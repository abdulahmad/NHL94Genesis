	dcb.b	$1390,0
	dc.b	'HOCKEY.BIN',$00,$00,$01,$FF	; HOCKEY.BIN....
	dcb.b	$14,0
	dc.b	$FF,$FF	; ..
	dcb.b	$72,0
	dc.b	$4E,$F9,$00,$00,$D8,$5A	; N....Z
; Dispatches the command number in d0 (below $80 by a compare chain, the rest to the high handler).
SubCommandDispatch	bra.w	RestoreBios_2
RestoreBios_1	dcb.b	$82,0
RestoreBios_2	cmpi.b	#$80,d0
	bcs.b	.l154C
	bra.w	SubCommandDispatchHigh
.l154C	tst.w	d0
	bne.b	.l1554
	bra.w	RestoreBios_7
.l1554	subi.w	#$1,d0
	bne.b	.l155E
	bra.w	.l228AE
.l155E	subi.w	#$1,d0
	bne.b	.l156A
	nop
	bra.w	RestoreBios_15
.l156A	subi.w	#$1,d0
	bne.b	.l1574
	bra.w	RestoreBios_8
.l1574	subi.w	#$1,d0
	bne.b	.l157C
	nop
.l157C	subi.w	#$1,d0
	bne.b	.l1586
	bra.w	RestoreBios_16
.l1586	subi.w	#$1,d0
	bne.b	.l1590
	bra.w	RestoreBios_17
.l1590	subi.w	#$1,d0
	bne.b	.l159A
	bra.w	RestoreBios_20
.l159A	subi.w	#$1,d0
	bne.b	.l15A4
	bra.w	RestoreBios_19
.l15A4	move.w	#$1,d0
	ori.b	#$1,ccr
	rts
.l228AE	movem.l	d0-d7/a0-a6,-(sp)
	lea.l	RestoreBios_26(pc),a0
	cmpi.w	#$0,(a0)
	beq.b	.l15BE
	bra.b	.l15F2
.l15BE	move.w	#$FFFF,(a0)
	bsr.w	.l228F8
	move.w	$FF800C.l,d0
	dc.w	$907A,$0FF0
	andi.w	#$FFF,d0
	cmpi.w	#$20,d0
	bcs.b	.l15EA
	bsr.w	.l2294A
	lea.l	RestoreBios_37(pc),a0
	move.w	$FF800C.l,d0
	move.w	d0,(a0)
.l15EA	lea.l	RestoreBios_26(pc),a0
	move.w	#$0,(a0)
.l15F2	movem.l	(sp)+,d0-d7/a0-a6
	rts
.l228F8	movem.l	d0-d1/a0-a1,-(sp)
.l15FC	lea.l	RestoreBios_1(pc),a0
	cmpi.w	#$0,(a0)
	beq.b	.l1644
	move.l	$2(a0),d0
	bsr.w	SubCommandDispatchHigh
	lea.l	RestoreBios_1(pc),a0
	move.w	(a0),d0
	move.w	#$FFFF,(a0)
	adda.l	#$2,a0
	movea.l	a0,a1
	adda.l	#$4,a1
	move.w	d0,d1
	subi.w	#$1,d1
	beq.b	.l1638
	subi.w	#$1,d1
.l1632	move.l	(a1)+,(a0)+
	dbra	d1,.l1632
.l1638	lea.l	RestoreBios_1(pc),a0
	subi.w	#$1,d0
	move.w	d0,(a0)
	bra.b	.l15FC
.l1644	movem.l	(sp)+,d0-d1/a0-a1
	rts
.l2294A	movem.l	d1-d4/a0-a2,-(sp)
	lea.l	RestoreBios_38(pc),a0
	move.w	#$0,(a0)
RestoreBios_3	dc.w	$103A,$0F1A
	dc.w	$343A,$0F64
	btst	d2,d0
	bne.w	RestoreBios_5
	lsl.w	#$2,d2
	lea.l	$FF0021.l,a0
	cmpi.b	#$0,$2(a0,d2.w)
	bne.b	.l1690
	lea.l	RestoreBios_27(pc),a0
	dc.w	$303A,$0F46
	move.b	(a0),d2
	bset	d0,d2
	move.b	d2,(a0)
	move.b	d2,$FF0011.l
	bsr.w	DelayShort
	bra.w	RestoreBios_5
.l1690	dc.w	$343A,$0F2E
	lea.l	RestoreBios_33(pc),a0
	cmpi.b	#$FF,(a0,d2.w)
	beq.w	RestoreBios_5
	clr.w	d1
	move.b	(a0,d2.w),d1
	move.w	#$4,d0
	bsr.w	TableLookupWord
	bcs.w	RestoreBios_5
	lea.l	RestoreBios_35(pc),a1
	dc.w	$303A,$0F06
	lsl.w	#$1,d0
	move.w	$FF800C.l,d1
	dc.w	$927A,$0EF8
	andi.w	#$FFF,d1
	lsr.w	#$5,d1
	add.w	(a1,d0.w),d1
	move.w	d1,(a1,d0.w)
	lea.l	RestoreBios_34(pc),a2
	dc.w	$323A,$0EE4
	clr.w	d2
	move.b	(a2,d1.w),d2
	addi.w	#$1,d2
	lsl.w	#$1,d2
	addi.w	#$3,d2
	clr.w	d3
	move.b	(a0,d2.w),d3
	cmp.w	(a1,d0.w),d3
	bcc.b	.l174C
	move.w	(a1,d0.w),d2
	sub.w	d3,d2
	move.w	d2,(a1,d0.w)
	addi.b	#$1,(a2,d1.w)
	move.b	(a2,d1.w),d2
	cmp.b	$2(a0),d2
	bne.b	.l1728
	lea.l	RestoreBios_36(pc),a1
	dc.w	$363A,$0EA6
	btst	d3,(a1)
	beq.b	.l1728
	move.b	$1(a0),(a2,d1.w)
	bra.b	.l174C
.l1728	addi.b	#$1,d2
	cmp.b	(a0),d2
	bcs.b	.l174C
	lea.l	RestoreBios_27(pc),a0
	dc.w	$303A,$0E8A
	move.b	(a0),d1
	bset	d0,d1
	move.b	d1,$FF0011.l
	move.b	d1,(a0)
	bsr.w	DelayShort
	bra.w	RestoreBios_5
.l174C	lea.l	RestoreBios_34(pc),a1
	dc.w	$303A,$0E6E
	clr.w	d1
	move.b	(a1,d0.w),d1
	lsl.w	#$1,d1
	addi.w	#$3,d1
	move.b	$1(a0,d1.w),d0
	cmp.b	$3(a0,d1.w),d0
	bcs.b	.l1776
	clr.w	d2
	move.b	$1(a0,d1.w),d2
	sub.b	$3(a0,d1.w),d2
	bra.b	RestoreBios_4
.l1776	clr.w	d2
	move.b	$3(a0,d1.w),d2
RestoreBiosSub2	sub.b	$1(a0,d1.w),d2
RestoreBios_4	cmpi.b	#$0,d2
	bne.b	.l178C
	move.b	$1(a0,d1.w),d2
	bra.b	.l17C8
.l178C	lea.l	RestoreBios_35(pc),a1
	dc.w	$303A,$0E2E
	lsl.w	#$1,d0
	move.w	(a1,d0.w),d3
	lsl.w	#$8,d3
	clr.w	d4
	move.b	$2(a0,d1.w),d4
	divu.w	d4,d3
	move.b	$1(a0,d1.w),d0
	cmp.b	$3(a0,d1.w),d0
	bcs.b	.l17BC
	mulu.w	d2,d3
	lsr.w	#$8,d3
	clr.w	d2
	move.b	$1(a0,d1.w),d2
	sub.w	d3,d2
	bra.b	.l17C8
.l17BC	mulu.w	d2,d3
	lsr.w	#$8,d3
	clr.w	d2
	move.b	$1(a0,d1.w),d2
	add.w	d3,d2
.l17C8	lea.l	RestoreBios_31(pc),a1
	dc.w	$303A,$0DF2
	clr.w	d3
	move.b	(a1,d0.w),d3
	lsl.w	#$1,d3
	mulu.w	d3,d2
	lsr.w	#$8,d2
	ori.b	#$C0,d0
	move.b	d0,$FF000F.l
	bsr.w	DelayShort
	move.b	d2,$FF0001.l
	bsr.w	DelayShort
RestoreBios_5	lea.l	RestoreBios_38(pc),a0
	addi.w	#$1,(a0)
	cmpi.w	#$8,(a0)
	beq.b	.l1806
	bra.w	RestoreBios_3
.l1806	movem.l	(sp)+,d1-d4/a0-a2
	rts
; Second level for commands $80 and up, by range.
SubCommandDispatchHigh	cmpi.b	#$8F,d0
	bgt.b	.l1816
	bra.w	.l22CAE
.l1816	cmpi.b	#$9F,d0
	bgt.b	.l1820
	bra.w	.l22B56
.l1820	cmpi.b	#$AF,d0
	bgt.b	.l1828
	bra.b	.l184C
.l1828	cmpi.b	#$BF,d0
	bgt.b	.l1830
	nop
.l1830	cmpi.b	#$CF,d0
	bgt.b	.l183A
	bra.w	.l22DB0
.l183A	cmpi.b	#$DF,d0
	bgt.b	.l1842
	bra.b	.l184C
.l1842	cmpi.b	#$EF,d0
	bgt.b	.l184C
	bra.w	.l22DD4
.l184C	move.w	#$1,d0
	ori.b	#$1,ccr
	rts
.l22B56	movem.l	d1-d2/a0-a1,-(sp)
	lea.l	RestoreBios_22(pc),a0
	move.b	d0,d1
	andi.w	#$F,d1
	move.l	d0,d2
	swap	d2
	lsr.w	#$8,d2
	or.b	d2,d1
	move.w	d1,$260(a0)
	move.w	d0,d1
	lsr.w	#$8,d1
	move.w	d1,$262(a0)
	move.l	d0,d1
	swap	d1
	andi.w	#$FF,d1
	move.w	d1,$264(a0)
	dc.w	$343A,$0D3C
	lea.l	RestoreBios_44(pc),a0
	clr.w	d1
	move.b	(a0,d2.w),d1
.l1892	lea.l	RestoreBios_41(pc),a0
	move.w	d1,(a0)
	move.w	#$0,d0
	bsr.w	TableLookupWord
	bcs.w	.l19A8
	lea.l	RestoreBios_43(pc),a1
	move.l	a0,(a1)
	cmpi.b	#$7,(a0)
	bne.b	.l18C0
	dc.w	$303A,$0D12
	addi.w	#$1,d0
	clr.w	d1
	move.b	(a0,d0.w),d1
	bra.b	.l1892
