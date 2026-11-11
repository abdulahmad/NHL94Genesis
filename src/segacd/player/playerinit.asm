;	PLAYER.BIN $0-$1D53 (runtime $0-$1D53).
;
;	The start of PLAYER.BIN, the player information overlay HOCKEY.BIN runs with $6044 d7 = 5 (d0, d1 the two
;	teams, d2 FourWayPlay): stack and a6 (base + $A594), the team resources, the photo and team stat pages,
;	text sprites and page transitions, up to playerpic.asm. Names given here; docs/segacd_player.md.


CopyVramRows	equ	$281C
FillVram	equ	$2C28
DrawTileMap	equ	$2C6A
IncrementPaletteTick	equ	$2D4E
ServicePlayerDisplay	equ	$2D54
ReadJoy1	equ	$36B6
ReadJoy2	equ	$36CE
InstallPlayerFrameCallback	equ	$3B8C
RestorePlayerFrameCallback	equ	$3B9C
SendMainCommand3D	equ	$3F24
X_DEC	equ	$DEC
X_14D2	equ	$14D2
X_1D54	equ	$1D54
X_23D0	equ	$23D0
X_7CF4	equ	$7CF4
X_82A4	equ	$82A4

	org	$0

PlayerOverlayEntry
	dc.w	$08B9
	dc.w	$0005
	dc.w	$00FF
	dc.w	$800F
	dc.w	$2C7C
	dc.w	$0000
	dc.w	$AE6E
	dc.w	$9DFC
	ori.b	#$0,d0
	lea	PlayerOverlayEntry(pc,a6.l),sp
	move.l	a6,-(sp)
	movea.l	#$A594,a6
	lea	PlayerOverlayEntry(pc,a6.l),a6
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	InstallPlayerFrameCallback
	lea	ServicePlayerDisplay(pc),a0
	move.l	a0,$D2(a6)
	move.w	d0,$7C(a6)
	move.w	d1,$7E(a6)
	move.w	d2,$BC(a6)
	bsr.w	SendMainCommand3D
	move.w	#$6,d7
	jsr	$6044.w
	move.l	a0,$DA(a6)
	dc.b	'$H0<@&"|'
	dc.w	$000A
	dc.w	$FF60
	move.l	(a1)+,(a2)+
	dc.w	$51C8
	dc.w	$FFFC
	movea.l	$DA(a6),a0
	adda.l	#$100A0,a0
	move.l	a0,$8E(a6)
	adda.l	#$100,a0
	move.l	a0,$92(a6)
	adda.l	#$280,a0
	move.l	a0,$8A(a6)
	adda.l	#$1F80,a0
	move.w	#$2,d7
	jsr	$6044.w
	clr.w	$C6(a6)
	clr.w	$C8(a6)
	clr.w	$C2(a6)
	clr.w	$DE(a6)
	clr.w	$F6(a6)
	clr.w	$F2(a6)
	move.w	#$2,$F8(a6)
	clr.w	$80(a6)
	move.w	#$0,$56(a6)
	move.w	#$7,$5E(a6)
	move.w	#$FF90,$5C(a6)
	move.w	$7C(a6),d0
	move.w	$7E(a6),d1
	andi.l	#$FFFF,d0
	andi.l	#$FFFF,d1
	addi.l	#$44,d0
	addi.l	#$44,d1
	movea.l	d0,a2
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	a2,d0
	jsr	$6044.w
	move.l	a0,$FE(a6)
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	$FE(a6),a0
	movea.l	d0,a2
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	a2,d0
	jsr	$6044.w
	move.l	a0,$FE(a6)
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	$FE(a6),a0
	move.l	a0,d2
	move.l	(a0),$4(a6)
	add.l	d2,$4(a6)
	move.l	$4(a0),$0(a6)
	add.l	d2,$0(a6)
	move.l	$8(a0),$8(a6)
	add.l	d2,$8(a6)
	movea.l	d1,a2
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	a2,d0
	jsr	$6044.w
	move.l	a0,$FE(a6)
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	$FE(a6),a0
	move.l	a0,d2
	move.l	(a0),$10(a6)
	add.l	d2,$10(a6)
	move.l	$4(a0),$C(a6)
	add.l	d2,$C(a6)
	move.l	$8(a0),$14(a6)
	add.l	d2,$14(a6)
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$40,d0
	jsr	$6044.w
	move.l	a0,$70(a6)
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$22,d0
	jsr	$6044.w
	move.l	a0,$86(a6)
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	$86(a6),a2
	move.l	a2,d2
	moveq	#$1B,d0
.L1AE
	add.l	d2,(a2)+
	dbf	d0,.L1AE
	move.w	#$6,d7
	jsr	$6044.w
	move.l	a0,$A2(a6)
	bsr.w	FetchTeamPhotoAndStatTables
	bset.b	#$5,$FF800F.l
	movea.l	#$BBCB0,a0
	moveq	#$1F,d0
.L1D4
	clr.l	(a0)+
	dbf	d0,.L1D4
	move.w	#$18,$EC(a6)
.L1E0
	tst.w	$EC(a6)
	bpl.w	.L1E0
.L1E8
	btst.b	#$7,$FF800E.l
	bne.s	.L1E8
	move.w	#$20,$FF8020.l
	bset.b	#$6,$FF800F.l
.L202
	btst.b	#$6,$FF800E.l
	beq.s	.L202
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L21C
	btst.b	#$6,$FF800E.l
	bne.s	.L21C
	bclr.b	#$7,$FF800F.l
.L22E
	btst.b	#$7,$FF800E.l
	bne.s	.L22E
	move.w	#$8164,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L250
	btst.b	#$6,$FF800E.l
	beq.s	.L250
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L26A
	btst.b	#$6,$FF800E.l
	bne.s	.L26A
	bclr.b	#$7,$FF800F.l
.L27C
	btst.b	#$7,$FF800E.l
	bne.s	.L27C
	move.w	#$8C81,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L29E
	btst.b	#$6,$FF800E.l
	beq.s	.L29E
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2B8
	btst.b	#$6,$FF800E.l
	bne.s	.L2B8
	bclr.b	#$7,$FF800F.l
.L2CA
	btst.b	#$7,$FF800E.l
	bne.s	.L2CA
	move.w	#$9003,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2EC
	btst.b	#$6,$FF800E.l
	beq.s	.L2EC
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L306
	btst.b	#$6,$FF800E.l
	bne.s	.L306
	bclr.b	#$7,$FF800F.l
.L318
	btst.b	#$7,$FF800E.l
	bne.s	.L318
	move.w	#$8200,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L33A
	btst.b	#$6,$FF800E.l
	beq.s	.L33A
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L354
	btst.b	#$6,$FF800E.l
	bne.s	.L354
	bclr.b	#$7,$FF800F.l
