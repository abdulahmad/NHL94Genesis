X_1B9C	dc.b	$08,$B9,$00,$05,$00,$FF,$80,$0F,$2C,$7C,$00,$00,$AE,$6E,$9D,$FC	; ........,|...n..
	dc.b	$00,$00,$00,$00,$4F,$FB,$E8,$EA,$2F,$0E,$2C,$7C,$00,$00,$A5,$94	; ....O.../.,|....
	dc.b	$4D,$FB,$E8,$DE	; M...
X_1B9CSub1	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	InstallVblankHook
	lea.l	LF64_28(pc),a0
	move.l	a0,$D2(a6)
	move.w	d0,$7C(a6)
	move.w	d1,$7E(a6)
	move.w	d2,$BC(a6)
	bsr.w	GateArrayLoadCmd
	move.w	#$6,d7
	jsr	$6044.w
	move.l	a0,$DA(a6)
	movea.l	a0,a2
	move.w	#$4026,d0
	movea.l	#$AFF60,a1
.l5C	move.l	(a1)+,(a2)+
	dbra	d0,.l5C
	movea.l	$DA(a6),a0
	adda.l	#$100A0,a0
	move.l	a0,$8E(a6)
	adda.l	#$100,a0
	move.l	a0,$92(a6)
	adda.l	#$280,a0
	move.l	a0,$8A(a6)
	adda.l	#$1F80,a0
	move.w	#$2,d7
	jsr	$6044.w
	clr.w	$C6(a6)
	clr.w	$C8(a6)
	clr.w	$C2(a6)
	clr.w	$DE(a6)
	clr.w	$F6(a6)
	clr.w	$F2(a6)
	move.w	#$2,$F8(a6)
	clr.w	$80(a6)
	move.w	#$0,$56(a6)
	move.w	#$7,$5E(a6)
	move.w	#$FF90,$5C(a6)
	move.w	$7C(a6),d0
	move.w	$7E(a6),d1
	andi.l	#$FFFF,d0
	andi.l	#$FFFF,d1
	addi.l	#$44,d0
	addi.l	#$44,d1
	movea.l	d0,a2
X_1B9CSub2	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	a2,d0
	jsr	$6044.w
	move.l	a0,$FE(a6)
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	$FE(a6),a0
	movea.l	d0,a2
X_1B9CSub3	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	a2,d0
	jsr	$6044.w
	move.l	a0,$FE(a6)
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	$FE(a6),a0
	move.l	a0,d2
	move.l	(a0),$4(a6)
	add.l	d2,$4(a6)
	move.l	$4(a0),$0(a6)
	add.l	d2,$0(a6)
	move.l	$8(a0),$8(a6)
	add.l	d2,$8(a6)
	movea.l	d1,a2
X_1B9CSub4	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	a2,d0
	jsr	$6044.w
	move.l	a0,$FE(a6)
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	$FE(a6),a0
	move.l	a0,d2
	move.l	(a0),$10(a6)
	add.l	d2,$10(a6)
	move.l	$4(a0),$C(a6)
	add.l	d2,$C(a6)
	move.l	$8(a0),$14(a6)
	add.l	d2,$14(a6)
X_1B9CSub5	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$40,d0
	jsr	$6044.w
	move.l	a0,$70(a6)
	movem.l	(sp)+,d0-d2/d7/a0-a1
X_1B9CSub6	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$22,d0
	jsr	$6044.w
	move.l	a0,$86(a6)
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	$86(a6),a2
	move.l	a2,d2
	moveq	#$1B,d0
.l1AE	add.l	d2,(a2)+
	dbra	d0,.l1AE
	move.w	#$6,d7
	jsr	$6044.w
	move.l	a0,$A2(a6)
	bsr.w	LCAA
	bset.b	#$5,$FF800F.l
	movea.l	#$BBCB0,a0
	moveq	#$1F,d0
.l1D4	clr.l	(a0)+
	dbra	d0,.l1D4
	move.w	#$18,$EC(a6)
.l1E0	tst.w	$EC(a6)
	bpl.w	.l1E0
.l1E8	btst.b	#$7,$FF800E.l
	bne.b	.l1E8
	move.w	#$20,$FF8020.l
	bset.b	#$6,$FF800F.l
.l202	btst.b	#$6,$FF800E.l
	beq.b	.l202
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l21C	btst.b	#$6,$FF800E.l
	bne.b	.l21C
	bclr.b	#$7,$FF800F.l
.l22E	btst.b	#$7,$FF800E.l
	bne.b	.l22E
	move.w	#$8164,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.l250	btst.b	#$6,$FF800E.l
	beq.b	.l250
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l26A	btst.b	#$6,$FF800E.l
	bne.b	.l26A
	bclr.b	#$7,$FF800F.l
.l27C	btst.b	#$7,$FF800E.l
	bne.b	.l27C
	move.w	#$8C81,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.l29E	btst.b	#$6,$FF800E.l
	beq.b	.l29E
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l2B8	btst.b	#$6,$FF800E.l
	bne.b	.l2B8
	bclr.b	#$7,$FF800F.l
.l2CA	btst.b	#$7,$FF800E.l
	bne.b	.l2CA
	move.w	#$9003,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.l2EC	btst.b	#$6,$FF800E.l
	beq.b	.l2EC
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l306	btst.b	#$6,$FF800E.l
	bne.b	.l306
	bclr.b	#$7,$FF800F.l
.l318	btst.b	#$7,$FF800E.l
	bne.b	.l318
	move.w	#$8200,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.l33A	btst.b	#$6,$FF800E.l
	beq.b	.l33A
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l354	btst.b	#$6,$FF800E.l
	bne.b	.l354
	bclr.b	#$7,$FF800F.l
.l366	btst.b	#$7,$FF800E.l
	bne.b	.l366
	move.w	#$8401,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.l388	btst.b	#$6,$FF800E.l
	beq.b	.l388
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l3A2	btst.b	#$6,$FF800E.l
	bne.b	.l3A2
	bclr.b	#$7,$FF800F.l
.l3B4	btst.b	#$7,$FF800E.l
	bne.b	.l3B4
	move.w	#$8574,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.l3D6	btst.b	#$6,$FF800E.l
	beq.b	.l3D6
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l3F0	btst.b	#$6,$FF800E.l
	bne.b	.l3F0
	bclr.b	#$7,$FF800F.l
.l402	btst.b	#$7,$FF800E.l
	bne.b	.l402
	move.w	#$8D3C,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.l424	btst.b	#$6,$FF800E.l
	beq.b	.l424
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l43E	btst.b	#$6,$FF800E.l
	bne.b	.l43E
	bclr.b	#$7,$FF800F.l
