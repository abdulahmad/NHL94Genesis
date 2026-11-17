	opt	oaq-
	opt	osq-
; MAIN.BIN Z80 loader, $FF76C8-$FF77B7.
; Accepts a block whose first bytes are $C3,$00, copies it to $A00000,
; and clears the eight $FFFFFFFF sound slots. See docs/segacd_film.md.



LFF76C8	movem.l	d1/a0-a2,-(sp)
	move.w	sr,-(sp)
	move.w	#$2700,sr
	lea.l	LFF855A(pc),a2
	adda.l	#$4,a1
	move.l	a1,(a2)
	move.w	#$100,$A11100.l
	move.w	#$100,$A11200.l
	cmpi.b	#$C3,(a0)
	bne.b	LFF771A
	cmpi.b	#$0,$1(a0)
	bne.b	LFF771A
	move.l	a0,-(sp)
	bsr.w	LFF835C
	bsr.w	LFF83FC
	lea.l	$A00000.l,a1
LFF770C	move.b	(a0)+,(a1)+
	dbra	d1,LFF770C
	movea.l	(sp)+,a0
	bsr.w	LFF83B0
	bra.b	LFF7722
LFF771A	move.w	#$6,d0
	bra.w	LFF77AC
LFF7722	move.w	#$0,$A11200.l
	move.w	#$0,$A11100.l
	move.w	#$1F4,d0
LFF7736	dbra	d0,LFF7736
	move.w	#$100,$A11200.l
	lea.l	LFF85EC(pc),a0
	move.w	#$4,d0
LFF774A	move.l	#$FFFFFFFF,(a0)+
	dbra	d0,LFF774A
	lea.l	LFF841C(pc),a0
	move.w	#$7,d0
LFF775C	move.l	#$FFFFFFFF,(a0)+
	dbra	d0,LFF775C
	lea.l	LFF843C(pc),a0
	move.w	#$7,d0
LFF776E	move.l	#$0,(a0)+
	dbra	d0,LFF776E
	lea.l	LFF845C(pc),a0
	move.w	#$7,d0
LFF7780	move.w	#$FFFF,(a0)+
	dbra	d0,LFF7780
	bsr.w	LFF7E1E
	lea.l	LFF854A(pc),a0
	move.w	#$7,d0
LFF7794	move.w	#$0,(a0)+
	dbra	d0,LFF7794
	lea.l	LFF855E(pc),a0
	move.w	#$0,(a0)
	andi.b	#$FE,ccr
	clr.w	d0
	bra.b	LFF77B0
LFF77AC	ori.b	#$1,ccr
LFF77B0	move.w	(sp)+,sr
	movem.l	(sp)+,d1/a0-a2
	rts

	opt	oaq+
	opt	osq+
