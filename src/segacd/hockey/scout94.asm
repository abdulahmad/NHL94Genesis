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
	bne.w	.next
	move.b	#$50,d0		;none saved: 80 dB
.next	move.l	a1,-(sp)
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
	beq.w	.next
	movea.l	#ThreeStars,a3
	movea.l	#$2828C,a1
	move.l	a3,-(sp)
	jsr	(CopyString).l		;copy the String at a1 to a3: 'by '
	movea.l	(sp)+,a3
	clr.w	d2
	move.b	$9(a0),d2
	movea.l	#TempBuffer,a1
	bset	#$7,(sflags6).l
	bsr.w	AppendUserName
	jsr	(appstring).l
	movea.l	#$28292,a1
	jsr	(appstring).l
	movea.l	a3,a1		;a1 = 'by <name> '
	bra.w	.next2
.next	movea.l	#ScoutEmptyTxt,a1
.next2	movem.l	(sp)+,d0-d7/a0/a2-a6
	rts
ScoutEmptyTxt						;empty String: no name number in the crowd record
; Ascending offset table of 6 words after ScoutEmptyTxt ($0002,$0006 ...).
	dc.w	2
	dc.w	6							;the String 'by ' of the next label
	dc.b	'by ',$00
ScoutSpaceTxt						;space after the name
; Data that follows ScoutSpaceTxt (strings, small tables)
ScoutSpaceTxtData	dc.w	$0004,$2000
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
.loop	move.l	(a0)+,(a1)+
	dbra	d0,.loop
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
	jsr	(song).l
	move.l	#vb2,(VBint).l
	jsr	(clearTeamStats).l
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
	jsr	(setVram).l
	move.w	#$2,d4		;vram chars from 2
	move.w	d4,(homepicchars).l		;home picture chars (6 x 6)
	addi.w	#$24,d4
	move.w	d4,(vispicchars).l
	addi.w	#$24,d4
	move.w	d4,(BigFontchars).l
	movea.l	(BigFontMap).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
; Inline data read by DecompressGraphicsWithRemap from the return address (2 rows).
	dc.l	$05431567,$79ABCDEF
	dc.w	$4EB9,$0003,$93E8		;remap table
	move.w	d4,(smallfont2chars).l		;framer tiles (as AddFramer), remapped
	movea.l	(SmallFontMap).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
; Inline data read by DecompressGraphicsWithRemap from the return address (1 row).
	dc.l	$0A234567,$89ABCDEF
	movea.l	(FramerMap).l,a2
	addq.l	#$8,a2
	move.w	d4,(framercset).l
	jsr	(DecompressGraphicsWithRemap).l
; Inline data read by DecompressGraphicsWithRemap from the return address (1 row).
	dc.l	$05422561,$89ABCDEF
	jsr	(printz).l
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
	jsr	(dobitmap).l
	jsr	(printbigz).l
	String	CC_Font1Pal2,$C,$D,'MATCHUPS'
	move.w	#$0,(printfontset).l
	jsr	(printz).l
	String	CC_Font1,$10,$11,'ADVANTAGE:'
	jsr	(printz).l
	String	CC_Font2Pal2,$6,$3
	moveq	#$21,d0		;33 x 9 text box frame
	moveq	#$9,d1
	jsr	(Framer).l
	jsr	(printz).l
	String	CC_Font2Pal2,$1,$E		;(and dropped a word)
	move.w	#$8,d0		;8 x 8 frame: visitors picture
	move.w	#$8,d1
	jsr	(Framer).l
	jsr	(printz).l
	String	CC_Font2Pal2,$1F,$E		;(and dropped a word)
	move.w	#$8,d0		;8 x 8 frame: home picture
	move.w	#$8,d1
	jsr	(Framer).l
	jsr	(printz).l
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
	jsr	(dobitmap).l
	movea.l	(HotMap).l,a2
	adda.l	#$8,a2
	move.w	d4,(hoticonchars).l
	jsr	(DecompressGraphicsPlain).l
	movea.l	(ColdMap).l,a2
	adda.l	#$8,a2
	move.w	d4,(coldiconchars).l
	jsr	(DecompressGraphicsPlain).l
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
.loop2	tst.w	(palcount).l
	bpl.w	.loop2
	jsr	(InitScoutingDisplay).l
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
	jsr	(CompareHotColdTotals).l
