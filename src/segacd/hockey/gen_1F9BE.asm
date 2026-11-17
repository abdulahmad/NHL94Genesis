FallDown
	cmpi.w	#$B,$52(a2)
	bgt.w	rtss2
	cmpi.w	#$145C,$58(a2)
	beq.w	rtss2
	cmpi.w	#$1AF4,$58(a2)
	beq.w	rtss2
	cmpi.w	#$11E6,$58(a2)
	beq.w	rtss2
	cmpi.w	#$D26,$58(a2)
	beq.w	rtss2
	cmpi.w	#$DD8,$58(a2)
	beq.w	rtss2
	cmpi.w	#$136A,$58(a2)
	beq.w	rtss2
	cmpa.l	$1AD7E.l,a2
	bne.w	.l1FA1A
	cmpa.l	$1AD82.l,a3
	bne.w	.l1FA1A
	rts
.l1FA1A	move.l	a2,$1AD7E.l
	move.l	a3,$1AD82.l
	btst	#$3,$64(a2)
	bne.w	rtss2
	btst	#$3,$64(a3)
	bne.w	rtss2
	move.w	#$11E6,d1
	btst	#$4,$64(a3)
	bne.w	.l1FAC0
	cmpi.b	#$18,$71(a2)
	blt.w	.l1FAC0
	tst.b	$5F(a2)
	bne.w	.l1FAC0
.l1FA5A	btst	#$7,$FF800E.l
	bne.b	.l1FA5A
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.l1FA74	btst	#$6,$FF800E.l
	beq.b	.l1FA74
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l1FA94	btst	#$6,$FF800E.l
	bne.b	.l1FA94
	bclr	#$7,$FF800F.l
	andi.w	#$F,d0
	addi.w	#$10,d0
	cmp.w	$32(a2),d0
	ble.w	.l1FAC0
	move.b	#$3C,$5F(a2)
	bra.w	FallDownSub3
.l1FAC0	tst.w	$34(a3)
	beq.w	.l1FB08
	movea.l	#tmstruct,a0
	btst	#$6,$62(a3)
	beq.w	.l1FADC
	adda.w	#$366,a0
.l1FADC	addi.w	#$1,$10(a0)
	clr.w	d0
	move.b	$66(a3),d0
	adda.w	d0,a0
	addi.b	#$1,$11E(a0)
	addi.w	#$1,$180EC.l
	tst.b	$74(a3)
	bne.w	.l1FB08
	addi.w	#$2,$180EC.l
.l1FB08	move.b	#$78,$5E(a2)
	move.w	$0(a3),d0
	sub.w	$0(a2),d0
	move.w	$14(a3),d1
	sub.w	$14(a2),d1
	bsr.w	vtoa
	tst.w	$34(a2)
	beq.w	FallDownSub1
	jsr	$24FB4.l
	btst	#$4,$64(a2)
	beq.w	FallDownSub1
	movem.l	d1-d4,-(sp)
	move.w	$28(a2),d1
	bpl.w	.l1FB48
	neg.w	d1
.l1FB48	move.w	$2A(a2),d2
	bpl.w	.l1FB52
	neg.w	d2
.l1FB52	move.w	$0(a2),d3
	sub.w	$0(a3),d3
	move.w	$14(a2),d4
	sub.w	$14(a3),d4
	cmpi.w	#$108,$14(a3)
	bgt.w	.l1FBAC
	cmpi.w	#$FEF8,$14(a3)
	blt.w	.l1FBA2
	tst.w	$0(a3)
	bpl.w	.l1FB90
	tst.w	d3
	bpl.w	.l1FBB6
	cmpi.w	#$FFFD,d3
	bgt.w	.l1FBB6
	bra.w	.l1FBBE
.l1FB90	tst.w	d3
	bmi.w	.l1FBB6
	cmpi.w	#$3,d3
	blt.w	.l1FBB6
	bra.w	.l1FBBE
.l1FBA2	tst.w	d4
	bpl.w	.l1FBB6
	bra.w	.l1FBBE
.l1FBAC	tst.w	d4
	bmi.w	.l1FBB6
	bra.w	.l1FBBE
.l1FBB6	movem.l	(sp)+,d1-d4
	bra.w	FallDownSub1
.l1FBBE	movem.l	(sp)+,d1-d4
	bra.w	.l1FBC6
