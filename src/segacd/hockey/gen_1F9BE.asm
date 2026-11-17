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
	bne.w	.next
	cmpa.l	$1AD82.l,a3
	bne.w	.next
	rts
.next	move.l	a2,$1AD7E.l
	move.l	a3,$1AD82.l
	btst	#$3,$64(a2)
	bne.w	rtss2
	btst	#$3,$64(a3)
	bne.w	rtss2
	move.w	#$11E6,d1
	btst	#$4,$64(a3)
	bne.w	.next2
	cmpi.b	#$18,$71(a2)
	blt.w	.next2
	tst.b	$5F(a2)
	bne.w	.next2
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	andi.w	#$F,d0
	addi.w	#$10,d0
	cmp.w	$32(a2),d0
	ble.w	.next2
	move.b	#$3C,$5F(a2)
	bra.w	FallDownSub3
.next2	tst.w	$34(a3)
	beq.w	.next4
	movea.l	#tmstruct,a0
	btst	#$6,$62(a3)
	beq.w	.next3
	adda.w	#$366,a0
.next3	addi.w	#$1,$10(a0)
	clr.w	d0
	move.b	$66(a3),d0
	adda.w	d0,a0
	addi.b	#$1,$11E(a0)
	addi.w	#$1,$180EC.l
	tst.b	$74(a3)
	bne.w	.next4
	addi.w	#$2,$180EC.l
.next4	move.b	#$78,$5E(a2)
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
	bpl.w	.next5
	neg.w	d1
.next5	move.w	$2A(a2),d2
	bpl.w	.next6
	neg.w	d2
.next6	move.w	$0(a2),d3
	sub.w	$0(a3),d3
	move.w	$14(a2),d4
	sub.w	$14(a3),d4
	cmpi.w	#$108,$14(a3)
	bgt.w	.next9
	cmpi.w	#$FEF8,$14(a3)
	blt.w	.next8
	tst.w	$0(a3)
	bpl.w	.next7
	tst.w	d3
	bpl.w	.next10
	cmpi.w	#$FFFD,d3
	bgt.w	.next10
	bra.w	.next11
.next7	tst.w	d3
	bmi.w	.next10
	cmpi.w	#$3,d3
	blt.w	.next10
	bra.w	.next11
.next8	tst.w	d4
	bpl.w	.next10
	bra.w	.next11
.next9	tst.w	d4
	bmi.w	.next10
	bra.w	.next11
.next10	movem.l	(sp)+,d1-d4
	bra.w	FallDownSub1
.next11	movem.l	(sp)+,d1-d4
	bra.w	.next12
.next12	cmpi.w	#$10C,$14(a2)
	bgt.w	.next13
	cmpi.w	#$FEF4,$14(a2)
	blt.w	.next13
	cmpi.w	#$68,$0(a2)
	bgt.w	.next13
	cmpi.w	#$FF98,$0(a2)
	blt.w	.next13
	bra.w	FallDownSub1
.next13	cmpi.w	#$B,$52(a3)
	bgt.w	.next14
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
.next14	movem.l	d0/a0,-(sp)
	cmpi.w	#$10C,$14(a2)
	bgt.w	.next16
	cmpi.w	#$FEF4,$14(a2)
	blt.w	.next17
	tst.w	$0(a2)
	bmi.w	.next15
	move.w	#$2,d0
	bra.w	.next18
.next15	move.w	#$6,d0
	bra.w	.next18
.next16	move.w	#$0,d0
	bra.w	.next18
.next17	move.w	#$4,d0
.next18	add.w	d0,d0
	movea.l	#$3AD3A,a0
	move.w	(a0,d0.w),d1
	move.w	$14(a2),$1937C.l
	move.w	$0(a2),$1937E.l
	cmpi.w	#$18CC,d1
	bne.w	.next19
	cmpi.w	#$59,$14(a2)
	bgt.w	.next19
	cmpi.w	#$FFA7,$14(a2)
	blt.w	.next19
	move.w	d0,-(sp)
	move.w	#$7,d0
	jsr	(StartArenaAnim).l
	move.w	(sp)+,d0
	move.w	#$193E,d1
	btst	#$3,$4(a2)
	beq.w	.next22
	move.w	#$1A00,d1
	bra.w	.next22
