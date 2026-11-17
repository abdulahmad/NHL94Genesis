Sub_3E6E6
	move.w	$4(a3),-(sp)
	movem.l	d0-d5/a0-a2,-(sp)
	move.w	$6(a3),d4
	bmi.w	L23868
	beq.w	L23868
	andi.w	#$F800,d4
	eor.w	d4,$4(a3)
	move.w	$6(a3),d4
	andi.w	#$7FF,d4
	movea.l	$47D24.l,a2
	adda.l	$4(a2),a2
	add.w	d4,d4
	cmp.w	$2(a2),d4
	bge.w	L23868
	move.w	$2(a2,d4.w),d5
	sub.w	(a2,d4.w),d5
	lsr.w	#$3,d5
	subi.w	#$1,d5
	adda.w	(a2,d4.w),a2
	clr.w	d3
	clr.w	d4
L23734	move.w	d0,-(sp)
	move.w	$6(a3),d0
	andi.w	#$7FF,d0
	cmp.w	$8(a3),d0
	beq.w	L237CA
	tst.w	d5
	bne.w	L23750
	move.w	d0,$8(a3)
L23750	movem.w	d0-d4,-(sp)
	move.w	$4(a2),d2
	clr.w	d4
	move.b	$7(a2),d4
	movea.l	#$41A5C,a0
	move.b	(a0,d4.w),d4
	cmp.w	$8(sp),d4
	bgt.w	L23794
	cmp.w	$4(sp),d2
	blt.w	L23794
	move.w	$4(sp),d0
	add.w	$8(sp),d0
	sub.w	d2,d0
	sub.w	d4,d0
	bmi.w	L23794
	movem.w	(sp)+,d0-d1
	adda.w	#$6,sp
	bra.w	L237C6
L23794	add.w	$8(sp),d3
	movem.w	(sp)+,d0-d1
	adda.w	#$6,sp
	movem.w	d0-d4,-(sp)
	add.w	$12(a3),d3
	ext.l	d2
	asl.l	#$5,d2
	add.l	$47D24.l,d2
	addi.l	#$A,d2
	asl.w	#$4,d4
	asl.w	#$5,d3
	move.l	d2,(a5)+
	move.w	d4,(a5)+
	move.w	d3,(a5)+
	movem.w	(sp)+,d0-d4
L237C6	move.b	d3,$A(a3,d5.w)
L237CA	move.w	(sp)+,d0
	movem.w	d0-d2,-(sp)
	move.w	$2(a2),d2
	btst	#$4,$4(a3)
	beq.w	L237F2
	move.b	$7(a2),d2
	andi.w	#$3,d2
	addi.w	#$1,d2
	asl.w	#$3,d2
	neg.w	d2
	sub.w	$2(a2),d2
L237F2	add.w	d2,d1
	move.w	d1,(a6)
	move.w	(a2),d2
	btst	#$3,$4(a3)
	beq.w	L23814
	move.b	$7(a2),d2
	andi.w	#$C,d2
	addi.w	#$4,d2
	asl.w	#$1,d2
	neg.w	d2
	sub.w	(a2),d2
L23814	add.w	d2,d0
	move.w	d0,$6(a6)
	move.b	$7(a2),$2(a6)
	move.b	d6,$3(a6)
	move.w	$6(a2),d2
	move.w	$4(a3),d0
	eor.w	d0,d2
	andi.w	#$F800,d2
	btst	#$0,$5(a3)
	beq.w	L23848
	btst	#$E,d2
	beq.w	L23848
	bset	#$D,d2
L23848	or.b	$A(a3,d5.w),d2
	add.w	$12(a3),d2
	move.w	d2,$4(a6)
	movem.w	(sp)+,d0-d2
	addi.w	#$1,d6
	adda.w	#$8,a6
	adda.w	#$8,a2
	dbra	d5,L23734
L23868	movem.l	(sp)+,d0-d5/a0-a2
	move.w	(sp)+,$4(a3)
	rts
find3d
	btst	#$7,$17F6A.l
	beq.w	L2388A
	exg.l	d0,d1
	neg.w	d0
	subi.w	#$C5,d1
	bra.w	L23896
L2388A	dc.w	$9079,$0001,$7CEE
	dc.w	$9279,$0001,$7CEA
