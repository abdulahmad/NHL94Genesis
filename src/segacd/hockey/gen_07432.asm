	move.w	#$F1F,d1
L7436	add.b	(a0)+,d0
	dbra	d1,L7436
	rts
	dc.w	$41F9,$0001,$93BC,$303C,$0F1F,$4281,$10C1,$51C8
	dc.w	$FFFC,$4E75
	movem.l	d0-d1/a0-a1,-(sp)
	movea.l	d0,a1
	adda.l	#$193BC,a1
	subq.l	#$1,d1
L7460	move.b	(a1)+,(a0)+
	dbra	d1,L7460
	movem.l	(sp)+,d0-d1/a0-a1
	rts
	movem.l	d0-d1/a0-a1,-(sp)
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst	#$5,$FF800F.l
	dc.w	$6706
	move.w	#$1,-(a6)
	dc.w	$6004
L7488	move.w	#$0,-(a6)
L748C	bclr	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	movea.l	d0,a1
	adda.l	#$193BC,a1
	subq.l	#$1,d1
L74A6	move.b	(a0)+,(a1)+
	dbra	d1,L74A6
	dc.w	$4A79,$0001,$93BA
	bmi.w	L7508
	jsr	$2242A.l
	move.l	d0,$1A2DC.l
	move.w	#$0,d0
	lea.l	(ThreeStars).l,a0
	lea.l	(mesarea).l,a1
	jsr	$5F16.w
	bcs.w	L7500
	move.w	#$5,d0
	lea.l	$2240C.l,a0
	jsr	$5F16.w
	move.w	#$4,d0
	lea.l	$2241C.l,a0
	lea.l	$193BC.l,a1
	jsr	$5F16.w
	bcc.w	L7508
L7500	dc.w	$33FC,$FFFF,$0001,$93BA
L7508	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	dc.w	$670A
	bset	#$5,$FF800F.l
	dc.w	$6008
L751E	bclr	#$5,$FF800F.l
L7526	move.l	a6,$19360.l
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
	beq.w	L7576
	jsr	$2246C.l
	bra.w	L757C
L7576	jsr	$22452.l
L757C	movem.l	(sp)+,d0-d1/a0-a1
	rts
Sub_22582
	bset	#$6,(sflags6).l
	bra.w	L753C
ReadCrowdRecord
	bclr	#$6,(sflags6).l
L7596	movem.l	d0-d1/a0-a1,-(sp)
	move.l	d1,d0
	asl.w	#$4,d0
	addi.l	#$B60,d0
	dc.w	$223C,$0000,$0010
	btst	#$6,(sflags6).l
	beq.w	L75C0
	jsr	$2246C.l
	bra.w	L75C6
L75C0	jsr	$22452.l
L75C6	movem.l	(sp)+,d0-d1/a0-a1
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
	beq.w	L760A
	jsr	$2246C.l
	bra.w	L7610
L760A	jsr	$22452.l
L7610	movem.l	(sp)+,d0-d1/a0-a1
	rts
Sub_22616
	bset	#$6,(sflags6).l
	bra.w	L75E0
Sub_22622
	bset	#$6,(sflags6).l
	bra.w	NameLogIO
ReadNameLog
	bclr	#$6,(sflags6).l
NameLogIO
	movem.l	d0-d7/a0-a6,-(sp)
	dc.w	$223C,$0000,$0080
	dc.w	$203C,$0000,$0DA0
	dc.w	$207C,$0001,$A2FC
	btst	#$6,(sflags6).l
	beq.w	L7662
	jsr	$2246C.l
	bra.w	L7668
L7662	jsr	$22452.l
L7668	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.w	$0000,$001A,$0034,$004E,$0068,$0082,$009C,$00B6
	dc.w	$00D0,$00EA,$0104,$011E,$0138,$0152,$016C,$0186
	dc.w	$01A0,$01BA,$01D4,$01EE,$0208,$0222,$023C,$0256
	dc.w	$0270,$028A,$02A4,$02BE,$02D8
puckvzadj
	movem.l	d0-d7/a0-a6,-(sp)
	dc.w	$3039,$0001,$7B94
	bpl.w	L76B8
	neg.w	d0
L76B8	subi.w	#$108,d0
	bpl.w	L76C2
	neg.w	d0
L76C2	swap	d0
	andi.l	#$FFFF0000,d0
	dc.w	$3239,$0001,$7BAA
	beq.w	L7734
	bpl.w	L76DA
	neg.w	d1
