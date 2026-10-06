;	NHL 94 (retail) segment $F739E-$F8B59
;	The 94 game setup screen (93 hockey93_08 setoptions). 94 splits 93's setoptions: GameSetUp (called from PeriodOver) runs the menu
;	and the start / demo exits, setoptions only builds the screen, and GameSetUp_2 waits for a pad (93 .top / .wait). The 93 setoptions
;	locals are 94 routines: sub_F76D4 (.nms), GameSetUp_3 (.IncItem), sub_F7B0A (.iilimit), sub_F7B20 (.ps), GameSetUp_4 (.psd),
;	loc_F7C5E (.psdtp), sub_F7864 (.setrect), loc_F8418 (.demo), loc_F843E (.ex), unk_F791E (.pslim), unk_F7D04 (.pl), unk_F80D4 (.text).
;	94 adds the Goalies and User Records options (9 lines, 6 shown, scrolled by word_FFD422), Shootout, four way play, the team logo
;	blocks (sub_F85B0 / sub_F8608) and player cards with user records (sub_F87EA, sub_F8868). The 93 team block roster players
;	(UpdateBothTeamDisplays ... AddTeamSpriteFrame) are not here (nullsub_3 is called in their place). VBlank_SetOptions is attract94; DefaultMenus, NewPO, MakeTree and
;	FigureJoy are hockey94_09. This range is in the 94 code at the end of the ROM, after the hot / cold player code (sub_F737E) and
;	before wallcollduringcheck ($F8B5A).
;	Transcribed from lst/nhl94.bin.lst lines 960187-963038. Global names are the IDA names (GameSetUp ... GameSetUp_4 are IDA names);
;	locals are the IDA local names (_x -> .x) or the IDA address (loc_F7464 -> .F7464). IDA labels reached across a global label stay
;	global (loc_F7C5E, loc_F8418, loc_F843E, loc_F865C, loc_F8796, locret_F78A0).
;	IDA gaps written from the retail bytes: unreferenced code IDA left as dc.b ($F7666-$F76BD and the rts at $F76C6 in GameSetUp,
;	sub_F7822) or unlabeled (sub_F84A2); sub_F84D0 (IDA unk_F84D0, dc.b and code); the five DecompressGraphicsWithCallback remap
;	tables; the printz Strings (IDA ori.b, some with a word dropped) and the instructions IDA hid in them; the menu text as String
;	tables; unk_F86F2 as dc.l. sub_F8868 continues past IDA's end of function.
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp / cmpi;
;	fixopcodes.js patches the cmp encoding after assembly.
;	Options (d7 = line * 2, the offset from OptPlayMode): 0 OptPlayMode (Regular Season, Continue Playoffs, New Playoffs, New
;	Playoffs/7 game, Shootout), 2 OptNOP, 4 Opt1Team, 6 Opt2Team, 8 OptPerlen, $A OptGoalie, $C OptUserRec (0 On), $E OptPen (0 Off),
;	$10 OptLine (0 On, 2 Auto). word_FFD42E bits: 0 player card up, 1 card side (visitors), 2 / 3 home / visitors block drawn,
;	5 C pressed, 6 / 7 home / visitors logo shown. Pad bits: ubut 0, dbut 1, lbut 2, rbut 3, cbut 5, sbut 7.
;	printz String first byte, negated: low 2 bits = map, the rest << 9 = printa ($FF / $FE map 1 / 2, $BF map 1 + priority).

GameSetUp	;IDA name. 94 game setup screen, called from PeriodOver (93 PeriodOver called setoptions). Builds the screen (setoptions), then runs
	;the menu: up / down move the frame (sub_F76D4), left / right change the option (GameSetUp_3) and redraw (sub_F78A2), start begins the game
	;(loc_F843E), and $5460 frames without a press start a demo (loc_F8418). 93 setoptions from .keep on
	jsr	(sub_FE660).l
	movea.l	#unk_FFD088,a3	;saved playoff state
	jsr	(sub_1803E).l	;(93 ReadPassBits)
	move.w	(TmpOptLine2).w,(OptLine).w	;undo the start changes of loc_F843E (Auto line changes, Shootout)
	move.w	(TempOptPlayMode).w,(OptPlayMode).w
	bclr	#1,(byte_FFC2FC).w
	jsr	(sub_FD73C).l
	jsr	(sub_F9C68).l	;read the SRAM name list
	bsr.w	setoptions	;build the screen
	clr.w	(word_FFD422).w	;first menu line shown
	clr.w	(word_FFD424).w
	bsr.w	sub_F8070	;option names
	tst.w	(demoflag).w	;clear after a demo (93 .keep)
	bne.w	.shootout	;keep the teams
	moveq	#$1C,d0
	jsr	(randomd0).l
	move.w	d0,(Opt1Team).w	;random teams after a demo (0-27)
	moveq	#$1C,d0
	jsr	(randomd0).l
	move.w	d0,(Opt2Team).w
.shootout
	st	(demoflag).w
	cmpi.w	#4,(OptPlayMode).w	;check if shootout
	bne.w	.newplay	;branch if not
	bra.w	.reggame	;branch if so
.newplay
	cmpi.w	#2,(OptPlayMode).w	;check if new playoffs
	blt.w	.contplay	;branch if cont. playoffs or reg season
	bsr.w	j_NewPO	;new playoffs: random tree (93 SelectRandomPlayoffTree)
.contplay
	cmpi.w	#1,(OptPlayMode).w	;check if cont playoffs
	bne.w	.reggame	;branch if not
	bsr.w	sub_F76CE	;continue playoffs (93 NewPO)
.reggame
	clr.w	d7	;menu line 0 (d7 = line * 2 = offset in OptPlayMode ... OptLine)
	clr.w	d0
	bsr.w	sub_F76D4	;frame the line
	bsr.w	sub_F78A2	;print the options
	move.w	(HomeTeam).w,(word_FFD42A).w
	move.w	(HomeTeam).w,(word_FFD428).w
	bsr.w	sub_F85B0	;home team block
	move.w	(VisTeam).w,(word_FFD42C).w
	move.w	(VisTeam).w,(word_FFD428).w
	bsr.w	sub_F8608	;visitors team block
	move.w	#$18,(palcount).w	;24
	bclr	#2,(disflags).w	;dfng: fade in graphics now
.F7464
	cmpi.w	#4,(OptPlayMode).w	;Shootout: line changes Off, penalties Off, user records Off
	bne.w	.F7480
	move.w	#1,(OptLine).w
	move.w	#0,(OptPen).w
	move.w	#1,(OptUserRec).w
.F7480
	bsr.w	GameSetUp_2	;d1 = new presses, 0 after $5460 frames
	tst.w	d1
	bne.w	.F748E
	bra.w	loc_F8418	;none: demo
.F748E
	btst	#7,d1	;sbut
	bne.w	loc_F843E	;start the game
	btst	#1,d1	;dbut: next line, past the lines that do not apply (Demo: Goalies, User Records; Shootout: Per. Length, nothing after Goalies; no SRAM: User Records)
	beq.w	.F752C
	tst.w	(OptNOP).w
	bne.w	.F74B6
	cmp.w	#8,d7
	bne.w	.F74B6
	move.w	#4,d0
	bra.w	.F74BA
.F74B6
	move.w	#2,d0
.F74BA
	cmpi.w	#4,(OptPlayMode).w
	beq.w	.F74DC
	tst.w	(OptNOP).w
	bne.w	.F74DC
	cmp.w	#8,d7
	bne.w	.F74DC
	move.w	#6,d0
	bra.w	.F7520
