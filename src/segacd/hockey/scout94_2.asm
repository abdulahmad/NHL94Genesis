;	HOCKEY.BIN $D398-$E1CD (runtime $28398-$291CD): scout94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	Part 2 of scout94 ($D2B6-$D397 before it is src/segacd/scoutopen.asm, the scouting screen open).
;	CD: the scouting report screen is largely new (the CD reads the report aloud; docs/segacd_announce.md);
;	waitx became the BIOS call at $6044.

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

CalcAttrib	equ	$2610C
DrawPlayerPicture	equ	$26276
PrintPlayerNameRight	equ	$2948E
GetTeamRating	equ	$2A024
UnpackPicture	equ	$2A902
AttribAdjust	equ	$2AE82
TeamLogoPalettes	equ	$2AF56
dobitmap	equ	$387E2
DecompressGraphicsWithRemap	equ	$38946
DecompressGraphicsPlain	equ	$38958
eraser	equ	$38C06
Framer	equ	$38CA0
printsmallz	equ	$38D8C
printsmall	equ	$38D9E
printz	equ	$38F6E
PushNumberWidth	equ	$3919A
printbigz	equ	$39258
AddSmallFont	equ	$393E8
InitScoutingDisplay	equ	$3F86C
UpdateScoutingDisplay	equ	$3F890
PAttribOverallMask	equ	$41C70
GAttribOverallMask	equ	$41DD2
PicturePalette	equ	$428A0
waitx	equ	$372D0
ReadJoy1	equ	$374F0
ReadJoy2	equ	$3750E
vb2	equ	$3DB90

	org	$28398

ScoutingReport						;CD: its first lines have no twin; the rest of it starts here
	dc.l	$05431567,$79ABCDEF		;remap table
	jsr	(AddSmallFont).l
	move.w	d4,(smallfont2chars).l	;1st vram char of the 2nd small font set
;CD: no cartridge twin
	movea.l	(SmallFontMapPtr).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
	dc.w	$0A23,$4567
	or.l	d4,-$3211(a3)
	movea.l	(FramerMapPtr).l,a2
	addq.l	#$8,a2
	move.w	d4,(framercset).l
	jsr	(DecompressGraphicsWithRemap).l
	dc.l	$05422561,$89ABCDEF		;remap table
	jsr	(printz).l
	String	CC_Font2,0,0
;CD: no cartridge twin
	movea.l	(EASportsBGMapPtr).l,a0
	movea.l	a0,a1					;a1 = map header
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1				;a1 = map data
	clr.w	d0
	clr.w	d1
	moveq	#$28,d2					;40 x 28 background
	moveq	#$1C,d3
	moveq	#3,d5					;color fam 1-2
	jsr	(dobitmap).l
	jsr	(printbigz).l
	String	CC_Font1Pal2,$C,$D,'MATCHUPS'
	move.w	#0,(printfontset).l
	jsr	(printz).l					;map at the header
	String	CC_Font1,$10,$11,'ADVANTAGE:'
	jsr	(printz).l					;map at the box
	String	CC_Font2Pal2,6,3
	moveq	#$21,d0					;33 x 9 text box frame
	moveq	#9,d1
	jsr	(Framer).l
	jsr	(printz).l					;map at the visitors picture
	String	CC_Font2Pal2,1,$E		;(and dropped a word)
	move.w	#8,d0					;8 x 8 frame: visitors picture
	move.w	#8,d1
	jsr	(Framer).l
	jsr	(printz).l					;map at the home picture
	String	CC_Font2Pal2,$1F,$E		;(and dropped a word)
	move.w	#8,d0					;8 x 8 frame: home picture
	move.w	#8,d1
	jsr	(Framer).l
	jsr	(printz).l					;map at Ron Barr
	String	CC_Font1,1,1
;CD: no cartridge twin
	movea.l	(RonBarrMapPtr).l,a0
	movea.l	a0,a1					;a1 = map header
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1				;a1 = map data
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	mapheight(a1),d3
	moveq	#$C,d5					;color fam 3-4
	jsr	(dobitmap).l
;CD: no cartridge twin
	movea.l	(HotMapPtr).l,a2
	adda.l	#$8,a2
	move.w	d4,$1AD86.l
	jsr	(DecompressGraphicsPlain).l
	movea.l	(ColdMapPtr).l,a2
	adda.l	#$8,a2
	move.w	d4,(coldiconchars).l	;tiles: 1st vram char
	jsr	(DecompressGraphicsPlain).l
	clr.w	(matchup).l				;matchup 0: the teams
	clr.w	(scoutunused).l
	move.w	#$10D,(matchuptimer).l	;frames to the next matchup
	bsr.w	GetMatchupPlayers		;the matchup players
	bsr.w	DrawMatchupPictures
	bsr.w	PrintMatchupRatings