L76DA	move.w	#$11,d2
	dc.w	$4A79,$0001,$8C20
	beq.w	L76EC
	move.w	#$16,d2
L76EC	divu.w	d1,d0
	andi.l	#$FFFF,d0
	divu.w	d2,d0
	tst.w	d0
	bne.w	L7700
	move.w	#$1,d0
L7700	move.l	#$A0000,d1
	move.w	d0,d3
	mulu.w	d2,d0
	divu.w	d0,d1
	move.w	d2,d4
	add.w	d2,d2
	add.w	d4,d2
	mulu.w	d3,d2
	cmpi.l	#$7FFF,d2
	blt.w	L7722
	move.w	#$7FFF,d2
L7722	add.w	d2,d1
	tst.w	d1
	bpl.w	L772E
	move.w	#$7FFF,d1
L772E	dc.w	$33C1,$0001,$7BAC
L7734	movem.l	(sp)+,d0-d7/a0-a6
	rts
OneTimerPass
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$C,d0
	dc.w	$3239,$0001,$937A
	mulu.w	d1,d0
	swap	d0
	andi.l	#$FFFF0000,d0
	dc.w	$4EB9,$0003,$708E
	dc.w	$33C0,$0001,$7BAC
	ext.l	d0
	move.w	#$3,d4
	divu.w	d4,d0
	clr.l	d1
	dc.w	$3239,$0001,$9376
	dc.w	$9279,$0001,$7B80
	swap	d1
	tst.w	d0
	bne.w	L7780
	move.w	#$1,d0
L7780	divs.w	d0,d1
	dc.w	$33C1,$0001,$7BA8
	clr.l	d1
	dc.w	$3239,$0001,$9378
	dc.w	$9279,$0001,$7B94
	swap	d1
	divs.w	d0,d1
	dc.w	$33C1,$0001,$7BAA
	dc.w	$267C,$0001,$7B80
	dc.w	$3039,$0001,$7BAC
	dc.w	$4EB9,$0003,$5EF8
	movem.l	(sp)+,d0-d7/a0-a6
	rts
OneTimerTarget
	movem.l	d0-d7/a0-a6,-(sp)
	bclr	#$2,(sflags6).l
	tst.w	$34(a3)
	bne.w	L77D6
	movea.l	#$22906,a0
	bra.w	L780A
L77D6	move.w	$14(a3),d0
	btst	#$7,$62(a3)
	bne.w	L77E6
	neg.w	d0
L77E6	bset	#$2,(sflags6).l
	dc.w	$207C,$0002,$28C6
	cmpi.w	#$58,d0
	blt.w	L780A
	movea.l	#$228E6,a0
	bclr	#$2,(sflags6).l
L780A	move.w	$54(a3),d0
	btst	#$7,$62(a3)
	bne.w	L7820
	addi.w	#$4,d0
	andi.w	#$7,d0
L7820	asl.w	#$2,d0
	move.w	(a0,d0.w),d1
	move.w	$2(a0,d0.w),d2
	cmpa.l	#$228E6,a0
	bne.w	L785C
	move.w	$14(a3),d0
	bpl.w	L783E
	neg.w	d0
L783E	cmpi.w	#$8A,d0
	blt.w	L785C
	move.w	$0(a3),d0
	bpl.w	L7850
	neg.w	d0
L7850	cmpi.w	#$37,d0
	bgt.w	L785C
	move.w	#$103,d2
L785C	btst	#$7,$62(a3)
	bne.w	L786A
	neg.w	d1
	neg.w	d2
L786A	move.w	#$A,d0
	dc.w	$4EB9,$0003,$7050
	add.w	d0,d1
	move.w	#$A,d0
	dc.w	$4EB9,$0003,$7050
	add.w	d0,d2
	dc.w	$33C1,$0001,$9376
	tst.w	$34(a3)
	beq.w	L78BA
	sub.w	$0(a3),d1
	bmi.w	L78AC
	subi.w	#$3C,d1
	bpl.w	L78BA
	neg.w	d1
	dc.w	$D379,$0001,$9376
	bra.w	L78BA
L78AC	addi.w	#$3C,d1
	bmi.w	L78BA
	dc.w	$9379,$0001,$9376
L78BA	dc.w	$33C2,$0001,$9378
	movem.l	(sp)+,d0-d7/a0-a6
	rts
