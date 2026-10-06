# NHL 94 segment agent

This file is the queue and the history. Do not rewrite it as a whole file. Edit it in place.

## Current segment

`logic94_4`. Not matched. Starts at `checkob` `$E62E` (listing line 40493; `bsr.w checkob` at `$E04A` in logic94_3), the byte after logic94_3. 93 logic93_4 starts at checkob too; logic94_5 (`ChkOffsides`) follows it. Confirm the end against `lst/nhl94.bin` before writing instructions.

## Sources

- Listing: `lst/nhl94.bin.lst` in this repo. Open that file. Do not disassemble `lst/nhl94.bin`. Do not write a disassembler.
- The listing was exported from IDA as an LST in ASM68K / MRI mode. It has no address column. A `loc_`, `sub_`, or `unk_` name is the address. A named routine is at the instruction before the next address-bearing label. Confirm the org against `lst/nhl94.bin` before the first verify.
- Style source: the matching file in https://github.com/abdulahmad/NHLPA93Genesis. 93 is the closer source.
- Reference ROM: `lst/nhl94.bin`. This is the ROM the listing was generated from. Bytes and branch displacements come from it. Do not substitute another ROM.
- `src/hockey94.asm` is the include order. Do not reorder it.
- Stub includes live in `src/stubinc` (`ports.inc`, `equals.inc`, `ram_addrs.inc`).


## Teams

NHLPA 93 has 24 teams. NHL 94 has 26. Do not copy a 93 team count, team index, or palette slot into `teamdata94`.

Added in 94:

- Anaheim Mighty Ducks
- Florida Panthers

Replaced in 94:

- Minnesota North Stars is Dallas Stars. `North Stars` and `Minnesota` are not in `lst/nhl94.bin`.

Still present from 93: Ottawa Senators, Tampa Bay Lightning, San Jose Sharks, Quebec Nordiques, Winnipeg Jets, Hartford Whalers. All Stars East and All Stars West remain.

94 also changed the conferences. 93 is Wales and Campbell. 94 is Eastern (Atlantic, Northeast) and Western (Central, Pacific). A 93 division or playoff-tree index is not a 94 index.

## Build

`buildseg.bat <name>` assembles `src/<name>_stub.asm`. The stub is `org` at the confirmed start, includes `src/stubinc`, and includes `src/<name>.asm`.

`npm run seg:<name>` runs buildseg, then `fixopcodes.js` on `output/<name> .lst` and `output/<name>.bin` with the org, then `verifySegment.js`. The assembler listing name has a space before `.lst`.

A MATCH of 0 bytes is a failure. The byte count must be the confirmed range.

## Rules carried from 93

- Write real `cmp`, `cmpi`, and `exg`. `fixopcodes.js` rewrites an EA `cmp.l` (`0Cxx` to `B0BC`) only. A real `cmpi.l #imm,d0` stays `0C80`. Do not revert that rule.
- Retail pad bytes win over the listing.
- A `printz` string can hide the next instruction. Write the instruction. Do not label a byte inside a string.
- If IDA splits one instruction into `dc.b` and `ori.b`, write the instruction.
- A 92 or 93 name is the field even when the 94 value differs. The equate gets the 94 value. The comment records the older value.
- Bit names (`sf2drec`, `sfwrap`) replace the number. Keep the flag word the retail bytes use.
- `jsr name` only when SNASM emits the same opcode. `jsr (name).l` is `4EB9`. `jsr (name).w` is `4EB8`. `bsr.w` stays `bsr.w`.
- A global label ends local-label scope. Strip `?` from IDA names. Keep each comment line under 200 characters.
- Do not delete an asm file. Edit it in place. Do not add a file except the stub and the segment asm.

## ROM map

The first row that is not matched is the current segment. Ranges are provisional until that row is matched.

