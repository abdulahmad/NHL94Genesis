;	HOCKEY.BIN $83CC-$9B5D (runtime $233CC-$24B5D): optsetup94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	The option logic and strings are the cartridge's.
;
;	CD: the graphics are not ROM labels any more: each movea.l #map / lea of a tile set became a load from a
;	pointer table at $47D00-$47D8C (file $2CD00, zeros on the disc, filled at run time), and the beam-counter
;	seed is command $1B to the main CPU (the word comes back in $FF8010).
;
;	The New York full names are read from the disc file.

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

TeamList	equ	$1B00C
ReadNameLog	equ	$2262E
ResetCardTimer	equ	$24B5E
PlayerCardTimer	equ	$24B7C
ClearShootout	equ	$279DA
ClearGameStats	equ	$29302
ReadLineData	equ	$2A58C
TeamLogoPalettes	equ	$2AF56
randomd0	equ	$37050
orjoy	equ	$37460
ProcessInputWithRepeat	equ	$374BE
ReadJoy1	equ	$374F0
ReadJoy2	equ	$3750E
ReadJoy3	equ	$3752C
ReadJoy4	equ	$3754A
setVram	equ	$37B5A
dobitmap	equ	$387E2
DecompressGraphicsWithRemap	equ	$38946
eraser	equ	$38C06
Framer	equ	$38CA0
printsmall	equ	$38D9E
printz	equ	$38F6E
print	equ	$38F80
defaultsprites_0	equ	$3EE84
UpdatePlayoffLevel	equ	$3FF16
TeamIcons	equ	$3FF4C
VBlank_SetOptions	equ	$400D0
ContinuePlayoffs	equ	$40132
NewPO	equ	$401C4
MakeTree	equ	$40244
FigureJoy	equ	$40318
ReadPassBits	equ	$4057C
DecompressGraphicsPlain	equ	$38958

	org	$233CC

;	Game setup screen. This file runs the option menu, starts a game or the demo, and prints each
;	option within its limits. New in 94: the goalie and user record options, the shootout, 4 Way
;	Play, and team logos on the setup screen.


;Options (d7 = line * 2, the offset from OptPlayMode): 0 OptPlayMode (Regular Season,
;Continue Playoffs, New Playoffs, New Playoffs/7 game, Shootout), 2 OptNOP, 4 Opt1team,
;6 Opt2team, 8 Optperlen, $A OptGoalie, $C OptUserRec (0 On), $E OptPen (0 Off), $10
;OptLine (0 On, 2 Auto). setupcardflags bits: 0 player card up, 1 card side (visitors),
;2 / 3 home / visitors block drawn, 5 C pressed, 6 / 7 home / visitors logo shown.
;printz String first byte, negated: low 2 bits = map, the rest << 9 = printa.

GameSetUp							;Game setup screen, called from PeriodOver. Builds the screen
									;(setoptions), then runs the menu: up / down move the frame, left / right
									;change the option (ChangeOption) and redraw (FixModeOptions), start
									;begins the game (SetupStart), and $5460 frames without a press start a
									;demo (SetupDemo).
	jsr	(ReadLineData).l			;read the line data
	movea.l	#passbits,a3			;saved playoff state
	jsr	(ReadPassBits).l			;read the playoff bits
	move.w	(TmpOptLine2).l,(OptLine).l	;undo the start changes of SetupStart (Auto line changes, Shootout)
	move.w	(TempOptPlayMode).l,(OptPlayMode).l	;restore the play mode
	bclr.b	#1,(sflags7).l			;no overtime
	jsr	(ClearGameStats).l
	jsr	(ReadNameLog).l				;read the SRAM name list
	bsr.w	setoptions				;build the screen
	clr.w	(setupfirstline).l		;first menu line shown
	clr.w	(setupprevline).l		;clear the previous first line
	bsr.w	PrintOptionNames
	tst.w	(demoflag).l			;clear after a demo
	bne.w	.shootout
	moveq	#NumTeams,d0
	jsr	(randomd0).l
	move.w	d0,(Opt1team).l			;random teams after a demo (0 through NumTeams-1)
	moveq	#NumTeams,d0
	jsr	(randomd0).l				;0 to NumTeams-1
	move.w	d0,(Opt2team).l
.shootout							;teams set (random after a demo)
	st.b	(demoflag).l
	cmpi.w	#4,(OptPlayMode).l
	bne.w	.newplay
	bra.w	.reggame
.newplay							;OptPlayMode <> 4
	cmpi.w	#2,(OptPlayMode).l		;check if new playoffs
	blt.w	.contplay				;league or continue playoffs
	bsr.w	GoNewPlayoffs			;new playoffs: random tree
.contplay							;playoffs set up
	cmpi.w	#1,(OptPlayMode).l		;check if cont playoffs
	bne.w	.reggame				;not continue playoffs
	bsr.w	GoContinuePlayoffs
.reggame							;any mode: start on the first line
	clr.w	d7						;menu line 0 (d7 = line * 2 = offset in OptPlayMode ... OptLine)
	clr.w	d0
	bsr.w	MoveMenuFrame			;frame the line
	bsr.w	FixModeOptions			;print the options
	move.w	(HomeTeam).l,(setuphome).l	;home in the block
	move.w	(HomeTeam).l,(logoteam).l	;logo of the home team
	bsr.w	DrawHomeBlock
	move.w	(VisTeam).l,(setupvis).l	;visitors in the block
	move.w	(VisTeam).l,(logoteam).l	;logo of the visitors
	bsr.w	DrawVisBlock
	move.w	#$18,(palcount).l
	bclr.b	#dfng,(disflags).l		;dfng: fade in graphics now
.loop								;loop
	cmpi.w	#4,(OptPlayMode).l		;Shootout: line changes Off, penalties Off, user records Off
	bne.w	.0
	move.w	#1,(OptLine).l			;line changes off
	move.w	#0,(OptPen).l			;penalties off
	move.w	#1,(OptUserRec).l		;user records off
.0									;shootout options forced
	bsr.w	ReadSetupPads			;d1 = new presses, 0 after $5460 frames
	tst.w	d1						;any press?
	bne.w	.1
	bra.w	SetupDemo
.1									;d1 <> 0
	btst	#sbut,d1				;Start?
	bne.w	SetupStart
	btst	#dbut,d1				;dbut: next line, past the lines that do not apply (Demo: Goalies, User
									;Records; Shootout: Per. Length, nothing after Goalies; no SRAM: User
									;Records)
	beq.w	.9
	tst.w	(OptNOP).l				;no players (demo)?
	bne.w	.2
	cmpi.w	#8,d7					;on the period length line?
	bne.w	.2						;not the period length line
	move.w	#4,d0					;skip a line
	bra.w	.3
.2									;OptNOP <> 0 or d7 <> 8
	move.w	#2,d0					;one line down
.3									;frame size chosen
	cmpi.w	#4,(OptPlayMode).l		;shootout?
	beq.w	.4
	tst.w	(OptNOP).l				;no players (demo)?
	bne.w	.4
	cmpi.w	#8,d7					;on the period length line?
	bne.w	.4						;not the period length line
	move.w	#6,d0					;skip 3 lines
	bra.w	.8