assonetimer
	ori.w	#$C2,$74(a4,d0.w)
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_078CC.bin
PuckOnAttackHalf
	movem.w	d0-d1,-(sp)
	dc.w	$3039,$0001,$7B94
	btst	#$7,$62(a3)
	bne.w	L7CBA
	neg.w	d0
L7CBA	tst.w	d0
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
onetimershot
	dc.w	$33FC,$0004,$0001,$7E2C
	dc.w	$4EB9,$0003,$1528
	movem.l	d0/a0,-(sp)
	movea.l	#tmstruct,a0
	btst	#$6,$62(a3)
	beq.w	L7D4E
	lea.l	$366(a0),a0
L7D4E	clr.w	d0
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
CheckOneTimerFacing
	movem.w	d0-d1,-(sp)
	neg.w	d0
	addi.w	#$8,d0
	andi.w	#$7,d0
	move.w	$54(a3),d1
	add.w	d0,d1
	andi.w	#$7,d1
	cmpi.w	#$4,d1
	bgt.w	L7DCE
	move.w	$4(a3),d0
	eori.w	#$FFFF,d0
	andi.w	#$800,d0
	bra.w	L7DD6
L7DCE	move.w	$4(a3),d0
	andi.w	#$800,d0
L7DD6	movem.w	(sp)+,d0-d1
	rts
	dc.w	$4E75
	rts
Set4WayPlayer
	dc.w	$0C79,$FFFF,$0001,$7DC8
	beq.w	L7E36
	movem.l	d0-d2,-(sp)
	move.w	#$1,d0
	btst	#$6,$62(a3)
	beq.w	L7E02
	move.w	#$2,d0
L7E02	dc.w	$B079,$0001,$7FAA
	beq.w	L7E18
	move.w	#$F,d1
	move.w	#$4,d0
	bra.w	L7E20
L7E18	move.w	#$F0,d1
	move.w	#$0,d0
L7E20	dc.w	$C379,$0001,$7DD6
	move.w	$52(a3),d1
	asl.w	d0,d1
	dc.w	$8379,$0001,$7DD6
	movem.l	(sp)+,d0-d2
L7E36	rts
LoadCrowdRec
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(HomeTeam).l,d1
	ext.l	d1
	movea.l	#ThreeStars,a0
	jsr	(ReadCrowdRecord).l
	move.b	$8(a0),d0
	beq.w	L7E60
	andi.w	#$FF,d0
	bra.w	L7E64
L7E60	move.w	#$50,d0
L7E64	dc.w	$33C0,$0001,$7F8E
	movem.l	(sp)+,d0-d7/a0-a6
	rts
Crowd_Noise
	btst	#$7,$17F6A.l
	bne.w	L7F72
	btst	#$0,$17F78.l
	bne.w	L7F72
	btst	#$0,$17F6E.l
	bne.w	L7EBC
	btst	#$7,$17F74.l
	bne.w	L7EF2
	dc.w	$4A79,$0001,$7F82
	beq.w	L7EBE
	dc.w	$0479,$0001,$0001,$7F82
	bpl.w	L7F72
	dc.w	$4279,$0001,$7F82
L7EBC	rts
L7EBE	dc.w	$3039,$0001,$7F8E
	dc.w	$33C0,$0001,$7F90
	dc.w	$0479,$000B,$0001,$7F90
	subi.w	#$49,d0
	muls.w	d0,d0
	asr.l	#$2,d0
	addi.w	#$6,d0
	dc.w	$B079,$0001,$7CD8
	bgt.w	L7F72
	bset	#$7,$17F74.l
	rts
L7EF2	dc.w	$3039,$0001,$7F90
	subi.w	#$41,d0
	muls.w	d0,d0
	asr.l	#$2,d0
	dc.w	$B079,$0001,$7CD8
	blt.w	L7F12
	bclr	#$7,$17F74.l
L7F12	dc.w	$9F79,$0001,$7F84
	bpl.w	L7F72
	dc.w	$33FC,$0014,$0001,$7F84
	addi.w	#$1,$17F86.l
	dc.w	$3039,$0001,$7CD8
	ext.l	d0
	asl.w	#$2,d0
	dc.w	$4EB9,$0003,$708E
	addi.w	#$41,d0
	dc.w	$33C0,$0001,$7F8C
	dc.w	$B079,$0001,$7F92
	ble.w	L7F56
	dc.w	$33C0,$0001,$7F92
