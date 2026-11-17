Sub_3D770
	bclr	#$6,$63(a3)
	movea.l	#tmstruct,a0
	btst	#$6,$62(a3)
	beq.w	L2278A
	adda.w	#$366,a0
L2278A	move.b	d3,$66(a3)
	moveq	#$A,d0
	ext.w	d3
	add.w	d3,d3
	move.w	$68(a0,d3.w),d1
	bpl.w	L227A6
	moveq	#$9,d0
	cmpi.w	#$FFFE,d1
	bne.w	L227B4
L227A6	bsr.w	Sub_362D8
	bclr	#$5,$62(a3)
	clr.w	$58(a3)
L227B4	move.w	#$FFFF,$68(a0,d3.w)
	lsr.w	#$1,d3
	movea.l	$1E(a0),a0
	move.l	a0,-(sp)
	adda.w	$8(a0),a0
	clr.l	$18AE0.l
	tst.w	$34(a3)
	beq.w	L22878
	btst	#$5,$17F6C.l
	beq.w	L2280C
	jsr	(chkpk2).l
	beq.w	L227FE
	move.b	$1(a0),$18AE0.l
	andi.b	#$F,$18AE0.l
	bra.w	L2280C
L227FE	move.b	$1(a0),d0
	lsr.b	#$4,d0
	neg.b	d0
	move.b	d0,$18AE1.l
L2280C	move.b	$2(a0),d0
	andi.b	#$F,d0
	neg.b	d0
	btst	#$6,$62(a3)
	bne.w	L22826
	move.b	$2(a0),d0
	lsr.b	#$4,d0
L22826	move.b	d0,$18AE3.l
	cmpi.w	#$2,$180E4.l
	blt.w	L22878
	bgt.w	L2284E
	jsr	(GetPeriodTime).l
	lsr.w	#$1,d0
	dc.w	$B079,$0001,$80E6
	bgt.w	L22878
L2284E	dc.w	$3039,$0001,$8358
	dc.w	$9079,$0001,$86BE
	beq.w	L22870
	btst	#$6,$62(a3)
	beq.w	L2286C
	eori.b	#$8,ccr
L2286C	bpl.w	L22878
L22870	move.b	#$2,$18AE2.l
L22878	movea.l	(sp)+,a0
	adda.w	$0(a0),a0
L2287E	adda.w	(a0),a0
	adda.w	#$8,a0
	dbra	d3,L2287E
	suba.w	#$8,a0
	move.b	(a0),$6F(a3)
	move.b	$1(a0),d3
	andi.w	#$F0,d3
	lsr.w	#$1,d3
	move.b	d3,$67(a3)
	move.b	$1(a0),d3
	andi.b	#$F,d3
	dc.w	$33FC,$0003,$0001,$7E64
	jsr	(AttributeCalc).l
	move.b	d3,$68(a3)
	move.b	$2(a0),d3
	lsr.b	#$4,d3
	dc.w	$33FC,$0004,$0001,$7E64
	jsr	(AttributeCalc).l
	move.b	d3,$69(a3)
	move.b	$2(a0),d3
	andi.b	#$F,d3
	dc.w	$33FC,$0005,$0001,$7E64
	jsr	(AttributeCalc).l
	add.b	$18AE0.l,d3
	add.b	$18AE1.l,d3
	add.b	$18AE3.l,d3
	add.b	$18AE2.l,d3
	bsr.w	L22AA2
	lsr.b	#$1,d3
	eori.b	#$F,d3
	addi.b	#$F,d3
	lsr.b	#$1,d3
	move.b	d3,$6A(a3)
	move.b	$3(a0),d3
	lsr.b	#$4,d3
	dc.w	$33FC,$0006,$0001,$7E64
	jsr	(AttributeCalc).l
	add.b	$18AE3.l,d3
	bsr.w	L22AA2
	lsr.b	#$1,d3
	eori.b	#$F,d3
	addi.b	#$F,d3
	lsr.b	#$1,d3
	move.b	d3,$6B(a3)
	move.b	$3(a0),$6C(a3)
	andi.b	#$F,$6C(a3)
	move.b	$6C(a3),d3
	dc.w	$33FC,$0007,$0001,$7E64
	jsr	(AttributeCalc).l
	move.b	d3,$6C(a3)
	move.b	$4(a0),d3
	lsr.b	#$4,d3
	dc.w	$33FC,$0008,$0001,$7E64
	jsr	(AttributeCalc).l
	add.b	$18AE2.l,d3
	bsr.w	L22AA2
	move.b	d3,$75(a3)
	bclr	#$3,$4(a3)
	move.b	$4(a0),$76(a3)
	andi.b	#$1,$76(a3)
	eori.b	#$1,$76(a3)
	bne.w	L229A6
	bset	#$3,$4(a3)