.F74DC
	cmp.w	#6,d7
	bne.w	.F74FC
	cmpi.w	#4,(OptPlayMode).w
	bne.w	.F74FC
	tst.w	(OptNOP).w
	bne.w	.F751C
	clr.w	d0
	bra.w	.F7520
.F74FC
	cmp.w	#$A,d7
	bne.w	.F7520
	cmpi.w	#4,(OptPlayMode).w
	bne.w	.F7514
	clr.w	d0
	bra.w	.F7520
.F7514
	tst.w	(ValidSRAM).w
	bpl.w	.F7520
.F751C
	move.w	#4,d0
.F7520
	bsr.w	sub_F76D4
	bsr.w	sub_F78A2
	bra.w	.F7464
.F752C
	btst	#0,d1	;ubut: previous line, the same skips
	beq.w	.F75AE
	tst.w	(OptNOP).w
	bne.w	.F754C
	cmp.w	#$C,d7
	bne.w	.F754C
	move.w	#$FFFC,d0
	bra.w	.F7572
.F754C
	move.w	#$FFFE,d0
	cmpi.w	#4,(OptPlayMode).w
	beq.w	.F7572
	tst.w	(OptNOP).w
	bne.w	.F7572
	cmp.w	#$E,d7
	bne.w	.F7572
	move.w	#$FFFA,d0
	bra.w	.F75A2
.F7572
	cmp.w	#$A,d7
	bne.w	.F7584
	cmpi.w	#4,(OptPlayMode).w
	beq.w	.F759E
.F7584
	cmp.w	#$E,d7
	bne.w	.F75A2
	cmpi.w	#4,(OptPlayMode).w
	beq.w	.F759E
	tst.w	(ValidSRAM).w
	bpl.w	.F75A2
.F759E
	move.w	#$FFFC,d0
.F75A2
	bsr.w	sub_F76D4
	bsr.w	sub_F78A2
	bra.w	.F7464
.F75AE
	moveq	#1,d2
	btst	#3,d1	;rbut
	bne.w	.F75C2
	btst	#2,d1	;lbut
	beq.w	.F7464
	moveq	#-1,d2
.F75C2
	cmpi.w	#4,(OptPlayMode).w
	beq.w	.F75D2
	jsr	(FigureJoy).l
.F75D2
	move.w	(Opt2Team).w,-(sp)
	move.w	(Opt1Team).w,-(sp)
	bsr.w	GameSetUp_3	;change the option by d2
	move.w	(sp)+,d0
	cmpi.w	#4,(OptPlayMode).w
	beq.w	.F75F2
	tst.w	(OptPlayMode).w
	bne.w	.F75FE
.F75F2
	move.w	(Opt1Team).w,(HomeTeam).w	;Regular Season and Shootout: the menu teams
	move.w	(Opt2Team).w,(VisTeam).w
.F75FE
	move.w	(HomeTeam).w,(word_FFD428).w
	btst	#6,(word_FFD42E).w	;home logo shown?
	beq.w	.F7622
	movem.w	d0,-(sp)
	move.w	(word_FFD42A).w,d0
	cmp.w	(HomeTeam).w,d0
	movem.w	(sp)+,d0
	beq.w	.F762C
.F7622
	move.w	(HomeTeam).w,(word_FFD42A).w
	bsr.w	sub_F85B0
.F762C
	btst	#7,(word_FFD42E).w	;visitors logo shown?
	beq.w	.F764A
	movem.w	d0,-(sp)
	move.w	(word_FFD42C).w,d0
	cmp.w	(VisTeam).w,d0
	movem.w	(sp)+,d0
	beq.w	.F7660
.F764A
	move.w	(VisTeam).w,(word_FFD42C).w
	move.w	(VisTeam).w,(word_FFD428).w
	bsr.w	sub_F8608
	move.w	(HomeTeam).w,(word_FFD428).w
.F7660
	tst.w	(sp)+
	bra.w	.F76BE	;redraw
	move.w	(sp)+,d0	;IDA dc.b, no xref: an older copy of the team block update above
	cmp.w	(VisTeam).w,d0
	beq.w	.F76BE
	move.w	(VisTeam).w,(word_FFD428).w
	movem.w	d0,-(sp)
	move.w	(VisTeam).w,d0
	cmp.w	(VisTeam).w,d0
	movem.w	(sp)+,d0
	beq.w	.F7694
	move.w	(VisTeam).w,(word_FFD42C).w
	bsr.w	sub_F8608
.F7694
	movem.w	d0,-(sp)
	move.w	(word_FFD42A).w,d0
	cmp.w	(HomeTeam).w,d0
	movem.w	(sp)+,d0
	beq.w	.F76BE
	move.w	(HomeTeam).w,(word_FFD42A).w
	move.w	(HomeTeam).w,(word_FFD428).w
	bsr.w	sub_F85B0
	move.w	(VisTeam).w,(word_FFD428).w
.F76BE
	bsr.w	sub_F78A2
	bra.w	.F7464
	rts	;IDA dc.b, no xref
j_NewPO	;IDA name. New playoffs: jmp NewPO (hockey94_09; 93 SelectRandomPlayoffTree). Called from GameSetUp and GameSetUp_3
	jmp	NewPO
sub_F76CE	;94 only. Continue playoffs: jmp sub_17CA0 (hockey94_09; 93 NewPO). Called from GameSetUp
	jmp	sub_17CA0
sub_F76D4	;93 setoptions .nms: move the menu frame by d0 (+2 / -2 lines). 94 shows 6 of the 9 lines and scrolls: word_FFD422 = first line shown
	;(0-3), word_FFD424 = the one before (word_FFC2F6 bit 2 set on a scroll; sub_F78A2 reprints the names when they differ). Continue playoffs
	;skips lines 1-3, new playoffs line 3 (Team 2). The old frame is erased by redrawing the unk_BEFB8 background under it. Called from GameSetUp
	move.w	d7,d3
.optionup
	bclr	#2,(word_FFC2F6).w
	tst.w	d0
	bpl.w	.optiondown
	move.w	d0,-(sp)
	move.w	d7,d0
	asr.w	#1,d0
	cmp.w	(word_FFD422).w,d0
	bne.w	.noscroll
	move.w	(word_FFD422).w,(word_FFD424).w
	bset	#2,(word_FFC2F6).w
	subq.w	#1,(word_FFD422).w
	bpl.w	.noscroll
	clr.w	(word_FFD422).w
.noscroll
	move.w	(sp)+,d0
.optiondown
	move.w	d7,(word_FFBF12).w
	add.w	d0,d7
	bpl.w	.F7716
	clr.w	d7
.F7716
	tst.w	d0
	bmi.w	.F7768
	move.w	d0,-(sp)
	move.w	d7,d0
	asr.w	#1,d0
	sub.w	(word_FFD422).w,d0
	cmp.w	#5,d0
	bgt.w	.scrolldown
	bra.w	.F7766
.scrolldown
	move.w	(word_FFD422).w,(word_FFD424).w
	bset	#2,(word_FFC2F6).w
	addq.w	#1,(word_FFD422).w
	move.w	d7,d0
	asr.w	#1,d0
	sub.w	(word_FFD422).w,d0
	cmp.w	#5,d0
	ble.w	.F7756
	addq.w	#1,(word_FFD422).w
