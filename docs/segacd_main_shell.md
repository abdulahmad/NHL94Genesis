# MAIN.BIN: the main CPU shell and the sound engine

MAIN.BIN runs at file + `$FF1000` on the main CPU, the whole file. Its first instruction is `jmp $FF45A8`, MainShellEntry (file `$35A8`); the command loop reads its handler table at `$FF471C` (file `$371C`, `maintable.asm`; file `$471C` is zeros); 61 of that table's 64 pointers land on routine starts at this base and 1 at `$FF0000`; the code stores the literal `$FF1006` for the pc-relative address of file `$6`; and the file's `$EC00` bytes end exactly at `$FFFC00`, the stack top MainShellEntry sets. The older fragments in `src/segacd/` (`maincd.asm`, `maindisp.asm`, `hwread.asm`, `z80load.asm` ...) were written at `$FF0000` and are at `$FF1000` now, with the same bytes. The routine names here are given here (none comes from the disc); `tools/segacd_main.sh` holds them with a one-line reason each.

MAIN.BIN holds two command interfaces and a sound sequence engine:

- the older interface: `CmdJumpTable`, a table of displacements at `$FF11BE` (file `$1BE`, `maincd.asm`), with handlers in the older fragments (`maindma`, `maincont`, `mainblit`, `mainvdp`). STARTER.BIN's driver sends these commands during the start-up (`docs/segacd_starter_driver.md`).
- the game shell: MainShellEntry, its command table and handlers. HOCKEY.BIN and PLAYER.BIN send these.
- the sound engine (`mainmod.asm`) behind DispatchSoundOperation, and the Z80 program (`mainz80.z80`).

## Communication

On the main CPU `$A12010` is the sub CPU's `$FF8010` and `$A12020` its `$FF8020`; the main CPU writes its flag byte at `$A1200E` and reads the sub CPU's at `$A1200F`. The foreground channel takes a command from `$A12020` (parameters at `$A12022`, flag bits 6/7). The V interrupt channel takes one from `$A12026` (parameters at `$A12028`, flag bits 3/4; pad reads reply in `$A12018`).

## Start-up and dispatch

MainShellEntry (`$FF45A8`) sets the stack at `$FFFC00`, clears `$A12010`-`$A1201E` and `$A1200E`, does the start-up handshake (SyncMainShellStartup), waits for the memory mode, gives word RAM to the sub CPU and enters MainShellCommandLoop (`$FF4622`): wait for sub flag bit 6 with bit 7 clear, read the command, call `ShellCommandTable[command - 1]`, acknowledge with bit 6. MainShellVBlank (`$FF485E`) serves the second channel through the same table until command `$2F` (EndVBlankCommandService) clears `$FF6CFA`.

## The game shell's commands

`maintable.asm` lists them; the senders are examples found in the fragments.

