setVram
	movea.l	#$BBCB0,a0
	moveq	#$3F,d1
L1CB62	move.w	d0,(a0)+
	dbra	d1,L1CB62
	move.w	#$18,(palcount).l
	bsr.w	Sub_36D66
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst	#$5,$FF800F.l
	dc.w	$6706
	move.w	#$1,-(a6)
	dc.w	$6004
L1CB8C	move.w	#$0,-(a6)
L1CB90	bclr	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
L1CBAE	btst	#$7,$FF800E.l
	bne.b	L1CBAE
	move.w	#$8F02,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
L1CBD0	btst	#$6,$FF800E.l
	beq.b	L1CBD0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1CBEA	btst	#$6,$FF800E.l
	bne.b	L1CBEA
	bclr	#$7,$FF800F.l
	clr.w	d0
	bsr.w	Sub_3871E
	clr.l	d1
L1CC04	btst	#$7,$FF800E.l
	bne.b	L1CC04
	move.w	#$20,$FF8020.l
	bset	#$6,$FF800F.l
L1CC1E	btst	#$6,$FF800E.l
	beq.b	L1CC1E
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1CC38	btst	#$6,$FF800E.l
	bne.b	L1CC38
	bclr	#$7,$FF800F.l
	move.w	#$8C00,d0
	btst	#$1,(disflags).l
	bne.w	L1CC5E
	ori.w	#$81,d0
L1CC5E	btst	#$7,$FF800E.l
	bne.b	L1CC5E
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
L1CC7E	btst	#$6,$FF800E.l
	beq.b	L1CC7E
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1CC98	btst	#$6,$FF800E.l
	bne.b	L1CC98
	bclr	#$7,$FF800F.l
L1CCAA	btst	#$7,$FF800E.l
	bne.b	L1CCAA
	move.w	#$8014,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
L1CCCC	btst	#$6,$FF800E.l
	beq.b	L1CCCC
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1CCE6	btst	#$6,$FF800E.l
	bne.b	L1CCE6
	bclr	#$7,$FF800F.l
L1CCF8	btst	#$7,$FF800E.l
	bne.b	L1CCF8
	move.w	#$8164,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
L1CD1A	btst	#$6,$FF800E.l
	beq.b	L1CD1A
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1CD34	btst	#$6,$FF800E.l
	bne.b	L1CD34
	bclr	#$7,$FF800F.l
	move.w	#$9001,d0
	cmpi.w	#$6,(Map1col).l
	beq.w	L1CD5A
	move.w	#$9003,d0
L1CD5A	btst	#$7,$FF800E.l
	bne.b	L1CD5A
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
L1CD7A	btst	#$6,$FF800E.l
	beq.b	L1CD7A
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1CD94	btst	#$6,$FF800E.l
	bne.b	L1CD94
	bclr	#$7,$FF800F.l
	move.w	#$8200,d0
	move.b	(VmMAP1).l,d0
	lsr.b	#$2,d0
	andi.b	#$38,d0
L1CDB6	btst	#$7,$FF800E.l
	bne.b	L1CDB6
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
L1CDD6	btst	#$6,$FF800E.l
	beq.b	L1CDD6
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1CDF0	btst	#$6,$FF800E.l
	bne.b	L1CDF0
	bclr	#$7,$FF800F.l
	move.w	#$8400,d0
	dc.w	$1039,$0001,$8D38
	lsr.b	#$5,d0
L1CE0E	btst	#$7,$FF800E.l
	bne.b	L1CE0E
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
L1CE2E	btst	#$6,$FF800E.l
	beq.b	L1CE2E
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1CE48	btst	#$6,$FF800E.l
	bne.b	L1CE48
	bclr	#$7,$FF800F.l
	move.w	#$8300,d0
	move.b	$18D3C.l,d0
	lsr.b	#$2,d0
	andi.b	#$3E,d0
