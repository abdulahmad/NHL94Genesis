setVram						;initialize all necesary video parameters based on my variables. d0 =
									;color to fade to. Falls into setVram_0
	movea.l	#$BBCB0,a0
	moveq	#$3F,d1
.l1CB62	move.w	d0,(a0)+		;fill the 64 target colors with d0
	dbra	d1,.l1CB62
	move.w	#$18,(palcount).l
	bsr.w	Sub_36D66
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst	#$5,$FF800F.l
	beq.s	.l1CB8C
	move.w	#$1,-(a6)
	bra.s	.l1CB90
.l1CB8C	move.w	#$0,-(a6)
.l1CB90	bclr	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
.l1CBAE	btst	#$7,$FF800E.l
	bne.b	.l1CBAE
	move.w	#$8F02,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.l1CBD0	btst	#$6,$FF800E.l
	beq.b	.l1CBD0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l1CBEA	btst	#$6,$FF800E.l
	bne.b	.l1CBEA
	bclr	#$7,$FF800F.l
	clr.w	d0
	bsr.w	Sub_3871E
	clr.l	d1
.l1CC04	btst	#$7,$FF800E.l
	bne.b	.l1CC04
	move.w	#$20,$FF8020.l
	bset	#$6,$FF800F.l
.l1CC1E	btst	#$6,$FF800E.l
	beq.b	.l1CC1E
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l1CC38	btst	#$6,$FF800E.l
	bne.b	.l1CC38
	bclr	#$7,$FF800F.l
	move.w	#$8C00,d0
	btst	#$1,(disflags).l
	bne.w	.l1CC5E
	ori.w	#$81,d0
.l1CC5E	btst	#$7,$FF800E.l
	bne.b	.l1CC5E
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.l1CC7E	btst	#$6,$FF800E.l
	beq.b	.l1CC7E
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l1CC98	btst	#$6,$FF800E.l
	bne.b	.l1CC98
	bclr	#$7,$FF800F.l
.l1CCAA	btst	#$7,$FF800E.l
	bne.b	.l1CCAA
	move.w	#$8014,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.l1CCCC	btst	#$6,$FF800E.l
	beq.b	.l1CCCC
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l1CCE6	btst	#$6,$FF800E.l
	bne.b	.l1CCE6
	bclr	#$7,$FF800F.l
.l1CCF8	btst	#$7,$FF800E.l
	bne.b	.l1CCF8
	move.w	#$8164,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.l1CD1A	btst	#$6,$FF800E.l
	beq.b	.l1CD1A
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l1CD34	btst	#$6,$FF800E.l
	bne.b	.l1CD34
	bclr	#$7,$FF800F.l
	move.w	#$9001,d0
	cmpi.w	#$6,(Map1col).l
	beq.w	.l1CD5A
	move.w	#$9003,d0
.l1CD5A	btst	#$7,$FF800E.l
	bne.b	.l1CD5A
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.l1CD7A	btst	#$6,$FF800E.l
	beq.b	.l1CD7A
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l1CD94	btst	#$6,$FF800E.l
	bne.b	.l1CD94
	bclr	#$7,$FF800F.l
	move.w	#$8200,d0
	move.b	(VmMAP1).l,d0
	lsr.b	#$2,d0
	andi.b	#$38,d0
.l1CDB6	btst	#$7,$FF800E.l
	bne.b	.l1CDB6
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.l1CDD6	btst	#$6,$FF800E.l
	beq.b	.l1CDD6
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l1CDF0	btst	#$6,$FF800E.l
	bne.b	.l1CDF0
	bclr	#$7,$FF800F.l
	move.w	#$8400,d0
	move.b	$18D38.l,d0
	lsr.b	#$5,d0
.l1CE0E	btst	#$7,$FF800E.l
	bne.b	.l1CE0E
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.l1CE2E	btst	#$6,$FF800E.l
	beq.b	.l1CE2E
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l1CE48	btst	#$6,$FF800E.l
	bne.b	.l1CE48
	bclr	#$7,$FF800F.l
	move.w	#$8300,d0
	move.b	$18D3C.l,d0
	lsr.b	#$2,d0
	andi.b	#$3E,d0
