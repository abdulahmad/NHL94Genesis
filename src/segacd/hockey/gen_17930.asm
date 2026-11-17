Sub_32930
	dc.w	$33F9,$0001,$7B80,$0001,$AD58
	btst	#$0,$17F72.l
	beq.w	L179E8
	btst	#$1,$63(a3)
	bne.w	L179E8
	btst	#$1,$17F72.l
	beq.w	L17990
	btst	#$3,$17F72.l
	bne.w	L179E8
	cmpi.w	#$2C4,$6(a3)
	bne.w	L179E8
	cmpi.w	#$2C8,$6(a3)
	bne.w	L179E8
	bset	#$3,$17F72.l
	move.w	#$1C,-(sp)
	bsr.w	sfx
	bra.w	L179E8
L17990	movem.w	d0-d1,-(sp)
	dc.w	$3039,$0001,$7B94
	move.w	$14(a3),d1
	eor.w	d1,d0
	movem.w	(sp)+,d0-d1
	bmi.w	L179E8
	cmpi.w	#$14,$0(a3)
	bgt.w	L179E8
	cmpi.w	#$FFEC,$0(a3)
	ble.w	L179E8
	bset	#$1,$17F72.l
	bclr	#$3,$17F72.l
	move.w	#$1596,d1
	btst	#$7,$62(a3)
	beq.w	L179DE
	move.w	#$1684,d1
L179DE	bsr.w	Sub_363C0
	bset	#$1,$63(a3)
L179E8	btst	#$5,$62(a3)
	bne.w	L18056
	bsr.w	Sub_31906
	bclr	#$1,$62(a3)
	beq.w	L17A0E
	clr.w	$40(a3)
	move.w	#$8,$42(a3)
	st.b	$46(a3)
L17A0E	cmpi.w	#$34,$0(a3)
	bgt.w	L17A4A
	cmpi.w	#$FFCC,$0(a3)
	blt.w	L17A4A
	cmpi.w	#$10E,$14(a3)
	bgt.w	L17A4A
	cmpi.w	#$FEF2,$14(a3)
	blt.w	L17A4A
	cmpi.w	#$D2,$14(a3)
	bgt.w	L17A6E
	cmpi.w	#$FF2E,$14(a3)
	blt.w	L17A6E
L17A4A	lea.l	L18056(pc),a0
	moveq	#$4,d0
	tst.w	$0(a3)
	bpl.w	L17A5A
	neg.w	d0
L17A5A	move.w	#$E4,d1
	btst	#$7,$62(a3)
	beq.w	skateto
	neg.w	d1
	bra.w	skateto
L17A6E	btst	#$1,$63(a3)
	bne.w	L18056
	btst	#$0,$17F72.l
	beq.w	L17AA8
	cmpi.w	#$2C5,$6(a3)
	beq.w	L17AA2
	cmpi.w	#$2C9,$6(a3)
	bne.w	L17AA8
	move.w	#$4,$54(a3)
	bra.w	L17AA8
L17AA2	move.w	#$0,$54(a3)
L17AA8	move.w	#$2,d1
	bsr.w	Sub_363C0
	btst	#$2,$17F70.l
	bne.w	L17AC8
	btst	#$0,$17F68.l
	bne.w	L18056
L17AC8	tst.w	$48(a3)
	bmi.w	L17B0C
	move.w	$52(a3),d0
	cmp.w	$17BE0.l,d0
	beq.w	L17AE6
	st.b	$48(a3)
	bra.w	L17B0C
L17AE6	sub.w	d7,$48(a3)
	bpl.w	L17B0C
	btst	#$2,$17F70.l
	beq.w	L17B06
	bset	#$4,$17F70.l
	bra.w	L17B0C
L17B06	moveq	#$8,d0
	bsr.w	AddPenalty2
L17B0C	sub.b	d7,$40(a3)
	bpl.w	L17F82
	move.b	$6B(a3),d0
	beq.w	L17B2C
	btst	#$6,$17F7A.l
	beq.w	L17B2C
	subi.b	#$1,d0
