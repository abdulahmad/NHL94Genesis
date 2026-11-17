#!/usr/bin/env python3
"""Rename placeholder labels of one disc program: segcd_rename.py main  (reads src/segacd/<dir>/names.json).
names.json: {"OldLabel": ["NewName", "one-line comment"], ...}. The comment goes above the label's line."""
import json, re, sys, glob
d = sys.argv[1]
names = json.load(open('src/segacd/%s/names.json' % d))
if any(k.startswith('@') for k in names):
    # '@FF0278' keys: the placeholder label at that runtime address in the last build listing
    sys.path.insert(0, 'tools')
    import segcd_labels
    byaddr = {}
    for nm, ad in segcd_labels.labels(d).items():
        byaddr.setdefault(ad, []).append(nm)
    res = {}
    for k, v in names.items():
        if k.startswith('@'):
            c = [x for x in byaddr.get(int(k[1:], 16), []) if re.fullmatch(r'\w+?(_\d+|Sub\d+)|L[0-9A-F]+', x)]
            if not c:
                print('no placeholder at', k); continue
            res[c[0]] = v
        else:
            res[k] = v
    names = res
files = [f for f in glob.glob('src/segacd/%s/*.asm' % d)] + ['src/segacd/%s.asm' % d]
texts = {f: open(f).read() for f in files}
alltext = '\n'.join(texts.values())
new = [v[0] for v in names.values()]
assert len(set(new)) == len(new), 'duplicate new names'
for n in new:
    assert not re.search(r'(?m)^%s\b' % re.escape(n), alltext), 'exists: ' + n
for old, (nn, cm) in names.items():
    pat = re.compile(r'(?<![\w.])%s(?![\w])' % re.escape(old))
    hit = False
    for f in files:
        t = texts[f]
        if not pat.search(t): continue
        hit = True
        lines = t.split('\n'); out = []
        for l in lines:
            if re.match(r'^%s(\s|:|;|$)' % re.escape(old), l):
                if cm: out.append('; ' + cm)
                l = re.sub(r';\s*%s\s*$' % re.escape(nn), '', l)
            out.append(pat.sub(nn, l))
        texts[f] = '\n'.join(out)
    if not hit: print('unused', old)
for f in files: open(f, 'w').write(texts[f])
done = {}
try: done = json.load(open('src/segacd/%s/names_applied.json' % d))
except OSError: pass
done.update(names)
json.dump(done, open('src/segacd/%s/names_applied.json' % d, 'w'), indent=1)
json.dump({}, open('src/segacd/%s/names.json' % d, 'w'))
