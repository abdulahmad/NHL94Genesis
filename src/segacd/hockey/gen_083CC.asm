GameSetUp
	jsr	$2A58C.l
	dc.w	$267C,$0001,$8C38
	dc.w	$4EB9,$0004,$057C
	dc.w	$33F9,$0001,$8C22,$0001,$8C0A
	dc.w	$33F9,$0001,$8C24,$0001,$8BFA
	bclr	#$1,$17F7A.l
	jsr	$29302.l
	jsr	(ReadNameLog).l
	bsr.w	Sub_24348
	dc.w	$4279,$0001,$9384
	dc.w	$4279,$0001,$9386
	bsr.w	PrintOptionNames
	dc.w	$4A79,$0001,$8C16
	bne.w	L8440
	moveq	#$1C,d0
	dc.w	$4EB9,$0003,$7050
	dc.w	$33C0,$0001,$8BFE
	moveq	#$1C,d0
	dc.w	$4EB9,$0003,$7050
	dc.w	$33C0,$0001,$8C00
L8440	dc.w	$50F9,$0001,$8C16
	dc.w	$0C79,$0004,$0001,$8BFA
	bne.w	L8456
	bra.w	L8476
L8456	dc.w	$0C79,$0002,$0001,$8BFA
	blt.w	L8466
	bsr.w	Sub_23798
L8466	dc.w	$0C79,$0001,$0001,$8BFA
	bne.w	L8476
	bsr.w	Sub_2379E
L8476	clr.w	d7
	clr.w	d0
	bsr.w	MoveMenuFrame
	bsr.w	FixModeOptions
	dc.w	$33F9,$0001,$7FAE,$0001,$938C
	dc.w	$33F9,$0001,$7FAE,$0001,$938A
	bsr.w	DrawHomeBlock
	dc.w	$33F9,$0001,$7FB0,$0001,$938E
	dc.w	$33F9,$0001,$7FB0,$0001,$938A
	bsr.w	DrawVisBlock
	move.w	#$18,(palcount).l
	bclr	#$2,(disflags).l
Sub_234C2
	dc.w	$0C79,$0004,$0001,$8BFA
	bne.w	L84E6
	dc.w	$33FC,$0001,$0001,$8C0A
	dc.w	$33FC,$0000,$0001,$8C08
	dc.w	$33FC,$0001,$0001,$8C06
L84E6	bsr.w	ReadSetupPads
	tst.w	d1
	bne.w	L84F4
	bra.w	Sub_24660
L84F4	btst	#$7,d1
	bne.w	Sub_24720
	btst	#$1,d1
	beq.w	L85A0
	tst.w	(OptNOP).l
	bne.w	L851E
	cmpi.w	#$8,d7
	bne.w	L851E
	move.w	#$4,d0
	bra.w	L8522
L851E	move.w	#$2,d0
L8522	dc.w	$0C79,$0004,$0001,$8BFA
	beq.w	L8548
	tst.w	(OptNOP).l
	bne.w	L8548
	cmpi.w	#$8,d7
	bne.w	L8548
	move.w	#$6,d0
	bra.w	L8594
L8548	cmpi.w	#$6,d7
	bne.w	L856C
	dc.w	$0C79,$0004,$0001,$8BFA
	bne.w	L856C
	tst.w	(OptNOP).l
	bne.w	L8590
	clr.w	d0
	bra.w	L8594
L856C	cmpi.w	#$A,d7
	bne.w	L8594
	dc.w	$0C79,$0004,$0001,$8BFA
	bne.w	L8586
	clr.w	d0
	bra.w	L8594
L8586	dc.w	$4A79,$0001,$93BA
	bpl.w	L8594
L8590	move.w	#$4,d0
L8594	bsr.w	MoveMenuFrame
	bsr.w	FixModeOptions
	bra.w	Sub_234C2
L85A0	btst	#$0,d1
	beq.w	L862E
	tst.w	(OptNOP).l
	bne.w	L85C2
	cmpi.w	#$C,d7
	bne.w	L85C2
	move.w	#$FFFC,d0
	bra.w	L85EC