L17B2C	lsr.b	#$2,d0
	move.b	d0,$40(a3)
	btst	#$3,$62(a3)
	beq.w	L17B4C
	btst	#$2,$64(a3)
	bne.w	L17B4C
	moveq	#$1D,d0
	bra.w	Sub_362D8
L17B4C	dc.w	$3039,$0001,$7B94
	move.w	$14(a3),d1
	eor.w	d0,d1
	bpl.w	L17B72
	clr.w	d0
	move.w	#$F4,d2
	btst	#$7,$62(a3)
	beq.w	L17F34
	neg.w	d2
	bra.w	L17F34
L17B72	subi.w	#$1,$46(a3)
	bpl.w	L17B82
	move.w	#$FFFF,$46(a3)
L17B82	move.w	$52(a3),d0
	cmp.w	$17BE0.l,d0
	bne.w	L17C6C
	tst.w	$48(a3)
	bpl.w	L17B9E
	move.w	#$5A,$48(a3)
L17B9E	st.b	$46(a3)
	cmpi.w	#$5A,$48(a3)
	bgt.w	L17D12
L17BAC	btst	#$7,$FF800E.l
	bne.b	L17BAC
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
L17BC6	btst	#$6,$FF800E.l
	beq.b	L17BC6
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L17BE6	btst	#$6,$FF800E.l
	bne.b	L17BE6
	bclr	#$7,$FF800F.l
	andi.w	#$3,d0
	bne.w	L17D12
	moveq	#$5,d0
	dc.w	$207C,$0001,$7480
	btst	#$6,$62(a3)
	bne.w	L17C16
	adda.w	#$300,a0
L17C16	btst	#$2,$63(a0)
	bne.w	L17C54
	dc.w	$3239,$0001,$7B94
	sub.w	$14(a0),d1
	cmpi.w	#$1C,d1
	bgt.w	L17C54
	cmpi.w	#$FFE4,d1
	blt.w	L17C54
	dc.w	$3239,$0001,$7B80
	sub.w	$0(a0),d1
	cmpi.w	#$19,d1
	bgt.w	L17C54
	cmpi.w	#$FFE7,d1
	bgt.w	L17D12
L17C54	adda.w	#$80,a0
	dbra	d0,L17C16
	move.w	#$1,$17E34.l
	bsr.w	chk4pass
	bra.w	L17D12
L17C6C	tst.w	$46(a3)
	bne.w	L17D12
	tst.w	$17BE0.l
	bpl.w	L17D12
	dc.w	$3039,$0001,$7B80
	sub.w	$0(a3),d0
	cmpi.w	#$14,d0
	bgt.w	L17D12
	cmpi.w	#$FFEC,d0
	blt.w	L17D12
	dc.w	$3239,$0001,$7B94
	cmpi.w	#$108,d1
	bgt.w	L17D12
	cmpi.w	#$FEF8,d1
	blt.w	L17D12
	sub.w	$14(a3),d1
	cmpi.w	#$1E,d1
	bgt.w	L17D12
	cmpi.w	#$FFE2,d1
	blt.w	L17D12
	movem.w	d0-d1,-(sp)
	dc.w	$3039,$0001,$7BA8
	bpl.w	L17CD2
	neg.w	d0
L17CD2	dc.w	$3239,$0001,$7BAA
	bpl.w	L17CDE
	neg.w	d1
L17CDE	add.w	d1,d0
	cmpi.w	#$1000,d0
	movem.w	(sp)+,d0-d1
	bgt.w	L17D12
	bsr.w	vtoa
	move.w	d0,$54(a3)
	move.b	#$8,$5E(a3)
	move.w	#$2F4,d1
	bsr.w	Sub_363C0
	bset	#$1,$63(a3)
	addi.w	#$96,(Crowdlevel).l
	rts
