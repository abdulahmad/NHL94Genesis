ChkShotStat
	btst	#$0,$17F68.l
	bne.w	rtss2
	btst	#$4,$17F68.l
	bne.w	rtss2
	bclr	#$4,$17F6C.l
	bne.w	L218B8
	btst	#$0,$17F72.l
	beq.w	rtss2
	bclr	#$3,$17F7C.l
	bne.w	L21866
	bset	#$3,$17F7C.l
	bra.w	rtss2
L21866	movem.l	d0-d1/a1-a3,-(sp)
	move.l	a4,-(sp)
	dc.w	$287C,$0001,$80EC
	dc.w	$D8F9,$0001,$80F0
	movea.l	#tmstruct,a2
	btst	#$7,$2(a4)
	beq.w	L2188C
	adda.w	#$366,a2
L2188C	clr.w	d0
	move.b	$3(a4),d0
	movea.l	(sp)+,a4
	movea.l	$22(a2),a2
	move.w	#$5,d1
L2189C	cmp.b	$66(a2),d0
	beq.w	L218B0
	adda.w	#$80,a2
	dbra	d1,L2189C
	bra.w	L21952
L218B0	move.w	$52(a2),d0
	bra.w	L218D2
L218B8	movem.l	d0-d1/a1-a3,-(sp)
	addi.w	#$64,(Crowdlevel).l
	dc.w	$0679,$000A,$0001,$7CD8
	dc.w	$3039,$0001,$7E28
L218D2	asl.w	#$7,d0
	dc.w	$267C,$0001,$7480
	adda.w	d0,a3
	bsr.w	L21958
	addi.w	#$1,$0(a2)
	btst	#$5,$17F6C.l
	beq.w	L2191C
	btst	#$6,$17F6C.l
	bne.w	L21912
	btst	#$6,$62(a3)
	bne.w	L2191C
L21908	addi.w	#$1,$356(a2)
	bra.w	L2191C
L21912	btst	#$6,$62(a3)
	bne.w	L21908
L2191C	move.l	a2,-(sp)
	move.w	$180E4.l,d0
	add.w	d0,d0
	adda.w	d0,a2
	addi.w	#$1,$34C(a2)
	movea.l	(sp)+,a2
	clr.w	d0
	move.b	$66(a3),d0
	addi.w	#$EA,d0
	addi.b	#$1,(a2,d0.w)
	move.w	$28(a1),d0
	bmi.w	L21952
	addi.w	#$EA,d0
	addi.b	#$1,(a1,d0.w)
L21952	movem.l	(sp)+,d0-d1/a1-a3
	rts
L21958	movea.l	#tmstruct,a2
	lea.l	$366(a2),a1
	btst	#$6,$62(a3)
	beq.w	rtss2
	exg.l	a1,a2
	rts
SetupTeamForIntermission
	bsr.w	ResetBench
	movea.l	#tmstruct,a2
	lea.l	$366(a2),a3
	bsr.w	L21984
	exg.l	a2,a3
L21984	bsr.w	reenergizeteam
	clr.w	$16(a3)
	dc.w	$4A79,$0001,$8C0A
	bne.w	rtss2
	move.w	$26(a3),d0
	sub.w	$26(a2),d0
	beq.w	rtss2
	move.w	#$3,$16(a3)
	tst.w	d0
	bpl.w	rtss2
	move.w	#$5,$16(a3)
	rts
RestoreTeamEnergy
	moveq	#$32,d0
L219B8	cmpi.w	#$FFFD,$68(a2,d0.w)
	bne.w	L219D0
	cmpi.w	#$FFFC,$68(a2,d0.w)
	bne.w	L219D0
	bra.w	L219D6
L219D0	move.w	#$1000,$34(a2,d0.w)
L219D6	subi.w	#$2,d0
	bpl.w	L219B8
	rts
reenergizeteam
	moveq	#$32,d0
