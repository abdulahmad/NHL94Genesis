;	HOCKEY.BIN $24DE8-$2654B (runtime $3FDE8-$4154B): setup94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	Part 3 of setup94, after src/segacd/scoutload.asm and cdstart.asm ($24C12-$24DE7): menus and
;	the playoff data. $2654C-$265CB after it is src/segacd/crowdtable.asm (the start of tables94).

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

null	equ	$1B008
TeamList	equ	$1B00C
playoffseats	equ	$1FFDA
TeamPalettes	equ	$25060
CountGoalies	equ	$25D8C
ShootoutModeBox	equ	$27860
StartArenaAnim	equ	$2A41E
WriteLineData	equ	$2A5C8
PrintPlayerAssists	equ	$2AA6A
PrintPlayerGoals	equ	$2AA80
GetPeriodTime	equ	$2BA04
GetGoalieCount	equ	$2ED60
lcfound_close	equ	$30D9C
p_music_vblank	equ	$36DF6
randomd0	equ	$37050
song	equ	$3710C
dobitmap	equ	$387E2
eraser	equ	$38C06
printz	equ	$38F6E
print	equ	$38F80
prefmes	equ	$39D96
rtss2	equ	$3C000
vb2	equ	$3DB90
DumpSprites2	equ	$3DBB4
setteams	equ	$3F1BC
Penaltylist	equ	$4165C
UnpackNibbles	equ	$36BB2
WeightedRandomSelect	equ	$36BE2
forceblack	equ	$36D0A
ProcessInputWithRepeat	equ	$374BE
ReadJoy1	equ	$374F0
Framer	equ	$38CA0
printsmallz	equ	$38D8C
PushNumberWidth	equ	$3919A
appendz	equ	$39200
appstring	equ	$39208
printbigz	equ	$39258
printbig	equ	$3926A
X_3FC0C	equ	$3FC0C

	org	$3FDE8

;CD: no cartridge twin
	move.w	#$1,$3FC0A.l
	bsr.w	X_3FC0C

EASportsScreen						;Called from Begin. Show the EA Sports screen until a button, or $50 x 4
									;frames (about 5 s)
	move.l	#vb2,(VBint).l			;vblank handler
	bclr.b	#df32c,(disflags).l		;32 cell flag off
	move.w	#5,(Map3col).l
	move.w	#$A000,(VmMAP2).l
	move.w	#7,(Map2col).l
	move.w	#$C000,(VmMAP1).l
	move.w	#7,(Map1col).l
	move.w	#$F000,(VmMAP3).l
	move.w	#$F800,(VSPRITES).l
	move.w	#$FC00,$18D30.l			;CD: the cartridge has (VSCRLPM).w
	movea.l	#$BBCB0,a0				;CD: the cartridge has #(palfadenew-M68K_RAM)
	moveq	#$1F,d1					;32 longs: all 64 colours black
.clr	clr.l	(a0)+
	dbf	d1,.clr						;loop
;CD: no cartridge twin
	jsr	$36F72.l
	jsr	$37B74.l
	rts
	jsr	(ReadJoy1).l
	cmpi.b	#$E0,d3
	bne.w	rtss2
	bset.b	#$5,$FF800F.l
	move.l	#vb2,(VBint).l
	jsr	$47DAC.l
	jsr	(forceblack).l
	move.w	#$18,(palcount).l
	bsr.w	printsmallz
	dc.w	$0012,$F804
	movep.w	$143(a4),d1
	dc.b	'heck Sound|'
	dc.b	$14
.L3FEAE
	move.w	(Vcount).l,d0
.L3FEB4
	cmp.w	(Vcount).l,d0
	beq.w	.L3FEB4
	jsr	(ReadJoy1).l
	jsr	(ProcessInputWithRepeat).l
	tst.b	d1
	beq.w	.L3FEAE
	btst	#$7,d1
	bne.w	rtss2
	btst	#$3,d1
	beq.w	.L3FEE4
	addi.w	#$1,d6
.L3FEE4
	btst	#$2,d1
	beq.w	.L3FEF0
	subi.w	#$1,d6
.L3FEF0
	btst	#$5,d1
	beq.w	.L3FEFE
	jsr	$3710C.l
.L3FEFE
	move.w	d6,d0
	moveq	#$3,d1
	bsr.w	PushNumberWidth
	move.w	#$17,(printx).l
	bsr.w	print
	bra.w	.L3FEAE

UpdatePlayoffLevel					;Set pojoy from the number of players for play modes 2 and 3.
	cmpi.w	#2,(OptPlayMode).l		;playoff mode?
	blt.w	rtss2
	cmpi.w	#4,(OptPlayMode).l		;mode 4?
	beq.w	rtss2
	moveq	#7,d0					;8 pad layouts
	tst.w	(FourWayPlay).l			;4-way play?
	beq.w	.set
	move.w	#$B,d0					;4 way play
.set	sub.w	(OptNOP).l,d0		;pojoy = pad layouts minus the player count option
	move.w	d0,(pojoy).l
	rts

TeamIcons							;draw the visitor and home team bitmaps and set colors.
									;Called from PrintOptions. 92 TeamIcons drew name bars (dotb)
	movem.l	d0-d7/a0-a2,-(sp)
	cmpi.w	#4,(OptPlayMode).l		;mode 4?
	beq.w	.opt
	tst.w	(OptPlayMode).l			;regular season?
	bne.w	.draw
.opt	move.w	(Opt1team).l,(HomeTeam).l	;league / exhibition setup: the menu teams play
	move.w	(Opt2team).l,(VisTeam).l	;menu team 2 is the visitors
.draw	bsr.w	printz				;teams set: print them
	String	CC_Font1Pri,7,1,0
	move.w	(VisTeam).l,d1
	move.w	d1,d0
	asl.w	#6,d0					;64 bytes per team
	movea.l	#TeamPalettes,a0
	move.l	$26(a0,d0.w),(palfadenew+$26).l	;B palette colors into palette 1
	move.w	(teambitmapchars).l,d4
	bsr.w	DrawTeamBitmap
	bsr.w	printz
	String	CC_Font1Pri,$16,1,0
	move.w	(HomeTeam).l,d1
	move.w	d1,d0
	asl.w	#6,d0					;64 bytes per team
	movea.l	#TeamPalettes,a0
	move.l	$2(a0,d0.w),(palfadenew+$22).l	;A palette colors into palette 1
	move.w	#$EEE,(palfadenew+$2A).l	;colour 5 white
	move.w	#2,d4					;first bitmap char
	bsr.w	DrawTeamBitmap			;draw the home team
	bsr.w	setteams				;set up the team structs
	move.w	#$64,(palcount).l		;fade over $64 frames
	movem.l	(sp)+,d0-d7/a0-a2
	rts

DrawTeamBitmap						;dobitmap entry d1 of TeamBitmaps (d4 from the caller)
	clr.w	d0
	asl.w	#1,d1
;CD: no cartridge twin
	movea.l	(TeamBitmapsPtr).l,a0
	movea.l	a0,a1					;a1 = map header
	adda.l	(a0),a0					;a0 = tile data
	adda.l	jimdata(a1),a1			;a1 = map data
	movea.l	#null,a2
	move.w	(a1),d2
	moveq	#2,d3
	moveq	#0,d5
	bra.w	dobitmap

dotb								;unreferenced. Like DrawTeamBitmap with Teamblocksmap, d4 = 2, d5 = 2
	clr.w	d0
	asl.w	#1,d1
;CD: no cartridge twin
	movea.l	(TeamblocksmapPtr).l,a0
	movea.l	a0,a1					;a1 = map header
	adda.l	(a0),a0					;a0 = tile data
	adda.l	jimdata(a1),a1			;a1 = map data
	movea.l	#null,a2				;tile data: word 0 at $310 = no tiles
	move.w	(a1),d2
	moveq	#2,d3
	moveq	#2,d4
	moveq	#2,d5					;color fam 2
	bra.w	dobitmap

ClearRosterName						;unreferenced. Set the print position, then erase 12 x 2 at it
	bsr.w	setoptions_printpos2
	moveq	#$C,d0
	moveq	#2,d1
	move.w	#$7FF,d2				;blank char
	bra.w	eraser

setoptions_printpos2				;printz position string, then printx = $1A when a2 is the home team
	bsr.w	printz
	String	CC_Font1Pri,2,$A,0
	cmpa.l	#$1834C,a2				;home team struct? (CD: the cartridge has #(tmstruct-M68K_RAM))
	bne.w	rtss2
	move.w	#$1A,(printx).l
	rts

PickStartingGoalie					;unreferenced. tmgoalie = 0 if a pad has team a2, else (gamelevel <= 2,
									;line changes on) a value from the team's .godds
	movem.l	d0/a0,-(sp)
	clr.w	tmgoalie(a2)
	bsr.w	FigureJoy				;sets cont1team / cont2team
	cmpa.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
	seq.b	d0						;home: d0 = -1
	ext.w	d0
	addi.w	#2,d0					;1 for the home team, 2 for the away team
	cmp.w	(cont1team).l,d0		;pad 1 on it?
	beq.w	.x						;pad 1 on this team
	cmp.w	(cont2team).l,d0		;pad 2 on it?
	beq.w	.x						;a pad has this team: leave tmgoalie(a2) = 0
	moveq	#0,d0					;first goalie
	cmpi.w	#2,(gamelevel).l		;past level 2?
	bgt.w	.set
	tst.w	(OptLine).l
	bne.w	.set					;line changes off
	movea.l	#TeamList,a0
	move.w	0(a2),d0
	asl.w	#2,d0
	movea.l	(a0,d0.w),a0			;team block
	adda.w	GoalieOdds(a0),a0		;GoalieOdds offset: a0 = .godds
	moveq	#4,d0					;4 goalie weights
