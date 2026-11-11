;	MAIN.BIN $371C-$381B (runtime $FF471C-$FF481B): the game shell's command table. Written by hand.
;
;	MainShellCommandLoop (mainstart.asm) calls ShellCommandTable[command - 1] for each command word the sub
;	CPU writes to $FF8020 (main CPU $A12020); MainShellVBlank does the same for $FF8026 ($A12026). The
;	pointers are runtime addresses: MAIN.BIN runs at $FF1000.
;
;	Each fragment assembles on its own, so the handlers (labels in their own files, hwread.asm included) are
;	equates here. docs/segacd_main_shell.md.

ClearVramByWord	equ	$FF496E
CopyWordRamToVram	equ	$FF49DA
CopyWordRamToCram	equ	$FF4A2E
TestZ80BusBitCommand	equ	$FF4A56
ClearByteAtAddressCommand	equ	$FF4A78
ClearWordAtAddressCommand	equ	$FF4A82
GiveSubWordRamCommand	equ	$FF4A8C
RunWordRamVdpDmaCommand	equ	$FF4A92
WriteVdpControlByteCommand	equ	$FF4B3C
WriteVdpControlWordCommand	equ	$FF4B48
WriteVdpControlLongCommand	equ	$FF4B54
WriteVdpDataByteCommand	equ	$FF4B60
WriteVdpDataWordCommand	equ	$FF4B6C
WriteVdpDataLongCommand	equ	$FF4B78
WritePad1DataCommand	equ	$FF4B84
WritePad2DataCommand	equ	$FF4B90
WritePad1CtrlCommand	equ	$FF4B9C
WritePad2CtrlCommand	equ	$FF4BA8
ReadPad1DataCommand	equ	$FF4BB4
ReadPad2DataCommand	equ	$FF4BC0
ReadVdpDataWordCommand	equ	$FF4BCC
ReadVdpDataLongCommand	equ	$FF4BD8
WriteZ80BusReqCommand	equ	$FF4BF0
ReadHvCounterCommand	equ	$FF4BFC
ReadHvCounterByteCommand	equ	$FF4C08
ReadByteAtAddressCommand	equ	$FF4C14
ReadWordAtAddressCommand	equ	$FF4C22
ReadLongAtAddressCommand	equ	$FF4C30
StepCramFadeCommand	equ	$FF4C3E
CopyVramByDmaCommand	equ	$FF4CAC
RunWordRamVdpDmaListCommand	equ	$FF4D38
FillVramFromWordRamCommand	equ	$FF4D8E
ClearAllVramCommand	equ	$FF4DE4
WriteVdpWordsFromWordRamCommand	equ	$FF4E02
WriteZ80ResetCommand	equ	$FF4E24
SoundOperation4Command	equ	$FF4E30
StartSoundSequenceCommand	equ	$FF4E5A
TickSoundSequenceCommand	equ	$FF4E84
EnterMainShellCProgram	equ	$FF4FC8
RunSubCommandAndRestartShell	equ	$FF500C
InstallSoundSequenceHInt	equ	$FF67E8
DisableShellHInt	equ	$FF680E
RestartMainShellCommandLoop	equ	$FF6818
InitSoundCommand	equ	$FF684A
InitSoundDriverCommand	equ	$FF688A
DetectFourWayPlayCommand	equ	$FF68AA
InstallMainShellVBlank	equ	$FF6916
InstallAcknowledgeVBlank	equ	$FF6924
EndVBlankCommandService	equ	$FF6932
WriteVBlankVdpControlLong	equ	$FF693C
WriteVBlankVdpDataWord	equ	$FF6948
WriteVBlankVdpDataLong	equ	$FF6954
StartVBlankSoundSequence	equ	$FF6960
WriteVBlankPad1Port	equ	$FF697C
WriteVBlankPad2Port	equ	$FF6988
ReadVBlankPad1Port	equ	$FF6994
ReadVBlankPad2Port	equ	$FF69A0
WriteVBlankVdpControlWord	equ	$FF69AC
SaveCramPaletteCommand	equ	$FF69B8
ShowWordRamScreenCommand	equ	$FF69E4
InstallMainShellOverlayCommand	equ	$FF6C86

	org	$FF471C

