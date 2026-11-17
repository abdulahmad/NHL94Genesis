NextShooter						;Shootout: the next shooter (BA_Team, BA_Goalie_SCnum, StartShootoutPath),
	
	btst	#$3,$17F78.l
	beq.w	.0
	jmp	$3F2BE.l
.0	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	StartShootoutPath
	dc.w	$33F9,$0001,$A436,$0001,$9366
	dc.w	$33FC,$000B,$0001,$936A
	dc.w	$207C,$0001,$A41C
	dc.w	$4A79,$0001,$A436
	beq.w	.lCA7A
	dc.w	$33FC,$0005,$0001,$936A
	dc.w	$207C,$0001,$A42A
.lCA7A	dc.w	$3039,$0001,$A428
	add.w	d0,d0
	dc.w	$33F0,$0000,$0001,$936C
	bclr	#$2,$17BE2.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
CountShootoutGoals						;Shootout: count the goals and end it when one team cannot catch up
	
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#$0,$1A437.l
	beq.w	.lCAD6
	cmpi.w	#$5,$1A41A.l
	blt.w	.lCAD6
	dc.w	$3039,$0001,$A416
	dc.w	$B079,$0001,$A418
	beq.w	.lCAD6
	bset	#$3,$17F78.l
	jsr	$291CE.l
	bra.w	.x
.lCAD6	dc.w	$0A79,$0001,$0001,$A436
	bne.w	.x
	dc.w	$0679,$0001,$0001,$A428
	dc.w	$0C79,$0005,$0001,$A428
	blt.w	.1
	dc.w	$4279,$0001,$A428
.1	addi.w	#$1,$1A41A.l
.x	movem.l	(sp)+,d0-d7/a0-a6
	rts
InitShooters						;Shootout: the 6 starters of the home (shootoutteam 0) or away team as the
	
	dc.w	$207C,$0001,$A428
	move.w	(HomeTeam).l,d0
	dc.w	$4A79,$0001,$A436
	beq.w	.0
	move.w	(VisTeam).l,d0
	dc.w	$207C,$0001,$A436
.0	movea.l	#TeamList,a1
	asl.w	#$2,d0
	movea.l	(a1,d0.w),a1
	adda.w	$6(a1),a1
	move.w	#$5,d0
.loop	clr.w	d1
	move.b	(a1)+,d1
	subi.w	#$1,d1
	move.w	d1,-(a0)
	dbra	d0,.loop
	rts
ShootoutWonBy						;Shootout: "SHOOTOUT WON BY" (printbig). Called from SetPA
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
	bgt.w	.0
	move.w	(VisTeam).l,d1
.0	asl.w	#$2,d1
	movea.l	#TeamList,a1
	movea.l	(a1,d1.w),a1
	adda.w	$4(a1),a1
	move.w	#$2,(printx).l
	dc.w	$4EB9,$0003,$926A
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ShootoutShooters						;Shootout shooters menu item (menu lists): pick
	
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
ShootersLoop						;Shootout shooters: the input loop
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
ShooterSelectList						;Shootout shooters: "{Select Player}" list
	move.w	#$C000,d7
	dc.w	$207C,$0001,$A41C
	cmpa.l	#$1834C,a2
	beq.w	.0
	dc.w	$207C,$0001,$A42A
.0	move.w	(TestList).l,d0
	asl.w	#$1,d0
	move.w	(a0,d0.w),d6
	dc.w	$4EB9,$0002,$ED60
	move.w	d0,d1
	dc.w	$4EB9,$0002,$EDBC
	sub.w	d1,d0
	subi.w	#$1,d0
	cmpi.w	#$5,(TestList).l
	bne.w	.1
	move.w	d1,d0
	subi.w	#$1,d0
	clr.w	d1
.1	move.w	d0,(screentimer).l
	clr.w	(PlayerScrollCtr).l
	clr.w	(VertLineScrolling).l
	dc.w	$207C,$000B,$BD30
	clr.w	d2
.loop	move.b	d1,(a0,d2.w)
	cmp.w	d1,d6
	bne.w	.2
	move.w	d2,(VertLineScrolling).l
