NextShooter
	btst	#$3,$17F78.l
	beq.w	LCA42
	jmp	$3F2BE.l
LCA42	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	StartShootoutPath
	dc.w	$33F9,$0001,$A436,$0001,$9366
	dc.w	$33FC,$000B,$0001,$936A
	dc.w	$207C,$0001,$A41C
	dc.w	$4A79,$0001,$A436
	beq.w	LCA7A
	dc.w	$33FC,$0005,$0001,$936A
	dc.w	$207C,$0001,$A42A
LCA7A	dc.w	$3039,$0001,$A428
	add.w	d0,d0
	dc.w	$33F0,$0000,$0001,$936C
	bclr	#$2,$17BE2.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
CountShootoutGoals
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#$0,$1A437.l
	beq.w	LCAD6
	cmpi.w	#$5,$1A41A.l
	blt.w	LCAD6
	dc.w	$3039,$0001,$A416
	dc.w	$B079,$0001,$A418
	beq.w	LCAD6
	bset	#$3,$17F78.l
	jsr	$291CE.l
	bra.w	LCB04
LCAD6	dc.w	$0A79,$0001,$0001,$A436
	bne.w	LCB04
	dc.w	$0679,$0001,$0001,$A428
	dc.w	$0C79,$0005,$0001,$A428
	blt.w	LCAFC
	dc.w	$4279,$0001,$A428
LCAFC	addi.w	#$1,$1A41A.l
LCB04	movem.l	(sp)+,d0-d7/a0-a6
	rts
InitShooters
	dc.w	$207C,$0001,$A428
	move.w	(HomeTeam).l,d0
	dc.w	$4A79,$0001,$A436
	beq.w	LCB2C
	move.w	(VisTeam).l,d0
	dc.w	$207C,$0001,$A436
LCB2C	movea.l	#TeamList,a1
	asl.w	#$2,d0
	movea.l	(a1,d0.w),a1
	adda.w	$6(a1),a1
	move.w	#$5,d0
LCB40	clr.w	d1
	move.b	(a1)+,d1
	subi.w	#$1,d1
	move.w	d1,-(a0)
	dbra	d0,LCB40
	rts
ShootoutWonBy
	movem.l	d0-d7/a0-a6,-(sp)
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1Pri,$1,$D
	move.w	#$6,d1
	move.w	#$1E,d0
	dc.w	$4EB9,$0003,$8CA0
	dc.w	$4EB9,$0003,$9258
	String	CC_Font1Pri,$2,$E,'SHOOTOUT WON BY'
	addi.w	#$2,(printy).l
	move.w	(HomeTeam).l,d1
	dc.w	$3039,$0001,$A416
	dc.w	$B079,$0001,$A418
	bgt.w	LCBAC
	move.w	(VisTeam).l,d1
LCBAC	asl.w	#$2,d1
	movea.l	#TeamList,a1
	movea.l	(a1,d1.w),a1
	adda.w	$4(a1),a1
	move.w	#$2,(printx).l
	dc.w	$4EB9,$0003,$926A
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ShootoutShooters
	btst	#$0,$17F78.l
	beq.w	LCC80
	moveq	#$0,d0
	moveq	#$1C,d1
	dc.w	$4EB9,$0002,$E728
	clr.w	(scoutcolumn).l
	clr.w	(PlayerScrollCtr).l
	dc.w	$4EB9,$0003,$8D8C
	dc.w	$0008
	dc.b	$FF,$02,$FD,$00,$FC,$00
	moveq	#$28,d0
	moveq	#$1C,d1
	move.w	#$7FF,d2
	dc.w	$4EB9,$0003,$8C06
	bsr.w	Sub_28038
	bsr.w	Sub_28046
	move.w	#$0,(TestList).l
LCC1E	bsr.w	Sub_27F9C
	bsr.w	Sub_2813E
	bsr.w	Sub_280D6
