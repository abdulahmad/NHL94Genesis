	include	segacd\hockey.inc
	include	macros\genesis.mac

AwGoals	equ	$186BE
BitWidthTable	equ	$408DC
CC_Font1Pri	equ	$BF
CC_SetMapAndPosition	equ	$F8
CalcTeamStarScores	equ	$40CAC
FourWayPlay	equ	$18BF8
GetPeriodTime	equ	$2BA04
HmGoals	equ	$18358
HomeTeam	equ	$17FAE
LOAD	equ	$1B000
Map1col	equ	$18D36
Map2col	equ	$18D3A
Opt1team	equ	$18BFE
Opt2team	equ	$18C00
OptLine	equ	$18C0A
OptNOP	equ	$18BFC
OptPlayMode	equ	$18BFA
ProcessInputWithRepeat	equ	$374BE
PushNumberWidth	equ	$3919A
ReadJoy1	equ	$374F0
RefCnt	equ	$1806E
ScoreSum	equ	$180EC
ScoreSumbytes	equ	$180F0
ScoutSubStatus	equ	$17474
TeamBitmaps	equ	$47D48
TeamList	equ	$1B00C
TeamPalettes	equ	$25060
Teamblocksmap	equ	$47D44
ThreeStars	equ	$BC000
UnpackNibbles	equ	$36BB2
VBint	equ	$18D66
VSPRITES	equ	$18D32
VisTeam	equ	$17FB0
VmMAP1	equ	$18D34
VmMAP2	equ	$18D38
WeightedRandomSelect	equ	$36BE2
WinBits	equ	$18AA4
WriteLineData	equ	$2A5C8
bosgames	equ	$18A9C
cont1team	equ	$17FA6
cont2team	equ	$17FA8
cont3team	equ	$17FAA
cont4team	equ	$17FAC
defmenuoptions	equ	$40120
demoflag	equ	$18C16
disflags	equ	$18D64
dobitmap	equ	$387E2
eraser	equ	$38C06
forceblack	equ	$36D0A
gamelevel	equ	$18A9E
gamenum	equ	$18A98
move	equ	$2C9C8
null	equ	$1B008
palcount	equ	$18D62
passbits	equ	$18C38
playoffseats	equ	$1FFDA
pojoy	equ	$18AA2
postarts	equ	$18A9A
potreeteam	equ	$18AA0
print	equ	$38F80
printsmallz	equ	$38D8C
printx	equ	$18D58
printz	equ	$38F6E
randomd0	equ	$37050
setteams	equ	$3F1BC
sfx	equ	$3710C
swap	equ	$2779A
teambitmapchars	equ	$1939C
tmstruct	equ	$1834C
vb2	equ	$3DB90
X_21000	equ	$21000
X_22BB4	equ	$22BB4
X_24C0C	equ	$24C0C
X_2546E	equ	$2546E
X_2548E	equ	$2548E
X_25532	equ	$25532
X_2557C	equ	$2557C

	org	$24DE8

EASportsScreen						;Called from Begin. Show the EA Sports screen until a button, or $50 x 4
									;frames (about 5 s)
	move.w	#$1,$3FC0A.l
	bsr.w	X_24C0C
	move.l	#vb2,(VBint).l		;vblank handler
	bclr	#$1,(disflags).l		;32 cell flag off
	move.w	#$5,$18D3E.l
	move.w	#$A000,(VmMAP2).l
	move.w	#$7,(Map2col).l
	move.w	#$C000,(VmMAP1).l
	move.w	#$7,(Map1col).l
	move.w	#$F000,$18D3C.l
	move.w	#$F800,(VSPRITES).l
	move.w	#$FC00,$18D30.l
	movea.l	#$BBCB0,a0
	moveq	#$1F,d1		;32 longs: all 64 colours black
.clr	clr.l	(a0)+
	dbra	d1,.clr
	jsr	$36F72.l
	jsr	$37B74.l
	rts
	jsr	(ReadJoy1).l
	cmpi.b	#$E0,d3
	bne.w	X_21000
	bset	#$5,$FF800F.l
	move.l	#vb2,(VBint).l
	jsr	$47DAC.l
	jsr	(forceblack).l
	move.w	#$18,(palcount).l
	bsr.w	printsmallz-LOAD
	String	CC_SetMapAndPosition,$4,$3,$C,$1,'Check Sound'
	moveq	#$14,d6
.l24EAE	move.w	(ScoutSubStatus).l,d0
.l24EB4	cmp.w	(ScoutSubStatus).l,d0
	beq.w	.l24EB4
	jsr	(ReadJoy1).l
	jsr	(ProcessInputWithRepeat).l
	tst.b	d1
	beq.w	.l24EAE
	btst	#$7,d1
	bne.w	X_21000
	btst	#$3,d1
	beq.w	.l24EE4
	addi.w	#$1,d6
.l24EE4	btst	#$2,d1
	beq.w	.l24EF0
	subi.w	#$1,d6
.l24EF0	btst	#$5,d1
	beq.w	.l24EFE
	jsr	(sfx).l
.l24EFE	move.w	d6,d0
	moveq	#$3,d1
	bsr.w	PushNumberWidth-LOAD
	move.w	#$17,(printx).l		;colour 0 white
	bsr.w	print-LOAD
	bra.w	.l24EAE
