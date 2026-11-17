#!/usr/bin/env python3
"""label -> runtime address of a disc program, from the last build listing (output/obj/<name> .lst)."""
import re, sys
def labels(name):
    out = {}
    for l in open('output/obj/%s .lst' % name, errors='replace').read().replace('\r', '').split('\n'):
        m = re.match(r'^([0-9A-F]{8}) [0-9A-F +]*?\s{2,}([A-Za-z_]\w*)(\t|$)', l)
        if m and not m.group(2).startswith('.'):
            out.setdefault(m.group(2), int(m.group(1), 16))
    return out
if __name__ == '__main__':
    for k, v in sorted(labels(sys.argv[1]).items(), key=lambda kv: kv[1]):
        print('%X %s' % (v, k))
