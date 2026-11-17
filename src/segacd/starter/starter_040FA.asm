; Zero-filled work storage (4 bytes).
Long7	dc.b	$00,$00,$00,$00	; ....
; Saves the vector at $5F90 and installs the second handler.
InstallIrqHook2	lea.l	Long7(pc),a0
	move.l	$5F90.w,(a0)
	lea.l	RestoreBios_116(pc),a0
	move.w	sr,-(sp)
	ori.w	#$2700,sr
	move.l	a0,$5F90.w
	move.w	(sp)+,sr
	rts
; Restores the vector at $5F90.
RemoveIrqHook2	movea.l	Long7(pc),a0
	move.w	sr,-(sp)
	ori.w	#$2700,sr
	move.l	a0,$5F90.w
	move.w	(sp)+,sr
	rts
; Zero-filled work storage (4 bytes).
Long8	dc.b	$00,$00,$00,$00	; ....
RestoreBios_116	movem.l	d0-d3/a0-a2/a5,-(sp)
	pea.l	.l413E(pc)
	move.w	sr,-(sp)
	movea.l	Long7(pc),a2
	jmp	(a2)
.l413E	movea.l	#$FF8000,a5
	move.l	Long4(pc),d3
	beq.w	.l421C
	bgt.b	.l41C6
	andi.w	#$F8FF,$4(a5)
	ori.w	#$300,$4(a5)
	move.w	#$8B,d0
	jsr	$5F22.w
	bcs.w	.l421C
	move.l	Long5(pc),d0
	bne.b	.l4176
	bsr.w	PeekSectDst
	tst.l	d0
	beq.w	.l4222
.l4176	movea.l	d0,a0
	lea.l	Long8(pc),a1
	move.w	#$8C,d0
	jsr	$5F22.w
	bcs.w	.l421C
	move.w	#$8D,d0
	jsr	$5F22.w
	move.l	Long8(pc),d0
	andi.l	#$FFFFFF00,d0
	bsr.w	CdMsfBcdToBin
	move.l	Buf8_10(pc),d1
	cmp.l	d0,d1
	bne.b	.l421C
	lea.l	Long5(pc),a1
	tst.l	(a1)
	beq.b	.l41B6
	addi.l	#$800,(a1)
	bra.b	.l41BA
.l41B6	bsr.w	GetSectDst
.l41BA	neg.l	d3
	subq.w	#$1,d3
	lea.l	Long4(pc),a1
	move.l	d3,(a1)
	bra.b	.l421C
.l41C6	movea.l	#$FF8000,a5
	andi.w	#$F8FF,$4(a5)
	ori.w	#$500,$4(a5)
	move.l	Long5(pc),d0
	bne.b	.l41E6
	bsr.w	GetSectDst
	tst.l	d0
	beq.b	.l4222
.l41E6	lsr.l	#$3,d0
	move.w	d0,$A(a5)
	move.w	#$8B,d0
	jsr	$5F22.w
	bcs.b	.l422A
.l41F6	btst.b	#$7,$4(a5)
	beq.b	.l41F6
	bcs.b	.l422A
	move.w	#$8D,d0
	jsr	$5F22.w
	lea.l	Long5(pc),a1
	tst.l	(a1)
	beq.b	.l4216
	addi.l	#$800,(a1)
.l4216	lea.l	Long4(pc),a1
	subq.l	#$1,(a1)
.l421C	movem.l	(sp)+,d0-d3/a0-a2/a5
	rte
.l4222	lea.l	Long4(pc),a1
	clr.l	(a1)
	bra.b	.l421C
.l422A	lea.l	BufA8_1(pc),a1
	move.l	#$FFFFFFFF,(a1)
	bra.b	.l421C
RestoreBios_117	lea.l	Long4(pc),a1
	clr.l	(a1)
	move.w	#$8,d0
	jsr	$5F22.w
	rts
RestoreBios_118	link	a6,#$FFFC
RestoreBiosSub47	movem.l	d1-d7/a0-a5,-(sp)
	movea.l	#$FF8000,a5
	lea.l	BufA8_1(pc),a1
	clr.l	(a1)
	moveq	#$5,d4
	moveq	#-1,d5
	subq.l	#$1,d4
	beq.b	.l4298
	moveq	#$0,d0
	move.w	#$96,d0
	jsr	$5F22.w
	move.l	$8(a6),d3
	move.l	$C(a6),d2
	lea.l	$8(a6),a0
	move.w	#$17,d0
	jsr	$5F22.w
	lea.l	Long5(pc),a1
	move.l	$10(a6),(a1)
	lea.l	Long4(pc),a1
	neg.l	d2
	move.l	d2,(a1)
	lea.l	Buf8_10(pc),a1
	move.l	d3,(a1)
	moveq	#$0,d5
.l4298	move.l	d5,d0
	movem.l	(sp)+,d1-d7/a0-a5
	unlk	a6
	rts
; Converts the packed BCD byte in d0 to binary.
BcdToBin	move.l	d1,-(sp)
	move.b	d0,d1
	andi.w	#$FF,d1
	lsr.w	#$4,d1
	mulu.w	#$A,d1
	andi.w	#$F,d0
	add.w	d1,d0
	move.l	(sp)+,d1
	rts
; Converts the BCD minute/second/frame bytes of d0 to binary.
CdMsfBcdToBin	movem.l	d1-d2,-(sp)
	lsr.l	#$8,d0
	move.l	d0,d1
	jsr	BcdToBin(pc)
	move.b	d0,d2
	andi.l	#$FF,d2
	move.l	d1,d0
	lsr.l	#$8,d0
	move.l	d0,d1
	jsr	BcdToBin(pc)
	andi.l	#$FF,d0
	mulu.w	#$4B,d0
	add.l	d0,d2
	move.l	d1,d0
	lsr.l	#$8,d0
	jsr	BcdToBin(pc)
	andi.l	#$FF,d0
	mulu.w	#$1194,d0
	add.l	d0,d2
	subi.l	#$96,d2
	move.l	d2,d0
	movem.l	(sp)+,d1-d2
	rts
RestoreBios_120	link	a6,#$0
Wait	movem.l	d6-d7,-(sp)
	move.l	$8(a6),d6
	jsr	GetTicks(pc)
	move.l	d0,d7
.l4318	jsr	GetTicks(pc)
	move.l	d7,d1
	add.l	d6,d1
	cmp.l	d0,d1
	bgt.b	.l4318
	movem.l	-$8(a6),d6-d7
	unlk	a6
	rts
	dc.b	$84,'Wait',$00,$00,$00	; .Wait...