.4									;next line check
	cmpi.w	#6,d7					;on the 2nd team line?
	bne.w	.5						;not the 2nd team line
	cmpi.w	#4,(OptPlayMode).l		;shootout?
	bne.w	.5
	tst.w	(OptNOP).l				;no players (demo)?
	bne.w	.7
	clr.w	d0						;stay on the line
	bra.w	.8
.5									;d7 <> 6 or OptPlayMode <> 4
	cmpi.w	#$A,d7					;on the goalie line?
	bne.w	.8						;not the goalie line
	cmpi.w	#4,(OptPlayMode).l		;shootout?
	bne.w	.6
	clr.w	d0						;shootout: stay
	bra.w	.8
.6									;OptPlayMode <> 4
	tst.w	(ValidSRAM).l			;save RAM?
	bpl.w	.8
.7									;no save RAM: smaller frame
	move.w	#4,d0					;4 lines
.8									;move the frame
	bsr.w	MoveMenuFrame
	bsr.w	FixModeOptions			;print the options
	bra.w	.loop
.9									;dbut clear
	btst	#ubut,d1				;ubut: previous line, the same skips
	beq.w	.15						;not up: left / right
	tst.w	(OptNOP).l				;demo (no pads)?
	bne.w	.10
	cmpi.w	#$C,d7					;on the user records line?
	bne.w	.10						;not the user records line
	move.w	#$FFFC,d0				;skip a line
	bra.w	.11
.10									;OptNOP <> 0 or d7 <> $C
	move.w	#$FFFE,d0				;one line up
	cmpi.w	#4,(OptPlayMode).l		;shootout?
	beq.w	.11						;shootout: one line
	tst.w	(OptNOP).l				;players?
	bne.w	.11						;players: move one line
	cmpi.w	#$E,d7					;on the penalties line?
	bne.w	.11						;not the penalties line
	move.w	#$FFFA,d0				;skip 3 lines
	bra.w	.14
.11									;next line check
	cmpi.w	#$A,d7					;on the goalie line?
	bne.w	.12						;not the goalie line
	cmpi.w	#4,(OptPlayMode).l		;shootout?
	beq.w	.13
.12									;not the shootout line
	cmpi.w	#$E,d7					;on the user records line?
	bne.w	.14						;not the line: move one line
	cmpi.w	#4,(OptPlayMode).l		;shootout?
	beq.w	.13
	tst.w	(ValidSRAM).l			;save RAM?
	bpl.w	.14						;save RAM: move one line
.13									;shootout or no save RAM: skip the line
	move.w	#$FFFC,d0				;skip a line
.14									;move the frame
	bsr.w	MoveMenuFrame
	bsr.w	FixModeOptions			;print the options
	bra.w	.loop
.15									;ubut clear
	moveq	#1,d2
	btst	#rbut,d1				;right?
	bne.w	.16
	btst	#lbut,d1				;left?
	beq.w	.loop					;neither: back to the loop
	moveq	#-1,d2
.16									;left or right: change the option
	cmpi.w	#4,(OptPlayMode).l		;shootout?
	beq.w	.17						;shootout: no pad setup
	jsr	(FigureJoy).l				;set up the pads
.17									;pad setup done
	move.w	(Opt2team).l,-(sp)		;save the old teams
	move.w	(Opt1team).l,-(sp)		;save the old teams
	bsr.w	ChangeOption			;change the option by d2
	move.w	(sp)+,d0				;old Opt1team
	cmpi.w	#4,(OptPlayMode).l		;shootout?
	beq.w	.18
	tst.w	(OptPlayMode).l			;league?
	bne.w	.19
.18									;league or shootout: the menu teams play
	move.w	(Opt1team).l,(HomeTeam).l	;Regular Season and Shootout: the menu teams
	move.w	(Opt2team).l,(VisTeam).l
.19									;teams set for the mode
	move.w	(HomeTeam).l,(logoteam).l	;logo of the home team
	btst.b	#6,(setupcardflags).l	;home logo shown?
	beq.w	.20
	movem.w	d0,-(sp)
	move.w	(setuphome).l,d0		;team in the block
	cmp.w	(HomeTeam).l,d0			;home team changed?
	movem.w	(sp)+,d0
	beq.w	.21						;same team: keep it
.20									;home team changed (or no logo yet): redraw its block
	move.w	(HomeTeam).l,(setuphome).l
	bsr.w	DrawHomeBlock
.21									;home block done
	btst.b	#7,(setupcardflags).l	;visitors logo shown?
	beq.w	.22
	movem.w	d0,-(sp)
	move.w	(setupvis).l,d0			;visitors on the screen
	cmp.w	(VisTeam).l,d0			;visitors changed?
	movem.w	(sp)+,d0
	beq.w	.23						;same team: keep it
.22									;visitors team changed (or no logo yet): redraw its block
	move.w	(VisTeam).l,(setupvis).l
	move.w	(VisTeam).l,(logoteam).l	;logo of the visitors
	bsr.w	DrawVisBlock
	move.w	(HomeTeam).l,(logoteam).l	;logo back to the home team
.23									;visitors block done
	tst.w	(sp)+					;drop the saved Opt2team
	bra.w	.fix
	move.w	(sp)+,d0				;unreferenced: an older copy of the team block update above
	cmp.w	(VisTeam).l,d0			;same as the visitors?
	beq.w	.fix
	move.w	(VisTeam).l,(logoteam).l	;logo of the visitors
	movem.w	d0,-(sp)
	move.w	(VisTeam).l,d0
	cmp.w	(VisTeam).l,d0
	movem.w	(sp)+,d0
	beq.w	.24
	move.w	(VisTeam).l,(setupvis).l
	bsr.w	DrawVisBlock			;redraw the visitors block
.24									;visitors block redrawn when the team changed
	movem.w	d0,-(sp)
	move.w	(setuphome).l,d0		;home on the screen
	cmp.w	(HomeTeam).l,d0			;home team changed?
	movem.w	(sp)+,d0
	beq.w	.fix
	move.w	(HomeTeam).l,(setuphome).l
	move.w	(HomeTeam).l,(logoteam).l	;logo of the home team
	bsr.w	DrawHomeBlock			;redraw the home block
	move.w	(VisTeam).l,(logoteam).l	;logo of the visitors
.fix								;redraw the options
	bsr.w	FixModeOptions			;print the options
	bra.w	.loop
	rts
GoNewPlayoffs						;New playoffs: jmp NewPO. Called from GameSetUp and ChangeOption
	jmp	(NewPO).l
GoContinuePlayoffs					;Continue playoffs: jmp ContinuePlayoffs. Called from GameSetUp
	jmp	(ContinuePlayoffs).l
MoveMenuFrame						;Move the menu frame by d0 (+2 / -2 lines). Shows 6 of the 9 lines and
									;scrolls: setupfirstline = first line shown
									;(0-3), setupprevline = the one before (sflags5 bit 2 set on a scroll;
									;FixModeOptions reprints the names when they differ). Continue playoffs
									;skips lines 1-3, new playoffs line 3 (Team 2). The old frame is erased by
									;redrawing the SetupMenuMap background under it. Called from GameSetUp
	move.w	d7,d3
