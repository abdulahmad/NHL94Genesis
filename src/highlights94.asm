;	Season game highlights save and NHL HIGHLIGHTS screen (ported from NHL 95 stats95.asm).

SaveGameHighlights	;Pick today's highlight of HomeTeam's game and save at GetHighlightSlot
	btst	#3,(SeasonFlags).w
	bne.w	rtsHighlight
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#StatBuf,a0
	clr.w	(a0)
	bclr	#1,(BA_PS_flags).w
	movea.l	#tmstruct,a2
	movea.l	#AwShots,a3
	move.w	(HmGoals).w,d0
	cmp.w	(AwGoals).w,d0
	bgt.w	.1
	blt.w	.0
	bset	#1,(BA_PS_flags).w
	bra.w	.1
.0
	movea.l	#AwShots,a2
	movea.l	#tmstruct,a3
.1
	movem.l	a2-a3,-(sp)
	bsr.w	MostGoals
	cmp.w	#2,d2
	blt.w	.2
	move.w	Xvel(a2),d0
	mulu.w	#$1A,d0
	add.w	d3,d0
	ori.w	#$2000,d0
	bsr.w	AddHighlight
.2
	movem.l	(sp),a2-a3
	movea.l	a3,a2
	bsr.w	MostGoals
	cmp.w	#3,d2
	blt.w	.3
	move.w	Xvel(a2),d0
	mulu.w	#$1A,d0
	add.w	d3,d0
	ori.w	#$2000,d0
	bsr.w	AddHighlight
.3
	movem.l	(sp),a2-a3
	bsr.w	BestGoalieSaves
	tst.w	tmscore(a3)
	bne.w	.saves
.shutout
	move.w	Xvel(a2),d0
	mulu.w	#$1A,d0
	add.w	d3,d0
	ori.w	#$6000,d0
	bsr.w	AddHighlight
	bra.w	.6
.saves
	cmp.w	#$18,d2
	bgt.s	.shutout
.6
	movem.l	(sp),a2-a3
	bsr.w	MostAssists
	move.l	a2,(StatWork).w
	move.w	d2,(SeasonGameCount).w
	move.w	d3,(StatWork+$6).w
	exg	a2,a3
	bsr.w	MostAssists
	cmp.w	(SeasonGameCount).w,d2
	bge.w	.7
	movea.l	(StatWork).w,a2
	move.w	(SeasonGameCount).w,d2
	move.w	(StatWork+$6).w,d3
.7
	cmp.w	#2,d2
	blt.w	.8
	move.w	Xvel(a2),d0
	mulu.w	#$1A,d0
	add.w	d3,d0
	ori.w	#$4000,d0
	bsr.w	AddHighlight
.8
	nop
	move.w	(StatBuf).w,d0
	andi.w	#$E000,d0
	bne.w	.9
	movem.l	(sp),a2-a3
	bsr.w	MostGoals
	move.w	Xvel(a2),d0
	mulu.w	#$1A,d0
	add.w	d3,d0
	ori.w	#$2000,d0
	bsr.w	AddHighlight
.9
	movem.l	(sp)+,a2-a3
	jsr	(GetHighlightSlot).l
	tst.w	d0
	bmi.w	.10
	movea.l	#StatBuf,a0
	moveq	#4,d1
	jsr	(WriteSRAM).l
	jsr	(MakeSRAMChecksum).l
.10
	movem.l	(sp)+,d0-d7/a0-a6
	rts

BestGoalieSaves	;d2 / d3 = most saves and roster slot in team a2
	movem.l	d4-d6/a2-a3,-(sp)
	jsr	(GetGoalieCount).l
	clr.w	d2
	clr.w	d3
	subq.w	#1,d0
	move.w	d0,d1
	clr.w	d0
	movea.l	a2,a3
	adda.l	#$B6,a2
	adda.l	#$EA,a3
.loop
	move.b	(a3,d0.w),d4
	sub.b	(a2,d0.w),d4
	bpl.w	.1
	clr.b	d4
.1
	cmp.b	d4,d2
	bge.w	.2
	move.b	d4,d2
	move.w	d0,d3
.2
	addq.w	#1,d0
	dbf	d1,.loop
	movem.l	(sp)+,d4-d6/a2-a3
	rts

