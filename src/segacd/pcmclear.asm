; STARTER.BIN PCM wipe, file $3A0C-$3A75, runtime $EA0C-$EA75.
; Clears all eight channels and their wave RAM, then mutes them.

	org	$EA0C

	move.w	#$7,d2
LEA10	move.b	d2,d3
	addi.w	#$40,d3
	move.b	d3,$FF000F.l
	move.b	#$0,$FF000D.l
	move.b	#$0,$FF000B.l
	move.b	#$0,$FF0009.l
	dbra	d2,LEA10
	move.b	#$40,$FF000F.l
	move.b	#$80,$FF000F.l
	move.w	#$F,d2
LEA4C	move.w	#$FFF,d0
	moveq	#$0,d1
	movea.l	#$FF2001,a0
	move.b	d2,$FF000D.l
LEA5E	move.b	d1,$0(a0)
	addq.w	#$2,a0
	dbra	d0,LEA5E
	dbra	d2,LEA4C
	move.b	#$FF,$FF0011.l
	rts
