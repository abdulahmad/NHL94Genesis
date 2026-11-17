#!/usr/bin/env python3
"""Regenerate every hk_*.asm fragment of HOCKEY.BIN and register them.

  node tools/build.js retail            # writes output/obj/nhl94 .lst
  python3 tools/hockey_regen.py         # pairs, symbols, fragments, segacd.json, verifySegacd.js

Needs the cartridge ROM (output/nhl94.bin) and cdbin/HOCKEY.BIN. Hand-written HOCKEY.BIN
fragments (everything in verifySegacd.js that is not hk_*) are left alone and skipped.
"""
import collections
import glob
import json
import os
import re
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor

LST = "/tmp/nhl94.lst"
DISC = "cdbin/HOCKEY.BIN"
PAIRS, SYMS = "/tmp/hk_pairs.csv", "/tmp/hk_syms.csv"


def run(cmd, out=None):
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode:
        sys.exit(r.stderr[-800:])
    if out:
        open(out, "w").write(r.stdout)
    return r.stdout


run(["python3", "tools/hockey_pair.py", "/tmp/nhl94.bin", DISC, LST], PAIRS)
run(["python3", "tools/hockey_syms.py", PAIRS, "/tmp/nhl94.bin", DISC, LST], SYMS)
size = os.path.getsize(DISC)
ver = open("tools/verifySegacd.js").read()
cov = sorted((int(a, 16), int(b, 16)) for n, a, b in re.findall(r"compareAt\('output/segacd/(\w+)\.bin', 'cdbin/HOCKEY.BIN', (0x[0-9A-F]+), (0x[0-9A-F]+)\)", ver) if not n.startswith("hk_"))
gaps, p = [], 0
for a, l in cov:
    if a > p:
        gaps.append((p, a))
    p = a + l
gaps.append((p, size))
starts = sorted(int(l.split(",")[1], 16) for l in open(PAIRS))
chunks = []
for a, b in gaps:
    cur = a
    while cur < b:
        end = min(b, cur + 0x1000)
        if end < b:
            c = [s for s in starts if cur + 0x800 <= s <= end]
            end = c[-1] if c else end
        chunks.append((cur, end))
        cur = end
lab = {}
for f in glob.glob("src/*.asm"):
    for l in open(f):
        m = re.match(r"^([A-Za-z_]\w*)\b", l)
        if m:
            lab.setdefault(m.group(1), f.split("/")[-1])
rows = [l.strip().split(",")[:5] for l in open(PAIRS)]
for f in glob.glob("src/segacd/hk_*.asm"):
    os.remove(f)
names, cnt = [], collections.Counter()
for a, b in chunks:
    c = collections.Counter(lab.get(r[2]) for r in rows if a <= int(r[1], 16) < b and r[2] in lab)
    twin = c.most_common(1)[0][0] if c else None
    if twin:
        cnt[twin] += 1
        names.append("hk_%s_%d" % (twin[:-4], cnt[twin]))
    else:
        names.append("hk_data_%X" % a)


def make(i):
    a, b = chunks[i]
    dst = "src/segacd/%s.asm" % names[i]
    run(["python3", "tools/hockey_auto.py", PAIRS, SYMS, DISC, "0x%X" % a, "0x%X" % b, dst])
    c = collections.Counter(lab.get(r[2]) for r in rows if a <= int(r[1], 16) < b and r[2] in lab)
    if c:
        subprocess.run(["python3", "tools/hockey_align.py", "src/" + c.most_common(1)[0][0], dst], capture_output=True)
    s = open(dst).read()
    for u in re.findall(r"^(\.l[0-9A-Fa-f]+)\tequ", s, re.M):
        s = re.sub(re.escape(u) + r"\b", "L" + u[2:].upper(), s)
    defd = {d.lower() for d in re.findall(r"^(\.l[0-9A-Fa-f]+)\b", s, re.M)}
    for u in set(re.findall(r"(\.l[0-9a-fA-F]{4,5})\b", s)):
        if u.lower() not in defd:
            s = re.sub(re.escape(u) + r"\b", "L" + u[2:].upper(), s)
    open(dst, "w").write(s)
    return names[i]


with ThreadPoolExecutor(1) as ex:
    for n in ex.map(make, range(len(chunks))):
        print("wrote", n, flush=True)

conf = [f for f in json.load(open("tools/segacd.json")) if not f["name"].startswith("hk_")]
opts = [f for f in conf if f["name"] == "scouting"][0]["options"]
conf += [{"name": n, "options": opts} for n in names]
open("tools/segacd.json", "w").write("[\n  " + ",\n  ".join(json.dumps(f) for f in conf) + "\n]\n")
ver = re.sub(r"compareAt\('output/segacd/hk_\w+\.bin'[^\n]*\n", "", ver)
i = ver.index("compareAt('output/segacd/scout94.bin'")
new = "".join("compareAt('output/segacd/%s.bin', 'cdbin/HOCKEY.BIN', 0x%X, 0x%X);\n" % (n, a, b - a) for n, (a, b) in zip(names, chunks))
open("tools/verifySegacd.js", "w").write(ver[:i] + new + ver[i:])
print(len(chunks), "fragments")
