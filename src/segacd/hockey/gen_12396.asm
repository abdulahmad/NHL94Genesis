; Draws the selected player's entry.
PlayerListDrawSelected
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$7,$3,$2,$9,CC_SetFont,$1
	move.w	(SelectedPlayerIdx).l,d0
	dc.w	$43FA,$012C
	jsr	(SkipListEntries).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	CC_Font3,$16,$FC,$9
.loop	movea.l	#$41C48,a1
	move.w	(scoutcolumn).l,d0
	tst.w	(SelectedPlayerIdx).l
	bne.w	.next
	movea.l	#$41DAA,a1
	bra.w	.next
.loop2	adda.w	(a1),a1
	adda.w	#$4,a1
.next	tst.w	(a1)
	dbmi	d0,.loop2
	bpl.w	.next2
	subi.w	#$1,(scoutcolumn).l
	bra.w	.loop
.next2	jsr	(printsmall).l
	move.l	(a1),d4
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$0,$0,CC_SetFont,$0
	btst	#$0,$1A455.l
	beq.w	.next3
	addi.w	#$10,(printy).l
.next3	move.w	(printy).l,-(sp)
	moveq	#$28,d0
	moveq	#$10,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	move.w	(sp)+,(printy).l
	bsr.w	GetGoalieCount
	move.w	d0,d1
	subi.w	#$1,d1
	movea.l	#$2D4CA,a5
	movea.l	#$BBD30,a3
	move.l	#$1020304,(a3)
	move.w	(SelectedPlayerIdx).l,d0
	subi.w	#$1,d0
	bmi.w	.loop3
	asl.w	#$3,d0
	lea.l	$16C(a2),a3
	lea.l	$1(a3,d0.w),a3
	movea.l	#$41A20,a5
	moveq	#$4,d1
	cmpi.w	#$5,(SelectedPlayerIdx).l
	ble.w	.loop3
	subi.w	#$1,d1
.loop3	move.w	#$2,(printx).l
	movea.l	a5,a1
	jsr	(print).l
	movea.l	a1,a5
	move.w	#$7,(printx).l
	clr.w	d0
	move.b	(a3)+,d0
	subi.w	#$1,d0
	bsr.w	GetNameandAttrib
	addi.w	#$2,(printy).l
	dbra	d1,.loop3
	rts
CheckPlayerListScrollTbl1	dc.w	$0004,$4700,$0004,$4700,$0004,$4700,$0004,$4700
	dc.b	$00,$12,'    Goalies   '
	dc.b	' }',$00,$12,'{  Scoring  '
	dc.b	'1  }',$00,$12,'{  Scoring'
	dc.b	'  2  }',$00,$12,'{   Chec'
	dc.b	'king   }',$00,$12,'{ Powe'
	dc.b	'r Play 1 }',$00,$12,'{ Po'
	dc.b	'wer Play 2 }',$00,$12,'{P'
	dc.b	'enalty Kill 1}',$00,$12
	dc.b	'{Penalty Kill 2 '
GetNameandAttrib						;Print player d0's name, then at x $1E the column d4 picks (attribjmp;
									;above 2 a rating through CalcAttrib, high ROM). Saves d0-d4/a0-a1/a4-a5
	movem.l	d0-d4/a0-a1/a4-a5,-(sp)
	dc.w	$487A,$0030
	jsr	(GetPlayerNameBuild).l
	jsr	(print).l
	move.w	#$1E,(printx).l
	cmpi.w	#$2,d4		;status or energy column?
	bls.w	.next
	jsr	(CalcAttrib).l
	swap	d4
.next	dc.w	$41FA,$000E
	adda.w	(a0,d4.w),a0
	jmp	(a0)
	dc.w	$4CDF,$331F,$4E75,$000C,$009E,$00E8,$010E,$00B8
	dc.w	$00C0,$D040,$3032,$0068,$6A00,$001E,$4640,$0C40
	dc.w	$0003,$6300,$000A,$7001,$6000,$0004,$7003,$43FA
	dc.w	$0040,$4EF9,$0003,$CEBE,$0800,$000C,$6600,$FFEE
	dc.w	$0479,$0001,$0001,$8D58,$3200,$0240,$0FFF,$4EB9
	dc.w	$0003,$90F4,$4EB9,$0003,$8F80,$7004,$0881,$000E
	dc.w	$6700,$0004,$7005,$43FA,$0008,$4EF9,$0003,$CEBE
	dc.b	$00,$0A,'Ice     ',$00,$0A,'Benc'
	dc.b	'h   ',$00,$0A,'Injury P',$00,$0A
	dc.b	'Injury G',$00,$06,'    ',$00,$06
	dc.w	$2043,$2020
