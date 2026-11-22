UnpackNibbles						;a0 = packed data, d0 = count: unpack 4-bit values into words at
									;nibblebuffer
	movem.l	d0-d2/a0-a1,-(sp)
	movea.l	#nibblebuffer,a1		;a1 = output words
	clr.w	d2		;d2 bit 0 = which nibble is next
	bra.w	.next2
.loop	move.b	(a0)+,d1		;next nibble (one count per pass)
	bchg	#$0,d2		;toggle high/low nibble
	bne.w	.lo		;low nibble?
	suba.w	#$1,a0		;high nibble: read the same byte again next time
	lsr.w	#$4,d1		;high nibble down
.lo	andi.w	#$F,d1
	move.w	d1,(a1)+
.next2	dbra	d0,.loop
	movem.l	(sp)+,d0-d2/a0-a1
	rts
WeightedRandomSelect						;d0 = number of word weights at nibblebuffer:
									;return a weighted random index
	movem.l	d1/a1,-(sp)
	movea.l	#nibblebuffer,a1		;weights
	clr.w	d1		;d1 = running total of the weights
	bra.w	.next
.sumloop	add.w	(a1)+,d1
.next	dbra	d0,.sumloop
	move.w	d1,d0
	bsr.w	randomd0		;random 0 to total-1
.findloop	sub.w	-(a1),d0		;minus the weight
	bpl.w	.findloop
	suba.l	#nibblebuffer,a1
	move.w	a1,d0
	lsr.w	#$1,d0		;word offset -> index
	movem.l	(sp)+,d1/a1
	rts
; Pushes the vram write flag on the gate array queue
QueueVramWriteFlag
	move.l	a6,-(sp)
	movea.l	(DiscDmaListPtr).l,a6
	btst	#$5,$FF800F.l
	beq.s	.next
	move.w	#$1,-(a6)
	bra.s	.next2
.next	move.w	#$0,-(a6)
.next2	bclr	#$5,$FF800F.l
	move.l	a6,(DiscDmaListPtr).l
	movea.l	(sp)+,a6
remap
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movem.l	d0-d4/a0-a2,-(sp)
	exg.l	d0,d1
	movea.l	a0,a2
	bsr.w	SetVramWriteAddr1
	subi.w	#$1,d1
.loop	moveq	#$3,d0
	move.w	(a2)+,d2
	clr.w	d3
.loop2	move.w	d2,d4
	andi.w	#$F,d4
	lsr.w	#$1,d4
	move.b	(a1,d4.w),d4
	btst	#$0,d2
	bne.w	.next3
	lsr.w	#$4,d4
.next3	andi.w	#$F,d4
	or.b	d4,d3
	ror.w	#$4,d3
	ror.w	#$4,d2
	dbra	d0,.loop2
.loop3	btst	#$7,$FF800E.l
	bne.b	.loop3
	move.w	d3,$FF8022.l
	move.w	#$D,$FF8020.l
	bset	#$6,$FF800F.l
.loop4	btst	#$6,$FF800E.l
	beq.b	.loop4
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop5	btst	#$6,$FF800E.l
	bne.b	.loop5
	bclr	#$7,$FF800F.l
	dbra	d1,.loop
	movem.l	(sp)+,d0-d4/a0-a2
	move.w	(sp)+,(disflags).l
	move.l	a6,-(sp)
	movea.l	(DiscDmaListPtr).l,a6
	tst.w	(a6)+
	beq.s	.next4
	bset	#$5,$FF800F.l
	bra.s	.next5
.next4	bclr	#$5,$FF800F.l
.next5	move.l	a6,(DiscDmaListPtr).l
	movea.l	(sp)+,a6
	rts
forceblack
	movem.l	d0/a0,-(sp)
	movea.l	#palfadenew,a0
	moveq	#$1F,d0
.0	move.l	(a0),-(sp)
	clr.l	(a0)+
	dbra	d0,.0
	move.w	#$18,(palcount).l
	bsr.w	ForceBlackBegin
	moveq	#$1F,d0
.1	move.l	(sp)+,-(a0)
	dbra	d0,.1
	movem.l	(sp)+,d0/a0
	rts
forceblack2
	movem.l	d0/a0,-(sp)
	movea.l	#palfadenew,a0
	moveq	#$1F,d0
.loop	move.l	(a0),-(sp)
	clr.l	(a0)+
	dbra	d0,.loop
	move.w	#$64,(palcount).l
	bsr.w	ForceBlackBegin
	moveq	#$1F,d0
.loop2	move.l	(sp)+,-(a0)
	dbra	d0,.loop2
	movem.l	(sp)+,d0/a0
	rts
; Saves the VBint and flags and installs the fade handler.
ForceBlackBegin
	move.l	(VBint).l,-(sp)
	move.w	(disflags).l,-(sp)
	bclr	#$2,(disflags).l
	move.l	#vb2,(VBint).l
	move.l	a6,-(sp)
	movea.l	(DiscDmaListPtr).l,a6
	btst	#$5,$FF800F.l
	beq.s	.next
	move.w	#$1,-(a6)
	bra.s	.next2
.next	move.w	#$0,-(a6)
.next2	bclr	#$5,$FF800F.l
	move.l	a6,(DiscDmaListPtr).l
	movea.l	(sp)+,a6
	bset	#$5,$FF800F.l
.loop	tst.w	(palcount).l
	bpl.w	.loop
	move.l	a6,-(sp)
	movea.l	(DiscDmaListPtr).l,a6
	tst.w	(a6)+
	beq.s	.next3
	bset	#$5,$FF800F.l
	bra.s	.next4
.next3	bclr	#$5,$FF800F.l
.next4	move.l	a6,(DiscDmaListPtr).l
	movea.l	(sp)+,a6
	move.w	(sp)+,(disflags).l
	move.l	(sp)+,(VBint).l
	rts

; One fade countdown step.
cramfade
	tst.w	(palcount).l
	bmi.w	rtss2
	cmpi.w	#$64,(palcount).l
	beq.w	.next
	subq.w	#$1,(palcount).l
	bmi.w	rtss2
	clr.l	d0
	move.w	(palcount).l,d0
	cmpi.w	#$18,d0
	bgt.w	rtss2
	divu.w	#$3,d0
	swap	d0
	asl.w	#$2,d0
	moveq	#$2,d3
	asl.w	d0,d3
	moveq	#$E,d5
	asl.w	d0,d5
	move.w	d5,d4
	not.w	d4
	move.l	d3,$BBC88.l
	move.l	d4,$BBC8C.l
	move.l	d5,$BBC90.l
	jsr	(RaiseGateRequest).l
