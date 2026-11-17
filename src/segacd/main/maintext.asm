; MAIN.BIN $302A-$34B7. Sierra C command handlers. The bytes after each rts
; are the function name (tag byte, ASCII, padding) and the strings the
; handler prints.



DoDrawTextCommand_A	; Sierra C function name tag: DoDrawTextCommand (first copy of the module)
	link	a6,#$FF00
	movem.l	d6-d7/a4,-(sp)
	lea.l	-$100(a6),a4
	clr.w	d6
	bra.b	DispatchTail_29
DispatchTail_28	cmpi.b	#$1,d7
	bne.b	.lFF304A
	move.w	d6,d0
	addq.w	#$1,d6
	clr.b	(a4,d0.w)
	bra.b	DispatchTail_30
.lFF304A	move.w	d6,d0
	addq.w	#$1,d6
	move.b	d7,(a4,d0.w)
DispatchTail_29	jsr	GetCommandFromSub_A(pc)
	move.b	d0,d7
	bne.b	DispatchTail_28
DispatchTail_30	move.l	a4,-(sp)
	jsr	aprint_A(pc)
	addq.w	#$4,sp
	movem.l	-$10C(a6),d6-d7/a4
	unlk	a6
	rts
; DoDrawTextCommand
	dc.b	$91,'DoDrawTextComma'	; .DoDrawTextComma
	dc.b	$6E,$64,$00,$00			; nd..
DoMoviePlayBack_A	; Sierra C function name tag: DoMoviePlayBack (first copy of the module)
	link	a6,#$0
	movem.l	d5-d7/a4,-(sp)
	movea.l	#$200000,a4
	move.l	(a4),d5
	move.l	$4(a4),d6
	move.l	$8(a4),d7
	bra.b	DispatchTail_33
DispatchTail_32	moveq	#$1,d0
	move.l	d0,-(sp)
	jsr	Set1MFlag_A(pc)
	move.l	#$200000,-(sp)
	move.l	d5,-(sp)
	move.l	d6,-(sp)
	move.l	d7,-(sp)
	jsr	DrawTextBuffer(pc)
	moveq	#$0,d0
	move.l	d0,-(sp)
	jsr	Set1MFlag_A(pc)
	addq.w	#$8,sp
DispatchTail_33	jsr	GetCommandFromSub_A(pc)
	cmpi.w	#$2,d0
	beq.b	DispatchTail_32
	movem.l	-$10(a6),d5-d7/a4
	unlk	a6
	rts
; DoMoviePlayBack
	dc.b	$8F,'DoMoviePlayBack'	; .DoMoviePlayBack
	dc.b	$00,$00					; ..
MAINCODE_A	; Sierra C function name tag: MAINCODE (first copy of the module)
	link	a6,#$0
	move.l	d7,-(sp)
	jsr	InitWorld_A(pc)
	pea.l	LFF315A(pc)
	jsr	aprint_A(pc)
	addq.w	#$4,sp
	bra.b	DispatchTail_36
DispatchTail_35	move.w	d7,d0
	subq.w	#$1,d0
	beq.b	.lFF3104
	subq.w	#$2,d0
	beq.b	.lFF310A
	bra.b	.lFF3110
.lFF3104	jsr	DoDrawTextCommand_A(pc)
	bra.b	DispatchTail_36
.lFF310A	jsr	DoMoviePlayBack_A(pc)
	bra.b	DispatchTail_37
.lFF3110	ext.l	d7
	move.l	d7,-(sp)
	pea.l	LFF314E(pc)
	jsr	aprint_A(pc)
	addq.w	#$8,sp
DispatchTail_36	jsr	GetCommandFromSub_A(pc)
	move.w	d0,d7
	bne.b	DispatchTail_35
DispatchTail_37	pea.l	LFF3144(pc)
	jsr	aprint_A(pc)
	addq.w	#$4,sp
	move.l	-$4(a6),d7
	unlk	a6
	rts
; MAINCODE
	dc.b	$88,'MAINCODE',$00,$00,'8Main'	; .MAINCODE..8Main
	dc.b	' Done',$00,'Command: %'	;  Done.Command: %
	dc.b	$64,$00,'MAINCPU ready '	; d.MAINCPU ready 
	dc.b	'to handle comman'	; to handle comman
	dc.b	$64,$73,$00,$00			; ds..
ReDraw_A	; Sierra C function name tag: ReDraw (first copy of the module)
	link	a6,#$0
	unlk	a6
	rts
; ReDraw
	dc.b	$86,'ReDraw',$00,$00,$00	; .ReDraw...
