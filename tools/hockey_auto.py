#!/usr/bin/env python3
"""Write one HOCKEY.BIN fragment as named source, from the routine pairs and learned symbols.

  python3 tools/hockey_auto.py pairs.csv syms.csv cdbin/HOCKEY.BIN 0x82FC 0x8A7E src/segacd/xxx.asm

Routine names come from the pairs (a routine paired with a cartridge label starts with
that label). Absolute operands are named from syms.csv. The range is emitted as code;
bytes that do not decode become dc.w, so the fragment always round-trips.
"""
import csv
import re
import sys

sys.path.insert(0, __import__("os").path.dirname(__file__))
import emit_hockey as H

pairs, syms, blobp, a, b, out = sys.argv[1:7]
a, b = int(a, 16), int(b, 16)
blob = open(blobp, "rb").read()
names = H.load_names("src/segacd/hockey.inc")
for r in csv.DictReader(open("docs/segacd-handoff/name_map.csv")):
    if r["disc_file"] == "HOCKEY.BIN":
        names.setdefault(int(r["disc_addr"][1:], 16), r["name_94g"])
        H.NM_FILE[int(r["disc_addr"][1:], 16) - 0x1B000] = r["name_94g"]
for l in open(syms):
    s, v, c, x = l.strip().split(",")
    if x != "0" or len(s) < 4 or re.match(r"^[0-9A-Fa-f]+$", s) or "." in s or re.match(r"^[a-z]{1,3}\d?$", s):
        continue
    names.setdefault(int(v, 16), s)
local = {}
for l in open(pairs):
    ca, d, n, cl, dl = l.strip().split(",")
    d = int(d, 16)
    if a <= d < b and len(n) > 2 and n not in H.LABELS.values():
        H.LABELS[d] = n
        names.setdefault(d + 0x1B000, n)
        H.NM_FILE[d] = n
ext_all = set()
lines = []
ext = set()
ext_ranges = []
for l in sorted(open(pairs), key=lambda l: int(l.split(",")[1], 16)):
    ca, d, n, cl, dl = l.strip().split(",")
    d, dl = int(d, 16), int(dl)
    if a <= d and d + dl <= b:
        ext_ranges.append((d, d + dl))
pos = a
def words(x, y):
    out = []
    for i in range(x, y, 16):
        j = min(i + 16, y)
        w = ["$%04X" % int.from_bytes(blob[k:k + 2], "big") if k + 2 <= j else "$%02X" % blob[k] for k in range(i, j, 2)]
        raw = blob[i:j].hex()
        out.append("\tdc.w\t" + ",".join(w) + "\t;@" + raw if (j - i) % 2 == 0 else "\tdc.w\t" + ",".join(w[:-1]) + "\t;@" + blob[i:j - 1].hex() + "\n\tdc.b\t" + w[-1] + "\t;@" + blob[j - 1:j].hex())
    return out
for x, y in ext_ranges:
    if x < pos:
        continue
    if x > pos:
        lines += words(pos, x)
    ol, e = H.emit_code(blob, x, y, names)
    lines += ol
    ext |= e
    pos = max(y, H.LAST_PC)
if pos < b:
    lines += words(pos, b)
import subprocess
body_lines = lines
OPTS = " ".join(__import__("json").load(open("tools/segacd.json"))[0]["options"]) if False else None


def build(lines, hdr_extra):
    body = "\n".join(lines)
    used = {}
    for v, n in names.items():
        if n in H.LABELS.values():
            continue
        if re.search(r"(?<![\w.])" + re.escape(n) + r"(?![\w])", body):
            used[n] = v
    eq = ["%s\tequ\t$%X" % (n, v) for n, v in sorted(used.items())]
    xs = sorted(set(int(x, 16) for x in re.findall(r"\bX_([0-9A-F]+)", body)))
    defined = set(re.findall(r"^(L[0-9A-F]{4,5})\b", body, re.M))
    ls = sorted(set(int(x, 16) for x in re.findall(r"\b(L[0-9A-F]{4,5})\b", body) if x not in defined for x in [x[1:]]))
    eq += ["L%X\tequ\t$%X" % (v, v) for v in ls]
    hdr = eq + ["X_%X\tequ\t$%X" % (d, d) for d in xs]
    head = ["\tinclude\tsegacd\\hockey.inc", "\tinclude\tmacros\\genesis.mac", ""] + hdr + ["", "\torg\t$%X" % a, ""]
    return head, head + lines