.loop	btst	#$4,$FF800E.l
	bne.b	.loop
	move.w	#$1D,$FF8026.l
	bset	#$3,$FF800F.l
.loop2	btst	#$3,$FF800E.l
	beq.b	.loop2
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.loop3	btst	#$3,$FF800E.l
	bne.b	.loop3
	bclr	#$4,$FF800F.l
	jsr	(WaitGateAck).l
	rts
.next	movem.l	d0/a0-a1,-(sp)
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movea.l	#palfadenew,a1
	movea.l	#$C00000,a0
.loop4	btst	#$4,$FF800E.l
	bne.b	.loop4
	move.w	#$30,$FF8026.l
	move.l	#$C0000000,$FF8028.l
	bset	#$3,$FF800F.l
.loop5	btst	#$3,$FF800E.l
	beq.b	.loop5
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.loop6	btst	#$3,$FF800E.l
	bne.b	.loop6
	bclr	#$4,$FF800F.l
	moveq	#$1F,d0
.loop7	btst	#$4,$FF800E.l
	bne.b	.loop7
	move.w	#$33,$FF8026.l
	move.l	(a1)+,$FF8028.l
	bset	#$3,$FF800F.l
.loop8	btst	#$3,$FF800E.l
	beq.b	.loop8
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.loop9	btst	#$3,$FF800E.l
	bne.b	.loop9
	bclr	#$4,$FF800F.l
	dbra	d0,.loop7
	st.b	(palcount).l
	move.w	(sp)+,(disflags).l
	movem.l	(sp)+,d0/a0-a1
	rts
; Sets colour RAM to black through the gate array.
CopyPaletteToCRAM
	movem.l	d0/a0-a1,-(sp)
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movea.l	#palfadenew,a1
	movea.l	#$C00000,a0
.loop10	btst	#$7,$FF800E.l
	bne.b	.loop10
	move.l	#$C0000000,$FF8022.l
	move.w	#$B,$FF8020.l
	bset	#$6,$FF800F.l
.loop11	btst	#$6,$FF800E.l
	beq.b	.loop11
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop12	btst	#$6,$FF800E.l
	bne.b	.loop12
	bclr	#$7,$FF800F.l
	moveq	#$1F,d0
.loop13	btst	#$7,$FF800E.l
	bne.b	.loop13
	move.l	(a1)+,$FF8022.l
	move.w	#$E,$FF8020.l
	bset	#$6,$FF800F.l
.loop14	btst	#$6,$FF800E.l
	beq.b	.loop14
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop15	btst	#$6,$FF800E.l
	bne.b	.loop15
	bclr	#$7,$FF800F.l
	dbra	d0,.loop13
	st.b	(palcount).l
	move.w	(sp)+,(disflags).l
	movem.l	(sp)+,d0/a0-a1
	rts
randomd0s
	move.w	d0,-(sp)
	asl.w	#$1,d0
	bsr.w	randomd0
	sub.w	(sp)+,d0
	rts
randomd0						;d0 = range. Return random number in d0 (0 <= d0 < range)
	movem.l	d0-d2,-(sp)
	move.w	$18C1A.l,d0
	move.w	d0,d1
	move.w	(seed).l,d2
	mulu.w	#$E62D,d0
	mulu.w	#$BB40,d1
	mulu.w	#$E62D,d2
	add.w	d2,d1
	swap	d0
	add.w	d1,d0
	swap	d0
	addq.l	#$1,d0
	move.l	d0,(seed).l
	asr.l	#$8,d0
	mulu.w	$2(sp),d0
	swap	d0
	addq.w	#$4,sp
	movem.l	(sp)+,d1-d2
	rts
Sroot						;Square Root, this returns (d0.L)^.5 in d0. Large values use a binary
	
	tst.l	d0
	beq.w	rtss2
	cmpi.l	#$640,d0
	bhi.w	.m2
	move.l	d1,-(sp)
	moveq	#-1,d1
.0	addq.w	#$2,d1
	sub.w	d1,d0
	bcc.w	.0
	lsr.w	#$1,d1
	move.w	d1,d0
	move.l	(sp)+,d1
	rts
.m2	movem.l	d1-d4,-(sp)
	moveq	#$9,d3
	move.w	#$8000,d1
	cmpi.l	#$F00000,d0
	bhi.w	.big
	move.l	d0,d1
	lsr.l	#$8,d1
	addi.w	#$2,d1
.top	move.w	d1,d2
	move.l	d0,d1
	divu.w	d2,d1
	add.w	d2,d1
	lsr.w	#$1,d1
	cmp.w	d1,d2
	dbeq	d3,.top
.done	move.w	d1,d0
	movem.l	(sp)+,d1-d4
	rts
.big	moveq	#$0,d1
	moveq	#-1,d2
.bs	move.w	d1,d3
	add.w	d2,d3
	roxr.w	#$1,d3
	cmp.w	d3,d1
	beq.w	.done
	move.w	d3,d4
	mulu.w	d3,d3
	cmp.l	d3,d0
	bcc.w	.lo
	move.w	d4,d2
	bra.w	.bs
.lo	move.w	d4,d1
	bra.w	.bs
sfx						;play sound effect number. One word passed on stack
	move.l	d0,-(sp)
	move.w	$8(sp),d0
	bmi.w	.none
	move.w	d0,(lastsfx).l
	move.w	d0,$FF8022.l
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.w	#$26,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
.none	movem.l	(sp)+,d0
	move.l	(sp),$2(sp)
	addq.w	#$2,sp
	rts
; disc only: sfx for code that runs inside the vblank. Sends the sound number (one word on the stack)
; to the main CPU as vblank command $34, which runs the same Z80 sound call as sfx's command $26.
; Unlike sfx it does not skip negative numbers or set lastsfx.
sfx_vblank	move.l	d0,-(sp)
	move.w	$8(sp),d0
	move.w	d0,$FF8028.l
.loop	btst.b	#$4,$FF800E.l
	bne.b	.loop
	move.w	#$34,$FF8026.l
	bset.b	#$3,$FF800F.l
.loop2	btst.b	#$3,$FF800E.l
	beq.b	.loop2
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop3	btst.b	#$3,$FF800E.l
	bne.b	.loop3
	bclr.b	#$4,$FF800F.l
	movem.l	(sp)+,d0
	move.l	(sp),$2(sp)
	addq.w	#$2,sp
	rts	
song						;play song number. One word passed on stack
	move.l	d0,-(sp)
	move.w	$8(sp),d0
	cmpi.w	#$30,d0
	blt.w	.none
	cmpi.w	#$78,d0
	bge.w	.none
	move.w	#$1,$1745C.l
	subi.w	#$29,d0
	move.w	d0,$1745E.l