.F7756
	cmpi.w	#3,(word_FFD422).w
	ble.w	.F7766
	move.w	#3,(word_FFD422).w
.F7766
	move.w	(sp)+,d0
.F7768
	btst	#2,(word_FFC2F6).w
	bne.w	.F7778
	move.w	(word_FFD422).w,(word_FFD424).w
.F7778
	cmp.w	#$12,d7	;past the last line (Line Changes)
	blt.w	.contplayoffs
	sub.w	d0,d7
.contplayoffs
	cmpi.w	#1,(OptPlayMode).w
	bne.w	.newplay
	tst.w	d7
	beq.w	.newplay
	cmp.w	#6,d7
	bls.w	.optionup
.newplay
	cmpi.w	#2,(OptPlayMode).w
	blt.w	.F77B6
	cmpi.w	#4,(OptPlayMode).w
	beq.w	.F77B6
	cmp.w	#6,d7
	beq.w	.optionup
.F77B6
	bsr.w	sub_F780C	;printx $10, printy $E, 23 x 13
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(word_FFD426).w,d4
	movea.l	#unk_BEFB8,a0	;menu background: redraw that part (word_FFC2F8 bit 0) over the old frame
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	move.w	(printx).w,d0
	subq.w	#1,d0
	move.w	d1,d3
	move.w	(printy).w,d1
	subi.w	#$E,d1
	moveq	#$17,d2
	moveq	#0,d5
	bset	#0,(word_FFC2F8).w
	jsr	(dobitmap).l
	bclr	#0,(word_FFC2F8).w
	movem.l	(sp)+,d0-d7/a0-a6
	move.w	d7,d3
	bsr.w	sub_F7864	;the new frame
	move.w	#$6000,(printa).w
	jmp	Framer
sub_F780C	;94 only. Set the menu area for sub_F76D4: printx $10, printy $E, d0 = 23 x d1 = 13
	jsr	(printz).l
	String	$FF,$10,$E	;IDA: ori.b (and dropped a word)
	move.w	#$17,d0
	move.w	#$D,d1
	rts
sub_F7822	;no IDA label (IDA dc.b, no xref). An unused copy of sub_F7864 without its printz that uses word_FFD424 and stops at row $18
	add.w	d3,(printy).w
	move.w	(word_FFD424).w,d0
	add.w	d0,d0
	sub.w	d0,(printy).w
	cmpi.w	#$18,(printy).w
	ble.w	.F7840
	move.w	#$18,(printy).w
.F7840
	moveq	#$17,d0
	moveq	#3,d1
	cmpi.w	#2,(OptPlayMode).w
	blt.w	locret_F78A0
	cmpi.w	#4,(OptPlayMode).w
	beq.w	locret_F78A0
	cmp.w	#4,d3
	bne.w	locret_F78A0
	moveq	#5,d1
	rts
sub_F7864	;93 setoptions .setrect: frame position for line d3 (row $E + d3 - word_FFD422 * 2), 23 x 3, or 23 x 5 for Team 1 in new playoffs (93 22 x 3 / 5). Called from sub_F76D4
	jsr	(printz).l
	String	$FF,$10,$E	;IDA: ori.b (and dropped a word)
	add.w	d3,(printy).w	;2 rows per line
	move.w	(word_FFD422).w,d0
	add.w	d0,d0
	sub.w	d0,(printy).w
	moveq	#$17,d0
	moveq	#3,d1
	cmpi.w	#2,(OptPlayMode).w
	blt.w	locret_F78A0
	cmpi.w	#4,(OptPlayMode).w
	beq.w	locret_F78A0
	cmp.w	#4,d3
	bne.w	locret_F78A0
	moveq	#5,d1
locret_F78A0	;IDA label. The shared rts; GameSetUp_3, GameSetUp_4, sub_F7822 and sub_F7B0A branch to it
	rts
sub_F78A2	;94 only. Fix the options a mode does not allow, then print them: Shootout and Demo set User Records Off, Demo sets both goalies to
	;Auto Control. Reprint the option names (sub_F8070) after a scroll, then the values (sub_F7B20) in the setup font (word_FFC2F8 bit 3: print2
	;uses word_FFBF52). Called from GameSetUp
	movem.l	d0-d7/a0-a6,-(sp)
	cmpi.w	#4,(OptPlayMode).w
	bne.w	.F78B6
	move.w	#1,(OptUserRec).w	;Off
.F78B6
	tst.w	(OptNOP).w
	bne.w	.F78C4
	move.w	#1,(OptUserRec).w	;Off
.F78C4
	tst.w	(OptNOP).w
	bne.w	.F78F8
	move.w	#0,(OptGoalie).w
	move.w	#0,(word_FFD05A).w
	move.w	#0,(word_FFD05C).w
	tst.w	(OptNOP).w
	bne.w	.F78F8
	move.w	#1,(OptGoalie).w	;Auto Control
	move.w	#1,(word_FFD05A).w	;both teams
	move.w	#1,(word_FFD05C).w
.F78F8
	move.w	(word_FFD422).w,d0
	cmp.w	(word_FFD424).w,d0
	beq.w	.F7908
	bsr.w	sub_F8070
.F7908
	bset	#3,(word_FFC2F8).w
	bsr.w	sub_F7B20
	bclr	#3,(word_FFC2F8).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
unk_F791E	;IDA name. Number of values of each option (93 setoptions .pslim)
	dc.w	5,8,$1C,$1C,3,2,2,3,3
unk_F7930	;IDA name. The same with FourWayPlay (12 player choices)
	dc.w	5,$C,$1C,$1C,3,2,2,3,3
GameSetUp_3	;IDA name. 93 setoptions .IncItem: add d2 to option d7 (d2 = 0: only limit it) and wrap it in its range (sub_F7B0A). 94: entering
	;Shootout saves User Records, Penalties and Line Changes (TmpOptUserRec ...), leaving restores them; Team 1 in new playoffs has $1A teams; the
	;Players range depends on the mode and FourWayPlay. A new play mode starts the playoffs (sub_17CA0 / j_NewPO). Called from GameSetUp and
	;sub_F7B20
	tst.w	d7
	bne.w	.F79A6
	movem.w	d0/d2,-(sp)
	tst.w	d2
	beq.w	.F797A
	move.w	(OptPlayMode).w,d0
	add.w	d2,d0
	bpl.w	.F7960
	move.w	#4,d0
.F7960
	cmp.w	#4,d0
	bne.w	.F797A
	move.w	(OptUserRec).w,(TmpOptUserRec).w
	move.w	(OptPen).w,(TmpOptPen).w
	move.w	(OptLine).w,(TmpOptLine).w
.F797A
	movem.w	(sp)+,d0/d2
	tst.w	d7
	bne.w	.F79A6
	tst.w	d2
	beq.w	.F79A6
	cmpi.w	#4,(OptPlayMode).w
	bne.w	.F79A6
	move.w	(TmpOptUserRec).w,(OptUserRec).w
	move.w	(TmpOptPen).w,(OptPen).w
	move.w	(TmpOptLine).w,(OptLine).w
.F79A6
	movea.w	#(OptPlayMode-M68K_RAM),a2
	movea.l	#unk_F791E,a3
	tst.w	(FourWayPlay).w
	beq.w	.F79BE
	movea.l	#unk_F7930,a3
