#!/usr/bin/env python3
"""Code discovery for a Sega CD binary loaded at `base`.

find_code(d, base, seeds, string_calls) follows fall-through, bra/bcc/dbcc/bsr and jsr/jmp to absolute
addresses, and lea/pea/move.l #imm pointers (data). Each seed is tried alone: when decoding falls off the
file or hits an invalid instruction the whole trial is dropped, so data that only looks like code does not
become code.
"""
import re
from capstone import Cs, CS_ARCH_M68K, CS_MODE_BIG_ENDIAN, CS_MODE_M68K_000

md = Cs(CS_ARCH_M68K, CS_MODE_M68K_000 | CS_MODE_BIG_ENDIAN)
md.detail = False
BR = ("bra", "bsr", "beq", "bne", "bhi", "bls", "bcc", "bcs", "bpl", "bmi", "bvc", "bvs", "bge", "bgt", "ble", "blt",
      "dbra", "dbf", "dbne", "dbt", "dbeq", "dbhi", "dbcc", "dbcs", "dbmi", "dbpl", "dble", "dblt", "dbge", "dbgt",
      "dbls", "dbvs", "dbvc")
STRICT = True
INLINE = {}   # bsr/jsr target address -> number of inline data bytes that follow the call (set by the generator)
STOP = ("rts", "rte", "jmp", "bra", "rtr", "illegal")
SUSPECT = ("illegal", "reset", "stop")


def is_zero_word(g):
    """A 0000 first word is padding, except in a real ori.b #imm,d0 (0000 00ii, ii not 0)."""
    b = bytes(g.bytes)
    if b[:2] != b"\x00\x00":
        return False
    return not (g.mnemonic.startswith("ori.b") and len(b) == 4 and b[2] == 0 and b[3] != 0 and g.op_str.endswith("d0"))


def inline_len(d, at, spec):
    """Inline data bytes after a call: a number, or 'w' = the word at `at` gives the length (itself included)."""
    return int.from_bytes(d[at:at + 2], "big") if spec == "w" else spec


def decode_at(d, pc, base):
    for i in md.disasm(d[pc:pc + 12], base + pc):
        return i
    return None


def abs_target(g, base, n):
    """Absolute address operand of jsr/jmp/pea/lea (abs.l or abs.w), or None."""
    m = re.fullmatch(r"\$([0-9a-f]+)(\.[wl])?", g.op_str.split(",")[0].replace(" ", ""))
    if not m:
        return None
    t = int(m.group(1), 16)
    if m.group(2) == ".w" and t >= 0x8000:
        t |= 0xFFFF0000
    return t


def find_code(d, base, seeds, string_calls=(), data_refs=None):
    n = len(d)
    covered = bytearray(n)
    insns = {}     # pc -> size
    calls = set()  # routine entries (bsr/jsr targets)
    labels = set() # branch targets
    queue = list(reversed(seeds))
    tried = set()
    while queue:
        entry = queue.pop()
        if entry in tried or not (0 <= entry < n - 1) or entry % 2:
            continue
        tried.add(entry)
        if entry in insns:
            continue
        path, pcalls, plabels, pq = {}, set(), set(), []
        pc = entry
        ok = True
        natural = False
        while True:
            if pc in insns:
                break          # joins known code
            if pc in path:
                break
            if not (0 <= pc < n - 1) or covered[pc]:
                ok = False
                break
            g = decode_at(d, pc, base)
            if g is None or g.size < 2 or pc + g.size > n or g.mnemonic.split(".")[0] in SUSPECT or is_zero_word(g):
                ok = False
                break
            if any(covered[pc + k] for k in range(g.size)):
                ok = False
                break
            mn = g.mnemonic.split(".")[0]
            path[pc] = g.size
            m = re.search(r"\$([0-9a-f]+)", g.op_str)
            if mn in BR and m and "(" not in g.op_str.replace("(pc)", ""):
                tgt = int(m.group(1), 16) - base
                if not (0 <= tgt < n):
                    ok = False
                    break
                pq.append(tgt)
                (pcalls if mn == "bsr" else plabels).add(tgt)
            elif mn in ("jsr", "jmp") and "(pc)" in g.op_str and m:
                tgt = int(m.group(1), 16) - base
                if 0 <= tgt < n:
                    pq.append(tgt)
                    pcalls.add(tgt)
            elif mn in ("jsr", "jmp") and len(g.bytes) in (4, 6):
                t = abs_target(g, base, n)
                if t is not None:
                    if mn == "jsr" and len(g.bytes) == 6 and t in string_calls:
                        ln = int.from_bytes(d[pc + 6:pc + 8], "big")
                        for k in range(ln):
                            path[pc + 6 + k] = -1
                        pc += 6 + ln
                        continue
                    t -= base
                    if 0 <= t < n:
                        pq.append(t)
                        pcalls.add(t)
            if mn in STOP:
                natural = True
                break
            pc += g.size
        if ok is False and False:
            pass
        if natural or STRICT is False:
            for p, sz in path.items():
                if sz > 0:
                    insns[p] = sz
                    for k in range(sz):
                        covered[p + k] = 1
                else:
                    covered[p] = 2
            calls |= pcalls
            labels |= plabels
            if ok:
                queue.extend(reversed(pq))
    return covered, insns, calls, labels


def string_calls_off(sc, base):
    return {x - base for x in sc}


def runs(covered, val=1):
    out, s = [], None
    for i, v in enumerate(covered):
        if v and s is None:
            s = i
        if not v and s is not None:
            out.append((s, i)); s = None
    if s is not None:
        out.append((s, len(covered)))
    return out