.optionup							;loop
	bclr.b	#2,(sflags5).l			;not scrolled yet
	tst.w	d0						;direction?
	bpl.w	.optiondown
	move.w	d0,-(sp)
	move.w	d7,d0
	asr.w	#1,d0					;lines
	cmp.w	(setupfirstline).l,d0	;top line shown?
	bne.w	.noscroll				;not at the top of the frame
	move.w	(setupfirstline).l,(setupprevline).l
	bset.b	#2,(sflags5).l			;scrolled
	subi.w	#1,(setupfirstline).l
	bpl.w	.noscroll				;not above line 0
	clr.w	(setupfirstline).l		;clamp to line 0
.noscroll							;first line scrolled (not above 0)
	move.w	(sp)+,d0
.optiondown							;move the line cursor by d0
	move.w	d7,(TempWord1).l
	add.w	d0,d7
	bpl.w	.0						;not above line 0
	clr.w	d7						;clamp to line 0
.0									;line clamped at the top
	tst.w	d0						;moving?
	bmi.w	.3
	move.w	d0,-(sp)
	move.w	d7,d0
	asr.w	#1,d0					;lines
	sub.w	(setupfirstline).l,d0	;row in the frame
	cmpi.w	#5,d0					;past row 5?
	bgt.w	.scrolldown				;below the frame: scroll
	bra.w	.2
.scrolldown							;d0 > 5
	move.w	(setupfirstline).l,(setupprevline).l
	bset.b	#2,(sflags5).l			;scrolled
	addi.w	#1,(setupfirstline).l
	move.w	d7,d0
	asr.w	#1,d0
	sub.w	(setupfirstline).l,d0	;minus the first line shown
	cmpi.w	#5,d0					;still below the frame?
	ble.w	.1
	addi.w	#1,(setupfirstline).l	;scroll once more
.1									;first line moved down when needed
	cmpi.w	#3,(setupfirstline).l	;past line 3?
	ble.w	.2
	move.w	#3,(setupfirstline).l	;at most 3
.2									;first line clamped
	move.w	(sp)+,d0
.3									;moving up, or the scroll is done
	btst.b	#2,(sflags5).l			;scrolled?
	bne.w	.4
	move.w	(setupfirstline).l,(setupprevline).l	;no scroll: same first line
.4									;previous line kept for the redraw check
	cmpi.w	#$12,d7					;past the last line (Line Changes)
	blt.w	.contplayoffs
	sub.w	d0,d7
.contplayoffs						;line clamped at the bottom
	cmpi.w	#1,(OptPlayMode).l		;continuing playoffs?
	bne.w	.newplay
	tst.w	d7						;top line?
	beq.w	.newplay
	cmpi.w	#6,d7					;line 6 or above?
	bls.w	.optionup
.newplay							;not continuing playoffs, or the top line
	cmpi.w	#2,(OptPlayMode).l		;playoffs?
	blt.w	.5
	cmpi.w	#4,(OptPlayMode).l		;shootout?
	beq.w	.5
	cmpi.w	#6,d7					;line 6?
	beq.w	.optionup
.5									;line allowed
	bsr.w	SetMenuArea				;printx $10, printy $E, 23 x 13
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(setupmenuchars).l,d4
;CD: no cartridge twin
	movea.l	(SetupMenuMapPtr).l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1				;a1 = map data
	move.w	(printx).l,d0
	subi.w	#1,d0
	move.w	d1,d3
	move.w	(printy).l,d1
	subi.w	#$E,d1
	moveq	#$17,d2
	moveq	#0,d5					;no palette lines
	bset.b	#0,(sflags6).l
	jsr	(dobitmap).l
	bclr.b	#0,(sflags6).l			;normal maps
	movem.l	(sp)+,d0-d7/a0-a6
	move.w	d7,d3
	bsr.w	SetFrameRect			;the new frame
	move.w	#$6000,(printa).l
	jmp	(Framer).l					;draw the frame
SetMenuArea							;Set the menu area for MoveMenuFrame: printx $10, printy $E, d0 = 23 x d1
									;= 13
	jsr	(printz).l					;map at the menu
	String	CC_Font1,$10,$E			;(and dropped a word)
	move.w	#$17,d0
	move.w	#$D,d1
	rts
SetFrameRectUnused					;An unused copy of SetFrameRect without its printz that uses setupprevline
									;and stops at row $18
	add.w	d3,(printy).l
	move.w	(setupprevline).l,d0
	add.w	d0,d0					;2 rows a line
	sub.w	d0,(printy).l
	cmpi.w	#$18,(printy).l			;below row $18?
	ble.w	.0
	move.w	#$18,(printy).l
.0									;frame Y clamped
	moveq	#$17,d0
	moveq	#3,d1
	cmpi.w	#2,(OptPlayMode).l		;playoffs?
	blt.w	rtsSetup
	cmpi.w	#4,(OptPlayMode).l		;shootout?
	beq.w	rtsSetup
	cmpi.w	#4,d3					;line 4?
	bne.w	rtsSetup
	moveq	#5,d1
	rts
SetFrameRect						;Frame position for line d3 (row $E + d3 - setupfirstline * 2), 23 x 3, or
									;23 x 5 for Team 1 in new playoffs.
									;MoveMenuFrame
	jsr	(printz).l					;map at the first line
	String	CC_Font1,$10,$E			;(and dropped a word)
	add.w	d3,(printy).l			;2 rows per line
	move.w	(setupfirstline).l,d0
	add.w	d0,d0					;2 rows a line
	sub.w	d0,(printy).l
	moveq	#$17,d0
	moveq	#3,d1
	cmpi.w	#2,(OptPlayMode).l		;playoffs?
	blt.w	rtsSetup
	cmpi.w	#4,(OptPlayMode).l		;shootout?
	beq.w	rtsSetup
	cmpi.w	#4,d3					;line 4?
	bne.w	rtsSetup
	moveq	#5,d1
rtsSetup							;The shared rts; ChangeOption, PrintOptionValue, SetFrameRectUnused and
									;WrapOption branch to it
	rts
FixModeOptions						;Fix the options a mode does not allow, then print them: Shootout and Demo
									;set User Records Off, Demo sets both goalies to
									;Auto Control. Reprint the option names (PrintOptionNames) after a scroll,
									;then the values (PrintOptions) in the setup font (sflags6 bit 3:
									;printsmall uses setupfontchars). Called from GameSetUp
	movem.l	d0-d7/a0-a6,-(sp)
	cmpi.w	#4,(OptPlayMode).l		;shootout?
	bne.w	.0
	move.w	#1,(OptUserRec).l		;Off
.0									;shootout: user records off
	tst.w	(OptNOP).l				;one player?
	bne.w	.1
	move.w	#1,(OptUserRec).l		;Off
