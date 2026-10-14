# Season mode port plan (95G into 94G)

Phase 1 only. The decisions in section 8 are closed. No port code until that work is started separately.

Sources read for this plan:

- 94G `main` at `881e45c`. `SEGMENT_AGENT.md` ("Current rules (Oct 2026)"), `docs/HANDOFF.md`.
- 95G `main` at `518a1b0` (public repo, cloned read-only). `SEGMENT_AGENT.md` ("Current rules (Oct 2026)"), `docs/HANDOFF.md`, and the season, schedule, save, playoff, awards, stats, trade, create, and menu source.
- `START_HERE.md` is not in either repo on `main`. Nothing in this plan depends on a file that is not there.

This is a feature port. The season build will differ from the retail ROM. `main` stays untouched. Retail `npm run build:retail` keeps producing MATCH. The port lives behind `SEASON=1` on `feature/season-mode`.

95G calls the feature season mode. In 94G the menu line "Regular Season" is one exhibition game. The schedule, standings, and saved season are new.

## 1. What Season mode is

From the player's side, 95G season mode is a saved campaign around the existing game.

Power-on is the same shape as 94: title, then the game setup menu. 95's Play Mode list adds **New Season** and **Continue Season** beside Regular Game, the playoff modes, and Shootout. **Trade Players**, **Create Player**, **Sign Free Agents**, and **Release Players** are separate Play Mode lines. They are not items inside the season menu. This port includes those four lines, plus **Game With Trades**. They write the rosters and the created-player records that a season game reads. Practice Mode stays out.

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

**Play Games** simulates every Computer game that day, then sends each Human game through the normal path: the controller setup screen (which pad controls home or visitor), the scouting report, the game, the intermission. After the game the score, the standings, the player stats, and today's highlight are written to battery RAM and the season menu returns. A day with no human game is simulated in one step and the calendar advances.

When the last day is done the menu becomes **On To Playoffs**, plus standings, calendar, games today, leaders, and team and player stats. Playoffs seed the top 8 teams in each conference, 1 vs 8, 2 vs 7, 3 vs 6, 4 vs 5. West has 12 teams, East has 14, so 16 clubs play. Series length is whatever SEASON SETUP chose. The playoff menu is Play Games, Games Today, Team Stats, Player Stats, Playoff Team Stats, Playoff Player Stats, and Playoff Tree. The tree is the screen 94 already has: series scores, team blocks, pad scroll.

The champion's screen is the Stanley Cup, then nine awards (Hart, Norris, Vezina, Art Ross, Jennings, Pearson, Selke, Presidents', Conn Smythe), each with three finalists and a winner. Start leaves an award early. After the last award the game returns to the title and the setup menu. **Continue Season** reloads the battery header and resumes the saved day. A season game in progress is marked in battery RAM so a reset during the game comes back to the playoffs or the day correctly (`SRSeasonMark`).

**Create Player** is its own screen. The list holds 20 players, 32 bytes each. The letter grid takes a first and last name. A one-word name shows "Invalid Name" and does not save. Ratings come out of a point pool. Start writes the record and puts the player on the free-agent list. With all 20 slots full, the setup menu skips Create Player when the list is also empty, and a save attempt on a full list shows the full message.

**Sign Free Agents** puts one of those players on a club. The roster stops at 3 goalies, 15 forwards, and 15 defense. **Release Players** sends one back to the free-agent list and will not drop a club under its minimum. The team is chosen on that screen, not on the setup menu.

**Trade Players** starts on the setup menu with two clubs, which have to be different and in the 26-team list. The trade screen marks players on each side. An illegal trade shows the rules text and writes nothing. A legal one goes to the GM screen. Accept runs `ExecuteTrade`: the roster slots swap, and the lines, jersey numbers, injuries, and season stat blocks move with the players. Cancel writes nothing.

**Game With Trades** is one exhibition with the full setup lines (teams, period, goalies, user records, penalties, line changes). It uses the saved rosters, lines, jersey numbers, and injuries. It does not enter the season loop, and it does not write standings. Regular Season keeps the original team-data rosters. Password playoffs and Shootout keep those rosters too. A season game uses the saved rosters, the same way Game With Trades does.

A new season clears results and standings. It leaves rosters and created players alone. The battery-clear button rebuilds default rosters and clears created players.

Where it sits in 95's flow: `Begin` still runs the title. `Opening2` draws the setup menu (`GameSetUp`). Choosing a season sets `GameFlags` bit 3, and a new season also sets bit 4. `SeasonMain` then owns the loop. A human game sets bit 5 and jumps back into `GameSetUp`, which skips the menu and uses the season's period length, penalties, line changes, and the two clubs from today's list. `GameOver` writes the result (`SeasonGameOver`) and returns to `Opening2`, which calls `SeasonMain` again. The cup flag (`sflags13` bit 2) makes `GameOver` show the cup before that. After `SeasonMain` returns, `Opening2` tests `sflags10` and jumps to `TradePlayers` (bit 2), `CreatePlayer` (bit 4), `SignFreeAgents` (bit 5), or `ReleasePlayers` (bit 6). Each of those screens jumps back to `Opening2` when it is done.

94's matching loop is `Opening2` in `setup94.asm`: `GameSetUp`, name entry, the playoff screen, the scouting report, `StartGame`. `GameOver` runs `EncodePW` (the playoff password) and the playoff screen, then `ExitToOpening`. Exhibition, password playoffs, and the shootout stay on that path. Season is a branch beside them.

