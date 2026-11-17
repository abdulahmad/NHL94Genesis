addframe2
	move.w	$4(a3),-(sp)
	movem.l	d0-d5/a0-a2,-(sp)
	move.w	$6(a3),d4
	bmi.w	.l23868
	beq.w	.l23868
	andi.w	#$F800,d4
	eor.w	d4,$4(a3)
	move.w	$6(a3),d4
	andi.w	#$7FF,d4
	movea.l	$47D24.l,a2
	adda.l	$4(a2),a2
	add.w	d4,d4
	cmp.w	$2(a2),d4
	bge.w	.l23868
	move.w	$2(a2,d4.w),d5
	sub.w	(a2,d4.w),d5
	lsr.w	#$3,d5
	subi.w	#$1,d5
	adda.w	(a2,d4.w),a2
	clr.w	d3
	clr.w	d4
.l23734	move.w	d0,-(sp)
	move.w	$6(a3),d0
	andi.w	#$7FF,d0
	cmp.w	$8(a3),d0
	beq.w	.l237CA
	tst.w	d5
	bne.w	.l23750
	move.w	d0,$8(a3)
.l23750	movem.w	d0-d4,-(sp)
	move.w	$4(a2),d2
	clr.w	d4
	move.b	$7(a2),d4
	movea.l	#$41A5C,a0
	move.b	(a0,d4.w),d4
	cmp.w	$8(sp),d4
	bgt.w	.l23794
	cmp.w	$4(sp),d2
	blt.w	.l23794
	move.w	$4(sp),d0
	add.w	$8(sp),d0
	sub.w	d2,d0
	sub.w	d4,d0
	bmi.w	.l23794
	movem.w	(sp)+,d0-d1
	adda.w	#$6,sp
	bra.w	.l237C6
.l23794	add.w	$8(sp),d3
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
.l237C6	move.b	d3,$A(a3,d5.w)
.l237CA	move.w	(sp)+,d0
	movem.w	d0-d2,-(sp)
	move.w	$2(a2),d2
	btst	#$4,$4(a3)
	beq.w	.l237F2
	move.b	$7(a2),d2
	andi.w	#$3,d2
	addi.w	#$1,d2
	asl.w	#$3,d2
	neg.w	d2
	sub.w	$2(a2),d2
.l237F2	add.w	d2,d1
	move.w	d1,(a6)
	move.w	(a2),d2
	btst	#$3,$4(a3)
	beq.w	.l23814
	move.b	$7(a2),d2
	andi.w	#$C,d2
	addi.w	#$4,d2
	asl.w	#$1,d2
	neg.w	d2
	sub.w	(a2),d2
.l23814	add.w	d2,d0
	move.w	d0,$6(a6)
	move.b	$7(a2),$2(a6)
	move.b	d6,$3(a6)
	move.w	$6(a2),d2
	move.w	$4(a3),d0
	eor.w	d0,d2
	andi.w	#$F800,d2
	btst	#$0,$5(a3)
	beq.w	.l23848
	btst	#$E,d2
	beq.w	.l23848
	bset	#$D,d2
.l23848	or.b	$A(a3,d5.w),d2
	add.w	$12(a3),d2
	move.w	d2,$4(a6)
	movem.w	(sp)+,d0-d2
	addi.w	#$1,d6
	adda.w	#$8,a6
	adda.w	#$8,a2
	dbra	d5,.l23734
.l23868	movem.l	(sp)+,d0-d5/a0-a2
	move.w	(sp)+,$4(a3)
	rts
find3d						;input: d0 = xfield, d1 = yfield, d2 = height off field. Output: d0 =
									;xscreen, d1 = yscreen, or d1 = $4E20 when off screen
	btst	#$7,$17F6A.l
	beq.w	.l2388A
	exg.l	d0,d1
	neg.w	d0
	subi.w	#$C5,d1
	bra.w	.l23896
.l2388A	sub.w	$17CEE.l,d0
	sub.w	$17CEA.l,d1
.l23896	cmpi.w	#$90,d0
	bgt.w	.l238C8
	cmpi.w	#$FF70,d0
	blt.w	.l238C8
	addi.w	#$100,d0		;128+128
	add.w	d2,d1
	asr.w	#$1,d2
	add.w	d2,d1		;y + 1.5 * height
	cmpi.w	#$90,d1		;112+32
	bgt.w	.l238C8
	cmpi.w	#$FF70,d1
	blt.w	.l238C8
	neg.w	d1
	addi.w	#$F0,d1		;112+128
	rts
