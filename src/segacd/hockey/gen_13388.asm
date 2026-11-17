GetStatColumn						;d2 = stat column d1 for player d0. Goalies only have PIM (btst d1,#6
									;picks the columns kept)
	move.w	d0,-(sp)
	bsr.w	GetGoalieCount
	move.w	d0,d2
	move.w	(sp)+,d0
	cmp.w	d2,d0		;goalie?
	bge.w	Sub_2E3A4		;skater: read the column as is
	clr.w	d2		;goalie: columns 1 and 2 (A, Pts) show column 1 (assists), the rest 0
	dc.w	$033C,$0006,$6700
	dc.w	$15E8
ReadStatColumn						;d2 = stat column d1 for player d0. d7 = 0: the team struct byte arrays
									;(StatColumnOffsets); d7 = 1: the playoff tables (GetStatsValue)
	moveq	#$1,d1
Sub_2E3A4
	tst.w	d7
	bne.w	.l133D2
	dc.w	$43FA,$0076
	asl.w	#$2,d1
	adda.w	d1,a1
	clr.l	d1
	move.w	(a1),d1
	add.w	d0,d1
	clr.l	d2
	move.b	(a2,d1.l),d2
	move.w	$2(a1),d1
	bmi.w	Sub_2F988
	add.w	d0,d1
	clr.w	d3
	move.b	(a2,d1.l),d3
	add.w	d3,d2
	rts
.l133D2	asl.w	#$2,d1
	add.w	d0,d0
	clr.w	d2
	bsr.w	.l133E8
	addi.w	#$2,d1
	bsr.w	.l133E8
	lsr.w	#$1,d0
	rts
.l133E8	movea.l	#$2E40E,a1
	tst.w	(a1,d1.w)
	beq.w	Sub_2F988
	movea.w	(a1,d1.w),a1
	move.l	d7,-(sp)
	move.l	a1,d7
	andi.l	#$FFFF,d7
	movea.l	d7,a1
	move.l	(sp)+,d7
	add.w	(a1,d0.w),d2
	rts
	dc.w	$B000,$0000,$B034,$0000,$B000,$B034,$B068,$0000
	dc.w	$B09C,$0000,$00B6,$FFFF,$00D0,$FFFF,$00B6,$00D0
	dc.w	$00EA,$FFFF,$0104,$FFFF,$0016,$5361,$7665,$7320
	dc.w	$5368,$6F74,$7320,$5361,$7665,$2025,$2020,$0006
	dc.w	$2020,$2047,$0006,$2020,$2041,$0006,$2050,$7473
	dc.w	$0006,$2053,$4F47,$0006,$2050,$494D,$0016,$2020
	dc.w	$2020,$476F,$616C,$6965,$2053,$6176,$6573,$2020
	dc.w	$205D,$0016,$5B20,$2020,$2020,$2047,$6F61,$6C73
	dc.w	$2020,$2020,$2020,$205D,$0016,$5B20,$2020,$2020
	dc.w	$4173,$7369,$7374,$7320,$2020,$2020,$205D,$0016
	dc.w	$5B20,$2020,$2020,$2050,$6F69,$6E74,$7320,$2020
	dc.w	$2020,$205D,$0016,$5B20,$2053,$686F,$7473,$204F
	dc.w	$6E20,$476F,$616C,$2020,$205D,$0016,$5B20,$5065
	dc.w	$6E61,$6C74,$7920,$4D69,$6E75,$7465,$7320,$2020
Sub_2E4EE
	movem.l	d0-d1/a1,-(sp)
	dc.w	$4EB9,$0003,$8D8C
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
	dc.w	$43FA,$000E
	dc.w	$4EB9,$0003,$CEBE
	movem.l	(sp)+,d0-d1/a1
	rts
	dc.w	$000A
CrowdMeterScreen						;"Crowd Meter": current, average and peak level (PrintCrowdMeter), plus
									;the arena and league records; start exits. Menu item handler
	dc.w	$20FB,$FFFA,$0C20,$F900,$000A
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_1353A.bin
Sub_2E728
	movem.l	d0-d1/a2,-(sp)
	dc.w	$4EB9,$0003,$6D0A
	bclr	#$0,(disflags).l
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	dc.w	$3039,$0001,$8D32
	dc.w	$4EB9,$0003,$871E
