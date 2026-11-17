; Loads two long stack arguments
LoadLongArgs	move.l	$4(sp),d0
	move.l	$8(sp),d1
; 32-bit multiply
Mul32	move.l	d0,-(sp)
	mulu.w	d1,d0
	movea.l	d0,a0
	move.l	d1,d0
	mulu.w	(sp)+,d1
	clr.w	d0
	swap	d0
	beq.b	.next
	mulu.w	(sp),d0
.next	addq.l	#$2,sp
	add.w	d1,d0
	swap	d0
	clr.w	d0
	add.l	a0,d0
	rts
	dc.b	$22,$2F,$00,$04	; "/..
; Loads the second stack argument
LoadLongArg8	move.l	$8(sp),d0
; Jump thunk through a computed address
DataThunkA	lea.l	.next(pc),a0
	movea.w	#$2,a1
	dc.w	$4EF0,$92FE		; jmp -$2(a0,a1.w): enters the code that follows
.next	dc.w	$6006		; bra.b $8
	dc.w	$4C41,$0801		; divs.l d1,d0
	dc.w	$4E75		; rts 
	dc.w	$4EBA,$0024		; jsr $2e(pc)
	dc.w	$2001		; move.l d1, d0
	dc.w	$4E75		; rts 
	dc.w	$222F,$0004		; move.l $4(a7), d1
	dc.w	$202F,$0008		; move.l $8(a7), d0
; Jump thunk through a computed address
DataThunkB	lea.l	.next(pc),a0
	movea.w	#$2,a1
	dc.w	$4EF0,$92FE		; jmp -$2(a0,a1.w): enters the code that follows
.next	dc.w	$6008		; bra.b $a
	dc.w	$4C41,$0801		; divs.l d1,d0
	dc.w	$C340		; exg.l d1, d0
	dc.w	$4E75		; rts 
	dc.w	$4A80		; tst.l d0
	dc.w	$6B14		; bmi.b $22
	dc.w	$4A81		; tst.l d1
	dc.w	$6B06		; bmi.b $18
	dc.w	$4EBA,$0046		; jsr $5a(pc)
	dc.w	$4E75		; rts 
	dc.w	$4481		; neg.l d1
	dc.w	$4EBA,$003E		; jsr $5a(pc)
	dc.w	$4481		; neg.l d1
	dc.w	$4E75		; rts 
	dc.w	$4480		; neg.l d0
	dc.w	$4A81		; tst.l d1
	dc.w	$6B0A		; bmi.b $32
	dc.w	$4EBA,$0030		; jsr $5a(pc)
	dc.w	$4480		; neg.l d0
	dc.w	$4481		; neg.l d1
	dc.w	$4E75		; rts 
	dc.w	$4481		; neg.l d1
	dc.w	$4EBA,$0024		; jsr $5a(pc)
	dc.w	$4480		; neg.l d0
	dc.w	$4E75		; rts 
	dc.w	$222F,$0004		; move.l $4(a7), d1
	dc.w	$202F,$0008		; move.l $8(a7), d0
	dc.w	$41FA,$000A		; lea.l $50(pc), a0
	dc.w	$327C,$0002		; movea.w #$2, a1
	dc.w	$4EF0,$92FE		; jmp -$2(a0, a1.w)
	dc.w	$6008		; bra.b $5a
	dc.w	$4C41,$0001		; divu.l d1,d0
	dc.w	$C340		; exg.l d1, d0
	dc.w	$4E75		; rts 
	dc.w	$3F01		; move.w d1, -(a7)
	dc.w	$4841		; swap d1
	dc.w	$4A41		; tst.w d1
	dc.w	$661C		; bne.b $7e
	dc.w	$2200		; move.l d0, d1
	dc.w	$4241		; clr.w d1
	dc.w	$4841		; swap d1
	dc.w	$670A		; beq.b $74
	dc.w	$82D7		; divu.w (a7), d1
	dc.w	$4841		; swap d1
	dc.w	$4840		; swap d0
	dc.w	$3001		; move.w d1, d0
	dc.w	$4840		; swap d0
	dc.w	$80DF		; divu.w (a7)+, d0
	dc.w	$3200		; move.w d0, d1
	dc.w	$4240		; clr.w d0
	dc.w	$4840		; swap d0
	dc.w	$4E75		; rts 
	dc.w	$4841		; swap d1
	dc.w	$3E82		; move.w d2, (a7)
	dc.w	$2F03		; move.l d3, -(a7)
	dc.w	$3400		; move.w d0, d2
	dc.w	$2601		; move.l d1, d3
	dc.w	$7201		; moveq #$1, d1
	dc.w	$4240		; clr.w d0
	dc.w	$4840		; swap d0
	dc.w	$660C		; bne.b $9c
	dc.w	$4840		; swap d0
; Bit scan loop
BitScanLeft	move.w	d2,d0
	moveq	#$0,d1
	bra.b	.next
.loop	add.w	d1,d1
	bcs.b	.next
.loop2	add.w	d2,d2
	addx.l	d0,d0
	cmp.l	d3,d0
	bcs.b	.loop
	sub.l	d3,d0
	add.w	d1,d1
	bset	#$0,d1
	bcc.b	.loop2
.next	move.l	(sp)+,d3
	move.w	(sp)+,d2
	rts
	dc.b	$05,$D2,$00,$00	; ....
; Loads a sprite frame descriptor from the stack arguments.
SetupSpriteFrame	movem.l	d0-d7/a0-a6,-(sp)
	moveq	#$0,d0
	move.w	$40(sp),d2
	move.w	$42(sp),d1
	move.w	$44(sp),d0
	bmi.w	.loop
	move.w	d0,$10ADA.l
	cmpi.w	#$FFFF,d0
	beq.w	.loop
	cmpi.w	#$1,d0
	bge.w	.loop
	lea.l	$104EC.l,a0
	mulu.w	#$A,d0
	adda.l	d0,a0
	move.b	$0(a0),d0
	cmpi.b	#$2,d0
	dc.w	$6700,$000E
.loop	movem.l	(sp)+,d0-d7/a0-a6
	move.l	(sp),$6(sp)
	addq.l	#$6,sp
	rts
.next	tst.w	d1
	bne.w	.next4
	tst.w	d2
	bne.w	.next4
	move.w	$4(a0),d0
	sub.w	$2(a0),d0
	beq.w	.next2
	jsr	$E488.l
.next2	add.w	$2(a0),d0
	move.w	d0,d2
	moveq	#$0,d1
	move.b	$1(a0),d1
	move.w	$8(a0),d0
	sub.w	$6(a0),d0
	beq.w	.next3
	jsr	$E488.l
.next3	add.w	$6(a0),d0
	move.w	d0,d3
	move.w	#$3,d0
	move.w	#$FFFF,d4
	jsr	$C4BC.l
	bra.b	.loop
.next4	move.w	d1,d3
	move.w	d2,d4
	move.w	$4(a0),d0
	sub.w	$2(a0),d0
	beq.w	.next5
	jsr	$E488.l
.next5	add.w	$2(a0),d0
	move.w	d0,d2
	moveq	#$0,d1
	move.b	$1(a0),d1
	move.w	#$3,d0
	jsr	$C4BC.l
	bra.w	.loop
	dc.b	$02,$00,$05,$A9,$05,$A9,$00,$FF,$00,$FF	; ..........
