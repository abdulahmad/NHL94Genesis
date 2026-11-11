;	PLAYER.BIN $281C-$3F83 (runtime $281C-$3F83).
;
;	After playerpage.asm: the display, input and text helpers of the overlay: VRAM copies and fills, the
;	queued display work and palette fades through the main CPU, the career record search, number formatting,
;	the pad readers (HOCKEY names), the frame callback at $6038, text printing. docs/segacd_player.md.


X_3F84	equ	$3F84
X_3F92	equ	$3F92
X_3FAA	equ	$3FAA
X_3FB8	equ	$3FB8
X_4059	equ	$4059
X_4085	equ	$4085

	org	$281C

CopyVramRows
	movem.l	d0-d7/a0-a3,-(sp)
	movea.l	#$BC000,a0
	move.w	d0,d4
	dc.b	'2A4BHAHB:'
	dc.b	$01
	move.w	d2,d6
	move.w	d3,d7
	move.w	d3,(a0)+
	move.w	#$8F01,(a0)+
.L283C
	move.w	d4,d0
	move.w	d5,d1
	move.w	d6,d2
	move.w	#$8154,(a0)+
	move.w	#$9300,d3
	move.b	d0,d3
	move.w	d3,(a0)+
	move.w	#$9400,d3
	lsr.w	#$8,d0
	move.b	d0,d3
	move.w	d3,(a0)+
	move.w	#$9500,d3
	move.b	d2,d3
	move.w	d3,(a0)+
	move.w	#$9600,d3
	lsr.w	#$8,d2
	move.b	d2,d3
	move.w	d3,(a0)+
	move.w	#$97C0,(a0)+
	clr.l	d0
	move.w	d1,d0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	swap	d0
	ori.w	#$C0,d0
	move.l	d0,(a0)+
	add.w	a1,d5
	add.w	a2,d6
	dbf	d7,.L283C
	move.w	#$8,$DE(a6)
.L288C
	tst.w	$DE(a6)
	bne.w	.L288C
	movem.l	(sp)+,d0-d7/a0-a3
	rts
CopyVramRowsViaMainCommand
	movem.l	d0-d4,-(sp)
	move.w	#$50,$E0(a6)
	move.w	d0,d3
	swap	d0
	move.w	d1,d4
	swap	d1
.L28AC
	move.w	d0,$E4(a6)
	move.w	d1,$E2(a6)
	move.w	#$6,$DE(a6)
.L28BA
	tst.w	$DE(a6)
	bne.w	.L28BA
	add.w	d3,d0
	add.w	d4,d1
	dbf	d2,.L28AC
	movem.l	(sp)+,d0-d4
	rts
	dc.w	$1650
	dc.b	'ower play advantage'
	dc.b	$00
	dc.w	$1E50
	dc.b	'enalty killing disadvantage'
	dc.b	$00
	dc.w	$1548
	dc.b	'ome team advantage'
	dc.w	$0018,$526F
	dc.b	'ad team disadvantage'
	dc.w	$0014,$4E75
	dc.b	'mber of forwards'
	dc.w	$0016,$4E75
	dc.b	'mber of defensemen'
	dc.w	$000B
	dc.b	'Goalie # '
	dc.b	$00
	bchg.b	d5,(a0)
	dc.b	'layer # '
	dc.w	$0000
FormatTwoDigitNumber
	movem.l	d0-d2,-(sp)
	moveq	#$1,d0
	moveq	#$0,d2
	abcd.b	d0,d1
	moveq	#$0,d1
	bra.w	.L2984
.L2982
	abcd.b	d0,d1
.L2984
	dbf	d7,.L2982
	move.l	d1,d7
	cmpi.w	#$9,d1
	bgt.w	.L29A0
	addi.b	#$30,d7
	ori.l	#$2000,d7
	bra.w	.L29B0
.L29A0
	ror.b	#$4,d7
	lsl.w	#$4,d7
	lsr.b	#$4,d7
	addi.w	#$3030,d7
	ori.l	#$200000,d7
.L29B0
	movem.l	(sp)+,d0-d2
	rts
FormatPercentage
	movem.l	d0-d2,-(sp)
	moveq	#$1,d0
	moveq	#$0,d1
	moveq	#$0,d2
	bra.w	.L29CC
.L29C4
	abcd.b	d0,d1
	bcc.w	.L29CC
	addq.w	#$1,d2
.L29CC
	dbf	d7,.L29C4
	move.l	d1,d7
	tst.w	d2
	bne.w	.L2A02
	cmpi.w	#$9,d1
	bgt.w	.L29EE
	addi.b	#$30,d7
	ori.l	#$20202500,d7
	bra.w	.L2A18
.L29EE
	ror.b	#$4,d7
	lsl.w	#$4,d7
	lsr.b	#$4,d7
	addi.w	#$3030,d7
	ori.l	#$20250000,d7
	bra.w	.L2A18
.L2A02
	ror.b	#$4,d7
	lsl.w	#$4,d7
	lsr.b	#$4,d7
	lsl.l	#$8,d7
	move.b	d2,d7
	addi.l	#$303030,d7
	ori.l	#$25000000,d7
.L2A18
	movem.l	(sp)+,d0-d2
	rts
FormatDecimalString
	movem.l	d0-d2/a0-a1,-(sp)
	lea	.L2A50(pc),a1
	moveq	#$0,d2
	clr.b	(a1)+
