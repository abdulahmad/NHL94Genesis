#!/bin/bash
# segacd_starter.sh: write the STARTER.BIN fragments in src/segacd/starter/ with tools/segacd_port.py.
# STARTER.BIN is the Sega CD SDK (no cartridge code): the fragments are its instructions, with the Sierra C
# function names taken from the name tag after each rts. Needs only cdbin/STARTER.BIN (no ROM, no listing).
# The older hand fragments in src/segacd/ (filmopen.asm, subheap.asm ...) are written by hand; these fill
# the gaps between them. This file records each fragment's range and note.
#
#   tools/segacd_starter.sh
cd "$(dirname "$0")/.." || exit 1
mkdir -p output src/segacd/starter
fail=0
# Names for the driver module (CD-only, given here; the evidence is in docs/segacd_starter_driver.md).
SUBHDR_LABELS=(
  --label StarterDriverEntry=0xC4B6       # jmp RunStarterDriver; startertail calls it with d0-d4
  --label DispatchPcmCommandEntry=0xC4BC  # bra.w DispatchPcmCommand; the C part and startertail call it
)
SUBDRV_LABELS=(
  --label DispatchPcmCommand=0xC542       # d0.w commands 0-8; d0.b >= $80 goes to DispatchPackedPcmCommand
  --label ServicePcmDriver=0xC5AE         # command 1: drain the queue, update the channels every $20 timer ticks
  --label DrainPcmCommandQueue=0xC5F8     # packed longs at $C4C2, count at $C4C0
  --label UpdatePcmEnvelopes=0xC64A       # eight channels: playback address, envelope segments
  --label DispatchPackedPcmCommand=0xC80C # by command byte range ($80-$EF)
  --label PlayPackedPcmSound=0xC856       # $90-$9F: pick a channel, start, loop, frequency, envelope, pan
  --label StopPackedPcmSound=0xC9AE       # $80-$8F: release or disable the matching channel
  --label SetPcmSoundMapping=0xCAB0       # $B0-$CF: a byte into $D5D0[index]
  --label SetPcmPitchControl=0xCAD4       # $E0-$EF: a byte into $D7D0[index], then the frequency update
  --label StartPcmEnvelope=0xCB28         # record type 4: envelope id, position, first level
  --label InitPcmDriver=0xCBDE            # command 0
  --label PlayPcmSample=0xCCCE            # command 3: explicit frequency, envelope, pan
  --label UpdatePcmFrequency=0xCE06       # note + pitch control through PcmPitchTable, to $FF0005/$FF0007
  --label PcmPitchTable=0xCF5E            # frequency steps of semitones 0-48 above a sample's root: $0800, doubling every 12
  --label UpdatePcmPan=0xCFC0             # levels and pan to $FF0003
  --label SelectPcmChannel=0xD080         # reuse, a disabled channel, or replace by priority
  --label FindPcmRecord=0xD120            # search the two directories at $D568/$D56C by type and id
  --label ControlPcmSampleAllocation=0xD194 # command 2: reset / save / restore $D362/$D364
  --label SetPcmRecordDirectory=0xD204    # command 5: a0 into $D568 + d1*4
  --label LoadPcmRecordList=0xD218        # command 6: type/id pairs to $FFFF, uploads type-2 samples
  --label CopyPcmWaveData=0xD27A          # odd bytes of $FF2001-$FF3FFF, bank by bank
  --label SetPcmSoundLoopOffset=0xD2FA    # command 8: the word at offset 5 of a type-0 record
  --label WaitCdbiosReady=0xD342          # BIOS $80 (CDBCHK) until carry clear
  --label PcmCommandNoOp=0xD350           # command 7: rts
  --label PcmWriteDelay=0xD352            # nop / dbf after PCM register writes
  --label RunStarterDriver=0xD85A         # saves d0-d4 at $EC90, sets up, runs RunStarterSequence, restores
  --label RunStarterSequence=0xD8F8       # screens, samples, the EA SPORTS logo, High Score Productions, film, credits
  --label CopyScreensToWordRam=0xD94C     # the five screens of startergfx.asm to $80000
  --label CopyBytesToEnd=0xD9DC           # (a1)+ to (a0)+ until a1 = a2
  --label LoadStarterPcmSamples=0xD9E4    # commands 2, 5 (StarterPcmRecords) and 6
  --label AnimateEASportsLogo=0xDA2A      # sprites from EASportsLogoSprites ($109DC copy), timed, palette
  --label AnimateEASportsLogoStep=0xDAC6  # advances its timed records and rebuilds the sprites
  --label ShowHighScoreScreen=0xDB8C      # draws HighScoreScreen ($109D8 copy, command 8), four SparkleSprites animations, ends on a pad press
  --label ShowHighScoreScreenStep=0xDC78  # steps the four sparkle animations, builds and copies the sprites
  --label RunCredits=0xDD22               # draws and scrolls the credits records at $25F0E
  --label DrawCreditsLines=0xDE96         # length-prefixed lines through SendMainCommand0B
  --label WaitCreditsFrame=0xDEF2         # waits for $10AE0, scrolls, reads the pads
  --label UpdateCreditsScroll=0xDF1E      # main command $1D
  --label WaitNextDriverFrame=0xDFAC      # until $10AE0 changes
  --label BeginStarterSpriteList=0xDFCA
  --label AppendStarterSprites=0xDFDA     # eight-byte sprite entries, at most 80
  --label FinishStarterSpriteList=0xE03A
  --label CopyStarterSpriteData=0xE06E    # to word RAM $BC6F0
  --label StepStarterAnimation=0xE0BA
  --label InitStarterAnimation=0xE102
  --label WaitDriverFrames=0xE118         # waits d0 frame callbacks
  --label SendMainLoadTiles=0xE12A        # main command 4 (LoadTilesCommand): d4, a2
  --label ClearStarterPaletteAndWait=0xE14C
  --label WaitStarterTransfer=0xE17A      # until the word at $BA8D0 is negative
  --label ReadStarterPads=0xE198
  --label RepeatStarterPad1=0xE1B6
  --label RepeatStarterPad2=0xE1E6
  --label RepeatStarterPad=0xE212
  --label ReadStarterPad=0xE24A           # $FF801C/$FF801E, pad d4
  --label ReadStarterPad1=0xE298
  --label ReadStarterPad2=0xE2BC
  --label DecodeStarterPadDirection=0xE2DE # the 16-byte table at $E300
  --label SendMainCommand03=0xE310
  --label SendMainCommand02Inline=0xE320  # nine inline words after the call
  --label SendMainCommand00=0xE338
  --label SendMainCommand01=0xE354
  --label SendMainCommand=0xE370          # d0 to $FF8020, flag bit 6 handshake, word RAM handover
  --label ClearSubCommWords=0xE3BC        # $FF8020-$FF802E
  --label EnterTwoMegWordRamMode=0xE3EE
  --label SyncMainFlag7=0xE3F8
  --label WaitForSubWordRam=0xE416
  --label GiveWordRamToMain=0xE430
  --label ClearStarterWorkState=0xE440    # $10ADA-$10BD7
  --label StarterSequenceNoOp=0xE452
  --label InstallDriverFrameCallback=0xE454 # DriverFrameCallback into the vector d2 points at
  --label StarterRandomSigned=0xE47C
  --label StarterRandomRange=0xE488
  --label SendMainCommand06=0xE4C6
  --label SendMainCommand07=0xE4D6
  --label SendMainCommand08=0xE51C
  --label SendMainCommand0BInline=0xE57C
  --label SendMainCommand0C=0xE5E2
  --label SendMainCommand0DInline=0xE658
  --label DoubleStarterColorComponents=0xE6D6
  --label SendMainCommand0E=0xE6FC
  --label AppendStarterTextInline=0xE722
  --label AppendStarterText=0xE73C
  --label MeasureStarterText=0xE780
  --label MeasureStarterCharacter=0xE7B2
  --label ReadMainHvCounter=0xE7E0        # main command $0F
  --label SendMainCommand10Inline=0xE7FA
  --label SyncMainWordRamPhase0=0xE826
  --label SyncMainWordRamPhase1=0xE844
  --label SyncMainWordRamPhase2=0xE862
  --label SyncMainWordRamPhase3=0xE880
  --label SendMainCommand12Inline=0xE89E
  --label SendMainCommand12=0xE8C4
  --label SendMainFontMap=0xE8E2          # main command 5 (SetFontMapCommand): the credits font
  --label SendMainCommand0B=0xE8F6
  --label WriteMainVdpControl=0xE958      # main command $13
  --label SendIndexedMainCommand0C=0xE970
  --label SkipStarterRecords=0xE978
  --label SendMainCommand14=0xE984
  --label SendMainCommand15=0xE994
  --label SendMainCommand16=0xE9A4
  --label SendMainCommand19=0xE9C2
  --label SendMainCommand17=0xE9D8
  --label SendMainCommand18=0xE9E4
  --label EnterOneMegWordRamMode=0xEA00
)
SUBDRV2_LABELS=(
  --label DriverFrameCallback=0xEA8A      # installed by InstallDriverFrameCallback; counts $10AE0
  --label ReleaseDriverFrameWordRam=0xEAAC
  --label ReclaimDriverFrameWordRam=0xEAD0
  --label StarterFilmCallbackNoOp=0xEAE2  # rts, passed in the film-open arguments
  --label RunStarterFilm=0xEAE4           # film operations 0 / 1 / 2 through StarterFilmEntry
  --label PrepareMainFilmDisplay=0xEC80   # main command $1A
  --label StarterFilmEntry=0xECB4         # bra.w to $ED94, where filmrun.asm starts (FilmSwitch in boot/sp.asm)
# The film's state after it, named as in the system program's copy (docs/segacd_boot.md "Films"):
  --label FilmFrameTicks=0xECB8           # FilmHook adds one each time
  --label FilmBuffer=0xECBC               # open's buffer address
  --label FilmBufferSize=0xECC0           # and its size
  --label FilmReadCount=0xECC4            # sectors the read engine has left (negative: a read to start)
  --label FilmReadDest=0xECC8             # where the next sector goes (0: the engine's next buffer)
  --label FilmReadSector=0xECCC
  --label FilmDisplayArgs=0xECD4          # open's display arguments (tile address, name table, column, row, priority)
  --label FilmCallback=0xECE8             # FilmHook calls it when not 0
  --label FilmReadError=0xECEC            # -1 after a read error
  --label FilmState=0xECF4                # FilmOpen / FilmTask / FilmClose keep the film here (a4)
)
# After pcmchip.asm: the read hook and the read engine (the system program's names; STARTER = SP + $83E2).
SUBIRQ_LABELS=(
  --label SavedFilmReadJump=0xF0FA        # the old target of the BIOS jump at $5F8E
  --label InstallFilmReadHook=0xF0FE      # FilmReadInterrupt into the BIOS jump at $5F8E
  --label RemoveFilmReadHook=0xF118
  --label FilmSectorHeader=0xF12A         # the header of the sector just read
  --label FilmReadInterrupt=0xF12E        # the sectors of a read as they arrive (BIOS $8B-$8D)
  --label StopFilmRead=0xF236             # FilmReadCount 0, BIOS $08 (ROMPAUSEON)
  --label StartFilmRead=0xF246            # (sector, count, destination): BIOS $96, $17 (ROMREAD)
  --label FilmBcdToBinary=0xF2A2
  --label FilmMsfToLba=0xF2BA             # minute, second, frame (BCD) to a sector number
)
# Names in the older hand fragments, for the generated ones that call them.
HANDNAMES=(
  --cdname FilmSwitchBody=0xED94          # filmrun.asm
  --cdname CopySmChunk=0xEEAA             # filmsm.asm
  --cdname InitFilmPcm=0xEFD0             # pcmchip.asm (docs/segacd_audio.md)
  --cdname StartFilmPcm=0xF056
  --cdname StopFilmPcm=0xF070
  --cdname ReadFilmPcmAddress=0xF07E
  --cdname LoadFilmPcmBank=0xF0A6
)
# Every driver name, for the fragments that call into the driver from outside (an equate where used).
DRVNAMES=()
for x in "${SUBHDR_LABELS[@]}" "${SUBDRV_LABELS[@]}" "${SUBDRV2_LABELS[@]}" "${SUBIRQ_LABELS[@]}" "${HANDNAMES[@]}"; do
  [ "$x" = --label ] && DRVNAMES+=(--cdname) || DRVNAMES+=("$x")
