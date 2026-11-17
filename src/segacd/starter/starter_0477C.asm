	dc.b	$89,'FilmClose',$00,$00	; .FilmClose..
; C function SwapMeg (Sierra C name tag follows it).
SwapMeg	link	a6,#$0
.l478C	movea.l	#$FF8010,a0
	tst.w	$2(a0)
	bne.b	.l478C
	eori.w	#$1,$FF8002.l
	unlk	a6
	rts
	dc.b	$87,'SwapMeg',$00,$00	; .SwapMeg..
DrawText	link	a6,#$0
	movem.l	d7/a4,-(sp)
	movea.l	$8(a6),a4
	moveq	#$1,d0
	move.l	d0,-(sp)
	jsr	SendCommandToMain(pc)
	moveq	#$3C,d0
	move.l	d0,-(sp)
	jsr	SendCommandToMain(pc)
	addq.w	#$8,sp
	bra.b	.l47DA
.l47CE	ext.w	d7
	ext.l	d7
	move.l	d7,-(sp)
	jsr	SendCommandToMain(pc)
	addq.w	#$4,sp
.l47DA	move.b	(a4)+,d7
	bne.b	.l47CE
	moveq	#$3E,d0
	move.l	d0,-(sp)
	jsr	SendCommandToMain(pc)
	moveq	#$1,d0
	move.l	d0,-(sp)
	jsr	SendCommandToMain(pc)
	addq.w	#$8,sp
	movem.l	-$8(a6),d7/a4
	unlk	a6
	rts
	dc.b	$88,'DrawText',$00,$00,$00	; .DrawText...
NumStr	link	a6,#$FFF0
	movem.l	d6-d7/a3-a4,-(sp)
	movea.l	$10(a6),a3
	lea.l	-$10(a6),a4
	move.l	$8(a6),d6
	clr.w	d7
	move.w	d7,d0
	addq.w	#$1,d7
	clr.b	(a4,d0.w)
.l4824	move.l	d6,d0
	moveq	#$A,d1
	jsr	GetData_16(pc)
	moveq	#$30,d1
	add.b	d1,d0
	move.w	d7,d1
	addq.w	#$1,d7
	move.b	d0,(a4,d1.w)
	move.l	d6,d0
	moveq	#$A,d1
	jsr	GetData_15(pc)
	move.l	d0,d6
	bne.b	.l4824
	bra.b	.l484C
.l4846	subq.w	#$1,d7
	move.b	(a4,d7.w),(a3)+
.l484C	tst.w	d7
	bne.b	.l4846
	movem.l	-$20(a6),d6-d7/a3-a4
	unlk	a6
	rts
	dc.b	$86,'NumStr',$00,$00,$00	; .NumStr...
HexStr	link	a6,#$0
	movem.l	d3-d7/a4,-(sp)
	move.w	$E(a6),d4
	move.l	$8(a6),d5
	movea.l	$10(a6),a4
	ext.l	d4
	move.l	d4,d7
	subq.l	#$1,d7
	moveq	#$0,d3
	bra.b	.l48A8
.l4882	moveq	#$F,d6
	and.l	d5,d6
	asr.l	#$4,d5
	moveq	#$9,d0
	cmp.l	d6,d0
	blt.b	.l489A
	move.b	d6,d0
	moveq	#$30,d1
	add.b	d1,d0
	move.b	d0,(a4,d7.l)
	bra.b	.l48A4
.l489A	move.b	d6,d0
	moveq	#-55,d1
	sub.b	d1,d0
	move.b	d0,(a4,d7.l)
.l48A4	move.l	d7,d0
	subq.l	#$1,d7
.l48A8	cmp.l	d7,d3
	ble.b	.l4882
	clr.b	(a4,d4.w)
	movem.l	-$18(a6),d3-d7/a4
	unlk	a6
	rts
	dc.b	$86,'HexStr',$00,$00,$00	; .HexStr...
aprint	link	a6,#$FED8
	movem.l	d4-d7/a3-a4,-(sp)
	lea.l	-$128(a6),a4
	lea.l	-$108(a6),a3
	lea.l	$8(a6),a0
	addq.w	#$4,a0
	move.l	a0,-$4(a6)
	bra.w	.l49CA
