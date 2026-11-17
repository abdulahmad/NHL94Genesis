UpdateRecords						;With save RAM (ValidSRAM) and user records on (OptUserRec 0), update the
	
	
	
UpdateRecordsTbl1	dc.w	$0004,$2000
	tst.w	$193BA.l
	bmi.w	.ex
	tst.w	$18C06.l
	bne.w	.ex
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	.next17
	bsr.w	.next18
	move.w	(HomeTeam).l,d1
	ext.l	d1
	movea.l	#ThreeStars,a0
	movea.l	#tmstruct,a2
	move.w	$193AA.l,d5
	move.w	(VisTeam).l,d6
	bsr.w	.next12
	move.w	(VisTeam).l,d1
	ext.l	d1
	movea.l	#awtmstruct,a2
	move.w	$193AC.l,d5
	move.w	(HomeTeam).l,d6
	bsr.w	.next12
	clr.w	d7
	movea.l	#tmstruct,a1
	move.w	$18BF4.l,d4
	move.w	$18BF6.l,d5
	move.w	(HomeTeam).l,d1
	move.w	(VisTeam).l,d2
	move.w	$193AA.l,d6
	ext.l	d1
	movea.l	#ThreeStars,a0
	bsr.w	.next6
	movea.l	#awtmstruct,a1
	move.w	$18BF6.l,d4
	move.w	$18BF4.l,d5
	move.w	(VisTeam).l,d1
	move.w	(HomeTeam).l,d2
	move.w	$193AC.l,d6
	ext.l	d1
	movea.l	#ThreeStars,a0
	bsr.w	.next6
	movea.l	#ThreeStars,a0
	move.w	$18BF4.l,d1
	ext.l	d1
	move.w	$18BF6.l,d2
	move.w	(HomeTeam).l,d3
	move.w	(VisTeam).l,d4
	movea.l	#tmstruct,a1
	movea.l	#awtmstruct,a2
	bsr.w	.next
	movea.l	#ThreeStars,a0
	move.w	$18BF6.l,d1
	ext.l	d1
	move.w	$18BF4.l,d2
	move.w	(VisTeam).l,d3
	move.w	(HomeTeam).l,d4
	movea.l	#awtmstruct,a1
	movea.l	#tmstruct,a2
	bsr.w	.next
	movem.l	(sp)+,d0-d7/a0-a6
.ex	rts
.next	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	ReadCrowdRecordBClearFlag6
	st.b	d7
	movem.w	d0,-(sp)
	clr.w	d0
	move.b	$A(a0),d0
	lsl.w	#$8,d0
	move.b	$B(a0),d0
	cmpi.w	#$2328,d0
	bge.w	.next3
	addi.w	#$1,d0
	move.b	d0,$B(a0)
	lsr.w	#$8,d0
	move.b	d0,$A(a0)
	move.w	$C(a1),d0
	cmp.w	$C(a2),d0
	bgt.w	.next2
	blt.w	.next3
	clr.w	d0
	move.b	$C(a0),d0
	lsl.w	#$8,d0
	move.b	$D(a0),d0
	addi.w	#$1,d0
	move.b	d0,$D(a0)
	lsr.w	#$8,d0
	move.b	d0,$C(a0)
	bra.w	.next3
.next2	clr.w	d0
	move.b	$8(a0),d0
	lsl.w	#$8,d0
	move.b	$9(a0),d0
	addi.w	#$1,d0
	move.b	d0,$9(a0)
	lsr.w	#$8,d0
	move.b	d0,$8(a0)
.next3	movem.w	(sp)+,d0
	movem.w	d0,-(sp)
	move.w	$C(a1),d0
	cmp.w	$C(a2),d0
	movem.w	(sp)+,d0
	ble.w	.next5
	move.w	$C(a1),d5
	cmp.b	$0(a0),d5
	ble.w	.next4
	st.b	d7
	move.b	d5,$0(a0)
	move.b	d3,$1(a0)
	move.b	d4,$2(a0)
	move.b	d2,$3(a0)
.next4	move.w	$C(a2),d5
	move.w	$0(a2),d6
	sub.w	d5,d6
	cmp.b	$4(a0),d6
	ble.w	.next5
	st.b	d7
	move.b	d6,$4(a0)
	move.b	d3,$5(a0)
	move.b	d4,$6(a0)
	move.b	d2,$7(a0)
