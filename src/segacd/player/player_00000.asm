; Entry stub of the player program (jump block)
PlayerEntryStub	dc.b	$08,$B9,$00,$05,$00,$FF,$80,$0F,$2C,$7C,$00,$00,$AE,$6E,$9D,$FC	; ........,|...n..
	dc.b	$00,$00,$00,$00,$4F,$FB,$E8,$EA,$2F,$0E,$2C,$7C,$00,$00,$A5,$94	; ....O.../.,|....
	dc.b	$4D,$FB,$E8,$DE	; M...
; Player screen initialisation
PlInit	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	InstallVblankHook
	lea.l	PlVblankHandler(pc),a0
	move.l	a0,$D2(a6)
	move.w	d0,$7C(a6)
	move.w	d1,$7E(a6)
	move.w	d2,$BC(a6)
	bsr.w	GateArrayLoadCmd
	move.w	#$6,d7
	jsr	$6044.w
	move.l	a0,$DA(a6)
	movea.l	a0,a2
	move.w	#$4026,d0
	movea.l	#$AFF60,a1
.loop	move.l	(a1)+,(a2)+
	dbra	d0,.loop
	movea.l	$DA(a6),a0
	adda.l	#$100A0,a0
	move.l	a0,$8E(a6)
	adda.l	#$100,a0
	move.l	a0,$92(a6)
	adda.l	#$280,a0
	move.l	a0,$8A(a6)
	adda.l	#$1F80,a0
	move.w	#$2,d7
	jsr	$6044.w
	clr.w	$C6(a6)
	clr.w	$C8(a6)
	clr.w	$C2(a6)
	clr.w	$DE(a6)
	clr.w	$F6(a6)
	clr.w	$F2(a6)
	move.w	#$2,$F8(a6)
	clr.w	$80(a6)
	move.w	#$0,$56(a6)
	move.w	#$7,$5E(a6)
	move.w	#$FF90,$5C(a6)
	move.w	$7C(a6),d0
	move.w	$7E(a6),d1
	andi.l	#$FFFF,d0
	andi.l	#$FFFF,d1
	addi.l	#$44,d0
	addi.l	#$44,d1
	movea.l	d0,a2
; Loads a picture through the tile decoder
PlLoadPictureA	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	a2,d0
	jsr	$6044.w
	move.l	a0,$FE(a6)
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	$FE(a6),a0
	movea.l	d0,a2
; Loads a picture through the tile decoder (second form)
PlLoadPictureB	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	a2,d0
	jsr	$6044.w
	move.l	a0,$FE(a6)
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	$FE(a6),a0
	move.l	a0,d2
	move.l	(a0),$4(a6)
	add.l	d2,$4(a6)
	move.l	$4(a0),$0(a6)
	add.l	d2,$0(a6)
	move.l	$8(a0),$8(a6)
	add.l	d2,$8(a6)
	movea.l	d1,a2
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	a2,d0
	jsr	$6044.w
	move.l	a0,$FE(a6)
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	$FE(a6),a0
	move.l	a0,d2
	move.l	(a0),$10(a6)
	add.l	d2,$10(a6)
	move.l	$4(a0),$C(a6)
	add.l	d2,$C(a6)
	move.l	$8(a0),$14(a6)
	add.l	d2,$14(a6)
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$40,d0
	jsr	$6044.w
	move.l	a0,$70(a6)
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$22,d0
	jsr	$6044.w
	move.l	a0,$86(a6)
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	$86(a6),a2
	move.l	a2,d2
	moveq	#$1B,d0
.loop	add.l	d2,(a2)+
	dbra	d0,.loop
	move.w	#$6,d7
	jsr	$6044.w
	move.l	a0,$A2(a6)
	bsr.w	LCAA
	bset.b	#$5,$FF800F.l
	movea.l	#$BBCB0,a0
	moveq	#$1F,d0
.loop2	clr.l	(a0)+
	dbra	d0,.loop2
	move.w	#$18,$EC(a6)
.loop3	tst.w	$EC(a6)
	bpl.w	.loop3
.loop4	btst.b	#$7,$FF800E.l
	bne.b	.loop4
	move.w	#$20,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop5	btst.b	#$6,$FF800E.l
	beq.b	.loop5
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop6	btst.b	#$6,$FF800E.l
	bne.b	.loop6
	bclr.b	#$7,$FF800F.l
.loop7	btst.b	#$7,$FF800E.l
	bne.b	.loop7
	move.w	#$8164,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop8	btst.b	#$6,$FF800E.l
	beq.b	.loop8
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop9	btst.b	#$6,$FF800E.l
	bne.b	.loop9
	bclr.b	#$7,$FF800F.l
.loop10	btst.b	#$7,$FF800E.l
	bne.b	.loop10
	move.w	#$8C81,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop11	btst.b	#$6,$FF800E.l
	beq.b	.loop11
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop12	btst.b	#$6,$FF800E.l
	bne.b	.loop12
	bclr.b	#$7,$FF800F.l
.loop13	btst.b	#$7,$FF800E.l
	bne.b	.loop13
	move.w	#$9003,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop14	btst.b	#$6,$FF800E.l
	beq.b	.loop14
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop15	btst.b	#$6,$FF800E.l
	bne.b	.loop15
	bclr.b	#$7,$FF800F.l
.loop16	btst.b	#$7,$FF800E.l
	bne.b	.loop16
	move.w	#$8200,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop17	btst.b	#$6,$FF800E.l
	beq.b	.loop17
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop18	btst.b	#$6,$FF800E.l
	bne.b	.loop18
	bclr.b	#$7,$FF800F.l
.loop19	btst.b	#$7,$FF800E.l
	bne.b	.loop19
	move.w	#$8401,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop20	btst.b	#$6,$FF800E.l
	beq.b	.loop20
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop21	btst.b	#$6,$FF800E.l
	bne.b	.loop21
	bclr.b	#$7,$FF800F.l
.loop22	btst.b	#$7,$FF800E.l
	bne.b	.loop22
	move.w	#$8574,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop23	btst.b	#$6,$FF800E.l
	beq.b	.loop23
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop24	btst.b	#$6,$FF800E.l
	bne.b	.loop24
	bclr.b	#$7,$FF800F.l
.loop25	btst.b	#$7,$FF800E.l
	bne.b	.loop25
	move.w	#$8D3C,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop26	btst.b	#$6,$FF800E.l
	beq.b	.loop26
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop27	btst.b	#$6,$FF800E.l
	bne.b	.loop27
	bclr.b	#$7,$FF800F.l