.L2A2A
	move.l	d0,d1
	divu.w	#$A,d1
	swap	d1
	move.w	d1,d2
	addi.b	#$30,d1
	move.b	d1,(a1)+
	sub.l	d2,d0
	divu.w	#$A,d0
	bne.w	.L2A2A
.L2A44
	move.b	-(a1),(a0)+
	bne.w	.L2A44
	movem.l	(sp)+,d0-d2/a0-a1
	rts
.L2A50
	dcb.b	80,0
FindPlayerAndCareerRecord
	movem.l	d0-d7/a1-a5,-(sp)
	moveq	#$0,d0
	movea.l	$1C(a6),a1
	movea.l	$48(a6),a2
	move.w	$7C(a6),d0
	cmpi.w	#$0,$18(a6)
	beq.w	.L2AC8
	movea.l	$20(a6),a1
	movea.l	$4C(a6),a2
	move.w	$7E(a6),d0
.L2AC8
	move.w	$80(a6),d2
	add.w	d2,d2
	move.w	(a2,d2.w),d1
	bpl.w	.L2AE6
	neg.w	d1
	cmpi.w	#$40,d1
	bne.w	.L2AE6
	moveq	#$0,d1
	clr.w	$80(a6)
.L2AE6
	movea.l	$86(a6),a2
	add.l	d0,d0
	add.l	d0,d0
	movea.l	(a2,d0.l),a1
	move.w	(a1),d0
	movea.l	a1,a2
	adda.l	d0,a2
	bra.w	.L2B02
.L2AFC
	move.w	(a2),d0
	lea	$8(a2,d0.l),a2
.L2B02
	dbf	d1,.L2AFC
	move.w	(a2),d0
	lea	(a2,d0.l),a0
	move.l	a0,$50(a6)
	subq.w	#$3,d0
	movea.l	a2,a0
	addq.l	#$2,a0
	movea.l	$8E(a6),a1
.L2B1A
	move.b	(a0)+,d1
	beq.w	.L2B26
	move.b	d1,(a1)+
	dbf	d0,.L2B1A
.L2B26
	move.b	#$0,(a1)
	movea.l	$8E(a6),a0
.L2B2E
	move.b	(a0)+,d0
	cmpi.b	#$20,d0
	bne.w	.L2B2E
	lea	X_4059(pc),a5
	move.l	a5,$9A(a6)
	move.w	#$2,$A6(a6)
	lea	X_3FAA(pc),a5
	move.l	a5,$9E(a6)
	lea	X_3F84(pc),a5
	movea.l	a0,a3
	movea.l	$2C(a6),a1
	movea.l	$30(a6),a2
	cmpi.w	#$0,$18(a6)
	beq.w	.L2B6E
	movea.l	$3C(a6),a1
	movea.l	$40(a6),a2
.L2B6E
	move.l	a1,d0
	beq.w	.L2C16
	moveq	#$0,d0
	moveq	#-2,d2
.L2B78
	movea.l	a1,a4
	adda.l	#$5,a4
	movea.l	a3,a0
.L2B82
	move.b	(a0)+,d0
	move.b	(a4)+,d1
	ori.b	#$20,d0
	ori.b	#$20,d1
	cmp.b	d0,d1
	beq.w	.L2B82
	cmpi.b	#$2C,-$1(a4)
	beq.w	.L2BC4
	moveq	#$0,d1
.L2BA0
	move.w	(a1),d1
	lea	(a1,d1.l),a1
	cmpi.w	#$656C,$4(a1)
	beq.w	.L2BE8
	cmpi.w	#$656E,$4(a1)
	bne.w	.L2BA0
	move.w	(a1),d1
	lea	(a1,d1.l),a1
	bra.w	.L2B78
.L2BC4
	move.l	a1,$44(a6)
.L2BC8
	move.w	$5A(a6),d0
	add.w	d0,d0
	move.w	(a5,d0.w),$58(a6)
	bpl.w	.L2C1E
	move.w	#$0,$B0(a6)
	subi.w	#$1,$5A(a6)
	bra.w	.L2BC8
.L2BE8
	addq.w	#$1,d2
	beq.w	.L2C16
	movea.l	a2,a1
	lea	X_4085(pc),a5
	move.l	a5,$9A(a6)
	move.w	#$5,$A6(a6)
	lea	X_3FB8(pc),a5
	move.l	a5,$9E(a6)
	lea	X_3F92(pc),a5
	move.l	a1,d0
	beq.w	.L2C16
	moveq	#$0,d0
	bra.w	.L2B78
.L2C16
	move.l	#$0,$44(a6)
.L2C1E
	movea.l	$8E(a6),a0
	movem.l	(sp)+,d0-d7/a1-a5
	rts
FillVram
	move.w	d0,$E0(a6)
	swap	d0
	move.w	d0,$E2(a6)
	move.l	$62(a6),$E4(a6)
	move.w	#$2,$DE(a6)
.L2C3E
	tst.w	$DE(a6)
	bne.w	.L2C3E
	rts
FillVramWithTextTile
	move.w	d0,$E0(a6)
	swap	d0
	move.w	d0,$E2(a6)
	move.l	#$7A1,$E4(a6)
	move.w	#$2,$DE(a6)
.L2C60
	tst.w	$DE(a6)
	bne.w	.L2C60
	rts
DrawTileMap
	move.w	(a1)+,d1
	subq.w	#$1,d1
	move.w	d1,d2
	move.w	(a1)+,d7
	subq.w	#$1,d7
.L2C74
	moveq	#$0,d4
	move.w	d3,d4
	bsr.w	MakeVramWriteCommand
