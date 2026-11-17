SkipNameNumber						;Unreferenced. A1 = the FormatPlayerNumInitial String without its first 2
	
	movem.l	d0-d7/a0/a2-a3,-(sp)
	jsr	(FormatPlayerNumInitial).l
	move.w	(a1),d0
	subi.w	#$2,d0
	move.w	d0,$2(a1)
	adda.w	#$2,a1
	movem.l	(sp)+,d0-d7/a0/a2-a3
	rts
L29508	dc.w	$0006,$202E
	move.l	d0,d0
	movem.l	d0-d7/a0-a6,-(sp)
	movem.l	d7/a0,-(sp)
	movea.l	$47D24.l,a0
	move.w	#$2,d7
	jsr	$6044.w
	movem.l	(sp)+,d7/a0
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst.b	#$5,$FF800F.l
	beq.b	.next
	move.w	#$1,-(a6)
	bra.b	.next2
.next	move.w	#$0,-(a6)
.next2	bclr.b	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$4,d0
	jsr	$6044.w
	move.l	a0,$47D8C.l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.b	.next3
	bset.b	#$5,$FF800F.l
	bra.b	.next4
.next3	bclr.b	#$5,$FF800F.l
.next4	move.l	a6,$19360.l
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
	move.w	#$5,$19364.l
	move.w	#$13,d0
	lea.l	$19364.l,a0
	jsr	$5F22.w
	jsr	$376D4.l
	clr.w	$1A43A.l
	moveq	#$0,d0
	moveq	#$1C,d1
	jsr	$2E728.l
	jsr	$38F6E.l
	dc.b	$00,$06,$BE,$01,$0B,$00	; ......
L295FC	move.w	#$8,d0
	move.w	#$8,d1
	jsr	$38CA0.l
	jsr	$38F6E.l
	dc.b	$00,$06,$BE,$01,$13,$00	; ......
L29616	move.w	#$8,d0
	move.w	#$8,d1
	jsr	$38CA0.l
	jsr	$38F6E.l
	dc.b	$00,$06,$9E,$02,$0C,$00	; ......
L29630	movea.l	$47D8C.l,a0
	move.w	$17FB0.l,d0
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
	jsr	$387E2.l
	movea.l	#$BBCF0,a0
	movea.l	#$BBD10,a1
	move.w	#$7,d0
.loop	move.l	(a0)+,(a1)+
	dbra	d0,.loop
	jsr	$38F6E.l
	dc.b	$00,$06,$8E,$02,$14,$00	; ......
L2968C	movea.l	$47D8C.l,a0
	move.w	$17FAE.l,d0
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
	jsr	$387E2.l
	jsr	$38F6E.l
	dc.b	$00,$06,$BD,$04,$01,$00	; ......
L296D2	moveq	#$20,d0
	moveq	#$6,d1
	jsr	$38CA0.l
	jsr	$39258.l
	dc.b	$00,$18,$BD,$06,$03,$20,$20,$50,$65,$72,$69,$6F,$64,$20,$53,$74	; .....  Period St
	dc.b	$61,$74,$73,$20,$20,$BE,$06,$01	; ats  ...
L296FA	btst.b	#$1,$17F7A.l
	beq.w	L2974E
	jsr	$38F6E.l
	dc.b	$00,$1C,$BE,$0C,$09,$31,$BE,$11,$09,$32,$BE,$16,$09,$33,$BE,$1A	; .....1...2...3..
	dc.b	$09,$4F,$54,$BE,$20,$09,$54,$6F,$74,$61,$6C,$00	; .OT. .Total.
L29728	jsr	$38F6E.l
	dc.b	$00,$1C,$BE,$0C,$0A,$3C,$BE,$11,$0A,$3C,$BE,$16,$0A,$3C,$BE,$1A	; .....<...<...<..
	dc.b	$0A,$3C,$3C,$BE,$20,$0A,$3C,$3C,$3C,$3C,$3C,$00	; .<<. .<<<<<.
L2974A	bra.w	L29786
L2974E	jsr	$38F6E.l
	dc.b	$00,$16,$BE,$0C,$09,$31,$BE,$11,$09,$32,$BE,$16,$09,$33,$BE,$20	; .....1...2...3. 
	dc.b	$09,$54,$6F,$74,$61,$6C	; .Total