.l18C0	bsr.w	FindKeyIndex
	bcc.b	.l18CA
	bra.w	.l19A8
.l18CA	dc.w	$303A,$0CF4
	lea.l	RestoreBios_28(pc),a0
	dc.w	$11BA,$0CEF,$0000
	lea.l	RestoreBios_29(pc),a0
	dc.w	$11BA,$0CEB,$0000
	lea.l	RestoreBios_30(pc),a0
	dc.w	$11BA,$0CDD,$0000
	lea.l	RestoreBios_31(pc),a0
	dc.w	$11BA,$0CD5,$0000
	lea.l	RestoreBios_32(pc),a0
	dc.w	$227A,$0CD0
	move.b	$1(a1),(a0,d0.w)
	dc.w	$303A,$0CC4
	btst	#$0,d0
	beq.b	.l1914
	btst	#$1,d0
	beq.b	.l198C
.l1914	dc.w	$103A,$0C5C
	dc.w	$323A,$0CA6
	bset	d1,d0
	move.b	d0,$FF0011.l
	bsr.w	DelayShort
	ori.b	#$C0,d1
	move.b	d1,$FF000F.l
	bsr.w	DelayShort
	dc.w	$207A,$0C94
	clr.w	d0
	move.b	$2(a0),d0
	lsl.w	#$1,d0
	lea.l	RestoreBios_23(pc),a1
	move.w	(a1,d0.w),d1
	lsr.w	#$8,d1
	move.b	d1,$FF000D.l
	bsr.w	DelayShort
	move.b	$5(a0),d1
	lsl.w	#$8,d1
	move.b	$6(a0),d1
	cmpi.w	#$FFFF,d1
	bne.b	.l196A
	clr.w	d1
	bra.b	.l196E
.l196A	add.w	(a1,d0.w),d1
.l196E	move.b	d1,$FF0009.l
	bsr.w	DelayShort
	lsr.w	#$8,d1
	move.b	d1,$FF000B.l
	bsr.w	DelayShort
	bsr.w	.l22E28
	bsr.w	ScaleValueByTables
.l198C	bsr.w	CalcLevelDelta
	lea.l	RestoreBios_27(pc),a0
	dc.w	$303A,$0C2A
	move.b	(a0),d1
	bclr	d0,d1
	move.b	d1,$FF0011.l
	bsr.w	DelayShort
	move.b	d1,(a0)
.l19A8	movem.l	(sp)+,d1-d2/a0-a1
	rts
.l22CAE	movem.l	d1-d3/a0-a2,-(sp)
	clr.w	d1
	move.b	d0,d1
	andi.b	#$F,d1
	move.l	d0,d2
	swap	d2
	lsr.w	#$8,d2
	or.b	d2,d1
	lea.l	RestoreBios_39(pc),a0
	move.w	d1,(a0)
	move.w	d0,d1
	lsr.w	#$8,d1
	lea.l	RestoreBios_40(pc),a0
	move.w	d1,(a0)
	lea.l	RestoreBios_44(pc),a0
	dc.w	$303A,$0BEA
	clr.w	d1
	move.b	(a0,d0.w),d1
.l19E0	move.w	#$0,d0
	bsr.w	TableLookupWord
	bcs.w	.l1AAA
	cmpi.b	#$7,(a0)
	bne.b	.l1A02
	dc.w	$303A,$0BD0
	addi.w	#$1,d0
	clr.w	d1
	move.b	(a0,d0.w),d1
	bra.b	.l19E0
.l1A02	move.b	$5(a0),d0
	lsl.w	#$8,d0
	move.b	$6(a0),d0
	cmpi.w	#$FFFF,d0
	beq.w	.l1AAA
	dc.w	$103A,$0B5C
	clr.w	d1
	lea.l	RestoreBios_28(pc),a1
	lea.l	RestoreBios_30(pc),a2
	dc.w	$343A,$0B9E
	dc.w	$363A,$0B9C
.l1A2A	btst	d1,d0
	bne.b	.l1A8C
	cmp.b	(a1),d2
	bne.b	.l1A8C
	cmp.b	(a2),d3
	bne.b	.l1A8C
	cmpi.b	#$FF,$D(a0)
	beq.b	.l1A76
	lea.l	RestoreBios_36(pc),a1
	bclr.b	d1,(a1)
	lea.l	RestoreBios_38(pc),a1
	move.w	d1,(a1)
	clr.w	d1
	move.b	$D(a0),d1
	move.w	#$4,d0
	bsr.w	TableLookupWord
	bcs.b	.l1AAA
	lea.l	RestoreBios_34(pc),a1
	dc.w	$303A,$0B60
	move.b	$2(a0),(a1,d0.w)
	lsl.w	#$1,d0
	lea.l	RestoreBios_35(pc),a1
	move.w	#$0,(a1,d0.w)
	bra.b	.l1AAA
.l1A76	lea.l	RestoreBios_27(pc),a0
	bset	d1,d0
	move.b	d0,(a0)
	move.b	d0,$FF0011.l
	bsr.w	DelayShort
	clr.w	d0
	bra.b	.l1AAA
.l1A8C	adda.l	#$1,a1
	adda.l	#$1,a2
	addi.w	#$1,d1
	cmpi.w	#$8,d1
	bne.b	.l1A2A
	move.w	#$FFFF,d0
	ori.b	#$1,ccr
.l1AAA	movem.l	(sp)+,d1-d3/a0-a2
	rts
.l22DB0	movem.l	d1-d2/a0,-(sp)
	move.l	d0,d1
	swap	d1
	lsr.w	#$8,d1
	move.w	d0,d2
	andi.w	#$F,d2
	or.b	d1,d2
	lsr.w	#$8,d0
	lea.l	RestoreBios_44(pc),a0
	move.b	d0,(a0,d2.w)
	clr.w	d0
	movem.l	(sp)+,d1-d2/a0
	rts
.l22DD4	movem.l	d1-d2/a0,-(sp)
	move.l	d0,d1
	swap	d1
	lsr.w	#$8,d1
	move.w	d0,d2
	andi.w	#$F,d2
	or.b	d1,d2
	lsr.w	#$8,d0
	lea.l	RestoreBios_48(pc),a0
	move.b	d0,(a0,d2.w)
	lea.l	RestoreBios_38(pc),a0
	move.w	#$0,(a0)
.l1AF8	dc.w	$303A,$0AC6
	dc.w	$123A,$0A74
	btst	d0,d1
	beq.b	.l1B12
	lea.l	RestoreBios_28(pc),a0
	cmp.b	(a0,d0.w),d2
	bne.b	.l1B12
	bsr.w	CalcLevelDelta
.l1B12	lea.l	RestoreBios_38(pc),a0
	addi.w	#$1,(a0)
	cmpi.w	#$8,(a0)
	bne.b	.l1AF8
	clr.w	d0
	movem.l	(sp)+,d1-d2/a0
	rts
.l22E28	movem.l	d1-d2/a0,-(sp)
	dc.w	$207A,$0A9E
	clr.w	d1
	move.b	$D(a0),d1
	lea.l	RestoreBios_33(pc),a0
	dc.w	$303A,$0A84
	move.b	d1,(a0,d0.w)
	cmpi.b	#$FF,d1
	beq.b	.l1B52
	move.w	#$4,d0
	bsr.w	TableLookupWord
	bcc.b	.l1B80
.l1B52	dc.w	$303A,$0A6C
	ori.b	#$C0,d0
	move.b	d0,$FF000F.l
	bsr.w	DelayShort
	lea.l	RestoreBios_31(pc),a0
	dc.w	$303A,$0A56
	move.b	(a0,d0.w),d1
	lsl.w	#$1,d1
	move.b	d1,$FF0001.l
	bsr.w	DelayShort
	clr.w	d0
	bra.b	.l1BD8
.l1B80	clr.w	d0
	move.b	$4(a0),d0
	lea.l	RestoreBios_31(pc),a0
	dc.w	$323A,$0A34
	clr.w	d2
	move.b	(a0,d1.w),d2
	lsl.w	#$1,d2
	mulu.w	d2,d0
	lsr.w	#$8,d0
	dc.w	$323A,$0A24
	ori.b	#$C0,d1
	move.b	d1,$FF000F.l
	bsr.w	DelayShort
	move.b	d0,$FF0001.l
	bsr.w	DelayShort
	lea.l	RestoreBios_34(pc),a0
	dc.w	$303A,$0A04
	move.b	#$0,(a0,d0.w)
	lea.l	RestoreBios_36(pc),a0
	bset.b	d0,(a0)
	lsl.w	#$1,d0
	lea.l	RestoreBios_35(pc),a0
	move.w	#$0,(a0,d0.w)
	clr.w	d0
.l1BD8	movem.l	(sp)+,d1-d2/a0
	rts
RestoreBios_7	movem.l	d0/a0-a1,-(sp)
	lea.l	RestoreBios_22(pc),a0
	move.w	#$100,$0(a0)
	move.w	#$100,$2(a0)
	lea.l	RestoreBios_25(pc),a1
	move.w	#$1,d0
.l1BFA	move.l	#$FFFFFFFF,(a1)+
	dbra	d0,.l1BFA
	move.b	#$FF,$210(a0)
	lea.l	RestoreBios_44(pc),a0
	move.w	#$7F,d0
.l1C12	move.b	#$0,(a0)+
	dbra	d0,.l1C12
	lea.l	RestoreBios_45(pc),a0
	move.w	#$7F,d0
.l1C22	move.b	#$0,(a0)+
	dbra	d0,.l1C22
	lea.l	RestoreBios_46(pc),a0
	move.w	#$7F,d0
.l1C32	move.b	#$7F,(a0)+
	dbra	d0,.l1C32
	lea.l	RestoreBios_47(pc),a0
	move.w	#$7F,d0
.l1C42	move.b	#$40,(a0)+
	dbra	d0,.l1C42
	lea.l	RestoreBios_48(pc),a0
	move.w	#$7F,d0
.l1C52	move.b	#$40,(a0)+
	dbra	d0,.l1C52
	lea.l	RestoreBios_49(pc),a0
	move.w	#$7,d0
.l1C62	move.b	#$FF,(a0)+
	dbra	d0,.l1C62
	lea.l	RestoreBios_50(pc),a0
	move.b	#$FF,(a0)
	lea.l	RestoreBios_1(pc),a0
	move.w	#$0,(a0)
	move.b	#$80,$FF000F.l
	bsr.w	DelayShort
	lea.l	$FF2001.l,a0
	move.w	#$EB,d0
.l1C90	move.b	#$80,(a0)
	adda.l	#$2,a0
	nop
	nop
	nop
	nop
	dbra	d0,.l1C90
	move.w	#$F,d0