.l1FBC6	cmpi.w	#$10C,$14(a2)
	bgt.w	.l1FBF2
	cmpi.w	#$FEF4,$14(a2)
	blt.w	.l1FBF2
	cmpi.w	#$68,$0(a2)
	bgt.w	.l1FBF2
	cmpi.w	#$FF98,$0(a2)
	blt.w	.l1FBF2
	bra.w	FallDownSub1
.l1FBF2	cmpi.w	#$B,$52(a3)
	bgt.w	.l1FC2E
	addi.w	#$A,$17CD8.l
	addi.w	#$96,(Crowdlevel).l
	move.w	d1,-(sp)
	move.b	#$0,$40(a3)
	move.b	#$0,$65(a3)
	move.w	#$1AC2,d1
	jsr	(SetSPA).l
	clr.w	$28(a3)
	clr.w	$2A(a3)
	move.w	(sp)+,d1
.l1FC2E	movem.l	d0/a0,-(sp)
	cmpi.w	#$10C,$14(a2)
	bgt.w	.l1FC5E
	cmpi.w	#$FEF4,$14(a2)
	blt.w	.l1FC66
	tst.w	$0(a2)
	bmi.w	.l1FC56
	move.w	#$2,d0
	bra.w	.l1FC6A
.l1FC56	move.w	#$6,d0
	bra.w	.l1FC6A
.l1FC5E	move.w	#$0,d0
	bra.w	.l1FC6A
.l1FC66	move.w	#$4,d0
.l1FC6A	add.w	d0,d0
	movea.l	#$3AD3A,a0
	move.w	(a0,d0.w),d1
	move.w	$14(a2),$1937C.l
	move.w	$0(a2),$1937E.l
	cmpi.w	#$18CC,d1
	bne.w	.l1FCC6
	cmpi.w	#$59,$14(a2)
	bgt.w	.l1FCC6
	cmpi.w	#$FFA7,$14(a2)
	blt.w	.l1FCC6
	move.w	d0,-(sp)
	move.w	#$7,d0
	jsr	(StartArenaAnim).l
	move.w	(sp)+,d0
	move.w	#$193E,d1
	btst	#$3,$4(a2)
	beq.w	.l1FD1E
	move.w	#$1A00,d1
	bra.w	.l1FD1E
.l1FCC6	cmpi.w	#$17E8,d1
	bne.w	.l1FCF8
	cmpi.w	#$38,$14(a2)
	bgt.w	.l1FCF8
	cmpi.w	#$FFC8,$14(a2)
	blt.w	.l1FCF8
	move.w	#$1A00,d1
	btst	#$3,$4(a2)
	beq.w	.l1FD1E
	move.w	#$193E,d1
	bra.w	.l1FD1E
.l1FCF8	btst	#$3,$4(a2)
	beq.w	.l1FD1E
	cmpi.w	#$17E8,d1
	beq.w	.l1FD1A
	cmpi.w	#$18CC,d1
	bne.w	.l1FD1E
	move.w	#$17E8,d1
	bra.w	.l1FD1E
.l1FD1A	move.w	#$18CC,d1
.l1FD1E	clr.w	$28(a2)
	clr.w	$2A(a2)
	bset	#$5,$64(a2)
	bset	#$0,$62(a2)
	movem.l	(sp)+,d0/a0
	bra.w	FallDownSub2
FallDownTbl1	dc.w	$1776,$1776,$17E8,$17E8,$185A,$185A,$18CC,$18CC
FallDownSub1
	move.w	#$DD8,d1
	sub.w	$54(a2),d0
	addi.w	#$1,d0
	andi.w	#$7,d0
	cmpi.w	#$2,d0
	bls.w	FallDownSub3
	move.w	#$D26,d1
FallDownSub2
	move.w	$54(a2),d0
	andi.w	#$3,d0
	bne.w	FallDownSub3
	cmpi.b	#$14,$75(a3)
	blt.w	FallDownSub3
	cmpi.w	#$B,$52(a3)
	bgt.w	FallDownSub3
	btst	#$5,$64(a2)
	bne.w	FallDownSub3
	move.w	#$136A,d1
