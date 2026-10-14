# HANDOFF: comment and name cleanup (NHL94)

## Purpose
Make this bit-perfect 68000 SNASM disassembly read like clean original source: accurate names that follow the
NHL92 Genesis (EA original) lineage, and comments without disassembler or porting artifacts. Code, data and
bytes never change: every build must still MATCH the retail ROM.

## Setup
ROMs (gitignored, never commit): lst/nhl94.bin.
Windows: `npm run build:retail` (tools/prebuild.js, build94.bat, fixopcodes, verify);
segments: `npm run seg:<name>` (all keys in package.json `seg:*`).
Linux (wine): `apt install wine wine32` (dpkg --add-architecture i386), `export WINEDEBUG=-all`, then
1. `node tools/prebuild.js retail` (checks the ROM, extracts into Extracted/ if missing or incomplete; same as `node tools/extractAssets94.js lst/nhl94.bin`), then `export NHL_PREBUILD_DONE=1` so the .bat files skip their own pre-step (no node under wine). Accepts the one retail ROM (SHA-1 7b1489ab...); other ROMs are refused.
2. `wine cmd /c "set rev=0&& set checksum=1&& build94.bat"`
3. `node tools/fixopcodes.js "output/nhl94 .lst" output/nhl94.bin`
4. `node tools/verifyRom.js output/modified_nhl94.bin <reference ROM>` must print MATCH
5. Segments: run each package.json `seg:*` chain the same way (`wine cmd /c "buildseg.bat <seg>"`, then its node steps); tools/verifySegment.js must MATCH.
Failed-assembly detection: delete output/*.bin first, then check the bin exists and is fresh and that output/Build*.log has no
`^[1-9][0-9]* error` line. tools/verify_all.sh does all of this (top ROM + every segment).

## Naming lineage
- 92G (abdulahmad/NHL92Genesis, EA source) is the root. 93 -> 92; 94 -> 93 -> 92; 95 -> 94 -> 93 -> 92.
- Use the earliest game's name for the same routine/variable. 92 names are kept as-is, typos included.
- A name not from 92 that is inaccurate (checked against the routine body / usage) gets fixed, and the fix is propagated
  forward: 93 -> 94 -> 95, and to abdulahmad/NHLPA93SNES for 93 names that exist there.
- Clash rule: never reuse a name already used for a different item; pick a descriptive name instead.
- Teams: 93 (unlicensed) uses city names only; 94/95 use NYIslanders/NYRangers (NYI/NYR) style names.

## Comment rules
No other games' names or "X name" notes, no source-file/segment names, no IDA references (IDA, loc_, sub_, unk_),
no "(was: X)" history, no hardcoded ROM addresses (keep VRAM/RAM values, include address maps, RAM equate address
comments), no "only in 9x" tags ("New in 94/95:" allowed in file/section headers). Keep real explanations and
value-difference notes like "(94 $58)" / "92 used bit 6". Every routine has a header comment. Concise.

## Records
- docs/name_map.csv: every rename (old -> new, source/reason). History lives here, not in comments.
- docs/name_review_9x.md: name-accuracy checklist (name, verdict) per module.

## Conventions
Small commits per module; builds MATCH before every push; `git pull --rebase origin main` then push to main.
No force-push, no PRs, never commit ROMs, Extracted/ or output/.

## Local label style
Follow 92G (EA source): ~31% of its locals are number-only (.0, .1 ...), the rest short lowercase words
(.loop, .next, .top, .done, .ex/.exit, .ok, .wait, .skip, plus abbreviations like .nna, .nodec, .sr).
- Give a word where the branch has a clear meaning (loop top, next item, skip/no-X case, exit, wait).
- Keep plain numbers for trivial jumps and for locals inherited from a matching parent routine.
- A routine that matches a parent routine (92 or 93) uses the parent's local names.
- Data tables indexed by number (frames, team data) stay numeric, as in 92.
- Renames are scope-aware (routine scope, code part only, never comments); diff-review every commit.
  Tools on the box: /workspace/tools_ll/ll.py (rename/list), prop.py (copy parent local names).

## Season mode port

Branch `feature/season-mode`. Retail stays `SEASON=0` and must MATCH. `npm run build:season` (or `set season=1&& set checksum=0&& build94.bat`) builds the 2 MB season image with `CHECKSUM=0`. Segment builds pass `SEASON=0`.

- Chunk 1: the flag, the season header ROM end, and the fill to 2 MB. No season code yet. Retail verify_all MATCH.
- Chunk 2: season work-RAM names at `$FFFFDEF4`, menu scratch over the replay buffer, and the save-RAM offset names. Equates only. Retail verify_all MATCH.
- Chunk 3: `schedule94.asm` at the start of the second megabyte, `Day` macro, no caller. Season image is 2 MB. Retail verify_all MATCH.
- Chunk 4: season save window is `$8000` bytes, checksum at `$7FFE`, header backup end `$0020FFFF`. A retail checksum keeps the records and moves the line block to `SRLineData`. Retail verify_all MATCH. The season image is not compared to the retail ROM.
- Chunk 5: seven play mode lines after Shootout. Start on those lines sets the mode flags and returns to the menu. Continue Season is skipped until a header is stored. New playoffs are still modes 2 and 3. Retail verify_all MATCH.
- Chunk 6: Create Player in the second megabyte. Start on that line opens the screen. The create name is `CreateNameBuf`; the record-holders buffer keeps its name. Retail verify_all MATCH.
- Chunk 7: Sign Free Agents and Release Players open from the menu.
- Chunk 8: Trade Players opens from the menu. Clearing the battery rebuilds the default rosters and lines and drops created players. Retail verify_all MATCH.
- Chunk 9: Game With Trades starts an exhibition with the menu clubs and the saved roster. `sflags11` bit 6 stays clear, so lines, names, jersey numbers, and roster counts come from the battery. Regular Season, password playoffs, and Shootout still set the bit and use team data. `GetJerseyNumber` stores the battery jersey in `jerseynum` (95 aliased that byte with the create buffer). Retail verify_all MATCH. Season image is 2 MB, ROM end `$001FFFFF`, SRAM end `$0020FFFF`.
- Chunk 10: New Season opens SEASON SETUP from `SeasonMain` before the menu is drawn again. Start writes the 8 byte header, clears results and player stats, and leaves rosters and created players. Continue Season appears once `SeasonLength` or the saved header byte is nonzero. Retail verify_all MATCH.
- Chunk 11: Continue Season and a stored New Season enter the day loop. Games Today lists the day. A toggles Human and Computer on an unplayed game. Left and right change the day. Play Games with every game on Computer simulates the scores, writes them, and advances the date. Play Until A Day can be cancelled and the day stays put. Standings, the calendar, stats, and highlights stay on the menu until their screens exist. The playoff, cup, and award exits return to the title. Retail verify_all MATCH. Season image is 2 MB, ROM end `$001FFFFF`, SRAM end `$0020FFFF`.
- Chunk 12: One game set to Human skips the play mode menu. The clubs, period, penalties, and line changes come from the season. `sflags11` bit 6 stays clear, so the saved roster is on the ice. The game ends back in the day loop with that score stored. Player goals, assists, shots, penalty minutes, and games played are written from the team struct at `$B4`, `$CE`, `$E8`, `$102`, and `$136`. Regular Season still sets bit 6. Retail verify_all MATCH.
- Chunk 13: NHL Standings and the team schedule calendar are on the season menu. Standings cycle the four division groups. The calendar shows each month's games with opponent and result. `CountTeamGames` feeds games remaining on the standings lines. Retail verify_all MATCH.
- Chunk 14: Player Stats, Team Stats, and League Leaders are on the season menu. Playoff menu lines set `sflags11` bit 3 for the playoff stat blocks. Leader tables use `LeaderTeamTbls` and `TeamLeaderValues` over `picturebuf` while that screen is up. Retail verify_all MATCH.
- Chunk 15: Merged `main` (mod-safe ROM: `RomEnd` auto pad, `absjsr` / `absjmp`, `patchchecksum.js`, `LONGBRA` retry, `NumTeams` / `NumPlayoffTeams` in option limits). Season build keeps a forced 2 MB `RomSize` after the second-meg includes. Retail verify_all MATCH.
- Chunk 16: Controller setup (`controller94.asm`, 95 `SetContTeams` screen) runs from `Opening2` after `GameSetUp` and before `UserNameEntry`. Pad graphics are extracted from the 95 ROM (`ControllerTitleMap`, `PadCursorMap`, `PadIconMap1` through `4`). Human season games no longer force `OptNOP` to One - Home; pads are chosen on the controller screen. Practice Mode helpers are stubbed. Retail verify_all MATCH. Season image is 2 MB.
- Chunk 17: Playoffs (`playoff94.asm` from 95 `awards95.asm`): `InitPlayoffs`, `SetupPlayoffs`, `NextPlayoffRound`, `BuildPlayoffDayGames`, `RecordPlayoffGame`, `PlayoffTreeScreen` calling `PlayoffScreen`. `SeasonMain` runs init and setup at `.playoffs` and stays in the day loop. `NextSeasonDay` advances playoff days and rounds. End-of-regular-season menu leads through standings into playoffs. Playoff Tree menu item opens the tree. Retail verify_all MATCH.
- Chunk 18: Stanley Cup (`cup94.asm` from 95 `title95.asm`) with `SngEOG`. `hockey94` sets `sflags13` bit 2 and `cupwinner` on the season final when `GameFlags` bit 3 is set. `GameOver` and `SeasonMain` `.over` can show the cup when `SimFlags` bit 0 is set. `awards94.asm` ports `SeasonAwards` and the nine scans; graphics come from the 95 ROM via `extractSeasonAssets.js`. `SeasonMain` `.awards` runs awards then returns to the title through `Opening2`. Retail verify_all MATCH. Season image is 2 MB.
- Chunk 19: Multi-game injuries (`injury94.asm` from 95 `injury95.asm`) and highlights (`highlights94.asm` from 95 `stats95.asm`). `setInjuryType` calls `SeasonMultiGameInjury` when `GameFlags` bit 3 and `SeasonFlags` bit 2 (multi-game injuries on setup) apply. `restoreteams` calls `SetSeasonInjuries`; `CheckInjury` jumps to `SeasonShowInjury` for the n-games message. Trades use `SetInjuryGames`, `GetInjuryGames`, `InsertInjurySlot`, and `DeleteInjurySlot`. `SaveSimGame` saves highlights and ticks injuries. The Highlights menu opens `HighlightsScreen`; `HighlightsBgMap` is in `extractSeasonAssets.js`. The collide hook stays a short `jsr` so retail `bra.w Begin` still reaches. Retail verify_all MATCH. Season image is 2 MB.
- Chunk 20: Full-pass documentation. `docs/SEASON_SMOKE.md` lists the end-to-end emulator checklist (create → trade → season → sim/human day → stats/highlights/injuries → playoffs → cup). Retail `tools/verify_all.sh` MATCH again on this branch. `simgame94.asm` ports `SimGameStats` and helpers from 95 so simulated days call `SaveSimGame` with filled team structs. Season 2 MB image not hardware-verified here.
- **Season port status (chunks 1–20):** Feature-complete for the planned menu flow; use `SEASON_SMOKE.md` for manual QA. Integration edge cases (injuries vs roster OUT, line save-back, scouting, etc.) are listed in `docs/season_mode_port_plan.md` section 10.
- **Season integration (chunks 15–20 follow-up):** `SeasonPlayerOut` honors `GetInjuryGames`; season `GameOver` skips password playoff UI; `SetupPlayoffs` clear sizes use season save equates; Create Player menu gated at 20 slots. `SaveTeamLines`, `SeasonAttribAdjust`, scouting hot/cold skip, and type-4 highlight stub cover port-plan E2–E5/E8. See `SEASON_SMOKE.md` and section 10 of `season_mode_port_plan.md`.

## Current state / Next
- Mod-safe build (branch feature/mod-safe-build): `absjsr` / `absjmp` in src/macros/genesis.mac pick jsr/jmp (target).w below $8000 and .l otherwise. The 12 retail short calls (StartGame, StartPer, ResetClock, GetPeriodTime twice, restoreteams, DoGameFrame, updatecrowdf, SetupPauseScreen, InitMenuState, DrawMenuScreen, HandleMenuInput) use them. A target that is not defined yet cannot be sized (SNASM: "Expression must evaluate"); write jsr/jmp (name).l for a forward call. buildseg.bat no longer uses `cd ... || exit`, which made wine skip the assemble. Full ROM and every segment MATCH.
- Team list pointers: the zero long before TeamList is `NoTiles`. Every `#$30A` / `#$30E` load is `movea` `#NoTiles` or `#TeamList` (word or long, same encoding). A scan of other immediates against the symbol file found no further ROM pointers (the matches were speeds, VDP writes and sound data). Segment stubs that assemble those files alone equate `NoTiles` and `TeamList`. Full ROM and every segment MATCH.
- Auto-size: nhl94.asm pads with $FF to the next of 1MB, 1.5MB, 2MB or 4MB and sets `RomEnd`. The header ROM end is `RomEnd` (forward equate; the binary is filled, the listing may show zeros). Content past backup RAM warns (`inform 1`) and still builds; past 4MB stops the assemble. main94's segment stub sets `RomEnd` to the stock end so that segment stays a match. Stock ROM is still 1MB. Full ROM and every segment MATCH.
- Checksum: tools/patchchecksum.js runs after fixopcodes on the ROM the game boots. It sums every long below ValidationRoutine, skips the header long, and writes that sum over the compare immediate. The source keeps the retail immediate, so the checksum segment is not patched. Stock sum is unchanged. tools/verify_all.sh prints ALL MATCH and exits 0 when every target matches.
- Startup branch: `bra.w Begin` stays while Begin is in range (LONGBRA=0, passed by build94.bat and buildseg.bat). If the assemble reports that the branch is out of range, build94.bat runs again with LONGBRA=1 and a long jump. A 4KB block inserted before the game loop assembles with 0 errors, pads to 1.5MB, header end one byte below that, and the patched checksum matches an independent sum. The insert is not in the tree.
- Teams: `NumTeams` (all-stars included) and `NumPlayoffTeams` (the first all-star number) are in equals.inc. Option limits, the random team range, the new-playoff team range and the playoff clamp come from them. Each per-team table checks its length at assemble time. playoffseats stays 32 rows of 16 team numbers. Crowd records are `NumTeams` blocks at CrowdRecBase. The stock league ends on the records block, so TeamRecBase and NameLogBase stay put. A larger league starts the records block after the crowd records and the name log after that block. Line data stays where it is, and the build stops if the name log would run into it. TeamRatings is aligned after its length check; the stock table adds no pad byte. The playoff draw keeps used teams in one register, so it stops working past 32 playoff teams. prebuild writes output/teamcounts.inc from the two team-block maps. A throwaway 29th team that reused an existing record, home against Los Angeles, passed the boot check and reached the ice with the clock running. The extra team was not kept. Full ROM and every segment MATCH.
- The 1MB fill happens before the size pad. An include after that fill starts at the 1MB boundary; the size pad then grows the ROM. Stock is still 1MB. docs/ADDING_A_TEAM.md, START_HERE.md and the Current rules in SEGMENT_AGENT.md describe the macros and this build.
- Dynamic save RAM (docs/PLAN_DYNAMIC_SAVE_SRAM.md): SaveRamBase, SaveMirrorBytes, checksum byte equates and refactored sram94.asm (stock MATCH). SRAMTOGGLE=0 by default; build94.bat re-assembles with SRAMTOGGLE=1 when the log reports ROM overlap with backup RAM. ReadSRAM/WriteSRAM and factory-test chip paths use $A130F1 only in that build.

- Comment review: done in 93, 94, 95 and NHLPA93SNES.
- Name pass (full body read), records in docs/name_review_93.md / _94.md / _95.md:
  - Phase A (93): DONE, all modules. Renames propagated to 94/95/NHLPA93SNES.
  - Phase B (94): DONE (all src modules, RAM names, equates; docs/name_review_94.md).
  - Phase C (95): DONE (all modules, ram95, graphics95, frames95, sound95; docs/name_review_95.md).
- Local label pass (locals + header register notes; checklist "Local labels" in docs/name_review_94.md):
  all 94 modules done (later modules by branch-structure review); 93->94 local name consistency check done
  (tools_ll/consist.py). Next: 95G (MISMATCH routines from
  prop.py, then new-in-95 routines, then data labels/equates).
- Header rewrite (file header comments, 92 style): 94G nhl94, main, teamdata, frames, ram, macros, sega, stubinc, hockey, menu, stats, replay, input, assign, checks, video, penalty, collide, display, setup, all modules and stubs done (94G complete).
- Restructure: root .js tools (extractAssets94, fixopcodes, verifyRom, verifySegment, sync) moved to tools/; run from repo root as node tools/<name>.js (default Extracted/output paths resolve from the repo root). Fresh extract + ROM + all segments MATCH.
- Header rewrite 2 (story-style file headers, model 93G hockey93/main93/menu93): all 94G modules done. MATCH.
- Boundary moves (Task D, routine names/headers only): check4bench input94 -> assign94 (bench assignment);
  UnpackNibbles + WeightedRandomSelect checks94 -> video94 (shared helpers); ResetCardTimer, PlayerCardTimer,
  PlayerCardScreen optsetup94 -> cards94 (player cards); the name entry block NameEntryScreen ... WriteNameRecord
  cards94 -> records94 (user name entry); ShootoutModeBox records94 -> shootout94. Stub orgs/equates,
  package.json, nhl94.asm and the ROM map updated. MATCH.
- Segment stubs moved to src/stubinc/ (buildseg.bat assembles stubinc\<seg>_stub.asm). MATCH.
- Extractor takes any known retail ROM: SHA-1 detection (one retail version, 1993.JUL -00), per-version offset map, clear refusal of unknown ROMs. verify_all.sh extracts fresh first. Fresh extract + ROM + all segments MATCH.
- Build pre-step: every entry point (npm build:*/seg:* scripts and the .bat files) runs tools/prebuild.js first. It checks the ROM (path, SHA-1, size; stops with a message naming the exact file and version if it is missing or wrong, ROMs are not in the repo) and re-runs the extractor when Extracted/ is missing or incomplete. The extractor writes Extracted/.extract-complete.json last (ROM SHA-1, extractor SHA-1, every file and size). npm scripts set NHL_PREBUILD_DONE=1 so the .bat does not repeat it; verify_all.sh runs it with Linux node. Tested with Windows npm/cmd under wine: fresh build auto-extracts and MATCHes; missing ROM stops with the message. MATCH.
- Animation symbols: raw animation offsets and sprite-frame indices use frames94 names. Listing-confirmed new equates, after SPFbglass: SPFslamtop = 708 ($2C4), SPFslambot = 712 ($2C8), SPFghighr = 658 ($292). The slam hold frame is +1. frames94: 32 words in SPAgslamtop / SPAgslambot (708, 709, 712, 713 only) are SPFslamtop, SPFslamtop+1, SPFslambot, SPFslambot+1. Header: SPFghighr is frame 658 and frames after it have no name. Full ROM and frames94 MATCH.
- checks94: 42 immediates (expected 40; both extra sites are real SetSPA / frame writes). 4 slam frame compares, 2 slam animation loads, 3 SPAgready SetSPA loads (checkanim, goalieacc .setready, goalieacc .normalgoalie), SPAgdive, the SPAgglovel compare, SPAgglovel2, the 10-word .saveanim table, 3 SPFpuck (penalty-shot shadow, faceoff shadow, puckshadow compare), 5 SPAglide, SPApflip, 2 SPAglideback, 2 eori.w #SPAturnl-SPAturnr, addi.w #SPAturnr, SPAgskate, SPAskateback, SPAskate, SPAstumble, SPAskatewp, SPAstop. move.w #SPAgready,d1 encodes 323C 0002. Left numeric: doplayeracc cmp.w #$180,d4 and move.w #$180,d4 (speed clamp, same as 93), cmp.w #-50,d1 (Y difference; 93 writes #-50, the same word as #$FFCE), and move.w #2,d1 that is a team number next to checkcont1. The SPAstumble load is the 93 note on pflags2 bit 6. Stub equates are numeric copies of the frames94 values. Full ROM and checks94 MATCH.
- collide94: 61 immediates. SPA compares (SPAHold twice, SPAhook, SPAsweepchk, SPAburst, SPAHold2, SPAinjuryfall, SPAinjury1, SPAstumble, SPAfallfwd, SPAfallback twice, SPAflip, SPAgstackr/SPAgstackl twice each, SPAgdive twice), the 8-word checkinglist, SetSPA loads (SPAflail, SPAHold2, SPAhook2, SPAstumble, SPAcrosscheck, SPAbenchcheckl twice, SPAbenchcheckr twice, SPAboardright, SPAboardleft, SPAfallback, SPAfallfwd, SPAflip, SPAinjuryfall, SPAinjury1, SPAsiren, SPAbglass, SPAcatch), four FallDown compares of the animation in d1, the 8-word .FallList, and the frame writes #SPFGoalie, #SPFSiren, #SPFghighr. SPAsiren keeps "92 used $FE8". Full ROM and collide94 MATCH.
- input94: 26 immediates (16 instructions plus the 10-word unreferenced save table). SPAgdive, the 10 save offsets, SPAfaceoff, SPAfaceoffr, SPAburst, SPAhook twice, SPAHold, SPAgswing, SPApassf, SPApassb, SPAsweepchk, SPAshotf, SPAshotb twice, SPAgstackr, SPAgstackl. Acheck header is "start SPAhook, or SPAHold if a0 is ahead". Full ROM and input94 MATCH.
- assign94: 12 SetSPA loads (the expected 13th is not in the file; 93 has the same 12). SPAglide twice, SPAgready when position is the goalie (323C 0002), SPAwallleft twice, SPAwallright twice, SPAfaceoff, SPAfaceoffr, SPAstanley, SPAcelebrate, SPApump. move.w #2,facedir(a3) stays a facing, and assfight / assfwatch are rts. Full ROM and assign94 MATCH.
- replay94: 13 immediates (expected 11, plus the old-fight frame bounds). Six board SPA compares, SPAinjuryfall, SPAinjury1, #SPFpuck on the puck shadow, #SPFbglass and #SPFbglass+5 (glass shatter range; same number as SPFghighr, written as the end of the glass frames), #SPFfight and #SPFPen (old fight frames, $162 through just before $179). Left numeric: cmp.w #$34E,d2 (last frame +1) and the yleader #$FFCE scroll clamp. Full ROM and replay94 MATCH.
- title94: 7 immediates. Six board SPA compares and EndOneTimer #SPAglide. PlaceBoardFall names those animations and SPA(a3); the continuation line keeps its leading semicolon. Logo and position dc.w 2 / dc.w 1 and DispAttribCtr #$FFCE stay numeric. Full ROM and title94 MATCH.
- display94: 2 immediates, #SPFarrow and #SPFarrow+3. Left numeric: showcrowd moveq #$1A, moveq #$1D, addi.w #$1F; showzam moveq #1, addq.w #2 and .ftab 5,6,7,8...; pads 3/4 arrow frames #$346 and #$349 (after SPFghighr, no name). Full ROM and display94 MATCH.
- setup94: 10 immediates (expected 6, plus four .list frame fields copied from 92/93). .listffo: SPFpad+2 (puck poss. star), SPFpad (joypad 1 star), SPFpad+1 (joypad 2 star), SPFreplay (replay cursor), SPFgloves. resetplstuff SetSPA load is #SPAglide. .list frames: SPFgoal, SPFgoal+1, SPFpuck+1, SPFpuck. Left numeric: .listffo $34C and $34D, the player frame 1s (92 and 93 wrote 1), and .list $180 (an X coordinate). Full ROM and setup94 MATCH.
- onetimer94: 2 immediates, #SPAshotf and #SPAshotb. setonetimeranim says d1 is SPAshotf or SPAshotb. The $FFCE words in OneTimerGoalieTbl are target offsets, not the turn expression. Full ROM and onetimer94 MATCH.
- Unsure (left numeric): checks94 doplayeracc cmp.w #$180,d4 and move.w #$180,d4 (speed clamp); checks94 cmp.w #-50,d1 (Y difference; 93 writes #-50. The turn expression is only eori.w #SPAturnl-SPAturnr, and addi.w #SPAturnr); display94 showcrowd moveq #$1A, moveq #$1D, addi.w #$1F; display94 showzam moveq #1, addq.w #2, and .ftab dc.w 5,6,7,8...; setup94 .listffo dc.w $34C and $34D; replay94 cmp.w #$34E. Counts: frames94 32 words, checks94 42, collide94 61, input94 26, assign94 12, replay94 13, title94 7, display94 2, setup94 10, onetimer94 2.
- 93 alignment: every shared site uses the 93 symbol (SPAglide, SPAgready, SPAturnl-SPAturnr, SPFpad+2 / SPFpad / SPFpad+1 / SPFreplay / SPFgloves, SPFgoal / SPFgoal+1 / SPFpuck+1 / SPFpuck, SPFarrow / SPFarrow+3, SPFGoalie, the save and check lists). 93 notes restored on those instructions: SPAhook "this anim also holds", SPAsweepchk "this anim goes to Bcheck", SPAhook2 "holding anim after SPAhook", SPAflip "third fall anim", SPAfallback "injury: only from a fall back", SPAcatch "on a2", SPFarrow "frame numbers are 6 higher than 92", SPAglide "92 $346", SPFgoal "92 used $18E", SPFpuck "92 used $183, 4 chars". Acheck stays "start SPAhook, or SPAHold if a0 is ahead" (93's header names them the other way around; the load is SPAhook, then SPAHold). New in 94, so no 93 name: SPFslamtop, SPFslambot, SPFghighr, the board animations, the extra save anims, and the glass range written SPFbglass+5 (93's glass frames run SPFbglass through SPFbglass+4).
