#!/usr/bin/env python3
"""Write HOCKEY.BIN as ONE assembly: src/segacd/hockey.asm plus parts in src/segacd/hockey/.

The unit is assembled at org $1B000, the address the game loads at, so every label is the
runtime address and calls are plain labels (no equates for functions, no -LOAD/+LOAD).

  node tools/build.js retail                      # writes output/obj/nhl94 .lst
  cp output/nhl94.bin /tmp/nhl94.bin; cp "output/obj/nhl94 .lst" /tmp/nhl94.lst
  python3 tools/hockey_single.py

Parts: the hand-written HOCKEY.BIN fragments (kept, with their equates turned into labels) and
generated parts for everything between them. In generated parts, code is found by following
calls and branches from the paired routines (hockey_flow.py); the rest is data. A data piece
of 256 bytes or more is an asset: it is written to Extracted/SegaCD/HOCKEY/ and incbin'd, the
way the cartridge treats its assets. Smaller data stays as dc.w with a label.
"""
import csv
import glob
import json
import os
import re
import subprocess
import sys

sys.path.insert(0, os.path.dirname(__file__))
import emit_hockey as H
import emit_m68k as E
from hockey_flow import find_code

LOAD = 0x1B000
H.PLUS = H.MINUS = ""
DISC = "cdbin/HOCKEY.BIN"
PAIRS = "/tmp/hk_pairs.csv"
SYMS = "/tmp/hk_syms.csv"
PARTS = "src/segacd/hockey"
ASSETS = "Extracted/SegaCD/HOCKEY"
ASSET_MIN = 256
TAG = "".join("abcdefghij"[int(c)] for c in str(os.getpid()))

blob = open(DISC, "rb").read()
size = len(blob)

# ---- the hand-written fragments (kept as parts) -----------------------------------------
ver = open("tools/verifySegacd.js").read()
hand = sorted(
    (int(a, 16), int(l, 16), n)
    for n, a, l in re.findall(r"compareAt\('output/segacd/(\w+)\.bin', 'cdbin/HOCKEY.BIN', (0x[0-9A-Fa-f]+), (0x[0-9A-Fa-f]+)\)", ver)
    if not n.startswith("hk_") and n != "hockey"
)
hand_src = {}
for a, l, n in hand:
    # the originals (with their calls blocks) are the source; the converted copies are written to PARTS
    r = subprocess.run(["git", "show", "HEAD:src/segacd/%s.asm" % n], capture_output=True, text=True)
    if r.returncode == 0:
        hand_src[n] = r.stdout
    else:
        f = "%s/%s.asm" % (PARTS, n) if os.path.exists("%s/%s.asm" % (PARTS, n)) else "src/segacd/%s.asm" % n
        hand_src[n] = open(f).read()

# ---- names ------------------------------------------------------------------------------
inc_names = H.load_names("src/segacd/hockey.inc")          # runtime value -> name, variables
inc_lc = {n.lower() for n in inc_names.values()}
names = dict(inc_names)
for r in csv.DictReader(open("docs/segacd-handoff/name_map.csv")):
    if r["disc_file"] == "HOCKEY.BIN" and not r["notes"].startswith("auto pair"):
        v = int(r["disc_addr"][1:], 16)
        if v - LOAD < size:
            H.LABELS.setdefault(v - LOAD, r["name_94g"])
for l in open(SYMS):
    s, v, c, x = l.strip().split(",")
    if x != "0" or len(s) < 4 or re.match(r"^[0-9A-Fa-f]+$", s) or "." in s or re.match(r"^[a-z]{1,3}\d?$", s):
        continue
    if int(v, 16) - LOAD >= size or int(v, 16) < LOAD:
        names.setdefault(int(v, 16), s)
pairs = [l.strip().split(",") for l in open(PAIRS)]
for p in pairs:
    off, n = int(p[1], 16), p[2]
    if len(n) > 2 and n.lower() not in inc_lc and n not in H.LABELS.values():
        H.LABELS.setdefault(off, n)
