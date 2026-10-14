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
- Four-way play optional; controller setup runs for human season games (chunk 16).

## End-to-end path (chunk 20 plan)

Work top to bottom. Power-cycle after step 10 and confirm **Continue Season** resumes the same day.

| Step | Action | Pass criteria |
|------|--------|----------------|
| 1 | Play Mode → **Create Player** | Name + ratings save; player appears after reboot |
| 2 | **Sign Free Agents** | Created player signs to a club; limits enforced |
| 3 | **Trade Players** | Legal trade swaps rosters; GM accept persists after reboot |
| 4 | **Game With Trades** | Swapped players on ice; Regular Season still uses team-data roster |
| 5 | **New Season** → SEASON SETUP → Start | Header stored; **Continue Season** appears |
| 6 | Games Today: all **Computer** → **Play Games** | Day advances; scores written |
| 7 | One game **Human** → controller screen → play | Score saved; return to day loop |
| 8 | **NHL Standings** / **Calendar** | W-L-T and game result match step 7 |
| 9 | **Player Stats** / **Team Stats** / **League Leaders** | Human and simulated games reflected in stats |
| 10 | **Highlights** | Line from last played game; change day / game with `[]` / `{}` |
| 11 | SEASON SETUP **Injuries: Multi-game** (default) → game-length check injury in a **human** season game | Injury box says “Out for *n* games”; next day(s) player stays out (`SetSeasonInjuries`); `TickTeamInjuries` after each game; trade keeps injury (`GetInjuryGames`). **One Game Only** clears header bit 2—no new SRAM multi-game outs. |
| 12 | Finish regular season → playoffs → series | Tree and playoff screen behave; not password playoffs |
| 13 | Win championship | Stanley Cup screen, then awards, then title |

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
| E14 | *(Planned, critical)* Team with **128+** regular-season points stays at **top** of division standings and qualifies for playoffs (95 had signed-byte sort bug; see plan §10 and [forum fix write-up](https://forum.nhl94.com/index.php?/topic/26073-nhl95-bug-fix-make-the-playoffs-with-128-points/)). |

Full notes: **`docs/season_mode_port_plan.md` section 10**. E12 hardware / E13 merge are release tasks.

## Known gaps (not blocking retail MATCH)

| Item | Behavior today |
|------|----------------|
| Hardware boot | Season 2 MB image not verified on real Genesis hardware in this repo. |
| Highlights type 4 | `PrintRecordHighlight` exists; standing-streak saves not ported from 95. |
| Standings ≥128 pts | **Same as NHL 95:** signed sort on points byte can drop a elite team to last / miss playoffs until **E14** fix (`SortStandings`, `SortSeeds`). |

## Quick regression

After any season change:

1. `bash tools/verify_all.sh` → **ALL MATCH** (`SEASON=0`).
2. Season build command above → **0 errors** in `output/Build94.log`.
3. Spot-check: retail title boot still works from `modified_nhl94.bin`.
