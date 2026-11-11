#!/usr/bin/env python3
"""Port a range of the cartridge source to a HOCKEY.BIN fragment.

HOCKEY.BIN is the cartridge game linked again for the sub CPU (loaded at $1B000) with long
absolute addresses and no branch / quick-form optimisation. This tool walks the cartridge
source of one 94G file (from the build listing) and the disc bytes side by side:

  * an instruction whose disc decode is the cartridge instruction with relocated operands is
    written with the cartridge source's labels, symbols and comments, and the disc encoding
    (bsr.w for bsr.s, addi for addq, (sym).l for (sym).w ...);
  * data that is byte-equal is copied from the source line (String macros and all);
  * disc bytes with no cartridge twin are written as plain instructions under a "CD:" comment;
  * cartridge lines with no disc twin are dropped (counted in the report).

Symbols the fragment uses but does not define are solved from the disc operands: a RAM name
(the cartridge has it at $FFxxxx) goes into the shared include (one HOCKEY.BIN RAM map for all
fragments), a constant keeps its cartridge value, and a routine outside the fragment becomes an
equate at the top of the fragment. Anything that cannot be solved stays a number.

After writing the file it is assembled the same way build.js does, and any instruction that
SNASM encodes differently from the disc is replaced by its dc.w bytes (with a comment), so the
result matches by construction; the report says how many lines needed that.

  python tools/segacd_port.py --file onetimer94.asm --disc-start 0x76A8 --disc-end 0x7DDE \\
      --out src/segacd/hockey/onetimer94.asm

Needs the cartridge listing (output/obj/nhl94 .lst from npm run build:retail, or --lst), the
retail ROM (for the real bytes; the listing leaves forward references as 0), and cdbin/HOCKEY.BIN.
"""

import argparse
import os
import re
import subprocess
import sys

from capstone import Cs, CS_ARCH_M68K, CS_MODE_BIG_ENDIAN, CS_MODE_M68K_000

sys.dont_write_bytecode = True           # no tools/__pycache__ files from the import below
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from segacd_comments import fix_layout   # noqa: E402  (comment columns, widths, paragraphs: CONTRIBUTING.md)

md = Cs(CS_ARCH_M68K, CS_MODE_M68K_000 | CS_MODE_BIG_ENDIAN)
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
BASE = 0x1B000
NO_TEXT = False             # --no-text: never write text from the disc (team data)
OPTIONS = ["/o", "d-", "/o", "s-", "/o", "r+", "/o", "l+", "/o", "l.", "/o", "ow+", "/o", "op-",
           "/o", "os+", "/o", "oz-", "/o", "omq-", "/o", "oaq-", "/o", "osq-"]

BRANCHES = {"bra", "bsr", "beq", "bne", "bhi", "bls", "bcc", "bcs", "bpl", "bmi", "bvc", "bvs",
            "bge", "bgt", "ble", "blt", "bhs", "blo"}
DBCC = {"dbra", "dbf", "dbt", "dbeq", "dbne", "dbhi", "dbls", "dbcc", "dbcs", "dbpl", "dbmi",
        "dbvc", "dbvs", "dbge", "dbgt", "dble", "dblt"}
DATA = {"dc", "dc.b", "dc.w", "dc.l", "ds", "ds.b", "ds.w", "ds.l", "dcb", "dcb.b", "dcb.w", "dcb.l"}
ALIGN = {"even", "cnop", "align"}
DIRECTIVES = {"include", "if", "ifd", "ifnd", "else", "elseif", "endif", "endc", "inform", "opt",
              "list", "nolist", "rsset", "rsreset", "module", "modend", "section", "incbin_off"}
REGS = {f"d{i}" for i in range(8)} | {f"a{i}" for i in range(8)} | {"sp", "pc", "sr", "ccr", "usp"}
ID = r"[A-Za-z_.@][\w.@$]*"


# ---------------------------------------------------------------- listing

class Line:
    __slots__ = ("addr", "field", "mac", "src", "n")

    def __init__(self, addr, field, mac, src, n):
        self.addr, self.field, self.mac, self.src, self.n = addr, field, mac, src, n


def is_ram(name, cglob, ckind):
    """A cartridge RAM address ($FFxxxx); a small negative equate (CC_PageEnd equ -1) is a constant."""
    v = cglob.get(name)
    if v is None or v < 0xFF0000:
        return False
    return not (ckind.get(name) == "equ" and v >= 0xFFFFFF00)


def read_listing(path):
    out = []
    with open(path, encoding="latin1") as f:
        for n, raw in enumerate(f):
            raw = raw.rstrip("\r\n")
            if len(raw) < 9 or not re.match(r"[0-9A-F]{8} ", raw):
                continue
            out.append(Line(int(raw[:8], 16), raw[9:34].strip(), len(raw) > 34 and raw[34] == "M",
                            raw[36:] if len(raw) > 36 else "", n))
    return out


def split_comment(s):
    """(code, comment) with the comment starting at a ; outside quotes."""
    q = None
    for i, ch in enumerate(s):
        if q:
            if ch == q:
                q = None
        elif ch in "'\"":
            q = ch
        elif ch == ";":
            return s[:i], s[i:]
    return s, ""


def split_ops(s):
    """Split an operand field at top-level commas."""
    out, depth, q, cur = [], 0, None, ""
    for ch in s:
        if q:
            cur += ch
            if ch == q:
                q = None
            continue
        if ch in "'\"":
            q = ch
        elif ch == "(":
            depth += 1
        elif ch == ")":
            depth -= 1
        elif ch == "," and depth == 0:
            out.append(cur.strip())
            cur = ""
            continue
        cur += ch
    if cur.strip():
        out.append(cur.strip())
    return out


def parse_src(src):
    """label, mnemonic, operands, comment of one source line."""
    code, comment = split_comment(src)
    label = None
    m = re.match(r"(" + ID + r"):?", code)
    if m and not code[:1].isspace():
        label = m.group(1)
        code = code[m.end():]
    parts = code.strip().split(None, 1)
    mnem = parts[0] if parts else ""
    ops = parts[1].strip() if len(parts) > 1 else ""
    return label, mnem, ops, comment


def symbols(lines):
    """Cartridge symbol values: global labels, local labels (scope, name), equates."""
    glob, kind, local = {}, {}, {}
    scope = None
    for ln in lines:
        if ln.mac:
            continue
        code, _ = split_comment(ln.src)
        m = re.match(r"(" + ID + r")(:?)(\s+(.*))?$", code)
        if not m or code[:1].isspace():
            continue
        name = m.group(1)
        rest = (m.group(4) or "").strip()
        low = rest.lower()
        eq = re.match(r"(equ|set|rs\.[bwl]|rs|=|equr|reg|macro)\b", low) or low.startswith("=")
        if eq:
            if ln.field.startswith("="):
                glob[name] = int(ln.field[1:9], 16)
                kind[name] = "rs" if low.startswith("rs") else "equ"
            continue
        if name.startswith("."):
            local[(scope, name)] = ln.addr
        else:
            glob[name] = ln.addr
            kind[name] = "label"
            scope = name
    return glob, kind, local


# ---------------------------------------------------------------- items

class Item:
    def __init__(self, ln, label, mnem, ops, comment, scope):
        self.ln = ln
        self.addr = ln.addr
        self.label, self.mnem, self.ops, self.comment = label, mnem, ops, comment
        self.scope = scope           # global label in force for local names
        self.pre = []                # comment lines and labels before this item
        self.licensed = False        # from an Extracted/ include: the bytes come from the disc file
        self.exp = []                # macro expansion lines
        self.len = 0
        self.kind = None             # insn / data / align / macro / dir
        self.cart = b""
        self.norm = None


def build_items(lines, lo, hi, rom, cart_glob, nlo=None, nhi=None):
    if nlo is not None:
        sel = [ln for ln in lines if nlo < ln.n < nhi]
    else:
        sel = [ln for ln in lines if lo <= ln.addr < hi]
    items, pre = [], []
    scope = None
    i = 0
    lic_left = 0                 # lines still to come from an Extracted/ include (licensed text)
    lic_lines = set()
    while i < len(sel):
        ln = sel[i]
        if ln.mac:
            i += 1
            continue
        if lic_left:
            lic_left -= 1
            lic_lines.add(ln.n)
        label, mnem, ops, comment = parse_src(ln.src)
        low = mnem.lower()
        if low == "include" and "extracted" in ops.lower():
            path = os.path.join(ROOT, "src", ops.split()[0].replace("\\", os.sep))
            if not os.path.exists(path):
                sys.exit(f"{path}: needed to know which lines are licensed text (run npm run build:retail)")
            lic_left = len(open(path, encoding="latin1").read().rstrip("\n").split("\n"))
        if label and not label.startswith("."):
            code = split_comment(ln.src)[0]
            if re.match(r"\S+\s+(equ|set|rs|=|macro|reg|equr)\b", code, re.I) or re.match(r"\S+\s*=", code):
                pre.append(("dir", ln))
                i += 1
                continue
            scope = label
        if not mnem:
            pre.append(("label" if label else "text", ln))
            i += 1
            continue
        it = Item(ln, label, mnem, ops, comment, scope)
        it.pre, pre = [x for x in pre if x[1].n not in lic_lines], []
        it.licensed = ln.n in lic_lines
        j = i + 1
        while j < len(sel) and sel[j].mac:
            it.exp.append(sel[j])
            j += 1
        # next non-macro line gives the end address
        nxt = hi
        for k in range(j, len(sel)):
            if not sel[k].mac:
                nxt = sel[k].addr
                break
        else:
            nxt = hi
        it.len = max(0, nxt - it.addr)
        it.cart = rom[it.addr:it.addr + it.len]
        if low in DATA or low == "incbin":
            it.kind = "data"
        elif low in ALIGN:
            it.kind = "align"
        elif low in DIRECTIVES:
            it.kind = "dir"
        elif it.exp:
            it.kind = "macro"
        elif it.len == 0:
            it.kind = "dir"
        else:
            it.kind = "insn"
            d = decode(rom, it.addr, it.addr + it.len, 0)
            if d is None or d.size != it.len:
                it.kind = "data"
            else:
                it.norm = norm(d)
        items.append(it)
        i = j
    tail = pre
    return items, tail


# ---------------------------------------------------------------- decoding

_cache = {}


def decode(blob, pc, end, base):
    key = (id(blob), pc, base)
    if key in _cache:
        return _cache[key]
    got = None
    if pc + 2 <= len(blob) and not (base + pc) & 1:      # no instruction at an odd address
        for insn in md.disasm(blob[pc:pc + 10], base + pc):
            got = insn
            break
    if got is not None:
        raw = bytes(got.bytes)
        if got.size < 2 or pc + got.size > end or got.mnemonic in ("dc.w", "illegal"):
            got = None
        elif got.mnemonic.startswith("ori") and got.size == 2:
            got = None                       # capstone reads 0000 as a two-byte ori
        elif "*" in got.op_str or "[" in got.op_str or "{" in got.op_str or "invalid" in got.op_str:
            got = None                       # a 68020 form (scaled index, memory indirect): data here
        elif len(split_ops(got.op_str)) > 2:
            got = None                       # three operands (pack / unpk read as sbcd): not a 68000 form
        elif got.mnemonic.split(".")[0] in BRANCHES | DBCC and re.search(r"\$([0-9a-f]+)$", got.op_str) \
                and int(re.search(r"\$([0-9a-f]+)$", got.op_str).group(1), 16) & 1:
            got = None                       # a branch to an odd address: data here
    _cache[key] = got
    return got


TMOFS = re.compile(r"#tm\w+|(?<![\w.])tm\w+\(")


def loose(n):
    n = re.sub(r"#-?\$[0-9a-f]+", "#@", n)
    return re.sub(r"-?\$[0-9a-f]+\(", "@(", n)


