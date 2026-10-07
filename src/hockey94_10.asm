;	NHL 94 (retail) segment $18380-$18CFB
;	92 hockey.asm ResolveGames and the 92 exception handlers, as 93 hockey93_10: ResolveGames, the end of game Stars of the Game box
;	(DisplayPeriodOver, FindMaxAttributeTEam, CalculateTeamAttributes / Values), the injury box (ShowInjuryBox), the 94-only penalty
;	shot box (PenaltyShotBox), the goal box (DisplayPlayerAttributeMenu), box, the player name formatters (GetTempPlayerName, getname ...
;	FinalizeTextBuffer, getplayername, d0toascii) and AddError, Illinst, ZeroDiv and crash. cd0 (hockey94_11) follows at $18CFC.
;	Transcribed from lst/nhl94.bin.lst lines 55538-56542. Global names are the IDA names, or the 93 name where IDA has an auto name
;	(IDA name, unless generic, in an ;IDA: comment); the exception handlers have the main94 vector names. Locals are the IDA local names (_x -> .x)
;	or the 93 local where the code matches, else in the 93 style (.x exit, .loop, numbered), with the IDA label, unless generic, in an ;IDA: comment; crash's helper is the 93 local .ri.
;	IDA gaps written from the retail bytes: the printz / printbigz / appendz strings that IDA shows as code or dc.b, the instructions
;	IDA hid in them (moveq #$1B,d0, moveq #$13,d0, move.w (BA_Checker_Offset).w,d0, two move.w d0,-(sp), the exception handlers'
;	move.l $A(sp),d0 / 2(sp),d0), and the printbig String tables.
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp / cmpi;
;	fixopcodes.js patches the cmp encoding after assembly.
;	gsstruct game ($10 bytes, 93 gstruct): 0 gst1, 2 gst2, 4 gspotwins, 6 gspobwins, 8 gsper, $A gss1, $C gss2, $E gsflags.
;	Team struct: $C goals, $28 team, $B4 / $CE / $E8 goals / assists / shots bytes per roster slot, $136 frames on ice; tmsize $364.

ResolveGames	;93 name. Compute winners and losers for playoff matchups (92 ResolveGames). Called from EncodePW (hockey94_09)
	move.w	(gamenum).w,d0
	mulu.w	#gssize,d0
	movea.w	#(gsstruct-M68K_RAM),a0
	move.w	(HmGoals).w,gss1(a0,d0.w)	;copy score from played game into game structures (gss1, gss2)
	move.w	(AwGoals).w,gss2(a0,d0.w)
	bsr.w	GetShifter
	movea.w	#(gsstruct-M68K_RAM),a0
	moveq	#gssize,d3
	mulu.w	d1,d3
	adda.w	d3,a0
	cmpi.w	#7,(bosgames).w
	beq.w	.notbos	;not best of 7
.loop
	cmpi.w	#4,gspotwins(a0)	;series complete? (gspotwins)
	beq.w	.b1
	cmpi.w	#4,gspobwins(a0)
	beq.w	.b1
	clr.w	d3
	btst	#0,gsflags(a0)	;teams flipped (92 gsftf)
	beq.w	.0
	eori.w	#gspobwins-gspotwins,d3
.0
	move.w	gss1(a0),d0
	sub.w	gss2(a0),d0
	bpl.w	.1
	eori.w	#gspobwins-gspotwins,d3
.1
	addq.w	#1,gspotwins(a0,d3.w)	;one more win
.b1
	suba.w	#gssize,a0
	dbf	d1,.loop
	addq.w	#1,(bosgames).w
	cmpi.w	#7,(bosgames).w
	beq.w	.nextround
	move.w	(gamenum).w,d0
	mulu.w	#gssize,d0
	movea.w	#(gsstruct-M68K_RAM),a0
	adda.w	d0,a0
	cmpi.w	#4,gspotwins(a0)
	beq.w	.cround
	cmpi.w	#4,gspobwins(a0)
	bne.w	rtss2
.cround
	cmpi.w	#3,(gamelevel).w	;finish off rest of round games here
	bge.w	.nextround
	bsr.w	GetShifter
	movea.w	#(gsstruct-M68K_RAM),a0
	moveq	#gssize,d3
	mulu.w	d1,d3
	adda.w	d3,a0