.L366
	btst.b	#$7,$FF800E.l
	bne.s	.L366
	move.w	#$8401,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L388
	btst.b	#$6,$FF800E.l
	beq.s	.L388
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3A2
	btst.b	#$6,$FF800E.l
	bne.s	.L3A2
	bclr.b	#$7,$FF800F.l
.L3B4
	btst.b	#$7,$FF800E.l
	bne.s	.L3B4
	move.w	#$8574,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3D6
	btst.b	#$6,$FF800E.l
	beq.s	.L3D6
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3F0
	btst.b	#$6,$FF800E.l
	bne.s	.L3F0
	bclr.b	#$7,$FF800F.l
.L402
	btst.b	#$7,$FF800E.l
	bne.s	.L402
	move.w	#$8D3C,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L424
	btst.b	#$6,$FF800E.l
	beq.s	.L424
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L43E
	btst.b	#$6,$FF800E.l
	bne.s	.L43E
	bclr.b	#$7,$FF800F.l
.L450
	btst.b	#$7,$FF800E.l
	bne.s	.L450
	move.w	#$832C,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L472
	btst.b	#$6,$FF800E.l
	beq.s	.L472
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L48C
	btst.b	#$6,$FF800E.l
	bne.s	.L48C
	bclr.b	#$7,$FF800F.l
.L49E
	btst.b	#$7,$FF800E.l
	bne.s	.L49E
	move.w	#$9100,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L4C0
	btst.b	#$6,$FF800E.l
	beq.s	.L4C0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L4DA
	btst.b	#$6,$FF800E.l
	bne.s	.L4DA
	bclr.b	#$7,$FF800F.l
.L4EC
	btst.b	#$7,$FF800E.l
	bne.s	.L4EC
	move.w	#$9200,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L50E
	btst.b	#$6,$FF800E.l
	beq.s	.L50E
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L528
	btst.b	#$6,$FF800E.l
	bne.s	.L528
	bclr.b	#$7,$FF800F.l
.L53A
	btst.b	#$7,$FF800E.l
	bne.s	.L53A
	move.w	#$8F02,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L55C
	btst.b	#$6,$FF800E.l
	beq.s	.L55C
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L576
	btst.b	#$6,$FF800E.l
	bne.s	.L576
	bclr.b	#$7,$FF800F.l
.L588
	btst.b	#$7,$FF800E.l
	bne.s	.L588
	move.w	#$8B00,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L5AA
	btst.b	#$6,$FF800E.l
	beq.s	.L5AA
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L5C4
	btst.b	#$6,$FF800E.l
	bne.s	.L5C4
	bclr.b	#$7,$FF800F.l
.L5D6
	btst.b	#$7,$FF800E.l
	bne.s	.L5D6
	move.l	#$70000003,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L5FA
	btst.b	#$6,$FF800E.l
	beq.s	.L5FA
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L614
	btst.b	#$6,$FF800E.l
	bne.s	.L614
	bclr.b	#$7,$FF800F.l
.L626
	btst.b	#$7,$FF800E.l
	bne.s	.L626
	move.l	#$0,$FF8022.l
	move.w	#$E,$FF8020.l
	bset.b	#$6,$FF800F.l
.L64A
	btst.b	#$6,$FF800E.l
	beq.s	.L64A
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L664
	btst.b	#$6,$FF800E.l
	bne.s	.L664
	bclr.b	#$7,$FF800F.l
.L676
	btst.b	#$7,$FF800E.l
	bne.s	.L676
	move.l	#$40000010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L69A
	btst.b	#$6,$FF800E.l
	beq.s	.L69A
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L6B4
	btst.b	#$6,$FF800E.l
	bne.s	.L6B4
	bclr.b	#$7,$FF800F.l
.L6C6
	btst.b	#$7,$FF800E.l
	bne.s	.L6C6
	move.l	#$0,$FF8022.l
	move.w	#$E,$FF8020.l
	bset.b	#$6,$FF800F.l
.L6EA
	btst.b	#$6,$FF800E.l
	beq.s	.L6EA
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L704
	btst.b	#$6,$FF800E.l
	bne.s	.L704
	bclr.b	#$7,$FF800F.l
.L716
	btst.b	#$7,$FF800E.l
	bne.s	.L716
	move.l	#$68000003,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L73A
	btst.b	#$6,$FF800E.l
	beq.s	.L73A
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L754
	btst.b	#$6,$FF800E.l
	bne.s	.L754
	bclr.b	#$7,$FF800F.l
.L766
	btst.b	#$7,$FF800E.l
	bne.s	.L766
	move.l	#$0,$FF8022.l
	move.w	#$E,$FF8020.l
	bset.b	#$6,$FF800F.l
.L78A
	btst.b	#$6,$FF800E.l
	beq.s	.L78A
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L7A4
	btst.b	#$6,$FF800E.l
	bne.s	.L7A4
	bclr.b	#$7,$FF800F.l
	move.l	#$7A0,$62(a6)
	move.l	#$1000,d0
	bsr.w	FillVram
	move.l	#$20001000,d0
	bsr.w	FillVram
	move.l	#$B0000700,d0
	bsr.w	FillVram
	move.w	#$7000,$FC(a6)
	lea	IncrementPaletteTick(pc),a0
	move.l	a0,$D2(a6)
	move.w	#$0,$EC(a6)
.L7F0
	tst.w	$EC(a6)
	beq.s	.L7F0
	lea	ServicePlayerDisplay(pc),a0
	move.l	a0,$D2(a6)
	moveq	#$0,d6
	moveq	#$0,d4
	move.w	#$2000,$EE(a6)
	move.w	#$0,$18(a6)
	movea.l	$70(a6),a1
	move.w	$2(a1),d0
	lea	$4(a1),a1
	lsl.w	#$4,d0
	move.w	d0,$E0(a6)
	move.w	#$F400,$E2(a6)
	movea.l	#$BC000,a2
	move.l	a2,$E4(a6)
	subq.w	#$1,d0
.L832
	move.w	(a1)+,(a2)+
	dbf	d0,.L832
	move.w	#$1,$DE(a6)
.L83E
	tst.w	$DE(a6)
	bne.w	.L83E
	lea	X_82A4(pc),a1
	move.l	a1,$74(a6)
	movea.l	$74(a6),a1
	move.w	$2(a1),d0
	lea	$4(a1),a1
	lsl.w	#$4,d0
	move.w	d0,$E0(a6)
	move.w	#$A000,$E2(a6)
	movea.l	#$BC000,a2
	move.l	a2,$E4(a6)
	subq.w	#$1,d0
.L872
	move.w	(a1)+,(a2)+
	dbf	d0,.L872
	move.w	#$1,$DE(a6)
.L87E
	tst.w	$DE(a6)
	bne.w	.L87E
	adda.l	#$4,a1
	move.l	a1,$78(a6)
	bsr.w	X_1D54
	move.w	d4,d0
	bsr.w	DrawSelectedTeamPageBackground
	bsr.w	DrawPlayerNumberAndPosition
	move.w	#$18,$EC(a6)
