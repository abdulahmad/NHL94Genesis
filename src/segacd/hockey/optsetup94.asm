GameSetUp						;Game setup screen, called from PeriodOver. Builds the screen
									;(setoptions), then runs the menu: up / down move the frame, left / right
									;change the option (ChangeOption) and redraw (FixModeOptions), start
									;begins the game (SetupStart), and $5460 frames without a press start a
									;demo (SetupDemo).
	jsr	$2A58C.l
	movea.l	#$18C38,a3
	jsr	(InitPlayerSlots).l
	move.w	$18C22.l,$18C0A.l
	move.w	$18C24.l,$18BFA.l
	bclr	#$1,$17F7A.l		;no overtime
	jsr	$29302.l
	jsr	(ReadNameLog).l		;read the SRAM name list
	bsr.w	OptionsScreenSetup		;build the screen
	clr.w	$19384.l
	clr.w	$19386.l
	bsr.w	PrintOptionNames
	tst.w	$18C16.l
	bne.w	.next
	moveq	#$1C,d0
	jsr	(randomd0).l
	move.w	d0,$18BFE.l
	moveq	#$1C,d0
	jsr	(randomd0).l
	move.w	d0,$18C00.l
.next	st.b	$18C16.l
	cmpi.w	#$4,$18BFA.l
	bne.w	.next2
	bra.w	.reggame
.next2	cmpi.w	#$2,$18BFA.l
	blt.w	.next3
	bsr.w	GameSetUpJumpA
.next3	cmpi.w	#$1,$18BFA.l
	bne.w	.reggame		;not continue playoffs
	bsr.w	GameSetUpJumpB
.reggame	clr.w	d7		;menu line 0 (d7 = line * 2 = offset in OptPlayMode ... OptLine)
	clr.w	d0
	bsr.w	MoveMenuFrame		;frame the line
	bsr.w	FixModeOptions		;print the options
	move.w	(HomeTeam).l,$1938C.l
	move.w	(HomeTeam).l,$1938A.l
	bsr.w	DrawHomeBlock
	move.w	(VisTeam).l,$1938E.l
	move.w	(VisTeam).l,$1938A.l
	bsr.w	DrawVisBlock
	move.w	#$18,(palcount).l
	bclr	#$2,(disflags).l		;dfng: fade in graphics now
.loop
	cmpi.w	#$4,$18BFA.l
	bne.w	.next4
	move.w	#$1,$18C0A.l
	move.w	#$0,$18C08.l
	move.w	#$1,$18C06.l
.next4	bsr.w	ReadSetupPads
	tst.w	d1
	bne.w	.next5
	bra.w	SetupPadsSyncRead
.next5	btst	#$7,d1
	bne.w	SetupPadsPlayoffLevelRead
	btst	#$1,d1
	beq.w	.next13
	tst.w	(OptNOP).l
	bne.w	.next6
	cmpi.w	#$8,d7
	bne.w	.next6
	move.w	#$4,d0
	bra.w	.next7
.next6	move.w	#$2,d0
.next7	cmpi.w	#$4,$18BFA.l
	beq.w	.next8
	tst.w	(OptNOP).l
	bne.w	.next8
	cmpi.w	#$8,d7
	bne.w	.next8
	move.w	#$6,d0
	bra.w	.next12
.next8	cmpi.w	#$6,d7
	bne.w	.next9
	cmpi.w	#$4,$18BFA.l
	bne.w	.next9
	tst.w	(OptNOP).l
	bne.w	.next11
	clr.w	d0
	bra.w	.next12
.next9	cmpi.w	#$A,d7
	bne.w	.next12
	cmpi.w	#$4,$18BFA.l
	bne.w	.next10
	clr.w	d0
	bra.w	.next12
.next10	tst.w	$193BA.l
	bpl.w	.next12
.next11	move.w	#$4,d0
.next12	bsr.w	MoveMenuFrame
	bsr.w	FixModeOptions
	bra.w	.loop
.next13	btst	#$0,d1
	beq.w	.next19
	tst.w	(OptNOP).l
	bne.w	.next14
	cmpi.w	#$C,d7
	bne.w	.next14
	move.w	#$FFFC,d0
	bra.w	.next15
