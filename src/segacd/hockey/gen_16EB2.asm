donothing
	btst	#$5,$62(a3)
	bne.w	check4benchExit
	btst	#$3,$62(a3)
	bne.w	check4benchExit
	moveq	#$8,d0
	bra.w	doplayeracc
L31ECC	btst.b	#$5,$62(a3)
	dc.w	$6600,$FBE2
	bclr.b	#$1,$62(a3)
	beq.w	.l16F04
	move.w	#$5A,$44(a3)
	tst.w	$17CEE.l
	bpl.w	.l16EF4
	neg.w	$44(a3)
.l16EF4	move.w	$17CEA.l,$46(a3)
	move.w	#$109E,d1
	dc.w	$6100,$44BE
.l16F04	move.w	$44(a3),d0
	sub.w	$0(a3),d0
	move.w	$46(a3),d1
	sub.w	$14(a3),d1
	bsr.w	vtoa
	cmpi.w	#$7,d0
	dc.w	$6E00,$FB98
	move.w	d0,d2
	move.w	d2,$54(a3)
	dc.w	$6000,$4950
	btst.b	#$5,$62(a3)
	dc.w	$6600,$FB84
	bclr.b	#$1,$62(a3)
	beq.w	.l16F64
	bsr.w	L31FDA
	move.w	#$8,$42(a3)
	move.w	#$5A,$44(a3)
	tst.w	$17CEE.l
	bpl.w	.l16F5C
	neg.w	$44(a3)
.l16F5C	move.w	$17CEA.l,$46(a3)
.l16F64	movea.l	#$31AB6,a0
	move.w	$44(a3),d0
	move.w	$46(a3),d1
	btst.b	#$0,$17F78.l
	beq.w	.l16FB2
	tst.w	$1AD72.l
	beq.w	.l16F9C
	subi.w	#$1,$1AD72.l
	bne.w	.l16F9C
	bset.b	#$2,$17F6C.l
.l16F9C	cmpi.w	#$88,$0(a3)
	bgt.w	.l16FB0
	cmpi.w	#$FF78,$0(a3)
	bgt.w	.l16FB2
.l16FB0	clr.w	d1
.l16FB2	sub.w	d7,$40(a3)
	dc.w	$6A00,$002E
	bset.b	#$5,$62(a3)
	move.w	#$E8A,d1
	move.w	$17E28.l,d0
	cmp.w	$52(a3),d0
	bne.w	.l16FD6
	move.w	#$EFC,d1
.l16FD6	dc.w	$6100,$43E8
L31FDA	moveq	#$78,d0
	bsr.w	randomd0
	move.w	d0,$40(a3)
	rts
	btst.b	#$3,$62(a3)
	beq.w	skateto
	rts
	btst.b	#$5,$62(a3)
	dc.w	$6600,$FABC
	btst.b	#$0,$17F68.l
	dc.w	$6600,$FEAC
	dc.w	$6100,$F8FC
	btst.b	#$3,$62(a3)
	dc.w	$6600,$FAA2
	bclr.b	#$1,$62(a3)
	beq.w	.l1702A
	clr.w	$40(a3)
	move.w	#$8,$42(a3)
.l1702A	sub.b	d7,$40(a3)
	bpl.w	.l1709E
	move.b	$6A(a3),$40(a3)
	jsr	$2AEDC.l
	bmi.w	.l17056
	btst.b	#$6,$17F7A.l
	beq.w	.l1705C
	tst.b	$40(a3)
	beq.w	.l1705C
.l17056	subi.b	#$1,$40(a3)
.l1705C	moveq	#$2,d0
	btst.b	#$4,$32(a2)
	dc.w	$6600,$427E
	move.w	$17B94.l,d1
	btst.b	#$7,$62(a3)
	bne.w	.l1707A
	neg.w	d1
.l1707A	cmpi.w	#$5D,d1
	dc.w	$6D00,$4264
	move.w	$17BE0.l,d1
	bmi.w	.l1709E
	subi.w	#$6,d1
	move.w	$52(a3),d2
	subi.w	#$6,d2
	eor.w	d2,d1
	dc.w	$6B00,$4248