.loop3	btst	#$7,$FF800E.l
	bne.b	.loop3
	move.w	#$3C,$FF8020.l
	bset	#$6,$FF800F.l
.loop4	btst	#$6,$FF800E.l
	beq.b	.loop4
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop5	btst	#$6,$FF800E.l
	bne.b	.loop5
	bclr	#$7,$FF800F.l
	bclr	#$5,$FF800F.l
	move.w	#$F,d7
	jsr	$6044.w
	move.w	#$0,(ScoutLastPara).l
.loop6	movea.l	#$0,a0
	move.w	#$9,d0
	move.w	#$10,d7
	jsr	$6044.w
	tst.w	d0
	beq.w	.loop6
	movea.l	#$FFFFFFFF,a0
	move.w	#$9,d0
	move.w	#$10,d7
	jsr	$6044.w
	move.w	#$0,(ScoutingReportTimer).l
	move.w	(SelectedPlayerIdx).l,d0
	movea.l	#TestList,a0
	move.w	(a0,d0.w),d1
	btst	#$F,d1
	beq.s	.next
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
.next	move.l	d1,d0
	cmpi.w	#$21,d0
	bne.s	.next2
	move.w	#$1,(ScoutLastPara).l
.next2	bsr.w	ScoutParaOffset
	move.l	d0,(scoutparaoff).l
	move.l	d1,-(sp)
	jsr	(ReadJoy1).l
	move.w	d3,d5
	jsr	(ReadJoy2).l
	or.w	d3,d5
	btst	#$1,$1AD77.l
	bne.w	.next6
	move.l	(sp)+,d1
.loop7	btst	#$7,$FF800E.l
	bne.b	.loop7
	move.w	#$2E,$FF8020.l
	bset	#$6,$FF800F.l
.loop8	btst	#$6,$FF800E.l
	beq.b	.loop8
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop9	btst	#$6,$FF800E.l
	bne.b	.loop9
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
	bne.s	.next3
	move.w	(SelectedPlayerIdx).l,d0
	movea.l	#TestList,a0
.loop10	addi.w	#$2,d0
	move.w	(a0,d0.w),d1
	cmpi.w	#$1D,d1
	beq.w	.loop10
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
.next3	bclr	#$5,$FF800F.l
	move.w	#$6,d7
	jsr	$6044.w
	cmpi.w	#$5A,d3
	beq.s	.next4
	cmpi.w	#$3F1,d3
	beq.s	.next4
	cmpi.w	#$97,d3
	beq.s	.next4
	cmpi.w	#$392,d3
	beq.s	.next4
	cmpi.w	#$405,d3
	beq.s	.next4
	move.w	#$400,d1
	bra.s	.next5
.next4	move.w	#$380,d1
.next5	move.w	#$9,d0
	move.w	#$FF,d2
	move.w	#$FFFF,d3
	move.w	#$10,d7
	jsr	$6044.w
.next6	move.l	#vb2,(VBint).l
	jsr	(SubCmd2DSend).l
	bset	#$5,$FF800F.l
.loop11	moveq	#$0,d0
	jsr	(waitx).l
	btst	#$1,$1AD77.l
	beq.s	.next7
	movea.l	#$FFFFFFFF,a0
	move.w	#$9,d0
	move.w	#$10,d7
	jsr	$6044.w		;d1 = new presses
.next7	subi.w	#$1,(matchuptimer).l
	bpl.w	.next8		;not run out
	move.w	#$10E,(matchuptimer).l		;restart
.next8	bsr.w	PrintAdvantageMarks
	btst	#$7,d1		;Start?
	bne.w	.next17
	cmpi.w	#$10E,(matchuptimer).l
	beq.w	.next9		;timer ran out: next matchup
	btst	#$5,d1		;C?
	beq.w	.next11
	move.w	#$7FFF,(screentimer).l		;restart the screen timer
	move.l	#$8CA0,(scoutwait).l