.2	addi.w	#$1,d1
	addi.w	#$1,d2
	dbra	d0,.loop
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
	bra.w	.scroll
.loop2	jsr	(MenuWaitVblank).l
	dc.w	$4EB9,$0002,$F2F0
	dc.w	$4EB9,$0003,$74BE
	btst	#$7,d1
	bne.w	LCC1E
	btst	#$5,d1
	bne.w	.lCE0E
	moveq	#$1,d0
	btst	#$1,d1
	bne.w	.scroll
	btst	#$3,d1
	bne.w	.page
	moveq	#-1,d0
	btst	#$0,d1
	bne.w	.scroll
	btst	#$2,d1
	bne.w	.page
	bra.w	.loop2
.page	add.w	(scoutcolumn).l,d0
	bmi.w	.loop2
	move.w	d0,(scoutcolumn).l
	bsr.w	PrintShooterList
	bra.w	.loop2
.scroll	add.w	(VertLineScrolling).l,d0
	bmi.w	.loop2
	cmp.w	(screentimer).l,d0
	bgt.w	.loop2
	move.w	d0,(VertLineScrolling).l
	cmp.w	(PlayerScrollCtr).l,d0
	bgt.w	.8
	move.w	d0,(PlayerScrollCtr).l
.8	subi.w	#$5,d0
	cmp.w	(PlayerScrollCtr).l,d0
	ble.w	.9
	move.w	d0,(PlayerScrollCtr).l
.9	bsr.w	PrintShooterList
	bra.w	.loop2
.lCE0E	dc.w	$267C,$000B,$BD30
	adda.w	(VertLineScrolling).l,a3
	clr.w	d0
	move.b	(a3),d0
	move.w	(TestList).l,d2
	dc.w	$207C,$0001,$A41C
	cmpa.l	#$1834C,a2
	beq.w	.11
	dc.w	$207C,$0001,$A42A
.11	asl.w	#$1,d2
	move.w	d0,(a0,d2.w)
	bra.w	LCC1E
PrintShooterList						;Shootout shooters: the player list rows (getNameandAttrib)
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font2Pri,$16,$1
.loop	movea.l	#$41C5E,a1
	cmpi.w	#$5,(TestList).l
	bne.w	.0
	movea.l	#$41DC0,a1
.0	move.w	(scoutcolumn).l,d0
	bra.w	.1
.loop2	adda.w	(a1),a1
	adda.w	#$4,a1
.1	tst.w	(a1)
	dbmi	d0,.loop2
	bpl.w	.found
	subi.w	#$1,(scoutcolumn).l
	bra.w	.loop
.found	cmpa.l	#$41C5E,a1
	bne.w	.3
	movea.l	#$27F28,a1
.3	cmpa.l	#$41DC0,a1
	bne.w	.4
	movea.l	#$27F3E,a1
.4	jsr	(print).l
	move.l	(a1),d4
	dc.w	$267C,$000B,$BD30
	move.w	(PlayerScrollCtr).l,d2
	move.w	(screentimer).l,d1
	sub.w	d2,d1
	cmpi.w	#$5,d1
	bls.w	.5
	moveq	#$5,d1
.5	move.w	#$2,(printy).l
.loop3	jsr	(printsmallz).l
	dc.w	$0020
	dc.b	$FE,$04,$FD,$05,$FA,$01,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$FD,$05
	cmp.w	(VertLineScrolling).l,d2
	bne.w	.6
	move.w	d7,(printa).l
.6	clr.w	d0
	move.b	(a3,d2.w),d0
	dc.w	$4EB9,$0002,$D56A
	addi.w	#$1,d2
	dbra	d1,.loop3
	rts
	dc.w	$0012,$2020,$2020,$4F76,$6572,$616C,$6C20,$2020
	dc.w	$205D,$1F3A,$000A,$0012,$2020,$2020,$4F76,$6572
	dc.w	$616C,$6C20,$2020,$205D,$1B0F,$000A