L85C2	move.w	#$FFFE,d0
	dc.w	$0C79,$0004,$0001,$8BFA
	beq.w	L85EC
	tst.w	(OptNOP).l
	bne.w	L85EC
	cmpi.w	#$E,d7
	bne.w	L85EC
	move.w	#$FFFA,d0
	bra.w	L8622
L85EC	cmpi.w	#$A,d7
	bne.w	L8600
	dc.w	$0C79,$0004,$0001,$8BFA
	beq.w	L861E
L8600	cmpi.w	#$E,d7
	bne.w	L8622
	dc.w	$0C79,$0004,$0001,$8BFA
	beq.w	L861E
	dc.w	$4A79,$0001,$93BA
	bpl.w	L8622
L861E	move.w	#$FFFC,d0
L8622	bsr.w	MoveMenuFrame
	bsr.w	FixModeOptions
	bra.w	Sub_234C2
L862E	moveq	#$1,d2
	btst	#$3,d1
	bne.w	L8642
	btst	#$2,d1
	beq.w	Sub_234C2
	moveq	#-1,d2
L8642	dc.w	$0C79,$0004,$0001,$8BFA
	beq.w	L8654
	dc.w	$4EB9,$0004,$0318
L8654	dc.w	$3F39,$0001,$8C00
	dc.w	$3F39,$0001,$8BFE
	bsr.w	Sub_23A8C
	move.w	(sp)+,d0
	dc.w	$0C79,$0004,$0001,$8BFA
	beq.w	L867C
	dc.w	$4A79,$0001,$8BFA
	bne.w	L8690
L867C	dc.w	$33F9,$0001,$8BFE,$0001,$7FAE
	dc.w	$33F9,$0001,$8C00,$0001,$7FB0
L8690	dc.w	$33F9,$0001,$7FAE,$0001,$938A
	btst	#$6,$19390.l
	beq.w	L86BE
	movem.w	d0,-(sp)
	dc.w	$3039,$0001,$938C
	cmp.w	(HomeTeam).l,d0
	movem.w	(sp)+,d0
	beq.w	L86CC
L86BE	dc.w	$33F9,$0001,$7FAE,$0001,$938C
	bsr.w	DrawHomeBlock
L86CC	btst	#$7,$19390.l
	beq.w	L86F0
	movem.w	d0,-(sp)
	dc.w	$3039,$0001,$938E
	cmp.w	(VisTeam).l,d0
	movem.w	(sp)+,d0
	beq.w	L8712
L86F0	dc.w	$33F9,$0001,$7FB0,$0001,$938E
	dc.w	$33F9,$0001,$7FB0,$0001,$938A
	bsr.w	DrawVisBlock
	dc.w	$33F9,$0001,$7FAE,$0001,$938A
L8712	tst.w	(sp)+
	bra.w	Sub_2378E
	dc.w	$301F,$B079,$0001,$7FB0,$6700,$006C,$33F9,$0001
	dc.w	$7FB0,$0001,$938A,$48A7,$8000,$3039,$0001,$7FB0
	dc.w	$B079,$0001,$7FB0,$4C9F,$0001,$6700,$0010,$33F9
	dc.w	$0001,$7FB0,$0001,$938E,$6100,$1274,$48A7,$8000
	dc.w	$3039,$0001,$938C,$B079,$0001,$7FAE,$4C9F,$0001
	dc.w	$6700,$0024,$33F9,$0001,$7FAE,$0001,$938C,$33F9
	dc.w	$0001,$7FAE,$0001,$938A,$6100,$11E0,$33F9,$0001
	dc.w	$7FB0,$0001,$938A
Sub_2378E
	bsr.w	FixModeOptions
	bra.w	Sub_234C2
	dc.w	$4E75
Sub_23798
	jmp	$401C4.l
Sub_2379E
	jmp	$40132.l
MoveMenuFrame
	move.w	d7,d3
L87A6	bclr	#$2,$17F74.l
	tst.w	d0
	bpl.w	L87EA
	move.w	d0,-(sp)
	move.w	d7,d0
	asr.w	#$1,d0
	dc.w	$B079,$0001,$9384
	bne.w	L87E8
	dc.w	$33F9,$0001,$9384,$0001,$9386
	bset	#$2,$17F74.l
	dc.w	$0479,$0001,$0001,$9384
	bpl.w	L87E8
	dc.w	$4279,$0001,$9384