.l1CAA	move.b	#$FF,(a0)
	adda.l	#$2,a0
	nop
	nop
	nop
	nop
	dbra	d0,.l1CAA
	lea.l	RestoreBios_26(pc),a0
	move.w	#$0,(a0)
	movem.l	(sp)+,d0/a0-a1
	rts
RestoreBios_8	movem.l	d1-d7/a0,-(sp)
	dc.w	$103A,$089E
	move.w	#$7,d5
.l1CDA	btst	d5,d0
	bne.b	.l1D1A
	dbra	d5,.l1CDA
	lea.l	RestoreBios_32(pc),a0
	move.w	#$FFFF,d5
	move.b	#$FF,d6
	clr.w	d0
.l1CF0	cmp.b	(a0),d6
	bcs.b	.l1CF8
	move.w	d0,d5
	move.b	(a0),d6
.l1CF8	adda.l	#$1,a0
	addi.w	#$1,d0
	cmpi.w	#$8,d0
	bne.b	.l1CF0
	cmpi.w	#$FFFF,d5
	bne.b	.l1D1A
	move.w	#$7,d0
	ori.b	#$1,ccr
	bra.w	.l1E00
.l1D1A	lea.l	RestoreBios_38(pc),a0
	move.w	d5,(a0)
	lea.l	RestoreBios_27(pc),a0
	move.b	(a0),d0
	bset	d5,d0
	move.b	d0,$FF0011.l
	bsr.w	DelayShort
	lea.l	RestoreBios_23(pc),a0
	lsl.w	#$1,d1
	cmpi.w	#$FFFF,(a0,d1.w)
	bne.b	.l1D4C
	move.b	#$3,d0
	ori.b	#$1,ccr
	bra.w	.l1E00
.l1D4C	dc.w	$303A,$0872
	ori.b	#$C0,d0
	move.b	d0,$FF000F.l
	move.w	(a0,d1.w),d0
	lsr.w	#$8,d0
	move.b	d0,$FF000D.l
	bsr.w	DelayShort
	move.b	#$0,$FF0009.l
	bsr.w	DelayShort
	move.b	#$0,$FF000B.l
	bsr.w	DelayShort
	move.b	d2,$FF0005.l
	bsr.w	DelayShort
	lsr.w	#$8,d2
	move.b	d2,$FF0007.l
	bsr.w	DelayShort
	move.b	d3,$FF0001.l
	bsr.w	DelayShort
	move.b	d4,$FF0003.l
	bsr.w	DelayShort
	lea.l	RestoreBios_27(pc),a0
	dc.w	$303A,$080E
	move.b	(a0),d1
	bclr	d0,d1
	move.b	d1,(a0)
	move.b	d1,$FF0011.l
	bsr.w	DelayShort
	lea.l	RestoreBios_28(pc),a0
	move.b	#$FF,(a0,d0.w)
	lea.l	RestoreBios_29(pc),a0
	move.b	#$FF,(a0,d0.w)
	lea.l	RestoreBios_30(pc),a0
	move.b	#$FF,(a0,d0.w)
	lea.l	RestoreBios_31(pc),a0
	move.b	#$FF,(a0,d0.w)
	lea.l	RestoreBios_32(pc),a0
	move.b	#$0,(a0,d0.w)
	lea.l	RestoreBios_33(pc),a0
	move.b	#$FF,(a0,d0.w)
.l1E00	movem.l	(sp)+,d1-d7/a0
	rts
; Sums signed differences between table values and the record at a0.
CalcLevelDelta	movem.l	d1-d6/a0-a1,-(sp)
	dc.w	$207A,$07C0
	clr.w	d0
	clr.w	d1
	dc.w	$343A,$07AC
	lea.l	RestoreBios_30(pc),a1
	move.b	(a1,d2.w),d3
	cmp.b	$3(a0),d3
	blt.b	.l1E2C
	sub.b	$3(a0),d3
	add.b	d3,d0
	bra.b	.l1E36
.l1E2C	move.b	$3(a0),d3
	sub.b	(a1,d2.w),d3
	sub.b	d3,d0
.l1E36	dc.w	$343A,$078A
	lea.l	RestoreBios_48(pc),a1
	clr.w	d3
	move.b	(a1,d2.w),d3
	cmpi.b	#$40,d3
	beq.b	.l1E86
	blt.b	.l1E68
	subi.b	#$40,d3
	lsl.w	#$2,d3
	clr.w	d4
	move.b	$7(a0),d4
	mulu.w	d4,d3
	add.b	d3,d1
	bcc.b	.l1E62
	addi.b	#$1,d0
.l1E62	lsr.w	#$8,d3
	add.b	d3,d0
	bra.b	.l1E86
.l1E68	move.b	#$40,d3
	sub.b	(a1,d2.w),d3
	lsl.w	#$2,d3
	clr.w	d4
	move.b	$8(a0),d4
	mulu.w	d4,d3
	sub.b	d3,d1
	bcc.b	.l1E82
	subi.b	#$1,d0
.l1E82	lsr.w	#$8,d3
	sub.b	d3,d0
.l1E86	clr.w	d2
	move.b	$4(a0),d2
	cmpi.b	#$0,d2
	beq.b	.l1EB6
	btst	#$7,d2
	bne.b	.l1EA4
	lsl.b	#$1,d2
	add.b	d2,d1
	bcc.b	.l1EB6
	addi.b	#$1,d0
	bra.b	.l1EB6
.l1EA4	eori.b	#$FF,d2
	addi.b	#$1,d2
	lsl.b	#$1,d2
	sub.b	d2,d1
	bcc.b	.l1EB6
	subi.b	#$1,d0
.l1EB6	ext.w	d0
	lsl.w	#$1,d0
	lea.l	.l2325E(pc),a1
	move.w	(a1,d0.w),d2
	move.w	$2(a1,d0.w),d3
	sub.w	d2,d3
	mulu.w	d1,d3
	lsr.w	#$8,d3
	add.w	d3,d2
	dc.w	$303A,$06F0
	ori.b	#$C0,d0
	move.b	d0,$FF000F.l
	bsr.w	DelayShort
	move.b	d2,$FF0005.l
	bsr.w	DelayShort
	lsr.w	#$8,d2
	move.b	d2,$FF0007.l
	bsr.w	DelayShort
	clr.w	d0
	movem.l	(sp)+,d1-d6/a0-a1
	rts
	dc.b	$00,$80,$00,$88,$00,$90,$00,$98,$00,$A2,$00,$AB,$00,$B5,$00,$C0	; ................
	dc.b	$00,$CB,$00,$D7,$00,$E4,$00,$F2,$01,$00,$01,$0F,$01,$1F,$01,$30	; ...............0
	dc.b	$01,$43,$01,$56,$01,$6A,$01,$80,$01,$96,$01,$AF,$01,$C8,$01,$E3	; .C.V.j..........
	dc.b	$02,$00,$02,$1E,$02,$3F,$02,$61,$02,$85,$02,$AB,$02,$D4,$02,$FF	; .....?.a........
	dc.b	$03,$2D,$03,$5D,$03,$90,$03,$C7,$04,$00,$04,$3D,$04,$7D,$04,$C2	; .-.].......=.}..
	dc.b	$05,$0A,$05,$57,$05,$A8,$05,$FE,$06,$59,$06,$BA,$07,$21,$07,$8D	; ...W.....Y...!..
.l2325E	dc.b	$08,$00,$08,$7A,$08,$FB,$09,$83,$0A,$14,$0A,$AE,$0B,$50,$0B,$FD	; ...z.........P..
	dc.b	$0C,$B3,$0D,$74,$0E,$41,$0F,$1A,$10,$00,$10,$F4,$11,$F6,$13,$07	; ...t.A..........
	dc.b	$14,$29,$15,$56,$16,$A1,$17,$F9,$19,$66,$1A,$E9,$1C,$82,$1E,$34	; .).V.....f.....4
	dc.b	$20,$00,$21,$E7,$23,$EB,$26,$0E,$28,$51,$2A,$B7,$2D,$41,$2F,$F2	;  .!.#.&.(Q*.-A/.
	dc.b	$32,$CC,$35,$D1,$39,$04,$3C,$68,$40,$00,$43,$CE,$47,$D6,$4C,$1C	; 2.5.9.<h@.C.G.L.
	dc.b	$50,$A3,$55,$6E,$5A,$82,$5F,$E4,$65,$98,$6B,$A3,$72,$09,$78,$D1	; P.UnZ._.e.k.r.x.
	dc.b	$80,$00	; ..
; Scales a value through three byte tables and a lookup.
ScaleValueByTables	movem.l	d1-d3/a0,-(sp)
	dc.w	$303A,$05FA
	lea.l	RestoreBios_28(pc),a0
	clr.w	d3
	move.b	(a0,d0.w),d3
	lea.l	RestoreBios_46(pc),a0
	clr.w	d2
	move.b	(a0,d3.w),d2
	lsl.w	#$1,d2
	lea.l	RestoreBios_44(pc),a0
	clr.w	d1
	move.b	(a0,d3.w),d1
	move.w	#$0,d0
	bsr.w	TableLookupWord
	bcs.w	.l207A
	clr.w	d1
	move.b	$B(a0),d1
	mulu.w	d1,d2
	lsr.w	#$8,d2
	move.w	d3,d0
	lsr.w	#$4,d0
	lea.l	RestoreBios_49(pc),a0
	clr.w	d1
	move.b	(a0,d0.w),d1
	mulu.w	d1,d2
	lsr.w	#$8,d2
	clr.w	d1
	dc.w	$123A,$0844
	mulu.w	d1,d2
	lsr.w	#$8,d2
	lea.l	RestoreBios_47(pc),a0
	clr.w	d1
	move.b	(a0,d3.w),d1
	cmpi.b	#$40,d1
	bne.b	.l2034
	lsr.b	#$4,d2
	move.b	d2,d0
	lsl.b	#$4,d0
	or.b	d2,d0
	bra.b	.l205C
.l2034	bgt.b	.l2048
	move.b	d2,d0
	lsr.b	#$4,d0
	lsl.w	#$2,d1
	mulu.w	d1,d2
	lsr.w	#$8,d2
	andi.b	#$F0,d2
	or.b	d2,d0
	bra.b	.l205C
.l2048	move.b	d2,d0
	andi.b	#$F0,d0
	subi.w	#$40,d1
	lsl.w	#$2,d1
	mulu.w	d1,d2
	lsr.w	#$8,d2
	lsr.b	#$4,d2
	or.b	d2,d0
.l205C	dc.w	$323A,$0562
	ori.b	#$C0,d1
	move.b	d1,$FF000F.l
	bsr.w	DelayShort
	move.b	d0,$FF0003.l
	bsr.w	DelayShort
	clr.w	d0
.l207A	movem.l	(sp)+,d1-d3/a0
	rts
