#!/usr/bin/env python3
"""Turn code left as dc.w that loads from a data label (move.w Label(pc),d0 ...) into instructions.

  python3 tools/segcd_pcrel.py <main|player|starter>     (needs a build: output/obj/<dir> .lst)
Decodes the words with capstone, finds the data label at the pc-relative target in the listing and
writes `move.w Label+off(pc),d0`.  Rows that do not match their bytes after the build are the caller's
job to put back (the build fails and says where)."""
import sys, re, os, bisect, glob
from capstone import Cs, CS_ARCH_M68K, CS_MODE_M68K_000
D = sys.argv[1]
root = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')
src = os.path.join(root, 'src') + '/'
inc = [l.split()[1].replace('\\', '/') for l in open(src + 'segacd/' + D + '.asm')
       if l.strip().startswith('include') and 'macros' not in l]
files = [src + i for i in inc]
lst = open(os.path.join(root, 'output/obj/%s .lst' % D), errors='replace').read().split('\n')
dcw = []   # (addr, bytes, operand)
labs = {}
for l in lst:
    m = re.match(r'^([0-9A-F]{8}) ((?:[0-9A-F]{2,4} ?)*)\s+(\S+)?\t', l)
    if not m: continue
    name = m.group(3)
    if name and not name.startswith('.') and name not in ('dc.w', 'dc.b', 'dc.l') and re.match(r'^[A-Za-z_]\w*$', name) and not re.match(r'^[a-z]+(\.[bwl])?$', name):
        labs.setdefault(int(m.group(1), 16), name)
    m2 = re.match(r'^([0-9A-F]{8}) ((?:[0-9A-F]{4} ?)+)\s+(?:\S+)?\tdc\.w\t(.*)$', l)
    if m2:
        dcw.append((int(m2.group(1), 16), bytes.fromhex(m2.group(2).replace(' ', '')), m2.group(3).split(';')[0].strip()))
addrs = sorted(labs)
md = Cs(CS_ARCH_M68K, CS_MODE_M68K_000)
def label_for(t):
    i = bisect.bisect_right(addrs, t) - 1
    if i < 0: return None
    a = addrs[i]
    off = t - a
    if off > 0x400: return None
    return labs[a] + ('+$%X' % off if off else '')
k = 0; conv = 0
for f in files:
    L = open(f).read().split('\n'); out = []
    prev_ins = False
    for l in L:
        m = re.match(r'^(\S*)\tdc\.w\t(.*?)(\s*;.*)?$', l) if False else re.match(r'^([A-Za-z_.]\w*)?\tdc\.w\t([^;]*?)\s*(;.*)?$', l)
        if m:
            addr, by, opd = dcw[k]; k += 1
            assert opd == m.group(2).strip(), (f, l, opd)
            ins = list(md.disasm(by, addr))
            if prev_ins and len(ins) == 1 and ins[0].size == len(by) and '(pc)' in ins[0].op_str:
                i = ins[0]
                mm = re.search(r'\$([0-9a-f]+)\(pc\)', i.op_str)
                t = int(mm.group(1), 16)
                lb = label_for(t)
                if lb:
                    ops = i.op_str.replace(mm.group(0), lb + '(pc)')
                    ops = re.sub(r', ', ',', ops)
                    ops = re.sub(r'\(a(\d), d(\d)\.w\)', r'(a\1,d\2.w)', ops)
                    mn = i.mnemonic
                    if mn == 'movea': mn = 'movea.l' if False else mn
                    out.append((m.group(1) or '') + '\t' + mn + '\t' + ops + (('\t' + m.group(3)) if m.group(3) else ''))
                    conv += 1; prev_ins = True
                    continue
            out.append(l); prev_ins = False
            continue
        body = l.split(';')[0].strip().split()
        if body and not l.startswith(';'):
            op = body[1] if len(body) > 1 and not l.startswith(('\t', ' ')) else body[0]
            prev_ins = not op.startswith(('dc', 'incbin', 'opt', 'include', 'org', 'equ', 'even'))
        out.append(l)
    open(f, 'w').write('\n'.join(out))
print(D, 'converted', conv, 'of', k)
# second pass: Label+$N(pc) that now has an exact label
byname = {v: k for k, v in labs.items()}
fixed = 0
for f in files:
    t = open(f).read()
    def rep(m):
        global fixed
        a = byname.get(m.group(1))
        if a is None: return m.group(0)
        n = label_for(a + int(m.group(2), 16))
        if n and n != m.group(1) + '+$' + m.group(2):
            fixed += 1; return n + '(pc)'
        return m.group(0)
    t2 = re.sub(r'\b([A-Za-z_]\w*)\+\$([0-9A-F]+)\(pc\)', rep, t)
    if t2 != t: open(f, 'w').write(t2)
print('exact', fixed)
