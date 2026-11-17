#!/usr/bin/env python3
"""Regroup HOCKEY.BIN's address-chunk sources (gen_*.asm) into logical files named like the cartridge's.

  python3 tools/segcd_layout.py hockey [--dry]

Each routine / table that the cartridge also has (same global label) is owned by that cartridge file (src/*94.asm).
Placeholder-free disc-only labels continue the file of the label before them; a run of 1-2 labels between two runs of
the same file joins that file.  The sources are cut at global labels (with the comment lines above them), so local
labels keep their scope and the assembled bytes do not change.  A file that appears in several separate places gets
_2, _3 ... in address order.  hockey.asm is rewritten to include the new files.  Run `npm run build:segacd` after."""
import glob, os, re, sys
root = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'); os.chdir(root)
prog = sys.argv[1]; dry = '--dry' in sys.argv
top = open('src/segacd/%s.asm' % prog, encoding='latin1').read().split('\n')
cart = {}
for f in sorted(glob.glob('src/*.asm')):
    for l in open(f, encoding='latin1'):
        m = re.match(r'^([A-Za-z_]\w*)(?=[\s:]|$)', l)
        if m and not re.match(r'^\S+\s+(equ|=|macro)\b', l, re.I): cart.setdefault(m.group(1).lower(), os.path.basename(f))
GEN = re.compile(r'^\tinclude\tsegacd\\%s\\(gen_\w+)\.asm' % prog)
head = []; gens = []; tail = []
for l in top:
    m = GEN.match(l)
    if m: gens.append(m.group(1))
    elif not gens: head.append(l)
    else: tail.append(l)
lines = []
for g in gens:
    lines += open('src/segacd/%s/%s.asm' % (prog, g), encoding='latin1').read().split('\n')
LAB = re.compile(r'^([A-Za-z_]\w*)(?=[\s:]|$)')
units = []   # (start line, label)
for i, t in enumerate(lines):
    if t.startswith((' ', '\t', ';', '.')) or not t.strip(): continue
    m = LAB.match(t)
    if not m: continue
    rest = t[m.end():].split(';')[0].split()
    if rest[:1] and rest[0].lower() in ('equ', '=', 'macro'): continue
    s = i
    while s > 0 and lines[s - 1].startswith(';'): s -= 1
    if units and s <= units[-1][0]: continue
    units.append((s, m.group(1)))
own = []
last = None
for s, n in units:
    c = cart.get(n.lower())
    if c: last = c
    own.append(c or last)
first = next((c for c in own if c), None)
lead = 'cd%s.asm' % prog   # disc-only code and tables before the first cartridge routine
own = [c or lead for c in own]
# smoothing: short runs between two runs of one file join it
for _ in range(3):
    runs = []
    for k, c in enumerate(own):
        if runs and runs[-1][0] == c: runs[-1][2] = k
        else: runs.append([c, k, k])
    for r in range(1, len(runs) - 1):
        if runs[r - 1][0] == runs[r + 1][0] and runs[r][2] - runs[r][1] < 2:
            for k in range(runs[r][1], runs[r][2] + 1): own[k] = runs[r - 1][0]
runs = []
for k, c in enumerate(own):
    if runs and runs[-1][0] == c: runs[-1][2] = k
    else: runs.append([c, k, k])
count = {}; names = []
for c, a, b in runs:
    count[c] = count.get(c, 0) + 1
    nm = c if count[c] == 1 else c[:-4] + '_%d.asm' % count[c]
    names.append(nm)
print(prog, 'units', len(units), 'files', len(runs))
for (c, a, b), nm in zip(runs, names): print('  %-18s %5d units  first %s' % (nm, b - a + 1, units[a][1]))
if dry: sys.exit()
for g in gens: os.remove('src/segacd/%s/%s.asm' % (prog, g))
out = []
for k, ((c, a, b), nm) in enumerate(zip(runs, names)):
    s = 0 if k == 0 else units[a][0]
    e = len(lines) if k == len(runs) - 1 else units[runs[k + 1][1]][0]
    open('src/segacd/%s/%s' % (prog, nm), 'w', encoding='latin1').write('\n'.join(lines[s:e]))
    out.append('\tinclude\tsegacd\\%s\\%s' % (prog, nm))
open('src/segacd/%s.asm' % prog, 'w', encoding='latin1').write('\n'.join(head + out + tail))
