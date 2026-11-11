"""segacd_comments.py: lay out the comments of Sega CD sources the way CONTRIBUTING.md asks (and
tools/check_comments.py checks): a trailing comment at column 36 (one tab past code that reaches it),
continuation lines at column 36, no comment line wider than 110 columns, and header paragraphs of at most
3 lines. Only whitespace and comment line breaks change, never code, so the bytes stay the same.

    python tools/segacd_comments.py [files...]      (default: every .asm / .inc under src/segacd/)

The generators (segacd_port.py, segacd_graph2.py) run their output through fix_layout(), so a file they
write again comes out the same.
"""
import glob
import os
import re
import sys

WIDTH, COL, MAXPARA = 110, 36, 3
DATA = re.compile(r'^(dc\.\w+|db|dw|dl|dd)\b', re.I)
BANNER = re.compile(r'^;[>=<\-*]{3}')


def vis(s):
    c = 0
    for ch in s:
        c = (c // 4 + 1) * 4 if ch == '\t' else c + 1
    return c


def split(line):
    """(code, comment): the comment starts at the first ';' outside a string (as check_comments.py)."""
    q = None
    for i, ch in enumerate(line):
        if q:
            if ch == q:
                q = None
        elif ch in "'\"":
            q = ch
        elif ch == ';':
            return line[:i], line[i:]
    return line, None


def pad_to_comment(code):
    """code (no trailing blanks) plus the tabs that put a comment at COL, or one tab past it."""
    w = vis(code)
    if w < COL:
        return code + '\t' * (COL // 4 - w // 4)
    return code + '\t'


def wrap(text, prefix):
    """Split comment text (no ';') at spaces into pieces that fit in WIDTH columns after prefix (tabs in
    the text count by where they fall)."""
    words = text.split(' ')
    out, cur = [], ''
    for wd in words:
        t = wd if not cur else cur + ' ' + wd
        if vis(prefix + t) <= WIDTH or not cur:
            cur = t
        else:
            out.append(cur)
            cur = wd
    out.append(cur)
    return out


def is_continuation(l):
    """A comment line indented past the code (only blanks before its ';')."""
    code, cm = split(l)
    return cm is not None and not code.strip() and code != '' and vis(code) > 4


def fix_lines(lines):
    out = []
    prev_trailing = False
    i = 0
    while i < len(lines):
        l = lines[i]
        i += 1
        code, cm = split(l)
        if cm is None:
            out.append(l)
            prev_trailing = False
            continue
        if code.strip():                                    # a trailing comment
            head = pad_to_comment(code.rstrip())
            body = cm[1:].strip()
            line = head + ';' + body
            if vis(line) > WIDTH and not DATA.match(code.strip()):
                # wrapped together with its continuation lines, so the breaks stay even
                while i < len(lines) and is_continuation(lines[i]):
                    body += ' ' + split(lines[i])[1][1:].strip()
                    i += 1
                parts = wrap(body, head + ';')
                out.append(head + ';' + parts[0])
                rest = ' '.join(parts[1:])
                if rest:
                    cont = '\t' * (COL // 4) + ';'
                    out += [cont + p for p in wrap(rest, cont)]
            else:                                           # dc lines may be wide: the comment stays whole
                out.append(line)
            prev_trailing = True
            continue
        lead = code                                         # a comment line: only blanks before the ';'
        if lead and vis(lead) > 4 and prev_trailing:        # a continuation of a trailing comment
            lead = '\t' * (COL // 4)
        body = cm[1:]
        line = lead + ';' + body
        if vis(line) > WIDTH:
            m = re.match(r'([\t ]*)(.*)$', body)
            indent, text = m.group(1), m.group(2)
            prefix = lead + ';' + indent
            out += [prefix + p for p in wrap(text, prefix)]
        else:
            out.append(line)
        prev_trailing = prev_trailing and bool(lead)
    return out


def fix_paragraphs(lines):
    """Header blocks (lines starting ';<tab>'): no paragraph longer than MAXPARA lines. A long one gets
    ';' lines, after a line that ends a sentence where one does, else after MAXPARA lines."""
    out = []
    i = 0
    while i < len(lines):
        if lines[i].startswith(';\t') and not BANNER.match(lines[i]):
            j = i
            while j < len(lines) and lines[j].startswith(';') and not BANNER.match(lines[j]):
                j += 1
            para = []
            for k in range(i, j + 1):
                blank = k == j or re.match(r'^;\s*$', lines[k])
                if blank:
                    out += split_para(para)
                    para = []
                    if k < j:
                        out.append(lines[k])
                else:
                    para.append(lines[k])
            i = j
        else:
            out.append(lines[i])
            i += 1
    return out


PROSE = re.compile(r'^;\t[^\t|\-*$ ]')


def split_para(para):
    """A paragraph of more than MAXPARA lines. Prose (';<tab>text' lines) is joined and laid out again in
    sentence-bounded paragraphs of at most MAXPARA lines; anything else (tables, lists) gets a ';' line
    after a sentence end or every MAXPARA lines."""
    if len(para) <= MAXPARA:
        return para
    if all(PROSE.match(l) for l in para):
        text = ' '.join(l[2:].strip() for l in para)
        sentences = re.split(r'(?<=[.:])\s+(?=[A-Z(`$\'"])', text)
        prefix = ';\t'
        out, cur = [], []
        for s in sentences:
            trial = wrap(' '.join(cur + [s]), prefix)
            if len(trial) <= MAXPARA or not cur:
                cur.append(s)
                continue
            out.append(wrap(' '.join(cur), prefix))
            cur = [s]
        out.append(wrap(' '.join(cur), prefix))
        res = []
        for chunk in out:
            while len(chunk) > MAXPARA:                     # one sentence longer than MAXPARA lines
                res += [prefix + c for c in chunk[:MAXPARA]] + [';']
                chunk = chunk[MAXPARA:]
            res += [prefix + c for c in chunk] + [';']
        return res[:-1]
    out, run = [], []
    for n, l in enumerate(para):
        run.append(l)
        left = len(para) - n - 1
        ends = l.rstrip().endswith(('.', ':'))
        if left and (len(run) == MAXPARA or (ends and len(run) >= 2)):
            out += run + [';']
            run = []
    return out + run


def fix_layout(text):
    lines = text.split('\n')
    return '\n'.join(fix_paragraphs(fix_lines(lines)))


def main(argv):
    paths = argv or [f for f in glob.glob(os.path.join('src', 'segacd', '**', '*'), recursive=True)
                     if f.lower().endswith(('.asm', '.inc')) and os.path.isfile(f)]
    changed = 0
    for p in sorted(paths):
        raw = open(p, encoding='latin-1', newline='').read()
        nl = '\r\n' if '\r\n' in raw else '\n'
        t = raw.replace('\r\n', '\n')
        new = fix_layout(t)
        if new != t:
            open(p, 'w', encoding='latin-1', newline='').write(new.replace('\n', nl))
            changed += 1
    print(f'{changed} file(s) laid out again')


if __name__ == '__main__':
    main(sys.argv[1:])