.L8A4
	tst.w	$EC(a6)
	bpl.w	.L8A4
	bsr.w	X_DEC
	move.w	#$7,$BA(a6)
.L8B6
	move.l	#$B0000700,d0
	bsr.w	FillVram
	move.w	d4,d7
	bsr.w	ReadJoy1
	move.b	d0,$BE(a6)
	move.b	d1,$BF(a6)
	move.b	d2,$C0(a6)
	move.b	d3,$C1(a6)
	move.w	d1,d5
	bsr.w	ReadJoy2
	or.w	d1,d5
	or.b	d0,$BE(a6)
	or.b	d1,$BF(a6)
	or.b	d2,$C0(a6)
	or.b	d3,$C1(a6)
.L8EE
	cmpi.b	#$80,d5
	beq.w	.LC4E
	cmpi.b	#$28,$C1(a6)
	bne.w	.L968
	cmpi.w	#$1,d4
	beq.w	.L934
	cmpi.w	#$0,d4
	bne.w	.L968
	cmpi.w	#$0,$5A(a6)
	ble.w	.L8B6
	subi.w	#$1,$5A(a6)
	move.w	#$4,$B0(a6)
	bsr.w	X_1D54
	moveq	#$7,d0
	bsr.w	WaitDisplayFrames
	bra.w	.L8B6
.L934
	cmpi.w	#$0,$54(a6)
	beq.w	.L8B6
	cmpi.w	#$0,$58(a6)
	ble.w	.L8B6
	subi.w	#$1,$58(a6)
	move.w	#$4,$B0(a6)
	bsr.w	X_23D0
	move.b	#$0,$C1(a6)
	moveq	#$7,d0
	bsr.w	WaitDisplayFrames
	bra.w	.L8B6
.L968
	cmpi.b	#$24,$C1(a6)
	bne.w	.L9DC
	cmpi.w	#$1,d4
	beq.w	.L9A6
	cmpi.w	#$0,d4
	bne.w	.L9DC
	cmpi.w	#$FFFF,$58(a6)
	beq.w	.L8B6
	addi.w	#$1,$5A(a6)
	move.w	#$3,$B0(a6)
	bsr.w	X_1D54
	moveq	#$7,d0
	bsr.w	WaitDisplayFrames
	bra.w	.L8B6
.L9A6
	cmpi.w	#$0,$54(a6)
	beq.w	.L8B6
	move.w	$58(a6),d0
	cmp.w	$BA(a6),d0
	bgt.w	.L8B6
	addi.w	#$1,$58(a6)
	move.w	#$3,$B0(a6)
	bsr.w	X_23D0
	move.b	#$0,$C1(a6)
	moveq	#$7,d0
	bsr.w	WaitDisplayFrames
	bra.w	.L8B6
.L9DC
	cmpi.b	#$8,d5
	bne.w	.LA0E
	move.w	#$0,$F8(a6)
	subq.w	#$1,d4
	moveq	#$1,d6
	move.w	$EE(a6),d0
	move.w	d0,$F0(a6)
	addi.w	#$50,d0
	cmpi.w	#$2100,d0
	blt.w	.LA06
	subi.w	#$100,d0
.LA06
	move.w	d0,$EE(a6)
	bra.w	.LB9E
.LA0E
	cmpi.b	#$4,d5
	bne.w	.LA40
	move.w	#$1,$F8(a6)
	addq.w	#$1,d4
	moveq	#$1,d6
	move.w	$EE(a6),d0
	move.w	d0,$F0(a6)
	subi.w	#$50,d0
	cmpi.w	#$2000,d0
	bge.w	.LA38
	addi.w	#$100,d0
.LA38
	move.w	d0,$EE(a6)
	bra.w	.LB9E
.LA40
	cmpi.b	#$40,d5
	bne.w	.LA82
	move.w	$18(a6),d0
	eori.w	#$1,d0
	move.w	d0,$18(a6)
	moveq	#$1,d6
	move.w	#$2,$F8(a6)
	clr.w	$80(a6)
	move.w	#$0,$54(a6)
	move.w	#$0,$56(a6)
	move.w	#$0,$58(a6)
	move.w	#$0,$5A(a6)
	move.w	#$0,$B0(a6)
	bra.w	.LBC4
.LA82
	cmpi.b	#$10,d5
	bne.w	.LAEE
	cmpi.w	#$0,d4
	beq.w	.LABC
	cmpi.w	#$1,d4
	bne.w	.LAEE
	move.w	#$0,$54(a6)
	clr.w	$56(a6)
	clr.w	$58(a6)
	move.w	#$0,$B0(a6)
	bsr.w	X_23D0
	moveq	#$7,d0
	bsr.w	WaitDisplayFrames
	bra.w	.LBC4
.LABC
	addi.w	#$1,$80(a6)
	addi.b	#$1,$104(a6)
	addi.b	#$1,$105(a6)
	move.w	#$0,$56(a6)
	move.w	#$0,$5A(a6)
	move.w	#$0,$B0(a6)
	bsr.w	X_1D54
	moveq	#$7,d0
	bsr.w	WaitDisplayFrames
	bra.w	.LBC4
.LAEE
	cmpi.b	#$1,d5
	bne.w	.LB38
	cmpi.w	#$0,d4
	bne.w	.LB12
	addi.w	#$1,$56(a6)
	move.w	#$1,$B0(a6)
	bsr.w	X_1D54
	bra.w	.L8B6
.LB12
	cmpi.w	#$1,d4
	bne.w	.LB38
	cmpi.w	#$1,$54(a6)
	bne.w	.LB38
	addi.w	#$1,$56(a6)
	move.w	#$1,$B0(a6)
	bsr.w	X_23D0
	bra.w	.L8B6
.LB38
	cmpi.b	#$2,d5
	bne.w	.L8B6
	cmpi.w	#$0,d4
	bne.w	.LB6E
	subi.w	#$1,$56(a6)
	cmpi.w	#$0,$56(a6)
	bge.w	.LB60
	clr.w	$56(a6)
	bra.w	.L8B6
.LB60
	move.w	#$2,$B0(a6)
	bsr.w	X_1D54
	bra.w	.L8B6
.LB6E
	cmpi.w	#$1,d4
	bne.w	.L8B6
	cmpi.w	#$1,$54(a6)
	bne.w	.L8B6
	cmpi.w	#$1,$56(a6)
	blt.w	.L8B6
	subi.w	#$1,$56(a6)
	move.w	#$2,$B0(a6)
	bsr.w	X_23D0
	bra.w	.L8B6
.LB9E
	cmpi.w	#$0,d4
	bge.w	.LBB2
	moveq	#$0,d4
	moveq	#$0,d6
	move.w	$F0(a6),$EE(a6)
	bra.s	.LBC4
