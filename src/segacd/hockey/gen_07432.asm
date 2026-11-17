	move.w	#$F1F,d1
.l7436	add.b	(a0)+,d0
	dbra	d1,.l7436
	rts
	dc.w	$41F9,$0001,$93BC,$303C,$0F1F,$4281,$10C1,$51C8
	dc.w	$FFFC,$4E75
	movem.l	d0-d1/a0-a1,-(sp)
	movea.l	d0,a1
	adda.l	#$193BC,a1
	subq.l	#$1,d1
.l7460	move.b	(a1)+,(a0)+
	dbra	d1,.l7460
	movem.l	(sp)+,d0-d1/a0-a1
	rts
	movem.l	d0-d1/a0-a1,-(sp)
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst	#$5,$FF800F.l
	dc.w	$6706
	move.w	#$1,-(a6)
	dc.w	$6004
.l7488	move.w	#$0,-(a6)
.l748C	bclr	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	movea.l	d0,a1
	adda.l	#$193BC,a1
	subq.l	#$1,d1
.l74A6	move.b	(a0)+,(a1)+
	dbra	d1,.l74A6
	dc.w	$4A79,$0001,$93BA
	bmi.w	.l7508
	jsr	$2242A.l
	move.l	d0,$1A2DC.l
	move.w	#$0,d0
	lea.l	(ThreeStars).l,a0
	lea.l	(mesarea).l,a1
	jsr	$5F16.w
	bcs.w	.l7500
	move.w	#$5,d0
	lea.l	$2240C.l,a0
	jsr	$5F16.w
	move.w	#$4,d0
	lea.l	$2241C.l,a0
	lea.l	$193BC.l,a1
	jsr	$5F16.w
	bcc.w	.l7508
.l7500	dc.w	$33FC,$FFFF,$0001,$93BA
.l7508	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	dc.w	$670A
	bset	#$5,$FF800F.l
	dc.w	$6008
.l751E	bclr	#$5,$FF800F.l
.l7526	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	movem.l	(sp)+,d0-d1/a0-a1
	rts
Sub_22534
	bclr	#$6,(sflags6).l
L753C	movem.l	d0-d1/a0-a1,-(sp)
	asl.l	#$2,d0
	addi.l	#$0,d0
	movea.l	#$2266E,a1
	add.w	d1,d1
	move.w	(a1,d1.w),d1
	asl.w	#$2,d1
	ext.l	d1
	add.l	d1,d0
	dc.w	$223C,$0000,$0004
	btst	#$6,(sflags6).l
	beq.w	.l7576
	jsr	$2246C.l
	bra.w	.l757C
.l7576	jsr	$22452.l
.l757C	movem.l	(sp)+,d0-d1/a0-a1
	rts
Sub_22582
	bset	#$6,(sflags6).l
	bra.w	L753C
ReadCrowdRecord						;Read the 16 byte crowd record block of team d1 from save RAM
	
	
	bclr	#$6,(sflags6).l
L7596	movem.l	d0-d1/a0-a1,-(sp)
	move.l	d1,d0
	asl.w	#$4,d0
	addi.l	#$B60,d0
	dc.w	$223C,$0000,$0010
	btst	#$6,(sflags6).l
	beq.w	.l75C0
	jsr	$2246C.l
	bra.w	.l75C6
.l75C0	jsr	$22452.l
.l75C6	movem.l	(sp)+,d0-d1/a0-a1
	rts
Sub_225CC
	bset	#$6,(sflags6).l
	bra.w	L7596
Sub_225D8
	bclr	#$6,(sflags6).l
L75E0	movem.l	d0-d1/a0-a1,-(sp)
	move.l	d1,d0
	asl.w	#$4,d0
	addi.l	#$D20,d0
	dc.w	$223C,$0000,$0010
	btst	#$6,(sflags6).l
	beq.w	.l760A
	jsr	$2246C.l
	bra.w	.l7610
.l760A	jsr	$22452.l
.l7610	movem.l	(sp)+,d0-d1/a0-a1
	rts
Sub_22616
	bset	#$6,(sflags6).l
	bra.w	L75E0
