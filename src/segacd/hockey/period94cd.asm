ClampPositionBox						;Unreferenced. Clamp temp3 / temp4(a3) to the box for position(a3) in
									;PositionBoxes (PositionBoxesTop when bit 7 of
									;pflags(a3), the top net)
	movem.l	d0-d7/a0,-(sp)
	move.w	position(a3),d7
	subi.w	#$1,d7		;position 1 is entry 0
	movea.l	#$292E2,a0
	btst	#pfgoal,$62(a3)		;which net?
	beq.w	.0
	movea.l	#$292F2,a0
.0	add.w	d7,d7		;word per position
	move.w	(a0,d7.w),d0		;X min of the box
	cmp.w	temp3(a3),d0
	blt.w	.1
	move.w	d0,temp3(a3)		;clamp to the left
.1	move.w	$2(a0,d7.w),d0		;X max of the box
	cmp.w	temp3(a3),d0
	bgt.w	.2
	move.w	d0,temp3(a3)		;clamp to the right
.2	move.w	$4(a0,d7.w),d0		;Y min of the box
	cmp.w	temp4(a3),d0
	blt.w	.3
	move.w	d0,temp4(a3)		;clamp to the bottom
.3	move.w	$6(a0,d7.w),d0		;Y max of the box
	cmp.w	temp4(a3),d0
	bgt.w	.x
	move.w	d0,temp4(a3)		;clamp to the top
.x	movem.l	(sp)+,d0-d7/a0
	rts
; Position limits
ClampPositionBoxFirstLimits	dc.w	$FFB5,$0000,$0000,$0108,$0000,$004B,$0000,$0108
; Position limits
ClampPositionBoxSecondLimits	dc.w	$FFB5,$0000,$FEF8,$0000,$0000,$004B,$FEF8,$0000
; Clears the position box state and the team struct area.
ClearGameStats
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#shootoutstate,a0
	move.l	#$12,d0
.loop	clr.w	(a0)+
	dbra	d0,.loop
	movea.l	#tmstruct,a0
	move.w	#$365,d0
.loop2	clr.w	(a0)+
	dbra	d0,.loop2
	movea.l	#PenBuf,a0
	move.l	#$24,d0
.loop3	clr.w	(a0)+
	dbra	d0,.loop3
	clr.w	(BA_PS_flags).l
	clr.w	(sflags4).l
	clr.w	(sflags6).l
	clr.w	(gmode2).l
	clr.w	(setupcardflags).l
	clr.w	(featuredplayer).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
AddArenaAnimSprite						;Add the frame arenaframe of the arena animation (sprite list
									;arenaspritelist, see RunArenaAnim) to the sprite table a6 (d6 sprites, 64
									;at most) for the pieces inside the view (Hpos / Vpos). Not in a reverse
									;angle replay (sflags4 bit 4), sflags2 bit 3 or sflags bit 7. Called from
									;setvideo
	tst.w	(arenaanim).l
	bmi.w	AddArenaAnimSpriteExit
	tst.l	(arenaspritelist).l
	beq.w	AddArenaAnimSpriteExit		;not loaded: none
	btst	#$4,(sflags4).l		;check if reverse angle replay
	bne.w	AddArenaAnimSpriteExit
	btst	#sf2replay,(sflags2).l
	bne.w	AddArenaAnimSpriteExit		;replay: none
	btst	#sfhor,(sflags).l
	bne.w	AddArenaAnimSpriteExit		;horizontal mode: none
	movea.l	(arenaspritelist).l,a1
	adda.l	jimdata(a1),a1
	move.w	(Hpos).l,d4
	move.w	(Vpos).l,d5
	move.w	(arenaframe).l,d0
	bra.w	.spr
	andi.w	#$F,d2
	cmpi.w	#$3,d2
	bls.w	.0
	moveq	#$3,d2
.0	bra.w	.next2
.loop	move.w	d3,d0
	add.w	d2,d0
	dc.w	$6100,$0008		; bsr.w X_293DC
.next2	dbra	d2,.loop
	rts	
