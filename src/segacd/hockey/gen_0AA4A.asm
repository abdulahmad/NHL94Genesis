UpdateRecords
	dc.w	$0004,$2000
	dc.w	$4A79,$0001,$93BA
	bmi.w	LAB76
	dc.w	$4A79,$0001,$8C06
	bne.w	LAB76
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	LAD8C
	bsr.w	LADBA
	move.w	(HomeTeam).l,d1
	ext.l	d1
	movea.l	#ThreeStars,a0
	movea.l	#tmstruct,a2
	move.w	$193AA.l,d5
	move.w	(VisTeam).l,d6
	bsr.w	LAD0E
	move.w	(VisTeam).l,d1
	ext.l	d1
	movea.l	#awtmstruct,a2
	move.w	$193AC.l,d5
	move.w	(HomeTeam).l,d6
	bsr.w	LAD0E
	clr.w	d7
	movea.l	#tmstruct,a1
	dc.w	$3839,$0001,$8BF4
	dc.w	$3A39,$0001,$8BF6
	move.w	(HomeTeam).l,d1
	move.w	(VisTeam).l,d2
	move.w	$193AA.l,d6
	ext.l	d1
	movea.l	#ThreeStars,a0
	bsr.w	LAC54
	movea.l	#awtmstruct,a1
	dc.w	$3839,$0001,$8BF6
	dc.w	$3A39,$0001,$8BF4
	move.w	(VisTeam).l,d1
	move.w	(HomeTeam).l,d2
	move.w	$193AC.l,d6
	ext.l	d1
	movea.l	#ThreeStars,a0
	bsr.w	LAC54
	movea.l	#ThreeStars,a0
	dc.w	$3239,$0001,$8BF4
	ext.l	d1
	dc.w	$3439,$0001,$8BF6
	move.w	(HomeTeam).l,d3
	move.w	(VisTeam).l,d4
	movea.l	#tmstruct,a1
	movea.l	#awtmstruct,a2
	bsr.w	LAB78
	movea.l	#ThreeStars,a0
	dc.w	$3239,$0001,$8BF6
	ext.l	d1
	dc.w	$3439,$0001,$8BF4
	move.w	(VisTeam).l,d3
	move.w	(HomeTeam).l,d4
	movea.l	#awtmstruct,a1
	movea.l	#tmstruct,a2
	bsr.w	LAB78
	movem.l	(sp)+,d0-d7/a0-a6
LAB76	rts
LAB78	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	Sub_225D8
	st.b	d7
	movem.w	d0,-(sp)
	clr.w	d0
	move.b	$A(a0),d0
	lsl.w	#$8,d0
	move.b	$B(a0),d0
	cmpi.w	#$2328,d0
	bge.w	LABF0
	addi.w	#$1,d0
	move.b	d0,$B(a0)
	lsr.w	#$8,d0
	move.b	d0,$A(a0)
	move.w	$C(a1),d0
	cmp.w	$C(a2),d0
	bgt.w	LABD6
	blt.w	LABF0
	clr.w	d0
	move.b	$C(a0),d0
	lsl.w	#$8,d0
	move.b	$D(a0),d0
	addi.w	#$1,d0
	move.b	d0,$D(a0)
	lsr.w	#$8,d0
	move.b	d0,$C(a0)
	bra.w	LABF0
LABD6	clr.w	d0
	move.b	$8(a0),d0
	lsl.w	#$8,d0
	move.b	$9(a0),d0
	addi.w	#$1,d0
	move.b	d0,$9(a0)
	lsr.w	#$8,d0
	move.b	d0,$8(a0)
LABF0	movem.w	(sp)+,d0
	movem.w	d0,-(sp)
	move.w	$C(a1),d0
	cmp.w	$C(a2),d0
	movem.w	(sp)+,d0
	ble.w	LAC4A
	move.w	$C(a1),d5
	cmp.b	$0(a0),d5
	ble.w	LAC26
	st.b	d7
	move.b	d5,$0(a0)
	move.b	d3,$1(a0)
	move.b	d4,$2(a0)
	move.b	d2,$3(a0)
LAC26	move.w	$C(a2),d5
	move.w	$0(a2),d6
	sub.w	d5,d6
	cmp.b	$4(a0),d6
	ble.w	LAC4A
	st.b	d7
	move.b	d6,$4(a0)
	move.b	d3,$5(a0)
	move.b	d4,$6(a0)
	move.b	d2,$7(a0)
LAC4A	bsr.w	Sub_22616
	movem.l	(sp)+,d0-d7/a0-a6
	rts
