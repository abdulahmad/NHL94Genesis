# NHL 94 Sega CD

The disc is the cartridge game, linked again for the two Sega CD 68000s, with a new shell from the official Sega CD SDK around it. It is not a source-level rewrite, and it is not the cartridge ROM with a CD boot strapped on.

The six disc files used here live in `cdbin/` locally (`MAIN.BIN`, `STARTER.BIN`, `HOCKEY.BIN`, `PLAYER.BIN`, `GRAPH2.BIN`, `GTABLE.BIN`). They are not in the repo and nothing in the build makes them: copy them from the data track (ISO 9660 file system) of your own NHL '94 Sega CD disc into `cdbin/` (gitignored). Without them, `npm run build:segacd` still assembles the fragments, then stops at the verify step and names each missing file.

What the disc changed in gameplay, rosters and everything else, compared with the cartridge routine by routine, is [`docs/segacd_differences.md`](segacd_differences.md).

## What each file is

| File | CPU | What it is |
| --- | --- | --- |
| `STARTER.BIN` | Sub | SDK boot. Heap, film player, main/sub commands. Linked at `$21300`: the first instruction jumps to a Sierra C `link a6,#0` at `$262A8`. |
| `HOCKEY.BIN` | Sub | The game. Linked at `0` (its own branches land inside the file). About 181 KB. |
| `PLAYER.BIN` | Sub | A second module, also linked at `0`, with a relocating startup (`lea 0(pc,a6.l),a6`). Career stats, the team page, and player photos. The "Power play advantage" lines are this page, not the Ron Barr script. |
| `MAIN.BIN` | Main | SDK shell in Genesis RAM at `$FF0000`. Talks to the VDP and to the sub CPU through `$A120xx`. |
| `GTABLE.BIN` | | 2 KB of long offsets. |
| `GRAPH2.BIN` | | 3 MB graphics archive. The first longs are offsets into the file. |

`STARTER.BIN` and `MAIN.BIN` are the SDK. They contain `link a6` / `unlk a6` (39 and 26), `mmalloc` / `ffree`, `FilmOpen` / `FilmTask`, `Example Line 0` through `Example Line 7`, and the strings `SUBCPU is alive` and `MAINCPU is alive`. None of that is in the cartridge. Calls go through the sub CPU BIOS entry at `$6044` with the function number in `d7`.

`HOCKEY.BIN` has no `link a6`. It has 656 `rts` and 328 `movem.l` to the stack, the same shape as the cartridge, and it has the cartridge's screens: "Play Mode", "EA Hockey Night", "HAT TRICK!", "Line Editor", "SHOOTOUT MODE", the penalty names, the exception strings.

## The SDK change

The cartridge was built with EA's assembler. Short absolute addresses reach Genesis work RAM (`$B028` sign-extends to `$FFFFB028`), and `addq` / `bra.b` are used wherever they fit.

On the disc the same instructions were assembled with long addresses, because the game now runs on the sub CPU and those variables live in its program RAM. Two instructions from the end of the Play Mode screen:

Cartridge (`optsetup94`, bytes in front of `Play Mode`):

```
move.w  #0,$B02E.w
jsr     $11A48.l          ; printsmall
addq.w  #2,$B02A.w
bra.b   *-
bclr.b  #3,$C2F8.w
movem.l (sp)+,d0-d1
rts
```

Disc (`HOCKEY.BIN` `$928C`):

```
move.w  #0,$18D5E.l
jsr     $38D9E.l
addi.w  #2,$18D5A.l       ; addq has no absolute-long form
bra.w   *-                ; the function grew, so bra.b no longer reached
bclr.b  #3,$17F76.l
movem.l (sp)+,d0-d1
rts
```

Same order, same registers, same `#3` and `#2`. `addq` became `addi` and `bra.b` became `bra.w` because that is what the long addresses force. The EA Hockey Night ticker is the same kind of pair: `$B028` became `$18D58`.

| Cartridge | Disc | What |
| --- | --- | --- |
| `$FFB028` (`$B028.w`) | `$18D58` | print x |
| `$FFB02A` | `$18D5A` | print y |
| `$FFB02E` | `$18D5E` | print attribute |
| `$FFC2F8` (`$C2F8.w`) | `$17F76` | the flag byte `sflags6` |
| `$11086` random | `$37050` | absolute call |
| `$11340` ReadJoy1 | `$374F0` | absolute call |
| `$119B8` Framer | `$38CA0` | absolute call, 87 sites |
| `$11A48` printsmall | `$38D9E` | absolute call, 32 sites |
| `$11B92` printz | `$38F6E` | absolute call, 216 sites |
| `$11D3A` PushNumberWidth | `$3919A` | absolute call |
| `$11DE2` printbigz | `$39258` | absolute call, 36 sites |

