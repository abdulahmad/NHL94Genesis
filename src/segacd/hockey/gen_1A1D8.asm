Sub_351D8
	moveq	#$2,d1
	dc.w	$41FA,$003C
	cmpi.w	#$2,$180E4.l
	bne.w	L1A202
	move.w	$C(a2),d2
	cmp.w	$C(a1),d2
	beq.w	L1A202
	adda.w	#$6,a0
	bgt.w	L1A202
	adda.w	#$6,a0
L1A202	move.w	(a0)+,d0
	bsr.w	getlinee
	cmpi.w	#$C00,d0
	dbhi	d1,L1A202
	move.w	-(a0),$16(a2)
	bra.w	Sub_35154
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_1A218.bin
ResetAndSelectPlayers
	dc.w	$33FC,$FFFF,$0001,$7F9E
	dc.w	$33FC,$FFFF,$0001,$7FA0
	dc.w	$4A79,$0001,$7FA6
	beq.w	L1A7B8
	clr.w	d4
	bsr.w	Sub_312A4
L1A7B8	dc.w	$4A79,$0001,$7FA8
	beq.w	L1A7C8
	moveq	#$2,d4
	bsr.w	Sub_312A4
L1A7C8	dc.w	$4A79,$0001,$7FAA
	beq.w	L1A818
	dc.w	$3F39,$0001,$7FA6
	dc.w	$33F9,$0001,$7FAA,$0001,$7FA6
	dc.w	$3F39,$0001,$7F9E
	dc.w	$33FC,$FFFF,$0001,$7F9E
	clr.w	d4
	jsr	(Sub_312A4).l
	dc.w	$33F9,$0001,$7F9E,$0001,$7FA2
	dc.w	$33F9,$0001,$7FA6,$0001,$7FAA
	dc.w	$33DF,$0001,$7F9E
	dc.w	$33DF,$0001,$7FA6
L1A818	dc.w	$4A79,$0001,$7FAC
	beq.w	L1A86A
	dc.w	$3F39,$0001,$7FA8
	dc.w	$33F9,$0001,$7FAC,$0001,$7FA8
	dc.w	$3F39,$0001,$7FA0
	dc.w	$33FC,$FFFF,$0001,$7FA0
	move.w	#$2,d4
	jsr	(Sub_312A4).l
	dc.w	$33F9,$0001,$7FA0,$0001,$7FA4
	dc.w	$33F9,$0001,$7FA8,$0001,$7FAC
	dc.w	$33DF,$0001,$7FA0
	dc.w	$33DF,$0001,$7FA8
L1A86A	rts
updatefaceoff
	move.w	$40(a3),d0
	beq.w	L1A890
	addi.w	#$6,d0
	lsr.w	#$3,d0
	cmpi.w	#$2,d0
	bgt.w	rtss2
	neg.w	d0
	addi.w	#$A,d0
	dc.w	$33C0,$0001,$7D00
	rts
L1A890	bclr	#$4,(disflags).l
	bsr.w	printz
	String	CC_Font1Pri,$0,$0
	dc.w	$3039,$0001,$746C
	subi.w	#$2E,d0
	asr.w	#$3,d0
	move.w	d0,(printx).l
	moveq	#$64,d0
	dc.w	$3039,$0001,$746E
	subi.w	#$44,d0
	asr.w	#$3,d0
	move.w	d0,(printy).l
	moveq	#$C,d0
	moveq	#$D,d1
	move.w	#$7FF,d2
	bra.w	eraser
Endfaceoff
	dc.w	$207C,$000B,$BD30
	dc.w	$3039,$0001,$7F66
	dc.w	$3239,$0001,$8D32
	dc.w	$4EB9,$0003,$777C
	move.w	#$2F,-(sp)
	bsr.w	sfx
	bclr	#$0,$17F6C.l
	move.w	#$3C,$19374.l
	dc.w	$3839,$0001,$8D56
	movea.l	$47D1C.l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain
	bclr	#$2,$17F6C.l
	bclr	#$0,$17F68.l
	bclr	#$0,$63(a3)
	dc.w	$4279,$0001,$7F82
	bset	#$4,$17F6E.l
	move.w	$17EE6.l,d3
	move.w	#$800,d4
	movea.l	#$35A38,a0
	dc.w	$227C,$0001,$7CF8
	moveq	#$10,d2
	move.w	(a1),d1
	sub.b	-$1(a0,d1.w),d2
	move.w	$4(a1),d1
	add.b	-$1(a0,d1.w),d2
	moveq	#$21,d0
	bsr.w	randomd0
	cmp.b	d0,d2
	bls.w	L1A970
	adda.w	#$4,a1
L1A970	btst	#$3,$2(a1)
	beq.w	L1A982
	move.w	$17EE8.l,d3
	neg.w	d4
