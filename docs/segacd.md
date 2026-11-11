# NHL 94 Sega CD

The disc is the cartridge game, linked again for the two Sega CD 68000s, with a new shell from the official Sega CD SDK around it. It is not a source-level rewrite, and it is not the cartridge ROM with a CD boot strapped on.

The six disc files used here live in `cdbin/` locally (`MAIN.BIN`, `STARTER.BIN`, `HOCKEY.BIN`, `PLAYER.BIN`, `GRAPH2.BIN`, `GTABLE.BIN`). They are not in the repo and nothing in the build makes them: copy them from the data track (ISO 9660 file system) of your own NHL '94 Sega CD disc into `cdbin/` (gitignored). Without them, `npm run build:segacd` stops before assembling and names each missing file (the HOCKEY.BIN fragments read the licensed team nicknames from `cdbin/HOCKEY.BIN` with `incbin`, the way the cartridge build reads them from the ROM).

## What each file is

| File | CPU | What it is |
| --- | --- | --- |
| `STARTER.BIN` | Sub | SDK boot. Heap, film player, main/sub commands, the sub CPU driver. Runs at `$B000` (file + `$B000`): the opening `jmp $262A8` lands on its main entry (`movea.l #$C41C,sp`), and it loads HOCKEY.BIN at the end. |
| `HOCKEY.BIN` | Sub | The game. Linked at `0` (its own branches land inside the file). About 181 KB. |
| `PLAYER.BIN` | Sub | A second module, also linked at `0`, with a relocating startup (`lea 0(pc,a6.l),a6`). Career stats, the team page, and player photos. The "Power play advantage" lines are this page, not the Ron Barr script. |
| `MAIN.BIN` | Main | The main CPU shell and sound engine. Runs at `$FF1000` (file + `$FF1000`: its first instruction jumps to MainShellEntry at `$FF45A8`, and its command table sits at `$FF471C`). Talks to the VDP and to the sub CPU through `$A120xx`. `docs/segacd_main_shell.md`. |
| `GTABLE.BIN` | | The index of GRAPH2.BIN: 99 entries of start sector (word) and byte size (long). |
| `GRAPH2.BIN` | | 3 MB graphics archive: 99 resources, each on its own sectors, found through GTABLE.BIN. |
| boot area | Both | Not a file: the first 16 sectors of the data track (the disc header, the main CPU's initial program, the sub CPU's system program with the services at `$6044`). `tools/segacd_bootarea.py` copies it from a disc image to `cdbin/BOOT.BIN`; `src/segacd/boot/`, `docs/segacd_boot.md`. |

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

Those `$37xxx`–`$39xxx` targets are HOCKEY.BIN itself: the file runs at `$1B000`, so `$38D9E` is file `$1DD9E`, where the cartridge `printsmall` opening is (its register save is at `$1DDAC`). Inside the file the same routines are reached with `bsr`. `docs/segacd_memory_map.md` has the evidence and the sub CPU memory map.

One path really changed. The address-error hex dump is byte for byte the same (`move.w (sp)+,d0` / `andi.w #$F,d0` / `addi.b #$30,d0`). The handler under it is not: the cartridge does `move #$2700,sr` and `bsr.w $11DE2` (printbigz); the disc does `bclr.b #5,$FF800F` and `jsr $39258`. `$39258` is that same printbigz. The new instruction is the sub CPU comm flag, which the cartridge does not have.

The team block at the front of `HOCKEY.BIN` matches the cartridge from Montreal's colors through the start of the roster (733 bytes, cart `$37E`, disc `$7C`) and then splits. The cartridge continues into "Madison Square Garden"; the disc has "Eastern division" there.

`PLAYER.BIN` and `HOCKEY.BIN` share no 16-byte window with each other that matters, and `PLAYER.BIN` shares almost nothing with the cartridge ROM (39 windows of 16 bytes). It is new code on the sub CPU, not a slice of `HOCKEY.BIN`.

## Disassembly that builds

`npm run build:segacd` (`node tools/build.js --segacd`) assembles the fragments below into `output/segacd/` and compares them to `cdbin/` with `tools/verifySegacd.js`. Each fragment's assembler options are in `tools/segacd.json`; a new fragment is one line there plus its compare in `verifySegacd.js`. The cartridge ROM is not involved. The Sega CD assemble uses `/o oz-` so a written `$0(an)` stays a 16-bit displacement. The cartridge build still uses `/o oz+`.