.L2C7C
	btst.b	#$7,$FF800E.l
	bne.s	.L2C7C
	move.l	d4,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2C9C
	btst.b	#$6,$FF800E.l
	beq.s	.L2C9C
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2CB6
	btst.b	#$6,$FF800E.l
	bne.s	.L2CB6
	bclr.b	#$7,$FF800F.l
.L2CC8
	move.w	(a1)+,d4
	btst	#$D,d4
	bne.w	.L2CDE
	tst.w	$B2(a6)
	beq.w	.L2CDE
	ori.w	#$6000,d4
.L2CDE
	add.w	d5,d4
.L2CE0
	btst.b	#$7,$FF800E.l
	bne.s	.L2CE0
	move.w	d4,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2D00
	btst.b	#$6,$FF800E.l
	beq.s	.L2D00
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2D1A
	btst.b	#$6,$FF800E.l
	bne.s	.L2D1A
	bclr.b	#$7,$FF800F.l
	dbf	d2,.L2CC8
	add.w	d6,d3
	move.w	d1,d2
	dbf	d7,.L2C74
	rts
MakeVramWriteCommand
	andi.l	#$FFFF,d4
	lsl.l	#$2,d4
	lsr.w	#$2,d4
	swap	d4
	addi.l	#$40000000,d4
	rts
IncrementPaletteTick
	addq.w	#$1,$EC(a6)
	rts
ServicePlayerDisplay
	move.w	#$1,$102(a6)
	addi.l	#$1,$96(a6)
	cmpi.w	#$2,$DE(a6)
	beq.w	.L3272
	cmpi.w	#$1,$DE(a6)
	beq.w	.L32EA
	cmpi.w	#$3,$DE(a6)
	beq.w	.L3046
	cmpi.w	#$4,$DE(a6)
	beq.w	.L30A6
	cmpi.w	#$5,$DE(a6)
	beq.w	.L3100
	cmpi.w	#$6,$DE(a6)
	beq.w	.L31F8
	cmpi.w	#$7,$DE(a6)
	beq.w	.L2F90
	cmpi.w	#$8,$DE(a6)
	beq.w	.L2F36
	cmpi.w	#$9,$DE(a6)
	beq.w	.L2E7E
	cmpi.w	#$A,$DE(a6)
	beq.w	.L2DCA
	bra.w	.L3400
.L2DCA
	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
	move.w	$E2(a6),d0
	move.w	$E0(a6),d1
	addi.w	#$9200,d0
.L2DDE
	btst.b	#$4,$FF800E.l
	bne.s	.L2DDE
	move.w	#$39,$FF8026.l
	move.w	d0,$FF8028.l
	bset.b	#$3,$FF800F.l
.L2DFE
	btst.b	#$3,$FF800E.l
	beq.s	.L2DFE
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L2E18
	btst.b	#$3,$FF800E.l
	bne.s	.L2E18
	bclr.b	#$4,$FF800F.l
	addi.w	#$9100,d1
.L2E2E
	btst.b	#$4,$FF800E.l
	bne.s	.L2E2E
	move.w	#$39,$FF8026.l
	move.w	d1,$FF8028.l
	bset.b	#$3,$FF800F.l
.L2E4E
	btst.b	#$3,$FF800E.l
	beq.s	.L2E4E
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L2E68
	btst.b	#$3,$FF800E.l
	bne.s	.L2E68
	bclr.b	#$4,$FF800F.l
	bra.w	.L33FC
.L2E7E
	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
	move.w	$E2(a6),d0
	andi.w	#$3FF,d0
.L2E8E
	btst.b	#$4,$FF800E.l
	bne.s	.L2E8E
	move.w	#$30,$FF8026.l
	move.l	#$70000003,$FF8028.l
	bset.b	#$3,$FF800F.l
.L2EB2
	btst.b	#$3,$FF800E.l
	beq.s	.L2EB2
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L2ECC
	btst.b	#$3,$FF800E.l
	bne.s	.L2ECC
	bclr.b	#$4,$FF800F.l
.L2EDE
	btst.b	#$4,$FF800E.l
	bne.s	.L2EDE
	move.w	#$31,$FF8026.l
	move.w	d0,$FF8028.l
	bset.b	#$3,$FF800F.l
.L2EFE
	btst.b	#$3,$FF800E.l
	beq.s	.L2EFE
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L2F18
	btst.b	#$3,$FF800E.l
	bne.s	.L2F18
	bclr.b	#$4,$FF800F.l
	add.w	$E0(a6),d0
	move.w	d0,$E2(a6)
	bra.w	.L33FC
.L2F36
	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
	bsr.w	GiveWordRamToMain
.L2F42
	btst.b	#$4,$FF800E.l
	bne.s	.L2F42
	move.w	#$2C,$FF8026.l
	bset.b	#$3,$FF800F.l
.L2F5C
	btst.b	#$3,$FF800E.l
	beq.s	.L2F5C
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L2F76
	btst.b	#$3,$FF800E.l
	bne.s	.L2F76
	bclr.b	#$4,$FF800F.l
	bsr.w	WaitForSubWordRam
	bra.w	.L33FC
.L2F90
	movem.l	d0-d3/a0-a2,-(sp)
.L2F94
	btst.b	#$4,$FF800E.l
	bne.s	.L2F94
	move.w	#$30,$FF8026.l
	move.l	#$40000010,$FF8028.l
	bset.b	#$3,$FF800F.l