.next19	cmpi.w	#$17E8,d1
	bne.w	.next20
	cmpi.w	#$38,$14(a2)
	bgt.w	.next20
	cmpi.w	#$FFC8,$14(a2)
	blt.w	.next20
	move.w	#$1A00,d1
	btst	#$3,$4(a2)
	beq.w	.next22
	move.w	#$193E,d1
	bra.w	.next22
.next20	btst	#$3,$4(a2)
	beq.w	.next22
	cmpi.w	#$17E8,d1
	beq.w	.next21
	cmpi.w	#$18CC,d1
	bne.w	.next22
	move.w	#$17E8,d1
	bra.w	.next22
.next21	move.w	#$18CC,d1
.next22	clr.w	$28(a2)
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
	beq.w	.next
	tst.w	$34(a2)
	beq.w	.next
	addi.w	#$12C,(Crowdlevel).l
	addi.w	#$F,$17CD8.l
.next	move.w	$17BE0.l,d0
	bmi.w	newcheck
	cmp.w	$52(a2),d0
	bne.w	newcheck
	st.b	$17BE0.l
	btst	#$4,$17F68.l
	bne.w	.next3
	cmpi.w	#$DD8,$58(a2)
	bne.w	.next3
	move.w	$54(a2),d0
	andi.w	#$3,d0
	bne.w	.next3
	btst	#$4,$63(a2)
	bne.w	.next3
	move.l	#$A0,d0
	bsr.w	randomd0
	cmp.w	$32(a2),d0
	bgt.w	.next3
	btst	#$0,$17F68.l
	bne.w	.next3
	exg.l	a2,a3
	move.w	#$145C,d1
	bsr.w	SetSPA
	exg.l	a2,a3
	bsr.w	setInjuryType
	btst	#$5,$17F7A.l
	bne.w	.next2
	exg.l	a2,a3
	move.w	#$1AF4,d1
	bsr.w	SetSPA
	exg.l	a2,a3
.next2	move.w	#$4,$1806A.l
	moveq	#$14,d0
	tst.w	$34(a3)
	beq.w	AddPenalty2
	tst.w	$18C08.l
	beq.w	AddPenalty2
	moveq	#$12,d0
	bsr.w	AddPenalty2
	bra.w	Stop4Pen
.next3	move.w	#$B,-(sp)
	btst	#$6,$62(a2)
	bne.w	.next4
	move.w	#$C,(sp)
.next4	bsr.w	sfx
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
	bsr.w	.next
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
	bsr.w	.next
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
.next	cmpi.w	#$D,$18(a3)
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
	blt.w	.next2
	move.w	$24(a3),$18(a3)
	bra.w	.next9
.next2	bclr	#$7,$62(a3)
	move.w	$17BE0.l,d0
	bmi.w	.next4
	st.b	$17BE0.l
	asl.w	#$7,d0
	movea.l	#$17480,a0
	move.b	#$8,$5E(a0,d0.w)
	move.w	$17B94.l,d1
	btst	#$7,$62(a0,d0.w)
	bne.w	.next3
	neg.w	d1
.next3	tst.w	d1
	bpl.w	.next4
	bset	#$7,$62(a3)
.next4	move.w	#$FF00,d0
	move.l	$14(a3),d1
	sub.l	$20(a3),d1
	asr.l	#$8,d1
	beq.w	.next10
	bmi.w	.next5
	neg.w	d0
	neg.w	d5
.next5	add.w	d3,d5
	move.l	$0(a3),d3
	sub.l	$1C(a3),d3
	asr.l	#$8,d3
	muls.w	d3,d5
	divs.w	d1,d5
	bvs.w	.next10
	sub.w	d5,d2
	cmp.w	d4,d2
	blt.w	.next10
	neg.w	d4
	cmp.w	d4,d2
	bgt.w	.next10
	clr.w	d1
	move.w	$14(a3),d3
	eor.w	d0,d3
	bmi.w	wallcoll
	neg.w	d0
	btst	#$7,$62(a3)
	bne.w	wallcoll
	cmpi.w	#$D,$18(a3)
	beq.w	.next6
	subi.w	#$1,d4
	cmp.w	d4,d2
	bgt.w	.next6
	neg.w	d4
	cmp.w	d4,d2
	bge.w	.next11
