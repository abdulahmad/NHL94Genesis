;	HOCKEY.BIN $2CDAC-$2D209 (runtime $47DAC-$48209): cdpads.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	CD-only: the pad reader. ReadPads fills PadRaw1-PadRaw4 (the bytes ReadJoy1 ... ReadJoy4 read) by
;	asking the main CPU for each pad: commands $35-$38 in $FF8026 with the port in $FF8028; all four pads
;	when FourWayPlay. sram94 calls it. The cartridge reads its pads itself. Three rts stubs come first.

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

	org	$47DAC

;CD: no cartridge twin
	dc.b	'NuNuNu'
ReadPads							;CD-only routine (a name given here, not a cartridge name)
	movem.l	d1/a0,-(sp)
	tst.w	(FourWayPlay).l
	beq.w	.L47DEA
	bsr.s	.L47E04
	move.b	d0,(PadRaw1).l
	bsr.w	.L47E56
	move.b	d0,(PadRaw2).l
	bsr.w	.L47EA8
	move.b	d0,(PadRaw3).l
	bsr.w	.L47EFA
	move.b	d0,(PadRaw4).l
	bra.w	.L47DFE
.L47DEA
	bsr.w	.L47F58
	move.b	d0,(PadRaw1).l
	bsr.w	.L47F50
	move.b	d0,(PadRaw2).l
.L47DFE
	movem.l	(sp)+,d1/a0
	rts
.L47E04
	btst.b	#$4,$FF800E.l
	bne.s	.L47E04
	move.b	#$C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.L47E26
	btst.b	#$4,$FF800E.l
	beq.s	.L47E26
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L47E40
	btst.b	#$3,$FF800E.l
	bne.s	.L47E40
	bclr.b	#$4,$FF800F.l
	bra.w	.L47F48
.L47E56
	btst.b	#$4,$FF800E.l
	bne.s	.L47E56
	move.b	#$1C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.L47E78
	btst.b	#$4,$FF800E.l
	beq.s	.L47E78
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L47E92
	btst.b	#$3,$FF800E.l
	bne.s	.L47E92
	bclr.b	#$4,$FF800F.l
	bra.w	.L47F48
.L47EA8
	btst.b	#$4,$FF800E.l
	bne.s	.L47EA8
	move.b	#$2C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.L47ECA
	btst.b	#$4,$FF800E.l
	beq.s	.L47ECA
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L47EE4
	btst.b	#$3,$FF800E.l
	bne.s	.L47EE4
	bclr.b	#$4,$FF800F.l
	bra.w	.L47F48
.L47EFA
	btst.b	#$4,$FF800E.l
	bne.s	.L47EFA
	move.b	#$3C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.L47F1C
	btst.b	#$4,$FF800E.l
	beq.s	.L47F1C
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L47F36
	btst.b	#$3,$FF800E.l
	bne.s	.L47F36
	bclr.b	#$4,$FF800F.l
.L47F48
	movem.l	d1/a0,-(sp)
	bra.w	.L47F5C
.L47F50
	movem.l	d1/a0,-(sp)
	bra.w	.L48096
.L47F58
	movem.l	d1/a0,-(sp)
.L47F5C
	moveq	#$0,d0
.L47F5E
	btst.b	#$4,$FF800E.l
	bne.s	.L47F5E
	move.b	#$0,$FF8028.l
	move.w	#$36,$FF8026.l
	bset.b	#$3,$FF800F.l
.L47F80
	btst.b	#$3,$FF800E.l
	beq.s	.L47F80
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L47F9A
	btst.b	#$3,$FF800E.l
	bne.s	.L47F9A
	bclr.b	#$4,$FF800F.l
.L47FAC
	btst.b	#$4,$FF800E.l
	bne.s	.L47FAC
	move.w	#$37,$FF8026.l
	bset.b	#$3,$FF800F.l
.L47FC6
	btst.b	#$3,$FF800E.l
	beq.s	.L47FC6
	move.b	$FF8018.l,d0
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L47FE6
	btst.b	#$3,$FF800E.l
	bne.s	.L47FE6
	bclr.b	#$4,$FF800F.l
.L47FF8
	btst.b	#$4,$FF800E.l
	bne.s	.L47FF8
	move.b	#$40,$FF8028.l
	move.w	#$36,$FF8026.l
	bset.b	#$3,$FF800F.l
.L4801A
	btst.b	#$3,$FF800E.l
	beq.s	.L4801A
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L48034
	btst.b	#$3,$FF800E.l
	bne.s	.L48034
	bclr.b	#$4,$FF800F.l
.L48046
	btst.b	#$4,$FF800E.l
	bne.s	.L48046
	move.w	#$37,$FF8026.l
	bset.b	#$3,$FF800F.l
.L48060
	btst.b	#$3,$FF800E.l
	beq.s	.L48060
	move.b	$FF8018.l,d1
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L48080
	btst.b	#$3,$FF800E.l
	bne.s	.L48080
	bclr.b	#$4,$FF800F.l
	bra.w	.L481D0
.L48096
	moveq	#$0,d0
.L48098
	btst.b	#$4,$FF800E.l
	bne.s	.L48098
	move.b	#$0,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.L480BA
	btst.b	#$4,$FF800E.l
	beq.s	.L480BA
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L480D4
	btst.b	#$3,$FF800E.l
	bne.s	.L480D4
	bclr.b	#$4,$FF800F.l
.L480E6
	btst.b	#$4,$FF800E.l
	bne.s	.L480E6
	move.w	#$38,$FF8026.l
	bset.b	#$3,$FF800F.l
.L48100
	btst.b	#$3,$FF800E.l
	beq.s	.L48100
	move.b	$FF8018.l,d0
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L48120
	btst.b	#$3,$FF800E.l
	bne.s	.L48120
	bclr.b	#$4,$FF800F.l
.L48132
	btst.b	#$4,$FF800E.l
	bne.s	.L48132
	move.b	#$40,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.L48154
	btst.b	#$4,$FF800E.l
	beq.s	.L48154
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L4816E
	btst.b	#$3,$FF800E.l
	bne.s	.L4816E
	bclr.b	#$4,$FF800F.l
.L48180
	btst.b	#$4,$FF800E.l
	bne.s	.L48180
	move.w	#$38,$FF8026.l
	bset.b	#$3,$FF800F.l
.L4819A
	btst.b	#$3,$FF800E.l
	beq.s	.L4819A
	move.b	$FF8018.l,d1
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L481BA
	btst.b	#$3,$FF800E.l
	bne.s	.L481BA
	bclr.b	#$4,$FF800F.l
	bra.w	.L481D0
.L481D0
	asl.b	#$2,d0
	andi.b	#$C0,d0
	andi.b	#$3F,d1
	or.b	d1,d0
	not.b	d0
	not.b	d1
	andi.w	#$F,d1
	lea	.L481F8(pc),a0
	andi.b	#$F0,d0
	or.b	(a0,d1.w),d0
	not.b	d0
	movem.l	(sp)+,d1/a0
	rts
.L481F8
	dc.w	$0001,$0201
	dc.w	$0405,$0606
	dc.w	$0809
	dc.w	$0A0A
	dc.w	$0809
	dc.w	$0A00,$4E75