.l238C8	move.w	#$4E20,d1
	rts
updatesound						;move the crowd noise volume (psg noise channel, asv) toward Crowdlevel.
									;Called from periodicevents
	move.w	(Crowdlevel).l,d0
	asl.w	#$3,d0
	addi.w	#$400,d0
	cmpi.w	#$EFF,d0
	bls.w	.l238E6
	move.w	#$EFF,d0
.l238E6	moveq	#$28,d2		;max step 40 (d0 = target level, asv = current)
	sub.w	(asv).l,d0
	cmp.w	d2,d0
	bgt.w	.l238FC
	neg.w	d2
	cmp.w	d2,d0
	bge.w	.l2390C		;within 40: no change
.l238FC	add.w	d2,(asv).l		;step asv toward the target
	bpl.w	.l2390C
	clr.w	(asv).l
.l2390C	move.b	(asv).l,d0		;psg: noise channel setup, then attenuation below
	eori.b	#$F,d0
	ori.b	#$F0,d0
	rts
	movem.l	d0-d7/a0-a6,-(sp)
	bset	#$1,(disflags).l
	move.w	#$C000,$18D38.l
	move.w	#$6,(Map2col).l
	move.w	#$DC00,$18D32.l
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
	clr.w	$17CEE.l
	clr.w	$17CEA.l
	move.w	#$7D0,$17CEC.l
	st.b	$17CE2.l
	move.w	#$800,d0
	move.w	(VmMAP1).l,d1
	move.w	#$7FF,d2
	bsr.w	Sub_37AA2
	clr.w	d4
	move.w	d4,$18D48.l
	movea.l	$47D18.l,a2
	addq.l	#$8,a2
	btst	#$4,$17F72.l
	beq.w	.l239D4
	movea.l	$47D64.l,a2
	addq.l	#$8,a2
.l239D4	bsr.w	DecompressGraphicsPlain
	jsr	$2A9D0.l
	move.w	d4,$18D50.l
	bsr.w	Sub_3EC78
	move.w	d4,$18D46.l
	movea.l	$47D40.l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain
	move.w	d4,$18D4A.l
	movea.l	$47D2C.l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain
	move.w	d4,$1A54E.l
	addi.w	#$32,d4
	move.w	d4,$18D54.l
	bsr.w	Sub_3ED9A
	move.w	d4,$18C1C.l
	bsr.w	setupIceRinkPal
	bsr.w	Sub_393FA
	move.w	d4,$18D42.l
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
setupice_highlight
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(forceblack).l
	bclr	#$0,$17F6A.l
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	clr.w	$17CEE.l
	clr.w	$17CEA.l
	move.w	#$7D0,$17CEC.l
	st.b	$17CE2.l
	move.w	$18D54.l,d4
	bsr.w	Sub_3ED9A
	bsr.w	setupIceRinkPal
	btst	#$1,$17F68.l
	beq.w	.l23BA6
	movea.l	#$17480,a3
	moveq	#$B,d0
.l23B98	bchg	#$7,$62(a3)
	adda.w	#$80,a3
	dbra	d0,.l23B98
.l23BA6	bsr.w	Sub_3F24C
	move.w	#$FFFF,$17DC8.l
	move.w	#$FFFF,$17DD6.l
	clr.l	$17DCA.l
	clr.l	$17DCE.l
	clr.l	$17DD2.l
	st.b	$17F9E.l
	st.b	$17FA0.l
	bsr.w	Sub_3EC78
	movea.l	#$18D6A,a5
	movea.l	#$BBD30,a6
	moveq	#$1,d6
	movea.l	#$17D04,a3
	clr.w	d0
	clr.w	d1
	bsr.w	addframe2
	adda.w	#$1C,a3
	bsr.w	addframe2
	adda.w	#$1C,a3
	bsr.w	addframe2
	adda.w	#$1C,a3
	bsr.w	addframe2
	adda.w	#$1C,a3
	bsr.w	addframe2
	adda.w	#$1C,a3
	bsr.w	addframe2
	move.l	a5,$191CA.l
	bsr.w	dodmalist
	move.w	#$1C,(palcount).l
	move.w	(sp)+,(disflags).l
	move.l	#$3DAB8,(VBint).l
	bclr	#$0,(disflags).l
	bclr	#$2,(disflags).l
	bset	#$5,$FF800F.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