L219E2	cmpi.w	#$FFFC,$68(a2,d0.w)
	beq.w	L21A02
	move.w	#$1000,$34(a2,d0.w)
	cmpi.w	#$FFFD,$68(a2,d0.w)
	bne.w	L21A02
	move.w	#$FFFE,$68(a2,d0.w)
L21A02	subi.w	#$2,d0
	bpl.w	L219E2
	rts
Intermission
	cmpi.w	#$4,$180E4.l
	bne.w	L21A26
	dc.w	$33FC,$0000,$0001,$80E6
	jsr	$25A4E.l
L21A26	bsr.w	SetupTeamForIntermission
	moveq	#$F,d0
	dc.w	$207C,$0001,$7480
L21A32	clr.w	$0(a0)
	adda.w	#$80,a0
	dbra	d0,L21A32
	dc.w	$3839,$0001,$8D56
	movea.l	$47D34.l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain
	move.w	#$140,$17CE2.l
	move.w	$180E4.l,d0
	dc.w	$4A79,$0001,$8BFA
	beq.w	L21A6C
	addi.w	#$5,d0
L21A6C	asl.w	#$2,d0
	dc.w	$41FA,$00B8
	movea.l	(a0,d0.w),a0
	btst	#$0,$17F78.l
	beq.w	L21A88
	movea.l	#$42250,a0
L21A88	bset	#$0,$17F6A.l
	movea.l	#$2C1F8,a1
	jsr	(Sub_2C2F8).l
	bsr.w	GetShifter
	dc.w	$33C1,$0001,$8ADE
	bset	#$5,$FF800F.l
L21AAE	dc.w	$4A79,$0001,$8ADE
	bmi.w	L21AEC
	bsr.w	Sub_3CD00
	bsr.w	NewTicker3
	move.w	#$96,d0
	bsr.w	waitxsr
	btst	#$7,d1
	bne.w	L21AE4
	bsr.w	Sub_3CE8C
	move.w	#$3C,d0
	bsr.w	waitxsr
	btst	#$7,d1
	beq.w	L21AAE
L21AE4	bset	#$3,$17F6E.l
L21AEC	bsr.w	DoHiLights
	bclr	#$3,$17F6E.l
	bne.w	L21B20
L21AFC	move.w	#$1E0,d0
	bsr.w	waitxsr
	btst	#$7,d1
	bne.w	L21B20
	dc.w	$4A79,$0001,$7FA6
	bne.w	L21AFC
	dc.w	$4A79,$0001,$7FA8
	bne.w	L21AFC
L21B20	st.b	$17CE2.l
	rts
	dc.w	$0004,$22D4,$0004,$2454,$0004,$2454,$0004,$2454
	dc.w	$0004,$25B0,$0004,$2388,$0004,$2454,$0004,$2454
	dc.w	$0004,$2454,$0004,$26C4
InitScores
	dc.w	$0C79,$0001,$0001,$8A9E
	bgt.w	rtss2
	bsr.w	GetShifter
	movea.l	#$18A18,a0
	moveq	#$10,d0
	mulu.w	d1,d0
	adda.w	d0,a0
L21B6C	dc.w	$B279,$0001,$8A98
	beq.w	L21B96
	btst	#$2,$E(a0)
	bne.w	L21B96
	clr.w	$8(a0)
	moveq	#$3,d0
	bsr.w	randomd0
	bra.w	L21B92
L21B8E	bsr.w	SetScore
L21B92	dbra	d0,L21B8E
L21B96	suba.w	#$10,a0
	dbra	d1,L21B6C
	rts
UpdateScores
	bsr.w	GetShifter
	dc.w	$33C1,$0001,$8ADE
	movea.l	#$18A18,a0
	moveq	#$10,d0
	mulu.w	d1,d0
	adda.w	d0,a0
L21BB6	dc.w	$B279,$0001,$8A98
	beq.w	L21BD4
	bclr	#$1,$E(a0)
	btst	#$2,$E(a0)
	bne.w	L21BD4
	bsr.w	SetScore
