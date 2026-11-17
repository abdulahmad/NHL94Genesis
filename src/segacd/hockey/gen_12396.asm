Sub_2D396
	dc.w	$4EB9,$0003,$8D8C
	String	CC_SetMapAndPosition,$7,$3,$2,$9,CC_SetFont,$1
	move.w	(SelectedPlayerIdx).l,d0
	dc.w	$43FA,$012C
	dc.w	$4EB9,$0003,$CEC6
	dc.w	$4EB9,$0003,$8D9E
	dc.w	$4EB9,$0003,$8D8C
	String	CC_Font3,$16,$FC,$9
L123C8	movea.l	#$41C48,a1
	move.w	(scoutcolumn).l,d0
	tst.w	(SelectedPlayerIdx).l
	bne.w	L123EE
	movea.l	#$41DAA,a1
	bra.w	L123EE
L123E8	adda.w	(a1),a1
	adda.w	#$4,a1
L123EE	tst.w	(a1)
	dbmi	d0,L123E8
	bpl.w	L12404
	subi.w	#$1,(scoutcolumn).l
	bra.w	L123C8
L12404	jsr	(printsmall).l
	move.l	(a1),d4
	dc.w	$4EB9,$0003,$8D8C
	String	CC_SetMapAndPosition,$4,$2,$0,$0,CC_SetFont,$0
	btst	#$0,$1A455.l
	beq.w	L12430
	addi.w	#$10,(printy).l
L12430	move.w	(printy).l,-(sp)
	moveq	#$28,d0
	moveq	#$10,d1
	move.w	#$7FF,d2
	dc.w	$4EB9,$0003,$8C06
	move.w	(sp)+,(printy).l
	bsr.w	GetGoalieCount
	move.w	d0,d1
	subi.w	#$1,d1
	movea.l	#$2D4CA,a5
	dc.w	$267C,$000B,$BD30
	move.l	#$1020304,(a3)
	move.w	(SelectedPlayerIdx).l,d0
	subi.w	#$1,d0
	bmi.w	L12496
	asl.w	#$3,d0
	lea.l	$16C(a2),a3
	lea.l	$1(a3,d0.w),a3
	movea.l	#$41A20,a5
	moveq	#$4,d1
	cmpi.w	#$5,(SelectedPlayerIdx).l
	ble.w	L12496
	subi.w	#$1,d1
L12496	move.w	#$2,(printx).l
	movea.l	a5,a1
	dc.w	$4EB9,$0003,$8F80
	movea.l	a1,a5
	move.w	#$7,(printx).l
	clr.w	d0
	move.b	(a3)+,d0
	subi.w	#$1,d0
	bsr.w	GetNameandAttrib
	addi.w	#$2,(printy).l
	dbra	d1,L12496
	rts
	dc.w	$0004,$4700,$0004,$4700,$0004,$4700,$0004,$4700
	dc.w	$0012,$2020,$2020,$476F,$616C,$6965,$7320,$2020
	dc.w	$207D,$0012,$7B20,$2053,$636F,$7269,$6E67,$2020
	dc.w	$3120,$207D,$0012,$7B20,$2053,$636F,$7269,$6E67
	dc.w	$2020,$3220,$207D,$0012,$7B20,$2020,$4368,$6563
	dc.w	$6B69,$6E67,$2020,$207D,$0012,$7B20,$506F,$7765
	dc.w	$7220,$506C,$6179,$2031,$207D,$0012,$7B20,$506F
	dc.w	$7765,$7220,$506C,$6179,$2032,$207D,$0012,$7B50
	dc.w	$656E,$616C,$7479,$204B,$696C,$6C20,$317D,$0012
	dc.w	$7B50,$656E,$616C,$7479,$204B,$696C,$6C20,$3220
GetNameandAttrib
	movem.l	d0-d4/a0-a1/a4-a5,-(sp)
	dc.w	$487A,$0030
	dc.w	$4EB9,$0004,$112E
	dc.w	$4EB9,$0003,$8F80
	move.w	#$1E,(printx).l
	cmpi.w	#$2,d4
	bls.w	L12596
	jsr	(CalcAttrib).l
	swap	d4
