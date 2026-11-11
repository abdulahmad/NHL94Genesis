;	MAIN.BIN $381C-$3B3B (runtime $FF481C-$FF4B3B).
;
;	After ShellCommandTable (maintable.asm): the H and V interrupt handlers (MainShellVBlank serves the
;	second command channel), the start-up handshake, word RAM handover and the first command handlers.
;	hwread.asm follows (commands $09-$1C).


ReceiveSubWord	equ	$FF4678
ShellCommandTable	equ	$FF471C
DispatchSoundOperation	equ	$FF865C

	org	$FF481C

SoundSequenceHInt
	move.w	d0,-(sp)
	move.b	$C00008.l,d0
	cmpi.b	#$64,d0
	bcc.s	.LFF4834
	move.w	#$0,$FF6CF8.l
	bra.s	.LFF483C
.LFF4834
	tst.w	$FF6CF8.l
	beq.s	.LFF4840
.LFF483C
	move.w	(sp)+,d0
	rte
.LFF4840
	move.w	#$1,$FF6CF8.l
	move.w	#$1,d0
	bsr.w	DispatchSoundOperation
	move.w	(sp)+,d0
	rte
AcknowledgeMainVBlank
	bset.b	#$0,$A12000.l
	rte
MainShellVBlank
	movem.l	d0-d1/a0-a1,-(sp)
	bset.b	#$5,$A1200E.l
	bset.b	#$0,$A12000.l
	move.w	#$1,$FF6CFA.l
	move.l	#$32,d0
.LFF4880
	btst.b	#$2,$A1200F.l
	bne.s	.LFF48AE
	dbf	d0,.LFF4880
	bclr.b	#$5,$A1200E.l
	move.l	#$19,d0
.LFF489C
	btst.b	#$2,$A1200F.l
	bne.s	.LFF48AE
	dbf	d0,.LFF489C
	bra.w	.LFF490A
.LFF48AE
	btst.b	#$4,$A1200F.l
	bne.s	.LFF48AE
	btst.b	#$3,$A1200F.l
	beq.s	.LFF48AE
	bset.b	#$4,$A1200E.l
	move.w	$A12026.l,d0
	lsl.w	#$2,d0
	lea	(ShellCommandTable).l,a1
	movea.l	-$4(a1,d0.w),a0
	jsr	(a0)
	bset.b	#$3,$A1200E.l
.LFF48E6
	btst.b	#$3,$A1200F.l
	bne.s	.LFF48E6
	bclr.b	#$3,$A1200E.l
	bclr.b	#$4,$A1200E.l
	tst.w	$FF6CFA.l
	bne.w	.LFF48AE
.LFF490A
	bclr.b	#$5,$A1200E.l
	movem.l	(sp)+,d0-d1/a0-a1
	rte
SyncMainShellStartup
	btst.b	#$7,$A1200F.l
	bne.s	SyncMainShellStartup
.LFF4922
	btst.b	#$6,$A1200F.l
	bne.s	.LFF4922
	bset.b	#$6,$A1200E.l
.LFF4934
	btst.b	#$6,$A1200F.l
	beq.s	.LFF4934
	bset.b	#$7,$A1200E.l
	bclr.b	#$6,$A1200E.l
.LFF494E
	btst.b	#$6,$A1200F.l
	bne.s	.LFF494E
	bclr.b	#$7,$A1200E.l
	rts
WaitMainMemoryModeReady
	btst.b	#$2,$A12003.l
	bne.s	WaitMainMemoryModeReady
	rts
ClearVramByWord
	move.l	d0,-(sp)
	move.w	#$4000,$C00004.l
	move.w	#$0,$C00004.l
	move.l	#$8000,d0
.LFF4986
	move.w	#$0,$C00000.l
	dbf	d0,.LFF4986
	move.l	(sp)+,d0
	rts
WaitMainWordRam
	btst.b	#$1,$A12003.l
	bne.s	WaitMainWordRam
	rts
GiveSubWordRamAndWait
	bset.b	#$1,$A12003.l
.LFF49AA
	btst.b	#$0,$A12003.l
	bne.s	.LFF49AA
	rts
SetShellVramWriteAddress
	movem.w	d0,-(sp)
	andi.w	#$3FFF,d0
	ori.w	#$4000,d0
	move.w	d0,$C00004.l
	movem.w	(sp)+,d0
	rol.w	#$2,d0
	andi.w	#$3,d0
	move.w	d0,$C00004.l
	rts
CopyWordRamToVram
	movem.l	d0-d1/a0,-(sp)
	bsr.w	GiveSubWordRamAndWait
	bsr.w	WaitMainWordRam
	bsr.w	ReceiveSubWord
	move.w	d0,d1
	bsr.w	ReceiveSubWord
	bsr.w	SetShellVramWriteAddress
	lea	$200000.l,a0
.LFF49FA
	move.w	(a0)+,$C00000.l
	dbf	d1,.LFF49FA
	movem.l	(sp)+,d0-d1/a0
	rts
SetShellCramWriteAddress
	movem.w	d0,-(sp)
	andi.w	#$3FFF,d0
	ori.w	#$C000,d0
	move.w	d0,$C00004.l
	movem.w	(sp)+,d0
	rol.w	#$2,d0
	andi.w	#$3,d0
	move.w	d0,$C00004.l
	rts
CopyWordRamToCram
	bsr.w	GiveSubWordRamAndWait
	bsr.w	WaitMainWordRam
	bsr.w	ReceiveSubWord
	move.w	d0,d1
	bsr.w	ReceiveSubWord
	bsr.w	SetShellCramWriteAddress
	lea	$200000.l,a0
.LFF4A4A
	move.w	(a0)+,$C00000.l
	dbf	d1,.LFF4A4A
	rts
TestZ80BusBitCommand
	move.w	$A12022.l,d0
	move.w	#$0,$A12010.l
	btst.b	d0,$A11100.l
	bne.w	.LFF4A76
	move.w	#$4,$A12010.l
.LFF4A76
	rts
ClearByteAtAddressCommand
	movea.l	$A12022.l,a0
	clr.b	(a0)
	rts
ClearWordAtAddressCommand
	movea.l	$A12022.l,a0
	clr.w	(a0)
	rts
GiveSubWordRamCommand
	bsr.w	GiveSubWordRamAndWait
	rts
RunWordRamVdpDmaCommand
	bsr.w	WaitMainWordRam
	move.w	$23BC88.l,$C00004.l
	move.w	$23BC8A.l,$C00004.l
	move.w	$23BC8C.l,$C00004.l
	move.w	$23BC8E.l,$C00004.l
	move.w	$23BC90.l,$C00004.l
	move.w	$23BC92.l,$C00004.l
	move.w	$23BC94.l,$C00004.l
	lea	$C00004.l,a1
	move.l	$23BC9E.l,$FF6CE8.l
	move.w	$FF6CEA.l,(a1)
	move.w	$FF6CE8.l,(a1)
.LFF4AF8
	move.w	$C00004.l,-(sp)
	btst.b	#$1,$1(sp)
	addq.w	#$2,sp
	bne.w	.LFF4AF8
	move.w	#$8164,$C00004.l
	lea	$C00000.l,a1
	move.l	$23BC9A.l,d4
	asl.l	#$2,d4
	lsr.w	#$2,d4
	ori.w	#$4000,d4
	swap	d4
	andi.w	#$3,d4
	move.l	d4,$4(a1)
	move.l	$23BC96.l,(a1)
	bsr.w	GiveSubWordRamAndWait
	rts