setupIceRinkPal
	movea.l	$47D18.l,a0
	adda.l	(a0),a0
	moveq	#$F,d0
	movea.l	#$BBCB0,a1
.l23C70	move.l	(a0)+,(a1)+
	dbra	d0,.l23C70
	rts
Sub_3EC78
	move.w	$18D50.l,d4
	movea.l	$47D4C.l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsWithRemap
	dc.w	$7123,$4567,$89AB,$CDEF,$4E75,$3839,$0001,$8D46
	dc.w	$2479,$0004,$7D40,$508A,$6000,$9CB4,$3839,$0001
	dc.w	$8D4A,$2479,$0004,$7D2C,$508A,$6000,$9CA2
	move.w	$18D56.l,d4
	movea.l	$47D20.l,a2
	addq.l	#$8,a2
	bra.w	DecompressGraphicsPlain
	dc.w	$3839,$0001,$8D56,$2479,$0004,$7D1C,$508A,$6000
	dc.w	$9C7E,$3839,$0001,$8D4C,$2479,$0004,$7D30,$508A
	dc.w	$6000,$9C6C,$3839,$0001,$8D56,$2479,$0004,$7D14
	dc.w	$508A,$6000,$9C5A
setupTeamBlocksMap						;Load the TeamBlocks map tiles (Teamblocksmap) at d4+$2C and copy the home
	
	
	move.w	d4,$18D52.l
	addi.w	#$2C,d4
	movea.l	#$17FB2,a1
	movea.l	$47D44.l,a0
	lea.l	$8(a0),a2
	bsr.w	DecompressGraphicsPlain
	adda.l	$4(a0),a0
	move.l	a0,-(sp)
	move.w	(HomeTeam).l,d0
	move.w	$18D52.l,d1
	asl.w	#$5,d1
	bsr.w	CopyTeamBlockMapData
	movea.l	(sp)+,a0
	move.w	(VisTeam).l,d0
	move.w	$18D52.l,d1
	addi.w	#$16,d1
	asl.w	#$5,d1
	bsr.w	CopyTeamBlockMapData
	move.w	$18D52.l,d4
	addi.w	#$2C,d4
	rts
CopyTeamBlockMapData						;Copy one team's 22 block chars from the loaded tile set to vram at d1 by
	
	
	mulu.w	#$2C,d0
	lea.l	$4(a0,d0.w),a0
	move.w	#$15,d3
.row	moveq	#$20,d0
	move.w	d1,-(sp)
	move.b	(a0),(a1)
	andi.w	#$F800,(a1)
	lsr.w	#$5,d1
	ori.w	#$8000,d1
	or.w	d1,(a1)+
	move.w	(sp)+,d1
	move.w	(a0)+,d2
	andi.w	#$7FF,d2
	add.w	$18D52.l,d2
	addi.w	#$2C,d2
	asl.w	#$5,d2
	bsr.w	DoDMA_nd2
	addi.w	#$20,d1
	dbra	d3,.row
	rts
Sub_3ED9A
	movea.l	#$3EE08,a2
	movea.l	#$17DD8,a3
	moveq	#$3,d0
.l23DA8	move.w	#$FFFF,$8(a3)
	move.w	(a2)+,$0(a3)
	move.w	(a2)+,$2(a3)
	move.w	(a2)+,$6(a3)
	move.w	(a2)+,$4(a3)
	move.w	d4,$12(a3)
	add.w	(a2)+,d4
	adda.w	#$14,a3
	dbra	d0,.l23DA8
	movea.l	#$3EE30,a2
	movea.l	#$17D04,a3
	move.l	#$6,d0
.l23DDE	st.b	$8(a3)
	move.w	(a2)+,$0(a3)
	move.w	(a2)+,$14(a3)
	move.w	(a2)+,$18(a3)
	move.w	(a2)+,$6(a3)
	move.w	(a2)+,$4(a3)
	move.w	d4,$12(a3)
	add.w	(a2)+,d4
	adda.w	#$1C,a3
	dbra	d0,.l23DDE
	bra.w	Sub_3EE84
defaultsprites_0						;objects which are tied to screen scrolling and have velocity: the 16
	
	
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
	movea.l	#$17480,a3
	movea.l	#$17CA0,a4
