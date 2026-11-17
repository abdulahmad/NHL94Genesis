#!/usr/bin/env python3
"""Rebuild a Sega CD disc file (MAIN, PLAYER, STARTER) as ONE assembly that matches the disc.

  python3 tools/segcd_one.py MAIN

The hand fragments stay (names and comments), minus their X_<addr> equates: every address that an equate
named becomes a real label where the code is. The bytes between the fragments are rebuilt from the disc:
code found by following calls and branches (tools/segcd_flow.py) becomes instructions, runs of zeros become
dcb.b, big blocks that are not code become assets (Extracted/SegaCD/<FILE>/<name>_<off>.bin, incbin like the
cartridge), the rest dc.b. Each generated instruction line carries a ;@<hex> tag with its bytes; after
assembling, lines whose bytes differ fall back to dc.w and the build repeats until the binary equals the
disc. The tags are stripped at the end.
"""
import json
import os
import re
import struct
import subprocess
import sys

sys.path.insert(0, "tools")
import emit_m68k as E
import segcd_flow as F

CFG = {
    "PLAYER": dict(
        disc="cdbin/PLAYER.BIN", base=0x0, name="player", asset_min=512, oaq="-", ptr_seeds=False,
        hand=[("playerpic", 0x1D54, 0x2010), ("playercareer", 0x2010, 0x23D0), ("playerpage", 0x23D0, 0x281C)],
        opts_off=(), string_calls=(),
    ),
    "STARTER": dict(
        disc="cdbin/STARTER.BIN", base=0x21300, name="starter", asset_min=512, oaq="-", ptr_seeds=True,
        hand=[("subboot", 0x0, 0x90), ("pcmclear", 0x3A0C, 0x3A76), ("cdcwait", 0x3A76, 0x3A8A), ("filmrun", 0x3D94, 0x3EAA),
              ("filmsm", 0x3EAA, 0x3FD0), ("pcmchip", 0x3FD0, 0x40FA), ("filmopen", 0x4336, 0x4538), ("filmtask", 0x458C, 0x472E),
              ("filmclose", 0x473A, 0x477C), ("filmcmd", 0x4D9E, 0x4DCA), ("filmbuf", 0x4E26, 0x4EC0), ("subheap", 0x4FA8, 0x5068),
              ("audiostream", 0x508C, 0x5304), ("cdfade", 0x54F6, 0x556E)],
        opts_off=("subboot", "subheap", "pcmclear", "cdcwait", "pcmchip", "audiostream", "cdfade"), string_calls=(),
        # calls that read inline data from the return address: 18 bytes of command words, or a length word
        inline_calls={0x24620: 18, 0xE320: 18, 0x24958: "w"},
    ),
    "MAIN": dict(
        disc="cdbin/MAIN.BIN", base=0xFF0000, name="main", asset_min=512,
        hand=[("maincd", 0x0, 0x272), ("maindma", 0x272, 0x500), ("maincont", 0x500, 0xCB8), ("mainblit", 0xCB8, 0x12C0),
              ("mainvdp", 0x12C0, 0x1840), ("mainpad", 0x1840, 0x1E90), ("maindisp", 0x1E90, 0x2D2A),
              ("mainfont", 0x2D2A, 0x302A), ("maintext", 0x302A, 0x34B8), ("hwread", 0x3B3C, 0x3C3E),
              ("z80load", 0x76C8, 0x77B8)],
        opts_off=("hwread", "z80load"), oaq="+", ptr_seeds=True,
        string_calls=(),
    ),
}


def sierra_tags(d):
    """Sierra C function name tags: byte 0x80|len, len ASCII, zero padding to even. -> {tag_addr: name}"""
    out = {}
    for i in range(0, len(d) - 4, 2):
        b = d[i]
        if b & 0x80:
            ln = b & 0x7F
            if 3 <= ln < 40 and i + 1 + ln <= len(d):
                t = d[i + 1:i + 1 + ln]
                if t[0:1].isalpha() and all(c < 128 and (chr(c).isalnum() or chr(c) == "_") for c in t):
                    end = i + 1 + ln
                    pad = (2 - (end % 2)) % 2
                    if d[end:end + pad] == b"\0" * pad:
                        out[i] = t.decode()
    return out


