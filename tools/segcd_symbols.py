#!/usr/bin/env python3
"""segcd_symbols.py: Sega CD HOCKEY numbers become the cartridge's constant names, defined in ram94cd.asm.

Where a disc instruction lines up with the same instruction of its cartridge twin and the cartridge writes a
constant name (#gmhl, Xvel(a3), tmap(a2)) where the disc has a number (#$4, $28(a3), $26(a2)), the disc line takes the
name. The name is defined in src/segacd/ram94cd.asm with the DISC's value, so the bytes cannot change, and the disc
keeps its own struct layout (tmgoalie $28, not $26). A name is only taken when every aligned use agrees on one value
and there are at least --min of them.
  python3 tools/segcd_symbols.py REPO --lst="output/obj/nhl94 .lst" [--apply] [--min=2]
(the listing comes from `node tools/build.js retail`). Check with `node tools/build.js --segacd` (MATCH)."""
import re, glob, os, sys, difflib, collections
root = next((a for a in sys.argv[1:] if not a.startswith('--')), '.')
APPLY = '--apply' in sys.argv
MIN = int(next((a[6:] for a in sys.argv if a.startswith('--min=')), 2))
LST = next(a[6:] for a in sys.argv if a.startswith('--lst='))
SPLIT = re.compile(r',(?![^(]*\))')
# cartridge constants: plain `equ` symbols (not rs variables, not labels)
CONST = {}
for l in open(LST, encoding='latin-1'):
    m = re.match(r'^[0-9A-F]{8} =([0-9A-F]{8})\s+(\w+)\s+equ\s', l)
    if m: CONST[m.group(2).lower()] = m.group(2)
RS = set()
for l in open(LST, encoding='latin-1'):
    m = re.match(r'^[0-9A-F]{8} =[0-9A-F]{8}\s+(\w+)\s+rs\.', l)
    if m: RS.add(m.group(1).lower())
DISCDEF = {}
for l in open(os.path.join(root, 'src/segacd/ram94cd.asm'), encoding='latin-1'):
    m = re.match(r'^(\w+)\s+(?:equ|set)\s+(\$?[0-9A-Fa-f]+)', l)
    if m: DISCDEF[m.group(1).lower()] = m.group(2)
LABELS = set()
for f in glob.glob(os.path.join(root, 'src/segacd/**/*.asm'), recursive=True):
    for l in open(f, encoding='latin-1'):
        m = re.match(r'^([A-Za-z_]\w*)', l)
        if m and l[0] not in ' \t;': LABELS.add(m.group(1).lower())
def num(s):
    s = s.strip()
    return int(s[1:], 16) if s.startswith('$') else int(s) if re.fullmatch(r'\d+', s) else None
def parse_op(o):
    """-> (kind, expr, rest) for #expr, expr(an) and expr(an,dn.w); None for anything else"""
    m = re.match(r'^#(.+)$', o)
    if m: return ('#', m.group(1), '')
    m = re.match(r'^([^()]+)(\((?:a\d|sp)(?:,[^)]*)?\))$', o)
    if m: return ('d', m.group(1), m.group(2))
    return None
def scan(files):
    out = {}
    for f in files:
        L = open(f, encoding='latin-1').read().split('\n'); cur = None
        for i, l in enumerate(L):
            raw = l.split(';')[0].rstrip()
            if not raw: continue
            if raw[0] not in ' \t' and raw[0] != '.':
                m = re.match(r'^([A-Za-z_]\w*)\s*(.*)$', raw); cur = m.group(1); out.setdefault(cur, []); rest = m.group(2)
            elif raw[0] == '.': rest = re.match(r'^\.\w+\s*(.*)$', raw).group(1)
            else: rest = raw.strip()
            p = rest.split(None, 1)
            if cur is None or not p: continue
            op = p[0].lower()
            if op in ('include', 'incbin', 'equ', 'set', 'org', 'even', 'section', 'string') or op.startswith('dc.'): continue
            out[cur].append((f, i, op, SPLIT.split(p[1].replace(' ', '')) if len(p) > 1 else [], p[1] if len(p) > 1 else ''))
    return out
