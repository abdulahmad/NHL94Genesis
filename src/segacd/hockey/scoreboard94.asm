; Scoreboard, ticker and highlights. This file shows the power play graphic and the time remaining,
; switches the rink between its horizontal and vertical views (ClrHor, SetHor), draws the scoreboard and
; the energy bars, counts shot stats, runs the end of period intermission, the ticker scores and the
; highlights (DoHiLights).

updatepwrplay						;show graphic and time remaining for power plays. Nothing when gmode2 bit
	
	
	
	btst	#1,(gmode2).l
	bne.w	rtss2
	movea.l	#tmstruct,a2
	lea.l	$366(a2),a3
	move.w	$26(a2),d0
	sub.w	$26(a3),d0
	beq.w	.clrpwrplay
	bpl.w	.t0
	btst	#sf2pwrtm,(sflags2).l
	bne.w	.upp
	bsr.w	.clrpwrplay
	bset	#sf2pwrtm,(sflags2).l
	bra.w	.upp
.t0	exg.l	a2,a3
	btst	#sf2pwrtm,(sflags2).l
	beq.w	.upp
	bsr.w	.clrpwrplay
	bclr	#sf2pwrtm,(sflags2).l
.upp	bset	#sf2pwrplay,(sflags2).l
	bne.w	.uppt
	addi.w	#$1,$4(a3)
	cmpa.l	#tmstruct,a3
	bne.w	.away
.home	bra.w	.uppt
.away	bra.w	.home
.uppt	bsr.w	printz
; Inline data read by printz from the return address (2 rows).
	dc.w	$0012
	dc.b	$BF,$01,$19,$20,$20,$20,$16,$17,$18,$19,$BF,$01,$1A,$20,$20,$00
	bsr.w	GetLowestPen
	bsr.w	PushTime
	bsr.w	print
	movea.l	tmdata(a3),a0
	movea.l	#mesarea,a3
	move.w	#2,(a3)
	bsr.w	PushNumberWidthString
	String	CC_Font1Pri,$1,$19
	adda.w	$4(a0),a0
	adda.w	(a0),a0
	movea.l	a0,a1
	bsr.w	appstring
	movea.l	a3,a1
	bra.w	print
.clrpwrplay	bclr	#sf2pwrplay,(sflags2).l
	beq.w	rtss2
	bra.w	EASNLogo
ClrHor						;revert the graphics back to vertical ice rink mode. Reloads Rinktiles and
	
	movem.l	d0-d7/a0-a6,-(sp)
	bclr	#sfhor,(sflags).l
	move.w	#$3E8,(Oldrow).l
	move.w	(rinkvrcset).l,d4
	movea.l	$47D18.l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsPlain).l
	jsr	(UnpackPictureSelectGfx).l
	bsr.w	SprSort
	btst	#sfpz,(sflags).l
	bne.w	.ex
	bsr.w	printz
	String	CC_Font1,$0,$0
	moveq	#$20,d0
	moveq	#$1C,d1
	move.w	#$7FF,d2
	bsr.w	eraser
	bsr.w	printscores1
.ex	movem.l	(sp)+,d0-d7/a0-a6
	rts
SetHor						;switch graphics to horizontal ice rink graphics mode
	movem.l	d0-d7/a0-a6,-(sp)
	bset	#sfhor,(sflags).l
.p	btst	#dfok,(disflags).l
	bne.w	.p
	clr.w	(Hscroll).l
	clr.w	(Vscroll).l
	bsr.w	SprSort
	bsr.w	printz
	String	CC_Font2,$0,$0
	movea.l	$47D6C.l,a1
	adda.l	jimdata(a1),a1
	movea.l	$47D6C.l,a2
	addq.l	#$8,a2
	clr.w	d0
	move.w	#0,d1
	moveq	#$20,d2
	moveq	#$1C,d3
	move.w	(rinkvrcset).l,d4
	moveq	#0,d5
	bsr.w	dobitmap
	bsr.w	USBoard
	btst	#sfpz,(sflags).l
	bne.w	.ex
	move.w	#$800,d0
	move.w	(VmMAP1).l,d1
	move.w	#$7FF,d2
	bsr.w	DoDMANd2Queue
.ex	movem.l	(sp)+,d0-d7/a0-a6
	rts