; Finds the index of the key byte d0 in the 8-entry table and stores it.
FindKeyIndex	movem.l	d1-d2/a0,-(sp)
	lea.l	RestoreBios_42(pc),a0
	move.w	#$0,(a0)
	dc.w	$207A,$053E
RestoreBiosSub3	btst.b	#$0,$C(a0)
	beq.b	.l20D2
	lea.l	RestoreBios_29(pc),a0
	dc.w	$303A,$052A
	dc.w	$123A,$04D0
	clr.w	d2
.l20A6	btst	d2,d1
	bne.b	.l20C8
	cmp.b	(a0)+,d0
	bne.b	.l20C8
	lea.l	RestoreBios_38(pc),a0
	move.w	d2,(a0)
	lea.l	RestoreBios_43(pc),a0
	clr.w	d0
	move.b	$C(a0),d0
	lea.l	RestoreBios_42(pc),a0
	move.w	d0,(a0)
	clr.w	d0
	bra.b	RestoreBios_13
.l20C8	addi.w	#$1,d2
	cmpi.w	#$8,d2
	bne.b	.l20A6
.l20D2	dc.w	$103A,$049E
	clr.w	d1
.l20D8	btst	d1,d0
	beq.b	.l20E6
	lea.l	RestoreBios_38(pc),a0
	move.w	d1,(a0)
	clr.w	d0
	bra.b	RestoreBios_13
.l20E6	addi.w	#$1,d1
	cmpi.w	#$8,d1
	bne.b	.l20D8
	dc.w	$207A,$04DA
	move.b	$1(a0),d0
	lea.l	RestoreBios_32(pc),a0
RestoreBiosSub4	clr.w	d1
RestoreBios_12	cmp.b	(a0)+,d0
RestoreBiosSub5	bhi.b	.l210C
	lea.l	RestoreBios_38(pc),a0
	move.w	d1,(a0)
	clr.w	d0
	bra.b	RestoreBios_13
.l210C	addi.w	#$1,d1
	cmpi.w	#$8,d1
	bne.b	RestoreBios_12
	ori.b	#$1,ccr
RestoreBios_13	movem.l	(sp)+,d1-d2/a0
	rts
; Looks up the pair (d0,d1) in the table list and returns the word, carry set if absent.
TableLookupWord	movem.l	d1-d4/a1-a2,-(sp)
	lea.l	RestoreBios_25(pc),a1
	move.w	#$2,d2
.l212C	cmpi.l	#$FFFFFFFF,(a1)
	beq.b	.l217A
	movea.l	(a1),a2
	move.b	(a2)+,d3
	lsl.w	#$8,d3
	move.b	(a2)+,d3
	clr.l	d4
	move.w	d3,d4
	lsl.l	#$2,d4
	add.l	a2,d4
	movea.l	d4,a0
.l2146	cmp.b	(a2),d0
	bne.b	.l2160
	cmp.b	$1(a2),d1
	bne.b	.l2160
	move.b	$2(a2),d0
	lsl.w	#$8,d0
	move.b	$3(a2),d0
	andi.b	#$FE,ccr
	bra.b	.l218E
.l2160	clr.l	d4
	move.b	$2(a2),d4
	lsl.w	#$8,d4
	move.b	$3(a2),d4
	adda.l	d4,a0
	adda.l	#$4,a2
	subi.w	#$1,d3
	bne.b	.l2146
.l217A	adda.l	#$4,a1
	subi.w	#$1,d2
	bne.b	.l212C
	move.w	#$3,d0
	ori.b	#$1,ccr
.l218E	movem.l	(sp)+,d1-d4/a1-a2
	rts
RestoreBios_15	move.l	a0,-(sp)
	or.w	d1,d1
	bne.b	.l21A8
	lea.l	RestoreBios_22(pc),a0
	move.w	#$100,$2(a0)
	clr.w	d0
	bra.b	.l21FE
.l21A8	cmpi.w	#$1,d1
	bne.b	.l21BC
	lea.l	RestoreBios_22(pc),a0
	move.w	$0(a0),$2(a0)
	clr.w	d0
	bra.b	.l21FE
.l21BC	cmpi.w	#$2,d1
	bne.b	.l21F6
	lea.l	RestoreBios_22(pc),a0
	move.w	$2(a0),$0(a0)
	move.w	$2(a0),d0
	lea.l	RestoreBios_23(pc),a0
	move.w	#$FF,d1
.l21D8	cmpi.w	#$FFFF,(a0)
	beq.b	.l21E8
	cmp.w	(a0),d0
	bhi.w	.l21E8
	move.w	#$FFFF,(a0)
.l21E8	adda.l	#$2,a0
	dbra	d1,.l21D8
	clr.w	d0
	bra.b	.l21FE
.l21F6	move.w	#$5,d0
	ori.b	#$1,ccr
.l21FE	clr.w	d0
	movea.l	(sp)+,a0
	rts
RestoreBios_16	movem.l	d1/a1,-(sp)
	lsl.w	#$2,d1
	lea.l	RestoreBios_25(pc),a1
	move.l	a0,(a1,d1.w)
	movem.l	(sp)+,d1/a1
	rts
RestoreBios_17	movem.l	d1/a0-a1,-(sp)
	movea.l	a0,a1
.l221E	cmpi.w	#$FFFF,(a1)
	bne.b	.l2228
	clr.w	d0
	bra.b	.l2274
.l2228	move.w	(a1),d0
	move.w	$2(a1),d1
	bsr.w	TableLookupWord
	bcs.b	.l2270
	cmpi.w	#$2,(a1)
	bne.b	.l2268
	bsr.w	.l2357A
	bcs.b	.l2274
	lea.l	RestoreBios_23(pc),a0
	move.w	$2(a1),d0
	lsl.w	#$1,d0
	dc.w	$323A,$0116
	move.w	d1,(a0,d0.w)
	dc.w	$D27A,$0312
	or.b	d1,d1
	beq.b	.l2262
	andi.w	#$FF00,d1
	addi.w	#$100,d1
.l2262	lea.l	RestoreBios_22(pc),a0
	move.w	d1,(a0)
.l2268	adda.l	#$4,a1
	bra.b	.l221E
.l2270	ori.b	#$1,ccr
.l2274	movem.l	(sp)+,d1/a0-a1
	rts
.l2357A	movem.l	d1-d2/a0-a1,-(sp)
	lea.l	RestoreBios_24(pc),a1
	move.w	d0,(a1)
	dc.w	$323A,$00DC
	beq.b	RestoreBios_18
	clr.w	d1
	dc.w	$927A,$00D4
RestoreBiosSub6	cmp.w	d0,d1
	bhi.b	RestoreBios_18
	move.w	#$4,d0
	ori.b	#$1,ccr
	dc.w	$6056
RestoreBios_18	dc.w	$343A,$00C2
	lsr.w	#$8,d2
	lsr.w	#$4,d2
	ori.b	#$80,d2
	move.b	d2,$FF000F.l
	bsr.w	DelayShort
	dc.w	$323A,$00AC
	andi.l	#$FFF,d1
	lsl.l	#$1,d1
	addi.l	#$FF2001,d1
	movea.l	d1,a1
.l22C8	move.b	(a0)+,d1
	move.b	d1,(a1)
	adda.l	#$2,a1
	cmpa.l	#$FF4001,a1
	bne.b	.l22EE
	addi.b	#$1,d2
	move.b	d2,$FF000F.l
	bsr.w	DelayShort
	movea.l	#$FF2001,a1
.l22EE	dbra	d0,.l22C8
	clr.w	d0
.l22F4	movem.l	(sp)+,d1-d2/a0-a1
	rts
RestoreBios_19	movem.l	d1-d3/a0,-(sp)
RestoreBiosSub7	movem.l	d2-d3,-(sp)
	move.w	#$0,d0
	bsr.w	TableLookupWord
	movem.l	(sp)+,d2-d3
	bcs.b	.l233C
	cmpi.w	#$0,d3
	bne.b	.l2324
	move.b	d2,$6(a0)
	lsr.w	#$8,d2
	move.b	d2,$5(a0)
	clr.w	d0
	bra.b	.l233C
.l2324	move.b	$5(a0),d0
	lsl.w	#$8,d0
	move.b	$6(a0),d0
	add.w	d2,d0
	move.b	d0,$6(a0)
	lsr.w	#$8,d0
	move.b	d0,$5(a0)
	clr.w	d0
.l233C	movem.l	(sp)+,d1-d3/a0
	rts
.l2342	move.w	#$80,d0
	jsr	$5F22.l
	bcs.b	.l2342
	rts
RestoreBios_20	rts
; Busy-wait of about 40 loop passes (hardware settling delay).
DelayShort	move.l	d0,-(sp)
	move.w	#$28,d0
.l2358	nop
	dbra	d0,.l2358
	move.l	(sp)+,d0
	rts
RestoreBios_22	dc.b	$00,$00,$00,$00	; ....
RestoreBios_23	dcb.b	$200,0
RestoreBios_24	dc.b	$00,$00	; ..
RestoreBios_25	dcb.b	$8,0
RestoreBios_26	dc.b	$00,$00	; ..
RestoreBios_27	dc.b	$00,$00	; ..
RestoreBios_28	dcb.b	$8,0
RestoreBios_29	dcb.b	$8,0
RestoreBios_30	dcb.b	$8,0
RestoreBios_31	dcb.b	$8,0
RestoreBios_32	dcb.b	$8,0
RestoreBios_33	dcb.b	$8,0
RestoreBios_34	dcb.b	$8,0
RestoreBios_35	dcb.b	$11,0
RestoreBios_36	dc.b	$00	; .
RestoreBios_37	dc.b	$00,$00	; ..
RestoreBios_38	dc.b	$00,$00	; ..
RestoreBios_39	dc.b	$00	; .
.l238C3	dc.b	$00	; .
RestoreBios_40	dc.b	$00	; .
.l238C5	dc.b	$00,$00	; ..
.l238C7	dc.b	$00	; .
RestoreBios_41	dc.b	$00	; .
.l238C9	dc.b	$00	; .
RestoreBios_42	dc.b	$00,$00	; ..
RestoreBios_43	dc.b	$00,$00,$00,$00	; ....
RestoreBios_44	dcb.b	$80,0
RestoreBios_45	dcb.b	$80,0
RestoreBios_46	dcb.b	$80,0
RestoreBios_47	dcb.b	$80,0
RestoreBios_48	dcb.b	$80,0
RestoreBios_49	dcb.b	$8,0
RestoreBios_50	dc.b	$00,$00	; ..
RestoreBiosSub8	move.w	sr,-(sp)
	move.w	d0,$EC90.l
	move.l	d1,$EC92.l
	move.l	d2,$EC96.l
	move.l	d3,$EC9A.l
	move.l	d4,$EC9E.l
	jsr	$E3BC.l
	jsr	$E3F8.l
	jsr	$E3EE.l
	jsr	$E416.l
	move.w	#$0,$BC6E8.l
	move.w	#$2000,sr
	bclr.b	#$2,$FFFF8024.w
	jsr	$E454.l
	bset.b	#$2,$FFFF8024.w
	jsr	$E440.l
	move.w	#$0,d0
	jsr	$C4BC.l
	move.l	#$400,-(sp)
	jsr	$10540.l
	jsr	$D8F8.l
	bclr.b	#$2,$FFFF8024.w
	moveq	#$1E,d0
	jsr	$E370.l
	move.w	#$2700,sr
	movea.l	$EC96.l,a0
	move.l	$10ACC.l,(a0)
	bsr.w	ClearCommRegs
	move.w	(sp)+,sr
	rts
	move.w	#$0,$BC6E8.l
	bsr.w	.l23C4C
	bsr.w	LoadBootImages
	bsr.w	NopReturn
	bsr.w	CdStopMusic
	move.l	#$400,-(sp)
	bsr.w	CdSetFader
	bsr.w	SendCmd5
	bsr.w	ScreenSetupA
	bsr.w	ScreenSetupB
	bsr.w	SendCmdE320Inline
	move.w	$EC90.l,-(sp)
	bsr.w	CdPlayTrackRepeat
	move.l	#$4000200,-(sp)
	bsr.w	CdSetFader
	bsr.w	.l23C4C
	bsr.w	ScreenSetupC
	bsr.w	ClearCmdBuffer
	rts