;CD: no cartridge twin
	jsr	(UnpackNibbles).l
	jsr	(WeightedRandomSelect).l
.set								;CD: placed where the disc branches to it
	move.w	d0,$28(a2)
.x	movem.l	(sp)+,d0/a0
	rts

VBlank_SetOptions					;VBint handler stored by setoptions: cramfade unless dfng), plus
									;DumpSprites2 when dfok is set
	movem.l	d0-d7/a0-a6,-(sp)
	btst.b	#dfng,(disflags).l
	bne.w	.nograph
	bclr.b	#dfok,(disflags).l
	beq.w	.fade					;no sprites to send
	bsr.w	DumpSprites2
.fade								;CD: placed where the disc branches to it
	jsr	(p_music_vblank).l
;CD: no cartridge twin
.nograph							;CD: placed where the disc branches to it
	addq.w	#$1,(Vcount).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp /
;	cmpi; fixopcodes.js patches the cmp encoding after assembly.

;RAM: potree, WinBits, pojoy, statsbuffer
;tpassbits. gstruct game (gssize bytes): gst1, gst2, gspotwins, gspobwins, gsper, gss1, gss2, gsflags
;(gsflags bits 0 gsftf teams flipped, 1 gsfhl hilite, 2 gsfso series over).

DefaultMenus						;Set the default menu choices for the beginning of the game: the 9 option
									;words from defmenuoptions (93 had 7). Called once from Begin
	st.b	(demoflag).l			;no demo has run yet
	movea.l	#OptPlayMode,a0			;Start of Menu Options in RAM
	movea.l	#defmenuoptions,a1
	move.w	#8,d0					;9 options
.loop								;copy each option
	move.w	(a1)+,(a0)+
	dbf	d0,.loop					;loop
	rts
defmenuoptions						;default options: Regular Season, One - Home, MTL, LA, 10 Minutes, Manual
									;Control, User Records Off, Penalties Off
									;Line Changes Off
	dc.w	0						;Play Mode
	dc.w	1						;Players
	dc.w	$B						;Team 1
	dc.w	$A						;Team 2
	dc.w	1						;Per Length
	dc.w	0						;Goalies
	dc.w	1						;User Records
	dc.w	0						;Penalties
	dc.w	1						;Line Changes
ContinuePlayoffs					;Continue playoffs:
									;read the playoff state back from the saved bits at passbits, rebuild
									;the tree and set OptNOP from pojoy ( = 7 - OptNOP; 7 or $B with
									;FourWayPlay, pojoy adjusted to the pad set-ups). Called
									;(GoContinuePlayoffs, ChangeOption)
	movem.l	d0-d7/a0-a3,-(sp)
	movea.l	#$18C38,a3				;CD: the cartridge has #(passbits-M68K_RAM)
	bsr.w	ReadPassBits
	move.w	(gamelevel).l,d0
	or.w	(bosgames).l,d0
	beq.w	.x						;level 0, game 0: nothing played yet
	bsr.w	MakeTree
	moveq	#7,d0					;8 pad layouts
	tst.w	(FourWayPlay).l			;4-way play?
	beq.w	.0
	move.w	#$B,d0					;12 with the adaptor
.0									;pad layouts: 8, or $C with the adaptor
	tst.w	(FourWayPlay).l			;4-way play?
	bne.w	.1
	cmpi.w	#2,(pojoy).l			;layout 2 or more?
;CD: no cartridge twin
	ble.w	.set
	subi.w	#2,(pojoy).l
	bra.w	.set
.1									;FourWayPlay <> 0
	cmpi.w	#1,(pojoy).l			;layout 1?
	bne.w	.2
	move.w	#3,(pojoy).l			;becomes 3
	bra.w	.set
.2									;pojoy <> 1
	cmpi.w	#2,(pojoy).l			;layout 2?
	bne.w	.set
	move.w	#4,(pojoy).l			;becomes 4
.set								;pojoy set
	sub.w	(pojoy).l,d0
	move.w	d0,(OptNOP).l
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a3
	rts
NewPO								;New playoff generates tree with same team 1. Called from GoNewPlayoffs.
									;Falls into MakeTree
	moveq	#PlayoffRows,d0
;CD: no cartridge twin
	jsr	(randomd0).l
.top								;loop
	addi.w	#1,d0					;adds 1 to d0 (d0 cannot be 0)
	andi.w	#PlayoffRows-1,d0		;row index, 0 through 31
	asl.w	#4,d0					;row length is PlayoffRowTeams bytes
	movea.l	#playoffseats,a0
	adda.w	d0,a0					;use d0 as offset
	lsr.w	#4,d0					;back to the row index
	moveq	#PlayoffRowTeams-1,d1	;16 teams a row
	move.w	(Opt1team).l,d2			;Team 1 on menu
	cmpi.w	#NumPlayoffTeams-1,d2	;last playoff team; all-stars clamp to it
	bls.w	.loop
	moveq	#NumPlayoffTeams-1,d2
.loop								;team clamped to the playoff teams: find it in the tree
	cmp.b	(a0)+,d2				;compare team at a0+ to d2 (looks at second byte of a0)
	dbeq	d1,.loop				;iterate through loop until team is found
	bne.w	.top					;not in this tree, try the next one
	eori.w	#PlayoffRowTeams-1,d1
	move.w	d1,(potreeteam).l		;which team are you on the initial playoff tree
	move.w	d0,(postarts).l			;0-31 for which playoff tree to use as frame
	clr.w	(gamelevel).l			;0-3 for the depth into the playoff tree
	move.w	#7,(bosgames).l			;0-6 game of series or 7 if not in best of seven
	cmpi.w	#2,(OptPlayMode).l		;play mode on Main Menu
	beq.w	MakeTree				;jump to make playoff tree if play mode is 2
	clr.w	(bosgames).l			;best of seven: game 0
	moveq	#7,d0					;clr games won
	movea.l	#(gstruct-M68K_RAM),a0	;Game struct variables start
.cg									;clear each series
	clr.w	gspotwins(a0)
	clr.w	gspobwins(a0)
	adda.w	#gssize,a0
	dbf	d0,.cg						;falls into MakeTree
MakeTree							;Make the playoff tree (potree) from playoffseats and WinBits, clear the
									;scores of this round's games and set their teams
									;(.sett), then FigureJoy. Called from ContinuePlayoffs and EncodePW; falls
									;in from NewPO
	movem.l	d0-d4/a0-a3,-(sp)
	move.w	(postarts).l,d1
	asl.w	#4,d1					;16 bytes a tree
	movea.l	#(potree-M68K_RAM),a0
	movea.l	#playoffseats,a1
	adda.w	d1,a1
	move.l	(a1),(a0)				;first round: 16 teams from the tree
	move.l	4(a1),4(a0)
	move.l	8(a1),8(a0)
	move.l	$C(a1),$C(a0)
	lea	$10(a0),a1					;a1 = next round
	moveq	#$E,d2					;15 winners
	move.w	(WinBits).l,d0
.0									;each winner
	move.w	d0,d1					;d1 = lowest WinBits bit: pick the pair member
	andi.w	#1,d1					;winbit picks the top or bottom team of the pair
	move.b	(a0,d1.w),(a1)+			;winner
;CD: no cartridge twin
	adda.w	#$2,a0
	lsr.w	#1,d0					;next winner bit
	dbf	d2,.0						;loop
	bsr.w	GetShifter				;d1 = games, d2 = first
	tst.w	d1						;any games left?
	bmi.w	.nogames				;playoffs over
	movea.l	#(potree-M68K_RAM),a0
	adda.w	d2,a0
	adda.w	d2,a0					;(2 bytes a game)
	movea.l	#(gstruct-M68K_RAM),a1
.loop								;each first round game
	clr.w	gss1(a1)				;gstruct: gss1
	clr.w	gss2(a1)
	clr.w	gsper(a1)
	bclr.b	#gsfhl,gsflags(a1)		;hilite requested
	bsr.w	.sett
	adda.w	#gssize,a1
	dbf	d1,.loop					;loop
	bsr.w	FigureJoy				;assign the pads
.nogames							;exit: restore the registers
	movem.l	(sp)+,d0-d4/a0-a3
	rts
.sett								;series games 2, 3, 5: tree order, others swapped
	cmpi.w	#2,(bosgames).l			;game 2?
	beq.w	.1						;tree order
	cmpi.w	#3,(bosgames).l			;game 3?
	beq.w	.1						;tree order
	cmpi.w	#5,(bosgames).l			;game 5?
	beq.w	.1						;tree order
	bset.b	#gsftf,gsflags(a1)		;teams are flipped
	move.b	(a0)+,gst2+1(a1)
	move.b	(a0)+,gst1+1(a1)
	rts
.1									;teams in tree order
	bclr.b	#gsftf,gsflags(a1)		;gsftf: teams not flipped
	move.b	(a0)+,gst1+1(a1)
	move.b	(a0)+,gst2+1(a1)
	rts
