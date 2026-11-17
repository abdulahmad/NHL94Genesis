limitfo
	movem.l	d0-d1/a0-a1,-(sp)
	dc.w	$207C,$0001,$8022
L1EB4E	bsr.w	L1EB62
	adda.w	#$2,a0
	tst.w	(a0)
	bne.w	L1EB4E
	movem.l	(sp)+,d0-d1/a0-a1
	rts
L1EB62	move.b	$1(a0),d0
	andi.w	#$7F,d0
	asl.w	#$7,d0
	dc.w	$227C,$0001,$7480
	move.w	#$58,d1
	btst	#$7,$62(a1,d0.w)
	bne.w	L1EB98
	neg.w	d1
	cmp.w	$17EE4.l,d1
	blt.w	rtss2
	move.w	#$FFBF,$17EE4.l
	bra.w	L1EBAA
L1EB98	cmp.w	$17EE4.l,d1
	bgt.w	rtss2
	move.w	#$41,$17EE4.l
L1EBAA	move.w	#$46,d0
	tst.w	$17EE2.l
	bpl.w	L1EBBA
	neg.w	d0
L1EBBA	move.w	d0,$17EE2.l
	rts
UpdatePA
	dc.w	$4A79,$0001,$806E
	bmi.w	rtss2
	dc.w	$9F79,$0001,$806E
	bpl.w	L1EBDA
	bsr.w	SetPA2
L1EBDA	dc.w	$0C79,$0004,$0001,$8072
	bne.w	L1EBEA
	bsr.w	ShowThreeStars
L1EBEA	dc.w	$9F79,$0001,$806C
	bpl.w	rtss2
	dc.w	$33FC,$7FFF,$0001,$806C
	bsr.w	ClearPenaltyMessage
	bsr.w	printz
	String	CC_Font1Pri,$11,$B
	bsr.w	GetPlayerName
	move.w	(a1),d0
	lsr.w	#$1,d0
	sub.w	d0,(printx).l
	bra.w	print
Sub_39C1C
	dc.w	$33C0,$0001,$8072
	cmpi.w	#$2E,d0
	blt.w	L1EC2C
	rts
L1EC2C	dc.w	$4279,$0001,$8070
	bsr.w	prefmes
	cmpi.w	#$E,d0
	bne.w	L1EC42
	bsr.w	Sub_40EFA
L1EC42	btst	#$0,$17F78.l
	beq.w	L1EC60
	btst	#$3,$17F78.l
	beq.w	L1EC60
	jsr	(ShootoutWonBy).l
L1EC60	dc.w	$33FC,$7FFF,$0001,$806C
	btst	#$7,$17F6A.l
	beq.w	SetPA2
	dc.w	$33FC,$003C,$0001,$806C
SetPA2
	movem.l	d0-d2/a0-a1,-(sp)
	moveq	#$40,d0
	dc.w	$4A79,$0001,$8070
	bmi.w	L1ECF8
	dc.w	$3039,$0001,$8070
	dc.w	$0679,$0002,$0001,$8070
	dc.w	$3239,$0001,$8072
	dc.w	$207C,$0004,$165C
	adda.w	(a0,d1.w),a0
	adda.w	#$2,a0
	adda.w	(a0),a0
	move.w	(a0,d0.w),d0
	bpl.w	L1ECC0
	neg.w	d0
	dc.w	$50F9,$0001,$8070
L1ECC0	clr.w	d1
	move.b	d0,d1
	asl.w	#$3,d1
	dc.w	$33C1,$0001,$806E
	btst	#$0,$17F78.l
	beq.w	L1ECF6
	btst	#$3,$17F78.l
	beq.w	L1ECF6
	move.w	d0,-(sp)
	dc.w	$3039,$0001,$806E
	add.w	d0,d0
	dc.w	$33C0,$0001,$806E
	move.w	(sp)+,d0
L1ECF6	lsr.w	#$8,d0
L1ECF8	bsr.w	PushRef
	movem.l	(sp)+,d0-d2/a0-a1
	rts