.next5	bsr.w	ReadCrowdRecordBSetFlag6
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.next6	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	ReadCrowdRecord
	move.w	$C(a1),d3
	cmp.b	$0(a0),d3
	ble.w	.next7
	move.b	d3,$0(a0)
	move.b	d4,$1(a0)
	move.b	d5,$3(a0)
	move.b	d2,$2(a0)
	st.b	d7
.next7	subi.w	#$1,d6
	clr.w	d3
.loop	move.w	d6,d0
	addi.w	#$EA,d0
	move.b	(a1,d0.w),$17E62.l
	addi.w	#$FFCC,d0
	move.b	(a1,d0.w),d0
	sub.b	d0,$17E62.l
	cmp.b	$17E62.l,d3
	bge.w	.next8
	move.b	$17E62.l,d3
.next8	dbra	d6,.loop
	cmp.b	$4(a0),d3
	ble.w	.next9
	st.b	d7
	move.b	d3,$4(a0)
	move.b	d4,$5(a0)
	move.b	d5,$7(a0)
	move.b	d2,$6(a0)
.next9	cmp.w	(HomeTeam).l,d1
	bne.w	.next10
	move.b	$8(a0),d3
	andi.w	#$FF,d3
	cmp.w	$17F92.l,d3
	bge.w	.next10
	move.w	$17F92.l,d3
	st.b	d7
	move.b	d3,$8(a0)
	move.b	d4,$9(a0)
	move.b	d5,$B(a0)
	move.b	d2,$A(a0)
.next10	tst.w	d7
	beq.w	.next11
	bsr.w	ReadCrowdRecordASetFlag6
.next11	movem.l	(sp)+,d0-d7/a0-a6
	rts
.next12	clr.l	d0
	move.w	#$19,d2
.loop2	bsr.w	SPAlistClearFlag6
	cmp.w	d5,d0
	blt.w	.next13
	move.w	d0,-(sp)
	addi.w	#$B6,d0
	move.b	(a2,d0.w),d4
	move.w	(sp)+,d0
	bra.w	.next14
.next13	move.w	d0,-(sp)
	addi.w	#$EA,d0
	move.b	(a2,d0.w),d4
	addi.w	#$FFCC,d0
	sub.b	(a2,d0.w),d4
	move.w	(sp)+,d0
.next14	move.b	$0(a0),d3
	cmp.b	d3,d4
	ble.w	.next16
	move.b	d4,$0(a0)
	move.b	$18BF5.l,$1(a0)
	move.b	$18BF7.l,$3(a0)
	cmpa.l	#$1834C,a2
	beq.w	.next15
	move.b	$18BF7.l,$1(a0)
	move.b	$18BF5.l,$3(a0)
.next15	move.b	d6,$2(a0)
	bsr.w	SPAlistSetFlag6
.next16	addi.w	#$1,d0
	dbra	d2,.loop2
	rts
.next17	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a2
	jsr	(GetGoalieCount).l
	move.w	d0,$193AA.l
	movea.l	#awtmstruct,a2
	jsr	(GetGoalieCount).l
	move.w	d0,$193AC.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.next18	movem.l	d0-d7/a0-a6,-(sp)
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
	dc.b	$00,$02	; ..
L25E56	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$9,d7
	jsr	$6044.w
	movea.l	#$AFF60,a0
	btst.b	#$7,$FF800E.l
	dc.w	$66F6
	move.l	#$0,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
	btst.b	#$6,$FF800E.l
	dc.w	$67F6
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
	btst.b	#$6,$FF800E.l
	dc.w	$66F6
	bclr.b	#$7,$FF800F.l
	move.l	#$3FFF,d0
	btst.b	#$7,$FF800E.l
	dc.w	$66F6
	move.w	#$16,$FF8020.l
	bset.b	#$6,$FF800F.l
	btst.b	#$6,$FF800E.l
	dc.w	$67F6
	move.l	$FF8010.l,(a0)+
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
	btst.b	#$6,$FF800E.l
	dc.w	$66F6
	bclr.b	#$7,$FF800F.l
	dc.w	$51C8,$FFB2
	move.l	#$27,d0
	btst.b	#$7,$FF800E.l
	dc.w	$66F6
	move.l	#$10,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
	btst.b	#$6,$FF800E.l
	dc.w	$67F6
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
	btst.b	#$6,$FF800E.l
	dc.w	$66F6
	bclr.b	#$7,$FF800F.l
	btst.b	#$7,$FF800E.l
	dc.w	$66F6
	move.w	#$15,$FF8020.l
	bset.b	#$6,$FF800F.l
	btst.b	#$6,$FF800E.l
	dc.w	$67F6
	move.w	$FF8010.l,(a0)+
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
	btst.b	#$6,$FF800E.l
	dc.w	$66F6
	bclr.b	#$7,$FF800F.l
	dc.w	$51C8,$FFB2
	jsr	$36D0A.l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst.b	#$5,$FF800F.l
	beq.b	.lAFD2
	move.w	#$1,-(a6)
	bra.b	.lAFD6
