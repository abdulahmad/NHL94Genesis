# STARTER.BIN sub CPU driver

STARTER.BIN runs at file + `$B000` (`docs/segacd.md`). The driver module is file `$1000`-`$3D93`, runtime `$C000`-`$ED93`: a PCM sound driver, the start-up sequence (two animated stages, the film, the credits), pad readers, frame timing and the commands it sends to the main CPU. The source is `src/segacd/starter/subhdr.asm`, `subdrv.asm`, the older `pcmclear.asm` and `cdcwait.asm`, and `subdrv_2.asm`. The names are given here (none comes from the disc); `tools/segacd_starter.sh` holds them with a one-line reason each, and passes them to the other STARTER fragments so their calls into the driver use them.

`pcmclear.asm` and `cdcwait.asm` run at `$EA0C` and `$EA76`; `StarterFilmEntry` (`$ECB4`) branches to `filmrun.asm` at `$ED94`.

## Entry points

| Runtime | Name | Evidence |
| --- | --- | --- |
| `$C4B6` | StarterDriverEntry | `jmp RunStarterDriver`; startertail calls it |
| `$C4BC` | DispatchPcmCommandEntry | `bra.w DispatchPcmCommand`; the C part (crt.asm) and the driver itself call it |
| `$D85A` | RunStarterDriver | saves d0-d4, sets up, installs the frame callback, runs the start-up, restores |
| `$EA8A` | DriverFrameCallback | installed through the vector d2 points at; counts `$10AE0` |
| `$ECB4` | StarterFilmEntry | `bra.w $ED94` (filmrun.asm); called with film operations 0, 1, 2 |

RunStarterDriver keeps its arguments at `$EC90`-`$ECA1`: d0.w (`$EC90`, passed on to the later sound call), d1.l (`$EC92`, a film-open argument; zero skips the film), d2.l (`$EC96`, the vector to replace), d3.l and d4.l (`$EC9A`, `$EC9E`, film-open arguments). startertail calls it with d0 = 4, d1 = `$ADA`, d2 = `$6038`, d3 = `$29000`, d4 = `$80000 - $29000`.

## PCM commands

DispatchPcmCommand (`$C542`) takes d0. Below `$80` it dispatches by d0.w:

| Command | Handler | What it does |
| --- | --- | --- |
| 0 | InitPcmDriver (`$CBDE`) | set up allocation, mappings, channels and levels; clear the queue; set up wave RAM |
| 1 | ServicePcmDriver (`$C5AE`) | drain the queued packed commands; update the envelopes every `$20` gate array timer ticks |
| 2 | ControlPcmSampleAllocation (`$D194`) | d1: reset, save or restore the allocation position `$D362`/`$D364` |
| 3 | PlayPcmSample (`$CCCE`) | play a sample with explicit frequency, envelope and pan |
| 4 | (`$C5A4`) | not supported: d0 = 1, carry set |
| 5 | SetPcmRecordDirectory (`$D204`) | a0 into `$D568 + d1*4` |
| 6 | LoadPcmRecordList (`$D218`) | type/id word pairs to `$FFFF`; uploads each type 2 record (a wave sample) to wave RAM |
| 7 | PcmCommandNoOp (`$D350`) | `rts` |
| 8 | SetPcmSoundLoopOffset (`$D2FA`) | set or add to the loop offset word of a type 0 record |

A d0.b of `$80` or more is a packed command (DispatchPackedPcmCommand, `$C80C`): `$80`-`$8F` StopPackedPcmSound (`$C9AE`, release or disable the matching channel), `$90`-`$9F` PlayPackedPcmSound (`$C856`, find records, pick a channel, start it), `$B0`-`$CF` SetPcmSoundMapping (`$CAB0`, a byte into `$D5D0[index]`), `$E0`-`$EF` SetPcmPitchControl (`$CAD4`, a byte into `$D7D0[index]`, then UpdatePcmFrequency); `$A0`-`$AF`, `$D0`-`$DF` and `$F0`-`$FF` are not supported. DrainPcmCommandQueue (`$C5F8`) takes packed longs from `$C4C2` (count at `$C4C0`); nothing in the module was seen to fill that queue.

### Records

FindPcmRecord (`$D120`) searches the two directories at `$D568`/`$D56C`. A directory is a record count (word), then one 4-byte entry per record (type byte, id byte, length word), then the records one after another. Types seen: 0 a sound, 2 a wave sample, 4 an envelope, 7 a pointer to another record id. `StarterPcmRecords` in `startergfx.asm` is such a directory: one type 2 record, the 59,804-byte sample LoadStarterPcmSamples installs (command 5) and uploads (command 6, the list `2, 0, $FFFF`).

