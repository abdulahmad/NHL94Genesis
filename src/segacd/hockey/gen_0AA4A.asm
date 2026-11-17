UpdateRecords						;With save RAM (ValidSRAM) and user records on (OptUserRec 0), update the
	
	
	
	dc.w	$0004,$2000
	tst.w	$193BA.l
	bmi.w	.lAB76
	tst.w	$18C06.l
	bne.w	.lAB76
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	.lAD8C
	bsr.w	.lADBA
	move.w	(HomeTeam).l,d1
	ext.l	d1
	movea.l	#ThreeStars,a0
	movea.l	#tmstruct,a2
	move.w	$193AA.l,d5
	move.w	(VisTeam).l,d6
	bsr.w	.lAD0E
	move.w	(VisTeam).l,d1
	ext.l	d1
	movea.l	#awtmstruct,a2
	move.w	$193AC.l,d5
	move.w	(HomeTeam).l,d6
	bsr.w	.lAD0E
	clr.w	d7
	movea.l	#tmstruct,a1
	move.w	$18BF4.l,d4
	move.w	$18BF6.l,d5
	move.w	(HomeTeam).l,d1
	move.w	(VisTeam).l,d2
	move.w	$193AA.l,d6
	ext.l	d1
	movea.l	#ThreeStars,a0
	bsr.w	.lAC54
	movea.l	#awtmstruct,a1
	move.w	$18BF6.l,d4
	move.w	$18BF4.l,d5
	move.w	(VisTeam).l,d1
	move.w	(HomeTeam).l,d2
	move.w	$193AC.l,d6
	ext.l	d1
	movea.l	#ThreeStars,a0
	bsr.w	.lAC54
	movea.l	#ThreeStars,a0
	move.w	$18BF4.l,d1
	ext.l	d1
	move.w	$18BF6.l,d2
	move.w	(HomeTeam).l,d3
	move.w	(VisTeam).l,d4
	movea.l	#tmstruct,a1
	movea.l	#awtmstruct,a2
	bsr.w	.lAB78
	movea.l	#ThreeStars,a0
	move.w	$18BF6.l,d1
	ext.l	d1
	move.w	$18BF4.l,d2
	move.w	(VisTeam).l,d3
	move.w	(HomeTeam).l,d4
	movea.l	#awtmstruct,a1
	movea.l	#tmstruct,a2
	bsr.w	.lAB78
	movem.l	(sp)+,d0-d7/a0-a6
.lAB76	rts
.lAB78	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	Sub_225D8
	st.b	d7
	movem.w	d0,-(sp)
	clr.w	d0
	move.b	$A(a0),d0
	lsl.w	#$8,d0
	move.b	$B(a0),d0
	cmpi.w	#$2328,d0
	bge.w	.lABF0
	addi.w	#$1,d0
	move.b	d0,$B(a0)
	lsr.w	#$8,d0
	move.b	d0,$A(a0)
	move.w	$C(a1),d0
	cmp.w	$C(a2),d0
	bgt.w	.lABD6
	blt.w	.lABF0
	clr.w	d0
	move.b	$C(a0),d0
	lsl.w	#$8,d0
	move.b	$D(a0),d0
	addi.w	#$1,d0
	move.b	d0,$D(a0)
	lsr.w	#$8,d0
	move.b	d0,$C(a0)
	bra.w	.lABF0
.lABD6	clr.w	d0
	move.b	$8(a0),d0
	lsl.w	#$8,d0
	move.b	$9(a0),d0
	addi.w	#$1,d0
	move.b	d0,$9(a0)
	lsr.w	#$8,d0
	move.b	d0,$8(a0)
.lABF0	movem.w	(sp)+,d0
	movem.w	d0,-(sp)
	move.w	$C(a1),d0
	cmp.w	$C(a2),d0
	movem.w	(sp)+,d0
	ble.w	.lAC4A
	move.w	$C(a1),d5
	cmp.b	$0(a0),d5
	ble.w	.lAC26
	st.b	d7
	move.b	d5,$0(a0)
	move.b	d3,$1(a0)
	move.b	d4,$2(a0)
	move.b	d2,$3(a0)
.lAC26	move.w	$C(a2),d5
	move.w	$0(a2),d6
	sub.w	d5,d6
	cmp.b	$4(a0),d6
	ble.w	.lAC4A
	st.b	d7
	move.b	d6,$4(a0)
	move.b	d3,$5(a0)
	move.b	d4,$6(a0)
	move.b	d2,$7(a0)
