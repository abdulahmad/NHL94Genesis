#!/usr/bin/env python3
"""segcd_shared.py: how many routines of the Sega CD HOCKEY source are the same text as their cartridge twin.
Compares each routine's code (comments, spacing, address-size suffixes and branch sizes dropped; local labels kept).
  python3 tools/segcd_shared.py [REPO] [--list]"""
import re, glob, os, sys
root = next((a for a in sys.argv[1:] if not a.startswith('--')), '.')
def norm(l):
    l = l.split(';')[0].rstrip()
    if not l.strip(): return None
    m = re.match(r'^([A-Za-z_]\w*)\s*(.*)$', l) if l[0] not in ' \t' else None
    lab = ''
    if m: lab, l = m.group(1), m.group(2)
    elif l[0] == '.': 
        m = re.match(r'^(\.\w+)\s*(.*)$', l); lab, l = m.group(1), m.group(2)
    t = l.split(None, 1)
    if not t: return ('L', lab)
    op = re.sub(r'\.(s|b|w|l)$', '', t[0].lower()) if re.match(r'^(b|j)', t[0].lower()) and not re.match(r'^b(set|clr|tst|chg)', t[0].lower()) else t[0].lower()
    args = re.sub(r'\.(w|l)\b', '', t[1].replace(' ', '')) if len(t) > 1 else ''
    return (lab if lab.startswith('.') else '', op, args)
def scan(files):
    R = {}
    for f in files:
        cur = None
        for l in open(f, encoding='latin-1'):
            m = re.match(r'^([A-Za-z_]\w*)', l)
            if m and l[0] not in ' \t;': cur = m.group(1); R.setdefault(cur, [])
            n = norm(l)
            if cur and n and not (n[0] == 'L'): 
                if n[1:] and not l.startswith(' ') and l[0] != '\t' and l[0] != '.' and False: pass
                R[cur].append(n)
    return R
c = scan(glob.glob(os.path.join(root, 'src/*94.asm'))); d = scan(glob.glob(os.path.join(root, 'src/segacd/hockey/*.asm')))
same = [r for r in c if r in d and len(c[r]) >= 2 and c[r] == d[r]]
diff = [r for r in c if r in d and len(c[r]) >= 2 and c[r] != d[r]]
ni = sum(len(c[r]) for r in same)
print(f'{len(same)} routines have the same text in cartridge and disc ({ni} instructions); {len(diff)} paired routines differ')
if '--list' in sys.argv:
    for r in sorted(same): print(' ', r, len(c[r]))
if '--why' in sys.argv:
    import collections
    kinds = collections.Counter(); ex = {}
    for r in diff:
        a, b = c[r], d[r]
        if [x[1] for x in a] != [x[1] for x in b]: kinds['opcodes differ'] += 1; continue
        for x, y in zip(a, b):
            if x != y:
                k = 'labels' if x[0] != y[0] else 'operands'
                kinds[k] += 1; ex.setdefault(k, []).append((r, x, y)); break
    print(kinds)
    for k, v in ex.items():
        for e in v[:12]: print(k, e)