ShellCommandTable
	dc.l	ClearVramByWord			;$01
	dc.l	CopyWordRamToVram		;$02
	dc.l	CopyWordRamToCram		;$03
	dc.l	TestZ80BusBitCommand	;$04
	dc.l	ClearByteAtAddressCommand	;$05
	dc.l	ClearWordAtAddressCommand	;$06
	dc.l	GiveSubWordRamCommand	;$07
	dc.l	RunWordRamVdpDmaCommand	;$08
	dc.l	WriteVdpControlByteCommand	;$09
	dc.l	WriteVdpControlWordCommand	;$0A
	dc.l	WriteVdpControlLongCommand	;$0B
	dc.l	WriteVdpDataByteCommand	;$0C
	dc.l	WriteVdpDataWordCommand	;$0D
	dc.l	WriteVdpDataLongCommand	;$0E
	dc.l	WritePad1DataCommand	;$0F
	dc.l	WritePad2DataCommand	;$10
	dc.l	WritePad1CtrlCommand	;$11
	dc.l	WritePad2CtrlCommand	;$12
	dc.l	ReadPad1DataCommand		;$13
	dc.l	ReadPad2DataCommand		;$14
	dc.l	ReadVdpDataWordCommand	;$15
	dc.l	ReadVdpDataLongCommand	;$16
	dc.l	ReadByteAtAddressCommand	;$17
	dc.l	ReadWordAtAddressCommand	;$18
	dc.l	ReadLongAtAddressCommand	;$19
	dc.l	WriteZ80BusReqCommand	;$1A
	dc.l	ReadHvCounterCommand	;$1B
	dc.l	ReadHvCounterByteCommand	;$1C
	dc.l	StepCramFadeCommand		;$1D
	dc.l	CopyVramByDmaCommand	;$1E
	dc.l	FillVramFromWordRamCommand	;$1F
	dc.l	ClearAllVramCommand		;$20
	dc.l	WriteVdpWordsFromWordRamCommand	;$21
	dc.l	WriteZ80ResetCommand	;$22
	dc.l	SoundOperation4Command	;$23
	dc.l	TickSoundSequenceCommand	;$24
	dc.l	EnterMainShellCProgram	;$25
	dc.l	StartSoundSequenceCommand	;$26
	dc.l	InstallSoundSequenceHInt	;$27
	dc.l	RestartMainShellCommandLoop	;$28
	dc.l	InitSoundCommand		;$29
	dc.l	DisableShellHInt		;$2A
	dc.l	DetectFourWayPlayCommand	;$2B
	dc.l	RunWordRamVdpDmaListCommand	;$2C
	dc.l	InstallMainShellVBlank	;$2D
	dc.l	InstallAcknowledgeVBlank	;$2E
	dc.l	EndVBlankCommandService	;$2F
	dc.l	WriteVBlankVdpControlLong	;$30
	dc.l	WriteVBlankVdpDataWord	;$31
	dc.l	RunWordRamVdpDmaCommand	;$32
	dc.l	WriteVBlankVdpDataLong	;$33
	dc.l	StartVBlankSoundSequence	;$34
	dc.l	WriteVBlankPad2Port		;$35
	dc.l	WriteVBlankPad1Port		;$36
	dc.l	ReadVBlankPad1Port		;$37
	dc.l	ReadVBlankPad2Port		;$38
	dc.l	WriteVBlankVdpControlWord	;$39
	dc.l	CopyVramByDmaCommand	;$3A
	dc.l	FillVramFromWordRamCommand	;$3B
	dc.l	SaveCramPaletteCommand	;$3C
	dc.l	ShowWordRamScreenCommand	;$3D
	dc.l	RunSubCommandAndRestartShell	;$3E
	dc.l	InstallMainShellOverlayCommand	;$3F
	dc.l	InitSoundDriverCommand	;$40
