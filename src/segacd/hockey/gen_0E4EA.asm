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
	beq.b	.lE540
	move.w	#$1,-(a6)
	bra.b	.lE544
.lE540	move.w	#$0,-(a6)
.lE544	bclr.b	#$5,$FF800F.l
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
	beq.b	.lE584
	bset.b	#$5,$FF800F.l
	bra.b	.lE58C
.lE584	bclr.b	#$5,$FF800F.l
.lE58C	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	move.w	#$2,d0
	jsr	$5F22.w
	move.w	#$2,d0
	jsr	$5F22.w
	move.w	#$80,d0
	jsr	$5F22.w
	dc.w	$6500,$FFF6
	move.w	#$81,d0
	jsr	$5F22.w
	move.w	(a0),d2
	andi.w	#$FF00,d2
	cmpi.w	#$0,d2
	dc.w	$66EC
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
	movea.l	#$2AF56,a0
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
	move.l	(a0)+,(a1)+
	dc.w	$51C8,$FFFC
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
	movea.l	#$2AF56,a0
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
	dc.w	$6700,$004A
	jsr	$38F6E.l
	dc.b	$00,$1C,$BE,$0C,$09,$31,$BE,$11,$09,$32,$BE,$16,$09,$33,$BE,$1A	; .....1...2...3..
	dc.b	$09,$4F,$54,$BE,$20,$09,$54,$6F,$74,$61,$6C,$00	; .OT. .Total.
L29728	jsr	$38F6E.l
	dc.b	$00,$1C,$BE,$0C,$0A,$3C,$BE,$11,$0A,$3C,$BE,$16,$0A,$3C,$BE,$1A	; .....<...<...<..
	dc.b	$0A,$3C,$3C,$BE,$20,$0A,$3C,$3C,$3C,$3C,$3C,$00	; .<<. .<<<<<.
L2974A	bra.w	L29786
	jsr	$38F6E.l
	dc.b	$00,$16,$BE,$0C,$09,$31,$BE,$11,$09,$32,$BE,$16,$09,$33,$BE,$20	; .....1...2...3. 
	dc.b	$09,$54,$6F,$74,$61,$6C	; .Total
L2976A	jsr	$38F6E.l
	dc.b	$00,$16,$BE,$0C,$0A,$3C,$BE,$11,$0A,$3C,$BE,$16,$0A,$3C,$BE,$20	; .....<...<...<. 
	dc.b	$0A,$3C,$3C,$3C,$3C,$3C	; .<<<<<
L29786	bsr.w	L298BA
	bsr.w	L29904
	move.w	#$18,$18D62.l
	jsr	$2EDE2.l
	btst	#$7,d1
	bne.w	.lE7F0
	btst	#$2,d1
	bne.w	.lE7D4
	btst	#$3,d1
	bne.w	.lE7B8
	dc.w	$6000,$FFE0
.lE7B8	tst.w	$1A43A.l
	dc.w	$6600,$FFD6
	st.b	$1A43A.l
	bsr.w	L298BA
	bsr.w	L29904
	dc.w	$6000,$FFC4
.lE7D4	tst.w	$1A43A.l
	dc.w	$6700,$FFBA
	clr.w	$1A43A.l
	bsr.w	L298BA
	bsr.w	L29904
	dc.w	$6000,$FFA8
.lE7F0	movem.l	(sp)+,d0-d7/a0-a6
	movem.l	d7/a0,-(sp)
	movea.l	$47D8C.l,a0
	move.w	#$2,d7
	jsr	$6044.w
	movem.l	(sp)+,d7/a0
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst.b	#$5,$FF800F.l
	beq.b	.lE822
	move.w	#$1,-(a6)
	bra.b	.lE826
.lE822	move.w	#$0,-(a6)
.lE826	bclr.b	#$5,$FF800F.l
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
	beq.b	.lE866
	bset.b	#$5,$FF800F.l
	bra.b	.lE86E
.lE866	bclr.b	#$5,$FF800F.l
.lE86E	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	move.w	#$2,d0
	jsr	$5F22.w
	move.w	#$80,d0
	jsr	$5F22.w
	dc.w	$6500,$FFF6
	move.w	#$81,d0
	jsr	$5F22.w
	move.w	(a0),d2
	andi.w	#$FF00,d2
	cmpi.w	#$0,d2
	dc.w	$66EC
	move.w	#$5,$19364.l
	move.w	#$13,d0
	lea.l	$19364.l,a0
	jsr	$5F22.w
	jmp	$2E980.l
L298BA	tst.w	$1A43A.l
	dc.w	$6700,$0022
	jsr	$38F6E.l
	dc.b	$00,$18,$BE,$12,$07,$53,$68,$6F,$74,$73,$BE,$0F,$1A,$5B,$20,$46	; .....Shots...[ F
	dc.b	$6F,$72,$20,$47,$6F,$61,$6C,$73	; or Goals
L298E2	rts
	jsr	$38F6E.l
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
	beq.w	.lE950
	lea.l	$34C(a2),a0
.lE950	clr.w	$1A44A.l
	move.w	#$B,$18D58.l
	bsr.w	L299F6
	cmpi.w	#$1,$180E4.l
	blt.w	.lE9B6
	move.w	#$10,$18D58.l
	bsr.w	L299F6
	cmpi.w	#$2,$180E4.l
	blt.w	.lE9B6
	move.w	#$15,$18D58.l
	bsr.w	L299F6
	cmpi.w	#$3,$180E4.l
	blt.w	.lE9B6
	btst.b	#$1,$17F7A.l
	beq.w	.lE9B6
	move.w	#$1A,$18D58.l
	bsr.w	L299F6
.lE9B6	move.w	#$21,$18D58.l
	jsr	$38F6E.l
	dc.b	$00,$06,$20,$20,$20,$00	; ..   .
L299CA	subi.w	#$3,$18D58.l
	move.w	$1A44A.l,d0
	move.w	#$2,d1
	cmpi.w	#$64,d0
	blt.w	.lE9E8
	move.w	#$3,d1
.lE9E8	jsr	$3919A.l
	jsr	$38F80.l
	rts
L299F6	move.w	(a0)+,d0
	add.w	d0,$1A44A.l
	jsr	$38F6E.l
	dc.b	$00,$06,$20,$20,$20,$00	; ..   .
L29A0A	subi.w	#$3,$18D58.l
	move.w	#$2,d1
	cmpi.w	#$64,d0
	blt.w	.lEA22
	move.w	#$3,d1
.lEA22	jsr	$3919A.l
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
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_0EE56.bin
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
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_0F26C.bin
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