.L2FB8
	btst.b	#$3,$FF800E.l
	beq.s	.L2FB8
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L2FD2
	btst.b	#$3,$FF800E.l
	bne.s	.L2FD2
	bclr.b	#$4,$FF800F.l
	clr.w	$DE(a6)
	move.w	$E2(a6),d0
	move.w	$E0(a6),d1
	add.w	d1,d0
.L2FF2
	btst.b	#$4,$FF800E.l
	bne.s	.L2FF2
	move.w	#$31,$FF8026.l
	move.w	d0,$FF8028.l
	bset.b	#$3,$FF800F.l
.L3012
	btst.b	#$3,$FF800E.l
	beq.s	.L3012
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L302C
	btst.b	#$3,$FF800E.l
	bne.s	.L302C
	bclr.b	#$4,$FF800F.l
	move.w	d0,$E2(a6)
	bra.w	.L33FC
.L3046
	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
	moveq	#$0,d0
	bsr.w	WriteHorizontalScroll
.L3054
	btst.b	#$4,$FF800E.l
	bne.s	.L3054
	move.w	#$39,$FF8026.l
	move.w	#$9001,$FF8028.l
	bset.b	#$3,$FF800F.l
.L3076
	btst.b	#$3,$FF800E.l
	beq.s	.L3076
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3090
	btst.b	#$3,$FF800E.l
	bne.s	.L3090
	bclr.b	#$4,$FF800F.l
	bra.w	.L33FC
.L30A6
	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
.L30AE
	btst.b	#$4,$FF800E.l
	bne.s	.L30AE
	move.w	#$39,$FF8026.l
	move.w	#$9003,$FF8028.l
	bset.b	#$3,$FF800F.l
.L30D0
	btst.b	#$3,$FF800E.l
	beq.s	.L30D0
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L30EA
	btst.b	#$3,$FF800E.l
	bne.s	.L30EA
	bclr.b	#$4,$FF800F.l
	bra.w	.L33FC
.L3100
	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
.L3108
	btst.b	#$4,$FF800E.l
	bne.s	.L3108
	move.w	#$39,$FF8026.l
	move.w	$E2(a6),$FF8028.l
	bset.b	#$3,$FF800F.l
.L312A
	btst.b	#$3,$FF800E.l
	beq.s	.L312A
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3144
	btst.b	#$3,$FF800E.l
	bne.s	.L3144
	bclr.b	#$4,$FF800F.l
.L3156
	btst.b	#$4,$FF800E.l
	bne.s	.L3156
	move.w	#$30,$FF8026.l
	move.l	#$40000010,$FF8028.l
	bset.b	#$3,$FF800F.l
.L317A
	btst.b	#$3,$FF800E.l
	beq.s	.L317A
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3194
	btst.b	#$3,$FF800E.l
	bne.s	.L3194
	bclr.b	#$4,$FF800F.l
.L31A6
	btst.b	#$4,$FF800E.l
	bne.s	.L31A6
	move.w	#$31,$FF8026.l
	move.w	#$0,$FF8028.l
	bset.b	#$3,$FF800F.l
.L31C8
	btst.b	#$3,$FF800E.l
	beq.s	.L31C8
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L31E2
	btst.b	#$3,$FF800E.l
	bne.s	.L31E2
	bclr.b	#$4,$FF800F.l
	bra.w	.L33FC
.L31F8
	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
	moveq	#$0,d0
	move.w	$E0(a6),d0
	move.l	d0,$BBC88.l
	move.w	$E2(a6),d0
	move.l	d0,$BBC8C.l
	move.w	$E4(a6),d0
	move.l	d0,$BBC90.l
	bsr.w	GiveWordRamToMain
.L3224
	btst.b	#$4,$FF800E.l
	bne.s	.L3224
	move.w	#$3A,$FF8026.l
	bset.b	#$3,$FF800F.l
.L323E
	btst.b	#$3,$FF800E.l
	beq.s	.L323E
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3258
	btst.b	#$3,$FF800E.l
	bne.s	.L3258
	bclr.b	#$4,$FF800F.l
	bsr.w	WaitForSubWordRam
	bra.w	.L33FC
.L3272
	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
	moveq	#$0,d0
	move.w	$E0(a6),d0
	move.l	d0,$BBC88.l
	move.w	$E2(a6),d0
	move.l	d0,$BBC8C.l
	move.l	$E4(a6),$BBC90.l
	bsr.w	GiveWordRamToMain
.L329C
	btst.b	#$4,$FF800E.l
	bne.s	.L329C
	move.w	#$3B,$FF8026.l
	bset.b	#$3,$FF800F.l
.L32B6
	btst.b	#$3,$FF800E.l
	beq.s	.L32B6
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L32D0
	btst.b	#$3,$FF800E.l
	bne.s	.L32D0
	bclr.b	#$4,$FF800F.l
	bsr.w	WaitForSubWordRam
	bra.w	.L33FC
.L32EA
	movem.l	d0-d3/a0-a2,-(sp)
	clr.w	$DE(a6)
	move.w	$E0(a6),d0
	move.w	$E2(a6),d1
	movea.l	$E4(a6),a0
	cmpa.l	#$80000,a0
	bge.w	.L3326
	move.l	d0,d3
	movea.l	#$BC000,a2
	lsr.w	#$1,d3
	bcc.w	.L3318
	move.w	(a0)+,(a2)+
.L3318
	subq.w	#$1,d3