.loop28	btst.b	#$7,$FF800E.l
	bne.b	.loop28
	move.w	#$832C,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop29	btst.b	#$6,$FF800E.l
	beq.b	.loop29
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop30	btst.b	#$6,$FF800E.l
	bne.b	.loop30
	bclr.b	#$7,$FF800F.l
.loop31	btst.b	#$7,$FF800E.l
	bne.b	.loop31
	move.w	#$9100,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop32	btst.b	#$6,$FF800E.l
	beq.b	.loop32
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop33	btst.b	#$6,$FF800E.l
	bne.b	.loop33
	bclr.b	#$7,$FF800F.l
.loop34	btst.b	#$7,$FF800E.l
	bne.b	.loop34
	move.w	#$9200,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop35	btst.b	#$6,$FF800E.l
	beq.b	.loop35
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop36	btst.b	#$6,$FF800E.l
	bne.b	.loop36
	bclr.b	#$7,$FF800F.l
.loop37	btst.b	#$7,$FF800E.l
	bne.b	.loop37
	move.w	#$8F02,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop38	btst.b	#$6,$FF800E.l
	beq.b	.loop38
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop39	btst.b	#$6,$FF800E.l
	bne.b	.loop39
	bclr.b	#$7,$FF800F.l
.loop40	btst.b	#$7,$FF800E.l
	bne.b	.loop40
	move.w	#$8B00,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop41	btst.b	#$6,$FF800E.l
	beq.b	.loop41
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop42	btst.b	#$6,$FF800E.l
	bne.b	.loop42
	bclr.b	#$7,$FF800F.l
.loop43	btst.b	#$7,$FF800E.l
	bne.b	.loop43
	move.l	#$70000003,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop44	btst.b	#$6,$FF800E.l
	beq.b	.loop44
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop45	btst.b	#$6,$FF800E.l
	bne.b	.loop45
	bclr.b	#$7,$FF800F.l
.loop46	btst.b	#$7,$FF800E.l
	bne.b	.loop46
	move.l	#$0,$FF8022.l
	move.w	#$E,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop47	btst.b	#$6,$FF800E.l
	beq.b	.loop47
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop48	btst.b	#$6,$FF800E.l
	bne.b	.loop48
	bclr.b	#$7,$FF800F.l
.loop49	btst.b	#$7,$FF800E.l
	bne.b	.loop49
	move.l	#$40000010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop50	btst.b	#$6,$FF800E.l
	beq.b	.loop50
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop51	btst.b	#$6,$FF800E.l
	bne.b	.loop51
	bclr.b	#$7,$FF800F.l
.loop52	btst.b	#$7,$FF800E.l
	bne.b	.loop52
	move.l	#$0,$FF8022.l
	move.w	#$E,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop53	btst.b	#$6,$FF800E.l
	beq.b	.loop53
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop54	btst.b	#$6,$FF800E.l
	bne.b	.loop54
	bclr.b	#$7,$FF800F.l
.loop55	btst.b	#$7,$FF800E.l
	bne.b	.loop55
	move.l	#$68000003,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop56	btst.b	#$6,$FF800E.l
	beq.b	.loop56
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop57	btst.b	#$6,$FF800E.l
	bne.b	.loop57
	bclr.b	#$7,$FF800F.l
.loop58	btst.b	#$7,$FF800E.l
	bne.b	.loop58
	move.l	#$0,$FF8022.l
	move.w	#$E,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop59	btst.b	#$6,$FF800E.l
	beq.b	.loop59
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop60	btst.b	#$6,$FF800E.l
	bne.b	.loop60
	bclr.b	#$7,$FF800F.l
	move.l	#$7A0,$62(a6)
	move.l	#$1000,d0
	bsr.w	PlDmaRequest
	move.l	#$20001000,d0
	bsr.w	PlDmaRequest
	move.l	#$B0000700,d0
	bsr.w	PlDmaRequest
	move.w	#$7000,$FC(a6)
	lea.l	PlTimerTick(pc),a0
	move.l	a0,$D2(a6)
	move.w	#$0,$EC(a6)
.loop61	tst.w	$EC(a6)
	beq.b	.loop61
	lea.l	PlVblankHandler(pc),a0
	move.l	a0,$D2(a6)
	moveq	#$0,d6
	moveq	#$0,d4
	move.w	#$2000,$EE(a6)
	move.w	#$0,$18(a6)
	movea.l	$70(a6),a1
	move.w	$2(a1),d0
	lea.l	$4(a1),a1
	lsl.w	#$4,d0
	move.w	d0,$E0(a6)
	move.w	#$F400,$E2(a6)
	movea.l	#$BC000,a2
	move.l	a2,$E4(a6)
	subq.w	#$1,d0
.loop62	move.w	(a1)+,(a2)+
	dbra	d0,.loop62
	move.w	#$1,$DE(a6)
.loop63	tst.w	$DE(a6)
	bne.w	.loop63
	lea.l	PlBackgroundImage(pc),a1
	move.l	a1,$74(a6)
	movea.l	$74(a6),a1
	move.w	$2(a1),d0
	lea.l	$4(a1),a1
	lsl.w	#$4,d0
	move.w	d0,$E0(a6)
	move.w	#$A000,$E2(a6)
	movea.l	#$BC000,a2
	move.l	a2,$E4(a6)
	subq.w	#$1,d0
.loop64	move.w	(a1)+,(a2)+
	dbra	d0,.loop64
	move.w	#$1,$DE(a6)
.loop65	tst.w	$DE(a6)
	bne.w	.loop65
	adda.l	#$4,a1
	move.l	a1,$78(a6)
	bsr.w	PlDrawPicture
	move.w	d4,d0
	bsr.w	PlSelectPicture
	bsr.w	PlUnpackNibbles
	move.w	#$18,$EC(a6)
.loop66	tst.w	$EC(a6)
	bpl.w	.loop66
	bsr.w	LDEC
	move.w	#$7,$BA(a6)
.loop67	move.l	#$B0000700,d0
	bsr.w	PlDmaRequest
	move.w	d4,d7
	bsr.w	UpdatePad1
	move.b	d0,$BE(a6)
	move.b	d1,$BF(a6)
	move.b	d2,$C0(a6)
	move.b	d3,$C1(a6)
	move.w	d1,d5
	bsr.w	UpdatePad2
	or.w	d1,d5
	or.b	d0,$BE(a6)
	or.b	d1,$BF(a6)
	or.b	d2,$C0(a6)
	or.b	d3,$C1(a6)
