;	NHL 94 (retail) segment $FD618-$FFABF
;	94 code in the high ROM, between hockey94_07 and the checksum: the shootout end, the game stats clear, the arena animations
;	(RunArenaAnim, AddArenaAnimSprite, ArenaAnims), the Period Stats and Game Statistics screens (PeriodStatsScreen, GameStatisticsScreen,
;	TeamStatTextTbl), the Manual Goalie menu item, ChooseSong, the shootout skate paths, the save RAM option and three stars
;	blocks, the player picture unpack (UnpackPicture), HiScoreScreen, newTitleScreen and the credits, clrTmPdst and chgplayer.
;	94 only; 93 has no code here, except GameStatisticsScreen / DisplayTeamStatsScreen / FormatStatValue / TeamStatTextTbl (stats93).
;	Transcribed from lst/nhl94.bin.lst lines 970645-976744. The IDA human names are kept; the IDA auto names (sub_, loc_, unk_,
;	locret_) and the entries IDA has no label for are named for what they do, with the IDA name in an ;IDA: comment, or the 93 name.
;	Locals are in the 93 style (.x exit, .loop, numbered) with the IDA label in an ;IDA: comment. IDA left code as data at $FD6B4,
;	$FD7D0, $FD8EC-$FE14B, $FE1D8, $FE4FC and $FEEA0: written from the retail bytes (the instructions and Strings), as are the
;	Strings and remap table IDA hid in newTitleScreen. The data tables are formatted from the retail bytes; the IDA labels inside
;	Strings or tables (unk_FDAA9, unk_FF633) are not labels.

EndShootout	;IDA: sub_FD618. 94 only. Shootout over (CountShootoutGoals, high94_2): freezewindow, then the 5 skaters of player slots 1-5 (homeshootgoals > awayshootgoals) or
	;7-$B are set up (setplayer) above or below the view and get assscore (assinsert 7)
	movem.l	d0-d7/a0-a6,-(sp)
	bset	#2,(sflags2).w
	jsr	(freezewindow).l
	move.w	#$60,(shootoutdelay).w
	movea.l	#SortCords,a3
	move.w	#0,d0
	move.w	(homeshootgoals).w,d2
	cmp.w	(awayshootgoals).w,d2
	bgt.w	.0
	move.w	#6,d0
.0	;IDA: loc_FD648
	asl.w	#7,d0
	adda.w	d0,a3
	move.w	#4,d2
	move.w	#6,d3
	bra.w	.2
.loop	;IDA: loc_FD658
	movem.w	d2-d3,-(sp)
	jsr	(setplayer).l
	move.w	#2,$34(a3)
	move.w	#$F0,d0
	tst.w	(Vpos).w
	bmi.w	.1
	move.w	#$FF10,d0
.1	;IDA: loc_FD678
	add.w	(Vpos).w,d0
	move.w	d0,$14(a3)
	move.w	#0,(a3)
	move.w	#7,d0	;assscore
	jsr	(assinsert).l
	bclr	#5,$62(a3)
	bclr	#1,$63(a3)
	bclr	#2,$62(a3)
	movem.w	(sp)+,d2-d3
.2	;IDA: loc_FD6A4
	adda.l	#$80,a3
	dbf	d2,.loop
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ClampPositionBox	;no IDA label (was sub_FD6B4), and nothing calls it (IDA left it as data). Clamp $44 / $46(a3) to the box for position $34(a3) in PositionBoxes (PositionBoxesTop when bit 7 of
	;$62(a3), the top net)
	movem.l	d0-d7/a0,-(sp)
	move.w	$34(a3),d7
	subq.w	#1,d7
	movea.l	#PositionBoxes,a0
	btst	#7,$62(a3)
	beq.w	.0
	movea.l	#PositionBoxesTop,a0
.0
	add.w	d7,d7
	move.w	(a0,d7.w),d0
	cmp.w	$44(a3),d0
	blt.w	.1
	move.w	d0,$44(a3)
.1
	move.w	2(a0,d7.w),d0
	cmp.w	$44(a3),d0
	bgt.w	.2
	move.w	d0,$44(a3)
.2
	move.w	4(a0,d7.w),d0
	cmp.w	$46(a3),d0
	blt.w	.3
	move.w	d0,$46(a3)
.3
	move.w	6(a0,d7.w),d0
	cmp.w	$46(a3),d0
	bgt.w	.x
	move.w	d0,$46(a3)
.x
	movem.l	(sp)+,d0-d7/a0
	rts
PositionBoxes	;no IDA label (was unk_FD71C). ClampPositionBox boxes: min / max of $44, then of $46, per position
	dc.w	$FFB5,0,0,$108,0,$4B,0,$108
PositionBoxesTop	;no IDA label (was unk_FD72C). ClampPositionBox boxes, top net
	dc.w	$FFB5,0,$FEF8,0,0,$4B,$FEF8,0
ClearGameStats	;IDA: sub_FD73C. 94 only. Clear the game stats: shootoutstate (19 words), both team structs (HmShots, AwShots), PenBuf, BA_PS_flags, sflags4 / F8 /
	;FA and setupcardflags / featuredplayer. Called from GameSetUp (hockey94_08)
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#shootoutstate,a0
	moveq	#$12,d0
.loop	;IDA: loc_FD748
	clr.w	(a0)+
	dbf	d0,.loop
	movea.l	#HmShots,a0
	move.w	#$363,d0
.loop2	;IDA: loc_FD758
	clr.w	(a0)+
	dbf	d0,.loop2
	movea.l	#PenBuf,a0
	moveq	#$24,d0
.loop3	;IDA: loc_FD766
	clr.w	(a0)+
	dbf	d0,.loop3
	clr.w	(BA_PS_flags).w
	clr.w	(sflags4).w
	clr.w	(sflags6).w
	clr.w	(gmode2).w
	clr.w	(setupcardflags).w
	clr.w	(featuredplayer).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
AddArenaAnimSprite	;IDA: sub_FD78A. 94 only. Add the frame arenaframe of the arena animation (sprite list arenaspritelist, see RunArenaAnim) to the sprite table a6 (d6
	;sprites, 64 at most) for the pieces inside the view (Hpos / Vpos). Not in a reverse angle replay (sflags4 bit 4), sflags2 bit 3 or sflags
	;bit 7. Called from setvideo (video94_1)
	tst.w	(arenaanim).w
	bmi.w	.x2
	tst.l	(arenaspritelist).w
	beq.w	.x2
	btst	#4,(sflags4).w	;check if reverse angle replay
	bne.w	.x2	;branch if so
	btst	#3,(sflags2).w
	bne.w	.x2
	btst	#7,(sflags).w
	bne.w	.x2
	movea.l	(arenaspritelist).w,a1
	adda.l	4(a1),a1
	move.w	(Hpos).w,d4
	move.w	(Vpos).w,d5
	move.w	(arenaframe).w,d0
	bra.w	.2
	andi.w	#$F,d2	;nothing branches here: draw d2 + 1 (4 at most) frames from d3 (.2)
	cmp.w	#3,d2
	bls.w	.0
	moveq	#3,d2
.0
	bra.w	.1
.loop
	move.w	d3,d0
	add.w	d2,d0
	bsr.w	.2
.1
	dbf	d2,.loop
	rts
.2	;IDA: loc_FD7F0
	ext.w	d0
	beq.w	.x2
	cmp.w	#$40,d6
	bge.w	.x2
	movem.l	d0-d5,-(sp)
	add.w	d0,d0
	movea.l	a1,a0
	move.w	2(a0,d0.w),d1
	sub.w	0(a0,d0.w),d1
	lsr.w	#3,d1
	subq.w	#1,d1
	move.w	d1,-(sp)
	adda.w	0(a0,d0.w),a0
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
.loop2	;IDA: loc_FD83A
	cmp.w	2(a0),d2
	bgt.w	.3
	cmp.w	2(a0),d3
	blt.w	.3
	cmp.w	(a0),d0
	bgt.w	.3
	cmp.w	(a0),d1
	blt.w	.3
	move.w	2(a0),d5
	addi.w	#$70,d5
	sub.w	d2,d5
	move.w	d5,(a6)+
	move.b	7(a0),(a6)+
	move.b	d6,(a6)+
	move.w	6(a0),d5
	andi.w	#$F800,d5
	add.w	4(a0),d5
	add.w	(arenaanimchars).w,d5
	move.w	d5,(a6)+
	move.w	(a0),d5
	addi.w	#$70,d5
	sub.w	d0,d5
	move.w	d5,(a6)+
	addq.w	#1,d6
	cmp.w	#$40,d6
	beq.w	.x
.3	;IDA: loc_FD88E
	addq.w	#8,a0
	dbf	d4,.loop2
.x	;IDA: loc_FD894
	movem.l	(sp)+,d0-d5
.x2	;IDA: locret_FD898
	rts
PrintPlayerNameRight	;IDA: sub_FD89A. 94 only. Print the name of player d0 of team a2 (FormatPlayerName), moved left so it ends before column $29 (a trailing pad byte or
	;two not counted), then the icon of HotColdIcon. Called from PrintMatchupRatings (hockey94_07)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	d0,(iconplayer).w
	move.l	a2,-(sp)
	jsr	(FormatPlayerName).l
	movea.l	a1,a0
	move.w	(a0),d0
	move.w	d0,d5
	tst.b	-1(a0,d5.w)
	bne.w	.0
	subq.w	#1,d0
	tst.b	-2(a0,d5.w)
	bne.w	.0
	subq.w	#1,d0
.0	;IDA: loc_FD8C4
	add.w	(printx).w,d0
	subi.w	#$29,d0
	bmi.w	.1
	neg.w	d0
	add.w	d0,(printx).w
.1	;IDA: loc_FD8D6
	movea.l	a0,a1
	jsr	(print).l
	movea.l	(sp)+,a2
	jsr	(HotColdIcon).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
SkipNameNumber	;no IDA label (was sub_FD8EC), and nothing calls it (IDA left it as data). a1 = the FormatPlayerNameWithAttrib String without its first 2 characters (the length word moved up 2)
	movem.l	d0-d7/a0/a2-a3,-(sp)
	jsr	(FormatPlayerNameWithAttrib).l
	move.w	(a1),d0
	subq.w	#2,d0
	move.w	d0,2(a1)
	addq.w	#2,a1
	movem.l	(sp)+,d0-d7/a0/a2-a3
	rts
	String	' . '
PeriodStatsScreen	;no IDA label (was sub_FD90C) (IDA left it as data; 93 has no counterpart). "Period Stats" menu item (hockey94_11 menu lists): both team logos
	;(TeamLogoBitmaps, TeamLogoPalettes palettes), then the goals (matchup 0) or shots of each team by period ($342 / $34A of the team struct; OT when
	;sflags7 bit 1) and the total. Left / right switch, start exits (ExitAttributeScreen2)
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	(matchup).w
	moveq	#0,d0
	moveq	#$1C,d1
	jsr	(SetupScreen).l
	jsr	(printz).l
	String	$BE,1,$B
	move.w	#8,d0
	move.w	#8,d1
	jsr	(Framer).l
	jsr	(printz).l
	String	$BE,1,$13
	move.w	#8,d0
	move.w	#8,d1
	jsr	(Framer).l
	jsr	(printz).l
	String	$9E,2,$C
	movea.l	#TeamLogoBitmaps,a0
	move.w	(VisTeam).w,d0
	asl.w	#2,d0
	movea.l	0(a0,d0.w),a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	asl.w	#3,d0
	movea.l	#TeamLogoPalettes,a0
	subi.w	#$40,d0
	adda.w	d0,a0
	adda.l	(a2)+,a1
	clr.w	d1
	clr.w	d0
	moveq	#6,d2
	move.w	#6,d3
	moveq	#4,d5
	jsr	(dobitmap).l
	movea.l	#palfadenew+$40,a0
	movea.l	#palfadenew+$60,a1
	move.w	#7,d0
