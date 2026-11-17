Sub_31EB2
	btst	#$5,$62(a3)
	bne.w	Sub_31AB6
	btst	#$3,$62(a3)
	bne.w	Sub_31AB6
	moveq	#$8,d0
	bra.w	Sub_363D6
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_16ECC.bin
assgoaliectrl
	btst	#$3,$62(a3)
	bne.w	L177CC
	bra.w	Sub_362C4
L177CC	btst	#$1,$62(a3)
	bne.w	L17870
	movem.w	d0-d1,-(sp)
	move.w	$0(a3),d0
	move.w	$14(a3),d1
	cmpi.w	#$AA,d1
	bgt.w	L1780C
	cmpi.w	#$FF56,d1
	blt.w	L1780C
	btst	#$0,$17F68.l
	bne.w	L1780C
	move.w	d0,-(sp)
	move.w	#$8,d0
	dc.w	$4EB9,$0003,$9456
	move.w	(sp)+,d0
L1780C	dc.w	$9079,$0001,$7CEE
	dc.w	$9279,$0001,$7CEA
	bclr	#$2,$64(a3)
	cmpi.w	#$74,d0
	blt.w	L17830
	bset	#$2,$64(a3)
	bra.w	L17862
L17830	cmpi.w	#$FF8C,d0
	bgt.w	L17842
	bset	#$2,$64(a3)
	bra.w	L17862
L17842	cmpi.w	#$64,d1
	blt.w	L17854
	bset	#$2,$64(a3)
	bra.w	L17862
L17854	cmpi.w	#$FF9C,d1
	bgt.w	L17862
	bset	#$2,$64(a3)
L17862	movem.w	(sp)+,d0-d1
	btst	#$2,$64(a3)
	bne.w	Sub_32930
L17870	btst	#$5,$62(a3)
	bne.w	Sub_31AB6
	bsr.w	Sub_31906
	bclr	#$1,$62(a3)
	beq.w	L17896
	clr.w	$40(a3)
	move.w	#$8,$42(a3)
	st.b	$46(a3)
L17896	btst	#$1,$63(a3)
	bne.w	L17924
	btst	#$0,$17F68.l
	bne.w	Sub_31AB6
	tst.w	$48(a3)
	bmi.w	L178F0
	move.w	$52(a3),d0
	cmp.w	$17BE0.l,d0
	beq.w	L178CA
	st.b	$48(a3)
	bra.w	L178F0
L178CA	sub.w	d7,$48(a3)
	bpl.w	L178F0
	btst	#$2,$17F70.l
	beq.w	L178EA
	bset	#$4,$17F70.l
	bra.w	L178F0
L178EA	moveq	#$8,d0
	bsr.w	AddPenalty2
L178F0	sub.b	d7,$40(a3)
	bpl.w	L17924
	move.b	$6B(a3),d0
	beq.w	L17910
	btst	#$6,$17F7A.l
	beq.w	L17910
	subi.b	#$1,d0
L17910	lsr.b	#$2,d0
	move.b	d0,$40(a3)
	move.w	$52(a3),d0
	cmp.w	$17BE0.l,d0
	beq.w	L17924
L17924	rts
Sub_32926
	btst	#$3,$62(a3)
	bne.w	assgoaliectrl