.l23C4C	movem.l	d0-d7/a0-a6,-(sp)
	bclr.b	#$2,$FFFF8024.w
	lea.l	$80000.l,a0
	move.l	a0,$10984.l
	lea.l	$10BD8.l,a1
	lea.l	$15246.l,a2
	bsr.w	.l23CDC
	move.l	a0,$1094C.l
	lea.l	$15246.l,a1
	lea.l	$15942.l,a2
	bsr.w	.l23CDC
	move.l	a0,$109D8.l
	lea.l	$15942.l,a1
	lea.l	$16C62.l,a2
	bsr.w	.l23CDC
	move.l	a0,$109DC.l
	lea.l	$16C62.l,a1
	lea.l	$17402.l,a2
	bsr.w	.l23CDC
	move.l	a0,$109E0.l
	lea.l	$17402.l,a1
	lea.l	$1756C.l,a2
	bsr.w	.l23CDC
	move.l	a0,$10BD0.l
	bset.b	#$2,$FFFF8024.w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.l23CDC	move.b	(a1)+,(a0)+
	cmpa.l	a2,a1
	blt.b	.l23CDC
RestoreBios_51	rts
; Sends the load commands for the two boot images ($1756C, $DA24).
LoadBootImages	movem.l	d0-d7/a0-a6,-(sp)
	bclr.b	#$2,$FFFF8024.w
	move.w	#$2,d0
	moveq	#$2,d1
	bsr.w	SubCommandDispatch
	lea.l	$1756C.l,a0
	move.w	#$0,d1
	move.w	#$5,d0
	bsr.w	SubCommandDispatch
	lea.l	$DA24.l,a0
	move.w	#$6,d0
	bsr.w	SubCommandDispatch
	bset.b	#$2,$FFFF8024.w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.b	$00,$02,$00,$00,$FF,$FF	; ......
; Screen setup with inline palette words.
ScreenSetupA	movem.l	d0-d7/a0-a6,-(sp)
	andi.b	#$EF,$BC6E8.l
	bsr.w	SendCmd2Inline
	dc.b	$00,$00,$FC,$00,$E0,$00,$C0,$00,$B0,$00,$00,$06,$00,$20,$00,$00	; ............. ..
	dc.b	$0C,$CC	; ..
RestoreBiosSub9	bsr.w	SendCmd3
	moveq	#$1,d4
	move.w	d4,$10AF0.l
	movea.l	$109DC.l,a0
	lea.l	$8(a0),a2
	bsr.w	SendCmd4Args
	lea.l	$BA850.l,a1
	adda.l	(a0),a0
	moveq	#$1F,d0
.l2A70	move.l	(a0)+,(a1)+
	dbra	d0,.l2A70
	move.w	#$18,$BA8D0.l
	move.w	#$F0,d6
	move.w	#$A,$10B6C.l
	clr.w	$10B6E.l
	lea.l	$DB78.l,a3
.l2A96	bsr.w	AnimTick
	bsr.w	WaitFrameTick
	bsr.w	ReadPadsCombined
	moveq	#$0,d1
	tst.w	d1
	dbne	d6,.l2A96
	bsr.w	SendCmd2Inline
	dc.b	$00,$00,$FC,$00,$E0,$00,$C0,$00,$B0,$00,$00,$06,$00,$20,$00,$00	; ............. ..
	dc.b	$0C,$CC	; ..
RestoreBiosSub10	movem.l	(sp)+,d0-d7/a0-a6
	rts
; Advances the screen animation script by one tick.
AnimTick	movem.l	d0-d6/a0-a2,-(sp)
	btst.b	#$1,$BC6E8.l
	bne.w	.l2B72
	cmpi.w	#$10,$10B6E.l
	bgt.w	.l2B72
	subq.w	#$1,$10B6C.l
	bpl.w	.l2B72
	move.w	(a3)+,$10B6C.l
	move.w	(a3)+,d0
	cmpi.w	#$0,d0
	bne.w	.l2B20
	move.w	#$0,-(sp)
	move.l	#$0,-(sp)
	bsr.w	SetupSpriteFrame
	move.w	#$1,d0
	bsr.w	WaitCountdown
	move.w	#$0,-(sp)
	move.l	#$0,-(sp)
	bsr.w	SetupSpriteFrame
.l2B20	tst.w	-$2(a3)
	bpl.w	.l2B2A
	subq.w	#$4,a3
.l2B2A	addq.w	#$1,$10B6E.l
	bsr.w	SpriteListReset
	movea.l	$109DC.l,a0
	move.w	$10B6E.l,d2
	move.w	$10AF0.l,d4
.l2B46	move.w	#$80,d0
	move.w	#$80,d1
	cmpi.w	#$3,d2
	blt.w	.l2B5A
	move.w	#$88,d1
.l2B5A	bsr.w	SpriteListAddObject
	subq.w	#$1,d2
	bne.b	.l2B46
	bsr.w	SpriteListFinish
	bsr.w	SpriteListToVram
	bset.b	#$1,$BC6E8.l
.l2B72	movem.l	(sp)+,d0-d6/a0-a2
	rts
	dc.b	$00,$1E,$00,$00,$00,$1E,$00,$01,$00,$1E,$00,$01,$00,$04,$00,$01	; ................
	dc.b	$00,$06,$FF,$FF	; ....
; Screen setup, second variant.
ScreenSetupB	andi.b	#$9C,$BC6E8.l
	bsr.w	SendCmd3
	move.w	#$1,d4
	move.w	d4,$10AF0.l
	bsr.w	SendStateWithInline
	dc.b	$00,$08,$F8,$00,$01,$00,$00,$00	; ........
RestoreBiosSub11	movea.l	$109D8.l,a2
	lea.l	(a2),a0
	lea.l	(a2),a1
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	$2(a1),d3
	moveq	#$F,d5
	bsr.w	SaveRegsToCommBuf
	movea.l	#$107D0,a0
	movea.l	#$107CC,a1
	movea.l	#$107CA,a2
	lea.l	$10AF0.l,a3
	movea.l	$109E0.l,a4
	bsr.w	QueueAnimCmd
	movea.l	#$10822,a0
	movea.l	#$1081E,a1
	movea.l	#$1081C,a2
	lea.l	$10AF0.l,a3
	movea.l	$109E0.l,a4
	bsr.w	QueueAnimCmd
	movea.l	#$10874,a0
	movea.l	#$10870,a1
	movea.l	#$1086E,a2
	lea.l	$10AF0.l,a3
	movea.l	$109E0.l,a4
	bsr.w	QueueAnimCmd
	movea.l	#$108C6,a0
	movea.l	#$108C2,a1
	movea.l	#$108C0,a2
	lea.l	$10AF0.l,a3
	movea.l	$109E0.l,a4
	bsr.w	QueueAnimCmd
	move.w	#$20,$BA8D0.l
	move.w	#$B4,d7
.l2C60	bsr.w	.l23F78
	bsr.w	WaitFrameTick
	bsr.w	ReadPadsCombined
	tst.w	d1
	dbne	d7,.l2C60
	bsr.w	ClearCmdBuffer
	rts
.l23F78	btst.b	#$1,$BC6E8.l
	bne.w	.l2D20
	bsr.w	SpriteListReset
	move.w	$10AF0.l,d4
	movea.l	#$107CA,a2
	movea.l	#$107D0,a3
	movea.l	#$107CC,a4
	movea.l	$109E0.l,a0
	bsr.w	AnimNextFrame
	move.w	$10AF0.l,d4
	movea.l	#$1081C,a2
	movea.l	#$10822,a3
	movea.l	#$1081E,a4
	movea.l	$109E0.l,a0
	bsr.w	AnimNextFrame
	move.w	$10AF0.l,d4
	movea.l	#$1086E,a2
	movea.l	#$10874,a3
	movea.l	#$10870,a4
	movea.l	$109E0.l,a0
	bsr.w	AnimNextFrame
	move.w	$10AF0.l,d4
	movea.l	#$108C0,a2
	movea.l	#$108C6,a3
	movea.l	#$108C2,a4
	movea.l	$109E0.l,a0
	bsr.w	AnimNextFrame
	bsr.w	SpriteListFinish
	bsr.w	SpriteListToVram
	bset.b	#$1,$BC6E8.l
.l2D20	rts
; Screen setup, third variant.
ScreenSetupC	andi.b	#$9C,$BC6E8.l
	bsr.w	SendCmd2Inline
	dc.b	$00,$00,$FC,$00,$E0,$00,$C0,$00,$B0,$00,$00,$06,$00,$20,$00,$00	; ............. ..
	dc.b	$0C,$CC	; ..
RestoreBiosSub12	bsr.w	SendCmd3
	bsr.w	SendCmdF
	move.w	$10BCE.l,$10B2A.l
	move.w	$10BCE.l,$10B2C.l
	moveq	#$1C,d0
	bsr.w	SendCmdD0
	clr.w	$10B22.l
	bsr.w	SendStateInline
	dc.b	$00,$06,$FF,$00,$00,$00	; ......
RestoreBiosSub13	move.l	#$80,d0
	moveq	#$20,d1
	move.l	#$7FF,d2
	jsr	$E4D6.l
	bsr.w	SendStateInline
	dc.b	$00,$06,$FE,$00,$00,$00	; ......