.loop
	move.l	(a0)+,(a1)+
	dbf	d0,.loop
	jsr	(printz).l
	String	$8E,2,$14
	movea.l	#TeamLogoBitmaps,a0
	move.w	(HomeTeam).w,d0
	asl.w	#2,d0
	movea.l	0(a0,d0.w),a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	asl.w	#3,d0
	subi.w	#$40,d0
	movea.l	#TeamLogoPalettes,a0
	adda.w	d0,a0
	adda.l	(a2)+,a1
	clr.w	d1
	clr.w	d0
	moveq	#6,d2
	move.w	#6,d3
	moveq	#4,d5
	jsr	(dobitmap).l
	jsr	(printz).l
	String	$BD,4,1
	moveq	#$20,d0
	moveq	#6,d1
	jsr	(Framer).l
	jsr	(printbigz).l
	String	$BD,6,3,'  Period Stats  ',$BE,6,1
	btst	#1,(sflags7).w
	beq.w	.0
	jsr	(printz).l
	dc.w	$001C	;String length: too many arguments for the String macro (as 93)
	dc.b	$BE,$C,9,'1',$BE,$11,9,'2',$BE,$16,9,'3',$BE,$1A,9,'OT',$BE,' ',9,'Total',0
	jsr	(printz).l
	dc.w	$001C	;String length: too many arguments for the String macro (as 93)
	dc.b	$BE,$C,$A,'<',$BE,$11,$A,'<',$BE,$16,$A,'<',$BE,$1A,$A,'<<',$BE,' ',$A,'<<<<<',0
	bra.w	.1
.0
	jsr	(printz).l
	dc.w	$0016	;String length: too many arguments for the String macro (as 93)
	dc.b	$BE,$C,9,'1',$BE,$11,9,'2',$BE,$16,9,'3',$BE,' ',9,'Total'
	jsr	(printz).l
	dc.w	$0016	;String length: too many arguments for the String macro (as 93)
	dc.b	$BE,$C,$A,'<',$BE,$11,$A,'<',$BE,$16,$A,'<',$BE,' ',$A,'<<<<<'
.1
	bsr.w	.5
	bsr.w	.7
	move.w	#$18,(palcount).w
.loop2
	jsr	(_rjoy).l	;left (bit 2) goals, right (bit 3) shots, start exits
	btst	#7,d1
	bne.w	.4
	btst	#2,d1
	bne.w	.3
	btst	#3,d1
	bne.w	.2
	bra.s	.loop2
.2
	tst.w	(matchup).w
	bne.s	.loop2
	st	(matchup).w
	bsr.w	.5
	bsr.w	.7
	bra.s	.loop2
.3
	tst.w	(matchup).w
	beq.s	.loop2
	clr.w	(matchup).w
	bsr.w	.5
	bsr.w	.7
	bra.s	.loop2
.4
	movem.l	(sp)+,d0-d7/a0-a6
	jmp	(ExitAttributeScreen2).l
.5
	tst.w	(matchup).w
	beq.w	.6
	jsr	(printz).l
	String	$BE,$12,7,'Shots',$BE,$F,$1A,'[ For Goals'
	rts
.6
	jsr	(printz).l
	String	$BE,$12,7,'Goals',$BE,$F,$1A,'For Shots ]'
	rts
.7
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	$BE,0,0
	movea.l	#AwShots,a2
	move.w	#$E,(printy).w
	bsr.w	.8
	movea.l	#HmShots,a2
	move.w	#$16,(printy).w
	bsr.w	.8
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.8
	lea	$342(a2),a0
	tst.w	(matchup).w
	beq.w	.9
	lea	$34A(a2),a0
.9
	clr.w	(matchuptimer).w
	move.w	#$B,(printx).w
	bsr.w	.12
	cmpi.w	#1,(gsp).w
	blt.w	.10
	move.w	#$10,(printx).w
	bsr.w	.12
	cmpi.w	#2,(gsp).w
	blt.w	.10
	move.w	#$15,(printx).w
	bsr.w	.12
	cmpi.w	#3,(gsp).w
	blt.w	.10
	btst	#1,(sflags7).w
	beq.w	.10
	move.w	#$1A,(printx).w
	bsr.w	.12
.10
	move.w	#$21,(printx).w
	jsr	(printz).l
	String	'   '
	subq.w	#3,(printx).w
	move.w	(matchuptimer).w,d0
	move.w	#2,d1
	cmp.w	#$64,d0
	blt.w	.11
	move.w	#3,d1
.11
	jsr	(PushNumberWidth).l
	jsr	(print).l
	rts
.12
	move.w	(a0)+,d0
	add.w	d0,(matchuptimer).w
	jsr	(printz).l
	String	'   '
	subq.w	#3,(printx).w
	move.w	#2,d1
	cmp.w	#$64,d0
	blt.w	.13
	move.w	#3,d1
.13
	jsr	(PushNumberWidth).l
	jmp	(print).l
GameStatisticsScreen	;no IDA label (IDA left it as data; 93 name). "Game Statistics" menu item (hockey94_11 menu lists): both teams' totals
	;(DisplayTeamStatsScreen). 94 has more rows than the screen: up / down scroll them (matchupvis the most, $70 or $30 without penalties,
	;OptPen), start exits (ExitAttributeScreen2)
	moveq	#9,d0
	moveq	#$1A,d1
	jsr	(SetupScreen).l
	jsr	(printz).l
	String	$BD,4,1
	moveq	#$20,d0
	moveq	#6,d1
	jsr	(Framer).l
	jsr	(printbigz).l
	String	$BD,6,4,'Game  Statistics',$BD,7,1
	move.w	#$2C,d0
	jsr	(PrintTeamData).l
	addq.w	#4,(printx).w
	clr.w	d0
	jsr	(PrintTeamData).l
	clr.w	(DispAttribCtr).w
	clr.w	(VertLineScrolling).w
	clr.w	(PlayerScrollCtr).w
	move.w	#$70,(matchupvis).w	;the most scroll: 15 rows
	tst.w	(OptPen).w
	bne.w	.0
	move.w	#$30,(matchupvis).w	;11 rows
.0
	bsr.w	DisplayTeamStatsScreen
	bsr.w	PrintStatScrollArrows
.loop
	jsr	(vcountwait).l
	jsr	(getpzjoy).l
	btst	#7,d3
	beq.w	.1
	jmp	(ExitAttributeScreen2).l
.1
	jsr	(nodiag).l
	move.w	#$FFFE,d0
	btst	#0,d3
	bne.w	.2
	neg.w	d0
	btst	#1,d3
	beq.w	.3
.2
	move.w	d0,(PlayerScrollCtr).w
.3
	bsr.w	.4
	bsr.w	PrintStatScrollArrows
	bra.s	.loop
.4
	move.w	(PlayerScrollCtr).w,d0
	beq.w	rtsStatTables
	add.w	(VertLineScrolling).w,d0
	bmi.w	rtsStatTables
	cmp.w	(matchupvis).w,d0
	bgt.w	rtsStatTables
	move.w	(VertLineScrolling).w,d1
	move.w	d0,(VertLineScrolling).w
	andi.w	#$F,d0
	bne.w	.5
	clr.w	(PlayerScrollCtr).w
.5
	andi.w	#$F,d1
	bne.w	SetStatScroll
	move.w	d0,-(sp)
	cmp.w	#$E,d0
	bne.w	.6
	bsr.w	StatScrollRow
.6
	move.w	(sp)+,d0
	cmp.w	#2,d0
	bne.w	SetStatScroll
	bsr.w	StatScrollRowEnd
SetStatScroll	;no IDA label (was sub_FDD6A). Plane A vertical scroll (VSRAM 0) = VertLineScrolling - $50, with disflags bit 2 set while it writes
	move.w	(disflags).w,-(sp)
	bset	#2,(disflags).w
	movea.l	#VDP_DATA,a0
	move.l	#$40020010,4(a0)
	move.w	#$FFB0,d0
	add.w	(VertLineScrolling).w,d0
	move.w	d0,(a0)
	move.w	(sp)+,(disflags).w
	rts
StatScrollRow	;no IDA label (was sub_FDD92). d3 = VertLineScrolling / 16 (GameStatisticsScreen, at a scroll step)
	move.w	(VertLineScrolling).w,d3
	lsr.w	#4,d3
	bra.w	rtsStatScroll
StatScrollRowEnd	;no IDA label (was sub_FDD9C). d3 = VertLineScrolling / 16 + 6 (GameStatisticsScreen, at a scroll step)
	move.w	(VertLineScrolling).w,d3
	lsr.w	#4,d3
	addq.w	#6,d3
	bra.w	rtsStatScroll
rtsStatScroll	;no IDA label (was locret_FDDA8). rts of StatScrollRow / StatScrollRowEnd
	rts
PrintStatScrollArrows	;no IDA label (was sub_FDDAA). GameStatisticsScreen scroll arrows (printz2): up ($7B) when VertLineScrolling > 0, down ($7D) when it is below matchupvis
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz2).l
	String	$F9,1
	tst.w	(VertLineScrolling).w
	beq.w	.0
	jsr	(printz2).l
	String	$F8,4,3,'&',8,$F9,1,'{'
	bra.w	.1
.0
	jsr	(printz2).l
	String	$F8,4,3,'&',8,$F9,1,' '
.1
	move.w	(matchupvis).w,d0
	cmp.w	(VertLineScrolling).w,d0
	beq.w	.2
	jsr	(printz2).l
	String	$F8,4,3,'&',$1A,$F9,1,'}'
	bra.w	.3
.2
	jsr	(printz2).l
	String	$F8,4,3,'&',$1A,$F9,1,' '
.3
	jsr	(printz2).l
	String	$F9
	movem.l	(sp)+,d0-d7/a0-a6
	rts
DisplayTeamStatsScreen	;no IDA label (93 name). Team logos (PrintTeamData), then each TeamStatTextTbl row (TeamStatTextTblNoPen when penalties are
	;off, OptPen) centred, with the home value at x $22 and the visitors' at x 9 (FormatStatValue); SetStatScroll first
	jsr	(printz).l
	String	$BD,2,7
	move.w	#$2C,d0
	jsr	(PrintTeamData).l
	jsr	(printz).l
	String	$BD,$1A,7
	moveq	#0,d0
	jsr	(PrintTeamData).l
	bsr.w	SetStatScroll
	jsr	(printz).l
	String	$BE,0,0
	moveq	#$E,d6
	lea	TeamStatTextTbl(pc),a1
	tst.w	(OptPen).w
	bne.w	.loop
	move.w	#$A,d6
	lea	TeamStatTextTblNoPen(pc),a1
.loop
	move.w	(a1),d0
	lsr.w	#1,d0
	neg.w	d0
	addi.w	#$15,d0
	move.w	d0,(printx).w
	jsr	(print).l
	movea.l	a1,a0
	move.w	#$22,(printx).w
	movea.w	#(HmShots-M68K_RAM),a2
	bsr.w	FormatStatValue
	move.w	#9,(printx).w
	lea	$364(a2),a2
	bsr.w	FormatStatValue
	lea	4(a0),a1
	addq.w	#2,(printy).w
	dbf	d6,.loop
	rts
FormatStatValue	;no IDA label (93 name). Print TeamStatTextTbl entry a0 for team a2 centred at printx: the value (offsets $A and $352 are times,
	;PushTime), "/second" if any, " (pct%)" for passing. 94: offset $FFFF is the shooting percentage (goals $C * 100 / shots 0), printed with a
	;"%"
	movea.w	#(mesarea-M68K_RAM),a3
	move.w	#2,(a3)
	cmpi.w	#$FFFF,(a0)	;shooting percentage row
	bne.w	.1
	move.w	#$C,d0
	move.w	(a2,d0.w),d0
	mulu.w	#$64,d0
	move.w	#0,d1
	move.w	(a2,d1.w),d1
	beq.w	.0
	divu.w	d1,d0
.0
	jsr	(PushNumber).l
	jsr	(appstring).l
	jsr	(appendz).l
	String	'%'
	bra.w	.6
.1
	move.w	(a0),d0
	move.w	(a2,d0.w),d0
	cmpi.w	#$352,(a0)	;PP Minutes: a time
	bne.w	.2
	bsr.w	.8
	bra.w	.4
.2
	cmpi.w	#$A,(a0)
	beq.w	.3
	bsr.w	.7