MostAssists	;d2 / d3 = most assists and roster slot among skaters of team a2
	jsr	(GetGoalieCount).l
	move.w	#$1A,d1
	sub.w	d0,d1
	subq.w	#1,d1
	clr.w	d2
	clr.w	d3
	move.l	a2,-(sp)
	adda.l	#$D0,a2
.loop
	cmp.b	(a2,d0.w),d2
	bge.w	.1
	move.b	(a2,d0.w),d2
	move.w	d0,d3
.1
	addq.w	#1,d0
	dbf	d1,.loop
	movea.l	(sp)+,a2
	rts

MostGoals	;d2 / d3 = most goals and roster slot among skaters of team a2
	jsr	(GetGoalieCount).l
	move.w	#$1A,d1
	sub.w	d0,d1
	subq.w	#1,d1
	clr.w	d2
	clr.w	d3
	move.l	a2,-(sp)
	adda.l	#$B6,a2
.loop
	cmp.b	(a2,d0.w),d2
	bge.w	.1
	move.b	(a2,d0.w),d2
	move.w	d0,d3
.1
	addq.w	#1,d0
	dbf	d1,.loop
	movea.l	(sp)+,a2
	rts

AddHighlight	;Highlight d0 (type + team*$1A + slot) becomes roster id at (a0) unless a better one exists
	move.w	d3,-(sp)
	movem.l	d7,-(sp)
	move.w	d0,d7
	andi.w	#$E000,d7
	move.w	d7,-(sp)
	move.w	d0,d7
	andi.w	#$1FFF,d7
	divu.w	#$1A,d7
	move.l	d7,d0
	swap	d0
	jsr	(GetRosterId).l
	or.w	(sp)+,d0
	movem.l	(sp)+,d7
	move.w	(a0),d1
	bsr.w	CompareHighlight
	beq.w	.1
	move.w	(a0),d1
	andi.w	#$E000,d1
	beq.w	.0
	bne.w	.1
.0
	move.w	d0,(a0)
	move.w	d2,2(a0)
.1
	move.w	(sp)+,d3
	rts

CompareHighlight	;Compare highlight d0 with d1; d3 = 1 and Z clear when d1 is empty
	move.w	d1,d3
	andi.w	#$E000,d3
	beq.w	.0
	andi.w	#$1FFF,d1
	move.w	d0,d3
	andi.w	#$1FFF,d3
	cmp.w	d1,d3
	rts
.0
	move.w	#1,d3

rtsHighlight	;rts (SaveGameHighlights in the playoffs)
	rts

HighlightsScreen	;Season NHL HIGHLIGHTS screen
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(ReadSeasonHeader).l
	btst	#0,(sflags11).w
	bne.w	.0
	jsr	(SkipToGameDay).l
	btst	#3,(SeasonFlags).w
	bne.w	.done
.0
	jsr	(BuildSeasonTeamList).l
	move.b	(SeasonDay).w,(GamesTodayDay).w
	move.l	#ControllerBgMap,(screenarg).l
	bsr.w	GamesTodayGfx
	jsr	(printz).l
	String	-TXMAP2,$2,$6,$0
	movea.l	#HighlightsBgMap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#0,d5
	jsr	(dobitmap).l
	jsr	(PrintHighlightsTitle).l
	jsr	(HighlightsHelp).l
	clr.w	(rosterscroll).w
	move.w	#$FFFF,(setupdir).w
	move.w	#$18,(palcount).w
	bclr	#2,(disflags).w
	bsr.w	DrawHighlightPage
.page
	cmpi.w	#$FFFF,(setupdir).w
	beq.w	.input
	bsr.w	DrawHighlightPage
.input
	bsr.w	ReadHighlightsPad
	move.w	(SelectedPlayerIdx).w,(setupprevline).w
	tst.w	d1
	bne.w	.keys
	move.b	(SeasonDay).w,d0
	cmp.b	(GamesTodayDay).w,d0
	beq.w	.3
	jsr	(ReadSeasonHeader).l
	jsr	(BuildSeasonTeamList).l
.3
	jmp	(Opening2).l