.LBB2
	cmpi.w	#$2,d4
	ble.w	.LBC4
	moveq	#$2,d4
	moveq	#$0,d6
	move.w	$F0(a6),$EE(a6)
.LBC4
	tst.w	d6
	beq.w	.L8B6
	move.l	d4,d0
	clr.w	$56(a6)
	clr.w	$58(a6)
	bsr.w	DrawSelectedTeamPageBackground
	move.w	#$64,$EC(a6)
.LBDE
	tst.w	$EC(a6)
	bpl.w	.LBDE
	cmpi.w	#$1,d7
	bne.w	.LC02
	cmpi.w	#$1,$54(a6)
	bne.w	.LC02
	cmpi.w	#$2,$F8(a6)
	beq.w	.LC02
.LC02
	cmpi.w	#$0,d4
	bne.w	.LC0E
	bsr.w	X_1D54
.LC0E
	cmpi.w	#$1,d4
	bne.w	.LC1A
	bsr.w	X_23D0
.LC1A
	cmpi.w	#$2,$F8(a6)
	beq.w	.LC38
	move.w	#$140,$F4(a6)
	move.w	#$1,$FA(a6)
.LC30
	tst.w	$FA(a6)
	bne.w	.LC30
.LC38
	moveq	#$0,d6
	cmpi.w	#$2,d4
	bne.w	.L8B6
	bsr.w	X_14D2
	move.w	$AE(a6),d5
	bra.w	.L8EE
.LC4E
	movea.l	#$BBCB0,a0
	moveq	#$1F,d0
.LC56
	clr.l	(a0)+
	dbf	d0,.LC56
	move.w	#$18,$EC(a6)
.LC62
	tst.w	$EC(a6)
	bpl.w	.LC62
	bsr.w	SendMainCommand3D
	bclr.b	#$5,$FF800F.l
	move.l	#$3FFF,d0
	movea.l	$DA(a6),a1
	movea.l	#$AFF60,a2
.LC86
	move.l	(a1)+,(a2)+
	dbf	d0,.LC86
	move.l	#$13,d0
.LC92
	move.l	(a1)+,(a2)+
	dbf	d0,.LC92
	bsr.w	RestorePlayerFrameCallback
	movem.l	(sp)+,d0-d7/a0-a6
	movea.l	(sp)+,a6
	move.w	#$4,d7
	jsr	$6044.w
FetchTeamPhotoAndStatTables
	move.l	#$6,d0
	move.l	d0,d1
	add.w	$7C(a6),d0
	add.w	$7E(a6),d1
	lea	PlayerOverlayEntry(pc),a1
	movea.l	d0,a2
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	a2,d0
	jsr	$6044.w
	move.l	a0,$1C(a6)
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	$1C(a6),a2
	move.l	a2,d2
.LCDC
	add.l	d2,(a2)+
	tst.w	(a2)
	bpl.w	.LCDC
	lea	$24(a6),a3
	lea	-$10(a2),a4
	move.l	(a4)+,(a3)+
	move.l	(a4)+,(a3)+
	move.l	(a4)+,(a3)+
	move.l	(a4)+,(a3)+
	lea	$2(a2),a2
	move.l	a2,$48(a6)
	movea.l	d1,a2
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	a2,d0
	jsr	$6044.w
	move.l	a0,$20(a6)
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	$20(a6),a2
	move.l	a2,d2
.LD1A
	add.l	d2,(a2)+
	tst.w	(a2)
	bpl.w	.LD1A
	lea	$34(a6),a3
	lea	-$10(a2),a4
	move.l	(a4)+,(a3)+
	move.l	(a4)+,(a3)+
	move.l	(a4)+,(a3)+
	move.l	(a4)+,(a3)+
	lea	$2(a2),a2
	move.l	a2,$4C(a6)
	movea.l	$2C(a6),a0
	cmpi.l	#$12345678,(a0)
	bne.w	.LD50
	move.l	#$0,$2C(a6)
.LD50
	movea.l	$30(a6),a0
	cmpi.l	#$12345678,(a0)
	bne.w	.LD66
	move.l	#$0,$30(a6)
.LD66
	movea.l	$3C(a6),a0
	cmpi.l	#$12345678,(a0)
	bne.w	.LD7C
	move.l	#$0,$3C(a6)
.LD7C
	movea.l	$40(a6),a0
	cmpi.l	#$12345678,(a0)
	bne.w	.LD92
	move.l	#$0,$40(a6)
.LD92
	movea.l	$24(a6),a0
	cmpi.l	#$12345678,(a0)
	bne.w	.LDA8
	move.l	#$0,$24(a6)
.LDA8
	movea.l	$34(a6),a0
	cmpi.l	#$12345678,(a0)
	bne.w	.LDBE
	move.l	#$0,$34(a6)
.LDBE
	movea.l	$28(a6),a0
	cmpi.l	#$12345678,(a0)
	bne.w	.LDD4
	move.l	#$0,$28(a6)
.LDD4
	movea.l	$38(a6),a0
	cmpi.l	#$12345678,(a0)
	bne.w	.LDEA
	move.l	#$0,$38(a6)
.LDEA
	rts
	movem.l	d0-d7/a1-a2,-(sp)
	move.w	#$50,d0
	move.l	#$B0000080,d1
	move.w	$EE(a6),d2
	subi.w	#$2000,d2
	swap	d2
	move.w	#$100,d2
	move.w	#$13,d3
	bsr.w	CopyVramRows
	moveq	#$14,d0
	moveq	#$0,d1
	bsr.w	SetWindowPosition
	moveq	#$0,d0
	movea.l	#$91EC,a1
	suba.l	#$0,a1
	lea	PlayerOverlayEntry(pc),a2
	adda.l	a2,a1
	move.w	$2(a1),d0
	lea	$4(a1),a1
	lsl.w	#$4,d0
	move.w	$FC(a6),d1
	eori.w	#$3000,d1
	move.w	d1,$E2(a6)
	move.w	d0,$E0(a6)
	move.l	a1,$E4(a6)
	move.w	#$1,$DE(a6)
.LE50
	tst.w	$DE(a6)
	bne.w	.LE50
	add.w	d0,d0
	lea	(a1,d0.w),a1
	move.w	#$0,$B2(a6)
	move.w	d1,d5
	lsr.w	#$5,d5
	move.l	#$B296,d3
	move.l	#$80,d6
	bsr.w	DrawTileMap
	clr.l	$96(a6)
.LE7C
	bsr.w	ReadJoy1
	tst.w	d1
	bne.w	.LE9C
	bsr.w	ReadJoy2
	tst.w	d1
	bne.w	.LE9C
	cmpi.l	#$258,$96(a6)
	ble.w	.LE7C
.LE9C
	moveq	#$0,d0
	moveq	#$0,d1
	bsr.w	SetWindowPosition
	movem.l	(sp)+,d0-d7/a1-a2
	rts
