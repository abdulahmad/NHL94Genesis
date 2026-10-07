;	NHL 94 (retail) segment $17C72-$1837F
;	92 hockey.asm DefaultMenus, NewPO, MakeTree, FigureJoy and the playoff password code, as 93 hockey93_09: DefaultMenus (IDA
;	LoadDefMenuOptions), ContinuePlayoffs (93 NewPO), NewPO (93 SelectRandomPlayoffTree), MakeTree, FigureJoy, InitializeGameStructures, OptionRNG,
;	ReadPassBits ... SuperDiv, GetShifter, and the playoff stat packing (AddPOStats, BitWidthTable, ReadTeamStats). It follows
;	attract94 ($17C71) with no gap. ResolveGames starts hockey94_10.
;	94 keeps the playoff bits in pwddatabuffer (93 name) and saves them through WriteLineData (where 93 calls BitsToPW).
;	94 adds FourWayPlay (cont3team / cont4team, the Three and Four player choices) and Shootout, and has 9 menu options (93 7).
;	Transcribed from lst/nhl94.bin.lst lines 54836-55537. Global names are the IDA names, or the 93 name where IDA has an auto name.
;	Locals are the IDA local names (_x -> .x) or the 93 local where the code matches, else in the 93 style (.x exit, .loop, numbered), with the IDA label, unless generic,
;	in an ;IDA: comment.
;	The only IDA gap is BitWidthTable (IDA dc.b).
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp / cmpi;
;	fixopcodes.js patches the cmp encoding after assembly.
;	RAM (IDA names, 93 names): potree, WinBits, pojoy (93 playoffroundoffset), statsbuffer,
;	tpassbits. gsstruct game ($10 bytes, 93 gstruct): 0 gst1, 2 gst2, 4 gspotwins, 6 gspobwins, 8 gsper, $A gss1, $C gss2,
;	$E gsflags (bits 0 gsftf teams flipped, 1 gsfhl hilite, 2 gsfso series over).

DefaultMenus	;IDA: LoadDefMenuOptions. Set the default menu choices for the beginning of the game: the 9 option words from defmenuoptions (93: 7). Called once from Begin
	st	(demoflag).w	;no demo has run yet
	movea.l	#OptPlayMode,a0	;Start of Menu Options in RAM
	movea.l	#defmenuoptions,a1
	move.w	#8,d0	;9 options (93 6)
.loop
	move.w	(a1)+,(a0)+
	dbf	d0,.loop
	rts
defmenuoptions	;IDA name (93 DefaultMenus .defom). Regular Season, One - Home, MTL, LA, 10 Minutes, Manual Control, User Records Off, Penalties Off,
	;Line Changes Off (the hockey94_08 value lists; 93 0,1,$F,3,1,0,1)
	dc.w	0	;Play Mode
	dc.w	1	;Players
	dc.w	$B	;Team 1
	dc.w	$A	;Team 2
	dc.w	1	;Per Length
	dc.w	0	;Goalies
	dc.w	1	;User Records
	dc.w	0	;Penalties
	dc.w	1	;Line Changes
ContinuePlayoffs	;IDA name, kept: this is 93 NewPO, but IDA gives the name NewPO to the next routine (93 SelectRandomPlayoffTree). Continue playoffs:
	;read the playoff state back from the saved bits at pwddatabuffer (93 name), rebuild the tree and set OptNOP from pojoy (93 playofflevel
	;= 7 - playoffroundoffset; 94 7 or $B with FourWayPlay, pojoy adjusted to the pad set-ups). Called from hockey94_08 (GoContinuePlayoffs, GameSetUp_3)
	movem.l	d0-d7/a0-a3,-(sp)
	movea.w	#(pwddatabuffer-M68K_RAM),a3
	bsr.w	ReadPassBits
	move.w	(gamelevel).w,d0
	or.w	(bosgames).w,d0
	beq.w	.x	;level 0, game 0: nothing played yet
	bsr.w	MakeTree
	moveq	#7,d0
	tst.w	(FourWayPlay).w
	beq.w	.0
	move.w	#$B,d0
