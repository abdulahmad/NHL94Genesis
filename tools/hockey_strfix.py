#!/usr/bin/env python3
"""Rewrite text that was decoded as instructions (rows like `bgt.s *+118`) as dc.b rows with the text quoted.
  python3 tools/hockey_strfix.py       (needs a build: output/obj/hockey .lst; check with a build afterwards)"""
import os, re, sys
root = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'); os.chdir(root)
base = 0x1B000
d = open('cdbin/HOCKEY.BIN', 'rb').read()
inc = [l.split()[1].replace('\\', '/') for l in open('src/segacd/hockey.asm') if l.strip().startswith('include') and 'macros' not in l and l.split()[1].endswith('.asm')]
files = ['src/' + i for i in inc if os.path.exists('src/' + i)]
rows = []
for l in open('output/obj/hockey .lst', errors='replace').read().replace('\r', '').split('\n'):
    if re.match(r'^[0-9A-F]{8} ', l): rows.append((int(l[:8], 16), l[36:] if len(l) > 36 else ''))
norm = lambda s: re.sub(r'\s+', '', s)
Lall = [(f, t) for f in files for t in open(f, encoding='latin1').read().split('\n')]
addr = [None] * len(Lall)
first = next(norm(t) for f, t in Lall if norm(t))
j = next(k for k, r in enumerate(rows) if norm(r[1]) == first)
for n, (f, t) in enumerate(Lall):
    nt = norm(t); k = j
    while k < len(rows) and norm(rows[k][1]) != nt and k - j < 80: k += 1
    if k < len(rows) and norm(rows[k][1]) == nt: addr[n] = rows[k][0]; j = k + 1
def end(n):
    for m in range(n + 1, len(Lall)):
        if addr[m] is not None and addr[m] != addr[n]: return addr[m]
def printable(n):
    a = addr[n]; e = end(n)
    if a is None or e is None or e - a < 2: return False
    b = d[a - base:e - base]
    return sum(1 for x in b if 0x20 <= x < 0x7F) * 10 >= len(b) * 6
BODY = re.compile(r'^([A-Za-z_]\w*)?[^\t]*\t(\S+)')
def isstrrow(n):
    t = Lall[n][1]
    if t.lstrip().startswith(';') or not t.strip(): return False
    m = BODY.match(t)
    if not m: return False
    return printable(n) and not t.startswith(('.',))
sus = [n for n, (f, t) in enumerate(Lall) if re.search(r'\t[a-z.]+\t\*[+-]\d+', t)]
done = set(); edits = {}
for n in sus:
    if n in done: continue
    s = n
    while s > 0 and isstrrow(s - 1) and addr[s - 1] is not None and Lall[s - 1][0] == Lall[n][0]: s -= 1
    e = n
    while e + 1 < len(Lall) and isstrrow(e + 1) and Lall[e + 1][0] == Lall[n][0]: e += 1
    done.update(range(s, e + 1))
    a0 = addr[s]; a1 = end(e)
    edits[(Lall[n][0], s, e)] = (a0, a1)
print('blocks', len(edits))
out = {}
for (f, s, e), (a0, a1) in sorted(edits.items(), key=lambda kv: -kv[0][1]):
    if a0 is None or a1 is None:
        print('skip', f, s, e, Lall[s][1][:50]); continue
    b = d[a0 - base:a1 - base]
    lab = ''
    m = re.match(r'^([A-Za-z_]\w*)(?=[\t ])', Lall[s][1])
    lines = []
    i = 0; first = True
    while i < len(b):
        j2 = i
        while j2 < len(b) and 0x20 <= b[j2] < 0x7F and b[j2] != 0x27 and j2 - i < 40: j2 += 1
        if j2 - i >= 3: seg = "'" + b[i:j2].decode() + "'"; i = j2
        else: seg = '$%02X' % b[i]; i += 1
        lines.append(seg)
    # merge into rows of up to 12 items
    rows_out = ['\tdc.b\t' + ','.join(lines[k:k + 12]) for k in range(0, len(lines), 12)]
    if m: rows_out[0] = m.group(1) + '\t' + rows_out[0].lstrip('\t') if False else rows_out[0]
    out.setdefault(f, []).append((s, e, m.group(1) if m else None, rows_out))
for f, items in out.items():
    L = open(f, encoding='latin1').read().split('\n')
    base_idx = next(i for i, (ff, t) in enumerate(Lall) if ff == f)
    for s, e, lab, rows_out in sorted(items, reverse=True):
        s -= base_idx; e -= base_idx
        new = ([lab] if lab else []) + rows_out
        L[s:e + 1] = new
    open(f, 'w', encoding='latin1').write('\n'.join(L))
