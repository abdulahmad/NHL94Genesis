# Feature and patch branches

`main` is a faithful disassembly: a stock build matches `nhl94retail.bin` byte for byte (`docs/EXPANDING_THE_ROM.md`). Anything that changes the ROM lives on its own branch, branched from `main`, one topic per branch. Each branch below builds a separate mod ROM; `npm run build:retail` on `main` is unaffected. Branches are not merged into `main` because they change the ROM.

Everything here comes from the branches' own docs and commit history as of 2026-10-28. Nothing was built or run to write this page. If a branch and this page disagree, the branch wins.

| Branch | What it adds | Build | Output | Status |
| --- | --- | --- | --- | --- |
| [`feature/season-mode`](#featureseason-mode) | Season mode ported from NHL 95 Genesis | `npm run build:season` | 2 MB ROM | In progress, current with `main` through RosterSlots |
| [`feature/msu-md-music`](#featuremsu-md-music) | Sega CD audio through MSU-MD | `npm run build:msu` | 2 MB ROM | Working on its own; older build scripts, needs a rebase |
| [`patch/perf-stats`](#patchperf-stats) | On-screen performance overlay | `npm run build:perf` | `output/nhl94-perf.bin` | Active, latest work 2026-10-28 |
| [`patch/teamblock-vram`](#patchteamblock-vram) | Team banner tiles loaded per team instead of whole set | normal build | Mod ROM, about 1.5 MB | Done, for adding teams |

Every mod ROM needs the retail ROM in the repo folder and the usual prebuild (README, "Build pre-step"). Mod builds turn checksum validation off, like `build:dev`, so they boot but never match retail.

## feature/season-mode

Ports 95G's season mode into 94G: New Season and Continue Season, a saved campaign in battery RAM, schedule (192 days, October 5 to April 14), standings, playoffs, awards, and the Trade Players, Create Player, Sign Free Agents, Release Players and Game With Trades lines. It sits behind `SEASON=1`. Practice Mode is out of scope. 94's "Regular Season" menu line is one exhibition game, so the schedule and saved season are new.

- **Docs on the branch:** `docs/season_mode_port_plan.md` (the plan and closed decisions), `docs/SEASON_SMOKE.md` (build and emulator checklist), `docs/SEASON_LARGE_LEAGUE.md` (more than 28 teams, 32+ playoff teams), `docs/PLAN_DYNAMIC_SAVE_SRAM.md`, `docs/ADDING_A_TEAM.md`.
- **Build:** `npm run build:season`. Assets from NHL 95 are needed: `tools/extractSeasonAssets.js` reads an NHL 95 Genesis ROM (`NHL95_ROM`, or `lst/nhl95.bin` in a clone of NHL95Genesis). Expect `output/nhl94.bin` at 2 MB, header ROM end `$1FFFFF`, checksum word `$0000`. `SEASON_SMOKE.md` has the Linux and Wine steps.
- **Retail check:** `tools/verify_all.sh` must still print ALL MATCH on this branch. The season image itself is not expected to match retail.
- **Notes:** the season save map is computed (`src/stubinc/season_save_layout.inc`, `season_work_ram.inc`). An assemble error is raised if the season save would pass `$8000`. Stock 28 teams work; 34 teams (32 playoff plus 2 All-Star) need `EXPANDED_SCHEDULE=1` after the schedule lists every team. `NumTeams` and `NumPlayoffTeams` live in `ram94.asm`.
- **History:** latest commits are the credit notice (#150), a merge of `main` (RosterSlots, byte-identical) and a long jump to `AttribAdjust` that fixed the season build. Other pieces landed from the earlier `season-integration-edge-cases` branch (PR #12).
- **Status:** in progress. The smoke checklist is the test record; read it for what has been confirmed in an emulator.

## feature/msu-md-music

Plays Sega CD audio through [MSU-MD](https://github.com/krikzz/msu-md) on a cartridge ROM, in menus and in the game, in place of the FM songs. Formerly `cursor/msu-md-music-64b6` (PR #10, then #173, both closed; the branch was renamed). Credit for the MSU-MD driver (`src/msu/msu-drv.bin`, MIT) goes to krikzz.

- **Docs on the branch:** `docs/msu.md` has the build, the track map and the timing notes.
- **Build:** `npm run build:msu` (`MSU=1`, which also sets `checksum=0`). The ROM is 2 MB with header ROM end `$1FFFFF`. On Linux, `docs/msu.md` runs `build94.bat` under Wine and then `tools/fixopcodes.js`. The output is `output/modified_nhl94.bin`.
- **Use:** the options screen has a **CD Music** line under Line Changes. On plays the disc, Off is the original FM, and the choice lasts for the session. If no Mega CD is found the line stays Off. Point the MegaSD MSU cue at a disc whose track numbers match the Sega CD (track 1 data).
- **Track map:** songs `$30` to `$77` play track `id - $29` (7 to 78) once. Title (`$78`) loops track 4, end of game (`$79`) loops track 5, scouting (`$7A`) loops track 3. Track 2 is the crowd bed; the cartridge PSG crowd keeps running underneath. Sound effects stay on FM.
- **Timing:** organ songs end after the length of the USA redump track (serial T-50015, 79 tracks), one second short, counted in NTSC frames. A different pressing or a 50 Hz machine runs long or short. BlastEm cannot read the CD position from the cartridge, which is why frame counting is used.
- **Status:** works on its own, but the branch still uses the older `build94.bat` and `npm run asm` scripts, not `tools/build.js`, and carries the older tree. It needs a rebase onto current `main` before use or review. `MSU=0` retail assemble was checked to still match. Playback was not run on a MegaSD or in BlastEm after the rename.
- **Tracked in:** `docs/TODO.md` ("Triage branches").

## patch/perf-stats

A performance overlay for finding where a frame goes. Three lines on the window plane across the top of the screen, from 90 game frames into each period (after the faceoff fade). Pause, intermission and the title turn it off.

- **Docs on the branch:** `docs/perf.md` has what each field means and what the overlay itself costs.
- **Build:** `npm run build:perf`, giving `output/nhl94-perf.bin`. The code is `src/perf94.asm`, included after the 1 MB fill so retail addresses below `$100000` do not move. Calls into it are `jsr (label).l`.
- **Fields:** `CPU` (scanline percent), `SL` and `MAX` (scanlines per loop, current and period maximum), `FPS` (loops finished in the last 55 blanks, 45 on PAL), `SP` (sprite words), `DM` (queued DMA), `LAG` (blanks between loop starts), `STK` (stack depth in words).
- **Cost:** about 45 scanlines a frame on NTSC (17 to 19 percent of a frame). The sample is taken before the text is formatted, so the numbers exclude the overlay. The figures are hand totals from 68000 timings, not measurements.
- **History:** drawing moved from the rink to the window plane, a faceoff freeze was fixed by initialising strings before `printsmall`, digits were fixed to use the `divu` remainder, and the unused `VB` field was removed (#174, merged into this branch).
- **Notes:** the work found the PC-relative branch limit, which is why `docs/EXPANDING_THE_ROM.md` has a "PC-relative branches" section and `tools/assembleHints.js` exists. Those are on `main`. The branch also carries `contrib/expanding-rom-hints/*.patch` for the NHL 95, NHL 96 and NHLPA 93 repos.
- **Status:** active. PR #172 was closed without merging; the branch stays as a mod branch. Not built here by the last PR author, only hand-checked.

## patch/teamblock-vram

Removes the VRAM limit on the number of teams. Retail copies all 501 team-banner tiles to a scratch area in VRAM to show two teams, and that scratch overruns plane B, the sprite table and plane A. It survives only because they are rebuilt, and it caps the game at about 33 to 40 teams.

- **Docs on the branch:** the "Team banner graphics and VRAM" section of `docs/EXPANDING_THE_ROM.md`.
- **Patch A (in game):** `setupTeamBlocksMap` and `CopyTeamBlockMapData` DMA each tile of the two teams straight from ROM into two fixed slots. No scratch. Writes 44 characters instead of 545.
- **Patch B (setup screen):** `tools/packTeamBitmaps.js`, run from `prebuild.js`, packs each team's unique tiles and writes `output/teambitmaps_packed.inc`. `DrawMatchupBitmaps` loads only the home and visitor tiles on each team change. VRAM use drops from 796 characters to 44. Costs about 35 KB of ROM for 28 teams, so the image grows to about 1.5 MB.
- **Check:** `node tools/testTeamBlockVram.js` rebuilds each team's pixels from the packed data and compares them to retail.
- **Use:** merge or cherry-pick onto a mod branch, then add teams to both `.map.jim` files (two rows of 11 tiles per team) and rebuild. It is not for `main` because it changes the ROM.
- **Status:** done as of 2026-10-14. Also carries the build-output work that later went to `main` (spinner, `npm run clean`).

## Working with these branches

- Branch from `main`, one topic per branch (`CONTRIBUTING.md`). Name them `feature/...` for new game features and `patch/...` for fixes that a mod needs.
- Merge `main` in regularly. `feature/season-mode` and `patch/teamblock-vram` last synced to `main` on 2026-10-14. `feature/msu-md-music` has not.
- Anything built from these branches is a derivative work. Credit applies as in the README, "Credits and derivative works", and the branches add the same notice (#150, #151, #152).
- The three ROM-size changes stack: season mode and MSU need 2 MB; the team-block patch needs about 1.5 MB. Combining branches has not been tried.