FigureJoy							;Set contteams appropriately: cont1team ... cont4team (3 and 4 for
									;FourWayPlay). In the playoffs (not Shootout, gmode2 bit 0) find this
									;round's game of the po team and set the teams and pads from .pojoylist
									;(.pojoylist2 with FourWayPlay); otherwise from .noplist by OptNOP.
									;After a demo (demoflag clear), and outside the playoffs, fill gstruct
									;with random matchups (InitializeGameStructures). Called from MakeTree and
									;GameSetUp
	movem.l	d0-d3/a0-a1,-(sp)
	clr.w	(cont1team).l			;no pads assigned
	clr.w	(cont2team).l
	clr.w	(cont3team).l
	clr.w	(cont4team).l
	tst.w	(demoflag).l			;demo?
	beq.w	.init					;demo ran
	tst.w	(OptPlayMode).l
	beq.w	.fjnpo					;regular season
	btst.b	#0,(gmode2).l
	bne.w	.fjnpo
	bsr.w	GetShifter				;d1 = last game
	movea.l	#(potree-M68K_RAM),a0
	move.w	(potreeteam).l,d2		;user's tree position
	move.b	(a0,d2.w),d2
	movea.l	#(gstruct-M68K_RAM),a1
	moveq	#gssize,d4
	mulu.w	d1,d4					;times the last game
	adda.w	d4,a1					;a1 = last game
	st.b	(gamenum).l
	clr.w	d0
.f0									;find the game of the playoff team
	cmp.w	0(a1),d2				;first team?
	beq.w	.it1
	cmp.w	gst2(a1),d2				;second team?
	beq.w	.it2
	suba.w	#gssize,a1				;previous game
	dbf	d1,.f0						;loop
	bra.w	.ex						;po team not in playoffs
.it2								;user team is the second one
	moveq	#4,d0					;second team layout offset
	tst.w	(FourWayPlay).l			;4-way play?
	beq.w	.it22
	move.w	#5,d0					;4-way: 5
.it22								;pad layout offset set
	move.w	0(a1),(Opt2team).l		;swap the menu teams
	move.w	gst2(a1),(Opt1team).l	;user team is menu team 1
	bra.w	.itx
.it1								;d2 = a1
	clr.w	d0
	move.w	gst2(a1),(Opt2team).l
	move.w	0(a1),(Opt1team).l		;user team is menu team 1
.itx								;both: pad layout from the table
	add.w	(pojoy).l,d0			;plus the pad layout
	move.w	d1,(gamenum).l
	move.w	0(a1),(HomeTeam).l
	move.w	gst2(a1),(VisTeam).l
	asl.w	#2,d0					;4 bytes an entry
	lea	.pojoylist(pc),a0			;pad layouts
	tst.w	(FourWayPlay).l			;4-way play?
	beq.w	.0
	lea	.pojoylist2(pc),a0			;4-way pad layouts
.0									;table chosen
	move.w	(a0,d0.w),(cont1team).l	;pad 1 team
	move.w	$2(a0,d0.w),(cont2team).l	;pad 2 team
	tst.w	(FourWayPlay).l			;4-way play?
	beq.w	.ex
	cmpi.w	#4,d0					;layout 1?
	beq.w	.1						;pojoy 1: cont3team / cont4team = cont1team / cont2team
	cmpi.w	#$18,d0					;layout 6?
	beq.w	.1
	bra.w	.2
.1									;d0 = 4 or d0 = $18
	move.w	(cont1team).l,(cont3team).l
	move.w	(cont2team).l,(cont4team).l
	bra.w	.ex
.2									;pad 3 / 4 setups
	cmpi.w	#8,d0					;layout 2?
	beq.w	.3						;pojoy 2: cont3team = cont1team, cont4team 0
	cmpi.w	#$1C,d0					;layout 7?
	beq.w	.3
	bra.w	.ex
.3									;d0 = 8 or d0 = $1C
	move.w	(cont1team).l,(cont3team).l	;pad 3 = pad 1
	move.w	#0,(cont4team).l		;pad 4 unused
	bra.w	.ex
.pojoylist							;cont1team, cont2team for pojoy 0-3 with the po team as team 1, then as
									;team 2
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
.pojoylist2							;The same with FourWayPlay, pojoy 0-4
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
.fjnpo								;not playoffs
	move.w	(OptNOP).l,d0
	asl.w	#2,d0					;4 bytes an entry
	lea	.noplist(pc),a0				;pad layouts
	move.w	(a0,d0.w),(cont1team).l	;pad 1 team
	move.w	$2(a0,d0.w),(cont2team).l	;pad 2 team
	cmpi.w	#$14,d0					;Three
	bne.w	.4
	move.w	(cont1team).l,(cont3team).l	;pad 3 = pad 1
	move.w	#0,(cont4team).l		;pad 4 unused
	bra.w	.init
.4									;d0 <> $14
	cmpi.w	#$18,d0					;Four
	bne.w	.init
	move.w	(cont1team).l,(cont3team).l	;pad 3 = pad 1
	move.w	(cont2team).l,(cont4team).l	;pad 4 = pad 2
.init								;pads set: set up the game
	bsr.w	InitializeGameStructures
.ex									;exit: restore the registers
	movem.l	(sp)+,d0-d3/a0-a1
	rts
.noplist	dc.w	0				;cont1team, cont2team by OptNOP 0-6
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
InitializeGameStructures			;Random team pairs for all 8 gstruct games, none of them HomeTeam or
									;VisTeam. Called from FigureJoy
	st.b	(gamenum).l
	clr.l	d3						;d3 = used team bits
	move.w	(HomeTeam).l,d1
	bset	d1,d3
	move.w	(VisTeam).l,d1
	bset	d1,d3
	movea.l	#(gstruct-M68K_RAM),a1
	moveq	#7,d2					;8 games
.loop								;two random teams for each game
	bsr.w	GetRandomUnusedTeam		;both teams of game d2
	move.w	d0,0(a1)				;gst1
	bsr.w	GetRandomUnusedTeam
	move.w	d0,gst2(a1)
	adda.w	#gssize,a1
	dbf	d2,.loop					;loop
	rts
GetRandomUnusedTeam					;return d0 = a random playoff team not yet set in d3, and set its bit. d3
									;holds one bit per team, so this stops working past 32 playoff teams.
									;Called from InitializeGameStructures
	moveq	#NumPlayoffTeams,d0
;CD: no cartridge twin
	jsr	(randomd0).l
	bset	d0,d3					;mark it used
	bne.w	GetRandomUnusedTeam		;already used, pick again
	rts
ReadPassBits						;Translate the saved bits at a3 (5 words) to the playoff variables; the 5
									;words are kept. pojoy has 8 values (93 had 4),
									;and without FourWayPlay pojoy 1 / 2 become 4. Called from
									;ContinuePlayoffs and EncodePW and GameSetUp
	moveq	#4,d0
	lea	$A(a3),a0					;end of the words
.save								;keep the 5 bit words
	move.w	-(a0),-(sp)				;SuperDiv destroys the bits
	dbf	d0,.save					;loop
	moveq	#7,d2					;set gspobwins/gspotwins
	movea.l	#(gstruct+(7*$10)-M68K_RAM),a1	;last gstruct game (gstruct + 7 * $10)
.loop								;each series: decode both win counts
	bclr.b	#gsfso,gsflags(a1)		;series over
	moveq	#5,d0
	bsr.w	SuperDiv				;d0 = next digit
	move.w	d0,gspobwins(a1)
	cmpi.w	#4,d0					;valid count?
	bne.w	.nsf0
	bset.b	#gsfso,gsflags(a1)
.nsf0								;series over at 4 wins
	moveq	#5,d0					;second variable: gspotwins
	bsr.w	SuperDiv
	move.w	d0,gspotwins(a1)
	cmpi.w	#4,d0					;4 wins?
	bne.w	.nsf1
	bset.b	#gsfso,gsflags(a1)
.nsf1								;series over at 4 wins
	suba.w	#gssize,a1				;previous game
	dbf	d2,.loop					;loop
	move.w	#$4000,d0				;$4000 combinations
	bsr.w	SuperDiv
	move.w	d0,(WinBits).l
	move.w	#8,d0					;8 layouts
	bsr.w	SuperDiv
	move.w	d0,(pojoy).l
	tst.w	(FourWayPlay).l			;4-way play?
	beq.w	.1						;CD: the cartridge has .0
;CD: no cartridge twin
	cmpi.w	#$1,(pojoy).l
	bne.w	.L4060C
	move.w	#$3,(pojoy).l
	bra.w	.1
.L4060C
	cmpi.w	#2,(pojoy).l			;layout 2?
	bne.w	.1
.0									;without the adaptor pojoy 1 or 2 becomes 4
	move.w	#4,(pojoy).l
.1									;pojoy fixed
	moveq	#$10,d0					;set POTreeTeam
	bsr.w	SuperDiv
	move.w	d0,(potreeteam).l
	moveq	#4,d0					;set gamelevel
	bsr.w	SuperDiv
	move.w	d0,(gamelevel).l
	moveq	#8,d0					;set bosgames
	bsr.w	SuperDiv
	move.w	d0,(bosgames).l
	moveq	#$20,d0					;set PoStarts
	bsr.w	SuperDiv
	move.w	d0,(postarts).l
	moveq	#4,d0
	lea	(a3),a0