.F79BE
	clr.w	d5
	move.w	0(a3,d7.w),d4
	move.w	0(a2,d7.w),d3
	cmpi.w	#2,(OptPlayMode).w
	blt.w	.F79E6
	cmpi.w	#4,(OptPlayMode).w
	beq.w	.F79E6
	cmp.w	#4,d7
	bne.w	.F79E6
	moveq	#$1A,d4	;26 teams in new playoffs
.F79E6
	cmp.w	#2,d7
	bne.w	.F7A78
	cmpi.w	#4,(OptPlayMode).w
	bne.w	.F7A48
	movem.w	d2,-(sp)
	add.w	(OptNOP).w,d2
	bpl.w	.F7A06
	addq.w	#7,d2
.F7A06
	cmp.w	#4,d2
	movem.w	(sp)+,d2
	ble.w	.F7A26
	tst.w	d2
	bpl.w	.F7A20
	move.w	#4,d2
	bra.w	.F7A48
.F7A20
	addq.w	#2,d2
	bra.w	.F7A48
.F7A26
	movem.w	d2,-(sp)
	add.w	(OptNOP).w,d2
	cmp.w	#3,d2
	movem.w	(sp)+,d2
	bne.w	.F7A48
	tst.w	d2
	bpl.w	.F7A46
	subq.w	#1,d2
	bra.w	.F7A48
.F7A46
	addq.w	#1,d2
.F7A48
	moveq	#5,d5
	tst.w	(FourWayPlay).w
	beq.w	.F7A58
	move.w	#$A,d4
	addq.w	#2,d5
.F7A58
	cmpi.w	#4,(OptPlayMode).w
	beq.w	.F7A6A
	tst.w	(OptPlayMode).w
	bne.w	.F7A6E
.F7A6A
	clr.w	d5
	moveq	#5,d4
.F7A6E
	tst.w	(FourWayPlay).w
	beq.w	.F7A78
	addq.w	#2,d4
.F7A78
	bsr.w	sub_F7B0A	;wrap d3
	tst.w	(FourWayPlay).w
	beq.w	.F7ABA
	cmp.w	#2,d7
	bne.w	.F7ABA
	tst.w	d2
	bmi.w	.F7AA6
	cmp.w	#9,d3
	beq.w	.F7AB6
	cmp.w	#$A,d3
	beq.w	.F7AB6
	bra.w	.F7ABA
.F7AA6
	cmp.w	#$A,d3
	bne.w	.F7ABA
	move.w	#8,d3
	bra.w	.F7ABA
.F7AB6
	move.w	#$B,d3
.F7ABA
	move.w	d3,0(a2,d7.w)
	tst.w	d2
	beq.w	locret_F78A0
	cmpi.w	#1,(OptPlayMode).w
	bne.w	.F7AE6
	tst.w	d7
	bne.w	.F7AE6
	jsr	(sub_17CA0).l	;continue playoffs (93 NewPO)
	move.w	(gamelevel).w,d0
	or.w	(bosgames).w,d0
	beq.s	.F7A6E
	rts
.F7AE6
	cmpi.w	#2,(OptPlayMode).w
	blt.w	locret_F78A0
	cmpi.w	#4,(OptPlayMode).w
	beq.w	locret_F78A0
	tst.w	d7
	beq.w	j_NewPO
	cmp.w	#4,d7
	beq.w	j_NewPO
	rts
sub_F7B0A	;93 setoptions .iilimit: d3 + d2, wrapped into d5 ... d4-1. Called from GameSetUp_3
	add.w	d2,d3
	cmp.w	d5,d3
	bge.w	.F7B16
	move.w	d4,d3
	subq.w	#1,d3
.F7B16
	cmp.w	d4,d3
	blt.w	locret_F78A0
	move.w	d5,d3
	rts
sub_F7B20	;93 setoptions .ps: limit each option (GameSetUp_3 with d2 = 0) and print the lines shown (GameSetUp_4), the scroll marks (sub_F7BFA),
	;the team bitmaps (attract94 sub_17AF4) and, unless a player card is up, reset the card timer (sub_F87D2). Called from sub_F78A2
	move.w	d7,d6
	moveq	#-2,d7
.F7B24
	addq.w	#2,d7
	clr.w	d2
	bsr.w	GameSetUp_3
	movem.l	d7,-(sp)
	asr.w	#1,d7
	cmp.w	(word_FFD422).w,d7
	movem.l	(sp)+,d7
	blt.w	.F7B42
	bsr.w	GameSetUp_4
.F7B42
	cmp.w	#$10,d7
	bne.s	.F7B24
	bsr.w	sub_F7BFA
	move.w	d6,d7
	jsr	(sub_17AF4).l
	btst	#0,(word_FFD42E).w
	bne.w	.F7B64
	jsr	(sub_F87D2).l
.F7B64
	rts
GameSetUp_4	;IDA name. 93 setoptions .psd: print the value of option d7 at x $11 on its line (past row $1B: nothing). Team 1 / 2 go to loc_F7C5E;
	;Per. Length in Shootout prints 'N/A'; Players with FourWayPlay uses the second list (+$B0). Called from sub_F7B20
	jsr	(printz).l
	String	$BF,$11,$10	;IDA: ori.b / move.b d0,d0
	move.w	(word_FFD422).w,d0
	add.w	d0,d0
	sub.w	d0,(printy).w
	add.w	d7,(printy).w
	cmpi.w	#$1B,(printy).w
	bgt.w	locret_F78A0
	subq.w	#1,(printy).w
	move.w	#$11,(printx).w
	cmp.w	#4,d7
	beq.w	loc_F7C5E
	cmp.w	#6,d7
	beq.w	loc_F7C5E
	movea.l	#OptPlayMode,a0
	move.w	0(a0,d7.w),d3
	movea.l	#unk_F7D04,a0	;value Strings of option d7
	adda.w	0(a0,d7.w),a0
	cmpa.l	#unk_F7F3C,a0
	bne.w	.F7BD8
	cmpi.w	#4,(OptPlayMode).w
	bne.w	.F7BD8
	movea.l	#unk_F7CEE,a1
	jmp	print
.F7BD8
	tst.w	(FourWayPlay).w
	beq.w	.F7BEC
	cmp.w	#2,d7
	bne.w	.F7BEC
	adda.w	#$B0,a0	;4 way Players list
.F7BEC
	movea.l	a0,a1
	adda.w	(a0),a0
	dbf	d3,.F7BEC
	jmp	print
sub_F7BFA	;94 only. Print the scroll marks at x 2: '}' at row $19 when more lines follow (first line < 3), '{' at row $F when lines are above (first line > 0), else a space
	move.w	#$19,(printy).w
	movea.l	#unk_F7C5A,a1
	cmpi.w	#3,(word_FFD422).w
	beq.w	.F7C20
	cmpi.w	#4,(OptPlayMode).w
	beq.w	.F7C20
	movea.l	#unk_F7C56,a1
.F7C20
	move.w	#2,(printx).w
	jsr	(print).l
	movea.l	#unk_F7C5A,a1
	move.w	#$F,(printy).w
	tst.w	(word_FFD422).w
	beq.w	.F7C46
	movea.l	#unk_F7C52,a1
.F7C46
	move.w	#2,(printx).w
	jmp	print