.l23E9C	moveq	#$1F,d0
	movea.l	a3,a0
.l23EA0	clr.l	(a0)+
	dbra	d0,.l23EA0
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
	bne.w	.l23E9C
	bra.w	Sub_3F03E
SprSort						;sort objects in struct SortObj and set corresponding tables for keeping
	
	bclr	d0,d0
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_23F00.bin
Sub_3F03E
	movem.l	d0-d4/a0-a2,-(sp)
	movea.l	#$17CA0,a2
	movea.l	#$17C80,a1
	movea.l	#$17480,a0
	move.w	#$F,d3
.l24058	move.w	$14(a0),d4
	btst	#$7,$17F6A.l
	beq.w	.l2406C
	move.w	$0(a0),d4
.l2406C	move.w	d4,(a1)+
	adda.w	#$80,a0
	dbra	d3,.l24058
	movea.l	#$17C80,a1
.l2407C	clr.w	d4
	movea.l	#$17CC0,a0
	move.w	#$E,d3
	clr.w	d0
	clr.w	d1
.l2408C	move.b	(a0)+,d0
	move.b	(a0),d1
	move.w	(a1,d0.w),d2
	cmp.w	(a1,d1.w),d2
	ble.w	.l240B6
	move.b	d0,(a0)
	move.b	d1,-$1(a0)
	move.l	a0,d2
	subi.l	#$17CC0,d2
	move.w	d2,(a2,d0.w)
	subq.w	#$1,d2
	move.w	d2,(a2,d1.w)
	st.b	d4
.l240B6	dbra	d3,.l2408C
	tst.w	d4
	bne.w	.l2407C
	movem.l	(sp)+,d0-d4/a0-a2
	rts
resetplstuff
	movem.l	d0-d2/a0-a3,-(sp)
	movea.l	#tmstruct,a2
	bsr.w	.l240E4
	movea.l	#awtmstruct,a2
	bsr.w	.l240E4
	movem.l	(sp)+,d0-d2/a0-a3
	rts
.l240E4	bclr	#$4,$32(a2)
	moveq	#$5,d2
	movea.l	$22(a2),a3
.l240F0	clr.b	$63(a3)
	tst.w	$34(a3)
	bmi.w	.l24114
	move.w	#$50C,d1
	jsr	(SetSPA).l
	clr.w	$32(a3)
	clr.b	$5E(a3)
	andi.b	#$C2,$62(a3)
.l24114	adda.w	#$80,a3
	dbra	d2,.l240F0
	rts
clearTeamStats						;clear both team structs (2 x tmsize) but keep each hot / cold table
	
	
	
	move.w	$18374.l,-(sp)
	move.w	$186DA.l,-(sp)
	movem.l	a1-a3,-(sp)
	move.w	#$19F,d0
	movea.l	#$18856,a1
	movea.l	#$184F0,a0
	movea.l	#$1A574,a2
	movea.l	#$1A714,a3
.l2414A	move.b	(a0)+,(a2)+
	move.b	(a1)+,(a3)+
	dbra	d0,.l2414A
	movem.l	(sp)+,a1-a3
	move.l	#$365,d0
	movea.l	#tmstruct,a0
.loop2	clr.b	(a0)+
	dbra	d0,.loop2
	movea.l	#awtmstruct,a0
	move.w	#$365,d0
.loop3	clr.b	(a0)+
	dbra	d0,.loop3
	movem.l	a1-a3,-(sp)
	move.w	#$19F,d0
	movea.l	#$18856,a1
	movea.l	#$184F0,a0
	movea.l	#$1A574,a2
	movea.l	#$1A714,a3
.l24198	move.b	(a2)+,(a0)+
	move.b	(a3)+,(a1)+
	dbra	d0,.l24198
	movem.l	(sp)+,a1-a3
	move.w	(sp)+,$186DA.l
	move.w	(sp)+,$18374.l
	st.b	$183E8.l
	st.b	$1874E.l
setteams						;Use hometeam/visteam to set team structures (InitTeamStructure for each).
	
	movem.l	d0/a0-a2,-(sp)
	movea.l	#tmstruct,a2
	move.w	(HomeTeam).l,d0
	move.l	#$17480,$22(a2)
	bsr.w	.l241F6
	movea.l	#awtmstruct,a2
	move.w	(VisTeam).l,d0
	move.l	#$17780,$22(a2)
	bsr.w	.l241F6
	movem.l	(sp)+,d0/a0-a2
	rts
