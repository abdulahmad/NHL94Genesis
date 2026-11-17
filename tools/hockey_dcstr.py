#!/usr/bin/env python3
"""dc.w lines that hold text become dc.b with quoted text (same bytes)."""
import re, glob
def conv(bs):
    parts, cur = [], ''
    for b in bs:
        if 0x20 <= b < 0x7F and chr(b) not in "'\\;":
            cur += chr(b)
        else:
            if cur: parts.append("'%s'" % cur); cur = ''
            parts.append('$%02X' % b)
    if cur: parts.append("'%s'" % cur)
    return ','.join(parts)
n = 0
for f in sorted(glob.glob('src/segacd/hockey/gen_*.asm')):
    L = open(f).read().split('\n')
    for i, l in enumerate(L):
        m = re.match(r'^(\S*)\tdc\.w\t((?:\$[0-9A-F]{4},?)+)(\t;.*)?$', l)
        if not m: continue
        bs = bytes.fromhex(''.join(re.findall(r'\$([0-9A-F]{4})', m.group(2))))
        pr = sum(1 for b in bs if 0x20 <= b < 0x7F)
        if len(bs) >= 6 and pr * 10 >= len(bs) * 6:
            L[i] = '%s\tdc.b\t%s%s' % (m.group(1), conv(bs), m.group(3) or ''); n += 1
    open(f, 'w').write('\n'.join(L))
print(n)