;CD: no cartridge twin
	move.w	#$3,$1A446.l
	move.w	#$0,$1A448.l
	bsr.w	PrintAdvantageMarks
	move.w	#$18,(palcount).l
	move.l	#vb2,(VBint).l
	bset.b	#$5,$FF800F.l
.L2852E
	tst.w	(palcount).l
	bpl.w	.L2852E
	jsr	(InitScoutingDisplay).l		;a0 = the paragraph list
	move.w	#$1B,(a0)+				;paragraph numbers in ScoutingReportText: 'Hi, I'm Ron Barr ...'
	move.w	#$1D,(a0)+				;empty paragraph: a blank line
	move.w	#$1A,(a0)+				;'Welcome to a sold out ^ ...'
	move.w	#$1D,(a0)+				;blank line
;CD: no cartridge twin
	move.w	(HomeTeam).l,d0
	move.w	#$24,(a0)+
	move.w	#$1D,(a0)+
	move.w	d0,d1
	mulu.w	#$7,d1
	addi.w	#$26,d1
	move.w	d1,(a0)+
	move.w	#$1D,(a0)+
	move.w	#$1D,(a0)+
	move.w	(VisTeam).l,d0
	mulu.w	#$7,d0
	addi.w	#$26,d0
	move.w	d0,(a0)+
	move.w	#$1D,(a0)+
	move.w	#$1D,(a0)+
	move.l	d2,-(sp)
	move.w	d1,d2
	addq.w	#$1,d2
	ori.w	#$8000,d2
	move.w	d2,(a0)+
	move.w	#$1D,(a0)+
	move.w	d0,d2
	addq.w	#$1,d2
	move.w	d2,(a0)+
	move.w	#$1D,(a0)+
	move.w	d1,d2
	addq.w	#$5,d2
	ori.w	#$8000,d2
	move.w	d2,(a0)+
	move.w	#$1D,(a0)+
	move.w	d0,d2
	addq.w	#$5,d2
	move.w	d2,(a0)+
	move.w	#$1D,(a0)+
	move.w	d1,d2
	addq.w	#$6,d2
	ori.w	#$8000,d2
	move.w	d2,(a0)+
	move.w	#$1D,(a0)+
	move.w	d0,d2
	addq.w	#$6,d2
	move.w	d2,(a0)+
	move.w	#$1D,(a0)+
	move.w	d1,d2
	addq.w	#$3,d2
	ori.w	#$8000,d2
	move.w	d2,(a0)+
	move.w	#$1D,(a0)+
	move.w	d0,d2
	addq.w	#$3,d2
	move.w	d2,(a0)+
	move.w	#$1D,(a0)+
	move.w	d1,d2
	addq.w	#$2,d2
	ori.w	#$8000,d2
	move.w	d2,(a0)+
	move.w	#$1D,(a0)+
	move.w	d0,d2
	addq.w	#$2,d2
	move.w	d2,(a0)+
	move.w	#$1D,(a0)+
	move.w	d1,d2
	addq.w	#$4,d2
	ori.w	#$8000,d2
	move.w	d2,(a0)+
	move.w	#$1D,(a0)+
	move.w	d0,d2
	addq.w	#$4,d2
	move.w	d2,(a0)+
	move.w	#$1D,(a0)+
	move.l	(sp)+,d2
	move.w	#$21,(a0)+				;'Hit the start button ...'
	move.w	#$FFFF,(a0)
	clr.w	(asv).l
	move.w	#$7FFF,(screentimer).l	;frames left on the screen
	move.l	#$8CA0,(scoutwait).l	;then 36000 more when OptNOP is not 0
;CD: no cartridge twin
	jsr	$37652.l
.L28642
	btst.b	#$7,$FF800E.l
	bne.s	.L28642
	move.w	#$3C,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2865C
	btst.b	#$6,$FF800E.l
	beq.s	.L2865C
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L28676
	btst.b	#$6,$FF800E.l
	bne.s	.L28676
	bclr.b	#$7,$FF800F.l
	bclr.b	#$5,$FF800F.l
	move.w	#$F,d7
	jsr	$6044.w
	move.w	#$0,$17466.l
