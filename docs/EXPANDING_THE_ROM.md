# Expanding the ROM

`main` is a faithful disassembly of the retail cartridge: a stock build matches `lst/nhl94.bin`. It keeps only changes that emit the same bytes (equates, labels, assemble-time checks, build tools). Fixes that a bigger ROM or a bigger league needs are described here and belong on a mod branch, not on `main`.

## What main already does for you

- `tools/fixrom.js` runs after `fixopcodes`. It pads the image with $FF to the next size of 1MB, 1.5MB, 2MB or 4MB, writes the header ROM end ($1A4), then writes the boot checksum (the `cmpi.l` immediate in `ValidationRoutine`). A stock build stays 1MB and byte-identical.
- `src/nhl94.asm` fills to 1MB. Includes placed after that fill start at $100000, so new data does not move any retail code.
- `src/shortcalls.inc` (included last, emits nothing) stops the build if a routine the retail code calls with a short `jsr`/`jmp (x).w` moves past $7FFF. `tools/build.js` then stops at the assemble step and prints the routine, the files that call it, and the fix below.
- `NumTeams` / `NumPlayoffTeams` (`src/stubinc/equals.inc`) drive the option limits, the random team range and the playoff clamp, and every per-team table checks its length while assembling.
- `CHECKSUM=0` skips the boot check (`build:dev`); `REV` picks retail or Rev A.

## Short jumps

The retail code reaches eleven routines with absolute short calls, which only reach $0000-$7FFF: `StartGame`, `restoreteams`, `ResetClock`, `GetPeriodTime` (twice), `StartPer`, `DoGameFrame`, `updatecrowdf`, `SetupPauseScreen`, `InitMenuState`, `DrawMenuScreen` and `HandleMenuInput` (callers in setup94, penalty94, collide94, data94 and video94). `menu94` ends just below $8000, so about 375 bytes of growth in the files before it is enough to break them. `bra.w Begin` in `main94.asm` has the same kind of limit.

Fix, in order of preference:

1. Put new data after `menu94`, ideally after the 1MB fill in `src/nhl94.asm`. Nothing below $8000 moves.
2. If something below $8000 has to grow (for example `TeamList` or a team record in `teamdata94.asm`), change the affected calls to `jsr (name).l` / `jmp (name).l` on your mod branch (2 more bytes each), and `bra.w Begin` to `jmp (Begin).l` if it is out of range.

## Past 2MB: backup RAM and bank switching

The save chip sits at $200001-$203FFF (odd bytes). A ROM up to 2MB ends at $1FFFFF and needs no mapper. Anything larger overlaps the save chip:

- The game reads and writes save RAM directly at $200000 (`sram94.asm`). With ROM there, the console reads ROM instead of the chip. A cartridge (or emulator) with the Sega mapper exposes the chip only while bit 0 of $A130F1 is set, so every save access needs `move.b #1,($A130F1).l` before it and `clr.b ($A130F1).l` after it (`ReadSRAM`, `WriteSRAM`, and the two InitSaveRAM test loops). That is a mod-branch change.
- Past 4MB you need SSF2-style bank switching (the bank registers at $A130F3-$A130FF), so the code has to page data in. `tools/fixrom.js` refuses images larger than 4MB.
- Keep data above $200000 out of anything the game reads while save RAM is mapped in.

## Save RAM layout

The save layout is plain equates at the retail addresses (`src/stubinc/equals.inc`): crowd records `CrowdRecBase` ($B60, `NumTeams` blocks of 16 bytes), the records block `TeamRecBase` ($D20, eight 16-byte records), the name log `NameLogBase` ($DA0) and line data `LineDataBase` ($1EF6). The 28 retail teams fill the crowd records exactly up to $D20.

A 29th team overlaps the records block, and the build stops with "The crowd records run into the records block". On a mod branch, move `TeamRecBase` to `CrowdRecEnd` and `NameLogBase` to `TeamRecBase+RecordsBytes` (there is room below $1EF6), and expect old saves to be invalid.

## Team checklist

The stock game has 28 teams in TeamList order. The first 26 (`ANH` through `WPG`) are playoff teams; the two all-star teams stay last (`ASE`, `ASW`). Insert a playoff team before `ASE` and renumber `ASE` and `ASW`. Each table below is checked while assembling; the build stops if its count is not `NumTeams`.

| What | Where | One entry is |
| --- | --- | --- |
| Team number | `src/stubinc/equals.inc` | The next number before `ASE`. Renumber `ASE` and `ASW`. |
| Team record | `TeamList` in `src/teamdata94.asm` | One `dc.l` to a record like `Anaheim`: player list, home and visitor palettes, city and nickname strings, eight lines, scouting bytes and scoring odds. |
| Logo bitmap | `TeamLogoBitmaps` in `src/optsetup94.asm` | One `dc.l` to a logo in `src/graphics94.asm` (`logoANH` and the rest, each an `incbin` of a `.map.jim`). |
| Logo palette | `TeamLogoPalettes` in `src/title94.asm` | 16 colors. Most teams reuse their matchup palette; BOS, FLA, HFD and SJ have their own. |
| Matchup palettes | `TeamPalettes` in `src/cards94.asm` | Two palettes of 16 colors. A is the matchup logo palette. B is A with colors 1-2 and 3-4 swapped. |
| Featured pictures | `FeaturedPictures` in `src/cards94.asm` | One pointer, then that team's list of picture and roster index, ending in 0. |
| Songs | `TeamSongs` in `src/title94.asm` | 6 bytes. 0 picks from `RandomSongs`. |
| Ice logo | `TeamGfxList` in `src/title94.asm` | One address in `ArenaGfxBank`. |
| Rating | `TeamRatings` in `src/period94.asm` | One byte. |
| Team blocks | `Teamblocksmap` (`TeamBlocks.map.jim`) | Two rows, 11 tiles wide, in the shared banner image. |
| Team block bitmaps | `TeamBitmaps` (`TeamBlocks94.map.jim`) | The same shape, the other shared image. |