LAC54	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	ReadCrowdRecord
	move.w	$C(a1),d3
	cmp.b	$0(a0),d3
	ble.w	LAC7A
	move.b	d3,$0(a0)
	move.b	d4,$1(a0)
	move.b	d5,$3(a0)
	move.b	d2,$2(a0)
	st.b	d7
LAC7A	subi.w	#$1,d6
	clr.w	d3
LAC80	move.w	d6,d0
	addi.w	#$EA,d0
	dc.w	$13F1,$0000,$0001,$7E62
	addi.w	#$FFCC,d0
	move.b	(a1,d0.w),d0
	dc.w	$9139,$0001,$7E62
	dc.w	$B639,$0001,$7E62
	bge.w	LACAC
	dc.w	$1639,$0001,$7E62
LACAC	dbra	d6,LAC80
	cmp.b	$4(a0),d3
	ble.w	LACCA
	st.b	d7
	move.b	d3,$4(a0)
	move.b	d4,$5(a0)
	move.b	d5,$7(a0)
	move.b	d2,$6(a0)
LACCA	cmp.w	(HomeTeam).l,d1
	bne.w	LACFE
	move.b	$8(a0),d3
	andi.w	#$FF,d3
	dc.w	$B679,$0001,$7F92
	bge.w	LACFE
	dc.w	$3639,$0001,$7F92
	st.b	d7
	move.b	d3,$8(a0)
	move.b	d4,$9(a0)
	move.b	d5,$B(a0)
	move.b	d2,$A(a0)
LACFE	tst.w	d7
	beq.w	LAD08
	bsr.w	Sub_225CC
LAD08	movem.l	(sp)+,d0-d7/a0-a6
	rts
LAD0E	clr.l	d0
	move.w	#$19,d2
LAD14	bsr.w	Sub_22534
	cmp.w	d5,d0
	blt.w	LAD2E
	move.w	d0,-(sp)
	addi.w	#$B6,d0
	move.b	(a2,d0.w),d4
	move.w	(sp)+,d0
	bra.w	LAD42
LAD2E	move.w	d0,-(sp)
	addi.w	#$EA,d0
	move.b	(a2,d0.w),d4
	addi.w	#$FFCC,d0
	sub.b	(a2,d0.w),d4
	move.w	(sp)+,d0
LAD42	move.b	$0(a0),d3
	cmp.b	d3,d4
	ble.w	LAD82
	move.b	d4,$0(a0)
	move.b	$18BF5.l,$1(a0)
	move.b	$18BF7.l,$3(a0)
	cmpa.l	#$1834C,a2
	beq.w	LAD7A
	move.b	$18BF7.l,$1(a0)
	move.b	$18BF5.l,$3(a0)
LAD7A	move.b	d6,$2(a0)
	bsr.w	Sub_22582
LAD82	addi.w	#$1,d0
	dbra	d2,LAD14
	rts
LAD8C	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a2
	dc.w	$4EB9,$0002,$ED60
	move.w	d0,$193AA.l
	movea.l	#awtmstruct,a2
	dc.w	$4EB9,$0002,$ED60
	move.w	d0,$193AC.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
LADBA	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a2
	dc.w	$4EB9,$0002,$EDBC
	move.w	d0,$193AE.l
	movea.l	#awtmstruct,a2
	dc.w	$4EB9,$0002,$EDBC
	move.w	d0,$193B0.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
AppendUserName
	movem.l	d0-d3/a0-a3,-(sp)
	movea.l	a1,a2
	tst.w	d2
	beq.w	LAE38
	move.w	#$B,d0
	clr.w	d3
	dc.w	$207C,$0001,$A2FC
	mulu.w	#$C,d2
	adda.l	d2,a0
LAE06	move.b	(a0,d3.w),d1
	bne.w	LAE12
	move.b	#$20,d1
LAE12	move.b	d1,$2(a1)
	tst.b	(a1)+
	addi.w	#$1,d3
	dbra	d0,LAE06
	move.w	#$E,(a2)
	btst	#$7,(sflags6).l
	beq.w	LAE34
	bsr.w	TrimSpaces
LAE34	bra.w	LAE4E
LAE38	movea.l	a1,a3
	move.l	a3,-(sp)
	movea.l	#$25E54,a1
	jsr	(CopyString).l
	movea.l	(sp)+,a2
	bsr.w	TrimSpaces
LAE4E	movem.l	(sp)+,d0-d3/a0-a3
	rts
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_0AE54.bin
AppendTeamName
	movem.l	d0/a0-a3,-(sp)
	ext.w	d0
	asl.w	#$2,d0
	movea.l	#TeamList,a0
	movea.l	(a0,d0.w),a0
	move.w	$4(a0),d0
	ext.l	d0
	adda.l	d0,a0
	adda.w	(a0),a0
	movea.l	a1,a3
	movea.l	a0,a1
	dc.w	$4EB9,$0003,$9208
	movem.l	(sp)+,d0/a0-a3
	rts