.restore							;put the bits back
	move.w	(sp)+,(a0)+				;put the bits back
	dbf	d0,.restore					;loop
	rts
EncodePW							;After a playoff game compute winners and save the bits if needed. Returns
									;at once for Demo, Regular
									;Season and Shootout, and sets TempOptPlayMode with OptPlayMode. The bits
									;are passbits, saved through WriteLineData. Called from GameOver
	tst.w	(OptNOP).l				;no players?
	beq.w	rtss2
	tst.w	(OptPlayMode).l			;regular season?
	beq.w	rtss2
	cmpi.w	#4,(OptPlayMode).l		;mode 4?
	beq.w	rtss2
	move.w	#1,(OptPlayMode).l		;continue playoffs
	move.w	#1,(TempOptPlayMode).l
	bsr.w	ResolveGames			;winners of all games
	bsr.w	MakeTree
	cmpi.w	#4,(gamelevel).l
	beq.w	.0						;finished playoffs
	tst.w	(gamenum).l
	bmi.w	.0						;po team out, same as a win
	movea.l	#$18C38,a3				;CD: the cartridge has #(passbits-M68K_RAM)
	bsr.w	WritePassBits
	jsr	(WriteLineData).l
	btst.b	#sf3alttree,(sflags3).l	;alternate tree saved?
	beq.w	rtss2
	movea.l	#(tpassbits-M68K_RAM),a3	;bits before all games resolved
	bsr.w	ReadPassBits
	bra.w	MakeTree
.0									;gamelevel = 4 or gamenum negative
	movea.l	#$18C38,a3				;CD: the cartridge has #(passbits-M68K_RAM)
	bsr.w	ClrPassBits
	jsr	(WriteLineData).l
	move.w	#2,(OptPlayMode).l
	move.w	#2,(TempOptPlayMode).l
	cmpi.w	#7,(bosgames).l			;best of 7?
	beq.w	rtss2
	move.w	#3,(OptPlayMode).l		;new playoffs best of 7
	move.w	#3,(TempOptPlayMode).l
	rts
WritePassBits						;Transfer the game variables to the bits at a3 (pojoy range 8). Called
									;from EncodePW and ResolveGames
	bsr.w	ClrPassBits
	move.w	(postarts).l,d0
	moveq	#$20,d1					;32 trees
	bsr.w	PushBits
	move.w	(bosgames).l,d0
	moveq	#8,d1					;8 values
	bsr.w	PushBits
	move.w	(gamelevel).l,d0
	moveq	#4,d1					;4 levels
	bsr.w	PushBits
	move.w	(potreeteam).l,d0		;user tree position
	moveq	#$10,d1					;16 positions
	bsr.w	PushBits
	move.w	(pojoy).l,d0			;pad layout
	moveq	#8,d1					;8 layouts
	bsr.w	PushBits
	move.w	(WinBits).l,d0
	move.w	#$4000,d1
	bsr.w	PushBits
	moveq	#5,d1					;range 5
	moveq	#7,d2					;8 games
	movea.l	#(gstruct-M68K_RAM),a1
.loop								;each game
	move.w	gspotwins(a1),d0		;per game: push both win counts (range 5)
	bsr.w	PushBits
	move.w	gspobwins(a1),d0
	bsr.w	PushBits
	adda.w	#gssize,a1
	dbf	d2,.loop					;loop
	rts
PushBits							;bits = bits * d1 + d0. d1 = range 2^1-2^15, d0 = data
	movem.l	d0-d1,-(sp)
	exg	d0,d1
	bsr.w	SuperMult
	clr.l	d0
	move.w	d1,d0
	bsr.w	SuperAdd
	movem.l	(sp)+,d0-d1
	rts
;CD: no cartridge twin
ClrPassBits							;CD: placed where the disc branches to it
	movea.l	a3,a0
	moveq	#4,d0
.0									;clear each word
	clr.w	(a0)+
	dbf	d0,.0						;loop
	rts
SuperAdd							;1 long (d0.L) added to the 5 words at a3
	movem.l	d1/a0,-(sp)
	lea	$A(a3),a0					;end of the words
	moveq	#3,d1
	add.l	d0,-(a0)				;add to the lowest long
	bra.w	.2
.1									;carry into the next word
	addi.w	#1,-(a0)				;carry into the next word up
.2									;loop while there is a carry
	dbcc	d1,.1					;loop while no carry out of the word
	movem.l	(sp)+,d1/a0
	rts
SuperMult							;1 word (d0) multiplied by the 5 words at a3
	movem.l	d1-d4/a0,-(sp)
;CD: no cartridge twin
	movea.l	a3,a0
	moveq	#4,d4
.0									;stack each word
	move.w	(a0),-(sp)				;stack the 5 words, clearing the buffer
	clr.w	(a0)+
	dbf	d4,.0
	moveq	#4,d4
.1									;multiply each stacked word
	move.w	d0,d1					;multiply a stacked word by d0, add into the buffer
	mulu.w	(sp)+,d1				;times the stacked word
	lea	2(a3),a0					;its place in the buffer
	adda.w	d4,a0
	adda.w	d4,a0
	move.w	d4,d2
	add.l	d1,-(a0)
	bra.w	.3
.2									;carry
	addi.w	#1,-(a0)
.3									;loop while there is a carry
	dbcc	d2,.2					;loop while a carry remains
	dbf	d4,.1						;next word
	movem.l	(sp)+,d1-d4/a0
	rts
SuperDiv							;5 words at a3 divided by 1 word (d0); d0 = remainder on exit
	movem.l	d1-d2/a0,-(sp)
;CD: no cartridge twin
	movea.l	a3,a0
	moveq	#4,d1
	clr.l	d2
.0									;divide each word
	move.w	(a0),d2					;one word: d2 = remainder:word, divide by d0
	divu.w	d0,d2
	move.w	d2,(a0)+
	dbf	d1,.0						;next word
	swap	d2
	move.w	d2,d0
	movem.l	(sp)+,d1-d2/a0
	rts
GetShifter							;Returns d1 = number of games - 1, d2 = first bit of WinBits
	move.l	d0,-(sp)
	moveq	#-$10,d2
	moveq	#$10,d1					;16 games in round 1
	move.w	(gamelevel).l,d0
.3									;each round: halve the game count
	add.w	d1,d2					;d2 = sum of the halving sizes (bit offset of the round)
	lsr.w	#1,d1					;half the games
	dbf	d0,.3						;next round
	subi.w	#1,d1					;games - 1
	move.l	(sp)+,d0
	rts
AddPlayoffTeamStats					;Add the po team's game stats to its packed playoff totals: unpack them
									;(ReadTeamStats) add the $68 stat bytes at team struct + $B4, then pack
									;each total back into the bit stream below outputbuffer + $DE, clamped to
									;its BitWidthTable width. Called from PeriodOver
	cmpi.w	#1,(OptPlayMode).l
	blt.w	rtss2					;regular season
	bsr.w	ReadTeamStats			;unpack the totals
	movea.l	#(potree-M68K_RAM),a0
	move.w	(potreeteam).l,d2		;user tree position
	move.b	(a0,d2.w),d2
	movea.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
	cmp.w	tmteam(a2),d2			;team number of the home team struct
	beq.w	.0
	adda.w	#tmsize,a2				;tmsize: the po team is the visitor
.0									;team struct chosen
	adda.w	#tmgoals,a2				;the per-player stats
	moveq	#$67,d0					;$68 stats
	movea.l	#(statsbuffer-M68K_RAM),a1
.loop								;add each stat
	clr.w	d1						;add stat byte to its statsbuffer word
	move.b	(a2)+,d1
	add.w	d1,(a1)+
	dbf	d0,.loop					;next stat
	movea.l	#(statsbuffer-M68K_RAM),a0
	movea.l	#BitWidthTable,a1
	movea.l	#(outputbuffer-M68K_RAM),a2
	moveq	#$67,d0					;$68 stats
	clr.w	d4						;d4 = bit position
.loop2								;pack each stat
	clr.l	d1						;one stat: d1 = total, d2 = width, d3 = max
	move.w	(a0)+,d1
	move.w	d0,d2
	andi.w	#3,d2					;mod 4
	move.b	(a1,d2.w),d2			;d2 = bit width
	clr.l	d3
	bset	d2,d3
	subi.w	#1,d3					;d3 = max value
	cmp.w	d3,d1
	ble.w	.1
	move.w	d3,d1
.1									;value clamped to the field
	not.l	d3						;rotate mask and value to bit position d4, clear field then insert
	move.w	d4,d5					;bit position
	andi.w	#$F,d5					;within the word
	rol.l	d5,d3					;mask to position
	rol.l	d5,d1					;value to position
	move.w	d4,d5					;bit position
	lsr.w	#4,d5
	add.w	d5,d5
	neg.w	d5						;the stream runs down in words
	addi.w	#$100,d5				;from the end of the stream
	and.l	d3,-$22(a2,d5.w)		;clear the field
	or.l	d1,-$22(a2,d5.w)
	add.w	d2,d4					;next bit position
	dbf	d0,.loop2					;next stat
	rts
BitWidthTable						;Playoff stat bit widths, indexed by stat number & 3
	dc.b	$C,$E,$A,$A
