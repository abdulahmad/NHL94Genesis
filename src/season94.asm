;	New in 95: season setup, the season header, games today and a simulated day. New Season
;	shows the setup screen, stores the header, and leaves the traded rosters and created
;	players in the battery. Continue Season opens on the saved day.

SeasonMain	;While GameFlags bit 3 is set. Bit 4 is a new season: the setup screen, a clear of the
	;results, and the header. Then games today, the season menu and a simulated day. Playoffs,
	;the cup and the awards return to the title until those screens are in
	btst	#3,(GameFlags).w
	beq.w	.exit
	move.w	(SaveRAM+2*SRSeasonMark).l,d0
	tst.b	d0
	beq.w	.0
	clr.w	(SaveRAM+2*SRSeasonMark).l
	jsr	(MakeSRAMChecksum).l
	bra.w	.playoffs
.0
	btst	#3,(GameFlags).w
	beq.w	.exit
	btst	#4,(GameFlags).w
	beq.w	.day
	jsr	(SeasonSetup).l
	jsr	(ClearSeasonData).l
	clr.w	(SaveRAM+2*SRSeasonMark).l
	jsr	(MakeSRAMChecksum).l
	bsr.w	PickSeasonStartDay
	bclr	#4,(GameFlags).w
.day
	tst.b	(AutoplayDay).w
	beq.w	.2
	move.b	(SeasonDay).w,d0
	andi.w	#$FF,d0
	move.b	(AutoplayDay).w,d1
	andi.w	#$FF,d1
	cmp.w	d1,d0
	blt.w	.sim
	clr.b	(AutoplayDay).w
.2
	btst	#4,(SeasonFlags).w
	bne.w	.awards
	jsr	(GamesToday).l
	btst	#3,(SeasonFlags).w
	beq.w	.3
	btst	#5,(SeasonFlags).w
	beq.w	.seasonend
.3
	jsr	(SeasonOptions).l
	jsr	(BuildSeasonTeamList).l
	st	(seasonteamsel).w
	jsr	(NextSeasonTeam).l
	tst.w	(seasonteamsel).w
	bpl.w	.play
.sim
	jsr	(SimDayGames).l
	jsr	(NextSeasonDay).l
	btst	#3,(SeasonFlags).w
	beq.w	.5
	btst	#5,(SeasonFlags).w
	bne.w	.5
	clr.b	(AutoplayDay).w
	bset	#0,(sflags11).w
	bset	#5,(sflags12).w
	move.w	#$64,(SaveRAM+2*SRSeasonMark).l
	jsr	(MakeSRAMChecksum).l
	jsr	(SeasonOptions).l
	clr.w	(SaveRAM+2*SRSeasonMark).l
	jsr	(MakeSRAMChecksum).l
	bclr	#5,(sflags12).w
	bclr	#0,(sflags11).w
	bra.w	.playoffs
.5
	btst	#3,(SeasonFlags).w
	bne.w	.seasonend
	bra.w	.day
.play
	jsr	(ReadSeasonHeader).l
	jsr	(BuildSeasonTeamList).l
	move.w	(seasonteamsel).w,d0
	movea.l	#SeasonTeams,a0
	clr.w	(Opt1Team).w
	clr.w	(Opt2Team).w
	move.b	0(a0,d0.w),(Opt1Team+1).w
	move.b	1(a0,d0.w),(Opt2Team+1).w
	clr.w	(OptPerlen).w
	move.b	(SeasonPerlen).w,(OptPerlen+1).w
	clr.w	(OptPen).w
	move.b	(SeasonPen).w,(OptPen+1).w
	clr.w	(OptLine).w
	move.b	(SeasonLine).w,(OptLine+1).w
	clr.w	(OptNOP).w
	move.w	#1,(OptUserRec).w
	move.w	#1,(OptGoalie).w
	bset	#5,(GameFlags).w
	rts
.seasonend
	btst	#4,(SeasonFlags).w
	bne.w	.over
	btst	#5,(SeasonFlags).w
	bne.w	.day
	bset	#0,(sflags11).w
	clr.b	(AutoplayDay).w
	jsr	(GamesToday).l
	bclr	#0,(sflags11).w
	jsr	(StandingsScreen).l
.playoffs
	jsr	(InitPlayoffs).l
	jsr	(WriteSeasonHeader).l
	jsr	(SetupPlayoffs).l
	bra.w	.day
.over
	bset	#1,(sflags11).w
	btst	#1,(SimFlags).w
	bne.w	.11
	jsr	(GamesToday).l
.11
	bclr	#1,(sflags11).w
	btst	#0,(SimFlags).w
	beq.w	.awards
	move.w	(SaveRAM+2*SRCupWinner).l,(cupwinner).w
	andi.w	#$FF,(cupwinner).w
	jsr	(StanleyCupScreen).l
.awards
	jsr	(SeasonAwards).l
	bclr	#3,(GameFlags).w
	jmp	(Opening2).l
.exit
	rts

ReadSeasonHeader	;Read the 8 byte season header (SeasonStartDay ...) from save RAM SRSeasonHeader
	movem.l	d0-d7/a0-a6,-(sp)
	moveq	#8,d1
	move.l	#SRSeasonHeader,d0
	movea.l	#SeasonStartDay,a0
	jsr	(ReadSRAM).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

WriteSeasonHeader	;Write the 8 byte season header to save RAM SRSeasonHeader and update the checksum
	movem.l	d0-d7/a0-a6,-(sp)
	moveq	#8,d1
	move.l	#SRSeasonHeader,d0
	movea.l	#SeasonStartDay,a0
	jsr	(WriteSRAM).l
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PickSeasonStartDay	;SeasonDay = 0; with a random schedule (GameFlags bit 6) SeasonStartDay = a random schedule day that has
	;games, else 0. Then WriteSeasonHeader
	move.b	#0,(SeasonDay).w
	btst	#6,(GameFlags).w
	bne.w	.pick
	move.b	#0,(SeasonStartDay).w
	bra.w	.1
.pick
	clr.w	d0
	move.b	(SeasonSchedule).l,d0
	subq.w	#1,d0
	jsr	(randomd0).l
	move.b	d0,(SeasonStartDay).w
	movem.l	a0,-(sp)
	bsr.w	FindDayGames
	tst.b	(a0)
	movem.l	(sp)+,a0
	beq.s	.pick
.1
	bsr.w	WriteSeasonHeader
	rts

FindDayGames	;a0 = the schedule entry of SeasonDay (count byte, then 2 bytes a game)
	movem.l	d0-d7/a1-a6,-(sp)
	btst	#3,(SeasonFlags).w
	beq.w	.2
	jsr	(ReadPlayoffSchedule).l
	movea.l	#PlayoffSchedule+$1,a0
	clr.w	d5
	move.b	(SeasonDay).w,d5
	bra.w	.1
.loop
	clr.w	d4
	move.b	(a0)+,d4
	add.w	d4,d4
	adda.w	d4,a0
.1
	dbf	d5,.loop
	bra.w	.6
.2
	clr.w	d4
	move.b	(SeasonStartDay).w,d4
	clr.w	d5
	move.b	(SeasonDay).w,d5
	add.w	d4,d5
	cmp.w	#$C0,d5
	blt.w	.3
	subi.w	#$C0,d5
.3
	movea.l	#SeasonSchedule+1,a0
	bra.w	.5
.loop2
	clr.w	d0
	move.b	(a0),d0
	add.w	d0,d0
	addq.w	#1,d0
	adda.w	d0,a0
.5
	dbf	d5,.loop2
.6
	movem.l	(sp)+,d0-d7/a1-a6
	rts

ClearSeasonData	;New season: clear the game results, standings and the header-save area. Rosters and created players stay
	movem.l	d0-d7/a0-a6,-(sp)
	lea	(M68K_RAM).l,a0
	move.w	#$CCB,d0
	clr.l	d1
.loop
	move.b	d1,(a0)+
	dbf	d0,.loop
	move.l	#SRGameResults,d0
	move.l	#$CCC,d1
	lea	(M68K_RAM).l,a0
	jsr	(WriteSRAM).l
	lea	(M68K_RAM).l,a0
	move.w	#$4D,d0
	clr.l	d1
.loop2
	move.b	d1,(a0)+
	dbf	d0,.loop2
	move.l	#SRStandings,d0
	moveq	#$4E,d1
	lea	(M68K_RAM).l,a0
	jsr	(WriteSRAM).l
	move.l	#$24,(M68K_RAM).l
	move.w	#5,(M68K_RAM+4).l
	move.l	#SRGoalTotal,d0
	moveq	#6,d1
	lea	(M68K_RAM).l,a0
	jsr	(WriteSRAM).l
	move.w	#$1113,d1
	lsr.w	#2,d1
	clr.l	d0
	lea	(M68K_RAM).l,a0
.loop3
	move.l	d0,(a0)+
	dbf	d1,.loop3
	move.l	#SRSeasonHeaderSave,d0
	move.l	#$1110,d1
	lea	(M68K_RAM).l,a0
	jsr	(WriteSRAM).l
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

InitSeasonStats	;New season: clear the player stat blocks, the extra team block, team stats and injuries. Rosters stay
	movem.l	d0-d7/a0-a6,-(sp)
	lea	(M68K_RAM).l,a0
	move.w	#$6DC,d0
	clr.l	d1
.loop
	move.l	d1,(a0)+
	dbf	d0,.loop
	move.l	#SRGoals,d0
	move.l	#$1B6C,d1
	movea.l	#M68K_RAM,a0
	jsr	(WriteSRAM).l
	lea	(LeaderValues).w,a0
	move.w	#$42,d0
	clr.l	d1
.loop2
	move.l	d1,(a0)+
	dbf	d0,.loop2
	move.l	#SRTeamBlock2,d0
	move.l	#$104,d1
	movea.l	#LeaderValues,a0
	jsr	(WriteSRAM).l
	lea	(M68K_RAM).l,a0
	move.w	#$103,d0
	clr.l	d1
.loop3
	move.b	d1,(a0)+
	dbf	d0,.loop3
	move.l	#SRTeamStats,d0
	move.l	#$104,d1
	movea.l	#M68K_RAM,a0
	jsr	(WriteSRAM).l
	jsr	(MakeSRAMChecksum).l
	lea	(M68K_RAM).l,a0
	move.w	#$179,d0
	clr.l	d1
.loop4
	move.b	d1,(a0)+
	dbf	d0,.loop4
	move.l	#SRInjuries,d0
	move.l	#$17A,d1
	movea.l	#M68K_RAM,a0
	jsr	(WriteSRAM).l
	jsr	(MakeSRAMChecksum).l
	jsr	(MarkSeasonRosters).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

SeasonSetup	;SEASON SETUP screen: period length, penalties, line changes, playoffs, injuries, schedule
	movem.l	d0-d7/a0-a6,-(sp)
	clr.l	(setupvalues).w
	clr.l	(setupvalues+4).w
	clr.l	(setupvalues+8).w
	bclr	#6,(GameFlags).w
	clr.b	(SeasonFlags).w
	bsr.w	SeasonSetupGfx
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP1),$8,$2,'SEASON SETUP',$0
	movea.l	#SeasonSetupHelp,a1
	bsr.w	PrintOptionHi
	clr.w	(SelectedPlayerIdx).w
	clr.w	(setupprevline).w
	clr.w	(DispAttribCtr).w
	move.w	#4,(VertLineScrolling).w
	move.w	#$FFFF,(setupdir).w
	move.w	#$18,(palcount).w
	bclr	#2,(disflags).w