| File | Status | Start | Note |
|---|---|---|---|
| main94 | matched | org 0 | 778 bytes, `$000000-$000309`. vectors, header, Start, SegaInit |
| teamdata94 | matched | after main94 | 22546 bytes, `$00030A-$005B1B`. TeamList, 28 team blocks, playoffseats, Credits |
| frames94 | matched | SPAList | 7062 bytes, `$005B1C-$0076B1`. SPAlist, 66 SPA tables |
| ram94 | skipped | | equates only, no ROM bytes: no byte verify is possible. Skipped by the user; the queue goes past it |
| hockey94_01 | matched | VBjsr | 1924 bytes, `$0076B2-$007E35`. VBjsr, Begin ... Pausemode, SetupPauseScreen, seta2 |
| attract94 | matched | EASportsScreen | 602 bytes, `$017A18-$017C71`. EASportsScreen ... sub_17BE4, VBlank_SetOptions. HiScoreScreen is not here |
| hockey94_02 | matched | ReplayMode | 4376 bytes, `$009FD0-$00B0E7`. ReplayMode (no IDA label) ... checkwindow |
| logic94_1 | matched | doinput | 5672 bytes, `$00B0E8-$00C70F`. doinput ... setpads, check4bench |
| logic94_2 | matched | assbench | 2444 bytes, `$00C710-$00D09B`. assbench ... asswingd |
| logic94_3 | matched | asswingo | 5522 bytes, `$00D09C-$00E62D`. asswingo ... chk4pass, EvadePC |
| logic94_4 | not matched | checkob | |
| logic94_5 | not matched | ChkOffsides | |
| middle94_1 | not matched | remap | |
| middle94_2 | not matched | dobitmap | |
| penalty94_1 | not matched | AddPenalty | |
| penalty94_2 | not matched | printscores1 | |
| hockey94_03 | not matched | checkcoll | line 48484 |
| hockey94_04 | not matched | checkfight | |
| hockey94_05 | not matched | puckstick | |
| video94_1 | not matched | VBlank | |
| video94_2 | not matched | showclock | |
| hockey94_06 | not matched | setupice | line 53024 |
| hockey94_07 | not matched | ScoutingReport | 94 screens |
| hockey94_08 | not matched | setoptions | |
| hockey94_09 | not matched | DefaultMenus | |
| hockey94_10 | not matched | ResolveGames | through crash |
| hockey94_11 | not matched | cd0 | data |
| sram94 | not matched | InitSaveRAM | |
| sound94 | not matched | AllSndOff | 68k driver, then incbin |
| graphics94 | not matched | | incbin from extractAssets94.js |
| checksum94 | not matched | ValidationRoutine | existing draft |

## History

- `main94` matched: 778 bytes, `$000000-$000309`. `src/main94_stub.asm` is `org 0`, includes `stubinc\ports.inc`, `equals.inc`, `ram_addrs.inc` and `main94.asm`. Run `npm.cmd run seg:main94`. A match must report 778 bytes at `0x000000-0x000309`.
  - Range: vectors `$0-$FF`, header `$100-$1FF` (`sega\SegaIDTable94.asm`), `SegaInit` `$200-$2FF` (`sega\SegaInit.asm`, unchanged), `Start` tail `jsr ValidationRoutine` `$300` and `bra.w Begin` `$306`. 94 has no `jsr KillCrowd` in `Start`.
  - Outside addresses, from the retail bytes: `AddError` `$18BFC` (IDA `AdrErr`, vectors 2 and 3), `Illinst` `$18C22` (`InvOpCode`), `ZeroDiv` `$18C4C` (`DivBy0`), `IRQ7` `$15E6C` (vectors `$60-$70`, `$7C`), `VBjsr` `$76B2` (`$78`), `ValidationRoutine` `$FFAC0` (IDA `Calc_Checksum`, `jsr (x).l` at `$300`), `Begin` `$76B8` (`bra.w` displacement `$73B0` at `$308`).
  - Reset SP is `InitialSP` `$FFFFF6`, defined in `main94.asm` (93 name). `Stack` is `$FFFFFFFE` in `ram_addrs.inc`; the old `Stack = $FFFFF6` clashed with it. Unused vectors `$18-$5F` and `$90-$FF` are `$FF` (93: `$00`); `$74` and `$80-$8F` are 0.
  - Header fixes to `SegaIDTable94.asm`: overseas title at `$150` padded to 48 bytes (the draft was 2 bytes short), ROM end `$000FFFFF` (1 MB), backup RAM `'RA',$F8,$20` `$200001-$203FFF` at `$1B0`, country `UE`. Checksum word `$5512`.
  - No `cmp` / `cmpi` / `exg`: 0 opcodes patched. `fixopcodes.js` now writes `output/modified_<name>.bin` with 0 patches too (as the 93 copy does); before, `verifySegment.js` failed with ENOENT. `fixopcodes.js` still has a `cmpi.l` `0C80` to `B0BC` rule (the 93 copy removed it). main94 has no `cmpi.l`, so it was left as is.
  - Linux only: Wine 9 `cmd` takes the `||` after a good `cd /d` in `buildseg.bat` and exits 1 with no log. Under Wine, run a copy of `buildseg.bat` without `|| exit /b 1`. Windows is not affected.