.keys
	move.w	#$FFFF,(setupdir).w
	btst	#7,d1
	bne.w	.start
	btst	#2,d1
	bne.w	.prevday
	btst	#3,d1
	bne.w	.nextday
	btst	#1,d1
	beq.w	.5
	bra.w	.down
.5
	btst	#0,d1
	beq.w	.6
	bra.w	.up
.6
	bra.s	.page
.nextday
	move.w	#$FFFF,(setupdir).w
	movem.w	d0,-(sp)
	move.b	(SeasonDay).w,d0
	cmp.b	(GamesTodayDay).w,d0
	movem.w	(sp)+,d0
	beq.w	.page
	move.w	#3,(setupdir).w
	addq.b	#1,(SeasonDay).w
	jsr	(DayHasGames).l
	beq.s	.nextday
	jsr	(BuildSeasonTeamList).l
	clr.w	(rosterscroll).w
	bra.w	.page
.prevday
	move.w	#$FFFF,(setupdir).w
	tst.b	(SeasonDay).w
	beq.w	.page
	move.w	#2,(setupdir).w
	jsr	(PrevSeasonDay).l
	jsr	(DayHasGames).l
	beq.s	.prevday
	jsr	(BuildSeasonTeamList).l
	clr.w	(rosterscroll).w
	bra.w	.page
.up
	move.w	#0,(setupdir).w
	tst.w	(rosterscroll).w
	bne.w	.10
	move.w	#$FFFF,(setupdir).w
	bra.w	.page
.10
	subq.w	#1,(rosterscroll).w
	bra.w	.page
.down
	move.w	#1,(setupdir).w
	movem.w	d0,-(sp)
	addq.w	#1,(rosterscroll).w
	move.w	(rosterscroll).w,d0
	cmp.b	(SeasonTeams+$1).w,d0
	movem.w	(sp)+,d0
	blt.w	.page
	subq.w	#1,(rosterscroll).w
	move.w	#$FFFF,(setupdir).w
	bra.w	.page
.start
	jsr	(forceblack).l
	move.b	(SeasonDay).w,d0
	cmp.b	(GamesTodayDay).w,d0
	beq.w	.done
	jsr	(ReadSeasonHeader).l
	jsr	(BuildSeasonTeamList).l
.done
	movem.l	(sp)+,d0-d7/a0-a6
	rts

ReadHighlightsPad	;Poll joypads until d1 != 0
	move.l	#$5460,d6
.wait
	move.w	#$64,d6
	move.w	(vcount).w,d1
	sub.w	(oldvcount).w,d1
	beq.s	.wait
	move.w	(vcount).w,(oldvcount).w
	jsr	(ReadJoy1).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.1
	bra.w	.exit
.1
	jsr	(ReadJoy2).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.2
	bra.w	.exit
.2
	tst.w	(FourWayPlay).w
	beq.w	.4
	jsr	(ReadJoy3).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.3
	bra.w	.exit
.3
	jsr	(ReadJoy4).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.4
	bra.w	.exit
.4
	dbf	d6,.wait
.exit
	rts

PrintHighlightsTitle	;print big title NHL HIGHLIGHTS
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP1),$8,$2,'NHL HIGHLIGHTS',$0
	rts

DrawHighlightPage	;Date, logos, score, highlight line for rosterscroll game
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(VisTeam).w,-(sp)
	move.w	(HomeTeam).w,-(sp)
	move.w	#$28,d0
	move.w	#$13,d1
	move.w	#$7FF,d2
	jsr	(printz).l
	String	-TXMAP1,$0,$6,$0
	jsr	(eraser).l
	movea.l	#SeasonTeams,a0
	clr.w	d1
	move.b	1(a0),d3
	beq.w	.0
	jsr	(printz).l
	String	-TXMAP1,$14,$7,$0
	movem.l	d0/a0-a1,-(sp)
	jsr	(MakeDateString).l
	movea.l	#StatWork,a1
	move.w	(a1),d0
	subq.w	#2,d0
	lsr.w	#1,d0
	sub.w	d0,(printx).w
	jsr	(print).l
	movem.l	(sp)+,d0/a0-a1
	move.w	(rosterscroll).w,d0
	mulu.w	#5,d0
	addq.w	#2,d0
	jsr	(printz).l
	String	-TXMAP1,$7,$A,$0
	clr.w	d1
	move.b	0(a0,d0.w),d1
	move.w	d1,(HomeTeam).w
	bsr.w	DrawHighlightLogo
	move.w	#7,(printx).w
	move.w	#$E,(printy).w
	clr.w	d1
	move.b	1(a0,d0.w),d1
	move.w	d1,(VisTeam).w
	bsr.w	DrawHighlightLogo
	bsr.w	PrintGameScore2
	bsr.w	DrawHighlightEntry