L1A982	move.w	d3,d0
	btst	#$3,d0
	bne.w	L1A9E4
	andi.w	#$7,d0
L1A990	btst	#$7,$FF800E.l
	bne.b	L1A990
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
L1A9AA	btst	#$6,$FF800E.l
	beq.b	L1A9AA
	move.w	$FF8010.l,d1
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L1A9CA	btst	#$6,$FF800E.l
	bne.b	L1A9CA
	bclr	#$7,$FF800F.l
	andi.w	#$3,d1
	bne.w	L1A9FC
L1A9E4	moveq	#$5,d0
	bsr.w	randomd0
	subi.w	#$2,d0
	andi.w	#$7,d0
	tst.w	d4
	bmi.w	L1A9FC
	eori.w	#$4,d0
L1A9FC	asl.w	#$2,d0
	movea.l	#$36B8E,a0
	move.w	(a0,d0.w),d1
	asl.w	#$5,d1
	move.w	d1,$28(a3)
	move.w	$2(a0,d0.w),d1
	asl.w	#$5,d1
	add.w	d4,d1
	move.w	d1,$2A(a3)
	move.w	#$800,d0
	bsr.w	randomd0
	move.w	d0,$2C(a3)
	clr.w	$17B98.l
	bclr	#$2,$62(a3)
	moveq	#$18,d0
	bra.w	Sub_362E4
	dc.w	$0008,$1000,$0810
PeriodOver
	addi.w	#$1,$180E4.l
	bchg	#$1,$17F68.l
	cmpi.w	#$3,$180E4.l
	blt.w	L1AA90
	beq.w	L1AA78
	move.w	#$3,$180E4.l
	dc.w	$4A79,$0001,$8BFA
	bne.w	L1AA78
	move.w	#$4,$180E4.l
L1AA78	dc.w	$3039,$0001,$8358
	dc.w	$9079,$0001,$86BE
	beq.w	L1AA90
	move.w	#$4,$180E4.l
L1AA90	bsr.w	Sub_36D0A
	jsr	(ResetClock).l
	move.w	#$79,-(sp)
	bsr.w	song
	bsr.w	UpdateScores
	cmpi.w	#$4,$180E4.l
	bne.w	L1AAB8
	dc.w	$4EB9,$0004,$0838
L1AAB8	bsr.w	Intermission
	cmpi.w	#$4,$180E4.l
	beq.w	L1AACE
	jmp	$2BA1E.l
L1AACE	jmp	(GameOver).l
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_1AAD4.bin
ClearOffsidesIfAllPlayers
	btst	#$4,$32(a2)
	beq.w	rtss2
	movea.l	$22(a2),a0
	moveq	#$5,d1
L1AC9C	tst.w	$34(a0)
	bmi.w	L1ACB4
	move.w	$14(a0),d0
	btst	#$7,$62(a0)
	bne.w	L1ACB4
	neg.w	d0
L1ACB4	adda.w	#$80,a0
	cmpi.w	#$58,d0
	dbgt	d1,L1AC9C
	bgt.w	rtss2
	bclr	#$4,$32(a2)
	rts
a2offsides
	btst	#$5,$17F68.l
	beq.w	rtss2
	dc.w	$3039,$0001,$7B94
	btst	#$7,$62(a2)
	bne.w	L1ACEA
	neg.w	d0
L1ACEA	cmpi.w	#$68,d0
	blt.w	rtss2
	movea.l	#tmstruct,a0
	btst	#$6,$62(a2)
	beq.w	L1AD06
	adda.w	#$366,a0
L1AD06	btst	#$4,$32(a0)
	beq.w	rtss2
	btst	#$4,$17F68.l
	bne.w	rtss2
	exg.l	a2,a3
	moveq	#$10,d0
	bsr.w	AddPenalty
	exg.l	a2,a3
	rts
Sub_35D28
	move.w	$0(a2),$17ECA.l
	move.w	$14(a2),$17ECC.l
	move.w	$52(a2),$17EC8.l
	movea.l	#tmstruct,a0
	btst	#$6,$62(a2)
	beq.w	L1AD54
	lea.l	$366(a0),a0
L1AD54	clr.w	d0
	move.b	$66(a2),d0
	btst	#$3,$64(a2)
	beq.w	L1AD6C
	bset	#$7,$17F7C.l
L1AD6C	cmp.w	$18(a0),d0
	beq.w	L1AD9A
	bclr	#$3,$32(a0)
	bne.w	L1AD8A
	move.w	$1A(a0),$1C(a0)
	move.w	$18(a0),$1A(a0)
L1AD8A	move.w	d0,$18(a0)
	cmp.w	$1C(a0),d0
	bne.w	L1AD9A
	st.b	$1C(a0)