ReadTeamStats						;Unpack the $68 playoff stat totals from the bit stream into statsbuffer
									;words. Called from AddPOStats and PlayoffStatsScreen
	movea.l	#(statsbuffer-M68K_RAM),a0
	movea.l	#BitWidthTable,a1
	movea.l	#(outputbuffer-M68K_RAM),a2
	moveq	#$67,d0					;$68 stats
	clr.w	d4						;d4 = bit position
.loop								;unpack each stat
	move.w	d4,d5					;d4 = bit position of the stat
	lsr.w	#4,d5
	add.w	d5,d5
	neg.w	d5						;the stream runs down
	addi.w	#$100,d5				;from the end of the stream
	move.l	-$22(a2,d5.w),d1		;the long holding it
	move.w	d4,d5					;bit position
	andi.w	#$F,d5					;within the word
	lsr.l	d5,d1
	move.w	d0,d2
	andi.w	#3,d2					;mod 4
	move.b	(a1,d2.w),d2			;d2 = bit width
	add.w	d2,d4					;next bit position
	clr.w	d3
	bset	d2,d3
	subi.w	#1,d3
	and.w	d3,d1
	move.w	d1,(a0)+
	dbf	d0,.loop					;next stat
	rts
;	Playoff results, the end of game box, the injury, penalty shot and goal boxes, the player name
;	formatters and the exception handlers.
;
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp /
;	cmpi; fixopcodes.js patches the cmp encoding after assembly.

;Game struct (gstruct, gssize each) and team struct (tmstruct / awtmstruct): the fields are named in
;ram94.asm.

ResolveGames						;Compute winners and losers for playoff matchups. Called from EncodePW
	move.w	(gamenum).l,d0			;game just played
	mulu.w	#gssize,d0
	movea.l	#(gstruct-M68K_RAM),a0
	move.w	(HmGoals).l,gss1(a0,d0.w)	;copy score from played game into game structures (gss1, gss2)
	move.w	(AwGoals).l,gss2(a0,d0.w)
	bsr.w	GetShifter				;d1 = games - 1
	movea.l	#(gstruct-M68K_RAM),a0
	moveq	#gssize,d3
	mulu.w	d1,d3					;times the last game
	adda.w	d3,a0					;a0 = last game
	cmpi.w	#7,(bosgames).l
	beq.w	.notbos					;not best of 7
.loop								;each series
	cmpi.w	#4,gspotwins(a0)		;series complete? (gspotwins)
	beq.w	.b1
	cmpi.w	#4,gspobwins(a0)
	beq.w	.b1
	clr.w	d3						;d3 = gspotwins
	btst.b	#gsftf,gsflags(a0)
	beq.w	.0
	eori.w	#gspobwins-gspotwins,d3
.0									;win side chosen
	move.w	gss1(a0),d0
	sub.w	gss2(a0),d0
	bpl.w	.win
	eori.w	#gspobwins-gspotwins,d3
.win								;the winner's count
	addi.w	#1,gspotwins(a0,d3.w)
.b1									;next series
	suba.w	#gssize,a0				;previous game
	dbf	d1,.loop					;loop
	addi.w	#1,(bosgames).l			;next series game
	cmpi.w	#7,(bosgames).l			;series over?
	beq.w	.nextround
	move.w	(gamenum).l,d0			;game just played
	mulu.w	#gssize,d0
	movea.l	#(gstruct-M68K_RAM),a0
	adda.w	d0,a0					;a0 = that game
	cmpi.w	#4,gspotwins(a0)
	beq.w	.cround					;series won
	cmpi.w	#4,gspobwins(a0)
	bne.w	rtss2					;series goes on
.cround								;round over
	cmpi.w	#3,(gamelevel).l		;finish off rest of round games here
	bge.w	.nextround
	bsr.w	GetShifter				;d1 = games - 1
	movea.l	#(gstruct-M68K_RAM),a0
	moveq	#gssize,d3
	mulu.w	d1,d3					;times the last game
	adda.w	d3,a0					;a0 = last game
.cr0								;loop
	cmp.w	(gamenum).l,d1			;skip the game just played
	beq.w	.crn
	cmpi.w	#4,gspotwins(a0)		;won?
	beq.w	.crn
	cmpi.w	#4,gspobwins(a0)		;lost?
	beq.w	.crn
	addi.w	#1,gspotwins(a0)		;give team 1 a win
	move.l	#$C8,d0
	jsr	(randomd0).l
	andi.w	#1,d0					;odd or even
	beq.w	.cr0					;team 1 keeps it
	subi.w	#1,gspotwins(a0)		;take it back
	addi.w	#1,gspobwins(a0)
	bra.w	.cr0
.crn								;next game
	suba.w	#gssize,a0				;previous game
	dbf	d1,.cr0						;loop
	movea.l	#(tpassbits-M68K_RAM),a3	;bits before advancing to next round
	bsr.w	WritePassBits
	bset.b	#sf3alttree,(sflags3).l	;alternate tree saved
.nextround							;next round
	clr.w	(bosgames).l			;advance to next round
	bsr.w	GetShifter				;d1 = games - 1, d2 = first bit
	movea.l	#(gstruct-M68K_RAM),a0
	moveq	#gssize,d3
	mulu.w	d1,d3					;times the last game
	adda.w	d3,a0					;a0 = last game
	clr.w	d3
.loop2								;each series
	cmpi.w	#4,gspotwins(a0)
	beq.w	.2
	bset	d1,d3
.2									;winner bit set
	clr.w	gspotwins(a0)			;reset win counts for the next round
	clr.w	gspobwins(a0)
	suba.w	#gssize,a0				;previous game
	dbf	d1,.loop2					;loop
	moveq	#1,d1					;this round's
	asl.w	d2,d1
	subi.w	#1,d1
	and.w	d1,(WinBits).l			;clear this round's winbits
	asl.w	d2,d3
	or.w	d3,(WinBits).l
	addi.w	#1,(gamelevel).l		;next round
	rts
.notbos								;bosgames = 7
	clr.w	d3						;solve for no best of 7 playoffs (much simpler)
.loop3								;each game
	move.w	gss1(a0),d0
	cmp.w	gss2(a0),d0
	bhi.w	.3
	bset	d1,d3
.3									;winner bit
	btst.b	#gsftf,gsflags(a0)
	beq.w	.nb2
	bchg	d1,d3					;flip the winner
.nb2								;flip handled
	suba.w	#gssize,a0				;previous game
	dbf	d1,.loop3					;loop
	moveq	#1,d1					;this round's
	asl.w	d2,d1
	subi.w	#1,d1
	and.w	d1,(WinBits).l
	asl.w	d2,d3
	or.w	d3,(WinBits).l
	addi.w	#1,(gamelevel).l		;next round
	rts
ShowThreeStars						;End of game Stars of the Game box. Called from UpdatePA while RefPen is
									;the game over penalty. Waits for RefCnt <= $40 and runs once (gmode bit
									;7), then sets disflags bit 3 and waits a vblank. Frames the box, draws a
									;bitmap from Rinktilelist, then the three best star scores
									;(TakeTopStarScore): team abbreviation and getname. Song $F when the home
									;team won
	cmpi.w	#$40,(RefCnt).l
	bgt.w	rtss2					;ref animation not far enough yet
	bset.b	#gmstars,(gmode).l
	bne.w	rtss2					;already shown
	movem.l	d0/a1,-(sp)
	bset.b	#dfclock,(disflags).l	;clock display off
	move.w	(Vcount).l,d0			;current frame
.loop2								;loop
	cmp.w	(Vcount).l,d0			;wait for the next vblank
	beq.w	.loop2
	movem.l	(sp)+,d0/a1
	movem.l	d0-d5/a0-a4,-(sp)
;CD: no cartridge twin
	jsr	(printz).l
	String	CC_Font1Pri,2,$E		;(and dropped a word)
	moveq	#$1C,d0					;framer size
	moveq	#9,d1
;CD: no cartridge twin
	jsr	(Framer).l
	jsr	(printz).l
	dc.w	$001A,$BF09
	dc.w	$1053
	dc.b	'tars of the Game'
	eor.b	d7,d3
	btst	d7,d0
	movea.l	(RinktilelistPtr).l,a1
	movea.l	#null,a2
	adda.l	jimdata(a1),a1
	moveq	#$D,d0					;dobitmap d0-d5
	moveq	#$5B,d1
	moveq	#6,d2
	moveq	#4,d3
.0									;(not branched to)
	move.w	(rinkvrcset).l,d4
	clr.w	d5
;CD: no cartridge twin
	jsr	(dobitmap).l
	bsr.w	CalcStarScores
	move.w	#$12,(printy).l
	moveq	#2,d2					;3 stars
.loop								;each star
	bsr.w	TakeTopStarScore		;a2 = team, d0 = player
	move.w	#$1A,(printx).l
	addi.w	#1,(printy).l
	movea.l	tmdata(a2),a1
	adda.w	Teamname(a1),a1
	adda.w	(a1),a1
;CD: no cartridge twin
	jsr	(print).l
	bsr.w	getname
	move.w	#$3,(printx).l
	jsr	(print).l
	dbf	d2,.loop					;next star
	move.w	(HmGoals).l,d0
.1									;(not branched to)
	sub.w	(AwGoals).l,d0
	ble.w	.nosong					;home didn't win
	move.w	#SFXhomewin,-(sp)		;home team won (sound effect)
	jsr	(song).l