L21BD4	suba.w	#$10,a0
	dbra	d1,L21BB6
	rts
SetScore
	cmpi.w	#$4,$8(a0)
	bge.w	rtss2
	movem.l	d0-d1/a0-a1,-(sp)
	cmpi.w	#$3,$8(a0)
	bne.w	L21C24
	move.w	#$5,$8(a0)
	move.w	$A(a0),d0
	sub.w	$C(a0),d0
	cmpi.w	#$1,d0
	bgt.w	L21C4A
	cmpi.w	#$FFFF,d0
	blt.w	L21C4A
	move.w	#$3,$8(a0)
	bset	#$1,$E(a0)
	bra.w	L21C4A
L21C24	addi.w	#$1,$8(a0)
	move.w	$0(a0),d0
	move.w	$2(a0),d1
	bsr.w	L21C50
	add.w	d0,$A(a0)
	move.w	$2(a0),d0
	move.w	$0(a0),d1
	bsr.w	L21C50
	add.w	d0,$C(a0)
L21C4A	movem.l	(sp)+,d0-d1/a0-a1
	rts
L21C50	asl.w	#$2,d0
	movea.l	#TeamList,a1
	movea.l	(a1,d0.w),a1
	adda.w	$8(a1),a1
	move.b	(a1),d0
	andi.w	#$70,d0
	lsr.w	#$1,d0
	dc.w	$43FA,$0048
	move.l	(a1,d0.w),$18BE8.l
	move.l	$4(a1,d0.w),$18BEC.l
	asl.w	#$2,d1
	movea.l	#TeamList,a1
	movea.l	(a1,d1.w),a1
	adda.w	$8(a1),a1
	move.b	(a1),d0
	andi.w	#$7,d0
	asl.w	#$3,d0
	dc.w	$43FA,$001C
	move.l	(a1,d0.w),d1
	add.l	d1,$18BE8.l
	move.l	$4(a1,d0.w),d1
	add.l	d1,$18BEC.l
	moveq	#$4,d0
	bra.w	WeightedRandomSelect
NewTicker
	ori.b	#$1E,$17(a3)
	ori.b	#$27,d4
	ori.b	#$18,-(a0)
	ori.b	#$23,d5
	ori.b	#$1A,-(a1)
	ori.b	#$1E,d6
	ori.b	#$1E,-(a2)
	ori.b	#$1A,d6
	ori.b	#$1E,-(a4)
	dc.w	$0008,$0016,$0025,$001F,$000A,$0013,$0026,$001F
	dc.w	$000C,$000F,$0026,$0020,$000F
Sub_3CCF2
	moveq	#-1,d3
	dc.w	$0C79,$01E0,$0001,$80E6
	bgt.w	rtss2
Sub_3CD00
	dc.w	$3639,$0001,$8ADE
	bmi.w	rtss2
	dc.w	$0479,$0001,$0001,$8ADE
	dc.w	$B679,$0001,$8A98
	beq.w	Sub_3CD00
CheckGameTickerStatus
	moveq	#$10,d0
	mulu.w	d3,d0
	movea.l	#$18A18,a0
	adda.w	d0,a0
	btst	#$1,$E(a0)
	bne.w	Sub_3CD00
	btst	#$2,$E(a0)
	bne.w	Sub_3CD00
	rts
NewTicker3
	tst.w	d3
	bmi.w	rtss2
	bsr.w	SetTickerAreaPosition
	bsr.w	Framer
	addi.w	#$1,(printx).l
	subi.w	#$4,(printy).l
	move.w	(printx).l,-(sp)
	bsr.w	GetShifter
	move.w	#$A000,(printa).l
	bsr.w	printz
	String	'                        '
	move.w	(sp),(printx).l
	moveq	#$1,d0
	dc.w	$D079,$0001,$8A9E
	dc.w	$4A79,$0001,$8BFA
	bne.w	L21DA6
	clr.w	d0