.L286A0
	movea.l	#$0,a0
	move.w	#$9,d0
	move.w	#$10,d7
	jsr	$6044.w
	tst.w	d0
	beq.w	.L286A0
	movea.l	#$FFFFFFFF,a0
	move.w	#$9,d0
	move.w	#$10,d7
	jsr	$6044.w
	move.w	#$0,$1A456.l
	move.w	$1A454.l,d0
	movea.l	#TestList,a0
	move.w	(a0,d0.w),d1
	btst	#$F,d1
	beq.s	.L28720
	bclr	#$F,d1
	move.w	d1,(a0,d0.w)
	move.l	d1,-(sp)
	move.w	#$1,d0
	bclr.b	#$3,$FF8033.l
	bsr.w	PageMatchup
	bset.b	#$3,$FF8033.l
	move.w	#$3,$1A446.l
	move.w	#$0,$1A448.l
	bsr.w	PrintAdvantageMarks
	move.l	(sp)+,d1
.L28720
	move.l	d1,d0
	cmpi.w	#$21,d0
	bne.s	.L28730
	move.w	#$1,$17466.l
.L28730
	bsr.w	.L289EC
	move.l	d0,$17462.l
	move.l	d1,-(sp)
	jsr	(ReadJoy1).l
	move.w	d3,d5
	jsr	(ReadJoy2).l
	or.w	d3,d5
	btst.b	#$1,$1AD77.l
	bne.w	.L28870
	move.l	(sp)+,d1
.L2875A
	btst.b	#$7,$FF800E.l
	bne.s	.L2875A
	move.w	#$2E,$FF8020.l
	bset.b	#$6,$FF800F.l
.L28774
	btst.b	#$6,$FF800E.l
	beq.s	.L28774
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2878E
	btst.b	#$6,$FF800E.l
	bne.s	.L2878E
	bclr.b	#$7,$FF800F.l
	bset.b	#$5,$FF800F.l
	movea.l	#$FF8000,a5
	move.l	d1,d3
	asl.w	#$3,d1
	movea.l	(ScoutingSpeechClipsPtr).l,a0
	move.l	(a0,d1.w),d2
	move.l	$4(a0,d1.w),d1
	move.w	#$6,d7
	jsr	$6044.w
	move.l	a0,d0
	move.w	#$0,d7
	jsr	$6044.w
	tst.w	$17466.l
	bne.s	.L28824
	move.w	$1A454.l,d0
	movea.l	#TestList,a0
.L287E6
	addi.w	#$2,d0
	move.w	(a0,d0.w),d1
	cmpi.w	#$1D,d1
	beq.w	.L287E6
	bclr	#$F,d1
	move.l	d1,d0
	bsr.w	.L289EC
	asl.w	#$3,d1
	movea.l	(ScoutingSpeechClipsPtr).l,a0
	move.l	(a0,d1.w),d2
	subi.w	#$2,d2
	move.l	d2,$47D60.l
	lea	$47D60.l,a0
	move.w	#$18,d0
	jsr	$5F22.w
.L28824
	bclr.b	#$5,$FF800F.l
	move.w	#$6,d7
	jsr	$6044.w
	cmpi.w	#$5A,d3
	beq.s	.L28858
	cmpi.w	#$3F1,d3
	beq.s	.L28858
	cmpi.w	#$97,d3
	beq.s	.L28858
	cmpi.w	#$392,d3
	beq.s	.L28858
	cmpi.w	#$405,d3
	beq.s	.L28858
	move.w	#$400,d1
	bra.s	.L2885C
.L28858
	move.w	#$380,d1
.L2885C
	move.w	#$9,d0
	move.w	#$FF,d2
	move.w	#$FFFF,d3
	move.w	#$10,d7
	jsr	$6044.w
.L28870
	move.l	#vb2,(VBint).l
	jsr	$21FC8.l
	bset.b	#$5,$FF800F.l
.top								;CD: placed where the disc branches to it
	moveq	#$0,d0
	jsr	(waitx).l
	btst.b	#$1,$1AD77.l
	beq.s	.L288AC
	movea.l	#$FFFFFFFF,a0
	move.w	#$9,d0
	move.w	#$10,d7
	jsr	$6044.w						;d1 = new presses (CD: the cartridge has (waitx).l)
.L288AC
	subi.w	#1,(matchuptimer).l
	bpl.w	.2						;not run out
	move.w	#$10E,(matchuptimer).l	;restart