PushRef
	movem.l	d0-d2/a0-a1,-(sp)
	cmpi.w	#$40,d0
	beq.w	L1ED66
	mulu.w	#$70,d0
	movea.l	$47D1C.l,a0
	btst	#$7,$17F6A.l
	beq.w	L1ED2A
	movea.l	$47D20.l,a0
L1ED2A	adda.l	$4(a0),a0
	adda.w	#$4,a0
	adda.w	d0,a0
	movea.l	#$18074,a1
	dc.w	$3439,$0001,$8D56
	btst	#$7,$17F6A.l
	bne.w	L1ED50
	ori.w	#$8000,d2
L1ED50	moveq	#$37,d0
L1ED52	move.w	(a0)+,(a1)
	add.w	d2,(a1)+
	dbra	d0,L1ED52
	bset	#$1,$17F6C.l
	bra.w	L1ED90
L1ED66	btst	#$7,$17F6A.l
	bne.w	L1ED8A
	movea.l	#$18074,a1
	moveq	#$37,d0
L1ED7A	move.w	#$7FF,(a1)+
	dbra	d0,L1ED7A
	bset	#$1,$17F6C.l
L1ED8A	moveq	#-1,d0
	bsr.w	prefmes
L1ED90	movem.l	(sp)+,d0-d2/a0-a1
	rts
prefmes
	movem.l	d0-d2/a1,-(sp)
	btst	#$7,$17F6A.l
	bne.w	L1EE26
	tst.w	d0
	bpl.w	L1EDC6
	bsr.w	printz
	String	CC_Font1Pri,$0,$A
	moveq	#$D,d0
	moveq	#$3,d1
	move.w	#$7FF,d2
	bsr.w	eraser
	bra.w	L1EE56
L1EDC6	bsr.w	printz
	String	CC_Font1Pri,$5,$A
	dc.w	$227C,$0004,$165C
	adda.w	(a1,d0.w),a1
	adda.w	#$2,a1
	move.w	(a1),d0
	subi.w	#$2,d0
	beq.w	L1EE56
	lsr.w	#$1,d0
	sub.w	d0,(printx).l
	bpl.w	L1EDFA
	clr.w	(printx).l
L1EDFA	move.w	(a1),d0
	tst.b	-$1(a1,d0.w)
	bne.w	L1EE08
	subi.w	#$1,d0
L1EE08	moveq	#$3,d1
	bsr.w	Framer
	subi.w	#$2,(printy).l
	addi.w	#$1,(printx).l
	bsr.w	print
	bra.w	L1EE56
L1EE26	bsr.w	ClearPenaltyMessage
	tst.w	d0
	bmi.w	L1EE56
	bsr.w	printz
	String	CC_Font1Pri,$11,$B
	dc.w	$227C,$0004,$165C
	adda.w	(a1,d0.w),a1
	adda.w	#$2,a1
	move.w	(a1),d0
	lsr.w	#$1,d0
	sub.w	d0,(printx).l
	bsr.w	print
L1EE56	movem.l	(sp)+,d0-d2/a1
	rts
ClearPenaltyMessage
	bsr.w	printz
	String	CC_Font1Pri,$5,$B,'                      '
	rts
PenGoalStuff
	movem.l	d0-d2/a0,-(sp)
	cmpi.w	#$6,$26(a1)
	bne.w	L1EE90
	bsr.w	ClearPenaltyBuffer
L1EE90	move.w	$26(a2),d2
	cmp.w	$26(a1),d2
	ble.w	L1EEDE
	lea.l	$9C(a1),a0
L1EEA0	clr.w	d2
	move.b	(a0)+,d2
	bmi.w	L1EEDE
	btst	#$6,$68(a1,d2.w)
	bne.w	L1EEA0
	clr.w	$68(a1,d2.w)
	bsr.w	L1EFEC
	bset	#$0,$17F7E.l
	addi.w	#$1,$26(a1)
	addi.w	#$1,$2(a2)
	bset	#$0,$1837E.l
	bset	#$0,$186E4.l
L1EEDE	movem.l	(sp)+,d0-d2/a0
	rts
ClearPenaltyBuffer
	moveq	#$1F,d0
	dc.w	$207C,$0001,$8022
