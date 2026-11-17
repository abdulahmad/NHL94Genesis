#!/usr/bin/env python3
"""Put a comment above every undocumented dc run in the Sega CD sources (python3 tools/segcd_dccomment.py).

A run counts as documented when its first row has a global label, a comment line above, or a comment after two tabs.
The comment says what the bytes are, from what is around them: inline data read by the routine called just before,
the Sierra C name tag that follows a routine, text, a table of the routine above, or bytes inside a routine."""
import glob, os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
root = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'); os.chdir(root)
DC = re.compile(r'^(\S*)\t(?:dc|dcb)\.')
LAB = re.compile(r'^([A-Za-z_]\w*)(?=[\s:]|$)')
n = 0
for p in ['hockey', 'main', 'player', 'starter']:
    for f in sorted(glob.glob('src/segacd/%s/*.asm' % p)):
        if 'teamdata' in f: continue
        L = open(f, encoding='latin1').read().split('\n'); ins = []; i = 0
        while i < len(L):
            m = DC.match(L[i])
            if not m: i += 1; continue
            j = i + 1
            while j < len(L) and DC.match(L[j]) and not DC.match(L[j]).group(1): j += 1
            doc = bool(m.group(1) and not m.group(1).startswith('.')) or (i > 0 and L[i - 1].startswith(';')) or bool(re.search(r'\t\t;\s*\S', L[i]))
            if not doc:
                k = i - 1
                while k >= 0 and (not L[k].strip() or L[k].startswith(';')): k -= 1
                prev = L[k] if k >= 0 else ''
                pm = [x for x in prev.split(';')[0].split('\t') if x.strip()]
                if prev[:1] not in ' \t' and pm: pm = pm[1:]
                mn = pm[0].lower().split('.')[0] if pm else ''
                op = pm[1] if len(pm) > 1 else ''
                g = k
                while g >= 0 and not (LAB.match(L[g]) and not L[g].startswith('.') and not re.match(r'^\S+\s+equ\b', L[g])): g -= 1
                owner = LAB.match(L[g]).group(1) if g >= 0 else 'the file start'
                first = L[i]
                nrows = j - i
                tag = re.search(r"dc\.b\t\$([89A-F][0-9A-F]),'(\w+)'", first)
                text = re.search(r"dc\.b\t(?:\$[0-9A-F]{2},)*'[^']{4,}'", first) or first.lstrip().startswith("dc.b\t'")
                if tag and not tag.group(2).startswith(('$',)) and len(tag.group(2)) >= 3:
                    c = "; Sierra C name tag of the routine above (length byte, '%s', zero padding)." % tag.group(2)
                elif mn in ('jsr', 'bsr'):
                    tgt = re.sub(r'[()\.]l$|^\(|\)\.l$', '', op.split(',')[0])
                    c = '; Inline data read by %s from the return address (%d row%s).' % (tgt, nrows, 's' * (nrows > 1))
                elif text:
                    c = '; Text of %s (%d row%s).' % (owner, nrows, 's' * (nrows > 1))
                elif mn in ('rts', 'rte', 'bra', 'jmp', 'dc', 'dcb', 'incbin', ''):
                    c = '; Data of %s (%d row%s): table or constants used by it.' % (owner, nrows, 's' * (nrows > 1))
                else:
                    c = '; Instruction bytes inside %s that the assembler would encode differently, kept as words (%d row%s).' % (owner, nrows, 's' * (nrows > 1))
                ins.append((i, c))
            i = j
        for i, c in reversed(ins): L.insert(i, c)
        if ins: open(f, 'w', encoding='latin1').write('\n'.join(L)); n += len(ins)
print('comments added', n)