ShootersLoop
	dc.w	$4EB9,$0002,$C63A
	dc.w	$4EB9,$0002,$F2F0
	dc.w	$4EB9,$0003,$74BE
	btst	#$7,d1
	bne.w	LCC80
	move.w	#$1,d0
	btst	#$1,d1
	bne.w	ShootersMove
	move.w	#$FFFF,d0
	btst	#$0,d1
	bne.w	ShootersMove
	move.w	#$0,d0
	btst	#$2,d1
	bne.w	Sub_27F54
	move.w	#$5,d0
	btst	#$3,d1
	bne.w	Sub_27F54
	btst	#$5,d1
	bne.w	ShooterSelectList
	bra.w	ShootersLoop
LCC80	jmp	(Sub_2E980).l
ShooterSelectList
	move.w	#$C000,d7
	dc.w	$207C,$0001,$A41C
	cmpa.l	#$1834C,a2
	beq.w	LCCA0
	dc.w	$207C,$0001,$A42A
LCCA0	move.w	(TestList).l,d0
	asl.w	#$1,d0
	move.w	(a0,d0.w),d6
	dc.w	$4EB9,$0002,$ED60
	move.w	d0,d1
	dc.w	$4EB9,$0002,$EDBC
	sub.w	d1,d0
	subi.w	#$1,d0
	cmpi.w	#$5,(TestList).l
	bne.w	LCCD4
	move.w	d1,d0
	subi.w	#$1,d0
	clr.w	d1
LCCD4	move.w	d0,(screentimer).l
	clr.w	(PlayerScrollCtr).l
	clr.w	(VertLineScrolling).l
	dc.w	$207C,$000B,$BD30
	clr.w	d2
LCCEE	move.b	d1,(a0,d2.w)
	cmp.w	d1,d6
	bne.w	LCCFE
	move.w	d2,(VertLineScrolling).l
LCCFE	addi.w	#$1,d1
	addi.w	#$1,d2
	dbra	d0,LCCEE
	bsr.w	ClearShooterScreen
	dc.w	$4EB9,$0003,$8D8C
	String	CC_SetMapAndPosition,$0,$3,$1,$0
	move.w	#$12,d0
	move.w	#$3,d1
	dc.w	$4EB9,$0003,$8CA0
	dc.w	$4EB9,$0003,$8D8C
	String	CC_Font3,$15,$FC
	move.w	#$12,d0
	move.w	#$3,d1
	dc.w	$4EB9,$0003,$8CA0
	dc.w	$4EB9,$0003,$8D8C
	String	CC_SetMapAndPosition,$4,$2,$2,$1,'{Select Player}'
	clr.w	d0
	bra.w	LCDC8
LCD66	jsr	(MenuWaitVblank).l
	dc.w	$4EB9,$0002,$F2F0
	dc.w	$4EB9,$0003,$74BE
	btst	#$7,d1
	bne.w	LCC1E
	btst	#$5,d1
	bne.w	LCE0E
	moveq	#$1,d0
	btst	#$1,d1
	bne.w	LCDC8
	btst	#$3,d1
	bne.w	LCDB0
	moveq	#-1,d0
	btst	#$0,d1
	bne.w	LCDC8
	btst	#$2,d1
	bne.w	LCDB0
	bra.w	LCD66
LCDB0	add.w	(scoutcolumn).l,d0
	bmi.w	LCD66
	move.w	d0,(scoutcolumn).l
	bsr.w	PrintShooterList
	bra.w	LCD66
LCDC8	add.w	(VertLineScrolling).l,d0
	bmi.w	LCD66
	cmp.w	(screentimer).l,d0
	bgt.w	LCD66
	move.w	d0,(VertLineScrolling).l
	cmp.w	(PlayerScrollCtr).l,d0
	bgt.w	LCDF2
	move.w	d0,(PlayerScrollCtr).l
LCDF2	subi.w	#$5,d0
	cmp.w	(PlayerScrollCtr).l,d0
	ble.w	LCE06
	move.w	d0,(PlayerScrollCtr).l
LCE06	bsr.w	PrintShooterList
	bra.w	LCD66
