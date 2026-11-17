; Sierra C name tag of the routine above (length byte, 'InitEngine', zero padding).
	dc.b	$8A,'InitEngine',$00,$00,$00	; .InitEngine...
; C function DisposeEngine (Sierra C name tag follows it).
DisposeEngine	link	a6,#$0
	move.l	a4,-(sp)
	movea.l	$8(a6),a4
	tst.l	(a4)
	beq.b	.next
	move.l	(a4),-(sp)
	jsr	ffree(pc)
	addq.w	#$4,sp
.next	movea.l	-$4(a6),a4
	unlk	a6
	rts
; Sierra C name tag of the routine above (length byte, 'DisposeEngine', zero padding).
	dc.b	$8D,'DisposeEngine',$00,$00	; .DisposeEngine..
GetSectDst	link	a6,#$0
	movem.l	d7/a4,-(sp)
	lea.l	FilmEntryVector(pc),a0
	movea.l	$1C(a0),a4
	moveq	#$0,d7
	move.l	$8(a4),d0
	sub.l	$C(a4),d0
; Instruction bytes inside GetSectDst that the assembler would encode differently, kept as words (1 row).
	dc.w	$D0BC,$0000,$0800
	cmp.l	$4(a4),d0
	bge.b	.next
	move.l	$8(a4),d0
	move.l	$4(a4),d1
	jsr	DataThunkB(pc)
	move.l	d0,d7
	add.l	(a4),d7
	addq.l	#$1,$10(a4)
	addi.l	#$800,$8(a4)
.next	move.l	d7,d0
	movem.l	-$8(a6),d7/a4
	unlk	a6
	rts
; Sierra C name tag of the routine above (length byte, 'GetSectDst', zero padding).
	dc.b	$8A,'GetSectDst',$00,$00,$00	; .GetSectDst...
PeekSectDst	link	a6,#$0
	movem.l	d7/a4,-(sp)
	lea.l	FilmEntryVector(pc),a0
	movea.l	$1C(a0),a4
	moveq	#$0,d7
	move.l	$8(a4),d0
	sub.l	$C(a4),d0
; Instruction bytes inside PeekSectDst that the assembler would encode differently, kept as words (1 row).
	dc.w	$D0BC,$0000,$0800
	cmp.l	$4(a4),d0
	bge.b	.next
	move.l	$8(a4),d0
	move.l	$4(a4),d1
	jsr	DataThunkB(pc)
	move.l	d0,d7
	add.l	(a4),d7
.next	move.l	d7,d0
	movem.l	-$8(a6),d7/a4
	unlk	a6
	rts
; Sierra C name tag of the routine above (length byte, 'PeekSectDst', zero padding).
	dc.b	$8B,'PeekSectDst',$00,$00	; .PeekSectDst..
