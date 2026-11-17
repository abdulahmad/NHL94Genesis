passto
	btst	#$3,$62(a3)
	beq.w	L1617A
	tst.w	$34(a3)
	bne.w	L1617A
	movem.l	d0-d1,-(sp)
	btst	#$3,$62(a0)
	bne.w	L16176
	bset	#$6,$64(a0)
	dc.w	$3239,$0001,$7FA6
	dc.w	$B279,$0001,$7FA8
	bne.w	L16146
	move.w	$52(a0),d0
	move.w	$52(a3),d1
	dc.w	$B279,$0001,$7F9E
	bne.w	L1613C
	dc.w	$4EB9,$0003,$12B8
	bra.w	L16176
L1613C	jsr	(Sub_312DC).l
	bra.w	L16176
L16146	move.w	#$1,d1
	btst	#$6,$62(a3)
	beq.w	L16158
	move.w	#$2,d1
L16158	move.w	$52(a0),d0
	dc.w	$B279,$0001,$7FA6
	bne.w	L16170
	dc.w	$4EB9,$0003,$12B8
	bra.w	L16176
L16170	jsr	(Sub_312DC).l
L16176	movem.l	(sp)+,d0-d1
L1617A	jsr	$3C958.l
	addi.w	#$1,$12(a2)
	dc.w	$33E8,$0052,$0001,$7E30
	dc.w	$3A39,$0001,$7E2E
	asr.w	#$2,d5
	exg.l	a0,a3
	moveq	#$13,d0
	bsr.w	Sub_362D8
	exg.l	a0,a3
	move.l	a0,-(sp)
	bsr.w	Sub_36362
	add.w	$0(a0),d0
	dc.w	$9079,$0001,$7B80
	add.w	$14(a0),d1
	dc.w	$9279,$0001,$7B94
	movem.w	d0-d1,-(sp)
	movem.w	(sp),d2-d3
	asr.w	#$2,d2
	asr.w	#$2,d3
	move.w	$28(a0),d0
	muls.w	#$F0,d0
	swap	d0
	move.w	$2A(a0),d1
	muls.w	#$F0,d1
	swap	d1
	movem.w	d0-d1,-(sp)
	muls.w	d2,d0
	muls.w	d3,d1
	add.w	d1,d0
	asl.w	#$1,d0
	move.w	d0,d4
	movem.w	(sp),d0-d1
	muls.w	d0,d0
	muls.w	d1,d1
	muls.w	d5,d5
	neg.l	d5
	add.l	d0,d5
	add.l	d1,d5
	muls.w	d2,d2
	muls.w	d3,d3
	add.l	d2,d3
	muls.w	d5,d3
	asl.l	#$2,d3
	move.w	d4,d0
	muls.w	d0,d0
	sub.l	d3,d0
	bsr.w	Sroot
	moveq	#$1,d3
	asr.w	#$2,d5
	bne.w	L16216
	moveq	#$1,d5
L16216	move.w	d0,d2
	neg.w	d0
	sub.w	d4,d2
	ext.l	d2
	divs.w	d5,d2
	dbpl	d3,L16216
	bne.w	L1622C
	addi.w	#$1,d2
L1622C	cmpi.w	#$18,d2
	bls.w	L16236
	moveq	#$18,d2
L16236	dc.w	$13C2,$0001,$7BAC
	cmpi.w	#$C,d2
	blt.w	L1624C
	dc.w	$13FC,$000C,$0001,$7BAC
L1624C	move.w	d2,d0
	asl.w	#$3,d0
	subi.w	#$A,d0
	move.b	d0,$40(a0)
	subi.w	#$6,d0
	move.b	d0,$17BDE.l
	movem.w	(sp)+,d0-d1
	muls.w	d2,d0
	asr.l	#$1,d0
	add.w	(sp)+,d0
	dc.w	$3179,$0001,$7B80,$0044
	add.w	d0,$44(a0)
	muls.w	d2,d1
	asr.l	#$1,d1
	add.w	(sp)+,d1
	dc.w	$3179,$0001,$7B94,$0046
	add.w	d1,$46(a0)
	mulu.w	#$78,d2
	swap	d0
	divs.w	d2,d0
	dc.w	$33C0,$0001,$7BA8
	swap	d1
	divs.w	d2,d1
	dc.w	$33C1,$0001,$7BAA
	rts