def zeroish(g, d, pc):
    return g.mnemonic.startswith("ori.b") and is_zero_word(g) or is_zero_word(g)


def sweep(d, base, covered, insns, calls, labels, string_calls=(), rounds=6):
    """Grow code from the end of known routines: the bytes after an rts/rte/jmp/bra that decode as a plausible
    routine (valid opcodes, at least 4 instructions, no run of zero words) are taken as code, and flow follows them."""
    n = len(d)
    for _ in range(rounds):
        starts = set()
        for pc, sz in insns.items():
            g = decode_at(d, pc, base)
            if g and g.mnemonic.split(".")[0] in ("rts", "rte", "jmp", "bra", "rtr"):
                nx = pc + sz
                if nx < n - 1 and not covered[nx]:
                    starts.add(nx)
        # the first non-zero word after a run of zero words is a plausible routine start too
        i = 0
        while i < n - 3:
            if d[i:i + 2] == b"\0\0" and not covered[i]:
                j = i
                while j < n - 1 and d[j:j + 2] == b"\0\0" and not covered[j]:
                    j += 2
                if j - i >= 4 and j < n - 1 and not covered[j]:
                    starts.add(j)
                i = max(j, i + 2)
            else:
                i += 2
        new = 0
        accepted = []
        for st in sorted(starts):
            pc = st
            cnt = 0
            zero = 0
            good = False
            while pc < n - 1 and not covered[pc]:
                g = decode_at(d, pc, base)
                if g is None or g.size < 2 or g.mnemonic.split(".")[0] in SUSPECT:
                    break
                if is_zero_word(g):
                    zero += 1
                    if zero >= 2:
                        break
                else:
                    zero = 0
                cnt += 1
                if g.mnemonic.split(".")[0] in STOP:
                    good = cnt >= 2
                    break
                pc += g.size
            if good:
                accepted.append(st)
        if not accepted:
            break
        c2, i2, ca2, la2 = find_code_more(d, base, accepted, covered, insns, calls, labels, string_calls)
        new = len(accepted)
        if not new:
            break


def find_code_more(d, base, seeds, covered, insns, calls, labels, string_calls):
    # run find_code's loop on top of existing state
    c, i, ca, la = find_code_seeded(d, base, seeds, covered, insns, string_calls)
    calls |= ca
    labels |= la
    return c, i, ca, la


def find_code_seeded(d, base, seeds, covered, insns, string_calls):
    # same as find_code but continuing from an existing state
    import copy
    n = len(d)
    calls, labels = set(), set()
    queue = list(reversed(seeds))
    tried = set()
    while queue:
        entry = queue.pop()
        if entry in tried or not (0 <= entry < n - 1) or entry % 2:
            continue
        tried.add(entry)
        if entry in insns:
            continue
        path, pcalls, plabels, pq = {}, set(), set(), []
        pc = entry
        ok = True
        natural = False
        while True:
            if pc in insns or pc in path:
                natural = True
                break
            if not (0 <= pc < n - 1) or covered[pc]:
                ok = False
                break
            g = decode_at(d, pc, base)
            if g is None or g.size < 2 or pc + g.size > n or g.mnemonic.split(".")[0] in SUSPECT or is_zero_word(g) or any(covered[pc + k] for k in range(g.size)):
                ok = False
                break
            mn = g.mnemonic.split(".")[0]
            path[pc] = g.size
            m = re.search(r"\$([0-9a-f]+)", g.op_str)
            if mn in BR and m and "(" not in g.op_str.replace("(pc)", ""):
                tgt = int(m.group(1), 16) - base
                if not (0 <= tgt < n):
                    ok = False
                    break
                pq.append(tgt)
                (pcalls if mn == "bsr" else plabels).add(tgt)
                if mn == "bsr" and base + tgt in string_calls:
                    ln = int.from_bytes(d[pc + g.size:pc + g.size + 2], "big")
                    for k in range(ln):
                        path[pc + g.size + k] = -1
                    pc += g.size + ln
                    continue
                if mn == "bsr" and base + tgt in INLINE:
                    nb = inline_len(d, pc + g.size, INLINE[base + tgt])
                    for k in range(nb):
                        path[pc + g.size + k] = -1
                    pc += g.size + nb
                    continue
            elif mn in ("jsr", "jmp") and "(pc)" in g.op_str and m:
                tgt = int(m.group(1), 16) - base
                if 0 <= tgt < n:
                    pq.append(tgt)
                    pcalls.add(tgt)
            elif mn in ("jsr", "jmp") and len(g.bytes) in (4, 6):
                t = abs_target(g, base, n)
                if t is not None:
                    if mn == "jsr" and len(g.bytes) == 6 and t in INLINE:
                        nb = inline_len(d, pc + 6, INLINE[t])
                        for k in range(nb):
                            path[pc + 6 + k] = -1
                        pc += 6 + nb
                        continue
                    if mn == "jsr" and len(g.bytes) == 6 and t in string_calls:
                        ln = int.from_bytes(d[pc + 6:pc + 8], "big")
                        for k in range(ln):
                            path[pc + 6 + k] = -1
                        pc += 6 + ln
                        continue
                    t -= base
                    if 0 <= t < n:
                        pq.append(t)
                        pcalls.add(t)
            if mn in STOP:
                natural = True
                break
            pc += g.size
        if ok is False and False:
            pass
        if natural or STRICT is False:
            for p, sz in path.items():
                if sz > 0:
                    insns[p] = sz
                    for k in range(sz):
                        covered[p + k] = 1
                else:
                    covered[p] = 2
            calls |= pcalls
            labels |= plabels
            if ok:
                queue.extend(reversed(pq))
    return covered, insns, calls, labels