.3
	cmpi.w	#$A,(a0)
	bne.w	.4
	bsr.w	.8
.4
	jsr	(appstring).l
	move.w	2(a0),d0
	bmi.w	.6
	jsr	(appendz).l
	String	'/'
	move.w	(a2,d0.w),d0
	jsr	(PushNumber).l
	jsr	(appstring).l
	cmpi.w	#$14,(a0)
	bne.w	.6
	jsr	(appendz).l
	String	' ('
	move.w	(a0),d0
	move.w	(a2,d0.w),d0
	mulu.w	#$64,d0
	move.w	2(a0),d1
	move.w	(a2,d1.w),d1
	beq.w	.5
	divu.w	d1,d0
.5
	jsr	(PushNumber).l
	jsr	(appstring).l
	jsr	(appendz).l
	String	'%)'
.6
	movea.w	a3,a1
	move.w	(a1),d0
	lsr.w	#1,d0
	sub.w	d0,(printx).w
	jmp	(print).l
.7
	jmp	(PushNumber).l
.8
	jmp	(PushTime).l
TeamStatTextTbl	;93 name. Label, then the team struct stat offset and the second offset ($FFFF none). 15 rows
	dc.w	$0008
	dc.b	'Score',0
	dc.w	$C,$FFFF
	dc.w	$0008
	dc.b	'Shots',0
	dc.w	0,$FFFF
	dc.w	$000E
	dc.b	'Shooting Pct'
	dc.w	$FFFF,$FFFF
	dc.w	$000C
	dc.b	'Power Play'
	dc.w	2,4
	dc.w	$000C
	dc.b	'PP Minutes'
	dc.w	$352,$FFFF
	dc.w	$000A
	dc.b	'PP Shots'
	dc.w	$354,$FFFF
	dc.w	$000A
	dc.b	'SH Goals'
	dc.w	$356,$FFFF
	dc.w	$000C
	dc.b	'Breakaways'
	dc.w	$35A,$358
	dc.w	$000C
	dc.b	'One-Timers'
	dc.w	$35E,$35C
	dc.w	$0010
	dc.b	'Penalty Shots',0
	dc.w	$362,$360
	dc.w	$000E
	dc.b	'Faceoffs Won'
	dc.w	$E,$FFFF
	dc.w	$000E
	dc.b	'Body Checks',0
	dc.w	$10,$FFFF
	dc.w	$000C
	dc.b	'Penalties',0
	dc.w	6,8
	dc.w	$000E
	dc.b	'Attack Zone',0
	dc.w	$A,$FFFF
	dc.w	$000A
	dc.b	'Passing',0
	dc.w	$14,$12
TeamStatTextTblNoPen	;94 only. The rows without the power play ones, used when penalties are off. 11 rows
	dc.w	$0008
	dc.b	'Score',0
	dc.w	$C,$FFFF
	dc.w	$0008
	dc.b	'Shots',0
	dc.w	0,$FFFF
	dc.w	$000E
	dc.b	'Shooting Pct'
	dc.w	$FFFF,$FFFF
	dc.w	$000C
	dc.b	'Breakaways'
	dc.w	$35A,$358
	dc.w	$000C
	dc.b	'One-Timers'
	dc.w	$35E,$35C
	dc.w	$0010
	dc.b	'Penalty Shots',0
	dc.w	$362,$360
	dc.w	$000E
	dc.b	'Faceoffs Won'
	dc.w	$E,$FFFF
	dc.w	$000E
	dc.b	'Body Checks',0
	dc.w	$10,$FFFF
	dc.w	$000C
	dc.b	'Penalties',0
	dc.w	6,8
	dc.w	$000E
	dc.b	'Attack Zone',0
	dc.w	$A,$FFFF
	dc.w	$000A
	dc.b	'Passing',0
	dc.w	$14,$12
rtsStatTables	;no IDA label (was locret_FE14A). rts after the stat tables (GameStatisticsScreen scroll step)
	rts
updatePPTeamTime	;IDA name (and comments). 94 only: one more second of power play time ($352 of the team struct) for the team on the power play
	;(sflags2 bit 5, bit 6 the visitors). Called from updatepentime (penalty94_1)
	btst	#5,(sflags2).w	;check if PP
	beq.w	.x	;branch if not
	movea.l	#HmShots,a2	;move home team struct into a2
	btst	#6,(sflags2).w	;check who's on PP
	beq.w	.0	;branch if home (team 1)
	movea.l	#AwShots,a2	;move away team struct into a2
.0	;IDA: loc_FE16C
	addq.w	#1,$352(a2)	;add 1 to PP team total
.x	;IDA: locret_FE170
	rts
GetTeamRating	;IDA: sub_FE172. 94 only. d0 = the TeamRatings byte of team $28(a2). Called from PrintTeamRating (high94_2, the player card "Team Rating") and PrintMatchupRating (hockey94_07)
	movem.l	d1-d7/a0-a6,-(sp)
	move.w	$28(a2),d0
	movea.l	#TeamRatings,a0
	clr.w	d1
	move.b	0(a0,d0.w),d1
	move.w	d1,d0
	movem.l	(sp)+,d1-d7/a0-a6
	rts
TeamRatings	;IDA: unk_FE18E. GetTeamRating values, one byte per team (TeamList order)
	dc.b	$33,$4C,$49,$4B,$4E,$43,$4B,$43,$34,$42,$4A,$49,$44,$42
	dc.b	$4A,$37,$45,$4B,$47,$38,$45,$38,$48,$47,$48,$46,$5B,$59
ShortenMsgTimer	;IDA: sub_FE1AA. 94 only. Cap msgtimer at 2, unless a second pad is on (cont2team) and a3 is not the puck carrier. Called from doinput (logic94_1)
	movem.l	d0,-(sp)
	tst.w	(cont2team).w
	beq.w	.0
	move.w	$52(a3),d0
	cmp.w	(puckc).w,d0
	bne.w	.x
.0	;IDA: loc_FE1C2
	cmpi.w	#2,(msgtimer).w
	ble.w	.x
	move.w	#2,(msgtimer).w
.x	;IDA: loc_FE1D2
	movem.l	(sp)+,d0
	rts
ManualGoalieMenu	;no IDA label (was sub_FE1D8) (IDA left it as data; 93 has no counterpart). "x Manual Goalie" menu item (hockey94_11 menu lists; PrintMenuItem prints
	;Manual / Auto Goalie from the same words): with OptNOP set, toggle the goalie mode of the pause pad (goaliemode2 for pad 2, sflags bit 1,
	;else goaliemode1; both when the pads are on one team). In a penalty shot or shootout (gmode2 bit 0, BA_PS_flags bit 2) the pad then
	;takes player 0 / 6 or 5 / $B by its mode, when BA_Sktr_SCnum is on its side (setc1player / setc2player)
	movem.l	d0-d7/a0-a6,-(sp)
	tst.w	(OptNOP).w
	beq.w	.2
	move.w	(cont1team).w,d0
	cmp.w	(cont2team).w,d0
	bne.w	.0
	eori.w	#1,(goaliemode2).w
	bra.w	.1
.0
	btst	#1,(sflags).w
	beq.w	.1
	eori.w	#1,(goaliemode2).w
	bra.w	.2
.1
	eori.w	#1,(goaliemode1).w
.2
	btst	#0,(gmode2).w
	bne.w	.3
	btst	#2,(BA_PS_flags).w
	beq.w	.x
.3
	btst	#1,(sflags).w
	bne.w	.8
	cmpi.w	#2,(OptNOP).w
	bne.w	.4
	cmpi.w	#5,(BA_Sktr_SCnum).w
	bgt.w	.x
	bra.w	.5
.4
	cmpi.w	#5,(BA_Sktr_SCnum).w
	ble.w	.x
.5
	move.w	#0,d0
	cmpi.w	#2,(OptNOP).w
	bne.w	.6
	move.w	#6,d0
.6
	tst.w	(goaliemode1).w
	bne.w	.7
	move.w	#5,d0
	cmpi.w	#2,(OptNOP).w
	bne.w	.7
	move.w	#$B,d0
.7
	jsr	(setc1player).l
	bra.w	.x
.8
	cmpi.w	#2,(OptNOP).w
	bne.w	.9
	cmpi.w	#5,(BA_Sktr_SCnum).w
	ble.w	.x
	bra.w	.10
.9
	cmpi.w	#5,(BA_Sktr_SCnum).w
	bgt.w	.x
.10
	move.w	#6,d0
	tst.w	(goaliemode2).w
	bne.w	.11
	move.w	#$B,d0
.11
	jsr	(setc2player).l
.x
	movem.l	(sp)+,d0-d7/a0-a6
	rts
RunArenaAnim	;IDA: sub_FE2C8. 94 only. Run the arena animation arenaanim (negative: none): the first time, its frame list and graphics from ArenaAnims
	;(arenaframelist / arenaspritelist, tiles to VRAM d4 = arenaanimchars: DoDMA_clearCallbackPointer); then count down the frame time arenaframetime by d7
	;and step (NextArenaFrame). Called from periodicevents (hockey94_01) and waitxsr (middle94_1)
	tst.w	(arenaanim).w
	bmi.w	.x2
	movem.l	d0-d7/a0-a6,-(sp)
	tst.l	(arenaspritelist).w
	bne.w	.0
	move.w	(arenaanim).w,d0
	asl.w	#3,d0
	movea.l	#ArenaAnims,a0
	move.l	0(a0,d0.w),(arenaframelist).w
	move.l	4(a0,d0.w),(arenaspritelist).w
	movea.l	4(a0,d0.w),a2
	addq.w	#8,a2
	move.w	(arenaanimchars).w,d4
	jsr	(DoDMA_clearCallbackPointer).l
	clr.w	(arenaframeidx).w
	bsr.w	NextArenaFrame
	bra.w	.x
.0	;IDA: loc_FE310
	sub.w	d7,(arenaframetime).w
	bpl.w	.x
	addq.w	#1,(arenaframeidx).w
	bsr.w	NextArenaFrame
.x	;IDA: loc_FE320
	movem.l	(sp)+,d0-d7/a0-a6
.x2	;IDA: locret_FE324
	rts
NextArenaFrame	;IDA: sub_FE326. 94 only. Read frame arenaframeidx of the list: arenaframe = frame, arenaframetime = time; frame $FF loops to the start, $FE ends the animation (EndArenaAnim)
	movea.l	(arenaframelist).w,a0
	move.w	(arenaframeidx).w,d0
	add.w	d0,d0
	move.b	0(a0,d0.w),d1
	ext.w	d1
	move.w	d1,(arenaframe).w
	move.b	1(a0,d0.w),d1
	ext.w	d1
	move.w	d1,(arenaframetime).w
	cmpi.w	#$FFFF,(arenaframe).w
	bne.w	.0
	clr.w	(arenaframeidx).w
	bra.s	NextArenaFrame
.0	;IDA: loc_FE354
	cmpi.w	#$FFFE,(arenaframe).w
	bne.w	.x
	bsr.w	EndArenaAnim
.x	;IDA: locret_FE362
	rts
ArenaAnims	;IDA: unk_FE364. The 8 arena animations (StartArenaAnim d0): frame list, then the graphics in graphics94 ArenaGfxBank (sprite list at 4(x), tiles at 8(x))
	dc.l	ArenaFrames8,$EA2EC
	dc.l	ArenaFrames6,$EAB10
	dc.l	ArenaFrames7,$EAB10
	dc.l	ArenaFrames5,$EB816
	dc.l	ArenaFrames4,$EC284
	dc.l	ArenaFrames3,$EC284
	dc.l	ArenaFrames2,$ED1B0
	dc.l	ArenaFrames1,$ED1B0
ArenaFrames1	;no IDA label (was unk_FE3A4). ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,$A,2,$A,3,$A,4,$A,5,$A,6,$A,7,$A,8,$A
	dc.b	9,$A,$A,$A,1,$A,2,$A,3,$A,4,$A,5,$A,6,$A
	dc.b	7,$A,8,$A,9,$A,$A,$A,1,$A,2,$A,3,$A,4,$A
	dc.b	5,$A,6,$A,7,$A,8,$A,9,$A,$A,$A,$FE,0
