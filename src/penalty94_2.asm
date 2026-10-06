;	NHL 94 (retail) segment $12C04-$138AB
;	92 Penalty.Asm part 2, as 93 penalty93_2.asm: PrintScores1, PrintTeamNameAndScore, PrintTeamLogoAndScore, EASNLogo,
;	USBoard, pplpen, linebar, getlinee, AvgCline, ChkShotStat, loadTeamStruct, SetupTeamForIntermission, the 94-only
;	sub_13098, reenergizeteam, Intermission, InitScores, UpdateScores, SetScore, getscore, sctab, NewTicker, NewTicker2,
;	NewTicker3, NewTicker3pt2, GameLabels, ClearTickerArea, SetTickerAreaPosition, PrintStringFromList, Adda1Offset,
;	DoHiLights, StartHL, StartHL2. checkcoll (hockey94_03) follows at $138AC.
;	Transcribed from lst/nhl94.bin.lst lines 47136-48479. Global names are the IDA names, or the 93 name where IDA has an
;	auto name (IDA name in an ;IDA: comment). 94 IDA NewTicker3 is 93 CheckGameTickerStatus and NewTicker3pt2 is 93
;	NewTicker3; the IDA names are kept. The IDA sub_ routines that 93 writes as locals are locals here too (.dispen, .r, .tn,
;	.setteam, .ranres, .sv, .lo). Local labels are the IDA local names (_x -> .x) or the IDA address (loc_12C22 -> .12C22).
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
	;(.12CB0, 93 .sbscreen): period and both team logos with big scores. 94: the period name is gsp of unk_191E4, or name 4 of unk_191F8
	;when word_FFC2FA bit 1 is set; the horizontal rink uses unk_191F8 (name 4 when bit 0 is set). word_FFC2F6 bit 7 sets word_FFC304 = $78.
	;Called from USBoard, Pausemode, lcfound2 and others
	movem.l	d0-d2/a0-a3,-(sp)
	btst	#7,(sflags).w	;sfhor
	bne.w	.12CB0
	bclr	#7,(word_FFC2F6).w	;94 only
	beq.w	.12C22
	move.w	#$78,(word_FFC304).w
.12C22
	bsr.w	printz
	String	$BF,0,$17
	moveq	#9,d0
	moveq	#5,d1
	bsr.w	Framer
	bset	#3,(disflags).w	;dfclock
	bsr.w	printz
	String	$BF,1,$18
	move.w	(gsp).w,d0	;period name
	movea.l	#unk_191E4,a1	;93 PerLabels
	btst	#1,(word_FFC2FA).w	;94 only
	beq.w	.12C62
	move.w	#4,d0
	movea.l	#unk_191F8,a1
.12C62
	bsr.w	PrintStringFromList
	bsr.w	EASNLogo
	btst	#0,(sflags3).w	;sf3llcs: lower line change box is up
	bne.w	.12CAA
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
	adda.w	#$364,a2	;tmsize
	bsr.w	PrintTeamNameAndScore
.12CAA
	movem.l	(sp)+,d0-d2/a0-a3
	rts
.12CB0
	bsr.w	printz
	String	$BE,$11,2
	move.w	(gsp).w,d0	;IDA hid this in the string (ori.b / andi.b / and.w)
	btst	#0,(word_FFC2FA).w
	beq.w	.12CCC
	move.w	#4,d0
.12CCC
	movea.l	#unk_191F8,a1	;94: the horizontal rink always takes the name from unk_191F8
	bsr.w	Adda1Offset
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
	adda.w	#$364,a2	;tmsize. IDA hid this in the string (ori.b / andi.b / bchg)
	move.w	#$2C,d0	;visitor logo data offset (93 $30)
	bsr.w	PrintTeamLogoAndScore
	bra.s	.12CAA