.l1CE6A	btst	#$7,$FF800E.l
	bne.b	.l1CE6A
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.l1CE8A	btst	#$6,$FF800E.l
	beq.b	.l1CE8A
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l1CEA4	btst	#$6,$FF800E.l
	bne.b	.l1CEA4
	bclr	#$7,$FF800F.l
	move.w	#$8500,d0
	move.b	$18D32.l,d0
	lsr.b	#$1,d0
.l1CEC2	btst	#$7,$FF800E.l
	bne.b	.l1CEC2
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.l1CEE2	btst	#$6,$FF800E.l
	beq.b	.l1CEE2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l1CEFC	btst	#$6,$FF800E.l
	bne.b	.l1CEFC
	bclr	#$7,$FF800F.l
	move.w	#$8D00,d0
	move.b	$18D30.l,d0
	lsr.b	#$2,d0
.l1CF1A	btst	#$7,$FF800E.l
	bne.b	.l1CF1A
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.l1CF3A	btst	#$6,$FF800E.l
	beq.b	.l1CF3A
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l1CF54	btst	#$6,$FF800E.l
	bne.b	.l1CF54
	bclr	#$7,$FF800F.l
.l1CF66	btst	#$7,$FF800E.l
	bne.b	.l1CF66
	move.w	#$9100,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.l1CF88	btst	#$6,$FF800E.l
	beq.b	.l1CF88
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l1CFA2	btst	#$6,$FF800E.l
	bne.b	.l1CFA2
	bclr	#$7,$FF800F.l
.l1CFB4	btst	#$7,$FF800E.l
	bne.b	.l1CFB4
	move.w	#$9200,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.l1CFD6	btst	#$6,$FF800E.l
	beq.b	.l1CFD6
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l1CFF0	btst	#$6,$FF800E.l
	bne.b	.l1CFF0
	bclr	#$7,$FF800F.l
.l1D002	btst	#$7,$FF800E.l
	bne.b	.l1D002
	move.w	#$8700,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.l1D024	btst	#$6,$FF800E.l
	beq.b	.l1D024
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l1D03E	btst	#$6,$FF800E.l
	bne.b	.l1D03E
	bclr	#$7,$FF800F.l
.l1D050	btst	#$7,$FF800E.l
	bne.b	.l1D050
	move.w	#$8B00,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.l1D072	btst	#$6,$FF800E.l
	beq.b	.l1D072
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l1D08C	btst	#$6,$FF800E.l
	bne.b	.l1D08C
	bclr	#$7,$FF800F.l
.l1D09E	btst	#$7,$FF800E.l
	bne.b	.l1D09E
	move.l	#$40000010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset	#$6,$FF800F.l
.l1D0C2	btst	#$6,$FF800E.l
	beq.b	.l1D0C2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l1D0DC	btst	#$6,$FF800E.l
	bne.b	.l1D0DC
	bclr	#$7,$FF800F.l
.l1D0EE	btst	#$7,$FF800E.l
	bne.b	.l1D0EE
	move.l	#$0,$FF8022.l
	move.w	#$E,$FF8020.l
	bset	#$6,$FF800F.l
.l1D112	btst	#$6,$FF800E.l
	beq.b	.l1D112
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l1D12C	btst	#$6,$FF800E.l
	bne.b	.l1D12C
	bclr	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.s	.l1D15A
	bset	#$5,$FF800F.l
	bra.s	.l1D162
.l1D15A	bclr	#$5,$FF800F.l
.l1D162	move.l	a6,$19360.l
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
.l1D732	btst	#$7,$FF800E.l
	bne.b	.l1D732
	move.l	d0,$FF8022.l
	move.w	#$B,$FF8020.l
	bset	#$6,$FF800F.l
.l1D752	btst	#$6,$FF800E.l
	beq.b	.l1D752
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l1D76C	btst	#$6,$FF800E.l
	bne.b	.l1D76C
	bclr	#$7,$FF800F.l
	rts
Sub_38780
	movea.l	#$C00000,a0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	ori.w	#$4000,d0
	swap	d0
	andi.w	#$3,d0
.l1D794	btst	#$4,$FF800E.l
	bne.b	.l1D794
	move.w	#$30,$FF8026.l
	move.l	d0,$FF8028.l
	bset	#$3,$FF800F.l
