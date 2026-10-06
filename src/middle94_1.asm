;	NHL 94 (retail) segment $10EE0-$11699
;	92 Middle.Asm part 1, as 93 middle93_1.asm: remap, forceblack / forceblack2, forcefade, cramfade,
;	CopyPaletteToCRAM, randomd0s / randomd0, sroot, sfx, song, waitx, waitxsr, waitjoy, orjoy, nodiag,
;	ProcessInputWithRepeat, ReadJoy1-4 (94: pads 3 and 4), ReadJoy, jdtab, DoDMApro, DoDMA, DoDMA_nd2, DoFill,
;	WaitDMA, setvram, Vmaddr. dobitmap (middle94_2) follows at $1169A.
;	Transcribed from lst/nhl94.bin.lst lines 44006-44864. Global names are the IDA names except CopyPaletteToCRAM
;	(IDA sub_11044), ProcessInputWithRepeat (sub_11318) and DoDMA_nd2 (sub_114B8), the 93 names. waitxsr is the 92
;	name (93 IntermissionLoop). IDA dd / nd (inside DoDMA) are the locals .dd / .nd. IDA dmaram? is dmaram (? stripped).
;	Local labels are the IDA local names (_x -> .x) or the IDA address (loc_10F0A -> .10F0A).
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp /
;	cmpi; fixopcodes.js patches the cmp encoding after assembly.

remap
	move.w	(disflags).w,-(sp)
	bset	#2,(disflags).w
	movem.l	d0-d4/a0-a2,-(sp)
	exg	d1,d0
	movea.l	a0,a2
	bsr.w	Vmaddr
	subq.w	#1,d1
.1
	moveq	#3,d0
	move.w	(a2)+,d2
	clr.w	d3
.11
	move.w	d2,d4
	andi.w	#$F,d4
	lsr.w	#1,d4
	move.b	0(a1,d4.w),d4
	btst	#0,d2
	bne.w	.2
	lsr.w	#4,d4
.2
	andi.w	#$F,d4
	or.b	d4,d3
	ror.w	#4,d3
	ror.w	#4,d2
	dbf	d0,.11
	move.w	d3,(a0)
	dbf	d1,.1
	movem.l	(sp)+,d0-d4/a0-a2
	move.w	(sp)+,(disflags).w
	rts
; fade all colors to black but don't upset palfadenew
forceblack
	movem.l	d0/a0,-(sp)
	movea.w	#(palfadenew-M68K_RAM),a0
	moveq	#$1F,d0
.10F3C
	move.l	(a0),-(sp)
	clr.l	(a0)+
	dbf	d0,.10F3C
	move.w	#$18,(palcount).w
	bsr.w	forcefade
	moveq	#$1F,d0
.10F50
	move.l	(sp)+,-(a0)
	dbf	d0,.10F50
	movem.l	(sp)+,d0/a0
	rts
forceblack2
	movem.l	d0/a0,-(sp)
	movea.w	#(palfadenew-M68K_RAM),a0
	moveq	#$1F,d0
.10F66
	move.l	(a0),-(sp)
	clr.l	(a0)+
	dbf	d0,.10F66
	move.w	#$64,(palcount).w
	bsr.w	forcefade
	moveq	#$1F,d0
.10F7A
	move.l	(sp)+,-(a0)
	dbf	d0,.10F7A
	movem.l	(sp)+,d0/a0
	rts
forcefade
	move	sr,-(sp)
	move.l	(vbint).w,-(sp)
	move.w	(disflags).w,-(sp)
	bclr	#2,(disflags).w
	move.l	#loc_15E4C,(vbint).l
	move	#$2500,sr
.10FA4
	tst.w	(palcount).w
	bpl.s	.10FA4
	move.w	(sp)+,(disflags).w
	move.l	(sp)+,(vbint).w
	move	(sp)+,sr
	rts