ArenaFrames2	;no IDA label (was unk_FE3E2). ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,$A,2,$A,3,$A,4,$A,5,$A,6,$A,7,$A,8,$A
	dc.b	9,$A,$A,$A,$FF,0
ArenaFrames3	;no IDA label (was unk_FE3F8). ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,$A,2,$A,3,$A,4,$A,5,$A,6,$A,7,$A,8,$A
	dc.b	9,$A,$A,$A,$B,$A,$C,$A,$D,$A,$E,$A,$F,$A,$10,$A
	dc.b	$11,$A,$12,$A,$13,$A,$14,$A,$15,$A,$16,$A,$17,$A,$FE,0
ArenaFrames4	;no IDA label (was unk_FE428). ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,8,2,8,3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C
	dc.b	3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C
	dc.b	3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C
	dc.b	3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C
	dc.b	3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C
	dc.b	2,8,1,8,$FF,0
ArenaFrames5	;no IDA label (was unk_FE47E). ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,8,2,8,3,8,4,8,5,8,6,8,7,8,8,8
	dc.b	$FF,0
ArenaFrames6	;no IDA label (was unk_FE490). ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,8,2,8,3,8,4,$1E,5,8,6,8,7,8,8,$1E
	dc.b	5,8,6,8,7,8,8,$1E,9,8,$A,8,$B,8,$C,8
	dc.b	$D,8,$E,8,$FE,0
ArenaFrames7	;no IDA label (was unk_FE4B6). ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	$F,8,$10,8,$11,8,$12,$1E,$13,8,$14,8,$15,8,$16,$1E
	dc.b	$13,8,$14,8,$15,8,$16,$1E,$17,8,$18,8,$19,8,$1A,8
	dc.b	$1B,8,$1C,8,$FE,0
ArenaFrames8	;no IDA label (was unk_FE4DC). ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,$A,2,$A,3,$A,4,$A,5,$A,6,$A,7,$A,8,$A
	dc.b	9,$A,$A,$A,$B,$A,$C,$A,$D,$A,$E,$A,$F,$7F,$FE,0
SetCameraTop	;no IDA label (was sub_FE4FC), and nothing calls it (IDA left it as data). sflags bit 6, xc1 = 0, yc1 = $160
	bset	#6,(sflags).w
	move.w	#0,(xc1).w
	move.w	#$160,(yc1).w
	rts
StartArenaAnim	;IDA: sub_FE510. 94 only. Start arena animation d0 (ArenaAnims): arenaanim = d0, RunArenaAnim loads it. Called from FallDown (hockey94_03, 7),
	;DisplayPlayerAttributeMenu (hockey94_10, 0 on a home hat trick) and puckfaceoff2 (logic94_4, the one SetFaceoffAnim set)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	d0,(arenaanim).w
	move.l	#0,(arenaframelist).w
	move.l	#0,(arenaspritelist).w
	move.w	#1,(arenaframe).w
	clr.w	(arenaframeidx).w
	st	(faceoffanim).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
SetFaceoffAnim	;IDA: sub_FE53C. 94 only. Set the faceoff animation: sflags7 bit 0, faceoffanim = d0. Called from puckfaceoff (logic94_4)
	bset	#0,(sflags7).w
	move.w	d0,(faceoffanim).w
	rts
EndArenaAnim	;IDA: sub_FE548. 94 only. End the arena animation: arenaanim = -1, sflags7 bit 0 cleared. Called from NextArenaFrame and puckfaceoff2 (logic94_4)
	move.w	#$FFFF,(arenaanim).w
	bclr	#0,(sflags7).w
	rts
ChooseSong	;IDA name. 94 only: SongNum = byte SongIndex of the 6 song bytes of team HmTeam (TeamSongs), or one of the 8 of RandomSongs at random
	;when 0; $FFFF with gmode bit 4. Called from StartPer (hockey94_01), checkgoal (hockey94_04), puckshootout (logic94_4) and LeadSong
	movem.l	d0-d1/a0-a1,-(sp)
	btst	#4,(gmode).w
	beq.w	.0
	move.w	#$FFFF,d1
	bra.w	.1
.0	;IDA: loc_FE56C
	bclr	#6,(sflags8).w
	movea.l	#TeamSongs,a0
	movea.l	#RandomSongs,a1
	move.w	(HmTeam).w,d0
	mulu.w	#6,d0
	add.w	(SongIndex).w,d0
	clr.w	d1
	move.b	0(a0,d0.w),d1
	bne.w	.1
	move.w	#8,d0
	jsr	(randomd0).l
	andi.w	#7,d0
	move.b	0(a1,d0.w),d1
.1	;IDA: loc_FE5A6
	move.w	d1,(SongNum).w
	movem.l	(sp)+,d0-d1/a0-a1
	rts
TeamSongs	;IDA: unk_FE5B0. ChooseSong: 6 songs per team (TeamList order), 0 = random (RandomSongs)
	dc.b	$77,$75,$76,0,$5A,0
	dc.b	$31,$32,$30,0,$5A,$31
	dc.b	$34,$33,$33,$34,$5A,0
	dc.b	$35,$37,$35,$37,$36,$36
	dc.b	$38,$3A,$39,$38,$5A,$65
	dc.b	$4A,$4B,$4B,0,$5A,0
	dc.b	$3B,$3C,$3D,0,$5A,$3C
	dc.b	$3E,$3F,$3F,0,$5A,0
	dc.b	$77,$75,$76,0,$5A,0
	dc.b	$40,$42,$41,$42,$5A,$40
	dc.b	$43,$43,$45,$44,$5A,$46
	dc.b	$4F,$4E,$4F,$4D,$5A,$4C
	dc.b	$50,$51,$50,0,$5A,$52
	dc.b	$47,$48,$47,$49,$5A,$49
	dc.b	$54,$55,$53,0,$5A,0
	dc.b	$77,$75,$76,0,$5A,0
	dc.b	$56,$57,$56,$58,0,$58
	dc.b	$59,$5B,$59,$5C,$5A,$5C
	dc.b	$5D,$5E,$5D,0,$5A,$5E
	dc.b	$5F,$60,$61,$63,$64,$65
	dc.b	$67,$68,$68,$67,$5A,$69
	dc.b	$6A,$6B,$6B,0,$5A,0
	dc.b	$6C,$6C,$6D,0,$5A,0
	dc.b	$6E,$6F,$70,0,$5A,0
	dc.b	$71,$73,$71,0,$5A,$74
	dc.b	$77,$75,$76,0,$5A,0
	dc.b	$54,$55,$53,0,$5A,0
	dc.b	$54,$55,$53,0,$5A,0
RandomSongs	;IDA: unk_FE658. ChooseSong: the 8 songs for a random pick
	dc.b	$34,$40,$42,$49,$58,$5C,$65,$66
ReadLineData	;IDA: sub_FE660. 94 only. Read the $100 bytes at save RAM $1EF6 to databuffer (ReadSRAM); sflags bit 4 cleared, lastsfx = -1, recbpr = $FFFF0000. Called from Begin (hockey94_01) and
	;GameSetUp (hockey94_08)
	movem.l	d0-d1/a0,-(sp)
	move.l	#$100,d1
	move.l	#$1EF6,d0
	movea.l	#databuffer,a0
	jsr	(ReadSRAM).l
	bclr	#4,(sflags).w
	move.w	#$FFFF,(lastsfx).w
	move.l	#M68K_RAM,(recbpr).w
	movem.l	(sp)+,d0-d1/a0
	rts
WriteLineData	;IDA: sub_FE696. 94 only. Write databuffer back to save RAM $1EF6 (WriteSRAM, MakeSRAMChecksum); as ReadLineData after. Called from EncodePW (hockey94_09) and EncodePlayerAttributes
	;(stats94)
	movem.l	d0-d1/a0,-(sp)
	move.l	#$100,d1
	move.l	#$1EF6,d0
	movea.l	#databuffer,a0
	jsr	(WriteSRAM).l
	jsr	(MakeSRAMChecksum).l
	bclr	#4,(sflags).w
	move.w	#$FFFF,(lastsfx).w
	move.l	#M68K_RAM,(recbpr).w
	movem.l	(sp)+,d0-d1/a0
	rts
ClearWinRecords	;IDA: sub_FE6D2. 94 only. Clear bytes 8-$B of the 8 ThreeStars records and write the $80 bytes to save RAM $D20 (WriteSRAM, MakeSRAMChecksum). Called from RecordHoldersScreen
	;(high94_2, Record Holders)
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#ThreeStars,a0
	move.w	#7,d7
.loop	;IDA: loc_FE6E0
	clr.b	8(a0)
	clr.b	9(a0)
	clr.b	$A(a0)
	clr.b	$B(a0)
	adda.w	#$10,a0
	dbf	d7,.loop
	move.l	#$D20,d0
	move.l	#$80,d1
	movea.l	#ThreeStars,a0
	jsr	(WriteSRAM).l
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
PSandSOpassdir	;IDA name (and comments). 94 only: penalty shot / shootout: passdir = sopathdir (the end of the skate path, NextPathPoint), turned by
	;passdirlist for the bottom net. Called from shotdiradj (logic94_1)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(sopathdir).w,d0
	btst	#7,$62(a3)	;check what net shooting at
	bne.w	.0	;branch if top net
	movea.l	#passdirlist,a0
	add.w	d0,d0
	move.w	0(a0,d0.w),d0
.0	;IDA: loc_FE73A
	move.w	d0,(passdir).w	;move d0 into passdir
	movem.l	(sp)+,d0-d7/a0-a6
	rts
passdirlist	dc.w	0	;IDA name. PSandSOpassdir: passdir for the other net
	dc.w	7
	dc.w	6
	dc.w	5
	dc.w	4
	dc.w	3
	dc.w	2
	dc.w	1
	dc.w	8
StartShootoutPath	;IDA: sub_FE756. 94 only. Shootout: pick one of the 7 skate paths (ShootoutPaths) at random (sopath) and start it (NextPathPoint). Called from NextShooter (high94_2) and
	;puckshootout (logic94_4)
	movem.l	d0-d7/a0-a6,-(sp)
.loop	;IDA: loc_FE75A
	move.w	#7,d0
	jsr	(randomd0).l
	cmp.w	#6,d0
	bgt.s	.loop
	move.w	d0,(sopath).w
	bclr	#3,(sflags7).w
	move.w	#$FFFF,(sopathpoint).w
	clr.w	(sopathx).w
	bsr.w	NextPathPoint
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ShootoutPaths	;IDA: unk_FE788. The 7 shootout skate paths (NextPathPoint)
	dc.l	ShootoutPath1
	dc.l	ShootoutPath2
	dc.l	ShootoutPath3
	dc.l	ShootoutPath4
	dc.l	ShootoutPath5
	dc.l	ShootoutPath6
	dc.l	ShootoutPath7
ShootoutPath1	;no IDA label (was unk_FE7A4). ShootoutPaths path: x, y points; $80 in the high byte ends it (low byte: sopathend, then sopathdir)
	dc.w	$10,$E2,$10,$D0,$8020,5
ShootoutPath2	;no IDA label (was unk_FE7B0). ShootoutPaths path: x, y points; $80 in the high byte ends it (low byte: sopathend, then sopathdir)
	dc.w	$FFC9,$A0,$FFFF,$C8,$FFE0,$D0,$8020,5
ShootoutPath3	;no IDA label (was unk_FE7C0). ShootoutPaths path: x, y points; $80 in the high byte ends it (low byte: sopathend, then sopathdir)
	dc.w	$FFB0,$40,$1A,$BC,$8020,5
ShootoutPath4	;no IDA label (was unk_FE7CC). ShootoutPaths path: x, y points; $80 in the high byte ends it (low byte: sopathend, then sopathdir)
	dc.w	$FFCE,$58,$14,$D0,$802C,5
ShootoutPath5	;no IDA label (was unk_FE7D8). ShootoutPaths path: x, y points; $80 in the high byte ends it (low byte: sopathend, then sopathdir)
	dc.w	$FFCE,8,$20,$D0,$8028,6
