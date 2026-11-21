# NHL 94: cartridge vs Sega CD differences

This page lists every difference found between the retail cartridge game and the Sega CD game code (`HOCKEY.BIN`), in gameplay first, then everything else. The short answer: the Sega CD plays the same game. Skating, puck physics, AI assignments, shooting, goalies, checking, penalties, line changes, period lengths and overtime are the same code. Three small code changes touch play, and the rosters drop 31 players with the lines rebuilt around them.

Each item is marked:

- **Verified**: the instructions or bytes were compared directly in both builds.
- **Inferred**: what the verified change does in a game, read from the code but not measured in play.

Cartridge source references are to this repo (`src/`). Disc source references are to the transcribed disc code in `src/segacd/hockey/` where it exists. Cartridge addresses are ROM addresses. Disc addresses are `HOCKEY.BIN` runtime addresses (file offset + `$1B000`).

Player names in this repo are placeholders (`P051` and so on, see `src/teamdata94.asm`), so this page names players by placeholder and roster number. The real names come from your own ROM when you build.

## Gameplay differences

### 1. Skaters accelerate slightly faster on the Sega CD (verified; effect inferred)

| | Cartridge | Sega CD |
| --- | --- | --- |
| Routine | `playeracc`, `src/engine/logic94.asm` 7489, `.incagl` at 7517-7518 | `playeracc`, `src/segacd/hockey/logic94cd.asm` 6319, lines 6344-6345 |
| Address | `$10C08`-`$10C16` | `$368C0`-`$368D4` |
| Code | `addq.b #2,d2` once | `addi.b #2,d2` twice (+4) |

The acceleration term is `$40 - weight/4 + legstr`, plus the "crowd meter boost", then halved (`asr.w #1,d2`) and multiplied into the stick direction. The boost is gated on `sflags8` bit 1 or `sflags7` bit 6. `SetSflags8Bit1` (`src/helpers94.asm` 5) always sets `sflags8` bit 1, and `updateplayers` calls it every update (`src/engine/logic94.asm` 37; disc `$2AE68`, called from `$2FA14`). So the boost applies to every skater on both teams, all the time.

Inferred effect: after the halving, every player's acceleration term is 1 unit higher on the Sega CD. Goalies take the same path (the +4 comes before the goalie doubling of `legstr` + `$10`). The top-speed code that follows (+2, capped at `$1E`) is unchanged.

### 2. A checked player bounces off the corners much more easily (bytes verified; effect inferred)

| | Cartridge | Sega CD |
| --- | --- | --- |
| Routine | `checkcornercoll`, `src/front/crowd94.asm` 109, compare at 149 | `checkcornercoll`, `src/segacd/hockey/crowd94cd.asm` 90, compare at 128 |
| Address | `$F703E`: `b6bc 0000 1000` | `$2302A`: `0c83 0000 0042` |
| Code | `cmp.l #$1000,d3` (corner radius 64, squared) | `cmpi.l #$42,d3` (radius about 8) |

`checkcornercoll` tests the distance squared from the corner circle's centre. At or under the threshold (`bls .exit`) there is no corner hit. The only caller is `wallcollduringcheck` (`src/front/cards94.asm` 232-245; disc call at `$24FEE`, `src/segacd/hockey/cards94cd.asm` 222). That routine runs for a skater being body-checked near the boards, with his box grown by `$17`.

Inferred effect: on the cartridge, a checked player gets the corner bounce only when he is pushed past the curve of the corner. On the Sega CD, he gets it almost anywhere in a corner zone. `$42` looks like a typo for the radius. The normal skater/wall collision in `wallcoll` keeps `$1000` in both (`src/engine/collide94.asm` 1057; disc `src/segacd/hockey/collide94cd.asm` 942).

### 3. Pad input during the penalty-shot box (verified)

| | Cartridge | Sega CD |
| --- | --- | --- |
| Routine | `doinput`, `src/engine/logic94.asm` 517, `.5` at 543-548 | `doinput`, `src/segacd/hockey/logic94cd.asm` 442, lines 463-476 |
| Address | `$B140`-`$B158` | `$3025C`-`$30292` |

