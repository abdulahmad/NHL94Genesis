;	STARTER.BIN $4788-$49F9 (runtime $F788-$F9F9).
;
;	SwapMeg, DrawText, NumStr, HexStr, aprint: text to the main CPU (SendCommandToMain, the
;	DoDrawTextCommand side is in maintext.asm) and number formatting.


SendCommandToMain	equ	$FD9E
X_10332	equ	$10332
X_10356	equ	$10356

	org	$F788

SwapMeg
	link	a6,#$0
.LF78C
	movea.l	#$FF8010,a0
	tst.w	$2(a0)
	bne.s	.LF78C
	eori.w	#$1,$FF8002.l
	unlk	a6
	rts
	dc.b	$87,'SwapMeg',0,0
DrawText
	link	a6,#$0
	movem.l	d7/a4,-(sp)
	movea.l	$8(a6),a4
	moveq	#$1,d0
	move.l	d0,-(sp)
	jsr	SendCommandToMain(pc)
	moveq	#$3C,d0
	move.l	d0,-(sp)
	jsr	SendCommandToMain(pc)
	addq.w	#$8,sp
	bra.s	.LF7DA
.LF7CE
	ext.w	d7
	ext.l	d7
	move.l	d7,-(sp)
	jsr	SendCommandToMain(pc)
	addq.w	#$4,sp
.LF7DA
	move.b	(a4)+,d7
	bne.s	.LF7CE
	moveq	#$3E,d0
	move.l	d0,-(sp)
	jsr	SendCommandToMain(pc)
	moveq	#$1,d0
	move.l	d0,-(sp)
	jsr	SendCommandToMain(pc)
	addq.w	#$8,sp
	movem.l	-$8(a6),d7/a4
	unlk	a6
	rts
	dc.b	$88,'DrawText',0,0,0
NumStr
	link	a6,#$FFF0
	movem.l	d6-d7/a3-a4,-(sp)
	movea.l	$10(a6),a3
	lea	-$10(a6),a4
	move.l	$8(a6),d6
	clr.w	d7
	move.w	d7,d0
	addq.w	#$1,d7
	clr.b	(a4,d0.w)
.LF824
	move.l	d6,d0
	moveq	#$A,d1
	jsr	X_10356(pc)
	moveq	#$30,d1
	add.b	d1,d0
	move.w	d7,d1
	addq.w	#$1,d7
	move.b	d0,(a4,d1.w)
	move.l	d6,d0
	moveq	#$A,d1
	jsr	X_10332(pc)
	move.l	d0,d6
	bne.s	.LF824
	bra.s	.LF84C
.LF846
	subq.w	#$1,d7
	move.b	(a4,d7.w),(a3)+
.LF84C
	tst.w	d7
	bne.s	.LF846
	movem.l	-$20(a6),d6-d7/a3-a4
	unlk	a6
	rts
	dc.b	$86,'NumStr',0,0,0
HexStr
	link	a6,#$0
	movem.l	d3-d7/a4,-(sp)
	move.w	$E(a6),d4
	move.l	$8(a6),d5
	movea.l	$10(a6),a4
	ext.l	d4
	move.l	d4,d7
	subq.l	#$1,d7
	moveq	#$0,d3
	bra.s	.LF8A8
.LF882
	moveq	#$F,d6
	and.l	d5,d6
	asr.l	#$4,d5
	moveq	#$9,d0
	cmp.l	d6,d0
	blt.s	.LF89A
	move.b	d6,d0
	moveq	#$30,d1
	add.b	d1,d0
	move.b	d0,(a4,d7.l)
	bra.s	.LF8A4
.LF89A
	move.b	d6,d0
	moveq	#-55,d1
	sub.b	d1,d0
	move.b	d0,(a4,d7.l)
.LF8A4
	move.l	d7,d0
	subq.l	#$1,d7
.LF8A8
	cmp.l	d7,d3
	ble.s	.LF882
	clr.b	(a4,d4.w)
	movem.l	-$18(a6),d3-d7/a4
	unlk	a6
	rts
	dc.b	$86,'HexStr',0,0,0
aprint
	link	a6,#$FED8
	movem.l	d4-d7/a3-a4,-(sp)
	lea	-$128(a6),a4
	lea	-$108(a6),a3
	lea	$8(a6),a0
	addq.w	#$4,a0
	move.l	a0,-$4(a6)
	bra.w	.LF9CA
.LF8E2
	cmpi.b	#$25,d6
	beq.s	.LF8EE
	move.b	d6,(a3)+
	bra.w	.LF9CA
.LF8EE
	moveq	#$8,d4
	movea.l	$8(a6),a0
	addq.l	#$1,$8(a6)
	move.b	(a0),d6
	move.b	d6,d0
	subi.b	#$2A,d0
	bne.s	.LF91A
	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.w	-$2(a0),d4
	move.l	$8(a6),d0
	addq.l	#$1,$8(a6)
	movea.l	d0,a0
	move.b	(a0),d6
.LF91A
	move.b	d6,d0
	subi.b	#$25,d0
	beq.w	.LF9C8
	subi.b	#$2E,d0
	beq.s	.LF9A2
	subq.b	#$5,d0
	beq.s	.LF972
	subi.b	#$C,d0
	beq.s	.LF942
	subi.b	#$F,d0
	beq.s	.LF9A2
	subq.b	#$5,d0
	beq.s	.LF972
	bra.w	.LF9CA
.LF942
	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.l	-$4(a0),d5
	move.l	a4,-(sp)
	ext.l	d4
	move.l	d4,-(sp)
	move.l	d5,-(sp)
	jsr	NumStr(pc)
	clr.w	d7
	lea	$C(sp),sp
	bra.s	.LF96A
.LF962
	move.b	(a4,d7.w),(a3)+
	move.w	d7,d0
	addq.w	#$1,d7
.LF96A
	tst.b	(a4,d7.w)
	bne.s	.LF962
	bra.s	.LF9CA
.LF972
	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.l	-$4(a0),d5
	move.l	a4,-(sp)
	ext.l	d4
	move.l	d4,-(sp)
	move.l	d5,-(sp)
	jsr	HexStr(pc)
	clr.w	d7
	lea	$C(sp),sp
	bra.s	.LF99A
.LF992
	move.b	(a4,d7.w),(a3)+
	move.w	d7,d0
	addq.w	#$1,d7
.LF99A
	tst.b	(a4,d7.w)
	bne.s	.LF992
	bra.s	.LF9CA
.LF9A2
	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.l	-$4(a0),-$8(a6)
	bra.s	.LF9BE
.LF9B2
	move.l	-$8(a6),d0
	addq.l	#$1,-$8(a6)
	movea.l	d0,a0
	move.b	(a0),(a3)+
.LF9BE
	movea.l	-$8(a6),a0
	tst.b	(a0)
	bne.s	.LF9B2
	bra.s	.LF9CA
.LF9C8
	move.b	d6,(a3)+
.LF9CA
	move.l	$8(a6),d0
	addq.l	#$1,$8(a6)
	movea.l	d0,a0
	move.b	(a0),d6
	bne.w	.LF8E2
	clr.b	(a3)+
	pea	-$108(a6)
	jsr	DrawText(pc)
	addq.w	#$4,sp
	movem.l	-$140(a6),d4-d7/a3-a4
	unlk	a6
	rts
	dc.b	$86,'aprint',0,0,0