.l450	btst.b	#$7,$FF800E.l
	bne.b	.l450
	move.w	#$832C,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.l472	btst.b	#$6,$FF800E.l
	beq.b	.l472
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l48C	btst.b	#$6,$FF800E.l
	bne.b	.l48C
	bclr.b	#$7,$FF800F.l
.l49E	btst.b	#$7,$FF800E.l
	bne.b	.l49E
	move.w	#$9100,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.l4C0	btst.b	#$6,$FF800E.l
	beq.b	.l4C0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l4DA	btst.b	#$6,$FF800E.l
	bne.b	.l4DA
	bclr.b	#$7,$FF800F.l
.l4EC	btst.b	#$7,$FF800E.l
	bne.b	.l4EC
	move.w	#$9200,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.l50E	btst.b	#$6,$FF800E.l
	beq.b	.l50E
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l528	btst.b	#$6,$FF800E.l
	bne.b	.l528
	bclr.b	#$7,$FF800F.l
.l53A	btst.b	#$7,$FF800E.l
	bne.b	.l53A
	move.w	#$8F02,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.l55C	btst.b	#$6,$FF800E.l
	beq.b	.l55C
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l576	btst.b	#$6,$FF800E.l
	bne.b	.l576
	bclr.b	#$7,$FF800F.l
.l588	btst.b	#$7,$FF800E.l
	bne.b	.l588
	move.w	#$8B00,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.l5AA	btst.b	#$6,$FF800E.l
	beq.b	.l5AA
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l5C4	btst.b	#$6,$FF800E.l
	bne.b	.l5C4
	bclr.b	#$7,$FF800F.l
.l5D6	btst.b	#$7,$FF800E.l
	bne.b	.l5D6
	move.l	#$70000003,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.l5FA	btst.b	#$6,$FF800E.l
	beq.b	.l5FA
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l614	btst.b	#$6,$FF800E.l
	bne.b	.l614
	bclr.b	#$7,$FF800F.l
.l626	btst.b	#$7,$FF800E.l
	bne.b	.l626
	move.l	#$0,$FF8022.l
	move.w	#$E,$FF8020.l
	bset.b	#$6,$FF800F.l
.l64A	btst.b	#$6,$FF800E.l
	beq.b	.l64A
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l664	btst.b	#$6,$FF800E.l
	bne.b	.l664
	bclr.b	#$7,$FF800F.l
.l676	btst.b	#$7,$FF800E.l
	bne.b	.l676
	move.l	#$40000010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.l69A	btst.b	#$6,$FF800E.l
	beq.b	.l69A
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l6B4	btst.b	#$6,$FF800E.l
	bne.b	.l6B4
	bclr.b	#$7,$FF800F.l
.l6C6	btst.b	#$7,$FF800E.l
	bne.b	.l6C6
	move.l	#$0,$FF8022.l
	move.w	#$E,$FF8020.l
	bset.b	#$6,$FF800F.l
.l6EA	btst.b	#$6,$FF800E.l
	beq.b	.l6EA
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l704	btst.b	#$6,$FF800E.l
	bne.b	.l704
	bclr.b	#$7,$FF800F.l
.l716	btst.b	#$7,$FF800E.l
	bne.b	.l716
	move.l	#$68000003,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.l73A	btst.b	#$6,$FF800E.l
	beq.b	.l73A
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l754	btst.b	#$6,$FF800E.l
	bne.b	.l754
	bclr.b	#$7,$FF800F.l
.l766	btst.b	#$7,$FF800E.l
	bne.b	.l766
	move.l	#$0,$FF8022.l
	move.w	#$E,$FF8020.l
	bset.b	#$6,$FF800F.l
.l78A	btst.b	#$6,$FF800E.l
	beq.b	.l78A
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l7A4	btst.b	#$6,$FF800E.l
	bne.b	.l7A4
	bclr.b	#$7,$FF800F.l
	move.l	#$7A0,$62(a6)
	move.l	#$1000,d0
	bsr.w	PlDmaRequest
	move.l	#$20001000,d0
	bsr.w	PlDmaRequest
	move.l	#$B0000700,d0
	bsr.w	PlDmaRequest
	move.w	#$7000,$FC(a6)
	lea.l	LF64_27(pc),a0
	move.l	a0,$D2(a6)
	move.w	#$0,$EC(a6)
.l7F0	tst.w	$EC(a6)
	beq.b	.l7F0
	lea.l	LF64_28(pc),a0
	move.l	a0,$D2(a6)
	moveq	#$0,d6
	moveq	#$0,d4
	move.w	#$2000,$EE(a6)
	move.w	#$0,$18(a6)
	movea.l	$70(a6),a1
	move.w	$2(a1),d0
	lea.l	$4(a1),a1
	lsl.w	#$4,d0
	move.w	d0,$E0(a6)
	move.w	#$F400,$E2(a6)
	movea.l	#$BC000,a2
	move.l	a2,$E4(a6)
	subq.w	#$1,d0
.l832	move.w	(a1)+,(a2)+
	dbra	d0,.l832
	move.w	#$1,$DE(a6)
.l83E	tst.w	$DE(a6)
	bne.w	.l83E
	lea.l	PlBackgroundImage(pc),a1
	move.l	a1,$74(a6)
	movea.l	$74(a6),a1
	move.w	$2(a1),d0
	lea.l	$4(a1),a1
	lsl.w	#$4,d0
	move.w	d0,$E0(a6)
	move.w	#$A000,$E2(a6)
	movea.l	#$BC000,a2
	move.l	a2,$E4(a6)
	subq.w	#$1,d0
.l872	move.w	(a1)+,(a2)+
	dbra	d0,.l872
	move.w	#$1,$DE(a6)
.l87E	tst.w	$DE(a6)
	bne.w	.l87E
	adda.l	#$4,a1
	move.l	a1,$78(a6)
	bsr.w	PlDrawPicture
	move.w	d4,d0
	bsr.w	PlSelectPicture
	bsr.w	PlUnpackNibbles
	move.w	#$18,$EC(a6)
.l8A4	tst.w	$EC(a6)
	bpl.w	.l8A4
	bsr.w	LDEC
	move.w	#$7,$BA(a6)
.l8B6	move.l	#$B0000700,d0
	bsr.w	PlDmaRequest
	move.w	d4,d7
	bsr.w	UpdatePad1
	move.b	d0,$BE(a6)
	move.b	d1,$BF(a6)
	move.b	d2,$C0(a6)
	move.b	d3,$C1(a6)
	move.w	d1,d5
	bsr.w	UpdatePad2
	or.w	d1,d5
	or.b	d0,$BE(a6)
	or.b	d1,$BF(a6)
	or.b	d2,$C0(a6)
	or.b	d3,$C1(a6)