.0
	tst.w	(FourWayPlay).w
	bne.w	.1
	cmpi.w	#2,(pojoy).w
	blt.w	.3
	subq.w	#2,(pojoy).w
	bra.w	.3
.1
	cmpi.w	#1,(pojoy).w
	bne.w	.2
	move.w	#3,(pojoy).w
	bra.w	.3
.2
	cmpi.w	#2,(pojoy).w
	bne.w	.3
	move.w	#4,(pojoy).w
.3
	sub.w	(pojoy).w,d0
	move.w	d0,(OptNOP).w
.x
	movem.l	(sp)+,d0-d7/a0-a3
	rts
NewPO	;IDA name (92 NewPO, 93 SelectRandomPlayoffTree). New playoff generates tree with same team 1. Called from hockey94_08 (j_NewPO). Falls into MakeTree
	moveq	#$20,d0	;' '   ; 20 = 32 decimal
	bsr.w	randomd0
.top
	addq.w	#1,d0	;adds 1 to d0 (d0 cannot be 0)
	andi.w	#$1F,d0	;mask d0 with 1F (31 decimal). Makes sure its 31 or less
	asl.w	#4,d0	;multiply d0 by 16
	movea.l	#playoffseats,a0
	adda.w	d0,a0	;use d0 as offset
	lsr.w	#4,d0	;divide d0 by 16
	moveq	#$F,d1	;move 15 into d1
	move.w	(Opt1Team).w,d2	;Team 1 on menu
	cmp.w	#$19,d2	;compares #NumOfTeams-3 to d2 (25 decimal)
	bls.w	.loop	;branch if d2 less than 19 hex
	moveq	#$19,d2	;move 19 into d2 (limits team selection; all-star teams use team 25, 93 23)
.loop
	cmp.b	(a0)+,d2	;compare team at a0+ to d2 (looks at second byte of a0)
	dbeq	d1,.loop	;iterate through loop until team is found
	bne.s	.top
	eori.w	#$F,d1
	move.w	d1,(potreeteam).w	;which team are you on the initial playoff tree
	move.w	d0,(postarts).w	;0-31 for which playoff tree to use as frame
	clr.w	(gamelevel).w	;0-3 for the depth into the playoff tree
	move.w	#7,(bosgames).w	;0-6 game of series or 7 if not in best of seven
	cmpi.w	#2,(OptPlayMode).w	;play mode on Main Menu
	beq.w	MakeTree	;jump to make playoff tree if play mode is 2
	clr.w	(bosgames).w	;best of seven: game 0
	moveq	#7,d0	;clr games won
	movea.w	#(gsstruct-M68K_RAM),a0	;Game struct variables start
.cg
	clr.w	4(a0)	;gspotwins
	clr.w	6(a0)	;gspobwins
	adda.w	#$10,a0	;gssize
	dbf	d0,.cg	;falls into MakeTree
MakeTree	;IDA name (93 maketree, 92 MakeTree). Make the playoff tree (potree, 93 name) from playoffseats and the winbits (WinBits, 93
	;WinBits), clear the scores of this round's games and set their teams (.sett), then FigureJoy. Called from ContinuePlayoffs, EncodePW and hockey94_08
	;(SetupStart); falls in from NewPO
	movem.l	d0-d4/a0-a3,-(sp)
	move.w	(postarts).w,d1
	asl.w	#4,d1
	movea.w	#(potree-M68K_RAM),a0
	movea.l	#playoffseats,a1
	adda.w	d1,a1
	move.l	(a1),(a0)	;first round: 16 teams from the tree
	move.l	4(a1),4(a0)
	move.l	8(a1),8(a0)
	move.l	$C(a1),$C(a0)
	lea	$10(a0),a1
	moveq	#$E,d2	;15 winners
	move.w	(WinBits).w,d0
