; HOCKEY.BIN updatecrowdf, $10D28-$10E65.
; The cartridge updatecrowdf (hockey94.asm), same code with long addresses. The one
; change: the sub CPU cannot read the VDP HV counter, so both HVcount reads are
; command $1B to the main CPU, and the sample comes back in $FF8010.
; Frame table is updatecrowdf_cd0 (crowdtable.asm), $4154C on the disc.
; See docs/segacd_crowd.md.

	include	segacd\hockey.inc

;calls begin
;calls end

rtss8	equ	$14988				;a bare rts, the cartridge rtss8

	org	$10D28

updatecrowdf						;called every game loop with d7 = elapsed frames; updates the
									;current frame of crowd animation
	cmpi.w	#$15E,(Crowdlevel).l
	blt.w	.dec
	subi.w	#3,(Crowdlevel).l		;loud crowd calms down faster
.dec	sub.w	d7,(Crowdlevel).l	;crowd level decays by the elapsed frames
	bpl.w	.0
	clr.w	(Crowdlevel).l
.0	sub.w	d7,(Crowdcnt).l			;count down to the next crowd animation step
	bpl.w	.cf
	move.w	(Crowdlevel).l,d0
	lsr.w	#1,d0
	cmpi.w	#$7F,d0
	bls.w	.1
	moveq	#$7F,d0
.1	andi.w	#$60,d0					;%01100000
	addi.w	#2,(Crowdstep).l
	andi.w	#$1E,(Crowdstep).l		;%00011110
	add.w	(Crowdstep).l,d0
	movea.l	#$4154C,a0				;updatecrowdf_cd0, $fftt frame/time table
	move.b	(a0,d0.w),(Crowdframe+1).l
	clr.w	d1
	move.b	1(a0,d0.w),d1
.rd1a	btst.b	#7,$FF800E.l		;disc: HVcount comes from the main CPU (command $1B)
	bne.b	.rd1a
	move.w	#$1B,$FF8020.l
	bset.b	#6,$FF800F.l
.rd1b	btst.b	#6,$FF800E.l
	beq.b	.rd1b
	move.w	$FF8010.l,d2			;HVcount
	bset.b	#7,$FF800F.l
	bclr.b	#6,$FF800F.l
.rd1c	btst.b	#6,$FF800E.l
	bne.b	.rd1c
	bclr.b	#7,$FF800F.l
	and.w	d1,d2					;random 0..time
	add.w	d2,d1
	move.w	d1,(Crowdcnt).l			;Crowdcnt = time + random
.cf	clr.b	(Crowdframe).l			;no extra frame unless the crowd is loud
	cmpi.w	#$118,(Crowdlevel).l	;280
	bls.w	rtss8
.rd2a	btst.b	#7,$FF800E.l		;disc: HVcount again, command $1B
	bne.b	.rd2a
	move.w	#$1B,$FF8020.l
	bset.b	#6,$FF800F.l
.rd2b	btst.b	#6,$FF800E.l
	beq.b	.rd2b
	move.w	$FF8010.l,d0			;HVcount
	bset.b	#7,$FF800F.l
	bclr.b	#6,$FF800F.l
.rd2c	btst.b	#6,$FF800E.l
	bne.b	.rd2c
	bclr.b	#7,$FF800F.l
	andi.w	#$7F,d0
	cmpi.w	#$13,d0
	blt.w	rtss8
	cmpi.w	#$19,d0
	bgt.w	rtss8
	move.b	d0,(Crowdframe).l		;random extra frame 19-25 when crowd is loud
	rts
