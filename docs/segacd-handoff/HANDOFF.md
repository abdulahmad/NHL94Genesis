# Sega CD handoff

## Now
- Unit: none in progress. Branch `mcmarkis/segacd-hockey` (fork Mhopkinsinc/NHL94Genesis), PR abdulahmad/NHL94Genesis#239.
- Last check: 2026-11-10, Windows: `npm run build:segacd` MATCH 127 fragments with `cdbin/BOOT.BIN` (123 without:
  the 4 boot area fragments are skipped); `tools/verify_all.sh -q` ALL MATCH.
  `tools/segacd_check.sh`: all four code files match in full, 410,162 of 410,162 bytes. Of those, 43,120 (HOCKEY.BIN),
  25,806 (PLAYER.BIN) and about 87 KB (STARTER.BIN) are graphics, pictures, licensed names or credits read from the
  disc with incbin; the rest is source. GRAPH2.BIN and GTABLE.BIN (PLAN step 5) match too: all six disc files are
  built byte for byte (`src/segacd/data/`).
- Owner decision (Abdul, on the PR): all Sega CD code goes in the Sega CD folder and does not touch the existing
  work; align code, symbols and file names with 94G where possible. So the older hand fragments in `src/segacd/`
  stay as they are, and a 94G twin whose disc range holds one is written in parts around it (`name.asm`,
  `name_2.asm`, ... in `src/segacd/hockey/`; `port name:2 ...` in `tools/segacd_hockey.sh`).
- Owner update (Abdul, 2026-11-10): the older fragments can be corrected (done: STARTER and MAIN ones moved to
  `$B000` / `$FF1000`, same bytes); CD-only names are fine for now; hwread.asm's handlers get names.
- Done: PLAN step 0 (`tools/segacd_check.sh`), step 2 (`docs/segacd_memory_map.md`), and step 1: all of HOCKEY.BIN,
  one twin per 94G file in `src/segacd/hockey/` (some in parts around the older fragments), the team data with
  `--no-text`, and two CD-only files (`cdgfxptrs.asm`, `cdpads.asm`). title94 is not on the disc.
- How: `tools/segacd_port.py` writes a segment from the cartridge listing; `tools/segacd_hockey.sh` holds every
  segment's range, the hand-checked names and the header notes, and writes them all again from scratch
  (`npm run build:retail` first, keep a copy of `output/obj/nhl94 .lst`: the Sega CD build empties `output/obj/`).
  `docs/segacd.md` "HOCKEY.BIN from the cartridge source" explains the method.
