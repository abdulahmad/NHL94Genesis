;	Standings and team schedule calendar (ported from NHL 95 season95.asm).

PrintListItem	;printz String d0 of the list a1
	jsr	(AdvanceStringPtr).l
	jmp	(print).l

CalendarScreen	;CALENDAR (team schedule): {} change team, [] change month, start exits
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	(CalTeam).w
	clr.w	(CalMonthIdx).w
	clr.w	(CalDay).w
	bsr.w	CountSeasonMonths
	bsr.w	CalendarGfx
	jsr	(printbigz).l
	String	-TXMAP1,$C,$2,'CALENDAR',$0
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$1,$7,$0
	jsr	(printsmallz).l
	dc.w	$38	;String length
	dc.b	$F9,$1,'[ ]',$FD,$1,$FA,$1,'= Change'
	dc.b	$FD,$1,$FA,$1,'Month',$FD,$1,$FA
	dc.b	$2,'{ }',$FD,$1,$FA,$1,'= Change',$FD
	dc.b	$1,$FA,$1,'Team',$0
	jsr	(printsmallz).l
	String	CC_SetX,$1,CC_SetY,$15,'START',CC_SetX,$1,CC_AddY,$1,'= Exit',CC_SetFont,$0,$0
	move.w	#$18,(palcount).w
	bclr	#2,(disflags).w
.draw
	bsr.w	CalendarBg
	bsr.w	DrawCalendar
.input
	bsr.w	ReadCalendarPad
	tst.w	d1
	beq.w	.nopad
	btst	#7,d1
	bne.w	.done
	btst	#2,d1
	beq.w	.2
	tst.w	(CalMonthIdx).w
	beq.s	.input
	subq.w	#1,(CalMonthIdx).w
	bra.s	.draw
.2
	btst	#3,d1
	beq.w	.3
	move.w	(CalMonths).w,d0
	cmp.w	(CalMonthIdx).w,d0
	ble.s	.input
	addq.w	#1,(CalMonthIdx).w
	bra.s	.draw
.3
	btst	#1,d1
	beq.w	.4
	move.w	(CalTeam).w,d0
	subq.w	#1,d0
	bpl.w	.team
	move.w	#$19,d0
	bra.w	.team
.4
	btst	#0,d1
	beq.s	.input
	move.w	(CalTeam).w,d0
	addq.w	#1,d0
	cmp.w	#$1A,d0
	blt.w	.team
	clr.w	d0
.team
	move.w	d0,(CalTeam).w
	bra.s	.draw
.nopad
	jmp	(Opening2).l
.done
	movem.l	(sp)+,d0-d7/a0-a6
	rts

ReadCalendarPad	;As ReadAnyPad
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

