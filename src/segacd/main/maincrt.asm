;	MAIN.BIN $34B8-$35A7 (runtime $FF44B8-$FF45A7).
;
;	The Sierra C run-time helpers after maintext.asm: 32-bit multiply and the divide / modulo
;	entries with their jump table (the same code as STARTER.BIN crt.asm).


	org	$FF44B8

DoDrawTextCommand
	move.l	$4(sp),d1
	move.l	$8(sp),d0
	lea	.LFF44CC(pc),a0
	movea.w	#$2,a1
	dc.w	$4EF0,$92FE
.LFF44CC
	bra.s	.LFF44D4
	dc.w	$4C41
	dc.w	$0801
	rts
.LFF44D4
	jsr	.LFF44FA(pc)
	move.l	d1,d0
	rts
	move.l	$4(sp),d1
	move.l	$8(sp),d0
	lea	.LFF44F0(pc),a0
	movea.w	#$2,a1
	dc.w	$4EF0,$92FE
.LFF44F0
	bra.s	.LFF44FA
	dc.w	$4C41
	dc.w	$0801
	dc.w	$C340
	rts
.LFF44FA
	tst.l	d0
	bmi.s	.LFF4512
	tst.l	d1
	bmi.s	.LFF4508
	jsr	.LFF454A(pc)
	rts
.LFF4508
	neg.l	d1
	jsr	.LFF454A(pc)
	neg.l	d1
	rts
.LFF4512
	neg.l	d0
	tst.l	d1
	bmi.s	.LFF4522
	jsr	.LFF454A(pc)
	neg.l	d0
	neg.l	d1
	rts
.LFF4522
	neg.l	d1
	jsr	.LFF454A(pc)
	neg.l	d0
	rts
	move.l	$4(sp),d1
	move.l	$8(sp),d0
	lea	.LFF4540(pc),a0
	movea.w	#$2,a1
	dc.w	$4EF0,$92FE
.LFF4540
	bra.s	.LFF454A
	dc.w	$4C41
	dc.w	$0001,$C340
	rts
.LFF454A
	move.w	d1,-(sp)
	swap	d1
	tst.w	d1
	bne.s	.LFF456E
	move.l	d0,d1
	clr.w	d1
	swap	d1
	beq.s	.LFF4564
	divu.w	(sp),d1
	swap	d1
	swap	d0
	move.w	d1,d0
	swap	d0
.LFF4564
	divu.w	(sp)+,d0
	move.w	d0,d1
	dc.b	'B@H@Nu'
.LFF456E
	swap	d1
	move.w	d2,(sp)
	move.l	d3,-(sp)
	move.w	d0,d2
	move.l	d1,d3
	moveq	#$1,d1
	clr.w	d0
	swap	d0
	bne.s	.LFF458C
	swap	d0
	move.w	d2,d0
	moveq	#$0,d1
	bra.s	.LFF459E
.LFF4588
	add.w	d1,d1
	bcs.s	.LFF459E
.LFF458C
	add.w	d2,d2
	addx.l	d0,d0
	cmp.l	d3,d0
	bcs.s	.LFF4588
	sub.l	d3,d0
	add.w	d1,d1
	bset	#$0,d1
	bcc.s	.LFF458C
.LFF459E
	move.l	(sp)+,d3
	move.w	(sp)+,d2
	rts
	ori.b	#$0,d0