L12596	dc.w	$41FA,$000E
	adda.w	(a0,d4.w),a0
	jmp	(a0)
	dc.w	$4CDF,$331F,$4E75,$000C,$009E,$00E8,$010E,$00B8
	dc.w	$00C0,$D040,$3032,$0068,$6A00,$001E,$4640,$0C40
	dc.w	$0003,$6300,$000A,$7001,$6000,$0004,$7003,$43FA
	dc.w	$0040,$4EF9,$0003,$CEBE,$0800,$000C,$6600,$FFEE
	dc.w	$0479,$0001,$0001,$8D58,$3200,$0240,$0FFF,$4EB9
	dc.w	$0003,$90F4,$4EB9,$0003,$8F80,$7004,$0881,$000E
	dc.w	$6700,$0004,$7005,$43FA,$0008,$4EF9,$0003,$CEBE
	dc.w	$000A,$4963,$6520,$2020,$2020,$000A,$4265,$6E63
	dc.w	$6820,$2020,$000A,$496E,$6A75,$7279,$2050,$000A
	dc.w	$496E,$6A75,$7279,$2047,$0006,$2020,$2020,$0006
	dc.w	$2043,$2020
AttribEnergy
	add.w	d0,d0
	move.w	$34(a2,d0.w),d0
	ext.l	d0
	divu.w	#$28,d0
	cmpi.w	#$64,d0
	ble.w	Sub_2D672
	moveq	#$64,d0
	bra.w	Sub_2D672
	dc.w	$0240,$000E,$0441,$0001,$C0FC,$0064,$80C1,$4EB9
	dc.w	$0002,$AE82
Sub_2D672
	moveq	#$4,d1
	dc.w	$4EB9,$0003,$919A
	dc.w	$4EB9,$0003,$8F80
	dc.w	$4EB9,$0003,$8F6E
	String	'    '
	rts
	dc.w	$0240,$0001,$0A40,$0001,$43FA,$0008,$4EF9,$0003
	dc.w	$CEBE,$000A
AttribWeight
	addq.w	#$1,$6768(a1)
	moveq	#$79,d2
	move.l	-(a0),d0
	dc.w	$000A,$4C65,$6674,$7920,$2020,$E740,$0640,$008C
	dc.w	$4EB9,$0003,$915E,$4EB9,$0003,$8F80,$4EB9,$0003
	dc.w	$8F6E,$0008,$206C,$6220,$2000,$4E75
ScoringSummaryScreen
	moveq	#$A,d0
	moveq	#$1A,d1
	bsr.w	Sub_2E728
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font3Pri,$4,$1
	moveq	#$20,d0
	moveq	#$6,d1
	dc.w	$4EB9,$0003,$8CA0
	dc.w	$4EB9,$0003,$9258
	String	CC_Font3Pri,$6,$4,'Scoring Summary',CC_Font3Pri,$7,$1
	moveq	#$2C,d0
	bsr.w	Sub_2C59E
	addi.w	#$4,(printx).l
	clr.w	d0
	bsr.w	Sub_2C59E
	dc.w	$4EB9,$0003,$8D8C
	dc.w	$0034
	dc.b	$F8,$06,$03,$00,$08,$F9,$01,$5E,$50,$65,$72,$5E,$5E,$54,$69,$6D,$65,$5E,$5E,$54,$6D,$5E,$5E,$47,$6F,$61,$6C,$2F,$41,$73,$73,$69,$73,$74,$5E,$5E,$5E,$5E,$5E,$5E,$5E,$5E,$50,$2F,$53,$5E,$5E,$F9,$00,$00
	clr.l	d0
	dc.w	$3039,$0001,$80F0
	divu.w	#$6,d0
	asl.w	#$5,d0
	move.w	d0,(VertLineScrolling).l
	subi.w	#$80,d0
	bpl.w	L1277E
	clr.w	d0
L1277E	move.w	d0,(SelectedPlayerIdx).l
	move.w	(VertLineScrolling).l,d0