WaitDisplayFrames
	clr.w	$102(a6)
.LEAE
	tst.w	$102(a6)
	beq.w	.LEAE
	dbf	d0,WaitDisplayFrames
	rts
ClearVerticalScroll
	movem.l	d0-d2,-(sp)
.LEC0
	btst.b	#$7,$FF800E.l
	bne.s	.LEC0
	move.l	#$40000010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.LEE4
	btst.b	#$6,$FF800E.l
	beq.s	.LEE4
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.LEFE
	btst.b	#$6,$FF800E.l
	bne.s	.LEFE
	bclr.b	#$7,$FF800F.l
.LF10
	btst.b	#$7,$FF800E.l
	bne.s	.LF10
	move.w	#$0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.LF32
	btst.b	#$6,$FF800E.l
	beq.s	.LF32
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.LF4C
	btst.b	#$6,$FF800E.l
	bne.s	.LF4C
	bclr.b	#$7,$FF800F.l
	movem.l	(sp)+,d0-d2
	rts
SetWindowPosition
	addi.w	#$9200,d0
.LF68
	btst.b	#$7,$FF800E.l
	bne.s	.LF68
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.LF88
	btst.b	#$6,$FF800E.l
	beq.s	.LF88
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.LFA2
	btst.b	#$6,$FF800E.l
	bne.s	.LFA2
	bclr.b	#$7,$FF800F.l
	addi.w	#$9100,d1
.LFB8
	btst.b	#$7,$FF800E.l
	bne.s	.LFB8
	move.w	d1,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.LFD8
	btst.b	#$6,$FF800E.l
	beq.s	.LFD8
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.LFF2
	btst.b	#$6,$FF800E.l
	bne.s	.LFF2
	bclr.b	#$7,$FF800F.l
	rts
ClearStatTextTileRectangle
	movem.l	d0-d6,-(sp)
	moveq	#$0,d2
	move.w	d0,d1
	swap	d0
	move.w	#$7A0,d3
	bset	#$E,d3
	moveq	#$9,d4
	move.w	d4,d5
	moveq	#$A,d6
.L101E
	moveq	#$0,d2
	move.w	d0,d2
	lsl.l	#$2,d2
	lsr.w	#$2,d2
	swap	d2
	addi.l	#$40000000,d2
.L102E
	btst.b	#$7,$FF800E.l
	bne.s	.L102E
	move.l	d2,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L104E
	btst.b	#$6,$FF800E.l
	beq.s	.L104E
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L1068
	btst.b	#$6,$FF800E.l
	bne.s	.L1068
	bclr.b	#$7,$FF800F.l
.L107A
	btst.b	#$7,$FF800E.l
	bne.s	.L107A
	move.w	d3,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L109A
	btst.b	#$6,$FF800E.l
	beq.s	.L109A
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L10B4
	btst.b	#$6,$FF800E.l
	bne.s	.L10B4
	bclr.b	#$7,$FF800F.l
	dbf	d4,.L107A
	move.w	d5,d4
	add.w	d1,d0
	dbf	d6,.L101E
	movem.l	(sp)+,d0-d6
	rts
AnimateStatDisplayTransition
	movem.l	d0-d7/a0-a4,-(sp)
	move.w	$F2(a6),d2
	moveq	#$4,d3
	move.w	#$0,$E2(a6)
	move.w	#$1,$E0(a6)
	cmpi.w	#$1,d0
	beq.w	.L11C0
	cmpi.w	#$2,d0
	beq.w	.L11BA
	cmpi.w	#$4,d0
	beq.w	.L1108
	neg.w	d3
.L1108
	bsr.w	UploadStatTextTiles
	move.w	#$E8,d7
	cmpi.w	#$8,$B8(a6)
	beq.w	.L111E
	move.w	#$F0,d7
.L111E
	move.w	d7,d0
	bsr.w	MoveStatTextSpritesY
	move.w	$EE(a6),d0
	subi.w	#$2000,d0
	addi.w	#$CF8,d0
	swap	d0
	move.w	#$100,d0
	bsr.w	ClearStatTextTileRectangle
	move.w	$EE(a6),d0
	subi.w	#$2000,d0
	addi.w	#$D50,d0
	swap	d0
	move.w	#$100,d0
	bsr.w	ClearStatTextTileRectangle
	move.w	d2,$E2(a6)
	move.w	d3,$E0(a6)
	moveq	#$9,d0
.L115A
	move.w	#$9,$DE(a6)
.L1160
	tst.w	$DE(a6)
	bne.w	.L1160
	dbf	d0,.L115A
	moveq	#$1C,d0
	moveq	#$0,d1
	bsr.w	SetWindowPosition
	neg.w	d7
	move.w	d7,d0
	bsr.w	MoveStatTextSpritesY
	move.w	#$50,d0
	move.w	$EE(a6),d1
	subi.w	#$2000,d1
	swap	d1
	move.w	#$100,d1
	move.l	#$B0000080,d2
	move.w	#$1B,d3
	bsr.w	CopyVramRows
	move.w	$F2(a6),$E2(a6)
	move.w	#$0,$E0(a6)
	move.w	#$9,$DE(a6)
.L11AE
	tst.w	$DE(a6)
	bne.w	.L11AE
	bra.w	.L11D4
.L11BA
	move.w	#$FFFF,$E0(a6)
.L11C0
	moveq	#$7,d1
.L11C2
	move.w	#$7,$DE(a6)
.L11C8
	tst.w	$DE(a6)
	bne.w	.L11C8
	dbf	d1,.L11C2
.L11D4
	movem.l	(sp)+,d0-d7/a0-a4
	rts
InitStatTextSprites
	movem.l	d0-d7/a0-a1,-(sp)
	movea.l	$8A(a6),a0
	move.l	#$7DF,d0
	dc.b	'"<3333'
.L11EE
	move.l	d1,(a0)+
	dbf	d0,.L11EE
	movea.l	$92(a6),a1
	move.w	#$600,d0
	bset	#$E,d0
	bset	#$F,d0
	moveq	#$1,d2
	moveq	#$0,d3
	move.b	$B6(a6),d3
	subq.w	#$1,d3
	move.w	d3,d4
	move.w	$B8(a6),d5
	subq.w	#$1,d5
	moveq	#$0,d6
	move.l	#$88,d7
.L121E
	move.w	d6,$0(a1)
	move.w	d7,$6(a1)
	move.b	#$C,$2(a1)
	move.b	d2,$3(a1)
	move.w	d0,$4(a1)
	addq.b	#$1,d2
	addi.w	#$4,d0
	addi.w	#$20,d7
	lea	$8(a1),a1
	dbf	d3,.L121E
	move.w	d4,d3
	addi.w	#$8,d6
	move.l	#$88,d7
	dbf	d5,.L121E
	move.b	#$0,-$5(a1)
	movem.l	(sp)+,d0-d7/a0-a1
	rts