.l8EE	cmpi.b	#$80,d5
	beq.w	.lC4E
	cmpi.b	#$28,$C1(a6)
	bne.w	.l968
	cmpi.w	#$1,d4
	beq.w	.l934
	cmpi.w	#$0,d4
	bne.w	.l968
	cmpi.w	#$0,$5A(a6)
	ble.w	.l8B6
	subi.w	#$1,$5A(a6)
	move.w	#$4,$B0(a6)
	bsr.w	PlDrawPicture
	moveq	#$7,d0
	bsr.w	LEAA
	bra.w	.l8B6
.l934	cmpi.w	#$0,$54(a6)
	beq.w	.l8B6
	cmpi.w	#$0,$58(a6)
	ble.w	.l8B6
	subi.w	#$1,$58(a6)
	move.w	#$4,$B0(a6)
	bsr.w	PlShowPicture
	move.b	#$0,$C1(a6)
	moveq	#$7,d0
	bsr.w	LEAA
	bra.w	.l8B6
.l968	cmpi.b	#$24,$C1(a6)
	bne.w	.l9DC
	cmpi.w	#$1,d4
	beq.w	.l9A6
	cmpi.w	#$0,d4
	bne.w	.l9DC
	cmpi.w	#$FFFF,$58(a6)
	beq.w	.l8B6
	addi.w	#$1,$5A(a6)
	move.w	#$3,$B0(a6)
	bsr.w	PlDrawPicture
	moveq	#$7,d0
	bsr.w	LEAA
	bra.w	.l8B6
.l9A6	cmpi.w	#$0,$54(a6)
	beq.w	.l8B6
	move.w	$58(a6),d0
	cmp.w	$BA(a6),d0
	bgt.w	.l8B6
	addi.w	#$1,$58(a6)
	move.w	#$3,$B0(a6)
	bsr.w	PlShowPicture
	move.b	#$0,$C1(a6)
	moveq	#$7,d0
	bsr.w	LEAA
	bra.w	.l8B6
.l9DC	cmpi.b	#$8,d5
	bne.w	.lA0E
	move.w	#$0,$F8(a6)
	subq.w	#$1,d4
	moveq	#$1,d6
	move.w	$EE(a6),d0
	move.w	d0,$F0(a6)
	addi.w	#$50,d0
	cmpi.w	#$2100,d0
	blt.w	.lA06
	subi.w	#$100,d0
.lA06	move.w	d0,$EE(a6)
	bra.w	.lB9E
.lA0E	cmpi.b	#$4,d5
	bne.w	.lA40
	move.w	#$1,$F8(a6)
	addq.w	#$1,d4
	moveq	#$1,d6
	move.w	$EE(a6),d0
	move.w	d0,$F0(a6)
	subi.w	#$50,d0
	cmpi.w	#$2000,d0
	bge.w	.lA38
	addi.w	#$100,d0
.lA38	move.w	d0,$EE(a6)
	bra.w	.lB9E
.lA40	cmpi.b	#$40,d5
	bne.w	.lA82
	move.w	$18(a6),d0
	eori.w	#$1,d0
	move.w	d0,$18(a6)
	moveq	#$1,d6
	move.w	#$2,$F8(a6)
	clr.w	$80(a6)
	move.w	#$0,$54(a6)
	move.w	#$0,$56(a6)
	move.w	#$0,$58(a6)
	move.w	#$0,$5A(a6)
	move.w	#$0,$B0(a6)
	bra.w	.lBC4
.lA82	cmpi.b	#$10,d5
	bne.w	.lAEE
	cmpi.w	#$0,d4
	beq.w	.lABC
	cmpi.w	#$1,d4
	bne.w	.lAEE
	move.w	#$0,$54(a6)
	clr.w	$56(a6)
	clr.w	$58(a6)
	move.w	#$0,$B0(a6)
	bsr.w	PlShowPicture
	moveq	#$7,d0
	bsr.w	LEAA
	bra.w	.lBC4
.lABC	addi.w	#$1,$80(a6)
	addi.b	#$1,$104(a6)
	addi.b	#$1,$105(a6)
	move.w	#$0,$56(a6)
	move.w	#$0,$5A(a6)
	move.w	#$0,$B0(a6)
	bsr.w	PlDrawPicture
	moveq	#$7,d0
	bsr.w	LEAA
	bra.w	.lBC4
.lAEE	cmpi.b	#$1,d5
	bne.w	.lB38
	cmpi.w	#$0,d4
	bne.w	.lB12
	addi.w	#$1,$56(a6)
	move.w	#$1,$B0(a6)
	bsr.w	PlDrawPicture
	bra.w	.l8B6
.lB12	cmpi.w	#$1,d4
	bne.w	.lB38
	cmpi.w	#$1,$54(a6)
	bne.w	.lB38
	addi.w	#$1,$56(a6)
	move.w	#$1,$B0(a6)
	bsr.w	PlShowPicture
	bra.w	.l8B6
.lB38	cmpi.b	#$2,d5
	bne.w	.l8B6
	cmpi.w	#$0,d4
	bne.w	.lB6E
	subi.w	#$1,$56(a6)
	cmpi.w	#$0,$56(a6)
	bge.w	.lB60
	clr.w	$56(a6)
	bra.w	.l8B6
.lB60	move.w	#$2,$B0(a6)
	bsr.w	PlDrawPicture
	bra.w	.l8B6
.lB6E	cmpi.w	#$1,d4
	bne.w	.l8B6
	cmpi.w	#$1,$54(a6)
	bne.w	.l8B6
	cmpi.w	#$1,$56(a6)
	blt.w	.l8B6
	subi.w	#$1,$56(a6)
	move.w	#$2,$B0(a6)
	bsr.w	PlShowPicture
	bra.w	.l8B6
.lB9E	cmpi.w	#$0,d4
	bge.w	.lBB2
	moveq	#$0,d4
	moveq	#$0,d6
	move.w	$F0(a6),$EE(a6)
	bra.b	.lBC4
.lBB2	cmpi.w	#$2,d4
	ble.w	.lBC4
	moveq	#$2,d4
	moveq	#$0,d6
	move.w	$F0(a6),$EE(a6)
.lBC4	tst.w	d6
	beq.w	.l8B6
	move.l	d4,d0
	clr.w	$56(a6)
	clr.w	$58(a6)
	bsr.w	PlSelectPicture
	move.w	#$64,$EC(a6)
.lBDE	tst.w	$EC(a6)
	bpl.w	.lBDE
	cmpi.w	#$1,d7
	bne.w	.lC02
	cmpi.w	#$1,$54(a6)
	bne.w	.lC02
	cmpi.w	#$2,$F8(a6)
	beq.w	.lC02
.lC02	cmpi.w	#$0,d4
	bne.w	.lC0E
	bsr.w	PlDrawPicture
