; Sierra C name tag of the routine above (length byte, 'FilmClose', zero padding).
	dc.b	$89,'FilmClose',$00,$00	; .FilmClose..
; C function SwapMeg (Sierra C name tag follows it).
SwapMeg	link	a6,#$0
.loop	movea.l	#$FF8010,a0
	tst.w	$2(a0)
	bne.b	.loop
	eori.w	#$1,$FF8002.l
	unlk	a6
	rts
; Sierra C name tag of the routine above (length byte, 'SwapMeg', zero padding).
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
	bra.b	.next
.loop	ext.w	d7
	ext.l	d7
	move.l	d7,-(sp)
	jsr	SendCommandToMain(pc)
	addq.w	#$4,sp
.next	move.b	(a4)+,d7
	bne.b	.loop
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
; Sierra C name tag of the routine above (length byte, 'DrawText', zero padding).
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
.loop	move.l	d6,d0
	moveq	#$A,d1
	jsr	DataThunkB(pc)
	moveq	#$30,d1
	add.b	d1,d0
	move.w	d7,d1
	addq.w	#$1,d7
	move.b	d0,(a4,d1.w)
	move.l	d6,d0
	moveq	#$A,d1
	jsr	DataThunkA(pc)
	move.l	d0,d6
	bne.b	.loop
	bra.b	.next
.loop2	subq.w	#$1,d7
	move.b	(a4,d7.w),(a3)+
.next	tst.w	d7
	bne.b	.loop2
	movem.l	-$20(a6),d6-d7/a3-a4
	unlk	a6
	rts
; Sierra C name tag of the routine above (length byte, 'NumStr', zero padding).
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
	bra.b	.next3
.loop	moveq	#$F,d6
	and.l	d5,d6
	asr.l	#$4,d5
	moveq	#$9,d0
	cmp.l	d6,d0
	blt.b	.next
	move.b	d6,d0
	moveq	#$30,d1
	add.b	d1,d0
	move.b	d0,(a4,d7.l)
	bra.b	.next2
.next	move.b	d6,d0
	moveq	#-55,d1
	sub.b	d1,d0
	move.b	d0,(a4,d7.l)
.next2	move.l	d7,d0
	subq.l	#$1,d7
.next3	cmp.l	d7,d3
	ble.b	.loop
	clr.b	(a4,d4.w)
	movem.l	-$18(a6),d3-d7/a4
	unlk	a6
	rts
; Sierra C name tag of the routine above (length byte, 'HexStr', zero padding).
	dc.b	$86,'HexStr',$00,$00,$00	; .HexStr...
aprint	link	a6,#$FED8
	movem.l	d4-d7/a3-a4,-(sp)
	lea.l	-$128(a6),a4
	lea.l	-$108(a6),a3
	lea.l	$8(a6),a0
	addq.w	#$4,a0
	move.l	a0,-$4(a6)
	bra.w	.next10
.loop	cmpi.b	#$25,d6
	beq.b	.next
	move.b	d6,(a3)+
	bra.w	.next10
.next	moveq	#$8,d4
	movea.l	$8(a6),a0
	addq.l	#$1,$8(a6)
	move.b	(a0),d6
	move.b	d6,d0
	subi.b	#$2A,d0
	bne.b	.next2
	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.w	-$2(a0),d4
	move.l	$8(a6),d0
	addq.l	#$1,$8(a6)
	movea.l	d0,a0
	move.b	(a0),d6
.next2	move.b	d6,d0
	subi.b	#$25,d0
	beq.w	.next9
	subi.b	#$2E,d0
	beq.b	.next7
	subq.b	#$5,d0
	beq.b	.next5
	subi.b	#$C,d0
	beq.b	.next3
	subi.b	#$F,d0
	beq.b	.next7
	subq.b	#$5,d0
	beq.b	.next5
	bra.w	.next10
.next3	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.l	-$4(a0),d5
	move.l	a4,-(sp)
	ext.l	d4
	move.l	d4,-(sp)
	move.l	d5,-(sp)
	jsr	NumStr(pc)
	clr.w	d7
	lea.l	$C(sp),sp
	bra.b	.next4
.loop2	move.b	(a4,d7.w),(a3)+
	move.w	d7,d0
	addq.w	#$1,d7
.next4	tst.b	(a4,d7.w)
	bne.b	.loop2
	bra.b	.next10
.next5	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.l	-$4(a0),d5
	move.l	a4,-(sp)
	ext.l	d4
	move.l	d4,-(sp)
	move.l	d5,-(sp)
	jsr	HexStr(pc)
	clr.w	d7
	lea.l	$C(sp),sp
	bra.b	.next6
.loop3	move.b	(a4,d7.w),(a3)+
	move.w	d7,d0
	addq.w	#$1,d7
.next6	tst.b	(a4,d7.w)
	bne.b	.loop3
	bra.b	.next10
