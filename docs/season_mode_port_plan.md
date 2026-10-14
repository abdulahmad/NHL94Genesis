# Season mode port plan (95G into 94G)

Phase 1 only. No port code until this plan is approved.

Sources read for this plan:

- 94G `main` at `881e45c`. `SEGMENT_AGENT.md` ("Current rules (Oct 2026)"), `docs/HANDOFF.md`.
- 95G `main` at `518a1b0` (public repo, cloned read-only). `SEGMENT_AGENT.md` ("Current rules (Oct 2026)"), `docs/HANDOFF.md`, and the season, schedule, save, playoff, awards, stats, and menu source.
- `START_HERE.md` is not in either repo on `main`. Nothing in this plan depends on a file that is not there.

This is a feature port. The season build will differ from the retail ROM. `main` stays untouched. Retail `npm run build:retail` keeps producing MATCH. The port lives behind `SEASON=1` on `feature/season-mode`.

95G calls the feature season mode. In 94G the menu line "Regular Season" is one exhibition game. The schedule, standings, and saved season are new.

## 1. What Season mode is

From the player's side, 95G season mode is a saved campaign around the existing game.

Power-on is the same shape as 94: title, then the game setup menu. 95's Play Mode list adds **New Season** and **Continue Season** beside Regular Game, the playoff modes, and Shootout. Trade Players, Create Player, Sign Free Agents, and Release Players are separate Play Mode lines. They are not items inside the season menu.

**New Season** opens **SEASON SETUP**. Six lines, changed with left and right, stored with Start:

| Line | Values |
| --- | --- |
| Period Length | 5 Minutes, 10 Minutes, 20 Minutes, 30 Seconds |
| Penalties | Off, On, On no offsides |
| Line Changes | On, Off, Auto |
| Playoffs | Single Game, Best Of Seven |
| Injuries | Multi-game, One Game Only |
| Season Schedule | Normal, Random |

Start writes that header into battery RAM, clears the season records, and picks the first schedule day. Normal starts at day 0 (October 5). Random picks a schedule day that has games. The season is 192 schedule days, October 5 through April 14, which is the 1993-94 calendar stored in 95 (`schedule95.asm`).

**GAMES TODAY** lists that day's matchups. A toggles each game between Human and Computer. Left and right change the day. Start returns to the season menu. Human games are played. Computer games are simulated.

**SEASON OPTIONS** during the regular season:

- Play Games
- Play Until A Day (simulate ahead to a chosen date, cancellable)
- NHL Standings
- Team Schedule Calendar
- Games Today
- League Leaders
- Team Stats
- Player Stats
- Highlights
- End Season After Today

Standings cycle four groups with the pad: Western / Pacific, Western / Central, Eastern / Northeast, Eastern / Atlantic. Each line is a team block plus W, L, T, Pts, GP, and games remaining. The calendar is one team's month, with the opponent and W/L/T on days already played.

**Play Games** simulates every Computer game that day, then sends each Human game through the normal path: controller assignment, scouting report, the game, the intermission. After the game the score, the standings, the player stats, and today's highlight are written to battery RAM and the season menu returns. A day with no human game is simulated in one step and the calendar advances.

When the last day is done the menu becomes **On To Playoffs**, plus standings, calendar, games today, leaders, and team and player stats. Playoffs seed the top 8 teams in each conference, 1 vs 8, 2 vs 7, 3 vs 6, 4 vs 5. West has 12 teams, East has 14, so 16 clubs play. Series length is whatever SEASON SETUP chose. The playoff menu is Play Games, Games Today, Team Stats, Player Stats, Playoff Team Stats, Playoff Player Stats, and Playoff Tree. The tree is the screen 94 already has: series scores, team blocks, pad scroll.

The champion's screen is the Stanley Cup, then nine awards (Hart, Norris, Vezina, Art Ross, Jennings, Pearson, Selke, Presidents', Conn Smythe), each with three finalists and a winner. Start leaves an award early. After the last award the game returns to the title and the setup menu. **Continue Season** reloads the battery header and resumes the saved day. A season game in progress is marked in battery RAM so a reset during the game comes back to the playoffs or the day correctly (`SRSeasonMark`).

Where it sits in 95's flow: `Begin` still runs the title. `Opening2` draws the setup menu (`GameSetUp`). Choosing a season sets `GameFlags` bit 3, and a new season also sets bit 4. `SeasonMain` then owns the loop. A human game sets bit 5 and jumps back into `GameSetUp`, which skips the menu and uses the season's period length, penalties, line changes, and the two clubs from today's list. `GameOver` writes the result (`SeasonGameOver`) and returns to `Opening2`, which calls `SeasonMain` again. The cup flag (`sflags13` bit 2) makes `GameOver` show the cup before that.

94's matching loop is `Opening2` in `setup94.asm`: `GameSetUp`, name entry, the playoff screen, the scouting report, `StartGame`. `GameOver` runs `EncodePW` (the playoff password) and the playoff screen, then `ExitToOpening`. Exhibition, password playoffs, and the shootout stay on that path. Season is a branch beside them.

## 2. Code to bring over

Counts below are global labels (routines and the tables they own). Locals are not counted. A straight port is source that assembles against 94 once the new RAM names and the new assets exist. An adaptation calls a 95-only service, or collides with a 94 name that means something else. A replacement is a 94 routine that already does the job, so the 95 copy is not copied.

| Class | Labels |
| --- | --- |
| Straight port | 374 |
| Adaptation | 25 |
| Replaced by a 94 routine | 91 |

The 25 adaptations are 10 copied routines that need a change (`StanleyCupScreen`, `PrintCentered`, `AppendNumber`, `setInjuryType`, `CheckInjury`, `GetRosterName`, `GetCreatedName`, `SaveTeamLines`, `CopyTeamLines`, `TeamLinesOffset`), the 8 save-RAM routines, and 7 existing hooks (`GameSetUp`, `FixModeOptions`, `Opening2`, `GameOver`, the period-end cup flag, `ReadLineData`, `WriteLineData`). The 91 replacements are the demo readers, the playoff tree screen, the stats, period, line-editor, and three-stars screens, four injury helpers, the three unused leader builders, and the title, credits, and high-score labels in `title95.asm`. Left out of those totals: the trade screen and Create Player, 40 labels (section 8).

