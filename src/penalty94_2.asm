;	NHL 94 (retail) segment $12C04-$138AB
;	92 Penalty.Asm part 2, as 93 penalty93_2.asm: PrintScores1, PrintTeamNameAndScore, PrintTeamLogoAndScore, EASNLogo,
;	USBoard, pplpen, linebar, getlinee, AvgCline, ChkShotStat, loadTeamStruct, SetupTeamForIntermission, the 94-only
;	RestoreTeamEnergy, reenergizeteam, Intermission, InitScores, UpdateScores, SetScore, sctab, NewTicker, NewTicker2,
;	NewTicker3, NewTicker3pt2, GameLabels, ClearTickerArea, SetTickerAreaPosition, PrintStringFromList, AdvanceStringPtr,
;	DoHiLights, StartHL, StartHL2. checkcoll (hockey94_03) follows at $138AC.
;	Transcribed from lst/nhl94.bin.lst lines 47136-48479. Global names are the IDA names, or the 93 name where IDA has an
;	auto name or where the routine is the 93 one (AdvanceStringPtr, IDA Adda1Offset). 94 IDA NewTicker3 is 93 CheckGameTickerStatus and
;	NewTicker3pt2 is 93 NewTicker3; the IDA names are kept. The IDA sub_ routines that 93 writes as locals are locals here too (.dispen, .r, .tn,
;	.setteam, .ranres, .sv, .lo), and IDA getscore is the 93 SetScore .getscore. Local labels are the IDA local names (_x -> .x) or the 93
;	local where the code matches, else in the 93 style (.x exit, .loop, numbered), with the IDA label in an ;IDA: comment.
;	IDA shows the printz strings as dc.b, ori.b or (in StartHL2) as code; they are written with the String macro (length
;	word includes itself and the 0 pad). Five instructions IDA hid in strings are written out. The tables IDA left as dc.b
;	(.sslist, sctab, GameLabels, .postab) are written as dc.l / dc.w / String.
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp / cmpi;
;	fixopcodes.js patches the cmp encoding after assembly.
;	94 team struct from HmShots / AwShots (tmsize $364): 0 tmshots, $C tmscore, $16 tmline, $1E tmdata, $22 tmsort, $24 tmap,
;	$26 tmgoalie, $32 tmpde, $66 tmpdst, $9A penalty box list, $E8 per-player shot bytes, $16A line sets, $34A shots by
;	period, $354 power play shots. Game struct (gsstruct, $10 each): 0 gst1, 2 gst2, 8 gsper, $A gss1, $C gss2, $E gsflags
;	(bit 1 gsfhl, bit 2 gsfso).

PrintScores1	;IDA name (93 printscores1). Draw scoreboard. Vertical rink: period box and the score box (team names and scores). Horizontal rink
	;(.sbscreen, 93 .sbscreen): period and both team logos with big scores. 94: the period name is gsp of PerLabels, or name 4 of PenShotPenalties2
	;when gmode2 bit 1 is set; the horizontal rink uses PenShotPenalties2 (name 4 when bit 0 is set). sflags5 bit 7 sets crowdnoisedelay = $78.
	;Called from USBoard, Pausemode, lcfound2 and others
	movem.l	d0-d2/a0-a3,-(sp)
	btst	#sfhor,(sflags).w	;sfhor
	bne.w	.sbscreen
	bclr	#7,(sflags5).w	;94 only
	beq.w	.0
	move.w	#$78,(crowdnoisedelay).w
.0
	bsr.w	printz
	String	$BF,0,$17
	moveq	#9,d0
	moveq	#5,d1
	bsr.w	Framer
	bset	#dfclock,(disflags).w	;dfclock
	bsr.w	printz
	String	$BF,1,$18
	move.w	(gsp).w,d0	;period name
	movea.l	#PerLabels,a1	;93 PerLabels
	btst	#1,(gmode2).w	;94 only
	beq.w	.1
	move.w	#4,d0
	movea.l	#PenShotPenalties2,a1
.1
	bsr.w	PrintStringFromList
	bsr.w	EASNLogo
	btst	#sf3llcs,(sflags3).w	;sf3llcs: lower line change box is up
	bne.w	.ex
	bsr.w	printz
	String	$BF,$17,$17		;IDA: ori.b / move.b d0,-(a3)
	moveq	#8,d0
	moveq	#5,d1
	bsr.w	Framer
	bsr.w	printz
	String	$BF,$18,$1A	;home team on the lower row. IDA: ori.b / move.b d0,d5
	movea.w	#(HmShots-M68K_RAM),a2
	bsr.w	PrintTeamNameAndScore
	bsr.w	printz
	String	$BF,$18,$18		;IDA: ori.b / move.b d0,d4
	adda.w	#tmsize,a2	;tmsize
	bsr.w	PrintTeamNameAndScore
.ex
	movem.l	(sp)+,d0-d2/a0-a3
	rts
.sbscreen
	bsr.w	printz
	String	$BE,$11,2
	move.w	(gsp).w,d0	;IDA hid this in the string (ori.b / andi.b / and.w)
	btst	#0,(gmode2).w
	beq.w	.2
	move.w	#4,d0