L17D12	movea.l	#$17E36,a0
	move.w	#$104,d3
	btst	#$7,$62(a3)
	beq.w	L17D2C
	adda.w	#$4,a0
	neg.w	d3
L17D2C	cmpi.w	#$104,$14(a3)
	bgt.w	L17D40
	cmpi.w	#$FEFC,$14(a3)
	bgt.w	L17D6A
L17D40	clr.w	d2
	clr.w	d0
	cmpi.w	#$2C,$0(a3)
	bgt.w	L17F34
	cmpi.w	#$FFD4,$0(a3)
	blt.w	L17F34
	move.w	#$88,d0
	tst.w	$0(a3)
	bpl.w	L17F34
	neg.w	d0
	bra.w	L17F34
L17D6A	tst.w	$17BE0.l
	bmi.w	L17DAC
	move.w	$52(a3),d0
	cmp.w	$17BE0.l,d0
	beq.w	L17DAC
	move.l	a0,-(sp)
	dc.w	$207C,$0001,$7480
	move.w	$17BE0.l,d0
	asl.w	#$7,d0
	adda.w	d0,a0
	dc.w	$3039,$0001,$7B80
	sub.w	$0(a0),d0
	asr.w	#$1,d0
	add.w	$0(a0),d0
	move.w	d0,$1AD58.l
	movea.l	(sp)+,a0
L17DAC	move.w	$1AD58.l,d0
	dc.w	$3239,$0001,$7B94
	bsr.w	ClampYPosition
	bsr.w	vtoa
	bsr.w	AdjustFacingDirection
	dc.w	$3039,$0001,$80E6
	andi.w	#$7,d0
	asl.w	#$4,d0
	addi.w	#$A0,d0
	dc.w	$0C79,$00DB,$0001,$7B94
	bgt.w	L17DEC
	dc.w	$0C79,$FF25,$0001,$7B94
	bgt.w	L17DF0
L17DEC	subi.w	#$40,d0
L17DF0	move.w	d0,d1
	dc.w	$C1F9,$0001,$7BA8
	swap	d0
	add.w	$1AD58.l,d0
	dc.w	$C3F9,$0001,$7BAA
	swap	d1
	dc.w	$D279,$0001,$7B94
	bsr.w	ClampYPosition
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	cmpi.l	#$384,d0
	bhi.w	L17E2E
	movem.w	(sp)+,d0-d1
	bra.w	L17E58
L17E2E	bsr.w	Sroot
	moveq	#$1,d2
	add.w	d0,d2
	moveq	#$12,d4
	btst	#$3,$17F6A.l
	beq.w	L17E48
	addi.w	#$8,d4
L17E48	movem.w	(sp)+,d0-d1
	muls.w	d4,d1
	addi.w	#$8,d4
	muls.w	d4,d0
	divs.w	d2,d0
	divs.w	d2,d1
L17E58	add.w	d3,d1
	move.w	d1,d2
	btst	#$0,$17F78.l
	bne.w	L17EC0
	btst	#$2,$17F70.l
	bne.w	L17EC0
	btst	#$3,$17F6A.l
	beq.w	L17EC0
	dc.w	$0C79,$00D0,$0001,$7B94
	bgt.w	L17E9C
	dc.w	$0C79,$FF30,$0001,$7B94
	blt.w	L17E9C
	bra.w	L17EC0
L17E9C	cmpi.w	#$14,$0(a3)
	bgt.w	L17EC0
	cmpi.w	#$FFEC,$0(a3)
	blt.w	L17EC0
	btst	#$1,$180E7.l
	bne.w	L17EC0
	bra.w	L17EE4
L17EC0	cmpi.w	#$22,$2(a0)
	bhi.w	L17F34
	cmpi.w	#$18,(a0)
	bgt.w	L17F94
	cmpi.w	#$FFE8,(a0)
	blt.w	L17F94
	cmpi.w	#$C,$2(a0)
	bhi.w	L17F0C