.next14	move.w	#$FFFE,d0
	cmpi.w	#$4,$18BFA.l
	beq.w	.next15
	tst.w	(OptNOP).l
	bne.w	.next15
	cmpi.w	#$E,d7
	bne.w	.next15
	move.w	#$FFFA,d0
	bra.w	.next18
.next15	cmpi.w	#$A,d7
	bne.w	.next16
	cmpi.w	#$4,$18BFA.l
	beq.w	.next17
.next16	cmpi.w	#$E,d7
	bne.w	.next18
	cmpi.w	#$4,$18BFA.l
	beq.w	.next17
	tst.w	$193BA.l
	bpl.w	.next18
.next17	move.w	#$FFFC,d0
.next18	bsr.w	MoveMenuFrame
	bsr.w	FixModeOptions
	bra.w	.loop
.next19	moveq	#$1,d2
	btst	#$3,d1
	bne.w	.next20
	btst	#$2,d1
	beq.w	.loop
	moveq	#-1,d2
.next20	cmpi.w	#$4,$18BFA.l
	beq.w	.next21
	jsr	(FigureJoy).l
.next21	move.w	$18C00.l,-(sp)
	move.w	$18BFE.l,-(sp)
	bsr.w	ChangeOption
	move.w	(sp)+,d0
	cmpi.w	#$4,$18BFA.l
	beq.w	.next22
	tst.w	$18BFA.l
	bne.w	.next23
.next22	move.w	$18BFE.l,(HomeTeam).l
	move.w	$18C00.l,(VisTeam).l
.next23	move.w	(HomeTeam).l,$1938A.l
	btst	#$6,$19390.l
	beq.w	.next24
	movem.w	d0,-(sp)
	move.w	$1938C.l,d0
	cmp.w	(HomeTeam).l,d0
	movem.w	(sp)+,d0
	beq.w	.next25
.next24	move.w	(HomeTeam).l,$1938C.l
	bsr.w	DrawHomeBlock
.next25	btst	#$7,$19390.l
	beq.w	.next26
	movem.w	d0,-(sp)
	move.w	$1938E.l,d0
	cmp.w	(VisTeam).l,d0
	movem.w	(sp)+,d0
	beq.w	.next27
.next26	move.w	(VisTeam).l,$1938E.l
	move.w	(VisTeam).l,$1938A.l
	bsr.w	DrawVisBlock
	move.w	(HomeTeam).l,$1938A.l
.next27	tst.w	(sp)+
	bra.w	.next28
; Data of GameSetUp (8 rows): table or constants used by it.
	dc.w	$301F,$B079,$0001,$7FB0,$6700,$006C,$33F9,$0001
	dc.w	$7FB0,$0001,$938A,$48A7,$8000,$3039,$0001,$7FB0
	dc.w	$B079,$0001,$7FB0,$4C9F,$0001,$6700,$0010,$33F9
	dc.w	$0001,$7FB0,$0001,$938E,$6100,$1274,$48A7,$8000
	dc.w	$3039,$0001,$938C,$B079,$0001,$7FAE,$4C9F,$0001
	dc.w	$6700,$0024,$33F9,$0001,$7FAE,$0001,$938C,$33F9
	dc.w	$0001,$7FAE,$0001,$938A,$6100,$11E0,$33F9,$0001
	dc.w	$7FB0,$0001,$938A
.next28
	bsr.w	FixModeOptions
	bra.w	.loop
	rts
; Jumps to the disc routine at $401C4.
GameSetUpJumpA
	jmp	$401C4.l
; Jumps to the disc routine at $40132.
GameSetUpJumpB
	jmp	$40132.l
MoveMenuFrame						;Move the menu frame by d0 (+2 / -2 lines). Shows 6 of the 9 lines and
									;scrolls: setupfirstline = first line shown
									;(0-3), setupprevline = the one before (sflags5 bit 2 set on a scroll;
									;FixModeOptions reprints the names when they differ). Continue playoffs
									;skips lines 1-3, new playoffs line 3 (Team 2). The old frame is erased by
									;redrawing the SetupMenuMap background under it. Called from GameSetUp
	move.w	d7,d3
