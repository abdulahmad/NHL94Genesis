# The boot area and the system program

The first 16 sectors of the data track are the boot area. It is not a file on the disc, so the six files in `cdbin/` do not have it: `tools/segacd_bootarea.py` copies it from your own disc image (a `.cue` with its `.bin`, or an `.iso`) into `cdbin/BOOT.BIN`, and the `src/segacd/boot/` fragments are compared with it. `npm run build:segacd` skips those four fragments when `cdbin/BOOT.BIN` is missing.

```
python tools/segacd_bootarea.py "path/to/NHL '94.cue"           (cdbin/BOOT.BIN)
python tools/segacd_bootarea.py "path/to/NHL '94.cue" --files   (and the six files, from the disc's file system)
```

| BOOT.BIN | Runtime | Fragment | What |
| --- | --- | --- | --- |
| `$0`-`$1FF` | | `boot/header.asm` | the disc header: volume `NHLHOCKEY94`, system `CDSYS.BIN`, where the two programs are, the system header (`SEGA GENESIS`, `NHL HOCKEY 94`, `GM T-50015 -00`, region U) |
| `$200`-`$783` | main `$FF0000` | `boot/security.asm` | Sega's US security block (the licence screen): read from the disc |
| `$784`-`$FFF` | main `$FF0584` | `boot/ip.asm` | the initial program |
| `$1000`-`$7FFF` | sub `$6000` | `boot/sp.asm` | the system program, module `MAIN SEGAOS` (code to `$A4DD`, then zeros) |

`tools/segacd_boot.sh` writes `ip.asm` and `sp.asm` with `segacd_port.py` and holds the names (CD-only, given here) with a reason each.

## Start-up

The BIOS loads the initial program at main CPU `$FF0000` and the system program at sub CPU `$6000`.

- **SegaOSMain** (`$622A`, sub CPU): drive init (BIOS `$10`, `$96`), then MAIN.BIN (30 sectors from LBA 30) into word RAM at `$80000`, GTABLE.BIN (LBA 2728) into GTableBuffer (`$9B58`), and STARTER.BIN (120 sectors from LBA 226) to `$B000`; then `jmp $B000`.
- **IPMain** (`$FF0584`, main CPU): interrupt level and the V / H interrupt vectors, the start-up handshake, word RAM taken, then `$EC02` bytes copied from word RAM `$200000` to `$FF1000` and `jmp $FF1000`. That is MAIN.BIN, which is why it runs at `$FF1000` (`docs/segacd_main_shell.md`). Its helpers are the same code as MAIN.BIN's and have the same names.
- STARTER.BIN runs the start-up sequence and its tail jumps back to `$B00E` in its own boot code, which reads HOCKEY.BIN (`$92` sectors from LBA `$4F`) to `$1B000` with service 0 and jumps to it (`docs/segacd.md`).

Every file is read by a sector number written in the code, never by name (the file names `HOCKEY.BIN`, `RAM.BIN`, `MAIN.BIN`, `PLAYR.BIN`, `START.BIN` after `$6346` are not used):

| File | LBA | Read by |
| --- | --- | --- |
| MAIN.BIN | 30 (`$1E`) | SegaOSMain |
| HOCKEY.BIN | 79 (`$4F`) | STARTER.BIN's boot code, OSReturnFromPlayer |
| STARTER.BIN | 226 (`$E2`) | SegaOSMain |
| GRAPH2.BIN | 286 (`$11E`) | OSLoadResource: LBA 286 + the resource's sector |
| GTABLE.BIN | 2728 (`$AA8`) | SegaOSMain |
| PLAYER.BIN | 2729 (`$AA9`) | OSRunPlayer |
| HOCKEY.SEG | 2778 (`$ADA`) | the intro film: STARTER.BIN passes it to StarterDriverEntry |

The disc also holds the films (`GOAL*.SEG`, `HIT*.SEG`, `STNLY*.SEG`, `THNDR*.SEG`: OSPlayFilm with the sector in d1) and the speech (`RON*.PCM`, the team names `ANAHEIM.PCM` ...). Those are media, not code, and are not part of this build.

