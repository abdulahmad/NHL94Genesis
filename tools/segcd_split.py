#!/usr/bin/env python3
"""Cut an address-named MAIN / PLAYER / STARTER source into function-named files.

  python3 tools/segcd_split.py src/segacd/<prog>/layout.json

layout.json: {"prog": "main", "files": {"main_03C3E": [["mainsubcmd", null], ["mainctrl", "ClearVram"], ...]}}
Each entry is [new file name, first global label or null for the start of the file].  The text is cut at that label
(with the comment lines above it), the old file is removed, and the include line in src/segacd/<prog>.asm is replaced
by the new files in order.  Cutting at a global label keeps local label scopes, so the bytes do not change."""
import json, os, re, sys
root = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'); os.chdir(root)
plan = json.load(open(sys.argv[1])); prog = plan['prog']
top = open('src/segacd/%s.asm' % prog, encoding='latin1').read().split('\n')
for old, cuts in plan['files'].items():
    p = 'src/segacd/%s/%s.asm' % (prog, old)
    L = open(p, encoding='latin1').read().split('\n')
    starts = []
    for nm, lab in cuts:
        if lab is None: starts.append(0); continue
        i = next(k for k, t in enumerate(L) if re.match(r'^%s(?=[\s:]|$)' % re.escape(lab), t))
        while i > 0 and L[i - 1].startswith(';'): i -= 1
        starts.append(i)
    assert starts == sorted(starts), old
    inc = '\tinclude\tsegacd\\%s\\%s.asm' % (prog, old)
    k = top.index(inc)
    new = []
    for j, (nm, lab) in enumerate(cuts):
        e = starts[j + 1] if j + 1 < len(cuts) else len(L)
        open('src/segacd/%s/%s.asm' % (prog, nm), 'w', encoding='latin1').write('\n'.join(L[starts[j]:e]))
        new.append('\tinclude\tsegacd\\%s\\%s.asm' % (prog, nm))
    top[k:k + 1] = new
    os.remove(p)
open('src/segacd/%s.asm' % prog, 'w', encoding='latin1').write('\n'.join(top))
