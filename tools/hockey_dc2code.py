#!/usr/bin/env python3
"""Turn dc.w lines that hold one whole jsr/jmp abs.l instruction back into code, naming the target from the
last build's listing. Usage: hockey_dc2code.py [revert_lines_file]"""
import re, glob, sys, os
lst = open('output/obj/hockey .lst', errors='replace').read().split('\n')
lab = {}
for l in lst:
    m = re.match(r'^([0-9A-F]{8}) {20,}([A-Za-z_]\w*)(\s|$)', l)
    if m and not m.group(2).startswith('.'):
        lab.setdefault(int(m.group(1), 16), m.group(2))
n = 0
for f in sorted(glob.glob('src/segacd/hockey/gen_*.asm')):
    L = open(f).read().split('\n')
    for i, l in enumerate(L):
        m = re.match(r'^(\S*)\t(?:dc\.w)\t\$(4EB9|4EF9),\$([0-9A-F]{4}),\$([0-9A-F]{4})(\t;.*)?$', l)
        if not m: continue
        a = int(m.group(3) + m.group(4), 16)
        mn = 'jsr' if m.group(2) == '4EB9' else 'jmp'
        nm = lab.get(a)
        tgt = '(%s).l' % nm if nm else '$%X.l' % a
        L[i] = '%s\t%s\t%s%s' % (m.group(1), mn, tgt, m.group(5) or '')
        n += 1
    open(f, 'w').write('\n'.join(L))
print('converted', n)
