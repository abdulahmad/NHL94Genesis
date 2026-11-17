GameSetUp						;Game setup screen, called from PeriodOver. Builds the screen
									;(setoptions), then runs the menu: up / down move the frame, left / right
									;change the option (ChangeOption) and redraw (FixModeOptions), start
									;begins the game (SetupStart), and $5460 frames without a press start a
									;demo (SetupDemo).
	jsr	(ReadLineDataBackupRead).l
	movea.l	#passbits,a3
	jsr	(InitPlayerSlots).l
	move.w	(TmpOptLine2).l,(OptLine).l
	move.w	(TempOptPlayMode).l,(OptPlayMode).l
	bclr	#1,(sflags7).l		;no overtime
	jsr	(ClampPositionBoxClear).l
	jsr	(ReadNameLog).l		;read the SRAM name list
	bsr.w	OptionsScreenSetup		;build the screen
	clr.w	(setupfirstline).l
	clr.w	(setupprevline).l
	bsr.w	PrintOptionNames
	tst.w	(demoflag).l
	bne.w	.next
	moveq	#$1C,d0
	jsr	(randomd0).l
	move.w	d0,(Opt1team).l
	moveq	#$1C,d0
	jsr	(randomd0).l
	move.w	d0,(Opt2team).l
.next	st.b	(demoflag).l
	cmpi.w	#4,(OptPlayMode).l
	bne.w	.newplay
	bra.w	.reggame
.newplay	cmpi.w	#2,(OptPlayMode).l
	blt.w	.contplay
	bsr.w	GameSetUpJumpA
.contplay	cmpi.w	#1,(OptPlayMode).l
	bne.w	.reggame		;not continue playoffs
	bsr.w	GameSetUpJumpB
.reggame	clr.w	d7		;menu line 0 (d7 = line * 2 = offset in OptPlayMode ... OptLine)
	clr.w	d0
	bsr.w	MoveMenuFrame		;frame the line
	bsr.w	FixModeOptions		;print the options
	move.w	(HomeTeam).l,(setuphome).l
	move.w	(HomeTeam).l,(logoteam).l
	bsr.w	DrawHomeBlock
	move.w	(VisTeam).l,(setupvis).l
	move.w	(VisTeam).l,(logoteam).l
	bsr.w	DrawVisBlock
	move.w	#$18,(palcount).l
	bclr	#dfng,(disflags).l		;dfng: fade in graphics now
.loop
	cmpi.w	#4,(OptPlayMode).l
	bne.w	.0
	move.w	#1,(OptLine).l
	move.w	#0,(OptPen).l
	move.w	#1,(OptUserRec).l
.0	bsr.w	ReadSetupPads
	tst.w	d1
	bne.w	.1
	bra.w	SetupPadsSyncRead
.1	btst	#sbut,d1
	bne.w	SetupPadsPlayoffLevelRead
	btst	#dbut,d1
	beq.w	.9
	tst.w	(OptNOP).l
	bne.w	.2
	cmpi.w	#$8,d7
	bne.w	.2
	move.w	#4,d0
	bra.w	.3
.2	move.w	#2,d0
.3	cmpi.w	#4,(OptPlayMode).l
	beq.w	.next8
	tst.w	(OptNOP).l
	bne.w	.next8
	cmpi.w	#$8,d7
	bne.w	.next8
	move.w	#6,d0
	bra.w	.8
.next8	cmpi.w	#$6,d7
	bne.w	.next9
	cmpi.w	#4,(OptPlayMode).l
	bne.w	.next9
	tst.w	(OptNOP).l
	bne.w	.7
	clr.w	d0
	bra.w	.8
.next9	cmpi.w	#$A,d7
	bne.w	.8
	cmpi.w	#4,(OptPlayMode).l
	bne.w	.6
	clr.w	d0
	bra.w	.8
.6	tst.w	(ValidSRAM).l
	bpl.w	.8
.7	move.w	#4,d0
.8	bsr.w	MoveMenuFrame
	bsr.w	FixModeOptions
	bra.w	.loop
.9	btst	#ubut,d1
	beq.w	.15
	tst.w	(OptNOP).l
	bne.w	.10
	cmpi.w	#$C,d7
	bne.w	.10
	move.w	#$FFFC,d0
	bra.w	.next15
.10	move.w	#$FFFE,d0
	cmpi.w	#4,(OptPlayMode).l
	beq.w	.next15
	tst.w	(OptNOP).l
	bne.w	.next15
	cmpi.w	#$E,d7
	bne.w	.next15
	move.w	#$FFFA,d0
	bra.w	.14
.next15	cmpi.w	#$A,d7
	bne.w	.next16
	cmpi.w	#4,(OptPlayMode).l
	beq.w	.13
.next16	cmpi.w	#$E,d7
	bne.w	.14
	cmpi.w	#4,(OptPlayMode).l
	beq.w	.13
	tst.w	(ValidSRAM).l
	bpl.w	.14
.13	move.w	#$FFFC,d0
.14	bsr.w	MoveMenuFrame
	bsr.w	FixModeOptions
	bra.w	.loop
