	opt	oaq-
	opt	osq-
; MAIN.BIN Z80 loader, $FF76C8-$FF77B7.
; Accepts a block whose first bytes are $C3,$00, copies it to $A00000,
; and clears the eight $FFFFFFFF sound slots. See docs/segacd_film.md.



Set1MFlag_7	movem.l	d1/a0-a2,-(sp)
	move.w	sr,-(sp)
	move.w	#$2700,sr
	lea.l	Set1MFlag_42(pc),a2
	adda.l	#$4,a1
	move.l	a1,(a2)
	move.w	#$100,$A11100.l
	move.w	#$100,$A11200.l
	cmpi.b	#$C3,(a0)
	bne.b	.next
	cmpi.b	#$0,$1(a0)
	bne.b	.next
	move.l	a0,-(sp)
	bsr.w	PrgRamReadBegin
	bsr.w	PrgRamMapAddr
	lea.l	$A00000.l,a1
.loop	move.b	(a0)+,(a1)+
	dbra	d1,.loop
	movea.l	(sp)+,a0
	bsr.w	PrgRamReadWait
	bra.b	.next2
.next	move.w	#$6,d0
	bra.w	.next4
.next2	move.w	#$0,$A11200.l
	move.w	#$0,$A11100.l
	move.w	#$1F4,d0
.next3	dbra	d0,.next3
	move.w	#$100,$A11200.l
	lea.l	Set1MFlag_45(pc),a0
	move.w	#$4,d0
.loop2	move.l	#$FFFFFFFF,(a0)+
	dbra	d0,.loop2
	lea.l	Set1MFlag_32(pc),a0
	move.w	#$7,d0
.loop3	move.l	#$FFFFFFFF,(a0)+
	dbra	d0,.loop3
	lea.l	Set1MFlag_33(pc),a0
	move.w	#$7,d0
.loop4	move.l	#$0,(a0)+
	dbra	d0,.loop4
	lea.l	Set1MFlag_34(pc),a0
	move.w	#$7,d0
.loop5	move.w	#$FFFF,(a0)+
	dbra	d0,.loop5
	bsr.w	SndSlotsReset
	lea.l	Set1MFlag_41(pc),a0
	move.w	#$7,d0
.loop6	move.w	#$0,(a0)+
	dbra	d0,.loop6
	lea.l	Set1MFlag_43(pc),a0
	move.w	#$0,(a0)
	andi.b	#$FE,ccr
	clr.w	d0
	bra.b	.next5
.next4	ori.b	#$1,ccr
.next5	move.w	(sp)+,sr
	movem.l	(sp)+,d1/a0-a2
	rts

	opt	oaq+
	opt	osq+