L17EE4	dc.w	$0C79,$0108,$0001,$7B94
	bgt.w	L17F0C
	dc.w	$0C79,$FEF8,$0001,$7B94
	blt.w	L17F0C
	bset	#$1,$63(a3)
	bne.w	L17F0C
	jsr	$330AC.l
L17F0C	move.w	(a0),d0
	dc.w	$0C79,$00FC,$0001,$7B94
	bgt.w	L17F26
	dc.w	$0C79,$FF04,$0001,$7B94
	bgt.w	L17F34
L17F26	moveq	#$18,d0
	tst.w	$1AD58.l
	bpl.w	L17F34
	neg.w	d0
L17F34	move.w	d2,d1
	movem.w	d0-d1,-(sp)
	move.b	$28(a3),d0
	ext.w	d0
	neg.w	d0
	add.w	(sp)+,d0
	sub.w	$0(a3),d0
	move.b	$2A(a3),d1
	ext.w	d1
	neg.w	d1
	add.w	(sp)+,d1
	sub.w	$14(a3),d1
	cmpi.w	#$4,d0
	bgt.w	L17F7A
	cmpi.w	#$FFFC,d0
	blt.w	L17F7A
	cmpi.w	#$4,d1
	bgt.w	L17F7A
	cmpi.w	#$FFFC,d1
	blt.w	L17F7A
	clr.w	d0
	clr.w	d1
L17F7A	bsr.w	vtoa
	move.b	d0,$43(a3)
L17F82	move.b	$43(a3),d2
	ext.w	d2
	cmpi.w	#$7,d2
	ble.w	Sub_36878
	bra.w	stopna
L17F94	tst.w	$17BE0.l
	bpl.w	L17F34
	btst	#$2,$17ECE.l
	bne.w	L17F34
	movea.l	#tmstruct,a1
	lea.l	$366(a1),a2
	btst	#$6,$62(a3)
	beq.w	L17FC0
	exg.l	a1,a2
L17FC0	cmpi.l	#$1324,$2C(a1)
	blt.w	L17F34
	cmpi.l	#$9C4,$2C(a2)
	blt.w	L17F34
	dc.w	$0C79,$00E0,$0001,$7B94
	bgt.w	L17FF0
	dc.w	$0C79,$FF20,$0001,$7B94
	bgt.w	L17F34
L17FF0	dc.w	$4A79,$0001,$7BAA
	btst	#$7,$62(a3)
	beq.w	L18004
	eori.b	#$8,ccr
L18004	bmi.w	L17F34
	dc.w	$3039,$0001,$7BA8
	bpl.w	L18014
	neg.w	d0
L18014	dc.w	$3239,$0001,$7BAA
	bpl.w	L18020
	neg.w	d1
L18020	cmp.w	d0,d1
	blt.w	L17F34
	moveq	#$F,d0
	bra.w	Sub_362D8
ClampYPosition
	move.w	$17BE0.l,d2
	cmp.w	$52(a3),d2
	bne.w	L1803C
	clr.w	d0
L1803C	cmpi.w	#$103,d1
	blt.w	L18048
	move.w	#$103,d1
L18048	cmpi.w	#$FEFD,d1
	bgt.w	L18054
	move.w	#$FEFD,d1
L18054	sub.w	d3,d1
L18056	rts
AdjustFacingDirection
	move.w	$54(a3),d1
	sub.w	d1,d0
	beq.w	Sub_31AB6
	neg.w	d0
	andi.w	#$4,d0
	lsr.w	#$1,d0
	subi.w	#$1,d0
	btst	#$3,$62(a3)
	bne.w	L180A0
	dc.w	$033C,$0042,$6700
	dc.w	$0022,$D240
	btst	#$7,$62(a3)
	dc.w	$6600,$000A
	dc.w	$033C,$0083,$6000
	dc.w	$0006,$033C
	dc.w	$0038,$6700,$0008
	neg.w	d0
	add.w	d0,d1
