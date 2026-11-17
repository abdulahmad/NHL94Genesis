EncodePW
	tst.w	(OptNOP).l
	beq.w	rtss2
	dc.w	$4A79,$0001,$8BFA
	beq.w	rtss2
	dc.w	$0C79,$0004,$0001,$8BFA
	beq.w	rtss2
	dc.w	$33FC,$0001,$0001,$8BFA
	move.w	#$1,$18C24.l
	bsr.w	ResolveGames
	bsr.w	MakeTree
	dc.w	$0C79,$0004,$0001,$8A9E
	beq.w	L256D4
	dc.w	$4A79,$0001,$8A98
	bmi.w	L256D4
	dc.w	$267C,$0001,$8C38
	bsr.w	WritePassBits
	jsr	$2A5C8.l
	btst	#$2,$17F6E.l
	beq.w	rtss2
	movea.l	#$18D26,a3
	bsr.w	Sub_4057C
	bra.w	MakeTree
L256D4	dc.w	$267C,$0001,$8C38
	bsr.w	ClrPassBits
	jsr	$2A5C8.l
	dc.w	$33FC,$0002,$0001,$8BFA
	move.w	#$2,$18C24.l
	dc.w	$0C79,$0007,$0001,$8A9C
	beq.w	rtss2
	dc.w	$33FC,$0003,$0001,$8BFA
	move.w	#$3,$18C24.l
	rts
WritePassBits
	bsr.w	ClrPassBits
	dc.w	$3039,$0001,$8A9A
	moveq	#$20,d1
	bsr.w	PushBits
	dc.w	$3039,$0001,$8A9C
	moveq	#$8,d1
	bsr.w	PushBits
	dc.w	$3039,$0001,$8A9E
	moveq	#$4,d1
	bsr.w	PushBits
	dc.w	$3039,$0001,$8AA0
	moveq	#$10,d1
	bsr.w	PushBits
	dc.w	$3039,$0001,$8AA2
	moveq	#$8,d1
	bsr.w	PushBits
	dc.w	$3039,$0001,$8AA4
	move.w	#$4000,d1
	bsr.w	PushBits
	moveq	#$5,d1
	moveq	#$7,d2
	movea.l	#$18A18,a1
L2576A	move.w	$4(a1),d0
	bsr.w	PushBits
	move.w	$6(a1),d0
	bsr.w	PushBits
	adda.w	#$10,a1
	dbra	d2,L2576A
	rts
PushBits
	movem.l	d0-d1,-(sp)
	exg.l	d0,d1
	bsr.w	SuperMult
	clr.l	d0
	move.w	d1,d0
	bsr.w	SuperAdd
	movem.l	(sp)+,d0-d1
	rts
ClrPassBits
	movea.l	a3,a0
	moveq	#$4,d0
L257A0	clr.w	(a0)+
	dbra	d0,L257A0
	rts
SuperAdd
	movem.l	d1/a0,-(sp)
	lea.l	$A(a3),a0
	moveq	#$3,d1
	add.l	d0,-(a0)
	bra.w	L257BC
L257B8	addi.w	#$1,-(a0)
L257BC	dbcc	d1,L257B8
	movem.l	(sp)+,d1/a0
	rts
SuperMult
	movem.l	d1-d4/a0,-(sp)
	movea.l	a3,a0
	moveq	#$4,d4
L257CE	move.w	(a0),-(sp)
	clr.w	(a0)+
	dbra	d4,L257CE
	moveq	#$4,d4
L257D8	move.w	d0,d1
	mulu.w	(sp)+,d1
	lea.l	$2(a3),a0
	adda.w	d4,a0
	adda.w	d4,a0
	move.w	d4,d2
	add.l	d1,-(a0)
	bra.w	L257F0
L257EC	addi.w	#$1,-(a0)
L257F0	dbcc	d2,L257EC
	dbra	d4,L257D8
	movem.l	(sp)+,d1-d4/a0
	rts
SuperDiv
	movem.l	d1-d2/a0,-(sp)
	movea.l	a3,a0
	moveq	#$4,d1
	clr.l	d2