.nosong								;exit: restore the registers
	movem.l	(sp)+,d0-d5/a0-a4
	rts
TakeTopStarScore					;Take the highest of the 52 star scores at ThreeStars and clear it.
									;Returns d0 = player slot, a2 = its team struct. Called from
									;ShowThreeStars
	movem.l	d1-d2/a1/a4,-(sp)
	movea.l	#(starscores-M68K_RAM),a4
	clr.l	d0						;best so far 0
	moveq	#$33,d2
.find								;scan the 52 entries
	cmp.l	(a4)+,d0				;scan for the highest score
	bge.w	.next
	lea	-4(a4),a1					;a1 = best entry
	move.l	(a1),d0
.next								;next entry
	dbf	d2,.find					;next entry
	clr.l	(a1)
;CD: no cartridge twin
	move.l	a1,d0
	subi.l	#$BC000,d0
	lsr.w	#2,d0
	movea.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
	cmpi.w	#RosterSlots,d0			;home slot?
	blt.w	.home
	subi.w	#RosterSlots,d0
	adda.w	#tmsize,a2				;second team roster block (tmsize)
.home								;exit: restore the registers
	movem.l	(sp)+,d1-d2/a1/a4
	rts
CalcStarScores						;Star score for every roster slot of both teams to ThreeStars (26 longs
									;per team, home first). d5 =
									;GetPeriodTime + d2, the goalie ice time needed. If gsp is 3 and the score
									;is not tied, the scorer of the last goal gets $7FFFFFFF. Called from
									;ShowThreeStars
	movea.l	#(starscores-M68K_RAM),a4
	jsr	(GetPeriodTime).l			;d0 = period time
	move.w	d0,d5					;d5 = period time + d2
	add.w	d2,d5
	movea.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
	lea	tmsize(a2),a3				;a3 = other team
	bsr.w	CalcTeamStarScores
;CD: no cartridge twin
	movea.l	a3,a2
	lea	-$366(a2),a3
	bsr.w	CalcTeamStarScores		;away (d3 = away - home score)
	cmpi.w	#3,(gsp).l				;overtime?
	bne.w	.x
	tst.w	d3
	beq.w	.x
	movea.l	#$180EC,a0				;+ ScoreSumbytes = last goal entry (CD: the cartridge has
									;#(ChkCnt-M68K_RAM))
	adda.w	(ScoreSumbytes).l,a0
	clr.w	d0
	btst.b	#7,ssflags(a0)
	beq.w	.slot
	addi.w	#RosterSlots,d0			;away goal: second RosterSlots entries
.slot								;slot of the scorer
	add.b	ssscorer(a0),d0
	asl.w	#2,d0
	movea.l	#(starscores-M68K_RAM),a0
	move.l	#$7FFFFFFF,(a0,d0.w)	;game winner is the first star
.x									;exit (also the end of the code above)
	rts
;CD: no cartridge twin
CalcTeamStarScores					;CD: placed where the disc branches to it
	movea.l	a2,a1
	move.w	tmscore(a2),d3			;our goals
	sub.w	tmscore(a3),d3			;goal difference (HmGoals / AwGoals)
	ext.l	d3
	moveq	#$19,d4
	jsr	(GetGoalieCount).l			;d0 = goalies on the team
	neg.w	d0
	add.w	d4,d0					;d4 above $19 - goalies: goalie slot
.loop								;each roster slot
	move.l	d3,(a4)					;slot d4: start at the goal difference
	cmp.w	d0,d4					;goalie slot?
	bhi.w	.goalie
	clr.w	d1
	move.b	tmgoals(a2),d1
	mulu.w	#$2AF8,d1				;goals * 11000
	add.l	d1,(a4)
	clr.w	d1
	move.b	tmassists(a2),d1
	mulu.w	#$2774,d1				;assists * 10100
	add.l	d1,(a4)
	clr.w	d1
	move.b	tmpshots(a2),d1
	mulu.w	#$A,d1					;shots * 10
	tst.w	d3
	bne.w	.add					;not tied: shots * 10
	mulu.w	#$64,d1					;tied: shots * 1000
	add.l	d1,(a4)
	clr.l	d1
	add.w	tmpice(a1),d1			;+ frames on ice
.add								;add the score
	add.l	d1,(a4)
	bra.w	.next
.goalie								;d4 > d0
	cmp.w	tmpice(a1),d5			;goalie slot: needs enough frames on ice
	bhi.w	.next					;not on ice long enough
	clr.w	d1
	move.b	tmgoals(a2),d1
	mulu.w	#$64,d1
	clr.w	d2
	move.b	tmpshots(a2),d2
	beq.w	.next					;no shots: nothing
	divu.w	d2,d1					;goals against %
	cmpi.w	#4,d1					;4% or less?
	bhi.w	.next
	addi.l	#$7D00,(a4)
	tst.w	d1						;no goals?
	bne.w	.next
	addi.l	#$124F8,(a4)			;75000 for a shutout
;CD: no cartridge twin
.next								;CD: placed where the disc branches to it
	adda.w	#$2,a1
	adda.w	#$1,a2
	adda.w	#$4,a4
	dbf	d4,.loop					;loop
	rts
ShowInjuryBox						;Injury box: 'Injury to:' player TempPlOffset, 'Out for period', or 'Out
									;for game' when sflags7 bit 5 is set, and 'the game' over 'period' when
									;puck_pflags2 bit 0 is set. Jumped to from
									;CheckInjury so global
	movem.l	d0-d2/a0-a4,-(sp)
;CD: no cartridge twin
	jsr	(printz).l
	String	CC_Font1Pri,$B,3
	moveq	#$12,d0					;framer size
	moveq	#5,d1
;CD: no cartridge twin
	jsr	(Framer).l
	btst.b	#$5,(sflags7).l
	bne.w	.L40DA4
	jsr	(printz).l
	dc.w	$0024,$BF0C
	dc.w	$0449
	dc.b	'njury to:'
	dc.b	$BF
	dc.w	$0C06,$4F75
	dc.b	't for period'
	cmpm.b	(a4)+,(sp)+
	btst	d2,d0
	bra.w	.L40DCC
.L40DA4
	jsr	(printz).l
	dc.w	$0022,$BF0C
	dc.w	$0449
	dc.b	'njury to:'
	dc.b	$BF
	dc.w	$0C06,$4F75
	dc.b	't for game'
	cmpm.b	(a4)+,(sp)+
	btst	d2,d0
.L40DCC
	bsr.w	GetPlayerNumInitial
	jsr	(print).l
	btst.b	#$0,(puck_pflags2).l
	beq.w	.ex
	jsr	(printz).l
	String	CC_Font1Pri,$14,6,'the game'
.ex									;exit: restore the registers
	movem.l	(sp)+,d0-d2/a0-a4
	rts
PenaltyShotBox						;Penalty shot box, called from chkprogress. Sets gmode2 bit 7; in Shootout
									;(bit 0) jumps to ShootoutModeBox
									;instead. Otherwise: printbig 'PENALTY SHOT!', the shooter (BA_Sktr_SCnum,
									;BA_Team), the penalty name (Penaltylist, pspenalty) and ' by' the player
									;BA_Checker_Offset of the other team
	bset.b	#7,(gmode2).l			;penalty shot box shown
	btst.b	#0,(gmode2).l			;shootout?
.0									;(not branched to)
	beq.w	.box
	jmp	(ShootoutModeBox).l
.box								;bit 0 of gmode2 clear
	movem.l	d0-d2/a0-a4,-(sp)
	move.w	#$FFFF,d0				;clear the message
	jsr	(prefmes).l
;CD: no cartridge twin
	jsr	(printz).l
	String	CC_Font1Pri,3,2
	moveq	#$1B,d0
.2									;(not branched to)
	moveq	#8,d1
;CD: no cartridge twin
	jsr	(Framer).l
	lea	PenShotBigTxt(pc),a1
	jsr	(printbig).l
	move.w	(BA_Sktr_SCnum).l,d0
	asl.w	#7,d0					;sprite structs are $80 bytes
	movea.l	#SortCords,a2
	adda.w	d0,a2
	clr.w	d0
	move.b	pnum(a2),d0
	movea.l	#tmstruct,a2
	tst.w	(BA_Team).l				;which team?
	beq.w	.6
.5									;(not branched to)
	movea.l	#awtmstruct,a2
.6									;team chosen
	bsr.w	FormatPlayerNumInitial	;a1 = shooter's name
;CD: no cartridge twin
	jsr	(print).l
	jsr	(printz).l
	String	CC_Font1Pri,4,7
	movem.l	a1/a3,-(sp)
	move.w	(pspenalty).l,d0
	movea.l	#Penaltylist,a1
	adda.w	(a1,d0.w),a1			;this penalty's data
	lea	2(a1),a1
;CD: no cartridge twin
	jsr	(print).l
	movem.l	(sp)+,a1/a3
	jsr	(printz).l
	String	' by',CC_Font1Pri,4,8
	move.w	(BA_Checker_Offset).l,d0
	movea.l	#awtmstruct,a2
	tst.w	(BA_Team).l				;which team?
	beq.w	.7
	movea.l	#tmstruct,a2
.7									;opponent team chosen
	jsr	(FormatPlayerNumInitial).l	;a1 = his name
	jsr	(print).l
	movem.l	(sp)+,d0-d2/a0-a4
	rts
