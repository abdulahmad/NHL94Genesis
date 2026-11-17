#!/usr/bin/env python3
"""Sierra C function-name tags. After each function's rts comes a tag (byte $80+len, the name, padding) and the
function's string literals. Name the function that starts after the previous tag/literal block, and its literals
<Name>Str<n>. Writes src/segacd/<dir>/names.json (old placeholder -> new) for segcd_rename.py.
  segcd_tags.py starter|main|player"""
import glob, json, re, sys
d = sys.argv[1]
top = open('src/segacd/%s.asm' % d).read()
order = re.findall(r'include\tsegacd\\\w+\\(\w+)\.asm', top)
lines = []
for m in order:
    if m == 'equates': continue
    for l in open('src/segacd/%s/%s.asm' % (d, m)).read().split('\n'):
        lines.append(l)
PH = re.compile(r'^(\w+?(_\d+|Sub\d+)|L[0-9A-F]+)$')
def label(l):
    m = re.match(r'^([A-Za-z_]\w*)(?:;[^\t]*)?(\t|$)', l)
    return m.group(1) if m else None
def body(l):
    return re.sub(r'^[^\t]*\t', '', l.split(';')[0] if False else l).strip() if '\t' in l else ''
def is_dcb(l):
    return re.match(r'^[^\t]*\tdc\.b\t', l) is not None
def tokens(l):
    t = re.sub(r'^[^\t]*\tdc\.b\t', '', l)
    t = re.sub(r'\t;.*$', '', t)
    out = []
    for m in re.finditer(r"'([^']*)'|\$([0-9A-Fa-f]{2})|(\d+)", t):
        if m.group(1) is not None: out += [ord(c) for c in m.group(1)]
        elif m.group(2): out.append(int(m.group(2), 16))
        else: out.append(int(m.group(3)))
    return out
def tag_name(i):
    """name from a tag line: byte $8x then ASCII (the text may continue on the next dc.b lines)"""
    b = tokens(lines[i])
    if not b or not (0x80 <= b[0] <= 0xBF): return None
    ln = b[0] & 0x7F
    j = i + 1
    while len(b) - 1 < ln and j < len(lines) and is_dcb(lines[j]):
        b += tokens(lines[j]); j += 1
    txt = bytes(b[1:1 + ln])
    if len(txt) < ln or not re.fullmatch(rb'[A-Za-z_]\w*', txt): return None
    return txt.decode()
names = {}
used = set(label(l) for l in lines if label(l))
start_label = None      # global label on the first instruction after the previous tag block
lits = []               # data labels after the previous tag
prev_tag = None
state = 'code'
for i, l in enumerate(lines):
    lab = label(l)
    if re.match(r'^[^\t]*\tdc\.b\t\$[89A-F][0-9A-F],\'', l) and tag_name(i):
        nm = tag_name(i)
        if start_label and PH.match(start_label) and start_label not in names:
            new = nm
            k = 2
            while new in used:
                new = '%s_%d' % (nm, k); k += 1
            used.add(new)
            names[start_label] = [new, 'C function %s (Sierra C name tag follows it).' % nm]
            prev_tag = new
        else:
            prev_tag = nm
            used.add(nm)
        state = 'lits'; start_label = None; lit_n = 0
        continue
    if state == 'lits':
        if is_dcb(l) or not l.strip() or l.lstrip().startswith(';') or re.match(r'^[^\t]*\tdcb\.b\t', l):
            if lab and PH.match(lab) and prev_tag and is_dcb(l):
                lit_n += 1
                names[lab] = ['%sStr%d' % (prev_tag, lit_n), '']
            continue
        state = 'code'
    if state == 'code' and start_label is None:
        # first instruction line of the next function
        if lab and not lab.startswith('.') and re.match(r'^[^\t]*\t(?!dc\.b|dcb)', l):
            start_label = lab
        elif re.match(r'^\t(?!dc\.b|dcb)\S', l) and not l.lstrip().startswith(';'):
            start_label = '?'
# labels written as `Placeholder; RealName` (the name tag, noted by an earlier pass): take the name
for l in lines:
    m = re.match(r'^(\w+); (\w+)\s*$', l)
    if m and PH.match(m.group(1)) and m.group(1) not in names:
        nm, k = m.group(2), 2
        new = nm
        while new in used:
            new = '%s_%d' % (nm, k); k += 1
        used.add(new)
        names[m.group(1)] = [new, 'C function %s (Sierra C name tag follows it).' % nm]
json.dump({k: v for k, v in names.items() if not k.startswith('?')}, open('src/segacd/%s/names.json' % d, 'w'), indent=1)
print(len(names), 'names')