.1									;one player: user records off
	tst.w	(OptNOP).l				;one player?
	bne.w	.2
	move.w	#0,(OptGoalie).l		;goalie on auto
	move.w	#0,(goaliemode1).l		;player 1 auto
	move.w	#0,(goaliemode2).l		;player 2 auto
	tst.w	(OptNOP).l				;one player?
	bne.w	.2
	move.w	#1,(OptGoalie).l		;Auto Control
	move.w	#1,(goaliemode1).l		;both teams
	move.w	#1,(goaliemode2).l		;player 2 manual
.2									;one player: goalie on auto
	move.w	(setupfirstline).l,d0
	cmp.w	(setupprevline).l,d0	;moved?
	beq.w	.3
	bsr.w	PrintOptionNames
.3									;option names redrawn when the scroll moved
	bset.b	#3,(sflags6).l			;print all
	bsr.w	PrintOptions			;print the options
	bclr.b	#3,(sflags6).l			;normal
	movem.l	(sp)+,d0-d7/a0-a6
	rts
OptionLimits						;Number of values of each option
	dc.w	5,8,NumTeams,NumTeams,3,2,2,3,3
OptionLimits4Way					;The same with FourWayPlay (12 player choices)
	dc.w	5,$C,NumTeams,NumTeams,3,2,2,3,3
ChangeOption						;add d2 to option d7 (d2 = 0: only limit it) and wrap it in its range
									;(WrapOption). Entering Shootout saves User Records, Penalties and Line
									;Changes (TmpOptUserRec ...), leaving restores them; Team 1 in new
									;playoffs has NumPlayoffTeams teams; the Players range depends on the mode
									;and FourWayPlay. A new play mode starts the playoffs (ContinuePlayoffs /
									;GoNewPlayoffs). Called from GameSetUp and PrintOptions
	tst.w	d7						;mode line?
	bne.w	.2
	movem.w	d0/d2,-(sp)
	tst.w	d2						;change?
	beq.w	.1
	move.w	(OptPlayMode).l,d0
	add.w	d2,d0
	bpl.w	.0
	move.w	#4,d0					;wrap to 4
.0									;mode wrapped
	cmpi.w	#4,d0					;shootout?
	bne.w	.1
	move.w	(OptUserRec).l,(TmpOptUserRec).l	;save the user records
	move.w	(OptPen).l,(TmpOptPen).l
	move.w	(OptLine).l,(TmpOptLine).l
.1									;pop the d0/d2 saved above
	movem.w	(sp)+,d0/d2
	tst.w	d7						;mode line?
	bne.w	.2
	tst.w	d2						;change?
	beq.w	.2
	cmpi.w	#4,(OptPlayMode).l		;shootout?
	bne.w	.2
	move.w	(TmpOptUserRec).l,(OptUserRec).l	;restore the user records
	move.w	(TmpOptPen).l,(OptPen).l
	move.w	(TmpOptLine).l,(OptLine).l
.2									;shootout options put back
	movea.l	#$18BFA,a2				;CD: the cartridge has #(OptPlayMode-M68K_RAM)
	movea.l	#OptionLimits,a3
	tst.w	(FourWayPlay).l			;four way?
	beq.w	.3
	movea.l	#OptionLimits4Way,a3
.3									;limits for 1 or 4 pads
	clr.w	d5
	move.w	(a3,d7.w),d4			;limit
	move.w	(a2,d7.w),d3
	cmpi.w	#2,(OptPlayMode).l		;playoffs?
	blt.w	.4
	cmpi.w	#4,(OptPlayMode).l		;shootout?
	beq.w	.4
	cmpi.w	#4,d7					;line 4?
	bne.w	.4
	moveq	#NumPlayoffTeams,d4		;playoff teams, the all-stars excluded
.4									;limit set
	cmpi.w	#2,d7					;players line?
	bne.w	.wrap
	cmpi.w	#4,(OptPlayMode).l		;shootout?
	bne.w	.9
	movem.w	d2,-(sp)
	add.w	(OptNOP).l,d2
	bpl.w	.5
	addi.w	#7,d2					;wrap
.5									;player count wrapped
	cmpi.w	#4,d2					;over 4?
	movem.w	(sp)+,d2
	ble.w	.7
	tst.w	d2						;up?
	bpl.w	.6
	move.w	#4,d2
	bra.w	.9
.6									;d2 >= 0
	addi.w	#2,d2
	bra.w	.9
.7									;4 or fewer: wrap with the pad count
	movem.w	d2,-(sp)
	add.w	(OptNOP).l,d2
	cmpi.w	#3,d2					;3?
	movem.w	(sp)+,d2
	bne.w	.9
	tst.w	d2						;up?
	bpl.w	.8
	subi.w	#1,d2
	bra.w	.9
.8									;d2 >= 0
	addi.w	#1,d2
.9									;player count set
	moveq	#5,d5					;lowest 5
	tst.w	(FourWayPlay).l			;four way?
	beq.w	.10
	move.w	#$A,d4					;limit $A
	addi.w	#2,d5					;lowest 7
.10									;limits for the adaptor
	cmpi.w	#4,(OptPlayMode).l		;shootout?
	beq.w	.11
	tst.w	(OptPlayMode).l			;league?
	bne.w	.loop
.11									;shootout or league
	clr.w	d5
	moveq	#5,d4					;limit 5
.loop								;each of the 6 slots
	tst.w	(FourWayPlay).l			;four way?
	beq.w	.wrap
	addi.w	#2,d4
.wrap								;wrap the option
	bsr.w	WrapOption
	tst.w	(FourWayPlay).l			;four way?
	beq.w	.set
	cmpi.w	#2,d7					;players line?
	bne.w	.set
	tst.w	d2						;down?
	bmi.w	.13
	cmpi.w	#9,d3					;9?
	beq.w	.14
	cmpi.w	#$A,d3					;$A?
	beq.w	.14
	bra.w	.set
.13									;d2 negative
	cmpi.w	#$A,d3					;$A?
	bne.w	.set
	move.w	#8,d3
	bra.w	.set
.14									;d3 = 9 or d3 = $A
	move.w	#$B,d3
.set								;store the option
	move.w	d3,(a2,d7.w)
	tst.w	d2						;change?
	beq.w	rtsSetup
	cmpi.w	#1,(OptPlayMode).l		;continuing playoffs?
	bne.w	.16
	tst.w	d7						;mode line?
	bne.w	.16
	jsr	(ContinuePlayoffs).l
	move.w	(gamelevel).l,d0
	or.w	(bosgames).l,d0
	beq.w	.loop
	rts
.16									;OptPlayMode <> 1 or d7 <> 0
	cmpi.w	#2,(OptPlayMode).l		;playoffs?
	blt.w	rtsSetup
	cmpi.w	#4,(OptPlayMode).l		;shootout?
	beq.w	rtsSetup
	tst.w	d7						;mode line?
	beq.w	GoNewPlayoffs
	cmpi.w	#4,d7					;line 4?
	beq.w	GoNewPlayoffs
	rts
WrapOption							;d3 + d2, wrapped into d5 ... d4-1. Called from ChangeOption
	add.w	d2,d3
	cmp.w	d5,d3					;below the lowest?
	bge.w	.0
	move.w	d4,d3
	subq.w	#1,d3