L2976A	jsr	$38F6E.l
	dc.b	$00,$16,$BE,$0C,$0A,$3C,$BE,$11,$0A,$3C,$BE,$16,$0A,$3C,$BE,$20	; .....<...<...<. 
	dc.b	$0A,$3C,$3C,$3C,$3C,$3C	; .<<<<<
L29786	bsr.w	L298BA
	bsr.w	L29904
	move.w	#$18,$18D62.l
.loop	jsr	$2EDE2.l
	btst	#$7,d1
	bne.w	.next3
	btst	#$2,d1
	bne.w	.next2
	btst	#$3,d1
	bne.w	.next
	bra.w	.loop
.next	tst.w	$1A43A.l
	bne.w	.loop
	st.b	$1A43A.l
	bsr.w	L298BA
	bsr.w	L29904
	bra.w	.loop
.next2	tst.w	$1A43A.l
	beq.w	.loop
	clr.w	$1A43A.l
	bsr.w	L298BA
	bsr.w	L29904
	bra.w	.loop
.next3	movem.l	(sp)+,d0-d7/a0-a6
	movem.l	d7/a0,-(sp)
	movea.l	$47D8C.l,a0
	move.w	#$2,d7
	jsr	$6044.w
	movem.l	(sp)+,d7/a0
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst.b	#$5,$FF800F.l
	beq.b	.next4
	move.w	#$1,-(a6)
	bra.b	.next5
.next4	move.w	#$0,-(a6)
.next5	bclr.b	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$2,d0
	jsr	$6044.w
	move.l	a0,$47D24.l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.b	.next6
	bset.b	#$5,$FF800F.l
	bra.b	.next7
.next6	bclr.b	#$5,$FF800F.l
.next7	move.l	a6,$19360.l
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
	move.w	#$5,$19364.l
	move.w	#$13,d0
	lea.l	$19364.l,a0
	jsr	$5F22.w
	jmp	$2E980.l
L298BA	tst.w	$1A43A.l
	beq.w	L298E4
	jsr	$38F6E.l
	dc.b	$00,$18,$BE,$12,$07,$53,$68,$6F,$74,$73,$BE,$0F,$1A,$5B,$20,$46	; .....Shots...[ F
	dc.b	$6F,$72,$20,$47,$6F,$61,$6C,$73	; or Goals
L298E2	rts
L298E4	jsr	$38F6E.l
	dc.b	$00,$18,$BE,$12,$07,$47,$6F,$61,$6C,$73,$BE,$0F,$1A,$46,$6F,$72	; .....Goals...For
	dc.b	$20,$53,$68,$6F,$74,$73,$20,$5D	;  Shots ]
L29902	rts
L29904	movem.l	d0-d7/a0-a6,-(sp)
	jsr	$38F6E.l
	dc.b	$00,$06,$BE,$00,$00,$00	; ......
L29914	movea.l	#$186B2,a2
	move.w	#$E,$18D5A.l
	bsr.w	L2993E
	movea.l	#$1834C,a2
	move.w	#$16,$18D5A.l
	bsr.w	L2993E
	movem.l	(sp)+,d0-d7/a0-a6
	rts
L2993E	lea.l	$344(a2),a0
	tst.w	$1A43A.l
	beq.w	.next
	lea.l	$34C(a2),a0
.next	clr.w	$1A44A.l
	move.w	#$B,$18D58.l
	bsr.w	L299F6
	cmpi.w	#$1,$180E4.l
	blt.w	.next2
	move.w	#$10,$18D58.l
	bsr.w	L299F6
	cmpi.w	#$2,$180E4.l
	blt.w	.next2
	move.w	#$15,$18D58.l
	bsr.w	L299F6
	cmpi.w	#$3,$180E4.l
	blt.w	.next2
	btst.b	#$1,$17F7A.l
	beq.w	.next2
	move.w	#$1A,$18D58.l
	bsr.w	L299F6
.next2	move.w	#$21,$18D58.l
	jsr	$38F6E.l
	dc.b	$00,$06,$20,$20,$20,$00	; ..   .
L299CA	subi.w	#$3,$18D58.l
	move.w	$1A44A.l,d0
	move.w	#$2,d1
	cmpi.w	#$64,d0
	blt.w	.next
	move.w	#$3,d1
.next	jsr	$3919A.l
	jsr	$38F80.l
	rts
L299F6	move.w	(a0)+,d0
	add.w	d0,$1A44A.l
	jsr	$38F6E.l
	dc.b	$00,$06,$20,$20,$20,$00	; ..   .
