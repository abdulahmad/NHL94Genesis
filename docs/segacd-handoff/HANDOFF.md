# Sega CD handoff

## Now
- Unit: none in progress.
- Last check: 2026-11-17, `npm run build:segacd` (Linux, wine): MATCH 40 fragments, 0 errors (scouttext and scouttok merged into scouting.asm). `build:retail` MATCH.
- 2026-11-17 alignment review: the HOCKEY.BIN fragments that are cartridge routines now read like the cartridge source: 94G names, local labels, RAM names from `src/segacd/hockey.inc`, `name_map.csv` filled. Done: updatecrowdf, updatesound, sfx, song, InitScoutingDisplay, UpdateScoutingDisplay, ScrollDisplayUp, ScoutingReport (first part). Not cartridge code (SDK, disc loader, CD-DA): left with disc labels (L1xxxx).
- Finding: the disc team struct has the goalie word at `$28`, the cartridge `tmgoalie` is `$26`. Say so in 94G if that is wrong there.
- Next: PLAN.md step 1, the rest of ScoutingReport and the other HOCKEY routines, using `hockey.inc` names; step 0 coverage script still open.
- Open questions: the `$37xxx`-`$39xxx` image (PLAN.md step 2).

## Coverage (from NHL94Genesis `docs/segacd.md`, 2026-11-10)
| File | Size | Matched | Notes |
|---|---|---|---|
| MAIN.BIN | 60,416 | 13,994 (23%) | contiguous `$0`-`$34B7` plus Z80 loader and hardware readers |
| STARTER.BIN | 120,248 | 3,280 | boot, heap, PCM chip, audio stream, film player |
| HOCKEY.BIN | 184,842 | 2,656 | song/sfx requests, crowd, scouting text |
| PLAYER.BIN | 44,656 | 2,760 | photo picker, career rows, team page |
| GRAPH2.BIN | 3,051,520 | 0 | graphics archive; first longs are offsets |
| GTABLE.BIN | 2,048 | 0 | long offsets |
| Total code | 410,162 | 22,690 (5.5%) | |

## Parked units
(none)

## Round 2: HOCKEY.BIN scouting module (scout94.asm)

`src/segacd/scout94.asm` (`HOCKEY.BIN` `$D1D4`, 4090 bytes) replaces scoutopen.asm. It is generated from the cartridge source by `tools/emit_hockey.py` and `tools/hockey_align.py` (94G names, local labels and comments carried over), then annotated by hand where the disc differs (CD speech, `SDKCall`, `_CDBIOS`). `tools/segacd_calls.py` writes each fragment's routine equates from `name_map.csv`. The disc team struct has the goalie word at `$28`; the cartridge `tmgoalie` is `$26`.

## Round 3: the rest of HOCKEY.BIN as named source (hk_*.asm)

All of HOCKEY.BIN is now covered: 51 more fragments `src/segacd/hk_<94G file>_<n>.asm` (and `hk_data_<offset>.asm` where no cartridge routine lives), 91 fragments MATCH. The disc lays routines out in the cartridge's source-file order (onetimer, crowd, optsetup, cards, records, shootout, period, ui, hockey, stats, replay, logic, middle, decompress, print, penalty, collide, video, setup), so each fragment name is the 94G file whose routines dominate it.

How they are made (all in `tools/`):
1. `hockey_pair.py` disassembles each cartridge routine (from `output/obj/nhl94 .lst` after `node tools/build.js retail`) and finds its twin in HOCKEY.BIN by instruction shape. 391 routines pair (names in `name_map.csv`).
2. `hockey_syms.py` learns cartridge symbol to disc value from the paired routines (1,216 symbols, 94% unambiguous).
3. `hockey_auto.py` writes a fragment: paired routines as named code, everything else as `dc.w`. It assembles, and any instruction the assembler would encode differently (junk data that decodes as code, size changes) becomes `dc.w`, until the bytes match.
4. `hockey_align.py` copies the 94G local labels and comments onto the fragment.

Not done: routines the CD changed (they did not pair, so they are still `dc.w` words with no name), and the `dc.w` regions between paired routines (data tables, strings, unpaired code). The next steps are pairing by prefix to name the CD-changed routines, and turning data regions into labelled tables.