.lAFD2	move.w	#$0,-(a6)
.lAFD6	bclr.b	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	move.w	$18BFE.l,d0
	move.w	$18C00.l,d1
	move.w	$18BF8.l,d2
	move.w	#$5,d7
	jsr	$6044.w
	jsr	$2B614.l
	jsr	$21FC8.l
	move.w	#$2,d0
	jsr	$5F22.w
	move.w	#$80,d0
	jsr	$5F22.w
	dc.w	$6500,$FFF6
	move.w	#$81,d0
	jsr	$5F22.w
	move.w	(a0),d2
	andi.w	#$FF00,d2
	cmpi.w	#$0,d2
	dc.w	$66EC
	move.w	#$5,$19364.l
	move.w	#$13,d0
	lea.l	$19364.l,a0
	jsr	$5F22.w
	jsr	$36D0A.l
	move.w	#$8000,d0
	move.w	#$0,d1
	movea.l	#$AFF60,a0
	jsr	$37762.l
	jsr	$3816C.l
	btst.b	#$7,$FF800E.l
	dc.w	$66F6
	move.w	#$27,$FF8020.l
	bset.b	#$6,$FF800F.l
	btst.b	#$6,$FF800E.l
	dc.w	$67F6
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
	btst.b	#$6,$FF800E.l
	dc.w	$66F6
	bclr.b	#$7,$FF800F.l
	movem.l	(sp)+,d0-d7/a0-a6
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.b	.lB0CA
	bset.b	#$5,$FF800F.l
	bra.b	.lB0D2
.lB0CA	bclr.b	#$5,$FF800F.l
.lB0D2	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	jmp	$2E980.l
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
	beq.w	.next
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
.next	dbra	d2,.bit
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
CalcAttribTbl1	dc.w	$0202,$0202,$0406,$0204,$0204,$0606,$0402,$0202
CalcAttribTbl2	dc.w	$0202,$0202,$0202,$0202,$0909,$0202,$0902,$0202
CalcAttribTbl3	dc.w	$0202,$0202,$0202,$0202,$0202,$0202,$0202,$0202
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
	bra.w	.next
.loop2	adda.w	(a6),a6
	adda.w	#$8,a6
.next	dbra	d6,.loop2
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
	move.l	#PickStartingGoalieTbl1,(VBint).l
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
L263EE	move.w	d4,$1A3D2.l
	movea.l	$47D10.l,a2
	addq.l	#$8,a2
	jsr	$38946.l
	dc.b	$91,$23,$45,$60,$89,$AB,$CD,$EF	; .#E`....
L2640A	move.w	d4,$18D42.l
	jsr	$393E8.l
	jsr	$38F6E.l
	dc.b	$00,$06,$FF,$00,$00,$00	; ......
L26422	moveq	#$28,d0
	moveq	#$1C,d1
	move.w	#$7FF,d2
	jsr	$38C06.l
	jsr	$3EC60.l
	jsr	$38F6E.l
	dc.b	$00,$06,$FE,$00,$00,$00	; ......
L26442	movea.l	$47D0C.l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$28,d2
	moveq	#$1C,d3
	moveq	#$D,d5
	jsr	$387E2.l
	jsr	$36F72.l
	move.w	d4,$19392.l
	addi.w	#$24,d4
	move.w	d4,$19398.l
	movea.l	$47D7C.l,a2
	addq.l	#$8,a2
	jsr	$38958.l
	move.w	d4,$18D40.l
	movea.l	$47D38.l,a2
	addq.l	#$8,a2
	jsr	$38946.l
	dc.b	$71,$23,$45,$67,$89,$AB,$CD,$EF	; q#Eg....
L264A0	jsr	$38F6E.l
	dc.b	$00,$06,$BF,$1F,$06,$00	; ......
L264AC	move.w	$17FAE.l,d0
	tst.w	$1A390.l
	beq.w	.lB4C2
	move.w	$17FB0.l,d0
