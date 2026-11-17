#!/usr/bin/env python3
"""Fold placeholder global labels that only continue a named routine into that routine as local labels.

  python3 tools/segcd_chains.py hockey|main|player|starter [--dry]

A placeholder (L<hex>, Name_<n>, Name<Sub><n>) that follows a named routine and is only the target of branches
from inside that routine (or from earlier members of the same chain) is not a routine of its own: it becomes a
local label `.l<line>` of the owner.  A member that is called (bsr/jsr), referenced from outside, or has no
references breaks the chain.  Local names are then given their roles by tools/segcd_localnames.py."""
import glob, os, re, sys
root = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'); os.chdir(root)
prog = sys.argv[1]; dry = '--dry' in sys.argv
PH = re.compile(r'^(L[0-9A-F]{3,6}|\w+?_\d+|\w+?Sub\d+)$')
inc = [l.split()[1].replace('\\', '/') for l in open('src/segacd/%s.asm' % prog) if l.strip().startswith('include') and 'macros' not in l and 'output' not in l and l.split()[1].lower().endswith('.asm')]
files = ['src/' + i for i in inc if os.path.exists('src/' + i) and '/segacd/' in ('/' + i.replace('\\', '/'))]
lines = []   # [file, text]
for f in files:
    for t in open(f, encoding='latin1').read().split('\n'): lines.append([f, t])
LAB = re.compile(r'^([A-Za-z_]\w*)(?=[\s:]|$)')
BRANCH = re.compile(r'^(b(?!sr\b)[a-z]{2}|bra|dbra|dbf|db[a-z]{2}|jmp)(\.[sbwl])?$', re.I)
glob_lines = []   # (index, name)
for i, (f, t) in enumerate(lines):
    if t.startswith((' ', '\t', ';', '.')) or not t.strip(): continue
    m = LAB.match(t)
    if not m: continue
    rest = t[m.end():].split(';')[0].split()
    if rest[:1] and rest[0].lower() in ('equ', '=', 'macro'): continue
    glob_lines.append((i, m.group(1)))
names = {n: i for i, n in glob_lines}
tok = re.compile(r'[A-Za-z_]\w*')
refs = {}
for i, (f, t) in enumerate(lines):
    body = t.split(';')[0]
    m = LAB.match(body) if not body.startswith((' ', '\t', '.')) else None
    if m: body = body[m.end():]
    parts = body.split(None, 1)
    if not parts: continue
    op = parts[0]; opr = parts[1] if len(parts) > 1 else ''
    for w in tok.findall(opr):
        if w in names and names[w] != i: refs.setdefault(w, []).append((i, op))
gl = [i for i, _ in glob_lines]
conv = {}
k = 0
while k < len(glob_lines):
    i, n = glob_lines[k]
    if PH.match(n):
        k += 1; continue
    owner = n; k += 1
    chain = []
    while k < len(glob_lines) and PH.match(glob_lines[k][1]):
        chain.append(glob_lines[k]); k += 1
    if not chain: continue
    end_all = glob_lines[k][0] if k < len(glob_lines) else len(lines)
    ok = []
    for (ci, cn) in chain:
        r = refs.get(cn, [])
        if not r: break                      # unreferenced (data or entry): stays
        if any(not BRANCH.match(op) for _, op in r): break
        nxt_i = None
        # references must lie between the owner and the end of the chain so far
        lo = names[owner]
        if any(not (lo < ri) for ri, _ in r): break
        ok.append((ci, cn))
    # all references of the members must be before the first staying member
    stay = chain[len(ok)][0] if len(ok) < len(chain) else end_all
    ok = [(ci, cn) for ci, cn in ok if all(ri < stay for ri, _ in refs[cn])]
    # members after a staying one are not in the owner's scope: only the leading run counts
    lead = []
    for (ci, cn) in ok:
        lead.append((ci, cn))
    for ci, cn in lead:
        conv[cn] = '.l%X' % ci
print(prog, 'chain labels to fold:', len(conv))
if dry: sys.exit()
word = {n: re.compile(r'(?<![\w.])%s(?!\w)' % re.escape(n)) for n in conv}
out = {}
for i, (f, t) in enumerate(lines):
    s = t
    m = LAB.match(s) if not s.startswith((' ', '\t', ';', '.')) else None
    if m and m.group(1) in conv:
        s = conv[m.group(1)] + s[m.end():]
    if '\t' in s or s.startswith('.') or m:
        head, sep, cmt = s.partition(';')
        for n, rx in word.items():
            if n in head: head = rx.sub(conv[n], head)
        s = head + sep + cmt
    out.setdefault(f, []).append(s)
for f, L in out.items(): open(f, 'w', encoding='latin1').write('\n'.join(L))