.l48E2	cmpi.b	#$25,d6
	beq.b	.l48EE
	move.b	d6,(a3)+
	bra.w	.l49CA
.l48EE	moveq	#$8,d4
	movea.l	$8(a6),a0
	addq.l	#$1,$8(a6)
	move.b	(a0),d6
	move.b	d6,d0
	subi.b	#$2A,d0
	bne.b	.l491A
	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.w	-$2(a0),d4
	move.l	$8(a6),d0
	addq.l	#$1,$8(a6)
	movea.l	d0,a0
	move.b	(a0),d6
.l491A	move.b	d6,d0
	subi.b	#$25,d0
	beq.w	.l49C8
	subi.b	#$2E,d0
	beq.b	.l49A2
	subq.b	#$5,d0
	beq.b	.l4972
	subi.b	#$C,d0
	beq.b	.l4942
	subi.b	#$F,d0
	beq.b	.l49A2
	subq.b	#$5,d0
	beq.b	.l4972
	bra.w	.l49CA
.l4942	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.l	-$4(a0),d5
	move.l	a4,-(sp)
	ext.l	d4
	move.l	d4,-(sp)
	move.l	d5,-(sp)
	jsr	NumStr(pc)
	clr.w	d7
	lea.l	$C(sp),sp
	bra.b	.l496A
.l4962	move.b	(a4,d7.w),(a3)+
	move.w	d7,d0
	addq.w	#$1,d7
.l496A	tst.b	(a4,d7.w)
	bne.b	.l4962
	bra.b	.l49CA
.l4972	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.l	-$4(a0),d5
	move.l	a4,-(sp)
	ext.l	d4
	move.l	d4,-(sp)
	move.l	d5,-(sp)
	jsr	HexStr(pc)
	clr.w	d7
	lea.l	$C(sp),sp
	bra.b	.l499A
.l4992	move.b	(a4,d7.w),(a3)+
	move.w	d7,d0
	addq.w	#$1,d7
.l499A	tst.b	(a4,d7.w)
	bne.b	.l4992
	bra.b	.l49CA
.l49A2	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.l	-$4(a0),-$8(a6)
	bra.b	.l49BE
.l49B2	move.l	-$8(a6),d0
	addq.l	#$1,-$8(a6)
	movea.l	d0,a0
	move.b	(a0),(a3)+
.l49BE	movea.l	-$8(a6),a0
	tst.b	(a0)
	bne.b	.l49B2
	bra.b	.l49CA
.l49C8	move.b	d6,(a3)+
.l49CA	move.l	$8(a6),d0
	addq.l	#$1,$8(a6)
	movea.l	d0,a0
	move.b	(a0),d6
	bne.w	.l48E2
	clr.b	(a3)+
	pea.l	-$108(a6)
	jsr	DrawText(pc)
	addq.w	#$4,sp
	movem.l	-$140(a6),d4-d7/a3-a4
	unlk	a6
	rts
	dc.b	$86,'aprint',$00,$00,$00	; .aprint...
ffree	link	a6,#$0
	movem.l	a3-a4,-(sp)
	movea.l	$8(a6),a3
	movea.l	a3,a4
	lea.l	-$10(a4),a4
	move.l	a3,d0
	beq.b	.l4A1E
	moveq	#$48,d0
	cmp.b	(a4),d0
	bne.b	.l4A1E
	moveq	#$42,d0
	cmp.b	$1(a4),d0
	beq.b	.l4A2C
.l4A1E	move.l	a4,-(sp)
	pea.l	.l25DAE(pc)
	jsr	aprint(pc)
	addq.w	#$8,sp
	bra.b	.l4A7C
.l4A2C	tst.w	$2(a4)
	bne.b	.l4A40
	move.l	a4,-(sp)
	pea.l	.l25D8E(pc)
	jsr	aprint(pc)
	addq.w	#$8,sp
	bra.b	.l4A7C
.l4A40	tst.l	$4(a4)
	beq.b	.l4A62
	movea.l	$4(a4),a0
	tst.w	$2(a0)
	bne.b	.l4A62
	move.l	$8(a4),$8(a0)
	movea.l	$4(a4),a4
	movea.l	$8(a4),a0
	move.l	a4,$4(a0)