L7F56	dc.w	$3039,$0001,$7F8C
	dc.w	$B079,$0001,$7F8E
	blt.w	L7F6A
	bra.w	L7F6A
L7F6A	movem.l	d0-d7/a0-a6,-(sp)
	movem.l	(sp)+,d0-d7/a0-a6
L7F72	rts
stopna2
	tst.w	$28(a3)
	bpl.w	L7F8A
	addi.w	#$7D0,$28(a3)
	bmi.w	L7F98
	clr.w	$28(a3)
L7F8A	subi.w	#$7D0,$28(a3)
	bpl.w	L7F98
	clr.w	$28(a3)
L7F98	tst.w	$2A(a3)
	bpl.w	L7FAE
	addi.w	#$7D0,$2A(a3)
	bmi.w	L7FBC
	clr.w	$2A(a3)
L7FAE	subi.w	#$7D0,$2A(a3)
	bpl.w	L7FBC
	clr.w	$2A(a3)
L7FBC	rts
checkcornercoll
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
	bgt.w	L8000
	cmp.w	d4,d2
	blt.w	L801A
	neg.w	d4
	cmp.w	d4,d2
	bgt.w	L801A
	bra.w	L804E
L8000	neg.w	d5
	cmp.w	d5,d3
	blt.w	L804E
	cmp.w	d4,d2
	blt.w	L801A
	neg.w	d4
	cmp.w	d4,d2
	bgt.w	L801A
	bra.w	L804E
L801A	sub.w	d4,d2
	sub.w	d5,d3
	move.w	d3,d0
	move.w	d2,d1
	neg.w	d1
	muls.w	d3,d3
	muls.w	d2,d2
	add.l	d2,d3
	cmpi.l	#$42,d3
	bls.w	L804E
	exg.l	d0,d3
	dc.w	$4EB9,$0003,$708E
	exg.l	d0,d3
	ext.l	d0
	asl.l	#$8,d0
	divs.w	d3,d0
	ext.l	d1
	asl.l	#$8,d1
	divs.w	d3,d1
	bsr.w	L8088
L804E	movem.w	(sp)+,d2-d5
	move.w	$4E(a3),d0
	or.w	$50(a3),d0
	bne.w	L8086
	move.w	#$100,d0
	clr.w	d1
	cmp.w	d5,d3
	bge.w	L8088
	neg.w	d5
	neg.w	d0
	cmp.w	d5,d3
	ble.w	L8088
	exg.l	d0,d1
	cmp.w	d4,d2
	bge.w	L8088
	neg.w	d4
	neg.w	d1
	cmp.w	d4,d2
	ble.w	L8088
L8086	rts
L8088	jmp	$3B6A2.l
Create_HotCold_Table
	movem.l	d0-d7,-(sp)
	move.w	#$19F,d1
HotColdLoop
	move.w	#$9,d0
	dc.w	$4EB9,$0003,$7044
	move.l	a0,-(sp)
	adda.l	#$1A4,a0
	move.b	d0,(a0,d1.w)
	movea.l	(sp)+,a0
	dbra	d1,HotColdLoop
	movem.l	(sp)+,d0-d7
	rts
Clamp0to100
	tst.w	d3
	bpl.w	L80C2
	clr.w	d3
	rts
L80C2	cmpi.w	#$64,d3
	ble.w	L80CE
	move.w	#$64,d3
L80CE	rts
AttributeCalc
	movem.l	d0-d2/a1,-(sp)
	dc.w	$3239,$0001,$7E64
	movea.l	#tmstruct,a1
	btst	#$6,$62(a3)
	beq.w	L80F0
	adda.l	#$366,a1
L80F0	clr.w	d1
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
	bmi.w	L8126
	cmpi.w	#$1E,d3
	blt.w	L8128
	move.w	#$1E,d3
	bra.w	L8128
L8126	clr.w	d3
L8128	andi.w	#$FF,d3
	movem.l	(sp)+,d0-d2/a1
	rts
NextHomeHotPlayer
	movem.l	d0/a0,-(sp)
	dc.w	$207C,$0001,$7EAE
	dc.w	$3039,$0001,$7EA6
	add.w	d0,d0
	move.w	(a0,d0.w),d1
	dc.w	$0C79,$0000,$0001,$7EA6
	bge.w	L815C
	dc.w	$0679,$0001,$0001,$7EA6