.none	movem.l	(sp)+,d0
	move.l	(sp),$2(sp)
	addq.w	#$2,sp
	rts
; Checks the CD (BIOS calls $80/$81) before a song starts.
SongCdCheck
	movem.l	d0-d2/a0-a1,-(sp)
	move.w	#$80,d0
	jsr	$5F22.w
	bcs.w	.next7
	move.w	#$81,d0
	jsr	$5F22.w
	move.w	(a0),d2
	andi.w	#$FF00,d2
	cmpi.w	#$500,d2
	bne.s	.next
	move.w	#$2,$1745E.l
	bra.s	.next4
.next	cmpi.w	#$100,d2
	bne.s	.next2
	move.b	$7(a0),d0
	cmpi.b	#$FF,d0
	beq.s	.next2
	cmpi.b	#$2,d0
	beq.s	.next2
	cmpi.b	#$7,$7(a0)
	bge.s	.next2
	move.w	#$2,$1745E.l
	bra.s	.next4
.next2	cmpi.w	#$0,d2
	bne.s	.next3
	bra.w	.next4
.next3	tst.w	$1745C.l
	ble.s	.next7
.next4	move.w	#$0,$1745C.l
	move.w	$1745E.l,(CdCommandArg).l
	cmpi.w	#$2,$1745E.l
	bne.s	.next5
	move.w	#$300,d1
	move.w	#$85,d0
	jsr	$5F22.w
	move.w	$1745E.l,(CdCommandArg).l
	bra.s	.next6
.next5	move.w	#$400,d1
	move.w	#$85,d0
	jsr	$5F22.w
.next6	lea.l	(CdCommandArg).l,a0
	move.w	#$12,d0
	jsr	$5F22.w
	move.w	#$12,d0
	lea.l	(CdCommandArg).l,a0
	jsr	$5F22.w
.next7	movem.l	(sp)+,d0-d2/a0-a1
	rts
waitx						;wait d0 vblanks or until input from either joystick. Return joystick
	
	
	clr.w	(waitxpad).l
	neg.w	d0
	move.w	d0,(Vcount).l
.wait	bsr.w	ReadJoy1
	or.w	d3,(waitxpad).l
	tst.w	d1
	bne.w	rtss2
	bsr.w	ReadJoy2
	or.w	d3,(waitxpad).l
	tst.w	d1
	bne.w	rtss2
	tst.w	(FourWayPlay).l
	beq.w	.1
	bsr.w	ReadJoy3
	or.w	d3,(waitxpad).l
	tst.w	d1
	bne.w	rtss2
	bsr.w	ReadJoy4
	or.w	d3,(waitxpad).l
	tst.w	d1
	bne.w	rtss2
.1	move.w	(Vcount).l,d0
.0	cmp.w	(Vcount).l,d0
	beq.w	.0
	tst.w	d0
	bmi.w	.wait		;still counting up to zero
	rts
waitxsr						;Wait d0 vblanks while the zamboni crosses
	movem.l	d4-d7/a0-a3,-(sp)
	neg.w	d0
	move.w	d0,(Vcount).l
.wait	cmpi.w	#$708,(Zamx).l
	bhi.w	.nz
	addi.w	#$1,(Zamx).l
.nz	moveq	#$1,d7
	jsr	(updatecrowdf).l
	jsr	(RunArenaAnim).l
	clr.w	(pausepad).l
	bclr	#sfpj,(sflags).l
	bsr.w	ReadJoy1
	bsr.w	ProcessInputWithRepeat
	tst.w	d1
	bne.w	.key
	clr.w	(pausepad).l
	bset	#sfpj,(sflags).l
	bsr.w	ReadJoy2
	bsr.w	ProcessInputWithRepeat
	tst.w	d1
	bne.w	.key
	tst.w	(FourWayPlay).l
	beq.w	.vid
	bclr	#sfpj,(sflags).l
	move.w	#$3,(pausepad).l
	bsr.w	ReadJoy3
	bsr.w	ProcessInputWithRepeat
	tst.w	d1
	bne.w	.key
	tst.w	(FourWayPlay).l
	beq.w	.vid
	bset	#sfpj,(sflags).l
	move.w	#$4,(pausepad).l
	bsr.w	ReadJoy4
	bsr.w	ProcessInputWithRepeat
	tst.w	d1
	beq.w	.vid
.key	move.w	(Vcount).l,d0
	cmpi.w	#$FF88,d0
	blt.w	.menu
	moveq	#-120,d0
.menu	movem.w	d0,-(sp)
	jsr	(HandleMenuInput).l
	bne.w	.resume
	adda.w	#$2,sp
	bset	#$7,d1
	bra.w	.ex
.resume	move.w	(sp)+,(Vcount).l
.vid	bsr.w	setvideo
	move.w	(Vcount).l,d0
.0	cmp.w	(Vcount).l,d0
	beq.w	.0
	tst.w	d0
	bmi.w	.wait
.ex	movem.l	(sp)+,d4-d7/a0-a3
	rts
waitjoy						;wait for either joystick input. Return d1 = new button presses. it as
	
	move.w	(Vcount).l,d0
.0	cmp.w	(Vcount).l,d0
	beq.w	.0
	bsr.w	orjoy
	beq.w	waitjoy
	rts
orjoy						;return d1 = new button presses from either joystick
	tst.w	(FourWayPlay).l
	bne.w	.4way
	bsr.w	ReadJoy1
	move.w	d1,-(sp)
	bsr.w	ReadJoy2
	or.w	(sp)+,d1
	rts
.4way	bsr.w	ReadJoy1
	move.w	d1,-(sp)
	bsr.w	ReadJoy2
	move.w	d1,-(sp)
	bsr.w	ReadJoy3
	move.w	d1,-(sp)
	bsr.w	ReadJoy4
	or.w	(sp)+,d1
	or.w	(sp)+,d1
	or.w	(sp)+,d1
	rts
nodiag						;eliminate diagonal direction presses: if held directions (d3 bits 0-3)
	
	movem.l	d0/d4-d5,-(sp)
	moveq	#$3,d4
	move.w	d3,d0
	andi.w	#$F,d0
	beq.w	.ok
.0	clr.w	d5
	bset	d4,d5
	cmp.w	d5,d0
	dbeq	d4,.0
	beq.w	.ok
	andi.w	#$FFF0,d1
.ok	movem.l	(sp)+,d0/d4-d5
	rts