Sub_27F54
	cmp.w	(TestList).l,d0
	beq.w	ShootersLoop
	bra.w	LCF8A
ShootersMove						;Shootout shooters: move the slot cursor by d0, wrapping in 0 ... 4 (not
	
	cmpi.w	#$5,(TestList).l
	beq.w	ShootersLoop
	add.w	(TestList).l,d0
	bmi.w	ShootersSelect
	cmpi.w	#$5,d0
	blt.w	LCF8A
	clr.w	d0
	bra.w	LCF8A
ShootersSelect						;Shootout shooters: TestList = d0, redraw the names and the player box,
	
	move.w	#$4,d0
LCF8A	move.w	d0,(TestList).l
	bsr.w	Sub_2813E
	bsr.w	Sub_280D6
	bra.w	ShootersLoop		;back to the input loop
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
	beq.w	.lD018
	move.w	#$2C,d0
.lD018	jmp	(Sub_2C59E).l
ClearShooterScreen						;Shootout shooters: erase the screen
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
	beq.w	.lD114
	dc.w	$227C,$0001,$A42A
.lD114	move.w	(TestList).l,d0
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
	beq.w	.lD16A
	dc.w	$207C,$0001,$A42A
.lD16A	move.w	d1,d0
	asl.w	#$1,d0
	move.w	(a0,d0.w),d0
	jsr	$41226.l
	move.w	(printx).l,-(sp)
	cmp.w	(TestList).l,d1
	bne.w	.lD190
	move.w	#$2,(printfontset).l
.lD190	cmpi.w	#$5,d1
	bne.w	.lD1A8
	move.w	#$19,(printx).l
	move.w	#$E,(printy).l
.lD1A8	jsr	(printsmall).l
	clr.w	(printfontset).l
	move.w	(sp)+,(printx).l
	addi.w	#$2,(printy).l
	addi.w	#$1,d1
	cmpi.w	#$6,d1
	blt.w	.lD16A
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ScoutCrowdRecord						;The text player's '@' (UpdateScoutingDisplay): return a1 = the home
									;team's crowd record in dB as a String at TempBuffer (SRAM team record
									;crpeak, 80 if 0). ReadCrowdRecord reads the 16 byte SRAM record of team
									;d1 (CrowdRecBase + d1 * 16) to a0
	movem.l	d0-d7/a0/a2-a6,-(sp)
	move.w	(HomeTeam).l,d1
	ext.l	d1
	movea.l	#teamrecbuf,a0		;SRAM team record buffer
	move.l	a0,-(sp)
	jsr	(ReadCrowdRecord).l		;read the HomeTeam record
	movea.l	(sp)+,a0
	movea.l	#TempBuffer,a1
	clr.w	d0
	move.b	$8(a0),d0		;crowd record
	bne.w	.lD204
	move.b	#$50,d0		;none saved: 80 dB
.lD204	move.l	a1,-(sp)
	jsr	(AppendNumber).l		;d0 as a decimal String at a1
	movea.l	(sp)+,a1
	movem.l	(sp)+,d0-d7/a0/a2-a6
	rts
ScoutCrowdRecordBy						;unused: return a1 = 'by <name> ' for the home team's crowd record (SRAM
									;record crpeakuser = name number, AppendUserName reads that 12 char name
									;from namelog), or an empty String if crpeakuser is 0
	movem.l	d0-d7/a0/a2-a6,-(sp)
	move.w	(HomeTeam).l,d1
	ext.l	d1
	movea.l	#teamrecbuf,a0		;SRAM team record buffer
	move.l	a0,-(sp)
	jsr	(ReadCrowdRecord).l		;read the HomeTeam record
	movea.l	(sp)+,a0
	tst.b	$9(a0)
	beq.w	.lD27E
	movea.l	#ThreeStars,a3
	dc.w	$227C,$0002,$828C
	move.l	a3,-(sp)
	jsr	(CopyString).l		;copy the String at a1 to a3: 'by '
	movea.l	(sp)+,a3
	clr.w	d2
	move.b	$9(a0),d2
	movea.l	#TempBuffer,a1
	bset	#$7,(sflags6).l
	bsr.w	AppendUserName
	dc.w	$4EB9,$0003,$9208
	dc.w	$227C,$0002,$8292
	dc.w	$4EB9,$0003,$9208
	movea.l	a3,a1		;a1 = 'by <name> '
	bra.w	.lD284
