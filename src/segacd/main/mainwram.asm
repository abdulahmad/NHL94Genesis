;	MAIN.BIN $3C3E-$40CF (runtime $FF4C3E-$FF50CF).
;
;	After hwread.asm: command handlers $1D-$26, $2C and $3E (palette fade, VRAM copy and fill by DMA,
;	the sound commands), the pad poll, the way into the shell C program. The second copy of maindisp.asm
;	(main/maindisp_2.asm) follows.


MainShellEntry	equ	$FF45A8
WaitMainWordRam	equ	$FF4996
GiveSubWordRamAndWait	equ	$FF49A2
DisableShellHInt	equ	$FF680E
DispatchSoundOperation	equ	$FF865C
X_FF1006	equ	$FF1006
X_FF4E76	equ	$FF4E76
X_FF4EC2	equ	$FF4EC2
X_FF5040	equ	$FF5040
X_FF50D0	equ	$FF50D0

	org	$FF4C3E

StepCramFadeCommand
	bsr.w	WaitMainWordRam
	move.l	$23BC88.l,d3
	move.l	$23BC8C.l,d4
	move.l	$23BC90.l,d5
	movea.l	#$23BCB0,a1
	movea.l	#$C00000,a0
	clr.w	d6
.LFF4C62
	move.w	d3,d2
	move.w	d6,d0
	swap	d0
	move.w	#$20,d0
	move.l	d0,$4(a0)
	move.w	(a0),d7
	move.w	d7,d0
	and.w	d5,d0
	move.w	(a1)+,d1
	and.w	d5,d1
	cmp.w	d1,d0
	beq.w	.LFF4C9C
	blt.w	.LFF4C86
	neg.w	d2
.LFF4C86
	add.w	d2,d0
	and.w	d4,d7
	or.w	d0,d7
	move.l	#$C000,d0
	move.b	d6,d0
	swap	d0
	move.l	d0,$4(a0)
	move.w	d7,(a0)
.LFF4C9C
	addq.w	#$2,d6
	cmpi.w	#$80,d6
	bne.w	.LFF4C62
	bsr.w	GiveSubWordRamAndWait
	rts
CopyVramByDmaCommand
	bsr.w	WaitMainWordRam
	move.l	$23BC88.l,d0
	move.l	$23BC8C.l,d1
	move.l	$23BC90.l,d2
	lea	$C00004.l,a1
	move.w	#$8154,(a1)
	move.w	#$8F01,(a1)
	move.w	#$9300,d3
	move.b	d0,d3
	move.w	d3,(a1)
	move.w	#$9400,d3
	lsr.w	#$8,d0
	move.b	d0,d3
	move.w	d3,(a1)
	move.w	#$9500,d3
	move.b	d2,d3
	move.w	d3,(a1)
	move.w	#$9600,d3
	lsr.w	#$8,d2
	move.b	d2,d3
	move.w	d3,(a1)
	move.w	#$97C0,(a1)
	clr.l	d0
	move.w	d1,d0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	swap	d0
	ori.w	#$C0,d0
	move.l	d0,$FF6CE8.l
	move.w	$FF6CE8.l,(a1)
	move.w	$FF6CEA.l,(a1)
.LFF4D18
	move.w	$C00004.l,-(sp)
	btst.b	#$1,$1(sp)
	addq.w	#$2,sp
	bne.w	.LFF4D18
	move.w	#$8164,(a1)
	move.w	#$8F02,(a1)
	bsr.w	GiveSubWordRamAndWait
	rts
RunWordRamVdpDmaListCommand
	bsr.w	WaitMainWordRam
	lea	$C00004.l,a1
	movea.l	#$23C000,a0
	move.w	(a0)+,d0
	move.w	(a0)+,(a1)
.LFF4D4C
	move.w	(a0)+,(a1)
	move.w	(a0)+,(a1)
	move.w	(a0)+,(a1)
	move.w	(a0)+,(a1)
	move.w	(a0)+,(a1)
	move.w	(a0)+,(a1)
	move.l	(a0)+,$FF6CE8.l
	move.w	$FF6CE8.l,(a1)
	move.w	$FF6CEA.l,(a1)
.LFF4D6A
	move.w	$C00004.l,-(sp)
	btst.b	#$1,$1(sp)
	addq.w	#$2,sp
	bne.w	.LFF4D6A
	move.w	#$8164,(a1)
	dbf	d0,.LFF4D4C
	move.w	#$8F02,(a1)
	bsr.w	GiveSubWordRamAndWait
	rts
FillVramFromWordRamCommand
	bsr.w	WaitMainWordRam
	move.l	$23BC88.l,d0
	move.l	$23BC8C.l,d1
	move.l	$23BC90.l,d2
	movea.l	#$C00000,a1
	andi.l	#$FFFF,d1
	asl.l	#$2,d1
	lsr.w	#$2,d1
	ori.w	#$4000,d1
	swap	d1
	move.l	d1,$4(a1)
	move.w	d2,d3
	swap	d3
	move.w	d2,d3
	lsr.w	#$1,d0
	subq.w	#$1,d0
.LFF4DC8
	move.l	d3,$FF6CE8.l
	move.w	$FF6CE8.l,(a1)
	move.w	$FF6CEA.l,(a1)
	dbf	d0,.LFF4DC8
	bsr.w	GiveSubWordRamAndWait
	rts
ClearAllVramCommand
	move.l	#$40000000,$C00004.l
	move.w	#$3FFF,d0
	movea.l	#$C00000,a0
	clr.l	d1