.next7	addq.l	#$4,-$4(a6)
	movea.l	-$4(a6),a0
	move.l	-$4(a0),-$8(a6)
	bra.b	.next8
.loop4	move.l	-$8(a6),d0
	addq.l	#$1,-$8(a6)
	movea.l	d0,a0
	move.b	(a0),(a3)+
.next8	movea.l	-$8(a6),a0
	tst.b	(a0)
	bne.b	.loop4
	bra.b	.next10
.next9	move.b	d6,(a3)+
.next10	move.l	$8(a6),d0
	addq.l	#$1,$8(a6)
	movea.l	d0,a0
	move.b	(a0),d6
	bne.w	.loop
	clr.b	(a3)+
	pea.l	-$108(a6)
	jsr	DrawText(pc)
	addq.w	#$4,sp
	movem.l	-$140(a6),d4-d7/a3-a4
	unlk	a6
	rts
; Sierra C name tag of the routine above (length byte, 'aprint', zero padding).
	dc.b	$86,'aprint',$00,$00,$00	; .aprint...
ffree	link	a6,#$0
	movem.l	a3-a4,-(sp)
	movea.l	$8(a6),a3
	movea.l	a3,a4
	lea.l	-$10(a4),a4
	move.l	a3,d0
	beq.b	.next
	moveq	#$48,d0
	cmp.b	(a4),d0
	bne.b	.next
	moveq	#$42,d0
	cmp.b	$1(a4),d0
	beq.b	.next2
.next	move.l	a4,-(sp)
	pea.l	.next8(pc)
	jsr	aprint(pc)
	addq.w	#$8,sp
	bra.b	.next6
.next2	tst.w	$2(a4)
	bne.b	.next3
	move.l	a4,-(sp)
	pea.l	.next7(pc)
	jsr	aprint(pc)
	addq.w	#$8,sp
	bra.b	.next6
.next3	tst.l	$4(a4)
	beq.b	.next4
	movea.l	$4(a4),a0
	tst.w	$2(a0)
	bne.b	.next4
	move.l	$8(a4),$8(a0)
	movea.l	$4(a4),a4
	movea.l	$8(a4),a0
	move.l	a4,$4(a0)
.next4	movea.l	$8(a4),a0
	tst.w	$2(a0)
	bne.b	.next5
	movea.l	$8(a0),a0
	move.l	a0,$8(a4)
	move.l	a4,$4(a0)
.next5	clr.w	$2(a4)
.next6	movem.l	-$8(a6),a3-a4
	unlk	a6
	rts
; Sierra C name tag of the routine above (length byte, 'ffree', zero padding).
	dc.b	$85,'ffree',$00,$40	; .ffree.@
; Text of ffree (2 rows).
.next7	dc.b	'Tried to ffree a'	; Tried to ffree a
	dc.b	' free block: %x',$00	;  free block: %x.
; Text of ffree (2 rows).
.next8	dc.b	'Tried to ffree a'	; Tried to ffree a
	dc.b	' bad block: %x',$00,$00	;  bad block: %x..
findSmallestBlock	link	a6,#$0
	movem.l	d5-d7/a3-a4,-(sp)
	move.l	$8(a6),d5
	lea.l	FilmEntryVector(pc),a0
	movea.l	$8(a0),a4
	moveq	#$0,d0
	movea.l	d0,a3
	move.l	#$7FFFFFFF,d6
	bra.b	.next2
.loop	tst.w	$2(a4)
	bne.b	.next
	move.l	$8(a4),d0
	sub.l	a4,d0
	move.l	d0,d7
	moveq	#$10,d0
	sub.l	d0,d7
	cmp.l	d7,d5
	bge.b	.next
	cmp.l	d7,d6
	ble.b	.next
	move.l	d7,d6
	movea.l	a4,a3
.next	movea.l	$8(a4),a4
.next2	move.l	a4,d0
	bne.b	.loop
	move.l	a3,d0
	movem.l	-$14(a6),d5-d7/a3-a4
	unlk	a6
	rts
; Sierra C name tag of the routine above (length byte, 'findSmallestBlo', zero padding).
	dc.b	$91,'findSmallestBlo'	; .findSmallestBlo
	dc.b	$63,$6B,$00,$00	; ck..
MaxFree	link	a6,#$0
	movem.l	d6-d7/a4,-(sp)
	lea.l	FilmEntryVector(pc),a0
	movea.l	$8(a0),a4
	moveq	#-1,d6
	bra.b	.next2
.loop	tst.w	$2(a4)
	bne.b	.next
	move.l	$8(a4),d0
	sub.l	a4,d0
	move.l	d0,d7
	moveq	#$10,d0
	sub.l	d0,d7
	cmp.l	d7,d6
	bge.b	.next
	move.l	d7,d6
