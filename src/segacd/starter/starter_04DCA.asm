	dc.b	$91,'SendCommandToMa'	; .SendCommandToMa
	dc.b	$69,$6E,$00,$00	; in..
CopyData	link	a6,#$0
CopyDataSub1	movem.l	d4-d7,-(sp)
	move.l	$C(a6),d4
	move.l	$8(a6),d5
	move.l	$10(a6),d6
	move.l	d6,d0
	addq.l	#$3,d0
	asr.l	#$2,d0
	move.l	d0,d6
	moveq	#$0,d7
	bra.b	CopyData_2
CopyData_1	movea.l	d5,a0
CopyDataSub2	addq.l	#$4,d5
	movea.l	d4,a1
	addq.l	#$4,d4
	move.l	(a0),(a1)
	move.l	d7,d0
	addq.l	#$1,d7
CopyData_2	cmp.l	d7,d6
	bgt.b	CopyData_1
	movem.l	-$10(a6),d4-d7
	unlk	a6
	rts
	dc.b	$88,'CopyData',$00,$00,$00	; .CopyData...