.loop
	bsr.w	SeasonSetupLines
	bsr.w	DrawSeasonSetup
	bsr.w	ReadAnyPad
	move.w	(SelectedPlayerIdx).w,(setupprevline).w
	tst.w	d1
	bne.w	.keys
	bra.w	.store
.keys
	move.w	#$FFFF,(setupdir).w
	btst	#7,d1
	bne.w	.store
	btst	#1,d1
	beq.w	.2
	bra.w	.down
.2
	btst	#0,d1
	beq.w	.3
	bra.w	.up
.3
	btst	#2,d1
	beq.w	.right
	bra.w	.left
.right
	btst	#3,d1
	beq.s	.loop
	move.w	#3,(setupdir).w
	move.w	(SelectedPlayerIdx).w,d0
	movea.l	#setupvalues,a0
	addq.b	#1,(a0,d0.w)
	bsr.w	WrapSetupUp
	bra.s	.loop
.left
	move.w	#2,(setupdir).w
	move.w	(SelectedPlayerIdx).w,d0
	movea.l	#setupvalues,a0
	subq.b	#1,(a0,d0.w)
	bsr.w	WrapSetupDown
	bra.w	.loop
.up
	move.w	#0,(setupdir).w
	tst.w	(SelectedPlayerIdx).w
	beq.w	.loop
	subq.w	#1,(SelectedPlayerIdx).w
	bra.w	.loop
.down
	move.w	#$FFFF,(setupdir).w
	cmpi.w	#4,(SelectedPlayerIdx).w
	beq.w	.loop
	move.w	#1,(setupdir).w
	addq.w	#1,(SelectedPlayerIdx).w
	bra.w	.loop
.store
	jsr	(forceblack).l
	bsr.w	StoreSeasonSetup
	jsr	(WriteSeasonHeader).l
	jsr	(InitSeasonStats).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

ReadAnyPad	;Wait for a pad press, d1 = buttons
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

StoreSeasonSetup	;Copy the setup values into the season header and flags
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#setupvalues,a0
	move.w	#$C0,d0
	move.b	d0,(SeasonLength).w
	move.b	(a0),(SeasonPerlen).w
	move.b	1(a0),(SeasonPen).w
	move.b	2(a0),(SeasonLine).w
	bclr	#1,(SeasonFlags).w
	tst.b	3(a0)
	beq.w	.0
	bset	#1,(SeasonFlags).w
.0
	bset	#2,(SeasonFlags).w
	tst.b	4(a0)
	beq.w	.1
	bclr	#2,(SeasonFlags).w
.1
	bclr	#6,(GameFlags).w
	tst.b	5(a0)
	beq.w	.2
	bset	#6,(GameFlags).w
.2
	movem.l	(sp)+,d0-d7/a0-a6
	rts

SeasonSetupCounts	;Number of values of each setup line
	dc.b	3,3,3,2,2,2

WrapSetupUp	;Wrap setup value d0 to 0 past its last value
	movea.l	#SeasonSetupCounts,a1
	clr.w	d2
	move.b	(a1,d0.w),d2
	cmp.b	(a0,d0.w),d2
	bgt.w	.exit
	clr.b	(a0,d0.w)
.exit
	rts

WrapSetupDown	;Wrap setup value d0 to its last value below 0
	tst.b	(a0,d0.w)
	bpl.w	.exit
	movea.l	#SeasonSetupCounts,a1
	move.b	(a1,d0.w),d2
	subq.b	#1,d2
	move.b	d2,(a0,d0.w)
.exit
	rts

SeasonSetupLines	;a0 = setupvalues
	movea.l	#setupvalues,a0
	move.w	#5,(setuplines).w
	move.w	#5,(setupshown).w
	rts

