;	MAIN.BIN $35A8-$371B (runtime $FF45A8-$FF471B).
;
;	The game shell: MainShellEntry (MAIN.BIN starts with a jmp here) sets the stack at $FFFC00, clears
;	the communication words and runs MainShellCommandLoop, which calls ShellCommandTable (maintable.asm,
;	next) for each command the sub CPU sends. docs/segacd_main_shell.md.


ShellCommandTable	equ	$FF471C
SyncMainShellStartup	equ	$FF4918
WaitMainMemoryModeReady	equ	$FF4962
GiveSubWordRamAndWait	equ	$FF49A2

	org	$FF45A8

MainShellEntry
	movea.l	#$FFFC00,sp
	move.w	#$0,$A12010.l
	move.w	#$0,$A12012.l
	move.w	#$0,$A12014.l
	move.w	#$0,$A12016.l
	move.w	#$0,$A12018.l
	move.w	#$0,$A1201A.l
	move.w	#$0,$A1201C.l
	move.w	#$0,$A1201E.l
	move.b	#$0,$A1200E.l
	move.w	#$0,$FF6CEE.l
	bsr.w	SyncMainShellStartup
	bsr.w	WaitMainMemoryModeReady
	bsr.w	GiveSubWordRamAndWait
	move.l	#$0,$FF6D00.l
	move.l	#$0,$FF6CFC.l
	bra.w	MainShellCommandLoop
MainShellCommandLoop
	btst.b	#$7,$A1200F.l
	bne.s	MainShellCommandLoop
	btst.b	#$6,$A1200F.l
	beq.s	MainShellCommandLoop
	bset.b	#$7,$A1200E.l
	move.w	$A12020.l,d0
	lsl.w	#$2,d0
	lea	(ShellCommandTable).l,a1
	movea.l	-$4(a1,d0.w),a0
	jsr	(a0)
	bset.b	#$6,$A1200E.l
.LFF465A
	btst.b	#$6,$A1200F.l
	bne.s	.LFF465A
	bclr.b	#$6,$A1200E.l
	bclr.b	#$7,$A1200E.l
	bra.w	MainShellCommandLoop
ReceiveSubWord
	btst.b	#$7,$A1200F.l
	bne.s	ReceiveSubWord
	btst.b	#$6,$A1200F.l
	beq.s	ReceiveSubWord
	bset.b	#$7,$A1200E.l
	move.w	$A12020.l,d0
	bset.b	#$6,$A1200E.l
.LFF46A2
	btst.b	#$6,$A1200F.l
	bne.s	.LFF46A2
	bclr.b	#$6,$A1200E.l
	bclr.b	#$7,$A1200E.l
	rts
SendMainWord
	btst.b	#$7,$A1200F.l
	bne.s	SendMainWord
	move.w	d0,$A12010.l
	bset.b	#$6,$A1200E.l
.LFF46D6
	btst.b	#$6,$A1200F.l
	beq.s	.LFF46D6
	bset.b	#$7,$A1200E.l
	bclr.b	#$6,$A1200E.l
.LFF46F0
	btst.b	#$6,$A1200F.l
	bne.s	.LFF46F0
	bclr.b	#$7,$A1200E.l
	rts
CallMainShellCommand
	movem.l	d0-d7/a0-a6,-(sp)
	lsl.w	#$2,d0
	lea	(ShellCommandTable).l,a1
	movea.l	-$4(a1,d0.w),a0
	jsr	(a0)
	movem.l	(sp)+,d0-d7/a0-a6
	rts
