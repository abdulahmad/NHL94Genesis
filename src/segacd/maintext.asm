; MAIN.BIN $302A-$34B7. Sierra C command handlers. The bytes after each rts
; are the function name (tag byte, ASCII, padding) and the strings the
; handler prints.

X_FF429C	equ	$FF429C
X_FF4456	equ	$FF4456
X_FF3BA0	equ	$FF3BA0
X_FF4498	equ	$FF4498
X_FF4144	equ	$FF4144
X_FF414E	equ	$FF414E
X_FF4080	equ	$FF4080
X_FF402A	equ	$FF402A
X_FF415A	equ	$FF415A
X_FF43C4	equ	$FF43C4
X_FF417C	equ	$FF417C
X_FF3AEC	equ	$FF3AEC
X_FF2E00	equ	$FF2E00
X_FF44C0	equ	$FF44C0
X_FF44E4	equ	$FF44E4
X_FF418E	equ	$FF418E
X_FF423C	equ	$FF423C
X_FF41DE	equ	$FF41DE
X_FF4424	equ	$FF4424
X_FF4434	equ	$FF4434
X_FF4444	equ	$FF4444

	org	$FF402A

; DoDrawTextCommand
	link	a6,#$FF00
	movem.l	d6-d7/a4,-(sp)
	lea.l	-$100(a6),a4
	clr.w	d6
	bra.b	LFF4052
LFF403A	cmpi.b	#$1,d7
	bne.b	LFF404A
	move.w	d6,d0
	addq.w	#$1,d6
	clr.b	(a4,d0.w)
	bra.b	LFF405A
LFF404A	move.w	d6,d0
	addq.w	#$1,d6
	move.b	d7,(a4,d0.w)
LFF4052	jsr	X_FF4456(pc)
	move.b	d0,d7
	bne.b	LFF403A
LFF405A	move.l	a4,-(sp)
	jsr	X_FF429C(pc)
	addq.w	#$4,sp
	movem.l	-$10C(a6),d6-d7/a4
	unlk	a6
	rts
; DoDrawTextCommand
	dc.b	$91,$44,$6F,$44,$72,$61,$77,$54,$65,$78,$74,$43,$6F,$6D,$6D,$61	;.DoDrawTextComma
	dc.b	$6E,$64,$00,$00			;nd..
; DoMoviePlayBack
	link	a6,#$0
	movem.l	d5-d7/a4,-(sp)
	movea.l	#$200000,a4
	move.l	(a4),d5
	move.l	$4(a4),d6
	move.l	$8(a4),d7
	bra.b	LFF40BC
LFF409A	moveq	#$1,d0
	move.l	d0,-(sp)
	jsr	X_FF4498(pc)
	move.l	#$200000,-(sp)
	move.l	d5,-(sp)
	move.l	d6,-(sp)
	move.l	d7,-(sp)
	jsr	X_FF3BA0(pc)
	moveq	#$0,d0
	move.l	d0,-(sp)
	jsr	X_FF4498(pc)
	addq.w	#$8,sp
LFF40BC	jsr	X_FF4456(pc)
	cmpi.w	#$2,d0
	beq.b	LFF409A
	movem.l	-$10(a6),d5-d7/a4
	unlk	a6
	rts
; DoMoviePlayBack
	dc.b	$8F,$44,$6F,$4D,$6F,$76,$69,$65,$50,$6C,$61,$79,$42,$61,$63,$6B	;.DoMoviePlayBack
	dc.b	$00,$00					;..
; MAINCODE
	link	a6,#$0
	move.l	d7,-(sp)
	jsr	X_FF43C4(pc)
	pea.l	X_FF415A(pc)
	jsr	X_FF429C(pc)
	addq.w	#$4,sp
	bra.b	LFF411E
LFF40F8	move.w	d7,d0
	subq.w	#$1,d0
	beq.b	LFF4104
	subq.w	#$2,d0
	beq.b	LFF410A
	bra.b	LFF4110
LFF4104	jsr	X_FF402A(pc)
	bra.b	LFF411E
LFF410A	jsr	X_FF4080(pc)
	bra.b	LFF4126
LFF4110	ext.l	d7
	move.l	d7,-(sp)
	pea.l	X_FF414E(pc)
	jsr	X_FF429C(pc)
	addq.w	#$8,sp
LFF411E	jsr	X_FF4456(pc)
	move.w	d0,d7
	bne.b	LFF40F8
LFF4126	pea.l	X_FF4144(pc)
	jsr	X_FF429C(pc)
	addq.w	#$4,sp
	move.l	-$4(a6),d7
	unlk	a6
	rts