.loop68	cmpi.b	#$80,d5
	beq.w	.next23
	cmpi.b	#$28,$C1(a6)
	bne.w	.next2
	cmpi.w	#$1,d4
	beq.w	.next
	cmpi.w	#$0,d4
	bne.w	.next2
	cmpi.w	#$0,$5A(a6)
	ble.w	.loop67
	subi.w	#$1,$5A(a6)
	move.w	#$4,$B0(a6)
	bsr.w	PlDrawPicture
	moveq	#$7,d0
	bsr.w	LEAA
	bra.w	.loop67
.next	cmpi.w	#$0,$54(a6)
	beq.w	.loop67
	cmpi.w	#$0,$58(a6)
	ble.w	.loop67
	subi.w	#$1,$58(a6)
	move.w	#$4,$B0(a6)
	bsr.w	PlShowPicture
	move.b	#$0,$C1(a6)
	moveq	#$7,d0
	bsr.w	LEAA
	bra.w	.loop67
.next2	cmpi.b	#$24,$C1(a6)
	bne.w	.next4
	cmpi.w	#$1,d4
	beq.w	.next3
	cmpi.w	#$0,d4
	bne.w	.next4
	cmpi.w	#$FFFF,$58(a6)
	beq.w	.loop67
	addi.w	#$1,$5A(a6)
	move.w	#$3,$B0(a6)
	bsr.w	PlDrawPicture
	moveq	#$7,d0
	bsr.w	LEAA
	bra.w	.loop67
.next3	cmpi.w	#$0,$54(a6)
	beq.w	.loop67
	move.w	$58(a6),d0
	cmp.w	$BA(a6),d0
	bgt.w	.loop67
	addi.w	#$1,$58(a6)
	move.w	#$3,$B0(a6)
	bsr.w	PlShowPicture
	move.b	#$0,$C1(a6)
	moveq	#$7,d0
	bsr.w	LEAA
	bra.w	.loop67
.next4	cmpi.b	#$8,d5
	bne.w	.next6
	move.w	#$0,$F8(a6)
	subq.w	#$1,d4
	moveq	#$1,d6
	move.w	$EE(a6),d0
	move.w	d0,$F0(a6)
	addi.w	#$50,d0
	cmpi.w	#$2100,d0
	blt.w	.next5
	subi.w	#$100,d0
.next5	move.w	d0,$EE(a6)
	bra.w	.next16
.next6	cmpi.b	#$4,d5
	bne.w	.next8
	move.w	#$1,$F8(a6)
	addq.w	#$1,d4
	moveq	#$1,d6
	move.w	$EE(a6),d0
	move.w	d0,$F0(a6)
	subi.w	#$50,d0
	cmpi.w	#$2000,d0
	bge.w	.next7
	addi.w	#$100,d0
.next7	move.w	d0,$EE(a6)
	bra.w	.next16
.next8	cmpi.b	#$40,d5
	bne.w	.next9
	move.w	$18(a6),d0
	eori.w	#$1,d0
	move.w	d0,$18(a6)
	moveq	#$1,d6
	move.w	#$2,$F8(a6)
	clr.w	$80(a6)
	move.w	#$0,$54(a6)
	move.w	#$0,$56(a6)
	move.w	#$0,$58(a6)
	move.w	#$0,$5A(a6)
	move.w	#$0,$B0(a6)
	bra.w	.next18
.next9	cmpi.b	#$10,d5
	bne.w	.next11
	cmpi.w	#$0,d4
	beq.w	.next10
	cmpi.w	#$1,d4
	bne.w	.next11
	move.w	#$0,$54(a6)
	clr.w	$56(a6)
	clr.w	$58(a6)
	move.w	#$0,$B0(a6)
	bsr.w	PlShowPicture
	moveq	#$7,d0
	bsr.w	LEAA
	bra.w	.next18
.next10	addi.w	#$1,$80(a6)
	addi.b	#$1,$104(a6)
	addi.b	#$1,$105(a6)
	move.w	#$0,$56(a6)
	move.w	#$0,$5A(a6)
	move.w	#$0,$B0(a6)
	bsr.w	PlDrawPicture
	moveq	#$7,d0
	bsr.w	LEAA
	bra.w	.next18
.next11	cmpi.b	#$1,d5
	bne.w	.next13
	cmpi.w	#$0,d4
	bne.w	.next12
	addi.w	#$1,$56(a6)
	move.w	#$1,$B0(a6)
	bsr.w	PlDrawPicture
	bra.w	.loop67
.next12	cmpi.w	#$1,d4
	bne.w	.next13
	cmpi.w	#$1,$54(a6)
	bne.w	.next13
	addi.w	#$1,$56(a6)
	move.w	#$1,$B0(a6)
	bsr.w	PlShowPicture
	bra.w	.loop67
.next13	cmpi.b	#$2,d5
	bne.w	.loop67
	cmpi.w	#$0,d4
	bne.w	.next15
	subi.w	#$1,$56(a6)
	cmpi.w	#$0,$56(a6)
	bge.w	.next14
	clr.w	$56(a6)
	bra.w	.loop67
.next14	move.w	#$2,$B0(a6)
	bsr.w	PlDrawPicture
	bra.w	.loop67
.next15	cmpi.w	#$1,d4
	bne.w	.loop67
	cmpi.w	#$1,$54(a6)
	bne.w	.loop67
	cmpi.w	#$1,$56(a6)
	blt.w	.loop67
	subi.w	#$1,$56(a6)
	move.w	#$2,$B0(a6)
	bsr.w	PlShowPicture
	bra.w	.loop67
.next16	cmpi.w	#$0,d4
	bge.w	.next17
	moveq	#$0,d4
	moveq	#$0,d6
	move.w	$F0(a6),$EE(a6)
	bra.b	.next18
.next17	cmpi.w	#$2,d4
	ble.w	.next18
	moveq	#$2,d4
	moveq	#$0,d6
	move.w	$F0(a6),$EE(a6)
.next18	tst.w	d6
	beq.w	.loop67
	move.l	d4,d0
	clr.w	$56(a6)
	clr.w	$58(a6)
	bsr.w	PlSelectPicture
	move.w	#$64,$EC(a6)
.loop69	tst.w	$EC(a6)
	bpl.w	.loop69
	cmpi.w	#$1,d7
	bne.w	.next19
	cmpi.w	#$1,$54(a6)
	bne.w	.next19
	cmpi.w	#$2,$F8(a6)
	beq.w	.next19
.next19	cmpi.w	#$0,d4
	bne.w	.next20
	bsr.w	PlDrawPicture