.2
	movea.l	#PenShotPenalties2,a1	;94: the horizontal rink always takes the name from PenShotPenalties2
	bsr.w	AdvanceStringPtr
	move.w	(a1),d0
	lsr.w	#1,d0	;center the period name on x $11
	sub.w	d0,(printx).w
	bsr.w	print
	bsr.w	printz
	String	$BE,$17,2
	movea.w	#(HmShots-M68K_RAM),a2	;IDA hid this in the string (ori.b / andi.b / mulu.w)
	clr.w	d0	;home logo data offset
	bsr.w	PrintTeamLogoAndScore
	bsr.w	printz
	String	$BE,8,2
	adda.w	#tmsize,a2	;tmsize. IDA hid this in the string (ori.b / andi.b / bchg)
	move.w	#$2C,d0	;visitor logo data offset (93 $30)
	bsr.w	PrintTeamLogoAndScore
	bra.s	.ex
PrintTeamNameAndScore	;93 name. Print the team name of team a2 at printx/printy, then its score as 2 digits at x $1C. Called twice from PrintScores1
	movea.l	tmdata(a2),a1	;tmdata
	adda.w	4(a1),a1
	adda.w	(a1),a1	;skip the first string to the team name
	bsr.w	print
	move.w	#$1C,(printx).w
	move.w	tmscore(a2),d0	;tmscore
	moveq	#2,d1
	bsr.w	PushNumberWidth
	bra.w	print
PrintTeamLogoAndScore	;93 name. Draw the team logo map (PrintTeamData, d0 = offset) 5 columns left of printx (93 6),
	;then the score of team a2 in big font, centered 2 rows lower; 94 moves a 2 digit score one more left. Called twice from PrintScores1
	move.w	(printx).w,-(sp)
	subq.w	#5,(printx).w
	jsr	(PrintTeamData).l	;93 PrintTeamData
	move.w	(sp)+,(printx).w
	addq.w	#2,(printy).w
	move.w	tmscore(a2),d0	;tmscore
	cmp.w	#$A,d0	;94 only
	bge.w	.0
	bra.w	.1
.0
	subq.w	#1,(printx).w
.1
	bsr.w	PushNumber
	move.w	(a1),d0	;center on the old printx
	subq.w	#2,d0
	lsr.w	#1,d0
	sub.w	d0,(printx).w
	addq.w	#1,(printx).w
	bra.w	printbig
EASNLogo	;93 name. Draw the EASN logo map at x 1, y $19 on the vertical ice rink if no power play. 94 has no DrawEASNMap entry. Called from PrintScores1 and updatepwrplay
	btst	#sf2pwrplay,(sflags2).w	;sf2pwrplay
	bne.w	rtss2
	bsr.w	printz
	String	$BF,1,$19		;IDA: ori.b / move.b d0,-(a4)
	movea.l	#EASNmap,a1	;93 EASNmap
	adda.l	4(a1),a1
	movea.w	#$30A,a2	;93 #$310
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2	;width and height from the map header
	move.w	2(a1),d3
	move.w	(EASNcset).w,d4	;93 EASNcset
	clr.w	d5
	bra.w	dobitmap
USBoard	;93 name. Update score board, including the players in the penalty box and their time remaining. Called from InProgress and SetHor
	movem.l	d0-d7/a0-a3,-(sp)
	bset	#dfclock,(disflags).w	;dfclock
	bsr.w	PrintScores1
	bsr.w	printz
	String	$BE,$14,8
	movea.w	#(HmShots-M68K_RAM),a2	;home team. IDA hid this in the string (ori.b / #$7C / mulu.w)
	bsr.w	.dispen
	bsr.w	printz
	String	$BE,5,8
	movea.w	#(AwShots-M68K_RAM),a2	;visitors. IDA hid this, the bsr.w and the movem.l in the string (ori.b / #$7C / and.b / ori.b / d7)
	bsr.w	.dispen
	movem.l	(sp)+,d0-d7/a0-a3
	rts
.dispen	;93 .dispen, IDA USBoard_dispen. Penalty box list of team a2: the players without a coincidental penalty first, then those with one
	lea	$9A(a2),a0
.l1
	clr.w	d0
	move.b	(a0)+,d0
	bmi.w	.p2	;end of list
	btst	#6,tmpdst(a2,d0.w)	;coincidental (tmpdst high byte bit 6)
	bne.s	.l1
	bsr.w	pplpen
	bra.s	.l1
.p2
	lea	$9A(a2),a0
.l2
	clr.w	d0
	move.b	(a0)+,d0
	bmi.w	rtss2
	btst	#6,tmpdst(a2,d0.w)
	beq.s	.l2
	bsr.w	pplpen
	bra.s	.l2
pplpen	;93 IDA pplpen?. Print one penalty box line: player number and time remaining. a2 = team, d0 = roster offset (player*2). Only
	;rows up to y $A are printed; printy += 1. Called from USBoard .dispen
	cmpi.w	#$A,(printy).w
	bhi.w	rtss2	;no room for more rows
	move.w	tmpdst(a2,d0.w),d2
	andi.w	#$7FF,d2	;penalty time
	movea.l	tmdata(a2),a1	;tmdata
	adda.w	(a1),a1
	lsr.w	#1,d0