.spr
	ext.w	d0
	beq.w	AddArenaAnimSpriteExit
	cmpi.w	#$40,d6
	bge.w	AddArenaAnimSpriteExit
	movem.l	d0-d5,-(sp)
	add.w	d0,d0
	movea.l	a1,a0
	move.w	$2(a0,d0.w),d1
	sub.w	(a0,d0.w),d1
	lsr.w	#$3,d1
	subi.w	#$1,d1
	move.w	d1,-(sp)
	adda.w	(a0,d0.w),a0
	move.w	d4,d0
	addi.w	#$C0,d0
	move.w	d0,d1
	subi.w	#$90,d0
	addi.w	#$80,d1
	move.w	#$170,d2
	sub.w	d5,d2
	move.w	d2,d3
	subi.w	#$80,d2
	addi.w	#$70,d3
	move.w	(sp)+,d4
.loop2	cmp.w	seY(a0),d2
	bgt.w	.next4
	cmp.w	seY(a0),d3
	blt.w	.next4
	cmp.w	(a0),d0
	bgt.w	.next4
	cmp.w	(a0),d1
	blt.w	.next4
	move.w	seY(a0),d5
	addi.w	#$70,d5
	sub.w	d2,d5
	move.w	d5,(a6)+
	move.b	seSize(a0),(a6)+
	move.b	d6,(a6)+
	move.w	seAttr(a0),d5
	andi.w	#$F800,d5
	add.w	seTile(a0),d5
	add.w	(arenaanimchars).l,d5
	move.w	d5,(a6)+
	move.w	(a0),d5
	addi.w	#$70,d5
	sub.w	d0,d5
	move.w	d5,(a6)+
	addi.w	#$1,d6
	cmpi.w	#$40,d6
	beq.w	.x
.next4	adda.w	#$8,a0
	dbra	d4,.loop2
.x	movem.l	(sp)+,d0-d5
AddArenaAnimSpriteExit
	rts
PrintPlayerNameRight						;Print the name of player d0 of team a2 (FormatPlayerName), moved left so
									;it ends before column $29 (a trailing pad byte or
									;two not counted), then the icon of HotColdIcon. Called from
									;PrintMatchupRatings
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	d0,(iconplayer).l
	move.l	a2,-(sp)
	jsr	(FormatPlayerName).l
	movea.l	a1,a0
	move.w	(a0),d0
	move.w	d0,d5
	tst.b	-$1(a0,d5.w)		;trailing pad byte?
	bne.w	.0
	subi.w	#$1,d0		;first pad byte
	tst.b	-$2(a0,d5.w)		;second pad byte?
	bne.w	.0
	subi.w	#$1,d0		;second pad byte
.0	add.w	(printx).l,d0
	subi.w	#$29,d0		;past column $29?
	bmi.w	.1		;fits: leave printx
	neg.w	d0
	add.w	d0,(printx).l
.1	movea.l	a0,a1
	jsr	(print).l
	movea.l	(sp)+,a2
	jsr	(HotColdIcon).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

SkipNameNumber						;Unreferenced. A1 = the FormatPlayerNumInitial String without its first 2
	
	movem.l	d0-d7/a0/a2-a3,-(sp)
	jsr	(FormatPlayerNumInitial).l
	move.w	(a1),d0
	subi.w	#$2,d0
	move.w	d0,$2(a1)
	adda.w	#$2,a1
	movem.l	(sp)+,d0-d7/a0/a2-a3
	rts
; "Period Stats" screen: loads the team logos from the disc and draws the shots / goals table
SkipNameNumber_1A	dc.w	$0006,$202E
	move.l	d0,d0
	movem.l	d0-d7/a0-a6,-(sp)
	movem.l	d7/a0,-(sp)
	movea.l	$47D24.l,a0
	move.w	#$2,d7
	jsr	$6044.w
	movem.l	(sp)+,d7/a0
	move.l	a6,-(sp)
	movea.l	(DiscDmaListPtr).l,a6
	btst.b	#$5,$FF800F.l
	beq.b	.next
	move.w	#$1,-(a6)
	bra.b	.next2
.next	move.w	#$0,-(a6)
.next2	bclr.b	#$5,$FF800F.l
	move.l	a6,(DiscDmaListPtr).l
	movea.l	(sp)+,a6
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$4,d0
	jsr	$6044.w
	move.l	a0,$47D8C.l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	move.l	a6,-(sp)
	movea.l	(DiscDmaListPtr).l,a6
	tst.w	(a6)+
	beq.b	.next3
	bset.b	#$5,$FF800F.l
	bra.b	.next4
.next3	bclr.b	#$5,$FF800F.l
.next4	move.l	a6,(DiscDmaListPtr).l
	movea.l	(sp)+,a6
	move.w	#$2,d0
	jsr	$5F22.w
	move.w	#$2,d0
	jsr	$5F22.w