def assemble(path):
    try:
        __import__("os").remove("/tmp/new/auto.bin")
    except OSError:
        pass
    import json
    opts = [o for f in json.load(open("tools/segacd.json")) if f["name"] == "scouting" for o in f["options"]]
    rel = path[len("src/"):].replace("/", "\\")
    r = subprocess.run(["wine", "../assembler/Assembler.exe", "/p", "/m", "/g"] + opts + [rel + ",Z:\\tmp\\new\\auto.bin,Z:\\tmp\\newobj\\auto,Z:\\tmp\\newobj\\auto"], cwd="src", capture_output=True, text=True, env={**__import__("os").environ, "WINEDEBUG": "-all"})
    errs = []
    for l in r.stdout.replace("\r", "").split("\n"):
        m = re.search(r"\((\d+)\S*\s+(.*)$", l)
        if "rror" in l or m:
            m2 = re.search(r"\.ASM\((\d+)", l, re.I)
            if m2:
                errs.append(int(m2.group(1)))
    return sorted(set(errs)), r.stdout


for rnd in range(8):
    head, full = build(lines, None)
    open(out, "w").write("\n".join(full) + "\n")
    errs, txt = assemble(out)
    if not errs:
        break
    fixed = 0
    for e in errs:
        idx = e - 1 - len(head)
        if 0 <= idx < len(lines):
            m = re.search(r";@([0-9a-f]+)$", lines[idx])
            if m:
                raw = bytes.fromhex(m.group(1))
                lab = re.match(r"^(\S+)\t", lines[idx])
                lines[idx] = (lab.group(1) if lab and not lines[idx].startswith("\t") else "") + "\t" + ("dc.w\t" + ",".join("$%04X" % int.from_bytes(raw[k:k + 2], "big") for k in range(0, len(raw) - 1, 2)))
                fixed += 1
    if not fixed:
        break
ref = blob[a:b]
for rnd in range(int(__import__("os").environ.get("ROUNDS", "400"))):
    head, full = build(lines, None)
    open(out, "w").write("\n".join(full) + "\n")
    errs, txt = assemble(out)
    if not errs and not __import__("os").path.exists("/tmp/new/auto.bin"):
        print(txt[-600:])
        break
    asm = open("/tmp/new/auto.bin", "rb").read() if not errs else b""
    if not errs and asm == ref:
        break
    tgt = None
    tagged = [i for i, l in enumerate(lines) if re.search(r";@[0-9a-f]*$", l)]
    k = 0
    pos = a
    for ll in open("/tmp/newobj/auto .lst", errors="replace"):
        m = re.search(r";@([0-9a-f]*)\s*$", ll)
        if not m:
            continue
        exp = m.group(1)
        if k >= len(tagged):
            break
        got = re.sub(r"[^0-9A-Fa-f]", "", ll[9:35]).lower()
        addr = int(ll[:8], 16)
        fwd = re.search(r"\bL[0-9A-F]{4,5}\b", ll[35:]) or re.search(r"\t(b[a-z]{2}|bsr|bra|db[a-z]+)(\.\w)?\t", ll[35:])
        full = "+" not in ll[9:36] and not fwd and len(exp) <= 16
        if addr != pos or (got and (got[:4] != exp[:4] or (full and got != exp))):
            tgt = tagged[k - 1] if addr != pos and k > 0 else tagged[k]
            break
        pos += len(exp) // 2
        k += 1
    if tgt is None:
        print("no listing mismatch found; size", len(asm), len(ref))
        break
    l = lines[tgt]
    if __import__("os").environ.get("DBG"): print(rnd, tgt, l[:70])
    if re.match(r"^(\S*)\t(dc\.[wb]|String)\t", l):
        # already data: this cannot be fixed here
        # give up on the routine around it: turn it into data
        rn = set(H.LABELS.values())
        i0 = tgt
        while i0 > 0 and lines[i0].split("\t")[0] not in rn:
            i0 -= 1
        i1 = tgt + 1
        while i1 < len(lines) and lines[i1].split("\t")[0] not in rn:
            i1 += 1
        print("routine to data:", lines[i0][:40])
        for j in range(i0, i1):
            mm = re.search(r";@([0-9a-f]+)$", lines[j])
            if not mm or re.match(r"^(\S*)\t(dc\.[wb]|String)\t", lines[j]):
                continue
            raw = bytes.fromhex(mm.group(1))
            lab = lines[j].split("\t")[0] if not lines[j].startswith("\t") else ""
            lines[j] = lab + "\tdc.w\t" + ",".join("$%04X" % int.from_bytes(raw[k:k + 2], "big") for k in range(0, len(raw) - 1, 2)) + "\t;@" + raw.hex()
        continue
    raw = bytes.fromhex(re.search(r";@([0-9a-f]+)$", l).group(1))
    lab = l.split("\t")[0] if not l.startswith("\t") else ""
    lines[tgt] = lab + "\tdc.w\t" + ",".join("$%04X" % int.from_bytes(raw[k:k + 2], "big") for k in range(0, len(raw) - 1, 2)) + "\t;@" + raw.hex()
lines = [re.sub(r"\t;@[0-9a-f]+$", "", l) for l in lines]
head, full = build(lines, None)
open(out, "w").write("\n".join(full) + "\n")
print("wrote", out, len(lines), "lines; errors left:", len(errs))