LCE0E	dc.w	$267C,$000B,$BD30
	adda.w	(VertLineScrolling).l,a3
	clr.w	d0
	move.b	(a3),d0
	move.w	(TestList).l,d2
	dc.w	$207C,$0001,$A41C
	cmpa.l	#$1834C,a2
	beq.w	LCE3A
	dc.w	$207C,$0001,$A42A
LCE3A	asl.w	#$1,d2
	move.w	d0,(a0,d2.w)
	bra.w	LCC1E
PrintShooterList
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font2Pri,$16,$1
LCE50	movea.l	#$41C5E,a1
	cmpi.w	#$5,(TestList).l
	bne.w	LCE68
	movea.l	#$41DC0,a1
LCE68	move.w	(scoutcolumn).l,d0
	bra.w	LCE78
LCE72	adda.w	(a1),a1
	adda.w	#$4,a1
LCE78	tst.w	(a1)
	dbmi	d0,LCE72
	bpl.w	LCE8E
	subi.w	#$1,(scoutcolumn).l
	bra.w	LCE50
LCE8E	cmpa.l	#$41C5E,a1
	bne.w	LCE9E
	movea.l	#$27F28,a1
LCE9E	cmpa.l	#$41DC0,a1
	bne.w	LCEAE
	movea.l	#$27F3E,a1
LCEAE	jsr	(print).l
	move.l	(a1),d4
	dc.w	$267C,$000B,$BD30
	move.w	(PlayerScrollCtr).l,d2
	move.w	(screentimer).l,d1
	sub.w	d2,d1
	cmpi.w	#$5,d1
	bls.w	LCED4
	moveq	#$5,d1
LCED4	move.w	#$2,(printy).l
LCEDC	jsr	(printsmallz).l
	dc.w	$0020
	dc.b	$FE,$04,$FD,$05,$FA,$01,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$FD,$05
	cmp.w	(VertLineScrolling).l,d2
	bne.w	LCF12
	move.w	d7,(printa).l
LCF12	clr.w	d0
	move.b	(a3,d2.w),d0
	dc.w	$4EB9,$0002,$D56A
	addi.w	#$1,d2
	dbra	d1,LCEDC
	rts
	dc.w	$0012,$2020,$2020,$4F76,$6572,$616C,$6C20,$2020
	dc.w	$205D,$1F3A,$000A,$0012,$2020,$2020,$4F76,$6572
	dc.w	$616C,$6C20,$2020,$205D,$1B0F,$000A
Sub_27F54
	cmp.w	(TestList).l,d0
	beq.w	ShootersLoop
	bra.w	LCF8A
ShootersMove
	cmpi.w	#$5,(TestList).l
	beq.w	ShootersLoop
	add.w	(TestList).l,d0
	bmi.w	ShootersSelect
	cmpi.w	#$5,d0
	blt.w	LCF8A
	clr.w	d0
	bra.w	LCF8A
ShootersSelect
	move.w	#$4,d0
LCF8A	move.w	d0,(TestList).l
	bsr.w	Sub_2813E
	bsr.w	Sub_280D6
	bra.w	ShootersLoop
Sub_27F9C
	bsr.w	ClearShooterScreen
	movem.l	d0-d5/a0-a2,-(sp)
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font3,$0,$0
	movea.l	(EASportsBGMap).l,a1
	adda.l	$4(a1),a1
	movea.l	#$1B008,a2
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	$2(a1),d3
	moveq	#$1,d4
	moveq	#$0,d5
	dc.w	$4EB9,$0003,$87E2
	movem.l	(sp)+,d0-d5/a0-a2
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font2Pri,$7,$1
	moveq	#$1A,d0
	moveq	#$6,d1
	dc.w	$4EB9,$0003,$8CA0
	dc.w	$4EB9,$0003,$9258
	String	CC_Font2Pri,$A,$4,'  Shootout  ',CC_Font2Pri,$F,$1
	clr.w	d0
	cmpa.l	#$1834C,a2
	beq.w	LD018
	move.w	#$2C,d0