L229A6	move.b	$4(a0),$74(a3)
	andi.b	#$E,$74(a3)
	move.b	$5(a0),d3
	lsr.b	#$4,d3
	dc.w	$33FC,$000A,$0001,$7E64
	jsr	(AttributeCalc).l
	add.b	$18AE0.l,d3
	add.b	$18AE1.l,d3
	add.b	$18AE3.l,d3
	bsr.w	L22AA2
	move.b	d3,$71(a3)
	move.b	$5(a0),d3
	andi.b	#$F,d3
	dc.w	$33FC,$000B,$0001,$7E64
	jsr	(AttributeCalc).l
	add.b	$18AE0.l,d3
	add.b	$18AE1.l,d3
	add.b	$18AE3.l,d3
	bsr.w	L22AA2
	move.b	d3,$6D(a3)
	move.b	$6(a0),d3
	lsr.b	#$4,d3
	dc.w	$33FC,$000C,$0001,$7E64
	jsr	(AttributeCalc).l
	move.b	d3,$72(a3)
	move.b	$6(a0),d3
	andi.b	#$F,d3
	dc.w	$33FC,$000D,$0001,$7E64
	jsr	(AttributeCalc).l
	add.b	$18AE2.l,d3
	add.b	$18AE2.l,d3
	bsr.w	L22AA2
	move.b	d3,$70(a3)
	move.b	$7(a0),d3
	lsr.b	#$4,d3
	dc.w	$33FC,$000E,$0001,$7E64
	jsr	(AttributeCalc).l
	add.b	$18AE0.l,d3
	add.b	$18AE3.l,d3
	bsr.w	L22AA2
	move.b	d3,$6E(a3)
	move.b	$7(a0),$73(a3)
	move.b	$73(a3),d3
	andi.b	#$F,d3
	dc.w	$33FC,$000F,$0001,$7E64
	jsr	(AttributeCalc).l
	move.b	d3,$73(a3)
	andi.b	#$F,$73(a3)
	rts
L22AA2	tst.b	d3
	bpl.w	L22AAA
	clr.w	d3
L22AAA	cmpi.b	#$1E,d3
	ble.w	L22AB6
	move.w	#$1E,d3
L22AB6	rts
	dc.w	$48E7,$FFFE,$0839,$0002,$0001,$8D64,$6600,$0016
	dc.w	$08B9,$0000,$0001,$8D64,$6700,$0006,$6100,$00DA
	dc.w	$6100,$931C,$0839,$0000,$0001,$7F6A,$6600,$006A
	dc.w	$0839,$0002,$0001,$7F78,$6600,$000E,$0839,$0000
	dc.w	$0001,$7F68,$6600,$0052,$0839,$0001,$0001,$7F78
	dc.w	$6600,$0052,$4A79,$0001,$80E6,$6700,$003C,$0479
	dc.w	$0AAA,$0001,$80E8,$6400,$0030,$08F9,$0003,$0001
	dc.w	$8D64,$5379,$0001,$80E6,$0C79,$003D,$0001,$80E6
	dc.w	$6E00,$0016,$0C79,$003C,$0001,$80E6,$6D00,$000A
	dc.w	$3F3C,$0002,$6100,$9626,$5279,$0001,$7474,$4CDF
	dc.w	$7FFF,$4E75,$4A79,$0001,$93B6,$6700,$FFEC,$0479
	dc.w	$0AAA,$0001,$93B8,$6400,$FFE0,$08F9,$0003,$0001
	dc.w	$8D64,$0839,$0007,$0001,$7F78,$6600,$FFCC,$5379
	dc.w	$0001,$93B6,$6000,$FFC2
