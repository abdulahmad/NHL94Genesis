#!/usr/bin/env python3
"""Pair cartridge routines with their HOCKEY.BIN twins.

The cartridge listing (output/obj/nhl94 .lst, written by `node tools/build.js retail`)
gives each global label and its address. Each routine is disassembled from the retail
ROM, reduced to a shape (mnemonic family + operands with numbers removed, because the
disc uses long absolute addresses, addi for addq and word branches), and searched in
HOCKEY.BIN. A routine is paired when its whole shape sequence occurs once, or when
only one occurrence lies after the previous paired routine (the disc keeps the order).

  python3 tools/hockey_pair.py output/nhl94.bin cdbin/HOCKEY.BIN "output/obj/nhl94 .lst" > pairs.csv

Output lines: cartridge_addr,disc_file_offset,name,cart_len,disc_len
"""
import re
import sys
from collections import defaultdict

from capstone import Cs, CS_ARCH_M68K, CS_MODE_BIG_ENDIAN, CS_MODE_M68K_000

md = Cs(CS_ARCH_M68K, CS_MODE_M68K_000 | CS_MODE_BIG_ENDIAN)
FAM = {"addq": "add", "addi": "add", "subq": "sub", "subi": "sub", "movea": "move", "cmpi": "cmp", "cmpa": "cmp",
       "adda": "add", "suba": "sub", "andi": "and", "ori": "or", "eori": "eor", "bra": "bra", "bsr": "bsr"}


def shape(insn):
    mn = insn.mnemonic.split(".")[0]
    mn = FAM.get(mn, mn)
    op = insn.op_str
    op = re.sub(r"\.[wl]\b", "", op)
    op = re.sub(r"#?\$[0-9a-f]+", "N", op)
    op = re.sub(r"\b\d+\b", "N", op)
    if mn.startswith(("b", "db")) and mn not in ("btst", "bclr", "bset", "bchg", "bfextu"):
        op = "N" if "(" not in op and "d" not in op[:2] else op
    return mn + " " + op


def decode(blob, start, end, base=0):
    out, pc = [], start
    while pc < end:
        got = None
        for i in md.disasm(blob[pc:pc + 12], pc + base):
            got = i
            break
        if got is None or got.size < 2 or pc + got.size > end:
            break
        out.append(got)
        pc += got.size
    return out, pc


def routines_from_listing(path):
    """global code labels: (address, name). A label counts when the next line at its address is an instruction."""
    L = open(path, errors="replace").read().split("\n")
    out = []
    for i, ln in enumerate(L):
        m = re.match(r"^([0-9A-F]{8}) {20,}([A-Za-z_]\w*)(\s|$)", ln)
        if not m:
            continue
        a = int(m.group(1), 16)
        if a >= 0x100000:
            continue
        for l2 in L[i + 1:i + 14]:
            m2 = re.match(r"^([0-9A-F]{8}) ([0-9A-F ]{4,}?)\s+([a-z]\w*)", l2)
            if m2 and int(m2.group(1), 16) == a:
                if m2.group(3) not in ("dc", "ds", "incbin", "rs", "equ", "String", "org", "even"):
                    out.append((a, m.group(2)))
                break
    return out