.L331A
	move.l	(a0)+,(a2)+
	dbf	d3,.L331A
	movea.l	#$BC000,a0
.L3326
	lea	$C00004.l,a1
	move.l	(a0),$BBC96.l
	move.l	d1,$BBC9A.l
	adda.l	#$180002,a0
	move.w	#$8154,$BBC88.l
	move.w	#$8F02,$BBC8A.l
	move.w	#$9300,d2
	move.b	d0,d2
	move.w	d2,$BBC8C.l
	move.w	#$9400,d2
	lsr.w	#$8,d0
	move.b	d0,d2
	move.w	d2,$BBC8E.l
	move.l	a0,d0
	lsr.l	#$1,d0
	move.w	#$9500,d2
	move.b	d0,d2
	move.w	d2,$BBC90.l
	lsr.l	#$8,d0
	move.w	#$9600,d2
	move.b	d0,d2
	move.w	d2,$BBC92.l
	lsr.l	#$8,d0
	andi.b	#$7F,d0
	move.w	#$9700,d2
	move.b	d0,d2
	move.w	d2,$BBC94.l
	clr.l	d0
	move.w	d1,d0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	move.l	d0,d3
	ori.l	#$804000,d0
	move.l	d0,$BBC9E.l
	bsr.w	GiveWordRamToMain
.L33B2
	btst.b	#$4,$FF800E.l
	bne.s	.L33B2
	move.w	#$32,$FF8026.l
	bset.b	#$3,$FF800F.l
.L33CC
	btst.b	#$3,$FF800E.l
	beq.s	.L33CC
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L33E6
	btst.b	#$3,$FF800E.l
	bne.s	.L33E6
	bclr.b	#$4,$FF800F.l
	bsr.w	WaitForSubWordRam
.L33FC
	movem.l	(sp)+,d0-d3/a0-a2
.L3400
	tst.w	$FA(a6)
	beq.w	.L3472
	movem.l	d0-d3/a0-a2,-(sp)
	move.w	$F6(a6),d0
	cmp.w	$F4(a6),d0
	bgt.w	.L3436
	cmpi.w	#$1,$F8(a6)
	beq.w	.L3424
	neg.w	d0
.L3424
	add.w	$F2(a6),d0
	bsr.w	WriteHorizontalScroll
	addi.w	#$6,$F6(a6)
	bra.w	.L346E
.L3436
	move.w	$F6(a6),d0
	subi.w	#$6,d0
	move.w	d0,$F6(a6)
	sub.w	$F4(a6),d0
	neg.w	d0
	add.w	$F6(a6),d0
	tst.w	$F8(a6)
	bne.w	.L3456
	neg.w	d0
.L3456
	add.w	$F2(a6),d0
	bsr.w	WriteHorizontalScroll
	clr.w	$FA(a6)
	clr.w	$F6(a6)
	andi.w	#$3FF,d0
	move.w	d0,$F2(a6)
.L346E
	movem.l	(sp)+,d0-d3/a0-a2
.L3472
	movem.l	d0-d5/a0-a1,-(sp)
	bsr.w	StepPaletteFade
	movem.l	(sp)+,d0-d5/a0-a1
	rts
WriteHorizontalScroll
	btst.b	#$4,$FF800E.l
	bne.s	WriteHorizontalScroll
	move.w	#$30,$FF8026.l
	move.l	#$70000003,$FF8028.l
	bset.b	#$3,$FF800F.l
.L34A4
	btst.b	#$3,$FF800E.l
	beq.s	.L34A4
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L34BE
	btst.b	#$3,$FF800E.l
	bne.s	.L34BE
	bclr.b	#$4,$FF800F.l
.L34D0
	btst.b	#$4,$FF800E.l
	bne.s	.L34D0
	move.w	#$31,$FF8026.l
	move.w	d0,$FF8028.l
	bset.b	#$3,$FF800F.l
.L34F0
	btst.b	#$3,$FF800E.l
	beq.s	.L34F0
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L350A
	btst.b	#$3,$FF800E.l
	bne.s	.L350A
	bclr.b	#$4,$FF800F.l
.L351C
	btst.b	#$4,$FF800E.l
	bne.s	.L351C
	move.w	#$31,$FF8026.l
	move.w	d0,$FF8028.l
	bset.b	#$3,$FF800F.l
.L353C
	btst.b	#$3,$FF800E.l
	beq.s	.L353C
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3556
	btst.b	#$3,$FF800E.l
	bne.s	.L3556
	bclr.b	#$4,$FF800F.l
	rts
StepPaletteFade
	tst.w	$EC(a6)
	bmi.w	.L3606
	cmpi.w	#$64,$EC(a6)
	beq.w	WritePlayerPalette
	subq.w	#$1,$EC(a6)
	bmi.w	.L3606
	clr.l	d0
	move.w	$EC(a6),d0
	cmpi.w	#$18,d0
	bgt.w	.L3606
	divu.w	#$3,d0
	swap	d0
	asl.w	#$2,d0
	moveq	#$2,d3
	asl.w	d0,d3
	moveq	#$E,d5
	asl.w	d0,d5
	move.w	d5,d4
	not.w	d4
	move.l	d3,$BBC88.l
	move.l	d4,$BBC8C.l
	move.l	d5,$BBC90.l
	bsr.w	GiveWordRamToMain
.L35BC
	btst.b	#$4,$FF800E.l
	bne.s	.L35BC
	move.w	#$1D,$FF8026.l
	bset.b	#$3,$FF800F.l