.next9	dc.w	$6100,$0764		; bsr.w X_29058
	move.w	#$1,d0
	tst.w	(ScoutLastPara).l
	beq.s	.next10
	bsr.w	PageMatchup
.next10	bra.w	.next14
.next11	btst	#$6,d1		;A?
	beq.w	.next13
	move.w	#$7FFF,(screentimer).l		;restart the screen timer
	move.l	#$8CA0,(scoutwait).l
	dc.w	$6100,$0732		; bsr.w X_29058
	tst.w	(ScoutLastPara).l
	beq.s	.next12
	bsr.w	PageMatchup
.next12	bra.w	.next14
.next13	clr.w	(asv).l		;normal text speed
	btst	#$1,d1		;down?
	beq.w	.next14
	st.b	(asv).l		;down: type the rest without delays
.next14	btst	#$1,$1AD77.l		;down held (waitx pad bits)
	beq.w	.next15
	st.b	(asv).l
.next15	jsr	(UpdateScoutingDisplay).l
	tst.w	(ScoutLastPara).l
	bne.s	.next16
	cmpi.w	#$FF00,(PlayerScrollCtr).l
	bne.s	.next16
	move.l	#$A9,(scoutparaoff).l
	move.w	(SelectedPlayerIdx).l,d0
	movea.l	#TestList,a0
	move.w	(a0,d0.w),d0
	cmpi.w	#$1D,d0
	beq.s	.next16
	bra.w	.loop6
.next16	subi.w	#$1,(screentimer).l
	bpl.w	.loop11
	tst.w	(OptNOP).l
	beq.w	.next17		;OptNOP 0: leave when the text is done
	move.w	#$FFFF,(screentimer).l		;else wait for start, up to scoutwait frames
	subi.l	#$1,(scoutwait).l
	bpl.w	.loop11
	beq.w	.loop11
.next17	movea.l	#$FFFFFFFF,a0
	move.w	#$9,d0
	move.w	#$10,d7
	jsr	$6044.w
	move.w	#$0,(printfontset).l
	movea.l	(ScoutSavedSP).l,sp
	rts

ScoutParaOffset
	cmpi.w	#$1A,d0
	bne.s	.next3
	move.w	#$EA,d0
	cmpi.w	#$1A,(HomeTeam).l
	bge.s	.next
	add.w	(HomeTeam).l,d0
	bra.s	.next3
.next	cmpi.w	#$1A,(VisTeam).l
	bge.s	.next2
	addi.w	#$1A,d0
	bra.s	.next3
.next2	addi.w	#$1B,d0
.next3	movea.l	(ScoutingReportText).l,a1
	movea.l	a1,a2
	move.w	#$0,d1
	bra.w	.next4
.loop	addq.w	#$1,d1
.loop2	cmpi.b	#$D,(a2)+
	bne.w	.loop2
	cmpi.b	#$A,(a2)
	bne.w	.next4
	addq.l	#$1,a2
	cmpi.b	#$21,-$3(a2)
	beq.w	.loop
.next4	dbra	d0,.loop
	suba.l	a1,a2
	move.l	a2,d0
	rts
PageMatchup						;Page the matchup by d0 (+1 / -1, 0-6 wrapping), restart the page timer
	
	move.w	#$10E,(matchuptimer).l
	add.w	(matchup).l,d0
	bmi.w	.0
	cmpi.w	#$7,d0
	blt.w	.1
	clr.w	d0
	bra.w	.1
.0	move.w	#$6,d0
.1	move.w	d0,(matchup).l
	bsr.w	GetMatchupPlayers
	bsr.w	DrawMatchupPictures
	move.w	(ScoutSubStatus).l,d0
.loop	cmp.w	(ScoutSubStatus).l,d0
	beq.b	.loop
.loop2	btst	#$7,$FF800E.l
	bne.b	.loop2
	move.w	#$3C,$FF8020.l
	bset	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	beq.b	.loop3
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop4	btst	#$6,$FF800E.l
	bne.b	.loop4
	bclr	#$7,$FF800F.l
	bsr.w	PrintMatchupRatings
	rts