FallDownSub3
	exg.l	a2,a3
	bset	#$5,$62(a3)
	bsr.w	SetSPA
	exg.l	a2,a3
	tst.w	$34(a3)
	beq.w	.l1FDC2
	tst.w	$34(a2)
	beq.w	.l1FDC2
	addi.w	#$12C,(Crowdlevel).l
	addi.w	#$F,$17CD8.l
.l1FDC2	move.w	$17BE0.l,d0
	bmi.w	newcheck
	cmp.w	$52(a2),d0
	bne.w	newcheck
	st.b	$17BE0.l
	btst	#$4,$17F68.l
	bne.w	.l1FE72
	cmpi.w	#$DD8,$58(a2)
	bne.w	.l1FE72
	move.w	$54(a2),d0
	andi.w	#$3,d0
	bne.w	.l1FE72
	btst	#$4,$63(a2)
	bne.w	.l1FE72
	move.l	#$A0,d0
	bsr.w	randomd0
	cmp.w	$32(a2),d0
	bgt.w	.l1FE72
	btst	#$0,$17F68.l
	bne.w	.l1FE72
	exg.l	a2,a3
	move.w	#$145C,d1
	bsr.w	SetSPA
	exg.l	a2,a3
	bsr.w	setInjuryType
	btst	#$5,$17F7A.l
	bne.w	.l1FE4C
	exg.l	a2,a3
	move.w	#$1AF4,d1
	bsr.w	SetSPA
	exg.l	a2,a3
.l1FE4C	move.w	#$4,$1806A.l
	moveq	#$14,d0
	tst.w	$34(a3)
	beq.w	AddPenalty2
	tst.w	$18C08.l
	beq.w	AddPenalty2
	moveq	#$12,d0
	bsr.w	AddPenalty2
	bra.w	Stop4Pen
.l1FE72	move.w	#$B,-(sp)
	btst	#$6,$62(a2)
	bne.w	.l1FE84
	move.w	#$C,(sp)
.l1FE84	bsr.w	sfx
	rts
setInjuryType						;determines if injury will be for period or game. a2 = player injured, a3
									;= player checking. Marks a2 unavailable, pumps up the crowd, plays sfx
									;$D, locks the scroll on a2 and sets TempPlOffset (pnum, bit 15 set for
									;the away team). a2's tmpdst becomes $FFFD (injured for the period) or,
									;from a3's Fgt byte (getFgtbyte, chkFgtBit1), $FFFC (injured for the game,
									;sflags7 bit 5). Called from FallDown
	move.w	d0,-(sp)
	bset	#$2,$63(a2)
	addi.w	#$12C,(Crowdlevel).l		;pump up crowd
	addi.w	#$1E,$17CD8.l
	move.w	#$D,-(sp)
	bsr.w	sfx
	move.w	$0(a2),$17EDC.l		;move Xpos to scroll center
	move.w	$14(a2),$17EDE.l		;move Ypos to scroll center
	bset	#$6,$17F6A.l		;set sfslock (scroll lock)
	clr.w	d1
	movea.l	#tmstruct,a0		;move Home team Struct to a0
	btst	#$6,$62(a2)		;check if player home or away
	beq.w	.0
	move.w	#$8000,d1		;move $8000 into d1
	adda.w	#$366,a0		;add $364 to a0 (Away Team Struct start)
.0	move.b	$66(a2),d1		;move roster offset into d1
	move.w	d1,$180EE.l
	ext.w	d1		;sign extend - in this case just makes upper bye of word 00
	add.w	d1,d1		;add d1 to itself
	exg.l	a2,a3		;swap a2 and a3
	jsr	(getFgtbyte).l		;get the Fgt byte (divided by 4)
	exg.l	a2,a3
	tst.w	d0		;check if d0 is zero
	bne.w	.not0		;branch if H/F was more than 3
	bclr	#$5,$17F7A.l		;clear injury game bit
	move.w	#$FFFD,$68(a0,d1.w)		;update status of player
	bra.w	.exit
.not0	cmpi.w	#$3,d0		;compare d0 to 3 (if H/F was 12, d0 = 3)
	beq.w	.injurygame
	bclr	#$5,$17F7A.l
	move.w	#$FFFD,$68(a0,d1.w)		;update status of player
	jsr	$2AC46.l		;check Fgt bit 1 of player.
	beq.w	.exit		;jump if Fgt not 2,6,A
.injurygame	bset	#$5,$17F7A.l		;set injury game bit
	move.w	#$FFFC,$68(a0,d1.w)		;update status of player
