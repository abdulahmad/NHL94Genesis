; PLAYER.BIN career-stat printer, $2010-$23CF.
; Regular/Playoff headers, then up to 7 linked season rows.
; End of a list is the word $656C or $656E at offset 4.
; See docs/segacd_stats.md.



LF64_12	movem.l	d0-d7/a0-a5,-(sp)
	move.l	$44(a6),d0
	beq.w	LF64_14
	movea.l	d0,a2
	move.w	#$1C3,-(sp)
	move.w	#$14B,-(sp)
	moveq	#$1,d5
.l2028	moveq	#$0,d1
	move.w	(a2),d1
	lea.l	(a2,d1.w),a2
	movea.l	a2,a0
	adda.l	#$5,a0
	cmpi.w	#$1,d5
	bne.w	.l204A
	move.b	(a0),$B7(a6)
	adda.l	#$2,a0
.l204A	move.w	(sp)+,d0
	move.w	#$1D,d1
	bsr.w	LF64_38
	dbra	d5,.l2028
	moveq	#$0,d1
	move.w	(a2),d1
	lea.l	(a2,d1.w),a2
	movea.l	a2,a0
	adda.l	#$5,a0
	movea.l	$8E(a6),a1
	move.b	(a0)+,(a1)+
	move.b	(a0)+,(a1)+
	move.b	(a0)+,(a1)+
	move.b	#$20,(a1)+
.l2076	cmpi.b	#$20,(a0)+
	bne.w	.l2076
.l207E	move.b	(a0)+,(a1)+
	bne.w	.l207E
	movea.l	$8E(a6),a0
	move.w	#$1EB,d0
	move.w	#$1D,d1
	bsr.w	LF64_38
	moveq	#$3,d5
.l2096	move.w	(a2),d1
	lea.l	(a2,d1.w),a2
	dbra	d5,.l2096
	movea.l	a2,a3
	moveq	#$0,d0
	moveq	#$0,d3
.l20A6	move.b	$5(a3),d1
	sub.b	$4(a3),d1
	cmp.b	d1,d0
	bgt.w	.l20B6
	move.b	d1,d0
.l20B6	move.w	(a3),d3
	lea.l	(a3,d3.w),a3
	cmpi.w	#$656C,$4(a3)
	beq.w	.l20D0
	cmpi.w	#$656E,$4(a3)
	bne.w	.l20A6
.l20D0	movea.l	$9E(a6),a0
	cmpi.b	#$A,d0
	bge.w	.l20E0
	move.b	#$A,d0
.l20E0	subq.b	#$1,d0
	move.b	d0,$1(a0)
	moveq	#$0,d1
	move.b	(a0)+,d1
	add.b	(a0)+,d1
	add.b	(a0),d1
	divs.w	#$4,d1
	move.b	d1,$B6(a6)
	swap	d1
	tst.w	d1
	beq.w	.l2104
	addi.b	#$1,$B6(a6)
.l2104	move.w	#$9,$B8(a6)
	bsr.w	LF64_2
	movea.l	$9E(a6),a0
	moveq	#$F,d3
	add.b	$1(a0),d3
	add.w	d3,d3
	addi.l	#$B682,d3
	move.l	d3,d2
	lsl.l	#$2,d2
	lsr.w	#$2,d2
	swap	d2
	addi.l	#$40000000,d2
.l212E	btst.b	#$7,$FF800E.l
	bne.b	.l212E
	move.l	d2,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.l214E	btst.b	#$6,$FF800E.l
	beq.b	.l214E
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l2168	btst.b	#$6,$FF800E.l
	bne.b	.l2168
	bclr.b	#$7,$FF800F.l
	lea.l	LF64_49(pc),a0
	move.w	$A6(a6),d1
	cmp.w	$58(a6),d1
	bge.w	.l218E
	lea.l	LF64_50(pc),a0
.l218E	movea.l	$8E(a6),a5
	move.w	#$7,d1
	bsr.w	LF64_39
	move.l	#$B702,d3
	movea.l	$9A(a6),a0
	movea.l	$9E(a6),a1
	move.l	d3,d2
	lsl.l	#$2,d2
	lsr.w	#$2,d2
	swap	d2
	addi.l	#$40000000,d2