L23896	cmpi.w	#$90,d0
	bgt.w	L238C8
	cmpi.w	#$FF70,d0
	blt.w	L238C8
	addi.w	#$100,d0
	add.w	d2,d1
	asr.w	#$1,d2
	add.w	d2,d1
	cmpi.w	#$90,d1
	bgt.w	L238C8
	cmpi.w	#$FF70,d1
	blt.w	L238C8
	neg.w	d1
	addi.w	#$F0,d1
	rts
L238C8	move.w	#$4E20,d1
	rts
updatesound
	move.w	(Crowdlevel).l,d0
	asl.w	#$3,d0
	addi.w	#$400,d0
	cmpi.w	#$EFF,d0
	bls.w	L238E6
	move.w	#$EFF,d0
L238E6	moveq	#$28,d2
	sub.w	(asv).l,d0
	cmp.w	d2,d0
	bgt.w	L238FC
	neg.w	d2
	cmp.w	d2,d0
	bge.w	L2390C
L238FC	add.w	d2,(asv).l
	bpl.w	L2390C
	clr.w	(asv).l
L2390C	move.b	(asv).l,d0
	eori.b	#$F,d0
	ori.b	#$F0,d0
	rts
	movem.l	d0-d7/a0-a6,-(sp)
	bset	#$1,(disflags).l
	dc.w	$33FC,$C000,$0001,$8D38
	move.w	#$6,(Map2col).l
	dc.w	$33FC,$DC00,$0001,$8D32
	move.w	#$E000,(VmMAP1).l
	move.w	#$6,(Map1col).l
	move.w	#$F000,$18D3C.l
	move.w	#$5,$18D3E.l
	move.w	#$FC00,$18D30.l
	moveq	#$0,d0
	bsr.w	setVram
	bclr	#$0,$17F6A.l
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	dc.w	$4279,$0001,$7CEE
	dc.w	$4279,$0001,$7CEA
	dc.w	$33FC,$07D0,$0001,$7CEC
	st.b	$17CE2.l
	move.w	#$800,d0
	move.w	(VmMAP1).l,d1
	move.w	#$7FF,d2
	bsr.w	Sub_37AA2
	clr.w	d4
	dc.w	$33C4,$0001,$8D48
	movea.l	$47D18.l,a2
	addq.l	#$8,a2
	btst	#$4,$17F72.l
	beq.w	L239D4
	movea.l	$47D64.l,a2
	addq.l	#$8,a2
L239D4	bsr.w	DecompressGraphicsPlain
	jsr	$2A9D0.l
	dc.w	$33C4,$0001,$8D50
	bsr.w	Sub_3EC78
	dc.w	$33C4,$0001,$8D46
	movea.l	$47D40.l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain
	dc.w	$33C4,$0001,$8D4A
	movea.l	$47D2C.l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain
	dc.w	$33C4,$0001,$A54E
	addi.w	#$32,d4
	move.w	d4,$18D54.l
	bsr.w	Sub_3ED9A
	move.w	d4,$18C1C.l
	bsr.w	Sub_3EC60
	bsr.w	Sub_393FA
	dc.w	$33C4,$0001,$8D42
	movea.l	(SmallFontMap).l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsWithRemap
	dc.w	$4343,$4567,$89AB,$CDEF,$33C4,$0001,$8D40,$2479
	dc.w	$0004,$7D38,$508A,$6100,$9EEE,$7123,$4567,$89AB
	dc.w	$CDEF,$6100,$029C,$33C4,$0001,$8D56,$0839,$0001
	dc.w	$0001,$7F68,$6700,$0018,$267C,$0001,$7480,$700B
	dc.w	$086B,$0007,$0062,$D6FC,$0080,$51C8,$FFF4,$6100
	dc.w	$07BC,$33FC,$FFFF,$0001,$7DC8,$33FC,$FFFF,$0001
	dc.w	$7DD6,$42B9,$0001,$7DCA,$42B9,$0001,$7DCE,$42B9
	dc.w	$0001,$7DD2,$50F9,$0001,$7F9E,$50F9,$0001,$7FA0
	dc.w	$2A7C,$0001,$8D6A,$2C7C,$000B,$BD30,$7C01,$267C
	dc.w	$0001,$7D04,$4240,$4241,$6100,$FC0C,$D6FC,$001C
	dc.w	$6100,$FC04,$D6FC,$001C,$6100,$FBFC,$D6FC,$001C
	dc.w	$6100,$FBF4,$D6FC,$001C,$6100,$FBEC,$D6FC,$001C
	dc.w	$6100,$FBE4,$23CD,$0001,$91CA,$6100,$F0E4,$33DF
	dc.w	$0001,$8D64,$23FC,$0003,$DAB8,$0001,$8D66,$08B9
	dc.w	$0000,$0001,$8D64,$08B9,$0002,$0001,$8D64,$08F9
	dc.w	$0005,$00FF,$800F,$4CDF,$7FFF,$4E75