AttribEnergy						;Energy: tmpde(a2) word / 40, at most 100 (AttribPrintPct)
	add.w	d0,d0
	move.w	$34(a2,d0.w),d0		;his energy
	ext.l	d0
	divu.w	#$28,d0
	cmpi.w	#$64,d0		;over 100?
	ble.w	AttribPrintPct
	moveq	#$64,d0
	bra.w	AttribPrintPct		;print it
	dc.w	$0240,$000E,$0441,$0001,$C0FC,$0064,$80C1,$4EB9
	dc.w	$0002,$AE82
AttribPrintPct
	moveq	#$4,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l
	String	'    '
	rts
	dc.w	$0240,$0001,$0A40,$0001,$43FA,$0008,$4EF9,$0003
	dc.w	$CEBE,$000A
AttribWeight						;Weight: 140 + 8 * rating lb
	addq.w	#$1,$6768(a1)
	moveq	#$79,d2
	move.l	-(a0),d0
	dc.b	$00,$0A,'Lefty   ',$E7,'@',$06,'@',$00,$8C
	dc.w	$4EB9,$0003,$915E,$4EB9,$0003,$8F80,$4EB9,$0003
	dc.b	$8F,'n',$00,$08,' lb  ',$00,'Nu'
ScoringSummaryScreen						;"Scoring Summary": one 4 row entry per goal (6 bytes each from ScoreSum),
									;scrolled with up / down, start exits. Menu item handler
	moveq	#$A,d0		;SetupScreen d0/d1: row offset / height
	moveq	#$1A,d1
	bsr.w	CrowdMeterFadeIn		;set up the screen
	jsr	(printz).l
	String	CC_Font3Pri,$4,$1
	moveq	#$20,d0
	moveq	#$6,d1
	jsr	(Framer).l
	jsr	(printbigz).l
	String	CC_Font3Pri,$6,$4,'Scoring Summary',CC_Font3Pri,$7,$1
	moveq	#$2C,d0
	bsr.w	PutTeamBlockDraw
	addi.w	#$4,(printx).l		;4 columns right
	clr.w	d0
	bsr.w	PutTeamBlockDraw
	jsr	(printsmallz).l
	dc.w	$0034
	dc.b	$F8,$06,$03,$00,$08,$F9,$01,'^Per^^Time^^Tm^^Goal/Assist^^^^^^^^P/S^^',$F9,$00,$00
	clr.l	d0
	move.w	$180F0.l,d0
	divu.w	#$6,d0		;goals
	asl.w	#$5,d0		;32 pixels per entry
	move.w	d0,(VertLineScrolling).l		;start at the end
	subi.w	#$80,d0		;4 entries fit on screen
	bpl.w	.0
	clr.w	d0
.0	move.w	d0,(SelectedPlayerIdx).l
	move.w	(VertLineScrolling).l,d0		;start position
.toend	bsr.w	MenuWaitVblank		;wait for the next frame
	bsr.w	ScoringScrollStep
	move.w	(VertLineScrolling).l,d0		;position
	subi.w	#$2,d0
	cmp.w	(SelectedPlayerIdx).l,d0		;reached the limit?
	bge.w	.toend
	clr.w	(PlayerScrollCtr).l
.loop	bsr.w	MenuWaitVblank		;wait for the next frame
	bsr.w	ReadActiveJoypad		;read the pads
	btst	#$7,d3		;start: leave
	bne.w	CrowdMeterScreenSub2
	moveq	#-2,d0
	btst	#$0,d3		;up?
	bne.w	.set
	neg.w	d0
	btst	#$1,d3		;down?
	beq.w	.scroll