.loop	move.w	#$80,d0
	jsr	$5F22.w
	bcs.w	.loop
.loop2	move.w	#$81,d0
	jsr	$5F22.w
	move.w	(a0),d2
	andi.w	#$FF00,d2
	cmpi.w	#$0,d2
	bne.s	.loop2
	move.w	#$5,(CdCommandArg).l
	move.w	#$13,d0
	lea.l	(CdCommandArg).l,a0
	jsr	$5F22.w
	jsr	(RelocateLogoBitmaps).l
	clr.w	(matchup).l
	moveq	#$0,d0
	moveq	#$1C,d1
	jsr	(SetupScreen).l
	jsr	(printz).l
; Inline data read by $38F6E from the return address (1 row).
	dc.b	$00,$06,$BE,$01,$0B,$00	; ......
	move.w	#$8,d0
	move.w	#$8,d1
	jsr	(Framer).l
	jsr	(printz).l
; Inline data read by $38F6E from the return address (1 row).
	dc.b	$00,$06,$BE,$01,$13,$00	; ......
	move.w	#$8,d0
	move.w	#$8,d1
	jsr	(Framer).l
	jsr	(printz).l
; Inline data read by $38F6E from the return address (1 row).
	dc.b	$00,$06,$9E,$02,$0C,$00	; ......
	movea.l	$47D8C.l,a0
	move.w	(VisTeam).l,d0
	asl.w	#$2,d0
	movea.l	(a0,d0.w),a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	asl.w	#$3,d0
	movea.l	#TeamLogoPalettes,a0
	subi.w	#$40,d0
	adda.w	d0,a0
	adda.l	(a2)+,a1
	clr.l	d1
	clr.l	d0
	moveq	#$6,d2
	move.w	#$6,d3
	moveq	#$4,d5
	jsr	(dobitmap).l
	movea.l	#$BBCF0,a0
	movea.l	#$BBD10,a1
	move.w	#$7,d0
.loop3	move.l	(a0)+,(a1)+
	dbra	d0,.loop3
	jsr	(printz).l
; Inline data read by $38F6E from the return address (1 row).
	dc.b	$00,$06,$8E,$02,$14,$00	; ......
	movea.l	$47D8C.l,a0
	move.w	(HomeTeam).l,d0
	asl.w	#$2,d0
	movea.l	(a0,d0.w),a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	asl.w	#$3,d0
	subi.w	#$40,d0
	movea.l	#TeamLogoPalettes,a0
	adda.w	d0,a0
	adda.l	(a2)+,a1
	clr.w	d1
	clr.w	d0
	moveq	#$6,d2
	move.w	#$6,d3
	moveq	#$4,d5
	jsr	(dobitmap).l
	jsr	(printz).l
; Inline data read by $38F6E from the return address (1 row).
	dc.b	$00,$06,$BD,$04,$01,$00	; ......
	moveq	#$20,d0
	moveq	#$6,d1
	jsr	(Framer).l
	jsr	(printbigz).l
; Inline data read by $39258 from the return address (2 rows).
	dc.b	$00,$18,$BD,$06,$03,$20,$20,$50,$65,$72,$69,$6F,$64,$20,$53,$74	; .....  Period St
	dc.b	$61,$74,$73,$20,$20,$BE,$06,$01	; ats  ...
	btst.b	#$1,(sflags7).l
	beq.w	PeriodStatsHeader
	jsr	(printz).l
; Inline data read by $38F6E from the return address (2 rows).
	dc.b	$00,$1C,$BE,$0C,$09,$31,$BE,$11,$09,$32,$BE,$16,$09,$33,$BE,$1A	; .....1...2...3..
	dc.b	$09,$4F,$54,$BE,$20,$09,$54,$6F,$74,$61,$6C,$00	; .OT. .Total.
	jsr	(printz).l
; Inline data read by $38F6E from the return address (2 rows).
	dc.b	$00,$1C,$BE,$0C,$0A,$3C,$BE,$11,$0A,$3C,$BE,$16,$0A,$3C,$BE,$1A	; .....<...<...<..
	dc.b	$0A,$3C,$3C,$BE,$20,$0A,$3C,$3C,$3C,$3C,$3C,$00	; .<<. .<<<<<.
	bra.w	PeriodStatsLoop
