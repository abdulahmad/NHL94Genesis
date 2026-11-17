Sub_3A9BE
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
	bne.w	L1FA1A
	cmpa.l	$1AD82.l,a3
	bne.w	L1FA1A
	rts
L1FA1A	move.l	a2,$1AD7E.l
	move.l	a3,$1AD82.l
	btst	#$3,$64(a2)
	bne.w	rtss2
	btst	#$3,$64(a3)
	bne.w	rtss2
	move.w	#$11E6,d1
	btst	#$4,$64(a3)
	bne.w	L1FAC0
	cmpi.b	#$18,$71(a2)
	blt.w	L1FAC0
	tst.b	$5F(a2)
	bne.w	L1FAC0
L1FA5A	btst	#$7,$FF800E.l
	bne.b	L1FA5A
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
L1FA74	btst	#$6,$FF800E.l
	beq.b	L1FA74
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1FA94	btst	#$6,$FF800E.l
	bne.b	L1FA94
	bclr	#$7,$FF800F.l
	andi.w	#$F,d0
	addi.w	#$10,d0
	cmp.w	$32(a2),d0
	ble.w	L1FAC0
	move.b	#$3C,$5F(a2)
	bra.w	Sub_3AD94
L1FAC0	tst.w	$34(a3)
	beq.w	L1FB08
	movea.l	#tmstruct,a0
	btst	#$6,$62(a3)
	beq.w	L1FADC
	adda.w	#$366,a0
L1FADC	addi.w	#$1,$10(a0)
	clr.w	d0
	move.b	$66(a3),d0
	adda.w	d0,a0
	addi.b	#$1,$11E(a0)
	dc.w	$0679,$0001,$0001,$80EC
	tst.b	$74(a3)
	bne.w	L1FB08
	dc.w	$0679,$0002,$0001,$80EC
L1FB08	move.b	#$78,$5E(a2)
	move.w	$0(a3),d0
	sub.w	$0(a2),d0
	move.w	$14(a3),d1
	sub.w	$14(a2),d1
	bsr.w	vtoa
	tst.w	$34(a2)
	beq.w	Sub_3AD4A
	jsr	$24FB4.l
	btst	#$4,$64(a2)
	beq.w	Sub_3AD4A
	movem.l	d1-d4,-(sp)
	move.w	$28(a2),d1
	bpl.w	L1FB48
	neg.w	d1
L1FB48	move.w	$2A(a2),d2
	bpl.w	L1FB52
	neg.w	d2
L1FB52	move.w	$0(a2),d3
	sub.w	$0(a3),d3
	move.w	$14(a2),d4
	sub.w	$14(a3),d4
	cmpi.w	#$108,$14(a3)
	bgt.w	L1FBAC
	cmpi.w	#$FEF8,$14(a3)
	blt.w	L1FBA2
	tst.w	$0(a3)
	bpl.w	L1FB90
	tst.w	d3
	bpl.w	L1FBB6
	cmpi.w	#$FFFD,d3
	bgt.w	L1FBB6
	bra.w	L1FBBE
L1FB90	tst.w	d3
	bmi.w	L1FBB6
	cmpi.w	#$3,d3
	blt.w	L1FBB6
	bra.w	L1FBBE
L1FBA2	tst.w	d4
	bpl.w	L1FBB6
	bra.w	L1FBBE
L1FBAC	tst.w	d4
	bmi.w	L1FBB6
	bra.w	L1FBBE
L1FBB6	movem.l	(sp)+,d1-d4
	bra.w	Sub_3AD4A
L1FBBE	movem.l	(sp)+,d1-d4
	bra.w	L1FBC6
L1FBC6	cmpi.w	#$10C,$14(a2)
	bgt.w	L1FBF2
	cmpi.w	#$FEF4,$14(a2)
	blt.w	L1FBF2
	cmpi.w	#$68,$0(a2)
	bgt.w	L1FBF2
	cmpi.w	#$FF98,$0(a2)
	blt.w	L1FBF2
	bra.w	Sub_3AD4A