Sub_312A4
	jmp	$2B4E2.l
Sweepcheck
	bset	#$5,$62(a3)
	move.w	#$B24,d1
	bra.w	Sub_363C0
Sub_312B8
	dc.w	$B079,$0001,$7F9E
	beq.w	L162DA
	movem.l	d1/a0-a1,-(sp)
	dc.w	$3239,$0001,$7F9E
	bsr.w	restorepl
	dc.w	$33C0,$0001,$7F9E
	movem.l	(sp)+,d1/a0-a1
L162DA	rts
Sub_312DC
	dc.w	$B079,$0001,$7FA0
	beq.w	L162FE
	movem.l	d1/a0-a1,-(sp)
	dc.w	$3239,$0001,$7FA0
	bsr.w	restorepl
	dc.w	$33C0,$0001,$7FA0
	movem.l	(sp)+,d1/a0-a1
L162FE	rts
restorepl
	dc.w	$207C,$0001,$7480
	tst.w	d1
	blt.w	L1633C
	cmpi.w	#$B,d1
	bgt.w	L1633C
	asl.w	#$7,d1
	btst	#$3,$63(a0,d1.w)
	beq.w	L16326
	lsr.w	#$7,d1
	move.w	d1,d0
	rts
L16326	bclr	#$3,$62(a0,d1.w)
	btst	#$3,$64(a0,d1.w)
	bne.w	L1633C
	bset	#$1,$62(a0,d1.w)
L1633C	tst.w	d0
	blt.w	L163A8
	cmpi.w	#$B,d0
	bgt.w	L163A8
	move.w	d0,d1
	asl.w	#$7,d1
	btst	#$2,$17F70.l
	bne.w	L16366
	btst	#$0,$17F78.l
	beq.w	L163A2
L16366	tst.w	$34(a0,d1.w)
	bne.w	L163A2
	btst	#$6,$62(a0,d1.w)
	beq.w	L16382
	dc.w	$4A79,$0001,$8C0E
	bra.w	L16388
L16382	dc.w	$4A79,$0001,$8C0C
L16388	beq.w	L163A2
	move.w	#$0,d0
	btst	#$6,$62(a0,d1.w)
	beq.w	L1639E
	move.w	#$6,d0
L1639E	bra.w	L163A8
L163A2	bset	#$3,$62(a0,d1.w)
L163A8	rts
Findhittype
	neg.w	d0
	add.w	$54(a3),d0
	andi.w	#$7,d0
	btst	#$3,$4(a3)
	beq.w	L163C4
	dc.w	$013C,$00F0,$4E75
L163C4	dc.w	$013C,$001E,$4E75
Sub_313CA
	btst	#$2,$17F70.l
	beq.w	L163FA
	bclr	#$2,$17F78.l
	bset	#$5,$17F70.l
	bne.w	Sub_30A6E
	bclr	#$5,$17F78.l
	dc.w	$33FC,$0064,$0001,$7F9A
L163FA	dc.w	$33FC,$0008,$0001,$7E2C
	bset	#$3,$17F6A.l
	clr.w	d0
	move.w	#$128,d1
	btst	#$7,$62(a3)
	bne.w	L1641C
	neg.w	d1
L1641C	sub.w	$0(a3),d0
	sub.w	$14(a3),d1
	bsr.w	vtoa
	dc.w	$33FC,$000F,$0001,$7E2E
	move.w	#$7FC,d1
	bsr.w	Findhittype
	beq.w	L16448
	move.w	#$92E,d1
	dc.w	$33FC,$000F,$0001,$7E2E