.l21B6	btst.b	#$7,$FF800E.l
	bne.b	.l21B6
	move.l	d2,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.l21D6	btst.b	#$6,$FF800E.l
	beq.b	.l21D6
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l21F0	btst.b	#$6,$FF800E.l
	bne.b	.l21F0
	bclr.b	#$7,$FF800F.l
	moveq	#$2,d5
	moveq	#$0,d1
	movea.l	$8E(a6),a5
.l220A	moveq	#$0,d1
	move.b	(a1)+,d1
	bsr.w	LF64_39
	dbra	d5,.l220A
	move.w	#$0,$B4(a6)
	movea.l	$8E(a6),a4
.l2220	tst.b	(a4)+
	bne.w	.l2220
	move.b	#$20,-$1(a4)
	movea.l	$8E(a6),a4
	bsr.w	LF64_4
	move.w	#$2,$B4(a6)
	cmpi.w	#$0,$58(a6)
	beq.w	.l225A
	move.w	$58(a6),d5
	subq.w	#$1,d5
.l224A	tst.b	(a0)+
	bne.w	.l224A
	adda.l	#$1,a1
	dbra	d5,.l224A
.l225A	move.l	a1,$FE(a6)
	moveq	#$2,d5
	moveq	#$0,d1
	movea.l	$8E(a6),a5
.l2266	moveq	#$0,d1
	move.b	(a1)+,d1
	bsr.w	LF64_39
	dbra	d5,.l2266
LF64_13	move.w	$56(a6),d6
	beq.w	.l22C8
	subq.w	#$1,d6
	movea.l	a2,a0
.l227E	move.w	(a0),d5
	lea.l	(a0,d5.w),a0
	addi.w	#$80,d3
	cmpi.w	#$656C,$4(a0)
	beq.w	LF64_15
	cmpi.w	#$656E,$4(a0)
	beq.w	LF64_15
	dbra	d6,.l227E
	movea.l	a0,a3
	moveq	#$6,d6
.l22A4	cmpi.w	#$656C,$4(a0)
	beq.w	LF64_15
	cmpi.w	#$656E,$4(a0)
	beq.w	LF64_15
	move.w	(a0),d5
	lea.l	(a0,d5.w),a0
	addi.w	#$80,d3
	dbra	d6,.l22A4
	movea.l	a3,a2
.l22C8	move.l	#$B802,d3
	moveq	#$6,d6
.l22D0	movea.l	a2,a0
	moveq	#$0,d5
	move.b	$2(a0),d5
	lea.l	$3(a0,d5.w),a0
	movea.l	$9E(a6),a1
	move.l	d3,d2
	lsl.l	#$2,d2
	lsr.w	#$2,d2
	swap	d2
	addi.l	#$40000000,d2
.l22EE	btst.b	#$7,$FF800E.l
	bne.b	.l22EE
	move.l	d2,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.l230E	btst.b	#$6,$FF800E.l
	beq.b	.l230E
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l2328	btst.b	#$6,$FF800E.l
	bne.b	.l2328
	bclr.b	#$7,$FF800F.l
	move.w	#$2,d5
	movea.l	$8E(a6),a5
.l2342	moveq	#$0,d1
	move.b	(a1)+,d1
	bsr.w	LF64_39
	dbra	d5,.l2342
	movea.l	$8E(a6),a4
.l2352	tst.b	(a4)+
	bne.w	.l2352
	move.b	#$20,-$1(a4)
	movea.l	$8E(a6),a4
	bsr.w	LF64_4
	movea.l	a2,a0
	moveq	#$0,d1
	move.b	$2(a0),d1
	lea.l	$3(a0,d1.w),a0
	moveq	#$0,d1
	move.w	$58(a6),d1
	move.b	$6(a2,d1.w),d1
	lea.l	(a0,d1.w),a0
	movea.l	$FE(a6),a1
	move.w	#$2,d5
	movea.l	$8E(a6),a5
.l238C	moveq	#$0,d1
	move.b	(a1)+,d1
	bsr.w	LF64_39
	dbra	d5,.l238C
	move.w	(a2),d5
	lea.l	(a2,d5.w),a2
	addi.w	#$80,d3
	cmpi.w	#$656C,$4(a2)
	beq.w	LF64_14
	cmpi.w	#$656E,$4(a2)
	beq.w	LF64_14
	dbra	d6,.l22D0
LF64_14	movem.l	(sp)+,d0-d7/a0-a5
	rts
LF64_15	subi.w	#$1,$56(a6)
	move.w	#$0,$B0(a6)
	bra.w	LF64_13

