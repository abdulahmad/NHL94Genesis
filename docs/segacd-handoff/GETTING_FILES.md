# Getting the files and running the build

## 1. Fork and clone
Fork `abdulahmad/NHL94Genesis` and clone your fork.

## 2. The six disc files
Needed: `MAIN.BIN`, `STARTER.BIN`, `HOCKEY.BIN`, `PLAYER.BIN`, `GRAPH2.BIN`, `GTABLE.BIN`.
Place them in `NHL94Genesis/cdbin/` (the folder is gitignored; never commit them to the fork).

**Easiest:** copy them from `segacd-disc/` in this repo: `mkdir cdbin && cp segacd-disc/*.BIN cdbin/`. `cdbin/` is the only place the build reads, and it is gitignored.

**If `segacd-disc/` is ever missing, or from your own NHL '94 Sega CD disc:** take them from your own NHL '94 Sega CD disc:
- The disc has a data track (track 1, ISO 9660). Open the `.bin/.cue` image with 7-Zip (`7z x image.bin`), or mount it, or on Linux `bchunk` then `7z x`. Copy the six files out of the root.
- Check sizes: MAIN 60,416; STARTER 120,248; HOCKEY 184,842; PLAYER 44,656; GRAPH2 3,051,520; GTABLE 2,048 bytes. A different size means a different disc release; say so in HANDOFF.md before going on.
- Or let the repo do it: `python tools/segacd_bootarea.py "path/to/NHL '94.cue" --files` copies the six files out of the image (a `.cue` with its `.bin`, or an `.iso`) into `cdbin/`.

**Optional, the boot area:** the disc's boot sectors (header, initial program, system program) are not a file, so only the image has them. `python tools/segacd_bootarea.py "path/to/NHL '94.cue"` writes `cdbin/BOOT.BIN`, and the build then also checks `src/segacd/boot/` (four fragments, skipped without it). Never commit the image or `cdbin/`.

## 3. Build tools
- Node 18+ and `npm install` in `NHL94Genesis`.
- The assembler is SNASM68k (`assembler/Assembler.exe`, already in the repo). Windows runs it directly. Linux needs `wine` (`apt install wine wine32`, i386 enabled).

## 4. Check it works before you change anything
```
npm run build:segacd      # assembles src/segacd/*.asm, compares to cdbin/
tools/verify_all.sh -q    # cartridge: must still end in ALL MATCH
```
Every fragment should report a match. If any does not, record it in HANDOFF.md first: it is the baseline.