UpdatePlayoffLevel						;Set pojoy from the number of players for play modes 2 and 3.
	cmpi.w	#$2,(OptPlayMode).l		;playoff mode?
	blt.w	X_21000
	cmpi.w	#$4,(OptPlayMode).l		;mode 4?
	beq.w	X_21000
	moveq	#$7,d0		;8 pad layouts
	tst.w	(FourWayPlay).l		;4-way play?
	beq.w	.set
	move.w	#$B,d0		;4 way play
.set	sub.w	(OptNOP).l,d0		;pojoy = pad layouts minus the player count option
	move.w	d0,(pojoy).l
	rts
TeamIcons						;draw the visitor and home team bitmaps and set colors.
									;Called from PrintOptions. 92 TeamIcons drew name bars (dotb)
	movem.l	d0-d7/a0-a2,-(sp)
	cmpi.w	#$4,(OptPlayMode).l		;mode 4?
	beq.w	.opt
	tst.w	(OptPlayMode).l		;regular season?
	bne.w	.draw
.opt	move.w	(Opt1team).l,(HomeTeam).l		;league / exhibition setup: the menu teams play
	move.w	(Opt2team).l,(VisTeam).l		;menu team 2 is the visitors
.draw	bsr.w	printz-LOAD		;teams set: print them
	String	CC_Font1Pri,$7,$1
	move.w	(VisTeam).l,d1
	move.w	d1,d0
	asl.w	#$6,d0		;64 bytes per team
	movea.l	#TeamPalettes,a0
	move.l	$26(a0,d0.w),$BBCD6.l		;B palette colors into palette 1
	move.w	(teambitmapchars).l,d4
	bsr.w	DrawTeamBitmap
	bsr.w	printz-LOAD
	String	CC_Font1Pri,$16,$1
	move.w	(HomeTeam).l,d1
	move.w	d1,d0
	asl.w	#$6,d0		;64 bytes per team
	movea.l	#TeamPalettes,a0
	move.l	$2(a0,d0.w),$BBCD2.l		;A palette colors into palette 1
	move.w	#$EEE,$BBCDA.l		;colour 5 white
	move.w	#$2,d4		;first bitmap char
	bsr.w	DrawTeamBitmap		;draw the home team
	bsr.w	setteams-LOAD		;set up the team structs
	move.w	#$64,(palcount).l		;fade over $64 frames
	movem.l	(sp)+,d0-d7/a0-a2
	rts
DrawTeamBitmap						;dobitmap entry d1 of TeamBitmaps (d4 from the caller)
	clr.w	d0
	asl.w	#$1,d1
	movea.l	(TeamBitmaps).l,a0
	movea.l	a0,a1		;a1 = map header
	adda.l	(a0),a0		;a0 = tile data
	adda.l	$4(a1),a1		;a1 = map data
	movea.l	#null,a2
	move.w	(a1),d2
	moveq	#$2,d3
	moveq	#$0,d5
	bra.w	dobitmap-LOAD
dotb						;unreferenced. Like DrawTeamBitmap with Teamblocksmap, d4 = 2, d5 = 2
	clr.w	d0
	asl.w	#$1,d1
	movea.l	(Teamblocksmap).l,a0
	movea.l	a0,a1		;a1 = map header
	adda.l	(a0),a0		;a0 = tile data
	adda.l	$4(a1),a1		;a1 = map data
	movea.l	#null,a2		;tile data: word 0 at $310 = no tiles
	move.w	(a1),d2
	moveq	#$2,d3
	moveq	#$2,d4
	moveq	#$2,d5		;color fam 2
	bra.w	dobitmap-LOAD
ClearRosterName						;unreferenced. Set the print position, then erase 12 x 2 at it
	bsr.w	.l25040
	moveq	#$C,d0
	moveq	#$2,d1
	move.w	#$7FF,d2		;blank char
	bra.w	eraser-LOAD
.l25040	bsr.w	printz-LOAD
	String	CC_Font1Pri,$2,$A
	cmpa.l	#$1834C,a2
	bne.w	X_21000
	move.w	#$1A,(printx).l
	rts
PickStartingGoalie						;unreferenced. tmgoalie = 0 if a pad has team a2, else (gamelevel <= 2,
									;line changes on) a value from the team's .godds
	movem.l	d0/a0,-(sp)
	clr.w	$28(a2)
	bsr.w	FigureJoy		;sets cont1team / cont2team
	cmpa.l	#$1834C,a2
	seq.b	d0		;home: d0 = -1
	ext.w	d0
	addi.w	#$2,d0		;1 for the home team, 2 for the away team
	cmp.w	(cont1team).l,d0		;pad 1 on it?
	beq.w	.x		;pad 1 on this team
	cmp.w	(cont2team).l,d0		;pad 2 on it?
	beq.w	.x		;a pad has this team: leave tmgoalie(a2) = 0
	moveq	#$0,d0		;first goalie
	cmpi.w	#$2,(gamelevel).l		;past level 2?
	bgt.w	.set
	tst.w	(OptLine).l
	bne.w	.set		;line changes off
	movea.l	#TeamList,a0
	move.w	$0(a2),d0
	asl.w	#$2,d0
	movea.l	(a0,d0.w),a0		;team block
	adda.w	$A(a0),a0		;GoalieOdds offset: a0 = .godds
	moveq	#$4,d0		;4 goalie weights
	jsr	(UnpackNibbles).l
	jsr	(WeightedRandomSelect).l