PrintTeamNameAndScore	;IDA: sub_12D0E (93 name). Print the team name of team a2 at printx/printy, then its score as 2 digits at x $1C. Called twice from PrintScores1
	movea.l	$1E(a2),a1	;tmdata
	adda.w	4(a1),a1
	adda.w	(a1),a1	;skip the first string to the team name
	bsr.w	print
	move.w	#$1C,(printx).w
	move.w	$C(a2),d0	;tmscore
	moveq	#2,d1
	bsr.w	PushNumberWidth
	bra.w	print
PrintTeamLogoAndScore	;IDA: sub_12D30 (93 name). Draw the team logo map (sub_8078, 93 PrintTeamData, d0 = offset) 5 columns left of printx (93 6),
	;then the score of team a2 in big font, centered 2 rows lower; 94 moves a 2 digit score one more left. Called twice from PrintScores1
	move.w	(printx).w,-(sp)
	subq.w	#5,(printx).w
	jsr	(sub_8078).l	;93 PrintTeamData
	move.w	(sp)+,(printx).w
	addq.w	#2,(printy).w
	move.w	$C(a2),d0	;tmscore
	cmp.w	#$A,d0	;94 only
	bge.w	.12D56
	bra.w	.12D5A
.12D56
	subq.w	#1,(printx).w
.12D5A
	bsr.w	PushNumber
	move.w	(a1),d0	;center on the old printx
	subq.w	#2,d0
	lsr.w	#1,d0
	sub.w	d0,(printx).w
	addq.w	#1,(printx).w
	bra.w	printbig
EASNLogo	;IDA: sub_12D70 (93 name). Draw the EASN logo map at x 1, y $19 on the vertical ice rink if no power play. 94 has no DrawEASNMap entry. Called from PrintScores1 and updatepwrplay
	btst	#5,(sflags2).w	;sf2pwrplay
	bne.w	rtss2
	bsr.w	printz
	String	$BF,1,$19		;IDA: ori.b / move.b d0,-(a4)
	movea.l	#unk_B3530,a1	;93 EASNmap
	adda.l	4(a1),a1
	movea.w	#$30A,a2	;93 #$310
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2	;width and height from the map header
	move.w	2(a1),d3
	move.w	(word_FFB020).w,d4	;93 EASNcset
	clr.w	d5
	bra.w	dobitmap
USBoard	;IDA: sub_12DA6 (93 name). Update score board, including the players in the penalty box and their time remaining. Called from InProgress and SetHor
	movem.l	d0-d7/a0-a3,-(sp)
	bset	#3,(disflags).w	;dfclock
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
.dispen	;IDA: sub_12DDE (93 .dispen, IDA USBoard_dispen). Penalty box list of team a2: the players without a coincidental penalty first, then those with one
	lea	$9A(a2),a0
.12DE2
	clr.w	d0
	move.b	(a0)+,d0
	bmi.w	.12DF8	;end of list
	btst	#6,$66(a2,d0.w)	;coincidental (tmpdst high byte bit 6)
	bne.s	.12DE2
	bsr.w	pplpen
	bra.s	.12DE2
.12DF8
	lea	$9A(a2),a0
.12DFC
	clr.w	d0
	move.b	(a0)+,d0
	bmi.w	rtss2
	btst	#6,$66(a2,d0.w)
	beq.s	.12DFC
	bsr.w	pplpen
	bra.s	.12DFC
pplpen	;IDA: sub_12E12 (93 IDA pplpen?). Print one penalty box line: player number and time remaining. a2 = team, d0 = roster offset (player*2). Only
	;rows up to y $A are printed; printy += 1. Called from USBoard .dispen
	cmpi.w	#$A,(printy).w
	bhi.w	rtss2	;no room for more rows
	move.w	$66(a2,d0.w),d2
	andi.w	#$7FF,d2	;penalty time
	movea.l	$1E(a2),a1	;tmdata
	adda.w	(a1),a1
	lsr.w	#1,d0