L16448	bra.w	Sub_363C0
ShotMode
	cmpi.w	#$1C,$5A(a3)
	bge.w	prepshot
	btst	#$3,d0
	bne.w	L16468
	andi.w	#$7,d0
	dc.w	$33C0,$0001,$7E2C
L16468	cmpi.w	#$10,$5A(a3)
	bge.w	L167B6
	dc.w	$DF79,$0001,$7E2E
	cmpi.b	#$14,$6C(a3)
	bge.w	L1648C
	cmpi.w	#$8,$5A(a3)
	bgt.w	L16494
L1648C	btst	#$5,d2
	beq.w	L167B6
L16494	neg.w	$5A(a3)
	addi.w	#$1C,$5A(a3)
	rts
prepshot
	bclr	#$4,$17F74.l
	move.w	#$B,d0
	btst	#$6,$62(a3)
	beq.w	L164BA
	move.w	#$5,d0
L164BA	jsr	(getGoalieSCnum).l
	tst.w	d0
	bmi.w	L164EA
	movem.l	a0,-(sp)
	asl.w	#$7,d0
	dc.w	$207C,$0001,$7480
	cmpi.w	#$250,$58(a0,d0.w)
	beq.w	L164E2
	cmpi.w	#$2A2,$58(a0,d0.w)
L164E2	movem.l	(sp)+,a0
	bne.w	L16524
L164EA	dc.w	$0C79,$0001,$0001,$7E2C
	ble.w	L16502
	dc.w	$0C79,$0007,$0001,$7E2C
	bne.w	L16524
L16502	dc.w	$3039,$0001,$7B94
	btst	#$7,$62(a3)
	bne.w	L16514
	neg.w	d0
L16514	cmpi.w	#$D8,d0
	blt.w	L16524
	bset	#$4,$17F74.l
L16524	bra.w	doshot
doshot
	movem.l	d0-d7/a0-a3,-(sp)
	bclr	#$4,$17F78.l
	btst	#$1,$64(a3)
	beq.w	L16546
	bset	#$4,$17F78.l
L16546	bsr.w	Sub_317DC
	move.w	#$5,-(sp)
	dc.w	$33EB,$0052,$0001,$7E28
	bclr	#$3,$17F6A.l
	bset	#$5,$62(a3)
	btst	#$3,$64(a3)
	bne.w	L1657C
	move.w	$17BE0.l,d0
	cmp.w	$52(a3),d0
	bne.w	L167AE
L1657C	move.w	#$18,(sp)
	bset	#$4,$17F6C.l
	cmpi.w	#$92E,$58(a3)
	bne.w	L165A4
	move.w	#$14,(sp)
	dc.w	$3039,$0001,$7E2E
	lsr.w	#$2,d0
	dc.w	$9179,$0001,$7E2E
L165A4	btst	#$3,$64(a3)
	beq.w	L165C0
	movem.l	d0-d1,-(sp)
	move.w	#$1F,d0
	dc.w	$33C0,$0001,$7E2E
	movem.l	(sp)+,d0-d1
L165C0	clr.w	d0
	move.b	$6C(a3),d0
	lsr.b	#$1,d0
	movea.l	a3,a0
	dc.w	$4EB9,$0003,$C274
	addi.w	#$14,d0
	dc.w	$C0F9,$0001,$7E2E
	mulu.w	#$5249,d0
	swap	d0
	dc.w	$33C0,$0001,$7E2E
	btst	#$0,$6C(a3)
	beq.w	L165F8
	asr.w	#$4,d0
	dc.w	$D079,$0001,$7E2E
L165F8	lsr.w	#$4,d0
	neg.w	d0
	addi.w	#$3,d0
	bpl.w	L16606
	clr.w	d0
L16606	add.w	d0,(sp)
	st.b	$17BE0.l
	move.b	#$10,$5E(a3)
	dc.w	$33EB,$0052,$0001,$7E2A
	move.w	#$108,d1
	btst	#$7,$62(a3)
	bne.w	L1662C
	neg.w	d1
