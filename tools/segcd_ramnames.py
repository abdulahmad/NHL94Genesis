#!/usr/bin/env python3
"""segcd_ramnames.py: finds the cartridge variable name for each raw RAM address in the Sega CD HOCKEY source.

For every routine the disc shares with the cartridge it aligns the two instruction streams, and where a disc
operand is a raw address ($17F6C.l) and the cartridge operand at the same place is a variable name, that is one
vote. A name is accepted when every vote for an address agrees and there are at least --min of them.
  python3 tools/segcd_ramnames.py [REPO]            report
  python3 tools/segcd_ramnames.py [REPO] --apply    add the equates to src/segacd/hockey.inc, rewrite the sources
Check with `node tools/build.js --segacd` (MATCH) before committing."""
import re, glob, os, sys, difflib, collections
root = next((a for a in sys.argv[1:] if not a.startswith('--')), '.')
APPLY = '--apply' in sys.argv
MIN = int(next((a[6:] for a in sys.argv if a.startswith('--min=')), 2))
SPLIT = re.compile(r',(?![^(]*\))')

def scan(files):
    out = {}
    for f in files:
        cur = None
        for l in open(f, encoding='latin-1'):
            raw = l.split(';')[0].rstrip()
            if not raw: continue
            if raw[0] not in ' \t':
                m = re.match(r'^([A-Za-z_]\w*)', raw)
                if m: cur = m.group(1); out.setdefault(cur, []); rest = raw[len(cur):]
                else: rest = raw
            else:
                rest = re.sub(r'^\s*\.\w+', '', raw) if re.match(r'^\.\w+', raw) else raw
            m2 = re.match(r'^\.\w+(.*)$', raw)
            if m2: rest = m2.group(1)
            p = rest.split(None, 1)
            if cur is None or not p: continue
            op = p[0].lower()
            if op in ('include', 'incbin', 'equ', 'org', 'even', 'section') or op.startswith('dc.'): continue
            out[cur].append((op, SPLIT.split(p[1].replace(' ', '')) if len(p) > 1 else []))
    return out

cart = scan(glob.glob(os.path.join(root, 'src/*94.asm')))
disc = scan(glob.glob(os.path.join(root, 'src/segacd/hockey/*.asm')))
RAWD = re.compile(r'^(#?)\(?\$([0-9A-Fa-f]{4,5})\)?\.l$|^(#)\$([0-9A-Fa-f]{5})$')
# disc operand like ($17F6C).l or $17F6C.l or #$17F6C
RAW = re.compile(r'^(#?)\(?\$([0-9A-F]{4,5})\)?(\.l)?$')
NAME = re.compile(r'^(#?)\(?([A-Za-z_]\w*)\)?(\.[lw])?$')
votes = collections.defaultdict(collections.Counter)
for r, a in cart.items():
    b = disc.get(r)
    if not b: continue
    sm = difflib.SequenceMatcher(None, [x[0] for x in a], [x[0] for x in b], autojunk=False)
    for tag, i1, i2, j1, j2 in sm.get_opcodes():
        if tag != 'equal': continue
        for k in range(i2 - i1):
            ca, da = a[i1 + k][1], b[j1 + k][1]
            if len(ca) != len(da): continue
            for c, d in zip(ca, da):
                md, mc = RAW.match(d), NAME.match(c)
                if md and mc and md.group(1) == mc.group(1) and (d.endswith('.l') or md.group(1)):
                    votes[int(md.group(2), 16)][mc.group(2)] += 1
LABELS = set()
for _f in glob.glob(os.path.join(root, 'src/segacd/**/*.asm'), recursive=True):
    for _l in open(_f, encoding='latin-1'):
        _m = re.match(r'^([A-Za-z_]\w*)', _l)
        if _m and _l[0] not in ' \t;': LABELS.add(_m.group(1))
ok = {}
for addr, cn in votes.items():
    if len(cn) == 1 and sum(cn.values()) >= MIN and 0x17000 <= addr < 0x20000 and next(iter(cn)) not in LABELS:
        ok[addr] = next(iter(cn))
# addresses that hockey.inc already names get that name wherever they are still written raw
_inc = open(os.path.join(root, 'src/segacd/hockey.inc'), encoding='latin-1').read()
_eq = collections.defaultdict(list)
for _m in re.finditer(r'^(\w+)\s+equ\s+\$([0-9A-F]{5})\b', _inc, re.M): _eq[int(_m.group(2), 16)].append(_m.group(1))
for _a, _n in _eq.items():
    if len(_n) == 1 and 0x17000 <= _a < 0x20000 and _a not in ok: ok[_a] = _n[0]