L25808	move.w	(a0),d2
	divu.w	d0,d2
	move.w	d2,(a0)+
	dbra	d1,L25808
	swap	d2
	move.w	d2,d0
	movem.l	(sp)+,d1-d2/a0
	rts
GetShifter
	move.l	d0,-(sp)
	moveq	#-16,d2
	moveq	#$10,d1
	dc.w	$3039,$0001,$8A9E
L25828	add.w	d1,d2
	lsr.w	#$1,d1
	dbra	d0,L25828
	subi.w	#$1,d1
	move.l	(sp)+,d0
	rts
AddPlayoffTeamStats
	dc.w	$0C79,$0001,$0001,$8BFA
	blt.w	rtss2
	bsr.w	ReadTeamStats
	movea.l	#$18AA6,a0
	dc.w	$3439,$0001,$8AA0
	move.b	(a0,d2.w),d2
	movea.l	#tmstruct,a2
	cmp.w	$2A(a2),d2
	beq.w	L2586A
	adda.w	#$366,a2
L2586A	adda.w	#$B6,a2
	moveq	#$67,d0
	movea.l	#$B000,a1
L25876	clr.w	d1
	move.b	(a2)+,d1
	add.w	d1,(a1)+
	dbra	d0,L25876
	movea.l	#$B000,a0
	movea.l	#$408DC,a1
	movea.l	#$18C42,a2
	moveq	#$67,d0
	clr.w	d4
L25896	clr.l	d1
	move.w	(a0)+,d1
	move.w	d0,d2
	andi.w	#$3,d2
	move.b	(a1,d2.w),d2
	clr.l	d3
	bset	d2,d3
	subi.w	#$1,d3
	cmp.w	d3,d1
	ble.w	L258B4
	move.w	d3,d1
L258B4	not.l	d3
	move.w	d4,d5
	andi.w	#$F,d5
	rol.l	d5,d3
	rol.l	d5,d1
	move.w	d4,d5
	lsr.w	#$4,d5
	add.w	d5,d5
	neg.w	d5
	addi.w	#$100,d5
	and.l	d3,-$22(a2,d5.w)
	or.l	d1,-$22(a2,d5.w)
	add.w	d2,d4
	dbra	d0,L25896
	rts
	dc.w	$0C0E,$0A0A
ReadTeamStats
	movea.l	#$B000,a0
	movea.l	#$408DC,a1
	movea.l	#$18C42,a2
	moveq	#$67,d0
	clr.w	d4
L258F6	move.w	d4,d5
	lsr.w	#$4,d5
	add.w	d5,d5
	neg.w	d5
	addi.w	#$100,d5
	move.l	-$22(a2,d5.w),d1
	move.w	d4,d5
	andi.w	#$F,d5
	lsr.l	d5,d1
	move.w	d0,d2
	andi.w	#$3,d2
	move.b	(a1,d2.w),d2
	add.w	d2,d4
	clr.w	d3
	bset	d2,d3
	subi.w	#$1,d3
	and.w	d3,d1
	move.w	d1,(a0)+
	dbra	d0,L258F6
	rts
ResolveGames
	dc.w	$3039,$0001,$8A98
	mulu.w	#$10,d0
	movea.l	#$18A18,a0
	dc.w	$31B9,$0001,$8358,$000A
	dc.w	$31B9,$0001,$86BE,$000C
	bsr.w	GetShifter
	movea.l	#$18A18,a0
	moveq	#$10,d3
	mulu.w	d1,d3
	adda.w	d3,a0
	dc.w	$0C79,$0007,$0001,$8A9C
	beq.w	L25AB6
L25968	cmpi.w	#$4,$4(a0)
	beq.w	L259A2
	cmpi.w	#$4,$6(a0)
	beq.w	L259A2
	clr.w	d3
	btst	#$0,$E(a0)
	beq.w	L2598C
	eori.w	#$2,d3
L2598C	move.w	$A(a0),d0
	sub.w	$C(a0),d0
	bpl.w	L2599C
	eori.w	#$2,d3
