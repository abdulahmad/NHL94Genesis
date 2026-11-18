#!/usr/bin/env python3
"""Replace HOCKEY dc rows by the cartridge's source rows for the same label when the bytes are identical.

  python3 tools/segcd_cartdc.py          (needs output/obj/hockey .lst from a build and /tmp/w/nhl94.lst, the cartridge listing)

A disc label that is also a cartridge label and is followed by dc rows: if the cartridge rows between that label and the
next label are plain data (dc.b/dc.w/dc.l/dcb with numbers or arithmetic only, no symbols) and assemble to the same bytes
as the disc rows, the disc rows are replaced by the cartridge text (formulas, comments)."""
import glob, os, re, sys
root = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'); os.chdir(root)
CART = os.environ.get('CART_LST', '/tmp/w/nhl94.lst')
d = open('cdbin/HOCKEY.BIN', 'rb').read(); rom = open('nhl94retail.bin', 'rb').read(); base = 0x1B000
caddr = {}
for l in open(CART, errors='replace').read().replace('\r', '').split('\n'):
    m = re.match(r'^([0-9A-F]{8}) (?:[0-9A-F]{2,4} ?)*[+ ]+([A-Za-z_]\w*):?(?:\t|$)', l)
    if m: caddr.setdefault(m.group(2), int(m.group(1), 16))
csrc = {}
for f in glob.glob('src/**/*94.asm', recursive=True):
    L = open(f, encoding='latin1').read().split('\n')
    for i, t in enumerate(L):
        m = re.match(r'^([A-Za-z_]\w*)(?=[\s:]|$)', t)
        if m and m.group(1) in caddr and m.group(1) not in csrc:
            j = i + 1; rows = [t]
            while j < len(L) and re.match(r'^\s*(dc\.[bwl]|dcb\.[bwl])\s', L[j]): rows.append(L[j]); j += 1
            csrc[m.group(1)] = rows
dlab = {}
for l in open('output/obj/hockey .lst', errors='replace').read().replace('\r', '').split('\n'):
    m = re.match(r'^([0-9A-F]{8}) (?:[0-9A-F]{2,4} ?)*[+ ]+([A-Za-z_]\w*):?(?:\t|$)', l)
    if m: dlab.setdefault(m.group(2), int(m.group(1), 16))
SYM = re.compile(r"(?<![\$\w])[A-Za-z_]\w*")
total = 0
for f in sorted(glob.glob('src/segacd/hockey/*.asm')):
    if 'teamdata' in f: continue
    L = open(f, encoding='latin1').read().split('\n'); out = []; i = 0; ch = 0
    while i < len(L):
        t = L[i]; m = re.match(r'^([A-Za-z_]\w*)(?=[\s:]|$)', t)
        if m and i + 1 < len(L) and re.match(r'^; (Data of|Text of|Inline data|Instruction bytes)', L[i + 1]) and i + 2 < len(L) and re.match(r'^\s+(dc|dcb)\.', L[i + 2]): del L[i + 1]
        if m and m.group(1) in csrc and m.group(1) in dlab and re.search(r'\t(dc|dcb)\.', t) or (m and m.group(1) in csrc and m.group(1) in dlab and i + 1 < len(L) and re.match(r'^\s*(dc|dcb)\.', L[i + 1])):
            nm = m.group(1); j = i + 1
            while j < len(L) and re.match(r'^\s*(dc|dcb)\.[bwl]', L[j]) and not L[j].startswith(tuple('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_')): j += 1
            if re.search(r'\t(dc|dcb)\.', t): j = max(j, i + 1)
            rows = csrc[nm]
            body = [r.split(';')[0] for r in rows[1:]] + [rows[0].split(';')[0].split(None, 1)[1] if len(rows[0].split(';')[0].split(None, 1)) > 1 else '']
            if any(SYM.search(re.sub(r"'[^']*'", '', x).replace('dc.b', '').replace('dc.w', '').replace('dc.l', '').replace('dcb.b', '').replace('dcb.w', '')) for x in body): out.append(t); i += 1; continue
            # sizes: disc bytes until the next disc label vs cartridge bytes until its next label
            nxt = min([a for k, a in dlab.items() if a > dlab[nm]] or [None], default=None)
            cn = min([a for k, a in caddr.items() if a > caddr[nm]] or [None], default=None)
            if nxt is None or cn is None or nxt - dlab[nm] != cn - caddr[nm]: out.append(t); i += 1; continue
            ln = nxt - dlab[nm]
            if d[dlab[nm] - base:dlab[nm] - base + ln] != rom[caddr[nm]:caddr[nm] + ln]: out.append(t); i += 1; continue
            out.extend(rows); ch += 1
            # skip the disc rows of this label
            i += 1
            while i < len(L) and re.match(r'^\s+(dc|dcb)\.[bwl]\s', L[i]): i += 1
            continue
        out.append(t); i += 1
    if ch: open(f, 'w', encoding='latin1').write('\n'.join(out)); total += ch; print(f, ch)
print('tables replaced', total)