.0									;wrapped to the top
	cmp.w	d4,d3					;at the limit?
	blt.w	rtsSetup
	move.w	d5,d3
	rts
PrintOptions						;Limit each option (ChangeOption with d2 = 0) and print the lines shown
									;(PrintOptionValue), the scroll marks (PrintScrollMarks) the team bitmaps
									;(TeamIcons) and, unless a player card is up, reset the card
									;timer (ResetCardTimer). Called from FixModeOptions
	move.w	d7,d6
;CD: no cartridge twin
	move.l	#$FFFFFFFE,d7
.loop								;loop
	addi.w	#2,d7					;next option
	clr.w	d2
	bsr.w	ChangeOption
	movem.l	d7,-(sp)
	asr.w	#1,d7					;line
	cmp.w	(setupfirstline).l,d7	;on screen?
	movem.l	(sp)+,d7
	blt.w	.0
	bsr.w	PrintOptionValue		;print it
.0									;value printed when on screen
	cmpi.w	#$10,d7					;all done?
	bne.w	.loop
	bsr.w	PrintScrollMarks
	move.w	d6,d7
	jsr	(TeamIcons).l
	btst.b	#0,(setupcardflags).l	;card up?
	bne.w	.x
	jsr	(ResetCardTimer).l			;restart the card timer
.x									;exit (also the end of the code above)
	rts
PrintOptionValue					;print the value of option d7 at x $11 on its line (past row $1B:
									;nothing). Team 1 / 2 go to PrintOptTeamName Per. Length in
									;Shootout prints 'N/A'; Players with FourWayPlay uses the second list
									;(+$B0). Called from PrintOptions
	jsr	(printz).l					;map at the first value
	String	CC_Font1Pri,$11,$10
	move.w	(setupfirstline).l,d0
	add.w	d0,d0					;2 rows a line
	sub.w	d0,(printy).l
	add.w	d7,(printy).l
	cmpi.w	#$1B,(printy).l			;below row $1B?
	bgt.w	rtsSetup				;yes: off screen
	subi.w	#1,(printy).l
	move.w	#$11,(printx).l
	cmpi.w	#4,d7					;home team line?
	beq.w	PrintOptTeamName		;print the team
	cmpi.w	#6,d7					;visitors line?
	beq.w	PrintOptTeamName		;print the team
	movea.l	#OptPlayMode,a0
	move.w	(a0,d7.w),d3
	movea.l	#OptionValueOffsets,a0	;value Strings of option d7
	adda.w	(a0,d7.w),a0			;its value Strings
	cmpa.l	#PerLengthValues,a0		;period length?
	bne.w	.0
	cmpi.w	#4,(OptPlayMode).l		;shootout?
	bne.w	.0
	movea.l	#NATxt,a1
	jmp	(print).l
.0									;a0 <> #PerLengthValues or OptPlayMode <> 4
	tst.w	(FourWayPlay).l			;four way?
	beq.w	.loop
	cmpi.w	#2,d7					;players line?
	bne.w	.loop
	adda.w	#$B0,a0					;4 way Players list
.loop								;print each option name
	movea.l	a0,a1
	adda.w	(a0),a0
	dbf	d3,.loop					;loop
	jmp	(print).l
PrintScrollMarks					;Print the scroll marks at x 2: '}' at row $19 when more lines follow
									;(first line < 3), '{' at row $F when lines are above (first line > 0),
									;else a space
	move.w	#$19,(printy).l
	movea.l	#ScrollClearTxt,a1
	cmpi.w	#3,(setupfirstline).l	;at the last first line?
	beq.w	.0
	cmpi.w	#4,(OptPlayMode).l		;shootout?
	beq.w	.0
	movea.l	#ScrollDownTxt,a1
.0									;down arrow (or a blank)
	move.w	#2,(printx).l
	jsr	(print).l
	movea.l	#ScrollClearTxt,a1
	move.w	#$F,(printy).l
	tst.w	(setupfirstline).l		;at the top?
	beq.w	.1
	movea.l	#ScrollUpTxt,a1
.1									;up arrow (or a blank)
	move.w	#2,(printx).l
	jmp	(print).l
ScrollUpTxt	String	'{'				;Scroll marks for PrintScrollMarks
ScrollDownTxt	String	'}'			;scroll down mark
ScrollClearTxt	String	' '			;blank to clear a scroll mark
PrintOptTeamName					;Print team name d3 of option d7 (TeamList city; the full name of the
									;two New York teams, $D / $E).
									;PrintOptionValue
	move.w	(printx).l,-(sp)
	movea.l	#BlankValueTxt,a1
	jsr	(print).l
	move.w	(sp)+,(printx).l
	movea.l	#OptPlayMode,a1
	move.w	(a1,d7.w),d3
	movea.l	#TeamList,a1
	asl.w	#2,d3
	movea.l	(a1,d3.w),a1
	lsr.w	#2,d3
	adda.w	Teamname(a1),a1
	cmpi.w	#$E,d3					;NYR?
	bne.w	.0
	movea.l	#NewYorkRTxt,a1			;full name
	bra.w	.1						;print
.0									;d3 <> $E
	cmpi.w	#$D,d3					;NYI?
	bne.w	.1
	movea.l	#NewYorkITxt,a1			;full name
.1									;print the name
	jmp	(print).l
NewYorkITxt							;Full names for the two New York teams (TeamList has only the city).
									;The nicknames are licensed names, so each String (length word, 'New York
									;' and
									;the nickname) is generated from the ROM
	incbin	..\cdbin\HOCKEY.BIN,$8E7A,20	;licensed text: read from the disc file
NewYorkRTxt							;full name of NYR
	incbin	..\cdbin\HOCKEY.BIN,$8E8E,18	;licensed text: read from the disc file
BlankValueTxt	String	'                    '	;A blank value
NATxt	String	'N/A                 '	;Per. Length in Shootout
OptionValueOffsets					;Offsets of each option's value Strings. Team 1 / 2 are not read
									;(PrintOptTeamName); User Records uses the On / Off list
	dc.w	PlayModeValues-OptionValueOffsets,PlayersValues-OptionValueOffsets,UserRecValues-OptionValueOffsets,UserRecValues-OptionValueOffsets,PerLengthValues-OptionValueOffsets
	dc.w	GoaliesValues-OptionValueOffsets,UserRecValues-OptionValueOffsets,PenaltiesValues-OptionValueOffsets,LineChangeValues-OptionValueOffsets
PlayModeValues						;Play Mode: OptPlayMode 0-4
	String	'Regular Season      '
	String	'Continue Playoffs   '
	String	'New Playoffs        '
	String	'New Playoffs/7 game '
	String	'Shootout            '
PlayersValues						;Players: OptNOP 0-7, then the FourWayPlay list (+$B0)
	String	'Demo                '
	String	'One - Home          '
	String	'One - Visitor       '
	String	'Two - Teammates     '
	String	'Two - Head to Head  '
	String	'Two - Head to Head  '
	String	'Two - Teammates     '
	String	'One                 '
	String	'Demo                '
	String	'One - Home          '
	String	'One - Visitor       '
	String	'Two - Teammates     '
	String	'Two - Head to Head  '
	String	'Three               '
	String	'Four                '
	String	'Two - Head to Head  '
	String	'Two - Teammates     '
	String	'Three               '
	String	'Four                '
	String	'One                 '