L21DA6	dc.w	$43FA,$0094
	bsr.w	Sub_3CEBE
	move.w	$8(a0),d0
	subi.w	#$1,d0
	movea.l	#$41A34,a1
	bsr.w	Sub_3CEC6
	move.w	(a1),d0
	lsr.w	#$1,d0
	neg.w	d0
	add.w	(sp),d0
	addi.w	#$17,d0
	move.w	d0,(printx).l
	bsr.w	print
	move.w	#$8000,(printa).l
	move.w	$2(a0),d0
	move.w	$C(a0),d1
	bsr.w	L21DFC
	move.w	$0(a0),d0
	move.w	$A(a0),d1
	bsr.w	L21DFC
	adda.w	#$2,sp
	rts
L21DFC	move.w	$4(sp),(printx).l
	addi.w	#$1,(printy).l
	movea.l	#TeamList,a1
	asl.w	#$2,d0
	movea.l	(a1,d0.w),a1
	adda.w	$4(a1),a1
	bsr.w	print
	move.w	$4(sp),(printx).l
	addi.w	#$15,(printx).l
	move.w	d1,d0
	moveq	#$2,d1
	bsr.w	PushNumberWidth
	bra.w	print
	dc.w	$0012,$4541,$2048,$6F63,$6B65,$7920,$4E69,$6768
	dc.w	$7400,$0018,$5374,$616E,$6C65,$7920,$4375,$7020
	dc.w	$5175,$616C,$6966,$6965,$7200,$000E,$5175,$6172
	dc.w	$7465,$7266,$696E,$616C,$0018,$5374,$616E,$6C65
	dc.w	$7920,$4375,$7020,$5365,$6D69,$6669,$6E61,$6C00
Sub_3CE8C
	bsr.w	SetTickerAreaPosition
	move.w	#$7FF,d2
	bra.w	eraser
SetTickerAreaPosition
	bsr.w	printz
	String	CC_Font3Pri,$3,$17
	btst	#$0,$17F6A.l
	bne.w	L21EB8
	bsr.w	printz
	String	CC_Font1Pri,$3,$17
L21EB8	moveq	#$1A,d0
	moveq	#$5,d1
	rts
Sub_3CEBE
	bsr.w	Sub_3CEC6
	bra.w	printsmall
Sub_3CEC6
	bra.w	L21ECC
L21ECA	adda.w	(a1),a1
L21ECC	dbra	d0,L21ECA
	rts
DoHiLights
	bsr.w	GetShifter
	moveq	#$10,d3
	mulu.w	d1,d3
	movea.l	#$18A18,a0
	adda.w	d3,a0
L21EE2	btst	#$2,$E(a0)
	bne.w	L21EFA
	bclr	#$1,$E(a0)
	beq.w	L21EFA
	bsr.w	L21F04
L21EFA	suba.w	#$10,a0
	dbra	d1,L21EE2
	rts
L21F04	movem.l	d0-d7/a0-a6,-(sp)
L21F08	btst	#$3,$17F6E.l
	bne.w	L2231E
	bsr.w	L223BA
	move.w	d1,d3
	bsr.w	CheckGameTickerStatus
	bsr.w	NewTicker3
	btst	#$3,$17F6E.l
	bne.w	L22312
	move.w	#$4,(printx).l
	subi.w	#$6,(printy).l
	moveq	#$18,d0
	moveq	#$3,d1
	bsr.w	Framer
	addi.w	#$1,(printx).l
	subi.w	#$2,(printy).l
	bsr.w	printz
	String	'Highlight from game:'
	move.w	#$B4,d0
	bsr.w	waitxsr
	btst	#$7,d1
	bne.w	L22312
	st.b	$17CE2.l
	dc.w	$4279,$0001,$7CD8
	move.w	$0(a0),(HomeTeam).l
	move.w	$2(a0),(VisTeam).l
	move.l	a0,-(sp)
	clr.w	$18374.l
	clr.w	$186DA.l
	dc.w	$4EB9,$0003,$F11E
	jsr	(restoreteams).l
	dc.w	$50F9,$0001,$7F9E
	dc.w	$50F9,$0001,$7FA0
	dc.w	$4279,$0001,$7FA6
	dc.w	$4279,$0001,$7FA8
	moveq	#$78,d0
	bsr.w	randomd0
	addi.w	#$3C,d0
	dc.w	$33C0,$0001,$80E6
	movea.l	(sp),a0
	move.w	$8(a0),$180E4.l
	subi.w	#$1,$180E4.l
	dc.w	$33E8,$000A,$0001,$8358
	dc.w	$33E8,$000C,$0001,$86BE
	move.b	#$10,$17F68.l
	btst	#$0,$180E5.l
	beq.w	L2201C
	bset	#$1,$17F68.l