.lC0E	cmpi.w	#$1,d4
	bne.w	.lC1A
	bsr.w	PlShowPicture
.lC1A	cmpi.w	#$2,$F8(a6)
	beq.w	.lC38
	move.w	#$140,$F4(a6)
	move.w	#$1,$FA(a6)
.lC30	tst.w	$FA(a6)
	bne.w	.lC30
.lC38	moveq	#$0,d6
	cmpi.w	#$2,d4
	bne.w	.l8B6
	bsr.w	PlDecodePicture
	move.w	$AE(a6),d5
	bra.w	.l8EE
.lC4E	movea.l	#$BBCB0,a0
	moveq	#$1F,d0
.lC56	clr.l	(a0)+
	dbra	d0,.lC56
	move.w	#$18,$EC(a6)
.lC62	tst.w	$EC(a6)
	bpl.w	.lC62
	bsr.w	GateArrayLoadCmd
	bclr.b	#$5,$FF800F.l
	move.l	#$3FFF,d0
	movea.l	$DA(a6),a1
	movea.l	#$AFF60,a2
.lC86	move.l	(a1)+,(a2)+
	dbra	d0,.lC86
	move.l	#$13,d0
.lC92	move.l	(a1)+,(a2)+
	dbra	d0,.lC92
	bsr.w	RemoveVblankHook
	movem.l	(sp)+,d0-d7/a0-a6
	movea.l	(sp)+,a6
	move.w	#$4,d7
	jsr	$6044.w
LCAA	move.l	#$6,d0
	move.l	d0,d1
	add.w	$7C(a6),d0
	add.w	$7E(a6),d1
	lea.l	X_1B9C(pc),a1
	movea.l	d0,a2
LCAASub1	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	a2,d0
	jsr	$6044.w
	move.l	a0,$1C(a6)
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	$1C(a6),a2
	move.l	a2,d2
.lCDC	add.l	d2,(a2)+
	tst.w	(a2)
	bpl.w	.lCDC
	lea.l	$24(a6),a3
	lea.l	-$10(a2),a4
	move.l	(a4)+,(a3)+
	move.l	(a4)+,(a3)+
	move.l	(a4)+,(a3)+
	move.l	(a4)+,(a3)+
	lea.l	$2(a2),a2
	move.l	a2,$48(a6)
	movea.l	d1,a2
LCAASub2	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	a2,d0
	jsr	$6044.w
	move.l	a0,$20(a6)
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	$20(a6),a2
	move.l	a2,d2
.lD1A	add.l	d2,(a2)+
	tst.w	(a2)
	bpl.w	.lD1A
	lea.l	$34(a6),a3
	lea.l	-$10(a2),a4
	move.l	(a4)+,(a3)+
	move.l	(a4)+,(a3)+
	move.l	(a4)+,(a3)+
	move.l	(a4)+,(a3)+
	lea.l	$2(a2),a2
	move.l	a2,$4C(a6)
	movea.l	$2C(a6),a0
	cmpi.l	#$12345678,(a0)
	bne.w	.lD50
	move.l	#$0,$2C(a6)
.lD50	movea.l	$30(a6),a0
	cmpi.l	#$12345678,(a0)
	bne.w	.lD66
	move.l	#$0,$30(a6)
.lD66	movea.l	$3C(a6),a0
	cmpi.l	#$12345678,(a0)
	bne.w	.lD7C
	move.l	#$0,$3C(a6)
.lD7C	movea.l	$40(a6),a0
	cmpi.l	#$12345678,(a0)
	bne.w	.lD92
	move.l	#$0,$40(a6)
.lD92	movea.l	$24(a6),a0
	cmpi.l	#$12345678,(a0)
	bne.w	.lDA8
	move.l	#$0,$24(a6)
.lDA8	movea.l	$34(a6),a0
	cmpi.l	#$12345678,(a0)
	bne.w	.lDBE
	move.l	#$0,$34(a6)
.lDBE	movea.l	$28(a6),a0
	cmpi.l	#$12345678,(a0)
	bne.w	.lDD4
	move.l	#$0,$28(a6)
.lDD4	movea.l	$38(a6),a0
	cmpi.l	#$12345678,(a0)
	bne.w	.lDEA
	move.l	#$0,$38(a6)
.lDEA	rts
LDEC	movem.l	d0-d7/a1-a2,-(sp)
	move.w	#$50,d0
	move.l	#$B0000080,d1
	move.w	$EE(a6),d2
	subi.w	#$2000,d2
	swap	d2
	move.w	#$100,d2
	move.w	#$13,d3
	bsr.w	PlBlitToBuffer
	moveq	#$14,d0
	moveq	#$0,d1
	bsr.w	LF64
	moveq	#$0,d0
	movea.l	#$91EC,a1
	suba.l	#$0,a1
	lea.l	X_1B9C(pc),a2
	adda.l	a2,a1
	move.w	$2(a1),d0
	lea.l	$4(a1),a1
	lsl.w	#$4,d0
	move.w	$FC(a6),d1
	eori.w	#$3000,d1
	move.w	d1,$E2(a6)
	move.w	d0,$E0(a6)
	move.l	a1,$E4(a6)
	move.w	#$1,$DE(a6)
.lE50	tst.w	$DE(a6)
	bne.w	.lE50
	add.w	d0,d0
	lea.l	(a1,d0.w),a1
	move.w	#$0,$B2(a6)
	move.w	d1,d5
	lsr.w	#$5,d5
	move.l	#$B296,d3
	move.l	#$80,d6
	bsr.w	PlCopyRectToVdp
	clr.l	$96(a6)
.lE7C	bsr.w	UpdatePad1
	tst.w	d1
	bne.w	.lE9C
	bsr.w	UpdatePad2
	tst.w	d1
	bne.w	.lE9C
	cmpi.l	#$258,$96(a6)
	ble.w	.lE7C
.lE9C	moveq	#$0,d0
	moveq	#$0,d1
	bsr.w	LF64
	movem.l	(sp)+,d0-d7/a1-a2
	rts
LEAA	clr.w	$102(a6)
.lEAE	tst.w	$102(a6)
	beq.w	.lEAE
	dbra	d0,LEAA
	rts
LEBC	movem.l	d0-d2,-(sp)
.lEC0	btst.b	#$7,$FF800E.l
	bne.b	.lEC0
	move.l	#$40000010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.lEE4	btst.b	#$6,$FF800E.l
	beq.b	.lEE4
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.lEFE	btst.b	#$6,$FF800E.l
	bne.b	.lEFE
	bclr.b	#$7,$FF800F.l