; fade from current color in color ram to color held in palfadenew
; this should be called during vblank because palette changes punch holes in video
cramfade
	tst.w	(palcount).w
	bmi.w	rtss2
	cmpi.w	#$64,(palcount).w
	beq.w	CopyPaletteToCRAM
	subq.w	#1,(palcount).w
	bmi.w	rtss2
	clr.l	d0
	move.w	(palcount).w,d0
	cmp.w	#$18,d0
	bgt.w	rtss2
	divu.w	#3,d0
	swap	d0
	asl.w	#2,d0
	moveq	#2,d3
	asl.w	d0,d3
	moveq	#$E,d5
	asl.w	d0,d5
	move.w	d5,d4
	not.w	d4
	movea.l	#$FFFFBD28,a1
	movea.l	#VDP_DATA,a0
	clr.w	d6
.11000
	move.w	d3,d2
	move.w	d6,d0
	swap	d0
	move.w	#$20,d0
	move.l	d0,4(a0)
	move.w	(a0),d7
	move.w	d7,d0
	and.w	d5,d0
	move.w	(a1)+,d1
	and.w	d5,d1
	cmp.w	d1,d0
	beq.w	.1103A
	blt.w	.11024
	neg.w	d2
.11024
	add.w	d2,d0
	and.w	d4,d7
	or.w	d0,d7
	move.l	#$C000,d0
	move.b	d6,d0
	swap	d0
	move.l	d0,4(a0)
	move.w	d7,(a0)
.1103A
	addq.w	#2,d6
	cmp.w	#$80,d6
	bne.s	.11000
	rts
CopyPaletteToCRAM	;IDA: sub_11044 (93 name). Copy all 64 palfadenew colours to colour ram, protected from vblank
	movem.l	d0/a0-a1,-(sp)
	move.w	(disflags).w,-(sp)
	bset	#2,(disflags).w
	movea.w	#(palfadenew-M68K_RAM),a1
	movea.l	#VDP_DATA,a0
	move.l	#$C0000000,4(a0)
	moveq	#$1F,d0
.11066
	move.l	(a1)+,(a0)
	dbf	d0,.11066
	st	(palcount).w
	move.w	(sp)+,(disflags).w
	movem.l	(sp)+,d0/a0-a1
	rts
; d0 = range
; return d0 = random number (-range < d0 < range)
randomd0s
	move.w	d0,-(sp)
	asl.w	#1,d0
	bsr.w	randomd0
	sub.w	(sp)+,d0
	rts
; d0 = range
; return random number in d0 (0 <= d0 < range)
randomd0
	movem.l	d0-d2,-(sp)
	move.w	(RNGseed+2).w,d0
	move.w	d0,d1
	move.w	(RNGseed).w,d2
	mulu.w	#$E62D,d0
	mulu.w	#$BB40,d1
	mulu.w	#$E62D,d2
	add.w	d2,d1
	swap	d0
	add.w	d1,d0
	swap	d0
	addq.l	#1,d0
	move.l	d0,(RNGseed).w
	asr.l	#8,d0
	mulu.w	2(sp),d0
	swap	d0
	addq.w	#4,sp
	movem.l	(sp)+,d1-d2
	rts
; returns d0.L^.5 in d0
sroot
	tst.l	d0
	beq.w	rtss2	;zero^.5 = zero
	cmp.l	#$640,d0	;#40^2
	bhi.w	.m2
	move.l	d1,-(sp)
	moveq	#-1,d1	;-1
.0
	addq.w	#2,d1
	sub.w	d1,d0
	bcc.s	.0
	lsr.w	#1,d1
	move.w	d1,d0
	move.l	(sp)+,d1
	rts
.m2
	movem.l	d1-d4,-(sp)
	moveq	#9,d3	;max number of reps
	move.w	#$8000,d1
	cmp.l	#$F00000,d0
	bhi.w	.11112
	move.l	d0,d1
	lsr.l	#8,d1
	addq.w	#2,d1
.top
	move.w	d1,d2
	move.l	d0,d1
	divu.w	d2,d1
	add.w	d2,d1
	lsr.w	#1,d1
	cmp.w	d1,d2
	dbeq	d3,.top
.1110A
	move.w	d1,d0
	movem.l	(sp)+,d1-d4
	rts