RestoreBiosSub14	move.l	#$80,d0
	moveq	#$20,d1
	move.l	#$7FF,d2
	jsr	$E4D6.l
	moveq	#$1C,d4
	bsr.w	SendStateInline
	dc.b	$00,$06,$FE,$00,$13,$00	; ......
RestoreBiosSub15	movea.l	$10984.l,a1
	adda.l	$4(a1),a1
	lea.l	$BC6EC.l,a2
	clr.w	d0
	moveq	#$13,d1
	move.w	(a1),d2
	move.w	$2(a1),d3
	sub.w	d1,d3
	moveq	#$0,d5
	jsr	$E51C.l
	bsr.w	SendStateInline
	dc.b	$00,$06,$FD,$00,$00,$00	; ......
RestoreBiosSub16	movea.l	$10984.l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	$2(a1),d3
	moveq	#$F,d5
	jsr	$E51C.l
	move.w	d4,$10AFE.l
	movea.l	$1094C.l,a2
	addq.l	#$8,a2
	jsr	$E12A.l
	bsr.w	CopyAnimStateToCmd
	bsr.w	SendStateInline
	dc.b	$00,$06,$FF,$00,$00,$00	; ......
RestoreBiosSub17	lea.l	$25F0E.l,a1
	bsr.w	CalcScrollPhase
	addi.w	#$40,$10B22.l
	clr.w	$10B20.l
	clr.w	$10B24.l
	move.w	#$5,$10B28.l
	move.w	#$20,$BA8D0.l
	move.w	#$F0,d3
.l2E52	bsr.w	WaitFrameAndUpdate
	dbra	d3,.l2E52
	bsr.w	SendStateInline
	dc.b	$00,$06,$FF,$00,$00,$00	; ......
RestoreBiosSub18	lea.l	$25F36.l,a1
.l2E6A	bsr.w	CalcScrollPhase
	adda.w	(a1),a1
	moveq	#$3F,d4
.l2E72	bsr.w	WaitFrameAndUpdate
	bsr.w	WaitFrameAndUpdate
	addq.w	#$1,$10B22.l
	dbra	d4,.l2E72
	moveq	#$78,d4
.l2E86	bsr.w	WaitFrameAndUpdate
	dbra	d4,.l2E86
	tst.w	$2(a1)
	bpl.b	.l2E6A
	rts
; Derives the scroll phase from the counter at $10B22.
CalcScrollPhase	move.w	$10B22.l,d0
	asr.w	#$3,d0
	addi.w	#$1C,d0
	andi.w	#$1F,d0
	move.w	d0,$10B0C.l
	move.w	d0,-(sp)
	clr.w	$10B0A.l
	moveq	#$20,d0
	moveq	#$9,d1
	move.w	#$7FF,d2
	jsr	$E4D6.l
	move.w	(sp)+,$10B0C.l
.l2EC8	move.w	(a1),d0
	asr.w	#$1,d0
	neg.w	d0
	addi.w	#$10,d0
	move.w	d0,$10B0A.l
	bsr.w	SendPadStateCmd
	addq.w	#$1,$10B0C.l
	andi.w	#$1F,$10B0C.l
	tst.w	$2(a1)
	bpl.b	.l2EC8
	rts
; Waits for the next frame tick, then updates the screen state.
WaitFrameAndUpdate	movem.l	d0-d7/a0-a6,-(sp)
	move.w	$10AE0.l,d0
.l2EFC	cmp.w	$10AE0.l,d0
	beq.b	.l2EFC
	bsr.w	.l2421E
	jsr	$E198.l
	btst	#$7,d1
	movem.l	(sp)+,d0-d7/a0-a6
	beq.w	.l242AA
	addq.l	#$4,sp
	rts
.l2421E	lea.l	$BA450.l,a0
	move.w	$10B22.l,(a0)
	moveq	#$1D,d0
	bsr.w	SendCmdD0
	move.w	#$DF,d0
	lea.l	$BC368.l,a0
	moveq	#$7F,d1
	add.w	$10B20.l,d1
.l2F42	clr.l	(a0)+
	cmpi.w	#$48,d0
	ble.w	.l2F50
	move.w	d1,-$2(a0)
.l2F50	dbra	d0,.l2F42
	bset.b	#$0,$BC6E8.l
	bset.b	#$6,$BC6E8.l
	cmpi.w	#$B4,$10B20.l
	blt.w	.l2F9E
	subq.w	#$1,$10B24.l
	bpl.w	.l242AA
	move.w	#$12C,d0
	jsr	$E488.l
	move.w	d0,$10B24.l
	andi.w	#$7,d0
	addq.w	#$4,d0
	move.w	d0,$10B28.l
	move.w	#$FEB4,$10B20.l
.l2F9E	move.w	$10B28.l,d0
	add.w	d0,$10B20.l
.l242AA	rts
; Waits until the frame counter at $10AE0 changes.
WaitFrameTick	move.w	d0,-(sp)
	move.w	$10AE2.l,d0
.l2FB4	cmp.w	$10AE0.l,d0
	beq.b	.l2FB4
	move.w	$10AE0.l,$10AE2.l
	move.w	(sp)+,d0
	rts
; Points the sprite list registers at $BA8D2/$BAF16 and restarts the count.
SpriteListReset	movea.l	#$BA8D2,a5
	movea.l	#$BAF16,a6
	moveq	#$1,d6
	rts
; Adds the sprites of one object to the list (max $50).
SpriteListAddObject	cmpi.w	#$50,d6
	bgt.w	RestoreBios_51
RestoreBiosSub19	movem.l	d0-d5/a0,-(sp)
	adda.l	$4(a0),a0
	move.w	d2,d5
	andi.w	#$7FF,d2
	add.w	d2,d2
	move.w	(a0,d2.w),d3
	sub.w	-$2(a0,d2.w),d3
	lsr.w	#$3,d3
	subq.w	#$1,d3
	adda.w	-$2(a0,d2.w),a0
.l3002	move.w	$2(a0),(a6)
	add.w	d1,(a6)+
	move.b	$7(a0),(a6)+
	move.b	d6,(a6)+
	move.w	$6(a0),d2
	eor.w	d5,d2
	andi.w	#$F800,d2
	add.w	$4(a0),d2
	add.w	d4,d2
	move.w	d2,(a6)+
	move.w	(a0),(a6)
	add.w	d0,(a6)+
	addq.w	#$1,d6
	cmpi.w	#$51,d6
	beq.w	.l3034
	addq.l	#$8,a0
	dbra	d3,.l3002
.l3034	movem.l	(sp)+,d0-d5/a0
	rts
; Terminates the sprite list.
SpriteListFinish	moveq	#-1,d0
	add.w	d6,d0
	bne.w	.l3048
	moveq	#$1,d0
	clr.l	(a6)+
	clr.l	(a6)+
.l3048	cmpi.w	#$50,d0
	ble.w	.l3052
	moveq	#$50,d0
.l3052	asl.w	#$3,d0
	lea.l	$BAF16.l,a6
	clr.b	-$5(a6,d0.w)
	lsr.w	#$1,d0
	move.w	d0,$BB1E6.l
	move.l	a5,$BAF12.l
	rts
; Copies the sprite data to the buffer at $BC6F0.
SpriteListToVram	movea.l	#$BC6F0,a0
	lea.l	$BA8D2.l,a1
	move.l	#$80000,d1
.l3080	cmpa.l	$BAF12.l,a1
	beq.w	.l30B0
	move.l	(a1),d0
	cmp.l	d1,d0
	bgt.w	.l30AC
	movea.l	d0,a2
	move.w	$4(a1),d0
	subq.w	#$1,d0
	move.l	a0,(a1)
.l309C	move.w	(a2)+,(a0)+
	cmpa.l	#$C0000,a0
	bge.w	.l30B8
	dbra	d0,.l309C
.l30AC	addq.l	#$8,a1
	bra.b	.l3080
.l30B0	move.l	a0,$10AC8.l
	rts
.l30B8	bra.b	.l30B8
; Steps an animation script to its next frame or loop point.
AnimNextFrame	movea.l	(a4),a1
	move.w	$2(a1),d2
	subq.w	#$1,(a2)
	bpl.w	.l30F2
	addq.l	#$4,a1
	move.w	(a1),d0
	bpl.w	.l30EA
	move.w	$2(a1),d0
	beq.w	.l30DA
	bmi.w	.l30E6
.l30DA	move.l	a3,(a4)
	addq.l	#$4,(a4)
	movea.l	(a4),a1
	move.w	(a1),d0
	bra.w	.l30EA
.l30E6	subq.l	#$4,a1
	move.w	(a1),d0
.l30EA	move.w	d0,(a2)
	move.w	$2(a1),d2
	move.l	a1,(a4)
.l30F2	tst.w	d2
	bmi.w	RestoreBios_65
	move.w	(a3)+,d0
RestoreBiosSub20	move.w	(a3),d1
	bsr.w	SpriteListAddObject
RestoreBios_65	rts
; Stores the animation state and sends command 4.
QueueAnimCmd	move.w	d4,(a3)
	move.l	a0,(a1)
	addq.l	#$4,(a1)
	move.w	$4(a0),(a2)
	movea.l	a4,a0
	lea.l	$8(a0),a2
	bsr.w	SendCmd4Args
	rts
; Stores -d0 in the frame counter and waits until it counts up past zero.
WaitCountdown	neg.w	d0
	move.w	d0,$10AE0.l
.l3120	tst.w	$10AE0.l
	bmi.b	.l3120
	rts
; Puts d4/a2 in the command buffer and sends command 4.
SendCmd4Args	movem.l	d0-d1/a0,-(sp)
	lea.l	$BA450.l,a0
	move.l	d4,(a0)+
	move.l	a2,(a0)
	moveq	#$4,d0
	bsr.w	SendCmdD0
	lea.l	$BA450.l,a0
	move.l	(a0),d4
	movem.l	(sp)+,d0-d1/a0
	rts
; Clears the 32-long command buffer at $BA850.
ClearCmdBuffer	movem.l	d0/a0,-(sp)
	lea.l	$BA850.l,a0
	moveq	#$1F,d0
.l3158	move.l	(a0),-(sp)
	clr.l	(a0)+
	dbra	d0,.l3158
	move.w	#$18,$BA8D0.l
	bsr.w	.l2447A
	moveq	#$1F,d0
.l316E	move.l	(sp)+,-(a0)
	dbra	d0,.l316E
	movem.l	(sp)+,d0/a0
	rts
.l2447A	move.w	$BC6E8.l,-(sp)
	bclr.b	#$4,$BC6E8.l
.l3188	tst.w	$BA8D0.l
	bpl.b	.l3188
	move.w	(sp)+,$BC6E8.l
	rts
