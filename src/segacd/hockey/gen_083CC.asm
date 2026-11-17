GameSetUp						;Game setup screen, called from PeriodOver. Builds the screen
									;(setoptions), then runs the menu: up / down move the frame, left / right
									;change the option (ChangeOption) and redraw (FixModeOptions), start
									;begins the game (SetupStart), and $5460 frames without a press start a
									;demo (SetupDemo).
	jsr	$2A58C.l
	movea.l	#$18C38,a3
	jsr	(InitializeGameStructuresSub2).l
	move.w	$18C22.l,$18C0A.l
	move.w	$18C24.l,$18BFA.l
	bclr	#$1,$17F7A.l		;no overtime
	jsr	$29302.l
	jsr	(ReadNameLog).l		;read the SRAM name list
	bsr.w	PrintOptionNamesSub1		;build the screen
	clr.w	$19384.l
	clr.w	$19386.l
	bsr.w	PrintOptionNames
	tst.w	$18C16.l
	bne.w	.l8440
	moveq	#$1C,d0
	jsr	(randomd0).l
	move.w	d0,$18BFE.l
	moveq	#$1C,d0
	jsr	(randomd0).l
	move.w	d0,$18C00.l
.l8440	st.b	$18C16.l
	cmpi.w	#$4,$18BFA.l
	bne.w	.l8456
	bra.w	.reggame
.l8456	cmpi.w	#$2,$18BFA.l
	blt.w	.l8466
	bsr.w	GameSetUpSub3
.l8466	cmpi.w	#$1,$18BFA.l
	bne.w	.reggame		;not continue playoffs
	bsr.w	GameSetUpSub4
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
GameSetUpSub1
	cmpi.w	#$4,$18BFA.l
	bne.w	.l84E6
	move.w	#$1,$18C0A.l
	move.w	#$0,$18C08.l
	move.w	#$1,$18C06.l
.l84E6	bsr.w	ReadSetupPads
	tst.w	d1
	bne.w	.l84F4
	bra.w	ReadSetupPadsSub1
.l84F4	btst	#$7,d1
	bne.w	ReadSetupPadsSub2
	btst	#$1,d1
	beq.w	.l85A0
	tst.w	(OptNOP).l
	bne.w	.l851E
	cmpi.w	#$8,d7
	bne.w	.l851E
	move.w	#$4,d0
	bra.w	.l8522
.l851E	move.w	#$2,d0
.l8522	cmpi.w	#$4,$18BFA.l
	beq.w	.l8548
	tst.w	(OptNOP).l
	bne.w	.l8548
	cmpi.w	#$8,d7
	bne.w	.l8548
	move.w	#$6,d0
	bra.w	.l8594
.l8548	cmpi.w	#$6,d7
	bne.w	.l856C
	cmpi.w	#$4,$18BFA.l
	bne.w	.l856C
	tst.w	(OptNOP).l
	bne.w	.l8590
	clr.w	d0
	bra.w	.l8594
.l856C	cmpi.w	#$A,d7
	bne.w	.l8594
	cmpi.w	#$4,$18BFA.l
	bne.w	.l8586
	clr.w	d0
	bra.w	.l8594
.l8586	tst.w	$193BA.l
	bpl.w	.l8594
.l8590	move.w	#$4,d0
.l8594	bsr.w	MoveMenuFrame
	bsr.w	FixModeOptions
	bra.w	GameSetUpSub1
.l85A0	btst	#$0,d1
	beq.w	.l862E
	tst.w	(OptNOP).l
	bne.w	.l85C2
	cmpi.w	#$C,d7
	bne.w	.l85C2
	move.w	#$FFFC,d0
	bra.w	.l85EC
.l85C2	move.w	#$FFFE,d0
	cmpi.w	#$4,$18BFA.l
	beq.w	.l85EC
	tst.w	(OptNOP).l
	bne.w	.l85EC
	cmpi.w	#$E,d7
	bne.w	.l85EC
	move.w	#$FFFA,d0
	bra.w	.l8622
.l85EC	cmpi.w	#$A,d7
	bne.w	.l8600
	cmpi.w	#$4,$18BFA.l
	beq.w	.l861E
.l8600	cmpi.w	#$E,d7
	bne.w	.l8622
	cmpi.w	#$4,$18BFA.l
	beq.w	.l861E
	tst.w	$193BA.l
	bpl.w	.l8622