.l4A62	movea.l	$8(a4),a0
	tst.w	$2(a0)
	bne.b	.l4A78
	movea.l	$8(a0),a0
	move.l	a0,$8(a4)
	move.l	a4,$4(a0)
.l4A78	clr.w	$2(a4)
.l4A7C	movem.l	-$8(a6),a3-a4
	unlk	a6
	rts
	dc.b	$85,'ffree',$00,$40	; .ffree.@
.l25D8E	dc.b	'Tried to ffree a'	; Tried to ffree a
	dc.b	' free block: %x',$00	;  free block: %x.
.l25DAE	dc.b	'Tried to ffree a'	; Tried to ffree a
	dc.b	' bad block: %x',$00,$00	;  bad block: %x..
findSmallestBlock	link	a6,#$0
	movem.l	d5-d7/a3-a4,-(sp)
	move.l	$8(a6),d5
	lea.l	RestoreBios_97(pc),a0
	movea.l	$8(a0),a4
	moveq	#$0,d0
	movea.l	d0,a3
	move.l	#$7FFFFFFF,d6
	bra.b	.l4B10
.l4AEE	tst.w	$2(a4)
	bne.b	.l4B0C
	move.l	$8(a4),d0
	sub.l	a4,d0
	move.l	d0,d7
	moveq	#$10,d0
	sub.l	d0,d7
	cmp.l	d7,d5
	bge.b	.l4B0C
	cmp.l	d7,d6
	ble.b	.l4B0C
	move.l	d7,d6
	movea.l	a4,a3
.l4B0C	movea.l	$8(a4),a4
.l4B10	move.l	a4,d0
	bne.b	.l4AEE
	move.l	a3,d0
	movem.l	-$14(a6),d5-d7/a3-a4
	unlk	a6
	rts
	dc.b	$91,'findSmallestBlo'	; .findSmallestBlo
	dc.b	$63,$6B,$00,$00	; ck..
MaxFree	link	a6,#$0
	movem.l	d6-d7/a4,-(sp)
	lea.l	RestoreBios_97(pc),a0
	movea.l	$8(a0),a4
	moveq	#-1,d6
	bra.b	.l4B64
.l4B48	tst.w	$2(a4)
	bne.b	.l4B60
	move.l	$8(a4),d0
	sub.l	a4,d0
	move.l	d0,d7
	moveq	#$10,d0
	sub.l	d0,d7
	cmp.l	d7,d6
	bge.b	.l4B60
	move.l	d7,d6
.l4B60	movea.l	$8(a4),a4
.l4B64	move.l	a4,d0
	bne.b	.l4B48
	move.l	d6,d0
	movem.l	-$C(a6),d6-d7/a4
	unlk	a6
	rts
	dc.b	$87,'MaxFree',$00,$00	; .MaxFree..
mmalloc	link	a6,#$0
	movem.l	d6-d7/a3-a4,-(sp)
	move.l	$8(a6),d7
	move.l	d7,d0
	addq.l	#$7,d0
	moveq	#-8,d1
	and.l	d0,d1
	move.l	d1,d7
	move.l	d7,-(sp)
	jsr	findSmallestBlock(pc)
	movea.l	d0,a3
	move.l	a3,d0
	addq.w	#$4,sp
	bne.b	.l4BA6
	moveq	#$0,d0
	bra.b	.l4BFC
.l4BA6	move.l	$8(a3),d0
	sub.l	a3,d0
	move.l	d0,d6
	moveq	#$10,d0
	sub.l	d0,d6
	move.l	d7,d1
	moveq	#$18,d2
	add.l	d2,d1
	cmp.l	d6,d1
	bge.b	.l4BF0
	move.l	a3,d0
	moveq	#$10,d1
	add.l	d1,d0
	movea.l	d0,a4
	adda.l	d7,a4
	move.b	#$48,(a4)
	move.b	#$42,$1(a4)
	clr.w	$2(a4)
	move.l	a3,$4(a4)
	move.l	$8(a3),$8(a4)
	moveq	#$0,d0
	move.l	d0,$C(a4)
	movea.l	$8(a4),a0
	move.l	a4,$4(a0)
	move.l	a4,$8(a3)