for _k in [k for k, v in H.LABELS.items() if v == "rtss2"]:
    del H.LABELS[_k]
H.LABELS[0x21000] = "rtss2"  # the bare rts the scouting code branches to (hockey.inc had it as an equate)
seeds = sorted(set(int(p[1], 16) for p in pairs) | set(H.LABELS))
covered, seen, calls = find_code(blob, [s for s in seeds if s < size])
hand_cov = bytearray(size)
for a, l, n in hand:
    for i in range(a, a + l):
        hand_cov[i] = 1


def in_hand(off):
    return hand_cov[off] if off < size else 0


# ---- exact data tables from the cartridge ------------------------------------------------
try:
    rom = open("/tmp/nhl94.bin", "rb").read()
    L = open("/tmp/nhl94.lst", errors="replace").read().split("\n")
    labs = []
    for i, ln in enumerate(L):
        m = re.match(r"^([0-9A-F]{8}) {20,}([A-Za-z_]\w*)(\s|$)", ln)
        if not m or int(m.group(1), 16) >= 0x100000:
            continue
        for l2 in L[i + 1:i + 14]:
            m2 = re.match(r"^([0-9A-F]{8}) ([0-9A-F ]{4,}?)\s+([a-z]\w*)", l2)
            if m2 and int(m2.group(1), 16) == int(m.group(1), 16):
                labs.append((int(m.group(1), 16), m.group(2), m2.group(3) in ("dc", "ds", "String")))
                break
    labs = sorted(set(labs))
    for k, (a, n, isdata) in enumerate(labs[:-1]):
        nxt = labs[k + 1][0]
        if isdata and len(n) > 2 and nxt - a >= 24 and blob.count(rom[a:nxt]) == 1:
            H.LABELS.setdefault(blob.index(rom[a:nxt]), n)
except OSError:
    pass


def runtime_names():
    for off, n in H.LABELS.items():
        names[off + LOAD] = n


# ---- hand parts -> parts of the single unit -----------------------------------------------
HAND_LABELS = set()
for _t in hand_src.values():
    HAND_LABELS |= set(re.findall(r"^([A-Za-z_]\w*)\b(?!\s+equ)", _t, re.M)) - {"include", "org", "opt"}


# routine names that hand fragments took from the calls block: they name a place in the generated parts
for _t in hand_src.values():
    for _n, _v in re.findall(r"^(\w+)\s+equ\s+\$([0-9A-Fa-f]+)", _t, re.M):
        _v = int(_v, 16)
        _o = _v - LOAD if _v >= LOAD else _v
        if _n not in HAND_LABELS and 0 <= _o < size and not in_hand(_o) and _n.lower() not in inc_lc:
            for _k in [k for k, v in H.LABELS.items() if v == _n]:
                del H.LABELS[_k]
            H.LABELS[_o] = _n


def convert_hand(text, nm):
    labels_all = HAND_LABELS | set(H.LABELS.values())
    out = []
    skip = False
    for ln in text.split("\n"):
        if ln.startswith(";calls begin"):
            skip = True
            continue
        if ln.startswith(";calls end"):
            skip = False
            continue
        if skip:
            continue
        if re.match(r"^\s*include\s+(segacd\\hockey\.inc|macros\\genesis\.mac)", ln) or re.match(r"^\s*org\s", ln):
            continue
        if re.match(r"^X_[0-9A-F]+\tequ\t", ln):
            continue
        me = re.match(r"^(\w+)\s+equ\s+\$([0-9A-Fa-f]+)", ln)
        if me and (me.group(1) in labels_all or LOAD <= int(me.group(2), 16) < LOAD + size):
            continue
        out.append(ln)
    s = "\n".join(out)
    s = re.sub(r"(\w+)-LOAD\b", r"\1", s)
    s = re.sub(r"(\w+)\+LOAD\b", r"\1", s)
    return s


def x_names(text):
    toks = set(re.findall(r"\bX_([0-9A-F]+)\b", text))
    for t in toks:
        off = int(t, 16)
        H.LABELS.setdefault(off, "Sub_%X" % (off + LOAD))
    return re.sub(r"\bX_([0-9A-F]+)\b", lambda m: H.LABELS[int(m.group(1), 16)], text)