.optionup	bclr	#$2,$17F74.l		;not scrolled yet
	tst.w	d0		;direction?
	bpl.w	.next2
	move.w	d0,-(sp)
	move.w	d7,d0
	asr.w	#$1,d0		;lines
	cmp.w	$19384.l,d0
	bne.w	.next
	move.w	$19384.l,$19386.l
	bset	#$2,$17F74.l
	subi.w	#$1,$19384.l
	bpl.w	.next
	clr.w	$19384.l
.next	move.w	(sp)+,d0
.next2	move.w	d7,$17E62.l
	add.w	d0,d7
	bpl.w	.0		;not above line 0
	clr.w	d7		;clamp to line 0
.0	tst.w	d0		;moving?
	bmi.w	.3
	move.w	d0,-(sp)
	move.w	d7,d0
	asr.w	#$1,d0		;lines
	sub.w	$19384.l,d0
	cmpi.w	#$5,d0		;past row 5?
	bgt.w	.next3		;below the frame: scroll
	bra.w	.2
.next3	move.w	$19384.l,$19386.l
	bset	#$2,$17F74.l
	addi.w	#$1,$19384.l
	move.w	d7,d0
	asr.w	#$1,d0
	sub.w	$19384.l,d0
	cmpi.w	#$5,d0
	ble.w	.next4
	addi.w	#$1,$19384.l
.next4	cmpi.w	#$3,$19384.l
	ble.w	.2
	move.w	#$3,$19384.l
.2	move.w	(sp)+,d0
.3	btst	#$2,$17F74.l		;scrolled?
	bne.w	.4
	move.w	$19384.l,$19386.l
.4	cmpi.w	#$12,d7		;past the last line (Line Changes)
	blt.w	.next5
	sub.w	d0,d7
.next5	cmpi.w	#$1,$18BFA.l
	bne.w	.next6
	tst.w	d7		;top line?
	beq.w	.next6
	cmpi.w	#$6,d7		;line 6 or above?
	bls.w	.optionup
.next6	cmpi.w	#$2,$18BFA.l
	blt.w	.5
	cmpi.w	#$4,$18BFA.l
	beq.w	.5
	cmpi.w	#$6,d7		;line 6?
	beq.w	.optionup
.5	bsr.w	.next7		;printx $10, printy $E, 23 x 13
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	$19388.l,d4
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
	moveq	#$0,d5		;no palette lines
	bset	#$0,(sflags6).l
	jsr	(dobitmap).l
	bclr	#$0,(sflags6).l		;normal maps
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
	move.w	$19386.l,d0
	add.w	d0,d0		;2 rows a line
	sub.w	d0,(printy).l
	cmpi.w	#$18,(printy).l		;below row $18?
	ble.w	.0
	move.w	#$18,(printy).l
.0	moveq	#$17,d0
	moveq	#$3,d1
	cmpi.w	#$2,$18BFA.l
	blt.w	SetFrameRectUnusedExit
	cmpi.w	#$4,$18BFA.l
	beq.w	SetFrameRectUnusedExit
	cmpi.w	#$4,d3		;line 4?
	bne.w	SetFrameRectUnusedExit
	moveq	#$5,d1
	rts
; Prints a title in font 1 and adjusts printy.
PrintFont1Title	jsr	(printz).l
	String	CC_Font1,$10,$E
	add.w	d3,(printy).l
	move.w	$19384.l,d0
	add.w	d0,d0
	sub.w	d0,(printy).l
	moveq	#$17,d0
	moveq	#$3,d1
	cmpi.w	#$2,$18BFA.l
	blt.w	SetFrameRectUnusedExit
	cmpi.w	#$4,$18BFA.l
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
	cmpi.w	#$4,$18BFA.l
	bne.w	.next
	move.w	#$1,$18C06.l
.next	tst.w	(OptNOP).l
	bne.w	.0
	move.w	#$1,$18C06.l
.0	tst.w	(OptNOP).l		;one player?
	bne.w	.next2
	move.w	#$0,$18C04.l		;Off
	move.w	#$0,$18C0C.l
	move.w	#$0,$18C0E.l
	tst.w	(OptNOP).l		;one player?
	bne.w	.next2
	move.w	#$1,$18C04.l		;goalie on auto
	move.w	#$1,$18C0C.l
	move.w	#$1,$18C0E.l
