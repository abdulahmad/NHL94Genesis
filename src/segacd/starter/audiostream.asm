	opt	oaq+
	opt	osq+
; STARTER.BIN audio stream API. Runtime $2638C-$26603 (file $508C-$5303).
; Nine Sierra C functions. The name sits after each rts.
; Assemble with /o oz-.



L2638C; AudioPlayPos
	link	a6,#$FFFC
	move.l	a4,-(sp)
	movea.l	$8(a6),a4
	moveq	#-1,d0
	cmp.l	(a4),d0
	bne.b	L263A0
	moveq	#$0,d0
	bra.b	L263C0
L263A0	jsr	L2537E(pc)
	moveq	#$C,d1
	asr.l	d1,d0
	move.l	d0,-$4(a6)
	move.l	(a4),d0
	moveq	#$8,d1
	jsr	L26656(pc)
	move.l	-$4(a6),d1
	cmp.l	d1,d0
	beq.b	L263BE
	addq.l	#$1,(a4)
L263BE	move.l	(a4),d0
L263C0	movea.l	-$8(a6),a4
	unlk	a6
	rts
; AudioPlayPos
	dc.b	$8C,$41,$75,$64,$69,$6F,$50,$6C,$61,$79,$50,$6F,$73,$00,$00,$00	; .AudioPlayPos...
L263D8; AudioInit
	link	a6,#$0
	move.l	a4,-(sp)
	movea.l	$8(a6),a4
	moveq	#-1,d0
	move.l	d0,(a4)
	moveq	#$0,d1
	move.l	d1,$4(a4)
	move.l	d1,$8(a4)
	move.l	d1,$C(a4)
	jsr	L252D0(pc)
	movea.l	-$4(a6),a4
	unlk	a6
	rts
; AudioInit
	dc.b	$89,$41,$75,$64,$69,$6F,$49,$6E,$69,$74,$00,$00	; .AudioInit..
L2640C; AudioIdle
	link	a6,#$0
	movem.l	d7/a4,-(sp)
	movea.l	$8(a6),a4
	move.l	a4,-(sp)
	jsr	L2638C(pc)
	move.l	d0,d7
	tst.l	$C(a4)
	addq.w	#$4,sp
	beq.b	L2646A
	move.l	$4(a4),d0
	sub.l	d7,d0
	moveq	#$8,d1
	cmp.l	d0,d1
	ble.b	L2646A
	move.l	$4(a4),d0
	moveq	#$8,d1
	jsr	L26656(pc)
	move.l	d0,-(sp)
	move.l	$8(a4),-(sp)
	jsr	L253A6(pc)
	addq.l	#$1,$4(a4)
	addi.l	#$1000,$8(a4)
	subi.l	#$1000,$C(a4)
	tst.l	$C(a4)
	addq.w	#$8,sp
	bge.b	L2646A
	moveq	#$0,d0
	move.l	d0,$C(a4)
L2646A	movem.l	-$8(a6),d7/a4
	unlk	a6
	rts
; AudioIdle
	dc.b	$89,$41,$75,$64,$69,$6F,$49,$64,$6C,$65,$00,$00	; .AudioIdle..
L26480; AudioFeed
	link	a6,#$0
	move.l	a4,-(sp)
	movea.l	$8(a6),a4
	move.l	a4,-(sp)
	jsr	L2640C(pc)
	move.l	$C(a6),$8(a4)
	move.l	$10(a6),$C(a4)
	move.l	a4,-(sp)
	jsr	L2640C(pc)
	moveq	#-1,d0
	cmp.l	(a4),d0
	addq.w	#$8,sp
	bne.b	L264CA
	bra.b	L264B4
L264AC	move.l	a4,-(sp)
	jsr	L2640C(pc)
	addq.w	#$4,sp
L264B4	tst.l	$C(a4)
	ble.b	L264C2
	moveq	#$8,d0
	cmp.l	$4(a4),d0
	bgt.b	L264AC