.cr0
	cmp.w	(gamenum).w,d1
	beq.w	.crn
	cmpi.w	#4,gspotwins(a0)
	beq.w	.crn
	cmpi.w	#4,gspobwins(a0)
	beq.w	.crn
	addq.w	#1,gspotwins(a0)
	move.l	#$C8,d0	;200
	jsr	(randomd0).l
	andi.w	#1,d0
	beq.s	.cr0
	subq.w	#1,gspotwins(a0)
	addq.w	#1,gspobwins(a0)
	bra.s	.cr0
.crn
	suba.w	#gssize,a0
	dbf	d1,.cr0
	movea.w	#(tpassbits-M68K_RAM),a3	;bits before advancing to next round (93 tpassbits)
	bsr.w	WritePassBits
	bset	#sf3alttree,(sflags3).w	;93 sf3alttree
.nextround
	clr.w	(bosgames).w	;advance to next round
	bsr.w	GetShifter
	movea.w	#(gsstruct-M68K_RAM),a0
	moveq	#gssize,d3
	mulu.w	d1,d3
	adda.w	d3,a0
	clr.w	d3
.loop2
	cmpi.w	#4,gspotwins(a0)
	beq.w	.2
	bset	d1,d3
.2
	clr.w	gspotwins(a0)
	clr.w	gspobwins(a0)
	suba.w	#gssize,a0
	dbf	d1,.loop2
	moveq	#1,d1
	asl.w	d2,d1
	subq.w	#1,d1
	and.w	d1,(WinBits).w	;clear this round's winbits (93 WinBits)
	asl.w	d2,d3
	or.w	d3,(WinBits).w
	addq.w	#1,(gamelevel).w
	rts
.notbos
	clr.w	d3	;solve for no best of 7 playoffs (much simpler)
.loop3
	move.w	gss1(a0),d0
	cmp.w	gss2(a0),d0
	bhi.w	.3
	bset	d1,d3
.3
	btst	#0,gsflags(a0)
	beq.w	.nb2
	bchg	d1,d3
.nb2
	suba.w	#gssize,a0
	dbf	d1,.loop3
	moveq	#1,d1
	asl.w	d2,d1
	subq.w	#1,d1
	and.w	d1,(WinBits).w
	asl.w	d2,d3
	or.w	d3,(WinBits).w
	addq.w	#1,(gamelevel).w
	rts
DisplayPeriodOver	;93 name. End of game Stars of the Game box. Called from UpdatePA (penalty94_1) while RefPen is the game over
	;penalty. Waits for RefCnt <= $40 and runs once (gmode bit 7); 94 then sets disflags bit 3 and waits a vblank. Frames the box, draws a bitmap
	;from Rinktilelist (93 IceRinkMap), then the three best star scores (FindMaxAttributeTEam): team abbreviation and getname. Song $F when the
	;home team won
	cmpi.w	#$40,(RefCnt).w
	bgt.w	rtss2	;ref animation not far enough yet
	bset	#7,(gmode).w
	bne.w	rtss2	;already shown
	movem.l	d0/a1,-(sp)
	bset	#3,(disflags).w
	move.w	(vcount).w,d0
.loop2
	cmp.w	(vcount).w,d0
	beq.s	.loop2
	movem.l	(sp)+,d0/a1
	movem.l	d0-d5/a0-a4,-(sp)
	bsr.w	printz
	String	$BF,2,$E	;IDA: ori.b (and dropped a word)
	moveq	#$1C,d0	;framer size
	moveq	#9,d1
	bsr.w	Framer
	bsr.w	printz
	String	$BF,9,$10,'Stars of the Game',$BF,3,$F	;IDA: code
	movea.l	#Rinktilelist,a1	;IDA hid this in the string. map at offset 4
	movea.w	#$30A,a2	;a zero long (93 #$310)
	adda.l	4(a1),a1
	moveq	#$D,d0
	moveq	#$5B,d1
	moveq	#6,d2
	moveq	#4,d3
.0
	move.w	(rinkvrcset).w,d4
	clr.w	d5
	bsr.w	dobitmap
	bsr.w	CalculateTeamAttributes
	move.w	#$12,(printy).w
	moveq	#2,d2	;3 stars