.L35D6
	btst.b	#$3,$FF800E.l
	beq.s	.L35D6
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L35F0
	btst.b	#$3,$FF800E.l
	bne.s	.L35F0
	bclr.b	#$4,$FF800F.l
	bsr.w	WaitForSubWordRam
.L3606
	rts
WritePlayerPalette
	movea.l	#$BBCB0,a1
.L360E
	btst.b	#$4,$FF800E.l
	bne.s	.L360E
	move.w	#$30,$FF8026.l
	move.l	#$C0000000,$FF8028.l
	bset.b	#$3,$FF800F.l
.L3632
	btst.b	#$3,$FF800E.l
	beq.s	.L3632
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L364C
	btst.b	#$3,$FF800E.l
	bne.s	.L364C
	bclr.b	#$4,$FF800F.l
	moveq	#$1F,d0
.L3660
	btst.b	#$4,$FF800E.l
	bne.s	.L3660
	move.w	#$33,$FF8026.l
	move.l	(a1)+,$FF8028.l
	bset.b	#$3,$FF800F.l
.L3680
	btst.b	#$3,$FF800E.l
	beq.s	.L3680
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L369A
	btst.b	#$3,$FF800E.l
	bne.s	.L369A
	bclr.b	#$4,$FF800F.l
	dbf	d0,.L3660
	st.b	$EC(a6)
	rts
ReadJoy1
	move.b	$C2(a6),d0
	bsr.w	ReadJoy
	move.w	$C6(a6),d2
	move.w	d1,$C6(a6)
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
ReadJoy2
	move.b	$C3(a6),d0
	bsr.w	ReadJoy
	move.w	$C8(a6),d2
	move.w	d1,$C8(a6)
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
ReadJoy3
	move.b	$C4(a6),d0
	bsr.w	ReadJoy
	move.w	$CA(a6),d2
	move.w	d1,$CA(a6)
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
ReadJoy4
	move.b	$C5(a6),d0
	bsr.w	ReadJoy
	move.w	$CC(a6),d2
	move.w	d1,$CC(a6)
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
ReadJoy
	not.b	d0
	clr.w	d1
	move.b	d0,d1
	move.w	d1,-(sp)
	andi.w	#$F0,d0
	andi.w	#$F,d1
	lea	.L3734(pc),a0
	move.b	(a0,d1.w),d1
	or.w	d1,d0
	move.w	(sp)+,d1
	rts
.L3734
	dc.w	$0800
	dc.w	$0408
	dc.w	$0607,$0508
	dc.w	$0201,$0308
	dc.w	$0808
	dc.w	$0808
ReadPads
	movem.l	d1/a0,-(sp)
	tst.w	$BC(a6)
	beq.w	.L3772
	bsr.s	.L3788
	move.b	d0,$C2(a6)
	bsr.w	.L37DA
	move.b	d0,$C3(a6)
	bsr.w	.L382C
	move.b	d0,$C4(a6)
	bsr.w	.L387E
	move.b	d0,$C5(a6)
	bra.w	.L3782
.L3772
	bsr.w	.L38DC
	move.b	d0,$C2(a6)
	bsr.w	.L38D4
	move.b	d0,$C3(a6)
.L3782
	movem.l	(sp)+,d1/a0
	rts
.L3788
	btst.b	#$4,$FF800E.l
	bne.s	.L3788
	move.b	#$C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.L37AA
	btst.b	#$4,$FF800E.l
	beq.s	.L37AA
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L37C4
	btst.b	#$3,$FF800E.l
	bne.s	.L37C4
	bclr.b	#$4,$FF800F.l
	bra.w	.L38CC
.L37DA
	btst.b	#$4,$FF800E.l
	bne.s	.L37DA
	move.b	#$1C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.L37FC
	btst.b	#$4,$FF800E.l
	beq.s	.L37FC
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3816
	btst.b	#$3,$FF800E.l
	bne.s	.L3816
	bclr.b	#$4,$FF800F.l
	bra.w	.L38CC
.L382C
	btst.b	#$4,$FF800E.l
	bne.s	.L382C
	move.b	#$2C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.L384E
	btst.b	#$4,$FF800E.l
	beq.s	.L384E
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3868
	btst.b	#$3,$FF800E.l
	bne.s	.L3868
	bclr.b	#$4,$FF800F.l
	bra.w	.L38CC
.L387E
	btst.b	#$4,$FF800E.l
	bne.s	.L387E
	move.b	#$3C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.L38A0
	btst.b	#$4,$FF800E.l
	beq.s	.L38A0
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L38BA
	btst.b	#$3,$FF800E.l
	bne.s	.L38BA
	bclr.b	#$4,$FF800F.l
.L38CC
	movem.l	d1/a0,-(sp)
	bra.w	.L38E0
.L38D4
	movem.l	d1/a0,-(sp)
	bra.w	.L3A1A
.L38DC
	movem.l	d1/a0,-(sp)
.L38E0
	moveq	#$0,d0
.L38E2
	btst.b	#$4,$FF800E.l
	bne.s	.L38E2
	move.b	#$0,$FF8028.l
	move.w	#$36,$FF8026.l
	bset.b	#$3,$FF800F.l
.L3904
	btst.b	#$3,$FF800E.l
	beq.s	.L3904
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L391E
	btst.b	#$3,$FF800E.l
	bne.s	.L391E
	bclr.b	#$4,$FF800F.l