L1278A	bsr.w	MenuWaitVblank
	bsr.w	L127FC
	move.w	(VertLineScrolling).l,d0
	subi.w	#$2,d0
	cmp.w	(SelectedPlayerIdx).l,d0
	bge.w	L1278A
	clr.w	(PlayerScrollCtr).l
L127AC	bsr.w	MenuWaitVblank
	bsr.w	Sub_2F2F0
	btst	#$7,d3
	bne.w	Sub_2E980
	moveq	#-2,d0
	btst	#$0,d3
	bne.w	L127D0
	neg.w	d0
	btst	#$1,d3
	beq.w	L127D6
L127D0	move.w	d0,(PlayerScrollCtr).l
L127D6	bsr.w	CheckScoringScroll
	bra.w	L127AC
CheckScoringScroll
	move.w	(PlayerScrollCtr).l,d0
	beq.w	Sub_2F988
	add.w	(VertLineScrolling).l,d0
	bmi.w	Sub_2F988
	cmp.w	(SelectedPlayerIdx).l,d0
	bgt.w	Sub_2F988
L127FC	move.w	(VertLineScrolling).l,d1
	move.w	d0,(VertLineScrolling).l
	ext.l	d0
	divs.w	#$20,d0
	swap	d0
	tst.w	d0
	bne.w	L12820
	bsr.w	Sub_2DDB0
	clr.w	(PlayerScrollCtr).l
L12820	andi.w	#$1F,d1
	bne.w	L12844
	move.l	d0,-(sp)
	cmpi.w	#$1E,d0
	bne.w	L12836
	bsr.w	L12904
L12836	move.l	(sp)+,d0
	cmpi.w	#$2,d0
	bne.w	L12844
	bsr.w	L12936
L12844	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movea.l	#$C00000,a0
L12858	btst	#$7,$FF800E.l
	bne.b	L12858
	move.l	#$40020010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset	#$6,$FF800F.l
L1287C	btst	#$6,$FF800E.l
	beq.b	L1287C
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L12896	btst	#$6,$FF800E.l
	bne.b	L12896
	bclr	#$7,$FF800F.l
	moveq	#-80,d0
	add.w	(VertLineScrolling).l,d0
L128B0	btst	#$7,$FF800E.l
	bne.b	L128B0
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset	#$6,$FF800F.l
L128D0	btst	#$6,$FF800E.l
	beq.b	L128D0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L128EA	btst	#$6,$FF800E.l
	bne.b	L128EA
	bclr	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	rts
L12904	move.l	d0,-(sp)
	swap	d0
	moveq	#$6,d3
	mulu.w	d0,d3
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font2Pri,$0,$0
	move.w	(VertLineScrolling).l,d0
	lsr.w	#$3,d0
	subi.w	#$3,d0
	andi.w	#$1F,d0
	move.w	d0,(printy).l
	bsr.w	DrawScoringRow
	move.l	(sp)+,d0
	rts
L12936	move.l	d0,-(sp)
	swap	d0
	addi.w	#$4,d0
	moveq	#$6,d3
	mulu.w	d0,d3
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font2Pri,$0,$0
	move.w	(VertLineScrolling).l,d0
	lsr.w	#$3,d0
	addi.w	#$10,d0
	andi.w	#$1F,d0
	move.w	d0,(printy).l
	bsr.w	DrawScoringRow
	move.l	(sp)+,d0
	rts
DrawScoringRow
	move.w	(printy).l,-(sp)
	moveq	#$28,d0
	moveq	#$4,d1
	move.w	#$7FF,d2
	dc.w	$4EB9,$0003,$8C06
	move.w	(sp)+,(printy).l
	movea.l	#$180F2,a0
	move.w	(a0,d3.w),d0
	move.w	#$1,(printx).l
	dc.w	$4EB9,$0003,$90C0
	movea.l	#tmstruct,a2
	btst	#$7,$2(a0,d3.w)
	beq.w	L129B2
	adda.w	#$366,a2