L2599C	addi.w	#$1,$4(a0,d3.w)
L259A2	suba.w	#$10,a0
	dbra	d1,L25968
	dc.w	$0679,$0001,$0001,$8A9C
	dc.w	$0C79,$0007,$0001,$8A9C
	beq.w	L25A62
	dc.w	$3039,$0001,$8A98
	mulu.w	#$10,d0
	movea.l	#$18A18,a0
	adda.w	d0,a0
	cmpi.w	#$4,$4(a0)
	beq.w	L259E4
	cmpi.w	#$4,$6(a0)
	bne.w	rtss2
L259E4	dc.w	$0C79,$0003,$0001,$8A9E
	bge.w	L25A62
	bsr.w	GetShifter
	movea.l	#$18A18,a0
	moveq	#$10,d3
	mulu.w	d1,d3
	adda.w	d3,a0
L25A00	dc.w	$B279,$0001,$8A98
	beq.w	L25A48
	cmpi.w	#$4,$4(a0)
	beq.w	L25A48
	cmpi.w	#$4,$6(a0)
	beq.w	L25A48
	addi.w	#$1,$4(a0)
	move.l	#$C8,d0
	jsr	(randomd0).l
	andi.w	#$1,d0
	beq.w	L25A00
	subi.w	#$1,$4(a0)
	addi.w	#$1,$6(a0)
	bra.w	L25A00
L25A48	suba.w	#$10,a0
	dbra	d1,L25A00
	movea.l	#$18D26,a3
	bsr.w	WritePassBits
	bset	#$2,$17F6E.l
L25A62	dc.w	$4279,$0001,$8A9C
	bsr.w	GetShifter
	movea.l	#$18A18,a0
	moveq	#$10,d3
	mulu.w	d1,d3
	adda.w	d3,a0
	clr.w	d3
L25A7A	cmpi.w	#$4,$4(a0)
	beq.w	L25A86
	bset	d1,d3
L25A86	clr.w	$4(a0)
	clr.w	$6(a0)
	suba.w	#$10,a0
	dbra	d1,L25A7A
	moveq	#$1,d1
	asl.w	d2,d1
	subi.w	#$1,d1
	dc.w	$C379,$0001,$8AA4
	asl.w	d2,d3
	dc.w	$8779,$0001,$8AA4
	dc.w	$0679,$0001,$0001,$8A9E
	rts
L25AB6	clr.w	d3
L25AB8	move.w	$A(a0),d0
	cmp.w	$C(a0),d0
	bhi.w	L25AC6
	bset	d1,d3
L25AC6	btst	#$0,$E(a0)
	beq.w	L25AD2
	bchg	d1,d3
L25AD2	suba.w	#$10,a0
	dbra	d1,L25AB8
	moveq	#$1,d1
	asl.w	d2,d1
	subi.w	#$1,d1
	dc.w	$C379,$0001,$8AA4
	asl.w	d2,d3
	dc.w	$8779,$0001,$8AA4
	dc.w	$0679,$0001,$0001,$8A9E
	rts
ShowThreeStars
	dc.w	$0C79,$0040,$0001,$806E
	bgt.w	rtss2
	bset	#$7,$17F68.l
	bne.w	rtss2
	movem.l	d0/a1,-(sp)
	bset	#$3,(disflags).l
	move.w	(ScoutSubStatus).l,d0
L25B24	cmp.w	(ScoutSubStatus).l,d0
	beq.w	L25B24
	movem.l	(sp)+,d0/a1
	movem.l	d0-d5/a0-a4,-(sp)
	jsr	(printz).l
	String	CC_Font1Pri,$2,$E
	moveq	#$1C,d0
	moveq	#$9,d1
	jsr	(Framer).l
	jsr	(printz).l
	String	CC_Font1Pri,$9,$10,'Stars of the Game',CC_Font1Pri,$3,$F
	movea.l	$47D18.l,a1
	movea.l	#$1B008,a2
	adda.l	$4(a1),a1
	moveq	#$D,d0
	moveq	#$5B,d1
	moveq	#$6,d2
	moveq	#$4,d3
	dc.w	$3839,$0001,$8D48
	clr.w	d5
	jsr	(dobitmap).l
	bsr.w	CalcStarScores
	move.w	#$12,(printy).l
	moveq	#$2,d2