Sub_22622
	bset	#$6,(sflags6).l
	bra.w	NameLogIO
ReadNameLog						;Read the user name log from save RAM at NameLogBase to namelog. Called
	
	bclr	#$6,(sflags6).l
NameLogIO						;A user record block: read or write (sflags6 bit 6)
	movem.l	d0-d7/a0-a6,-(sp)
	dc.w	$223C,$0000,$0080
	dc.w	$203C,$0000,$0DA0
	dc.w	$207C,$0001,$A2FC
	btst	#$6,(sflags6).l
	beq.w	.l7662
	jsr	$2246C.l
	bra.w	.l7668
.l7662	jsr	$22452.l
.l7668	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.w	$0000,$001A,$0034,$004E,$0068,$0082,$009C,$00B6
	dc.w	$00D0,$00EA,$0104,$011E,$0138,$0152,$016C,$0186
	dc.w	$01A0,$01BA,$01D4,$01EE,$0208,$0222,$023C,$0256
	dc.w	$0270,$028A,$02A4,$02BE,$02D8
puckvzadj						;set puckvz for a top shelf shot from the distance to the goal line ($108)
	
	movem.l	d0-d7/a0-a6,-(sp)
	dc.w	$3039,$0001,$7B94
	bpl.w	.l76B8
	neg.w	d0
.l76B8	subi.w	#$108,d0
	bpl.w	.l76C2
	neg.w	d0
.l76C2	swap	d0
	andi.l	#$FFFF0000,d0
	dc.w	$3239,$0001,$7BAA
	beq.w	.l7734
	bpl.w	.l76DA
	neg.w	d1
.l76DA	move.w	#$11,d2
	dc.w	$4A79,$0001,$8C20
	beq.w	.l76EC
	move.w	#$16,d2
.l76EC	divu.w	d1,d0
	andi.l	#$FFFF,d0
	divu.w	d2,d0
	tst.w	d0
	bne.w	.l7700
	move.w	#$1,d0
.l7700	move.l	#$A0000,d1
	move.w	d0,d3
	mulu.w	d2,d0
	divu.w	d0,d1
	move.w	d2,d4
	add.w	d2,d2
	add.w	d4,d2
	mulu.w	d3,d2
	cmpi.l	#$7FFF,d2
	blt.w	.l7722
	move.w	#$7FFF,d2
.l7722	add.w	d2,d1
	tst.w	d1
	bpl.w	.l772E
	move.w	#$7FFF,d1
.l772E	dc.w	$33C1,$0001,$7BAC
.l7734	movem.l	(sp)+,d0-d7/a0-a6
	rts
OneTimerPass						;One-timer pass: puckvz = sqrt(12 * onetimerheight), then puckvx / puckvy
	
	
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$C,d0
	dc.w	$3239,$0001,$937A
	mulu.w	d1,d0
	swap	d0
	andi.l	#$FFFF0000,d0
	jsr	(Sroot).l
	dc.w	$33C0,$0001,$7BAC
	ext.l	d0
	move.w	#$3,d4
	divu.w	d4,d0
	clr.l	d1
	dc.w	$3239,$0001,$9376
	dc.w	$9279,$0001,$7B80
	swap	d1
	tst.w	d0
	bne.w	.l7780
	move.w	#$1,d0
.l7780	divs.w	d0,d1
	dc.w	$33C1,$0001,$7BA8
	clr.l	d1
	dc.w	$3239,$0001,$9378
	dc.w	$9279,$0001,$7B94
	swap	d1
	divs.w	d0,d1
	dc.w	$33C1,$0001,$7BAA
	dc.w	$267C,$0001,$7B80
	dc.w	$3039,$0001,$7BAC
	jsr	(puckflip).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
OneTimerTarget						;One-timer pass target for receiver a3: an offset by facing from
	
	
	
	movem.l	d0-d7/a0-a6,-(sp)
	bclr	#$2,(sflags6).l
	tst.w	$34(a3)
	bne.w	.l77D6
	movea.l	#$22906,a0
	bra.w	.l780A