drawprint_A	; Sierra C function name tag: drawprint (first copy of the module)
	link	a6,#$0
	move.l	$8(a6),-(sp)
	lea.l	DispatchTail_12(pc),a0
	move.l	$5C(a0),-(sp)
	lea.l	DispatchTail_12(pc),a0
	move.l	$60(a0),-(sp)
	jsr	DrawTextToPlane(pc)
	lea.l	DispatchTail_12(pc),a0
	addq.l	#$1,$60(a0)
	lea.l	DispatchTail_12(pc),a0
	moveq	#$18,d0
	cmp.l	$60(a0),d0
	bgt.b	.lFF31CA
	lea.l	DispatchTail_12(pc),a0
	subi.l	#$14,$60(a0)
.lFF31CA	jsr	ReDraw_A(pc)
	unlk	a6
	rts
; drawprint
	dc.b	$89,'drawprint',$00,$00	; .drawprint..
NumStr_A	; Sierra C function name tag: NumStr (first copy of the module)
	link	a6,#$FFF0
	movem.l	d6-d7/a3-a4,-(sp)
	movea.l	$10(a6),a3
	lea.l	-$10(a6),a4
	move.l	$8(a6),d6
	clr.w	d7
	move.w	d7,d0
	addq.w	#$1,d7
	clr.b	(a4,d0.w)
.lFF31FC	move.l	d6,d0
	moveq	#$A,d1
	jsr	LongModU(pc)
	moveq	#$30,d1
	add.b	d1,d0
	move.w	d7,d1
	addq.w	#$1,d7
	move.b	d0,(a4,d1.w)
	move.l	d6,d0
	moveq	#$A,d1
	jsr	LongDivU(pc)
	move.l	d0,d6
	bne.b	.lFF31FC
	bra.b	DispatchTail_42
DispatchTail_41	subq.w	#$1,d7
	move.b	(a4,d7.w),(a3)+
DispatchTail_42	tst.w	d7
	bne.b	DispatchTail_41
	movem.l	-$20(a6),d6-d7/a3-a4
	unlk	a6
	rts
; NumStr
	dc.b	$86,'NumStr',$00,$00,$00	; .NumStr...
HexStr_A	; Sierra C function name tag: HexStr (first copy of the module)
	link	a6,#$0
	movem.l	d3-d7/a4,-(sp)
	move.w	$E(a6),d4
	move.l	$8(a6),d5
	movea.l	$10(a6),a4
	ext.l	d4
	move.l	d4,d7
	subq.l	#$1,d7
	moveq	#$0,d3
	bra.b	DispatchTail_45
DispatchTail_44	moveq	#$F,d6
	and.l	d5,d6
	asr.l	#$4,d5
	moveq	#$9,d0
	cmp.l	d6,d0
	blt.b	.lFF3272
	move.b	d6,d0
	moveq	#$30,d1
	add.b	d1,d0
	move.b	d0,(a4,d7.l)
	bra.b	.lFF327C
.lFF3272	move.b	d6,d0
	moveq	#-55,d1
	sub.b	d1,d0
	move.b	d0,(a4,d7.l)
.lFF327C	move.l	d7,d0
	subq.l	#$1,d7
DispatchTail_45	cmp.l	d7,d3
	ble.b	DispatchTail_44
	clr.b	(a4,d4.w)
	movem.l	-$18(a6),d3-d7/a4
	unlk	a6
	rts
; HexStr
	dc.b	$86,'HexStr',$00,$00,$00	; .HexStr...
aprint_A	; Sierra C function name tag: aprint (first copy of the module)
	link	a6,#$FED8
	movem.l	d4-d7/a3-a4,-(sp)
	lea.l	-$128(a6),a4
	bra.w	DispatchTail_58
DispatchTail_47	cmpi.b	#$25,d6
	beq.b	.lFF32B8
	move.b	d6,(a3)+
	bra.w	DispatchTail_57
.lFF32B8	moveq	#$8,d4
	movea.l	$8(a6),a0
	addq.l	#$1,$8(a6)
	move.b	(a0),d6
	move.b	d6,d0
	subi.b	#$2A,d0
	bne.b	.lFF32E4
	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.w	-$2(a0),d4
	move.l	$8(a6),d0
	addq.l	#$1,$8(a6)
	movea.l	d0,a0
	move.b	(a0),d6
.lFF32E4	move.b	d6,d0
	subi.b	#$25,d0
	beq.w	DispatchTail_56
	subi.b	#$2E,d0
	beq.b	DispatchTail_53
	subq.b	#$5,d0
	beq.b	DispatchTail_50
	subi.b	#$C,d0
	beq.b	.lFF330C
	subi.b	#$F,d0
	beq.b	DispatchTail_53
	subq.b	#$5,d0
	beq.b	DispatchTail_50
	bra.w	DispatchTail_57
