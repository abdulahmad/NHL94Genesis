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
	move.w	(TmpOptLine2).w,(OptLine).w	;undo the start changes of SetupStart (Auto line changes, Shootout)
	move.w	(TempOptPlayMode).w,(OptPlayMode).w	;restore the play mode
	bclr	#1,(sflags7).w			;no overtime
	jsr	(ClearGameStats).l
	jsr	(ReadNameLog).l				;read the SRAM name list
	bsr.w	setoptions				;build the screen
	clr.w	(setupfirstline).w		;first menu line shown
	clr.w	(setupprevline).w		;clear the previous first line
	bsr.w	PrintOptionNames
	tst.w	(demoflag).w			;clear after a demo
	bne.w	.shootout
	moveq	#NumTeams,d0
	jsr	(randomd0).l
	move.w	d0,(Opt1team).w			;random teams after a demo (0 through NumTeams-1)
	moveq	#NumTeams,d0
	jsr	(randomd0).l				;0 to NumTeams-1
	move.w	d0,(Opt2team).w
.shootout							;teams set (random after a demo)
	st	(demoflag).w
	cmpi.w	#4,(OptPlayMode).w
	bne.w	.newplay
	bra.w	.reggame
.newplay							;OptPlayMode <> 4
	cmpi.w	#2,(OptPlayMode).w		;check if new playoffs
	blt.w	.contplay				;league or continue playoffs
	bsr.w	GoNewPlayoffs			;new playoffs: random tree
.contplay							;playoffs set up
	cmpi.w	#1,(OptPlayMode).w		;check if cont playoffs
	bne.w	.reggame				;not continue playoffs
	bsr.w	GoContinuePlayoffs
.reggame							;any mode: start on the first line
	clr.w	d7						;menu line 0 (d7 = line * 2 = offset in OptPlayMode ... OptLine)
	clr.w	d0
	bsr.w	MoveMenuFrame			;frame the line
	bsr.w	FixModeOptions			;print the options
	move.w	(HomeTeam).w,(setuphome).w	;home in the block
	move.w	(HomeTeam).w,(logoteam).w	;logo of the home team
	bsr.w	DrawHomeBlock
	move.w	(VisTeam).w,(setupvis).w	;visitors in the block
	move.w	(VisTeam).w,(logoteam).w	;logo of the visitors
	bsr.w	DrawVisBlock
	move.w	#$18,(palcount).w
	bclr	#dfng,(disflags).w		;dfng: fade in graphics now
.loop								;loop
	cmpi.w	#4,(OptPlayMode).w		;Shootout: line changes Off, penalties Off, user records Off
	bne.w	.0
	move.w	#1,(OptLine).w			;line changes off
	move.w	#0,(OptPen).w			;penalties off
	move.w	#1,(OptUserRec).w		;user records off
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
	tst.w	(OptNOP).w				;no players (demo)?
	bne.w	.2
	cmp.w	#8,d7					;on the period length line?
	bne.w	.2						;not the period length line
	move.w	#4,d0					;skip a line
	bra.w	.3
.2									;OptNOP <> 0 or d7 <> 8
	move.w	#2,d0					;one line down
.3									;frame size chosen
	cmpi.w	#4,(OptPlayMode).w		;shootout?
	beq.w	.4
	tst.w	(OptNOP).w				;no players (demo)?
	bne.w	.4
	cmp.w	#8,d7					;on the period length line?
	bne.w	.4						;not the period length line
	move.w	#6,d0					;skip 3 lines
	bra.w	.8
.4									;next line check
	cmp.w	#6,d7					;on the 2nd team line?
	bne.w	.5						;not the 2nd team line
	cmpi.w	#4,(OptPlayMode).w		;shootout?
	bne.w	.5
	tst.w	(OptNOP).w				;no players (demo)?
	bne.w	.7
	clr.w	d0						;stay on the line
	bra.w	.8
.5									;d7 <> 6 or OptPlayMode <> 4
	cmp.w	#$A,d7					;on the goalie line?
	bne.w	.8						;not the goalie line
	cmpi.w	#4,(OptPlayMode).w		;shootout?
	bne.w	.6
	clr.w	d0						;shootout: stay
	bra.w	.8
.6									;OptPlayMode <> 4
	tst.w	(ValidSRAM).w			;save RAM?
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
	tst.w	(OptNOP).w				;demo (no pads)?
	bne.w	.10
	cmp.w	#$C,d7					;on the user records line?
	bne.w	.10						;not the user records line
	move.w	#$FFFC,d0				;skip a line
	bra.w	.11
.10									;OptNOP <> 0 or d7 <> $C
	move.w	#$FFFE,d0				;one line up
	cmpi.w	#4,(OptPlayMode).w		;shootout?
	beq.w	.11						;shootout: one line
	tst.w	(OptNOP).w				;players?
	bne.w	.11						;players: move one line
	cmp.w	#$E,d7					;on the penalties line?
	bne.w	.11						;not the penalties line
	move.w	#$FFFA,d0				;skip 3 lines
	bra.w	.14
.11									;next line check
	cmp.w	#$A,d7					;on the goalie line?
	bne.w	.12						;not the goalie line
	cmpi.w	#4,(OptPlayMode).w		;shootout?
	beq.w	.13
.12									;not the shootout line
	cmp.w	#$E,d7					;on the user records line?
	bne.w	.14						;not the line: move one line
	cmpi.w	#4,(OptPlayMode).w		;shootout?
	beq.w	.13
	tst.w	(ValidSRAM).w			;save RAM?
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
	cmpi.w	#4,(OptPlayMode).w		;shootout?
	beq.w	.17						;shootout: no pad setup
	jsr	(FigureJoy).l				;set up the pads