vb2
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#$2,(disflags).l
	bne.w	L22BA4
	bsr.w	Sub_36DF6
L22BA4	addq.w	#$1,(ScoutSubStatus).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.w	$6100,$0064,$207C,$000B,$BD30,$3039,$0001,$7F66
	dc.w	$3239,$0001,$8D32,$6100,$9D0A,$2C79,$0001,$91CA
	dc.w	$BDFC,$0001,$8D6A,$6700,$E428,$3226,$3026,$2066
	dc.w	$6100,$9CF0,$BDFC,$0001,$8D6A,$6E00,$FFEE,$4E75
Sub_3DBF0
	movea.l	$191CA.l,a6
	cmpa.l	#$18D6A,a6
	beq.w	rtss2
L22C00	move.w	-(a6),d1
	move.w	-(a6),d0
	movea.l	-(a6),a0
	bsr.w	Sub_3777C
	cmpa.l	#$18D6A,a6
	bgt.w	L22C00
	rts
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_22C16.bin
Sub_3DD16
	movem.l	d0-d7/a0-a6,-(sp)
L22D1A	btst	#$0,(disflags).l
	bne.w	L22D1A
	movea.l	#$18D6A,a5
	bsr.w	updatescroll
	dc.w	$2C7C,$000B,$BD30
	moveq	#$1,d6
	bsr.w	checkfo
	bsr.w	checksso
	bsr.w	setsortcords
	bsr.w	setffo
	bsr.w	showclock
	bsr.w	showzam
	jsr	(AddArenaAnimSprite).l
	bsr.w	showcrowd
	bsr.w	showref
	jsr	(Crowd_Noise).l
	cmpa.l	#$BBD30,a6
	bne.w	L22D72
	clr.l	(a6)+
	clr.l	(a6)+
L22D72	clr.b	-$5(a6)
	move.l	a6,d0
	subi.l	#$BBD30,d0
	lsr.w	#$1,d0
	dc.w	$33C0,$0001,$7F66
	move.l	a5,$191CA.l
	move.l	a5,$1AD96.l
	bset	#$0,(disflags).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
updatescroll
	btst	#$7,$17F6A.l
	bne.w	rtss2
	moveq	#-64,d0
	dc.w	$9079,$0001,$7CEE
	dc.w	$3239,$0001,$7CEA
	dc.w	$33C0,$0001,$7CF0
	dc.w	$33C1,$0001,$7CF2
	dc.w	$4479,$0001,$7CF2
	dc.w	$3839,$0001,$7CEC
	asr.w	#$3,d1
	dc.w	$33C1,$0001,$7CEC
	moveq	#$1F,d3
	cmp.w	d4,d1
	beq.w	rtss2
	movea.l	$47D18.l,a0
	btst	#$4,$17F72.l
	beq.w	L22DFA
	movea.l	$47D64.l,a0
L22DFA	adda.l	$4(a0),a0
	blt.w	L22E3C
L22E02	move.w	d1,d0
	neg.w	d0
	addi.w	#$1E,d0
	andi.w	#$1F,d0
	asl.w	#$7,d0
	dc.w	$D079,$0001,$8D38
	move.w	d0,$6(a5)
	move.w	#$1E,d0
	sub.w	d1,d0
	move.w	(a0),$4(a5)
	mulu.w	(a0),d0
	add.w	d0,d0
	lea.l	$4(a0,d0.w),a1
	move.l	a1,(a5)
	adda.w	#$8,a5
	subq.w	#$1,d1
	cmp.w	d4,d1
	dbeq	d3,L22E02
	rts
