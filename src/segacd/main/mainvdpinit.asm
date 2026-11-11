;	MAIN.BIN $57E8-$5E0B (runtime $FF67E8-$FF6E0B).
;
;	After the second copy of the C handlers and of the run-time (maincrt_2.asm): command handlers
;	$27-$40 (interrupt set-up, the sound driver, the four-way probe, the V interrupt channel, the screen
;	fades, the overlay at $FF1006). mainz80.asm (the Z80 sound image) follows.


MainShellCommandLoop	equ	$FF4622
SoundSequenceHInt	equ	$FF481C
AcknowledgeMainVBlank	equ	$FF4854
MainShellVBlank	equ	$FF485E
SyncMainShellStartup	equ	$FF4918
WaitMainWordRam	equ	$FF4996
GiveSubWordRamAndWait	equ	$FF49A2
ClearAllVramCommand	equ	$FF4DE4
Z80SoundImage	equ	$FF6E0C
DispatchSoundOperation	equ	$FF865C
SoundBank	equ	$FF963C
Z80SoundResourceList	equ	$FFA0C6
X_FF1006	equ	$FF1006
X_FF6AD4	equ	$FF6AD4
X_FF6D04	equ	$FF6D04
X_FF6D8C	equ	$FF6D8C

	org	$FF67E8

InstallSoundSequenceHInt
	lea	(SoundSequenceHInt).l,a0
	move.w	#$FFFF,$70.l
	move.w	a0,$A12006.l
	move.w	#$8A00,$C00004.l
	move.w	#$8014,$C00004.l
	rts
DisableShellHInt
	move.w	#$8004,$C00004.l
	rts
RestartMainShellCommandLoop
	bset.b	#$6,$A1200E.l
.LFF6820
	btst.b	#$6,$A1200F.l
	bne.s	.LFF6820
	bclr.b	#$6,$A1200E.l
	bclr.b	#$7,$A1200E.l
	jsr	(SyncMainShellStartup).l
	movea.l	#$FFFC00,sp
	bra.w	MainShellCommandLoop
InitSoundCommand
	move.w	#$0,d0
	lea	(Z80SoundImage).l,a0
	move.w	#$184F,d1
	movea.l	$A12022.l,a1
	bsr.w	DispatchSoundOperation
	lea	(SoundBank).l,a0
	move.w	#$0,d1
	move.w	#$6,d0
	bsr.w	DispatchSoundOperation
	lea	(Z80SoundResourceList).l,a0
	move.w	#$7,d0
	bsr.w	DispatchSoundOperation
	jsr	(InstallSoundSequenceHInt).l
	rts
InitSoundDriverCommand
	move.w	#$0,d0
	lea	(Z80SoundImage).l,a0
	move.w	#$184F,d1
	movea.l	$A12022.l,a1
	bsr.w	DispatchSoundOperation
	jsr	(InstallSoundSequenceHInt).l
	rts
DetectFourWayPlayCommand
	move.w	#$0,$A11200.l
	move.b	#$40,$A10009.l
	move.b	#$43,$A1000B.l
	nop
	move.b	#$7C,$A10005.l
	nop
	move.b	#$7F,$A1000B.l
	nop
	move.b	#$7C,$A10005.l
	nop
	move.b	$A10003.l,d0
	andi.b	#$3,d0
	cmpi.b	#$0,d0
	bne.s	.LFF68FC
	move.w	#$1,$A12010.l
	bra.s	.LFF690C
.LFF68FC
	move.w	#$0,$A12010.l
	move.b	#$40,$A1000B.l
.LFF690C
	move.w	#$100,$A11200.l
	rts
InstallMainShellVBlank
	lea	(MainShellVBlank).l,a0
	move.l	a0,$FFFD08.l
	rts
InstallAcknowledgeVBlank
	lea	(AcknowledgeMainVBlank).l,a0
	move.l	a0,$FFFD08.l
	rts
EndVBlankCommandService
	move.w	#$0,$FF6CFA.l
	rts
WriteVBlankVdpControlLong
	move.l	$A12028.l,$C00004.l
	rts
WriteVBlankVdpDataWord
	move.w	$A12028.l,$C00000.l
	rts
WriteVBlankVdpDataLong
	move.l	$A12028.l,$C00000.l
	rts
StartVBlankSoundSequence
	move.w	sr,-(sp)
	move.w	#$2700,sr
	move.w	#$2,d0
	move.w	$A12028.l,d1
	move.w	#$100,d4
	bsr.w	DispatchSoundOperation
	move.w	(sp)+,sr
	rts