.15	moveq	#1,d2
	btst	#rbut,d1
	bne.w	.16
	btst	#lbut,d1
	beq.w	.loop
	moveq	#-1,d2
.16	cmpi.w	#4,(OptPlayMode).l
	beq.w	.17
	jsr	(FigureJoy).l
.17	move.w	(Opt2team).l,-(sp)
	move.w	(Opt1team).l,-(sp)
	bsr.w	ChangeOption
	move.w	(sp)+,d0
	cmpi.w	#4,(OptPlayMode).l
	beq.w	.18
	tst.w	(OptPlayMode).l
	bne.w	.19
.18	move.w	(Opt1team).l,(HomeTeam).l
	move.w	(Opt2team).l,(VisTeam).l
.19	move.w	(HomeTeam).l,(logoteam).l
	btst	#6,(setupcardflags).l
	beq.w	.20
	movem.w	d0,-(sp)
	move.w	(setuphome).l,d0
	cmp.w	(HomeTeam).l,d0
	movem.w	(sp)+,d0
	beq.w	.21
.20	move.w	(HomeTeam).l,(setuphome).l
	bsr.w	DrawHomeBlock
.21	btst	#7,(setupcardflags).l
	beq.w	.22
	movem.w	d0,-(sp)
	move.w	(setupvis).l,d0
	cmp.w	(VisTeam).l,d0
	movem.w	(sp)+,d0
	beq.w	.23
.22	move.w	(VisTeam).l,(setupvis).l
	move.w	(VisTeam).l,(logoteam).l
	bsr.w	DrawVisBlock
	move.w	(HomeTeam).l,(logoteam).l
.23	tst.w	(sp)+
	bra.w	.fix
; Code kept as words after GameSetUp (the 118 bytes are decoded in the row comments).
	dc.w	$301F,$B079,$0001,$7FB0,$6700,$006C,$33F9,$0001		; move.w (a7)+, d0 / cmp.w $17fb0.l, d0 / beq.w *+110 / move.w $17fb0.l, $1938a.l
	dc.w	$7FB0,$0001,$938A,$48A7,$8000,$3039,$0001,$7FB0		; movem.w d0, -(a7) / move.w $17fb0.l, d0
	dc.w	$B079,$0001,$7FB0,$4C9F,$0001,$6700,$0010,$33F9		; cmp.w $17fb0.l, d0 / movem.w (a7)+, d0 / beq.w *+18 / move.w $17fb0.l, $1938e.l
	dc.w	$0001,$7FB0,$0001,$938E,$6100,$1274,$48A7,$8000		; bsr.w *+4726 / movem.w d0, -(a7)
	dc.w	$3039,$0001,$938C,$B079,$0001,$7FAE,$4C9F,$0001		; move.w $1938c.l, d0 / cmp.w $17fae.l, d0 / movem.w (a7)+, d0
	dc.w	$6700,$0024,$33F9,$0001,$7FAE,$0001,$938C,$33F9		; beq.w *+38 / move.w $17fae.l, $1938c.l / move.w $17fae.l, $1938a.l
	dc.w	$0001,$7FAE,$0001,$938A,$6100,$11E0,$33F9,$0001		; bsr.w *+4578 / move.w $17fb0.l, $1938a.l
	dc.w	$7FB0,$0001,$938A
.fix
	bsr.w	FixModeOptions
	bra.w	.loop
	rts
; Jumps to the disc routine at $401C4.
GameSetUpJumpA
	jmp	(DefaultMenusRandomPick).l
; Jumps to the disc routine at $40132.
GameSetUpJumpB
	jmp	(DefaultMenusInit).l
MoveMenuFrame						;Move the menu frame by d0 (+2 / -2 lines). Shows 6 of the 9 lines and
									;scrolls: setupfirstline = first line shown
									;(0-3), setupprevline = the one before (sflags5 bit 2 set on a scroll;
									;FixModeOptions reprints the names when they differ). Continue playoffs
									;skips lines 1-3, new playoffs line 3 (Team 2). The old frame is erased by
									;redrawing the SetupMenuMap background under it. Called from GameSetUp
	move.w	d7,d3
.optionup	bclr	#2,(sflags5).l		;not scrolled yet
	tst.w	d0		;direction?
	bpl.w	.optiondown
	move.w	d0,-(sp)
	move.w	d7,d0
	asr.w	#1,d0		;lines
	cmp.w	(setupfirstline).l,d0
	bne.w	.noscroll
	move.w	(setupfirstline).l,(setupprevline).l
	bset	#2,(sflags5).l
	subi.w	#$1,(setupfirstline).l
	bpl.w	.noscroll
	clr.w	(setupfirstline).l
.noscroll	move.w	(sp)+,d0
.optiondown	move.w	d7,(TempWord1).l
	add.w	d0,d7
	bpl.w	.0		;not above line 0
	clr.w	d7		;clamp to line 0
