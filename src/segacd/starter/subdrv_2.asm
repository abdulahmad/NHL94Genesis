;	STARTER.BIN $3A8A-$3D93 (runtime $EA8A-$ED93).
;
;	The end of the sub CPU driver module, between cdcwait.asm and filmrun.asm: the frame callback,
;	RunStarterFilm (film operations 0, 1, 2 through StarterFilmEntry, which branches to filmrun.asm at $ED94),
;	the saved arguments and the DRVINIT block (with HOCKEY.SEG). docs/segacd_starter_driver.md.


WaitDriverFrames	equ	$E118
ReadStarterPad1	equ	$E298
SendMainCommand03	equ	$E310
SendMainCommand02Inline	equ	$E320
SendMainCommand	equ	$E370
ClearSubCommWords	equ	$E3BC
EnterTwoMegWordRamMode	equ	$E3EE
SyncMainFlag7	equ	$E3F8
WaitForSubWordRam	equ	$E416
GiveWordRamToMain	equ	$E430
EnterOneMegWordRamMode	equ	$EA00
FilmSwitchBody	equ	$ED94
X_ECA2	equ	$ECA2

	org	$EA8A

DriverFrameCallback
	movem.l	d0-d7/a0-a6,-(sp)
	btst.b	#$2,$FFFF8024.w
	beq.w	.LEAA0
	bsr.w	ReleaseDriverFrameWordRam
	bsr.w	ReclaimDriverFrameWordRam
.LEAA0
	addq.w	#$1,$10AE0.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ReleaseDriverFrameWordRam
	btst.b	#$1,$10912.l
	beq.w	.LEAC6
	bsr.w	GiveWordRamToMain
	bset.b	#$0,$10912.l
	rts
.LEAC6
	bclr.b	#$0,$10912.l
	rts
ReclaimDriverFrameWordRam
	btst.b	#$0,$10912.l
	beq.w	.LEAE0
	bsr.w	WaitForSubWordRam
.LEAE0
	rts
StarterFilmCallbackNoOp
	rts
RunStarterFilm
	movem.l	d0-d7/a0-a6,-(sp)
	movem.l	a1,-(sp)
	jsr	(SendMainCommand02Inline).l
	dc.w	$0000,$FC00,$E000,$C000,$B000,$0006,$0020,$0008
	dc.w	$0000
	movem.l	(sp)+,a1
	bsr.w	SendMainCommand03
	move.l	#$4000400,-(sp)
	jsr	$10540.l
	move.w	#$1,d0
	bsr.w	WaitDriverFrames
	jsr	$1055C.l
	jsr	$EA76.l
	bsr.w	PrepareMainFilmDisplay
	jsr	$EA0C.l
	move.l	$EC92.l,d1
	beq.w	.LEC78
	movem.l	d1,-(sp)
	move.w	$FFFF8004.w,$EC8E.l
	lea	(X_ECA2).l,a0
	move.w	#$10,d0
	jsr	$5F22.w
	move.w	#$0,d1
	move.w	#$96,d0
	jsr	$5F22.w
	jsr	$EA76.l
	bclr.b	#$2,$FFFF8024.w
	move.l	$602C.w,$ECB0.l
	moveq	#$1B,d0
	jsr	(SendMainCommand).l
	jsr	(ClearSubCommWords).l
	movem.l	(sp)+,d1
	movea.l	#$FF8000,a5
	move.w	#$0,$BC6E8.l
	jsr	(EnterOneMegWordRamMode).l
	move.l	#$EAE2,-(sp)
	move.l	#$0,-(sp)
	move.l	#$0,-(sp)
	move.l	#$E000,-(sp)
	move.l	#$0,-(sp)
	move.l	#$0,-(sp)
	move.l	$EC9E.l,-(sp)
	move.l	$EC9A.l,-(sp)
	move.l	d1,-(sp)
	move.w	#$0,-(sp)
	jsr	(StarterFilmEntry).l
	adda.w	#$26,sp
	tst.w	d0
	bmi.w	.LEC7E
.LEBE6
	jsr	(ReadStarterPad1).l
	btst	#$7,d1
	bne.w	.LEC04
	move.w	#$1,-(sp)
	jsr	(StarterFilmEntry).l
	addq.l	#$2,sp
	tst.w	d0
	bge.s	.LEBE6
.LEC04
	move.w	#$2,-(sp)
	jsr	(StarterFilmEntry).l
	addq.l	#$2,sp
	jsr	(ClearSubCommWords).l
	jsr	(SyncMainFlag7).l
	jsr	(EnterTwoMegWordRamMode).l
	jsr	(WaitForSubWordRam).l
	lea	(X_ECA2).l,a0
	move.w	#$10,d0
	jsr	$5F22.w
	move.w	$EC8E.l,d1
	andi.b	#$F8,d1
	ori.b	#$3,d1
	move.w	#$96,d0
	jsr	$5F22.w
	jsr	$EA76.l
	move.w	#$0,$BC6E8.l
	move.l	#$0,$BC6EC.l
	move.l	$ECB0.l,$602C.w
	bset.b	#$2,$FFFF8024.w
	bset.b	#$2,$FFFF8033.w
.LEC78
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.LEC7E
	bra.s	.LEC7E
PrepareMainFilmDisplay
	moveq	#$1A,d0
	jsr	(SendMainCommand).l
	rts
	dcb.b	24,0
	dc.w	$01FF
	dc.b	'HOCKEY.SEG'
	ori.b	#$0,d0
	dc.w	$0000
StarterFilmEntry
	bra.w	FilmSwitchBody
FilmFrameTicks
	ori.b	#$0,d0
FilmBuffer
	ori.b	#$0,d1
FilmBufferSize
	ori.b	#$0,d6
FilmReadCount
	ori.b	#$0,d0
FilmReadDest
	ori.b	#$0,d0
FilmReadSector
	ori.b	#$0,d0
	ori.b	#$0,d0
FilmDisplayArgs
	dcb.b	20,0
FilmCallback
	ori.b	#$0,d0
FilmReadError
	ori.b	#$0,d0
	ori.b	#$0,d0
FilmState
	dcb.b	160,0