### Menus and screens (`front/season95.asm`, 16,772 bytes in 95)

Straight port, the whole season loop except the four demo labels:

`SeasonMain`, `ReadSeasonHeader`, `WriteSeasonHeader`, `PickSeasonStartDay`, `BuildSeasonTeamList`, `ReadDayGames`, `WriteDayGames`, `SkipToGameDay`, `DayHasGames`, `FindDayGames`, `PrevSeasonDay`, `NextSeasonDay`, `NextSeasonTeam`, `PrevSeasonTeam`, `SeasonGameOver`, `AddSeasonGoals`, `ClearSeasonData`, `RecordGameResult`, `RecordTeamResult`, `MakeDateString`, `DayToDate`, `DateToDay`, `CountTeamGames`, `ReadStandings`, `SeasonSetup`, `ReadAnyPad`, `StoreSeasonSetup`, `WrapSetupUp`, `WrapSetupDown`, `SeasonSetupLines`, `SeasonSetupGfx`, `DrawSeasonSetup`, `PrintSetupValue`, `PrintSetupName`, `PrintOption`, `PrintOptionHi`, `GamesToday`, `GamesTodayLoop`, `GamesTodayNext`, `GamesTodayPrev`, `GamesTodayToggle`, `GamesTodayUp`, `GamesTodayDown`, `GamesTodayExit`, `GamesTodayDone`, `ReadGamesTodayPad`, `PrintGamesToday`, `PrintPreviousDay`, `DrawGamesToday`, `PrintGameScores`, `PrintGameScore`, `DrawGameCursor`, `DrawHumanMark`, `DrawCompMark`, `DrawGameLogo`, `SeasonOptions`, `MenuEndSeason`, `MenuLeagueLeaders`, `MenuPlayoffTeamStats`, `MenuTeamStats`, `MenuPlayoffPlayerStats`, `MenuPlayerStats`, `MenuHighlights`, `MenuGamesToday`, `MenuStandings`, `MenuPlayoffTree`, `MenuStay`, `MenuCalendar`, `MenuPlayGames`, `MenuPlayUntil`, `AutoplayCancel`, `AutoplayMessage`, `PrintAutoplayDay`, `ReadSeasonMenuPad`, `DrawSeasonMenu`, `GetSeasonMenu`, `PrintWait`, `CalendarScreen`, `ReadCalendarPad`, `CountSeasonMonths`, `DrawCalendar`, `DrawCalendarTeam`, `DrawCalendarMonth`, `DrawCalendarDay`, `DrawCalendarOpponent`, `DrawCalendarResult`, `StandingsScreen`, `ReadStandingsPad`, `SortStandings`, `StandingsPoints`, `StandingsGroups`, `StandingsGfx`, `DrawStandings`, `PrintStandingsLine`, `DrawStandingsLogo`, `PrintStandingsHelp`.

Tables owned by those routines, copied with them: `SeasonSetupCounts`, `SetupValueText`, `SetupNameText`, `SeasonSetupHelp`, `CompText`, `HumanText`, `GameRowsTbl1` through `GameRowsTbl6`, `GamesTodayHelp`, `SeasonMenuJumps`, `SeasonEndMenuJumps`, `PlayoffMenuJumps`, `SeasonMenuText`, `SeasonEndMenuText`, `PlayoffMenuText`, `MonthNames`, `MonthDays`, `CalendarFirstXTbl`, `CalendarFirstDayTbl`, `StandingsGroupTbl`, `StandingsGroup0` through `StandingsGroup3`, `StandingsTitles`. Division bytes stay as team numbers. Section 6 is why they already match 94.

Replaced by `hockey94`: `demoread`, `EndDemoOnPress`, `rtsdemo`, `RandomSetupTeams`.

`SimDayGames` and the sim helpers are listed under standings and stats, in this same file.

### Schedule (`schedule95.asm`, 2,378 bytes)

Straight port: `SeasonSchedule`, `SeasonScheduleEnd`. One byte count of days (`192`), then one record per day written with the `Day` macro. The macro moves into `src/macros/genesis.mac` next to the other macros. Team abbreviations are the `ANH` through `WPG` equates already in `src/stubinc/equals.inc` (`ANH equ 0`, same order as 94 `TeamList`).

### Simulation and results (still `season95.asm`)

Straight port: `SimDayGames`, `SimGameStats`, `SimGoalieStats`, `SimGoalie`, `PickSimGoalie`, `SimScorers`, `SimAssists`, `PickAssist`, `SimShots`, `SimScore`, `SimTieBreak`, `SimTeamGoals`, `ScaleSimScore`.

Tables: `SimTeamTbl`, `TeamScoring0` through `TeamScoring25` and `TeamScoringTbls`, `SimShotsTbl`, `SimGoalsHome`, `SimGoalsAway`, `SimGoalsHomeDef`, `SimGoalsAwayDef`, `SimTieTbl`. Each weight row is one team in `TeamList` order, ANH first. They copy as-is.

### Standings, stats, leaders, highlights (`front/stats95.asm`)

The file is 17,074 bytes and mixes 94 screens with the season screens. Copy only the season block.

