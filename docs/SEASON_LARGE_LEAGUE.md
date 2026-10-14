# Season mode and large leagues (32+ playoff teams)

Exhibition mods on `main` use sliding retail save equates in `equals.inc`. Season mode (`SEASON=1`) adds a computed save map in `src/stubinc/season_save_layout.inc` and scaled work RAM in `season_work_ram.inc`.

## Status

| Area | Stock (28 teams) | 34 teams (32 playoff + 2 AS) |
| --- | --- | --- |
| Retail exhibition save | OK (`verify_all` MATCH) | OK if `NameLogEnd` < `LineDataBase` |
| Season `SRSeasonHeader` | Fixed `$E22` | Slides to `max(NameLogEnd, $E22)` |
| Season save size | Fills mirror to `$7FFE` | **Assemble error** if `SeasonSaveEnd` > `$8000` |
| Standings / leaders RAM | 26-team buffers | Scales via `NumPlayoffTeams` (must stay below `CreatedPlayerBuf`) |
| Sim goal weights | 26 rows + `REPT` pad | Extra teams use duplicated default row |
| Schedule | `schedule94.asm` (26 clubs) | Set `EXPANDED_SCHEDULE=1` after extending the schedule |
| Standings divisions | `season_divisions.inc` | Stock tables for 26 or 32 playoff teams; add more in that include |

## Modder knobs

- `NumTeams` / `NumPlayoffTeams` — `equals.inc`
- `EXPANDED_SCHEDULE equ 1` — after `schedule94.asm` lists every playoff team
- `season_divisions.inc` — division byte lists (counts must sum to `NumPlayoffTeams`)

## Checks

```bash
bash tools/verify_all.sh
node tools/checkSaveLayout.js --season 28 34
```
