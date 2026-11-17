; STARTER.BIN FilmTask, file $458C, runtime $2588C.
; Steps one 16-byte record. An SM chunk ($534D) goes to filmsm.
; See docs/segacd_film.md.



Wait_10	link	a6,#$FFFC
	movem.l	d7/a3-a4,-(sp)
	move.l	#$C0000,-$4(a6)
	lea.l	RestoreBios_85(pc),a0
	lea.l	$40(a0),a4
	lea.l	RestoreBios_85(pc),a0
	tst.l	$38(a0)
	beq.b	.l258B4
	moveq	#-2,d0
	bra.w	Wait_22
.l258B4	tst.l	$40(a4)
	bge.b	.l258C0
	moveq	#-1,d0
	bra.w	Wait_22
.l258C0	lea.l	RestoreBios_85(pc),a0
	moveq	#$1,d0
	cmp.l	$3C(a0),d0
	bne.b	.l258D6
	pea.l	$30(a4)
	jsr	GetData_9(pc)
	addq.w	#$4,sp
.l258D6	movea.l	$10(a4),a0
	move.l	$40(a4),d0
	addq.l	#$1,$40(a4)
	asl.l	#$4,d0
	lea.l	$10(a0,d0.l),a3
	moveq	#-1,d0
	cmp.l	$8(a3),d0
	bne.w	Wait_17
	bra.b	Wait_12
Wait_11	pea.l	$18(a4)
	jsr	EngineIdle(pc)
	pea.l	$30(a4)
	jsr	GetData_4(pc)
	addq.w	#$8,sp
Wait_12	move.l	$4(a3),-(sp)
	move.l	(a3),d0
	add.l	$8(a4),d0
	move.l	d0,-(sp)
	pea.l	$18(a4)
	jsr	GetData(pc)
	move.l	d0,d7
	lea.l	$C(sp),sp
	beq.b	Wait_11
	move.l	$4(a3),-(sp)
	move.l	d7,-(sp)
	pea.l	$30(a4)
	jsr	GetData_5(pc)
	lea.l	RestoreBios_85(pc),a0
	moveq	#-1,d0
	cmp.l	$3C(a0),d0
	lea.l	$C(sp),sp
	bne.b	Wait_15
	bra.b	Wait_14
Wait_13	pea.l	$30(a4)
	jsr	GetData_4(pc)
	addq.w	#$4,sp
Wait_14	pea.l	$30(a4)
	jsr	GetData_13(pc)
	tst.w	d0
	addq.w	#$4,sp
	bne.b	Wait_13
Wait_15	move.l	$4(a3),-(sp)
	move.l	(a3),d0
	add.l	$8(a4),d0
	move.l	d0,-(sp)
	pea.l	$18(a4)
	jsr	GetData_1(pc)
	lea.l	$C(sp),sp
	bra.w	Wait_21
Wait_16	pea.l	$30(a4)
	jsr	GetData_4(pc)
	pea.l	$18(a4)
	jsr	EngineIdle(pc)
	addq.w	#$8,sp
Wait_17	move.l	$4(a3),-(sp)
	move.l	(a3),d0
	add.l	$8(a4),d0
	move.l	d0,-(sp)
	pea.l	$18(a4)
	jsr	GetData(pc)
	move.l	d0,d7
	lea.l	$C(sp),sp
	beq.b	Wait_16
	movea.l	d7,a0
	cmpi.w	#$534D,(a0)
	bne.b	Wait_20
	move.l	d7,-(sp)
	move.l	-$4(a6),-(sp)
	jsr	RestoreBios_99(pc)
	move.l	#$7FFFFFFF,d7
	and.l	$8(a3),d7
	bra.b	Wait_19
Wait_18	pea.l	$30(a4)
	jsr	GetData_4(pc)
	pea.l	$18(a4)
	jsr	EngineIdle(pc)
	addq.w	#$8,sp
Wait_19	pea.l	$258.w
	pea.l	$30(a4)
	jsr	GetData_12(pc)
	cmp.l	d0,d7
	addq.w	#$8,sp
	bgt.b	Wait_18
	jsr	Wait_24(pc)
	moveq	#$2,d0
	move.l	d0,-(sp)
	jsr	GetTicks_2(pc)
	addq.w	#$4,sp
Wait_20	move.l	$4(a3),-(sp)
	move.l	(a3),d0
	add.l	$8(a4),d0
	move.l	d0,-(sp)
	pea.l	$18(a4)
	jsr	GetData_1(pc)
	lea.l	$C(sp),sp
Wait_21	movea.l	$10(a4),a0
	move.l	$40(a4),d0
	cmp.l	$C(a0),d0
	bne.b	.l25A20
	moveq	#-1,d0
	move.l	d0,$40(a4)
.l25A20	move.l	$40(a4),d0
Wait_22	movem.l	-$10(a6),d7/a3-a4
	unlk	a6
	rts