L1CE6A	btst	#$7,$FF800E.l
	bne.b	L1CE6A
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
L1CE8A	btst	#$6,$FF800E.l
	beq.b	L1CE8A
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1CEA4	btst	#$6,$FF800E.l
	bne.b	L1CEA4
	bclr	#$7,$FF800F.l
	move.w	#$8500,d0
	dc.w	$1039,$0001,$8D32
	lsr.b	#$1,d0
L1CEC2	btst	#$7,$FF800E.l
	bne.b	L1CEC2
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
L1CEE2	btst	#$6,$FF800E.l
	beq.b	L1CEE2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1CEFC	btst	#$6,$FF800E.l
	bne.b	L1CEFC
	bclr	#$7,$FF800F.l
	move.w	#$8D00,d0
	move.b	$18D30.l,d0
	lsr.b	#$2,d0
L1CF1A	btst	#$7,$FF800E.l
	bne.b	L1CF1A
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
L1CF3A	btst	#$6,$FF800E.l
	beq.b	L1CF3A
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1CF54	btst	#$6,$FF800E.l
	bne.b	L1CF54
	bclr	#$7,$FF800F.l
L1CF66	btst	#$7,$FF800E.l
	bne.b	L1CF66
	move.w	#$9100,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
L1CF88	btst	#$6,$FF800E.l
	beq.b	L1CF88
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1CFA2	btst	#$6,$FF800E.l
	bne.b	L1CFA2
	bclr	#$7,$FF800F.l
L1CFB4	btst	#$7,$FF800E.l
	bne.b	L1CFB4
	move.w	#$9200,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
L1CFD6	btst	#$6,$FF800E.l
	beq.b	L1CFD6
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1CFF0	btst	#$6,$FF800E.l
	bne.b	L1CFF0
	bclr	#$7,$FF800F.l
L1D002	btst	#$7,$FF800E.l
	bne.b	L1D002
	move.w	#$8700,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
L1D024	btst	#$6,$FF800E.l
	beq.b	L1D024
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1D03E	btst	#$6,$FF800E.l
	bne.b	L1D03E
	bclr	#$7,$FF800F.l
L1D050	btst	#$7,$FF800E.l
	bne.b	L1D050
	move.w	#$8B00,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
L1D072	btst	#$6,$FF800E.l
	beq.b	L1D072
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1D08C	btst	#$6,$FF800E.l
	bne.b	L1D08C
	bclr	#$7,$FF800F.l
L1D09E	btst	#$7,$FF800E.l
	bne.b	L1D09E
	move.l	#$40000010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset	#$6,$FF800F.l
L1D0C2	btst	#$6,$FF800E.l
	beq.b	L1D0C2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1D0DC	btst	#$6,$FF800E.l
	bne.b	L1D0DC
	bclr	#$7,$FF800F.l
L1D0EE	btst	#$7,$FF800E.l
	bne.b	L1D0EE
	dc.w	$23FC,$0000,$0000,$00FF,$8022
	move.w	#$E,$FF8020.l
	bset	#$6,$FF800F.l
L1D112	btst	#$6,$FF800E.l
	beq.b	L1D112
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1D12C	btst	#$6,$FF800E.l
	bne.b	L1D12C
	bclr	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	dc.w	$670A
	bset	#$5,$FF800F.l
	dc.w	$6008
L1D15A	bclr	#$5,$FF800F.l
L1D162	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	rts
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_1D16C.bin
Sub_3871E
	movea.l	#$C00000,a0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	ori.w	#$4000,d0
	swap	d0
	andi.w	#$3,d0
L1D732	btst	#$7,$FF800E.l
	bne.b	L1D732
	move.l	d0,$FF8022.l
	move.w	#$B,$FF8020.l
	bset	#$6,$FF800F.l
L1D752	btst	#$6,$FF800E.l
	beq.b	L1D752
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1D76C	btst	#$6,$FF800E.l
	bne.b	L1D76C
	bclr	#$7,$FF800F.l
	rts