ProcessInputWithRepeat						;nodiag, then key repeat on d1-d3
	bsr.w	nodiag
	tst.w	d3
	beq.w	rtss2
	tst.w	d2
	bne.w	.chg
	subi.w	#$1,(repeatdelayframes).l
	bpl.w	rtss2
	move.w	#$4,(repeatdelayframes).l
	move.w	d3,d1
	rts
.chg	move.w	#$F,(repeatdelayframes).l
	rts
ReadJoy1						;read controller 1 from the byte ReadPads left in PadRaw1. Return d0 =
	
	
	move.b	(PadRaw1).l,d0
	bsr.w	ReadJoy
	move.w	(lj1).l,d2
	move.w	d1,(lj1).l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1		;d1 = changed and now down = new presses
	rts
ReadJoy2						;read controller 2 from PadRaw2 (same as ReadJoy1 with lj2)
	move.b	(PadRaw2).l,d0
	bsr.w	ReadJoy
	move.w	(lj2).l,d2
	move.w	d1,(lj2).l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
ReadJoy3	move.b	(PadRaw3).l,d0
	bsr.w	ReadJoy
	move.w	(lj3).l,d2
	move.w	d1,(lj3).l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
ReadJoy4	move.b	(PadRaw4).l,d0
	bsr.w	ReadJoy
	move.w	(lj4).l,d2
	move.w	d1,(lj4).l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
ReadJoy	not.b	d0
	clr.w	d1
	move.b	d0,d1
	move.w	d1,-(sp)
	andi.w	#$F0,d0
	andi.w	#$F,d1
	lea.l	ReadJoyDataTable.l,a0
	move.b	(a0,d1.w),d1
	or.w	d1,d0
	move.w	(sp)+,d1
	rts
; Data that follows ReadJoy (strings, small tables)
ReadJoyDataTable	dc.w	$0800,$0408,$0607,$0508,$0201,$0308,$0808,$0808
; Loads the scouting report text block and clears its pointer slots.
ScoutingReportTextLoad
	movem.l	d7/a0,-(sp)
	move.w	#$2,d7
	movea.l	#$4820A,a0
	jsr	$6044.w
	movem.l	(sp)+,d7/a0
	jsr	(ScoutingReportTextClear).l
	rts
; Clears the scouting report text pointer table ($2C longs).
ScoutingReportTextClear
	movem.l	d0/a0,-(sp)
	lea.l	(ScoutingReportText).l,a0
	move.l	#$2B,d0
.loop	clr.l	(a0)+
	dbra	d0,.loop
	movem.l	(sp)+,d0/a0
	rts
; Table of 16 words after ReadJoyDataTable, 32 bytes: $563A,$7E00,$3E39,$0003,$75D2,$E24F ...
	dc.w	$563A,$7E00,$3E39,$0003,$75D2,$E24F,$6400,$0006
	dc.w	$0A47,$B400,$33C7,$0003,$75D2,$8FFC,$FFFF,$4847
	rts
; Adds the disc load base to every pointer of the table at $47D88.
RelocatePointerTableDisc
	movem.l	d0-d1/a0,-(sp)
	movea.l	$47D88.l,a0
	move.l	a0,d1
	moveq	#$1B,d0
.loop2	add.l	d1,(a0)+
	dbra	d0,.loop2
.loop3	add.l	d1,(a0)+
	addq.l	#$2,a0
	tst.l	(a0)
	bne.w	.loop3
	addq.l	#$4,a0
	tst.l	(a0)
	bne.w	.loop3
	movem.l	(sp)+,d0-d1/a0
	rts
; Relocates the pointer table to the word RAM base.
RelocatePointerTableWordRam
	movem.l	d0-d1/a0,-(sp)
	movea.l	#$80000,a0
	move.l	a0,d1
	sub.l	$47D88.l,d1
	moveq	#$1B,d0
.loop4	add.l	d1,(a0)+
	dbra	d0,.loop4
.loop5	add.l	d1,(a0)+
	addq.l	#$2,a0
	tst.l	(a0)
	bne.w	.loop5
	addq.l	#$4,a0
	tst.l	(a0)
	bne.w	.loop5
	movem.l	(sp)+,d0-d1/a0
	rts
ScoutCompareHotColdTotals						;Compare the teams' hot / cold totals (GetHotColdTotal into TempWord1 /
									;TempWord2): awayhotter = 1 when the away total is
									;higher; d0 = -1, $22 or $23 by the difference (ScoutingReport text
									;"Lately ... has been playing (extremely) well")
	movem.l	d0-d3/a0-a4,-(sp)
	movea.l	$47D88.l,a0
	movea.l	#$80000,a1
	move.w	#$88B8,d0
.loop	move.l	(a0)+,(a1)+
	dbra	d0,.loop
	movea.l	$47D88.l,a0
	jsr	(RelocatePointerTableWordRam).l
	movea.l	a0,a1
	adda.l	#$7D0,a1
	movea.l	#$80000,a2
	move.w	(VisTeam).l,d0
	bsr.s	.next
	move.w	(HomeTeam).l,d0
	bsr.s	.next
	adda.l	#$EA60,a0
	move.w	#$2,d7
	jsr	$6044.w
	movem.l	(sp)+,d0-d3/a0-a4
	rts
.next	move.w	d0,d2
	asl.w	#$2,d2
	move.l	(a0,d2.w),d1
	sub.l	a0,d1
.loop2	move.w	#$12C,d3
	movea.l	(a2,d1.w),a3
	movea.l	a1,a4
.loop3	move.l	(a3)+,(a1)+
	dbra	d3,.loop3
	move.l	a4,(a0,d1.w)
	addq.w	#$6,d1
	tst.l	(a0,d1.w)
	bne.w	.loop2
	rts
; Adds the logo bitmap base to its pointer table ($1C entries).
RelocateLogoBitmaps
	movem.l	d0-d1/a0,-(sp)
	movea.l	(TeamLogoBitmaps).l,a0
	move.l	a0,d1
	move.l	#$1B,d0
.loop4	add.l	d1,(a0)+
	dbra	d0,.loop4
	movem.l	(sp)+,d0-d1/a0
	rts
; Sends gate array command $3D.
SubCmd3DSend
	movem.l	d0-d7/a0-a2,-(sp)
	bclr	#$5,$FF800F.l
.loop5	btst	#$7,$FF800E.l
	bne.b	.loop5
	move.w	#$3D,$FF8020.l
	bset	#$6,$FF800F.l
.loop6	btst	#$6,$FF800E.l
	beq.b	.loop6
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop7	btst	#$6,$FF800E.l
	bne.b	.loop7
	bclr	#$7,$FF800F.l
	bset	#$5,$FF800F.l
	movem.l	(sp)+,d0-d7/a0-a2
	rts