Verified bytes are 410,162 of the 410,162 bytes in the four code files (all of them; `tools/segacd_check.sh` prints the current numbers). Before the HOCKEY.BIN segments they were 22,690 (5.5%). `MAIN.BIN` is contiguous from the first byte through `$FF34B7` (13,496 of 60,416) and the rest of the file is in `src/segacd/main/` (`tools/segacd_main.sh`): MAIN.BIN matches in full. The Z80 sound image at `$5E0C`-`$765B` (not the cartridge driver) is Z80 source, `src/segacd/main/mainz80.z80` (asm80, written by `tools/segacd_z80dis.py`; `tools/build.js --segacd` assembles it before the fragments). z80load.asm copies all `$1850` bytes to Z80 RAM `$0000`: the vectors, the program at `$0600` (2,848 bytes of code), its tables, and zeroed RAM. `STARTER.BIN` matches in full; 86,838 of its bytes (five pictures and a PCM sample) and its credits text are read from the disc with `incbin`. `HOCKEY.BIN` is matched in full (184,842 bytes), most of it the 94G twins in `src/segacd/hockey/`. 43,120 of those bytes are read from the disc file with `incbin`: graphics (palettes, pictures, arena animations), the licensed player names and team nicknames, and the team data blocks that differ from the cartridge; the rest is source. `PLAYER.BIN` matches in full: the older fragments plus `src/segacd/player/` (`tools/segacd_player.sh`); its 25,806 bytes of pictures are read from the disc with `incbin`. It is the player information overlay HOCKEY.BIN runs from `RunPlayerOverlay` (cards94); its routines are named in `docs/segacd_player.md`. `GRAPH2.BIN` and `GTABLE.BIN` (`src/segacd/data/`) match too: GRAPH2 is an archive of 99 resources and GTABLE its index (see "GRAPH2.BIN and GTABLE.BIN" below). All six disc files are built byte for byte. CD audio is `docs/segacd_audio.md`. `song` and `sfx` are `docs/segacd_song.md`. The scouting-report script is `docs/segacd_announce.md`. Career stats and photos are `docs/segacd_stats.md`. Crowd frames are `docs/segacd_crowd.md`. The film player, Z80 loader, and hardware readers are `docs/segacd_film.md`.

