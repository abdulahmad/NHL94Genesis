ScoutParaOffset
	cmpi.w	#$1A,d0
	dc.w	$662A
	move.w	#$EA,d0
	cmpi.w	#$1A,(HomeTeam).l
	dc.w	$6C08
	add.w	(HomeTeam).l,d0
	dc.w	$6014
LDA08	cmpi.w	#$1A,(VisTeam).l
	dc.w	$6C06
	addi.w	#$1A,d0
	dc.w	$6004
LDA18	addi.w	#$1B,d0
LDA1C	movea.l	(ScoutingReportText).l,a1
	movea.l	a1,a2
	move.w	#$0,d1
	bra.w	LDA4A
LDA2C	addq.w	#$1,d1
LDA2E	cmpi.b	#$D,(a2)+
	bne.w	LDA2E
	cmpi.b	#$A,(a2)
	bne.w	LDA4A
	addq.l	#$1,a2
	cmpi.b	#$21,-$3(a2)
	beq.w	LDA2C
LDA4A	dbra	d0,LDA2C
	suba.l	a1,a2
	move.l	a2,d0
	rts
PageMatchup
	move.w	#$10E,(matchuptimer).l
	add.w	(matchup).l,d0
	bmi.w	LDA74
	cmpi.w	#$7,d0
	blt.w	LDA78
	clr.w	d0
	bra.w	LDA78
LDA74	move.w	#$6,d0
LDA78	move.w	d0,(matchup).l
	bsr.w	GetMatchupPlayers
	bsr.w	DrawMatchupPictures
	move.w	(ScoutSubStatus).l,d0
LDA8C	cmp.w	(ScoutSubStatus).l,d0
	beq.b	LDA8C
LDA94	btst	#$7,$FF800E.l
	bne.b	LDA94
	move.w	#$3C,$FF8020.l
	bset	#$6,$FF800F.l
LDAAE	btst	#$6,$FF800E.l
	beq.b	LDAAE
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
LDAC8	btst	#$6,$FF800E.l
	bne.b	LDAC8
	bclr	#$7,$FF800F.l
	bsr.w	PrintMatchupRatings
	rts
PrintMatchupRating
	bsr.w	PrintTwoSpaces
	move.l	a2,-(sp)
	movea.l	a0,a2
	bsr.w	GetTeamRating
	movea.l	(sp)+,a2
	move.l	d0,-(sp)
	move.w	#$2,d1
	dc.w	$4EB9,$0003,$919A
	dc.w	$4EB9,$0003,$8D9E
	move.l	(sp)+,d0
	rts
PrintTwoSpaces
	move.l	a1,-(sp)
	move.w	(printx).l,-(sp)
	dc.w	$227C,$0002,$8B22
	dc.w	$4EB9,$0003,$8D9E
	move.w	(sp)+,(printx).l
	movea.l	(sp)+,a1
	rts
TwoSpacesTxt
	dc.w	$0004,$2020
ScoutRatingText
	dc.w	$000A,$5368,$6F6F,$7469,$6E67,$000A,$536B,$6174
	dc.w	$696E,$6700,$000A,$5061,$7373,$696E,$6700,$000A
	dc.w	$4465,$6665,$6E73,$6500,$000A,$4368,$6563,$6B69
	dc.w	$6E67,$000A,$4669,$6768,$7469,$6E67,$000E,$476F
	dc.w	$616C,$6B65,$6570,$696E,$6700,$0012,$506F,$7765
	dc.w	$7220,$506C,$6179,$2041,$6476,$2E00,$001A,$2D20
	dc.w	$2020,$2048,$6F6D,$6520,$5465,$616D,$2041,$6476
	dc.w	$2E20,$2020,$2000,$0012,$2020,$2020,$4F76,$6572
	dc.w	$616C,$6C20,$2020,$2020,$FFFF
DrawMatchupPictures
	movem.l	d0-d7/a0-a6,-(sp)
	tst.w	(matchup).l
	bne.w	LDC2A
	move.w	(VisTeam).l,d3
	bsr.w	GetTeamLogo
	move.w	#$2,(printx).l
	move.w	#$F,(printy).l
	move.w	(vispicchars).l,d4
	move.w	#$4,d5
	move.w	#$6000,(printa).l
	bsr.w	DrawMatchupLogo
	move.w	(HomeTeam).l,d3
	bsr.w	GetTeamLogo
	move.w	#$20,(printx).l
	move.w	#$F,(printy).l
	move.w	(homepicchars).l,d4
	move.w	#$0,(printa).l
	move.w	#$2,d5
	bsr.w	DrawMatchupLogo
	move.w	#$64,(palcount).l
	bra.w	LDCA2