PerLengthValues						;Per. Length
	String	'5 Minutes           '
	String	'10 Minutes          '
	String	'20 Minutes          '
	String	'30 Seconds          '
GoaliesValues						;Goalies
	String	'Manual Control      '
	String	'Auto Control        '
PenaltiesValues						;Penalties option values
	String	'Off                 '
	String	'On                  '
	String	'On, Except Off-sides'
UserRecValues						;User Records, and the unread Team 1 / 2 entries
	String	'On                  '
	String	'Off                 '
LineChangeValues					;Line Changes (Off, On, Auto)
	String	'On                  '
	String	'Off                 '
	String	'Auto                '
PrintOptionNames					;Print the option names from OptionNames at x 3, 2 rows apart from row $F
									;- setupfirstline * 2, rows $F-$19 only.
									;from
									;GameSetUp and FixModeOptions
	movem.l	d0-d1,-(sp)
	bset.b	#3,(sflags6).l			;print all
	movea.l	#OptionNames,a1
	move.w	#$F,d0
	move.w	(setupfirstline).l,d1
	add.w	d1,d1					;2 rows a line
	sub.w	d1,d0
	move.w	d0,(printy).l
.loop								;loop
	cmpi.w	#$F,(printy).l			;above the menu?
	bge.w	.0
	adda.w	(a1),a1
	bra.w	.1
.0									;printy >= $F
	cmpi.w	#$19,(printy).l			;past row $19?
	bgt.w	.done
	move.w	#3,(printx).l
	move.w	#0,(printa).l
	move.w	#0,(printm).l
	jsr	(printsmall).l				;print it
.1									;next line
	addi.w	#2,(printy).l			;2 rows on
	bra.w	.loop
.done								;printy > $19
	bclr.b	#3,(sflags6).l			;normal
	movem.l	(sp)+,d0-d1
	rts
OptionNames							;Option names; the last entry is an empty String (dc.w 4,0)
	String	'Play Mode    '
	String	'Players      '
	String	'Team 1       '
	String	'Team 2       '
	String	'Per. Length  '
	String	'Goalies      '
	String	'User Records '
	String	'Penalties    '
	String	'Line Changes '
	dc.w	4,0
setoptions							;options screen display: build the game setup screen only: vblank vram
									;maps, the TeamBitmaps+8 tiles (LoadSetupTiles), framer, small font and
									;setup font tiles, the screen and menu bitmaps, the logo box tiles and
									;defaultsprites_0. Called from GameSetUp
	move.l	#VBlank_SetOptions,(VBint).l
;CD: no cartridge twin
	bset.b	#$5,$FF800F.l
	bclr.b	#dfok,(disflags).l		;#dfok - graphics are ready for transfer (clr = not ready)
	bset.b	#dfng,(disflags).l		;#dfng - dont int graphics
	bclr.b	#df32c,(disflags).l		;#df32c - 32 bit column mode (clr = off)
	move.w	#0,$18D30.l				;CD: the cartridge has (VSCRLPM).w
	move.w	#$B400,(VSPRITES).l
	move.w	#$B800,(VmMAP3).l
	move.w	#5,(Map3col).l
	move.w	#$C000,(VmMAP2).l
	move.w	#6,(Map2col).l
	move.w	#$E000,(VmMAP1).l
	move.w	#6,(Map1col).l
;CD: no cartridge twin
	move.l	#$0,d0
	jsr	(setVram).l
	jsr	(orjoy).l					;read the pads
	jsr	(LoadSetupTiles).l			;TeamBitmaps+8 tiles
	move.w	d4,(framercset).l		;frame chars
;CD: no cartridge twin
	movea.l	(SetupFramerMapPtr).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
	dc.l	$03567564,$89ABCDEF		;remap table (/ or.l, a word dropped)
	move.w	d4,(smallfontchars).l
;CD: no cartridge twin
	movea.l	(SmallFontMapPtr).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
	dc.l	$0FC04567,$89ABCDEF		;remap table (/ or.l)
	move.w	d4,(setupfontchars).l
;CD: no cartridge twin
	movea.l	(PrintFont2MapPtr).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
	dc.l	$01234567,$89ABCDEF		;remap table (/ or.l)
	jsr	(printz).l					;map at the top left
	String	CC_Font1,0,0			;x2
	moveq	#$28,d0
	moveq	#$1C,d1
	move.w	#$7FF,d2				;blank char
	jsr	(eraser).l
	jsr	(printz).l					;map at the background
	String	CC_Font2,0,0			;x3
;CD: no cartridge twin
	movea.l	(GameSetUpMapPtr).l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1				;a1 = map data
	clr.w	d0
	clr.w	d1
	moveq	#$28,d2
	moveq	#$1C,d3
	moveq	#$D,d5					;color fam 1, 3, 4
	jsr	(dobitmap).l
	move.w	d4,(vispicchars).l
	addi.w	#$24,d4
	jsr	(printz).l					;map at the second layer
	String	CC_Font1,0,0			;x3
;CD: no cartridge twin
	movea.l	(GameSetUpMap2Ptr).l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1				;a1 = map data
	clr.w	d0
	clr.w	d1
	moveq	#$28,d2
	moveq	#4,d3
	moveq	#0,d5					;no palette lines
	jsr	(dobitmap).l
	jsr	(printz).l					;map at the menu
	String	CC_Font1,1,$E			;(and dropped a word)
	move.w	d4,(setupmenuchars).l
;CD: no cartridge twin
	movea.l	(SetupMenuMapPtr).l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1				;a1 = map data
	clr.w	d0
	clr.w	d1
	moveq	#$26,d2
	moveq	#$D,d3
	moveq	#0,d5					;no palette lines
	jsr	(dobitmap).l
	move.w	d4,(homepicchars).l
	addi.w	#$24,d4
	move.w	d4,(logobox1chars).l	;logo box 1 chars
;CD: no cartridge twin
	movea.l	(LogoBoxMapPtr).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,$1939A.l
	movea.l	(LogoBoxMapPtr).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
	dc.l	$03414567,$89ABCDEF		;remap table (/ or.l, a word dropped)
	jsr	(defaultsprites_0).l
	move.w	#$28,(SortCords+rosxoff).l
	move.w	#$28,(SortCords+(6*SCstruct)+rosxoff).l
	st.b	(tmstruct).l			;no home team block yet
	st.b	(awtmstruct).l			;no visitors block yet
	rts
ReadSetupPads						;wait up to $5460 frames (6 minutes) for a press on any pad (4 with
									;FourWayPlay); return d1 = the presses, 0 on timeout. C does not return:
									;it sets setupcardflags bit 5 (next player card sooner). When only one
									;logo is shown (after a player card) redraws the team blocks. For the
									;first $E10 frames of the wait, and while a card is up, runs the player
									;cards (PlayerCardTimer), else resets their timer (ResetCardTimer). Called
									;from GameSetUp
	move.l	#$5460,d6