.loop
	bsr.w	FindMaxAttributeTEam	;a2 = team, d0 = player
	move.w	#$1A,(printx).w
	addq.w	#1,(printy).w
	movea.l	tmdata(a2),a1
	adda.w	4(a1),a1
	adda.w	(a1),a1
	bsr.w	print
	bsr.w	getname	;a1 = number and name of player d0
	move.w	#3,(printx).w
	bsr.w	print
	dbf	d2,.loop
	move.w	(HmGoals).w,d0
.1
	sub.w	(AwGoals).w,d0
	ble.w	.nosong
	move.w	#$F,-(sp)	;song $F: home team won
	jsr	(song).l
.nosong
	movem.l	(sp)+,d0-d5/a0-a4
	rts
FindMaxAttributeTEam	;93 name. Take the highest of the 52 star scores at ThreeStars (93 DispAttribCtr; 26 per team, home first)
	;and clear it. Returns d0 = player slot, a2 = its team struct. Called from DisplayPeriodOver
	movem.l	d1-d2/a1/a4,-(sp)
	movea.w	#(ThreeStars-M68K_RAM),a4
	clr.l	d0
	moveq	#$33,d2
.find
	cmp.l	(a4)+,d0
	bge.w	.next	;not higher
	lea	-4(a4),a1
	move.l	(a1),d0
.next
	dbf	d2,.find
	clr.l	(a1)
	move.w	a1,d0
	subi.w	#(ThreeStars-M68K_RAM),d0
	lsr.w	#2,d0	;entry number
	movea.w	#(HmShots-M68K_RAM),a2
	cmp.w	#$1A,d0
	blt.w	.home
	subi.w	#$1A,d0
	adda.w	#tmsize,a2	;26-51: away team (tmsize)
.home
	movem.l	(sp)+,d1-d2/a1/a4
	rts
CalculateTeamAttributes	;93 name. Star score for every roster slot of both teams to ThreeStars (26 longs per team, home first). d5 =
	;GetPeriodTime + d2, the goalie ice time needed. If gsp is 3 and the score is not tied, the scorer of the last goal gets $7FFFFFFF. Called
	;from DisplayPeriodOver
	movea.w	#(ThreeStars-M68K_RAM),a4
	jsr	(GetPeriodTime).w	;IDA: ClockLength
	move.w	d0,d5
	add.w	d2,d5
	movea.w	#(HmShots-M68K_RAM),a2
	lea	tmsize(a2),a3
	bsr.w	CalculateTeamAttributeValues	;home
	movea.w	a3,a2
	lea	-tmsize(a2),a3
	bsr.w	CalculateTeamAttributeValues	;away (d3 = away - home score)
	cmpi.w	#3,(gsp).w
	bne.w	.x
	tst.w	d3
	beq.w	.x	;tied
	movea.w	#(ChkCnt-M68K_RAM),a0	;+ ScoreSumbytes = last goal entry
	adda.w	(ScoreSumbytes).w,a0
	clr.w	d0
	btst	#7,2(a0)
	beq.w	.slot
	addi.w	#$1A,d0	;away goal: second 26 entries
.slot
	add.b	3(a0),d0
	asl.w	#2,d0
	movea.w	#(ThreeStars-M68K_RAM),a0
	move.l	#$7FFFFFFF,0(a0,d0.w)	;game winner is the first star
.x
	rts
CalculateTeamAttributeValues	;93 name. Star scores of team a2 (a3 = other team) to (a4)+, one long per roster slot (26). Each
	;starts at the goal difference. Skaters: goals*11000 + assists*10100 + shots*10, or in a tied game shots*1000 + frames on ice. Goalies on ice
	;at least d5 with shots against: +32000 if goals against*100/shots <= 4, +75000 more for a shutout. Called from CalculateTeamAttributes
	movea.w	a2,a1
	move.w	tmscore(a2),d3
	sub.w	tmscore(a3),d3	;goal difference (HmGoals / AwGoals)
	ext.l	d3
	moveq	#$19,d4	;26 slots
	jsr	(ReadAttributeNibble).l	;d0 = goalies on the team (93 ReadAttributeNibble)
	neg.w	d0
	add.w	d4,d0