.lF10	btst.b	#$7,$FF800E.l
	bne.b	.lF10
	move.w	#$0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.lF32	btst.b	#$6,$FF800E.l
	beq.b	.lF32
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.lF4C	btst.b	#$6,$FF800E.l
	bne.b	.lF4C
	bclr.b	#$7,$FF800F.l
	movem.l	(sp)+,d0-d2
	rts
LF64	addi.w	#$9200,d0
.lF68	btst.b	#$7,$FF800E.l
	bne.b	.lF68
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.lF88	btst.b	#$6,$FF800E.l
	beq.b	.lF88
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.lFA2	btst.b	#$6,$FF800E.l
	bne.b	.lFA2
	bclr.b	#$7,$FF800F.l
	addi.w	#$9100,d1
.lFB8	btst.b	#$7,$FF800E.l
	bne.b	.lFB8
	move.w	d1,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.lFD8	btst.b	#$6,$FF800E.l
	beq.b	.lFD8
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.lFF2	btst.b	#$6,$FF800E.l
	bne.b	.lFF2
	bclr.b	#$7,$FF800F.l
	rts
; Sets up the tile window parameters (d0 position, d1 size) for a text box.
PlSetupWindow	movem.l	d0-d6,-(sp)
	moveq	#$0,d2
	move.w	d0,d1
	swap	d0
	move.w	#$7A0,d3
	bset	#$E,d3
	moveq	#$9,d4
	move.w	d4,d5
	moveq	#$A,d6
.l101E	moveq	#$0,d2
	move.w	d0,d2
	lsl.l	#$2,d2
	lsr.w	#$2,d2
	swap	d2
	addi.l	#$40000000,d2
.l102E	btst.b	#$7,$FF800E.l
	bne.b	.l102E
	move.l	d2,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.l104E	btst.b	#$6,$FF800E.l
	beq.b	.l104E
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l1068	btst.b	#$6,$FF800E.l
	bne.b	.l1068
	bclr.b	#$7,$FF800F.l
.l107A	btst.b	#$7,$FF800E.l
	bne.b	.l107A
	move.w	d3,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.l109A	btst.b	#$6,$FF800E.l
	beq.b	.l109A
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l10B4	btst.b	#$6,$FF800E.l
	bne.b	.l10B4
	bclr.b	#$7,$FF800F.l
	dbra	d4,.l107A
	move.w	d5,d4
	add.w	d1,d0
	dbra	d6,.l101E
	movem.l	(sp)+,d0-d6
	rts
; Draws the page selected by d0 (1 or 2, otherwise the default page).
PlDrawPage	movem.l	d0-d7/a0-a4,-(sp)
	move.w	$F2(a6),d2
	moveq	#$4,d3
	move.w	#$0,$E2(a6)
	move.w	#$1,$E0(a6)
	cmpi.w	#$1,d0
	beq.w	.l11C0
	cmpi.w	#$2,d0
	beq.w	.l11BA
	cmpi.w	#$4,d0
	beq.w	.l1108
	neg.w	d3
.l1108	bsr.w	PlUploadTiles
	move.w	#$E8,d7
	cmpi.w	#$8,$B8(a6)
	beq.w	.l111E
	move.w	#$F0,d7
.l111E	move.w	d7,d0
	bsr.w	PlOffsetSpriteTable
	move.w	$EE(a6),d0
	subi.w	#$2000,d0
	addi.w	#$CF8,d0
	swap	d0
	move.w	#$100,d0
	bsr.w	PlSetupWindow
	move.w	$EE(a6),d0
	subi.w	#$2000,d0
	addi.w	#$D50,d0
	swap	d0
	move.w	#$100,d0
	bsr.w	PlSetupWindow
	move.w	d2,$E2(a6)
	move.w	d3,$E0(a6)
	moveq	#$9,d0
.l115A	move.w	#$9,$DE(a6)
.l1160	tst.w	$DE(a6)
	bne.w	.l1160
	dbra	d0,.l115A
	moveq	#$1C,d0
	moveq	#$0,d1
	bsr.w	LF64
	neg.w	d7
	move.w	d7,d0
	bsr.w	PlOffsetSpriteTable
	move.w	#$50,d0
	move.w	$EE(a6),d1
	subi.w	#$2000,d1
	swap	d1
	move.w	#$100,d1
	move.l	#$B0000080,d2
	move.w	#$1B,d3
	bsr.w	PlBlitToBuffer
	move.w	$F2(a6),$E2(a6)
	move.w	#$0,$E0(a6)
	move.w	#$9,$DE(a6)
.l11AE	tst.w	$DE(a6)
	bne.w	.l11AE
	bra.w	.l11D4
.l11BA	move.w	#$FFFF,$E0(a6)
.l11C0	moveq	#$7,d1
.l11C2	move.w	#$7,$DE(a6)
.l11C8	tst.w	$DE(a6)
	bne.w	.l11C8
	dbra	d1,.l11C2
.l11D4	movem.l	(sp)+,d0-d7/a0-a4
	rts
; Fills the picture buffers with the background pattern.
PlFillBackground	movem.l	d0-d7/a0-a1,-(sp)
	movea.l	$8A(a6),a0
	move.l	#$7DF,d0
	move.l	#$33333333,d1
.l11EE	move.l	d1,(a0)+
	dbra	d0,.l11EE
	movea.l	$92(a6),a1
	move.w	#$600,d0
	bset	#$E,d0
	bset	#$F,d0
	moveq	#$1,d2
	moveq	#$0,d3
	move.b	$B6(a6),d3
	subq.w	#$1,d3
	move.w	d3,d4
	move.w	$B8(a6),d5
	subq.w	#$1,d5
	moveq	#$0,d6
	move.l	#$88,d7
.l121E	move.w	d6,$0(a1)
	move.w	d7,$6(a1)
	move.b	#$C,$2(a1)
	move.b	d2,$3(a1)
	move.w	d0,$4(a1)
	addq.b	#$1,d2
	addi.w	#$4,d0
	addi.w	#$20,d7
	lea.l	$8(a1),a1
	dbra	d3,.l121E
	move.w	d4,d3
	addi.w	#$8,d6
	move.l	#$88,d7
	dbra	d5,.l121E
	move.b	#$0,-$5(a1)
	movem.l	(sp)+,d0-d7/a0-a1
	rts
; Adds d0 to the Y position of all 80 sprite entries.
PlOffsetSpriteTable	movem.l	d1/a1,-(sp)
	movea.l	$92(a6),a1
	move.w	#$140,$E0(a6)
	move.w	#$E800,$E2(a6)
	move.l	a1,$E4(a6)
	moveq	#$4F,d1
.l127C	add.w	d0,$0(a1)
	lea.l	$8(a1),a1
	dbra	d1,.l127C
	move.w	#$1,$DE(a6)
.l128E	tst.w	$DE(a6)
	bne.w	.l128E
	movem.l	(sp)+,d1/a1
	rts