.l1709E	dc.w	$41FA,$1BCE
	moveq	#$50,d0
	cmpi.w	#$2,$34(a3)
	beq.w	.l170B0
	neg.w	d0
.l170B0	move.w	#$62,d1
	btst.b	#$7,$62(a3)
	bne.w	.l170C2
	neg.w	d0
	neg.w	d1
.l170C2	move.w	$17B80.l,d2
	eor.w	d0,d2
	bmi.w	.l170D8
	move.w	$17B80.l,d0
	bra.w	skateto
.l170D8	move.w	$17B80.l,d2
	asr.w	#$1,d2
	add.w	d2,d0
	bra.w	skateto
	btst.b	#$5,$62(a3)
	dc.w	$6600,$F9C8
	btst.b	#$0,$17F68.l
	dc.w	$6600,$FDB8
	dc.w	$6100,$F808
	btst.b	#$3,$62(a3)
	dc.w	$6600,$F9AE
	bclr.b	#$1,$62(a3)
	beq.w	.l1711E
	clr.w	$40(a3)
	move.w	#$8,$42(a3)
.l1711E	sub.b	d7,$40(a3)
	bpl.w	.l1729A
	move.b	$6B(a3),$40(a3)
	btst.b	#$6,$17F7A.l
	beq.w	.l17146
	tst.b	$40(a3)
	beq.w	.l17146
	subi.b	#$1,$40(a3)
.l17146	move.w	$17B94.l,d1
	move.w	$17BAA.l,d3
	asr.w	#$6,d3
	btst.b	#$7,$62(a3)
	bne.w	.l17162
	neg.w	d1
	neg.w	d3
.l17162	tst.w	d3
	bpl.w	.l1716A
	clr.w	d3
.l1716A	add.w	d1,d3
	cmpi.w	#$58,d3
	blt.w	.l171A4
	btst.b	#$4,$32(a2)
	bne.w	.l171A4
	move.w	$17BE0.l,d1
	bmi.w	.l171A4
	dc.w	$6100,$172C
	beq.w	.l171A4
	moveq	#$1,d0
	subi.w	#$6,d1
	move.w	$52(a3),d2
	subi.w	#$6,d2
	eor.w	d2,d1
	dc.w	$6A00,$4142
.l171A4	move.w	#$41,$44(a3)
	cmpi.w	#$2,$34(a3)
	beq.w	.l171B8
	neg.w	$44(a3)
.l171B8	movea.l	#$17480,a0
	cmpi.w	#$6,$52(a3)
	bge.w	.l171CC
	adda.w	#$300,a0
.l171CC	moveq	#$5,d2
	move.w	#$FC18,d0
	btst.b	#$7,$62(a3)
	beq.w	.l1723C
	neg.w	d0
	btst.b	#$2,$63(a0)
	bne.w	.l17208
	tst.w	$34(a0)
	bmi.w	.l17208
	move.w	$2A(a0),d1
	bmi.w	.l171FA
	clr.w	d1
.l171FA	asr.w	#$4,d1
	add.w	$14(a0),d1
	cmp.w	d0,d1
	bgt.w	.l17208
	move.w	d1,d0
.l17208	adda.w	#$80,a0
	dc.w	$51CA,$FFD0
	subi.w	#$32,d0
	cmpi.w	#$FF42,d0
	bgt.w	.l17220
	move.w	#$FF24,d0
.l17220	move.w	d0,$46(a3)
	move.w	$17B80.l,d0
	move.w	$44(a3),d1
	eor.w	d0,d1
	bpl.w	.l1729A
	clr.w	$44(a3)
	bra.w	.l1729A
.l1723C	btst.b	#$2,$63(a0)
	bne.w	.l17266
	tst.w	$34(a0)
	bmi.w	.l17266
	move.w	$2A(a0),d1
	bpl.w	.l17258
	clr.w	d1