.l861E	move.w	#$FFFC,d0
.l8622	bsr.w	MoveMenuFrame
	bsr.w	FixModeOptions
	bra.w	GameSetUpSub1
.l862E	moveq	#$1,d2
	btst	#$3,d1
	bne.w	.l8642
	btst	#$2,d1
	beq.w	GameSetUpSub1
	moveq	#-1,d2
.l8642	cmpi.w	#$4,$18BFA.l
	beq.w	.l8654
	jsr	(FigureJoy).l
.l8654	move.w	$18C00.l,-(sp)
	move.w	$18BFE.l,-(sp)
	bsr.w	ChangeOption
	move.w	(sp)+,d0
	cmpi.w	#$4,$18BFA.l
	beq.w	.l867C
	tst.w	$18BFA.l
	bne.w	.l8690
.l867C	move.w	$18BFE.l,(HomeTeam).l
	move.w	$18C00.l,(VisTeam).l
.l8690	move.w	(HomeTeam).l,$1938A.l
	btst	#$6,$19390.l
	beq.w	.l86BE
	movem.w	d0,-(sp)
	move.w	$1938C.l,d0
	cmp.w	(HomeTeam).l,d0
	movem.w	(sp)+,d0
	beq.w	.l86CC
.l86BE	move.w	(HomeTeam).l,$1938C.l
	bsr.w	DrawHomeBlock
.l86CC	btst	#$7,$19390.l
	beq.w	.l86F0
	movem.w	d0,-(sp)
	move.w	$1938E.l,d0
	cmp.w	(VisTeam).l,d0
	movem.w	(sp)+,d0
	beq.w	.l8712
.l86F0	move.w	(VisTeam).l,$1938E.l
	move.w	(VisTeam).l,$1938A.l
	bsr.w	DrawVisBlock
	move.w	(HomeTeam).l,$1938A.l
.l8712	tst.w	(sp)+
	bra.w	GameSetUpSub2
	dc.w	$301F,$B079,$0001,$7FB0,$6700,$006C,$33F9,$0001
	dc.w	$7FB0,$0001,$938A,$48A7,$8000,$3039,$0001,$7FB0
	dc.w	$B079,$0001,$7FB0,$4C9F,$0001,$6700,$0010,$33F9
	dc.w	$0001,$7FB0,$0001,$938E,$6100,$1274,$48A7,$8000
	dc.w	$3039,$0001,$938C,$B079,$0001,$7FAE,$4C9F,$0001
	dc.w	$6700,$0024,$33F9,$0001,$7FAE,$0001,$938C,$33F9
	dc.w	$0001,$7FAE,$0001,$938A,$6100,$11E0,$33F9,$0001
	dc.w	$7FB0,$0001,$938A
GameSetUpSub2
	bsr.w	FixModeOptions
	bra.w	GameSetUpSub1
	rts
GameSetUpSub3
	jmp	$401C4.l
GameSetUpSub4
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
	bpl.w	.l87EA
	move.w	d0,-(sp)
	move.w	d7,d0
	asr.w	#$1,d0		;lines
	cmp.w	$19384.l,d0
	bne.w	.l87E8
	move.w	$19384.l,$19386.l
	bset	#$2,$17F74.l
	subi.w	#$1,$19384.l
	bpl.w	.l87E8
	clr.w	$19384.l
.l87E8	move.w	(sp)+,d0
.l87EA	move.w	d7,$17E62.l
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
	bgt.w	.l8816		;below the frame: scroll
	bra.w	.2
.l8816	move.w	$19384.l,$19386.l
	bset	#$2,$17F74.l
	addi.w	#$1,$19384.l
	move.w	d7,d0
	asr.w	#$1,d0
	sub.w	$19384.l,d0
	cmpi.w	#$5,d0
	ble.w	.l884A
	addi.w	#$1,$19384.l
.l884A	cmpi.w	#$3,$19384.l
	ble.w	.2
	move.w	#$3,$19384.l
.2	move.w	(sp)+,d0
.3	btst	#$2,$17F74.l		;scrolled?
	bne.w	.4
	move.w	$19384.l,$19386.l
.4	cmpi.w	#$12,d7		;past the last line (Line Changes)
	blt.w	.l8880
	sub.w	d0,d7
