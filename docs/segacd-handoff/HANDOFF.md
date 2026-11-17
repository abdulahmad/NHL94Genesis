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