.17									;pad setup done
	move.w	(Opt2team).w,-(sp)		;save the old teams
	move.w	(Opt1team).w,-(sp)		;save the old teams
	bsr.w	ChangeOption			;change the option by d2
	move.w	(sp)+,d0				;old Opt1team
	cmpi.w	#4,(OptPlayMode).w		;shootout?
	beq.w	.18
	tst.w	(OptPlayMode).w			;league?
	bne.w	.19
.18									;league or shootout: the menu teams play
	move.w	(Opt1team).w,(HomeTeam).w	;Regular Season and Shootout: the menu teams
	move.w	(Opt2team).w,(VisTeam).w
.19									;teams set for the mode
	move.w	(HomeTeam).w,(logoteam).w	;logo of the home team
	btst	#6,(setupcardflags).w	;home logo shown?
	beq.w	.20
	movem.w	d0,-(sp)
	move.w	(setuphome).w,d0		;team in the block
	cmp.w	(HomeTeam).w,d0			;home team changed?
	movem.w	(sp)+,d0
	beq.w	.21						;same team: keep it
.20									;home team changed (or no logo yet): redraw its block
	move.w	(HomeTeam).w,(setuphome).w
	bsr.w	DrawHomeBlock
.21									;home block done
	btst	#7,(setupcardflags).w	;visitors logo shown?
	beq.w	.22
	movem.w	d0,-(sp)
	move.w	(setupvis).w,d0			;visitors on the screen
	cmp.w	(VisTeam).w,d0			;visitors changed?
	movem.w	(sp)+,d0
	beq.w	.23						;same team: keep it
.22									;visitors team changed (or no logo yet): redraw its block
	move.w	(VisTeam).w,(setupvis).w
	move.w	(VisTeam).w,(logoteam).w	;logo of the visitors
	bsr.w	DrawVisBlock
	move.w	(HomeTeam).w,(logoteam).w	;logo back to the home team
.23									;visitors block done
	tst.w	(sp)+					;drop the saved Opt2team
	bra.w	.fix
	move.w	(sp)+,d0				;unreferenced: an older copy of the team block update above
	cmp.w	(VisTeam).w,d0			;same as the visitors?
	beq.w	.fix
	move.w	(VisTeam).w,(logoteam).w	;logo of the visitors
	movem.w	d0,-(sp)
	move.w	(VisTeam).w,d0
	cmp.w	(VisTeam).w,d0
	movem.w	(sp)+,d0
	beq.w	.24
	move.w	(VisTeam).w,(setupvis).w
	bsr.w	DrawVisBlock			;redraw the visitors block
.24									;visitors block redrawn when the team changed
	movem.w	d0,-(sp)
	move.w	(setuphome).w,d0		;home on the screen
	cmp.w	(HomeTeam).w,d0			;home team changed?
	movem.w	(sp)+,d0
	beq.w	.fix
	move.w	(HomeTeam).w,(setuphome).w
	move.w	(HomeTeam).w,(logoteam).w	;logo of the home team
	bsr.w	DrawHomeBlock			;redraw the home block
	move.w	(VisTeam).w,(logoteam).w	;logo of the visitors
.fix								;redraw the options
	bsr.w	FixModeOptions			;print the options
	bra.w	.loop
	rts
GoNewPlayoffs						;New playoffs: jmp NewPO. Called from GameSetUp and ChangeOption
	jmp	NewPO
GoContinuePlayoffs					;Continue playoffs: jmp ContinuePlayoffs. Called from GameSetUp
	jmp	ContinuePlayoffs
MoveMenuFrame						;Move the menu frame by d0 (+2 / -2 lines). Shows 6 of the 9 lines and
									;scrolls: setupfirstline = first line shown
									;(0-3), setupprevline = the one before (sflags5 bit 2 set on a scroll;
									;FixModeOptions reprints the names when they differ). Continue playoffs
									;skips lines 1-3, new playoffs line 3 (Team 2). The old frame is erased by
									;redrawing the SetupMenuMap background under it. Called from GameSetUp
	move.w	d7,d3
.optionup							;loop
	bclr	#2,(sflags5).w			;not scrolled yet
	tst.w	d0						;direction?
	bpl.w	.optiondown
	move.w	d0,-(sp)
	move.w	d7,d0
	asr.w	#1,d0					;lines
	cmp.w	(setupfirstline).w,d0	;top line shown?
	bne.w	.noscroll				;not at the top of the frame
	move.w	(setupfirstline).w,(setupprevline).w
	bset	#2,(sflags5).w			;scrolled
	subq.w	#1,(setupfirstline).w
	bpl.w	.noscroll				;not above line 0
	clr.w	(setupfirstline).w		;clamp to line 0
.noscroll							;first line scrolled (not above 0)
	move.w	(sp)+,d0
.optiondown							;move the line cursor by d0
	move.w	d7,(TempWord1).w
	add.w	d0,d7
	bpl.w	.0						;not above line 0
	clr.w	d7						;clamp to line 0
.0									;line clamped at the top
	tst.w	d0						;moving?
	bmi.w	.3
	move.w	d0,-(sp)
	move.w	d7,d0
	asr.w	#1,d0					;lines
	sub.w	(setupfirstline).w,d0	;row in the frame
	cmp.w	#5,d0					;past row 5?
	bgt.w	.scrolldown				;below the frame: scroll
	bra.w	.2
