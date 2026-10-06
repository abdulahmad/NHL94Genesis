# NHL 94 segment agent

This file is the queue and the history. Do not rewrite it as a whole file. Edit it in place.

## Current segment

`frames94`. Not matched. Starts at `SPAList` `$5B1C` (listing line 22741; `movea.l #$5B1C,a0` in the code), the byte after teamdata94. No file yet. `src/hockey94.asm` has no frames94 include (93 has `Frames93` after `TeamData93`); do not edit it. The ROM map note says SPAList ends near `unk_73A0`. Confirm the end against `lst/nhl94.bin` before writing instructions.

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
| frames94 | not matched | SPAList | no file yet. SPAList ends near unk_73A0 |
| ram94 | not matched | | equates only, no ROM bytes |
| hockey94_01 | not matched | VBjsr | line 29709, next loc_76E8 |
| attract94 | not matched | EASportsScreen | 94 only |
| hockey94_02 | not matched | ReplayMode | before doinput, if present |
| logic94_1 | not matched | doinput | line 35886, before loc_B470 |
| logic94_2 | not matched | assbench | |
| logic94_3 | not matched | asswingo | |
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
