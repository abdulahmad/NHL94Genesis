;	Shared helpers used all over the game. They fade palettes, make random numbers and square
;	roots, start sounds, read up to four joysticks and wait for buttons, move and fill video
;	memory and set up the screen.

UnpackNibbles						;a0 = packed data, d0 = count: unpack 4-bit values into words at
									;nibblebuffer
	movem.l	d0-d2/a0-a1,-(sp)
	movea.w	#(nibblebuffer-M68K_RAM),a1
	clr.w	d2
	bra.w	.next
.loop
	move.b	(a0)+,d1
	bchg	#0,d2
	bne.w	.lo
	subq.w	#1,a0
	lsr.w	#4,d1
.lo
	andi.w	#$F,d1
	move.w	d1,(a1)+
.next
	dbf	d0,.loop
	movem.l	(sp)+,d0-d2/a0-a1
	rts
WeightedRandomSelect				;d0 = number of word weights at nibblebuffer:
									;return a weighted random index
	movem.l	d1/a1,-(sp)
	movea.w	#(nibblebuffer-M68K_RAM),a1
	clr.w	d1
	bra.w	.pick
.sumloop
	add.w	(a1)+,d1
.pick
	dbf	d0,.sumloop
	move.w	d1,d0
	bsr.w	randomd0
.findloop
	sub.w	-(a1),d0
	bpl.s	.findloop
	suba.w	#(nibblebuffer-M68K_RAM),a1
	move.w	a1,d0
	lsr.w	#1,d0
	movem.l	(sp)+,d1/a1
	rts

remap
	move.w	(disflags).w,-(sp)
	bset	#dfng,(disflags).w
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
.0
	move.l	(a0),-(sp)
	clr.l	(a0)+
	dbf	d0,.0
	move.w	#$18,(palcount).w
	bsr.w	forcefade
	moveq	#$1F,d0
.1
	move.l	(sp)+,-(a0)
	dbf	d0,.1
	movem.l	(sp)+,d0/a0
	rts
forceblack2							;fade to black, keeping palfadenew (saved on the stack and restored)
	movem.l	d0/a0,-(sp)
	movea.w	#(palfadenew-M68K_RAM),a0
	moveq	#$1F,d0
.loop
	move.l	(a0),-(sp)
	clr.l	(a0)+
	dbf	d0,.loop
	move.w	#$64,(palcount).w
	bsr.w	forcefade
	moveq	#$1F,d0
.loop2
	move.l	(sp)+,-(a0)
	dbf	d0,.loop2
	movem.l	(sp)+,d0/a0
	rts
forcefade							;regardless of interupts/disflags fade in new palettes, don't upset
									;anything else
	move	sr,-(sp)
	move.l	(VBint).w,-(sp)
	move.w	(disflags).w,-(sp)
	bclr	#dfng,(disflags).w
	move.l	#vb2,(VBint).l
	move	#$2500,sr
.1
	tst.w	(palcount).w
	bpl.s	.1
	move.w	(sp)+,(disflags).w
	move.l	(sp)+,(VBint).w
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
	movea.l	#palfadenew,a1
	movea.l	#Vdata,a0
	clr.w	d6
.top
	move.w	d3,d2
	move.w	d6,d0
	swap	d0
	move.w	#$20,d0
	move.l	d0,Vctrl-Vdata(a0)
	move.w	(a0),d7
	move.w	d7,d0
	and.w	d5,d0
	move.w	(a1)+,d1
	and.w	d5,d1
	cmp.w	d1,d0
	beq.w	.next
	blt.w	.nn
	neg.w	d2
.nn
	add.w	d2,d0
	and.w	d4,d7
	or.w	d0,d7
	move.l	#$C000,d0
	move.b	d6,d0
	swap	d0
	move.l	d0,Vctrl-Vdata(a0)
	move.w	d7,(a0)
.next
	addq.w	#2,d6
	cmp.w	#$80,d6
	bne.s	.top
	rts
CopyPaletteToCRAM					;Copy all 64 palfadenew colours to colour ram, protected from vblank
	movem.l	d0/a0-a1,-(sp)
	move.w	(disflags).w,-(sp)
	bset	#dfng,(disflags).w
	movea.w	#(palfadenew-M68K_RAM),a1
	movea.l	#Vdata,a0
	move.l	#CRAM_W,Vctrl-Vdata(a0)
	moveq	#$1F,d0