.lD27E	movea.l	#ScoutEmptyTxt,a1
.lD284	movem.l	(sp)+,d0-d7/a0/a2-a6
	rts
ScoutEmptyTxt						;empty String: no name number in the crowd record
	ori.b	#$6,d2
	dc.w	$6279
	move.l	d0,d0
ScoutSpaceTxt						;space after the name
	dc.w	$0004,$2000
GetTeamCity						;unused: return a1 = the city String of team byte tmATOP(a0) (TeamList,
									;Teamname offset)
	movem.l	d0-d7/a0/a2-a6,-(sp)
	clr.w	d2
	move.b	$A(a0),d2
	asl.w	#$2,d2
	movea.l	#TeamList,a1
	movea.l	(a1,d2.w),a1
	adda.w	$4(a1),a1
	movem.l	(sp)+,d0-d7/a0/a2-a6
	rts
ScoutingReport						;pregame MATCHUPS screen, called from Opening2. Draws the Ron Barr
									;picture, the text box and the matchup
									;matchup 0 is both team logos with the team ratings, 1-6 the two players
									;at center, left forward, right forward, left defense, right defense and
									;goalie with their ratings, with marks toward the side that has the
									;advantage. The text player (UpdateScoutingDisplay) types the paragraph
									;list. A / C page the matchups (the page also turns by itself about every
									;$10E frames), down types fast, start leaves
	move.l	sp,(ScoutSavedSP).l
	movea.l	#$1745C,sp
	movea.l	(ScoutSpeechTable).l,a0
	movea.l	#$C458,a1
	move.w	#$DAC,d0