.2									;timer counted
	bsr.w	PrintAdvantageMarks
	btst	#sbut,d1				;Start?
	bne.w	.exit
	cmpi.w	#$10E,(matchuptimer).l
	beq.w	.3						;timer ran out: next matchup
	btst	#cbut,d1				;C?
	beq.w	.4
	move.w	#$7FFF,(screentimer).l	;restart the screen timer
	move.l	#$8CA0,(scoutwait).l
.3									;next matchup
	bsr.w	RestartAdvantageMarks
	move.w	#1,d0					;next matchup
;CD: no cartridge twin
	tst.w	$17466.l
	beq.s	.L28906
	bsr.w	PageMatchup
.L28906
	bra.w	.6
.4									;cbut clear
	btst	#abut,d1				;A?
	beq.w	.5
	move.w	#$7FFF,(screentimer).l	;restart the screen timer
	move.l	#$8CA0,(scoutwait).l
	bsr.w	RestartAdvantageMarks
;CD: no cartridge twin
	tst.w	$17466.l
	beq.s	.L28934
	bsr.w	PageMatchup
.L28934
	bra.w	.6
.5									;abut clear
	clr.w	(asv).l					;normal text speed
	btst	#dbut,d1				;down?
	beq.w	.6
	st.b	(asv).l					;down: type the rest without delays
.6									;down held?
	btst.b	#1,(waitxpad+1).l		;down held (waitx pad bits)
	beq.w	.upd
	st.b	(asv).l
.upd								;show the next text
	jsr	(UpdateScoutingDisplay).l
;CD: no cartridge twin
	tst.w	$17466.l
	bne.s	.L2899A
	cmpi.w	#$FF00,(PlayerScrollCtr).l
	bne.s	.L2899A
	move.l	#$A9,$17462.l
	move.w	$1A454.l,d0
	movea.l	#TestList,a0
	move.w	(a0,d0.w),d0
	cmpi.w	#$1D,d0
	beq.s	.L2899A
	bra.w	.L286A0
.L2899A
	subi.w	#1,(screentimer).l
	bpl.w	.top
	tst.w	(OptNOP).l
	beq.w	.exit					;OptNOP 0: leave when the text is done
	move.w	#$FFFF,(screentimer).l	;else wait for start, up to scoutwait frames
	subi.l	#1,(scoutwait).l
	bpl.w	.top
;CD: no cartridge twin
	beq.w	.top
.exit								;CD: placed where the disc branches to it
	movea.l	#$FFFFFFFF,a0
	move.w	#$9,d0
	move.w	#$10,d7
	jsr	$6044.w
	move.w	#$0,(printfontset).l
	movea.l	(GameSetUpMapPtr).l,sp
	rts
.L289EC
	cmpi.w	#$1A,d0
	bne.s	.L28A1C
	move.w	#$EA,d0
	cmpi.w	#$1A,(HomeTeam).l
	bge.s	.L28A08
	add.w	(HomeTeam).l,d0
	bra.s	.L28A1C
.L28A08
	cmpi.w	#$1A,(VisTeam).l
	bge.s	.L28A18
	addi.w	#$1A,d0
	bra.s	.L28A1C
.L28A18
	addi.w	#$1B,d0
.L28A1C
	movea.l	(ScoutingReportTextPtr).l,a1
	movea.l	a1,a2
	move.w	#$0,d1
	bra.w	.L28A4A
.L28A2C
	addq.w	#$1,d1
.L28A2E
	cmpi.b	#$D,(a2)+
	bne.w	.L28A2E
	cmpi.b	#$A,(a2)
	bne.w	.L28A4A
	addq.l	#$1,a2
	cmpi.b	#$21,-$3(a2)
	beq.w	.L28A2C
.L28A4A
	dbf	d0,.L28A2C
	suba.l	a1,a2
	move.l	a2,d0
	rts
PageMatchup							;Page the matchup by d0 (+1 / -1, 0-6 wrapping), restart the page timer
									;and redraw. Called from ScoutingReport
	move.w	#$10E,(matchuptimer).l	;restart the matchup timer
	add.w	(matchup).l,d0
	bmi.w	.0						;below 0: wrap to 6
	cmpi.w	#7,d0					;past 6?
	blt.w	.1
	clr.w	d0
	bra.w	.1
.0									;d0 negative
	move.w	#6,d0
.1									;set the matchup
	move.w	d0,(matchup).l
	bsr.w	GetMatchupPlayers
	bsr.w	DrawMatchupPictures