.l77D6	move.w	$14(a3),d0
	btst	#$7,$62(a3)
	bne.w	.l77E6
	neg.w	d0
.l77E6	bset	#$2,(sflags6).l
	dc.w	$207C,$0002,$28C6
	cmpi.w	#$58,d0
	blt.w	.l780A
	movea.l	#$228E6,a0
	bclr	#$2,(sflags6).l
.l780A	move.w	$54(a3),d0
	btst	#$7,$62(a3)
	bne.w	.l7820
	addi.w	#$4,d0
	andi.w	#$7,d0
.l7820	asl.w	#$2,d0
	move.w	(a0,d0.w),d1
	move.w	$2(a0,d0.w),d2
	cmpa.l	#$228E6,a0
	bne.w	.l785C
	move.w	$14(a3),d0
	bpl.w	.l783E
	neg.w	d0
.l783E	cmpi.w	#$8A,d0
	blt.w	.l785C
	move.w	$0(a3),d0
	bpl.w	.l7850
	neg.w	d0
.l7850	cmpi.w	#$37,d0
	bgt.w	.l785C
	move.w	#$103,d2
.l785C	btst	#$7,$62(a3)
	bne.w	.l786A
	neg.w	d1
	neg.w	d2
.l786A	move.w	#$A,d0
	jsr	(randomd0).l
	add.w	d0,d1
	move.w	#$A,d0
	jsr	(randomd0).l
	add.w	d0,d2
	dc.w	$33C1,$0001,$9376
	tst.w	$34(a3)
	beq.w	.l78BA
	sub.w	$0(a3),d1
	bmi.w	.l78AC
	subi.w	#$3C,d1
	bpl.w	.l78BA
	neg.w	d1
	dc.w	$D379,$0001,$9376
	bra.w	.l78BA
.l78AC	addi.w	#$3C,d1
	bmi.w	.l78BA
	dc.w	$9379,$0001,$9376
.l78BA	dc.w	$33C2,$0001,$9378
	movem.l	(sp)+,d0-d7/a0-a6
	rts
assonetimer						;Assignment $23 (asstab), player a3 shooting a one-timer: take control of
	
	
	
	ori.w	#$C2,$74(a4,d0.w)
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_078CC.bin
PuckOnAttackHalf						;d0 = 1 when the puck is on the half of the goal player a3 shoots at, else
	
	movem.w	d0-d1,-(sp)
	dc.w	$3039,$0001,$7B94
	btst	#$7,$62(a3)
	bne.w	.l7CBA
	neg.w	d0
.l7CBA	tst.w	d0
	bpl.w	Sub_22D1E
	bra.w	Sub_22D16
	dc.w	$3039,$0001,$7E2C,$0640,$0004,$0240,$0007,$322B
	dc.w	$0054,$B240,$6000,$0044,$6700,$0040,$0641,$0001
	dc.w	$0241,$0007,$B240,$6700,$0032,$0641,$0001,$0241
	dc.w	$0007,$B240,$6700,$0024,$0441,$0003,$0241,$0007
	dc.w	$B240,$6700,$0016,$0441,$0001,$0241,$0007,$6700
	dc.w	$000A
Sub_22D16
	move.w	#$0,d0
	bra.w	L7D22
Sub_22D1E
	move.w	#$1,d0
L7D22	movem.w	(sp)+,d0-d1
	rts
onetimershot						;Do the one-timer shot (doshot), credit the last two passers as the
	
	
	
	dc.w	$33FC,$0004,$0001,$7E2C
	jsr	(doshot).l
	movem.l	d0/a0,-(sp)
	movea.l	#tmstruct,a0
	btst	#$6,$62(a3)
	beq.w	.l7D4E
	lea.l	$366(a0),a0
.l7D4E	clr.w	d0
	move.b	$66(a3),d0
	move.w	$1A(a0),$1C(a0)
	move.w	$18(a0),$1A(a0)
	move.w	d0,$18(a0)
	bset	#$7,$17F7C.l
	addi.w	#$96,(Crowdlevel).l
	dc.w	$0679,$000A,$0001,$7CD8
	addi.w	#$1,$35E(a0)
	movem.l	(sp)+,d0/a0
	dc.w	$08F9,$0000,$0001,$7EC6
	bset	#$1,$63(a3)
	bset	#$1,(sflags6).l
	rts