L22E3C	move.w	d1,d0
	neg.w	d0
	addi.w	#$1D,d0
	andi.w	#$1F,d0
	asl.w	#$7,d0
	dc.w	$D079,$0001,$8D38
	move.w	d0,$6(a5)
	move.w	#$3D,d0
	sub.w	d1,d0
	move.w	(a0),$4(a5)
	mulu.w	(a0),d0
	add.w	d0,d0
	lea.l	$4(a0,d0.w),a1
	move.l	a1,(a5)
	adda.w	#$8,a5
	addq.w	#$1,d1
	cmp.w	d4,d1
	dbeq	d3,L22E3C
	rts
showref
	bclr	#$1,$17F6C.l
	beq.w	rtss2
	movea.l	#$18074,a0
	movea.l	#VmMAP1,a1
	move.w	$2(a1),d2
	moveq	#$2,d0
	btst	#$7,$17F6A.l
	beq.w	L22EA2
	moveq	#$F,d0
L22EA2	asl.w	d2,d0
	moveq	#$2,d1
	asl.w	d2,d1
	addi.w	#$2,d0
	btst	#$7,$17F6A.l
	beq.w	L22EBC
	addi.w	#$B,d0
L22EBC	asl.w	#$1,d0
	add.w	(a1),d0
	moveq	#$7,d2
L22EC2	move.l	a0,(a5)+
	move.w	#$7,(a5)+
	move.w	d0,(a5)+
	adda.w	#$E,a0
	add.w	d1,d0
	dbra	d2,L22EC2
	rts
checkfo
	btst	#$0,$17F6A.l
	bne.w	rtss2
	btst	#$4,(disflags).l
	beq.w	rtss2
	dc.w	$267C,$0001,$7CF8
	moveq	#$2,d0
L22EF6	move.w	(a3),d4
	bmi.w	L22F98
	beq.w	L22F98
	movea.l	$47D30.l,a2
	adda.l	$4(a2),a2
	add.w	d4,d4
	move.w	$2(a2,d4.w),d5
	sub.w	(a2,d4.w),d5
	lsr.w	#$3,d5
	subi.w	#$1,d5
	adda.w	(a2,d4.w),a2
L22F1E	move.w	$2(a2),d2
	addi.w	#$80,d2
	dc.w	$D479,$0001,$746E
	move.w	d2,(a6)
	move.w	(a2),d2
	btst	#$3,$2(a3)
	beq.w	L22F4C
	move.b	$7(a2),d2
	andi.w	#$C,d2
	addi.w	#$4,d2
	asl.w	#$1,d2
	neg.w	d2
	sub.w	(a2),d2
L22F4C	addi.w	#$80,d2
	dc.w	$D479,$0001,$746C
	move.w	d2,$6(a6)
	move.b	$7(a2),$2(a6)
	move.b	d6,$3(a6)
	move.w	$6(a2),d2
	andi.w	#$F800,d2
	or.w	$4(a2),d2
	move.w	$2(a3),d1
	andi.w	#$F800,d1
	eor.w	d1,d2
	dc.w	$D479,$0001,$8D4C
	move.w	d2,$4(a6)
	addi.w	#$1,d6
	adda.w	#$8,a6
	adda.w	#$8,a2
	dbra	d5,L22F1E
	adda.w	#$4,a3
L22F98	dbra	d0,L22EF6
	rts
showzam
	move.w	$17CE2.l,d0
	bmi.w	rtss2
	movea.l	$47D34.l,a0
	lsr.w	#$2,d0
	move.w	#$12A,d1
	moveq	#$1,d2
	dc.w	$3639,$0001,$8D56
	bsr.w	Sub_3E028
	move.w	d0,d2
	lsr.w	#$1,d2
	ext.l	d2
	divu.w	#$3,d2
	swap	d2
	addi.w	#$2,d2
	bsr.w	Sub_3E028
	moveq	#$5,d2
	dc.w	$3839,$0001,$8358
	dc.w	$B879,$0001,$86BE
	bls.w	Sub_3E028
	move.w	d0,d2
	subi.w	#$DA,d2
	bpl.w	L22FF2
	clr.w	d2