; Clears VRAM from address 0 via setVram.
ClearVramViaSetVram
	movem.l	d0-d7/a0-a2,-(sp)
	moveq	#$0,d0
	bsr.w	setVram
	movem.l	(sp)+,d0-d7/a0-a2
	rts
DoDMApro
	move.w	(disflags).l,-(sp)
	bset	#dfng,(disflags).l
	bsr.w	DoDMAProQueue
	move.w	(sp)+,(disflags).l
	rts
; Queues a DMA command in the list at $19360.
DoDMAProQueue
	move.l	a6,-(sp)
	movea.l	(DiscDmaListPtr).l,a6
	btst	#$5,$FF800F.l
	beq.s	.next
	move.w	#$1,-(a6)
	bra.s	.next2
.next	move.w	#$0,-(a6)
.next2	bclr	#$5,$FF800F.l
	move.l	a6,(DiscDmaListPtr).l
	movea.l	(sp)+,a6
	movem.l	d2-d3/a1-a2,-(sp)
	cmpa.l	#$80000,a0
	bge.w	.next3
	move.l	d0,d3
	lsr.w	#$1,d3
	lea.l	(ThreeStars).l,a2
.loop	move.l	(a0)+,(a2)+
	dbra	d3,.loop
	lea.l	(ThreeStars).l,a0
.next3	lea.l	$C00004.l,a1
	move.l	(a0),$BBC96.l
	move.l	d1,$BBC9A.l
	adda.l	#$180002,a0
	move.w	#$8154,$BBC88.l
	move.w	#$8F02,$BBC8A.l
	move.w	#$9300,d2
	move.b	d0,d2
	move.w	d2,$BBC8C.l
	move.w	#$9400,d2
	lsr.w	#$8,d0
	move.b	d0,d2
	move.w	d2,$BBC8E.l
	move.l	a0,d0
	lsr.l	#$1,d0
	move.w	#$9500,d2
	move.b	d0,d2
	move.w	d2,$BBC90.l
	lsr.l	#$8,d0
	move.w	#$9600,d2
	move.b	d0,d2
	move.w	d2,$BBC92.l
	lsr.l	#$8,d0
	andi.b	#$7F,d0
	move.w	#$9700,d2
	move.b	d0,d2
	move.w	d2,$BBC94.l
	clr.l	d0
	move.w	d1,d0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	move.l	d0,d3
	ori.l	#$804000,d0
	move.l	d0,$BBC9E.l
	jsr	(RaiseGateRequest).l
.loop2	btst	#$7,$FF800E.l
	bne.b	.loop2
	move.w	#$8,$FF8020.l
	bset	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	beq.b	.loop3
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop4	btst	#$6,$FF800E.l
	bne.b	.loop4
	bclr	#$7,$FF800F.l
	jsr	(WaitGateAck).l
	move.l	a6,-(sp)
	movea.l	(DiscDmaListPtr).l,a6
	tst.w	(a6)+
	beq.s	.next4
	bset	#$5,$FF800F.l
	bra.s	.next5
.next4	bclr	#$5,$FF800F.l
.next5	move.l	a6,(DiscDmaListPtr).l
	movea.l	(sp)+,a6
	movem.l	(sp)+,d2-d3/a1-a2
	rts
; Copies d0 bytes from word RAM into the work buffer when the source is in range.
DmaCopyFromWordRam
	movem.l	d2-d3/a1-a2,-(sp)
	cmpa.l	#$80000,a0
	bge.w	.next6
	move.l	d0,d3
	lsr.w	#$1,d3
	lea.l	(ThreeStars).l,a2
.loop5	move.l	(a0)+,(a2)+
	dbra	d3,.loop5
	lea.l	(ThreeStars).l,a0
.next6	lea.l	$C00004.l,a1
	move.l	(a0),$BBC96.l
	move.l	d1,$BBC9A.l
	adda.l	#$180002,a0
	move.w	#$8154,$BBC88.l
	move.w	#$8F02,$BBC8A.l
	move.w	#$9300,d2
	move.b	d0,d2
	move.w	d2,$BBC8C.l
	move.w	#$9400,d2
	lsr.w	#$8,d0
	move.b	d0,d2
	move.w	d2,$BBC8E.l
	move.l	a0,d0
	lsr.l	#$1,d0
	move.w	#$9500,d2
	move.b	d0,d2
	move.w	d2,$BBC90.l
	lsr.l	#$8,d0
	move.w	#$9600,d2
	move.b	d0,d2
	move.w	d2,$BBC92.l
	lsr.l	#$8,d0
	andi.b	#$7F,d0
	move.w	#$9700,d2
	move.b	d0,d2
	move.w	d2,$BBC94.l
	clr.l	d0
	move.w	d1,d0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	move.l	d0,d3
	ori.l	#$804000,d0
	move.l	d0,$BBC9E.l
	jsr	(RaiseGateRequest).l
.loop6	btst	#$4,$FF800E.l
	bne.b	.loop6
	move.w	#$32,$FF8026.l
	bset	#$3,$FF800F.l
.loop7	btst	#$3,$FF800E.l
	beq.b	.loop7
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.loop8	btst	#$3,$FF800E.l
	bne.b	.loop8
	bclr	#$4,$FF800F.l
	jsr	(WaitGateAck).l
	movem.l	(sp)+,d2-d3/a1-a2
	rts
DoDMA_nd2						;vram to vram copy by dma, protected from vblank
	move.l	a6,-(sp)
	movea.l	(DiscDmaListPtr).l,a6
	btst	#$5,$FF800F.l
	beq.s	.next
	move.w	#$1,-(a6)
	bra.s	.next2
.next	move.w	#$0,-(a6)
.next2	bclr	#$5,$FF800F.l
	move.l	a6,(DiscDmaListPtr).l
	movea.l	(sp)+,a6
	move.w	(disflags).l,-(sp)
	bset	#dfng,(disflags).l
	move.l	d0,$BBC88.l
	move.l	d1,$BBC8C.l
	move.l	d2,$BBC90.l
	jsr	(RaiseGateRequest).l
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.w	#$1E,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	jsr	(WaitGateAck).l
	move.w	(sp)+,(disflags).l
	move.l	a6,-(sp)
	movea.l	(DiscDmaListPtr).l,a6
	tst.w	(a6)+
	beq.s	.next3
	bset	#$5,$FF800F.l
	bra.s	.next4
.next3	bclr	#$5,$FF800F.l
.next4	move.l	a6,(DiscDmaListPtr).l
	movea.l	(sp)+,a6
	rts