L1EEEC	clr.w	(a0)+
	dbra	d0,L1EEEC
	rts
updatepentime
	bclr	#$6,$17F6E.l
	btst	#$0,$17F68.l
	bne.w	rtss2
	dc.w	$9F79,$0001,$8066
	bpl.w	rtss2
	dc.w	$0679,$0018,$0001,$8066
	bset	#$6,$17F6E.l
	bsr.w	chkatop
	jsr	(updatePPTeamTime).l
	movea.l	#tmstruct,a2
	bsr.w	updatepentime_ut
	adda.w	#$366,a2
updatepentime_ut
	lea.l	$9C(a2),a0
	movea.l	#mesarea,a1
	moveq	#$2,d1
	moveq	#$2,d3
L1EF48	clr.w	d0
	move.b	(a0)+,d0
	bmi.w	L1EF76
	btst	#$6,$68(a2,d0.w)
	bne.w	L1EFC4
	subi.w	#$1,d1
	bmi.w	L1EF48
	move.w	d0,(a1)+
	subi.w	#$1,$68(a2,d0.w)
	bne.w	L1EF72
	bsr.w	L1EFEC
L1EF72	bra.w	L1EF48
L1EF76	move.w	(mesarea).l,d0
	cmpi.w	#$1,d1
	beq.w	L1EFA0
	tst.w	d1
	bne.w	L1EF92
	bsr.w	L1EFA0
	bra.w	L1EF9A
L1EF92	cmpi.w	#$FFFF,d1
	bne.w	rtss2
L1EF9A	move.w	(TextBuffer).l,d0
L1EFA0	cmpi.w	#$5,$68(a2,d0.w)
	bgt.w	rtss2
	move.w	#$1,-(sp)
	tst.w	$68(a2,d0.w)
	bne.w	L1EFBE
	bsr.w	releasepl
	move.w	#$2,(sp)
L1EFBE	bsr.w	sfx
	rts
L1EFC4	subi.w	#$1,$68(a2,d0.w)
	btst	#$3,$68(a2,d0.w)
	beq.w	L1EF48
	btst	#$4,$68(a2,d0.w)
	bne.w	RemovePlayerFromList
	move.w	#$1000,$68(a2,d0.w)
	bra.w	L1EFEC
RemovePlayerFromList
	clr.w	$68(a2,d0.w)
L1EFEC	moveq	#-1,d2
L1EFEE	addi.w	#$1,d2
	move.b	(a0,d2.w),-$1(a0,d2.w)
	bpl.w	L1EFEE
	suba.w	#$1,a0
	rts
chkatop
	moveq	#$0,d1
	dc.w	$3039,$0001,$7B94
	cmpi.w	#$58,d0
	bgt.w	L1F022
	move.l	#$366,d1
	neg.w	d0
	cmpi.w	#$58,d0
	blt.w	rtss2
L1F022	btst	#$1,$17F68.l
	beq.w	L1F032
	eori.w	#$366,d1
L1F032	movea.l	#tmstruct,a2
	addi.w	#$1,$A(a2,d1.w)
	rts
releasepl
	movem.l	d0-d3/a0-a3,-(sp)
	movea.l	$22(a2),a3
	suba.w	#$80,a3
L1F04C	adda.w	#$80,a3
	tst.w	$34(a3)
	bpl.w	L1F04C
	move.w	d0,d3
	lsr.w	#$1,d3
	move.w	$26(a2),d1
	addi.w	#$1,$26(a2)
	bset	#$0,$1837E.l
	bset	#$0,$186E4.l
	movea.l	#$41AD6,a0
	tst.w	$28(a2)
	bpl.w	L1F088
	adda.w	#$1,a0
L1F088	clr.w	$34(a3)
	move.b	(a0,d1.w),$35(a3)
	bsr.w	Setplass
	bsr.w	Sub_3D770
	bset	#$2,$63(a3)
	movem.l	(sp)+,d0-d3/a0-a3
	rts
GetLowestPen
	clr.w	d0
	clr.w	d3
	lea.l	$9C(a2),a0