.11112
	moveq	#0,d1
	moveq	#-1,d2
.11116
	move.w	d1,d3
	add.w	d2,d3
	roxr.w	#1,d3
	cmp.w	d3,d1
	beq.s	.1110A
	move.w	d3,d4
	mulu.w	d3,d3
	cmp.l	d3,d0
	bcc.w	.1112E
	move.w	d4,d2
	bra.s	.11116
.1112E
	move.w	d4,d1
	bra.s	.11116
; play sound effect number
; one word passed on stack
sfx
	movem.l	d0-d7/a0-a6,-(sp)
	clr.l	d0
	move.w	$40(sp),d0	;$40 = 16*4
	bmi.w	.none
	move.w	d0,(lastsfx).w
	jsr	(p_initfx).l
.none
	movem.l	(sp)+,d0-d7/a0-a6
	move.l	(sp),2(sp)
	addq.w	#2,sp
	rts
; play song number
; one word passed on stack
song
	movem.l	d0-d7/a0-a6,-(sp)
	clr.l	d0
	move.w	$40(sp),d0	;$40 = 16*4
	bmi.w	.none
	jsr	(p_initfx).l
.none
	movem.l	(sp)+,d0-d7/a0-a6
	move.l	(sp),2(sp)
	addq.w	#2,sp
	rts
; wait d0 vblanks or until input from either joystick
; return joystick variables (d0-d3) if any
waitx
	clr.w	(word_FFDED4).w
	neg.w	d0
	move.w	d0,(vcount).w
.wait
	bsr.w	ReadJoy1
	move.w	d3,(word_FFDED4).w
	tst.w	d1
	bne.w	rtss2
	bsr.w	ReadJoy2
	or.w	d3,(word_FFDED4).w
	tst.w	d1
	bne.w	rtss2
	tst.w	(FourWayPlay).w
	beq.w	.111C0
	bsr.w	ReadJoy3
	or.w	d3,(word_FFDED4).w
	tst.w	d1
	bne.w	rtss2
	bsr.w	ReadJoy4
	or.w	d3,(word_FFDED4).w
	tst.w	d1
	bne.w	rtss2
.111C0
	move.w	(vcount).w,d0
.0
	cmp.w	(vcount).w,d0
	beq.s	.0
	tst.w	d0
	bmi.s	.wait
	rts
; special version of waitx for zamboni crossing
; wait d0 vblanks or until input from either joystick
; retrun joystick variables (d0-d3) if any
waitxsr	;92 name (93 IntermissionLoop). Wait d0 vblanks while the zamboni crosses
	movem.l	d4-d7/a0-a3,-(sp)
	neg.w	d0
	move.w	d0,(vcount).w
.111DA
	cmpi.w	#$708,(zamx).w
	bhi.w	.111E8
	addq.w	#1,(zamx).w
.111E8
	moveq	#1,d7
	jsr	(updatecrowdf).w		;4EB8: target below $8000 (hockey94_01)
	jsr	(sub_FE2C8).l
	clr.w	(word_FFC316).w
	bclr	#1,(sflags).w
	bsr.w	ReadJoy1
	bsr.w	ProcessInputWithRepeat
	tst.w	d1
	bne.w	.11268
	clr.w	(word_FFC316).w
	bset	#1,(sflags).w
	bsr.w	ReadJoy2
	bsr.w	ProcessInputWithRepeat
	tst.w	d1
	bne.w	.11268
	tst.w	(FourWayPlay).w
	beq.w	.11290
	bclr	#1,(sflags).w
	move.w	#3,(word_FFC316).w
	bsr.w	ReadJoy3
	bsr.w	ProcessInputWithRepeat
	tst.w	d1
	bne.w	.11268
	tst.w	(FourWayPlay).w
	beq.w	.11290
	bset	#1,(sflags).w
	move.w	#4,(word_FFC316).w
	bsr.w	ReadJoy4
	bsr.w	ProcessInputWithRepeat
	tst.w	d1
	beq.w	.11290
