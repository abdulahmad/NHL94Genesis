RestoreBios_118	dc.b	$00,$00,$00,$00	; ....
; Saves the vector at $5F90 and installs the second handler.
InstallIrqHook2	lea.l	RestoreBios_118(pc),a0
	move.l	$5F90.w,(a0)
	lea.l	RestoreBios_122(pc),a0
	move.w	sr,-(sp)
	ori.w	#$2700,sr
	move.l	a0,$5F90.w
	move.w	(sp)+,sr
	rts
; Restores the vector at $5F90.
RemoveIrqHook2	movea.l	RestoreBios_118(pc),a0
	move.w	sr,-(sp)
	ori.w	#$2700,sr
	move.l	a0,$5F90.w
	move.w	(sp)+,sr
	rts
RestoreBios_121	dc.b	$00,$00,$00,$00	; ....
RestoreBios_122	movem.l	d0-d3/a0-a2/a5,-(sp)
	pea.l	.next(pc)
	move.w	sr,-(sp)
	movea.l	RestoreBios_118(pc),a2
	jmp	(a2)
.next	movea.l	#$FF8000,a5
	move.l	RestoreBios_101(pc),d3
	beq.w	.loop2
	bgt.b	.next5
	andi.w	#$F8FF,$4(a5)
	ori.w	#$300,$4(a5)
	move.w	#$8B,d0
	jsr	$5F22.w
	bcs.w	.loop2
	move.l	RestoreBios_102(pc),d0
	bne.b	.next2
	bsr.w	PeekSectDst
	tst.l	d0
	beq.w	.next8
.next2	movea.l	d0,a0
	lea.l	RestoreBios_121(pc),a1
	move.w	#$8C,d0
	jsr	$5F22.w
	bcs.w	.loop2
	move.w	#$8D,d0
	jsr	$5F22.w
	move.l	RestoreBios_121(pc),d0
	andi.l	#$FFFFFF00,d0
	bsr.w	CdMsfBcdToBin
	move.l	RestoreBios_103(pc),d1
	cmp.l	d0,d1
	bne.b	.loop2
	lea.l	RestoreBios_102(pc),a1
	tst.l	(a1)
	beq.b	.next3
	addi.l	#$800,(a1)
	bra.b	.next4
.next3	bsr.w	GetSectDst
.next4	neg.l	d3
	subq.w	#$1,d3
	lea.l	RestoreBios_101(pc),a1
	move.l	d3,(a1)
	bra.b	.loop2
.next5	movea.l	#$FF8000,a5
	andi.w	#$F8FF,$4(a5)
	ori.w	#$500,$4(a5)
	move.l	RestoreBios_102(pc),d0
	bne.b	.next6
	bsr.w	GetSectDst
	tst.l	d0
	beq.b	.next8
.next6	lsr.l	#$3,d0
	move.w	d0,$A(a5)
	move.w	#$8B,d0
	jsr	$5F22.w
	bcs.b	.next9
.loop	btst.b	#$7,$4(a5)
	beq.b	.loop
	bcs.b	.next9
	move.w	#$8D,d0
	jsr	$5F22.w
	lea.l	RestoreBios_102(pc),a1
	tst.l	(a1)
	beq.b	.next7
	addi.l	#$800,(a1)
.next7	lea.l	RestoreBios_101(pc),a1
	subq.l	#$1,(a1)
.loop2	movem.l	(sp)+,d0-d3/a0-a2/a5
	rte
.next8	lea.l	RestoreBios_101(pc),a1
	clr.l	(a1)
	bra.b	.loop2
.next9	lea.l	RestoreBios_106(pc),a1
	move.l	#$FFFFFFFF,(a1)
	bra.b	.loop2
; Clears a flag and calls CD BIOS function 8.
CdBiosCall8	lea.l	RestoreBios_101(pc),a1
	clr.l	(a1)
	move.w	#$8,d0
	jsr	$5F22.w
	rts
; Runs a CD BIOS read sequence (functions $96...) with a retry count.
CdBiosReadSequence	link	a6,#$FFFC
	movem.l	d1-d7/a0-a5,-(sp)
	movea.l	#$FF8000,a5
	lea.l	RestoreBios_106(pc),a1
	clr.l	(a1)
	moveq	#$5,d4
	moveq	#-1,d5
	subq.l	#$1,d4
	beq.b	.next
	moveq	#$0,d0
	move.w	#$96,d0
	jsr	$5F22.w
	move.l	$8(a6),d3
	move.l	$C(a6),d2
	lea.l	$8(a6),a0
	move.w	#$17,d0
	jsr	$5F22.w
	lea.l	RestoreBios_102(pc),a1
	move.l	$10(a6),(a1)
	lea.l	RestoreBios_101(pc),a1
	neg.l	d2
	move.l	d2,(a1)
	lea.l	RestoreBios_103(pc),a1
	move.l	d3,(a1)
	moveq	#$0,d5
.next	move.l	d5,d0
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
Wait	link	a6,#$0
	movem.l	d6-d7,-(sp)
	move.l	$8(a6),d6
	jsr	GetTicks(pc)
	move.l	d0,d7
.loop	jsr	GetTicks(pc)
	move.l	d7,d1
	add.l	d6,d1
	cmp.l	d0,d1
	bgt.b	.loop
	movem.l	-$8(a6),d6-d7
	unlk	a6
	rts
	dc.b	$84,'Wait',$00,$00,$00	; .Wait...