.L3930
	btst.b	#$4,$FF800E.l
	bne.s	.L3930
	move.w	#$37,$FF8026.l
	bset.b	#$3,$FF800F.l
.L394A
	btst.b	#$3,$FF800E.l
	beq.s	.L394A
	move.b	$FF8018.l,d0
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L396A
	btst.b	#$3,$FF800E.l
	bne.s	.L396A
	bclr.b	#$4,$FF800F.l
.L397C
	btst.b	#$4,$FF800E.l
	bne.s	.L397C
	move.b	#$40,$FF8028.l
	move.w	#$36,$FF8026.l
	bset.b	#$3,$FF800F.l
.L399E
	btst.b	#$3,$FF800E.l
	beq.s	.L399E
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L39B8
	btst.b	#$3,$FF800E.l
	bne.s	.L39B8
	bclr.b	#$4,$FF800F.l
.L39CA
	btst.b	#$4,$FF800E.l
	bne.s	.L39CA
	move.w	#$37,$FF8026.l
	bset.b	#$3,$FF800F.l
.L39E4
	btst.b	#$3,$FF800E.l
	beq.s	.L39E4
	move.b	$FF8018.l,d1
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3A04
	btst.b	#$3,$FF800E.l
	bne.s	.L3A04
	bclr.b	#$4,$FF800F.l
	bra.w	.L3B54
.L3A1A
	moveq	#$0,d0
.L3A1C
	btst.b	#$4,$FF800E.l
	bne.s	.L3A1C
	move.b	#$0,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.L3A3E
	btst.b	#$4,$FF800E.l
	beq.s	.L3A3E
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3A58
	btst.b	#$3,$FF800E.l
	bne.s	.L3A58
	bclr.b	#$4,$FF800F.l
.L3A6A
	btst.b	#$4,$FF800E.l
	bne.s	.L3A6A
	move.w	#$38,$FF8026.l
	bset.b	#$3,$FF800F.l
.L3A84
	btst.b	#$3,$FF800E.l
	beq.s	.L3A84
	move.b	$FF8018.l,d0
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3AA4
	btst.b	#$3,$FF800E.l
	bne.s	.L3AA4
	bclr.b	#$4,$FF800F.l
.L3AB6
	btst.b	#$4,$FF800E.l
	bne.s	.L3AB6
	move.b	#$40,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.L3AD8
	btst.b	#$4,$FF800E.l
	beq.s	.L3AD8
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3AF2
	btst.b	#$3,$FF800E.l
	bne.s	.L3AF2
	bclr.b	#$4,$FF800F.l
.L3B04
	btst.b	#$4,$FF800E.l
	bne.s	.L3B04
	move.w	#$38,$FF8026.l
	bset.b	#$3,$FF800F.l
.L3B1E
	btst.b	#$3,$FF800E.l
	beq.s	.L3B1E
	move.b	$FF8018.l,d1
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3B3E
	btst.b	#$3,$FF800E.l
	bne.s	.L3B3E
	bclr.b	#$4,$FF800F.l
	bra.w	.L3B54
.L3B54
	asl.b	#$2,d0
	andi.b	#$C0,d0
	andi.b	#$3F,d1
	or.b	d1,d0
	not.b	d0
	not.b	d1
	andi.w	#$F,d1
	lea	.L3B7C(pc),a0
	andi.b	#$F0,d0
	or.b	(a0,d1.w),d0
	not.b	d0
	movem.l	(sp)+,d1/a0
	rts
.L3B7C
	dc.w	$0001,$0201
	dc.w	$0405,$0606
	dc.w	$0809
	dc.w	$0A0A
	dc.w	$0809
	dc.w	$0A00
InstallPlayerFrameCallback
	move.l	$6038.w,$D6(a6)
	lea	PlayerFrameCallback(pc),a0
	move.l	a0,$6038.w
	rts
RestorePlayerFrameCallback
	move.l	$D6(a6),$6038.w
	rts
PlayerFrameCallback
	btst.b	#$5,$FF800E.l
	beq.w	.L3C14
	bset.b	#$2,$FF800F.l
	pea	.L3BC2(pc)
	move.l	$D2(a6),-(sp)
	rts
.L3BC2
	bsr.w	ReadPads
.L3BC6
	btst.b	#$4,$FF800E.l
	bne.s	.L3BC6
	move.w	#$2F,$FF8026.l
	bset.b	#$3,$FF800F.l
.L3BE0
	btst.b	#$3,$FF800E.l
	beq.s	.L3BE0
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L3BFA
	btst.b	#$3,$FF800E.l
	bne.s	.L3BFA
	bclr.b	#$4,$FF800F.l
	bclr.b	#$2,$FF800F.l
.L3C14
	rts
PrintTextAtScreenCell
	movem.l	d0-d2/a0-a1/a5,-(sp)
	andi.l	#$FFFF,d0
	divu.w	#$28,d0
	move.w	d0,d2
	lsl.w	#$6,d2
	swap	d0
	add.w	d2,d0
	add.w	d0,d0
	moveq	#$0,d2
	move.w	#$B000,d2
	add.w	d0,d2
	lsl.l	#$2,d2
	lsr.w	#$2,d2
	swap	d2
	addi.l	#$40000000,d2
.L3C42
	btst.b	#$7,$FF800E.l
	bne.s	.L3C42
	move.l	d2,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3C62
	btst.b	#$6,$FF800E.l
	beq.s	.L3C62
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3C7C
	btst.b	#$6,$FF800E.l
	bne.s	.L3C7C
	bclr.b	#$7,$FF800F.l
	movea.l	$8E(a6),a5
	bsr.w	PrintPaddedText
	movem.l	(sp)+,d0-d2/a0-a1/a5
	rts