LD018	jmp	(Sub_2C59E).l
ClearShooterScreen
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font2Pri,$0,$0
	moveq	#$28,d0
	moveq	#$A,d1
	move.w	#$7FF,d2
	dc.w	$4EF9,$0003,$8C06
Sub_28038
	clr.w	$BBD0A.l
	clr.w	$BBD2A.l
	rts
Sub_28046
	dc.w	$4EB9,$0003,$8D8C
	dc.w	$0008
	dc.b	$FF,$02,$FD,$00,$FC,$0A
	dc.w	$4EB9,$0003,$8D8C
	String	CC_Font2,$4
	dc.w	$4EB9,$0003,$8D8C
	String	CC_Font3,$7,$FC,$C,'Shooters'
	dc.w	$4EB9,$0003,$8D8C
	String	CC_Font3,$3,$FC,$E,'1. '
	dc.w	$4EB9,$0003,$8D8C
	String	CC_Font3,$3,$FC,$10,'2. '
	dc.w	$4EB9,$0003,$8D8C
	String	CC_Font3,$3,$FC,$12,'3. '
	dc.w	$4EB9,$0003,$8D8C
	String	CC_Font3,$3,$FC,$14,'4. '
	dc.w	$4EB9,$0003,$8D8C
	String	CC_Font3,$3,$FC,$16,'5. '
	dc.w	$4EB9,$0003,$8D8C
	String	CC_Font3,$1A,$FC,$C,'Goalie'
	rts
Sub_280D6
	dc.w	$4EB9,$0003,$8D8C
	String	CC_SetMapAndPosition,$4,$2,$8,$7,CC_SetFont,$1
	moveq	#$18,d0
	moveq	#$3,d1
	dc.w	$4EB9,$0003,$8CA0
	dc.w	$4EB9,$0003,$8D8C
	String	CC_Font3,$15,$FC,$8,CC_Font2,$6
	dc.w	$227C,$0001,$A41C
	cmpa.l	#$1834C,a2
	beq.w	LD114
	dc.w	$227C,$0001,$A42A
LD114	move.w	(TestList).l,d0
	asl.w	#$1,d0
	move.w	(a1,d0.w),d0
	dc.w	$4EB9,$0004,$112E
	move.w	(a1),d0
	lsr.w	#$1,d0
	sub.w	d0,(printx).l
	dc.w	$4EB9,$0003,$8D9E
	clr.w	(printfontset).l
	rts
Sub_2813E
	movem.l	d0-d7/a0-a6,-(sp)
	dc.w	$4EB9,$0003,$8D8C
	String	CC_Font3,$6,$FC,$E,CC_Font2,$6
	move.w	#$0,d1
	dc.w	$207C,$0001,$A41C
	cmpa.l	#$1834C,a2
	beq.w	LD16A
	dc.w	$207C,$0001,$A42A
LD16A	move.w	d1,d0
	asl.w	#$1,d0
	move.w	(a0,d0.w),d0
	jsr	$41226.l
	move.w	(printx).l,-(sp)
	cmp.w	(TestList).l,d1
	bne.w	LD190
	move.w	#$2,(printfontset).l
LD190	cmpi.w	#$5,d1
	bne.w	LD1A8
	move.w	#$19,(printx).l
	move.w	#$E,(printy).l
LD1A8	jsr	(printsmall).l
	clr.w	(printfontset).l
	move.w	(sp)+,(printx).l
	addi.w	#$2,(printy).l
	addi.w	#$1,d1
	cmpi.w	#$6,d1
	blt.w	LD16A
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ScoutCrowdRecord
	movem.l	d0-d7/a0/a2-a6,-(sp)
	move.w	(HomeTeam).l,d1
	ext.l	d1
	movea.l	#teamrecbuf,a0
	move.l	a0,-(sp)
	jsr	(ReadCrowdRecord).l
	movea.l	(sp)+,a0
	movea.l	#TempBuffer,a1
	clr.w	d0
	move.b	$8(a0),d0
	bne.w	LD204
	move.b	#$50,d0
LD204	move.l	a1,-(sp)
	jsr	(AppendNumber).l
	movea.l	(sp)+,a1
	movem.l	(sp)+,d0-d7/a0/a2-a6
	rts