L1F0AE	clr.w	d2
	move.b	(a0)+,d2
	bmi.w	L1F0CC
	move.w	$68(a2,d2.w),d2
	btst	#$E,d2
	bne.w	L1F0AE
	sub.w	d3,d2
	add.w	d2,d0
	move.w	d2,d3
	bra.w	L1F0AE
L1F0CC	cmpi.w	#$6,$26(a3)
	beq.w	rtss2
	sub.w	d3,d0
	lea.l	$9C(a3),a0
	clr.w	d2
L1F0DE	move.b	(a0)+,d2
	bmi.w	rtss2
	btst	#$6,$68(a3,d2.w)
	bne.w	L1F0DE
	cmp.w	$68(a3,d2.w),d0
	blt.w	rtss2
	add.w	d3,d0
	rts
checkcoll
	clr.w	$17EEE.l
	btst	#$7,$17F6A.l
	beq.w	L1F10E
	exg.l	d2,d3
L1F10E	btst	#$2,$62(a3)
	bne.w	L1F180
	movem.l	d0-d7,-(sp)
	move.w	$0(a3),d2
	move.w	$14(a3),d3
	dc.w	$33EB,$004A,$0001,$7CF4
	dc.w	$33EB,$004C,$0001,$7CF6
	bsr.w	checkwallcoll
	move.w	$4E(a3),d0
	or.w	$50(a3),d0
	bne.w	L1F178
	cmpi.w	#$B,$52(a3)
	bgt.w	L1F178
	movem.l	(sp),d0-d7
	move.l	a3,-(sp)
	bsr.w	Sub_36362
	move.w	$0(a3),d2
	move.w	$14(a3),d3
	add.w	d0,d2
	add.w	d1,d3
	dc.w	$33FC,$0001,$0001,$7CF4
	dc.w	$33FC,$0001,$0001,$7CF6
	bsr.w	checkwallcoll
L1F178	movem.l	(sp)+,d0-d7
	bsr.w	checkplcoll
L1F180	tst.w	$17EEE.l
	bne.w	L1F204
	move.w	$52(a3),d0
	asl.w	#$1,d0
	movea.l	#$17CA0,a0
	movea.l	#$17CC0,a1
	movea.l	#$17C80,a2
	move.w	(a0,d0.w),d1
L1F1A6	cmpi.w	#$F,d1
	beq.w	L1F1D2
	clr.w	d4
	move.b	$1(a1,d1.w),d4
	cmp.w	(a2,d4.w),d3
	ble.w	L1F1D2
	addq.w	#$1,(a0,d0.w)
	subq.w	#$1,(a0,d4.w)
	move.b	d4,(a1,d1.w)
	move.b	d0,$1(a1,d1.w)
	addq.w	#$1,d1
	bra.w	L1F1A6
L1F1D2	move.w	(a0,d0.w),d1
	beq.w	L1F1FE
L1F1DA	clr.w	d4
	move.b	-$1(a1,d1.w),d4
	cmp.w	(a2,d4.w),d3
	bge.w	L1F1FE
	subq.w	#$1,(a0,d0.w)
	addq.w	#$1,(a0,d4.w)
	move.b	d4,(a1,d1.w)
	move.b	d0,-$1(a1,d1.w)
	subq.w	#$1,d1
	bne.w	L1F1DA
L1F1FE	move.w	d3,(a2,d0.w)
	rts
L1F204	move.w	$1C(a3),$0(a3)
	move.w	$20(a3),$14(a3)
	rts
checkplcoll
	btst	#$5,$63(a3)
	bne.w	L1F28E
	cmpi.w	#$B,$52(a3)
	bgt.w	L1F28E
	move.w	$52(a3),d0
	asl.w	#$1,d0
	movea.l	#$17CA0,a0
	movea.l	#$17CC0,a1
	movea.l	#$17C80,a2
	move.w	(a0,d0.w),d1
L1F242	cmpi.w	#$F,d1
	beq.w	L1F268
	clr.w	d4
	move.b	$1(a1,d1.w),d4
	move.w	(a2,d4.w),d5
	sub.w	d3,d5
	cmpi.w	#$10,d5
	bgt.w	L1F268
	bsr.w	checkcx
	addq.w	#$1,d1
	bra.w	L1F242