.loop
	move.l	d3,(a4)
	cmp.w	d0,d4
	bhi.w	.goalie	;goalie slot
	clr.w	d1
	move.b	$B4(a2),d1
	mulu.w	#$2AF8,d1	;goals * 11000
	add.l	d1,(a4)
	clr.w	d1
	move.b	$CE(a2),d1
	mulu.w	#$2774,d1	;assists * 10100
	add.l	d1,(a4)
	clr.w	d1
	move.b	$E8(a2),d1
	mulu.w	#$A,d1
	tst.w	d3
	bne.w	.add	;not tied: shots * 10
	mulu.w	#$64,d1	;tied: shots * 1000
	add.l	d1,(a4)
	clr.l	d1
	add.w	$136(a1),d1	;+ frames on ice
.add
	add.l	d1,(a4)
	bra.w	.next
.goalie
	cmp.w	$136(a1),d5
	bhi.w	.next	;not on ice long enough
	clr.w	d1
	move.b	$B4(a2),d1
	mulu.w	#$64,d1
	clr.w	d2
	move.b	$E8(a2),d2
	beq.w	.next
	divu.w	d2,d1
	cmp.w	#4,d1
	bhi.w	.next
	addi.l	#$7D00,(a4)	;32000
	tst.w	d1
	bne.w	.next
	addi.l	#$124F8,(a4)	;75000 for a shutout
.next
	addq.w	#2,a1
	addq.w	#1,a2
	addq.w	#4,a4
	dbf	d4,.loop
	rts
ShowInjuryBox	;93 name. Injury box: 'Injury to:' player TempPlOffset (GetPlayerNameWithAttrib), 'Out for period', or 'Out for game'
	;when sflags7 bit 5 is set (94), and 'the game' over 'period' when puck_pflags2 bit 0 (93 pf2fight) is set. Jumped to from CheckInjury
	;(hockey94_01), so global
	movem.l	d0-d2/a0-a4,-(sp)
	bsr.w	printz
	String	$BF,$B,3	;IDA: ori.b / btst
	moveq	#$12,d0	;framer size
	moveq	#5,d1
	bsr.w	Framer
	btst	#5,(sflags7).w
	bne.w	.0
	bsr.w	printz
	String	$BF,$C,4,'Injury to:',$BF,$C,6,'Out for period',$BF,$C,5	;IDA: code
	bra.w	.1
.0
	bsr.w	printz
	String	$BF,$C,4,'Injury to:',$BF,$C,6,'Out for game',$BF,$C,5	;IDA: code
.1
	bsr.w	GetPlayerNameWithAttrib
	bsr.w	print
	btst	#pf2fight,(puck_pflags2).w
	beq.w	.ex
	bsr.w	printz
	String	$BF,$14,6,'the game'	;IDA: ori.b / addi.w / bsr.s
.ex
	movem.l	(sp)+,d0-d2/a0-a4	;IDA: bcs.w / move.b (IDA hid this in the string)
	rts
PenaltyShotBox	;94 only. Penalty shot box, called from chkprogress (penalty94_1). Sets gmode2 bit 7; in Shootout (bit 0) jumps to PlayoffRoundScreen
	;instead. Otherwise: printbig 'PENALTY SHOT!', the shooter (BA_Sktr_SCnum, BA_Team), the penalty name (PenaltyList, pspenalty) and ' by' the
	;player BA_Checker_Offset of the other team
	bset	#7,(gmode2).w
	btst	#0,(gmode2).w
.0
	beq.w	.1
	jmp	PlayoffRoundScreen
.1
	movem.l	d0-d2/a0-a4,-(sp)
	move.w	#$FFFF,d0
	jsr	(prefmes).l	;d0 = -1
	bsr.w	printz
	String	$BF,3,2	;IDA: ori.b / andi.b
	moveq	#$1B,d0	;IDA hid this in the string
.2
	moveq	#8,d1
	bsr.w	Framer
.3
	lea	PenShotBigTxt(pc),a1