.0
	move.l	(a1)+,(a0)
	dbf	d0,.0
	st	(palcount).w
	move.w	(sp)+,(disflags).w
	movem.l	(sp)+,d0/a0-a1
	rts
; d0 = range
; return d0 = random number (-range < d0 < range)
randomd0s
	move.w	d0,-(sp)
	asl.w	#1,d0					;range*2
	bsr.w	randomd0				;0 .. 2*range-1
	sub.w	(sp)+,d0				;shift down to -range+1 .. range-1
	rts
; d0 = range
; return random number in d0 (0 <= d0 < range)
randomd0
	movem.l	d0-d2,-(sp)				;2(sp) = range (the saved d0 low word)
	move.w	(seed+2).w,d0			;seed+2 (92)
	move.w	d0,d1
	move.w	(seed).w,d2				;seed
	mulu.w	#$E62D,d0
	mulu.w	#$BB40,d1
	mulu.w	#$E62D,d2
	add.w	d2,d1
	swap	d0
	add.w	d1,d0
	swap	d0
	addq.l	#1,d0
	move.l	d0,(seed).w				;seed
	asr.l	#8,d0
	mulu.w	2(sp),d0
	swap	d0						;d0 = result 0 <= d0 < range
	addq.w	#4,sp					;skip the saved d0 so the result survives
	movem.l	(sp)+,d1-d2
	rts
; returns d0.L^.5 in d0
Sroot
	tst.l	d0
	beq.w	rtss2					;zero^.5 = zero
	cmp.l	#$640,d0				;#40^2
	bhi.w	.m2
	move.l	d1,-(sp)
	moveq	#-1,d1					;-1
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
	moveq	#9,d3					;max number of reps
	move.w	#$8000,d1
	cmp.l	#$F00000,d0
	bhi.w	.big
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
.done
	move.w	d1,d0
	movem.l	(sp)+,d1-d4
	rts
.big
	moveq	#0,d1
	moveq	#-1,d2
.bs
	move.w	d1,d3
	add.w	d2,d3
	roxr.w	#1,d3
	cmp.w	d3,d1
	beq.s	.done
	move.w	d3,d4
	mulu.w	d3,d3
	cmp.l	d3,d0
	bcc.w	.lo
	move.w	d4,d2
	bra.s	.bs
.lo
	move.w	d4,d1
sfxarg = 16*4						;sfx / song: stack offset of the number word after the movem
	bra.s	.bs
; play sound effect number
; one word passed on stack
sfx
	movem.l	d0-d7/a0-a6,-(sp)		;sfxarg(sp) = the number word (above 15 longs and the return address)
	clr.l	d0
	move.w	sfxarg(sp),d0			;sound number
	bmi.w	.none
	move.w	d0,(lastsfx).w
	jsr	(play_sfx_or_music_track).l
.none
	movem.l	(sp)+,d0-d7/a0-a6
	move.l	(sp),2(sp)				;return address over the number word
	addq.w	#2,sp
	rts
; play song number
; one word passed on stack
song
	movem.l	d0-d7/a0-a6,-(sp)		;sfxarg(sp) = the number word (above 15 longs and the return address)
	clr.l	d0
	move.w	sfxarg(sp),d0			;sound number
	bmi.w	.none
	jsr	(play_sfx_or_music_track).l
.none
	movem.l	(sp)+,d0-d7/a0-a6
	move.l	(sp),2(sp)				;return address over the number word
	addq.w	#2,sp
	rts
; wait d0 vblanks or until input from either joystick
; return joystick variables (d0-d3) if any
waitx
	clr.w	(waitxpad).w
	neg.w	d0
	move.w	d0,(Vcount).w
.wait
	bsr.w	ReadJoy1
	move.w	d3,(waitxpad).w
	tst.w	d1
	bne.w	rtss2
	bsr.w	ReadJoy2
	or.w	d3,(waitxpad).w
	tst.w	d1
	bne.w	rtss2
	tst.w	(FourWayPlay).w
	beq.w	.1
	bsr.w	ReadJoy3
	or.w	d3,(waitxpad).w
	tst.w	d1
	bne.w	rtss2
	bsr.w	ReadJoy4
	or.w	d3,(waitxpad).w
	tst.w	d1
	bne.w	rtss2
.1
	move.w	(Vcount).w,d0
.0
	cmp.w	(Vcount).w,d0
	beq.s	.0
	tst.w	d0
	bmi.s	.wait
	rts