# ---- generated parts ------------------------------------------------------------------------
def words(x, y):
    out = []
    cuts = sorted(o for o in H.LABELS if x < o < y)
    pts = [x] + cuts + [y]
    for a, b in zip(pts, pts[1:]):
        if a in H.LABELS and a != x:
            out.append(H.LABELS[a])
        if a == x and a in H.LABELS:
            out.append(H.LABELS[a])
        if b - a >= ASSET_MIN and not any(a < o < b for o in H.LABELS):
            nm = "hockey_%05X.bin" % a
            os.makedirs(ASSETS, exist_ok=True)
            open("%s/%s" % (ASSETS, nm), "wb").write(blob[a:b])
            out.append("\tincbin\t..\\Extracted\\SegaCD\\HOCKEY\\%s\t;#%d" % (nm, b - a))
            continue
        for i in range(a, b, 16):
            j = min(i + 16, b)
            w = ["$%04X" % int.from_bytes(blob[k:k + 2], "big") for k in range(i, j - ((j - i) & 1), 2)]
            line = "\tdc.w\t" + ",".join(w) + "\t;@" + blob[i:j - ((j - i) & 1)].hex()
            if w:
                out.append(line)
            if (j - i) & 1:
                out.append("\tdc.b\t$%02X\t;@%02x" % (blob[j - 1], blob[j - 1]))
    return out


def gen_region(x, y):
    """code and data for [x, y), none of it inside a hand fragment"""
    out = []
    pos = x
    while pos < y:
        if covered[pos]:
            e = pos
            while e < y and covered[e]:
                e += 1
            # a label may not start in the middle; emit_code handles labels at instruction boundaries
            lines, ext = H.emit_code(blob, pos, e, names)
            e = max(e, H.LAST_PC)
            e = min(e, y)
            out += lines
            for d in ext:
                if 0 <= d < size:
                    H.LABELS.setdefault(d, "Sub_%X" % (d + LOAD))
            pos = e
        else:
            e = pos
            while e < y and not covered[e]:
                e += 1
            out += words(pos, e)
            pos = e
    return out


def regions():
    """(start, end, kind, name): hand fragments and the gaps between"""
    out, p = [], 0
    for a, l, n in hand:
        if a > p:
            out.append((p, a, "gen", None))
        out.append((a, a + l, "hand", n))
        p = a + l
    if p < size:
        out.append((p, size, "gen", None))
    return out


def split_gen(a, b):
    """chunks of about 4 KB cut at label offsets"""
    cur, res = a, []
    while cur < b:
        end = min(b, cur + 0x1000)
        if end < b:
            c = [o for o in sorted(H.LABELS) if cur + 0x800 <= o <= end and not (covered[o - 1] and not covered[o] and False)]
            end = c[-1] if c else end
        res.append((cur, end))
        cur = end
    return res


def build():
    runtime_names()
    return None


