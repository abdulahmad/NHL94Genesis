#!/usr/bin/env python3
"""Replace a HOCKEY.BIN data asset (an incbin) with the cartridge's own source lines, where the bytes agree.

  python3 tools/hockey_cartdata.py <asset key, e.g. hockey_2665C.bin> <cartridge ROM address of its first byte>

Needs the cartridge build listing (node tools/build.js, then copy "output/obj/nhl94 .lst" to $CART_LST or
/tmp/w/nhl94.lst before the segacd build empties output/obj) and a hockey build.  The asset bytes are aligned with
the cartridge ROM; every cartridge source line (dc.w, String, PIX ...) whose bytes all match the disc is written as
that line, with its label and comment lines; the bytes that differ stay dc.b rows.  Lines that do not assemble here
(a symbol the disc build does not have) fall back to dc.b.  Labels the new text defines replace the equates of the
same name in hockey.inc, and `#$addr` immediates in the code that point at a new label become `#Label`."""
import difflib, glob, json, os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import segcd_one as S

root = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')
os.chdir(root)
LST = os.environ.get('CART_LST', '/tmp/w/nhl94.lst')
d = open('cdbin/HOCKEY.BIN', 'rb').read()
rom = open('output/nhl94.bin', 'rb').read()
apath = 'src/segacd/hockey/assets.json'


def cart_lines():
    """[(addr, text, macro_expansion)] for every listing row that carries a source line."""
    out = []
    for l in open(LST, errors='replace').read().replace('\r', '').split('\n'):
        m = re.match(r'^([0-9A-F]{8}) ', l)
        if not m or len(l) < 36:
            continue
        equ = l[9:10] == '='
        out.append((int(m.group(1), 16), l[36:].rstrip(), l[34:35] == 'M', equ))
    return out


def spans(lines):
    """For each non-macro, non-equate row: (addr, end, text). end is the address of the next such row."""
    rows = [(a, t) for a, t, mac, equ in lines if not mac and not equ and not t.strip().startswith(('org\t@', '@end', '@begin'))]
    res = []
    for i, (a, t) in enumerate(rows):
        e = rows[i + 1][0] if i + 1 < len(rows) else a
        res.append((a, e, t))
    return res


def rows_dcb(b, start_label=None):
    out = []
    for i in range(0, len(b), 16):
        out.append('\tdc.b\t' + ','.join('$%02X' % x for x in b[i:i + 16]))
    return out


