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
    last = 0
    for n, (a, name) in enumerate(labs):
        nxt = labs[n + 1][0] if n + 1 < len(labs) else a + 2
        if nxt <= a:
            continue
        ins, _ = decode(rom, a, nxt)
        term = [k for k, i in enumerate(ins) if i.mnemonic.split('.')[0] in ('rts', 'rte', 'jmp', 'bra')]
        if term:
            ins = ins[:term[-1] + 1]
        sh = [shape(i) for i in ins]
        if len(sh) < K:
            continue
        cands = idx.get(tuple(sh[:K]), [])
        good = []
        for c in cands:
            if dshapes[c:c + len(sh) - 2] == sh[:len(sh) - 2]:
                good.append(c)
        if not good:
            continue
        after = [c for c in good if doffs[c] >= last]
        pick = good[0] if len(good) == 1 else (after[0] if len(after) == 1 else None)
        if pick is None:
            continue
        last = doffs[pick]
        dl = doffs[min(pick + len(sh), len(doffs) - 1)] - doffs[pick]
        print("%X,%X,%s,%d,%d" % (a, doffs[pick], name, nxt - a, dl))


if __name__ == "__main__":
    main()