.set	move.w	d0,$28(a2)		;store the pick (0 = first goalie)
.x	movem.l	(sp)+,d0/a0
	rts
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#$2,(disflags).l
	bne.w	.l250F6
	bclr	#$0,(disflags).l
	beq.w	.l250F0
	bsr.w	X_22BB4
.l250F0	jsr	$36DF6.l
.l250F6	addq.w	#$1,(ScoutSubStatus).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
DefaultMenus						;Set the default menu choices for the beginning of the game: the 9 option
									;words from defmenuoptions (93 had 7). Called once from Begin
	st.b	(demoflag).l		;no demo has run yet
	movea.l	#OptPlayMode,a0		;Start of Menu Options in RAM
	movea.l	#defmenuoptions,a1
	move.w	#$8,d0		;9 options
.loop	move.w	(a1)+,(a0)+
	dbra	d0,.loop
	rts
	ori.b	#$1,d0
	dc.w	$000B
	dc.w	$000A
	ori.b	#$0,d1
	ori.b	#$0,d1
	dc.w	$0001,$48E7
	dc.w	$FFF0
	movea.l	#passbits,a3
	bsr.w	X_2557C
	move.w	(gamelevel).l,d0
	or.w	(bosgames).l,d0
	beq.w	.l251BE
	bsr.w	MakeTree
	moveq	#$7,d0
	tst.w	(FourWayPlay).l
	beq.w	.l25164
	move.w	#$B,d0
.l25164	tst.w	(FourWayPlay).l
	bne.w	.l25186
	cmpi.w	#$2,(pojoy).l
	ble.w	.l251B2
	subi.w	#$2,(pojoy).l
	bra.w	.l251B2
.l25186	cmpi.w	#$1,(pojoy).l
	bne.w	.l2519E
	move.w	#$3,(pojoy).l
	bra.w	.l251B2
.l2519E	cmpi.w	#$2,(pojoy).l
	bne.w	.l251B2
	move.w	#$4,(pojoy).l
.l251B2	sub.w	(pojoy).l,d0
	move.w	d0,(OptNOP).l
.l251BE	movem.l	(sp)+,d0-d7/a0-a3
	rts
	moveq	#$20,d0
	jsr	(randomd0).l
	dc.w	$0640,$0001,$0240,$001F,$E940,$207C,$0001,$FFDA
	dc.w	$D0C0,$E848,$720F,$3439,$0001,$8BFE,$0C42,$0019
	dc.w	$6300,$0004,$7419,$B418,$57C9,$FFFC,$6600,$FFD2
	dc.w	$0A41,$000F,$33C1,$0001,$8AA0,$33C0,$0001,$8A9A
	dc.w	$4279,$0001,$8A9E,$33FC,$0007,$0001,$8A9C,$0C79
	dc.w	$0002,$0001,$8BFA,$6700,$0020,$4279,$0001,$8A9C
	dc.w	$7007,$207C,$0001,$8A18,$4268,$0004,$4268,$0006
	dc.w	$D0FC,$0010,$51C8,$FFF2
MakeTree						;Make the playoff tree (potree) from playoffseats and WinBits, clear the
									;scores of this round's games and set their teams
									;(.sett), then FigureJoy. Called from ContinuePlayoffs and EncodePW; falls
									;in from NewPO
	movem.l	d0-d4/a0-a3,-(sp)
	move.w	(postarts).l,d1
	asl.w	#$4,d1		;16 bytes a tree
	movea.l	#$18AA6,a0
	movea.l	#playoffseats,a1
	adda.w	d1,a1
	move.l	(a1),(a0)		;first round: 16 teams from the tree
	move.l	$4(a1),$4(a0)
	move.l	$8(a1),$8(a0)
	move.l	$C(a1),$C(a0)
	lea.l	$10(a0),a1		;a1 = next round
	moveq	#$E,d2		;15 winners
	move.w	(WinBits).l,d0
.0	move.w	d0,d1		;d1 = lowest WinBits bit: pick the pair member
	andi.w	#$1,d1		;winbit picks the top or bottom team of the pair
	move.b	(a0,d1.w),(a1)+		;winner
	adda.w	#$2,a0		;next pair
	lsr.w	#$1,d0		;next winner bit
	dbra	d2,.0
	bsr.w	GetShifter		;d1 = games, d2 = first
	tst.w	d1		;any games left?
	bmi.w	.nogames		;playoffs over
	movea.l	#$18AA6,a0
	adda.w	d2,a0
	adda.w	d2,a0		;(2 bytes a game)
	movea.l	#$18A18,a1
.loop	clr.w	$A(a1)		;gstruct: gss1
	clr.w	$C(a1)
	clr.w	$8(a1)
	bclr	#$1,$E(a1)		;hilite requested
	bsr.w	.sett
	adda.w	#$10,a1
	dbra	d1,.loop
	bsr.w	FigureJoy		;assign the pads
.nogames	movem.l	(sp)+,d0-d4/a0-a3
	rts
.sett	cmpi.w	#$2,(bosgames).l		;game 2?
	beq.w	.1		;tree order
	cmpi.w	#$3,(bosgames).l		;game 3?
	beq.w	.1		;tree order
	cmpi.w	#$5,(bosgames).l		;game 5?
	beq.w	.1		;tree order
	bset	#$0,$E(a1)		;teams are flipped
	move.b	(a0)+,$3(a1)
	move.b	(a0)+,$1(a1)
	rts
