;	End-of-season awards. Ported from NHL 95 awards95.asm (lines before InitPlayoffs).
SeasonAwards	;End of season awards: for each of the 9 awards the finalists, then the winner (AwardsLoop) until a button
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(forceblack).l
	jsr	(AwardsScreenSetup).l
	clr.w	(AwardIndex).w
	clr.w	(AwardHilite).w
	clr.l	(AwardTimer).w
	move.w	#$F,(AwardCycle).w
	move.w	#$18,(palcount).w
	bclr	#2,(disflags).w
	bsr.w	DrawFinalistsPanel
	bsr.w	FindAwardFinalists
	bsr.w	PrintAwardTitle
	bsr.w	DrawAwardPicture
.loop
	bsr.w	AwardsLoop
	tst.w	d1
	beq.w	.done
	btst	#7,d1
	bne.w	.done
	bra.s	.loop
.done
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PrintAwardTitle	;Print award AwardIndex: name, description and second line (PrintCentered)
	jsr	(printsmallz).l
	String	CC_SetFont,$0,CC_SetAttribute,$1,CC_SetMap,$1,CC_SetY,$2
	move.w	(AwardIndex).w,d0
	movea.l	#AwardNames,a1
	bsr.w	AwardPrintCentered
	addq.w	#1,(printy).w
	move.w	(AwardIndex).w,d0
	movea.l	#AwardDescs,a1
	bsr.w	AwardPrintCentered
	addq.w	#1,(printy).w
	move.w	(AwardIndex).w,d0
	movea.l	#AwardDescs2,a1
	bsr.w	AwardPrintCentered
	rts

AwardPrintCentered	;Print String d0 of the list a1 (SkipStrings) centred on the 40 columns
	jsr	(AdvanceStringPtr).l
	move.w	(a1),d0
	subq.w	#2,d0
	lsr.w	#1,d0
	subi.w	#$14,d0
	neg.w	d0
	move.w	d0,(printx).w
	jmp	(printsmall).l

AwardNames	;PrintAwardTitle Strings: the award names
	String	'HART MEMORIAL TROPHY'
	String	'JAMES NORRIS TROPHY',$0
	String	'VEZINA TROPHY',$0
	String	'ART ROSS TROPHY',$0
	String	'WILLIAM JENNINGS TROPHY',$0
	String	'LESTER B. PEARSON AWARD',$0
	String	'FRANK SELKE AWARD',$0
	String	'PRESIDENTS TROPHY',$0
	String	'CONN SMYTHE AWARD',$0

AwardDescs	;PrintAwardTitle Strings: the award descriptions
	String	'Most Valuable Player'
	String	'Best Defenseman',$0
	String	'Best Goalkeeper',$0
	String	'Most Points',$0
	String	'Goalie with Fewest'
	String	'NHLPA Most Valuable',$0
	String	'Best Defensive Forward'
	String	'Team with Best Regular'
	String	'Most Valuable Player'

AwardDescs2	;PrintAwardTitle Strings: the second description lines
	String	' ',$0
	String	' ',$0
	String	' ',$0
	String	' ',$0
	String	'Goals Against',$0
	String	'Player'
	String	' ',$0
	String	'Season Record',$0
	String	'In Playoffs',$0

DrawAwardPicture	;Draw the picture of award AwardIndex at AwardPictureX / AwardPictureY
	jsr	(printz).l
	String	-TXMAP1,$0,$0,$0
	move.w	(AwardIndex).w,d0
	add.w	d0,d0
	movea.l	#AwardPictureX,a0
	move.w	(a0,d0.w),(printx).w
	movea.l	#AwardPictureY,a0
	move.w	(a0,d0.w),(printy).w
	move.w	(AwardIndex).w,d0
	asl.w	#2,d0
	movea.l	#AwardPictures,a0
	movea.l	(a0,d0.w),a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	move.w	#1,d5
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	move.w	(awardpicchars).w,d4
	jsr	(dobitmap).l
	move.w	#$64,(palcount).w
	rts

AwardPictures	;The award picture bitmaps, one per award
	dc.l	HartPic
	dc.l	NorrisPic
	dc.l	VezinaPic
	dc.l	ArtRossPic
	dc.l	JenningsPic
	dc.l	PearsonPic
	dc.l	SelkePic
	dc.l	PresidentsPic
	dc.l	ConnSmythePic

