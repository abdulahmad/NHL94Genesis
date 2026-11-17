Sub_338E8
	bsr.w	Sub_338B6
	bne.w	Sub_33986
	tst.w	$17E34.l
	beq.w	Sub_33986
L188FA	btst	#$7,$FF800E.l
	bne.b	L188FA
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
L18914	btst	#$6,$FF800E.l
	beq.b	L18914
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L18934	btst	#$6,$FF800E.l
	bne.b	L18934
	bclr	#$7,$FF800F.l
	andi.w	#$3,d0
	bne.w	Sub_33986
	move.w	#$58,d0
	btst	#$7,$62(a3)
	beq.w	L1896C
	move.w	#$FFA8,d0
	cmp.w	$14(a3),d0
	blt.w	CompShoot
	bra.w	L18974
L1896C	cmp.w	$14(a3),d0
	bgt.w	CompShoot
L18974	bset	#$3,$17F74.l
	jmp	(dopass).l
	dc.w	$6000,$0144
Sub_33986
	btst	#$1,$64(a3)
	beq.w	L189D2
	move.w	#$1E,d0
	dc.w	$4EB9,$0003,$7050
	addi.w	#$82,d0
	dc.w	$B079,$0001,$7B94
	blt.w	L189B8
	neg.w	d0
	dc.w	$B079,$0001,$7B94
	bgt.w	L189B8
	bra.w	L189D2
L189B8	move.w	#$2,d0
	dc.w	$4EB9,$0003,$7044
	add.w	$54(a3),d0
	andi.w	#$7,d0
	move.w	d0,$54(a3)
	bra.w	CompShoot
L189D2	moveq	#$20,d4
	clr.w	d1
	move.b	$70(a3),d1
	lsr.w	#$1,d1
	sub.b	d1,d4
	asl.w	#$4,d4
	move.w	#$108,d1
	btst	#$7,$62(a3)
	bne.w	L189F0
	neg.w	d1
L189F0	dc.w	$9279,$0001,$7B94
	dc.w	$3039,$0001,$7B80
	neg.w	d0
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d0,d1
	cmpi.l	#$2710,d1
	movem.w	(sp)+,d0-d1
	bhi.w	L18A76
	lsr.w	#$4,d4
	bsr.w	vtoa
	move.w	d0,d5
	moveq	#$5,d3
	dc.w	$227C,$0001,$7480
	cmpi.w	#$6,$52(a3)
	bge.w	L18A34
	adda.w	#$300,a1
L18A34	tst.w	$34(a1)
	beq.w	L18A60
	move.w	$0(a1),d0
	dc.w	$9079,$0001,$7B80
	move.w	$14(a1),d1
	dc.w	$9279,$0001,$7B94
	bsr.w	vtoa
	cmp.w	d5,d0
	bne.w	L18A6E
	asl.w	#$1,d4
	bra.w	L18A6E
L18A60	btst	#$1,$63(a1)
	beq.w	L18A6E
	clr.w	d3
	moveq	#$1,d4
L18A6E	adda.w	#$80,a1
	dbra	d3,L18A34
L18A76	move.w	d4,d0
	bsr.w	randomd0
	btst	#$0,$70(a3)
	beq.w	L18A92
	cmpi.w	#$7,d0
	bgt.w	Sub_31AB6
	bra.w	L18A9A
L18A92	cmpi.w	#$8,d0
	bgt.w	Sub_31AB6
L18A9A	dc.w	$3039,$0001,$7B94
	btst	#$7,$62(a3)
	bne.w	L18AAC
	neg.w	d0
L18AAC	tst.w	d0
	bmi.w	Sub_31AB6
	move.w	#$108,d1
	sub.w	d0,d1
	bmi.w	Sub_31AB6
	btst	#$7,$17F6C.l
	bne.w	Sub_31AB6
CompShoot
	adda.w	#$4,sp
	dc.w	$3039,$0001,$7B94
	btst	#$7,$62(a3)
	bne.w	L18ADE
	neg.w	d0
