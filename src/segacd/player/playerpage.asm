; PLAYER.BIN team stat page, $23D0-$281B.
; Players/Goalies columns, or the power-play and home/road lines at $28D0.
; See docs/segacd_stats.md.



; Prepares the buffers and shows the current picture.
PlShowPicture	movem.l	d0-d7/a0-a5,-(sp)
	move.b	#$5,$B6(a6)
	move.w	#$8,$B8(a6)
	bsr.w	PlFillBackground
	move.w	#$0,$B4(a6)
	move.w	$7C(a6),d0
	cmpi.w	#$0,$18(a6)
	beq.w	.l23FC
	move.w	$7E(a6),d0
.l23FC	movea.l	$86(a6),a1
	andi.l	#$FFFF,d0
	add.w	d0,d0
	add.w	d0,d0
	move.l	d0,d2
	movea.l	(a1,d0.l),a0
	move.w	$4(a0),d0
	adda.l	d0,a0
	move.w	#$1C6,-(sp)
	move.w	#$14E,-(sp)
	move.w	#$D6,-(sp)
	moveq	#$2,d3
.l2424	move.w	(a0),d0
	lea.l	(a0,d0.l),a0
	movea.l	a0,a2
	move.w	(a0)+,d0
	bsr.w	CopyStringToBuffer
	move.w	(sp)+,d0
	move.w	#$19,d1
	movea.l	$8E(a6),a0
	bsr.w	TilemapAddr
	movea.l	a2,a0
	dbra	d3,.l2424
	move.w	$54(a6),d0
	cmpi.w	#$0,d0
	beq.w	.l2670
	cmpi.w	#$1,d0
	beq.w	.l2470
	movea.l	$28(a6),a0
	cmpi.w	#$0,$18(a6)
	beq.w	.l2482
	movea.l	$38(a6),a0
	bra.w	.l2482
.l2470	movea.l	$24(a6),a0
	cmpi.w	#$0,$18(a6)
	beq.w	.l2482
	movea.l	$34(a6),a0
.l2482	move.l	a0,d0
	beq.w	.l2816
	movea.l	a0,a5
	cmpi.w	#$0,$56(a6)
	beq.w	.l24D0
.l2494	move.w	$56(a6),d5
	subq.w	#$1,d5
	moveq	#$0,d4
.l249C	move.w	(a5),d4
	lea.l	(a5,d4.w),a5
	dbra	d5,.l249C
	movea.l	a5,a2
	moveq	#$5,d5
.l24AA	cmpi.w	#$656E,$4(a5)
	bne.w	.l24C4
	move.w	#$0,$B0(a6)
	movea.l	a0,a5
	subq.w	#$1,$56(a6)
	bra.w	.l2494
.l24C4	move.w	(a5),d4
	lea.l	(a5,d4.w),a5
	dbra	d5,.l24AA
	movea.l	a2,a5
.l24D0	move.l	#$B6800080,d0
	bsr.w	PlDmaRequest
	move.w	#$209,d0
	move.w	#$14,d1
	lea.l	StrPlayers(pc),a0
	cmpi.w	#$2,$54(a6)
	bne.w	.l24F4
	lea.l	StrGoalies(pc),a0
.l24F4	bsr.w	TilemapAddr
	movea.l	a0,a4
	bsr.w	PlBuildPortraitTiles
	movea.l	$8E(a6),a0
	movea.l	a0,a2
	move.l	#$20202020,(a0)+
	move.l	#$20202020,(a0)+
	move.l	#$20202020,(a0)+
	move.l	#$20202020,(a0)+
	move.l	#$20202020,(a0)+
	move.b	#$0,(a0)
	move.w	#$7,$BA(a6)
	lea.l	StrSkaterStatHeaders(pc),a3
	cmpi.w	#$2,$54(a6)
	bne.w	.l2544
	lea.l	StrGoalieStatHeaders(pc),a3
	move.w	#$E,$BA(a6)
.l2544	movea.l	a2,a0
	cmpi.w	#$0,$58(a6)
	beq.w	.l2560
	move.w	$58(a6),d1
	subq.w	#$1,d1
.l2556	move.b	(a3)+,d0
	bne.w	.l2556
	dbra	d1,.l2556
.l2560	moveq	#$3,d1
.l2562	move.b	(a3)+,d0
	beq.w	.l2572
	bmi.w	.l2572
	move.b	d0,(a0)+
	bra.w	.l2562
.l2572	adda.l	#$5,a2
	movea.l	a2,a0
	dbra	d1,.l2562
	move.w	#$21C,d0
	move.w	#$14,d1
	movea.l	$8E(a6),a0
	bsr.w	TilemapAddr
	moveq	#$5,d5
	moveq	#$0,d3
	move.w	#$B782,d3
	move.w	#$2,$B4(a6)
.l259C	move.l	d3,d2
	lsl.l	#$2,d2
	lsr.w	#$2,d2
	swap	d2
	addi.l	#$40000000,d2