# --lst PATH (the cartridge listing, output/obj/nhl94 .lst after `node tools/build.js retail`): the disc's RAM is the
# cartridge's moved by a different amount per block of variables. An address between two names that hockey.inc
# already has, both moved by the same amount, is the cartridge variable at (address - amount).
_lst = next((a[6:] for a in sys.argv if a.startswith('--lst=')), None)
if _lst:
    import bisect
    _cart = {}
    for _l in open(_lst, encoding='latin-1'):
        _m = re.match(r'^[0-9A-F]{8} =FFFF([0-9A-F]{4})\s+(\w+)\s+rs\.[bwl]\s+', _l)
        if _m: _cart[_m.group(2)] = int(_m.group(1), 16)
    _by = collections.defaultdict(list)
    for _n, _a in _cart.items(): _by[_a].append(_n)
    _known = sorted((_a, _a - _cart[_n]) for _n, _al in [(n, a) for a, ns in _eq.items() for n in ns] for _a in [_al] if _n in _cart)
    _keys = [k[0] for k in _known]
    _raw = set()
    for _f in glob.glob(os.path.join(root, 'src/segacd/hockey/*.asm')):
        for _l in open(_f, encoding='latin-1'):
            for _m in re.finditer(r'(?<![\w$])#?\(?\$([0-9A-F]{5})\)?(\.l)?(?!\w)', _l.split(';')[0]): _raw.add(int(_m.group(1), 16))
    _n2 = 0
    for _A in sorted(_raw):
        if not 0x17000 <= _A < 0x20000 or _A in ok: continue
        _i = bisect.bisect_left(_keys, _A)
        if not _i or _i >= len(_known) or _known[_i - 1][1] != _known[_i][1]: continue
        _c = _by.get(_A - _known[_i][1], [])
        if len(_c) == 1 and _c[0] not in LABELS: ok[_A] = _c[0]; _n2 += 1
    print(f'{_n2} more addresses from the cartridge block offsets')
print(f'{len(votes)} addresses with votes, {len(ok)} agreed (>= {MIN} votes), {len(votes) - len(ok)} left')
if not APPLY:
    for a, n in sorted(ok.items()): print(f'  ${a:X} {n}')
    sys.exit(0)
inc = os.path.join(root, 'src/segacd/hockey.inc')
have = set(re.findall(r'^(\w+)\s+equ', open(inc, encoding='latin-1').read(), re.M))
cm = {}
for l in open(os.path.join(root, 'src/ram94.asm'), encoding='latin-1'):
    m = re.match(r'^(\w+)\s+(?:rs\.\w|equ)\s+[^;]*;\s*(.*)$', l.rstrip())
    if m: cm[m.group(1)] = m.group(2).strip()
add = []
for a, n in sorted(ok.items()):
    if n in have: ok[a] = n; continue
    add.append(f'{n}\tequ\t${a:X}\t\t\t;{cm.get(n, "")}'.rstrip())
    have.add(n)
with open(inc, 'a', encoding='latin-1') as f:
    f.write('\n; --- variables named from the cartridge twin of each routine (tools/segcd_ramnames.py) ---\n' + '\n'.join(add) + '\n')
pat = re.compile(r'(?<![\w$])(#?)\(?\$([0-9A-F]{4,5})\)?(\.l)?(?![\w])')
def sub(m):
    a = int(m.group(2), 16)
    if a not in ok: return m.group(0)
    if m.group(1): return '#' + ok[a]
    return '(' + ok[a] + ').l' if m.group(3) else m.group(0)
n = 0
for f in glob.glob(os.path.join(root, 'src/segacd/hockey/*.asm')):
    L = open(f, encoding='latin-1').read().split('\n'); ch = False
    for i, l in enumerate(L):
        code, sep, cmt = l.partition(';')
        if not re.match(r'^[\w.]*\s+[a-z]', code) and not code.startswith(('\t', ' ')): continue
        m = re.match(r'^([\w.]*\s+\S+\s+)(.*)$', code)
        if not m: continue
        new = m.group(1) + pat.sub(sub, m.group(2))
        if new != code: L[i] = new + sep + cmt; ch = True; n += 1
    if ch: open(f, 'w', encoding='latin-1').write('\n'.join(L))
print(f'{n} lines rewritten, {len(add)} equates added')