.set	move.w	d0,(PlayerScrollCtr).l
.scroll	bsr.w	CheckScoringScroll
	bra.w	.loop
CheckScoringScroll						;ScoringSummaryScreen per frame: add PlayerScrollCtr to VertLineScrolling
									;(0 ... SelectedPlayerIdx). Falls into UpdateScoringScroll
	move.w	(PlayerScrollCtr).l,d0
	beq.w	updatereplayExit
	add.w	(VertLineScrolling).l,d0		;new position
	bmi.w	updatereplayExit		;above the top: ignore
	cmp.w	(SelectedPlayerIdx).l,d0		;past the limit?
	bgt.w	updatereplayExit
; Scrolling step in units of $20.
ScoringScrollStep	move.w	(VertLineScrolling).l,d1
	move.w	d0,(VertLineScrolling).l
	ext.l	d0
	divs.w	#$20,d0
	swap	d0
	tst.w	d0
	bne.w	.next
	bsr.w	PenaltyEntryHeader
	clr.w	(PlayerScrollCtr).l
.next	andi.w	#$1F,d1
	bne.w	.next3
	move.l	d0,-(sp)
	cmpi.w	#$1E,d0
	bne.w	.next2
	bsr.w	.next4
.next2	move.l	(sp)+,d0
	cmpi.w	#$2,d0
	bne.w	.next3
	bsr.w	.next5
.next3	move.w	(disflags).l,-(sp)
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
	moveq	#-80,d0
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
.next4	move.l	d0,-(sp)
	swap	d0
	moveq	#$6,d3
	mulu.w	d0,d3
	jsr	(printz).l
	String	CC_Font2Pri,$0,$0
	move.w	(VertLineScrolling).l,d0
	lsr.w	#$3,d0
	subi.w	#$3,d0
	andi.w	#$1F,d0
	move.w	d0,(printy).l
	bsr.w	DrawScoringRow
	move.l	(sp)+,d0
	rts
.next5	move.l	d0,-(sp)
	swap	d0
	addi.w	#$4,d0
	moveq	#$6,d3
	mulu.w	d0,d3
	jsr	(printz).l
	String	CC_Font2Pri,$0,$0
	move.w	(VertLineScrolling).l,d0
	lsr.w	#$3,d0
	addi.w	#$10,d0
	andi.w	#$1F,d0
	move.w	d0,(printy).l
	bsr.w	DrawScoringRow
	move.l	(sp)+,d0
	rts
DrawScoringRow						;Print ScoreSum entry d3: time, team (bit 7 of byte 2 = away), goal type
									;(GoalTypeTbl), scorer and the two assists (PrintScorerName)
	move.w	(printy).l,-(sp)
	moveq	#$28,d0		;width 40 cells
	moveq	#$4,d1		;4 rows high
	move.w	#$7FF,d2		;blank tile
	jsr	(eraser).l
	move.w	(sp)+,(printy).l
	movea.l	#$180F2,a0
	move.w	(a0,d3.w),d0		;goal time
	move.w	#$1,(printx).l
	jsr	(FormatAndPrintTime).l
	movea.l	#tmstruct,a2
	btst	#$7,$2(a0,d3.w)
	beq.w	.0
	adda.w	#$366,a2
.0	movea.l	$1E(a2),a1		;team data -> team name string
	adda.w	$4(a1),a1
	adda.w	(a1),a1
	move.w	#$C,(printx).l
	jsr	(print).l
	move.w	#$23,(printx).l
	dc.w	$43FA,$0060
	move.b	$2(a0,d3.w),d0
	andi.w	#$7F,d0
	jsr	(PrintTickerEntry).l
	move.w	#$10,(printx).l
	move.b	$3(a0,d3.w),d0
	bsr.w	PrintScorerName		;print him
	move.w	#$E000,(printa).l
	move.w	#$12,(printx).l
	move.b	$4(a0,d3.w),d0
	bsr.w	PrintScorerName
	move.w	#$12,(printx).l
	move.b	$5(a0,d3.w),d0		;second assist, falls into PrintScorerName
