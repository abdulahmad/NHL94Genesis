; Saves the BIOS call arguments in d0-d3 to the call block
SetupBiosCallArgs	move.w	sr,-(sp)
	move.w	d0,$EC90.l
	move.l	d1,$EC92.l
	move.l	d2,$EC96.l
	move.l	d3,$EC9A.l
	move.l	d4,$EC9E.l
	jsr	$E3BC.l
	jsr	$E3F8.l
	jsr	$E3EE.l
	jsr	$E416.l
	move.w	#$0,$BC6E8.l
	move.w	#$2000,sr
	bclr.b	#$2,$FFFF8024.w
	jsr	$E454.l
	bset.b	#$2,$FFFF8024.w
	jsr	$E440.l
	move.w	#$0,d0
	jsr	$C4BC.l
	move.l	#$400,-(sp)
	jsr	$10540.l
	jsr	$D8F8.l
	bclr.b	#$2,$FFFF8024.w
	moveq	#$1E,d0
	jsr	$E370.l
	move.w	#$2700,sr
	movea.l	$EC96.l,a0
	move.l	$10ACC.l,(a0)
	bsr.w	ClearCommRegs
	move.w	(sp)+,sr
	rts
	move.w	#$0,$BC6E8.l
	bsr.w	.next
	bsr.w	LoadBootImages
	bsr.w	NopReturn
	bsr.w	CdStopMusic
	move.l	#$400,-(sp)
	bsr.w	CdSetFader
	bsr.w	SendCmd5
	bsr.w	ScreenSetupA
	bsr.w	ScreenSetupB
	bsr.w	SendCmdE320Inline
	move.w	$EC90.l,-(sp)
	bsr.w	CdPlayTrackRepeat
	move.l	#$4000200,-(sp)
	bsr.w	CdSetFader
	bsr.w	.next
	bsr.w	ScreenSetupC
	bsr.w	ClearCmdBuffer
	rts
.next	movem.l	d0-d7/a0-a6,-(sp)
	bclr.b	#$2,$FFFF8024.w
	lea.l	$80000.l,a0
	move.l	a0,$10984.l
	lea.l	$10BD8.l,a1
	lea.l	$15246.l,a2
	bsr.w	.loop
	move.l	a0,$1094C.l
	lea.l	$15246.l,a1
	lea.l	$15942.l,a2
	bsr.w	.loop
	move.l	a0,$109D8.l
	lea.l	$15942.l,a1
	lea.l	$16C62.l,a2
	bsr.w	.loop
	move.l	a0,$109DC.l
	lea.l	$16C62.l,a1
	lea.l	$17402.l,a2
	bsr.w	.loop
	move.l	a0,$109E0.l
	lea.l	$17402.l,a1
	lea.l	$1756C.l,a2
	bsr.w	.loop
	move.l	a0,$10BD0.l
	bset.b	#$2,$FFFF8024.w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.loop	move.b	(a1)+,(a0)+
	cmpa.l	a2,a1
	blt.b	.loop
; Bare rts target
RtsStub	rts