def build_text(s, n, r, bad):
    a = d[s:s + n]
    sm = difflib.SequenceMatcher(None, a, rom[r:r + n + 64], autojunk=False)
    blocks = [b for b in sm.get_matching_blocks() if b.size >= 2]
    dmap = {}          # rom offset (relative to r) -> disc offset, for matched bytes
    for b in blocks:
        for k in range(b.size):
            dmap[b.b + k] = b.a + k
    import bisect
    bstarts = [b.b for b in blocks]
    def dpos(o):
        if o in dmap: return dmap[o]
        k = bisect.bisect_right(bstarts, o) - 1
        if k < 0: return None
        x = blocks[k]; v = o + (x.a - x.b)
        return v if 0 <= v <= n else None
    rl = spans(cart_lines())
    # rows whose bytes all match, keyed by disc offset
    start = {}
    lab_at = {}
    pend = []          # zero-width rows (labels, comments) waiting for the next data row
    pending = {}
    cur = []
    for (ad, e, t) in rl:
        o = ad - r
        if e == ad:
            if re.match(r'^\s*(include|IF|ENDIF|inform|ELSE)\b', t, re.I):
                continue
            if 0 <= o < n + 64:
                cur.append(t)
            else:
                cur = []
            continue
        if 'incbin' in t:      # a cartridge graphic file: the disc bytes are written as dc.w under the same label and comment
            if 0 <= o < n + 64 and dpos(o) is not None and dpos(o) + (e - ad) <= n:
                if e - ad >= 64:
                    lm = re.match(r'^([A-Za-z_]\w*)', t)
                    cm = t.partition(';')[2].strip()
                    pre = cur + ([lm.group(1) + ('\t\t\t\t\t\t;' + cm if cm else '')] if lm else (['\t\t\t\t\t\t\t\t;' + cm] if cm else []))
                    start[dpos(o)] = (e - ad, pre, 'asset')
                else:
                    start[dpos(o)] = (e - ad, cur + [re.sub(r'incbin\s+\S+', 'dcw', t)], 'dcw')
            cur = []
            continue
        if cur and 0 <= o < n + 64 and dpos(o) is not None:
            lab_at.setdefault(dpos(o), list(cur))
        ok = 0 <= o and all((o + k) in dmap and dmap[o + k] == dmap[o] + k for k in range(e - ad))
        if ok and dmap[o] + (e - ad) <= n:
            start[dmap[o]] = (e - ad, cur + [t], 'src')
        cur = []
    items = []         # (kind, disc offset, length, lines)
    o = 0
    lab_rows = []
    while o < n:
        if o in start and (o not in bad):
            ln, lines, kd = start[o]
            if kd in ('dcw', 'asset'):
                items.append((kd, o, ln, lines)); o += ln
            else:
                items.append(('src', o, ln, lines)); o += ln
        else:
            p = o + 1
            while p < n and not (p in start and p not in bad) and (p - o) < 16 and p not in lab_at:
                p += 1
            items.append(('dcb', o, p - o, lab_at.get(o))); o = p
    # long runs of unmatched bytes (graphics) go back to an extracted asset
    merged = []; run = []
    def flush():
        if run:
            tot = sum(x[2] for x in run)
            if tot >= 512:
                merged.append(('asset', run[0][1], tot, run[0][3]))
            else:
                merged.extend(run)
        run.clear()
    for it in items:
        if it[0] == 'dcb' and not (run and it[3]):
            run.append(it)
        else:
            flush()
            if it[0] == 'dcb': run.append(it)
            else: merged.append(it)
    flush()
    items = merged
    return items


def render(items, s):
    L = []; pos = []
    for kind, o, ln, lines in items:
        pos.append((len(L), o, ln, kind, (len(lines) if kind == 'src' else 0)))
        if kind == 'src':
            L.extend(lines)
        elif kind == 'dcw':
            L.extend(lines[:-1])
            head, _, cmt = lines[-1].partition('dcw')
            cmt = cmt.partition(';')[2]
            for k in range(0, ln, 8):
                w = ','.join('$%04X' % int.from_bytes(d[s + o + k + m:s + o + k + m + 2], 'big') for m in range(0, min(8, ln - k), 2))
                L.append((head if k == 0 else '') + '\tdc.w\t' + w + (('\t\t;' + cmt) if k == 0 and cmt else ''))
        elif kind == 'asset':
            L.extend(lines or [])
            L.append('\tincbin\t..\\Extracted\\SegaCD\\HOCKEY\\hockey_%05X.bin' % (s + o))
        else:
            L.extend(lines or [])
            L.extend(rows_dcb(d[s + o:s + o + ln]))
    return L, pos