PrintScorerName						;Print player d0 (byte, negative = none) and go down a row
	ext.w	d0
	bmi.w	.next
	jsr	(FormatPlayerNumInitial).l
	jsr	(print).l
.next	addi.w	#$1,(printy).l
	rts
	dc.w	$0006,$5348,$3200,$0004,$5348,$0004,$2000,$0004
	dc.b	'PP',$00,$06,'PP2',$00
PenaltySummaryScreen						;"Penalty Summary": one 3 row entry per penalty (4 bytes each from PenSum,
									;PenSumLength bytes), scrolled as ScoringSummaryScreen. Menu item handler
	moveq	#$A,d0		;bitmap row $A
	moveq	#$19,d1
	bsr.w	CrowdMeterFadeIn		;set up the screen
	jsr	(printz).l
	String	CC_Font3Pri,$4,$1
	moveq	#$20,d0
	moveq	#$6,d1
	jsr	(Framer).l
	jsr	(printbigz).l
	String	CC_Font3Pri,$5,$4,'Penalty  Summary',CC_Font3Pri,$7,$1
	moveq	#$2C,d0
	bsr.w	PutTeamBlockDraw
	addi.w	#$4,(printx).l		;4 columns right
	clr.w	d0
	bsr.w	PutTeamBlockDraw
	jsr	(printsmallz).l
	dc.w	$0034
	dc.b	$F8,$06,$03,$00,$08,$F9,$01,'^Per^^Time^^Tm^^Player/Penalty^^^^min^^^',$F9,$00,$00
	clr.l	d0
	move.w	$1825A.l,d0
	lsr.w	#$2,d0		;/4 bytes per entry = number of penalties
	mulu.w	#$18,d0		;24 pixels per entry
	move.w	d0,(VertLineScrolling).l		;start at the end
	subi.w	#$78,d0		;5 entries fit on screen
	bpl.w	.0
	clr.w	d0		;fewer than 5 entries: no scrolling
.0	move.w	d0,(SelectedPlayerIdx).l
	move.w	(VertLineScrolling).l,d0		;start position
.toend	bsr.w	MenuWaitVblank		;wait for the next frame
	bsr.w	PenaltyScrollStep		;set scroll to d0, drawing entries as they come into view
	move.w	(VertLineScrolling).l,d0		;position
	subi.w	#$2,d0
	cmp.w	(SelectedPlayerIdx).l,d0		;reached the limit?
	bge.w	.toend		;not there yet
	clr.w	(PlayerScrollCtr).l