; special version of waitx for zamboni crossing
; wait d0 vblanks or until input from either joystick
; retrun joystick variables (d0-d3) if any
waitxsr								;Wait d0 vblanks while the zamboni crosses
	movem.l	d4-d7/a0-a3,-(sp)
	neg.w	d0
	move.w	d0,(Vcount).w
.wait
	cmpi.w	#$708,(Zamx).w
	bhi.w	.nz
	addq.w	#1,(Zamx).w
.nz
	moveq	#1,d7
	jsr	(updatecrowdf).w			;4EB8: target below $8000
	jsr	(RunArenaAnim).l
	clr.w	(pausepad).w
	bclr	#sfpj,(sflags).w
	bsr.w	ReadJoy1
	bsr.w	ProcessInputWithRepeat
	tst.w	d1
	bne.w	.key
	clr.w	(pausepad).w
	bset	#sfpj,(sflags).w
	bsr.w	ReadJoy2
	bsr.w	ProcessInputWithRepeat
	tst.w	d1
	bne.w	.key
	tst.w	(FourWayPlay).w
	beq.w	.vid
	bclr	#sfpj,(sflags).w
	move.w	#3,(pausepad).w
	bsr.w	ReadJoy3
	bsr.w	ProcessInputWithRepeat
	tst.w	d1
	bne.w	.key
	tst.w	(FourWayPlay).w
	beq.w	.vid
	bset	#sfpj,(sflags).w
	move.w	#4,(pausepad).w
	bsr.w	ReadJoy4
	bsr.w	ProcessInputWithRepeat
	tst.w	d1
	beq.w	.vid
.key
	move.w	(Vcount).w,d0
	cmp.w	#$FF88,d0
	blt.w	.menu
	moveq	#$FFFFFF88,d0
.menu
	movem.w	d0,-(sp)
	jsr	(HandleMenuInput).w			;4EB8: target below $8000
	bne.w	.resume
	addq.w	#2,sp
	bset	#7,d1
	bra.w	.ex
.resume
	move.w	(sp)+,(Vcount).w
.vid
	bsr.w	setvideo
	move.w	(Vcount).w,d0
.0
	cmp.w	(Vcount).w,d0
	beq.s	.0
	tst.w	d0
	bmi.w	.wait
.ex
	movem.l	(sp)+,d4-d7/a0-a3
	rts
; wait for either joystick input
; return d1 = new button presses
waitjoy
	move.w	(Vcount).w,d0
.0
	cmp.w	(Vcount).w,d0
	beq.s	.0
	bsr.w	orjoy
	beq.s	waitjoy
	rts
; return d1 = new button presses
orjoy
	tst.w	(FourWayPlay).w			;check for 4-way play?
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
ProcessInputWithRepeat				;nodiag, then key repeat on d1-d3
	bsr.s	nodiag
	tst.w	d3
	beq.w	rtss2
	tst.w	d2
	bne.w	.chg
	subq.w	#1,(repeatdelayframes).w
	bpl.w	rtss2
	move.w	#4,(repeatdelayframes).w
	move.w	d3,d1
	rts
.chg
	move.w	#$F,(repeatdelayframes).w
	rts
; Read controller 1
; return d0 = direction (bit 0-3) and new button (bit 4-7) presses
; d1 = new presses (all 8 bits)
; d2 = changed buttons (all 8)
; d3 = current held buttons (all 8)
ReadJoy1
	move.b	(pad4way1).w,d0
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
	move.b	(pad4way2).w,d0
	bsr.w	ReadJoy
	move.w	(lj2).w,d2
	move.w	d1,(lj2).w
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
ReadJoy3							;read 4 way play pad 3 (pad4way3). Same returns as ReadJoy1
	move.b	(pad4way3).w,d0
	bsr.w	ReadJoy
	move.w	(lj3).w,d2
	move.w	d1,(lj3).w
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
ReadJoy4							;read 4 way play pad 4 (pad4way4). Same returns as ReadJoy1
	move.b	(pad4way4).w,d0
	bsr.w	ReadJoy
	move.w	(lj4).w,d2
	move.w	d1,(lj4).w
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
ReadJoy								;read controller a0. Return d0 = direction (bit 0-3) and new button (bit
									;4-7) presses, d1 = buttons down (all 8 bits)
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
	bset	#dfng,(disflags).w
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
	lsr.w	#1,d2					;do 2 transers if source address crosses 64k boundary
	sub.w	d2,d0
	move.w	d0,-(sp)
	bsr.w	.dd
	move.w	(sp)+,d0
	add.w	d0,d0
	add.w	d0,d1
	adda.w	d0,a0
	move.w	d2,d0
	bra.w	.nd