ScoutCrowdRecordBy
	movem.l	d0-d7/a0/a2-a6,-(sp)
	move.w	(HomeTeam).l,d1
	ext.l	d1
	movea.l	#teamrecbuf,a0
	move.l	a0,-(sp)
	jsr	(ReadCrowdRecord).l
	movea.l	(sp)+,a0
	tst.b	$9(a0)
	beq.w	LD27E
	movea.l	#ThreeStars,a3
	dc.w	$227C,$0002,$828C
	move.l	a3,-(sp)
	jsr	(CopyString).l
	movea.l	(sp)+,a3
	clr.w	d2
	move.b	$9(a0),d2
	movea.l	#TempBuffer,a1
	bset	#$7,(sflags6).l
	bsr.w	AppendUserName
	dc.w	$4EB9,$0003,$9208
	dc.w	$227C,$0002,$8292
	dc.w	$4EB9,$0003,$9208
	movea.l	a3,a1
	bra.w	LD284
LD27E	movea.l	#ScoutEmptyTxt,a1
LD284	movem.l	(sp)+,d0-d7/a0/a2-a6
	rts
ScoutEmptyTxt
	ori.b	#$6,d2
	dc.w	$6279
	move.l	d0,d0
ScoutSpaceTxt
	dc.w	$0004,$2000
GetTeamCity
	movem.l	d0-d7/a0/a2-a6,-(sp)
	clr.w	d2
	move.b	$A(a0),d2
	asl.w	#$2,d2
	movea.l	#TeamList,a1
	movea.l	(a1,d2.w),a1
	adda.w	$4(a1),a1
	movem.l	(sp)+,d0-d7/a0/a2-a6
	rts
ScoutingReport
	move.l	sp,(ScoutSavedSP).l
	movea.l	#$1745C,sp
	movea.l	(ScoutSpeechTable).l,a0
	movea.l	#$C458,a1
	move.w	#$DAC,d0
LD2D2	move.l	(a0)+,(a1)+
	dbra	d0,LD2D2
	move.l	(ScoutSpeechTable).l,d1
	subi.l	#$C458,d1
	sub.l	d1,(ScoutSpeechTable).l
	sub.l	d1,(SmallFontMap).l
	sub.l	d1,(HotMap).l
	sub.l	d1,(ColdMap).l
	jsr	(ReadNameLog).l
	jsr	(BuildHotColdLists).l
	clr.w	(advframe).l
	move.w	#$7A,-(sp)
	dc.w	$4EB9,$0003,$71D2
	move.l	#vb2,(VBint).l
	dc.w	$4EB9,$0003,$F11E
	move.l	a0,-(sp)
	movea.l	#tmstruct,a0
	jsr	(Create_HotCold_Table).l
	movea.l	#awtmstruct,a0
	jsr	(Create_HotCold_Table).l
	movea.l	(sp)+,a0
	jsr	(BuildHotColdLists).l
	bclr	#$1,(disflags).l
	move.w	#$6,(Map1col).l
	move.w	#$6,(Map2col).l
	move.w	#$0,d0
	dc.w	$4EB9,$0003,$7B5A
	move.w	#$2,d4
	move.w	d4,(homepicchars).l
	addi.w	#$24,d4
	move.w	d4,(vispicchars).l
	addi.w	#$24,d4
	move.w	d4,(BigFontchars).l
	movea.l	(BigFontMap).l,a2
	addq.l	#$8,a2
	dc.w	$4EB9,$0003,$8946
	dc.l	$05431567,$79ABCDEF
	dc.w	$4EB9,$0003,$93E8
	move.w	d4,(smallfont2chars).l
	movea.l	(SmallFontMap).l,a2
	addq.l	#$8,a2
	dc.w	$4EB9,$0003,$8946
	dc.l	$0A234567,$89ABCDEF
	movea.l	(FramerMap).l,a2
	addq.l	#$8,a2
	move.w	d4,(framercset).l
	dc.w	$4EB9,$0003,$8946
	dc.l	$05422561,$89ABCDEF
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font2,$0,$0
	movea.l	(EASportsBGMap).l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$28,d2
	moveq	#$1C,d3
	moveq	#$3,d5
	dc.w	$4EB9,$0003,$87E2
	dc.w	$4EB9,$0003,$9258
	String	CC_Font1Pal2,$C,$D,'MATCHUPS'
	move.w	#$0,(printfontset).l
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1,$10,$11,'ADVANTAGE:'
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font2Pal2,$6,$3
	moveq	#$21,d0
	moveq	#$9,d1
	dc.w	$4EB9,$0003,$8CA0
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font2Pal2,$1,$E
	move.w	#$8,d0
	move.w	#$8,d1
	dc.w	$4EB9,$0003,$8CA0
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font2Pal2,$1F,$E
	move.w	#$8,d0
	move.w	#$8,d1
	dc.w	$4EB9,$0003,$8CA0
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1,$1,$1
	movea.l	(RonBarrMap).l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	$2(a1),d3
	moveq	#$C,d5
	dc.w	$4EB9,$0003,$87E2
	movea.l	(HotMap).l,a2
	adda.l	#$8,a2
	move.w	d4,(hoticonchars).l
	dc.w	$4EB9,$0003,$8958
	movea.l	(ColdMap).l,a2
	adda.l	#$8,a2
	move.w	d4,(coldiconchars).l
	dc.w	$4EB9,$0003,$8958
	clr.w	(matchup).l
	clr.w	(scoutunused).l
	move.w	#$10D,(matchuptimer).l
	bsr.w	GetMatchupPlayers
	bsr.w	DrawMatchupPictures
	bsr.w	PrintMatchupRatings
	move.w	#$3,(advframe).l
	move.w	#$0,(advcount).l
	bsr.w	PrintAdvantageMarks
	move.w	#$18,(palcount).l
	move.l	#vb2,(VBint).l
	bset	#$5,$FF800F.l