Straight port, season records and the season screens (`InitSeasonStats` at `$92BEC` through `LeadersHelp`, 8,934 bytes up to `PeriodStatsScreen`, plus the leaders tables in that span): `InitSeasonStats`, `SaveSimGame`, `AddTeamSeasonStats`, `AddPlayerSeasonStats`, `ReadStatBlock`, `WriteStatBlock`, `SaveGameHighlights`, `BestGoalieSaves`, `MostAssists`, `MostGoals`, `AddHighlight`, `CompareHighlight`, `rtsHighlight`, `ReadTeamPlayerStats`, `WriteTeamPlayerStats`, `ReadSeasonTeamRecord`, `MarkSeasonRosters`, `SeasonPlayerStats`, `SeasonPlayersScreen`, `SeasonStatsList` and its draw, scroll, and row routines, `SeasonTeamStats`, `SeasonTeamsScreen`, `SeasonTeamStatsRun`, `PrintSeasonTeamStats`, `DrawTeamStatsLogo`, `LeagueLeadersScreen` and the leader builders (`LeadersPoints` through `LeadersShotsAllowed`, `BuildPlayerLeaders`, `PlayerLeadersGoals`, `PlayerLeadersAssists`, `PlayerLeadersPoints`, `PlayerLeadersGAA`, `GatherAndSort`, `DrawLeaderRows`). That block is 84 labels including its text and jump tables.

Straight port, highlights (`HighlightsScreen` through `HighlightsHelp`, about 1,640 bytes): `HighlightsScreen`, `ReadHighlightsPad`, `PrintHighlightsTitle`, `DrawHighlightPage`, `DrawHighlightEntry`, `PrintRecordHighlight`, `PrintHighlight`, `PrintGameScore2`, `PrintScore2`, `DrawHighlightLogo`, `GetHighlightSlot`, `HighlightsHelp`, and the GOAL/ASSIST/SAVE strings.

Adaptation: 95's highlight `AppendNumber` is a different routine from `cards94`'s `AppendNumber` (that one writes a String at `a1`). 94 keeps the name. The highlight helper gets a new name, `HighlightAppendNumber`, recorded in `docs/name_map.csv`.

Replaced by `stats94`, `period94`, and `cards94`: `GameStatisticsScreen` through `ScrollArrowTbl2`, `PeriodStatsScreen` and its column printers, `LineEditor` through `SetLineSlot`, `ShowThreeStars`, `TakeTopStarScore`, `CalcStarScores`, `CalcTeamStarScores`.

Adaptation of the 94 line editor, only if saved season lines are in the first build: `SaveTeamLines`, `CopyTeamLines`, `TeamLinesOffset`. They read and write `SRLines`. The rest of the editor stays 94's.

### Save RAM (`sram95.asm`)

Adaptation of the 94 routines in `sram94.asm`, behind the flag: `InitSaveRAM`, `SRAMWaitVblank`, `VBcount`, `ValidateSRAM`, `ClearSRAM`, `WriteSRAM`, `MakeSRAMChecksum`, `ReadSRAM`. The season build checks and copies `$8000` bytes and puts the checksum at `$7FFE`. Retail stays `$2000` bytes and `$1FFE`.

Not ported: `BuildLeaderList`, `BuildLeaderListSum`, `BuildLeaderListPct`. 95 marks them unreferenced. `LeagueLeadersScreen` has its own builders.

`ReadLineData` and `WriteLineData` in `title94.asm` are an adaptation: the season build stores that `$100` byte block at `SRLineData` (`$7EF6`) so the 95 season map can occupy `$1EF6`.

### Playoff transition (`front/awards95.asm`, the second half)

Straight port: `InitPlayoffs`, `SeedPairings`, `SortSeeds`, `CalcSeedPoints`, `CopyBytes`, `SetupPlayoffs`, `RestoreSeasonHeader`, `NextPlayoffRound`, `InitPlayoffSeries`, `BuildPlayoffDayGames`, `SeriesInRound`, `GetRoundPairings`, `ReadPlayoffSchedule`, `RecordPlayoffGame`, `CollectSeriesWinners`, `PlayoffTreeScreen`, plus `ConferenceTeams1`, `ConferenceTeams2`, `SeriesCountTbl`, `RoundPairOffsets`, `RoundSeriesOffsets`, `RoundSeriesCounts`.

`PlayoffTreeScreen` fills `gsstruct`, `bosgames`, `gamelevel`, and `potree`, then calls `PlayoffScreen`.

Replaced by `setup94`, `title94`, and `display94` (the whole of `engine/playoff95.asm`, 1,754 bytes): `PlayoffScreen`, `HandlePlayoffInput`, `UpdatePlayoffScroll`, `PlayoffScreenExit`, `PlayoffScreen_waitvsync`, `PrintSeriesScore`, `DrawTreeArrow`, `DrawTeamBlocks`, `VBlank_Playoff`, `PlayoffTreeSetup` and its level tables, `DrawPlayoffSprite`, `SetSframe`.

`EncodePW`, `NewPO`, `maketree`, `ContinuePlayoffs`, and `playoffseats` stay the password playoff path. Season series do not go through the password.

### Awards and the cup

Straight port from `awards95.asm`: `SeasonAwards`, `PrintAwardTitle`, `DrawAwardPicture`, `DrawFinalistsPanel`, `DrawWinnerPanel`, `DrawAwardPanel`, `PrintFinalists`, `FlashWinnerCaption`, `AwardsLoop`, `AwardsScreenSetup`, `FindAwardFinalists`, `SortAwardScores`, and the scans (`ScanHart`, `ScanNorris`, `ScanVezina`, `ScanArtRoss`, `ScanJennings`, `ScanPearson`, `ScanSelke`, `ScanPresidents`, `ScanConnSmythe`, `ScanAllPlayers`, and the score functions). Tables: `AwardNames`, `AwardDescs`, `AwardDescs2`, `AwardPictures`, `AwardPictureX`, `AwardPictureY`, `AwardScanTbl`.

Adaptation: 95's award `PrintCentered` takes a string index and a list. 94's `PrintCentered` in `cards94.asm` centres the String at `a0`. 94 keeps the name. The award printer is named `AwardPrintCentered`.

