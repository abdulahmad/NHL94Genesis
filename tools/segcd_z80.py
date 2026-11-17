#!/usr/bin/env python3
"""Disassemble the Sega CD Z80 sound driver in MAIN.BIN into commented dc.b rows.

  python3 tools/segcd_z80.py [--names FILE.json] > src/segacd/main/z80driver.asm

The driver is the Z80 program the main CPU uploads to Z80 RAM at $0000 ($5E0C in MAIN.BIN up to $76C8).  Code is
found from the entry points ($0000, the interrupt vectors, the jump table at $44) through jr / jp / call / djnz; gaps
that decode cleanly to their end are code too, the rest is data.  Every code row is `dc.b` with the Z80 mnemonic."""
import json, os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import z80dis as Z
root = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'); os.chdir(root)
START, END = 0x5E0C, 0x765C
d = open('cdbin/MAIN.BIN', 'rb').read()
b = d[START:END] + b'\0' * 8
n = END - START
names = json.load(open(sys.argv[sys.argv.index('--names') + 1])) if '--names' in sys.argv else {}
code = {}; todo = [0] + [x for x in (0x38, 0x66) if b[x]] + [0x600]
todo += [b[a + 1] | (b[a + 2] << 8) for a in range(0, 0x100, 4) if b[a] == 0xC3]
seen = set()
for a in range(0, 0x100, 4):   # the vector table: jp xxxx, nop
    if b[a] == 0xC3:
        code[a] = Z.dis(b, a, a); code[a + 3] = (1, 'nop', None)[0:3]
while todo:
    a = todo.pop()
    while 0 <= a < n and a not in code:
        l, t, tg = Z.dis(b, a, a)
        if t.startswith('db'): break
        code[a] = (l, t, tg)
        if tg is not None and 0 <= tg < n: todo.append(tg)
        if t.startswith(('ret', 'jp $', 'jr $', 'reti', 'retn')) and not re.match(r'^(ret|jp|jr) (nz|z|nc|c|po|pe|p|m),', t): break
        if t.startswith('jp ('): break
        a += l
# gaps decode as code when clean
def covered(): 
    c = bytearray(n)
    for a, (l, t, tg) in code.items():
        for k in range(a, a + l): c[k] = 1
    return c
cov = covered(); a = 0
while a < n:
    if cov[a]: a += 1; continue
    e = a
    while e < n and not cov[e]: e += 1
    o = a; tmp = {}; ok = True
    while o < e:
        l, t, tg = Z.dis(b, o, o)
        if t.startswith('db') or o + l > e or t in ('nop', 'halt') or (tg is not None and not (0 <= tg < n)): ok = False; break
        tmp[o] = (l, t, tg); o += l
    if ok and len(tmp) >= 3 and list(tmp.values())[-1][1].startswith(('ret', 'jp', 'jr')): code.update(tmp)
    a = e
cov = covered()
labs = {0: 'Z80SoundDriver'}
for a, (l, t, tg) in code.items():
    if tg is not None and tg in code and t.startswith('call'): labs.setdefault(tg, None)
for a in (0x600, 0x62C): labs.setdefault(a, None)
for a in range(0, 0x100, 4):
    if b[a] == 0xC3 and (b[a + 1] | (b[a + 2] << 8)) in code: labs.setdefault(b[a + 1] | (b[a + 2] << 8), None)
# branch targets inside a routine get local-style names like the 68000 sources: .loop for a backward target, .next forward
owner_of = lambda x: max([k for k in labs if k <= x] or [0])
inner = {}
for a, (l, t, tg) in sorted(code.items()):
    if tg is not None and tg in code and tg not in labs and not t.startswith('call'):
        inner.setdefault(tg, 'loop' if tg <= a else 'next')
cnt = {}
loc = {}
for tg in sorted(inner):
    o = owner_of(tg); k = inner[tg]; cnt[(o, k)] = cnt.get((o, k), 0) + 1
    loc[tg] = '.' + k + (str(cnt[(o, k)]) if cnt[(o, k)] > 1 else '')
lab = {}
for a in sorted(labs):
    lab[a] = names.get('%04X' % a, ['Z80_%04X' % a, ''])[0] if a else 'Z80SoundDriver'
lab.update(loc)
def tx(t):
    return re.sub(r'\$([0-9A-F]{4})\b', lambda m: lab.get(int(m.group(1), 16), m.group(0)) if int(m.group(1), 16) in lab and re.match(r'^(jp|jr|djnz|call)', t) else m.group(0), t)
out = ['; Z80 sound driver: the program the main CPU uploads to Z80 RAM at $0000 (file $%X-$%X in MAIN.BIN, Z80 address 0 = $%X).' % (START, END, START),
       '; Rows are the exact bytes; the comment is the Z80 instruction at that Z80 address.']
a = 0
while a < n:
    if a in lab:
        if a in names and names[a if isinstance(a, str) else '%04X' % a][1]: pass
        c = names.get('%04X' % a, [None, ''])[1]
        if c: out.append('; ' + c)
        out.append(lab[a])
    if a in code:
        l, t, tg = code[a]
        out.append('\tdc.b\t%s\t\t; $%04X %s' % (','.join('$%02X' % x for x in b[a:a + l]), a, tx(t))); a += l
    else:
        e = a
        while e < n and e not in code and (e == a or e not in lab) and e - a < 16: e += 1
        z = a
        while z < n and z not in code and b[z] == 0 and (z == a or z not in lab): z += 1
        if z - a >= 16:
            out.append('\tdcb.b\t$%X,0\t\t; $%04X zero fill' % (z - a, a)); a = z; continue
        out.append('\tdc.b\t%s\t\t; $%04X data' % (','.join('$%02X' % x for x in b[a:e]), a)); a = e
print('\n'.join(out))