.l17258	asr.w	#$4,d1
	add.w	$14(a0),d1
	cmp.w	d0,d1
	blt.w	.l17266
	move.w	d1,d0
.l17266	adda.w	#$80,a0
	dbra	d2,.l1723C
	addi.w	#$32,d0
	cmpi.w	#$BE,d0
	blt.w	.l1727E
	move.w	#$DC,d0
.l1727E	move.w	d0,$46(a3)
	neg.w	$44(a3)
	move.w	$17B80.l,d0
	move.w	$44(a3),d1
	eor.w	d0,d1
	bpl.w	.l1729A
	clr.w	$44(a3)
.l1729A	move.w	$44(a3),d0
	move.w	$46(a3),d1
	movea.l	#$33C6E,a0
	bsr.w	skateto
	bra.w	CheckCheckerSet
	rts
	btst.b	#$5,$62(a3)
	dc.w	$6600,$FFF6
	btst.b	#$0,$17F68.l
	dc.w	$6600,$FBEC
	dc.w	$6100,$F63C
	btst.b	#$3,$62(a3)
	dc.w	$6600,$FFDC
	bclr.b	#$1,$62(a3)
	beq.w	.l172EA
	clr.w	$40(a3)
	move.w	#$8,$42(a3)
.l172EA	sub.b	d7,$40(a3)
	bpl.w	.l17330
	move.b	$6B(a3),$40(a3)
	btst.b	#$6,$17F7A.l
	beq.w	.l17312
	tst.b	$40(a3)
	beq.w	.l17312
	subi.b	#$1,$40(a3)
.l17312	move.w	$17BE0.l,d1
	bmi.w	.l17330
	moveq	#$4,d0
	subi.w	#$6,d1
	move.w	$52(a3),d2
	subi.w	#$6,d2
	eor.w	d2,d1
	dc.w	$6A00,$3FB6
.l17330	moveq	#$64,d0
	cmpi.w	#$5,$34(a3)
	bne.w	.l1733E
	neg.w	d0
.l1733E	move.l	#$9E,d1
	btst.b	#$7,$62(a3)
	beq.w	.l17386
	neg.w	d0
	neg.w	d1
	moveq	#-78,d2
	btst.b	#$4,$32(a2)
	bne.w	.l173B4
	cmp.w	$17B94.l,d2
	bgt.w	.l17372
	move.w	$17B94.l,d1
	bra.w	.l173B6
.l17372	move.w	#$FEF8,d2
	cmp.w	$17B94.l,d2
	blt.w	.l173B6
	move.w	d2,d1
	bra.w	.l173B6
.l17386	moveq	#$4E,d2
	btst.b	#$4,$32(a2)
	bne.w	.l173B4
	cmp.w	$17B94.l,d2
	blt.w	.l173A6
	move.w	$17B94.l,d1
	bra.w	.l173B6
.l173A6	move.w	#$108,d2
	cmp.w	$17B94.l,d2
	bgt.w	.l173B6
.l173B4	move.w	d2,d1
.l173B6	lea.l	$322B0.l,a0
	move.w	$17B80.l,d2
	eor.w	d0,d2
	bmi.w	skateto
	move.w	$17B80.l,d0
	bra.w	skateto
	btst.b	#$5,$62(a3)
	dc.w	$6600,$FED6
	btst.b	#$0,$17F68.l
	dc.w	$6600,$FACC
	dc.w	$6100,$F51C
	btst.b	#$3,$62(a3)
	dc.w	$6600,$FEBC
	bclr.b	#$1,$62(a3)
	beq.w	.l1740E
	st.b	$48(a3)
	clr.w	$40(a3)
	move.w	#$8,$42(a3)
.l1740E	sub.b	d7,$40(a3)
	bpl.w	L3254A
	move.b	$6B(a3),$40(a3)
	btst.b	#$6,$17F7A.l
	beq.w	.l17436
	tst.b	$40(a3)
	beq.w	.l17436
	subi.b	#$1,$40(a3)