LDC2A	move.w	(VisTeam).l,d1
	move.w	(matchupvis).l,d0
	jsr	(DrawPlayerPicture).l
	move.w	#$2,(printx).l
	move.w	#$F,(printy).l
	move.w	(vispicchars).l,d4
	move.w	#$2,d5
	move.w	#$0,(printa).l
	bsr.w	DrawMatchupPicture
	move.w	(HomeTeam).l,d1
	move.w	(matchuphome).l,d0
	jsr	(DrawPlayerPicture).l
	move.w	#$20,(printx).l
	move.w	#$F,(printy).l
	move.w	(homepicchars).l,d4
	move.w	#$0,d5
	move.w	#$0,(printa).l
	bsr.w	DrawMatchupPicture
	move.w	#$64,(palcount).l
LDCA2	movem.l	(sp)+,d0-d7/a0-a6
	rts
DrawMatchupPicture
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	movea.l	#PicturePalette,a0
	adda.l	(a0),a0
	tst.l	(a2)
	bne.w	LDCCC
	movea.l	#PicturePalette,a1
	adda.l	$4(a1),a1
	tst.l	(a2)+
	bra.w	LDCCE
LDCCC	adda.l	(a2)+,a1
LDCCE	bsr.w	UnpackPicture
	movea.l	#picturebuf,a2
	bra.w	DrawMatchupBitmap
DrawMatchupLogo
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	asl.w	#$3,d3
	cmpi.w	#$4,d5
	beq.w	LDCF4
	subi.w	#$20,d3
	bra.w	LDCF8
LDCF4	subi.w	#$40,d3
LDCF8	movea.l	#TeamLogoPalettes,a0
	adda.w	d3,a0
	adda.l	(a2)+,a1
DrawMatchupBitmap
	move.w	#$6,d3
	move.w	#$6,d2
	clr.w	d0
	clr.w	d1
	dc.w	$4EB9,$0003,$87E2
	cmpi.w	#$14,(printx).l
	bgt.w	LDD2C
	move.w	#$2,(printx).l
	bra.w	LDD34
LDD2C	move.w	#$20,(printx).l
LDD34	move.w	#$19,(printy).l
	move.w	#$8,d0
	move.w	#$3,d1
	move.w	#$7FF,d2
	dc.w	$4EB9,$0003,$8C06
	rts
GetTeamLogo
	asl.w	#$2,d3
	movea.l	(TeamLogoBitmaps).l,a0
	movea.l	(a0,d3.w),a0
	rts
PrintMatchupRatings
	tst.w	(matchup).l
	bne.w	LDE4C
	dc.w	$4EB9,$0003,$8D8C
	String	CC_SetMapAndPosition,$0,$1,$16,$16,CC_SetFont,$1
	lea.l	ScoutRatingText(pc),a1
	move.w	#$0,d7
LDD80	move.w	(a1),d0
	asr.w	#$1,d0
	neg.w	d0
	addi.w	#$16,d0
	move.w	d0,(printx).l
	cmpi.w	#$9,d7
	beq.w	LDD9E
	adda.w	(a1),a1
	bra.w	LDDC0
LDD9E	move.w	#$2,(printfontset).l
	move.w	(printy).l,-(sp)
	subi.w	#$3,(printy).l
	dc.w	$4EB9,$0003,$8D9E
	move.w	(sp)+,(printy).l
LDDC0	addi.w	#$1,d7
	tst.w	(a1)
	bpl.w	LDD80
	move.w	#$2,(printfontset).l
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1,$0,$17,'                                        '
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1,$22,$16
	movea.l	#tmstruct,a0
	movea.l	#awtmstruct,a2
	bsr.w	PrintMatchupRating
	move.w	d0,(homerating).l
	move.w	#$2,(printfontset).l
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1,$4,$16
	exg.l	a0,a2
	bsr.w	PrintMatchupRating
	move.w	d0,(visrating).l
	bra.w	LDF8C
LDE4C	move.w	(matchup).l,d0
	subi.w	#$1,d0
	dc.w	$227C,$0002,$8F8E
	bra.w	LDE62