### PCM chip

| Address | Use |
| --- | --- |
| `$FF0001` | channel envelope |
| `$FF0003` | stereo pan |
| `$FF0005`/`$FF0007` | frequency low/high |
| `$FF0009`/`$FF000B` | loop address low/high |
| `$FF000D` | start address |
| `$FF000F` | channel / bank control |
| `$FF0011` | channel disable mask |
| `$FF0021` on | playback address reads |
| `$FF2001`-`$FF3FFF`, odd bytes | wave RAM window (CopyPcmWaveData changes bank as it wraps) |

SelectPcmChannel (`$D080`) reuses a matching channel, then a disabled one, then replaces by the record's priority byte. UpdatePcmFrequency (`$CE06`) interpolates PcmPitchTable (`$CF5E`, the frequency steps of 0 to 48 semitones above a sample's root note). The system program has the same driver with one more command, and `docs/segacd_boot.md` ("Channels, records and envelopes") has the record and envelope formats and the channel tables, which hold for this copy too. UpdatePcmPan (`$CFC0`) combines the levels and pan. PcmWriteDelay (`$D352`) is the short wait after a register write. WaitCdbiosReady (`$D342`) calls BIOS `$80` (CDBCHK) until carry clears; no caller was found.

## Start-up sequence and credits

RunStarterSequence (`$D8F8`): CopyScreensToWordRam (the five screens of `startergfx.asm` to `$80000`), LoadStarterPcmSamples, AnimateEASportsLogo (`$DA2A`), ShowHighScoreScreen (`$DB8C`), RunStarterFilm (`$EAE4`), CopyScreensToWordRam again, RunCredits (`$DD22`), ClearStarterPaletteAndWait (`$E14C`). AnimateEASportsLogo builds the EA SPORTS logo from the sprite pieces in EASportsLogoSprites (the copy at `$109DC`). ShowHighScoreScreen draws HighScoreScreen ("High Score Productions presents", the copy at `$109D8`, main command 8) and runs four sparkle animations from SparkleSprites (`$109E0`; InitStarterAnimation, StepStarterAnimation) until a pad press or the time is up. RunCredits draws CreditsTitleScreen and the credits lines in CreditsFont. Each screen is in `startergfx.asm`; their packed tiles are the cartridge's DecompressBytecode format, unpacked on the main CPU by MAIN.BIN's copy of DecompressGraphics. The sprite list helpers are BeginStarterSpriteList, AppendStarterSprites (eight-byte entries, at most 80), FinishStarterSpriteList and CopyStarterSpriteData (to word RAM `$BC6F0`).

RunCredits reads the records at `$25F0E` and `$25F36`, the credits text at the start of `startertail.asm` (file `$1AF0E`). DrawCreditsLines (`$DE96`) draws length-prefixed lines until a negative word; WaitCreditsFrame (`$DEF2`) waits for the frame counter, scrolls and reads the pads; UpdateCreditsScroll (`$DF1E`) sends main command `$1D`.

## Commands to the main CPU

SendMainCommand (`$E370`) writes d0 to `$FF8020`, sets sub flag bit 6, waits for the main CPU, and hands word RAM over and back (`$FF8014` bit 0 and the four phases on `$FF8018`/`$FF8028`, SyncMainWordRamPhase0-3). Arguments go in word RAM at `$BA450` (`$23A450` on the main CPU). These numbers are the driver's: MAIN.BIN's older interface, `CmdJumpTable` at `$FF11BE` (`docs/segacd_main_shell.md`, "The older interface"), not the game shell's.