cart = scan(glob.glob(os.path.join(root, 'src/**/*94.asm'), recursive=True))
disc = scan(glob.glob(os.path.join(root, 'src/segacd/hockey/*.asm')))
votes = collections.defaultdict(collections.Counter)   # symbol -> Counter(disc value)
cand = []                                              # (file, line, old operand text, index, symbol, kind)
for r, a in cart.items():
    b = disc.get(r)
    if not b: continue
    sm = difflib.SequenceMatcher(None, [x[2] for x in a], [x[2] for x in b], autojunk=False)
    for tag, i1, i2, j1, j2 in sm.get_opcodes():
        if tag != 'equal': continue
        for k in range(i2 - i1):
            ca, da = a[i1 + k], b[j1 + k]
            if len(ca[3]) != len(da[3]): continue
            for idx, (x, y) in enumerate(zip(ca[3], da[3])):
                px, py = parse_op(x), parse_op(y)
                if not px or not py or px[0] != py[0] or px[2].split(',')[0] != py[2].split(',')[0]: continue
                sx, vy = px[1], num(py[1])
                if vy is None or not re.fullmatch(r'[A-Za-z_]\w*', sx) or sx.lower() not in CONST: continue
                if sx.lower() in RS or sx.lower() in LABELS and sx.lower() not in DISCDEF: continue
                if px[0] == 'd' and vy == 0: continue          # $0(a1) and (a1) are different encodings
                votes[sx][vy] += 1
                cand.append((da[0], da[1], idx, sx, vy))
ok = {}
for s, c in votes.items():
    if len(c) == 1 and sum(c.values()) >= MIN:
        v = next(iter(c))
        if s.lower() in DISCDEF and num(DISCDEF[s.lower()]) != v: continue
        ok[s] = v
edits = [e for e in cand if e[3] in ok]
print(f'{len(votes)} constant names seen, {len(ok)} agreed, {len(edits)} operand rewrites ({len(votes) - len(ok)} names left as numbers)')
if not APPLY: sys.exit(0)
cm = {}
for l in open(os.path.join(root, 'src/ram94.asm'), encoding='latin-1'):
    m = re.match(r'^(\w+)\s+equ\s+[^;]*;\s*(.*)$', l.rstrip())
    if m: cm[m.group(1).lower()] = m.group(2).strip()
new = [s for s in sorted(ok, key=lambda s: ok[s]) if s.lower() not in DISCDEF]
with open(os.path.join(root, 'src/segacd/ram94cd.asm'), 'a', encoding='latin-1') as f:
    f.write('\n; --- constants of the cartridge that the disc code uses, with the disc\'s values (the disc team struct differs: tmgoalie is $28) ---\n')
    for s in new: f.write(f'{s}\tequ\t${ok[s]:X}' + (f'\t\t\t;{cm[s.lower()]}' if cm.get(s.lower()) else '') + '\n')
byf = collections.defaultdict(dict)
for f, i, idx, s, v in edits: byf[f].setdefault(i, []).append((idx, s))
for f, d in byf.items():
    L = open(f, encoding='latin-1').read().split('\n')
    for i, lst in d.items():
        code, sep, cmt = L[i].partition(';')
        trail = code[len(code.rstrip()):]
        m = re.match(r'^([\w.]*\s*\S+\s+)(.*)$', code.rstrip())
        if not m: continue
        ops = SPLIT.split(m.group(2).replace(' ', ''))
        for idx, s in lst:
            px = parse_op(ops[idx])
            if px: ops[idx] = ('#' + s if px[0] == '#' else s + px[2])
        L[i] = m.group(1) + ','.join(ops) + trail + (sep + cmt if sep else '')
    open(f, 'w', encoding='latin-1').write('\n'.join(L))
print(f'{len(new)} constants defined in ram94cd.asm, {len(byf)} files rewritten')