.exit	move.w	(sp)+,d0
	rts
setInjuryTypeExit
	rts
checkwallcoll						;d2/d3 = x/y to test, a3 = object, wcradiusx/wcradiusy = radius. Check the
									;corner circles, the goals (checkgoal with a2 = SortCords+(13*SCstruct)
									;top, SortCords+(12*SCstruct) bottom) and then the side and end boards.
									;Calls wallcollb on a hit, with d0/d1 = cos/sin of the wall. Called from
									;checkcoll
	bclr	#$4,$64(a3)
	move.w	#$88,d4
	sub.w	$17CF4.l,d4
	move.w	#$12A,d5
	sub.w	$17CF6.l,d5
	movem.w	d2-d5,-(sp)
	neg.w	d4
	neg.w	d5
	addi.w	#$40,d4		;corner circle radius 64
	addi.w	#$40,d5
	cmp.w	d5,d3
	bgt.w	.0
	cmp.w	d4,d2
	blt.w	.1
	neg.w	d4
	cmp.w	d4,d2
	bgt.w	.1
	movea.l	#$17B00,a2
	bsr.w	.l2001C
	bra.w	.2
.0	neg.w	d5
	cmp.w	d5,d3
	blt.w	.2
	cmp.w	d4,d2
	blt.w	.1
	neg.w	d4
	cmp.w	d4,d2
	bgt.w	.1
	movea.l	#$17A80,a2
	bsr.w	.l2001C
	bra.w	.2
.1	sub.w	d4,d2		;corner circle: d2/d3 = offset from the circle centre
	sub.w	d5,d3
	move.w	d3,d0
	move.w	d2,d1
	neg.w	d1
	muls.w	d3,d3
	muls.w	d2,d2
	add.l	d2,d3		;dist from dot
	cmpi.l	#$1000,d3		;inside the corner circle (64*64)
	bls.w	.2
	exg.l	d0,d3
	bsr.w	Sroot		;distance from the circle center
	exg.l	d0,d3
	ext.l	d0
	asl.l	#$8,d0
	divs.w	d3,d0
	ext.l	d1
	asl.l	#$8,d1
	divs.w	d3,d1
	bsr.w	wallcollb
.2	movem.w	(sp)+,d2-d5
	move.w	$4E(a3),d0		;wallcos: already hit
	or.w	$50(a3),d0
	bne.w	rtss2
	move.w	#$100,d0		;now check side walls
	clr.w	d1
	cmp.w	d5,d3
	bge.w	wallcollb
	neg.w	d5
	neg.w	d0
	cmp.w	d5,d3
	ble.w	wallcollb
	exg.l	d0,d1
	cmp.w	d4,d2
	bge.w	wallcollb
	neg.w	d4
	neg.w	d1
	cmp.w	d4,d2
	ble.w	wallcollb
	rts
.l2001C	cmpi.w	#$D,$18(a3)
	bgt.w	rtss2
	cmpi.w	#$E,$52(a3)
	bne.w	checkgoalp
	sub.w	$0(a2),d2
	moveq	#$10,d4
	add.w	$17CF4.l,d4
	cmp.w	d4,d2
	bgt.w	rtss2
	neg.w	d4
	cmp.w	d4,d2
	blt.w	rtss2
	sub.w	$14(a2),d3
	move.w	#$2,d5
	add.w	$17CF6.l,d5
	cmp.w	d5,d3
	bgt.w	rtss2
	neg.w	d5
	cmp.w	d5,d3
	blt.w	rtss2
	st.b	$17EEE.l
	cmpi.w	#$D,$24(a3)
	blt.w	.l20080
	move.w	$24(a3),$18(a3)
	bra.w	.l20192
.l20080	bclr	#$7,$62(a3)
	move.w	$17BE0.l,d0
	bmi.w	.l200C2
	st.b	$17BE0.l
	asl.w	#$7,d0
	movea.l	#$17480,a0
	move.b	#$8,$5E(a0,d0.w)
	move.w	$17B94.l,d1
	btst	#$7,$62(a0,d0.w)
	bne.w	.l200B6
	neg.w	d1
.l200B6	tst.w	d1
	bpl.w	.l200C2
	bset	#$7,$62(a3)