L29A0A	subi.w	#$3,$18D58.l
	move.w	#$2,d1
	cmpi.w	#$64,d0
	blt.w	.next
	move.w	#$3,d1
.next	jsr	$3919A.l
	jmp	$38F80.l
StatsReport						;"Game Statistics" menu item (menu lists): both
	
	
	
	moveq	#$9,d0
	moveq	#$1A,d1
	jsr	(CrowdMeterFadeIn).l
	jsr	(printz).l
	String	CC_Font3Pri,$4,$1
	moveq	#$20,d0
	moveq	#$6,d1
	jsr	(Framer).l
	jsr	(printbigz).l
	String	CC_Font3Pri,$6,$4,'Game  Statistics',CC_Font3Pri,$7,$1
	move.w	#$2C,d0
	jsr	(PutTeamBlockDraw).l
	addi.w	#$4,(printx).l
	clr.w	d0
	jsr	(PutTeamBlockDraw).l
	clr.w	(scoutcolumn).l
	clr.w	(VertLineScrolling).l
	clr.w	(PlayerScrollCtr).l
	move.w	#$70,(matchupvis).l
	tst.w	$18C08.l
	bne.w	.0
	move.w	#$30,(matchupvis).l
.0	bsr.w	DisplayStats
	bsr.w	StatScrollHeader
.loop	jsr	(MenuWaitVblank).l
	jsr	(ReadActiveJoypad).l
	btst	#$7,d3
	beq.w	.1
	jmp	(CrowdMeterScreenSub2).l
.1	jsr	(nodiag).l
	move.w	#$FFFE,d0
	btst	#$0,d3
	bne.w	.2
	neg.w	d0
	btst	#$1,d3
	beq.w	.3
.2	move.w	d0,(PlayerScrollCtr).l
.3	bsr.w	.scroll
	bsr.w	StatScrollHeader
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
	bra.w	StatScrollRowEnd_1
StatScrollRowEnd	move.w	(VertLineScrolling).l,d3
	lsr.w	#$4,d3
	addi.w	#$6,d3
	bra.w	StatScrollRowEnd_1
StatScrollRowEnd_1	rts
; Prints the stats scroll header.
StatScrollHeader	movem.l	d0-d7/a0-a6,-(sp)
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
	jsr	(PutTeamBlockDraw).l
	jsr	(printz).l
	String	CC_Font3Pri,$1A,$7
	moveq	#$0,d0
	jsr	(PutTeamBlockDraw).l
	bsr.w	StatsReportBlitSetup
	jsr	(printz).l
	String	CC_Font2Pri,$0,$0
	moveq	#$E,d6
	dc.w	$43FA,$015A
	tst.w	$18C08.l
	bne.w	.row
	move.w	#$A,d6
	dc.w	$43FA,$0236
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
	move.w	#$C,d0
	move.w	(a2,d0.w),d0
	mulu.w	#$64,d0
	move.w	#$0,d1
	move.w	(a2,d1.w),d1
	beq.w	.0
	divu.w	d1,d0
.0	jsr	(PushNumber).l
	jsr	(appstring).l
	jsr	(PushNumberWidthString).l
	String	'%'
	bra.w	.6
.1	move.w	(a0),d0
	move.w	(a2,d0.w),d0
	cmpi.w	#$354,(a0)
	bne.w	.2
	bsr.w	.next2
	bra.w	.4
.2	cmpi.w	#$A,(a0)
	beq.w	.3
	bsr.w	.next
.3	cmpi.w	#$A,(a0)
	bne.w	.4
	bsr.w	.next2
.4	jsr	(appstring).l
	move.w	$2(a0),d0
	bmi.w	.6
	jsr	(PushNumberWidthString).l
	String	'/'
	move.w	(a2,d0.w),d0
	jsr	(PushNumber).l
	jsr	(appstring).l
	cmpi.w	#$14,(a0)
	bne.w	.6
	jsr	(PushNumberWidthString).l
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
	jsr	(PushNumberWidthString).l
	String	'%)'
.6	movea.l	a3,a1
	move.w	(a1),d0
	lsr.w	#$1,d0
	sub.w	d0,(printx).l
	jmp	(print).l
