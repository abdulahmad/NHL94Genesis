#!/usr/bin/env python3
"""`lea label(pc),aN` rows that stayed dc.w ($4xFA dddd): give the target a label and write the lea.
Needs the listing of the last build (output/obj/hockey .lst)."""
import re, glob
lst = open('output/obj/hockey .lst', errors='replace').read().replace('\r', '').split('\n')
norm = lambda s: re.sub(r'\s+', '', s)
rows = []
for l in lst:
    m = re.match(r'^([0-9A-F]{8}) (.*)$', l)
    if m: rows.append((int(m.group(1), 16), norm(m.group(2))))
ptr = 0; total = 0; miss = 0; want = {}
GL = {}
_files = sorted(glob.glob('src/segacd/hockey/gen_*.asm'))
_T = {f: open(f).read().split('\n') for f in _files}
_p = 0
for f in _files:
    first = True
    for i, l in enumerate(_T[f]):
        if not l.strip(): continue
        ns = norm(l); j = _p
        while j < len(rows) and not rows[j][1].endswith(ns): j += 1
        if j >= len(rows) or (j - _p > 40 and not first): continue
        first = False; GL.setdefault(rows[j][0], (f, i)); _p = j + 1
EXTRA = []
for f in sorted(glob.glob('src/segacd/hockey/gen_*.asm')):
    L = open(f).read().split('\n')
    addr = {}; first = True
    for i, l in enumerate(L):
        if not l.strip(): continue
        ns = norm(l); j = ptr
        while j < len(rows) and not rows[j][1].endswith(ns): j += 1
        if j >= len(rows) or (j - ptr > 40 and not first): continue
        first = False; addr[i] = rows[j][0]; ptr = j + 1
    byaddr = {}
    for i, a in addr.items():
        byaddr.setdefault(a, i)
    for i, l in enumerate(L):
        m = re.match(r'^(\S*)\tdc\.w\t\$([0-9A-F]{2})([0-9A-F]{2}),\$([0-9A-F]{4})\s*(;.*)?$', l)
        if not m or m.group(3) != 'FA' or int(m.group(2), 16) & 0xF1 != 0x41 or i not in addr: continue
        reg = (int(m.group(2), 16) >> 1) & 7
        d = int(m.group(4), 16); d = d - 0x10000 if d & 0x8000 else d
        t = addr[i] + 2 + d
        ti = byaddr.get(t)
        if ti is None:
            g = GL.get(t)
            if g and g[0] != f:
                lab2 = re.match(r'^(\S*)\t', _T[g[0]][g[1]])
                if lab2 and lab2.group(1) and not lab2.group(1).startswith('.'):
                    L[i] = '%s\tlea.l\t%s(pc),a%d' % (m.group(1), lab2.group(1), reg); total += 1; continue
            want.setdefault(f, set()).add(t); miss += 1; continue
        cur = re.match(r'^(\S*)\t', L[ti])
        if not cur: miss += 1; continue
        name = cur.group(1) or '.l%X' % t
        if not cur.group(1):
            L[ti] = name + L[ti]
        if name.startswith('.'):
            # local labels are scoped to the previous global label: only use it when no global label lies between
            lo, hi = sorted((i, ti))
            if any(re.match(r'^[A-Za-z_]', L[k]) for k in range(lo + 1, hi)): 
                L[ti] = L[ti][len(name):]; miss += 1; continue
        L[i] = '%s\tlea.l\t%s(pc),a%d' % (m.group(1), name, reg); total += 1
    open(f, 'w').write('\n'.join(L))
def toks(args):
    out = []
    for m in re.finditer(r"'((?:[^']|'')*)'|\$([0-9A-Fa-f]{2})", args):
        if m.group(1) is not None: out += [("'" + m.group(1) + "'", len(m.group(1).replace("''", "'")))]
        else: out.append(('$' + m.group(2), 1))
    return out
import sys
if '--split' in sys.argv:
    allt = sorted({t for ts in want.values() for t in ts}, reverse=True)
    byfile = {}
    for t in allt:
        cand = [a for a in GL if a < t]
        if not cand: continue
        a = max(cand); f2, i2 = GL[a]
        byfile.setdefault(f2, []).append((i2, a, t))
    for f2, items in byfile.items():
        L = _T[f2]
        for i2, a, t in sorted(items, reverse=True):
            m = re.match(r'^(\S*)\tdc\.b\t(.*?)(\t;.*)?$', L[i2])
            if not m: continue
            tk = toks(m.group(2)); off = t - a; acc = 0; cut = None
            for k, (tx, n) in enumerate(tk):
                if acc == off: cut = k; break
                if acc < off < acc + n and tx.startswith("'"):
                    body = tx[1:-1]
                    tk[k:k + 1] = [("'" + body[:off - acc] + "'", off - acc), ("'" + body[off - acc:] + "'", n - (off - acc))]
                    cut = k + 1; break
                acc += n
            if cut is None or cut == 0: continue
            L[i2:i2 + 1] = [m.group(1) + '\tdc.b\t' + ','.join(x[0] for x in tk[:cut]), '\tdc.b\t' + ','.join(x[0] for x in tk[cut:])]
        open(f2, 'w').write('\n'.join(L))
print('converted', total, 'unresolved', miss)
