#!/usr/bin/env python3
"""Emit SNASM for a slice of HOCKEY.BIN with names.

Like emit_m68k.py, plus what HOCKEY.BIN needs: inline strings after the print
calls, remap tables after DecompressGraphicsWithRemap, and 94G names for
absolute addresses taken from src/segacd/hockey.inc.

  python3 tools/emit_hockey.py cdbin/HOCKEY.BIN 0xD2B6 0xD9EB out.asm [--strings 0x38F6E,...]

Absolute operands are runtime addresses (file offset + $1B000 is not applied
here: the disc fragments keep file offsets as the org and runtime values in
operands, as the other src/segacd files do).
"""
import re
import sys

sys.path.insert(0, __import__("os").path.dirname(__file__))
import emit_m68k as E

STRING_CALLS = {0x38F6E, 0x38D8C, 0x39258}  # printz, printsmallz, printbigz: an inline String follows
REMAP_CALLS = {0x38946}  # DecompressGraphicsWithRemap: an 8 byte remap table follows


NM_FILE = {}  # file offset -> routine name, from docs/segacd-handoff/name_map.csv
LABELS = {}   # file offset -> global label name (from label:ADDR=Name items)


CC = {0xF8: "CC_SetMapAndPosition", 0xF9: "CC_SetFont", 0xFF: "CC_Font1", 0xFE: "CC_Font2", 0xFD: "CC_Font3",
      0xEF: "CC_Font1Pal1", 0xDF: "CC_Font1Pal2", 0xDE: "CC_Font2Pal2", 0xCF: "CC_Font1Pal3", 0xCE: "CC_Font2Pal3",
      0xCD: "CC_Font3Pal3", 0xBF: "CC_Font1Pri", 0xBE: "CC_Font2Pri", 0xBD: "CC_Font3Pri", 0x9E: "CC_Font2Pal2Pri",
      0x8F: "CC_Font1Pal3Pri", 0x8E: "CC_Font2Pal3Pri", 0x8D: "CC_Font3Pal3Pri"}
CCARGS = {0xF8: 4, 0xF9: 1}


def render_string(chunk):
    """chunk = length word + bytes. Return the String macro arguments, or None when it is not a plain String."""
    n = int.from_bytes(chunk[:2], "big")
    body = chunk[2:]
    if n != len(chunk):
        return None
    for cut in (body[:-1] if body[-1:] == b"\0" else None, body):
        if cut is None:
            continue
        if n != 2 + len(cut) + ((2 + len(cut)) & 1) or body != cut + b"\0" * ((2 + len(cut)) & 1):
            continue
        params, run, i = [], b"", 0
        def flush():
            nonlocal run
            if run:
                params.append("'" + run.decode() + "'")
                run = b""
        ok = True
        while i < len(cut):
            b = cut[i]
            if b >= 0x80:
                if b not in CC:
                    ok = False
                    break
                flush()
                params.append(CC[b])
                k = CCARGS.get(b, 2)
                params += ["$%X" % x for x in cut[i + 1:i + 1 + k]]
                i += 1 + k
            elif 32 <= b < 127 and b != 39:
                run += bytes([b]); i += 1
            else:
                flush(); params.append("$%X" % b); i += 1
        if not ok:
            continue
        flush()
        if len(params) == 0:
            return ["''"]
        if len(params) <= 8:
            return params
    return None


def load_names(inc):
    names = {}
    for l in open(inc):
        m = re.match(r"^(\w+)\s+equ\s+\$([0-9A-Fa-f]+)", l)
        if m:
            names.setdefault(int(m.group(2), 16), m.group(1))
    return names