L815C	movem.l	(sp)+,d0/a0
	movea.l	#tmstruct,a1
	rts
NextAwayHotPlayer
	movem.l	d0/a0,-(sp)
	dc.w	$207C,$0001,$7EAC
	dc.w	$3039,$0001,$7EA4
	add.w	d0,d0
	move.w	(a0,d0.w),d1
	dc.w	$0C79,$0000,$0001,$7EA4
	bge.w	L8192
	dc.w	$0679,$0001,$0001,$7EA4
L8192	movem.l	(sp)+,d0/a0
	movea.l	#awtmstruct,a1
	rts
	dc.w	$4E75
BuildHotColdLists
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
SortHotColdStarters
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	a0,a2
	adda.l	#$1A4,a2
	movea.l	$1E(a0),a0
	adda.w	$6(a0),a0
	movea.l	#TempBuffer,a1
	move.w	#$5,d0
L8210	move.b	(a0)+,d1
	subi.b	#$1,d1
	move.b	d1,(a1)+
	ext.w	d1
	asl.w	#$4,d1
	clr.b	(a1)
	addi.w	#$3,d1
	move.w	#$3,d7
L8226	clr.w	d2
	move.b	(a2,d1.w),d2
	cmpi.b	#$9,d7
	beq.w	L823E
	cmpi.b	#$D,d7
	beq.w	L823E
	add.b	d2,(a1)
L823E	addi.w	#$1,d1
	addi.w	#$1,d7
	cmpi.b	#$10,d7
	bne.w	L8226
	tst.b	(a1)+
	dbra	d0,L8210
L8254	movea.l	#TempBuffer,a1
	clr.w	d1
	move.w	#$4,d0
L8260	move.b	$3(a1),d6
	cmp.b	$1(a1),d6
	ble.w	L827C
	st.b	d1
	move.w	$2(a1),d2
	move.w	$0(a1),$2(a1)
	move.w	d2,$0(a1)
L827C	tst.w	(a1)+
	dbra	d0,L8260
	tst.w	d1
	bne.w	L8254
	movem.l	(sp)+,d0-d7/a0-a6
	rts
NextHomeColdPlayer
	movem.l	d0/a0,-(sp)
	dc.w	$207C,$0001,$7EB2
	move.w	$17EAA.l,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d1
	cmpi.w	#$0,$17EAA.l
	bge.w	L82B8
	addi.w	#$1,$17EAA.l
L82B8	movem.l	(sp)+,d0/a0
	movea.l	#tmstruct,a1
	rts
NextAwayColdPlayer
	movem.l	d0/a0,-(sp)
	dc.w	$207C,$0001,$7EB0
	move.w	$17EA8.l,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d1
	cmpi.w	#$0,$17EA8.l
	bge.w	L82EE
	addi.w	#$1,$17EA8.l
L82EE	movem.l	(sp)+,d0/a0
	movea.l	#awtmstruct,a1
	rts
	dc.w	$4E75
CopyHottestPlayer
	movem.l	d0-d1/a0-a1,-(sp)
	movea.l	#TempBuffer,a1
	move.w	#$0,d0
L830A	clr.b	(a0)+
	move.b	(a1),d1
	move.b	d1,(a0)+
	tst.w	(a1)+
	dbra	d0,L830A
	movem.l	(sp)+,d0-d1/a0-a1
	rts
CopyColdestPlayer
	movem.l	d0/a0-a1,-(sp)
	movea.l	#$17E7A,a1
	move.w	#$0,d0
L832A	clr.b	(a0)+
	move.b	(a1),(a0)+
	tst.w	-(a1)
	dbra	d0,L832A
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
	bmi.w	L8382
	move.w	#$1,(awayhotter).l
L8382	tst.w	d2
	bpl.w	L838A
	neg.w	d2
L838A	move.w	#$FFFF,d0
	cmpi.w	#$5E,d2
	blt.w	L83A6
	move.w	#$22,d0
	cmpi.w	#$BD,d2
	blt.w	L83A6
	move.w	#$23,d0
L83A6	movem.l	(sp)+,d1-d7/a0-a6
	rts
GetHotColdTotal
	bsr.w	SortHotColdStarters
	move.w	#$6,d0
	movea.l	#TempBuffer,a0
	clr.w	d1
L83BC	move.b	$1(a0),d2
	ext.w	d2
	add.w	d2,d1
	tst.w	(a0)+
	dbra	d0,L83BC
	rts