.lAC4A	bsr.w	Sub_22616
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.lAC54	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	ReadCrowdRecord
	move.w	$C(a1),d3
	cmp.b	$0(a0),d3
	ble.w	.lAC7A
	move.b	d3,$0(a0)
	move.b	d4,$1(a0)
	move.b	d5,$3(a0)
	move.b	d2,$2(a0)
	st.b	d7
.lAC7A	subi.w	#$1,d6
	clr.w	d3
.lAC80	move.w	d6,d0
	addi.w	#$EA,d0
	move.b	(a1,d0.w),$17E62.l
	addi.w	#$FFCC,d0
	move.b	(a1,d0.w),d0
	sub.b	d0,$17E62.l
	cmp.b	$17E62.l,d3
	bge.w	.lACAC
	move.b	$17E62.l,d3
.lACAC	dbra	d6,.lAC80
	cmp.b	$4(a0),d3
	ble.w	.lACCA
	st.b	d7
	move.b	d3,$4(a0)
	move.b	d4,$5(a0)
	move.b	d5,$7(a0)
	move.b	d2,$6(a0)
.lACCA	cmp.w	(HomeTeam).l,d1
	bne.w	.lACFE
	move.b	$8(a0),d3
	andi.w	#$FF,d3
	cmp.w	$17F92.l,d3
	bge.w	.lACFE
	move.w	$17F92.l,d3
	st.b	d7
	move.b	d3,$8(a0)
	move.b	d4,$9(a0)
	move.b	d5,$B(a0)
	move.b	d2,$A(a0)
.lACFE	tst.w	d7
	beq.w	.lAD08
	bsr.w	Sub_225CC
.lAD08	movem.l	(sp)+,d0-d7/a0-a6
	rts
.lAD0E	clr.l	d0
	move.w	#$19,d2
.lAD14	bsr.w	Sub_22534
	cmp.w	d5,d0
	blt.w	.lAD2E
	move.w	d0,-(sp)
	addi.w	#$B6,d0
	move.b	(a2,d0.w),d4
	move.w	(sp)+,d0
	bra.w	.lAD42
.lAD2E	move.w	d0,-(sp)
	addi.w	#$EA,d0
	move.b	(a2,d0.w),d4
	addi.w	#$FFCC,d0
	sub.b	(a2,d0.w),d4
	move.w	(sp)+,d0
.lAD42	move.b	$0(a0),d3
	cmp.b	d3,d4
	ble.w	.lAD82
	move.b	d4,$0(a0)
	move.b	$18BF5.l,$1(a0)
	move.b	$18BF7.l,$3(a0)
	cmpa.l	#$1834C,a2
	beq.w	.lAD7A
	move.b	$18BF7.l,$1(a0)
	move.b	$18BF5.l,$3(a0)
.lAD7A	move.b	d6,$2(a0)
	bsr.w	Sub_22582
.lAD82	addi.w	#$1,d0
	dbra	d2,.lAD14
	rts
.lAD8C	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a2
	jsr	(GetGoalieCount).l
	move.w	d0,$193AA.l
	movea.l	#awtmstruct,a2
	jsr	(GetGoalieCount).l
	move.w	d0,$193AC.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.lADBA	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a2
	jsr	(GetPlayerCount).l
	move.w	d0,$193AE.l
	movea.l	#awtmstruct,a2
	jsr	(GetPlayerCount).l
	move.w	d0,$193B0.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
AppendUserName						;Append user name d2 (12 bytes of the name log at namelog, spaces for 0)
	
	movem.l	d0-d3/a0-a3,-(sp)
	movea.l	a1,a2
	tst.w	d2
	beq.w	.2
	move.w	#$B,d0
	clr.w	d3
	movea.l	#$1A2FC,a0
	mulu.w	#$C,d2
	adda.l	d2,a0
.loop	move.b	(a0,d3.w),d1
	bne.w	.0
	move.b	#$20,d1
.0	move.b	d1,$2(a1)
	tst.b	(a1)+
	addi.w	#$1,d3
	dbra	d0,.loop
	move.w	#$E,(a2)
	btst	#$7,(sflags6).l
	beq.w	.1
	bsr.w	TrimSpaces
.1	bra.w	.x
.2	movea.l	a1,a3
	move.l	a3,-(sp)
	movea.l	#$25E54,a1
	jsr	(CopyString).l
	movea.l	(sp)+,a2
	bsr.w	TrimSpaces
.x	movem.l	(sp)+,d0-d3/a0-a3
	rts
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_0AE54.bin
AppendTeamName						;Append the city name of team d0 (TeamList block Strings) to a1
	
	movem.l	d0/a0-a3,-(sp)
	ext.w	d0
	asl.w	#$2,d0
	movea.l	#TeamList,a0
	movea.l	(a0,d0.w),a0
	move.w	$4(a0),d0
	ext.l	d0
	adda.l	d0,a0
	adda.w	(a0),a0
	movea.l	a1,a3
	movea.l	a0,a1
	jsr	(appstring).l
	movem.l	(sp)+,d0/a0-a3
	rts