L18ADE	move.w	#$108,d1
	sub.w	d0,d1
	lsr.w	#$3,d1
	cmpi.w	#$14,d1
	blt.w	L18AF0
	moveq	#$14,d1
L18AF0	move.w	d1,$42(a3)
	moveq	#$12,d0
	bra.w	Sub_362E4
chk4pass
	tst.w	$17E34.l
	bne.w	L18B16
	moveq	#$10,d0
	add.b	$70(a3),d0
	bsr.w	randomd0
	cmpi.w	#$C,d0
	bgt.w	Sub_31AB6
L18B16	moveq	#$6,d0
	bsr.w	randomd0
	cmpi.w	#$6,$52(a3)
	blt.w	L18B2A
	addi.w	#$6,d0
L18B2A	tst.w	$34(a3)
	beq.w	L18B62
	dc.w	$0C79,$0028,$0001,$7B80
	bgt.w	L18B62
	dc.w	$0C79,$FFD8,$0001,$7B80
	blt.w	L18B62
	dc.w	$0C79,$00CC,$0001,$7B94
	bgt.w	Sub_31AB6
	dc.w	$0C79,$FF34,$0001,$7B94
	blt.w	Sub_31AB6
L18B62	cmp.w	$52(a3),d0
	beq.w	Sub_31AB6
	asl.w	#$7,d0
	dc.w	$207C,$0001,$7480
	adda.w	d0,a0
	tst.w	$34(a0)
	ble.w	Sub_31AB6
	btst	#$2,$63(a0)
	bne.w	Sub_31AB6
	btst	#$5,$62(a0)
	bne.w	Sub_31AB6
	move.w	$14(a0),d0
	move.w	$14(a3),d1
	btst	#$7,$62(a3)
	bne.w	L18BA6
	neg.w	d0
	neg.w	d1
L18BA6	btst	#$5,$17F68.l
	beq.w	L18BC8
	movem.w	d0-d1,-(sp)
	subi.w	#$58,d0
	subi.w	#$58,d1
	eor.w	d0,d1
	movem.w	(sp)+,d0-d1
	bmi.w	Sub_31AB6
L18BC8	cmpi.w	#$58,d0
	bgt.w	L18BDA
	sub.w	d1,d0
	cmpi.w	#$FFF1,d0
	blt.w	Sub_31AB6
L18BDA	move.w	$0(a0),d0
	dc.w	$9079,$0001,$7B80
	move.w	$14(a0),d1
	dc.w	$9279,$0001,$7B94
	movem.w	d0-d1,-(sp)
	bsr.w	vtoa
	dc.w	$33C0,$0001,$7E2C
	movem.w	(sp)+,d1-d2
	muls.w	d1,d1
	muls.w	d2,d2
	add.l	d1,d2
	moveq	#$5,d3
	dc.w	$227C,$0001,$7480
	cmpi.w	#$6,$52(a3)
	bge.w	L18C1C
	adda.w	#$300,a1
L18C1C	move.w	$0(a1),d0
	dc.w	$9079,$0001,$7B80
	move.w	$14(a1),d1
	dc.w	$9279,$0001,$7B94
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d0,d1
	cmp.l	d2,d1
	movem.w	(sp)+,d0-d1
	bhi.w	L18C52
	bsr.w	vtoa
	dc.w	$B079,$0001,$7E2C
	beq.w	Sub_31AB6