.11268
	move.w	(vcount).w,d0
	cmp.w	#$FF88,d0
	blt.w	.11276
	moveq	#$FFFFFF88,d0
.11276
	movem.w	d0,-(sp)
	jsr	(sub_7E88).w		;4EB8: target below $8000 (93 HandleMenuInput)
	bne.w	.1128C
	addq.w	#2,sp
	bset	#7,d1
	bra.w	.112A4
.1128C
	move.w	(sp)+,(vcount).w
.11290
	bsr.w	setvideo
	move.w	(vcount).w,d0
.11298
	cmp.w	(vcount).w,d0
	beq.s	.11298
	tst.w	d0
	bmi.w	.111DA
.112A4
	movem.l	(sp)+,d4-d7/a0-a3
	rts
; wait for either joystick input
; return d1 = new button presses
waitjoy
	move.w	(vcount).w,d0
.0
	cmp.w	(vcount).w,d0
	beq.s	.0
	bsr.w	orjoy
	beq.s	waitjoy
	rts
; return d1 = new button presses
orjoy
	tst.w	(FourWayPlay).w	;check for 4-way play?
	bne.w	.4way
	bsr.w	ReadJoy1
	move.w	d1,-(sp)
	bsr.w	ReadJoy2
	or.w	(sp)+,d1
	rts
.4way
	bsr.w	ReadJoy1
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
; eliminate diagonal direction presses on d0
nodiag
	movem.l	d0/d4-d5,-(sp)
	moveq	#3,d4
	move.w	d3,d0
	andi.w	#$F,d0
	beq.w	.ok
.0
	clr.w	d5
	bset	d4,d5
	cmp.w	d5,d0
	dbeq	d4,.0
	beq.w	.ok
	andi.w	#$FFF0,d1
.ok
	movem.l	(sp)+,d0/d4-d5
	rts
ProcessInputWithRepeat	;IDA: sub_11318 (93 name). nodiag, then key repeat on d1-d3
	bsr.s	nodiag
	tst.w	d3
	beq.w	rtss2
	tst.w	d2
	bne.w	.11338
	subq.w	#1,(word_FFB042).w
	bpl.w	rtss2
	move.w	#4,(word_FFB042).w
	move.w	d3,d1
	rts
.11338
	move.w	#$F,(word_FFB042).w
	rts
; Read controller 1
; return d0 = direction (bit 0-3) and new button (bit 4-7) presses
; d1 = new presses (all 8 bits)
; d2 = changed buttons (all 8)
; d3 = current held buttons (all 8)
ReadJoy1
	move.b	(byte_FFBEF6).w,d0
	bsr.w	ReadJoy
	move.w	(lj1).w,d2
	move.w	d1,(lj1).w
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
; Read controller 2
; return d0 = direction (bit 0-3) and new button (bit 4-7) presses
; d1 = new presses (all 8 bits)
; d2 = changed buttons (all 8)
; d3 = current held buttons (all 8)
ReadJoy2
	move.b	(byte_FFBEF7).w,d0
	bsr.w	ReadJoy
	move.w	(lj2).w,d2
	move.w	d1,(lj2).w
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
ReadJoy3
	move.b	(byte_FFBEF8).w,d0
	bsr.w	ReadJoy
	move.w	(lj3).w,d2
	move.w	d1,(lj3).w
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
ReadJoy4
	move.b	(byte_FFBEF9).w,d0
	bsr.w	ReadJoy
	move.w	(lj4).w,d2
	move.w	d1,(lj4).w
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
ReadJoy
	not.b	d0
	clr.w	d1
	move.b	d0,d1
	move.w	d1,-(sp)
	andi.w	#$F0,d0
	andi.w	#$F,d1
	movea.l	#jdtab,a0
	move.b	0(a0,d1.w),d1
	or.w	d1,d0
	move.w	(sp)+,d1
	rts
jdtab	dc.b	8
	;convert button l,r,d,u into directions 0-7,8
	dc.b	0,4,8,6,7,5,8,2,1,3,8,8,8,8,8
