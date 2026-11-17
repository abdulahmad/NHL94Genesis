#!/usr/bin/env python3
"""Turn the code that sits inside HOCKEY.BIN assets (incbin blocks) into instructions.

  python3 tools/hockey_assetcode.py [--dry]      (needs a build: output/obj/hockey .lst)

The assets were cut from the data between the routines that pair with the cartridge, so code that nothing
paired still sat in them.  Code is found from the asset starts, `movem.l`/`link` prologues and the places after
an rts/rte, followed through branches and calls inside the assets (tools/segcd_flow.py).  Each asset that holds
code is rewritten: instructions (tagged ;@hex while fixing), zero runs as dcb.b, other data as dc.b, data blocks of
512 bytes or more stay assets.  Routine starts are `L<addr>` and branch targets `.l<addr>` until they are named.
Then `segcd_one.fixloop` puts every row that does not assemble to the disc bytes back to dc.w and strips the tags."""
import json, os, re, struct, sys, bisect, glob
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import segcd_flow as F
import emit_m68k as E
import segcd_one as S

root = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')
os.chdir(root)
base = 0x1B000
d = open('cdbin/HOCKEY.BIN', 'rb').read(); n = len(d)
apath = 'src/segacd/hockey/assets.json'
assets = json.load(open(apath))
F.INLINE[0x38946] = 8
SC = {0x38F6E, 0x38D8C, 0x39258, 0x39200}
inasset = bytearray(n)
for k, v in assets.items():
    for i in range(v['start'], v['start'] + v['size']): inasset[i] = 1
cov = bytearray(n)
for i in range(n):
    if not inasset[i]: cov[i] = 1
seeds = [i for i in range(0, n - 2, 2) if inasset[i] and d[i:i + 2] in (b'\x48\xe7', b'\x4e\x56')]
seeds += [v['start'] for v in assets.values()]
for i in range(0, n - 4, 2):
    if inasset[i] and d[i:i + 2] in (b'\x4e\x75', b'\x4e\x73') and inasset[i + 2]:
        j = i + 2
        while j < n - 2 and d[j:j + 2] == b'\x00\x00': j += 2
        seeds.append(j)
insns = {}; calls = set(); labs = set()
F.find_code_seeded(d, base, seeds, cov, insns, SC)
F.sweep(d, base, cov, insns, calls, labs, SC)
decode = {p: F.decode_at(d, p, base) for p in insns}
# existing labels (global) from the last build listing
labels = {}
for l in open('output/obj/hockey .lst', errors='replace').read().replace('\r', '').split('\n'):
    m = re.match(r'^([0-9A-F]{8}) ((?:[0-9A-F]{2,4} ?)*)\s+([A-Za-z_]\w*):?\t', l)
    if m and m.group(3) not in ('dc', 'dcb'):
        labels.setdefault(int(m.group(1), 16), m.group(3))
# entries: calls, run starts, jsr/bsr targets inside code
entries = set(calls)
prev = None
for p in sorted(decode):
    if prev is None or p != prev: entries.add(p)
    prev = p + decode[p].size
for p, g in decode.items():
    mn = g.mnemonic.split('.')[0]
    m = re.search(r'\$([0-9a-f]+)', g.op_str)
    if mn in ('bsr', 'jsr', 'jmp') and m:
        t = int(m.group(1), 16) - base
        if 0 <= t < n and (mn != 'jmp' or '(' not in g.op_str.replace('(pc)', '')) and t in decode: entries.add(t)
ent_sorted = sorted(entries)
def func_of(o):
    k = bisect.bisect_right(ent_sorted, o)
    return ent_sorted[k - 1] if k else None
newlab = {}
def NAME(ad):
    if ad in labels: return labels[ad]
    return 'L%X' % ad
loc = set()
def tgt(o_from, t_addr):
    o = t_addr - base
    if t_addr in labels: return labels[t_addr]
    if 0 <= o < n and o in decode and func_of(o) == func_of(o_from) and o not in entries:
        loc.add(o); return '.l%X' % o
    if 0 <= o < n and o in decode:
        newlab[t_addr] = 1; return 'L%X' % t_addr
    # data: label on the nearest earlier code/data label
    return None
# which assets hold code
code_assets = {}
for k, v in assets.items():
    if any(v['start'] <= p < v['start'] + v['size'] for p in decode): code_assets[k] = v
print('assets with code:', len(code_assets), 'instructions:', len(decode))
if '--dry' in sys.argv: sys.exit()
# pc-relative targets that fall in data need a data label
pcdata = set()
for p, g in decode.items():
    if '(pc)' in g.op_str:
        m = re.search(r'\$([0-9a-f]+)\(pc\)', g.op_str)
        if m:
            t = int(m.group(1), 16)
            if 0 <= t - base < n and (t - base) not in decode: pcdata.add(t)