CalcAttrib						;The overall rating of player d0: his attributes weighted by
	
	
	
	move.l	a6,-(sp)
	clr.w	$1A570.l
	clr.w	$1A572.l
	movea.l	#$26266,a6
	cmp.l	(PAttribOverallMask).l,d4
	bne.w	.1
	movea.l	#$26246,a6
.1	cmp.l	(GAttribOverallMask).l,d4
	bne.w	.11
	movea.l	#$26256,a6
.11	movea.l	$1E(a2),a0
	lea.l	$1A4(a2),a4
	clr.l	d1
	move.w	d0,d1
	asl.w	#$4,d1
	adda.l	d1,a4
	adda.l	#$10,a4
	adda.w	$0(a0),a0
.skip	adda.w	(a0),a0
	adda.w	#$8,a0
	dbra	d0,.skip
	clr.w	d0
	clr.w	d1
	moveq	#$F,d2
	swap	d4
.bit	btst	d2,d4
	beq.w	.lB20A
	move.w	d2,d3
	lsr.w	#$1,d3
	neg.w	d3
	move.b	-$1(a0,d3.w),d3
	btst	#$0,d2
	beq.w	.0
	lsr.w	#$4,d3
.0	andi.w	#$F,d3
	cmpi.w	#$D,d2
	bne.w	.cont
	bra.w	.00
.cont	cmpi.w	#$6,d2
	beq.w	.00
	movem.l	d5-d7,-(sp)
	move.b	(a6,d2.w),d5
	ext.w	d5
	cmpi.w	#$2,d5
	beq.w	.000
	move.w	d3,-(sp)
	subi.w	#$2,d5
.attribadd	add.w	(sp),d3
	dbra	d5,.attribadd
	asr.w	#$1,d3
	tst.w	(sp)+
.000	movem.l	(sp)+,d5-d7
	cmpa.l	#$26266,a6
	beq.w	.2
	neg.w	d2
	move.w	d7,-(sp)
	move.b	-$1(a4,d2.w),d7
	ext.w	d7
	add.w	d7,$1A570.l
	addi.w	#$1,$1A572.l
	move.w	(sp)+,d7
	neg.w	d2
	bra.w	.00
.2	move.w	d3,-(sp)
	asl.w	#$4,d3
	add.w	(sp),d3
	add.w	(sp)+,d3
	neg.w	d2
	add.b	-$1(a4,d2.w),d3
	bpl.w	.pos
	clr.b	d3
.pos	neg.w	d2
.00	add.w	d3,d0
	addi.w	#$64,d1
.lB20A	dbra	d2,.bit
	cmpa.l	#$26266,a6
	beq.w	.3
	move.w	#$64,d1
	movem.l	d6-d7,-(sp)
	move.w	$1A570.l,d6
	ext.l	d6
	move.w	$1A572.l,d7
	divs.w	d7,d6
	add.w	d6,d0
	movem.l	(sp)+,d6-d7
.3	cmp.w	d1,d0
	blt.w	.4
	move.w	d0,d1
	subi.w	#$1,d0
.4	movea.l	(sp)+,a6
	rts
	dc.w	$0202,$0202,$0406,$0204,$0204,$0606,$0402,$0202
	dc.w	$0202,$0202,$0202,$0202,$0909,$0202,$0902,$0202
	dc.w	$0202,$0202,$0202,$0202,$0202,$0202,$0202,$0202
DrawPlayerPicture						;Draw the player picture (NoPicSkater1 ... NoPicGoalie2, Card<player>)
	movem.l	d0-d7/a1-a6,-(sp)
	movea.l	$47D88.l,a0
	move.w	d1,d2
	asl.w	#$2,d2
	movea.l	(a0,d2.w),a0
	move.w	#$FFFF,d2
	bra.w	.1
.loop	cmp.w	$4(a0),d0
	bne.w	.0
	movea.l	(a0),a0
	bra.w	.x
.0	adda.l	#$6,a0
.1	addi.w	#$1,d2
	tst.l	(a0)
	bne.w	.loop
	movea.l	#TeamList,a0
	asl.w	#$2,d1
	movea.l	(a0,d1.w),a0
	movea.l	a0,a6
	move.w	d0,d6
	adda.w	$0(a6),a6
	bra.w	.lB2CC
.loop2	adda.w	(a6),a6
	adda.w	#$8,a6