L25BA0	bsr.w	TakeTopStarScore
	move.w	#$1A,(printx).l
	addi.w	#$1,(printy).l
	movea.l	$1E(a2),a1
	adda.w	$4(a1),a1
	adda.w	(a1),a1
	jsr	(print).l
	bsr.w	Sub_4112E
	move.w	#$3,(printx).l
	jsr	(print).l
	dbra	d2,L25BA0
	dc.w	$3039,$0001,$8358
	dc.w	$9079,$0001,$86BE
	ble.w	L25BF4
	move.w	#$F,-(sp)
	jsr	(sfx).l
L25BF4	movem.l	(sp)+,d0-d5/a0-a4
	rts
TakeTopStarScore
	movem.l	d1-d2/a1/a4,-(sp)
	movea.l	#ThreeStars,a4
	clr.l	d0
	moveq	#$33,d2
L25C08	cmp.l	(a4)+,d0
	bge.w	L25C14
	lea.l	-$4(a4),a1
	move.l	(a1),d0
L25C14	dbra	d2,L25C08
	clr.l	(a1)
	move.l	a1,d0
	subi.l	#$BC000,d0
	lsr.w	#$2,d0
	movea.l	#tmstruct,a2
	cmpi.w	#$1A,d0
	blt.w	L25C3A
	subi.w	#$1A,d0
	adda.w	#$366,a2
L25C3A	movem.l	(sp)+,d1-d2/a1/a4
	rts
CalcStarScores
	movea.l	#ThreeStars,a4
	jsr	(GetPeriodTime).l
	move.w	d0,d5
	add.w	d2,d5
	movea.l	#tmstruct,a2
	lea.l	$366(a2),a3
	bsr.w	CalcTeamStarScores
	movea.l	a3,a2
	lea.l	-$366(a2),a3
	bsr.w	CalcTeamStarScores
	cmpi.w	#$3,$180E4.l
	bne.w	L25CAA
	tst.w	d3
	beq.w	L25CAA
	dc.w	$207C,$0001,$80EC
	dc.w	$D0F9,$0001,$80F0
	clr.w	d0
	btst	#$7,$2(a0)
	beq.w	L25C96
	addi.w	#$1A,d0
L25C96	add.b	$3(a0),d0
	asl.w	#$2,d0
	movea.l	#ThreeStars,a0
	move.l	#$7FFFFFFF,(a0,d0.w)
L25CAA	rts
CalcTeamStarScores
	movea.l	a2,a1
	move.w	$C(a2),d3
	sub.w	$C(a3),d3
	ext.l	d3
	moveq	#$19,d4
	jsr	(GetGoalieCount).l
	neg.w	d0
	add.w	d4,d0
L25CC4	move.l	d3,(a4)
	cmp.w	d0,d4
	bhi.w	L25D06
	clr.w	d1
	move.b	$B6(a2),d1
	mulu.w	#$2AF8,d1
	add.l	d1,(a4)
	clr.w	d1
	move.b	$D0(a2),d1
	mulu.w	#$2774,d1
	add.l	d1,(a4)
	clr.w	d1
	move.b	$EA(a2),d1
	mulu.w	#$A,d1
	tst.w	d3
	bne.w	L25D00
	mulu.w	#$64,d1
	add.l	d1,(a4)
	clr.l	d1
	add.w	$138(a1),d1
L25D00	add.l	d1,(a4)
	bra.w	L25D3E
L25D06	cmp.w	$138(a1),d5
	bhi.w	L25D3E
	clr.w	d1
	move.b	$B6(a2),d1
	mulu.w	#$64,d1
	clr.w	d2
	move.b	$EA(a2),d2
	beq.w	L25D3E
	divu.w	d2,d1
	cmpi.w	#$4,d1
	bhi.w	L25D3E
	addi.l	#$7D00,(a4)
	tst.w	d1
	bne.w	L25D3E
	addi.l	#$124F8,(a4)