L1F268	move.w	(a0,d0.w),d1
	beq.w	L1F28E
L1F270	clr.w	d4
	move.b	-$1(a1,d1.w),d4
	move.w	d3,d5
	sub.w	(a2,d4.w),d5
	cmpi.w	#$10,d5
	bgt.w	L1F28E
	bsr.w	checkcx
	subq.w	#$1,d1
	bne.w	L1F270
L1F28E	rts
checkcx
	movem.l	d0-d7/a0-a3,-(sp)
	asl.w	#$6,d4
	dc.w	$247C,$0001,$7480
	adda.w	d4,a2
	btst	#$2,$62(a2)
	bne.w	L1F432
	btst	#$5,$63(a2)
	bne.w	L1F432
	cmpi.w	#$B,$52(a2)
	bgt.w	L1F432
	move.w	$0(a2),d0
	btst	#$7,$17F6A.l
	beq.w	L1F2D0
	move.w	$14(a2),d0
L1F2D0	sub.w	d2,d0
	cmpi.w	#$FFF0,d0
	blt.w	L1F432
	cmpi.w	#$10,d0
	bgt.w	L1F432
	muls.w	d5,d5
	muls.w	d0,d0
	add.l	d5,d0
	cmpi.l	#$100,d0
	bgt.w	L1F432
	move.w	#$0,$17EF0.l
	move.b	$62(a3),d6
	move.b	$62(a2),d0
	eor.b	d0,d6
	move.w	$28(a3),d0
	sub.w	$28(a2),d0
	move.w	$2A(a3),d1
	sub.w	$2A(a2),d1
	move.w	$0(a3),d2
	sub.w	$0(a2),d2
	neg.w	d2
	move.w	$14(a3),d3
	sub.w	$14(a2),d3
	neg.w	d3
	movem.w	d0-d1,-(sp)
	muls.w	d3,d1
	muls.w	d2,d0
	add.l	d0,d1
	bmi.w	L1F438
	asr.l	#$4,d1
	btst	#$6,d6
	beq.w	L1F3A4
	move.w	d1,d4
	lsr.w	#$8,d4
	cmpi.w	#$5,d4
	bgt.w	L1F34E
	moveq	#$5,d4
L1F34E	add.w	d4,$32(a3)
	add.w	d4,$32(a2)
	btst	#$0,$63(a2)
	bne.w	L1F366
	move.w	$52(a3),$2E(a2)
L1F366	btst	#$0,$63(a3)
	bne.w	L1F376
	move.w	$52(a2),$2E(a3)
L1F376	cmpi.w	#$14,d4
	blt.w	L1F398
	move.w	$17BE0.l,d0
	cmp.w	$52(a3),d0
	beq.w	L1F394
	cmp.w	$52(a2),d0
	bne.w	L1F398
L1F394	bsr.w	newcheck
L1F398	bsr.w	checkint
	bsr.w	L1F55C
	bsr.w	Sub_3AF3E
L1F3A4	move.w	d1,d4
	movem.w	(sp)+,d0-d1
	tst.w	$17EEE.l
	bmi.w	L1F432
	muls.w	d2,d1
	muls.w	d3,d0
	sub.l	d1,d0
	asr.l	#$4,d0
	move.w	d0,d5
	clr.w	d0
	move.b	$67(a3),d0
	addi.w	#$8C,d0
	clr.w	d1
	move.b	$67(a2),d1
	addi.w	#$8C,d1
	move.w	$17EF0.l,d7
	mulu.w	d1,d7
	lsr.w	#$4,d7
	add.w	d0,d1
	sub.w	d7,d0
	muls.w	d4,d0
	divs.w	d1,d0
	move.w	$17EF0.l,d1
	muls.w	d4,d1
	asr.w	#$4,d1
	add.w	d0,d1
	movem.w	d2-d3,-(sp)
	muls.w	d5,d3
	muls.w	d0,d2
	add.l	d2,d3
	asr.l	#$4,d3
	add.w	$28(a2),d3
	move.w	d3,$28(a3)
	movem.w	(sp),d2-d3
	muls.w	d5,d2
	muls.w	d0,d3
	sub.l	d2,d3
	asr.l	#$4,d3
	add.w	$2A(a2),d3
	move.w	d3,$2A(a3)
	movem.w	(sp)+,d2-d3
	muls.w	d1,d2
	asr.l	#$4,d2
	add.w	d2,$28(a2)
	muls.w	d1,d3
	asr.l	#$4,d3
	add.w	d3,$2A(a2)
	st.b	$17EEE.l