.scrolldown							;d0 > 5
	move.w	(setupfirstline).w,(setupprevline).w
	bset	#2,(sflags5).w			;scrolled
	addq.w	#1,(setupfirstline).w
	move.w	d7,d0
	asr.w	#1,d0
	sub.w	(setupfirstline).w,d0	;minus the first line shown
	cmp.w	#5,d0					;still below the frame?
	ble.w	.1
	addq.w	#1,(setupfirstline).w	;scroll once more
.1									;first line moved down when needed
	cmpi.w	#3,(setupfirstline).w	;past line 3?
	ble.w	.2
	move.w	#3,(setupfirstline).w	;at most 3
.2									;first line clamped
	move.w	(sp)+,d0
.3									;moving up, or the scroll is done
	btst	#2,(sflags5).w			;scrolled?
	bne.w	.4
	move.w	(setupfirstline).w,(setupprevline).w	;no scroll: same first line
.4									;previous line kept for the redraw check
	cmp.w	#$12,d7					;past the last line (Line Changes)
	blt.w	.contplayoffs
	sub.w	d0,d7
.contplayoffs						;line clamped at the bottom
	cmpi.w	#1,(OptPlayMode).w		;continuing playoffs?
	bne.w	.newplay
	tst.w	d7						;top line?
	beq.w	.newplay
	cmp.w	#6,d7					;line 6 or above?
	bls.w	.optionup
.newplay							;not continuing playoffs, or the top line
	cmpi.w	#2,(OptPlayMode).w		;playoffs?
	blt.w	.5
	cmpi.w	#4,(OptPlayMode).w		;shootout?
	beq.w	.5
	cmp.w	#6,d7					;line 6?
	beq.w	.optionup
.5									;line allowed
	bsr.w	SetMenuArea				;printx $10, printy $E, 23 x 13
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(setupmenuchars).w,d4
	movea.l	#SetupMenuMap,a0		;menu background: redraw that part (sflags6 bit 0) over the old frame
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1				;a1 = map data
	move.w	(printx).w,d0
	subq.w	#1,d0
	move.w	d1,d3
	move.w	(printy).w,d1
	subi.w	#$E,d1
	moveq	#$17,d2
	moveq	#0,d5					;no palette lines
	bset	#0,(sflags6).w
	jsr	(dobitmap).l
	bclr	#0,(sflags6).w			;normal maps
	movem.l	(sp)+,d0-d7/a0-a6
	move.w	d7,d3
	bsr.w	SetFrameRect			;the new frame
	move.w	#$6000,(printa).w
	jmp	Framer						;draw the frame
SetMenuArea							;Set the menu area for MoveMenuFrame: printx $10, printy $E, d0 = 23 x d1
									;= 13
	jsr	(printz).l					;map at the menu
	String	CC_Font1,$10,$E			;(and dropped a word)
	move.w	#$17,d0
	move.w	#$D,d1
	rts
SetFrameRectUnused					;An unused copy of SetFrameRect without its printz that uses setupprevline
									;and stops at row $18
	add.w	d3,(printy).w			;add d3 to printy
	move.w	(setupprevline).w,d0	;d0 = setupprevline
	add.w	d0,d0					;2 rows a line
	sub.w	d0,(printy).w			;subtract from printy
	cmpi.w	#$18,(printy).w			;below row $18?
	ble.w	.0						;branch taken: printy is $18 or less
	move.w	#$18,(printy).w			;printy = $18
.0									;frame Y clamped
	moveq	#$17,d0					;width $17
	moveq	#3,d1					;height 3
	cmpi.w	#2,(OptPlayMode).w		;playoffs?
	blt.w	rtsSetup				;branch taken: below 2, return
	cmpi.w	#4,(OptPlayMode).w		;shootout?
	beq.w	rtsSetup				;branch taken: OptPlayMode is 4, return
	cmp.w	#4,d3					;line 4?
	bne.w	rtsSetup				;branch taken: not line 4, return
	moveq	#5,d1					;height 5
	rts								;return
SetFrameRect						;Frame position for line d3 (row $E + d3 - setupfirstline * 2), 23 x 3, or
									;23 x 5 for Team 1 in new playoffs.
									;MoveMenuFrame
	jsr	(printz).l					;map at the first line
	String	CC_Font1,$10,$E			;(and dropped a word)
	add.w	d3,(printy).w			;2 rows per line
	move.w	(setupfirstline).w,d0
	add.w	d0,d0					;2 rows a line
	sub.w	d0,(printy).w
	moveq	#$17,d0
	moveq	#3,d1
	cmpi.w	#2,(OptPlayMode).w		;playoffs?
	blt.w	rtsSetup
	cmpi.w	#4,(OptPlayMode).w		;shootout?
	beq.w	rtsSetup
	cmp.w	#4,d3					;line 4?
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
	cmpi.w	#4,(OptPlayMode).w		;shootout?
	bne.w	.0
	move.w	#1,(OptUserRec).w		;Off
.0									;shootout: user records off
	tst.w	(OptNOP).w				;one player?
	bne.w	.1
	move.w	#1,(OptUserRec).w		;Off
.1									;one player: user records off
	tst.w	(OptNOP).w				;one player?
	bne.w	.2
	move.w	#0,(OptGoalie).w		;goalie on auto
	move.w	#0,(goaliemode1).w		;player 1 auto
	move.w	#0,(goaliemode2).w		;player 2 auto
	tst.w	(OptNOP).w				;one player?
	bne.w	.2
	move.w	#1,(OptGoalie).w		;Auto Control
	move.w	#1,(goaliemode1).w		;both teams
	move.w	#1,(goaliemode2).w		;player 2 manual
.2									;one player: goalie on auto
	move.w	(setupfirstline).w,d0
	cmp.w	(setupprevline).w,d0	;moved?
	beq.w	.3
	bsr.w	PrintOptionNames