Adaptation: `StanleyCupScreen` in `title95.asm`. The picture, the sprites, and the wait-for-start loop copy over (`CupReadPads`, `CupWaitFrame`, `CupExit`, `CupVBlank`, `CupDrawTeam`, `CupBuildSprites`, `AddSpriteFrame`). The 95 sound-driver restart (`SoundCmd` 9/0/6/7, then `song` 3) becomes 94's `song` call. Song 3 in 95 is the cup song; 94 will use the end-of-game song (`SngEOG`) unless you want the 95 song brought over (section 8).

The rest of `title95.asm` (title, credits, high score) is replaced by `title94` and `attract94`.

### Injuries (`front/injury95.asm`)

Straight port: `SetSeasonInjuries`, `TickTeamInjuries`, `TickInjuries`, `SetInjuryGames`, `GetInjuryGames`, `InsertInjurySlot`, `DeleteInjurySlot`, `ClearPowerPlay`.

Adaptation: `setInjuryType` (a season injury stores a games-out count) and `CheckInjury` in `hockey94.asm` (call `SetInjuryGames` when the season header says multi-game). `restoreteams` / the lineup build calls `SetSeasonInjuries` when `GameFlags` bit 3 is set, the way `players95` does.

Replaced: `getFgtbyte`, `chkFgtBit1` (`title94`), `updatepwrplay`, `GetLowestPen` (`penalty94`).

### Roster reads (`front/trade95.asm`, the top of the file only)

Straight port, needed so season stats name the right players: `DefaultRosters`, `GetRosterId`, `ReadTeamRoster`, `WriteTeamRoster`, `GetJerseyNumber`, `FixJerseyNumber`.

Adaptation: `GetRosterName` and `GetCreatedName`. With Create Player left out, `GetCreatedName` returns the team-data record and the created-player branch is skipped.

The trade screen itself (`TradePlayers` through `TradeRatingValues`, about 6,340 bytes for the whole file) stays out.

### Hooks into game start and game end

These are edits to 94 routines, also counted in the adaptation total:

| 94 routine | Change under `SEASON=1` |
| --- | --- |
| `optsetup94` `GameSetUp`, `FixModeOptions`, the Play Mode strings | Add New Season and Continue Season. On a human season game (`GameFlags` bit 5), skip the menu and take period, penalties, lines, and the two teams from the season header and `SeasonTeams`. |
| `setup94` `Opening2` | After `GameSetUp`, `jsr SeasonMain`. A human game comes back through `GameSetUp` with bit 5 set. |
| `setup94` `GameOver` | After `EncodePW`, `jsr SeasonGameOver`. `EncodePW` already returns immediately for a non-playoff mode. |
| `hockey94` period end / `clockcont_0` | When the last playoff series ends, set `sflags13` bit 2 and `cupwinner` so `GameOver` shows the cup. |
| `title94` `ReadLineData`, `WriteLineData` | Season build uses offset `SRLineData`. |
| `sram94` the eight routines above | `$8000` bytes, checksum at `$7FFE`. |

`Begin`, the title screen, `StartGame`, the scouting report, and the intermission stay. `AddPlayoffTeamStats` in `data94.asm` remains the password-playoff stat packer. Season player totals go through `SaveSimGame` and `AddPlayerSeasonStats`.

## 3. Hooks in 94

Same edits as the table above, from the player's path:

1. **Setup menu** (`optsetup94`). Retail Play Mode values stay Regular Season, Continue Playoffs, New Playoffs, New Playoffs/7 game, Shootout. The season build appends New Season and Continue Season. Continue Season is omitted when the battery header is empty (`SeasonLength` 0), matching `FixModeOptions` in `setup95.asm`. Choosing New Season sets `GameFlags` bits 3 and 4. Continue Season sets bit 3 only.
2. **After the menu** (`setup94` `Opening2`). `SeasonMain` runs while bit 3 is set. It returns only when it is about to start a human game or the season is over.
3. **Game setup for a season game.** `GameSetUp` sees bit 5, copies `SeasonPerlen`, `SeasonPen`, and `SeasonLine` into the option words, and sets `HomeTeam` and `VisTeam` from the selected `SeasonTeams` entry. Name entry, the scouting report, and `StartGame` then run as they do now.
4. **Game end** (`setup94` `GameOver`, and the period-end path in `hockey94`). `SeasonGameOver` writes the score into the day's record, updates standings, and calls `SaveSimGame`. The cup flag sends the champion to `StanleyCupScreen` before `SeasonMain` runs the awards.
5. **Playoffs.** `PlayoffTreeScreen` feeds the existing `PlayoffScreen`. The password tree (`playoffseats`, `EncodePW`) is unchanged and still serves Continue Playoffs and New Playoffs.
6. **Stats screens.** The pause-menu stats, period stats, line editor, and three stars stay the 94 screens. The season menu calls the new season screens. No change to the pause menu is required for the season to be playable.
7. **Injuries.** `CheckInjury` and `setInjuryType` gain a season branch. One Game Only keeps today's "out for the game" behavior.

`main94.asm` `Start` is unchanged apart from the existing `CHECKSUM` switch. The season build passes `CHECKSUM=0`, so `Start` skips `ValidationRoutine` the same way `build:dev` does.

## 4. RAM and SRAM

94 already has battery save. The header is `'RA',$F8,$20` at `$200001-$203FFF`: `$2000` data bytes on the odd bytes of a 16 KB window. `InitSaveRAM` copies those bytes to `M68K_RAM` and checks them. What is in there today:

| Offset | Bytes | Contents |
| --- | --- | --- |
| `$0000` | through `$B5F` | Player records (`PlayerRecordIO`) |
| `$B60` | `$10` per team | Crowd records |
| `$D20` | `$80` | Team records |
| `$DA0` | `$80` | Name log (ends at `$E20`) |
| `$E20` | `$10D6` | Unused, up to the line block |
| `$1EF6` | `$100` | Saved lines (`ReadLineData`) |
| `$1FFE` | 2 | Checksum complement and sum |