; Reads the pads four times and ORs the results.
ReadPadsCombined	movem.l	d0/d2-d4,-(sp)
	clr.w	-(sp)
	moveq	#$3,d4
.l31A0	bsr.w	ReadCommRegs
	bsr.w	PadAutoRepeat
	or.w	d1,(sp)
	dbra	d4,.l31A0
	move.w	(sp)+,d1
	movem.l	(sp)+,d0/d2-d4
	rts
	tst.w	d3
	beq.w	RestoreBios_71
	tst.w	d2
	bne.w	.l31DC
	subq.b	#$1,$10B1C.l
	bpl.w	RestoreBios_71
	move.b	#$4,$10B1C.l
	move.w	d3,d1
	andi.w	#$F,d1
	rts
.l31DC	move.b	#$F,$10B1C.l
RestoreBios_71	rts
	tst.w	d3
	beq.b	RestoreBios_71
	tst.w	d2
	bne.w	.l3208
	subq.b	#$1,$10B1D.l
	bpl.b	RestoreBios_71
	move.b	#$4,$10B1D.l
	move.w	d3,d1
	andi.w	#$F,d1
	rts
.l3208	move.b	#$F,$10B1D.l
	rts
; Auto-repeat counter for held pad directions.
PadAutoRepeat	tst.w	d3
	beq.b	RestoreBios_71
RestoreBiosSub21	movem.l	a0,-(sp)
	lea.l	$10B1C.l,a0
	tst.w	d2
	bne.w	.l323E
	subq.b	#$1,(a0,d4.w)
	bpl.w	.l3244
	move.b	#$4,(a0,d4.w)
	move.w	d3,d1
	andi.w	#$F,d1
	bra.w	.l3244
.l323E	move.b	#$F,(a0,d4.w)
.l3244	movem.l	(sp)+,a0
	rts
; Copies the main-CPU comm registers $801C-$801E into the pad/status bytes at $10B14.
ReadCommRegs	move.w	$FFFF801C.w,d0
	move.b	d0,$10B15.l
	lsr.w	#$8,d0
	move.b	d0,$10B14.l
	move.w	$FFFF801E.w,d0
	move.b	d0,$10B17.l
	lsr.w	#$8,d0
	move.b	d0,$10B16.l
	moveq	#$0,d0
RestoreBiosSub22	movem.l	a0,-(sp)
	lea.l	$10B14.l,a0
	move.b	(a0,d4.w),d0
	bsr.w	.l245DE
	moveq	#$0,d2
	move.b	$4(a0,d4.w),d2
	move.b	d1,$4(a0,d4.w)
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	movem.l	(sp)+,a0
	rts
	move.w	$FFFF801C.w,d0
	lsr.w	#$8,d0
	move.b	d0,$10B14.l
	bsr.w	.l245DE
	move.b	$10B18.l,d2
	move.b	d1,$10B18.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
	move.w	$FFFF801C.w,d0
	move.b	d0,$10B15.l
	bsr.w	.l245DE
	move.b	$10B19.l,d2
	move.b	d1,$10B19.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
.l245DE	clr.w	d1
	move.b	d0,d1
RestoreBiosSub23	movem.l	d1/a0,-(sp)
	andi.w	#$F0,d0
	andi.w	#$F,d1
	lea.l	$E300.l,a0
	move.b	(a0,d1.w),d1
	or.w	d1,d0
	movem.l	(sp)+,d1/a0
	rts
	dc.b	$08,$00,$04,$08,$06,$07,$05,$08,$02,$01,$03,$08,$08,$08,$08,$08	; ................
; Sends command 3 to the main CPU.
SendCmd3	movem.l	d0,-(sp)
	moveq	#$3,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,d0
	rts
; Sends command 2 with the nine inline words after the call.
SendCmd2Inline	movea.l	(sp),a0
	lea.l	$BA450.l,a1
	moveq	#$8,d0
.l332A	move.w	(a0)+,(a1)+
	dbra	d0,.l332A
	move.l	a0,(sp)
	moveq	#$2,d0
	bra.w	SendCmdD0
RestoreBiosSub24	movem.l	d0/d2-d3/a1,-(sp)
	lea.l	$BA450.l,a1
	move.w	d0,(a1)+
	move.w	d1,(a1)+
	move.l	a0,(a1)
	moveq	#$0,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,d0/d2-d3/a1
	rts
RestoreBiosSub25	movem.l	d0/d2-d3/a1,-(sp)
	lea.l	$BA450.l,a1
	move.w	d0,(a1)+
	move.w	d1,(a1)+
	move.l	a0,(a1)
	moveq	#$1,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,d0/d2-d3/a1
	rts
; Sends the command in d0 through the gate-array comm registers and waits for the acknowledge.
SendCmdD0	move.w	d0,$FFFF8020.w
	bset.b	#$6,$FFFF800F.w
.l337A	btst.b	#$6,$FFFF800E.w
	beq.b	.l337A
	bclr.b	#$6,$FFFF800F.w
	move.w	#$0,$FFFF8020.w
	bclr.b	#$1,$FFFF8024.w
	bsr.w	CommHandshake0
	bsr.w	ReleaseWordRam
	bsr.w	CommHandshake1
.l33A0	btst.b	#$0,$FFFF8014.w
	beq.b	.l33A0
	bset.b	#$1,$FFFF8024.w
	bsr.w	CommHandshake2
	bsr.w	TakeWordRam
	bsr.w	CommHandshake3
	rts
; Clears the sub-CPU communication registers $8020-$802C.
ClearCommRegs	move.w	#$0,$FFFF8020.w
	move.w	#$0,$FFFF8022.w
	move.w	#$0,$FFFF8024.w
	move.w	#$0,$FFFF8026.w
	move.w	#$0,$FFFF8028.w
	move.w	#$0,$FFFF802A.w
	move.w	#$0,$FFFF802C.w
	move.w	#$0,$FFFF802E.w
	rts
.l33EE	bclr.b	#$2,$FFFF8003.w
	bne.b	.l33EE
	rts
.l33F8	btst.b	#$7,$FFFF800E.w
	beq.b	.l33F8
	bset.b	#$7,$FFFF800F.w
.l3406	btst.b	#$7,$FFFF800E.w
	bne.b	.l3406
	bclr.b	#$7,$FFFF800F.w
	rts
; Waits until word RAM is granted to the sub CPU and notes it.
TakeWordRam	btst.b	#$1,$FFFF8003.w
	beq.b	TakeWordRam
	btst.b	#$0,$FFFF8003.w
	bne.b	TakeWordRam
	bset.b	#$1,$10912.l
	rts
; Returns word RAM to the main CPU.
ReleaseWordRam	bset.b	#$0,$FFFF8003.w
	bclr.b	#$1,$10912.l
	rts
	lea.l	$10ADA.l,a0
.l3446	clr.b	(a0)+
	cmpa.l	#$10BD8,a0
	blt.b	.l3446
	rts
; Empty routine.
NopReturn	rts
	dc.b	$4E,$B9,$00,$00,$E3,$F8	; N.....
RestoreBiosSub26	movem.l	a0-a1,-(sp)
	movea.l	$EC96.l,a0
	move.l	(a0),$10ACC.l
	move.l	#$EA8A,(a0)
	bset.b	#$2,$FFFF8033.w
	movem.l	(sp)+,a0-a1
	rts
	move.w	d0,-(sp)
	add.w	d0,d0
	bsr.w	.l24788
	sub.w	(sp)+,d0
	rts
.l24788	movem.l	d0-d2,-(sp)
	move.w	$10B2C.l,d0
	move.w	d0,d1
	move.w	$10B2A.l,d2
	mulu.w	#$E62D,d0
	mulu.w	#$BB40,d1
	mulu.w	#$E62D,d2
	add.w	d2,d1
	swap	d0
	add.w	d1,d0
	swap	d0
	addq.l	#$1,d0
	move.l	d0,$10B2A.l
	asr.l	#$8,d0
	mulu.w	$2(sp),d0
	swap	d0
	addq.l	#$4,sp
	movem.l	(sp)+,d1-d2
	rts
RestoreBiosSub27	movem.l	d0/a0,-(sp)
	moveq	#$6,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,d0/a0
	rts
RestoreBiosSub28	movem.l	d0-d3/a0,-(sp)
	lea.l	$BA450.l,a0
	move.w	d0,(a0)+
	move.w	d1,(a0)+
	move.w	d2,(a0)+
	move.w	$10B0A.l,(a0)+
	move.w	$10B0C.l,(a0)+
	move.w	$10B10.l,(a0)+
	moveq	#$7,d0
	bsr.w	SendCmdD0
	lea.l	$BA450.l,a0
	move.w	(a0)+,$10B0A.l
	move.w	(a0)+,$10B0C.l
	move.w	(a0)+,$10B10.l
	movem.l	(sp)+,d0-d3/a0
	rts
; Stores the registers and pad values in the command buffer.
SaveRegsToCommBuf	movem.l	d0-d3/d5-d6/a0-a3/a6,-(sp)
	lea.l	$BA450.l,a6
	move.l	a0,(a6)+
	move.l	a1,(a6)+
	move.l	a2,(a6)+
	move.l	d0,(a6)+
	move.l	d1,(a6)+
	move.l	d2,(a6)+
	move.l	d3,(a6)+
	move.l	d4,(a6)+
	move.l	d5,(a6)+
	move.w	$10B0E.l,(a6)+
	move.w	$10B0A.l,(a6)+
	move.w	$10B0C.l,(a6)+
	move.w	$10B10.l,(a6)+
	moveq	#$8,d0
	bsr.w	SendCmdD0
	lea.l	$BA450.l,a6
	move.w	(a6)+,d4
	move.w	(a6)+,$10B0E.l
	move.w	(a6)+,$10B0A.l
	move.w	(a6)+,$10B0C.l
	move.w	(a6)+,$10B10.l
	movem.l	(sp)+,d0-d3/d5-d6/a0-a3/a6
	rts
; Sends the pad state plus a length-prefixed inline block (command $B).
SendStateInline	movem.l	d0/a1-a2,-(sp)
	movea.l	$C(sp),a1
	lea.l	$BA450.l,a2
	move.w	$10B0E.l,(a2)+
	move.w	$10B10.l,(a2)+
	move.w	$10B0A.l,(a2)+
	move.w	$10B0C.l,(a2)+
	move.w	$10AFE.l,(a2)+
	move.w	(a1),d0
	lsr.w	#$1,d0
	subq.w	#$1,d0
.l35AE	move.w	(a1)+,(a2)+
	dbra	d0,.l35AE
	move.l	a1,$C(sp)
	moveq	#$B,d0
	bsr.w	SendCmdD0
	lea.l	$BA450.l,a1
	move.w	(a1)+,$10B0E.l
	move.w	(a1)+,$10B10.l
	move.w	(a1)+,$10B0A.l
	move.w	(a1),$10B0C.l
	movem.l	(sp)+,d0/a1-a2
	rts
