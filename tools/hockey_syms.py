#!/usr/bin/env python3
"""Learn cartridge-symbol -> HOCKEY.BIN-value pairs from paired routines.

Reads the pairs from tools/hockey_pair.py. For every paired routine the cartridge
listing lines (source operands, symbols intact) are matched 1:1 to the disc
instructions; each symbol in a cartridge operand votes for the number in the same
operand slot on the disc. Prints symbol,value,votes,conflicts.

  python3 tools/hockey_syms.py pairs.csv output/nhl94.bin cdbin/HOCKEY.BIN "output/obj/nhl94 .lst"
"""
import re
import sys
from collections import Counter, defaultdict

sys.path.insert(0, __import__("os").path.dirname(__file__))
from hockey_pair import decode, shape

REG = re.compile(r"^(d[0-7]|a[0-7]|sp|pc|sr|ccr|usp)$", re.I)


def listing_instrs(path):
    """address -> source operand text of the instruction at that address (first listing line)"""
    out = {}
    for ln in open(path, errors="replace"):
        m = re.match(r"^([0-9A-F]{8}) ([0-9A-F ]{4,}?)\s+([a-z]\w*(?:\.\w)?)\s*(.*)$", ln.rstrip("\n"))
        if m:
            a = int(m.group(1), 16)
            op = m.group(4).split(";")[0].strip()
            out.setdefault(a, (m.group(3), op))
    return out


def syms(op):
    return [t for t in re.findall(r"[A-Za-z_][\w.]*", op) if not REG.match(t) and not re.match(r"^\.[wlbsWLBS]$", t)
            and not re.match(r"^[wlbsWLBS]$", t)]


def nums(op):
    return [int(x, 16) for x in re.findall(r"\$([0-9a-fA-F]+)", op)]


def main():
    pairs = [l.strip().split(",") for l in open(sys.argv[1])]
    rom = open(sys.argv[2], "rb").read()
    disc = open(sys.argv[3], "rb").read()
    lst = listing_instrs(sys.argv[4])
    votes = defaultdict(Counter)
    for a, d, name, cl, dl in pairs:
        a, d, cl = int(a, 16), int(d, 16), int(cl)
        ci, _ = decode(rom, a, a + cl)
        di, _ = decode(disc, d, d + int(dl) + 8, 0x1B000)
        for x, y in zip(ci, di):
            x_ok = x
            if shape(x) != shape(y):
                break
            src = lst.get(x.address)
            if not src:
                continue
            s = syms(src[1])
            n = nums(y.op_str)
            if len(s) == 1 and len(n) == 1:
                votes[s[0]][n[0]] += 1
    for s in sorted(votes):
        top, cnt = votes[s].most_common(1)[0]
        print("%s,%X,%d,%d" % (s, top, cnt, sum(votes[s].values()) - cnt))


main()