.lD2D2	move.l	(a0)+,(a1)+
	dbra	d0,.lD2D2
	move.l	(ScoutSpeechTable).l,d1
	subi.l	#$C458,d1
	sub.l	d1,(ScoutSpeechTable).l
	sub.l	d1,(SmallFontMap).l
	sub.l	d1,(HotMap).l
	sub.l	d1,(ColdMap).l
	jsr	(ReadNameLog).l		;read the $80 byte SRAM name list at NameLogBase to namelog
	jsr	(BuildHotColdLists).l		;hot / cold players for the text
	clr.w	(advframe).l		;advantage mark frame
	move.w	#$7A,-(sp)		;song $7A
	dc.w	$4EB9,$0003,$71D2
	move.l	#vb2,(VBint).l
	dc.w	$4EB9,$0003,$F11E
	move.l	a0,-(sp)
	movea.l	#tmstruct,a0
	jsr	(Create_HotCold_Table).l		;new random hot / cold tables (end of the team structs)
	movea.l	#awtmstruct,a0
	jsr	(Create_HotCold_Table).l
	movea.l	(sp)+,a0
	jsr	(BuildHotColdLists).l		;again with the new tables
	bclr	#$1,(disflags).l		;40 cell mode
	move.w	#$6,(Map1col).l
	move.w	#$6,(Map2col).l
	move.w	#$0,d0		;fade to color
	dc.w	$4EB9,$0003,$7B5A
	move.w	#$2,d4		;vram chars from 2
	move.w	d4,(homepicchars).l		;home picture chars (6 x 6)
	addi.w	#$24,d4
	move.w	d4,(vispicchars).l
	addi.w	#$24,d4
	move.w	d4,(BigFontchars).l
	movea.l	(BigFontMap).l,a2
	addq.l	#$8,a2
	dc.w	$4EB9,$0003,$8946
	dc.l	$05431567,$79ABCDEF
	dc.w	$4EB9,$0003,$93E8		;remap table
	move.w	d4,(smallfont2chars).l		;framer tiles (as AddFramer), remapped
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
	movea.l	(EASportsBGMap).l,a0		;the jsr, the string and this (ori.b x4)
	movea.l	a0,a1		;a1 = map header
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1		;a1 = map data
	clr.w	d0
	clr.w	d1
	moveq	#$28,d2		;40 x 28 background
	moveq	#$1C,d3
	moveq	#$3,d5		;color fam 1-2
	dc.w	$4EB9,$0003,$87E2
	dc.w	$4EB9,$0003,$9258
	String	CC_Font1Pal2,$C,$D,'MATCHUPS'
	move.w	#$0,(printfontset).l
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1,$10,$11,'ADVANTAGE:'
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font2Pal2,$6,$3
	moveq	#$21,d0		;33 x 9 text box frame
	moveq	#$9,d1
	dc.w	$4EB9,$0003,$8CA0
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font2Pal2,$1,$E		;(and dropped a word)
	move.w	#$8,d0		;8 x 8 frame: visitors picture
	move.w	#$8,d1
	dc.w	$4EB9,$0003,$8CA0
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font2Pal2,$1F,$E		;(and dropped a word)
	move.w	#$8,d0		;8 x 8 frame: home picture
	move.w	#$8,d1
	dc.w	$4EB9,$0003,$8CA0
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1,$1,$1
	movea.l	(RonBarrMap).l,a0		;Ron Barr picture: palette offset, then map header offset
	movea.l	a0,a1		;a1 = map header
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1		;a1 = map data
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	$2(a1),d3
	moveq	#$C,d5		;color fam 3-4
	dc.w	$4EB9,$0003,$87E2
	movea.l	(HotMap).l,a2
	adda.l	#$8,a2
	move.w	d4,(hoticonchars).l
	dc.w	$4EB9,$0003,$8958
	movea.l	(ColdMap).l,a2
	adda.l	#$8,a2
	move.w	d4,(coldiconchars).l
	dc.w	$4EB9,$0003,$8958
	clr.w	(matchup).l		;matchup 0: the teams
	clr.w	(scoutunused).l
	move.w	#$10D,(matchuptimer).l		;frames to the next matchup
	bsr.w	GetMatchupPlayers		;the matchup players
	bsr.w	DrawMatchupPictures
	bsr.w	PrintMatchupRatings
	move.w	#$3,(advframe).l
	move.w	#$0,(advcount).l		;vblank routine
	bsr.w	PrintAdvantageMarks
	move.w	#$18,(palcount).l
	move.l	#vb2,(VBint).l
	bset	#$5,$FF800F.l
.lD52E	tst.w	(palcount).l
	bpl.w	.lD52E
	dc.w	$4EB9,$0003,$F86C
	move.w	#$1B,(a0)+
	move.w	#$1D,(a0)+		;blank line
	move.w	#$1A,(a0)+
	move.w	#$1D,(a0)+		;home hot / cold player
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
	move.w	d2,(a0)+		;blank line
	move.w	#$1D,(a0)+		;'The ^ crowd record is @ dB.'
	move.l	(sp)+,d2		;blank line
	move.w	#$21,(a0)+		;'Hit the start button ...'
	move.w	#$FFFF,(a0)
	clr.w	(asv).l
	move.w	#$7FFF,(screentimer).l		;frames left on the screen
	move.l	#$8CA0,(scoutwait).l		;then 36000 more when OptNOP is not 0
	dc.w	$4EB9,$0003,$7652
.lD642	btst	#$7,$FF800E.l
	bne.b	.lD642
	move.w	#$3C,$FF8020.l
	bset	#$6,$FF800F.l
.lD65C	btst	#$6,$FF800E.l
	beq.b	.lD65C
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.lD676	btst	#$6,$FF800E.l
	bne.b	.lD676
	bclr	#$7,$FF800F.l
	bclr	#$5,$FF800F.l
	move.w	#$F,d7
	jsr	$6044.w
	move.w	#$0,(ScoutLastPara).l
.lD6A0	dc.w	$207C,$0000,$0000
	move.w	#$9,d0
	move.w	#$10,d7
	jsr	$6044.w
	tst.w	d0
	beq.w	.lD6A0
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
.lD720	move.l	d1,d0
	cmpi.w	#$21,d0
	dc.w	$6608
	move.w	#$1,(ScoutLastPara).l