.next20	cmpi.w	#$1,d4
	bne.w	.next21
	bsr.w	PlShowPicture
.next21	cmpi.w	#$2,$F8(a6)
	beq.w	.next22
	move.w	#$140,$F4(a6)
	move.w	#$1,$FA(a6)
.loop70	tst.w	$FA(a6)
	bne.w	.loop70
.next22	moveq	#$0,d6
	cmpi.w	#$2,d4
	bne.w	.loop67
	bsr.w	PlDecodePicture
	move.w	$AE(a6),d5
	bra.w	.loop68
.next23	movea.l	#$BBCB0,a0
	moveq	#$1F,d0
.loop71	clr.l	(a0)+
	dbra	d0,.loop71
	move.w	#$18,$EC(a6)
.loop72	tst.w	$EC(a6)
	bpl.w	.loop72
	bsr.w	GateArrayLoadCmd
	bclr.b	#$5,$FF800F.l
	move.l	#$3FFF,d0
	movea.l	$DA(a6),a1
	movea.l	#$AFF60,a2
.loop73	move.l	(a1)+,(a2)+
	dbra	d0,.loop73
	move.l	#$13,d0
.loop74	move.l	(a1)+,(a2)+
	dbra	d0,.loop74
	bsr.w	RemoveVblankHook
	movem.l	(sp)+,d0-d7/a0-a6
	movea.l	(sp)+,a6
	move.w	#$4,d7
	jsr	$6044.w
LCAA	move.l	#$6,d0
	move.l	d0,d1
	add.w	$7C(a6),d0
	add.w	$7E(a6),d1
	lea.l	PlayerEntryStub(pc),a1
	movea.l	d0,a2
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	a2,d0
	jsr	$6044.w
	move.l	a0,$1C(a6)
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	$1C(a6),a2
	move.l	a2,d2
.loop	add.l	d2,(a2)+
	tst.w	(a2)
	bpl.w	.loop
	lea.l	$24(a6),a3
	lea.l	-$10(a2),a4
	move.l	(a4)+,(a3)+
	move.l	(a4)+,(a3)+
	move.l	(a4)+,(a3)+
	move.l	(a4)+,(a3)+
	lea.l	$2(a2),a2
	move.l	a2,$48(a6)
	movea.l	d1,a2
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	a2,d0
	jsr	$6044.w
	move.l	a0,$20(a6)
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	$20(a6),a2
	move.l	a2,d2
.loop2	add.l	d2,(a2)+
	tst.w	(a2)
	bpl.w	.loop2
	lea.l	$34(a6),a3
	lea.l	-$10(a2),a4
	move.l	(a4)+,(a3)+
	move.l	(a4)+,(a3)+
	move.l	(a4)+,(a3)+
	move.l	(a4)+,(a3)+
	lea.l	$2(a2),a2
	move.l	a2,$4C(a6)
	movea.l	$2C(a6),a0
	cmpi.l	#$12345678,(a0)
	bne.w	.next
	move.l	#$0,$2C(a6)
.next	movea.l	$30(a6),a0
	cmpi.l	#$12345678,(a0)
	bne.w	.next2
	move.l	#$0,$30(a6)
.next2	movea.l	$3C(a6),a0
	cmpi.l	#$12345678,(a0)
	bne.w	.next3
	move.l	#$0,$3C(a6)
.next3	movea.l	$40(a6),a0
	cmpi.l	#$12345678,(a0)
	bne.w	.next4
	move.l	#$0,$40(a6)
.next4	movea.l	$24(a6),a0
	cmpi.l	#$12345678,(a0)
	bne.w	.next5
	move.l	#$0,$24(a6)
.next5	movea.l	$34(a6),a0
	cmpi.l	#$12345678,(a0)
	bne.w	.next6
	move.l	#$0,$34(a6)
.next6	movea.l	$28(a6),a0
	cmpi.l	#$12345678,(a0)
	bne.w	.next7
	move.l	#$0,$28(a6)
.next7	movea.l	$38(a6),a0
	cmpi.l	#$12345678,(a0)
	bne.w	.ex
	move.l	#$0,$38(a6)
.ex	rts
LDEC	movem.l	d0-d7/a1-a2,-(sp)
	move.w	#$50,d0
	move.l	#$B0000080,d1
	move.w	$EE(a6),d2
	subi.w	#$2000,d2
	swap	d2
	move.w	#$100,d2
	move.w	#$13,d3
	bsr.w	PlBlitToBuffer
	moveq	#$14,d0
	moveq	#$0,d1
	bsr.w	LF64
	moveq	#$0,d0
	movea.l	#$91EC,a1
	suba.l	#$0,a1
	lea.l	PlayerEntryStub(pc),a2
	adda.l	a2,a1
	move.w	$2(a1),d0
	lea.l	$4(a1),a1
	lsl.w	#$4,d0
	move.w	$FC(a6),d1
	eori.w	#$3000,d1
	move.w	d1,$E2(a6)
	move.w	d0,$E0(a6)
	move.l	a1,$E4(a6)
	move.w	#$1,$DE(a6)
.loop	tst.w	$DE(a6)
	bne.w	.loop
	add.w	d0,d0
	lea.l	(a1,d0.w),a1
	move.w	#$0,$B2(a6)
	move.w	d1,d5
	lsr.w	#$5,d5
	move.l	#$B296,d3
	move.l	#$80,d6
	bsr.w	PlCopyRectToVdp
	clr.l	$96(a6)
.loop2	bsr.w	UpdatePad1
	tst.w	d1
	bne.w	.next
	bsr.w	UpdatePad2
	tst.w	d1
	bne.w	.next
	cmpi.l	#$258,$96(a6)
	ble.w	.loop2
.next	moveq	#$0,d0
	moveq	#$0,d1
	bsr.w	LF64
	movem.l	(sp)+,d0-d7/a1-a2
	rts
LEAA	clr.w	$102(a6)
.loop	tst.w	$102(a6)
	beq.w	.loop
	dbra	d0,LEAA
	rts
LEBC	movem.l	d0-d2,-(sp)
.loop	btst.b	#$7,$FF800E.l
	bne.b	.loop
	move.l	#$40000010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop2	btst.b	#$6,$FF800E.l
	beq.b	.loop2
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop3	btst.b	#$6,$FF800E.l
	bne.b	.loop3
	bclr.b	#$7,$FF800F.l
.loop4	btst.b	#$7,$FF800E.l
	bne.b	.loop4
	move.w	#$0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop5	btst.b	#$6,$FF800E.l
	beq.b	.loop5
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop6	btst.b	#$6,$FF800E.l
	bne.b	.loop6
	bclr.b	#$7,$FF800F.l
	movem.l	(sp)+,d0-d2
	rts
