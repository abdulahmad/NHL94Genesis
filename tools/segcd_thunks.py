#!/usr/bin/env python3
"""Annotate the 68020 arithmetic thunks (mulu.l / divs.l ... behind `bra.s`) in the Sega CD sources.

  python3 tools/segcd_thunks.py main|starter

The SNASM68k assembler has no 68020 mnemonics, so the bytes stay dc.w, but every instruction gets its own row with the
decoded mnemonic as a comment (4C4x = mul/div .l, decoded here; everything else by Capstone)."""
import os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import segcd_flow as F
root = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'); os.chdir(root)
prog = sys.argv[1]
def parse(rows):
    b = bytearray()
    for r in rows:
        body = r.split(';')[0] if not r.split(';')[0].count("'") % 2 else r
        m = re.search(r'dc\.b\t(.*?)(?:\t;.*)?$', r)
        s = m.group(1); i = 0
        while i < len(s):
            if s[i] == '$': b.append(int(s[i + 1:i + 3], 16)); i += 3
            elif s[i] == "'":
                j = s.index("'", i + 1)
                b.extend(s[i + 1:j].encode('latin1')); i = j + 1
            else: i += 1
    return bytes(b)
REG = lambda n: 'd%d' % n
def dec020(b, o):
    w = int.from_bytes(b[o:o + 2], 'big')
    if (w & 0xFFC0) in (0x4C00, 0x4C40) and (w & 0x38) == 0 and o + 4 <= len(b):
        e = int.from_bytes(b[o + 2:o + 4], 'big')
        if e & 0x8000: return None
        dl = (e >> 12) & 7; sg = bool(e & 0x800); big = bool(e & 0x400); dh = e & 7
        src = 'd%d' % (w & 7)
        if (w & 0xFFC0) == 0x4C00:
            return 4, '%s.l %s,%s%s' % ('muls' if sg else 'mulu', src, ('d%d:' % dh if big else ''), REG(dl))
        return 4, '%s.l %s,%s%s' % ('divs' if sg else 'divu', src, ('d%d:' % dh if big else ''), REG(dl)) if big or True else None
    return None
for fn in sorted(os.listdir('src/segacd/' + prog)):
    if not fn.endswith('.asm'): continue
    p = 'src/segacd/%s/%s' % (prog, fn)
    L = open(p, encoding='latin1').read().split('\n'); out = []; i = 0; ch = 0
    while i < len(L):
        t = L[i]
        if re.match(r'^\tdc\.w\t\$4EF0,\$92FE', t):
            out.append(t + '\t\t; jmp -$2(a0,a1.w): enters the code that follows'); i += 1
            j = i
            while j < len(L) and re.match(r'^(\.\w+)?\tdc\.b\t', L[j]): j += 1
            lab = L[i].split('\t')[0]
            raw = parse(L[i:j]); o = 0; first = True
            while o < len(raw):
                l_ = lab if first else ''; first = False
                r = dec020(raw, o)
                if r: n, txt = r
                else:
                    g = F.decode_at(raw + b'\0' * 8, o, 0)
                    if g is None or o + g.size > len(raw): n, txt = min(2, len(raw) - o), 'data'
                    else: n, txt = g.size, g.mnemonic + ' ' + g.op_str
                words = ','.join('$%04X' % int.from_bytes(raw[q:q + 2], 'big') for q in range(o, o + n - n % 2, 2))
                if n % 2: words += (',' if words else '') + '$%02X00' % raw[o + n - 1]; assert False
                out.append('%s\tdc.w\t%s\t\t; %s' % (l_, words, txt)); o += n
            i = j; ch += 1; continue
        out.append(t); i += 1
    if ch: open(p, 'w', encoding='latin1').write('\n'.join(out)); print(fn, ch)
