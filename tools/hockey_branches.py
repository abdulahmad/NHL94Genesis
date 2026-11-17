#!/usr/bin/env python3
"""Turn HOCKEY branch rows left as dc.w (and *+N branches) into labelled branches.

  python3 tools/hockey_branches.py       (needs a build: output/obj/hockey .lst)

A branch row decodes with capstone; the target address gets a label: an existing one, a local `.l<addr>` when
the branch and the target are in the same routine (same previous global label), else a global `L<addr>`.
A global label splits the scope of the locals after it, so a local that is then used from another scope
becomes global too.  The result is checked by the build (bytes must stay identical); rows that still do not
assemble are put back to dc.w by the caller (run segcd_one.fixloop style: see main)."""
import os, re, sys, bisect, glob
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from capstone import Cs, CS_ARCH_M68K, CS_MODE_M68K_000
root = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'); os.chdir(root)
base = 0x1B000
md = Cs(CS_ARCH_M68K, CS_MODE_M68K_000)
inc = [l.split()[1].replace('\\', '/') for l in open('src/segacd/hockey.asm') if l.strip().startswith('include') and 'macros' not in l and l.split()[1].endswith('.asm')]
files = ['src/' + i for i in inc]
L = []   # [file, text]
for f in files:
    for t in open(f).read().split('\n'): L.append([f, t])
# align listing rows with source lines
rows = []
for l in open('output/obj/hockey .lst', errors='replace').read().replace('\r', '').split('\n'):
    if re.match(r'^[0-9A-F]{8} ', l): rows.append((int(l[:8], 16), l[36:] if len(l) > 36 else ''))
norm = lambda s: re.sub(r'\s+', '', s)
addr = [None] * len(L)
j = 0
first = next(norm(t) for f, t in L if norm(t))
j = next(k for k, r in enumerate(rows) if norm(r[1]) == first)
for i, (f, t) in enumerate(L):
    nt = norm(t)
    k = j
    while k < len(rows) and norm(rows[k][1]) != nt and k - j < 80: k += 1
    if k < len(rows) and norm(rows[k][1]) == nt:
        addr[i] = rows[k][0]; j = k + 1
print('aligned', sum(a is not None for a in addr), 'of', len(L))
BRX = re.compile(r'^([^\t]*)\t(?:(dc\.w)\t([^;]*?)|(b[a-z]{1,2}|dbra|dbf|dbne|dbeq)(?:\.[sbw])?\t\*([+-]\d+))\s*(;.*)?$')
LABEL = re.compile(r'^(\.?[A-Za-z_]\w*):?(?=\s|$)')
def decode_branch(words):
    try: by = b''.join(int(w.strip().replace('$', ''), 16).to_bytes(2, 'big') for w in words.split(','))
    except Exception: return None
    ins = list(md.disasm(by, 0))
    if len(ins) != 1 or ins[0].size != len(by): return None
    mn = ins[0].mnemonic.split('.')[0]
    if not (mn.startswith('b') or mn.startswith('db')) or mn in ('btst', 'bchg', 'bclr', 'bset'): return None
    m = re.search(r'\$([0-9a-f]+)', ins[0].op_str)
    if not m: return None
    return mn, ins[0].mnemonic, int(m.group(1), 16), len(by)
refs = []   # (line index, mnemonic, target runtime addr, size, kind)
for i, (f, t) in enumerate(L):
    m = BRX.match(t)
    if not m or addr[i] is None: continue
    if m.group(2):
        r = decode_branch(m.group(3))
        if not r: continue
        mn, full, rel, sz = r
        # capstone decoded at address 0: the printed target is relative to 0
        if rel >= 0x80000000: rel -= 1 << 32
        tgt = addr[i] + rel
        if tgt == addr[i] or tgt % 2: continue
        refs.append((i, mn, full, tgt, sz))
    else:
        mn = m.group(4); n = int(m.group(5))
        tgt = addr[i] + n
        refs.append((i, mn, m.group(0).split('\t')[1], tgt, 0))
print('branch rows', len(refs))
# line index by address (first line with code/data at that address that has bytes)
by_addr = {}
for i, a in enumerate(addr):
    if a is None: continue
    t = L[i][1]
    body = LABEL.sub('', t, count=1) if LABEL.match(t) and not t.startswith(('\t', ' ')) else t
    if body.strip() and not body.strip().startswith(';'): by_addr.setdefault(a, i)
# global label positions (by line index), local label defs
glob_idx = []   # sorted line indices of global labels
for i, (f, t) in enumerate(L):
    m = LABEL.match(t) if not t.startswith(('\t', ' ', ';')) else None
    if m and not m.group(1).startswith('.') and 'equ' not in t.split()[1:2]: glob_idx.append(i)
def scope(i):
    k = bisect.bisect_right(glob_idx, i); return glob_idx[k - 1] if k else -1