L180A0	add.w	d0,d1
	andi.w	#$7,d1
	move.w	d1,$54(a3)
	rts
	move.w	(a0),d0
	sub.w	$0(a3),d0
	move.w	d3,d1
	sub.w	$14(a3),d1
	bsr.w	vtoa
	sub.w	$54(a3),d0
	andi.w	#$7,d0
	move.w	d0,d3
	lsr.w	#$2,d0
	btst	#$3,$4(a3)
	beq.w	L180D6
	eori.w	#$1,d0
L180D6	cmpi.w	#$8,$17B98.l
	bgt.w	L180F2
	dc.w	$0C79,$0800,$0001,$7BAC
	bgt.w	L180F2
	bra.w	L18120
L180F2	movem.l	d0,-(sp)
	move.w	$0(a3),d0
	sub.w	(a0),d0
	cmpi.w	#$10,d0
	bgt.w	L18118
	cmpi.w	#$FFF0,d0
	blt.w	L18118
	movem.l	(sp)+,d0
	addi.w	#$6,d0
	bra.w	L181DA
L18118	movem.l	(sp)+,d0
	bra.w	L181DA
L18120	addi.w	#$4,d0
	cmpi.w	#$8,$2(a0)
	bls.w	L181B0
	cmpi.w	#$2,$54(a3)
	beq.w	L181DA
	cmpi.w	#$6,$54(a3)
	beq.w	L181DA
	tst.w	$17BE0.l
	bmi.w	L181DA
	subi.w	#$2,d0
	move.w	d1,-(sp)
	move.w	#$1000,d1
	move.w	d1,$28(a3)
	ori.w	#$1,d0
	btst	#$7,$62(a3)
	bne.w	L1816C
	eori.w	#$1,d0
L1816C	move.w	#$FFFA,d1
	tst.w	$28(a3)
	bmi.w	L1817C
	neg.w	$28(a3)
L1817C	tst.w	$0(a3)
	bpl.w	L18198
	tst.w	$28(a3)
	bpl.w	L18190
	neg.w	$28(a3)
L18190	move.w	#$6,d1
	eori.w	#$1,d0
L18198	add.w	d1,$0(a3)
	btst	#$0,$76(a3)
	beq.w	L181AA
	eori.w	#$1,d0
L181AA	move.w	(sp)+,d1
	bra.w	L181DA
L181B0	movem.l	d0,-(sp)
	move.w	$0(a3),d0
	sub.w	(a0),d0
	cmpi.w	#$10,d0
	ble.w	L181CA
	movem.l	(sp)+,d0
	bra.w	L181D6
L181CA	cmpi.w	#$FFF0,d0
	movem.l	(sp)+,d0
	bgt.w	L181DA
L181D6	addi.w	#$4,d0
L181DA	add.w	d0,d0
	dc.w	$43FA,$004A
	move.w	(a1,d0.w),d1
	cmpi.w	#$178,d1
	bne.w	L18202
	andi.w	#$3,d3
	beq.w	L18202
	cmpi.b	#$B,$73(a3)
	blt.w	L18202
	move.w	#$1AA,d1
L18202	bsr.w	Sub_363C0
	addi.w	#$96,(Crowdlevel).l
	dc.w	$0679,$000A,$0001,$7CD8
	asr.w	$28(a3)
	asr.w	$28(a3)
	asr.w	$2A(a3)
	asr.w	$2A(a3)
	rts
	dc.w	$0146,$0178,$0250,$02A2,$01EC,$021E,$148E,$14C0
	dc.w	$14F2,$1544
assgoalietopuck
	btst	#$3,$62(a3)
	bne.w	Sub_362C4
	btst	#$0,$17F68.l
	bne.w	Sub_362C4
	bsr.w	Sub_31906
	bclr	#$1,$62(a3)
	beq.w	L18264
	clr.w	$40(a3)
L18264	sub.b	d7,$40(a3)
	bpl.w	L182DA
	move.b	$6B(a3),d0
	beq.w	L18284
	btst	#$6,$17F7A.l
	beq.w	L18284
	subi.b	#$1,d0