LDE60	adda.w	(a1),a1
LDE62	dbra	d0,LDE60
	dc.w	$4EB9,$0003,$8D8C
	String	CC_SetMapAndPosition,$0,$1,$D,$13,CC_SetFont,$1
	dc.w	$4EB9,$0003,$8D9E
	move.w	#$16,(printy).l
	move.w	#$2,(printfontset).l
	movea.l	#tmstruct,a2
	move.l	(PAttribOverallMask).l,d4
	tst.w	(matchupslot).l
	bne.w	LDEA8
	move.l	(GAttribOverallMask).l,d4
LDEA8	move.w	(matchuphome).l,d0
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1,$0,$17,'                                        '
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1,$23,$17
	bsr.w	PrintPlayerNameRight
	bsr.w	CalcAttrib
	mulu.w	#$64,d0
	divu.w	d1,d0
	bsr.w	AttribAdjust
	move.w	#$2,d1
	move.w	d0,(homerating).l
	dc.w	$4EB9,$0003,$919A
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1,$22,$16
	bsr.w	PrintTwoSpaces
	dc.w	$4EB9,$0003,$8D9E
	movea.l	#awtmstruct,a2
	move.l	(PAttribOverallMask).l,d4
	tst.w	(matchupslot).l
	bne.w	LDF42
	move.l	(GAttribOverallMask).l,d4
LDF42	move.w	(matchupvis).l,d0
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1,$0,$17
	bsr.w	PrintPlayerNameRight
	bsr.w	CalcAttrib
	mulu.w	#$64,d0
	divu.w	d1,d0
	bsr.w	AttribAdjust
	move.w	d0,(visrating).l
	move.w	#$2,d1
	dc.w	$4EB9,$0003,$919A
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1,$4,$16
	bsr.w	PrintTwoSpaces
	dc.w	$4EB9,$0003,$8D9E
LDF8C	rts
MatchupPosNames
	dc.w	$0012,$2020
	move.l	-(a0),d0
	movea.l	-(a3),a0
	dc.w	$656E
	moveq	#$65,d2
	moveq	#$20,d1
	move.l	-(a0),d0
	move.l	-(a0),d0
	dc.w	$0012,$206C
	dc.w	$6566
	moveq	#$20,d2
	dc.w	$666F
	moveq	#$77,d1
	dc.w	$6172
	dc.w	$6420
	move.l	-(a0),d0
	dc.w	$0012,$2072
	dc.w	$6967
	dc.w	$6874
	movea.l	-(a6),a0
	dc.w	$6F72
	dc.w	$7761,$7264,$2020,$0012,$6C65,$6674,$2064,$6566
	dc.w	$656E
Sub_28FD0
	dc.w	$7365,$6D61,$6E20,$0012,$7269,$6768,$7420,$6465
	dc.w	$6665,$6E73,$656D,$616E,$0012,$2020,$2020,$2067
	dc.w	$6F61,$6C69,$6520,$2020,$2020
GetMatchupPlayers
	movem.l	d0/a0-a1,-(sp)
	movea.l	#tmstruct,a0
	bsr.w	GetMatchupPlayer
	move.w	d0,(matchuphome).l
	movea.l	#awtmstruct,a0
	bsr.w	GetMatchupPlayer
	move.w	d0,(matchupvis).l
	movem.l	(sp)+,d0/a0-a1
	rts
GetMatchupPlayer
	movea.l	$1E(a0),a0
	adda.w	$6(a0),a0
	move.w	(matchup).l,d0
	dc.w	$227C,$0002,$9050
	move.b	(a1,d0.w),d0
	ext.w	d0
	move.w	d0,(matchupslot).l
	move.b	(a0,d0.w),d0
	ext.w	d0
	subi.w	#$1,d0
	rts
MatchupLineSlots
	dc.w	$0004,$0305
	dc.w	$0102
	dc.l	$4279
	dc.w	$0001,$A448
	clr.w	(advframe).l
	rts
PrintAdvantageMarks
	movem.l	d0-d7/a0-a6,-(sp)
	addi.w	#$1,(advcount).l
	cmpi.w	#$7,(advcount).l
	blt.w	LE0A0
	clr.w	(advcount).l
	addi.w	#$1,(advframe).l
	cmpi.w	#$6,(advframe).l
	blt.w	LE0A0
	move.w	#$5,(advframe).l
LE0A0	move.w	(advframe).l,d1
	asl.w	#$2,d1
	dc.w	$227C,$0002,$90FE
	move.w	(homerating).l,d0
	cmp.w	(visrating).l,d0
	bgt.w	LE0C8
	beq.w	LE0D0
	dc.w	$227C,$0002,$9116
LE0C8	movea.l	(a1,d1.w),a1
	bra.w	LE0D6