L1F432	movem.l	(sp)+,d0-d7/a0-a3
	rts
L1F438	addq.w	#$4,sp
	bra.w	L1F432
newcheck
	move.l	d0,-(sp)
	moveq	#$3,d0
	bsr.w	randomd0
	addq.w	#$1,d0
	dc.w	$D079,$0001,$7F62
	andi.w	#$3,d0
	dc.w	$33C0,$0001,$7F62
	addi.w	#$1C,d0
	move.w	d0,-(sp)
	bsr.w	sfx
	move.l	(sp)+,d0
	rts
checkint
	move.l	d0,-(sp)
	bsr.w	L1F478
	exg.l	a2,a3
	bsr.w	L1F478
	exg.l	a2,a3
	move.l	(sp)+,d0
	rts
L1F478	tst.w	$34(a2)
	bne.w	rtss2
	btst	#$0,$17F68.l
	bne.w	rtss2
	move.w	$17BE0.l,d0
	cmp.w	$52(a3),d0
	beq.w	L1F4A4
	cmpi.w	#$19,$32(a3)
	ble.w	rtss2
L1F4A4	cmpi.w	#$2,$32(a3)
	ble.w	rtss2
	exg.l	a2,a3
	bsr.w	Sub_3A9BE
	exg.l	a2,a3
	cmpi.w	#$1E,$32(a2)
	ble.w	rtss2
	btst	#$4,$63(a3)
	bne.w	rtss2
	tst.w	$34(a2)
	bne.w	rtss2
	move.w	#$1,d0
	btst	#$6,$62(a3)
	beq.w	L1F4E4
	move.w	#$2,d0
L1F4E4	dc.w	$B079,$0001,$7FA6
	beq.w	L1F4F8
	dc.w	$B079,$0001,$7FA8
	bne.w	L1F502
L1F4F8	btst	#$3,$62(a3)
	beq.w	rtss2
L1F502	move.w	$14(a2),d0
	btst	#$7,$62(a2)
	beq.w	L1F512
	neg.w	d0
L1F512	cmpi.w	#$EF,d0
	blt.w	rtss2
	cmpi.w	#$10A,d0
	bgt.w	rtss2
	move.w	$0(a2),d0
	cmpi.w	#$14,d0
	bgt.w	rtss2
	cmpi.w	#$FFEC,d0
	blt.w	rtss2
	move.w	#$28,d0
	sub.b	$73(a3),d0
	bsr.w	randomd0
	cmpi.w	#$4,d0
	bhi.w	rtss2
	btst	#$4,$17F68.l
	bne.w	rtss2
	moveq	#$22,d0
	bra.w	AddPenalty
L1F55C	movem.l	d0-d4/a0-a3,-(sp)
	bsr.w	L1F570
	exg.l	a2,a3
	bsr.w	L1F570
	movem.l	(sp)+,d0-d4/a0-a3
	rts
L1F570	cmpi.w	#$C90,$58(a2)
	beq.w	Sub_3A822
	cmpi.w	#$1122,$58(a2)
	beq.w	Sub_3A822
	cmpi.w	#$B24,$58(a2)
	beq.w	Sub_3A90A
	cmpi.w	#$C5E,$58(a3)
	bne.w	rtss2
	btst	#$0,$17F68.l
	beq.w	L1F5B0
	move.w	#$100,$32(a3)
	move.w	#$100,$32(a2)