.l1D7B4	btst	#$3,$FF800E.l
	beq.b	.l1D7B4
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.l1D7CE	btst	#$3,$FF800E.l
	bne.b	.l1D7CE
	bclr	#$4,$FF800F.l
	rts
dobitmap						;transfer palette data/map data/tiles data to vram. a0 = palette, a1 =
									;map, a2 = tiles (DecompressGraphics data), d0 = start x, d1 = start y, d2
									;= width x, d3 = width y, d4 = start char, d5 = pal used bits (0-3) for
									;color fam 1-4. printy is restored and the tiles go last through
									;DecompressGraphics (returns d4 = end char)
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst	#$5,$FF800F.l
	beq.s	.l1D7FA
	move.w	#$1,-(a6)
	bra.s	.l1D7FE
.l1D7FA	move.w	#$0,-(a6)
.l1D7FE	bclr	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	move.w	(printy).l,-(sp)
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movem.l	d0-d3/d5-d6/a0-a3,-(sp)		;2(sp) start x, $A(sp) width x, $E(sp) width y (low words of d0, d2, d3)
	move.w	d1,d6
	movea.l	#$BBCB0,a3		;a3 = target palette, a0 = palette data
	bra.w	.l1D848
.l1D832	move.b	(a0,d0.w),(a3,d0.w)		;copy the color
	dbra	d0,.l1D832
.l1D83C	adda.l	#$20,a0		;next line
	adda.l	#$20,a3		;next line
.l1D848	moveq	#$1F,d0
	lsr.w	#$1,d5		;d5 bit n = copy palette line n; stop when no bits left
	bcs.w	.l1D832
	bne.w	.l1D83C
	move.w	(printa).l,d5		;d5 = tile attribute bits (priority/palette/flip) from printa
	andi.w	#$F800,d5		;attribute bits
	move.w	$E(sp),d2
	subi.w	#$1,d2
.l1D866	bsr.w	xyVmMap		;set vram address from printx/printy/printm, a0 = Vdata
	move.w	d6,d0
	mulu.w	(a1),d0
	add.w	$2(sp),d0
	asl.w	#$1,d0		;d0 = byte offset of the first map word wanted
	move.w	$A(sp),d1
	subi.w	#$1,d1
	move.w	d1,(ThreeStars).l		;map word (map data starts 4 bytes in)
	lea.l	$BC002.l,a0
.l1D888	move.w	$4(a1,d0.w),d3
	add.w	d4,d3		;add the start char
	eor.w	d5,d3		;xor the attribute bits
	move.w	d3,(a0)+		;write the name table entry
	addi.w	#$2,d0
	dbra	d1,.l1D888
.l1D89A	btst	#$7,$FF800E.l
	bne.b	.l1D89A
	move.w	#$21,$FF8020.l
	jsr	$222C2.l
	bset	#$6,$FF800F.l
	jsr	$22268.l
.l1D8C0	btst	#$6,$FF800E.l
	beq.b	.l1D8C0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l1D8DA	btst	#$6,$FF800E.l
	bne.b	.l1D8DA
	bclr	#$7,$FF800F.l
	addi.w	#$1,(printy).l
	addi.w	#$1,d6
	dbra	d2,.l1D866
	btst	#$0,(sflags6).l
	bne.w	.l1D90E
	jsr	(DecompressGraphicsPlain).l
.l1D90E	movem.l	(sp)+,d0-d3/d5-d6/a0-a3
	move.w	(sp)+,(disflags).l
	move.w	(sp)+,(printy).l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.s	.l1D934
	bset	#$5,$FF800F.l
	bra.s	.l1D93C
.l1D934	bclr	#$5,$FF800F.l
.l1D93C	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	rts
DecompressGraphicsWithRemap						;DecompressGraphics, then return 8 bytes past the call (remap table)
	move.l	(sp),$18AE4.l
	bsr.w	L1D95E
	addi.l	#$8,(sp)
	rts
DecompressGraphicsPlain						;Clear remapTablePtr, fall into DecompressGraphics
	clr.l	$18AE4.l
