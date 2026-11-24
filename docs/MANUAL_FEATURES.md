# NHL 94 Genesis: the manual's features and the code behind them

The manual's "New Features" list (archive.org scan, SEGAGenesisMegaDriveManuals, PDF p.5) says what 94 added to
NHLPA 93. The manual is a lead; the code column shows where each one is. Written 2026-11-24.

| Manual line | Code |
| --- | --- |
| Goalie control | `ManualGoalieMenu` (src/engine/period94.asm), `assgoaliectrl` (src/engine/logic94.asm) |
| Shootout game | `ShootoutShooters`, `CountShootoutGoals` (src/front/shootout94.asm) |
| Penalty shots | `PenShotChk` (src/engine/penalty94.asm) |
| Bench and board checks | board: `SPAboardfront`, `SPAboardright` (src/frames94.asm); bench: not confirmed in code |
| 3 or 4 players with adapter | `Detect4WayPlay` (src/engine/fourway94.asm) |
| One-timers | `OneTimerPass`, `OneTimerTarget` (src/engine/onetimer94.asm) |
| Hot and cold streaks | not confirmed in code |
| Reverse-angle replay | `ReplayMode` (src/engine/replay94.asm); reverse angle not confirmed in code |
| Clear the zone on the PK | not confirmed in code |
| Automatic line changes | `chk4lc` (src/engine/logic94.asm) |
| Tougher defence and goalies | not confirmed in code |
| Local organ music, 72 pieces | `TeamSongs` (src/front/arena94.asm) |
| Team logos at centre ice | logos: `TeamLogoBitmaps` (src/front/optsetup94.asm); on the ice: not confirmed in code |
| No fighting or blood | not confirmed in code (no fight routines found) |
| Anaheim and Florida | `Anaheim` record (src/teamdata94.asm) |

Not mapped yet (all on PDF p.5): 1992-93 rosters, saved player records and standings, new player stats, flip
passes, computer shooter scoring moves, player and team cards, 144 player pictures, new crowd animations, period
stats, more kinds of game stats.

Goalie control: "Hold B to get goalie control" (PDF p.3); the manual explains it on its own pages 5-6.