AwardPictureX	;DrawAwardPicture x of each award picture
	dc.w	$7,$7,$6,$6,$6,$7,$5,$5,$6

AwardPictureY	;DrawAwardPicture y of each award picture
	dc.w	$5,$5,$5,$5,$5,$5,$5,$4,$5

DrawFinalistsPanel	;Draw the finalists panel (FinalistsPanelMap) at 31,9
	jsr	(printz).l
	String	-TXMAP1,$1F,$9,$0
	movea.l	#FinalistsPanelMap,a0
	bra.w	DrawAwardPanel

DrawWinnerPanel	;Draw the winner panel (WinnerPanelMap) at 29,9
	jsr	(printz).l
	String	-TXMAP1,$1D,$9,$0
	movea.l	#WinnerPanelMap,a0
	bra.w	DrawAwardPanel

DrawAwardPanel	;Draw the panel bitmap a0 at awardpanelchars
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	move.w	#0,d5
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	move.w	(awardpanelchars).w,d4
	jmp	(dobitmap).l

AwardWinnerNop	;Does nothing (AwardsLoop calls it after DrawWinnerPanel)
	rts

PrintFinalists	;"FINALISTS:" and the 3 finalists (player names, or teams for a team award), the highlight (AwardHilite) moving every AwardCycle frames; in winner mode (BA_PS_flags bit 1) only the winner (AwardWinner) stays
	btst	#1,(BA_PS_flags).w
	bne.w	.print
	jsr	(printsmallz).l
	String	CC_SetFont,$0,CC_SetAttribute,$1,CC_SetMap,$1,CC_SetX,$11,CC_SetY,$6,'FINALISTS:'
	move.w	(AwardFlashTimer).w,d0
	ext.l	d0
	divu.w	(AwardCycle).w,d0
	swap	d0
	tst.w	d0
	bne.w	.print
	cmpi.l	#$F0,(AwardTimer).w
	blt.w	.step
	movea.l	#AwardIds,a0
	move.w	(AwardHilite).w,d0
	move.w	(a0,d0.w),d0
	cmp.w	(AwardWinner).w,d0
	beq.w	.print
.step
	addq.w	#2,(AwardHilite).w
	cmpi.w	#4,(AwardHilite).w
	ble.w	.print
	clr.w	(AwardHilite).w
.print
	jsr	(printz).l
	String	-(TXPAL1+TXMAP1),$11,$8,$0
	clr.w	d1
	movea.l	#AwardIds,a0
.item
	clr.w	(printfontset).w
	cmp.w	(AwardHilite).w,d1
	bne.w	.font
	move.w	#2,(printfontset).w
.font
	btst	#4,(sflags11).w
	beq.w	.player
	move.w	(a0,d1.w),d0
	asl.w	#2,d0
	movea.l	#TeamList,a1
	movea.l	(a1,d0.w),a1
	move.w	4(a1),d0
	ext.l	d0
	adda.l	d0,a1
	move.l	a1,-(sp)
	btst	#1,(BA_PS_flags).w
	beq.w	.4
	tst.w	(printfontset).w
	bne.w	.4
	movea.l	#.blank,a1
.4
	jsr	(printsmall).l
	move.w	#$11,(printx).w
	addq.w	#1,(printy).w
	movea.l	(sp)+,a1
	adda.w	(a1),a1
	adda.w	(a1),a1
	btst	#1,(BA_PS_flags).w
	beq.w	.5
	tst.w	(printfontset).w
	bne.w	.5
	movea.l	#.blank,a1
.5
	jsr	(printsmall).l
	addq.w	#2,(printy).w
	move.w	#$11,(printx).w
	addq.w	#2,d1
	cmp.w	#4,d1
	ble.w	.item
	rts
.blank	;Blank String (12 spaces)
	String	'            '
.player
	move.w	(a0,d1.w),d0
	ext.l	d0
	divu.w	#RosterSlots,d0
	move.w	d0,d7
	swap	d0
	movem.w	d0/d7,-(sp)
	jsr	(FormatFirstNameD7).l
	btst	#1,(BA_PS_flags).w
	beq.w	.8
	tst.w	(printfontset).w
	bne.w	.8
	movea.l	#.blank,a1
.8
	jsr	(printsmall).l
	move.w	#$11,(printx).w
	addq.w	#1,(printy).w
	movem.w	(sp)+,d0/d7
	jsr	(FormatLastNameD7).l
	btst	#1,(BA_PS_flags).w
	beq.w	.9
	tst.w	(printfontset).w
	bne.w	.9
	movea.l	#.blank,a1
