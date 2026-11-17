; PLAYER.BIN photo picker, $1D54-$200F.
; Selects a real photo or a generic $504-byte frame, copies it to $BC000,
; and posts gate commands $B and $D so the main CPU can DMA it.
; See docs/segacd_stats.md.



LF64_11	movem.l	d0-d7/a0-a4,-(sp)
	movea.l	$1C(a6),a1
	movea.l	$48(a6),a2
	cmpi.w	#$0,$18(a6)
	beq.w	.l1D72
	movea.l	$20(a6),a1
	movea.l	$4C(a6),a2
.l1D72	bsr.w	LF64_23
	move.w	#$D3,d0
	move.w	#$1E,d1
	bsr.w	LF64_38
	movea.l	$50(a6),a3
	tst.l	$44(a6)
	bne.w	.l1DA2
	tst.b	$5(a3)
	beq.w	.l1D9E
	lea.l	LF64_20(pc),a0
	bra.w	.l1DA2
.l1D9E	lea.l	LF64_19(pc),a0
.l1DA2	move.w	$80(a6),d0
	add.w	d0,d0
	tst.w	(a2,d0.w)
	bmi.w	.l1DBA
	add.w	d0,d0
	movea.l	(a1,d0.w),a1
	bra.w	.l1E28
.l1DBA	moveq	#$0,d0
	tst.b	$5(a3)
	bne.w	.l1DF8
	btst.b	#$0,$4(a3)
	beq.w	.l1DD6
	lea.l	LF64_53(pc),a1
	bra.w	.l1E28
.l1DD6	lea.l	LF64_54(pc),a1
	move.b	$104(a6),d0
	cmpi.b	#$3,d0
	blt.w	.l1DEC
	clr.w	d0
	move.b	d0,$104(a6)
.l1DEC	mulu.w	#$504,d0
	lea.l	(a1,d0.l),a1
	bra.w	.l1E28
.l1DF8	btst.b	#$0,$4(a3)
	beq.w	.l1E0A
	lea.l	LF64_51(pc),a1
	bra.w	.l1E28
.l1E0A	lea.l	LF64_52(pc),a1
	move.b	$105(a6),d0
	cmpi.b	#$7,d0
	blt.w	.l1E20
	clr.w	d0
	move.b	d0,$105(a6)
.l1E20	mulu.w	#$504,d0
	lea.l	(a1,d0.l),a1
.l1E28	move.w	$EE(a6),d0
	bsr.w	LF64_12
	lea.l	$2(a1),a1
	move.w	(a1)+,d0
	lsl.w	#$4,d0
	move.w	d0,$E0(a6)
	move.w	#$EB00,$E2(a6)
	movea.l	#$BC000,a2
	move.l	a2,$E4(a6)
	subq.w	#$1,d0
.l1E4E	move.w	(a1)+,(a2)+
	dbra	d0,.l1E4E
	move.w	#$1,$DE(a6)
.l1E5A	tst.w	$DE(a6)
	bne.w	.l1E5A
	movea.l	#$BBCF0,a2
	moveq	#$7,d0
	lea.l	$20(a1),a1
.l1E6E	move.l	(a1)+,(a2)+
	dbra	d0,.l1E6E
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
.l1EB4	move.w	d3,d4
	bsr.w	LF64_26
.l1EBA	btst.b	#$7,$FF800E.l
	bne.b	.l1EBA
	move.l	d4,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.l1EDA	btst.b	#$6,$FF800E.l
	beq.b	.l1EDA
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l1EF4	btst.b	#$6,$FF800E.l
	bne.b	.l1EF4
	bclr.b	#$7,$FF800F.l
.l1F06	move.w	d5,d4
.l1F08	btst.b	#$7,$FF800E.l
	bne.b	.l1F08
	move.w	d4,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.l1F28	btst.b	#$6,$FF800E.l
	beq.b	.l1F28
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l1F42	btst.b	#$6,$FF800E.l
	bne.b	.l1F42
	bclr.b	#$7,$FF800F.l
	addi.w	#$1,d5
	dbra	d1,.l1F06
	add.w	d6,d3
	move.w	d7,d1
	dbra	d2,.l1EB4
	cmpi.w	#$0,$B0(a6)
	beq.w	.l1FD8
	cmpi.w	#$2,$B0(a6)
	ble.w	.l1F88
	move.w	#$E,d0
	move.w	#$0,d1
	bsr.w	LF64
	bra.w	.l1FBE
.l1F88	moveq	#$10,d0
	moveq	#$0,d1
	bsr.w	LF64
	cmpi.w	#$2,$B0(a6)
	bne.w	.l1FBE
	move.w	#$50,d0
	move.w	$EE(a6),d1
	subi.w	#$2000,d1
	addi.w	#$F00,d1
	swap	d1
	move.w	#$100,d1
	move.l	#$B8000080,d2
	move.w	#$0,d3
	bsr.w	LF64_17
.l1FBE	move.w	$B0(a6),d0
	bsr.w	LF64_1
	move.w	#$0,$B0(a6)
	moveq	#$1C,d0
	moveq	#$0,d1
	bsr.w	LF64
	bsr.w	LEBC
.l1FD8	move.w	#$50,d0
	move.w	$EE(a6),d1
	subi.w	#$2000,d1
	swap	d1
	move.w	#$100,d1
	move.l	#$B0000080,d2
	move.w	#$1B,d3
	bsr.w	LF64_17
	move.w	#$0,$B0(a6)
	moveq	#$0,d0
	moveq	#$0,d1
	bsr.w	LF64
	bsr.w	LF64_10
	movem.l	(sp)+,d0-d7/a0-a4
	rts