.next6	bsr.w	ChkShotStat
	move.w	#$25,-(sp)
	btst	#$0,$17F68.l
	bne.w	.next7
	move.w	#$8,(sp)
	addi.w	#$12C,(Crowdlevel).l
	addi.w	#$28,$17CD8.l
.next7	bsr.w	sfx
	move.w	#$1000,d0
	bsr.w	randomd0
	tst.w	$14(a3)
	bmi.w	.next8
	neg.w	d0
.next8	move.w	d0,$2A(a3)
	move.w	#$1000,d0
	bsr.w	randomd0s
	move.w	d0,$28(a3)
	move.w	#$1000,d0
	bsr.w	randomd0s
	move.w	d0,$2C(a3)
	bra.w	puckflip
.next9	neg.w	$2C(a3)
	bpl.w	rtss2
	neg.w	$2C(a3)
	rts
.next10	clr.w	d0
	move.w	#$100,d1
	move.w	$0(a3),d2
	sub.w	$1C(a3),d2
	bmi.w	wallcoll
	neg.w	d1
	bra.w	wallcoll
.next11	btst	#$2,$17F70.l
	beq.w	.next18
	btst	#$0,$17F78.l
	bne.w	.next12
	movem.l	d0/a0,-(sp)
	move.w	$19368.l,d0
	asl.w	#$7,d0
	movea.l	#$17480,a0
	adda.w	d0,a0
	btst	#$7,$62(a0)
	movem.l	(sp)+,d0/a0
	bne.w	.next13
	bra.w	.next14
.next12	tst.w	$1A436.l
	bne.w	.next14
.next13	tst.w	$17B94.l
	bmi.w	rtss2
	bra.w	.next15
.next14	tst.w	$17B94.l
	bpl.w	rtss2
.next15	bset	#$5,$17F72.l
	tst.w	$1A436.l
	beq.w	.next16
	addi.w	#$1,$1A418.l
	bra.w	.next17
.next16	addi.w	#$1,$1A416.l
.next17	bset	#$0,$17F7C.l
	jsr	(EndPenaltyShotPlay).l
	bra.w	.next19
.next18	btst	#$0,$17F68.l
	bne.w	rtss2
.next19	bset	#$0,$17F72.l
	bclr	#$3,$17F7C.l
	bsr.w	ChkShotStat
	jsr	$47DB0.l
	move.w	d0,-(sp)
	move.w	(ScoutSubStatus).l,d0
.loop	cmp.w	(ScoutSubStatus).l,d0
	beq.w	.loop
	move.w	(sp)+,d0
	move.w	#$0,-(sp)
	bsr.w	sfx
	jsr	(freezewindow).l
	addi.w	#$1F4,(Crowdlevel).l
	movea.l	#tmstruct,a2
	lea.l	$366(a2),a1
	tst.w	$14(a3)
	bpl.w	.next20
	exg.l	a1,a2
.next20	btst	#$1,$17F68.l
	beq.w	.next21
	exg.l	a1,a2
.next21	addi.w	#$1,$C(a2)
	btst	#$5,$17F72.l
	beq.w	.next22
	btst	#$0,$17F78.l
	bne.w	.next22
	addi.w	#$1,$364(a2)
.next22	bclr	#$4,$17F78.l
	beq.w	.next23
	addi.w	#$1,$35C(a2)
.next23	btst	#$5,$17F6C.l
	beq.w	.next25
	btst	#$6,$17F6C.l
	bne.w	.next24
	cmpa.l	#$186B2,a2
	bne.w	.next25
.loop2	addi.w	#$1,$358(a2)
	bra.w	.next25
.next24	cmpa.l	#$1834C,a2
	beq.w	.loop2
.next25	movem.l	d0/a2,-(sp)
	move.w	$180E4.l,d0
	add.w	d0,d0
	adda.w	d0,a2
	addi.w	#$1,$344(a2)
	movem.l	(sp)+,d0/a2
	bclr	#$7,$17F7C.l
	beq.w	.next26
	addi.w	#$1,$360(a2)