.lB4C2	movea.l	#$1B00C,a1
	asl.w	#$2,d0
	movea.l	(a1,d0.w),a1
	adda.w	$4(a1),a1
	move.w	(a1),d0
	subi.w	#$2,d0
	lsr.w	#$1,d0
	sub.w	d0,$18D58.l
	jsr	$38F80.l
	jsr	$38F6E.l
	dc.b	$00,$06,$BF,$1B,$07,$00	; ......
L264F2	move.w	#$8,d0
	move.w	#$8,d1
	jsr	$38CA0.l
	jsr	$38F6E.l
	dc.b	$00,$06,$8F,$1C,$08,$00	; ......
L2650C	move.w	$17FAE.l,d3
	tst.w	$1A390.l
	beq.w	.lB522
	move.w	$17FB0.l,d3
.lB522	asl.w	#$2,d3
	movea.l	$47D8C.l,a0
	movea.l	(a0,d3.w),a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	asl.w	#$3,d3
	movea.l	#$2AF56,a0
	subi.w	#$40,d3
	adda.w	d3,a0
	adda.l	(a2)+,a1
	move.w	#$6,d3
	move.w	#$6,d2
	clr.w	d0
	clr.w	d1
	move.w	#$4,d5
	move.w	$19392.l,d4
	jsr	$387E2.l
	jsr	$38F6E.l
	dc.b	$00,$06,$BF,$02,$00,$00	; ......
L2656C	move.w	#$24,d0
	move.w	#$6,d1
	jsr	$38CA0.l
	jsr	$39258.l
	dc.b	$00,$10,$BF,$0A,$02,$4E,$41,$4D,$45,$20,$20,$45,$4E,$54,$52,$59	; .....NAME  ENTRY
L26590	bsr.w	ReadNameLog
	clr.w	$1A38E.l
	move.w	#$1,$1A38C.l
	clr.w	d0
	bsr.w	SkipOtherUserName
	movea.l	#$1A37C,a1
	bsr.w	GetLogName
	dc.w	$6100,$06AC
	jsr	$38F6E.l
	dc.b	$00,$0E,$BF,$07,$06,$4E,$61,$6D,$65,$20,$4C,$6F,$67,$00	; .....Name Log.
L265CA	move.w	#$18,$18D62.l
	bclr.b	#$2,$18D64.l
	clr.w	d4
	bsr.w	SyncLetterCursor
	bsr.w	PrintNameCursor
	bsr.w	LetterGridPos
	move.w	$18D58.l,-(sp)
	move.w	$18D5A.l,-(sp)
	jsr	$26DF0.l
	move.w	(sp)+,$18D5A.l
	addi.w	#$1,$18D5A.l
	move.w	(sp)+,$18D58.l
	addi.w	#$1,$18D58.l
	bsr.w	PrintCurLetter
	move.w	#$1,$1A566.l
	bsr.w	NameLetterGrid
	clr.w	d0
	dc.w	$6000,$01B0
	bsr.w	GetNameLength
	jsr	$38F6E.l
	dc.b	$00,$06,$BF,$05,$12,$00	; ......
L2663C	tst.w	$1A566.l
	beq.w	.lB654
	movea.l	#$1A37C,a1
	bsr.w	PrintNameField
	bsr.w	PrintNamePrompt
.lB654	bsr.w	MoveLogArrows
	move.w	$17474.l,d0
	cmp.w	$17474.l,d0
	dc.w	$6700,$FFF8
	movem.w	d1,-(sp)
	move.w	$17FA6.l,d1
	subi.w	#$1,d1
	cmp.w	$1A390.l,d1
	movem.w	(sp)+,d1
	beq.w	.lB694
	jsr	$3750E.l
	tst.w	d1
	dc.w	$6700,$FFCA
	bra.w	.lB6A0
.lB694	jsr	$374F0.l
	tst.w	d1
	dc.w	$6700,$FFBA
.lB6A0	btst	#$7,d1
	dc.w	$6600,$0200
	tst.w	$1A566.l
	bne.w	.lB6DC
	move.w	#$1,d0
	btst	#$1,d1
	bne.w	.lB726
	move.w	#$FFFF,d0
	btst	#$0,d1
	bne.w	.lB726
	btst	#$4,d1
	dc.w	$6700,$FF5C
	bsr.w	NameLetterGrid
	clr.w	d0
	bra.w	.lB726
