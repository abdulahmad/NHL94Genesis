# Sega CD handoff

## Now
- Unit: none in progress.
- Last check: 2026-11-17, `npm run build:segacd` (Linux, wine): MATCH 40 fragments, 0 errors (scouttext and scouttok merged into scouting.asm). `build:retail` MATCH.
- 2026-11-17 alignment review: the HOCKEY.BIN fragments that are cartridge routines now read like the cartridge source: 94G names, local labels, RAM names from `src/segacd/hockey.inc`, `name_map.csv` filled. Done: updatecrowdf, updatesound, sfx, song, InitScoutingDisplay, UpdateScoutingDisplay, ScrollDisplayUp, ScoutingReport (first part). Not cartridge code (SDK, disc loader, CD-DA): left with disc labels (L1xxxx).
- Finding: the disc team struct has the goalie word at `$28`, the cartridge `tmgoalie` is `$26`. Say so in 94G if that is wrong there.
- Next: PLAN.md step 1, the rest of ScoutingReport and the other HOCKEY routines, using `hockey.inc` names; step 0 coverage script still open.
- Open questions: the `$37xxx`-`$39xxx` image (PLAN.md step 2).

## Status 2026-11-17 (rounds 5-6)
- HOCKEY.BIN is one assembly (`src/segacd/hockey.asm` + `hockey/gen_*.asm`), MATCH, no function equates. Assets are extracted like the cartridge (`tools/extractAssetsSegaCD.js`, `hockey/assets.json`).
- Round 6: 62 disc-only routines named from their cartridge twins (`tools/hockey_subnames.py`, fuzzy shape match >= 0.9), about 2,000 dc.w lines turned back into code (`hockey_dc2code.py`, `hockey_dc2code2.py`, `hockey_fixdc.py`), text tables as dc.b (`hockey_dcstr.py`), short branches (`hockey_dcbr.py`, targets written `*+N`).
- Round 7: short-branch targets labeled, 18 more names from cartridge twins, 50 L labels made local, the rest numbered per routine (`<Routine>_<n>`, `<Routine>Sub<n>`; `hockey_seqnames.py`). These are CD-only or CD-changed entry points with no cartridge twin. About 700 dc lines remain (tables, strings, undecodable data).
- MAIN.BIN (23%), STARTER.BIN (3%) and PLAYER.BIN (6%) are mostly undisassembled; their fragments still use `X_xxxx` equates for code outside the fragment. Bringing them to the HOCKEY structure means disassembling the rest of each file first.