L1662C	dc.w	$3439,$0001,$7E2C
	asl.w	#$2,d2
	dc.w	$41FA,$0182
	move.w	(a0,d2.w),d0
	move.w	$2(a0,d2.w),d2
	dc.w	$9079,$0001,$7B80
	dc.w	$9279,$0001,$7B94
	movem.w	d0-d2,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	bsr.w	Sroot
	tst.w	d0
	bne.w	L16664
	addi.w	#$1,d0
L16664	move.w	d0,d3
	btst	#$4,$17F68.l
	bne.w	L1670A
	cmpi.w	#$C8,d3
	bhi.w	L166A2
	jsr	(ReadGoaliePulled).l
	bmi.w	L1670A
	btst	#$0,$17F78.l
	bne.w	L1670A
	moveq	#$10,d0
	add.b	$6D(a3),d0
	bsr.w	randomd0
	cmpi.w	#$E,d0
	bgt.w	L1670A
L166A2	clr.w	d0
	move.b	$6D(a3),d0
	lsr.w	#$1,d0
	move.b	d0,-(sp)
	dc.w	$3039,$0001,$7E2E
	lsr.w	#$4,d0
	sub.b	(sp)+,d0
	addi.b	#$10,d0
	mulu.w	d3,d0
	lsr.w	#$6,d0
	cmpi.w	#$FA,d3
	bhi.w	L166C8
	lsr.w	#$1,d0
L166C8	cmpi.w	#$88,d0
	blt.w	L166D4
	move.w	#$88,d0
L166D4	move.w	d0,-(sp)
	bsr.w	Sub_37044
	add.w	d0,$2(sp)
	move.w	(sp),d0
	cmpi.w	#$3C,d0
	bls.w	L166EC
	moveq	#$3C,d0
	move.w	d0,(sp)
L166EC	tst.w	$4(sp)
	bpl.w	L166F6
	lsr.w	#$1,d0
L166F6	bsr.w	Sub_37044
	add.w	d0,$4(sp)
	move.w	(sp)+,d0
	lsr.w	#$1,d0
	bsr.w	randomd0
	add.w	d0,$4(sp)
L1670A	dc.w	$3439,$0001,$7E2E
	muls.w	#$44,d2
	muls.w	(sp)+,d2
	divs.w	d3,d2
	dc.w	$33C2,$0001,$7BA8
	dc.w	$3439,$0001,$7E2E
	muls.w	#$44,d2
	muls.w	(sp)+,d2
	divs.w	d3,d2
	dc.w	$33C2,$0001,$7BAA
	move.w	#$8000,d1
	btst	#$7,$62(a3)
	beq.w	L16742
	clr.w	d1
L16742	eor.w	d2,d1
	bpl.w	L16762
	dc.w	$33FC,$3810,$0001,$7BAA
	btst	#$7,$62(a3)
	bne.w	L16762
	dc.w	$33FC,$C7F0,$0001,$7BAA
L16762	move.w	(sp)+,d1
	beq.w	L167AE
	dc.w	$C2F9,$0001,$7E2E
	mulu.w	#$44,d1
	divu.w	d3,d1
	mulu.w	#$B33,d3
	dc.w	$86F9,$0001,$7E2E
	add.w	d1,d3
	cmpi.w	#$1800,d3
	bls.w	L1678C
	move.w	#$1800,d3
L1678C	dc.w	$33C3,$0001,$7BAC
	bclr	#$4,$17F74.l
	beq.w	L167AE
	btst	#$3,$64(a3)
	bne.w	L167AE
	jsr	(puckvzadj).l
L167AE	bsr.w	sfx
	movem.l	(sp)+,d0-d7/a0-a3
L167B6	rts
shotdiradj
	ori.b	#$C,d0
	ori.b	#$C,(a0)
	ori.b	#$6,(a0)
	ori.b	#$0,(a0)
	ori.b	#$0,d0
	dc.w	$FFF0
	dc.l	$FFF0
	dc.w	$0006,$FFF0
	dc.w	$000C,$0000,$0006