.l200C2	move.w	#$FF00,d0
	move.l	$14(a3),d1
	sub.l	$20(a3),d1
	asr.l	#$8,d1
	beq.w	.l201A0
	bmi.w	.l200DC
	neg.w	d0
	neg.w	d5
.l200DC	add.w	d3,d5
	move.l	$0(a3),d3
	sub.l	$1C(a3),d3
	asr.l	#$8,d3
	muls.w	d3,d5
	divs.w	d1,d5
	bvs.w	.l201A0
	sub.w	d5,d2
	cmp.w	d4,d2
	blt.w	.l201A0
	neg.w	d4
	cmp.w	d4,d2
	bgt.w	.l201A0
	clr.w	d1
	move.w	$14(a3),d3
	eor.w	d0,d3
	bmi.w	wallcoll
	neg.w	d0
	btst	#$7,$62(a3)
	bne.w	wallcoll
	cmpi.w	#$D,$18(a3)
	beq.w	.l20134
	subi.w	#$1,d4
	cmp.w	d4,d2
	bgt.w	.l20134
	neg.w	d4
	cmp.w	d4,d2
	bge.w	.l201B8
.l20134	bsr.w	ChkShotStat
	move.w	#$25,-(sp)
	btst	#$0,$17F68.l
	bne.w	.l2015C
	move.w	#$8,(sp)
	addi.w	#$12C,(Crowdlevel).l
	addi.w	#$28,$17CD8.l
.l2015C	bsr.w	sfx
	move.w	#$1000,d0
	bsr.w	randomd0
	tst.w	$14(a3)
	bmi.w	.l20172
	neg.w	d0
.l20172	move.w	d0,$2A(a3)
	move.w	#$1000,d0
	bsr.w	randomd0s
	move.w	d0,$28(a3)
	move.w	#$1000,d0
	bsr.w	randomd0s
	move.w	d0,$2C(a3)
	bra.w	puckflip
.l20192	neg.w	$2C(a3)
	bpl.w	rtss2
	neg.w	$2C(a3)
	rts
.l201A0	clr.w	d0
	move.w	#$100,d1
	move.w	$0(a3),d2
	sub.w	$1C(a3),d2
	bmi.w	wallcoll
	neg.w	d1
	bra.w	wallcoll
.l201B8	btst	#$2,$17F70.l
	beq.w	.l20250
	btst	#$0,$17F78.l
	bne.w	.l201F6
	movem.l	d0/a0,-(sp)
	move.w	$19368.l,d0
	asl.w	#$7,d0
	movea.l	#$17480,a0
	adda.w	d0,a0
	btst	#$7,$62(a0)
	movem.l	(sp)+,d0/a0
	bne.w	.l20200
	bra.w	.l2020E
.l201F6	tst.w	$1A436.l
	bne.w	.l2020E
.l20200	tst.w	$17B94.l
	bmi.w	rtss2
	bra.w	.l20218
.l2020E	tst.w	$17B94.l
	bpl.w	rtss2
.l20218	bset	#$5,$17F72.l
	tst.w	$1A436.l
	beq.w	.l20236
	addi.w	#$1,$1A418.l
	bra.w	.l2023E
.l20236	addi.w	#$1,$1A416.l
.l2023E	bset	#$0,$17F7C.l
	jsr	(EndPenaltyShotPlay).l
	bra.w	.l2025C
.l20250	btst	#$0,$17F68.l
	bne.w	rtss2
.l2025C	bset	#$0,$17F72.l
	bclr	#$3,$17F7C.l
	bsr.w	ChkShotStat
	jsr	$47DB0.l
	move.w	d0,-(sp)
	move.w	(ScoutSubStatus).l,d0
.l2027E	cmp.w	(ScoutSubStatus).l,d0
	beq.w	.l2027E
	move.w	(sp)+,d0
	move.w	#$0,-(sp)
	bsr.w	sfx
	jsr	(freezewindow).l
	addi.w	#$1F4,(Crowdlevel).l
	movea.l	#tmstruct,a2
	lea.l	$366(a2),a1
	tst.w	$14(a3)
	bpl.w	.l202B4
	exg.l	a1,a2
.l202B4	btst	#$1,$17F68.l
	beq.w	.l202C2
	exg.l	a1,a2