L18C52	adda.w	#$80,a1
	dbra	d3,L18C1C
	bsr.w	dopass
	tst.w	$34(a3)
	beq.w	Sub_31AB6
	adda.w	#$4,sp
	bra.w	Sub_362C4
	dc.w	$4A79,$0001,$7BE0,$6B00,$DE40,$142B,$0028,$9439
	dc.w	$0001,$7BA8,$4882,$D46B,$0000,$9479,$0001,$7B80
	dc.w	$0C42,$0028,$6E00,$DE22,$0C42,$FFD8,$6D00,$DE1A
	dc.w	$122B,$002A,$9239,$0001,$7BAA,$4881,$D26B,$0014
	dc.w	$9279,$0001,$7B94,$0C41,$0028,$6E00,$DDFC,$0C41
	dc.w	$FFD8,$6D00,$DDF4,$302B,$0000,$9079,$0001,$7B80
	dc.w	$322B,$0014,$9279,$0001,$7B94,$6100,$261E,$0839
	dc.w	$0005,$0001,$7F68,$6700,$0038,$322B,$0014,$082B
	dc.w	$0007,$0062,$6600,$0004,$4441,$0441,$0058,$0C41
	dc.w	$000A,$6E00,$001C,$0C41,$FFCE,$6D00,$0014,$7002
	dc.w	$322B,$0000,$B279,$0001,$7B80,$6E00,$0004,$7006
	dc.w	$4E75
checkob
	btst	#$5,$17F68.l
	beq.w	Sub_31AB6
	btst	#$2,$17F70.l
	bne.w	L18D94
	movem.l	d0-d1/a0,-(sp)
	moveq	#$5,d0
	dc.w	$207C,$0001,$7480
	cmpi.w	#$6,$52(a3)
	blt.w	L18D52
	adda.w	#$300,a0
L18D52	moveq	#$5C,d1
	btst	#$7,$62(a3)
	bne.w	L18DB6
	neg.w	d1
	dc.w	$B279,$0001,$7B94
	bgt.w	L18D82
L18D6A	tst.w	$34(a0)
	bmi.w	L18D7A
	cmp.w	$14(a0),d1
	bgt.w	L18D96
L18D7A	adda.w	#$80,a0
	dbra	d0,L18D6A
L18D82	moveq	#$40,d0
	bclr	#$7,$17F6C.l
	bne.w	L18DA4
L18D90	movem.l	(sp)+,d0-d1/a0
L18D94	rts
L18D96	moveq	#$6,d0
	bset	#$7,$17F6C.l
	bne.w	L18D90
L18DA4	dc.w	$4A79,$0001,$806E
	bpl.w	L18D90
	bsr.w	PushRef
	bra.w	L18D90
L18DB6	dc.w	$B279,$0001,$7B94
	blt.w	L18D82
L18DC0	tst.w	$34(a0)
	bmi.w	L18DD0
	cmp.w	$14(a0),d1
	blt.w	L18D96
L18DD0	adda.w	#$80,a0
	dbra	d0,L18DC0
	bra.w	L18D82
assbreakaway
	move.w	$52(a3),d0
	cmp.w	$17BE0.l,d0
	beq.w	assnearest
L18DEA	bclr	#$1,$64(a3)
	move.w	#$11,d0
	bsr.w	Sub_362E4
	bra.w	L18E06
assnearest
	jsr	(breakaway).l
	bmi.w	L18DEA
L18E06	bclr	#$2,$17F74.l
	bne.w	L18E18
	bclr	#$1,$64(a3)
L18E18	move.w	$52(a3),d0
	cmp.w	$17BE0.l,d0
	bne.w	L18E52
	btst	#$1,$64(a3)
	bne.w	L18E52
	btst	#$2,$17F70.l
	bne.w	L18E52
	jsr	(BreakawayOffsidesFlagSet).l
	beq.w	L18E52
	move.w	#$22,d0
	bsr.w	Sub_362E4
	bra.w	L18E52
L18E52	bclr	#$1,$62(a3)
	beq.w	L18EBC
	btst	#$1,$64(a3)
	beq.w	L18E70
	move.w	#$2,-(sp)
	dc.w	$4EB9,$0003,$710C
L18E70	btst	#$1,$64(a3)
	beq.w	L18EAE
	movem.l	a2,-(sp)
	movea.l	#tmstruct,a2
	btst	#$6,$62(a3)
	beq.w	L18E94
	movea.l	#awtmstruct,a2