.l17436	moveq	#$3,d0
	move.w	$17BE0.l,d1
	bmi.w	.l17454
	subi.w	#$6,d1
	move.w	$52(a3),d2
	subi.w	#$6,d2
	eor.w	d2,d1
	dc.w	$6B00,$3E92
.l17454	move.w	$17B94.l,d0
	move.w	$17BAA.l,d3
	asr.w	#$6,d3
	add.w	d0,d3
	btst.b	#$7,$62(a3)
	bne.w	.l17472
	neg.w	d0
	neg.w	d3
.l17472	clr.w	d2
	cmpi.w	#$FFA8,d3
	blt.w	.l174A2
	addi.w	#$8,d2
	cmpi.w	#$58,d0
	blt.w	.l174A2
	btst.b	#$4,$32(a2)
	bne.w	.l174A2
	addi.w	#$8,d2
	cmpi.w	#$108,d3
	blt.w	.l174A2
	addi.w	#$8,d2
.l174A2	cmp.w	$48(a3),d2
	bne.w	.l174FE
	btst.b	#$7,$FF800E.l
	dc.w	$66F6
	move.w	#$1B,$FF8020.l
	bset.b	#$6,$FF800F.l
	btst.b	#$6,$FF800E.l
	dc.w	$67F6
	move.w	$FF8010.l,d0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
	btst.b	#$6,$FF800E.l
	dc.w	$66F6
	bclr.b	#$7,$FF800F.l
	andi.w	#$7F,d0
	bne.w	L3254A
.l174FE	move.w	d2,$48(a3)
	lea.l	L3252A(pc),a0
	move.w	$2(a0,d2.w),d0
	dc.w	$6100,$4B38
	add.w	(a0,d2.w),d0
	move.w	d0,$44(a3)
	move.w	$6(a0,d2.w),d0
	dc.w	$6100,$4B28
	add.w	$4(a0,d2.w),d0
	move.w	d0,$46(a3)
	bra.w	L3254A
L3252A	dc.b	$00,$50,$00,$14,$FF,$BA,$00,$0A,$00,$64,$00,$14,$00,$3A,$00,$05	; .P.......d...:..
	dc.b	$00,$3C,$00,$32,$00,$E6,$00,$14,$00,$50,$00,$1E,$00,$FA,$00,$14	; .<.2.....P......
L3254A	move.w	$44(a3),d0
	cmpi.w	#$5,$34(a3)
	beq.w	.l1755A
	neg.w	d0
.l1755A	move.w	$46(a3),d1
	btst.b	#$7,$62(a3)
	bne.w	.l1756C
	neg.w	d0
	neg.w	d1
.l1756C	dc.w	$41FA,$1700
	bra.w	skateto
	rts
	btst.b	#$5,$62(a3)
	dc.w	$6600,$FFF6
	btst.b	#$0,$17F68.l
	dc.w	$6600,$F928
	dc.w	$6100,$F378
	btst.b	#$3,$62(a3)
	dc.w	$6600,$FFDC
	bclr.b	#$1,$62(a3)
	beq.w	.l175AE
	clr.w	$40(a3)
	move.w	#$8,$42(a3)
.l175AE	sub.b	d7,$40(a3)
	bpl.w	.l175F4
	move.b	$6B(a3),$40(a3)
	btst.b	#$6,$17F7A.l
	beq.w	.l175D6
	tst.b	$40(a3)
	beq.w	.l175D6
	subi.b	#$1,$40(a3)
.l175D6	move.w	$17BE0.l,d1
	bmi.w	.l175F4
	moveq	#$6,d0
	subi.w	#$6,d1
	move.w	$52(a3),d2
	subi.w	#$6,d2
	eor.w	d2,d1
	dc.w	$6A00,$3CF2
.l175F4	move.w	$17B80.l,d0
	asr.w	#$1,d0
	move.w	$17B94.l,d2
	btst.b	#$7,$62(a3)
	bne.w	.l1760E
	neg.w	d2