def git_text(path):
    return subprocess.run(["git", "show", "a8233dc:" + path], capture_output=True, text=True).stdout


def norm(s):
    return re.sub(r"\s+", "", s)


def lst_rows(frag):
    rows = []
    for l in open("/tmp/lst/%s .lst" % frag, errors="replace").read().replace("\r", "").split("\n"):
        if re.match(r"^[0-9A-F]{8} ", l):
            rows.append((int(l[:8], 16), l[9:36].strip(), l[36:] if len(l) > 36 else ""))
    return rows


def map_lines(src_lines, frag):
    """source line index -> runtime address (sequential text match against the listing)."""
    rows = lst_rows(frag)
    out = {}
    j = 0
    for i, l in enumerate(src_lines):
        if not l.strip():
            continue
        ns = norm(l)
        k = j
        while k < len(rows) and norm(rows[k][2]) != ns and not norm(rows[k][2]).endswith(ns):
            k += 1
        if k >= len(rows) or k - j > 60:
            continue
        out[i] = rows[k][0]
        j = k + 1
    return out


def main():
    key = sys.argv[1]
    cfg = CFG[key]
    d = open(cfg["disc"], "rb").read()
    base = cfg["base"]
    n = len(d)
    ddir = "src/segacd/" + cfg["name"]
    os.makedirs(ddir, exist_ok=True)
    adir = "Extracted/SegaCD/" + key
    os.makedirs(adir, exist_ok=True)

    # 1. hand fragments
    hand = {}
    for name, a, b in cfg["hand"]:
        src = git_text("src/segacd/%s.asm" % name).split("\n")
        hand[name] = dict(a=a, b=b, src=src, addr=map_lines(src, name))
    hack = {}  # label -> address, from `org X` followed by a bare label (maincd's link stubs)
    s = hand["maincd"]["src"] if "maincd" in hand else []
    for i, l in enumerate(s):
        m = re.match(r"^\torg\t\$([0-9A-F]+)\s*$", l)
        if m and i + 1 < len(s) and re.match(r"^[A-Za-z_]\w*\s*$", s[i + 1]) and int(m.group(1), 16) != base:
            hack[s[i + 1].strip()] = int(m.group(1), 16)
    # the first label above the first hack org is the end-of-fragment link target
    for i, l in enumerate(s):
        if l.startswith("; Bodies live later"):
            lab = s[i + 1].strip()
            hack[lab] = base + hand["maincd"]["b"]
            hand["maincd"]["src"] = s[:i]
            break
    names = {}  # runtime address -> label name
    for nm, ad in hack.items():
        names[ad] = nm
    hand_ranges = [(base + h["a"], base + h["b"]) for h in hand.values()]

    def in_hand(ad):
        return any(a <= ad < b for a, b in hand_ranges)

    # 2. every address the equates name
    equ = {}
    for name, h in hand.items():
        for l in h["src"]:
            m = re.match(r"^(X_[0-9A-F]+)\s+equ\s+\$([0-9A-F]+)", l)
            if m:
                equ[m.group(1)] = int(m.group(2), 16)
    # names the hand fragments already give (global labels in the listings)
    hnames = {}
    for name in hand:
        for addr, by, text in lst_rows(name):
            m = re.match(r"^([A-Za-z_]\w*)(?:\t|$)", text)
            if m and not re.fullmatch(r"(L|X_)[0-9A-F]+", m.group(1)):
                hnames.setdefault(addr, m.group(1))
    for ad, nm in hnames.items():
        names.setdefault(ad, nm)

    # 3. code in the gaps
    F.INLINE.clear()
    F.INLINE.update(cfg.get("inline_calls", {}))
    cov = bytearray(n)
    for a, b in ((x - base, y - base) for x, y in hand_ranges):
        for k in range(a, b):
            cov[k] = 1
    seeds = set()
    for nm, ad in equ.items():
        o = ad - base
        if 0 <= o < n and cov[o] == 0 and o % 2 == 0:
            seeds.add(o)
    for h in hand.values():
        for ln in h["src"]:
            for m in re.finditer(r"\$(FF[0-9A-F]{4})\b", ln):
                pass
    for i in range(0, n - 3, 2):
        if not cfg["ptr_seeds"]:
            break
        v = struct.unpack(">I", d[i:i + 4])[0]
        if base <= v < base + n and v % 2 == 0 and not cov[v - base]:
            seeds.add(v - base)
    link = [i for i in range(0, n - 1, 2) if d[i:i + 2] in (b"\x4e\x56", b"\x48\xe7") and not cov[i]]
    insns, calls, labs = {}, set(), set()
    # prologues first: a pointer-looking word can point into the middle of an instruction
    F.find_code_seeded(d, base, link, cov, insns, cfg["string_calls"])
    F.find_code_seeded(d, base, sorted(seeds), cov, insns, cfg["string_calls"])
    F.sweep(d, base, cov, insns, calls, labs, cfg["string_calls"])
    print("gap code: %d instructions" % len(insns), flush=True)

    # pointer tables in the gaps: runs of 3 or more longs that each point at an instruction we found
    ptr_runs = {}
    i = 0
    while i < n - 3:
        if i % 2 == 0 and not cov[i] and not in_hand(base + i):
            k = 0
            while i + 4 * k + 4 <= n and not any(cov[i + 4 * k:i + 4 * k + 4]):
                v = struct.unpack(">I", d[i + 4 * k:i + 4 * k + 4])[0] - base
                if v in insns:
                    k += 1
                else:
                    break
            if k >= 3:
                ptr_runs[i] = k
                i += 4 * k
                continue
        i += 2

    # 4. names. A hand label wins, then a hand generic label (L<addr>), then a new generic one.
    anyl = {}
    for name in hand:
        for addr, by, text in lst_rows(name):
            m = re.match(r"^([A-Za-z_]\w*)(?:\t|$)", text)
            if m:
                anyl.setdefault(addr, m.group(1))
    need = set(hack.values())

    def NAME(ad):
        if ad in names:
            return names[ad]
        if ad in anyl:
            return anyl[ad]
        nm = "L%X" % ad
        names[ad] = nm
        need.add(ad)
        return nm

    for _nm, _ad in equ.items():
        NAME(_ad)
    for _o, _k in ptr_runs.items():
        for _j in range(_k):
            NAME(struct.unpack('>I', d[_o + 4 * _j:_o + 4 * _j + 4])[0])

    # 5. the gap parts
    gaps = []
    pos = 0
    ranges = sorted((a, b) for a, b in ((x - base, y - base) for x, y in hand_ranges))
    for a, b in ranges + [(n, n)]:
        if pos < a:
            gaps.append((pos, a))
        pos = max(pos, b)
    decode = {}
    for p0 in insns:
        decode[p0] = F.decode_at(d, p0, base)
    # function entries for local labels
    entries = set(o for o in seeds | set(link) if o in insns) | set(calls)
    for ad in names:
        if 0 <= ad - base < n:
            entries.add(ad - base)
    for p0, g in decode.items():
        mn = g.mnemonic.split(".")[0]
        if mn in ("bsr", "jsr") or (mn == "jmp"):
            m = re.search(r"\$([0-9a-f]+)", g.op_str)
            if m and "(" not in g.op_str.replace("(pc)", "") or (m and "(pc)" in g.op_str):
                t = int(m.group(1), 16) - base
                if 0 <= t < n:
                    entries.add(t)
    # code runs start a function
    prev = None
    for p0 in sorted(decode):
        if prev is None or p0 != prev:
            entries.add(p0)
        prev = p0 + decode[p0].size
    ent_sorted = sorted(entries)
    import bisect

    def func_of(o):
        k = bisect.bisect_right(ent_sorted, o)
        return ent_sorted[k - 1] if k else None

    tag_names = {}
    used_tags = set()
    for tag_addr, nm in sierra_tags(d).items():
        tag_names[tag_addr] = nm
    # a Sierra C function is followed by its name tag; use it for the entry that ends right before the tag
    for o in sorted(entries):
        if o in insns:
            q = o
            last = None
            while q in decode:
                last = q
                q += decode[q].size
                if decode[last].mnemonic.split(".")[0] in ("rts", "rte"):
                    break
            if q in tag_names and last is not None and decode[last].mnemonic.startswith("rts"):
                ad = base + o
                if ad not in names and ad not in anyl and tag_names[q] not in used_tags:
                    used_tags.add(tag_names[q])
                    names[ad] = tag_names[q]
    labels_all = {}
    loc = set()

    def tgt_name(o_from, t_addr):
        o = t_addr - base
        if 0 <= o < n and o in insns or (0 <= o < n and cov[o]):
            pass
        nm = names.get(t_addr) or anyl.get(t_addr)
        if nm:
            return nm
        if 0 <= o < n and o in decode and func_of(o) == func_of(o_from) and o not in entries:
            loc.add(o)
            return ".l%X" % o
        return NAME(t_addr)

    def gen_gaps():
        out_parts = []
        for a, b in gaps:
            lines = []
            o = a
            # split points for labels in the gap
            pts = sorted({x - base for x in names if a <= x - base < b} | {x - base for x in anyl if a <= x - base < b} | {r for r in ptr_runs if a <= r < b} | {r + 4 * k for r, k in ptr_runs.items() if a <= r + 4 * k < b})
            while o < b:
                if o in decode:
                    g = decode[o]
                    ad = base + o
                    lab = ""
                    nm = names.get(ad) or anyl.get(ad)
                    if nm:
                        lab = nm
                    elif o in entries:
                        lab = "Sub_%X" % ad
                        names[ad] = lab
                    # local label if a branch in this function targets it
                    text = E.snasm_op(g, {}, base)
                    kind = g.mnemonic.split(".")[0]
                    raw = bytes(g.bytes)
                    if kind in E.BRANCH or "(pc)" in g.op_str or kind in ("jsr", "jmp", "bsr"):
                        m = re.search(r"\$([0-9a-f]+)", g.op_str)
                        if m:
                            t = int(m.group(1), 16)
                            if kind in E.BRANCH or "(pc)" in g.op_str or (len(raw) in (4, 6)):
                                if base <= t < base + n:
                                    nmt = tgt_name(o, t)
                                    text = E.snasm_op(g, {t: nmt}, base)
                    mn2 = g.mnemonic
                    if kind in ("btst", "bclr", "bset", "bchg") and re.search(r",d[0-7]$", text.replace(" ", "")):
                        mn2 = kind
                    if kind == "link":
                        mn2 = "link"   # SNASM has no link.w
                    if kind == "btst" and mn2 == "btst.l" and re.search(r",\(a[0-7]\)$", text.replace(" ", "")):
                        mn2 = "btst"   # SNASM: no size on a memory bit test
                    if kind == "moveq":
                        m = re.match(r"#\$([0-9A-F]+),(.*)", text)
                        if m and int(m.group(1), 16) >= 0x80:
                            text = "#%d,%s" % (int(m.group(1), 16) - 256, m.group(2))
                    lines.append((o, lab, "%s\t%s" % (mn2, text) if text else mn2, raw))
                    o += g.size
                    continue
                # data run up to the next code start or label
                e = o + 1
                while e < b and e not in decode and e not in pts:
                    e += 1
                lines.append((o, "", None, d[o:e]))
                o = e
            out_parts.append((a, b, lines))

        return out_parts
    gen_gaps()
    out_parts = gen_gaps()

    # 6. data runs into zero runs, assets and dc.b rows
    def emit_data(o, blob, labfn):
        res = []
        i = 0
        L = len(blob)
        while i < L:
            if o + i in ptr_runs:
                k = ptr_runs[o + i]
                for j in range(0, k, 4):
                    vals = [NAME(struct.unpack(">I", d[o + i + 4 * q:o + i + 4 * q + 4])[0]) for q in range(j, min(j + 4, k))]
                    res.append("%s\tdc.l\t%s" % (labfn(o + i + 4 * j) if j == 0 else "", ",".join(vals)))
                i += 4 * k
                continue
            if blob[i] == 0:
                j = i
                while j < L and blob[j] == 0:
                    j += 1
                if j - i >= 8:
                    res.append("%s\tdcb.b\t$%X,0" % (labfn(o + i), j - i))
                    i = j
                    continue
            # non-zero stretch up to the next long zero run
            j = i
            while j < L:
                if blob[j] == 0:
                    k = j
                    while k < L and blob[k] == 0:
                        k += 1
                    if k - j >= 8 or k == L and False:
                        break
                    j = k
                else:
                    j += 1
            seg = blob[i:j]
            if len(seg) >= cfg["asset_min"]:
                fn = "%s_%05X.bin" % (cfg["name"], o + i)
                open("%s/%s" % (adir, fn), "wb").write(seg)
                res.append("%s\tincbin\t..\\Extracted\\SegaCD\\%s\\%s" % (labfn(o + i), key, fn))
                assets[fn] = dict(start=o + i, size=len(seg))
            else:
                for k in range(0, len(seg), 16):
                    chunk = seg[k:k + 16]
                    asc = "".join(chr(c) if 32 <= c < 127 and chr(c) not in "'\\;" else "." for c in chunk)
                    res.append("%s\tdc.b\t%s\t; %s" % (labfn(o + i + k) if k == 0 else "", ",".join("$%02X" % c for c in chunk), asc))
            i = j
        return res

    assets = {}
    gen_files = []
    for a, b, lines in out_parts:
        text = []
        for o, lab, ins, raw in lines:
            if ins is None:
                def labfn(x):
                    nm = names.get(base + x) or anyl.get(base + x)
                    return nm or ""
                text += emit_data(o, raw, labfn)
            else:
                lab = names.get(base + o) or anyl.get(base + o) or (".l%X" % o if o in loc else "")
                text.append("%s\t%s\t;@%s" % (lab, ins, raw.hex()))
        fn = "%s/%s_%05X.asm" % (ddir, cfg["name"], a)
        open(fn, "w").write("\n".join(text) + "\n")
        gen_files.append((a, b, fn))
    print("gap parts:", len(gen_files), "assets:", len(assets), "need labels in hand parts:", len(need), flush=True)
    json.dump(assets, open("%s/assets.json" % ddir, "w"), indent=1)

    # 7. hand parts: no equates, labels where the equates pointed
    def eq_name(m):
        nm = m.group(0)
        return NAME(equ[nm]) if nm in equ else nm
    parts = []
    unresolved = []
    for name, a, b in cfg["hand"]:
        h = hand[name]
        keep = []   # (orig index, text)
        for i, l in enumerate(h["src"]):
            if re.match(r"^X_[0-9A-F]+\s+equ\s+", l) or re.match(r"^\torg\t", l):
                continue
            keep.append([i, re.sub(r"\bX_[0-9A-F]+\b", eq_name, l)])
        h["keep"] = keep
        parts.append((a, b, "hand", name))
    for ad in sorted(need):
        o = ad - base
        for name, a, b in cfg["hand"]:
            if a <= o < b:
                h = hand[name]
                idx = [si for si, addr in h["addr"].items() if addr == ad]
                if not idx:
                    unresolved.append(ad)
                    continue
                for ent in h["keep"]:
                    if ent[0] == idx[0]:
                        t = ent[1]
                        m = re.match(r"^([A-Za-z_.]\w*)(\t|$)", t)
                        if m and not m.group(1).startswith("."):
                            names[ad] = m.group(1)   # already labelled (generic)
                        elif m:
                            unresolved.append(ad)    # local label here: keep an equate instead
                        else:
                            ent[1] = names[ad] + t
    print("unresolved (kept as equates):", [hex(x) for x in unresolved], flush=True)
    for name, a, b in cfg["hand"]:
        h = hand[name]
        pre = ""
        txt = "\n".join(e[1] for e in h["keep"])
        for ad in unresolved:
            pass
        open("%s/%s.asm" % (ddir, name), "w").write(txt + "\n")
    if unresolved:
        eqs = ["%s\tequ\t$%X" % (names[ad], ad) for ad in unresolved]
        open("%s/equates.asm" % ddir, "w").write("\n".join(eqs) + "\n")
    for a, b, fn in gen_files:
        parts.append((a, b, "gen", os.path.basename(fn)[:-4]))
    parts.sort()
    print("parts", len(parts))
    # 8. top file
    top = ["\tinclude\tmacros\\genesis.mac", "", "\torg\t$%X" % base, ""]
    if unresolved:
        top.insert(1, "\tinclude\tsegacd\\%s\\equates.asm" % cfg["name"])
    for a, b, kind, nm in parts:
        if kind == "hand" and nm in cfg["opts_off"]:
            p0 = "%s/%s.asm" % (ddir, nm)
            t0 = open(p0).read()
            flip = "+" if cfg["oaq"] == "-" else "-"
            if not t0.startswith("\topt\toaq" + flip):
                open(p0, "w").write("\topt\toaq%s\n\topt\tosq%s\n" % (flip, flip) + t0 + "\topt\toaq%s\n\topt\tosq%s\n" % (cfg["oaq"], cfg["oaq"]))
        top.append("\tinclude\tsegacd\\%s\\%s.asm" % (cfg["name"], nm))
    open("src/segacd/%s.asm" % cfg["name"], "w").write("\n".join(top) + "\n")
    return parts, ddir