; Queues a DMA command in the list at $19360.
DoDMANd2Queue
	move.l	a6,-(sp)
	movea.l	(DiscDmaListPtr).l,a6
	btst	#$5,$FF800F.l
	beq.s	.next
	move.w	#$1,-(a6)
	bra.s	.next2
.next	move.w	#$0,-(a6)
.next2	bclr	#$5,$FF800F.l
	move.l	a6,(DiscDmaListPtr).l
	movea.l	(sp)+,a6
	move.l	d0,$BBC88.l
	move.l	d1,$BBC8C.l
	move.l	d2,$BBC90.l
	jsr	(RaiseGateRequest).l
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.w	#$1F,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	jsr	(WaitGateAck).l
	move.l	a6,-(sp)
	movea.l	(DiscDmaListPtr).l,a6
	tst.w	(a6)+
	beq.s	.next3
	bset	#$5,$FF800F.l
	bra.s	.next4
.next3	bclr	#$5,$FF800F.l
.next4	move.l	a6,(DiscDmaListPtr).l
	movea.l	(sp)+,a6
	rts

setVram						;initialize all necesary video parameters based on my variables. d0 =
									;color to fade to. Falls into setVram_0
	movea.l	#palfadenew,a0
	moveq	#$3F,d1
.0	move.w	d0,(a0)+		;fill the 64 target colors with d0
	dbra	d1,.0
	move.w	#$18,(palcount).l
	bsr.w	ForceBlackBegin
; Pushes the sub-CPU return state while a VRAM transfer runs.
SetVramStackPush
	move.l	a6,-(sp)
	movea.l	(DiscDmaListPtr).l,a6
	btst	#$5,$FF800F.l
	beq.s	.next
	move.w	#$1,-(a6)
	bra.s	.next2
.next	move.w	#$0,-(a6)
.next2	bclr	#$5,$FF800F.l
	move.l	a6,(DiscDmaListPtr).l
	movea.l	(sp)+,a6
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
.loop2	btst	#$7,$FF800E.l
	bne.b	.loop2
	move.w	#$8F02,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	beq.b	.loop3
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop4	btst	#$6,$FF800E.l
	bne.b	.loop4
	bclr	#$7,$FF800F.l
	clr.w	d0
	bsr.w	SetVramWriteAddr1
	clr.l	d1
.loop5	btst	#$7,$FF800E.l
	bne.b	.loop5
	move.w	#$20,$FF8020.l
	bset	#$6,$FF800F.l
.loop6	btst	#$6,$FF800E.l
	beq.b	.loop6
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop7	btst	#$6,$FF800E.l
	bne.b	.loop7
	bclr	#$7,$FF800F.l
	move.w	#$8C00,d0
	btst	#$1,(disflags).l
	bne.w	.loop8
	ori.w	#$81,d0
.loop8	btst	#$7,$FF800E.l
	bne.b	.loop8
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop9	btst	#$6,$FF800E.l
	beq.b	.loop9
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop10	btst	#$6,$FF800E.l
	bne.b	.loop10
	bclr	#$7,$FF800F.l
.loop11	btst	#$7,$FF800E.l
	bne.b	.loop11
	move.w	#$8014,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop12	btst	#$6,$FF800E.l
	beq.b	.loop12
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop13	btst	#$6,$FF800E.l
	bne.b	.loop13
	bclr	#$7,$FF800F.l
.loop14	btst	#$7,$FF800E.l
	bne.b	.loop14
	move.w	#$8164,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop15	btst	#$6,$FF800E.l
	beq.b	.loop15
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop16	btst	#$6,$FF800E.l
	bne.b	.loop16
	bclr	#$7,$FF800F.l
	move.w	#$9001,d0
	cmpi.w	#$6,(Map1col).l
	beq.w	.loop17
	move.w	#$9003,d0
.loop17	btst	#$7,$FF800E.l
	bne.b	.loop17
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop18	btst	#$6,$FF800E.l
	beq.b	.loop18
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop19	btst	#$6,$FF800E.l
	bne.b	.loop19
	bclr	#$7,$FF800F.l
	move.w	#$8200,d0
	move.b	(VmMAP1).l,d0
	lsr.b	#$2,d0
	andi.b	#$38,d0
.loop20	btst	#$7,$FF800E.l
	bne.b	.loop20
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop21	btst	#$6,$FF800E.l
	beq.b	.loop21
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop22	btst	#$6,$FF800E.l
	bne.b	.loop22
	bclr	#$7,$FF800F.l
	move.w	#$8400,d0
	move.b	(VmMAP2).l,d0
	lsr.b	#$5,d0
.loop23	btst	#$7,$FF800E.l
	bne.b	.loop23
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop24	btst	#$6,$FF800E.l
	beq.b	.loop24
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop25	btst	#$6,$FF800E.l
	bne.b	.loop25
	bclr	#$7,$FF800F.l
	move.w	#$8300,d0
	move.b	(VmMAP3).l,d0
	lsr.b	#$2,d0
	andi.b	#$3E,d0
.loop26	btst	#$7,$FF800E.l
	bne.b	.loop26
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop27	btst	#$6,$FF800E.l
	beq.b	.loop27
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop28	btst	#$6,$FF800E.l
	bne.b	.loop28
	bclr	#$7,$FF800F.l
	move.w	#$8500,d0
	move.b	(VSPRITES).l,d0
	lsr.b	#$1,d0
.loop29	btst	#$7,$FF800E.l
	bne.b	.loop29
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop30	btst	#$6,$FF800E.l
	beq.b	.loop30
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop31	btst	#$6,$FF800E.l
	bne.b	.loop31
	bclr	#$7,$FF800F.l
	move.w	#$8D00,d0
	move.b	(VSCRLPM).l,d0
	lsr.b	#$2,d0
.loop32	btst	#$7,$FF800E.l
	bne.b	.loop32
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop33	btst	#$6,$FF800E.l
	beq.b	.loop33
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop34	btst	#$6,$FF800E.l
	bne.b	.loop34
	bclr	#$7,$FF800F.l
.loop35	btst	#$7,$FF800E.l
	bne.b	.loop35
	move.w	#$9100,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop36	btst	#$6,$FF800E.l
	beq.b	.loop36
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop37	btst	#$6,$FF800E.l
	bne.b	.loop37
	bclr	#$7,$FF800F.l
.loop38	btst	#$7,$FF800E.l
	bne.b	.loop38
	move.w	#$9200,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop39	btst	#$6,$FF800E.l
	beq.b	.loop39
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop40	btst	#$6,$FF800E.l
	bne.b	.loop40
	bclr	#$7,$FF800F.l