L129B2	movea.l	$1E(a2),a1
	adda.w	$4(a1),a1
	adda.w	(a1),a1
	move.w	#$C,(printx).l
	dc.w	$4EB9,$0003,$8F80
	move.w	#$23,(printx).l
	dc.w	$43FA,$0060
	move.b	$2(a0,d3.w),d0
	andi.w	#$7F,d0
	dc.w	$4EB9,$0003,$CEBE
	move.w	#$10,(printx).l
	move.b	$3(a0,d3.w),d0
	bsr.w	PrintScorerName
	move.w	#$E000,(printa).l
	move.w	#$12,(printx).l
	move.b	$4(a0,d3.w),d0
	bsr.w	PrintScorerName
	move.w	#$12,(printx).l
	move.b	$5(a0,d3.w),d0
PrintScorerName
	ext.w	d0
	bmi.w	L12A2A
	dc.w	$4EB9,$0004,$1192
	dc.w	$4EB9,$0003,$8F80
L12A2A	addi.w	#$1,(printy).l
	rts
	dc.w	$0006,$5348,$3200,$0004,$5348,$0004,$2000,$0004
	dc.w	$5050,$0006,$5050,$3200
PenaltySummaryScreen
	moveq	#$A,d0
	moveq	#$19,d1
	bsr.w	Sub_2E728
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font3Pri,$4,$1
	moveq	#$20,d0
	moveq	#$6,d1
	dc.w	$4EB9,$0003,$8CA0
	dc.w	$4EB9,$0003,$9258
	String	CC_Font3Pri,$5,$4,'Penalty  Summary',CC_Font3Pri,$7,$1
	moveq	#$2C,d0
	bsr.w	Sub_2C59E
	addi.w	#$4,(printx).l
	clr.w	d0
	bsr.w	Sub_2C59E
	dc.w	$4EB9,$0003,$8D8C
	dc.w	$0034
	dc.b	$F8,$06,$03,$00,$08,$F9,$01,$5E,$50,$65,$72,$5E,$5E,$54,$69,$6D,$65,$5E,$5E,$54,$6D,$5E,$5E,$50,$6C,$61,$79,$65,$72,$2F,$50,$65,$6E,$61,$6C,$74,$79,$5E,$5E,$5E,$5E,$6D,$69,$6E,$5E,$5E,$5E,$F9,$00,$00
	clr.l	d0
	dc.w	$3039,$0001,$825A
	lsr.w	#$2,d0
	mulu.w	#$18,d0
	move.w	d0,(VertLineScrolling).l
	subi.w	#$78,d0
	bpl.w	L12AF4
	clr.w	d0
L12AF4	move.w	d0,(SelectedPlayerIdx).l
	move.w	(VertLineScrolling).l,d0
L12B00	bsr.w	MenuWaitVblank
	bsr.w	L12B72
	move.w	(VertLineScrolling).l,d0
	subi.w	#$2,d0
	cmp.w	(SelectedPlayerIdx).l,d0
	bge.w	L12B00
	clr.w	(PlayerScrollCtr).l
L12B22	bsr.w	MenuWaitVblank
	bsr.w	Sub_2F2F0
	btst	#$7,d3
	bne.w	Sub_2E980
	moveq	#-2,d0
	btst	#$0,d3
	bne.w	L12B46
	neg.w	d0
	btst	#$1,d3
	beq.w	L12B4C
L12B46	move.w	d0,(PlayerScrollCtr).l
L12B4C	bsr.w	CheckPenaltyScroll
	bra.w	L12B22
CheckPenaltyScroll
	move.w	(PlayerScrollCtr).l,d0
	beq.w	Sub_2F988
	add.w	(VertLineScrolling).l,d0
	bmi.w	Sub_2F988
	cmp.w	(SelectedPlayerIdx).l,d0
	bgt.w	Sub_2F988
L12B72	move.w	(VertLineScrolling).l,d1
	move.w	d0,(VertLineScrolling).l
	ext.l	d0
	divs.w	#$18,d0
	swap	d0
	tst.w	d0
	bne.w	L12B96
	bsr.w	Sub_2DDB0
	clr.w	(PlayerScrollCtr).l