L1D95E	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst	#$5,$FF800F.l
	beq.s	.l1D976
	move.w	#$1,-(a6)
	bra.s	.l1D97A
.l1D976	move.w	#$0,-(a6)
.l1D97A	bclr	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	movem.l	d0-d1/a0-a6,-(sp)
	moveq	#$0,d0
	moveq	#$0,d1
	movea.l	a2,a0
	move.w	d4,d1
	asl.w	#$5,d1
	move.w	(a0)+,d0
	beq.w	.l1D9CA
	bmi.w	.l1D9C0
	add.w	d0,d4
	asl.w	#$4,d0
	pea.l	$389CA.l
	tst.l	$18AE4.l
	beq.w	DoDMApro
	movea.l	$18AE4.l,a1
	bra.w	Sub_36C14
.l1D9C0	andi.w	#$7FFF,d0
	add.w	d0,d4
	bsr.w	DecompressBytecode
.l1D9CA	movem.l	(sp)+,d0-d1/a0-a6
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.s	.l1D9E4
	bset	#$5,$FF800F.l
	bra.s	.l1D9EC
.l1D9E4	bclr	#$5,$FF800F.l
.l1D9EC	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	rts
DecompressBytecode						;Unpack a0 into the 256 byte ring buffer at decompbuffer. d1 = vram
	
	movea.l	#ThreeStars,a1
	movea.l	#ThreeStars,a3
	movea.l	#$18AE4,a4
	movea.l	#Sub_36C14,a5
	movea.l	#DoDMApro,a6
	movem.l	d0-d3/a0-a2,-(sp)
	move.w	d1,d3
	clr.w	d1
	clr.w	d2
.loop	move.b	(a0)+,d0
	andi.w	#$F0,d0
	lsr.w	#$3,d0
	dc.w	$45FA,$000C
	move.w	(a2,d0.w),d0
	jsr	(a2,d0.w)
	bra.b	.loop
DecompressOpcodeTable						;DecompressBytecode handler offsets, one per opcode high nibble
	dc.w	$0020,$0020,$003C,$0058,$0078,$0078,$0078,$0078
	dc.w	$00AA,$00B8,$00D2,$00EC,$0106,$0106,$0138,$0158
Opcode_CopyLiteral						;opcodes 0-1, copy (low 5 bits)+1 bytes from the data
	move.b	-$1(a0),d0
	andi.w	#$1F,d0
.loop	move.b	(a0)+,(a1,d1.w)
	addq.b	#$1,d1
	bne.w	.l1DA6A
	bsr.w	FlushOutputBuffer
.l1DA6A	dbra	d0,.loop
	rts
Opcode_ClearBytes						;opcode 2, write (low 4 bits)+1 zero bytes
	move.b	-$1(a0),d0
	andi.w	#$F,d0
.loop	clr.b	(a1,d1.w)
	addq.b	#$1,d1
	bne.w	.l1DA86
	bsr.w	FlushOutputBuffer
.l1DA86	dbra	d0,.loop
	rts
Opcode_FillBytes						;opcode 3, write the next data byte (low 4 bits)+3 times
	move.b	-$1(a0),d0
	andi.w	#$F,d0
	addq.w	#$2,d0
	move.b	(a0)+,d2
.loop	move.b	d2,(a1,d1.w)
	addq.b	#$1,d1
	bne.w	.l1DAA6
	bsr.w	FlushOutputBuffer
.l1DAA6	dbra	d0,.loop
	rts
Opcode_CopyBackwardShort						;opcodes 4-7, copy from back in the output buffer
	move.b	-$1(a0),d0
	andi.w	#$7,d0
	addq.w	#$1,d0
	move.b	-$1(a0),d2
	lsr.w	#$3,d2
	andi.w	#$7,d2
	addq.w	#$1,d2
CopyBackwardRun						;shared copy loop, d0 = count-1, d2 = distance back
	neg.b	d2
	add.b	d1,d2
.loop	move.b	(a1,d2.w),(a1,d1.w)
	addq.b	#$1,d2
	addq.b	#$1,d1
	bne.w	.l1DAD8
	bsr.w	FlushOutputBuffer
.l1DAD8	dbra	d0,.loop
	rts
Opcode_CopyBackwardMedium						;opcode 8
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