def asm_opts(cfg):
    return ["/o", "d-", "/o", "s-", "/o", "r+", "/o", "l+", "/o", "l.", "/o", "ow+", "/o", "op-", "/o", "os+", "/o", "oz-",
            "/o", "omq-", "/o", "oaq" + cfg["oaq"], "/o", "osq" + cfg["oaq"]]


def assemble(cfg):
    t = "Z:\\tmp\\new\\" + cfg["name"]
    os.makedirs("/tmp/new", exist_ok=True)
    r = subprocess.run(["wine", "../assembler/Assembler.exe", "/p", "/m", "/g"] + asm_opts(cfg) +
                       ["segacd\\%s.asm,%s.bin,%s,%s" % (cfg["name"], t, t, t)],
                       cwd="src", capture_output=True, text=True, env={**os.environ, "WINEDEBUG": "-all"})
    txt = r.stdout.replace("\r", "")
    errs = []
    for l in txt.split("\n"):
        m = re.search(r"SEGACD\\(?:\w+\\)?(\w+)\.ASM\((\d+)", l, re.I)
        if m:
            errs.append((m.group(1).lower(), int(m.group(2)), l[-70:]))
    return errs, txt


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


def fixloop(cfg, parts, ddir, d):
    base = cfg["base"]
    gen = [(nm, a) for a, b, kind, nm in parts if kind == "gen"]
    files = {nm: open("%s/%s.asm" % (ddir, nm)).read().split("\n") for nm, a in gen}
    for rnd in range(60):
        for nm, ls in files.items():
            open("%s/%s.asm" % (ddir, nm), "w").write("\n".join(ls))
        errs, txt = assemble(cfg)
        print("round", rnd, "errors", len(errs), errs[:2], flush=True)
        if errs:
            conv = 0
            for fn, ln, msg in errs:
                key = next((k for k in files if k.lower() == fn), None)
                if key and ln - 1 < len(files[key]):
                    w = to_words(files[key][ln - 1])
                    if w:
                        files[key][ln - 1] = "\x00".join(w)
                        conv += 1
            if not conv:
                print("unfixable", errs[:6])
                return False
            for k in files:
                files[k] = "\n".join(files[k]).replace("\x00", "\n").split("\n")
            continue
        out = open("/tmp/new/%s.bin" % cfg["name"], "rb").read()
        if out == d:
            return True
        lst = open("/tmp/new/%s .lst" % cfg["name"], errors="replace").read().replace("\r", "").split("\n")
        # every listing row of a tagged line: compare its bytes with the tag
        flagged = set()
        rows = []
        for ll in lst:
            m = re.search(r";@([0-9a-f]+)\s*$", ll)
            if m and re.match(r"^[0-9A-F]{8} ", ll):
                rows.append((int(ll[:8], 16), ll[9:36], m.group(1), ll))
        # which file/line is each row? match in order against the tagged lines
        tagged = []
        for nm, a in gen:
            for i, l in enumerate(files[nm]):
                if re.search(r";@[0-9a-f]+\s*$", l):
                    tagged.append((nm, i, l))
        if len(rows) != len(tagged):
            print("row/tag count differs", len(rows), len(tagged))
        bad = 0
        for k, ((addr, bytes_s, exp, ll), (nm, i, l)) in enumerate(zip(rows, tagged)):
            got = re.sub(r"[^0-9A-Fa-f+]", "", bytes_s).lower()
            exp_b = exp
            nxt = rows[k + 1][0] - addr if k + 1 < len(rows) else None
            wrong = False
            mnr = re.sub(r"^\S*\t", "", ll[36:]).strip().split("\t")[0].split(".")[0].lower() if len(ll) > 36 else ""
            if mnr in E.BRANCH or mnr in ("jsr", "jmp", "bsr", "lea", "pea"):
                got = got[:4]
                exp_b = exp_b[:4]
                if mnr in E.BRANCH and len(exp) == 4:
                    # short branch: the displacement byte is not final in the listing, compare the opcode byte
                    got = got[:2]
                    exp_b = exp_b[:2]
            if "+" in got:
                got = got.replace("+", "")
                wrong = not exp_b.startswith(got)
            else:
                wrong = got != exp_b[:len(got)] or (len(got) < len(exp_b) and False)
            # (an instruction that assembled longer or shorter shows in the first-difference fallback below)
            if wrong:
                w = to_words(l)
                if w:
                    files[nm][i] = "\x00".join(w)
                    bad += 1
        # data diffs outside tagged lines are caught by size drift only
        if not bad:
            # compare binaries to find the first difference and convert the nearest tagged line before it
            diff = next((i for i in range(min(len(out), len(d))) if out[i] != d[i]), None)
            print("no flagged row; first diff", None if diff is None else hex(diff), len(out), len(d))
            if diff is None:
                return False
            ad = diff + base
            cand = [(a2, nm, i, l) for (a2, _, e, ll), (nm, i, l) in zip(rows, tagged) if a2 <= ad]
            if not cand:
                return False
            a2, nm, i, l = cand[-1]
            w = to_words(l)
            if not w:
                return False
            files[nm][i] = "\x00".join(w)
        for k in files:
            files[k] = "\n".join(files[k]).replace("\x00", "\n").split("\n")
    return False


if __name__ == "__main__":
    parts, ddir = main()
    d = open(CFG[sys.argv[1]]["disc"], "rb").read()
    if "--fix" in sys.argv:
        ok = fixloop(CFG[sys.argv[1]], parts, ddir, d)
        print("converged" if ok else "FAILED")
        if ok:
            for a, b, kind, nm in parts:
                if kind == "gen":
                    p0 = "%s/%s.asm" % (ddir, nm)
                    txt0 = open(p0).read().split("\n")
                    open(p0, "w").write("\n".join(re.sub(r"\t;@[0-9a-f]*\s*$", "", l) for l in txt0))
