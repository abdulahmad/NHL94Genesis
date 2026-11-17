; PLAYER.BIN career-stat printer, $2010-$23CF.
; Regular/Playoff headers, then up to 7 linked season rows.
; End of a list is the word $656C or $656E at offset 4.
; See docs/segacd_stats.md.



; Draws the career statistics rows from $44(a6).
PlDrawCareerStats	movem.l	d0-d7/a0-a5,-(sp)
	move.l	$44(a6),d0
	beq.w	LF64_14
	movea.l	d0,a2
	move.w	#$1C3,-(sp)
	move.w	#$14B,-(sp)
	moveq	#$1,d5
.loop	moveq	#$0,d1
	move.w	(a2),d1
	lea.l	(a2,d1.w),a2
	movea.l	a2,a0
	adda.l	#$5,a0
	cmpi.w	#$1,d5
	bne.w	.next
	move.b	(a0),$B7(a6)
	adda.l	#$2,a0
.next	move.w	(sp)+,d0
	move.w	#$1D,d1
	bsr.w	TilemapAddr
	dbra	d5,.loop
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
.loop2	cmpi.b	#$20,(a0)+
	bne.w	.loop2
.loop3	move.b	(a0)+,(a1)+
	bne.w	.loop3
	movea.l	$8E(a6),a0
	move.w	#$1EB,d0
	move.w	#$1D,d1
	bsr.w	TilemapAddr
	moveq	#$3,d5
.loop4	move.w	(a2),d1
	lea.l	(a2,d1.w),a2
	dbra	d5,.loop4
	movea.l	a2,a3
	moveq	#$0,d0
	moveq	#$0,d3
.loop5	move.b	$5(a3),d1
	sub.b	$4(a3),d1
	cmp.b	d1,d0
	bgt.w	.next2
	move.b	d1,d0
.next2	move.w	(a3),d3
	lea.l	(a3,d3.w),a3
	cmpi.w	#$656C,$4(a3)
	beq.w	.next3
	cmpi.w	#$656E,$4(a3)
	bne.w	.loop5
.next3	movea.l	$9E(a6),a0
	cmpi.b	#$A,d0
	bge.w	.next4
	move.b	#$A,d0
.next4	subq.b	#$1,d0
	move.b	d0,$1(a0)
	moveq	#$0,d1
	move.b	(a0)+,d1
	add.b	(a0)+,d1
	add.b	(a0),d1
	divs.w	#$4,d1
	move.b	d1,$B6(a6)
	swap	d1
	tst.w	d1
	beq.w	.next5
	addi.b	#$1,$B6(a6)
.next5	move.w	#$9,$B8(a6)
	bsr.w	PlFillBackground
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
.loop6	btst.b	#$7,$FF800E.l
	bne.b	.loop6
	move.l	d2,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop7	btst.b	#$6,$FF800E.l
	beq.b	.loop7
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop8	btst.b	#$6,$FF800E.l
	bne.b	.loop8
	bclr.b	#$7,$FF800F.l
	lea.l	StrRegular(pc),a0
	move.w	$A6(a6),d1
	cmp.w	$58(a6),d1
	bge.w	.next6
	lea.l	StrPlayoff(pc),a0
.next6	movea.l	$8E(a6),a5
	move.w	#$7,d1
	bsr.w	PrintTextLine
	move.l	#$B702,d3
	movea.l	$9A(a6),a0
	movea.l	$9E(a6),a1
	move.l	d3,d2
	lsl.l	#$2,d2
	lsr.w	#$2,d2
	swap	d2
	addi.l	#$40000000,d2
.loop9	btst.b	#$7,$FF800E.l
	bne.b	.loop9
	move.l	d2,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop10	btst.b	#$6,$FF800E.l
	beq.b	.loop10
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop11	btst.b	#$6,$FF800E.l
	bne.b	.loop11
	bclr.b	#$7,$FF800F.l
	moveq	#$2,d5
	moveq	#$0,d1
	movea.l	$8E(a6),a5
.loop12	moveq	#$0,d1
	move.b	(a1)+,d1
	bsr.w	PrintTextLine
	dbra	d5,.loop12
	move.w	#$0,$B4(a6)
	movea.l	$8E(a6),a4
.loop13	tst.b	(a4)+
	bne.w	.loop13
	move.b	#$20,-$1(a4)
	movea.l	$8E(a6),a4
	bsr.w	PlBuildPortraitTiles
	move.w	#$2,$B4(a6)
	cmpi.w	#$0,$58(a6)
	beq.w	.next7
	move.w	$58(a6),d5
	subq.w	#$1,d5
.loop14	tst.b	(a0)+
	bne.w	.loop14
	adda.l	#$1,a1
	dbra	d5,.loop14
.next7	move.l	a1,$FE(a6)
	moveq	#$2,d5
	moveq	#$0,d1
	movea.l	$8E(a6),a5
.loop15	moveq	#$0,d1
	move.b	(a1)+,d1
	bsr.w	PrintTextLine
	dbra	d5,.loop15
LF64_13	move.w	$56(a6),d6
	beq.w	.next
	subq.w	#$1,d6
	movea.l	a2,a0
.loop	move.w	(a0),d5
	lea.l	(a0,d5.w),a0
	addi.w	#$80,d3
	cmpi.w	#$656C,$4(a0)
	beq.w	LF64_15
	cmpi.w	#$656E,$4(a0)
	beq.w	LF64_15
	dbra	d6,.loop
	movea.l	a0,a3
	moveq	#$6,d6
.loop2	cmpi.w	#$656C,$4(a0)
	beq.w	LF64_15
	cmpi.w	#$656E,$4(a0)
	beq.w	LF64_15
	move.w	(a0),d5
	lea.l	(a0,d5.w),a0
	addi.w	#$80,d3
	dbra	d6,.loop2
	movea.l	a3,a2
.next	move.l	#$B802,d3
	moveq	#$6,d6
.loop3	movea.l	a2,a0
	moveq	#$0,d5
	move.b	$2(a0),d5
	lea.l	$3(a0,d5.w),a0
	movea.l	$9E(a6),a1
	move.l	d3,d2
	lsl.l	#$2,d2
	lsr.w	#$2,d2
	swap	d2
	addi.l	#$40000000,d2
.loop4	btst.b	#$7,$FF800E.l
	bne.b	.loop4
	move.l	d2,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop5	btst.b	#$6,$FF800E.l
	beq.b	.loop5
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop6	btst.b	#$6,$FF800E.l
	bne.b	.loop6
	bclr.b	#$7,$FF800F.l
	move.w	#$2,d5
	movea.l	$8E(a6),a5
.loop7	moveq	#$0,d1
	move.b	(a1)+,d1
	bsr.w	PrintTextLine
	dbra	d5,.loop7
	movea.l	$8E(a6),a4
.loop8	tst.b	(a4)+
	bne.w	.loop8
	move.b	#$20,-$1(a4)
	movea.l	$8E(a6),a4
	bsr.w	PlBuildPortraitTiles
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
.loop9	moveq	#$0,d1
	move.b	(a1)+,d1
	bsr.w	PrintTextLine
	dbra	d5,.loop9
	move.w	(a2),d5
	lea.l	(a2,d5.w),a2
	addi.w	#$80,d3
	cmpi.w	#$656C,$4(a2)
	beq.w	LF64_14
	cmpi.w	#$656E,$4(a2)
	beq.w	LF64_14
	dbra	d6,.loop3
LF64_14	movem.l	(sp)+,d0-d7/a0-a5
	rts
LF64_15	subi.w	#$1,$56(a6)
	move.w	#$0,$B0(a6)
	bra.w	LF64_13