unk_F7C52	String	'{'	;IDA name. Scroll marks for sub_F7BFA
unk_F7C56	String	'}'	;IDA name
unk_F7C5A	String	' '	;IDA name
loc_F7C5E	;IDA label. 93 setoptions .psdtp: print team name d3 of option d7 (TeamList city; 'New York Islanders' / 'New York Rangers' for teams $D / $E). Branched to from GameSetUp_4
	move.w	(printx).w,-(sp)
	movea.l	#unk_F7CD8,a1
	jsr	(print).l
	move.w	(sp)+,(printx).w
	movea.l	#OptPlayMode,a1
	move.w	0(a1,d7.w),d3
	movea.w	#TeamList,a1
	asl.w	#2,d3
	movea.l	0(a1,d3.w),a1
	lsr.w	#2,d3
	adda.w	4(a1),a1
	cmp.w	#$E,d3
	bne.w	.F7C9E
	movea.l	#unk_F7CC6,a1
	bra.w	.F7CAC
.F7C9E
	cmp.w	#$D,d3
	bne.w	.F7CAC
	movea.l	#unk_F7CB2,a1
.F7CAC
	jmp	print
unk_F7CB2	String	'New York Islanders'	;IDA name. Full names for the two New York teams (TeamList has only the city)
unk_F7CC6	String	'New York Rangers'	;IDA name
unk_F7CD8	String	'                    '	;IDA name. A blank value
unk_F7CEE	String	'N/A                 '	;IDA name. Per. Length in Shootout
unk_F7D04	;IDA name. Offsets of each option's value Strings (93 setoptions .pl). Team 1 / 2 are not read (loc_F7C5E); User Records uses the On / Off list
	dc.w	unk_F7D16-unk_F7D04,unk_F7D84-unk_F7D04,unk_F8002-unk_F7D04,unk_F8002-unk_F7D04,unk_F7F3C-unk_F7D04
	dc.w	unk_F7F94-unk_F7D04,unk_F8002-unk_F7D04,unk_F7FC0-unk_F7D04,unk_F802E-unk_F7D04
unk_F7D16	;no IDA label. Play Mode: OptPlayMode 0-4
	String	'Regular Season      '
	String	'Continue Playoffs   '
	String	'New Playoffs        '
	String	'New Playoffs/7 game '
	String	'Shootout            '
unk_F7D84	;no IDA label. Players: OptNOP 0-7, then the FourWayPlay list (+$B0)
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
unk_F7F3C	;IDA name. Per. Length
	String	'5 Minutes           '
	String	'10 Minutes          '
	String	'20 Minutes          '
	String	'30 Seconds          '
unk_F7F94	;no IDA label. Goalies (94 only)
	String	'Manual Control      '
	String	'Auto Control        '
unk_F7FC0	;no IDA label. Penalties (93 'Off, Except fighting', 'On', 'On, Except Off-sides')
	String	'Off                 '
	String	'On                  '
	String	'On, Except Off-sides'
unk_F8002	;no IDA label. User Records (94 only), and the unread Team 1 / 2 entries
	String	'On                  '
	String	'Off                 '
unk_F802E	;no IDA label. Line Changes (94 adds Auto)
	String	'On                  '
	String	'Off                 '
	String	'Auto                '
sub_F8070	;94 only. Print the option names from unk_F80D4 at x 3, 2 rows apart from row $F - word_FFD422 * 2, rows $F-$19 only (93 printed setoptions .text once). Called from GameSetUp and sub_F78A2
	movem.l	d0-d1,-(sp)
	bset	#3,(word_FFC2F8).w
	movea.l	#unk_F80D4,a1
	move.w	#$F,d0
	move.w	(word_FFD422).w,d1
	add.w	d1,d1
	sub.w	d1,d0
	move.w	d0,(printy).w
.F8090
	cmpi.w	#$F,(printy).w
	bge.w	.F80A0
	adda.w	(a1),a1
	bra.w	.F80C2
.F80A0
	cmpi.w	#$19,(printy).w
	bgt.w	.F80C8
	move.w	#3,(printx).w
	move.w	#0,(printa).w
	move.w	#0,(printm).w
	jsr	(print2).l
.F80C2
	addq.w	#2,(printy).w
	bra.s	.F8090
.F80C8
	bclr	#3,(word_FFC2F8).w
	movem.l	(sp)+,d0-d1
	rts
unk_F80D4	;IDA name. Option names (93 setoptions .text, which had positions); the last entry is 93 dc.w 4,0 (92 String 0)
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
setoptions	;options screen display and input (IDA comment). 94: build the game setup screen only (93 setoptions up to the random teams): vblank,
	;vram maps, the unk_AFE1A tiles (sub_F84D0), framer, small font and setup font tiles, the screen and menu bitmaps, the logo box tiles and
	;defaultsprites2. Called from GameSetUp
	move.l	#VBlank_SetOptions,(vbint).w
	move	#$2500,sr
	bclr	#0,(disflags).w	;#dfok - graphics are ready for transfer (clr = not ready)
	bset	#2,(disflags).w	;#dfng - dont int graphics
	bclr	#1,(disflags).w	;#df32c - 32 bit column mode (clr = off)
	move.w	#0,(VSCRLPM).w
	move.w	#$B400,(VSPRITES).w
	move.w	#$B800,(VmMap3).w
	move.w	#5,(Map3col1).w
	move.w	#$C000,(VmMap2).w
	move.w	#6,(Map2col1).w
	move.w	#$E000,(VmMap1).w
	move.w	#6,(Map1col1).w
	move.w	#0,d0	;fade to color
	jsr	(setvram).l
	jsr	(orjoy).l
	jsr	(sub_F84D0).l	;unk_AFE1A tiles (where 93 called AddTeamBlock)
	move.w	d4,(framercset).w
	movea.l	#unk_BF54A,a2	;framer tiles (93 FramerMap+8)
	jsr	(DecompressGraphicsWithCallback).l
	dc.l	$03567564,$89ABCDEF	;remap table (IDA: bchg / or.l, a word dropped)
	move.w	d4,(word_FFB012).w
	movea.l	#unk_AAC5A,a2	;small font (93 SmallFontMap+8)
	jsr	(DecompressGraphicsWithCallback).l
	dc.l	$0FC04567,$89ABCDEF	;remap table (IDA: bset / or.l)
	move.w	d4,(word_FFBF52).w
	movea.l	#unk_BE272,a2	;setup screen font (print2 with word_FFC2F8 bit 3)
	jsr	(DecompressGraphicsWithCallback).l
	dc.l	$01234567,$89ABCDEF	;remap table (IDA: btst / or.l)
	jsr	(printz).l
	String	$FF,0,0	;IDA: ori.b x2
	moveq	#$28,d0	;IDA hid this in the string
	moveq	#$1C,d1	;40 x 28
	move.w	#$7FF,d2	;blank char
	jsr	(eraser).l
	jsr	(printz).l
	String	$FE,0,0	;IDA: ori.b x3
	movea.l	#unk_4B7A0,a0	;IDA hid this in the string
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$28,d2
	moveq	#$1C,d3
	moveq	#$D,d5	;color fam 1, 3, 4
	jsr	(dobitmap).l
	move.w	d4,(word_FFD432).w
	addi.w	#$24,d4
	jsr	(printz).l
	String	$FF,0,0	;IDA: ori.b x3
	movea.l	#unk_4DEEE,a0	;IDA hid this in the string
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$28,d2
	moveq	#4,d3	;40 x 4
	moveq	#0,d5
	jsr	(dobitmap).l
	jsr	(printz).l
	String	$FF,1,$E	;IDA: ori.b (and dropped a word)
	move.w	d4,(word_FFD426).w
	movea.l	#unk_BEFB8,a0	;menu background, 38 x 13 at x 1, y $E
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$26,d2
	moveq	#$D,d3
	moveq	#0,d5
	jsr	(dobitmap).l
	move.w	d4,(word_FFD430).w
	addi.w	#$24,d4
	move.w	d4,(word_FFD436).w
	movea.l	#unk_BF70A,a2	;logo box tiles
	jsr	(DoDMA_clearCallbackPointer).l
	move.w	d4,(word_FFD438).w
	movea.l	#unk_BF70A,a2	;again, remapped
	jsr	(DecompressGraphicsWithCallback).l
	dc.l	$03414567,$89ABCDEF	;remap table (IDA: bchg / or.l, a word dropped)
	jsr	(defaultsprites2).l
	move.w	#$28,(word_FFB066).w	;as 93
	move.w	#$28,(word_FFB366).w
	st	(HmShots).w	;(93 hmtmstruct / awtmstruct)
	st	(AwShots).w
	rts