LE0D0	movea.l	#EvenAdvTxt,a1
LE0D6	move.w	#$2,(printfontset).l
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1,$13,$16
	dc.w	$4EB9,$0003,$8D9E
	move.w	#$0,(printfontset).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
HomeAdvMarks
	dc.w	$0002,$912E
	dc.w	$0002,$9134
	dc.w	$0002,$913A
	dc.w	$0002,$9140
	dc.w	$0002,$9140
	dc.w	$0002,$9140
VisAdvMarks
	dc.w	$0002,$9146
	dc.w	$0002,$914C
	dc.w	$0002,$9152
	dc.w	$0002,$9158
	dc.w	$0002,$9158
	dc.w	$0002,$9158
HomeAdv0Txt
	dc.w	$0006,$2020
	move.l	d0,d0
HomeAdv1Txt
	dc.w	$0006,$5D20
	move.l	d0,d0
HomeAdv2Txt
	dc.w	$0006,$5D5D
	move.l	d0,d0
HomeAdv3Txt
	dc.w	$0006,$5D5D
	subq.b	#$6,d0
VisAdv0Txt
	dc.w	$0006,$2020
	move.l	d0,d0
VisAdv1Txt
	dc.w	$0006,$2020
	subq.b	#$5,d0
VisAdv2Txt
	dc.w	$0006,$205B
	subq.b	#$5,d0
VisAdv3Txt
	dc.w	$0006,$5B5B
	subq.b	#$5,d0
EvenAdvTxt
	dc.w	$0006,$2020
	move.l	d0,d0
GetTeamNickname
	movem.l	d0/a0/a2,-(sp)
	movea.l	a2,a1
	movea.l	$1E(a1),a1
	adda.w	$4(a1),a1
	adda.w	(a1),a1
	adda.w	(a1),a1
	cmpi.w	#$2,(a1)
	bne.w	LE194
	dc.w	$227C,$0002,$919A
	cmpa.l	#$1834C,a2
	beq.w	LE194
	dc.w	$227C,$0002,$91A0
LE194	movem.l	(sp)+,d0/a0/a2
	rts
HomeTxt
	dc.w	$0006,$486F
	dc.w	$6D65
VisitorsTxt
	dc.w	$000A,$5669,$7369,$746F,$7273
GetTeamArena
	movem.l	d0/a0/a2,-(sp)
	movea.l	a2,a1
	movea.l	$1E(a1),a1
	adda.w	$4(a1),a1
	adda.w	(a1),a1
	adda.w	(a1),a1
	adda.w	(a1),a1
	movem.l	(sp)+,d0/a0/a2
	rts
ScoutStub
	movem.l	d0-d7/a0-a6,-(sp)
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	movem.l	d0-d7/a0-a6,-(sp)
	bset	#$2,$17F6C.l
	dc.w	$4EB9,$0003,$0094
	dc.w	$33FC,$0060,$0001,$AD72
	dc.w	$267C,$0001,$7480
	move.w	#$0,d0
	dc.w	$3439,$0001,$A416
	dc.w	$B479,$0001,$A418
	bgt.w	LE206
	move.w	#$6,d0
LE206	asl.w	#$7,d0
	adda.w	d0,a3
	move.w	#$4,d2
	move.w	#$6,d3
	bra.w	LE268
LE216	movem.w	d2-d3,-(sp)
	dc.w	$4EB9,$0003,$D770
	move.w	#$2,$34(a3)
	move.w	#$F0,d0
	dc.w	$4A79,$0001,$7CEA
	bmi.w	LE238
	move.w	#$FF10,d0
LE238	dc.w	$D079,$0001,$7CEA
	move.w	d0,$14(a3)
	move.w	#$0,$0(a3)
	move.w	#$7,d0
	dc.w	$4EB9,$0003,$62D8
	bclr	#$5,$62(a3)
	bclr	#$1,$63(a3)
	bclr	#$2,$62(a3)
	movem.w	(sp)+,d2-d3
LE268	adda.l	#$80,a3
	dbra	d2,LE216
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ClampPositionBox
	movem.l	d0-d7/a0,-(sp)
	move.w	$34(a3),d7
	subi.w	#$1,d7
	movea.l	#$292E2,a0
	btst	#$7,$62(a3)
	beq.w	LE29A
	movea.l	#$292F2,a0
LE29A	add.w	d7,d7
	move.w	(a0,d7.w),d0
	cmp.w	$44(a3),d0
	blt.w	LE2AC
	move.w	d0,$44(a3)
