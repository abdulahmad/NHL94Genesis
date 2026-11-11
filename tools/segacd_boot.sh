#!/bin/bash
# segacd_boot.sh: write the boot area fragments in src/segacd/boot/ with tools/segacd_port.py.
# cdbin/BOOT.BIN is the first 16 sectors of the data track (tools/segacd_bootarea.py copies it from your
# own disc image). header.asm and security.asm are written by hand; these are the two programs:
#   ip.asm  the initial program after Sega's security block: BOOT.BIN $784 runs at $FF0584 (main CPU).
#   sp.asm  the system program: BOOT.BIN $1000 runs at sub CPU $6000. It holds the services HOCKEY.BIN,
#           STARTER.BIN and PLAYER.BIN call at $6044 (function number in d7), and the same Sierra C SDK
#           code as STARTER.BIN (its functions are named from their tags).
#
#   tools/segacd_boot.sh
cd "$(dirname "$0")/.." || exit 1
[ -f cdbin/BOOT.BIN ] || { echo "no cdbin/BOOT.BIN (python tools/segacd_bootarea.py <your disc image>.cue)"; exit 1; }
mkdir -p output src/segacd/boot
fail=0
# The initial program's helpers are the same code as MAIN.BIN's (mainstart_2.asm), so they have its names.
IP_LABELS=(
  --label IPMain=0xFF0584                 # interrupts set up, then MAIN.BIN copied from word RAM to $FF1000 and run
  --label WaitMainWordRam=0xFF0606        # until $A12003 bit 1 clears (as in MAIN.BIN)
  --label GiveSubWordRamAndWait=0xFF0612  # DMNA set, wait for RET to clear (as in MAIN.BIN)
  --label AcknowledgeMainVBlank=0xFF0626  # V interrupt: bit 0 of $A12000 (interrupts the sub CPU), rte
  --label IPHBlank=0xFF0630               # H interrupt: rte
  --label SyncMainShellStartup=0xFF0632   # the flag bit 6 / 7 handshake (as in MAIN.BIN)
  --label SetInterruptLevel=0xFF067C      # d0 into the SR interrupt mask
)
# The system program: the boot code, the services at $6044 (SegaOSCall, d7 = the entry of SegaOSCallTable)
# and what they use. CD-only names given here; docs/segacd_boot.md has the evidence.
SP_LABELS=(
  --label SegaOSCall=0x6044               # d7*4+2 into the bra.w displacement below: jumps to entry d7 of SegaOSCallTable
  --label SegaOSCallTable=0x6052          # seventeen bra.w, services 0-$10
  --label SegaOSStack=0x6096              # the boot stack area (zeros); SegaOSCall's bra.w points here until rewritten
  --label SegaOSStackTop=0x6226           # the boot stack
  --label SegaOSMain=0x622A               # drive init, MAIN.BIN (30 sectors from LBA 30) to word RAM, GTABLE.BIN (LBA 2728)
                                          # to GTableBuffer, STARTER.BIN (120 sectors from LBA 226) to $B000, jmp $B000
  --label ReadFrameHook=0x633E            # put at $6038 (the frame callback) while SegaOSMain reads: sets ReadHookFlag
  --label HookReturn=0x6346               # rts
  --label OSReadSectors=0x637A            # 0: ReadSectors(d2 LBA, d1 sectors, d0 address)
  --label OSLoadResource=0x63AC           # 1: GRAPH2 resource d0 at LoadPointer (GTABLE entry, LBA 286 + sector, end mark checked, 3 tries)
  --label OSSetLoadPointer=0x64EC         # 2: a0 into LoadPointer
  --label OSStartTimer=0x64F4             # 3: StartTimerInterrupt
  --label OSReturnFromPlayer=0x64FC       # 4: HOCKEY.BIN read again (LBA $4F) to $1B000, back to OSRunPlayer's caller
  --label OSRunPlayer=0x662E              # 5: PLAYER.BIN (22 sectors from LBA 2729) to $1B000, over HOCKEY.BIN, and run
  --label OSGetLoadPointer=0x671A         # 6: LoadPointer into a0
  --label OSGetPcmDriver=0x6722           # $E: PcmDriverEntry into a0
  --label OSCallPcmDriver=0x672A          # $10: PcmDriverEntry with d0
  --label OSSetKeptWord=0x6730            # $B: d0 into KeptWord
  --label OSGetKeptWord=0x6738            # $C: KeptWord into d0
  --label OSPlayFilm=0x6740               # 7: main command $25, FilmSwitch 0 (open d1) then 1 until the end or FilmStopFlag
  --label FilmSwitch=0x68D2               # 0 open, 1 frame, else close (as filmrun.asm in STARTER.BIN); the film's state follows
  --label FilmFrameTicks=0x68D6           # FilmHook adds one each time
  --label FilmBuffer=0x68DA               # open's buffer address
  --label FilmBufferSize=0x68DE           # and its size
  --label FilmReadCount=0x68E2            # sectors the read engine has left (negative: a read to start)
  --label FilmReadDest=0x68E6             # where the next sector goes (0: the engine's next buffer)
  --label FilmReadSector=0x68EA
  --label FilmDisplayArgs=0x68F2          # open's arguments 7, 6, 5, 4, 8: tile address, name table, column, row, priority
  --label FilmCallback=0x6906             # open's argument 9: FilmHook calls it when not 0
  --label FilmReadError=0x690A            # -1 after a read error (FilmTask then returns -2)
  --label FilmState=0x6912                # FilmOpen / FilmTask / FilmClose keep the film here (a4)
  --label FilmSwitchBody=0x69B2           # the switch: open saves the arguments, hooks two BIOS jumps, FilmOpen(sector)
  --label SavedFilmHookJump=0x6A7E        # the old target of the BIOS jump at $5F34
  --label InstallFilmHook=0x6A82          # FilmHook into the BIOS jump at $5F34 (the old target kept)
  --label RemoveFilmHook=0x6A9C
  --label FilmHook=0x6AAE                 # on the BIOS jump at $5F34: FilmFrameTicks + 1, then FilmCallback
  --label InitFilmPcm=0x6BEE              # the film audio's PCM channel 0 (pcmchip.asm in STARTER.BIN, docs/segacd_audio.md)
  --label StartFilmPcm=0x6C74             # channel 0 on
  --label StopFilmPcm=0x6C8E              # every channel off
  --label ReadFilmPcmAddress=0x6C9C       # channel 0's play address
  --label LoadFilmPcmBank=0x6CC4          # $1000 bytes from 4(sp) into wave RAM bank 8(sp)
  --label CopySmChunk=0x6AC8              # FilmTask's SM chunk copy to word RAM (filmsm.asm in STARTER.BIN)
  --label SavedFilmReadJump=0x6D18        # the old target of the BIOS jump at $5F8E
  --label InstallFilmReadHook=0x6D1C      # FilmReadInterrupt into the BIOS jump at $5F8E (the old target kept)
  --label RemoveFilmReadHook=0x6D36
  --label StopFilmRead=0x6E54             # FilmReadCount 0, BIOS $08 (ROMPAUSEON)
  --label StartFilmRead=0x6E64            # (sector, count, destination): BIOS $96, $17 (ROMREAD), FilmRead* set for FilmReadInterrupt
  --label FilmBcdToBinary=0x6EC0          # the film code's own copies of BcdToBinary and MsfToLba
  --label FilmMsfToLba=0x6ED8
  --label FilmSectorHeader=0x6D48         # the header of the sector just read (BIOS $8C), checked against FilmReadSector
  --label FilmReadInterrupt=0x6D4C        # the sectors of a read as they arrive (BIOS $8B-$8D); the first must be FilmReadSector
  --label LongMultiply=0x7F64             # Sierra C run-time: d0 * d1 (32 bits); the entry 8 bytes before takes them from the stack
  --label LongModulo=0x7F8A               # d0 mod d1 (signed); likewise
  --label LongDivide=0x7FAE               # d0 / d1 (signed); likewise
  --label SignedDivide=0x7FC4             # both: quotient in d0, remainder in d1
  --label OSStopFilm=0x8078               # $A: FilmStopFlag set
  --label OSInitMainSound=0x808A          # 8: main command $29 with PcmDriverEntry in $FF8022
  --label OSInitMainSoundDriver=0x8122    # $F: main command $40 with PcmDriverEntry in $FF8022
  --label OSStopMainSoundHInt=0x818E      # 9: main command $2A
  --label OSStopTimer=0x81DE              # $D: the saved timer vector put back
  --label StartTimerInterrupt=0x81F2      # TimerInterrupt into the BIOS level 3 jmp (the vector at $6C + 2), interval $84, level 3 enabled
  --label TimerInterrupt=0x822C           # level 3 (gate array timer): interval $84 again; command 1 while PcmServiceEnabled
  --label PcmDriverEntry=0x8260           # bra.w to the PCM driver, then its 130-byte command queue (as in STARTER.BIN)
# The PCM driver: STARTER.BIN's driver (docs/segacd_starter_driver.md) with command 9 added, so its routines
# have the names of their STARTER twins (found by equal byte runs).
  --label PcmCommandQueue=0x8264          # count word, then packed longs (DrainPcmCommandQueue); the main CPU's sound engine fills it
  --label DispatchPcmCommand=0x82E6       # d0.w commands 0-9; d0.b >= $80 goes to DispatchPackedPcmCommand
  --label ServicePcmDriver=0x835C         # command 1: drain the queue, update the channels every $20 timer ticks, ServicePcmStream
  --label DrainPcmCommandQueue=0x83AA     # packed longs from PcmCommandQueue
  --label UpdatePcmEnvelopes=0x83FC       # eight channels: playback address, envelope segments
  --label ServicePcmStream=0x85BE         # command 9's stream: refill the half the channel has left, point the loop at the other
  --label DispatchPackedPcmCommand=0x86CC # by command byte range ($80-$EF)
  --label PlayPackedPcmSound=0x8716       # $90-$9F: pick a channel, start, loop, frequency, envelope, pan
  --label StopPackedPcmSound=0x886E       # $80-$8F: release or disable the matching channel
  --label SetPcmSoundMapping=0x8970       # $B0-$CF
  --label SetPcmPitchControl=0x8994       # $E0-$EF, then the frequency update
  --label StartPcmEnvelope=0x89E8         # record type 4: envelope id, position, first level
  --label InitPcmDriver=0x8A9E            # command 0
  --label PlayPcmSample=0x8BAC            # command 3: explicit frequency, envelope, pan
  --label UpdatePcmFrequency=0x8CE4       # the note against the record's root, fine tune, pitch bend, modulation: PcmPitchTable
  --label PcmPitchTable=0x8EAC            # frequency steps of semitones 0-48 above the root: $0800 (as recorded), doubling every 12
  --label UpdatePcmPan=0x8F0E             # levels and pan to $FF0003
  --label SelectPcmChannel=0x8FCE         # reuse, a disabled channel, or replace by priority
  --label FindPcmRecord=0x906E            # search the record directories by type and id
  --label ControlPcmSampleAllocation=0x90E2 # command 2: reset / save / restore PcmAllocPosition
  --label SetPcmRecordDirectory=0x9152    # command 5: a0 into directory d1
  --label LoadPcmRecordList=0x9166        # command 6: type/id pairs to $FFFF, uploads type-2 samples
  --label CopyPcmWaveData=0x91C8          # odd bytes of $FF2001-$FF3FFF, bank by bank
  --label SetPcmSoundLoopOffset=0x9248    # command 8: the word at offset 5 of a type-0 record
  --label PlayPcmStream=0x9290            # command 9 (not in STARTER): a0 -1 stop, 0 ask, else stream a0 (ends at $FF); d1 frequency, d2 envelope, d3 pan
  --label FillPcmStreamHalf=0x949E        # d0 = 0 half A, 1 half B: copy the next bytes from PcmStreamSource, $FF after them
  --label WaitCdbiosReady=0x95A2          # BIOS $80 (CDBCHK) until carry clear
  --label PcmCommandNoOp=0x95B0           # command 7: rts
  --label PcmWriteDelay=0x95B2            # nop / dbf after PCM register writes
  --label PcmAllocPosition=0x95C2         # the next free wave RAM address (STARTER's $D362), then the saved one
  --label PcmSampleAddress=0x95C6         # 256 words: each wave sample id's wave RAM address ($FFFF: not loaded)
  --label PcmLastWaveLength=0x97C6        # CopyPcmWaveData's byte count, added to PcmAllocPosition
  --label PcmRecordDirectories=0x97C8     # four longs (SetPcmRecordDirectory d1), searched by FindPcmRecord
  --label PcmServiceBusy=0x97D8           # ServicePcmDriver's reentry guard
  --label PcmChannelOffMask=0x97DA        # what was last written to $FF0011 (a set bit: channel off)
  --label PcmChannelSlot=0x97DC           # one byte per channel: the packed-command slot it plays for
  --label PcmChannelSound=0x97E4          # one byte per channel: the sound (type 0 record id)
  --label PcmChannelNote=0x97EC           # one byte per channel: the note
  --label PcmChannelVelocity=0x97F4       # one byte per channel: the velocity (the level, before the envelope)
  --label PcmChannelPriority=0x97FC       # one byte per channel: a sound takes the channel when its record's byte is not above it
  --label PcmChannelEnvelope=0x9804       # one byte per channel: the envelope (type 4 record id), $FF none
  --label PcmChannelSegment=0x980C        # one byte per channel: the envelope segment it is in
  --label PcmChannelSegmentTime=0x9814    # one word per channel: time in that segment ($FF800C ticks / 32)
  --label PcmEnvelopeHeld=0x9825          # a bit per channel: the note is held, so the envelope loops at its sustain segment
  --label PcmLastTimerTick=0x9826         # $FF800C when the channels were last updated
  --label PcmCurrentChannel=0x9828        # the channel the update loops are on (0-7)
  --label PcmEventSlot=0x982A             # the packed command being played or stopped: slot (word)
  --label PcmEventNote=0x982C             # its note (word)
  --label PcmEventVelocity=0x982E         # its velocity (word)
  --label PcmEventSound=0x9830            # the sound PcmSoundMapping (and a key map record) gives (word)
  --label PcmReuseFlags=0x9832            # SelectPcmChannel: the record's flags byte $C when a channel already playing the
                                          # sound is taken (bit 1 clear: it keeps playing, only the frequency changes)
  --label PcmEventRecord=0x9834           # the sound's type 0 record
  --label PcmStreamActive=0x9838          # not zero while command 9's stream plays
  --label PcmStreamHalfA=0x983A           # wave RAM address of half A
  --label PcmStreamHalfASize=0x983C       # $400 bytes, or half of a smaller free wave RAM rounded down to $100
  --label PcmStreamHalfB=0x983E           # wave RAM address of half B (right after half A)
  --label PcmStreamHalfBSize=0x9840
  --label PcmStreamLoopB=0x9842           # the loop address once half A is filled: half B (zero after the end byte)
  --label PcmStreamLoopA=0x9844           # the loop address once half B is filled: half A (zero after the end byte)
  --label PcmStreamLastHalf=0x9846        # the half filled last: 0 A, 1 B
  --label PcmStreamChannel=0x9848
  --label PcmStreamSource=0x984A          # the next byte to copy; -1 once the $FF end byte is reached
  --label PcmStreamFrequency=0x984E       # d1 of command 9
  --label PcmStreamEnvelope=0x9850        # d2 of command 9
  --label PcmStreamPan=0x9852             # d3 of command 9
  --label PcmSoundMapping=0x9854          # 128 bytes, one per packed-command slot: packed $B0-$CF (STARTER's $D5D0)
  --label PcmSlotModulation=0x98D4        # 128 bytes, one per slot: modulation depth, 0 at init and nothing writes it
  --label PcmSlotLevel=0x9954             # 128 bytes, one per slot: $7F at init
  --label PcmSlotPan=0x99D4               # 128 bytes, one per slot: $40 (centre) at init
  --label PcmPitchControl=0x9A54          # 128 bytes, one per slot: packed $E0-$EF, $40 at init (STARTER's $D7D0)
  --label PcmGroupLevel=0x9AD4            # 8 bytes, one per 16 slots (the long's top byte / 16): $FF at init
  --label PcmMasterLevel=0x9ADC           # $FF at init
  --label PcmModulationLevels=0x9ADD      # 3 bytes picked by a record's byte $A: $80 (none) at init, nothing writes them
  --label SyncWithMain=0x9AE0             # the flag bit 6 / 7 handshake
  --label WaitForSubWordRam=0x9B20        # until $FF8003 bit 1 (RET) is set (as in STARTER.BIN and PLAYER.BIN)
  --label GiveWordRamToMain=0x9B2C        # $FF8003 bit 0, then until bit 1 clears (as in STARTER.BIN and PLAYER.BIN)
  --label WaitDriveReady=0x9B40           # BIOS $80 (CDBCHK) until carry clear, registers kept
  --label DriveInitParams=0x9B56          # BIOS $10 (DRVINIT): $01FF, then zeros
  --label BcdToBinary=0xA372              # d0.b BCD to binary
  --label MsfToLba=0xA38A                 # d0 = minute, second, frame (BCD, from a sector header) to a sector number
  --label WaitReadFrame=0xA3DC            # sub flag bit 5, then until ReadFrameHook sets ReadHookFlag
  --label ReadSectors=0xA3F8              # (LBA, sectors, address): BIOS reads through $5F22, five tries
  --cdname GTableBuffer=0x9B58
  --cdname StarterEntry=0xB000            # STARTER.BIN, where SegaOSMain jumps
  --cdname PlayerCallerSp=0xA358
  --cdname PlayerReturn=0xA35C
  --cdname LoadPointer=0xA360
  --cdname SavedReadHook=0xA364
  --cdname ReadHookFlag=0xA368
  --cdname FilmStopFlag=0xA36A
  --cdname KeptWord=0xA36C
  --cdname SavedTimerVector=0xA36E
  --cdname TimerCountdown=0x8228          # TimerInterrupt counts it 15 to 0 and round again; nothing reads it
  --cdname PcmServiceEnabled=0x822A       # set by services 8 and $F, cleared by 9: TimerInterrupt runs command 1 while set
  --cdname PcmEventSlotByte=0x982B        # the low bytes of the PcmEvent words
  --cdname PcmEventNoteByte=0x982D
  --cdname PcmEventVelocityByte=0x982F
  --cdname PcmEventSoundByte=0x9831
)
# Code the decoder would take for text (an rts, unlk / addq / jmp, nops spell letters), and the PCM driver's
# pitch table (words, not instructions).
SP_RANGES=(
  --code 0x6346-0x6348 --code 0x6BE6-0x6BEE --code 0x7D7C-0x7D86 --code 0x8032-0x8038
  --code 0x8260-0x8EAC --data 0x8EAC-0x8F0E --code 0x8F0E-0x95C2
)
port() {  # name start end base [options...]
  local n=$1 s=$2 e=$3 b=$4
  shift 4
  python tools/segacd_port.py --disc cdbin/BOOT.BIN --base "$b" --plain --tags --cart-start 0 --cart-end 0 \
    --disc-start "$s" --disc-end "$e" --out "src/segacd/boot/$n.asm" --register "$@" > "output/port_boot_$n.log" 2>&1
  grep -q "^MATCH" "output/port_boot_$n.log" || fail=1
  grep -E "^(MATCH|MISMATCH)|^src" "output/port_boot_$n.log" | tr '\n' ' '; echo
}

port ip 0x784 0x1000 0xFEFE00 "${IP_LABELS[@]}" --note 'The initial program after Sega'"'"'s security block (security.asm): it sets the interrupt level and the\nV / H interrupt vectors, waits for the sub CPU, takes word RAM, copies MAIN.BIN ($EC02 bytes, which the\nsystem program put in word RAM) to $FF1000 and jumps to it. Then zeros to the system program.'
port sp 0x1000 0x8000 0x5000 "${SP_LABELS[@]}" "${SP_RANGES[@]}" --note 'The system program (sub CPU $6000, module MAIN SEGAOS): the header, the service dispatch at $6044\n(function number in d7), the file table, then the Sierra C SDK code STARTER.BIN has too, and zeros.'

exit $fail