| Cmd | Handler | What it does | Sender |
| --- | --- | --- | --- |
| `$01` | ClearVramByWord | clear VRAM | |
| `$02` / `$03` | CopyWordRamToVram / CopyWordRamToCram | count and address from the sub CPU, words from `$200000` | |
| `$04` | TestZ80BusBitCommand | a bit of `$A11100`, reply 0 or 4 | |
| `$05` / `$06` | ClearByteAtAddressCommand / ClearWordAtAddressCommand | | |
| `$07` | GiveSubWordRamCommand | | sram94 |
| `$08`, `$32` | RunWordRamVdpDmaCommand | a VDP DMA record from word RAM | middle94_2, startertail |
| `$09`-`$0E` | WriteVdpControl/DataByte/Word/LongCommand (hwread.asm) | the parameter to the VDP | setup94, middle94, print94 |
| `$0F`-`$14` | pad port writes and reads (hwread.asm) | | |
| `$15` / `$16` | ReadVdpDataWord/LongCommand (hwread.asm) | | cards94 |
| `$17`-`$19` | ReadByte/Word/LongAtAddressCommand (hwread.asm) | | sram94 |
| `$1A` | WriteZ80BusReqCommand (hwread.asm) | | |
| `$1B` / `$1C` | ReadHvCounterCommand / ReadHvCounterByteCommand (hwread.asm) | the HV counter | collide94, logic94 (the random seed) |
| `$1D` | StepCramFadeCommand | 64 colours one step toward the target palette | middle94 (cramfade), PLAYER |
| `$1E`, `$3A` | CopyVramByDmaCommand | VRAM to VRAM DMA | middle94_2, PLAYER |
| `$1F`, `$3B` | FillVramFromWordRamCommand | | middle94_2, PLAYER |
| `$20` | ClearAllVramCommand | 64 KB of zeros | middle94_2, startertail |
| `$21` | WriteVdpWordsFromWordRamCommand | | middle94_2 |
| `$22` | WriteZ80ResetCommand | | |
| `$23` | SoundOperation4Command | sound operation 4 (PlayZ80Channel16Note) with d1 = the word in `$A12022` (0-6) and d2 = its note from the table at `$FF4E76` (0, `$6B`, `$6A`, `$75`, `$7C`, `$73`, `$74`), gated by `$FF6CF8` | |
| `$24` | TickSoundSequenceCommand | sound operation 1 | |
| `$25` | EnterMainShellCProgram | the shell C program, then the shell again | OSPlayFilm (boot/sp) |
| `$26` | StartSoundSequenceCommand | sound operation 2 with the id in `$A12022` | sfxcd.asm |
| `$27` | InstallSoundSequenceHInt | | cards94 |
| `$28` | RestartMainShellCommandLoop | | OSReturnFromPlayer (boot/sp) |
| `$29` | InitSoundCommand | the Z80 driver, the sound resources, the H interrupt | OSInitMainSound (boot/sp): the sub CPU PCM driver's address |
| `$2A` | DisableShellHInt | | OSStopMainSoundHInt (boot/sp) |
| `$2B` | DetectFourWayPlayCommand | the four-way adapter probe | sram94 |
| `$2C` | RunWordRamVdpDmaListCommand | the DMA records at `$23C000` | PLAYER |
| `$2D` / `$2E` | InstallMainShellVBlank / InstallAcknowledgeVBlank | which V interrupt handler | sram94, scout94_2, startertail |
| `$2F` | EndVBlankCommandService | | sram94, PLAYER |
| `$30` / `$31` / `$33` / `$39` | WriteVBlankVdpControlLong / DataWord / DataLong / ControlWord | the VDP from the second channel | middle94, video94, PLAYER |
| `$34` | StartVBlankSoundSequence | sound operation 2 from the second channel | gate34.asm |
| `$35`-`$38` | WriteVBlankPad2Port / WriteVBlankPad1Port / ReadVBlankPad1Port / ReadVBlankPad2Port | pad transactions | cdpads |
| `$3C` | SaveCramPaletteCommand | 64 CRAM words to `$FF6D04` | scout94_2 |
| `$3D` | ShowWordRamScreenCommand | fade out, clear, upload a screen, fade in | middle94_2, PLAYER |
| `$3E` | RunSubCommandAndRestartShell | the older interface, then the shell again | startertail |
| `$3F` | InstallMainShellOverlayCommand | shows a word RAM screen, copies `$C5B` longs to `$FF1006` | startertail |
| `$40` | InitSoundDriverCommand | `$29` without the resource calls | OSInitMainSoundDriver (boot/sp) |

## The older interface

`RunSubCommand` (`maincd.asm`, `$FF1006`) serves these until command `$1E`; the game shell runs it for command `$3E`. `DispatchSubCommand` adds the long from `CmdJumpTable` (`$FF11BE`) to the table address. STARTER.BIN's driver sends these during the start-up (`docs/segacd_starter_driver.md`). The parameters are in word RAM at `$23A450` (the sub CPU's `$BA450`), and what a command gives back is written there too. A pointer from the sub CPU is a word RAM address on its side (`$80000` on), so the handlers add `$180000` to reach the same bytes at `$200000`. The drawing handlers have CD-only names; the rest are labelled `SubCmdNN` with the command's job as the comment.

