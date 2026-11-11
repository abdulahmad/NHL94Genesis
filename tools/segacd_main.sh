#!/bin/bash
# segacd_main.sh: write the MAIN.BIN fragments in src/segacd/main/ with tools/segacd_port.py.
# MAIN.BIN runs at file + $FF1000 (main CPU): its first instruction jumps to MainShellEntry ($FF45A8, file
# $35A8), the command loop reads ShellCommandTable at $FF471C (file $371C; file $471C is zeros), 61 of that
# table's 64 pointers land on routine starts at this base and 1 at $FF0000, and the code stores the
# literal $FF1006 for the pc-relative address of file $6. The older hand fragments in src/segacd/ were
# first written at $FF0000 and are at $FF1000 now (same bytes). These fill the gaps between them.
# Needs only cdbin/MAIN.BIN. maindisp_2.asm, mainfont_2.asm, maintext_2.asm and maincrt_2.asm are written
# by hand (each includes the file it copies), and so are maintable.asm and mainz80.asm.
#
#   tools/segacd_main.sh
cd "$(dirname "$0")/.." || exit 1
mkdir -p output src/segacd/main
fail=0
# Names (CD-only, given here; docs/segacd_main_shell.md has the evidence), runtime = file + $FF1000.
MSTART_LABELS=(
  --label MainShellEntry=0xFF45A8  # MAIN.BIN starts with jmp here: stack $FFFC00, comm words cleared, start-up handshake, command loop
  --label MainShellCommandLoop=0xFF4622  # waits for sub flag bit 6, reads $A12020, calls ShellCommandTable[command-1]
  --label ReceiveSubWord=0xFF4678  # one word from $A12020 with the bit 6/7 handshake
  --label SendMainWord=0xFF46BE  # d0 to $A12010 with the bit 6/7 handshake
  --label CallMainShellCommand=0xFF4704  # calls the handler for d0, registers saved
)
MSTART_2_LABELS=(
  --label SoundSequenceHInt=0xFF481C  # H interrupt: at line $64 calls sound operation 1 once ($FF6CF8 latch)
  --label AcknowledgeMainVBlank=0xFF4854  # sets bit 0 of $A12000, rte
  --label MainShellVBlank=0xFF485E  # acknowledges, then serves commands from $A12026 (flag bits 3/4)
  --label SyncMainShellStartup=0xFF4918  # start-up handshake on flag bits 6/7
  --label WaitMainMemoryModeReady=0xFF4962  # until $A12003 bit 2 clears
  --label ClearVramByWord=0xFF496E  # command $01
  --label WaitMainWordRam=0xFF4996  # until $A12003 bit 1 clears
  --label GiveSubWordRamAndWait=0xFF49A2  # sets DMNA, waits for RET to clear
  --label SetShellVramWriteAddress=0xFF49B6  # VRAM address d0 to the two VDP control words
  --label CopyWordRamToVram=0xFF49DA  # command $02: count and address from the sub CPU, words from $200000
  --label SetShellCramWriteAddress=0xFF4A0A  # CRAM write command from d0
  --label CopyWordRamToCram=0xFF4A2E  # command $03
  --label TestZ80BusBitCommand=0xFF4A56  # command $04: a bit of $A11100, 0 or 4 to $A12010
  --label ClearByteAtAddressCommand=0xFF4A78  # command $05
  --label ClearWordAtAddressCommand=0xFF4A82  # command $06
  --label GiveSubWordRamCommand=0xFF4A8C  # command $07
  --label RunWordRamVdpDmaCommand=0xFF4A92  # commands $08 and $32: seven VDP words from $23BC88, the DMA, the last write
)
MWRAM_LABELS=(
  --label StepCramFadeCommand=0xFF4C3E  # command $1D: 64 colours one step toward $23BCB0 (the sub side is cramfade)
  --label CopyVramByDmaCommand=0xFF4CAC  # commands $1E and $3A: VRAM to VRAM DMA
  --label RunWordRamVdpDmaListCommand=0xFF4D38  # command $2C: the DMA records at $23C000
  --label FillVramFromWordRamCommand=0xFF4D8E  # commands $1F and $3B
  --label ClearAllVramCommand=0xFF4DE4  # command $20: 64 KB of zeros
  --label WriteVdpWordsFromWordRamCommand=0xFF4E02  # command $21
  --label WriteZ80ResetCommand=0xFF4E24  # command $22: $A12022 to $A11200
  --label SoundOperation4Command=0xFF4E30  # command $23: sound operation 4 (not worked out), gated by $FF6CF8
  --label StartSoundSequenceCommand=0xFF4E5A  # command $26: sound operation 2 with the id in $A12022 (sfxcd.asm)
  --label TickSoundSequenceCommand=0xFF4E84  # command $24: sound operation 1
  --label PollShellPads=0xFF4E8E  # both pad ports, raw bytes kept
  --label ReadShellPad2=0xFF4EAC  # $A10005
  --label ReadShellPad1=0xFF4EB8  # $A10003
  --label EnterMainShellCProgram=0xFF4FC8  # command $25: the C program, then the shell again
  --label RunSubCommandAndRestartShell=0xFF500C  # command $3E: the older command interface (RunSubCommand), then the shell again
)
MVDPINIT_LABELS=(
  --label InstallSoundSequenceHInt=0xFF67E8  # command $27: SoundSequenceHInt on vector $70, VDP $8A00/$8014
  --label DisableShellHInt=0xFF680E  # command $2A: VDP register 0 = $8004
  --label RestartMainShellCommandLoop=0xFF6818  # command $28
  --label InitSoundCommand=0xFF684A  # command $29: the Z80 driver, the sound resources, the H interrupt
  --label InitSoundDriverCommand=0xFF688A  # command $40: the same without the resource calls
  --label DetectFourWayPlayCommand=0xFF68AA  # command $2B: the port probe, a Boolean reply (sram94)
  --label InstallMainShellVBlank=0xFF6916  # command $2D: MainShellVBlank into $FFFD08
  --label InstallAcknowledgeVBlank=0xFF6924  # command $2E: AcknowledgeMainVBlank into $FFFD08
  --label EndVBlankCommandService=0xFF6932  # command $2F
  --label WriteVBlankVdpControlLong=0xFF693C  # command $30
  --label WriteVBlankVdpDataWord=0xFF6948  # command $31
  --label WriteVBlankVdpDataLong=0xFF6954  # command $33
  --label StartVBlankSoundSequence=0xFF6960  # command $34 (gate34.asm)
  --label WriteVBlankPad1Port=0xFF697C  # command $36 (cdpads)
  --label WriteVBlankPad2Port=0xFF6988  # command $35 (cdpads)
  --label ReadVBlankPad1Port=0xFF6994  # command $37
  --label ReadVBlankPad2Port=0xFF69A0  # command $38
  --label WriteVBlankVdpControlWord=0xFF69AC  # command $39 (PLAYER)
  --label SaveCramPaletteCommand=0xFF69B8  # command $3C: 64 CRAM words
  --label ShowWordRamScreenCommand=0xFF69E4  # command $3D: fade out, clear, upload, fade in
  --label InstallScreenFadeVBlank=0xFF6AC8  # ScreenFadeVBlank into $FFFD08
  --label SetScreenVramWriteAddress=0xFF6AF2
  --label ScreenFadeVBlank=0xFF6B0C  # steps the fade, 64 colours
  --label DmaScreenTilesToVram=0xFF6BD0
  --label InstallMainShellOverlayCommand=0xFF6C86  # command $3F: shows a word RAM screen, copies $C5B longs to $FF1006
)
MCMD_LABELS=(
  --label DispatchSoundOperation=0xFF865C  # d0 = 0-9; the targets are z80load.asm and mainmod.asm
)
MMOD_LABELS=(
  --label TickSoundSequences=0xFF87B8  # sound operation 1: eight streams of MIDI-style events, needs the $1234 guard
  --label StartSoundSequence=0xFF8A34  # sound operation 2: a free stream, resource type 3 by id d1
  --label StopSoundSequence=0xFF8ADE  # sound operation 3
  --label ClearZ80SoundBuffers=0xFF8B90  # sound operation 5
  --label RouteSoundEvent=0xFF8BFC  # to the Z80 queue or the deferred queue
  --label QueueDeferredSoundEvent=0xFF8C2A
  --label QueueZ80SoundEvent=0xFF8C76  # four bytes into the queue at Z80 $0030
  --label FlushDeferredSoundEvents=0xFF8CF0
  --label ClearPendingNoteOffs=0xFF8E1E
  --label ExpireSequenceNoteOffs=0xFF8E52
  --label QueueTimedNoteOff=0xFF8E96  # after a $90 event
  --label TickPendingNoteOffs=0xFF8EBC  # emits the $80 events
  --label ServiceZ80DataRequest=0xFF8F30  # a DAC sample (type 1) to the Z80 in $200-byte chunks, on the request byte at
                                         # Z80 $0072; this Z80 program keeps it at $0092, so it is never answered
  --label FindSoundResource=0xFF90CA  # type d0, id d1 in four directories
  --label RegisterSoundResourceBank=0xFF919C  # sound operation 6
  --label LoadZ80SoundResources=0xFF91B0  # sound operation 7
  --label RemoveZ80SoundResources=0xFF91FA  # sound operation 8
  --label ClearZ80SoundResourceDirectory=0xFF92F8  # sound operation 9
  --label AcquireSoundZ80Bus=0xFF933E
  --label ReleaseSoundZ80Bus=0xFF9352
  --label AcquireSoundSubProgramRam=0xFF935C
  --label ReleaseSoundSubProgramRam=0xFF93B0
  --label MapSoundSubProgramPointer=0xFF93FC  # into the main CPU window $020000-$03FFFF
  --label PlayZ80Channel16Note=0xFF8B36  # sound operation 4: d1 into the Z80's slot (its word at Z80 $0028, + 3), then
                                         # program $7F and note d2 on MIDI channel 16 (shell command $23)
  --label UploadZ80SoundResource=0xFF8D5A  # d1+1 bytes from a0 to Z80 RAM at its free pointer ($A00022), an entry in the Z80 $0100 table
  --label SoundEngineGuard=0xFF941A  # $1234 while the state is whole (TickSoundSequences checks it)
  --label SequenceData=0xFF941C  # 8 longs, one per stream: its sequence record (-1: free)
  --label SequencePosition=0xFF943C  # 8 longs: the offset of the next event
  --label SequenceId=0xFF945C  # 8 words: StartSoundSequence's d1
  --label SequenceDelay=0xFF946C  # 8 words: ticks to the next event
  --label SequenceTempo=0xFF947C  # 8 words: ticks per frame in 1/256 (StartSoundSequence's d4); note lengths are divided by it
  --label SequenceFraction=0xFF948C  # 8 words: the 1/256 left over
  --label SequenceRunState=0xFF949C  # 8 longs: frames an event waited for a full queue (word), then the running status byte
  --label CurrentSoundStream=0xFF953E  # the stream TickSoundSequences is on (0-7): the events' top byte is it * 16
  --label PcmChannelRouting=0xFF954A  # 8 words, one per stream: a set bit sends that MIDI channel to the sub CPU PCM driver
  --label PcmQueuePointer=0xFF955A  # the sub CPU PCM driver's command queue (z80load.asm: InitSoundCommand's pointer + 4)
  --label DeferredSoundEvents=0xFF955E  # count, then up to 32 events for the PCM driver
  --label DacSampleRecord=0xFF9540  # the DAC sample ServiceZ80DataRequest streams
  --label DacSamplePosition=0xFF9544  # its next $200-byte chunk (0: ended)
  --label DacSampleLoop=0xFF9548  # the sample's first word: where it goes on at its end ($FFFF: it stops)
  --label SoundResourceBanks=0xFF95EC  # four directory pointers (RegisterSoundResourceBank)
  --label SoundBank=0xFF963C  # InitSoundCommand's bank 0: 48 sequences (type 3) and 31 FM instruments (type 0, kind 0)
  --label Z80SoundResourceList=0xFFA0C6  # the type / id pairs InitSoundCommand loads into the Z80 (the 31 instruments), $FFFF
)
# Every name, for calls from one fragment into another (an equate where used); the hwread.asm handlers
# (names only in maintable.asm) and the table itself too.
ALLNAMES=(
  --cdname ShellCommandTable=0xFF471C
  --cdname Z80SoundImage=0xFF6E0C
  --cdname LoadZ80SoundProgram=0xFF86C8  # z80load.asm (sound operation 0)
  --cdname WriteVdpControlByteCommand=0xFF4B3C
  --cdname WriteVdpControlWordCommand=0xFF4B48
  --cdname WriteVdpControlLongCommand=0xFF4B54
  --cdname WriteVdpDataByteCommand=0xFF4B60
  --cdname WriteVdpDataWordCommand=0xFF4B6C
  --cdname WriteVdpDataLongCommand=0xFF4B78
  --cdname WritePad1DataCommand=0xFF4B84
  --cdname WritePad2DataCommand=0xFF4B90
  --cdname WritePad1CtrlCommand=0xFF4B9C
  --cdname WritePad2CtrlCommand=0xFF4BA8
  --cdname ReadPad1DataCommand=0xFF4BB4
  --cdname ReadPad2DataCommand=0xFF4BC0
  --cdname ReadVdpDataWordCommand=0xFF4BCC
  --cdname ReadVdpDataLongCommand=0xFF4BD8
  --cdname ReadByteAtAddressCommand=0xFF4C14
  --cdname ReadWordAtAddressCommand=0xFF4C22
  --cdname ReadLongAtAddressCommand=0xFF4C30
  --cdname WriteZ80BusReqCommand=0xFF4BF0
  --cdname ReadHvCounterCommand=0xFF4BFC
  --cdname ReadHvCounterByteCommand=0xFF4C08
)
for x in "${MSTART_LABELS[@]}" "${MSTART_2_LABELS[@]}" "${MWRAM_LABELS[@]}" "${MVDPINIT_LABELS[@]}" "${MCMD_LABELS[@]}" "${MMOD_LABELS[@]}"; do
  [ "$x" = --label ] && ALLNAMES+=(--cdname) || ALLNAMES+=("$x")