L12B96	ext.l	d1
	divs.w	#$18,d1
	swap	d1
	tst.w	d1
	bne.w	L12BC0
	move.l	d0,-(sp)
	cmpi.w	#$16,d0
	bne.w	L12BB2
	bsr.w	L12C82
L12BB2	move.l	(sp)+,d0
	cmpi.w	#$2,d0
	bne.w	L12BC0
	bsr.w	L12CB4
L12BC0	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movea.l	#$C00000,a0
L12BD4	btst	#$7,$FF800E.l
	bne.b	L12BD4
	move.l	#$40020010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset	#$6,$FF800F.l
L12BF8	btst	#$6,$FF800E.l
	beq.b	L12BF8
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L12C12	btst	#$6,$FF800E.l
	bne.b	L12C12
	bclr	#$7,$FF800F.l
	move.w	#$FFB0,d0
	add.w	(VertLineScrolling).l,d0
L12C2E	btst	#$7,$FF800E.l
	bne.b	L12C2E
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset	#$6,$FF800F.l
L12C4E	btst	#$6,$FF800E.l
	beq.b	L12C4E
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L12C68	btst	#$6,$FF800E.l
	bne.b	L12C68
	bclr	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	rts
L12C82	move.l	d0,-(sp)
	swap	d0
	move.w	d0,d3
	asl.w	#$2,d3
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font2Pri,$0,$0
	move.w	(VertLineScrolling).l,d0
	lsr.w	#$3,d0
	subi.w	#$2,d0
	andi.w	#$1F,d0
	move.w	d0,(printy).l
	bsr.w	DisplayPenaltyEntry
	move.l	(sp)+,d0
	rts
L12CB4	move.l	d0,-(sp)
	swap	d0
	addi.w	#$5,d0
	move.w	d0,d3
	asl.w	#$2,d3
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font2Pri,$0,$0
	move.w	(VertLineScrolling).l,d0
	lsr.w	#$3,d0
	addi.w	#$F,d0
	andi.w	#$1F,d0
	move.w	d0,(printy).l
	bsr.w	DisplayPenaltyEntry
	move.l	(sp)+,d0
	rts
DisplayPenaltyEntry
	move.w	(printy).l,-(sp)
	moveq	#$28,d0
	moveq	#$3,d1
	move.w	#$7FF,d2
	dc.w	$4EB9,$0003,$8C06
	move.w	(sp)+,(printy).l
	movea.l	#$1825C,a0
	move.w	(a0,d3.w),d0
	move.w	#$1,(printx).l
	dc.w	$4EB9,$0003,$90C0
	movea.l	#tmstruct,a2
	btst	#$7,$2(a0,d3.w)
	beq.w	L12D30
	adda.w	#$366,a2
L12D30	movea.l	$1E(a2),a1
	adda.w	$4(a1),a1
	adda.w	(a1),a1
	move.w	#$C,(printx).l
	dc.w	$4EB9,$0003,$8F80
	move.b	$2(a0,d3.w),d0
	andi.w	#$7F,d0
	dc.w	$267C,$0004,$165C
	adda.w	(a3,d0.w),a3
	clr.w	d0
	move.b	$1(a3),d0
	dc.w	$4EB9,$0003,$915E
	move.w	#$23,(printx).l
	dc.w	$4EB9,$0003,$8F80
	move.w	#$10,(printx).l
	clr.w	d0
	move.b	$3(a0,d3.w),d0
	dc.w	$4EB9,$0004,$1192
	dc.w	$4EB9,$0003,$8F80
	addi.w	#$1,(printy).l
	move.w	#$13,(printx).l
	move.w	#$E000,(printa).l
	lea.l	$2(a3),a1
	dc.w	$4EF9,$0003,$8F80