MoveStatTextSpritesY
	movem.l	d1/a1,-(sp)
	movea.l	$92(a6),a1
	move.w	#$140,$E0(a6)
	move.w	#$E800,$E2(a6)
	move.l	a1,$E4(a6)
	moveq	#$4F,d1
.L127C
	add.w	d0,$0(a1)
	lea	$8(a1),a1
	dbf	d1,.L127C
	move.w	#$1,$DE(a6)
.L128E
	tst.w	$DE(a6)
	bne.w	.L128E
	movem.l	(sp)+,d1/a1
	rts
RenderTwoStatStringsToTiles
	movem.l	d0-d4/a0-a4,-(sp)
	movea.l	$70(a6),a0
	lea	$4(a0),a0
	movea.l	$8A(a6),a1
	moveq	#$0,d0
	move.b	$B6(a6),d0
	lsl.l	#$7,d0
	move.l	d0,d1
	mulu.w	$B4(a6),d0
	lea	(a1,d0.l),a3
	move.l	d1,d0
	movea.l	a3,a1
	move.l	d1,d2
	lsr.l	#$2,d2
	subq.l	#$1,d2
	dc.b	'"<3333('
	dc.b	$01
.L12D0
	move.l	d1,(a1)+
	dbf	d2,.L12D0
	movea.l	a3,a1
	moveq	#$1,d3
.L12DA
	moveq	#$0,d1
	move.b	(a4)+,d1
	beq.w	.L1320
	subi.b	#$20,d1
	lsl.w	#$5,d1
	lea	(a0,d1.w),a2
	move.l	(a2)+,d1
	eor.l	d4,d1
	move.l	d1,(a1)+
	move.l	(a2)+,d1
	eor.l	d4,d1
	move.l	d1,(a1)+
	move.l	(a2)+,d1
	eor.l	d4,d1
	move.l	d1,(a1)+
	move.l	(a2)+,d1
	eor.l	d4,d1
	move.l	d1,(a1)+
	move.l	(a2)+,d1
	eor.l	d4,d1
	move.l	d1,(a1)+
	move.l	(a2)+,d1
	eor.l	d4,d1
	move.l	d1,(a1)+
	move.l	(a2)+,d1
	eor.l	d4,d1
	move.l	d1,(a1)+
	move.l	(a2)+,d1
	eor.l	d4,d1
	move.l	d1,(a1)+
	bra.w	.L12DA
.L1320
	adda.l	#$20,a1
	dbf	d3,.L12DA
	addi.w	#$1,$B4(a6)
	movem.l	(sp)+,d0-d4/a0-a4
	rts
UploadStatTextTiles
	movem.l	d0/a0-a1,-(sp)
	movea.l	$8A(a6),a0
	move.w	#$7DF,d0
	movea.l	#$BC000,a1
.L1348
	move.l	(a0)+,(a1)+
	dbf	d0,.L1348
	move.l	#$BC000,$E4(a6)
	move.w	#$FC0,$E0(a6)
	move.w	#$C000,$E2(a6)
	move.w	#$1,$DE(a6)
.L1368
	tst.w	$DE(a6)
	bne.w	.L1368
	movem.l	(sp)+,d0/a0-a1
	rts
DrawSelectedTeamPageBackground
	movem.l	d0-d7/a0-a2,-(sp)
	lea	$0(a6),a0
	lsl.w	#$2,d0
	cmpi.w	#$0,$18(a6)
	beq.w	.L138E
	lea	$C(a6),a0
.L138E
	adda.w	d0,a0
	movea.l	(a0),a0
	lsr.w	#$2,d0
	movea.l	a0,a1
	moveq	#$0,d2
	moveq	#$0,d1
	move.w	$2(a1),d2
	lea	$4(a1),a1
	move.w	$FC(a6),d5
	eori.w	#$3000,d5
	move.w	d5,$FC(a6)
	lsl.w	#$4,d2
	move.w	d2,$E0(a6)
	move.w	d5,$E2(a6)
	movea.l	#$BC000,a2
	move.l	a2,$E4(a6)
	subq.w	#$1,d2
.L13C4
	move.w	(a1)+,(a2)+
	dbf	d2,.L13C4
	move.w	#$1,$DE(a6)
.L13D0
	tst.w	$DE(a6)
	bne.w	.L13D0
	lsr.w	#$5,d5
	cmpi.w	#$0,d0
	beq.w	.L1422
	cmpi.w	#$1,d0
	beq.w	.L1406
	move.w	#$1,$B2(a6)
	movea.l	#$BBD10,a2
	moveq	#$7,d2
.L13F8
	move.l	(a1)+,(a2)+
	dbf	d2,.L13F8
	lea	$60(a1),a1
	bra.w	.L1448
.L1406
	move.w	#$0,$B2(a6)
	movea.l	#$BBCB0,a2
	moveq	#$F,d2
.L1414
	move.l	(a1)+,(a2)+
	dbf	d2,.L1414
	lea	$40(a1),a1
	bra.w	.L1448
.L1422
	move.w	#$1,$B2(a6)
	movea.l	#$BBD10,a2
	moveq	#$7,d2
.L1430
	move.l	(a1)+,(a2)+
	dbf	d2,.L1430
	movea.l	#$BBCD0,a2
	moveq	#$7,d2
.L143E
	move.l	(a1)+,(a2)+
	dbf	d2,.L143E
	lea	$40(a1),a1
.L1448
	move.l	#$EEE,$BBCF0.l
	move.l	#$EEE0444,$BBCF4.l
	move.w	#$2C,$BBD0A.l
	move.w	#$444,$BBCB0.l
	move.w	#$444,$BBCD0.l
	move.w	#$444,$BBCF0.l
	move.w	#$444,$BBD10.l
	cmpi.w	#$2,$F8(a6)
	bne.w	.L14AA
	movea.l	a1,a2
	movem.l	d2,-(sp)
	move.w	$EE(a6),d3
	move.l	#$100,d6
	bsr.w	DrawTileMap
	movem.l	(sp)+,d2
	bra.w	.L14CA
.L14AA
	move.w	#$64,$EC(a6)
.L14B0
	tst.w	$EC(a6)
	bpl.w	.L14B0
	moveq	#$0,d3
	move.w	$EE(a6),d3
	move.l	#$100,d6
	movea.l	a1,a2
	bsr.w	DrawTileMap
.L14CA
	movem.l	(sp)+,d0-d7/a0-a2
	rts
.L14D0
	rts
	movem.l	d0-d7/a0-a4,-(sp)
	movea.l	$8(a6),a0
	cmpi.w	#$0,$18(a6)
	beq.w	.L14E8
	movea.l	$14(a6),a0