LF64	addi.w	#$9200,d0
.loop	btst.b	#$7,$FF800E.l
	bne.b	.loop
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop2	btst.b	#$6,$FF800E.l
	beq.b	.loop2
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop3	btst.b	#$6,$FF800E.l
	bne.b	.loop3
	bclr.b	#$7,$FF800F.l
	addi.w	#$9100,d1
.loop4	btst.b	#$7,$FF800E.l
	bne.b	.loop4
	move.w	d1,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop5	btst.b	#$6,$FF800E.l
	beq.b	.loop5
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop6	btst.b	#$6,$FF800E.l
	bne.b	.loop6
	bclr.b	#$7,$FF800F.l
	rts
; Sets up the tile window parameters (d0 position, d1 size) for a text box.
PlSetupWindow	movem.l	d0-d6,-(sp)
	moveq	#$0,d2
	move.w	d0,d1
	swap	d0
	move.w	#$7A0,d3
	bset	#$E,d3
	moveq	#$9,d4
	move.w	d4,d5
	moveq	#$A,d6
.loop	moveq	#$0,d2
	move.w	d0,d2
	lsl.l	#$2,d2
	lsr.w	#$2,d2
	swap	d2
	addi.l	#$40000000,d2
.loop2	btst.b	#$7,$FF800E.l
	bne.b	.loop2
	move.l	d2,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop3	btst.b	#$6,$FF800E.l
	beq.b	.loop3
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop4	btst.b	#$6,$FF800E.l
	bne.b	.loop4
	bclr.b	#$7,$FF800F.l
.loop5	btst.b	#$7,$FF800E.l
	bne.b	.loop5
	move.w	d3,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop6	btst.b	#$6,$FF800E.l
	beq.b	.loop6
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop7	btst.b	#$6,$FF800E.l
	bne.b	.loop7
	bclr.b	#$7,$FF800F.l
	dbra	d4,.loop5
	move.w	d5,d4
	add.w	d1,d0
	dbra	d6,.loop
	movem.l	(sp)+,d0-d6
	rts
; Draws the page selected by d0 (1 or 2, otherwise the default page).
PlDrawPage	movem.l	d0-d7/a0-a4,-(sp)
	move.w	$F2(a6),d2
	moveq	#$4,d3
	move.w	#$0,$E2(a6)
	move.w	#$1,$E0(a6)
	cmpi.w	#$1,d0
	beq.w	.next4
	cmpi.w	#$2,d0
	beq.w	.next3
	cmpi.w	#$4,d0
	beq.w	.next
	neg.w	d3
.next	bsr.w	PlUploadTiles
	move.w	#$E8,d7
	cmpi.w	#$8,$B8(a6)
	beq.w	.next2
	move.w	#$F0,d7
.next2	move.w	d7,d0
	bsr.w	PlOffsetSpriteTable
	move.w	$EE(a6),d0
	subi.w	#$2000,d0
	addi.w	#$CF8,d0
	swap	d0
	move.w	#$100,d0
	bsr.w	PlSetupWindow
	move.w	$EE(a6),d0
	subi.w	#$2000,d0
	addi.w	#$D50,d0
	swap	d0
	move.w	#$100,d0
	bsr.w	PlSetupWindow
	move.w	d2,$E2(a6)
	move.w	d3,$E0(a6)
	moveq	#$9,d0
.loop	move.w	#$9,$DE(a6)
.loop2	tst.w	$DE(a6)
	bne.w	.loop2
	dbra	d0,.loop
	moveq	#$1C,d0
	moveq	#$0,d1
	bsr.w	LF64
	neg.w	d7
	move.w	d7,d0
	bsr.w	PlOffsetSpriteTable
	move.w	#$50,d0
	move.w	$EE(a6),d1
	subi.w	#$2000,d1
	swap	d1
	move.w	#$100,d1
	move.l	#$B0000080,d2
	move.w	#$1B,d3
	bsr.w	PlBlitToBuffer
	move.w	$F2(a6),$E2(a6)
	move.w	#$0,$E0(a6)
	move.w	#$9,$DE(a6)
.loop3	tst.w	$DE(a6)
	bne.w	.loop3
	bra.w	.next5
.next3	move.w	#$FFFF,$E0(a6)
.next4	moveq	#$7,d1
.loop4	move.w	#$7,$DE(a6)
.loop5	tst.w	$DE(a6)
	bne.w	.loop5
	dbra	d1,.loop4
.next5	movem.l	(sp)+,d0-d7/a0-a4
	rts
; Fills the picture buffers with the background pattern.
PlFillBackground	movem.l	d0-d7/a0-a1,-(sp)
	movea.l	$8A(a6),a0
	move.l	#$7DF,d0
	move.l	#$33333333,d1
.loop	move.l	d1,(a0)+
	dbra	d0,.loop
	movea.l	$92(a6),a1
	move.w	#$600,d0
	bset	#$E,d0
	bset	#$F,d0
	moveq	#$1,d2
	moveq	#$0,d3
	move.b	$B6(a6),d3
	subq.w	#$1,d3
	move.w	d3,d4
	move.w	$B8(a6),d5
	subq.w	#$1,d5
	moveq	#$0,d6
	move.l	#$88,d7
.loop2	move.w	d6,$0(a1)
	move.w	d7,$6(a1)
	move.b	#$C,$2(a1)
	move.b	d2,$3(a1)
	move.w	d0,$4(a1)
	addq.b	#$1,d2
	addi.w	#$4,d0
	addi.w	#$20,d7
	lea.l	$8(a1),a1
	dbra	d3,.loop2
	move.w	d4,d3
	addi.w	#$8,d6
	move.l	#$88,d7
	dbra	d5,.loop2
	move.b	#$0,-$5(a1)
	movem.l	(sp)+,d0-d7/a0-a1
	rts
; Adds d0 to the Y position of all 80 sprite entries.
PlOffsetSpriteTable	movem.l	d1/a1,-(sp)
	movea.l	$92(a6),a1
	move.w	#$140,$E0(a6)
	move.w	#$E800,$E2(a6)
	move.l	a1,$E4(a6)
	moveq	#$4F,d1
.loop	add.w	d0,$0(a1)
	lea.l	$8(a1),a1
	dbra	d1,.loop
	move.w	#$1,$DE(a6)
.loop2	tst.w	$DE(a6)
	bne.w	.loop2
	movem.l	(sp)+,d1/a1
	rts