ShootoutPath6	;no IDA label (was unk_FE7E4). ShootoutPaths path: x, y points; $80 in the high byte ends it (low byte: sopathend, then sopathdir)
	dc.w	$1C,$F4,8,$E0,$8020,6
ShootoutPath7	;no IDA label (was unk_FE7F0). ShootoutPaths path: x, y points; $80 in the high byte ends it (low byte: sopathend, then sopathdir)
	dc.w	$FFE6,$F8,0,$E0,$8020,2
NextPathPoint	;IDA: sub_FE7FC. 94 only. Next point of shootout path sopath (sopathpoint): sopathx / sopathy = x (turned by bit 0 of $76(a3)) / y; at
	;the end ($80) sflags7 bit 3, sopathend and sopathdir (passdir)
	movem.l	d0-d7/a0-a6,-(sp)
	cmpi.b	#$80,(sopathx).w
	beq.w	.x
	addq.w	#1,(sopathpoint).w
	move.w	(sopathpoint).w,d0
	asl.w	#2,d0
	movea.l	#ShootoutPaths,a0
	move.w	(sopath).w,d1
	asl.w	#2,d1
	movea.l	0(a0,d1.w),a0
	move.w	0(a0,d0.w),(sopathx).w
	btst	#0,$76(a3)
	beq.w	.0
	neg.w	(sopathx).w
.0	;IDA: loc_FE838
	move.w	2(a0,d0.w),(sopathy).w
	cmpi.b	#$80,4(a0,d0.w)
	bne.w	.x
	bset	#3,(sflags7).w
	clr.w	(sopathend).w
	move.b	5(a0,d0.w),(sopathend+1).w
	move.w	6(a0,d0.w),(sopathdir).w
.x	;IDA: loc_FE85E
	movem.l	(sp)+,d0-d7/a0-a6
	rts
SkatePath	;IDA: sub_FE864. 94 only. Shootout skate path: d0 / d1 = the point (mirrored for the bottom net); within $A of it ($12 while $28 / $2A(a3) are 0) take
	;the next one (NextPathPoint). Called from asspuckc (logic94_3)
	movem.l	d2-d7/a0-a6,-(sp)
	cmpi.b	#$80,(sopathx).w
	beq.w	.x
	move.w	(sopathx).w,d0
	move.w	(sopathy).w,d1
	btst	#7,$62(a3)
	bne.w	.0
	neg.w	d0
	neg.w	d1
.0	;IDA: loc_FE888
	sub.w	(a3),d0
	bpl.w	.1
	neg.w	d0
.1	;IDA: loc_FE890
	tst.w	$28(a3)
	bne.w	.2
	tst.w	$2A(a3)
	bne.w	.2
	cmp.w	#$12,d0
	ble.w	.3
.2	;IDA: loc_FE8A8
	cmp.w	#$A,d0
	bgt.w	.7
.3	;IDA: loc_FE8B0
	sub.w	$14(a3),d1
	bpl.w	.4
	neg.w	d1
.4	;IDA: loc_FE8BA
	tst.w	$28(a3)
	bne.w	.5
	tst.w	$2A(a3)
	bne.w	.5
	cmp.w	#$12,d1
	ble.w	.6
.5	;IDA: loc_FE8D2
	cmp.w	#$A,d1
	bgt.w	.7
.6	;IDA: loc_FE8DA
	bsr.w	NextPathPoint
.7	;IDA: loc_FE8DE
	move.w	(sopathx).w,d0
	move.w	(sopathy).w,d1
.x	;IDA: loc_FE8E6
	movem.l	(sp)+,d2-d7/a0-a6
	rts
ShootoutShootCheck	;IDA: sub_FE8EC. 94 only. Shootout, skater a3 has the puck (gmode2 bit 1): Z set (d0 is restored) = shoot now: after 3 (shootoutclock) at the path
	;end, within sopathend of its last point, or with the puck stopped before $F. Called from asspuckc (logic94_3)
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#1,(gmode2).w
	beq.w	.5
	move.w	$52(a3),d0
	cmp.w	(puckc).w,d0
	bne.w	.5
	cmpi.w	#3,(shootoutclock).w
	ble.w	.4
	cmpi.b	#$80,(sopathx).w
	beq.w	.4
	btst	#3,(sflags7).w
	bne.w	.0
	tst.w	(puckvx).w
	bne.w	.5
	tst.w	(puckvy).w
	bne.w	.5
	cmpi.w	#$F,(shootoutclock).w
	blt.w	.4
	bra.w	.5
.0	;IDA: loc_FE942
	move.w	(sopathx).w,d0
	move.w	(sopathy).w,d1
	btst	#7,$62(a3)
	bne.w	.1
	neg.w	d0
	neg.w	d1
.1	;IDA: loc_FE958
	sub.w	(a3),d0
	bpl.w	.2
	neg.w	d0
.2	;IDA: loc_FE960
	sub.w	$14(a3),d1
	bpl.w	.3
	neg.w	d1
.3	;IDA: loc_FE96A
	cmp.w	(sopathend).w,d0
	bgt.w	.5
	cmp.w	(sopathend).w,d1
	bgt.w	.5
.4	;IDA: loc_FE97A
	clr.w	d0
	bra.w	.x
.5	;IDA: loc_FE980
	move.w	#1,d0
.x	;IDA: loc_FE984
	movem.l	(sp)+,d0-d7/a0-a6
	rts
UnpackPicture	;IDA: sub_FE98A. 94 only. Unpack a picture a2: count.w, then 3 bytes per row of 8 pixels to 4 bit pixels + 5 at picturebuf (count first). Called from
	;DrawPictureBox (high94_2), DrawMatchupPicture (hockey94_07) and PlayerCardScreen (hockey94_08)
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#picturebuf,a0
	movea.l	#picturebits,a1
	move.w	(a2)+,d0
	move.w	d0,(a0)+
	asl.w	#3,d0
	subq.w	#1,d0
.loop	;IDA: loc_FE9A2
	clr.l	(a0)
	clr.l	(a1)
	move.b	(a2)+,(a1)
	move.b	(a2)+,1(a1)
	move.b	(a2)+,2(a1)
	move.l	#0,-(sp)
	move.l	(a1),d2
	andi.l	#$E0000000,d2
	lsr.l	#1,d2
	addi.l	#$50000000,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$1C000000,d2
	lsr.l	#2,d2
	addi.l	#$5000000,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$3800000,d2
	lsr.l	#3,d2
	addi.l	#$500000,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$700000,d2
	lsr.l	#4,d2
	addi.l	#$50000,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$E0000,d2
	lsr.l	#5,d2
	addi.l	#$5000,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$1C000,d2
	lsr.l	#6,d2
	addi.l	#$500,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$3800,d2
	lsr.l	#7,d2
	addi.l	#$50,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$700,d2
	move.w	#8,d5
	lsr.l	d5,d2
	addq.l	#5,d2
	or.l	d2,(sp)
	move.l	(sp)+,(a0)+
	dbf	d0,.loop
	movem.l	(sp)+,d0-d7/a0-a6
	rts
LoadHomeTeamGfx	;IDA: sub_FEA52. 94 only. Load the HomeTeam graphics of TeamGfxList to VRAM d4 - $18 (DoDMA_clearCallbackPointer). Called from setupice (hockey94_06), ClrHor (penalty94_1) and
	;ReloadRinkGraphics (stats94)
	move.w	d0,-(sp)
	subi.w	#$18,d4
	movea.l	#TeamGfxList,a2
	move.w	(HomeTeam).w,d0
	asl.w	#2,d0
	movea.l	0(a2,d0.w),a2
	addq.w	#8,a2
	jsr	(DoDMA_clearCallbackPointer).l
	move.w	(sp)+,d0
	rts
TeamGfxList	;IDA: unk_FEA74. LoadHomeTeamGfx: one address per team (TeamList order) in graphics94 ArenaGfxBank
	dc.l	$EDE8A,$F2A84,$EE194,$EE49E
	dc.l	$EE7A8,$EEAB2,$EEDBC,$EF0C6
	dc.l	$EF3D0,$EF6DA,$EF9E4,$EFCEE
	dc.l	$EFFF8,$F0302,$F060C,$F0916
	dc.l	$F0C20,$F0F2A,$F1234,$F153E
	dc.l	$F1848,$F1B52,$F1E5C,$F2166
	dc.l	$F2470,$F277A,$F2D8E,$F2D8E
PrintPlayerAssists	;IDA: sub_FEAE4. 94 only. Print " (n)": byte $CE + d0 of team a2, then the next row at x $E. Called from DisplayPlayerAttributeMenu (hockey94_10)
	movem.l	d0/a2,-(sp)
	jsr	(printz).l
	String	' ('
	adda.w	#$CE,a2
	bra.w	PrintParenNumber
PrintPlayerGoals	;IDA: sub_FEAFA. 94 only. As PrintPlayerAssists with byte $B4 + d0. Called from DisplayPlayerAttributeMenu (hockey94_10)
	movem.l	d0/a2,-(sp)
	jsr	(printz).l
	String	' ('
	adda.w	#$B4,a2
PrintParenNumber	;IDA: loc_FEB0C. IDA label. PrintPlayerAssists / PrintPlayerGoals: the number (1 to 3 digits, PushNumberWidth) and ")"
	move.b	0(a2,d0.w),d0
	ext.w	d0
	move.w	#1,d1
	cmp.w	#9,d0
	ble.w	.0
	move.w	#2,d1
	cmp.w	#$63,d0
	ble.w	.0
	move.w	#3,d1
.0	;IDA: loc_FEB2E
	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l
	String	')'
	addq.w	#1,(printy).w
	move.w	#$E,(printx).w
	movem.l	(sp)+,d0/a2
	rts
PlaceBoardFall	;IDA: sub_FEB54. 94 only. A player falling into the boards (frames94 SPAboardtop ... SPAboardmidl). For frames $1776 / $185A (y to $124 / $FEDC, or $116 / $FEEA by FallXPos) and $17E8
	;/ $1A00 / $18CC / $193E (x to +-$82 /
	;$88 by bit 3 of 4(a3)) of $58(a3): move player a3 half way there. Called from updateplayers (hockey94_02)
	cmpi.w	#$193E,$58(a3)
	beq.w	.12
	cmpi.w	#$1A00,$58(a3)
	beq.w	.8
	cmpi.w	#$18CC,$58(a3)
	beq.w	.10
	cmpi.w	#$17E8,$58(a3)
	beq.w	.6
	cmpi.w	#$1776,$58(a3)
	beq.w	.0
	cmpi.w	#$185A,$58(a3)
	beq.w	.3
	bra.w	.x
.0	;IDA: loc_FEB94
	move.w	#$124,d0
	cmpi.w	#$56,(FallXPos).w
	bgt.w	.1
	cmpi.w	#$FFAA,(FallXPos).w
	bgt.w	.2
.1	;IDA: loc_FEBAC
	move.w	#$116,d0
.2	;IDA: loc_FEBB0
	sub.w	$14(a3),d0
	bmi.w	.x
	asr.w	#1,d0
	add.w	d0,$14(a3)
	bra.w	.x
.3	;IDA: loc_FEBC2
	move.w	#$FEDC,d0
	cmpi.w	#$56,(FallXPos).w
	bgt.w	.4
	cmpi.w	#$FFAA,(FallXPos).w
	bgt.w	.5
.4	;IDA: loc_FEBDA
	move.w	#$FEEA,d0
.5	;IDA: loc_FEBDE
	sub.w	$14(a3),d0
	bpl.w	.x
	asr.w	#1,d0
	add.w	d0,$14(a3)
	bra.w	.x
.6	;IDA: loc_FEBF0
	move.w	#$82,d0
	btst	#3,4(a3)
	beq.w	.7
	move.w	#$FF7E,d0
.7	;IDA: loc_FEC02
	sub.w	(a3),d0
	asr.w	#1,d0
	add.w	d0,(a3)
	bra.w	.x
.8	;IDA: loc_FEC0C
	move.w	#$88,d0
	btst	#3,4(a3)
	beq.w	.9
	move.w	#$FF78,d0