.next	jmp	(PushNumber).l
.next2	jmp	(PushTime).l
TeamStatTextTbl						;Label, then the team struct stat offset and the second offset ($FFFF
									;none). 15 rows
	String	'Score'
	dc.b	$00,$0C,$FF,$FF
	String	'Shots'
	dc.b	$00,$00,$FF,$FF
	String	'Shooting Pct'
	dc.w	$FFFF,$FFFF
	String	'Power Play'
	dc.b	$00,$02,$00,$04
	String	'PP Minutes'
	dc.b	$03,$54,$FF,$FF
	String	'PP Shots'
	dc.b	$03,$56,$FF,$FF
	String	'SH Goals'
	dc.b	$03,$58,$FF,$FF
	String	'Breakaways'
	dc.b	$03,$5C,$03,$5A
	String	'One-Timers'
	dc.b	$03,$60,$03,$5E
	String	'Penalty Shots'
	dc.b	$03,$64,$03,$62
	String	'Faceoffs Won'
	dc.b	$00,$0E,$FF,$FF
	String	'Body Checks'
	dc.b	$00,$10,$FF,$FF
	String	'Penalties'
	dc.b	$00,$06,$00,$08
	String	'Attack Zone'
	dc.b	$00,$0A,$FF,$FF
	String	'Passing'
	dc.b	$00,$14,$00,$12
TeamStatTextTblNoPen				;The rows without the power play ones, used when penalties are off. 11
									;rows
	String	'Score'
	dc.b	$00,$0C,$FF,$FF
	String	'Shots'
	dc.b	$00,$00,$FF,$FF
	String	'Shooting Pct'
	dc.w	$FFFF,$FFFF
	String	'Breakaways'
	dc.b	$03,$5C,$03,$5A
	String	'One-Timers'
	dc.b	$03,$60,$03,$5E
	String	'Penalty Shots'
	dc.b	$03,$64,$03,$62
	String	'Faceoffs Won'
	dc.b	$00,$0E,$FF,$FF
	String	'Body Checks'
	dc.b	$00,$10,$FF,$FF
	String	'Penalties'
	dc.b	$00,$06,$00,$08
	String	'Attack Zone'
	dc.b	$00,$0A,$FF,$FF
	String	'Passing'
	dc.b	$00,$14,$00,$12
rtsStatTables
	rts
updatePPTeamTime						;One more second of power play time (tmPwrPlayTime) for the team
	
	
	btst	#$5,$17F6C.l
	beq.w	.x
	movea.l	#tmstruct,a2
	btst	#$6,$17F6C.l
	beq.w	.0
	movea.l	#awtmstruct,a2
.0	addi.w	#$1,$354(a2)		;one more second of power play time
.x	rts
GetTeamRating						;d0 = the TeamRatings byte of team tmteam(a2). Called from PrintTeamRating
	
	movem.l	d1-d7/a0-a6,-(sp)
	move.w	$2A(a2),d0
	movea.l	#$2A040,a0
	clr.w	d1
	move.b	(a0,d0.w),d1
	move.w	d1,d0
	movem.l	(sp)+,d1-d7/a0-a6
	rts
GetTeamRatingStr1	dc.b	'3LIKNCKC4BJIDBJ7'
	dc.b	'EKG8E8HGHF[Y'
ShortenMsgTimer						;Cap msgtimer at 2, unless a second pad is on (cont2team) and a3 is not
	
	movem.l	d0,-(sp)
	tst.w	$17FA8.l
	beq.w	.0
	move.w	$52(a3),d0
	cmp.w	$17BE0.l,d0
	bne.w	.x
.0	cmpi.w	#$2,$17F98.l
	ble.w	.x
	move.w	#$2,$17F98.l
.x	movem.l	(sp)+,d0
	rts