.find
	adda.w	(a1),a1	;skip d0+1 roster entries (name string + 8 bytes)
	addq.w	#8,a1
	dbf	d0,.find
	clr.w	d0
	move.b	-8(a1),d0	;player number (BCD)
	move.w	(printx).w,-(sp)
	movea.w	#(TextBuffer-M68K_RAM),a1	;93 TextBuffer (mesarea+2)
	bsr.w	d0toascii	;93 ConverByteToDigits
	movea.w	#(mesarea-M68K_RAM),a1
	move.w	#4,(a1)	;string length: 2 digits
	bsr.w	print
	move.w	d2,d0
	bsr.w	PushTime
	bsr.w	print
	move.w	(sp)+,(printx).w
	addq.w	#1,(printy).w
	rts
linebar	;93 name. Draw the energy bar of line d0 for team a2 at printx/printy (bitmap from the bar map, 16 steps). Called from SetLCmode2
	movem.l	d0-d5/a0-a2,-(sp)
	bsr.w	getlinee
	move.w	(printa).w,-(sp)
	move.w	#$8000,(printa).w
	ext.l	d0
	divu.w	#$100,d0	;4096/16
	cmp.w	#$F,d0
	bls.w	.ok
	moveq	#$F,d0
.ok
	moveq	#$F,d1	;d1 = bar frame (15 = empty)
	sub.w	d0,d1
	clr.w	d0
	movea.l	#EnergyBarMap,a1	;93 EnergyBarMap
	adda.l	4(a1),a1
	movea.w	#$30A,a2	;93 #$310
	move.w	(a1),d2
	moveq	#1,d3
	move.w	(energybarchars).w,d4
	moveq	#0,d5
	bsr.w	dobitmap
	move.w	(sp)+,(printa).w
	movem.l	(sp)+,d0-d5/a0-a2
	rts
getlinee	;d0 = line number, a2 = team struct. Return d0 = energy level of this line
	movem.l	d1-d5/a0-a3,-(sp)
	lea	$16A(a2),a1	;line sets
	asl.w	#3,d0
	adda.w	d0,a1
	clr.l	d0
	clr.w	d1
	movea.l	#priolist,a0
	move.w	tmap(a2),d4	;tmap
	bra.w	.next
.loop
	clr.w	d5
	move.b	0(a0,d4.w),d5	;position
	beq.w	.next	;goalie energy doesn't count
	clr.w	d3
	move.b	0(a1,d5.w),d3	;player number
	asl.w	#1,d3
	addq.w	#1,d1
	add.w	tmpde-2(a2,d3.w),d0	;tmpde-2
.next
	dbf	d4,.loop
	divu.w	d1,d0
	movem.l	(sp)+,d1-d5/a0-a3
	rts
AvgCline	;93 name. Return d0 = average energy of current line on team a2
	movem.l	d1-d3/a0,-(sp)
	clr.l	d0
	clr.w	d1
	moveq	#5,d2
	movea.w	tmsort(a2),a0	;tmsort
.loop
	tst.w	position(a0)	;position
	ble.w	.next
	clr.w	d3
	move.b	pnum(a0),d3	;pnum
	add.w	d3,d3
	add.w	tmpde(a2,d3.w),d0	;tmpde
	addq.w	#1,d1
.next
	adda.w	#SCstruct,a0
	dbf	d2,.loop
	tst.w	d1
	beq.w	.ex
	divu.w	d1,d0
.ex
	movem.l	(sp)+,d1-d3/a0
	rts
ChkShotStat	;determine if shot taken, add to appropriate stats. As 93: crowd, team, shooter and goalie shots against. 94 adds: nothing while the
	;clock is stopped or in a highlight, PP shots ($354) and period shots ($34A), and a second path (sflags4 bit 0, sflags8 bit 3 every
	;second call) that counts the shot for the player in the last ScoreSum entry
	btst	#0,(gmode).w	;gmclock: clock stopped
	bne.w	rtss2	;exit if so
	btst	#4,(gmode).w	;gmhl: highlight
	bne.w	rtss2	;exit if so
	bclr	#4,(sflags2).w	;sf2shot: shot taken
	bne.w	.Cwdupdate	;it was set
	btst	#0,(sflags4).w	;94 only
	beq.w	rtss2	;exit if cleared
	bclr	#3,(sflags8).w
	bne.w	.0
	bset	#3,(sflags8).w
	bra.w	rtss2
.0
	movem.l	d0-d1/a1-a3,-(sp)
	move.l	a4,-(sp)
	movea.l	#ScoreSum-6,a4	;IDA: #$FFFFC46E (ChkCnt). +ScoreSumbytes, then 2(a4) = the last ScoreSum entry
	adda.w	(ScoreSumbytes).w,a4
	movea.l	#HmShots,a2	;home team
	btst	#7,2(a4)	;entry flag: visitors
	beq.w	.pllookup
	adda.w	#$364,a2	;tmsize
.pllookup
	clr.w	d0
	move.b	3(a4),d0	;pnum (roster offset)
	movea.l	(sp)+,a4
	movea.w	$22(a2),a2	;tmsort
	move.w	#5,d1
.findplayer
	cmp.b	$66(a2),d0	;pnum
	beq.w	.foundplayer
	adda.w	#$80,a2	;SCstruct
	dbf	d1,.findplayer
	bra.w	.ex
.foundplayer
	move.w	$52(a2),d0	;SCnum
	bra.w	.addShot