.12E2C
	adda.w	(a1),a1	;IDA: loc_12E2C. skip d0+1 roster entries (name string + 8 bytes)
	addq.w	#8,a1
	dbf	d0,.12E2C
	clr.w	d0
	move.b	-8(a1),d0	;player number (BCD)
	move.w	(printx).w,-(sp)
	movea.w	#(word_FFBFA6-M68K_RAM),a1	;93 TextBuffer (mesarea+2)
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
linebar	;IDA: sub_12E66 (93 name). Draw the energy bar of line d0 for team a2 at printx/printy (bitmap from the bar map, 16 steps). Called from SetLCmode2
	movem.l	d0-d5/a0-a2,-(sp)
	bsr.w	getlinee
	move.w	(printa).w,-(sp)
	move.w	#$8000,(printa).w
	ext.l	d0
	divu.w	#$100,d0	;4096/16
	cmp.w	#$F,d0
	bls.w	.12E88
	moveq	#$F,d0
.12E88
	moveq	#$F,d1	;IDA: loc_12E88. d1 = bar frame (15 = empty)
	sub.w	d0,d1
	clr.w	d0
	movea.l	#unk_AB920,a1	;93 EnergyBarMap
	adda.l	4(a1),a1
	movea.w	#$30A,a2	;93 #$310
	move.w	(a1),d2
	moveq	#1,d3
	move.w	(word_FFB016).w,d4
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
	move.w	$24(a2),d4	;tmap
	bra.w	.12EEA
.12ED2
	clr.w	d5
	move.b	0(a0,d4.w),d5	;position
	beq.w	.12EEA	;goalie energy doesn't count
	clr.w	d3
	move.b	0(a1,d5.w),d3	;player number
	asl.w	#1,d3
	addq.w	#1,d1
	add.w	$30(a2,d3.w),d0	;tmpde-2
.12EEA
	dbf	d4,.12ED2
	divu.w	d1,d0
	movem.l	(sp)+,d1-d5/a0-a3
	rts
AvgCline	;IDA: sub_12EF6 (93 name). Return d0 = average energy of current line on team a2
	movem.l	d1-d3/a0,-(sp)
	clr.l	d0
	clr.w	d1
	moveq	#5,d2
	movea.w	$22(a2),a0	;tmsort
.12F04
	tst.w	$34(a0)	;position
	ble.w	.12F1A
	clr.w	d3
	move.b	$66(a0),d3	;pnum
	add.w	d3,d3
	add.w	$32(a2,d3.w),d0	;tmpde
	addq.w	#1,d1
.12F1A
	adda.w	#$80,a0
	dbf	d2,.12F04
	tst.w	d1
	beq.w	.12F2A
	divu.w	d1,d0
.12F2A
	movem.l	(sp)+,d1-d3/a0
	rts
ChkShotStat	;determine if shot taken, add to appropriate stats. As 93: crowd, team, shooter and goalie shots against. 94 adds: nothing while the
	;clock is stopped or in a highlight, PP shots ($354) and period shots ($34A), and a second path (word_FFC2F4 bit 0, byte_FFC2FE bit 3 every
	;second call) that counts the shot for the player in the last ScoreSum entry
	btst	#0,(gmode).w	;gmclock: clock stopped
	bne.w	rtss2	;exit if so
	btst	#4,(gmode).w	;gmhl: highlight
	bne.w	rtss2	;exit if so
	bclr	#4,(sflags2).w	;sf2shot: shot taken
	bne.w	.Cwdupdate	;it was set
	btst	#0,(word_FFC2F4).w	;94 only
	beq.w	rtss2	;exit if cleared
	bclr	#3,(byte_FFC2FE).w
	bne.w	.12F6C
	bset	#3,(byte_FFC2FE).w
	bra.w	rtss2
.12F6C
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
	beq.w	.1300C
	btst	#6,(sflags2).w	;sf2pwrtm: 0 home, 1 visitors
	bne.w	.13004
	btst	#6,$62(a3)	;pfteam
	bne.w	.1300C	;not the team on the power play
.PPshot
	addq.w	#1,$354(a2)	;power play shots
	bra.w	.1300C