PrintMatchupRating						;Print the team rating of team a0 (GetTeamRating: the TeamRatings byte for
	
	
	
	bsr.w	PrintTwoSpaces
	move.l	a2,-(sp)
	movea.l	a0,a2
	bsr.w	GetTeamRating
	movea.l	(sp)+,a2
	move.l	d0,-(sp)
	move.w	#$2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	move.l	(sp)+,d0
	rts
PrintTwoSpaces						;Print 2 spaces at printx / printy and keep printx
	move.l	a1,-(sp)
	move.w	(printx).l,-(sp)
	movea.l	#$28B22,a1
	jsr	(printsmall).l
	move.w	(sp)+,(printx).l
	movea.l	(sp)+,a1
	rts
TwoSpacesTxt						;A two space String (printsmall by PrintTwoSpaces)
; Data that follows TwoSpacesTxt (strings, small tables)
TwoSpacesTxtData	dc.w	$0004,$2020
ScoutRatingText						;rating names; only ' Overall ' is printed (PrintMatchupRatings, matchup
	
; Text of ScoutRatingText (9 rows).
	dc.b	$00,$0A,'Shooting',$00,$0A,'Skat'
	dc.b	'ing',$00,$00,$0A,'Passing',$00,$00,$0A
	dc.b	'Defense',$00,$00,$0A,'Checki'
	dc.b	'ng',$00,$0A,'Fighting',$00,$0E,'Go'
	dc.b	'alkeeping',$00,$00,$12,'Powe'
	dc.b	'r Play Adv.',$00,$00,$1A,'- '
	dc.b	'   Home Team Adv'
	dc.b	'.    ',$00,$00,$12,'    Over'
	dc.b	'all     ',$FF,$FF
DrawMatchupPictures						;Draw the matchup's 6 x 6 pictures, visitors at x 2, home at x $20, y $F:
	
	
	
	movem.l	d0-d7/a0-a6,-(sp)
	tst.w	(matchup).l
	bne.w	.0
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
	bra.w	.x
.0	move.w	(VisTeam).l,d1
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
.x	movem.l	(sp)+,d0-d7/a0-a6
	rts
DrawMatchupPicture						;Draw player picture a0 at printx / printy with the PicturePalette
	
	
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	movea.l	#PicturePalette,a0
	adda.l	(a0),a0
	tst.l	(a2)
	bne.w	.0
	movea.l	#PicturePalette,a1
	adda.l	$4(a1),a1
	tst.l	(a2)+
	bra.w	.1
.0	adda.l	(a2)+,a1
.1	bsr.w	UnpackPicture
	movea.l	#picturebuf,a2
	bra.w	DrawMatchupBitmap
DrawMatchupLogo						;Draw team logo a0 at printx / printy, palette TeamLogoPalettes + team d3
	
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	asl.w	#$3,d3
	cmpi.w	#$4,d5
	beq.w	.0
	subi.w	#$20,d3
	bra.w	.1
.0	subi.w	#$40,d3
.1	movea.l	#TeamLogoPalettes,a0
	adda.w	d3,a0
	adda.l	(a2)+,a1
DrawMatchupBitmap						;6 x 6 dobitmap, then erase the 8 x 3 name area at y $19 on that side (x 2
	
	move.w	#$6,d3
	move.w	#$6,d2
	clr.w	d0
	clr.w	d1
	jsr	(dobitmap).l
	cmpi.w	#$14,(printx).l
	bgt.w	.0
	move.w	#$2,(printx).l
	bra.w	.1
.0	move.w	#$20,(printx).l
.1	move.w	#$19,(printy).l
	move.w	#$8,d0
	move.w	#$3,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	rts
GetTeamLogo						;Return a0 = the logo bitmap of team d3 (TeamLogoBitmaps table)
	asl.w	#$2,d3
	movea.l	(TeamLogoBitmaps).l,a0
	movea.l	(a0,d3.w),a0
	rts
PrintMatchupRatings						;Print the matchup ratings. Matchup 0: 'Overall' at y $13, the team
	
	
	
	
	
	
	
	tst.w	(matchup).l
	bne.w	.matchup
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$0,$1,$16,$16,CC_SetFont,$1
	lea.l	ScoutRatingText(pc),a1
	move.w	#$0,d7
.loop	move.w	(a1),d0
	asr.w	#$1,d0
	neg.w	d0
	addi.w	#$16,d0
	move.w	d0,(printx).l
	cmpi.w	#$9,d7
	beq.w	.0
	adda.w	(a1),a1
	bra.w	.1
.0	move.w	#$2,(printfontset).l
	move.w	(printy).l,-(sp)
	subi.w	#$3,(printy).l
	jsr	(printsmall).l
	move.w	(sp)+,(printy).l
.1	addi.w	#$1,d7
	tst.w	(a1)
	bpl.w	.loop
	move.w	#$2,(printfontset).l
	jsr	(printz).l
	String	CC_Font1,$0,$17,'                                        '
	jsr	(printz).l
	String	CC_Font1,$22,$16
	movea.l	#tmstruct,a0
	movea.l	#awtmstruct,a2
	bsr.w	PrintMatchupRating
	move.w	d0,(homerating).l
	move.w	#$2,(printfontset).l
	jsr	(printz).l
	String	CC_Font1,$4,$16
	exg.l	a0,a2
	bsr.w	PrintMatchupRating
	move.w	d0,(visrating).l
	bra.w	.ex
.matchup	move.w	(matchup).l,d0
	subi.w	#$1,d0
	movea.l	#$28F8E,a1
	bra.w	.next
.loop2	adda.w	(a1),a1
.next	dbra	d0,.loop2
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$0,$1,$D,$13,CC_SetFont,$1
	jsr	(printsmall).l
	move.w	#$16,(printy).l
	move.w	#$2,(printfontset).l
	movea.l	#tmstruct,a2
	move.l	(PAttribOverallMask).l,d4
	tst.w	(matchupslot).l
	bne.w	.4
	move.l	(GAttribOverallMask).l,d4
.4	move.w	(matchuphome).l,d0
	jsr	(printz).l
	String	CC_Font1,$0,$17,'                                        '
	jsr	(printz).l
	String	CC_Font1,$23,$17
	bsr.w	PrintPlayerNameRight
	bsr.w	CalcAttrib
	mulu.w	#$64,d0
	divu.w	d1,d0
	bsr.w	AttribAdjust
	move.w	#$2,d1
	move.w	d0,(homerating).l
	jsr	(PushNumberWidth).l
	jsr	(printz).l
	String	CC_Font1,$22,$16
	bsr.w	PrintTwoSpaces
	jsr	(printsmall).l
	movea.l	#awtmstruct,a2
	move.l	(PAttribOverallMask).l,d4
	tst.w	(matchupslot).l
	bne.w	.5
	move.l	(GAttribOverallMask).l,d4
.5	move.w	(matchupvis).l,d0
	jsr	(printz).l
	String	CC_Font1,$0,$17
	bsr.w	PrintPlayerNameRight
	bsr.w	CalcAttrib
	mulu.w	#$64,d0
	divu.w	d1,d0
	bsr.w	AttribAdjust
	move.w	d0,(visrating).l
	move.w	#$2,d1		;2 digits
	jsr	(PushNumberWidth).l
	jsr	(printz).l
	String	CC_Font1,$4,$16
	bsr.w	PrintTwoSpaces
	jsr	(printsmall).l
.ex	rts
MatchupPosNames						;Position names of matchups 1-6
; Data that follows MatchupPosNames (strings, small tables)
MatchupPosNamesData	dc.w	$0012,$2020
	dc.b	'   center     '
	dc.w	$0012,$206C
	dc.b	'eft forward   '
	dc.w	$0012,$2072
	dc.b	'ight forward  ',$00,$12,'left defen'
.next
; Text of MatchupPosNamesData (3 rows).
	dc.b	'seman ',$00,$12,'right de'
	dc.b	'fenseman',$00,$12,'     g'
	dc.b	'oalie     '
GetMatchupPlayers						;matchuphome / matchupvis = the home / visitors player of the matchup.
	
	movem.l	d0/a0-a1,-(sp)
	movea.l	#tmstruct,a0
	bsr.w	GetMatchupPlayer
	move.w	d0,(matchuphome).l
	movea.l	#awtmstruct,a0
	bsr.w	GetMatchupPlayer
	move.w	d0,(matchupvis).l
	movem.l	(sp)+,d0/a0-a1
	rts
GetMatchupPlayer						;Return d0 = the roster index of team a0's player for matchup: the first
	
	
	
	movea.l	$1E(a0),a0
	adda.w	$6(a0),a0
	move.w	(matchup).l,d0
	movea.l	#$29050,a1
	move.b	(a1,d0.w),d0
	ext.w	d0
	move.w	d0,(matchupslot).l
	move.b	(a0,d0.w),d0
	ext.w	d0
	subi.w	#$1,d0		;player numbers start at 1
	rts
MatchupLineSlots						;Line slot by matchup 0-6 (0 for the teams, then 4 center, 3 left forward,
	
	
; Data that follows MatchupLineSlots (strings, small tables)
MatchupLineSlotsData	dc.w	$0004,$0305
	dc.w	$0102
	dc.l	$4279
	dc.w	$0001,$A448
	clr.w	(advframe).l
	rts
PrintAdvantageMarks						;Called every frame by ScoutingReport. Print the advantage marks at x $13,
	
	
	
	
	movem.l	d0-d7/a0-a6,-(sp)
	addi.w	#$1,(advcount).l
	cmpi.w	#$7,(advcount).l
	blt.w	.0
	clr.w	(advcount).l
	addi.w	#$1,(advframe).l
	cmpi.w	#$6,(advframe).l
	blt.w	.0
	move.w	#$5,(advframe).l
.0	move.w	(advframe).l,d1
	asl.w	#$2,d1
	movea.l	#$290FE,a1
	move.w	(homerating).l,d0
	cmp.w	(visrating).l,d0
	bgt.w	.1
	beq.w	.2
	movea.l	#$29116,a1
.1	movea.l	(a1,d1.w),a1
	bra.w	.3
.2	movea.l	#EvenAdvTxt,a1
.3	move.w	#$2,(printfontset).l
	jsr	(printz).l
	String	CC_Font1,$13,$16
	jsr	(printsmall).l
	move.w	#$0,(printfontset).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
HomeAdvMarks						;Home advantage marks, by advframe (0-5)
; Data that follows HomeAdvMarks (strings, small tables)
HomeAdvMarksData	dc.w	$0002,$912E
	dc.w	$0002,$9134
	dc.w	$0002,$913A
	dc.w	$0002,$9140
	dc.w	$0002,$9140
	dc.w	$0002,$9140
VisAdvMarks						;Visitors advantage marks
; Data that follows VisAdvMarks (strings, small tables)
VisAdvMarksData	dc.w	$0002,$9146
	dc.w	$0002,$914C
	dc.w	$0002,$9152
	dc.w	$0002,$9158
	dc.w	$0002,$9158
	dc.w	$0002,$9158
HomeAdv0Txt						;home advantage marks: none
; Table of 2 words after HomeAdv0Txt, 4 bytes: $0006,$2020 ...
	dc.w	$0006,$2020
	move.l	d0,d0
HomeAdv1Txt						;home advantage: one mark
; Table of 2 words after HomeAdv1Txt, 4 bytes: $0006,$5D20 ...
	dc.w	$0006,$5D20
	move.l	d0,d0
HomeAdv2Txt						;home advantage: two marks
; Table of 2 words after HomeAdv2Txt, 4 bytes: $0006,$5D5D ...
	dc.w	$0006,$5D5D
	move.l	d0,d0
HomeAdv3Txt						;home advantage: three marks
; Table of 2 words after HomeAdv3Txt, 4 bytes: $0006,$5D5D ...
	dc.w	$0006,$5D5D
	subq.b	#$6,d0
VisAdv0Txt						;visitors advantage marks: none
; Table of 2 words after VisAdv0Txt, 4 bytes: $0006,$2020 ...
	dc.w	$0006,$2020
	move.l	d0,d0
VisAdv1Txt						;visitors advantage: one mark
; Table of 2 words after VisAdv1Txt, 4 bytes: $0006,$2020 ...
	dc.w	$0006,$2020
	subq.b	#$5,d0
VisAdv2Txt						;visitors advantage: two marks
; Table of 2 words after VisAdv2Txt, 4 bytes: $0006,$205B ...
	dc.w	$0006,$205B
	subq.b	#$5,d0
VisAdv3Txt						;visitors advantage: three marks
; Table of 2 words after VisAdv3Txt, 4 bytes: $0006,$5B5B ...
	dc.w	$0006,$5B5B
	subq.b	#$5,d0
EvenAdvTxt						;Even teams
; Table of 2 words after EvenAdvTxt, 4 bytes: $0006,$2020 ...
	dc.w	$0006,$2020
	move.l	d0,d0
GetTeamNickname						;The text player's '=' (a2 = tmstruct) and '*' (awtmstruct): return a1 =
	
	
	
	movem.l	d0/a0/a2,-(sp)
	movea.l	a2,a1
	movea.l	$1E(a1),a1
	adda.w	$4(a1),a1
	adda.w	(a1),a1
	adda.w	(a1),a1
	cmpi.w	#$2,(a1)
	bne.w	.next
	movea.l	#$2919A,a1
	cmpa.l	#$1834C,a2
	beq.w	.next
	movea.l	#$291A0,a1
.next	movem.l	(sp)+,d0/a0/a2
	rts
HomeTxt						;name used when the home team has no nickname
; Data that follows HomeTxt (strings, small tables)
HomeTxtData	dc.w	$0006,$486F
	dc.b	$6D,$65
VisitorsTxt						;name used when the visiting team has no nickname
; Data that follows VisitorsTxt (strings, small tables)
VisitorsTxtData	dc.b	$00,$0A,'Visitors'
GetTeamArena						;The text player's '^' (a2 = tmstruct) and ';' (awtmstruct): return a1 =
	
	
	movem.l	d0/a0/a2,-(sp)
	movea.l	a2,a1
	movea.l	$1E(a1),a1
	adda.w	$4(a1),a1
	adda.w	(a1),a1
	adda.w	(a1),a1
	adda.w	(a1),a1
	movem.l	(sp)+,d0/a0/a2
	rts
ScoutStub						;An empty routine
	movem.l	d0-d7/a0-a6,-(sp)
	movem.l	(sp)+,d0-d7/a0-a6
	rts
; Scouting screen set-up: freezes the window and clears the pick state.
ScoutStubSetup
	movem.l	d0-d7/a0-a6,-(sp)
	bset	#$2,$17F6C.l
	jsr	(freezewindow).l
	move.w	#$60,$1AD72.l
	movea.l	#$17480,a3
	move.w	#$0,d0
	move.w	$1A416.l,d2
	cmp.w	$1A418.l,d2
	bgt.w	.next
	move.w	#$6,d0
.next	asl.w	#$7,d0
	adda.w	d0,a3
	move.w	#$4,d2
	move.w	#$6,d3
	bra.w	.next3
.loop	movem.w	d2-d3,-(sp)
	jsr	(SetPlayerSide).l
	move.w	#$2,$34(a3)
	move.w	#$F0,d0
	tst.w	$17CEA.l
	bmi.w	.next2
	move.w	#$FF10,d0
.next2	add.w	$17CEA.l,d0
	move.w	d0,$14(a3)
	move.w	#$0,$0(a3)
	move.w	#$7,d0
	jsr	(AssistListPush).l
	bclr	#$5,$62(a3)
	bclr	#$1,$63(a3)
	bclr	#$2,$62(a3)
	movem.w	(sp)+,d2-d3
.next3	adda.l	#$80,a3
	dbra	d2,.loop
	movem.l	(sp)+,d0-d7/a0-a6
	rts