L1FBF2	cmpi.w	#$B,$52(a3)
	bgt.w	L1FC2E
	dc.w	$0679,$000A,$0001,$7CD8
	addi.w	#$96,(Crowdlevel).l
	move.w	d1,-(sp)
	move.b	#$0,$40(a3)
	move.b	#$0,$65(a3)
	move.w	#$1AC2,d1
	jsr	(Sub_363C0).l
	clr.w	$28(a3)
	clr.w	$2A(a3)
	move.w	(sp)+,d1
L1FC2E	movem.l	d0/a0,-(sp)
	cmpi.w	#$10C,$14(a2)
	bgt.w	L1FC5E
	cmpi.w	#$FEF4,$14(a2)
	blt.w	L1FC66
	tst.w	$0(a2)
	bmi.w	L1FC56
	move.w	#$2,d0
	bra.w	L1FC6A
L1FC56	move.w	#$6,d0
	bra.w	L1FC6A
L1FC5E	move.w	#$0,d0
	bra.w	L1FC6A
L1FC66	move.w	#$4,d0
L1FC6A	add.w	d0,d0
	movea.l	#$3AD3A,a0
	move.w	(a0,d0.w),d1
	move.w	$14(a2),$1937C.l
	move.w	$0(a2),$1937E.l
	cmpi.w	#$18CC,d1
	bne.w	L1FCC6
	cmpi.w	#$59,$14(a2)
	bgt.w	L1FCC6
	cmpi.w	#$FFA7,$14(a2)
	blt.w	L1FCC6
	move.w	d0,-(sp)
	move.w	#$7,d0
	jsr	(StartArenaAnim).l
	move.w	(sp)+,d0
	move.w	#$193E,d1
	btst	#$3,$4(a2)
	beq.w	L1FD1E
	move.w	#$1A00,d1
	bra.w	L1FD1E
L1FCC6	cmpi.w	#$17E8,d1
	bne.w	L1FCF8
	cmpi.w	#$38,$14(a2)
	bgt.w	L1FCF8
	cmpi.w	#$FFC8,$14(a2)
	blt.w	L1FCF8
	move.w	#$1A00,d1
	btst	#$3,$4(a2)
	beq.w	L1FD1E
	move.w	#$193E,d1
	bra.w	L1FD1E
L1FCF8	btst	#$3,$4(a2)
	beq.w	L1FD1E
	cmpi.w	#$17E8,d1
	beq.w	L1FD1A
	cmpi.w	#$18CC,d1
	bne.w	L1FD1E
	move.w	#$17E8,d1
	bra.w	L1FD1E
L1FD1A	move.w	#$18CC,d1
L1FD1E	clr.w	$28(a2)
	clr.w	$2A(a2)
	bset	#$5,$64(a2)
	bset	#$0,$62(a2)
	movem.l	(sp)+,d0/a0
	bra.w	Sub_3AD66
	dc.w	$1776,$1776,$17E8,$17E8,$185A,$185A,$18CC,$18CC
Sub_3AD4A
	move.w	#$DD8,d1
	sub.w	$54(a2),d0
	addi.w	#$1,d0
	andi.w	#$7,d0
	cmpi.w	#$2,d0
	bls.w	Sub_3AD94
	move.w	#$D26,d1
Sub_3AD66
	move.w	$54(a2),d0
	andi.w	#$3,d0
	bne.w	Sub_3AD94
	cmpi.b	#$14,$75(a3)
	blt.w	Sub_3AD94
	cmpi.w	#$B,$52(a3)
	bgt.w	Sub_3AD94
	btst	#$5,$64(a2)
	bne.w	Sub_3AD94
	move.w	#$136A,d1
Sub_3AD94
	exg.l	a2,a3
	bset	#$5,$62(a3)
	bsr.w	Sub_363C0
	exg.l	a2,a3
	tst.w	$34(a3)
	beq.w	L1FDC2
	tst.w	$34(a2)
	beq.w	L1FDC2
	addi.w	#$12C,(Crowdlevel).l
	dc.w	$0679,$000F,$0001,$7CD8