; Builds the portrait tile data from the source at $70(a6).
PlBuildPortraitTiles	movem.l	d0-d4/a0-a4,-(sp)
	movea.l	$70(a6),a0
	lea.l	$4(a0),a0
	movea.l	$8A(a6),a1
	moveq	#$0,d0
	move.b	$B6(a6),d0
	lsl.l	#$7,d0
	move.l	d0,d1
	mulu.w	$B4(a6),d0
	lea.l	(a1,d0.l),a3
	move.l	d1,d0
	movea.l	a3,a1
	move.l	d1,d2
	lsr.l	#$2,d2
	subq.l	#$1,d2
	move.l	#$33333333,d1
	move.l	d1,d4
.l12D0	move.l	d1,(a1)+
	dbra	d2,.l12D0
	movea.l	a3,a1
	moveq	#$1,d3
.l12DA	moveq	#$0,d1
	move.b	(a4)+,d1
	beq.w	.l1320
	subi.b	#$20,d1
	lsl.w	#$5,d1
	lea.l	(a0,d1.w),a2
	move.l	(a2)+,d1
	eor.l	d4,d1
	move.l	d1,(a1)+
	move.l	(a2)+,d1
	eor.l	d4,d1
	move.l	d1,(a1)+
	move.l	(a2)+,d1
	eor.l	d4,d1
	move.l	d1,(a1)+
	move.l	(a2)+,d1
	eor.l	d4,d1
	move.l	d1,(a1)+
	move.l	(a2)+,d1
	eor.l	d4,d1
	move.l	d1,(a1)+
	move.l	(a2)+,d1
	eor.l	d4,d1
	move.l	d1,(a1)+
	move.l	(a2)+,d1
	eor.l	d4,d1
	move.l	d1,(a1)+
	move.l	(a2)+,d1
	eor.l	d4,d1
	move.l	d1,(a1)+
	bra.w	.l12DA
.l1320	adda.l	#$20,a1
	dbra	d3,.l12DA
	addi.w	#$1,$B4(a6)
	movem.l	(sp)+,d0-d4/a0-a4
	rts
; Copies the tile buffer to $BC000 and queues the VRAM upload.
PlUploadTiles	movem.l	d0/a0-a1,-(sp)
	movea.l	$8A(a6),a0
	move.w	#$7DF,d0
	movea.l	#$BC000,a1
.l1348	move.l	(a0)+,(a1)+
	dbra	d0,.l1348
	move.l	#$BC000,$E4(a6)
	move.w	#$FC0,$E0(a6)
	move.w	#$C000,$E2(a6)
	move.w	#$1,$DE(a6)
.l1368	tst.w	$DE(a6)
	bne.w	.l1368
	movem.l	(sp)+,d0/a0-a1
	rts
; Picks the picture pointer for index d0 (page A or B).
PlSelectPicture	movem.l	d0-d7/a0-a2,-(sp)
	lea.l	$0(a6),a0
	lsl.w	#$2,d0
	cmpi.w	#$0,$18(a6)
	beq.w	.l138E
	lea.l	$C(a6),a0
.l138E	adda.w	d0,a0
	movea.l	(a0),a0
	lsr.w	#$2,d0
	movea.l	a0,a1
	moveq	#$0,d2
	moveq	#$0,d1
	move.w	$2(a1),d2
	lea.l	$4(a1),a1
	move.w	$FC(a6),d5
	eori.w	#$3000,d5
	move.w	d5,$FC(a6)
	lsl.w	#$4,d2
	move.w	d2,$E0(a6)
	move.w	d5,$E2(a6)
	movea.l	#$BC000,a2
	move.l	a2,$E4(a6)
	subq.w	#$1,d2
.l13C4	move.w	(a1)+,(a2)+
	dbra	d2,.l13C4
	move.w	#$1,$DE(a6)
.l13D0	tst.w	$DE(a6)
	bne.w	.l13D0
	lsr.w	#$5,d5
	cmpi.w	#$0,d0
	beq.w	.l1422
	cmpi.w	#$1,d0
	beq.w	.l1406
	move.w	#$1,$B2(a6)
	movea.l	#$BBD10,a2
	moveq	#$7,d2
.l13F8	move.l	(a1)+,(a2)+
	dbra	d2,.l13F8
	lea.l	$60(a1),a1
	bra.w	.l1448
.l1406	move.w	#$0,$B2(a6)
	movea.l	#$BBCB0,a2
	moveq	#$F,d2
.l1414	move.l	(a1)+,(a2)+
	dbra	d2,.l1414
	lea.l	$40(a1),a1
	bra.w	.l1448
.l1422	move.w	#$1,$B2(a6)
	movea.l	#$BBD10,a2
	moveq	#$7,d2
.l1430	move.l	(a1)+,(a2)+
	dbra	d2,.l1430
	movea.l	#$BBCD0,a2
	moveq	#$7,d2
.l143E	move.l	(a1)+,(a2)+
	dbra	d2,.l143E
	lea.l	$40(a1),a1
.l1448	move.l	#$EEE,$BBCF0.l
	move.l	#$EEE0444,$BBCF4.l
	move.w	#$2C,$BBD0A.l
	move.w	#$444,$BBCB0.l
	move.w	#$444,$BBCD0.l
	move.w	#$444,$BBCF0.l
	move.w	#$444,$BBD10.l
	cmpi.w	#$2,$F8(a6)
	bne.w	LF64_7
	movea.l	a1,a2
LF64Sub2	movem.l	d2,-(sp)
	move.w	$EE(a6),d3
	move.l	#$100,d6
	bsr.w	PlCopyRectToVdp
	movem.l	(sp)+,d2
	dc.w	$6000,$0022
LF64_7	move.w	#$64,$EC(a6)
.l14B0	tst.w	$EC(a6)
	bpl.w	.l14B0
	moveq	#$0,d3
	move.w	$EE(a6),d3
	move.l	#$100,d6
	movea.l	a1,a2
	bsr.w	PlCopyRectToVdp
.l14CA	movem.l	(sp)+,d0-d7/a0-a2
	rts
LF64_8	dc.b	$4E,$75	; Nu
; Decodes the picture at (a0) into the tile buffer.
PlDecodePicture	movem.l	d0-d7/a0-a4,-(sp)
	movea.l	$8(a6),a0
	cmpi.w	#$0,$18(a6)
	beq.w	.l14E8
	movea.l	$14(a6),a0
.l14E8	moveq	#$0,d0
	move.w	$2(a0),d0
	lsl.w	#$5,d0
	lea.l	(a0,d0.w),a2
	adda.l	#$84,a2
	move.w	$FC(a6),d5
	lsr.w	#$5,d5
	ori.w	#$8000,d5
	move.w	#$1,$B2(a6)
	move.w	#$B000,d3
	move.l	#$80,d6
	movea.l	a2,a1
	bsr.w	PlCopyRectToVdp