Sub_38780
	movea.l	#$C00000,a0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	ori.w	#$4000,d0
	swap	d0
	andi.w	#$3,d0
L1D794	btst	#$4,$FF800E.l
	bne.b	L1D794
	move.w	#$30,$FF8026.l
	move.l	d0,$FF8028.l
	bset	#$3,$FF800F.l
L1D7B4	btst	#$3,$FF800E.l
	beq.b	L1D7B4
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
L1D7CE	btst	#$3,$FF800E.l
	bne.b	L1D7CE
	bclr	#$4,$FF800F.l
	rts
dobitmap
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst	#$5,$FF800F.l
	dc.w	$6706
	move.w	#$1,-(a6)
	dc.w	$6004
L1D7FA	move.w	#$0,-(a6)
L1D7FE	bclr	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	move.w	(printy).l,-(sp)
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movem.l	d0-d3/d5-d6/a0-a3,-(sp)
	move.w	d1,d6
	movea.l	#$BBCB0,a3
	bra.w	L1D848
L1D832	move.b	(a0,d0.w),(a3,d0.w)
	dbra	d0,L1D832
L1D83C	adda.l	#$20,a0
	adda.l	#$20,a3
L1D848	moveq	#$1F,d0
	lsr.w	#$1,d5
	bcs.w	L1D832
	bne.w	L1D83C
	move.w	(printa).l,d5
	andi.w	#$F800,d5
	move.w	$E(sp),d2
	subi.w	#$1,d2
L1D866	bsr.w	xyVmMap
	move.w	d6,d0
	mulu.w	(a1),d0
	add.w	$2(sp),d0
	asl.w	#$1,d0
	move.w	$A(sp),d1
	subi.w	#$1,d1
	move.w	d1,(ThreeStars).l
	lea.l	$BC002.l,a0
L1D888	move.w	$4(a1,d0.w),d3
	add.w	d4,d3
	eor.w	d5,d3
	move.w	d3,(a0)+
	addi.w	#$2,d0
	dbra	d1,L1D888
L1D89A	btst	#$7,$FF800E.l
	bne.b	L1D89A
	move.w	#$21,$FF8020.l
	jsr	$222C2.l
	bset	#$6,$FF800F.l
	jsr	$22268.l
L1D8C0	btst	#$6,$FF800E.l
	beq.b	L1D8C0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1D8DA	btst	#$6,$FF800E.l
	bne.b	L1D8DA
	bclr	#$7,$FF800F.l
	addi.w	#$1,(printy).l
	addi.w	#$1,d6
	dbra	d2,L1D866
	btst	#$0,(sflags6).l
	bne.w	L1D90E
	dc.w	$4EB9,$0003,$8958
L1D90E	movem.l	(sp)+,d0-d3/d5-d6/a0-a3
	move.w	(sp)+,(disflags).l
	move.w	(sp)+,(printy).l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	dc.w	$670A
	bset	#$5,$FF800F.l
	dc.w	$6008
L1D934	bclr	#$5,$FF800F.l
L1D93C	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	rts
DecompressGraphicsWithRemap
	move.l	(sp),$18AE4.l
	bsr.w	L1D95E
	addi.l	#$8,(sp)
	rts
DecompressGraphicsPlain
	clr.l	$18AE4.l
L1D95E	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst	#$5,$FF800F.l
	dc.w	$6706
	move.w	#$1,-(a6)
	dc.w	$6004
L1D976	move.w	#$0,-(a6)
L1D97A	bclr	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	movem.l	d0-d1/a0-a6,-(sp)
	moveq	#$0,d0
	moveq	#$0,d1
	movea.l	a2,a0
	move.w	d4,d1
	asl.w	#$5,d1
	move.w	(a0)+,d0
	beq.w	L1D9CA
	bmi.w	L1D9C0
	add.w	d0,d4
	asl.w	#$4,d0
	pea.l	$389CA.l
	tst.l	$18AE4.l
	beq.w	Sub_37762
	movea.l	$18AE4.l,a1
	bra.w	Sub_36C14
