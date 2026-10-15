# Season mode smoke checklist

Branch `feature/season-mode`. Retail verification is `tools/verify_all.sh` (must print **ALL MATCH**). The season image is separate: bit-perfect match to retail is not required.

## Build the season ROM (Linux + Wine)

```bash
node tools/prebuild.js retail
export NHL_PREBUILD_DONE=1
node tools/extractSeasonAssets.js   # needs NHL 95 lst/nhl95.bin (NHL95_ROM or /tmp/NHL95Genesis/lst/nhl95.bin)
mkdir -p extracted && ln -sfn ../Extracted/NHL94 extracted/nhl94
wine cmd /c "set rev=0&& set checksum=0&& set season=1&& build94.bat"
node tools/fixopcodes.js "output/nhl94 .lst" output/nhl94.bin
```

Expect `output/nhl94.bin` at **2 MB** (`$200000`), header ROM end `$1FFFFF`, checksum word `$0000` (`CHECKSUM=0`).

Or: `npm run build:season` on Windows (same steps; Wine path above is what CI-style Linux hosts use).

## Emulator setup

- Load `output/nhl94.bin` (season build), not `modified_nhl94.bin`.
- Clear battery once before a full run, or use the in-game clear-battery path after trades/create tests.
- Controller setup runs for human season games (chunk 16).

## End-to-end path (full pass — chunk 20)

Work top to bottom. Power-cycle after step 10 and confirm **Continue Season** resumes the same day.

| Step | Action | Pass criteria |
|------|--------|----------------|
| 1 | Play Mode → **Create Player** | Name + ratings save; player appears after reboot |
| 2 | **Sign Free Agents** | Created player signs to a club; limits enforced |
| 3 | **Trade Players** | Legal trade swaps rosters; GM accept persists after reboot |
| 4 | **Game With Trades** | Swapped players on ice; Regular Season still uses team-data roster |
| 5 | **New Season** → SEASON SETUP → Start | Header stored; **Continue Season** appears |
| 6 | Games Today: all **Computer** → **Play Games** | Day advances; scores written |
| 7 | One game **Human** → controller screen → play | Score saved; return to day loop; **no** password playoff tree after the game |
| 8 | **NHL Standings** / **Calendar** | W-L-T and game result match step 7 |
| 9 | **Player Stats** / **Team Stats** / **League Leaders** | Human and simulated games reflected in stats |
| 10 | **Highlights** | Line from last played game; change day / game with `[]` / `{}` |
| 11 | SEASON SETUP **Injuries: Multi-game** → hurt player in human game | Next day still out on ice; trade screen skips attrib adjust for that player (`SeasonPlayerOut` + `SRInjuries`) |
| 12 | Finish regular season → **On To Playoffs** → play series | Playoff tree (not password modes); series scores on existing playoff screen |
| 13 | Win championship | Stanley Cup (if human club won), then nine awards, then title; **Continue Season** hidden until a new season |

## Playoffs (chunk 17)

- End regular season from the menu (or simulate through the last day).
- Confirm **InitPlayoffs** seeds 1v8 per conference and the day loop continues with `SeasonFlags` bit 5.
- **Playoff Tree** menu item opens `PlayoffTreeScreen` → `PlayoffScreen`.
- Password **Continue / New Playoffs** still use `playoffseats` and are unchanged.

## Integration edge cases (E1–E11)

| ID | Prove in emulator |
|----|-------------------|
| E1 | Trade screen overall for a multi-game injured star matches “out” (no `AttribAdjust` bump); same as manual OUT slot. |
| E2 | In-game player stats **Overall** column matches trade screen for injured/out players. |
| E3 | Change lines in a human season game, finish game, start another day with same club — starters follow saved `SRLines`. |
| E4 | Scouting report hot/cold lists reflect season line set, not stock ROM lines. |
| E5 | Human season game: user records on, auto goalies (by design; no setup menu). |
| E6 | Season human `GameOver` returns to day loop without password encode or retail playoff tree. |
| E7 | Controller screen: practice player list is empty (stub); pads still assign. |
| E9 | With 20 created players, **Create Player** from main menu does nothing (returns to menu). |
| E10 | *(Likely N/A — re-verify vs 95 ROM)* Plan once tied a missing `setInjuryType` prologue to “fighting”; **Genesis 95 has no fist-fight mode** (`checkfight` is `rts`). Season setup is **Injuries** (multi-game vs one game), not Fighting. Deferred hook was dropped for **1MB `checks94`↔`rtss2` branch limit**; only pursue if 95 disassembly shows real behavior we still miss. |
| E8 | Type-4 standing highlights still optional; goal/assist/save highlights unchanged. |
| E11 | Retail ROM still MATCH; season hooks stay `jsr (Routine).l` in collide/setup. |
| E14 | Team with **128+** points (e.g. 164) stays at **top** of division standings and qualifies for playoffs (`SortStandings` / `SortSeeds` use unsigned byte compares; Pts column uses word math). |

Full notes: **`docs/season_mode_port_plan.md` section 10**. E12 hardware / E13 merge are release tasks.

## Cup and awards (chunk 18)

- Last playoff game: optional cup during `GameOver` when `sflags13` bit 2 is set.
- After the final sim day, `SeasonMain` `.over` may show the cup when `SimFlags` bit 0, then `SeasonAwards`.
- Start skips an award early; after the last award, title returns.

## Injuries and highlights (chunk 19)

- **Multi-game:** injury carries in SRAM; trade screen treats injured players as out (same as roster `$1E`).
- **One game only:** out for that game only.
- **Highlights:** saved from human games via `SaveSimGame` / `SaveGameHighlights`.

## Integration fixes on this branch

| ID | Fix | Prove |
| --- | --- | --- |
| E1 | `SeasonPlayerOut` calls `GetInjuryGames` | Step 11 + trade roster attrib line |
| E2 | `SeasonAttribAdjust` on scouting matchups and player cards | Injured starter shows unadjusted overall on MATCHUPS / pause card |
| E3 | `SaveTeamLines` from `SaveSimGame` after human/sim games | Line change in game persists next season start (same clubs) |
| E4 | Season scouting skips random `Create_HotCold_Table` regen | Hot/cold text follows starters from `SRLines`, not new RNG |
| E5 | Documented: season `.play` sets User Records on, goalies Auto | Pads still from controller screen; not full setup menu |
| E6 | Season `GameOver` skips `EncodePW` / `PlayoffScreen` | Step 7 returns to season menu, not password tree |
| E8 | `TryTeamRecordHighlight` (type 4) when human club has 5+ wins | Highlights may show team W-L-T line after a streak game |
| E9 | Start on **Create Player** with 20 slots full returns to menu; scroll skips mode 9 when full | Create 20 players, mode line jumps past Create |

Remaining edge cases: **`docs/season_mode_port_plan.md` section 10** (E7 practice UI if `sflags9` bit 7 ever set, E10 fighting/injury, E2 stats `AttribRating` without player context).
| Item | Behavior today |
|------|----------------|
| Hardware boot | Season 2 MB image not verified on real Genesis hardware in this repo. |
| Highlights type 4 | `PrintRecordHighlight` exists; standing-streak saves not ported from 95. |

## Quick regression

After any season change:

1. `bash tools/verify_all.sh` → **ALL MATCH** (`SEASON=0`).
2. Season build command above → **0 errors** in `output/Build94.log`.
3. Spot-check: retail title boot still works from `modified_nhl94.bin`.