L18E94	addi.w	#$1,$35A(a2)
	dc.w	$0679,$0014,$0001,$7CD8
	addi.w	#$C8,(Crowdlevel).l
	movem.l	(sp)+,a2
L18EAE	clr.w	$44(a3)
	move.w	#$8,$42(a3)
	clr.w	$40(a3)
L18EBC	move.w	$52(a3),d1
	cmp.w	$17BE0.l,d1
	bne.w	L18EE0
	tst.w	$34(a3)
	beq.w	Sub_32926
	moveq	#$10,d0
	btst	#$3,$62(a3)
	beq.w	Sub_362D8
	rts
L18EE0	sub.b	d7,$40(a3)
	bpl.w	L19096
	move.b	$6A(a3),$40(a3)
	jsr	(ReadGoaliePulled).l
	bmi.w	L18F0C
	btst	#$6,$17F7A.l
	beq.w	L18F12
	tst.b	$40(a3)
	beq.w	L18F12
L18F0C	subi.b	#$1,$40(a3)
L18F12	btst	#$5,(sflags6).l
	beq.w	L18F5A
	move.w	$17BE0.l,d1
	cmpi.w	#$5,d1
	bgt.w	L18F50
	btst	#$6,$62(a3)
	beq.w	L18F5A
L18F36	move.b	$40(a3),d1
	ext.w	d1
	asr.w	#$1,d1
	move.b	d1,$40(a3)
	bne.w	L18F5A
	move.b	#$1,$40(a3)
	bra.w	L18F5A
L18F50	btst	#$6,$62(a3)
	beq.w	L18F36
L18F5A	clr.l	$2C(a2)
	move.w	$17BE0.l,d1
	bmi.w	L18F84
	asl.w	#$7,d1
	dc.w	$227C,$0001,$7480
	adda.w	d1,a1
	move.b	$62(a1),d0
	move.b	$62(a3),d1
	eor.b	d0,d1
	btst	#$6,d1
	beq.w	L19004
L18F84	moveq	#-1,d2
	moveq	#$5,d4
	movea.l	$22(a2),a0
L18F8C	tst.w	$34(a0)
	ble.w	L18FF2
	tst.b	$5E(a0)
	bne.w	L18FF2
	btst	#$2,$63(a0)
	bne.w	L18FF2
	move.w	$36(a0),d0
	cmpi.b	#$13,$38(a0,d0.w)
	beq.w	L18FF2
	move.l	a0,-(sp)
	bsr.w	Sub_36362
	add.w	$0(a0),d0
	dc.w	$9079,$0001,$7B80
	add.w	$14(a0),d1
	dc.w	$9279,$0001,$7B94
	dc.w	$3639,$0001,$7BA8
	asr.w	#$6,d3
	sub.w	d3,d0
	dc.w	$3639,$0001,$7BAA
	asr.w	#$6,d3
	sub.w	d3,d1
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	cmp.l	d2,d0
	bhi.w	L18FF2
	move.l	d0,d2
	movea.l	a0,a1
L18FF2	adda.w	#$80,a0
	dbra	d4,L18F8C
	tst.l	d2
	bmi.w	L1903E
	move.l	d2,$2C(a2)
L19004	cmpa.l	a1,a3
	beq.w	L1903E
	btst	#$0,$17F68.l
	bne.w	L1903E
	btst	#$2,$63(a1)
	bne.w	L1903E
	btst	#$3,$64(a1)
	bne.w	L1903E
	exg.l	a1,a3
	bclr	#$0,$62(a3)
	moveq	#$11,d0
	bsr.w	Sub_362D8
	exg.l	a1,a3
	bra.w	Sub_362C4
L1903E	btst	#$5,$62(a3)
	bne.w	Sub_31AB6
	moveq	#$2,d1
	cmpi.w	#$190,d2
	bhi.w	L19060
	subi.w	#$2,d1
	cmpi.w	#$2,$34(a3)
	bls.w	L19096