| Cmd | Handler | What it does |
| --- | --- | --- |
| `$00` / `$01` | SubCmd00 / SubCmd01 (`maindma`) | DMA to VRAM from `$23A450` parameters; `$01` keeps word RAM flag bit 4 |
| `$02` | SetUpDisplayCommand (`maincont`) | the VRAM layout (H scroll, sprites, planes A and B, window), the plane size, H32 or H40, one colour for the whole palette |
| `$03` | SubCmd03 (`maindma`) | clear VRAM |
| `$04` | LoadTilesCommand (`maincd`) | tiles (a count word, bit 15 set when packed) into VRAM at character d4; d4 back, moved past them |
| `$05` | SetFontMapCommand (`maincd`) | the font of the text commands into FontMapPtr (`$FF2884`) |
| `$06` | ResetTileRemapCommand (`maincont`) | clear TileRemap (below) |
| `$07` | FillCellsCommand (`maincont`) | fill a rectangle of cells with one cell word |
| `$08` | DrawPictureCommand (`maincont`) | a picture: palette lines, a rectangle of its map, its tiles |
| `$09` | LoadRemappedTilesCommand (`maincont`) | load only the tiles TileRemap marks |
| `$0A` | DrawRemappedMapCommand (`maincont`) | a rectangle of a map, its tiles renumbered through TileRemap |
| `$0B` | DrawTextCommand (`maincont`) | a string through the font |
| `$0C` / `$0D` | DrawCodedTextCommand / DrawCodedTextCommand2 (`mainblit`) | a string with text codes (two copies of one handler) |
| `$0E` | SetDrawingParametersCommand (`mainblit`) | `$24` bytes to `$FF2860`-`$FF2883`, the font bases at `$FF287A` among them |
| `$0F` | ReadHvCounterToWordRamCommand (`mainblit`) | the HV counter into `$23A450` |
| `$10` | LoadRecolouredTilesCommand (`mainblit`) | as `$04`, each pixel through an eight-byte colour map |
| `$11` | DrawFrameRowCommand (`mainblit`) | one row of a frame: an end cell, a middle cell repeated, the other end |
| `$12` | CopyCellRectanglesCommand (`mainblit`) | copy a rectangle of cells from one place in the planes to another (VRAM copy DMA, row by row) |
| `$13` | SubCmd13 (`mainvdp`) | a word to VDP control |
| `$14`, `$15` | SubCmd14 / SubCmd15 (`mainvdp`) | clear the tables and VSRAM |
| `$17` | ClearHScrollAndSpritesCommand (`maincont`) | clear the H scroll table and the first sprite |
| `$18` | FillVramCommand (`maincont`) | FillVram: d0 bytes of the word d2 at VRAM d1 |
| `$16`, `$19`, `$1D` | SubCmd16 / 19 / 1D (`mainvdp`) | VSRAM (vertical scroll; `$1D` is the credits scroll) |
| `$1A` / `$1B` | SubCmd1A / SubCmd1B (`mainvdp`) | VDP set-up for the film; the film (the C code at `$FF2E00`) |
| `$1C` | SubCmd1C (`mainvdp`) | VDP registers `$9100`, `$9213`, `$8B03` |
| `$1E` | SetCmdPending (`maincd`) | the end: `RunSubCommand` returns |

### Drawing

The commands draw into the planes at a cursor that the sub CPU sends with each command and gets back after it (STARTER.BIN keeps it at `$10B0A`-`$10B10`):

| Variable | Use |
| --- | --- |
| `$FF2DB2` / `$FF2DB4` | x and y, in cells |
| `$FF2DB6` | the attribute: bits 11-15 of each cell word (flips, palette, priority) |
| `$FF2DB8` | the plane: 0 A, 4 B, 8 the window (an offset into the pairs at `$FF2852`) |
| `$FF2DBA` | DrawCodedText's font: twice the index of a base at `$FF287A`; 4 picks DrawBigCharacter |