def main():
    os.makedirs(PARTS, exist_ok=True)
    for f in glob.glob(PARTS + "/gen_*.asm"):
        os.remove(f)
    regs = regions()
    # round 1: generate to learn the outside branch targets, round 2: with their labels
    for rnd in range(3):
        runtime_names()
        plan = []
        gen_cache = {}
        for a, b, kind, n in regs:
            if kind == "hand":
                plan.append(("hand", a, b, n))
            else:
                for x, y in split_gen(a, b):
                    gen_cache[(x, y)] = gen_region(x, y)
                    plan.append(("gen", x, y, "gen_%05X" % x))
    # write parts
    top = ["\tinclude\tsegacd\\hockey.inc", "\tinclude\tmacros\\genesis.mac", "", "\torg\t$%X" % LOAD, ""]
    parts = []
    for kind, a, b, n in plan:
        if kind == "hand":
            text = x_names(convert_hand(hand_src[n], n))
            opt = n in ("cdrequest", "cdtrack", "cdcrowd", "cdstart")
            body = text
            if opt:
                body = "\topt\toaq+\n\topt\tosq+\n" + body + "\n\topt\toaq-\n\topt\tosq-"
            open("%s/%s.asm" % (PARTS, n), "w").write(body + "\n")
        else:
            lines = gen_cache[(a, b)]
            parts.append(n)
            open("%s/%s.asm" % (PARTS, n), "w").write("\n".join(lines) + "\n")
        top.append("\tinclude\tsegacd\\hockey\\%s.asm" % n)
    open("src/segacd/hockey.asm", "w").write("\n".join(top) + "\n")
    print(len(plan), "parts;", len(H.LABELS), "labels", flush=True)
    ok = fixloop(plan)
    if not ok:
        sys.exit("did not converge")
    for n in parts:
        p = "%s/%s.asm" % (PARTS, n)
        text = open(p).read()
        open(p, "w").write("\n".join(re.sub(r"\t;[@#][0-9a-f]*$", "", l) for l in text.split("\n")))
    man = {}
    for n in parts:
        for l in open("%s/%s.asm" % (PARTS, n)):
            m = re.search(r"incbin\t\.\.\\Extracted\\SegaCD\\HOCKEY\\(hockey_([0-9A-F]+)\.bin)", l)
            if m:
                a0 = int(m.group(2), 16)
                man[m.group(1)] = {"start": a0, "size": os.path.getsize("%s/%s" % (ASSETS, m.group(1)))}
    json.dump(dict(sorted(man.items())), open(PARTS + "/assets.json", "w"), indent=1)
    print("done")


def tag_len(l):
    m = re.search(r";@([0-9a-f]*)\s*$", l)
    if m:
        return len(m.group(1)) // 2
    m = re.search(r";#(\d+)\s*$", l)
    return int(m.group(1)) if m else None


def to_words(l):
    m = re.search(r";@([0-9a-f]+)\s*$", l)
    if not m or re.match(r"^(\S*)\t(dc\.[wb])\t", l):
        return None
    raw = bytes.fromhex(m.group(1))
    lab = l.split("\t")[0] if not l.startswith("\t") else ""
    w = ",".join("$%04X" % int.from_bytes(raw[k:k + 2], "big") for k in range(0, len(raw) - 1, 2))
    if len(raw) & 1:
        return [lab + "\tdc.w\t" + w + "\t;@" + raw[:-1].hex(), "\tdc.b\t$%02X\t;@%02x" % (raw[-1], raw[-1])] if w else [lab + "\tdc.b\t$%02X\t;@%02x" % (raw[-1], raw[-1])]
    return [lab + "\tdc.w\t" + w + "\t;@" + raw.hex()]


def assemble():
    opts = [o for f in json.load(open("tools/segacd.json")) if f["name"] == "scouting" for o in f["options"]]
    t = "Z:\\tmp\\new\\hockey" + TAG
    r = subprocess.run(["wine", "../assembler/Assembler.exe", "/p", "/m", "/g"] + opts + ["segacd\\hockey.asm," + t + ".bin," + t + "," + t], cwd="src", capture_output=True, text=True, env={**os.environ, "WINEDEBUG": "-all"})
    txt = r.stdout.replace("\r", "")
    errs = []
    for l in txt.split("\n"):
        m = re.search(r"SEGACD\\(?:HOCKEY\\)?(\w+)\.ASM\((\d+)", l, re.I)
        if m:
            errs.append((m.group(1), int(m.group(2)), l.split(" : ")[-1] if " : " in l else l[-60:]))
    return errs, txt