GameSetUp_2	;IDA name. 93 setoptions .top / .wait: wait up to $5460 frames (6 minutes) for a press on any pad (4 with FourWayPlay); return d1 =
	;the presses, 0 on timeout. C does not return: it sets word_FFD42E bit 5 (next player card sooner). When only one logo is shown (after a
	;player card) redraws the team blocks. For the first $E10 frames of the wait, and while a card is up, runs the player cards (sub_F87EA), else
	;resets their timer (sub_F87D2). Called from GameSetUp
	move.l	#$5460,d6	;21600 frames
.F830A
	move.w	(vcount).w,d1
	sub.w	(oldvcount).w,d1
	beq.s	.F830A
	move.w	(vcount).w,(oldvcount).w
	bclr	#5,(word_FFD42E).w
	jsr	(nullsub_3).l
	jsr	(ReadJoy1).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.F8356
	btst	#5,d1	;cbut
	beq.w	.F8416	;another button: return
	btst	#5,d2
	beq.w	.F8350
	move.w	#$53,(word_FFD43C).l
.F8350
	bset	#5,(word_FFD42E).w
.F8356
	jsr	(ReadJoy2).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.F8376
	btst	#5,d1
	beq.w	.F8416
	bset	#5,(word_FFD42E).w
.F8376
	tst.w	(FourWayPlay).w
	beq.w	.F83BE
	jsr	(ReadJoy3).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.F839E
	btst	#5,d1
	beq.w	.F8416
	bset	#5,(word_FFD42E).w
.F839E
	jsr	(ReadJoy4).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.F83BE
	btst	#5,d1
	beq.w	.F8416
	bset	#5,(word_FFD42E).w
.F83BE
	btst	#6,(word_FFD42E).w
	beq.w	.F83DC
	btst	#7,(word_FFD42E).w
	bne.w	.F83F0
	move.w	(word_FFD42C).w,(word_FFD428).w
	bsr.w	sub_F8608
.F83DC
	btst	#7,(word_FFD42E).w
	beq.w	.F83F0
	move.w	(word_FFD42A).w,(word_FFD428).w
	bsr.w	sub_F85B0
.F83F0
	cmp.w	#$4650,d6	;the first $E10 frames (a minute)?
	bgt.w	.F840C
	btst	#0,(word_FFD42E).w
	bne.w	.F840C
	jsr	(sub_F87D2).l
	bra.w	.F8412
.F840C
	jsr	(sub_F87EA).l	;player cards
.F8412
	dbf	d6,.F830A
.F8416
	rts
loc_F8418	;IDA label. 93 setoptions .demo: no press for $5460 frames. Clear demoflag, seed RNGseed, Regular Season, Demo, line changes On,
	;penalties On. Falls into loc_F843E. Branched to from GameSetUp
	clr.w	(demoflag).w
	move.w	(VDP_CNTR).l,(RNGseed).w
	move.w	(VDP_CNTR).l,(RNGseed+2).w
	clr.w	(OptPlayMode).w
	clr.w	(OptNOP).w	;Demo
	clr.w	(OptLine).w
	move.w	#1,(OptPen).w	;On
loc_F843E	;IDA label. 93 setoptions .ex: start. Copy Goalies to both teams, set pojoy (sub_17AC8), seed RNGseed, and keep OptLine / OptPlayMode
	;in TmpOptLine2 / TempOptPlayMode: Auto line changes play as On with byte_FFC2FC bit 4, Shootout as Regular Season with word_FFC2FA bit 0
	;(sub_FC47C). Then jmp MakeTree. Branched to from GameSetUp
	move.w	(OptGoalie).w,-(sp)
	move.w	(sp),(word_FFD05A).w
	move.w	(sp)+,(word_FFD05C).w
	jsr	(sub_17AC8).l
	move.w	(VDP_CNTR).l,(RNGseed).w
	move.w	(VDP_CNTR).l,(RNGseed+2).w
	move.w	(OptLine).w,(TmpOptLine2).w
	cmpi.w	#2,(OptLine).w
	bne.w	.F847A
	clr.w	(OptLine).w
	bset	#4,(byte_FFC2FC).w
.F847A
	move.w	(OptPlayMode).w,(TempOptPlayMode).w
	cmpi.w	#4,(OptPlayMode).w
	bne.w	.F849C
	move.w	#0,(OptPlayMode).w
	bset	#0,(word_FFC2FA).w
	jsr	(sub_FC47C).l
.F849C
	jmp	MakeTree	;hockey94_09
sub_F84A2	;no IDA label, no xref. Tests OptNOP for 0, 5, 6, 9 and $A and returns: no effect
	tst.w	(OptNOP).w
	beq.w	.F84CE
	cmpi.w	#5,(OptNOP).w
	beq.w	.F84CE
	cmpi.w	#6,(OptNOP).w
	beq.w	.F84CE
	cmpi.w	#9,(OptNOP).w
	beq.w	.F84CE
	cmpi.w	#$A,(OptNOP).w
.F84CE
	rts
sub_F84D0	;IDA: unk_F84D0 (IDA dc.b and code). 94 only: load the unk_AFE1A tiles from char 2 (where 93 setoptions called AddTeamBlock), then again remapped at word_FFD43A. Called from setoptions
	moveq	#2,d4	;IDA dc.b. vram char 2
	movea.l	#unk_AFE1A,a2
	jsr	(DoDMA_clearCallbackPointer).l
	move.w	d4,(word_FFD43A).w
	movea.l	#unk_AFE1A,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.l	$03412567,$89ABCDEF	;remap table (IDA: bchg / move.l / dc.b)
	rts
nullsub_3	;IDA name. An empty routine, called from GameSetUp_2 (93 bsr UpdateBothTeamDisplays). An unused rts follows
	rts
	rts
sub_F84FC	;94 only. If a player card is up (word_FFD42E bit 0, cleared here), clear both logo flags (bits 6 / 7) and erase the card: its logo
	;box and its 25 x 8 box. Called from sub_F85B0 and sub_F8608
	movem.l	d0-d7,-(sp)
	bclr	#0,(word_FFD42E).w
	beq.w	.F85AA
	bclr	#6,(word_FFD42E).w
	bclr	#7,(word_FFD42E).w
	jsr	(printz).l
	String	$EF,0,0	;IDA: ori.b x3
	move.w	#5,(printy).w	;IDA hid this in the string
	moveq	#8,d0
	moveq	#8,d1
	move.w	#$7FF,d2
	btst	#1,(word_FFD42E).w
	beq.w	.F8574
	move.w	#3,(printx).w
	jsr	(eraser).l
	jsr	(printz).l
	String	$FF,0,0	;IDA: ori.b x3
	move.w	#$B,(printx).w	;IDA hid this in the string
	move.w	#5,(printy).w
	move.w	#$19,d0
	move.w	#8,d1