Sub_317DC
	btst	#$3,$64(a3)
	bne.w	L167F0
	btst	#$3,$62(a3)
	bne.w	L168C6
L167F0	moveq	#$8,d0
	moveq	#$5,d1
	movea.l	#$17400,a0
	btst	#$6,$62(a3)
	bne.w	L16808
	adda.w	#$300,a0
L16808	adda.w	#$80,a0
	tst.w	$34(a0)
	dbeq	d1,L16808
	bne.w	L168A2
	move.b	$28(a0),d0
	ext.w	d0
	asr.w	#$1,d0
	add.w	$0(a0),d0
	dc.w	$9079,$0001,$7B80
	move.b	$2A(a0),d1
	ext.w	d1
	asr.w	#$1,d1
	add.w	$14(a0),d1
	dc.w	$9279,$0001,$7B94
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	addq.l	#$1,d0
	bsr.w	Sroot
	move.w	d0,d2
	movem.w	(sp)+,d0-d1
	moveq	#$12,d3
	move.w	#$108,d4
	btst	#$7,$62(a3)
	bne.w	L16864
	neg.w	d4
L16864	movem.w	d3-d4,-(sp)
	bsr.w	L168C8
	move.w	d4,d5
	movem.w	(sp)+,d3-d4
	neg.w	d3
	bsr.w	L168C8
	add.w	d5,d4
	clr.w	d0
	cmpi.w	#$2C,d4
	bgt.w	L168A2
	cmpi.w	#$FFD4,d4
	blt.w	L168A2
	btst	#$7,$62(a3)
	beq.w	L16898
	neg.w	d4
L16898	moveq	#$2,d0
	tst.w	d4
	bpl.w	L168A2
	moveq	#$6,d0
L168A2	dc.w	$33C0,$0001,$7E2C
	btst	#$2,$17F70.l
	bne.w	L168C0
	btst	#$0,$17F78.l
	beq.w	L168C6
L168C0	jsr	(PSandSOpassdir).l
L168C6	rts
L168C8	dc.w	$9679,$0001,$7B80
	dc.w	$9879,$0001,$7B94
	muls.w	d0,d4
	muls.w	d1,d3
	sub.l	d3,d4
	divs.w	d2,d4
	rts
setpads
	movem.l	d0-d1,-(sp)
	moveq	#$2,d0
	add.w	d4,d0
	add.w	d0,d0
	move.w	#$FFF0,d1
	rol.w	d0,d1
	dc.w	$C379,$0001,$7DC8
	move.w	$52(a3),d1
	asl.w	d0,d1
	dc.w	$8379,$0001,$7DC8
	movem.l	(sp)+,d0-d1
L16904	rts
Sub_31906
	btst	#$2,$17F70.l
	bne.w	L16904
	btst	#$3,$62(a3)
	bne.w	L16904
	btst	#$4,$63(a3)
	bne.w	L16904
	tst.b	$60(a3)
	bpl.w	L16936
	tst.b	$61(a3)
	bmi.w	L16904
L16936	move.b	$61(a3),d0
	cmp.b	$66(a3),d0
	beq.w	L16972
	move.w	$36(a3),d0
	cmpi.b	#$B,$38(a3,d0.w)
	beq.w	L16904
	move.w	$52(a3),d0
	cmp.w	$17BE0.l,d0
	beq.w	L16904
	adda.w	#$4,sp
	bset	#$2,$63(a3)
	clr.w	$40(a3)
	moveq	#$B,d0
	bra.w	Sub_362E4
L16972	adda.w	#$4,sp
	bclr	#$2,$63(a3)
	bclr	#$2,$62(a3)
	st.b	$61(a3)
	st.b	$60(a3)
	move.w	$34(a3),d0
	tst.b	$60(a3)
	bpl.w	L1699C
	dc.w	$4EF9,$0003,$D754
