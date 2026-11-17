#!/usr/bin/env python3
"""Replace the generic comments written by segcd_dccomment.py by ones that describe the bytes themselves.

  python3 tools/segcd_dcrefine.py

For each auto comment ("; Data of X (n rows): ...") the run below it is parsed and classified: zero fill, text
(with the string), pointer table, ascending offset table, small byte/word table.  The comment keeps the owner routine,
the size and the first values."""
import glob, os, re, struct
root = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'); os.chdir(root)
AUTO = re.compile(r'^; (Data of (\S+)(?: \(\d+ rows?\))?: table or constants used by it\.|Data of (the file start)[^:]*: table or constants used by it\.)$')
DCROW = re.compile(r'^(?:\S*)\t(dc\.[bwl]|dcb\.[bwl])\t([^;]*)')
def parse(rows):
    vals = []; size = 1
    for r in rows:
        m = DCROW.match(r)
        if not m: return None
        k, body = m.group(1), m.group(2).strip()
        sz = {'b': 1, 'w': 2, 'l': 4}[k[-1]]
        if k.startswith('dcb'):
            a = body.split(',')
            try: n = int(a[0].replace('$', '0x'), 0); v = int(a[1].replace('$', '0x'), 0)
            except Exception: return None
            vals += [(v, sz)] * n; continue
        i = 0
        while i < len(body):
            if body[i] == "'":
                j = body.index("'", i + 1)
                vals += [(ord(c), 1) for c in body[i + 1:j]]; i = j + 1
            elif body[i] in ', \t': i += 1
            else:
                j = i
                while j < len(body) and body[j] not in ', \t': j += 1
                tok = body[i:j]
                try: v = int(tok.replace('$', '0x'), 0) if not tok.startswith('-') else int(tok.replace('$', '0x'), 0)
                except Exception: return None
                vals.append((v & ((1 << (8 * sz)) - 1), sz)); i = j
    return vals
def describe(owner, vals):
    n = len(vals); sz = vals[0][1] if vals else 1
    nb = sum(s for _, s in vals)
    allz = all(v == 0 for v, _ in vals)
    if allz: return '%d zero bytes after %s (padding or space the program fills at run time).' % (nb, owner)
    bs = b''.join(v.to_bytes(s, 'big') for v, s in vals)
    pr = sum(1 for x in bs if 32 <= x < 127 or x == 0)
    txt = ''.join(chr(x) if 32 <= x < 127 else '.' for x in bs)
    if nb >= 4 and sum(1 for x in bs if 32 <= x < 127) >= 0.6 * nb:
        return 'Text bytes after %s: "%s" (%d bytes).' % (owner, txt[:40], nb)
    if sz == 4 and all(0x1B000 <= v < 0x80000 or v == 0 for v, _ in vals):
        return 'Pointer table of %d entries after %s (addresses in the HOCKEY image).' % (n, owner)
    words = [v for v, s in vals if s == 2]
    if sz == 2 and n >= 4 and all(words[i] <= words[i + 1] for i in range(len(words) - 1)):
        return 'Ascending offset table of %d words after %s (%s ...).' % (n, owner, ','.join('$%04X' % x for x in words[:4]))
    if sz == 2 and n >= 3 and all(w in (0x0EEE, 0x0EEA, 0x0EE8) or (w & 0xF111) == 0 for w in words):
        return 'Palette data after %s: %d colour words (%s ...).' % (owner, n, ','.join('$%04X' % x for x in words[:4]))
    first = ','.join(('$%0*X' % (2 * s, v)) for v, s in vals[:6])
    kind = {1: 'byte', 2: 'word', 4: 'long'}[sz]
    return 'Table of %d %s%s after %s, %d bytes: %s ...' % (n, kind, 's' * (n != 1), owner, nb, first)
tot = 0
for p in ['hockey', 'main', 'player', 'starter']:
    for f in sorted(glob.glob('src/segacd/%s/*.asm' % p)):
        L = open(f, encoding='latin1').read().split('\n'); out = []; i = 0; ch = 0
        while i < len(L):
            m = AUTO.match(L[i])
            if m:
                j = i + 1; rows = []
                while j < len(L) and re.match(r'^\S*\t(dc|dcb)\.', L[j]) and (j == i + 1 or not re.match(r'^[A-Za-z_]', L[j])): rows.append(L[j]); j += 1
                v = parse(rows)
                if v:
                    out.append('; ' + describe(m.group(2) or m.group(3), v)); ch += 1; i += 1; continue
            out.append(L[i]); i += 1
        if ch: open(f, 'w', encoding='latin1').write('\n'.join(out)); tot += ch
print('refined', tot)