CalendarGfx	;Calendar screen video set up and graphics
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
	dc.b	$0B,$83,$44,$67,$89,$AB,$CD,$EF	;remap table
	move.l	#SmallFontMap,(smallfontptr).l
	move.w	d4,(smallfont2chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$83,$4C,$67,$89,$AB,$CD,$EF	;remap table
	move.w	d4,(BigFontChars).w
	movea.l	#BigFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$01,$23,$45,$67,$89,$AB,$CD,$EF	;remap table
	move.w	d4,(teamblocksmapptr).w
	movea.l	#Teamblocksmap+8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,(padiconchars1).w
	movea.l	#CalOpponentMap+8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,(padiconchars2).w
	movea.l	#CalDayMap+8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,(padiconchars3).w
	movea.l	#CalMonthMap+8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,(padiconchars4).w
	movea.l	#CalCheckMap,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,(calresultchars).w
	movea.l	#CalResultMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$01,$21,$23,$45,$67,$89,$AB,$CD	;remap table
	move.w	d4,(calbgchars).w
	jsr	(printz).l
	String	-TXMAP2,$0,$0,$0
	movea.l	#CalendarBgMap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$28,d2
	moveq	#$1C,d3
	moveq	#7,d5
	jsr	(dobitmap).l
	rts

CountSeasonMonths	;CalMonths = last month of the season
	clr.w	d0
	movea.l	#MonthDays,a0
	clr.w	d1
	move.b	(SeasonLength).w,d1
	addq.w	#4,d1
.loop
	clr.w	d2
	move.b	(a0,d0.w),d2
	addq.w	#1,d2
	sub.w	d2,d1
	bmi.w	.1
	beq.w	.1
	addq.w	#1,d0
	bra.s	.loop
.1
	move.w	d0,(CalMonths).w
	rts

DrawCalendar	;Draw the month of CalTeam: day numbers, opponents, results
	move.w	#$16,d0
	move.w	#$16,d1
	move.w	#$7FF,d2
	jsr	(printz).l
	String	-TXMAP1,$9,$5,$0
	jsr	(eraser).l
	bsr.w	DrawCalendarTeam
	bsr.w	DrawCalendarMonth
	bsr.w	CalendarFirstDay
	bsr.w	CalendarFirstX
	clr.w	(CalFirst).w
	tst.w	(CalMonthIdx).w
	bne.w	.0
	move.w	#4,(CalFirst).w
.0
	clr.w	d0
	move.b	(SeasonLength).w,d0
	movea.l	#MonthDays,a0
	move.w	(CalMonthIdx).w,d1
	cmp.w	(CalMonths).w,d1
	beq.w	.1
	clr.w	(CalLast).w
	move.b	(a0,d1.w),(CalLast+1).w
	bra.w	.4
.1
	clr.w	d1
.lastday
	sub.b	(a0,d1.w),d0
	subq.w	#1,d0
	cmp.w	#$1C,d0
	blt.w	.3
	addq.w	#1,d1
	bra.s	.lastday
.3
	subq.w	#1,d0
	addq.w	#4,d0
	move.w	d0,(CalLast).w
.4
	movea.l	#MonthDays,a0
	move.w	(CalMonthIdx).w,d1
	clr.w	d7
	move.b	(a0,d1.w),d7
	clr.w	d6
.day
	cmp.w	(CalFirst).w,d6
	blt.w	.plain
	cmp.w	(CalLast).w,d6
	bgt.w	.plain
	movea.l	#CalGames,a2
	move.w	(CalDay).w,d1
	clr.w	d2
	move.b	(SeasonStartDay).w,d2
	jsr	(ReadDayGames).l
	movea.l	#CalGames,a0
	clr.w	d0
	move.b	1(a0),d0
	move.w	(CalTeam).w,d1
	addq.w	#2,a0
	move.w	#$FFFF,(TempWord1).w
	bra.w	.9
.find
	cmp.b	(a0),d1
	bne.w	.8
.found
	clr.w	(TempWord1).w
	bra.w	.10
.8
	cmp.b	1(a0),d1
	beq.s	.found
	addq.w	#5,a0
.9
	dbf	d0,.find
.10
	tst.w	(TempWord1).w
	bmi.w	.plain
	move.l	a0,(CalGamePtr).w
	movea.l	(CalGamePtr).w,a0
	move.w	(CalTeam).w,d0
	cmp.b	(a0),d0
	bne.w	.11
	jsr	(printz).l
	String	-TXMAP2,$0,$0,$0
	move.w	(CalX).w,(printx).w
	move.w	(CalY).w,(printy).w
	move.w	#$3A,d2
	add.w	(calbgchars).w,d2
	move.w	#3,d0
	move.w	#3,d1
	jsr	(eraser).l
.11
	bsr.w	DrawCalendarDay
	movea.l	(CalGamePtr).w,a0
	btst	#0,4(a0)
	bne.w	.12
	move.w	(CalX).w,(printx).w
	addq.w	#2,(printx).w
	move.w	(CalY).w,(printy).w
	move.w	(padiconchars4).w,d2
	move.w	#1,d0
	move.w	#1,d1
	jsr	(eraser).l
.12
	movea.l	(CalGamePtr).w,a0
	clr.w	d0
	move.b	(a0),d0
	cmp.w	(CalTeam).w,d0
	bne.w	.13
	move.b	1(a0),d0
.13
	bsr.w	DrawCalendarOpponent
	movea.l	(CalGamePtr).w,a0
	btst	#1,4(a0)
	beq.w	.18
	move.w	#2,d1
	move.w	(CalTeam).w,d0
	cmp.b	(a0),d0
	beq.w	.home
	move.b	3(a0),d0
	cmp.b	2(a0),d0
	beq.w	.result
	bgt.w	.win
	bra.w	.loss
.home
	move.b	2(a0),d0
	cmp.b	3(a0),d0
	beq.w	.result
	bgt.w	.win
.loss
	move.w	#0,d1
	bra.w	.result
.win
	move.w	#1,d1
.result
	bsr.w	DrawCalendarResult
.18
	bra.w	.next
.plain
	bsr.w	DrawCalendarDay
.next
	cmpi.w	#$1C,(CalX).w
	blt.w	.21
	move.w	#$A,(CalX).w
	addq.w	#3,(CalY).w
	bra.w	.22
.21
	addq.w	#3,(CalX).w
.22
	addq.w	#1,(CalDay).w
	addq.w	#1,d6
	dbf	d7,.day
	rts

CalendarFirstX	;CalX / CalY of the first day of CalMonth
	move.w	(CalMonthIdx).w,d0
	add.w	d0,d0
	movea.l	#CalendarFirstXTbl,a0
	move.w	#9,(CalY).w
	move.w	(a0,d0.w),(CalX).w
	rts

CalendarFirstXTbl	;Column of the first day of each month
	dc.w	$19,$D,$13,$1C,$10,$10,$19

DrawCalendarTeam	;Draw the CalTeam name
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(CalTeam).w,d1
	jsr	(printz).l
	String	-TXMAP1,$F,$5,$0
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

DrawCalendarMonth	;Draw the CalMonth name
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(CalMonthIdx).w,d1
	jsr	(printz).l
	String	-TXMAP1,$10,$7,$0
	clr.w	d0
	asl.w	#1,d1
	move.w	(padiconchars3).w,d4
	movea.l	#CalMonthMap,a0
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

DrawCalendarDay	;Draw day number d6 at CalX / CalY
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	d6,d1
	jsr	(printz).l
	String	-TXMAP1,$0,$0,$0
	move.w	(CalX).w,(printx).w
	move.w	(CalY).w,(printy).w
	clr.w	d0
	move.w	(padiconchars2).w,d4
	movea.l	#CalDayMap,a0
	movea.l	a0,a1
	adda.l	(a0),a0
	adda.l	4(a1),a1
	movea.l	#ZeroLong,a2
	move.w	(a1),d2
	moveq	#1,d3
	moveq	#0,d5
	jsr	(dobitmap).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

DrawCalendarOpponent	;Draw opponent d0
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	d0,d1
	move.w	(CalX).w,(printx).w
	move.w	(CalY).w,(printy).w
	addq.w	#1,(printy).w
	clr.w	d0
	move.w	(padiconchars1).w,d4
	movea.l	#CalOpponentMap,a0
	movea.l	a0,a1
	adda.l	(a0),a0
	adda.l	4(a1),a1
	movea.l	#ZeroLong,a2
	move.w	(a1),d2
	moveq	#1,d3
	moveq	#0,d5
	jsr	(dobitmap).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

DrawCalendarResult	;Draw result d1 (0 loss, 1 win, 2 tie)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(CalX).w,(printx).w
	move.w	(CalY).w,(printy).w
	addq.w	#2,(printy).w
	clr.w	d0
	move.w	(calresultchars).w,d4
	movea.l	#CalResultMap,a0
	movea.l	a0,a1
	adda.l	(a0),a0
	adda.l	4(a1),a1
	movea.l	#ZeroLong,a2
	move.w	(a1),d2
	moveq	#1,d3
	moveq	#0,d5
	jsr	(dobitmap).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

CalendarFirstDay	;CalDay = schedule day of the 1st of CalMonth
	movea.l	#CalendarFirstDayTbl,a0
	move.w	(CalMonthIdx).w,d0
	add.w	d0,d0
	move.w	(a0,d0.w),(CalDay).w
	rts

CalendarFirstDayTbl	;Schedule day of the 1st of each month
	dc.w	$FFFC,$1B,$39,$58,$77,$93,$B2

CalendarBg	;Draw the calendar background
	move.w	(calbgchars).w,d4
	jsr	(printz).l
	String	-TXMAP2,$0,$0,$0
	movea.l	#CalendarBgMap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	movea.l	#ZeroLong,a2
	moveq	#$28,d2
	moveq	#$1C,d3
	moveq	#0,d5
	jsr	(dobitmap).l
	rts

StandingsScreen	;NHL STANDINGS: {} conference / division, [] the other group; start exits
	movem.l	d0-d7/a0-a6,-(sp)
	move.l	#ControllerBgMap,(screenarg).l
	bsr.w	StandingsGfx
	move.w	#$18,(palcount).w
	bclr	#2,(disflags).w
	jsr	(PrintStandingsHelp).l
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP1),$8,$2,'NHL STANDINGS'
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$10,$9,'W  L  T  Pts  GP  GR',$0
	clr.w	(StandingsMode).w
