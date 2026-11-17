#!/usr/bin/env python3
"""Turn runs of dc rows in the MAIN / PLAYER / STARTER sources that decode cleanly as code into instructions.

  python3 tools/segcd_dc2code.py main|player|starter [--min N]

A run is the dc.b / dc.w rows from a label (or the first dc row) up to the next row of another kind or the next
label.  It is converted only when every byte decodes to an instruction (zero padding allowed at the end) and the
last instruction is rts / rte / bra / jmp, and every branch inside the run lands inside the run.  Rows are tagged
;@hex and segcd_one.fixloop puts back as dc.w whatever does not assemble, then strips the tags.  Names of
branch targets inside a run: `.l<hex>`.  Run `tools/segcd_localnames.py` afterwards for roles."""
import os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import segcd_flow as F, emit_m68k as E, segcd_one as S
root = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'); os.chdir(root)
prog = sys.argv[1]; LOOSE = '--loose' in sys.argv; MIN = int(sys.argv[sys.argv.index('--min') + 1]) if '--min' in sys.argv else 6
cfg = S.CFG[prog.upper()] if prog != 'hockey' else dict(disc='cdbin/HOCKEY.BIN', base=0x1B000, name='hockey', oaq='-');  base = cfg['base']; d = open(cfg['disc'], 'rb').read()
ddir = 'src/segacd/' + prog
errs, txt = S.assemble(cfg)
rows = []
for l in open('/tmp/new/%s .lst' % prog, errors='replace').read().replace('\r', '').split('\n'):
    if re.match(r'^[0-9A-F]{8} ', l): rows.append((int(l[:8], 16), l[36:] if len(l) > 36 else ''))
norm = lambda s: re.sub(r'\s+', '', s)
DC = re.compile(r'^(?:([A-Za-z_.]\w*)[^\t]*)?\t(?:dc\.[bwl]|dcb\.[bwl])\t')
glab = {}
for l in open('/tmp/new/%s .lst' % prog, errors='replace').read().replace('\r', '').split('\n'):
    m_ = re.match(r'^([0-9A-F]{8}) (?:[0-9A-F]{2,4} ?)*[+ ]+([A-Za-z_]\w*)\t', l)
    if m_ and not m_.group(2).startswith(('dc', 'incbin')): glab.setdefault(int(m_.group(1), 16), m_.group(2))