.l25AA	btst.b	#$7,$FF800E.l
	bne.b	.l25AA
	move.l	d2,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.l25CA	btst.b	#$6,$FF800E.l
	beq.b	.l25CA
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l25E4	btst.b	#$6,$FF800E.l
	bne.b	.l25E4
	bclr.b	#$7,$FF800F.l
	movea.l	a5,a2
	move.w	(a2)+,d4
	moveq	#$0,d6
	move.b	(a2)+,d6
	lea.l	(a2,d6.w),a3
	adda.l	#$1,a2
	moveq	#$0,d1
	move.b	(a2),d1
	lea.l	(a3,d1.w),a4
	bsr.w	PlBuildPortraitTiles
	move.b	$1(a2),d1
	sub.b	(a2),d1
	bsr.w	PrintTextPlain
	moveq	#$0,d6
	move.b	$1(a2),d6
	lea.l	(a3,d6.w),a4
	move.b	#$13,d0
	sub.b	d1,d0
	move.b	d0,d1
	bsr.w	PrintTextPlain
	adda.l	#$2,a2
	move.w	$58(a6),d0
	adda.w	d0,a2
	moveq	#$3,d6
.l2642	moveq	#$0,d0
	move.b	(a2)+,d0
	lea.l	(a3,d0.w),a4
	move.w	#$5,d1
	bsr.w	PrintTextPlain
	dbra	d6,.l2642
	addi.w	#$80,d3
	lea.l	(a5,d4.w),a5
	cmpi.w	#$656C,$4(a5)
	beq.w	.l277A
	dbra	d5,.l259C
	bra.w	.l277A
.l2670	moveq	#$0,d0
	movea.l	(a1,d2.l),a1
	move.w	$8(a1),d0
	adda.l	d0,a1
	move.l	#$B6800340,d0
	bsr.w	PlDmaRequest
	lea.l	StrSituationTable(pc),a0
	moveq	#$2,d4
	move.w	#$1E1,d5
	movea.l	a0,a2
	adda.l	#$1,a1
.l2698	move.b	(a1)+,d2
	move.b	d2,d1
	andi.b	#$F,d2
	lsr.b	#$4,d1
	movea.l	a2,a0
	moveq	#$0,d0
	move.b	(a0)+,d0
	bsr.w	CopyStringToBuffer
	movea.l	$8E(a6),a0
	move.w	d1,d7
	mulu.w	#$64,d7
	cmpi.w	#$1,d4
	bge.w	.l26C8
	move.w	d1,d7
	bsr.w	BinToBcd
	bra.w	.l26D0
.l26C8	divu.w	#$2,d7
	bsr.w	BinToBcdCarry
.l26D0	move.b	#$20,-$2(a0,d0.w)
	moveq	#$4,d3
	subq.w	#$1,d0
.l26DA	move.l	d7,d1
	move.b	d1,(a0,d0.w)
	addq.w	#$1,d0
	lsr.l	#$8,d7
	dbra	d3,.l26DA
	addi.w	#$28,d5
	move.w	d5,d0
	move.w	#$27,d1
	bsr.w	TilemapAddr
	moveq	#$0,d0
	movea.l	a2,a0
	move.b	(a0),d0
	lea.l	(a0,d0.l),a0
	movea.l	a0,a2
	move.b	(a0)+,d0
	bsr.w	CopyStringToBuffer
	movea.l	$8E(a6),a0
	move.w	d2,d7
	mulu.w	#$64,d7
	cmpi.w	#$3,d4
	beq.w	.l271E
	bra.w	.l272A
.l271E	divu.w	#$7,d7
	bsr.w	BinToBcdCarry
	bra.w	.l2744
.l272A	cmpi.w	#$1,d4
	bge.w	.l273C
	move.w	d2,d7
	bsr.w	BinToBcd
	bra.w	.l2744
.l273C	divu.w	#$2,d7
	bsr.w	BinToBcdCarry
.l2744	move.b	#$20,-$2(a0,d0.w)
	moveq	#$4,d3
	subq.w	#$1,d0
.l274E	move.l	d7,d1
	move.b	d1,(a0,d0.w)
	addq.w	#$1,d0
	lsr.l	#$8,d7
	dbra	d3,.l274E
	addi.w	#$28,d5
	move.w	d5,d0
	move.w	#$27,d1
	bsr.w	TilemapAddr
	moveq	#$0,d0
	movea.l	a2,a0
	move.b	(a0),d0
	lea.l	(a0,d0.l),a0
	movea.l	a0,a2
	dbra	d4,.l2698
.l277A	cmpi.w	#$0,$B0(a6)
	beq.w	.l27EE
	cmpi.w	#$2,$B0(a6)
	ble.w	.l279E
	move.w	#$D,d0
	move.w	#$0,d1
	bsr.w	LF64
	bra.w	.l27D4
.l279E	moveq	#$F,d0
	moveq	#$0,d1
	bsr.w	LF64
	cmpi.w	#$2,$B0(a6)
	bne.w	.l27D4
	move.w	#$50,d0
	move.w	$EE(a6),d1
	subi.w	#$2000,d1
	addi.w	#$E00,d1
	swap	d1
	move.w	#$100,d1
	move.l	#$B7800080,d2
	move.w	#$0,d3
	bsr.w	PlBlitToBuffer
.l27D4	move.w	$B0(a6),d0
	bsr.w	PlDrawPage
	move.w	#$0,$B0(a6)
	moveq	#$1C,d0
	moveq	#$0,d1
	bsr.w	LF64
	bsr.w	LEBC
.l27EE	move.w	#$50,d0
	move.w	$EE(a6),d1
	subi.w	#$2000,d1
	swap	d1
	move.w	#$100,d1
	move.l	#$B0000080,d2
	move.w	#$1B,d3
	bsr.w	PlBlitToBuffer
	moveq	#$0,d0
	moveq	#$0,d1
	bsr.w	LF64
.l2816	movem.l	(sp)+,d0-d7/a0-a5
	rts

