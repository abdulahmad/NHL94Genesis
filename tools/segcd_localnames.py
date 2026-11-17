#!/usr/bin/env python3
"""Give every branch target in a Sega CD disc program a role name like the cartridge does.

  python3 tools/segcd_localnames.py <main|player|starter|hockey> [--dry]

1. Numbered global labels (Foo_3, FooSub2) that are only reached by branches from
   inside their own routine become local labels of that routine.
2. Every local label (.l1A2B or a converted one) is renamed by role:
   .loop (some branch jumps back to it), .ex (it is the routine exit),
   .next (forward branch target).  Repeats in one routine get 2, 3, ...
Already renamed locals (.loop, .next2 ...) are left alone.
"""
import re, sys, collections, os
D = sys.argv[1]
base = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'src') + '/'
inc = [l.split()[1].replace('\\', '/') for l in open(base + 'segacd/' + D + '.asm')
       if l.strip().startswith('include') and 'macros' not in l]
files = [base + i for i in inc]
BR = {'bra','bne','beq','bcc','bcs','bhi','bls','bpl','bmi','bge','blt','bgt','ble','bvc','bvs',
      'dbra','dbf','dbne','dbeq','dbt','dbcc','dbcs','dbhi','dbls','dbpl','dbmi','dbge','dblt','dbgt','dble','dbvc','dbvs','jmp'}
lab = re.compile(r'^(\.?[A-Za-z_][A-Za-z_0-9]*)(:?)(?=\s|$)')
PLACE = re.compile(r'^(?:[A-Za-z]+(?:_\d+|Sub\d+))$')
LOCPL = re.compile(r'^\.l[0-9A-Fa-f]+$')
tok = re.compile(r'(?<![A-Za-z0-9_])(\.?[A-Za-z_][A-Za-z_0-9]*)')

lines = []          # [file_idx, text]
for fi, f in enumerate(files):
    for l in open(f).read().split('\n'):
        lines.append([fi, l])

def split(l):
    """-> (label or None, op, operand-text, comment-start-index)"""
    code = l
    in_q = False
    cut = len(l)
    for i, ch in enumerate(l):
        if ch == "'": in_q = not in_q
        elif ch == ';' and not in_q:
            cut = i; break
    code = l[:cut]
    m = lab.match(code) if code and not code[0].isspace() else None
    rest = code[m.end():] if m else code
    p = rest.split(None, 1)
    op = p[0].lower() if p else ''
    opr = p[1] if len(p) > 1 else ''
    return (m.group(1) if m else None), op, opr, cut, (m.end() if m else 0)

info = [split(l[1]) for l in lines]
# definitions
defs = {}   # name -> line idx (globals and locals share a namespace key by (scope,name) later)
globals_ = []
for k, (n, op, opr, cut, e) in enumerate(info):
    if n and not n.startswith('.') and op != 'equ':
        if n not in defs: defs[n] = k
        globals_.append(k)
# references to global names, with op
grefs = collections.defaultdict(list)
for k, (n, op, opr, cut, e) in enumerate(info):
    if not op: continue
    if op.startswith('dc.b') and "'" in opr: continue
    for t in tok.findall(opr):
        if t in defs and not t.startswith('.'):
            grefs[t].append((k, op.split('.')[0]))

cand = set()
for n, k in defs.items():
    if PLACE.match(n):
        r = grefs.get(n, [])
        if r and all(o in BR for _, o in r):
            cand.add(n)

def owner_of(k, cand):
    # nearest preceding global label not in cand (same file order)
    j = k
    while j >= 0:
        n = info[j][0]
        if n and not n.startswith('.') and info[j][1] != 'equ' and n not in cand:
            return n
        j -= 1
    return None
changed = True
while changed:
    changed = False
    for n in sorted(cand):
        o = owner_of(defs[n], cand)
        if any(owner_of(k, cand) != o for k, _ in grefs[n]) or o is None:
            cand.discard(n); changed = True
# a candidate must not be the first label of a data block etc: ensure code precedes
# Build scopes: owner -> ordered list of local-label (line idx, old name)
loc_defs = collections.defaultdict(list)   # owner -> [(k, name)]
cur = None
newname = {}   # (owner, oldname) -> newname
for k, (n, op, opr, cut, e) in enumerate(info):
    if n and not n.startswith('.') and op != 'equ' and n not in cand:
        cur = n
    if n and (n in cand or (n.startswith('.') and LOCPL.match(n))):
        loc_defs[cur].append((k, n))
# references per owner scope
def refs_to(owner, name, start, end):
    out = []
    for k in range(start, end):
        nn, op, opr, cut, e = info[k]
        if op and not (op.startswith('dc.b') and "'" in opr):
            if name in tok.findall(opr): out.append((k, op.split('.')[0]))
    return out
# scope extents
extent = {}
cur = None; s = 0
for k, (n, op, opr, cut, e) in enumerate(info):
    if n and not n.startswith('.') and op != 'equ' and n not in cand:
        if cur is not None: extent[cur] = (s, k)
        cur = n; s = k
if cur is not None: extent[cur] = (s, len(info))
SKIPOP = {'rts','rte','rtr'}
for owner, dl in loc_defs.items():
    if owner is None: continue
    s, e = extent[owner]
    cnt = collections.Counter()
    used = set()
    for k in range(s, e):
        if info[k][0] and info[k][0].startswith('.'): used.add(info[k][0])
    for k, name in dl:
        r = refs_to(owner, name, s, e)
        back = any(rk > k for rk, _ in r)       # a branch after the label jumps back to it
        # first instruction at the label
        j = k; first = info[k][1]
        if not first:
            j = k + 1
            while j < e and not info[j][1] and not info[j][0]: j += 1
            first = info[j][1] if j < e else ''
        if back: base_n = 'loop'
        elif first.split('.')[0] in SKIPOP or first in ('unlk',): base_n = 'ex'
        else: base_n = 'next'
        while True:
            cnt[base_n] += 1
            nn = '.' + base_n + (str(cnt[base_n]) if cnt[base_n] > 1 else '')
            if nn not in used: break
        used.add(nn)
        newname[(owner, name)] = nn
if '--dry' in sys.argv:
    print(D, 'converted globals', len(cand), 'renamed locals', len(newname)); sys.exit()
# apply
out = [l[1] for l in lines]
owner_at = {}
cur = None
for k, (n, op, opr, cut, e) in enumerate(info):
    if n and not n.startswith('.') and op != 'equ' and n not in cand: cur = n
    owner_at[k] = cur
for k, (n, op, opr, cut, e) in enumerate(info):
    ow = owner_at[k]
    l = lines[k][1]
    head = l[:e]; body = l[e:cut]; tail = l[cut:]
    if n and (n in cand or (n.startswith('.') and (ow, n) in newname)):
        head = newname[(ow, n)] + head[len(n):]
    if op and not (op.startswith('dc.b') and "'" in opr):
        def rep(m):
            t = m.group(1)
            if t.startswith('.'):
                return newname.get((ow, t), t)
            if t in cand: return newname[(ow, t)] if (ow, t) in newname else t
            return t
        body = tok.sub(rep, body)
    out[k] = head + body + tail
# write back per file
per = collections.defaultdict(list)
for k, l in enumerate(out): per[lines[k][0]].append(l)
for fi, f in enumerate(files):
    open(f, 'w').write('\n'.join(per[fi]))
print(D, 'converted globals', len(cand), 'renamed locals', len(newname))