;CD: no cartridge twin
	move.w	(Vcount).l,d0
.L28A8C
	cmp.w	(Vcount).l,d0
	beq.s	.L28A8C
.L28A94
	btst.b	#$7,$FF800E.l
	bne.s	.L28A94
	move.w	#$3C,$FF8020.l
	bset.b	#$6,$FF800F.l
.L28AAE
	btst.b	#$6,$FF800E.l
	beq.s	.L28AAE
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L28AC8
	btst.b	#$6,$FF800E.l
	bne.s	.L28AC8
	bclr.b	#$7,$FF800F.l
	bsr.w	PrintMatchupRatings
	rts
PrintMatchupRating					;Print the team rating of team a0 (GetTeamRating: the TeamRatings byte for
									;team number tmteam(a0)) as 2 digits at printx / printy; return d0 = the
									;rating.
									;Called from PrintMatchupRatings
	bsr.w	PrintTwoSpaces			;clear the old number
	move.l	a2,-(sp)
	movea.l	a0,a2
	bsr.w	GetTeamRating
	movea.l	(sp)+,a2
	move.l	d0,-(sp)
	move.w	#2,d1					;2 digits
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l				;print it
	move.l	(sp)+,d0
	rts
PrintTwoSpaces						;Print 2 spaces at printx / printy and keep printx
	move.l	a1,-(sp)
	move.w	(printx).l,-(sp)
	movea.l	#TwoSpacesTxt,a1
	jsr	(printsmall).l				;print them
	move.w	(sp)+,(printx).l
	movea.l	(sp)+,a1
	rts
TwoSpacesTxt						;A two space String (printsmall by PrintTwoSpaces)
	String	'  '
ScoutRatingText						;rating names; only ' Overall ' is printed (PrintMatchupRatings, matchup
									;0); -1 ends the list
	String	'Shooting'
	String	'Skating'
	String	'Passing'
	String	'Defense'
	String	'Checking'
	String	'Fighting'
	String	'Goalkeeping'
	String	'Power Play Adv.'
	String	'-    Home Team Adv.    '
	String	'    Overall     '
	dc.w	-1
DrawMatchupPictures					;Draw the matchup's 6 x 6 pictures, visitors at x 2, home at x $20, y $F:
									;matchup 0 the team logos (GetTeamLogo, DrawMatchupLogo)
									;1-6 the two players' pictures (DrawPlayerPicture, DrawMatchupPicture).
									;Called from ScoutingReport and PageMatchup
	movem.l	d0-d7/a0-a6,-(sp)
	tst.w	(matchup).l				;the teams?
	bne.w	.0
	move.w	(VisTeam).l,d3
	bsr.w	GetTeamLogo				;a0 = visitors logo
	move.w	#2,(printx).l
	move.w	#$F,(printy).l
	move.w	(vispicchars).l,d4
	move.w	#4,d5
	move.w	#$6000,(printa).l
	bsr.w	DrawMatchupLogo
	move.w	(HomeTeam).l,d3
	bsr.w	GetTeamLogo				;a0 = home logo
	move.w	#$20,(printx).l
	move.w	#$F,(printy).l
	move.w	(homepicchars).l,d4
	move.w	#0,(printa).l
	move.w	#2,d5
	bsr.w	DrawMatchupLogo
	move.w	#$64,(palcount).l
	bra.w	.x
.0									;matchup <> 0
	move.w	(VisTeam).l,d1
	move.w	(matchupvis).l,d0		;matchup player
	jsr	(DrawPlayerPicture).l		;a0 = picture of player d0 of team d1 (visitors)
	move.w	#2,(printx).l
	move.w	#$F,(printy).l
	move.w	(vispicchars).l,d4
	move.w	#2,d5					;palette line 2
	move.w	#0,(printa).l
	bsr.w	DrawMatchupPicture
	move.w	(HomeTeam).l,d1
	move.w	(matchuphome).l,d0		;matchup player
	jsr	(DrawPlayerPicture).l
	move.w	#$20,(printx).l
	move.w	#$F,(printy).l
	move.w	(homepicchars).l,d4
	move.w	#0,d5					;palette line 0
	move.w	#0,(printa).l
	bsr.w	DrawMatchupPicture
	move.w	#$64,(palcount).l
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a6
	rts
