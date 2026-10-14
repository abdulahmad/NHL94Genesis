;	New in 95: season setup and the season header. New Season shows this screen, stores the
;	header, and leaves the traded rosters and created players in the battery.

SeasonMain	;While GameFlags bit 3 is set. Bit 4 is a new season: the setup screen, a clear of the
	;results, and the header. A season already in progress waits for the day loop
	btst	#3,(GameFlags).w
	beq.w	.exit
	btst	#4,(GameFlags).w
	beq.w	.exit
	jsr	(SeasonSetup).l
	jsr	(ClearSeasonData).l
	bsr.w	PickSeasonStartDay
	bclr	#4,(GameFlags).w
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

ReadPlayoffSchedule	;The playoff schedule copy waits for the playoff chunk
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
