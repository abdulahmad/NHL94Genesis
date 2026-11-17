#!/usr/bin/env python3
"""Carry 94G comments and local labels onto a generated HOCKEY.BIN fragment.

For each routine that has the same global label in the cartridge source and in the
disc fragment, the two instruction lists are aligned by mnemonic (difflib). An aligned
disc instruction gets the cartridge line's comment, and a disc label (Lxxxx) on an
aligned instruction takes the cartridge local label (.0 .1 .loop ...). Routine header
comments are copied. Anything the cartridge does not have (CD code) is left alone.

  python3 tools/hockey_align.py src/scout94.asm src/segacd/scout94.asm
"""
import difflib
import re
import sys

FAM = {"addq": "add", "addi": "add", "subq": "sub", "subi": "sub", "movea": "move", "cmpi": "cmp", "cmpa": "cmp",
       "adda": "add", "suba": "sub", "andi": "and", "ori": "or", "eori": "eor", "lea": "lea"}


def base(mn):
    mn = mn.lower().split(".")[0]
    return FAM.get(mn, mn)


def parse(path, disc):
    """-> list of routines: (name, header_comments, [lines]) ; line = dict(label, ins, mn, comment, raw)"""
    routines, cur = [], None
    for raw in open(path).read().split("\n"):
        m = re.match(r"^([A-Za-z_][\w]*)(?:\t+|\s+|$)(.*)$", raw)
        glob = None
        if m and not raw.startswith(("\t", ";", " ")):
            name, rest = m.group(1), m.group(2)
            if name in ("include", "org") or re.match(r"^\w+\s+equ\b", raw):
                continue
            is_local_disc = disc and re.match(r"^L[0-9A-F]{4,5}$", name)
            if not is_local_disc:
                glob = name
        if glob:
            cur = [glob, [], []]
            routines.append(cur)
            rest = m.group(2)
            raw = "\t" + rest if rest.strip() else ""
            cur[1].append(m.group(2).partition(";")[2])  # comment on the label line
            # an instruction may follow the global label on the same line
            if raw.strip() and not raw.strip().startswith(";"):
                cur[2].append(parse_line("", raw.strip()))
            continue
        if cur is None:
            continue
        if not raw.strip():
            continue
        lab = None
        mm = re.match(r"^([.\w]+)(?:\t+| +|$)(.*)$", raw) if not raw.startswith(("\t", " ", ";")) else None
        if mm:
            lab, raw = mm.group(1), mm.group(2)
            if not raw.strip() or raw.strip().startswith(";"):
                cur[2].append({"label": lab, "ins": None, "mn": None, "comment": raw.strip().lstrip(";").strip(), "pure": True})
                continue
        cur[2].append(parse_line(lab, raw.strip()))
    return routines


def parse_line(lab, text):
    code, _, com = text.partition(";")
    code = code.strip()
    if not code:
        return {"label": lab, "ins": None, "mn": None, "comment": com.strip(), "pure": True}
    mn = code.split()[0]
    return {"label": lab, "ins": code, "mn": base(mn) if not code.startswith(("dc.", "String")) else code.split()[0].split(".")[0], "comment": com.strip(), "pure": False}