.next2	move.w	$19384.l,d0
	cmp.w	$19386.l,d0
	beq.w	.3
	bsr.w	PrintOptionNames
.3	bset	#$3,(sflags6).l		;print all
	bsr.w	PrintOptions		;print the options
	bclr	#$3,(sflags6).l		;normal
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
	beq.w	.next2
	move.w	$18BFA.l,d0
	add.w	d2,d0
	bpl.w	.next
	move.w	#$4,d0
.next	cmpi.w	#$4,d0
	bne.w	.next2
	move.w	$18C06.l,$18C10.l
	move.w	$18C08.l,$18C12.l
	move.w	$18C0A.l,$18C14.l
.next2	movem.w	(sp)+,d0/d2
	tst.w	d7
	bne.w	.next3
	tst.w	d2
	beq.w	.next3
	cmpi.w	#$4,$18BFA.l
	bne.w	.next3
	move.w	$18C10.l,$18C06.l
	move.w	$18C12.l,$18C08.l
	move.w	$18C14.l,$18C0A.l
.next3	movea.l	#$18BFA,a2
	movea.l	#$23A68,a3
	tst.w	$18BF8.l
	beq.w	.next4
	movea.l	#$23A7A,a3
.next4	clr.w	d5
	move.w	(a3,d7.w),d4
	move.w	(a2,d7.w),d3
	cmpi.w	#$2,$18BFA.l
	blt.w	.next5
	cmpi.w	#$4,$18BFA.l
	beq.w	.next5
	cmpi.w	#$4,d7
	bne.w	.next5
	moveq	#$1A,d4
.next5	cmpi.w	#$2,d7
	bne.w	.next13
	cmpi.w	#$4,$18BFA.l
	bne.w	.next10
	movem.w	d2,-(sp)
	add.w	(OptNOP).l,d2
	bpl.w	.next6
	addi.w	#$7,d2
.next6	cmpi.w	#$4,d2
	movem.w	(sp)+,d2
	ble.w	.next8
	tst.w	d2
	bpl.w	.next7
	move.w	#$4,d2
	bra.w	.next10
.next7	addi.w	#$2,d2
	bra.w	.next10
.next8	movem.w	d2,-(sp)
	add.w	(OptNOP).l,d2
	cmpi.w	#$3,d2
	movem.w	(sp)+,d2
	bne.w	.next10
	tst.w	d2
	bpl.w	.next9
	subi.w	#$1,d2
	bra.w	.next10
.next9	addi.w	#$1,d2
.next10	moveq	#$5,d5
	tst.w	$18BF8.l
	beq.w	.next11
	move.w	#$A,d4
	addi.w	#$2,d5
.next11	cmpi.w	#$4,$18BFA.l
	beq.w	.next12
	tst.w	$18BFA.l
	bne.w	.loop
.next12	clr.w	d5
	moveq	#$5,d4
.loop	tst.w	$18BF8.l
	beq.w	.next13
	addi.w	#$2,d4
.next13	bsr.w	WrapOption
	tst.w	$18BF8.l
	beq.w	.next16
	cmpi.w	#$2,d7
	bne.w	.next16
	tst.w	d2
	bmi.w	.next14
	cmpi.w	#$9,d3
	beq.w	.next15
	cmpi.w	#$A,d3
	beq.w	.next15
	bra.w	.next16
.next14	cmpi.w	#$A,d3
	bne.w	.next16
	move.w	#$8,d3
	bra.w	.next16
.next15	move.w	#$B,d3
.next16	move.w	d3,(a2,d7.w)
	tst.w	d2
	beq.w	SetFrameRectUnusedExit
	cmpi.w	#$1,$18BFA.l
	bne.w	.next17
	tst.w	d7
	bne.w	.next17
	jsr	$40132.l
	move.w	$18A9E.l,d0
	or.w	$18A9C.l,d0
	beq.w	.loop
	rts
.next17	cmpi.w	#$2,$18BFA.l
	blt.w	SetFrameRectUnusedExit
	cmpi.w	#$4,$18BFA.l
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
	subq.w	#$1,d3
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
	asr.w	#$1,d7
	cmp.w	$19384.l,d7
	movem.l	(sp)+,d7
	blt.w	.next
	bsr.w	PrintOptionValue