; MAINCODE
	dc.b	$88,$4D,$41,$49,$4E,$43,$4F,$44,$45,$00,$00,$38,$4D,$61,$69,$6E	;.MAINCODE..8Main
	dc.b	$20,$44,$6F,$6E,$65,$00,$43,$6F,$6D,$6D,$61,$6E,$64,$3A,$20,$25	;Done.Command: %
	dc.b	$64,$00,$4D,$41,$49,$4E,$43,$50,$55,$20,$72,$65,$61,$64,$79,$20	;d.MAINCPU ready
	dc.b	$74,$6F,$20,$68,$61,$6E,$64,$6C,$65,$20,$63,$6F,$6D,$6D,$61,$6E	;to handle comman
	dc.b	$64,$73,$00,$00			;ds..
; ReDraw
	link	a6,#$0
	unlk	a6
	rts
; ReDraw
	dc.b	$86,$52,$65,$44,$72,$61,$77,$00,$00,$00	;.ReDraw...
; drawprint
	link	a6,#$0
	move.l	$8(a6),-(sp)
	lea.l	X_FF2E00(pc),a0
	move.l	$5C(a0),-(sp)
	lea.l	X_FF2E00(pc),a0
	move.l	$60(a0),-(sp)
	jsr	X_FF3AEC(pc)
	lea.l	X_FF2E00(pc),a0
	addq.l	#$1,$60(a0)
	lea.l	X_FF2E00(pc),a0
	moveq	#$18,d0
	cmp.l	$60(a0),d0
	bgt.b	LFF41CA
	lea.l	X_FF2E00(pc),a0
	subi.l	#$14,$60(a0)
LFF41CA	jsr	X_FF417C(pc)
	unlk	a6
	rts
; drawprint
	dc.b	$89,$64,$72,$61,$77,$70,$72,$69,$6E,$74,$00,$00	;.drawprint..
; NumStr
	link	a6,#$FFF0
	movem.l	d6-d7/a3-a4,-(sp)
	movea.l	$10(a6),a3
	lea.l	-$10(a6),a4
	move.l	$8(a6),d6
	clr.w	d7
	move.w	d7,d0
	addq.w	#$1,d7
	clr.b	(a4,d0.w)
LFF41FC	move.l	d6,d0
	moveq	#$A,d1
	jsr	X_FF44E4(pc)
	moveq	#$30,d1
	add.b	d1,d0
	move.w	d7,d1
	addq.w	#$1,d7
	move.b	d0,(a4,d1.w)
	move.l	d6,d0
	moveq	#$A,d1
	jsr	X_FF44C0(pc)
	move.l	d0,d6
	bne.b	LFF41FC
	bra.b	LFF4224
LFF421E	subq.w	#$1,d7
	move.b	(a4,d7.w),(a3)+
LFF4224	tst.w	d7
	bne.b	LFF421E
	movem.l	-$20(a6),d6-d7/a3-a4
	unlk	a6
	rts
; NumStr
	dc.b	$86,$4E,$75,$6D,$53,$74,$72,$00,$00,$00	;.NumStr...
; HexStr
	link	a6,#$0
	movem.l	d3-d7/a4,-(sp)
	move.w	$E(a6),d4
	move.l	$8(a6),d5
	movea.l	$10(a6),a4
	ext.l	d4
	move.l	d4,d7
	subq.l	#$1,d7
	moveq	#$0,d3
	bra.b	LFF4280
LFF425A	moveq	#$F,d6
	and.l	d5,d6
	asr.l	#$4,d5
	moveq	#$9,d0
	cmp.l	d6,d0
	blt.b	LFF4272
	move.b	d6,d0
	moveq	#$30,d1
	add.b	d1,d0
	move.b	d0,(a4,d7.l)
	bra.b	LFF427C
LFF4272	move.b	d6,d0
	moveq	#-55,d1
	sub.b	d1,d0
	move.b	d0,(a4,d7.l)
LFF427C	move.l	d7,d0
	subq.l	#$1,d7
LFF4280	cmp.l	d7,d3
	ble.b	LFF425A
	clr.b	(a4,d4.w)
	movem.l	-$18(a6),d3-d7/a4
	unlk	a6
	rts
; HexStr
	dc.b	$86,$48,$65,$78,$53,$74,$72,$00,$00,$00	;.HexStr...
; aprint
	link	a6,#$FED8
	movem.l	d4-d7/a3-a4,-(sp)
	lea.l	-$128(a6),a4
	bra.w	LFF43B0
LFF42AC	cmpi.b	#$25,d6
	beq.b	LFF42B8
	move.b	d6,(a3)+
	bra.w	LFF4394
LFF42B8	moveq	#$8,d4
	movea.l	$8(a6),a0
	addq.l	#$1,$8(a6)
	move.b	(a0),d6
	move.b	d6,d0
	subi.b	#$2A,d0
	bne.b	LFF42E4
	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.w	-$2(a0),d4
	move.l	$8(a6),d0
	addq.l	#$1,$8(a6)
	movea.l	d0,a0
	move.b	(a0),d6
