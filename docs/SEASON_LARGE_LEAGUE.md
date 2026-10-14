# Season mode and large leagues (32+ playoff teams)

This document tracks season-build work for leagues larger than the stock 26 playoff teams. Exhibition mods on `main` use sliding retail save equates in `equals.inc`; season mode adds the fixed 95 save map in `ram_addrs.inc`.

## Status

| Area | Stock (28 teams) | 34 teams (32 playoff + 2 AS) |
| --- | --- | --- |
| Retail exhibition save | OK (`verify_all` MATCH) | OK if `NameLogEnd` < `LineDataBase` (`checkSaveLayout.js`) |
| Season save low band vs `SRSeasonHeader` | OK (name log ends at `$E20`) | **Assemble error** (`NameLogEnd` > `SeasonHeaderBase`) until SR relayout |
| Season standings / sim / awards loops | Uses `NumPlayoffTeams` / `RosterSlots` | **Assemble error** if `NumPlayoffTeams` > 26 until RAM/SR sizing |
| Free-agent team index | `FreeAgentTeam equ NumTeams` | Same |
| Schedule / sim weights | 26-team 95 data | Needs modder assets or build gate |

Run `node tools/checkSaveLayout.js` for retail-band math. Season implementation phases live on `feature/season-mode` (layout include, loop fixes, schedule gate).

## Equates (shared)

- `NumTeams`, `NumPlayoffTeams` — `equals.inc`
- `RosterSlots equ 26` — per-team roster geometry (not league size)
- `FreeAgentTeam equ NumTeams` — trade/create season paths
