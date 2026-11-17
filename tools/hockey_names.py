#!/usr/bin/env python3
"""Give the generated HOCKEY.BIN parts the cartridge's local labels and comments, and make the
rest of the branch labels local to their routine.

  python3 tools/hockey_names.py        # after tools/hockey_single.py, rewrites src/segacd/hockey/gen_*.asm

1. hockey_align.py runs once per cartridge file whose routines appear in the part: aligned
   instructions get the cartridge comment, and an L<offset> label on an aligned instruction takes
   the cartridge local label (.1, .loop ...).
2. A remaining global L<offset> label that is only used inside its own routine (between two
   global labels) becomes a local .l<offset> label.
"""
import collections
import glob
import re
import subprocess
import sys

lab = {}
for f in sorted(glob.glob("src/*.asm")):
    for l in open(f):
        m = re.match(r"^([A-Za-z_]\w*)\b", l)
        if m:
            lab.setdefault(m.group(1), f.split("/")[-1])
parts = sorted(glob.glob("src/segacd/hockey/gen_*.asm"))
for f in parts:
    text = open(f).read()
    names = re.findall(r"^([A-Za-z_]\w*)\b", text, re.M)
    c = collections.Counter(lab[n] for n in names if n in lab)
    for twin, k in c.most_common():
        subprocess.run(["python3", "tools/hockey_align.py", "src/" + twin, f], capture_output=True)
# make L labels local where every use is inside the routine
alltext = {f: open(f).read().split("\n") for f in parts}
flat = []
for f in parts:
    for i, l in enumerate(alltext[f]):
        flat.append((f, i, l))
glob_re = re.compile(r"^([A-Za-z_]\w*)\b")
routine_of = {}
cur = None
for f, i, l in flat:
    m = glob_re.match(l)
    if m and not re.match(r"^L[0-9A-F]{4,5}$", m.group(1)) and m.group(1) not in ("include", "org"):
        cur = m.group(1)
    routine_of[(f, i)] = cur
defs = {}
for f, i, l in flat:
    m = re.match(r"^(L[0-9A-F]{4,5})\b", l)
    if m:
        defs[m.group(1)] = routine_of[(f, i)]
uses = collections.defaultdict(set)
for f, i, l in flat:
    for m in re.finditer(r"\b(L[0-9A-F]{4,5})\b", l):
        uses[m.group(1)].add(routine_of[(f, i)])
loc = set()
for f in parts:
    out = []
    for l in alltext[f]:
        l = re.sub(r"\bL([0-9A-F]{4,5})\b", lambda m: (".l" + m.group(1)) if m.group(0) in loc else m.group(0), l)
        out.append(l)
    open(f, "w").write("\n".join(out))
# a local label whose use is not in the scope of its definition (a scope ends at any global label,
# including the L<offset> ones) goes back to a global label; repeat until nothing changes
moved = 0
for _ in range(20):
    txt = {f: open(f).read().split("\n") for f in parts}
    scope = 0
    ldef = {}
    luse = collections.defaultdict(list)
    for f in parts:
        for l in txt[f]:
            m = glob_re.match(l)
            if m and not l.startswith(".") and m.group(1) not in ("include", "org"):
                scope += 1
            md = re.match(r"^(\.[A-Za-z_]\w*)\b", l)
            if md:
                ldef[(scope, md.group(1).lower())] = True
            if not l.lstrip().startswith(";"):
                for mu in re.finditer(r"(?<![\w])(\.[A-Za-z_]\w*)\b", l):
                    luse[mu.group(1).lower()].append(scope)
    bad = {n for n, sc in luse.items() if any((x, n) not in ldef for x in sc)}
    bad = {n for n in bad if re.match(r"^\.l[0-9a-f]{4,5}$", n)}
    if not bad:
        break
    moved += len(bad)
    for f in parts:
        out = []
        for l in txt[f]:
            out.append(re.sub(r"(?<![\w])(\.l[0-9a-fA-F]{4,5})\b", lambda m: ("L" + m.group(1)[2:].upper()) if m.group(1).lower() in bad else m.group(1), l))
        open(f, "w").write("\n".join(out))
print("moved back to global:", moved)
