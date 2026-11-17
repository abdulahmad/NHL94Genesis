#!/usr/bin/env python3
"""dc.b lines of $xx bytes: printable runs of 4 or more become quoted text (same bytes)."""
import re, glob, sys
n = 0
for f in sorted(glob.glob('src/segacd/*/*.asm')):
    L = open(f).read().split('\n')
    for i, l in enumerate(L):
        m = re.match(r'^(\S*)\tdc\.b\t((?:\$[0-9A-F]{2},?)+)(\t;.*)?$', l)
        if not m: continue
        bs = [int(x, 16) for x in re.findall(r'\$([0-9A-F]{2})', m.group(2))]
        parts, cur, k = [], [], 0
        def flush(cur):
            if not cur: return
            if len(cur) >= 4:
                parts.append("'" + ''.join(chr(c) for c in cur) + "'")
            else:
                parts.extend('$%02X' % c for c in cur)
        run = []
        for b in bs:
            if 0x20 <= b < 0x7F and chr(b) not in "'\;":
                run.append(b)
            else:
                flush(run); run = []
                parts.append('$%02X' % b)
        flush(run)
        if any(p.startswith("'") for p in parts):
            L[i] = '%s\tdc.b\t%s%s' % (m.group(1), ','.join(parts), m.group(3) or ''); n += 1
    open(f, 'w').write('\n'.join(L))
print(n)