.l202C2	addi.w	#$1,$C(a2)
	btst	#$5,$17F72.l
	beq.w	.l202E6
	btst	#$0,$17F78.l
	bne.w	.l202E6
	addi.w	#$1,$364(a2)
.l202E6	bclr	#$4,$17F78.l
	beq.w	.l202F8
	addi.w	#$1,$35C(a2)
.l202F8	btst	#$5,$17F6C.l
	beq.w	.l2032E
	btst	#$6,$17F6C.l
	bne.w	.l20324
	cmpa.l	#$186B2,a2
	bne.w	.l2032E
.l2031A	addi.w	#$1,$358(a2)
	bra.w	.l2032E
.l20324	cmpa.l	#$1834C,a2
	beq.w	.l2031A
.l2032E	movem.l	d0/a2,-(sp)
	move.w	$180E4.l,d0
	add.w	d0,d0
	adda.w	d0,a2
	addi.w	#$1,$344(a2)
	movem.l	(sp)+,d0/a2
	bclr	#$7,$17F7C.l
	beq.w	.l20358
	addi.w	#$1,$360(a2)
.l20358	cmpa.l	#$1834C,a2
	bne.w	.l20384
	move.w	(HomeTeam).l,$1A56C.l
	move.w	#$3,$1A56E.l
	jsr	(ChooseSong).l
	move.w	$1A56A.l,-(sp)
	bsr.w	song
.l20384	cmpi.w	#$168,$180F0.l
	bne.w	.l20398
	subi.w	#$6,$180F0.l
.l20398	movea.l	#$180F2,a0
	adda.w	$180F0.l,a0
	addi.w	#$6,$180F0.l
	bsr.w	GetPeriodTimeRemaining
	move.w	d0,(a0)+
	moveq	#$2,d0
	add.w	$26(a2),d0
	sub.w	$26(a1),d0
	move.b	d0,(a0)+
	addi.w	#$1E,$17CD8.l
	cmpa.l	#$1834C,a2
	beq.w	.l203DE
	subi.w	#$14,$17CD8.l
	bset	#$7,-$1(a0)
.l203DE	move.w	$18(a2),d0
	move.b	d0,(a0)+
	move.w	#$FFFF,(a0)
	addi.w	#$B6,d0
	addi.b	#$1,(a2,d0.w)
	move.w	$1A(a2),d0
	bmi.w	.l2042A
	cmp.w	$18(a2),d0
	beq.w	.l2042A
	move.b	d0,(a0)+
	addi.w	#$D0,d0
	addi.b	#$1,(a2,d0.w)
	move.w	$1C(a2),d0
	bmi.w	.l2042A
	cmp.w	$18(a2),d0
	beq.w	.l2042A
	move.b	d0,(a0)
	addi.w	#$D0,d0
	addi.b	#$1,(a2,d0.w)
.l2042A	move.w	$28(a1),d0
	bmi.w	.l2043C
	addi.w	#$B6,d0
	addi.b	#$1,(a1,d0.w)
.l2043C	bsr.w	ChkShotStat
	bsr.w	PenGoalStuff
	bclr	#$3,$17F70.l
	bsr.w	printscores1
	move.w	#$2710,$17F82.l
	btst	#$0,$17F78.l
	beq.w	.l20468
	bra.w	.l2046E
.l20468	moveq	#$7,d0
	bsr.w	.l204DE
.l2046E	clr.w	$17EEE.l
	clr.w	$28(a3)
	clr.w	$2A(a3)
	moveq	#$6,d0
	tst.w	$0(a3)
	bpl.w	.l20488
	neg.w	d0
.l20488	move.w	d0,$0(a3)
	move.w	#$110,d0
	tst.w	$14(a3)
	bpl.w	.l2049A
	neg.w	d0
.l2049A	move.w	d0,$14(a3)
	move.w	#$600,$2C(a3)
	clr.w	$18(a3)
	st.b	$17E38.l
	st.b	$17E3C.l
	bset	#$2,$62(a3)
	move.w	#$1A,d0
	bsr.w	assreplace
	move.l	a3,-(sp)
	adda.w	#$80,a3
	move.w	#$102E,d1
	bsr.w	SetSPA
	movea.l	$22(a1),a3
	moveq	#$E,d0
	bsr.w	AddPenalty2
	movea.l	(sp)+,a3
	rts