def gen(k, v):
    s, e = v['start'], v['start'] + v['size']
    lines = []; new_assets = {}
    o = s
    bps = {a - base for a in pcdata if s <= a - base < e} | {x for x in entries if s <= x < e}
    while o < e:
        if o in decode:
            g = decode[o]; ad = base + o
            lab = ''
            if ad in labels: lab = labels[ad]
            elif o in entries: lab = 'L%X' % ad; labels[ad] = lab
            elif o in loc: lab = '.l%X' % o
            text = E.snasm_op(g, {}, base)
            kind = g.mnemonic.split('.')[0]
            raw = bytes(g.bytes)
            m = re.search(r'\$([0-9a-f]+)', g.op_str)
            if m and (kind in E.BRANCH or '(pc)' in g.op_str or (kind in ('jsr', 'jmp', 'bsr') and len(raw) in (4, 6))):
                t = int(m.group(1), 16)
                nm = tgt(o, t) if base <= t < base + n else None
                if nm is None and base <= t < base + n and ('(pc)' in g.op_str or kind in E.BRANCH):
                    nm = 'L%X' % t; pcdata.add(t)
                if nm:
                    text = E.snasm_op(g, {t: nm}, base)
                    if kind in ('jsr', 'jmp') and '(pc)' not in g.op_str:
                        text = text.replace(nm + '.l', '(' + nm + ').l') if (nm + '.l') in text else text
            mn2 = g.mnemonic
            if kind in ('btst', 'bclr', 'bset', 'bchg') and re.search(r',d[0-7]$', text.replace(' ', '')): mn2 = kind
            if kind == 'link': mn2 = 'link'
            if kind == 'btst' and mn2 == 'btst.l' and re.search(r',\(a[0-7]\)$', text.replace(' ', '')): mn2 = 'btst'
            if kind == 'moveq':
                mm = re.match(r'#\$([0-9A-F]+),(.*)', text)
                if mm and int(mm.group(1), 16) >= 0x80: text = '#%d,%s' % (int(mm.group(1), 16) - 256, mm.group(2))
            lines.append('%s\t%s\t%s\t;@%s' % (lab, mn2, text, raw.hex()) if text else '%s\t%s\t;@%s' % (lab, mn2, raw.hex()))
            o += g.size
            continue
        j = o + 1
        while j < e and j not in decode and j not in bps: j += 1
        blob = d[o:j]
        ad = base + o
        lab = labels.get(ad) or ('L%X' % ad if (j - o) and ad in pcdata else '')
        i = 0; L = len(blob)
        while i < L:
            if blob[i] == 0:
                q = i
                while q < L and blob[q] == 0: q += 1
                if q - i >= 8:
                    lines.append('%s\tdcb.b\t$%X,0' % (lab if i == 0 else '', q - i)); i = q; continue
            q = i
            while q < L:
                if blob[q] == 0:
                    r = q
                    while r < L and blob[r] == 0: r += 1
                    if r - q >= 8: break
                    q = r
                else: q += 1
            seg = blob[i:q]
            if len(seg) >= 512:
                fn = 'hockey_%05X.bin' % (o + i)
                new_assets[fn] = dict(start=o + i, size=len(seg))
                lines.append('%s\tincbin\t..\\Extracted\\SegaCD\\HOCKEY\\%s' % (lab if i == 0 else '', fn))
            else:
                for c in range(0, len(seg), 16):
                    ch = seg[c:c + 16]
                    asc = ''.join(chr(x) if 32 <= x < 127 and chr(x) not in "'\;" else '.' for x in ch)
                    lines.append('%s\tdc.b\t%s\t; %s' % (lab if (i == 0 and c == 0) else '', ','.join('$%02X' % x for x in ch), asc))
            i = q
        o = j
    return lines, new_assets

inc_of = {}
for f in glob.glob('src/segacd/hockey/*.asm'):
    for i, l in enumerate(open(f).read().split('\n')):
        m = re.search(r'incbin\t\.\.\\Extracted\\SegaCD\\HOCKEY\\(hockey_\w+\.bin)', l)
        if m: inc_of[m.group(1)] = (f, i)
touched = {}
newassets = {}
for k, v in code_assets.items():
    lines, na = gen(k, v)
    f, i = inc_of[k]
    touched.setdefault(f, []).append((i, lines))
    del assets[k]; newassets.update(na)
assets.update(newassets)
for f, ch in touched.items():
    L = open(f).read().split('\n')
    for i, lines in sorted(ch, reverse=True):
        L[i:i + 1] = lines
    open(f, 'w').write('\n'.join(L))
json.dump(dict(sorted(assets.items(), key=lambda kv: kv[1]['start'])), open(apath, 'w'), indent=1)
os.system('node tools/extractAssetsSegaCD.js >/dev/null')
# fix loop
incs = [l.split()[1].replace('\\', '/') for l in open('src/segacd/hockey.asm') if l.strip().startswith('include') and 'macros' not in l and l.split()[1].endswith('.asm')]
parts = []
for x in incs:
    nm = os.path.basename(x)[:-4]
    path = 'src/segacd/hockey/%s.asm' % nm
    if os.path.exists(path) and path in touched:
        parts.append((0, 0, 'gen', nm))
cfg = dict(disc='cdbin/HOCKEY.BIN', base=base, name='hockey', oaq='-')
ok = S.fixloop(cfg, parts, 'src/segacd/hockey', d)
print('converged' if ok else 'FAILED')
if ok:
    for a, b, kind, nm in parts:
        p0 = 'src/segacd/hockey/%s.asm' % nm
        t0 = open(p0).read().split('\n')
        open(p0, 'w').write('\n'.join(re.sub(r'\t;@[0-9a-f]*\s*$', '', l) for l in t0))