- `teamdata94` matched: 22546 bytes, `$00030A-$005B1B`. `src/teamdata94_stub.asm` is `org $30A`, includes `macros\genesis.mac`, the three stubinc files and `teamdata94.asm`. No outside addresses. Run `npm.cmd run seg:teamdata94`. A match must report 22546 bytes at `0x00030a-0x005b1b`.
  - Range: `dc.l 0` at `$30A`, `TeamList` `$30E` (28 longs), the team blocks `$37E-$5575`, `playoffseats` `$5576` (512 bytes), `Credits` `$5776` to the byte before `SPAList` `$5B1C`. The listing has no labels there; the code has `movea.l #$5576` (playoffseats), `#$5776` and `#$57B8` (`Credits`, `Credits+$42`) and `#$5B1C` (SPAList).
  - The old draft (92 Wales/Campbell teams, 92 offsets, `.pal` incbins) was replaced in place. Transcribed from the listing bytes, lines 278-22740, by a script that reads only the `.lst`.
  - TeamList order: ANH, BOS, BUF, CGY, CHI, DAL, DET, EDM, FLA, HFD, LA, MTL, NJ, NYI, NYR, OTW, PHI, PIT, QUE, SJ, STL, TB, TOR, VAN, WSH, WPG, ASE, ASW. The blocks are in a different order in the ROM: ASE, ASW, BOS, BUF, CGY, CHI, DET, EDM, HFD, LA, DAL, MTL, NJ, NYI, NYR, OTW, PHI, PIT, QUE, SJ, STL, TB, TOR, VAN, WPG, WSH, FLA, ANH. Labels are 93 names (`LongIsland` = NYI, `NewYork` = NYR); `Dallas`, `Florida`, `Anaheim` are new. Ottawa's abbreviation is `OTW`. The listing comments on TeamList swap PIT / PHI and STL / SJ: `$3348` is PHI, `$3646` PIT, `$3C42` SJ, `$3F30` STL (read from the city and abbreviation Strings).
  - Each block keeps the 93 offset-word order and equates (`Playerdata` 0 ... `ScoreOdds` 10). Changes from 93: `.sr` is 4 bytes (93: 8), `.ls` has 8 lines (93: 7), and after city and abbreviation there are 2 more Strings, nickname and arena (empty nickname for ASE / ASW). The player list ends in an empty String (`dc.w 2`). Palettes are `dc.w`; `extractAssets94.js` has no 94 palette entries.
  - `Player` (the 93 `PLAYER` macro) was added to `src/macros/genesis.mac`. `seg:main94` still matches. No `cmp` / `exg`: 0 opcodes patched.
  - IDA labels inside the data are not created: `unk_400`, `runspeed_15`, `word_3244`, `byte_4240`, `byte_43FA`.