.4
	bsr.w	printbig
	move.w	(BA_Sktr_SCnum).w,d0
	asl.w	#7,d0	;sprite structs are $80 bytes
	movea.l	#SortCords,a2
	adda.w	d0,a2
	clr.w	d0
	move.b	$66(a2),d0	;roster slot
	movea.l	#HmShots,a2
	tst.w	(BA_Team).w
	beq.w	.6
.5
	movea.l	#AwShots,a2
.6
	bsr.w	FormatPlayerNameWithAttrib
	bsr.w	print
	bsr.w	printz
	String	$BF,4,7	;IDA: ori.b / btst
	movem.l	a1/a3,-(sp)
	move.w	(pspenalty).w,d0
	movea.l	#PenaltyList,a1
	adda.w	0(a1,d0.w),a1
	lea	2(a1),a1
	bsr.w	print
	movem.l	(sp)+,a1/a3
	bsr.w	printz
	String	' by',$BF,4,8	;IDA: ori.b / subi.b / add.b
	move.w	(BA_Checker_Offset).w,d0	;IDA hid this in the string
	movea.l	#AwShots,a2
	tst.w	(BA_Team).w
	beq.w	.7
	movea.l	#HmShots,a2
.7
	jsr	(FormatPlayerNameWithAttrib).l
	jsr	(print).l
	movem.l	(sp)+,d0-d2/a0-a4
	rts
PenShotBigTxt	String	$BF,4,3,'PENALTY SHOT!',$BF,4,5	;printbig String for PenaltyShotBox
DisplayPlayerAttributeMenu	;93 name. Goal box. Closes both line change boxes, then printbig 'GOAL!' ('PP GOAL!' when DelayedPen
	;bit 0 is set, cleared here), or 'HAT TRICK!' on the scorer's third goal when the scorer's slot is at least scorergoalies (homegoalies home /
	;awaygoalies visitors), then the scorer and up to two assists of the last goal entry (FormatPlayerName). 94 calls CountGoalies, StartArenaAnim (home
	;hat trick), PrintPlayerGoals and PrintPlayerAssists (not matched yet); BA_PS_flags bit 2 sets sflags2 bit 2. Called from SetPA (penalty94_1)
	movem.l	d0-d2/a0-a4,-(sp)
	btst	#2,(BA_PS_flags).w
	beq.w	.0
	bset	#2,(sflags2).w
.0
	movea.w	#(HmShots-M68K_RAM),a2
	jsr	(lcfound2).l	;close lc box
	adda.w	#tmsize,a2
	jsr	(lcfound2).l
	movea.w	#(ChkCnt-M68K_RAM),a4	;+ ScoreSumbytes = last goal entry
	adda.w	(ScoreSumbytes).w,a4
	bsr.w	printz
	String	$BF,$B,2	;IDA: ori.b / andi.b
	moveq	#$13,d0	;IDA hid this in the string
	move.w	#5,d1	;5 rows: no assist
	tst.b	4(a4)
	bmi.w	.frame
	addq.w	#2,d1	;7: one assist
	tst.b	5(a4)
	bmi.w	.frame
	addq.w	#1,d1	;8: two assists
.frame
	bsr.w	Framer
	jsr	(CountGoalies).l
	movea.w	#(HmShots-M68K_RAM),a2
	move.w	(homegoalies).w,(scorergoalies).w
	btst	#7,2(a4)
	beq.w	.1	;home team scored
	adda.w	#tmsize,a2
	move.w	(awaygoalies).w,(scorergoalies).w
.1
	lea	GoalBigTxt(pc),a1
	bclr	#0,(DelayedPen).w
	beq.w	.2
	lea	PPGoalBigTxt(pc),a1
.2
	clr.w	d0
	move.b	3(a4),d0	;scorer
	addi.w	#$B4,d0
	cmpi.b	#3,0(a2,d0.w)	;goals
	bne.w	.4
	movem.w	d1,-(sp)
	clr.w	d1
	move.b	3(a4),d1
	cmp.w	(scorergoalies).w,d1
	movem.w	(sp)+,d1
	blt.w	.4
	adda.w	(a1),a1	;HAT TRICK!
	move.w	d0,-(sp)
	move.w	$28(a2),d0
	cmp.w	(HomeTeam).w,d0
	bne.w	.3
	move.w	#0,d0
	jsr	(StartArenaAnim).l
.3
	move.w	(sp)+,d0