L22FF2	lsr.w	#$2,d2
	add.w	d2,d2
	cmpi.w	#$1A,d2
	blt.w	L23000
	moveq	#$18,d2
L23000	lea.l	$3E00E.l,a1
	move.w	(a1,d2.w),d2
	bra.w	Sub_3E028
	dc.w	$0005,$0006,$0007,$0008,$0007,$0008,$0007,$0008
	dc.w	$0007,$0008,$0007,$0006,$0005
Sub_3E028
	cmpi.w	#$40,d6
	bge.w	rtss2
	movem.l	d0-d5/a0,-(sp)
	adda.l	$4(a0),a0
	add.w	d2,d2
	move.w	$2(a0,d2.w),d4
	sub.w	(a0,d2.w),d4
	lsr.w	#$3,d4
	subi.w	#$1,d4
	adda.w	(a0,d2.w),a0
L2304C	move.w	$2(a0),(a6)
	add.w	d1,(a6)+
	move.b	$7(a0),(a6)+
	move.b	d6,(a6)+
	move.w	$6(a0),d2
	andi.w	#$F800,d2
	add.w	$4(a0),d2
	add.w	d3,d2
	move.w	d2,(a6)+
	move.w	(a0),(a6)
	add.w	d0,(a6)+
	addi.w	#$1,d6
	cmpi.w	#$40,d6
	beq.w	L23080
	adda.w	#$8,a0
	dbra	d4,L2304C
L23080	movem.l	(sp)+,d0-d5/a0
	rts
showcrowd
	btst	#$4,$17F72.l
	bne.w	L231CC
	movea.l	$47D2C.l,a1
	adda.l	$4(a1),a1
	dc.w	$3839,$0001,$7CEE
	dc.w	$3A39,$0001,$7CEA
	btst	#$7,$17F6A.l
	beq.w	L230BC
	moveq	#-64,d4
	move.l	#$100,d5
L230BC	clr.w	d0
	dc.w	$1439,$0001,$8068
	moveq	#$1A,d3
	bsr.w	L230EC
	dc.w	$1439,$0001,$8068
	lsr.w	#$4,d2
	moveq	#$1D,d3
	bsr.w	L230EC
	move.b	(Crowdframe).l,d0
	bsr.w	L2310C
	move.b	$17CD1.l,d0
	bra.w	L2310C
L230EC	andi.w	#$F,d2
	cmpi.w	#$3,d2
	bls.w	L230FA
	moveq	#$3,d2
L230FA	bra.w	L23106
L230FE	move.w	d3,d0
	add.w	d2,d0
	bsr.w	L2310C
L23106	dbra	d2,L230FE
	rts
L2310C	ext.w	d0
	beq.w	rtss2
	btst	#$7,$17F6A.l
	beq.w	L23122
	addi.w	#$1F,d0
L23122	cmpi.w	#$40,d6
	bge.w	rtss2
	movem.l	d0-d5,-(sp)
	add.w	d0,d0
	movea.l	a1,a0
	move.w	$2(a0,d0.w),d1
	sub.w	(a0,d0.w),d1
	lsr.w	#$3,d1
	subi.w	#$1,d1
	move.w	d1,-(sp)
	adda.w	(a0,d0.w),a0
	move.w	d4,d0
	addi.w	#$C0,d0
	move.w	d0,d1
	subi.w	#$90,d0
	addi.w	#$80,d1
	move.w	#$170,d2
	sub.w	d5,d2
	move.w	d2,d3
	subi.w	#$80,d2
	addi.w	#$70,d3
	move.w	(sp)+,d4