L19060	btst	#$5,$17F6C.l
	beq.w	L1907C
	subi.w	#$2,d1
	bsr.w	chkpk2
	bne.w	L1907C
	addi.w	#$4,d1
L1907C	moveq	#$28,d0
	sub.b	$75(a3),d0
	asl.w	d1,d0
	bsr.w	randomd0
	cmpi.w	#$2,d0
	bhi.w	L19096
	move.w	#$F0,$44(a3)
L19096	btst	#$5,$62(a3)
	bne.w	Sub_31AB6
	btst	#$2,$17F70.l
	beq.w	L190B8
	btst	#$5,$17F70.l
	beq.w	L190C4
L190B8	btst	#$0,$17F68.l
	bne.w	Sub_31EB2
L190C4	btst	#$3,$62(a3)
	bne.w	Sub_31AB6
	btst	#$2,$32(a2)
	bne.w	L190EE
	tst.w	$17BE0.l
	bmi.w	check4check
	sub.w	d7,$44(a3)
	bpl.w	check4check
	clr.w	$44(a3)
L190EE	bsr.w	skatetopuckinit
	movem.w	d0-d1,-(sp)
	neg.w	d0
	neg.w	d1
	addi.w	#$F4,d1
	btst	#$7,$62(a3)
	beq.w	L1910C
	subi.w	#$1E8,d1
L1910C	asr.w	#$1,d0
	asr.w	#$1,d1
	add.w	(sp)+,d0
	add.w	(sp)+,d1
	btst	#$2,$32(a2)
	beq.w	L19144
	btst	#$7,$62(a3)
	beq.w	L19138
	cmpi.w	#$53,d1
	blt.w	L19144
	move.w	#$44,d1
	bra.w	L19144
L19138	cmpi.w	#$FFAD,d1
	bgt.w	L19144
	move.w	#$FFBC,d1
L19144	btst	#$5,(sflags6).l
	beq.w	L191A2
	move.b	$69(a3),$17E6E.l
	addi.b	#$6,$69(a3)
	btst	#$1,$17F7C.l
	bne.w	L19176
	btst	#$6,$17F7A.l
	beq.w	L1917C
L19176	addi.b	#$2,$69(a3)
L1917C	cmpi.b	#$1E,$69(a3)
	ble.w	L1918C
	move.b	#$1E,$69(a3)
L1918C	lea.l	$341EE.l,a0
	bsr.w	skateto
	move.b	$17E6E.l,$69(a3)
	bra.w	L191AC
L191A2	lea.l	$341EE.l,a0
	bsr.w	skateto
L191AC	btst	#$5,(sflags6).l
	beq.w	L191F0
	dc.w	$3039,$0001,$7B94
	move.w	$14(a3),d2
	tst.w	d0
	bpl.w	L191CC
	neg.w	d0
	neg.w	d2
L191CC	sub.w	d0,d2
	cmpi.w	#$A,d2
	blt.w	L191EE
	move.w	$0(a3),d0
	dc.w	$9079,$0001,$7B80
	bpl.w	L191E6
	neg.w	d0
L191E6	cmpi.w	#$F,d0
	blt.w	L191F0
L191EE	rts
L191F0	btst	#$5,(sflags6).l
	beq.w	L1922A
	move.b	$75(a3),d0
	ext.w	d0
	movem.l	d0/a3,-(sp)
	add.b	d0,d0
	cmpi.b	#$1E,d0
	blt.w	L19214
	move.b	#$1E,d0
L19214	move.b	d0,$75(a3)
	bsr.w	L1922A
	movem.l	(sp)+,d0/a3
	move.b	d0,$75(a3)
	rts
check4check
	bsr.w	skatetopuck
L1922A	tst.w	$34(a3)
	bne.w	L19234
	rts
L19234	move.w	#$28,d0
	sub.b	$75(a3),d0
	dc.w	$4A79,$0001,$8C08
	beq.w	L19248
	asl.w	#$1,d0