L1F5B0	move.w	$0(a2),d0
	sub.w	$0(a3),d0
	move.w	$14(a2),d1
	sub.w	$14(a3),d1
	bsr.w	vtoa
	sub.w	$54(a3),d0
	andi.w	#$7,d0
	btst	#$3,$4(a3)
	beq.w	L1F5E0
	neg.w	d0
	addi.w	#$8,d0
	andi.w	#$7,d0
L1F5E0	asl.w	#$1,d0
	dc.w	$41FA,$0168
	move.w	(a0,d0.w),d1
	bset	#$5,$62(a3)
	bsr.w	Sub_363C0
	tst.w	$34(a2)
	beq.w	rtss2
	cmpi.w	#$14,d4
	blt.w	rtss2
	moveq	#$78,d0
	btst	#$3,$62(a3)
	beq.w	L1F612
	asl.w	#$1,d0
L1F612	sub.b	$67(a3),d0
	add.b	$67(a2),d0
	lsr.w	#$1,d0
	exg.l	a2,a3
	jsr	$24FB4.l
	exg.l	a2,a3
	sub.w	$32(a2),d0
	beq.w	L1F6D4
	bmi.w	L1F6D4
	btst	#$4,$64(a3)
	bne.w	L1F6D4
	bsr.w	randomd0
	dc.w	$4279,$0001,$7E62
	move.b	$75(a3),$17E63.l
	dc.w	$E2F9,$0001,$7E62
	cmp.b	$17E63.l,d0
	ble.w	L1F6D4
	bsr.w	Sub_3A75C
	cmpi.w	#$4,d0
	bhi.w	rtss2
	btst	#$4,$17F68.l
	bne.w	rtss2
L1F676	btst	#$7,$FF800E.l
	bne.b	L1F676
	move.w	#$1C,$FF8020.l
	bset	#$6,$FF800F.l
L1F690	btst	#$6,$FF800E.l
	beq.b	L1F690
	move.b	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1F6B0	btst	#$6,$FF800E.l
	bne.b	L1F6B0
	bclr	#$7,$FF800F.l
	andi.w	#$2,d0
	addi.w	#$16,d0
	jsr	(PenShotChk).l
	bra.w	AddPenalty
L1F6D4	bsr.w	Sub_3A75C
	cmpi.w	#$3,d0
	bhi.w	L1F748
	btst	#$4,$17F68.l
	bne.w	L1F748
L1F6EC	btst	#$7,$FF800E.l
	bne.b	L1F6EC
	move.w	#$1C,$FF8020.l
	bset	#$6,$FF800F.l
L1F706	btst	#$6,$FF800E.l
	beq.b	L1F706
	move.b	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1F726	btst	#$6,$FF800E.l
	bne.b	L1F726
	bclr	#$7,$FF800F.l
	andi.w	#$2,d0
	addi.w	#$1A,d0
	bsr.w	PenShotChk
	bsr.w	AddPenalty
L1F748	bra.w	Sub_3A9BE
checkagr
	bclr	d5,(a6)
	movep.l	d5,$C2C(a0)
	dc.w	$0C2C,$0C2C,$0BFA
	dc.w	$0BFA,$0B96
Sub_3A75C
	move.w	#$28,d0
	sub.b	$73(a3),d0
	lsr.b	#$1,d0
	mulu.w	#$D,d0
	btst	#$3,$62(a3)
	beq.w	L1F776
	asl.w	#$1,d0
L1F776	move.w	$0(a3),d1
	dc.w	$9279,$0001,$7B80
	cmpi.w	#$28,d1
	bgt.w	L1F7AC
	cmpi.w	#$FFD8,d1
	blt.w	L1F7AC
	move.w	$14(a3),d1
	dc.w	$9279,$0001,$7B94
	cmpi.w	#$28,d1
	bgt.w	L1F7AC
	cmpi.w	#$FFD8,d1
	blt.w	L1F7AC
	asr.w	#$1,d0
L1F7AC	bsr.w	randomd0
	btst	#$1,$64(a2)
	beq.w	L1F7F6
	move.w	$14(a2),d1
	bpl.w	L1F7C4
	neg.w	d1