`PenaltyShotBox` (`src/engine/setup94.asm` 2500) sets `gmode2` bit 7 while the PENALTY SHOT box (or, in Shootout mode, the shootout box) is shown.

- Cartridge: while the bit is set, a d-pad press calls `ShortenMsgTimer` (`src/engine/period94.asm` 753). The pad input then goes on to the player as normal.
- Sega CD: while the bit is set, bit 6 (the A button) is cleared in `d0`-`d3`. If the d-pad is pressed, it calls `ShortenMsgTimer` and then forces `d0 = 8` (no direction) and `d1 = d2 = d3 = 0`. The pad does nothing else during the box.

### 4. Rosters, lines and goalie counts (verified)

Both builds have the same 28 teams (26 NHL teams and the two All-Star teams). Florida and Anaheim are byte-identical. The disc drops 31 player records from 20 teams. 28 of them are players the cartridge also lists on Florida or Anaheim, so the cartridge has them twice. The other three (DAL #7, NYI #16, TOR #3) are not on any other team.

Every remaining player's record (name and all ratings) is byte-identical. The team `.sr` bytes 0-2 (simulated scoring odds, power play / penalty kill and home/visitor bonuses) are the same on all teams.

Removed players (cartridge roster number; G, F or D from the team's goalie and forward counts):

| Team | Removed |
| --- | --- |
| BOS | P072 #22 D |
| BUF | P091 #16 F |
| CGY | P106 #6 F, P124 #24 D |
| CHI | P136 #11 F |
| EDM | P177 #2 G, P191 #16 F |
| HFD | P205 #5 F, P224 #24 D |
| LA | P235 #10 F |
| DAL | P257 #7 F |
| MTL | P299 #24 D |
| NJ | P322 #22 D |
| NYI | P327 #2 G, P340 #15 F, P341 #16 F |
| NYR | P351 #1 G, P361 #11 F, P375 #25 D |
| PHI | P412 #12 F, P424 #24 D |
| PIT | P434 #9 F |
| QUE | P458 #8 F, P461 #11 F |
| SJ | P484 #9 F, P497 #22 D |
| STL | P502 #2 G, P510 #10 F |
| TB | P536 #11 F |
| TOR | P553 #3 G |
| VAN | P580 #5 F |

Unchanged: ASE, ASW, DET, OTW, WPG, WSH, FLA, ANH.

**Goalie counts.** `.godds` is one nibble per goalie, and `GetGoalieCount` (`src/front/stats94.asm` 2117) counts the nibbles. The changes are:

| Team | Cartridge | Sega CD | Goalies |
| --- | --- | --- | --- |
| EDM | `$D500` | `$D000` | 2 → 1 |
| NYI | `$9700` | `$9000` | 2 → 1 |
| NYR | `$9600` | `$9000` | 2 → 1 |
| STL | `$D400` | `$D000` | 2 → 1 |
| TOR | `$9610` | `$9600` | 3 → 2 |

The weights themselves are read only by `PickStartingGoalie` (`src/engine/setup94.asm` 1482), which nothing calls in the cartridge. The starting goalie is the G slot in the lines.

**Forward counts.** The high nibble of `.sr` byte 3 is the forward count (`srforwards`, `src/ram94.asm` 232; `GetForwardCount`, `src/front/stats94.asm` 2144, used by the line editor and player cards). It drops by the number of forwards removed. TOR also drops 14 → 13 with no forward removed: its cartridge #17 (P567) falls in the defense group on the disc, and the disc lines play him on defense. The low nibble is not read by the code. It changes on most teams, including OTW, whose roster is unchanged.

**Lines.** `.ls` (8 lines × G, LD, RD, LW, C, RW, extra attacker) was renumbered for the shorter rosters. These are the slots whose player differs, compared by player, not by number:

| Team | Line slot changes (cartridge → Sega CD) |
| --- | --- |
| BOS | Chk LD P072→P073, RD P073→P074; PP2 LD P072→P073; PK1 LD P069→P068, RD P068→P069 (swapped) |
| EDM | Sc2 RW P191→P192; PP2 RW P191→P192 |
| HFD | NLC XA P205→P206; Sc1 XA P205→P207; Sc2 LD P224→P222, C P205→P207; PP2 C P205→P206, RW P206→P207; PK1 LD P224→P221 |
| LA | Chk LW P235→P236 |
| DAL | PP1 LW P261↔RW P262 (swapped) |
| NJ | Sc2 RD P322→P324 |
| NYI | NLC XA P335→P336; Chk RW P340→P339; PK1 XA P340→P339; PK2 C P340→P339 |
| NYR | G P351→P352 in all 8 lines; Chk RD P375→P374; PK2 RD P375→P372 |
| PHI | Sc1 XA P405→P408; Sc2 LW P412→P408 |
| PIT | Sc2 LW P434→P435 |
| QUE | Sc2 LW P458→P459; PP2 C P464↔RW P466 (swapped) |
| SJ | PP2 C P480↔RW P481 (swapped) |
| STL | NLC LD P517↔RD P518 (swapped); Sc2 LW P510→P507; PK1 RW P510→P509; PK2 LW P510→P509 |
| TOR | Every line except NLC has new D pairs: Sc1 P571/P567, Sc2 P573/P572, Chk P568/P569, PP1 P568/P567, PP2 P569/P571, PK1 P568/P573, PK2 P571/P567 |
| VAN | Sc1 XA P580→P581; Sc2 C P580→P581; PP1 LW P588↔RW P589 (swapped); PK1 C P580→P583; PK2 RW P588→P583, XA P580→P588 |

The other teams that lost players (BUF, CGY, CHI, MTL, TB) had them in no line, so their lines name the same players. The team palettes differ for HFD and OTW (visual only, see the non-gameplay section).

### 5. Playoff password: pad layout decoding (verified; minor)

| | Cartridge | Sega CD |
| --- | --- | --- |
| `ReadPassBits` remap | `src/engine/setup94.asm` 1905-1912, `$180A6`-`$180C8`: without the 4-way adaptor, `pojoy` 1 or 2 becomes 4 | `src/segacd/hockey/setup94cd.asm` 1635-1643, `$405EA`-`$40620`: only with the adaptor, 1 becomes 3 and 2 becomes 4 |
| `ContinuePlayoffs` | `src/engine/setup94.asm` 1575, `$17CD8`: `blt` (subtract 2 when `pojoy` ≥ 2) | `src/segacd/hockey/setup94cd.asm` 1374, `$40176`: `ble` (subtract 2 when `pojoy` > 2) |

With the 4-way adaptor, both builds end with the same `pojoy` and `OptNOP`. Without it, a password with pad layout 1 or 2 restores a different `pojoy` (1 or 2 on the disc, 4 on the cartridge). For layout 1, `OptNOP` also comes out different: 6 on the disc, 5 on the cartridge. Inferred effect: which pads control which team in a continued playoff can differ. Nothing in play itself changes.

## Changed code with no gameplay effect

- **`ClearShotData`** (`src/engine/hockey94.asm` 75; cartridge `$77E4`, disc `$2B984`, verified): the cartridge clears `$E4` words from `outputbuffer`, a 113-word buffer, so it runs on through `marker`, `tpassbits` and the FM driver's tables after it (`src/ram94.asm` 840). The disc clears `$72` words (the buffer and `marker`). The overrun is fixed.
- **`puckgoalie` save tables** (`src/engine/collide94.asm` 2229; `lea .list2` 2265, `lea .list3` 2275, tables 2370 and 2446; verified bytes, inferred effect): on the disc both `lea`s point at `$3C246` inside `deflect`'s code (`$3C0A0` and `$3C0C6`; `src/segacd/hockey/collide94cd.asm` 1974 and 1983), and the tables are not on the disc. The value read from them is overwritten before use in both builds (`a2touchpuck` clears `d0`, and so do `.bounceoff` / `.chkanim`), so the result does not change.
- **Random numbers** (verified code; inferred values): the routines that read the VDP HV counter for random bits (`asspuckc`, `check4check`, `chk4lc`, `checkanim`, `playeracc`, `Endfaceoff`, `asswingo`, `asscentero`, `FallDown`, `puckgoalie`, `CCStart` and others) read it through main-CPU command `$1B`, with the reply at `$FF8010`. The logic is the same. The timing is not, so the actual random values differ from the cartridge in practice. `randomd0` / `randomd0s` (`src/engine/middle94.asm` 199-207) are unchanged.
- **Sound ids**: the "ding" `sfx` id is `1` (`SFXbeep1`) → `2` in `assnearest`, `asspuckc` and `breakaway`. `dopass` stores its `sfx` value with `move` instead of `addi`.
- **Music**: `puckfaceoff` and `Goal` call `song` directly instead of queuing a song through `sflags8` bit 4 and the cartridge song queue.
- **`GetDefenseStart`** (`src/front/stats94.asm` 2130): a redundant `andi #$F` is dropped.
- **`CountButtonPress`** (`src/ui94.asm` 367): a smaller `movem` register list. Otherwise the same.
- **`PeriodOver_sp`** (`src/engine/setup94.asm` 757): the two waits for the next vblank around `p_turnoff` are gone.
- **`StartGame`** (`src/engine/hockey94.asm` 39): the same set-up, plus CD loading and one extra cleared word.
- **`StartHL2`** (`src/engine/scoreboard94.asm` 840): the saved block size is `$5BD` → `$557` (the disc RAM layout).
- **Hardware glue**: VDP writes, DMA, palette fades and bitmaps go through sub→main gate commands. `move #$2700,sr` became `bclr #5,$FF800F`. The vblank handler ends in `rts` instead of `rte`. `waitx` uses `or` instead of `move`. `LineEditorExit` has a different wait loop. `UpdateScoutingDisplay` is rewritten for the CD scouting report.
- **RAM layout**: the team struct is 2 bytes longer (`$364` → `$366`). Field `$22` became a long, so every team field from `$24` up is 2 bytes further on (for example `$1A2` → `$1A4`). Every use was checked to be the same field.

## Non-gameplay differences

From `docs/segacd.md` and the area write-ups:

- The SDK shell around the game: `MAIN.BIN` on the main CPU, `STARTER.BIN` on the sub CPU. The game itself runs on the sub CPU.
- CD-DA music tracks and a PCM stream replace the cartridge song player (`docs/segacd_audio.md`, `docs/segacd_song.md`).
- The Ron Barr scouting report: voice clips and a typed script (`docs/segacd_announce.md`).
- An FMV player (`FILM` / `SM`, `docs/segacd_film.md`).
- `PLAYER.BIN`: career stats, the team page with the power-play lines, and player photos (`docs/segacd_stats.md`).
- The crowd frame driver is unchanged, but the crowd-volume PSG writes are dropped (`docs/segacd_crowd.md`).
- Graphics come from the `GRAPH2.BIN` archive.
- HFD and OTW team palettes differ.

## Verified the same

These are the same in both builds, or differ only by address relocation, the RAM layout shift, or the CD hardware glue:

- **Physics and collision**: `Sroot`, `randomd0`, `randomd0s` (`src/engine/middle94.asm` 199-228); `vtoa` (`logic94.asm` 7065); `pucknorm` (`logic94.asm` 6439); `checkagr` (`collide94.asm` 459); `FallDown` (638); `wallcoll` (1580); `checkpuckcoll` (1678); `puckstick` (1959); `CCStart` (359).
- **Shooting and goalies**: `doshot` (`logic94.asm` 1903); `goaliesave` (3820); `onetimershot` (`onetimer94.asm` 441); the rest of `puckgoalie`.
- **AI**: `assdefo` (`logic94.asm` 2700), `assdefd` (2768), `asswingd` (2901), `asswingo` (2983), `asscenterd` (3093), `asscentero` (3144), `breakaway` (3983), `asspuckc` (4089), `assnearest` (4706), and the `asstab` table (`src/tables94.asm` 23) after relocation.
- **Players, ratings and line changes**: `setplayer` (`collide94.asm` 2801); `Setplass` and its `.alist` table (2786); `SetPlList` (2577); `GetHot` (`logic94.asm` 7106); `AttributeCalc` (`src/front/crowd94.asm` 211); `chgplayer` (`src/engine/chgplayer94.asm` 5, byte-identical); `CompLine` (`logic94.asm` 5895); `Sweepcheck`, `setc1player`, `setc2player` (`logic94.asm` 1718-1734, byte-identical at disc `$312AA`).
- **Rules, faceoffs and the clock**: `Endfaceoff` (`logic94.asm` 6368); `ReturnGoalies` (5853); `PenaltyManager` (`src/engine/penalty94.asm` 63); `PeriodOver` (`src/engine/setup94.asm` 737); `ResetClock` (`src/engine/hockey94.asm` 94). The `GetPeriodTime` table (110) is byte-identical: `$12C`, `$258`, `$4B0`, `$1E` (5, 10 and 20 minutes, and 30 seconds). Overtime is 10:00 outside the playoffs in both.
- **Data tables, byte-identical**: `MaxSpeed` (`logic94.asm` 7629); `noturn` (7483); `checkinglist` (`collide94.asm` 450); `OneTimerNearTbl` / `OneTimerFarTbl` (`onetimer94.asm` 168-171); `PAttribColumns`, `PAttribOverall`, `GAttribColumns`, `GAttribOverall` (`src/tables94.asm` 420-468); `sublist` (326); `updatecrowdf_cd0` (8); and more than 40 animation tables from `src/frames94.asm`.

## How this was checked

- Cartridge: `nhl94retail.bin`, SHA-1 `7b1489ab501258133bf03e5f0892b77d04312580` (the retail ROM this repo builds).
- Sega CD: `HOCKEY.BIN`, SHA-1 `f12fdc1f6d24c35b47d3b4abf8b3540fae774578`, from the disc's data track. Also used for context: `MAIN.BIN` `d771cbbdae9aed1174bdcfd93593f5d3f1889bba`, `STARTER.BIN` `98cede070a6cb7fff523c3d7c8aab34da471cf64`, `PLAYER.BIN` `852b01298d2e5b97ac3ff13b3d52993faf54ff87`.

Method:

1. Both files were disassembled with Capstone (68000). Each cartridge routine was cut at the cartridge build's labels.
2. Every instruction was normalised so that only real changes are left:
   - addresses become placeholders;
   - `addq`/`addi`/`adda` count as `add`, and `cmpi`/`cmpa` as `cmp`;
   - short and long address forms, branch sizes, `$0(aN)` and `(aN)`, and the `exg` operand order count as the same;
   - large immediates on `move`, `lea`, `cmp`, `add` and `sub` become placeholders.
3. Each routine was found on the disc through an index of six-instruction windows, then aligned with `difflib`. A second pass placed routines after the end of the previous match. A third, looser pass covered routines with inline data or strings.
4. Every remaining difference was sorted into displacement, immediate, hardware I/O or RAM-layout changes. Every one that was not plainly relocation or I/O was read by hand against the raw bytes, and the addresses above come from that check. Some "differences" turned out to be inline strings decoded as code (`updatefaceoff`, `DrawScoringRow`, `Intermission`, `setlccords`, `printscores1`, `SetHor`); their bytes are the same.
5. The team data was parsed from both files. Each cartridge team was matched to the disc block with the most player records in common, then players, `.sr`, `.godds`, `.ls` and the palettes were compared.

Coverage: 765 of the 1,040 cartridge routines outside graphics, team data and SRAM (about 96 KB) were placed on the disc and compared. Most of the rest are text, tables or stubs of a few bytes. Gameplay routines the matcher could not place were compared by hand (`Setplass`, `Sweepcheck`, `setc1player`, `setc2player`, `MaxSpeed`, `checkinglist`, the one-timer tables). `docs/segacd-handoff/cart_vs_disc.md` is a separate, plain-text routine report. It counts address-size and relocation changes as "code changed", so its counts are much larger than the list here.

The comparison scripts are not in the repo. `tools/segacd_relocs.py` gives the cartridge-to-disc address pairs they start from.

## Not covered

- The main CPU side (`MAIN.BIN`), including how it reads the pads and hands the reads to the game. Only the sub-CPU game code was compared.
- The 4-way adaptor and pad-swap routines in `src/engine/fourway94.asm` were not compared.
- Frame timing and slowdown. The disc game runs on the sub CPU and talks to the VDP through the main CPU, so frame pacing may differ. It was not measured.
- The size of the agility change (1) and the corner change (2) in real games. Both effects are read from the code.
