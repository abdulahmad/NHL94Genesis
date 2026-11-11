; STARTER.BIN audio stream API. Runtime $1008C-$10303 (file $508C-$5303).
; Nine Sierra C functions. The name sits after each rts.
; Assemble with /o oz-.

X_10356	equ	$10356
ReadFilmPcmAddress	equ	$F07E
InitFilmPcm	equ	$EFD0
LoadFilmPcmBank	equ	$F0A6
X_1008C	equ	$1008C
StartFilmPcm	equ	$F056
X_1010C	equ	$1010C
ffree	equ	$F9FA
mmalloc	equ	$FB7E
StopFilmPcm	equ	$F070
X_10332	equ	$10332
X_1030C	equ	$1030C
X_1026E	equ	$1026E

	org	$1008C

; AudioPlayPos
	link	a6,#$FFFC
	move.l	a4,-(sp)
	movea.l	$8(a6),a4
	moveq	#-1,d0
	cmp.l	(a4),d0
	bne.b	L100A0
	moveq	#$0,d0
	bra.b	L100C0
L100A0	jsr	ReadFilmPcmAddress(pc)
	moveq	#$C,d1
	asr.l	d1,d0
	move.l	d0,-$4(a6)
	move.l	(a4),d0
	moveq	#$8,d1
	jsr	X_10356(pc)
	move.l	-$4(a6),d1
	cmp.l	d1,d0
	beq.b	L100BE
	addq.l	#$1,(a4)
L100BE	move.l	(a4),d0
L100C0	movea.l	-$8(a6),a4
	unlk	a6
	rts
; AudioPlayPos
	dc.b	$8C,$41,$75,$64,$69,$6F,$50,$6C,$61,$79,$50,$6F,$73,$00,$00,$00	;.AudioPlayPos...
; AudioInit
	link	a6,#$0
	move.l	a4,-(sp)
	movea.l	$8(a6),a4
	moveq	#-1,d0
	move.l	d0,(a4)
	moveq	#$0,d1
	move.l	d1,$4(a4)
	move.l	d1,$8(a4)
	move.l	d1,$C(a4)
	jsr	InitFilmPcm(pc)
	movea.l	-$4(a6),a4
	unlk	a6
	rts
; AudioInit
	dc.b	$89,$41,$75,$64,$69,$6F,$49,$6E,$69,$74,$00,$00	;.AudioInit..
; AudioIdle
	link	a6,#$0
	movem.l	d7/a4,-(sp)
	movea.l	$8(a6),a4
	move.l	a4,-(sp)
	jsr	X_1008C(pc)
	move.l	d0,d7
	tst.l	$C(a4)
	addq.w	#$4,sp
	beq.b	L1016A
	move.l	$4(a4),d0
	sub.l	d7,d0
	moveq	#$8,d1
	cmp.l	d0,d1
	ble.b	L1016A
	move.l	$4(a4),d0
	moveq	#$8,d1
	jsr	X_10356(pc)
	move.l	d0,-(sp)
	move.l	$8(a4),-(sp)
	jsr	LoadFilmPcmBank(pc)
	addq.l	#$1,$4(a4)
	addi.l	#$1000,$8(a4)
	subi.l	#$1000,$C(a4)
	tst.l	$C(a4)
	addq.w	#$8,sp
	bge.b	L1016A
	moveq	#$0,d0
	move.l	d0,$C(a4)
L1016A	movem.l	-$8(a6),d7/a4
	unlk	a6
	rts
; AudioIdle
	dc.b	$89,$41,$75,$64,$69,$6F,$49,$64,$6C,$65,$00,$00	;.AudioIdle..
; AudioFeed
	link	a6,#$0
	move.l	a4,-(sp)
	movea.l	$8(a6),a4
	move.l	a4,-(sp)
	jsr	X_1010C(pc)
	move.l	$C(a6),$8(a4)
	move.l	$10(a6),$C(a4)
	move.l	a4,-(sp)
	jsr	X_1010C(pc)
	moveq	#-1,d0
	cmp.l	(a4),d0
	addq.w	#$8,sp
	bne.b	L101CA
	bra.b	L101B4