.l241F6	move.w	d0,$2A(a2)
	movea.l	#TeamList,a0
	asl.w	#$2,d0
	move.l	(a0,d0.w),$1E(a2)
CopyTeamLines						;'Set Original lines' (line editor exit menu): copy the team data line
	
	tst.w	$18C0A.l
	beq.w	.0
	movea.l	$1E(a2),a0
	adda.w	$6(a0),a0
	lea.l	$16C(a2),a1
	move.l	(a0)+,(a1)+
	move.l	(a0)+,(a1)+
	adda.w	#$8,a0
	move.w	#$B,d0
.loop	move.l	(a0)+,(a1)+
	dbra	d0,.loop
	rts
.0	moveq	#$D,d0
	movea.l	$1E(a2),a0
	adda.w	$6(a0),a0
	adda.w	#$8,a0
	lea.l	$16C(a2),a1
.copy	move.l	(a0)+,(a1)+
	dbra	d0,.copy
	rts
Sub_3F24C
	clr.w	d1
	cmpi.w	#$13,(VisTeam).l
	beq.w	.l2426A
	cmpi.w	#$13,(HomeTeam).l
	beq.w	.l2426A
	bra.w	.l24272
.l2426A	move.w	#$860,$BBCDC.l
.l24272	movea.l	#tmstruct,a0
	bsr.w	.l24282
	moveq	#$20,d1
	adda.w	#$366,a0
.l24282	movea.l	$1E(a0),a2
	adda.w	$2(a2),a2
	adda.w	d1,a2
	movea.l	#$BBCF0,a1
	adda.w	d1,a1
	moveq	#$7,d0
.l24296	move.l	(a2)+,(a1)+
	dbra	d0,.l24296
	rts
GameOver						;EncodePW (save the password), then in playoff mode PlayoffStatsScreen
	
	bsr.w	EncodePW
	tst.w	$18BFA.l
	beq.w	.po
	bclr	#$1,$17F6A.l
	jsr	(PlayoffStatsScreen).l
.po	bsr.w	Sub_3F33C
	tst.w	$191CE.l
	bne.s	*+14
	move.w	#$1,$3FC0A.l
	bsr.w	Sub_3FC0C
.l242D2	bra.w	Sub_3F2DC
	jsr	$48208.l
Sub_3F2DC
	jsr	$48208.l
	bclr	#$5,$FF800F.l
	movea.l	#$C458,sp
	movea.l	#$1745C,a0
.l242F6	clr.l	(a0)+
	cmpa.l	#$18BF0,a0
	blt.w	.l242F6
	move.l	#vb2,(VBint).l
	bset	#$5,$FF800F.l
	jsr	(GameSetUp).l
	jsr	(UserNameEntry).l
	bsr.w	Sub_3F33C
	btst	#$0,$17F78.l
	bne.w	.l24336
	jsr	(ScoutingReport).l
.l24336	jmp	$2B7F8.l
Sub_3F33C
	tst.w	$191CE.l
	bne.s	*+14
	move.w	#$0,$3FC0A.l
	bsr.w	Sub_3FC0C
.l24350	bclr	#$5,$FF800F.l
	tst.w	$18BFA.l
	beq.w	rtss2
	move.l	#VBlank_Playoff,(VBint).l
	bset	#$5,$FF800F.l
	bclr	#$1,(disflags).l
	move.w	#$0,$18D30.l
	move.w	#$BC00,$18D32.l
	move.w	#$B000,$18D3C.l
	move.w	#$6,$18D3E.l
	move.w	#$C000,$18D38.l
	move.w	#$7,(Map2col).l
	move.w	#$E000,(VmMAP1).l
	move.w	#$7,(Map1col).l
	move.w	#$0,d0
	bsr.w	setVram
	bsr.w	printz
	String	CC_Font1,$0,$0
	move.l	#$80,d0
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
	move.w	d4,$18D56.l
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
.l2444A	move.l	-$40(a0),$20(a0)
	move.l	(a1)+,-$40(a0)
	move.l	-$20(a0),(a0)+
	dbra	d0,.l2444A
	move.w	#$860,$BBCDC.l
	move.w	#$860,$BBCFC.l
	move.w	d4,$18D46.l
	bsr.w	DecompressGraphicsPlain
	move.w	#$104,$17CE8.l
	move.w	#$A0,$17CE6.l
	movea.l	#$C00004,a0
