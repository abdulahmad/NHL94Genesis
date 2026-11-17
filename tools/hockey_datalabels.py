#!/usr/bin/env python3
"""Data blocks of HOCKEY.BIN that code reaches through an absolute address ($3xxxx.l, move.l #$3xxxx): label the block
(<Routine>Str<n> for text, <Routine>Tbl<n> otherwise) and use the label in the operand. Needs the last build's listing."""
import re, glob
lst = open('output/obj/hockey .lst', errors='replace').read().replace('\r', '').split('\n')
norm = lambda s: re.sub(r'\s+', '', s)
rows = []
for l in lst:
    m = re.match(r'^([0-9A-F]{8}) (.*)$', l)
    if m: rows.append((int(m.group(1), 16), norm(m.group(2))))
base, size = 0x1B000, 184842
files = sorted(glob.glob('src/segacd/hockey/gen_*.asm'))
T = {f: open(f).read().split('\n') for f in files}
A = {}; ptr = 0
for f in files:
    L = T[f]; first = True
    for i, l in enumerate(L):
        if not l.strip(): continue
        ns = norm(l); j = ptr
        while j < len(rows) and not rows[j][1].endswith(ns): j += 1
        if j >= len(rows) or (j - ptr > 40 and not first): continue
        first = False; A[(f, i)] = rows[j][0]; ptr = j + 1
refs = {}
for f, L in T.items():
    for l in L:
        for m in re.finditer(r'\$([0-9A-F]{5,6})\.l|#\$([0-9A-F]{5,6})\b', l.split(';')[0]):
            v = int(m.group(1) or m.group(2), 16)
            if base <= v < base + size: refs[v] = 1
byaddr = {a: k for k, a in A.items()}
names = {}; cnt = {}
for f, L in T.items():
    prev = 'Hk'
    for i, l in enumerate(L):
        m = re.match(r'^([A-Za-z_]\w*)', l)
        if m: prev = m.group(1)
        a = A.get((f, i))
        if a in refs and re.match(r'^\S*\tdc\.', l) and a not in names:
            lab = re.match(r'^(\S*)\t', l).group(1)
            kind = 'Str' if re.match(r"^\S*\tdc\.b\t'", l) else 'Tbl'
            if lab and not lab.startswith('.'):
                names[a] = lab; continue
            root = re.sub(r'(_\d+|Sub\d+)$', '', prev)
            cnt[(root, kind)] = cnt.get((root, kind), 0) + 1
            nm = '%s%s%d' % (root, kind, cnt[(root, kind)])
            names[a] = nm
            if not lab: L[i] = nm + l
print(len(names), 'blocks labelled')
for f, L in T.items():
    for i, l in enumerate(L):
        if l.lstrip().startswith(';'): continue
        code, sep, cm = l.partition(';')
        def r1(m):
            v = int(m.group(1), 16)
            return names[v] + '.l' if v in names else m.group(0)
        code = re.sub(r'\$([0-9A-F]{5,6})\.l', r1, code)
        if re.search(r'\t(move|pea|cmpi)\.l\t#', code):
            code = re.sub(r'#\$([0-9A-F]{5,6})\b', lambda m: '#' + names[int(m.group(1), 16)] if int(m.group(1), 16) in names else m.group(0), code)
        L[i] = code + sep + cm
    open(f, 'w').write('\n'.join(L))
