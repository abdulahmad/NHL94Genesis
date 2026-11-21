# NHL 94: cartridge vs Sega CD differences

This page lists every difference found between the retail cartridge game and the Sega CD game code (`HOCKEY.BIN`), in gameplay first, then everything else. The short answer: the Sega CD plays the same game. Skating, puck physics, AI assignments, shooting, goalies, checking, penalties, line changes, period lengths and overtime are the same code. Three small code changes touch play, and the rosters drop 31 players with the lines rebuilt around them.

Each item is marked:

- **Verified**: the instructions or bytes were compared directly in both builds.
- **Inferred**: what the verified change does in a game, read from the code but not measured in play.

Cartridge source references are to this repo (`src/`). Disc source references are to the transcribed disc code in `src/segacd/hockey/` where it exists. Cartridge addresses are ROM addresses. Disc addresses are `HOCKEY.BIN` runtime addresses (file offset + `$1B000`).

Players are named as the retail team data spells them (the ROM shortens some long names, for example `John Vanbiesbrk`), with their cartridge roster number (`#n`, 1-based, the numbers `.ls` uses). The source in `src/teamdata94.asm` has placeholders for the names; the roster numbers match it.

## Gameplay differences

### 1. Skaters accelerate slightly faster on the Sega CD (verified; effect inferred)

| | Cartridge | Sega CD |
| --- | --- | --- |
| Routine | `playeracc`, `src/engine/logic94.asm` 7489, `.incagl` at 7517-7518 | `playeracc`, `src/segacd/hockey/logic94cd.asm` 6319, lines 6344-6345 |
| Address | `$10C08`-`$10C16` | `$368C0`-`$368D4` |
| Code | `addq.b #2,d2` once | `addi.b #2,d2` twice (+4) |

The acceleration term is `$40 - weight/4 + legstr`, plus the "crowd meter boost", then halved (`asr.w #1,d2`) and multiplied into the stick direction. The boost is gated on `sflags8` bit 1 or `sflags7` bit 6. `SetSflags8Bit1` (`src/helpers94.asm` 5) always sets `sflags8` bit 1, and `updateplayers` calls it every update (`src/engine/logic94.asm` 37; disc `$2AE68`, called from `$2FA14`). So the boost applies to every skater on both teams, all the time.

Inferred effect: after the halving, every player's acceleration term is 1 unit higher on the Sega CD. Goalies take the same path (the +4 comes before the goalie doubling of `legstr` + `$10`). The top-speed code that follows (+2, capped at `$1E`) is unchanged.

Size (arithmetic from the code; not measured in play). `setplayer` stores `weight` as the weight nibble × 8 (`src/engine/collide94.asm` 2888-2891) and `legstr` as `AttributeCalc` of the leg nibble (5 × nibble plus hot/cold ÷ 3, clamped to 0-`$1E`; `src/front/crowd94.asm` 211). So the skater term before halving is `64 - 2 × weight nibble + legstr + boost`, which is 36 to 96 on the cartridge. After the halving it is 18 to 48 on the cartridge and 19 to 49 on the Sega CD, about 2% (light, quick skaters) to 6% (heavy, slow skaters) more acceleration. For goalies, with the extra `legstr` + `$10`, the halved term is 26 to 71 on the cartridge, so about 1.4% to 3.8% more.

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