.9	;IDA: loc_FEC1E
	sub.w	(a3),d0
	asr.w	#1,d0
	add.w	d0,(a3)
	bra.w	.x
.10	;IDA: loc_FEC28
	move.w	#$FF7E,d0
	btst	#3,4(a3)
	beq.w	.11
	move.w	#$82,d0
.11	;IDA: loc_FEC3A
	sub.w	(a3),d0
	asr.w	#1,d0
	add.w	d0,(a3)
	bra.w	.x
.12	;IDA: loc_FEC44
	move.w	#$FF78,d0
	btst	#3,4(a3)
	beq.w	.13
	move.w	#$88,d0
.13	;IDA: loc_FEC56
	sub.w	(a3),d0
	asr.w	#1,d0
	add.w	d0,(a3)
.x	;IDA: locret_FEC5C
	rts
GetLeagueCrowdRecord	;IDA: sub_FEC5E. 94 only. d0 = the team (of 28) with the highest crowd record byte 8 (clrCrowdRAM; 0 counts as $50). Called from DisplayGameStats (stats94)
	movem.l	d1-d7/a0-a6,-(sp)
	move.w	#$1B,d1
	ext.l	d1
	clr.w	d7
	movea.l	#ThreeStars,a0
.loop	;IDA: loc_FEC70
	jsr	(clrCrowdRAM).l
	clr.w	d2
	move.b	8(a0),d2
	bne.w	.0
	move.w	#$50,d2
.0	;IDA: loc_FEC84
	cmp.w	d7,d2
	ble.w	.1
	move.w	d2,d7
	move.w	d1,d0
.1	;IDA: loc_FEC8E
	dbf	d1,.loop
	movem.l	(sp)+,d1-d7/a0-a6
	rts
getFgtbyte	;IDA name (and comments). 94 only. Called from setInjuryType (hockey94_03)
	clr.w	d0	;clear d0
	move.b	$74(a2),d0	;move H/F bit into d0 (this is always even)
	lsr.w	#2,d0	;shift 2 right (divide by 4)
	rts
chkFgtBit1	;IDA name. 94 only: test bit 1 of $74(a2). Called from setInjuryType (hockey94_03)
	btst	#1,$74(a2)
	rts
RandomFaceoffAnim	;IDA: sub_FECAA. 94 only. d0 = a random faceoff animation from FaceoffAnims (StartArenaAnim), 6 when fox <= -$40 and foy <= $C0. Called from puckfaceoff (logic94_4)
	movem.l	a0,-(sp)
	movea.l	#FaceoffAnims,a0
	move.w	#$64,d0
	jsr	(randomd0).l
	andi.w	#7,d0
	add.w	d0,d0
	move.w	0(a0,d0.w),d0
	cmpi.w	#$FFC0,(fox).w
	bgt.w	.x
	cmpi.w	#$C0,(foy).w
	bgt.w	.x
	move.w	#6,d0
.x	;IDA: loc_FECE0
	movem.l	(sp)+,a0
	rts
FaceoffAnims	;IDA: unk_FECE6. RandomFaceoffAnim animations
	dc.w	3,5,3,1,5,2,3,3,$FFFF
CheckScoreLeader	;IDA: sub_FECF8. 94 only. Compare the scores ($24 of HmShots / AwShots) and test $28 of the leader for $13; the result is not used (bne.w *+4). Called from puckfaceoff (logic94_4)
	movem.l	d0-d2/a0-a2,-(sp)
	movea.l	#HmShots,a0
	movea.l	#AwShots,a1
	move.w	$24(a0),d0
	sub.w	$24(a1),d0
	beq.w	.x
	bpl.w	.0
	exg	a0,a1
.0	;IDA: loc_FED1A
	cmpi.w	#$13,$28(a0)
	bne.w	*+4
.x	;IDA: loc_FED24
	movem.l	(sp)+,d0-d2/a0-a2
	rts
DrawPlayoffSprite	;IDA: sub_FED2A. 94 only. The PlayoffSprite sprite at playoffspritex / playoffspritey (SetSframe) in Satt, then end the sprite list (Sattsize = its size). Called from PlayoffScreen
	;(hockey94_06)
	movea.w	#(Satt-M68K_RAM),a6
	moveq	#1,d6
	movea.l	#PlayoffSprite,a0
	move.w	(energybarchars).w,d3
	ori.w	#$8000,d3
	move.w	(playoffspritex).w,d0
	move.w	(playoffspritey).w,d1
	move.w	#1,d2
	jsr	(SetSframe).l
	cmpa.w	#$C018,a6
	bne.w	.0
	clr.l	(a6)+
	clr.l	(a6)+
.0	;IDA: loc_FED5C
	clr.b	-5(a6)
	move.l	a6,d0
	subi.l	#Satt,d0
	lsr.w	#1,d0
	move.w	d0,(Sattsize).w
	rts
HiScoreScreen	;IDA name. 94 only: vb2, the $F4378 bitmap and HiScoreImg, then wait up to $50 * 4 frames or a button (waitx). Called from Begin (hockey94_01, attract mode)
	move.l	#vb2,(vbint).w
	bclr	#1,(disflags).w
	move.w	#5,(Map3col1).w
	move.w	#$A000,(VmMap2).w
	move.w	#7,(Map2col1).w
	move.w	#$C000,(VmMap1).w
	move.w	#7,(Map1col1).w
	move.w	#$F000,(VmMap3).w
	move.w	#$F800,(VSPRITES).w
	move.w	#$FC00,(VSCRLPM).w
	jsr	(forceblack).l
	movea.w	#(palfadenew-M68K_RAM),a0
	moveq	#$1F,d1
.loop	;IDA: loc_FEDBA
	clr.l	(a0)+
	dbf	d1,.loop
	jsr	(setVram_0).l
	jsr	(printz).l
	String	$BE,$E,3
	movea.l	#$F4378,a2
	movea.l	a2,a0
	movea.l	a2,a1
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	clr.w	d4
	moveq	#$F,d5
	jsr	(dobitmap).l
	jsr	(printz).l
	String	$BE,$10,$10
	movea.l	#HiScoreImg,a2
	movea.l	a2,a0
	movea.l	a2,a1
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#0,d5
	jsr	(dobitmap).l
	move.w	#$18,(palcount).w
	move	#$2500,sr
	move.w	#$50,(RNGseed).w
.loop2	;IDA: loc_FEE30
	moveq	#4,d0
	jsr	(waitx).l
	tst.w	d1
	bne.w	.0
	subq.w	#1,(RNGseed).w
	bpl.s	.loop2
.0	;IDA: loc_FEE44
	move	#$2700,sr
	rts
GetTeamStruct	;IDA: sub_FEE4A. 94 only. a2 = HmShots, or AwShots when team d2 is not $28 of HmShots. Called from PrintStartingLine (high94_2)
	movea.l	#HmShots,a2
	cmp.w	$28(a2),d2
	beq.w	.x
	movea.l	#AwShots,a2
.x	;IDA: locret_FEE5E
	rts
CountButtonPress	;IDA: sub_FEE60. 94 only. Not in gmode bit 0: add 1 to homepresses (awaypresses for d4), and to the next long unless TempWord1 is 8 or $54(a3). Called from doinput_ispc
	;(logic94_1)
	movem.l	d1-d7/a0,-(sp)
	btst	#0,(gmode).w
	bne.w	.x
	move.w	(TempWord1).w,d1
	movea.l	#homepresses,a0
	tst.w	d4
	beq.w	.0
	movea.l	#awaypresses,a0
.0	;IDA: loc_FEE84
	addq.l	#1,(a0)
	cmp.w	#8,d1
	beq.w	.x
	cmp.w	$54(a3),d1
	beq.w	.x
	addq.l	#1,4(a0)
.x	;IDA: loc_FEE9A
	movem.l	(sp)+,d1-d7/a0
	rts
TerminateLogName	;no IDA label (was sub_FEEA0), and nothing calls it (IDA left it as data). The GetLogName String at lognametext, ended with 0 at namelength and its length word made even
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#lognametext,a1
	bsr.w	GetLogName
	move.w	(namelength).w,d0
	move.b	#0,(a1,d0.w)
	addq.w	#1,d0
	andi.w	#$FFFE,d0
	move.w	d0,-2(a1)
	movem.l	(sp)+,d0-d7/a0-a6
	rts
PlayedByHome	;IDA: sub_FEEC8. 94 only. a1 = String "(played by NAME)" for homeuser (GetLogName name), or an empty String for 0. Called from ScoutTextPlayer (hockey94_06)
	movem.l	d0-d7/a0/a2-a6,-(sp)
	move.w	(homeuser).w,d0
PlayedByText	;IDA: loc_FEED0. IDA label. PlayedByHome / PlayedByAway body
	tst.w	d0
	beq.w	PlayedByNone
	movea.l	#nameentrybuf+2,a1
	move.w	d0,(namelogsel).w
	bsr.w	GetLogName
	adda.w	(namelength).w,a1
	move.b	#0,(a1)
	addq.w	#1,(namelength).w
	andi.w	#$FFFE,(namelength).w
	addq.w	#2,(namelength).w
	move.w	(namelength).w,(nameentrybuf).w
	movea.l	#nameentrybuf,a1
	move.l	a1,-(sp)
	movea.l	#TempBuffer,a3
	movea.l	#PlayedByTxt,a1
	bsr.w	StartText
	movea.l	(sp)+,a1
	movea.l	#TempBuffer,a3
	jsr	(appstring).l
	movea.l	#TempBuffer,a3
	jsr	(appendz).l
	String	')'
	movea.l	#TempBuffer,a1
PlayedByExit	;IDA: loc_FEF3C. IDA label. Exit
	movem.l	(sp)+,d0-d7/a0/a2-a6
	rts
PlayedByTxt	;IDA: unk_FEF42. PlayedByHome text
	String	'(played by '
PlayedByEmptyTxt	;IDA: unk_FEF50. PlayedByHome: the empty String
	dc.w	2	;empty String
PlayedByNone	;IDA: loc_FEF52. IDA label. PlayedByHome: no name
	movea.l	#PlayedByEmptyTxt,a1
	bra.s	PlayedByExit
PlayedByAway	;IDA: sub_FEF5A. 94 only. As PlayedByHome for awayuser. Called from ScoutTextPlayer (hockey94_06)
	movem.l	d0-d7/a0/a2-a6,-(sp)
	move.w	(awayuser).w,d0
	bra.w	PlayedByText
set_bit1_C2FE	;IDA name (and comments). 94 only. Called from updateplayers (hockey94_02)
	bra.w	.set
	bclr	#1,(sflags8).w
	bra.w	.ex
.set
	bset	#1,(sflags8).w	;set bit 1 of C2FE
.ex
	rts
AttribAdjust	;IDA name (and comments). 94 only: an attribute under $32 becomes d0 / 2 + $19. Called from DispAttribValue (stats94), PrintOverallRating (high94_2) and PrintMatchupRatings (hockey94_07)
	cmp.w	#$32,d0	;'2'   ; compare $32 to d0
	bge.w	.exit	;branch if greater than
	asr.w	#1,d0	;divide by 2
	addi.w	#$19,d0	;add $19 (25 dec)
.exit
	rts
PuckComingToward	;IDA: sub_FEF8C. nothing calls it. Z clear when the puck is within $1E of player a3 and moving toward him (x, then y); d0-d1 kept
	movem.w	d0-d1,-(sp)
	move.w	(puckx).w,d0
	sub.w	(a3),d0
	cmp.w	#$1E,d0
	bgt.w	.x
	move.w	(puckvx).w,d1
	eor.w	d1,d0
	andi.w	#$8000,d0
	beq.w	.x
	move.w	(pucky).w,d0
	sub.w	$14(a3),d0
	cmp.w	#$1E,d0
	bgt.w	.x
	move.w	(puckvy).w,d1
	eor.w	d1,d0
	andi.w	#$8000,d0
.x	;IDA: loc_FEFC6
	movem.w	(sp)+,d0-d1
	rts