CalcAttrib
	move.l	a6,-(sp)
	dc.w	$4279,$0001,$A570
	dc.w	$4279,$0001,$A572
	movea.l	#$26266,a6
	cmp.l	(PAttribOverallMask).l,d4
	bne.w	LB130
	movea.l	#$26246,a6
LB130	cmp.l	(GAttribOverallMask).l,d4
	bne.w	LB140
	movea.l	#$26256,a6
LB140	movea.l	$1E(a2),a0
	lea.l	$1A4(a2),a4
	clr.l	d1
	move.w	d0,d1
	asl.w	#$4,d1
	adda.l	d1,a4
	adda.l	#$10,a4
	adda.w	$0(a0),a0
LB15A	adda.w	(a0),a0
	adda.w	#$8,a0
	dbra	d0,LB15A
	clr.w	d0
	clr.w	d1
	moveq	#$F,d2
	swap	d4
LB16C	btst	d2,d4
	beq.w	LB20A
	move.w	d2,d3
	lsr.w	#$1,d3
	neg.w	d3
	move.b	-$1(a0,d3.w),d3
	btst	#$0,d2
	beq.w	LB186
	lsr.w	#$4,d3
LB186	andi.w	#$F,d3
	cmpi.w	#$D,d2
	bne.w	LB196
	bra.w	LB204
LB196	cmpi.w	#$6,d2
	beq.w	LB204
	movem.l	d5-d7,-(sp)
	move.b	(a6,d2.w),d5
	ext.w	d5
	cmpi.w	#$2,d5
	beq.w	LB1C0
	move.w	d3,-(sp)
	subi.w	#$2,d5
LB1B6	add.w	(sp),d3
	dbra	d5,LB1B6
	asr.w	#$1,d3
	tst.w	(sp)+
LB1C0	movem.l	(sp)+,d5-d7
	cmpa.l	#$26266,a6
	beq.w	LB1EE
	neg.w	d2
	move.w	d7,-(sp)
	move.b	-$1(a4,d2.w),d7
	ext.w	d7
	dc.w	$DF79,$0001,$A570
	dc.w	$0679,$0001,$0001,$A572
	move.w	(sp)+,d7
	neg.w	d2
	bra.w	LB204
LB1EE	move.w	d3,-(sp)
	asl.w	#$4,d3
	add.w	(sp),d3
	add.w	(sp)+,d3
	neg.w	d2
	add.b	-$1(a4,d2.w),d3
	bpl.w	LB202
	clr.b	d3
LB202	neg.w	d2
LB204	add.w	d3,d0
	addi.w	#$64,d1
LB20A	dbra	d2,LB16C
	cmpa.l	#$26266,a6
	beq.w	LB236
	move.w	#$64,d1
	movem.l	d6-d7,-(sp)
	dc.w	$3C39,$0001,$A570
	ext.l	d6
	dc.w	$3E39,$0001,$A572
	divs.w	d7,d6
	add.w	d6,d0
	movem.l	(sp)+,d6-d7
LB236	cmp.w	d1,d0
	blt.w	LB242
	move.w	d0,d1
	subi.w	#$1,d0
LB242	movea.l	(sp)+,a6
	rts
	dc.w	$0202,$0202,$0406,$0204,$0204,$0606,$0402,$0202
	dc.w	$0202,$0202,$0202,$0202,$0909,$0202,$0902,$0202
	dc.w	$0202,$0202,$0202,$0202,$0202,$0202,$0202,$0202
DrawPlayerPicture
	movem.l	d0-d7/a1-a6,-(sp)
	movea.l	$47D88.l,a0
	move.w	d1,d2
	asl.w	#$2,d2
	movea.l	(a0,d2.w),a0
	move.w	#$FFFF,d2
	bra.w	LB2A4
LB290	cmp.w	$4(a0),d0
	bne.w	LB29E
	movea.l	(a0),a0
	bra.w	LB316
LB29E	adda.l	#$6,a0
LB2A4	addi.w	#$1,d2
	tst.l	(a0)
	bne.w	LB290
	movea.l	#TeamList,a0
	asl.w	#$2,d1
	movea.l	(a0,d1.w),a0
	movea.l	a0,a6
	move.w	d0,d6
	adda.w	$0(a6),a6
	bra.w	LB2CC
LB2C6	adda.w	(a6),a6
	adda.w	#$8,a6