.L14E8
	moveq	#$0,d0
	move.w	$2(a0),d0
	lsl.w	#$5,d0
	lea	(a0,d0.w),a2
	adda.l	#$84,a2
	move.w	$FC(a6),d5
	lsr.w	#$5,d5
	ori.w	#$8000,d5
	move.w	#$1,$B2(a6)
	move.w	#$B000,d3
	move.l	#$80,d6
	movea.l	a2,a1
	bsr.w	DrawTileMap
.L151A
	btst.b	#$7,$FF800E.l
	bne.s	.L151A
	move.w	#$921C,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L153C
	btst.b	#$6,$FF800E.l
	beq.s	.L153C
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L1556
	btst.b	#$6,$FF800E.l
	bne.s	.L1556
	bclr.b	#$7,$FF800F.l
	cmpi.w	#$4000,$FC(a6)
	beq.w	.L15B8
	move.w	#$7000,$E4(a6)
	move.w	#$4000,$E2(a6)
	move.w	#$3000,$E0(a6)
	move.w	#$6,$DE(a6)
.L158A
	tst.w	$DE(a6)
	bne.w	.L158A
	move.w	#$4000,d5
	lsr.w	#$5,d5
	ori.w	#$8000,d5
	move.w	#$1,$B2(a6)
	move.w	#$B000,d3
	move.l	#$80,d6
	movea.l	a2,a1
	bsr.w	DrawTileMap
	move.w	#$4000,$FC(a6)
.L15B8
	move.l	#$1000,d0
	bsr.w	FillVram
	move.l	#$20001000,d0
	bsr.w	FillVram
	move.w	#$3,$DE(a6)
.L15D2
	tst.w	$DE(a6)
	bne.w	.L15D2
	move.w	#$2000,d3
	move.l	#$80,d6
	movea.l	a2,a1
	bsr.w	DrawTileMap
.L15EA
	btst.b	#$7,$FF800E.l
	bne.s	.L15EA
	move.w	#$9200,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L160C
	btst.b	#$6,$FF800E.l
	beq.s	.L160C
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L1626
	btst.b	#$6,$FF800E.l
	bne.s	.L1626
	bclr.b	#$7,$FF800F.l
.L1638
	btst.b	#$7,$FF800E.l
	bne.s	.L1638
	move.l	#$70000003,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L165C
	btst.b	#$6,$FF800E.l
	beq.s	.L165C
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L1676
	btst.b	#$6,$FF800E.l
	bne.s	.L1676
	bclr.b	#$7,$FF800F.l
.L1688
	btst.b	#$7,$FF800E.l
	bne.s	.L1688
	move.w	#$4F,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L16AA
	btst.b	#$6,$FF800E.l
	beq.s	.L16AA
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L16C4
	btst.b	#$6,$FF800E.l
	bne.s	.L16C4
	bclr.b	#$7,$FF800F.l
.L16D6
	btst.b	#$7,$FF800E.l
	bne.s	.L16D6
	move.l	#$40000010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L16FA
	btst.b	#$6,$FF800E.l
	beq.s	.L16FA
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L1714
	btst.b	#$6,$FF800E.l
	bne.s	.L1714
	bclr.b	#$7,$FF800F.l
.L1726
	btst.b	#$7,$FF800E.l
	bne.s	.L1726
	move.w	#$FFB8,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L1748
	btst.b	#$6,$FF800E.l
	beq.s	.L1748
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L1762
	btst.b	#$6,$FF800E.l
	bne.s	.L1762
	bclr.b	#$7,$FF800F.l
.L1774
	btst.b	#$7,$FF800E.l
	bne.s	.L1774
	move.w	#$8730,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L1796
	btst.b	#$6,$FF800E.l
	beq.s	.L1796
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L17B0
	btst.b	#$6,$FF800E.l
	bne.s	.L17B0
	bclr.b	#$7,$FF800F.l
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$2,d7
	movea.l	$A2(a6),a0
	jsr	$6044.w
	move.w	$7C(a6),d0
	cmpi.w	#$0,$18(a6)
	beq.w	.L17E4
	move.w	$7E(a6),d0
.L17E4
	mulu.w	#$34,d0
	lea	X_7CF4(pc),a0
	adda.l	d0,a0
	move.l	a0,$68(a6)
	bra.w	.L1852
.L17F6
	bset.b	#$5,$FF800F.l
.L17FE
	moveq	#$7,d0
	bsr.w	WaitDisplayFrames
	bsr.w	ReadJoy1
	move.w	d1,d5
	bsr.w	ReadJoy2
	or.w	d1,d5
	cmpi.b	#$10,d5
	bne.w	.L1822
	addi.w	#$1,$66(a6)
	bra.w	.L1852
.L1822
	cmpi.b	#$20,d5
	beq.w	.L1852
	cmpi.b	#$4,d5
	beq.w	.L17FE
	cmpi.b	#$1,d5
	beq.w	.L17FE
	cmpi.b	#$2,d5
	beq.w	.L17FE
	cmpi.b	#$0,d5
	beq.w	.L17FE
	move.w	d5,$AE(a6)
	bra.w	.L188A
.L1852
	movea.l	$68(a6),a0
	moveq	#$0,d1
	move.w	$66(a6),d1
	add.w	d1,d1
	add.w	d1,d1
	move.l	(a0,d1.l),d1
	cmpi.l	#$FFFFFFFF,d1
	bne.w	.L1874
	clr.w	$66(a6)
	move.l	(a0),d1
.L1874
	lea	.L14D0(pc),a0
	move.l	#$1,d0
	move.w	#$7,d7
	jsr	$6044.w
	bra.w	.L17F6
.L188A
	movea.l	$74(a6),a1
	move.w	$2(a1),d0
	lea	$4(a1),a1
	lsl.w	#$4,d0
	move.w	d0,$E0(a6)
	move.w	#$A000,$E2(a6)
	movea.l	#$BC000,a2
	move.l	a2,$E4(a6)
	subq.w	#$1,d0
.L18AE
	move.w	(a1)+,(a2)+
	dbf	d0,.L18AE
	move.w	#$1,$DE(a6)
.L18BA
	tst.w	$DE(a6)
	bne.w	.L18BA
	movem.l	(sp)+,d0-d7/a0-a6
	move.w	#$B000,d3
	move.l	#$80,d6
	movea.l	a2,a1
	bsr.w	DrawTileMap
	move.w	#$1C,$E2(a6)
	clr.w	$E0(a6)
	move.w	#$A,$DE(a6)
.L18E6
	tst.w	$DE(a6)
	bne.w	.L18E6
	move.l	#$1000,d0
	bsr.w	FillVram
	move.l	#$20001000,d0
	bsr.w	FillVram
.L1902
	btst.b	#$7,$FF800E.l
	bne.s	.L1902
	move.l	#$70000003,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L1926
	btst.b	#$6,$FF800E.l
	beq.s	.L1926
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L1940
	btst.b	#$6,$FF800E.l
	bne.s	.L1940
	bclr.b	#$7,$FF800F.l
