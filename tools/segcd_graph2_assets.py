#!/usr/bin/env python3
"""Writes src/segacd/graph2/assets.json: the pieces of GRAPH2.BIN that are byte for byte cartridge assets (named after the
cartridge asset, from tools/extractAssets94.js and the cartridge ROM), plus the offset directory and the script text.
Usage: python3 tools/segcd_graph2_assets.py cdbin/GRAPH2.BIN nhl94retail.bin"""
import json, re, struct, sys, os
g = open(sys.argv[1], 'rb').read()
rom = open(sys.argv[2], 'rb').read()
root = os.path.join(os.path.dirname(__file__), '..')
js = open(os.path.join(root, 'tools', 'extractAssets94.js'), encoding='latin1').read()
pat = re.compile(r"^\s*\{\s*name:\s*'([^']+)',\s*folder:\s*'([^']+)',\s*start:\s*(0x[0-9A-Fa-f]+|\d+),\s*end:\s*(0x[0-9A-Fa-f]+|\d+)", re.M)
first = struct.unpack('>I', g[:4])[0]
out = {'Graph2Directory.bin': {'start': 0, 'size': first}}
offs = [struct.unpack('>I', g[i:i + 4])[0] for i in range(0, first, 4)]
out['ScoutingReportText.bin'] = {'start': offs[0], 'size': offs[1] - offs[0]}   # chunk 0: the typed script (docs/segacd_announce.md)
seen = {}
for m in pat.finditer(js):
    name, a, b = m.group(1), int(m.group(3), 0), int(m.group(4), 0)
    if b - a < 64 or name.startswith(('z80_', 'fm_', 'fmtune_', 'ScoutingReportText')):
        continue
    blob = rom[a:b]
    if len(set(blob)) <= 1:
        continue
    p = g.find(blob)
    if p >= 0 and p not in seen:
        seen[p] = (name, b - a)
for p in sorted(seen):
    out[seen[p][0]] = {'start': p, 'size': seen[p][1]}
d = os.path.join(root, 'src', 'segacd', 'graph2')
os.makedirs(d, exist_ok=True)
json.dump(out, open(os.path.join(d, 'assets.json'), 'w'), indent=1)
print(len(out), 'assets,', sum(v['size'] for v in out.values()), 'bytes of', len(g))