NHL 95 inserts **controller setup** (`SetContTeams` in `engine/goal95.asm`) on `Opening2` after the setup menu and season or trade screens return, and before name entry and the playoff tree. Home and visitor on the ice stay whatever `HomeTeam` and `VisTeam` already are; the player assigns `cont1team` through `cont4team` on a full-screen UI. The port adds that step for every mode that is about to play a real game (see chunk 16). `ControllerBgMap` alone is not that screen; it is only the backdrop reused on several menus.

## 2. Code to bring over

Counts below are global labels (routines and the tables they own). Locals are not counted. A straight port is source that assembles against 94 once the new RAM names and the new assets exist. An adaptation calls a 95-only service, or collides with a 94 name that means something else. A replacement is a 94 routine that already does the job, so the 95 copy is not copied.

| Class | Labels |
| --- | --- |
| Straight port | 608 |
| Adaptation | 30 |
| Replaced by a 94 routine | 92 |

The 30 adaptations are 8 copied routines that need a change (`StanleyCupScreen`, `PrintCentered`, `AppendNumber`, `setInjuryType`, `CheckInjury`, `SaveTeamLines`, `CopyTeamLines`, `TeamLinesOffset`), the 8 save-RAM routines, and 14 existing hooks (`GameSetUp`, `FixModeOptions`, `SetupStart`, `Opening2`, `GameOver`, the period-end cup flag, `ReadLineData`, `WriteLineData`, `InitTeamStructure`, `GetPlayerName`, `GetPlayerCount`, `GetGoalieCount`, `GetForwardCount`, `GetDefenseStart`). The 92 replacements are the demo readers, the playoff tree screen, the stats, period, line-editor, and three-stars screens, four injury helpers, the three unused leader builders, the title, credits, and high-score labels in `title95.asm`, and `NameEntryFramer` (the same routine `records94` already has). `GetRosterName` and `GetCreatedName` are straight ports now that Create Player is in. Left out on purpose: `PrintOverallRating` in `create95.asm` (unreferenced, and `cards94` already owns that name) and Practice Mode.

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

### Controller setup (`engine/goal95.asm`, about 1,630 bytes, 11 labels)