.lD730	bsr.w	ScoutParaOffset
	move.l	d0,(scoutparaoff).l
	move.l	d1,-(sp)
	dc.w	$4EB9,$0003,$74F0
	move.w	d3,d5
	dc.w	$4EB9,$0003,$750E
	or.w	d3,d5
	btst	#$1,$1AD77.l
	bne.w	.lD870
	move.l	(sp)+,d1
.lD75A	btst	#$7,$FF800E.l
	bne.b	.lD75A
	move.w	#$2E,$FF8020.l
	bset	#$6,$FF800F.l
.lD774	btst	#$6,$FF800E.l
	beq.b	.lD774
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.lD78E	btst	#$6,$FF800E.l
	bne.b	.lD78E
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
.lD7E6	addi.w	#$2,d0
	move.w	(a0,d0.w),d1
	cmpi.w	#$1D,d1
	beq.w	.lD7E6
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
.lD824	bclr	#$5,$FF800F.l
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
.lD858	move.w	#$380,d1
.lD85C	move.w	#$9,d0
	move.w	#$FF,d2
	move.w	#$FFFF,d3
	move.w	#$10,d7
	jsr	$6044.w
.lD870	move.l	#vb2,(VBint).l
	jsr	$21FC8.l
	bset	#$5,$FF800F.l
.lD888	moveq	#$0,d0
	dc.w	$4EB9,$0003,$72D0
	btst	#$1,$1AD77.l
	dc.w	$6712
	movea.l	#$FFFFFFFF,a0
	move.w	#$9,d0
	move.w	#$10,d7
	jsr	$6044.w		;d1 = new presses
.lD8AC	subi.w	#$1,(matchuptimer).l
	bpl.w	.lD8C0		;not run out
	move.w	#$10E,(matchuptimer).l		;restart
.lD8C0	bsr.w	PrintAdvantageMarks
	btst	#$7,d1		;Start?
	bne.w	.lD9CA
	cmpi.w	#$10E,(matchuptimer).l
	beq.w	.lD8F2		;timer ran out: next matchup
	btst	#$5,d1		;C?
	beq.w	.lD90A
	move.w	#$7FFF,(screentimer).l		;restart the screen timer
	move.l	#$8CA0,(scoutwait).l
.lD8F2	dc.w	$6100,$0764
	move.w	#$1,d0
	tst.w	(ScoutLastPara).l
	dc.w	$6704
	bsr.w	PageMatchup
.lD906	bra.w	.lD94C
.lD90A	btst	#$6,d1		;A?
	beq.w	.lD938
	move.w	#$7FFF,(screentimer).l		;restart the screen timer
	move.l	#$8CA0,(scoutwait).l
	dc.w	$6100,$0732
	tst.w	(ScoutLastPara).l
	dc.w	$6704
	bsr.w	PageMatchup
.lD934	bra.w	.lD94C
.lD938	clr.w	(asv).l		;normal text speed
	btst	#$1,d1		;down?
	beq.w	.lD94C
	st.b	(asv).l		;down: type the rest without delays
.lD94C	btst	#$1,$1AD77.l		;down held (waitx pad bits)
	beq.w	.lD95E
	st.b	(asv).l
.lD95E	jsr	(UpdateScoutingDisplay).l
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
	bra.w	.lD6A0
.lD99A	subi.w	#$1,(screentimer).l
	bpl.w	.lD888
	tst.w	(OptNOP).l
	beq.w	.lD9CA		;OptNOP 0: leave when the text is done
	move.w	#$FFFF,(screentimer).l		;else wait for start, up to scoutwait frames
	subi.l	#$1,(scoutwait).l
	bpl.w	.lD888
	beq.w	.lD888
.lD9CA	movea.l	#$FFFFFFFF,a0
	move.w	#$9,d0
	move.w	#$10,d7
	jsr	$6044.w
	move.w	#$0,(printfontset).l
	movea.l	(ScoutSavedSP).l,sp
	rts
