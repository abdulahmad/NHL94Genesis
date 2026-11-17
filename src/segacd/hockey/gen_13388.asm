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
	dc.b	$7B,$FB,$FF,$FA,$0C,$20,$F9,$00,$00,$0A,$20,$FB,$FF,$FA,$0C,$7D	; {.... .... ....}
	dc.b	$F9,$00,$00,$0A,$7B,$FB,$FF,$FA,$0C,$7D,$F9,$00,$70,$09,$72,$1C	; ....{....}..p.r.
	dc.b	$61,$00,$01,$CC,$4E,$B9,$00,$03,$8F,$6E,$00,$06,$BD,$06,$01,$00	; a...N....n......
	dc.b	$70,$1C,$72,$06,$4E,$B9,$00,$03,$8C,$A0,$4E,$B9,$00,$03,$92,$58	; p.r.N.....N....X
	dc.b	$00,$14,$BD,$09,$04,$43,$72,$6F,$77,$64,$20,$20,$4D,$65,$74,$65	; .....Crowd  Mete
	dc.b	$72,$BD,$07,$01,$70,$2C,$61,$00,$E0,$0C,$06,$79,$00,$04,$00,$01	; r...p,a....y....
	dc.b	$8D,$58,$42,$40,$61,$00,$DF,$FE,$61,$00,$00,$12,$61,$00,$08,$3A	; .XB@a...a...a..:
	dc.b	$08,$01,$00,$07,$66,$00,$03,$D0,$60,$00,$FF,$F2,$4E,$B9,$00,$03	; ....f...`...N...
	dc.b	$8D,$8C,$00,$16,$F8,$04,$02,$04,$0C,$43,$75,$72,$72,$65,$6E,$74	; .........Current
	dc.b	$20,$4C,$65,$76,$65,$6C,$FD,$1C,$30,$39,$00,$01,$7C,$D8,$61,$00	;  Level..09..|.a.
	dc.b	$01,$24,$4E,$B9,$00,$03,$8D,$8C,$00,$16,$FD,$04,$FA,$02,$41,$76	; .$N...........Av
	dc.b	$65,$72,$61,$67,$65,$20,$4C,$65,$76,$65,$6C,$FD,$1C,$00,$20,$39	; erage Level... 9
	dc.b	$00,$01,$7C,$DE,$80,$F9,$00,$01,$7C,$DC,$61,$00,$00,$F8,$4E,$B9	; ..|.....|.a...N.
	dc.b	$00,$03,$8D,$8C,$00,$12,$FD,$04,$FA,$02,$50,$65,$61,$6B,$20,$4C	; ..........Peak L
	dc.b	$65,$76,$65,$6C,$FD,$1C,$30,$39,$00,$01,$7C,$DA,$61,$00,$00,$D6	; evel..09..|.a...
L2E62A	movem.l	d0-d7/a0-a6,-(sp)
	tst.w	$193BA.l
	bmi.w	L2E6F8
	move.w	$17FAE.l,d1
	ext.l	d1
	movea.l	#$BC000,a0
	jsr	$2258E.l
	move.b	$8(a0),d0
	bne.w	.next
	move.b	#$50,d0
.next	andi.w	#$FF,d0
	move.w	d0,-(sp)
	jsr	$38D8C.l
	dc.b	$00,$14,$FD,$04,$FA,$02,$41,$72,$65,$6E,$61,$20,$52,$65,$63,$6F	; ......Arena Reco
	dc.b	$72,$64,$FD,$1C	; rd..
	move.w	(sp)+,d0
	move.w	#$3,d1
	jsr	$3919A.l
	jsr	$38F80.l
	jsr	$38F6E.l
	dc.b	$00,$06,$20,$64,$42,$00	; .. dB.
	jsr	$2AC02.l
	move.w	d0,d1
	ext.l	d1
	movea.l	#$BC000,a0
	jsr	$2258E.l
	move.b	$8(a0),d0
	bne.w	.next2
	move.w	#$50,d0
.next2	andi.w	#$FF,d0
	move.w	d0,-(sp)
	jsr	$38D8C.l
	dc.b	$00,$16,$FD,$04,$FA,$02,$4C,$65,$61,$67,$75,$65,$20,$52,$65,$63	; ......League Rec
	dc.b	$6F,$72,$64,$FD,$1C,$00	; ord...
	move.w	(sp)+,d0
	move.w	#$3,d1
	jsr	$3919A.l
	jsr	$38F80.l
	jsr	$38F6E.l
	dc.b	$00,$06,$20,$64,$42,$00	; .. dB.
L2E6F8	movem.l	(sp)+,d0-d7/a0-a6
	rts
	ext.l	d0
	asl.w	#$2,d0
	jsr	$3708E.l
	addi.w	#$41,d0
	moveq	#$3,d1
	jsr	$3919A.l
	jsr	$38F80.l
	jsr	$38F6E.l
	dc.b	$00,$06,$20,$64,$42,$00	; .. dB.
	rts
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
	move.w	$18D4E.l,d4
	jsr	$393FA.l
	jsr	$3EC78.l
	jsr	$3EC94.l
	jsr	$3ECA6.l
	jsr	$3EC60.l
	jmp	$3F24C.l
	dc.b	$04,$79,$00,$01,$00,$01,$8A,$D2,$04,$79,$00,$01,$00,$01,$8A,$D4	; .y.......y......
	dc.b	$23,$FC,$00,$04,$20,$DC,$00,$01,$8A,$D6,$08,$EA,$00,$02,$00,$32	; #... ..........2
	dc.b	$4E,$B9,$00,$03,$8F,$6E,$00,$06,$BD,$05,$0C,$00,$70,$16,$72,$06	; N....n......p.r.
	dc.b	$4E,$B9,$00,$03,$8C,$A0,$4E,$B9,$00,$03,$8F,$6E,$00,$10,$BD,$0C	; N.....N....n....
	dc.b	$0E,$54,$69,$6D,$65,$6F,$75,$74,$BD,$11,$0F,$00,$22,$6A,$00,$1E	; .Timeout...."j..
	dc.b	$D2,$E9,$00,$04,$30,$11,$E2,$48,$91,$79,$00,$01,$8D,$58,$4E,$B9	; ....0..H.y...XN.
	dc.b	$00,$03,$8F,$80,$24,$7C,$00,$01,$83,$4C,$4E,$B9,$00,$03,$C9,$B6	; ....$|...LN.....
	dc.b	$D5,$FC,$00,$00,$03,$66,$4E,$B9,$00,$03,$C9,$B6,$70,$78,$4E,$F9	; .....fN.....pxN.
	dc.b	$00,$03,$72,$D0,$3F,$39,$00,$01,$8A,$D2,$3F,$39,$00,$01,$8A,$D4	; ..r.?9....?9....
	dc.b	$61,$00,$01,$A4,$33,$C0,$00,$01,$8A,$D4,$4E,$B9,$00,$03,$8F,$6E	; a...3.....N....n
	dc.b	$00,$06,$BD,$04,$0C,$00,$70,$18,$72,$03,$D2,$79,$00,$01,$8A,$D4	; ......p.r..y....
	dc.b	$4E,$B9,$00,$03,$8C,$A0,$30,$2A,$00,$28,$6A,$00,$00,$04,$70,$FF	; N.....0*.(j...p.
	dc.b	$06,$40,$00,$01,$33,$C0,$00,$01,$8A,$D2,$61,$00,$00,$84,$61,$00	; .@..3.....a...a.
	dc.b	$01,$E8,$08,$01,$00,$07,$66,$00,$00,$48,$08,$01,$00,$05,$66,$00	; ......f..H....f.
	dc.b	$00,$40,$08,$01,$00,$01,$67,$00,$00,$1A,$30,$39,$00,$01,$8A,$D2	; .@....g...09....
	dc.b	$52,$40,$B0,$79,$00,$01,$8A,$D4,$6E,$00,$FF,$D0,$33,$C0,$00,$01	; R@.y....n...3...
	dc.b	$8A,$D2,$08,$01,$00,$00,$67,$00,$FF,$C2,$04,$79,$00,$01,$00,$01	; ......g....y....
	dc.b	$8A,$D2,$6A,$00,$FF,$B6,$42,$79,$00,$01,$8A,$D2,$60,$00,$FF,$AC	; ..j...By....`...
	dc.b	$30,$39,$00,$01,$8A,$D2,$04,$40,$00,$01,$6A,$00,$00,$0C,$0C,$6A	; 09.....@..j....j
	dc.b	$FF,$FF,$00,$28,$6D,$00,$00,$0C,$35,$40,$00,$28,$4E,$B9,$00,$03	; ...(m...5@.(N...
	dc.b	$D4,$26,$33,$DF,$00,$01,$8A,$D4,$33,$DF,$00,$01,$8A,$D2,$4E,$75	; .&3.....3.....Nu
L2EC7A	move.w	#$D,$18D5A.l
	move.w	$18AD4.l,d1
	moveq	#$0,d0
L2EC8A	move.w	#$5,$18D58.l
	move.w	#$A000,$18D5C.l
	cmp.w	$18AD2.l,d0
	bne.w	.next
	move.w	#$8000,$18D5C.l
.next	jsr	$38F6E.l
	dc.b	$00,$18,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20	; ..              
	dc.b	$20,$20,$20,$20,$20,$20,$20,$20	;         
L2ECCA	tst.w	d0
	bne.w	L2ECEE
	move.w	#$B,$18D58.l
	jsr	$38F6E.l
	dc.b	$00,$0C,$6E,$6F,$20,$67,$6F,$61,$6C,$69,$65,$00	; ..no goalie.
	bra.w	L13D4E
L2ECEE	movea.l	$1E(a2),a1
	adda.w	$0(a1),a1
	move.w	d0,d2
	subi.w	#$1,d2
	bra.w	.next
.loop	adda.w	(a1),a1
	adda.w	#$8,a1
.next	dbra	d2,.loop
	move.w	#$8,$18D58.l
	jsr	$38F80.l
	move.b	(a1),d2
	lsr.b	#$4,d2
	addi.b	#$30,d2
	move.b	d2,$17EF4.l
	move.b	(a1),d2
	andi.b	#$F,d2
	addi.b	#$30,d2
	move.b	d2,$17EF5.l
	movea.l	#$17EF2,a1
	move.w	#$4,(a1)
	move.w	#$5,$18D58.l
	jsr	$38F80.l
L13D4E	addi.w	#$1,$18D5A.l
	addi.w	#$1,d0
	dbra	d1,L2EC8A
	rts
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
L2EDE2	move.w	$17474.l,d1
.loop	cmp.w	$17474.l,d1
	beq.w	.loop
	dc.w	$6100,$04FC
	jsr	$37496.l
	tst.b	d1
	beq.w	L2EDE2
	rts
	bclr.b	#$0,$17F74.l
	bsr.w	forceblack
	move.w	$18D64.l,-(sp)
	bset.b	#$3,$17F6C.l
	bclr.b	#$4,$17F72.l
	jsr	$3C3AC.l
	move.w	#$400,d0
	move.w	$18D3C.l,d1
	move.w	#$7FF,d2
	jsr	$37AA2.l
	move.w	$18D56.l,d4
	movea.l	$47D68.l,a2
	addq.l	#$8,a2
	jsr	$38958.l
	jsr	$2F330.l
	bclr.b	#$5,$17F6A.l
	bclr.b	#$5,$17F6E.l
	st.b	$17D6E.l
	movea.l	$17470.l,a4
.loop2	bsr.w	suba4
	tst.w	d7
	bne.w	.loop2
	jsr	$3F03E.l
	jsr	$3DD16.l
	bclr.b	#$1,$17F6E.l
	clr.l	$17DCA.l
	clr.l	$17DCE.l
	clr.l	$17DD2.l
	move.w	#$18,$18D62.l
	moveq	#$1,d7
L2EEB0	move.w	$17474.l,d0
	sub.w	$17476.l,d0
	cmp.w	d0,d7
	bhi.w	L2EEB0
	move.w	$17474.l,$17476.l
	tst.w	$1AD56.l
	bmi.w	.next
	sub.w	d7,$1AD56.l
	bpl.w	.next
	clr.w	$1AD56.l
	jsr	$2F37E.l
.next	movem.l	d0/a3,-(sp)
	movea.l	#$17A80,a3
	move.w	#$1,$8(a3)
	movea.l	#$17B00,a3
	move.w	#$1,$8(a3)
	movem.l	(sp)+,d0/a3
	moveq	#$1,d7
	dc.w	$6100,$03E0
	btst.b	#$0,$17F74.l
	beq.w	.next2
	andi.w	#$FFF0,d0
	ori.w	#$8,d0
	andi.w	#$FFF0,d1
	andi.w	#$FFF0,d3
.next2	movea.l	#$17D58,a5
	btst.b	#$5,$17F6E.l
	beq.w	.next3
	move.w	d1,d5
	andi.w	#$F,d5
	beq.w	L2F0F8
.next3	btst	#$3,d0
	bne.w	L2F0F8
	cmpi.w	#$FF60,$0(a5)
	bgt.w	.next4
	move.w	#$0,$0(a5)
	bra.w	.next4
.next4	cmpi.w	#$FED0,$14(a5)
	bgt.w	.next5
	move.w	#$0,$14(a5)
.next5	bset.b	#$5,$17F6A.l
	bne.w	.next6
	move.w	$17CEE.l,$0(a5)
	move.w	$17CEA.l,$14(a5)
.next6	move.w	d0,d5
	andi.w	#$7,d5
	eori.w	#$4,d5
	movea.l	#$17480,a1
	st.b	d3
	bclr.b	#$5,$17F6E.l
	beq.w	.next7
	move.w	$16(a5),d3
.next7	move.w	$0(a5),d0
	move.w	$14(a5),d1
	moveq	#$B,d2
	move.l	#$100,d4
	movem.w	d0-d1,-(sp)
.loop	cmp.w	$52(a1),d3
	beq.w	.next8
	movem.w	(sp),d0-d1
	sub.w	$0(a1),d0
	sub.w	$14(a1),d1
	jsr	$362F8.l
	btst	#$3,d0
	bne.w	.next8
	sub.w	d5,d0
	addi.w	#$1,d0
	andi.w	#$7,d0
	cmpi.w	#$2,d0
	bhi.w	.next8
	movem.w	(sp),d0-d1
	sub.w	$0(a1),d0
	sub.w	$14(a1),d1
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	cmpi.l	#$4,d0
	bls.w	.next8
	cmp.l	d4,d0
	bhi.w	.next8
	move.l	d0,d4
	move.w	$52(a1),$16(a5)
	bset.b	#$5,$17F6E.l
.next8	adda.l	#$80,a1
	dbra	d2,.loop
	adda.w	#$4,sp
	btst.b	#$5,$17F6E.l
	beq.w	.next9
	move.w	$16(a5),d0
	asl.w	#$7,d0
	movea.l	#$17480,a3
	adda.w	d0,a3
	moveq	#$4,d4
	bsr.w	setpads
	bsr.w	UpdateCameraPos
	jsr	$3DD16.l
	bra.w	L2EEB0
.next9	bset.b	#$5,$17F6A.l
	eori.w	#$4,d5
	asl.w	#$2,d5
	lea.l	L2F0D8(pc),a0
	move.w	(a0,d5.w),d0
	add.w	$0(a5),d0
	cmpi.w	#$88,d0
	bgt.w	.next10
	cmpi.w	#$FF78,d0
	blt.w	.next10
	move.w	d0,$0(a5)
.next10	move.w	$2(a0,d5.w),d1
	add.w	$14(a5),d1
	cmpi.w	#$126,d1
	bgt.w	.next11
	cmpi.w	#$FEDA,d1
	blt.w	.next11
	move.w	d1,$14(a5)
.next11	movea.l	a5,a3
	clr.w	$18(a5)
	andi.w	#$FFF,$17DC8.l
	ori.w	#$E000,$17DC8.l
	bsr.w	UpdateCameraPos
	jsr	$3DD16.l
	bra.w	L2EEB0
L2F0D8	dc.b	$00,$00,$00,$02,$00,$02,$00,$02,$00,$02,$00,$00,$00,$02,$FF,$FE	; ................
	dc.b	$00,$00,$FF,$FE,$FF,$FE,$FF,$FE,$FF,$FE,$00,$00,$FF,$FE,$00,$02	; ................
L2F0F8	st.b	$18(a5)
	btst	#$5,d1
	beq.w	.next
	btst.b	#$0,$17F74.l
	bne.w	.next
	bchg.b	#$1,$17F6E.l
.next	btst	#$6,d3
	beq.w	.next2
	btst.b	#$0,$17F74.l
	bne.w	.next2
	bsr.w	suba4
	bsr.w	suba4
	bsr.w	suba4
	bsr.w	suba4
	jsr	$3F03E.l
	jsr	$3DD16.l
	moveq	#$1,d7
	bclr.b	#$1,$17F6E.l
.next2	btst.b	#$0,$17F74.l
	bne.w	.next4
	btst	#$4,d3
	beq.w	.next4
	btst	#$6,d3
	beq.w	.next3
	bclr.b	#$5,$17F6E.l
	bclr.b	#$5,$17F6A.l
	move.w	d0,-(sp)
	move.w	$17DC8.l,d0
	andi.w	#$FFF,d0
	ori.w	#$E000,d0
	move.w	d0,$17DC8.l
	move.w	(sp)+,d0
	bra.w	L2EEB0
.next3	bsr.w	adda4
	jsr	$3F03E.l
	jsr	$3DD16.l
	asl.w	#$1,d7
	bclr.b	#$1,$17F6E.l
.next4	btst.b	#$1,$17F6E.l
	beq.w	.next5
	st.b	$17F64.l
	bsr.w	adda4
	move.w	$17F64.l,-(sp)
	bsr.w	sfx
	jsr	$3F03E.l
.next5	jsr	$3DD16.l
	btst.b	#$0,$17F74.l
	bne.w	.next6
	btst	#$7,d1
	beq.w	L2EEB0
	jsr	$2F39C.l
	bclr.b	#$1,$17F6E.l
	bset.b	#$0,$17F74.l
	bne.w	.next6
	bra.w	L2EEB0
.next6	btst	#$7,d1
	bne.w	.next8
	btst	#$6,d1
	bne.w	.next7
	btst	#$4,d1
	bne.w	.next9
	btst	#$5,d1
	beq.w	L2EEB0
	bset.b	#$6,$17F72.l
	bclr.b	#$0,$17F74.l
	jsr	$2F3D6.l
	bsr.w	adda4
	jsr	$3F03E.l
	bra.w	L2EEB0
.next7	jmp	$2EEB0.l
.next8	clr.w	$18AD2.l
	bset.b	#$1,$17F74.l
.next9	bsr.w	forceblack
	ori.w	#$F000,$17DC8.l
	bclr.b	#$5,$17F6A.l
	movea.l	$17470.l,a4
	bclr.b	#$4,$17F72.l
	bsr.w	RestoreReplayFrameCopy
	jsr	$3F03E.l
	bclr.b	#$3,$17F6C.l
	move.w	(sp)+,$18D64.l
	jsr	$2E986.l
	jsr	$3EC78.l
	jsr	$3EC94.l
	jsr	$3ECA6.l
	jsr	$3ECCA.l
	btst.b	#$4,$18D64.l
	beq.w	.next10
	jsr	$3ECEE.l
	jsr	$3ECDC.l
.next10	jsr	$3C40A.l
	jsr	$3DD16.l
	move.w	#$18,$18D62.l
	rts