LD52E	tst.w	(palcount).l
	bpl.w	LD52E
	dc.w	$4EB9,$0003,$F86C
	move.w	#$1B,(a0)+
	move.w	#$1D,(a0)+
	move.w	#$1A,(a0)+
	move.w	#$1D,(a0)+
	move.w	(HomeTeam).l,d0
	move.w	#$24,(a0)+
	move.w	#$1D,(a0)+
	move.w	d0,d1
	mulu.w	#$7,d1
	addi.w	#$26,d1
	move.w	d1,(a0)+
	move.w	#$1D,(a0)+
	move.w	#$1D,(a0)+
	move.w	(VisTeam).l,d0
	mulu.w	#$7,d0
	addi.w	#$26,d0
	move.w	d0,(a0)+
	move.w	#$1D,(a0)+
	move.w	#$1D,(a0)+
	move.l	d2,-(sp)
	move.w	d1,d2
	addq.w	#$1,d2
	ori.w	#$8000,d2
	move.w	d2,(a0)+
	move.w	#$1D,(a0)+
	move.w	d0,d2
	addq.w	#$1,d2
	move.w	d2,(a0)+
	move.w	#$1D,(a0)+
	move.w	d1,d2
	addq.w	#$5,d2
	ori.w	#$8000,d2
	move.w	d2,(a0)+
	move.w	#$1D,(a0)+
	move.w	d0,d2
	addq.w	#$5,d2
	move.w	d2,(a0)+
	move.w	#$1D,(a0)+
	move.w	d1,d2
	addq.w	#$6,d2
	ori.w	#$8000,d2
	move.w	d2,(a0)+
	move.w	#$1D,(a0)+
	move.w	d0,d2
	addq.w	#$6,d2
	move.w	d2,(a0)+
	move.w	#$1D,(a0)+
	move.w	d1,d2
	addq.w	#$3,d2
	ori.w	#$8000,d2
	move.w	d2,(a0)+
	move.w	#$1D,(a0)+
	move.w	d0,d2
	addq.w	#$3,d2
	move.w	d2,(a0)+
	move.w	#$1D,(a0)+
	move.w	d1,d2
	addq.w	#$2,d2
	ori.w	#$8000,d2
	move.w	d2,(a0)+
	move.w	#$1D,(a0)+
	move.w	d0,d2
	addq.w	#$2,d2
	move.w	d2,(a0)+
	move.w	#$1D,(a0)+
	move.w	d1,d2
	addq.w	#$4,d2
	ori.w	#$8000,d2
	move.w	d2,(a0)+
	move.w	#$1D,(a0)+
	move.w	d0,d2
	addq.w	#$4,d2
	move.w	d2,(a0)+
	move.w	#$1D,(a0)+
	move.l	(sp)+,d2
	move.w	#$21,(a0)+
	move.w	#$FFFF,(a0)
	clr.w	(asv).l
	move.w	#$7FFF,(screentimer).l
	move.l	#$8CA0,(scoutwait).l
	dc.w	$4EB9,$0003,$7652