L264C2	jsr	L25356(pc)
	moveq	#$0,d0
	move.l	d0,(a4)
L264CA	movea.l	-$4(a6),a4
	unlk	a6
	rts
; AudioFeed
	dc.b	$89,$41,$75,$64,$69,$6F,$46,$65,$65,$64,$00,$00	; .AudioFeed..
L264DE; AudioSilence
	link	a6,#$0
	movem.l	d3/d7/a3-a4,-(sp)
	movea.l	$8(a6),a3
	moveq	#-1,d0
	cmp.l	(a3),d0
	bne.b	L2653C
	pea.l	$1000.w
	jsr	L25E7E(pc)
	movea.l	d0,a4
	moveq	#$0,d7
	move.l	#$400,d3
	addq.w	#$4,sp
L26504	move.l	d7,d0
	asl.l	#$2,d0
	moveq	#$0,d1
	move.l	d1,(a4,d0.l)
	move.l	d7,d0
	addq.l	#$1,d7
	cmp.l	d7,d3
	bgt.b	L26504
	moveq	#$0,d7
L26518	move.l	d7,-(sp)
	move.l	a4,-(sp)
	jsr	L253A6(pc)
	addq.w	#$8,sp
	move.l	d7,d0
	addq.l	#$1,d7
	moveq	#$8,d0
	cmp.l	d7,d0
	bgt.b	L26518
	move.l	a4,-(sp)
	jsr	L25CFA(pc)
	jsr	L25356(pc)
	moveq	#$0,d0
	move.l	d0,(a3)
	addq.w	#$4,sp
L2653C	movem.l	-$10(a6),d3/d7/a3-a4
	unlk	a6
	rts
; AudioSilence
	dc.b	$8C,$41,$75,$64,$69,$6F,$53,$69,$6C,$65,$6E,$63,$65,$00,$00,$00	; .AudioSilence...
L26556; AudioStop
	link	a6,#$0
	jsr	L25370(pc)
	unlk	a6
	rts
; AudioStop
	dc.b	$89,$41,$75,$64,$69,$6F,$53,$74,$6F,$70,$00,$00	; .AudioStop..
L2656E; AudioTicks
	link	a6,#$FFFC
	move.l	a4,-(sp)
	movea.l	$8(a6),a4
	move.l	a4,-(sp)
	jsr	L2638C(pc)
	moveq	#$C,d0
	move.l	(a4),d1
	lsl.l	d0,d1
	move.l	d1,-$4(a6)
	jsr	L2537E(pc)
	move.l	#$FFF,d1
	and.l	d0,d1
	move.l	-$4(a6),d0
	or.l	d0,d1
	move.l	d1,d0
	movea.l	-$8(a6),a4
	unlk	a6
	rts
; AudioTicks
	dc.b	$8A,$41,$75,$64,$69,$6F,$54,$69,$63,$6B,$73,$00,$00,$00	; .AudioTicks...
L265B2; AudioTime
	link	a6,#$0
	move.l	$8(a6),-(sp)
	jsr	L2656E(pc)
	move.l	d0,d1
	move.l	$C(a6),d0
	jsr	L2660C(pc)
	; SNASM rewrites add.l #imm,dn into addi.l. The disc is D0BC.
	dc.w	$D0BC
	dc.l	$00001F40
	move.l	#$3E80,d1
	jsr	L26632(pc)
	unlk	a6
	rts
; AudioTime
	dc.b	$89,$41,$75,$64,$69,$6F,$54,$69,$6D,$65,$00,$00	; .AudioTime..
L265E8; AudioBusy
	link	a6,#$0
	movea.l	$8(a6),a0
	move.w	$E(a0),d0
	unlk	a6
	rts
; AudioBusy
	dc.b	$89,$41,$75,$64,$69,$6F,$42,$75,$73,$79,$00,$00	; .AudioBusy..

	opt	oaq-
	opt	osq-