L1F7C4	subi.w	#$108,d1
	neg.w	d1
	move.w	#$8,d0
	cmpi.w	#$75,d1
	bgt.w	L1F7F2
	move.w	#$7,d0
	cmpi.w	#$3A,d1
	bgt.w	L1F7F2
	move.w	#$4,d0
	cmpi.w	#$2C,d1
	bgt.w	L1F7F2
	move.w	#$3,d0
L1F7F2	bsr.w	randomd0
L1F7F6	btst	#$6,$62(a3)
	bne.w	L1F810
	btst	#$2,$17F7E.l
	bne.w	L1F81C
	bra.w	L1F820
L1F810	btst	#$1,$17F7E.l
	beq.w	L1F820
L1F81C	move.w	#$7F,d0
L1F820	rts
Sub_3A822
	btst	#$5,$62(a3)
	bne.w	rtss2
	tst.w	$34(a3)
	beq.w	rtss2
	btst	#$0,$63(a3)
	bne.w	rtss2
	move.w	$0(a3),d0
	sub.w	$0(a2),d0
	move.w	$14(a3),d1
	sub.w	$14(a2),d1
	bsr.w	vtoa
	sub.w	$54(a2),d0
	addi.w	#$1,d0
	andi.w	#$7,d0
	cmpi.w	#$2,d0
	bhi.w	rtss2
	move.w	$17BE0.l,d0
	cmp.w	$52(a3),d0
	bne.w	L1F87C
	bclr	#$3,$17F6A.l
L1F87C	move.w	$28(a3),d0
	add.w	$28(a2),d0
	asr.w	#$1,d0
	move.w	d0,$28(a3)
	move.w	d0,$28(a2)
	move.w	$2A(a3),d0
	add.w	$2A(a2),d0
	asr.w	#$1,d0
	move.w	d0,$2A(a3)
	move.w	d0,$2A(a2)
	bset	#$5,$62(a3)
	move.w	#$CF4,d1
	bsr.w	Sub_363C0
	exg.l	a2,a3
	bset	#$5,$62(a3)
	move.w	#$CC2,d1
	cmpi.w	#$C90,$58(a3)
	beq.w	L1F8C8
	move.w	#$1154,d1
L1F8C8	bsr.w	Sub_363C0
	bsr.w	Sub_3A75C
	cmpi.w	#$6,d0
	bhi.w	L1F900
	btst	#$4,$17F68.l
	bne.w	L1F900
	move.w	#$24,d0
	cmpi.w	#$CC2,$58(a3)
	beq.w	L1F8F6
	move.w	#$1E,d0
L1F8F6	jsr	(PenShotChk).l
	bsr.w	AddPenalty
L1F900	exg.l	a2,a3
	st.b	$17EEE.l
	rts
Sub_3A90A
	btst	#$5,$62(a3)
	bne.w	rtss2
	tst.w	$34(a3)
	beq.w	rtss2
	btst	#$0,$63(a3)
	bne.w	rtss2
	dc.w	$4A79,$0001,$8C08
	bne.w	L1F96C
	btst	#$3,$62(a2)
	beq.w	L1F96C
	moveq	#$20,d0
	add.b	$75(a2),d0
	sub.b	$68(a3),d0
	btst	#$1,$17F7C.l
	bne.w	L1F95C
	btst	#$6,$17F7A.l
	beq.w	L1F960
L1F95C	subi.b	#$2,d0
L1F960	bsr.w	randomd0
	cmpi.w	#$18,d0
	blt.w	rtss2
L1F96C	move.w	$0(a3),d0
	sub.w	$0(a2),d0
	move.w	$14(a3),d1
	sub.w	$14(a2),d1
	bsr.w	vtoa
	sub.w	$54(a2),d0
	addi.w	#$1,d0
	andi.w	#$7,d0
	cmpi.w	#$2,d0
	bhi.w	rtss2
	exg.l	a2,a3
	bsr.w	Sub_3A9BE
	bsr.w	Sub_3A75C
	cmpi.w	#$4,d0
	bhi.w	L1F9B4
	move.w	#$20,d0
	jsr	(PenShotChk).l
	bsr.w	AddPenalty
L1F9B4	exg.l	a2,a3
	st.b	$17EEE.l
	rts