.1	bclr	#$0,$E(a1)		;gsftf: teams not flipped
	move.b	(a0)+,$1(a1)
	move.b	(a0)+,$3(a1)
	rts
FigureJoy						;Set contteams appropriately: cont1team ... cont4team (3 and 4 for
									;FourWayPlay). In the playoffs (not Shootout, gmode2 bit 0) find this
									;round's game of the po team and set the teams and pads from .pojoylist
									;(.pojoylist2 with FourWayPlay); otherwise from .noplist by OptNOP.
									;After a demo (demoflag clear), and outside the playoffs, fill gstruct
									;with random matchups (InitializeGameStructures). Called from MakeTree and
									;GameSetUp
	movem.l	d0-d3/a0-a1,-(sp)
	clr.w	(cont1team).l		;no pads assigned
	clr.w	(cont2team).l
	clr.w	(cont3team).l
	clr.w	(cont4team).l
	tst.w	(demoflag).l		;demo?
	beq.w	.init		;demo ran
	tst.w	(OptPlayMode).l
	beq.w	.l254B6		;regular season
	btst	#$0,$17F78.l
	bne.w	.l254B6
	bsr.w	GetShifter		;d1 = last game
	movea.l	#$18AA6,a0
	move.w	(potreeteam).l,d2		;user's tree position
	move.b	(a0,d2.w),d2
	movea.l	#$18A18,a1
	moveq	#$10,d4
	mulu.w	d1,d4		;times the last game
	adda.w	d4,a1		;a1 = last game
	st.b	(gamenum).l
	clr.w	d0
.f0	cmp.w	$0(a1),d2		;first team?
	beq.w	.it1
	cmp.w	$2(a1),d2		;second team?
	beq.w	.it2
	suba.w	#$10,a1		;previous game
	dbra	d1,.f0
	bra.w	.ex		;po team not in playoffs
.it2	moveq	#$4,d0		;second team layout offset
	tst.w	(FourWayPlay).l		;4-way play?
	beq.w	.it22
	move.w	#$5,d0		;4-way: 5
.it22	move.w	$0(a1),(Opt2team).l		;swap the menu teams
	move.w	$2(a1),(Opt1team).l		;user team is menu team 1
	bra.w	.itx
.it1	clr.w	d0
	move.w	$2(a1),(Opt2team).l
	move.w	$0(a1),(Opt1team).l		;user team is menu team 1
.itx	add.w	(pojoy).l,d0		;plus the pad layout
	move.w	d1,(gamenum).l
	move.w	$0(a1),(HomeTeam).l
	move.w	$2(a1),(VisTeam).l
	asl.w	#$2,d0		;4 bytes an entry
	lea.l	X_2546E(pc),a0		;pad layouts
	tst.w	(FourWayPlay).l		;4-way play?
	beq.w	.0
	lea.l	X_2548E(pc),a0		;4-way pad layouts
.0	move.w	(a0,d0.w),(cont1team).l		;pad 1 team
	move.w	$2(a0,d0.w),(cont2team).l		;pad 2 team
	tst.w	(FourWayPlay).l		;4-way play?
	beq.w	.ex
	cmpi.w	#$4,d0		;layout 1?
	beq.w	.1		;pojoy 1: cont3team / cont4team = cont1team / cont2team
	cmpi.w	#$18,d0		;layout 6?
	beq.w	.1
	bra.w	.2
.1	move.w	(cont1team).l,(cont3team).l
	move.w	(cont2team).l,(cont4team).l
	bra.w	.ex
.2	cmpi.w	#$8,d0		;layout 2?
	beq.w	.3		;pojoy 2: cont3team = cont1team, cont4team 0
	cmpi.w	#$1C,d0		;layout 7?
	beq.w	.3
	bra.w	.ex
.3	move.w	(cont1team).l,(cont3team).l		;pad 3 = pad 1
	move.w	#$0,(cont4team).l		;pad 4 unused
	bra.w	.ex
	ori.b	#$0,d1
	ori.b	#$1,d1
	ori.b	#$2,d1
	ori.b	#$1,d2
	ori.b	#$0,d2
	ori.b	#$2,d2
	ori.b	#$1,d2
	ori.b	#$2,d1
	ori.b	#$0,d1
	ori.b	#$2,d1
	ori.b	#$2,d1
	ori.b	#$1,d1
	ori.b	#$2,d1
	ori.b	#$0,d2
	ori.b	#$1,d2
	ori.b	#$1,d2
	ori.b	#$2,d2
	ori.b	#$1,d2
.l254B6	move.w	(OptNOP).l,d0
	asl.w	#$2,d0
	dc.w	$41FA,$0056
	move.w	(a0,d0.w),(cont1team).l		;pad 1 team
	move.w	$2(a0,d0.w),(cont2team).l		;pad 2 team
	cmpi.w	#$14,d0		;Three
	bne.w	.4
	move.w	(cont1team).l,(cont3team).l		;pad 3 = pad 1
	move.w	#$0,(cont4team).l		;pad 4 unused
	bra.w	.init
.4	cmpi.w	#$18,d0		;Four
	bne.w	.init
	move.w	(cont1team).l,(cont3team).l		;pad 3 = pad 1
	move.w	(cont2team).l,(cont4team).l		;pad 4 = pad 2
.init	bsr.w	X_25532
.ex	movem.l	(sp)+,d0-d3/a0-a1
	rts