L25D3E	adda.w	#$2,a1
	adda.w	#$1,a2
	adda.w	#$4,a4
	dbra	d4,L25CC4
	rts
	movem.l	d0-d2/a0-a4,-(sp)
	jsr	(printz).l
	String	CC_Font1Pri,$B,$3
	moveq	#$12,d0
	moveq	#$5,d1
	jsr	(Framer).l
	btst	#$5,$17F7A.l
	bne.w	L25DA4
	jsr	(printz).l
	dc.w	$0024
	dc.b	$BF,$0C,$04,$49,$6E,$6A,$75,$72,$79,$20,$74,$6F,$3A,$BF,$0C,$06,$4F,$75,$74,$20,$66,$6F,$72,$20,$70,$65,$72,$69,$6F,$64,$BF,$0C,$05,$00
	bra.w	L25DCC
L25DA4	jsr	(printz).l
	dc.w	$0022
	dc.b	$BF,$0C,$04,$49,$6E,$6A,$75,$72,$79,$20,$74,$6F,$3A,$BF,$0C,$06,$4F,$75,$74,$20,$66,$6F,$72,$20,$67,$61,$6D,$65,$BF,$0C,$05,$00
L25DCC	bsr.w	Sub_4116C
	jsr	(print).l
	btst	#$0,$17BE3.l
	beq.w	L25DF6
	jsr	(printz).l
	String	CC_Font1Pri,$14,$6,'the game'
L25DF6	movem.l	(sp)+,d0-d2/a0-a4
	rts
	bset	#$7,$17F78.l
	btst	#$0,$17F78.l
	beq.w	L25E16
	jmp	(ShootoutModeBox).l
L25E16	movem.l	d0-d2/a0-a4,-(sp)
	move.w	#$FFFF,d0
	jsr	(prefmes).l
	jsr	(printz).l
	String	CC_Font1Pri,$3,$2
	moveq	#$1B,d0
	moveq	#$8,d1
	jsr	(Framer).l
	dc.w	$43FA,$00A8
	jsr	(printbig).l
	dc.w	$3039,$0001,$9368
	asl.w	#$7,d0
	dc.w	$247C,$0001,$7480
	adda.w	d0,a2
	clr.w	d0
	move.b	$66(a2),d0
	movea.l	#tmstruct,a2
	dc.w	$4A79,$0001,$9366
	beq.w	L25E70
	movea.l	#awtmstruct,a2
L25E70	bsr.w	FormatPlayerNumInitial
	jsr	(print).l
	jsr	(printz).l
	String	CC_Font1Pri,$4,$7
	movem.l	a1/a3,-(sp)
	dc.w	$3039,$0001,$9372
	dc.w	$227C,$0004,$165C
	adda.w	(a1,d0.w),a1
	lea.l	$2(a1),a1
	jsr	(print).l
	movem.l	(sp)+,a1/a3
	jsr	(printz).l
	String	' by',CC_Font1Pri,$4,$8
	move.w	$19370.l,d0
	movea.l	#awtmstruct,a2
	dc.w	$4A79,$0001,$9366
	beq.w	L25ED2
	movea.l	#tmstruct,a2
L25ED2	jsr	(FormatPlayerNumInitial).l
	jsr	(print).l
	movem.l	(sp)+,d0-d2/a0-a4
	rts
ShowGoalBox
	dc.w	$0016,$BF04
	bchg	d1,(a0)
	dc.w	$454E,$414C,$5459,$2053,$484F,$5421,$BF04,$0500
Sub_40EFA
	movem.l	d0-d2/a0-a4,-(sp)
	btst	#$2,$17F70.l
	beq.w	L25F12
	bset	#$2,$17F6C.l
L25F12	movea.l	#tmstruct,a2
	jsr	(lcfound_close).l
	adda.w	#$366,a2
	jsr	(lcfound_close).l
	dc.w	$287C,$0001,$80EC
	dc.w	$D8F9,$0001,$80F0
	jsr	(printz).l
	String	CC_Font1Pri,$B,$2
	moveq	#$13,d0
	move.w	#$5,d1
	tst.b	$4(a4)
	bmi.w	L25F5E
	addi.w	#$2,d1
	tst.b	$5(a4)
	bmi.w	L25F5E
	addi.w	#$1,d1
