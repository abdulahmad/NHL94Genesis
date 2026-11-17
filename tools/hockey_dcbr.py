#!/usr/bin/env python3
"""Single-word dc.w short branches ($6xxx) become bra.s/bcc.s with the target label from the last listing."""
import re, glob
COND = {0: 'bra', 1: 'bsr', 2: 'bhi', 3: 'bls', 4: 'bcc', 5: 'bcs', 6: 'bne', 7: 'beq', 8: 'bvc', 9: 'bvs', 10: 'bpl', 11: 'bmi', 12: 'bge', 13: 'blt', 14: 'bgt', 15: 'ble'}
lst = open('output/obj/hockey .lst', errors='replace').read().split('\n')
labat = {}
rows = []
for l in lst:
    m = re.match(r'^([0-9A-F]{8}) {20,}([.A-Za-z_]\w*)(\s|$)', l)
    if m:
        labat.setdefault(int(m.group(1), 16), m.group(2)); continue
    m = re.match(r'^([0-9A-F]{8}) ([0-9A-F]{4})\s+\t?\s*dc\.w\s+\$(6[0-9A-F]{3})\s*(;.*)?$', l)
    if m: rows.append((int(m.group(1), 16), int(m.group(3), 16)))
files = sorted(glob.glob('src/segacd/hockey/gen_*.asm'))
k = 0; n = 0
for f in files:
    L = open(f).read().split('\n')
    for i, l in enumerate(L):
        m = re.match(r'^(\S*)\tdc\.w\t\$(6[0-9A-F]{3})(\t;.*)?$', l)
        if not m: continue
        a, w = rows[k]; k += 1
        assert w == int(m.group(2), 16), (f, i, hex(w))
        d = w & 0xFF; c = (w >> 8) & 15
        if d in (0, 0xFF) or c == 1: continue
        if d >= 0x80: d -= 256
        t = a + 2 + d
        nm = labat.get(t) or ('*%+d' % (d + 2) if d + 2 >= 0 else '*%d' % (d + 2))
        L[i] = '%s\t%s.s\t%s%s' % (m.group(1), COND[c], nm, m.group(3) or ''); n += 1
    open(f, 'w').write('\n'.join(L))
print('rows', len(rows), 'used', k, 'converted', n)