SeasonSetupGfx	;Season setup screen video set up and graphics
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
	move.w	d4,(smallfont2chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$83,$44,$67,$89,$AB,$CD,$EF
	move.w	d4,(smallfont3chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$83,$4C,$67,$89,$AB,$CD,$EF
	move.w	d4,(BigFontChars).w
	movea.l	#BigFontMap+8,a2
	jsr	(DecompressGraphicsPlain).l
	jsr	(printz).l
	String	-TXMAP2,$0,$0,$0
	movea.l	#ControllerBgMap,a0
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
	rts

DrawSeasonSetup	;Print the setup lines
	move.w	(DispAttribCtr).w,d0
	move.w	#9,(printy).w
.loop
	move.w	#3,(printx).w
	bsr.w	PrintSetupName
	move.w	#$18,(printx).w
	bsr.w	PrintSetupValue
	addq.w	#2,(printy).w
	addq.w	#1,d0
	cmp.w	(VertLineScrolling).w,d0
	ble.s	.loop
	rts

PrintSetupValue	;Print the value of setup line d0, highlighted on the cursor line
	movem.l	d0-d2/a0-a1,-(sp)
	movea.l	#setupvalues,a0
	clr.w	d1
	move.b	(a0,d0.w),d1
	move.w	d0,d2
	add.w	d2,d2
	movea.l	#SetupValueText,a1
	adda.w	(a1,d2.w),a1
	bra.w	.1
.loop
	adda.w	(a1),a1
.1
	dbf	d1,.loop
	cmp.w	(SelectedPlayerIdx).w,d0
	bne.w	.2
	bsr.w	PrintOptionHi
	bra.w	.3
.2
	bsr.w	PrintOption
.3
	movem.l	(sp)+,d0-d2/a0-a1
	rts

PrintSetupName	;Print the name of setup line d0, highlighted on the cursor line
	movem.l	d0/a1,-(sp)
	move.w	d0,-(sp)
	movea.l	#SetupNameText,a1
	bra.w	.1
.loop
	adda.w	(a1),a1
.1
	dbf	d0,.loop
	move.w	(sp)+,d0
	cmp.w	(SelectedPlayerIdx).w,d0
	bne.w	.2
	bsr.w	PrintOptionHi
	bra.w	.3
.2
	bsr.w	PrintOption
.3
	movem.l	(sp)+,d0/a1
	rts

PrintOption	;Print String a1 at printx / printy in the second small font
	move.w	(smallfontchars).w,-(sp)
	movem.l	a1,-(sp)
	move.l	#SmallFontMap,(smallfontptr).l
	move.w	(smallfont2chars).w,(smallfontchars).w
	move.w	(printx).w,-(sp)
	move.w	(printy).w,-(sp)
	jsr	(printz).l
	String	-TXMAP1,$0,$0,$0
	move.w	(sp)+,(printy).w
	move.w	(sp)+,(printx).w
	movem.l	(sp)+,a1
	jsr	(print).l
	move.w	(sp)+,(smallfontchars).w
	rts

PrintOptionHi	;Print String a1 at printx / printy in the highlight font
	move.w	(smallfontchars).w,-(sp)
	movem.l	a1,-(sp)
	move.l	#SmallFontMap,(smallfontptr).l
	move.w	(smallfont3chars).w,(smallfontchars).w
	move.w	(printx).w,-(sp)
	move.w	(printy).w,-(sp)
	jsr	(printz).l
	String	-TXMAP1,$0,$0,$0
	move.w	(sp)+,(printy).w
	move.w	(sp)+,(printx).w
	movem.l	(sp)+,a1
	jsr	(print).l
	move.w	(sp)+,(smallfontchars).w
	rts

SetupValueText	;Offsets of the value lists of each setup line, then the value Strings
	dc.w	.0-SetupValueText,.1-SetupValueText,.2-SetupValueText,.3-SetupValueText,.4-SetupValueText,.5-SetupValueText
.0
	String	'5 Minutes     '
	String	'10 Minutes    '
	String	'20 Minutes    '
	String	'30 Seconds    '
.1
	String	'Off           '
	String	'On            '
	String	'On,No Offsides'
.2
	String	'On            '
	String	'Off           '
	String	'Auto          '
.3
	String	'Single Game   '
	String	'Best Of Seven '
.4
	String	'Multi-game    '
	String	'One Game Only '
.5
	String	'Normal        '
	String	'Random        '

SetupNameText	;Setup line names
	String	'Period Length',$0
	String	'Penalties    ',$0
	String	'Line Changes ',$0
	String	'Playoffs     ',$0
	String	'Injuries     ',$0
	String	'Season Schedule     '

SeasonSetupHelp	;Season setup help line
	String	$BF,$2,$19,'{} Select option    [] Change option',$BF,$9,$1A,'Start = Store Setup',$0

;	Games today, the season menu, and the scores of a computer day.

BuildSeasonTeamList	;Build today's game list in SeasonTeams (day, count, then 5 bytes a game: home, away, home score, away
	;score, flags) from the schedule and the results in save RAM. Falls into ReadDayGames
	clr.w	d1
	move.b	(SeasonDay).w,d1
	clr.w	d2
	move.b	(SeasonStartDay).w,d2
	movea.l	#SeasonTeams,a2

ReadDayGames	;d1 = day, d2 = start day, a2 = buffer: read the day's games and their saved results
	movem.l	d0-d7/a0-a6,-(sp)
	move.b	d1,(a2)+
	btst	#0,(sflags11).w
	bne.w	.1
	btst	#1,(sflags11).w
	bne.w	.0
	btst	#3,(SeasonFlags).w
	beq.w	.1
.0
	jsr	(ReadPlayoffSchedule).l
	movea.l	#PlayoffSchedule+$1,a0
	bra.w	.2
.1
	movea.l	#SeasonSchedule,a0
	clr.w	d5
	move.b	(a0)+,d5
	add.w	d2,d1
	cmp.w	d5,d1
	blt.w	.2
	sub.w	d5,d1
.2
	move.l	#SRGameResults,d0
	bra.w	.4
.skipday
	clr.l	d3
	move.b	(a0)+,d3
	move.w	d3,d4
	add.w	d4,d4
	adda.w	d4,a0
	move.b	d3,-(sp)
	add.b	d3,d3
	add.b	(sp)+,d3
	add.l	d3,d0
.4
	dbf	d1,.skipday
	clr.w	d1
	move.b	(a0)+,d1
	move.b	d1,(a2)+
	bra.w	.6
.game
	move.b	(a0)+,(a2)
	move.b	(a0)+,1(a2)
	movem.l	d0-d7/a0-a7,-(sp)
	moveq	#3,d1
	lea	2(a2),a0
	jsr	(ReadSRAM).l
	eori.b	#1,4(a2)
	movem.l	(sp)+,d0-d7/a0-a7
	addq.l	#3,d0
	addq.w	#5,a2
.6
	dbf	d1,.game
	movem.l	(sp)+,d0-d7/a0-a6
	rts

WriteDayGames	;Write the results of the games in SeasonTeams back to save RAM
	clr.w	d2
	move.b	(SeasonStartDay).w,d2
	movea.l	#SeasonTeams,a2
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d1
	move.b	(a2)+,d1
	btst	#3,(SeasonFlags).w
	beq.w	.0
	jsr	(ReadPlayoffSchedule).l
	movea.l	#PlayoffSchedule+$1,a0
	bra.w	.1
.0
	movea.l	#SeasonSchedule,a0
	clr.w	d5
	move.b	(a0)+,d5
	add.w	d2,d1
	cmp.w	d5,d1
	blt.w	.1
	sub.w	d5,d1
.1
	move.l	#SRGameResults,d0
	bra.w	.3
.skipday
	clr.l	d3
	move.b	(a0)+,d3
	move.w	d3,d4
	add.w	d4,d4
	adda.w	d4,a0
	move.b	d3,-(sp)
	add.b	d3,d3
	add.b	(sp)+,d3
	add.l	d3,d0
.3
	dbf	d1,.skipday
	clr.w	d1
	move.b	(a2)+,d1
	bra.w	.5
.game
	movem.l	d0-d7/a0-a6,-(sp)
	moveq	#3,d1
	lea	2(a2),a0
	eori.b	#1,4(a2)
	jsr	(WriteSRAM).l
	eori.b	#1,4(a2)
	movem.l	(sp)+,d0-d7/a0-a6
	addq.l	#3,d0
	addq.w	#5,a2
.5
	dbf	d1,.game
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

SkipToGameDay	;Step SeasonDay forward until a day with games
	movem.l	d0-d7/a0-a6,-(sp)
.loop
	bsr.w	FindDayGames
	tst.b	(a0)
	bne.w	.1
	bsr.w	NextSeasonDay
	bra.s	.loop
.1
	movem.l	(sp)+,d0-d7/a0-a6
	rts

DayHasGames	;Ne when SeasonDay has games
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	FindDayGames
	tst.b	(a0)
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PrevSeasonDay	;SeasonDay - 1, not below 0
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d0
	move.b	(SeasonLength).w,d0
	clr.w	d1
	move.b	(SeasonDay).w,d1
	beq.w	.0
	subq.w	#1,d1
	move.b	d1,(SeasonDay).w
.0
	movem.l	(sp)+,d0-d7/a0-a6
	rts

NextSeasonDay	;SeasonDay + 1; at SeasonLength set SeasonFlags bit 3. In the playoffs advance the day and round
	btst	#5,(SeasonFlags).w
	bne.w	.2
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d0
	move.b	(SeasonLength).w,d0
	clr.w	d1
	move.b	(SeasonDay).w,d1
	addq.w	#1,d1
	cmp.w	d0,d1
	blt.w	.0
	bset	#3,(SeasonFlags).w
	bra.w	.1
.0
	move.b	d1,(SeasonDay).w
.1
	bsr.w	WriteSeasonHeader
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.2
	movem.l	d0-d7/a0-a6,-(sp)
	bset	#7,(GameFlags).w
	addq.b	#1,(SeasonDay).w
	move.l	(SaveRAM+2*SRPODay).l,d0
	addq.b	#1,d0
	move.l	d0,(SaveRAM+2*SRPODay).l
	jsr	(WriteSeasonHeader).l
	jsr	(BuildPlayoffDayGames).l
	bne.w	.4
	move.l	(SaveRAM+2*SRPORound).l,d0
	cmp.b	#3,d0
	bge.w	.3
	addq.b	#1,d0
	move.l	d0,(SaveRAM+2*SRPORound).l
	jsr	(NextPlayoffRound).l
	bra.w	.4
.3
	bset	#4,(SeasonFlags).w
	jsr	(WriteSeasonHeader).l
.4
	bclr	#7,(GameFlags).w
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

NextSeasonTeam	;seasonteamsel = offset of the first unplayed human game in SeasonTeams after it, -1 none
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#SeasonTeams+1,a0
	clr.w	d0
	move.b	(a0)+,d0
	move.w	#2,d1
	bra.w	.2
.loop
	btst	#0,4(a0)
	bne.w	.1
	btst	#1,4(a0)
	bne.w	.1
	cmp.w	(seasonteamsel).w,d1
	ble.w	.1
	move.w	d1,(seasonteamsel).w
	bra.w	.3
.1
	addq.w	#5,d1
	addq.w	#5,a0
.2
	dbf	d0,.loop
	st	(seasonteamsel).w
.3
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PrevSeasonTeam	;seasonteamsel = offset of the last unplayed human game in SeasonTeams before it, -1 none
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#SeasonTeams+1,a0
	clr.w	d0
	move.b	(a0)+,d0
	move.w	d0,d6
	subq.w	#1,d6
	mulu.w	#5,d6
	addq.w	#2,d6
	move.w	d6,d1
	lea	-2(a0,d1.w),a0
	bra.w	.3
.loop
	btst	#0,4(a0)
	bne.w	.2
	btst	#1,4(a0)
	bne.w	.2
	tst.w	(seasonteamsel).w
	bmi.w	.1
	cmp.w	(seasonteamsel).w,d1
	bge.w	.2
.1
	move.w	d1,(seasonteamsel).w
	bra.w	.4
.2
	subq.w	#5,d1
	subq.w	#5,a0
.3
	dbf	d0,.loop
	st	(seasonteamsel).w
.4
	movem.l	(sp)+,d0-d7/a0-a6
	rts

SimDayGames	;Simulate every computer game of the day (flags bit 0 set, bit 1 clear), then write the scores
	movem.l	d0-d7/a0-a6,-(sp)
	move	sr,-(sp)
	bset	#7,(GameFlags).w
	move	#$2300,sr
	bsr.w	BuildSeasonTeamList
	movea.l	#SeasonTeams,a0
	clr.w	d0
	move.b	1(a0),d0
	addq.w	#2,a0
	bra.w	.2
.loop
	btst	#0,4(a0)
	beq.w	.1
	btst	#1,4(a0)
	bne.w	.1
	bclr	#0,(SimFlags).w
	bclr	#1,(SimFlags).w
	bsr.w	SimScore
	bset	#1,4(a0)
	jsr	(RecordPlayoffGame).l
	bsr.w	RecordGameResult
	move.w	#$4B0,(PerTimeTotal).w
	bsr.w	SimGameStats
.1
	addq.w	#5,a0
.2
	dbf	d0,.loop
	bclr	#7,(GameFlags).w
	bsr.w	WriteDayGames
	move	(sp)+,sr
	movem.l	(sp)+,d0-d7/a0-a6
	rts

GameSetUpSeason	;GameSetUp: a human season game skips the menu. Otherwise the menu runs as usual
	btst	#5,(GameFlags).w
	bne.w	SeasonGameStart
	jmp	(GameSetUpMenu).l

SeasonGameStart	;Start the human season game already stored in the option words. The saved roster stays in use
	jsr	(ClearGameStats).l
	jsr	(ReadNameLog).l
	st	(demoflag).w
	move.w	(Opt1Team).w,(HomeTeam).w
	move.w	(Opt2Team).w,(VisTeam).w
	move.w	(OptLine).w,(TmpOptLine2).w
	cmpi.w	#2,(OptLine).w
	bne.w	.0
	clr.w	(OptLine).w
	bset	#4,(sflags7).w
.0
	move.w	(OptGoalie).w,-(sp)
	move.w	(sp),(goaliemode1).w
	move.w	(sp)+,(goaliemode2).w
	jsr	(UpdatePlayoffLevel).l
	move.w	(VDP_CNTR).l,(seed).w
	move.w	(VDP_CNTR).l,(seed+2).w
	move.w	(OptPlayMode).w,(TempOptPlayMode).w
	clr.w	(OptPlayMode).w
	bclr	#6,(sflags11).w
	bclr	#5,(GameFlags).w
	jmp	(maketree).l

SeasonGameOver	;After a human season game, copy the score into today's list and save the result
	clr.w	(seasonsetupreq).w
	btst	#3,(GameFlags).w
	beq.w	.exit
	st	(seasonsetupreq).w
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	ReadSeasonHeader
	bsr.w	BuildSeasonTeamList
	move.w	(HomeTeam).w,d1
	movea.l	#SeasonTeams+1,a0
	clr.w	d0
	move.b	(a0)+,d0
	beq.w	.3
	bra.w	.1
.loop
	cmp.b	(a0),d1
	beq.w	.2
	addq.w	#5,a0
.1
	dbf	d0,.loop
	bra.w	.3
.2
	movea.l	#tmstruct,a1
	move.b	$D(a1),2(a0)
	adda.w	#tmsize,a1
	move.b	$D(a1),3(a0)
	bset	#1,4(a0)
	jsr	(RecordPlayoffGame).l
	bset	#7,(GameFlags).w
	bsr.w	AddSeasonGoals
	bsr.w	WriteDayGames
	bsr.w	RecordGameResult
	bset	#1,(SimFlags).w
	jsr	(SaveSimGame).l
	bclr	#7,(GameFlags).w
	jsr	(MakeSRAMChecksum).l
.3
	movem.l	(sp)+,d0-d7/a0-a6
.exit
	rts

SaveSimGame	;Save the player lines and the team lines of the game just finished
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(tmstruct+$28).w,(SaveRAM+2*SRCupWinner).l
	move.w	(HmGoals).w,d7
	cmp.w	(AwGoals).w,d7
	bgt.w	.0
	move.w	(AwShots+$28).w,(SaveRAM+2*SRCupWinner).l
.0
	bclr	#0,(SimFlags).w
	move.w	#1,d0
	move.w	(HmGoals).w,d7
	cmp.w	(AwGoals).w,d7
	bgt.w	.1
	beq.w	.3
	move.w	#2,d0
.1
	cmp.w	(cont1team).w,d0
	beq.w	.2
	cmp.w	(cont2team).w,d0
	beq.w	.2
	cmp.w	(cont3team).w,d0
	beq.w	.2
	cmp.w	(cont4team).w,d0
	bne.w	.3
.2
	btst	#1,(SimFlags).w
	beq.w	.3
	bset	#0,(SimFlags).w
.3
	move.w	(HomeTeam).w,d7
	jsr	(GetGoalieCountD7).l
	move.w	d0,d6
	subq.w	#1,d6
	add.w	d6,d6
	move.w	d7,d0
	movea.l	#tmstruct,a1
	bsr.w	AddPlayerSeasonStats
	move.w	(VisTeam).w,d0
	movea.l	#AwShots,a1
	bsr.w	AddPlayerSeasonStats
	bsr.w	SaveGameHighlights
	move.w	(HomeTeam).w,d0
	movea.l	#tmstruct,a1
	movea.l	#AwShots,a2
	bsr.w	AddTeamSeasonStats
	move.w	(VisTeam).w,d0
	movea.l	#AwShots,a1
	movea.l	#tmstruct,a2
	bsr.w	AddTeamSeasonStats
	move.w	(tmstruct+$28).w,d0
	move.w	(AwShots+$28).w,d1
	jsr	(TickTeamInjuries).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

AddTeamSeasonStats	;Add team a1's totals (a2 is the other team) to team d0's season record
	mulu.w	#$A,d0
	btst	#5,(SeasonFlags).w
	beq.w	.0
	addi.l	#SRPOTeamStats,d0
	bra.w	.1
.0
	addi.l	#SRTeamStats,d0
.1
	movea.l	#StatBuf,a0
	moveq	#$A,d1
	movem.l	d0-d1/a0,-(sp)
	jsr	(ReadSRAM).l
	movea.l	#StatBuf,a0
	move.w	$C(a1),d5
	add.w	d5,(a0)
	move.w	$C(a2),d5
	add.w	d5,2(a0)
	move.w	8(a1),d5
	add.w	d5,4(a0)
	move.w	(a1),d5
	add.w	d5,6(a0)
	move.w	(a2),d5
	add.w	d5,8(a0)
	movem.l	(sp)+,d0-d1/a0
	jsr	(WriteSRAM).l
	jsr	(MakeSRAMChecksum).l
	rts

AddPlayerSeasonStats	;Add goals, assists, shots, penalty minutes and games played for team d0, stats at a1
	move.l	#SRGoals,d2
	btst	#5,(SeasonFlags).w
	beq.w	.0
	move.l	#SRPOGoals,d2
.0
	movem.l	d0/a1,-(sp)
	bsr.w	ReadStatBlock
.loop
	clr.w	d2
	move.b	$B4(a1),d2
	andi.w	#$7FFF,(a0,d0.w)
	add.w	d2,(a0,d0.w)
	cmp.w	d6,d0
	bgt.w	.2
	ori.w	#$8000,(a0,d0.w)
.2
	addq.w	#1,a1
	addq.w	#2,d0
	dbf	d7,.loop
	bsr.w	WriteStatBlock
	movem.l	(sp),d0/a1
	move.l	#SRAssists,d2
	btst	#5,(SeasonFlags).w
	beq.w	.3
	move.l	#SRPOAssists,d2
.3
	bsr.w	ReadStatBlock
.loop2
	clr.w	d2
	move.b	$CE(a1),d2
	add.w	d2,(a0,d0.w)
	addq.w	#1,a1
	addq.w	#2,d0
	dbf	d7,.loop2
	bsr.w	WriteStatBlock
	movem.l	(sp),d0/a1
	move.l	#SRShots,d2
	btst	#5,(SeasonFlags).w
	beq.w	.5
	move.l	#SRPOShots,d2
.5
	bsr.w	ReadStatBlock
.loop3
	clr.w	d2
	move.b	$E8(a1),d2
	andi.w	#$7FFF,(a0,d0.w)
	add.w	d2,(a0,d0.w)
	cmp.w	d6,d0
	bgt.w	.7
	ori.w	#$8000,(a0,d0.w)
.7
	addq.w	#1,a1
	addq.w	#2,d0
	dbf	d7,.loop3
	bsr.w	WriteStatBlock
	movem.l	(sp),d0/a1
	move.l	a4,-(sp)
	movea.l	a1,a4
	move.l	#SRPenMin,d2
	btst	#5,(SeasonFlags).w
	beq.w	.8
	move.l	#SRPOPenMin,d2
.8
	bsr.w	ReadStatBlock
.loop4
	clr.w	d2
	cmp.w	d6,d0
	bgt.w	.skater
	move.b	$B4(a1),d2
	movem.l	d4-d5,-(sp)
	move.w	(PerTimeTotal).w,d4
	add.w	(PerTimeTotal).w,d4
	add.w	(PerTimeTotal).w,d4
	move.w	$136(a4),d5
	beq.w	.12
	ext.l	d4
	divu.w	d5,d4
	cmp.w	#1,d4
	bge.w	.10
	move.w	#1,d4
.10
	mulu.w	d4,d2
	cmp.l	#$7FFF,d2
	blt.w	.11
	move.w	#$7FFF,d2
.11
	add.w	d2,(a0,d0.w)
.12
	movem.l	(sp)+,d4-d5
	bra.w	.14
.skater
	move.b	$102(a1),d2
	add.w	d2,(a0,d0.w)
.14
	addq.w	#1,a1
	addq.w	#2,a4
	addq.w	#2,d0
	dbf	d7,.loop4
	bsr.w	WriteStatBlock
	movea.l	(sp)+,a4
	movem.l	(sp),d0/a1
	move.l	#SRGamesPlayed,d2
	btst	#5,(SeasonFlags).w
	beq.w	.15
	move.l	#SRPOGamesPlayed,d2
.15
	bsr.w	ReadStatBlock
.loop5
	clr.w	d2
	tst.w	$136(a1)
	beq.w	.17
	cmp.w	d6,d0
	bgt.w	.17
	addq.w	#1,(a0,d0.w)
.17
	addq.w	#2,a1
	addq.w	#2,d0
	dbf	d7,.loop5
	bsr.w	WriteStatBlock
	movem.l	(sp)+,d0/a1
	jsr	(MakeSRAMChecksum).l
	rts

ReadStatBlock	;Read team d0's $34 byte block at save RAM d2 into StatBuf. d0 = 0 and d7 = $19 on return
	mulu.w	#$34,d0
	add.l	d2,d0
	movea.l	#StatBuf,a0
	moveq	#$34,d1
	movea.l	#StatWork+$14,a5
	movem.l	d0-d1/a0,-(a5)
	jsr	(ReadSRAM).l
	movea.l	#StatBuf,a0
	clr.w	d0
	move.w	#$19,d7
	rts

WriteStatBlock	;Write StatBuf back to the block ReadStatBlock read
	movem.l	(a5)+,d0-d1/a0
	jmp	(WriteSRAM).l

AddSeasonGoals	;Add the game's goals to the season goal total and count the game
	movem.l	d0-d7/a0-a6,-(sp)
	move.l	a0,-(sp)
	move.l	#SRGoalTotal,d0
	moveq	#6,d1
	movea.l	#SeasonGoalSum,a0
	jsr	(ReadSRAM).l
	movea.l	(sp)+,a0
	clr.l	d0
	move.b	2(a0),d0
	add.b	3(a0),d0
	add.l	d0,(SeasonGoalSum).w
	addq.w	#1,(SeasonGameCount).w
	move.l	#SRGoalTotal,d0
	moveq	#6,d1
	movea.l	#SeasonGoalSum,a0
	jsr	(WriteSRAM).l
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

RecordGameResult	;RecordTeamResult for the home and the away team, then the checksum
	movem.l	d0-d7/a0-a6,-(sp)
	clr.l	d4
	bsr.w	RecordTeamResult
	move.w	#1,d4
	bsr.w	RecordTeamResult
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

RecordTeamResult	;Add a win, loss or tie to the team's standings record (3 bytes a team)
	movem.l	a0,-(sp)
	clr.w	d2
	move.b	(a0),d2
	tst.w	d4
	beq.w	.0
	move.b	1(a0),d2
.0
	mulu.w	#3,d2
	move.l	#SRStandings,d0
	btst	#5,(SeasonFlags).w
	beq.w	.1
	move.l	#SRPOStandings,d0
.1
	add.l	d2,d0
	move.b	2(a0),d3
	move.b	3(a0),d5
	tst.w	d4
	beq.w	.2
	move.w	d3,-(sp)
	move.w	d5,d3
	move.w	(sp)+,d5
.2
	cmp.b	d5,d3
	beq.w	.4
	bgt.w	.3
	addq.l	#2,d0
	bra.w	.5
.3
	addi.l	#0,d0
	bra.w	.5
.4
	addq.l	#1,d0
.5
	moveq	#1,d1
	movea.l	#shootoutteam,a0
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(ReadSRAM).l
	movem.l	(sp)+,d0-d7/a0-a6
	addq.b	#1,(shootoutteam).w
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(WriteSRAM).l
	movem.l	(sp)+,d0-d7/a0-a6
	movem.l	(sp)+,a0
	rts

MakeDateString	;a1 = "Month day" for SeasonDay, built in DateStringBuf
	movem.l	d0-d7/a0/a2-a6,-(sp)
	clr.w	d0
	move.b	(SeasonDay).w,d0
	addq.w	#4,d0
	clr.w	d1
	movea.l	#MonthDays,a0
	clr.w	d2
.loop
	move.b	(a0,d1.w),d2
	cmp.w	d2,d0
	ble.w	.1
	addq.w	#1,d1
	sub.w	d2,d0
	subq.w	#1,d0
	bra.s	.loop
.1
	movea.l	#MonthNames,a1
	bra.w	.3
.loop2
	adda.w	(a1),a1
.3
	dbf	d1,.loop2
	move.w	d0,-(sp)
	movea.l	#DateStringBuf,a3
	move.w	(a1),d0
	subq.w	#1,d0
.loop3
	move.b	(a1)+,(a3)+
	dbf	d0,.loop3
	move.w	(sp)+,d0
	addq.w	#1,d0
	cmp.w	#9,d0
	ble.w	.5
	move.w	#3,d1
	bra.w	.6
.5
	move.w	#2,d1
.6
	jsr	(PushNumberWidth).l
	movea.l	#DateStringBuf,a3
	jsr	(appstring).l
	movea.l	a3,a1
	movem.l	(sp)+,d0-d7/a0/a2-a6
	rts

MonthNames	;October through April
	String	'October',$0
	String	'November'
	String	'December'
	String	'January',$0
	String	'February'
	String	'March',$0
	String	'April',$0

DayToDate	;d1 = month, d0 = day for SeasonDay
	movem.l	d2-d7/a0,-(sp)
	clr.w	d0
	move.b	(SeasonDay).w,d0
	addq.w	#4,d0
	clr.w	d1
	movea.l	#MonthDays,a0
	clr.w	d2
.loop
	move.b	(a0,d1.w),d2
	cmp.w	d2,d0
	ble.w	.done
	addq.w	#1,d1
	sub.w	d2,d0
	subq.w	#1,d0
	bra.s	.loop
.done
	movem.l	(sp)+,d2-d7/a0
	rts

DateToDay	;d2 = schedule day of month d1, day d0, clamped to the season
	movem.l	d0-d1/d4,-(sp)
	cmp.b	#6,d1
	ble.w	.0
	clr.w	d1
	cmp.b	#4,d0
	bge.w	.0
	move.b	#4,d0
.0
	cmp.b	#6,d1
	bne.w	.1
	cmp.b	#$D,d0
	ble.w	.1
	move.b	#$D,d0
.1
	movea.l	#MonthDays,a0
	ext.w	d0
	clr.w	d3
	clr.w	d2
.loop
	cmp.w	d1,d2
	bge.w	.3
	move.b	(a0,d2.w),d4
	andi.w	#$FF,d4
	add.w	d4,d3
	addq.w	#1,d3
	addq.w	#1,d2
	bra.s	.loop
.3
	add.b	d3,d0
	subq.b	#4,d0
	move.w	d0,d2
	andi.w	#$FF,d2
	movem.l	(sp)+,d0-d1/d4
	rts

MonthDays	;Days - 1 of October through April, then $FF
	dc.b	$1E,$1D,$1E,$1E,$1B,$1E,$1D,$FF

CountTeamGames	;d1 = number of season games of team d0
	movem.l	d2-d7/a0-a6,-(sp)
	btst	#3,(SeasonFlags).w
	bne.w	.7
	clr.w	d2
	move.b	(SeasonDay).w,d2
	clr.w	d3
	move.b	(SeasonLength).w,d3
	cmp.w	d2,d3
	beq.w	.7
	move.w	(SeasonDay).w,-(sp)
	clr.b	(SeasonDay).w
	bsr.w	FindDayGames
	move.w	(sp)+,(SeasonDay).w
	clr.w	d2
	move.b	(SeasonLength).w,d2
	clr.w	d1
	bra.w	.6
.loop
	clr.w	d3
	move.b	(a0)+,d3
	bra.w	.4
.loop2
	cmp.b	(a0),d0
	beq.w	.2
	cmp.b	1(a0),d0
	bne.w	.3
.2
	addq.w	#1,d1
.3
	addq.w	#2,a0
.4
	cmpa.l	#SeasonScheduleEnd,a0
	blt.w	.5
	movea.l	#SeasonSchedule+1,a0
.5
	dbf	d3,.loop2
.6
	dbf	d2,.loop
.7
	movem.l	(sp)+,d2-d7/a0-a6
	rts

ReadStandings	;Read the 26 teams' standings records (3 bytes: wins, ties, losses) into a0
	movem.l	d0-d7/a0-a6,-(sp)
	move.l	#SRStandings,d0
	btst	#5,(SeasonFlags).w
	beq.w	.0
	move.l	#SRPOStandings,d0
.0
	moveq	#3,d1
	mulu.w	#$1A,d1
	jsr	(ReadSRAM).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

SimScore	;Simulate the score of game a0. A playoff tie gets a random winner
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(rosterscroll).w,-(sp)
	movea.l	#SimGoalsHome,a1
	movea.l	#SimGoalsHomeDef,a2
	bsr.w	SimTeamGoals
	move.b	d3,2(a0)
	movea.l	#SimGoalsAway,a1
	movea.l	#SimGoalsAwayDef,a2
	bsr.w	SimTeamGoals
	move.b	d3,3(a0)
	cmp.b	2(a0),d3
	bne.w	.0
	bsr.w	SimTieBreak
.0
	bsr.w	ScaleSimScore
	btst	#3,(GameFlags).w
	beq.w	.2
	btst	#5,(SeasonFlags).w
	beq.w	.2
	move.b	2(a0),d0
	move.b	3(a0),d1
	cmp.b	d0,d1
	bne.w	.2
	btst	#2,(vcount).w
	beq.w	.1
	addq.b	#1,3(a0)
	bra.w	.2
.1
	addq.b	#1,2(a0)
.2
	move.w	(sp)+,(rosterscroll).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts

SimTieBreak	;On a tie, adjust the home score by -1, 0 or +1
	movea.l	#SimTieTbl,a1
	clr.w	d0
	move.b	(a0),d0
	move.w	d0,-(sp)
	add.w	d0,d0
	add.w	(sp)+,d0
	adda.w	d0,a1
	move.l	a1,-(sp)
	move.w	#2,d0
	clr.w	d7
.loop
	add.b	(a1)+,d7
	dbf	d0,.loop
	move.w	d7,d0
	jsr	(randomd0).l
	move.w	#2,d1
	movea.l	(sp)+,a3
	move.w	#$FFFF,d3
	clr.w	d2
.loop2
	add.b	(a3)+,d2
	cmp.w	d0,d2
	bgt.w	.2
	addq.w	#1,d3
	dbf	d1,.loop2
.2
	move.b	2(a0),d0
	add.b	d3,d0
	bmi.w	.exit
	move.b	d0,2(a0)
.exit
	rts

SimTeamGoals	;d3 = goals from the team's offense weights plus the other team's defense weights
	clr.w	d0
	move.b	(a0),d0
	mulu.w	#$A,d0
	adda.w	d0,a1
	clr.w	d0
	move.b	1(a0),d0
	mulu.w	#$A,d0
	adda.w	d0,a2
	movea.l	#SimWeights,a3
	move.w	#9,d0
	clr.w	d7
.loop
	move.b	(a1)+,(a3)
	move.b	(a3),d6
	add.b	(a2)+,d6
	move.b	d6,(a3)
	add.b	(a3)+,d7
	dbf	d0,.loop
	move.w	d7,d0
	jsr	(randomd0).l
	move.w	#9,d1
	movea.l	#SimWeights,a3
	clr.w	d2
	clr.w	d3
.loop2
	add.b	(a3)+,d2
	cmp.w	d0,d2
	bgt.w	.exit
	addq.w	#1,d3
	dbf	d1,.loop2
.exit
	rts

ScaleSimScore	;Scale the score to the average goals of the human games so far, and keep the winner
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	(TempWord2).w
	move.b	2(a0),d0
	cmp.b	3(a0),d0
	bgt.w	.0
	move.w	#$FFFF,(TempWord2).w
	cmp.b	3(a0),d0
	blt.w	.0
	move.w	#1,(TempWord2).w
.0
	move.l	a0,-(sp)
	move.l	#SRGoalTotal,d0
	moveq	#6,d1
	movea.l	#SeasonGoalSum,a0
	jsr	(ReadSRAM).l
	movea.l	(sp)+,a0
	move.l	(SeasonGoalSum).w,d0
	move.w	(SeasonGameCount).w,d1
	tst.w	d1
	beq.w	.7
	divu.w	d1,d0
	mulu.w	#$64,d0
	divu.w	#$48,d0
	cmp.w	#5,d0
	bge.w	.1
	move.w	#5,d0
.1
	cmp.w	#$5A,d0
	ble.w	.2
	move.w	#$5A,d0
.2
	clr.w	d1
	move.b	2(a0),d1
	mulu.w	d0,d1
	addq.w	#5,d1
	divu.w	#$A,d1
	move.b	d1,2(a0)
	clr.w	d1
	move.b	3(a0),d1
	mulu.w	d0,d1
	addq.w	#5,d1
	divu.w	#$A,d1
	move.b	d1,3(a0)
.keep
	move.b	2(a0),d0
	move.b	3(a0),d1
	tst.w	(TempWord2).w
	beq.w	.6
	bmi.w	.5
	sub.b	d0,d1
	beq.w	.7
	bmi.w	.4
	addq.b	#1,2(a0)
	bra.s	.keep
.4
	addq.b	#1,3(a0)
	bra.s	.keep
.5
	cmp.b	d0,d1
	bgt.w	.7
	addq.b	#1,3(a0)
	bra.s	.keep
.6
	cmp.b	d1,d0
	bgt.w	.7
	addq.b	#1,2(a0)
	bra.s	.keep
.7
	movem.l	(sp)+,d0-d7/a0-a6
	rts
GamesToday	;GAMES TODAY: list the day's games. A toggles human and computer, left and right change the day, start goes on
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(ReadSeasonHeader).l
	btst	#0,(sflags11).w
	beq.w	.0
	bclr	#3,(SeasonFlags).w
	bra.w	.2
.0
	btst	#1,(sflags11).w
	beq.w	.1
	subq.b	#1,(SeasonDay).w
	bra.w	.2
.1
	jsr	(SkipToGameDay).l
	btst	#3,(SeasonFlags).w
	beq.w	.2
	btst	#4,(SeasonFlags).w
	bne.w	GamesTodayDone
.2
	jsr	(BuildSeasonTeamList).l
	move.b	(SeasonDay).w,(GamesTodayDay).w
	move.l	#GamesTodayLogoMap,(screenarg).l
	bsr.w	GamesTodayGfx
	jsr	(PrintGamesToday).l
	jsr	(GamesTodayHelp).l
	bsr.w	GamesTodayLines
	move.w	#$FFFF,(setupdir).w
	move.w	#$18,(palcount).w
	bclr	#2,(disflags).w

GamesTodayLoop	;Draw the list and read the pads
	bsr.w	DrawGamesToday
	bsr.w	ReadGamesTodayPad
	move.w	(SelectedPlayerIdx).w,(setupprevline).w
	tst.w	d1
	bne.w	.1
	move.b	(SeasonDay).w,d0
	cmp.b	(GamesTodayDay).w,d0
	beq.w	.0
	jsr	(ReadSeasonHeader).l
	jsr	(BuildSeasonTeamList).l
.0
	jmp	(Opening2).l
.1
	move.w	#$FFFF,(setupdir).w
	btst	#7,d1
	bne.w	GamesTodayExit
	btst	#2,d1
	bne.w	GamesTodayPrev
	btst	#3,d1
	bne.w	GamesTodayNext
	btst	#1,d1
	beq.w	.2
	bra.w	GamesTodayDown
.2
	btst	#0,d1
	beq.w	.3
	bra.w	GamesTodayUp
.3
	btst	#6,d1
	bne.w	GamesTodayToggle
	bra.w	GamesTodayLoop

GamesTodayLines	;Cursor and scroll lines for the day's game count
	clr.w	(SelectedPlayerIdx).w
	clr.w	(setupprevline).w
	clr.w	(DispAttribCtr).w
	move.w	#3,(setupshown).w
	move.w	#2,(VertLineScrolling).w
	movea.l	#SeasonTeams,a0
	clr.w	d0
	move.b	1(a0),d0
	move.w	d0,(setuplines).w
	cmp.b	#3,d0
	bge.w	.exit
	subq.w	#1,d0
	move.w	d0,(VertLineScrolling).w
.exit
	rts

GamesTodayNext	;Right: the next day with games, up to today
	move.w	#$FFFF,(setupdir).w
	movem.w	d0,-(sp)
	move.b	(SeasonDay).w,d0
	cmp.b	(GamesTodayDay).w,d0
	movem.w	(sp)+,d0
	beq.w	GamesTodayLoop
	move.w	#3,(setupdir).w
	addq.b	#1,(SeasonDay).w
	jsr	(DayHasGames).l
	beq.w	GamesTodayNext
	jsr	(BuildSeasonTeamList).l
	bsr.w	GamesTodayLines
	bra.w	GamesTodayLoop

GamesTodayPrev	;Left: the previous day with games
	move.w	#$FFFF,(setupdir).w
	tst.b	(SeasonDay).w
	beq.w	GamesTodayLoop
	movem.w	d0,-(sp)
	move.b	(SeasonDay).w,d0
	cmp.b	(GamesTodayDay).w,d0
	movem.w	(sp)+,d0
	bne.w	.0
	jsr	(WriteDayGames).l
.0
	move.w	#2,(setupdir).w
	jsr	(PrevSeasonDay).l
	jsr	(DayHasGames).l
	beq.w	GamesTodayPrev
	jsr	(BuildSeasonTeamList).l
	bsr.w	GamesTodayLines
	bra.w	GamesTodayLoop

GamesTodayToggle	;A toggles human and computer on an unplayed game. Bit 0 set is computer
	move.w	#6,(setupdir).w
	movem.l	d0-d1/a0,-(sp)
	move.w	(DispAttribCtr).w,d0
	add.w	(SelectedPlayerIdx).w,d0
	mulu.w	#5,d0
	movea.l	#SeasonTeams+2,a0
	btst	#1,4(a0,d0.w)
	bne.w	.1
	bchg	#0,4(a0,d0.w)
	bra.w	.2
.1
	move.w	#$FFFF,(setupdir).w
.2
	movem.l	(sp)+,d0-d1/a0
	bra.w	GamesTodayLoop

GamesTodayUp	;Cursor up
	move.w	#$FFFF,(setupdir).w
	tst.w	(DispAttribCtr).w
	bne.w	.0
	tst.w	(SelectedPlayerIdx).w
	beq.w	GamesTodayLoop
.0
	move.w	#0,(setupdir).w
	subq.w	#1,(SelectedPlayerIdx).w
	movem.w	d0-d1,-(sp)
	move.w	(DispAttribCtr).w,d1
	add.w	(SelectedPlayerIdx).w,d1
	move.w	(DispAttribCtr).w,d0
	cmp.w	d1,d0
	movem.w	(sp)+,d0-d1
	ble.w	GamesTodayLoop
	addq.w	#1,(SelectedPlayerIdx).w
	subq.w	#1,(DispAttribCtr).w
	subq.w	#1,(VertLineScrolling).w
	bra.w	GamesTodayLoop

GamesTodayDown	;Cursor down
	move.w	#$FFFF,(setupdir).w
	movem.w	d0-d1,-(sp)
	move.w	(setuplines).w,d0
	subq.w	#1,d0
	move.w	(DispAttribCtr).w,d1
	add.w	(SelectedPlayerIdx).w,d1
	cmp.w	d1,d0
	movem.w	(sp)+,d0-d1
	beq.w	GamesTodayLoop
	move.w	#1,(setupdir).w
	addq.w	#1,(SelectedPlayerIdx).w
	movem.w	d0-d1,-(sp)
	move.w	(VertLineScrolling).w,d0
	move.w	(SelectedPlayerIdx).w,d1
	add.w	(DispAttribCtr).w,d1
	cmp.w	d1,d0
	movem.w	(sp)+,d0-d1
	bge.w	GamesTodayLoop
	subq.w	#1,(SelectedPlayerIdx).w
	addq.w	#1,(VertLineScrolling).w
	addq.w	#1,(DispAttribCtr).w
	bra.w	GamesTodayLoop

GamesTodayExit	;Start: save today's games
	jsr	(forceblack).l
	btst	#1,(sflags11).w
	bne.w	.0
	btst	#0,(sflags11).w
	bne.w	.0
	move.b	(SeasonDay).w,d0
	cmp.b	(GamesTodayDay).w,d0
	beq.w	.1
.0
	jsr	(ReadSeasonHeader).l
	jsr	(BuildSeasonTeamList).l
.1
	jsr	(WriteDayGames).l

GamesTodayDone	;Return
	movem.l	(sp)+,d0-d7/a0-a6
	rts

ReadGamesTodayPad	;Wait for a pad press. d1 = 0 after $5460 frames with none
	move.l	#$5460,d6
.wait
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

PrintGamesToday	;GAMES TODAY title
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP1),$9,$2,'GAMES TODAY'
	rts