.Cwdupdate
	movem.l	d0-d1/a1-a3,-(sp)
	addi.w	#$64,(crowdlevel).w	;100
	addi.w	#$A,(CwdExciteLvl).w
	move.w	(shotplayer).w,d0
.addShot
	asl.w	#7,d0	;scsize
	movea.w	#(SortCords-M68K_RAM),a3
	adda.w	d0,a3
	bsr.w	loadTeamStruct
	addq.w	#1,(a2)	;tmshots
	btst	#5,(sflags2).w	;sf2pwrplay
	beq.w	.2
	btst	#6,(sflags2).w	;sf2pwrtm: 0 home, 1 visitors
	bne.w	.1
	btst	#6,$62(a3)	;pfteam
	bne.w	.2	;not the team on the power play
.PPshot
	addq.w	#1,$354(a2)	;power play shots
	bra.w	.2
.1
	btst	#6,$62(a3)	;pfteam
	bne.s	.PPshot
.2
	move.l	a2,-(sp)
	move.w	(gsp).w,d0	;period
	add.w	d0,d0
	adda.w	d0,a2
	addq.w	#1,$34A(a2)	;shots by period
	movea.l	(sp)+,a2
	clr.w	d0
	move.b	pnum(a3),d0	;pnum
	addi.w	#$E8,d0
	addq.b	#1,0(a2,d0.w)	;shooter's shot count
	move.w	tmgoalie(a1),d0	;other team's tmgoalie
	bmi.w	.ex	;empty net
	addi.w	#$E8,d0
	addq.b	#1,0(a1,d0.w)	;goalie's shots against
.ex
	movem.l	(sp)+,d0-d1/a1-a3
	rts
loadTeamStruct	;return a2 = team struct of player a3, a1 = the other team's struct. Called from ChkShotStat and updateplayers
	movea.w	#(HmShots-M68K_RAM),a2
	lea	tmsize(a2),a1	;tmsize
	btst	#pfteam,pflags(a3)	;pfteam
	beq.w	rtss2
	exg	a1,a2
	rts
SetupTeamForIntermission	;93 name. Reset the bench, then for each team refill energy and pick the starting line: 92 Pw1 (3)
	;for the team with more players on ice, PK1 (5) for the team with fewer, else 0. Called from Intermission
	bsr.w	ResetBench
	movea.w	#(HmShots-M68K_RAM),a2
	lea	tmsize(a2),a3
	bsr.w	.r
	exg	a2,a3	;falls in for the other team
.r	;93 .r
	bsr.w	reenergizeteam
	clr.w	tmline(a3)	;tmline
	tst.w	(OptLine).w
	bne.w	rtss2	;line changes off
	move.w	tmap(a3),d0
	sub.w	tmap(a2),d0
	beq.w	rtss2
	move.w	#3,tmline(a3)	;Pw1
	tst.w	d0
	bpl.w	rtss2
	move.w	#5,tmline(a3)	;PK1
	rts
RestoreTeamEnergy	;94 only. a2 = team: max energy (tmpde $1000) for every player. The skip needs tmpdst to be both -3 and -4, so it never happens.
	;Called from $9DD0 / $9DDA (the menu code before ReplayMode)
	moveq	#$32,d0	;(MaxRos-1)*2
.loop
	cmpi.w	#$FFFD,$66(a2,d0.w)
	bne.w	.0
	cmpi.w	#$FFFC,$66(a2,d0.w)
	bne.w	.0
	bra.w	.1
.0
	move.w	#$1000,$32(a2,d0.w)	;tmpde
.1
	subq.w	#2,d0
	bpl.s	.loop
	rts
reenergizeteam	;93 name. Set all players to max energy on team a2 except those at tmpdst -4 (94); players marked -3 in tmpdst go to
	;the bench (-2). Called from SetupTeamForIntermission and StartHL2 .setteam
	moveq	#$32,d0	;(MaxRos-1)*2
.loop
	cmpi.w	#$FFFC,$66(a2,d0.w)	;94 only
	beq.w	.nb
	move.w	#$1000,tmpde(a2,d0.w)	;tmpde
	cmpi.w	#$FFFD,tmpdst(a2,d0.w)
	bne.w	.nb
	move.w	#$FFFE,tmpdst(a2,d0.w)	;on bench
.nb
	subq.w	#2,d0
	bpl.s	.loop
	rts
Intermission	;end of period junk (zamboni/stats). As 93: opens the pause menu screen (item list by period, +5 in playoffs), shows the ticker scores
	;of the other games, then the highlights; Start on either pad cuts it short. 94: when gsp is 4 the clock is cleared and UpdateRecords runs first,
	;and gmode2 bit 0 picks the ShootoutIntermissionMenu item list. Called from PeriodOver
	cmpi.w	#4,(gsp).w
	bne.w	.1
	move.w	#0,(gameclock).w
	jsr	(UpdateRecords).l	;94 only
.1
	bsr.w	SetupTeamForIntermission
	moveq	#$F,d0
	movea.w	#(SortCords-M68K_RAM),a0
.0
	clr.w	(a0)	;Xpos
	adda.w	#SCstruct,a0	;SCstruct
	dbf	d0,.0
	move.w	(ExtraChars).w,d4
	movea.l	#ZamFrameList+8,a2	;93 ZamSprites+8
	bsr.w	DoDMA_clearCallbackPointer
	move.w	#$140,(zamx).w	;320
	move.w	(gsp).w,d0
	tst.w	(OptPlayMode).w
	beq.w	.ss
	addq.w	#5,d0	;playoffs