Both builds have the same 28 teams (26 NHL teams and the two All-Star teams). Florida and Anaheim are byte-identical. The disc drops 31 player records from 20 teams. 28 of them are players the cartridge also lists on Florida or Anaheim, so the cartridge has them twice. The other three (Bobby Smith, DAL #7; Dan Marois, NYI #16; Rick Wamsley, TOR #3) are not on any other team.

Every remaining player's record (name and all ratings) is byte-identical. The team `.sr` bytes 0-2 (simulated scoring odds, power play / penalty kill and home/visitor bonuses) are the same on all teams.

Removed players (cartridge roster number; G, F or D from the team's goalie and forward counts):

| Team | Removed |
| --- | --- |
| BOS | Gord Murphy #22 D |
| BUF | Bob Corkum #16 F |
| CGY | Brian Skrudland #6 F, Alexnder Godynyuk #24 D |
| CHI | Stu Grimson #11 F |
| EDM | Ron Tugnutt #2 G, Scott Mellanby #16 F |
| HFD | Terry Yake #5 F, Randy Ladouceur #24 D |
| LA | Lonnie Loach #10 F |
| DAL | Bobby Smith #7 F |
| MTL | Sean Hill #24 D |
| NJ | Alexei Kasatonov #22 D |
| NYI | Mark Fitzpatrik #2 G, Tom Fitzgerald #15 F, Dan Marois #16 F |
| NYR | John Vanbiesbrk #1 G, Steven King #11 F, Joe Cirella #25 D |
| PHI | Andrei Lomakin #12 F, Gord Hynes #24 D |
| PIT | Troy Loney #9 F |
| QUE | Mike Hough #8 F, Bill Lindsay #11 F |
| SJ | Robin Bawa #9 F, David Williams #22 D |
| STL | Guy Hebert #2 G, Dave Lowry #10 F |
| TB | Randy Gilhen #11 F |
| TOR | Rick Wamsley #3 G |
| VAN | Anatoli Semenov #5 F |

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

**Forward counts.** The high nibble of `.sr` byte 3 is the forward count (`srforwards`, `src/ram94.asm` 232; `GetForwardCount`, `src/front/stats94.asm` 2144, used by the line editor and player cards). It drops by the number of forwards removed. TOR also drops 14 → 13 with no forward removed: its cartridge #17 (Ken Baumgartnr) falls in the defense group on the disc, and the disc lines play him on defense. The low nibble is not read by the code. It changes on most teams, including OTW, whose roster is unchanged.

**Lines.** `.ls` (8 lines × G, LD, RD, LW, C, RW, extra attacker) was renumbered for the shorter rosters. These are the slots whose player differs, compared by player, not by number:

| Team | Line slot changes (cartridge → Sega CD) |
| --- | --- |
| BOS | Chk LD Gord Murphy (#22)→Gordie Roberts (#23), RD Gordie Roberts (#23)→Glen Feathrston (#24); PP2 LD Gord Murphy (#22)→Gordie Roberts (#23); PK1 LD Don Sweeney (#19)→Ray Bourque (#18), RD Ray Bourque (#18)→Don Sweeney (#19) (swapped) |
| EDM | Sc2 RW Scott Mellanby (#16)→Steven Rice (#17); PP2 RW Scott Mellanby (#16)→Steven Rice (#17) |
| HFD | NLC XA Terry Yake (#5)→Mikael Nylander (#6); Sc1 XA Terry Yake (#5)→Robert Kron (#7); Sc2 LD Randy Ladouceur (#24)→Dan Keczmer (#22), C Terry Yake (#5)→Robert Kron (#7); PP2 C Terry Yake (#5)→Mikael Nylander (#6), RW Mikael Nylander (#6)→Robert Kron (#7); PK1 LD Randy Ladouceur (#24)→Adam Burt (#21) |
| LA | Chk LW Lonnie Loach (#10)→Pat Conacher (#11) |
| DAL | PP1 LW Russ Courtnall (#11)↔RW Ulf Dahlen (#12) (swapped) |
| NJ | Sc2 RD Alexei Kasatonov (#22)→Tommy Albelin (#24) |
| NYI | NLC XA Derek King (#10)→Dave Volek (#11); Chk RW Tom Fitzgerald (#15)→Brad Dalgarno (#14); PK1 XA Tom Fitzgerald (#15)→Brad Dalgarno (#14); PK2 C Tom Fitzgerald (#15)→Brad Dalgarno (#14) |
| NYR | G John Vanbiesbrk (#1)→Mike Richter (#2) in all 8 lines; Chk RD Joe Cirella (#25)→Jay Wells (#24); PK2 RD Joe Cirella (#25)→Kevin Lowe (#22) |
| PHI | Sc1 XA Rod BrindAmour (#5)→Keith Acton (#8); Sc2 LW Andrei Lomakin (#12)→Keith Acton (#8) |
| PIT | Sc2 LW Troy Loney (#9)→Jeff Daniels (#10) |
| QUE | Sc2 LW Mike Hough (#8)→Gino Cavallini (#9); PP2 C Mats Sundin (#14)↔RW Andrei Kovalenko (#16) (swapped) |
| SJ | PP2 C Rob Gaudreau (#5)↔RW Dean Evason (#6) (swapped) |
| STL | NLC LD Jeff Brown (#17)↔RD Garth Butcher (#18) (swapped); Sc2 LW Dave Lowry (#10)→Bob Bassen (#7); PK1 RW Dave Lowry (#10)→Igor Korolev (#9); PK2 LW Dave Lowry (#10)→Igor Korolev (#9) |
| TOR | Every line except NLC has new D pairs: Sc1 Drake Berehowsky (#21)/Ken Baumgartnr (#17), Sc2 Bob Rouse (#23)/Jamie Macoun (#22), Chk Todd Gill (#18)/Dave Ellett (#19), PP1 Todd Gill (#18)/Ken Baumgartnr (#17), PP2 Dave Ellett (#19)/Drake Berehowsky (#21), PK1 Todd Gill (#18)/Bob Rouse (#23), PK2 Drake Berehowsky (#21)/Ken Baumgartnr (#17) |
| VAN | Sc1 XA Anatoli Semenov (#5)→Tom Fergus (#6); Sc2 C Anatoli Semenov (#5)→Tom Fergus (#6); PP1 LW Pavel Bure (#13)↔RW Trevor Linden (#14) (swapped); PK1 C Anatoli Semenov (#5)→Murray Craven (#8); PK2 RW Pavel Bure (#13)→Murray Craven (#8), XA Anatoli Semenov (#5)→Pavel Bure (#13) |

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
- HFD and OTW team palettes differ (below).

### HFD and OTW team palettes (verified)

Each team record has two 16-colour palettes, home then visitor. `setplayercolors` (`src/engine/setup94.asm` 718) copies the home team's home palette into palette line 2 and the visiting team's visitor palette into line 3. Only one half changed for each team. Colours are Genesis `0BGR` words.

| Team, palette | Index | Cartridge | Sega CD |
| --- | --- | --- | --- |
| HFD home | 9 | `$042` (dark green) | `$264` (lighter green) |
| OTW visitor | 4 | `$002` (dark red) | `$200` (dark blue) |
| OTW visitor | 5 | `$004` (red) | `$200` (dark blue) |
| OTW visitor | 8 | `$028` (dark orange) | `$006` (dark red) |
| OTW visitor | 10 | `$002` (dark red) | `$000` (black) |
| OTW visitor | 11 | `$222` (dark grey) | `$000` (black) |
| OTW visitor | 12 | `$444` (grey) | `$000` (black) |

HFD visitor and OTW home are the same in both. The cartridge palettes are at ROM `$1B50` (HFD, `src/teamdata94.asm` 617-618) and `$3060` (OTW, 1059-1060). The Sega CD ones are at `HOCKEY.BIN` file offsets `$17CA` and `$2BC6` (runtime `$1C7CA` and `$1DBC6`).

![HFD home and OTW visitor palettes, cartridge vs Sega CD, on sprite frame 194](images/segacd_hfd_otw_palettes.svg)

The example is sprite frame 194: the second celebrate frame for facing direction 4, toward the camera, arms and stick up (`SPFcelebrate` = 185, two frames per direction, `src/frames94.asm` 18 and `SPAcelebrate` at 1178). It was decoded from the cartridge's `frameSprData` (`$9E724`) and `Spritetiles` (`$5DE84`) the way `addframe2` (`src/engine/video94.asm` 863) draws it. Every changed index above is used by pixels in that frame. The image shows each 3-bit colour level scaled to 0-255, so the shades are approximate. HFD's green stripes are lighter on the Sega CD. The OTW visitor uniform goes from grey with dark-red pants to black with dark-blue pants.

## Main CPU, pads, the 4-way adaptor and frame timing

The game runs on the sub CPU. The main CPU (`MAIN.BIN`) runs the SDK shell and does every VDP, pad port and Z80 access for it. `MAIN.BIN` runtime addresses below are the file offset + `$FF1000` (the command table at file `$371C` is the runtime table at `$FF471C`).

### How a frame reaches the game (verified code)

- Sub command `$2D` (`MAIN.BIN` `$FF6916`) points the main CPU's vblank vector (`$FFFD08`) at `$FF485E`. That is `SubCommAck` (`src/segacd/main/mainsubcomm94cd.asm` 190). The sub side sends it from `SubCmd2DSend` (`src/segacd/hockey/cdhockey94cd.asm` 2), which also points the sub CPU's vblank hook (`$6038`) at `VBlankSubCpuHook` (`$22018`, same file, line 17).
- Every main vblank, `SubCommAck` sets main flag bit 5 and raises the sub CPU's level 2 interrupt (`bset #0,$A12000`). It then polls for the sub's answer (sub flag bit 2), about 77 polls in two loops. With an answer, it runs the sub's requests from `$A12026` through the table at `$FF471C`, one at a time, until command `$2F` (`$FF6932`) clears `$FF6CFA`. It ends in `rte`. With no answer, it clears bit 5 and returns, and nothing is serviced that vblank.
- `VBlankSubCpuHook` checks main flag bit 5, answers with bit 2, and calls the game's vblank code through `VBint` (`$18D66`, the cartridge's `VBint` pointer). It then calls `ReadJoyData`, sends command `$2F`, and adds 1 to a counter at `$17460`. That counter is cleared at game start (`hockey94cd.asm` 88) and never read.
- The game-play vblank routine is the cartridge's `VBlank` (`src/engine/video94.asm` 5; cartridge `$15D9A`, disc `$3DAB8`). It does the same work: sprite DMA when `dfok` is set, `cramfade`, the game clock jiffy, `Vcount + 1`. It does not call `p_music_vblank` (the pads are read by the hook instead, and music is CD audio), and it ends in `rts`. Its VDP writes and DMA are sub→main commands (for example `$30` and `$31` in `DmaListWait`, `src/segacd/hockey/video94cd.asm` 38), each a full four-step flag handshake instead of one bus write.
- `DoGameFrame` is the same on both (`src/engine/hockey94.asm` 171; cartridge `$794E`, disc `$2BB8E`). It waits for `Vcount` to change, sets `d7` to the vblanks since the last game frame, and the movement code scales by `d7` (for example `muls.w d7` in `playeracc`). That is the game's only frame-skip handling, and it is the same on both.

### Frame timing and slowdown (inferred; not measured)

- The game clock and `Vcount` tick only in a vblank the sub CPU actually got. If the sub does not answer `SubCommAck`'s polls, that vblank is lost to the game: no sprite DMA, no clock jiffy, no `Vcount` step. Then the game clock and game speed run slower than real time. The cartridge's `VBlank` is an ordinary interrupt and cannot be skipped that way.
- When a game frame takes more than one vblank, both versions step movement by `d7`. So the CD would show fewer screen updates but the same game-time speed, unless vblanks are lost as above.
- Each VDP write, DMA and pad access in the vblank now costs a sub↔main handshake. So the vblank work takes longer on the CD than on the cartridge. Whether that causes visible slowdown in a real game was not measured.
- No emulator measurement was taken. That needs a Sega CD BIOS and a full disc image (with the CD-DA tracks). Neither was available for this check.

### Pads (verified)

- **Cartridge**: `p_music_vblank` (`src/sound/sound94.asm` 383) calls `ReadJoyData` (258; ROM `$1A370`) every vblank. It requests the Z80 bus (with `ResetZ80Bus` if it is not granted) and reads each pad with TH low, then high, two `nop`s apart (`ReadPad3Button`, 348). It maps the direction nibble through `PadDirTable` (373) and stores `PadRaw1`-`PadRaw4`.
- **Sega CD**: `ReadJoyData` is on the sub CPU (`src/segacd/hockey/graphics94cd.asm` 31; `$47DB2`), called from `VBlankSubCpuHook`. Each port access is a main-CPU command:

  | Command | Main handler | Does |
  | --- | --- | --- |
  | `$35` | `$FF6988` | write port 2 data (`$A10005`) |
  | `$36` | `$FF697C` | write port 1 data (`$A10003`) |
  | `$37` | `$FF6994` | read port 1 into `$A12018` |
  | `$38` | `$FF69A0` | read port 2 into `$A12018` |

  The handlers are in `src/segacd/main/maincmd94cd.asm` 517-523. Each pad is read as on the cartridge: write 0 (TH low), read, write `$40` (TH high), read. Port 1 uses `$36`/`$37` and port 2 uses `$35`/`$38`. The direction table (`.next9`, line 220) has the same 16 values as `PadDirTable`, and the button packing is the same (line 206). The Z80 bus request and `ResetZ80Bus` are gone (the main CPU owns the Z80 on the CD). The TH settle time is a command round trip instead of two `nop`s. The bytes stored in `PadRaw1`-`PadRaw4`, and everything that reads them (`ReadJoy1`-`ReadJoy4`, `ReadJoy` and `jdtab` (`src/engine/middle94.asm` 483-539), and `doinput` (`src/engine/logic94.asm` 517)), are the same apart from item 3 above.
- `MAIN.BIN` also has its own pad poller, `PollControllers` (`src/segacd/main/mainctrl94cd.asm` 43; `$FF4E8E`), with the same TH sequence and a copy of the direction remap. Its only caller (`$FF4F88`) runs only while sub flag bit 0 is set, and sets main flag bit 1 when the combined new presses are exactly Start (`$80`). It does not write the game's `PadRaw` bytes. What the sub uses that Start flag for (probably skipping a film or loading screen) was not traced.

### 4-way adaptor (verified)

- **`Detect4WayPlay`** (`src/engine/fourway94.asm` 4; cartridge `$F6D5E`, called from `src/engine/hockey94.asm` 27): on the CD, the same port sequence runs on the main CPU as command `$2B` (`$FF68AA`, `src/segacd/main/maincmd94cd.asm` 474-492). It holds the Z80 reset, sets port 1 control `$40` and port 2 control `$43`, writes `$7C` to port 2 twice with control `$7F`, and tests port 1 lines 0-1. It returns 1 or 0 in `$A12010` instead of writing `FourWayPlay`, and puts port 2 back to `$40` when no adaptor is found. The sub stores the reply in `FourWayPlay` (`$18BF8`) at `$221A8` (`cdhockey94cd.asm` 84-88).
- **Reading through the adaptor**: the cartridge's `ReadPad4Way1`-`4` select pads with `$0C`, `$1C`, `$2C`, `$3C` on port 2 and read port 1. The CD's `ReadJoyData` sends the same four values with command `$35` and reads with `$36`/`$37`, without the Z80 bus request.
- **`ReadJoySwapPad1`-`4`** (unused in the cartridge, `fourway94.asm` 28-52) are not on the disc. None of the 13 disc callers of `ReadJoy1` (`$374F0`) has their save/restore shape, and the disc RAM map (`src/segacd/ram94cd.asm`) has no `pad4waysave` words.
- **`Set4WayPlayer`** (unused in both) is still on the disc (`src/segacd/hockey/fourway94cd.asm` 1).

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

- **Measured timing**: frame timing and slowdown were analysed from the code only (see above). No emulator or hardware measurement was taken, because that needs a Sega CD BIOS and a full disc image.
- **In-game effect sizes**: the agility change (1) is sized from the code's arithmetic. How it feels in play, and how often the corner change (2) fires, were not measured.
- **Main CPU code outside the game's I/O path**: the rest of `MAIN.BIN` (the film player, scouting report and SDK menu code) was read only where it serves the game's vblank, pads and 4-way detection. The Start-press flag from `$FF4F88` was not traced to its use on the sub CPU.
