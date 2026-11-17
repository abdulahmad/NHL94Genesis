; PLAYER.BIN photo picker, $1D54-$200F.
; Selects a real photo or a generic $504-byte frame, copies it to $BC000,
; and posts gate commands $B and $D so the main CPU can DMA it.
; See docs/segacd_stats.md.



; Draws the selected picture into the tilemap.
PlDrawPicture	movem.l	d0-d7/a0-a4,-(sp)
	movea.l	$1C(a6),a1
	movea.l	$48(a6),a2
	cmpi.w	#$0,$18(a6)
	beq.w	.next
	movea.l	$20(a6),a1
	movea.l	$4C(a6),a2
.next	bsr.w	PlPrepareSource
	move.w	#$D3,d0
	move.w	#$1E,d1
	bsr.w	TilemapAddr
	movea.l	$50(a6),a3
	tst.l	$44(a6)
	bne.w	.next3
	tst.b	$5(a3)
	beq.w	.next2
	lea.l	StrPlayerNum(pc),a0
	bra.w	.next3
.next2	lea.l	StrGoalieNum(pc),a0
.next3	move.w	$80(a6),d0
	add.w	d0,d0
	tst.w	(a2,d0.w)
	bmi.w	.next4
	add.w	d0,d0
	movea.l	(a1,d0.w),a1
	bra.w	.next10
.next4	moveq	#$0,d0
	tst.b	$5(a3)
	bne.w	.next7
	btst.b	#$0,$4(a3)
	beq.w	.next5
	lea.l	PicTilesStillB(pc),a1
	bra.w	.next10
.next5	lea.l	PicTilesFramesB(pc),a1
	move.b	$104(a6),d0
	cmpi.b	#$3,d0
	blt.w	.next6
	clr.w	d0
	move.b	d0,$104(a6)
.next6	mulu.w	#$504,d0
	lea.l	(a1,d0.l),a1
	bra.w	.next10
.next7	btst.b	#$0,$4(a3)
	beq.w	.next8
	lea.l	PicTilesStillA(pc),a1
	bra.w	.next10
.next8	lea.l	PicTilesFramesA(pc),a1
	move.b	$105(a6),d0
	cmpi.b	#$7,d0
	blt.w	.next9
	clr.w	d0
	move.b	d0,$105(a6)
.next9	mulu.w	#$504,d0
	lea.l	(a1,d0.l),a1
.next10	move.w	$EE(a6),d0
	bsr.w	PlDrawCareerStats
	lea.l	$2(a1),a1
	move.w	(a1)+,d0
	lsl.w	#$4,d0
	move.w	d0,$E0(a6)
	move.w	#$EB00,$E2(a6)
	movea.l	#$BC000,a2
	move.l	a2,$E4(a6)
	subq.w	#$1,d0
.loop	move.w	(a1)+,(a2)+
	dbra	d0,.loop
	move.w	#$1,$DE(a6)
.loop2	tst.w	$DE(a6)
	bne.w	.loop2
	movea.l	#$BBCF0,a2
	moveq	#$7,d0
	lea.l	$20(a1),a1
.loop3	move.l	(a1)+,(a2)+
	dbra	d0,.loop3
	move.l	#$EEE,$BBCF0.l
	move.w	#$444,$BBCB0.l
	move.w	#$444,$BBCD0.l
	move.w	#$444,$BBCF0.l
	move.w	#$444,$BBD10.l
	move.w	#$758,d5
	bset	#$E,d5
	move.w	#$B286,d3
	move.w	#$80,d6
	moveq	#$5,d1
	move.w	d1,d7
	move.w	d1,d2
.loop4	move.w	d3,d4
	bsr.w	VdpWriteCmdD4
.loop5	btst.b	#$7,$FF800E.l
	bne.b	.loop5
	move.l	d4,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop6	btst.b	#$6,$FF800E.l
	beq.b	.loop6
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop7	btst.b	#$6,$FF800E.l
	bne.b	.loop7
	bclr.b	#$7,$FF800F.l
.loop8	move.w	d5,d4
.loop9	btst.b	#$7,$FF800E.l
	bne.b	.loop9
	move.w	d4,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop10	btst.b	#$6,$FF800E.l
	beq.b	.loop10
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop11	btst.b	#$6,$FF800E.l
	bne.b	.loop11
	bclr.b	#$7,$FF800F.l
	addi.w	#$1,d5
	dbra	d1,.loop8
	add.w	d6,d3
	move.w	d7,d1
	dbra	d2,.loop4
	cmpi.w	#$0,$B0(a6)
	beq.w	.next13
	cmpi.w	#$2,$B0(a6)
	ble.w	.next11
	move.w	#$E,d0
	move.w	#$0,d1
	bsr.w	PlSetWindowRegCmd
	bra.w	.next12
.next11	moveq	#$10,d0
	moveq	#$0,d1
	bsr.w	PlSetWindowRegCmd
	cmpi.w	#$2,$B0(a6)
	bne.w	.next12
	move.w	#$50,d0
	move.w	$EE(a6),d1
	subi.w	#$2000,d1
	addi.w	#$F00,d1
	swap	d1
	move.w	#$100,d1
	move.l	#$B8000080,d2
	move.w	#$0,d3
	bsr.w	PlBlitToBuffer
.next12	move.w	$B0(a6),d0
	bsr.w	PlDrawPage
	move.w	#$0,$B0(a6)
	moveq	#$1C,d0
	moveq	#$0,d1
	bsr.w	PlSetWindowRegCmd
	bsr.w	PlSetScrollCmd
.next13	move.w	#$50,d0
	move.w	$EE(a6),d1
	subi.w	#$2000,d1
	swap	d1
	move.w	#$100,d1
	move.l	#$B0000080,d2
	move.w	#$1B,d3
	bsr.w	PlBlitToBuffer
	move.w	#$0,$B0(a6)
	moveq	#$0,d0
	moveq	#$0,d1
	bsr.w	PlSetWindowRegCmd
	bsr.w	PlUnpackNibbles
	movem.l	(sp)+,d0-d7/a0-a4
	rts