.l204DE	move.l	a3,-(sp)
	movea.l	$22(a2),a3
	moveq	#$5,d3
.l204E6	tst.w	$34(a3)
	ble.w	.l20512
	btst	#$0,$63(a3)
	bne.w	.l20512
	bclr	#$2,$62(a3)
	bclr	#$3,$64(a3)
	beq.w	.l2050E
	jsr	(EndOneTimer).l
.l2050E	bsr.w	assexitSub1
.l20512	adda.w	#$80,a3
	dbra	d3,.l204E6
	movea.l	(sp)+,a3
	rts
GetPeriodTimeRemaining
	move.w	$180E4.l,d0
	swap	d0
	clr.w	d0
	lsr.l	#$2,d0
	or.w	$180EA.l,d0
	sub.w	$180E6.l,d0
	rts
checkgoalp	btst	#$5,$63(a3)
	bne.w	rtss2
	cmpi.w	#$A,$18(a3)
	bgt.w	rtss2
	cmpi.w	#$B,$52(a3)
	bgt.w	rtss2
	movem.w	d2-d3,-(sp)
	sub.w	$14(a2),d3
	move.w	d3,d0
	sub.w	$0(a2),d2
	move.w	d2,d1
	neg.w	d0
	asl.w	#$4,d2
	muls.w	d2,d2
	divu.w	#$400,d2
	cmpi.w	#$100,d2
	bhi.w	.l205CA
	asl.w	#$4,d3
	muls.w	d3,d3
	divu.w	#$79,d3
	add.w	d2,d3
	cmpi.w	#$100,d3
	bhi.w	.l205CA
	movem.w	(sp)+,d2-d3
	bsr.w	.l205D0
	movem.w	d2-d3,-(sp)
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	bsr.w	Sroot
	move.w	d0,d2
	movem.w	(sp)+,d0-d1
	addi.w	#$1,d2
	asl.l	#$8,d0
	divs.w	d2,d0
	asl.l	#$8,d1
	divs.w	d2,d1
	bset	#$4,(sflags6).l
	bsr.w	wallcoll
	bclr	#$4,(sflags6).l
.l205CA	movem.w	(sp)+,d2-d3
	rts
.l205D0	movem.l	d0-d1,-(sp)
.l205D4	btst	#$7,$FF800E.l
	bne.b	.l205D4
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.l205EE	btst	#$6,$FF800E.l
	beq.b	.l205EE
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l2060E	btst	#$6,$FF800E.l
	bne.b	.l2060E
	bclr	#$7,$FF800F.l
	andi.w	#$1F,d0
	bne.w	.l2066A
	move.w	$17B94.l,d0
	sub.w	$14(a2),d0
	cmpi.w	#$28,d0
	bgt.w	.l2066A
	cmpi.w	#$FFD8,d0
	blt.w	.l2066A
	move.w	$28(a3),d0
	move.w	$2A(a3),d1
	cmpi.w	#$2000,d0
	bgt.w	.l20670
	cmpi.w	#$E000,d0
	blt.w	.l20670
	cmpi.w	#$2000,d1
	bgt.w	.l20670
	cmpi.w	#$E000,d1
	blt.w	.l20670
.l2066A	movem.l	(sp)+,d0-d1
	rts
.l20670	adda.w	#$C,sp
	asr.w	#$2,d0
	asr.w	#$2,d1
	move.w	d0,$28(a2)
	move.w	d1,$2A(a2)
	clr.w	$28(a3)
	clr.w	$2A(a3)
	bset	#$6,$17F6A.l
	btst	#$0,$17F68.l
	bne.w	rtss2
	moveq	#$8,d0
	bra.w	AddPenalty2
wallcollb	cmpi.w	#$E,$52(a3)
	bne.w	wallcoll
	cmpi.w	#$1D,$18(a3)
	bgt.w	.l20714
	cmpi.w	#$12,$18(a3)
	bls.w	wallcoll
	cmpi.w	#$118,$14(a3)
	blt.w	.l20714
	cmpi.w	#$D,$0(a3)
	blt.w	wallcoll
	cmpi.w	#$F,$0(a3)
	bgt.w	wallcoll
	cmpi.w	#$FA0,$2A(a3)
	blt.w	wallcoll
	move.l	a3,-(sp)
	asr.w	$2A(a3)
	adda.w	#$80,a3
	move.w	#$1078,d1
	bsr.w	SetSPA
	movea.l	(sp)+,a3
	move.w	#$E,-(sp)
	bsr.w	sfx
	addi.w	#$258,(Crowdlevel).l
	addi.w	#$F,$17CD8.l
