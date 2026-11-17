SelectPenaltyShotSkater
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a0
	dc.w	$4A79,$0001,$9366
	beq.w	L19680
	movea.l	#awtmstruct,a0
L19680	move.w	#$0,d1
	move.w	#$FFFF,d6
	move.w	#$FFFF,d5
	movea.l	$1E(a0),a2
	adda.w	$0(a2),a2
L19694	cmpi.w	#$2,(a2)
	beq.w	L19768
	adda.w	(a2),a2
	move.w	d1,d7
	asl.w	#$1,d7
	move.b	$5(a2),d0
	andi.w	#$F,d0
	cmpi.b	#$1,d0
	ble.w	L19756
	btst	#$0,$17F78.l
	bne.w	L19774
	cmpi.w	#$FFFE,$68(a0,d7.w)
	beq.w	L196D2
	cmpi.w	#$FFFF,$68(a0,d7.w)
	bne.w	L19756
L196D2	clr.w	d3
	clr.w	d0
	move.b	$1(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	$2(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	$2(a2),d0
	andi.w	#$F0,d0
	lsr.w	#$4,d0
	add.w	d0,d3
	move.b	$3(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	$3(a2),d0
	andi.w	#$F0,d0
	lsr.w	#$4,d0
	add.w	d0,d3
	move.b	$5(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	$5(a2),d0
	andi.w	#$F0,d0
	lsr.w	#$4,d0
	add.w	d0,d3
	move.b	$6(a2),d0
	andi.w	#$F0,d0
	lsr.w	#$4,d0
	add.w	d0,d3
	move.b	$7(a2),d0
	andi.w	#$F0,d0
	lsr.w	#$4,d0
	add.w	d0,d3
	dc.w	$B279,$0001,$936C
	bne.w	L19748
	move.w	#$7FFF,d3
L19748	cmp.w	d6,d3
	blt.w	L19756
	move.w	d3,d6
	move.w	d1,d5
	bra.w	L19756
L19756	adda.l	#$8,a2
	addi.w	#$1,d1
	cmpi.w	#$1A,d1
	blt.w	L19694
L19768	tst.w	d5
	bmi.w	L197A8
	dc.w	$33C5,$0001,$936C
L19774	dc.w	$33FC,$0000,$0001,$9368
	dc.w	$4A79,$0001,$9366
	beq.w	L1978E
	dc.w	$33FC,$0006,$0001,$9368
L1978E	dc.w	$3039,$0001,$9368
	asl.w	#$7,d0
	dc.w	$267C,$0001,$7480
	adda.w	d0,a3
	dc.w	$3639,$0001,$936C
	bra.w	L197B0
L197A8	move.w	#$FFFF,d0
	bra.w	L197B4
L197B0	move.w	#$1,d0
L197B4	movem.l	(sp)+,d0-d7/a0-a6
	rts
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_197BA.bin
UpdatePenaltyShotEnd
	movem.w	d0,-(sp)
	move.w	$17BE0.l,d0
	dc.w	$B079,$0001,$936A
	movem.w	(sp)+,d0
	beq.w	L19C00
	btst	#$5,$17F70.l
	beq.w	L19C08
	btst	#$5,$17F78.l
	bne.w	L19BE2
	tst.w	$17BE0.l
	bpl.w	L19BEC
	bset	#$5,$17F78.l
L19BE2	tst.w	$17BE0.l
	bpl.w	L19C00
L19BEC	dc.w	$4A79,$0001,$7F9A
	bmi.w	L19C00
	dc.w	$5379,$0001,$7F9A
	bra.w	L19C08
L19C00	bset	#$4,$17F70.l
L19C08	dc.w	$4A79,$0001,$93B6
	bne.w	L19C1A
	bset	#$4,$17F70.l
L19C1A	btst	#$4,$17F70.l
	bne.w	L19C28
	rts
L19C28	btst	#$6,$17F70.l
	bne.w	L19CC4
	bset	#$6,$17F70.l
	move.w	#$A,d0
	dc.w	$4EB9,$0003,$9456
EndPenaltyShotPlay
	jsr	(freezewindow).l
	btst	#$0,$17F78.l
	bne.w	L19C68
	dc.w	$33FC,$000A,$0001,$AD92
	bset	#$2,$17F6C.l
L19C68	bset	#$0,$17F68.l
	bclr	#$2,$17F78.l
	bclr	#$2,$17F70.l
	bclr	#$3,$17F70.l
	bclr	#$5,$17F70.l
	bclr	#$4,$17F70.l
	bclr	#$6,$17F70.l
	movem.l	d0/a0,-(sp)
	dc.w	$207C,$0001,$7480
	dc.w	$3039,$0001,$9368
	asl.w	#$7,d0
	move.b	$17F9C.l,$61(a0,d0.w)
	movem.l	(sp)+,d0/a0
	jsr	(CountShootoutGoals).l
L19CC4	rts
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_19CC6.bin
L19EDC	dc.w	$4A79,$0001,$8C0A
	bne.w	rtss2
	btst	#$4,$17F7A.l
	bne.w	L19F06
	dc.w	$B079,$0001,$7FA6
	beq.w	rtss2
	dc.w	$B079,$0001,$7FA8
	beq.w	rtss2
L19F06	bsr.w	CompLine
	dc.w	$4EB9,$0003,$D426
	bsr.w	printscores1
	dc.w	$33FC,$2710,$0001,$7F82
	rts
StartFaceoffLineChange
	exg.l	a2,a3
	asl.w	#$7,d0
	dc.w	$267C,$0001,$7480
	adda.w	d0,a3
	bclr	#$3,$63(a3)
	move.l	a2,-(sp)
	bsr.w	Sub_30B08
	movea.l	(sp)+,a2
	btst	#$3,$63(a3)
	beq.w	L19F68
	btst	#$6,$62(a3)
	beq.w	L19F5C
	move.w	#$168,$42(a2)
	move.w	$52(a3),$46(a2)
	bra.w	L19F68
L19F5C	move.w	#$258,$40(a2)
	move.w	$52(a3),$44(a2)
L19F68	exg.l	a2,a3
	rts
WaitForFaceoffLineChanges
	move.w	#$40,d0
	bsr.w	UpdateFaceoffLineChangeTimer
	move.w	#$42,d0
	bsr.w	UpdateFaceoffLineChangeTimer
	tst.w	$40(a3)
	bpl.w	rtss2
	tst.w	$42(a3)
	bpl.w	rtss2
	movea.l	#tmstruct,a2
	lea.l	$366(a2),a1
	moveq	#$1,d0
	bsr.w	L19EDC
	move.w	#$FFFF,$1A568.l
	move.w	#$1C,d0
	bra.w	Sub_362E4
UpdateFaceoffLineChangeTimer
	tst.w	(a3,d0.w)
	bmi.w	rtss2
	move.w	$4(a3,d0.w),d1
	asl.w	#$7,d1
	dc.w	$207C,$0001,$7480
	movea.l	#tmstruct,a2
	btst	#$6,$62(a0,d1.w)
	beq.w	L19FD4
	adda.w	#$366,a2
L19FD4	btst	#$3,$63(a0,d1.w)
	bne.w	L19FE6
	st.b	(a3,d0.w)
	bra.w	Sub_30B50
L19FE6	sub.w	d7,(a3,d0.w)
	bpl.w	rtss2
	move.l	a3,-(sp)
	lea.l	(a0,d1.w),a3
	btst	#$3,$63(a3)
	beq.w	L1A008
	clr.w	d2
	bsr.w	Sub_30D64
	bsr.w	Sub_30B50
L1A008	movea.l	(sp)+,a3
	rts
	dc.w	$4EF9,$0002,$BE98
ChkGoalies
	btst	#$0,$17F68.l
	bne.w	rtss2
	movea.l	#tmstruct,a2
	lea.l	$366(a2),a1
	moveq	#$1,d0
	bsr.w	L1A032
	moveq	#$2,d0
	exg.l	a1,a2
L1A032	tst.w	$28(a2)
	bmi.w	rtss2
	move.w	$17BE0.l,d1
	bmi.w	rtss2
	subi.w	#$6,d1
	cmpa.l	#$1834C,a2
	beq.w	L1A054
	not.w	d1
L1A054	tst.w	d1
	bpl.w	rtss2
	btst	#$3,$17F68.l
	beq.w	L1A070
	st.b	$28(a2)
	dc.w	$4EF9,$0003,$D426
L1A070	dc.w	$B079,$0001,$7FA6
	beq.w	rtss2
	dc.w	$B079,$0001,$7FA8
	beq.w	rtss2
	dc.w	$3239,$0001,$7B94
	bra.w	CPgoalie
ReturnGoalies
	movea.l	#tmstruct,a2
	lea.l	$366(a2),a1
	moveq	#$1,d0
	bsr.w	L1A0A2
	moveq	#$2,d0
	exg.l	a1,a2
L1A0A2	cmpi.w	#$FFFF,$28(a2)
	beq.w	rtss2
	clr.b	$28(a2)
	dc.w	$B079,$0001,$7FA6
	beq.w	rtss2
	dc.w	$B079,$0001,$7FA8
	beq.w	rtss2
	move.w	$17EE4.l,d1
CPgoalie
	cmpi.w	#$2,$180E4.l
	bne.w	rtss2
	move.w	$C(a1),d0
	sub.w	$C(a2),d0
	bmi.w	rtss2
	cmpi.w	#$2,d0
	bne.w	rtss2
	dc.w	$0C79,$003C,$0001,$80E6
	bgt.w	rtss2
	move.l	a0,-(sp)
	movea.l	$22(a2),a0
	btst	#$7,$62(a0)
	movea.l	(sp)+,a0
	bne.w	L1A10A
	neg.w	d1
L1A10A	tst.w	d1
	bmi.w	rtss2
	st.b	$28(a2)
	dc.w	$4EF9,$0003,$D426
CompLine
	movem.l	d0-d2/a0,-(sp)
	moveq	#$3,d0
	move.w	$26(a2),d1
	sub.w	$26(a1),d1
	beq.w	L1A15A
	bpl.w	L1A134
	addi.w	#$2,d0
L1A134	move.w	d0,-(sp)
	bsr.w	getlinee
	move.w	d0,d1
	move.w	(sp),d0
	addi.w	#$1,d0
	bsr.w	getlinee
	cmp.w	d0,d1
	bge.w	L1A150
	addi.w	#$1,(sp)
L1A150	move.w	(sp)+,$16(a2)
Sub_35154
	movem.l	(sp)+,d0-d2/a0
	rts
L1A15A	cmpa.l	#$1834C,a2
	bne.w	Sub_351D8
	moveq	#$2,d1
	dc.w	$41FA,$0046
	cmpi.w	#$2,$180E4.l
	bne.w	L1A18E
	move.w	$C(a2),d2
	cmp.w	$C(a1),d2
	beq.w	L1A18E
	adda.w	#$E,a0
	bgt.w	L1A18E
	adda.w	#$E,a0
L1A18E	move.w	$16(a1),d1
	asl.w	#$1,d1
	move.w	(a0,d1.w),d0
	bsr.w	getlinee
	cmpi.w	#$C00,d0
	bls.w	Sub_351D8
	move.w	(a0,d1.w),$16(a2)
	bra.w	Sub_35154
	dc.w	$0000,$0001,$0002,$0000,$0001,$0000,$0001,$0002
	dc.w	$0000,$0001,$0002,$0000,$0002,$0000,$0000,$0001
	dc.w	$0000,$0000,$0001,$0000,$0001