WriteVBlankPad1Port
	move.b	$A12028.l,$A10003.l
	rts
WriteVBlankPad2Port
	move.b	$A12028.l,$A10005.l
	rts
ReadVBlankPad1Port
	move.b	$A10003.l,$A12018.l
	rts
ReadVBlankPad2Port
	move.b	$A10005.l,$A12018.l
	rts
WriteVBlankVdpControlWord
	move.w	$A12028.l,$C00004.l
	rts
SaveCramPaletteCommand
	move.w	sr,-(sp)
	move.w	#$2700,sr
	movea.l	#$C00000,a0
	move.l	#$20,$C00004.l
	move.l	#$3F,d0
	lea	(X_FF6D04).l,a1
.LFF69DA
	move.w	(a0),(a1)+
	dbf	d0,.LFF69DA
	move.w	(sp)+,sr
	rts
ShowWordRamScreenCommand
	tst.w	$FF6D84.l
	bne.w	.LFF69F8
	move.w	#$1,$FF6D84.l
	rts
.LFF69F8
	movem.l	d0-d7/a0-a2,-(sp)
	st.b	$FF6D8A.l
	bsr.w	InstallScreenFadeVBlank
	lea	X_FF6D8C(pc),a0
	moveq	#$3F,d1
.LFF6A0C
	move.w	#$0,(a0)+
	dbf	d1,.LFF6A0C
	move.w	#$18,$FF6D8A.l
.LFF6A1C
	tst.w	$FF6D8A.l
	bpl.w	.LFF6A1C
	bsr.w	ClearAllVramCommand
	bsr.w	X_FF6AD4
	movea.l	#$C00000,a0
	move.w	#$8C81,$4(a0)
	move.w	#$9001,$4(a0)
	move.w	#$8230,$4(a0)
	move.w	#$8406,$4(a0)
	movea.l	$FF6D86.l,a1
	move.w	$2(a1),d0
	lsl.w	#$4,d0
	move.w	d0,d2
	move.w	#$20,d1
	move.w	d1,d5
	lsr.w	#$5,d5
	lea	$4(a1),a0
	jsr	(DmaScreenTilesToVram).l
	add.w	d2,d2
	lea	$4(a1,d2.w),a0
	lea	X_FF6D8C(pc),a1
	moveq	#$1F,d0
.LFF6A78
	move.l	(a0)+,(a1)+
	dbf	d0,.LFF6A78
	move.w	(a0)+,d1
	move.w	(a0)+,d2
	dc.b	'$HSASB6'
	dc.b	$01
	move.w	#$80,d7
	moveq	#$0,d4
	move.w	#$C000,d4
.LFF6A94
	move.l	d4,d0
	bsr.w	SetScreenVramWriteAddress
.LFF6A9A
	move.w	(a2)+,d6
	add.w	d5,d6
	move.w	d6,(a0)
	dbf	d1,.LFF6A9A
	move.w	d3,d1
	add.w	d7,d4
	dbf	d2,.LFF6A94
	move.w	#$18,$FF6D8A.l
.LFF6AB4
	tst.w	$FF6D8A.l
	bpl.w	.LFF6AB4
	bsr.w	InstallMainShellVBlank
	movem.l	(sp)+,d0-d7/a0-a2
	rts
InstallScreenFadeVBlank
	lea	ScreenFadeVBlank(pc),a0
	move.l	a0,$FFFD08.l
	rts
	movea.l	#$C00000,a1
	move.l	#$27,d0
	move.l	#$40000010,$4(a1)
.LFF6AE8
	move.w	#$0,(a1)
	dbf	d0,.LFF6AE8
	rts
SetScreenVramWriteAddress
	movea.l	#$C00000,a0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	ori.w	#$4000,d0
	swap	d0
	andi.w	#$3,d0
	move.l	d0,$4(a0)
	rts
ScreenFadeVBlank
	movem.l	d0-d7/a0-a4,-(sp)
	tst.w	$FF6D8A.l
	bmi.w	.LFF6BA4
	cmpi.w	#$64,$FF6D8A.l
	beq.w	.LFF6BAA
	subq.w	#$1,$FF6D8A.l
	bmi.w	.LFF6BA4
	clr.l	d0
	move.w	$FF6D8A.l,d0
	cmpi.w	#$18,d0
	bgt.w	.LFF6BA4
	divu.w	#$3,d0
	swap	d0
	asl.w	#$2,d0
	moveq	#$2,d3
	asl.w	d0,d3
	moveq	#$E,d5
	asl.w	d0,d5
	move.w	d5,d4
	not.w	d4
	lea	X_FF6D8C(pc),a1
	movea.l	#$C00000,a0
	clr.w	d6
