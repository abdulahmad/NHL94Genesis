#!/usr/bin/env python3
"""A function whose `link` word stayed dc.w has its first label on the dc.w line and a second label (often the
Sierra C name tag) on the next instruction. Merge them: the function keeps one label, at the link word.
  segcd_fixlink.py starter|main|player"""
import glob, re, sys
d = sys.argv[1]
files = glob.glob('src/segacd/%s/*.asm' % d) + ['src/segacd/%s.asm' % d]
T = {f: open(f).read() for f in files}
PH = re.compile(r'\w+?(_\d+|Sub\d+)$')
def refs(n):
    return sum(len(re.findall(r'(?<![\w.\'])%s(?![\w\'])' % re.escape(n), re.sub(r'(?m)^.*\tdc\.b\t.*$', '', t))) for t in T.values())
for f in files:
    L = T[f].split('\n')
    for i in range(len(L) - 1):
        m = re.match(r'^(\w+)(?:;[^\t]*)?\tdc\.w\t\$4E56,\$[0-9A-F]{4}\s*$', L[i])
        m2 = re.match(r'^(\w+)((?:;[^\t]*)?)\t(.*)$', L[i + 1])
        if not (m and m2): continue
        a, b = m.group(1), m2.group(1)
        if refs(b) > 1: continue
        if PH.match(a) and not PH.match(b):
            # first is a placeholder: the tag name is the real one
            for g in T:
                T[g] = re.sub(r'(?<![\w.])%s(?!\w)' % re.escape(a), '\x01', T[g])
            L = T[f].split('\n')
            L[i] = L[i].replace('\x01', b)
            for g in T:
                if g != f: T[g] = T[g].replace('\x01', b)
            L[i + 1] = '\t' + m2.group(3)
            L = '\n'.join(L).replace('\x01', b).split('\n')
        else:
            L[i + 1] = '\t' + m2.group(3)
        T[f] = '\n'.join(L)
for f in files: open(f, 'w').write(T[f])
