# Plan

Order is chosen by payoff per effort. Sizes are bytes of code left. Run the check after each unit.

Method for every step: **one segment at a time**, names and file placement aligned with 94 Genesis (see RULES.md). A segment is done when it matches, is named, and is in the docs; only then start the next.

## Step 0: baseline (half a day)
Get the files in place, run `npm run build:segacd` and the cartridge verify, record both in HANDOFF.md. Add `tools/segacd_check.sh` that runs the build and prints matched bytes per file, so progress is a number. If a fragment fails, fix that first.

## Step 1: HOCKEY.BIN, the cartridge game relinked (181 KB left, biggest win)
HOCKEY.BIN has the same shape as the cartridge (656 `rts`, 328 `movem.l`) and the same code, assembled with long absolute addresses. The cartridge is already matched and named, so most of this is transcription, not discovery.
1. Run `tools/segacd_relocs.py` on the cartridge and `HOCKEY.BIN` to get the cartridge-to-disc address pairs (variables like `$B028` to `$18D58`, calls like `$11A48` to `$38D9E`).
2. Try to make the transcription mechanical: take a cartridge routine, rewrite its absolute addresses through the pairs, assemble with `/o oz-`, compare against the matching disc range. A routine that matches this way needs only a fragment line and a name. A routine that differs shows exactly what the CD changed (sub CPU comm flag, CD audio, film calls), and those are the interesting ones to write up.
3. Work from the start of the file: the team data block ($7C onward) matches the cartridge for 733 bytes and then splits (disc has "Eastern division" where the cartridge has "Madison Square Garden"). Then the game screens ("Play Mode", "Line Editor", "SHOOTOUT MODE"), then gameplay.
4. Cover HOCKEY.BIN segment by segment, using the cartridge's own segment list and file layout (the include list in `src/nhl94.asm`, `src/`), so each disc segment sits next to its 94G twin and carries its 94G names. Keep `docs/name_map.csv` (disc file, address, 94G name).
Measure: matched bytes of HOCKEY.BIN. A sensible first target is 25%.

## Step 2: the `$37xxx`-`$39xxx` question (time-box one day)
Calls such as printsmall `$38D9E`, printz `$38F6E`, Framer `$38CA0` target addresses above the end of HOCKEY.BIN (`$2D20A`), and no disc file contains those bytes at that address. The same routines also exist inside HOCKEY.BIN, reached by `bsr`. Find out where the `$37xxx` image comes from: look for a copy loop in STARTER.BIN or HOCKEY.BIN that moves a block into program RAM at start-up (search for a long `move.l #$37000`-range constant and `LEA`/`DBF` copy loops), and a second load from disc via the BIOS file calls. Write the answer in a new `docs/segacd_memory_map.md`. If it is not found in a day, park it with what you tried.

## Step 3: STARTER.BIN, the SDK (117 KB left)
Sierra C code; each function's name follows its `rts`, so naming is free. Continue after the film player: heap (`mmalloc`/`ffree`), main/sub commands, CD and PCM handling. Compare with the matched fragments for style. Candidate for a script: split the file at `rts` plus name tag into function units automatically.

## Step 4: PLAYER.BIN (42 KB left) and the rest of MAIN.BIN (46 KB left)
Smaller, independent, good for warm-up if HOCKEY.BIN is slow. MAIN.BIN after `$34B7` includes the second copy of the eleven C handlers (`$2240` bytes later), so the second copy should be near-free once the first is understood.

## Step 5: data files
`GRAPH2.BIN` (offset table, then graphics) and `GTABLE.BIN`: represent as `.incbin` or tables with a documented layout; extract assets only where useful. Do last; the value is the format notes, not the bytes.

## Done means
`npm run build:segacd` reproduces all six files byte for byte from `src/segacd/`, with docs per area, a name map, and the cartridge build unchanged.

## Housekeeping while you go
- Keep `docs/segacd.md` table current; update HANDOFF.md each session.
- When 3+ areas are stable, consider moving Sega CD into its own repo so it stops sharing `docs/HANDOFF.md` with the cartridge. Owner decides.