; init dma transfer and protect vblank interruption
; d0 = words to transfer
; d1 = initial vram address
; a0 = address to transfer from
DoDMApro
	move.w	(disflags).w,-(sp)
	bset	#2,(disflags).w
	bsr.w	DoDMA
	move.w	(sp)+,(disflags).w
	rts
; initiate dma transfer (dma transfer bug is compensated for)
; d0 = words to transfer
; d1 = destination vram address
; a0 = source address
DoDMA
	movem.l	d2-d3/a1,-(sp)
	move.w	d0,d2
	add.w	d2,d2
	add.w	a0,d2
	bcc.w	.nd
	beq.w	.nd
	lsr.w	#1,d2	;do 2 transers if source address crosses 64k boundary
	sub.w	d2,d0
	move.w	d0,-(sp)
	bsr.w	.dd
	move.w	(sp)+,d0
	add.w	d0,d0
	add.w	d0,d1
	adda.w	d0,a0
	move.w	d2,d0
	bra.w	.nd
.dd	;IDA: dd (a global in IDA; local here, only DoDMA uses it)
	movem.l	d2-d3/a1,-(sp)
.nd	;IDA: nd
	lea	(VDP_CTRL).l,a1
	move.w	#$8154,(a1)
	move.w	#$8F02,(a1)
	move.w	#$9300,d2
	move.b	d0,d2
	move.w	d2,(a1)
	move.w	#$9400,d2
	lsr.w	#8,d0
	move.b	d0,d2
	move.w	d2,(a1)
	move.l	a0,d0
	lsr.l	#1,d0
	move.w	#$9500,d2
	move.b	d0,d2
	move.w	d2,(a1)
	lsr.l	#8,d0
	move.w	#$9600,d2
	move.b	d0,d2
	move.w	d2,(a1)
	lsr.l	#8,d0
	andi.b	#$7F,d0
	move.w	#$9700,d2
	move.b	d0,d2
	move.w	d2,(a1)
	clr.l	d0
	move.w	d1,d0
	asl.l	#2,d0
	lsr.w	#2,d0
	move.l	d0,d3
	ori.l	#$804000,d0
	move.l	d0,(dmaram).w
	move	sr,-(sp)
	move	#$2700,sr
	move.w	#$100,(IO_Z80BUS).l
.11478
	btst	#0,(IO_Z80BUS).l
	bne.s	.11478
	move.w	(dmaram+2).w,(a1)
	move.w	(dmaram).w,(a1)
	bsr.w	WaitDMA
	move.w	#$8164,(a1)
	clr.w	(IO_Z80BUS).l
	cmpa.w	#0,a0
	bge.w	.114B0
	ori.w	#$4000,d3
	swap	d3
	andi.w	#3,d3
	move.l	d3,(a1)
	move.w	(a0),-4(a1)
.114B0
	move	(sp)+,sr
	movem.l	(sp)+,d2-d3/a1
	rts
DoDMA_nd2	;IDA: sub_114B8 (93 name). vram to vram copy by dma, protected from vblank
	movem.l	d0-d3/a1,-(sp)
	move.w	(disflags).w,-(sp)
	bset	#2,(disflags).w
	lea	(VDP_CTRL).l,a1
	move.w	#$8154,(a1)
	move.w	#$8F01,(a1)
	move.w	#$9300,d3
	move.b	d0,d3
	move.w	d3,(a1)
	move.w	#$9400,d3
	lsr.w	#8,d0
	move.b	d0,d3
	move.w	d3,(a1)
	move.w	#$9500,d3
	move.b	d2,d3
	move.w	d3,(a1)
	move.w	#$9600,d3
	lsr.w	#8,d2
	move.b	d2,d3
	move.w	d3,(a1)
	move.w	#$97C0,(a1)
	clr.l	d0
	move.w	d1,d0
	asl.l	#2,d0
	lsr.w	#2,d0
	swap	d0
	ori.w	#$C0,d0
	move.l	d0,(dmaram).w
	move.w	#$100,(IO_Z80BUS).l