.4
	bsr.w	printbig
	clr.w	d0
	move.b	3(a4),d0
	move.w	d0,-(sp)
	move.w	#$C,(printx).w
	bsr.w	FormatPlayerName
	bsr.w	print
	move.w	(sp)+,d0
	movem.w	d1,-(sp)
	clr.w	d1
	move.b	3(a4),d1
	cmp.w	(scorergoalies).w,d1
	movem.w	(sp)+,d1
	blt.w	.5
	jsr	(PrintPlayerGoals).l
.5
	clr.w	d0
	move.b	4(a4),d0	;first assist
	bmi.w	.6
	bclr	#5,(sflags4).w
	bne.w	.6	;sflags4 bit 5 set: no assists
	bsr.w	printz
	String	$BF,$E,6,'Assist by:',$BF,$C,7	;IDA: code
	move.w	d0,-(sp)	;IDA hid this in the string
	bsr.w	FormatPlayerName
	bsr.w	print
	move.w	(sp)+,d0
	jsr	(PrintPlayerAssists).l
	clr.w	d0
	move.b	5(a4),d0	;second assist
	bmi.w	.6
	bsr.w	printz
	String	$BF,$C,8	;IDA: ori.b / #0
	move.w	d0,-(sp)	;IDA hid this in the string
	bsr.w	FormatPlayerName
	bsr.w	print
	move.w	(sp)+,d0
	jsr	(PrintPlayerAssists).l
.6
	bclr	#5,(sflags4).w
	movem.l	(sp)+,d0-d2/a0-a4
	rts
GoalBigTxt	String	$BF,$F,3,'GOAL!',$BF,$C,5	;printbig Strings for DisplayPlayerAttributeMenu (93 attrText): GOAL!, then HAT TRICK!
	String	$BF,$C,3,'HAT TRICK!',$BF,$C,5
PPGoalBigTxt	String	$BF,$D,3,'PP GOAL!',$BF,$C,5	;The same after DelayedPen bit 0: PP GOAL!, then HAT TRICK!
	String	$BF,$C,3,'HAT TRICK!',$BF,$C,5
box	;IDA name (93 box). Fill a $13 x 8 rectangle at printz position $FF,$B,2 with char $7FF (eraser). Called from SetLCmode2 (logic94_1)
	bsr.w	printz
	String	$FF,$B,2	;IDA dc.b
	moveq	#$13,d0	;IDA hid this in the string
	moveq	#8,d1
	move.l	#$7FF,d2
	bra.w	eraser
GetTempPlayerName	;93 GetPlayerName, but that is the same symbol as getplayername (SNASM symbols are case-insensitive).
	;a1 = mesarea "NN First Last" (getname) for player TempPlOffset (bit 15 set: away team). Called from UpdatePA (penalty94_1)
	movem.l	d0/a2,-(sp)
	movea.w	#(HmShots-M68K_RAM),a2
	move.w	(TempPlOffset).w,d0
	bpl.w	.0
	andi.w	#$FF,d0
	adda.w	#$364,a2	;away team (tmsize)
.0
	bsr.w	getname
	movem.l	(sp)+,d0/a2
	rts