L2201C	clr.b	$17F6A.l
	move.b	#$4,$17F6C.l
	clr.b	$17F6E.l
	bclr	#$4,(disflags).l
	bset	#$3,(disflags).l
	clr.w	$17E32.l
	clr.b	$17ECE.l
	dc.w	$50F9,$0001,$806E
	st.b	$17E38.l
	st.b	$17E3C.l
	jsr	$47DAC.l
	bsr.w	Sub_3EB3C
	move.w	#$1,$17468.l
	bsr.w	ClrHor
	move.w	#$0,$17468.l
	movea.l	#$C00000,a0
L22082	btst	#$7,$FF800E.l
	bne.b	L22082
	move.w	#$9100,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
L220A4	btst	#$6,$FF800E.l
	beq.b	L220A4
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L220BE	btst	#$6,$FF800E.l
	bne.b	L220BE
	bclr	#$7,$FF800F.l
L220D0	btst	#$7,$FF800E.l
	bne.b	L220D0
	move.w	#$9200,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
L220F2	btst	#$6,$FF800E.l
	beq.b	L220F2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L2210C	btst	#$6,$FF800E.l
	bne.b	L2210C
	bclr	#$7,$FF800F.l
	dc.w	$3839,$0001,$8D56
	movea.l	$47D1C.l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain
	dc.w	$4279,$0001,$7CEA
	dc.w	$4279,$0001,$7CEE
	bsr.w	ResetBench
	movea.l	#tmstruct,a2
	bsr.w	L22326
	adda.w	#$366,a2
	bsr.w	L22326
	bsr.w	Sub_3F0C6
	moveq	#$B,d0
	movea.l	#$3D3F6,a0
	dc.w	$227C,$0001,$7480
L22164	move.w	$34(a1),d1
	btst	#$7,$62(a1)
	bne.w	L22176
	addi.w	#$6,d1
L22176	asl.w	#$2,d1
	move.w	(a0,d1.w),$0(a1)
	move.w	$2(a0,d1.w),$14(a1)
	clr.w	$28(a1)
	clr.w	$2A(a1)
	adda.w	#$80,a1
	dbra	d0,L22164
	bsr.w	Sub_3F03E
	move.w	#$18,(palcount).l
	dc.w	$33F9,$0001,$7474,$0001,$7476
	move.w	#$B4,-(sp)
L221AE	jsr	(DoGameFrame).l
	btst	#$0,$17F68.l
	beq.w	L221C8
	subi.w	#$1,(sp)
	bmi.w	L2224C
L221C8	bsr.w	orjoy
	btst	#$5,d1
	bne.w	L221DC
	btst	#$7,d1
	beq.w	L221AE
L221DC	dc.w	$3039,$0001,$8358
	dc.w	$B079,$0001,$86BE
	bne.w	L2224C
L221EC	btst	#$7,$FF800E.l
	bne.b	L221EC
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
L22206	btst	#$6,$FF800E.l
	beq.b	L22206
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L22226	btst	#$6,$FF800E.l
	bne.b	L22226
	bclr	#$7,$FF800F.l
	andi.w	#$1,d0
	dc.w	$D179,$0001,$8358
	eori.w	#$1,d0
	dc.w	$D179,$0001,$86BE