.ss
	asl.w	#2,d0
	lea	.sslist(pc),a0
	movea.l	0(a0,d0.w),a0
	btst	#0,(gmode2).w	;94 only
	beq.w	.2
	movea.l	#ShootoutIntermissionMenu,a0
.2
	bset	#sfpz,(sflags).w	;sfpz
	movea.l	#SetupPauseScreen,a1
	jsr	(InitMenuState).w	;93 InitMenuState
	bsr.w	GetShifter
	move.w	d1,(TickerNum).w
.top
	tst.w	(TickerNum).w
	bmi.w	.doh	;no more ticker games
	bsr.w	NewTicker2
	bsr.w	NewTicker3pt2	;93 NewTicker3
	move.w	#$96,d0	;150 frames
	bsr.w	IntermissionLoop
	btst	#7,d1	;sbut
	bne.w	.clrh
	bsr.w	ClearTickerArea
	move.w	#$3C,d0	;60 frames
	bsr.w	IntermissionLoop
	btst	#7,d1
	beq.s	.top
.clrh
	bset	#sf3sbut,(sflags3).w	;sf3sbut
.doh
	bsr.w	DoHiLights
	bclr	#sf3sbut,(sflags3).w
	bne.w	.clrz
.wait
	move.w	#$1E0,d0	;480 frames
	bsr.w	IntermissionLoop
	btst	#7,d1
	bne.w	.clrz
	tst.w	(cont1team).w
	bne.s	.wait	;keep waiting while a pad is on a team
	tst.w	(cont2team).w
	bne.s	.wait
.clrz
	st	(zamx).w
	rts
.sslist	;93 .sslist. Menu item lists by period, then playoff period
	dc.l	StartGameText,IntermissionText,IntermissionText,IntermissionText,ExitGameText
	dc.l	StartGameTextPO,IntermissionText,IntermissionText,IntermissionText,ExitGameTextPO
InitScores	;initialize other games scores/period in playoffs. Called from StartGame
	cmpi.w	#1,(gamelevel).w
	bgt.w	rtss2
	bsr.w	GetShifter
	movea.w	#(gsstruct-M68K_RAM),a0
	moveq	#$10,d0	;gssize
	mulu.w	d1,d0
	adda.w	d0,a0
.top
	cmp.w	(gamenum).w,d1
	beq.w	.next
	btst	#2,$E(a0)	;gsfso
	bne.w	.next
	clr.w	8(a0)	;gsper
	moveq	#3,d0
	bsr.w	randomd0
	bra.w	.1
.0
	bsr.w	SetScore
.1
	dbf	d0,.0
.next
	suba.w	#$10,a0	;gssize
	dbf	d1,.top
	rts
UpdateScores	;update ticker score values. Called from PeriodOver
	bsr.w	GetShifter
	move.w	d1,(TickerNum).w
	movea.w	#(gsstruct-M68K_RAM),a0
	moveq	#$10,d0	;gssize
	mulu.w	d1,d0
	adda.w	d0,a0
.top
	cmp.w	(gamenum).w,d1
	beq.w	.next
	bclr	#1,$E(a0)	;gsfhl
	btst	#2,$E(a0)	;gsfso
	bne.w	.next
	bsr.w	SetScore
.next
	suba.w	#$10,a0	;gssize
	dbf	d1,.top
	rts
SetScore	;add to score for game in a0. After period 3 a game within one goal goes to OT (gsper 3) and asks for a highlight
	cmpi.w	#4,8(a0)	;gsper
	bge.w	rtss2
	movem.l	d0-d1/a0-a1,-(sp)
	cmpi.w	#3,8(a0)
	bne.w	.o
	move.w	#5,8(a0)	;final
	move.w	$A(a0),d0	;gss1
	sub.w	$C(a0),d0	;gss2
	cmp.w	#1,d0
	bgt.w	.ex
	cmp.w	#$FFFF,d0
	blt.w	.ex
	move.w	#3,8(a0)	;close game: overtime
	bset	#1,$E(a0)	;gsfhl
	bra.w	.ex
.o
	addq.w	#1,8(a0)
	move.w	(a0),d0	;gst1
	move.w	2(a0),d1	;gst2
	bsr.w	.getscore
	add.w	d0,$A(a0)	;gss1
	move.w	2(a0),d0
	move.w	(a0),d1
	bsr.w	.getscore
	add.w	d0,$C(a0)	;gss2
.ex
	movem.l	(sp)+,d0-d1/a0-a1
	rts