L87E8	move.w	(sp)+,d0
L87EA	dc.w	$33C7,$0001,$7E62
	add.w	d0,d7
	bpl.w	L87F8
	clr.w	d7
L87F8	tst.w	d0
	bmi.w	L8860
	move.w	d0,-(sp)
	move.w	d7,d0
	asr.w	#$1,d0
	dc.w	$9079,$0001,$9384
	cmpi.w	#$5,d0
	bgt.w	L8816
	bra.w	L885E
L8816	dc.w	$33F9,$0001,$9384,$0001,$9386
	bset	#$2,$17F74.l
	dc.w	$0679,$0001,$0001,$9384
	move.w	d7,d0
	asr.w	#$1,d0
	dc.w	$9079,$0001,$9384
	cmpi.w	#$5,d0
	ble.w	L884A
	dc.w	$0679,$0001,$0001,$9384
L884A	dc.w	$0C79,$0003,$0001,$9384
	ble.w	L885E
	dc.w	$33FC,$0003,$0001,$9384
L885E	move.w	(sp)+,d0
L8860	btst	#$2,$17F74.l
	bne.w	L8876
	dc.w	$33F9,$0001,$9384,$0001,$9386
L8876	cmpi.w	#$12,d7
	blt.w	L8880
	sub.w	d0,d7
L8880	dc.w	$0C79,$0001,$0001,$8BFA
	bne.w	L889A
	tst.w	d7
	beq.w	L889A
	cmpi.w	#$6,d7
	bls.w	L87A6
L889A	dc.w	$0C79,$0002,$0001,$8BFA
	blt.w	L88BA
	dc.w	$0C79,$0004,$0001,$8BFA
	beq.w	L88BA
	cmpi.w	#$6,d7
	beq.w	L87A6
L88BA	bsr.w	L891E
	movem.l	d0-d7/a0-a6,-(sp)
	dc.w	$3839,$0001,$9388
	movea.l	$47D74.l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	move.w	(printx).l,d0
	subi.w	#$1,d0
	move.w	d1,d3
	move.w	(printy).l,d1
	subi.w	#$E,d1
	moveq	#$17,d2
	moveq	#$0,d5
	bset	#$0,(sflags6).l
	dc.w	$4EB9,$0003,$87E2
	bclr	#$0,(sflags6).l
	movem.l	(sp)+,d0-d7/a0-a6
	move.w	d7,d3
	bsr.w	L8984
	move.w	#$6000,(printa).l
	dc.w	$4EF9,$0003,$8CA0
L891E	jsr	(printz).l
	String	CC_Font1,$10,$E
	move.w	#$17,d0
	move.w	#$D,d1
	rts
SetFrameRectUnused
	add.w	d3,(printy).l
	dc.w	$3039,$0001,$9386
	add.w	d0,d0
	sub.w	d0,(printy).l
	cmpi.w	#$18,(printy).l
	ble.w	L895C
	move.w	#$18,(printy).l
L895C	moveq	#$17,d0
	moveq	#$3,d1
	dc.w	$0C79,$0002,$0001,$8BFA
	blt.w	Sub_239CA
	dc.w	$0C79,$0004,$0001,$8BFA
	beq.w	Sub_239CA
	cmpi.w	#$4,d3
	bne.w	Sub_239CA
	moveq	#$5,d1
	rts
L8984	jsr	(printz).l
	String	CC_Font1,$10,$E
	add.w	d3,(printy).l
	dc.w	$3039,$0001,$9384
	add.w	d0,d0
	sub.w	d0,(printy).l
	moveq	#$17,d0
	moveq	#$3,d1
	dc.w	$0C79,$0002,$0001,$8BFA
	blt.w	Sub_239CA
	dc.w	$0C79,$0004,$0001,$8BFA
	beq.w	Sub_239CA
	cmpi.w	#$4,d3
	bne.w	Sub_239CA
	moveq	#$5,d1