.3									;option names redrawn when the scroll moved
	bset	#3,(sflags6).w			;print all
	bsr.w	PrintOptions			;print the options
	bclr	#3,(sflags6).w			;normal
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
	move.w	(OptPlayMode).w,d0
	add.w	d2,d0
	bpl.w	.0
	move.w	#4,d0					;wrap to 4
.0									;mode wrapped
	cmp.w	#4,d0					;shootout?
	bne.w	.1
	move.w	(OptUserRec).w,(TmpOptUserRec).w	;save the user records
	move.w	(OptPen).w,(TmpOptPen).w
	move.w	(OptLine).w,(TmpOptLine).w
.1									;pop the d0/d2 saved above
	movem.w	(sp)+,d0/d2
	tst.w	d7						;mode line?
	bne.w	.2
	tst.w	d2						;change?
	beq.w	.2
	cmpi.w	#4,(OptPlayMode).w		;shootout?
	bne.w	.2
	move.w	(TmpOptUserRec).w,(OptUserRec).w	;restore the user records
	move.w	(TmpOptPen).w,(OptPen).w
	move.w	(TmpOptLine).w,(OptLine).w
.2									;shootout options put back
	movea.w	#(OptPlayMode-M68K_RAM),a2
	movea.l	#OptionLimits,a3
	tst.w	(FourWayPlay).w			;four way?
	beq.w	.3
	movea.l	#OptionLimits4Way,a3
.3									;limits for 1 or 4 pads
	clr.w	d5
	move.w	0(a3,d7.w),d4			;limit
	move.w	0(a2,d7.w),d3
	cmpi.w	#2,(OptPlayMode).w		;playoffs?
	blt.w	.4
	cmpi.w	#4,(OptPlayMode).w		;shootout?
	beq.w	.4
	cmp.w	#4,d7					;line 4?
	bne.w	.4
	moveq	#NumPlayoffTeams,d4		;playoff teams, the all-stars excluded
.4									;limit set
	cmp.w	#2,d7					;players line?
	bne.w	.wrap
	cmpi.w	#4,(OptPlayMode).w		;shootout?
	bne.w	.9
	movem.w	d2,-(sp)
	add.w	(OptNOP).w,d2
	bpl.w	.5
	addq.w	#7,d2					;wrap
.5									;player count wrapped
	cmp.w	#4,d2					;over 4?
	movem.w	(sp)+,d2
	ble.w	.7
	tst.w	d2						;up?
	bpl.w	.6
	move.w	#4,d2
	bra.w	.9
.6									;d2 >= 0
	addq.w	#2,d2
	bra.w	.9
.7									;4 or fewer: wrap with the pad count
	movem.w	d2,-(sp)
	add.w	(OptNOP).w,d2
	cmp.w	#3,d2					;3?
	movem.w	(sp)+,d2
	bne.w	.9
	tst.w	d2						;up?
	bpl.w	.8
	subq.w	#1,d2
	bra.w	.9
.8									;d2 >= 0
	addq.w	#1,d2
.9									;player count set
	moveq	#5,d5					;lowest 5
	tst.w	(FourWayPlay).w			;four way?
	beq.w	.10
	move.w	#$A,d4					;limit $A
	addq.w	#2,d5					;lowest 7
.10									;limits for the adaptor
	cmpi.w	#4,(OptPlayMode).w		;shootout?
	beq.w	.11
	tst.w	(OptPlayMode).w			;league?
	bne.w	.loop
.11									;shootout or league
	clr.w	d5
	moveq	#5,d4					;limit 5
.loop								;each of the 6 slots
	tst.w	(FourWayPlay).w			;four way?
	beq.w	.wrap
	addq.w	#2,d4
.wrap								;wrap the option
	bsr.w	WrapOption
	tst.w	(FourWayPlay).w			;four way?
	beq.w	.set
	cmp.w	#2,d7					;players line?
	bne.w	.set
	tst.w	d2						;down?
	bmi.w	.13
	cmp.w	#9,d3					;9?
	beq.w	.14
	cmp.w	#$A,d3					;$A?
	beq.w	.14
	bra.w	.set
.13									;d2 negative
	cmp.w	#$A,d3					;$A?
	bne.w	.set
	move.w	#8,d3
	bra.w	.set
.14									;d3 = 9 or d3 = $A
	move.w	#$B,d3
.set								;store the option
	move.w	d3,0(a2,d7.w)
	tst.w	d2						;change?
	beq.w	rtsSetup
	cmpi.w	#1,(OptPlayMode).w		;continuing playoffs?
	bne.w	.16
	tst.w	d7						;mode line?
	bne.w	.16
	jsr	(ContinuePlayoffs).l
	move.w	(gamelevel).w,d0
	or.w	(bosgames).w,d0
	beq.s	.loop
	rts
.16									;OptPlayMode <> 1 or d7 <> 0
	cmpi.w	#2,(OptPlayMode).w		;playoffs?
	blt.w	rtsSetup
	cmpi.w	#4,(OptPlayMode).w		;shootout?
	beq.w	rtsSetup
	tst.w	d7						;mode line?
	beq.w	GoNewPlayoffs
	cmp.w	#4,d7					;line 4?
	beq.w	GoNewPlayoffs
	rts
WrapOption							;d3 + d2, wrapped into d5 ... d4-1. Called from ChangeOption
	add.w	d2,d3					;add d2 to d3
	cmp.w	d5,d3					;below the lowest?
	bge.w	.0						;branch taken: d3 at least d5
	move.w	d4,d3					;d3 = d4
	subq.w	#1,d3					;minus 1