.LFF4DFA
	move.l	d1,(a0)
	dbf	d0,.LFF4DFA
	rts
WriteVdpWordsFromWordRamCommand
	bsr.w	WaitMainWordRam
	lea	$C00000.l,a0
	lea	$23C002.l,a1
	move.w	$23C000.l,d0
.LFF4E18
	move.w	(a1)+,(a0)
	dbf	d0,.LFF4E18
	bsr.w	GiveSubWordRamAndWait
	rts
WriteZ80ResetCommand
	move.w	$A12022.l,$A11200.l
	rts
SoundOperation4Command
	tst.w	$FF6CF8.l
	bne.w	.LFF4E58
	moveq	#$0,d1
	move.w	$A12022.l,d1
	move.l	d1,d0
	asl.w	#$1,d0
	lea	(X_FF4E76).l,a0
	adda.l	d0,a0
	move.w	(a0),d2
	move.w	#$4,d0
	bsr.w	DispatchSoundOperation
.LFF4E58
	rts
StartSoundSequenceCommand
	move.w	sr,-(sp)
	move.w	#$2700,sr
	move.w	#$2,d0
	move.w	$A12022.l,d1
	move.w	#$100,d4
	bsr.w	DispatchSoundOperation
	move.w	(sp)+,sr
	rts
	ori.b	#$6B,d0
	ori.w	#$75,$7C(a2)
	dc.w	$0073
	dc.w	$0074
TickSoundSequenceCommand
	move.w	#$1,d0
	bsr.w	DispatchSoundOperation
	rts
PollShellPads
	movem.l	d1/a0,-(sp)
	bsr.w	ReadShellPad1
	move.b	d0,$FF4F84.l
	bsr.w	ReadShellPad2
	move.b	d0,$FF4F85.l
	movem.l	(sp)+,d1/a0
	rts
ReadShellPad2
	movem.l	d1/a0,-(sp)
	lea	$A10005.l,a0
	bra.s	X_FF4EC2
ReadShellPad1
	movem.l	d1/a0,-(sp)
	lea	$A10003.l,a0
	moveq	#$0,d0
	move.b	#$0,(a0)
	nop
	nop
	move.b	(a0),d0
	move.b	#$40,(a0)
	nop
	nop
	move.b	(a0),d1
	asl.b	#$2,d0
	andi.b	#$C0,d0
	andi.b	#$3F,d1
	or.b	d1,d0
	not.b	d0
	not.b	d1
	andi.w	#$F,d1
	lea	.LFF4F00(pc),a0
	andi.b	#$F0,d0
	or.b	(a0,d1.w),d0
	not.b	d0
	movem.l	(sp)+,d1/a0
	rts
.LFF4F00
	dc.w	$0001,$0201
	dc.w	$0405,$0606
	dc.w	$0809
	dc.w	$0A0A
	dc.w	$0809
	dc.w	$0A00
.LFF4F10
	move.b	$FF4F84.l,d0
	bsr.w	.LFF4F4C
	move.w	$FF4F7C.l,d2
	move.w	d1,$FF4F7C.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
.LFF4F2E
	move.b	$FF4F85.l,d0
	bsr.w	.LFF4F4C
	move.w	$FF4F7E.l,d2
	move.w	d1,$FF4F7E.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
.LFF4F4C
	not.b	d0
	clr.w	d1
	move.b	d0,d1
	move.w	d1,-(sp)
	andi.w	#$F0,d0
	andi.w	#$F,d1
	lea	(.LFF4F6C).l,a0
	move.b	(a0,d1.w),d1
	or.w	d1,d0
	move.w	(sp)+,d1
	rts
.LFF4F6C
	dc.w	$0800
	dc.w	$0408
	dc.w	$0607,$0508
	dc.w	$0201,$0308
	dc.w	$0808
	dc.w	$0808
	ori.b	#$0,d0
	ori.b	#$0,d0
	ori.b	#$0,d0
	movem.l	d0-d7/a0-a6,-(sp)
	btst.b	#$0,$A1200F.l
	beq.w	.LFF4FC0
	bclr.b	#$1,$A1200E.l
	bsr.w	PollShellPads
	bsr.w	.LFF4F10
	move.w	d1,d5
	bsr.w	.LFF4F2E
	or.w	d1,d5
	cmpi.b	#$80,d5
	bne.w	.LFF4FC0
	bset.b	#$1,$A1200E.l
.LFF4FC0
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	rte
EnterMainShellCProgram
	bset.b	#$6,$A1200E.l
.LFF4FD0
	btst.b	#$6,$A1200F.l
	bne.s	.LFF4FD0
	bclr.b	#$6,$A1200E.l
	bclr.b	#$7,$A1200E.l
	move.b	#$0,$A1200E.l
	bsr.w	DisableShellHInt
	move.l	#$FF4F88,-(sp)
	bsr.w	X_FF5040
	adda.l	#$4,sp
	bra.w	MainShellEntry
	rts
RunSubCommandAndRestartShell
	bset.b	#$6,$A1200E.l
.LFF5014
	btst.b	#$6,$A1200F.l
	bne.s	.LFF5014
	bclr.b	#$6,$A1200E.l
	bclr.b	#$7,$A1200E.l
	move.b	#$0,$A1200E.l
	bsr.w	X_FF1006
	bra.w	MainShellEntry
	rts
	bra.w	X_FF50D0
	dcb.b	140,0