.next	cmpi.w	#$10,d7
	bne.w	.loop
	bsr.w	PrintScrollMarks
	move.w	d6,d7
	jsr	(TeamIcons).l
	btst	#$0,$19390.l
	bne.w	.ex
	jsr	(ResetCardTimer).l
.ex	rts
PrintOptionValue						;print the value of option d7 at x $11 on its line (past row $1B:
									;nothing). Team 1 / 2 go to PrintOptTeamName Per. Length in
									;Shootout prints 'N/A'; Players with FourWayPlay uses the second list
									;(+$B0). Called from PrintOptions
	jsr	(printz).l
	String	CC_Font1Pri,$11,$10
	move.w	$19384.l,d0
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
	movea.l	#$18BFA,a0
	move.w	(a0,d7.w),d3
	movea.l	#OptionValueOffsets,a0
	adda.w	(a0,d7.w),a0		;its value Strings
	cmpa.l	#PerLengthValues,a0		;period length?
	bne.w	.next
	cmpi.w	#$4,$18BFA.l
	bne.w	.next
	movea.l	#$23EB6,a1
	jmp	(print).l
.next	tst.w	$18BF8.l
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
	cmpi.w	#$3,$19384.l
	beq.w	.0
	cmpi.w	#$4,$18BFA.l
	beq.w	.0
	movea.l	#$23E18,a1
.0	move.w	#$2,(printx).l
	jsr	(print).l
	movea.l	#$23E1C,a1
	move.w	#$F,(printy).l
	tst.w	$19384.l
	beq.w	.1
	movea.l	#$23E14,a1
.1	move.w	#$2,(printx).l
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
	movea.l	#$18BFA,a1
	move.w	(a1,d7.w),d3
	movea.l	#TeamList,a1
	asl.w	#$2,d3
	movea.l	(a1,d3.w),a1
	lsr.w	#$2,d3
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
	bset	#$3,(sflags6).l		;print all
	movea.l	#$242B4,a1
	move.w	#$F,d0
	move.w	$19384.l,d1
	add.w	d1,d1		;2 rows a line
	sub.w	d1,d0
	move.w	d0,(printy).l
.loop	cmpi.w	#$F,(printy).l		;above the menu?
	bge.w	.0
	adda.w	(a1),a1
	bra.w	.1
.0	cmpi.w	#$19,(printy).l		;past row $19?
	bgt.w	.done
	move.w	#$3,(printx).l
	move.w	#$0,(printa).l
	move.w	#$0,$18D5E.l
	jsr	(printsmall).l
.1	addi.w	#$2,(printy).l		;2 rows on
	bra.w	.loop
.done	bclr	#$3,(sflags6).l		;normal
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
	move.w	#$0,$18D30.l
	move.w	#$B400,$18D32.l
	move.w	#$B800,$18D3C.l
	move.w	#$5,$18D3E.l
	move.w	#$C000,$18D38.l
	move.w	#$6,(Map2col).l
	move.w	#$E000,(VmMAP1).l
	move.w	#$6,(Map1col).l
	move.l	#$0,d0
	jsr	(setVram).l
	jsr	(orjoy).l
	jsr	$24866.l
	move.w	d4,(framercset).l
	movea.l	$47D78.l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
; Inline data read by DecompressGraphicsWithRemap from the return address (1 row).
	dc.l	$03567564,$89ABCDEF
	move.w	d4,$18D42.l
	movea.l	$47D3C.l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
; Inline data read by $38946 from the return address (1 row).
	dc.b	$0F,$C0,$45,$67,$89,$AB,$CD,$EF	; ..Eg....
	move.w	d4,$17EA2.l
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
	move.w	d4,$19394.l
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
	move.w	d4,$19388.l
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
	move.w	d4,$19392.l
	addi.w	#$24,d4
	move.w	d4,$19398.l
	movea.l	$47D7C.l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,$1939A.l
	movea.l	$47D7C.l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