.0									;wrapped to the top
	cmp.w	d4,d3					;at the limit?
	blt.w	rtsSetup				;branch taken: d3 below d4, return
	move.w	d5,d3					;d3 = d5
	rts								;return
PrintOptions						;Limit each option (ChangeOption with d2 = 0) and print the lines shown
									;(PrintOptionValue), the scroll marks (PrintScrollMarks) the team bitmaps
									;(DrawMatchupBitmaps) and, unless a player card is up, reset the card
									;timer (ResetCardTimer). Called from FixModeOptions
	move.w	d7,d6
	moveq	#-2,d7
.loop								;loop
	addq.w	#2,d7					;next option
	clr.w	d2
	bsr.w	ChangeOption
	movem.l	d7,-(sp)
	asr.w	#1,d7					;line
	cmp.w	(setupfirstline).w,d7	;on screen?
	movem.l	(sp)+,d7
	blt.w	.0
	bsr.w	PrintOptionValue		;print it
.0									;value printed when on screen
	cmp.w	#$10,d7					;all done?
	bne.s	.loop
	bsr.w	PrintScrollMarks
	move.w	d6,d7
	jsr	(DrawMatchupBitmaps).l
	btst	#0,(setupcardflags).w	;card up?
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
	move.w	(setupfirstline).w,d0
	add.w	d0,d0					;2 rows a line
	sub.w	d0,(printy).w
	add.w	d7,(printy).w
	cmpi.w	#$1B,(printy).w			;below row $1B?
	bgt.w	rtsSetup				;yes: off screen
	subq.w	#1,(printy).w
	move.w	#$11,(printx).w
	cmp.w	#4,d7					;home team line?
	beq.w	PrintOptTeamName		;print the team
	cmp.w	#6,d7					;visitors line?
	beq.w	PrintOptTeamName		;print the team
	movea.l	#OptPlayMode,a0
	move.w	0(a0,d7.w),d3
	movea.l	#OptionValueOffsets,a0	;value Strings of option d7
	adda.w	0(a0,d7.w),a0			;its value Strings
	cmpa.l	#PerLengthValues,a0		;period length?
	bne.w	.0
	cmpi.w	#4,(OptPlayMode).w		;shootout?
	bne.w	.0
	movea.l	#NATxt,a1
	jmp	print
.0									;a0 <> #PerLengthValues or OptPlayMode <> 4
	tst.w	(FourWayPlay).w			;four way?
	beq.w	.loop
	cmp.w	#2,d7					;players line?
	bne.w	.loop
	adda.w	#$B0,a0					;4 way Players list
.loop								;print each option name
	movea.l	a0,a1
	adda.w	(a0),a0
	dbf	d3,.loop					;loop
	jmp	print
PrintScrollMarks					;Print the scroll marks at x 2: '}' at row $19 when more lines follow
									;(first line < 3), '{' at row $F when lines are above (first line > 0),
									;else a space
	move.w	#$19,(printy).w			;printy $19
	movea.l	#ScrollClearTxt,a1		;a1 = clear text
	cmpi.w	#3,(setupfirstline).w	;at the last first line?
	beq.w	.0						;branch taken
	cmpi.w	#4,(OptPlayMode).w		;shootout?
	beq.w	.0						;branch taken
	movea.l	#ScrollDownTxt,a1		;a1 = scroll down text
.0									;down arrow (or a blank)
	move.w	#2,(printx).w			;printx 2
	jsr	(print).l					;print
	movea.l	#ScrollClearTxt,a1		;a1 = clear text
	move.w	#$F,(printy).w			;printy $F
	tst.w	(setupfirstline).w		;at the top?
	beq.w	.1						;branch taken
	movea.l	#ScrollUpTxt,a1			;a1 = scroll up text
.1									;up arrow (or a blank)
	move.w	#2,(printx).w			;printx 2
	jmp	print						;print
ScrollUpTxt	String	'{'				;Scroll marks for PrintScrollMarks
ScrollDownTxt	String	'}'			;scroll down mark
ScrollClearTxt	String	' '			;blank to clear a scroll mark
PrintOptTeamName					;Print team name d3 of option d7 (TeamList city; the full name of the
									;two New York teams, $D / $E).
									;PrintOptionValue
	move.w	(printx).w,-(sp)		;keep printx
	movea.l	#BlankValueTxt,a1		;a1 = blank value text
	jsr	(print).l					;print it
	move.w	(sp)+,(printx).w		;restore printx
	movea.l	#OptPlayMode,a1			;a1 = option table
	move.w	0(a1,d7.w),d3			;d3 = the option value
	movea.w	#TeamList,a1			;a1 = TeamList
	asl.w	#2,d3					;times 4
	movea.l	0(a1,d3.w),a1			;a1 = the team
	lsr.w	#2,d3					;back
	adda.w	Teamname(a1),a1			;a1 = Teamname String
	cmp.w	#$E,d3					;NYR?
	bne.w	.0						;branch taken
	movea.l	#NewYorkRTxt,a1			;full name
	bra.w	.1						;print
.0									;d3 <> $E
	cmp.w	#$D,d3					;NYI?
	bne.w	.1						;branch taken
	movea.l	#NewYorkITxt,a1			;full name
.1									;print the name
	jmp	print						;print
NewYorkITxt							;Full names for the two New York teams (TeamList has only the city).
									;The nicknames are licensed names, so each String (length word, 'New York
									;' and
									;the nickname) is generated from the ROM
	include	..\Extracted\NHL94\Text\NewYorkIName.asm
NewYorkRTxt							;full name of NYR
	include	..\Extracted\NHL94\Text\NewYorkRName.asm
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
	bset	#3,(sflags6).w			;print all
	movea.l	#OptionNames,a1
	move.w	#$F,d0
	move.w	(setupfirstline).w,d1
	add.w	d1,d1					;2 rows a line
	sub.w	d1,d0
	move.w	d0,(printy).w