.draw
	bsr.w	StandingsGroups
	movea.l	#StandingsBuf,a0
	bsr.w	ReadStandings
	bsr.w	StandingsPoints
	bsr.w	SortStandings
	bsr.w	DrawStandings
.input
	bsr.w	ReadStandingsPad
	tst.w	d1
	beq.w	.nopad
	btst	#7,d1
	beq.w	.2
	jsr	(forceblack).l
	bra.w	.done
.2
	btst	#2,d1
	beq.w	.3
	eori.w	#1,(StandingsMode).w
	bra.s	.draw
.3
	btst	#3,d1
	beq.w	.4
	eori.w	#1,(StandingsMode).w
	bra.s	.draw
.4
	btst	#0,d1
	beq.w	.5
	eori.w	#2,(StandingsMode).w
	bra.s	.draw
.5
	btst	#1,d1
	beq.s	.input
	eori.w	#2,(StandingsMode).w
	bra.s	.draw
.nopad
	jmp	Opening2
.done
	movem.l	(sp)+,d0-d7/a0-a6
	rts

ReadStandingsPad	;As ReadAnyPad
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

SortStandings	;Sort StandingsList by points, then by fewer games played
	movea.l	#StandingsList,a0
	movea.l	#CalMonth,a1
	movea.l	#StandingsOrder,a2