; Period stats: prints the period column heads (1, 2, 3 ... Total)
PeriodStatsHeader	jsr	(printz).l
; Inline data read by $38F6E from the return address (2 rows).
	dc.b	$00,$16,$BE,$0C,$09,$31,$BE,$11,$09,$32,$BE,$16,$09,$33,$BE,$20	; .....1...2...3. 
	dc.b	$09,$54,$6F,$74,$61,$6C	; .Total
	jsr	(printz).l
; Inline data read by $38F6E from the return address (2 rows).
	dc.b	$00,$16,$BE,$0C,$0A,$3C,$BE,$11,$0A,$3C,$BE,$16,$0A,$3C,$BE,$20	; .....<...<...<. 
	dc.b	$0A,$3C,$3C,$3C,$3C,$3C	; .<<<<<
; Period stats: draws the title and rows, then waits for a button
PeriodStatsLoop	bsr.w	PeriodStatsTitleShots
	bsr.w	PeriodStatsTeamRows
	move.w	#$18,(palcount).l
.loop	jsr	(Pausemode_rjoy).l
	btst	#$7,d1
	bne.w	.next3
	btst	#$2,d1
	bne.w	.next2
	btst	#$3,d1
	bne.w	.next
	bra.w	.loop
.next	tst.w	(matchup).l
	bne.w	.loop
	st.b	(matchup).l
	bsr.w	PeriodStatsTitleShots
	bsr.w	PeriodStatsTeamRows
	bra.w	.loop
.next2	tst.w	(matchup).l
	beq.w	.loop
	clr.w	(matchup).l
	bsr.w	PeriodStatsTitleShots
	bsr.w	PeriodStatsTeamRows
	bra.w	.loop
.next3	movem.l	(sp)+,d0-d7/a0-a6
	movem.l	d7/a0,-(sp)
	movea.l	$47D8C.l,a0
	move.w	#$2,d7
	jsr	$6044.w
	movem.l	(sp)+,d7/a0
	move.l	a6,-(sp)
	movea.l	(DiscDmaListPtr).l,a6
	btst.b	#$5,$FF800F.l
	beq.b	.next4
	move.w	#$1,-(a6)
	bra.b	.next5
.next4	move.w	#$0,-(a6)
.next5	bclr.b	#$5,$FF800F.l
	move.l	a6,(DiscDmaListPtr).l
	movea.l	(sp)+,a6
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$2,d0
	jsr	$6044.w
	move.l	a0,$47D24.l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	move.l	a6,-(sp)
	movea.l	(DiscDmaListPtr).l,a6
	tst.w	(a6)+
	beq.b	.next6
	bset.b	#$5,$FF800F.l
	bra.b	.next7
.next6	bclr.b	#$5,$FF800F.l
.next7	move.l	a6,(DiscDmaListPtr).l
	movea.l	(sp)+,a6
	move.w	#$2,d0
	jsr	$5F22.w
.loop2	move.w	#$80,d0
	jsr	$5F22.w
	bcs.w	.loop2
.loop3	move.w	#$81,d0
	jsr	$5F22.w
	move.w	(a0),d2
	andi.w	#$FF00,d2
	cmpi.w	#$0,d2
	bne.s	.loop3
	move.w	#$5,(CdCommandArg).l
	move.w	#$13,d0
	lea.l	(CdCommandArg).l,a0
	jsr	$5F22.w
	jmp	(StatsScreenFadeIn).l
; Period stats: title when the table shows shots (Shots [ For Goals ])
PeriodStatsTitleShots	tst.w	(matchup).l
	beq.w	PeriodStatsTitleGoals
	jsr	(printz).l
; Inline data read by $38F6E from the return address (2 rows).
	dc.b	$00,$18,$BE,$12,$07,$53,$68,$6F,$74,$73,$BE,$0F,$1A,$5B,$20,$46	; .....Shots...[ F
	dc.b	$6F,$72,$20,$47,$6F,$61,$6C,$73	; or Goals
	rts
; Period stats: title when the table shows goals (Goals [ For Shots ])
PeriodStatsTitleGoals	jsr	(printz).l
; Inline data read by $38F6E from the return address (2 rows).
	dc.b	$00,$18,$BE,$12,$07,$47,$6F,$61,$6C,$73,$BE,$0F,$1A,$46,$6F,$72	; .....Goals...For
	dc.b	$20,$53,$68,$6F,$74,$73,$20,$5D	;  Shots ]
	rts