.l8880	cmpi.w	#$1,$18BFA.l
	bne.w	.l889A
	tst.w	d7		;top line?
	beq.w	.l889A
	cmpi.w	#$6,d7		;line 6 or above?
	bls.w	.optionup
.l889A	cmpi.w	#$2,$18BFA.l
	blt.w	.5
	cmpi.w	#$4,$18BFA.l
	beq.w	.5
	cmpi.w	#$6,d7		;line 6?
	beq.w	.optionup
.5	bsr.w	.l891E		;printx $10, printy $E, 23 x 13
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
	bsr.w	SetFrameRectUnused_1		;the new frame
	move.w	#$6000,(printa).l
	jmp	(Framer).l
.l891E	jsr	(printz).l
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
SetFrameRectUnused_1	jsr	(printz).l
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
	bne.w	.l89E4
	move.w	#$1,$18C06.l
.l89E4	tst.w	(OptNOP).l
	bne.w	.0
	move.w	#$1,$18C06.l
.0	tst.w	(OptNOP).l		;one player?
	bne.w	.l8A3A
	move.w	#$0,$18C04.l		;Off
	move.w	#$0,$18C0C.l
	move.w	#$0,$18C0E.l
	tst.w	(OptNOP).l		;one player?
	bne.w	.l8A3A
	move.w	#$1,$18C04.l		;goalie on auto
	move.w	#$1,$18C0C.l
	move.w	#$1,$18C0E.l
.l8A3A	move.w	$19384.l,d0
	cmp.w	$19386.l,d0
	beq.w	.3
	bsr.w	PrintOptionNames
.3	bset	#$3,(sflags6).l		;print all
	bsr.w	PrintOptions		;print the options
	bclr	#$3,(sflags6).l		;normal
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.w	$0005,$0008,$001C,$001C,$0003,$0002,$0002,$0003
	dc.w	$0003,$0005,$000C,$001C,$001C,$0003,$0002,$0002
	dc.w	$0003,$0003
ChangeOption
	tst.w	d7
	bne.w	.l8B0C
	movem.w	d0/d2,-(sp)
	tst.w	d2
	beq.w	.l8AD2
	move.w	$18BFA.l,d0
	add.w	d2,d0
	bpl.w	.l8AAC
	move.w	#$4,d0
.l8AAC	cmpi.w	#$4,d0
	bne.w	.l8AD2
	move.w	$18C06.l,$18C10.l
	move.w	$18C08.l,$18C12.l
	move.w	$18C0A.l,$18C14.l
.l8AD2	movem.w	(sp)+,d0/d2
	tst.w	d7
	bne.w	.l8B0C
	tst.w	d2
	beq.w	.l8B0C
	cmpi.w	#$4,$18BFA.l
	bne.w	.l8B0C
	move.w	$18C10.l,$18C06.l
	move.w	$18C12.l,$18C08.l
	move.w	$18C14.l,$18C0A.l
.l8B0C	movea.l	#$18BFA,a2
	movea.l	#$23A68,a3
	tst.w	$18BF8.l
	beq.w	.l8B28
	movea.l	#$23A7A,a3
.l8B28	clr.w	d5
	move.w	(a3,d7.w),d4
	move.w	(a2,d7.w),d3
	cmpi.w	#$2,$18BFA.l
	blt.w	.l8B54
	cmpi.w	#$4,$18BFA.l
	beq.w	.l8B54
	cmpi.w	#$4,d7
	bne.w	.l8B54
	moveq	#$1A,d4
.l8B54	cmpi.w	#$2,d7
	bne.w	.l8C00
	cmpi.w	#$4,$18BFA.l
	bne.w	.l8BC4
	movem.w	d2,-(sp)
	add.w	(OptNOP).l,d2
	bpl.w	.l8B7A
	addi.w	#$7,d2
.l8B7A	cmpi.w	#$4,d2
	movem.w	(sp)+,d2
	ble.w	.l8B9C
	tst.w	d2
	bpl.w	.l8B94
	move.w	#$4,d2
	bra.w	.l8BC4
.l8B94	addi.w	#$2,d2
	bra.w	.l8BC4