DrawMatchupPicture					;Draw player picture a0 at printx / printy with the PicturePalette
									;palette. A picture with no map (offset 0) uses the PicturePalette map.
									;UnpackPicture, then the picturebuf tiles. Falls into DrawMatchupBitmap
	movea.l	a0,a1					;a1 = map header
	movea.l	a0,a2
	adda.l	(a2)+,a0				;skip the palette offset
	movea.l	#PicturePalette,a0
	adda.l	(a0),a0
	tst.l	(a2)					;no map?
	bne.w	.0
	movea.l	#PicturePalette,a1
	adda.l	jimdata(a1),a1
	tst.l	(a2)+
	bra.w	.1
.0									;a2 <> 0
	adda.l	(a2)+,a1
.1									;unpack the logo
	bsr.w	UnpackPicture
	movea.l	#picturebuf,a2
	bra.w	DrawMatchupBitmap
DrawMatchupLogo						;Draw team logo a0 at printx / printy, palette TeamLogoPalettes + team d3
									;* 8 - $20 (d5 = 4: - $40). Falls into DrawMatchupBitmap
	movea.l	a0,a1					;a1 = map header
	movea.l	a0,a2
	adda.l	(a2)+,a0				;skip the palette offset
	asl.w	#3,d3					;8 bytes per team
	cmpi.w	#4,d5					;visitors?
	beq.w	.0
	subi.w	#$20,d3
	bra.w	.1
.0									;d5 = 4
	subi.w	#$40,d3
.1									;palette offset chosen
	movea.l	#TeamLogoPalettes,a0
	adda.w	d3,a0
	adda.l	(a2)+,a1
DrawMatchupBitmap					;6 x 6 dobitmap, then erase the 8 x 3 name area at y $19 on that side (x 2
									;or $20). Branched to from DrawMatchupPicture
	move.w	#6,d3
	move.w	#6,d2
	clr.w	d0
	clr.w	d1
	jsr	(dobitmap).l
	cmpi.w	#$14,(printx).l			;right side?
	bgt.w	.0
	move.w	#2,(printx).l
	bra.w	.1
.0									;printx > $14
	move.w	#$20,(printx).l
.1									;print x chosen
	move.w	#$19,(printy).l
	move.w	#8,d0
	move.w	#3,d1
	move.w	#$7FF,d2				;blank char
	jsr	(eraser).l					;erase the name area
	rts
GetTeamLogo							;Return a0 = the logo bitmap of team d3 (TeamLogoBitmaps table)
	asl.w	#2,d3
;CD: no cartridge twin
	movea.l	(TeamLogoBitmapsPtr).l,a0
	movea.l	(a0,d3.w),a0			;its logo
	rts
PrintMatchupRatings					;Print the matchup ratings. Matchup 0: 'Overall' at y $13, the team
									;ratings (PrintMatchupRating), home at x $22, visitors at x 4, y $16. 1-6:
									;the position name at y $13, the player names on y $17
									;(PrintPlayerNameRight; home right justified), and the player ratings at x
									;$22 / 4, y $16: CalcAttrib with the PAttribOverallMask (skater) or
									;GAttribOverallMask (goalie) long in d4, * 100 / d1, AttribAdjust. The
									;ratings go to homerating (home) / visrating (visitors) for
									;PrintAdvantageMarks. Called from ScoutingReport and PageMatchup
	tst.w	(matchup).l				;the teams?
	bne.w	.matchup
	jsr	(printsmallz).l				;map at the title
	String	CC_SetMapAndPosition,0,1,$16,$16,CC_SetFont,1
	lea	ScoutRatingText(pc),a1
	move.w	#0,d7					;line 0
.loop								;loop
	move.w	(a1),d0
	asr.w	#1,d0
	neg.w	d0
	addi.w	#$16,d0					;center on column 22
	move.w	d0,(printx).l
	cmpi.w	#9,d7					;only the 10th, 'Overall'
	beq.w	.0
	adda.w	(a1),a1
	bra.w	.1
.0									;d7 = 9
	move.w	#2,(printfontset).l
	move.w	(printy).l,-(sp)
	subi.w	#3,(printy).l
	jsr	(printsmall).l				;print it
	move.w	(sp)+,(printy).l
.1									;next line
	addi.w	#1,d7
	tst.w	(a1)					;more?
	bpl.w	.loop
	move.w	#2,(printfontset).l
	jsr	(printz).l					;map at the home rating
	String	CC_Font1,0,$17,'                                        '	;40 spaces
	jsr	(printz).l					;its position
	String	CC_Font1,$22,$16
	movea.l	#tmstruct,a0
	movea.l	#awtmstruct,a2
	bsr.w	PrintMatchupRating
	move.w	d0,(homerating).l
	move.w	#2,(printfontset).l
	jsr	(printz).l					;map at the visitors rating
	String	CC_Font1,4,$16
	exg	a0,a2
	bsr.w	PrintMatchupRating
	move.w	d0,(visrating).l
	bra.w	.x