L1AD9A	bclr	#$4,$17F6C.l
	bsr.w	a2offsides
	btst	#$2,$17ECE.l
	beq.w	L1AE06
	btst	#$0,$17ECE.l
	beq.w	L1AE06
	tst.w	$34(a2)
	beq.w	L1AE06
	btst	#$1,$17ECE.l
	bne.w	L1ADFC
	btst	#$7,$62(a2)
	beq.w	L1AE06
L1ADDC	clr.w	d0
	move.b	$17ECF.l,d0
	asl.w	#$7,d0
	move.l	a3,-(sp)
	dc.w	$267C,$0001,$7480
	adda.w	d0,a3
	move.w	#$C,d0
	bsr.w	AddPenalty
	movea.l	(sp)+,a3
	rts
L1ADFC	btst	#$7,$62(a2)
	beq.w	L1ADDC
L1AE06	clr.b	$17ECE.l
	move.b	$53(a2),$17ECF.l
	dc.w	$3039,$0001,$7B94
	btst	#$7,$62(a2)
	beq.w	L1AE2E
	bset	#$1,$17ECE.l
	neg.w	d0
L1AE2E	bmi.w	rtss2
	move.w	$18372.l,d0
	sub.w	$186D8.l,d0
	btst	#$6,$62(a2)
	beq.w	L1AE4A
	neg.w	d0
L1AE4A	bmi.w	rtss2
	bset	#$2,$17ECE.l
	rts
PuckIChk
	btst	#$2,$17ECE.l
	beq.w	rtss2
	btst	#$0,$17ECE.l
	bne.w	rtss2
	tst.w	$17BE0.l
	bpl.w	rtss2
	move.w	#$108,d0
	btst	#$1,$17ECE.l
	bne.w	L1AE98
	neg.w	d0
	dc.w	$B079,$0001,$7B94
	bgt.w	L1AEA2
	rts
L1AE98	dc.w	$B079,$0001,$7B94
	bgt.w	rtss2
L1AEA2	dc.w	$0C79,$002C,$0001,$7B80
	bgt.w	L1AEC4
	dc.w	$0C79,$FFD4,$0001,$7B80
	blt.w	L1AEC4
	bclr	#$2,$17ECE.l
	rts
L1AEC4	bset	#$0,$17ECE.l
	rts
puckunflip
	cmpi.w	#$8,$5A(a3)
	blt.w	L1AEE8
	cmpi.w	#$18,$5A(a3)
	bge.w	L1AEE8
	eori.w	#$2,$54(a3)
L1AEE8	ori.w	#$4,$54(a3)
	clr.w	$5A(a3)
	st.b	$5C(a3)
	rts
puckflip
	andi.w	#$1,d0
	eor.w	d0,$54(a3)
	andi.w	#$3,$54(a3)
	st.b	$5C(a3)
	move.w	#$46A,d1
	bra.w	Sub_363C0
	dc.w	$0C6B,$018A,$0006,$6600,$002A,$376B,$FF80,$0000
	dc.w	$376B,$FF94,$0014,$426B,$0018,$7014,$0839,$0007
	dc.w	$0001,$7F6A,$6700,$0004,$7000,$0673,$0001,$0000
	dc.w	$4E75,$4A6B,$0006,$6700,$60B6,$426B,$0000,$377C
	dc.w	$012C,$0014,$377C,$000E,$0018,$4A6B,$FF94,$6A00
	dc.w	$0012,$377C,$8000,$0004,$446B,$0014,$046B,$0001
	dc.w	$0018,$4E75
findpc
	movem.l	d0-d4/a1-a2,-(sp)
	movea.l	#$17E36,a1
	move.w	#$88,d1
	move.w	#$108,d4
	bsr.w	L1AF98
	neg.w	d4
	bsr.w	L1AF98
	movem.l	(sp)+,d0-d4/a1-a2
	rts
L1AF98	move.w	d4,d0
	dc.w	$9079,$0001,$7B94
	dc.w	$4A79,$0001,$7BAA
	beq.w	L1AFFC
	move.w	d0,d2
	swap	d2
	clr.w	d2
	asr.l	#$4,d2
	dc.w	$85F9,$0001,$7BAA
	bmi.w	L1AFFC
	move.w	d2,$2(a1)
	dc.w	$C1F9,$0001,$7BA8
	dc.w	$81F9,$0001,$7BAA
	bvs.w	L1AFFC
	dc.w	$D079,$0001,$7B80
	cmp.w	d1,d0
	blt.w	L1AFE4
	neg.w	d0
	add.w	d1,d0
	add.w	d1,d0
	add.w	d1,d0
L1AFE4	neg.w	d1
	cmp.w	d1,d0
	bgt.w	L1AFF4
	neg.w	d0
	add.w	d1,d0
	add.w	d1,d0
	add.w	d1,d0
L1AFF4	neg.w	d1
	move.w	d0,(a1)
	bra.w	L1B002
L1AFFC	move.w	#$FFFF,$2(a1)
L1B002	adda.w	#$4,a1
	rts