.loop								;loop
	cmpi.w	#$F,(printy).w			;above the menu?
	bge.w	.0
	adda.w	(a1),a1
	bra.w	.1
.0									;printy >= $F
	cmpi.w	#$19,(printy).w			;past row $19?
	bgt.w	.done
	move.w	#3,(printx).w
	move.w	#0,(printa).w
	move.w	#0,(printm).w
	jsr	(printsmall).l				;print it
.1									;next line
	addq.w	#2,(printy).w			;2 rows on
	bra.s	.loop
.done								;printy > $19
	bclr	#3,(sflags6).w			;normal
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
	move.l	#VBlank_SetOptions,(VBint).w
	move	#$2500,sr				;interrupts on
	bclr	#dfok,(disflags).w		;#dfok - graphics are ready for transfer (clr = not ready)
	bset	#dfng,(disflags).w		;#dfng - dont int graphics
	bclr	#df32c,(disflags).w		;#df32c - 32 bit column mode (clr = off)
	move.w	#0,(VSCRLPM).w
	move.w	#$B400,(VSPRITES).w
	move.w	#$B800,(VmMAP3).w
	move.w	#5,(Map3col).w
	move.w	#$C000,(VmMAP2).w
	move.w	#6,(Map2col).w
	move.w	#$E000,(VmMAP1).w
	move.w	#6,(Map1col).w
	move.w	#0,d0					;fade to color
	jsr	(setVram).l
	jsr	(orjoy).l					;read the pads
	jsr	(LoadSetupTiles).l			;TeamBitmaps+8 tiles 
	move.w	d4,(framercset).w		;frame chars
	movea.l	#SetupFramerMap+8,a2
	jsr	(DecompressGraphicsWithRemap).l
	dc.l	$03567564,$89ABCDEF		;remap table (/ or.l, a word dropped)
	move.w	d4,(smallfontchars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithRemap).l
	dc.l	$0FC04567,$89ABCDEF		;remap table (/ or.l)
	move.w	d4,(setupfontchars).w
	movea.l	#PrintFont2Map+8,a2		;setup screen font (printsmall with sflags6 bit 3)
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
	movea.l	#GameSetUpMap,a0
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
	move.w	d4,(vispicchars).w
	addi.w	#$24,d4
	jsr	(printz).l					;map at the second layer
	String	CC_Font1,0,0			;x3
	movea.l	#GameSetUpMap2,a0
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
	move.w	d4,(setupmenuchars).w
	movea.l	#SetupMenuMap,a0		;menu background, 38 x 13 at x 1, y $E
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
	move.w	d4,(homepicchars).w
	addi.w	#$24,d4
	move.w	d4,(logobox1chars).w	;logo box 1 chars
	movea.l	#LogoBoxMap+8,a2		;logo box tiles
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,(logobox2chars).w	;logo box 2 chars
	movea.l	#LogoBoxMap+8,a2
	jsr	(DecompressGraphicsWithRemap).l
	dc.l	$03414567,$89ABCDEF		;remap table (/ or.l, a word dropped)
	jsr	(defaultsprites_0).l
	move.w	#$28,(SortCords+rosxoff).w
	move.w	#$28,(SortCords+(6*SCstruct)+rosxoff).w
	st	(tmstruct).w				;no home team block yet
	st	(awtmstruct).w				;no visitors block yet
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
	move.w	(Vcount).w,d1			;frame count
	sub.w	(OldVcount).w,d1		;changed?
	beq.s	.loop
	move.w	(Vcount).w,(OldVcount).w	;new frame count
	bclr	#5,(setupcardflags).w	;no press yet
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
	bset	#5,(setupcardflags).w
.1									;pad 2
	jsr	(ReadJoy2).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1						;any press?
	beq.w	.2
	btst	#5,d1					;C?
	beq.w	.x						;no: return the press
	bset	#5,(setupcardflags).w	;press seen
.2									;pad 3 (with the adaptor)
	tst.w	(FourWayPlay).w			;four way?
	beq.w	.4
	jsr	(ReadJoy3).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1						;any press?
	beq.w	.3
	btst	#5,d1					;C?
	beq.w	.x						;no: return the press
	bset	#5,(setupcardflags).w	;press seen
.3									;pad 4
	jsr	(ReadJoy4).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1						;any press?
	beq.w	.4
	btst	#5,d1					;C?
	beq.w	.x						;no: return the press
	bset	#5,(setupcardflags).w	;press seen
.4									;redraw the team blocks when flagged
	btst	#6,(setupcardflags).w	;visitors block flagged?
	beq.w	.5
	btst	#7,(setupcardflags).w	;home flagged too?
	bne.w	.6
	move.w	(setupvis).w,(logoteam).w
	bsr.w	DrawVisBlock
.5									;visitors block done
	btst	#7,(setupcardflags).w	;home block flagged?
	beq.w	.6
	move.w	(setuphome).w,(logoteam).w
	bsr.w	DrawHomeBlock
.6									;home block done
	cmp.w	#$4650,d6				;the first $E10 frames (a minute)?
	bgt.w	.timer
	btst	#0,(setupcardflags).w	;card up?
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
	clr.w	(demoflag).w			;clear demoflag
	move.w	(HVcount).l,(seed).w	;seed from the beam
	move.w	(HVcount).l,(seed+2).w	;seed+2 from the beam
	clr.w	(OptPlayMode).w			;clear OptPlayMode
	clr.w	(OptNOP).w				;clear OptNOP
	clr.w	(OptLine).w				;line changes off
	move.w	#1,(OptPen).w			;OptPen = 1