.matchup							;matchup <> 0
	move.w	(matchup).l,d0
	subi.w	#1,d0
	movea.l	#MatchupPosNames,a1		;position name of matchup - 1
	bra.w	.3
.loop2								;skip one name
	adda.w	(a1),a1
.3									;loop the skip
	dbf	d0,.loop2
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,0,1,$D,$13,CC_SetFont,1
	jsr	(printsmall).l				;print it
	move.w	#$16,(printy).l
	move.w	#2,(printfontset).l
	movea.l	#tmstruct,a2
	move.l	(PAttribOverallMask).l,d4	;skater rating weights
	tst.w	(matchupslot).l			;line slot 0: goalie
	bne.w	.4
	move.l	(GAttribOverallMask).l,d4
.4									;rating weights chosen
	move.w	(matchuphome).l,d0
	jsr	(printz).l
	String	CC_Font1,0,$17,'                                        '	;40 spaces
	jsr	(printz).l					;its position
	String	CC_Font1,$23,$17
	bsr.w	PrintPlayerNameRight	;print the name, moved left to fit the line
	bsr.w	CalcAttrib				;d0 = weighted total, d1 = weights
	mulu.w	#$64,d0
	divu.w	d1,d0
	bsr.w	AttribAdjust
	move.w	#2,d1					;2 digits
	move.w	d0,(homerating).l
	jsr	(PushNumberWidth).l
	jsr	(printz).l					;map at the number
	String	CC_Font1,$22,$16
	bsr.w	PrintTwoSpaces			;clear the old number
	jsr	(printsmall).l				;print it
	movea.l	#awtmstruct,a2
	move.l	(PAttribOverallMask).l,d4	;skater rating weights
	tst.w	(matchupslot).l			;goalie?
	bne.w	.5
	move.l	(GAttribOverallMask).l,d4	;goalie weights
.5									;rating weights chosen
	move.w	(matchupvis).l,d0
	jsr	(printz).l					;map at the name
	String	CC_Font1,0,$17
	bsr.w	PrintPlayerNameRight
	bsr.w	CalcAttrib				;d0 = weighted total, d1 = weights
	mulu.w	#$64,d0
	divu.w	d1,d0
	bsr.w	AttribAdjust
	move.w	d0,(visrating).l
	move.w	#2,d1					;2 digits
	jsr	(PushNumberWidth).l
	jsr	(printz).l					;map at the number
	String	CC_Font1,4,$16
	bsr.w	PrintTwoSpaces			;clear the old number
	jsr	(printsmall).l				;print it
.x									;exit (also the end of the code above)
	rts
MatchupPosNames						;Position names of matchups 1-6
	String	'     center     '
	String	' left forward   '
	String	' right forward  '
	String	'left defenseman '
	String	'right defenseman'
	String	'     goalie     '
GetMatchupPlayers					;matchuphome / matchupvis = the home / visitors player of the matchup.
									;Called from ScoutingReport and PageMatchup
	movem.l	d0/a0-a1,-(sp)
	movea.l	#tmstruct,a0
	bsr.w	GetMatchupPlayer
	move.w	d0,(matchuphome).l
	movea.l	#awtmstruct,a0
	bsr.w	GetMatchupPlayer
	move.w	d0,(matchupvis).l
	movem.l	(sp)+,d0/a0-a1
	rts
GetMatchupPlayer					;Return d0 = the roster index of team a0's player for matchup: the first
									;line of the team's line sets, slot
									;MatchupLineSlots[matchup] (matchupslot; 0 goalie, 1 left defense, 2 right
									;defense, 3 left wing, 4 center, 5 right wing)
	movea.l	tmdata(a0),a0
	adda.w	LineSets(a0),a0
	move.w	(matchup).l,d0
	movea.l	#MatchupLineSlots,a1
	move.b	(a1,d0.w),d0
	ext.w	d0
	move.w	d0,(matchupslot).l
	move.b	(a0,d0.w),d0			;player number in the slot
	ext.w	d0
	subi.w	#1,d0					;player numbers start at 1
	rts