.l8B9C	movem.w	d2,-(sp)
	add.w	(OptNOP).l,d2
	cmpi.w	#$3,d2
	movem.w	(sp)+,d2
	bne.w	.l8BC4
	tst.w	d2
	bpl.w	.l8BC0
	subi.w	#$1,d2
	bra.w	.l8BC4
.l8BC0	addi.w	#$1,d2
.l8BC4	moveq	#$5,d5
	tst.w	$18BF8.l
	beq.w	.l8BD8
	move.w	#$A,d4
	addi.w	#$2,d5
.l8BD8	cmpi.w	#$4,$18BFA.l
	beq.w	.l8BEE
	tst.w	$18BFA.l
	bne.w	.l8BF2
.l8BEE	clr.w	d5
	moveq	#$5,d4
.l8BF2	tst.w	$18BF8.l
	beq.w	.l8C00
	addi.w	#$2,d4
.l8C00	bsr.w	WrapOption
	tst.w	$18BF8.l
	beq.w	.l8C44
	cmpi.w	#$2,d7
	bne.w	.l8C44
	tst.w	d2
	bmi.w	.l8C30
	cmpi.w	#$9,d3
	beq.w	.l8C40
	cmpi.w	#$A,d3
	beq.w	.l8C40
	bra.w	.l8C44
.l8C30	cmpi.w	#$A,d3
	bne.w	.l8C44
	move.w	#$8,d3
	bra.w	.l8C44
.l8C40	move.w	#$B,d3
.l8C44	move.w	d3,(a2,d7.w)
	tst.w	d2
	beq.w	SetFrameRectUnusedExit
	cmpi.w	#$1,$18BFA.l
	bne.w	.l8C78
	tst.w	d7
	bne.w	.l8C78
	jsr	$40132.l
	move.w	$18A9E.l,d0
	or.w	$18A9C.l,d0
	beq.w	.l8BF2
	rts
.l8C78	cmpi.w	#$2,$18BFA.l
	blt.w	SetFrameRectUnusedExit
	cmpi.w	#$4,$18BFA.l
	beq.w	SetFrameRectUnusedExit
	tst.w	d7
	beq.w	GameSetUpSub3
	cmpi.w	#$4,d7
	beq.w	GameSetUpSub3
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
.l8CBE	addi.w	#$2,d7
	clr.w	d2
	bsr.w	ChangeOption
	movem.l	d7,-(sp)
	asr.w	#$1,d7
	cmp.w	$19384.l,d7
	movem.l	(sp)+,d7
	blt.w	.l8CE0
	bsr.w	PrintOptionValue
.l8CE0	cmpi.w	#$10,d7
	bne.w	.l8CBE
	bsr.w	PrintScrollMarks
	move.w	d6,d7
	jsr	(TeamIcons).l
	btst	#$0,$19390.l
	bne.w	.l8D06
	jsr	(ResetCardTimer).l
.l8D06	rts
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
	movea.l	#$23ECC,a0
	adda.w	(a0,d7.w),a0		;its value Strings
	cmpa.l	#$24104,a0		;period length?
	bne.w	.l8D8A
	cmpi.w	#$4,$18BFA.l
	bne.w	.l8D8A
	movea.l	#$23EB6,a1
	jmp	(print).l
.l8D8A	tst.w	$18BF8.l
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
	dc.w	$0004,$7B00,$0004,$7D00,$0004,$2000
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
	dc.b	$00,$14,'New York Islan'
	dc.b	'ders',$00,$12,'New York R'
	dc.b	'angers',$00,$16,'        '
	dc.b	'            ',$00,$16,'N/'
	dc.b	'A               '
	dc.w	$2020
OptionValueOffsets						;Offsets of each option's value Strings. Team 1 / 2 are not read
									;(PrintOptTeamName); User Records uses the On / Off list
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_08ECC.bin
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
	dc.b	$00,$10,'Play Mode    ',$00
	dc.b	$00,$10,'Players      ',$00
	dc.b	$00,$10,'Team 1       ',$00
	dc.b	$00,$10,'Team 2       ',$00
	dc.b	$00,$10,'Per. Length  ',$00
	dc.b	$00,$10,'Goalies      ',$00
	dc.b	$00,$10,'User Records ',$00
	dc.b	$00,$10,'Penalties    ',$00
	dc.b	$00,$10,'Line Changes ',$00
	dc.w	$0004,$0000