A password cannot hold this feature. 94's password is the playoff bracket (`pwddatabuffer`, five words). One season is the header, `$CCC` bytes of game results, standings, a roster per team, five stat words per player, playoff series, and the same stat blocks again for the playoffs. 95's season region from `SRSeasonHeader` through the checksum is about 29 KB.

**Recommendation:** the season build widens battery RAM to `$8000` data bytes, header end `$0020FFFF`, the same window 95 declares. Emulators and flash carts size the save from the header. A real NHL 94 cart has the 8 KB chip, so that cart would keep exhibition records only. Retail build keeps `$203FFF` and `$2000`.

95's low save map is two bytes off 94's (`SRCrowdRecords` is `$B62`, the name log is `$DA2`). Keep 94's offsets for player records, crowd, team records, and the name log so those routines stay byte-identical in the retail build and correct in the season build. From `SRSeasonHeader` upward, use 95's offsets and 95's names. That region starts at `$E22`, just past the name log. It overlaps the line block at `$1EF6`, so the season build moves the line block to `SRLineData` (`$7EF6`). `ReadLineData` and `WriteLineData` take the new offset under the flag.

Season save names, at the 95 offsets:

| Name | Offset | What it holds |
| --- | --- | --- |
| `SRSeasonHeader` | `$E22` | 8 bytes: `SeasonStartDay` through `SeasonLine` |
| `SRGameResults` | `$E2A` | `$CCC` bytes, 3 per game |
| `SRStandings` | `$1AF6` | W, L, T, 3 bytes a team |
| `SRGoalTotal` | `$1B44` | Human-game goal total and `SeasonGameCount` |
| `SRRosters` | `$1B4C` | `$38` bytes a team |
| `SRGoals` | `$21A4` | Player goals, `$57C` |
| `SRAssists` | `$2720` | Assists |
| `SRShots` | `$2C9C` | Shots |
| `SRGamesPlayed` | `$3218` | Games played |
| `SRPenMin` | `$3794` | Penalty minutes |
| `SRTeamStats` | `$3D10` | 10 bytes a team |
| `SRLines` | `$3E14` | Season line sets |
| `SRSavedLines1` | `$4530` | Extra line sets |
| `SRSavedLines2` | `$4B6C` | Extra line sets |
| `SRSavedLines3` | `$5136` | Extra line sets |
| `SRJerseyNums` | `$5700` | Jersey numbers |
| `SRFreeAgentJerseys` | `$5A80` | Reserved so later offsets stay put |
| `SRCreatedPlayers` | `$5AA0` | Reserved, unused while Create Player is out |
| `SRCreateCount` | `$5D21` | Reserved |
| `SRFreeAgentList` | `$5D22` | Reserved |
| `SRFreeAgentCount` | `$5D57` | Reserved |
| `SRTeamBlock2` | `$5D58` | Cleared by `InitSeasonStats`, no other reader |
| `SRInjuries` | `$5E5C` | Games remaining, one nibble a player |
| `SRSeasonHeaderSave` | `$5FD6` | Header saved across the playoff reset |
| `SRHighlights` | `$5FD6` | Today's highlights, 4 bytes a game (same address 95 uses; the header save occupies it only while playoffs are being built) |
| `SRPOPairings` | `$5FE0` | Playoff pairings |
| `SRPORound` | `$6000` | Round |
| `SRPODay` | `$6002` | Playoff day |
| `SRPOSeries` | `$6004` | Series, `$10` bytes each |
| `SRPOSchedule` | `$6084` | Playoff schedule |
| `SRPOStandings` | `$6173` | Playoff W, L, T |
| `SRPOGoals` | `$61C1` | Playoff player stats, same layout as the regular-season blocks |
| `SRPOAssists` | `$673D` | |
| `SRPOShots` | `$6CB9` | |
| `SRPOGamesPlayed` | `$7235` | |
| `SRPOPenMin` | `$77B1` | |
| `SRPOTeamStats` | `$7D2D` | |
| `SRSeasonMark` | `$7EE6` | Nonzero while a season game is being played |
| `SRCupWinner` | `$7EEE` | Champion team number |
| `SRLineData` | `$7EF6` | The old `$1EF6` line block, moved |
| `SRChecksum` | `$7FFE` | Complement and sum |

Work RAM cannot use the 95 addresses. 95's `GameFlags` is `$FFFFBF08`, which in 94 is `bholdtimer34`. 95's `SeasonStartDay` is `$FFFFD1A4`, which in 94 is `fm_voice_usage_table`. The 94 variable area runs from `VSCRLPM` (`$FFFFB000`) through `PALflag` (`$FFFFDEF2`). `Begin` clears `$B000` through `$DEF3`. `Opening2` clears `$B000` through `$D03E` only, so a block above `$DEF2` survives from one game to the next and is zeroed on power-on. The season reloads itself from battery RAM after that.

New work variables, 95 names, placed at `$FFFFDEF4` upward. The stack stays at `$FFFFFFFE`. This block is about 1 KB. `$FFFFF000` and above stay stack.