.l1760E	moveq	#-128,d1
	cmpi.w	#$FFA8,d2
	blt.w	.l17620
	add.w	$17B94.l,d1
	asr.w	#$1,d1
.l17620	btst.b	#$7,$62(a3)
	bne.w	.l1762C
	neg.w	d1
.l1762C	lea.l	$32574.l,a0
	bra.w	skateto
	btst.b	#$5,$62(a3)
	dc.w	$6600,$FF36
	btst.b	#$0,$17F68.l
	dc.w	$6600,$F868
	dc.w	$6100,$F2B8
	btst.b	#$3,$62(a3)
	dc.w	$6600,$FF1C
	bclr.b	#$1,$62(a3)
	beq.w	.l17672
	st.b	$48(a3)
	clr.w	$40(a3)
	move.w	#$8,$42(a3)
.l17672	sub.b	d7,$40(a3)
	bpl.w	L327A2
	move.b	$6B(a3),$40(a3)
	btst.b	#$6,$17F7A.l
	beq.w	.l1769A
	tst.b	$40(a3)
	beq.w	.l1769A
	subi.b	#$1,$40(a3)
.l1769A	move.w	$17BE0.l,d1
	bmi.w	.l176B8
	moveq	#$5,d0
	subi.w	#$6,d1
	move.w	$52(a3),d2
	subi.w	#$6,d2
	eor.w	d2,d1
	dc.w	$6B00,$3C2E
.l176B8	move.w	$17B94.l,d0
	btst.b	#$7,$62(a3)
	bne.w	.l176CA
	neg.w	d0
.l176CA	clr.w	d2
	cmpi.w	#$FFA8,d0
	blt.w	.l176FA
	addi.w	#$8,d2
	cmpi.w	#$58,d0
	blt.w	.l176FA
	btst.b	#$4,$32(a2)
	bne.w	.l176FA
	addi.w	#$8,d2
	cmpi.w	#$108,d0
	blt.w	.l176FA
	addi.w	#$8,d2
.l176FA	cmp.w	$48(a3),d2
	bne.w	.l17756
	btst.b	#$7,$FF800E.l
	dc.w	$66F6
	move.w	#$1B,$FF8020.l
	bset.b	#$6,$FF800F.l
	btst.b	#$6,$FF800E.l
	dc.w	$67F6
	move.w	$FF8010.l,d0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
	btst.b	#$6,$FF800E.l
	dc.w	$66F6
	bclr.b	#$7,$FF800F.l
	andi.w	#$7F,d0
	bne.w	L327A2
.l17756	move.w	d2,$48(a3)
	lea.l	L32782(pc),a0
	move.w	$2(a0,d2.w),d0
	dc.w	$6100,$48E0
	add.w	(a0,d2.w),d0
	move.w	d0,$44(a3)
	move.w	$6(a0,d2.w),d0
	dc.w	$6100,$48D0
	add.w	$4(a0,d2.w),d0
	move.w	d0,$46(a3)
	bra.w	L327A2