L101AC	move.l	a4,-(sp)
	jsr	X_1010C(pc)
	addq.w	#$4,sp
L101B4	tst.l	$C(a4)
	ble.b	L101C2
	moveq	#$8,d0
	cmp.l	$4(a4),d0
	bgt.b	L101AC
L101C2	jsr	StartFilmPcm(pc)
	moveq	#$0,d0
	move.l	d0,(a4)
L101CA	movea.l	-$4(a6),a4
	unlk	a6
	rts
; AudioFeed
	dc.b	$89,$41,$75,$64,$69,$6F,$46,$65,$65,$64,$00,$00	;.AudioFeed..
; AudioSilence
	link	a6,#$0
	movem.l	d3/d7/a3-a4,-(sp)
	movea.l	$8(a6),a3
	moveq	#-1,d0
	cmp.l	(a3),d0
	bne.b	L1023C
	pea.l	$1000.w
	jsr	mmalloc(pc)
	movea.l	d0,a4
	moveq	#$0,d7
	move.l	#$400,d3
	addq.w	#$4,sp
L10204	move.l	d7,d0
	asl.l	#$2,d0
	moveq	#$0,d1
	move.l	d1,(a4,d0.l)
	move.l	d7,d0
	addq.l	#$1,d7
	cmp.l	d7,d3
	bgt.b	L10204
	moveq	#$0,d7
L10218	move.l	d7,-(sp)
	move.l	a4,-(sp)
	jsr	LoadFilmPcmBank(pc)
	addq.w	#$8,sp
	move.l	d7,d0
	addq.l	#$1,d7
	moveq	#$8,d0
	cmp.l	d7,d0
	bgt.b	L10218
	move.l	a4,-(sp)
	jsr	ffree(pc)
	jsr	StartFilmPcm(pc)
	moveq	#$0,d0
	move.l	d0,(a3)
	addq.w	#$4,sp
L1023C	movem.l	-$10(a6),d3/d7/a3-a4
	unlk	a6
	rts
; AudioSilence
	dc.b	$8C,$41,$75,$64,$69,$6F,$53,$69,$6C,$65,$6E,$63,$65,$00,$00,$00	;.AudioSilence...
; AudioStop
	link	a6,#$0
	jsr	StopFilmPcm(pc)
	unlk	a6
	rts
; AudioStop
	dc.b	$89,$41,$75,$64,$69,$6F,$53,$74,$6F,$70,$00,$00	;.AudioStop..
; AudioTicks
	link	a6,#$FFFC
	move.l	a4,-(sp)
	movea.l	$8(a6),a4
	move.l	a4,-(sp)
	jsr	X_1008C(pc)
	moveq	#$C,d0
	move.l	(a4),d1
	lsl.l	d0,d1
	move.l	d1,-$4(a6)
	jsr	ReadFilmPcmAddress(pc)
	move.l	#$FFF,d1
	and.l	d0,d1
	move.l	-$4(a6),d0
	or.l	d0,d1
	move.l	d1,d0
	movea.l	-$8(a6),a4
	unlk	a6
	rts
; AudioTicks
	dc.b	$8A,$41,$75,$64,$69,$6F,$54,$69,$63,$6B,$73,$00,$00,$00	;.AudioTicks...
; AudioTime
	link	a6,#$0
	move.l	$8(a6),-(sp)
	jsr	X_1026E(pc)
	move.l	d0,d1
	move.l	$C(a6),d0
	jsr	X_1030C(pc)
	; SNASM rewrites add.l #imm,dn into addi.l. The disc is D0BC.
	dc.w	$D0BC
	dc.l	$00001F40
	move.l	#$3E80,d1
	jsr	X_10332(pc)
	unlk	a6
	rts
; AudioTime
	dc.b	$89,$41,$75,$64,$69,$6F,$54,$69,$6D,$65,$00,$00	;.AudioTime..
; AudioBusy
	link	a6,#$0
	movea.l	$8(a6),a0
	move.w	$E(a0),d0
	unlk	a6
	rts
; AudioBusy
	dc.b	$89,$41,$75,$64,$69,$6F,$42,$75,$73,$79,$00,$00	;.AudioBusy..
