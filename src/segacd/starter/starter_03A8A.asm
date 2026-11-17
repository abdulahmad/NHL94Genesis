RestoreBiosSub43	movem.l	d0-d7/a0-a6,-(sp)
	btst.b	#$2,$FFFF8024.w
	beq.w	.next
	bsr.w	.next2
	bsr.w	.next4
.next	addq.w	#$1,$10AE0.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.next2	btst.b	#$1,$10912.l
	beq.w	.next3
	bsr.w	ReleaseWordRam
	bset.b	#$0,$10912.l
	rts
.next3	bclr.b	#$0,$10912.l
	rts
.next4	btst.b	#$0,$10912.l
	beq.w	.ex
	bsr.w	TakeWordRam
.ex	rts
	dc.b	$4E,$75	; Nu
; Calls the $E320 command with an inline parameter block.
SendCmdE320Inline	movem.l	d0-d7/a0-a6,-(sp)
	movem.l	a1,-(sp)
	jsr	$E320.l
	dc.b	$00,$00,$FC,$00,$E0,$00,$C0,$00,$B0,$00,$00,$06,$00,$20,$00,$08	; ............. ..
	dc.b	$00,$00	; ..
RestoreBiosSub45	movem.l	(sp)+,a1
	bsr.w	SendCmd3
	move.l	#$4000400,-(sp)
	jsr	$10540.l
	move.w	#$1,d0
	bsr.w	WaitCountdown
	jsr	$1055C.l
	jsr	$EA76.l
	bsr.w	SubBiosCall1A
	jsr	$EA0C.l
	move.l	$EC92.l,d1
	beq.w	SubBootExit
	movem.l	d1,-(sp)
	move.w	$FFFF8004.w,$EC8E.l
	lea.l	$ECA2.l,a0
	move.w	#$10,d0
	jsr	$5F22.w
	move.w	#$0,d1
	move.w	#$96,d0
	jsr	$5F22.w
	jsr	$EA76.l
	bclr.b	#$2,$FFFF8024.w
	move.l	$602C.w,$ECB0.l
	moveq	#$1B,d0
	jsr	$E370.l
	jsr	$E3BC.l
	movem.l	(sp)+,d1
	movea.l	#$FF8000,a5
	move.w	#$0,$BC6E8.l
	jsr	$EA00.l
	move.l	#$EAE2,-(sp)
	move.l	#$0,-(sp)
	move.l	#$0,-(sp)
	move.l	#$E000,-(sp)
RestoreBiosSub47	move.l	#$0,-(sp)
	move.l	#$0,-(sp)
	move.l	$EC9E.l,-(sp)
	move.l	$EC9A.l,-(sp)
	move.l	d1,-(sp)
	move.w	#$0,-(sp)
	jsr	$ECB4.l
	adda.w	#$26,sp
	tst.w	d0
	bmi.w	SubBootHalt
; Retries the BIOS call at $E298 while the result stays negative.
SubBootRetry	jsr	$E298.l
	btst	#$7,d1
RestoreBiosSub48	bne.w	.next
	move.w	#$1,-(sp)
	jsr	$ECB4.l
	addq.l	#$2,sp
	tst.w	d0
	bge.b	SubBootRetry
.next	move.w	#$2,-(sp)
	jsr	$ECB4.l
	addq.l	#$2,sp
	jsr	$E3BC.l
	jsr	$E3F8.l
	jsr	$E3EE.l
	jsr	$E416.l
	lea.l	$ECA2.l,a0
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
; Restores all registers and returns from the boot sequence.
SubBootExit	movem.l	(sp)+,d0-d7/a0-a6
	rts
; Endless loop after a failed boot step.
SubBootHalt	bra.b	SubBootHalt
; Calls $E370 with function $1A.
SubBiosCall1A	moveq	#$1A,d0
	jsr	$E370.l
	rts
	dcb.b	$18,0
	dc.b	$01,$FF,'HOCKEY.SEG',$00,$00,$00,$00	; ..HOCKEY.SEG....
	dc.b	$00,$00	; ..
; Entry vector of the movie driver (bra to FilmSwitch). FilmOpen, FilmTask and FilmClose address the driver variables that follow relative to it.
FilmEntryVector	bra.w	FilmSwitch
; Long counter incremented by the first CD interrupt hook.
FilmIrqTicks	dc.b	$00,$00,$00,$00	; ....
; Second pointer saved by FilmSwitch from the caller.
FilmSavedArg2	dc.b	$00,$01,$00,$00	; ....
; First pointer saved by FilmSwitch from the caller.
FilmSavedArg1	dc.b	$00,$06,$00,$00	; ....
; Sector count of the running CD read (negative = error).
CdReadSectorsLeft	dc.b	$00,$00,$00,$00	; ....
; Destination address of the running CD read.
CdReadDest	dc.b	$00,$00,$00,$00	; ....
; Last minute/second/frame position seen by the CD interrupt hook.
CdReadLastMsf	dcb.b	$8,0
; Six longs saved by FilmSwitch (the caller pointers it installs).
FilmSavedVectors	dcb.b	$14,0
; Callback called by the first CD interrupt hook every tick (0 = none).
FilmTickCallback	dc.b	$00,$00,$00,$00	; ....
; State block of CdBiosReadSequence.
CdReadState	dcb.b	$A8,0