- `frames94` matched: 7062 bytes, `$005B1C-$0076B1`. `src/frames94_stub.asm` is `org $5B1C`, includes the three stubinc files and `frames94.asm`. No outside addresses. Run `npm.cmd run seg:frames94`. A match must report 7062 bytes at `0x005b1c-0x0076b1`.
  - Range: `SPAlist` `dc.w 0` at `$5B1C`, then 66 SPA tables that end exactly at `VBjsr` `$76B2`. The listing has only `SPAList` and `unk_73A0` (a direction start in `SPA_185A`, RAM xref) there. Transcribed from listing lines 22741-29708 by a script that reads only the `.lst`.
  - Same table format as 93: 8 direction offsets from `.t`, a flag word, then frame,time pairs; a negative time ends a direction. `SPA<name> = *-SPAlist`. `wallright` / `wallleft` direction 7 points at the next table, as in 93 (`.7` is at the table end).
  - Order: 93 `gready` ... `pump` (0-37), then `wallright` ... `flip` (38-50), then 14 tables new in 94 (51-64, named `SPA_<offset>`, e.g. `SPA_145C`; no 93 table to name them from), then `injury1` (65). The 9 93 fight tables (`fight` ... `finjury`) are not in 94.
  - SPF bases: 93 names, 94 values. Same as 93 through `SPFgready` (539); `SPFSiren` and up are 93 + 8 (`SPFbglass` 653), because 94 `gready` has 3 frames per direction (93: 2). Found by comparing every 93 table frame by frame (evaluated from `frames93.asm`): each SPF group has one shift. Frames 658-837 are new in 94 and are written as numbers.
  - Other changes from 93: `Hold2` and `flail` end with time -40 (93: -30). No `cmp` / `exg`: 0 opcodes patched. `src/hockey94.asm` still has no frames94 include; it was not edited.
- `ram94` skipped: `src/ram94.asm` has no active lines (all commented out) and no ROM bytes, so a segment verify cannot report a non-zero MATCH. The user chose to skip it. Stubs keep using `src/stubinc`.
- `hockey94_01` matched: 1924 bytes, `$0076B2-$007E35`. `src/hockey94_01_stub.asm` is `org $76B2`, includes `macros\genesis.mac`, the three stubinc files and `hockey94_01.asm`. Run `npm.cmd run seg:hockey94_01`. A match must report 1924 bytes at `0x0076b2-0x007e35`.
  - Range: listing lines 29709-30309. Same split as 93 hockey93_01: `VBjsr` through `seta2`. The next byte, `$7E36`, is IDA `sub_7E36` = 93 menu93 `InitMenuState`.
  - Names: 93 names where 93 has the routine, IDA name in an `;IDA:` comment: `ClearShotData` (`sub_77E4`), `GetPeriodTime` (`ClockLength`), `periodicevents` (`periodiceevents`), `CheckInjury` (`loc_79EA`), `UpdateLineChange` (`loc_79F8`), `CheckPeriodEnd` (`sub_7A34`), `clockcont_0` (`loc_7B5C`, also entered from puckfaceoff+B2), `HandleJoy1` (`loc_7CB0`), `SetupPauseScreen` (`sub_7DCE`), `seta2` (`sub_7E0E`). 94 only, named from behaviour: `startpause3` (`loc_7CDC`) and `startpause4` (`loc_7CEA`), the 4 way play pads (doinput+A4 / +A8 jump to them). IDA `start` in updatecrowdf is the local `.dec`: a global `start` is the same symbol as main94 `Start`.
  - 94 differences from 93: `Begin` saves the VDP PAL bit and calls `EASportsScreen`, `InitSaveRAM`, `HiScoreScreen`, `LoadDefMenuOptions`; `StartGame` has the pad 1 `$E0` check inline (93 `ChkShortPeriods`); `demoread` and `startpause` handle pads 3 and 4; `Pausemode` has a third item list (`unk_19664`). IDA calls VDP status bit 0 "DMA busy"; it is `PAL_MODE`.
  - The inline string after `jsr (printz2).l` in `SetupPauseScreen` (`$7DFA`) is `String $FF,3,$FD,0,$FC,0` (retail bytes); IDA shows it as `ori.b #3,a0`.
  - Outside addresses: 63 stubs, each read from the retail operand (`jsr` / `jmp (x).l`, `movea.l #x`, or `bsr.w` / `Bcc.w` displacement); the stub comment gives the instruction address. Each symbol had one address at every use.
  - `cmp.b #$E0,d3` and `cmp.w #imm,d0` (3) are EA `cmp`: 4 opcodes patched. `fixopcodes.js` got the 93 byte rules `0C01`-`0C06` (`B23C`-`BC3C`), takes the binary org from the first listing line that emits bytes (optional third argument), and patches each address once. Before, it used ROM addresses as file offsets, so no patch landed on a segment above org 0 (verify 1 failed on the 4 `cmp` opcodes). main94, teamdata94 and frames94 still match.