ManualGoalieMenu						;"x Manual Goalie" menu item (menu lists; PrintMenuItem prints Manual /
	
	
	
	
	
	
	movem.l	d0-d7/a0-a6,-(sp)
	tst.w	(OptNOP).l
	beq.w	.chkso
	move.w	$17FA6.l,d0
	cmp.w	$17FA8.l,d0
	bne.w	.0
	eori.w	#$1,$18C0E.l
	bra.w	.next
.0	btst	#$1,$17F6A.l
	beq.w	.next
	eori.w	#$1,$18C0E.l
	bra.w	.chkso
.next	eori.w	#$1,$18C0C.l
.chkso	btst	#$0,$17F78.l
	bne.w	.so
	btst	#$2,$17F70.l
	beq.w	.x
.so	btst	#$1,$17F6A.l
	bne.w	.p2
	cmpi.w	#$2,(OptNOP).l
	bne.w	.next2
	cmpi.w	#$5,$19368.l
	bgt.w	.x
	bra.w	.5
.next2	cmpi.w	#$5,$19368.l
	ble.w	.x
.5	move.w	#$0,d0
	cmpi.w	#$2,(OptNOP).l
	bne.w	.next3
	move.w	#$6,d0
.next3	tst.w	$18C0C.l
	bne.w	.set1
	move.w	#$5,d0
	cmpi.w	#$2,(OptNOP).l
	bne.w	.set1
	move.w	#$B,d0
.set1	jsr	(setc1player).l
	bra.w	.x
.p2	cmpi.w	#$2,(OptNOP).l
	bne.w	.next4
	cmpi.w	#$5,$19368.l
	ble.w	.x
	bra.w	.next5
.next4	cmpi.w	#$5,$19368.l
	bgt.w	.x
.next5	move.w	#$6,d0
	tst.w	$18C0E.l
	bne.w	.set2		;manual: the goalie
	move.w	#$B,d0		;skater slot
.set2	jsr	(setc2player).l
.x	movem.l	(sp)+,d0-d7/a0-a6
	rts
RunArenaAnim						;Run the arena animation arenaanim (negative: none): the first time, its
									;frame list and graphics from ArenaAnims
									;(arenaframelist / arenaspritelist, tiles to VRAM d4 = arenaanimchars:
									;DecompressGraphicsPlain); then count down the frame time arenaframetime
									;by d7 and step (NextArenaFrame). Called from periodicevents and waitxsr
	tst.w	$1A556.l
	bmi.w	.ex
	movem.l	d0-d7/a0-a6,-(sp)
	tst.l	$1A55C.l
	bne.w	.next
	move.w	$1A556.l,d0
	asl.w	#$3,d0
	movea.l	#$2A26C,a0
	move.l	(a0,d0.w),$1A558.l
	move.l	$4(a0,d0.w),$1A55C.l
	movea.l	$4(a0,d0.w),a2
	adda.w	#$8,a2
	move.w	$1A54E.l,d4
	jsr	(DecompressGraphicsPlain).l
	clr.w	$1A552.l
	bsr.w	NextArenaFrame
	bra.w	.next2
.next	sub.w	d7,$1A554.l
	bpl.w	.next2
	addi.w	#$1,$1A552.l
	bsr.w	NextArenaFrame		;read the next frame
.next2	movem.l	(sp)+,d0-d7/a0-a6
.ex	rts
NextArenaFrame						;Read frame arenaframeidx of the list: arenaframe = frame, arenaframetime
									;= time; frame $FF loops to the start, $FE ends the animation
									;(EndArenaAnim)
	movea.l	$1A558.l,a0
	move.w	$1A552.l,d0
	add.w	d0,d0		;2 bytes per entry
	move.b	(a0,d0.w),d1		;frame byte
	ext.w	d1
	move.w	d1,$1A550.l
	move.b	$1(a0,d0.w),d1
	ext.w	d1
	move.w	d1,$1A554.l
	cmpi.w	#$FFFF,$1A550.l
	bne.w	.next
	clr.w	$1A552.l
	bra.w	NextArenaFrame
.next	cmpi.w	#$FFFE,$1A550.l
	bne.w	.ex
	bsr.w	EndArenaAnim		;$FE: end the animation
.ex	rts
	dc.b	$00,$02,$A3,$E4,$00,$04,$3A,$7E,$00,$02,$A3,$98,$00,$04,$42,$A2
	dc.b	$00,$02,$A3,$BE,$00,$04,$42,$A2,$00,$02,$A3,$86,$00,$04,$4F,$A8
	dc.b	$00,$02,$A3,$30,$00,$04,$5A,$16,$00,$02,$A3,$00,$00,$04,$5A,$16
	dc.b	$00,$02,$A2,$EA,$00,$04,$69,$42,$00,$02,$A2,$AC,$00,$04,$69,$42
ArenaFrames1						;ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,$A,2,$A,3,$A,4,$A,5,$A,6,$A,7,$A,8,$A
	dc.b	9,$A,$A,$A,1,$A,2,$A,3,$A,4,$A,5,$A,6,$A
	dc.b	7,$A,8,$A,9,$A,$A,$A,1,$A,2,$A,3,$A,4,$A
	dc.b	5,$A,6,$A,7,$A,8,$A,9,$A,$A,$A,$FE,0
ArenaFrames2						;ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,$A,2,$A,3,$A,4,$A,5,$A,6,$A,7,$A,8,$A
	dc.b	9,$A,$A,$A,$FF,0
ArenaFrames3						;ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,$A,2,$A,3,$A,4,$A,5,$A,6,$A,7,$A,8,$A
	dc.b	9,$A,$A,$A,$B,$A,$C,$A,$D,$A,$E,$A,$F,$A,$10,$A
	dc.b	$11,$A,$12,$A,$13,$A,$14,$A,$15,$A,$16,$A,$17,$A,$FE,0
ArenaFrames4						;ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,8,2,8,3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C
	dc.b	3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C
	dc.b	3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C
	dc.b	3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C
	dc.b	3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C
	dc.b	2,8,1,8,$FF,0
ArenaFrames5						;ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,8,2,8,3,8,4,8,5,8,6,8,7,8,8,8
	dc.b	$FF,0
ArenaFrames6						;ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,8,2,8,3,8,4,$1E,5,8,6,8,7,8,8,$1E
	dc.b	5,8,6,8,7,8,8,$1E,9,8,$A,8,$B,8,$C,8
	dc.b	$D,8,$E,8,$FE,0
ArenaFrames7						;ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	$F,8,$10,8,$11,8,$12,$1E,$13,8,$14,8,$15,8,$16,$1E
	dc.b	$13,8,$14,8,$15,8,$16,$1E,$17,8,$18,8,$19,8,$1A,8
	dc.b	$1B,8,$1C,8,$FE,0
ArenaFrames8						;ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,$A,2,$A,3,$A,4,$A,5,$A,6,$A,7,$A,8,$A
	dc.b	9,$A,$A,$A,$B,$A,$C,$A,$D,$A,$E,$A,$F,$7F,$FE,0
	dc.b	$08,$F9,$00,$06,$00,$01,$7F,$6A,$33,$FC,$00,$00,$00,$01,$7E,$DC
	dc.b	$33,$FC,$01,$60,$00,$01,$7E,$DE
	rts
StartArenaAnim						;Start arena animation d0 (ArenaAnims): arenaanim = d0, RunArenaAnim loads
									;it. Called from FallDown (7)
									;ShowGoalBox (0 on a home hat trick) and puckfaceoff2 (the one
									;SetFaceoffAnim set)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	d0,$1A556.l
	move.l	#$0,$1A558.l
	move.l	#$0,$1A55C.l
	move.w	#$1,$1A550.l
	clr.w	$1A552.l
	st.b	$1A560.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
SetFaceoffAnim						;Set the faceoff animation: sflags7 bit 0, faceoffanim = d0. Called from
									;puckfaceoff
	bset	#$0,$17F7A.l
	move.w	d0,$1A560.l
	rts
EndArenaAnim
	move.w	#$FFFF,$1A556.l
	bclr	#$0,$17F7A.l
	rts
ChooseSong						;SongNum = byte SongIndex of the 6 song bytes of team HmTeam, or one of
									;the 8 of RandomSongs at random when 0; $FFFF with gmode bit 4. Called
									;from StartPer, checkgoal, puckshootout and LeadSong
	movem.l	d0-d1/a0-a1,-(sp)
	btst	#$4,$17F68.l		;highlight reel?
	beq.w	.next		;not the highlight reel: pick a song
	move.w	#$FFFF,d1		;highlights: no song
	bra.w	.next2
.next	bclr	#$6,$17F7C.l		;clear sflags8 bit 6
	movea.l	#$2A4DC,a0
	movea.l	#$2A584,a1
	move.w	$1A56C.l,d0
	mulu.w	#$6,d0
	add.w	$1A56E.l,d0
	clr.w	d1
	move.b	(a0,d0.w),d1		;team song
	bne.w	.next2		;a team song: use it
	move.w	#$8,d0		;slot 0: one of the 8 random songs
	jsr	(randomd0).l
	andi.w	#$7,d0
	move.b	(a1,d0.w),d1
.next2	move.w	d1,$1A56A.l
	movem.l	(sp)+,d0-d1/a0-a1
	rts
TeamSongs						;ChooseSong: 6 songs per team (TeamList order), 0 = random (RandomSongs)
TeamSongsTbl1	dc.w	$7775