.13004
	btst	#6,$62(a3)	;pfteam
	bne.s	.PPshot
.1300C
	move.l	a2,-(sp)
	move.w	(gsp).w,d0	;period
	add.w	d0,d0
	adda.w	d0,a2
	addq.w	#1,$34A(a2)	;shots by period
	movea.l	(sp)+,a2
	clr.w	d0
	move.b	$66(a3),d0	;pnum
	addi.w	#$E8,d0
	addq.b	#1,0(a2,d0.w)	;shooter's shot count
	move.w	$26(a1),d0	;other team's tmgoalie
	bmi.w	.ex	;empty net
	addi.w	#$E8,d0
	addq.b	#1,0(a1,d0.w)	;goalie's shots against
.ex
	movem.l	(sp)+,d0-d1/a1-a3
	rts
loadTeamStruct	;return a2 = team struct of player a3, a1 = the other team's struct. Called from ChkShotStat and updateplayers
	movea.w	#(HmShots-M68K_RAM),a2
	lea	$364(a2),a1	;tmsize
	btst	#6,$62(a3)	;pfteam
	beq.w	rtss2
	exg	a1,a2
	rts
SetupTeamForIntermission	;IDA: sub_13056 (93 name). Reset the bench, then for each team refill energy and pick the starting line: 92 Pw1 (3)
	;for the team with more players on ice, PK1 (5) for the team with fewer, else 0. Called from Intermission
	bsr.w	ResetBench
	movea.w	#(HmShots-M68K_RAM),a2
	lea	$364(a2),a3
	bsr.w	.r
	exg	a2,a3	;falls in for the other team
.r	;IDA: sub_13068 (93 .r)
	bsr.w	reenergizeteam
	clr.w	$16(a3)	;tmline
	tst.w	(OptLine).w
	bne.w	rtss2	;line changes off
	move.w	$24(a3),d0
	sub.w	$24(a2),d0
	beq.w	rtss2
	move.w	#3,$16(a3)	;Pw1
	tst.w	d0
	bpl.w	rtss2
	move.w	#5,$16(a3)	;PK1
	rts
sub_13098	;94 only. a2 = team: max energy (tmpde $1000) for every player. The skip needs tmpdst to be both -3 and -4, so it never happens.
	;Called from $9DD0 / $9DDA (the menu code before ReplayMode)
	moveq	#$32,d0	;(MaxRos-1)*2
.1309A
	cmpi.w	#$FFFD,$66(a2,d0.w)
	bne.w	.130B2
	cmpi.w	#$FFFC,$66(a2,d0.w)
	bne.w	.130B2
	bra.w	.130B8
.130B2
	move.w	#$1000,$32(a2,d0.w)	;tmpde
.130B8
	subq.w	#2,d0
	bpl.s	.1309A
	rts
reenergizeteam	;IDA: sub_130BE (93 name). Set all players to max energy on team a2 except those at tmpdst -4 (94); players marked -3 in tmpdst go to
	;the bench (-2). Called from SetupTeamForIntermission and StartHL2 .setteam
	moveq	#$32,d0	;(MaxRos-1)*2
.130C0
	cmpi.w	#$FFFC,$66(a2,d0.w)	;94 only
	beq.w	.130E0
	move.w	#$1000,$32(a2,d0.w)	;tmpde
	cmpi.w	#$FFFD,$66(a2,d0.w)
	bne.w	.130E0
	move.w	#$FFFE,$66(a2,d0.w)	;on bench
.130E0
	subq.w	#2,d0
	bpl.s	.130C0
	rts
Intermission	;end of period junk (zamboni/stats). As 93: opens the pause menu screen (item list by period, +5 in playoffs), shows the ticker scores
	;of the other games, then the highlights; Start on either pad cuts it short. 94: when gsp is 4 the clock is cleared and sub_F9CDE runs first,
	;and word_FFC2FA bit 0 picks the unk_19A00 item list. Called from PeriodOver
	cmpi.w	#4,(gsp).w
	bne.w	.130FC
	move.w	#0,(gameclock).w
	jsr	(sub_F9CDE).l	;94 only