.l4BF0	move.w	#$1,$2(a3)
	move.l	a3,d0
	moveq	#$10,d1
	add.l	d1,d0
.l4BFC	movem.l	-$10(a6),d6-d7/a3-a4
	unlk	a6
	rts
	dc.b	$87,'mmalloc',$00,$00	; .mmalloc..
InitHeap	link	a6,#$0
	movem.l	a3-a4,-(sp)
	lea.l	RestoreBios_97(pc),a0
	movea.l	$8(a0),a3
	lea.l	RestoreBios_97(pc),a0
	lea.l	RestoreBios_97(pc),a1
	move.l	$C(a1),d0
	add.l	$8(a0),d0
	movea.l	d0,a4
	lea.l	-$10(a4),a4
InitHeapSub2	move.b	#$48,(a3)
	move.b	#$42,$1(a3)
	clr.w	$2(a3)
	moveq	#$0,d0
	move.l	d0,$4(a3)
	move.l	a4,$8(a3)
	move.l	d0,$C(a3)
	move.b	#$48,(a4)
	move.b	#$45,$1(a4)
	move.w	#$2,$2(a4)
	move.l	a3,$4(a4)
	move.l	d0,$8(a4)
	move.l	d0,$C(a4)
	movem.l	-$8(a6),a3-a4
	unlk	a6
	rts
	dc.b	$88,'InitHeap',$00,$00,$00	; .InitHeap...
; C function InitWorld (Sierra C name tag follows it).
InitWorld	link	a6,#$0
	move.l	d7,-(sp)
	clr.w	$FF8020.l
	pea.l	.l26052(pc)
	jsr	aprint(pc)
	lea.l	RestoreBios_97(pc),a0
	moveq	#$F,d7
	and.l	$8(a0),d7
	tst.l	d7
	addq.w	#$4,sp
	beq.b	.l4CB2
	pea.l	.l26046(pc)
	jsr	aprint(pc)
	addq.w	#$4,sp
.l4CB2	lea.l	RestoreBios_97(pc),a0
	move.l	$8(a0),d0
	moveq	#$F,d1
	add.l	d1,d0
	moveq	#-16,d2
	and.l	d0,d2
	lea.l	RestoreBios_97(pc),a0
	move.l	d2,$8(a0)
	lea.l	RestoreBios_97(pc),a0
	move.l	$C(a0),d0
	sub.l	d7,d0
	moveq	#-16,d2
	and.l	d0,d2
	lea.l	RestoreBios_97(pc),a0
	move.l	d2,$C(a0)
	lea.l	RestoreBios_97(pc),a0
	move.l	$8(a0),-(sp)
	pea.l	.l26036(pc)
	jsr	aprint(pc)
	lea.l	RestoreBios_97(pc),a0
	move.l	$C(a0),-(sp)
	pea.l	.l26026(pc)
	jsr	aprint(pc)
	lea.l	RestoreBios_97(pc),a0
	tst.l	$C(a0)
	lea.l	$10(sp),sp
	beq.b	.l4D12
	jsr	InitHeap(pc)
.l4D12	move.l	-$4(a6),d7
	unlk	a6
	rts
	dc.b	$89,'InitWorld',$00,$3C	; .InitWorld.<
.l26026	dc.b	'Heap Size : %x',$00,$00	; Heap Size : %x..
.l26036	dc.b	'Heap Start: %x',$00,$00	; Heap Start: %x..
.l26046	dc.b	'Fixing Heap',$00	; Fixing Heap.
.l26052	dc.b	'SUBCPU is alive',$00	; SUBCPU is alive.
GetTicks	link	a6,#$0
	lea.l	RestoreBios_97(pc),a0
	move.l	$4(a0),d0
	unlk	a6
	rts
	dc.b	$88,'GetTicks',$00,$00,$00	; .GetTicks...
; C function WaitIODone (Sierra C name tag follows it).
WaitIODone	link	a6,#$0
.l4D82	lea.l	RestoreBios_97(pc),a0
	tst.l	$10(a0)
	bne.b	.l4D82
	unlk	a6
	rts
	dc.b	$8A,'WaitIODone',$00,$00,$00	; .WaitIODone...