L18284	lsr.b	#$2,d0
	move.b	d0,$40(a3)
	tst.w	$17BE0.l
	bpl.w	Sub_362C4
	dc.w	$4A79,$0001,$7BAA
	btst	#$7,$62(a3)
	beq.w	L182A8
	eori.b	#$8,ccr
L182A8	bmi.w	Sub_362C4
	movea.l	#tmstruct,a1
	lea.l	$366(a1),a2
	btst	#$6,$62(a3)
	beq.w	L182C2
	exg.l	a1,a2
L182C2	cmpi.l	#$E10,$2C(a1)
	blt.w	Sub_362C4
	cmpi.l	#$640,$2C(a2)
	blt.w	Sub_362C4
L182DA	bra.w	skatetopuck
breakaway
	bset	#$2,$17F74.l
	bclr	#$1,$62(a3)
	beq.w	L1832E
	move.w	#$2,-(sp)
	dc.w	$4EB9,$0003,$710C
	movem.l	a2,-(sp)
	movea.l	#tmstruct,a2
	btst	#$6,$62(a3)
	beq.w	L18314
	movea.l	#awtmstruct,a2
L18314	addi.w	#$1,$35A(a2)
	dc.w	$0679,$0014,$0001,$7CD8
	addi.w	#$C8,(Crowdlevel).l
	movem.l	(sp)+,a2
L1832E	movem.w	d1,-(sp)
	move.w	$14(a3),d0
	move.w	$2A(a3),d1
	beq.w	L18346
	eor.w	d1,d0
L18340	movem.w	(sp)+,d1
	rts
L18346	move.w	#$FFFF,d1
	bra.w	L18340
BreakawayOffsidesFlagSet
	btst	#$1,$62(a3)
	beq.w	L18364
	bclr	#$0,$64(a3)
	bclr	#$1,$64(a3)
L18364	movem.w	d0-d1/a0,-(sp)
	move.w	#$108,d0
	move.w	$14(a3),d1
	bpl.w	L18376
	neg.w	d1
L18376	cmp.w	d0,d1
	bge.w	L183F0
	move.w	#$58,d0
	move.w	$14(a3),d1
	btst	#$7,$62(a3)
	bne.w	L1839A
	neg.w	d0
	cmp.w	d1,d0
	blt.w	L183A0
	bra.w	L183AA
L1839A	cmp.w	d1,d0
	blt.w	L183AA
L183A0	bset	#$0,$64(a3)
	bra.w	L183F0
L183AA	bclr	#$0,$64(a3)
	beq.w	L183F0
	movea.l	#$17A00,a0
	move.w	#$B,d0
	tst.w	d1
	bmi.w	L183F8
L183C4	cmp.w	$14(a0),d1
	bge.w	L183D8
	tst.w	$34(a0)
	beq.w	L183D8
	bra.w	L183F0
L183D8	suba.w	#$80,a0
	dbra	d0,L183C4
L183E0	bset	#$1,$64(a3)
	move.w	#$1,d0
L183EA	movem.w	(sp)+,d0-d1/a0
	rts
L183F0	move.w	#$0,d0
	bra.w	L183EA
L183F8	cmp.w	$14(a0),d1
	ble.w	L1840C
	tst.w	$34(a0)
	beq.w	L1840C
	bra.w	L183F0
L1840C	suba.w	#$80,a0
	dbra	d0,L183F8
	bra.w	L183E0
chkpuckc
	btst	#$0,$17F78.l
	bne.w	L18438
	btst	#$2,$17F70.l
	bne.w	L18438
	bsr.w	breakaway
	bpl.w	asspuckc
L18438	bclr	#$1,$64(a3)
	move.w	#$10,d0
	bsr.w	Sub_362E4
asspuckc
	bclr	#$2,$17F74.l
	bne.w	L18458
	bclr	#$1,$64(a3)
