GetStatColumn						;d2 = stat column d1 for player d0. Goalies only have PIM (btst d1,#6
									;picks the columns kept)
	move.w	d0,-(sp)
	bsr.w	GetGoalieCount
	move.w	d0,d2
	move.w	(sp)+,d0
	cmp.w	d2,d0		;goalie?
	bge.w	ReadStatColumnTable		;skater: read the column as is
	clr.w	d2		;goalie: columns 1 and 2 (A, Pts) show column 1 (assists), the rest 0
	dc.w	$033C,$0006,$6700
	dc.w	$15E8
ReadStatColumn						;d2 = stat column d1 for player d0. d7 = 0: the team struct byte arrays
									;(StatColumnOffsets); d7 = 1: the playoff tables (GetStatsValue)
	moveq	#$1,d1
; Selects the stat column table and indexes it.
ReadStatColumnTable
	tst.w	d7
	bne.w	.next
	dc.w	$43FA,$0076
	asl.w	#$2,d1
	adda.w	d1,a1
	clr.l	d1
	move.w	(a1),d1
	add.w	d0,d1
	clr.l	d2
	move.b	(a2,d1.l),d2
	move.w	$2(a1),d1
	bmi.w	updatereplayExit
	add.w	d0,d1
	clr.w	d3
	move.b	(a2,d1.l),d3
	add.w	d3,d2
	rts
.next	asl.w	#$2,d1
	add.w	d0,d0
	clr.w	d2
	bsr.w	.next2
	addi.w	#$2,d1
	bsr.w	.next2
	lsr.w	#$1,d0
	rts
.next2	movea.l	#$2E40E,a1
	tst.w	(a1,d1.w)
	beq.w	updatereplayExit
	movea.w	(a1,d1.w),a1
	move.l	d7,-(sp)
	move.l	a1,d7
	andi.l	#$FFFF,d7
	movea.l	d7,a1
	move.l	(sp)+,d7
	add.w	(a1,d0.w),d2
	rts
ReadStatColumnTbl1	dc.w	$B000,$0000,$B034,$0000,$B000,$B034,$B068,$0000
	dc.w	$B09C,$0000,$00B6,$FFFF,$00D0,$FFFF,$00B6,$00D0
	dc.w	$00EA,$FFFF,$0104,$FFFF,$0016,$5361,$7665,$7320
	dc.b	'Shots Save %  ',$00,$06
	dc.b	'   G',$00,$06,'   A',$00,$06,' Pts'
	dc.b	$00,$06,' SOG',$00,$06,' PIM'
	dc.b	$00,$16,'  '
	dc.b	'  Goalie Saves  '
	dc.b	' ]',$00,$16,'[      Goals'
	dc.b	'       ]',$00,$16,'[     '
	dc.b	'Assists      ]',$00,$16
	dc.b	'[      Points   '
	dc.b	'   ]',$00,$16,'[  Shots O'
	dc.b	'n Goal   ]',$00,$16,'[ Pe'
	dc.b	'nalty Minutes   '
; Prints the stat column header.
StatColumnHeader
	movem.l	d0-d1/a1,-(sp)
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,$2,$B,CC_SetFont,$1
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
.next	dc.w	$000A
CrowdMeterScreen						;"Crowd Meter": current, average and peak level (PrintCrowdMeter), plus
									;the arena and league records; start exits. Menu item handler
	dc.w	$20FB,$FFFA,$0C20,$F900,$000A
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_1353A.bin
; Forces black and sets display flags for the crowd meter screen.
CrowdMeterFadeIn
	movem.l	d0-d1/a2,-(sp)
	jsr	(forceblack).l
	bclr	#$0,(disflags).l
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	move.w	$18D32.l,d0
	jsr	(SetVramWriteAddr1).l
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.l	#$0,$FF8022.l
	move.w	#$E,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
.loop4	btst	#$7,$FF800E.l
	bne.b	.loop4
	move.w	#$8C81,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop5	btst	#$6,$FF800E.l
	beq.b	.loop5
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop6	btst	#$6,$FF800E.l
	bne.b	.loop6
	bclr	#$7,$FF800F.l
	move.w	#$6,$18D3E.l
.loop7	btst	#$7,$FF800E.l
	bne.b	.loop7
	move.w	#$8D00,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop8	btst	#$6,$FF800E.l
	beq.b	.loop8
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop9	btst	#$6,$FF800E.l
	bne.b	.loop9
	bclr	#$7,$FF800F.l
	clr.w	d0
	jsr	(SetVramWriteAddr1).l
.loop10	btst	#$7,$FF800E.l
	bne.b	.loop10
	move.l	#$0,$FF8022.l
	move.w	#$E,$FF8020.l
	bset	#$6,$FF800F.l