RestoreBiosSub29	movem.l	d0-d3/a0/a2-a3,-(sp)
	lea.l	$BA450.l,a2
	move.w	$10B0E.l,(a2)+
	move.w	$10B0A.l,(a2)+
	move.w	$10B0C.l,(a2)+
	move.w	$10B12.l,(a2)+
	move.w	$10B10.l,(a2)+
	move.w	$10AFE.l,(a2)+
	move.w	$10B00.l,(a2)+
	move.w	$10B02.l,(a2)+
	move.w	(a1),d0
	lsr.w	#$1,d0
	subq.w	#$1,d0
.l3622	move.w	(a1)+,(a2)+
	dbra	d0,.l3622
	moveq	#$C,d0
	bsr.w	SendCmdD0
	lea.l	$BA450.l,a2
	move.w	(a2)+,$10B0E.l
	move.w	(a2)+,$10B0A.l
	move.w	(a2)+,$10B0C.l
	move.w	(a2)+,$10B12.l
	move.w	(a2),$10B10.l
	movem.l	(sp)+,d0-d3/a0/a2-a3
	rts
; Sends the pad state plus a length-prefixed inline block.
SendStateWithInline	movem.l	d0/a1-a2,-(sp)
	movea.l	$C(sp),a1
	lea.l	$BA450.l,a2
	move.w	$10B0E.l,(a2)+
	move.w	$10B0A.l,(a2)+
	move.w	$10B0C.l,(a2)+
	move.w	$10B12.l,(a2)+
	move.w	$10B10.l,(a2)+
	move.w	$10AFE.l,(a2)+
	move.w	$10B00.l,(a2)+
	move.w	$10B02.l,(a2)+
	move.w	(a1),d0
	lsr.w	#$1,d0
	subq.w	#$1,d0
.l369C	move.w	(a1)+,(a2)+
	dbra	d0,.l369C
	moveq	#$D,d0
	bsr.w	SendCmdD0
	move.l	a1,$C(sp)
	lea.l	$BA450.l,a1
	move.w	(a1)+,$10B0E.l
	move.w	(a1)+,$10B0A.l
	move.w	(a1)+,$10B0C.l
	move.w	(a1)+,$10B12.l
	move.w	(a1),$10B10.l
	movem.l	(sp)+,d0/a1-a2
	rts
RestoreBiosSub30	movem.l	d1-d4,-(sp)
	clr.w	d4
	moveq	#$2,d3
	moveq	#$E,d2
.l36E0	move.w	d0,d1
	and.w	d2,d1
	beq.w	.l36EE
	add.w	d2,d1
	and.w	d2,d1
	or.w	d1,d4
.l36EE	asl.w	#$4,d2
	dbra	d3,.l36E0
	move.w	d4,d0
	movem.l	(sp)+,d1-d4
	rts
; Copies the animation state words into the command buffer.
CopyAnimStateToCmd	movem.l	d0/a0-a1,-(sp)
	lea.l	$BA450.l,a0
	lea.l	$10AE4.l,a1
.l370C	move.w	(a1)+,(a0)+
	cmpa.l	#$10B08,a1
	blt.b	.l370C
	moveq	#$E,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,d0/a0-a1
	rts
RestoreBiosSub31	movem.l	a1,-(sp)
	movem.l	$4(sp),a1
	bsr.w	.l24A3C
	movem.l	a1,$4(sp)
	movem.l	(sp)+,a1
	rts
.l24A3C	movem.l	d0/a0,-(sp)
	lea.l	$2(a3),a0
	move.w	(a3),d0
	subq.w	#$3,d0
	bmi.w	.l3754
.l374C	addq.l	#$1,a0
	tst.b	(a0)
	dbeq	d0,.l374C
.l3754	move.w	(a1)+,d0
	subq.w	#$3,d0
	bmi.w	.l377A
.l375C	move.b	(a1)+,(a0)+
	bne.w	.l3764
	subq.l	#$1,a0
.l3764	dbra	d0,.l375C
	move.l	a0,d0
	btst	#$0,d0
	beq.w	.l3776
	clr.b	(a0)+
	addq.l	#$1,d0
.l3776	sub.l	a3,d0
	move.w	d0,(a3)
.l377A	movem.l	(sp)+,d0/a0
	rts
RestoreBiosSub32	movem.l	d1-d2/a0-a1,-(sp)
	clr.w	d0
	clr.w	d1
	move.w	(a1)+,d2
	subq.w	#$2,d2
	bra.w	.l37A8
.l3790	move.b	(a1)+,d1
	beq.w	.l37A8
	bpl.w	.l37A4
	subq.w	#$2,d2
	addq.l	#$2,a1
	clr.w	d0
	bra.w	.l37A8
.l37A4	bsr.w	.l24AB2
.l37A8	dbra	d2,.l3790
	movem.l	(sp)+,d1-d2/a0-a1
	rts
.l24AB2	ext.w	d1
	beq.w	RestoreBios_71
	cmpi.w	#$61,d1
	blt.w	.l37CC
	cmpi.w	#$7A,d1
	bgt.w	.l37CC
	addi.w	#$FFE0,d1
.l37CC	addq.w	#$1,d0
	movea.l	#$10570,a0
	tst.b	-$20(a0,d1.w)
	bmi.w	RestoreBios_71
	addq.w	#$1,d0
	rts
; Sends command $F and keeps the reply word.
SendCmdF	movem.l	d0,-(sp)
	moveq	#$F,d0
	bsr.w	SendCmdD0
	move.w	$BA450.l,$10BCE.l
	movem.l	(sp)+,d0
	rts
RestoreBiosSub33	movem.l	d0-d1/a0-a1,-(sp)
	lea.l	$BA450.l,a0
	move.l	d4,(a0)+
	move.l	a2,(a0)+
	movea.l	$10(sp),a1
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	moveq	#$10,d0
	bsr.w	SendCmdD0
	lea.l	$BA450.l,a0
	move.l	(a0),d4
	movem.l	(sp)+,d0-d1/a0-a1
	addq.l	#$8,(sp)
	rts
; Sets and clears handshake flag 0 in $8028 after the main CPU answers on $8018.
CommHandshake0	btst.b	#$0,$FFFF8018.w
	beq.b	CommHandshake0
	bset.b	#$0,$FFFF8028.w
.l3834	btst.b	#$0,$FFFF8018.w
	bne.b	.l3834
	bclr.b	#$0,$FFFF8028.w
	rts
; Handshake flag 1.
CommHandshake1	btst.b	#$1,$FFFF8018.w
	beq.b	CommHandshake1
	bset.b	#$1,$FFFF8028.w
.l3852	btst.b	#$1,$FFFF8018.w
	bne.b	.l3852
	bclr.b	#$1,$FFFF8028.w
	rts
; Handshake flag 2.
CommHandshake2	btst.b	#$2,$FFFF8018.w
	beq.b	CommHandshake2
	bset.b	#$2,$FFFF8028.w
.l3870	btst.b	#$2,$FFFF8018.w
	bne.b	.l3870
	bclr.b	#$2,$FFFF8028.w
	rts
; Handshake flag 3.
CommHandshake3	btst.b	#$3,$FFFF8018.w
	beq.b	CommHandshake3
	bset.b	#$3,$FFFF8028.w
.l388E	btst.b	#$3,$FFFF8018.w
	bne.b	.l388E
	bclr.b	#$3,$FFFF8028.w
	rts
RestoreBiosSub34	movem.l	d0/a0-a1,-(sp)
	lea.l	$BA450.l,a0
	movea.l	$C(sp),a1
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	a1,$C(sp)
	moveq	#$12,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,d0/a0-a1
	rts
RestoreBiosSub35	movem.l	d0/a0-a1,-(sp)
	lea.l	$BA450.l,a0
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	moveq	#$12,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,d0/a0-a1
	rts
; Sends command 5 with the value from $1094C.
SendCmd5	lea.l	$BA450.l,a0
	move.l	$1094C.l,(a0)+
	moveq	#$5,d0
	bsr.w	SendCmdD0
	rts
; Sends the pad state registers in the command buffer.
SendPadStateCmd	movem.l	d0-d3/a0/a2/a6,-(sp)
	lea.l	$BA450.l,a2
	move.w	$10B0E.l,(a2)+
	move.w	$10B10.l,(a2)+
	move.w	$10B0A.l,(a2)+
	move.w	$10B0C.l,(a2)+
	move.w	$10AFE.l,(a2)+
	move.w	(a1),d0
	lsr.w	#$1,d0
	subq.w	#$1,d0
.l3924	move.w	(a1)+,(a2)+
	dbra	d0,.l3924
	movea.l	a1,a6
	moveq	#$B,d0
	bsr.w	SendCmdD0
	lea.l	$BA450.l,a1
	move.w	(a1)+,$10B0E.l
	move.w	(a1)+,$10B10.l
	move.w	(a1)+,$10B0A.l
	move.w	(a1),$10B0C.l
	movea.l	a6,a1
	movem.l	(sp)+,d0-d3/a0/a2/a6
	rts
RestoreBiosSub36	movem.l	a0,-(sp)
	lea.l	$BA450.l,a0
	move.w	d0,(a0)
	moveq	#$13,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,a0
	rts
	bsr.w	.l24C78
	bra.w	RestoreBiosSub29
.l24C78	bra.w	.l397E
.l397C	adda.w	(a1),a1
.l397E	dbra	d0,.l397C
	rts
RestoreBiosSub37	movem.l	d0,-(sp)
	moveq	#$14,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,d0
	rts
RestoreBiosSub38	movem.l	d0,-(sp)
	moveq	#$15,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,d0
	rts
RestoreBiosSub39	movem.l	d0/a0,-(sp)
	lea.l	$BA450.l,a0
	move.w	$10B22.l,(a0)+
	move.w	d0,(a0)+
	moveq	#$16,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,d0/a0
	rts
RestoreBiosSub40	movem.l	d0/a0,-(sp)
	move.w	d0,$BA450.l
	moveq	#$19,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,d0/a0
	rts
	move.l	d0,-(sp)
	moveq	#$17,d0
	bsr.w	SendCmdD0
	move.l	(sp)+,d0
	rts
RestoreBiosSub41	movem.l	d0-d2/a0,-(sp)
	lea.l	$BA450.l,a0
RestoreBiosSub42	move.w	d0,(a0)+
	move.w	d1,(a0)+
	move.w	d2,(a0)+
	moveq	#$18,d0
	bsr.w	SendCmdD0
	movem.l	(sp)+,d0-d2/a0
	rts
.l3A00	bset.b	#$2,$FF8003.l
	bne.b	.l3A00
	rts