L1699C	move.b	$60(a3),d0
	ext.w	d0
	move.w	d0,$34(a3)
	dc.w	$4EF9,$0003,$D754
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_169AC.bin
Sub_31AB6
	rts
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_16AB8.bin
assdopen
	btst	#$5,$62(a3)
	bne.w	Sub_31AB6
	moveq	#$10,d0
	btst	#$6,$62(a3)
	beq.w	L16CFA
	moveq	#$1,d0
L16CFA	dc.w	$D139,$0001,$8068
	st.b	$34(a3)
	clr.w	$6(a3)
	rts
assepen
	btst	#$5,$62(a3)
	bne.w	Sub_31AB6
	bclr	#$1,$62(a3)
	beq.w	L16D6E
	bset	#$2,$62(a3)
	bset	#$2,$63(a3)
	moveq	#$10,d0
	moveq	#-60,d1
	btst	#$6,$62(a3)
	beq.w	L16D3C
	moveq	#$1,d0
	neg.w	d1
L16D3C	dc.w	$9139,$0001,$8068
	move.w	d1,$14(a3)
	clr.w	$28(a3)
	clr.w	$2A(a3)
	move.w	#$86,$0(a3)
	move.w	#$2,$54(a3)
	bset	#$5,$62(a3)
	move.w	#$FAC,d1
	bsr.w	Sub_363C0
	dc.w	$4EF9,$0003,$F03E
L16D6E	move.w	#$4,$54(a3)
	st.b	$61(a3)
	st.b	$60(a3)
	bclr	#$3,$62(a3)
	bclr	#$2,$62(a3)
	bclr	#$5,$63(a3)
	bclr	#$2,$63(a3)
	move.w	#$F000,$28(a3)
	bra.w	Sub_362C4
assgoaliebreakwait
	btst	#$5,$62(a3)
	bne.w	L16DFC
	btst	#$2,$17F70.l
	bne.w	L16DC6
	btst	#$0,$17F78.l
	bne.w	L16DC6
	nop
	bra.w	Sub_362C4
L16DC6	clr.w	$28(a3)
	clr.w	$2A(a3)
	movem.l	d0/a0,-(sp)
	dc.w	$207C,$0001,$7480
	dc.w	$3039,$0001,$936A
	asl.w	#$7,d0
	adda.w	d0,a0
	move.w	#$191,$14(a3)
	btst	#$7,$62(a0)
	bne.w	L16DF8
	move.w	#$FE6F,$14(a3)
L16DF8	movem.l	(sp)+,d0/a0
L16DFC	rts
assfaceoff
	btst	#$5,$62(a3)
	bne.w	L16E14
	btst	#$0,$17F6C.l
	beq.w	Sub_362C4
L16E14	rts
assfaceoffpl
	btst	#$5,$62(a3)
	bne.w	L16E14
	btst	#$0,$17F6C.l
	beq.w	L16EA4
	bclr	#$1,$62(a3)
	beq.w	L16E3A
	clr.w	$40(a3)
L16E3A	dc.w	$207C,$0001,$7CF8
	btst	#$6,$62(a3)
	beq.w	L16E4E
	adda.w	#$4,a0
L16E4E	move.w	$5A(a3),d0
	lsr.w	#$2,d0
	addi.w	#$1,d0
	tst.b	$76(a3)
	bne.w	L16E64
	addi.w	#$3,d0
L16E64	move.w	d0,(a0)
	btst	#$3,$62(a3)
	bne.w	Sub_31AB6
	bset	#$1,$63(a3)
	bne.w	Sub_31AB6
	move.w	#$FEA,d1
	cmpi.w	#$10,$17BC0.l
	bls.w	L16E9A
	moveq	#$8,d0
	bsr.w	randomd0
	tst.w	d0
	beq.w	L16E9A
	move.w	#$1014,d1
L16E9A	bset	#$1,$63(a3)
	bra.w	Sub_363C0
L16EA4	move.b	#$14,$5E(a3)
	bra.w	Sub_362C4
	dc.w	$4E75,$4E75