ReadGoaliePulled	;IDA name (and comments). 94 only: Z clear when the team of a3 pulled its goalie ($26 of the team struct). Called from doshot
	;(logic94_1), assdefo (logic94_2), asspuckc (logic94_3) and assnearest (logic94_4)
	movem.l	a1,-(sp)
	movea.l	#HmShots,a1
	btst	#6,$62(a3)	;check if home or away 0=home 1=away
	beq.w	.chkgoalie
	movea.l	#AwShots,a1
.chkgoalie
	tst.w	$26(a1)
	movem.l	(sp)+,a1
	rts
EndOneTimer	;IDA: sub_FEFF0. 94 only. End a one-timer for a3: bits cleared, onetimerplayer = -1, SetSPA $50C, then assexit (goalie) or Setplass. Called from assonetimer (high94_1) and setass
	;(hockey94_04)
	movem.l	d0/a0,-(sp)
	bclr	#3,$64(a3)
	bclr	#5,$62(a3)
	bclr	#1,$63(a3)
	clr.w	(onetimerflags).w
	st	(onetimerplayer).w
	move.w	d1,-(sp)
	move.w	#$50C,d1
	jsr	(SetSPA).l
	tst.w	$34(a3)
	bpl.w	.0
	jsr	(assexit).l
	bra.w	.1
.0	;IDA: loc_FF02C
	jsr	(Setplass).l
.1	;IDA: loc_FF032
	clr.w	$5A(a3)
	st	$5C(a3)
	move.w	(sp)+,d1
	movem.l	(sp)+,d0/a0
	rts