def main():
    rom = open(sys.argv[1], "rb").read()
    disc = open(sys.argv[2], "rb").read()
    labs = sorted(set(routines_from_listing(sys.argv[3])))
    # disc stream: every even offset decoded linearly is wrong; index shape windows lazily.
    # Build a disc index by decoding from each candidate start (offset of an even byte) is too slow,
    # so decode the disc as one linear stream per alignment class from the known code entry.
    dshapes, doffs = [], []
    pc = 0
    while pc < len(disc) - 2:
        got = None
        for i in md.disasm(disc[pc:pc + 12], pc):
            got = i
            break
        if got is None or got.size < 2:
            pc += 2
            continue
        dshapes.append(shape(got))
        doffs.append(pc)
        pc += got.size
    K = 8
    idx = defaultdict(list)
    for i in range(len(dshapes) - K):
        idx[tuple(dshapes[i:i + K])].append(i)
    prep = []
    labs = [(a, nm) for a, nm in labs if len(nm) > 2 and nm != 'incbin']
    for n, (a, name) in enumerate(labs):
        nxt = labs[n + 1][0] if n + 1 < len(labs) else a + 2
        if nxt <= a:
            prep.append(None)
            continue
        ins, _ = decode(rom, a, nxt)
        term = [k for k, i in enumerate(ins) if i.mnemonic.split('.')[0] in ('rts', 'rte', 'jmp', 'bra')]
        if term:
            ins = ins[:term[-1] + 1]
        prep.append((a, name, nxt, [shape(i) for i in ins]))
    res = {}   # label index -> (disc stream index, exact)
    last = 0
    for n, pr in enumerate(prep):
        if pr is None:
            continue
        a, name, nxt, sh = pr
        if len(sh) < K:
            continue
        cands = idx.get(tuple(sh[:K]), [])
        good = [c for c in cands if dshapes[c:c + len(sh) - 2] == sh[:len(sh) - 2]]
        if not good:
            continue
        after = [c for c in good if doffs[c] >= last]
        pick = good[0] if len(good) == 1 else (after[0] if len(after) == 1 else None)
        if pick is None:
            continue
        last = doffs[pick]
        res[n] = (pick, True)
    # second pass: a routine the CD changed keeps its first instructions; accept a unique prefix
    # match between the disc positions of its paired neighbours (the disc keeps the cartridge order)
    K2 = 5
    idx2 = defaultdict(list)
    for i in range(len(dshapes) - K2):
        idx2[tuple(dshapes[i:i + K2])].append(i)
    for _ in range(0):
        changed = False
        paired = sorted(res)
        for n, pr in enumerate(prep):
            if pr is None or n in res or len(pr[3]) < K2:
                continue
            lo = max([doffs[res[m][0]] for m in paired if m < n] or [0])
            hi = min([doffs[res[m][0]] for m in paired if m > n] or [10 ** 9])
            c = [x for x in idx2.get(tuple(pr[3][:K2]), []) if lo < doffs[x] < hi]
            if len(c) == 1:
                res[n] = (c[0], False)
                changed = True
        if not changed:
            break
    # third pass: align the disc code between two paired routines with the cartridge code between
    # the same two routines (difflib on shapes); a cartridge routine whose first instruction lands in
    # a matching block is paired. This names routines the CD changed.
    import difflib
    rom_ins = {}
    for _ in range(1):
        order0 = sorted(((doffs[v[0]], n) for n, v in res.items()))
        for j in range(len(order0) - 1):
            d0, n0 = order0[j]
            d1, n1 = order0[j + 1]
            a0, name0, nx0, sh0 = prep[n0]
            c_lo = nx0
            c_hi = prep[n1][0]
            if c_hi <= c_lo or d1 - d0 < 8:
                continue
            gi = next((i for i, o in enumerate(doffs) if o >= d0), None)
            # disc instructions after the paired routine (its extent is exact when exact=True)
            i0 = res[n0][0] + len(sh0) if res[n0][1] else res[n0][0] + 1
            di = []
            k = i0
            while k < len(doffs) and doffs[k] < d1:
                di.append(k)
                k += 1
            cn = [m for m in range(n0 + 1, n1) if prep[m] is not None]
            if not cn or not di:
                continue
            cart = []   # (shape, label index)
            for m in cn:
                for q in prep[m][3]:
                    cart.append((q, m))
            sm = difflib.SequenceMatcher(None, [c[0] for c in cart], [dshapes[x] for x in di], autojunk=False)
            first_idx = {}
            pos = 0
            for m in cn:
                first_idx[m] = pos
                pos += len(prep[m][3])
            blocks = sm.get_matching_blocks()
            for m in cn:
                fi = first_idx[m]
                for bi, bj, size in blocks:
                    if bi == fi and size >= 5 and len(prep[m][3]) >= 3 and m not in res:
                        t = bj + (fi - bi)
                        while t > 0 and not dshapes[di[t - 1]].startswith(("rts", "rte", "jmp", "bra")):
                            t -= 1
                        res[m] = (di[t], False)
                        break
    order = sorted(res.items(), key=lambda kv: doffs[kv[1][0]])
    for j, (n, (pick, exact)) in enumerate(order):
        a, name, nxt, sh = prep[n]
        if exact:
            dl = doffs[min(pick + len(sh), len(doffs) - 1)] - doffs[pick]
        else:
            nx = doffs[order[j + 1][1][0]] if j + 1 < len(order) else len(disc)
            dl = min(nx - doffs[pick], 4 * (nxt - a) + 16)
        print("%X,%X,%s,%d,%d%s" % (a, doffs[pick], name, nxt - a, dl, "" if exact else ",prefix"))


if __name__ == "__main__":
    main()
