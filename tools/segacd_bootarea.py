"""segacd_bootarea.py: copy the boot area (and, with --files, the six disc files) from your own disc image
into cdbin/.

    python tools/segacd_bootarea.py "path/to/NHL '94.cue" [--files]

The boot area is the first 16 sectors of the data track (32 KB): the disc header, the main CPU's initial
program and the sub CPU's system program. It is not a file on the disc, so the image is the only place to
get it. It goes to cdbin/BOOT.BIN, which the src/segacd/boot/ fragments are compared with; the build skips
those fragments when the file is missing. With --files, MAIN.BIN, STARTER.BIN, HOCKEY.BIN, PLAYER.BIN,
GRAPH2.BIN and GTABLE.BIN are copied out of the image's ISO 9660 file system too.

The image may be a .cue (with its .bin, data track MODE1/2352 or MODE1/2048), a .bin of 2352-byte sectors,
or an .iso of 2048-byte sectors. Nothing here is written outside cdbin/, and cdbin/ is not in the repo.
"""
import os
import re
import sys

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')
SIX = {'MAIN.BIN': 60416, 'STARTER.BIN': 120248, 'HOCKEY.BIN': 184842, 'PLAYER.BIN': 44656,
       'GRAPH2.BIN': 3051520, 'GTABLE.BIN': 2048}


def open_image(path):
    """(file, sector size, offset of the user data in a sector) for the data track."""
    if path.lower().endswith('.cue'):
        cue = open(path, encoding='latin1').read()
        m = re.search(r'FILE\s+"([^"]+)"', cue)
        if not m:
            sys.exit('no FILE line in the cue sheet')
        mode = re.search(r'TRACK\s+01\s+MODE1/(\d+)', cue)
        if not mode:
            sys.exit('track 1 is not a MODE1 data track')
        name = m.group(1)
        binp = os.path.join(os.path.dirname(path), name)
        if not os.path.exists(binp):            # the cue may name the file differently from the one on disk
            bins = [f for f in os.listdir(os.path.dirname(path) or '.') if f.lower().endswith('.bin')]
            if len(bins) != 1:
                sys.exit(f'{name} not found next to the cue sheet')
            binp = os.path.join(os.path.dirname(path), bins[0])
        size = int(mode.group(1))
        return open(binp, 'rb'), size, 16 if size == 2352 else 0
    f = open(path, 'rb')
    head = f.read(16)
    if head[:12] == b'\x00' + b'\xff' * 10 + b'\x00':
        return f, 2352, 16
    return f, 2048, 0


def main():
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    if len(args) != 1:
        sys.exit(__doc__)
    f, size, skip = open_image(args[0])

    def sector(n, count=1):
        out = b''
        for i in range(count):
            f.seek((n + i) * size + skip)
            out += f.read(2048)
        return out

    boot = sector(0, 16)
    if boot[:16] != b'SEGADISCSYSTEM  ':
        sys.exit('sector 0 is not a Sega CD disc header')
    cd = os.path.join(ROOT, 'cdbin')
    os.makedirs(cd, exist_ok=True)
    open(os.path.join(cd, 'BOOT.BIN'), 'wb').write(boot)
    print(f'cdbin/BOOT.BIN: {len(boot)} bytes ({boot[16:27].decode("latin1").strip()})')
    if '--files' not in sys.argv:
        return
    pvd = sector(16)
    if pvd[1:6] != b'CD001':
        sys.exit('no ISO 9660 volume descriptor at sector 16')
    root = pvd[156:190]
    ext, length = int.from_bytes(root[2:6], 'little'), int.from_bytes(root[10:14], 'little')
    d = sector(ext, (length + 2047) // 2048)
    p, found = 0, {}
    while p < length:
        n = d[p]
        if n == 0:
            p = (p // 2048 + 1) * 2048
            continue
        rec = d[p:p + n]
        name = rec[33:33 + rec[32]].decode('latin1').split(';')[0]
        found[name] = (int.from_bytes(rec[2:6], 'little'), int.from_bytes(rec[10:14], 'little'))
        p += n
    for name, want in SIX.items():
        if name not in found:
            sys.exit(f'{name} is not on this disc')
        lba, n = found[name]
        data = sector(lba, (n + 2047) // 2048)[:n]
        open(os.path.join(cd, name), 'wb').write(data)
        print(f'cdbin/{name}: {n} bytes' + ('' if n == want else f' (GETTING_FILES.md lists {want}: another release?)'))


if __name__ == '__main__':
    main()