L18458	move.w	$17BE0.l,d0
	cmp.w	$52(a3),d0
	bne.w	Sub_362C4
	btst	#$2,$17F70.l
	beq.w	L1847E
	cmpi.w	#$1,$17F98.l
	bgt.w	Sub_337C8
L1847E	btst	#$1,$64(a3)
	bne.w	L184AA
	btst	#$2,$17F70.l
	bne.w	L184AA
	jsr	(BreakawayOffsidesFlagSet).l
	beq.w	L184AA
	move.w	#$21,d0
	bsr.w	Sub_362E4
	bra.w	L184AA
L184AA	btst	#$5,$62(a3)
	bne.w	Sub_337C8
	btst	#$2,$17F70.l
	bne.w	L184CC
	btst	#$0,$17F68.l
	bne.w	Sub_31EB2
L184CC	btst	#$3,$62(a3)
	bne.w	Sub_362C4
	bclr	#$1,$62(a3)
	beq.w	L18590
	btst	#$1,$64(a3)
	beq.w	L184F4
	move.w	#$2,-(sp)
	dc.w	$4EB9,$0003,$710C
L184F4	btst	#$1,$64(a3)
	beq.w	L18532
	movem.l	a2,-(sp)
	movea.l	#tmstruct,a2
	btst	#$6,$62(a3)
	beq.w	L18518
	movea.l	#awtmstruct,a2
L18518	addi.w	#$1,$35A(a2)
	dc.w	$0679,$0014,$0001,$7CD8
	addi.w	#$C8,(Crowdlevel).l
	movem.l	(sp)+,a2
L18532	clr.w	$40(a3)
	move.w	#$8,$42(a3)
L1853C	btst	#$7,$FF800E.l
	bne.b	L1853C
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
L18556	btst	#$6,$FF800E.l
	beq.b	L18556
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L18576	btst	#$6,$FF800E.l
	bne.b	L18576
	bclr	#$7,$FF800F.l
	andi.w	#$3,d0
	move.w	d0,$44(a3)
L18590	sub.b	d7,$40(a3)
	bpl.w	L18652
	move.b	$6A(a3),$40(a3)
	jsr	(ReadGoaliePulled).l
	bmi.w	L185BC
	btst	#$6,$17F7A.l
	beq.w	L185C2
	tst.b	$40(a3)
	beq.w	L185C2
L185BC	subi.b	#$1,$40(a3)
L185C2	btst	#$2,$17F70.l
	bne.w	L1863E
	btst	#$0,$17F78.l
	bne.w	L1863E
	bsr.w	checkob
	bsr.w	Sub_337F2
	btst	#$0,$17F78.l
	bne.w	L1863E
	btst	#$2,$17F70.l
	bne.w	L1863E
	btst	#$1,$64(a3)
	bne.w	L18636
	move.w	#$1,d0
	btst	#$6,$62(a3)
	beq.w	L18616
	move.w	#$2,d0
L18616	dc.w	$B079,$0001,$7FA6
	beq.w	L18636
	dc.w	$B079,$0001,$7FA8
	beq.w	L18636
	btst	#$1,$17475.l
	bne.w	L1864E
L18636	bsr.w	Sub_338E8
	bra.w	L1864E
L1863E	jsr	$2A84A.l
	bne.w	L18652
	dc.w	$4EB9,$0003,$3AC8
L1864E	bsr.w	chk4pass
L18652	moveq	#$6,d0
	add.w	$44(a3),d0
	dc.w	$41FA,$0170
	btst	#$7,$17F6C.l
	beq.w	L1866C
	move.w	$34(a3),d0
L1866C	asl.w	#$2,d0
	move.w	$2(a0,d0.w),d1
	move.w	(a0,d0.w),d0
	btst	#$2,$17F70.l
	bne.w	L1868E
	btst	#$0,$17F78.l
	beq.w	L186A0
L1868E	jsr	$2A7B6.l
	dc.w	$0C39,$0080,$0001,$A8B8
	beq.w	Sub_337C8