Sub_3EB3C
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(Sub_36D0A).l
	bclr	#$0,$17F6A.l
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	dc.w	$4279,$0001,$7CEE
	dc.w	$4279,$0001,$7CEA
	dc.w	$33FC,$07D0,$0001,$7CEC
	st.b	$17CE2.l
	move.w	$18D54.l,d4
	bsr.w	Sub_3ED9A
	bsr.w	Sub_3EC60
	btst	#$1,$17F68.l
	beq.w	L23BA6
	dc.w	$267C,$0001,$7480
	moveq	#$B,d0
L23B98	bchg	#$7,$62(a3)
	adda.w	#$80,a3
	dbra	d0,L23B98
L23BA6	bsr.w	Sub_3F24C
	dc.w	$33FC,$FFFF,$0001,$7DC8
	dc.w	$33FC,$FFFF,$0001,$7DD6
	clr.l	$17DCA.l
	clr.l	$17DCE.l
	clr.l	$17DD2.l
	dc.w	$50F9,$0001,$7F9E
	dc.w	$50F9,$0001,$7FA0
	bsr.w	Sub_3EC78
	movea.l	#$18D6A,a5
	dc.w	$2C7C,$000B,$BD30
	moveq	#$1,d6
	movea.l	#$17D04,a3
	clr.w	d0
	clr.w	d1
	bsr.w	Sub_3E6E6
	adda.w	#$1C,a3
	bsr.w	Sub_3E6E6
	adda.w	#$1C,a3
	bsr.w	Sub_3E6E6
	adda.w	#$1C,a3
	bsr.w	Sub_3E6E6
	adda.w	#$1C,a3
	bsr.w	Sub_3E6E6
	adda.w	#$1C,a3
	bsr.w	Sub_3E6E6
	move.l	a5,$191CA.l
	bsr.w	Sub_3DBF0
	move.w	#$1C,(palcount).l
	move.w	(sp)+,(disflags).l
	move.l	#$3DAB8,(VBint).l
	bclr	#$0,(disflags).l
	bclr	#$2,(disflags).l
	bset	#$5,$FF800F.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
Sub_3EC60
	movea.l	$47D18.l,a0
	adda.l	(a0),a0
	moveq	#$F,d0
	movea.l	#$BBCB0,a1
L23C70	move.l	(a0)+,(a1)+
	dbra	d0,L23C70
	rts
Sub_3EC78
	dc.w	$3839,$0001,$8D50
	movea.l	$47D4C.l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsWithRemap
	dc.w	$7123,$4567,$89AB,$CDEF,$4E75,$3839,$0001,$8D46
	dc.w	$2479,$0004,$7D40,$508A,$6000,$9CB4,$3839,$0001
	dc.w	$8D4A,$2479,$0004,$7D2C,$508A,$6000,$9CA2
	dc.w	$3839,$0001,$8D56
	movea.l	$47D20.l,a2
	addq.l	#$8,a2
	bra.w	DecompressGraphicsPlain
	dc.w	$3839,$0001,$8D56,$2479,$0004,$7D1C,$508A,$6000
	dc.w	$9C7E,$3839,$0001,$8D4C,$2479,$0004,$7D30,$508A
	dc.w	$6000,$9C6C,$3839,$0001,$8D56,$2479,$0004,$7D14
	dc.w	$508A,$6000,$9C5A
setupTeamBlocksMap
	dc.w	$33C4,$0001,$8D52
	addi.w	#$2C,d4
	movea.l	#$17FB2,a1
	movea.l	$47D44.l,a0
	lea.l	$8(a0),a2
	bsr.w	DecompressGraphicsPlain
	adda.l	$4(a0),a0
	move.l	a0,-(sp)
	move.w	(HomeTeam).l,d0
	dc.w	$3239,$0001,$8D52
	asl.w	#$5,d1
	bsr.w	CopyTeamBlockMapData
	movea.l	(sp)+,a0
	move.w	(VisTeam).l,d0
	dc.w	$3239,$0001,$8D52
	addi.w	#$16,d1
	asl.w	#$5,d1
	bsr.w	CopyTeamBlockMapData
	dc.w	$3839,$0001,$8D52
	addi.w	#$2C,d4
	rts