Sub_2DDB0
	movem.l	d0-d1/a1,-(sp)
	dc.w	$4EB9,$0003,$8D8C
	String	CC_SetMapAndPosition,$4,$3,$4,$9,CC_SetFont,$1
	clr.w	d0
	move.w	(VertLineScrolling).l,d1
	tst.w	d1
	sgt.b	d0
	neg.b	d0
	cmp.w	(SelectedPlayerIdx).l,d1
	slt.b	d1
	neg.b	d1
	add.b	d1,d0
	add.b	d1,d0
	dc.w	$43FA,$000E
	dc.w	$4EB9,$0003,$CEBE
	movem.l	(sp)+,d0-d1/a1
	rts
	dc.w	$000A,$20FB,$FFFA,$1120,$F900,$000A,$7BFB,$FFFA
	dc.w	$1120,$F900,$000A,$20FB,$FFFA,$117D,$F900,$000A
	dc.w	$7BFB,$FFFA,$117D,$F900
PlayoffStatsScreen
	movem.l	a2,-(sp)
	dc.w	$4EB9,$0004,$08E0
	movea.l	#$18AA6,a0
	dc.w	$3039,$0001,$8AA0
	move.b	(a0,d0.w),d0
	movea.l	#tmstruct,a2
	cmp.w	$2A(a2),d0
	beq.w	L12E44
	adda.w	#$366,a2
L12E44	moveq	#$1,d7
	bsr.w	PlayerStatsList
	movem.l	(sp)+,a2
	rts
	dc.w	$4247
PlayerStatsList
	moveq	#$D,d0
	moveq	#$16,d1
	bsr.w	Sub_2E728
	clr.w	(scoutcolumn).l
	clr.w	(VertLineScrolling).l
L12E66	clr.w	(PlayerScrollCtr).l
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font3Pri,$5,$1
	moveq	#$1E,d0
	moveq	#$6,d1
	dc.w	$4EB9,$0003,$8CA0
	tst.w	d7
	beq.w	L12EA8
	dc.w	$4EB9,$0003,$9258
	String	CC_Font3Pri,$7,$4,'Playoff  Stats',CC_Font3Pri,$E,$1
	bra.w	L12EE6
L12EA8	jsr	(printsmallz).l
	dc.w	$001C
	dc.b	$F8,$06,$03,$0C,$1A,$F9,$01,$41,$5E,$2D,$5E,$53,$77,$69,$74,$63,$68,$5E,$54,$65,$61,$6D,$73,$F9,$00,$00
	dc.w	$4EB9,$0003,$9258
	String	CC_Font3Pri,$8,$4,'Player  Stats',CC_Font3Pri,$E,$1
L12EE6	clr.w	d0
	cmpa.l	#$1834C,a2
	beq.w	L12EF4
	moveq	#$2C,d0
L12EF4	bsr.w	Sub_2C59E
	bsr.w	L130D8
	bsr.w	Sub_2E4EE
L12F00	bsr.w	MenuWaitVblank
	bsr.w	Sub_2F2F0
	btst	#$7,d3
	bne.w	Sub_2E980
	btst	#$6,d1
	bne.w	L12F7C
	dc.w	$4EB9,$0003,$7496
	moveq	#$1,d0
	btst	#$3,d1
	bne.w	L12F54
	neg.w	d0
	btst	#$2,d1
	bne.w	L12F54
	moveq	#-2,d0
	btst	#$0,d3
	bne.w	L12F46
	neg.w	d0
	btst	#$1,d3
	beq.w	L12F4C
L12F46	move.w	d0,(PlayerScrollCtr).l
L12F4C	bsr.w	UpdateStatsListScroll
	bra.w	L12F00
L12F54	add.w	(scoutcolumn).l,d0
	cmpi.w	#$FFFF,d0
	blt.w	L12F4C
	cmpi.w	#$4,d0
	bgt.w	L12F4C
	move.w	d0,(scoutcolumn).l
	bsr.w	L130D8
	bsr.w	Sub_2E4EE
	bra.w	L12F4C
L12F7C	tst.w	d7
	bne.w	L12F4C
	lea.l	$366(a2),a2
	cmpa.l	#$186B2,a2
	beq.w	L12E66
	movea.l	#tmstruct,a2
	bra.w	L12E66