| Source | Compared to | Bytes |
| --- | --- | --- |
| `src/segacd/maincd.asm` | `cdbin/MAIN.BIN` | `$FF1000`-`$FF1271` (626) |
| `src/segacd/maindma.asm` | `cdbin/MAIN.BIN` `$272` | `$FF1272`-`$FF14FF` (654) |
| `src/segacd/maincont.asm` | `cdbin/MAIN.BIN` `$500` | `$FF1500`-`$FF1CB7` (1,976) |
| `src/segacd/mainblit.asm` | `cdbin/MAIN.BIN` `$CB8` | `$FF1CB8`-`$FF22BF` (1,544) |
| `src/segacd/mainvdp.asm` | `cdbin/MAIN.BIN` `$12C0` | `$FF22C0`-`$FF283F` (1,408) |
| `src/segacd/mainpad.asm` | `cdbin/MAIN.BIN` `$1840` | `$FF2840`-`$FF2E8F` (1,616) |
| `src/segacd/maindisp.asm` | `cdbin/MAIN.BIN` `$1E90` | `$FF2E90`-`$FF3D29` (3,738) |
| `src/segacd/mainfont.asm` | `cdbin/MAIN.BIN` `$2D2A` | `$FF3D2A`-`$FF4029` (768) |
| `src/segacd/maintext.asm` | `cdbin/MAIN.BIN` `$302A` | `$FF402A`-`$FF44B7` (1,166) |
| `src/segacd/subboot.asm` | `cdbin/STARTER.BIN` | first `$90` bytes (144) |
| `src/segacd/subheap.asm` | `cdbin/STARTER.BIN` `$4FA8` | `EngineIdle` and `GetData` (192) |
| `src/segacd/pcmclear.asm` | `cdbin/STARTER.BIN` `$3A0C` | PCM channel wipe (106) |
| `src/segacd/cdcwait.asm` | `cdbin/STARTER.BIN` `$3A76` | `CDBCHK` spin (20) |
| `src/segacd/pcmchip.asm` | `cdbin/STARTER.BIN` `$3FD0` | PCM init, start, stop, address, bank load (298) |
| `src/segacd/audiostream.asm` | `cdbin/STARTER.BIN` `$508C` | `AudioPlayPos` through `AudioBusy` (632) |
| `src/segacd/cdfade.asm` | `cdbin/STARTER.BIN` `$54F6` | seek/repeat, fader ramp, stop (120) |
| `src/segacd/cdrequest.asm` | `cdbin/HOCKEY.BIN` `$1C1D2` | `song` at runtime `$371D2` (52) |
| `src/segacd/sfxcd.asm` | `cdbin/HOCKEY.BIN` `$1C10C` | `sfx`, command `$26` (104) |
| `src/segacd/gate34.asm` | `cdbin/HOCKEY.BIN` `$1C174` | command `$34` (94) |
| `src/segacd/songplay.asm` | `cdbin/HOCKEY.BIN` `$10B1E` | `song` then one `MSCPLAY1` (58) |
| `src/segacd/cdtrack.asm` | `cdbin/HOCKEY.BIN` `$1C206` | choose a track and `MSCPLAY1` (202) |
| `src/segacd/cdcrowd.asm` | `cdbin/HOCKEY.BIN` `$238CE` | crowd-volume slew, no PSG write (78) |
| `src/segacd/cdstart.asm` | `cdbin/HOCKEY.BIN` `$24D66` | CD-DA mode, seek track 4, repeat it (130) |
| `src/segacd/scoutopen.asm` | `cdbin/HOCKEY.BIN` `$D2B6` | scouting screen open, song `$7A` (226) |
| `src/segacd/scouttext.asm` | `cdbin/HOCKEY.BIN` `$2486C` | scouting text player (542) |
| `src/segacd/scouttok.asm` | `cdbin/HOCKEY.BIN` `$24A8A` | scouting script tokens (384) |
| `src/segacd/scoutload.asm` | `cdbin/HOCKEY.BIN` `$24C12` | scouting file directory load (340) |
| `src/segacd/playerpic.asm` | `cdbin/PLAYER.BIN` `$1D54` | player photo picker (700) |
| `src/segacd/playercareer.asm` | `cdbin/PLAYER.BIN` `$2010` | career-stat rows (960) |
| `src/segacd/playerpage.asm` | `cdbin/PLAYER.BIN` `$23D0` | team stat page (1,100) |
| `src/segacd/player/playerinit.asm` | `cdbin/PLAYER.BIN` `$0` | start-up (pc-relative stack and a6) and the code before `playerpic.asm` (7,508) |
| `src/segacd/player/playercode.asm` | `cdbin/PLAYER.BIN` `$281C` | the code after `playerpage.asm` (5,992) |
| `src/segacd/player/playertext.asm` | `cdbin/PLAYER.BIN` `$3F84` | column tables and stat-page headings (322) |
| `src/segacd/player/playerphotos.asm` | `cdbin/PLAYER.BIN` `$40C6` | the pictures (read from the disc) and the zero variable area; by hand (28,074) |
| `src/segacd/crowdanim.asm` | `cdbin/HOCKEY.BIN` `$10D28` | crowd frame driver (318) |
| `src/segacd/crowdtable.asm` | `cdbin/HOCKEY.BIN` `$2654C` | crowd frame table, same as cartridge `updatecrowdf_cd0` (128) |
| `src/segacd/filmrun.asm` | `cdbin/STARTER.BIN` `$3D94` | movie open/task/close switch (278) |
| `src/segacd/filmcmd.asm` | `cdbin/STARTER.BIN` `$4D9E` | post a movie command (44) |
| `src/segacd/filmbuf.asm` | `cdbin/STARTER.BIN` `$4E26` | film buffer allocator (154) |
| `src/segacd/filmopen.asm` | `cdbin/STARTER.BIN` `$4336` | `FilmOpen` (514) |
| `src/segacd/filmsm.asm` | `cdbin/STARTER.BIN` `$3EAA` | `SM` chunk copy (294) |
| `src/segacd/filmtask.asm` | `cdbin/STARTER.BIN` `$458C` | `FilmTask` (418) |
| `src/segacd/filmclose.asm` | `cdbin/STARTER.BIN` `$473A` | `FilmClose` (66) |
| `src/segacd/z80load.asm` | `cdbin/MAIN.BIN` `$76C8` | Z80 loader (240) |
| `src/segacd/hwread.asm` | `cdbin/MAIN.BIN` `$3B3C` | VDP, joypad, and HV readers (258) |
| `src/segacd/main/maindisp_2.asm` | `cdbin/MAIN.BIN` `$40D0` | the second copy of `maindisp.asm` (3,738) |
| `src/segacd/main/mainfont_2.asm` | `cdbin/MAIN.BIN` `$4F6A` | the second copy of `mainfont.asm` (768) |
| `src/segacd/main/maintext_2.asm` | `cdbin/MAIN.BIN` `$526A` | the second copy of `maintext.asm` (1,166) |
| `src/segacd/main/maincrt.asm` | `cdbin/MAIN.BIN` `$34B8` | Sierra C run-time helpers (240) |
| `src/segacd/main/mainstart.asm` | `cdbin/MAIN.BIN` `$35A8` | MainShellEntry and the command loop (372) |
| `src/segacd/main/maintable.asm` | `cdbin/MAIN.BIN` `$371C` | the game shell's 64 command handler pointers, by name; by hand (256) |
| `src/segacd/main/mainstart_2.asm` | `cdbin/MAIN.BIN` `$381C` | interrupt handlers, start-up handshake, commands `$01`-`$08` (800) |
| `src/segacd/main/mainwram.asm` | `cdbin/MAIN.BIN` `$3C3E` | commands `$1D`-`$26`, `$2C`, `$3E`: fades, DMA, sound, pads (1,170) |
| `src/segacd/main/maincrt_2.asm` | `cdbin/MAIN.BIN` `$56F8` | the second copy of `maincrt.asm` (240) |
| `src/segacd/main/mainvdpinit.asm` | `cdbin/MAIN.BIN` `$57E8` | commands `$27`-`$40`: interrupts, sound driver, V interrupt channel, screens (1,572) |
| `src/segacd/main/mainz80.asm` | `cdbin/MAIN.BIN` `$5E0C` | the Z80 sound image (vectors, program at Z80 `$0600`, RAM): the asm80 build of `mainz80.z80` (6,224) |
| `src/segacd/main/maincmd.asm` | `cdbin/MAIN.BIN` `$765C` | DispatchSoundOperation (108) |
| `src/segacd/main/mainmod.asm` | `cdbin/MAIN.BIN` `$77B8` | the sound sequence engine, its tables, zeros to the end (29,768) |
| `src/segacd/starter/subhdr.asm` | `cdbin/STARTER.BIN` `$90` | zeros, the driver module's file record and entry table (5,298) |
| `src/segacd/starter/subdrv.asm` | `cdbin/STARTER.BIN` `$1542` | the sub CPU driver module, runtime file + `$B000` (9,418) |
| `src/segacd/starter/subdrv_2.asm` | `cdbin/STARTER.BIN` `$3A8A` | the end of the driver module (778) |
| `src/segacd/starter/subirq.asm` | `cdbin/STARTER.BIN` `$40FA` | BIOS vector hook, `Wait` (572) |
| `src/segacd/starter/subtext.asm` | `cdbin/STARTER.BIN` `$4788` | `SwapMeg`, `DrawText`, `NumStr`, `HexStr`, `aprint` (626) |
| `src/segacd/starter/heapalloc.asm` | `cdbin/STARTER.BIN` `$49FA` | `ffree`, `findSmallestBlock`, `MaxFree`, `mmalloc`, `InitHeap` (650) |
| `src/segacd/starter/subinit.asm` | `cdbin/STARTER.BIN` `$4C84` | `InitWorld`, `GetTicks`, `WaitIODone` (282) |
| `src/segacd/starter/copydata.asm` | `cdbin/STARTER.BIN` `$4DDE` | `CopyData` (72) |
| `src/segacd/starter/engine.asm` | `cdbin/STARTER.BIN` `$4ECE` | `DisposeEngine`, `GetSectDst`, `PeekSectDst` (218) |
| `src/segacd/starter/readdata.asm` | `cdbin/STARTER.BIN` `$5068` | `ReadData` (36) |
| `src/segacd/starter/crt.asm` | `cdbin/STARTER.BIN` `$5304` | Sierra C run-time: 32-bit multiply, divide (498) |
| `src/segacd/starter/film*_tag.asm` | `cdbin/STARTER.BIN` `$4538` ... | the name tags (and FilmOpen's strings) after the older film fragments (142) |
| `src/segacd/starter/startertext.asm` | `cdbin/STARTER.BIN` `$556E` | tables and the Example Line strings, as bytes (1,642) |
| `src/segacd/starter/startergfx.asm` | `cdbin/STARTER.BIN` `$5BD8` | five screens and the block for driver function 5, read from the disc; by hand (86,838) |
| `src/segacd/starter/startertail.asm` | `cdbin/STARTER.BIN` `$1AF0E` | credits text (read from the disc) and code to the end (9,898) |
| `src/segacd/data/gtable.asm` | `cdbin/GTABLE.BIN` | the 99 index entries as source, the start sectors worked out from the sizes (2,048) |
| `src/segacd/data/graph2.asm` | `cdbin/GRAPH2.BIN` | the 99 resources; the two packs' offset tables, end marks and zero fill as source, the graphics read from the disc (3,051,520) |
| `src/segacd/hockey/teamdata94.asm` | `cdbin/HOCKEY.BIN` `$0` | header and `teamdata94.asm`: team records; licensed names read from the disc (21,554) |
| `src/segacd/hockey/frames94.asm` | `cdbin/HOCKEY.BIN` `$5432` | `frames94.asm`: sprite animation tables, unchanged (7,062) |
| `src/segacd/hockey/sram94.asm` | `cdbin/HOCKEY.BIN` `$6FC8` | `sram94.asm`: CD start-up, `Begin` (the game start), backup RAM (1,388) |
| `src/segacd/hockey/cards94_2.asm` | `cdbin/HOCKEY.BIN` `$7534` | `cards94.asm` part 2: the save RAM readers, moved here (372) |
| `src/segacd/hockey/onetimer94.asm` | `cdbin/HOCKEY.BIN` `$76A8` | `onetimer94.asm`: the one-timer (1,844) |
| `src/segacd/hockey/fourway94.asm` | `cdbin/HOCKEY.BIN` `$7DDC` | `fourway94.asm`: only `Set4WayPlayer` is left (92) |
| `src/segacd/hockey/crowd94.asm` | `cdbin/HOCKEY.BIN` `$7E38` | `crowd94.asm`: crowd records, hot and cold players, corner collisions (1,428) |
| `src/segacd/hockey/optsetup94.asm` | `cdbin/HOCKEY.BIN` `$83CC` | `optsetup94.asm`: game setup and options (6,034) |
| `src/segacd/hockey/cards94.asm` | `cdbin/HOCKEY.BIN` `$9B5E` | `cards94.asm`: user records bookkeeping, ratings; no player card screen (6,122) |
| `src/segacd/hockey/records94.asm` | `cdbin/HOCKEY.BIN` `$B348` | `records94.asm`: name entry and Record Holders (5,400) |
| `src/segacd/hockey/shootout94.asm` | `cdbin/HOCKEY.BIN` `$C860` | `shootout94.asm`: shootout (2,420) |
| `src/segacd/hockey/scout94.asm` | `cdbin/HOCKEY.BIN` `$D1D4` | `scout94.asm` part 1: matchups (226) |
| `src/segacd/hockey/scout94_2.asm` | `cdbin/HOCKEY.BIN` `$D398` | `scout94.asm` part 2, after `scoutopen.asm`: scouting report screen (3,638) |
| `src/segacd/hockey/period94.asm` | `cdbin/HOCKEY.BIN` `$E1CE` | `period94.asm`: period stats, game statistics, Manual Goalie (4,060) |
| `src/segacd/hockey/arena94.asm` | `cdbin/HOCKEY.BIN` `$F1AA` | `arena94.asm`: arena / faceoff animations (994) |
| `src/segacd/hockey/shootoutpath94.asm` | `cdbin/HOCKEY.BIN` `$F58C` | `shootoutpath94.asm`: saved lines, shootout skate paths (886) |
| `src/segacd/hockey/ui94.asm` | `cdbin/HOCKEY.BIN` `$F902` | `ui94.asm`: unpack, rink graphics, HiScore, played-by (1,382) |
| `src/segacd/hockey/helpers94.asm` | `cdbin/HOCKEY.BIN` `$FE68` | `helpers94.asm` (238) |
| `src/segacd/hockey/logos94.asm` | `cdbin/HOCKEY.BIN` `$FF56` | `logos94.asm`: logo palettes, lead song, hot / cold icon (1,420) |
| `src/segacd/hockey/chgplayer94.asm` | `cdbin/HOCKEY.BIN` `$104E2` | `chgplayer94.asm`: chgplayer and far thunks (306) |
| `src/segacd/hockey/hockey94.asm` | `cdbin/HOCKEY.BIN` `$10614` | `hockey94.asm` part 1: game and period start, clock (1,290) |
| `src/segacd/hockey/hockey94_2.asm` | `cdbin/HOCKEY.BIN` `$10B58` | `hockey94.asm` part 2, after `songplay.asm` (464) |
| `src/segacd/hockey/hockey94_3.asm` | `cdbin/HOCKEY.BIN` `$10E66` | `hockey94.asm` part 3, after `crowdanim.asm` (1,170) |
| `src/segacd/hockey/menu94.asm` | `cdbin/HOCKEY.BIN` `$112F8` | `menu94.asm`: menu core (872) |
| `src/segacd/hockey/stats94.asm` | `cdbin/HOCKEY.BIN` `$11660` | `stats94.asm`: scores, line editor, roster, stat screens (10,148) |
| `src/segacd/hockey/replay94.asm` | `cdbin/HOCKEY.BIN` `$13E04` | `replay94.asm`: replay (2,950) |
| `src/segacd/hockey/logic94.asm` | `cdbin/HOCKEY.BIN` `$1498A` | `logic94.asm`: player update, input, assignments (29,224) |
| `src/segacd/hockey/middle94.asm` | `cdbin/HOCKEY.BIN` `$1BBB2` | `middle94.asm` part 1: shared helpers (1,370) |
| `src/segacd/hockey/middle94_2.asm` | `cdbin/HOCKEY.BIN` `$1C2D0` | `middle94.asm` part 2, after `sfxcd` ... `cdtrack` (5,750) |
| `src/segacd/hockey/decompress94.asm` | `cdbin/HOCKEY.BIN` `$1D946` | `decompress94.asm`: graphics decompressor (654) |
| `src/segacd/hockey/print94.asm` | `cdbin/HOCKEY.BIN` `$1DBD4` | `print94.asm`: print routines (2,118) |
| `src/segacd/hockey/penalty94.asm` | `cdbin/HOCKEY.BIN` `$1E41A` | `penalty94.asm` part 1, up to `updatepwrplay` (3,296) |
| `src/segacd/hockey/collide94.asm` | `cdbin/HOCKEY.BIN` `$1F0FA` | `collide94.asm` part 1, up to `setpersonel` (8,662) |
| `src/segacd/hockey/penalty94_2.asm` | `cdbin/HOCKEY.BIN` `$212D0` | `penalty94.asm` part 2 (4,438) |
| `src/segacd/hockey/collide94_2.asm` | `cdbin/HOCKEY.BIN` `$22426` | `collide94.asm` part 2 (1,682) |
| `src/segacd/hockey/video94.asm` | `cdbin/HOCKEY.BIN` `$22AB8` | `video94.asm`: vblank, clock, rink scroll; before `cdcrowd.asm` (3,606) |
| `src/segacd/hockey/setup94.asm` | `cdbin/HOCKEY.BIN` `$2391C` | `setup94.asm` part 1: ice setup, attract (3,920) |
| `src/segacd/hockey/setup94_2.asm` | `cdbin/HOCKEY.BIN` `$24C0A` | `setup94.asm` part 2: the 8 bytes between `scouttok.asm` and `scoutload.asm` (8) |
| `src/segacd/hockey/setup94_3.asm` | `cdbin/HOCKEY.BIN` `$24DE8` | `setup94.asm` part 3, after `cdstart.asm`: menus, playoff data (5,988) |
| `src/segacd/hockey/tables94.asm` | `cdbin/HOCKEY.BIN` `$265CC` | `tables94.asm` after `crowdtable.asm`: asstab, penalties, playoff tree, menu lists (4,820) |
| `src/segacd/hockey/graphics94.asm` | `cdbin/HOCKEY.BIN` `$278A0` | `graphics94.asm` part 1: picture palette and no-picture cards, read from the disc (4,574) |
| `src/segacd/hockey/graphics94_2.asm` | `cdbin/HOCKEY.BIN` `$28A7E` | `graphics94.asm` part 2: arena animation graphics and more, read from the disc; by hand (17,022) |
| `src/segacd/hockey/cdgfxptrs.asm` | `cdbin/HOCKEY.BIN` `$2CCFC` | CD-only: the graphics pointer table (zeros, filled at run time), 31 of 44 entries named `<label>Ptr` after the cartridge graphic the replaced lines loaded; by hand (176) |
| `src/segacd/hockey/cdpads.asm` | `cdbin/HOCKEY.BIN` `$2CDAC` | CD-only: `ReadPads`, the pads through the main CPU (1,118) |

`maincd.asm` is the main CPU command loop: read `$A12020` when sub flag bit 6 is set, dispatch through `CmdJumpTable` at `$FF11BE`, and put the VBlank vector at `$FD08` back when the command finishes. Past the handshake it clears the eight command words, waits on memory-mode bit 2, and hands word RAM back and forth (DMNA / RET in `$A12003`). Two commands add `$180000` to a sub CPU pointer so the main CPU sees the same word RAM (`$080000` there, `$200000` here).

`maindma.asm` is the word-RAM blit that command path calls. It expands nibbles, writes the VDP at `$C00000`, and sets up DMA. A source in `$200000`-`$240000` is adjusted by two when the address is odd. The slice ends on `cmpa.w #0,a0`, and `maincont.asm` is the rest of that routine: the VBlank-status spin at `$FF051C`, a copy of the `$23A450` block into `$FF284E`, VDP fills, and the helpers that add `$180000` to a pointer. A 9-long table sits at `$FF0C94`.

`mainblit.asm` reads a byte stream into `$FF2DB2`-`$FF2DBA` and shakes the gate-array flag bits at `$A12018` / `$A12028`. It ends with the 16-long handler table at `$FF1280`. `mainvdp.asm` is those handlers and the routines next to them: VDP data and register writes, waits on `$A12024`, and copies that add `$180000` before calling the DMA helper at `$FF0418`. The file stops on the `rts` at `$FF183E`.

`mainpad.asm` is the zero fill after that `rts` and the byte table at `$FF1DBC`. `maindisp.asm` saves the VBlank vector at `$FD08`, points it at `$FF1F8C`, and calls `MAINCODE`. When that returns it waits on a flag and puts the old vector back, then programs the VDP and copies tiles. `mainfont.asm` is the font bitmap that follows the `rts` at `$FF2D28`.

`maintext.asm` is the Sierra C handlers those calls land in: `DoDrawTextCommand`, `DoMoviePlayBack`, `MAINCODE`, `ReDraw`, `drawprint`, `NumStr`, `HexStr`, `aprint`, `InitWorld`, `GetCommandFromSub`, and `Set1MFlag`. Each `rts` is followed by the function name (a tag byte, then the ASCII). `InitWorld` prints `MAINCPU is alive`. MAIN.BIN `$40D0`-`$56F7` is a byte-for-byte second copy of `$1E90`-`$34B7` (`maindisp`, `mainfont`, `maintext`, `$2240` bytes on); `src/segacd/main/*_2.asm` include those three files unchanged and are compared there.

`subboot.asm` is the sub CPU's first instructions, the flag handshake, BIOS function 0 at `$6044`, and `jmp $1B000` into `HOCKEY.BIN`. `subheap.asm` is the Sierra C `EngineIdle` and `GetData` at `$262A8` (the `link a6` the boot jumps to). The function name is the bytes after each `rts`.

The audio slices are the sub CPU's CD-DA calls and the PCM stream. `docs/segacd_audio.md` lists the `_CDBIOS` numbers, the track word at `$1745E`, and the crowd-volume routine whose PSG stores were dropped. `scoutopen.asm` starts the scouting screen on song `$7A`. `scouttext.asm` and `scouttok.asm` type the Ron Barr script. `docs/segacd_announce.md` is that write-up.

`playerpic.asm`, `playercareer.asm`, and `playerpage.asm` are the `PLAYER.BIN` overlay: a photo (or a generic `$504`-byte frame), the Regular/Playoff career rows, and the Players/Goalies page with the power-play lines. `docs/segacd_stats.md`.

`crowdanim.asm` is the cartridge crowd-frame driver. The frame table in `crowdtable.asm` matches `updatecrowdf_cd0` with nothing added. The HV counter reads became command `$1B` and a word from `$FF8010`. `docs/segacd_crowd.md`.

`filmrun.asm` chooses `FilmOpen`, `FilmTask`, or `FilmClose`. `filmcmd.asm` posts that choice to the main CPU, where `DoMoviePlayBack` blits command `2`. `filmbuf.asm` allocates the buffer. `filmopen.asm`, `filmsm.asm`, `filmtask.asm`, and `filmclose.asm` are the `FILM` / `SM` player. `docs/segacd_film.md`.

`cdrequest.asm` is `song` at runtime `$371D2`. `sfxcd.asm` is `sfx` at `$3710C`. `songplay.asm` is the one call that then `MSCPLAY1`s the track. `docs/segacd_song.md`.

`z80load.asm` copies a `$C3 $00` block to the Z80. `hwread.asm` is the main CPU's one-line port readers, including the HV counter copy into `$A12010`.

## The boot area

The disc's boot sectors hold two more programs: the initial program the BIOS runs on the main CPU (Sega's security block, then a loader that copies MAIN.BIN from word RAM to `$FF1000`) and the system program on the sub CPU at `$6000`. The system program loads MAIN.BIN, GTABLE.BIN and STARTER.BIN at start-up and provides the services every program calls at `$6044`: sector reads, GRAPH2 resources, the PLAYER overlay, films, sound set-up. `docs/segacd_boot.md` has the details; `src/segacd/boot/` builds when `cdbin/BOOT.BIN` is there (`tools/segacd_bootarea.py`).