## The services at `$6044`

HOCKEY.BIN, STARTER.BIN and PLAYER.BIN call `jsr $6044.w` with the service number in d7. **SegaOSCall** turns d7 into `d7 * 4 + 2`, writes it over the displacement of the `bra.w` that follows (at `$6050`), and so lands on entry d7 of **SegaOSCallTable**:

| d7 | Service | What it does |
| --- | --- | --- |
| 0 | OSReadSectors | ReadSectors(d2 LBA, d1 sectors, d0 address) |
| 1 | OSLoadResource | GRAPH2 resource d0: its GTABLE entry (start sector, size), read from LBA 286 + sector to LoadPointer, which moves past it; the `$12345678` end mark is checked and the read tried up to 3 times. Main CPU commands `$2E` before and `$2D` after (the V interrupt handlers, `docs/segacd_main_shell.md`). Returns the address in a0 |
| 2 | OSSetLoadPointer | a0 into LoadPointer (`$A360`) |
| 3 | OSStartTimer | StartTimerInterrupt: TimerInterrupt on level 3, interval `$84` ("The timer" below) |
| 4 | OSReturnFromPlayer | HOCKEY.BIN read again to `$1B000`, then back to the caller of OSRunPlayer (its stack was kept); with no caller kept, main command `$28` and `jmp $1B000` |
| 5 | OSRunPlayer | service 9, the caller's stack and return kept (PlayerCallerSp, PlayerReturn), PLAYER.BIN (22 sectors from LBA 2729) to `$1B000`, over HOCKEY.BIN, LoadPointer `$26000`, `jmp $1B000` with d0-d2 (the teams and FourWayPlay) |
| 6 | OSGetLoadPointer | LoadPointer into a0 |
| 7 | OSPlayFilm | main command `$25` (the shell's C program shows the film), FilmSwitch 0 (open the film at sector d1, with the display layout d0 picks, a0 the callback: "Films" below) then 1 until the film ends or FilmStopFlag is set, then 2 |
| 8 | OSInitMainSound | main command `$29` with PcmDriverEntry in `$FF8022`; then PCM driver commands 0 (init), 5 with a1 (a record directory), 6 with a2 (load a record list), 5 with a3; StartTimerInterrupt; PcmServiceEnabled set. LoadGameGfx passes GRAPH2 resource 96 (the game's 13 wave samples), HOCKEY.BIN `$223D6` (the list) and `$222EA` (13 sound definitions) |
| 9 | OSStopMainSoundHInt | main command `$2A`; PcmServiceEnabled cleared, so the timer stops running the driver |
| `$A` | OSStopFilm | FilmStopFlag set |
| `$B` / `$C` | OSSetKeptWord / OSGetKeptWord | d0 into / out of KeptWord (`$A36C`), kept across HOCKEY.BIN reloads (sram94 reads it at the cold start) |
| `$D` | OSStopTimer | the saved level 3 vector put back |
| `$E` | OSGetPcmDriver | PcmDriverEntry into a0 |
| `$F` | OSInitMainSoundDriver | main command `$40` with PcmDriverEntry in `$FF8022`; PCM command 0, StartTimerInterrupt, PcmServiceEnabled set |
| `$10` | OSCallPcmDriver | PcmDriverEntry with d0 |

The callers already in the source match: STARTER's boot code (service 0), LoadGameGfx and period94 (1), startertail (2, `$A`, `$B`), scoutload (3, `$D`), PLAYER's exit (4), RunPlayerOverlay in cards94 (9 then 5), PLAYER's team films (7), LoadGameGfx (8 with `$60`, `$D`), sram94 (`$C`, 3).

## Films

FilmSwitch (`$68D2`) is the SDK's film switch, as `filmrun.asm` in STARTER.BIN (`docs/segacd_film.md`): a word on the stack, 0 open, 1 the next frame (FilmTask), anything else close. Its state follows it (FilmFrameTicks to FilmState). Open takes nine longs after the word:

| Argument | Use | OSPlayFilm, d0 = 0 | OSPlayFilm, d0 not 0 | STARTER (the intro) |
| --- | --- | --- | --- | --- |
| 1 | the film's start sector (FilmOpen) | d1 | d1 | `$ADA`, HOCKEY.SEG |
| 2 / 3 | the read buffer and its size | LoadPointer, up to `$80000` | the same | `$29000`, up to `$80000` |
| 4 / 5 | the window's row and column in the plane | 0, 0 | 0, 0 | 0, 0 |
| 6 | the plane's name table | `$E000` | 0 | `$E000` |
| 7 | VRAM address of the frame tiles | 0 | `$7000` | 0 |
| 8 | not 0: the priority bit on the window's cells | 1 | 0 | 0 |
| 9 | a routine FilmHook calls (0: none) | a0 | a0 | `$EAE2` |

Arguments 4 to 8 go to FilmDisplayArgs, and FilmOpen hands them to the main CPU in word RAM (`$C0000`): the tile address, the name table + column * 2 + row * `$80` (the window's first cell in a 64-cell plane), and the priority flag. MAIN.BIN's DoMoviePlayBack reads the three longs and passes them to its frame routine (`$FF3BA0`, `maindisp.asm`): it sends the frame's tiles to that VRAM address by DMA, two banks in turn, and builds the cell words (tile number, the palette from the chunk, the priority bit) that the V interrupt writes row by row from the window's first cell, with the chunk's palette.

Open also hooks two BIOS jumps: FilmHook on `$5F34` (FilmFrameTicks + 1, then the callback) and FilmReadInterrupt on `$5F8E` (the sectors of a read as they arrive, through BIOS `$8B`-`$8D`: the first sector's header must match FilmReadSector, and a BIOS error sets FilmReadError). Close puts both back.

PLAYER.BIN is the only caller of OSPlayFilm, with d0 = 1 and an `rts` as the callback: each team's film list (`docs/segacd_player.md`) holds the sectors of its `GOAL`, `HIT`, `THNDR` and `STNLY` films. 145 of the disc's 199 films (besides the intro) are in those lists, and nothing calls OSPlayFilm with d0 = 0. The other 54 are on the disc but nothing refers to them: no other table of film sectors exists in any file (as longs: the LBA, the LBA - 150 or the BCD minute / second / frame), all 52 calls of `$6044` (28 in HOCKEY.BIN, 11 in STARTER.BIN, 13 in PLAYER.BIN) load a constant service number and only PLAYER's team film call is service 7, and only STARTER's own copy of the film code calls into it (for the intro).

## Sound

PcmDriverEntry (`$8260`) is a `bra.w` to DispatchPcmCommand, then PcmCommandQueue (a count word and the packed command longs, 130 bytes). OSInitMainSound gives its address to the main CPU with command `$29` (InitSoundCommand), which hands it to the Z80 loader; z80load.asm keeps that address + 4, the queue. So the main CPU's sound engine writes its PCM events into the sub CPU driver's queue (FlushDeferredSoundEvents), and the driver plays them.

The driver (`$8260`-`$9ADF`) is STARTER.BIN's (`docs/segacd_starter_driver.md`) with one command added. Every routine named in STARTER's copy has a twin here with the same bytes (found by runs of equal bytes: about half of the 6,272 bytes are such runs, and the rest differs by the addresses and the added code), and has the STARTER name.

| d0 | Handler | What it does |
| --- | --- | --- |
| 0 | InitPcmDriver | allocation, mappings, channels, levels; the queue cleared; silence (`$80`) then `$FF` loop marks at wave RAM 0; no stream |
| 1 | ServicePcmDriver | drain the queue; when `$FF800C` (12 bits) has moved `$20` on since PcmLastTimerTick, update the envelopes and ServicePcmStream. PcmServiceBusy keeps it from running twice at once. TimerInterrupt calls it |
| 2 | ControlPcmSampleAllocation | d1 = 0: the saved position set to `$100`; 1: PcmAllocPosition saved; 2: put back, and the samples above it forgotten |
| 3 | PlayPcmSample | a sample with explicit frequency, envelope and pan |
| 4 | | not supported: d0 = 1, carry set |
| 5 | SetPcmRecordDirectory | a0 into PcmRecordDirectories + d1 * 4 |
| 6 | LoadPcmRecordList | type/id word pairs to `$FFFF`; each type 2 record (a wave sample) uploaded to wave RAM at PcmAllocPosition and noted in PcmSampleAddress |
| 7 | PcmCommandNoOp | `rts` |
| 8 | SetPcmSoundLoopOffset | set or add to the loop offset word of a type 0 record |
| 9 | PlayPcmStream | not in STARTER: a stream (below) |
| `$80` on | DispatchPackedPcmCommand | the packed commands of the queue |

The packed ranges are MIDI's status bytes: `$8x` note off (StopPackedPcmSound), `$9x` note on (PlayPackedPcmSound), `$Bx` and `$Cx` control and program change (both SetPcmSoundMapping), `$Ex` pitch bend (SetPcmPitchControl); `$Ax`, `$Dx` and `$Fx` are refused. The low nibble with the long's top byte picks one of 128 slots, which PcmSoundMapping and PcmPitchControl are indexed by (the byte after the status byte is the value).

### The stream (command 9)

PlayPcmStream plays a sound longer than wave RAM straight from sub CPU memory, through two halves of the wave RAM left free above the loaded samples:

| a0 | What it does |
| --- | --- |
| -1 | stop: the channel's loop address set to 0 (the silence InitPcmDriver put there, where the channel is soon turned off), PcmStreamActive cleared |
| 0 | ask: d0 = 0 while a stream plays, -1 when none does |
| other | start (d0 = 7, carry set, when one plays): a0 is the sound, ended by a `$FF` byte; d1 the frequency, d2 the envelope, d3 the pan |

Starting cuts the free wave RAM into halves A and B (`$400` bytes each when at least `$800` is free), fills both (FillPcmStreamHalf: the next bytes, then a `$FF` loop mark), takes a channel that is off or else the one with the smallest PcmChannelPriority byte, gives it priority 0, and starts it at half A. Each time the channel moves into a half, ServicePcmStream (in command 1, so from the timer) fills the other one and points the loop address at it, so the channel goes round A, B, A ... When the `$FF` end byte has been copied, PcmStreamSource becomes -1 and the loop address 0. Once the channel plays in wave RAM page 0, UpdatePcmEnvelopes turns it off (as it does for any sound that has ended), and ServicePcmStream, finding the channel off, clears PcmStreamActive: the stream has ended by itself.

The scouting report reads its script aloud this way (`docs/segacd_announce.md`): service 0 reads a clip to LoadPointer and service `$10` sends command 9 with d1 = `$400`, d2 = `$FF`, d3 = `$FFFF`.

### The timer

StartTimerInterrupt (service 3, and services 8 and `$F`) puts TimerInterrupt into the BIOS level 3 jump (the long at the address in the vector at `$6C`, + 2, kept in SavedTimerVector), writes `$84` to the gate array timer `$FF8030` and enables level 3 in `$FF8032`. OSStopTimer (`$D`) puts the old jump target back.

TimerInterrupt writes `$84` to the timer again and, while PcmServiceEnabled is set (services 8 and `$F` set it, service 9 clears it), calls the driver with d0 = 1: it is what runs the driver. It also counts TimerCountdown from 15 to 0 and round again, which nothing reads.

### Channels, records and envelopes

A note on (packed `$9x`) is a long: the slot (status nibble with the top byte), the note, the velocity. PlayPackedPcmSound keeps them in PcmEventSlot, PcmEventNote and PcmEventVelocity, takes the sound from PcmSoundMapping[slot] and finds its type 0 record. A record whose first byte is 7 is a key map: byte 2 + note is the sound to use instead (StopPackedPcmSound reads byte 1 + note, one off). The bytes of a type 0 record (a sound) that the driver reads:

| Byte | Use |
| --- | --- |
| 1 | priority (a sound takes a playing channel only when that channel's PcmChannelPriority is not below this byte) |
| 2 | the wave sample id (PcmSampleAddress: the start) |
| 3 | the root note: the note that plays at the recorded rate |
| 4 | fine tune (signed) |
| 5-6 | the loop offset in the sample (`$FFFF`: none; the channel then runs into page 0 and is turned off, and a note off has nothing to stop) |
| 7 / 8 | the pitch bend range up / down (times PcmPitchControl's distance from `$40`) |
| 9 / `$A` | the modulation depth and which PcmModulationLevels byte drives it (`$FF`: none); with PcmSlotModulation at 0 it does nothing here |
| `$B` | the level (UpdatePcmPan: PcmSlotLevel * 2 * it, times PcmGroupLevel and PcmMasterLevel, then PcmSlotPan) |
| `$C` | flags: bit 0, a note of this sound takes a channel already playing it; bit 1 clear, that channel is not restarted |
| `$D` | the envelope (type 4 record id), `$FF` none: the envelope level is then the velocity * 2 |

SelectPcmChannel takes a channel playing the same sound (when bit 0 of byte `$C` says so), then one that is off, then the first whose PcmChannelPriority is not below the record's; with none, the note is not played. The stream's channel gets priority 0, so a sound of priority 0 (all of the game's but the whistle) can take it when every channel is busy. The channel's tables (PcmChannelSlot, PcmChannelSound, PcmChannelNote, PcmChannelVelocity, PcmChannelPriority, PcmChannelEnvelope) are filled, the start and loop addresses written, and StartPcmEnvelope, UpdatePcmPan and UpdatePcmFrequency run.

UpdatePcmFrequency takes the note's distance from the root, adds fine tune, pitch bend and modulation as a fraction of a semitone, and reads PcmPitchTable (`$8EAC`): the frequency step for 0 to 48 semitones above the root, `$0800` (the recorded rate) doubling every 12, between two entries by the fraction.

A type 4 record (an envelope): byte 0 the segment count, byte 1 the segment to loop back to, byte 2 the sustain segment, then from byte 4 a level and a time for each segment (level, time, level, time ...). Segment s goes from its level to the next one's in its time, counted in `$FF800C` ticks / 32 (PcmChannelSegmentTime). While the note is held (its PcmEnvelopeHeld bit), reaching segment byte 2 goes back to segment byte 1 (the sustain loop); a note off clears the bit and moves the channel to segment byte 2 (the release), and the channel is turned off when it reaches the last level. The channel's envelope register gets the level * velocity * 2 / 256.

### What the game plays

OSInitMainSound installs GRAPH2 resource 96 as directory 0, loads its 13 wave samples (type 2, ids 0-12) with the list GamePcmSampleList (HOCKEY.BIN `$223D6`), then puts GamePcmSounds (HOCKEY.BIN `$222EA`) in directory 0 instead: 13 sound records (type 0, kind 6), ids `$60`-`$67` and `$6B`-`$6F`. Each plays one sample once (loop offset `$FFFF`), with no envelope, bend ranges 2 and the level `$FF`; the record's root note is `$54`, `$5A` or `$60`. `$67` (the hits) has the level `$96`, and `$6F` (the whistle) priority 8 where the others have 0.

The byte 0 of a type 0 record is its kind: below 6 an FM instrument (the main CPU's sound engine sends those to the Z80), 6 a PCM sound, 7 a key map.

The main CPU's sound engine (`docs/segacd_main_shell.md`, "The sound engine") sends the driver only what its sequences put on the channels they switch to PCM (controller 18): `$Cx` program changes (the sound: PcmSoundMapping), `$9x` notes with their velocity, and the `$8x` note off it times itself (with no loop, a note off finds nothing to stop). The game's sequences send no pitch bend or other controller to a PCM channel. Each stream is a port, so the slot is the stream number * 16 + the channel. Which sound effects use PCM, and which sample each plays, is in that doc.

## Not worked out

Nothing in the sound path is left; the per-slot modulation (PcmSlotModulation, PcmModulationLevels) and the key maps are in the driver but unused by the game.