L1FDC2	move.w	$17BE0.l,d0
	bmi.w	newcheck
	cmp.w	$52(a2),d0
	bne.w	newcheck
	st.b	$17BE0.l
	btst	#$4,$17F68.l
	bne.w	L1FE72
	cmpi.w	#$DD8,$58(a2)
	bne.w	L1FE72
	move.w	$54(a2),d0
	andi.w	#$3,d0
	bne.w	L1FE72
	btst	#$4,$63(a2)
	bne.w	L1FE72
	move.l	#$A0,d0
	bsr.w	randomd0
	cmp.w	$32(a2),d0
	bgt.w	L1FE72
	btst	#$0,$17F68.l
	bne.w	L1FE72
	exg.l	a2,a3
	move.w	#$145C,d1
	bsr.w	Sub_363C0
	exg.l	a2,a3
	bsr.w	setInjuryType
	btst	#$5,$17F7A.l
	bne.w	L1FE4C
	exg.l	a2,a3
	move.w	#$1AF4,d1
	bsr.w	Sub_363C0
	exg.l	a2,a3
L1FE4C	move.w	#$4,$1806A.l
	moveq	#$14,d0
	tst.w	$34(a3)
	beq.w	AddPenalty2
	dc.w	$4A79,$0001,$8C08
	beq.w	AddPenalty2
	moveq	#$12,d0
	bsr.w	AddPenalty2
	bra.w	Stop4Pen
L1FE72	move.w	#$B,-(sp)
	btst	#$6,$62(a2)
	bne.w	L1FE84
	move.w	#$C,(sp)
L1FE84	bsr.w	sfx
	rts
setInjuryType
	move.w	d0,-(sp)
	bset	#$2,$63(a2)
	addi.w	#$12C,(Crowdlevel).l
	dc.w	$0679,$001E,$0001,$7CD8
	move.w	#$D,-(sp)
	bsr.w	sfx
	move.w	$0(a2),$17EDC.l
	move.w	$14(a2),$17EDE.l
	bset	#$6,$17F6A.l
	clr.w	d1
	movea.l	#tmstruct,a0
	btst	#$6,$62(a2)
	beq.w	L1FEDC
	move.w	#$8000,d1
	adda.w	#$366,a0
L1FEDC	move.b	$66(a2),d1
	dc.w	$33C1,$0001,$80EE
	ext.w	d1
	add.w	d1,d1
	exg.l	a2,a3
	jsr	(getFgtbyte).l
	exg.l	a2,a3
	tst.w	d0
	bne.w	L1FF0C
	bclr	#$5,$17F7A.l
	move.w	#$FFFD,$68(a0,d1.w)
	bra.w	L1FF3A
L1FF0C	cmpi.w	#$3,d0
	beq.w	L1FF2C
	bclr	#$5,$17F7A.l
	move.w	#$FFFD,$68(a0,d1.w)
	jsr	$2AC46.l
	beq.w	L1FF3A
L1FF2C	bset	#$5,$17F7A.l
	move.w	#$FFFC,$68(a0,d1.w)
L1FF3A	move.w	(sp)+,d0
	rts
Sub_3AF3E
	rts
checkwallcoll
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
	bgt.w	L1FF8C
	cmp.w	d4,d2
	blt.w	L1FFB0
	neg.w	d4
	cmp.w	d4,d2
	bgt.w	L1FFB0
	movea.l	#$17B00,a2
	bsr.w	L2001C
	bra.w	L1FFE2
L1FF8C	neg.w	d5
	cmp.w	d5,d3
	blt.w	L1FFE2
	cmp.w	d4,d2
	blt.w	L1FFB0
	neg.w	d4
	cmp.w	d4,d2
	bgt.w	L1FFB0
	movea.l	#$17A80,a2
	bsr.w	L2001C
	bra.w	L1FFE2