PrintPreviousDay	;PREVIOUS DAY title
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP1),$8,$2,'PREVIOUS DAY',$0
	rts

DrawGamesToday	;Draw the date, the day's games and the arrows
	movem.l	d0-d7/a0-a6,-(sp)
	cmpi.w	#2,(setupdir).w
	beq.w	.1
	cmpi.w	#3,(setupdir).w
	beq.w	.1
	cmpi.w	#0,(setupdir).w
	beq.w	.0
	cmpi.w	#1,(setupdir).w
	bne.w	.3
.0
	jsr	(printz).l
	String	-TXMAP1,$19,$7,$0
	move.w	#7,d0
	move.w	#$11,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	bra.w	.3
.1
	move.w	#$28,d0
	move.w	#$17,d1
	move.w	#$7FF,d2
	jsr	(printz).l
	String	-TXMAP1,$0,$2,$0
	jsr	(eraser).l
	move.b	(GamesTodayDay).w,d0
	cmp.b	(SeasonDay).w,d0
	beq.w	.2
	bsr.w	PrintPreviousDay
	bra.w	.3
.2
	bsr.w	PrintGamesToday
.3
	move.w	(setuplines).w,d0
	subq.w	#1,d0
	cmp.w	(VertLineScrolling).w,d0
	ble.w	.4
	jsr	(printz).l
	String	-TXMAP1,$3,$17,'}'
	bra.w	.5