.next	movea.l	$8(a4),a4
.next2	move.l	a4,d0
	bne.b	.loop
	move.l	d6,d0
	movem.l	-$C(a6),d6-d7/a4
	unlk	a6
	rts
; Sierra C name tag of the routine above (length byte, 'MaxFree', zero padding).
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
	bne.b	.next
	moveq	#$0,d0
	bra.b	.next3
.next	move.l	$8(a3),d0
	sub.l	a3,d0
	move.l	d0,d6
	moveq	#$10,d0
	sub.l	d0,d6
	move.l	d7,d1
	moveq	#$18,d2
	add.l	d2,d1
	cmp.l	d6,d1
	bge.b	.next2
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
.next2	move.w	#$1,$2(a3)
	move.l	a3,d0
	moveq	#$10,d1
	add.l	d1,d0
.next3	movem.l	-$10(a6),d6-d7/a3-a4
	unlk	a6
	rts
; Sierra C name tag of the routine above (length byte, 'mmalloc', zero padding).
	dc.b	$87,'mmalloc',$00,$00	; .mmalloc..
InitHeap	link	a6,#$0
	movem.l	a3-a4,-(sp)
	lea.l	FilmEntryVector(pc),a0
	movea.l	$8(a0),a3
	lea.l	FilmEntryVector(pc),a0
	lea.l	FilmEntryVector(pc),a1
	move.l	$C(a1),d0
	add.l	$8(a0),d0
	movea.l	d0,a4
	lea.l	-$10(a4),a4
; Writes a heap block header
InitHeapBlock	move.b	#$48,(a3)
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
; Sierra C name tag of the routine above (length byte, 'InitHeap', zero padding).
	dc.b	$88,'InitHeap',$00,$00,$00	; .InitHeap...
; C function InitWorld (Sierra C name tag follows it).
InitWorld	link	a6,#$0
	move.l	d7,-(sp)
	clr.w	$FF8020.l
	pea.l	.next6(pc)
	jsr	aprint(pc)
	lea.l	FilmEntryVector(pc),a0
	moveq	#$F,d7
	and.l	$8(a0),d7
	tst.l	d7
	addq.w	#$4,sp
	beq.b	.next
	pea.l	.next5(pc)
	jsr	aprint(pc)
	addq.w	#$4,sp
.next	lea.l	FilmEntryVector(pc),a0
	move.l	$8(a0),d0
	moveq	#$F,d1
	add.l	d1,d0
	moveq	#-16,d2
	and.l	d0,d2
	lea.l	FilmEntryVector(pc),a0
	move.l	d2,$8(a0)
	lea.l	FilmEntryVector(pc),a0
	move.l	$C(a0),d0
	sub.l	d7,d0
	moveq	#-16,d2
	and.l	d0,d2
	lea.l	FilmEntryVector(pc),a0
	move.l	d2,$C(a0)
	lea.l	FilmEntryVector(pc),a0
	move.l	$8(a0),-(sp)
	pea.l	.next4(pc)
	jsr	aprint(pc)
	lea.l	FilmEntryVector(pc),a0
	move.l	$C(a0),-(sp)
	pea.l	.next3(pc)
	jsr	aprint(pc)
	lea.l	FilmEntryVector(pc),a0
	tst.l	$C(a0)
	lea.l	$10(sp),sp
	beq.b	.next2
	jsr	InitHeap(pc)
.next2	move.l	-$4(a6),d7
	unlk	a6
	rts
; Sierra C name tag of the routine above (length byte, 'InitWorld', zero padding).
	dc.b	$89,'InitWorld',$00,$3C	; .InitWorld.<
; Text of InitWorld (1 row).
.next3	dc.b	'Heap Size : %x',$00,$00	; Heap Size : %x..
; Text of InitWorld (1 row).
.next4	dc.b	'Heap Start: %x',$00,$00	; Heap Start: %x..
; Text of InitWorld (1 row).
.next5	dc.b	'Fixing Heap',$00	; Fixing Heap.
; Text of InitWorld (1 row).
.next6	dc.b	'SUBCPU is alive',$00	; SUBCPU is alive.
GetTicks	link	a6,#$0
	lea.l	FilmEntryVector(pc),a0
	move.l	$4(a0),d0
	unlk	a6
	rts
; Sierra C name tag of the routine above (length byte, 'GetTicks', zero padding).
	dc.b	$88,'GetTicks',$00,$00,$00	; .GetTicks...
; C function WaitIODone (Sierra C name tag follows it).
WaitIODone	link	a6,#$0
.loop	lea.l	FilmEntryVector(pc),a0
	tst.l	$10(a0)
	bne.b	.loop
	unlk	a6
	rts
; Sierra C name tag of the routine above (length byte, 'WaitIODone', zero padding).
	dc.b	$8A,'WaitIODone',$00,$00,$00	; .WaitIODone...