L32782	dc.b	$00,$00,$00,$3C,$FF,$BA,$00,$0A,$00,$00,$00,$3C,$00,$3C,$00,$0A	; ...<.......<.<..
	dc.b	$00,$00,$00,$28,$00,$AA,$00,$1E,$00,$00,$00,$50,$00,$AA,$00,$14	; ...(.......P....
L327A2	move.w	$44(a3),d0
	move.w	$46(a3),d1
	btst.b	#$7,$62(a3)
	bne.w	.l177B6
	neg.w	d1
.l177B6	dc.w	$41FA,$14B6
	bra.w	skateto
assgoaliectrl						;joypad controlled goalie control: a3 = goalie; a goalie not on the
									;joystick leaves through assexit
	btst	#$3,$62(a3)		;is player joystick controlled?
	bne.w	.goaliectrl		;branch is so
	bra.w	assexit
.goaliectrl	btst	#$1,$62(a3)		;check if new assignment
	bne.w	.na		;branch if new assignment
	movem.w	d0-d1,-(sp)		;push to stack
	move.w	$0(a3),d0		;Xpos
	move.w	$14(a3),d1		;Ypos
	cmpi.w	#$AA,d1		;compare $AA to Ypos
	bgt.w	.next
	cmpi.w	#$FF56,d1		;check -$AA to Ypos
	blt.w	.next		;branch if less than
	btst	#$0,$17F68.l		;check if clock stopped
	bne.w	.next		;branch if so
	move.w	d0,-(sp)		;push to stack
	move.w	#$8,d0		;clock stoppage due to goalie out of range
	jsr	(AddPenalty2).l
	move.w	(sp)+,d0
.next	sub.w	$17CEE.l,d0
	sub.w	$17CEA.l,d1
	bclr	#$2,$64(a3)		;clear goalie control bit?
	cmpi.w	#$74,d0		;compare $74 to Xpos diff
	blt.w	.0		;branch if less than
	bset	#$2,$64(a3)		;set goalie control bit?
	bra.w	.cont2
.0	cmpi.w	#$FF8C,d0		;compare -$74 to Xpos diff
	bgt.w	.1		;branch if greater than
	bset	#$2,$64(a3)		;set goalie control bit?
	bra.w	.cont2
.1	cmpi.w	#$64,d1		;compare $64 to Ypos diff
	blt.w	.2		;branch if less than
	bset	#$2,$64(a3)		;set goalie control bit?
	bra.w	.cont2
.2	cmpi.w	#$FF9C,d1		;compare -$64 to Ypos diff
	bgt.w	.cont2		;branch if greater than
	bset	#$2,$64(a3)		;set goalie control bit?
.cont2	movem.w	(sp)+,d0-d1		;pop from stack
	btst	#$2,$64(a3)		;check goalie ctrl bit
	bne.w	checkanimSub1		;branch if set
.na	btst	#$5,$62(a3)		;check if anim lock
	bne.w	check4benchExit		;exit if so
	bsr.w	check4bench
	bclr	#$1,$62(a3)		;clear new assignment bit
	beq.w	.nna		;branch if already cleared
	clr.w	$40(a3)		;clear temp1
	move.w	#$8,$42(a3)		;move 8 into temp2
	st.b	$46(a3)		;FFFF to temp4
.nna	btst	#$1,$63(a3)		;check if anim in progress
	bne.w	.ex		;exit if so
	btst	#$0,$17F68.l		;check if clock stopped
	bne.w	check4benchExit		;exit if so
	tst.w	$48(a3)		;test temp5
	bmi.w	.nofo		;branch if less than 0
	move.w	$52(a3),d0		;move SCnum into d0
	cmp.w	$17BE0.l,d0		;check if puckc is goalie
	beq.w	.mbfo		;branch if equal
	st.b	$48(a3)		;set temp5 to -1
	bra.w	.nofo
.mbfo	sub.w	d7,$48(a3)		;subtract d7(frames elapsed) from temp5
	bpl.w	.nofo		;branch if more than 0
	btst	#$2,$17F70.l		;check bit 2
	beq.w	.next2		;branch if not set
	bset	#$4,$17F70.l
	bra.w	.nofo
.next2	moveq	#$8,d0
	bsr.w	AddPenalty2
.nofo	sub.b	d7,$40(a3)		;sub d7(frames elapsed) from temp1
	bpl.w	.ex		;branch if positive
	move.b	$6B(a3),d0		;DfA into d0
	beq.w	.3		;branch if value was 0
	btst	#$6,$17F7A.l		;check if crowd meter broken
	beq.w	.3		;jump if not
	subi.b	#$1,d0		;sub 1 from d0
.3	lsr.b	#$2,d0		;divide by 4
	move.b	d0,$40(a3)		;move d0 into temp1
	move.w	$52(a3),d0		;move SCnum into d0
	cmp.w	$17BE0.l,d0		;compare puckc to d0
	beq.w	.ex		;jump to assgoaliecpu if the same
.ex	rts
checkanim
	btst	#$3,$62(a3)
	bne.w	assgoaliectrl
