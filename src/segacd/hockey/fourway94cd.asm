Set4WayPlayer						;unused: put player a3's number (SCnum) in the home or away nibble of
									;PadControlBits34 (unless PadControlBits is -1)
	cmpi.w	#$FFFF,(PadControlBits).l
	beq.w	.x
	movem.l	d0-d2,-(sp)
	move.w	#$1,d0		;1 = home side code
	btst	#pfteam,pflags(a3)		;away?
	beq.w	.chkpad3
	move.w	#$2,d0
.chkpad3	cmp.w	(cont3team).l,d0
	beq.w	.pad3
	move.w	#$F,d1		;not pad 3: keep the low nibble, write the high
	move.w	#$4,d0		;shift 4: the high nibble
	bra.w	.set
.pad3	move.w	#$F0,d1		;keep the high nibble
	move.w	#$0,d0		;no shift: the low nibble
.set	and.w	d1,(PadControlBits34).l
	move.w	SCnum(a3),d1
	asl.w	d0,d1
	or.w	d1,(PadControlBits34).l
	movem.l	(sp)+,d0-d2
.x	rts