; Builds the portrait tile data from the source at $70(a6).
PlBuildPortraitTiles	movem.l	d0-d4/a0-a4,-(sp)
	movea.l	$70(a6),a0
	lea.l	$4(a0),a0
	movea.l	$8A(a6),a1
	moveq	#$0,d0
	move.b	$B6(a6),d0
	lsl.l	#$7,d0
	move.l	d0,d1
	mulu.w	$B4(a6),d0
	lea.l	(a1,d0.l),a3
	move.l	d1,d0
	movea.l	a3,a1
	move.l	d1,d2
	lsr.l	#$2,d2
	subq.l	#$1,d2
	move.l	#$33333333,d1
	move.l	d1,d4
.loop	move.l	d1,(a1)+
	dbra	d2,.loop
	movea.l	a3,a1
	moveq	#$1,d3
.loop2	moveq	#$0,d1
	move.b	(a4)+,d1
	beq.w	.next
	subi.b	#$20,d1
	lsl.w	#$5,d1
	lea.l	(a0,d1.w),a2
	move.l	(a2)+,d1
	eor.l	d4,d1
	move.l	d1,(a1)+
	move.l	(a2)+,d1
	eor.l	d4,d1
	move.l	d1,(a1)+
	move.l	(a2)+,d1
	eor.l	d4,d1
	move.l	d1,(a1)+
	move.l	(a2)+,d1
	eor.l	d4,d1
	move.l	d1,(a1)+
	move.l	(a2)+,d1
	eor.l	d4,d1
	move.l	d1,(a1)+
	move.l	(a2)+,d1
	eor.l	d4,d1
	move.l	d1,(a1)+
	move.l	(a2)+,d1
	eor.l	d4,d1
	move.l	d1,(a1)+
	move.l	(a2)+,d1
	eor.l	d4,d1
	move.l	d1,(a1)+
	bra.w	.loop2
.next	adda.l	#$20,a1
	dbra	d3,.loop2
	addi.w	#$1,$B4(a6)
	movem.l	(sp)+,d0-d4/a0-a4
	rts
; Copies the tile buffer to $BC000 and queues the VRAM upload.
PlUploadTiles	movem.l	d0/a0-a1,-(sp)
	movea.l	$8A(a6),a0
	move.w	#$7DF,d0
	movea.l	#$BC000,a1
.loop	move.l	(a0)+,(a1)+
	dbra	d0,.loop
	move.l	#$BC000,$E4(a6)
	move.w	#$FC0,$E0(a6)
	move.w	#$C000,$E2(a6)
	move.w	#$1,$DE(a6)
.loop2	tst.w	$DE(a6)
	bne.w	.loop2
	movem.l	(sp)+,d0/a0-a1
	rts
; Picks the picture pointer for index d0 (page A or B).
PlSelectPicture	movem.l	d0-d7/a0-a2,-(sp)
	lea.l	$0(a6),a0
	lsl.w	#$2,d0
	cmpi.w	#$0,$18(a6)
	beq.w	.next
	lea.l	$C(a6),a0
.next	adda.w	d0,a0
	movea.l	(a0),a0
	lsr.w	#$2,d0
	movea.l	a0,a1
	moveq	#$0,d2
	moveq	#$0,d1
	move.w	$2(a1),d2
	lea.l	$4(a1),a1
	move.w	$FC(a6),d5
	eori.w	#$3000,d5
	move.w	d5,$FC(a6)
	lsl.w	#$4,d2
	move.w	d2,$E0(a6)
	move.w	d5,$E2(a6)
	movea.l	#$BC000,a2
	move.l	a2,$E4(a6)
	subq.w	#$1,d2
.loop	move.w	(a1)+,(a2)+
	dbra	d2,.loop
	move.w	#$1,$DE(a6)
.loop2	tst.w	$DE(a6)
	bne.w	.loop2
	lsr.w	#$5,d5
	cmpi.w	#$0,d0
	beq.w	.next3
	cmpi.w	#$1,d0
	beq.w	.next2
	move.w	#$1,$B2(a6)
	movea.l	#$BBD10,a2
	moveq	#$7,d2
.loop3	move.l	(a1)+,(a2)+
	dbra	d2,.loop3
	lea.l	$60(a1),a1
	bra.w	.next4
.next2	move.w	#$0,$B2(a6)
	movea.l	#$BBCB0,a2
	moveq	#$F,d2
.loop4	move.l	(a1)+,(a2)+
	dbra	d2,.loop4
	lea.l	$40(a1),a1
	bra.w	.next4
.next3	move.w	#$1,$B2(a6)
	movea.l	#$BBD10,a2
	moveq	#$7,d2
.loop5	move.l	(a1)+,(a2)+
	dbra	d2,.loop5
	movea.l	#$BBCD0,a2
	moveq	#$7,d2
.loop6	move.l	(a1)+,(a2)+
	dbra	d2,.loop6
	lea.l	$40(a1),a1
.next4	move.l	#$EEE,$BBCF0.l
	move.l	#$EEE0444,$BBCF4.l
	move.w	#$2C,$BBD0A.l
	move.w	#$444,$BBCB0.l
	move.w	#$444,$BBCD0.l
	move.w	#$444,$BBCF0.l
	move.w	#$444,$BBD10.l
	cmpi.w	#$2,$F8(a6)
	bne.w	PlWaitFrameCopy
	movea.l	a1,a2
	movem.l	d2,-(sp)
	move.w	$EE(a6),d3
	move.l	#$100,d6
	bsr.w	PlCopyRectToVdp
	movem.l	(sp)+,d2
	dc.w	$6000,$0022
; Waits for the frame timer, then copies the rectangle to VRAM
PlWaitFrameCopy	move.w	#$64,$EC(a6)
.loop	tst.w	$EC(a6)
	bpl.w	.loop
	moveq	#$0,d3
	move.w	$EE(a6),d3
	move.l	#$100,d6
	movea.l	a1,a2
	bsr.w	PlCopyRectToVdp
.next	movem.l	(sp)+,d0-d7/a0-a2
	rts
; Bare rts target
PlRtsStub	dc.b	$4E,$75	; Nu
; Decodes the picture at (a0) into the tile buffer.
PlDecodePicture	movem.l	d0-d7/a0-a4,-(sp)
	movea.l	$8(a6),a0
	cmpi.w	#$0,$18(a6)
	beq.w	.next
	movea.l	$14(a6),a0