def main():
    key, cart = sys.argv[1], int(sys.argv[2], 16)
    assets = json.load(open(apath))
    s, n = assets[key]['start'], assets[key]['size']
    gens = [f for f in glob.glob('src/segacd/hockey/*.asm') if key in open(f, encoding='latin1').read()]
    assert len(gens) == 1, gens
    f = gens[0]
    orig = open(f, encoding='latin1').read()
    inc = open('src/segacd/hockey.inc', encoding='latin1').read()
    base = os.path.basename(f)[:-4].lower()
    bad = set()
    cfg = dict(disc='cdbin/HOCKEY.BIN', base=0x1B000, name='hockey', oaq='-')
    for rnd in range(40):
        items = build_text(s, n, cart, bad)
        L, pos = render(items, s)
        # labels the new text defines
        labs = {m.group(1) for t in L for m in [re.match(r'^([A-Za-z_]\w*)', t)] if m and not t.startswith((' ', '\t'))}
        txt = orig.split('\n')
        i = [k for k, l in enumerate(txt) if key in l][0]
        j = i
        while j > 0 and (txt[j - 1].lstrip().startswith(';') or txt[j - 1].split()[:1] and txt[j - 1].split()[0] in labs and not txt[j - 1].startswith(('\t', ' '))):
            j -= 1
        new = txt[:j] + L + txt[i + 1:]
        # equates replaced by labels
        inc2 = '\n'.join(l for l in inc.split('\n') if not (re.match(r'^(\w+)\s+equ\s', l) and l.split()[0] in labs))
        open(f, 'w', encoding='latin1').write('\n'.join(new))
        open('src/segacd/hockey.inc', 'w', encoding='latin1').write(inc2)
        a3 = json.loads(json.dumps(assets)); a3.pop(key)
        for it in items:
            if it[0] == 'asset': a3['hockey_%05X.bin' % (s + it[1])] = {'start': s + it[1], 'size': it[2]}
        json.dump(dict(sorted(a3.items(), key=lambda kv: kv[1]['start'])), open(apath, 'w'), indent=1)
        os.system('node tools/extractAssetsSegaCD.js >/dev/null')
        if os.path.exists('/tmp/new/hockey.bin'): os.remove('/tmp/new/hockey.bin')
        errs, atxt = S.assemble(cfg)
        allerrs = [e for e in errs if 'odd address' not in e[2]]
        errs = [e for e in errs if e[0] == base]
        if not errs and not allerrs:
            break
        fixed = 0
        for (_, ln, msg) in errs:
            idx = ln - 1 - j
            for (start_ix, o, length, kind, nl) in pos:
                if kind == 'src' and start_ix <= idx < start_ix + nl:
                    bad.add(o); fixed += 1
                    break
        print('round', rnd, 'errors', len(errs), 'fallbacks', len(bad))
        if not fixed:
            print(errs[:5]); open(f, 'w', encoding='latin1').write(orig); open('src/segacd/hockey.inc', 'w', encoding='latin1').write(inc); json.dump(assets, open(apath, 'w'), indent=1); sys.exit(1)
    else:
        open(f, 'w', encoding='latin1').write(orig); open('src/segacd/hockey.inc', 'w', encoding='latin1').write(inc); json.dump(assets, open(apath, 'w'), indent=1); sys.exit(1)
    # byte check against the disc
    if not os.path.exists('/tmp/new/hockey.bin'):
        open(f, 'w', encoding='latin1').write(orig); open('src/segacd/hockey.inc', 'w', encoding='latin1').write(inc); json.dump(assets, open(apath, 'w'), indent=1); print(atxt[-700:]); print('no output', [e for e in errs if 'odd address' not in e[2]][:6]); sys.exit(1)
    out = open('/tmp/new/hockey.bin', 'rb').read()
    if out != d:
        k = next(i for i in range(min(len(out), len(d))) if out[i] != d[i]) if out[:len(d)] != d[:len(out)] else min(len(out), len(d))
        print('MISMATCH at', hex(k), len(out), len(d))
        open(f, 'w', encoding='latin1').write(orig); open('src/segacd/hockey.inc', 'w', encoding='latin1').write(inc); json.dump(assets, open(apath, 'w'), indent=1); sys.exit(1)
    pass  # assets.json already holds the new assets
    # `#$addr` -> `#Label` for the labels this text defines (all global labels with an address in the asset)
    print('ok', key, 'src items', sum(1 for i in items if i[0] == 'src'), 'dc.b rows', sum(1 for i in items if i[0] == 'dcb'))


main()