.9
	jsr	(printsmall).l
	addq.w	#2,(printy).w
	move.w	#$11,(printx).w
	addq.w	#2,d1
	cmp.w	#4,d1
	ble.w	.item
	rts

FlashWinnerCaption	;Flash "The Winner !" (AwardFlashTimer: on $1E frames, off to $3C)
	jsr	(printsmallz).l
	String	CC_SetFont,$0,CC_SetAttribute,$1,CC_SetMap,$1,CC_SetX,$11,CC_SetY,$6,'          '
	move.w	#2,(printfontset).w
	move.w	(AwardFlashTimer).w,d0
	cmp.w	#$1E,d0
	blt.w	.print
	move.w	#0,(printfontset).w
	cmp.w	#$3C,d0
	blt.w	.print
	clr.w	(AwardFlashTimer).w
.print
	jsr	(printsmallz).l
	String	CC_SetAttribute,$1,CC_SetMap,$1,CC_SetX,$12,CC_SetY,$6,'The Winner !'
	rts

AwardsLoop	;Awards frames: finalists for $12C frames, then the winner to $258, then the next award; d1 = a pad button (exit), 0 after the last award or AwardWait frames
	move.w	#$5460,(AwardWait).w
.wait
	move.w	(vcount).w,d1
	sub.w	(oldvcount).w,d1
	beq.s	.wait
	move.w	(vcount).w,(oldvcount).w
	tst.l	(AwardTimer).w
	bne.w	.1
	bsr.w	DrawFinalistsPanel
.1
	addq.w	#1,(AwardFlashTimer).w
	addq.l	#1,(AwardTimer).w
	cmpi.l	#$12C,(AwardTimer).w
	bge.w	.winner
	bclr	#1,(BA_PS_flags).w
	bsr.w	PrintFinalists
	bra.w	.chkend
.winner
	cmpi.l	#$12C,(AwardTimer).w
	bne.w	.flash
	bsr.w	DrawWinnerPanel
	bsr.w	AwardWinnerNop
.flash
	bsr.w	FlashWinnerCaption
	bset	#1,(BA_PS_flags).w
	bsr.w	PrintFinalists
.chkend
	cmpi.l	#$258,(AwardTimer).w
.5
	blt.w	.pads
	addq.w	#1,(AwardIndex).w
	cmpi.w	#9,(AwardIndex).w
	blt.w	.nextaward
	clr.w	d1
	rts
.nextaward
	jsr	(printz).l
	String	-TXMAP1,$0,$0,$0
	move.w	#$7FF,d2
	move.w	#$28,d0
	move.w	#$1C,d1
	jsr	(eraser).l
	move.w	#$18,(palcount).w
	bsr.w	DrawFinalistsPanel
	clr.w	(AwardHilite).w
	clr.l	(AwardTimer).w
	move.w	#$F,(AwardCycle).w
	bsr.w	FindAwardFinalists
	bsr.w	PrintAwardTitle
	bsr.w	DrawAwardPicture
.pads
	jsr	(ReadJoy1).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.8
	bra.w	.exit
.8
	jsr	(ReadJoy2).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.9
	bra.w	.exit
.9
	tst.w	(FourWayPlay).w
	beq.w	.count
	jsr	(ReadJoy3).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.10
	bra.w	.exit
.10
	jsr	(ReadJoy4).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.count
	bra.w	.exit
.count
	subq.w	#1,(AwardWait).w
	bpl.w	.wait
.exit
	rts