L19248	bsr.w	randomd0
	cmpi.w	#$6,d0
	bhi.w	Sub_31AB6
	moveq	#$5,d2
	dc.w	$207C,$0001,$7480
	cmpi.w	#$6,$52(a3)
	bge.w	L1926A
	adda.w	#$300,a0
L1926A	tst.w	$34(a0)
	beq.w	L19326
	btst	#$5,$62(a0)
	bne.w	L19326
	btst	#$0,$63(a0)
	bne.w	L19326
	move.w	$0(a0),d0
	sub.w	$0(a3),d0
	cmpi.w	#$1E,d0
	bgt.w	L19326
	cmpi.w	#$FFE2,d0
	blt.w	L19326
	move.w	$14(a0),d1
	sub.w	$14(a3),d1
	cmpi.w	#$1E,d1
	bgt.w	L19326
	cmpi.w	#$FFE2,d1
	blt.w	L19326
	bsr.w	vtoa
	cmp.w	$54(a3),d0
	bne.w	L19326
	btst	#$5,(sflags6).l
	bne.w	Acheck
L192CE	btst	#$7,$FF800E.l
	bne.b	L192CE
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
L192E8	btst	#$6,$FF800E.l
	beq.b	L192E8
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L19308	btst	#$6,$FF800E.l
	bne.b	L19308
	bclr	#$7,$FF800F.l
	andi.w	#$3,d0
	bne.w	burst
	bra.w	Acheck
L19326	adda.w	#$80,a0
	dbra	d2,L1926A
	rts
asspassrec
	btst	#$5,$62(a3)
	bne.w	Sub_31AB6
	btst	#$0,$17F68.l
	bne.w	Sub_31EB2
	btst	#$3,$62(a3)
	bne.w	Sub_362C4
	bclr	#$1,$62(a3)
	beq.w	L19370
	bset	#$0,$62(a3)
	move.b	#$8,$43(a3)
	clr.b	$42(a3)
	move.w	#$FFFE,$46(a3)
L19370	tst.w	$17BE0.l
	bpl.w	L19422
	addi.w	#$1,$46(a3)
	beq.w	L19388
	bpl.w	L1941A
L19388	dc.w	$4A79,$0001,$7EBC
	bpl.w	L1941A
	tst.w	$34(a3)
	beq.w	L1941A
	move.w	d0,-(sp)
	clr.w	$46(a3)
	move.w	#$1,d0
	btst	#$6,$62(a3)
	beq.w	L193B2
	move.w	#$2,d0
L193B2	dc.w	$B079,$0001,$7FA6
	beq.w	L19418
	dc.w	$B079,$0001,$7FA8
	beq.w	L19418
	jsr	(PuckOnAttackHalf).l
	beq.w	L19418
	move.w	$14(a3),d0
	btst	#$7,$62(a3)
	bne.w	L193E0
	neg.w	d0
L193E0	cmpi.w	#$58,d0
	blt.w	L193F4
	cmpi.w	#$108,d0
	bgt.w	L193F4
	bra.w	L19404
L193F4	move.w	#$8,d0
	dc.w	$4EB9,$0003,$7050
	tst.w	d0
	bne.w	L19418
L19404	move.w	(sp)+,d0
	dc.w	$33FC,$FFFF,$0001,$AD7A
	move.w	#$23,d0
	dc.w	$4EF9,$0003,$62E4
L19418	move.w	(sp)+,d0
L1941A	sub.b	d7,$40(a3)
	bpl.w	Sub_31AB6
L19422	bclr	#$0,$62(a3)
	bra.w	Sub_362C4
	dc.w	$302B,$0044,$322B,$0046,$41FA,$7BCA,$6000,$1BCE
assshoot
	btst	#$5,$62(a3)
	bne.w	Sub_31AB6
	bclr	#$1,$62(a3)
	beq.w	L19454
	bra.w	Sub_313CA