Straight port from the 95 goal module (listed in 95's `FILE_ORIGINS.md` as new in 95): `SetContTeams`, `ControllerSetupScreen`, `DrawPadSetup`, `DrawPadIcon`, `DrawPadCursor`, `DrawSetupTeamBlock`, `PrintSetupStr`, `PrintSetupStrHi`, `ReadAllPads`, `PrintPracticeTitle`, `PrintPracticePlayers`, `PrintPlayerCount`. Practice-only pieces (`PrintPracticeTitle`, `PrintPracticePlayers`, `PrintPlayerCount`) stay in the file but are not wired; Practice Mode remains out of scope.

**Hook (adaptation):** `setup94` `Opening2` calls `jsr (SetContTeams).l` after `GameSetUp` returns and before `UserNameEntry`, matching `hockey95.asm` in 95. That path covers Regular Season, Game With Trades, Shootout, password Continue and New Playoffs, and human season games (including when `GameSetUp` skipped the menu and fell through `maketree` back to `Opening2`). Skip the screen when `SetContTeams` would clear all pads (demo / no game), same as 95. Do not swap `HomeTeam` and `VisTeam` to let the player pick a side; only set `cont1team` through `cont4team`. Season human games must not hard-code `OptNOP` to One - Home only; either honor the last menu choice from exhibition-style setup where the menu still ran, or default pads from `HomeTeam` / `VisTeam` and let the player change them on this screen.

**Replaced by 94 today:** pad assignment on the game setup menu (`ReadSetupPads` plus `FigureJoy` on A/B/C) remains for players who use the menu, but it is not sufficient for season games that skip the menu.

### Injuries (`front/injury95.asm`)

Straight port: `SetSeasonInjuries`, `TickTeamInjuries`, `TickInjuries`, `SetInjuryGames`, `GetInjuryGames`, `InsertInjurySlot`, `DeleteInjurySlot`, `ClearPowerPlay`.

Adaptation: `setInjuryType` (a season injury stores a games-out count) and `CheckInjury` in `hockey94.asm` (call `SetInjuryGames` when the season header says multi-game). `restoreteams` / the lineup build calls `SetSeasonInjuries` when `GameFlags` bit 3 is set, the way `players95` does.

Replaced: `getFgtbyte`, `chkFgtBit1` (`title94`), `updatepwrplay`, `GetLowestPen` (`penalty94`).

### Rosters and trades (`front/trade95.asm`, 6,340 bytes, 48 labels)

Straight port, the whole file. Roster storage: `DefaultRosters`, `GetRosterId`, `GetCreatedName`, `GetRosterName`, `GetRosterNameTail`, `ReadTeamRoster`, `WriteTeamRoster`, `GetJerseyNumber`, `FixJerseyNumber`. The trade itself: `ExecuteTrade`, `TagTradePositions`, `ShiftTradeUp`, `ShiftTradeDown`, `ExtractTradedPlayer`, `FixLinesRemoved`, `InsertTradedPlayer`, `FixLinesInserted`, `TeamRecordSRAM`, and the two `TradeCountOffsets` tables. The screens: `TradePlayers`, `BuildTradeRoster`, `DrawHomeTradeRoster`, `DrawVisTradeRoster`, `DrawTradeRosterRows`, `DrawTradeLogo`, `TradeGfx`, `ReadTradePads`, `TradeDone`, `TradeExit`, `CheckTrade`, `CountChosen`, `BuildTradeList`, `EvaluateTrade`, `PrintTradeNames`, `ReadEvalTradePads`, `GMDecisionScreen`, `GMDecisionGfx`, `PrintTradedPlayers`, `ReadGMDecisionPads`, `TradeValue`, plus `InvalidTradeText`, `TradeRulesText`, `PositionLetters`, `PositionLetters2`, `TradeRatingSteps`, `TradeRatingValues`, and `rtsTrade`.

`GetRosterName` reads `TeamList` when `sflags11` bit 6 is set, and `SRRosters` when that bit is clear. Bit 6 is set for Regular Season, password playoffs, and Shootout. It is clear for Game With Trades and for a season game. 95 clears it for every mode except Regular Game. This port keeps it set for the password playoffs and the shootout, so those modes stay on `teamdata94`. Team `$1C` is the free-agent list. A roster id of `$1E00` is a created player, and `GetCreatedName` loads that record from `SRCreatedPlayers`. `ExecuteTrade` updates rosters, lines, jerseys, injuries, and the stat blocks, then writes the checksum.

Straight port, the saved-roster helpers Game With Trades and a season game share: `LoadTeamLines` (`lines95.asm`), `GetPlayerCountD7`, `GetGoalieCountD7`, `GetForwardCountD7`, `GetDefenseStartD7`, and `SeasonPlayerOut`. The 94 count routines call the `D7` versions when bit 6 is clear. `SeasonPlayerOut` is how a roster slot marked out stays off the ice. `InitTeamStructure` calls `LoadTeamLines` in that same case and copies `teamdata94` lines when bit 6 is set.

`ClearSRAM` in the season build calls `DefaultRosters`, `DefaultLineData`, and `ClearCreatedPlayers` before it writes the `$8000` image. `DefaultLineData` (one routine in `lines95.asm`) copies each club's default lines from `TeamList` into the RAM image at `SRLines`. 94 has no routine that fills that block. It is a straight port. `NullSaveClear` in 95 is an empty return and is not copied.

### Create Player, sign, and release (`front/create95.asm`, 12,434 bytes, 187 labels)

Straight port, 185 labels. The screen: `CreatePlayer`, `CreateScreenGfx`, `CreateRatingsGfx`, `DrawCreateList`, `ReadCreatedPlayers`, `ModifyRatings`, `CommitCreatedPlayer`, and the rating editors and field tables (`FieldSpeed` through `EditChecking`, `SkaterFieldTbls`, `GoalieFieldTbls`, the label lists). The name grid: `NameEntry`, `NameEntryBg`, `NameEntryDone`, `CreateLetterGrid`, `GetCreateName`, `SaveCreateName`, `SaveNewName`, `InvalidName`, `BuildEnteredName`, `FormatNameRecord`, `NewCreateRecord`, `InitCreateRecord`. This `NameEntry` is the create-player grid. 94's `NameEntryScreen` stays the record-holders screen.

Sign and release: `SignFreeAgents`, `BuildFreeAgentList`, `DrawFreeAgents`, `CheckMaxGoalies`, `CheckMaxForwards`, `CheckMaxDefense`, `FreeAgentViolation`, `ReleasePlayers`, `DrawReleaseRoster`, `CheckMinGoalies`, `CheckMinForwards`, `CheckMinDefense`, `ReleaseViolation`, `DeleteCreatedPlayer`, `CheckCreateSlots`, `ClearCreatedPlayers`, `GetCreatedId`, `ReadCreateList`, `WriteCreateList`.

Replaced by `records94`: `NameEntryFramer`. The body is the same three instructions, and 94 already has the name.

Not copied: `PrintOverallRating`. 95 marks it unreferenced, and `cards94` already uses that name for the player-card rating.

### Hooks into game start and game end

These are edits to 94 routines, also counted in the adaptation total:

| 94 routine | Change under `SEASON=1` |
| --- | --- |
| `optsetup94` `GameSetUp`, `FixModeOptions`, `SetupStart`, the Play Mode strings | Append Game With Trades, New Season, Continue Season, Trade Players, Create Player, Sign Free Agents, and Release Players. Those are `OptPlayMode` 5 through 11. 95's mode numbers are not copied, because 94's 0 through 4 already mean Regular Season, Continue Playoffs, New Playoffs, New Playoffs/7 game, and Shootout. `SetupStart` sets `GameFlags` bits 3 and 4 for the season lines and `sflags10` bits 2, 4, 5, and 6 for trade, create, sign, and release. Game With Trades clears `sflags11` bit 6 and does not set `GameFlags` bit 3. On a human season game (`GameFlags` bit 5), skip the menu and take period, penalties, lines, and the two teams from the season header and `SeasonTeams`. |
| `setup94` `Opening2` | After `GameSetUp`, `jsr SeasonMain`. Then, on the `sflags10` bits above, jump to `TradePlayers`, `CreatePlayer`, `SignFreeAgents`, or `ReleasePlayers`. A human game comes back through `GameSetUp` with bit 5 set. After `GameSetUp` returns and before `UserNameEntry`, `jsr (SetContTeams).l` (chunk 16). |
| `setup94` `GameOver` | After `EncodePW`, `jsr SeasonGameOver`. `EncodePW` already returns immediately for a non-playoff mode. |
| `hockey94` period end / `clockcont_0` | When the last playoff series ends, set `sflags13` bit 2 and `cupwinner` so `GameOver` shows the cup. |
| `title94` `ReadLineData`, `WriteLineData` | Season build uses offset `SRLineData`. |
| `sram94` the eight routines above | `$8000` bytes, checksum at `$7FFE`. Season `ClearSRAM` calls `DefaultRosters`, `DefaultLineData`, and `ClearCreatedPlayers` before the write. |
| `setup94` `InitTeamStructure` | Game With Trades and a season game call `LoadTeamLines` and take players through `GetRosterName`. Regular Season, password playoffs, and Shootout still copy `teamdata94`. |
| `data94` `GetPlayerName` | Game With Trades and a season game call `GetRosterName`. The other modes still walk `TeamList`. |
| `stats94` `GetPlayerCount`, `GetGoalieCount`, `GetForwardCount`, `GetDefenseStart` | Game With Trades and a season game take the counts from `SRRosters`. The other modes still read the team-data nibbles. |

`Begin`, the title screen, `StartGame`, the scouting report, and the intermission stay. `AddPlayoffTeamStats` in `data94.asm` remains the password-playoff stat packer. Season player totals go through `SaveSimGame` and `AddPlayerSeasonStats`.

## 3. Hooks in 94

Same edits as the table above, from the player's path:

1. **Setup menu** (`optsetup94`). Retail Play Mode values stay Regular Season, Continue Playoffs, New Playoffs, New Playoffs/7 game, Shootout. The season build appends, in order, Game With Trades, New Season, Continue Season, Trade Players, Create Player, Sign Free Agents, Release Players. Those are `OptPlayMode` 5 through 11. Continue Season is skipped when the battery header is empty (`SeasonLength` 0) or the battery is invalid. Create Player is skipped when all 20 slots are full and no created player is stored. Game With Trades shows the same lines as Regular Season and clears `sflags11` bit 6. Trade Players shows the mode plus the two team lines, and the two clubs are kept different. Create, Sign, and Release show the mode line only. The team for a signing or a release is chosen on that screen. Choosing New Season sets `GameFlags` bits 3 and 4. Continue Season sets bit 3 only. Trade, Create, Sign, and Release set `sflags10` bits 2, 4, 5, and 6.
2. **After the menu** (`setup94` `Opening2`). `SeasonMain` runs while bit 3 is set. It returns only when it is about to start a human game or the season is over. The `sflags10` bits then enter the trade, create, sign, or release screen. Those screens return to `Opening2`.
3. **Game setup for a season game.** `GameSetUp` sees bit 5, copies `SeasonPerlen`, `SeasonPen`, and `SeasonLine` into the option words, and sets `HomeTeam` and `VisTeam` from the selected `SeasonTeams` entry (schedule home and away). Controller setup runs on `Opening2` before name entry so the player can take the visitor when their club is away. Then name entry, the scouting report, and `StartGame` run as they do now. `InitTeamStructure`, the roster counts, and `GetPlayerName` read the saved roster for that game. Game With Trades takes the same roster path and then the normal exhibition path, with the two clubs from the menu.
4. **Game end** (`setup94` `GameOver`, and the period-end path in `hockey94`). `SeasonGameOver` writes the score into the day's record, updates standings, and calls `SaveSimGame`. The cup flag sends the champion to `StanleyCupScreen` before `SeasonMain` runs the awards.
5. **Playoffs.** `PlayoffTreeScreen` feeds the existing `PlayoffScreen`. The password tree (`playoffseats`, `EncodePW`) is unchanged and still serves Continue Playoffs and New Playoffs.
6. **Stats screens.** The pause-menu stats, period stats, line editor, and three stars stay the 94 screens. The season menu calls the new season screens. No change to the pause menu is required for the season to be playable. Season player names come from `GetRosterName`.
7. **Injuries.** `CheckInjury` and `setInjuryType` gain a season branch. One Game Only keeps today's "out for the game" behavior. A trade moves the injury nibble with the player.

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

**Decision:** the season build widens battery RAM to `$8000` data bytes, header end `$0020FFFF`, the same window 95 declares. Emulators and flash carts size the save from the header. A real NHL 94 cart has the 8 KB chip, so that cart would keep exhibition records only. Retail build keeps `$203FFF` and `$2000`.

The 8 KB gap is about 4,310 bytes. Trades, created players, and free agents need `SRRosters` (`$38` a team), the line sets, the jersey numbers, and `SRCreatedPlayers` (20 records of `$20`). Those records sit past the gap. A season that kept the retail battery would have to drop trades and Create Player. They are in, so the season build uses the 32 KB window.

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
| `SRFreeAgentJerseys` | `$5A80` | Jersey numbers of the free-agent slots |
| `SRCreatedPlayers` | `$5AA0` | 20 created-player records, `$20` each |
| `SRCreateCount` | `$5D21` | How many created players are stored |
| `SRFreeAgentList` | `$5D22` | Free-agent roster ids, 2 bytes a slot |
| `SRFreeAgentCount` | `$5D57` | How many free agents are unsigned |
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
| `sflags10` | Bit 2 Trade Players, bit 4 Create Player, bit 5 Sign Free Agents, bit 6 Release Players. 95's address is `padword3` in 94, so this byte lives here |
| `CreatedPlayerBuf` | The `$20` byte record `GetCreatedName` reads out of `SRCreatedPlayers`. Callers use it immediately, including during a game, so it stays in this block |
| `sflags11` | Bit 0 previous day, bit 1 cup day, bit 2 inside `PlayoffScreen`, bit 3 playoff stat page, bit 5 end-of-season menu, bit 6 use team data (set for Regular Season, password playoffs, and Shootout; clear for Game With Trades and a season game) |
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

Trade and create scratch uses that same overlay, and only while those screens are up: `TradeBuf`, `TradeData`, `TradeWork`, `TradeRoster1`, `TradeRoster2`, `RosterRatings`, `CreatedIds`, `createdcount`, `CreateListTop`, `CreateListSel`, `CreateRecord`, `CreatePoints`, `CreateType`, `CreateCursorX`, `CreateCursorY`, `CreatedList`, `NameEntryMode`, `NameEntryLen`. 95's addresses for these sit on top of 94's pad timers, the FM driver, and `namelogsel`. The port gives them new addresses in the overlay. Create-player name entry does not use 94's `namelog` or `namelength`.

One case keeps 95's low-RAM offsets. Season `ClearSRAM` zeros the first `$8000` bytes of `M68K_RAM` and writes that image to battery RAM. `DefaultRosters` builds `RosterTable` at `M68K_RAM+SRRosters`, `DefaultLineData` writes `M68K_RAM+SRLines`, and `ClearCreatedPlayers` writes `M68K_RAM+SRFreeAgentList`, so the dump lands on the right save records. Those three equates are the SRAM offset plus `M68K_RAM`. The screens can reuse the same storage after that, because a trade or a create returns to the menu before a game starts. `CreatedPlayerBuf` is the exception and stays at `$FFFFDEF4`, as listed above.

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
| `SmallFontMap`, `Teamblocksmap`, `BigFontMap` | The same three on the trade, create, GM, and free-agent screens | Those screens remap `SmallFontMap`, draw team blocks, and title with the big font. Same reuse rule as the season screens |
| `NameEntryScreen`, `NameEntryFramer`, the name log | 94's record-holders name entry | Create Player has its own grid (`NameEntry`). The record-holders screen stays |

In-game rinks, sprites, crowds, and the pause screen are unchanged and stay the 94 files.

### Brought over from 95

94 has no games-today screen, no calendar, no season standings background, no award art, and no cup picture. Sizes are the spans in `tools/extractAssets95.js`.

| 95 asset | Bytes | Why 94 has nothing for it | Extraction |
| --- | --- | --- | --- |
| `ControllerBgMap.map.jim` | 3,950 | Full-screen background for setup, options, standings, and controller setup. `SetupMenuMap` is the small options frame | Slice `0x164AC8-0x165A36` |
| `ControllerTitleMap.map.jim` | 734 | Controller setup title art | `0x16AA7C-0x16AD5A` |
| `PadCursorMap.map.jim` | 856 | Pad cursor on controller setup | `0x16AD5A-0x16B0B2` |
| `PadIconMap1.map.jim` through `PadIconMap4.map.jim` | 278 each | Pad icons for ports 1–4 | `0x16B0B2-0x16B50A` (four consecutive spans in 95 `extractAssets95.js`) |
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
| `CreateBgMap.map.jim` | 10,446 | Create Player page. 94's name-entry art is the record-holders screen | `0x1703FE-0x172CCC` |
| `NameEntryBgMap.map.jim` | 226 | The create-player letter-grid background | `0x1834F4-0x1835D6` |
| `TradeBgMap.map.jim` | 5,070 | Trade Player page | `0x172CCC-0x17409A` |
| `GMDecisionMap.map.jim` | 804 | GM decision page | `0x180D54-0x181078` |
| `TradeAdvantageMap1.map.jim` | 3,448 | Which side the trade favors | `0x18277C-0x1834F4` |
| `TradeAdvantageMap2.map.jim` | 3,192 | The other advantage panel | `0x181B04-0x18277C` |
| `FreeAgentMap1.map.jim` | 1,662 | Sign Free Agents page | `0x181486-0x181B04` |
| `FreeAgentMap2.map.jim` | 1,038 | Release Players page | `0x181078-0x181486` |
| `Framermap.map.jim` | 448 | Frame tiles those screens load. 94's `FramerMap` is the in-game frame (120 bytes) and `SetupFramerMap` is the options frame. The symbol `Framermap` would collide with `FramerMap`, so the brought file is named `CreateFramerMap` | `0x14C148-0x14C308` |

42 files for season plus controller UI (controller title, cursor, and four pad icons add about 2,146 bytes beyond the prior 38-file list). Total brought art is about 133,650 bytes. The award pictures and the cup are 67,578 bytes of that. The trade and create art is 26,334 bytes. Dropping awards and the cup (section 8) leaves 28 files and about 66,072 bytes.

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

`#$1A` in the season source is 26 clubs. `#$1C` in the demo team roller is 28, All-Stars included. Both numbers are already correct for 94. `GetRosterName` also uses team number `$1C` as the free-agent list, one past the All-Star teams.

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
| Injury routines | 1,406 |
| Rosters, trades, and the GM screen (`trade95`) | 6,340 |
| Create Player, sign, and release (`create95`) | 12,434 |
| Default lines for a fresh battery (`DefaultLineData`) | under 100 |
| Hooks inside existing files | ~1,200 |
| Code subtotal | ~56,000 |
| Assets | 131,504 |
| Together | ~187 KB |

The season build appends new code at the 1 MB boundary. On `feature/season-mode` today that is a fixed `SEASON=1` pad to `$200000` (2 MB). **Next (chunk 15):** merge `main`, which adds the mod-safe ROM expansion (`RomEnd`, auto pad to 1 / 1.5 / 2 / 4 MB, `absjsr` / `absjmp`, checksum patch step). Reconcile the season image with that layout so retail still MATCHes and the season target still lands at 2 MB (or grows with content) without duplicating incompatible pad logic. `jsr (name).l` reaches the second megabyte from the first. `bsr.w` does not, so every new call from an old file is a long `jsr`.

Header, season build only, in `SegaIDTable94.asm`:

- ROM end `$001FFFFF` (retail `$000FFFFF`).
- Battery end `$0020FFFF` (retail `$00203FFF`).
- Checksum word `$0000`, and `CHECKSUM=0` so `Start` skips `ValidationRoutine`.

`ValidationRoutine` sums the ROM only up to itself, so bytes at `$100000` would not change that sum. The hooks inside the first megabyte would. The retail target does not assemble the hooks, does not change the header, and does not append. `verify_all` on that target still MATCHes `lst/nhl94.bin`. The season image is not compared to the retail ROM.

`src/nhl94.asm` keeps the retail include list and, on stock `main`, pads to 1 MB. Under `SEASON=1` it includes the new files after the 1 MB fill. New files, 95 names: `schedule94.asm` is the wrong name for this data. The new modules keep the 95 file roles with a 94 suffix: `src/season94.asm`, `src/schedule94.asm`, `src/awards94.asm`, `src/trade94.asm`, `src/create94.asm`, `src/seasonstats94.asm`, and `src/controller94.asm` (or the same routines in `goalie94.asm` if that matches 94 layout). Names of routines inside them stay the 95 names. `Framermap` is the exception in section 5: the asset is `CreateFramerMap`.

## 8. Decisions

Confirmed:

1. **Battery.** Season build uses `$8000` bytes, 95's layout from `SRSeasonHeader` up, 94's record blocks left where they are, lines at `SRLineData`. Retail stays `$2000`.
2. **Sign Free Agents and Release Players.** In, with Create Player and Trade Players.
3. **Game With Trades.** In. One exhibition on the saved rosters. Regular Season, password playoffs, and Shootout stay on `teamdata94`.
4. **Practice Mode.** Out.
5. **Awards and the cup.** In.
6. **Multi-game injuries.** In.
7. **Highlights.** In.
8. **Big font.** Try 94 `BigFontMap` for `BigFontMap2`. Bring the 4,514-byte 95 font if a title decompresses wrong.
9. **Cup song.** `SngEOG`.
10. **Season ROM.** 2 MB. Retail stays 1 MB and MATCHes.
11. **Play Mode order.** Existing five lines keep their numbers. Appended order: Game With Trades, New Season, Continue Season, Trade Players, Create Player, Sign Free Agents, Release Players.
12. **Names.** 94 keeps `AppendNumber`, `PrintCentered`, `FramerMap`, `NameEntryFramer`, and `PrintOverallRating`. Season copies are `HighlightAppendNumber` and `AwardPrintCentered`. The brought frame is `CreateFramerMap`.
13. **Where the new RAM lives.** Persistent season state is at `$FFFFDEF4`. Menu scratch overlays the replay buffer at `$FFFF0000`. Existing 94 variables stay where they are.
14. **Roster flag.** `sflags11` bit 6 selects team data. Clear selects `SRRosters`, for Game With Trades and season games.
15. **Chunk order.** Create, sign, release, and the trade screen are chunks 6 through 8. Game With Trades is chunk 9, the first on-ice check. Cup and awards stay after the playoffs. Injuries and highlights follow the cup. **Next work on the branch:** chunk 15 merges `main` (ROM expansion). Chunk 16 ports controller setup. Playoffs resume at chunk 17.
16. **Controller setup.** Port 95 `SetContTeams` and its screen. Run it from `Opening2` for every mode that starts a real game (Regular Season, Game With Trades, Shootout, password playoffs, human season and playoff games). Practice Mode stays out. RAM for `padcursorchars` and `padiconchars1` through `padiconchars4` during that screen must not collide with 94 in-game names; reuse 95's overlay scheme or equate to season menu scratch where safe.
17. **ROM expansion on `main`.** Before more feature chunks, merge the latest `main` (mod-safe build: `RomEnd`, sized pad, `absjsr` / `absjmp`, `patchchecksum.js`, `LONGBRA`, extra data at 1 MB). Resolve conflicts on `nhl94.asm`, `build94.bat`, `genesis.mac`, and SRAM layout docs (`ADDING_A_TEAM.md`). Retail `verify_all` must still MATCH. Season build must still assemble and keep header SRAM end `$0020FFFF` for the season battery window.

`$FFFFDEF4` holds `GameFlags`, `sflags9` through `sflags13`, the season header image, `SeasonTeams`, `CreatedPlayerBuf`, and the small screen cursors that have to survive a game. That block is about 1 KB. `Begin` clears through `$DEF3`, so a power-on zeros it. `Opening2` clears only through `$D03E`, so the block survives from one game to the next. The stack stays at `$FFFFFFFE`. `$FFFFF000` and above stay stack.

Menu scratch (`TradeBuf`, the trade rosters, the create list, award and leader sorts) overlays `$FFFF0000` while that screen is up. Those screens return to the menu before a game. `ClearSRAM` is the one case that keeps 95's low offsets: `RosterTable`, the line image, and the free-agent list sit at `M68K_RAM` plus their save-RAM offsets so the `$8000` dump lands on the right records. `CreatedPlayerBuf` stays in the `$DEF4` block because `GetCreatedName` runs during a game, while the replay buffer holds that game.

The 95 addresses stay unused. 95's `GameFlags` is `$FFFFBF08`, which in 94 is `bholdtimer34`. 95's `SeasonStartDay` is `$FFFFD1A4`, which in 94 is `fm_voice_usage_table`. Those bytes stay the pad timers and the FM driver. Retail `SEASON=0` does not assemble the new equates into the ROM, and the season build does not move any existing 94 variable.

Watch items, not choices:

- `SeasonMain` jumps to `GameSetUp` with `GameFlags` bit 5 set. Chunk 12 proves a human season game skips the menu, and that a normal game still shows it. Chunk 16 proves the same game can assign pad 1 to the visitor when that club is away.
- `ValidSRAM` fails closed. Continue Season stays off the menu when the header length is 0. The battery-clear button rebuilds default rosters and wipes created players.
- A wrong `sflags11` bit 6 puts a traded player into Regular Season, or leaves Game With Trades on the original roster. Chunks 8 and 9 prove both sides.

## 9. Implementation and test plan

Each chunk is behind `SEASON=1`, builds, and can be played or checked on its own before the next one starts. After every chunk: retail `tools/verify_all.sh` prints MATCH, and the season target assembles to a 2 MB image whose header ROM end is `$1FFFFF` and whose checksum word is `$0000` (until chunk 15 reconciles sizing with `RomEnd` on `main`). The season build always passes `CHECKSUM=0`. From the menu chunk on, the same boot also starts Regular Season, New Playoffs, and Shootout far enough to reach the next screen, so a bad mode number shows up immediately. New comments are plain English. No rename history, no source-file notes, no hardcoded ROM addresses. Routine names stay the 95 names. `docs/HANDOFF.md` is updated on this branch after each chunk. Anything still unclear after about 10 minutes goes on an Unsure list in that handoff and the chunk moves on.

**Branch status (`feature/season-mode`):** chunks 1 through 16 are implemented. **Do chunk 17 next** (playoffs), then 18 through 20 below.

Trades and Create Player land before the season loop. They only need the menu and the battery. A created player is reviewed on the create screen, then on the sign screen, then on the ice in Game With Trades, then again in the first human season game.

1. **Flag and empty image.** `SEASON` defaults to 0 in `build94.bat`. `npm run build:season` sets `SEASON=1` and `CHECKSUM=0`. Header ROM end and the pad to `$200000` switch with the flag. No season code yet. **Proves:** retail MATCH. The season image boots to the current title. The Play Mode list is unchanged.

2. **RAM names.** Equates only, at `$FFFFDEF4` and in the menu overlay, as in section 4. **Proves:** retail MATCH. The season image still boots to the current title.

3. **Schedule.** `Day` macro, `schedule94.asm` at `$100000`, team equates already in `equals.inc`. No caller yet. **Proves:** both targets build. Boot looks the same as chunk 2.

4. **Battery window.** Season-build `sram94` uses `$8000` and checksum `$7FFE`. Line block moves to `SRLineData`. Record, crowd, team, and name-log offsets stay. The season save names exist. `ClearSRAM` can call `DefaultRosters` and `DefaultLineData` once those routines exist in chunk 8; until then the new area is zero. **Proves:** cold boot. Exhibition records and the name log still load. The existing clear-battery button still clears them. A second boot after a good save still validates. `build:retail` still uses the 8 KB window and MATCHes.

5. **Menu lines.** Append the seven lines. `SetupStart` sets the flags. Choosing a new line returns to the menu, except Game With Trades, which has no screen of its own and waits for chunk 9 before it starts a game. Until then, Start on Game With Trades returns to the menu too. **Proves:** the cursor reaches Game With Trades, New Season, Continue Season, Trade Players, Create Player, Sign Free Agents, and Release Players. Continue Season is skipped when no header is stored. Start on each new line returns to the menu and does not drop into a game. Regular Season still reaches the scouting report. Continue Playoffs and New Playoffs still reach the password tree. Shootout still starts. Record holders and the old name entry still open.

6. **Create Player.** `create94.asm`: the list, the letter grid, the rating pool, and the save into `SRCreatedPlayers` and `SRFreeAgentList`. **Proves:** enter a first and last name, set ratings, Start. Power cycle and the player is still in the list. A one-word name shows Invalid Name and does not add a record. The 20th player fills the list, and another save shows the full message. Leaving without Start adds nothing. The record-holders name entry still stores a user name.

7. **Sign Free Agents and Release Players.** The rest of `create94.asm`. **Proves:** sign the player from chunk 6 onto a club. A side that already has 3 goalies, 15 forwards, or 15 defense refuses another of that position. Release puts the player back on the free-agent list and refuses to drop a club under its minimum. Power cycle keeps the signing. Cancel writes nothing.

8. **Trade Players.** `trade94.asm`, including `DefaultRosters`, `GetRosterName`, `GetCreatedName`, and `ExecuteTrade`. `ClearSRAM` now rebuilds default rosters and default lines, and clears created players. **Proves:** two different clubs. An illegal selection shows the rules text and the rosters are unchanged after a power cycle. A legal trade reaches the GM screen. Accept swaps the players, and a power cycle still shows the swap. Cancel on the GM screen leaves the old rosters. The created player from chunk 7 can be one side of the trade once that player is signed. The battery-clear button restores the default rosters and removes the created player. On-ice proof waits for chunk 9.

9. **Game With Trades.** The menu line starts a game. `LoadTeamLines`, `SeasonPlayerOut`, and the roster-count helpers run when `sflags11` bit 6 is clear. **Proves:** after the trade in chunk 8, Game With Trades with those two clubs shows the swapped players on the ice and in the names, including a signed created player. Quit and start Regular Season with the same clubs: the original team-data roster is back. New Playoffs and Shootout also stay on the original roster. A Game With Trades score does not create a season header, so Continue Season stays hidden.

10. **Season setup and the header.** `SeasonSetup` through `WriteSeasonHeader` and `ClearSeasonData`. **Proves:** New Season shows SEASON SETUP. Start stores the six lines and returns to the menu. Continue Season is present on the next visit and after a power cycle. The trade and the created player from chunks 6 through 8 are still in the battery. New Season does not put the rosters back to the team-data defaults.

11. **Games today and a simulated day.** `SeasonMain`, `GamesToday`, `BuildSeasonTeamList`, `NextSeasonDay`, `SimDayGames`. **Proves:** A toggles Human and Computer. Left and right change the day. Play Games with every game on Computer advances the date, and the games-today list shows simulated scores. Play Until A Day can be cancelled and the day stays put.

12. **One human season game.** `GameSetUp` bit 5 branch, `SeasonGameOver`, `RecordGameResult`, `SaveSimGame`. The roster path is the one from chunk 9. **Proves:** set one game to Human and play it. Games Today shows that score the next day. The traded player and the signed created player are on the ice and in the names. Continue Season returns to the saved day. Regular Season with the same clubs still shows the original roster.

13. **Standings and calendar.** `StandingsScreen`, `CalendarScreen`, `CountTeamGames`. **Proves:** the game from chunk 12 changes that club's W, L, or T, and the calendar cell shows the opponent and the result. The other three division pages scroll. A simulated day from chunk 11 is on the calendar too.

14. **Season stats.** Player stats, team stats, league leaders. The stat writers are already in from chunk 12. This chunk is the screens. **Proves:** the human game is in the player line, the team line, and the leaders. The created player's line uses the name entered in chunk 6.

15. **Merge `main` (ROM expansion).** Pull or rebase the latest `main` into `feature/season-mode` and fix conflicts. Bring in mod-safe build support: `absjsr` / `absjmp`, auto ROM size pad and `RomEnd`, `tools/patchchecksum.js`, `LONGBRA` in `build94.bat`, and docs (`START_HERE.md`, `ADDING_A_TEAM.md`, `SEGMENT_AGENT.md` updates). Keep `SEASON=1` includes and season SRAM header behavior. **Proves:** retail `tools/verify_all.sh` MATCH. Season image still builds at 2 MB (or the size `RomEnd` selects). No duplicate or broken pad between the old fixed `$200000` season tail and the new 1 MB fill plus size pad.

16. **Controller setup.** Port `SetContTeams` and helpers from 95 `goal95.asm`. Add controller UI assets to `tools/extractSeasonAssets.js`. Hook `Opening2` as in section 3. Remove the season-only hard code of `OptNOP = 1` (One - Home) in `SeasonMain` `.play`, or override it after the player confirms on the controller screen. **Proves:** Regular Season and Game With Trades reach the new screen and pad 1 can be set to home or visitor. A human season game with the away team (for example NYR at BUF) lets pad 1 control the Rangers while `HomeTeam` / `VisTeam` stay schedule-correct. Four-way play assigns pads 3 and 4 when enabled. Demo timeout still clears pads without hanging. Password playoff modes unchanged.

17. **Playoffs.** `InitPlayoffs`, `SetupPlayoffs`, the series scheduler, `PlayoffTreeScreen` calling the existing `PlayoffScreen`. **Proves:** end the regular season. The menu becomes On To Playoffs. The tree is the top 8 of each conference, 1 vs 8. Play a series on the existing playoff screen through to a champion. The password playoff modes still use `playoffseats`.

18. **Cup and awards.** `StanleyCupScreen` with `SngEOG`, then `SeasonAwards`, then the title. **Proves:** the champion's cup screen, then the nine awards. Start leaves an award early. After the last award the title is back. Continue Season follows whatever 95 does with a finished header (the header length is what the menu tests).

19. **Injuries and highlights.** `SetInjuryGames` on the season branch of `CheckInjury`, and the highlights page. **Proves:** with Injuries set to Multi-game, a player hurt in one game is still out the next day, and a trade takes that injury with him. One Game Only clears it after the game. Highlights shows a line saved from the last human game.

20. **Full pass.** Retail MATCH again. One season image, from a cold start: create a player, sign that player, trade that player, play Game With Trades, start a season, simulate a day, play a day with a chosen pad side, read the standings, finish the playoffs, see the cup. Power cycle in the middle and Continue Season resumes the saved day.

Chunks 6 through 9 are reviewable before any season day exists. Chunks 1 through 5 are the shared floor: every later chunk still has a matching retail ROM and a bootable season image.