.130FC
	bsr.w	SetupTeamForIntermission
	moveq	#$F,d0
	movea.w	#(SortCords-M68K_RAM),a0
.13106
	clr.w	(a0)	;Xpos
	adda.w	#$80,a0	;SCstruct
	dbf	d0,.13106
	move.w	(ExtraChars).w,d4
	movea.l	#unk_A892A,a2	;93 ZamSprites+8
	bsr.w	DoDMA_clearCallbackPointer
	move.w	#$140,(zamx).w	;320
	move.w	(gsp).w,d0
	tst.w	(OptPlayMode).w
	beq.w	.13132
	addq.w	#5,d0	;playoffs
.13132
	asl.w	#2,d0
	lea	.sslist(pc),a0
	movea.l	0(a0,d0.w),a0
	btst	#0,(word_FFC2FA).w	;94 only
	beq.w	.1314C
	movea.l	#unk_19A00,a0
.1314C
	bset	#0,(sflags).w	;sfpz
	movea.l	#SetupPauseScreen,a1
	jsr	(sub_7E36).w	;93 InitMenuState
	bsr.w	GetShifter
	move.w	d1,(TickerNum).w
.13164
	tst.w	(TickerNum).w
	bmi.w	.1319C	;no more ticker games
	bsr.w	NewTicker2
	bsr.w	NewTicker3pt2	;93 NewTicker3
	move.w	#$96,d0	;150 frames
	bsr.w	waitxsr	;93 IntermissionLoop
	btst	#7,d1	;sbut
	bne.w	.13196
	bsr.w	ClearTickerArea
	move.w	#$3C,d0	;60 frames
	bsr.w	waitxsr
	btst	#7,d1
	beq.s	.13164
.13196
	bset	#3,(sflags3).w	;sf3sbut
.1319C
	bsr.w	DoHiLights
	bclr	#3,(sflags3).w
	bne.w	.131C6
.131AA
	move.w	#$1E0,d0	;480 frames
	bsr.w	waitxsr
	btst	#7,d1
	bne.w	.131C6
	tst.w	(cont1team).w
	bne.s	.131AA	;keep waiting while a pad is on a team
	tst.w	(cont2team).w
	bne.s	.131AA
.131C6
	st	(zamx).w
	rts
.sslist	;IDA: unk_131CC (93 .sslist). Menu item lists by period, then playoff period. The targets have no IDA labels
	dc.l	unk_19A84,unk_19C04,unk_19C04,unk_19C04,unk_19D60
	dc.l	unk_19B38,unk_19C04,unk_19C04,unk_19C04,unk_19E74
InitScores	;initialize other games scores/period in playoffs. Called from StartGame
	cmpi.w	#1,(gamelevel).w
	bgt.w	rtss2
	bsr.w	GetShifter
	movea.w	#(gsstruct-M68K_RAM),a0
	moveq	#$10,d0	;gssize
	mulu.w	d1,d0
	adda.w	d0,a0
.1320C
	cmp.w	(gamenum).w,d1
	beq.w	.13234
	btst	#2,$E(a0)	;gsfso
	bne.w	.13234
	clr.w	8(a0)	;gsper
	moveq	#3,d0
	bsr.w	randomd0
	bra.w	.13230
.1322C
	bsr.w	SetScore
.13230
	dbf	d0,.1322C
.13234
	suba.w	#$10,a0	;gssize
	dbf	d1,.1320C
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
	bsr.w	getscore
	add.w	d0,$A(a0)	;gss1
	move.w	2(a0),d0
	move.w	(a0),d1
	bsr.w	getscore
	add.w	d0,$C(a0)	;gss2
.ex
	movem.l	(sp)+,d0-d1/a0-a1
	rts