Sub_239CA
	rts
FixModeOptions
	movem.l	d0-d7/a0-a6,-(sp)
	dc.w	$0C79,$0004,$0001,$8BFA
	bne.w	L89E4
	dc.w	$33FC,$0001,$0001,$8C06
L89E4	tst.w	(OptNOP).l
	bne.w	L89F6
	dc.w	$33FC,$0001,$0001,$8C06
L89F6	tst.w	(OptNOP).l
	bne.w	L8A3A
	move.w	#$0,$18C04.l
	dc.w	$33FC,$0000,$0001,$8C0C
	dc.w	$33FC,$0000,$0001,$8C0E
	tst.w	(OptNOP).l
	bne.w	L8A3A
	move.w	#$1,$18C04.l
	dc.w	$33FC,$0001,$0001,$8C0C
	dc.w	$33FC,$0001,$0001,$8C0E
L8A3A	dc.w	$3039,$0001,$9384
	dc.w	$B079,$0001,$9386
	beq.w	L8A4E
	bsr.w	PrintOptionNames
L8A4E	bset	#$3,(sflags6).l
	bsr.w	Sub_23CB6
	bclr	#$3,(sflags6).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.w	$0005,$0008,$001C,$001C,$0003,$0002,$0002,$0003
	dc.w	$0003,$0005,$000C,$001C,$001C,$0003,$0002,$0002
	dc.w	$0003,$0003
Sub_23A8C
	tst.w	d7
	bne.w	L8B0C
	movem.w	d0/d2,-(sp)
	tst.w	d2
	beq.w	L8AD2
	dc.w	$3039,$0001,$8BFA
	add.w	d2,d0
	bpl.w	L8AAC
	move.w	#$4,d0
L8AAC	cmpi.w	#$4,d0
	bne.w	L8AD2
	dc.w	$33F9,$0001,$8C06,$0001,$8C10
	dc.w	$33F9,$0001,$8C08,$0001,$8C12
	dc.w	$33F9,$0001,$8C0A,$0001,$8C14
L8AD2	movem.w	(sp)+,d0/d2
	tst.w	d7
	bne.w	L8B0C
	tst.w	d2
	beq.w	L8B0C
	dc.w	$0C79,$0004,$0001,$8BFA
	bne.w	L8B0C
	dc.w	$33F9,$0001,$8C10,$0001,$8C06
	dc.w	$33F9,$0001,$8C12,$0001,$8C08
	dc.w	$33F9,$0001,$8C14,$0001,$8C0A
L8B0C	dc.w	$247C,$0001,$8BFA
	movea.l	#$23A68,a3
	dc.w	$4A79,$0001,$8BF8
	beq.w	L8B28
	movea.l	#$23A7A,a3
L8B28	clr.w	d5
	move.w	(a3,d7.w),d4
	move.w	(a2,d7.w),d3
	dc.w	$0C79,$0002,$0001,$8BFA
	blt.w	L8B54
	dc.w	$0C79,$0004,$0001,$8BFA
	beq.w	L8B54
	cmpi.w	#$4,d7
	bne.w	L8B54
	moveq	#$1A,d4
L8B54	cmpi.w	#$2,d7
	bne.w	L8C00
	dc.w	$0C79,$0004,$0001,$8BFA
	bne.w	L8BC4
	movem.w	d2,-(sp)
	add.w	(OptNOP).l,d2
	bpl.w	L8B7A
	addi.w	#$7,d2
L8B7A	cmpi.w	#$4,d2
	movem.w	(sp)+,d2
	ble.w	L8B9C
	tst.w	d2
	bpl.w	L8B94
	move.w	#$4,d2
	bra.w	L8BC4
L8B94	addi.w	#$2,d2
	bra.w	L8BC4
L8B9C	movem.w	d2,-(sp)
	add.w	(OptNOP).l,d2
	cmpi.w	#$3,d2
	movem.w	(sp)+,d2
	bne.w	L8BC4
	tst.w	d2
	bpl.w	L8BC0
	subi.w	#$1,d2
	bra.w	L8BC4