; Inline data read by $38946 from the return address (1 row).
	dc.b	$03,$41,$45,$67,$89,$AB,$CD,$EF	; .AEg....
	jsr	(SortObjectsInit).l
	move.w	#$28,$1749C.l
	move.w	#$28,$1779C.l
	st.b	$1834C.l
	st.b	$186B2.l
	rts
ReadSetupPads						;wait up to $5460 frames (6 minutes) for a press on any pad (4 with
	
	
	
	
	
	
	move.l	#$5460,d6
.loop	move.w	(ScoutSubStatus).l,d1
	sub.w	$17476.l,d1
	beq.w	.loop
	move.w	(ScoutSubStatus).l,$17476.l
	bclr	#$5,$19390.l
	jsr	$24894.l
	jsr	(ReadJoy1).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.1
	btst	#$5,d1
	beq.w	.ex
	btst	#$5,d2
	beq.w	.0
	move.w	#$53,$1939E.l
.0	bset	#$5,$19390.l
.1	jsr	(ReadJoy2).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.next
	btst	#$5,d1
	beq.w	.ex
	bset	#$5,$19390.l
.next	tst.w	$18BF8.l
	beq.w	.4
	jsr	(ReadJoy3).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.3
	btst	#$5,d1
	beq.w	.ex
	bset	#$5,$19390.l
.3	jsr	(ReadJoy4).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.4
	btst	#$5,d1
	beq.w	.ex
	bset	#$5,$19390.l
.4	btst	#$6,$19390.l
	beq.w	.5
	btst	#$7,$19390.l
	bne.w	.6
	move.w	$1938E.l,$1938A.l
	bsr.w	DrawVisBlock
.5	btst	#$7,$19390.l
	beq.w	.6
	move.w	$1938C.l,$1938A.l
	bsr.w	DrawHomeBlock
.6	cmpi.l	#$4650,d6
	bgt.w	.next2
	btst	#$0,$19390.l
	bne.w	.next2
	jsr	(ResetCardTimer).l
	bra.w	.next3
.next2	jsr	(PlayerCardTimer).l
.next3	dbra	d6,.loop
.ex	rts
; Sub CPU handshake that reads the pads for the setup screen
SetupPadsSyncRead
	clr.w	$18C16.l
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	move.w	$FF8010.l,$18C18.l
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
	clr.w	$18BFA.l
	clr.w	(OptNOP).l
	clr.w	$18C0A.l
	move.w	#$1,$18C08.l
; Saves the playoff level, updates it and reads the pads through the sub CPU
SetupPadsPlayoffLevelRead
	move.w	$18C04.l,-(sp)
	move.w	(sp),$18C0C.l
	move.w	(sp)+,$18C0E.l
	jsr	(UpdatePlayoffLevel).l
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	move.w	$FF8010.l,$18C18.l
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
	move.w	$18C0A.l,$18C22.l
	cmpi.w	#$2,$18C0A.l
	bne.w	.next
	clr.w	$18C0A.l
	bset	#$4,$17F7A.l
.next	move.w	$18BFA.l,$18C24.l
	cmpi.w	#$4,$18BFA.l
	bne.w	.next2
	move.w	#$0,$18BFA.l
	bset	#$0,$17F78.l
	jsr	(ClearShootout).l
.next2	jmp	(MakeTree).l
CheckNOPUnused						;unreferenced. Tests OptNOP for 0, 5, 6, 9 and $A and returns: no effect
	tst.w	(OptNOP).l
	beq.w	.x
	cmpi.w	#$5,(OptNOP).l
	beq.w	.x
	cmpi.w	#$6,(OptNOP).l
	beq.w	.x
	cmpi.w	#$9,(OptNOP).l
	beq.w	.x
	cmpi.w	#$A,(OptNOP).l
.x	rts
	moveq	#$2,d4
	movea.l	$47D48.l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,$1939C.l
	movea.l	$47D48.l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
; Inline data read by DecompressGraphicsWithRemap from the return address (1 row).
	dc.l	$03412567,$89ABCDEF
	rts
	rts
	rts
; Prints the message selected by the flag bits at $19390.
PrintFlaggedMessage	movem.l	d0-d7,-(sp)
	bclr	#$0,$19390.l
	beq.w	.next2
	bclr	#$6,$19390.l
	bclr	#$7,$19390.l
	jsr	(printz).l
	String	CC_Font1Pal1,$0,$0
	move.w	#$5,(printy).l
	moveq	#$8,d0
	moveq	#$8,d1
	move.w	#$7FF,d2
	btst	#$1,$19390.l
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
	bset	#$2,$19390.l
	bset	#$6,$19390.l
	bsr.w	DrawLogoBoxVisitor
	bclr	#$3,$19390.l
	beq.w	.0
	jsr	(printz).l
	String	CC_Font1Pal1,$0,$0
	move.w	#$8,(printx).l
	move.w	#$5,(printy).l
	moveq	#$8,d0
	moveq	#$8,d1
	move.w	#$7FF,d2
.0	jsr	(printz).l
	String	CC_Font1,$0,$0		;x3
	move.w	#$19,(printx).l
	bra.w	DrawTeamLogo
DrawVisBlock						;The same for the visitors: logo box, logo at x 9. setupcardflags bit 3,
	
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	PrintFlaggedMessage
	bset	#$3,$19390.l
	bset	#$7,$19390.l
	bsr.w	DrawLogoBoxHomeRight
	bclr	#$2,$19390.l
	beq.w	.0
	jsr	(printz).l
	String	CC_Font1Pal1,$0,$0
	move.w	#$18,(printx).l
	move.w	#$5,(printy).l
	moveq	#$8,d0
	moveq	#$8,d1
	move.w	#$7FF,d2
.0	jsr	(printz).l
	String	CC_Font1Pal3,$0,$0
	move.w	#$9,(printx).l
DrawTeamLogo						;Draw the logo of team logoteam at printx, y 6, 6 x 6, palette
	
	
	
	
	move.w	#$B4,$193A2.l
	move.w	#$6,(printy).l
	move.w	(homepicchars).l,d4
	btst	#$2,$19390.l
	bne.w	.next
	move.w	(vispicchars).l,d4
.next	move.w	$1938A.l,d3
	asl.w	#$2,d3
	movea.l	(TeamLogoBitmaps).l,a0
	movea.l	(a0,d3.w),a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	asl.w	#$3,d3
	movea.l	#TeamLogoPalettes,a0
	btst	#$2,$19390.l
	beq.w	.1
	subi.w	#$20,d3
	bra.w	.2
.1	subi.w	#$40,d3
.2	adda.w	d3,a0
	adda.l	(a2)+,a1
	move.w	#$6,d3
	move.w	#$6,d2
	clr.w	d0
	clr.w	d1
	move.l	$BBCD2.l,-(sp)
	move.l	$BBCD6.l,-(sp)
	move.w	#$4,d5
	btst	#$2,$19390.l
	beq.w	.draw
	move.w	#$2,d5
.draw	jsr	(dobitmap).l
	move.l	(sp)+,$BBCD6.l
	move.l	(sp)+,$BBCD2.l
	move.w	#$64,(palcount).l		;fade in
	movem.l	(sp)+,d0-d7/a0-a6
	rts
TeamLogoBitmapsEnd						;end of TeamLogoBitmaps (size check below)
	move.w	$19398.l,d4
	move.w	#$1C,(printx).l
	bra.w	DrawLogoBox
; Draws the visitor logo box at x=$18.
DrawLogoBoxVisitor	move.w	$19398.l,d4
	move.w	#$18,(printx).l
	bra.w	DrawLogoBox
; Draws a logo box at x=3 from the value at $1939A.
DrawLogoBoxHomeLeft
	move.w	$1939A.l,d4
	move.w	#$3,(printx).l
	bra.w	DrawLogoBox
; Draws a logo box at x=8 from the value at $1939A.
DrawLogoBoxHomeRight	move.w	$1939A.l,d4
	move.w	#$8,(printx).l
DrawLogoBox						;Draw the LogoBoxMap box at printx, y 5 (sflags6 bit 0 set). Branched to
	
	clr.w	(printa).l
	move.w	#$5,(printy).l
	movea.l	$47D7C.l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	move.w	#$8,d3
	move.w	#$8,d2
	clr.w	d0
	clr.w	d1
	move.w	#$0,d5
	bset	#$0,(sflags6).l
	jsr	(dobitmap).l
	bclr	#$0,(sflags6).l
	rts