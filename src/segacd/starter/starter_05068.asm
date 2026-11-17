L26368	dc.w	$4E56,$0000
	move.l	$10(a6),d0
	add.l	$C(a6),d0
	movea.l	$8(a6),a0
	move.l	d0,$C(a0)
	unlk	a6
	dc.w	$4E75
	dc.b	$88,$52,$65,$61,$64,$44,$61,$74,$61,$00,$00,$00	; .ReadData...