.loop41	btst	#$7,$FF800E.l
	bne.b	.loop41
	move.w	#$8700,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop42	btst	#$6,$FF800E.l
	beq.b	.loop42
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop43	btst	#$6,$FF800E.l
	bne.b	.loop43
	bclr	#$7,$FF800F.l
.loop44	btst	#$7,$FF800E.l
	bne.b	.loop44
	move.w	#$8B00,$FF8022.l
	move.w	#$A,$FF8020.l
	bset	#$6,$FF800F.l
.loop45	btst	#$6,$FF800E.l
	beq.b	.loop45
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop46	btst	#$6,$FF800E.l
	bne.b	.loop46
	bclr	#$7,$FF800F.l
.loop47	btst	#$7,$FF800E.l
	bne.b	.loop47
	move.l	#$40000010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset	#$6,$FF800F.l
.loop48	btst	#$6,$FF800E.l
	beq.b	.loop48
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop49	btst	#$6,$FF800E.l
	bne.b	.loop49
	bclr	#$7,$FF800F.l
.loop50	btst	#$7,$FF800E.l
	bne.b	.loop50
	move.l	#$0,$FF8022.l
	move.w	#$E,$FF8020.l
	bset	#$6,$FF800F.l
.loop51	btst	#$6,$FF800E.l
	beq.b	.loop51
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop52	btst	#$6,$FF800E.l
	bne.b	.loop52
	bclr	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	move.l	a6,-(sp)
	movea.l	(DiscDmaListPtr).l,a6
	tst.w	(a6)+
	beq.s	.next3
	bset	#$5,$FF800F.l
	bra.s	.next4
.next3	bclr	#$5,$FF800F.l
.next4	move.l	a6,(DiscDmaListPtr).l
	movea.l	(sp)+,a6
	rts
; Pushes the flag on the queue for setVram
SetVramQueueFlag	move.l	a6,-(sp)
	movea.l	(DiscDmaListPtr).l,a6
	btst.b	#$5,$FF800F.l
	beq.b	.next
	move.w	#$1,-(a6)
	bra.b	.next2
.next	move.w	#$0,-(a6)
.next2	bclr.b	#$5,$FF800F.l
	move.l	a6,(DiscDmaListPtr).l
	movea.l	(sp)+,a6
	move.w	(disflags).l,-(sp)
	bset.b	#$2,(disflags).l
.loop	btst.b	#$7,$FF800E.l
	bne.s	.loop
	move.w	#$8F02,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop2	btst.b	#$6,$FF800E.l
	beq.s	.loop2
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop3	btst.b	#$6,$FF800E.l
	bne.s	.loop3
	bclr.b	#$7,$FF800F.l
	clr.w	d0
	bsr.w	SetVramWriteAddr1
	clr.l	d1
	move.w	#$8C00,d0
	btst.b	#$1,(disflags).l
	bne.w	.loop4
	ori.w	#$81,d0
.loop4	btst.b	#$7,$FF800E.l
	bne.b	.loop4
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop5	btst.b	#$6,$FF800E.l
	beq.s	.loop5
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop6	btst.b	#$6,$FF800E.l
	bne.s	.loop6
	bclr.b	#$7,$FF800F.l
.loop7	btst.b	#$7,$FF800E.l
	bne.s	.loop7
	move.w	#$8014,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop8	btst.b	#$6,$FF800E.l
	beq.s	.loop8
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop9	btst.b	#$6,$FF800E.l
	bne.s	.loop9
	bclr.b	#$7,$FF800F.l
.loop10	btst.b	#$7,$FF800E.l
	bne.s	.loop10
	move.w	#$8164,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop11	btst.b	#$6,$FF800E.l
	beq.s	.loop11
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop12	btst.b	#$6,$FF800E.l
	bne.s	.loop12
	bclr.b	#$7,$FF800F.l
	move.w	#$9001,d0
	cmpi.w	#$6,(Map1col).l
	beq.w	.loop13
	move.w	#$9003,d0
.loop13	btst.b	#$7,$FF800E.l
	bne.b	.loop13
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop14	btst.b	#$6,$FF800E.l
	beq.s	.loop14
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop15	btst.b	#$6,$FF800E.l
	bne.s	.loop15
	bclr.b	#$7,$FF800F.l
	move.w	#$8200,d0
	move.b	(VmMAP1).l,d0
	lsr.b	#$2,d0
	andi.b	#$38,d0
.loop16	btst.b	#$7,$FF800E.l
	bne.s	.loop16
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop17	btst.b	#$6,$FF800E.l
	beq.s	.loop17
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop18	btst.b	#$6,$FF800E.l
	bne.s	.loop18
	bclr.b	#$7,$FF800F.l
	move.w	#$8400,d0
	move.b	(VmMAP2).l,d0
	lsr.b	#$5,d0
.loop19	btst.b	#$7,$FF800E.l
	bne.s	.loop19
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop20	btst.b	#$6,$FF800E.l
	beq.s	.loop20
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop21	btst.b	#$6,$FF800E.l
	bne.s	.loop21
	bclr.b	#$7,$FF800F.l
	move.w	#$8300,d0
	move.b	(VmMAP3).l,d0
	lsr.b	#$2,d0
	andi.b	#$3E,d0
.loop22	btst.b	#$7,$FF800E.l
	bne.s	.loop22
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop23	btst.b	#$6,$FF800E.l
	beq.s	.loop23
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop24	btst.b	#$6,$FF800E.l
	bne.s	.loop24
	bclr.b	#$7,$FF800F.l
	move.w	#$8500,d0
	move.b	(VSPRITES).l,d0
	lsr.b	#$1,d0
.loop25	btst.b	#$7,$FF800E.l
	bne.s	.loop25
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop26	btst.b	#$6,$FF800E.l
	beq.s	.loop26
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop27	btst.b	#$6,$FF800E.l
	bne.s	.loop27
	bclr.b	#$7,$FF800F.l
	move.w	#$8D00,d0
	move.b	(VSCRLPM).l,d0
	lsr.b	#$2,d0
.loop28	btst.b	#$7,$FF800E.l
	bne.s	.loop28
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop29	btst.b	#$6,$FF800E.l
	beq.s	.loop29
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop30	btst.b	#$6,$FF800E.l
	bne.s	.loop30
	bclr.b	#$7,$FF800F.l
.loop31	btst.b	#$7,$FF800E.l
	bne.s	.loop31
	move.w	#$9100,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop32	btst.b	#$6,$FF800E.l
	beq.s	.loop32
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop33	btst.b	#$6,$FF800E.l
	bne.s	.loop33
	bclr.b	#$7,$FF800F.l