`tools/segacd_relocs.py` finds these by matching six-instruction windows and keeping an absolute operand only when the cartridge address always becomes the same disc address. Run `python3 tools/segacd_relocs.py nhl94retail.bin cdbin/HOCKEY.BIN` for the full list (it needs the disc files in `cdbin/`).

Those `$37xxx`–`$39xxx` targets are above the end of `HOCKEY.BIN` (`$2D20A`). None of the six disc files, loaded flat, contains the reassembled bytes at that address. The same routines also exist inside `HOCKEY.BIN` (printsmall's register save is at `$1DDAC`) and are reached with `bsr`. A call site uses one or the other. The `$37xxx` image is the open question: it is linked, and it is not a raw slice of these files.

One path really changed. The address-error hex dump is byte for byte the same (`move.w (sp)+,d0` / `andi.w #$F,d0` / `addi.b #$30,d0`). The handler under it is not: the cartridge does `move #$2700,sr` and `bsr.w $11DE2` (printbigz); the disc does `bclr.b #5,$FF800F` and `jsr $39258`. `$39258` is that same printbigz. The new instruction is the sub CPU comm flag, which the cartridge does not have.

The team block at the front of `HOCKEY.BIN` matches the cartridge from Montreal's colors through the start of the roster (733 bytes, cart `$37E`, disc `$7C`) and then splits. The cartridge continues into "Madison Square Garden"; the disc has "Eastern division" there.

`PLAYER.BIN` and `HOCKEY.BIN` share no 16-byte window with each other that matters, and `PLAYER.BIN` shares almost nothing with the cartridge ROM (39 windows of 16 bytes). It is new code on the sub CPU, not a slice of `HOCKEY.BIN`.

## Disassembly that builds

`npm run build:segacd` (`node tools/build.js --segacd`) assembles the fragments below into `output/segacd/` and compares them to `cdbin/` with `tools/verifySegacd.js`. Each fragment's assembler options are in `tools/segacd.json`; a new fragment is one line there plus its compare in `verifySegacd.js`. The cartridge ROM is not involved. The Sega CD assemble uses `/o oz-` so a written `$0(an)` stays a 16-bit displacement. The cartridge build still uses `/o oz+`.

Verified bytes are 22,690 of the 410,162 bytes in the four code files (5.5%). `MAIN.BIN` is contiguous from the first byte through `$FF34B7` (13,496 of 60,416) plus the hardware readers and the Z80 loader (498 bytes more, 13,994 total, 23.2%). `STARTER.BIN` is 3,280 bytes. `HOCKEY.BIN` is 2,656 bytes. `PLAYER.BIN` is 2,760 bytes. `GRAPH2.BIN` and `GTABLE.BIN` are still untouched. CD audio is `docs/segacd_audio.md`. `song` and `sfx` are `docs/segacd_song.md`. The scouting-report script is `docs/segacd_announce.md`. Career stats and photos are `docs/segacd_stats.md`. Crowd frames are `docs/segacd_crowd.md`. The film player, Z80 loader, and hardware readers are `docs/segacd_film.md`.

| Source | Compared to | Bytes |
| --- | --- | --- |
| `src/segacd/main/maincd94cd.asm` | `cdbin/MAIN.BIN` | `$FF0000`-`$FF0271` (626) |
| `src/segacd/main/maindma94cd.asm` | `cdbin/MAIN.BIN` `$272` | `$FF0272`-`$FF04FF` (654) |
| `src/segacd/main/maincont94cd.asm` | `cdbin/MAIN.BIN` `$500` | `$FF0500`-`$FF0CB7` (1,976) |
| `src/segacd/main/mainblit94cd.asm` | `cdbin/MAIN.BIN` `$CB8` | `$FF0CB8`-`$FF12BF` (1,544) |
| `src/segacd/main/mainvdp94cd.asm` | `cdbin/MAIN.BIN` `$12C0` | `$FF12C0`-`$FF183F` (1,408) |
| `src/segacd/main/mainpad94cd.asm` | `cdbin/MAIN.BIN` `$1840` | `$FF1840`-`$FF1E8F` (1,616) |
| `src/segacd/main/maindisp94cd.asm` | `cdbin/MAIN.BIN` `$1E90` | `$FF1E90`-`$FF2D29` (3,738) |
| `src/segacd/main/mainfont94cd.asm` | `cdbin/MAIN.BIN` `$2D2A` | `$FF2D2A`-`$FF3029` (768) |
| `src/segacd/main/maintext94cd.asm` | `cdbin/MAIN.BIN` `$302A` | `$FF302A`-`$FF34B7` (1,166) |
| `src/segacd/starter/subboot94cd.asm` | `cdbin/STARTER.BIN` | first `$90` bytes (144) |
| `src/segacd/starter/subheap94cd.asm` | `cdbin/STARTER.BIN` `$4FA8` | `EngineIdle` and `GetData` (192) |
| `src/segacd/starter/pcmclear94cd.asm` | `cdbin/STARTER.BIN` `$3A0C` | PCM channel wipe (106) |
| `src/segacd/starter/cdcwait94cd.asm` | `cdbin/STARTER.BIN` `$3A76` | `CDBCHK` spin (20) |
| `src/segacd/starter/pcmchip94cd.asm` | `cdbin/STARTER.BIN` `$3FD0` | PCM init, start, stop, address, bank load (298) |
| `src/segacd/starter/audiostream94cd.asm` | `cdbin/STARTER.BIN` `$508C` | `AudioPlayPos` through `AudioBusy` (632) |
| `src/segacd/starter/cdfade94cd.asm` | `cdbin/STARTER.BIN` `$54F6` | seek/repeat, fader ramp, stop (120) |
| `src/segacd/hockey/middle94cd.asm` | `cdbin/HOCKEY.BIN` `$1C1D2` | `song` at runtime `$371D2` (52) |
| `src/segacd/hockey/middle94cd.asm` | `cdbin/HOCKEY.BIN` `$1C10C` | `sfx`, command `$26` (104) |
| `src/segacd/hockey/middle94cd.asm` | `cdbin/HOCKEY.BIN` `$1C174` | command `$34` (94) |
| `src/segacd/hockey/hockey94cd.asm` | `cdbin/HOCKEY.BIN` `$10B1E` | `song` then one `MSCPLAY1` (58) |
| `src/segacd/hockey/middle94cd.asm` | `cdbin/HOCKEY.BIN` `$1C206` | choose a track and `MSCPLAY1` (202) |
| `src/segacd/hockey/video94cd.asm` | `cdbin/HOCKEY.BIN` `$238CE` | crowd-volume slew, no PSG write (78) |
| `src/segacd/hockey/setup94cd.asm` | `cdbin/HOCKEY.BIN` `$24D66` | CD-DA mode, seek track 4, repeat it (130) |
| `src/segacd/hockey/scout94cd.asm` | `cdbin/HOCKEY.BIN` `$D1D4`..`$E1CE` | scouting report and matchup screen (ScoutCrowdRecord to ScoutStub), 94G names |
| `src/segacd/hockey/setup94cd.asm` | `cdbin/HOCKEY.BIN` `$2486C` | InitScoutingDisplay, UpdateScoutingDisplay, ScrollDisplayUp, with the cartridge labels (926) |
| `src/segacd/hockey/setup94cd.asm` | `cdbin/HOCKEY.BIN` `$24C12` | scouting file directory load (340) |
| `src/segacd/player/playerpic94cd.asm` | `cdbin/PLAYER.BIN` `$1D54` | player photo picker (700) |
| `src/segacd/player/playercareer94cd.asm` | `cdbin/PLAYER.BIN` `$2010` | career-stat rows (960) |
| `src/segacd/player/playerpage94cd.asm` | `cdbin/PLAYER.BIN` `$23D0` | team stat page (1,100) |
| `src/segacd/hockey/hockey94cd.asm` | `cdbin/HOCKEY.BIN` `$10D28` | crowd frame driver (318) |
| `src/segacd/hockey/tables94cd.asm` | `cdbin/HOCKEY.BIN` `$2654C` | crowd frame table, same as cartridge `updatecrowdf_cd0` (128) |
| `src/segacd/starter/filmrun94cd.asm` | `cdbin/STARTER.BIN` `$3D94` | movie open/task/close switch (278) |
| `src/segacd/starter/filmcmd94cd.asm` | `cdbin/STARTER.BIN` `$4D9E` | post a movie command (44) |
| `src/segacd/starter/filmbuf94cd.asm` | `cdbin/STARTER.BIN` `$4E26` | film buffer allocator (154) |
| `src/segacd/starter/filmopen94cd.asm` | `cdbin/STARTER.BIN` `$4336` | `FilmOpen` (514) |
| `src/segacd/starter/filmsm94cd.asm` | `cdbin/STARTER.BIN` `$3EAA` | `SM` chunk copy (294) |
| `src/segacd/starter/filmtask94cd.asm` | `cdbin/STARTER.BIN` `$458C` | `FilmTask` (418) |
| `src/segacd/starter/filmclose94cd.asm` | `cdbin/STARTER.BIN` `$473A` | `FilmClose` (66) |
| `src/segacd/main/z80load94cd.asm` | `cdbin/MAIN.BIN` `$76C8` | Z80 loader (240) |
| `src/segacd/main/hwread94cd.asm` | `cdbin/MAIN.BIN` `$3B3C` | VDP, joypad, and HV readers (258) |

`src/segacd/main/maincd94cd.asm` is the main CPU command loop: read `$A12020` when sub flag bit 6 is set, dispatch through the long table at `$FF01BE`, and put the VBlank vector at `$FD08` back when the command finishes. Past the handshake it clears the eight command words, waits on memory-mode bit 2, and hands word RAM back and forth (DMNA / RET in `$A12003`). Two commands add `$180000` to a sub CPU pointer so the main CPU sees the same word RAM (`$080000` there, `$200000` here).

`src/segacd/main/maindma94cd.asm` is the word-RAM blit that command path calls. It expands nibbles, writes the VDP at `$C00000`, and sets up DMA. A source in `$200000`-`$240000` is adjusted by two when the address is odd. The slice ends on `cmpa.w #0,a0`, and `src/segacd/main/maincont94cd.asm` is the rest of that routine: the VBlank-status spin at `$FF051C`, a copy of the `$23A450` block into `$FF284E`, VDP fills, and the helpers that add `$180000` to a pointer. A 9-long table sits at `$FF0C94`.

`src/segacd/main/mainblit94cd.asm` reads a byte stream into `$FF2DB2`-`$FF2DBA` and shakes the gate-array flag bits at `$A12018` / `$A12028`. It ends with the 16-long handler table at `$FF1280`. `src/segacd/main/mainvdp94cd.asm` is those handlers and the routines next to them: VDP data and register writes, waits on `$A12024`, and copies that add `$180000` before calling the DMA helper at `$FF0418`. The file stops on the `rts` at `$FF183E`.

`src/segacd/main/mainpad94cd.asm` is the zero fill after that `rts` and the byte table at `$FF1DBC`. `src/segacd/main/maindisp94cd.asm` saves the VBlank vector at `$FD08`, points it at `$FF1F8C`, and calls `MAINCODE`. When that returns it waits on a flag and puts the old vector back, then programs the VDP and copies tiles. `src/segacd/main/mainfont94cd.asm` is the font bitmap that follows the `rts` at `$FF2D28`.

`src/segacd/main/maintext94cd.asm` is the Sierra C handlers those calls land in: `DoDrawTextCommand`, `DoMoviePlayBack`, `MAINCODE`, `ReDraw`, `drawprint`, `NumStr`, `HexStr`, `aprint`, `InitWorld`, `GetCommandFromSub`, and `Set1MFlag`. Each `rts` is followed by the function name (a tag byte, then the ASCII). `InitWorld` prints `MAINCPU is alive`. The same eleven names occur again later in the file, `$2240` bytes on.

`src/segacd/starter/subboot94cd.asm` is the sub CPU's first instructions, the flag handshake, BIOS function 0 at `$6044`, and `jmp $1B000` into `HOCKEY.BIN`. `src/segacd/starter/subheap94cd.asm` is the Sierra C `EngineIdle` and `GetData` at `$262A8` (the `link a6` the boot jumps to). The function name is the bytes after each `rts`.

The audio slices are the sub CPU's CD-DA calls and the PCM stream. `docs/segacd_audio.md` lists the `_CDBIOS` numbers, the track word at `$1745E`, and the crowd-volume routine whose PSG stores were dropped. `src/segacd/hockey/scout94cd.asm` starts the scouting screen on song `$7A`. The scouting text player in `src/segacd/hockey/setup94cd.asm` types the Ron Barr script. `docs/segacd_announce.md` is that write-up.

`src/segacd/player/playerpic94cd.asm`, `src/segacd/player/playercareer94cd.asm`, and `src/segacd/player/playerpage94cd.asm` are the `PLAYER.BIN` overlay: a photo (or a generic `$504`-byte frame), the Regular/Playoff career rows, and the Players/Goalies page with the power-play lines. `docs/segacd_stats.md`.

`src/segacd/hockey/hockey94cd.asm` is the cartridge crowd-frame driver. The frame table in `src/segacd/hockey/tables94cd.asm` matches `updatecrowdf_cd0` with nothing added. The HV counter reads became command `$1B` and a word from `$FF8010`. `docs/segacd_crowd.md`.

`src/segacd/starter/filmrun94cd.asm` chooses `FilmOpen`, `FilmTask`, or `FilmClose`. `src/segacd/starter/filmcmd94cd.asm` posts that choice to the main CPU, where `DoMoviePlayBack` blits command `2`. `src/segacd/starter/filmbuf94cd.asm` allocates the buffer. `src/segacd/starter/filmopen94cd.asm`, `src/segacd/starter/filmsm94cd.asm`, `src/segacd/starter/filmtask94cd.asm`, and `src/segacd/starter/filmclose94cd.asm` are the `FILM` / `SM` player. `docs/segacd_film.md`.

`song` (runtime `$371D2`) and `sfx` (`$3710C`) are in `src/segacd/hockey/middle94cd.asm`. The game start in `src/segacd/hockey/hockey94cd.asm` has the one call that then `MSCPLAY1`s the track. `docs/segacd_song.md`.

`src/segacd/main/z80load94cd.asm` copies a `$C3 $00` block to the Z80. `src/segacd/main/hwread94cd.asm` is the main CPU's one-line port readers, including the HV counter copy into `$A12010`.

`tools/emit_m68k.py` writes a slice as SNASM (`moveq #-1` instead of `moveq #$FF`, unsized `btst` to a data register, `$FFFFFD08.w` instead of `$FD08.w`). `tools/segacd_relocs.py` is the six-instruction matcher that prints the cartridge-to-disc address pairs. Both are Sega CD helpers only; the cartridge build does not use them.

## GRAPH2.BIN assets

`GRAPH2.BIN` is not assembled, but `src/segacd/graph2/assets.json` (made by `tools/segcd_graph2_assets.py`, extracted by `tools/extractAssetsSegaCD.js` into `Extracted/SegaCD/GRAPH2/`) names 189 pieces, 629,126 of its 3,051,520 bytes: the 23-long offset directory (`Graph2Directory.bin`), the script text (`ScoutingReportText.bin`, chunk 0) and 187 pieces that are byte for byte cartridge assets and carry the cartridge name (team logos, player cards, NoPic pictures, fonts, rink, refs, crowd/Zamboni/faceoff animations, `Spritetiles.bin`, `frameSprData.bin`). Two more pieces are named by hand: `GoalieLicenseScreen.bin` (`$DD800`, 23,496 bytes, the license text over the goalie) and `GoalieLoadingScreen.bin` (`$E33C8`, 12,648 bytes, the loading screen). Both are stored uncompressed as `u16 $0808`, `u16` tile count, the 4bpp tiles, 128 bytes of CRAM, `u16` width, `u16` height (40 by 28) and the name table, and are listed in `GTABLE.BIN` (record 5 is the sector of the license screen). The 28 team pages (GTABLE.BIN records 68 to 95, in TeamList order, offsets `$1FB000` to `$2CB000`) are named `TeamDetails<T>.map.jim` (name banner, crest, arena photo), `TeamDetailsNoPhoto<T>.map.jim` (the same page with an empty photo frame) and `TeamVideoFrame<T>.map.jim` (the frame the team clips play in), each stored like the goalie screens, with `<T>` the team abbreviation the game uses (ANH, BOS, ... FLA, OTW, WSH, WPG, ASE, ASW). The rest of the block from `$B5E4E` to the end (about 2.3 MB, starts `08 05 12 34 56 78`) is not identified: it is not 4bpp tile data and matches no cartridge asset, so it has no name yet. `GTABLE.BIN` (512 longs) is not decoded either.