def fixloop(plan):
    gen = [(n, a) for k, a, b, n in plan if k == "gen"]
    files = {n: open("%s/%s.asm" % (PARTS, n)).read().split("\n") for n, a in gen}
    base = {n: a for n, a in gen}
    for rnd in range(int(os.environ.get("ROUNDS", "300"))):
        for n, ls in files.items():
            open("%s/%s.asm" % (PARTS, n), "w").write("\n".join(ls))
        errs, txt = assemble()
        if os.environ.get('DBG'):
            print('round', rnd, len(errs), [(e[0], e[1]) for e in errs[:4]], flush=True)
        todo = None
        if errs:
            seen_bad = False
            conv = set()
            for fn, ln, msg in errs:
                if fn.lower() in {x.lower() for x in files}:
                    key = [x for x in files if x.lower() == fn.lower()][0]
                    if ln - 1 < len(files[key]) and (key, ln - 1) not in conv:
                        w = to_words(files[key][ln - 1])
                        if w:
                            conv.add((key, ln - 1))
                            files[key][ln - 1] = "\x00".join(w)
                            seen_bad = True
            if seen_bad:
                for key in files:
                    files[key] = "\n".join(files[key]).replace("\x00", "\n").split("\n")
                continue
            print("unfixable errors:", errs[:5])
            return False
        outp = "/tmp/new/hockey%s.bin" % TAG
        if os.path.exists(outp) and open(outp, "rb").read() == blob:
            return True
        lst = open("/tmp/new/hockey%s .lst" % TAG, errors="replace").read().split("\n")
        tagged = []
        for n, a in gen:
            p = a
            for i, l in enumerate(files[n]):
                t = tag_len(l)
                if t is not None:
                    tagged.append((n, i, p, t, l))
                    p += t
        rows = []
        k = 0
        for ll in lst:
            m = re.search(r";([@#])([0-9a-f]*)\s*$", ll)
            if not m or not re.match(r"^[0-9A-F]{8} ", ll):
                continue
            if k >= len(tagged):
                break
            rows.append((int(ll[:8], 16) - LOAD, ll))
            k += 1
        flagged = []
        for k, (addr, ll) in enumerate(rows):
            n, i, p, t, l = tagged[k]
            got = re.sub(r"[^0-9A-Fa-f]", "", ll[9:35]).lower()
            exp = l.split(";@")[-1] if ";@" in l else ""
            fwd = re.search(r"\bL[0-9A-F]{4,5}\b", ll[35:]) or re.search(r"\t(b[a-z]{2}|bsr|bra|db[a-z]+)(\.\w)?\t", ll[35:])
            full = "+" not in ll[9:36] and not fwd and len(exp) <= 16
            nxt = rows[k + 1][0] - addr if k + 1 < len(rows) and tagged[k + 1][0] == n else None
            if (exp and got and (got[:4] != exp[:4] or (full and got != exp))) or (nxt is not None and nxt != t):
                flagged.append(tagged[k])
        bad = None
        if flagged:
            changed = False
            for n, i, p, t, l in flagged:
                w = to_words(l)
                if w:
                    files[n][i] = "\x00".join(w)
                    changed = True
            if not changed:
                # drift without a convertible flagged line: convert the first flagged line's predecessor
                n, i, p, t, l = flagged[0]
                j = i - 1
                while j >= 0:
                    w = to_words(files[n][j]) if tag_len(files[n][j]) is not None else None
                    if w:
                        files[n][j] = "\x00".join(w)
                        changed = True
                        break
                    j -= 1
            if not changed:
                print("cannot fix", flagged[0][0], flagged[0][1], flagged[0][4][:60])
                return False
            for key in files:
                files[key] = "\n".join(files[key]).replace("\x00", "\n").split("\n")
            continue
        if True:
            outp = "/tmp/new/hockey%s.bin" % TAG
            if os.path.exists(outp) and open(outp, "rb").read() == blob:
                return True
            print("no mismatch found by listing; sizes", os.path.getsize(outp) if os.path.exists(outp) else None, size)
            return False
        n, i, p, t, l = bad
        w = to_words(l)
        if not w:
            # the drift comes from an earlier line: convert the nearest convertible line above
            j = i - 1
            while j >= 0:
                w = to_words(files[n][j]) if tag_len(files[n][j]) is not None else None
                if w:
                    break
                j -= 1
            if not w:
                print("cannot fix", n, i, l[:70])
                return False
            files[n][j:j + 1] = w
            continue
        files[n][i:i + 1] = w
    return False


main()