.0
	move.w	d0,d1
	andi.w	#1,d1	;winbit picks the top or bottom team of the pair
	move.b	0(a0,d1.w),(a1)+
	addq.w	#2,a0
	lsr.w	#1,d0
	dbf	d2,.0
	bsr.w	GetShifter
	tst.w	d1
	bmi.w	.nogames	;playoffs over
	movea.w	#(potree-M68K_RAM),a0
	adda.w	d2,a0
	adda.w	d2,a0
	movea.w	#(gsstruct-M68K_RAM),a1
.loop
	clr.w	gss1(a1)	;gsstruct: gss1
	clr.w	gss2(a1)	;gss2
	clr.w	gsper(a1)	;gsper
	bclr	#1,gsflags(a1)	;hilite requested (92 gsfhl)
	bsr.w	.sett	;93 local .sett
	adda.w	#gssize,a1
	dbf	d1,.loop
	bsr.w	FigureJoy
.nogames
	movem.l	(sp)+,d0-d4/a0-a3
	rts
.sett	;93 .sett. Series games 2, 3, 5: tree order, others swapped
	cmpi.w	#2,(bosgames).w
	beq.w	.1
	cmpi.w	#3,(bosgames).w
	beq.w	.1
	cmpi.w	#5,(bosgames).w
	beq.w	.1
	bset	#0,gsflags(a1)	;teams are flipped (92 gsftf)
	move.b	(a0)+,gst2+1(a1)
	move.b	(a0)+,gst1+1(a1)
	rts
.1
	bclr	#0,gsflags(a1)	;(93 .flip) gsftf
	move.b	(a0)+,gst1+1(a1)
	move.b	(a0)+,gst2+1(a1)
	rts
FigureJoy	;IDA name (92 / 93 FigureJoy). Set contteams appropriately: cont1team ... cont4team (94 adds 3 and 4 for FourWayPlay). In the playoffs
	;(not Shootout, gmode2 bit 0) find this round's game of the po team and set the teams and pads from .pojoylist (.pojoylist2 with
	;FourWayPlay); otherwise from .noplist by OptNOP. After a demo (demoflag clear), and outside the playoffs, fill gsstruct with random matchups
	;(InitializeGameStructures). Called from MakeTree and hockey94_08 GameSetUp
	movem.l	d0-d3/a0-a1,-(sp)
	clr.w	(cont1team).w
	clr.w	(cont2team).w
	clr.w	(cont3team).w
	clr.w	(cont4team).w
	tst.w	(demoflag).w
	beq.w	.init	;demo ran
	tst.w	(OptPlayMode).w
	beq.w	.fjnpo	;regular season
	btst	#0,(gmode2).w
	bne.w	.fjnpo	;shootout (94)
	bsr.w	GetShifter
	movea.w	#(potree-M68K_RAM),a0	;#potree
	move.w	(potreeteam).w,d2
	move.b	0(a0,d2.w),d2	;po team
	movea.w	#(gsstruct-M68K_RAM),a1
	moveq	#gssize,d4
	mulu.w	d1,d4
	adda.w	d4,a1
	st	(gamenum).w
	clr.w	d0
.f0
	cmp.w	(a1),d2
	beq.w	.it1
	cmp.w	gst2(a1),d2
	beq.w	.it2
	suba.w	#gssize,a1
	dbf	d1,.f0
	bra.w	.ex	;po team not in playoffs
.it2
	moveq	#4,d0
	tst.w	(FourWayPlay).w
	beq.w	.it22
	move.w	#5,d0
.it22
	move.w	(a1),(Opt2Team).w	;(93 menuawayteam)
	move.w	gst2(a1),(Opt1Team).w
	bra.w	.itx
.it1
	clr.w	d0
	move.w	gst2(a1),(Opt2Team).w
	move.w	(a1),(Opt1Team).w
.itx
	add.w	(pojoy).w,d0	;(93 playoffroundoffset)
	move.w	d1,(gamenum).w
	move.w	(a1),(HomeTeam).w
	move.w	gst2(a1),(VisTeam).w
	asl.w	#2,d0
	lea	.pojoylist(pc),a0
	tst.w	(FourWayPlay).w
	beq.w	.0
	lea	.pojoylist2(pc),a0