InitializeGameStructures						;Random team pairs for all 8 gstruct games, none of them HomeTeam or
									;VisTeam. Called from FigureJoy
	ori.b	#$0,d0
	ori.b	#$0,d1
	ori.b	#$0,d2
	ori.b	#$1,d1
	ori.b	#$2,d1
	ori.b	#$2,d1
	ori.b	#$2,d1
	st.b	(gamenum).l
	clr.l	d3		;d3 = used team bits
	move.w	(HomeTeam).l,d1
	bset	d1,d3
	move.w	(VisTeam).l,d1
	bset	d1,d3
	movea.l	#$18A18,a1
	moveq	#$7,d2		;8 games
.loop	bsr.w	.l2556C		;both teams of game d2
	move.w	d0,$0(a1)		;gst1
	bsr.w	.l2556C
	move.w	d0,$2(a1)
	adda.w	#$10,a1
	dbra	d2,.loop
	rts
.l2556C	moveq	#$1A,d0
	jsr	(randomd0).l
	bset	d0,d3
	bne.w	.l2556C
	rts
	moveq	#$4,d0
	lea.l	$A(a3),a0
.l25582	move.w	-(a0),-(sp)
	dbra	d0,.l25582
	moveq	#$7,d2
	movea.l	#$18A88,a1
.l25590	bclr	#$2,$E(a1)
	moveq	#$5,d0
	bsr.w	SuperDiv
	move.w	d0,$6(a1)
	cmpi.w	#$4,d0
	bne.w	.l255AE
	bset	#$2,$E(a1)
.l255AE	moveq	#$5,d0
	bsr.w	SuperDiv
	move.w	d0,$4(a1)
	cmpi.w	#$4,d0
	bne.w	.l255C6
	bset	#$2,$E(a1)
.l255C6	suba.w	#$10,a1
	dbra	d2,.l25590
	move.w	#$4000,d0
	bsr.w	SuperDiv
	move.w	d0,(WinBits).l
	move.w	#$8,d0
	bsr.w	SuperDiv
	move.w	d0,(pojoy).l
	dc.w	$4A79,$0001,$8BF8,$6700,$002E,$0C79,$0001,$0001
	dc.w	$8AA2,$6600,$000E,$33FC,$0003,$0001,$8AA2,$6000
	dc.w	$0016,$0C79,$0002,$0001,$8AA2,$6600,$000A,$33FC
	dc.w	$0004,$0001,$8AA2,$7010,$6100,$01DA,$33C0,$0001
	dc.w	$8AA0,$7004,$6100,$01CE,$33C0,$0001,$8A9E,$7008
	dc.w	$6100,$01C2,$33C0,$0001,$8A9C,$7020,$6100,$01B6
	dc.w	$33C0,$0001,$8A9A,$7004,$41D3,$30DF,$51C8,$FFFC
	dc.w	$4E75
EncodePW						;After a playoff game compute winners and save the bits if needed. Returns
									;at once for Demo, Regular
									;Season and Shootout, and sets TempOptPlayMode with OptPlayMode. The bits
									;are passbits, saved through WriteLineData. Called from GameOver
	tst.w	(OptNOP).l		;no players?
	beq.w	X_21000
	tst.w	(OptPlayMode).l		;regular season?
	beq.w	X_21000
	cmpi.w	#$4,(OptPlayMode).l		;mode 4?
	beq.w	X_21000
	move.w	#$1,(OptPlayMode).l		;continue playoffs
	move.w	#$1,$18C24.l
	bsr.w	ResolveGames		;winners of all games
	bsr.w	MakeTree
	cmpi.w	#$4,(gamelevel).l
	beq.w	.0		;finished playoffs
	tst.w	(gamenum).l
	bmi.w	.0		;po team out, same as a win
	movea.l	#passbits,a3
	bsr.w	WritePassBits
	jsr	(WriteLineData).l
	btst	#$2,$17F6E.l		;alternate tree saved?
	beq.w	X_21000
	movea.l	#$18D26,a3		;bits before all games resolved
	bsr.w	X_2557C
	bra.w	MakeTree
.0	movea.l	#passbits,a3
	bsr.w	ClrPassBits
	jsr	(WriteLineData).l
	move.w	#$2,(OptPlayMode).l
	move.w	#$2,$18C24.l
	cmpi.w	#$7,(bosgames).l		;best of 7?
	beq.w	X_21000
	move.w	#$3,(OptPlayMode).l		;new playoffs best of 7
	move.w	#$3,$18C24.l
	rts
WritePassBits						;Transfer the game variables to the bits at a3 (pojoy range 8). Called
									;from EncodePW and ResolveGames
	bsr.w	ClrPassBits
	move.w	(postarts).l,d0
	moveq	#$20,d1		;32 trees
	bsr.w	PushBits
	move.w	(bosgames).l,d0
	moveq	#$8,d1		;8 values
	bsr.w	PushBits
	move.w	(gamelevel).l,d0
	moveq	#$4,d1		;4 levels
	bsr.w	PushBits
	move.w	(potreeteam).l,d0		;user tree position
	moveq	#$10,d1		;16 positions
	bsr.w	PushBits
	move.w	(pojoy).l,d0		;pad layout
	moveq	#$8,d1		;8 layouts
	bsr.w	PushBits
	move.w	(WinBits).l,d0
	move.w	#$4000,d1
	bsr.w	PushBits
	moveq	#$5,d1		;range 5
	moveq	#$7,d2		;8 games
	movea.l	#$18A18,a1