; Period stats: team rows of the table
PeriodStatsTeamRows	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
; Inline data read by $38F6E from the return address (1 row).
	dc.b	$00,$06,$BE,$00,$00,$00	; ......
	movea.l	#awtmstruct,a2
	move.w	#$E,(printy).l
	bsr.w	PeriodStatsPeriodRow
	movea.l	#tmstruct,a2
	move.w	#$16,(printy).l
	bsr.w	PeriodStatsPeriodRow
	movem.l	(sp)+,d0-d7/a0-a6
	rts
; Period stats: one row, a0 = the period counts of a team
PeriodStatsPeriodRow	lea.l	$344(a2),a0
	tst.w	(matchup).l
	beq.w	.next
	lea.l	$34C(a2),a0
.next	clr.w	(matchuptimer).l
	move.w	#$B,(printx).l
	bsr.w	PeriodStatsPrintTotal
	cmpi.w	#$1,(gsp).l
	blt.w	.next2
	move.w	#$10,(printx).l
	bsr.w	PeriodStatsPrintTotal
	cmpi.w	#$2,(gsp).l
	blt.w	.next2
	move.w	#$15,(printx).l
	bsr.w	PeriodStatsPrintTotal
	cmpi.w	#$3,(gsp).l
	blt.w	.next2
	btst.b	#$1,(sflags7).l
	beq.w	.next2
	move.w	#$1A,(printx).l
	bsr.w	PeriodStatsPrintTotal
.next2	move.w	#$21,(printx).l
	jsr	(printz).l
; Inline data read by $38F6E from the return address (1 row).
	dc.b	$00,$06,$20,$20,$20,$00	; ..   .
	subi.w	#$3,(printx).l
	move.w	(matchuptimer).l,d0
	move.w	#$2,d1
	cmpi.w	#$64,d0
	blt.w	.next3
	move.w	#$3,d1
.next3	jsr	(PushNumberWidth).l
	jsr	(print).l
	rts
; Period stats: adds a count to the total and prints it
PeriodStatsPrintTotal	move.w	(a0)+,d0
	add.w	d0,(matchuptimer).l
	jsr	(printz).l
; Inline data read by $38F6E from the return address (1 row).
	dc.b	$00,$06,$20,$20,$20,$00	; ..   .
	subi.w	#$3,(printx).l
	move.w	#$2,d1
	cmpi.w	#$64,d0
	blt.w	.next
	move.w	#$3,d1
.next	jsr	(PushNumberWidth).l
	jmp	(print).l
StatsReport						;"Game Statistics" menu item (menu lists): both
	
	
	
	moveq	#$9,d0
	moveq	#$1A,d1
	jsr	(SetupScreen).l
	jsr	(printz).l
	String	CC_Font3Pri,$4,$1
	moveq	#$20,d0
	moveq	#$6,d1
	jsr	(Framer).l
	jsr	(printbigz).l
	String	CC_Font3Pri,$6,$4,'Game  Statistics',CC_Font3Pri,$7,$1
	move.w	#$2C,d0
	jsr	(PutTeamBlock).l
	addi.w	#$4,(printx).l
	clr.w	d0
	jsr	(PutTeamBlock).l
	clr.w	(scoutcolumn).l
	clr.w	(VertLineScrolling).l
	clr.w	(PlayerScrollCtr).l
	move.w	#$70,(matchupvis).l
	tst.w	(OptPen).l
	bne.w	.0
	move.w	#$30,(matchupvis).l
.0	bsr.w	DisplayStats
	bsr.w	PrintStatScrollArrows
.loop	jsr	(MenuWaitVblank).l
	jsr	(ReadActiveJoypad).l
	btst	#$7,d3
	beq.w	.1
	jmp	(StatsScreenFadeIn).l
.1	jsr	(nodiag).l
	move.w	#$FFFE,d0
	btst	#$0,d3
	bne.w	.2
	neg.w	d0
	btst	#$1,d3
	beq.w	.3
.2	move.w	d0,(PlayerScrollCtr).l
.3	bsr.w	.scroll
	bsr.w	PrintStatScrollArrows
	bra.w	.loop
.scroll	move.w	(PlayerScrollCtr).l,d0
	beq.w	rtsStatTables
	add.w	(VertLineScrolling).l,d0
	bmi.w	rtsStatTables
	cmp.w	(matchupvis).l,d0
	bgt.w	rtsStatTables
	move.w	(VertLineScrolling).l,d1
	move.w	d0,(VertLineScrolling).l
	andi.w	#$F,d0
	bne.w	.5
	clr.w	(PlayerScrollCtr).l
