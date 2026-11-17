#!/usr/bin/env python3
"""After hockey_dc2code2: build, revert lines that fail to assemble or change bytes (restoring the dc.w line from
git HEAD), repeat until the binary equals the disc."""
import re, subprocess, sys, glob, os
def sh(c): return subprocess.run(c, shell=True, capture_output=True, text=True)
def orig(f):
    return subprocess.run(['git', 'show', 'HEAD:' + f], capture_output=True, text=True).stdout.split('\n')
for rnd in range(12):
    r = sh('npm run build:segacd 2>&1')
    out = r.stdout
    bad = {}
    for m in re.finditer(r'SRC\\SEGACD\\HOCKEY\\(GEN_\w+)\.ASM\((\d+)', out):
        bad.setdefault(m.group(1), set()).add(int(m.group(2)))
    if bad:
        for g, ls in bad.items():
            f = glob.glob('src/segacd/hockey/' + g.lower() + '.asm') or glob.glob('src/segacd/hockey/gen_' + g[4:] + '.asm')
            f = f[0]
            L = open(f).read().split('\n'); O = orig(f)
            for n in ls:
                L[n - 1] = O[n - 1]
            open(f, 'w').write('\n'.join(L))
        print('round', rnd, 'reverted', sum(len(v) for v in bad.values())); continue
    if 'MATCH' in out and 'MISMATCH' not in out:
        print('MATCH'); break
    a = open('output/segacd/hockey.bin', 'rb').read(); b = open('cdbin/HOCKEY.BIN', 'rb').read()
    d = [i for i in range(min(len(a), len(b))) if a[i] != b[i]]
    lst = open('output/obj/hockey .lst', errors='replace').read().split('\n')
    rows = []
    for l in lst:
        m = re.match(r'^([0-9A-F]{8}) ([0-9A-F ]+?)\s+\t?(.*)$', l)
        if m and re.match(r'^[0-9A-F ]+$', m.group(2)):
            rows.append((int(m.group(1), 16), len(m.group(2).replace(' ', '')) // 2, m.group(3)))
    texts = set()
    for off in d:
        ad = off + 0x1B000
        for a0, ln, tx in rows:
            if a0 <= ad < a0 + ln:
                texts.add(re.sub(r'\s*;.*', '', tx).strip()); break
    print('round', rnd, 'diff bytes', len(d), 'texts', len(texts))
    cnt = 0
    for f in glob.glob('src/segacd/hockey/gen_*.asm'):
        L = open(f).read().split('\n'); O = orig(f)
        for i, l in enumerate(L):
            if l != O[i] and re.sub(r'\s*;.*', '', re.sub(r'^\S*\t', '', l)).strip() in {re.sub(r'^\S*\s', '', t) for t in texts} | texts:
                L[i] = O[i]; cnt += 1
        open(f, 'w').write('\n'.join(L))
    print('reverted by text', cnt)
    if not cnt: break
