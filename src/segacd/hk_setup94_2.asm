	include	segacd\hockey.inc
	include	macros\genesis.mac

AwGoals	equ	$186BE
BitWidthTable	equ	$408DC
CC_Font1Pri	equ	$BF
FourWayPlay	equ	$18BF8
GetPeriodTime	equ	$2BA04
HmGoals	equ	$18358
HomeTeam	equ	$17FAE
LOAD	equ	$1B000
Opt1team	equ	$18BFE
Opt2team	equ	$18C00
OptNOP	equ	$18BFC
OptPlayMode	equ	$18BFA
RefCnt	equ	$1806E
ScoreSumbytes	equ	$180F0
ScoutSubStatus	equ	$17474
TeamPalettes	equ	$25060
Teamblocksmap	equ	$47D44
ThreeStars	equ	$BC000
VisTeam	equ	$17FB0
WinBits	equ	$18AA4
WriteLineData	equ	$2A5C8
bosgames	equ	$18A9C
disflags	equ	$18D64
dobitmap	equ	$387E2
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
printz	equ	$38F6E
randomd0	equ	$37050
swap	equ	$2779A
teambitmapchars	equ	$1939C
tmstruct	equ	$1834C
X_21000	equ	$21000
X_241BC	equ	$241BC
X_24FEA	equ	$24FEA
X_25318	equ	$25318
X_2557C	equ	$2557C
X_2579C	equ	$2579C
X_25CAC	equ	$25CAC

	org	$24DE8

	dc.w	$33FC,$0001,$0003,$FC0A,$6100,$FE1A,$23FC,$0003
	dc.w	$DB90,$0001,$8D66,$08B9,$0001,$0001,$8D64,$33FC
	dc.w	$0005,$0001,$8D3E,$33FC,$A000,$0001,$8D38,$33FC
	dc.w	$0007,$0001,$8D3A,$33FC,$C000,$0001,$8D34,$33FC
	dc.w	$0007,$0001,$8D36,$33FC,$F000,$0001,$8D3C,$33FC
	dc.w	$F800,$0001,$8D32,$33FC,$FC00,$0001,$8D30,$207C
	dc.w	$000B,$BCB0,$721F,$4298,$51C9,$FFFC,$4EB9,$0003
	dc.w	$6F72,$4EB9,$0003,$7B74,$4E75,$4EB9,$0003,$74F0
	dc.w	$0C03,$00E0,$6600,$C192,$08F9,$0005,$00FF,$800F
	dc.w	$23FC,$0003,$DB90,$0001,$8D66,$4EB9,$0004,$7DAC
	dc.w	$4EB9,$0003,$6D0A,$33FC,$0018,$0001,$8D62,$6100
	dc.w	$8EF4,$0012,$F804,$030C,$0143,$6865,$636B,$2053
	dc.w	$6F75,$6E64,$7C14,$3039,$0001,$7474,$B079,$0001
	dc.w	$7474,$6700,$FFF8,$4EB9,$0003,$74F0,$4EB9,$0003
	dc.w	$74BE,$4A01,$6700,$FFE0,$0801,$0007,$6600,$C12A
	dc.w	$0801,$0003,$6700,$0006,$0646,$0001,$0801,$0002
	dc.w	$6700,$0006,$0446,$0001,$0801,$0005,$6700,$0008
	dc.w	$4EB9,$0003,$710C,$3006,$7203,$6100,$9296,$33FC
	dc.w	$0017,$0001,$8D58,$6100,$9070,$6000,$FF9A
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
	bsr.w	X_24FEA
	bsr.w	printz-LOAD
	String	CC_Font1Pri,$16,$1
	move.w	(HomeTeam).l,d1
	move.w	d1,d0
	asl.w	#$6,d0		;64 bytes per team
	movea.l	#TeamPalettes,a0
	move.l	$2(a0,d0.w),$BBCD2.l		;A palette colors into palette 1
	move.w	#$EEE,$BBCDA.l		;colour 5 white
	move.w	#$2,d4		;first bitmap char
	bsr.w	X_24FEA		;draw the home team
	bsr.w	X_241BC		;set up the team structs
	move.w	#$64,(palcount).l		;fade over $64 frames
	movem.l	(sp)+,d0-d7/a0-a2
	rts
	dc.w	$4240,$E341,$2079,$0004,$7D48,$2248,$D1D0,$D3E9
	dc.w	$0004,$247C,$0001,$B008,$3411,$7602,$7A00,$6000
	dc.w	$87D8
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
	dc.w	$6100,$000E,$700C,$7202,$343C,$07FF,$6000,$8BC8
	dc.w	$6100,$8F2C,$0006,$BF02,$0A00,$B5FC,$0001,$834C
	dc.w	$6600,$BFAE,$33FC,$001A,$0001,$8D58,$4E75,$48E7
	dc.w	$8080,$426A,$0028,$6100,$02B0,$B5FC,$0001,$834C
	dc.w	$57C0,$4880,$0640,$0002,$B079,$0001,$7FA6,$6700
	dc.w	$004A,$B079,$0001,$7FA8,$6700,$0040,$7000,$0C79
	dc.w	$0002,$0001,$8A9E,$6E00,$002E,$4A79,$0001,$8C0A
	dc.w	$6600,$0024,$207C,$0001,$B00C,$302A,$0000,$E540
	dc.w	$2070,$0000,$D0E8,$000A,$7004,$4EB9,$0003,$6BB2
	dc.w	$4EB9,$0003,$6BE2,$3540,$0028,$4CDF,$0101,$4E75
	dc.w	$48E7,$FFFE,$0839,$0002,$0001,$8D64,$6600,$0018
	dc.w	$08B9,$0000,$0001,$8D64,$6700,$0006,$6100,$DAC6
	dc.w	$4EB9,$0003,$6DF6,$5279,$0001,$7474,$4CDF,$7FFF
	dc.w	$4E75,$50F9,$0001,$8C16,$207C,$0001,$8BFA,$227C
	dc.w	$0004,$0120,$303C,$0008,$30D9,$51C8,$FFFC,$4E75
	dc.w	$0000,$0001,$000B,$000A,$0001,$0000,$0001,$0000
	dc.w	$0001,$48E7,$FFF0,$267C,$0001,$8C38,$6100,$043E
	dc.w	$3039,$0001,$8A9E,$8079,$0001,$8A9C,$6700,$0070
	dc.w	$6100,$00F2,$7007,$4A79,$0001,$8BF8,$6700,$0006
	dc.w	$303C,$000B,$4A79,$0001,$8BF8,$6600,$001A,$0C79
	dc.w	$0002,$0001,$8AA2,$6F00,$003A,$0479,$0002,$0001
	dc.w	$8AA2,$6000,$002E,$0C79,$0001,$0001,$8AA2,$6600
	dc.w	$000E,$33FC,$0003,$0001,$8AA2,$6000,$0016,$0C79
	dc.w	$0002,$0001,$8AA2,$6600,$000A,$33FC,$0004,$0001
	dc.w	$8AA2,$9079,$0001,$8AA2,$33C0,$0001,$8BFC,$4CDF
	dc.w	$0FFF,$4E75,$7020,$4EB9,$0003,$7050,$0640,$0001
	dc.w	$0240,$001F,$E940,$207C,$0001,$FFDA,$D0C0,$E848
	dc.w	$720F,$3439,$0001,$8BFE,$0C42,$0019,$6300,$0004
	dc.w	$7419,$B418,$57C9,$FFFC,$6600,$FFD2,$0A41,$000F
	dc.w	$33C1,$0001,$8AA0,$33C0,$0001,$8A9A,$4279,$0001
	dc.w	$8A9E,$33FC,$0007,$0001,$8A9C,$0C79,$0002,$0001
	dc.w	$8BFA,$6700,$0020,$4279,$0001,$8A9C,$7007,$207C
	dc.w	$0001,$8A18,$4268,$0004,$4268,$0006,$D0FC,$0010
	dc.w	$51C8,$FFF2
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
	bsr.w	X_25318		;assign the pads
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
	dc.w	$48E7,$F0C0,$4279,$0001,$7FA6,$4279,$0001,$7FA8
	dc.w	$4279,$0001,$7FAA,$4279,$0001,$7FAC,$4A79,$0001
	dc.w	$8C16,$6700,$01D0,$4A79,$0001,$8BFA,$6700,$0170
	dc.w	$0839,$0000,$0001,$7F78,$6600,$0164,$6100,$04C6
	dc.w	$207C,$0001,$8AA6,$3439,$0001,$8AA0,$1430,$2000
	dc.w	$227C,$0001,$8A18,$7810,$C8C1,$D2C4,$50F9,$0001
	dc.w	$8A98,$4240,$B469,$0000,$6700,$003A,$B469,$0002
	dc.w	$6700,$000E,$92FC,$0010,$51C9,$FFEA,$6000,$017A
	dc.w	$7004,$4A79,$0001,$8BF8,$6700,$0006,$303C,$0005
	dc.w	$33E9,$0000,$0001,$8C00,$33E9,$0002,$0001,$8BFE
	dc.w	$6000,$0014,$4240,$33E9,$0002,$0001,$8C00,$33E9
	dc.w	$0000,$0001,$8BFE,$D079,$0001,$8AA2,$33C1,$0001
	dc.w	$8A98,$33E9,$0000,$0001,$7FAE,$33E9,$0002,$0001
	dc.w	$7FB0,$E540,$41FA,$0080,$4A79,$0001,$8BF8,$6700
	dc.w	$0006,$41FA,$0092,$33F0,$0000,$0001,$7FA6,$33F0
	dc.w	$0002,$0001,$7FA8,$4A79,$0001,$8BF8,$6700,$00FA
	dc.w	$0C40,$0004,$6700,$000E,$0C40,$0018,$6700,$0006
	dc.w	$6000,$001A,$33F9,$0001,$7FA6,$0001,$7FAA,$33F9
	dc.w	$0001,$7FA8,$0001,$7FAC,$6000,$00CE,$0C40,$0008
	dc.w	$6700,$000E,$0C40,$001C,$6700,$0006,$6000,$00BA
	dc.w	$33F9,$0001,$7FA6,$0001,$7FAA,$33FC,$0000,$0001
	dc.w	$7FAC,$6000,$00A4,$0001,$0000,$0001,$0001,$0001
	dc.w	$0002,$0002,$0001,$0002,$0000,$0002,$0002,$0002
	dc.w	$0001,$0001,$0002,$0001,$0000,$0001,$0002,$0001
	dc.w	$0002,$0001,$0001,$0001,$0002,$0002,$0000,$0002
	dc.w	$0001,$0002,$0001,$0002,$0002,$0002,$0001,$3039
	dc.w	$0001,$8BFC,$E540,$41FA,$0056,$33F0,$0000,$0001
	dc.w	$7FA6,$33F0,$0002,$0001,$7FA8,$0C40,$0014,$6600
	dc.w	$0018,$33F9,$0001,$7FA6,$0001,$7FAA,$33FC,$0000
	dc.w	$0001,$7FAC,$6000,$001E,$0C40,$0018,$6600,$0016
	dc.w	$33F9,$0001,$7FA6,$0001,$7FAA,$33F9,$0001,$7FA8
	dc.w	$0001,$7FAC,$6100,$0024,$4CDF,$030F,$4E75,$0000
	dc.w	$0000,$0001,$0000,$0002,$0000,$0001,$0001,$0001
	dc.w	$0002,$0001,$0002,$0001,$0002,$50F9,$0001,$8A98
	dc.w	$4283,$3239,$0001,$7FAE,$03C3,$3239,$0001,$7FB0
	dc.w	$03C3,$227C,$0001,$8A18,$7407,$6100,$0018,$3340
	dc.w	$0000,$6100,$0010,$3340,$0002,$D2FC,$0010,$51CA
	dc.w	$FFEA,$4E75,$701A,$4EB9,$0003,$7050,$01C3,$6600
	dc.w	$FFF4,$4E75,$7004,$41EB,$000A,$3F20,$51C8,$FFFC
	dc.w	$7407,$227C,$0001,$8A88,$08A9,$0002,$000E,$7005
	dc.w	$6100,$0264,$3340,$0006,$0C40,$0004,$6600,$0008
	dc.w	$08E9,$0002,$000E,$7005,$6100,$024C,$3340,$0004
	dc.w	$0C40,$0004,$6600,$0008,$08E9,$0002,$000E,$92FC
	dc.w	$0010,$51CA,$FFC4,$303C,$4000,$6100,$022A,$33C0
	dc.w	$0001,$8AA4,$303C,$0008,$6100,$021C,$33C0,$0001
	dc.w	$8AA2,$4A79,$0001,$8BF8,$6700,$002E,$0C79,$0001
	dc.w	$0001,$8AA2,$6600,$000E,$33FC,$0003,$0001,$8AA2
	dc.w	$6000,$0016,$0C79,$0002,$0001,$8AA2,$6600,$000A
	dc.w	$33FC,$0004,$0001,$8AA2,$7010,$6100,$01DA,$33C0
	dc.w	$0001,$8AA0,$7004,$6100,$01CE,$33C0,$0001,$8A9E
	dc.w	$7008,$6100,$01C2,$33C0,$0001,$8A9C,$7020,$6100
	dc.w	$01B6,$33C0,$0001,$8A9A,$7004,$41D3,$30DF,$51C8
	dc.w	$FFFC,$4E75
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
	bsr.w	X_2579C
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
	bsr.w	X_2579C
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
	dc.w	$204B,$7004,$4258,$51C8,$FFFC,$4E75
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
	bsr.w	X_25CAC
	movea.l	a3,a2
	lea.l	-$366(a2),a3		;a3 = home team
	bsr.w	X_25CAC		;away (d3 = away - home score)
	cmpi.w	#$3,$180E4.l		;overtime?
	bne.w	.x
	tst.w	d3
	beq.w	.x
	movea.l	#$180EC,a0		;+ ScoreSumbytes = last goal entry
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