AwardsScreenSetup	;Awards screen setup: vram layout, the small font (two remaps) and the background bitmap (AwardsBgMap)
	move.l	#VBlank_SetOptions,(vbint).w
	move	#$2500,sr
	bclr	#0,(disflags).w
	bset	#2,(disflags).w
	bclr	#1,(disflags).w
	move.w	#0,(VSCRLPM).w
	move.w	#$B400,(VSPRITES).w
	move.w	#$B800,(VmMap3).w
	move.w	#5,(Map3col1).w
	move.w	#$C000,(VmMap2).w
	move.w	#6,(Map2col1).w
	move.w	#$E000,(VmMap1).w
	move.w	#6,(Map1col1).w
	move.w	#0,d0
	jsr	(setVram).l
	jsr	(orjoy).l
	move.w	#1,d4
	move.w	d4,(smallfontchars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$01,$23,$45,$67,$89,$AB,$CD,$EF
	move.w	d4,(smallfont2chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$01,$23,$44,$67,$89,$AB,$CD,$EF
	move.l	#SmallFontMap,(smallfontptr).l
	jsr	(printz).l
	String	-TXMAP2,$0,$0,$0
	movea.l	#AwardsBgMap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$28,d2
	moveq	#$1C,d3
	moveq	#$F,d5
	jsr	(dobitmap).l
	move.w	d4,(awardpicchars).w
	addi.w	#$78,d4
	move.w	d4,(awardpanelchars).w
	rts

FindAwardFinalists	;Score the candidates of award AwardIndex, sort them (SortAwardScores), keep the winner in AwardWinner and put the top 3 in a random order
	move.w	(AwardIndex).w,d0
	asl.w	#2,d0
	movea.l	#AwardScanTbl,a0
	movea.l	(a0,d0.w),a0
	bclr	#4,(sflags11).w
	cmpa.l	#ScanPresidents,a0
	bne.w	.0
	bset	#4,(sflags11).w
.0
	jsr	(a0)
	bsr.w	SortAwardScores
	bclr	#6,(sflags12).w
	movea.l	#AwardIds,a0
	move.w	(a0),(AwardWinner).w
	move.w	#2,d0
	jsr	(randomd0).l
	add.w	d0,d0
	move.w	(a0,d0.w),d2
	addq.w	#2,d0
	cmp.w	#4,d0
	ble.w	.1
	clr.w	d0
.1
	move.w	(a0,d0.w),d3
	addq.w	#2,d0
	cmp.w	#4,d0
	ble.w	.2
	clr.w	d0
.2
	move.w	(a0,d0.w),d4
	move.w	d2,(a0)
	move.w	d3,2(a0)
	move.w	d4,4(a0)
	rts

SortAwardScores	;Bubble sort AwardScores (with AwardIds), highest first, lowest first with sflags12 bit 6
	btst	#6,(sflags12).w
	bne.w	.low
	move.w	(AwardCount).w,d1
	subq.w	#2,d1
	bmi.w	.exit
	movea.l	#AwardIds,a1
	movea.l	#AwardScores,a0
	clr.w	d0
	clr.w	(TempWord1).w
.cmp
	move.w	(a0,d0.w),d2
	move.w	2(a0,d0.w),d3
	cmp.w	d2,d3
	ble.w	.noswap
	st	(TempWord1).w
	move.w	d2,2(a0,d0.w)
	move.w	d3,(a0,d0.w)
	move.w	(a1,d0.w),d2
	move.w	2(a1,d0.w),d3
	move.w	d2,2(a1,d0.w)
	move.w	d3,(a1,d0.w)
.noswap
	addq.w	#2,d0
	dbf	d1,.cmp
	tst.w	(TempWord1).w
	beq.w	.exit
	bra.s	SortAwardScores
.low
	move.w	(AwardCount).w,d1
	subq.w	#2,d1
	bmi.w	.exit
	movea.l	#AwardIds,a1
	movea.l	#AwardScores,a0
	clr.w	d0
	clr.w	(TempWord1).w
.lowcmp
	move.w	(a0,d0.w),d2
	move.w	2(a0,d0.w),d3
	cmp.w	d2,d3
	bge.w	.lownoswap
	st	(TempWord1).w
	move.w	d2,2(a0,d0.w)
	move.w	d3,(a0,d0.w)
	move.w	(a1,d0.w),d2
	move.w	2(a1,d0.w),d3
	move.w	d2,2(a1,d0.w)
	move.w	d3,(a1,d0.w)
.lownoswap
	addq.w	#2,d0
	dbf	d1,.lowcmp
	tst.w	(TempWord1).w
	beq.w	.exit
	bra.s	.low
.exit
	rts

AwardScanTbl	;The award scans in award order (Hart ... Conn Smythe)
	dc.l	ScanHart
	dc.l	ScanNorris
	dc.l	ScanVezina
	dc.l	ScanArtRoss
	dc.l	ScanJennings
	dc.l	ScanPearson
	dc.l	ScanSelke
	dc.l	ScanPresidents
	dc.l	ScanConnSmythe

ScanConnSmythe	;Conn Smythe: skaters by playoff points (ConnSmytheScore)
	movea.l	#ConnSmytheScore,a6
	bsr.w	ScanAllPlayers
	rts

rtsAwardScan	;Not used
	rts

ScanPresidents	;Presidents Trophy: the 26 teams by regular season points (ReadStandings with SeasonFlags bit 5 clear,
	;PresidentsScore)
	movea.l	#PresidentsScore,a6
	move.l	a0,-(sp)
	movea.l	#StandingsBuf,a0
	move.b	(SeasonDay+1).w,-(sp)
	bclr	#5,(SeasonDay+1).w
	jsr	(ReadStandings).l
	move.b	(sp)+,(SeasonDay+1).w
	movea.l	(sp)+,a0
	move.w	#$19,d7
	movea.l	#AwardIds,a1
	movea.l	#AwardScores,a2
	clr.w	(AwardCount).w
.team
	movem.l	d1-d3/a1-a2,-(sp)
	jsr	(a6)
	movem.l	(sp)+,d1-d3/a1-a2
	addq.w	#1,(AwardCount).w
	move.w	d7,(a1)+
	move.w	d5,(a2)+
	dbf	d7,.team
	rts

ScanSelke	;Selke: forwards (SelkeScore)
	movea.l	#SelkeScore,a6
	bsr.w	ScanAllPlayers
	rts

ScanPearson	;Pearson: skaters by points (PearsonScore)
	movea.l	#PearsonScore,a6
	bsr.w	ScanAllPlayers
	rts

ScanJennings	;Jennings: goalies by goals against average, lowest first (JenningsScore, sflags12 bit 6)
	movea.l	#JenningsScore,a6
	bsr.w	ScanAllPlayers
	bset	#6,(sflags12).w
	rts

ScanArtRoss	;Art Ross: skaters by points (ArtRossScore)
	movea.l	#ArtRossScore,a6
	bsr.w	ScanAllPlayers
	rts

ScanNorris	;Norris: defensemen (NorrisScore)
	movea.l	#NorrisScore,a6
	bsr.w	ScanAllPlayers
	rts

ScanHart	;Hart: all players (HartScore)
	movea.l	#HartScore,a6
	bsr.w	ScanAllPlayers
	rts

ScanVezina	;Vezina: goalies (VezinaScore)
	movea.l	#VezinaScore,a6
	bsr.w	ScanAllPlayers
	rts

ScanAllPlayers	;Every player d1 of the 26 teams (d7): when the score routine a6 qualifies him (d5 >= 0), add d1 to AwardIds and d5 to AwardScores
	clr.w	d1
	clr.w	d7
	movea.l	#AwardIds,a1
	movea.l	#AwardScores,a2
	clr.w	(AwardCount).w
.team
	move.w	d1,d0
	ext.l	d0
	divu.w	#RosterSlots,d0
	swap	d0
	move.w	d0,-(sp)
	jsr	(GetGoalieCountD7).l
	move.w	d0,d2
	move.w	(sp),d0
	jsr	(GetPlayerCountD7).l
	move.w	d0,d3
.player
	movem.l	d1-d3/a1-a2,-(sp)
	jsr	(a6)
	movem.l	(sp)+,d1-d3/a1-a2
	bmi.w	.next
	addq.w	#1,(AwardCount).w
	move.w	d1,(a1)+
	move.w	d5,(a2)+
.next
	addq.w	#1,(sp)
	move.w	(sp),d0
	addq.w	#1,d1
	cmp.w	d3,d0
	bge.w	.nextteam
	bra.s	.player
.nextteam
	tst.w	(sp)+
	addq.w	#1,d7
	cmp.w	#NumPlayoffTeams,d7
	bge.w	.exit
	move.w	d7,d1
	mulu.w	#RosterSlots,d1
	bra.s	.team
.exit
	rts

ConnSmytheScore	;Score: skaters (from d2, the goalie count), playoff goals + assists (sflags11 bit 3)
	move.w	d1,d0
	ext.l	d0
	divu.w	#RosterSlots,d0
	swap	d0
	cmp.w	d0,d2
	bgt.w	AwardNotQualified
	bset	#3,(sflags11).w
	bsr.w	GetAwardGoals
	bsr.w	GetAwardAssists
	bclr	#3,(sflags11).w
	add.w	d6,d5
	beq.w	AwardNotQualified
	bra.w	AwardQualifies

PresidentsScore	;Score: team d7, 2 * wins + ties (StandingsBuf)
	movem.l	d0/a0,-(sp)
	movea.l	#StandingsBuf,a0
	move.w	d7,d0
	mulu.w	#3,d0
	adda.l	d0,a0
	clr.w	d3
	clr.w	d5
	move.b	(a0),d5
	add.b	d5,d5
	add.b	1(a0),d5
	movem.l	(sp)+,d0/a0
	bra.w	AwardQualifies
	rts

SelkeScore	;Score: forwards (d2 up to GetDefenseStartD7) with 10 goals per 100 games or more; the score is the
	;goal rate high nibble plus rating byte 3 (GetRosterName)
	move.w	d1,d0
	ext.l	d0
	divu.w	#RosterSlots,d0
	swap	d0
	move.w	d0,d6
	cmp.w	d2,d6
	blt.w	AwardNotQualified
	jsr	(GetDefenseStartD7).l
	cmp.w	d0,d6
	bge.w	AwardNotQualified
	jsr	(GetAwardGoals).l
	movem.l	d4,-(sp)
	movem.l	d7/a0,-(sp)
	movea.l	#SaveRAM+2*SRStandings,a0
	mulu.w	#6,d7
	clr.w	d4
	move.b	1(a0,d7.w),d4
	add.b	3(a0,d7.w),d4
	add.b	5(a0,d7.w),d4
	movem.l	(sp)+,d7/a0
	mulu.w	#$64,d5
	tst.w	d4
	beq.w	.0
	divu.w	d4,d5
	movem.l	(sp)+,d4
	cmp.w	#$A,d5
	blt.w	AwardNotQualified
	move.w	d6,d0
	jsr	(GetRosterName).l
	adda.w	(a1),a1
	move.b	4(a1),d0
	lsr.w	#4,d0
	andi.w	#$F,d0
	move.b	3(a1),d0
	lsr.w	#4,d5
	andi.w	#$F,d5
	add.w	d0,d5
	bra.w	AwardQualifies
	rts
.0
	movem.l	(sp)+,d4
	bra.w	AwardNotQualified

PearsonScore	;Score: skaters, goals + assists
	move.w	d1,d0
	ext.l	d0
	divu.w	#RosterSlots,d0
	swap	d0
	cmp.w	d0,d2
	bgt.w	AwardNotQualified
	bsr.w	GetAwardGoals
	bsr.w	GetAwardAssists
	add.w	d6,d5
	beq.w	AwardNotQualified
	bra.w	AwardQualifies
	rts

JenningsScore	;Score: goalies who played half the games or more, 100 * goals against / minutes (GetGoalieAwardStats)
	move.w	d1,d0
	ext.l	d0
	divu.w	#RosterSlots,d0
	swap	d0
	move.w	d0,d6
	jsr	(GetGoalieCountD7).l
	cmp.w	d0,d6
	bge.w	AwardNotQualified
	movem.l	d7/a0,-(sp)
	movea.l	#SaveRAM+2*SRStandings,a0
	mulu.w	#6,d7
	clr.w	d4
	move.b	1(a0,d7.w),d4
	add.b	3(a0,d7.w),d4
	add.b	5(a0,d7.w),d4
	movem.l	(sp)+,d7/a0
	bsr.w	GetGoalieAwardStats
	tst.w	d4
	beq.w	AwardNotQualified
	movem.l	d5-d6,-(sp)
	mulu.w	#$64,d6
	divu.w	d4,d6
	cmp.w	#$32,d6
	movem.l	(sp)+,d5-d6
	blt.w	AwardNotQualified
	mulu.w	#$64,d5
	divu.w	d6,d5
	bra.w	AwardQualifies

ArtRossScore	;Score: skaters, goals + assists
	move.w	d1,d0
	ext.l	d0
	divu.w	#RosterSlots,d0
	swap	d0
	move.w	d0,d6
	jsr	(GetGoalieCountD7).l
	cmp.w	d0,d6
	blt.w	AwardNotQualified
	bsr.w	GetAwardGoals
	bsr.w	GetAwardAssists
	add.w	d6,d5
	beq.w	AwardNotQualified
	bra.w	AwardQualifies

VezinaScore	;Score: goalies who played a quarter of the games or more, (600 - min(100 * goals against / minutes, 600)) / 10
	move.w	d1,d0
	ext.l	d0
	divu.w	#RosterSlots,d0
	swap	d0
	move.w	d0,d6
	jsr	(GetGoalieCountD7).l
	cmp.w	d0,d6
	bge.w	AwardNotQualified
	movem.l	d7/a0,-(sp)
	movea.l	#SaveRAM+2*SRStandings,a0
	mulu.w	#6,d7
	clr.w	d4
	move.b	1(a0,d7.w),d4
	add.b	3(a0,d7.w),d4
	add.b	5(a0,d7.w),d4
	movem.l	(sp)+,d7/a0
	tst.w	d4
	beq.w	AwardNotQualified
	bsr.w	GetGoalieAwardStats
	movem.l	d5-d6,-(sp)
	mulu.w	#$64,d6
	divu.w	d4,d6
	cmp.w	#$19,d6
	movem.l	(sp)+,d5-d6
	blt.w	AwardNotQualified
	mulu.w	#$64,d5
	divu.w	d6,d5
	cmp.w	#$258,d5
	ble.w	.0
	move.w	#$258,d5
.0
	subi.w	#$258,d5
	neg.w	d5
	divu.w	#$A,d5
	bra.w	AwardQualifies

NorrisScore	;Score: defensemen, 100 * (6 - min(penalty minutes per game, 6)) + 10 * goals + assists
	move.w	d1,d0
	ext.l	d0
	divu.w	#RosterSlots,d0
	swap	d0
	move.w	d0,d6
	jsr	(GetDefenseStartD7).l
	cmp.w	d0,d6
	blt.w	AwardNotQualified
	move.w	d7,d0
	mulu.w	#$A,d0
	add.w	d0,d0
	movea.l	#SaveRAM+2*(SRPOTeamStats+2),a0
	adda.w	d0,a0
	move.b	1(a0),d5
	lsl.w	#8,d5
	move.b	3(a0),d5
	movem.l	d7/a0,-(sp)
	movea.l	#SaveRAM+2*SRStandings,a0
	mulu.w	#6,d7
	clr.w	d6
	move.b	1(a0,d7.w),d6
	add.b	3(a0,d7.w),d6
	add.b	5(a0,d7.w),d6
	movem.l	(sp)+,d7/a0
	ext.l	d5
	tst.w	d6
	beq.w	AwardNotQualified
	divu.w	d6,d5
	cmp.w	#6,d5
	ble.w	.0
	move.w	#6,d5
.0
	subq.w	#6,d5
	neg.w	d5
	mulu.w	#$64,d5
	movea.l	#SaveRAM+2*SRGoals,a0
	move.w	d1,d0
	asl.w	#2,d0
	move.b	1(a0,d0.w),d6
	lsl.w	#8,d6
	move.b	3(a0,d0.w),d6
	mulu.w	#$A,d6
	add.w	d6,d5
	movea.l	#SaveRAM+2*SRAssists,a0
	move.w	d1,d0
	asl.w	#2,d0
	move.b	1(a0,d0.w),d6
	lsl.w	#8,d6
	move.b	3(a0,d0.w),d6
	add.w	d6,d5
	bra.w	AwardQualifies

HartScore	;Score: goalies 10 * (3 - min(goals against / minutes, 3)), skaters 2 * goals + assists
	move.w	d1,d0
	ext.l	d0
	divu.w	#RosterSlots,d0
	swap	d0
	cmp.w	d0,d2
	ble.w	.1
	bsr.w	GetGoalieAwardStats
	tst.w	d6
	beq.w	AwardNotQualified
	divu.w	d6,d5
	cmp.w	#3,d5
	ble.w	.0
	move.w	#3,d5
.0
	subq.w	#3,d5
	neg.w	d5
	mulu.w	#$A,d5
	bra.w	AwardQualifies
.1
	bsr.w	GetAwardGoals
	add.w	d5,d5
	bsr.w	GetAwardAssists
	add.w	d6,d5
	beq.w	AwardNotQualified
	bra.w	AwardQualifies

AwardQualifies	;Score exit: qualifies (d5 is the score)
	clr.w	d0
	rts

AwardNotQualified	;Score exit: does not qualify (d5 = -1)
	move.w	#-1,d5
	rts

GetGoalieAwardStats	;d5 / d6 = the goalie stat words of player d1 (save RAM SRPenMin / SRGamesPlayed)
	movea.l	#SaveRAM+2*SRPenMin,a0
	move.w	d1,d0
	asl.w	#2,d0
	move.b	1(a0,d0.w),d5
	lsl.w	#8,d5
	move.b	3(a0,d0.w),d5
	movea.l	#SaveRAM+2*SRGamesPlayed,a0
	move.b	1(a0,d0.w),d6
	lsl.w	#8,d6
	move.b	3(a0,d0.w),d6
	andi.l	#$7FFF,d6
	rts

AwardsMesareaDone	;mesarea length from TextBuffer in a1, same as FinalizeTextBuffer
	move.w	a1,d0
	subi.w	#(mesarea-M68K_RAM),d0
	btst	#0,d0
	beq.w	.even
	clr.b	(a1)+
	addq.w	#1,d0
.even
	movea.w	#(mesarea-M68K_RAM),a1
	move.w	d0,(a1)
	rts

FormatFirstNameD7	;a1 = mesarea first name for player d0 on team d7
	movem.l	d0-d3/d7-a0/a2,-(sp)
	jsr	(GetRosterName).l
	movea.l	a1,a0
	movea.w	#(TextBuffer-M68K_RAM),a1
	addq.w	#2,a0
.copy
	move.b	(a0)+,(a1)+
	cmpi.b	#$20,(a0)
	bne.s	.copy
	bsr.w	AwardsMesareaDone
	movea.w	#(mesarea-M68K_RAM),a1
	movem.l	(sp)+,d0-d3/d7-a0/a2
	rts

FormatLastNameD7	;a1 = mesarea last name for player d0 on team d7
	movem.l	d0-d3/d7-a0/a2,-(sp)
	jsr	(GetRosterName).l
	movea.l	a1,a0
	movea.w	#(TextBuffer-M68K_RAM),a1
	move.w	(a0)+,d0
	lea	-2(a0,d0.w),a2
.skipfirst
	cmpi.b	#$20,(a0)+
	bne.s	.skipfirst
.copy
	move.b	(a0)+,(a1)+
	cmpa.l	a0,a2
	bne.s	.copy
	bsr.w	AwardsMesareaDone
	movea.w	#(mesarea-M68K_RAM),a1
	movem.l	(sp)+,d0-d3/d7-a0/a2
	rts

GetAwardGoals	;d5 = goals of player d1 (SRGoals or SRPOGoals with sflags11 bit 3)
	movea.l	#SaveRAM+2*SRGoals,a0
	btst	#3,(sflags11).w
	beq.w	.0
	movea.l	#SaveRAM+2*SRPOGoals,a0
.0
	move.w	d1,d0
	asl.w	#2,d0
	move.b	1(a0,d0.w),d5
	lsl.w	#8,d5
	move.b	3(a0,d0.w),d5
	andi.w	#$7FFF,d5
	rts

GetAwardAssists	;d6 = assists of player d0 (SRAssists or SRPOAssists with sflags11 bit 3)
	movea.l	#SaveRAM+2*SRAssists,a0
	btst	#3,(sflags11).w
	beq.w	.0
	movea.l	#SaveRAM+2*SRPOAssists,a0
.0
	move.b	1(a0,d0.w),d6
	lsr.w	#8,d6
	move.b	3(a0,d0.w),d6
	rts

AwardsBgMap
	incbin	..\Extracted\NHL94\Season\AwardsBgMap.map.jim
FinalistsPanelMap
	incbin	..\Extracted\NHL94\Season\FinalistsPanelMap.map.jim
WinnerPanelMap
	incbin	..\Extracted\NHL94\Season\WinnerPanelMap.map.jim
HartPic
	incbin	..\Extracted\NHL94\Season\HartPic.map.jim
NorrisPic
	incbin	..\Extracted\NHL94\Season\NorrisPic.map.jim
VezinaPic
	incbin	..\Extracted\NHL94\Season\VezinaPic.map.jim
ArtRossPic
	incbin	..\Extracted\NHL94\Season\ArtRossPic.map.jim
JenningsPic
	incbin	..\Extracted\NHL94\Season\JenningsPic.map.jim
PearsonPic
	incbin	..\Extracted\NHL94\Season\PearsonPic.map.jim
SelkePic
	incbin	..\Extracted\NHL94\Season\SelkePic.map.jim
PresidentsPic
	incbin	..\Extracted\NHL94\Season\PresidentsPic.map.jim
ConnSmythePic
	incbin	..\Extracted\NHL94\Season\ConnSmythePic.map.jim