.dd									;(a global in ; local here, only DoDMA uses it)
	movem.l	d2-d3/a1,-(sp)
.nd
	lea	(Vctrl).l,a1
	move.w	#VDPR_MODE2+$54,(a1)
	move.w	#VDPR_AUTOINC+$02,(a1)
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
.loop
	btst	#0,(IO_Z80BUS).l
	bne.s	.loop
	move.w	(dmaram+2).w,(a1)
	move.w	(dmaram).w,(a1)
	bsr.w	WaitDMA
	move.w	#VDPR_MODE2+$64,(a1)
	clr.w	(IO_Z80BUS).l
	cmpa.w	#0,a0
	bge.w	.0
	ori.w	#$4000,d3
	swap	d3
	andi.w	#3,d3
	move.l	d3,(a1)
	move.w	(a0),-4(a1)
.0
	move	(sp)+,sr
	movem.l	(sp)+,d2-d3/a1
	rts
DoDMA_nd2							;vram to vram copy by dma, protected from vblank
	movem.l	d0-d3/a1,-(sp)
	move.w	(disflags).w,-(sp)
	bset	#dfng,(disflags).w
	lea	(Vctrl).l,a1
	move.w	#VDPR_MODE2+$54,(a1)
	move.w	#VDPR_AUTOINC+$01,(a1)
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
	move.w	#VDPR_DMASRCH+$C0,(a1)
	clr.l	d0
	move.w	d1,d0
	asl.l	#2,d0
	lsr.w	#2,d0
	swap	d0
	ori.w	#$C0,d0
	move.l	d0,(dmaram).w
	move.w	#$100,(IO_Z80BUS).l
.loop
	btst	#0,(IO_Z80BUS).l
	bne.s	.loop
	move.w	(dmaram).w,(a1)
	move.w	(dmaram+2).w,(a1)
	bsr.w	WaitDMA
	move.w	#VDPR_MODE2+$64,(a1)
	move.w	#VDPR_AUTOINC+$02,(a1)
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
	movea.l	#Vdata,a1
	andi.l	#$FFFF,d1
	asl.l	#2,d1
	lsr.w	#2,d1
	ori.w	#$4000,d1
	swap	d1
	move.l	d1,Vctrl-Vdata(a1)
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
WaitDMA								;wait for dma completion
	move.w	(Vctrl).l,-(sp)			;read the vdp status: 1(sp) is its low byte
	btst	#1,1(sp)				;status bit 1 = dma busy
	addq.w	#2,sp
	bne.s	WaitDMA
	rts
; d0 = color to fade to
setVram
	movea.w	#(palfadenew-M68K_RAM),a0
	moveq	#$3F,d1
.0
	move.w	d0,(a0)+
	dbf	d1,.0
	move.w	#$18,(palcount).w
	bsr.w	forcefade
setVram_0							;second half of setVram without the fade: clear vram and set the VDP
									;registers from disflags, Map1col, VmMAP1-3, VSPRITES and VSCRLPM.
									;Falls in from setVram, called from EASportsScreen and HiScoreScreen
	move.w	(disflags).w,-(sp)
	bset	#dfng,(disflags).w		;#dfng
	move.w	#VDPR_AUTOINC+$02,(Vctrl).l
	clr.w	d0
	bsr.w	Vmaddr
	move.w	#$3FFF,d0
	clr.l	d1
.9
	move.l	d1,(a0)
	dbf	d0,.9
	move.w	#$8C00,d0				;8 for shadow mode
	btst	#df32c,(disflags).w		;#df32c
	bne.w	.i32
	ori.w	#$81,d0
.i32
	move.w	d0,Vctrl-Vdata(a0)		;40 col mode, no interlace, normal brightness
	move.w	#VDPR_MODE1+$04,Vctrl-Vdata(a0)	;512 color palette enable
	move.w	#VDPR_MODE2+$64,Vctrl-Vdata(a0)
	move.w	#$9001,d0				;playfield is 64x32
	cmpi.w	#6,(Map1col).w
	beq.w	.i64
	move.w	#$9003,d0