.next	moveq	#$0,d0
	move.w	$2(a0),d0
	lsl.w	#$5,d0
	lea.l	(a0,d0.w),a2
	adda.l	#$84,a2
	move.w	$FC(a6),d5
	lsr.w	#$5,d5
	ori.w	#$8000,d5
	move.w	#$1,$B2(a6)
	move.w	#$B000,d3
	move.l	#$80,d6
	movea.l	a2,a1
	bsr.w	PlCopyRectToVdp
.loop	btst.b	#$7,$FF800E.l
	bne.b	.loop
	move.w	#$921C,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop2	btst.b	#$6,$FF800E.l
	beq.b	.loop2
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop3	btst.b	#$6,$FF800E.l
	bne.b	.loop3
	bclr.b	#$7,$FF800F.l
	cmpi.w	#$4000,$FC(a6)
	beq.w	.next2
	move.w	#$7000,$E4(a6)
	move.w	#$4000,$E2(a6)
	move.w	#$3000,$E0(a6)
	move.w	#$6,$DE(a6)
.loop4	tst.w	$DE(a6)
	bne.w	.loop4
	move.w	#$4000,d5
	lsr.w	#$5,d5
	ori.w	#$8000,d5
	move.w	#$1,$B2(a6)
	move.w	#$B000,d3
	move.l	#$80,d6
	movea.l	a2,a1
	bsr.w	PlCopyRectToVdp
	move.w	#$4000,$FC(a6)
.next2	move.l	#$1000,d0
	bsr.w	PlDmaRequest
	move.l	#$20001000,d0
	bsr.w	PlDmaRequest
	move.w	#$3,$DE(a6)
.loop5	tst.w	$DE(a6)
	bne.w	.loop5
	move.w	#$2000,d3
	move.l	#$80,d6
	movea.l	a2,a1
	bsr.w	PlCopyRectToVdp
.loop6	btst.b	#$7,$FF800E.l
	bne.b	.loop6
	move.w	#$9200,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop7	btst.b	#$6,$FF800E.l
	beq.b	.loop7
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop8	btst.b	#$6,$FF800E.l
	bne.b	.loop8
	bclr.b	#$7,$FF800F.l
.loop9	btst.b	#$7,$FF800E.l
	bne.b	.loop9
	move.l	#$70000003,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop10	btst.b	#$6,$FF800E.l
	beq.b	.loop10
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop11	btst.b	#$6,$FF800E.l
	bne.b	.loop11
	bclr.b	#$7,$FF800F.l
.loop12	btst.b	#$7,$FF800E.l
	bne.b	.loop12
	move.w	#$4F,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop13	btst.b	#$6,$FF800E.l
	beq.b	.loop13
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop14	btst.b	#$6,$FF800E.l
	bne.b	.loop14
	bclr.b	#$7,$FF800F.l
.loop15	btst.b	#$7,$FF800E.l
	bne.b	.loop15
	move.l	#$40000010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop16	btst.b	#$6,$FF800E.l
	beq.b	.loop16
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop17	btst.b	#$6,$FF800E.l
	bne.b	.loop17
	bclr.b	#$7,$FF800F.l
.loop18	btst.b	#$7,$FF800E.l
	bne.b	.loop18
	move.w	#$FFB8,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop19	btst.b	#$6,$FF800E.l
	beq.b	.loop19
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop20	btst.b	#$6,$FF800E.l
	bne.b	.loop20
	bclr.b	#$7,$FF800F.l
.loop21	btst.b	#$7,$FF800E.l
	bne.b	.loop21
	move.w	#$8730,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop22	btst.b	#$6,$FF800E.l
	beq.b	.loop22
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop23	btst.b	#$6,$FF800E.l
	bne.b	.loop23
	bclr.b	#$7,$FF800F.l
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$2,d7
	movea.l	$A2(a6),a0
	jsr	$6044.w
	move.w	$7C(a6),d0
	cmpi.w	#$0,$18(a6)
	beq.w	.next3
	move.w	$7E(a6),d0
.next3	mulu.w	#$34,d0
	lea.l	PlRecordTable(pc),a0
	adda.l	d0,a0
	move.l	a0,$68(a6)
	bra.w	.next5
.loop24	bset.b	#$5,$FF800F.l
.loop25	moveq	#$7,d0
	bsr.w	LEAA
	bsr.w	UpdatePad1
	move.w	d1,d5
	bsr.w	UpdatePad2
	or.w	d1,d5
	cmpi.b	#$10,d5
	bne.w	.next4
	addi.w	#$1,$66(a6)
	bra.w	.next5
.next4	cmpi.b	#$20,d5
	beq.w	.next5
	cmpi.b	#$4,d5
	beq.w	.loop25
	cmpi.b	#$1,d5
	beq.w	.loop25
	cmpi.b	#$2,d5
	beq.w	.loop25
	cmpi.b	#$0,d5
	beq.w	.loop25
	move.w	d5,$AE(a6)
	bra.w	.next7
.next5	movea.l	$68(a6),a0
	moveq	#$0,d1
	move.w	$66(a6),d1
	add.w	d1,d1
	add.w	d1,d1
	move.l	(a0,d1.l),d1
	cmpi.l	#$FFFFFFFF,d1
	bne.w	.next6
	clr.w	$66(a6)
	move.l	(a0),d1
.next6	lea.l	PlRtsStub(pc),a0
	move.l	#$1,d0
	move.w	#$7,d7
	jsr	$6044.w
	bra.w	.loop24
.next7	movea.l	$74(a6),a1
	move.w	$2(a1),d0
	lea.l	$4(a1),a1
	lsl.w	#$4,d0
	move.w	d0,$E0(a6)
	move.w	#$A000,$E2(a6)
	movea.l	#$BC000,a2
	move.l	a2,$E4(a6)
	subq.w	#$1,d0
.loop26	move.w	(a1)+,(a2)+
	dbra	d0,.loop26
	move.w	#$1,$DE(a6)
.loop27	tst.w	$DE(a6)
	bne.w	.loop27
	movem.l	(sp)+,d0-d7/a0-a6
	move.w	#$B000,d3
	move.l	#$80,d6
	movea.l	a2,a1
	bsr.w	PlCopyRectToVdp
	move.w	#$1C,$E2(a6)
	clr.w	$E0(a6)
	move.w	#$A,$DE(a6)
.loop28	tst.w	$DE(a6)
	bne.w	.loop28
	move.l	#$1000,d0
	bsr.w	PlDmaRequest
	move.l	#$20001000,d0
	bsr.w	PlDmaRequest