PenShotBigTxt	String	CC_Font1Pri,4,3,'PENALTY SHOT!',CC_Font1Pri,4,5	;printbig String for PenaltyShotBox
ShowGoalBox							;Goal box. Closes both line change boxes, then printbig 'GOAL!' ('PP
									;GOAL!' when DelayedPen bit 0 is set, cleared here), or 'HAT TRICK!' on
									;the scorer's third goal when the scorer's slot is at least scorergoalies
									;(homegoalies home / awaygoalies visitors), then the scorer and up to two
									;assists of the last goal entry (FormatPlayerName). Calls CountGoalies,
									;StartArenaAnim (home hat trick),
									;PrintPlayerGoals and PrintPlayerAssists; BA_PS_flags bit 2 sets sflags2
									;bit 2. Called from SetPA
	movem.l	d0-d2/a0-a4,-(sp)
	btst.b	#2,(BA_PS_flags).l		;penalty shot?
	beq.w	.0
	bset.b	#sf2drec,(sflags2).l	;record the replay
.0									;replay recording set for a penalty shot
	movea.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
	jsr	(lcfound_close).l			;close lc box
	adda.w	#tmsize,a2
	jsr	(lcfound_close).l			;close its box
	movea.l	#$180EC,a4				;+ ScoreSumbytes = last goal entry (CD: the cartridge has
									;#(ChkCnt-M68K_RAM))
	adda.w	(ScoreSumbytes).l,a4
;CD: no cartridge twin
	jsr	(printz).l
	String	CC_Font1Pri,$B,2
	moveq	#$13,d0
	move.w	#5,d1					;5 rows: no assist
	tst.b	ssassist1(a4)
	bmi.w	.frame
	addi.w	#2,d1					;7: one assist
	tst.b	ssassist2(a4)
	bmi.w	.frame
	addi.w	#1,d1					;8: two assists
;CD: no cartridge twin
.frame								;CD: placed where the disc branches to it
	jsr	(Framer).l
	jsr	(CountGoalies).l			;goalies of each team
	movea.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
	move.w	(homegoalies).l,(scorergoalies).l
	btst.b	#7,ssflags(a4)
	beq.w	.1
	adda.w	#tmsize,a2
	move.w	(awaygoalies).l,(scorergoalies).l
.1									;scorer team chosen
	lea	GoalBoxText(pc),a1
	bclr.b	#0,(DelayedPen).l		;power play goal?
	beq.w	.2
	lea	PPGoalBigTxt(pc),a1
.2									;goal or power play goal text chosen
	clr.w	d0
	move.b	ssscorer(a4),d0
	addi.w	#tmgoals,d0				;goals of the scorer
	cmpi.b	#3,(a2,d0.w)			;goals
	bne.w	.print					;not a hat trick
	movem.w	d1,-(sp)
	clr.w	d1
	move.b	ssscorer(a4),d1
	cmp.w	(scorergoalies).l,d1	;a goalie?
	movem.w	(sp)+,d1
	blt.w	.print					;yes: no hat trick
	adda.w	(a1),a1					;HAT TRICK!
	move.w	d0,-(sp)
	move.w	tmteam(a2),d0
	cmp.w	(HomeTeam).l,d0			;home team?
	bne.w	.3
	move.w	#0,d0					;animation 0
	jsr	(StartArenaAnim).l
.3									;arena animation for a home goal
	move.w	(sp)+,d0
;CD: no cartridge twin
.print								;CD: placed where the disc branches to it
	jsr	(printbig).l
	clr.w	d0
	move.b	ssscorer(a4),d0
	move.w	d0,-(sp)
	move.w	#$C,(printx).l
	bsr.w	FormatPlayerName		;a1 = his name
;CD: no cartridge twin
	jsr	(print).l
	move.w	(sp)+,d0
	movem.w	d1,-(sp)
	clr.w	d1
	move.b	ssscorer(a4),d1
	cmp.w	(scorergoalies).l,d1	;a goalie?
	movem.w	(sp)+,d1
	blt.w	.5
	jsr	(PrintPlayerGoals).l
.5									;goalies get no goal count
	clr.w	d0
	move.b	ssassist1(a4),d0
	bmi.w	.6
	bclr.b	#5,(sflags4).l
	bne.w	.6						;sflags4 bit 5 set: no assists
;CD: no cartridge twin
	jsr	(printz).l
	String	CC_Font1Pri,$E,6,'Assist by:',CC_Font1Pri,$C,7
	move.w	d0,-(sp)
	bsr.w	FormatPlayerName		;a1 = his name
;CD: no cartridge twin
	jsr	(print).l
	move.w	(sp)+,d0
	jsr	(PrintPlayerAssists).l
	clr.w	d0
	move.b	ssassist2(a4),d0
	bmi.w	.6
;CD: no cartridge twin
	jsr	(printz).l
	String	CC_Font1Pri,$C,8
	move.w	d0,-(sp)
	bsr.w	FormatPlayerName		;a1 = his name
;CD: no cartridge twin
	jsr	(print).l
	move.w	(sp)+,d0
	jsr	(PrintPlayerAssists).l
.6									;box done
	bclr.b	#5,(sflags4).l			;clear the no assists flag
	movem.l	(sp)+,d0-d2/a0-a4
	rts
GoalBoxText	String	CC_Font1Pri,$F,3,'GOAL!',CC_Font1Pri,$C,5	;printbig Strings for ShowGoalBox: GOAL!,
									;then HAT TRICK!
	String	CC_Font1Pri,$C,3,'HAT TRICK!',CC_Font1Pri,$C,5
PPGoalBigTxt	String	CC_Font1Pri,$D,3,'PP GOAL!',CC_Font1Pri,$C,5	;The same after DelayedPen bit 0:
									;PP GOAL!, then HAT TRICK!
	String	CC_Font1Pri,$C,3,'HAT TRICK!',CC_Font1Pri,$C,5
;CD: no cartridge twin
box									;CD: entered here; the cartridge box starts at its first twin line, $410F2
	jsr	(printz).l
	String	CC_Font1,$B,2
	moveq	#$13,d0
	moveq	#8,d1
	move.l	#$7FF,d2				;blank char
;CD: no cartridge twin
	jmp	(eraser).l
GetPlayerName						;but that is the same symbol as getplayername (SNASM symbols are
									;case-insensitive).
									;a1 = mesarea "NN First Last" (getname) for player TempPlOffset (bit 15
									;set: away team). Called from UpdatePA
	movem.l	d0/a2,-(sp)
	movea.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
	move.w	(TempPlOffset).l,d0
	bpl.w	.0
	andi.w	#$FF,d0
	adda.w	#tmsize,a2
.0									;team chosen
	bsr.w	getname					;name for d0 of team a2
	movem.l	(sp)+,d0/a2
	rts
getname								;gets player number and name, appends to string: a1 = mesarea "NN First
									;Last" for player d0 (roster offset) of team struct a2. The number is the
									;bcd byte after the name
	movem.l	d0-d3/a0/a2-a3,-(sp)
	bsr.w	GetPlayerNamePointer	;get to start of player name
	move.l	a0,-(sp)				;push a0 (address to start of player name) to stack
	movea.l	#$17EF2,a3				;move mesarea to a3 address (CD: the cartridge has #(mesarea-M68K_RAM))
	move.w	#4,(a3)					;move 4 into a3 address location
	lea	2(a3),a1					;move long address at a3+2 into a1
	adda.w	(a0),a0					;add data at a0 (player name length) to a0
	move.b	(a0),d0					;move a0 data (jersey #) to d0
	bsr.w	ConvertByteToDigits		;convert JNo to ascii
;CD: no cartridge twin
	jsr	(appendz).l
	dc.w	$0004,$2000
	movea.l	(sp)+,a1
	jsr	(appstring).l
	movea.l	#$17EF2,a1				;move mesarea address into a1 (CD: the cartridge has #(mesarea-M68K_RAM))
	movem.l	(sp)+,d0-d3/a0/a2-a3
	rts
GetPlayerNumInitial					;a1 = mesarea "NN F. Last" (FormatPlayerNumInitial) for player
									;TempPlOffset (bit 15 set: away team). Called from ShowInjuryBox
	movem.l	d0/a2,-(sp)
	movea.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
	move.w	(TempPlOffset).l,d0
	bpl.w	.get
	andi.w	#$FF,d0
	adda.w	#tmsize,a2
.get								;team chosen
	bsr.w	FormatPlayerNumInitial	;name for d0 of team a2
	movem.l	(sp)+,d0/a2
	rts
FormatPlayerNumInitial				;a1 = mesarea string "NN F. Last" for player d0 of team a2, built in
									;TextBuffer. Called from PenaltyShotBox and others
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	GetPlayerNamePointer	;a0 = player record
	move.l	a0,-(sp)
	movea.l	#$17EF4,a1				;CD: the cartridge has #(TextBuffer-M68K_RAM)
	adda.w	(a0),a0					;byte after the name: number
	move.b	(a0),d0
	bsr.w	ConvertByteToDigits
	move.b	#$20,(a1)+
	movea.l	(sp)+,a0
	move.w	(a0)+,d0
	lea	-$2(a0,d0.w),a2				;end of the name
	move.b	(a0)+,(a1)+
	move.w	#$2E20,(a1)+
.skip								;loop
	cmpi.b	#$20,(a0)+				;space?
	bne.w	.skip
.copy								;loop
	move.b	(a0)+,(a1)+
	cmpa.l	a0,a2					;end of the name?
	bne.w	.copy
	bsr.w	FinalizeTextBuffer
	movem.l	(sp)+,d0-d3/a0/a2
	rts
FormatPlayerName					;a1 = mesarea string "NN Last" for player d0 of team a2, built in
									;TextBuffer. Called from ShowGoalBox and others
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	GetPlayerNamePointer	;a0 = player record
	move.l	a0,-(sp)
	movea.l	#$17EF4,a1				;CD: the cartridge has #(TextBuffer-M68K_RAM)
	adda.w	(a0),a0					;byte after the name: number
	move.b	(a0),d0
	bsr.w	ConvertByteToDigits
	move.b	#$20,(a1)+
	movea.l	(sp)+,a0
	move.w	(a0)+,d0
	lea	-$2(a0,d0.w),a2				;end of the name
.skip								;loop
	cmpi.b	#$20,(a0)+				;space?
	bne.w	.skip
.copy								;loop
	move.b	(a0)+,(a1)+
	cmpa.l	a0,a2					;end of the name?
	bne.w	.copy
	bsr.w	FinalizeTextBuffer
	movem.l	(sp)+,d0-d3/a0/a2
	rts
FormatPlayerNameLast				;FormatPlayerNameShort without the leading space ("Last", space padded).
									;Branches into FormatLastName
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	GetPlayerNamePointer	;a0 = player record
	movea.l	#$17EF4,a1				;CD: the cartridge has #(TextBuffer-M68K_RAM)
	bra.w	FormatLastName
FormatPlayerNameShort				;a1 = mesarea string " Last" for player d0 of team a2, space padded to 12
									;characters; a 0 byte also ends the name
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	GetPlayerNamePointer	;a0 = player record
	movea.l	#$17EF4,a1				;CD: the cartridge has #(TextBuffer-M68K_RAM)
	move.b	#$20,(a1)+				;leading space
FormatLastName						;Skip the first name, copy the last name, pad; branched to from
									;FormatPlayerNameLast, so global
	move.w	(a0)+,d0
	lea	-$2(a0,d0.w),a2				;end of the name
.loop								;loop
	cmpi.b	#$20,(a0)+				;space?
	bne.w	.loop
.loop2								;loop
	move.b	(a0)+,(a1)+
	cmpa.l	a0,a2					;end of the name?
	beq.w	.pad
	tst.b	(a0)					;0 byte?
	bne.w	.loop2
	bra.w	.pad
.loop3								;loop
	move.b	#$20,(a1)+
.pad								;pad with spaces to 12
	cmpa.l	#$17F00,a1				;CD: the cartridge has #(TextBuffer+12-M68K_RAM)
	blt.w	.loop3
	bsr.w	FinalizeTextBuffer
	movem.l	(sp)+,d0-d3/a0/a2
	rts
;CD: no cartridge twin
FinalizeTextBuffer					;CD: placed where the disc branches to it
	move.l	a1,d0
	subi.l	#$17EF2,d0
	btst	#0,d0					;odd?
	beq.w	.even
	clr.b	(a1)+
	addi.w	#1,d0
.even								;length rounded to even
	movea.l	#$17EF2,a1				;CD: the cartridge has #(mesarea-M68K_RAM)
	move.w	d0,(a1)
	rts
GetPlayerNamePointer				;loops through team roster to get to d0 player: a0 = name string of player
									;d0 (roster offset) of team struct a2. Each record is a length word String
									;and 8 more bytes
	movea.l	tmdata(a2),a0			;ROM address of the team data
	adda.w	0(a0),a0				;add offset (player data start) to a0 address
	bra.w	.loop
.skip								;skip one player record
	adda.w	(a0),a0					;add player name length to a0
;CD: no cartridge twin
	adda.w	#$8,a0
.loop								;loop until the player is reached
	dbf	d0,.skip					;loop until at player offset
	rts
ConvertByteToDigits					;converts decimal number in d0 to ascii: two ascii digits of bcd byte d0
									;to (a1)+, a leading 0 becomes a space ($F0 + '0')
	move.w	d0,-(sp)
	lsr.b	#4,d0					;divide by 16 (get upper digit in d0)
	bne.w	.n0						;branch if not 0
	move.b	#$F0,d0					;move $F0 into d0
.n0									;tens digit (or a space)
	addi.b	#$30,d0
	move.b	d0,(a1)+				;move d0 into a1 and increment
	move.w	(sp)+,d0				;pop d0 from stack
	andi.w	#$F,d0					;pass bottom 4 bytes of d0 (lower digit in d0)
	addi.b	#$30,d0
	move.b	d0,(a1)+				;move d0 into a1 and increment
	rts
;CD: no cartridge twin
	bclr.b	#$5,$FF800F.l
	jsr	(printbigz).l
AddError							;CD: its first lines have no twin; the rest of it starts here
	String	CC_Font3Pri,0,0,'Address Error'
	move.l	$A(sp),d0				;pc (exception frame)
	move.l	2(sp),d1				;access address (exception frame)
	bra.w	crash
;CD: no cartridge twin
	bclr.b	#$5,$FF800F.l
	jsr	(printbigz).l
Illinst								;CD: its first lines have no twin; the rest of it starts here
	String	CC_Font3Pri,0,0,'Illegal Instruction'
	move.l	2(sp),d0				;pc (exception frame)
	move.l	d0,d1
	bra.w	crash
;CD: no cartridge twin
	bclr.b	#$5,$FF800F.l
	jsr	(printbigz).l
ZeroDiv								;CD: its first lines have no twin; the rest of it starts here
	String	CC_Font3Pri,0,0,'Division by zero'
	move.l	2(sp),d0				;pc (exception frame)
	move.l	d0,d1
crash								;printbig d1 then d0 as hex, set the vdp up, copy 8 longs from the
									;Rinktilelist palette + $20 to cram $20
									;and hang. Branched to from AddError and Illinst, falls in from ZeroDiv
	movea.l	#$17EF2,a0				;CD: the cartridge has #(mesarea-M68K_RAM)
	move.w	#$18,(a0)+
	move.b	#$BD,(a0)+
	move.b	#0,(a0)+
	move.b	#2,(a0)+
	move.l	d1,-(sp)
	bsr.w	.ri
	move.b	#$BD,(a0)+				;position code
	move.b	#0,(a0)+
	move.b	#4,(a0)+
	move.l	(sp)+,d0
	bsr.w	.ri
	movea.l	#$17EF2,a1				;CD: the cartridge has #(mesarea-M68K_RAM)
;CD: no cartridge twin
	jsr	(printbig).l
	movea.l	#$C00000,a0
.L4138E
	btst.b	#$7,$FF800E.l
	bne.s	.L4138E
	move.w	#$9100,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L413B0
	btst.b	#$6,$FF800E.l
	beq.s	.L413B0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L413CA
	btst.b	#$6,$FF800E.l
	bne.s	.L413CA
	bclr.b	#$7,$FF800F.l
.L413DC
	btst.b	#$7,$FF800E.l
	bne.s	.L413DC
	move.w	#$9206,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L413FE
	btst.b	#$6,$FF800E.l
	beq.s	.L413FE
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L41418
	btst.b	#$6,$FF800E.l
	bne.s	.L41418
	bclr.b	#$7,$FF800F.l
.L4142A
	btst.b	#$7,$FF800E.l
	bne.s	.L4142A
	move.w	#$8F02,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L4144C
	btst.b	#$6,$FF800E.l
	beq.s	.L4144C
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L41466
	btst.b	#$6,$FF800E.l
	bne.s	.L41466
	bclr.b	#$7,$FF800F.l
.L41478
	btst.b	#$7,$FF800E.l
	bne.s	.L41478
	move.l	#$C0200000,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L4149C
	btst.b	#$6,$FF800E.l
	beq.s	.L4149C
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L414B6
	btst.b	#$6,$FF800E.l
	bne.s	.L414B6
	bclr.b	#$7,$FF800F.l
	movea.l	(RinktilelistPtr).l,a1
	adda.l	(a1),a1
	adda.w	#$20,a1					;second palette
	moveq	#7,d0					;8 longs
;CD: no cartridge twin
.pal								;CD: placed where the disc branches to it
.L414D6
	btst.b	#$7,$FF800E.l
	bne.s	.L414D6
	move.l	(a1)+,$FF8022.l
	move.w	#$E,$FF8020.l
	bset.b	#$6,$FF800F.l
.L414F6
	btst.b	#$6,$FF800E.l
	beq.s	.L414F6
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L41510
	btst.b	#$6,$FF800E.l
	bne.s	.L41510
	bclr.b	#$7,$FF800F.l
	dbf	d0,.pal						;loop
.end								;loop
	bra.w	.end
.ri									;d0 as 8 hex digits to (a0)+
	moveq	#7,d2					;8 digits
.top								;each hex digit
	rol.l	#4,d0					;next hex digit (high nibble first)
	move.w	d0,d1
	andi.w	#$F,d1					;nibble
	addi.w	#$30,d1
	cmpi.w	#$39,d1
	ble.w	.t1
	addi.w	#7,d1
.t1									;digit character ready
	move.b	d1,(a0)+
	dbf	d2,.top						;next digit
	rts
