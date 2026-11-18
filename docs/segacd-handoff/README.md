# NHL '94 Sega CD: start here

Goal: a byte-matching disassembly of the Sega CD disc code, written so it reads like the original source.
Same idea as the cartridge repos, with one difference: the check is the disc files, not the cartridge ROM.

## Where things are
Everything you need is in `abdulahmad/NHL94Genesis` (fork it): the work (`src/segacd/*.asm`, `tools/segacd.json`, `tools/verifySegacd.js`, `tools/emit_m68k.py`, `tools/segacd_relocs.py`), the write-ups `docs/segacd*.md`, these handoff docs (`docs/segacd-handoff/`). The six disc files are not in the repo: copy them from your own disc to `cdbin/` (see GETTING_FILES.md).

The cartridge disassembly is finished and its build must keep passing (`tools/verify_all.sh -q` ends in `ALL MATCH`).
Ignore the cartridge "Now" block in its `docs/HANDOFF.md`; Sega CD progress is tracked in [HANDOFF.md](HANDOFF.md) here.

## Read in this order
1. [GETTING_FILES.md](GETTING_FILES.md): set up the folders and the six disc files, then run the build.
2. NHL94Genesis `docs/segacd.md`: what each file is, what the disc changed, the table of matched slices.
3. [PLAN.md](PLAN.md): what to do, in order, and how to size each step.
4. [RULES.md](RULES.md): how each unit is done and checked.
5. [HANDOFF.md](HANDOFF.md): where things stand now. Update it before you stop.
6. The area write-up for whatever you pick: `docs/segacd_audio.md`, `_announce`, `_crowd`, `_film`, `_song`, `_stats`.

## Credit
Add nothing new to the credit text, but never remove it: NHL94Genesis README "Credits and derivative works"
(chaos, StaticEck, McMarkis (Mhopkinsinc), Drezz; special thanks smozoma and kingraph).