L1FFB0	sub.w	d4,d2
	sub.w	d5,d3
	move.w	d3,d0
	move.w	d2,d1
	neg.w	d1
	muls.w	d3,d3
	muls.w	d2,d2
	add.l	d2,d3
	cmpi.l	#$1000,d3
	bls.w	L1FFE2
	exg.l	d0,d3
	bsr.w	Sroot
	exg.l	d0,d3
	ext.l	d0
	asl.l	#$8,d0
	divs.w	d3,d0
	ext.l	d1
	asl.l	#$8,d1
	divs.w	d3,d1
	bsr.w	L206A2
L1FFE2	movem.w	(sp)+,d2-d5
	move.w	$4E(a3),d0
	or.w	$50(a3),d0
	bne.w	rtss2
	move.w	#$100,d0
	clr.w	d1
	cmp.w	d5,d3
	bge.w	L206A2
	neg.w	d5
	neg.w	d0
	cmp.w	d5,d3
	ble.w	L206A2
	exg.l	d0,d1
	cmp.w	d4,d2
	bge.w	L206A2
	neg.w	d4
	neg.w	d1
	cmp.w	d4,d2
	ble.w	L206A2
	rts
L2001C	cmpi.w	#$D,$18(a3)
	bgt.w	rtss2
	cmpi.w	#$E,$52(a3)
	bne.w	L20538
	sub.w	$0(a2),d2
	moveq	#$10,d4
	dc.w	$D879,$0001,$7CF4
	cmp.w	d4,d2
	bgt.w	rtss2
	neg.w	d4
	cmp.w	d4,d2
	blt.w	rtss2
	sub.w	$14(a2),d3
	move.w	#$2,d5
	dc.w	$DA79,$0001,$7CF6
	cmp.w	d5,d3
	bgt.w	rtss2
	neg.w	d5
	cmp.w	d5,d3
	blt.w	rtss2
	st.b	$17EEE.l
	cmpi.w	#$D,$24(a3)
	blt.w	L20080
	move.w	$24(a3),$18(a3)
	bra.w	L20192
L20080	bclr	#$7,$62(a3)
	move.w	$17BE0.l,d0
	bmi.w	L200C2
	st.b	$17BE0.l
	asl.w	#$7,d0
	dc.w	$207C,$0001,$7480
	move.b	#$8,$5E(a0,d0.w)
	dc.w	$3239,$0001,$7B94
	btst	#$7,$62(a0,d0.w)
	bne.w	L200B6
	neg.w	d1
L200B6	tst.w	d1
	bpl.w	L200C2
	bset	#$7,$62(a3)
L200C2	move.w	#$FF00,d0
	move.l	$14(a3),d1
	sub.l	$20(a3),d1
	asr.l	#$8,d1
	beq.w	L201A0
	bmi.w	L200DC
	neg.w	d0
	neg.w	d5
L200DC	add.w	d3,d5
	move.l	$0(a3),d3
	sub.l	$1C(a3),d3
	asr.l	#$8,d3
	muls.w	d3,d5
	divs.w	d1,d5
	bvs.w	L201A0
	sub.w	d5,d2
	cmp.w	d4,d2
	blt.w	L201A0
	neg.w	d4
	cmp.w	d4,d2
	bgt.w	L201A0
	clr.w	d1
	move.w	$14(a3),d3
	eor.w	d0,d3
	bmi.w	wallcoll
	neg.w	d0
	btst	#$7,$62(a3)
	bne.w	wallcoll
	cmpi.w	#$D,$18(a3)
	beq.w	L20134
	subi.w	#$1,d4
	cmp.w	d4,d2
	bgt.w	L20134
	neg.w	d4
	cmp.w	d4,d2
	bge.w	L201B8
L20134	bsr.w	ChkShotStat
	move.w	#$25,-(sp)
	btst	#$0,$17F68.l
	bne.w	L2015C
	move.w	#$8,(sp)
	addi.w	#$12C,(Crowdlevel).l
	dc.w	$0679,$0028,$0001,$7CD8
L2015C	bsr.w	sfx
	move.w	#$1000,d0
	bsr.w	randomd0
	tst.w	$14(a3)
	bmi.w	L20172
	neg.w	d0
