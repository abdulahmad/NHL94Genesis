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
- 2026-11-10 hockey: HOCKEY.BIN runs at `$1B000`; a fragment assembled at `org $1B000+offset` gets its absolute operands (calls, tables, `dc.l` pointers) right with labels. (crowdtable `$4154C`, printsmall `$38D9E` = file `$1DD9E`)
- 2026-11-10 hockey: `cmp.l #n,dn` is `cmpi.l` (`0C8x`) on the disc; the cartridge ROM has `cmp.l` (`B?BC`) from fixopcodes. Write `cmpi.l`. (onetimer94 `puckvzadj`)
- 2026-11-10 hockey: a zero struct offset (`Xpos(a3)`, Xpos = 0) stays a 16-bit displacement on the disc; write `Xpos(a3)` or `0(a3)` with `/o oz-`, never `(a3)`. (onetimer94 `assonetimer`)
- 2026-11-10 hockey: the disc team struct is one word longer: `tmOneTimers` `$35E`, `tmsize` `$366` (cartridge `$35C`, `$364`). Every team struct offset from `tmap` is +2. Take struct offsets from disc operands. (onetimer94 `onetimershot`, period94 `TeamStatTextTbl`)
- 2026-11-10 hockey: `movea.w #ram,an` (a short immediate the 68000 sign-extends to `$FFxxxx`) is `movea.l` on the disc: the sub CPU RAM is above `$FFFF`. (logic94 `checkwindow`)
- 2026-11-10 hockey: a cartridge `movea.l #map,a0` / `lea tiles,a2` of a graphic became a load from the pointer table at `$47D00` (file `$2CD00`, zeros on the disc, filled at run time); those lines are CD code. (optsetup94, cards94 ...)
- 2026-11-10 hockey: never take bytes from `Extracted/`: licensed names and cartridge assets are `incbin ..\cdbin\HOCKEY.BIN,offset,length`. The port tool stops on a player name or team nickname. (optsetup94 New York names, cards94 palettes)
- 2026-11-10 hockey: data can end on an odd address; a decoder that steps 2 bytes stays odd and never finds the code again. Step 1 byte there. (logic94 table ending at `$15CDD`)
- 2026-11-10 hockey: SNASM pads `dc.w` to an even address; data at an odd address is `dc.b`. (records94)
- 2026-11-10 hockey: `move #$2700,sr` (interrupts off) became `bclr.b #5,$FF800F` around screen setups; `jsr MenuWaitVblank` became `jsr $6044.w` (BIOS). (records94 `NameEntryScreen`, cards94)
- 2026-11-10 owner (Abdul, PR #239): Sega CD code goes in the Sega CD folder and does not touch the existing work. The older fragments in `src/segacd/` stay as they are; a 94G twin is written in parts around them (`name.asm`, `name_2.asm`). Align code, symbols and file names with 94G where possible.
- 2026-11-10 boot: the disc's boot sectors hold code (the initial program and the system program with the `$6044` services); they are not a file, so `tools/segacd_bootarea.py` copies them from a disc image to `cdbin/BOOT.BIN` and the build skips `src/segacd/boot/` without it. (docs/segacd_boot.md)
- 2026-11-10 owner (Abdul, later): the older fragments may be corrected (bases, names), keeping their bytes; CD-only names are fine for now.
- 2026-11-10 hockey: a constant defined in a 94G code file (`collrad = 8` in collide94) belongs to that file's fragment; other fragments get their own equate, never `hockey.inc`. (collide94: `collrad` multiply defined)
- 2026-11-10 hockey: the disc team data differs from the cartridge's in places and may hold names the cartridge lists do not have; port it with `--no-text` (every non-public quoted line and every CD block is incbin from the disc). (teamdata94)
- 2026-11-10 hockey: a shared name (ram94 / teamdata94 / macros) defined inside a fragment is a comment there and a value in hockey.inc, whatever order the fragments are written in. (teamdata94: NumTeams multiply defined)
- 2026-11-10 starter: STARTER.BIN file `$1000`-`$3D93` runs at file + `$B000`, not `$21300`; test a base by checking that absolute call targets fall just after an `rts`. (17 of 19 at `$B000`, 0 at `$21300`)
- 2026-11-10 starter: test a base on every part of a file, data addresses too, not on one jump: the whole of STARTER.BIN runs at `$B000`. A single target that fits another base (the boot's `jmp` onto a `link a6` at `$21300`) can be chance. (crt `lea $104EC.l`, the tail's calls, the boot's `$B090`)
- 2026-11-10 main: MAIN.BIN runs at `$FF1000`, not `$FF0000`: a pointer table is the best base test (61 of 64 entries on routine starts at `$FF1000`, 1 at `$FF0000`). (maintable.asm, the first `jmp $FF45A8`)
- 2026-11-10 hockey: a call that matches a cartridge line by instruction shape can have a new target; when another fragment has that cartridge label elsewhere, do not solve it to the new target. The same goes for placing another 94G file's label by branch evidence. (hockey94_2: setSlotBit, updatepwrplay, checkwindow; logic94: rtss2)
- 2026-11-10 starter: Sierra C puts a function's string literals after its name tag; the next function starts at the next `link a6`. (heapalloc: the ffree messages between ffree and findSmallestBlock)
- 2026-11-10 starter: the STARTER credits text names real people (one matches a player name); text runs there are incbin from the disc (`--text-incbin`). (startertail)