L23168	cmp.w	$2(a0),d2
	bgt.w	L231C0
	cmp.w	$2(a0),d3
	blt.w	L231C0
	cmp.w	(a0),d0
	bgt.w	L231C0
	cmp.w	(a0),d1
	blt.w	L231C0
	move.w	$2(a0),d5
	addi.w	#$70,d5
	sub.w	d2,d5
	move.w	d5,(a6)+
	move.b	$7(a0),(a6)+
	move.b	d6,(a6)+
	move.w	$6(a0),d5
	andi.w	#$F800,d5
	add.w	$4(a0),d5
	dc.w	$DA79,$0001,$8D4A
	move.w	d5,(a6)+
	move.w	(a0),d5
	addi.w	#$70,d5
	sub.w	d0,d5
	move.w	d5,(a6)+
	addi.w	#$1,d6
	cmpi.w	#$40,d6
	beq.w	L231C8
L231C0	adda.w	#$8,a0
	dbra	d4,L23168
L231C8	movem.l	(sp)+,d0-d5
L231CC	rts
showclock
	btst	#$7,$17F6A.l
	beq.w	Sub_3E29C
	btst	#$0,$17F78.l
	bne.w	L23260
	move.l	a1,-(sp)
	jsr	(printz).l
	String	CC_Font2Pri,$D,$5
	dc.w	$3039,$0001,$80E6
	ext.l	d0
	divu.w	#$258,d0
	move.l	d0,-(sp)
	tst.w	d0
	bne.w	L23214
	addi.w	#$1,(printx).l
	bra.w	L2321A
L23214	jsr	$3E262.l
L2321A	move.l	(sp)+,d0
	swap	d0
	ext.l	d0
	divu.w	#$3C,d0
	move.l	d0,-(sp)
	jsr	$3E262.l
	move.l	(sp)+,d0
	swap	d0
	ext.l	d0
	addi.w	#$2,(printx).l
	divu.w	#$A,d0
	move.l	d0,-(sp)
	jsr	$3E262.l
	move.l	(sp)+,d0
	swap	d0
	ext.l	d0
	jsr	$3E262.l
	movea.l	(sp)+,a1
	jsr	(printz).l
	String	CC_Font3Pri,$D,$5
L23260	rts
	movea.l	#$3E274,a1
	asl.w	#$2,d0
	adda.w	d0,a1
	jsr	(print).l
	rts
	dc.w	$0004,$3000,$0004,$3100,$0004,$3200,$0004,$3300
	dc.w	$0004,$3400,$0004,$3500,$0004,$3600,$0004,$3700
	dc.w	$0004,$3800,$0004,$3900
Sub_3E29C
	bclr	#$3,(disflags).l
	beq.w	rtss2
	btst	#$3,$17F6C.l
	bne.w	rtss2
	cmpi.w	#$4,$180E4.l
	beq.w	rtss2
	movea.l	#$17EDA,a0
	movea.l	(SmallFontMap).l,a1
	adda.l	$4(a1),a1
	move.w	$78(a1),d0
	dc.w	$D079,$0001,$8D42
	ori.w	#$8000,d0
	dc.w	$33C0,$0001,$7ED4
	dc.w	$3039,$0001,$80E6
	btst	#$1,$17F78.l
	beq.w	L232FC
	dc.w	$3039,$0001,$93B6
L232FC	ext.l	d0
	divu.w	#$A,d0
	bsr.w	L23360
	divu.w	#$6,d0
	bsr.w	L23360
	suba.w	#$2,a0
	divu.w	#$A,d0
	bsr.w	L23360
	swap	d0
	tst.l	d0
	bne.w	L23326
	moveq	#-16,d0
	swap	d0
L23326	bsr.w	L23360
	move.l	a0,(a5)+
	move.w	#$5,(a5)+
	movea.l	#VmMAP1,a1
	moveq	#$18,d0
	moveq	#$3,d2
	btst	#$7,$17F6A.l
	beq.w	L23350
	dc.w	$227C,$0001,$8D38
	moveq	#$5,d0
	moveq	#$D,d2
L23350	move.w	$2(a1),d1
	asl.w	d1,d0
	add.w	d2,d0
	asl.w	#$1,d0
	add.w	(a1),d0
	move.w	d0,(a5)+
	rts