.11516
	btst	#0,(IO_Z80BUS).l
	bne.s	.11516
	move.w	(dmaram).w,(a1)
	move.w	(dmaram+2).w,(a1)
	bsr.w	WaitDMA
	move.w	#$8164,(a1)
	move.w	#$8F02,(a1)
	clr.w	(IO_Z80BUS).l
	move.w	(sp)+,(disflags).w
	movem.l	(sp)+,d0-d3/a1
	rts
; fill vram
; d0 = words to fill
; d1 = vram address
; d2 = data to fill with
DoFill
	movem.l	d3/a1,-(sp)
	movea.l	#VDP_DATA,a1
	andi.l	#$FFFF,d1
	asl.l	#2,d1
	lsr.w	#2,d1
	ori.w	#$4000,d1
	swap	d1
	move.l	d1,4(a1)
	move.w	d2,d3
	swap	d3
	move.w	d2,d3
	lsr.w	#1,d0
	subq.w	#1,d0
.0
	move.l	d3,(dmaram).w
	move.w	(dmaram).w,(a1)
	move.w	(dmaram+2).w,(a1)
	dbf	d0,.0
	movem.l	(sp)+,d3/a1
	rts
WaitDMA
	move.w	(VDP_CTRL).l,-(sp)
	btst	#1,1(sp)
	addq.w	#2,sp
	bne.s	WaitDMA
	rts
; d0 = color to fade to
setvram
	movea.w	#(palfadenew-M68K_RAM),a0
	moveq	#$3F,d1
.0
	move.w	d0,(a0)+
	dbf	d1,.0
	move.w	#$18,(palcount).w
	bsr.w	forcefade
.115AA
	move.w	(disflags).w,-(sp)
	bset	#2,(disflags).w	;#dfng
	move.w	#$8F02,(VDP_CTRL).l
	clr.w	d0
	bsr.w	Vmaddr
	move.w	#$3FFF,d0
	clr.l	d1
.9
	move.l	d1,(a0)
	dbf	d0,.9
	move.w	#$8C00,d0	;8 for shadow mode
	btst	#1,(disflags).w	;#df32c
	bne.w	.i32
	ori.w	#$81,d0
.i32
	move.w	d0,4(a0)	;40 col mode, no interlace, normal brightness
	move.w	#$8004,4(a0)	;512 color palette enable
	move.w	#$8164,4(a0)
	move.w	#$9001,d0	;playfield is 64x32
	cmpi.w	#6,(Map1col1).w
	beq.w	.i64
	move.w	#$9003,d0
.i64
	move.w	d0,4(a0)
	move.w	#$8200,d0
	move.b	(VmMap1).w,d0
	lsr.b	#2,d0
	andi.b	#$38,d0
	move.w	d0,4(a0)
	move.w	#$8400,d0
	move.b	(VmMap2).w,d0
	lsr.b	#5,d0
	move.w	d0,4(a0)
	move.w	#$8300,d0
	move.b	(VmMap3).w,d0
	lsr.b	#2,d0
	andi.b	#$3E,d0
	move.w	d0,4(a0)
	move.w	#$8500,d0
	move.b	(VSPRITES).w,d0
	lsr.b	#1,d0
	move.w	d0,4(a0)
	move.w	#$8D00,d0
	move.b	(VSCRLPM).w,d0
	lsr.b	#2,d0
	move.w	d0,4(a0)
	move.w	#$9100,4(a0)	;disable plane 3 graphics
	move.w	#$9200,4(a0)	;disable plane 3 graphics
	move.w	#$8700,4(a0)	;Palette # 0 is border/transparent
	move.w	#$8B00,4(a0)	;Scroll mode (entire scroll)
	move.l	#$40000010,4(a0)	;vsram
	move.l	#0,(a0)	;playfield 1/2
	move.w	(sp)+,(disflags).w
	rts
; set video port to address d0
; d0 = vram address
; returns a0 = Vdata!!!
Vmaddr
	movea.l	#VDP_DATA,a0
	asl.l	#2,d0
	lsr.w	#2,d0
	ori.w	#$4000,d0
	swap	d0
	andi.w	#3,d0
	move.l	d0,4(a0)
	rts