| Name | Role |
| --- | --- |
| `GameFlags` | Bit 3 season, bit 4 new season, bit 5 human season game, bit 6 random schedule, bit 7 checksum batch |
| `sflags9` | Left clear. 95 uses bit 7 for Practice Mode, which this port does not add |
| `sflags10` | Left clear. 95 uses it for Trade and Create |
| `sflags11` | Bit 0 previous day, bit 1 cup day, bit 2 inside `PlayoffScreen`, bit 3 playoff stat page, bit 5 end-of-season menu, bit 6 kept across the `Opening2` clear |
| `sflags12` | Bit 1 multi-game injury just set, bit 5 end-of-season menu select |
| `sflags13` | Bit 2 Stanley Cup won |
| `cupwinner` | Team number |
| `SimFlags` | Bit 0 a user club won the cup, bit 1 this game was simulated |
| `seasonsetupreq` | Nonzero: next menu open is Continue Season |
| `AutoplayDay` | Play Until A Day target, 0 when off |
| `SeasonStartDay`, `SeasonLength`, `SeasonDay`, `SeasonFlags`, `SeasonPerlen`, `SeasonPen`, `SeasonLine` | The header image `ReadSeasonHeader` fills |
| `seasonteamsel` | Index into `SeasonTeams`, or -1 |
| `SeasonTeams` | Today's games: day, count, then 5 bytes a game (home, away, scores, flags). 12 games is the schedule maximum |
| `injurygames` | Length of the last injury |
| `StandingsMode`, `CalTeam` | Which division and which club the screens are showing |
| `optbgchars`, `gamestoday1chars`, `gamestoday3chars`, `calbgchars`, `calresultchars` | VRAM bases for the season screens |
| `AwardIndex`, `AwardTimer`, `AwardFlashTimer`, `AwardCount`, `AwardWinner`, `AwardHilite`, `AwardCycle`, `AwardWait` | Award screen state. `SimWeights` shares `AwardIndex`'s storage the way it does in 95, because sim and awards never run together |
| `PlayoffSchedule` | Scratch copy of `SRPOSchedule` (239 bytes) |
| `StandingsBuf` | 26 teams, 3 bytes, filled by `ReadStandings` |

Large sort buffers use `M68K_RAM` (`$FFFF0000`) while a menu is up, which is the replay frame buffer. 95 does the same (`AwardIds` is an equate on `M68K_RAM`). They are not live during a game. Names: `AwardIds`, `AwardScores`, `RosterTable`, `LeaderPlayers`, `LeaderValues`, `SeedPoints`, `SeedGames`, `SeedCount`. `SeasonTeams` and the header bytes stay in the `$DEF4` block, because `SeasonGameOver` runs at the end of a game, while the replay buffer still holds that game.

## 5. Assets

### Reused from 94

| 94 asset | Stands in for | Why it is enough |
| --- | --- | --- |
| `SmallFontMap` (`Extracted/NHL94/Graphics/SmallFont.map.jim`) | `SmallFontMap` | The font every season screen prints with, including the remap loads in `SeasonSetupGfx` |
| `BigFontMap` (`BigFont94.map.jim`) | `BigFontMap2` | Titles (SEASON SETUP, SEASON OPTIONS, NHL STANDINGS, GAMES TODAY). Same compressed-font job. If a title decompresses wrong, `BigFontMap2` (4,514 bytes) moves to the brought-over list |
| `Teamblocksmap` (`TeamBlocks94.map.jim`) | `Teamblocksmap` | 28 team blocks, same `dobitmap` use, same team index. Standings, games today, leaders, and the cup all draw these |
| `logoANH` through `logoASW` | The 95 per-team logo bitmaps | Already indexed in `TeamList` order. `DrawGameLogo` and the calendar use this set |
| Team palettes (`ANHh.pal`, `ANHv.pal`, and the rest) | 95 team palettes | The game and the logo draws already load these |
| `Arrowsmap` | `Arrowsmap` | `DrawTreeArrow` in the playoff tree |
| `SetupMenuMap`, `SetupFramerMap`, `LogoBoxMap` | The 95 setup-menu art for the exhibition menu | The human game still enters through 94's game setup. Those screens keep their own art |
| `PrintFont2Map` (`SmallFont94.map.jim`) | The 95 setup-screen font | Already what `GameSetUp` prints with |
| `SngTitle`, `SngEOG`, `SFXhorn`, the rest of `sound94` | 95 `SoundCmd` songs on the cup and between games | Season screens do not add a new driver. The cup uses `SngEOG` |

In-game rinks, sprites, crowds, and the pause screen are unchanged and stay the 94 files.

### Brought over from 95

94 has no games-today screen, no calendar, no season standings background, no award art, and no cup picture. Sizes are the spans in `tools/extractAssets95.js`.

| 95 asset | Bytes | Why 94 has nothing for it | Extraction |
| --- | --- | --- | --- |
| `ControllerBgMap.map.jim` | 3,950 | Full-screen background for setup, options, and standings. `SetupMenuMap` is the small options frame | Slice `0x164AC8-0x165A36` |
| `GamesTodayLogoMap.map.jim` | 6,894 | The games-today page art | `0x165A36-0x167524` |
| `GamesTodayMap1.map.jim` | 346 | Cursor | `0x167524-0x16767E` |
| `GamesTodayMap2.map.jim` | 416 | Human pad icon | `0x16767E-0x16781E` |
| `GamesTodayMap3.map.jim` | 550 | Computer icon | `0x16781E-0x167A44` |
| `CalendarBgMap.map.jim` | 5,166 | Calendar page | `0x167A44-0x168E72` |
| `CalOpponentMap.map.jim` | 2,154 | Opponent cell | `0x168E72-0x1696DC` |
| `CalDayMap.map.jim` | 1,546 | Day cell | `0x1696DC-0x169CE6` |
| `CalMonthMap.map.jim` | 2,862 | Month header | `0x169CE6-0x16A814` |
| `CalCheckMap.bin` | 168 | Played-day mark | `0x16A814-0x16A8BC` |
| `CalResultMap.map.jim` | 448 | W/L/T mark | `0x16A8BC-0x16AA7C` |
| `WaitBoxMap.map.jim` | 7,730 | The "simulating" box | `0x16CC82-0x16EAB4` |
| `HighlightsBgMap.map.jim` | 646 | Highlights header art | `0x16C9FC-0x16CC82` |
| `PlayerStatsBgMap.map.jim` | 3,886 | Season player-stats page. 94's player stats are text on the pause screen | `0x16B50A-0x16C438` |
| `PlayerStatsTitleMap.map.jim` | 830 | That page's title art | `0x16C438-0x16C776` |
| `AwardsBgMap.map.jim` | 18,222 | Awards page | `0x17409A-0x1787C8` |
| `FinalistsPanelMap.map.jim` | 842 | Finalists panel | `0x1787C8-0x178B12` |
| `WinnerPanelMap.map.jim` | 948 | Winner panel | `0x178B12-0x178EC6` |
| `HartPic.map.jim` | 1,994 | Award picture | `0x178EC6-0x179690` |
| `NorrisPic.map.jim` | 4,794 | Award picture | `0x179690-0x17A94A` |
| `VezinaPic.map.jim` | 2,462 | Award picture | `0x17A94A-0x17B2E8` |
| `ArtRossPic.map.jim` | 3,096 | Award picture | `0x17B2E8-0x17BF00` |
| `SelkePic.map.jim` | 8,662 | Award picture | `0x17BF00-0x17E0D6` |
| `JenningsPic.map.jim` | 3,512 | Award picture | `0x17E0D6-0x17EE8E` |
| `PresidentsPic.map.jim` | 2,270 | Award picture | `0x17EE8E-0x17F76C` |
| `ConnSmythePic.map.jim` | 2,750 | Award picture | `0x17F76C-0x18022A` |
| `PearsonPic.map.jim` | 2,340 | Award picture | `0x18022A-0x180B4E` |
| `StanleyCupImg.map.jim` | 13,486 | Cup picture | `0x196C4C-0x19A0FA` |
| `CupSprites.map.jim` | 2,200 | Cup sprite frames | `0x19A0FA-0x19A992` |