L8BC0	addi.w	#$1,d2
L8BC4	moveq	#$5,d5
	dc.w	$4A79,$0001,$8BF8
	beq.w	L8BD8
	move.w	#$A,d4
	addi.w	#$2,d5
L8BD8	dc.w	$0C79,$0004,$0001,$8BFA
	beq.w	L8BEE
	dc.w	$4A79,$0001,$8BFA
	bne.w	L8BF2
L8BEE	clr.w	d5
	moveq	#$5,d4
L8BF2	dc.w	$4A79,$0001,$8BF8
	beq.w	L8C00
	addi.w	#$2,d4
L8C00	bsr.w	WrapOption
	dc.w	$4A79,$0001,$8BF8
	beq.w	L8C44
	cmpi.w	#$2,d7
	bne.w	L8C44
	tst.w	d2
	bmi.w	L8C30
	cmpi.w	#$9,d3
	beq.w	L8C40
	cmpi.w	#$A,d3
	beq.w	L8C40
	bra.w	L8C44
L8C30	cmpi.w	#$A,d3
	bne.w	L8C44
	move.w	#$8,d3
	bra.w	L8C44
L8C40	move.w	#$B,d3
L8C44	move.w	d3,(a2,d7.w)
	tst.w	d2
	beq.w	Sub_239CA
	dc.w	$0C79,$0001,$0001,$8BFA
	bne.w	L8C78
	tst.w	d7
	bne.w	L8C78
	jsr	$40132.l
	dc.w	$3039,$0001,$8A9E
	dc.w	$8079,$0001,$8A9C
	beq.w	L8BF2
	rts
L8C78	dc.w	$0C79,$0002,$0001,$8BFA
	blt.w	Sub_239CA
	dc.w	$0C79,$0004,$0001,$8BFA
	beq.w	Sub_239CA
	tst.w	d7
	beq.w	Sub_23798
	cmpi.w	#$4,d7
	beq.w	Sub_23798
	rts
WrapOption
	add.w	d2,d3
	cmp.w	d5,d3
	bge.w	L8CAC
	move.w	d4,d3
	subq.w	#$1,d3
L8CAC	cmp.w	d4,d3
	blt.w	Sub_239CA
	move.w	d5,d3
	rts
Sub_23CB6
	move.w	d7,d6
	move.l	#$FFFFFFFE,d7
L8CBE	addi.w	#$2,d7
	clr.w	d2
	bsr.w	Sub_23A8C
	movem.l	d7,-(sp)
	asr.w	#$1,d7
	dc.w	$BE79,$0001,$9384
	movem.l	(sp)+,d7
	blt.w	L8CE0
	bsr.w	PrintOptionValue
L8CE0	cmpi.w	#$10,d7
	bne.w	L8CBE
	bsr.w	PrintScrollMarks
	move.w	d6,d7
	dc.w	$4EB9,$0003,$FF4C
	btst	#$0,$19390.l
	bne.w	L8D06
	dc.w	$4EB9,$0002,$4B5E
L8D06	rts
PrintOptionValue
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1Pri,$11,$10
	dc.w	$3039,$0001,$9384
	add.w	d0,d0
	sub.w	d0,(printy).l
	add.w	d7,(printy).l
	cmpi.w	#$1B,(printy).l
	bgt.w	Sub_239CA
	subi.w	#$1,(printy).l
	move.w	#$11,(printx).l
	cmpi.w	#$4,d7
	beq.w	PrintOptTeamName
	cmpi.w	#$6,d7
	beq.w	PrintOptTeamName
	dc.w	$207C,$0001,$8BFA
	move.w	(a0,d7.w),d3
	dc.w	$207C,$0002,$3ECC
	adda.w	(a0,d7.w),a0
	cmpa.l	#$24104,a0
	bne.w	L8D8A
	dc.w	$0C79,$0004,$0001,$8BFA
	bne.w	L8D8A
	movea.l	#$23EB6,a1
	dc.w	$4EF9,$0003,$8F80
L8D8A	dc.w	$4A79,$0001,$8BF8
	beq.w	L8DA0
	cmpi.w	#$2,d7
	bne.w	L8DA0
	adda.w	#$B0,a0