.L1952
	btst.b	#$7,$FF800E.l
	bne.s	.L1952
	move.w	#$0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L1974
	btst.b	#$6,$FF800E.l
	beq.s	.L1974
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L198E
	btst.b	#$6,$FF800E.l
	bne.s	.L198E
	bclr.b	#$7,$FF800F.l
.L19A0
	btst.b	#$7,$FF800E.l
	bne.s	.L19A0
	move.w	$F2(a6),$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L19C2
	btst.b	#$6,$FF800E.l
	beq.s	.L19C2
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L19DC
	btst.b	#$6,$FF800E.l
	bne.s	.L19DC
	bclr.b	#$7,$FF800F.l
.L19EE
	btst.b	#$7,$FF800E.l
	bne.s	.L19EE
	move.l	#$40000010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L1A12
	btst.b	#$6,$FF800E.l
	beq.s	.L1A12
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L1A2C
	btst.b	#$6,$FF800E.l
	bne.s	.L1A2C
	bclr.b	#$7,$FF800F.l
.L1A3E
	btst.b	#$7,$FF800E.l
	bne.s	.L1A3E
	move.w	#$0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L1A60
	btst.b	#$6,$FF800E.l
	beq.s	.L1A60
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L1A7A
	btst.b	#$6,$FF800E.l
	bne.s	.L1A7A
	bclr.b	#$7,$FF800F.l
	move.w	#$0,d3
	andi.w	#$7FFF,d5
	move.l	#$100,d6
	movea.l	a2,a1
	bsr.w	DrawTileMap
	move.w	#$4,$DE(a6)
.L1AA6
	tst.w	$DE(a6)
	bne.w	.L1AA6
	move.w	$EE(a6),d3
	andi.w	#$7FFF,d5
	move.l	#$100,d6
	movea.l	a2,a1
	bsr.w	DrawTileMap
	move.l	#$1000,d0
	bsr.w	FillVram
.L1ACC
	btst.b	#$7,$FF800E.l
	bne.s	.L1ACC
	move.l	#$70000003,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L1AF0
	btst.b	#$6,$FF800E.l
	beq.s	.L1AF0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L1B0A
	btst.b	#$6,$FF800E.l
	bne.s	.L1B0A
	bclr.b	#$7,$FF800F.l
.L1B1C
	btst.b	#$7,$FF800E.l
	bne.s	.L1B1C
	move.w	$F2(a6),$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L1B3E
	btst.b	#$6,$FF800E.l
	beq.s	.L1B3E
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L1B58
	btst.b	#$6,$FF800E.l
	bne.s	.L1B58
	bclr.b	#$7,$FF800F.l
	clr.w	$E2(a6)
	clr.w	$E0(a6)
	move.w	#$A,$DE(a6)
.L1B78
	tst.w	$DE(a6)
	bne.w	.L1B78
	move.l	#$B0000800,d0
	bsr.w	FillVram
	bsr.w	FetchTeamPhotoAndStatTables
	bset.b	#$5,$FF800F.l
	movem.l	(sp)+,d0-d7/a0-a4
	rts
DrawPlayerNumberAndPosition
	movem.l	d0-d7/a0-a4,-(sp)
	moveq	#$0,d4
	move.w	#$500,d4
	moveq	#$0,d1
	moveq	#$0,d2
	movea.l	$50(a6),a3
	move.b	(a3),d1
	move.b	d1,d2
	lsr.b	#$4,d2
	mulu.w	#$3,d2
	add.w	d2,d2
	movea.w	d2,a2
	move.l	#$3840,d5
	moveq	#$2,d0
	moveq	#$25,d3
	movea.l	$78(a6),a0
	movea.l	a0,a1
	bsr.w	DrawThreeRowTileBlock
	move.l	#$3844,d5
	move.w	#$500,d4
	andi.b	#$F,d1
	mulu.w	#$3,d1
	add.w	d1,d1
	movea.w	d1,a2
	moveq	#$2,d0
	moveq	#$25,d3
	movea.l	a1,a0
	bsr.w	DrawThreeRowTileBlock
	move.l	#$3802,d5
	move.w	#$500,d4
	cmpi.b	#$47,$B7(a6)
	beq.w	.L1C72
	cmpi.b	#$44,$B7(a6)
	beq.w	.L1C4A
	cmpi.b	#$4C,$B7(a6)
	beq.w	.L1C36
	cmpi.b	#$43,$B7(a6)
	beq.w	.L1C5E
	moveq	#$7,d0
	movea.w	#$130,a2
	move.w	#$20,d3
	movea.l	a1,a0
	bsr.w	DrawThreeRowTileBlock
	bra.w	.L1C86
.L1C36
	moveq	#$7,d0
	movea.w	#$110,a2
	move.w	#$20,d3
	movea.l	a1,a0
	bsr.w	DrawThreeRowTileBlock
	bra.w	.L1C86
.L1C4A
	moveq	#$7,d0
	movea.w	#$120,a2
	move.w	#$20,d3
	movea.l	a1,a0
	bsr.w	DrawThreeRowTileBlock
	bra.w	.L1C86
.L1C5E
	moveq	#$7,d0
	movea.w	#$100,a2
	move.w	#$20,d3
	movea.l	a1,a0
	bsr.w	DrawThreeRowTileBlock
	bra.w	.L1C86
.L1C72
	moveq	#$7,d0
	movea.w	#$F0,a2
	move.w	#$20,d3
	movea.l	a1,a0
	bsr.w	DrawThreeRowTileBlock
	bra.w	.L1C86
.L1C86
	movem.l	(sp)+,d0-d7/a0-a4
	rts
DrawThreeRowTileBlock
	moveq	#$2,d7
	move.w	d0,d2
	add.w	d3,d3
	lea	(a0,a2.w),a0
.L1C96
	move.l	d5,d6
	lsl.l	#$2,d6
	lsr.w	#$2,d6
	swap	d6
	addi.l	#$40000000,d6
.L1CA4
	btst.b	#$7,$FF800E.l
	bne.s	.L1CA4
	move.l	d6,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L1CC4
	btst.b	#$6,$FF800E.l
	beq.s	.L1CC4
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L1CDE
	btst.b	#$6,$FF800E.l
	bne.s	.L1CDE
	bclr.b	#$7,$FF800F.l
.L1CF0
	movea.w	d4,a3
	adda.w	(a0)+,a3
.L1CF4
	btst.b	#$7,$FF800E.l
	bne.s	.L1CF4
	move.w	a3,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L1D14
	btst.b	#$6,$FF800E.l
	beq.s	.L1D14
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L1D2E
	btst.b	#$6,$FF800E.l
	bne.s	.L1D2E
	bclr.b	#$7,$FF800F.l
	dbf	d0,.L1CF0
	move.w	d2,d0
	adda.w	d3,a0
	addi.l	#$100,d5
	dbf	d7,.L1C96
	rts
