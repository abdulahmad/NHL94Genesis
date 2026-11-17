GetData_1	link	a6,#$0
	move.l	$10(a6),d0
	add.l	$C(a6),d0
	movea.l	$8(a6),a0
	move.l	d0,$C(a0)
	unlk	a6
	rts
	dc.b	$88,'ReadData',$00,$00,$00	; .ReadData...