.4
	jsr	(printz).l
	String	-TXMAP1,$3,$17,' '
.5
	tst.w	(DispAttribCtr).w
	beq.w	.6
	jsr	(printz).l
	String	-TXMAP1,$3,$8,'{'
	bra.w	.7
.6
	jsr	(printz).l
	String	-TXMAP1,$3,$8,' '
.7
	movea.l	#SeasonTeams,a0
	clr.w	d1
	move.b	1(a0),d3
	beq.w	.13
	subq.w	#1,d3
	mulu.w	#5,d3
	addq.w	#2,d3
	move.w	(DispAttribCtr).w,d0
	mulu.w	#5,d0
	addq.w	#2,d0
	clr.w	d2
.game
	cmp.w	d3,d0
	bgt.w	.13
	jsr	(printz).l
	String	-TXMAP1,$14,$5,$0
	btst	#5,(SeasonFlags).w
	beq.w	.9
	movem.l	d0-d1/a1,-(sp)
	jsr	(printz).l
	String	-TXMAP1,$C,$5,'PLAYOFFS DAY '
	move.w	#2,d1
	clr.w	d0
	move.b	(SeasonDay).w,d0
	addq.w	#1,d0
	jsr	(PushNumberWidth).l
	jsr	(print).l
	movem.l	(sp)+,d0-d1/a1
	bra.w	.10