.0
	move.w	0(a0,d0.w),(cont1team).w
	move.w	2(a0,d0.w),(cont2team).w
	tst.w	(FourWayPlay).w
	beq.w	.ex
	cmp.w	#4,d0
	beq.w	.1	;pojoy 1: cont3team / cont4team = cont1team / cont2team
	cmp.w	#$18,d0
	beq.w	.1
	bra.w	.2
.1
	move.w	(cont1team).w,(cont3team).w
	move.w	(cont2team).w,(cont4team).w
	bra.w	.ex
.2
	cmp.w	#8,d0
	beq.w	.3	;pojoy 2: cont3team = cont1team, cont4team 0
	cmp.w	#$1C,d0
	beq.w	.3
	bra.w	.ex
.3
	move.w	(cont1team).w,(cont3team).w
	move.w	#0,(cont4team).w
	bra.w	.ex
.pojoylist	;IDA: _pojoylist. cont1team, cont2team for pojoy 0-3 with the po team as team 1, then as team 2
	dc.w	1
	dc.w	0
	dc.w	1
	dc.w	1
	dc.w	1
	dc.w	2
	dc.w	2
	dc.w	1
	dc.w	2
	dc.w	0
	dc.w	2
	dc.w	2
	dc.w	2
	dc.w	1
	dc.w	1
	dc.w	2
.pojoylist2	;IDA: _pojoylist2. The same with FourWayPlay, pojoy 0-4
	dc.w	1
	dc.w	0
	dc.w	1
	dc.w	2
	dc.w	1
	dc.w	2
	dc.w	1
	dc.w	1
	dc.w	1
	dc.w	2
	dc.w	2
	dc.w	0
	dc.w	2
	dc.w	1
	dc.w	2
	dc.w	1
	dc.w	2
	dc.w	2
	dc.w	2
	dc.w	1
.fjnpo	;IDA: _fjnpo. 93 used playofflevel
	move.w	(OptNOP).w,d0
	asl.w	#2,d0
	lea	.noplist(pc),a0
	move.w	0(a0,d0.w),(cont1team).w
	move.w	2(a0,d0.w),(cont2team).w
	cmp.w	#$14,d0	;Three
	bne.w	.4
	move.w	(cont1team).w,(cont3team).w
	move.w	#0,(cont4team).w
	bra.w	.init
.4
	cmp.w	#$18,d0	;Four
	bne.w	.init
	move.w	(cont1team).w,(cont3team).w
	move.w	(cont2team).w,(cont4team).w
.init
	bsr.w	InitializeGameStructures	;(93 .init)
.ex
	movem.l	(sp)+,d0-d3/a0-a1
	rts
.noplist	dc.w	0	;IDA: _noplist. cont1team, cont2team by OptNOP 0-6 (93 0-4)
	dc.w	0
	dc.w	1
	dc.w	0
	dc.w	2
	dc.w	0
	dc.w	1
	dc.w	1
	dc.w	1
	dc.w	2
	dc.w	1
	dc.w	2
	dc.w	1
	dc.w	2
InitializeGameStructures	;93 name. Random team pairs for all 8 gsstruct games, none of them HomeTeam or VisTeam. Called from FigureJoy
	st	(gamenum).w
	clr.l	d3	;d3 = used team bits
	move.w	(HomeTeam).w,d1
	bset	d1,d3
	move.w	(VisTeam).w,d1
	bset	d1,d3
	movea.w	#(gsstruct-M68K_RAM),a1
	moveq	#7,d2
.loop
	bsr.w	OptionRNG
	move.w	d0,(a1)
	bsr.w	OptionRNG
	move.w	d0,gst2(a1)
	adda.w	#gssize,a1
	dbf	d2,.loop
	rts