.lB2CC	dbra	d6,.loop2
	adda.w	(a6),a6
	adda.w	$A(a0),a0
	move.w	(a0),d1
	clr.w	d3
.loop3	addi.w	#$1,d3
	asl.w	#$4,d1
	bne.w	.loop3
	movea.l	#$433AA,a0
	btst	#$0,$4(a6)
	bne.w	.3
	movea.l	#$43714,a0
.3	cmp.w	d3,d0
	blt.w	.x
	movea.l	#$43040,a0
	btst	#$0,$4(a6)
	bne.w	.x
	movea.l	#$42CD6,a0
.x	movem.l	(sp)+,d0-d7/a1-a6
	rts
TrimSpaces						;Trim the trailing spaces of String a2 and pad it to an even length
	movem.l	a3,-(sp)
	movea.l	a2,a3
	adda.w	(a2),a3
.loop	move.b	-(a3),d0
	cmpi.b	#$20,d0
	bne.w	.0
	move.b	#$0,(a3)
	subi.w	#$1,(a2)
	bra.w	.loop
.0	addi.w	#$1,(a2)
	andi.w	#$FE,(a2)
	movem.l	(sp)+,a3
	rts
	movem.l	d0-d7/a0-a6,-(sp)
	bclr	#$5,$FF800F.l
	move.w	#$2,d4
	move.l	#$400D0,(VBint).l
	bclr	#$0,(disflags).l
	bset	#$2,(disflags).l
	bclr	#$1,(disflags).l
	move.w	#$0,$18D30.l
	move.w	#$B400,$18D32.l
	move.w	#$B800,$18D3C.l
	move.w	#$5,$18D3E.l
	move.w	#$C000,$18D38.l
	move.w	#$6,(Map2col).l
	move.w	#$E000,(VmMAP1).l
	move.w	#$6,(Map1col).l
	move.w	#$0,d0
	jsr	(setVram).l
	bset	#$5,$FF800F.l
	jsr	(orjoy).l
	move.w	d4,(framercset).l
	movea.l	(FramerMap).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
	dc.l	$91234567,$89ABCDEF
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_0B3EE.bin
NameLetterGrid						;Name entry: the letter grid ("D-Pad to a letter.", "C to select letter.",
									;"A to go back.")
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	CC_Font1Pri,$1,$14
	move.w	#$16,d0
	move.w	#$7,d1
	move.w	#$7FF,d2		;blank char
	jsr	(eraser).l
	bchg	#$0,$1A567.l
	bne.w	.lBA00
	jsr	(printz).l
	String	CC_Font1Pri,$19,$11
	movea.l	#$26DD0,a0		;print the 5 rows of 6 letters
	moveq	#$4,d0		;5 rows
.lB8F2	moveq	#$5,d1		;6 letters
	movea.l	#mesarea,a1
	move.w	#$E,(a1)+		;String of 6 letters with spaces: 12 bytes + header
.lB8FE	move.b	(a0)+,(a1)+
	move.b	#$20,(a1)+
	dbra	d1,.lB8FE
	movea.l	#mesarea,a1
	jsr	(print).l
	addi.w	#$2,(printy).l
	subi.w	#$C,(printx).l
	dbra	d0,.lB8F2
	jsr	(printz).l
	String	CC_Font2,$1,$14
	moveq	#$16,d0
	moveq	#$7,d1
	jsr	(Framer).l
	jsr	(printz).l
	String	CC_Font1Pri,$2,$15,'D-Pad to a letter.'
	move.w	#$2,(printx).l
	addi.w	#$1,(printy).l
	move.w	(printx).l,-(sp)
	jsr	(printz).l
	String	'C to select letter.'
	move.w	(sp),(printx).l
	addi.w	#$1,(printy).l
	jsr	(printz).l
	String	'A to go back.'
	move.w	(sp),(printx).l
	addi.w	#$1,(printy).l
	jsr	(printz).l
	String	'B to cancel.'
	move.w	(sp)+,(printx).l
	addi.w	#$1,(printy).l
	jsr	(printz).l
	String	'START when done.'
.lB9FA	movem.l	(sp)+,d0-d7/a0-a6
	rts
.lBA00	movea.l	#$1A37C,a1
	bsr.w	GetLogName		;copy the log name
	move.w	#$0,(printx).l
	move.w	#$F,(printy).l
	move.w	#$28,d0
	move.w	#$D,d1
	move.w	#$7FF,d2		;blank char
	jsr	(eraser).l
	jsr	(printz).l
	String	CC_Font2,$1,$14
	moveq	#$16,d0
	moveq	#$7,d1
	jsr	(Framer).l
	bsr.w	NameEntryHelp
	bra.w	.lB9FA