.5	andi.w	#$F,d1
	bne.w	StatsReportBlitSetup
	move.w	d0,-(sp)
	cmpi.w	#$E,d0
	bne.w	.6
	bsr.w	StatScrollRow
.6	move.w	(sp)+,d0
	cmpi.w	#$2,d0
	bne.w	StatsReportBlitSetup
	bsr.w	StatScrollRowEnd
; Sets up the VDP DMA write for the stats report.
StatsReportBlitSetup	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movea.l	#$C00000,a0
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.l	#$40020010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	move.w	#$FFB0,d0
	add.w	(VertLineScrolling).l,d0
.loop4	btst	#$7,$FF800E.l
	bne.b	.loop4
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset	#$6,$FF800F.l
.loop5	btst	#$6,$FF800E.l
	beq.b	.loop5
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop6	btst	#$6,$FF800E.l
	bne.b	.loop6
	bclr	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	rts
StatScrollRow	move.w	(VertLineScrolling).l,d3
	lsr.w	#$4,d3
	bra.w	StatScrollRowExit
StatScrollRowEnd	move.w	(VertLineScrolling).l,d3
	lsr.w	#$4,d3
	addi.w	#$6,d3
	bra.w	StatScrollRowExit
; Return of StatScrollRowEnd
StatScrollRowExit	rts
; Prints the stats scroll header.
PrintStatScrollArrows	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printsmallz).l
	String	CC_SetFont,$1
	tst.w	(VertLineScrolling).l
	beq.w	.next
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,$26,$8,CC_SetFont,$1,'{'
	bra.w	.next2
.next	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,$26,$8,CC_SetFont,$1,' '
.next2	move.w	(matchupvis).l,d0
	cmp.w	(VertLineScrolling).l,d0
	beq.w	.next3
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,$26,$1A,CC_SetFont,$1,'}'
	bra.w	.next4
.next3	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,$26,$1A,CC_SetFont,$1,' '
.next4	jsr	(printsmallz).l
	String	CC_SetFont
	movem.l	(sp)+,d0-d7/a0-a6
	rts
DisplayStats						;Team logos (PutTeamBlock), then each
	
	
	
	jsr	(printz).l
	String	CC_Font3Pri,$2,$7
	move.w	#$2C,d0
	jsr	(PutTeamBlock).l
	jsr	(printz).l
	String	CC_Font3Pri,$1A,$7
	moveq	#$0,d0
	jsr	(PutTeamBlock).l
	bsr.w	StatsReportBlitSetup
	jsr	(printz).l
	String	CC_Font2Pri,$0,$0
	moveq	#$E,d6
	dc.w	$43FA,$015A		; lea.l X_29E56(pc),a1
	tst.w	(OptPen).l
	bne.w	.row
	move.w	#$A,d6
	dc.w	$43FA,$0236		; lea.l X_29F44(pc),a1
.row	move.w	(a1),d0
	lsr.w	#$1,d0
	neg.w	d0
	addi.w	#$15,d0
	move.w	d0,(printx).l
	jsr	(print).l
	movea.l	a1,a0
	move.w	#$22,(printx).l
	movea.l	#tmstruct,a2
	bsr.w	PrintStatValue
	move.w	#$9,(printx).l
	lea.l	$366(a2),a2
	bsr.w	PrintStatValue
	lea.l	$4(a0),a1
	addi.w	#$2,(printy).l		;2 map rows per table row
	dbra	d6,.row
	rts
PrintStatValue						;Print TeamStatTextTbl entry a0 for team a2 centred at printx: the value
	
	
	
	movea.l	#mesarea,a3
	move.w	#$2,(a3)
	cmpi.w	#$FFFF,(a0)
	bne.w	.1
	move.w	#tmscore,d0
	move.w	(a2,d0.w),d0
	mulu.w	#$64,d0
	move.w	#$0,d1
	move.w	(a2,d1.w),d1
	beq.w	.0
	divu.w	d1,d0
.0	jsr	(PushNumber).l
	jsr	(appstring).l
	jsr	(appendz).l
	String	'%'
	bra.w	.6
.1	move.w	(a0),d0
	move.w	(a2,d0.w),d0
	cmpi.w	#$354,(a0)
	bne.w	.2
	bsr.w	.8
	bra.w	.4
.2	cmpi.w	#$A,(a0)
	beq.w	.3
	bsr.w	.7
.3	cmpi.w	#$A,(a0)
	bne.w	.4
	bsr.w	.8