.0	tst.w	d0		;moving?
	bmi.w	.3
	move.w	d0,-(sp)
	move.w	d7,d0
	asr.w	#1,d0		;lines
	sub.w	(setupfirstline).l,d0
	cmpi.w	#$5,d0		;past row 5?
	bgt.w	.scrolldown		;below the frame: scroll
	bra.w	.2
.scrolldown	move.w	(setupfirstline).l,(setupprevline).l
	bset	#2,(sflags5).l
	addi.w	#$1,(setupfirstline).l
	move.w	d7,d0
	asr.w	#1,d0
	sub.w	(setupfirstline).l,d0
	cmpi.w	#$5,d0
	ble.w	.1
	addi.w	#$1,(setupfirstline).l
.1	cmpi.w	#3,(setupfirstline).l
	ble.w	.2
	move.w	#3,(setupfirstline).l
.2	move.w	(sp)+,d0
.3	btst	#2,(sflags5).l		;scrolled?
	bne.w	.4
	move.w	(setupfirstline).l,(setupprevline).l
.4	cmpi.w	#$12,d7		;past the last line (Line Changes)
	blt.w	.contplayoffs
	sub.w	d0,d7
.contplayoffs	cmpi.w	#1,(OptPlayMode).l
	bne.w	.newplay
	tst.w	d7		;top line?
	beq.w	.newplay
	cmpi.w	#$6,d7		;line 6 or above?
	bls.w	.optionup
.newplay	cmpi.w	#2,(OptPlayMode).l
	blt.w	.5
	cmpi.w	#4,(OptPlayMode).l
	beq.w	.5
	cmpi.w	#$6,d7		;line 6?
	beq.w	.optionup
.5	bsr.w	.next7		;printx $10, printy $E, 23 x 13
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(setupmenuchars).l,d4
	movea.l	$47D74.l,a0		;menu background: redraw that part (sflags6 bit 0) over the old frame
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1		;a1 = map data
	move.w	(printx).l,d0
	subi.w	#$1,d0
	move.w	d1,d3
	move.w	(printy).l,d1
	subi.w	#$E,d1
	moveq	#$17,d2
	moveq	#0,d5		;no palette lines
	bset	#0,(sflags6).l
	jsr	(dobitmap).l
	bclr	#0,(sflags6).l		;normal maps
	movem.l	(sp)+,d0-d7/a0-a6
	move.w	d7,d3
	bsr.w	PrintFont1Title		;the new frame
	move.w	#$6000,(printa).l
	jmp	(Framer).l
.next7	jsr	(printz).l
	String	CC_Font1,$10,$E
	move.w	#$17,d0
	move.w	#$D,d1
	rts
SetFrameRectUnused						;An unused copy of SetFrameRect without its printz that uses setupprevline
									;and stops at row $18
	add.w	d3,(printy).l
	move.w	(setupprevline).l,d0
	add.w	d0,d0		;2 rows a line
	sub.w	d0,(printy).l
	cmpi.w	#$18,(printy).l		;below row $18?
	ble.w	.0
	move.w	#$18,(printy).l
.0	moveq	#$17,d0
	moveq	#3,d1
	cmpi.w	#2,(OptPlayMode).l
	blt.w	SetFrameRectUnusedExit
	cmpi.w	#4,(OptPlayMode).l
	beq.w	SetFrameRectUnusedExit
	cmpi.w	#$4,d3		;line 4?
	bne.w	SetFrameRectUnusedExit
	moveq	#5,d1
	rts
; Prints a title in font 1 and adjusts printy.
PrintFont1Title	jsr	(printz).l
	String	CC_Font1,$10,$E
	add.w	d3,(printy).l
	move.w	(setupfirstline).l,d0
	add.w	d0,d0
	sub.w	d0,(printy).l
	moveq	#$17,d0
	moveq	#$3,d1
	cmpi.w	#$2,(OptPlayMode).l
	blt.w	SetFrameRectUnusedExit
	cmpi.w	#$4,(OptPlayMode).l
	beq.w	SetFrameRectUnusedExit
	cmpi.w	#$4,d3
	bne.w	SetFrameRectUnusedExit
	moveq	#$5,d1
SetFrameRectUnusedExit
	rts
FixModeOptions						;Fix the options a mode does not allow, then print them: Shootout and Demo
									;set User Records Off, Demo sets both goalies to
									;Auto Control. Reprint the option names (PrintOptionNames) after a scroll,
									;then the values (PrintOptions) in the setup font (sflags6 bit 3:
									;printsmall uses setupfontchars). Called from GameSetUp
	movem.l	d0-d7/a0-a6,-(sp)
	cmpi.w	#4,(OptPlayMode).l
	bne.w	.0
	move.w	#1,(OptUserRec).l
.0	tst.w	(OptNOP).l
	bne.w	.1
	move.w	#1,(OptUserRec).l
.1	tst.w	(OptNOP).l		;one player?
	bne.w	.2
	move.w	#0,(OptGoalie).l		;Off
	move.w	#0,(goaliemode1).l
	move.w	#0,(goaliemode2).l
	tst.w	(OptNOP).l		;one player?
	bne.w	.2
	move.w	#1,(OptGoalie).l		;goalie on auto
	move.w	#1,(goaliemode1).l
	move.w	#1,(goaliemode2).l
