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
| 11 | SEASON SETUP **Injuries: Multi-game** → hurt player in human game | Next day roster shows out; trade moves injury nibble |
| 12 | Finish regular season → playoffs → series | Tree and playoff screen behave; not password playoffs |
| 13 | Win championship | Stanley Cup screen, then awards, then title |

## Planned follow-ups (integration edge cases)

Full table with 95 vs 94 notes and priority: **`docs/season_mode_port_plan.md` section 10** (E1–E13). Examples: injury state vs trade-screen “OUT” (`SeasonPlayerOut`), saving line sets to `SRLines` after a season game, season scouting report data, and skipping password playoff UI on season `GameOver`.

## Known gaps (not blocking retail MATCH)

| Item | Behavior today |
|------|----------------|
| Hardware boot | Season 2 MB image not verified on real Genesis hardware in this repo. |
| `SeasonPlayerOut` | Roster word `$1E` only; multi-game outs use `SetSeasonInjuries` / SRAM `SRInjuries` at game time, not this helper. |

## Quick regression

After any season change:

1. `bash tools/verify_all.sh` → **ALL MATCH** (`SEASON=0`).
2. Season build command above → **0 errors** in `output/Build94.log`.
3. Spot-check: retail title boot still works from `modified_nhl94.bin`.