.getscore	;IDA: getscore. 93 SetScore .getscore. d0 = scoring team, d1 = other team. Adds the scoring team's (bits 4-6) and the other team's (bits 0-2) sctab rows as weights. Return d0 = goals 0-3
	asl.w	#2,d0
	movea.w	#$30E,a1	;TeamList (93 $314)
	movea.l	0(a1,d0.w),a1
	adda.w	8(a1),a1	;92 ScoreOdds
	move.b	(a1),d0
	andi.w	#$70,d0
	lsr.w	#1,d0	;row * 8
	lea	sctab(pc),a1
	move.l	0(a1,d0.w),(nibblebuffer).w
	move.l	4(a1,d0.w),(nibblebuffer+4).w
	asl.w	#2,d1
	movea.w	#$30E,a1	;TeamList
	movea.l	0(a1,d1.w),a1
	adda.w	8(a1),a1
	move.b	(a1),d0
	andi.w	#7,d0
	asl.w	#3,d0
	lea	sctab(pc),a1
	move.l	0(a1,d0.w),d1
	add.l	d1,(nibblebuffer).w
	move.l	4(a1,d0.w),d1
	add.l	d1,(nibblebuffer+4).w
	moveq	#4,d0	;4 weights
	bra.w	WeightedRandomSelect
sctab	;IDA name (93 SetScore .sctab). Weights for 0, 1, 2, 3 goals, 8 rows (92 had 4 percent bytes per row)
	dc.w	$2B,$1E,$17,4
	dc.w	$27,$20,$18,5
	dc.w	$23,$21,$1A,6
	dc.w	$1E,$22,$1E,6
	dc.w	$1A,$24,$1E,8
	dc.w	$16,$25,$1F,$A
	dc.w	$13,$26,$1F,$C
	dc.w	$F,$26,$20,$F
NewTicker	;show the next ticker score once the clock is at 8:00 or less. d3 = -1 if not. Called from chkprogress. Falls into NewTicker2
	moveq	#-1,d3
	cmpi.w	#$1E0,(gameclock).w	;480
	bgt.w	rtss2
NewTicker2	;goto next ticker. Return d3 = game, or neg if none left. Falls into NewTicker3
	move.w	(TickerNum).w,d3
	bmi.w	rtss2
	subq.w	#1,(TickerNum).w
	cmp.w	(gamenum).w,d3	;don't show current game as ticker
	beq.s	NewTicker2
NewTicker3	;IDA name (93 CheckGameTickerStatus). d3 = game. Return a0 = its gstruct; skip to the next ticker game if a highlight is coming up or the series is over. Called from StartHL2
	moveq	#$10,d0	;gssize
	mulu.w	d3,d0
	movea.w	#(gsstruct-M68K_RAM),a0
	adda.w	d0,a0
	btst	#1,$E(a0)	;gsfhl
	bne.s	NewTicker2	;don't show if hilite coming up
	btst	#2,$E(a0)	;gsfso
	bne.s	NewTicker2	;don't show if the series is over for this game
	rts
NewTicker3pt2	;IDA name (93 NewTicker3). Display ticker score for game d3 (a0 = gstruct entry), skip if d3 is negative. Called from chkprogress, Intermission and StartHL2
	tst.w	d3
	bmi.w	rtss2
	bsr.w	SetTickerAreaPosition
	bsr.w	Framer
	addq.w	#1,(printx).w
	subq.w	#4,(printy).w
	move.w	(printx).w,-(sp)
	bsr.w	GetShifter
	move.w	#$A000,(printa).w
	bsr.w	printz
	String	'                        '	;24 spaces
	move.w	(sp),(printx).w
	moveq	#1,d0
	add.w	(gamelevel).w,d0
	tst.w	(OptPlayMode).w
	bne.w	.0
	clr.w	d0	;not playoffs: 'EA Hockey Night'
.0
	lea	GameLabels(pc),a1
	bsr.w	PrintStringFromList
	move.w	8(a0),d0	;gsper
	subq.w	#1,d0
	movea.l	#PerLabels,a1	;93 PerLabels
	bsr.w	AdvanceStringPtr
	move.w	(a1),d0	;period name centered on x+$17
	lsr.w	#1,d0
	neg.w	d0
	add.w	(sp),d0
	addi.w	#$17,d0
	move.w	d0,(printx).w
	bsr.w	print
	move.w	#$8000,(printa).w
	move.w	2(a0),d0	;gst2
	move.w	$C(a0),d1	;gss2
	bsr.w	.tn
	move.w	(a0),d0	;gst1
	move.w	$A(a0),d1	;gss1
	bsr.w	.tn
	addq.w	#2,sp
	rts
.tn	;93 .tn, IDA NewTicker3_tn. Print team d0 name and score d1 on the next row
	move.w	4(sp),(printx).w
	addq.w	#1,(printy).w
	movea.w	#$30E,a1	;TeamList (93 $314)
	asl.w	#2,d0
	movea.l	0(a1,d0.w),a1
	adda.w	4(a1),a1	;team name
	bsr.w	print
	move.w	4(sp),(printx).w
	addi.w	#$15,(printx).w	;92 23
	move.w	d1,d0
	moveq	#2,d1
	bsr.w	PushNumberWidth
	bra.w	print
GameLabels	;93 name. Ticker titles, by OptPlayMode and gamelevel
	String	'EA Hockey Night'
	String	'Stanley Cup Qualifier'
	String	'Quarterfinal'
	String	'Stanley Cup Semifinal'
ClearTickerArea	;93 name. Erase the ticker box. Called from Intermission and StartHL2
	bsr.w	SetTickerAreaPosition
	move.w	#$7FF,d2	;blank char
	bra.w	eraser