.loop	bsr.w	MenuWaitVblank		;wait for the next frame
	bsr.w	ReadActiveJoypad		;d3 = held buttons of the pad that paused
	btst	#$7,d3		;start?
	bne.w	CrowdMeterScreenSub2		;Start
	moveq	#-2,d0
	btst	#$0,d3		;up?
	bne.w	.set		;up held: scroll up
	neg.w	d0
	btst	#$1,d3		;down?
	beq.w	.scroll		;neither: keep the current PlayerScrollCtr (it is cleared at entry
.set	move.w	d0,(PlayerScrollCtr).l
.scroll	bsr.w	CheckPenaltyScroll
	bra.w	.loop
CheckPenaltyScroll						;PenaltySummaryScreen per frame: add PlayerScrollCtr to VertLineScrolling
									;(0 ... SelectedPlayerIdx). Falls into UpdatePenaltyScroll
	move.w	(PlayerScrollCtr).l,d0
	beq.w	updatereplayExit
	add.w	(VertLineScrolling).l,d0		;new position
	bmi.w	updatereplayExit		;above the top: ignore
	cmp.w	(SelectedPlayerIdx).l,d0		;past the limit?
	bgt.w	updatereplayExit
; Scrolling step in units of $18.
PenaltyScrollStep	move.w	(VertLineScrolling).l,d1
	move.w	d0,(VertLineScrolling).l
	ext.l	d0
	divs.w	#$18,d0
	swap	d0
	tst.w	d0
	bne.w	.next
	bsr.w	PenaltyEntryHeader
	clr.w	(PlayerScrollCtr).l
.next	ext.l	d1
	divs.w	#$18,d1
	swap	d1
	tst.w	d1
	bne.w	.next3
	move.l	d0,-(sp)
	cmpi.w	#$16,d0
	bne.w	.next2
	bsr.w	.next4
.next2	move.l	(sp)+,d0
	cmpi.w	#$2,d0
	bne.w	.next3
	bsr.w	.next5
.next3	move.w	(disflags).l,-(sp)
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
.next4	move.l	d0,-(sp)
	swap	d0
	move.w	d0,d3
	asl.w	#$2,d3
	jsr	(printz).l
	String	CC_Font2Pri,$0,$0
	move.w	(VertLineScrolling).l,d0
	lsr.w	#$3,d0
	subi.w	#$2,d0
	andi.w	#$1F,d0
	move.w	d0,(printy).l
	bsr.w	DisplayPenaltyEntry
	move.l	(sp)+,d0
	rts
.next5	move.l	d0,-(sp)
	swap	d0
	addi.w	#$5,d0
	move.w	d0,d3
	asl.w	#$2,d3
	jsr	(printz).l
	String	CC_Font2Pri,$0,$0
	move.w	(VertLineScrolling).l,d0
	lsr.w	#$3,d0
	addi.w	#$F,d0
	andi.w	#$1F,d0
	move.w	d0,(printy).l
	bsr.w	DisplayPenaltyEntry
	move.l	(sp)+,d0
	rts
DisplayPenaltyEntry						;Print PenSum entry d3: time, team (bit 7 of byte 2 = away), minutes and
									;name from Penaltylist, player (byte 3)
	move.w	(printy).l,-(sp)
	moveq	#$28,d0		;width 40 cells
	moveq	#$3,d1		;3 rows high
	move.w	#$7FF,d2		;blank tile
	jsr	(eraser).l
	move.w	(sp)+,(printy).l
	movea.l	#$1825C,a0
	move.w	(a0,d3.w),d0		;penalty time
	move.w	#$1,(printx).l
	jsr	(FormatAndPrintTime).l
	movea.l	#tmstruct,a2
	btst	#$7,$2(a0,d3.w)		;away penalty?
	beq.w	.0
	adda.w	#$366,a2
.0	movea.l	$1E(a2),a1		;team data -> team name string
	adda.w	$4(a1),a1
	adda.w	(a1),a1
	move.w	#$C,(printx).l
	jsr	(print).l
	move.b	$2(a0,d3.w),d0
	andi.w	#$7F,d0
	movea.l	#$4165C,a3
	adda.w	(a3,d0.w),a3
	clr.w	d0
	move.b	$1(a3),d0		;penalty minutes
	jsr	(PushNumber).l
	move.w	#$23,(printx).l
	jsr	(print).l
	move.w	#$10,(printx).l
	clr.w	d0
	move.b	$3(a0,d3.w),d0
	jsr	(FormatPlayerNumInitial).l
	jsr	(print).l
	addi.w	#$1,(printy).l
	move.w	#$13,(printx).l
	move.w	#$E000,(printa).l
	lea.l	$2(a3),a1		;penalty name string
	jmp	(print).l
; Prints the penalty entry header.
PenaltyEntryHeader
	movem.l	d0-d1/a1,-(sp)
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,$4,$9,CC_SetFont,$1
	clr.w	d0
	move.w	(VertLineScrolling).l,d1
	tst.w	d1
	sgt.b	d0
	neg.b	d0
	cmp.w	(SelectedPlayerIdx).l,d1
	slt.b	d1
	neg.b	d1
	add.b	d1,d0
	add.b	d1,d0
	lea.l	.next(pc),a1
	jsr	(PrintTickerEntry).l
	movem.l	(sp)+,d0-d1/a1
	rts
.next	dc.w	$000A,$20FB,$FFFA,$1120,$F900,$000A,$7BFB,$FFFA
	dc.w	$1120,$F900,$000A,$20FB,$FFFA,$117D,$F900,$000A
	dc.w	$7BFB,$FFFA,$117D,$F900
PlayoffStatsScreen						;"Playoff Stats": the playoff totals (ReadTeamStats) of the potreeteam
									;team as PlayerStatsList with d7 = 1. Called and the menu lists
	movem.l	a2,-(sp)
	jsr	(ReadTeamStats).l
	movea.l	#$18AA6,a0
	move.w	$18AA0.l,d0
	move.b	(a0,d0.w),d0		;his team
	movea.l	#tmstruct,a2
	cmp.w	$2A(a2),d0		;is it home?
	beq.w	.0
	adda.w	#$366,a2
.0	moveq	#$1,d7		;playoff mode: stats come from the playoff RAM tables
	bsr.w	PlayerStatsList
	movem.l	(sp)+,a2
	rts
	dc.w	$4247
PlayerStatsList						;Stats screen for team a2, d7 = 0 game / 1 playoff: the column headers,
									;the players sorted by the selected column (left / right), up / down
									;scroll, A switches teams (game stats only), start exits
	moveq	#$D,d0		;bitmap row $D
	moveq	#$16,d1
	bsr.w	CrowdMeterFadeIn		;set up the screen
	clr.w	(scoutcolumn).l		;sort column: -1 goalie saves, 0-4 G A Pts SOG PIM; start with goals
	clr.w	(VertLineScrolling).l		;list scrolled to the top
.redraw	clr.w	(PlayerScrollCtr).l
	jsr	(printz).l
	String	CC_Font3Pri,$5,$1
	moveq	#$1E,d0
	moveq	#$6,d1
	jsr	(Framer).l
	tst.w	d7
	beq.w	.title
	jsr	(printbigz).l
	String	CC_Font3Pri,$7,$4,'Playoff  Stats',CC_Font3Pri,$E,$1
	bra.w	.team
.title	jsr	(printsmallz).l
	dc.w	$001C
	dc.b	$F8,$06,$03,$0C,$1A,$F9,$01,'A^-^Switch^Teams',$F9,$00,$00
	jsr	(printbigz).l
	String	CC_Font3Pri,$8,$4,'Player  Stats',CC_Font3Pri,$E,$1
.team	clr.w	d0		;TeamBlockMap offset: 0 for the home struct, $30 for the away struct
	cmpa.l	#$1834C,a2		;home team?
	beq.w	.home
	moveq	#$2C,d0
.home	bsr.w	PutTeamBlockDraw		;draw the team block, then the list
	bsr.w	StatsListDrawHeader
	bsr.w	StatColumnHeader
.loop	bsr.w	MenuWaitVblank
	bsr.w	ReadActiveJoypad		;d1 = new presses, d3 = held
	btst	#$7,d3
	bne.w	CrowdMeterScreenSub2		;Start
	btst	#$6,d1		;A?
	bne.w	.switch
	jsr	(nodiag).l
	moveq	#$1,d0
	btst	#$3,d1		;right?
	bne.w	.col		;right pressed: column +1
	neg.w	d0
	btst	#$2,d1		;left?
	bne.w	.col		;left pressed: column -1
	moveq	#-2,d0
	btst	#$0,d3		;up?
	bne.w	.set		;up held: scroll step -2
	neg.w	d0
	btst	#$1,d3		;down?
	beq.w	.scroll		;nothing held: keep the current scroll step
.set	move.w	d0,(PlayerScrollCtr).l
.scroll	bsr.w	UpdateStatsListScroll
	bra.w	.loop
.col	add.w	(scoutcolumn).l,d0
	cmpi.w	#$FFFF,d0		;below -1?
	blt.w	.scroll
	cmpi.w	#$4,d0		;past 4?
	bgt.w	.scroll
	move.w	d0,(scoutcolumn).l
	bsr.w	StatsListDrawHeader
	bsr.w	StatColumnHeader
	bra.w	.scroll
.switch	tst.w	d7		;No team switch in playoff stats
	bne.w	.scroll
	lea.l	$366(a2),a2
	cmpa.l	#$186B2,a2		;was the home team?
	beq.w	.redraw		;was home, now away
	movea.l	#tmstruct,a2		;was away, back to home
	bra.w	.redraw
UpdateStatsListScroll						;Stats screen per frame: scroll 0 ... SelectedPlayerIdx, stop on a 16 line
									;boundary, draw the row coming into view
	move.w	(PlayerScrollCtr).l,d0
	beq.w	updatereplayExit
	add.w	(VertLineScrolling).l,d0		;new position
	bmi.w	updatereplayExit		;above the top: ignore
	cmp.w	(SelectedPlayerIdx).l,d0		;past the limit?
	bgt.w	updatereplayExit
	move.w	(VertLineScrolling).l,d1		;d1 = old position
	move.w	d0,(VertLineScrolling).l
	andi.w	#$F,d0		;pixels into the current 16 pixel row
	bne.w	.0
	bsr.w	StatColumnHeader		;landed on a row boundary: refresh arrows and stop scrolling
	clr.w	(PlayerScrollCtr).l
.0	andi.w	#$F,d1		;old position within its row
	bne.w	UpdateStatsListScroll_1
	move.w	d0,-(sp)
	cmpi.w	#$E,d0		;14 pixels in: moved up, draw the row above
	bne.w	.1
	bsr.w	StatsListDrawTopRow
.1	move.w	(sp)+,d0		;restore the pixels into the row
	cmpi.w	#$2,d0		;2 pixels in: moved down, draw the row below
	bne.w	UpdateStatsListScroll_1
	bsr.w	StatsListDrawBottomRow		;falls into the scroll register write
UpdateStatsListScroll_1	move.w	(disflags).l,-(sp)
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
	move.w	#$FF98,d0
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
; Draws the first visible stats row.
StatsListDrawTopRow	move.w	(VertLineScrolling).l,d3
	lsr.w	#$4,d3
	bra.w	DrawStatsRow
; Draws the stats row six lines below the first.
StatsListDrawBottomRow	move.w	(VertLineScrolling).l,d3
	lsr.w	#$4,d3
	addi.w	#$6,d3
	bra.w	DrawStatsRow
; Prints the 'Player' column header.
StatsListDrawHeader	jsr	(printsmallz).l
	dc.w	$0012
	dc.b	$F8,$06,$03,$04,$0B,$F9,$01,'Player',$FB,$07,$00
	dc.w	$43FA,$0344
	moveq	#$5,d3
	tst.w	(scoutcolumn).l
	bmi.w	.loop
	adda.w	(a1),a1
	clr.w	d3
.loop	move.w	#$8000,(printa).l
	cmp.w	(scoutcolumn).l,d3
	bne.w	.next
	move.w	#$C000,(printa).l
.next	jsr	(printsmall).l
	addi.w	#$1,d3
	cmpi.w	#$5,d3
	blt.w	.loop
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,$9,$7
	moveq	#$16,d0
	moveq	#$3,d1
	jsr	(Framer).l
	jsr	(printz).l
	String	CC_Font3Pal3Pri,$A,$8
	dc.w	$43FA,$0314
	moveq	#$1,d0
	add.w	(scoutcolumn).l,d0
	jsr	(PrintTickerEntry).l
	clr.w	(printfontset).l
	movea.l	#$BBD30,a3
	clr.l	d6
	tst.w	(scoutcolumn).l
	bpl.w	.loop2
	bsr.w	GetGoalieCount
	bset	d0,d6
	subi.w	#$1,d6
	not.l	d6
.loop2	moveq	#-1,d4
	st.b	d5
	bsr.w	GetPlayerCount
	bra.w	.next3
.loop3	btst	d0,d6
	bne.w	.next3
	clr.w	d2
	move.w	(scoutcolumn).l,d1
	bmi.w	.next2
	bsr.w	GetStatColumn
.next2	ext.l	d2
	asl.l	#$8,d2
	movea.l	$1E(a2),a1
	adda.w	$0(a1),a1
	move.w	d0,d1
	suba.w	#$8,a1
.loop4	adda.w	#$8,a1
	adda.w	(a1),a1
	dbra	d1,.loop4
	move.b	#$FF,d2
	sub.b	(a1),d2
	cmp.l	d4,d2
	ble.w	.next3
	move.l	d2,d4
	move.w	d0,d5
.next3	dbra	d0,.loop3
	bset	d5,d6
	move.b	d5,(a3)+
	bpl.w	.loop2
	moveq	#$5,d0
.loop5	st.b	(a3,d0.w)
	dbra	d0,.loop5
	move.l	a3,d0
	subi.l	#$BBD36,d0
	bpl.w	.next4
	clr.w	d0
.next4	asl.w	#$4,d0
	move.w	d0,(SelectedPlayerIdx).l
	cmp.w	(VertLineScrolling).l,d0
	bcc.w	.next5
	move.w	d0,(VertLineScrolling).l
.next5	moveq	#$5,d4
.loop6	move.w	(VertLineScrolling).l,d3
	lsr.w	#$4,d3
	add.w	d4,d3
	bsr.w	DrawStatsRow
	dbra	d4,.loop6
	bra.w	UpdateStatsListScroll_1
DrawStatsRow						;Stats screen row d3 of Satt: rank, name, then the 5 columns, or for
									;goalies saves, shots and save %
	movea.l	#$BBD30,a4
	adda.w	d3,a4
	jsr	(printz).l
	String	CC_Font2Pri,$0,$0
	add.w	d3,d3		;2 map rows per Satt row
	andi.w	#$1F,d3		;wrap in the 32 row map
	move.w	d3,(printy).l
	moveq	#$28,d0		;erase one row, 40 cells wide
	moveq	#$1,d1
	move.w	#$7FF,d2		;blank char
	jsr	(eraser).l
	tst.b	(a4)		;empty row?
	bmi.w	updatereplayExit
	subi.w	#$1,(printy).l		;eraser moved printy down one row; back to the row rank (2 digits) at x 1
	move.w	#$1,(printx).l
	move.l	a4,d0
	subi.l	#$BBD2F,d0		;rank (1-based)
	moveq	#$2,d1		;2 digits
	move.w	#$E000,(printa).l
	jsr	(PushNumberWidth).l
	jsr	(print).l
	clr.w	d0
	move.b	(a4),d0
	jsr	(FormatPlayerName).l
	addi.w	#$1,(printx).l
	move.w	#$8000,(printa).l
	jsr	(print).l
	move.w	#$11,(printx).l		;stat columns start at x $11
	tst.w	(scoutcolumn).l		;goalie column?
	bmi.w	.goalie
	clr.w	d5
.col	clr.w	d0		;next stat column d5
	move.b	(a4),d0
	move.w	d5,d1
	bsr.w	GetStatColumn		;d2 = the stat
	move.w	d2,d0
	moveq	#$4,d1		;4 digits
	jsr	(PushNumberWidth).l
	move.w	#$8000,(printa).l
	cmp.w	(scoutcolumn).l,d5		;sort column?
	bne.w	.1
	move.w	#$C000,(printa).l		;highlighted sort column
.1	jsr	(print).l
	addi.w	#$1,d5
	cmpi.w	#$5,d5		;5 columns
	bne.w	.col
	bra.w	.ex
.goalie	clr.w	d0		;Shots against
	move.b	(a4),d0
	moveq	#$3,d1		;column 3 (SOG array)
	bsr.w	ReadStatColumnTable		;d2 = shots against
	clr.w	d0
	move.b	(a4),d0
	moveq	#$0,d1		;goals against
	move.w	d2,-(sp)
	bsr.w	ReadStatColumnTable		;d2 = goals against
	move.w	(sp)+,d0
	move.w	d0,d3
	sub.w	d2,d0		;saves = shots - goals against
	bpl.w	.2
	clr.w	d0
.2	move.w	d0,d2
	moveq	#$4,d1		;4 digits
	jsr	(PushNumberWidth).l
	addi.w	#$1,(printx).l
	jsr	(print).l
	move.w	d3,d0
	moveq	#$4,d1
	jsr	(PushNumberWidth).l
	addi.w	#$2,(printx).l
	jsr	(print).l
	tst.w	d3
	beq.w	.3		;no shots: percentage is just d2 (0)
	mulu.w	#$64,d2
	divu.w	d3,d2		;saves * 100 / shots
.3	move.w	d2,d0
	moveq	#$4,d1		;4 digits
	jsr	(PushNumberWidth).l
	addi.w	#$2,(printx).l
	jsr	(print).l
	jsr	(printz).l
	String	'%'
.ex	rts
