#!/usr/bin/env python3
"""segcd_assetnames.py: gives the disc asset files the name of the label they sit under (hockey_278A0.bin ->
PicturePalette.bin) in src/segacd/<dir>/assets.json and in the incbin lines. Re-runnable: already named files stay."""
import re, glob, os, json, sys
root = sys.argv[1] if len(sys.argv) > 1 else '.'
for d, B in (('hockey', 'HOCKEY'), ('main', 'MAIN'), ('player', 'PLAYER'), ('starter', 'STARTER')):
    jp = os.path.join(root, 'src/segacd', d, 'assets.json')
    if not os.path.exists(jp): continue
    meta = json.load(open(jp)); ren = {}; used = set(k for k in meta if not re.match(r'^%s_[0-9A-F]{5}\.bin$' % d, k))
    for f in sorted(glob.glob(os.path.join(root, 'src/segacd', d, '*.asm'))):
        L = open(f, encoding='latin-1').read().split('\n'); glob_lab = None; cnt = {}
        for i, l in enumerate(L):
            m = re.match(r'^([A-Za-z_]\w*)', l)
            if m and l[0] not in ' \t;': glob_lab = m.group(1)
            m = re.search(r'incbin\s+\.\.\\Extracted\\SegaCD\\%s\\(%s_[0-9A-F]{5}\.bin)' % (B, d), l)
            if not m: continue
            old = m.group(1)
            # a label on this line, or the nearest line above once comment lines are skipped, names the file;
            # a block with no label of its own keeps its offset name
            if re.match(r'^[A-Za-z_]\w*\s+incbin', l): name = glob_lab
            else:
                j = i - 1
                while j >= 0 and re.match(r'^\s+;', L[j]): j -= 1
                if j >= 0 and re.match(r'^[A-Za-z_]\w*', L[j]) and L[j][0] not in ' \t;' and not L[j].startswith('.'): name = re.match(r'^([A-Za-z_]\w*)', L[j]).group(1)
                else: continue
            if name + '.bin' in used: continue
            used.add(name + '.bin'); ren[old] = name + '.bin'
            L[i] = l.replace(old, name + '.bin')
        if ren and any(o in open(f, encoding='latin-1').read() for o in ren): open(f, 'w', encoding='latin-1').write('\n'.join(L))
    meta = {ren.get(k, k): v for k, v in meta.items()}
    json.dump(meta, open(jp, 'w'), indent=1)
    print(d, len(ren), 'renamed')