.9
	movem.l	d0/a1,-(sp)
	jsr	(MakeDateString).l
	movea.l	#DateStringBuf,a1
	move.w	(a1),d0
	subq.w	#2,d0
	lsr.w	#1,d0
	sub.w	d0,(printx).w
	jsr	(print).l
	movem.l	(sp)+,d0/a1
.10
	bsr.w	DrawGameCursor
	jsr	(printz).l
	String	-TXMAP1,$0,$0,$0
	move.w	#$E,(printx).w
	movea.l	#GameRowsTbl2,a1
	move.b	(a1,d2.w),(printy+1).w
	clr.w	d1
	move.b	(a0,d0.w),d1
	bsr.w	DrawGameLogo
	move.w	#$E,(printx).w
	movea.l	#GameRowsTbl1,a1
	move.b	(a1,d2.w),(printy+1).w
	clr.w	d1
	move.b	1(a0,d0.w),d1
	bsr.w	DrawGameLogo
	movea.l	#GameRowsTbl4,a1
	move.b	(a1,d2.w),(printy+1).w
	move.w	#$13,(printx).w
	jsr	(printz).l
	String	'AT'
	btst	#0,4(a0,d0.w)
	bne.w	.11
	bsr.w	DrawHumanMark
	bra.w	.12
.11
	bsr.w	DrawCompMark
.12
	bsr.w	PrintGameScores
	addq.w	#5,d0
	addq.w	#1,d2
	cmp.w	#3,d2
	bge.w	.13
	bra.w	.game
.13
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PrintGameScores	;Print both scores of a played game line
	btst	#1,4(a0,d0.w)
	beq.w	.exit
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d5
	move.b	2(a0,d0.w),d5
	movea.l	#GameRowsTbl6,a1
	bsr.w	PrintGameScore
	move.b	3(a0,d0.w),d5
	movea.l	#GameRowsTbl5,a1
	bsr.w	PrintGameScore
	movem.l	(sp)+,d0-d7/a0-a6
.exit
	rts

PrintGameScore	;Print one score
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	-TXMAP1,$1C,$0,$0
	move.b	(a1,d2.w),(printy+1).w
	move.w	d5,d0
	moveq	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

DrawGameCursor	;Erase the cursor on the previous line and draw it on the current line
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	-TXMAP1,$8,$0,$0
	movea.l	#(GameRowsTbl4+3),a0
	move.w	(setupprevline).w,d1
	move.b	(a0,d1.w),(printy+1).w
	move.w	#2,d0
	move.w	#3,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	jsr	(printz).l
	String	-TXMAP1,$8,$0,$0
	movea.l	#(GameRowsTbl4+3),a0
	move.w	(SelectedPlayerIdx).w,d1
	move.b	(a0,d1.w),(printy+1).w
	move.w	(gamestoday1chars).w,d4
	movea.l	#GamesTodayMap1,a0
	clr.w	d0
	clr.w	d1
	movea.l	a0,a1
	adda.l	(a0),a0
	adda.l	4(a1),a1
	movea.l	#ZeroLong,a2
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#0,d5
	jsr	(dobitmap).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

DrawHumanMark	;A human game: the pad icon while it is unplayed, else H by the score
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#1,4(a0,d0.w)
	bne.w	.0
	jsr	(printz).l
	String	-TXMAP1,$B,$0,$0
	movea.l	#GameRowsTbl3,a1
	move.b	(a1,d2.w),(printy+1).w
	clr.w	d0
	clr.w	d1
	move.w	(padcursorchars).w,d4
	movea.l	#GamesTodayMap2,a0
	movea.l	a0,a1
	adda.l	(a0),a0
	adda.l	4(a1),a1
	movea.l	#ZeroLong,a2
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#0,d5
	jsr	(dobitmap).l
	bra.w	.1
.0
	jsr	(printz).l
	String	-TXMAP1,$1A,$0,$0
	movea.l	#GameRowsTbl4,a1
	move.b	(a1,d2.w),(printy+1).w
	movea.l	#HumanText,a1
	jsr	(print).l
	move.w	#$B,(printx).w
	subq.w	#1,(printy).w
	move.w	#$7FF,d2
	move.w	#3,d0
	move.w	#3,d1
	jsr	(eraser).l
.1
	movem.l	(sp)+,d0-d7/a0-a6
	rts

CompText	;C
	String	'C',$0

HumanText	;H
	String	'H',$0

DrawCompMark	;A computer game: the computer icon while it is unplayed, else C by the score
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#1,4(a0,d0.w)
	bne.w	.0
	jsr	(printz).l
	String	-TXMAP1,$0,$0,$0
	move.w	#$B,(printx).w
	movea.l	#GameRowsTbl3,a1
	move.b	(a1,d2.w),(printy+1).w
	clr.w	d0
	clr.w	d1
	move.w	(gamestoday3chars).w,d4
	movea.l	#GamesTodayMap3,a0
	movea.l	a0,a1
	adda.l	(a0),a0
	adda.l	4(a1),a1
	movea.l	#ZeroLong,a2
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#0,d5
	jsr	(dobitmap).l
	bra.w	.1
.0
	jsr	(printz).l
	String	-TXMAP1,$1A,$0,$0
	movea.l	#GameRowsTbl4,a1
	move.b	(a1,d2.w),(printy+1).w
	movea.l	#CompText,a1
	jsr	(print).l
	move.w	#$B,(printx).w
	subq.w	#1,(printy).w
	move.w	#$7FF,d2
	move.w	#3,d0
	move.w	#3,d1
	jsr	(eraser).l
.1
	movem.l	(sp)+,d0-d7/a0-a6
	rts

DrawGameLogo	;Draw team d1's logo on a game line. printx and printy are the screen position
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

GameRowsTbl1	;Screen row of each game line
	dc.b	7,$D,$13

GameRowsTbl2
	dc.b	$A,$10,$16

GameRowsTbl3
	dc.b	8,$E,$14

GameRowsTbl4
	dc.b	9,$F,$15,8,$E,$14

GameRowsTbl5
	dc.b	8,$E,$14

GameRowsTbl6
	dc.b	$A,$10,$16,$FF

GamesTodayGfx	;Games today video setup and graphics
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
	dc.b	$0B,$83,$44,$67,$89,$AB,$CD,$EF
	move.w	d4,(smallfont2chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$83,$4C,$67,$89,$AB,$CD,$EF
	move.l	#SmallFontMap,(smallfontptr).l
	move.w	d4,(BigFontChars).w
	movea.l	#BigFontMap+8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,(gamestoday1chars).w
	movea.l	#GamesTodayMap1+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$97,$54,$CF,$F9,$AB,$CD,$E1
	move.w	d4,(padcursorchars).w
	movea.l	#GamesTodayMap2+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$97,$54,$CF,$F9,$AB,$CD,$E1
	move.w	d4,(gamestoday3chars).w
	movea.l	#GamesTodayMap3+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$97,$54,$CF,$F9,$AB,$CD,$E1
	move.w	d4,(teamblocksmapptr).w
	movea.l	#Teamblocksmap+8,a2
	jsr	(DecompressGraphicsPlain).l
	jsr	(printz).l
	String	-TXMAP2,$0,$0,$0
	movea.l	(screenarg).w,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$28,d2
	moveq	#$1C,d3
	moveq	#3,d5
	jsr	(dobitmap).l
	rts

GamesTodayHelp	;Games today help line
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(smallfontchars).w,-(sp)
	move.w	(smallfont2chars).w,(smallfontchars).w
	jsr	(printz).l
	String	-TXMAP1,$2,$19,'A=Human/Computer',-TXMAP1,$19,$19,'[] Change day',$0
	move.w	(sp)+,(smallfontchars).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts

SeasonOptions	;SEASON OPTIONS. An item runs through the jump list for this part of the season
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	(SelectedPlayerIdx).w
	clr.w	(DispAttribCtr).w
	move.w	#9,(VertLineScrolling).w
.screen
	bsr.w	SeasonOptionsGfx
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP1),$7,$2,'SEASON OPTIONS',$0
	move.w	#$18,(palcount).w
	bclr	#2,(disflags).w
.draw
	bsr.w	DrawSeasonMenu
.input
	bsr.w	ReadSeasonMenuPad
	tst.w	d1
	bne.w	.keys
	jmp	(Opening2).l
.keys
	btst	#1,d1
	beq.w	.9
	move.w	(SelectedPlayerIdx).w,d0
	addq.w	#1,d0
	add.w	(DispAttribCtr).w,d0
	bsr.w	GetSeasonMenu
	tst.w	(a1)
	beq.s	.input
	move.w	(SelectedPlayerIdx).w,d0
	cmp.w	#$A,d0
	blt.w	.7
	addq.w	#1,(DispAttribCtr).w
	addq.w	#1,(VertLineScrolling).w
	bra.w	.8
