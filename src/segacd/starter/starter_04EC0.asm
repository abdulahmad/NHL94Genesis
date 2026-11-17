	dc.b	$8A,'InitEngine',$00,$00,$00	; .InitEngine...
; C function DisposeEngine (Sierra C name tag follows it).
DisposeEngine	link	a6,#$0
	move.l	a4,-(sp)
	movea.l	$8(a6),a4
	tst.l	(a4)
	beq.b	.l4EE4
	move.l	(a4),-(sp)
	jsr	ffree(pc)
	addq.w	#$4,sp
.l4EE4	movea.l	-$4(a6),a4
	unlk	a6
	rts
	dc.b	$8D,'DisposeEngine',$00,$00	; .DisposeEngine..
GetSectDst	link	a6,#$0
	movem.l	d7/a4,-(sp)
	lea.l	RestoreBios_97(pc),a0
	movea.l	$1C(a0),a4
	moveq	#$0,d7
	move.l	$8(a4),d0
	sub.l	$C(a4),d0
	dc.w	$D0BC,$0000,$0800
	cmp.l	$4(a4),d0
	bge.b	.l4F3E
	move.l	$8(a4),d0
	move.l	$4(a4),d1
	jsr	GetData_16(pc)
	move.l	d0,d7
	add.l	(a4),d7
	addq.l	#$1,$10(a4)
	addi.l	#$800,$8(a4)
.l4F3E	move.l	d7,d0
	movem.l	-$8(a6),d7/a4
	unlk	a6
	rts
	dc.b	$8A,'GetSectDst',$00,$00,$00	; .GetSectDst...
PeekSectDst	link	a6,#$0
	movem.l	d7/a4,-(sp)
	lea.l	RestoreBios_97(pc),a0
	movea.l	$1C(a0),a4
	moveq	#$0,d7
	move.l	$8(a4),d0
	sub.l	$C(a4),d0
	dc.w	$D0BC,$0000,$0800
	cmp.l	$4(a4),d0
	bge.b	.l4F8E
	move.l	$8(a4),d0
	move.l	$4(a4),d1
	jsr	GetData_16(pc)
	move.l	d0,d7
	add.l	(a4),d7
.l4F8E	move.l	d7,d0
	movem.l	-$8(a6),d7/a4
	unlk	a6
	rts
	dc.b	$8B,'PeekSectDst',$00,$00	; .PeekSectDst..