.loop								;loop
	move.w	(Vcount).l,d1			;frame count
	sub.w	(OldVcount).l,d1		;changed?
	beq.w	.loop
	move.w	(Vcount).l,(OldVcount).l	;new frame count
	bclr.b	#5,(setupcardflags).l	;no press yet
	jsr	(UpdateRosterPlayers).l
	jsr	(ReadJoy1).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1						;any press?
	beq.w	.1
	btst	#cbut,d1				;C?
	beq.w	.x						;another button: return
	btst	#5,d2					;C?
	beq.w	.0
	move.w	#$53,(cardtimer).l
.0									;C held: the shorter card timer
	bset.b	#5,(setupcardflags).l
.1									;pad 2
	jsr	(ReadJoy2).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1						;any press?
	beq.w	.2
	btst	#5,d1					;C?
	beq.w	.x						;no: return the press
	bset.b	#5,(setupcardflags).l	;press seen
.2									;pad 3 (with the adaptor)
	tst.w	(FourWayPlay).l			;four way?
	beq.w	.4
	jsr	(ReadJoy3).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1						;any press?
	beq.w	.3
	btst	#5,d1					;C?
	beq.w	.x						;no: return the press
	bset.b	#5,(setupcardflags).l	;press seen
.3									;pad 4
	jsr	(ReadJoy4).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1						;any press?
	beq.w	.4
	btst	#5,d1					;C?
	beq.w	.x						;no: return the press
	bset.b	#5,(setupcardflags).l	;press seen
.4									;redraw the team blocks when flagged
	btst.b	#6,(setupcardflags).l	;visitors block flagged?
	beq.w	.5
	btst.b	#7,(setupcardflags).l	;home flagged too?
	bne.w	.6
	move.w	(setupvis).l,(logoteam).l
	bsr.w	DrawVisBlock
.5									;visitors block done
	btst.b	#7,(setupcardflags).l	;home block flagged?
	beq.w	.6
	move.w	(setuphome).l,(logoteam).l
	bsr.w	DrawHomeBlock
;CD: no cartridge twin
.6									;CD: placed where the disc branches to it
	cmpi.l	#$4650,d6
	bgt.w	.timer
	btst.b	#0,(setupcardflags).l	;card up?
	bne.w	.timer
	jsr	(ResetCardTimer).l			;restart the card timer
	bra.w	.8
.timer								;player cards
	jsr	(PlayerCardTimer).l
.8									;next frame
	dbf	d6,.loop					;loop
.x									;exit (also the end of the code above)
	rts
SetupDemo							;Demo after no press for $5460 frames. Clear demoflag, seed the RNG
									;(seed), Regular Season, Demo, line changes On
									;penalties On. Falls into SetupStart. Branched to from GameSetUp
	clr.w	(demoflag).l
;CD: no cartridge twin
.L24666
	btst.b	#$7,$FF800E.l
	bne.s	.L24666
	move.w	#$1B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L24680
	btst.b	#$6,$FF800E.l
	beq.s	.L24680
	move.w	$FF8010.l,(seed).l
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L246A4
	btst.b	#$6,$FF800E.l
	bne.s	.L246A4
	bclr.b	#$7,$FF800F.l
.L246B6
	btst.b	#$7,$FF800E.l
	bne.s	.L246B6
	move.w	#$1B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L246D0
	btst.b	#$6,$FF800E.l
	beq.s	.L246D0
	move.w	$FF8010.l,$18C1A.l
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L246F4
	btst.b	#$6,$FF800E.l
	bne.s	.L246F4
	bclr.b	#$7,$FF800F.l
	clr.w	(OptPlayMode).l
	clr.w	(OptNOP).l
	clr.w	(OptLine).l				;line changes off
	move.w	#1,(OptPen).l
SetupStart							;Start pressed: Copy Goalies to both teams, set pojoy, seed the RNG
									;(seed), and keep OptLine / OptPlayMode in TmpOptLine2 / TempOptPlayMode:
									;Auto line changes play as On with sflags7 bit 4, Shootout as Regular
									;Season with gmode2 bit 0 (ClearShootout). Then jmp MakeTree. Branched to
									;from GameSetUp
	move.w	(OptGoalie).l,-(sp)
	move.w	(sp),(goaliemode1).l
	move.w	(sp)+,(goaliemode2).l
	jsr	(UpdatePlayoffLevel).l
;CD: no cartridge twin
.L24738
	btst.b	#$7,$FF800E.l
	bne.s	.L24738
	move.w	#$1B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L24752
	btst.b	#$6,$FF800E.l
	beq.s	.L24752
	move.w	$FF8010.l,(seed).l
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L24776
	btst.b	#$6,$FF800E.l
	bne.s	.L24776
	bclr.b	#$7,$FF800F.l
.L24788
	btst.b	#$7,$FF800E.l
	bne.s	.L24788
	move.w	#$1B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L247A2
	btst.b	#$6,$FF800E.l
	beq.s	.L247A2
	move.w	$FF8010.l,$18C1A.l
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L247C6
	btst.b	#$6,$FF800E.l
	bne.s	.L247C6
	bclr.b	#$7,$FF800F.l
	move.w	(OptLine).l,(TmpOptLine2).l
	cmpi.w	#2,(OptLine).l			;auto?
	bne.w	.0
	clr.w	(OptLine).l
	bset.b	#4,(sflags7).l			;auto line changes
.0									;line changes set for the game
	move.w	(OptPlayMode).l,(TempOptPlayMode).l	;save the play mode
	cmpi.w	#4,(OptPlayMode).l		;shootout?
	bne.w	.1
	move.w	#0,(OptPlayMode).l		;league
	bset.b	#0,(gmode2).l			;shootout flag
	jsr	(ClearShootout).l
.1									;shootout set up
	jmp	(MakeTree).l				;build the playoff tree
CheckNOPUnused						;unreferenced. Tests OptNOP for 0, 5, 6, 9 and $A and returns: no effect
	tst.w	(OptNOP).l				;0?
	beq.w	.x
	cmpi.w	#5,(OptNOP).l			;5?
	beq.w	.x
	cmpi.w	#6,(OptNOP).l			;6?
	beq.w	.x
	cmpi.w	#9,(OptNOP).l			;9?
	beq.w	.x
	cmpi.w	#$A,(OptNOP).l			;$A?
.x									;exit (also the end of the code above)
	rts
LoadSetupTiles						;Load the TeamBitmaps+8 tiles from char 2, then again remapped
									;teambitmapchars.
									;Called
									;from setoptions
	moveq	#2,d4
;CD: no cartridge twin
	movea.l	(TeamBitmapsPtr).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,$1939C.l
	movea.l	(TeamBitmapsPtr).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
	dc.l	$03412567,$89ABCDEF		;remap table (/ move.l / dc.b)
	rts
UpdateRosterPlayers					;An empty routine, called from ReadSetupPads. An unused rts follows
	rts
	rts