.pass
	bclr	#6,(sflags6).w
	clr.w	d7
.cmp
	clr.w	d6
	move.b	(a0,d7.w),d6
	move.b	(a1,d6.w),d0
	move.b	1(a0,d7.w),d6
	cmp.b	(a1,d6.w),d0
	bgt.w	.next
	blt.w	.swap
	move.b	(a0,d7.w),d6
	move.b	(a2,d6.w),d0
	move.b	1(a0,d7.w),d6
	cmp.b	(a2,d6.w),d0
	ble.w	.next
.swap
	bset	#6,(sflags6).w
	move.b	(a0,d7.w),d5
	move.b	1(a0,d7.w),d4
	move.b	d5,1(a0,d7.w)
	move.b	d4,(a0,d7.w)
.next
	addq.w	#2,d7
	clr.w	d5
	move.b	(StandTeamCount).w,d5
	addq.w	#1,d5
	addq.w	#1,d5
	cmp.w	d5,d7
	bge.w	.4
	subq.w	#1,d7
	bra.s	.cmp
.4
	btst	#6,(sflags6).w
	bne.s	.pass
	rts

StandingsPoints	;Points and games of the playoff teams from StandingsBuf
	move.w	#NumPlayoffTeams,d0
	movea.l	#StandingsBuf,a1
	movea.l	#CalMonth,a2
	movea.l	#StandingsOrder,a3
	clr.w	d2
	bra.w	.1
.loop
	move.w	d2,d5
	mulu.w	#3,d2
	clr.w	d3
	move.b	(a1,d2.w),d3
	add.b	d3,d3
	add.b	1(a1,d2.w),d3
	move.b	d3,(a2,d5.w)
	move.b	(a1,d2.w),d3
	add.b	1(a1,d2.w),d3
	add.b	2(a1,d2.w),d3
	move.b	d3,(a3,d5.w)
	move.w	d5,d2
	addq.w	#1,d2
.1
	dbf	d0,.loop
	rts

StandingsGroups	;StandingsList = the teams of group StandingsMode
	movea.l	#StandingsGroupTbl,a5
	move.w	(StandingsMode).w,d0
	asl.w	#2,d0
	movea.l	(a5,d0.w),a5
	move.b	(a5)+,d0
	move.b	d0,(StandTeamCount).w
	subq.w	#1,d0
	movea.l	#StandingsList,a4
.loop
	move.b	(a5)+,(a4)+
	dbf	d0,.loop
	rts

StandingsGroupTbl	;Team lists of the 4 divisions (count, teams)
	dc.l	StandingsGroup0,StandingsGroup1,StandingsGroup2,StandingsGroup3

	include	stubinc\season_divisions.inc