.7
	addq.w	#1,(SelectedPlayerIdx).w
.8
	bra.s	.draw
.9
	btst	#0,d1
	beq.w	.13
	tst.w	(SelectedPlayerIdx).w
	bne.w	.10
	tst.w	(DispAttribCtr).w
	beq.s	.input
.10
	tst.w	(SelectedPlayerIdx).w
	bne.w	.11
	subq.w	#1,(DispAttribCtr).w
	subq.w	#1,(VertLineScrolling).w
	bra.w	.12
.11
	subq.w	#1,(SelectedPlayerIdx).w
.12
	bra.w	.draw
.13
	btst	#7,d1
	beq.w	.14
	bra.w	.select
.14
	btst	#5,d1
	beq.w	.input
.select
	move.w	(SelectedPlayerIdx).w,d0
	add.w	(DispAttribCtr).w,d0
	asl.w	#2,d0
	movea.l	#SeasonMenuJumps,a0
	btst	#5,(SeasonFlags).w
	beq.w	.16
	movea.l	#PlayoffMenuJumps,a0
.16
	btst	#5,(sflags12).w
	beq.w	.17
	movea.l	#SeasonEndMenuJumps,a0
.17
	movea.l	(a0,d0.w),a0
	move.w	(SelectedPlayerIdx).w,-(sp)
	move.w	(DispAttribCtr).w,-(sp)
	move.w	(VertLineScrolling).w,-(sp)
	jsr	(a0)
	beq.w	.play
	bmi.w	.cancel
	bra.w	.back
.play
	addq.w	#6,sp
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.back
	move.w	(sp)+,(VertLineScrolling).w
	move.w	(sp)+,(DispAttribCtr).w
	move.w	(sp)+,(SelectedPlayerIdx).w
	bra.w	.screen
.cancel
	move.w	(sp)+,(VertLineScrolling).w
	move.w	(sp)+,(DispAttribCtr).w
	move.w	(sp)+,(SelectedPlayerIdx).w
	bra.w	.draw

SeasonMenuJumps	;Regular season menu
	dc.l	MenuPlayGames,MenuPlayUntil,MenuStandings,MenuCalendar,MenuGamesToday
	dc.l	MenuLeagueLeaders,MenuTeamStats,MenuPlayerStats,MenuHighlights,MenuEndSeason

SeasonEndMenuJumps	;Menu after the regular season
	dc.l	MenuPlayGames,MenuStandings,MenuCalendar,MenuGamesToday,MenuLeagueLeaders
	dc.l	MenuTeamStats,MenuPlayerStats

PlayoffMenuJumps	;Playoff menu
	dc.l	MenuPlayGames,MenuGamesToday,MenuTeamStats,MenuPlayerStats,MenuPlayoffTeamStats
	dc.l	MenuPlayoffPlayerStats,MenuPlayoffTree

MenuEndSeason	;End the regular season after today
	move.b	(SeasonDay).w,(SeasonLength).w
	addq.b	#1,(SeasonLength).w
	jsr	(WriteSeasonHeader).l
	bra.w	MenuStay

MenuLeagueLeaders	;League Leaders
	jsr	(LeagueLeadersScreen).l
	bra.w	MenuStay

MenuPlayoffTeamStats	;Playoff Team Stats (sflags11 bit 3)
	bset	#3,(sflags11).w
	jsr	(SeasonTeamStats).l
	bclr	#3,(sflags11).w
	bra.w	MenuStay

MenuTeamStats	;Team Stats
	jsr	(SeasonTeamStats).l
	bra.w	MenuStay

MenuPlayoffPlayerStats	;Playoff Player Stats (sflags11 bit 3)
	bset	#3,(sflags11).w
	jsr	(SeasonPlayerStats).l
	bclr	#3,(sflags11).w
	bra.w	MenuStay

MenuPlayerStats	;Player Stats
	jsr	(SeasonPlayerStats).l
	bra.w	MenuStay

MenuHighlights	;Highlights
	jsr	(HighlightsScreen).l
	bra.w	MenuStay

MenuGamesToday	;Games Today
	jsr	(GamesToday).l
	bra.w	MenuStay

MenuStandings	;NHL Standings
	jsr	(StandingsScreen).l
	bra.w	MenuStay

MenuPlayoffTree	;Playoff tree from save RAM, then the existing PlayoffScreen
	jsr	(PlayoffTreeScreen).l
	bra.w	MenuStay

MenuStay	;d0 = 1: stay in the menu
	move.w	#1,d0
	rts

MenuCalendar	;Team schedule calendar
	jsr	(CalendarScreen).l
	bra.s	MenuStay

MenuPlayGames	;Play the computer games. d0 = 0
	clr.b	(AutoplayDay).w
	jsr	(forceblack).l
	clr.w	d0
	rts

MenuPlayUntil	;Pick a day. A changes the month, B the day, C cancels, start autoplays to that day
	bsr.w	BuildSeasonTeamList
	st	(seasonteamsel).w
	bsr.w	NextSeasonTeam
	tst.w	(seasonteamsel).w
	bmi.w	.ask
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$5,$A,$0
	move.w	#$1E,d0
	move.w	#$E,d1
	jsr	(Framer).l
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$7,$C,$0
	jsr	(printsmallz).l
	String	CC_SetFont,$2,'Please complete human',CC_SetX,$7,CC_SetY,$D,'controlled games before'
	jsr	(printsmallz).l
	dc.w	$3C
	dc.b	$FD,$7,$FA,$1,$F9,$2,'selecting autoplay.',$FD
	dc.b	$7,$FA,$2,$F9,$2,'Press START to continue.',$F9,$0
	dc.b	$0
.loop
	move.w	(vcount).w,d0
.loop2
	cmp.w	(vcount).w,d0
	beq.s	.loop2
	jsr	(orjoy).l
	btst	#7,d1
	beq.s	.loop
	jmp	(AutoplayCancel).l
.ask
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$5,$A,$0
	move.w	#$1E,d0
	move.w	#$E,d1
	jsr	(Framer).l
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$7,$C,$0
	jsr	(printsmallz).l
	String	CC_SetFont,$2,'Autoplay games until this',CC_SetX,$7,CC_SetY,$D,'day...',CC_SetFont,$0,$0
	jsr	(printsmallz).l
	String	CC_SetX,$7,CC_SetY,$12,CC_SetFont,$2,'Press A to change Month',$0
	jsr	(printsmallz).l
	String	CC_SetX,$7,CC_SetY,$13,CC_SetFont,$2,'Press B to change Day',$0
	jsr	(printsmallz).l
	String	CC_SetX,$7,CC_SetY,$14,CC_SetFont,$2,'Press C to cancel',$0
	jsr	(printsmallz).l
	String	CC_SetX,$7,CC_SetY,$15,CC_SetFont,$2,'Press Start to autoplay',CC_SetFont,$0,$0
	move.b	(SeasonDay).w,d0
	addq.b	#1,d0
	move.b	d0,(AutoplayDay).w
	bsr.w	PrintAutoplayDay
.3
	move.w	(vcount).w,d0
.input
	cmp.w	(vcount).w,d0
	beq.s	.input
	jsr	(orjoy).l
	btst	#5,d1
	bne.w	AutoplayCancel
	btst	#6,d1
	bne.w	.month
	btst	#4,d1
	bne.w	.day
	btst	#7,d1
	bne.w	AutoplayMessage
	bra.s	.input
.day
	move.b	(SeasonDay).w,-(sp)
	move.b	(AutoplayDay).w,(SeasonDay).w
	jsr	(DayToDate).l
	move.b	(sp)+,(SeasonDay).w
.nextday
	movea.l	#MonthDays,a0
	move.b	(a0,d1.w),d2
	addq.b	#1,d0
	cmp.b	d2,d0
	ble.w	.7
	clr.w	d0
	tst.w	d1
	bne.w	.7
	move.w	#5,d0
.7
	cmp.w	#6,d1
	bne.w	.8
	cmp.w	#$E,d0
	ble.w	.8
	clr.w	d0
.8
	cmp.w	#6,d1
	bne.w	.9
	cmp.w	#$E,d0
	bne.w	.9
	move.w	#$C0,d2
	bra.w	.10
.9
	jsr	(DateToDay).l
.10
	move.b	(SeasonDay).w,d5
	andi.w	#$FF,d5
	cmp.w	d5,d2
	ble.s	.nextday
	move.b	d2,(AutoplayDay).w
	bsr.w	PrintAutoplayDay
	bra.w	.input
.month
	move.b	(SeasonDay).w,-(sp)
	jsr	(DayToDate).l
	cmp.w	#6,d1
	bne.w	.12
	move.b	(sp)+,(SeasonDay).w
	bra.w	.input
.12
	move.b	(AutoplayDay).w,(SeasonDay).w
	jsr	(DayToDate).l
	move.b	(sp)+,(SeasonDay).w
	addq.b	#1,d1
.nextmonth
	jsr	(DateToDay).l
	move.b	(SeasonDay).w,d4
	andi.w	#$FF,d4
	cmp.w	d4,d2
	ble.w	.14
	move.b	d2,(AutoplayDay).w
	bsr.w	PrintAutoplayDay
	bra.w	.input
.14
	move.b	(SeasonDay).w,-(sp)
	addq.b	#1,d4
	move.b	d4,(SeasonDay).w
	jsr	(DayToDate).l
	move.b	(sp)+,(SeasonDay).w
	bra.s	.nextmonth

AutoplayCancel	;Cancel: the target day is today, the window is erased, d0 = -1
	move.b	(SeasonDay).w,(AutoplayDay).w
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$5,$A,$0
	move.w	#$7FF,d2
	move.w	#$1E,d0
	move.w	#$E,d1
	jsr	(eraser).l
	move.w	#$FFFF,d0
	rts

AutoplayMessage	;The autoplay warning. d0 = 0
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$5,$A,$0
	move.w	#$1E,d0
	move.w	#$E,d1
	jsr	(Framer).l
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$7,$C,$0
	jsr	(printsmallz).l
	dc.w	$46
	dc.b	$F9,$2,$FA,$3,'AUTOPLAYING GAMES.',$FA,$2,$FD
	dc.b	$7,'DO NOT PRESS RESET !!',$FA,$2,$FD,$7,'Please wait...',$F9
	dc.b	$0,$0
	clr.w	d0
	rts

PrintAutoplayDay	;Print the autoplay date
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$A,$F,$0
	move.w	(printx).w,-(sp)
	jsr	(printsmallz).l
	String	CC_SetFont,$2,'               ',$0
	move.w	(sp)+,(printx).w
	move.b	(SeasonDay).w,-(sp)
	move.b	(AutoplayDay).w,(SeasonDay).w
	jsr	(MakeDateString).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	CC_SetFont,$0
	move.b	(sp)+,(SeasonDay).w
	rts

ReadSeasonMenuPad	;Wait for a pad press. The frame count resets, so the menu does not time out
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

DrawSeasonMenu	;Draw the season menu items
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d1
	jsr	(printz).l
	String	-TXMAP1,$0,$7,$0
.loop
	move.w	d1,d0
	add.w	(DispAttribCtr).w,d0
	bsr.w	GetSeasonMenu
	tst.w	(a1)
	beq.w	.3
	move.w	(a1),d2
	subq.w	#2,d2
	lsr.w	#1,d2
	subi.w	#$14,d2
	neg.w	d2
	move.w	d2,(printx).w
	cmp.w	(SelectedPlayerIdx).w,d1
	beq.w	.1
	jsr	(print).l
	bra.w	.2