SetupStart							;Start pressed: Copy Goalies to both teams, set pojoy, seed the RNG
									;(seed), and keep OptLine / OptPlayMode in TmpOptLine2 / TempOptPlayMode:
									;Auto line changes play as On with sflags7 bit 4, Shootout as Regular
									;Season with gmode2 bit 0 (ClearShootout). Then jmp MakeTree. Branched to
									;from GameSetUp
	move.w	(OptGoalie).w,-(sp)
	move.w	(sp),(goaliemode1).w
	move.w	(sp)+,(goaliemode2).w
	jsr	(UpdatePlayoffLevel).l
	move.w	(HVcount).l,(seed).w	;seed from the beam
	move.w	(HVcount).l,(seed+2).w
	move.w	(OptLine).w,(TmpOptLine2).w
	cmpi.w	#2,(OptLine).w			;auto?
	bne.w	.0
	clr.w	(OptLine).w
	bset	#4,(sflags7).w			;auto line changes
.0									;line changes set for the game
	move.w	(OptPlayMode).w,(TempOptPlayMode).w	;save the play mode
	cmpi.w	#4,(OptPlayMode).w		;shootout?
	bne.w	.1
	move.w	#0,(OptPlayMode).w		;league
	bset	#0,(gmode2).w			;shootout flag
	jsr	(ClearShootout).l
.1									;shootout set up
	jmp	MakeTree					;build the playoff tree
CheckNOPUnused						;unreferenced. Tests OptNOP for 0, 5, 6, 9 and $A and returns: no effect
	tst.w	(OptNOP).w				;0?
	beq.w	.x
	cmpi.w	#5,(OptNOP).w			;5?
	beq.w	.x
	cmpi.w	#6,(OptNOP).w			;6?
	beq.w	.x
	cmpi.w	#9,(OptNOP).w			;9?
	beq.w	.x
	cmpi.w	#$A,(OptNOP).w			;$A?
.x									;exit (also the end of the code above)
	rts
LoadSetupTiles						;Load the TeamBitmaps+8 tiles from char 2, then again remapped
									;teambitmapchars.
									;Called
									;from setoptions
	moveq	#2,d4					;first char 2
	movea.l	#TeamBitmaps+8,a2		;the tiles
	jsr	(DecompressGraphicsPlain).l	;decompress them as they are
	move.w	d4,(teambitmapchars).w	;remember the first char
	movea.l	#TeamBitmaps+8,a2		;the tiles again
	jsr	(DecompressGraphicsWithRemap).l	;decompress them with the remap table
	dc.l	$03412567,$89ABCDEF		;remap table (/ move.l / dc.b)
	rts								;done
UpdateRosterPlayers					;An empty routine, called from ReadSetupPads. An unused rts follows
	rts
	rts
EraseCard							;If a player card is up (setupcardflags bit 0, cleared here), clear both
									;logo flags (bits 6 / 7) and erase the card: its logo box and its 25 x 8
									;box. Called from DrawHomeBlock and DrawVisBlock
	movem.l	d0-d7,-(sp)
	bclr	#0,(setupcardflags).w	;card up?
	beq.w	.x
	bclr	#6,(setupcardflags).w	;no visitors block
	bclr	#7,(setupcardflags).w	;no home block
	jsr	(printz).l					;map at the card
	String	CC_Font1Pal1,0,0		;x3
	move.w	#5,(printy).w
	moveq	#8,d0
	moveq	#8,d1
	move.w	#$7FF,d2				;blank char
	btst	#1,(setupcardflags).w	;visitors side?
	beq.w	.1
	move.w	#3,(printx).w
	jsr	(eraser).l
	jsr	(printz).l					;map at the text
	String	CC_Font1,0,0			;x3
	move.w	#$B,(printx).w
	move.w	#5,(printy).w
	move.w	#$19,d0
	move.w	#8,d1
.0									;(not branched to)
	move.w	#$7FF,d2				;blank char
	jsr	(eraser).l
	bra.w	.x
.1									;bit 1 of setupcardflags clear
	move.w	#$1C,(printx).w
	jsr	(eraser).l
	jsr	(printz).l					;map at the text
	String	CC_Font1,0,0			;x3
	move.w	#3,(printx).w
	move.w	#5,(printy).w
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
	bset	#2,(setupcardflags).w	;home side
	bset	#6,(setupcardflags).w	;home block up
	bsr.w	LogoBoxHome				;logo box
	bclr	#3,(setupcardflags).w	;visitors side?
	beq.w	.0
	jsr	(printz).l					;map at the area
	String	CC_Font1Pal1,0,0		;x3
	move.w	#8,(printx).w
	move.w	#5,(printy).w
	moveq	#8,d0
	moveq	#8,d1
	move.w	#$7FF,d2				;blank char
.0									;home logo box done
	jsr	(printz).l					;map at the logo
	String	CC_Font1,0,0			;x3
	move.w	#$19,(printx).w
	bra.w	DrawTeamLogo
DrawVisBlock						;The same for the visitors: logo box, logo at x 9. setupcardflags bit 3,
									;bit 7. Called from GameSetUp and ReadSetupPads
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	EraseCard
	bset	#3,(setupcardflags).w	;visitors side
	bset	#7,(setupcardflags).w	;visitors block up
	bsr.w	LogoBoxVis				;logo box
	bclr	#2,(setupcardflags).w	;home side?
	beq.w	.0
	jsr	(printz).l					;map at the area
	String	CC_Font1Pal1,0,0		;x3
	move.w	#$18,(printx).w
	move.w	#5,(printy).w
	moveq	#8,d0
	moveq	#8,d1
	move.w	#$7FF,d2				;blank char