getscore	;IDA name (93 SetScore .getscore). d0 = scoring team, d1 = other team. Adds the scoring team's (bits 4-6) and the other team's (bits 0-2) sctab rows as weights. Return d0 = goals 0-3
	asl.w	#2,d0
	movea.w	#$30E,a1	;TeamList (93 $314)
	movea.l	0(a1,d0.w),a1
	adda.w	8(a1),a1	;92 ScoreOdds
	move.b	(a1),d0
	andi.w	#$70,d0
	lsr.w	#1,d0	;row * 8
	lea	sctab(pc),a1
	move.l	0(a1,d0.w),(dword_FFD036).w	;93 dword_FFCACA
	move.l	4(a1,d0.w),(dword_FFD03A).w	;93 dword_FFCACE
	asl.w	#2,d1
	movea.w	#$30E,a1	;TeamList
	movea.l	0(a1,d1.w),a1
	adda.w	8(a1),a1
	move.b	(a1),d0
	andi.w	#7,d0
	asl.w	#3,d0
	lea	sctab(pc),a1
	move.l	0(a1,d0.w),d1
	add.l	d1,(dword_FFD036).w
	move.l	4(a1,d0.w),d1
	add.l	d1,(dword_FFD03A).w
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
	bne.w	.13408
	clr.w	d0	;not playoffs: 'EA Hockey Night'
.13408
	lea	GameLabels(pc),a1
	bsr.w	PrintStringFromList
	move.w	8(a0),d0	;gsper
	subq.w	#1,d0
	movea.l	#unk_191E4,a1	;93 PerLabels
	bsr.w	Adda1Offset
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
.tn	;IDA: sub_13454 (93 .tn, IDA NewTicker3_tn). Print team d0 name and score d1 on the next row
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
GameLabels	;IDA: unk_13488 (93 name). Ticker titles, by OptPlayMode and gamelevel
	String	'EA Hockey Night'
	String	'Stanley Cup Qualifier'
	String	'Quarterfinal'
	String	'Stanley Cup Semifinal'
ClearTickerArea	;IDA: sub_134D8 (93 name). Erase the ticker box. Called from Intermission and StartHL2
	bsr.w	SetTickerAreaPosition
	move.w	#$7FF,d2	;blank char
	bra.w	eraser
SetTickerAreaPosition	;IDA: sub_134E4 (93 name). Set printx/printy/printm for the ticker box (x 3, y $17; the $BD map in pause mode). Return d0 =
	;$1A wide, d1 = 5 high. Called from NewTicker3pt2 and ClearTickerArea
	bsr.w	printz
	String	$BD,3,$17		;IDA: ori.b / move.b d0,-(a3)
	btst	#0,(sflags).w	;sfpz
	bne.w	.13502
	bsr.w	printz
	String	$BF,3,$17		;IDA: ori.b / move.b d0,-(a3)
.13502
	moveq	#$1A,d0
	moveq	#5,d1
	rts
PrintStringFromList	;IDA: sub_13508 (93 name). Print string d0 of the String list a1 with print2 (93 printsmall)
	bsr.w	Adda1Offset
	bra.w	print2
Adda1Offset	;IDA name (93 AdvanceStringPtr). Return a1 = string d0 of the String list a1 (92 Fprint without the print)
	bra.w	.13516
.13514
	adda.w	(a1),a1
.13516
	dbf	d0,.13514
	rts
DoHiLights	;IDA: sub_1351C (93 name). Hilites logic: search for hilite game and show hilite. Called from Intermission
	bsr.w	GetShifter
	moveq	#$10,d3	;gssize
	mulu.w	d1,d3
	movea.w	#(gsstruct-M68K_RAM),a0
	adda.w	d3,a0
.1352A
	btst	#2,$E(a0)	;gsfso
	bne.w	.13542
	bclr	#1,$E(a0)	;gsfhl
	beq.w	.13542
	bsr.w	StartHL
.13542
	suba.w	#$10,a0	;gssize
	dbf	d1,.1352A
	rts