.1
	move.w	(smallfontchars).w,-(sp)
	move.w	(smallfont2chars).w,(smallfontchars).w
	jsr	(print).l
	move.w	(sp)+,(smallfontchars).w
.2
	addq.w	#1,d1
	addq.w	#2,(printy).w
	cmp.w	#$A,d1
	blt.s	.loop
.3
	movem.l	(sp)+,d0-d7/a0-a6
	rts

GetSeasonMenu	;a1 = item d0 of the menu for this part of the season
	movem.w	d0,-(sp)
	movea.l	#SeasonMenuText,a1
	btst	#5,(SeasonFlags).w
	beq.w	.0
	movea.l	#PlayoffMenuText,a1
.0
	btst	#5,(sflags12).w
	beq.w	.2
	movea.l	#SeasonEndMenuText,a1
	bra.w	.2
.loop
	adda.w	(a1),a1
	tst.w	(a1)
	beq.w	.3
.2
	dbf	d0,.loop
.3
	movem.w	(sp)+,d0
	rts

SeasonMenuText	;Regular season menu
	String	'      Play Games      '
	String	'   Play Until A Day   '
	String	'    NHL Standings     '
	String	'Team Schedule Calendar'
	String	'     Games Today      '
	String	'    League Leaders    '
	String	'      Team Stats      '
	String	'     Player Stats     '
	String	'      Highlights      '
	String	'End Season After Today'
	dc.w	0

SeasonEndMenuText	;Menu after the regular season
	String	'    On To Playoffs    '
	String	'    NHL Standings     '
	String	'Team Schedule Calendar'
	String	'     Games Today      '
	String	'    League Leaders    '
	String	'      Team Stats      '
	String	'     Player Stats     '
	dc.w	0

PlayoffMenuText	;Playoff menu
	String	'      Play Games      '
	String	'     Games Today      '
	String	'      Team Stats      '
	String	'     Player Stats     '
	String	'  Playoff Team Stats  '
	String	' Playoff Player Stats '
	String	'     Playoff Tree     '
	dc.w	0

SeasonOptionsGfx	;Season options video setup and graphics
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
	dc.b	$0B,$83,$44,$67,$89,$AB,$CD,$EF
	move.w	d4,(smallfont2chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$83,$4C,$67,$89,$AB,$CD,$EF
	move.w	d4,(smallfont3chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$BB,$83,$44,$67,$89,$AB,$CD,$EF
	move.l	#SmallFontMap,(smallfontptr).l
	move.w	d4,(BigFontChars).w
	movea.l	#BigFontMap+8,a2
	jsr	(DecompressGraphicsPlain).l
	movea.l	#FramerMap+8,a2
	move.l	#FramerMap,(framermapptr).l
	move.w	d4,(framercset).w
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$01,$23,$45,$67,$89,$AB,$CD,$EF
	jsr	(printz).l
	String	-TXMAP2,$0,$0,$0
	movea.l	#ControllerBgMap,a0
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
	move.w	d4,(optbgchars).w
	rts

	include	simgame94.asm
	include	seasonstandcal94.asm
	include	seasonstats94.asm

ZeroLong	;A zero word: dobitmap transfers no extra tiles
	dc.l	0

SimGoalsHome	;26 teams, 10 weights each: home offense
	dc.b	3,3,$F,$A,5,4,2,0,0,0
	dc.b	3,4,9,6,3,7,7,2,1,0
	dc.b	1,4,$B,8,7,5,5,1,0,0
	dc.b	1,3,7,$A,$A,5,2,2,1,1
	dc.b	1,4,$B,9,8,5,3,0,0,1
	dc.b	2,4,8,5,$E,3,3,1,1,1
	dc.b	1,2,8,9,2,7,6,2,2,3
	dc.b	0,6,7,$B,5,6,5,2,0,0
	dc.b	0,7,$F,$A,5,4,0,0,1,0
	dc.b	2,8,9,8,8,2,4,1,0,0
	dc.b	2,3,6,8,7,4,6,2,2,2
	dc.b	0,4,6,$C,8,7,0,2,1,2
	dc.b	2,2,$A,3,9,8,3,5,0,0
	dc.b	2,5,7,5,7,$B,4,1,0,0
	dc.b	1,3,6,$E,6,8,4,0,0,0
	dc.b	4,$D,$A,5,3,4,3,0,0,0
	dc.b	1,4,8,8,$A,4,3,0,3,1
	dc.b	0,1,$B,$A,8,5,3,2,1,1
	dc.b	2,5,9,6,4,8,4,2,2,0
	dc.b	0,9,7,9,$A,1,3,1,1,1
	dc.b	1,0,5,$F,9,5,5,2,0,0
	dc.b	5,8,4,$A,$E,1,0,0,0,0
	dc.b	4,3,5,8,$A,4,5,3,0,0
	dc.b	0,5,9,$D,8,3,4,0,0,0
	dc.b	2,4,$B,$D,5,2,5,0,0,0
	dc.b	4,4,6,$B,8,3,3,1,1,1

SimGoalsAwayDef	;26 teams, 10 weights each: away defense
	dc.b	6,5,9,$A,5,2,4,1,0,0
	dc.b	2,6,6,$A,8,5,3,1,1,0
	dc.b	3,4,4,$F,4,6,3,3,0,0
	dc.b	0,3,9,$A,$B,4,4,1,0,0
	dc.b	2,8,8,$E,4,3,1,2,0,0
	dc.b	3,2,$C,$A,3,6,4,1,0,1
	dc.b	0,2,5,$A,$B,4,6,2,1,1
	dc.b	1,$B,8,8,9,4,0,1,0,0
	dc.b	1,6,$A,$F,4,5,1,0,0,0
	dc.b	3,7,$E,9,5,2,2,0,0,0
	dc.b	4,4,$A,9,8,4,2,1,0,0
	dc.b	3,5,8,$C,8,4,0,1,1,0
	dc.b	0,9,8,8,2,5,7,2,1,0
	dc.b	1,7,5,$E,6,6,1,1,1,0
	dc.b	0,6,8,5,$D,7,0,2,1,0
	dc.b	4,8,$F,6,3,3,1,2,0,0
	dc.b	4,2,8,9,9,5,4,0,0,1
	dc.b	0,4,7,$F,$A,2,3,1,0,0
	dc.b	3,7,$A,8,6,6,1,1,1,0
	dc.b	3,4,$F,9,6,3,0,1,1,0
	dc.b	4,7,9,$D,5,3,0,0,0,1
	dc.b	3,9,3,$C,$A,4,1,0,0,0
	dc.b	1,3,$B,$D,6,4,4,0,0,0
	dc.b	1,5,7,9,9,5,4,1,1,0
	dc.b	4,9,7,7,7,5,1,0,1,1
	dc.b	1,5,8,7,$D,5,3,0,0,0

SimGoalsAway	;26 teams, 10 weights each: away offense
	dc.b	1,7,7,$C,7,5,2,1,0,0
	dc.b	1,6,8,$10,6,3,0,0,2,0
	dc.b	5,$A,6,$A,3,5,3,0,0,0
	dc.b	4,4,$D,7,7,5,2,0,0,0
	dc.b	4,8,7,6,7,5,4,0,0,1
	dc.b	4,6,8,$C,5,2,4,1,0,0
	dc.b	3,6,9,$A,7,3,3,1,0,0
	dc.b	1,3,6,$E,6,7,4,1,0,0
	dc.b	1,8,$B,$A,7,4,0,1,0,0
	dc.b	3,3,7,$F,7,4,2,1,0,0
	dc.b	2,5,7,6,7,9,5,0,1,0
	dc.b	2,7,$B,$A,6,5,1,0,0,0
	dc.b	4,7,$C,$A,7,2,0,0,0,0
	dc.b	4,4,$C,7,9,5,1,0,0,0
	dc.b	5,7,9,9,8,1,2,1,0,0
	dc.b	0,4,2,6,$B,7,5,4,2,1
	dc.b	1,2,8,$D,8,7,0,2,0,1
	dc.b	1,6,$C,9,6,4,1,2,0,1
	dc.b	1,5,7,7,$C,5,5,0,0,0
	dc.b	3,4,$B,$B,6,0,4,0,2,1
	dc.b	0,7,8,7,$A,8,2,0,0,0
	dc.b	1,5,$A,$D,7,3,2,1,0,0
	dc.b	1,8,9,$E,6,2,1,1,0,0
	dc.b	2,6,6,$C,7,4,3,1,1,0
	dc.b	2,4,8,9,6,5,0,6,2,0
	dc.b	1,6,$A,$B,7,2,4,1,0,0

SimGoalsHomeDef	;26 teams, 10 weights each: home defense
	dc.b	2,6,9,9,$A,5,1,0,0,0
	dc.b	4,7,6,$B,3,5,4,2,0,0
	dc.b	4,1,$10,$C,6,1,1,1,0,0
	dc.b	1,6,6,$C,9,1,5,1,1,0
	dc.b	3,6,$B,9,7,5,1,0,0,0
	dc.b	1,2,$A,$B,9,6,1,0,0,2
	dc.b	1,5,4,$B,$B,3,5,0,1,1
	dc.b	0,3,6,7,$F,5,5,1,0,0
	dc.b	1,8,$A,9,$A,2,1,1,0,0
	dc.b	0,6,9,3,9,6,6,1,1,1
	dc.b	0,1,5,$A,$C,5,5,2,2,0
	dc.b	5,6,$A,5,3,7,2,0,2,2
	dc.b	1,6,$D,$C,4,1,4,0,1,0
	dc.b	1,3,7,$A,$A,7,2,2,0,0
	dc.b	3,5,8,$D,8,2,3,0,0,0
	dc.b	0,1,4,5,8,$A,7,2,3,2
	dc.b	2,1,6,$A,7,8,5,1,1,1
	dc.b	2,4,7,$A,7,3,2,5,1,1
	dc.b	2,1,$D,6,7,9,4,1,0,0
	dc.b	0,6,$B,$B,4,6,3,1,0,0
	dc.b	1,7,9,8,7,2,3,1,1,3
	dc.b	4,7,$B,6,3,5,3,1,2,0
	dc.b	2,6,6,$C,8,6,2,0,0,0
	dc.b	1,5,$A,$A,5,5,2,3,1,0
	dc.b	0,2,4,7,7,8,9,4,0,1
	dc.b	3,7,9,7,4,3,6,2,1,0

SimTieTbl	;Tie break weights, 3 a team
	dc.b	6,4,0
	dc.b	3,7,5
	dc.b	4,$A,4
	dc.b	4,$B,4
	dc.b	3,$C,1
	dc.b	0,$A,0
	dc.b	0,9,2
	dc.b	4,8,5
	dc.b	6,4,0
	dc.b	9,6,3
	dc.b	1,$A,2
	dc.b	3,6,5
	dc.b	0,7,4
	dc.b	3,7,3
	dc.b	4,$B,2
	dc.b	6,4,0
	dc.b	2,$B,4
	dc.b	0,7,3
	dc.b	1,$A,4
	dc.b	5,2,3
	dc.b	4,$B,2
	dc.b	4,7,3
	dc.b	1,$B,1
	dc.b	0,9,1
	dc.b	2,7,2
	dc.b	2,7,2

GamesTodayLogoMap
	incbin	..\Extracted\NHL94\Season\GamesTodayLogoMap.map.jim

GamesTodayMap1
	incbin	..\Extracted\NHL94\Season\GamesTodayMap1.map.jim

GamesTodayMap2
	incbin	..\Extracted\NHL94\Season\GamesTodayMap2.map.jim

GamesTodayMap3
	incbin	..\Extracted\NHL94\Season\GamesTodayMap3.map.jim