.0
	move.w	(sp)+,(HomeTeam).w
	move.w	(sp)+,(VisTeam).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts

DrawHighlightEntry	;Read highlight for this game and print it
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	GetHighlightSlot
	moveq	#4,d1
	movea.l	#StatBuf,a0
	jsr	(ReadSRAM).l
	jsr	(printz).l
	String	-TXMAP1,$14,$13,$0
	bsr.w	PrintHighlight
	movem.l	(sp)+,d0-d7/a0-a6
	rts

FormatLastNameAlt	;a1 = mesarea last name for roster id d0
	movem.l	d0-d3/a0/a2,-(sp)
	jsr	(GetCreatedName).l
	movea.l	a1,a0
	movea.w	#(TextBuffer-M68K_RAM),a1
	adda.w	(a0),a0
	move.b	(a0),d0
	move.w	(a0)+,d0
	lea	-2(a0,d0.w),a2
.skipfirst
	cmpi.b	#$20,(a0)+
	bne.s	.skipfirst
.copy
	move.b	(a0)+,(a1)+
	cmpa.l	a0,a2
	bne.s	.copy
	jsr	(FinalizeTextBuffer).l
	movem.l	(sp)+,d0-d3/a0/a2
	rts

PrintRecordHighlight	;Type 4 highlight: team name and W-L-T from SRStandings
	move.l	a0,-(sp)
	jsr	(printz).l
	String	-TXMAP1,$14,$13,$0
	move.w	(a0),d0
	andi.w	#$FFF,d0
	move.w	d0,-(sp)
	mulu.w	#3,d0
	addi.l	#SRStandings,d0
	movea.l	#StatWork,a0
	moveq	#3,d1
	jsr	(ReadSRAM).l
	move.w	(sp)+,d0
	asl.w	#2,d0
	movea.l	#TeamList,a0
	movea.l	0(a0,d0.w),a0
	adda.w	4(a0),a0
	move.w	(a0),d0
	movea.l	#mesarea,a1
	bra.w	.1
.loop
	move.b	(a0)+,(a1)+
.1
	dbf	d0,.loop
	movea.l	#mesarea,a3
	jsr	(appendz).l
	String	' ',$0
	clr.w	d0
	move.b	(StatWork).w,d0
	bsr.w	HighlightAppendNumber
	jsr	(appendz).l
	String	'-',$0
	clr.w	d0
	move.b	(StatWork+2).w,d0
	bsr.w	HighlightAppendNumber
	jsr	(appendz).l
	String	'-',$0
	clr.w	d0
	move.b	(StatWork+$1).w,d0
	bsr.w	HighlightAppendNumber
	movea.l	#mesarea,a3
	move.w	(a3),d0
	subq.w	#2,d0
	lsr.w	#1,d0
	sub.w	d0,(printx).w
	movea.l	a3,a1
	jsr	(print).l
	movea.l	(sp)+,a0
	rts

HighlightAppendNumber	;Append number d0 to mesarea
	movea.l	#mesarea,a3
	move.w	#2,d1
	cmp.w	#9,d0
	bgt.w	.0
	move.w	#1,d1
.0
	jsr	(PushNumberWidth).l
	jsr	(appstring).l
	movea.l	#mesarea,a3
	rts

PrintHighlight	;Print highlight record a0
	movem.l	d0-d7/a0-a6,-(sp)
	clr.l	d0
	move.w	(a0),d0
	lsr.w	#8,d0
	lsr.w	#5,d0
	tst.w	d0
	beq.w	.2
	cmp.w	#4,d0
	bne.w	.0
	bsr.w	PrintRecordHighlight
	bra.w	.2
