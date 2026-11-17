	dc.b	$20,$2F,$00,$04,$22,$2F,$00,$08	;  /.."/..
L2660C	move.l	d0,-(sp)
Sub_2660E	mulu.w	d1,d0
	movea.l	d0,a0
Sub_26612	move.l	d1,d0
Sub_26614	mulu.w	(sp)+,d1
	clr.w	d0
Sub_26618	swap	d0
	dc.w	$6702
	mulu.w	(sp),d0
.l531E	addq.l	#$2,sp
	add.w	d1,d0
	swap	d0
	clr.w	d0
	add.l	a0,d0
	dc.w	$4E75
	dc.b	$22,$2F,$00,$04	; "/..
Sub_2662E	move.l	$8(sp),d0
L26632	dc.w	$41FA,$000A
	movea.w	#$2,a1
	dc.w	$4EF0,$92FE
L2663E	dc.b	$60,$06,$4C,$41,$08,$01,$4E,$75,$4E,$BA,$00,$24,$20,$01,$4E,$75	; `.LA..NuN..$ .Nu
	dc.b	$22,$2F,$00,$04,$20,$2F,$00,$08	; "/.. /..
L26656	dc.w	$41FA,$000A
	movea.w	#$2,a1
	dc.w	$4EF0,$92FE
L26662	dc.b	$60,$08,$4C,$41,$08,$01,$C3,$40,$4E,$75,$4A,$80,$6B,$14,$4A,$81	; `.LA...@NuJ.k.J.
	dc.b	$6B,$06,$4E,$BA,$00,$46,$4E,$75,$44,$81,$4E,$BA,$00,$3E,$44,$81	; k.N..FNuD.N..>D.
	dc.b	$4E,$75,$44,$80,$4A,$81,$6B,$0A,$4E,$BA,$00,$30,$44,$80,$44,$81	; NuD.J.k.N..0D.D.
	dc.b	$4E,$75,$44,$81,$4E,$BA,$00,$24,$44,$80,$4E,$75,$22,$2F,$00,$04	; NuD.N..$D.Nu"/..
	dc.b	$20,$2F,$00,$08,$41,$FA,$00,$0A,$32,$7C,$00,$02,$4E,$F0,$92,$FE	;  /..A...2|..N...
	dc.b	$60,$08,$4C,$41,$00,$01,$C3,$40,$4E,$75,$3F,$01,$48,$41,$4A,$41	; `.LA...@Nu?.HAJA
	dc.b	$66,$1C,$22,$00,$42,$41,$48,$41,$67,$0A,$82,$D7,$48,$41,$48,$40	; f.".BAHAg...HAH@
	dc.b	$30,$01,$48,$40,$80,$DF,$32,$00,$42,$40,$48,$40,$4E,$75,$48,$41	; 0.H@..2.B@H@NuHA
	dc.b	$3E,$82,$2F,$03,$34,$00,$26,$01,$72,$01,$42,$40,$48,$40,$66,$0C	; >./.4.&.r.B@H@f.
	dc.b	$48,$40	; H@
Sub_266F4	move.w	d2,d0
	moveq	#$0,d1
	dc.w	$6016
L266FA	add.w	d1,d1
	dc.w	$6512
L266FE	add.w	d2,d2
Sub_26700	addx.l	d0,d0
	cmp.l	d3,d0
	bcs.b	L266FA
	sub.l	d3,d0
	add.w	d1,d1
	bset	#$0,d1
	bcc.b	L266FE
L26710	move.l	(sp)+,d3
	move.w	(sp)+,d2
	dc.w	$4E75
	dc.b	$05,$D2,$00,$00	; ....
L2671A	movem.l	d0-d7/a0-a6,-(sp)
	moveq	#$0,d0
	move.w	$40(sp),d2
	move.w	$42(sp),d1
	move.w	$44(sp),d0
	dc.w	$6B00,$0030
	move.w	d0,$10ADA.l
	cmpi.w	#$FFFF,d0
	dc.w	$6700,$0022
	cmpi.w	#$1,d0
	dc.w	$6C00,$001A
	lea.l	$104EC.l,a0
	mulu.w	#$A,d0
	adda.l	d0,a0
	move.b	$0(a0),d0
	cmpi.b	#$2,d0
	dc.w	$6700,$000E
L2675E	movem.l	(sp)+,d0-d7/a0-a6
	move.l	(sp),$6(sp)
	addq.l	#$6,sp
	rts
.l546A	tst.w	d1
	dc.w	$6600,$004E
	tst.w	d2
	dc.w	$6600,$0048
	move.w	$4(a0),d0
	sub.w	$2(a0),d0
	dc.w	$6700,$0008
	jsr	$E488.l
.l5488	add.w	$2(a0),d0
	move.w	d0,d2
	moveq	#$0,d1
	move.b	$1(a0),d1
	move.w	$8(a0),d0
	sub.w	$6(a0),d0
	dc.w	$6700,$0008
	jsr	$E488.l
.l54A6	add.w	$6(a0),d0
	move.w	d0,d3
	move.w	#$3,d0
Sub_267B0	move.w	#$FFFF,d4
	jsr	$C4BC.l
	bra.b	L2675E
L267BC	move.w	d1,d3
	move.w	d2,d4
	move.w	$4(a0),d0
	sub.w	$2(a0),d0
	dc.w	$6700,$0008
	jsr	$E488.l
.l54D2	add.w	$2(a0),d0
	move.w	d0,d2
	moveq	#$0,d1
	move.b	$1(a0),d1
	move.w	#$3,d0
	jsr	$C4BC.l
	dc.w	$6000,$FF74
	dc.b	$02,$00,$05,$A9,$05,$A9,$00,$FF,$00,$FF	; ..........