.l151A	btst.b	#$7,$FF800E.l
	bne.b	.l151A
	move.w	#$921C,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.l153C	btst.b	#$6,$FF800E.l
	beq.b	.l153C
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l1556	btst.b	#$6,$FF800E.l
	bne.b	.l1556
	bclr.b	#$7,$FF800F.l
	cmpi.w	#$4000,$FC(a6)
	beq.w	.l15B8
	move.w	#$7000,$E4(a6)
	move.w	#$4000,$E2(a6)
	move.w	#$3000,$E0(a6)
	move.w	#$6,$DE(a6)
.l158A	tst.w	$DE(a6)
	bne.w	.l158A
	move.w	#$4000,d5
	lsr.w	#$5,d5
	ori.w	#$8000,d5
	move.w	#$1,$B2(a6)
	move.w	#$B000,d3
	move.l	#$80,d6
	movea.l	a2,a1
	bsr.w	PlCopyRectToVdp
	move.w	#$4000,$FC(a6)
.l15B8	move.l	#$1000,d0
	bsr.w	PlDmaRequest
	move.l	#$20001000,d0
	bsr.w	PlDmaRequest
	move.w	#$3,$DE(a6)
.l15D2	tst.w	$DE(a6)
	bne.w	.l15D2
	move.w	#$2000,d3
	move.l	#$80,d6
	movea.l	a2,a1
	bsr.w	PlCopyRectToVdp
.l15EA	btst.b	#$7,$FF800E.l
	bne.b	.l15EA
	move.w	#$9200,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.l160C	btst.b	#$6,$FF800E.l
	beq.b	.l160C
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l1626	btst.b	#$6,$FF800E.l
	bne.b	.l1626
	bclr.b	#$7,$FF800F.l
.l1638	btst.b	#$7,$FF800E.l
	bne.b	.l1638
	move.l	#$70000003,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.l165C	btst.b	#$6,$FF800E.l
	beq.b	.l165C
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l1676	btst.b	#$6,$FF800E.l
	bne.b	.l1676
	bclr.b	#$7,$FF800F.l
.l1688	btst.b	#$7,$FF800E.l
	bne.b	.l1688
	move.w	#$4F,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.l16AA	btst.b	#$6,$FF800E.l
	beq.b	.l16AA
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l16C4	btst.b	#$6,$FF800E.l
	bne.b	.l16C4
	bclr.b	#$7,$FF800F.l
.l16D6	btst.b	#$7,$FF800E.l
	bne.b	.l16D6
	move.l	#$40000010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.l16FA	btst.b	#$6,$FF800E.l
	beq.b	.l16FA
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l1714	btst.b	#$6,$FF800E.l
	bne.b	.l1714
	bclr.b	#$7,$FF800F.l
.l1726	btst.b	#$7,$FF800E.l
	bne.b	.l1726
	move.w	#$FFB8,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.l1748	btst.b	#$6,$FF800E.l
	beq.b	.l1748
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l1762	btst.b	#$6,$FF800E.l
	bne.b	.l1762
	bclr.b	#$7,$FF800F.l
.l1774	btst.b	#$7,$FF800E.l
	bne.b	.l1774
	move.w	#$8730,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.l1796	btst.b	#$6,$FF800E.l
	beq.b	.l1796
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l17B0	btst.b	#$6,$FF800E.l
	bne.b	.l17B0
	bclr.b	#$7,$FF800F.l
LF64Sub3	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$2,d7
	movea.l	$A2(a6),a0
	jsr	$6044.w
	move.w	$7C(a6),d0
	cmpi.w	#$0,$18(a6)
	beq.w	.l17E4
	move.w	$7E(a6),d0
.l17E4	mulu.w	#$34,d0
	lea.l	PlRecordTable(pc),a0
	adda.l	d0,a0
	move.l	a0,$68(a6)
	bra.w	.l1852
.l17F6	bset.b	#$5,$FF800F.l
.l17FE	moveq	#$7,d0
	bsr.w	LEAA
	bsr.w	UpdatePad1
	move.w	d1,d5
	bsr.w	UpdatePad2
	or.w	d1,d5
	cmpi.b	#$10,d5
	bne.w	.l1822
	addi.w	#$1,$66(a6)
	bra.w	.l1852
.l1822	cmpi.b	#$20,d5
	beq.w	.l1852
	cmpi.b	#$4,d5
	beq.w	.l17FE
	cmpi.b	#$1,d5
	beq.w	.l17FE
	cmpi.b	#$2,d5
	beq.w	.l17FE
	cmpi.b	#$0,d5
	beq.w	.l17FE
	move.w	d5,$AE(a6)
	bra.w	.l188A
.l1852	movea.l	$68(a6),a0
	moveq	#$0,d1
	move.w	$66(a6),d1
	add.w	d1,d1
	add.w	d1,d1
	move.l	(a0,d1.l),d1
	cmpi.l	#$FFFFFFFF,d1
	bne.w	.l1874
	clr.w	$66(a6)
	move.l	(a0),d1
.l1874	lea.l	LF64_8(pc),a0
	move.l	#$1,d0
	move.w	#$7,d7
	jsr	$6044.w
	bra.w	.l17F6
.l188A	movea.l	$74(a6),a1
	move.w	$2(a1),d0
	lea.l	$4(a1),a1
	lsl.w	#$4,d0
	move.w	d0,$E0(a6)
	move.w	#$A000,$E2(a6)
	movea.l	#$BC000,a2
	move.l	a2,$E4(a6)
	subq.w	#$1,d0
.l18AE	move.w	(a1)+,(a2)+
	dbra	d0,.l18AE
	move.w	#$1,$DE(a6)
.l18BA	tst.w	$DE(a6)
	bne.w	.l18BA
	movem.l	(sp)+,d0-d7/a0-a6
	move.w	#$B000,d3
	move.l	#$80,d6
	movea.l	a2,a1
	bsr.w	PlCopyRectToVdp
	move.w	#$1C,$E2(a6)
	clr.w	$E0(a6)
	move.w	#$A,$DE(a6)
.l18E6	tst.w	$DE(a6)
	bne.w	.l18E6
	move.l	#$1000,d0
	bsr.w	PlDmaRequest
	move.l	#$20001000,d0
	bsr.w	PlDmaRequest
.l1902	btst.b	#$7,$FF800E.l
	bne.b	.l1902
	move.l	#$70000003,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.l1926	btst.b	#$6,$FF800E.l
	beq.b	.l1926
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l1940	btst.b	#$6,$FF800E.l
	bne.b	.l1940
	bclr.b	#$7,$FF800F.l