LB2CC	dbra	d6,LB2C6
	adda.w	(a6),a6
	adda.w	$A(a0),a0
	move.w	(a0),d1
	clr.w	d3
LB2DA	addi.w	#$1,d3
	asl.w	#$4,d1
	bne.w	LB2DA
	movea.l	#$433AA,a0
	btst	#$0,$4(a6)
	bne.w	LB2FA
	movea.l	#$43714,a0
LB2FA	cmp.w	d3,d0
	blt.w	LB316
	movea.l	#$43040,a0
	btst	#$0,$4(a6)
	bne.w	LB316
	movea.l	#$42CD6,a0
LB316	movem.l	(sp)+,d0-d7/a1-a6
	rts
TrimSpaces
	movem.l	a3,-(sp)
	movea.l	a2,a3
	adda.w	(a2),a3
LB324	move.b	-(a3),d0
	cmpi.b	#$20,d0
	bne.w	LB33A
	move.b	#$0,(a3)
	subi.w	#$1,(a2)
	bra.w	LB324
LB33A	addi.w	#$1,(a2)
	andi.w	#$FE,(a2)
	movem.l	(sp)+,a3
	rts
	movem.l	d0-d7/a0-a6,-(sp)
	bclr	#$5,$FF800F.l
	move.w	#$2,d4
	move.l	#$400D0,(VBint).l
	bclr	#$0,(disflags).l
	bset	#$2,(disflags).l
	bclr	#$1,(disflags).l
	move.w	#$0,$18D30.l
	dc.w	$33FC,$B400,$0001,$8D32
	move.w	#$B800,$18D3C.l
	move.w	#$5,$18D3E.l
	dc.w	$33FC,$C000,$0001,$8D38
	move.w	#$6,(Map2col).l
	move.w	#$E000,(VmMAP1).l
	move.w	#$6,(Map1col).l
	move.w	#$0,d0
	dc.w	$4EB9,$0003,$7B5A
	bset	#$5,$FF800F.l
	dc.w	$4EB9,$0003,$7460
	move.w	d4,(framercset).l
	movea.l	(FramerMap).l,a2
	addq.l	#$8,a2
	dc.w	$4EB9,$0003,$8946
	dc.l	$91234567,$89ABCDEF
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_0B3EE.bin
NameLetterGrid
	movem.l	d0-d7/a0-a6,-(sp)
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1Pri,$1,$14
	move.w	#$16,d0
	move.w	#$7,d1
	move.w	#$7FF,d2
	dc.w	$4EB9,$0003,$8C06
	bchg	#$0,$1A567.l
	bne.w	LBA00
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1Pri,$19,$11
	movea.l	#$26DD0,a0
	moveq	#$4,d0
LB8F2	moveq	#$5,d1
	movea.l	#mesarea,a1
	move.w	#$E,(a1)+
LB8FE	move.b	(a0)+,(a1)+
	move.b	#$20,(a1)+
	dbra	d1,LB8FE
	movea.l	#mesarea,a1
	dc.w	$4EB9,$0003,$8F80
	addi.w	#$2,(printy).l
	subi.w	#$C,(printx).l
	dbra	d0,LB8F2
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font2,$1,$14
	moveq	#$16,d0
	moveq	#$7,d1
	dc.w	$4EB9,$0003,$8CA0
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1Pri,$2,$15,'D-Pad to a letter.'
	move.w	#$2,(printx).l
	addi.w	#$1,(printy).l
	move.w	(printx).l,-(sp)
	dc.w	$4EB9,$0003,$8F6E
	String	'C to select letter.'
	move.w	(sp),(printx).l
	addi.w	#$1,(printy).l
	dc.w	$4EB9,$0003,$8F6E
	String	'A to go back.'
	move.w	(sp),(printx).l
	addi.w	#$1,(printy).l
	dc.w	$4EB9,$0003,$8F6E
	String	'B to cancel.'
	move.w	(sp)+,(printx).l
	addi.w	#$1,(printy).l
	dc.w	$4EB9,$0003,$8F6E
	String	'START when done.'
LB9FA	movem.l	(sp)+,d0-d7/a0-a6
	rts
LBA00	movea.l	#$1A37C,a1
	bsr.w	GetLogName
	move.w	#$0,(printx).l
	move.w	#$F,(printy).l
	move.w	#$28,d0
	move.w	#$D,d1
	move.w	#$7FF,d2
	dc.w	$4EB9,$0003,$8C06
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font2,$1,$14
	moveq	#$16,d0
	moveq	#$7,d1
	dc.w	$4EB9,$0003,$8CA0
	bsr.w	NameEntryHelp
	bra.w	LB9FA
