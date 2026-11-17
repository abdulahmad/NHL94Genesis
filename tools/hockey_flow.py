#!/usr/bin/env python3
"""Find the code in HOCKEY.BIN by following calls and branches from the paired routines.

  python3 tools/hockey_flow.py pairs.csv cdbin/HOCKEY.BIN > code_ranges.txt

Seeds are the paired routine starts and the hand-written fragments. Decoding follows
fall-through, bra/bcc/dbcc/bsr/jsr targets inside the file, and skips the inline String
after the print calls. A routine ends at rts, rte, jmp or bra. Output: start,end,seed
lines of contiguous code; everything else is data.
"""
import re
import sys

from capstone import Cs, CS_ARCH_M68K, CS_MODE_BIG_ENDIAN, CS_MODE_M68K_000

md = Cs(CS_ARCH_M68K, CS_MODE_M68K_000 | CS_MODE_BIG_ENDIAN)
LOAD = 0x1B000
STRING_CALLS = {0x38F6E, 0x38D8C, 0x39258, 0x39200}
BR = ("bra", "bsr", "beq", "bne", "bhi", "bls", "bcc", "bcs", "bpl", "bmi", "bvc", "bvs", "bge", "bgt", "ble", "blt", "dbra", "dbf", "dbne", "dbt", "dbeq", "dbhi", "dbcc", "dbcs", "dbmi", "dbpl", "dble", "dblt", "dbge", "dbgt", "dbls", "dbvs", "dbvc")


def find_code(d, seeds):
    seen = {}
    calls = set()
    queue = list(seeds)
    covered = bytearray(len(d))
    while queue:
        pc = queue.pop()
        while 0 <= pc < len(d) - 2 and pc not in seen:
            got = None
            for i in md.disasm(d[pc:pc + 12], pc):
                got = i
                break
            if got is None or got.size < 2 or pc + got.size > len(d) or covered[pc]:
                break
            mn = got.mnemonic.split(".")[0]
            m = re.search(r"\$([0-9a-f]+)", got.op_str)
            tgt = int(m.group(1), 16) if m else None
            seen[pc] = got.size
            for k in range(got.size):
                covered[pc + k] = 1
            if mn in BR and tgt is not None and "(" not in got.op_str.replace("(pc)", ""):
                t = tgt if mn != "jsr" else tgt - LOAD
                if 0 <= t < len(d) and t not in seen:
                    queue.append(t)
                    if mn in ("bsr", "jsr"):
                        calls.add(t)
            if mn in ("jsr", "jmp") and len(got.bytes) == 6:
                a = int.from_bytes(got.bytes[2:], "big")
                if a in STRING_CALLS:
                    n = int.from_bytes(d[pc + 6:pc + 8], "big")
                    for k in range(n):
                        covered[pc + 6 + k] = 1
                    pc += 6 + n
                    continue
                t = a - LOAD
                if 0 <= t < len(d) and t not in seen:
                    queue.append(t)
                    calls.add(t)
            if mn in ("rts", "rte", "jmp", "bra"):
                break
            pc += got.size
    return covered, seen, calls


def main():
    pairs = [l.strip().split(",") for l in open(sys.argv[1])]
    d = open(sys.argv[2], "rb").read()
    covered, seen, calls = find_code(d, [int(p[1], 16) for p in pairs])
    s = None
    for i, v in enumerate(covered):
        if v and s is None:
            s = i
        if not v and s is not None:
            print("%X,%X" % (s, i))
            s = None
    if s is not None:
        print("%X,%X" % (s, len(d)))


if __name__ == "__main__":
    main()