- `attract94` matched: 602 bytes, `$017A18-$017C71`. `src/attract94_stub.asm` is `org $17A18`, includes `macros\genesis.mac`, the three stubinc files and `attract94.asm`. Run `npm.cmd run seg:attract94`. A match must report 602 bytes at `0x017a18-0x017c71`.
  - Range: listing lines 54528-54846. 94 put the EA screen code just before the 93 hockey93_08 vblank handler `VBlank_SetOptions` (IDA `loc_17C42`, `$17C42-$17C71`), so the handler ends this segment. The next byte `$17C72` is `LoadDefMenuOptions`, which is 93 `DefaultMenus` (same `st demoflag` and option copy; 9 words in 94, 7 in 93), followed by `sub_17CA0` = 93 `NewPO`, `MakeTree`, `FigureJoy`: the hockey94_09 row (`DefaultMenus`) starts at `$17C72`, not in attract94.
  - `HiScoreScreen` is at `$FED70` (listing line 974979), in the 94 code near the end of the ROM, not next to this code. It is not in this segment and has no row yet.
  - Routines: `EASportsScreen`, `sub_17AC8`, `sub_17AF4`, `sub_17B78` (IDA). `$17B98-$17C41` is IDA `dc.b`; it is code with no xref, written as instructions from the listing bytes: `sub_17B98`, `sub_17BBA`, `sub_17BCA`, `sub_17BE4` (IDA-style names). The bytes before `$17A18` (`sub_179D2`, a 94 scroll routine) are not 93 code.
  - IDA hid instructions in printz strings: `EASportsScreen` is `String $FE,0,0,0` then `movea.l #unk_B425A,a2` (IDA `ori.b` x3); `sub_17AF4` has `String $BF,7,1,0` and `String $BF,$16,1,0`; `sub_17BCA` has `String $BF,2,$A,0`.
  - Outside addresses: 19 stubs read from the retail operands. `printz` is `$11B92`. `rtss2` is the `rts` at `$15464` (also the target of the undecoded `bne.w`). `sub_17E42` and `unk_B425A` have no IDA label. `#$30E` in `sub_17BE4` is TeamList. No `cmp #imm,Dn`: 0 opcodes patched.