SetTickerAreaPosition	;93 name. Set printx/printy/printm for the ticker box (x 3, y $17; the $BD map in pause mode). Return d0 =
	;$1A wide, d1 = 5 high. Called from NewTicker3pt2 and ClearTickerArea
	bsr.w	printz
	String	$BD,3,$17		;IDA: ori.b / move.b d0,-(a3)
	btst	#sfpz,(sflags).w	;sfpz
	bne.w	.1
	bsr.w	printz
	String	$BF,3,$17		;IDA: ori.b / move.b d0,-(a3)
.1
	moveq	#$1A,d0
	moveq	#5,d1
	rts
PrintStringFromList	;93 name. Print string d0 of the String list a1 with print2 (93 printsmall)
	bsr.w	AdvanceStringPtr
	bra.w	print2
AdvanceStringPtr	;IDA: Adda1Offset. Return a1 = string d0 of the String list a1 (92 Fprint without the print)
	bra.w	.0
.loop
	adda.w	(a1),a1
.0
	dbf	d0,.loop
	rts
DoHiLights	;93 name. Hilites logic: search for hilite game and show hilite. Called from Intermission
	bsr.w	GetShifter
	moveq	#$10,d3	;gssize
	mulu.w	d1,d3
	movea.w	#(gsstruct-M68K_RAM),a0
	adda.w	d3,a0
.top
	btst	#2,$E(a0)	;gsfso
	bne.w	.next
	bclr	#1,$E(a0)	;gsfhl
	beq.w	.next
	bsr.w	StartHL
.next
	suba.w	#$10,a0	;gssize
	dbf	d1,.top
	rts
StartHL	;93 name. Play hilite for game a0, d1 = game. Called from DoHiLights. Falls into StartHL2
	movem.l	d0-d7/a0-a6,-(sp)
StartHL2	;93 name. Play hilite for game a0. Start skips it with a random result. A tied game is replayed (beq StartHL2). 94:
	;song $79 (93 $36), setupice_highlight, setplayercolors
	btst	#sf3sbut,(sflags3).w	;sf3sbut
	bne.w	.nhl0
	bsr.w	.sv
	move.w	d1,d3
	bsr.w	NewTicker3
	bsr.w	NewTicker3pt2	;show score from hilight game
	btst	#sf3sbut,(sflags3).w
	bne.w	.nhl1
	move.w	#4,(printx).w
	subq.w	#6,(printy).w
	moveq	#$18,d0	;24
	moveq	#3,d1
	bsr.w	Framer
	addq.w	#1,(printx).w
	subq.w	#2,(printy).w
	bsr.w	printz
	String	'Highlight from game:'	;IDA decoded the text as code
	move.w	#$B4,d0	;180 frames
	bsr.w	IntermissionLoop
	btst	#7,d1	;sbut
	bne.w	.nhl1
	st	(zamx).w
	clr.w	(CwdExciteLvl).w
	move.w	(a0),(HomeTeam).w	;set up teams for game in a0
	move.w	2(a0),(VisTeam).w
	move.l	a0,-(sp)
	clr.w	(HmShots+tmgoalie).w
	clr.w	(AwShots+tmgoalie).w
	jsr	(clearTeamStats).l
	jsr	(restoreteams).w
	st	(c1playernum).w
	st	(c2playernum).w
	clr.w	(cont1team).w
	clr.w	(cont2team).w
	moveq	#$78,d0	;120
	bsr.w	randomd0
	addi.w	#$3C,d0	;60
	move.w	d0,(gameclock).w
	movea.l	(sp),a0
	move.w	8(a0),(gsp).w	;gsper
	subq.w	#1,(gsp).w
	move.w	$A(a0),(HmGoals).w	;gss1
	move.w	$C(a0),(AwGoals).w	;gss2
	move.b	#$10,(gmode).w	;1<<gmhl
	btst	#0,(gsp+1).w
	beq.w	.ndi
	bset	#gmdir,(gmode).w	;gmdir
.ndi
	clr.b	(sflags).w
	move.b	#4,(sflags2).w	;1<<sf2drec
	clr.b	(sflags3).w
	bclr	#4,(disflags).w
	bset	#dfclock,(disflags).w	;dfclock
	clr.w	(glovecords).w
	clr.b	(iflags).w
	st	(RefCnt).w
	st	(puckcross2).w
	st	(puckcross6).w
	jsr	(p_turnoff).l
	bsr.w	setupice_highlight	;93 setupice_highlight
	bsr.w	ClrHor
	movea.l	#VDP_DATA,a0
	move.w	#$9100,4(a0)	;window H position 0
	move.w	#$9200,4(a0)	;window V position 0
	move.w	(ExtraChars).w,d4	;ref cam chars
	movea.l	#RefsMap+8,a2	;93 RefsMap+8
	bsr.w	DoDMA_clearCallbackPointer
	clr.w	(Vpos).w
	clr.w	(Hpos).w
	bsr.w	ResetBench
	movea.w	#(HmShots-M68K_RAM),a2
	bsr.w	.setteam
	adda.w	#tmsize,a2	;tmsize
	bsr.w	.setteam
	bsr.w	resetplstuff
	moveq	#$B,d0
	movea.l	#.postab,a0
	movea.w	#(SortCords-M68K_RAM),a1
.loop
	move.w	position(a1),d1	;position
	btst	#pfgoal,pflags(a1)	;pfgoal
	bne.w	.pl0
	addq.w	#6,d1