labdef = {}   # name -> line index (locals keyed with scope)
for i, (f, t) in enumerate(L):
    m = LABEL.match(t) if not t.startswith(('\t', ' ', ';')) else None
    if m and not m.group(1).startswith('.'): labdef[m.group(1)] = i
label_at = {}
for i, (f, t) in enumerate(L):
    m = LABEL.match(t) if not t.startswith(('\t', ' ', ';')) else None
    if m and addr[i] is not None: label_at.setdefault(addr[i], []).append((m.group(1), i))
need_global = set(); need_local = {}   # addr -> True
changed = True
for r in refs:
    i, mn, full, tgt, sz = r
    ti = by_addr.get(tgt)
    if ti is None: continue
    have = label_at.get(tgt, [])
    ok = False
    for nm, li in have:
        if not nm.startswith('.') or scope(li) == scope(i): ok = True
    if ok: continue
    if scope(ti) == scope(i) and scope(ti) != -1: need_local[tgt] = True
    else: need_global.add(tgt)
print('new globals', len(need_global), 'new locals', len(need_local))
out = [t for f, t in L]
# labels: insert on the target line
def put_label(i, name):
    t = out[i]
    if t.startswith(('\t', ' ')): out[i] = name + t
    else: out[i] = name + '\n' + t
def name_for(tgt, i):
    for nm, li in label_at.get(tgt, []):
        if not nm.startswith('.') or scope(li) == scope(i): return nm
    if tgt in need_global: return 'L%X' % tgt
    if tgt in need_local: return '.l%X' % tgt
    return None
done = 0
for r in refs:
    i, mn, full, tgt, sz = r
    nm = name_for(tgt, i)
    if not nm: continue
    t = L[i][1]; m = BRX.match(t)
    lab = m.group(1); cm = m.group(6) or ''
    if sz == 0:
        ins = re.sub(r'\*[+-]\d+', nm, m.group(0).split('\t')[1] + '\t' + t.split('\t')[2].split(';')[0].strip() if False else '')
    # build: mnemonic from capstone ('bne.b' -> size from bytes)
    mnem = full
    if m.group(2):
        suffix = '.s' if sz == 2 else '.w'
        if mn.startswith('db'): suffix = ''
        mnem = mn + suffix
        out[i] = (lab + '\t' + mnem + '\t' + (('d%s,' % re.search(r'd(\d)', full).group(1)) if False else '') + nm + ('\t' + cm if cm else '')) if not mn.startswith('db') else None
        if mn.startswith('db'):
            dreg = None
            by = b''.join(int(w.strip().replace('$', ''), 16).to_bytes(2, 'big') for w in m.group(3).split(','))
            dreg = by[1] & 7
            out[i] = lab + '\t' + mn + '\td%d,%s' % (dreg, nm) + ('\t' + cm if cm else '')
    else:
        # *+N branch: just replace the operand
        out[i] = re.sub(r'\*[+-]\d+', nm, t)
    done += 1
print('converted', done)
for tg in need_global:
    put_label(by_addr[tg], 'L%X' % tg)
for tg in need_local:
    if tg in need_global: continue
    put_label(by_addr[tg], '.l%X' % tg)

per = []   # (file, [lines]) in include order, multi-line entries flattened
cur = None
for k, (f, t) in enumerate(L):
    if cur is None or cur[0] != f:
        cur = (f, []); per.append(cur)
    cur[1].extend(out[k].split('\n'))
flat = [(f, l) for f, ls in per for l in ls]
LOC = re.compile(r'(?<![A-Za-z0-9_])(\.l[0-9A-Fa-f]+)\b')
for rnd in range(20):
    gl = [i for i, (f, l) in enumerate(flat) if l and not l.startswith(('\t', ' ', ';', '.')) and LABEL.match(l) and 'equ' not in l.split()[1:2]]
    def sc(i):
        k = bisect.bisect_right(gl, i); return gl[k - 1] if k else -1
    defs_ = {}
    for i, (f, l) in enumerate(flat):
        m = re.match(r'^(\.l[0-9A-Fa-f]+)\b', l)
        if m: defs_.setdefault(m.group(1), []).append(sc(i))
    bad = set()
    for i, (f, l) in enumerate(flat):
        code = l.split(';')[0]
        body = re.sub(r'^(\.l[0-9A-Fa-f]+)', '', code)
        for n in LOC.findall(body):
            if n in defs_ and sc(i) not in defs_[n]: bad.add(n)
    if not bad: break
    for n in bad:
        g = 'L' + n[2:].upper()
        for i, (f, l) in enumerate(flat):
            code, _, cm = l.partition(';')
            code2 = re.sub(r'(?<![A-Za-z0-9_])' + re.escape(n) + r'\b', g, code)
            if code2 != code: flat[i] = (f, code2 + (';' + cm if cm else ''))
    print('scope fix round', rnd, len(bad))
res = {}
for f, l in flat: res.setdefault(f, []).append(l)
for f, ls in res.items(): open(f, 'w').write('\n'.join(ls))