done
port() {  # name start end [options...]
  local n=$1 s=$2 e=$3
  shift 3
  python tools/segacd_port.py --disc cdbin/STARTER.BIN --base 0xB000 --plain --tags --cart-start 0 --cart-end 0 \
    --disc-start "$s" --disc-end "$e" --out "src/segacd/starter/$n.asm" --register "${DRVNAMES[@]}" "$@" > "output/port_starter_$n.log" 2>&1
  grep -q "^MATCH" "output/port_starter_$n.log" || fail=1
  grep -E "^(MATCH|MISMATCH)|^src" "output/port_starter_$n.log" | tr '\n' ' '; echo
}

# STARTER.BIN runs at file + $B000 (runtime $B000-$285B7). Every absolute call and data reference in it fits
# that base: the driver module's jmp $D85A is file $285A, crt's lea $104EC.l is the data after crt (file
# $54EC), startertail's jsr $27A6A is its own code at file $1CA6A. The older subboot.asm, pcmclear.asm,
# cdcwait.asm ... were first written at $21300 and are at $B000 now (same bytes).
port subhdr 0x90 0x1542 "${SUBHDR_LABELS[@]}" --note 'Zeros after subboot.asm (the stack top is $C41C), a file record (HOCKEY.BIN, $01FF), the words\nstartertail shares at $C42E-$C452, then the driver'"'"'s two entries: StarterDriverEntry (the start-up) and\nDispatchPcmCommandEntry (PCM commands). Names given here; docs/segacd_starter_driver.md.'
# The parameter blocks after calls to the inline senders (SendMainCommand02Inline: 18 bytes; 0BInline /
# 0DInline: a length word, the block's size): data, not instructions.
SUBDRV_INLINE=(
  --data 0xDA3A-0xDA4C --data 0xDAAE-0xDAC0 --data 0xDBA6-0xDBAE --data 0xDD2E-0xDD40
  --data 0xDD6C-0xDD72 --data 0xDD8A-0xDD90 --data 0xDDAA-0xDDB0 --data 0xDDD8-0xDDDE
  --data 0xDE1A-0xDE20 --data 0xDE5E-0xDE64
)
port subdrv 0x1542 0x3A0C "${SUBDRV_LABELS[@]}" --code 0xC542-0xCF5E --data 0xCF5E-0xCFC0 --code 0xCFC0-0xD362 "${SUBDRV_INLINE[@]}" --note 'The sub CPU driver module: the PCM sound driver (commands 0-8 and packed commands, records, eight\nchannels, envelopes), then the start-up sequence (screens, samples, two stages, film, credits), the commands\nit sends to the main CPU, word RAM handover, frames, pads. Names given here; docs/segacd_starter_driver.md.\nThe parameter blocks of the inline senders and PcmPitchTable are words.\npcmclear.asm follows.'
port subdrv_2 0x3A8A 0x3D94 "${SUBDRV2_LABELS[@]}" --data 0xEAF2-0xEB04 --note 'The end of the sub CPU driver module, between cdcwait.asm and filmrun.asm: the frame callback,\nRunStarterFilm (film operations 0, 1, 2 through StarterFilmEntry, which branches to filmrun.asm at $ED94),\nthe saved arguments and the DRVINIT block (with HOCKEY.SEG). docs/segacd_starter_driver.md.'
port subirq 0x40FA 0x4336 "${SUBIRQ_LABELS[@]}" --note 'After pcmchip.asm: a long that keeps the BIOS vector at $5F90 (the first line, decoded as an\nori.b #0), code that hooks that vector with its own handler and puts it back, then the C function Wait.'
port subtext 0x4788 0x49FA --note 'SwapMeg, DrawText, NumStr, HexStr, aprint: text to the main CPU (SendCommandToMain, the\nDoDrawTextCommand side is in maintext.asm) and number formatting.'
port heapalloc 0x49FA 0x4C84 --note 'The heap: ffree, findSmallestBlock, MaxFree, mmalloc, InitHeap.'
port subinit 0x4C84 0x4D9E --note 'InitWorld (prints SUBCPU is alive), GetTicks, WaitIODone.'
port copydata 0x4DDE 0x4E26 --note 'CopyData (after SendCommandToMain in filmcmd.asm).'
port engine 0x4ECE 0x4FA8 --note 'DisposeEngine, GetSectDst, PeekSectDst: the CD read engine (InitEngine is in filmbuf.asm,\nEngineIdle and GetData in subheap.asm).'
port readdata 0x5068 0x508C --note 'ReadData (between GetData in subheap.asm and the audio stream in audiostream.asm).'
port filmopen_tag 0x4538 0x458C --note 'The FilmOpen name tag after filmopen.asm and the strings FilmOpen prints.'
port filmtask_tag 0x472E 0x473A --note 'The FilmTask name tag after filmtask.asm.'
port filmclose_tag 0x477C 0x4788 --note 'The FilmClose name tag after filmclose.asm.'
port filmcmd_tag 0x4DCA 0x4DDE --note 'The SendCommandToMain name tag after filmcmd.asm.'
port filmbuf_tag 0x4EC0 0x4ECE --note 'The InitEngine name tag after filmbuf.asm.'
port startertext 0x556E 0x5BD8 --raw --raw-text --note 'After cdfade.asm: tables, the SDK demo strings (Example Line 0-7) and more tables, as bytes.\nstartergfx.asm (by hand: the five screens the driver copies to $80000) follows.'
port startertail 0x1AF0E 0x1D5B8 --text-incbin --label SubMain=0x262A8 --note 'After startergfx.asm to the end of the file: the credits text (read from the disc file: it names\nreal people), then code and data, decoded as found. SubMain (a name given here) is where the boot'"'"'s\njmp $262A8 lands: stack at $C41C, the gate array command words cleared, then the start-up. The code\nends with jmp $B00E, back to the boot, which loads HOCKEY.BIN at $1B000 over this part of the file.'
port crt 0x5304 0x54F6 --note 'The Sierra C run-time helpers after AudioBusy: 32-bit multiply ($10304) and the divide /\nmodulo entries with their jump table. No name tags here; cdfade.asm follows.'

exit $fail