done
port() {  # name start end [options...]
  local n=$1 s=$2 e=$3
  shift 3
  python tools/segacd_port.py --disc cdbin/MAIN.BIN --base 0xFF1000 --plain --tags --cart-start 0 --cart-end 0 \
    --disc-start "$s" --disc-end "$e" --out "src/segacd/main/$n.asm" --register "${ALLNAMES[@]}" "$@" > "output/port_main_$n.log" 2>&1
  grep -q "^MATCH" "output/port_main_$n.log" || fail=1
  grep -E "^(MATCH|MISMATCH)|^src" "output/port_main_$n.log" | tr '\n' ' '; echo
}

port maincrt 0x34B8 0x35A8 --note 'The Sierra C run-time helpers after maintext.asm: 32-bit multiply and the divide / modulo\nentries with their jump table (the same code as STARTER.BIN crt.asm).'
port mainstart 0x35A8 0x371C "${MSTART_LABELS[@]}" --note 'The game shell: MainShellEntry (MAIN.BIN starts with a jmp here) sets the stack at $FFFC00, clears\nthe communication words and runs MainShellCommandLoop, which calls ShellCommandTable (maintable.asm,\nnext) for each command the sub CPU sends. docs/segacd_main_shell.md.'
# maintable ($371C-$381B, the 64 command handler pointers) is written by hand.
port mainstart_2 0x381C 0x3B3C "${MSTART_2_LABELS[@]}" --note 'After ShellCommandTable (maintable.asm): the H and V interrupt handlers (MainShellVBlank serves the\nsecond command channel), the start-up handshake, word RAM handover and the first command handlers.\nhwread.asm follows (commands $09-$1C).'
port mainwram 0x3C3E 0x40D0 "${MWRAM_LABELS[@]}" --note 'After hwread.asm: command handlers $1D-$26, $2C and $3E (palette fade, VRAM copy and fill by DMA,\nthe sound commands), the pad poll, the way into the shell C program. The second copy of maindisp.asm\n(main/maindisp_2.asm) follows.'
port mainvdpinit 0x57E8 0x5E0C "${MVDPINIT_LABELS[@]}" --note 'After the second copy of the C handlers and of the run-time (maincrt_2.asm): command handlers\n$27-$40 (interrupt set-up, the sound driver, the four-way probe, the V interrupt channel, the screen\nfades, the overlay at $FF1006). mainz80.asm (the Z80 sound image) follows.'
# mainz80 ($5E0C-$765B, the Z80 sound image z80load.asm copies to Z80 $0000) is Z80 source:
# src/segacd/main/mainz80.z80, written by tools/segacd_z80dis.py and assembled by tools/build.js --segacd;
# mainz80.asm (by hand) includes it.
port maincmd 0x765C 0x76C8 "${MCMD_LABELS[@]}" --note 'DispatchSoundOperation (after the Z80 sound image): d0 = 0 (z80load.asm, next) or 1-9 (mainmod.asm).'
port mainmod 0x77B8 0xEC00 "${MMOD_LABELS[@]}" --data 0xFF963C-0xFFA144 --note 'After z80load.asm: the sound sequence engine (eight streams of MIDI-style events, timed note-offs,\nthe Z80 event queue, resource directories, bus access), its state and tables, then zeros to the end.\ndocs/segacd_main_shell.md.'

exit $fail