.lFF330C	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.l	-$4(a0),d5
	move.l	a4,-(sp)
	ext.l	d4
	move.l	d4,-(sp)
	move.l	d5,-(sp)
	jsr	NumStr_A(pc)
	clr.w	d7
	lea.l	$C(sp),sp
	bra.b	DispatchTail_49
DispatchTail_48	move.b	(a4,d7.w),(a3)+
	move.w	d7,d0
	addq.w	#$1,d7
DispatchTail_49	tst.b	(a4,d7.w)
	bne.b	DispatchTail_48
	bra.b	DispatchTail_57
DispatchTail_50	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.l	-$4(a0),d5
	move.l	a4,-(sp)
	ext.l	d4
	move.l	d4,-(sp)
	move.l	d5,-(sp)
	jsr	HexStr_A(pc)
	clr.w	d7
	lea.l	$C(sp),sp
	bra.b	DispatchTail_52
DispatchTail_51	move.b	(a4,d7.w),(a3)+
	move.w	d7,d0
	addq.w	#$1,d7
DispatchTail_52	tst.b	(a4,d7.w)
	bne.b	DispatchTail_51
	bra.b	DispatchTail_57
DispatchTail_53	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.l	-$4(a0),-$8(a6)
	bra.b	DispatchTail_55
DispatchTail_54	move.l	-$8(a6),d0
	addq.l	#$1,-$8(a6)
	movea.l	d0,a0
	move.b	(a0),(a3)+
DispatchTail_55	movea.l	-$8(a6),a0
	tst.b	(a0)
	bne.b	DispatchTail_54
	bra.b	DispatchTail_57
DispatchTail_56	move.b	d6,(a3)+
DispatchTail_57	move.l	$8(a6),d0
	addq.l	#$1,$8(a6)
	movea.l	d0,a0
	move.b	(a0),d6
	bne.w	DispatchTail_47
	clr.b	(a3)+
	pea.l	-$108(a6)
	jsr	drawprint_A(pc)
	addq.w	#$4,sp
DispatchTail_58	movem.l	-$140(a6),d4-d7/a3-a4
	unlk	a6
	rts
; aprint
	dc.b	$86,'aprint',$00,$00,$00	; .aprint...
InitWorld_A	; Sierra C function name tag: InitWorld (first copy of the module)
	link	a6,#$0
	movea.l	#$A12010,a0
	clr.w	(a0)
	movea.l	#$A12010,a0
	clr.w	$2(a0)
	lea.l	DispatchTail_12(pc),a0
	moveq	#$4,d0
	move.l	d0,$5C(a0)
	lea.l	DispatchTail_12(pc),a0
	move.l	d0,$60(a0)
	pea.l	LFF3444(pc)
	jsr	aprint_A(pc)
	lea.l	DispatchTail_12(pc),a0
	move.l	$54(a0),-(sp)
	pea.l	LFF3434(pc)
	jsr	aprint_A(pc)
	lea.l	DispatchTail_12(pc),a0
	move.l	$58(a0),-(sp)
	pea.l	LFF3424(pc)
	jsr	aprint_A(pc)
	unlk	a6
	rts
; InitWorld
	dc.b	$89,'InitWorld',$00,'2Heap'	; .InitWorld.2Heap
	dc.b	' Size : %x',$00,$00,'Heap'	;  Size : %x..Heap
	dc.b	' Start: %x',$00,$00,'MAIN'	;  Start: %x..MAIN
	dc.b	'CPU is alive',$00,$00	; CPU is alive..
; Waits for a command word from the sub CPU ($A12020) (Sierra tag GetCommandFromSub).
GetCommandFromSub_A	; Sierra C function name tag: GetCommandFromSub (first copy of the module)
	link	a6,#$0
	movem.l	d7/a3-a4,-(sp)
	movea.l	#$A12010,a3
	movea.l	#$A12020,a4
.lFF346A	move.w	(a4),d7
	beq.b	.lFF346A
	move.w	#$1,(a3)
.lFF3472	tst.w	(a4)
	bne.b	.lFF3472
	clr.w	(a3)
	move.w	d7,d0
	movem.l	-$C(a6),d7/a3-a4
	unlk	a6
	rts
; GetCommandFromSub
	dc.b	$91,'GetCommandFromS'	; .GetCommandFromS
	dc.b	$75,$62,$00,$00			; ub..
; Writes the word-RAM 1M flag word to the sub CPU comm port (Sierra tag Set1MFlag).
Set1MFlag_A	; Sierra C function name tag: Set1MFlag (first copy of the module)
	link	a6,#$0
	movea.l	#$A12010,a0
	move.w	$A(a6),$2(a0)
	unlk	a6
	rts
; Set1MFlag
	dc.b	$89,'Set1MFlag',$00,$00	; .Set1MFlag..