L20172	move.w	d0,$2A(a3)
	move.w	#$1000,d0
	bsr.w	Sub_37044
	move.w	d0,$28(a3)
	move.w	#$1000,d0
	bsr.w	Sub_37044
	move.w	d0,$2C(a3)
	bra.w	puckflip
L20192	neg.w	$2C(a3)
	bpl.w	rtss2
	neg.w	$2C(a3)
	rts
L201A0	clr.w	d0
	move.w	#$100,d1
	move.w	$0(a3),d2
	sub.w	$1C(a3),d2
	bmi.w	wallcoll
	neg.w	d1
	bra.w	wallcoll
L201B8	btst	#$2,$17F70.l
	beq.w	L20250
	btst	#$0,$17F78.l
	bne.w	L201F6
	movem.l	d0/a0,-(sp)
	dc.w	$3039,$0001,$9368
	asl.w	#$7,d0
	dc.w	$207C,$0001,$7480
	adda.w	d0,a0
	btst	#$7,$62(a0)
	movem.l	(sp)+,d0/a0
	bne.w	L20200
	bra.w	L2020E
L201F6	dc.w	$4A79,$0001,$A436
	bne.w	L2020E
L20200	dc.w	$4A79,$0001,$7B94
	bmi.w	rtss2
	bra.w	L20218
L2020E	dc.w	$4A79,$0001,$7B94
	bpl.w	rtss2
L20218	bset	#$5,$17F72.l
	dc.w	$4A79,$0001,$A436
	beq.w	L20236
	dc.w	$0679,$0001,$0001,$A418
	bra.w	L2023E
L20236	dc.w	$0679,$0001,$0001,$A416
L2023E	bset	#$0,$17F7C.l
	jsr	(EndPenaltyShotPlay).l
	bra.w	L2025C
L20250	btst	#$0,$17F68.l
	bne.w	rtss2
L2025C	bset	#$0,$17F72.l
	bclr	#$3,$17F7C.l
	bsr.w	ChkShotStat
	jsr	$47DB0.l
	move.w	d0,-(sp)
	move.w	(ScoutSubStatus).l,d0
L2027E	cmp.w	(ScoutSubStatus).l,d0
	beq.w	L2027E
	move.w	(sp)+,d0
	move.w	#$0,-(sp)
	bsr.w	sfx
	jsr	(freezewindow).l
	addi.w	#$1F4,(Crowdlevel).l
	movea.l	#tmstruct,a2
	lea.l	$366(a2),a1
	tst.w	$14(a3)
	bpl.w	L202B4
	exg.l	a1,a2
L202B4	btst	#$1,$17F68.l
	beq.w	L202C2
	exg.l	a1,a2
L202C2	addi.w	#$1,$C(a2)
	btst	#$5,$17F72.l
	beq.w	L202E6
	btst	#$0,$17F78.l
	bne.w	L202E6
	addi.w	#$1,$364(a2)
L202E6	bclr	#$4,$17F78.l
	beq.w	L202F8
	addi.w	#$1,$35C(a2)
L202F8	btst	#$5,$17F6C.l
	beq.w	L2032E
	btst	#$6,$17F6C.l
	bne.w	L20324
	cmpa.l	#$186B2,a2
	bne.w	L2032E
L2031A	addi.w	#$1,$358(a2)
	bra.w	L2032E
L20324	cmpa.l	#$1834C,a2
	beq.w	L2031A
L2032E	movem.l	d0/a2,-(sp)
	move.w	$180E4.l,d0
	add.w	d0,d0
	adda.w	d0,a2
	addi.w	#$1,$344(a2)
	movem.l	(sp)+,d0/a2
	bclr	#$7,$17F7C.l
	beq.w	L20358
	addi.w	#$1,$360(a2)
L20358	cmpa.l	#$1834C,a2
	bne.w	L20384
	dc.w	$33F9,$0001,$7FAE,$0001,$A56C
	dc.w	$33FC,$0003,$0001,$A56E
	jsr	(ChooseSong).l
	dc.w	$3F39,$0001,$A56A
	bsr.w	song
