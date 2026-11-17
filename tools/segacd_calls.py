#!/usr/bin/env python3
"""Write the routine equates each src/segacd fragment needs.

docs/segacd-handoff/name_map.csv holds the HOCKEY.BIN routines by runtime address.
A fragment that uses a name from it, and does not define that name as a label itself,
gets one equate line for it between ';calls begin' and ';calls end'.

  python3 tools/segacd_calls.py          (rewrites the fragments)
"""
import csv
import glob
import re

names = {}
for r in csv.DictReader(open("docs/segacd-handoff/name_map.csv")):
    if r["disc_file"] == "HOCKEY.BIN":
        names.setdefault(r["name_94g"], r["disc_addr"])

for path in sorted(glob.glob("src/segacd/*.asm")):
    t = open(path).read()
    if "hockey.inc" not in t:
        continue
    body = re.sub(r";calls begin.*?;calls end\n", "", t, flags=re.S)
    labels = set(re.findall(r"^([A-Za-z_]\w*)", body, flags=re.M))
    used = sorted(n for n in names
                  if re.search(r"(?<![\w.])" + re.escape(n) + r"(?!\w)", re.sub(r";.*", "", body)) and n not in labels)
    block = ";calls begin\n" + "".join("%s\tequ\t%s\n" % (n, names[n]) for n in used) + ";calls end\n"
    if ";calls begin" in t:
        new = re.sub(r";calls begin.*?;calls end\n", block, t, flags=re.S)
    else:
        new = re.sub(r"(\tinclude\tsegacd\\hockey\.inc\n)", r"\1\n" + block.replace("\\", "\\\\"), t, count=1)
    if new != t:
        open(path, "w").write(new)
        print("updated", path, len(used))