CopyTeamBlockMapData
	mulu.w	#$2C,d0
	lea.l	$4(a0,d0.w),a0
	move.w	#$15,d3
L23D66	moveq	#$20,d0
	move.w	d1,-(sp)
	move.b	(a0),(a1)
	andi.w	#$F800,(a1)
	lsr.w	#$5,d1
	ori.w	#$8000,d1
	or.w	d1,(a1)+
	move.w	(sp)+,d1
	move.w	(a0)+,d2
	andi.w	#$7FF,d2
	dc.w	$D479,$0001,$8D52
	addi.w	#$2C,d2
	asl.w	#$5,d2
	bsr.w	DoDMA_nd2
	addi.w	#$20,d1
	dbra	d3,L23D66
	rts
Sub_3ED9A
	dc.w	$247C,$0003,$EE08
	movea.l	#$17DD8,a3
	moveq	#$3,d0
L23DA8	move.w	#$FFFF,$8(a3)
	move.w	(a2)+,$0(a3)
	move.w	(a2)+,$2(a3)
	move.w	(a2)+,$6(a3)
	move.w	(a2)+,$4(a3)
	move.w	d4,$12(a3)
	add.w	(a2)+,d4
	adda.w	#$14,a3
	dbra	d0,L23DA8
	movea.l	#$3EE30,a2
	movea.l	#$17D04,a3
	dc.w	$203C,$0000,$0006
L23DDE	st.b	$8(a3)
	move.w	(a2)+,$0(a3)
	move.w	(a2)+,$14(a3)
	move.w	(a2)+,$18(a3)
	move.w	(a2)+,$6(a3)
	move.w	(a2)+,$4(a3)
	move.w	d4,$12(a3)
	add.w	(a2)+,d4
	adda.w	#$1C,a3
	dbra	d0,L23DDE
	bra.w	Sub_3EE84
defaultsprites_0
	ori.b	#$0,d0
	ori.b	#$0,d0
	dc.w	$0009,$0000,$0000,$0000,$0000,$0009,$0000,$0000
	dc.w	$0000,$0000,$0009,$0000,$0000,$0000,$0000,$0009
	dc.w	$0000,$0000,$FFFF,$0188,$0000,$0007,$0000,$0000
	dc.w	$FFFF,$0186,$0000,$0007,$0000,$0000,$FFFF,$0187
	dc.w	$0000,$0007,$0000,$0000,$FFFF,$0189,$8000,$0007
	dc.w	$0000,$0000,$FFFF,$034C,$0000,$0007,$0000,$0000
	dc.w	$FFFF,$034D,$0000,$0007,$0000,$0000,$FFFF,$0161
	dc.w	$0000,$0005
Sub_3EE84
	clr.w	d6
	movea.l	#$17CC0,a1
	dc.w	$45FA,$0070
	dc.w	$267C,$0001,$7480
	movea.l	#$17CA0,a4
L23E9C	moveq	#$1F,d0
	movea.l	a3,a0
L23EA0	clr.l	(a0)+
	dbra	d0,L23EA0
	move.w	d6,$52(a3)
	st.b	$8(a3)
	st.b	$66(a3)
	move.w	(a2)+,$0(a3)
	move.w	(a2)+,$14(a3)
	move.w	(a2)+,$18(a3)
	move.w	(a2)+,$6(a3)
	move.w	(a2)+,$4(a3)
	move.w	d4,$12(a3)
	add.w	(a2)+,d4
	move.w	(a2)+,$4A(a3)
	move.w	(a2)+,$4C(a3)
	adda.w	#$1,a2
	move.b	(a2)+,$38(a3)
	adda.w	#$1,a2
	move.b	(a2)+,$62(a3)
	adda.w	#$80,a3
	asl.w	#$1,d6
	move.b	d6,(a1)+
	lsr.w	#$1,d6
	move.w	d6,(a4)+
	addq.w	#$1,d6
	cmpi.w	#$10,d6
	bne.w	L23E9C
	bra.w	Sub_3F03E
SprSort
	bclr	d0,d0
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_23F00.bin
Sub_3F03E
	movem.l	d0-d4/a0-a2,-(sp)
	movea.l	#$17CA0,a2
	movea.l	#$17C80,a1
	dc.w	$207C,$0001,$7480
	move.w	#$F,d3