LE2AC	move.w	$2(a0,d7.w),d0
	cmp.w	$44(a3),d0
	bgt.w	LE2BC
	move.w	d0,$44(a3)
LE2BC	move.w	$4(a0,d7.w),d0
	cmp.w	$46(a3),d0
	blt.w	LE2CC
	move.w	d0,$46(a3)
LE2CC	move.w	$6(a0,d7.w),d0
	cmp.w	$46(a3),d0
	bgt.w	LE2DC
	move.w	d0,$46(a3)
LE2DC	movem.l	(sp)+,d0-d7/a0
	rts
	dc.w	$FFB5,$0000,$0000,$0108,$0000,$004B,$0000,$0108
	dc.w	$FFB5,$0000,$FEF8,$0000,$0000,$004B,$FEF8,$0000
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#$1A414,a0
	dc.w	$203C,$0000,$0012
LE312	clr.w	(a0)+
	dbra	d0,LE312
	movea.l	#tmstruct,a0
	move.w	#$365,d0
LE322	clr.w	(a0)+
	dbra	d0,LE322
	dc.w	$207C,$0001,$8022
	dc.w	$203C,$0000,$0024
LE334	clr.w	(a0)+
	dbra	d0,LE334
	clr.w	$17F70.l
	clr.w	$17F72.l
	clr.w	(sflags6).l
	clr.w	$17F78.l
	clr.w	$19390.l
	clr.w	$193A0.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
AddArenaAnimSprite
	dc.w	$4A79,$0001,$A556
	bmi.w	Sub_2948C
	dc.w	$4AB9,$0001,$A55C
	beq.w	Sub_2948C
	btst	#$4,$17F72.l
	bne.w	Sub_2948C
	btst	#$3,$17F6C.l
	bne.w	Sub_2948C
	btst	#$7,$17F6A.l
	bne.w	Sub_2948C
	dc.w	$2279,$0001,$A55C
	adda.l	$4(a1),a1
	dc.w	$3839,$0001,$7CEE
	dc.w	$3A39,$0001,$7CEA
	dc.w	$3039,$0001,$A550
	bra.w	Sub_293DC
	dc.w	$0242,$000F,$0C42,$0003,$6300,$0004,$7403,$6000
	dc.w	$000A,$3003,$D042,$6100,$0008,$51CA,$FFF6,$4E75
Sub_293DC
	ext.w	d0
	beq.w	Sub_2948C
	cmpi.w	#$40,d6
	bge.w	Sub_2948C
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
LE428	cmp.w	$2(a0),d2
	bgt.w	LE480
	cmp.w	$2(a0),d3
	blt.w	LE480
	cmp.w	(a0),d0
	bgt.w	LE480
	cmp.w	(a0),d1
	blt.w	LE480
	move.w	$2(a0),d5
	addi.w	#$70,d5
	sub.w	d2,d5
	move.w	d5,(a6)+
	move.b	$7(a0),(a6)+
	move.b	d6,(a6)+
	move.w	$6(a0),d5
	andi.w	#$F800,d5
	add.w	$4(a0),d5
	dc.w	$DA79,$0001,$A54E
	move.w	d5,(a6)+
	move.w	(a0),d5
	addi.w	#$70,d5
	sub.w	d0,d5
	move.w	d5,(a6)+
	addi.w	#$1,d6
	cmpi.w	#$40,d6
	beq.w	LE488
LE480	adda.w	#$8,a0
	dbra	d4,LE428
LE488	movem.l	(sp)+,d0-d5
Sub_2948C
	rts
PrintPlayerNameRight
	movem.l	d0-d7/a0-a6,-(sp)
	dc.w	$33C0,$0001,$AD8A
	move.l	a2,-(sp)
	dc.w	$4EB9,$0004,$11D6
	movea.l	a1,a0
	move.w	(a0),d0
	move.w	d0,d5
	tst.b	-$1(a0,d5.w)
	bne.w	LE4BE
	subi.w	#$1,d0
	tst.b	-$2(a0,d5.w)
	bne.w	LE4BE
	subi.w	#$1,d0
LE4BE	add.w	(printx).l,d0
	subi.w	#$29,d0
	bmi.w	LE4D4
	neg.w	d0
	add.w	d0,(printx).l
LE4D4	movea.l	a0,a1
	dc.w	$4EB9,$0003,$8F80
	movea.l	(sp)+,a2
	dc.w	$4EB9,$0002,$B3FE
	movem.l	(sp)+,d0-d7/a0-a6
	rts