def norm(insn):
    m = insn.mnemonic
    op = insn.op_str
    base = m.split(".")[0]
    if base in BRANCHES:
        return base + " @"
    if base in DBCC:
        return "dbra " + op.split(",")[0]
    sz = m.split(".")[-1] if "." in m else ""
    if base in ("cmp", "add", "sub", "and", "or", "eor") and op.startswith("#"):
        base = base + "i"
    if base == "moveq":
        base, sz = "move", "l"
    if base in ("movea", "cmpa", "adda", "suba") and re.match(r"#\$[0-9a-f]{3,}", op):
        sz = ""                         # movea.w #ram (sign-extends to $FFxxxx) on the cartridge is .l here
    if base in ("addq", "addi"):
        base = "add"
    elif base in ("subq", "subi"):
        base = "sub"
    m = base + ("." + sz if sz else "")
    if base in ("jsr", "jmp") and "(pc" not in op and re.match(r"\$[0-9a-f]+(\.[wl])?$", op):
        return base + " @"
    if base in ("jsr", "jmp", "lea", "pea") and re.match(r"\$[0-9a-f]+(\.[wl]|\(pc\))", op):
        op = re.sub(r"\$[0-9a-f]+(\.[wl]|\(pc\))", "@", op)    # jsr x.l <-> bsr / lea (pc) <-> lea x.l
    op = re.sub(r"(?<![\w$])\$0\((a[0-7])", r"(\1", op)
    op = re.sub(r"(?<![\w$-])\$[0-9a-f]{3,}\((a[0-7])", r"@(\1", op)  # struct offsets can differ on the disc       # Xpos(a3), Xpos = 0: (a3) on the cartridge
    op = re.sub(r"\$[0-9a-f]+\.[wl]", "@", op)
    op = re.sub(r"\$[0-9a-f]+\(pc", "@(pc", op)
    op = re.sub(r"#\$[0-9a-f]{3,}", "#@", op)
    return m + " " + op


# ---------------------------------------------------------------- operands

def fmt_num(n):
    return f"${n:X}"


def disc_operands(insn):
    """Capstone operands -> list of dicts: text (SNASM), mode, value."""
    out = []
    for op in split_ops(insn.op_str.replace(", ", ",")):
        o = {"raw": op, "mode": "reg", "value": None, "text": None}
        t = re.sub(r"\ba7\b", "sp", op)
        m = re.match(r"#(-?)\$([0-9a-f]+)$", t)
        if m:
            o["mode"], o["value"] = "imm", int(m.group(2), 16) * (-1 if m.group(1) else 1)
        elif re.match(r"\$([0-9a-f]+)\.([wl])$", t):
            m = re.match(r"\$([0-9a-f]+)\.([wl])$", t)
            v = int(m.group(1), 16)
            if m.group(2) == "w" and v >= 0x8000:
                v |= 0xFFFF0000
            o["mode"], o["value"], o["size"] = "abs", v, m.group(2)
        elif re.match(r"(-?)\$([0-9a-f]+)\(pc(,.*)?\)$", t):
            m = re.match(r"(-?)\$([0-9a-f]+)\(pc(,.*)?\)$", t)
            o["mode"], o["value"], o["idx"] = "pcrel", int(m.group(2), 16), m.group(3) or ""
        elif re.match(r"(-?)\$([0-9a-f]+)\((a[0-7]|sp)(,.*)?\)$", t):
            m = re.match(r"(-?)\$([0-9a-f]+)\((a[0-7]|sp)(,.*)?\)$", t)
            o["mode"] = "disp"
            o["value"] = int(m.group(2), 16) * (-1 if m.group(1) else 1)
            o["reg"], o["idx"] = m.group(3), m.group(4) or ""
        elif re.match(r"\$([0-9a-f]+)$", t):
            o["mode"], o["value"] = "target", int(t[1:], 16)
        o["t"] = t
        out.append(o)
    return out


def snasm_text(o, insn):
    """Numeric SNASM text for one disc operand."""
    t, mode, v = o["t"], o["mode"], o["value"]
    base = insn.mnemonic.split(".")[0]
    if mode == "imm":
        if base == "moveq" and v >= 0x80:
            return f"#{v - 256}"
        return "#" + (f"-${-v:X}" if v < 0 else fmt_num(v))
    if mode == "abs":
        return f"${v:X}.{o['size']}"
    if mode == "disp":
        d = f"-${-v:X}" if v < 0 else fmt_num(v)
        return f"{d}({o['reg']}{o['idx']})"
    if mode in ("pcrel", "target"):
        return None                     # resolved by the caller (label or equate)
    return re.sub(r"\$([0-9a-f]+)", lambda m: "$" + m.group(1).upper(), t)


def cart_expr(op, mode):
    """Expression part of a cartridge operand for a given disc mode, or None."""
    s = op.strip()
    if mode == "imm":
        return s[1:].strip() if s.startswith("#") else None
    if mode == "abs":
        m = re.match(r"^\((.*)\)\.([wlWL])$", s) or re.match(r"^(.*?)\.([wlWL])$", s)
        if m:
            return m.group(1)
        if "(" in s and not s.startswith("("):
            return None
        return s
    if mode in ("disp", "pcrel"):
        m = re.match(r"^(.*?)\(\s*(a[0-7]|sp|pc)\s*(,.*)?\)$", s, re.I)
        if m:
            return m.group(1).strip() or "0"
        return None
    if mode == "target":
        return s
    return None


def has_ident(expr):
    for tok in re.findall(ID, expr or ""):
        if tok.lower() not in REGS and not re.match(r"\.[wlbs]$", tok.lower()):
            return True
    return False


# ---------------------------------------------------------------- expressions

class Unknown(Exception):
    pass


def evaluate(expr, lookup):
    """Evaluate a SNASM expression with lookup(name) -> int (raises Unknown)."""
    e = expr.strip()
    if not e:
        raise Unknown(expr)
    py = ""
    i = 0
    while i < len(e):
        ch = e[i]
        if ch == "$":
            m = re.match(r"\$([0-9A-Fa-f]+)", e[i:])
            py += str(int(m.group(1), 16))
            i += m.end()
        elif ch == "%":
            m = re.match(r"%([01]+)", e[i:])
            if not m:
                py += "%"
                i += 1
                continue
            py += str(int(m.group(1), 2))
            i += m.end()
        elif ch == "'":
            m = re.match(r"'([^']*)'", e[i:])
            if not m:
                raise Unknown(expr)
            v = 0
            for c in m.group(1):
                v = v * 256 + ord(c)
            py += str(v)
            i += m.end()
        elif ch.isdigit():
            m = re.match(r"\d+", e[i:])
            py += m.group(0)
            i += m.end()
        elif re.match(ID, e[i:]):
            m = re.match(ID, e[i:])
            py += "(" + str(lookup(m.group(0))) + ")"
            i += m.end()
        elif ch in "+-*/()&|^~<> \t!":
            if ch == "/":
                py += "//"
            elif ch == "!":
                py += "|"
            elif ch == "*" and (not py.strip() or py.strip()[-1] in "+-*/(&|^~<>"):
                raise Unknown(expr)            # * as the location counter
            else:
                py += ch
            i += 1
        else:
            raise Unknown(expr)
    try:
        return int(eval(py, {"__builtins__": {}}, {}))
    except Exception:
        raise Unknown(expr)