L24058	move.w	$14(a0),d4
	btst	#$7,$17F6A.l
	beq.w	L2406C
	move.w	$0(a0),d4
L2406C	move.w	d4,(a1)+
	adda.w	#$80,a0
	dbra	d3,L24058
	movea.l	#$17C80,a1
L2407C	clr.w	d4
	movea.l	#$17CC0,a0
	move.w	#$E,d3
	clr.w	d0
	clr.w	d1
L2408C	move.b	(a0)+,d0
	move.b	(a0),d1
	move.w	(a1,d0.w),d2
	cmp.w	(a1,d1.w),d2
	ble.w	L240B6
	move.b	d0,(a0)
	move.b	d1,-$1(a0)
	move.l	a0,d2
	subi.l	#$17CC0,d2
	move.w	d2,(a2,d0.w)
	subq.w	#$1,d2
	move.w	d2,(a2,d1.w)
	st.b	d4
L240B6	dbra	d3,L2408C
	tst.w	d4
	bne.w	L2407C
	movem.l	(sp)+,d0-d4/a0-a2
	rts
Sub_3F0C6
	movem.l	d0-d2/a0-a3,-(sp)
	movea.l	#tmstruct,a2
	bsr.w	L240E4
	movea.l	#awtmstruct,a2
	bsr.w	L240E4
	movem.l	(sp)+,d0-d2/a0-a3
	rts
L240E4	bclr	#$4,$32(a2)
	moveq	#$5,d2
	movea.l	$22(a2),a3
L240F0	clr.b	$63(a3)
	tst.w	$34(a3)
	bmi.w	L24114
	move.w	#$50C,d1
	jsr	(Sub_363C0).l
	clr.w	$32(a3)
	clr.b	$5E(a3)
	andi.b	#$C2,$62(a3)
L24114	adda.w	#$80,a3
	dbra	d2,L240F0
	rts
clearTeamStats
	move.w	$18374.l,-(sp)
	move.w	$186DA.l,-(sp)
	movem.l	a1-a3,-(sp)
	move.w	#$19F,d0
	movea.l	#$18856,a1
	movea.l	#$184F0,a0
	dc.w	$247C,$0001,$A574
	dc.w	$267C,$0001,$A714
L2414A	move.b	(a0)+,(a2)+
	move.b	(a1)+,(a3)+
	dbra	d0,L2414A
	movem.l	(sp)+,a1-a3
	move.l	#$365,d0
	movea.l	#tmstruct,a0
L24162	clr.b	(a0)+
	dbra	d0,L24162
	movea.l	#awtmstruct,a0
	move.w	#$365,d0
L24172	clr.b	(a0)+
	dbra	d0,L24172
	movem.l	a1-a3,-(sp)
	move.w	#$19F,d0
	movea.l	#$18856,a1
	movea.l	#$184F0,a0
	dc.w	$247C,$0001,$A574
	dc.w	$267C,$0001,$A714
L24198	move.b	(a2)+,(a0)+
	move.b	(a3)+,(a1)+
	dbra	d0,L24198
	movem.l	(sp)+,a1-a3
	move.w	(sp)+,$186DA.l
	move.w	(sp)+,$18374.l
	st.b	$183E8.l
	st.b	$1874E.l
setteams
	movem.l	d0/a0-a2,-(sp)
	movea.l	#tmstruct,a2
	move.w	(HomeTeam).l,d0
	dc.w	$257C,$0001,$7480,$0022
	bsr.w	L241F6
	movea.l	#awtmstruct,a2
	move.w	(VisTeam).l,d0
	move.l	#$17780,$22(a2)
	bsr.w	L241F6
	movem.l	(sp)+,d0/a0-a2
	rts
L241F6	move.w	d0,$2A(a2)
	movea.l	#TeamList,a0
	asl.w	#$2,d0
	move.l	(a0,d0.w),$1E(a2)
CopyTeamLines
	dc.w	$4A79,$0001,$8C0A
	beq.w	L24232
	movea.l	$1E(a2),a0
	adda.w	$6(a0),a0
	lea.l	$16C(a2),a1
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	adda.w	#$8,a0
	move.w	#$B,d0
L2422A	move.l	(a0)+,(a1)+
	dbra	d0,L2422A
	rts