L1D9C0	andi.w	#$7FFF,d0
	add.w	d0,d4
	bsr.w	DecompressBytecode
L1D9CA	movem.l	(sp)+,d0-d1/a0-a6
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	dc.w	$670A
	bset	#$5,$FF800F.l
	dc.w	$6008
L1D9E4	bclr	#$5,$FF800F.l
L1D9EC	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	rts
DecompressBytecode
	movea.l	#ThreeStars,a1
	movea.l	#ThreeStars,a3
	movea.l	#$18AE4,a4
	movea.l	#Sub_36C14,a5
	movea.l	#Sub_37762,a6
	movem.l	d0-d3/a0-a2,-(sp)
	move.w	d1,d3
	clr.w	d1
	clr.w	d2
L1DA1E	move.b	(a0)+,d0
	andi.w	#$F0,d0
	lsr.w	#$3,d0
	dc.w	$45FA,$000C
	move.w	(a2,d0.w),d0
	jsr	(a2,d0.w)
	bra.b	L1DA1E
DecompressOpcodeTable
	dc.w	$0020,$0020,$003C,$0058,$0078,$0078,$0078,$0078
	dc.w	$00AA,$00B8,$00D2,$00EC,$0106,$0106,$0138,$0158
Opcode_CopyLiteral
	move.b	-$1(a0),d0
	andi.w	#$1F,d0
L1DA5C	move.b	(a0)+,(a1,d1.w)
	addq.b	#$1,d1
	bne.w	L1DA6A
	bsr.w	FlushOutputBuffer
L1DA6A	dbra	d0,L1DA5C
	rts
Opcode_ClearBytes
	move.b	-$1(a0),d0
	andi.w	#$F,d0
L1DA78	clr.b	(a1,d1.w)
	addq.b	#$1,d1
	bne.w	L1DA86
	bsr.w	FlushOutputBuffer
L1DA86	dbra	d0,L1DA78
	rts
Opcode_FillBytes
	move.b	-$1(a0),d0
	andi.w	#$F,d0
	addq.w	#$2,d0
	move.b	(a0)+,d2
L1DA98	move.b	d2,(a1,d1.w)
	addq.b	#$1,d1
	bne.w	L1DAA6
	bsr.w	FlushOutputBuffer
L1DAA6	dbra	d0,L1DA98
	rts
Opcode_CopyBackwardShort
	move.b	-$1(a0),d0
	andi.w	#$7,d0
	addq.w	#$1,d0
	move.b	-$1(a0),d2
	lsr.w	#$3,d2
	andi.w	#$7,d2
	addq.w	#$1,d2
CopyBackwardRun
	neg.b	d2
	add.b	d1,d2
L1DAC6	move.b	(a1,d2.w),(a1,d1.w)
	addq.b	#$1,d2
	addq.b	#$1,d1
	bne.w	L1DAD8
	bsr.w	FlushOutputBuffer
L1DAD8	dbra	d0,L1DAC6
	rts
Opcode_CopyBackwardMedium
	move.b	-$1(a0),d0
	andi.w	#$F,d0
	addq.w	#$2,d0
	move.b	(a0)+,d2
	bra.b	CopyBackwardRun
	dc.w	$1010,$E300,$1028,$FFFF,$E310,$0240,$001F,$5440
	dc.w	$1418,$0242,$007F,$5242,$60BC,$1028,$FFFF,$E140
	dc.w	$1010,$EC48,$0240,$003F,$5440,$1418,$0242,$003F
	dc.w	$5242,$60A2,$1028,$FFFF,$E140,$1010,$EA48,$0240
	dc.w	$007F,$5440,$1418,$0242,$001F,$5242,$6088,$1028
	dc.w	$FFFF,$0240,$0003,$5240,$1428,$FFFF,$E44A,$0242
	dc.w	$0007,$5242
