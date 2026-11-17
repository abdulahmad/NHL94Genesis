#!/usr/bin/env python3
"""Turn global L<hex> labels into local .l<hex> labels when every use is in the same routine scope."""
import re, glob, sys
DIR = sys.argv[1]
_top = open(DIR + '.asm').read()
files = [DIR + '/' + m for m in re.findall(r'include\tsegacd\\\w+\\(\w+)\.asm', _top) if m != 'equates']
files = [f + '.asm' for f in files]
T = {f: open(f).read().split('\n') for f in files}
allsrc = {f: open(f).read().split('\n') for f in glob.glob('src/segacd/*.asm') + glob.glob(DIR + '/*.asm')}
Lre = re.compile(r'^L([0-9A-F]{4,6})\b')
conv = set()
def isglobal(line, conv):
    m = re.match(r'^([A-Za-z_]\w*)', line)
    if not m: return False
    n = m.group(1)
    return not (n in conv)
changed = True
while changed:
    changed = False
    for f in files:
        L = T[f]
        defs = {}
        for i, l in enumerate(L):
            m = Lre.match(l)
            if m and 'L' + m.group(1) not in conv: defs['L' + m.group(1)] = i
        for name, di in defs.items():
            refs = []
            ok = True
            for g, GL in allsrc.items():
                for k, l in enumerate(GL):
                    if re.search(r'\b%s\b' % name, l) and not (g == f and k == di):
                        if g != f: ok = False; break
                        refs.append(k)
                if not ok: break
            if not ok: continue
            good = True
            for k in refs:
                lo, hi = sorted((k, di))
                # scope boundaries: any global label strictly between, or at/after lo up to hi (def line itself excluded)
                for q in range(lo + 1 if k < di else lo + 1, hi + (0 if k < di else 0)):
                    if q != di and isglobal(L[q], conv): good = False; break
                if k > di:
                    pass
                if not good: break
            if good:
                conv.add(name); changed = True
print(len(conv), 'convertible')
for f in files:
    s = '\n'.join(T[f])
    for n in conv:
        s = re.sub(r'(?m)^%s\b' % n, '.l' + n[1:], s)
        s = re.sub(r'(?<![\w.])%s\b' % n, '.l' + n[1:], s)
    open(f, 'w').write(s)