PrintTextAtPageCell
	movem.l	d0-d2/a0-a1/a5,-(sp)
	andi.l	#$FFFF,d0
	divu.w	#$28,d0
	move.w	d0,d2
	lsl.w	#$7,d2
	swap	d0
	add.w	d2,d0
	add.w	d0,d0
	moveq	#$0,d2
	move.w	$EE(a6),d2
	subi.w	#$2000,d2
	add.w	d0,d2
	lsl.l	#$2,d2
	lsr.w	#$2,d2
	swap	d2
	addi.l	#$40000000,d2
.L3CCC
	btst.b	#$7,$FF800E.l
	bne.s	.L3CCC
	move.l	d2,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3CEC
	btst.b	#$6,$FF800E.l
	beq.s	.L3CEC
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3D06
	btst.b	#$6,$FF800E.l
	bne.s	.L3D06
	bclr.b	#$7,$FF800F.l
	movea.l	$8E(a6),a5
	bsr.w	PrintPaddedText
	movem.l	(sp)+,d0-d2/a0-a1/a5
	rts
PrintPaddedText
	move.w	#$7A0,d0
	bset	#$E,d0
.L3D2E
	moveq	#$0,d2
	move.b	(a0)+,d2
	beq.w	.L3DB8
	cmpi.b	#$22,d2
	beq.w	.L3D52
	cmpi.b	#$5F,d2
	beq.w	.L3D52
	cmpi.b	#$24,d2
	beq.w	.L3D5A
	bra.w	.L3D5E
.L3D52
	move.b	#$20,d2
	bra.w	.L3D5E
.L3D5A
	move.b	#$22,d2
.L3D5E
	move.b	d2,(a5)+
	subi.b	#$20,d2
	add.w	d0,d2
.L3D66
	btst.b	#$7,$FF800E.l
	bne.s	.L3D66
	move.w	d2,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3D86
	btst.b	#$6,$FF800E.l
	beq.s	.L3D86
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3DA0
	btst.b	#$6,$FF800E.l
	bne.s	.L3DA0
	bclr.b	#$7,$FF800F.l
	subq.w	#$1,d1
	bra.w	.L3D2E
.L3DB8
	tst.w	d1
	blt.w	.L3E14
.L3DBE
	btst.b	#$7,$FF800E.l
	bne.s	.L3DBE
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3DDE
	btst.b	#$6,$FF800E.l
	beq.s	.L3DDE
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3DF8
	btst.b	#$6,$FF800E.l
	bne.s	.L3DF8
	bclr.b	#$7,$FF800F.l
	move.b	#$20,(a5)+
	dbf	d1,.L3DBE
	subq.l	#$1,a5
.L3E14
	clr.b	(a5)+
	rts
PrintStatColumnText
	movem.l	d0-d2/a4,-(sp)
	move.w	#$7A0,d0
	bset	#$E,d0
.L3E24
	moveq	#$0,d2
	move.b	(a4)+,d2
	beq.w	.L3E8C
	cmpi.b	#$FF,d2
	beq.w	.L3E8C
	subi.b	#$20,d2
	add.w	d0,d2
.L3E3A
	btst.b	#$7,$FF800E.l
	bne.s	.L3E3A
	move.w	d2,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3E5A
	btst.b	#$6,$FF800E.l
	beq.s	.L3E5A
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3E74
	btst.b	#$6,$FF800E.l
	bne.s	.L3E74
	bclr.b	#$7,$FF800F.l
	subq.b	#$1,d1
	bra.w	.L3E24
.L3E8C
	subq.b	#$1,d1
	tst.b	d1
	bmi.w	.L3EE4
.L3E94
	btst.b	#$7,$FF800E.l
	bne.s	.L3E94
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3EB4
	btst.b	#$6,$FF800E.l
	beq.s	.L3EB4
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3ECE
	btst.b	#$6,$FF800E.l
	bne.s	.L3ECE
	bclr.b	#$7,$FF800F.l
	dbf	d1,.L3E94
.L3EE4
	movem.l	(sp)+,d0-d2/a4
	rts
CopyTextToBuffer
	movem.l	d0/a0-a1,-(sp)
	movea.l	$8E(a6),a1
.L3EF2
	move.b	(a0)+,(a1)+
	beq.w	.L3EFE
	dbf	d0,.L3EF2
	clr.b	(a1)
.L3EFE
	movem.l	(sp)+,d0/a0-a1
	rts
WaitForSubWordRam
	btst.b	#$1,$FF8003.l
	beq.s	WaitForSubWordRam
	rts
GiveWordRamToMain
	bset.b	#$0,$FF8003.l
.L3F18
	btst.b	#$1,$FF8003.l
	bne.s	.L3F18
	rts
SendMainCommand3D
	movem.l	d0-d7/a0-a2,-(sp)
	bclr.b	#$5,$FF800F.l
.L3F30
	btst.b	#$7,$FF800E.l
	bne.s	.L3F30
	move.w	#$3D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3F4A
	btst.b	#$6,$FF800E.l
	beq.s	.L3F4A
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3F64
	btst.b	#$6,$FF800E.l
	bne.s	.L3F64
	bclr.b	#$7,$FF800F.l
	bset.b	#$5,$FF800F.l
	movem.l	(sp)+,d0-d7/a0-a2
	rts