- `hockey94_02` matched: 4376 bytes, `$009FD0-$00B0E7`. `src/hockey94_02_stub.asm` is `org $9FD0`, includes `macros\genesis.mac`, the three stubinc files and `hockey94_02.asm`. Run `npm.cmd run seg:hockey94_02`. A match must report 4376 bytes at `0x009fd0-0x00b0e7`.
  - Range: listing lines 34505-35879. `ReplayMode` has no IDA label: it is the code after `_rjoy` (`$9FB8-$9FCF`, the end of the code before it), first instruction `bclr #0,(word_FFC2F6).w` at `$9FD0`, found by instruction sizes back from `loc_A02A`. It ends with `checkwindow`; `doinput` (`$B0E8`) is next. The code between hockey94_01 (`$7E36`) and `$9FCF` (93 menu93 / stats93) has no row yet.
  - Names: 93 names where 93 has the routine: `suba4` (`sub_A4F6`), `adda4` (`sub_A528`; 94 adds the reverse angle switch at the top), `adda42` (`loc_A5F4`), `adda43` (`sub_A600`), `UpdateCameraPos` (`sub_A616`), `RestoreReplayFrame` (`SetRCords`). Kept IDA names: `getpzjoy`, `RevReplayAdj`, `sub_A448`, `sub_A48A`, `sub_A4A8`, `sub_A4D8`, `sub_A88C`, `updatereplay`, `rtss8` (93 calls this rts `rtss2`, but 94 `rtss2` is `$15464`), `updateplayers`, `updateanim`, `freezewindow`, `checkwindow`. Locals are the IDA local names (`_top` -> `.top`) or the IDA address (`loc_A058` -> `.A058`); all 87 address locals assemble at their own address. `unk_A23E` is the local `.dirtab` (8 x/y word pairs).
  - Hidden instructions after `printz`: `sub_A448` `String $BD,2,2` + `moveq #$20,d0`; `sub_A48A` `String $BD,2,2` + `move.w #8,d0` / `#4,d1` / `#$7FF,d2`; `sub_A4A8` `String $BD,2,0` + `moveq #0,d0`; `sub_A4D8` `String $BD,2,2` + `move.w #$10,d0` / `#$B,d1` / `#$7FF,d2` (IDA shows ori.b / andi.b and a bare `d3` line).
  - The `cmpi.w #$xxxx,$58(a3)` checks in updateplayers are frames94 SPA offsets (`SPA_193E`, `SPA_1A00`, `SPA_18CC`, `SPA_17E8`, `SPA_1776`, `SPA_185A`, `SPA_145C`, `SPAinjury1` `$1AF4`); written as numbers with the name in the comment. `#$5B1C` is `SPAlist` (stub).
  - Outside addresses: 38 stubs read from the retail operands. 30 EA `cmp` opcodes patched (`cmp.w #imm` on d0 / d1 / d2 / d6, one `cmp.l #4,d0`). Matched on the first verify.
- `logic94_1` matched: 5672 bytes, `$00B0E8-$00C70F`. `src/logic94_1_stub.asm` is `org $B0E8`, includes `macros\genesis.mac`, the three stubinc files and `logic94_1.asm`. Run `npm.cmd run seg:logic94_1`. A match must report 5672 bytes at `0x00b0e8-0x00c70f`.
  - Range: listing lines 35886-37885, `doinput` through `check4bench`, as 93 logic93_1. `assbench` (`$C710`) is next. The ROM map note "before loc_B470" was not a boundary: `loc_B470` is a branch target inside doinput.
  - Names: IDA names (the 92 / 93 names here) except `SetLCmode2` (`sub_B92E`), `setpads` (`sub_C656`) and `restorepl` (IDA `restorep1`). Locals are IDA local names (`_x` -> `.x`) or the IDA address. IDA labels that would clash or split a routine are locals: `loop` -> `.loop`, `even` -> `.even` (an SNASM directive), `chkgoalie` -> `.chkgoalie` (inside restorepl). `loc_B470`, `loc_B616`, `loc_B6BA`, `loc_B72E`, `loc_B81A` stay global: doinput branches to them across a global label. IDA prints `glb_B8AA` (and others) twice; the second line is dropped. `loc_7CDC` / `loc_7CEA` are hockey94_01 `startpause3` / `startpause4`.
  - IDA gaps written from the retail bytes: `setlccords` `String $BF,$16,0,0` then `add.w d0,(printy).w` and `moveq #2,d0` (IDA ori.b / ori.b / cmp.b); `Findhittype` `btst d0,#$F0` / `rts` and `btst d0,#$1E` / `rts` (IDA prints a bare `d0`, as 93 wrote them). The `dc.b` block at `$B602` is 10 SPA words (`SPAgglover` ... `SPAgstickl`, `SPA_148E` ... `SPA_1544`) with no reference.
  - IDA operator: `cmp.l #256^2,d0` means 256 squared; SNASM `^` is xor ($102). Written as `#$10000`. Verify 1 failed on this (3 bytes at `$BD3D`); check every IDA immediate with `^`.
  - Outside addresses: 43 stubs read from the retail operands; all 108 address locals and promoted labels assemble at their own address. 20 EA `cmp` opcodes patched.