L25F5E	jsr	(Framer).l
	jsr	$25D8C.l
	movea.l	#tmstruct,a2
	move.w	$193AA.l,$17E98.l
	btst	#$7,$2(a4)
	beq.w	L25F92
	adda.w	#$366,a2
	move.w	$193AC.l,$17E98.l
L25F92	dc.w	$43FA,$0116
	bclr	#$0,$17F7E.l
	beq.w	L25FA6
	dc.w	$43FA,$0126
L25FA6	clr.w	d0
	move.b	$3(a4),d0
	addi.w	#$B6,d0
	cmpi.b	#$3,(a2,d0.w)
	bne.w	L25FF0
	movem.w	d1,-(sp)
	clr.w	d1
	move.b	$3(a4),d1
	cmp.w	$17E98.l,d1
	movem.w	(sp)+,d1
	blt.w	L25FF0
	adda.w	(a1),a1
	move.w	d0,-(sp)
	move.w	$2A(a2),d0
	cmp.w	(HomeTeam).l,d0
	bne.w	L25FEE
	move.w	#$0,d0
	jsr	(StartArenaAnim).l
L25FEE	move.w	(sp)+,d0
L25FF0	jsr	(printbig).l
	clr.w	d0
	move.b	$3(a4),d0
	move.w	d0,-(sp)
	move.w	#$C,(printx).l
	bsr.w	FormatPlayerName
	jsr	(print).l
	move.w	(sp)+,d0
	movem.w	d1,-(sp)
	clr.w	d1
	move.b	$3(a4),d1
	cmp.w	$17E98.l,d1
	movem.w	(sp)+,d1
	blt.w	L26030
	jsr	$2AA80.l
L26030	clr.w	d0
	move.b	$4(a4),d0
	bmi.w	L2609C
	bclr	#$5,$17F72.l
	bne.w	L2609C
	jsr	(printz).l
	String	CC_Font1Pri,$E,$6,'Assist by:',CC_Font1Pri,$C,$7
	move.w	d0,-(sp)
	bsr.w	FormatPlayerName
	jsr	(print).l
	move.w	(sp)+,d0
	jsr	$2AA6A.l
	clr.w	d0
	move.b	$5(a4),d0
	bmi.w	L2609C
	jsr	(printz).l
	String	CC_Font1Pri,$C,$8
	move.w	d0,-(sp)
	bsr.w	FormatPlayerName
	jsr	(print).l
	move.w	(sp)+,d0
	jsr	$2AA6A.l
L2609C	bclr	#$5,$17F72.l
	movem.l	(sp)+,d0-d2/a0-a4
	rts
	dc.w	$000E,$BF0F,$0347,$4F41,$4C21,$BF0C,$0500,$0012
	dc.w	$BF0C,$0348,$4154,$2054,$5249,$434B,$21BF,$0C05
	dc.w	$0010,$BF0D,$0350,$5020,$474F,$414C,$21BF,$0C05
	dc.w	$0012,$BF0C,$0348,$4154,$2054,$5249,$434B,$21BF
	dc.w	$0C05
	jsr	(printz).l
	String	CC_Font1,$B,$2
	moveq	#$13,d0
	moveq	#$8,d1
	move.l	#$7FF,d2
	jmp	(eraser).l
GetPlayerName
	movem.l	d0/a2,-(sp)
	movea.l	#tmstruct,a2
	dc.w	$3039,$0001,$80EE
	bpl.w	L26124
	andi.w	#$FF,d0
	adda.w	#$366,a2
L26124	bsr.w	Sub_4112E
	movem.l	(sp)+,d0/a2
	rts
Sub_4112E
	movem.l	d0-d3/a0/a2-a3,-(sp)
	bsr.w	L26290
	move.l	a0,-(sp)
	movea.l	#mesarea,a3
	move.w	#$4,(a3)
	lea.l	$2(a3),a1
	adda.w	(a0),a0
	move.b	(a0),d0
	bsr.w	ConvertByteToDigits
	jsr	(Sub_39200).l
	String	' '
	movea.l	(sp)+,a1
	jsr	(appstring).l
	movea.l	#mesarea,a1
	movem.l	(sp)+,d0-d3/a0/a2-a3
	rts