OptionRNG	;IDA name (93 GetRandomUnusedTeam). Calls randomd0 when changing options: return d0 = a random team 0-25 (93 0-23) not yet set in d3, and set its bit. Called from InitializeGameStructures
	moveq	#$1A,d0
	bsr.w	randomd0
	bset	d0,d3
	bne.s	OptionRNG
	rts
ReadPassBits	;93 name. Translate the saved bits at a3 (5 words) to the playoff variables; the 5 words are kept. 94: pojoy has 8
	;values (93 4), and without FourWayPlay pojoy 1 / 2 become 4. Called from ContinuePlayoffs, EncodePW and hockey94_08 GameSetUp
	moveq	#4,d0
	lea	$A(a3),a0
.save
	move.w	-(a0),-(sp)	;SuperDiv destroys the bits
	dbf	d0,.save
	moveq	#7,d2
	movea.w	#(gsstruct+(7*$10)-M68K_RAM),a1	;last gsstruct game (gsstruct + 7 * $10)
.loop
	bclr	#2,gsflags(a1)	;series over (92 gsfso)
	moveq	#5,d0
	bsr.w	SuperDiv
	move.w	d0,gspobwins(a1)	;gspobwins
	cmp.w	#4,d0
	bne.w	.nsf0
	bset	#2,gsflags(a1)
.nsf0
	moveq	#5,d0
	bsr.w	SuperDiv
	move.w	d0,gspotwins(a1)	;gspotwins
	cmp.w	#4,d0
	bne.w	.nsf1
	bset	#2,gsflags(a1)
.nsf1
	suba.w	#gssize,a1
	dbf	d2,.loop
	move.w	#$4000,d0
	bsr.w	SuperDiv
	move.w	d0,(WinBits).w	;winbits (93 WinBits)
	move.w	#8,d0
	bsr.w	SuperDiv
	move.w	d0,(pojoy).w	;(93 playoffroundoffset)
	tst.w	(FourWayPlay).w
	bne.w	.1
	cmpi.w	#1,(pojoy).w
	beq.w	.0
	cmpi.w	#2,(pojoy).w
	bne.w	.1
.0
	move.w	#4,(pojoy).w
.1
	moveq	#$10,d0
	bsr.w	SuperDiv
	move.w	d0,(potreeteam).w
	moveq	#4,d0
	bsr.w	SuperDiv
	move.w	d0,(gamelevel).w
	moveq	#8,d0
	bsr.w	SuperDiv
	move.w	d0,(bosgames).w
	moveq	#$20,d0
	bsr.w	SuperDiv
	move.w	d0,(postarts).w
	moveq	#4,d0
	lea	(a3),a0
.restore
	move.w	(sp)+,(a0)+	;put the bits back
	dbf	d0,.restore
	rts
EncodePW	;93 name. After a playoff game compute winners and save the bits if needed. 94 returns at once for Demo, Regular
	;Season and Shootout, and sets TempOptPlayMode with OptPlayMode. The bits are pwddatabuffer (93 name); WriteLineData (not matched yet) is
	;where 93 calls BitsToPW. Called from GameOver (hockey94_06)
	tst.w	(OptNOP).w
	beq.w	rtss2
	tst.w	(OptPlayMode).w
	beq.w	rtss2
	cmpi.w	#4,(OptPlayMode).w
	beq.w	rtss2
	move.w	#1,(OptPlayMode).w	;continue playoffs
	move.w	#1,(TempOptPlayMode).w
	bsr.w	ResolveGames	;93 ResolveGames (hockey94_10)
	bsr.w	MakeTree
	cmpi.w	#4,(gamelevel).w
	beq.w	.0	;finished playoffs
	tst.w	(gamenum).w
	bmi.w	.0	;po team out, same as a win
	movea.w	#(pwddatabuffer-M68K_RAM),a3
	bsr.w	WritePassBits
	jsr	(WriteLineData).l
	btst	#sf3alttree,(sflags3).w	;93 sf3alttree
	beq.w	rtss2
	movea.w	#(tpassbits-M68K_RAM),a3	;bits before all games resolved (93 tpassbits)
	bsr.w	ReadPassBits
	bra.w	MakeTree