.LFF6B60
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
	beq.w	.LFF6B9A
	blt.w	.LFF6B84
	neg.w	d2
.LFF6B84
	add.w	d2,d0
	and.w	d4,d7
	or.w	d0,d7
	move.l	#$C000,d0
	move.b	d6,d0
	swap	d0
	move.l	d0,$4(a0)
	move.w	d7,(a0)
.LFF6B9A
	addq.w	#$2,d6
	cmpi.w	#$80,d6
	bne.w	.LFF6B60
.LFF6BA4
	movem.l	(sp)+,d0-d7/a0-a4
	rte
.LFF6BAA
	lea	(X_FF6D8C).l,a1
	movea.l	#$C00000,a0
	move.l	#$C0000000,$4(a0)
	moveq	#$1F,d0
.LFF6BC0
	move.l	(a1)+,(a0)
	dbf	d0,.LFF6BC0
	st.b	$FF6D8A.l
	bra.w	.LFF6BA4
DmaScreenTilesToVram
	movem.l	d2-d7/a1-a2,-(sp)
	moveq	#$0,d7
	lea	$C00004.l,a1
	move.w	#$8154,(a1)
	move.w	#$8F02,(a1)
	move.w	#$9300,d2
	move.b	d0,d2
	move.w	d2,(a1)
	move.w	#$9400,d2
	lsr.w	#$8,d0
	move.b	d0,d2
	move.w	d2,(a1)
	cmpa.l	#$240000,a0
	ble.w	.LFF6C04
	bra.w	.LFF6C10
.LFF6C04
	moveq	#$1,d7
	move.w	d1,d6
	move.l	(a0),d5
	adda.l	#$2,a0
.LFF6C10
	move.l	a0,d0
	lsr.l	#$1,d0
	move.w	#$9500,d2
	move.b	d0,d2
	move.w	d2,(a1)
	lsr.l	#$8,d0
	move.w	#$9600,d2
	move.b	d0,d2
	move.w	d2,(a1)
	lsr.l	#$8,d0
	andi.b	#$7F,d0
	move.w	#$9700,d2
	move.b	d0,d2
	move.w	d2,(a1)
	clr.l	d0
	move.w	d1,d0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	move.l	d0,d3
	ori.l	#$804000,d0
	move.l	d0,$FF6CE8.l
	move.w	$FF6CEA.l,(a1)
	move.w	$FF6CE8.l,(a1)
.LFF6C56
	move.w	$C00004.l,-(sp)
	btst.b	#$1,$1(sp)
	addq.w	#$2,sp
	bne.w	.LFF6C56
	move.w	#$8164,$C00004.l
	tst.w	d7
	beq.w	.LFF6C80
	moveq	#$0,d0
	move.w	d6,d0
	bsr.w	SetScreenVramWriteAddress
	move.l	d5,(a0)
.LFF6C80
	movem.l	(sp)+,d2-d7/a1-a2
	rts
InstallMainShellOverlayCommand
	bsr.w	WaitMainWordRam
	movea.l	#$C00004,a0
	move.w	#$8B00,(a0)
	move.w	#$9100,(a0)
	move.w	#$9200,(a0)
	move.w	#$8578,(a0)
	move.w	#$8D3D,(a0)
	movea.l	#$200000,a0
	move.l	a0,$FF6D86.l
	move.w	#$1,$FF6D84.l
	bsr.w	ShowWordRamScreenCommand
	lea	X_FF1006(pc),a1
	movea.l	#$205BC8,a0
	move.l	#$C5A,d0
.LFF6CCC
	move.l	(a0)+,(a1)+
	dbf	d0,.LFF6CCC
	move.l	#$FF1006,$FF6D86.l
	bsr.w	GiveSubWordRamAndWait
	clr.w	$FF6D84.l
	rts
	ori.b	#$0,d0
	ori.b	#$0,d0
	ori.b	#$0,d0
	dc.w	$0000,$FFFF
	ori.b	#$0,d0
	ori.b	#$0,d0
	ori.b	#$0,d0
	dcb.b	136,0
	dcb.b	128,0