.l20714	bset	#$6,$17F6A.l
	bset	#$2,$62(a3)
	tst.w	$14(a3)
	bpl.w	.l20730
	ori.w	#$8000,$4(a3)
.l20730	clr.w	$86(a3)
	btst	#$0,$17F68.l
	bne.w	rtss2
	move.l	a3,-(sp)
	move.w	$17EC8.l,d0
	asl.w	#$7,d0
	movea.l	#$17480,a3
	adda.w	d0,a3
	moveq	#$6,d0
	bsr.w	AddPenalty2
	movea.l	(sp)+,a3
	rts
wallcoll						;d0 = cosine, d1 = sine of angle of incidence with wall, a3 = object.
									;Bounce a3 off the wall: the puck loses speed, flips and plays
									;sfx $28-$2B; a player sets the wall collision bit (unless sflags6 bit 4)
									;and plays SFXplayerwall on a hard hit. Called from checkgoal, checkgoalp
									;and wallcollb
	move.w	d0,$4E(a3)
	move.w	d1,$50(a3)
	movem.l	d2-d3,-(sp)
	movem.w	d0-d1,-(sp)
	muls.w	$2A(a3),d0
	muls.w	$28(a3),d1
	sub.l	d1,d0
	asr.l	#$8,d0
	move.w	d0,d2
	movem.w	(sp),d0-d1
	muls.w	$28(a3),d0
	muls.w	$2A(a3),d1
	add.l	d1,d0
	asr.l	#$8,d0
	move.w	d0,d3
	neg.w	d2
	cmpi.w	#$E,$52(a3)
	bne.w	.player
	bclr	#$4,$17F6C.l
	tst.w	d2
	bpl.w	.nocoll
	asr.w	#$2,d2		;reduce normal speed on puck
	cmpi.w	#$FC00,d2
	bgt.w	.pok
	move.w	#$800,d0
	bsr.w	randomd0
	neg.w	d0
	move.w	d0,$2C(a3)
	bsr.w	puckflip
	move.w	d2,d0		;sfx $28 + ((v1n >> 10) + 4) & 3
	asr.w	#$8,d0
	asr.w	#$2,d0
	addi.w	#$4,d0
	bpl.w	.sf0
	clr.w	d0
.sf0	andi.w	#$3,d0
	addi.w	#$28,d0
	move.w	d0,-(sp)
	bsr.w	sfx
.pok	move.w	d3,d0		;reduce tangent speed on puck
	asr.w	#$6,d0
	sub.w	d0,d3
	asr.w	#$1,d0
	sub.w	d0,d3
	bra.w	.noadd
.player	cmpi.w	#$3E8,d2
	bgt.w	.nocoll
	bclr	#$4,(sflags6).l		;set by checkgoalp
	bne.w	.0
	bset	#$4,$64(a3)		;set wall collision bit
.0	cmpi.w	#$F000,d2
	bgt.w	.nosfx
	cmpi.w	#$A,$32(a3)
	blt.w	.nosfx
	move.w	#$20,-(sp)
	bsr.w	sfx
.nosfx	asr.w	#$2,d2		;reduce normal speed on player to 1/4
	cmpi.w	#$FC7C,d2
	blt.w	.noadd
	move.w	#$FC18,d2
.noadd	movem.w	(sp),d0-d1		;rotate normal/tangent speeds (d2/d3) back into Xvel/Yvel
	movem.w	d2-d3,-(sp)
	muls.w	d0,d3
	muls.w	d1,d2
	sub.l	d2,d3
	asr.l	#$8,d3
	move.w	d3,$28(a3)
	movem.w	(sp)+,d2-d3
	movem.w	(sp),d0-d1
	muls.w	d1,d3
	muls.w	d0,d2
	add.l	d2,d3
	asr.l	#$8,d3
	move.w	d3,$2A(a3)
	tst.w	$2C(a3)
	bmi.w	.nocoll
	clr.w	$2C(a3)
.nocoll	adda.w	#$4,sp		;drop saved cos/sin
	movem.l	(sp)+,d2-d3
	rts