.l1952	btst.b	#$7,$FF800E.l
	bne.b	.l1952
	move.w	#$0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.l1974	btst.b	#$6,$FF800E.l
	beq.b	.l1974
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l198E	btst.b	#$6,$FF800E.l
	bne.b	.l198E
	bclr.b	#$7,$FF800F.l
.l19A0	btst.b	#$7,$FF800E.l
	bne.b	.l19A0
	move.w	$F2(a6),$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.l19C2	btst.b	#$6,$FF800E.l
	beq.b	.l19C2
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l19DC	btst.b	#$6,$FF800E.l
	bne.b	.l19DC
	bclr.b	#$7,$FF800F.l
.l19EE	btst.b	#$7,$FF800E.l
	bne.b	.l19EE
	move.l	#$40000010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.l1A12	btst.b	#$6,$FF800E.l
	beq.b	.l1A12
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l1A2C	btst.b	#$6,$FF800E.l
	bne.b	.l1A2C
	bclr.b	#$7,$FF800F.l
.l1A3E	btst.b	#$7,$FF800E.l
	bne.b	.l1A3E
	move.w	#$0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.l1A60	btst.b	#$6,$FF800E.l
	beq.b	.l1A60
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l1A7A	btst.b	#$6,$FF800E.l
	bne.b	.l1A7A
	bclr.b	#$7,$FF800F.l
	move.w	#$0,d3
	andi.w	#$7FFF,d5
	move.l	#$100,d6
	movea.l	a2,a1
	bsr.w	PlCopyRectToVdp
	move.w	#$4,$DE(a6)
.l1AA6	tst.w	$DE(a6)
	bne.w	.l1AA6
	move.w	$EE(a6),d3
	andi.w	#$7FFF,d5
	move.l	#$100,d6
	movea.l	a2,a1
	bsr.w	PlCopyRectToVdp
	move.l	#$1000,d0
	bsr.w	PlDmaRequest
.l1ACC	btst.b	#$7,$FF800E.l
	bne.b	.l1ACC
	move.l	#$70000003,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.l1AF0	btst.b	#$6,$FF800E.l
	beq.b	.l1AF0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l1B0A	btst.b	#$6,$FF800E.l
	bne.b	.l1B0A
	bclr.b	#$7,$FF800F.l
.l1B1C	btst.b	#$7,$FF800E.l
	bne.b	.l1B1C
	move.w	$F2(a6),$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.l1B3E	btst.b	#$6,$FF800E.l
	beq.b	.l1B3E
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l1B58	btst.b	#$6,$FF800E.l
	bne.b	.l1B58
	bclr.b	#$7,$FF800F.l
	clr.w	$E2(a6)
	clr.w	$E0(a6)
	move.w	#$A,$DE(a6)
.l1B78	tst.w	$DE(a6)
	bne.w	.l1B78
	move.l	#$B0000800,d0
	bsr.w	PlDmaRequest
	bsr.w	LCAA
	bset.b	#$5,$FF800F.l
	movem.l	(sp)+,d0-d7/a0-a4
	rts
; Unpacks 4-bit pixel data from $50(a6) into the buffer.
PlUnpackNibbles	movem.l	d0-d7/a0-a4,-(sp)
	moveq	#$0,d4
	move.w	#$500,d4
	moveq	#$0,d1
	moveq	#$0,d2
	movea.l	$50(a6),a3
	move.b	(a3),d1
	move.b	d1,d2
	lsr.b	#$4,d2
	mulu.w	#$3,d2
	add.w	d2,d2
	movea.w	d2,a2
	move.l	#$3840,d5
	moveq	#$2,d0
	moveq	#$25,d3
	movea.l	$78(a6),a0
	movea.l	a0,a1
	bsr.w	.l1C8C
	move.l	#$3844,d5
	move.w	#$500,d4
	andi.b	#$F,d1
	mulu.w	#$3,d1
	add.w	d1,d1
	movea.w	d1,a2
	moveq	#$2,d0
	moveq	#$25,d3
	movea.l	a1,a0
	bsr.w	.l1C8C
	move.l	#$3802,d5
	move.w	#$500,d4
	cmpi.b	#$47,$B7(a6)
	beq.w	.l1C72
	cmpi.b	#$44,$B7(a6)
	beq.w	.l1C4A
	cmpi.b	#$4C,$B7(a6)
	beq.w	.l1C36
	cmpi.b	#$43,$B7(a6)
	beq.w	.l1C5E
	moveq	#$7,d0
	movea.w	#$130,a2
	move.w	#$20,d3
	movea.l	a1,a0
	bsr.w	.l1C8C
	bra.w	.l1C86
.l1C36	moveq	#$7,d0
	movea.w	#$110,a2
	move.w	#$20,d3
	movea.l	a1,a0
	bsr.w	.l1C8C
	bra.w	.l1C86
.l1C4A	moveq	#$7,d0
	movea.w	#$120,a2
	move.w	#$20,d3
	movea.l	a1,a0
	bsr.w	.l1C8C
	bra.w	.l1C86
.l1C5E	moveq	#$7,d0
	movea.w	#$100,a2
	move.w	#$20,d3
	movea.l	a1,a0
	bsr.w	.l1C8C
	bra.w	.l1C86
.l1C72	moveq	#$7,d0
	movea.w	#$F0,a2
	move.w	#$20,d3
	movea.l	a1,a0
	bsr.w	.l1C8C
	bra.w	.l1C86
.l1C86	movem.l	(sp)+,d0-d7/a0-a4
	rts
.l1C8C	moveq	#$2,d7
	move.w	d0,d2
	add.w	d3,d3
	lea.l	(a0,a2.w),a0
.l1C96	move.l	d5,d6
	lsl.l	#$2,d6
	lsr.w	#$2,d6
	swap	d6
	addi.l	#$40000000,d6
.l1CA4	btst.b	#$7,$FF800E.l
	bne.b	.l1CA4
	move.l	d6,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.l1CC4	btst.b	#$6,$FF800E.l
	beq.b	.l1CC4
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l1CDE	btst.b	#$6,$FF800E.l
	bne.b	.l1CDE
	bclr.b	#$7,$FF800F.l
.l1CF0	movea.w	d4,a3
	adda.w	(a0)+,a3
.l1CF4	btst.b	#$7,$FF800E.l
	bne.b	.l1CF4
	move.w	a3,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.l1D14	btst.b	#$6,$FF800E.l
	beq.b	.l1D14
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.l1D2E	btst.b	#$6,$FF800E.l
	bne.b	.l1D2E
	bclr.b	#$7,$FF800F.l
	dbra	d0,.l1CF0
	move.w	d2,d0
	adda.w	d3,a0
	addi.l	#$100,d5
	dbra	d7,.l1C96
	rts