L24232	moveq	#$D,d0
	movea.l	$1E(a2),a0
	adda.w	$6(a0),a0
	adda.w	#$8,a0
	lea.l	$16C(a2),a1
L24244	move.l	(a0)+,(a1)+
	dbra	d0,L24244
	rts
Sub_3F24C
	clr.w	d1
	cmpi.w	#$13,(VisTeam).l
	beq.w	L2426A
	cmpi.w	#$13,(HomeTeam).l
	beq.w	L2426A
	bra.w	L24272
L2426A	move.w	#$860,$BBCDC.l
L24272	movea.l	#tmstruct,a0
	bsr.w	L24282
	moveq	#$20,d1
	adda.w	#$366,a0
L24282	movea.l	$1E(a0),a2
	adda.w	$2(a2),a2
	adda.w	d1,a2
	movea.l	#$BBCF0,a1
	adda.w	d1,a1
	moveq	#$7,d0
L24296	move.l	(a2)+,(a1)+
	dbra	d0,L24296
	rts
GameOver
	bsr.w	EncodePW
	dc.w	$4A79,$0001,$8BFA
	beq.w	L242BA
	bclr	#$1,$17F6A.l
	jsr	(PlayoffStatsScreen).l
L242BA	bsr.w	Sub_3F33C
	tst.w	$191CE.l
	dc.w	$660C
	move.w	#$1,$3FC0A.l
	bsr.w	Sub_3FC0C
L242D2	bra.w	Sub_3F2DC
	dc.w	$4EB9,$0004,$8208
Sub_3F2DC
	jsr	$48208.l
	bclr	#$5,$FF800F.l
	movea.l	#$C458,sp
	movea.l	#$1745C,a0
L242F6	clr.l	(a0)+
	cmpa.l	#$18BF0,a0
	blt.w	L242F6
	move.l	#vb2,(VBint).l
	bset	#$5,$FF800F.l
	jsr	(GameSetUp).l
	jsr	(UserNameEntry).l
	bsr.w	Sub_3F33C
	btst	#$0,$17F78.l
	bne.w	L24336
	jsr	(ScoutingReport).l
L24336	jmp	$2B7F8.l
Sub_3F33C
	tst.w	$191CE.l
	dc.w	$660C
	move.w	#$0,$3FC0A.l
	bsr.w	Sub_3FC0C
L24350	bclr	#$5,$FF800F.l
	dc.w	$4A79,$0001,$8BFA
	beq.w	rtss2
	move.l	#VBlank_Playoff,(VBint).l
	bset	#$5,$FF800F.l
	bclr	#$1,(disflags).l
	move.w	#$0,$18D30.l
	dc.w	$33FC,$BC00,$0001,$8D32
	move.w	#$B000,$18D3C.l
	move.w	#$6,$18D3E.l
	dc.w	$33FC,$C000,$0001,$8D38
	move.w	#$7,(Map2col).l
	move.w	#$E000,(VmMAP1).l
	move.w	#$7,(Map1col).l
	move.w	#$0,d0
	bsr.w	setVram
	bsr.w	printz
	String	CC_Font1,$0,$0
	dc.w	$203C,$0000,$0080
	moveq	#$1C,d1
	move.w	#$7FF,d2
	bsr.w	eraser
	bsr.w	printz
	String	CC_Font3,$0,$0
	moveq	#$28,d0
	moveq	#$2,d1
	move.w	#$7FF,d2
	bsr.w	eraser
	bsr.w	Sub_3940C
	bsr.w	AddSmallFont
	movea.l	$47D50.l,a2
	addq.l	#$8,a2
	dc.w	$33C4,$0001,$8D56
	bsr.w	DecompressGraphicsPlain
	bsr.w	printz
	String	CC_Font2Pal3,$0,$0
	movea.l	(EASportsBGMap).l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	$2(a1),d3
	moveq	#$3,d5
	bsr.w	dobitmap
	movea.l	$47D94.l,a1
	lea.l	$8(a1),a2
	adda.l	(a1),a1
	moveq	#$7,d0
	movea.l	#$BBCF0,a0
L2444A	move.l	-$40(a0),$20(a0)
	move.l	(a1)+,-$40(a0)
	move.l	-$20(a0),(a0)+
	dbra	d0,L2444A
	move.w	#$860,$BBCDC.l
	move.w	#$860,$BBCFC.l
	dc.w	$33C4,$0001,$8D46
	bsr.w	DecompressGraphicsPlain
	move.w	#$104,$17CE8.l
	dc.w	$33FC,$00A0,$0001,$7CE6
	movea.l	#$C00004,a0