.l13754	btst	#$7,$FF800E.l
	bne.b	.l13754
	dc.w	$23FC,$0000,$0000,$00FF,$8022
	move.w	#$E,$FF8020.l
	bset	#$6,$FF800F.l
.l13778	btst	#$6,$FF800E.l
	beq.b	.l13778
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l13792	btst	#$6,$FF800E.l
	bne.b	.l13792
	bclr	#$7,$FF800F.l
.l137A4	btst	#$7,$FF800E.l
	bne.b	.l137A4
	move.w	#$8C81,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.l137C6	btst	#$6,$FF800E.l
	beq.b	.l137C6
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l137E0	btst	#$6,$FF800E.l
	bne.b	.l137E0
	bclr	#$7,$FF800F.l
	move.w	#$6,$18D3E.l
.l137FA	btst	#$7,$FF800E.l
	bne.b	.l137FA
	move.w	#$8D00,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.l1381C	btst	#$6,$FF800E.l
	beq.b	.l1381C
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l13836	btst	#$6,$FF800E.l
	bne.b	.l13836
	bclr	#$7,$FF800F.l
	clr.w	d0
	dc.w	$4EB9,$0003,$871E
.l13850	btst	#$7,$FF800E.l
	bne.b	.l13850
	dc.w	$23FC,$0000,$0000,$00FF,$8022
	move.w	#$E,$FF8020.l
	bset	#$6,$FF800F.l
.l13874	btst	#$6,$FF800E.l
	beq.b	.l13874
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l1388E	btst	#$6,$FF800E.l
	bne.b	.l1388E
	bclr	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	bclr	#$1,(disflags).l
	move.w	(framercset).l,d4
	movea.l	(FramerMap).l,a2
	addq.l	#$8,a2
	dc.w	$4EB9,$0003,$8946
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
Sub_2E980
	dc.w	$4EB9,$0003,$6D0A
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	move.w	$18D30.l,d0
	dc.w	$4EB9,$0003,$871E
.l139A0	btst	#$7,$FF800E.l
	bne.b	.l139A0
	dc.w	$23FC,$0000,$0000,$00FF,$8022
	move.w	#$E,$FF8020.l
	bset	#$6,$FF800F.l
.l139C4	btst	#$6,$FF800E.l
	beq.b	.l139C4
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l139DE	btst	#$6,$FF800E.l
	bne.b	.l139DE
	bclr	#$7,$FF800F.l
	move.w	#$8D00,d0
	move.b	$18D30.l,d0
	lsr.b	#$2,d0
.l139FC	btst	#$7,$FF800E.l
	bne.b	.l139FC
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.l13A1C	btst	#$6,$FF800E.l
	beq.b	.l13A1C
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l13A36	btst	#$6,$FF800E.l
	bne.b	.l13A36
	bclr	#$7,$FF800F.l
.l13A48	btst	#$7,$FF800E.l
	bne.b	.l13A48
	move.w	#$8C00,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.l13A6A	btst	#$6,$FF800E.l
	beq.b	.l13A6A
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l13A84	btst	#$6,$FF800E.l
	bne.b	.l13A84
	bclr	#$7,$FF800F.l
	move.w	#$5,$18D3E.l
.l13A9E	tst.w	(palcount).l
	bpl.w	.l13A9E
	move.w	(sp)+,(disflags).l
	bset	#$1,(disflags).l
	dc.w	$3839,$0001,$8D48
	movea.l	$47D18.l,a2
	addq.l	#$8,a2
	btst	#$4,$17F72.l
	beq.w	.l13AD8
	movea.l	$47D64.l,a2
	addq.l	#$8,a2
.l13AD8	jsr	(DecompressGraphicsPlain).l
	jsr	$2A9D0.l
	dc.w	$3839,$0001,$8D42
	movea.l	(SmallFontMap).l,a2
	addq.l	#$8,a2
	dc.w	$4EB9,$0003,$8946
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
Sub_2EDBC
	movem.l	a0,-(sp)
	movea.l	$1E(a2),a0
	adda.w	$0(a0),a0
	clr.w	d0
.l13DCA	addi.w	#$1,d0
	adda.w	(a0),a0
	adda.w	#$8,a0
	cmpi.w	#$2,(a0)
	bne.w	.l13DCA
	movem.l	(sp)+,a0
	rts
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_13DE2.bin