LFF42E4	move.b	d6,d0
	subi.b	#$25,d0
	beq.w	LFF4392
	subi.b	#$2E,d0
	beq.b	LFF436C
	subq.b	#$5,d0
	beq.b	LFF433C
	subi.b	#$C,d0
	beq.b	LFF430C
	subi.b	#$F,d0
	beq.b	LFF436C
	subq.b	#$5,d0
	beq.b	LFF433C
	bra.w	LFF4394
LFF430C	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.l	-$4(a0),d5
	move.l	a4,-(sp)
	ext.l	d4
	move.l	d4,-(sp)
	move.l	d5,-(sp)
	jsr	X_FF41DE(pc)
	clr.w	d7
	lea.l	$C(sp),sp
	bra.b	LFF4334
LFF432C	move.b	(a4,d7.w),(a3)+
	move.w	d7,d0
	addq.w	#$1,d7
LFF4334	tst.b	(a4,d7.w)
	bne.b	LFF432C
	bra.b	LFF4394
LFF433C	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.l	-$4(a0),d5
	move.l	a4,-(sp)
	ext.l	d4
	move.l	d4,-(sp)
	move.l	d5,-(sp)
	jsr	X_FF423C(pc)
	clr.w	d7
	lea.l	$C(sp),sp
	bra.b	LFF4364
LFF435C	move.b	(a4,d7.w),(a3)+
	move.w	d7,d0
	addq.w	#$1,d7
LFF4364	tst.b	(a4,d7.w)
	bne.b	LFF435C
	bra.b	LFF4394
LFF436C	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.l	-$4(a0),-$8(a6)
	bra.b	LFF4388
LFF437C	move.l	-$8(a6),d0
	addq.l	#$1,-$8(a6)
	movea.l	d0,a0
	move.b	(a0),(a3)+
LFF4388	movea.l	-$8(a6),a0
	tst.b	(a0)
	bne.b	LFF437C
	bra.b	LFF4394
LFF4392	move.b	d6,(a3)+
LFF4394	move.l	$8(a6),d0
	addq.l	#$1,$8(a6)
	movea.l	d0,a0
	move.b	(a0),d6
	bne.w	LFF42AC
	clr.b	(a3)+
	pea.l	-$108(a6)
	jsr	X_FF418E(pc)
	addq.w	#$4,sp
LFF43B0	movem.l	-$140(a6),d4-d7/a3-a4
	unlk	a6
	rts
; aprint
	dc.b	$86,$61,$70,$72,$69,$6E,$74,$00,$00,$00	;.aprint...
; InitWorld
	link	a6,#$0
	movea.l	#$A12010,a0
	clr.w	(a0)
	movea.l	#$A12010,a0
	clr.w	$2(a0)
	lea.l	X_FF2E00(pc),a0
	moveq	#$4,d0
	move.l	d0,$5C(a0)
	lea.l	X_FF2E00(pc),a0
	move.l	d0,$60(a0)
	pea.l	X_FF4444(pc)
	jsr	X_FF429C(pc)
	lea.l	X_FF2E00(pc),a0
	move.l	$54(a0),-(sp)
	pea.l	X_FF4434(pc)
	jsr	X_FF429C(pc)
	lea.l	X_FF2E00(pc),a0
	move.l	$58(a0),-(sp)
	pea.l	X_FF4424(pc)
	jsr	X_FF429C(pc)
	unlk	a6
	rts
; InitWorld
	dc.b	$89,$49,$6E,$69,$74,$57,$6F,$72,$6C,$64,$00,$32,$48,$65,$61,$70	;.InitWorld.2Heap
	dc.b	$20,$53,$69,$7A,$65,$20,$3A,$20,$25,$78,$00,$00,$48,$65,$61,$70	;Size : %x..Heap
	dc.b	$20,$53,$74,$61,$72,$74,$3A,$20,$25,$78,$00,$00,$4D,$41,$49,$4E	;Start: %x..MAIN
	dc.b	$43,$50,$55,$20,$69,$73,$20,$61,$6C,$69,$76,$65,$00,$00	;CPU is alive..
; GetCommandFromSub
	link	a6,#$0
	movem.l	d7/a3-a4,-(sp)
	movea.l	#$A12010,a3
	movea.l	#$A12020,a4
LFF446A	move.w	(a4),d7
	beq.b	LFF446A
	move.w	#$1,(a3)
LFF4472	tst.w	(a4)
	bne.b	LFF4472
	clr.w	(a3)
	move.w	d7,d0
	movem.l	-$C(a6),d7/a3-a4
	unlk	a6
	rts
; GetCommandFromSub
	dc.b	$91,$47,$65,$74,$43,$6F,$6D,$6D,$61,$6E,$64,$46,$72,$6F,$6D,$53	;.GetCommandFromS
	dc.b	$75,$62,$00,$00			;ub..
; Set1MFlag
	link	a6,#$0
	movea.l	#$A12010,a0
	move.w	$A(a6),$2(a0)
	unlk	a6
	rts
; Set1MFlag
	dc.b	$89,$53,$65,$74,$31,$4D,$46,$6C,$61,$67,$00,$00	;.Set1MFlag..