StartHL	;IDA: sub_1354C (93 name). Play hilite for game a0, d1 = game. Called from DoHiLights. Falls into StartHL2
	movem.l	d0-d7/a0-a6,-(sp)
StartHL2	;IDA: loc_13550 (93 name). Play hilite for game a0. Start skips it with a random result. A tied game is replayed (beq StartHL2). 94:
	;song $79 (93 $36), sub_16BAC (93 setupice_highlight), SetTeamColors (93 setplayercolors)
	btst	#3,(sflags3).w	;sf3sbut
	bne.w	.137F6
	bsr.w	.sv
	move.w	d1,d3
	bsr.w	NewTicker3
	bsr.w	NewTicker3pt2	;show score from hilight game
	btst	#3,(sflags3).w
	bne.w	.137EC
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
	bsr.w	waitxsr	;93 IntermissionLoop
	btst	#7,d1	;sbut
	bne.w	.137EC
	st	(zamx).w
	clr.w	(CwdExciteLvl).w
	move.w	(a0),(HomeTeam).w	;set up teams for game in a0
	move.w	2(a0),(VisTeam).w
	move.l	a0,-(sp)
	clr.w	(word_FFC6F4).w	;93 word_FFC50C
	clr.w	(word_FFCA58).w	;93 word_FFC6AE
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
	beq.w	.13628
	bset	#1,(gmode).w	;gmdir
.13628
	clr.b	(sflags).w
	move.b	#4,(sflags2).w	;1<<sf2drec
	clr.b	(sflags3).w
	bclr	#4,(disflags).w
	bset	#3,(disflags).w	;dfclock
	clr.w	(glovecords).w
	clr.b	(iflags).w
	st	(RefCnt).w
	st	(puckcross2).w
	st	(puckcross6).w
	jsr	(AllSndOff).l	;93 p_turnoff
	bsr.w	sub_16BAC	;93 setupice_highlight
	bsr.w	ClrHor
	movea.l	#VDP_DATA,a0
	move.w	#$9100,4(a0)	;window H position 0
	move.w	#$9200,4(a0)	;window V position 0
	move.w	(ExtraChars).w,d4	;ref cam chars
	movea.l	#unk_5C410,a2	;93 RefsMap+8
	bsr.w	DoDMA_clearCallbackPointer
	clr.w	(Vpos).w
	clr.w	(Hpos).w
	bsr.w	ResetBench
	movea.w	#(HmShots-M68K_RAM),a2
	bsr.w	.setteam
	adda.w	#$364,a2	;tmsize
	bsr.w	.setteam
	bsr.w	resetplstuff
	moveq	#$B,d0
	movea.l	#.postab,a0
	movea.w	#(SortCords-M68K_RAM),a1
.136B0
	move.w	$34(a1),d1	;IDA: loc_136B0. position
	btst	#7,$62(a1)	;pfgoal
	bne.w	.136C0
	addq.w	#6,d1
.136C0
	asl.w	#2,d1
	move.w	0(a0,d1.w),(a1)	;Xpos
	move.w	2(a0,d1.w),$14(a1)	;Ypos
	clr.w	$28(a1)	;Xvel
	clr.w	$2A(a1)	;Yvel
	adda.w	#$80,a1
	dbf	d0,.136B0
	bsr.w	SprSort
	move.w	#$18,(palcount).w
	move.w	(vcount).w,(oldvcount).w
	move.w	#$B4,-(sp)	;180 frames after the clock stops
.136F0
	jsr	(DoGameFrame).w
	btst	#0,(gmode).w	;gmclock
	beq.w	.13704
	subq.w	#1,(sp)
	bmi.w	.13738
.13704
	bsr.w	orjoy
	btst	#5,d1	;cbut
	bne.w	.13716
	btst	#7,d1	;sbut
	beq.s	.136F0