L23360	swap	d0
	asl.w	#$1,d0
	move.w	$64(a1,d0.w),d0
	dc.w	$D079,$0001,$8D42
	ori.w	#$8000,d0
	move.w	d0,-(a0)
	swap	d0
	ext.l	d0
	rts
checksso
	btst	#$7,$17F6A.l
	bne.w	rtss2
	movea.l	#$17D20,a0
	movea.l	#$17DD8,a3
	move.w	#$180,d3
	bsr.w	L233DE
	adda.w	#$1C,a0
	adda.w	#$14,a3
	move.w	#$183,d3
	bsr.w	L233DE
	dc.w	$4A79,$0001,$7FAA
	beq.w	rtss2
	movea.l	#$17D74,a0
	adda.w	#$14,a3
	move.w	#$346,d3
	bsr.w	L233DE
	dc.w	$4A79,$0001,$7FAC
	beq.w	rtss2
	movea.l	#$17D90,a0
	adda.w	#$14,a3
	move.w	#$349,d3
L233DE	tst.w	$18(a0)
	bmi.w	rtss2
	st.b	$6(a3)
	move.w	$0(a0),d0
	btst	#$0,$17F78.l
	bne.w	L23412
	btst	#$3,$17F6C.l
	bne.w	L23412
	btst	#$2,$17F70.l
	beq.w	L2342A
L23412	move.w	d0,-(sp)
	tst.w	d0
	bpl.w	L2341C
	neg.w	d0
L2341C	cmpi.w	#$A6,d0
	blt.w	L23428
	move.w	(sp)+,d0
	rts
L23428	move.w	(sp)+,d0
L2342A	move.w	$14(a0),d1
	btst	#$7,$17F6A.l
	beq.w	L23446
	exg.l	d0,d1
	neg.w	d0
	subi.w	#$C5,d1
	bra.w	L23452
L23446	dc.w	$9079,$0001,$7CEE
	dc.w	$9279,$0001,$7CEA
L23452	clr.w	d2
	cmpi.w	#$74,d0
	blt.w	L23460
	bset	#$3,d2
L23460	cmpi.w	#$FF8C,d0
	bgt.w	L2346C
	bset	#$2,d2
L2346C	cmpi.w	#$64,d1
	blt.w	L23478
	bset	#$0,d2
L23478	cmpi.w	#$FF9C,d1
	bgt.w	L23484
	bset	#$1,d2
L23484	tst.w	d2
	beq.w	rtss2
	movea.l	#$37588,a1
	move.b	(a1,d2.w),d2
	asl.w	#$3,d2
	movea.l	#$3E4D4,a1
	move.w	(a1,d2.w),d4
	beq.w	L234A6
	move.w	d4,d0
L234A6	addi.w	#$100,d0
	move.w	d0,$0(a3)
	move.w	$2(a1,d2.w),d4
	beq.w	L234B8
	move.w	d4,d1
L234B8	neg.w	d1
	addi.w	#$F0,d1
	move.w	d1,$2(a3)
	add.w	$4(a1,d2.w),d3
	move.w	d3,$6(a3)
	move.w	$6(a1,d2.w),$4(a3)
	bra.w	Sub_3E6E6
	dc.w	$0000,$0064,$0000,$0000,$0074,$0064,$0001,$0000
	dc.w	$0074,$0000,$0002,$0000,$0074,$FF9C,$0001,$1000
	dc.w	$0000,$FF9C,$0000,$1000,$FF8C,$FF9C,$0001,$1800
	dc.w	$FF8C,$0000,$0002,$0800,$FF8C,$0064,$0001,$0800
setsortcords
	movea.l	#$17CC0,a4
	move.w	#$F,d0
L2351E	clr.w	d1
	move.b	(a4)+,d1
	asl.w	#$6,d1
	dc.w	$267C,$0001,$7480
	adda.w	d1,a3
	bsr.w	Sub_3E6BC
	dbra	d0,L2351E
	rts
setffo
	bsr.w	uppads
	move.w	#$6,d0
	movea.l	#$17D04,a3