LD642	btst	#$7,$FF800E.l
	bne.b	LD642
	move.w	#$3C,$FF8020.l
	bset	#$6,$FF800F.l
LD65C	btst	#$6,$FF800E.l
	beq.b	LD65C
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
LD676	btst	#$6,$FF800E.l
	bne.b	LD676
	bclr	#$7,$FF800F.l
	bclr	#$5,$FF800F.l
	move.w	#$F,d7
	jsr	$6044.w
	move.w	#$0,(ScoutLastPara).l
LD6A0	dc.w	$207C,$0000,$0000
	move.w	#$9,d0
	move.w	#$10,d7
	jsr	$6044.w
	tst.w	d0
	beq.w	LD6A0
	movea.l	#$FFFFFFFF,a0
	move.w	#$9,d0
	move.w	#$10,d7
	jsr	$6044.w
	move.w	#$0,(ScoutingReportTimer).l
	move.w	(SelectedPlayerIdx).l,d0
	movea.l	#TestList,a0
	move.w	(a0,d0.w),d1
	btst	#$F,d1
	dc.w	$6738
	bclr	#$F,d1
	move.w	d1,(a0,d0.w)
	move.l	d1,-(sp)
	move.w	#$1,d0
	bclr	#$3,$FF8033.l
	bsr.w	PageMatchup
	bset	#$3,$FF8033.l
	move.w	#$3,(advframe).l
	move.w	#$0,(advcount).l
	bsr.w	PrintAdvantageMarks
	move.l	(sp)+,d1
LD720	move.l	d1,d0
	cmpi.w	#$21,d0
	dc.w	$6608
	move.w	#$1,(ScoutLastPara).l
LD730	bsr.w	ScoutParaOffset
	move.l	d0,(scoutparaoff).l
	move.l	d1,-(sp)
	dc.w	$4EB9,$0003,$74F0
	move.w	d3,d5
	dc.w	$4EB9,$0003,$750E
	or.w	d3,d5
	btst	#$1,$1AD77.l
	bne.w	LD870
	move.l	(sp)+,d1
LD75A	btst	#$7,$FF800E.l
	bne.b	LD75A
	move.w	#$2E,$FF8020.l
	bset	#$6,$FF800F.l
LD774	btst	#$6,$FF800E.l
	beq.b	LD774
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
LD78E	btst	#$6,$FF800E.l
	bne.b	LD78E
	bclr	#$7,$FF800F.l
	bset	#$5,$FF800F.l
	movea.l	#$FF8000,a5
	move.l	d1,d3
	asl.w	#$3,d1
	movea.l	(ScoutSpeechTable).l,a0
	move.l	(a0,d1.w),d2
	move.l	$4(a0,d1.w),d1
	move.w	#$6,d7
	jsr	$6044.w
	move.l	a0,d0
	move.w	#$0,d7
	jsr	$6044.w
	tst.w	(ScoutLastPara).l
	dc.w	$664A
	move.w	(SelectedPlayerIdx).l,d0
	movea.l	#TestList,a0