L20384	dc.w	$0C79,$0168,$0001,$80F0
	bne.w	L20398
	dc.w	$0479,$0006,$0001,$80F0
L20398	movea.l	#$180F2,a0
	dc.w	$D0F9,$0001,$80F0
	dc.w	$0679,$0006,$0001,$80F0
	bsr.w	Sub_3B51E
	move.w	d0,(a0)+
	moveq	#$2,d0
	add.w	$26(a2),d0
	sub.w	$26(a1),d0
	move.b	d0,(a0)+
	dc.w	$0679,$001E,$0001,$7CD8
	cmpa.l	#$1834C,a2
	beq.w	L203DE
	dc.w	$0479,$0014,$0001,$7CD8
	bset	#$7,-$1(a0)
L203DE	move.w	$18(a2),d0
	move.b	d0,(a0)+
	move.w	#$FFFF,(a0)
	addi.w	#$B6,d0
	addi.b	#$1,(a2,d0.w)
	move.w	$1A(a2),d0
	bmi.w	L2042A
	cmp.w	$18(a2),d0
	beq.w	L2042A
	move.b	d0,(a0)+
	addi.w	#$D0,d0
	addi.b	#$1,(a2,d0.w)
	move.w	$1C(a2),d0
	bmi.w	L2042A
	cmp.w	$18(a2),d0
	beq.w	L2042A
	move.b	d0,(a0)
	addi.w	#$D0,d0
	addi.b	#$1,(a2,d0.w)
L2042A	move.w	$28(a1),d0
	bmi.w	L2043C
	addi.w	#$B6,d0
	addi.b	#$1,(a1,d0.w)
L2043C	bsr.w	ChkShotStat
	bsr.w	PenGoalStuff
	bclr	#$3,$17F70.l
	bsr.w	printscores1
	dc.w	$33FC,$2710,$0001,$7F82
	btst	#$0,$17F78.l
	beq.w	L20468
	bra.w	L2046E
L20468	moveq	#$7,d0
	bsr.w	L204DE
L2046E	clr.w	$17EEE.l
	clr.w	$28(a3)
	clr.w	$2A(a3)
	moveq	#$6,d0
	tst.w	$0(a3)
	bpl.w	L20488
	neg.w	d0
L20488	move.w	d0,$0(a3)
	move.w	#$110,d0
	tst.w	$14(a3)
	bpl.w	L2049A
	neg.w	d0
L2049A	move.w	d0,$14(a3)
	move.w	#$600,$2C(a3)
	clr.w	$18(a3)
	st.b	$17E38.l
	st.b	$17E3C.l
	bset	#$2,$62(a3)
	move.w	#$1A,d0
	bsr.w	Sub_362E4
	move.l	a3,-(sp)
	adda.w	#$80,a3
	move.w	#$102E,d1
	bsr.w	Sub_363C0
	movea.l	$22(a1),a3
	moveq	#$E,d0
	bsr.w	AddPenalty2
	movea.l	(sp)+,a3
	rts
L204DE	move.l	a3,-(sp)
	movea.l	$22(a2),a3
	moveq	#$5,d3
L204E6	tst.w	$34(a3)
	ble.w	L20512
	btst	#$0,$63(a3)
	bne.w	L20512
	bclr	#$2,$62(a3)
	bclr	#$3,$64(a3)
	beq.w	L2050E
	jsr	(EndOneTimer).l
L2050E	bsr.w	Sub_362D8
L20512	adda.w	#$80,a3
	dbra	d3,L204E6
	movea.l	(sp)+,a3
	rts
Sub_3B51E
	move.w	$180E4.l,d0
	swap	d0
	clr.w	d0
	lsr.l	#$2,d0
	dc.w	$8079,$0001,$80EA
	dc.w	$9079,$0001,$80E6
	rts
L20538	btst	#$5,$63(a3)
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
	bhi.w	L205CA
	asl.w	#$4,d3
	muls.w	d3,d3
	divu.w	#$79,d3
	add.w	d2,d3
	cmpi.w	#$100,d3
	bhi.w	L205CA
	movem.w	(sp)+,d2-d3
	bsr.w	L205D0
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
L205CA	movem.w	(sp)+,d2-d3
	rts
