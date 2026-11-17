#!/usr/bin/env python3
"""Name disc-only Sub_<addr> routines by matching their full instruction shape to a cartridge routine that lies
between the same two paired neighbours (the disc keeps the cartridge order). Prints `Sub_X name` lines.
  python3 tools/hockey_subnames.py /tmp/nhl94.bin cdbin/HOCKEY.BIN /tmp/nhl94.lst /tmp/pairs.csv"""
import sys, re, glob, csv, collections
sys.path.insert(0, 'tools')
import hockey_pair as hp
rom = open(sys.argv[1], 'rb').read(); disc = open(sys.argv[2], 'rb').read()
labs = sorted(set(hp.routines_from_listing(sys.argv[3])))
labs = [(a, n) for a, n in labs if len(n) > 2 and n != 'incbin']
byname = {n: a for a, n in labs}
anch = []  # (disc_off, cart_addr)
for ln in open(sys.argv[4]):
    p = ln.strip().split(',')
    anch.append((int(p[1], 16), int(p[0], 16)))
for r in csv.DictReader(open('docs/segacd-handoff/name_map.csv')):
    if r['disc_file'] == 'HOCKEY.BIN' and r['name_94g'] in byname:
        anch.append((int(r['disc_addr'].lstrip('$'), 16), byname[r['name_94g']]))
anch = sorted(set(anch))
# keep a monotone chain
chain = []
for d, c in anch:
    if not chain or c > chain[-1][1]:
        chain.append((d, c))
cands = []
for i, (a, n) in enumerate(labs):
    nxt = labs[i + 1][0] if i + 1 < len(labs) else a + 2
    ins, _ = hp.decode(rom, a, nxt)
    t = [k for k, x in enumerate(ins) if x.mnemonic.split('.')[0] in ('rts', 'rte', 'jmp', 'bra')]
    if t: ins = ins[:t[0] + 1]
    cands.append((a, n, tuple(hp.shape(x) for x in ins)))
used = {n for _, n in labs if False}
subs = sorted({int(m, 16) for f in glob.glob('src/segacd/hockey/gen_*.asm') for m in re.findall(r'Sub_([0-9A-F]+)', open(f).read())})
LABS = sorted({int(m, 16) for f in glob.glob('src/segacd/hockey/gen_*.asm') for m in re.findall(r'^L([0-9A-F]{4,5})\b', open(f).read(), re.M)})
if len(sys.argv) > 6 and sys.argv[6] == 'L':
    subs = [x + 0x1B000 for x in LABS]
PFX = 'L' if len(sys.argv) > 6 and sys.argv[6] == 'L' else 'Sub_'
import bisect
dk = [d for d, _ in chain]
out = {}
for s in subs:
    off = s - 0x1B000
    ins, _ = hp.decode(disc, off, off + 400)
    t = [k for k, x in enumerate(ins) if x.mnemonic.split('.')[0] in ('rts', 'rte', 'jmp', 'bra')]
    if not t: continue
    sh = tuple(hp.shape(x) for x in ins[:t[0] + 1])
    j = bisect.bisect_right(dk, off)
    lo = chain[j - 1][1] if j > 0 else 0
    hi = chain[j][1] if j < len(chain) else 1 << 30
    m = [n for a, n, cs in cands if lo < a < hi and cs == sh]
    if len(m) == 1:
        out[s] = m[0]
for s, n in sorted(out.items()):
    print('Sub_%X %s' % (s, n))

if len(sys.argv) > 5 and sys.argv[5] == 'fuzzy':
    import difflib, os
    existing = set()
    for f in glob.glob('src/segacd/**/*.asm', recursive=True) + ['src/segacd/hockey.inc']:
        for m in re.finditer(r'^([A-Za-z_]\w*)', open(f, errors='replace').read(), re.M):
            existing.add(m.group(1))
    taken = set(out.values())
    res = {}
    for s_ in subs:
        if s_ in out:
            continue
        off = s_ - 0x1B000
        ins, _ = hp.decode(disc, off, off + 800)
        t = [k for k, x in enumerate(ins) if x.mnemonic.split('.')[0] in ('rts', 'rte', 'jmp', 'bra')]
        if not t: continue
        sh = [hp.shape(x) for x in ins[:t[0] + 1]]
        if len(sh) < (8 if PFX == 'L' else 4): continue
        sc = []
        for a, n, cs in cands:
            if abs(len(cs) - len(sh)) > max(3, len(sh) // 4): continue
            r = difflib.SequenceMatcher(None, list(cs), sh, autojunk=False).ratio()
            if r >= 0.9: sc.append((-r, a, n))
        sc.sort()
        res[s_] = sc
    for s_ in sorted(res):
        for r, a, n in res[s_]:
            if n in taken or n in existing or n.startswith('rts'):
                continue
            taken.add(n); out[s_] = n
            break
    for s_, n in sorted(out.items()):
        pass
    print('--- all')
    for s_, n in sorted(out.items()):
        print('%s%X %s' % (PFX, s_ - (0x1B000 if PFX == 'L' else 0), n))