LD7E6	addi.w	#$2,d0
	move.w	(a0,d0.w),d1
	cmpi.w	#$1D,d1
	beq.w	LD7E6
	bclr	#$F,d1
	move.l	d1,d0
	bsr.w	ScoutParaOffset
	asl.w	#$3,d1
	movea.l	(ScoutSpeechTable).l,a0
	move.l	(a0,d1.w),d2
	subi.w	#$2,d2
	move.l	d2,(ScoutCDArg).l
	lea.l	(ScoutCDArg).l,a0
	move.w	#$18,d0
	jsr	$5F22.w
LD824	bclr	#$5,$FF800F.l
	move.w	#$6,d7
	jsr	$6044.w
	cmpi.w	#$5A,d3
	dc.w	$671E
	cmpi.w	#$3F1,d3
	dc.w	$6718
	cmpi.w	#$97,d3
	dc.w	$6712
	cmpi.w	#$392,d3
	dc.w	$670C
	cmpi.w	#$405,d3
	dc.w	$6706
	move.w	#$400,d1
	dc.w	$6004
LD858	move.w	#$380,d1
LD85C	move.w	#$9,d0
	move.w	#$FF,d2
	move.w	#$FFFF,d3
	move.w	#$10,d7
	jsr	$6044.w
LD870	move.l	#vb2,(VBint).l
	jsr	$21FC8.l
	bset	#$5,$FF800F.l
LD888	moveq	#$0,d0
	dc.w	$4EB9,$0003,$72D0
	btst	#$1,$1AD77.l
	dc.w	$6712
	movea.l	#$FFFFFFFF,a0
	move.w	#$9,d0
	move.w	#$10,d7
	jsr	$6044.w
LD8AC	subi.w	#$1,(matchuptimer).l
	bpl.w	LD8C0
	move.w	#$10E,(matchuptimer).l
LD8C0	bsr.w	PrintAdvantageMarks
	btst	#$7,d1
	bne.w	LD9CA
	cmpi.w	#$10E,(matchuptimer).l
	beq.w	LD8F2
	btst	#$5,d1
	beq.w	LD90A
	move.w	#$7FFF,(screentimer).l
	move.l	#$8CA0,(scoutwait).l
LD8F2	dc.w	$6100,$0764
	move.w	#$1,d0
	tst.w	(ScoutLastPara).l
	dc.w	$6704
	bsr.w	PageMatchup
LD906	bra.w	LD94C
LD90A	btst	#$6,d1
	beq.w	LD938
	move.w	#$7FFF,(screentimer).l
	move.l	#$8CA0,(scoutwait).l
	dc.w	$6100,$0732
	tst.w	(ScoutLastPara).l
	dc.w	$6704
	bsr.w	PageMatchup
LD934	bra.w	LD94C
LD938	clr.w	(asv).l
	btst	#$1,d1
	beq.w	LD94C
	st.b	(asv).l
LD94C	btst	#$1,$1AD77.l
	beq.w	LD95E
	st.b	(asv).l
LD95E	jsr	(UpdateScoutingDisplay).l
	tst.w	(ScoutLastPara).l
	dc.w	$662E
	cmpi.w	#$FF00,(PlayerScrollCtr).l
	dc.w	$6624
	move.l	#$A9,(scoutparaoff).l
	move.w	(SelectedPlayerIdx).l,d0
	movea.l	#TestList,a0
	move.w	(a0,d0.w),d0
	cmpi.w	#$1D,d0
	dc.w	$6704
	bra.w	LD6A0
LD99A	subi.w	#$1,(screentimer).l
	bpl.w	LD888
	tst.w	(OptNOP).l
	beq.w	LD9CA
	move.w	#$FFFF,(screentimer).l
	subi.l	#$1,(scoutwait).l
	bpl.w	LD888
	beq.w	LD888
LD9CA	movea.l	#$FFFFFFFF,a0
	move.w	#$9,d0
	move.w	#$10,d7
	jsr	$6044.w
	move.w	#$0,(printfontset).l
	movea.l	(ScoutSavedSP).l,sp
	rts