.loop	move.w	$4(a1),d0		;per game: push both win counts (range 5)
	bsr.w	PushBits
	move.w	$6(a1),d0
	bsr.w	PushBits
	adda.w	#$10,a1
	dbra	d2,.loop
	rts
PushBits						;bits = bits * d1 + d0. d1 = range 2^1-2^15, d0 = data
	movem.l	d0-d1,-(sp)
	exg.l	d0,d1
	bsr.w	SuperMult
	clr.l	d0
	move.w	d1,d0
	bsr.w	SuperAdd
	movem.l	(sp)+,d0-d1
	rts
ClrPassBits						;Clear the 5 words of bits at a3
	movea.l	a3,a0
	moveq	#$4,d0
.0	clr.w	(a0)+
	dbra	d0,.0
	rts
SuperAdd						;1 long (d0.L) added to the 5 words at a3
	movem.l	d1/a0,-(sp)
	lea.l	$A(a3),a0		;end of the words
	moveq	#$3,d1
	add.l	d0,-(a0)		;add to the lowest long
	bra.w	.2
.1	addi.w	#$1,-(a0)		;carry into the next word up
.2	dbcc	d1,.1		;loop while no carry out of the word
	movem.l	(sp)+,d1/a0
	rts
SuperMult						;1 word (d0) multiplied by the 5 words at a3
	movem.l	d1-d4/a0,-(sp)
	movea.l	a3,a0
	moveq	#$4,d4
.0	move.w	(a0),-(sp)		;stack the 5 words, clearing the buffer
	clr.w	(a0)+
	dbra	d4,.0
	moveq	#$4,d4
.1	move.w	d0,d1		;multiply a stacked word by d0, add into the buffer
	mulu.w	(sp)+,d1		;times the stacked word
	lea.l	$2(a3),a0		;its place in the buffer
	adda.w	d4,a0
	adda.w	d4,a0
	move.w	d4,d2
	add.l	d1,-(a0)
	bra.w	.3
.2	addi.w	#$1,-(a0)
.3	dbcc	d2,.2		;loop while a carry remains
	dbra	d4,.1
	movem.l	(sp)+,d1-d4/a0
	rts
SuperDiv						;5 words at a3 divided by 1 word (d0); d0 = remainder on exit
	movem.l	d1-d2/a0,-(sp)
	movea.l	a3,a0
	moveq	#$4,d1
	clr.l	d2
.0	move.w	(a0),d2		;one word: d2 = remainder:word, divide by d0
	divu.w	d0,d2
	move.w	d2,(a0)+
	dbra	d1,.0
	swap	d2
	move.w	d2,d0
	movem.l	(sp)+,d1-d2/a0
	rts
GetShifter						;Returns d1 = number of games - 1, d2 = first bit of WinBits
	move.l	d0,-(sp)
	moveq	#-16,d2
	moveq	#$10,d1		;16 games in round 1
	move.w	(gamelevel).l,d0
.3	add.w	d1,d2		;d2 = sum of the halving sizes (bit offset of the round)
	lsr.w	#$1,d1		;half the games
	dbra	d0,.3
	subi.w	#$1,d1		;games - 1
	move.l	(sp)+,d0
	rts
AddPlayoffTeamStats						;Add the po team's game stats to its packed playoff totals: unpack them
									;(ReadTeamStats) add the $68 stat bytes at team struct + $B4, then pack
									;each total back into the bit stream below outputbuffer + $DE, clamped to
									;its BitWidthTable width. Called from PeriodOver
	cmpi.w	#$1,(OptPlayMode).l
	blt.w	X_21000		;regular season
	bsr.w	ReadTeamStats		;unpack the totals
	movea.l	#$18AA6,a0
	move.w	(potreeteam).l,d2		;user tree position
	move.b	(a0,d2.w),d2
	movea.l	#tmstruct,a2
	cmp.w	$2A(a2),d2		;team number of the home team struct
	beq.w	.0
	adda.w	#$366,a2		;tmsize: the po team is the visitor
.0	adda.w	#$B6,a2		;the per-player stats
	moveq	#$67,d0		;$68 stats
	movea.l	#$B000,a1
.loop	clr.w	d1		;add stat byte to its statsbuffer word
	move.b	(a2)+,d1
	add.w	d1,(a1)+
	dbra	d0,.loop
	movea.l	#$B000,a0
	movea.l	#BitWidthTable,a1
	movea.l	#$18C42,a2
	moveq	#$67,d0		;$68 stats
	clr.w	d4		;d4 = bit position
.loop2	clr.l	d1		;one stat: d1 = total, d2 = width, d3 = max
	move.w	(a0)+,d1
	move.w	d0,d2
	andi.w	#$3,d2		;mod 4
	move.b	(a1,d2.w),d2		;d2 = bit width
	clr.l	d3
	bset	d2,d3
	subi.w	#$1,d3		;d3 = max value
	cmp.w	d3,d1
	ble.w	.1
	move.w	d3,d1
.1	not.l	d3		;rotate mask and value to bit position d4, clear field then insert
	move.w	d4,d5		;bit position
	andi.w	#$F,d5		;within the word
	rol.l	d5,d3		;mask to position
	rol.l	d5,d1		;value to position
	move.w	d4,d5		;bit position
	lsr.w	#$4,d5
	add.w	d5,d5
	neg.w	d5		;the stream runs down in words
	addi.w	#$100,d5		;from the end of the stream
	and.l	d3,-$22(a2,d5.w)		;clear the field
	or.l	d1,-$22(a2,d5.w)
	add.w	d2,d4		;next bit position
	dbra	d0,.loop2
	rts
	dc.w	$0C0E
	dc.w	$0A0A