newTitleScreen	;IDA name. 94 only: the title screen (TitleScreenImg, NHLShieldImg, PAlogoImg, TitleImg) with the vblank TitleVBlank, song $78, then the
	;scrolling credits ($5776, $57B8 text; CreditsPrintRow, CreditsWait) until start. Called from Opening (hockey94_06)
	move	#$2700,sr
	move.w	(VDP_CNTR).l,(RNGseed).w
	move.w	(VDP_CNTR).l,(RNGseed+2).w
	move.l	#TitleVBlank,(vbint).l
	bset	#1,(disflags).w
	move.w	#5,(Map3col1).w
	move.w	#$A000,(VmMap2).w
	move.w	#7,(Map2col1).w
	move.w	#$C000,(VmMap1).w
	move.w	#7,(Map1col1).w
	move.w	#$F000,(VmMap3).w
	move.w	#$F800,(VSPRITES).w
	move.w	#$FC00,(VSCRLPM).w
	move.w	#0,d0
	jsr	(setvram).l
	movea.l	#VDP_DATA,a0
	move.w	#$9100,4(a0)
	move.w	#$9217,4(a0)
	move.w	#$8B03,4(a0)
	clr.w	(Vscroll).w
	jsr	(printz).l
	String	$FF,0,0
	move.l	#$80,d0	;IDA hid this (and the Strings)
	moveq	#$20,d1
	move.l	#$7FF,d2
	jsr	(eraser).l
	jsr	(printz).l
	String	$FE,0,0
	move.l	#$80,d0
	moveq	#$20,d1
	move.l	#$7FF,d2
	jsr	(eraser).l
	clr.w	d4
	move.w	d4,-(sp)
	jsr	(printz).l
	String	$FD,0,0
	movea.l	#TitleScreenImg,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	#$17,d3
	moveq	#$F,d5
	jsr	(dobitmap).l
	move.w	d4,(TempWord1).w
	move.w	(sp)+,d4
	jsr	(printz).l
	String	$FE,0,$17
	movea.l	#TitleScreenImg,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	move.w	#$17,d1
	move.w	(a1),d2
	move.w	#5,d3
	moveq	#0,d5
	bset	#0,(sflags6).w
	jsr	(dobitmap).l
	bclr	#0,(sflags6).w
	move.w	(TempWord1).w,d4
	jsr	(printz).l
	String	$BE,1,1
	movea.l	#NHLShieldImg,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#8,d5
	jsr	(dobitmap).l
	jsr	(printz).l
	String	$BE,$19,1
	movea.l	#PAlogoImg,a0
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
	jsr	(printz).l
	String	$BE,1,$E
	movea.l	#TitleImg,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#8,d5
	jsr	(dobitmap).l
	clr.w	(palfadenew).w
	clr.l	(fofdata2).w
	clr.w	(fofdata2+4).w
	move.w	d4,(smallfontchars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.l	$0D104567,$89ABCDEF	;remap table. FF210 + FF211 = Palette assignment for scrolling credits
	jsr	(printz).l
	String	$EF,0,0
	movea.l	#$5776,a1	;start of credits for scrolling
	jsr	(CreditsPrintRow).l
	addi.w	#$20,(Vscroll).w
	move.w	#$104,(clampcounter).w
	move.w	#$120,(playoffspritex).w
	move.w	#$D0,(playoffspritey).w
	clr.w	(asv).w
	move.w	#$FFCE,(DispAttribCtr).w
	move.w	#$20,(palcount).w
	move.w	#$78,-(sp)
	jsr	(song).l
	bsr.w	CreditsLineScroll
	move	#$2500,sr
.loop	;IDA: loc_FF26A
	jsr	(CreditsWait).l
	tst.w	(clampcounter).w
	bne.s	.loop
	move.w	#$3C,d3
.loop2	;IDA: loc_FF27A
	jsr	(CreditsWait).l
	dbf	d3,.loop2
	jsr	(printz).l
	String	$EF,0,0
	movea.l	#$57B8,a1
.loop3	;IDA: loc_FF296
	jsr	(CreditsPrintRow).l
	adda.w	(a1),a1
	moveq	#$27,d4
.loop4	;IDA: loc_FF2A0
	jsr	(CreditsWait).l
	jsr	(CreditsWait).l
	addq.w	#1,(Vscroll).w
	dbf	d4,.loop4
	moveq	#$78,d4
.loop5	;IDA: loc_FF2B6
	jsr	(CreditsWait).l
	dbf	d4,.loop5
	tst.w	2(a1)
	bpl.s	.loop3
	rts
CreditsPrintRow	;IDA: sub_FF2C8. 94 only. Credits: clear the row below the screen (Vscroll / 8 + $1C) and print the Strings from a1 centred there
	move.w	(Vscroll).w,d0
	asr.w	#3,d0
	addi.w	#$1C,d0
	andi.w	#$1F,d0
	move.w	d0,(printy).w
	move.w	d0,-(sp)
	clr.w	(printx).w
	moveq	#$20,d0
	moveq	#6,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	move.w	(sp)+,(printy).w
.loop	;IDA: loc_FF2F2
	move.w	(a1),d0
	asr.w	#1,d0
	neg.w	d0
	addi.w	#$11,d0
	move.w	d0,(printx).w
	jsr	(print).l
	addq.w	#1,(printy).w
	andi.w	#$1F,(printy).w
	tst.w	2(a1)
	bpl.s	.loop
	rts
CreditsWait	;IDA: sub_FF318. 94 only. Credits: wait for vcount, run the clampcounter count down; start (orjoy bit 7) returns from the caller too
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(vcount).w,d0
.loop	;IDA: loc_FF320
	cmp.w	(vcount).w,d0
	beq.s	.loop
	subq.w	#2,(clampcounter).w
	bpl.w	.0
	clr.w	(clampcounter).w
.0	;IDA: loc_FF332
	jsr	(orjoy).l
	btst	#7,d1
	movem.l	(sp)+,d0-d7/a0-a6
	beq.w	.x
	addq.w	#4,sp
.x	;IDA: locret_FF346
	rts
TitleVBlank	;IDA: loc_FF348. IDA label. newTitleScreen vblank: line scroll table (SortCords) and Vscroll, sprites, cramfade, CreditsScrollStep, MusicVB
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#2,(disflags).w
	bne.w	.1
	movea.w	#(SortCords-M68K_RAM),a0
	move.w	(VSCRLPM).w,d1
	move.w	#$1C0,d0
	jsr	(DoDMA).l
	movea.l	#VDP_DATA,a0
	move.l	#$40000010,4(a0)
	move.w	(Vscroll).w,(a0)
	movea.w	#(Satt-M68K_RAM),a0
	move.w	(Sattsize).w,d0
	beq.w	.0
	clr.w	(Sattsize).w
	move.w	(VSPRITES).w,d1
	jsr	(DoDMA).l
.0	;IDA: loc_FF394
	jsr	(cramfade).l
.1	;IDA: loc_FF39A
	addq.w	#1,(vcount).w
	jsr	(CreditsScrollStep).l
	jsr	(MusicVB).l
	movem.l	(sp)+,d0-d7/a0-a6
	rte
CreditsLineScroll	;IDA: sub_FF3B0. 94 only. Credits: the line scroll table at SortCords
	movem.l	d0-d1,-(sp)
	move.w	#$14,(Hscroll).w
	move.w	#$50,(TempWord2).w
	move.w	#$50,d0
	movea.l	#SortCords,a0
	move.l	#$FD80,d1
.loop	;IDA: loc_FF3D0
	move.l	d1,(a0)+
	btst	#0,d0
	bne.w	.0
	subq.w	#1,d1
.0	;IDA: loc_FF3DC
	dbf	d0,.loop
	move.w	#$60,d0
	move.l	#$100,d1
.loop2	;IDA: loc_FF3EA
	move.l	d1,(a0)+
	addq.l	#4,d1
	dbf	d0,.loop2
	movem.l	(sp)+,d0-d1
	rts
CreditsScrollStep	;IDA: sub_FF3F8. 94 only. Credits: line scroll step, every TempWord2 frames
	subq.w	#1,(TempWord2).w
	bmi.w	.0
	rts
.0	;IDA: loc_FF402
	clr.w	(TempWord2).w
	movem.l	d0-d2/a0,-(sp)
	move.w	#$DF,d0
	movea.w	#(SortCords-M68K_RAM),a0
.loop	;IDA: loc_FF412
	tst.l	(a0)+
	cmp.w	#$28,d0
	ble.w	.2
	move.w	(Hscroll).w,d1
	cmp.w	#$8F,d0
	blt.w	.1
	move.w	-2(a0),d2
	beq.w	.2
	add.w	d1,d2
	move.w	d2,-2(a0)
	andi.w	#$FC00,d2
	cmp.w	#$FC00,d2
	beq.w	.2
	move.w	#0,-2(a0)
	bra.w	.2
.1	;IDA: loc_FF44C
	sub.w	d1,-2(a0)
	bpl.w	.2
	clr.w	-2(a0)
.2	;IDA: loc_FF458
	dbf	d0,.loop
	movem.l	(sp)+,d0-d2/a0
	rts
TeamLogoPalettes	;IDA: unk_FF462. Team logo palettes, 16 colors per team. Used by PeriodStatsScreen, ClearCardText (high94_2), DrawMatchupLogo (hockey94_07) and DrawTeamLogo (hockey94_08)
	dc.w	$EEA,0,$42,$EEA,$EEA,$EEE,0,$888,$AAA,$68,$8A,$CE,$260,$40,$664,$E8E
	dc.w	$EE8,$8C,0,$A0A,$A0A,$EEE,0,$C8C,$8C,$888,$68,$846,$44,$422,$8CE,$2AE
	dc.w	$EE8,$822,$8C,$EE8,$EE8,$EEE,0,$EC8,$48C,$C88,$6C,$866,$268,$224,$620,$CE
	dc.w	$EE8,6,$8C,$EE8,$EE8,$EEE,0,$8EE,$2CE,$2AE,$26E,$C,$EE8,$EE8,$EE8,$EE8
	dc.w	$EE8,0,6,$EE8,$EE8,$EEE,0,$8EE,$A8E,$4AC,$A88,$46C,$226,$644,$22E,$262
	dc.w	$EE8,0,$42,$EE8,$EE8,$EEE,0,$8AA,$688,$488,$466,$244,$260,$20,$ACC,0
	dc.w	$EE8,6,6,$EE8,$EE8,$EEE,0,$C8E,$86E,$44E,$82E,$20E,$EE8,$EE8,$EE8,$EE8
	dc.w	$EE8,$600,$4A,$EE8,$EE8,$EEE,0,$CEA,$A8E,$8A8,$44E,$488,$2E,$440,$400,$EE8
	dc.w	$EEA,$4A,$600,$EEA,$EEA,$EEE,0,$8AE,$4AE,$66,$88,$220,$A84,$842,$200,$2E
	dc.w	$EE8,$42,$822,$EE8,$EE8,$EEE,0,$20,$40,$A8A,$20,$466,$200,$224,$888,$422
	dc.w	$EE8,0,0,$EE8,$EE8,$EEE,0,$AAA,$888,$666,$444,$222,$CCC,$EE8,$EE8,$EE8
	dc.w	$EE8,$600,6,$EE8,$EE8,$EEE,0,$88E,$26E,$C68,$2E,$A24,$EAA,$EE8,$EE8,$EE8
	dc.w	$EE8,$20,6,$EE8,$EE8,$EEE,0,$AAA,$A,$888,$C,$22,6,$CCC,$EE8,$EE8
	dc.w	$EE8,$822,$4A,$EE8,$EE8,$EEE,0,$AA8,$66E,$864,$22C,$62A,8,$622,$222,$A8E
	dc.w	$EE8,$600,6,$EE8,$EE8,$EEE,0,$AAA,$C86,$2E,$C60,$844,$444,$840,8,$EC8
	dc.w	$EE8,6,$6A,$EE8,$EE8,$EEE,0,$68A,$688,$466,$244,$22C,$228,8,$AAA,4
	dc.w	$EE8,0,$4A,$EE8,$EE8,$EEE,0,$CCC,$88E,$AAA,$46E,$6E,$888,$666,$2E,$444
	dc.w	$EE8,0,$8C,$EE8,$EE8,$EEE,0,$AAA,$88A,$66A,$4EE,$464,$440,$2CE,$244,$AEE
	dc.w	$EE8,$600,6,$EE8,$EE8,$EEE,0,$C00,$E,$E44,$ECE,$E80,$88E,$EE8,$EE8,$EE8
	dc.w	$EE8,0,$822,$EE8,$EE8,$EEE,0,$860,$642,$888,$CA8,$ACC,$2AE,$6E,$48,$46A
	dc.w	$EE8,$822,$6A,$EE8,$EE8,$EEE,0,$602,$24C,2,$26,$68,$428,$86E,$EE8,$EE8
	dc.w	$EE8,0,$600,$EE8,$EE8,$EEE,0,$C86,$E84,$A84,$C44,$822,$E20,$600,$A00,$EA8
	dc.w	$EE8,$600,$600,$EE8,$EE8,$EEE,0,$ECA,$AAA,$C66,$822,$CCC,$EE8,$EE8,$EE8,$EE8
	dc.w	$EE8,0,$8C,$EE8,$EE8,$EEE,0,$CE,$6A,$4E,$28,$22,$20,$8E,$888,$6CE
	dc.w	$EE8,6,$600,$EE8,$EE8,$EEE,0,$22C,$C86,$EA8,$88E,$842,$EE8,$EE8,$EE8,$EE8
	dc.w	$EE8,$600,6,$EE8,$EE8,$EEE,0,$22C,$422,$AAC,$666,$CAA,$444,$66E,$8CE,$226
	dc.w	$EE8,0,$4A,$EE8,$EE8,$EEE,0,$688,$464,$244,$222,$4E,$A,$22,$AAA,0
	dc.w	$EE8,0,$4A,$EE8,$EE8,$EEE,0,$688,$464,$244,$222,$4E,$A,$22,$AAA,0
LeadSong	;IDA: sub_FF7E2. 94 only. Not in a shootout (gmode2 bit 1), scores not level: once (sflags2 bit 5), ChooseSong with SongIndex 1 (home ahead) or 4
	;and sflags8 bit 6; sflags2 is put back on exit. Called from puckfaceoff2 (logic94_4)
	movem.l	d0/a0-a3,-(sp)
	move.w	(sflags2).w,-(sp)
	btst	#1,(gmode2).w
	bne.w	LeadSongExit
	movea.w	#(HmShots-M68K_RAM),a2
	lea	$364(a2),a3
	move.w	$24(a2),d0
	sub.w	$24(a3),d0
	beq.w	LeadSongExit
	bpl.w	.0
	btst	#6,(sflags2).w
	bne.w	.1
	bsr.w	ClearLeadSong
	bset	#6,(sflags2).w
	bra.w	.1
.0	;IDA: loc_FF824
	exg	a2,a3
	btst	#6,(sflags2).w
	beq.w	.1
	bsr.w	ClearLeadSong
	bclr	#6,(sflags2).w
.1	;IDA: loc_FF83A
	bset	#5,(sflags2).w
	bne.w	LeadSongExit
	cmpa.w	#$C6CE,a3
	bne.w	.2
	move.w	(HomeTeam).w,(HmTeam).w
	move.w	#1,(SongIndex).w
	jsr	(ChooseSong).l
.loop	;IDA: loc_FF85E
	bset	#6,(sflags8).w
	bra.w	LeadSongExit
.2	;IDA: loc_FF868
	move.w	(HomeTeam).w,(HmTeam).w
	move.w	#4,(SongIndex).w
	jsr	(ChooseSong).l
	bra.s	.loop
ClearLeadSong	;IDA: sub_FF87C. 94 only. Clear sflags2 bit 5
	bclr	#5,(sflags2).w
	rts
LeadSongExit	;IDA: loc_FF884. IDA label. LeadSong exit
	move.w	(sp)+,(sflags2).w
	movem.l	(sp)+,d0/a0-a3
	rts
ClearPenalties	;IDA: sub_FF88E. 94 only. Clear the penalties: PBnum, Penaltytimer, Pencntdwn, PenBuf and both teams' penalty slots (clrTmPdst). Called from clockcont_0 (hockey94_01)
	movem.l	d0/a0,-(sp)
	clr.w	(PBnum).w
	clr.w	(Penaltytimer).w
	clr.w	(Pencntdwn).w
	move.w	#$10,d0
	movea.l	#PenBuf,a0
.loop
	clr.l	(a0)+
	dbf	d0,.loop
	movea.l	#HmShots,a0
	bsr.w	clrTmPdst
	movea.l	#AwShots,a0
	bsr.w	clrTmPdst
	movem.l	(sp)+,d0/a0
	rts
clrTmPdst	;IDA name (and comments). 94 only
	move.w	#$19,d0	;19 = 25 decimal (max roster size)
	adda.w	#$66,a0	;'f'   ; Starting at (C734-home, CA98-away) and decrementing
.loop
	move.w	#$FFFE,(a0)+	;-2 = bench
	dbf	d0,.loop
	move.w	#$FFFF,(a0)	;-1 = ice
	rts
HotColdIcon	;IDA: sub_FF8DE. 94 only. The icon by the name of player iconplayer of team a2 at x iconx, y $19: HotIconMap when he is awayhotplayer /
	;homehotplayer, ColdIconMap when awaycoldplayer / homecoldplayer, else clear it (eraser)
	movem.l	d0/a0-a1,-(sp)
	movea.l	#awayhotplayer,a0
	move.w	#2,(iconx).w
	cmpa.l	#HmShots,a2
	bne.w	.0
	movea.l	#homehotplayer,a0
	move.w	#$20,(iconx).w
.0	;IDA: loc_FF904
	move.w	#0,d0
.loop	;IDA: loc_FF908
	move.w	(a0)+,d1
	cmp.w	(iconplayer).w,d1
	beq.w	.2
	dbf	d0,.loop
	movea.l	#awaycoldplayer,a0
	cmpa.l	#HmShots,a2
	bne.w	.1
	movea.l	#homecoldplayer,a0
.1	;IDA: loc_FF92C
	move.w	#0,d0
.loop2	;IDA: loc_FF930
	move.w	(a0)+,d1
	cmp.w	(iconplayer).w,d1
	beq.w	.3
	dbf	d0,.loop2
	move.w	(iconx).w,(printx).w
	move.w	#$19,(printy).w
	move.w	#8,d0
	move.w	#3,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	bra.w	.x
.2	;IDA: loc_FF960
	move.w	(hoticonchars).w,d4
	movea.l	#HotIconMap,a0
	bra.w	.4
.3	;IDA: loc_FF96E
	move.w	(coldiconchars).w,d4
	movea.l	#ColdIconMap,a0
.4	;IDA: loc_FF978
	move.w	(iconx).w,(printx).w
	move.w	#$19,(printy).w
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	movea.w	#$30A,a2
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#0,d5
	jsr	(dobitmap).l
.x	;IDA: loc_FF9A2
	movem.l	(sp)+,d0/a0-a1
	rts
chgplayer	;IDA name (and comments). 94 only: the pad d4 takes the nearest free skater to where the puck is going (not a goalie, not locked or
	;unavailable; in a penalty shot / shootout only BA_Sktr_SCnum or BA_Goalie_SCnum), or sweep checks when it is the same one. Called from
	;changeplayer (logic94_1)
	btst	#6,(sflags5).w	;Check bit 6. This is never set anywhere
	bne.w	exit
	movem.l	d0-d6/a0-a1,-(sp)
	move.w	(puckvx).w,d0	;lead puck slightly
	asr.w	#8,d0
	add.w	(puckx).w,d0
	move.w	(puckvy).w,d1
	asr.w	#8,d1
	add.w	(pucky).w,d1
	movem.w	d0-d1,-(sp)
	moveq	#5,d2
	move.w	d4,d3
	eori.w	#2,d3	;other controller
	moveq	#-1,d5	;-1
	movea.w	#(SortCords-M68K_RAM),a0	;start of search
	movea.w	#(cont1team-M68K_RAM),a1
	cmpi.w	#1,0(a1,d4.w)
	beq.w	.t1
	adda.w	#$300,a0	;controller is on other team
.t1
	movea.w	#(c1playernum-M68K_RAM),a1
.top
	tst.w	$34(a0)	;position
	ble.w	.next	;cant switch to goalie
	btst	#2,$63(a0)	;#pf2unav
	bne.w	.next	;this player is unavailable for some reason
	movem.w	d1,-(sp)
	move.w	$52(a0),d1	;SCnum
	cmp.w	0(a1,d4.w),d1
	movem.w	(sp)+,d1
	beq.w	.0
	btst	#3,$62(a0)	;is player controlled?
	bne.w	.next	;yes branch
.0	;IDA: loc_FFA22
	btst	#2,(BA_PS_flags).w
	beq.w	.1
	movem.l	d0,-(sp)
	move.w	(BA_Sktr_SCnum).w,d0
	cmp.w	$52(a0),d0
	movem.l	(sp)+,d0
	beq.w	.1
	movem.l	d0,-(sp)
	move.w	(BA_Goalie_SCnum).w,d0
	cmp.w	$52(a0),d0
	movem.l	(sp)+,d0
	bne.w	.next
.1	;IDA: loc_FFA54
	btst	#5,$62(a0)	;#pfalock
	bne.w	.next	;player is locked
	movem.w	(sp),d0-d1
	sub.w	(a0),d0	;Xpos
	muls.w	d0,d0
	sub.w	$14(a0),d1	;Ypos
	muls.w	d1,d1
	add.l	d1,d0
	cmp.l	d5,d0
	bhi.w	.next
	move.w	$52(a0),d1	;Scnum
	cmp.w	0(a1,d3.w),d1
	beq.w	.next	;this is current player
	move.l	d0,d5
	move.w	d1,d6
.next
	adda.w	#$80,a0	;size of SCstruct
	dbf	d2,.top
	addq.w	#4,sp
	pea	(.ex).l
	cmp.w	0(a1,d4.w),d6
	beq.w	swpchk	;player is same so sweep check
	move.w	d6,d0	;d0 now is new player
	tst.w	d4
	beq.w	j_setc1player	;IDA hid this
	bra.w	j_setc2player
.ex
	movem.l	(sp)+,d0-d6/a0-a1
exit	;IDA name
	rts
swpchk	;IDA name. Sweepcheck (logic94_1)
	jmp	Sweepcheck
j_setc1player	;IDA: setc1player (a thunk IDA gave its target's name)
	jmp	setc1player
j_setc2player	;IDA: setc2player (a thunk IDA gave its target's name)
	jmp	setc2player