L205D0	movem.l	d0-d1,-(sp)
L205D4	btst	#$7,$FF800E.l
	bne.b	L205D4
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
L205EE	btst	#$6,$FF800E.l
	beq.b	L205EE
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L2060E	btst	#$6,$FF800E.l
	bne.b	L2060E
	bclr	#$7,$FF800F.l
	andi.w	#$1F,d0
	bne.w	L2066A
	dc.w	$3039,$0001,$7B94
	sub.w	$14(a2),d0
	cmpi.w	#$28,d0
	bgt.w	L2066A
	cmpi.w	#$FFD8,d0
	blt.w	L2066A
	move.w	$28(a3),d0
	move.w	$2A(a3),d1
	cmpi.w	#$2000,d0
	bgt.w	L20670
	cmpi.w	#$E000,d0
	blt.w	L20670
	cmpi.w	#$2000,d1
	bgt.w	L20670
	cmpi.w	#$E000,d1
	blt.w	L20670
L2066A	movem.l	(sp)+,d0-d1
	rts
L20670	adda.w	#$C,sp
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
L206A2	cmpi.w	#$E,$52(a3)
	bne.w	wallcoll
	cmpi.w	#$1D,$18(a3)
	bgt.w	L20714
	cmpi.w	#$12,$18(a3)
	bls.w	wallcoll
	cmpi.w	#$118,$14(a3)
	blt.w	L20714
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
	bsr.w	Sub_363C0
	movea.l	(sp)+,a3
	move.w	#$E,-(sp)
	bsr.w	sfx
	addi.w	#$258,(Crowdlevel).l
	dc.w	$0679,$000F,$0001,$7CD8
L20714	bset	#$6,$17F6A.l
	bset	#$2,$62(a3)
	tst.w	$14(a3)
	bpl.w	L20730
	ori.w	#$8000,$4(a3)
L20730	clr.w	$86(a3)
	btst	#$0,$17F68.l
	bne.w	rtss2
	move.l	a3,-(sp)
	move.w	$17EC8.l,d0
	asl.w	#$7,d0
	dc.w	$267C,$0001,$7480
	adda.w	d0,a3
	moveq	#$6,d0
	bsr.w	AddPenalty2
	movea.l	(sp)+,a3
	rts
wallcoll
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
	bne.w	L207EE
	bclr	#$4,$17F6C.l
	tst.w	d2
	bpl.w	L20864
	asr.w	#$2,d2
	cmpi.w	#$FC00,d2
	bgt.w	L207E0
	move.w	#$800,d0
	bsr.w	randomd0
	neg.w	d0
	move.w	d0,$2C(a3)
	bsr.w	puckflip
	move.w	d2,d0
	asr.w	#$8,d0
	asr.w	#$2,d0
	addi.w	#$4,d0
	bpl.w	L207D2
	clr.w	d0
L207D2	andi.w	#$3,d0
	addi.w	#$28,d0
	move.w	d0,-(sp)
	bsr.w	sfx
L207E0	move.w	d3,d0
	asr.w	#$6,d0
	sub.w	d0,d3
	asr.w	#$1,d0
	sub.w	d0,d3
	bra.w	L20830
L207EE	cmpi.w	#$3E8,d2
	bgt.w	L20864
	bclr	#$4,(sflags6).l
	bne.w	L20808
	bset	#$4,$64(a3)
L20808	cmpi.w	#$F000,d2
	bgt.w	L20822
	cmpi.w	#$A,$32(a3)
	blt.w	L20822
	move.w	#$20,-(sp)
	bsr.w	sfx
L20822	asr.w	#$2,d2
	cmpi.w	#$FC7C,d2
	blt.w	L20830
	move.w	#$FC18,d2
L20830	movem.w	(sp),d0-d1
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
	bmi.w	L20864
	clr.w	$2C(a3)
L20864	adda.w	#$4,sp
	movem.l	(sp)+,d2-d3
	rts