def emit_code(blob, start, end, names):
    items = []   # (addr, kind, payload)
    pc = start
    while pc < end:
        got = None
        for i in E.md.disasm(blob[pc:pc + 12], pc):
            got = i
            break
        if got is None:
            items.append((pc, "dw", blob[pc:pc + 2]))
            pc += 2
            continue
        items.append((pc, "ins", got))
        pc += got.size
        if got.mnemonic.startswith("jsr") and len(got.bytes) == 6:
            a = int.from_bytes(got.bytes[2:], "big")
            if a in STRING_CALLS:
                n = int.from_bytes(blob[pc:pc + 2], "big")
                items.append((pc, "str", blob[pc:pc + n]))
                pc += n
            elif a in REMAP_CALLS:
                items.append((pc, "remap", blob[pc:pc + 8]))
                pc += 8
    # labels
    labels = {}
    for a, k, p in items:
        if k == "ins":
            kind = p.mnemonic.split(".")[0]
            if kind in E.BRANCH:
                d = E.target_of(p)
                if d is not None and start <= d < end:
                    labels[d] = f"L{d:X}"
    for a in list(LABELS):
        labels[a] = LABELS[a]
    for a, k, p in items:
        if k == "ins" and p.mnemonic.split(".")[0] in E.BRANCH:
            d = E.target_of(p)
            if d is not None and not (start <= d < end) and d in NM_FILE and d not in labels:
                labels[d] = NM_FILE[d] + "-LOAD"
    out = ["\torg\t$%X" % start, ""]
    ext = set()
    for a, k, p in items:
        lab = labels.get(a, "")
        if a in LABELS and lab:
            out.append(lab)
            lab = ""
        if k == "ins":
            kind = p.mnemonic.split(".")[0]
            text = E.snasm_op(p, labels, 0)
            if kind in E.BRANCH:
                d = E.target_of(p)
                if d is not None and d not in labels:
                    ext.add(d)
            # names for absolute long operands / long immediates
            def nm(m):
                v = int(m.group(1), 16)
                if v in names:
                    return "(%s).l" % (names[v] + ("+LOAD" if names[v] in LABELS.values() else ""))
                return m.group(0)
            text2 = re.sub(r"\$([0-9A-F]+)\.[Ll]", nm, text)
            if p.mnemonic in ("movea.l", "move.l") and text2.startswith("#$"):
                m = re.match(r"#\$([0-9A-F]+),(.*)", text2)
                if m and int(m.group(1), 16) in names:
                    nn = names[int(m.group(1), 16)]
                    text2 = "#%s,%s" % (nn + ("+LOAD" if nn in LABELS.values() else ""), m.group(2))
            mn = p.mnemonic
            if kind in ("btst", "bclr", "bset", "bchg") and re.search(r",d[0-7]$", text2.replace(" ", "")):
                mn = kind
            if kind == "moveq":
                m = re.match(r"#\$([0-9A-F]+),(.*)", text2)
                if m and int(m.group(1), 16) >= 0x80:
                    text2 = "#%d,%s" % (int(m.group(1), 16) - 256, m.group(2))
            if p.mnemonic.startswith("ori.b") and text2.endswith(",d0") and not (len(p.bytes) == 4 and p.bytes[:3] == b"\0\0\0"):
                out.append(f"{lab}\tdc.l\t${int.from_bytes(bytes(p.bytes),'big'):X}")
            else:
                out.append(f"{lab}\t{mn}\t{text2}".rstrip())
        elif k == "dw":
            out.append(f"{lab}\tdc.w\t${int.from_bytes(p,'big'):04X}")
        elif k == "str":
            pr = render_string(p)
            if pr:
                out.append(f"{lab}\tString\t" + ",".join(pr))
            else:
                out.append(f"{lab}\tdc.w\t${int.from_bytes(p[:2],'big'):04X}")
                out.append("\tdc.b\t" + ",".join("$%02X" % b for b in p[2:]))
        elif k == "remap":
            out.append(f"{lab}\tdc.l\t${int.from_bytes(p[:4],'big'):08X},${int.from_bytes(p[4:],'big'):08X}\t;remap table")
    return out[2:], ext


def emit_strs(blob, start, end):
    out, pc = [], start
    while pc < end:
        if pc in LABELS:
            out.append(LABELS[pc])
        n = int.from_bytes(blob[pc:pc + 2], "big")
        if n == 0xFFFF:
            out.append("\tdc.w\t-1")
            pc += 2
            continue
        pr = render_string(blob[pc:pc + n])
        if pr:
            out.append("\tString\t" + ",".join(pr))
        else:
            out.append("\tdc.w\t$%04X" % n)
            out.append("\tdc.b\t" + ",".join("$%02X" % b for b in blob[pc + 2:pc + n]))
        pc += n
    return out


def main():
    blob = open(sys.argv[1], "rb").read()
    out_path = sys.argv[-1]
    names = load_names("src/segacd/hockey.inc")
    import csv
    for r in csv.DictReader(open("docs/segacd-handoff/name_map.csv")):
        if r["disc_file"] == "HOCKEY.BIN":
            names.setdefault(int(r["disc_addr"][1:], 16), r["name_94g"])
            NM_FILE[int(r["disc_addr"][1:], 16) - 0x1B000] = r["name_94g"]
    spec = [x for x in sys.argv[2:-1]]
    lines, ext_all = [], set()
    first = None
    for sp in spec:
        if sp.startswith("label:"):
            ad, nm = sp[6:].split("=")
            LABELS[int(ad, 16)] = nm
    spec = [x for x in spec if not x.startswith("label:")]
    for sp in spec:
        kind, rng = sp.split(":")
        a, b = [int(x, 16) for x in rng.split("-")]
        if first is None:
            first = a
        if kind == "code":
            ol, ext = emit_code(blob, a, b, names)
            lines += ol; ext_all |= ext
        elif kind == "strs":
            lines += emit_strs(blob, a, b)
        elif kind == "label":
            pass
        elif kind == "bytes":
            if a in LABELS: lines.append(LABELS[a])
            lines.append("\tdc.b\t" + ",".join("$%02X" % x for x in blob[a:b]))
        elif kind == "longs":
            def lg(v):
                return (LABELS[v - 0x1B000] + "+LOAD") if (v - 0x1B000) in LABELS else "$%X" % v
            cur = []
            for i in range(a, b, 4):
                if i in LABELS:
                    if cur:
                        lines.append("\tdc.l\t" + ",".join(cur))
                        cur = []
                    lines.append(LABELS[i])
                cur.append(lg(int.from_bytes(blob[i:i + 4], "big")))
            if cur:
                lines.append("\tdc.l\t" + ",".join(cur))
    hdr = ["X_%X\tequ\t$%X" % (d, d) for d in sorted(ext_all)]
    open(out_path, "w").write("\n".join(["\tinclude\tsegacd\\hockey.inc", "\tinclude\tmacros\\genesis.mac", ""] + hdr + ["", "\torg\t$%X" % first, ""] + lines) + "\n")
    print("wrote", out_path, len(lines), "lines;", len(ext_all), "outside targets")


if __name__ == "__main__":
    main()