.13716
	move.w	(HmGoals).w,d0	;IDA: loc_13716. tied: random winner
	cmp.w	(AwGoals).w,d0
	bne.w	.13738
	move.w	(VDP_CNTR).l,d0	;hvcount
	andi.w	#1,d0
	add.w	d0,(HmGoals).w
	eori.w	#1,d0
	add.w	d0,(AwGoals).w
.13738
	addq.w	#2,sp
	movea.l	(sp)+,a0
	movem.l	d1/a0,-(sp)
	jsr	(KillCrowd).l
	jsr	(AllSndOff).l
	movem.l	(sp)+,d1/a0
	move.w	(HmGoals).w,$A(a0)	;gss1
	move.w	(AwGoals).w,$C(a0)	;gss2
	bsr.w	forceblack
	moveq	#$F,d0
	movea.w	#(SortCords-M68K_RAM),a0
.13766
	clr.w	(a0)
	adda.w	#$80,a0
	dbf	d0,.13766
	bsr.w	.lo
	bsr.w	SetTeamColors	;93 setplayercolors
	bsr.w	SetHor
	bsr.w	setvideo
	jsr	(SetupPauseScreen).w	;pause menu screen
	jsr	(sub_7E46).w	;93 DrawMenuScreen
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
	bsr.w	waitxsr
	btst	#7,d1
	bne.w	.137E0
	bsr.w	ClearTickerArea
	move.w	#$3C,d0
	bsr.w	waitxsr
	btst	#7,d1
	beq.w	.137E6
.137E0
	bset	#3,(sflags3).w	;IDA: loc_137E0 (93 .exit2). sf3sbut
.137E6
	movem.l	(sp)+,d0-d7/a0-a6	;IDA: loc_137E6 (93 .exit)
	rts
.137EC
	bsr.w	.lo	;IDA: loc_137EC (93 .nhl1)
	bsr.w	.ranres
	bra.s	.137E0
.137F6
	bsr.w	.ranres	;IDA: loc_137F6 (93 .nhl0)
	bra.s	.137E6
.setteam	;IDA: sub_137FC (93 .setteam, IDA SetupTeamForReplay). Refill energy, set personnel; 94 also clears byte_FFC2FE bit 7
	jsr	(reenergizeteam).l
	bsr.w	SetPersonel
	bsr.w	forcepldata
	st	$18(a2)
	bclr	#7,(byte_FFC2FE).w
	st	$1A(a2)
	st	$1C(a2)
	rts
.ranres	;IDA: sub_1381E (93 .ranres). Random resolve of game (if tied = random score)
	move.w	$A(a0),d0
	cmp.w	$C(a0),d0
	bne.w	.13840
	move.w	(VDP_CNTR).l,d0	;hvcount
	andi.w	#1,d0
	add.w	d0,$A(a0)
	eori.w	#1,d0
	add.w	d0,$C(a0)
.13840
	move.w	#5,8(a0)	;gsper: final
	rts
.sv	;IDA: sub_13848 (93 .sv). Save $5BE words from gmode to M68K_RAM (93 $37F), then ScoreSumbytes
	move.w	#$5BD,d0
	movea.w	#(gmode-M68K_RAM),a1
	movea.l	#M68K_RAM,a2
.13856
	move.w	(a1)+,(a2)+
	dbf	d0,.13856
	move.w	(ScoreSumbytes).w,(a2)+
	rts
.lo	;IDA: sub_13862 (93 .lo). Restore what .sv saved
	move.w	#$5BD,d0
	movea.w	#(gmode-M68K_RAM),a2
	movea.l	#M68K_RAM,a1
.13870
	move.w	(a1)+,(a2)+
	dbf	d0,.13870
	move.w	(a1)+,(ScoreSumbytes).w
	rts
.postab	;IDA: unk_1387C. Xpos,Ypos by position (goalie, l.def, r.def, l.wing, center, r.wing), pfgoal set, then clear (93 .postab)
	dc.w	0,-240,-70,-140,20,-110,-100,-60,25,-40,70,-80
	dc.w	0,240,34,90,-55,80,100,40,-10,10,-50,0