L23544	movea.l	a6,a0
	bsr.w	Sub_3E6BC
	cmpa.l	a6,a0
	beq.w	L2355C
	move.w	$2(a3),d1
	add.w	d1,$6(a0)
	add.w	d1,$E(a0)
L2355C	adda.w	#$1C,a3
	dbra	d0,L23544
	rts
uppads
	movea.l	#$17DAC,a0
	st.b	$18(a0)
	move.b	$17E32.l,d0
	beq.w	L23594
	move.b	$17E33.l,d1
	ext.w	d0
	asl.w	#$2,d0
	move.w	d0,$0(a0)
	ext.w	d1
	asl.w	#$2,d1
	move.w	d1,$14(a0)
	clr.w	$18(a0)
L23594	move.w	#$5,d4
	movea.l	#$17D04,a0
	movea.l	#$17DCA,a1
	dc.w	$247C,$0001,$7480
	dc.w	$3639,$0001,$7DC8
L235B0	cmpi.w	#$1,d4
	bne.w	L235C4
	dc.w	$3639,$0001,$7DD6
	lsr.w	#$4,d3
	bra.w	L235C4
L235C4	move.w	d3,d0
	andi.w	#$F,d0
	move.w	#$F,d1
	cmpi.w	#$E,d0
	beq.w	L235FE
	st.b	$18(a0)
	cmpi.w	#$F,d0
	beq.w	L2360A
	asl.w	#$7,d0
	move.w	(a2,d0.w),$0(a0)
	move.w	$14(a2,d0.w),$14(a0)
	clr.w	$18(a0)
	move.b	$35(a2,d0.w),d1
	asl.w	#$8,d1
	move.b	$6F(a2,d0.w),d1
L235FE	cmp.w	(a1),d1
	beq.w	L2360A
	move.w	d1,(a1)
	bsr.w	QueuePadLabel
L2360A	lsr.w	#$4,d3
	adda.w	#$1C,a0
	adda.w	#$2,a1
	dbra	d4,L235B0
	rts
QueuePadLabel
	dc.w	$49FA,$0098
	clr.w	$2(a0)
	move.w	d1,d2
	lsr.w	#$4,d2
	andi.w	#$F,d2
	bne.w	L23638
	move.w	#$FFF0,d2
	subi.w	#$4,$2(a0)
L23638	addi.w	#$30,d2
	clr.w	d0
	bsr.w	uppads_pd
	move.w	d1,d2
	andi.w	#$F,d2
	cmpi.w	#$F,d2
	bne.w	L23654
	move.w	#$FFF0,d2
L23654	addi.w	#$30,d2
	moveq	#$1,d0
	bsr.w	uppads_pd
	move.w	d1,d2
	btst	#$7,$17F7A.l
	beq.w	L2366E
	clr.w	d2
L2366E	lsr.w	#$8,d2
	andi.w	#$7,d2
	bne.w	L2367E
	addi.w	#$4,$2(a0)
L2367E	move.b	(a4,d2.w),d2
	moveq	#$2,d0
uppads_pd
	movea.l	(SmallFontMap).l,a3
	adda.l	$4(a3),a3
	add.w	d2,d2
	move.w	$4(a3,d2.w),d2
	andi.w	#$7FF,d2
	asl.w	#$5,d2
	movea.l	(SmallFontMap).l,a3
	lea.l	$A(a3,d2.w),a3
	move.l	a3,(a5)+
	move.w	#$10,(a5)+
	add.w	$12(a0),d0
	asl.w	#$5,d0
	move.w	d0,(a5)+
	rts
	dc.w	$2044,$444C,$4352,$5800
Sub_3E6BC
	movem.l	d0-d2,-(sp)
	move.w	$0(a3),d0
	move.w	$14(a3),d1
	move.w	$18(a3),d2
	bmi.w	L236E0
	bsr.w	find3d
	cmpi.w	#$4E20,d1
	beq.w	L236E0
	bsr.w	Sub_3E6E6
L236E0	movem.l	(sp)+,d0-d2
	rts