UpdateStatsListScroll
	move.w	(PlayerScrollCtr).l,d0
	beq.w	Sub_2F988
	add.w	(VertLineScrolling).l,d0
	bmi.w	Sub_2F988
	cmp.w	(SelectedPlayerIdx).l,d0
	bgt.w	Sub_2F988
	move.w	(VertLineScrolling).l,d1
	move.w	d0,(VertLineScrolling).l
	andi.w	#$F,d0
	bne.w	L12FD6
	bsr.w	Sub_2E4EE
	clr.w	(PlayerScrollCtr).l
L12FD6	andi.w	#$F,d1
	bne.w	L12FFA
	move.w	d0,-(sp)
	cmpi.w	#$E,d0
	bne.w	L12FEC
	bsr.w	L130BC
L12FEC	move.w	(sp)+,d0
	cmpi.w	#$2,d0
	bne.w	L12FFA
	bsr.w	L130C8
L12FFA	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movea.l	#$C00000,a0
L1300E	btst	#$7,$FF800E.l
	bne.b	L1300E
	move.l	#$40020010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset	#$6,$FF800F.l
L13032	btst	#$6,$FF800E.l
	beq.b	L13032
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1304C	btst	#$6,$FF800E.l
	bne.b	L1304C
	bclr	#$7,$FF800F.l
	move.w	#$FF98,d0
	add.w	(VertLineScrolling).l,d0
L13068	btst	#$7,$FF800E.l
	bne.b	L13068
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset	#$6,$FF800F.l
L13088	btst	#$6,$FF800E.l
	beq.b	L13088
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L130A2	btst	#$6,$FF800E.l
	bne.b	L130A2
	bclr	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	rts
L130BC	move.w	(VertLineScrolling).l,d3
	lsr.w	#$4,d3
	bra.w	DrawStatsRow
L130C8	move.w	(VertLineScrolling).l,d3
	lsr.w	#$4,d3
	addi.w	#$6,d3
	bra.w	DrawStatsRow
L130D8	jsr	(printsmallz).l
	dc.w	$0012
	dc.b	$F8,$06,$03,$04,$0B,$F9,$01,$50,$6C,$61,$79,$65,$72,$FB,$07,$00
	dc.w	$43FA,$0344
	moveq	#$5,d3
	tst.w	(scoutcolumn).l
	bmi.w	L13104
	adda.w	(a1),a1
	clr.w	d3
L13104	move.w	#$8000,(printa).l
	cmp.w	(scoutcolumn).l,d3
	bne.w	L1311E
	move.w	#$C000,(printa).l
L1311E	jsr	(printsmall).l
	addi.w	#$1,d3
	cmpi.w	#$5,d3
	blt.w	L13104
	dc.w	$4EB9,$0003,$8D8C
	String	CC_SetMapAndPosition,$4,$3,$9,$7
	moveq	#$16,d0
	moveq	#$3,d1
	dc.w	$4EB9,$0003,$8CA0
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font3Pal3Pri,$A,$8
	dc.w	$43FA,$0314
	moveq	#$1,d0
	add.w	(scoutcolumn).l,d0
	dc.w	$4EB9,$0003,$CEBE
	clr.w	(printfontset).l
	dc.w	$267C,$000B,$BD30
	clr.l	d6
	tst.w	(scoutcolumn).l
	bpl.w	L1318A
	bsr.w	GetGoalieCount
	bset	d0,d6
	subi.w	#$1,d6
	not.l	d6
L1318A	moveq	#-1,d4
	st.b	d5
	bsr.w	Sub_2EDBC
	bra.w	L131D8
L13196	btst	d0,d6
	bne.w	L131D8
	clr.w	d2
	move.w	(scoutcolumn).l,d1
	bmi.w	L131AC
	bsr.w	GetStatColumn
L131AC	ext.l	d2
	asl.l	#$8,d2
	movea.l	$1E(a2),a1
	adda.w	$0(a1),a1
	move.w	d0,d1
	suba.w	#$8,a1