.l2448C	btst	#$7,$FF800E.l
	bne.b	.l2448C
	move.w	#$9202,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.l244AE	btst	#$6,$FF800E.l
	beq.b	.l244AE
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l244C8	btst	#$6,$FF800E.l
	bne.b	.l244C8
	bclr	#$7,$FF800F.l
	movea.l	#$18AA6,a1
	movea.l	#$41ADE,a0
	move.w	$18A9E.l,d0
	asl.w	#$1,d0
	adda.w	(a0,d0.w),a0
	clr.w	d4
	move.b	(a0)+,d4
.l244F6	bsr.w	printz
	String	CC_Font1,$0,$0
	move.b	(a0)+,$18D59.l
	move.b	(a0)+,$18D5B.l
	clr.w	d1
	move.b	(a1)+,d1
	add.w	d1,d1
	bsr.w	PlayoffScreen_doteam
	dbra	d4,.l244F6
	clr.w	d4
	move.b	(a0)+,d4
.l2451E	bsr.w	printz
	String	CC_Font1,$0,$2
	move.b	(a0)+,$18D59.l
	clr.w	d0
	move.b	(a0)+,d0
	bsr.w	PlayoffScreen_doarrow
	dbra	d4,.l2451E
	bsr.w	printz
	String	CC_Font1Pal1,$0,$0
	cmpi.w	#$7,$18A9C.l
	beq.w	.l24576
	clr.w	d4
	move.b	(a0)+,d4
	bmi.w	.l24576
	movea.l	#$18A18,a2
.l2455E	move.b	(a0)+,$18D59.l
	move.b	(a0)+,$18D5B.l
	bsr.w	PlayoffScreen_doscores
	adda.w	#$10,a2
	dbra	d4,.l2455E
.l24576	bsr.w	printsmallz
	String	CC_SetMapAndPosition,$1,$1,$41,$1A
	dc.w	$43FA,$02AE,$3039,$0001,$8A9E,$6100,$D938,$3011
	dc.w	$E248,$9179,$0001,$8D58,$6100,$9802,$4A79,$0001
	dc.w	$8A9E,$6700,$0020,$6100,$99C4,$001A,$CD0A,$0150
	dc.b	'ress [ or ] to p'
	dc.w	$6167,$6500,$33FC,$0018,$0001,$8D62,$3F3C,$0079
	dc.w	$4EB9,$0003,$71D2,$4240,$4244,$33FC,$FFFF,$0001
	dc.w	$A452,$33FC,$0001,$0001,$A44E,$6100,$0052,$6100
	dc.w	$00C4,$207C,$0003,$C000,$4EB9,$0002,$ACD2,$6100
	dc.w	$0006,$6000,$FFEA,$4EB9,$0003,$74F0,$3F03,$4EB9
	dc.w	$0003,$750E,$865F,$0803,$0007,$6600,$0092,$0803
	dc.w	$0003,$6700,$000A,$33FC,$FFFE,$0001,$A452,$0803
	dc.w	$0002,$6700,$000A,$33FC,$0002,$0001,$A452
PlayoffScreen_scrup						;Move the tree one step (PlayerScrollCtr) and stop on a page boundary
	
	
	
	move.w	(PlayerScrollCtr).l,d0
	beq.w	rtss2
	add.w	(scoutcolumn).l,d0
	move.w	$18A9E.l,d1
	cmpi.w	#$3,d1
	bls.w	.lim
	moveq	#$3,d1
.lim	mulu.w	#$70,d1
	cmp.w	d1,d0
	bgt.w	rtss2
	neg.w	d1
	cmp.w	d1,d0
	blt.w	rtss2
	move.w	d0,(scoutcolumn).l
	clr.w	$17CE4.l
	move.w	d0,d1
	addi.w	#$100,d1
	cmpi.w	#$40,d1
	blt.w	.nox
	cmpi.w	#$200,d1
	bgt.w	.nox
	move.w	d1,$17CE4.l
.nox	ext.l	d0
	divs.w	#$70,d0
	swap	d0
	tst.w	d0
	bne.w	rtss2
	clr.w	(PlayerScrollCtr).l
	rts
	dc.w	$DEFC,$0004,$4E75
