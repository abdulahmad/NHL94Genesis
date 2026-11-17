#!/usr/bin/env python3
"""Find code that is still written as dc.b / dc.w rows in the HOCKEY sources and turn it into instructions.

  python3 tools/hockey_dc2asset.py       (needs a build: output/obj/hockey .lst; run from the repo root)

Every run of dc rows (one label at most, at its start) is cut out as a temporary asset (an incbin of the same
bytes), tools/hockey_assetcode.py then rewrites the assets that hold code, and every temporary asset it left
alone is put back as the original rows.  So data tables keep their dc.w / String form and only runs with code
change.  Follow with tools/hockey_branches.py and a build."""
import json, os, re, subprocess, sys
root = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'); os.chdir(root)
base = 0x1B000
MIN = int(os.environ.get('DC_MIN', '6'))
inc = [l.split()[1].replace('\\', '/') for l in open('src/segacd/hockey.asm') if l.strip().startswith('include') and 'macros' not in l and l.split()[1].endswith('.asm')]
files = ['src/' + i for i in inc if os.path.exists('src/' + i)]
rows = []
for l in open('output/obj/hockey .lst', errors='replace').read().replace('\r', '').split('\n'):
    if re.match(r'^[0-9A-F]{8} ', l): rows.append((int(l[:8], 16), l[36:] if len(l) > 36 else ''))
norm = lambda s: re.sub(r'\s+', '', s)
DC = re.compile(r'^(?:([A-Za-z_]\w*)[^\t]*)?\t(?:dc\.[bwl]|dcb\.[bwl])\t')
LAB = re.compile(r'^([A-Za-z_]\w*)')
assets = json.load(open('src/segacd/hockey/assets.json'))
saved = {}
first = None
total = 0
for f in files:
    L = open(f, encoding='latin1').read().split('\n')
    # addresses by aligning with the listing rows, per file (rows are in file order across the files)
    pass
# align once over all files
Lall = []
for f in files:
    for i, t in enumerate(open(f, encoding='latin1').read().split('\n')): Lall.append((f, i, t))
addr = [None] * len(Lall)
j = 0
first = next(norm(t) for f, i, t in Lall if norm(t))
j = next(k for k, r in enumerate(rows) if norm(r[1]) == first)
for n, (f, i, t) in enumerate(Lall):
    nt = norm(t); k = j
    while k < len(rows) and norm(rows[k][1]) != nt and k - j < 80: k += 1
    if k < len(rows) and norm(rows[k][1]) == nt:
        addr[n] = rows[k][0]; j = k + 1
# end address of a line = address of the next aligned line
def end_of(n):
    for m in range(n + 1, len(Lall)):
        if addr[m] is not None and addr[m] != addr[n]: return addr[m]
    return None
bylines = {}
for n, (f, i, t) in enumerate(Lall): bylines.setdefault(f, []).append(n)
new_files = {}
for f in files:
    idx = bylines[f]
    out = []
    n = 0
    L = [Lall[k][2] for k in idx]
    while n < len(L):
        t = L[n]; g = idx[n]
        m = DC.match(t)
        lab_line = None
        if m and addr[g] is not None:
            # a run: this row and the following dc rows without a label (comment-only lines are kept inside)
            s = n; e = n + 1
            while e < len(L):
                t2 = L[e]
                if DC.match(t2) and not LAB.match(t2) and addr[idx[e]] is not None: e += 1
                else: break
            a0 = addr[g]; a1 = end_of(idx[e - 1])
            if a1 is not None and a1 - a0 >= MIN and a0 >= base + 0x5432 and 'segacd/hockey/' in f and os.environ.get('DC_ONLY', '') in f:
                key = 'hockey_%05X.bin' % (a0 - base)
                head = LAB.match(t).group(0) if LAB.match(t) else ''
                saved[key] = {'file': f, 'lines': L[s:e]}
                assets[key] = {'start': a0 - base, 'size': a1 - a0}
                if head:
                    cm = t.partition(';')[2]
                    out.append(head + ('\t\t\t\t\t\t;' + cm if cm else ''))
                out.append('\tincbin\t..\\Extracted\\SegaCD\\HOCKEY\\' + key)
                n = e; total += a1 - a0
                continue
        out.append(t); n += 1
    new_files[f] = out
for f, out in new_files.items(): open(f, 'w', encoding='latin1').write('\n'.join(out))
json.dump(dict(sorted(assets.items(), key=lambda kv: kv[1]['start'])), open('src/segacd/hockey/assets.json', 'w'), indent=1)
json.dump(saved, open('/tmp/w/dcruns.json', 'w'))
print('runs', len(saved), 'bytes', total)
os.system('node tools/extractAssetsSegaCD.js >/dev/null')
r = subprocess.run([sys.executable, 'tools/hockey_assetcode.py'], capture_output=True, text=True)
open('/tmp/w/ac.log', 'w').write(r.stdout + r.stderr); print((r.stdout + r.stderr)[-600:])
# put back every temporary asset that still stands
assets = json.load(open('src/segacd/hockey/assets.json'))
back = 0
for key, v in saved.items():
    if key not in assets: continue
    f = v['file']; txt = open(f, encoding='latin1').read()
    line = '\tincbin\t..\\Extracted\\SegaCD\\HOCKEY\\' + key
    if line not in txt: continue
    L = v['lines']
    lines = txt.split('\n'); k = lines.index(line)
    mm = LAB.match(L[0])
    if mm and k > 0 and lines[k - 1].startswith(mm.group(0)):
        lines[k - 1:k + 1] = L
    else:
        lines[k:k + 1] = L
    txt = '\n'.join(lines)
    open(f, 'w', encoding='latin1').write(txt); back += 1
    assets.pop(key)
json.dump(dict(sorted(assets.items(), key=lambda kv: kv[1]['start'])), open('src/segacd/hockey/assets.json', 'w'), indent=1)
print('restored', back, 'of', len(saved))