.pl0
	asl.w	#2,d1
	move.w	0(a0,d1.w),(a1)	;Xpos
	move.w	2(a0,d1.w),Ypos(a1)	;Ypos
	clr.w	Xvel(a1)	;Xvel
	clr.w	Yvel(a1)	;Yvel
	adda.w	#SCstruct,a1
	dbf	d0,.loop
	bsr.w	SprSort
	move.w	#$18,(palcount).w
	move.w	(vcount).w,(oldvcount).w
	move.w	#$B4,-(sp)	;180 frames after the clock stops
.0
	jsr	(DoGameFrame).w
	btst	#gmclock,(gmode).w	;gmclock
	beq.w	.1
	subq.w	#1,(sp)
	bmi.w	.endhl
.1
	bsr.w	orjoy
	btst	#5,d1	;cbut
	bne.w	.2
	btst	#7,d1	;sbut
	beq.s	.0
.2
	move.w	(HmGoals).w,d0	;tied: random winner
	cmp.w	(AwGoals).w,d0
	bne.w	.endhl
	move.w	(VDP_CNTR).l,d0	;hvcount
	andi.w	#1,d0
	add.w	d0,(HmGoals).w
	eori.w	#1,d0
	add.w	d0,(AwGoals).w
.endhl
	addq.w	#2,sp
	movea.l	(sp)+,a0
	movem.l	d1/a0,-(sp)
	jsr	(KillCrowd).l
	jsr	(p_turnoff).l
	movem.l	(sp)+,d1/a0
	move.w	(HmGoals).w,$A(a0)	;gss1
	move.w	(AwGoals).w,$C(a0)	;gss2
	bsr.w	forceblack
	moveq	#$F,d0
	movea.w	#(SortCords-M68K_RAM),a0
.clr
	clr.w	(a0)
	adda.w	#SCstruct,a0
	dbf	d0,.clr
	bsr.w	.lo
	bsr.w	setplayercolors
	bsr.w	SetHor
	bsr.w	setvideo
	jsr	(SetupPauseScreen).w	;pause menu screen
	jsr	(DrawMenuScreen).w	;93 DrawMenuScreen
	move.w	#$18,(palcount).w
	move.w	#$79,-(sp)	;song $79 (93 $36)
	bsr.w	song
	movem.l	(sp),d0-d7/a0-a6
	move.w	#4,8(a0)	;gsper: OT
	move.w	$A(a0),d0
	cmp.w	$C(a0),d0
	beq.w	StartHL2	;still tied: play another hilite
	move.w	#5,8(a0)	;final
	move.w	d1,d3
	bsr.w	NewTicker3
	bsr.w	NewTicker3pt2
	move.w	#$B4,d0
	bsr.w	IntermissionLoop
	btst	#7,d1
	bne.w	.exit2
	bsr.w	ClearTickerArea
	move.w	#$3C,d0
	bsr.w	IntermissionLoop
	btst	#7,d1
	beq.w	.exit
.exit2
	bset	#sf3sbut,(sflags3).w	;93 .exit2. sf3sbut
.exit
	movem.l	(sp)+,d0-d7/a0-a6	;93 .exit
	rts
.nhl1
	bsr.w	.lo	;93 .nhl1
	bsr.w	.ranres
	bra.s	.exit2
.nhl0
	bsr.w	.ranres	;93 .nhl0
	bra.s	.exit
.setteam	;93 .setteam, IDA SetupTeamForReplay. Refill energy, set personnel; 94 also clears sflags8 bit 7
	jsr	(reenergizeteam).l
	bsr.w	SetPersonel
	bsr.w	forcepldata
	st	$18(a2)
	bclr	#7,(sflags8).w
	st	$1A(a2)
	st	$1C(a2)
	rts
.ranres	;93 .ranres. Random resolve of game (if tied = random score)
	move.w	$A(a0),d0
	cmp.w	$C(a0),d0
	bne.w	.rr0
	move.w	(VDP_CNTR).l,d0	;hvcount
	andi.w	#1,d0
	add.w	d0,$A(a0)
	eori.w	#1,d0
	add.w	d0,$C(a0)
.rr0
	move.w	#5,8(a0)	;gsper: final
	rts
.sv	;93 .sv. Save $5BE words from gmode to M68K_RAM (93 $37F), then ScoreSumbytes
	move.w	#$5BD,d0
	movea.w	#(gmode-M68K_RAM),a1
	movea.l	#M68K_RAM,a2
.sv1
	move.w	(a1)+,(a2)+
	dbf	d0,.sv1
	move.w	(ScoreSumbytes).w,(a2)+
	rts
.lo	;93 .lo. Restore what .sv saved
	move.w	#$5BD,d0
	movea.w	#(gmode-M68K_RAM),a2
	movea.l	#M68K_RAM,a1
.lo1
	move.w	(a1)+,(a2)+
	dbf	d0,.lo1
	move.w	(a1)+,(ScoreSumbytes).w
	rts
.postab	;Xpos,Ypos by position (goalie, l.def, r.def, l.wing, center, r.wing), pfgoal set, then clear (93 .postab)
	dc.w	0,-240,-70,-140,20,-110,-100,-60,25,-40,70,-80
	dc.w	0,240,34,90,-55,80,100,40,-10,10,-50,0