29 files, 105,170 bytes. The award pictures and the cup are 67,578 bytes of that. Dropping awards and the cup (section 8) leaves 15 files and 37,592 bytes.

How they are built. `tools/extractAssets94.js` accepts only `lst/nhl94.bin` and writes `Extracted/NHL94/`. Season slices are not in that ROM. A season extract step, run by the season prebuild and skipped by retail, reads `lst/nhl95.bin` (gitignored, SHA-1 `09e87b076aa4cd6f057a1d65bb50fd889b509b44`, 2,097,152 bytes) and writes `Extracted/NHL94/Season/` using the same slice-table style as `extractAssets94.js`. The new asm `incbin`s those paths. `Extracted/` stays gitignored. Retail prebuild does not ask for the 95 ROM.

## 6. Data differences

Both games have 26 clubs plus All-Stars East and All-Stars West. `TeamList` order is the same, and 94's `equals.inc` already numbers them:

`ANH BOS BUF CGY CHI DAL DET EDM FLA HFD LA MTL NJ NYI NYR OTW PHI PIT QUE SJ STL TB TOR VAN WSH WPG`, then `ASE` and `ASW`.

Ottawa's abbreviation is `OTW` in both. Quebec and Winnipeg are still in both. 95 did not add Colorado or Phoenix.

The schedule stores team numbers in that order, written as abbreviations. `Day NYR,BOS` is team 14 vs team 1. It assembles against 94's equates with no renumbering. `SimGoals*` rows follow the same order. All-Stars are not on the schedule and not in the standings.

Divisions, from `StandingsGroup0` through `StandingsGroup3` and the conference seed lists. These are the 1993-94 and 1994-95 alignments, so they describe 94's clubs:

| Group | Teams |
| --- | --- |
| Pacific (6) | ANH, CGY, EDM, LA, SJ, VAN |
| Central (6) | CHI, DAL, DET, STL, TOR, WPG |
| Northeast (7) | BOS, BUF, HFD, MTL, OTW, PIT, QUE |
| Atlantic (7) | FLA, NJ, NYI, NYR, PHI, TB, WSH |

West is Pacific plus Central (12). East is Northeast plus Atlantic (14). Playoff seeds take the top 8 of each. 94's `playoffseats` is a different table: 32 preset 16-team brackets for the password mode. Season standings do not read it. City and nickname strings, player lists, and abbreviations come from `teamdata94.asm` whenever a screen prints a name (`GetRosterName` walks `TeamList`).

`#$1A` in the season source is 26 clubs. `#$1C` in the demo team roller is 28, All-Stars included. Both numbers are already correct for 94.

## 7. ROM space

Retail is 1,048,576 bytes. The only pad is `dcb.b $100000-*,$FF` after `ValidationRoutine` (`$FFB10` through `$FFFFF`, 1,264 bytes). That pad cannot hold the feature.

| Piece | Bytes |
| --- | --- |
| Season flow, sim, calendar, standings (`season95` minus the demo labels) | ~16,500 |
| Schedule | 2,378 |
| Awards and playoff seeding | 4,842 |
| Cup screen | 674 |
| Season stats, leaders | ~8,900 |
| Highlights | ~1,640 |
| Roster readers and injury routines | ~1,500 |
| Hooks inside existing files | ~1,000 |
| Code subtotal | ~37,000 |
| Assets | 105,170 |
| Together | ~142 KB |

The season build appends this at `$100000` and pads to `$200000` (2 MB). `jsr (name).l` reaches it from the first megabyte. `bsr.w` does not, so every new call from an old file is a long `jsr`.

Header, season build only, in `SegaIDTable94.asm`:

- ROM end `$001FFFFF` (retail `$000FFFFF`).
- Battery end `$0020FFFF` (retail `$00203FFF`).
- Checksum word `$0000`, and `CHECKSUM=0` so `Start` skips `ValidationRoutine`.

`ValidationRoutine` sums the ROM only up to itself, so bytes at `$100000` would not change that sum. The hooks inside the first megabyte would. The retail target does not assemble the hooks, does not change the header, and does not append. `verify_all` on that target still MATCHes `lst/nhl94.bin`. The season image is not compared to the retail ROM.

`src/nhl94.asm` keeps the retail include list and the pad to `$100000`. Under `SEASON=1` it then includes the new files and pads to `$200000`. New files, 95 names: `schedule94.asm` is the wrong name for this data. The new modules keep the 95 file roles with a 94 suffix so they sit next to the rest of this repo: `src/season94.asm`, `src/schedule94.asm`, `src/awards94.asm`, and the season stat block in `src/seasonstats94.asm`. Names of routines inside them stay the 95 names.