.F8566
	move.w	#$7FF,d2
	jsr	(eraser).l
	bra.w	.F85AA
.F8574
	move.w	#$1C,(printx).w
	jsr	(eraser).l
	jsr	(printz).l
	String	$FF,0,0	;IDA: ori.b x3
	move.w	#3,(printx).w	;IDA hid this in the string
	move.w	#5,(printy).w
	move.w	#$19,d0
	move.w	#8,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
.F85AA
	movem.l	(sp)+,d0-d7
	rts
sub_F85B0	;94 only. Draw the home team block: the logo box (sub_F8770) and the HomeTeam logo (word_FFD428) at x $19, y 6. word_FFD42E bit 2:
	;home drawn, bit 6: home logo shown. Called from GameSetUp and GameSetUp_2
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	sub_F84FC
	bset	#2,(word_FFD42E).w
	bset	#6,(word_FFD42E).w
	bsr.w	sub_F8770
	bclr	#3,(word_FFD42E).w
	beq.w	.F85F2
	jsr	(printz).l
	String	$EF,0,0	;IDA: ori.b x3
	move.w	#8,(printx).w	;IDA hid this in the string
	move.w	#5,(printy).w
	moveq	#8,d0
	moveq	#8,d1
	move.w	#$7FF,d2
.F85F2
	jsr	(printz).l
	String	$FF,0,0	;IDA: ori.b x3
	move.w	#$19,(printx).w	;IDA hid this in the string
	bra.w	loc_F865C
sub_F8608	;94 only. The same for the visitors: logo box (sub_F878C), logo at x 9. word_FFD42E bit 3, bit 7. Called from GameSetUp and GameSetUp_2
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	sub_F84FC
	bset	#3,(word_FFD42E).w
	bset	#7,(word_FFD42E).w
	bsr.w	sub_F878C
	bclr	#2,(word_FFD42E).w
	beq.w	.F864A
	jsr	(printz).l
	String	$EF,0,0	;IDA: ori.b x3
	move.w	#$18,(printx).w	;IDA hid this in the string
	move.w	#5,(printy).w
	moveq	#8,d0
	moveq	#8,d1
	move.w	#$7FF,d2
.F864A
	jsr	(printz).l
	String	$CF,0,0	;IDA dc.b
	move.w	#9,(printx).w
loc_F865C	;IDA label. Draw the logo of team word_FFD428 (unk_F86F2) at printx, y 6, 6 x 6, palette unk_FF462 + team * 8 - $20 (home, color fam
	;2) or - $40 (visitors, color fam 3), then wait $B4 frames before a player card (word_FFD440). Branched to from sub_F85B0
	move.w	#$B4,(word_FFD440).w	;180 frames
	move.w	#6,(printy).w
	move.w	(word_FFD430).w,d4
	btst	#2,(word_FFD42E).w
	bne.w	.F867A
	move.w	(word_FFD432).w,d4
.F867A
	move.w	(word_FFD428).w,d3
	asl.w	#2,d3
	movea.l	#unk_F86F2,a0
	movea.l	0(a0,d3.w),a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	asl.w	#3,d3
	movea.l	#unk_FF462,a0
	btst	#2,(word_FFD42E).w
	beq.w	.F86AA
	subi.w	#$20,d3
	bra.w	.F86AE
.F86AA
	subi.w	#$40,d3
.F86AE
	adda.w	d3,a0
	adda.l	(a2)+,a1
	move.w	#6,d3
	move.w	#6,d2
	clr.w	d0
	clr.w	d1
	move.l	(dword_FFBD4A).w,-(sp)
	move.l	(dword_FFBD4E).w,-(sp)
	move.w	#4,d5
	btst	#2,(word_FFD42E).w
	beq.w	.F86D8
	move.w	#2,d5
.F86D8
	jsr	(dobitmap).l
	move.l	(sp)+,(dword_FFBD4E).w
	move.l	(sp)+,(dword_FFBD4A).w
	move.w	#$64,(palcount).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
unk_F86F2	;IDA name. Team logo bitmaps by team number (TeamList order); also used by hockey94_07 sub_FD1F0
	dc.l	$BF8D0,$BFD66,$C00BC,$C0412,$C08A8,$C2362,$C0CDE,$C1034
	dc.l	$C142A,$C1900,$C1FEC,$C2638,$C29AE,$C1B96,$C2E64,$C333A
	dc.l	$C3750,$C3B06,$C3E7C,$C41D2,$C4608,$C49DE,$C4DF4,$C514A
	dc.l	$C5560,$C57D6,$C5C4C,$C6022
sub_F8762	;94 only. Logo box (unk_BF702, 8 x 8) at x $1C, y 5 with the word_FFD436 tiles. Called from sub_F8868
	move.w	(word_FFD436).w,d4
	move.w	#$1C,(printx).w
	bra.w	loc_F8796
sub_F8770	;94 only. Logo box at x $18 (home block). Called from sub_F85B0
	move.w	(word_FFD436).w,d4
	move.w	#$18,(printx).w
	bra.w	loc_F8796
sub_F877E	;94 only. Logo box at x 3 with the word_FFD438 tiles. Called from sub_F8868
	move.w	(word_FFD438).w,d4
	move.w	#3,(printx).w
	bra.w	loc_F8796
sub_F878C	;94 only. Logo box at x 8 (visitors block). Called from sub_F8608
	move.w	(word_FFD438).w,d4
	move.w	#8,(printx).w
loc_F8796	;IDA label. Draw the unk_BF702 box at printx, y 5 (word_FFC2F8 bit 0 set). Branched to from sub_F8762 ... sub_F878C
	clr.w	(printa).w
	move.w	#5,(printy).w
	movea.l	#unk_BF702,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	move.w	#8,d3
	move.w	#8,d2
	clr.w	d0
	clr.w	d1
	move.w	#0,d5
	bset	#0,(word_FFC2F8).w
	jsr	(dobitmap).l
	bclr	#0,(word_FFC2F8).w
	rts
sub_F87D2	;94 only. Reset the player card timer word_FFD43C to $AA ($53 if C was pressed). Called from GameSetUp_2, sub_F7B20 and sub_F87EA
	move.w	#$AA,(word_FFD43C).w
	btst	#5,(word_FFD42E).w
	beq.w	.F87E8
	move.w	#$53,(word_FFD43C).w
.F87E8
	rts
sub_F87EA	;94 only. Player cards, called each frame from GameSetUp_2 in the first minute of its wait. When word_FFD440 runs out set word_FFD42E
	;bit 0; then count word_FFD43C down (C skips $50); at $52 switch sides (bit 1), forget the logos and draw the next card (sub_F8868); below 0
	;restart the timer (sub_F87D2)
	subq.w	#1,(word_FFD440).w
	bpl.w	.F8860
	move.w	#$FFFF,(word_FFD440).w
	bset	#0,(word_FFD42E).w
	btst	#0,(word_FFD42E).w
	beq.w	.F8860
	btst	#5,(word_FFD42E).w
	beq.w	.F8822
	cmpi.w	#$52,(word_FFD43C).w
	bge.w	.F8822
	subi.w	#$50,(word_FFD43C).w