files = sorted(f for f in os.listdir(ddir) if f.endswith('.asm') and f not in ('equates.asm', 'teamdata.asm'))
changed = 0
RUNS = []; PEND = {}
for f in files:
    L = open(os.path.join(ddir, f), encoding='latin1').read().split('\n')
    # align this file's lines with the listing
    addr = [None] * len(L)
    j = next((k for k, r in enumerate(rows) if r[1].strip().startswith('include') and r[1].strip().endswith('\\' + f)), 0)
    for n, t in enumerate(L):
        nt = norm(t)
        if not nt: continue
        k = j
        while k < len(rows) and norm(rows[k][1]) != nt and k - j < 60: k += 1
        if k < len(rows) and norm(rows[k][1]) == nt: addr[n] = rows[k][0]; j = k + 1
    out = []; n = 0
    while n < len(L):
        t = L[n]
        m = DC.match(t)
        if m and addr[n] is not None and not t.lstrip().startswith('.') or (m and addr[n] is not None and t.startswith('.')):
            e = n + 1
            while e < len(L) and DC.match(L[e]) and not re.match(r'^[A-Za-z_.]', L[e]) and addr[e] is not None: e += 1
            a0 = addr[n]; nx = next((addr[k] for k in range(e, len(L)) if addr[k] is not None and addr[k] != a0), None)
            if nx is None or nx - a0 < (4 if LOOSE else MIN) or a0 % 2: out.extend(L[n:e]); n = e; continue
            o0, o1 = a0 - base, nx - base
            insns = []; o = o0
            while o < o1:
                g = F.decode_at(d, o, base)
                if g is None or o + g.size > o1: insns = None; break
                if d[o:o + 2] == b'\0\0' and all(x == 0 for x in d[o:o1]): break
                insns.append((o, g)); o += g.size
            ok = bool(insns) and insns[-1][1].mnemonic.split('.')[0] in ('rts', 'rte', 'bra', 'jmp') and (o == o1 or all(x == 0 for x in d[o:o1]))
            if not ok and LOOSE and insns and o == o1:
                def mnem(tx):
                    q = tx.split(';')[0].split('\t')
                    q = [x for x in q if x.strip()]
                    if tx[:1] not in ' \t' and tx.strip(): q = q[1:]
                    return q[0].strip().lower().split('.')[0] if q else ''
                pm = mnem(L[n - 1]) if n else ''; nm_ = mnem(L[e]) if e < len(L) else ''
                term = ('rts', 'rte', 'bra', 'jmp', 'dc', 'dcb', 'incbin', '')
                words = [p_ for p_, g in insns]
                zero = any(d[p_:p_ + 2] == b'\0\0' for p_ in words)
                kinds = {g.mnemonic.split('.')[0] for p_, g in insns}
                if pm not in term + ('jsr', 'bsr') and nm_ not in term and not zero: ok = True          # code on both sides
                elif False and o1 - o0 >= 12 and not zero and kinds & {'rts', 'bra', 'bsr', 'jsr', 'bne', 'beq', 'dbra', 'rte'} and len(kinds) >= 4 and pm in term: ok = True
            if ok:
                ends = insns[-1][0] + insns[-1][1].size
                starts = {p for p, _ in insns}
                for p, g in insns:
                    mn = g.mnemonic.split('.')[0]
                    mm = re.search(r'\$([0-9a-f]+)', g.op_str)
                    if mn in E.BRANCH and mm and mn != 'jmp':
                        t_ = int(mm.group(1), 16) - base
                        if not (0 <= t_ < len(d)): ok = False
            if not ok: out.extend(L[n:e]); n = e; continue
            lab = (t.split('\t')[0] if not t.startswith('\t') else '')
            newl = []; out_real = out; out = newl
            tg = set()
            for p, g in insns:
                mn = g.mnemonic.split('.')[0]; mm = re.search(r'\$([0-9a-f]+)', g.op_str)
                if mn in E.BRANCH and mm and mn != 'jmp' and o0 <= int(mm.group(1), 16) - base < ends: tg.add(int(mm.group(1), 16) - base)
            for p, g in insns:
                ad = base + p
                l_ = '.l%X' % p if p in tg else ''
                if p == o0: l_ = lab or l_
                mt = re.search(r'\$([0-9a-f]+)', g.op_str); mp = {}
                if mt and g.mnemonic.split('.')[0] in E.BRANCH and g.mnemonic.split('.')[0] != 'jmp':
                    t_ = int(mt.group(1), 16)
                    if t_ - base in tg: mp[t_] = '.l%X' % (t_ - base)
                    elif t_ in glab: mp[t_] = glab[t_]
                text = E.snasm_op(g, mp, base)
                mn2 = g.mnemonic; kind = mn2.split('.')[0]
                if kind in ('btst', 'bclr', 'bset', 'bchg') and re.search(r',d[0-7]$', text.replace(' ', '')): mn2 = kind
                if kind == 'btst' and mn2 == 'btst.l' and re.search(r',\(a[0-7]\)$', text.replace(' ', '')): mn2 = 'btst'
                if kind == 'moveq':
                    mm = re.match(r'#\$([0-9A-F]+),(.*)', text)
                    if mm and int(mm.group(1), 16) >= 0x80: text = '#%d,%s' % (int(mm.group(1), 16) - 256, mm.group(2))
                out.append('%s\t%s\t%s\t;@%s' % (l_, mn2, text, bytes(g.bytes).hex()))
            if ends < o1: out.append('\tdcb.b\t$%X,0' % (o1 - ends))
            out = out_real; RUNS.append((newl, L[n:e], o0, o1)); out.append(('RUN', len(RUNS) - 1)); changed += 1; n = e; continue
        out.append(t); n += 1
    PEND[f] = out
print('runs converted', changed)
def render(bad):
    for f, out in PEND.items():
        lines = []
        for x in out:
            if isinstance(x, tuple): lines.extend(RUNS[x[1]][1] if x[1] in bad else RUNS[x[1]][0])
            else: lines.append(x)
        open(os.path.join(ddir, f), 'w', encoding='latin1').write('\n'.join(lines))
bad = set()
parts = [(0, 0, 'gen', f[:-4]) for f in files]
for rnd in range(40):
    render(bad)
    ok = S.fixloop(cfg, parts, ddir, d)
    if ok: break
    a = '/tmp/new/%s.bin' % prog
    ob = open(a, 'rb').read() if os.path.exists(a) else b''
    k = next((i for i in range(min(len(ob), len(d))) if ob[i] != d[i]), None)
    hit = next((i for i, r in enumerate(RUNS) if k is not None and r[2] <= k < r[3] and i not in bad), None)
    if hit is None: break
    bad.add(hit); print('revert run', hit, hex(RUNS[hit][2] + base))
print('reverted', len(bad))
for f in files:
    p = os.path.join(ddir, f); t0 = open(p, encoding='latin1').read().split('\n')
    open(p, 'w', encoding='latin1').write('\n'.join(re.sub(r'\t;@[0-9a-f]*\s*$', '', l) for l in t0))
print('fixloop', ok)