L19454	btst	#$3,$17F6A.l
	beq.w	Sub_362C4
	clr.w	d2
	sub.w	d7,$42(a3)
	bpl.w	ShotMode
	bset	#$5,d2
	bra.w	ShotMode
puckshootout
	bclr	#$1,$62(a3)
	beq.w	L195A8
	bset	#$7,$17F7A.l
	clr.l	$17DCA.l
	clr.l	$17DCE.l
	clr.l	$17DD2.l
	bclr	#$7,$17F78.l
	btst	#$0,$17F78.l
	beq.w	L194B4
	jsr	(NextShooter).l
	bra.w	L194DA
L194B4	jsr	(StartShootoutPath).l
	move.l	a2,-(sp)
	movea.l	#tmstruct,a2
	dc.w	$4A79,$0001,$9366
	beq.w	L194D2
	movea.l	#awtmstruct,a2
L194D2	addi.w	#$1,$362(a2)
	movea.l	(sp)+,a2
L194DA	bclr	#$2,$17F70.l
	bclr	#$4,$17F70.l
	bclr	#$5,$17F70.l
	bclr	#$6,$17F70.l
	bset	#$1,(sflags6).l
	btst	#$3,$17F68.l
	bne.w	Stop4Pen
	bclr	#$1,$62(a3)
	btst	#$0,$17F78.l
	beq.w	L19556
	dc.w	$4A79,$0001,$A436
	bne.w	L19578
	dc.w	$4A79,$0001,$A428
	bne.w	L19578
	dc.w	$33F9,$0001,$7FAE,$0001,$A56C
	dc.w	$33FC,$0002,$0001,$A56E
	jsr	(ChooseSong).l
	dc.w	$3F39,$0001,$A56A
	bra.w	L19574
L19556	dc.w	$33F9,$0001,$7FAE,$0001,$A56C
	dc.w	$33FC,$0002,$0001,$A56E
	jsr	(ChooseSong).l
	dc.w	$3F39,$0001,$A56A
L19574	bsr.w	song
L19578	bset	#$0,$17F68.l
	bset	#$1,$17F78.l
	dc.w	$4279,$0001,$7BA8
	dc.w	$4279,$0001,$7BAA
	dc.w	$33FC,$0019,$0001,$93B6
	bsr.w	ReturnGoalies
	st.b	$40(a3)
	st.b	$42(a3)
L195A8	bset	#$2,$17F70.l
	movem.w	d1-d2,-(sp)
	dc.w	$4EB9,$0003,$4666
	bmi.w	L195C6
	movem.w	(sp)+,d1-d2
	bra.w	L195DC
L195C6	movem.w	(sp)+,d1-d2
	bclr	#$2,$17F70.l
	move.w	#$1B,d0
	bsr.w	Sub_362E4
	rts
L195DC	movem.w	d1-d2,-(sp)
	dc.w	$3039,$0001,$936A
	dc.w	$247C,$0001,$7480
	asl.w	#$7,d0
	adda.w	d0,a2
	tst.w	$34(a2)
	bne.w	L19602
	btst	#$2,$63(a2)
	beq.w	L19654
L19602	dc.w	$3039,$0001,$936A
	move.w	#$6,d2
L1960C	subi.w	#$1,d2
	bmi.w	L195C6
	subi.w	#$1,d0
	bpl.w	L19624
	move.w	#$5,d0
	bra.w	L19630
L19624	cmpi.w	#$5,d0
	bne.w	L19630
	move.w	#$B,d0
L19630	dc.w	$247C,$0001,$7480
	move.w	d0,d1
	asl.w	#$7,d1
	adda.w	d1,a2
	tst.w	$34(a2)
	bne.w	L1960C
	btst	#$2,$63(a2)
	bne.w	L1960C
	dc.w	$33C0,$0001,$936A
L19654	movem.w	(sp)+,d1-d2
	movea.l	#tmstruct,a2
	move.w	#$1F,d0
	bra.w	Sub_362E4