.loop34	btst.b	#$7,$FF800E.l
	bne.s	.loop34
	move.w	#$9200,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop35	btst.b	#$6,$FF800E.l
	beq.s	.loop35
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop36	btst.b	#$6,$FF800E.l
	bne.s	.loop36
	bclr.b	#$7,$FF800F.l
.loop37	btst.b	#$7,$FF800E.l
	bne.s	.loop37
	move.w	#$8700,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop38	btst.b	#$6,$FF800E.l
	beq.s	.loop38
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop39	btst.b	#$6,$FF800E.l
	bne.s	.loop39
	bclr.b	#$7,$FF800F.l
.loop40	btst.b	#$7,$FF800E.l
	bne.s	.loop40
	move.w	#$8B00,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop41	btst.b	#$6,$FF800E.l
	beq.s	.loop41
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop42	btst.b	#$6,$FF800E.l
	bne.s	.loop42
	bclr.b	#$7,$FF800F.l
.loop43	btst.b	#$7,$FF800E.l
	bne.s	.loop43
	move.l	#$40000010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop44	btst.b	#$6,$FF800E.l
	beq.s	.loop44
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop45	btst.b	#$6,$FF800E.l
	bne.s	.loop45
	bclr.b	#$7,$FF800F.l
.loop46	btst.b	#$7,$FF800E.l
	bne.s	.loop46
	move.l	#$0,$FF8022.l
	move.w	#$E,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop47	btst.b	#$6,$FF800E.l
	beq.s	.loop47
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop48	btst.b	#$6,$FF800E.l
	bne.s	.loop48
	bclr.b	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	move.l	a6,-(sp)
	movea.l	(DiscDmaListPtr).l,a6
	tst.w	(a6)+
	beq.b	.next3
	bset.b	#$5,$FF800F.l
	bra.b	.next4
.next3	bclr.b	#$5,$FF800F.l
.next4	move.l	a6,(DiscDmaListPtr).l
	movea.l	(sp)+,a6
	rts
; Sets the VDP VRAM write command from d0.
SetVramWriteAddr1
	movea.l	#$C00000,a0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	ori.w	#$4000,d0
	swap	d0
	andi.w	#$3,d0
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.l	d0,$FF8022.l
	move.w	#$B,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	rts
; Second copy of SetVramWriteAddr1.
SetVramWriteAddr2
	movea.l	#$C00000,a0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	ori.w	#$4000,d0
	swap	d0
	andi.w	#$3,d0
.loop	btst	#$4,$FF800E.l
	bne.b	.loop
	move.w	#$30,$FF8026.l
	move.l	d0,$FF8028.l
	bset	#$3,$FF800F.l
.loop2	btst	#$3,$FF800E.l
	beq.b	.loop2
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.loop3	btst	#$3,$FF800E.l
	bne.b	.loop3
	bclr	#$4,$FF800F.l
	rts
dobitmap						;transfer palette data/map data/tiles data to vram. a0 = palette, a1 =
									;map, a2 = tiles (DecompressGraphics data), d0 = start x, d1 = start y, d2
									;= width x, d3 = width y, d4 = start char, d5 = pal used bits (0-3) for
									;color fam 1-4. printy is restored and the tiles go last through
									;DecompressGraphics (returns d4 = end char)
	move.l	a6,-(sp)
	movea.l	(DiscDmaListPtr).l,a6
	btst	#$5,$FF800F.l
	beq.s	.next
	move.w	#$1,-(a6)
	bra.s	.next2
.next	move.w	#$0,-(a6)
.next2	bclr	#$5,$FF800F.l
	move.l	a6,(DiscDmaListPtr).l
	movea.l	(sp)+,a6
	move.w	(printy).l,-(sp)
	move.w	(disflags).l,-(sp)
	bset	#dfng,(disflags).l
	movem.l	d0-d3/d5-d6/a0-a3,-(sp)		;2(sp) start x, $A(sp) width x, $E(sp) width y (low words of d0, d2, d3)
	move.w	d1,d6
	movea.l	#palfadenew,a3		;a3 = target palette, a0 = palette data
	bra.w	.00
.01	move.b	(a0,d0.w),(a3,d0.w)		;copy the color
	dbra	d0,.01
.02	adda.l	#$20,a0		;next line
	adda.l	#$20,a3		;next line
.00	moveq	#$1F,d0
	lsr.w	#$1,d5		;d5 bit n = copy palette line n; stop when no bits left
	bcs.w	.01
	bne.w	.02
	move.w	(printa).l,d5		;d5 = tile attribute bits (priority/palette/flip) from printa
	andi.w	#$F800,d5		;attribute bits
	move.w	$E(sp),d2
	subi.w	#$1,d2
.loop2	bsr.w	xyVmMap		;set vram address from printx/printy/printm, a0 = Vdata
	move.w	d6,d0
	mulu.w	(a1),d0
	add.w	$2(sp),d0
	asl.w	#$1,d0		;d0 = byte offset of the first map word wanted
	move.w	$A(sp),d1
	subi.w	#$1,d1
	move.w	d1,(ThreeStars).l		;map word (map data starts 4 bytes in)
	lea.l	$BC002.l,a0
.loop1	move.w	$4(a1,d0.w),d3
	add.w	d4,d3		;add the start char
	eor.w	d5,d3		;xor the attribute bits
	move.w	d3,(a0)+		;write the name table entry
	addi.w	#$2,d0
	dbra	d1,.loop1
.loop5	btst	#$7,$FF800E.l
	bne.b	.loop5
	move.w	#$21,$FF8020.l
	jsr	(RaiseGateRequest).l
	bset	#$6,$FF800F.l
	jsr	(WaitGateAck).l
.loop6	btst	#$6,$FF800E.l
	beq.b	.loop6
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop7	btst	#$6,$FF800E.l
	bne.b	.loop7
	bclr	#$7,$FF800F.l
	addi.w	#$1,(printy).l
	addi.w	#$1,d6
	dbra	d2,.loop2
	btst	#$0,(sflags6).l
	bne.w	.0
	jsr	(DecompressGraphicsPlain).l
.0	movem.l	(sp)+,d0-d3/d5-d6/a0-a3
	move.w	(sp)+,(disflags).l
	move.w	(sp)+,(printy).l
	move.l	a6,-(sp)
	movea.l	(DiscDmaListPtr).l,a6
	tst.w	(a6)+
	beq.s	.next5
	bset	#$5,$FF800F.l
	bra.s	.next6
.next5	bclr	#$5,$FF800F.l
.next6	move.l	a6,(DiscDmaListPtr).l
	movea.l	(sp)+,a6
	rts