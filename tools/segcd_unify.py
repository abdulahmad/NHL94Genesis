#!/usr/bin/env python3
"""segcd_unify.py: where a Sega CD HOCKEY instruction lines up with the same instruction in its cartridge twin and only
the operand text differs (#$4 against #gmhl, $28(a3) against Xvel(a3), $3 against 3), the disc line takes the
cartridge's operand text. Values are equal by construction because both builds read equates94.asm; the Sega CD build
(`node tools/build.js --segacd`, MATCH) is the proof.
  python3 tools/segcd_unify.py [REPO] [--apply] [--only=FILE,FILE]"""
import re, glob, os, sys, difflib
root = next((a for a in sys.argv[1:] if not a.startswith('--')), '.')
APPLY = '--apply' in sys.argv
BLOCK = set()
for _a in sys.argv:
    if _a.startswith('--block='): BLOCK = set(x.lower() for x in open(_a[8:]).read().split())
ONLY = next((a[7:].split(',') for a in sys.argv if a.startswith('--only=')), None)
SPLIT = re.compile(r',(?![^(]*\))')
NUM = re.compile(r'^#?[-(]*\$?[0-9A-Fa-f]+\)?(\([a-z0-9,.]+\))?$|^#?\$?[0-9A-Fa-f]+\([a-z0-9]+\)$')
def kind(o):
    if o.startswith('#'): return '#'
    m = re.match(r'^[^()]*\((a\d|sp)(,.*)?\)$', o)
    return 'd' + m.group(1) if m else ('r' if re.match(r'^[ad]\d$', o) else 'o')
def scan(files):
    out = {}
    for f in files:
        L = open(f, encoding='latin-1').read().split('\n'); cur = None
        for i, l in enumerate(L):
            raw = l.split(';')[0].rstrip()
            if not raw: continue
            if raw[0] not in ' \t' and raw[0] != '.':
                m = re.match(r'^([A-Za-z_]\w*)\s*(.*)$', raw); cur = m.group(1); out.setdefault(cur, []); rest = m.group(2)
            elif raw[0] == '.':
                m = re.match(r'^\.\w+\s*(.*)$', raw); rest = m.group(1)
            else: rest = raw.strip()
            p = rest.split(None, 1)
            if cur is None or not p: continue
            op = p[0].lower()
            if op in ('include', 'incbin', 'equ', 'org', 'even', 'section') or op.startswith('dc.'): continue
            out[cur].append((f, i, op, p[1].replace(' ', '') if len(p) > 1 else '', p[1] if len(p) > 1 else ''))
    return out
# --lst=PATH: the cartridge listing; a rewrite is only made when the cartridge's operand has the same value as the
# disc's number (the Sega CD team struct and some sound numbers differ from the cartridge's)
VAL = {}
for _a in sys.argv:
    if _a.startswith('--lst='):
        for _l in open(_a[6:], encoding='latin-1'):
            _m = re.match(r'^[0-9A-F]{8} =([0-9A-F]{8})\s+(\w+)\s+(equ|set|rs\.\w)\b', _l)
            if _m: VAL[_m.group(2).lower()] = int(_m.group(1), 16)
def value(o):
    m = re.match(r'^#?(.*?)(\((?:a\d|sp)(?:,.*)?\))?$', o)
    e = m.group(1)
    if e == '': return 0
    e = re.sub(r'\$([0-9A-Fa-f]+)', lambda x: str(int(x.group(1), 16)), e)
    def idr(x):
        v = VAL.get(x.group(0).lower())
        return str(v) if v is not None else 'None'
    e = re.sub(r'[A-Za-z_]\w*', idr, e)
    try: return eval(e, {'None': None}) & 0xFFFFFFFF
    except Exception: return None
cart = scan(glob.glob(os.path.join(root, 'src/*94.asm')))
disc = scan(glob.glob(os.path.join(root, 'src/segacd/hockey/*.asm')))
edits = {}  # (file,line) -> (old operand, new operand)
for r, a in cart.items():
    b = disc.get(r)
    if not b: continue
    sm = difflib.SequenceMatcher(None, [x[2] for x in a], [x[2] for x in b], autojunk=False)
    for tag, i1, i2, j1, j2 in sm.get_opcodes():
        if tag != 'equal': continue
        for k in range(i2 - i1):
            ca, da = a[i1 + k], b[j1 + k]
            if ca[3] == da[3]: continue
            co, do = SPLIT.split(ca[3]), SPLIT.split(da[3])
            if len(co) != len(do): continue
            ok = True; out = []
            for x, y in zip(co, do):
                xn = re.sub(r'\.(w|l)$', '', x); yn = re.sub(r'\.(w|l)$', '', y)
                if x == y or xn == yn: out.append(y); continue
                if re.match(r'^\$?0\(', y): ok = False; break   # $0(a1) is a 4 byte form, (a1) a 2 byte one
                if kind(x) != kind(y) or kind(y) not in ('#', 'da0', 'da1', 'da2', 'da3', 'da4', 'da5', 'da6', 'da7') or not NUM.match(y) or ca[2] in ('string',) or '"' in ca[4] or "'" in ca[4]: ok = False; break  # labels stay
                if not x.startswith('#') and re.match(r'^[0-9A-Fa-f$]+$', x): ok = False; break
                if VAL and value(x) != value(y): ok = False; break
                out.append(x)
            if ok and BLOCK & {t.lower() for t in re.findall(r'[A-Za-z_]\w*', ','.join(out))}: ok = False
            if ok and ','.join(out) != da[3]:
                edits[(da[0], da[1])] = (da[4], ','.join(out))
import json
for _a in sys.argv:
    if _a.startswith('--dump='): json.dump([[f, i, o, n] for (f, i), (o, n) in edits.items()], open(_a[7:], 'w'))
    if _a.startswith('--from='): edits = {(f, i): (o, n) for f, i, o, n in json.load(open(_a[7:]))}
print(len(edits), 'operand rewrites')
if ONLY: edits = {k: v for k, v in edits.items() if os.path.basename(k[0]) in ONLY}
if APPLY:
    byf = {}
    for (f, i), v in edits.items(): byf.setdefault(f, {})[i] = v
    for f, d in byf.items():
        L = open(f, encoding='latin-1').read().split('\n')
        for i, (old, new) in d.items():
            code, sep, cm = L[i].partition(';')
            if old in code: L[i] = code.replace(old, new, 1) + sep + cm
        open(f, 'w', encoding='latin-1').write('\n'.join(L))
    print('applied to', len(byf), 'files')
