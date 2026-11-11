;	STARTER.BIN $4DDE-$4E25 (runtime $FDDE-$FE25).
;
;	CopyData (after SendCommandToMain in filmcmd.asm).


	org	$FDDE

CopyData
	link	a6,#$0
	movem.l	d4-d7,-(sp)
	move.l	$C(a6),d4
	move.l	$8(a6),d5
	move.l	$10(a6),d6
	move.l	d6,d0
	addq.l	#$3,d0
	asr.l	#$2,d0
	move.l	d0,d6
	moveq	#$0,d7
	bra.s	.LFE0C
.LFDFE
	movea.l	d5,a0
	addq.l	#$4,d5
	movea.l	d4,a1
	addq.l	#$4,d4
	move.l	(a0),(a1)
	move.l	d7,d0
	addq.l	#$1,d7
.LFE0C
	cmp.l	d7,d6
	bgt.s	.LFDFE
	movem.l	-$10(a6),d4-d7
	unlk	a6
	rts
	dc.b	$88,'CopyData',0,0,0