.lB6DC	moveq	#-1,d0
	btst	#$6,d1
	dc.w	$6600,$00F6
	neg.w	d0
	btst	#$5,d1
	dc.w	$6600,$00EC
	btst	#$3,d1
	dc.w	$6600,$0112
	neg.w	d0
	btst	#$2,d1
	dc.w	$6600,$0108
	moveq	#$6,d0
	btst	#$1,d1
	dc.w	$6600,$00FE
	neg.w	d0
	btst	#$0,d1
	dc.w	$6600,$00F4
	btst	#$4,d1
	dc.w	$6700,$FF10
	bsr.w	NameLetterGrid
	dc.w	$6000,$FF08
.lB726	add.w	d0,$1A38C.l
	cmpi.w	#$7,$1A38C.l
	ble.w	.lB740
	move.w	#$1,$1A38C.l
.lB740	tst.w	$1A38C.l
	bne.w	.lB752
	move.w	#$7,$1A38C.l
.lB752	bsr.w	SkipOtherUserName
	dc.w	$6700,$FFD4
	movea.l	#$1A37C,a1
	bsr.w	GetLogName
	tst.w	$1A566.l
	bne.w	.lB778
	jsr	$26A4A.l
	dc.w	$6000,$FEB6
.lB778	jsr	$38F6E.l
	dc.b	$00,$06,$BF,$04,$13,$00	; ......
L26784	add.w	d4,$18D58.l
	jsr	$38F6E.l
	dc.b	$00,$06,$20,$20,$20,$00	; ..   .
L26796	bsr.w	LetterGridPos
	moveq	#$1,d2
	move.w	$18D58.l,-(sp)
	move.w	$18D5A.l,-(sp)
	jsr	$38C06.l
	move.w	(sp)+,$18D5A.l
	addi.w	#$1,$18D5A.l
	move.w	(sp)+,$18D58.l
	addi.w	#$1,$18D58.l
	bsr.w	PrintCurLetter
	bsr.w	SyncLetterCursor
	move.w	d4,d0
	neg.w	d0
	bra.w	.lB7DA
.lB7DA	add.w	d4,d0
	cmpi.w	#$B,d0
	dc.w	$6200,$FE4A
	move.w	d0,d4
	bsr.w	PrintNameCursor
	movea.l	#$1A37C,a0
	clr.w	d0
	cmpi.b	#$2D,(a0,d4.w)
	beq.w	.lB808
	move.b	(a0,d4.w),d0
	ext.w	d0
	bsr.w	FindLetter
	sub.w	d5,d0
.lB808	add.w	d5,d0
	cmpi.w	#$1D,d0
	dc.w	$6200,$FE1C
	move.w	d0,-(sp)
	bsr.w	LetterGridPos
	moveq	#$1,d2
	move.w	$18D58.l,-(sp)
	move.w	$18D5A.l,-(sp)
	jsr	$38C06.l
	move.w	(sp)+,$18D5A.l
	addi.w	#$1,$18D5A.l
	move.w	(sp)+,$18D58.l
	addi.w	#$1,$18D58.l
	bsr.w	PrintCurLetter
	move.w	(sp)+,d5
	bsr.w	LetterGridPos
	move.w	$18D58.l,-(sp)
	move.w	$18D5A.l,-(sp)
	tst.w	$1A566.l
	beq.w	.lB86E
	jsr	$26DF0.l
.lB86E	move.w	(sp)+,$18D5A.l
	addi.w	#$1,$18D5A.l
	move.w	(sp)+,$18D58.l
	addi.w	#$1,$18D58.l
	bsr.w	PrintCurLetter
	movea.l	#$1A37C,a0
	movea.l	#$26DD0,a1
	move.b	(a1,d5.w),d0
	move.b	d0,(a0,d4.w)
	dc.w	$6000,$FD88
	bsr.w	StoreUserName
	movem.l	(sp)+,d0-d7/a0-a6
	rts
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
	bne.w	.next
	jsr	(printz).l
	String	CC_Font1Pri,$19,$11
	movea.l	#$26DD0,a0		;print the 5 rows of 6 letters
	moveq	#$4,d0		;5 rows
.loop	moveq	#$5,d1		;6 letters
	movea.l	#mesarea,a1
	move.w	#$E,(a1)+		;String of 6 letters with spaces: 12 bytes + header
.loop2	move.b	(a0)+,(a1)+
	move.b	#$20,(a1)+
	dbra	d1,.loop2
	movea.l	#mesarea,a1
	jsr	(print).l
	addi.w	#$2,(printy).l
	subi.w	#$C,(printx).l
	dbra	d0,.loop
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
.loop3	movem.l	(sp)+,d0-d7/a0-a6
	rts
.next	movea.l	#$1A37C,a1
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
	bra.w	.loop3