L131BE	adda.w	#$8,a1
	adda.w	(a1),a1
	dbra	d1,L131BE
	move.b	#$FF,d2
	sub.b	(a1),d2
	cmp.l	d4,d2
	ble.w	L131D8
	move.l	d2,d4
	move.w	d0,d5
L131D8	dbra	d0,L13196
	bset	d5,d6
	move.b	d5,(a3)+
	bpl.w	L1318A
	moveq	#$5,d0
L131E6	st.b	(a3,d0.w)
	dbra	d0,L131E6
	move.l	a3,d0
	subi.l	#$BBD36,d0
	bpl.w	L131FC
	clr.w	d0
L131FC	asl.w	#$4,d0
	move.w	d0,(SelectedPlayerIdx).l
	cmp.w	(VertLineScrolling).l,d0
	bcc.w	L13214
	move.w	d0,(VertLineScrolling).l
L13214	moveq	#$5,d4
L13216	move.w	(VertLineScrolling).l,d3
	lsr.w	#$4,d3
	add.w	d4,d3
	bsr.w	DrawStatsRow
	dbra	d4,L13216
	bra.w	L12FFA
DrawStatsRow
	dc.w	$287C,$000B,$BD30
	adda.w	d3,a4
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font2Pri,$0,$0
	add.w	d3,d3
	andi.w	#$1F,d3
	move.w	d3,(printy).l
	moveq	#$28,d0
	moveq	#$1,d1
	move.w	#$7FF,d2
	dc.w	$4EB9,$0003,$8C06
	tst.b	(a4)
	bmi.w	Sub_2F988
	subi.w	#$1,(printy).l
	move.w	#$1,(printx).l
	move.l	a4,d0
	subi.l	#$BBD2F,d0
	moveq	#$2,d1
	move.w	#$E000,(printa).l
	dc.w	$4EB9,$0003,$919A
	dc.w	$4EB9,$0003,$8F80
	clr.w	d0
	move.b	(a4),d0
	dc.w	$4EB9,$0004,$11D6
	addi.w	#$1,(printx).l
	move.w	#$8000,(printa).l
	dc.w	$4EB9,$0003,$8F80
	move.w	#$11,(printx).l
	tst.w	(scoutcolumn).l
	bmi.w	L13306
	clr.w	d5
L132C2	clr.w	d0
	move.b	(a4),d0
	move.w	d5,d1
	bsr.w	GetStatColumn
	move.w	d2,d0
	moveq	#$4,d1
	dc.w	$4EB9,$0003,$919A
	move.w	#$8000,(printa).l
	cmp.w	(scoutcolumn).l,d5
	bne.w	L132F0
	move.w	#$C000,(printa).l
L132F0	jsr	(print).l
	addi.w	#$1,d5
	cmpi.w	#$5,d5
	bne.w	L132C2
	bra.w	L13386
L13306	clr.w	d0
	move.b	(a4),d0
	moveq	#$3,d1
	bsr.w	Sub_2E3A4
	clr.w	d0
	move.b	(a4),d0
	moveq	#$0,d1
	move.w	d2,-(sp)
	bsr.w	Sub_2E3A4
	move.w	(sp)+,d0
	move.w	d0,d3
	sub.w	d2,d0
	bpl.w	L13328
	clr.w	d0
L13328	move.w	d0,d2
	moveq	#$4,d1
	dc.w	$4EB9,$0003,$919A
	addi.w	#$1,(printx).l
	dc.w	$4EB9,$0003,$8F80
	move.w	d3,d0
	moveq	#$4,d1
	dc.w	$4EB9,$0003,$919A
	addi.w	#$2,(printx).l
	dc.w	$4EB9,$0003,$8F80
	tst.w	d3
	beq.w	L13364
	mulu.w	#$64,d2
	divu.w	d3,d2
L13364	move.w	d2,d0
	moveq	#$4,d1
	dc.w	$4EB9,$0003,$919A
	addi.w	#$2,(printx).l
	dc.w	$4EB9,$0003,$8F80
	dc.w	$4EB9,$0003,$8F6E
	String	'%'
L13386	rts