L8DA0	movea.l	a0,a1
	adda.w	(a0),a0
	dbra	d3,L8DA0
	dc.w	$4EF9,$0003,$8F80
PrintScrollMarks
	move.w	#$19,(printy).l
	movea.l	#$23E1C,a1
	dc.w	$0C79,$0003,$0001,$9384
	beq.w	L8DDA
	dc.w	$0C79,$0004,$0001,$8BFA
	beq.w	L8DDA
	movea.l	#$23E18,a1
L8DDA	move.w	#$2,(printx).l
	dc.w	$4EB9,$0003,$8F80
	movea.l	#$23E1C,a1
	move.w	#$F,(printy).l
	dc.w	$4A79,$0001,$9384
	beq.w	L8E06
	movea.l	#$23E14,a1
L8E06	move.w	#$2,(printx).l
	dc.w	$4EF9,$0003,$8F80
	dc.w	$0004,$7B00,$0004,$7D00,$0004,$2000
PrintOptTeamName
	move.w	(printx).l,-(sp)
	movea.l	#$23EA0,a1
	dc.w	$4EB9,$0003,$8F80
	move.w	(sp)+,(printx).l
	dc.w	$227C,$0001,$8BFA
	move.w	(a1,d7.w),d3
	movea.l	#TeamList,a1
	asl.w	#$2,d3
	movea.l	(a1,d3.w),a1
	lsr.w	#$2,d3
	adda.w	$4(a1),a1
	cmpi.w	#$E,d3
	bne.w	L8E66
	movea.l	#$23E8E,a1
	bra.w	L8E74
L8E66	cmpi.w	#$D,d3
	bne.w	L8E74
	movea.l	#$23E7A,a1
L8E74	jmp	(print).l
	dc.w	$0014,$4E65,$7720,$596F,$726B,$2049,$736C,$616E
	dc.w	$6465,$7273,$0012,$4E65,$7720,$596F,$726B,$2052
	dc.w	$616E,$6765,$7273,$0016,$2020,$2020,$2020,$2020
	dc.w	$2020,$2020,$2020,$2020,$2020,$2020,$0016,$4E2F
	dc.w	$4120,$2020,$2020,$2020,$2020,$2020,$2020,$2020
	dc.w	$2020
OptionValueOffsets
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_08ECC.bin
PrintOptionNames
	movem.l	d0-d1,-(sp)
	bset	#$3,(sflags6).l
	movea.l	#$242B4,a1
	move.w	#$F,d0
	dc.w	$3239,$0001,$9384
	add.w	d1,d1
	sub.w	d1,d0
	move.w	d0,(printy).l
L925E	cmpi.w	#$F,(printy).l
	bge.w	L9270
	adda.w	(a1),a1
	bra.w	L929A
L9270	cmpi.w	#$19,(printy).l
	bgt.w	L92A6
	move.w	#$3,(printx).l
	move.w	#$0,(printa).l
	dc.w	$33FC,$0000,$0001,$8D5E
	dc.w	$4EB9,$0003,$8D9E
L929A	addi.w	#$2,(printy).l
	bra.w	L925E
L92A6	bclr	#$3,(sflags6).l
	movem.l	(sp)+,d0-d1
	rts
	dc.w	$0010,$506C,$6179,$204D,$6F64,$6520,$2020,$2000
	dc.w	$0010,$506C,$6179,$6572,$7320,$2020,$2020,$2000
	dc.w	$0010,$5465,$616D,$2031,$2020,$2020,$2020,$2000
	dc.w	$0010,$5465,$616D,$2032,$2020,$2020,$2020,$2000
	dc.w	$0010,$5065,$722E,$204C,$656E,$6774,$6820,$2000
	dc.w	$0010,$476F,$616C,$6965,$7320,$2020,$2020,$2000
	dc.w	$0010,$5573,$6572,$2052,$6563,$6F72,$6473,$2000
	dc.w	$0010,$5065,$6E61,$6C74,$6965,$7320,$2020,$2000
	dc.w	$0010,$4C69,$6E65,$2043,$6861,$6E67,$6573,$2000
	dc.w	$0004,$0000
