#!/usr/bin/env python3
"""Short branches written `bxx.s *+N` get a real label: `.l<addr>` at the target when the target is in the same
file and routine scope. Needs the listing of the last build."""
import re, glob
lst = open('output/obj/hockey .lst', errors='replace').read().replace('\r','').split('\n')
norm = lambda s: re.sub(r'\s+', '', s)
rows = []
for l in lst:
    m = re.match(r'^([0-9A-F]{8}) (.*)$', l)
    if m: rows.append((int(m.group(1), 16), norm(m.group(2))))
ptr = 0
total = 0
for f in sorted(glob.glob('src/segacd/hockey/gen_*.asm')):
    L = open(f).read().split('\n')
    addr = {}
    first = True
    for i, l in enumerate(L):
        if not l.strip(): continue
        ns = norm(l)
        j = ptr
        while j < len(rows) and not rows[j][1].endswith(ns): j += 1
        if j >= len(rows) or (j - ptr > 40 and not first):
            continue
        first = False
        addr[i] = rows[j][0]; ptr = j + 1
    byaddr = {}
    for i, a in addr.items():
        if re.match(r'^[^\t;]*\t', L[i]) and re.match(r'^\S*\t\S', L[i]):  # has an instruction
            byaddr.setdefault(a, i)
    ins = {}
    n = 0
    for i, l in enumerate(L):
        m = re.match(r'^(\S*)\t(b\w\w)\.s\t\*([+-]\d+)(.*)$', l)
        if not m or i not in addr: continue
        t = addr[i] + int(m.group(3))
        ti = byaddr.get(t)
        if ti is None: continue
        lo, hi = sorted((i, ti))
        if any(re.match(r'^[A-Za-z_]', L[k]) for k in range(lo + 1, hi + 1) if k != ti or True) and False:
            continue
        # no global label between (a global label on the target line itself is fine as the scope owner)
        if any(re.match(r'^[A-Za-z_]\w*', L[k]) and not L[k].startswith('.') for k in range(lo + (1 if ti > i else 0), hi + (0 if ti > i else 1)) if k != ti):
            continue
        ln = '.l%X' % t
        ins[ti] = ln
        L[i] = '%s\t%s.s\t%s%s' % (m.group(1), m.group(2), ln, m.group(4)); n += 1
    for ti, ln in ins.items():
        cur = re.match(r'^(\S*)\t', L[ti]).group(1)
        if cur:
            # already labelled: reuse that label name in the branches
            pass
    # apply label definitions
    for ti, ln in ins.items():
        m = re.match(r'^(\S*)(\t.*)$', L[ti])
        if m.group(1) == '': L[ti] = ln + m.group(2)
        else:
            old = m.group(1)
            if old != ln:
                for k, l2 in enumerate(L):
                    L[k] = re.sub(r'(\.s\t)%s\b' % re.escape(ln), r'\g<1>' + old, l2)
    open(f, 'w').write('\n'.join(L)); total += n
print('converted', total)