.0
	movea.w	#(pwddatabuffer-M68K_RAM),a3
	bsr.w	ClrPassBits
	jsr	(WriteLineData).l
	move.w	#2,(OptPlayMode).w	;new playoffs
	move.w	#2,(TempOptPlayMode).w
	cmpi.w	#7,(bosgames).w
	beq.w	rtss2
	move.w	#3,(OptPlayMode).w	;new playoffs best of 7
	move.w	#3,(TempOptPlayMode).w
	rts
WritePassBits	;93 name. Transfer the game variables to the bits at a3 (pojoy range 8, 93 4). Called from EncodePW and ResolveGames (hockey94_10)
	bsr.w	ClrPassBits
	move.w	(postarts).w,d0
	moveq	#$20,d1
	bsr.w	PushBits
	move.w	(bosgames).w,d0
	moveq	#8,d1
	bsr.w	PushBits
	move.w	(gamelevel).w,d0
	moveq	#4,d1
	bsr.w	PushBits
	move.w	(potreeteam).w,d0
	moveq	#$10,d1
	bsr.w	PushBits
	move.w	(pojoy).w,d0
	moveq	#8,d1
	bsr.w	PushBits
	move.w	(WinBits).w,d0
	move.w	#$4000,d1	;92 1<<14
	bsr.w	PushBits
	moveq	#5,d1
	moveq	#7,d2
	movea.w	#(gsstruct-M68K_RAM),a1
.loop
	move.w	gspotwins(a1),d0
	bsr.w	PushBits
	move.w	gspobwins(a1),d0
	bsr.w	PushBits
	adda.w	#gssize,a1
	dbf	d2,.loop
	rts
PushBits	;93 name. bits = bits * d1 + d0. d1 = range 2^1-2^15, d0 = data
	movem.l	d0-d1,-(sp)
	exg	d0,d1
	bsr.w	SuperMult
	clr.l	d0
	move.w	d1,d0
	bsr.w	SuperAdd
	movem.l	(sp)+,d0-d1
	rts
ClrPassBits	;93 name. Clear the 5 words of bits at a3
	movea.w	a3,a0
	moveq	#4,d0
.0
	clr.w	(a0)+
	dbf	d0,.0
	rts
SuperAdd	;93 name. 1 long (d0.L) added to the 5 words at a3
	movem.l	d1/a0,-(sp)
	lea	$A(a3),a0
	moveq	#3,d1
	add.l	d0,-(a0)
	bra.w	.2
.1
	addq.w	#1,-(a0)	;carry into the next word up
.2
	dbcc	d1,.1
	movem.l	(sp)+,d1/a0
	rts
SuperMult	;93 name. 1 word (d0) multiplied by the 5 words at a3
	movem.l	d1-d4/a0,-(sp)
	movea.w	a3,a0
	moveq	#4,d4
.0
	move.w	(a0),-(sp)
	clr.w	(a0)+
	dbf	d4,.0
	moveq	#4,d4
.1
	move.w	d0,d1
	mulu.w	(sp)+,d1
	lea	2(a3),a0
	adda.w	d4,a0
	adda.w	d4,a0
	move.w	d4,d2
	add.l	d1,-(a0)
	bra.w	.3
.2
	addq.w	#1,-(a0)
.3
	dbcc	d2,.2
	dbf	d4,.1
	movem.l	(sp)+,d1-d4/a0
	rts
SuperDiv	;93 name. 5 words at a3 divided by 1 word (d0); d0 = remainder on exit
	movem.l	d1-d2/a0,-(sp)
	movea.w	a3,a0
	moveq	#4,d1
	clr.l	d2
.0
	move.w	(a0),d2
	divu.w	d0,d2
	move.w	d2,(a0)+
	dbf	d1,.0
	swap	d2
	move.w	d2,d0
	movem.l	(sp)+,d1-d2/a0
	rts
