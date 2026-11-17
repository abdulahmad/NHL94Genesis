#!/usr/bin/env python3
"""Last resort names for CD-only entry points: L<hex> -> <routine>_<n>, Sub_<hex> -> <routine>Sub<n>, where
<routine> is the nearest named global label above (n counts per routine)."""
import re, glob, collections, sys
DIR = sys.argv[1]
_top = open(DIR + '.asm').read()
files = [DIR + '/' + m for m in re.findall(r'include\tsegacd\\\w+\\(\w+)\.asm', _top) if m != 'equates']
files = [f + '.asm' for f in files]
T = {f: open(f).read().split('\n') for f in files}
cnt = collections.Counter(); ren = {}; prev = None
existing = set()
for f in files:
    for l in T[f]:
        m = re.match(r'^([A-Za-z_]\w*)', l)
        if m: existing.add(m.group(1))
for f in files:
    for l in T[f]:
        m = re.match(r'^([A-Za-z_]\w*)', l)
        if not m: continue
        n = m.group(1)
        if re.fullmatch(r'L[0-9A-F]{4,6}', n) or n.startswith('Sub_'):
            if prev is None: continue
            kind = '_' if n[0] == 'L' else 'Sub'
            cnt[(prev, kind)] += 1
            nn = '%s%s%d' % (prev, kind, cnt[(prev, kind)])
            while nn in existing: cnt[(prev, kind)] += 1; nn = '%s%s%d' % (prev, kind, cnt[(prev, kind)])
            existing.add(nn); ren[n] = nn
        else:
            prev = n
print(len(ren))
for f in files:
    s = '\n'.join(T[f])
    s = re.sub(r'\b(L[0-9A-F]{4,6}|Sub_[0-9A-F]+)\b', lambda m: ren.get(m.group(1), m.group(1)), s)
    open(f, 'w').write(s)