StandingsGfx	;Standings screen video set up and graphics
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
	dc.b	$0B,$83,$44,$67,$89,$AB,$CD,$EF	;remap table
	move.w	d4,(smallfont2chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$83,$4C,$67,$89,$AB,$CD,$EF	;remap table
	move.l	#SmallFontMap,(smallfontptr).l
	move.w	d4,(BigFontChars).w
	movea.l	#BigFontMap+8,a2
	jsr	(DecompressGraphicsPlain).l
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
	moveq	#$B,d5
	jsr	(dobitmap).l
	rts

DrawStandings	;Draw the group title and the standings lines
	move.w	#$28,d0
	move.w	#2,d1
	move.w	#$7FF,d2
	jsr	(printz).l
	String	-TXMAP1,$0,$16,$0
	jsr	(eraser).l
	movea.l	#StandingsTitles,a1
	move.w	(StandingsMode).w,d0
	jsr	(PrintListItem).l
	clr.w	d7
	move.b	(StandTeamCount).w,d7
	clr.w	d6
	movea.l	#StandingsList,a4
	jsr	(printz).l
	String	-TXMAP1,$2,$A,$0
	bra.w	.1
.loop
	clr.w	d1
	move.b	(a4,d6.w),d1
	bsr.w	DrawStandingsLogo
	bsr.w	PrintStandingsLine
	addq.w	#2,(printy).w
	move.w	#2,(printx).w
	addq.w	#1,d6
.1
	dbf	d7,.loop
	rts

PrintStandingsLine	;Print W, L, T, Pts, GP and games remaining of team d1 on line d6
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(printy).w,-(sp)
	move.w	d1,d2
	jsr	(printz).l
	String	-TXMAP1,$0,$B,$0
	move.w	d6,d1
	add.w	d1,d1
	add.w	d1,(printy).w
	movea.l	#StandingsBuf,a4
	move.w	d2,d5
	mulu.w	#3,d5
	clr.w	d0
	move.w	#2,d1
	move.b	(a4,d5.w),d0
	jsr	(PushNumberWidth).l
	move.w	#$F,(printx).w
	jsr	(print).l
	move.b	2(a4,d5.w),d0
	jsr	(PushNumberWidth).l
	move.w	#$12,(printx).w
	jsr	(print).l
	move.b	1(a4,d5.w),d0
	jsr	(PushNumberWidth).l
	move.w	#$15,(printx).w
	jsr	(print).l
	move.b	(a4,d5.w),d0
	add.b	d0,d0
	add.b	1(a4,d5.w),d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	move.w	#$19,(printx).w
	jsr	(print).l
	move.b	(a4,d5.w),d0
	add.b	1(a4,d5.w),d0
	add.b	2(a4,d5.w),d0
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	move.w	#$1E,(printx).w
	jsr	(print).l
	move.w	d0,-(sp)
	move.w	d0,d1
	move.w	d2,d0
	jsr	(CountTeamGames).l
	sub.w	(sp)+,d1
	move.w	d1,d0
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	move.w	#$22,(printx).w
	jsr	(print).l
	move.w	(sp)+,(printy).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts

DrawStandingsLogo	;Draw team d1's block
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

StandingsTitles	;Conference / division titles
	String	$FF,$3,$7,'WESTERN CONFERENCE',$FF,$17,$7,'PACIFIC DIV.  '
	String	$FF,$3,$7,'WESTERN CONFERENCE',$FF,$17,$7,'CENTRAL DIV.  '
	String	$FF,$3,$7,'EASTERN CONFERENCE',$FF,$17,$7,'NORTHEAST DIV.'
	String	$FF,$3,$7,'EASTERN CONFERENCE',$FF,$17,$7,'ATLANTIC DIV. '

PrintStandingsHelp	;Standings help line
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(smallfontchars).w,-(sp)
	move.w	(smallfont2chars).w,(smallfontchars).w
	jsr	(printz).l
	String	-TXMAP1,$2,$19,'{} For Conference',-TXMAP1,$18,$19,'[] For Division'
	move.w	(sp)+,(smallfontchars).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts

CalendarBgMap
	incbin	..\Extracted\NHL94\Season\CalendarBgMap.map.jim

CalOpponentMap
	incbin	..\Extracted\NHL94\Season\CalOpponentMap.map.jim

CalDayMap
	incbin	..\Extracted\NHL94\Season\CalDayMap.map.jim

CalMonthMap
	incbin	..\Extracted\NHL94\Season\CalMonthMap.map.jim

CalCheckMap
	incbin	..\Extracted\NHL94\Season\CalCheckMap.map.jim

CalResultMap
	incbin	..\Extracted\NHL94\Season\CalResultMap.map.jim