.2	move.w	(setupfirstline).l,d0
	cmp.w	(setupprevline).l,d0
	beq.w	.3
	bsr.w	PrintOptionNames
.3	bset	#3,(sflags6).l		;print all
	bsr.w	PrintOptions		;print the options
	bclr	#3,(sflags6).l		;normal
	movem.l	(sp)+,d0-d7/a0-a6
	rts
; Data that follows FixModeOptions (strings, small tables)
FixModeOptionsData	dc.w	$0005,$0008,$001C,$001C,$0003,$0002,$0002,$0003
	dc.w	$0003,$0005,$000C,$001C,$001C,$0003,$0002,$0002
	dc.w	$0003,$0003
ChangeOption
	tst.w	d7
	bne.w	.next3
	movem.w	d0/d2,-(sp)
	tst.w	d2
	beq.w	.1
	move.w	(OptPlayMode).l,d0
	add.w	d2,d0
	bpl.w	.next
	move.w	#4,d0
.next	cmpi.w	#$4,d0
	bne.w	.1
	move.w	(OptUserRec).l,(TmpOptUserRec).l
	move.w	(OptPen).l,(TmpOptPen).l
	move.w	(OptLine).l,(TmpOptLine).l
.1	movem.w	(sp)+,d0/d2
	tst.w	d7
	bne.w	.next3
	tst.w	d2
	beq.w	.next3
	cmpi.w	#4,(OptPlayMode).l
	bne.w	.next3
	move.w	(TmpOptUserRec).l,(OptUserRec).l
	move.w	(TmpOptPen).l,(OptPen).l
	move.w	(TmpOptLine).l,(OptLine).l
.next3	movea.l	#OptPlayMode,a2
	movea.l	#$23A68,a3
	tst.w	(FourWayPlay).l
	beq.w	.3
	movea.l	#$23A7A,a3
.3	clr.w	d5
	move.w	(a3,d7.w),d4
	move.w	(a2,d7.w),d3
	cmpi.w	#2,(OptPlayMode).l
	blt.w	.next5
	cmpi.w	#4,(OptPlayMode).l
	beq.w	.next5
	cmpi.w	#$4,d7
	bne.w	.next5
	moveq	#NumPlayoffTeams,d4
.next5	cmpi.w	#$2,d7
	bne.w	.wrap
	cmpi.w	#4,(OptPlayMode).l
	bne.w	.9
	movem.w	d2,-(sp)
	add.w	(OptNOP).l,d2
	bpl.w	.next6
	addi.w	#$7,d2
.next6	cmpi.w	#$4,d2
	movem.w	(sp)+,d2
	ble.w	.7
	tst.w	d2
	bpl.w	.next7
	move.w	#4,d2
	bra.w	.9
.next7	addi.w	#$2,d2
	bra.w	.9
.7	movem.w	d2,-(sp)
	add.w	(OptNOP).l,d2
	cmpi.w	#$3,d2
	movem.w	(sp)+,d2
	bne.w	.9
	tst.w	d2
	bpl.w	.next9
	subi.w	#$1,d2
	bra.w	.9
.next9	addi.w	#$1,d2
.9	moveq	#5,d5
	tst.w	(FourWayPlay).l
	beq.w	.10
	move.w	#$A,d4
	addi.w	#$2,d5
.10	cmpi.w	#4,(OptPlayMode).l
	beq.w	.11
	tst.w	(OptPlayMode).l
	bne.w	.loop
.11	clr.w	d5
	moveq	#5,d4
.loop	tst.w	(FourWayPlay).l
	beq.w	.wrap
	addi.w	#$2,d4
.wrap	bsr.w	WrapOption
	tst.w	(FourWayPlay).l
	beq.w	.set
	cmpi.w	#$2,d7
	bne.w	.set
	tst.w	d2
	bmi.w	.next14
	cmpi.w	#$9,d3
	beq.w	.14
	cmpi.w	#$A,d3
	beq.w	.14
	bra.w	.set
.next14	cmpi.w	#$A,d3
	bne.w	.set
	move.w	#8,d3
	bra.w	.set
.14	move.w	#$B,d3
.set	move.w	d3,(a2,d7.w)
	tst.w	d2
	beq.w	SetFrameRectUnusedExit
	cmpi.w	#1,(OptPlayMode).l
	bne.w	.16
	tst.w	d7
	bne.w	.16
	jsr	(DefaultMenusInit).l
	move.w	(gamelevel).l,d0
	or.w	(bosgames).l,d0
	beq.w	.loop
	rts
.16	cmpi.w	#2,(OptPlayMode).l
	blt.w	SetFrameRectUnusedExit
	cmpi.w	#4,(OptPlayMode).l
	beq.w	SetFrameRectUnusedExit
	tst.w	d7
	beq.w	GameSetUpJumpA
	cmpi.w	#$4,d7
	beq.w	GameSetUpJumpA
	rts