.F8822
	subq.w	#1,(word_FFD43C).w
	bmi.w	.F8862
	cmpi.w	#$52,(word_FFD43C).w
	bne.w	.F8860
	bclr	#2,(word_FFD42E).w
	bclr	#3,(word_FFD42E).w
	bchg	#1,(word_FFD42E).w
	st	(word_FFD42A).w
	st	(word_FFD42C).w
	bclr	#6,(word_FFD42E).w
	bclr	#7,(word_FFD42E).w
	jsr	(sub_F8868).l
.F8860
	rts
.F8862
	jmp	sub_F87D2
sub_F8868	;94 only. Draw a player card on one side (word_FFD42E bit 1: visitors on the left, else home on the right): erase the team block, a
	;logo box, the picture of featured player word_FFD43E (0-5, from the loc_F92F0+4 list of the team; next one after each visitors card), a
	;framed box with the player's number and name, and with SRAM his user records (sub_F98C6, sub_F9A64, sub_F9AAC; not matched yet). IDA ends the
	;routine at the last printz; the rest is IDA code with no label. Called from sub_F87EA
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	$FF,0,0	;IDA: ori.b x3
	move.w	#$1C,(printx).w	;IDA hid this in the string
	btst	#1,(word_FFD42E).w
	bne.w	.F888E
	move.w	#3,(printx).w
.F888E
	move.w	#5,(printy).w
	move.w	#8,d0
	move.w	#8,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	jsr	(printz).l
	String	$FF,0,0	;IDA: ori.b x3
	move.w	#3,(printx).w	;IDA hid this in the string
	btst	#1,(word_FFD42E).w
	bne.w	.F88C8
	move.w	#$B,(printx).w
.F88C8
	move.w	#5,(printy).w
	move.w	#$19,d0
	move.w	#8,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	btst	#1,(word_FFD42E).w
	bne.w	.F88F2
	bsr.w	sub_F8762
	bra.w	.F88FA
.F88F2
	bsr.w	sub_F877E
	addq.w	#1,(word_FFD43E).w
.F88FA
	jsr	(printz).l
	String	$FF,0,0	;IDA: ori.b x3 / add.b
	cmpi.w	#6,(word_FFD43E).l	;IDA hid this in the string
	blt.w	.F8916
	clr.w	(word_FFD43E).w
.F8916
	move.w	(HomeTeam).w,d0
	move.w	#$1D,(printx).w
	btst	#1,(word_FFD42E).w
	beq.w	.F8934
	move.w	(VisTeam).w,d0
	move.w	#4,(printx).w
.F8934
	move.w	#6,(printy).w
	move.w	(word_FFD430).w,d4
	move.w	(word_FFD43E).w,d3
	mulu.w	#6,d3
	asl.w	#2,d0
	movea.l	#(loc_F92F0+4),a0	;pictures of each team: picture.l, roster index.w entries
	movea.l	0(a0,d0.w),a0
	move.w	4(a0,d3.w),(word_FFD434).w	;roster index
	movea.l	0(a0,d3.w),a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	movea.l	#unk_C63F8,a0	;palette from unk_C63F8
	adda.l	(a0),a0
	tst.l	(a2)	;no map: the unk_C63F8 one
	bne.w	.F8980
	movea.l	#unk_C63F8,a1
	adda.l	4(a1),a1
	tst.l	(a2)+
	bra.w	.F8982
.F8980
	adda.l	(a2)+,a1
.F8982
	bsr.w	sub_FE98A
	movea.l	#$FFFFDA1E,a2	;tiles
	move.w	(vcount).w,d3
.F8990
	cmp.w	(vcount).w,d3
	beq.s	.F8990
	move.w	#6,d3
	move.w	#6,d2
	clr.w	d0
	clr.w	d1
	move.l	(dword_FFBD4A).w,-(sp)
	move.l	(dword_FFBD4E).w,-(sp)
	move.w	#2,d5
	jsr	(dobitmap).l
	move.l	(sp)+,(dword_FFBD4E).w
	move.l	(sp)+,(dword_FFBD4A).w
	jsr	(printz).l
	String	$BF,0,0	;IDA dc.b (IDA ends the routine here)
	move.w	#$6000,(printa).w
	move.w	#3,(printx).w
	move.w	#$19,d0
	btst	#1,(word_FFD42E).w
	beq.w	.F89EC
	move.w	#$B,(printx).w
	move.w	#$19,d0
.F89EC
	move.w	#5,(printy).w
	move.w	#8,d1
	move.w	(printx).w,(word_FFD442).w
	addq.w	#1,(word_FFD442).w
	move.w	(printy).w,(word_FFD444).w
	addq.w	#1,(word_FFD444).w
	jsr	(Framer).l	;25 x 8 box
	move.w	(word_FFD442).w,(printx).w
	move.w	(word_FFD444).w,(printy).w
	move.w	#0,(printa).w
	move.w	#0,(printm).w
	move.w	(HomeTeam).w,d0
	btst	#1,(word_FFD42E).w
	beq.w	.F8A3A
	move.w	(VisTeam).w,d0
.F8A3A
	move.w	d0,(word_FFD446).w
	movea.l	#TeamList,a2
	asl.w	#2,d0
	movea.l	0(a2,d0.w),a2
	adda.w	(a2),a2
	move.w	(word_FFD434).w,d0
	bra.w	.F8A58
.F8A54
	adda.w	(a2),a2
	addq.w	#8,a2
.F8A58
	dbf	d0,.F8A54
	movea.l	#mesarea,a3
	lea	2(a3),a1
	move.w	#6,(a3)
	move.l	a2,-(sp)
	adda.w	(a2),a2
	move.b	(a2),d0
	ext.w	d0
	jsr	(d0toascii).l	;uniform number
	move.w	#$2000,4(a3)
	movea.l	(sp)+,a1
	jsr	(appstring).l	;and the name
	movea.l	a3,a1
	bset	#3,(word_FFC2F8).w
	jsr	(print2).l
	bclr	#3,(word_FFC2F8).w
	movea.l	#mesarea,a1
	move.w	(word_FFD446).w,d0
	move.w	(word_FFD434).w,d1
	tst.w	(ValidSRAM).w	;no SRAM: no records
	bmi.w	.F8B4E
	jsr	(sub_F98C6).l
	cmpi.w	#2,(a1)
	beq.w	.F8B4E
	move.w	(word_FFD442).w,(printx).w
	addq.w	#2,(printy).w
	bset	#3,(word_FFC2F8).w
	jsr	(print2).l
	bclr	#3,(word_FFC2F8).w
	movea.l	#mesarea,a1
	move.w	(word_FFD446).w,d0
	move.w	(word_FFD434).w,d1
	movea.l	#M68K_RAM,a0
	jsr	(sub_F9A64).l
	move.w	(word_FFD442).w,(printx).w
	cmpi.w	#2,(a1)
	beq.w	.F8B18
	addq.w	#1,(printy).w
	bset	#3,(word_FFC2F8).w
	jsr	(print2).l
	bclr	#3,(word_FFC2F8).w
.F8B18
	movea.l	#mesarea,a1
	move.w	(word_FFD446).w,d0
	move.w	(word_FFD434).w,d1
	movea.l	#M68K_RAM,a0
	jsr	(sub_F9AAC).l
	move.w	(word_FFD442).w,(printx).w
	addq.w	#1,(printy).w
	bset	#3,(word_FFC2F8).w
	jsr	(print2).l
	bclr	#3,(word_FFC2F8).w
.F8B4E
	move.w	#$64,(palcount).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