ReadTeamStats						;Unpack the $68 playoff stat totals from the bit stream into statsbuffer
									;words. Called from AddPOStats and PlayoffStatsScreen
	movea.l	#$B000,a0
	movea.l	#BitWidthTable,a1
	movea.l	#$18C42,a2
	moveq	#$67,d0		;$68 stats
	clr.w	d4		;d4 = bit position
.loop	move.w	d4,d5		;d4 = bit position of the stat
	lsr.w	#$4,d5
	add.w	d5,d5
	neg.w	d5		;the stream runs down
	addi.w	#$100,d5		;from the end of the stream
	move.l	-$22(a2,d5.w),d1		;the long holding it
	move.w	d4,d5		;bit position
	andi.w	#$F,d5		;within the word
	lsr.l	d5,d1
	move.w	d0,d2
	andi.w	#$3,d2		;mod 4
	move.b	(a1,d2.w),d2		;d2 = bit width
	add.w	d2,d4		;next bit position
	clr.w	d3
	bset	d2,d3
	subi.w	#$1,d3
	and.w	d3,d1
	move.w	d1,(a0)+
	dbra	d0,.loop
	rts
ResolveGames						;Compute winners and losers for playoff matchups. Called from EncodePW
	move.w	(gamenum).l,d0		;game just played
	mulu.w	#$10,d0
	movea.l	#$18A18,a0
	move.w	(HmGoals).l,$A(a0,d0.w)		;copy score from played game into game structures (gss1, gss2)
	move.w	(AwGoals).l,$C(a0,d0.w)
	bsr.w	GetShifter		;d1 = games - 1
	movea.l	#$18A18,a0
	moveq	#$10,d3
	mulu.w	d1,d3		;times the last game
	adda.w	d3,a0		;a0 = last game
	cmpi.w	#$7,(bosgames).l
	beq.w	.notbos		;not best of 7
.loop	cmpi.w	#$4,$4(a0)		;series complete? (gspotwins)
	beq.w	.b1
	cmpi.w	#$4,$6(a0)
	beq.w	.b1
	clr.w	d3		;d3 = gspotwins
	btst	#$0,$E(a0)
	beq.w	.0
	eori.w	#$2,d3
.0	move.w	$A(a0),d0
	sub.w	$C(a0),d0
	bpl.w	.win
	eori.w	#$2,d3
.win	addi.w	#$1,$4(a0,d3.w)
.b1	suba.w	#$10,a0		;previous game
	dbra	d1,.loop
	addi.w	#$1,(bosgames).l		;next series game
	cmpi.w	#$7,(bosgames).l		;series over?
	beq.w	.nextround
	move.w	(gamenum).l,d0		;game just played
	mulu.w	#$10,d0
	movea.l	#$18A18,a0
	adda.w	d0,a0		;a0 = that game
	cmpi.w	#$4,$4(a0)
	beq.w	.cround		;series won
	cmpi.w	#$4,$6(a0)
	bne.w	X_21000		;series goes on
.cround	cmpi.w	#$3,(gamelevel).l		;finish off rest of round games here
	bge.w	.nextround
	bsr.w	GetShifter		;d1 = games - 1
	movea.l	#$18A18,a0
	moveq	#$10,d3
	mulu.w	d1,d3		;times the last game
	adda.w	d3,a0		;a0 = last game
.cr0	cmp.w	(gamenum).l,d1		;skip the game just played
	beq.w	.crn
	cmpi.w	#$4,$4(a0)		;won?
	beq.w	.crn
	cmpi.w	#$4,$6(a0)		;lost?
	beq.w	.crn
	addi.w	#$1,$4(a0)		;give team 1 a win
	move.l	#$C8,d0
	jsr	(randomd0).l
	andi.w	#$1,d0		;odd or even
	beq.w	.cr0		;team 1 keeps it
	subi.w	#$1,$4(a0)		;take it back
	addi.w	#$1,$6(a0)
	bra.w	.cr0
.crn	suba.w	#$10,a0		;previous game
	dbra	d1,.cr0
	movea.l	#$18D26,a3		;bits before advancing to next round
	bsr.w	WritePassBits
	bset	#$2,$17F6E.l		;alternate tree saved
.nextround	clr.w	(bosgames).l		;advance to next round
	bsr.w	GetShifter		;d1 = games - 1, d2 = first bit
	movea.l	#$18A18,a0
	moveq	#$10,d3
	mulu.w	d1,d3		;times the last game
	adda.w	d3,a0		;a0 = last game
	clr.w	d3
.loop2	cmpi.w	#$4,$4(a0)
	beq.w	.2
	bset	d1,d3
.2	clr.w	$4(a0)		;reset win counts for the next round
	clr.w	$6(a0)
	suba.w	#$10,a0		;previous game
	dbra	d1,.loop2
	moveq	#$1,d1		;this round's
	asl.w	d2,d1
	subi.w	#$1,d1
	and.w	d1,(WinBits).l		;clear this round's winbits
	asl.w	d2,d3
	or.w	d3,(WinBits).l
	addi.w	#$1,(gamelevel).l		;next round
	rts