.i64
	move.w	d0,Vctrl-Vdata(a0)
	move.w	#$8200,d0
	move.b	(VmMAP1).w,d0
	lsr.b	#2,d0
	andi.b	#$38,d0
	move.w	d0,Vctrl-Vdata(a0)
	move.w	#$8400,d0
	move.b	(VmMAP2).w,d0
	lsr.b	#5,d0
	move.w	d0,Vctrl-Vdata(a0)
	move.w	#$8300,d0
	move.b	(VmMAP3).w,d0
	lsr.b	#2,d0
	andi.b	#$3E,d0
	move.w	d0,Vctrl-Vdata(a0)
	move.w	#$8500,d0
	move.b	(VSPRITES).w,d0
	lsr.b	#1,d0
	move.w	d0,Vctrl-Vdata(a0)
	move.w	#$8D00,d0
	move.b	(VSCRLPM).w,d0
	lsr.b	#2,d0
	move.w	d0,Vctrl-Vdata(a0)
	move.w	#VDPR_WINX,Vctrl-Vdata(a0)	;disable plane 3 graphics
	move.w	#VDPR_WINY,Vctrl-Vdata(a0)	;disable plane 3 graphics
	move.w	#VDPR_BGCOL,Vctrl-Vdata(a0)	;Palette # 0 is border/transparent
	move.w	#VDPR_MODE3,Vctrl-Vdata(a0)	;Scroll mode (entire scroll)
	move.l	#VSRAM_W,Vctrl-Vdata(a0)	;vsram
	move.l	#0,(a0)					;playfield 1/2
	move.w	(sp)+,(disflags).w
	rts
; set video port to address d0
; d0 = vram address
; returns a0 = Vdata!!!
Vmaddr
	movea.l	#Vdata,a0
	asl.l	#2,d0
	lsr.w	#2,d0
	ori.w	#$4000,d0
	swap	d0
	andi.w	#3,d0
	move.l	d0,Vctrl-Vdata(a0)
	rts
;	Bitmap and tile decompression, text and number printing, and the small and big font routines.
;	The decompressor handlers and control code routines sit at the addresses in jump_table and
;	ControlCodeJumpTable.
;
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp /
;	cmpi; fixopcodes.js patches the cmp encoding after assembly.

dobitmap							;transfer palette data/map data/tiles data to vram. a0 = palette, a1 =
									;map, a2 = tiles (DecompressGraphics data), d0 = start x, d1 = start y, d2
									;= width x, d3 = width y, d4 = start char, d5 = pal used bits (0-3) for
									;color fam 1-4. printy is restored and the tiles go last through
									;DecompressGraphics (returns d4 = end char)
	move.w	(printy).w,-(sp)
	move.w	(disflags).w,-(sp)
	bset	#dfng,(disflags).w		;#dfng
	movem.l	d0-d3/d5-d6/a0-a3,-(sp)	;2(sp) start x, $A(sp) width x, $E(sp) width y (low words of d0, d2, d3)
	move.w	d1,d6
	movea.w	#(palfadenew-M68K_RAM),a3
	bra.w	.00
.01
	move.b	0(a0,d0.w),0(a3,d0.w)
	dbf	d0,.01
.02
	adda.l	#$20,a0
	adda.l	#$20,a3
.00
	moveq	#$1F,d0
	lsr.w	#1,d5
	bcs.s	.01
	bne.s	.02
	move.w	(printa).w,d5
	andi.w	#$F800,d5
	move.w	$E(sp),d2
	subq.w	#1,d2
.loop2
	bsr.w	xyVmMap
	move.w	d6,d0					;y start
	mulu.w	(a1),d0					;map width
	add.w	2(sp),d0
	asl.w	#1,d0
	move.w	$A(sp),d1
	subq.w	#1,d1
.loop1
	move.w	4(a1,d0.w),d3
	add.w	d4,d3
	eor.w	d5,d3
	move.w	d3,(a0)
	addq.w	#2,d0
	dbf	d1,.loop1
	addq.w	#1,(printy).w
	addq.w	#1,d6
	dbf	d2,.loop2
	btst	#0,(sflags6).w
	bne.w	.0
	bsr.w	DecompressGraphicsPlain
.0
	movem.l	(sp)+,d0-d3/d5-d6/a0-a3
	move.w	(sp)+,(disflags).w
	move.w	(sp)+,(printy).w
	rts
	include	decompress94.asm		;DecompressGraphicsWithCallback ... FlushOutputBuffer (93G layout)
	include	print94.asm				;xyVmMap ... AddTeamBlock (93G layout)
