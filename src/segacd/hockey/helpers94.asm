AttribAdjust						;An attribute under $32 becomes d0 / 2 + $19. Called from AttribRating,
	
	cmpi.w	#$32,d0
	bge.w	.ex
	asr.w	#$1,d0
	addi.w	#$19,d0
.ex	rts
	movem.w	d0-d1,-(sp)
	move.w	$17B80.l,d0
	sub.w	$0(a3),d0
	cmpi.w	#$1E,d0
	bgt.w	.next
	move.w	$17BA8.l,d1
	eor.w	d1,d0
	andi.w	#$8000,d0
	beq.w	.next
	move.w	$17B94.l,d0
	sub.w	$14(a3),d0
	cmpi.w	#$1E,d0
	bgt.w	.next
	move.w	$17BAA.l,d1
	eor.w	d1,d0
	andi.w	#$8000,d0
.next	movem.w	(sp)+,d0-d1
	rts	
ReadGoaliePulled						;Z clear when the team of a3 pulled its goalie ($26 of the team struct).
	
	movem.l	a1,-(sp)
	movea.l	#tmstruct,a1
	btst	#$6,$62(a3)
	beq.w	.next
	movea.l	#awtmstruct,a1
.next	tst.w	$28(a1)
	movem.l	(sp)+,a1
	rts
EndOneTimer						;End a one-timer for a3: bits cleared, onetimerplayer = -1, SetSPA
	
	
	movem.l	d0/a0,-(sp)
	bclr	#$3,$64(a3)
	bclr	#$5,$62(a3)
	bclr	#$1,$63(a3)
	clr.w	$17EC6.l
	st.b	$17EBC.l
	move.w	d1,-(sp)
	move.w	#$50C,d1
	jsr	(SetSPA).l
	tst.w	$34(a3)
	bpl.w	.next
	jsr	(assexit).l
	bra.w	.next2
.next	jsr	(Setplass).l
.next2	clr.w	$5A(a3)
	st.b	$5C(a3)
	move.w	(sp)+,d1
	movem.l	(sp)+,d0/a0
	rts
;	Team logo palettes, then LeadSong, ClearPenalties and the hot/cold icon.
;	New in 94. ROM-contiguous from TeamLogoPalettes through HotColdIcon.