- `logic94_2` matched: 2444 bytes, `$00C710-$00D09B`. `src/logic94_2_stub.asm` is `org $C710`, includes `macros\genesis.mac`, the three stubinc files and `logic94_2.asm`. Run `npm.cmd run seg:logic94_2`. A match must report 2444 bytes at `0x00c710-0x00d09b`.
  - Range: listing lines 37886-38681, `assbench` (`$C710`) through `asswingd`, as 93 logic93_2. `asswingo` (`$D09C`) is next. Both ends come from the `asstab` entries (`$18DA8`, `$18D8C`).
  - 94 has no fight code: `assfight` and `assfwatch` are an `rts`; the 93 `chkhit`, `ShowInjuryMsg`, `banner`, `addinfo` are not in 94. `assgoaliebreakwait` is new (asstab `$18DFC`).
  - Names: IDA names except `asseben` (IDA `assben`) and `assfaceoffp1` (IDA `assfaceoffpl`), the 93 names. IDA `_clrplayer` stays the local `.clrplayer` (93 made it global). IDA `exit` is the local `.exit`: a global would split assfaceoffp1. Calls to logic94_1 use its names (`setpads`, `check4bench`, `changeplayer`, `rtss3`). `movea.l #$E594,a0` is `#EvadePC`.
  - Outside addresses: 20 stubs read from the retail operands (`EvadePC` from a `lea (x,pc)` displacement). 14 EA `cmp` opcodes patched. No IDA gaps in this range. Matched on the first verify.
- `logic94_3` matched: 5522 bytes, `$00D09C-$00E62D`. `src/logic94_3_stub.asm` is `org $D09C`, includes `macros\genesis.mac`, the three stubinc files and `logic94_3.asm`. Run `npm.cmd run seg:logic94_3`. A match must report 5522 bytes at `0x00d09c-0x00e62d`.
  - Range: listing lines 38682-40488, `asswingo` through `EvadePC`, as 93 logic93_3. `checkob` (`$E62E`) is next.
  - Names: IDA names except `ClampYPosition` (`sub_DB3E`) and `AdjustFacingDirection` (`sub_DB68`), the 93 names. IDA `_checkanim` (a local of assgoaliecpu) is the global `checkanim`: assgoaliectrl branches to it across assgoaliecpu. IDA `compshoot?` is `compshoot` (`?` stripped; SNASM accepts `?` in a symbol, so a missed one still builds). IDA `_saveanim` is the local `.saveanim` (93 `GoalieSaveList`; the same 10 SPA words as the unreferenced logic94_1 table at `$B602`).
  - IDA gap: `AdjustFacingDirection` has three `btst d1,#imm` (`#$42`, `#$83`, `#$38`) that IDA cannot show, so it also lost the branch targets `.t` (`$DBA6`) and `.set` (`$DBB0`). Written from the retail bytes in the 93 form.
  - `fixopcodes.js` got the 93 `cmp` long rules `0C81`-`0C87` (`B2BC`-`BEBC`); it only had `cmpi.l` rules for d1 and d3. Verify 1 failed on `cmp.l #$2710,d1` at `$E35E` (built `0C81`, retail `B2BC`). All earlier segments still match. The `cmpi.l` `0C80` / `0C81` / `0C83` rules are still in the table; no segment so far has a real `cmpi.l #imm,Dn`.
  - Outside addresses: 27 stubs read from the retail operands; all 105 address locals assemble at their own address. 56 EA `cmp` opcodes patched.