WrapOption						;d3 + d2, wrapped into d5 ... d4-1. Called from ChangeOption
	add.w	d2,d3
	cmp.w	d5,d3		;below the lowest?
	bge.w	.0
	move.w	d4,d3
	subq.w	#1,d3
.0	cmp.w	d4,d3		;at the limit?
	blt.w	SetFrameRectUnusedExit
	move.w	d5,d3
	rts
PrintOptions
	move.w	d7,d6
	move.l	#$FFFFFFFE,d7
.loop	addi.w	#$2,d7
	clr.w	d2
	bsr.w	ChangeOption
	movem.l	d7,-(sp)
	asr.w	#1,d7
	cmp.w	(setupfirstline).l,d7
	movem.l	(sp)+,d7
	blt.w	.next
	bsr.w	PrintOptionValue
.next	cmpi.w	#$10,d7
	bne.w	.loop
	bsr.w	PrintScrollMarks
	move.w	d6,d7
	jsr	(TeamIcons).l
	btst	#0,(setupcardflags).l
	bne.w	.x
	jsr	(ResetCardTimer).l
.x	rts
PrintOptionValue						;print the value of option d7 at x $11 on its line (past row $1B:
									;nothing). Team 1 / 2 go to PrintOptTeamName Per. Length in
									;Shootout prints 'N/A'; Players with FourWayPlay uses the second list
									;(+$B0). Called from PrintOptions
	jsr	(printz).l
	String	CC_Font1Pri,$11,$10
	move.w	(setupfirstline).l,d0
	add.w	d0,d0		;2 rows a line
	sub.w	d0,(printy).l
	add.w	d7,(printy).l
	cmpi.w	#$1B,(printy).l		;below row $1B?
	bgt.w	SetFrameRectUnusedExit		;yes: off screen
	subi.w	#$1,(printy).l
	move.w	#$11,(printx).l
	cmpi.w	#$4,d7		;home team line?
	beq.w	PrintOptTeamName		;print the team
	cmpi.w	#$6,d7		;visitors line?
	beq.w	PrintOptTeamName		;print the team
	movea.l	#OptPlayMode,a0
	move.w	(a0,d7.w),d3
	movea.l	#OptionValueOffsets,a0
	adda.w	(a0,d7.w),a0		;its value Strings
	cmpa.l	#PerLengthValues,a0		;period length?
	bne.w	.0
	cmpi.w	#4,(OptPlayMode).l
	bne.w	.0
	movea.l	#$23EB6,a1
	jmp	(print).l
.0	tst.w	(FourWayPlay).l
	beq.w	.loop
	cmpi.w	#$2,d7		;players line?
	bne.w	.loop
	adda.w	#$B0,a0		;4 way Players list
.loop	movea.l	a0,a1
	adda.w	(a0),a0
	dbra	d3,.loop
	jmp	(print).l
PrintScrollMarks						;Print the scroll marks at x 2: '}' at row $19 when more lines follow
									;(first line < 3), '{' at row $F when lines are above (first line > 0),
									;else a space
	move.w	#$19,(printy).l
	movea.l	#$23E1C,a1
	cmpi.w	#3,(setupfirstline).l
	beq.w	.0
	cmpi.w	#4,(OptPlayMode).l
	beq.w	.0
	movea.l	#$23E18,a1
.0	move.w	#2,(printx).l
	jsr	(print).l
	movea.l	#$23E1C,a1
	move.w	#$F,(printy).l
	tst.w	(setupfirstline).l
	beq.w	.1
	movea.l	#$23E14,a1
.1	move.w	#2,(printx).l
	jmp	(print).l
; Data that follows PrintScrollMarks (strings, small tables)
PrintScrollMarksData	dc.w	$0004,$7B00,$0004,$7D00,$0004,$2000
PrintOptTeamName						;Print team name d3 of option d7 (TeamList city; the full name of the
									;two New York teams, $D / $E).
									;PrintOptionValue
	move.w	(printx).l,-(sp)
	movea.l	#$23EA0,a1
	jsr	(print).l
	move.w	(sp)+,(printx).l
	movea.l	#OptPlayMode,a1
	move.w	(a1,d7.w),d3
	movea.l	#TeamList,a1
	asl.w	#2,d3
	movea.l	(a1,d3.w),a1
	lsr.w	#2,d3
	adda.w	$4(a1),a1
	cmpi.w	#$E,d3		;NYR?
	bne.w	.0
	movea.l	#$23E8E,a1		;full name
	bra.w	.1		;print
.0	cmpi.w	#$D,d3		;NYI?
	bne.w	.1
	movea.l	#$23E7A,a1		;full name
.1	jmp	(print).l
; Data that follows PrintOptTeamName (strings, small tables)
PrintOptTeamNameData	dc.b	$00,$14,'New York Islan'
	dc.b	'ders',$00,$12,'New York R'
	dc.b	'angers',$00,$16,'        '
	dc.b	'            ',$00,$16,'N/'
	dc.b	'A               '
	dc.w	$2020
OptionValueOffsets					;Offsets of each option's value Strings. Team 1 / 2 are not read
									;(PrintOptTeamName); User Records uses the On / Off list