.4	jsr	(appstring).l
	move.w	$2(a0),d0
	bmi.w	.6
	jsr	(appendz).l
	String	'/'
	move.w	(a2,d0.w),d0
	jsr	(PushNumber).l
	jsr	(appstring).l
	cmpi.w	#$14,(a0)
	bne.w	.6
	jsr	(appendz).l
	String	' ('
	move.w	(a0),d0
	move.w	(a2,d0.w),d0
	mulu.w	#$64,d0
	move.w	$2(a0),d1
	move.w	(a2,d1.w),d1
	beq.w	.5
	divu.w	d1,d0
.5	jsr	(PushNumber).l
	jsr	(appstring).l
	jsr	(appendz).l
	String	'%)'
.6	movea.l	a3,a1
	move.w	(a1),d0
	lsr.w	#$1,d0
	sub.w	d0,(printx).l
	jmp	(print).l
.7	jmp	(PushNumber).l
.8	jmp	(PushTime).l
TeamStatTextTbl						;Label, then the team struct stat offset and the second offset ($FFFF
									;none). 15 rows
	String	'Score'
; Instruction bytes inside TeamStatTextTbl that the assembler would encode differently, kept as words (1 row).
	dc.b	$00,$0C,$FF,$FF
	String	'Shots'
; Instruction bytes inside TeamStatTextTbl that the assembler would encode differently, kept as words (1 row).
	dc.b	$00,$00,$FF,$FF
	String	'Shooting Pct'
	dc.w	$FFFF		; dc.w $FFFF
	dc.w	$FFFF		; dc.w $FFFF
	String	'Power Play'
	dc.w	$0002,$0004		; ori.b #$4,d2
	String	'PP Minutes'
	dc.w	$0354		; bchg.b d1,(a4)
	dc.w	$FFFF		; dc.w $FFFF
	String	'PP Shots'
	dc.w	$0356		; bchg.b d1,(a6)
	dc.w	$FFFF		; dc.w $FFFF
	String	'SH Goals'
	dc.w	$0358		; bchg.b d1,(a0)+
	dc.w	$FFFF		; dc.w $FFFF
	String	'Breakaways'
	dc.w	$035C		; bchg.b d1,(a4)+
	dc.w	$035A		; bchg.b d1,(a2)+
	String	'One-Timers'
	dc.w	$0360		; bchg.b d1,-(a0)
	dc.w	$035E		; bchg.b d1,(a6)+
	String	'Penalty Shots'
	dc.w	$0364		; bchg.b d1,-(a4)
	dc.w	$0362		; bchg.b d1,-(a2)
	String	'Faceoffs Won'
; Instruction bytes inside TeamStatTextTbl that the assembler would encode differently, kept as words (1 row).
	dc.b	$00,$0E,$FF,$FF
	String	'Body Checks'
	dc.w	$0010,$FFFF		; ori.b #$FF,(a0)
	String	'Penalties'
	dc.w	$0006,$0008		; ori.b #$8,d6
	String	'Attack Zone'
; Instruction bytes inside TeamStatTextTbl that the assembler would encode differently, kept as words (1 row).
	dc.b	$00,$0A,$FF,$FF
	String	'Passing'
; Instruction bytes inside TeamStatTextTbl that the assembler would encode differently, kept as words (1 row).
	dc.b	$00,$14,$00,$12
TeamStatTextTblNoPen				;The rows without the power play ones, used when penalties are off. 11
									;rows
	String	'Score'
; Instruction bytes inside TeamStatTextTblNoPen that the assembler would encode differently, kept as words (1 row).
	dc.b	$00,$0C,$FF,$FF
	String	'Shots'
; Instruction bytes inside TeamStatTextTblNoPen that the assembler would encode differently, kept as words (1 row).
	dc.b	$00,$00,$FF,$FF
	String	'Shooting Pct'
	dc.w	$FFFF		; dc.w $FFFF
	dc.w	$FFFF		; dc.w $FFFF
	String	'Breakaways'
	dc.w	$035C		; bchg.b d1,(a4)+
	dc.w	$035A		; bchg.b d1,(a2)+
	String	'One-Timers'
	dc.w	$0360		; bchg.b d1,-(a0)
	dc.w	$035E		; bchg.b d1,(a6)+
	String	'Penalty Shots'
	dc.w	$0364		; bchg.b d1,-(a4)
	dc.w	$0362		; bchg.b d1,-(a2)
	String	'Faceoffs Won'