.notbos	clr.w	d3		;solve for no best of 7 playoffs (much simpler)
.loop3	move.w	$A(a0),d0
	cmp.w	$C(a0),d0
	bhi.w	.3
	bset	d1,d3
.3	btst	#$0,$E(a0)
	beq.w	.nb2
	bchg	d1,d3		;flip the winner
.nb2	suba.w	#$10,a0		;previous game
	dbra	d1,.loop3
	moveq	#$1,d1		;this round's
	asl.w	d2,d1
	subi.w	#$1,d1
	and.w	d1,(WinBits).l
	asl.w	d2,d3
	or.w	d3,(WinBits).l
	addi.w	#$1,(gamelevel).l		;next round
	rts
ShowThreeStars						;End of game Stars of the Game box. Called from UpdatePA while RefPen is
									;the game over penalty. Waits for RefCnt <= $40 and runs once (gmode bit
									;7), then sets disflags bit 3 and waits a vblank. Frames the box, draws a
									;bitmap from Rinktilelist, then the three best star scores
									;(TakeTopStarScore): team abbreviation and getname. Song $F when the home
									;team won
	cmpi.w	#$40,(RefCnt).l
	bgt.w	X_21000		;ref animation not far enough yet
	bset	#$7,$17F68.l
	bne.w	X_21000		;already shown
	movem.l	d0/a1,-(sp)
	bset	#$3,(disflags).l		;clock display off
	move.w	(ScoutSubStatus).l,d0		;current frame
.loop2	cmp.w	(ScoutSubStatus).l,d0		;wait for the next vblank
	beq.w	.loop2
	movem.l	(sp)+,d0/a1
	movem.l	d0-d5/a0-a4,-(sp)
	jsr	(printz).l
	String	CC_Font1Pri,$2,$E
	dc.w	$701C,$7209,$4EB9,$0003,$8CA0,$4EB9,$0003,$8F6E
	dc.w	$001A,$BF09,$1053,$7461,$7273,$206F,$6620,$7468
	dc.w	$6520,$4761,$6D65,$BF03,$0F00,$2279,$0004,$7D18
	dc.w	$247C,$0001,$B008,$D3E9,$0004,$700D,$725B,$7406
	dc.w	$7604,$3839,$0001,$8D48,$4245,$4EB9,$0003,$87E2
	dc.w	$6100,$00AC,$33FC,$0012,$0001,$8D5A,$7402,$6100
	dc.w	$0058,$33FC,$001A,$0001,$8D58,$0679,$0001,$0001
	dc.w	$8D5A,$226A,$001E,$D2E9,$0004,$D2D1,$4EB9,$0003
	dc.w	$8F80,$6100,$0568,$33FC,$0003,$0001,$8D58,$4EB9
	dc.w	$0003,$8F80,$51CA,$FFC8,$3039,$0001,$8358,$9079
	dc.w	$0001,$86BE,$6F00,$000C,$3F3C,$000F,$4EB9,$0003
	dc.w	$710C,$4CDF,$1F3F,$4E75
TakeTopStarScore						;Take the highest of the 52 star scores at ThreeStars and clear it.
									;Returns d0 = player slot, a2 = its team struct. Called from
									;ShowThreeStars
	movem.l	d1-d2/a1/a4,-(sp)
	movea.l	#ThreeStars,a4
	clr.l	d0		;best so far 0
	moveq	#$33,d2
.find	cmp.l	(a4)+,d0		;scan for the highest score
	bge.w	.l25C14
	lea.l	-$4(a4),a1		;a1 = best entry
	move.l	(a1),d0
.l25C14	dbra	d2,.find
	clr.l	(a1)
	move.l	a1,d0
	subi.l	#$BC000,d0
	lsr.w	#$2,d0
	movea.l	#tmstruct,a2
	cmpi.w	#$1A,d0		;home slot?
	blt.w	.home
	subi.w	#$1A,d0
	adda.w	#$366,a2		;second team roster block (tmsize)
.home	movem.l	(sp)+,d1-d2/a1/a4
	rts
CalcStarScores						;Star score for every roster slot of both teams to ThreeStars (26 longs
									;per team, home first). d5 =
									;GetPeriodTime + d2, the goalie ice time needed. If gsp is 3 and the score
									;is not tied, the scorer of the last goal gets $7FFFFFFF. Called from
									;ShowThreeStars
	movea.l	#ThreeStars,a4
	jsr	(GetPeriodTime).l		;d0 = period time
	move.w	d0,d5		;d5 = period time + d2
	add.w	d2,d5
	movea.l	#tmstruct,a2
	lea.l	$366(a2),a3		;a3 = other team
	bsr.w	CalcTeamStarScores-LOAD
	movea.l	a3,a2
	lea.l	-$366(a2),a3		;a3 = home team
	bsr.w	CalcTeamStarScores-LOAD		;away (d3 = away - home score)
	cmpi.w	#$3,$180E4.l		;overtime?
	bne.w	.x
	tst.w	d3
	beq.w	.x
	movea.l	#ScoreSum,a0		;+ ScoreSumbytes = last goal entry
	adda.w	(ScoreSumbytes).l,a0
	clr.w	d0
	btst	#$7,$2(a0)
	beq.w	.slot
	addi.w	#$1A,d0		;away goal: second RosterSlots entries
.slot	add.b	$3(a0),d0
	asl.w	#$2,d0
	movea.l	#ThreeStars,a0
	move.l	#$7FFFFFFF,(a0,d0.w)		;game winner is the first star
.x	rts