.loop29	btst.b	#$7,$FF800E.l
	bne.b	.loop29
	move.l	#$70000003,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop30	btst.b	#$6,$FF800E.l
	beq.b	.loop30
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop31	btst.b	#$6,$FF800E.l
	bne.b	.loop31
	bclr.b	#$7,$FF800F.l
.loop32	btst.b	#$7,$FF800E.l
	bne.b	.loop32
	move.w	#$0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop33	btst.b	#$6,$FF800E.l
	beq.b	.loop33
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop34	btst.b	#$6,$FF800E.l
	bne.b	.loop34
	bclr.b	#$7,$FF800F.l
.loop35	btst.b	#$7,$FF800E.l
	bne.b	.loop35
	move.w	$F2(a6),$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop36	btst.b	#$6,$FF800E.l
	beq.b	.loop36
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop37	btst.b	#$6,$FF800E.l
	bne.b	.loop37
	bclr.b	#$7,$FF800F.l
.loop38	btst.b	#$7,$FF800E.l
	bne.b	.loop38
	move.l	#$40000010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop39	btst.b	#$6,$FF800E.l
	beq.b	.loop39
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop40	btst.b	#$6,$FF800E.l
	bne.b	.loop40
	bclr.b	#$7,$FF800F.l
.loop41	btst.b	#$7,$FF800E.l
	bne.b	.loop41
	move.w	#$0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop42	btst.b	#$6,$FF800E.l
	beq.b	.loop42
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop43	btst.b	#$6,$FF800E.l
	bne.b	.loop43
	bclr.b	#$7,$FF800F.l
	move.w	#$0,d3
	andi.w	#$7FFF,d5
	move.l	#$100,d6
	movea.l	a2,a1
	bsr.w	PlCopyRectToVdp
	move.w	#$4,$DE(a6)
.loop44	tst.w	$DE(a6)
	bne.w	.loop44
	move.w	$EE(a6),d3
	andi.w	#$7FFF,d5
	move.l	#$100,d6
	movea.l	a2,a1
	bsr.w	PlCopyRectToVdp
	move.l	#$1000,d0
	bsr.w	PlDmaRequest
.loop45	btst.b	#$7,$FF800E.l
	bne.b	.loop45
	move.l	#$70000003,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop46	btst.b	#$6,$FF800E.l
	beq.b	.loop46
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop47	btst.b	#$6,$FF800E.l
	bne.b	.loop47
	bclr.b	#$7,$FF800F.l
.loop48	btst.b	#$7,$FF800E.l
	bne.b	.loop48
	move.w	$F2(a6),$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop49	btst.b	#$6,$FF800E.l
	beq.b	.loop49
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop50	btst.b	#$6,$FF800E.l
	bne.b	.loop50
	bclr.b	#$7,$FF800F.l
	clr.w	$E2(a6)
	clr.w	$E0(a6)
	move.w	#$A,$DE(a6)
.loop51	tst.w	$DE(a6)
	bne.w	.loop51
	move.l	#$B0000800,d0
	bsr.w	PlDmaRequest
	bsr.w	LCAA
	bset.b	#$5,$FF800F.l
	movem.l	(sp)+,d0-d7/a0-a4
	rts
; Unpacks 4-bit pixel data from $50(a6) into the buffer.
PlUnpackNibbles	movem.l	d0-d7/a0-a4,-(sp)
	moveq	#$0,d4
	move.w	#$500,d4
	moveq	#$0,d1
	moveq	#$0,d2
	movea.l	$50(a6),a3
	move.b	(a3),d1
	move.b	d1,d2
	lsr.b	#$4,d2
	mulu.w	#$3,d2
	add.w	d2,d2
	movea.w	d2,a2
	move.l	#$3840,d5
	moveq	#$2,d0
	moveq	#$25,d3
	movea.l	$78(a6),a0
	movea.l	a0,a1
	bsr.w	.next6
	move.l	#$3844,d5
	move.w	#$500,d4
	andi.b	#$F,d1
	mulu.w	#$3,d1
	add.w	d1,d1
	movea.w	d1,a2
	moveq	#$2,d0
	moveq	#$25,d3
	movea.l	a1,a0
	bsr.w	.next6
	move.l	#$3802,d5
	move.w	#$500,d4
	cmpi.b	#$47,$B7(a6)
	beq.w	.next4
	cmpi.b	#$44,$B7(a6)
	beq.w	.next2
	cmpi.b	#$4C,$B7(a6)
	beq.w	.next
	cmpi.b	#$43,$B7(a6)
	beq.w	.next3
	moveq	#$7,d0
	movea.w	#$130,a2
	move.w	#$20,d3
	movea.l	a1,a0
	bsr.w	.next6
	bra.w	.next5
.next	moveq	#$7,d0
	movea.w	#$110,a2
	move.w	#$20,d3
	movea.l	a1,a0
	bsr.w	.next6
	bra.w	.next5
.next2	moveq	#$7,d0
	movea.w	#$120,a2
	move.w	#$20,d3
	movea.l	a1,a0
	bsr.w	.next6
	bra.w	.next5
.next3	moveq	#$7,d0
	movea.w	#$100,a2
	move.w	#$20,d3
	movea.l	a1,a0
	bsr.w	.next6
	bra.w	.next5
.next4	moveq	#$7,d0
	movea.w	#$F0,a2
	move.w	#$20,d3
	movea.l	a1,a0
	bsr.w	.next6
	bra.w	.next5
.next5	movem.l	(sp)+,d0-d7/a0-a4
	rts
.next6	moveq	#$2,d7
	move.w	d0,d2
	add.w	d3,d3
	lea.l	(a0,a2.w),a0
.loop	move.l	d5,d6
	lsl.l	#$2,d6
	lsr.w	#$2,d6
	swap	d6
	addi.l	#$40000000,d6
.loop2	btst.b	#$7,$FF800E.l
	bne.b	.loop2
	move.l	d6,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop3	btst.b	#$6,$FF800E.l
	beq.b	.loop3
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop4	btst.b	#$6,$FF800E.l
	bne.b	.loop4
	bclr.b	#$7,$FF800F.l
.loop5	movea.w	d4,a3
	adda.w	(a0)+,a3
.loop6	btst.b	#$7,$FF800E.l
	bne.b	.loop6
	move.w	a3,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop7	btst.b	#$6,$FF800E.l
	beq.b	.loop7
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop8	btst.b	#$6,$FF800E.l
	bne.b	.loop8
	bclr.b	#$7,$FF800F.l
	dbra	d0,.loop5
	move.w	d2,d0
	adda.w	d3,a0
	addi.l	#$100,d5
	dbra	d7,.loop
	rts