# ---------------------------------------------------------------- main work

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--lst", default=os.path.join(ROOT, "output", "obj", "nhl94 .lst"))
    ap.add_argument("--rom", default=None)
    ap.add_argument("--disc", default=os.path.join(ROOT, "cdbin", "HOCKEY.BIN"))
    ap.add_argument("--file", help="94G source file name (onetimer94.asm): its whole range")
    ap.add_argument("--cart-start", type=lambda s: int(s, 0))
    ap.add_argument("--cart-end", type=lambda s: int(s, 0))
    ap.add_argument("--disc-start", type=lambda s: int(s, 0), required=True)
    ap.add_argument("--disc-end", type=lambda s: int(s, 0), required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--inc", default=os.path.join(ROOT, "src", "segacd", "hockey", "hockey.inc"))
    ap.add_argument("--note", default=None, help="header note; a backslash-n in it starts a new line")
    ap.add_argument("--no-assemble", action="store_true")
    ap.add_argument("--register", action="store_true",
                    help="add the fragment to tools/segacd.json, tools/verifySegacd.js and the name map")
    ap.add_argument("--also", action="append", default=[], metavar="FILE",
                    help="another 94G file whose routines may have moved into this disc range")
    ap.add_argument("--base", type=lambda x: int(x, 0), default=0x1B000,
                    help="runtime address of file offset 0 ($1B000 HOCKEY.BIN, $21300 STARTER.BIN)")
    ap.add_argument("--plain", action="store_true", help="not a HOCKEY.BIN fragment: no hockey.inc / macros include")
    ap.add_argument("--raw", action="store_true", help="CD-only bytes as dc.b rows (a Z80 program, tables), not decoded")
    ap.add_argument("--raw-text", action="store_true", help="with --raw: printable runs of 4 or more as text")
    ap.add_argument("--text-incbin", action="store_true", help="text runs in decoded output are incbin from the disc (credits)")
    ap.add_argument("--tags", action="store_true",
                    help="Sierra C: each function ends with rts, a tag byte ($80 + length) and its name")
    ap.add_argument("--no-text", action="store_true",
                    help="team data: a quoted line that is not in the public src/teamdata94.asm (player names, "
                         "nicknames) and every CD block are incbin from the disc file, never text")
    ap.add_argument("--code", action="append", default=[], metavar="START-END",
                    help="CD-only runtime range that is code: no text runs are taken from it")
    ap.add_argument("--data", action="append", default=[], metavar="START-END",
                    help="CD-only runtime range that is data: dc.w rows, not decoded as instructions")
    ap.add_argument("--entry", action="append", default=[], metavar="NAME=ADDR",
                    help="a cartridge label whose callers enter at ADDR, before its first twin line (CD lines in front)")
    ap.add_argument("--label", action="append", default=[], metavar="NAME=ADDR",
                    help="a name for a CD-only routine at runtime address ADDR in the fragment")
    ap.add_argument("--cdname", action="append", default=[], metavar="NAME=ADDR",
                    help="a name for a CD-only disc address (no cartridge twin); CD lines use it, hockey.inc keeps it")
    ap.add_argument("--name", action="append", default=[], metavar="NAME=ADDR",
                    help="a disc address checked by hand (a RAM name or a routine outside the fragment)")
    a = ap.parse_args()
    global BASE
    BASE = a.base

    disc = open(a.disc, "rb").read()
    if a.plain and not a.file and not a.cart_end:
        # CD-only code (STARTER.BIN ...): no cartridge lines, so neither the ROM nor the listing is needed
        rom, lines = b"", []
    else:
        rom_path = a.rom
        if not rom_path:
            sys.path.insert(0, os.path.join(ROOT, "tools"))
            rom_path = find_rom()
        rom = open(rom_path, "rb").read()
        if not os.path.exists(a.lst):
            sys.exit(f"{a.lst}: no cartridge listing. Run npm run build:retail (the Sega CD build empties output/obj/),\n"
                     "or pass --lst with a saved copy.")
        lines = read_listing(a.lst)
    cart_glob, cart_kind, cart_local = symbols(lines)

    lo, hi = a.cart_start, a.cart_end
    nlo = nhi = None
    if a.file:
        lo, hi, nlo, nhi = file_range(lines, a.file)
    items, tail = build_items(lines, lo, hi, rom, cart_glob, nlo, nhi)
    scope0 = scope_at(lines, lo)
    for it in items:
        if it.scope is None:
            it.scope = scope0

    nmain = len(items)
    for extra in a.also:
        elo, ehi, enlo, enhi = file_range(lines, extra)
        more, _ = build_items(lines, elo, ehi, rom, cart_glob, enlo, enhi)
        sc = scope_at(lines, elo)
        for it in more:
            if it.scope is None:
                it.scope = sc
        items += more
    walk = align(items, disc, a.disc_start, a.disc_end, nmain)
    frag = Fragment(a, items, walk, disc, rom, cart_glob, cart_kind, cart_local, lines, lo, hi, tail)
    if a.tags:
        frag.tagspans, funcs = sierra_tags(disc)
        frag.known_funcs = funcs
        for start, name in funcs.items():
            if a.disc_start <= start - BASE < a.disc_end:
                a.label.append(f"{name}=0x{start:X}")
        # the first function of the fragment starts at the fragment start
        first = min((sp for sp in frag.tagspans if a.disc_start <= sp < a.disc_end), default=None)
        if first is not None and first > a.disc_start:       # its code is in this fragment, not only its tag
            n = frag.tagspans[first][1]
            if all(not l.startswith(n + "=") for l in a.label):
                # its start: the last link a6 before its rts in the fragment, else the fragment start
                st = a.disc_start
                for x in range(first - 2, a.disc_start - 1, -2):
                    if disc[x:x + 2] == b"NV":
                        st = x
                        break
                a.label.append(f"{n}=0x{BASE + st:X}")
    if a.no_text:
        global NO_TEXT
        NO_TEXT = True
        # the placeholder file is public: a line that reads the same there holds no licensed text
        frag.public = {re.sub(r"\s+", "", split_comment(l)[0]) for l in
                       open(os.path.join(ROOT, "src", "teamdata94.asm"), encoding="latin1")}
    # Constants defined in a 94G code file (not the RAM map / team data / macros): they stay that file's own.
    shared = set()
    for f in ("ram94.asm", "teamdata94.asm", os.path.join("macros", "genesis.mac")):
        p = os.path.join(ROOT, "src", f)
        if os.path.exists(p):
            for line in open(p, encoding="latin1"):
                m = re.match(r"\s*(" + ID + r")\s*(:?\s+(equ|set|rs(\.[bwl])?)\b|\s*=)", line, re.I)
                if m:
                    shared.add(m.group(1))
    frag.shared = shared
    frag.local_consts = {n for n, k in cart_kind.items() if k in ("equ", "rs") and n not in shared
                         and not is_ram(n, cart_glob, cart_kind)}
    for nv in a.name:
        n, v = nv.split("=")
        if n not in cart_glob:
            sys.exit(f"--name {nv}: {n} is not a cartridge name")
        frag.dsym[n] = int(v, 0)
    for nv in a.cdname:             # a name for a disc address with no cartridge twin (cdgfxptrs.asm entries)
        n, v = nv.split("=")
        frag.dsym[n] = int(v, 0)
        frag.cdnames.add(n)
    if not a.plain:
        frag.gnames = global_names(os.path.basename(a.disc), frag.start, frag.end)
        frag.gaddr = {n: v for v, n in frag.gnames.items()}
    text = frag.emit()
    os.makedirs(os.path.dirname(os.path.abspath(a.out)), exist_ok=True)
    open(a.out, "w", newline="\n").write(text)
    if not a.plain:
        frag.write_inc()             # hockey.inc is the HOCKEY.BIN RAM map; other discs files leave it alone
    matched = True
    if not a.no_assemble:
        matched = frag.fix_by_assembly(a.out)
    frag.report()
    licensed_check(a.out, required=not a.plain)
    if a.register and matched:
        register(a, frag)
    elif a.register:
        print("not registered: the fragment does not match the disc")


def global_names(disc, start, end):
    """The names the other fragments of this disc file define (docs/segacd-handoff/name_map.csv, written by
    --register), as {runtime: name}: only an address with one name, and a name at one address."""
    nm = os.path.join(ROOT, "docs", "segacd-handoff", "name_map.csv")
    if not os.path.exists(nm):
        return {}
    by_addr, by_name = {}, {}
    for row in open(nm, encoding="utf8").read().splitlines()[1:]:
        f = row.split(",")
        if len(f) < 3 or f[0] != disc or not f[1].startswith("$"):
            continue
        off = int(f[1][1:], 16)
        if start <= off < end:
            continue                    # this fragment's own rows: it is being written again
        by_addr.setdefault(off, set()).add(f[2])
        by_name.setdefault(f[2], set()).add(off)
    return {BASE + off: next(iter(ns)) for off, ns in by_addr.items()
            if len(ns) == 1 and len(by_name[next(iter(ns))]) == 1}


def licensed_check(path, required=True):
    """Stop if a player name or team nickname (licensed, never in the repo) is in the written file."""
    lists = {}
    for f in ("PlayerNames.txt", "TeamNicknames.txt"):
        p = os.path.join(ROOT, "Extracted", f)
        if not os.path.exists(p):
            if not required:
                return              # SDK code (STARTER.BIN ...): checked when the lists are there
            sys.exit(f"{p}: missing; it is needed to check that no licensed name is written (npm run build:retail)")
        lists[f] = [n.strip() for n in open(p, encoding="latin1") if len(n.strip()) >= 4]
    text = open(path, encoding="latin1").read()
    if re.search(r"^[^;\n]*\b(incbin|include)\s+\.\.\\Extracted", text, re.M | re.I):
        sys.exit(f"{path}: reads Extracted/ (cartridge assets); the Sega CD build must read cdbin/ only.")
    # a line that reads the same in the public placeholder file (String 'All Stars East') is not licensed
    public = {re.sub(r"\s+", "", split_comment(l)[0]) for l in
              open(os.path.join(ROOT, "src", "teamdata94.asm"), encoding="latin1")}
    text = "\n".join(l for l in text.split("\n")
                     if not ("'" in l and re.sub(r"\s+", "", split_comment(l)[0]) in public))
    quoted = " ".join(re.findall(r"'([^']*)'", text))
    hits = {n for n in lists["PlayerNames.txt"] if re.search(r"\b" + re.escape(n) + r"\b", text)}
    hits |= {n for n in lists["TeamNicknames.txt"] if re.search(r"\b" + re.escape(n) + r"\b", quoted)}
    if hits:
        sys.exit(f"{path}: contains {len(hits)} licensed name(s). Do not commit it; "
                 "those bytes must be read from cdbin/ (incbin).")



def sierra_tags(disc):
    """Sierra C name tags: {tag offset: (end of the zero pad, name)} and {function start (runtime): name}.
    A function's start is the end of the tag before it (functions follow each other)."""
    spans = {}
    for m in re.finditer(rb"\x4e\x75([\x81-\xbf])", disc):
        n = m.group(1)[0] - 0x80
        name = disc[m.start() + 3:m.start() + 3 + n]
        if not re.fullmatch(rb"[A-Za-z_][A-Za-z0-9_]*", name):
            continue
        e = m.start() + 3 + n
        while e < len(disc) and disc[e] == 0:
            e += 1
        if e & 1:
            e -= 1
        spans[m.start() + 2] = (e, name.decode())
    funcs = {}
    ends = {e: k for k, (e, _) in spans.items()}
    for k in sorted(spans):
        e, name = spans[k]
        # the function whose rts is at k-2 starts where the previous tag ended
        prev = [x for x in ends if x <= k - 2]
        if prev:
            start = max(prev)
            between = [t for t in spans if start <= t < k]
            if not between:
                # string literals of the function before may follow its tag: the function starts at
                # the first link a6 after them
                for x in range(start, min(start + 0x200, k - 2), 2):
                    if disc[x:x + 2] == b"NV":
                        start = x
                        break
                funcs[BASE + start] = name
    return spans, funcs


def find_rom():
    import hashlib
    want = "7b1489ab501258133bf03e5f0892b77d04312580"
    for n in os.listdir(ROOT):
        p = os.path.join(ROOT, n)
        if os.path.isfile(p) and n.lower().endswith((".bin", ".gen", ".md")) and os.path.getsize(p) == 0x100000:
            if hashlib.sha1(open(p, "rb").read()).hexdigest() == want:
                return p
    sys.exit("retail ROM not found in the repo folder (see tools/roms.js)")


def file_range(lines, name):
    inc = [(ln.addr, ln.n, split_comment(ln.src)[0].split()[-1]) for ln in lines
           if re.match(r"\s+include\s", split_comment(ln.src)[0]) and ln.src.strip().lower().startswith("include")]
    # top-level includes only: the ones listed in nhl94.asm order with increasing address
    for k, (addr, n, f) in enumerate(inc):
        if f.split("\\")[-1].lower() == name.lower():
            # the end is the next include whose address is higher
            for addr2, n2, f2 in inc[k + 1:]:
                if addr2 > addr and not f2.lower().endswith((".inc", ".mac")) and "Extracted" not in f2:
                    return addr, addr2, n, n2
    sys.exit(f"{name}: not found in the listing")


def scope_at(lines, lo):
    scope = None
    for ln in lines:
        if ln.addr > lo:
            break
        if ln.mac:
            continue
        code = split_comment(ln.src)[0]
        m = re.match(r"([A-Za-z_][\w@$]*)(:?)(\s+(.*))?$", code)
        if m and not code[:1].isspace():
            rest = (m.group(4) or "").lower()
            if not re.match(r"(equ|set|rs|=|macro|reg|equr)\b", rest) and not rest.startswith("="):
                scope = m.group(1)
    return scope


# ---------------------------------------------------------------- alignment

K = 3


def item_matches(it, disc, p, end):
    """Disc length when item it is at disc p, else None."""
    if it.kind == "insn":
        d = decode(disc, p, end, BASE)
        if d is not None and norm(d) == it.norm:
            return d.size
        if d is not None and TMOFS.search(it.ops) and loose(norm(d)) == loose(it.norm):
            return d.size               # only a team struct offset differs (the disc struct is longer)
        return None
    if it.kind in ("data", "macro"):
        if it.len and disc[p:p + it.len] == it.cart:
            return it.len
        if it.kind == "macro" and not it.len:
            return 0                    # nets no bytes (StringEnd back-patches the length word)
        return None
    if it.kind == "align":
        if it.mnem.lower() == "even":
            return (p + BASE) & 1
        return it.len if disc[p:p + it.len] == it.cart else None
    if it.kind == "dir":
        return 0
    return None


def soft_matches(it, disc, p, end):
    """Data that carries addresses: same length; each address element must point into HOCKEY.BIN
    or the game RAM, a label difference may shift a little, a constant element must be equal."""
    if not (it.kind == "data" and it.len and has_ident(it.ops) and p + it.len <= end):
        return None
    size = {"dc.b": 1, "dc.w": 2, "dc.l": 4, "dc": 2}.get(it.mnem.lower())
    ops = split_ops(it.ops)
    if size is None or size == 1 or len(ops) * size != it.len:
        return None
    for k, o in enumerate(ops):
        c = int.from_bytes(it.cart[k * size:(k + 1) * size], "big")
        d = int.from_bytes(disc[p + k * size:p + (k + 1) * size], "big")
        if not has_ident(o):
            if c != d:
                return None
        elif size == 4:
            if not (c == d or BASE <= d < BASE + len(disc) or 0x17000 <= d < BASE):
                return None
        elif abs(d - c) >= 0x800:
            return None
    return it.len


def run_ok(items, i, disc, p, end, k, used=(), soft=False):
    n = 0
    while n < k:
        if i in used:
            return False
        if i >= len(items):
            return n >= (1 if soft else min(k, 2))   # a jump to a file's last line alone (an rts) proves nothing
        it = items[i]
        ln = item_matches(it, disc, p, end)
        if ln is None and soft:
            ln = soft_matches(it, disc, p, end)     # a table of addresses: same length, other values
        if ln is None:
            return False
        if it.kind not in ("dir", "align") or ln:
            n += 1
        i += 1
        p += ln
    return True


def align(items, disc, start, end, nmain=None):
    """Walk the disc range in disc order. At each position continue the current run of cartridge
    lines, or jump to an unused cartridge line whose next lines match too (the disc may reorder or
    move routines), or take one instruction as CD-only code. items[nmain:] are other 94G files'
    lines (--also), used only by a jump."""
    from collections import defaultdict
    if nmain is None:
        nmain = len(items)
    idx = defaultdict(list)
    for j, it in enumerate(items):
        if it.kind == "insn":
            idx[("i", it.norm)].append(j)
        elif it.kind in ("data", "macro") and it.len >= 4:
            idx[("d", bytes(it.cart[:4]))].append(j)
        elif it.kind in ("data", "macro") and it.len >= 2:
            idx[("d2", bytes(it.cart[:2]))].append(j)     # dc.w tables (frames94)
    used = set()
    walk = []
    cd_from = None
    p, nxt = start, 0

    def flush_cd(q):
        nonlocal cd_from
        if cd_from is not None and q > cd_from:
            walk.append(("cd", cd_from, q))
        cd_from = None

    in_run = False
    while p < end:
        # 1. the next cartridge line, when it is here
        if in_run and nxt < len(items) and nxt not in used:
            it = items[nxt]
            ln = item_matches(it, disc, p, end)
            if ln is not None and p + ln <= end:
                flush_cd(p)
                walk.append(("m", it, p, ln))
                used.add(nxt)
                nxt += 1
                p += ln
                continue
            ln = soft_matches(it, disc, p, end)
            if ln is not None and run_ok(items, nxt + 1, disc, p + ln, end, 2, soft=True):
                flush_cd(p)
                walk.append(("s", it, p, ln))
                used.add(nxt)
                nxt += 1
                p += ln
                continue
        # 2. a jump: a cartridge line that starts a run of matches here
        d = decode(disc, p, end, BASE)
        cands = []
        if d is not None:
            cands += idx.get(("i", norm(d)), [])
        cands += idx.get(("d", bytes(disc[p:p + 4])), [])
        cands += idx.get(("d2", bytes(disc[p:p + 2])), [])
        best = None
        # prefer the run that follows on, then lines of this file, then the nearest after: try them in
        # that order and take the first that fits (a dc.w 0 or an rts has thousands of candidates)
        order = sorted(set(cands), key=lambda j: (0 if j == nxt else 1, 0 if j < nmain else 1,
                                                  0 if j > nxt else 1, abs(j - nxt)))
        for j in order:
            # a short skip forward needs K lines; any other jump (back, far, another file) needs more
            need = K if (j < nmain and (nxt <= j <= nxt + 40 or not in_run and walk == [])) else K + 2
            if j in used or not run_ok(items, j, disc, p, end, need, used):
                continue
            best = (None, j)
            break
        if best is not None:
            j = best[1]
            # zero-length lines just before it (labels, even) come along
            while j > 0 and items[j - 1].kind == "dir" and (j - 1) not in used and j - 1 >= (nmain if j >= nmain else 0):
                j -= 1
            flush_cd(p)
            nxt = j
            in_run = True
            continue
        # 3. CD-only code
        if cd_from is None:
            cd_from = p
        in_run = False
        p += d.size if d is not None else (1 if p & 1 else 2)      # step back onto even addresses
    flush_cd(min(p, end))
    walk = backfill(walk, items, disc, end, used)
    for j, it in enumerate(items[:nmain]):
        if j not in used:
            walk.append(("cut", it))
    return walk


def backfill(walk, items, disc, end, used):
    """A CD block followed by a run that starts at cartridge line j: the lines just before j may sit
    at the start of the block (the CD inserted code after them, e.g. right after a routine's
    movem). Take the longest such lead-in."""
    index = {id(it): j for j, it in enumerate(items)}
    out = []
    for k, w in enumerate(walk):
        if w[0] == "cd" and k + 1 < len(walk) and walk[k + 1][0] == "m":
            p, q = w[1], w[2]
            j = index[id(walk[k + 1][1])]
            got = None
            for m in range(min(8, j), 0, -1):
                if any((j - m + t) in used for t in range(m)):
                    continue
                pos, ents = p, []
                for t in range(m):          # a prefix of the lead-in: the CD may have replaced the rest
                    it = items[j - m + t]
                    ln = item_matches(it, disc, pos, q)
                    if ln is None or pos + ln > q:
                        break
                    ents.append(("m", it, pos, ln))
                    pos += ln
                while ents and ents[-1][1].kind == "dir":
                    pos -= ents.pop()[3]
                if any(e[1].kind in ("insn", "data", "macro") and e[3] for e in ents):   # byte-equal data counts too
                    got = (ents, pos)
                    break
            if got:
                ents, pos = got
                for e in ents:
                    used.add(index[id(e[1])])
                out += ents
                if pos < q:
                    out.append(("cd", pos, q))
                continue
        out.append(w)
    return out


# ---------------------------------------------------------------- emission

class Fragment:
    def __init__(self, a, items, walk, disc, rom, cglob, ckind, clocal, lines, lo, hi, tail):
        self.a, self.items, self.walk, self.disc, self.rom = a, items, walk, disc, rom
        self.cglob, self.ckind, self.clocal = cglob, ckind, clocal
        self.lo, self.hi, self.tail = lo, hi, tail
        self.start, self.end = a.disc_start, a.disc_end
        # the global labels this fragment's 94G file(s) define: the only ones it may place by evidence
        self.own_labels = ({it.label for it in items if it.label and not it.label.startswith(".")} |
                           {parse_src(l2.src)[0] for it in items for kind, l2 in it.pre if kind == "label"})
        self.dsym = {}          # name -> disc value (solved)
        self.labels = {}        # disc runtime address -> [(name, scope)]
        self.label_at = {}      # (scope, name) or name -> disc runtime address
        self.inc_assumed = set()
        self.inc_old = read_inc(a.inc, self.inc_assumed)
        self.confirmed = set()
        self.stats = {"aligned": 0, "soft": 0, "cd_bytes": 0, "cut": 0, "numeric": 0, "dcw": 0}
        self.externs = {}
        self.inc_new = {}
        self.globals_sorted = []
        self.starts = set()
        self.constraints = []
        self.force_numeric = set()
        self.evidence = set()
        self.restored = set()
        self.targets = set()
        self.cd_pcs = set()
        self.cdlabels = set()
        self.cdnames = set()
        self.listed = []            # (runtime, name, comment): names placed by place_team_list
        self.gnames = {}            # runtime -> a name another fragment of this disc file gives it (name_map.csv)
        self.gaddr = {}             # the same, name -> runtime
        self.moved = {}             # --entry: name -> (first twin line, entry)
        self.teamlist = []
        self.header = False
        self.tagspans = {}
        self.known_funcs = {}
        self.public = set()
        self.shared = set()
        self.local_consts = set()

    # -- labels from aligned items
    def place_labels(self):
        self.find_targets()
        self.starts = set()
        for w in self.walk:
            if w[0] in ("m", "s") and w[1].kind in ("insn", "data", "macro"):
                self.starts.add(BASE + w[2])
            elif w[0] == "cd":
                for u in self.cd_units(w[1], w[2]):
                    self.starts.add(BASE + u[1])
        for w in self.walk:
            if w[0] in ("m", "s"):
                it, p = w[1], w[2]
                rt = BASE + p
                for kind, ln in it.pre:
                    if kind == "label":
                        lab = parse_src(ln.src)[0]
                        self.add_label(lab, rt, it.scope)
                if it.label:
                    self.add_label(it.label, rt, it.scope)
        # --label: a name for a CD-only routine. Placed before restore_scopes, so a cartridge routine whose
        # first lines were cut is not named at a CD routine that happens to start with one of its lines.
        for nv in getattr(self.a, "label", []) or []:
            n, v = nv.split("=")
            rt = int(v, 0)
            if rt in self.starts and n not in self.label_at:
                self.add_label(n, rt, n)
                self.cdlabels.add((rt, n))
        self.restore_scopes()
        if NO_TEXT and self.start == 0:
            self.place_team_list()
        self.move_entries()

    def move_entries(self):
        """--entry NAME=ADDR: a cartridge routine the CD gave a few new lines in front of its first twin line.
        Its callers (in other fragments) enter at ADDR, so the name goes there, not on the first twin line."""
        for nv in getattr(self.a, "entry", []) or []:
            n, v = nv.split("=")
            v = int(v, 0)
            old = self.label_at.get(n)
            if old is None or old == v or v not in self.starts or not (BASE + self.start <= v < old):
                sys.exit(f"--entry {nv}: {n} is not a label after ${v:X} in this fragment")
            self.labels[old].remove(n)
            self.globals_sorted.remove((old, n))
            del self.label_at[n]
            self.restored.discard((old, n))
            self.add_label(n, v, n)
            self.moved[n] = (old, v)
            own = ""                    # the comment of the label's own line in the cartridge source
            for w in self.walk:
                if w[0] in ("m", "s"):
                    for kind, l2 in w[1].pre:
                        if kind == "label" and parse_src(l2.src)[0] == n:
                            own = split_comment(l2.src)[1].strip().lstrip(";").strip()
            note = f"CD: entered here; the cartridge {n} starts at its first twin line, ${old:X}"
            self.listed.append((v, n, f"{own} ({note})" if own else note))

    def place_team_list(self):
        """teamdata94 on the disc: the file header (jmp Begin, a word, null) and TeamList as source. The
        names come from the cartridge TeamList in order; a team whose record start has no twin gets its
        name (and .0, the record base) where its TeamList entry points."""
        names = []
        go = False
        for line in open(os.path.join(ROOT, "src", "teamdata94.asm"), encoding="latin1"):
            if re.match(r"TeamList\b", line):
                go = True
                continue
            if go:
                m = re.match(r"\s+dc\.l\s+(" + ID + r")", line)
                if m:
                    names.append(m.group(1))
                elif split_comment(line)[0].strip() or names:
                    break
        tl = self.dsym["TeamList"] - BASE
        self.teamlist = []
        for i, n in enumerate(names):
            v = int.from_bytes(self.disc[tl + 4 * i:tl + 4 * i + 4], "big")
            self.teamlist.append((n, v))
            old = self.label_at.get(n)
            if old == v:
                continue
            if old is not None:
                if (old, n) not in self.restored:
                    sys.exit(f"TeamList: {n} is at ${old:X} but the disc entry points at ${v:X}")
                self.restored.discard((old, n))       # its first surviving line: the record starts earlier
                self.labels[old].remove(n)
                self.globals_sorted.remove((old, n))
                del self.label_at[n]
            self.add_label(n, v, n)
            self.listed.append((v, n, f"team record {i}: TeamList points here; its first lines have no twin"))
            if (n, ".0") not in self.label_at:
                self.add_label(".0", v, n)
                self.listed.append((v, ".0", "record base"))
            self.starts.add(v)
        hdr = self.disc[0:6]
        begin = self.dsym.get("Begin")
        self.header = begin is not None and hdr[:2] == b"\x4e\xf9" and int.from_bytes(hdr[2:6], "big") == begin \
            and tl == 12 and self.disc[8:12] == b"\0\0\0\0"
        if self.header:
            for rt, n, why in ((BASE + 8, "null", "a zero long, the tile pointer when there is nothing to draw"),
                               (BASE + tl, "TeamList", "the team record pointers; team number = index")):
                if n not in self.label_at:
                    self.add_label(n, rt, n)
                    self.listed.append((rt, n, why))

    def restore_scopes(self):
        """A routine whose first lines were cut keeps its later lines: put its name at the first of
        them, so its local labels stay in its own scope (not in the routine before it)."""
        self.restored = set()
        for w in self.walk:
            if w[0] in ("m", "s"):
                sc = w[1].scope
                if sc and sc not in self.label_at and self.ckind.get(sc) == "label" and w[1].kind != "dir":
                    rt = BASE + w[2]
                    if not any(not lab.startswith(".") for lab in self.labels.get(rt, [])):
                        self.add_label(sc, rt, sc)
                        self.restored.add((rt, sc))

    def add_label(self, lab, rt, scope):
        key = (scope, lab) if lab.startswith(".") else lab
        self.label_at[key] = rt
        self.labels.setdefault(rt, []).append(lab)
        if not lab.startswith("."):
            self.globals_sorted = sorted(self.globals_sorted + [(rt, lab)])

    def lookup_disc(self, name, scope):
        """Disc value of a symbol, or raise Unknown."""
        if name.startswith("."):
            key = (scope, name)
            if key in self.label_at:
                return self.label_at[key]
            raise Unknown(name)
        if name in self.label_at:
            return self.label_at[name]
        if name in self.dsym:
            return self.dsym[name]
        if name in self.inc_old and name not in self.inc_assumed:
            return self.inc_old[name]
        k = self.ckind.get(name)
        if k in ("equ", "rs"):
            v = self.cglob[name]
            if is_ram(name, self.cglob, self.ckind):
                raise Unknown(name)            # RAM: the disc has its own map
            return v
        raise Unknown(name)

    def place_from_evidence(self, name, rt, scope):
        """A cartridge label whose line has no disc twin, put where the disc branch to it goes."""
        if not (BASE + self.start <= rt < BASE + self.end) or rt not in self.starts:
            return False
        if name.startswith("."):
            if self.scope_of(rt) != scope or (scope, name) in self.label_at:
                return False
        else:
            if name in self.label_at or self.ckind.get(name) != "label":
                return False
            if self.own_labels and name not in self.own_labels:
                return False                # another 94G file's label (a shared rts): never placed here
            # a global label must not split the local labels around it
            if any(self.scope_of(rt) == sc and lab_rt >= rt for (sc, lab), lab_rt in
                   [(k, v) for k, v in self.label_at.items() if isinstance(k, tuple)]):
                return False
        self.add_label(name, rt, scope)
        self.evidence.add((rt, name))
        return True

    def is_address(self, name):
        k = self.ckind.get(name)
        v = self.cglob.get(name)
        if name.startswith("."):
            return True
        if k == "label":
            return True
        return is_ram(name, self.cglob, self.ckind)

    def solve(self, expr, value, width, scope, mode=None):
        """Try to make expr equal value (mod width). Returns True and records new symbols."""
        mask = (1 << width) - 1
        u = expr.strip()
        old = self.label_at.get(u)
        if old is not None and any(r == (old, u) for r in self.restored) and value != old \
                and value in self.starts and value < old and self.scope_of(value) == self.scope_of(old - 1) \
                and BASE + self.start <= value:
            # a routine re-placed at its first surviving line, called at an earlier address: that is its start
            self.restored.discard((old, u))
            self.labels[old].remove(u)
            self.globals_sorted.remove((old, u))
            self.add_label(u, value, u)
            self.evidence.add((value, u))
        try:
            v = evaluate(expr, lambda n: self.lookup_disc(n, scope))
            if (v & mask) == (value & mask):
                single = expr.strip()
                if re.fullmatch(ID, single) and self.ckind.get(single) in ("equ", "rs") and not self.is_address(single) \
                        and single not in self.dsym:
                    self.confirmed.add(single)
                return True
            if mode != "disp":
                return False
            # a struct offset whose disc value differs (the disc team struct has an extra word)
            free = [t for t in re.findall(ID, expr) if t.lower() not in REGS and not t.startswith(".")
                    and self.ckind.get(t) in ("equ", "rs") and not self.is_address(t)
                    and t not in self.dsym and (t not in self.inc_old or t in self.inc_assumed)
                    and t not in self.confirmed]
            if len(free) != 1:
                return False
            u = free[0]
            v0 = evaluate(expr, lambda n: 0 if n == u else self.lookup_disc(n, scope))
            v1 = evaluate(expr, lambda n: 1 if n == u else self.lookup_disc(n, scope))
            if v1 - v0 != 1:
                return False
            sol = (value - v0) & mask
            if sol & 0x8000 and width == 16:
                sol -= 0x10000
            if sol < 0:
                return False
            self.dsym[u] = sol
            return True
        except Unknown:
            pass
        unknown = []
        for tok in re.findall(ID, expr):
            if tok.lower() in REGS:
                continue
            try:
                self.lookup_disc(tok, scope)
            except Unknown:
                if tok not in unknown:
                    unknown.append(tok)
        if len(unknown) != 1:
            return False
        u = unknown[0]
        if mode == "target" and expr.strip() == u:
            if self.place_from_evidence(u, value, scope):
                return True
            if u.startswith(".") or BASE + self.start <= value < BASE + self.end:
                return False
            # a routine outside the fragment: an equate (below)
        if u.startswith(".") or not self.is_address(u) and u in self.cglob:
            return False
        if u not in self.cglob:
            return False

        def at(x):
            return evaluate(expr, lambda n: x if n == u else self.lookup_disc(n, scope))
        try:
            v0, v1 = at(0), at(1)
        except Unknown:
            return False
        if v1 - v0 == 1:
            sol = (value - v0) & 0xFFFFFFFF
        elif v1 - v0 == -1:
            sol = (v0 - value) & 0xFFFFFFFF
        else:
            return False
        if width < 32:
            # a 16-bit absolute / displacement: only a RAM or code address makes sense
            if sol & 0x8000 and width == 16:
                sol |= 0xFFFF0000
            sol &= 0xFFFFFFFF
        if self.ckind.get(u) == "label" and not (BASE <= sol < BASE + len(self.disc)):
            return False                # a routine name must land in HOCKEY.BIN (not the BIOS at $6044)
        if self.ckind.get(u) == "label" and self.gaddr.get(u, sol) != sol:
            return False                # another fragment has this label elsewhere: the CD changed the call here
        self.dsym[u] = sol
        return True

    def sym_operand(self, cop, o, insn, scope, key=None):
        """Symbolic text for disc operand o using cartridge operand cop, or None."""
        expr = cart_expr(cop, o["mode"])
        if expr is None or not has_ident(expr) or key in self.force_numeric:
            return None
        base = insn.mnemonic.split(".")[0]
        sz = insn.mnemonic.split(".")[-1] if "." in insn.mnemonic else "w"
        mode, width = None, 32
        if o["mode"] == "imm":
            width = {"b": 8, "w": 16, "l": 32}.get(sz, 16)
            if base == "moveq":
                width = 8
            if base in ("btst", "bset", "bclr", "bchg") or (base in ("lsl", "lsr", "asl", "asr", "rol", "ror", "roxl", "roxr", "addq", "subq")):
                width = 8
            if base in ("adda", "suba") and width >= 16:
                mode = "disp"                   # a struct offset added to a pointer
            if re.fullmatch(r"tm\w+", expr.strip()) and width >= 16:
                mode = "disp"                   # a team struct offset (the disc struct is one word longer)
            text = "#" + expr
        elif o["mode"] == "abs":
            text = f"({expr}).{o['size']}"
        elif o["mode"] == "disp":
            mode, width = "disp", 16
            text = f"{expr}({o['reg']}{o['idx']})"
        elif o["mode"] == "pcrel":
            text = f"{expr}(pc{o['idx']})"
        elif o["mode"] == "target":
            mode = "target"
            text = expr
        else:
            return None
        if not self.solve(expr, o["value"], width, scope, mode):
            return None
        self.constraints.append((key, expr, o["value"], width, scope))
        return text

    def validate(self):
        """Every symbolic operand still equal to its disc value? Solve struct offsets that were
        assumed at their cartridge value; return the operand keys that cannot be made to fit."""
        changed = True
        while changed:
            changed = False
            for key, expr, value, width, scope in self.constraints:
                mask = (1 << width) - 1
                try:
                    if (evaluate(expr, lambda n: self.lookup_disc(n, scope)) & mask) == (value & mask):
                        continue
                except Unknown:
                    continue
                if self.solve(expr, value, width, scope, "disp"):
                    changed = True
        bad = set()
        for key, expr, value, width, scope in self.constraints:
            mask = (1 << width) - 1
            try:
                ok = (evaluate(expr, lambda n: self.lookup_disc(n, scope)) & mask) == (value & mask)
            except Unknown:
                ok = False
            if not ok:
                bad.add(key)
        return bad

    def resolvable(self, text, scope):
        """Every label a copied data line uses is defined in this fragment (or is a known name)."""
        for tok in re.findall(ID, re.sub(r"'(?:[^']|'')*'", "", text)):
            if tok.lower() in REGS:
                continue
            if tok.startswith("."):
                if (scope, tok) not in self.label_at:
                    return False
            elif self.ckind.get(tok) == "label" and tok not in self.label_at and tok not in self.dsym:
                return False
        return True

    def same_number(self, cop, o, insn):
        """The cartridge operand text, when it is a plain number equal to the disc operand."""
        expr = cart_expr(cop, o["mode"])
        if expr is None:
            return None
        try:
            v = evaluate(expr, lambda n: (_ for _ in ()).throw(Unknown(n)))
        except Unknown:
            return None
        base = insn.mnemonic.split(".")[0]
        sz = insn.mnemonic.split(".")[-1] if "." in insn.mnemonic else "w"
        width = 16 if o["mode"] == "disp" else {"b": 8, "w": 16, "l": 32}.get(sz, 16)
        if base == "moveq":
            width = 8
        mask = (1 << width) - 1
        if (v & mask) != (o["value"] & mask):
            return None
        c = cop.strip()
        if o["mode"] == "disp" and c.startswith("("):
            return "0" + c                  # the disc keeps the zero displacement
        return c

    def scope_of(self, rt):
        """The global label in force at runtime address rt in the emitted fragment."""
        best = None
        for pos, name in self.globals_sorted:
            if pos <= rt:
                best = name
            else:
                break
        return best

    def target_name(self, rt, scope):
        """Label text for a branch / pc target at runtime address rt."""
        for lab in self.labels.get(rt, []):
            if not lab.startswith("."):
                return lab
            if self.label_at.get((scope, lab)) == rt:
                return lab
        if rt in self.starts and self.scope_of(rt) == scope:
            self.auto.add(rt)
            return f".L{rt:X}"
        for n, v in self.dsym.items():          # a cartridge label, or (plain mode) another fragment's --cdname
            if v == rt and (self.ckind.get(n) == "label" or (self.a.plain and n in self.cdnames)):
                return n
        if rt in self.known_funcs and not (BASE + self.start <= rt < BASE + self.end):
            n = self.known_funcs[rt]
            self.externs[n] = rt
            return n
        if not self.a.plain:
            n = self.global_name(rt)            # a routine another fragment names
            if n:
                return n
        name = f"X_{rt:X}"
        self.externs[name] = rt
        return name

    def rev_name(self, v):
        """A unique name for address v (RAM map or a routine), for CD-only lines."""
        hits = set()
        for n, x in list(self.inc_old.items()) + list(self.dsym.items()):
            if x == v and (self.is_address(n) or n in self.cdnames):
                hits.add(n)
        for k, x in self.label_at.items():
            if x == v and isinstance(k, str):
                hits.add(k)
        return hits.pop() if len(hits) == 1 else None

    def global_name(self, v):
        """The name another fragment of this disc file gives address v, as an equate here (CD-only lines).
        Not a name this fragment defines or knows at another value, and never a cartridge constant."""
        n = self.gnames.get(v)
        if n is None or BASE + self.start <= v < BASE + self.end:
            return None
        if n in self.label_at or n in self.inc_old or self.dsym.get(n, v) != v or self.externs.get(n, v) != v:
            return None
        if n in self.cglob and self.ckind.get(n) != "label":
            return None
        self.externs[n] = v
        return n

    def insn_line(self, insn, it, scope):
        """(mnemonic, operand text, numeric_fallbacks)."""
        mn = insn.mnemonic
        base = mn.split(".")[0]
        if base in ("lea", "pea", "exg", "link"):
            mn = base
        if base in BRANCHES and mn.endswith(".b"):
            mn = base + ".s"
        if base in ("btst", "bset", "bclr", "bchg") and re.search(r",\s*d[0-7]$", insn.op_str):
            mn = base
        elif base in ("btst", "bset", "bclr", "bchg"):
            mn = base + ".b"                # a memory bit is always a byte (capstone may say .l)
        if base in DBCC:
            mn = "dbf" if base == "dbra" else base
        # keep the cartridge spelling when it is the same instruction
        if it is not None:
            cm = it.mnem
            if same_mnem(cm, mn):
                mn = cm
        dops = disc_operands(insn)
        cops = split_ops(it.ops) if it is not None else []
        texts, fallback = [], []
        for k, o in enumerate(dops):
            t = None
            if it is None and o["mode"] == "abs" and (o["value"] >= 0x10000 or
                                                      (self.a.plain and base in ("jsr", "jmp", "lea", "pea")) or
                                                      (self.a.plain and any(self.dsym.get(n) == o["value"]
                                                                            for n in self.cdnames))):
                n = self.rev_name(o["value"])
                if n:
                    t = f"({n}).{o['size']}"
            if t is None and it is None and not self.a.plain and o["mode"] == "abs" and o["value"] >= 0x10000:
                n = self.global_name(o["value"])      # a routine or table another fragment names
                if n:
                    t = f"({n}).{o['size']}"
            if t is None and it is None and self.a.plain and o["mode"] == "abs" and \
                    base in ("jsr", "jmp", "lea", "pea") and o["value"] in self.starts and \
                    BASE + self.start <= o["value"] < BASE + self.end:
                # an absolute call or address into this fragment: its label (plain mode, CD-only code)
                t = f"({self.target_name(o['value'], scope)}).{o['size']}"
            if it is None and o["mode"] == "imm" and o["value"] >= 0x10000 and \
                    insn.mnemonic in ("movea.l", "cmpa.l", "adda.l", "move.l") and k == 0:
                n = self.rev_name(o["value"])
                if n is None and not self.a.plain:
                    n = self.global_name(o["value"])
                if n:
                    t = "#" + n
            if it is not None and len(cops) == len(dops):
                t = self.sym_operand(cops[k], o, insn, scope, (it.ln.n, k))
                if t is None and has_ident(cart_expr(cops[k], o["mode"]) or ""):
                    fallback.append(cops[k])
                if t is None and o["mode"] == "reg" and len(cops) == len(dops):
                    if re.sub(r"\s", "", cops[k]).lower().replace("(a7)", "(sp)") == re.sub(r"\s", "", o["t"]).lower():
                        t = cops[k]
                if t is None and o["mode"] in ("imm", "disp") and not has_ident(cops[k]):
                    t = self.same_number(cops[k], o, insn)
                    if t is None:
                        fallback.append(cops[k])
                if t is None and o["mode"] == "abs" and not has_ident(cops[k]):
                    fallback.append(cops[k])
                if t is None and o["mode"] == "abs" and o["value"] >= 0x10000:
                    n = self.rev_name(o["value"])          # another name the disc address has
                    if n:
                        t = f"({n}).{o['size']}"
            if t is None:
                if o["mode"] in ("pcrel", "target"):
                    t = self.target_name(o["value"], scope)
                    if o["mode"] == "pcrel":
                        t += "(pc" + o["idx"] + ")"
                else:
                    t = snasm_text(o, insn)
            texts.append(t)
        return mn, ",".join(texts), fallback

    def emit(self):
        self.place_labels()
        for _ in range(6):
            text = self.emit_once()
            bad = self.validate() - self.force_numeric
            if not bad:
                return text
            self.force_numeric |= bad
        return text

    def emit_once(self):
        self.auto = set()
        self.externs = {}
        self.constraints = []
        for k in ("aligned", "soft", "cd_bytes", "cut", "numeric"):
            self.stats[k] = 0
        body = []
        for w in self.walk:
            if w[0] in ("m", "s"):
                it, p, ln = w[1], w[2], w[3]
                rt = BASE + p
                label = None if it.label in self.moved else it.label    # --entry: printed where callers enter
                for kind, l2 in it.pre:
                    if kind == "label" and parse_src(l2.src)[0] in self.moved:
                        continue
                    body.append(("text", l2.src.rstrip()))
                if w[0] == "m":
                    self.stats["aligned"] += 1
                else:
                    self.stats["soft"] += 1
                if it.kind == "insn":
                    insn = decode(self.disc, p, self.end, BASE)
                    mn, ops, fb = self.insn_line(insn, it, it.scope)
                    self.stats["numeric"] += len(fb)
                    code = split_comment(it.ln.src)[0]
                    gap = code[len(code.rstrip()):] or "\t"
                    com = it.comment
                    if fb:
                        note = "CD: the cartridge has " + ", ".join(fb)
                        com = (com + " (" + note + ")") if com else ";" + note
                    body.append(("insn", label, mn, ops, (gap + com) if com else "", p, insn.size))
                elif it.kind in ("data", "macro", "align", "dir"):
                    if w[0] == "s":
                        body.append(("data", label, self.reloc_data(it, p), p, ln))
                    elif it.mnem.lower() == "include":
                        pass
                    elif it.licensed:
                        body.append(("src", f"\tincbin\t..\\cdbin\\HOCKEY.BIN,${p:X},{ln}\t;licensed text: read from the disc file",
                                     p, ln))
                    elif NO_TEXT and "'" in split_comment(it.ln.src)[0] and \
                            re.sub(r"\s+", "", split_comment(it.ln.src)[0]) not in self.public:
                        # licensed text (a player row, a nickname): the bytes from the disc file, the
                        # line with its text masked as the comment (ratings and the P id stay)
                        code, com = split_comment(it.ln.src)
                        masked = re.sub(r"'(?:[^']|'')*'", "<text>", code.strip())
                        body.append(("src", f"{label or ''}\tincbin\t..\\cdbin\\HOCKEY.BIN,${p:X},{ln}\t;{masked}"
                                     + (" " + com.strip() if com else ""), p, ln))
                    elif it.mnem.lower() == "incbin" and "extracted" in it.ops.lower():
                        # a cartridge asset (extracted from the ROM there): the same bytes from the disc file
                        what = it.comment.lstrip(";").strip() or it.ops.split("\\")[-1]
                        body.append(("src", f"{label or ''}\tincbin\t..\\cdbin\\HOCKEY.BIN,${p:X},{ln}\t;{what} (from the disc file)",
                                     p, ln))
                    elif it.kind == "data" and ln and not self.resolvable(it.ops, it.scope):
                        # dc.w .pld-.0 of a record whose body has no twin: the disc bytes, the line as a comment
                        body.append(("src", f"{label or ''}\t{raw_dc(self.disc[p:p + ln])}\t;{split_comment(it.ln.src)[0].strip()}",
                                     p, ln))
                    else:
                        src = it.ln.src.rstrip()
                        if it.label in self.moved:
                            src = re.sub(r"^\S+", "", src, count=1)
                        body.append(("src", src, p, ln))
            elif w[0] == "cd":
                self.emit_cd(body, w[1], w[2])
            elif w[0] == "cut":
                it = w[1]
                if it.kind not in ("dir",):
                    self.stats["cut"] += 1
        self.body = body
        return self.render()

    def reloc_data(self, it, p):
        """dc.x with addresses: symbolize each element from the disc bytes."""
        mn = it.mnem.lower()
        size = {"dc.b": 1, "dc.w": 2, "dc.l": 4, "dc": 2}.get(mn)
        ops = split_ops(it.ops)
        if size is None or any(o.startswith(("'", '"')) for o in ops) or len(ops) * size != it.len:
            raw = self.disc[p:p + it.len]
            return "\t" + raw_dc(raw) + "\t\t;" + it.ops
        out = []
        for k, o in enumerate(ops):
            v = int.from_bytes(self.disc[p + k * size:p + (k + 1) * size], "big")
            key = (it.ln.n, k)
            mode = "disp" if re.fullmatch(r"tm\w+", o.strip()) and size >= 2 else None   # a team struct offset
            if has_ident(o) and key not in self.force_numeric and self.solve(o, v, size * 8, it.scope, mode):
                self.constraints.append((key, o, v, size * 8, it.scope))
                out.append(o)
            else:
                out.append(fmt_num(v))
                if has_ident(o):
                    self.stats["numeric"] += 1
        return f"\t{it.mnem}\t" + ",".join(out)

    def cd_units(self, p, q):
        """Split a CD block into instructions, text and raw words. Decoding starts again at every
        branch target inside the block, and a printable run of 6+ bytes is text."""
        out = []
        pc = p

        def ranges(opt):
            r = []
            for se in getattr(self.a, opt, []) or []:
                lo, hi = (int(x, 0) - BASE for x in se.split("-"))
                r.append((lo, hi))
            return r
        code_r, data_r = ranges("code"), ranges("data")
        while pc < q:
            dr = [hi for lo, hi in data_r if lo <= pc < hi]
            if dr and not pc & 1:               # a table: words, 8 to a row, split where something points
                e = min(dr[0], q, pc + 16)
                cut = [t - BASE for t in self.targets if pc < t - BASE < e]
                if cut:
                    e = min(cut)
                e = pc + ((e - pc) & ~1) if e - pc >= 2 else e
                out.append(("words", pc, e - pc))
                pc = e
                continue
            if pc in self.tagspans and self.tagspans[pc][0] <= q:
                e, name = self.tagspans[pc]
                out.append(("tag", pc, e - pc))
                pc = e
                continue
            k = pc
            while k < q and self.disc[k] == 0:
                k += 1
            cut = [t - BASE for t in self.targets if pc < t - BASE < k]
            if cut:
                k = min(cut)
            if k - pc >= 16:                    # a run of zeros: dcb.b, not a column of ori.b #0
                out.append(("zeros", pc, k - pc))
                pc = k
                continue
            k = pc
            while k < q and 0x20 <= self.disc[k] < 0x7F and self.disc[k] not in (0x27,):
                k += 1
            cut = [t - BASE for t in self.targets if pc < t - BASE < k]
            if cut:
                k = min(cut)                    # a string that is referenced starts there: split the run
            if k - pc >= 6 and not any(lo <= pc < hi for lo, hi in code_r):
                out.append(("text", pc, k - pc))
                pc = k
                continue
            d = decode(self.disc, pc, q, BASE)
            if d is not None:
                cut = [t - BASE for t in self.targets if pc < t - BASE < pc + d.size]
                if cut:
                    d = None
                    n = min(cut) - pc
                else:
                    out.append(("insn", pc, d))
                    pc += d.size
                    continue
            else:
                n = 2 if pc + 2 <= q and not pc & 1 else 1     # dc.w would be padded to even
            n = max(1, n)
            if n >= 2 and pc & 1:
                n = 1
            out.append(("raw", pc, min(n, 2) if not pc & 1 else 1))
            pc += out[-1][2]
        return out

    def find_targets(self):
        """Branch / pc-relative / absolute code targets inside the fragment (from every disc
        instruction the walk decodes), so CD blocks can be decoded in step with them."""
        self.targets = {int(nv.split("=")[1], 0) for nv in               # --label and --entry routines are entered
                        (getattr(self.a, "label", []) or []) + (getattr(self.a, "entry", []) or [])}
        lo, hi = BASE + self.start, BASE + self.end
        for _ in range(3):
            found = set(self.targets)
            for w in self.walk:
                if w[0] in ("m", "s") and w[1].kind == "insn":
                    insns = [decode(self.disc, w[2], self.end, BASE)]
                elif w[0] == "cd":
                    insns = [u[2] for u in self.cd_units(w[1], w[2]) if u[0] == "insn"]
                else:
                    continue
                for d in insns:
                    if d is None:
                        continue
                    base = d.mnemonic.split(".")[0]
                    if base in BRANCHES | DBCC or base in ("jsr", "jmp", "lea", "pea"):
                        for m in re.finditer(r"\$([0-9a-f]+)", d.op_str):
                            t = int(m.group(1), 16)
                            if lo <= t < hi and not t & 1:
                                found.add(t)
            if found == self.targets:
                break
            self.targets = found

    def emit_cd(self, body, p, q):
        if not self.a.plain:
            body.append(("text", ";CD: no cartridge twin"))
        self.stats["cd_bytes"] += q - p
        if self.a.raw:                  # not 68000 code (a Z80 program, tables): bytes, 16 to a line
            pc = p
            while pc < q:
                k = pc
                while k < q and self.disc[k] == 0:
                    k += 1
                if k - pc >= 16:
                    body.append(("data", None, f"\tdcb.b\t{k - pc},0", pc, k - pc))
                    pc = k
                    continue

                def printable_run(x):
                    y = x
                    while y < q and 0x20 <= self.disc[y] < 0x7F and self.disc[y] != 0x27:
                        y += 1
                    return y - x
                if self.a.raw_text and printable_run(pc) >= 4:
                    n = printable_run(pc)
                    body.append(("data", None, "\tdc.b\t'" + self.disc[pc:pc + n].decode("ascii") + "'", pc, n))
                    pc += n
                    continue
                n = min(16, q - pc)
                if self.a.raw_text:             # end the row where a string starts
                    for x in range(pc + 1, pc + n):
                        if printable_run(x) >= 4:
                            n = x - pc
                            break
                row = self.disc[pc:pc + n]
                body.append(("data", None, "\tdc.b\t" + ",".join(f"${b:02X}" for b in row), pc, n))
                pc += n
            return
        if NO_TEXT:                     # team data: may hold disc-only names, never decode it to text
            tl = 12
            if p == 0 and self.header and q >= tl + 4 * len(self.teamlist):
                if body and body[-1] == ("text", ";CD: no cartridge twin"):
                    body.pop()          # the header: the cartridge has null and TeamList too
                body.append(("src", "\tjmp\tBegin\t\t\t\t\t;the file header: the loader enters the game here", 0, 6))
                w = int.from_bytes(self.disc[6:8], "big")
                body.append(("src", f"\tdc.w\t${w:04X}\t\t\t\t\t;not known", 6, 2))
                body.append(("src", "\tdc.l\t0", 8, 4))
                for i, (n, v) in enumerate(self.teamlist):
                    body.append(("src", f"\tdc.l\t{n}\t\t\t\t\t;{i}", tl + 4 * i, 4))
                p = tl + 4 * len(self.teamlist)
                if p == q:
                    return
                body.append(("text", ";CD: no cartridge twin"))
            cuts = sorted({rt - BASE for rt, n, _ in self.listed if p < rt - BASE < q})
            for c in cuts + [q]:
                body.append(("src", f"\tincbin\t..\\cdbin\\HOCKEY.BIN,${p:X},{c - p}\t;read from the disc file", p, c - p))
                p = c
            return
        for u in self.cd_units(p, q):
            if u[0] == "zeros":
                body.append(("data", None, f"\tdcb.b\t{u[2]},0", u[1], u[2]))
            elif u[0] == "tag":
                pc, n = u[1], u[2]
                raw = self.disc[pc:pc + n]
                ln = raw[0] - 0x80
                name = raw[1:1 + ln].decode()
                pad = ",".join("0" for _ in raw[1 + ln:])
                body.append(("data", None, f"\tdc.b\t${raw[0]:02X},'{name}'" + ("," + pad if pad else ""), pc, n))
            elif u[0] == "text" and self.a.text_incbin:
                # text that may name real people (credits): read from the disc file, never written here
                pc, n = u[1], u[2]
                body.append(("src", f"\tincbin\t..\\cdbin\\{os.path.basename(self.a.disc)},${pc:X},{n}\t;text, read from the disc file",
                             pc, n))
            elif u[0] == "text":
                pc, n = u[1], u[2]
                body.append(("raw", self.disc[pc:pc + n], pc))
            elif u[0] == "raw":
                pc, n = u[1], u[2]
                body.append(("raw", self.disc[pc:pc + n], pc))
            elif u[0] == "words":
                pc, n = u[1], u[2]
                raw = self.disc[pc:pc + n]
                body.append(("data", None, "	dc.w	" + ",".join(f"${int.from_bytes(raw[i:i + 2], 'big'):04X}"
                                                                for i in range(0, n, 2)), pc, n))
            else:
                pc, d = u[1], u[2]
                mn, ops, _ = self.insn_line(d, None, self.scope_of(BASE + pc))
                body.append(("insn", None, mn, ops, "", pc, d.size))
                self.cd_pcs.add(pc)

    def render(self, markers=False):
        out = []
        src94 = self.a.file or os.path.basename(self.a.out)
        discname = os.path.basename(self.a.disc)
        if self.a.plain:
            out.append(f";\t{discname} ${self.start:X}-${self.end - 1:X} (runtime ${BASE + self.start:X}-${BASE + self.end - 1:X}).")
        else:
            out.append(f";\tHOCKEY.BIN ${self.start:X}-${self.end - 1:X} (runtime ${BASE + self.start:X}-${BASE + self.end - 1:X}):"
                       f" {src94} as the disc has it.")
            out.append(";\tThe cartridge source with long addresses and no short or quick forms. Lines under ;CD: have")
            out.append(";\tno cartridge twin. Names are the cartridge's; segacd\\hockey\\hockey.inc has the disc RAM map.")
        if self.a.note:
            out.append(";")
            for t in self.a.note.split("\\n"):
                out.append(f";\t{t}")
        out.append("")
        if not self.a.plain:
            out.append("\tinclude\tmacros\\genesis.mac")
            out.append("\tinclude\tsegacd\\hockey\\hockey.inc")
        out.append("")
        ext_at = len(out)
        out.append(f"\torg\t${BASE + self.start:X}")
        out.append("")
        auto = sorted(self.auto)
        placed = set()
        for k, e in enumerate(self.body):
            sp = self.span(e)
            if sp is not None and sp[1]:
                for rt, name in sorted(self.evidence):
                    if rt == BASE + sp[0] and (rt, name) not in placed:
                        out.append(name + "\t\t\t\t\t\t;CD: placed where the disc branches to it")
                        placed.add((rt, name))
                for rt, name in sorted(self.restored):
                    if rt == BASE + sp[0] and (rt, name) not in placed:
                        out.append(name + "\t\t\t\t\t\t;CD: its first lines have no twin; the rest of it starts here")
                        placed.add((rt, name))
                for rt, name, why in self.listed:
                    if rt == BASE + sp[0] and (rt, name) not in placed:
                        out.append(name + "\t\t\t\t\t\t;" + why)
                        placed.add((rt, name))
                for rt, name in sorted(self.cdlabels):
                    if rt == BASE + sp[0] and (rt, name) not in placed:
                        # a Sierra C name comes from its tag; any other is a name given here
                        what = "routine"
                        for se in getattr(self.a, "data", []) or []:
                            lo, hi = (int(x, 0) for x in se.split("-"))
                            if lo <= rt < hi:
                                what = "data"
                        out.append(name if self.a.tags else name + f"\t\t\t\t\t\t;CD-only {what} (a name given here, not a cartridge name)")
                        placed.add((rt, name))
            if markers and sp is not None:
                out.append(f".zzm{k}")
            if e[0] in ("text", "src"):
                if e[0] == "src" and BASE + e[2] in self.auto:
                    out.append(f".L{BASE + e[2]:X}")       # a string a lea / pea points at
                m = re.match(r"(" + ID + r")\s*(\s(equ|set)\b|=)", split_comment(e[1])[0], re.I)
                if m and (m.group(1) in self.inc_old or m.group(1) in self.shared) and not m.group(1).startswith("."):
                    out.append(";" + e[1] + "\t(defined in hockey.inc)")   # shared with other fragments
                else:
                    out.append(e[1])
            elif e[0] == "data":
                lab = e[1] or ""
                if BASE + e[3] in self.auto:
                    out.append(f".L{BASE + e[3]:X}")       # a buffer or table a lea points at
                out.append(lab + e[2])
            elif e[0] == "insn":
                _, lab, mn, ops, com, p, size = e
                rt = BASE + p
                if rt in self.auto:
                    out.append(f".L{rt:X}")
                line = f"{lab or ''}\t{mn}" + (f"\t{ops}" if ops else "")
                if com:
                    line += com if com[:1].isspace() else "\t" + com
                out.append(line)
            elif e[0] == "raw_insn":
                _, lab, raw, what, com, p = e
                if BASE + p in self.auto:
                    out.append(f".L{BASE + p:X}")
                if p in self.cd_pcs:
                    out.append(f"{lab or ''}\t{raw_dc(raw)}")       # CD-only bytes that are data, not code
                else:
                    out.append(f"{lab or ''}\t{raw_dc(raw)}\t\t;{what.strip()}: SNASM encodes it another way" + (" " + com.strip().lstrip(";") if com else ""))
            elif e[0] == "raw":
                raw, p = e[1], e[2]
                rt = BASE + p
                if rt in self.auto:
                    out.append(f".L{rt:X}")
                out.append(f"\t{raw_dc(raw)}")
        ext = []
        names = {}
        for n, v in self.dsym.items():
            if n in self.label_at or n in self.inc_old:
                continue
            if self.ckind.get(n) == "label" or (self.a.plain and n in self.cdnames):
                names[n] = v                # an equate at the top of this fragment, when it is used
            else:
                self.inc_new[n] = v
        used_text = "\n".join(out)
        for n, v in sorted(names.items(), key=lambda kv: kv[1]):
            if re.search(r"(?<![\w.@])" + re.escape(n) + r"(?![\w@])", used_text):
                ext.append(f"{n}\tequ\t${v:X}")
        for n, v in sorted(self.externs.items(), key=lambda kv: kv[1]):
            if names.get(n) == v and any(e.startswith(n + "\t") for e in ext):
                continue                    # already an equate (a name the cartridge lines use too)
            ext.append(f"{n}\tequ\t${v:X}")
        # constants of another 94G code file (collrad = 8 in collide94): an equate here, never in hockey.inc
        for n in sorted(set(self.used_constants(""))):
            if n in self.local_consts:
                try:
                    v = self.lookup_disc(n, None)
                except Unknown:
                    v = self.cglob[n]
                ext.append(f"{n}\tequ\t${v:X}")
        if ext:
            out[ext_at:ext_at] = ext + [""]
        # tail comments of the file
        return fix_layout("\n".join(out).rstrip() + "\n")

    def write_inc(self):
        merged = dict(self.inc_old)
        assumed = set(self.inc_assumed)
        used = self.used_constants("")          # also confirms constants seen in copied data
        for n, v in self.dsym.items():
            if n not in self.label_at and self.ckind.get(n) != "label":
                self.inc_new[n] = v
        for n in self.confirmed:
            if n not in self.inc_new:
                try:
                    self.inc_new[n] = self.lookup_disc(n, None)     # the value it was confirmed at
                except Unknown:
                    self.inc_new[n] = self.cglob[n]
        for n in self.local_consts:
            self.inc_new.pop(n, None)
        for n, v in self.inc_new.items():
            if n in merged and merged[n] != v and n not in assumed:
                print(f"warning: {n} is ${merged[n]:X} in the include, this fragment wants ${v:X}")
                continue
            merged[n] = v
            assumed.discard(n)
        # constants used by the fragment and not defined in it
        for n in used:
            if n not in merged and n not in self.local_consts:
                merged[n] = self.cglob[n]
                assumed.add(n)
        # shared names this fragment defines (NumTeams = ... in teamdata94): their line is a comment here,
        # the value lives in hockey.inc for every fragment
        for e in self.body:
            if e[0] in ("text", "src"):
                m = re.match(r"(" + ID + r")\s*(\s(equ|set)\b|=)", split_comment(e[1])[0], re.I)
                if m and m.group(1) in self.shared and m.group(1) in self.cglob and not m.group(1).startswith("."):
                    merged[m.group(1)] = self.cglob[m.group(1)]
                    assumed.discard(m.group(1))
        write_inc(self.a.inc, merged, self.cglob, self.ckind, assumed)

    def used_constants(self, text):
        out = []
        defined = set()
        for e in self.body:
            if e[0] in ("src", "text"):        # an equate line carried over before an item is "text"
                code = split_comment(e[1])[0]
                m = re.match(r"(" + ID + r")\s*(\s(equ|set|rs)\b|=)", code, re.I)
                if m:
                    defined.add(m.group(1))
        for e in self.body:
            if e[0] == "insn":
                s = e[3]
            elif e[0] == "data":
                s = split_comment(e[2])[0]
            elif e[0] == "src":
                s = split_comment(e[1])[0]
                s = s.split(None, 2)[-1] if s.split() else ""
                code = split_comment(e[1])[0]
                parts = code.strip().split(None, 1)
                s = parts[1] if len(parts) > 1 else ""
            else:
                continue
            for tok in re.findall(ID, s.replace("'", " ' ")) if "'" not in s else re.findall(ID, re.sub(r"'[^']*'", "", s)):
                if tok in defined or tok.startswith(".") or tok.lower() in REGS:
                    continue
                if tok in self.label_at or tok in self.externs or tok in self.dsym:
                    continue
                k = self.ckind.get(tok)
                if k in ("equ", "rs") and not is_ram(tok, self.cglob, self.ckind):
                    out.append(tok)
                    # a constant in a byte-equal copied data line (String CC_Font1,...) shows its value
                    if e[0] == "src" and e[3] and re.fullmatch(r"\s*(" + ID + r"\s+)?(string|dc\.[bwl]|dc)\b.*", split_comment(e[1])[0], re.I | re.S):
                        self.confirmed.add(tok)
        return out

    def span(self, e):
        """(disc offset, size) of a body entry, or None for text."""
        k = e[0]
        if k == "insn":
            return e[5], e[6]
        if k == "src":
            return e[2], e[3]
        if k == "data":
            return e[3], e[4]
        if k == "raw":
            return e[2], len(e[1])
        if k == "raw_insn":
            return e[5], len(e[2])
        return None

    def fix_by_assembly(self, path):
        """Assemble; an instruction SNASM sizes or encodes differently becomes its dc.w bytes."""
        want = self.disc[self.start:self.end]
        for attempt in range(400):
            chk = os.path.join(ROOT, "output", "port", "_chk.asm")
            os.makedirs(os.path.dirname(chk), exist_ok=True)
            open(chk, "w", newline="\n").write(self.render(markers=True))
            ok, binp, log = assemble(chk)
            if not ok:
                print(log)
                print(f"{path}: assembly failed (see above)")
                return
            built = open(binp, "rb").read()
            if built[:len(want)] == want and len(built) == len(want):
                ok2, binp2, log2 = assemble(path)
                b2 = open(binp2, "rb").read() if ok2 else b""
                print(("MATCH" if b2 == want else "MISMATCH (final build)") + f" {len(want)} bytes")
                return b2 == want
            lst = os.path.join(ROOT, "output", "port", "_chk .lst")
            got = {}
            for line in open(lst, encoding="latin1"):
                m = re.match(r"([0-9A-F]{8}) .{27}\.zzm(\d+)\s*$", line.rstrip())
                if m:
                    got[int(m.group(2))] = int(m.group(1), 16)
            culprit = None
            prev = None
            for k, e in enumerate(self.body):
                sp = self.span(e)
                if sp is None or sp[1] == 0:
                    continue
                if k in got and got[k] != BASE + sp[0]:
                    culprit = prev
                    break
                prev = k
            if culprit is None:
                for k, e in enumerate(self.body):
                    sp = self.span(e)
                    if sp is None or sp[1] == 0 or k not in got:
                        continue
                    o = got[k] - BASE - self.start
                    if built[o:o + sp[1]] != want[sp[0] - self.start:sp[0] - self.start + sp[1]]:
                        culprit = k
                        break
            if culprit is None or self.body[culprit][0] != "insn":
                where = self.span(self.body[culprit]) if culprit is not None else None
                print(f"MISMATCH: cannot fix by itself (entry {culprit} {self.body[culprit] if culprit is not None else ''})")
                open(path, "w", newline="\n").write(self.render())
                return
            e = self.body[culprit]
            raw = self.disc[e[5]:e[5] + e[6]]
            self.body[culprit] = ("raw_insn", e[1], raw, e[2] + "\t" + e[3], e[4], e[5])
            self.stats["dcw"] += 1
            open(path, "w", newline="\n").write(self.render())
        print("gave up after 400 fixes")

    def report(self):
        last = max((w[2] + w[3] for w in self.walk if w[0] in ("m", "s") and w[1].kind != "dir"), default=self.start)
        print(f"last aligned cartridge line ends at ${last:X}")
        s = self.stats
        print(f"{os.path.relpath(self.a.out, ROOT)}: ${self.start:X}-${self.end:X} ({self.end - self.start} bytes), "
              f"aligned {s['aligned']} (+{s['soft']} relocated data), CD-only {s['cd_bytes']} bytes, "
              f"cartridge lines dropped {s['cut']}, operands left numeric {s['numeric']}, dc.w lines {s['dcw']}")


def register(a, frag):
    """One line in tools/segacd.json and tools/verifySegacd.js, and the routines in the name map."""
    rel = os.path.relpath(os.path.abspath(a.out), os.path.join(ROOT, "src", "segacd")).replace("\\", "/")
    name = rel[:-4] if rel.endswith(".asm") else rel
    js = os.path.join(ROOT, "tools", "segacd.json")
    text = open(js, encoding="utf8").read()
    if f'"{name}"' not in text:
        opts = ", ".join(f'"{o}"' for o in OPTIONS)
        i = text.rindex("}")
        text = text[:i + 1] + f',\n  {{"name": "{name}", "options": [{opts}]}}' + "\n]\n"
        open(js, "w", encoding="utf8", newline="\n").write(text)
    vj = os.path.join(ROOT, "tools", "verifySegacd.js")
    text = open(vj, encoding="utf8").read()
    if f"output/segacd/{name}.bin" not in text:
        text = text.rstrip("\n") + "\n" + (f"compareAt('output/segacd/{name}.bin', 'cdbin/{os.path.basename(a.disc)}', "
                                           f"0x{frag.start:X}, 0x{frag.end - frag.start:X});") + "\n"
        open(vj, "w", encoding="utf8", newline="\n").write(text)
    nm = os.path.join(ROOT, "docs", "segacd-handoff", "name_map.csv")
    rows = open(nm, encoding="utf8").read().splitlines() if os.path.exists(nm) else ["disc_file,disc_addr,name_94g,notes"]
    src94 = a.file or ""
    note = src94 or ("Sierra C name tag" if a.tags else "CD-only")
    disc = os.path.basename(a.disc)

    def mine(r):                    # a row this fragment wrote before: replaced, so a renamed label leaves no stale row
        f = r.split(",")
        return f[0] == disc and frag.start <= int(f[1].lstrip("$"), 16) < frag.end and \
            (f[3] == note or f[3] == f"CD-only name in {src94}")
    rows = rows[:1] + [r for r in rows[1:] if not mine(r)]
    have = {tuple(r.split(",")[:3]) for r in rows[1:]}
    for rt, name94 in frag.globals_sorted:
        key = (disc, f"${rt - BASE:X}", name94)
        if key not in have:
            n = f"CD-only name in {src94}" if src94 and (rt, name94) in frag.cdlabels else note
            rows.append(",".join(key) + f",{n}")
    head, body = rows[0], rows[1:]
    body.sort(key=lambda r: (r.split(",")[0], int(r.split(",")[1].lstrip("$"), 16)))
    open(nm, "w", encoding="utf8", newline="\n").write("\n".join([head] + body) + "\n")
    print(f"registered {name}: tools/segacd.json, tools/verifySegacd.js, {len(frag.globals_sorted)} names in name_map.csv")


def same_mnem(cart, disc):
    c, d = cart.lower(), disc.lower()
    if c == d:
        return True
    cb, cs = (c.split(".") + [""])[:2]
    db, ds = (d.split(".") + [""])[:2]
    if cb != db:
        if {cb, db} <= {"dbf", "dbra"}:
            return True
        return False
    if cs == ds:
        return True
    if cb in BRANCHES:
        return {cs, ds} <= {"s", "b"}
    return False


def raw_dc(raw):
    if not NO_TEXT and len(raw) >= 6 and all(0x20 <= b < 0x7F and b != 0x27 for b in raw):
        return "dc.b\t'" + raw.decode("ascii") + "'"
    if len(raw) % 2 == 0:
        return "dc.w\t" + ",".join(f"${int.from_bytes(raw[i:i + 2], 'big'):04X}" for i in range(0, len(raw), 2))
    return "dc.b\t" + ",".join(f"${b:02X}" for b in raw)


ASSUMED = "not checked on the disc yet"


def read_inc(path, assumed=None):
    out = {}
    if os.path.exists(path):
        for line in open(path):
            m = re.match(r"(" + ID + r")\s+equ\s+(\$[0-9A-Fa-f]+|-\d+)", line)
            if m:
                g = m.group(2)
                out[m.group(1)] = int(g[1:], 16) if g.startswith("$") else int(g) & 0xFFFFFFFF
                if assumed is not None and ASSUMED in line:
                    assumed.add(m.group(1))
    return out


def write_inc(path, merged, cglob, ckind, assumed=()):
    ram = {n: v for n, v in merged.items() if is_ram(n, cglob, ckind)}
    const = {n: v for n, v in merged.items() if n not in ram}
    out = [";\tHOCKEY.BIN names: the sub CPU RAM map (where each cartridge variable lives on the disc) and the",
           ";\tcartridge constants the HOCKEY.BIN fragments use. tools/segacd_port.py adds to this file.",
           f";\tA constant marked \"{ASSUMED}\" has the cartridge value and was only used where its own",
           ";\tvalue does not show (a difference, a copied line); a disc operand may still change it.",
           "", "; RAM"]
    for n, v in sorted(ram.items(), key=lambda kv: (kv[1], kv[0])):
        out.append(f"{n}\tequ\t${v:X}")
    out += ["", "; constants"]
    for n, v in sorted(const.items(), key=lambda kv: kv[0].lower()):
        c = cglob.get(n)
        note = f"\t\t;the cartridge has ${c:X}" if c is not None and c != v else ""
        if n in assumed:
            note = f"\t\t;{ASSUMED}"
        val = f"{v - 0x100000000}" if v >= 0xFFFFFF00 else f"${v:X}"
        out.append(f"{n}\tequ\t{val}{note}")
    os.makedirs(os.path.dirname(path), exist_ok=True)
    open(path, "w", newline="\n").write(fix_layout("\n".join(out) + "\n"))


def assemble(path):
    exe = os.path.join(ROOT, "assembler", "Assembler.exe")
    rel = os.path.relpath(os.path.abspath(path), os.path.join(ROOT, "src")).replace("/", "\\")
    name = os.path.splitext(os.path.basename(path))[0]
    tmp = os.path.join(ROOT, "output", "port")
    os.makedirs(tmp, exist_ok=True)
    binp = os.path.join(tmp, name + ".bin")
    if os.path.exists(binp):
        os.remove(binp)
    args = ["/p", "/m", "/g"] + OPTIONS + [f"{rel},..\\output\\port\\{name}.bin,..\\output\\port\\{name},..\\output\\port\\{name}"]
    cmd = [exe] + args if os.name == "nt" else ["wine", exe] + args
    r = subprocess.run(cmd, cwd=os.path.join(ROOT, "src"), capture_output=True, text=True, encoding="latin1")
    log = r.stdout + r.stderr
    m = re.search(r"(\d+) error\(s\) from", log)
    ok = m is not None and int(m.group(1)) == 0 and os.path.exists(binp)
    return ok, binp, "\n".join(l for l in log.splitlines() if re.search(r"error|\.asm\(|\.inc\(", l, re.I))[:4000]


if __name__ == "__main__":
    main()