- Comment layout: `tools/check_comments.py` is clean for all of `src/segacd/` (CONTRIBUTING.md's checklist). The
  generators lay out their output with `tools/segacd_comments.py` (columns, widths, 3-line paragraphs); run it
  on a hand-written file after editing it. The 18 problems it still reports are in cartridge files, as upstream.
- STARTER.BIN, MAIN.BIN, PLAYER.BIN (PLAN steps 3 and 4) match in full: `src/segacd/starter/`, `main/`, `player/`,
  written by `tools/segacd_starter.sh`, `segacd_main.sh`, `segacd_player.sh` (no ROM or listing needed).
- Next:
  1. PLAN step 5: GRAPH2.BIN is an archive of 99 sector-aligned resources and GTABLE.BIN is its index (start sector,
     byte size); HOCKEY.BIN loads resource n with BIOS `$6044`, d7 = 1, d0 = n (`docs/segacd.md` "GRAPH2.BIN and
     GTABLE.BIN", `tools/segacd_graph2.py`). The two packs (resources 0 and 1) are named piece by piece, and the
     loader of every other resource is noted (HOCKEY, STARTER or PLAYER; 6-33 and 68-95 are per team). Their contents are
     described too (legal and loading screens, scoreboard frame, font, stats, page backgrounds). The code that reads GTABLE is
     the disc's system program (item 4).
  2. Names: STARTER's driver module is named (`docs/segacd_starter_driver.md`). PLAYER's code is named
     (`docs/segacd_player.md`), and so are MAIN's shell, command table and sound engine
     (`docs/segacd_main_shell.md`; MAIN.BIN runs at `$FF1000`, not `$FF0000`). The older interface's handlers are
     labelled too, and hwread.asm's; the drawing commands (`$02`, `$04`-`$12`, `$17`, `$18`) have names for what they
     draw (pictures, tiles, text through a `.map.jim` font, frame rows, cell copies; "Drawing" in that doc). HOCKEY's
     header and TeamList are source now; the graphics pointer table has 38 of 44 entries named (`--cdname` in
     `tools/segacd_hockey.sh`; ScoutingSpeechClipsPtr is the scouting report's speech clips,
     `docs/segacd_announce.md`), the rest have no cartridge label (their comments say what they hold). The older
     `scoutload.asm` and `scoutopen.asm` use the names too. A from-scratch run of `tools/segacd_hockey.sh`
     (2026-11-10) reproduced every HOCKEY fragment except the lines that gained the new name.
  3. Formats: STARTER's data is five `.map.jim` pictures (the Credits title, its font, High Score Productions,
     the EA SPORTS logo sprites, sparkles; packed tiles in the cartridge's DecompressBytecode format, which
     MAIN.BIN's copy of the cartridge decompressor unpacks) and a PCM record directory (`startergfx.asm`). MAIN's
     Z80 sound image is asm80 source (`src/segacd/main/mainz80.z80`, MAIN.BIN `$5E0C`-`$765B`, copied to Z80 `$0000`).
  5. Clean-up done: STARTER's inline parameter blocks are data (the code after them decodes again); the system
     program has no `X_` addresses left, and STARTER's copy of the SDK film code has the same names (STARTER =
     system program + `$83E2`); the older STARTER fragments use the tag names instead of `X_` addresses.
  4. The boot area (from a disc image: `tools/segacd_bootarea.py`, optional `cdbin/BOOT.BIN`): the header, Sega's
     security block (incbin), the initial program and the system program are in `src/segacd/boot/` and match.
     The system program (sub CPU `$6000`) loads MAIN.BIN, GTABLE.BIN and STARTER.BIN and provides the `$6044`
     services, all named (`docs/segacd_boot.md`). Its PCM driver is STARTER's with command 9 added (a stream
     from sub CPU memory, which the scouting report uses to read its script aloud), and TimerInterrupt is what runs
     the driver. Its tables, the sound record, key map and envelope formats, and FilmSwitch's open arguments (the
     film window's layout, which the main CPU's frame routine uses) are in that doc. `tools/segacd_port.py` takes
     `--code` / `--data` ranges for CD-only code (used for the PCM pitch table in `sp.asm` and STARTER's `subdrv.asm`).
     The sound path end to end: MAIN.BIN's sound bank (48 sequences = the cartridge's SFX numbers, 31 FM
     instruments) runs eight streams as MIDI ports; controller 18 sends a channel to the sub CPU PCM driver,
     which plays HOCKEY.BIN's 13 sound records (GamePcmSounds) from resource 96's 13 samples: the whistle,
     passes, shots, checks, hits, the crowd, the glass (`docs/segacd_main_shell.md` "The sound engine").
     Sound operation 4 plays a DAC sample through the Z80, but in this build it never sounds: the 68000 polls the
     Z80's request byte at `$0072`, the Z80 program keeps it at `$0092`, no DAC samples are registered, and
     nothing sends command `$23` (`docs/segacd_main_shell.md`). 54 of the disc's films are in no PLAYER list and verified unreferenced (no other film sector table in any file, every `$6044` call has a constant service number, only PLAYER's is service 7).
- Open questions:
  - Answered: the team struct is one word longer from `tmap` on because `tmsort` is a long on the disc (the sort
    objects are in sub CPU RAM above `$FFFF`): each cartridge `movea.w tmsort(aN)` is `movea.l $22(aN)`.
  - Answered: `STARTER.BIN` runs at `$B000` (the whole file), not `$21300`; its tail jumps to `$B00E`, which loads
    HOCKEY.BIN at `$1B000` over STARTER's top part. The STARTER fragments were written again at that base.

## Baseline log
- 2026-11-10 (McMarkis session, Windows 11, Node 22): fresh fork, `segacd-disc/*.BIN` copied to `cdbin/` (sizes as in GETTING_FILES.md).
  `npm run build:segacd`: MATCH 41 fragments. `tools/verify_all.sh -q` (with the retail ROM in the repo folder): ALL MATCH.

## Coverage (`tools/segacd_check.sh`, 2026-11-10)
| File | Size | Matched | Notes |
|---|---|---|---|
| MAIN.BIN | 60,416 | 60,416 (100%) | the older fragments, the second copies, the rest in `src/segacd/main/` (Z80 program as asm80 source) |
| STARTER.BIN | 120,248 | 120,248 (100%) | the older fragments and `src/segacd/starter/` (five screens, the function 5 block, credits text incbin) |
| HOCKEY.BIN | 184,842 | 184,842 (100%) | 94G twins (some in parts), team data, CD-only pads and pointer table, the older fragments; 43,120 bytes incbin |
| PLAYER.BIN | 44,656 | 44,656 (100%) | the older fragments and `src/segacd/player/` (pictures incbin) |
| GRAPH2.BIN | 3,051,520 | 3,051,520 (100%) | 99 resources; pack tables, end marks and fill in source, graphics incbin |
| GTABLE.BIN | 2,048 | 2,048 (100%) | the 99 index entries in source (`GRes size`) |
| Total code | 410,162 | 410,162 (100%) | was 22,690 (5.5%) at the start of the session |
| BOOT.BIN (boot area) | 32,768 | 32,768 (100%) | optional: `tools/segacd_bootarea.py` from a disc image; header and both programs in source, Sega's security block incbin |

## Parked units
(none)
