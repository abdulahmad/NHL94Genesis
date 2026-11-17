GetDataSub1	move.l	$4(sp),d0
	move.l	$8(sp),d1
GetData_14	move.l	d0,-(sp)
GetDataSub2	mulu.w	d1,d0
	movea.l	d0,a0
GetDataSub3	move.l	d1,d0
GetDataSub4	mulu.w	(sp)+,d1
	clr.w	d0
GetDataSub5	swap	d0
	beq.b	.next
	mulu.w	(sp),d0
.next	addq.l	#$2,sp
	add.w	d1,d0
	swap	d0
	clr.w	d0
	add.l	a0,d0
	rts
	dc.b	$22,$2F,$00,$04	; "/..
GetDataSub6	move.l	$8(sp),d0
GetData_15	lea.l	.next(pc),a0
	movea.w	#$2,a1
	dc.w	$4EF0,$92FE
.next	dc.b	$60,$06,$4C,$41,$08,$01,$4E,$75,$4E,$BA,$00,$24,$20,$01,$4E,$75	; `.LA..NuN..$ .Nu
	dc.b	$22,$2F,$00,$04,$20,$2F,$00,$08	; "/.. /..
GetData_16	lea.l	.next(pc),a0
	movea.w	#$2,a1
	dc.w	$4EF0,$92FE
.next	dc.b	$60,$08,$4C,$41,$08,$01,$C3,'@NuJ',$80,$6B,$14,$4A,$81	; `.LA...@NuJ.k.J.
	dc.b	$6B,$06,$4E,$BA,$00,'FNuD',$81,$4E,$BA,$00,$3E,$44,$81	; k.N..FNuD.N..>D.
	dc.b	$4E,$75,$44,$80,$4A,$81,$6B,$0A,$4E,$BA,$00,$30,$44,$80,$44,$81	; NuD.J.k.N..0D.D.
	dc.b	$4E,$75,$44,$81,$4E,$BA,$00,$24,$44,$80,'Nu"/',$00,$04	; NuD.N..$D.Nu"/..
	dc.b	$20,$2F,$00,$08,$41,$FA,$00,$0A,$32,$7C,$00,$02,$4E,$F0,$92,$FE	;  /..A...2|..N...
	dc.b	$60,$08,$4C,$41,$00,$01,$C3,'@Nu?',$01,'HAJA'	; `.LA...@Nu?.HAJA
	dc.b	$66,$1C,$22,$00,'BAHAg',$0A,$82,$D7,'HAH@'	; f.".BAHAg...HAH@
	dc.b	$30,$01,$48,$40,$80,$DF,$32,$00,'B@H@NuHA'	; 0.H@..2.B@H@NuHA
	dc.b	$3E,$82,$2F,$03,$34,$00,$26,$01,$72,$01,'B@H@f',$0C	; >./.4.&.r.B@H@f.
	dc.b	$48,$40	; H@
GetDataSub7	move.w	d2,d0
	moveq	#$0,d1
	bra.b	GetData_19
GetData_17	add.w	d1,d1
	bcs.b	GetData_19
GetData_18	add.w	d2,d2
GetDataSub8	addx.l	d0,d0
	cmp.l	d3,d0
	bcs.b	GetData_17
	sub.l	d3,d0
	add.w	d1,d1
	bset	#$0,d1
	bcc.b	GetData_18
GetData_19	move.l	(sp)+,d3
	move.w	(sp)+,d2
	rts
	dc.b	$05,$D2,$00,$00	; ....
; Loads a sprite frame descriptor from the stack arguments.
SetupSpriteFrame	movem.l	d0-d7/a0-a6,-(sp)
	moveq	#$0,d0
	move.w	$40(sp),d2
	move.w	$42(sp),d1
	move.w	$44(sp),d0
	bmi.w	GetData_21
	move.w	d0,$10ADA.l
	cmpi.w	#$FFFF,d0
	beq.w	GetData_21
	cmpi.w	#$1,d0
	bge.w	GetData_21
	lea.l	$104EC.l,a0
	mulu.w	#$A,d0
	adda.l	d0,a0
	move.b	$0(a0),d0
	cmpi.b	#$2,d0
	dc.w	$6700,$000E
GetData_21	movem.l	(sp)+,d0-d7/a0-a6
	move.l	(sp),$6(sp)
	addq.l	#$6,sp
	rts
.next	tst.w	d1
	bne.w	GetData_22
	tst.w	d2
	bne.w	GetData_22
	move.w	$4(a0),d0
	sub.w	$2(a0),d0
	beq.w	.next2
	jsr	$E488.l
.next2	add.w	$2(a0),d0
	move.w	d0,d2
	moveq	#$0,d1
	move.b	$1(a0),d1
	move.w	$8(a0),d0
	sub.w	$6(a0),d0
	beq.w	.next3
	jsr	$E488.l
.next3	add.w	$6(a0),d0
	move.w	d0,d3
	move.w	#$3,d0
GetDataSub9	move.w	#$FFFF,d4
	jsr	$C4BC.l
	bra.b	GetData_21
GetData_22	move.w	d1,d3
	move.w	d2,d4
	move.w	$4(a0),d0
	sub.w	$2(a0),d0
	beq.w	.next
	jsr	$E488.l
.next	add.w	$2(a0),d0
	move.w	d0,d2
	moveq	#$0,d1
	move.b	$1(a0),d1
	move.w	#$3,d0
	jsr	$C4BC.l
	bra.w	GetData_21
	dc.b	$02,$00,$05,$A9,$05,$A9,$00,$FF,$00,$FF	; ..........