L2224C	adda.w	#$2,sp
	movea.l	(sp)+,a0
	movem.l	d1/a0,-(sp)
	jsr	$48208.l
	jsr	$47DAC.l
	movem.l	(sp)+,d1/a0
	dc.w	$3179,$0001,$8358,$000A
	dc.w	$3179,$0001,$86BE,$000C
	bsr.w	Sub_36D0A
	moveq	#$F,d0
	dc.w	$207C,$0001,$7480
L22282	clr.w	$0(a0)
	adda.w	#$80,a0
	dbra	d0,L22282
	bsr.w	L223D8
	bsr.w	Sub_3F24C
	bsr.w	SetHor
	bsr.w	Sub_3DD16
	jsr	$2C1F8.l
	jsr	(DrawMenuScreen).l
	move.w	#$18,(palcount).l
	move.w	#$79,-(sp)
	bsr.w	song
	movem.l	(sp),d0-d7/a0-a6
	move.w	#$4,$8(a0)
	move.w	$A(a0),d0
	cmp.w	$C(a0),d0
	beq.w	L21F08
	move.w	#$5,$8(a0)
	move.w	d1,d3
	bsr.w	CheckGameTickerStatus
	bsr.w	NewTicker3
	move.w	#$B4,d0
	bsr.w	waitxsr
	btst	#$7,d1
	bne.w	L22304
	bsr.w	Sub_3CE8C
	move.w	#$3C,d0
	bsr.w	waitxsr
	btst	#$7,d1
	beq.w	L2230C
L22304	bset	#$3,$17F6E.l
L2230C	movem.l	(sp)+,d0-d7/a0-a6
	rts
L22312	bsr.w	L223D8
	bsr.w	L2234A
	bra.w	L22304
L2231E	bsr.w	L2234A
	bra.w	L2230C
L22326	jsr	(reenergizeteam).l
	bsr.w	Sub_3D426
	bsr.w	forcepldata
	st.b	$18(a2)
	bclr	#$7,$17F7C.l
	st.b	$1A(a2)
	st.b	$1C(a2)
	rts
L2234A	move.w	$A(a0),d0
	cmp.w	$C(a0),d0
	bne.w	L223B2
L22356	btst	#$7,$FF800E.l
	bne.b	L22356
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
L22370	btst	#$6,$FF800E.l
	beq.b	L22370
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L22390	btst	#$6,$FF800E.l
	bne.b	L22390
	bclr	#$7,$FF800F.l
	andi.w	#$1,d0
	add.w	d0,$A(a0)
	eori.w	#$1,d0
	add.w	d0,$C(a0)
L223B2	move.w	#$5,$8(a0)
	rts
L223BA	move.w	#$557,d0
	movea.l	#$17F68,a1
	dc.w	$247C,$0000,$C45C
L223CA	move.w	(a1)+,(a2)+
	dbra	d0,L223CA
	dc.w	$34F9,$0001,$80F0
	rts
L223D8	move.w	#$557,d0
	movea.l	#$17F68,a2
	dc.w	$227C,$0000,$C45C
L223E8	move.w	(a1)+,(a2)+
	dbra	d0,L223E8
	dc.w	$33D9,$0001,$80F0
	rts
	dc.w	$0000,$FF10,$FFBA,$FF74,$0014,$FF92,$FF9C,$FFC4
	dc.w	$0019,$FFD8,$0046,$FFB0,$0000,$00F0,$0022,$005A
	dc.w	$FFC9,$0050,$0064,$0028,$FFF6,$000A,$FFCE,$0000
Sub_3D426
	movem.l	d0-d5/a0-a4,-(sp)
	movea.l	$22(a2),a3
	moveq	#$5,d4
