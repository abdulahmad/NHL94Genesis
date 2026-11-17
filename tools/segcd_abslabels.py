#!/usr/bin/env python3
"""Give labels to HOCKEY routine starts that are only called through absolute addresses (jsr $xxxxx.l).

  python3 tools/segcd_abslabels.py NAMES.py        (needs output/obj/hockey .lst from a build)

NAMES.py defines N = {address: 'Name'}.  A label line is inserted before the instruction at that address (found by
aligning the sources with the listing) and every `jsr/jmp $addr.l` becomes `jsr (Name).l`.  Labels that make the
assembler fail (a local label used across the cut) are taken out again."""
import glob, os, re, subprocess, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import segcd_one as S
root = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'); os.chdir(root)
ns = {}; exec(open(sys.argv[1]).read(), ns); N = ns['N']
rows = []
for l in open('output/obj/hockey .lst', errors='replace').read().replace('\r', '').split('\n'):
    if re.match(r'^[0-9A-F]{8} ', l): rows.append((int(l[:8], 16), l[36:] if len(l) > 36 else ''))
norm = lambda s: re.sub(r'\s+', '', s)
cfg = dict(disc='cdbin/HOCKEY.BIN', base=0x1B000, name='hockey', oaq='-')
files = {f: open(f, encoding='latin1').read().split('\n') for f in glob.glob('src/segacd/hockey/*.asm') if 'teamdata' not in f}
orig = {f: list(v) for f, v in files.items()}
ins = []   # (file, line index, name)
for f, L in files.items():
    j = next((k for k, r in enumerate(rows) if r[1].strip().startswith('include') and r[1].strip().endswith('\\' + os.path.basename(f))), 0)
    for i, t in enumerate(L):
        nt = norm(t)
        if not nt: continue
        k = j
        while k < len(rows) and norm(rows[k][1]) != nt and k - j < 60: k += 1
        if k < len(rows) and norm(rows[k][1]) == nt:
            a = rows[k][0]; j = k + 1
            if a in N and (not re.match(r'^\S', t) or t.startswith('.')) and not re.match(r'^\s*(dc|dcb)\.', t) and (a, f) not in [(x[3], x[0]) for x in ins]: ins.append((f, i, N[a], a))
def apply(skip):
    for f in files: files[f] = list(orig[f])
    for f in files:
        mine = sorted([x for x in ins if x[0] == f and x[2] not in skip], key=lambda x: -x[1])
        for _, i, nm, a in mine:
            t = files[f][i]
            if t.startswith('.'): files[f][i] = nm + '\n' + t   # a local label line: keep it after the new global label
            else: files[f].insert(i, nm)
    rep = {a: n for _, _, n, a in ins if n not in skip}
    for f in files:
        files[f] = [re.sub(r'\b(jsr|jmp)\t\$([0-9A-F]{5})\.l', lambda m: '%s\t(%s).l' % (m.group(1), rep[int(m.group(2), 16)]) if int(m.group(2), 16) in rep else m.group(0), t) for t in files[f]]
        open(f, 'w', encoding='latin1').write('\n'.join(files[f]))
skip = set()
for rnd in range(8):
    apply(skip)
    errs, txt = S.assemble(cfg)
    errs = [e for e in errs if 'odd address' not in e[2]]
    print('round', rnd, 'errors', len(errs), flush=True)
    if not errs: break
    bad = set()
    for fn, ln, msg in errs:
        f = next((x for x in files if os.path.basename(x)[:-4].lower() == fn), None)
        if not f: continue
        # blame the nearest inserted label above the error line
        for _, i, nm, a in sorted(ins, key=lambda x: -x[1]):
            if _ == f and i <= ln: bad.add(nm); break
    if not bad: break
    skip |= bad
print('labels', len(ins) - len(skip), 'skipped', sorted(skip))