Sub_4116C
	movem.l	d0/a2,-(sp)
	movea.l	#tmstruct,a2
	dc.w	$3039,$0001,$80EE
	bpl.w	L26188
	andi.w	#$FF,d0
	adda.w	#$366,a2
L26188	bsr.w	FormatPlayerNumInitial
	movem.l	(sp)+,d0/a2
	rts
FormatPlayerNumInitial
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	L26290
	move.l	a0,-(sp)
	movea.l	#TextBuffer,a1
	adda.w	(a0),a0
	move.b	(a0),d0
	bsr.w	ConvertByteToDigits
	move.b	#$20,(a1)+
	movea.l	(sp)+,a0
	move.w	(a0)+,d0
	lea.l	-$2(a0,d0.w),a2
	move.b	(a0)+,(a1)+
	move.w	#$2E20,(a1)+
L261BC	cmpi.b	#$20,(a0)+
	bne.w	L261BC
L261C4	move.b	(a0)+,(a1)+
	cmpa.l	a0,a2
	bne.w	L261C4
	bsr.w	FinalizeTextBuffer
	movem.l	(sp)+,d0-d3/a0/a2
	rts
FormatPlayerName
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	L26290
	move.l	a0,-(sp)
	movea.l	#TextBuffer,a1
	adda.w	(a0),a0
	move.b	(a0),d0
	bsr.w	ConvertByteToDigits
	move.b	#$20,(a1)+
	movea.l	(sp)+,a0
	move.w	(a0)+,d0
	lea.l	-$2(a0,d0.w),a2
L261FA	cmpi.b	#$20,(a0)+
	bne.w	L261FA
L26202	move.b	(a0)+,(a1)+
	cmpa.l	a0,a2
	bne.w	L26202
	bsr.w	FinalizeTextBuffer
	movem.l	(sp)+,d0-d3/a0/a2
	rts
FormatPlayerNameLast
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	L26290
	movea.l	#TextBuffer,a1
	bra.w	FormatLastName
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	L26290
	movea.l	#TextBuffer,a1
	move.b	#$20,(a1)+
FormatLastName
	move.w	(a0)+,d0
	lea.l	-$2(a0,d0.w),a2
L2623E	cmpi.b	#$20,(a0)+
	bne.w	L2623E
L26246	move.b	(a0)+,(a1)+
	cmpa.l	a0,a2
	beq.w	L2625C
	tst.b	(a0)
	bne.w	L26246
	bra.w	L2625C
L26258	move.b	#$20,(a1)+
L2625C	cmpa.l	#$17F00,a1
	blt.w	L26258
	bsr.w	FinalizeTextBuffer
	movem.l	(sp)+,d0-d3/a0/a2
	rts
FinalizeTextBuffer
	move.l	a1,d0
	subi.l	#$17EF2,d0
	btst	#$0,d0
	beq.w	L26286
	clr.b	(a1)+
	addi.w	#$1,d0
L26286	movea.l	#mesarea,a1
	move.w	d0,(a1)
	rts
L26290	movea.l	$1E(a2),a0
	adda.w	$0(a0),a0
	bra.w	L262A2
L2629C	adda.w	(a0),a0
	adda.w	#$8,a0
L262A2	dbra	d0,L2629C
	rts
ConvertByteToDigits
	move.w	d0,-(sp)
	lsr.b	#$4,d0
	bne.w	L262B4
	move.b	#$F0,d0
L262B4	addi.b	#$30,d0
	move.b	d0,(a1)+
	move.w	(sp)+,d0
	andi.w	#$F,d0
	addi.b	#$30,d0
	move.b	d0,(a1)+
	rts
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_262C8.bin
updatecrowdf_cd0
	movep.w	$20C(a4),d0
	movep.w	$40C(a4),d1
	movep.w	$A0C(a4),d2
	movep.w	$80C(a4),d4
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_2655C.bin