getname	;IDA name (93 getname). gets player number and name, appends to string: a1 = mesarea "NN First Last" for player d0 (roster offset) of team struct a2. The number is the bcd byte after the name
	movem.l	d0-d3/a0/a2-a3,-(sp)	;push to stack
	bsr.w	getplayername	;get to start of player name
	move.l	a0,-(sp)	;push a0 (address to start of player name) to stack
	movea.w	#(mesarea-M68K_RAM),a3	;move mesarea to a3 address
	move.w	#4,(a3)	;move 4 into a3 address location
	lea	2(a3),a1	;move long address at a3+2 into a1
	adda.w	(a0),a0	;add data at a0 (player name length) to a0
	move.b	(a0),d0	;move a0 data (jersey #) to d0
	bsr.w	d0toascii	;convert JNo to ascii
	bsr.w	appendz	;add space after JNo
	String	' '
	movea.l	(sp)+,a1	;pop from stack into a1 (address to start of player name)
	bsr.w	appstring	;add player name to string a3
	movea.w	#(mesarea-M68K_RAM),a1	;move mesarea address into a1
	movem.l	(sp)+,d0-d3/a0/a2-a3	;pop from stack
	rts
GetPlayerNameWithAttrib	;93 name. a1 = mesarea "NN F. Last" (FormatPlayerNameWithAttrib) for player TempPlOffset (bit 15 set: away team). Called from ShowInjuryBox
	movem.l	d0/a2,-(sp)
	movea.w	#(HmShots-M68K_RAM),a2
	move.w	(TempPlOffset).w,d0
	bpl.w	.get
	andi.w	#$FF,d0
	adda.w	#tmsize,a2
.get
	bsr.w	FormatPlayerNameWithAttrib
	movem.l	(sp)+,d0/a2
	rts
FormatPlayerNameWithAttrib	;93 name. a1 = mesarea string "NN F. Last" for player d0 of team a2, built in TextBuffer (93 name). Called from PenaltyShotBox and others
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	getplayername
	move.l	a0,-(sp)
	movea.w	#(TextBuffer-M68K_RAM),a1
	adda.w	(a0),a0
	move.b	(a0),d0
	bsr.w	d0toascii
	move.b	#$20,(a1)+
	movea.l	(sp)+,a0
	move.w	(a0)+,d0
	lea	-2(a0,d0.w),a2
	move.b	(a0)+,(a1)+	;first initial
	move.w	#$2E20,(a1)+	;'. '
.skip
	cmpi.b	#$20,(a0)+
	bne.s	.skip
.copy
	move.b	(a0)+,(a1)+
	cmpa.l	a0,a2
	bne.s	.copy
	bsr.w	FinalizeTextBuffer
	movem.l	(sp)+,d0-d3/a0/a2
	rts
FormatPlayerName	;93 name. a1 = mesarea string "NN Last" for player d0 of team a2, built in TextBuffer. Called from DisplayPlayerAttributeMenu and others
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	getplayername
	move.l	a0,-(sp)
	movea.w	#(TextBuffer-M68K_RAM),a1
	adda.w	(a0),a0
	move.b	(a0),d0
	bsr.w	d0toascii
	move.b	#$20,(a1)+
	movea.l	(sp)+,a0
	move.w	(a0)+,d0
	lea	-2(a0,d0.w),a2
.skip
	cmpi.b	#$20,(a0)+
	bne.s	.skip
.copy
	move.b	(a0)+,(a1)+
	cmpa.l	a0,a2
	bne.s	.copy
	bsr.w	FinalizeTextBuffer
	movem.l	(sp)+,d0-d3/a0/a2
	rts
FormatPlayerNameLast	;94 only. FormatPlayerNameShort without the leading space ("Last", space padded). Branches into FormatLastName
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	getplayername
	movea.w	#(TextBuffer-M68K_RAM),a1
	bra.w	FormatLastName
FormatPlayerNameShort	;93 name. a1 = mesarea string " Last" for player d0 of team a2, space padded to 12 characters; a 0 byte also ends the name
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	getplayername
	movea.w	#(TextBuffer-M68K_RAM),a1
	move.b	#$20,(a1)+
FormatLastName	;Skip the first name, copy the last name, pad; branched to from FormatPlayerNameLast, so global
	move.w	(a0)+,d0
	lea	-2(a0,d0.w),a2
.loop
	cmpi.b	#$20,(a0)+
	bne.s	.loop
.loop2
	move.b	(a0)+,(a1)+
	cmpa.l	a0,a2
	beq.w	.0
	tst.b	(a0)
	bne.s	.loop2
	bra.w	.0
.loop3
	move.b	#$20,(a1)+
.0
	cmpa.w	#$BFB2,a1	;TextBuffer+12
	blt.s	.loop3
	bsr.w	FinalizeTextBuffer
	movem.l	(sp)+,d0-d3/a0/a2
	rts
FinalizeTextBuffer	;93 name. mesarea length word = a1 - mesarea, with a 0 pad byte when odd. Returns a1 = mesarea. Called from the FormatPlayerName routines
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
getplayername	;IDA name (93 GetPlayerNamePointer). loops through team roster to get to d0 player: a0 = name string of player d0 (roster offset) of
	;team struct a2. Each record is a length word String and 8 more bytes
	movea.l	$1E(a2),a0	;offset $1E - ROM address of team data?
	adda.w	(a0),a0	;add offset (player data start) to a0 address
	bra.w	.loop
.skip
	adda.w	(a0),a0	;add player name length to a0
	addq.w	#8,a0	;add 8 to a0 (player attributes field)
.loop
	dbf	d0,.skip	;loop until at player offset
	rts
d0toascii	;IDA name (93 ConverByteToDigits). converts decimal number in d0 to ascii: two ascii digits of bcd byte d0 to (a1)+, a leading 0 becomes a space ($F0 + '0')
	move.w	d0,-(sp)	;push to stack
	lsr.b	#4,d0	;divide by 16 (get upper digit in d0)
	bne.w	.n0	;branch if not 0
	move.b	#$F0,d0	;move $F0 into d0
.n0
	addi.b	#$30,d0	;'0'   ; add $30 (48 dec) to d0
	move.b	d0,(a1)+	;move d0 into a1 and increment
	move.w	(sp)+,d0	;pop d0 from stack
	andi.w	#$F,d0	;pass bottom 4 bytes of d0 (lower digit in d0)
	addi.b	#$30,d0	;'0'   ; add $30 (48 dec) to d0
	move.b	d0,(a1)+	;move d0 into a1 and increment
	rts
AddError	;IDA: AdrErr (92 / 93 name, main94 vectors). Address error vector; 94 has no BusError, the bus error vector also points here
	move	#$2700,sr
	bsr.w	printbigz
	String	$BD,0,0,'Address Error'	;IDA dc.b
	move.l	$A(sp),d0	;pc. IDA dc.b
	move.l	2(sp),d1	;access address
	bra.w	crash
Illinst	;IDA: InvOpCode (92 / 93 name, main94 vectors). Illegal instruction vector
	move	#$2700,sr
	bsr.w	printbigz
	String	$BD,0,0,'Illegal Instruction'	;IDA dc.b
	move.l	2(sp),d0	;IDA dc.b
	move.l	d0,d1
	bra.w	crash
ZeroDiv	;IDA: DivBy0 (92 / 93 name, main94 vectors). Divide by zero vector, falls into crash
	move	#$2700,sr
	bsr.w	printbigz
	String	$BD,0,0,'Division by zero'	;IDA dc.b
	move.l	2(sp),d0	;IDA dc.b
	move.l	d0,d1
crash	;92 / 93 name. printbig d1 then d0 as hex, set the vdp up, copy 8 longs from the Rinktilelist palette + $20 (93 IceRinkMap)
	;to cram $20 and hang. Branched to from AddError and Illinst, falls in from ZeroDiv
	movea.w	#(mesarea-M68K_RAM),a0
	move.w	#$18,(a0)+	;2+3+8+3+8 (93 form)
	move.b	#$BD,(a0)+	;92 -$43
	move.b	#0,(a0)+
	move.b	#2,(a0)+
	move.l	d1,-(sp)
	bsr.w	.ri	;d1
	move.b	#$BD,(a0)+
	move.b	#0,(a0)+
	move.b	#4,(a0)+
	move.l	(sp)+,d0
	bsr.w	.ri	;d0
	movea.w	#(mesarea-M68K_RAM),a1
	bsr.w	printbig
	movea.l	#VDP_DATA,a0
	move.w	#$9100,4(a0)
	move.w	#$9206,4(a0)
	move.w	#$8F02,4(a0)
	move.l	#$C0200000,4(a0)	;cram write $20 (92 $C0060000)
	movea.l	#Rinktilelist,a1
	adda.l	(a1),a1
	adda.w	#$20,a1
	moveq	#7,d0
.pal
	move.l	(a1)+,(a0)
	dbf	d0,.pal
.end
	bra.w	.end
.ri	;93 local .ri. d0 as 8 hex digits to (a0)+
	moveq	#7,d2
.top
	rol.l	#4,d0
	move.w	d0,d1
	andi.w	#$F,d1
	addi.w	#$30,d1
	cmp.w	#$39,d1
	ble.w	.t1
	addq.w	#7,d1	;'A'-'0'-10
.t1
	move.b	d1,(a0)+
	dbf	d2,.top
	rts