.0
	move.w	(a0),d0
	move.l	a0,-(sp)
	andi.w	#$1FFF,d0
	jsr	(FormatLastNameAlt).l
	movea.l	a1,a3
	movea.l	(sp)+,a0
	move.w	2(a0),d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	move.l	a3,-(sp)
	jsr	(appstring).l
	movea.l	(sp)+,a3
	move.w	(a0),d0
	lsr.w	#8,d0
	lsr.w	#5,d0
	asl.w	#2,d0
	movea.l	#HighlightPlurals,a6
	cmpi.w	#1,2(a0)
	bne.w	.1
	movea.l	#HighlightSingulars,a6
.1
	movea.l	0(a6,d0.w),a1
	move.l	a3,-(sp)
	jsr	(appstring).l
	movea.l	(sp)+,a3
	move.w	(a3),d0
	subq.w	#2,d0
	lsr.w	#1,d0
	sub.w	d0,(printx).w
	movea.l	a3,a1
	jsr	(print).l
.2
	movem.l	(sp)+,d0-d7/a0-a6
	rts

HighlightPlurals
	dc.l	0,GoalsText,AssistsText,SavesText

HighlightSingulars
	dc.l	0,GoalText,AssistText,SaveText

AssistsText
	String	' ASSISTS'

AssistText
	String	' ASSIST',$0

SavesText
	String	' SAVES'

SaveText
	String	' SAVE',$0

GoalsText
	String	' GOALS'

GoalText
	String	' GOAL',$0

PrintGameScore2	;Game score or ".......LATER"
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#1,4(a0,d0.w)
	bne.w	.0
	jsr	(printz).l
	String	-TXMAP1,$13,$E,'.......LATER',$0
	bra.w	.1
.0
	clr.w	d5
	move.b	2(a0,d0.w),d5
	move.w	#$19,(printx).w
	move.w	#$A,(printy).w
	bsr.w	PrintScore2
	move.b	3(a0,d0.w),d5
	move.w	#$19,(printx).w
	move.w	#$E,(printy).w
	bsr.w	PrintScore2
.1
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PrintScore2
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	d5,d0
	moveq	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printbig).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

DrawHighlightLogo	;Team logo d1 via dobitmap
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d0
	asl.w	#1,d1
	move.w	(teamblocksmapptr).w,d4
	movea.l	#Teamblocksmap,a0
	movea.l	a0,a1
	adda.l	(a0),a0
	adda.l	4(a1),a1
	movea.l	#ZeroLong,a2
	move.w	(a1),d2
	moveq	#2,d3
	moveq	#0,d5
	jsr	(dobitmap).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

GetHighlightSlot	;d0 = SRAM offset of HomeTeam's game highlight today, or -1
	movem.l	d1-d7/a0-a6,-(sp)
	clr.w	d1
	move.b	(SeasonDay).w,d1
	clr.w	d2
	move.b	(SeasonStartDay).w,d2
	movea.l	#SeasonSchedule,a6
	clr.w	d5
	move.b	(a6)+,d5
	add.w	d2,d1
	cmp.w	d5,d1
	blt.w	.0
	sub.w	d5,d1
.0
	move.l	#SRHighlights,d0
	bra.w	.next
.day
	clr.l	d3
	move.b	(a6)+,d3
	move.w	d3,d4
	add.w	d4,d4
	adda.w	d4,a6
	asl.w	#2,d3
	add.l	d3,d0
.next
	dbf	d1,.day
	move.b	(a6)+,d3
.game
	move.b	(a6),d4
	cmp.b	(HomeTeam+1).w,d4
	beq.w	.done
	addq.l	#4,d0
	addq.l	#2,a6
	dbf	d3,.game
	move.w	#$FFFF,d0
	bra.w	.done
.done
	movem.l	(sp)+,d1-d7/a0-a6
	rts

HighlightsHelp	;{} More games, [] Change day
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(smallfontchars).w,-(sp)
	move.w	(smallfont2chars).w,(smallfontchars).w
	jsr	(printz).l
	String	-TXMAP1,2,$19,'{} More games',-TXMAP1,$19,$19,'[] Change day'
	move.w	(sp)+,(smallfontchars).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts

HighlightsBgMap
	incbin	..\Extracted\NHL94\Season\HighlightsBgMap.map.jim