CheckOneTimerFacing						;called from setonetimeranim. it does nothing, d0 and d1 are restored at
	
	movem.w	d0-d1,-(sp)
	neg.w	d0
	addi.w	#$8,d0
	andi.w	#$7,d0
	move.w	$54(a3),d1
	add.w	d0,d1
	andi.w	#$7,d1
	cmpi.w	#$4,d1
	bgt.w	.l7DCE
	move.w	$4(a3),d0
	eori.w	#$FFFF,d0
	andi.w	#$800,d0
	bra.w	.l7DD6
.l7DCE	move.w	$4(a3),d0
	andi.w	#$800,d0
.l7DD6	movem.w	(sp)+,d0-d1
	rts
	dc.w	$4E75
	rts
Set4WayPlayer						;unused: put player a3's number (SCnum) in the home or away nibble of
									;PadControlBits34 (unless PadControlBits is -1)
	dc.w	$0C79,$FFFF,$0001,$7DC8
	beq.w	.l7E36
	movem.l	d0-d2,-(sp)
	move.w	#$1,d0		;1 = home side code
	btst	#$6,$62(a3)		;away?
	beq.w	.l7E02
	move.w	#$2,d0
.l7E02	dc.w	$B079,$0001,$7FAA
	beq.w	.l7E18
	move.w	#$F,d1		;not pad 3: keep the low nibble, write the high
	move.w	#$4,d0		;shift 4: the high nibble
	bra.w	.l7E20
.l7E18	move.w	#$F0,d1		;keep the high nibble
	move.w	#$0,d0		;no shift: the low nibble
.l7E20	dc.w	$C379,$0001,$7DD6
	move.w	$52(a3),d1
	asl.w	d0,d1
	dc.w	$8379,$0001,$7DD6
	movem.l	(sp)+,d0-d2