| Routine | Command | Arguments |
| --- | --- | --- |
| SendMainCommand00 / 01 (`$E338`, `$E354`) | `$00`, `$01` | d0.w, d1.w, a0.l |
| SendMainCommand02Inline (`$E320`) | `$02` | nine words after the call (SetUpDisplayCommand) |
| SendMainCommand03 (`$E310`) | `$03` | |
| SendMainLoadTiles (`$E12A`) | `$04` | d4, a2: tiles into VRAM (LoadTilesCommand) |
| SendMainFontMap (`$E8E2`) | `$05` | the pointer at `$1094C`, CreditsFont: the text font (SetFontMapCommand) |
| SendMainCommand06 / 07 / 08 | `$06`-`$08` | TileRemap reset; a filled rectangle (d0-d2); a picture (a0-a2, d0-d5) |
| SendMainCommand0BInline, SendMainCommand0B, SendMainCommand0C, SendMainCommand0DInline | `$0B`-`$0D` | text: a length-prefixed string, inline or at a1 (DrawTextCommand, DrawCodedTextCommand) |
| SendMainCommand0E (`$E6FC`) | `$0E` | `$10AE4`-`$10B07`: the drawing parameters, font bases among them |
| ReadMainHvCounter (`$E7E0`) | `$0F` | the reply (HV counter) at `$10BCE` |
| SendMainCommand10Inline, SendMainCommand12Inline / 12 | `$10`, `$12` | recoloured tiles; a cell rectangle copy (inline or at a1) |
| WriteMainVdpControl (`$E958`) | `$13` | a VDP control word |
| SendMainCommand14-19 | `$14`-`$19` | |
| PrepareMainFilmDisplay (`$EC80`) | `$1A` | VDP set-up for the film |

## Word RAM, frames, pads

ClearSubCommWords (`$E3BC`) clears `$FF8020`-`$FF802E`. EnterTwoMegWordRamMode (`$E3EE`) and EnterOneMegWordRamMode (`$EA00`) change memory mode bit 2; WaitForSubWordRam (`$E416`) and GiveWordRamToMain (`$E430`) pass word RAM between the CPUs. InstallDriverFrameCallback (`$E454`) saves the old vector at `$10ACC` and installs DriverFrameCallback, which counts `$10AE0` and may give word RAM away and back for the frame (ReleaseDriverFrameWordRam, ReclaimDriverFrameWordRam). WaitDriverFrames (`$E118`) waits d0 frames; WaitNextDriverFrame (`$DFAC`) waits for the next. ReadStarterPads (`$E198`) reads four pads through ReadStarterPad (`$E24A`, `$FF801C`/`$FF801E`) with repeat (RepeatStarterPad); DecodeStarterPadDirection uses the table at `$E300`. StarterRandomRange (`$E488`) is the random number helper; crt.asm calls it for sound parameters.

## The film

RunStarterFilm (`$EAE4`) clears the PCM chip (pcmclear.asm), waits for the CD BIOS (cdcwait.asm), sets up the display (PrepareMainFilmDisplay), then calls StarterFilmEntry with operation 0 (open), 1 (advance, repeatedly) and 2 (close); pad bit 7 ends it. It saves `$FF8004` at `$EC8E` and the vector at `$602C` at `$ECB0`, and puts both back. The BIOS calls in the module are `$10` DRVINIT (a0 = `$ECA2`), `$80` CDBCHK and `$96` CDCSETMODE.

## Work area (selected)

| Address | Use |
| --- | --- |
| `$C42E`-`$C452` | shared with startertail (it reads and writes these words) |
| `$C4C0`, `$C4C2`-`$C541` | packed PCM command queue: count, entries |
| `$D362`/`$D364` | sample allocation position, saved position |
| `$D366`-`$D565` | wave address of each sample |
| `$D568`/`$D56C` | the two record directories |
| `$D570` | ServicePcmDriver re-entry guard |
| `$D572`-`$D5BB` | per-channel state (disable mask, sound, record, note, level, priority, envelope) |
| `$D5D0`-`$D84F` | per-sound mapping, level (`$7F`), pan (`$40`), pitch control (`$40`) |
| `$D850`-`$D858` | group levels and master level (`$FF`) |
| `$EC90`-`$ECA1` | RunStarterDriver's arguments |
| `$ECA2` | the DRVINIT parameter block (with `$01FF` and `HOCKEY.SEG`) |
| `$1094C`-`$109E0`, `$10984` | where each screen was copied |
| `$10ADA`-`$10BD7` | state cleared by ClearStarterWorkState |
| `$10AE0`/`$10AE2` | frame counter, last frame seen |
| `$10B14`-`$10B1F` | pads: raw, previous, repeat counters |
| `$10B2A`/`$10B2C` | random number state |
| `$BA450` | main command arguments and replies |

## Not worked out

Who fills this driver's packed PCM command queue during the start-up (in the game, the system program's copy of the driver is fed by the main CPU's sound engine: `docs/segacd_boot.md`); the main CPU side of the driver's commands beyond the table in `docs/segacd_main_shell.md`; why the module keeps a `HOCKEY.SEG` record.