EraseCard							;If a player card is up (setupcardflags bit 0, cleared here), clear both
									;logo flags (bits 6 / 7) and erase the card: its logo box and its 25 x 8
									;box. Called from DrawHomeBlock and DrawVisBlock
	movem.l	d0-d7,-(sp)
	bclr.b	#0,(setupcardflags).l	;card up?
	beq.w	.x
	bclr.b	#6,(setupcardflags).l	;no visitors block
	bclr.b	#7,(setupcardflags).l	;no home block
	jsr	(printz).l					;map at the card
	String	CC_Font1Pal1,0,0		;x3
	move.w	#5,(printy).l
	moveq	#8,d0
	moveq	#8,d1
	move.w	#$7FF,d2				;blank char
	btst.b	#1,(setupcardflags).l	;visitors side?
	beq.w	.1
	move.w	#3,(printx).l
	jsr	(eraser).l
	jsr	(printz).l					;map at the text
	String	CC_Font1,0,0			;x3
	move.w	#$B,(printx).l
	move.w	#5,(printy).l
	move.w	#$19,d0
	move.w	#8,d1
.0									;(not branched to)
	move.w	#$7FF,d2				;blank char
	jsr	(eraser).l
	bra.w	.x
.1									;bit 1 of setupcardflags clear
	move.w	#$1C,(printx).l
	jsr	(eraser).l
	jsr	(printz).l					;map at the text
	String	CC_Font1,0,0			;x3
	move.w	#3,(printx).l
	move.w	#5,(printy).l
	move.w	#$19,d0
	move.w	#8,d1
	move.w	#$7FF,d2				;blank char
	jsr	(eraser).l
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7
	rts
DrawHomeBlock						;Draw the home team block: the logo box and the HomeTeam logo (logoteam)
									;at x $19, y 6. setupcardflags bit 2
									;home drawn, bit 6: home logo shown. Called from GameSetUp and
									;ReadSetupPads
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	EraseCard
	bset.b	#2,(setupcardflags).l	;home side
	bset.b	#6,(setupcardflags).l	;home block up
	bsr.w	LogoBoxHome				;logo box
	bclr.b	#3,(setupcardflags).l	;visitors side?
	beq.w	.0
	jsr	(printz).l					;map at the area
	String	CC_Font1Pal1,0,0		;x3
	move.w	#8,(printx).l
	move.w	#5,(printy).l
	moveq	#8,d0
	moveq	#8,d1
	move.w	#$7FF,d2				;blank char
.0									;home logo box done
	jsr	(printz).l					;map at the logo
	String	CC_Font1,0,0			;x3
	move.w	#$19,(printx).l
	bra.w	DrawTeamLogo
DrawVisBlock						;The same for the visitors: logo box, logo at x 9. setupcardflags bit 3,
									;bit 7. Called from GameSetUp and ReadSetupPads
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	EraseCard
	bset.b	#3,(setupcardflags).l	;visitors side
	bset.b	#7,(setupcardflags).l	;visitors block up
	bsr.w	LogoBoxVis				;logo box
	bclr.b	#2,(setupcardflags).l	;home side?
	beq.w	.0
	jsr	(printz).l					;map at the area
	String	CC_Font1Pal1,0,0		;x3
	move.w	#$18,(printx).l
	move.w	#5,(printy).l
	moveq	#8,d0
	moveq	#8,d1
	move.w	#$7FF,d2				;blank char
.0									;visitors logo box done
	jsr	(printz).l					;map at the logo
	String	CC_Font1Pal3,0,0
	move.w	#9,(printx).l
DrawTeamLogo						;Draw the logo of team logoteam at printx, y 6, 6 x 6, palette
									;TeamLogoPalettes + team * 8 - $20 (home, color fam
									;2) or - $40 (visitors, color fam 3), then wait $B4 frames before a player
									;card (carddelay). Branched to
	;  from DrawHomeBlock
	move.w	#$B4,(carddelay).l
	move.w	#6,(printy).l
	move.w	(homepicchars).l,d4
	btst.b	#2,(setupcardflags).l	;home?
	bne.w	.0
	move.w	(vispicchars).l,d4
.0									;picture tiles chosen
	move.w	(logoteam).l,d3
	asl.w	#2,d3
;CD: no cartridge twin
	movea.l	(TeamLogoBitmapsPtr).l,a0
	movea.l	(a0,d3.w),a0			;its logo
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0				;skip the palette offset
	asl.w	#3,d3					;32 bytes per team
	movea.l	#TeamLogoPalettes,a0
	btst.b	#2,(setupcardflags).l	;home?
	beq.w	.1
	subi.w	#$20,d3
	bra.w	.2
.1									;bit 2 of setupcardflags clear
	subi.w	#$40,d3
.2									;palette offset chosen
	adda.w	d3,a0
	adda.l	(a2)+,a1
	move.w	#6,d3
	move.w	#6,d2
	clr.w	d0
	clr.w	d1
	move.l	(palfadenew+$22).l,-(sp)
	move.l	(palfadenew+$26).l,-(sp)
	move.w	#4,d5
	btst.b	#2,(setupcardflags).l	;home?
	beq.w	.draw
	move.w	#2,d5
.draw								;palette line chosen
	jsr	(dobitmap).l
	move.l	(sp)+,(palfadenew+$26).l
	move.l	(sp)+,(palfadenew+$22).l
	move.w	#$64,(palcount).l		;fade in
	movem.l	(sp)+,d0-d7/a0-a6
	rts
TeamLogoBitmapsEnd					;end of TeamLogoBitmaps (size check below)
LogoBoxRight						;Logo box (LogoBoxMap, 8 x 8) at x $1C, y 5 with the logobox1chars tiles.
									;Called from PlayerCardScreen
	move.w	(logobox1chars).l,d4
	move.w	#$1C,(printx).l
	bra.w	DrawLogoBox
LogoBoxHome							;Logo box at x $18 (home block). Called from DrawHomeBlock
	move.w	(logobox1chars).l,d4
	move.w	#$18,(printx).l
	bra.w	DrawLogoBox
LogoBoxLeft							;Logo box at x 3 with the logobox2chars tiles.
									;Called from PlayerCardScreen
	move.w	(logobox2chars).l,d4
	move.w	#3,(printx).l
	bra.w	DrawLogoBox
LogoBoxVis							;Logo box at x 8 (visitors block). Called from DrawVisBlock
	move.w	(logobox2chars).l,d4
	move.w	#8,(printx).l
DrawLogoBox							;Draw the LogoBoxMap box at printx, y 5 (sflags6 bit 0 set). Branched to
									;from LogoBoxRight ... LogoBoxVis
	clr.w	(printa).l
	move.w	#5,(printy).l
;CD: no cartridge twin
	movea.l	(LogoBoxMapPtr).l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1				;a1 = map data
	move.w	#8,d3
	move.w	#8,d2
	clr.w	d0
	clr.w	d1
	move.w	#0,d5					;no palette lines
	bset.b	#0,(sflags6).l
	jsr	(dobitmap).l
	bclr.b	#0,(sflags6).l			;normal maps
	rts