## STARTER.BIN

STARTER.BIN runs at file + `$B000` (runtime `$B000`-`$285B7`), the whole file. Every absolute call and data address in it fits that base and not `$21300`, the base the older fragments assumed: the boot's first line keeps the BIOS vector at `$B090` (file `$90`, the zero area after the boot); its `jmp $262A8` lands on the main entry in the tail code (file `$1B2A8`: `movea.l #$C41C,sp`, clear the gate array command words, call two routines); the driver module's `jmp $D85A` is file `$285A` and 17 of its 19 absolute calls fall just after an `rts`; crt's `lea $104EC.l` is the data after crt (file `$54EC`); and 9 of the tail's 14 absolute call targets fall on a routine start at `$B000`, none at `$21300`. The opening `jmp` would also land on a `link a6` at `$21300` (file `$4FA8`), which is how that base was first read. The older fragments (`subboot.asm`, `pcmclear.asm`, `filmrun.asm` ...) were written at `$21300`. They are at `$B000` now: their `org`s, the equates they reach pc-relative and the labels named after addresses moved, and the bytes are the same.

The parts: the boot (file `$0`-`$8F`), a zero area with a file record (`HOCKEY.BIN`) and the stack top at `$C41C`, the sub CPU driver module (file `$1000`-`$3D93`, runtime `$C000`-`$ED93`; it talks to the gate array through short addresses, `$8020.w` is `$FF8020`), the C part from `$3D94` (the film player, the heap, the audio stream: Sierra C, each function's name in the tag after its `rts`), data, and the tail code. The load order follows from the base: the tail code runs the start-up, then jumps to `$B00E` in the boot, which loads HOCKEY.BIN at `$1B000` (BIOS function 0) over STARTER's top part (file `$10000` on, no longer needed) and jumps into the game. The driver module and the C part stay resident below `$1B000`; HOCKEY.BIN's BIOS calls (`$6044`) go to them. From `$556E` on the file is data: tables and the Example Line strings; from `$5BD8` five `.map.jim` pictures that the driver module copies one after another to `$80000`: the Credits title, the credits font, "High Score Productions presents", the EA SPORTS logo in sprite pieces and sparkle frames (the last four with packed tiles: the cartridge's DecompressBytecode format, which MAIN.BIN's copy of DecompressGraphics unpacks); from `$C56C` to `$1AF0D` a block with only two zero bytes that the driver passes to its function 5; then credits text and the tail code. The credits name real people, so `startertail.asm` reads every text run from the disc (`--text-incbin`).

The new fragments are in `src/segacd/starter/` and fill the gaps between the older ones. `tools/segacd_starter.sh` writes them with `segacd_port.py --plain --tags --base`: `--tags` names each C function from its tag, writes the tag as `dc.b $8A,'EngineIdle',0,0,0`, and names calls to other tagged functions. An absolute call into the same fragment gets that address's label. The driver module's routines are named (`docs/segacd_starter_driver.md`; the names are given here, with their evidence in `tools/segacd_starter.sh`), and the other fragments' calls into it use them.

`tools/emit_m68k.py` writes a slice as SNASM (`moveq #-1` instead of `moveq #$FF`, unsized `btst` to a data register, `$FFFFFD08.w` instead of `$FD08.w`). `tools/segacd_relocs.py` is the six-instruction matcher that prints the cartridge-to-disc address pairs. Both are Sega CD helpers only; the cartridge build does not use them.

## HOCKEY.BIN from the cartridge source

HOCKEY.BIN runs at `$1B000` (`docs/segacd_memory_map.md`) and is linked in the cartridge's file order, with the files that are new in 94 moved in front of `hockey94.asm`: team data, then `onetimer94`, `fourway94`, `crowd94`, `optsetup94`, `cards94`, `records94`, `shootout94`, `scout94`, `period94`, `arena94`, `shootoutpath94`, `ui94`, `helpers94`, (`title94`, not yet matched), `logos94`, `chgplayer94`, then `hockey94`, `menu94`, `stats94`, `replay94`, `logic94`, `middle94` and the rest. Each disc segment is the twin of one 94G file and sits in `src/segacd/hockey/` under that file's name, with the 94G names. The older hand-made fragments in `src/segacd/` keep their own files: a 94G file whose disc range holds one is written in parts around it (`hockey94.asm`, `hockey94_2.asm`, `hockey94_3.asm` around `songplay.asm` and `crowdanim.asm`), and each part's header names its neighbours. On the disc `penalty94` and `collide94` are interleaved (half of each, twice), so each has two parts as well.

The disc assembler did not optimise: an unsized branch is `.w`, `add`/`sub` of a small immediate is `addi`/`subi` (never `addq`/`subq`), `cmp.l #n,dn` is `cmpi.l` (the cartridge ROM has `cmp.l`, one of its fixopcodes patches), a zero displacement stays `0(an)`. Absolute addresses are long because the variables and the code are above `$7FFF` on the sub CPU.

`tools/segacd_port.py` does the transcription. It walks the cartridge build listing (`output/obj/nhl94 .lst` from `npm run build:retail`; the Sega CD build empties `output/obj/`, so keep a copy) and the disc bytes side by side. A disc instruction that is the cartridge instruction with relocated operands is written as the cartridge source line, with the disc encoding and the cartridge's labels, symbols and comments. Byte-equal data is copied (String macros and all). Disc code with no cartridge twin is written under `;CD:`. A name the fragment uses but does not define is solved from the disc operand: RAM names and struct offsets go to `src/segacd/hockey/hockey.inc` (shared by the HOCKEY.BIN fragments), routines outside the fragment become equates at its top. The tool assembles the result and checks it against the disc; an instruction SNASM would encode differently becomes `dc.w` with a comment (none so far). `--register` adds the fragment to `tools/segacd.json`, `tools/verifySegacd.js` and `docs/segacd-handoff/name_map.csv`. `tools/segacd_hockey.sh` runs it for every HOCKEY.BIN segment in disc order with its range, the names checked by hand (`--name seed=0x18C18`) and the header note, so the fragments and `hockey.inc` can be written again from scratch.

Names across fragments come from `docs/segacd-handoff/name_map.csv` (every fragment's labels, rewritten by `--register`):

- A CD-only line that calls or loads an address another fragment names uses that name, with an equate at the top (`jsr (LoadGameGfx).l` in cards94).
- A cartridge line is never solved to a routine's name when another fragment has that routine elsewhere. The CD changed the call there, so the line keeps the number with `;CD: the cartridge has setSlotBit`. For example, the CD moved the game loop's calls into the tail of `DoGameFrame`.
- A label is placed by branch evidence only in its own 94G file, so a shared `rts` such as `rtss2` (collide94) is not defined again in logic94.
- `--entry StartGame=0x2B7F8` moves a cartridge label to where its callers enter, when the CD put lines in front of the routine's first matching line. Each one is checked by hand and listed with its reason in the driver.

Run the driver twice after a name changes, so the fragments written before the change see it.

```
python tools/segacd_port.py --file onetimer94.asm --disc-start 0x76A8 --disc-end 0x7DDC --out src/segacd/hockey/onetimer94.asm --register
```

The team data (`teamdata94.asm`) is ported with `--no-text`: a quoted line that is not word for word in the public `src/teamdata94.asm` (a player row, a nickname) is `incbin` from the disc, with the line as its comment (text masked, ratings and the `P` id kept), and every block with no cartridge twin is `incbin` too, so a name only the disc has can never be written. The record structure, palettes, line sets and ratings are source.

What the cartridge build takes from the ROM (the licensed New York team nicknames in `optsetup94`, the asset files it `incbin`s from `Extracted/`, such as the matchup palettes in `cards94`) is `incbin ..\cdbin\HOCKEY.BIN,offset,length` here, read from your own disc file. The Sega CD build never reads `Extracted/`, and `segacd_port.py` stops if a written fragment would contain a player name or team nickname.

What the CD changed so far: graphics are no longer ROM labels (each `movea.l #map` became a load from a pointer table at `$47D00`, inside HOCKEY.BIN but zeros on the disc, filled at run time), the beam-counter seed is command `$1B` to the main CPU, the corner-collision radius test in `checkcornercoll` compares with `$42` instead of `$1000`, and the team struct is one word longer from `tmap` on (`docs/segacd_memory_map.md`). `title94` (title screen and credits) is not on the disc. `cards94` lost the whole player card screen and its save RAM readers moved next to `sram94`. `fourway94` is the first file the CD cut: `Detect4WayPlay` and the `ReadJoySwapPad` routines are gone, and one `rts` that nothing calls is left in their place.

## GRAPH2.BIN and GTABLE.BIN

GRAPH2.BIN is an archive of 99 resources and GTABLE.BIN is its index. A GTABLE entry is 6 bytes: the start sector (word, 2048-byte sectors from the start of GRAPH2.BIN) and the byte size (long). The 99 entries are followed by a zero entry and zero fill. Each resource starts on the sector after the one before it ends, ends with the mark `$12345678`, and is zero filled to the next sector; the last ends on sector `$5D2`, the end of the file. HOCKEY.BIN asks for resource n with `$6044`, `d7 = 1`, `d0 = n`, and gets its address back in `a0`. That is OSLoadResource in the disc's system program (`docs/segacd_boot.md`): SegaOSMain reads GTABLE.BIN (LBA 2728) at start-up, and OSLoadResource reads entry n's sectors from LBA 286 (GRAPH2.BIN) + the start sector.

Resources 0 and 1 are packs: a table of long offsets from the pack start, then the pieces. `scoutload.asm` loads resource 0 (the start-up pack, 23 pieces) and LoadGameGfx (`hockey94.asm`) loads resource 1 (the game graphics pack, 25 pieces). Each adds the pack address to every offset and stores the pointer in HOCKEY.BIN's graphics pointer table (`cdgfxptrs.asm`). Most pieces are the cartridge graphics files byte for byte (`SmallFont.map.jim`, `IceRink94.map.jim`, `Crowd.anim` ...), and the entry each lands in is the one whose code sites replaced that graphic's label. That is how the table entries are named (`SmallFontMapPtr`), and the bytes confirm every name that came from the code sites. The other resources and who loads them: 2 the sprite pack (`Spritetiles.bin`, `frameSprData.bin`; HOCKEY.BIN), 4 the team logos (period94), 5 the legal screen and the Loading... screen, 97 the arena scoreboard frame around the film window (STARTER.BIN), 6-33 each team's player photos (PLAYER.BIN loads 6 + team for the home and away teams), 34 each team's player stats and career records (PLAYER.BIN's pages), 35-62 each team's TeamGfxList graphics (HOCKEY.BIN `$2A9FA` lists each team's number; LoadGameGfx loads the home team's into HomeTeamGfxPtr), 64 a font (STARTER.BIN and PLAYER.BIN), 68-95 each team's three PLAYER page backgrounds (68 + team), 96 the game's 13 PCM wave samples (LoadGameGfx passes it to `$6044` with `d7 = 8`, OSInitMainSound; the sound effects that play them are in `docs/segacd_main_shell.md`). No load was found for 3 (the player cards), 63, 65 (the Stanley Cup sprite), 66 and 67 (the hot and cold icons) or 98; resource 0 holds copies of 3, 65, 66, 67 and 98, and those copies are what the code uses.

Resources 5, 64, 97 and the pieces of 68-95 are `$0808` pictures: the word `$0808`, the tile count, the tiles, a 64-colour palette, then the map (width, height, words).

`tools/segacd_graph2.py` writes `src/segacd/data/graph2.asm` and `gtable.asm` from the disc files (it checks the structure as it goes). The offset tables, end marks and zero fill are source, and the graphics are `incbin` from `cdbin/GRAPH2.BIN`. A piece is named `R0_` or `R1_` plus the cartridge label of the graphic it holds. In `gtable.asm` the macro `GRes size` writes one entry and works out the start sector from the sizes.