## Status 2026-11-17 (round 8): every disc program is one assembly
- MAIN.BIN (`src/segacd/main.asm`), PLAYER.BIN (`player.asm`), STARTER.BIN (`starter.asm`) and HOCKEY.BIN (`hockey.asm`) each assemble from one top file plus parts in the same-named folder, byte for byte (`npm run build:segacd`). Assets (blocks of 512 bytes or more that are not code) are extracted at build time into Extracted/SegaCD/<FILE>/ (`tools/extractAssetsSegaCD.js`, `<dir>/assets.json`), like the cartridge.
- Built by `tools/segcd_one.py` (hand fragments kept for names and comments, minus their X_ equates; the bytes between them rebuilt from the disc: code found by `tools/segcd_flow.py` as instructions, zero runs dcb.b, text dc.b with quoted strings, large blocks incbin). `segcd_locals.py` makes address-named labels local where every use is in one routine, `segcd_seqnames.py` numbers the rest per routine, `segcd_strs.py` quotes text. The old hand fragments are in git history (the commit before PR #250).
- Sierra C function names come from the name tags in MAIN.BIN. Everything else in MAIN, PLAYER and STARTER is CD-only (SDK, film player, PCM, photo/career pages): no cartridge twin, so names are the hand names from the fragments, else `<Routine>_<n>` / `<Routine>Sub<n>`.
- Left: data that is not flagged as code (tables, tile data, strings split across lines) is still dc.b/dc.w; code reached only by indirect jumps may still be dc.b.

## Status 2026-11-17 (round 9): names, recovered code, data labels
- Regenerating MAIN/PLAYER/STARTER: `python3 tools/segcd_one.py <MAIN|PLAYER|STARTER> --fix`, then `segcd_locals.py`, `segcd_seqnames.py` (arg `src/segacd/<dir>`), `segcd_strs.py`, `segcd_fixlink.py <dir>`, build, then re-apply names (below). Generated parts are overwritten by a regeneration, names are not kept in them.
- Names live in `src/segacd/<dir>/names.json` (`{"@FF0278": ["Name", "comment"]}`, key = runtime address of the placeholder label in the last build, or the placeholder itself) and are applied by `tools/segcd_rename.py <dir>`; applied entries move to `names_applied.json`. `tools/segcd_tags.py <dir>` writes names.json from the Sierra C name tags (the tag follows its function, the string literals after it are `<Func>Str<n>`).
- Generator fixes this round: `ori.b #imm,d0` is code, not padding (it hid whole routines); prologue seeds go before pointer seeds (a pointer into the middle of an instruction used to split real routines); calls that read inline data from the return address (`cfg["inline_calls"]`: command words, a length word) skip the data; `link`/`btst` spellings SNASM accepts; the row check no longer sends short branches and `rts` back to dc.w (dc.w code lines: STARTER 354 -> 6, MAIN 241 -> 29, PLAYER 23 -> 2); add/sub immediates that SNASM would turn into quick forms get a per-line `opt oaq-/osq-` wrapper.
- Named: MAIN VDP/DMA/print/pad/word-RAM/Z80 helpers, handshakes, Sierra C functions; PLAYER page, picture, pad and BCD routines, strings, column tables, picture tiles; STARTER PCM chip, comm registers, word RAM, IRQ hooks, BCD and the Sierra C functions (film, heap, audio, text). Zero-filled work storage is `Byte/Word/Long<n>` or `Buf<size>_<n>`.
- Still numbered (`<Routine>_<n>`): about 50 STARTER routines of the CD command/state machine at $22xxx-$24xxx, 7 MAIN routines, and the mid-routine labels. HOCKEY.BIN keeps about 600 dc lines (tables, strings, 41 `lea label(pc)` rows).

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

## HOCKEY.BIN is one assembly (round 5)

`src/segacd/hockey.asm` assembles the whole of HOCKEY.BIN at `org $1B000`, the address the game loads at, so every label is a runtime address and calls are plain labels. There are no equates for functions and no `-LOAD`/`+LOAD`. The parts are in `src/segacd/hockey/`: the hand-written fragments (crowdanim, scout94, scouting, cdrequest, ...) and `gen_<offset>.asm`, generated, in disc order. `output/segacd/hockey.bin` is compared with the whole of `cdbin/HOCKEY.BIN`.

Code is found by following calls and branches from the routines paired with the cartridge (`tools/hockey_flow.py`); everything else is data. Data blocks of 256 bytes or more are assets: `src/segacd/hockey/assets.json` lists them, `tools/extractAssetsSegaCD.js` writes them to `Extracted/SegaCD/HOCKEY/` (like the cartridge's `Extracted/`), and the source `incbin`s them. Smaller data stays as labelled `dc.w`.

Regenerate (only needed when the pairing or classification changes):
1. `node tools/build.js retail`, then copy `output/nhl94.bin` and `output/obj/nhl94 .lst` to /tmp (the Sega CD build empties output/obj).
2. `python3 tools/hockey_pair.py /tmp/nhl94.bin cdbin/HOCKEY.BIN /tmp/nhl94.lst > /tmp/hk_pairs.csv`, then `python3 tools/hockey_syms.py /tmp/hk_pairs.csv /tmp/nhl94.bin cdbin/HOCKEY.BIN /tmp/nhl94.lst > /tmp/hk_syms.csv`.
3. `python3 tools/hockey_single.py` (writes the parts, then repairs any instruction the assembler would encode differently by turning it into `dc.w`, until the bytes match).

About 550 cartridge routines are paired by instruction shape (routines the CD changed are found by aligning the disc code between two exact pairs). Not done: the generic names. Branch targets inside routines are `L<offset>` labels, call targets with no cartridge twin are `Sub_<runtime address>`, and data that the cartridge has but the disc relocated is still unnamed words.