MatchupLineSlots					;Line slot by matchup 0-6 (0 for the teams, then 4 center, 3 left forward,
									;5 right forward, 1 left defense, 2 right defense,
									;0 goalie), and a pad byte
	dc.b	0,4,3,5,1,2,0,0
RestartAdvantageMarks				;Restart the advantage marks (PrintAdvantageMarks)
	clr.w	(advcount).l
	clr.w	(advframe).l			;first frame
	rts
PrintAdvantageMarks					;Called every frame by ScoutingReport. Print the advantage marks at x $13,
									;y $16: ']' marks growing toward the home
									;side (right) when the home rating is higher, '[' marks toward the
									;visitors (left) when lower, one more every 7 frames up to 3; blank if
									;equal
	movem.l	d0-d7/a0-a6,-(sp)
	addi.w	#1,(advcount).l
	cmpi.w	#7,(advcount).l			;7 frames?
	blt.w	.0
	clr.w	(advcount).l
	addi.w	#1,(advframe).l			;next mark frame
	cmpi.w	#6,(advframe).l			;past 5?
	blt.w	.0
	move.w	#5,(advframe).l			;stay on 5
.0									;frame set
	move.w	(advframe).l,d1			;frame
	asl.w	#2,d1
	movea.l	#HomeAdvMarks,a1
	move.w	(homerating).l,d0
	cmp.w	(visrating).l,d0
	bgt.w	.1
	beq.w	.2
	movea.l	#VisAdvMarks,a1
.1									;advantage marks chosen
	movea.l	(a1,d1.w),a1			;marks for the frame
	bra.w	.3						;print
.2									;even matchup
	movea.l	#EvenAdvTxt,a1
.3									;print the marks
	move.w	#2,(printfontset).l
	jsr	(printz).l					;map at the marks
	String	CC_Font1,$13,$16
	jsr	(printsmall).l				;print them
	move.w	#0,(printfontset).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
HomeAdvMarks						;Home advantage marks, by advframe (0-5)
	dc.l	HomeAdv0Txt,HomeAdv1Txt,HomeAdv2Txt,HomeAdv3Txt,HomeAdv3Txt,HomeAdv3Txt
VisAdvMarks							;Visitors advantage marks
	dc.l	VisAdv0Txt,VisAdv1Txt,VisAdv2Txt,VisAdv3Txt,VisAdv3Txt,VisAdv3Txt
HomeAdv0Txt	String	'   '			;home advantage marks: none
HomeAdv1Txt	String	']  '			;home advantage: one mark
HomeAdv2Txt	String	']] '			;home advantage: two marks
HomeAdv3Txt	String	']]]'			;home advantage: three marks
VisAdv0Txt	String	'   '			;visitors advantage marks: none
VisAdv1Txt	String	'  ['			;visitors advantage: one mark
VisAdv2Txt	String	' [['			;visitors advantage: two marks
VisAdv3Txt	String	'[[['			;visitors advantage: three marks
EvenAdvTxt	String	'   '			;Even teams
GetTeamNickname						;The text player's '=' (a2 = tmstruct) and '*' (awtmstruct): return a1 =
									;the
									;team nickname String, or 'Home' / 'Visitors' when it is empty (the all
									;star teams)
	movem.l	d0/a0/a2,-(sp)
	movea.l	a2,a1
	movea.l	tmdata(a1),a1
	adda.w	Teamname(a1),a1
	adda.w	(a1),a1
	adda.w	(a1),a1
	cmpi.w	#2,(a1)					;empty String?
	bne.w	.x
	movea.l	#HomeTxt,a1
	cmpa.l	#tmstruct,a2			;home team?
	beq.w	.x
	movea.l	#VisitorsTxt,a1
.x									;exit: restore the registers
	movem.l	(sp)+,d0/a0/a2
	rts
HomeTxt	String	'Home'				;name used when the home team has no nickname
VisitorsTxt	String	'Visitors'		;name used when the visiting team has no nickname
GetTeamArena						;The text player's '^' (a2 = tmstruct) and ';' (awtmstruct): return a1 =
									;the
									;team arena String
	movem.l	d0/a0/a2,-(sp)
	movea.l	a2,a1
	movea.l	tmdata(a1),a1
	adda.w	Teamname(a1),a1
	adda.w	(a1),a1
	adda.w	(a1),a1
	adda.w	(a1),a1
	movem.l	(sp)+,d0/a0/a2
	rts
ScoutStub							;An empty routine
	movem.l	d0-d7/a0-a6,-(sp)
	movem.l	(sp)+,d0-d7/a0-a6
	rts