; Data of OptionValueOffsets (2 rows): table or constants used by it.
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
PrintOptionNames						;Print the option names from OptionNames at x 3, 2 rows apart from row $F
									;- setupfirstline * 2, rows $F-$19 only.
									;from
									;GameSetUp and FixModeOptions
	movem.l	d0-d1,-(sp)
	bset	#3,(sflags6).l		;print all
	movea.l	#$242B4,a1
	move.w	#$F,d0
	move.w	(setupfirstline).l,d1
	add.w	d1,d1		;2 rows a line
	sub.w	d1,d0
	move.w	d0,(printy).l
.loop	cmpi.w	#$F,(printy).l		;above the menu?
	bge.w	.0
	adda.w	(a1),a1
	bra.w	.1
.0	cmpi.w	#$19,(printy).l		;past row $19?
	bgt.w	.done
	move.w	#3,(printx).l
	move.w	#0,(printa).l
	move.w	#0,(printm).l
	jsr	(printsmall).l
.1	addi.w	#$2,(printy).l		;2 rows on
	bra.w	.loop
.done	bclr	#3,(sflags6).l		;normal
	movem.l	(sp)+,d0-d1
	rts
; Data that follows PrintOptionNames (strings, small tables)
PrintOptionNamesData	dc.b	$00,$10,'Play Mode    ',$00
	dc.b	$00,$10,'Players      ',$00
	dc.b	$00,$10,'Team 1       ',$00
	dc.b	$00,$10,'Team 2       ',$00
	dc.b	$00,$10,'Per. Length  ',$00
	dc.b	$00,$10,'Goalies      ',$00
	dc.b	$00,$10,'User Records ',$00
	dc.b	$00,$10,'Penalties    ',$00
	dc.b	$00,$10,'Line Changes ',$00
	dc.w	$0004,$0000

; Installs the options-screen vblank handler and display flags.
OptionsScreenSetup
	move.l	#MenuVBlankHandler,(VBint).l
	bset	#$5,$FF800F.l
	bclr	#$0,(disflags).l
	bset	#$2,(disflags).l
	bclr	#$1,(disflags).l
	move.w	#$0,(VSCRLPM).l
	move.w	#$B400,(VSPRITES).l
	move.w	#$B800,(VmMAP3).l
	move.w	#$5,(Map3col).l
	move.w	#$C000,(VmMAP2).l
	move.w	#$6,(Map2col).l
	move.w	#$E000,(VmMAP1).l
	move.w	#$6,(Map1col).l
	move.l	#$0,d0
	jsr	(setVram).l
	jsr	(orjoy).l
	jsr	(LoadTeamGraphicsPair).l
	move.w	d4,(framercset).l
	movea.l	$47D78.l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
; Inline data read by DecompressGraphicsWithRemap from the return address (1 row).
	dc.l	$03567564,$89ABCDEF
	move.w	d4,(smallfontchars).l
	movea.l	$47D3C.l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
; Inline data read by $38946 from the return address (1 row).
	dc.b	$0F,$C0,$45,$67,$89,$AB,$CD,$EF	; ..Eg....
	move.w	d4,(setupfontchars).l
	movea.l	$47D70.l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
; Inline data read by $38946 from the return address (1 row).
	dc.b	$01,$23,$45,$67,$89,$AB,$CD,$EF	; .#Eg....
	jsr	(printz).l
; Inline data read by $38F6E from the return address (1 row).
	dc.b	$00,$06,$FF,$00,$00,$00	; ......
	moveq	#$28,d0
	moveq	#$1C,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	jsr	(printz).l
; Inline data read by $38F6E from the return address (1 row).
	dc.b	$00,$06,$FE,$00,$00,$00	; ......
	movea.l	$47D00.l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$28,d2
	moveq	#$1C,d3
	moveq	#$D,d5
	jsr	(dobitmap).l
	move.w	d4,(vispicchars).l
	addi.w	#$24,d4
	jsr	(printz).l
; Inline data read by $38F6E from the return address (1 row).
	dc.b	$00,$06,$FF,$00,$00,$00	; ......
	movea.l	$47D04.l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$28,d2
	moveq	#$4,d3
	moveq	#$0,d5
	jsr	(dobitmap).l
	jsr	(printz).l
; Inline data read by $38F6E from the return address (1 row).
	dc.b	$00,$06,$FF,$01,$0E,$00	; ......
	move.w	d4,(setupmenuchars).l
	movea.l	$47D74.l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$26,d2
	moveq	#$D,d3
	moveq	#$0,d5
	jsr	(dobitmap).l
	move.w	d4,(homepicchars).l
	addi.w	#$24,d4
	move.w	d4,(logobox1chars).l
	movea.l	$47D7C.l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,(logobox2chars).l
	movea.l	$47D7C.l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
; Inline data read by $38946 from the return address (1 row).
	dc.b	$03,$41,$45,$67,$89,$AB,$CD,$EF	; .AEg....
	jsr	(SortObjectsInit).l
	move.w	#$28,$1749C.l
	move.w	#$28,$1779C.l
	st.b	(tmstruct).l
	st.b	(awtmstruct).l
	rts
