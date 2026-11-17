#!/usr/bin/env python3
"""Regenerate MAIN, PLAYER and STARTER from the disc and keep every name.
  python3 tools/segcd_regen.py            (run from the repo root, one wine at a time)
1. builds the current sources and records address -> name (+ comment) of every non-placeholder label,
2. runs tools/segcd_one.py --fix, the post passes and a build,
3. puts the names back by address (segcd_rename.py), then the Sierra C tag names and the link/audio fixes."""
import glob, json, os, re, subprocess, sys
sys.path.insert(0, 'tools')
PH = re.compile(r'^(\w+?(_\d+|Sub\d+)|L[0-9A-F]+)$')
def run(*a):
    r = subprocess.run(a, capture_output=True, text=True)
    return (r.stdout + r.stderr).strip().split('\n')[-1]
def build():
    return run('npm', 'run', 'build:segacd')
progs = ['starter', 'main', 'player']
print(build())
import segcd_labels as SL
a2n = {}
for d in progs:
    lab = SL.labels(d); out = {}
    for f in glob.glob('src/segacd/%s/*.asm' % d):
        L = open(f).read().split('\n')
        for i, l in enumerate(L):
            m = re.match(r'^([A-Za-z_]\w*)(?:;[^\t]*)?\t', l)
            if m and m.group(1) in lab and not PH.match(m.group(1)) and not re.match(r'^(Byte|Word|Long|Buf)', m.group(1)):
                out['@%X' % lab[m.group(1)]] = [m.group(1), L[i - 1][2:] if i and L[i - 1].startswith('; ') else '']
    a2n[d] = out
main_A = {k: v for k, v in json.load(open('src/segacd/main/names_applied.json')).items() if not k.startswith('@') and v[0].endswith('_A')}
for d in progs:
    print(run('python3', 'tools/segcd_one.py', d.upper(), '--fix'))
    print(run('python3', 'tools/segcd_locals.py', 'src/segacd/' + d))
    print(run('python3', 'tools/segcd_seqnames.py', 'src/segacd/' + d))
run('python3', 'tools/segcd_strs.py')
for d in progs: run('python3', 'tools/segcd_fixlink.py', d)
print(build())
for d in progs:
    json.dump(a2n[d], open('src/segacd/%s/names.json' % d, 'w'), indent=1)
    run('python3', 'tools/segcd_rename.py', d)
run('python3', 'tools/segcd_tags.py', 'starter'); run('python3', 'tools/segcd_rename.py', 'starter')
json.dump(main_A, open('src/segacd/main/names.json', 'w'), indent=1); run('python3', 'tools/segcd_rename.py', 'main')
for d in progs: run('python3', 'tools/segcd_fixlink.py', d)
for d in ('starter', 'main'):
    files = glob.glob('src/segacd/%s/*.asm' % d) + ['src/segacd/%s.asm' % d]
    T = {f: open(f).read() for f in files}
    pairs = [(m.group(1) + '_2', m.group(2)) for t in T.values() for m in re.finditer(r'(?m)^(\w+)_2; (\w+)$', t)]
    for old, new in pairs:
        for f in T:
            T[f] = re.sub(r'(?m)^%s; %s$' % (old, new), new, T[f]); T[f] = re.sub(r'(?<![\w.])%s(?!\w)' % old, new, T[f])
    for f in T: open(f, 'w').write(T[f])
p = 'src/segacd/main/maintext.asm'
t = open(p).read(); open(p, 'w').write(re.sub(r'(?m)^(\w+)_A; \1\s*$', r'\1_A\t; Sierra C function name tag: \1 (first copy of the module)', t))
print(build())
