;	STARTER.BIN $5304-$54F5 (runtime $10304-$104F5).
;
;	The Sierra C run-time helpers after AudioBusy: 32-bit multiply ($10304) and the divide /
;	modulo entries with their jump table. No name tags here; cdfade.asm follows.


DispatchPcmCommandEntry	equ	$C4BC
StarterRandomRange	equ	$E488

	org	$10304

	move.l	$4(sp),d0
	move.l	$8(sp),d1
	move.l	d0,-(sp)
	mulu.w	d1,d0
	movea.l	d0,a0
	move.l	d1,d0
	mulu.w	(sp)+,d1
	clr.w	d0
	swap	d0
	beq.s	.L1031E
	mulu.w	(sp),d0
.L1031E
	addq.l	#$2,sp
	add.w	d1,d0
	swap	d0
	clr.w	d0
	add.l	a0,d0
	rts
	move.l	$4(sp),d1
	move.l	$8(sp),d0
	lea	.L1033E(pc),a0
	movea.w	#$2,a1
	dc.w	$4EF0,$92FE
.L1033E
	bra.s	.L10346
	dc.w	$4C41
	dc.w	$0801
	rts
.L10346
	jsr	.L1036C(pc)
	move.l	d1,d0
	rts
	move.l	$4(sp),d1
	move.l	$8(sp),d0
	lea	.L10362(pc),a0
	movea.w	#$2,a1
	dc.w	$4EF0,$92FE
.L10362
	bra.s	.L1036C
	dc.w	$4C41
	dc.w	$0801
	dc.w	$C340
	rts
.L1036C
	tst.l	d0
	bmi.s	.L10384
	tst.l	d1
	bmi.s	.L1037A
	jsr	.L103BC(pc)
	rts
.L1037A
	neg.l	d1
	jsr	.L103BC(pc)
	neg.l	d1
	rts
.L10384
	neg.l	d0
	tst.l	d1
	bmi.s	.L10394
	jsr	.L103BC(pc)
	neg.l	d0
	neg.l	d1
	rts
.L10394
	neg.l	d1
	jsr	.L103BC(pc)
	neg.l	d0
	rts
	move.l	$4(sp),d1
	move.l	$8(sp),d0
	lea	.L103B2(pc),a0
	movea.w	#$2,a1
	dc.w	$4EF0,$92FE
.L103B2
	bra.s	.L103BC
	dc.w	$4C41
	dc.w	$0001,$C340
	rts
.L103BC
	move.w	d1,-(sp)
	swap	d1
	tst.w	d1
	bne.s	.L103E0
	move.l	d0,d1
	clr.w	d1
	swap	d1
	beq.s	.L103D6
	divu.w	(sp),d1
	swap	d1
	swap	d0
	move.w	d1,d0
	swap	d0
.L103D6
	divu.w	(sp)+,d0
	move.w	d0,d1
	dc.b	'B@H@Nu'
.L103E0
	swap	d1
	move.w	d2,(sp)
	move.l	d3,-(sp)
	move.w	d0,d2
	move.l	d1,d3
	moveq	#$1,d1
	clr.w	d0
	swap	d0
	bne.s	.L103FE
	swap	d0
	move.w	d2,d0
	moveq	#$0,d1
	bra.s	.L10410
.L103FA
	add.w	d1,d1
	bcs.s	.L10410
.L103FE
	add.w	d2,d2
	addx.l	d0,d0
	cmp.l	d3,d0
	bcs.s	.L103FA
	sub.l	d3,d0
	add.w	d1,d1
	bset	#$0,d1
	bcc.s	.L103FE
.L10410
	move.l	(sp)+,d3
	move.w	(sp)+,d2
	rts
	bset.b	d2,(a2)
	dc.w	$0000,$48E7
	dc.w	$FFFE
	moveq	#$0,d0
	move.w	$40(sp),d2
	move.w	$42(sp),d1
	move.w	$44(sp),d0
	bmi.w	.L1045E
	move.w	d0,$10ADA.l
	cmpi.w	#$FFFF,d0
	beq.w	.L1045E
	cmpi.w	#$1,d0
	bge.w	.L1045E
	lea	(.L104EC).l,a0
	mulu.w	#$A,d0
	adda.l	d0,a0
	move.b	$0(a0),d0
	cmpi.b	#$2,d0
	beq.w	.L1046A
.L1045E
	movem.l	(sp)+,d0-d7/a0-a6
	move.l	(sp),$6(sp)
	addq.l	#$6,sp
	rts
.L1046A
	tst.w	d1
	bne.w	.L104BC
	tst.w	d2
	bne.w	.L104BC
	move.w	$4(a0),d0
	sub.w	$2(a0),d0
	beq.w	.L10488
	jsr	(StarterRandomRange).l
.L10488
	add.w	$2(a0),d0
	move.w	d0,d2
	moveq	#$0,d1
	move.b	$1(a0),d1
	move.w	$8(a0),d0
	sub.w	$6(a0),d0
	beq.w	.L104A6
	jsr	(StarterRandomRange).l
.L104A6
	add.w	$6(a0),d0
	move.w	d0,d3
	move.w	#$3,d0
	move.w	#$FFFF,d4
	jsr	(DispatchPcmCommandEntry).l
	bra.s	.L1045E
.L104BC
	move.w	d1,d3
	move.w	d2,d4
	move.w	$4(a0),d0
	sub.w	$2(a0),d0
	beq.w	.L104D2
	jsr	(StarterRandomRange).l
.L104D2
	add.w	$2(a0),d0
	move.w	d0,d2
	moveq	#$0,d1
	move.b	$1(a0),d1
	move.w	#$3,d0
	jsr	(DispatchPcmCommandEntry).l
	bra.w	.L1045E
.L104EC
	dc.w	$0200,$05A9
	bclr.b	d2,$FF(a1)
	dc.w	$00FF