ReadSetupPads						;wait up to $5460 frames (6 minutes) for a press on any pad (4 with
	
	
	
	
	
	
	move.l	#$5460,d6
.loop	move.w	(ScoutSubStatus).l,d1
	sub.w	(OldVcount).l,d1
	beq.w	.loop
	move.w	(ScoutSubStatus).l,(OldVcount).l
	bclr	#5,(setupcardflags).l
	jsr	(CheckNOPUnusedReturn).l
	jsr	(ReadJoy1).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.1
	btst	#cbut,d1
	beq.w	.x
	btst	#5,d2
	beq.w	.0
	move.w	#$53,(cardtimer).l
.0	bset	#5,(setupcardflags).l
.1	jsr	(ReadJoy2).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.2
	btst	#5,d1
	beq.w	.x
	bset	#5,(setupcardflags).l
.2	tst.w	(FourWayPlay).l
	beq.w	.4
	jsr	(ReadJoy3).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.3
	btst	#5,d1
	beq.w	.x
	bset	#5,(setupcardflags).l
.3	jsr	(ReadJoy4).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.4
	btst	#5,d1
	beq.w	.x
	bset	#5,(setupcardflags).l
.4	btst	#6,(setupcardflags).l
	beq.w	.5
	btst	#7,(setupcardflags).l
	bne.w	.6
	move.w	(setupvis).l,(logoteam).l
	bsr.w	DrawVisBlock
.5	btst	#7,(setupcardflags).l
	beq.w	.6
	move.w	(setuphome).l,(logoteam).l
	bsr.w	DrawHomeBlock
.6	cmpi.l	#$4650,d6
	bgt.w	.timer
	btst	#0,(setupcardflags).l
	bne.w	.timer
	jsr	(ResetCardTimer).l
	bra.w	.next3
.timer	jsr	(PlayerCardTimer).l
.next3	dbra	d6,.loop
.x	rts
; Sub CPU handshake that reads the pads for the setup screen
SetupPadsSyncRead
	clr.w	(demoflag).l
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	move.w	$FF8010.l,(seed).l
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
.loop4	btst	#$7,$FF800E.l
	bne.b	.loop4
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.loop5	btst	#$6,$FF800E.l
	beq.b	.loop5
	move.w	$FF8010.l,$18C1A.l
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop6	btst	#$6,$FF800E.l
	bne.b	.loop6
	bclr	#$7,$FF800F.l
	clr.w	(OptPlayMode).l
	clr.w	(OptNOP).l
	clr.w	(OptLine).l
	move.w	#$1,(OptPen).l
; Saves the playoff level, updates it and reads the pads through the sub CPU
SetupPadsPlayoffLevelRead
	move.w	(OptGoalie).l,-(sp)
	move.w	(sp),(goaliemode1).l
	move.w	(sp)+,(goaliemode2).l
	jsr	(UpdatePlayoffLevel).l
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	move.w	$FF8010.l,(seed).l
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
.loop4	btst	#$7,$FF800E.l
	bne.b	.loop4
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.loop5	btst	#$6,$FF800E.l
	beq.b	.loop5
	move.w	$FF8010.l,$18C1A.l
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop6	btst	#$6,$FF800E.l
	bne.b	.loop6
	bclr	#$7,$FF800F.l
	move.w	(OptLine).l,(TmpOptLine2).l
	cmpi.w	#$2,(OptLine).l
	bne.w	.next
	clr.w	(OptLine).l
	bset	#$4,(sflags7).l
.next	move.w	(OptPlayMode).l,(TempOptPlayMode).l
	cmpi.w	#$4,(OptPlayMode).l
	bne.w	.next2
	move.w	#$0,(OptPlayMode).l
	bset	#$0,(gmode2).l
	jsr	(ClearShootout).l
.next2	jmp	(MakeTree).l
CheckNOPUnused						;unreferenced. Tests OptNOP for 0, 5, 6, 9 and $A and returns: no effect
	tst.w	(OptNOP).l
	beq.w	.x
	cmpi.w	#5,(OptNOP).l
	beq.w	.x
	cmpi.w	#6,(OptNOP).l
	beq.w	.x
	cmpi.w	#9,(OptNOP).l
	beq.w	.x
	cmpi.w	#$A,(OptNOP).l
.x	rts
; Decompresses the plain and the remapped team graphics pair.
LoadTeamGraphicsPair
	moveq	#$2,d4
	movea.l	$47D48.l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,(teambitmapchars).l
	movea.l	$47D48.l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
; Inline data read by DecompressGraphicsWithRemap from the return address (1 row).
	dc.l	$03412567,$89ABCDEF
	rts
; Return point of CheckNOPUnused.
CheckNOPUnusedReturn
	rts
	rts
; Prints the message selected by the flag bits at $19390.
PrintFlaggedMessage	movem.l	d0-d7,-(sp)
	bclr	#$0,(setupcardflags).l
	beq.w	.next2
	bclr	#$6,(setupcardflags).l
	bclr	#$7,(setupcardflags).l
	jsr	(printz).l
	String	CC_Font1Pal1,$0,$0
	move.w	#$5,(printy).l
	moveq	#$8,d0
	moveq	#$8,d1
	move.w	#$7FF,d2
	btst	#$1,(setupcardflags).l
	beq.w	.next
	move.w	#$3,(printx).l
	jsr	(eraser).l
	jsr	(printz).l
	String	CC_Font1,$0,$0
	move.w	#$B,(printx).l
	move.w	#$5,(printy).l
	move.w	#$19,d0
	move.w	#$8,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	bra.w	.next2
.next	move.w	#$1C,(printx).l
	jsr	(eraser).l
	jsr	(printz).l
	String	CC_Font1,$0,$0
	move.w	#$3,(printx).l
	move.w	#$5,(printy).l
	move.w	#$19,d0
	move.w	#$8,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
.next2	movem.l	(sp)+,d0-d7
	rts
DrawHomeBlock						;Draw the home team block: the logo box and the HomeTeam logo (logoteam)
	
	
	
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	PrintFlaggedMessage
	bset	#2,(setupcardflags).l
	bset	#6,(setupcardflags).l
	bsr.w	DrawLogoBoxVisitor
	bclr	#3,(setupcardflags).l
	beq.w	.0
	jsr	(printz).l
	String	CC_Font1Pal1,$0,$0
	move.w	#8,(printx).l
	move.w	#5,(printy).l
	moveq	#8,d0
	moveq	#8,d1
	move.w	#$7FF,d2
.0	jsr	(printz).l
	String	CC_Font1,$0,$0		;x3
	move.w	#$19,(printx).l
	bra.w	DrawTeamLogo
DrawVisBlock						;The same for the visitors: logo box, logo at x 9. setupcardflags bit 3,
	
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	PrintFlaggedMessage
	bset	#3,(setupcardflags).l
	bset	#7,(setupcardflags).l
	bsr.w	DrawLogoBoxHomeRight
	bclr	#2,(setupcardflags).l
	beq.w	.0
	jsr	(printz).l
	String	CC_Font1Pal1,$0,$0
	move.w	#$18,(printx).l
	move.w	#5,(printy).l
	moveq	#8,d0
	moveq	#8,d1
	move.w	#$7FF,d2
.0	jsr	(printz).l
	String	CC_Font1Pal3,$0,$0
	move.w	#9,(printx).l
DrawTeamLogo						;Draw the logo of team logoteam at printx, y 6, 6 x 6, palette
	
	
	
	
	move.w	#$B4,(carddelay).l
	move.w	#6,(printy).l
	move.w	(homepicchars).l,d4
	btst	#2,(setupcardflags).l
	bne.w	.0
	move.w	(vispicchars).l,d4
.0	move.w	(logoteam).l,d3
	asl.w	#2,d3
	movea.l	(TeamLogoBitmaps).l,a0
	movea.l	(a0,d3.w),a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	asl.w	#3,d3
	movea.l	#TeamLogoPalettes,a0
	btst	#2,(setupcardflags).l
	beq.w	.1
	subi.w	#$20,d3
	bra.w	.2
.1	subi.w	#$40,d3
.2	adda.w	d3,a0
	adda.l	(a2)+,a1
	move.w	#6,d3
	move.w	#6,d2
	clr.w	d0
	clr.w	d1
	move.l	$BBCD2.l,-(sp)
	move.l	$BBCD6.l,-(sp)
	move.w	#4,d5
	btst	#2,(setupcardflags).l
	beq.w	.draw
	move.w	#2,d5
.draw	jsr	(dobitmap).l
	move.l	(sp)+,$BBCD6.l
	move.l	(sp)+,$BBCD2.l
	move.w	#$64,(palcount).l		;fade in
	movem.l	(sp)+,d0-d7/a0-a6
	rts
TeamLogoBitmapsEnd						;end of TeamLogoBitmaps (size check below)
	move.w	(logobox1chars).l,d4
	move.w	#$1C,(printx).l
	bra.w	DrawLogoBox
; Draws the visitor logo box at x=$18.
DrawLogoBoxVisitor	move.w	(logobox1chars).l,d4
	move.w	#$18,(printx).l
	bra.w	DrawLogoBox
; Draws a logo box at x=3 from the value at $1939A.
DrawLogoBoxHomeLeft
	move.w	(logobox2chars).l,d4
	move.w	#$3,(printx).l
	bra.w	DrawLogoBox
; Draws a logo box at x=8 from the value at $1939A.
DrawLogoBoxHomeRight	move.w	(logobox2chars).l,d4
	move.w	#$8,(printx).l
DrawLogoBox						;Draw the LogoBoxMap box at printx, y 5 (sflags6 bit 0 set). Branched to
	
	clr.w	(printa).l
	move.w	#5,(printy).l
	movea.l	$47D7C.l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	move.w	#8,d3
	move.w	#8,d2
	clr.w	d0
	clr.w	d1
	move.w	#0,d5
	bset	#0,(sflags6).l
	jsr	(dobitmap).l
	bclr	#0,(sflags6).l
	rts