## 8. Risks and open questions

1. **Battery size.** Recommended: `$8000` bytes in the season build, 95's layout from `SRSeasonHeader` up, 94's record blocks left where they are, lines moved to `SRLineData`. Alternate: stay inside the retail 8 KB. The free gap is about 4,310 bytes, enough for the header, the `$CCC` result bytes, and standings, and not enough for per-player stats, rosters, or playoff stat blocks. That alternate drops leaders, player stats, highlights, and multi-game injuries. A password is not a third option for the full season.
2. **Trades and Create Player.** Recommended out of this port. They are separate Play Mode lines in 95, with their own screens (`trade95.asm` 6,340 bytes, `create95.asm` 12,434 bytes) and their own save records. The season loop runs with `DefaultRosters` copied from `teamdata94`. Say if you want them in this branch.
3. **Awards and the cup.** Recommended in. `SeasonMain` always ends there, and they are about 68 KB of the assets. The port still boots and plays a season if we stop after the playoff tree and return to the title. Say if you want that cut.
4. **Multi-game injuries.** Recommended in, because SEASON SETUP has the line. One Game Only is the 94 behavior and can ship first if you want the injury chunk later.
5. **Highlights.** A season-menu item, about 1.6 KB plus a 646-byte header. Recommended in. Easy to drop without touching the rest.
6. **Big font.** First try is 94 `BigFontMap` for `BigFontMap2`. If the titles look wrong, bring the 4,514-byte 95 font.
7. **Cup song.** Recommended: play `SngEOG`. Bringing 95's song means porting a song out of the 95 driver, which this plan does not otherwise touch.
8. **2 MB season ROM.** Recommended. 142 KB fits in the extra megabyte with room. The retail file stays 1 MB.
9. **Two name clashes.** `AppendNumber` and `PrintCentered` already mean something else in 94. The season copies get `HighlightAppendNumber` and `AwardPrintCentered`. Any further clash found while porting follows the same rule and is logged in `docs/name_map.csv`.
10. **`Opening2` clears `$B000-$D03E`.** Season state that has to survive a game lives at `$FFFFDEF4` and in battery RAM. Putting it at the 95 addresses would overwrite the FM driver and the pad timers.
11. **Human-game re-entry.** `SeasonMain` jumps to `GameSetUp` with `GameFlags` bit 5 set. Getting that branch wrong would either show the exhibition menu mid-season or skip it for a normal game. Chunk 6 is the one that proves this, and it is the chunk to watch.
12. **Continue Season on a bad battery.** `ValidSRAM` already fails closed. Continue Season stays off the menu when the header length is 0, including after `ClearSRAM`.

## 9. Implementation steps

Each chunk is behind `SEASON=1`. After every chunk: retail `tools/verify_all.sh` prints MATCH, and the season target assembles to a 2 MB image whose header ROM end is `$1FFFFF`. The season build always passes `CHECKSUM=0`. New comments are plain English. No rename history, no source-file notes, no hardcoded ROM addresses. Routine names stay the 95 names. `docs/HANDOFF.md` is updated on this branch after each chunk. Anything still unclear after about 10 minutes goes on an Unsure list in that handoff and the chunk moves on.

1. **Flag and empty image.** `SEASON` defaults to 0 in `build94.bat`. `npm run build:season` sets `SEASON=1` and `CHECKSUM=0`. Header ROM end and the pad to `$200000` switch with the flag. No season code yet. Retail MATCH. Season image boots to the current title.
2. **RAM names.** Equates only, at `$FFFFDEF4` as in section 4. No ROM bytes change. Retail MATCH.
3. **Schedule.** `Day` macro, `schedule94.asm` at `$100000`, team equates already in `equals.inc`. No caller yet. Both targets build. Retail MATCH.
4. **Battery window.** Season-build `sram94` uses `$8000` and checksum `$7FFE`. Line block moves to `SRLineData`. Existing record offsets stay. Boot, confirm a retail-style save still loads exhibition records, and confirm a fresh season save clears.
5. **Menu lines.** New Season and Continue Season set `GameFlags` and return to the old menu. No season loop yet. Boot and move the cursor onto the new lines.
6. **Season setup and the header.** `SeasonSetup` through `WriteSeasonHeader` and `ClearSeasonData`. Start on New Season shows SEASON SETUP, Start stores the header, and the game returns to the menu. Continue Season appears on the next visit.
7. **Games today and the day loop.** `SeasonMain`, `GamesToday`, `BuildSeasonTeamList`, `NextSeasonDay`. Human and Computer toggles work. Play Games with every game set to Computer simulates the day (`SimDayGames`) and advances the date.
8. **One human game.** `GameSetUp` bit 5 branch, `SeasonGameOver`, `RecordGameResult`, `SaveSimGame`. Pick a human game, play it, and see the score on Games Today the next day.
9. **Standings and calendar.** `StandingsScreen`, `CalendarScreen`, `CountTeamGames`. Both update from the result just saved.
10. **Season stats.** Player stats, team stats, league leaders. `InitSeasonStats` and the stat writers are already in from chunk 8. This chunk is the screens.
11. **Playoffs.** `InitPlayoffs`, `SetupPlayoffs`, the series scheduler, `PlayoffTreeScreen` calling the existing `PlayoffScreen`. End the regular season and play a series through to a champion.
12. **Cup and awards.** `StanleyCupScreen` with `SngEOG`, then `SeasonAwards`, then back to the title.
13. **Injuries and highlights.** `SetInjuryGames` and the season menu highlights page. Multi-game injuries carry across days. Highlights shows the saved line from the last human game.
14. **Pass over the branch.** Retail MATCH again. Season build boots from a cold start, a new season, a continued season, a simulated day, a played game, the playoffs, and the cup.

Chunks 12 and 13 can swap or drop if you cut awards, the cup, or highlights in section 8. Chunks 1 through 11 are the season itself.