printscores1						;Draw scoreboard. Vertical rink: period box and the score box (team names
	
	
	
	
	
	
	movem.l	d0-d2/a0-a3,-(sp)
	btst	#sfhor,(sflags).l
	bne.w	.sbscreen
	bclr	#7,(sflags5).l
	beq.w	.0
	move.w	#$78,(crowdnoisedelay).l
.0	bsr.w	printz
	String	CC_Font1Pri,$0,$17
	moveq	#9,d0
	moveq	#5,d1
	bsr.w	Framer
	bset	#dfclock,(disflags).l
	bsr.w	printz
	String	CC_Font1Pri,$1,$18
	move.w	(gsp).l,d0
	movea.l	#PerLabels,a1
	btst	#1,(gmode2).l
	beq.w	.1
	move.w	#4,d0
	movea.l	#PerLabels2,a1
.1	bsr.w	PrintTickerEntry
	bsr.w	EASNLogo
	btst	#sf3llcs,(sflags3).l
	bne.w	.ex
	bsr.w	printz
	String	CC_Font1Pri,$17,$17
	moveq	#8,d0
	moveq	#5,d1
	bsr.w	Framer
	bsr.w	printz
	String	CC_Font1Pri,$18,$1A
	movea.l	#tmstruct,a2
	bsr.w	printscores1_ps
	bsr.w	printz
	String	CC_Font1Pri,$18,$18
	adda.w	#$366,a2
	bsr.w	printscores1_ps
.ex	movem.l	(sp)+,d0-d2/a0-a3
	rts
.sbscreen	bsr.w	printz
	String	CC_Font2Pri,$11,$2
	move.w	(gsp).l,d0
	btst	#0,(gmode2).l
	beq.w	.2
	move.w	#4,d0
.2	movea.l	#PerLabels2,a1
	bsr.w	SkipListEntries
	move.w	(a1),d0
	lsr.w	#1,d0
	sub.w	d0,(printx).l
	bsr.w	print
	bsr.w	printz
	String	CC_Font2Pri,$17,$2
	movea.l	#tmstruct,a2
	clr.w	d0
	bsr.w	PrintTeamLogoAndScore
	bsr.w	printz
	String	CC_Font2Pri,$8,$2
	adda.w	#$366,a2		;tmsize
	moveq	#$2C,d0
	bsr.w	PrintTeamLogoAndScore
	bra.w	.ex
printscores1_ps						;Print the team name of team a2 at printx/printy, then its score as 2
	
	movea.l	tmdata(a2),a1
	adda.w	$4(a1),a1
	adda.w	(a1),a1
	bsr.w	print
	move.w	#$1C,(printx).l
	move.w	tmscore(a2),d0
	moveq	#2,d1
	bsr.w	PushNumberWidth
	bra.w	print		;print the score and return
PrintTeamLogoAndScore						;Draw the team logo map (PutTeamBlock, d0 = offset) 5 columns left of
	
	
	
	move.w	(printx).l,-(sp)
	subi.w	#$5,(printx).l
	jsr	(PutTeamBlockDraw).l
	move.w	(sp)+,(printx).l
	addi.w	#$2,(printy).l
	move.w	tmscore(a2),d0
	cmpi.w	#$A,d0
	bge.w	.0
	bra.w	.1
.0	subi.w	#$1,(printx).l
.1	bsr.w	PushNumber
	move.w	(a1),d0
	subi.w	#$2,d0
	lsr.w	#1,d0
	sub.w	d0,(printx).l
	addi.w	#$1,(printx).l
	bra.w	printbig
EASNLogo						;Draw the EASN logo map at x 1, y $19 on the vertical ice rink if no power
	
	btst	#sf2pwrplay,(sflags2).l
	bne.w	rtss2
	bsr.w	printz
	String	CC_Font1Pri,$1,$19
	movea.l	$47D4C.l,a1
	adda.l	jimdata(a1),a1
	movea.l	#$1B008,a2
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	mapheight(a1),d3
	move.w	(EASNcset).l,d4
	clr.w	d5
	bra.w	dobitmap
USBoard						;Update score board, including the players in the penalty box and their
	
	movem.l	d0-d7/a0-a3,-(sp)
	bset	#dfclock,(disflags).l
	bsr.w	printscores1
	bsr.w	printz
	String	CC_Font2Pri,$14,$8
; Instruction bytes inside USBoard that the assembler would encode differently, kept as words (6 rows).
	dc.w	$247C,$0001,$834C,$6100,$001C,$6100,$C8E2,$0006
	dc.w	$BE05,$0800,$247C,$0001,$86B2,$6100,$0008,$4CDF
	dc.w	$0FFF,$4E75,$41EA,$009C,$4240,$1018,$6B00,$0014
	dc.w	$0832,$0006,$0068,$6600,$FFF0,$6100,$0024,$6000
	dc.w	$FFE8,$41EA,$009C,$4240,$1018,$6B00,$F934,$0832
	dc.w	$0006,$0068,$6700,$FFF0,$6100,$0006,$6000,$FFE8
pplpen						;print one penalty box line: player number and time remaining. a2 = team,
	
	
	cmpi.w	#$A,(printy).l
	bhi.w	rtss2
	move.w	$68(a2,d0.w),d2
	andi.w	#$7FF,d2
	movea.l	tmdata(a2),a1
	adda.w	$0(a1),a1
	lsr.w	#1,d0
.find	adda.w	(a1),a1
	adda.w	#$8,a1
	dbra	d0,.find
	clr.w	d0
	move.b	pldnum-pldsize(a1),d0
	move.w	(printx).l,-(sp)
	movea.l	#TextBuffer,a1
	bsr.w	ConvertByteToDigits
	movea.l	#mesarea,a1
	move.w	#4,(a1)
	bsr.w	print
	move.w	d2,d0
	bsr.w	PushTime
	bsr.w	print
	move.w	(sp)+,(printx).l
	addi.w	#$1,(printy).l		;next row
	rts
linebar						;Draw the energy bar of line d0 for team a2 at printx/printy (bitmap from
	
	movem.l	d0-d5/a0-a2,-(sp)
	bsr.w	getlinee
	move.w	(printa).l,-(sp)
	move.w	#$8000,(printa).l
	ext.l	d0
	divu.w	#$100,d0
	cmpi.w	#$F,d0
	bls.w	.ok
	moveq	#$F,d0
.ok	moveq	#$F,d1
	sub.w	d0,d1
	clr.w	d0
	movea.l	$47D40.l,a1
	adda.l	jimdata(a1),a1
	movea.l	#$1B008,a2
	move.w	(a1),d2
	moveq	#1,d3
	move.w	(energybarchars).l,d4
	moveq	#0,d5
	bsr.w	dobitmap
	move.w	(sp)+,(printa).l
	movem.l	(sp)+,d0-d5/a0-a2
	rts
getlinee						;d0 = line number, a2 = team struct. Return d0 = energy level of this line
	movem.l	d1-d5/a0-a3,-(sp)
	lea.l	$16C(a2),a1
	asl.w	#3,d0
	adda.w	d0,a1
	clr.l	d0
	clr.w	d1
	movea.l	#priolist,a0
	move.w	$26(a2),d4
	bra.w	.next
.loop	clr.w	d5
	move.b	(a0,d4.w),d5
	beq.w	.next
	clr.w	d3
	move.b	(a1,d5.w),d3
	asl.w	#1,d3
	addi.w	#$1,d1
	add.w	$32(a2,d3.w),d0
.next	dbra	d4,.loop
	divu.w	d1,d0
	movem.l	(sp)+,d1-d5/a0-a3
	rts
AvgCline						;Return d0 = average energy of current line on team a2
	movem.l	d1-d3/a0,-(sp)
	clr.l	d0
	clr.w	d1
	moveq	#5,d2
	movea.l	$22(a2),a0
.loop	tst.w	position(a0)
	ble.w	.next
	clr.w	d3
	move.b	pnum(a0),d3
	add.w	d3,d3
	add.w	$34(a2,d3.w),d0
	addi.w	#$1,d1
.next	adda.w	#SCstruct,a0
	dbra	d2,.loop
	tst.w	d1
	beq.w	.ex
	divu.w	d1,d0
.ex	movem.l	(sp)+,d1-d3/a0
	rts

ChkShotStat						;determine if shot taken, add to appropriate stats: crowd, team, shooter
	
	
	
	
	btst	#gmclock,(gmode).l
	bne.w	rtss2
	btst	#gmhl,(gmode).l
	bne.w	rtss2
	bclr	#sf2shot,(sflags2).l
	bne.w	.Cwdupdate
	btst	#0,(sflags4).l
	beq.w	rtss2
	bclr	#3,(sflags8).l
	bne.w	.0
	bset	#3,(sflags8).l
	bra.w	rtss2
.0	movem.l	d0-d1/a1-a3,-(sp)
	move.l	a4,-(sp)
	movea.l	#ChkCnt,a4
	adda.w	(ScoreSumbytes).l,a4
	movea.l	#tmstruct,a2
	btst	#7,ssflags(a4)
	beq.w	.pllookup
	adda.w	#$366,a2
.pllookup	clr.w	d0
	move.b	ssscorer(a4),d0
	movea.l	(sp)+,a4
	movea.l	$22(a2),a2
	move.w	#5,d1
.findplayer	cmp.b	pnum(a2),d0
	beq.w	.foundplayer
	adda.w	#$80,a2
	dbra	d1,.findplayer
	bra.w	.ex
.foundplayer	move.w	SCnum(a2),d0
	bra.w	.addShot
.Cwdupdate	movem.l	d0-d1/a1-a3,-(sp)
	addi.w	#$64,(Crowdlevel).l
	addi.w	#$A,(CwdExciteLvl).l
	move.w	(shotplayer).l,d0
.addShot	asl.w	#scsize,d0
	movea.l	#SortCords,a3
	adda.w	d0,a3
	bsr.w	ChkShotStatSwapStructs
	addi.w	#$1,$0(a2)
	btst	#sf2pwrplay,(sflags2).l
	beq.w	.2
	btst	#sf2pwrtm,(sflags2).l
	bne.w	.1
	btst	#pfteam,pflags(a3)
	bne.w	.2
.PPshot	addi.w	#$1,$356(a2)
	bra.w	.2
.1	btst	#pfteam,pflags(a3)
	bne.w	.PPshot
.2	move.l	a2,-(sp)
	move.w	(gsp).l,d0
	add.w	d0,d0
	adda.w	d0,a2
	addi.w	#$1,$34C(a2)
	movea.l	(sp)+,a2
	clr.w	d0
	move.b	pnum(a3),d0
	addi.w	#$EA,d0
	addi.b	#$1,(a2,d0.w)
	move.w	$28(a1),d0
	bmi.w	.ex
	addi.w	#$EA,d0
	addi.b	#$1,(a1,d0.w)
.ex	movem.l	(sp)+,d0-d1/a1-a3
	rts
; Picks the shooting team struct and swaps it for the other side when needed
ChkShotStatSwapStructs
.next3	movea.l	#tmstruct,a2
	lea.l	$366(a2),a1
	btst	#$6,$62(a3)
	beq.w	rtss2
	exg.l	a1,a2
	rts
SetupTeamForIntermission						;Reset the bench, then for each team refill energy and pick the starting
	
	
	bsr.w	ResetBench
	movea.l	#tmstruct,a2
	lea.l	$366(a2),a3
	bsr.w	.r
	exg.l	a2,a3
.r	bsr.w	reenergizeteam
	clr.w	tmline(a3)
	tst.w	(OptLine).l
	bne.w	rtss2
	move.w	$26(a3),d0
	sub.w	$26(a2),d0
	beq.w	rtss2
	move.w	#3,tmline(a3)
	tst.w	d0
	bpl.w	rtss2
	move.w	#5,tmline(a3)		;PK1
	rts
RestoreTeamEnergy						;a2 = team: max energy (tmpde $1000) for every player. The skip needs
	
	
	moveq	#(maxros-1)*2,d0
.loop	cmpi.w	#$FFFD,$68(a2,d0.w)
	bne.w	.0
	cmpi.w	#$FFFC,$68(a2,d0.w)
	bne.w	.0
	bra.w	.1
.0	move.w	#$1000,$34(a2,d0.w)
.1	subi.w	#$2,d0
	bpl.w	.loop
	rts
reenergizeteam						;Set all players to max energy on team a2 except those at tmpdst -4;
	
	
	
	moveq	#(maxros-1)*2,d0
.loop	cmpi.w	#$FFFC,$68(a2,d0.w)
	beq.w	.nb
	move.w	#$1000,$34(a2,d0.w)
	cmpi.w	#$FFFD,$68(a2,d0.w)
	bne.w	.nb
	move.w	#$FFFE,$68(a2,d0.w)
.nb	subi.w	#$2,d0
	bpl.w	.loop
	rts
Intermission						;end of period junk (zamboni/stats). Opens the pause menu screen (item
	
	
	
	
	
	cmpi.w	#4,(gsp).l
	bne.w	.1
	move.w	#0,(gameclock).l
	jsr	(UpdateRecordsStart).l
.1	bsr.w	SetupTeamForIntermission
	moveq	#$F,d0
	movea.l	#SortCords,a0
.clr	clr.w	$0(a0)
	adda.w	#SCstruct,a0
	dbra	d0,.clr
	move.w	(ExtraChars).l,d4
	movea.l	$47D34.l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain
	move.w	#$140,(Zamx).l
	move.w	(gsp).l,d0
	tst.w	(OptPlayMode).l
	beq.w	.ss
	addi.w	#$5,d0
.ss	asl.w	#2,d0
	lea.l	.next(pc),a0
	movea.l	(a0,d0.w),a0
	btst	#0,(gmode2).l
	beq.w	.2
	movea.l	#$42250,a0
.2	bset	#sfpz,(sflags).l
	movea.l	#$2C1F8,a1
	jsr	(SetMenuScreenHandler).l
	bsr.w	GetShifter
	move.w	d1,(TickerNum).l
	bset	#$5,$FF800F.l
.top	tst.w	(TickerNum).l
	bmi.w	.doh
	bsr.w	NewTickerNext
	bsr.w	NewTicker3
	move.w	#$96,d0
	bsr.w	waitxsr
	btst	#sbut,d1
	bne.w	.clrh
	bsr.w	NewTickerErase
	move.w	#$3C,d0
	bsr.w	waitxsr
	btst	#7,d1
	beq.w	.top
.clrh	bset	#sf3sbut,(sflags3).l
.doh	bsr.w	DoHiLights
	bclr	#sf3sbut,(sflags3).l
	bne.w	.clrz
.wait	move.w	#$1E0,d0
	bsr.w	waitxsr
	btst	#7,d1
	bne.w	.clrz
	tst.w	(cont1team).l
	bne.w	.wait
	tst.w	(cont2team).l
	bne.w	.wait
.clrz	st.b	(Zamx).l		;zamboni off
	rts
; Table of 20 words after Intermission, 40 bytes: $0004,$22D4,$0004,$2454,$0004,$2454 ...
.next	dc.w	$0004,$22D4,$0004,$2454,$0004,$2454,$0004,$2454
	dc.w	$0004,$25B0,$0004,$2388,$0004,$2454,$0004,$2454
	dc.w	$0004,$2454,$0004,$26C4
InitScores						;initialize other games scores/period in playoffs. Called from StartGame
	cmpi.w	#1,(gamelevel).l
	bgt.w	rtss2
	bsr.w	GetShifter
	movea.l	#gstruct,a0
	moveq	#gssize,d0
	mulu.w	d1,d0
	adda.w	d0,a0
.top	cmp.w	(gamenum).l,d1
	beq.w	.next2
	btst	#gsfso,gsflags(a0)
	bne.w	.next2
	clr.w	gsper(a0)
	moveq	#3,d0
	bsr.w	randomd0
	bra.w	.next
.0	bsr.w	SetScore
.next	dbra	d0,.0
.next2	suba.w	#gssize,a0
	dbra	d1,.top
	rts
UpdateScores						;update ticker score values. Called from PeriodOver
	bsr.w	GetShifter
	move.w	d1,(TickerNum).l
	movea.l	#gstruct,a0
	moveq	#gssize,d0
	mulu.w	d1,d0
	adda.w	d0,a0
.top	cmp.w	(gamenum).l,d1
	beq.w	.next
	bclr	#gsfhl,gsflags(a0)
	btst	#gsfso,gsflags(a0)
	bne.w	.next
	bsr.w	SetScore
.next	suba.w	#gssize,a0
	dbra	d1,.top
	rts
SetScore						;add to score for game in a0. After period 3 a game within one goal goes
	
	cmpi.w	#4,gsper(a0)
	bge.w	rtss2
	movem.l	d0-d1/a0-a1,-(sp)
	cmpi.w	#3,gsper(a0)
	bne.w	.o
	move.w	#5,gsper(a0)
	move.w	gss1(a0),d0
	sub.w	gss2(a0),d0
	cmpi.w	#$1,d0
	bgt.w	.ex
	cmpi.w	#$FFFF,d0
	blt.w	.ex
	move.w	#3,gsper(a0)
	bset	#gsfhl,gsflags(a0)
	bra.w	.ex
.o	addi.w	#$1,$8(a0)
	move.w	$0(a0),d0
	move.w	gst2(a0),d1
	bsr.w	.getscore
	add.w	d0,gss1(a0)
	move.w	gst2(a0),d0
	move.w	$0(a0),d1
	bsr.w	.getscore
	add.w	d0,gss2(a0)
.ex	movem.l	(sp)+,d0-d1/a0-a1
	rts
.getscore	asl.w	#2,d0
	movea.l	#TeamList,a1
	movea.l	(a1,d0.w),a1
	adda.w	$8(a1),a1
	move.b	(a1),d0
	andi.w	#$70,d0
	lsr.w	#1,d0
	lea.l	NewTicker(pc),a1
	move.l	(a1,d0.w),(nibblebuffer).l
	move.l	$4(a1,d0.w),$18BEC.l
	asl.w	#2,d1
	movea.l	#TeamList,a1
	movea.l	(a1,d1.w),a1
	adda.w	$8(a1),a1
	move.b	(a1),d0
	andi.w	#7,d0
	asl.w	#3,d0
	lea.l	NewTicker(pc),a1
	move.l	(a1,d0.w),d1
	add.l	d1,(nibblebuffer).l
	move.l	4(a1,d0.w),d1
	add.l	d1,$18BEC.l
	moveq	#4,d0
	bra.w	WeightedRandomSelect
NewTicker						;show the next ticker score once the clock is at 8:00 or less. d3 = -1 if
	
	ori.b	#$1E,$17(a3)
	ori.b	#$27,d4
	ori.b	#$18,-(a0)
	ori.b	#$23,d5
	ori.b	#$1A,-(a1)
	ori.b	#$1E,d6
	ori.b	#$1E,-(a2)
	ori.b	#$1A,d6
	ori.b	#$1E,-(a4)
; Instruction bytes inside NewTicker that the assembler would encode differently, kept as words (2 rows).
	dc.w	$0008,$0016,$0025,$001F,$000A,$0013,$0026,$001F
	dc.w	$000C,$000F,$0026,$0020,$000F
; Skips when the ticker timer is above $1E0.
NewTickerCheckBusy
	moveq	#-1,d3
	cmpi.w	#$1E0,(gameclock).l
	bgt.w	rtss2
; Takes the next queued ticker message.
NewTickerNext
	move.w	(TickerNum).l,d3
	bmi.w	rtss2
	subi.w	#$1,(TickerNum).l
	cmp.w	(gamenum).l,d3
	beq.w	NewTickerNext
CheckGameTickerStatus						;d3 = game. Return a0 = its gstruct; skip to the next ticker game if a
	
	moveq	#gssize,d0
	mulu.w	d3,d0
	movea.l	#gstruct,a0
	adda.w	d0,a0
	btst	#gsfhl,gsflags(a0)
	bne.w	NewTickerNext
	btst	#gsfso,gsflags(a0)
	bne.w	NewTickerNext
	rts
NewTicker3						;Display ticker score for game d3 (a0 = gstruct entry), skip if d3 is
	
	tst.w	d3
	bmi.w	rtss2
	bsr.w	SetTickerAreaPosition
	bsr.w	Framer
	addi.w	#$1,(printx).l
	subi.w	#$4,(printy).l
	move.w	(printx).l,-(sp)
	bsr.w	GetShifter
	move.w	#$A000,(printa).l
	bsr.w	printz
	String	'                        '
	move.w	(sp),(printx).l
	moveq	#1,d0
	add.w	(gamelevel).l,d0
	tst.w	(OptPlayMode).l
	bne.w	.next
	clr.w	d0
.next	lea.l	.next2(pc),a1
	bsr.w	PrintTickerEntry
	move.w	gsper(a0),d0
	subi.w	#$1,d0
	movea.l	#PerLabels,a1
	bsr.w	SkipListEntries
	move.w	(a1),d0
	lsr.w	#1,d0
	neg.w	d0
	add.w	(sp),d0
	addi.w	#$17,d0
	move.w	d0,(printx).l
	bsr.w	print
	move.w	#$8000,(printa).l
	move.w	gst2(a0),d0
	move.w	gss2(a0),d1
	bsr.w	.tn
	move.w	$0(a0),d0
	move.w	gss1(a0),d1
	bsr.w	.tn
	adda.w	#$2,sp
	rts
.tn	move.w	$4(sp),(printx).l
	addi.w	#$1,(printy).l
	movea.l	#TeamList,a1
	asl.w	#2,d0
	movea.l	(a1,d0.w),a1
	adda.w	$4(a1),a1
	bsr.w	print
	move.w	$4(sp),(printx).l
	addi.w	#$15,(printx).l
	move.w	d1,d0
	moveq	#2,d1
	bsr.w	PushNumberWidth
	bra.w	print
; Text of NewTicker3 (5 rows).
.next2	dc.b	$00,$12,'EA Hockey Nigh'
	dc.b	't',$00,$00,$18,'Stanley Cup '
	dc.b	'Qualifier',$00,$00,$0E,'Quar'
	dc.b	'terfinal',$00,$18,'Stanle'
	dc.b	'y Cup Semifinal',$00
; Sets the ticker position and erases it.
NewTickerErase
	bsr.w	SetTickerAreaPosition
	move.w	#$7FF,d2
	bra.w	eraser
SetTickerAreaPosition						;Set printx/printy/printm for the ticker box (x 3, y $17; the $BD map in
	
	
	bsr.w	printz
	String	CC_Font3Pri,$3,$17
	btst	#sfpz,(sflags).l
	bne.w	.1
	bsr.w	printz
	String	CC_Font1Pri,$3,$17
.1	moveq	#$1A,d0
	moveq	#5,d1
	rts
; Skips to the entry and prints it small.
PrintTickerEntry
	bsr.w	SkipListEntries
	bra.w	printsmall
; Skips d0 offset-linked entries starting at a1.
SkipListEntries
	bra.w	.next
.loop	adda.w	(a1),a1
.next	dbra	d0,.loop
	rts
DoHiLights						;Hilites logic: search for hilite game and show
	
	bsr.w	GetShifter
	moveq	#gssize,d3
	mulu.w	d1,d3
	movea.l	#gstruct,a0
	adda.w	d3,a0
.top	btst	#gsfso,gsflags(a0)
	bne.w	.next
	bclr	#gsfhl,gsflags(a0)
	beq.w	.next
	bsr.w	.next2
.next	suba.w	#gssize,a0
	dbra	d1,.top
	rts
.next2	movem.l	d0-d7/a0-a6,-(sp)
.loop	btst	#$3,(sflags3).l
	bne.w	.next9
	bsr.w	.next13
	move.w	d1,d3
	bsr.w	CheckGameTickerStatus
	bsr.w	NewTicker3
	btst	#$3,(sflags3).l
	bne.w	.next8
	move.w	#$4,(printx).l
	subi.w	#$6,(printy).l
	moveq	#$18,d0
	moveq	#$3,d1
	bsr.w	Framer
	addi.w	#$1,(printx).l
	subi.w	#$2,(printy).l
	bsr.w	printz
	String	'Highlight from game:'
	move.w	#$B4,d0
	bsr.w	waitxsr
	btst	#$7,d1
	bne.w	.next8
	st.b	(Zamx).l
	clr.w	(CwdExciteLvl).l
	move.w	$0(a0),(HomeTeam).l
	move.w	$2(a0),(VisTeam).l
	move.l	a0,-(sp)
	clr.w	$18374.l
	clr.w	$186DA.l
	jsr	(clearTeamStats).l
	jsr	(restoreteams).l
	st.b	(c1playernum).l
	st.b	(c2playernum).l
	clr.w	(cont1team).l
	clr.w	(cont2team).l
	moveq	#$78,d0
	bsr.w	randomd0
	addi.w	#$3C,d0
	move.w	d0,(gameclock).l
	movea.l	(sp),a0
	move.w	$8(a0),(gsp).l
	subi.w	#$1,(gsp).l
	move.w	$A(a0),(HmGoals).l
	move.w	$C(a0),(AwGoals).l
	move.b	#$10,(gmode).l
	btst	#$0,$180E5.l
	beq.w	.next3
	bset	#$1,(gmode).l
.next3	clr.b	(sflags).l
	move.b	#$4,(sflags2).l
	clr.b	(sflags3).l
	bclr	#$4,(disflags).l
	bset	#$3,(disflags).l
	clr.w	(glovecords).l
	clr.b	(iflags).l
	st.b	(RefCnt).l
	st.b	$17E38.l
	st.b	$17E3C.l
	jsr	(HockeyRtsStubA).l
	bsr.w	setupice_highlight
	move.w	#$1,$17468.l
	bsr.w	ClrHor
	move.w	#$0,$17468.l
	movea.l	#$C00000,a0
.loop2	btst	#$7,$FF800E.l
	bne.b	.loop2
	move.w	#$9100,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	beq.b	.loop3
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop4	btst	#$6,$FF800E.l
	bne.b	.loop4
	bclr	#$7,$FF800F.l
.loop5	btst	#$7,$FF800E.l
	bne.b	.loop5
	move.w	#$9200,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop6	btst	#$6,$FF800E.l
	beq.b	.loop6
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop7	btst	#$6,$FF800E.l
	bne.b	.loop7
	bclr	#$7,$FF800F.l
	move.w	(ExtraChars).l,d4
	movea.l	$47D1C.l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain
	clr.w	(Vpos).l
	clr.w	(Hpos).l
	bsr.w	ResetBench
	movea.l	#tmstruct,a2
	bsr.w	.next10
	adda.w	#$366,a2
	bsr.w	.next10
	bsr.w	resetplstuff
	moveq	#$B,d0
	movea.l	#$3D3F6,a0
	movea.l	#SortCords,a1
.loop8	move.w	$34(a1),d1
	btst	#$7,$62(a1)
	bne.w	.next4
	addi.w	#$6,d1
.next4	asl.w	#$2,d1
	move.w	(a0,d1.w),$0(a1)
	move.w	$2(a0,d1.w),$14(a1)
	clr.w	$28(a1)
	clr.w	$2A(a1)
	adda.w	#$80,a1
	dbra	d0,.loop8
	bsr.w	SprSort
	move.w	#$18,(palcount).l
	move.w	(ScoutSubStatus).l,(OldVcount).l
	move.w	#$B4,-(sp)
.loop9	jsr	(DoGameFrame).l
	btst	#$0,(gmode).l
	beq.w	.next5
	subi.w	#$1,(sp)
	bmi.w	.next7
.next5	bsr.w	orjoy
	btst	#$5,d1
	bne.w	.next6
	btst	#$7,d1
	beq.w	.loop9
.next6	move.w	(HmGoals).l,d0
	cmp.w	(AwGoals).l,d0
	bne.w	.next7
.loop10	btst	#$7,$FF800E.l
	bne.b	.loop10
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.loop11	btst	#$6,$FF800E.l
	beq.b	.loop11
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop12	btst	#$6,$FF800E.l
	bne.b	.loop12
	bclr	#$7,$FF800F.l
	andi.w	#$1,d0
	add.w	d0,(HmGoals).l
	eori.w	#$1,d0
	add.w	d0,(AwGoals).l
.next7	adda.w	#$2,sp
	movea.l	(sp)+,a0
	movem.l	d1/a0,-(sp)
	jsr	(HockeyRtsStubC).l
	jsr	(HockeyRtsStubA).l
	movem.l	(sp)+,d1/a0
	move.w	(HmGoals).l,$A(a0)
	move.w	(AwGoals).l,$C(a0)
	bsr.w	forceblack
	moveq	#$F,d0
	movea.l	#SortCords,a0
.loop13	clr.w	$0(a0)
	adda.w	#$80,a0
	dbra	d0,.loop13
	bsr.w	.next14
	bsr.w	CopyTeamLinesCheckTeam
	bsr.w	SetHor
	bsr.w	setvideo
	jsr	(PausemodeVdpFill).l
	jsr	(DrawMenuScreen).l
	move.w	#$18,(palcount).l
	move.w	#$79,-(sp)
	bsr.w	song
	movem.l	(sp),d0-d7/a0-a6
	move.w	#$4,$8(a0)
	move.w	$A(a0),d0
	cmp.w	$C(a0),d0
	beq.w	.loop
	move.w	#$5,$8(a0)
	move.w	d1,d3
	bsr.w	CheckGameTickerStatus
	bsr.w	NewTicker3
	move.w	#$B4,d0
	bsr.w	waitxsr
	btst	#$7,d1
	bne.w	.loop14
	bsr.w	NewTickerErase
	move.w	#$3C,d0
	bsr.w	waitxsr
	btst	#$7,d1
	beq.w	.loop15
.loop14	bset	#$3,(sflags3).l
.loop15	movem.l	(sp)+,d0-d7/a0-a6
	rts
.next8	bsr.w	.next14
	bsr.w	.next11
	bra.w	.loop14
.next9	bsr.w	.next11
	bra.w	.loop15
.next10	jsr	(reenergizeteam).l
	bsr.w	setpersonel
	bsr.w	forcepldata
	st.b	$18(a2)
	bclr	#$7,(sflags8).l
	st.b	$1A(a2)
	st.b	$1C(a2)
	rts
.next11	move.w	$A(a0),d0
	cmp.w	$C(a0),d0
	bne.w	.next12
.loop16	btst	#$7,$FF800E.l
	bne.b	.loop16
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.loop17	btst	#$6,$FF800E.l
	beq.b	.loop17
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop18	btst	#$6,$FF800E.l
	bne.b	.loop18
	bclr	#$7,$FF800F.l
	andi.w	#$1,d0
	add.w	d0,$A(a0)
	eori.w	#$1,d0
	add.w	d0,$C(a0)
.next12	move.w	#$5,$8(a0)
	rts
.next13	move.w	#$557,d0
	movea.l	#gmode,a1
	movea.l	#$C45C,a2
.loop19	move.w	(a1)+,(a2)+
	dbra	d0,.loop19
	move.w	(ScoreSumbytes).l,(a2)+
	rts
.next14	move.w	#$557,d0
	movea.l	#gmode,a2
	movea.l	#$C45C,a1
.loop20	move.w	(a1)+,(a2)+
	dbra	d0,.loop20
	move.w	(a1)+,(ScoreSumbytes).l
	rts
; Data that follows DoHiLights (strings, small tables)
DoHiLightsData	dc.w	$0000,$FF10,$FFBA,$FF74,$0014,$FF92,$FF9C,$FFC4
	dc.w	$0019,$FFD8,$0046,$FFB0,$0000,$00F0,$0022,$005A
	dc.w	$FFC9,$0050,$0064,$0028,$FFF6,$000A,$FFCE,$0000