GetShifter	;IDA name (92 / 93 GetShifter). Returns d1 = number of games - 1, d2 = first bit of WinBits (WinBits)
	move.l	d0,-(sp)
	moveq	#-$10,d2
	moveq	#$10,d1
	move.w	(gamelevel).w,d0
.3
	add.w	d1,d2
	lsr.w	#1,d1
	dbf	d0,.3
	subq.w	#1,d1
	move.l	(sp)+,d0
	rts
AddPOStats	;IDA name (93 DisplayTeamStatsForPlayoffs). Add the po team's game stats to its packed playoff totals: unpack them (ReadTeamStats),
	;add the $68 stat bytes at team struct + $B4, then pack each total back into the bit stream below outputbuffer + $DE (93 + $5E), clamped to its
	;BitWidthTable width. Called from PeriodOver
	cmpi.w	#1,(OptPlayMode).w
	blt.w	rtss2	;regular season
	bsr.w	ReadTeamStats
	movea.w	#(potree-M68K_RAM),a0
	move.w	(potreeteam).w,d2
	move.b	0(a0,d2.w),d2	;po team
	movea.w	#(HmShots-M68K_RAM),a2
	cmp.w	$28(a2),d2
	beq.w	.0
	adda.w	#$364,a2	;tmsize: the po team is the visitor
.0
	adda.w	#$B4,a2
	moveq	#$67,d0	;$68 stats
	movea.w	#(statsbuffer-M68K_RAM),a1	;93 statsbuffer
.loop
	clr.w	d1
	move.b	(a2)+,d1
	add.w	d1,(a1)+
	dbf	d0,.loop
	movea.w	#(statsbuffer-M68K_RAM),a0
	movea.l	#BitWidthTable,a1
	movea.w	#(outputbuffer-M68K_RAM),a2
	moveq	#$67,d0
	clr.w	d4
.loop2
	clr.l	d1
	move.w	(a0)+,d1
	move.w	d0,d2
	andi.w	#3,d2
	move.b	0(a1,d2.w),d2	;d2 = bit width
	clr.l	d3
	bset	d2,d3
	subq.w	#1,d3	;d3 = max value
	cmp.w	d3,d1
	ble.w	.1
	move.w	d3,d1	;clamp
.1
	not.l	d3
	move.w	d4,d5
	andi.w	#$F,d5
	rol.l	d5,d3
	rol.l	d5,d1
	move.w	d4,d5
	lsr.w	#4,d5
	add.w	d5,d5
	neg.w	d5	;the stream runs down in words
	addi.w	#$100,d5
	and.l	d3,-$22(a2,d5.w)
	or.l	d1,-$22(a2,d5.w)
	add.w	d2,d4
	dbf	d0,.loop2
	rts
BitWidthTable	;93 name. Playoff stat bit widths, indexed by stat number & 3 (93 8, $A, 6, 6)
	dc.b	$C,$E,$A,$A
ReadTeamStats	;93 name. Unpack the $68 playoff stat totals from the bit stream into statsbuffer (93 name) words. Called from AddPOStats and DisplayTeamStats
	movea.w	#(statsbuffer-M68K_RAM),a0
	movea.l	#BitWidthTable,a1
	movea.w	#(outputbuffer-M68K_RAM),a2
	moveq	#$67,d0
	clr.w	d4
.loop
	move.w	d4,d5
	lsr.w	#4,d5
	add.w	d5,d5
	neg.w	d5
	addi.w	#$100,d5
	move.l	-$22(a2,d5.w),d1
	move.w	d4,d5
	andi.w	#$F,d5
	lsr.l	d5,d1
	move.w	d0,d2
	andi.w	#3,d2
	move.b	0(a1,d2.w),d2
	add.w	d2,d4
	clr.w	d3
	bset	d2,d3
	subq.w	#1,d3
	and.w	d3,d1
	move.w	d1,(a0)+
	dbf	d0,.loop
	rts