SetUpDisplayCommand sets the pairs at `$FF2852` (plane A's address and width as log2 cells, plane B's, the window's: 32 or 64 cells for H32 or H40), the plane height at `$FF285E` and the H scroll and sprite table addresses at `$FF284E` / `$FF2850`. SetVramWriteToCursor turns the cursor into a VRAM write address; FillCellRectangle and the map drawers go row by row from it, and y comes back moved down.

- **Pictures.** DrawPictureCommand takes a palette (a0), a map (a1: width, height, cell words) and tiles (a2), the three parts of a `.map.jim`; STARTER.BIN draws its screens with it (ShowHighScoreScreen). The palette lines whose bits are set in d5 go to the palette buffer at `$23A850`; d3 rows of d2 cells from column d0, row d1 of the map are drawn, each + d4 and with the attribute; then the tiles go to VRAM at character d4, and d4 comes back moved past them.
- **Only the tiles in use.** ResetTileRemapCommand clears TileRemap (`$FF2A1A`, one byte per tile of a big tile set) and sets the next index (`$FF2A18`) to 1. DrawRemappedMapCommand draws like DrawPictureCommand but gives a tile the next index the first time the map uses it; LoadRemappedTilesCommand then unpacks the set and sends only the marked tiles, each to character d4 + index - 1 (FlushOutputBuffer's skip mode).
- **Text.** The font is a `.map.jim` (SetFontMapCommand): its map gives the cell of each character code, and a font base (`$FF287A`, `$FF287C`, `$FF287E`) is added. DrawText (`$0B`) reads a length word and bytes: a character, `$40` for the cell `$7FF`, 0 for nothing, or -n: the attribute and the plane from n, then x and y bytes. DrawCodedText (`$0C`, `$0D`) reads -n as text code n through TextCodeTable: 1 plane, 2 attribute, 3 x, 4 y, 5 and 6 move x and y, 7 the font, 8 all of them; `^` skips a cell. STARTER.BIN draws the credits lines this way (DrawCreditsLines).
- **Frames and copies.** DrawFrameRowCommand draws a row from three cell words (an end, the middle repeated, the other end) and moves on to the next three, so calls one after another draw a box. CopyCellRectanglesCommand takes a source and a destination (x, y, plane 1-3), a width and a row count, and copies each row with a VRAM copy DMA.

DrawTextInline, DrawCodedTextInline and CopyCellRectanglesInline take the block after the `bsr`; nothing in MAIN.BIN calls them. DrawThreeCellGauge (`$FF1E30`, three cells, d1 of them on) is in no table entry, and no caller was found.

## The sound engine

DispatchSoundOperation (`$FF865C`) takes d0: 0 LoadZ80SoundProgram (`z80load.asm`), 1 TickSoundSequences, 2 StartSoundSequence, 3 StopSoundSequence (by SequenceId), 4 PlayZ80Channel16Note (a DAC sample on the Z80: "The DAC and sound operation 4" below), 5 ClearZ80SoundBuffers, 6 RegisterSoundResourceBank, 7 LoadZ80SoundResources, 8 RemoveZ80SoundResources, 9 ClearZ80SoundResourceDirectory; any other returns 1 with carry set.

TickSoundSequences (`$FF87B8`) needs the word `$1234` as its guard. It serves the timed note-offs and the Z80's data requests, then runs eight streams: MIDI-style status bytes (`$90`, `$B0`, `$C0`, `$E0`, `$FF` the end) with variable-length delays. A `$90` event also queues a timed `$80` (QueueTimedNoteOff, TickPendingNoteOffs). Events go to the Z80 queue at Z80 `$0030` (QueueZ80SoundEvent, 24 at most) or to a deferred queue of 32 (QueueDeferredSoundEvent, FlushDeferredSoundEvents). ServiceZ80DataRequest answers the request byte at Z80 `$0072` with `$200`-byte chunks. FindSoundResource looks up a type and id in the registered directories (a count, then 4-byte entries, as the sub CPU's PCM records). The bus helpers take the Z80 bus or map a sub CPU program RAM pointer into the main CPU window `$020000`-`$03FFFF`.

InitSoundCommand registers SoundBank (`$FF963C`, in MAIN.BIN) as directory 0: 48 sequences (type 3, id = the sound number) and 31 FM instruments (type 0, kind byte 0), and loads the instruments into the Z80 (Z80SoundResourceList; LoadZ80SoundResources sends a type 0 record only when its kind byte is below 6). HOCKEY.BIN's `sfx` (`sfxcd.asm`) sends the cartridge's sound number with command `$26`, so a sequence id is the cartridge's SFX number (`ram94.asm`).

A sequence starts with a little-endian word n and n words, then events: a variable-length delay (one byte, or two when the first has bit 7 set), a status byte (or the running status), its data. `$9x` note on: note, velocity, a variable-length length (divided by SequenceTempo; QueueTimedNoteOff sends the `$8x` when it runs out); `$Bx`: controller, value; `$Cx`: program; `$Ex`: one byte; `$FF` the end. TickSoundSequences builds each event as a long: the stream number * 16 in the top byte, then the second data byte, the first data byte and the status byte. That top byte is the port: the sub CPU driver's slot is it + the MIDI channel.

Controller 18 (`$12`) is not sent on: its value picks where the channel's events go from then on (PcmChannelRouting, a bit per channel for each stream): 0 the Z80 (FM), anything else the sub CPU's PCM driver (DeferredSoundEvents, copied into its queue at PcmQueuePointer by FlushDeferredSoundEvents). Every PCM sequence sends controller 18 = 1 on its channel, then a program change and a note (`$08` plays an FM note first, with controller 18 = 0):

| Sequence | Cartridge name | PCM sound (sample) | Note |
| --- | --- | --- | --- |
| `$03` | SFXwhistle | `$6F` (11) | 60 |
| `$07` | SFXpuckget | `$60` (7) | 74 |
| `$08` / `$0D` | SFXoooh / SFXoooh2 | `$6C` (10) | 70 |
| `$09` / `$0A` | SFXhithigh / SFXhitlow | `$67` (5) | 60 / 65 |
| `$0B` | SFXcrowdcheer | `$6D` (8) | 67 |
| `$0C` | SFXcrowdboo | `$6B` (12) | 58 |
| `$0E` | SFXbglass | `$6E` (9), then `$6C` (10) | 91, 72 |
| `$0F` | SFXhomewin | `$6D` (8) | six notes 66-69, softer each time |
| `$10`-`$13` | SFXpass + 0-3 | `$61` (2) | 70, 69, 68, 68 |
| `$14`-`$17` | SFXshotbh + 0-3 | `$62` (1) | 74, 73, 72, 72 |
| `$18`-`$1B` | SFXshotfh + 0-3 | `$63` (6) | 74, 73, 72, 72 |
| `$1C`-`$1F` | SFXcheck + 0-3 | `$67` (5) and `$65` (0) or `$64` (4) | two notes |
| `$20`-`$23` | SFXplayerwall 1-4 | `$66` (3) | 67, 67, 66, 66 |

The sounds are the sub CPU records HOCKEY.BIN installs (GamePcmSounds, `docs/segacd_boot.md`), the samples GRAPH2 resource 96's. Sequences `$07` and `$20`-`$23` also send channel 1 to the PCM driver with program 23 or 24, for which there is no record, so those notes play nothing. The other sequences are FM only: `$00` the siren, `$01` / `$02` the beeps, `$04` the horn, `$05` the shot that misses, `$06` (SFXstdef), `$24` the puck on a body, `$25` the post, `$28`-`$2B` the boards, `$2C`-`$2F` the ice; `$26` and `$27` are empty (only the end).

The Z80 side is `src/segacd/main/mainz80.z80`: Z80SoundImage, MAIN.BIN `$5E0C`-`$765B`. InitSoundCommand (`$29`) and InitSoundDriverCommand (`$40`) pass its `$1850` bytes to z80load.asm, which copies them to Z80 RAM `$0000`. That puts `jp $0600` at the reset vector, `jp` to a `reti` at the restart vectors, the program at `$0600`, and zeroed RAM below and after it (the command queue at `$0030`).

The Z80 program takes the events from the queue by status nibble, with the slot = the channel + the top byte, as the sub CPU's PCM driver does: `$8x` NoteOff, `$9x` NoteOn, `$Bx` ControlChange (controller 1 into SlotModulation, 7 into SlotVolume), `$Cx` ProgramChange (SlotSound), `$Ex` PitchBend (SlotPitchBend); any other status is dropped and every FM channel keyed off. NoteOn finds the slot's sound in its resource table at Z80 `$0100` (FindZ80Resource: 64 entries of id, size and address, filled by UploadZ80SoundResource) and goes by the record's kind byte: 0 an FM instrument on a free FM channel, 3 a DAC sample on FM channel 6, 7 a key map (byte 2 + the note is the sound).

### The DAC and sound operation 4

At start-up the Z80 puts one record in its table itself (InitResourceTable): id `$7F`, the 4 bytes at `$184B`, kind 3 (a DAC sample), priority 0, pan `$C0` (both speakers), and a sample id in byte 3. Sound operation 4 (PlayZ80Channel16Note) writes d1 into that byte 3 (Z80 `$0028` holds the record's address), then sends program `$7F` and a note d2 (velocity `$7F`) on MIDI channel 16 straight to the Z80 queue. StartDacSample then switches FM channel 6 to DAC mode, sets DacSampleId (`$0093`) and DacRequest (`$0092`) to 1, takes the sample rate from the note (YM timer A, TimerAValues), and starts the stream at DacStartMark, a `$FE` byte that waits for data.

The data was meant to come from the 68000. ServiceZ80DataRequest (in TickSoundSequences) answers a request by finding the DAC sample (type 1) with the requested id. A type 1 record is a loop word and then 8-bit samples, ended by a 0. ServiceZ80DataRequest copies `$200` bytes at a time into DacBufferA / DacBufferB (Z80 `$1448` / `$1649`, whose addresses the Z80 keeps at `$0024` / `$0026`), each ended by `$FF`. The Z80 plays one buffer while it asks for the other to be refilled (DacRequest 2 or 3).

In this build it never sounds, for three reasons:
- ServiceZ80DataRequest polls Z80 `$0072` / `$0073`, but this Z80 program keeps its request at `$0092` / `$0093`, so no request is answered and the stream waits at its `$FE` mark. In this program `$0072` is inside the 24-entry command queue, and ServiceZ80DataRequest writes 0 there on every tick, which would wipe the status byte of a 17th queued event.
- No bank with DAC samples (type 1) is registered: SoundBank has only sequences and FM instruments.
- Nothing sends shell command `$23`, the only way into sound operation 4. Its table at `$FF4E76` gives d1 = 0-6 the notes 0, `$6B`, `$6A`, `$75`, `$7C`, `$73` and `$74`.


## Not worked out

Which screen command `$3D` shows and what the overlay installed by `$3F` is; whether the game shell commands with no sender seen are used.