L22430	st.b	$60(a3)
	st.b	$61(a3)
	adda.w	#$80,a3
	dbra	d4,L22430
	bsr.w	SetPlList
	moveq	#$5,d4
	movea.l	#$18AC6,a4
L2244C	clr.w	d5
	move.b	(a4,d4.w),d5
	beq.w	L22482
	subi.w	#$1,d5
	moveq	#$5,d3
	movea.l	$22(a2),a3
	suba.w	#$80,a3
L22464	adda.w	#$80,a3
	cmp.b	$66(a3),d5
	dbeq	d3,L22464
	bne.w	L22482
	move.b	$6(a4,d4.w),$60(a3)
	move.b	d5,$61(a3)
	clr.b	(a4,d4.w)
L22482	dbra	d4,L2244C
	moveq	#$5,d4
	movea.l	#$18AC6,a4
L2248E	clr.w	d5
	move.b	(a4,d4.w),d5
	beq.w	L224CE
	subi.w	#$1,d5
	moveq	#$5,d3
	movea.l	$22(a2),a3
	suba.w	#$80,a3
L224A6	adda.w	#$80,a3
	tst.b	$61(a3)
	dbmi	d3,L224A6
	bpl.w	L224B8
	movea.l	a3,a0
L224B8	tst.w	$34(a3)
	dbpl	d3,L224A6
	move.b	$6(a4,d4.w),$60(a0)
	move.b	d5,$61(a0)
	clr.b	(a4,d4.w)
L224CE	dbra	d4,L2248E
	movem.l	(sp)+,d0-d5/a0-a4
	rts
SetPlList
	movea.l	#$18AC6,a4
	clr.l	(a4)
	clr.w	$4(a4)
	movea.l	#$41AD6,a0
	tst.w	$28(a2)
	bpl.w	L224F6
	adda.w	#$1,a0
L224F6	lea.l	$16C(a2),a1
	move.w	$16(a2),d0
	asl.w	#$3,d0
	adda.w	d0,a1
	move.w	$26(a2),d4
	bra.w	L22528
L2250A	clr.w	d5
	move.b	(a0,d4.w),d5
	move.b	(a1,d5.w),(a4,d4.w)
	move.b	d5,$6(a4,d4.w)
	bne.w	L22528
	moveq	#$1,d3
	add.w	$28(a2),d3
	move.b	d3,(a4,d4.w)
L22528	dbra	d4,L2250A
	moveq	#$5,d4
L2252E	move.b	(a4,d4.w),d3
	beq.w	L22584
	ext.w	d3
	subi.w	#$1,d3
	add.w	d3,d3
	cmpi.w	#$FFFD,$68(a2,d3.w)
	beq.w	L2255A
	cmpi.w	#$FFFC,$68(a2,d3.w)
	beq.w	L2255A
	tst.w	$68(a2,d3.w)
	ble.w	L22584
L2255A	lea.l	$16C(a2),a1
	move.b	$6(a4,d4.w),d0
	ext.w	d0
	asl.w	#$1,d0
	movea.l	#$41A6C,a0
	adda.w	(a0,d0.w),a0
L22570	clr.w	d0
	move.b	(a0)+,d0
	bmi.w	L2258A
	move.b	(a1,d0.w),d0
	bsr.w	TryAddPlayerToList
	beq.w	L22570
L22584	dbra	d4,L2252E
	rts
L2258A	jsr	(Sub_2EDBC).l
	move.w	d0,d3
L22592	move.w	d3,d0
	subi.w	#$1,d3
	bmi.w	L22584
	bsr.w	TryAddPlayerToList
	beq.w	L22592
	bra.w	L22584
TryAddPlayerToList
	move.w	d0,d1
	subi.w	#$1,d0
	add.w	d0,d0
	tst.w	$68(a2,d0.w)
	bgt.w	L225E0
	cmpi.w	#$FFFD,$68(a2,d0.w)
	beq.w	L225E0
	cmpi.w	#$FFFC,$68(a2,d0.w)
	beq.w	L225E0
	moveq	#$5,d0