Those two rows go at the new team's index, and each map grows by 2 rows. The setup banner and the scoreboard name are those tiles; the menu name and the on-ice abbreviation come from the team record. `tools/prebuild.js` measures both images and writes `output/teamcounts.inc`. The image tools (JIM-Tools) are in EA-NHL-Tools.

`NoTiles` is the zero long just before `TeamList` (the pointer for a slot with no tiles). It is not a team entry.

## Playoff rows

`playoffseats` in `src/teamdata94.asm` is 32 rows of 16 team numbers (`PlayoffRows` by `PlayoffRowTeams`), not one entry per team. `NewPO` picks a row at random and finds the menu's team in that row. All-star teams are not seeded: a team number at or past `NumPlayoffTeams` is treated as the last playoff team.

Put the new number into the existing rows. Do not add a row. The build checks that the table is still exactly those 32 rows.

`GetRandomUnusedTeam` keeps the teams it has already drawn as bits in one register. That covers 32 playoff teams. Past that the build stops.

Also check: the save RAM section above (a 29th team needs the records block moved), and the short-jump section if `TeamList` or a team record grows below $8000.

## Build and test

`npm run build:retail` (`node tools/build.js retail`; Windows, or Linux with wine) runs prebuild, assemble, fixopcodes and fixrom, then compares with retail. A mod reaches step 4 (size, header end, checksum) and then reports MISMATCH at step 5, which is expected; `output/nhl94.bin` is the ROM to test. `npm run build:dev` skips the compare and the boot check. Add `--verbose` (`npm run build:retail -- --verbose`) to see the full assembler and tool output under each step.

`npm run clean` deletes `output/` and `Extracted/`. Prebuild only extracts assets that are missing, so after you change a source image or asset (for example the team block images), run clean before building or the build keeps using the stale copy in `Extracted/`.

Boot with `checksum=1`; a red screen means the boot checksum is wrong. `tools/verify_all.sh` is the stock check and prints `ALL MATCH` only when the full ROM and every segment still match retail. A modded ROM will not match, and must not be committed to `main`.

## Team banner graphics and VRAM

**Problem.** Retail loads the whole team banner tile set into VRAM to show two teams:
- In game (`setupTeamBlocksMap`, `setup94.asm`): all 501 `TeamBlocks.map.jim` tiles are copied to a scratch area at `basetileoffset+$2C` (chars 1299-1799, VRAM $A260-$E0FF), then the home and visitor 22 chars are copied VRAM to VRAM to `basetileoffset` / `+$16`. The scratch already runs over plane B ($C000), the SAT ($DC00) and the top of plane A; retail survives because those get rebuilt. Limits: 237 chars before plane B, 621 before the window (char 1920), 717 before HScroll (char 2016), so roughly 33-40 teams before the scratch reaches an area that is not rebuilt.
- Setup screen (`LoadSetupTiles`, `optsetup94.asm`): all 398 `TeamBlocks94.map.jim` tiles are loaded twice (plain at char 2, colour-remapped 1-2<->3-4 at `teambitmapchars`), 796 chars, before the framer and fonts at char 798. Another team adds ~14-22 tiles twice.
- The playoff screen (`AddTeamBlock`) still loads the full set at char 2; it has room up to char 1408 (about 55-60 teams).

**What the patch (branch `patch/teamblock-vram`) changes.**
- A, in game: `setupTeamBlocksMap` / `CopyTeamBlockMapData` read each team's 22 map words and DMA each referenced tile from ROM (`Teamblocksmap+10`, unpacked, 32 bytes) into the two fixed slots, writing map words that keep the flip/palette bits (priority forced as retail). No scratch. Same contract: return `d4 = basetileoffset+$2C`, map words in `TeamBlockMap`. VRAM written: 44 chars instead of 44 + 501; chars 1299-1799 are no longer touched at setup (ExtraChars users still load there). Team count no longer limited by this screen.
- B, setup screen: `tools/packTeamBitmaps.js` (run from `prebuild.js`) packs each team's unique tiles from `TeamBlocks94.map.jim`, plain and pre-remapped, and a copy of the bitmap with each team's map rebased to 0..n-1 (`output/teambitmaps_packed.inc`, included after $100000 by `src/teambitmapvram.asm`, checked against `NumTeams`). `DrawMatchupBitmaps` (the only drawer; runs from `PrintOptions` on every team change) DMAs the home team's tiles to char 2 and the visitor's remapped tiles to `teambitmapchars = 2+TBP_Max` before drawing. `LoadSetupTiles` loads nothing and returns the retail d4 (798), so the framer and fonts stay put. VRAM: 2 x TBP_Max = 44 chars (2-45) instead of 796; chars 46-797 are free. ROM cost: ~35KB for 28 teams (pre-remapped copy doubles the tile data), which pushes the image to 1.5MB.
- `node tools/testTeamBlockVram.js` checks the built ROM: tables, pointers, and that every team's rebased map + tiles reproduce the retail pixels (plain and remapped).

**How to apply.** Merge or cherry-pick `patch/teamblock-vram` onto a mod branch; add teams to both `.map.jim` files as usual (two rows of 11 per team) and rebuild. Not for `main` (it changes the ROM).