.l7E36	rts
LoadCrowdRec						;CrowdRecord = the arena record of HomeTeam from save RAM (ReadCrowdRecord
	
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(HomeTeam).l,d1
	ext.l	d1
	movea.l	#ThreeStars,a0
	jsr	(ReadCrowdRecord).l
	move.b	$8(a0),d0
	beq.w	.none
	andi.w	#$FF,d0
	bra.w	.l7E64
.none	move.w	#$50,d0
.l7E64	dc.w	$33C0,$0001,$7F8E
	movem.l	(sp)+,d0-d7/a0-a6
	rts
Crowd_Noise						;The crowd meter each frame: crowd noise on / off (sflags5 bit 7) from
	
	
	
	btst	#$7,$17F6A.l
	bne.w	.ex1
	btst	#$0,$17F78.l
	bne.w	.ex1
	btst	#$0,$17F6E.l
	bne.w	.l7EBC
	btst	#$7,$17F74.l
	bne.w	.l7EF2
	dc.w	$4A79,$0001,$7F82
	beq.w	.l7EBE
	dc.w	$0479,$0001,$0001,$7F82
	bpl.w	.ex1
	dc.w	$4279,$0001,$7F82
.l7EBC	rts
.l7EBE	dc.w	$3039,$0001,$7F8E
	dc.w	$33C0,$0001,$7F90
	dc.w	$0479,$000B,$0001,$7F90
	subi.w	#$49,d0
	muls.w	d0,d0
	asr.l	#$2,d0
	addi.w	#$6,d0
	dc.w	$B079,$0001,$7CD8
	bgt.w	.ex1
	bset	#$7,$17F74.l
	rts
.l7EF2	dc.w	$3039,$0001,$7F90
	subi.w	#$41,d0
	muls.w	d0,d0
	asr.l	#$2,d0
	dc.w	$B079,$0001,$7CD8
	blt.w	.l7F12
	bclr	#$7,$17F74.l
.l7F12	dc.w	$9F79,$0001,$7F84
	bpl.w	.ex1
	dc.w	$33FC,$0014,$0001,$7F84
	addi.w	#$1,$17F86.l
	dc.w	$3039,$0001,$7CD8
	ext.l	d0
	asl.w	#$2,d0
	jsr	(Sroot).l
	addi.w	#$41,d0
	dc.w	$33C0,$0001,$7F8C
	dc.w	$B079,$0001,$7F92
	ble.w	.l7F56
	dc.w	$33C0,$0001,$7F92
.l7F56	dc.w	$3039,$0001,$7F8C
	dc.w	$B079,$0001,$7F8E
	blt.w	.stack
	bra.w	.stack
.stack	movem.l	d0-d7/a0-a6,-(sp)
	movem.l	(sp)+,d0-d7/a0-a6
.ex1	rts
stopna2						;Slow Xvel and Yvel of a3 toward 0 by $7D0. Called from goalieacc
	tst.w	$28(a3)
	bpl.w	.xp
	addi.w	#$7D0,$28(a3)
	bmi.w	.y
	clr.w	$28(a3)
.xp	subi.w	#$7D0,$28(a3)
	bpl.w	.y
	clr.w	$28(a3)
.y	tst.w	$2A(a3)
	bpl.w	.yp
	addi.w	#$7D0,$2A(a3)
	bmi.w	.ex
	clr.w	$2A(a3)
.yp	subi.w	#$7D0,$2A(a3)
	bpl.w	.ex
	clr.w	$2A(a3)
.ex	rts
checkcornercoll						;210 = blue line to the end of the rink, corner radius 64. Corner circles
	
	
	bclr	#$4,$64(a3)
	move.w	#$88,d4
	dc.w	$9879,$0001,$7CF4
	move.w	#$12A,d5
	dc.w	$9A79,$0001,$7CF6
	movem.w	d2-d5,-(sp)
	neg.w	d4
	neg.w	d5
	addi.w	#$40,d4
	addi.w	#$40,d5
	cmp.w	d5,d3
	bgt.w	.ctc
	cmp.w	d4,d2
	blt.w	.circle
	neg.w	d4
	cmp.w	d4,d2
	bgt.w	.circle
	bra.w	.exit
.ctc	neg.w	d5
	cmp.w	d5,d3
	blt.w	.exit
	cmp.w	d4,d2
	blt.w	.circle
	neg.w	d4
	cmp.w	d4,d2
	bgt.w	.circle
	bra.w	.exit
.circle	sub.w	d4,d2
	sub.w	d5,d3
	move.w	d3,d0
	move.w	d2,d1
	neg.w	d1
	muls.w	d3,d3
	muls.w	d2,d2
	add.l	d2,d3
	cmpi.l	#$42,d3
	bls.w	.exit
	exg.l	d0,d3
	jsr	(Sroot).l
	exg.l	d0,d3
	ext.l	d0
	asl.l	#$8,d0
	divs.w	d3,d0
	ext.l	d1
	asl.l	#$8,d1
	divs.w	d3,d1
	bsr.w	.l8088
.exit	movem.w	(sp)+,d2-d5
	move.w	$4E(a3),d0
	or.w	$50(a3),d0
	bne.w	.rtss3
	move.w	#$100,d0
	clr.w	d1
	cmp.w	d5,d3
	bge.w	.l8088
	neg.w	d5
	neg.w	d0
	cmp.w	d5,d3
	ble.w	.l8088
	exg.l	d0,d1
	cmp.w	d4,d2
	bge.w	.l8088
	neg.w	d4
	neg.w	d1
	cmp.w	d4,d2
	ble.w	.l8088
.rtss3	rts
.l8088	jmp	$3B6A2.l
Create_HotCold_Table						;Fill the hot / cold table (tmHotCold) of team struct a0: 16 bytes for
	
	
	movem.l	d0-d7,-(sp)
	move.w	#$19F,d1
HotColdLoop						;The Create_HotCold_Table loop
	move.w	#$9,d0
	jsr	(randomd0s).l
	move.l	a0,-(sp)
	adda.l	#$1A4,a0
	move.b	d0,(a0,d1.w)
	movea.l	(sp)+,a0
	dbra	d1,HotColdLoop
	movem.l	(sp)+,d0-d7
	rts
Clamp0to100						;unused: clamp d3 to 0 ... 100
	tst.w	d3
	bpl.w	.chkmax
	clr.w	d3
	rts
.chkmax	cmpi.w	#$64,d3
	ble.w	.x
	move.w	#$64,d3
.x	rts
AttributeCalc						;Attribute d3 of player a3 * 5 plus his hot / cold value / 3, limited to 0
	
	movem.l	d0-d2/a1,-(sp)
	dc.w	$3239,$0001,$7E64
	movea.l	#tmstruct,a1
	btst	#$6,$62(a3)
	beq.w	.attribmath
	adda.l	#$366,a1
.attribmath	clr.w	d1
	move.b	$66(a3),d1
	asl.w	#$4,d1
	adda.l	#$1A4,a1
	move.b	(a1,d1.w),d1
	ext.w	d1
	ext.l	d1
	divs.w	#$3,d1
	move.w	d3,-(sp)
	asl.w	#$2,d3
	add.w	(sp)+,d3
	add.w	d1,d3
	bmi.w	.LowerLimit
	cmpi.w	#$1E,d3
	blt.w	.MaskAttribMathResult
	move.w	#$1E,d3
	bra.w	.MaskAttribMathResult
.LowerLimit	clr.w	d3
.MaskAttribMathResult	andi.w	#$FF,d3
	movem.l	(sp)+,d0-d2/a1
	rts
NextHomeHotPlayer						;d1 = the next home hot player (homehotidx index into the list at
	
	
	movem.l	d0/a0,-(sp)
	dc.w	$207C,$0001,$7EAE
	dc.w	$3039,$0001,$7EA6
	add.w	d0,d0
	move.w	(a0,d0.w),d1
	dc.w	$0C79,$0000,$0001,$7EA6
	bge.w	.x
	dc.w	$0679,$0001,$0001,$7EA6
.x	movem.l	(sp)+,d0/a0
	movea.l	#tmstruct,a1
	rts
NextAwayHotPlayer						;The same for the away team (awayhotplayer, awayhotidx), a1 = awtmstruct.
	
	movem.l	d0/a0,-(sp)
	dc.w	$207C,$0001,$7EAC
	dc.w	$3039,$0001,$7EA4
	add.w	d0,d0
	move.w	(a0,d0.w),d1
	dc.w	$0C79,$0000,$0001,$7EA4
	bge.w	.x
	dc.w	$0679,$0001,$0001,$7EA4
.x	movem.l	(sp)+,d0/a0
	movea.l	#awtmstruct,a1
	rts
	dc.w	$4E75
BuildHotColdLists						;Build the hot / cold player lists of both teams (SortHotColdStarters,
	
	dc.w	$4279,$0001,$7EA4
	dc.w	$4279,$0001,$7EA6
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a0
	bsr.w	SortHotColdStarters
	dc.w	$207C,$0001,$7EAE
	bsr.w	CopyHottestPlayer
	dc.w	$207C,$0001,$7EB2
	bsr.w	CopyColdestPlayer
	movea.l	#awtmstruct,a0
	bsr.w	SortHotColdStarters
	dc.w	$207C,$0001,$7EAC
	bsr.w	CopyHottestPlayer
	dc.w	$207C,$0001,$7EB0
	bsr.w	CopyColdestPlayer
	movem.l	(sp)+,d0-d7/a0-a6
	rts
SortHotColdStarters						;Sum the hot / cold values of the 6 starters of team a0 into TempBuffer
	
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	a0,a2
	adda.l	#$1A4,a2
	movea.l	$1E(a0),a0
	adda.w	$6(a0),a0
	movea.l	#TempBuffer,a1
	move.w	#$5,d0
.player	move.b	(a0)+,d1
	subi.b	#$1,d1
	move.b	d1,(a1)+
	ext.w	d1
	asl.w	#$4,d1
	clr.b	(a1)
	addi.w	#$3,d1
	move.w	#$3,d7
.attrib	clr.w	d2
	move.b	(a2,d1.w),d2
	cmpi.b	#$9,d7
	beq.w	.nextattr
	cmpi.b	#$D,d7
	beq.w	.nextattr
	add.b	d2,(a1)
.nextattr	addi.w	#$1,d1
	addi.w	#$1,d7
	cmpi.b	#$10,d7
	bne.w	.attrib
	tst.b	(a1)+
	dbra	d0,.player
.sort	movea.l	#TempBuffer,a1
	clr.w	d1
	move.w	#$4,d0
.cmp	move.b	$3(a1),d6
	cmp.b	$1(a1),d6
	ble.w	.next
	st.b	d1
	move.w	$2(a1),d2
	move.w	$0(a1),$2(a1)
	move.w	d2,$0(a1)
.next	tst.w	(a1)+
	dbra	d0,.cmp
	tst.w	d1
	bne.w	.sort
	movem.l	(sp)+,d0-d7/a0-a6
	rts
NextHomeColdPlayer						;d1 = the next home cold player (homecoldidx, homecoldplayer), a1 =
	
	movem.l	d0/a0,-(sp)
	dc.w	$207C,$0001,$7EB2
	move.w	$17EAA.l,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d1
	cmpi.w	#$0,$17EAA.l
	bge.w	.x
	addi.w	#$1,$17EAA.l
.x	movem.l	(sp)+,d0/a0
	movea.l	#tmstruct,a1
	rts
NextAwayColdPlayer						;The same for the away team (awaycoldidx, awaycoldplayer), a1 =
	
	
	movem.l	d0/a0,-(sp)
	dc.w	$207C,$0001,$7EB0
	move.w	$17EA8.l,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d1
	cmpi.w	#$0,$17EA8.l
	bge.w	.x
	addi.w	#$1,$17EA8.l
.x	movem.l	(sp)+,d0/a0
	movea.l	#awtmstruct,a1
	rts
	dc.w	$4E75
CopyHottestPlayer						;Copy the hottest player of TempBuffer to the list at a0
	movem.l	d0-d1/a0-a1,-(sp)
	movea.l	#TempBuffer,a1
	move.w	#$0,d0
.copy	clr.b	(a0)+
	move.b	(a1),d1
	move.b	d1,(a0)+
	tst.w	(a1)+
	dbra	d0,.copy
	movem.l	(sp)+,d0-d1/a0-a1
	rts
CopyColdestPlayer						;Copy the coldest player (TempBuffer+10) to the list at a0
	movem.l	d0/a0-a1,-(sp)
	movea.l	#$17E7A,a1
	move.w	#$0,d0
.copy	clr.b	(a0)+
	move.b	(a1),(a0)+
	tst.w	-(a1)
	dbra	d0,.copy
	movem.l	(sp)+,d0/a0-a1
	rts
	movem.l	d1-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a0
	bsr.w	GetHotColdTotal
	dc.w	$33C1,$0001,$7E62
	movea.l	#awtmstruct,a0
	bsr.w	GetHotColdTotal
	dc.w	$33C1,$0001,$7E64
	dc.w	$3239,$0001,$7E62
	dc.w	$3439,$0001,$7E64
	sub.w	d1,d2
	move.w	#$0,(awayhotter).l
	tst.w	d2
	bmi.w	.l8382
	move.w	#$1,(awayhotter).l
.l8382	tst.w	d2
	bpl.w	.l838A
	neg.w	d2
.l838A	move.w	#$FFFF,d0
	cmpi.w	#$5E,d2
	blt.w	.l83A6
	move.w	#$22,d0
	cmpi.w	#$BD,d2
	blt.w	.l83A6
	move.w	#$23,d0
.l83A6	movem.l	(sp)+,d1-d7/a0-a6
	rts
GetHotColdTotal						;d1 = the hot / cold total of the starters of
	
	bsr.w	SortHotColdStarters
	move.w	#$6,d0
	movea.l	#TempBuffer,a0
	clr.w	d1
.sum	move.b	$1(a0),d2
	ext.w	d2
	add.w	d2,d1
	tst.w	(a0)+
	dbra	d0,.sum
	rts