.next26	cmpa.l	#$1834C,a2
	bne.w	.next27
	move.w	(HomeTeam).l,$1A56C.l
	move.w	#$3,$1A56E.l
	jsr	(ChooseSong).l
	move.w	$1A56A.l,-(sp)
	bsr.w	song
.next27	cmpi.w	#$168,$180F0.l
	bne.w	.next28
	subi.w	#$6,$180F0.l
.next28	movea.l	#$180F2,a0
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
	beq.w	.next29
	subi.w	#$14,$17CD8.l
	bset	#$7,-$1(a0)
.next29	move.w	$18(a2),d0
	move.b	d0,(a0)+
	move.w	#$FFFF,(a0)
	addi.w	#$B6,d0
	addi.b	#$1,(a2,d0.w)
	move.w	$1A(a2),d0
	bmi.w	.next30
	cmp.w	$18(a2),d0
	beq.w	.next30
	move.b	d0,(a0)+
	addi.w	#$D0,d0
	addi.b	#$1,(a2,d0.w)
	move.w	$1C(a2),d0
	bmi.w	.next30
	cmp.w	$18(a2),d0
	beq.w	.next30
	move.b	d0,(a0)
	addi.w	#$D0,d0
	addi.b	#$1,(a2,d0.w)
.next30	move.w	$28(a1),d0
	bmi.w	.next31
	addi.w	#$B6,d0
	addi.b	#$1,(a1,d0.w)
.next31	bsr.w	ChkShotStat
	bsr.w	PenGoalStuff
	bclr	#$3,$17F70.l
	bsr.w	printscores1
	move.w	#$2710,$17F82.l
	btst	#$0,$17F78.l
	beq.w	.next32
	bra.w	.next33
.next32	moveq	#$7,d0
	bsr.w	.next36
.next33	clr.w	$17EEE.l
	clr.w	$28(a3)
	clr.w	$2A(a3)
	moveq	#$6,d0
	tst.w	$0(a3)
	bpl.w	.next34
	neg.w	d0
.next34	move.w	d0,$0(a3)
	move.w	#$110,d0
	tst.w	$14(a3)
	bpl.w	.next35
	neg.w	d0
.next35	move.w	d0,$14(a3)
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
.next36	move.l	a3,-(sp)
	movea.l	$22(a2),a3
	moveq	#$5,d3
.loop3	tst.w	$34(a3)
	ble.w	.next38
	btst	#$0,$63(a3)
	bne.w	.next38
	bclr	#$2,$62(a3)
	bclr	#$3,$64(a3)
	beq.w	.next37
	jsr	(EndOneTimer).l
.next37	bsr.w	AssistListPush
.next38	adda.w	#$80,a3
	dbra	d3,.loop3
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
	bhi.w	.next
	asl.w	#$4,d3
	muls.w	d3,d3
	divu.w	#$79,d3
	add.w	d2,d3
	cmpi.w	#$100,d3
	bhi.w	.next
	movem.w	(sp)+,d2-d3
	bsr.w	.next2
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
.next	movem.w	(sp)+,d2-d3
	rts
.next2	movem.l	d0-d1,-(sp)
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	andi.w	#$1F,d0
	bne.w	.next3
	move.w	$17B94.l,d0
	sub.w	$14(a2),d0
	cmpi.w	#$28,d0
	bgt.w	.next3
	cmpi.w	#$FFD8,d0
	blt.w	.next3
	move.w	$28(a3),d0
	move.w	$2A(a3),d1
	cmpi.w	#$2000,d0
	bgt.w	.next4
	cmpi.w	#$E000,d0
	blt.w	.next4
	cmpi.w	#$2000,d1
	bgt.w	.next4
	cmpi.w	#$E000,d1
	blt.w	.next4
.next3	movem.l	(sp)+,d0-d1
	rts
.next4	adda.w	#$C,sp
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
	bgt.w	.next
	cmpi.w	#$12,$18(a3)
	bls.w	wallcoll
	cmpi.w	#$118,$14(a3)
	blt.w	.next
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
.next	bset	#$6,$17F6A.l
	bset	#$2,$62(a3)
	tst.w	$14(a3)
	bpl.w	.next2
	ori.w	#$8000,$4(a3)
.next2	clr.w	$86(a3)
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