def main():
    cart = {r[0]: r for r in parse(sys.argv[1], False)}
    text = open(sys.argv[2]).read().split("\n")
    disc = parse(sys.argv[2], True)
    # map global label -> index in file lines (header line index) by scanning
    out = text[:]
    # build per routine rewriting: we rewrite instruction lines by matching text
    renames = {}
    comments = {}   # (routine, idx among ins lines) -> comment
    hdr = {}
    for name, hcom, lines in disc:
        if name not in cart:
            continue
        cn, chead, clines = cart[name]
        # header comments: comment on the label line plus the pure-comment lines right after
        head = [c for c in chead if c.strip()]
        k = 0
        pending = []
        while k < len(clines) and clines[k].get("pure") and not clines[k]["label"]:
            pending.append(clines[k]["comment"])
            k += 1
        hdr[name] = ([h.strip().lstrip(";").strip() for h in head if h.strip()], pending)
        cins = [l for l in clines if not l.get("pure")]
        dins = [l for l in lines if not l.get("pure")]
        sm = difflib.SequenceMatcher(None, [l["mn"] for l in cins], [l["mn"] for l in dins], autojunk=False)
        # cartridge label that precedes each cart instruction (label-only lines attach to next)
        clab = {}
        pend = []
        for l in clines:
            if l.get("pure"):
                if l["label"]:
                    pend.append((l["label"], l["comment"]))
                continue
            labs = pend + ([(l["label"], "")] if l["label"] else [])
            pend = []
            clab[id(l)] = labs
        for tag, i1, i2, j1, j2 in sm.get_opcodes():
            if tag != "equal" or (i2 - i1) < 3:
                continue
            for a, b in zip(range(i1, i2), range(j1, j2)):
                cl, dl = cins[a], dins[b]
                if cl["comment"]:
                    comments[(name, id(dl))] = cl["comment"]
                dl["_cart"] = clab.get(id(cl), [])
                if dl["label"] and re.match(r"^L[0-9A-F]{4,5}$", dl["label"]) and dl["_cart"]:
                    renames[(name, dl["label"])] = dl["_cart"][0][0]
    # apply: rewrite file by walking routines in order
    res, cur = [], None
    names = {r[0] for r in disc}
    drout = {r[0]: r for r in disc}
    # label renames per routine; collisions: skip if cart label already used
    for name, hcom, lines in disc:
        used = set()
        for (rn, old), new in list(renames.items()):
            if rn == name:
                if new in used or any(l["label"] == new for l in lines):
                    del renames[(rn, old)]
                else:
                    used.add(new)
    cur = None
    iidx = {}
    for name, hcom, lines in disc:
        for l in lines:
            iidx[id(l)] = l
    # simple re-emission: go line by line over `text`, tracking routine and ins order
    ri = -1
    li = 0
    result = []
    routs = disc
    cur_r = None
    for raw in text:
        m = re.match(r"^([A-Za-z_]\w*)(?:\t+| +|$)(.*)$", raw)
        if m and not raw.startswith(("\t", ";", " ")) and not re.match(r"^\w+\s+equ\b", raw) and m.group(1) not in ("include", "org") and not re.match(r"^L[0-9A-F]{4,5}$", m.group(1)):
            name = m.group(1)
            cur_r = drout.get(name)
            li = 0
            if name in hdr and cur_r is not None:
                head, pend = hdr[name]
                first = (head[0] if head else "")
                line = name + ("\t\t\t\t\t\t" + ";" + first if first else "")
                result.append(line)
                for p in (head[1:] + pend):
                    result.append("\t\t\t\t\t\t\t\t\t;" + p)
                # keep the rest of the original label line if it had an instruction
                if m.group(2).strip() and not m.group(2).strip().startswith(";"):
                    result.append("\t" + m.group(2).strip())
                    li += 1
                cur_r_lines = [l for l in cur_r[2]]
                continue
            result.append(raw)
            continue
        if cur_r is None or not raw.strip() or raw.startswith(";"):
            result.append(raw)
            continue
        # find this line among cur_r lines in order
        lab = None
        mm = re.match(r"^([.\w]+)(?:\t+| +|$)(.*)$", raw) if not raw.startswith(("\t", " ")) else None
        body = raw
        if mm:
            lab, body = mm.group(1), mm.group(2)
        if not body.strip():
            result.append(raw)
            continue
        dl = None
        while li < len(cur_r[2]):
            cand = cur_r[2][li]
            li += 1
            if cand.get("pure"):
                continue
            dl = cand
            break
        if dl is None:
            result.append(raw)
            continue
        newlab = lab
        extra = []
        code = body.split(";")[0].strip()
        com = comments.get((cur_r[0], id(dl)), "")
        # label-only comment lines of the cartridge (e.g. '.0 ;d0 negative')
        pre = []
        if dl.get("_cart"):
            for ln, lc in dl["_cart"]:
                if lc and ln == (renames.get((cur_r[0], lab)) if lab else None):
                    pre.append((ln, lc))
        line = (newlab if newlab else "") + "\t" + code
        if com:
            line += "\t\t;" + com
        result.append(line)
    # rename branch operands
    for (rn, old), new in renames.items():
        pass
    final = "\n".join(result)
    # operand renames need routine scoping: do it routine by routine
    parts = re.split(r"(?m)^(?=(?!L[0-9A-F]{4,5}\b)[A-Za-z_]\w*(?:\t|\s|$))", final)
    outp = []
    for part in parts:
        m = re.match(r"^([A-Za-z_]\w*)", part)
        nm = m.group(1) if m else None
        for (rn, old), new in renames.items():
            if rn == nm:
                part = re.sub(r"\b" + old + r"\b", new, part)
        part = re.sub(r"(?<![\w.])L([0-9A-F]{4,5})\b", r".l\1", part)
        outp.append(part)
    open(sys.argv[2], "w").write("".join(outp))
    print("labels renamed:", len(renames), "comments:", len(comments))


if __name__ == "__main__":
    main()