L2448C	btst	#$7,$FF800E.l
	bne.b	L2448C
	move.w	#$9202,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
L244AE	btst	#$6,$FF800E.l
	beq.b	L244AE
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L244C8	btst	#$6,$FF800E.l
	bne.b	L244C8
	bclr	#$7,$FF800F.l
	movea.l	#$18AA6,a1
	movea.l	#$41ADE,a0
	dc.w	$3039,$0001,$8A9E
	asl.w	#$1,d0
	adda.w	(a0,d0.w),a0
	clr.w	d4
	move.b	(a0)+,d4
L244F6	bsr.w	printz
	String	CC_Font1,$0,$0
	move.b	(a0)+,$18D59.l
	move.b	(a0)+,$18D5B.l
	clr.w	d1
	move.b	(a1)+,d1
	add.w	d1,d1
	bsr.w	PlayoffScreen_doteam
	dbra	d4,L244F6
	clr.w	d4
	move.b	(a0)+,d4
L2451E	bsr.w	printz
	String	CC_Font1,$0,$2
	move.b	(a0)+,$18D59.l
	clr.w	d0
	move.b	(a0)+,d0
	bsr.w	PlayoffScreen_doarrow
	dbra	d4,L2451E
	bsr.w	printz
	String	CC_Font1Pal1,$0,$0
	dc.w	$0C79,$0007,$0001,$8A9C
	beq.w	L24576
	clr.w	d4
	move.b	(a0)+,d4
	bmi.w	L24576
	movea.l	#$18A18,a2
L2455E	move.b	(a0)+,$18D59.l
	move.b	(a0)+,$18D5B.l
	bsr.w	PlayoffScreen_doscores
	adda.w	#$10,a2
	dbra	d4,L2455E
L24576	bsr.w	printsmallz
	String	CC_SetMapAndPosition,$1,$1,$41,$1A
	dc.w	$43FA,$02AE,$3039,$0001,$8A9E,$6100,$D938,$3011
	dc.w	$E248,$9179,$0001,$8D58,$6100,$9802,$4A79,$0001
	dc.w	$8A9E,$6700,$0020,$6100,$99C4,$001A,$CD0A,$0150
	dc.w	$7265,$7373,$205B,$206F,$7220,$5D20,$746F,$2070
	dc.w	$6167,$6500,$33FC,$0018,$0001,$8D62,$3F3C,$0079
	dc.w	$4EB9,$0003,$71D2,$4240,$4244,$33FC,$FFFF,$0001
	dc.w	$A452,$33FC,$0001,$0001,$A44E,$6100,$0052,$6100
	dc.w	$00C4,$207C,$0003,$C000,$4EB9,$0002,$ACD2,$6100
	dc.w	$0006,$6000,$FFEA,$4EB9,$0003,$74F0,$3F03,$4EB9
	dc.w	$0003,$750E,$865F,$0803,$0007,$6600,$0092,$0803
	dc.w	$0003,$6700,$000A,$33FC,$FFFE,$0001,$A452,$0803
	dc.w	$0002,$6700,$000A,$33FC,$0002,$0001,$A452
PlayoffScreen_scrup
	move.w	(PlayerScrollCtr).l,d0
	beq.w	rtss2
	add.w	(scoutcolumn).l,d0
	dc.w	$3239,$0001,$8A9E
	cmpi.w	#$3,d1
	bls.w	L24660
	moveq	#$3,d1
L24660	mulu.w	#$70,d1
	cmp.w	d1,d0
	bgt.w	rtss2
	neg.w	d1
	cmp.w	d1,d0
	blt.w	rtss2
	move.w	d0,(scoutcolumn).l
	dc.w	$4279,$0001,$7CE4
	move.w	d0,d1
	addi.w	#$100,d1
	cmpi.w	#$40,d1
	blt.w	L2469A
	cmpi.w	#$200,d1
	bgt.w	L2469A
	dc.w	$33C1,$0001,$7CE4
L2469A	ext.l	d0
	divs.w	#$70,d0
	swap	d0
	tst.w	d0
	bne.w	rtss2
	clr.w	(PlayerScrollCtr).l
	rts
	dc.w	$DEFC,$0004,$4E75