.loop11	btst	#$6,$FF800E.l
	beq.b	.loop11
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop12	btst	#$6,$FF800E.l
	bne.b	.loop12
	bclr	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	bclr	#$1,(disflags).l
	move.w	(framercset).l,d4
	movea.l	(FramerMap).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
	dc.l	$91234567,$89ABCDEF
	dc.w	$3839,$0001,$8D42,$4EB9,$0003,$93E8,$4EB9,$0003
	dc.w	$8F6E,$0006,$BD00,$0000,$2279,$0004,$7D0C,$D3E9
	dc.w	$0004,$247C,$0001,$B008,$4240,$4241,$3411,$3629
	dc.w	$0002,$7801,$7A00,$4EB9,$0003,$87E2,$4EB9,$0003
	dc.w	$8F6E,$0006,$FD00,$0000,$4CD7,$0403,$D179,$0001
	dc.w	$8D5A,$2079,$0004,$7D0C,$2248,$2448,$D1DA,$D3DA
	dc.w	$3601,$9640,$3200,$4240,$7428,$7A0D,$4EB9,$0003
	dc.w	$87E2,$33C4,$0001,$8D44,$2479,$0004,$7D3C,$508A
	dc.w	$4EB9,$0003,$8946,$D123,$4567,$89AB,$CDEF,$4EB9
	dc.w	$0003,$8F6E,$0006,$FE00,$0000,$7040,$7220,$343C
	dc.w	$07FF,$4EB9,$0003,$8C06,$33FC,$0018,$0001,$8D62
	dc.w	$4CDF,$0403,$4E75
CrowdMeterScreenSub2
	jsr	(forceblack).l
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	move.w	$18D30.l,d0
	jsr	(SetVramWriteAddr1).l
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.l	#$0,$FF8022.l
	move.w	#$E,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	move.w	#$8D00,d0
	move.b	$18D30.l,d0
	lsr.b	#$2,d0
.loop4	btst	#$7,$FF800E.l
	bne.b	.loop4
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop5	btst	#$6,$FF800E.l
	beq.b	.loop5
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop6	btst	#$6,$FF800E.l
	bne.b	.loop6
	bclr	#$7,$FF800F.l
.loop7	btst	#$7,$FF800E.l
	bne.b	.loop7
	move.w	#$8C00,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop8	btst	#$6,$FF800E.l
	beq.b	.loop8
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop9	btst	#$6,$FF800E.l
	bne.b	.loop9
	bclr	#$7,$FF800F.l
	move.w	#$5,$18D3E.l
.loop10	tst.w	(palcount).l
	bpl.w	.loop10
	move.w	(sp)+,(disflags).l
	bset	#$1,(disflags).l
	move.w	$18D48.l,d4
	movea.l	$47D18.l,a2
	addq.l	#$8,a2
	btst	#$4,$17F72.l
	beq.w	.next
	movea.l	$47D64.l,a2
	addq.l	#$8,a2
.next	jsr	(DecompressGraphicsPlain).l
	jsr	$2A9D0.l
	move.w	$18D42.l,d4
	movea.l	(SmallFontMap).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
	dc.l	$43434567,$89ABCDEF
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_13B00.bin
GetGoalieCount						;d0 = goalies on team a2 (nibbles in a team data word)
	movem.l	d1/a0,-(sp)
	movea.l	$1E(a2),a0
	adda.w	$A(a0),a0
	move.w	(a0),d1		;word with one nibble per goalie slot
	clr.w	d0
.count	addi.w	#$1,d0		;count nibbles by shifting 4 bits out until the word is 0
	asl.w	#$4,d1
	bne.w	.count
	movem.l	(sp)+,d1/a0
	rts
GetDefenseStart						;d0 = goalies + forwards of team a2 (GetGoalieCount + GetForwardCount),
									;the roster index of the first defenseman (roster order is goalies,
									;forwards, defense). Called from the high ROM player cards
	movem.l	a0,-(sp)
	bsr.w	GetGoalieCount
	move.w	d0,-(sp)
	movea.l	$1E(a2),a0
	adda.w	$8(a0),a0
	move.b	$3(a0),d0
	lsr.w	#$4,d0		;high nibble
	add.w	(sp)+,d0
	movem.l	(sp)+,a0
	rts
GetForwardCount						;d0 = forwards on team a2 (high nibble of team data byte 3 at +8)
	movem.l	a0,-(sp)
	movea.l	$1E(a2),a0
	adda.w	$8(a0),a0
	move.b	$3(a0),d0
	lsr.w	#$4,d0		;high nibble = forward count
	andi.w	#$F,d0		;forward count
	movem.l	(sp)+,a0
	rts
GetPlayerCount
	movem.l	a0,-(sp)
	movea.l	$1E(a2),a0
	adda.w	$0(a0),a0
	clr.w	d0
.loop	addi.w	#$1,d0
	adda.w	(a0),a0
	adda.w	#$8,a0
	cmpi.w	#$2,(a0)
	bne.w	.loop
	movem.l	(sp)+,a0
	rts
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_13DE2.bin