; Instruction bytes inside TeamStatTextTblNoPen that the assembler would encode differently, kept as words (1 row).
	dc.b	$00,$0E,$FF,$FF
	String	'Body Checks'
	dc.w	$0010,$FFFF		; ori.b #$FF,(a0)
	String	'Penalties'
	dc.w	$0006,$0008		; ori.b #$8,d6
	String	'Attack Zone'
; Instruction bytes inside TeamStatTextTblNoPen that the assembler would encode differently, kept as words (1 row).
	dc.b	$00,$0A,$FF,$FF
	String	'Passing'
; Instruction bytes inside TeamStatTextTblNoPen that the assembler would encode differently, kept as words (1 row).
	dc.b	$00,$14,$00,$12
rtsStatTables
	rts
updatePPTeamTime						;One more second of power play time (tmPwrPlayTime) for the team
	
	
	btst	#sf2pwrplay,(sflags2).l
	beq.w	.x
	movea.l	#tmstruct,a2
	btst	#sf2pwrtm,(sflags2).l
	beq.w	.0
	movea.l	#awtmstruct,a2
.0	addi.w	#$1,$354(a2)		;one more second of power play time
.x	rts
GetTeamRating						;d0 = the TeamRatings byte of team tmteam(a2). Called from PrintTeamRating
	
	movem.l	d1-d7/a0-a6,-(sp)
	move.w	tmteam(a2),d0
	movea.l	#$2A040,a0
	clr.w	d1
	move.b	(a0,d0.w),d1
	move.w	d1,d0
	movem.l	(sp)+,d1-d7/a0-a6
	rts
; Data that follows GetTeamRating (strings, small tables)
GetTeamRatingTexts	dc.b	'3LIKNCKC4BJIDBJ7'
	dc.b	'EKG8E8HGHF[Y'
ShortenMsgTimer						;Cap msgtimer at 2, unless a second pad is on (cont2team) and a3 is not
	
	movem.l	d0,-(sp)
	tst.w	(cont2team).l
	beq.w	.0
	move.w	SCnum(a3),d0
	cmp.w	(puckc).l,d0
	bne.w	.x
.0	cmpi.w	#$2,(msgtimer).l
	ble.w	.x
	move.w	#$2,(msgtimer).l
.x	movem.l	(sp)+,d0
	rts
ManualGoalieMenu						;"x Manual Goalie" menu item (menu lists; PrintMenuItem prints Manual /
	
	
	
	
	
	
	movem.l	d0-d7/a0-a6,-(sp)
	tst.w	(OptNOP).l
	beq.w	.chkso
	move.w	(cont1team).l,d0
	cmp.w	(cont2team).l,d0
	bne.w	.0
	eori.w	#$1,(goaliemode2).l
	bra.w	.g1
.0	btst	#sfpj,(sflags).l
	beq.w	.g1
	eori.w	#$1,(goaliemode2).l
	bra.w	.chkso
.g1	eori.w	#$1,(goaliemode1).l
.chkso	btst	#$0,(gmode2).l
	bne.w	.so
	btst	#$2,(BA_PS_flags).l
	beq.w	.x
.so	btst	#sfpj,(sflags).l
	bne.w	.p2
	cmpi.w	#$2,(OptNOP).l
	bne.w	.4
	cmpi.w	#$5,(BA_Sktr_SCnum).l
	bgt.w	.x
	bra.w	.5
.4	cmpi.w	#$5,(BA_Sktr_SCnum).l
	ble.w	.x
.5	move.w	#$0,d0
	cmpi.w	#$2,(OptNOP).l
	bne.w	.6
	move.w	#$6,d0
.6	tst.w	(goaliemode1).l
	bne.w	.set1
	move.w	#$5,d0
	cmpi.w	#$2,(OptNOP).l
	bne.w	.set1
	move.w	#$B,d0
.set1	jsr	(setc1player).l
	bra.w	.x
.p2	cmpi.w	#$2,(OptNOP).l
	bne.w	.9
	cmpi.w	#$5,(BA_Sktr_SCnum).l
	ble.w	.x
	bra.w	.10
.9	cmpi.w	#$5,(BA_Sktr_SCnum).l
	bgt.w	.x
.10	move.w	#$6,d0
	tst.w	(goaliemode2).l
	bne.w	.set2		;manual: the goalie
	move.w	#$B,d0		;skater slot
.set2	jsr	(setc2player).l
.x	movem.l	(sp)+,d0-d7/a0-a6
	rts