L225CE	cmp.b	(a4,d0.w),d1
	dbeq	d0,L225CE
	beq.w	L225E0
	move.b	d1,(a4,d4.w)
	rts
L225E0	clr.w	d1
	rts
SetupPenaltyShot
	movem.l	d0-d5/a0-a3,-(sp)
	movea.l	$22(a2),a3
	moveq	#$5,d4
L225EE	move.w	$52(a3),d0
	dc.w	$B079,$0001,$9368
	beq.w	L22618
	dc.w	$B079,$0001,$936A
	beq.w	L22636
	bset	#$2,$63(a3)
	move.w	#$20,d0
	bsr.w	Sub_362E4
	bra.w	L22652
L22618	bsr.w	Setplass
	move.b	$61(a3),$17F9C.l
	move.b	$1936D.l,$61(a3)
	move.w	#$4,$34(a3)
	bra.w	L2263E
L22636	bsr.w	Setplass
	clr.w	$34(a3)
L2263E	clr.w	d3
	move.b	$61(a3),d3
	add.w	d3,d3
	move.w	#$FFFF,$68(a2,d3.w)
	lsr.w	#$1,d3
	bsr.w	Sub_3D770
L22652	st.b	$61(a3)
	st.b	$60(a3)
	adda.w	#$80,a3
	dbra	d4,L225EE
	movem.l	(sp)+,d0-d5/a0-a3
	rts
forcepldata
	movem.l	d0-d4/a0-a3,-(sp)
	movea.l	$22(a2),a3
	moveq	#$5,d4
L22672	move.b	$60(a3),d0
	ext.w	d0
	tst.w	$34(a3)
	bne.w	L2269A
	tst.w	d0
	beq.w	L2269A
	move.w	$52(a3),-(sp)
	move.w	#$F,$52(a3)
	jsr	$22DDE.l
	move.w	(sp)+,$52(a3)
L2269A	move.w	d0,$34(a3)
	bmi.w	L226CA
	bsr.w	Setplass
	cmpi.w	#$4,$34(a3)
	bne.w	L226B6
	moveq	#$11,d0
	bsr.w	Sub_362D8
L226B6	clr.w	d3
	move.b	$61(a3),d3
	add.w	d3,d3
	move.w	#$FFFF,$68(a2,d3.w)
	lsr.w	#$1,d3
	bsr.w	Sub_3D770
L226CA	st.b	$61(a3)
	st.b	$60(a3)
	adda.l	#$80,a3
	dbra	d4,L22672
	movem.l	(sp)+,d0-d4/a0-a3
	rts
ResetBench
	dc.w	$4239,$0001,$8068
	moveq	#$10,d1
	movea.l	#tmstruct,a0
	bsr.w	L226FA
	moveq	#$1,d1
	adda.w	#$366,a0
L226FA	moveq	#$32,d0
L226FC	dc.w	$D339,$0001,$8068
	tst.w	$68(a0,d0.w)
	ble.w	L2272A
	btst	#$4,$68(a0,d0.w)
	beq.w	L2274A
	move.w	$68(a0,d0.w),d2
	andi.w	#$7FF,d2
	bne.w	L2274A
	dc.w	$9339,$0001,$8068
	bra.w	L2274A
L2272A	dc.w	$9339,$0001,$8068
	cmpi.w	#$FFFD,$68(a0,d0.w)
	beq.w	L2274A
	cmpi.w	#$FFFC,$68(a0,d0.w)
	beq.w	L2274A
	move.w	#$FFFE,$68(a0,d0.w)
L2274A	subi.w	#$2,d0
	bpl.w	L226FC
	rts
Setplass
	move.w	$34(a3),d0
	bmi.w	rtss2
	dc.w	$41FA,$000A
	move.b	(a0,d0.w),d0
	bra.w	Sub_362E4
	dc.w	$0E02
setplayer
	dc.w	$0203,$0503
	btst	d2,d0
