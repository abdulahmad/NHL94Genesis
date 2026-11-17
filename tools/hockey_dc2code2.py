#!/usr/bin/env python3
"""Turn dc.w lines holding one whole non-branch instruction back into code (names from the last listing and
hockey.inc). The caller builds and compares; lines that break the match are reverted by git."""
import re, glob, sys
sys.path.insert(0, 'tools')
import emit_m68k as E
import emit_hockey as H
lst = open('output/obj/hockey .lst', errors='replace').read().split('\n')
lab = {}
for l in lst:
    m = re.match(r'^([0-9A-F]{8}) {20,}([A-Za-z_]\w*)(\s|$)', l)
    if m and not m.group(2).startswith('.'):
        lab.setdefault(int(m.group(1), 16), m.group(2))
names = H.load_names('src/segacd/hockey.inc')
n = 0
for f in sorted(glob.glob('src/segacd/hockey/gen_*.asm')):
    L = open(f).read().split('\n')
    for i, l in enumerate(L):
        m = re.match(r'^(\S*)\tdc\.w\t((?:\$[0-9A-F]{4},?){2,5})(\t;.*)?$', l)
        if not m: continue
        ws = re.findall(r'\$([0-9A-F]{4})', m.group(2))
        b = bytes.fromhex(''.join(ws))
        got = None
        for ins in E.md.disasm(b + b'\0' * 8, 0):
            got = ins; break
        if got is None or got.size != len(b): continue
        mn = got.mnemonic.split('.')[0]
        if mn in E.BRANCH or mn in ('ori', 'illegal', 'dc') or got.mnemonic.startswith('ori.b'): continue
        text = E.snasm_op(got, {}, 0)
        def nm(mm):
            v = int(mm.group(1), 16)
            if v in names: return '(%s).l' % names[v]
            if v in lab: return '(%s).l' % lab[v]
            return mm.group(0)
        text2 = re.sub(r'\$([0-9A-F]+)\.[Ll]', nm, text)
        mnem = got.mnemonic
        if mn in ('btst', 'bclr', 'bset', 'bchg') and re.search(r',(?!d[0-7]$)', text2.replace(' ', '')): mnem = mn
        L[i] = '%s\t%s\t%s%s' % (m.group(1), mnem, text2, m.group(3) or '')
        n += 1
    open(f, 'w').write('\n'.join(L))
print('converted', n)
