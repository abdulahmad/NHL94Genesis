# Rules for the Sega CD work

* **The check is a program.** A unit passes when `npm run build:segacd` reports every byte of its range equal to the disc file. "Looks right" and model confidence are never a pass.
* **Unit:** one function, or one contiguous slice of one disc file, small enough to finish in one sitting. Pick the first unmatched range after an existing fragment so the matched area grows without gaps.
* **Steps for a unit:** disassemble the range (IDB, or `tools/emit_m68k.py`); write `src/segacd/<name>.asm`; add one line to `tools/segacd.json` (copy a neighbour's options) and the compare in `tools/verifySegacd.js`; build; add a row to the table in `docs/segacd.md`.
* **Segments, one at a time.** Split each disc file into segments the way the cartridge is split (see `tools/segments.json` and `src/` in NHL94Genesis), and take one segment per session: write it, make it match, update the docs, push, then start the next. Do not open a second segment while one is unmatched.
* **Names align with 94 Genesis.** Where the disc code is the cartridge routine, use the 94G name, and put the segment in the file/folder the same routine has in `src/` of NHL94Genesis. Find the 94G routine through the address pairs (`tools/segacd_relocs.py`) or by comparing bytes. Record disc-to-94G pairs in `NHL94-SCD/docs/name_map.csv` (`disc_file,disc_addr,name_94g,notes`). CD-only code gets a new name in the style of the 94G names, and a note. Do not rename 94G routines; if a 94G name looks wrong, say so in HANDOFF.md.
* **Names (details):** follow the cartridge names where the code is the same routine (`docs/name_map.csv` in NHL94Genesis and the cartridge source). SDK (Sierra C) functions carry their own name in the bytes after each `rts`; use it. Anything unknown stays `sub_<address>`; do not guess.
* **Disc quirks, not mistakes:** long absolute addresses, `addq` becoming `addi`, `bra.b` becoming `bra.w`. Assemble with `/o oz-`.
* **Return rule:** a unit that fails the check gets at most 3 attempts. Then park it: write what you tried and the first differing byte in HANDOFF.md and take another unit.
* **Learned rules:** every confirmed cause of a mismatch becomes one line at the bottom of this file, newest last: `- YYYY-MM-DD area: rule. (evidence)`.
* **Never:** commit disc files or ROMs; change the cartridge build; force-push; remove credits.
* **Branches:** one branch per area, e.g. `<you>/segacd-<area>`. Open PRs against the owner's repo for review.
* **Before you stop:** update HANDOFF.md (Now block) and push. Nothing lives only in a chat.

## Learned
- 2026-11-17 labels: a fragment that is a cartridge routine uses the 94G global label and `.n` local labels (SNASM `/o l.`). A label that is also an `equ` in `src/segacd/ram94cd.asm` clashes, so routines defined in a fragment are not equated there. Fragments of one routine are merged into one file so local labels work. (scouting.asm)
- 2026-11-17 names: call-target names come from `tools/segacd_relocs.py` pairs or from the position in the 94G routine; the position is checked by the build, because every name is only an `equ` or a label and the bytes must still MATCH.