L186A0	btst	#$7,$62(a3)
	bne.w	L186AE
	neg.w	d0
	neg.w	d1
L186AE	dc.w	$41FA,$0022
	btst	#$2,$17F70.l
	bne.w	L186CA
	btst	#$0,$17F78.l
	beq.w	L186CE
L186CA	lea.l	Sub_337C8(pc),a0
L186CE	bra.w	skateto
	dc.w	$4880,$142B,$0028,$4882,$D479,$0001,$7B80,$162B
	dc.w	$002A,$4883,$D679,$0001,$7B94,$4279,$0001,$7E34
	dc.w	$7805,$207C,$0001,$7480,$0C6B,$0006,$0052,$6C00
	dc.w	$0006,$D0FC,$0300,$1228,$0028,$4881,$D268,$0000
	dc.w	$9242,$0C41,$0014,$6E00,$00A6,$0C41,$FFEC,$6D00
	dc.w	$009E,$1228,$002A,$4881,$D268,$0014,$9243,$0C41
	dc.w	$0014,$6E00,$008A,$0C41,$FFEC,$6D00,$0082,$0679
	dc.w	$0001,$0001,$7E34,$302B,$0000,$9068,$0000,$322B
	dc.w	$0014,$9268,$0014,$6100,$2B9E,$322B,$0054,$0A41
	dc.w	$0004,$B240,$6600,$0058,$0839,$0007,$00FF,$800E
	dc.w	$66F6,$33FC,$001B,$00FF,$8020,$08F9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$67F6,$3239,$00FF
	dc.w	$8010,$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007
	dc.w	$00FF,$800F,$0241,$0001,$D041,$0240,$0007,$D0FC
	dc.w	$0080,$51CC,$FF42
Sub_337C8
	rts
chk4lc
	dc.w	$FF9C
	dc.w	$FFEC
	ori.w	#$FFEC,-(a4)
	dc.w	$FF88
	ori.b	#$14,$28(a0)
	ori.w	#$28,$FFFFFFEC.w
	dc.w	$0028,$FFD8,$00F0
	ori.b	#$DC,d0
	ori.b	#$E6,(a4)
	ori.b	#$E6,(a6)+
Sub_337F2
	btst	#$4,$17F7A.l
	bne.w	L188B4
	dc.w	$3039,$0001,$7B94
	btst	#$7,$62(a3)
	bne.w	L18810
	neg.w	d0
L18810	tst.w	d0
	bmi.w	Sub_31AB6
	cmpi.w	#$58,d0
	bgt.w	Sub_31AB6
L1881E	btst	#$7,$FF800E.l
	bne.b	L1881E
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
L18838	btst	#$6,$FF800E.l
	beq.b	L18838
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L18858	btst	#$6,$FF800E.l
	bne.b	L18858
	bclr	#$7,$FF800F.l
	andi.w	#$3,d0
	bne.w	Sub_31AB6
	btst	#$3,$63(a3)
	bne.w	Sub_31AB6
	movea.l	#tmstruct,a2
	lea.l	$366(a2),a1
	btst	#$6,$62(a3)
	beq.w	L18892
	exg.l	a1,a2
L18892	jsr	(AvgCline).l
	cmpi.w	#$C00,d0
	bhi.w	Sub_31AB6
	bsr.w	CompLine
	dc.w	$4EB9,$0003,$D426
	dc.w	$4EB9,$0003,$C48C
	bra.w	CompShoot
L188B4	rts
Sub_338B6
	btst	#$5,$17F6C.l
	bne.w	chkpk2
	eori.b	#$4,ccr
	rts
chkpk2
	movem.l	d0-d1,-(sp)
	btst	#$6,$17F6C.l
	move.w	sr,d0
	btst	#$6,$62(a3)
	move.w	sr,d1
	eor.w	d1,d0
	move.w	d0,ccr
	movem.l	(sp)+,d0-d1
	rts