.0									;visitors logo box done
	jsr	(printz).l					;map at the logo
	String	CC_Font1Pal3,0,0
	move.w	#9,(printx).w
DrawTeamLogo						;Draw the logo of team logoteam at printx, y 6, 6 x 6, palette
									;TeamLogoPalettes + team * 8 - $20 (home, color fam
									;2) or - $40 (visitors, color fam 3), then wait $B4 frames before a player
									;card (carddelay). Branched to
	;  from DrawHomeBlock
	move.w	#$B4,(carddelay).w		;card delay $B4
	move.w	#6,(printy).w			;printy 6
	move.w	(homepicchars).w,d4		;d4 = home picture chars
	btst	#2,(setupcardflags).w	;home?
	bne.w	.0						;branch taken
	move.w	(vispicchars).w,d4		;d4 = visiting picture chars
.0									;picture tiles chosen
	move.w	(logoteam).w,d3			;d3 = logo team
	asl.w	#2,d3					;times 4
	movea.l	#TeamLogoBitmaps,a0		;a0 = team logo bitmaps
	movea.l	0(a0,d3.w),a0			;its logo
	movea.l	a0,a1					;a1 = the bitmap
	movea.l	a0,a2					;a2 = the bitmap
	adda.l	(a2)+,a0				;skip the palette offset
	asl.w	#3,d3					;32 bytes per team
	movea.l	#TeamLogoPalettes,a0	;a0 = team logo palettes
	btst	#2,(setupcardflags).w	;home?
	beq.w	.1						;branch taken
	subi.w	#$20,d3					;minus $20
	bra.w	.2						;go on
.1									;bit 2 of setupcardflags clear
	subi.w	#$40,d3					;minus $40
.2									;palette offset chosen
	adda.w	d3,a0					;plus d3
	adda.l	(a2)+,a1				;plus the bitmap offset
	move.w	#6,d3					;d3 = 6
	move.w	#6,d2					;d2 = 6
	clr.w	d0						;d0 = 0
	clr.w	d1						;d1 = 0
	move.l	(palfadenew+$22).w,-(sp)	;keep palette long
	move.l	(palfadenew+$26).w,-(sp)	;keep palette long
	move.w	#4,d5					;d5 = 4
	btst	#2,(setupcardflags).w	;home?
	beq.w	.draw					;branch taken
	move.w	#2,d5					;d5 = 2
.draw								;palette line chosen
	jsr	(dobitmap).l				;draw the bitmap
	move.l	(sp)+,(palfadenew+$26).w	;restore palette long
	move.l	(sp)+,(palfadenew+$22).w	;restore palette long
	move.w	#$64,(palcount).w		;fade in
	movem.l	(sp)+,d0-d7/a0-a6		;restore registers
	rts								;done
TeamLogoBitmaps						;Team logo bitmaps by team number (TeamList
									;order); also used by GetTeamLogo
	dc.l	logoANH,logoBOS,logoBUF,logoCGY,logoCHI,logoDAL,logoDET,logoEDM
	dc.l	logoFLA,logoHFD,logoLA,logoMTL,logoNJ,logoNYI,logoNYR,logoOTW
	dc.l	logoPHI,logoPIT,logoQUE,logoSJ,logoSTL,logoTB,logoTOR,logoVAN
	dc.l	logoWSH,logoWPG,logoASE,logoASW
TeamLogoBitmapsEnd					;end of TeamLogoBitmaps (size check below)
	IF (TeamLogoBitmapsEnd-TeamLogoBitmaps)<>(NumTeams*4)
		inform	3,"TeamLogoBitmaps needs one entry per team"
	ENDIF
LogoBoxRight						;Logo box (LogoBoxMap, 8 x 8) at x $1C, y 5 with the logobox1chars tiles.
									;Called from PlayerCardScreen
	move.w	(logobox1chars).w,d4
	move.w	#$1C,(printx).w
	bra.w	DrawLogoBox
LogoBoxHome							;Logo box at x $18 (home block). Called from DrawHomeBlock
	move.w	(logobox1chars).w,d4
	move.w	#$18,(printx).w
	bra.w	DrawLogoBox
LogoBoxLeft							;Logo box at x 3 with the logobox2chars tiles.
									;Called from PlayerCardScreen
	move.w	(logobox2chars).w,d4
	move.w	#3,(printx).w
	bra.w	DrawLogoBox
LogoBoxVis							;Logo box at x 8 (visitors block). Called from DrawVisBlock
	move.w	(logobox2chars).w,d4
	move.w	#8,(printx).w
DrawLogoBox							;Draw the LogoBoxMap box at printx, y 5 (sflags6 bit 0 set). Branched to
									;from LogoBoxRight ... LogoBoxVis
	clr.w	(printa).w				;print attribute 0
	move.w	#5,(printy).w			;printy 5
	movea.l	#LogoBoxMap,a0			;logo box map
	movea.l	a0,a1					;a1 = the map
	movea.l	a0,a2					;a2 = the map
	adda.l	(a2)+,a0				;plus the data offset
	adda.l	(a2)+,a1				;a1 = map data
	move.w	#8,d3					;d3 = 8
	move.w	#8,d2					;d2 = 8
	clr.w	d0						;d0 = 0
	clr.w	d1						;d1 = 0
	move.w	#0,d5					;no palette lines
	bset	#0,(sflags6).w			;set sflags6 bit 0
	jsr	(dobitmap).l				;draw the bitmap
	bclr	#0,(sflags6).w			;normal maps
	rts								;done
