;	HOCKEY.BIN $1C2D0-$1D945 (runtime $372D0-$38945): middle94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	Part 2 of middle94. CD: the sound driver calls and most of the VDP helpers here are new
;	(CD audio and commands to the main CPU instead of the Z80 and VDP ports).

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

RunArenaAnim	equ	$2A1AA
updatecrowdf	equ	$2BD28
HandleMenuInput	equ	$2C368
forcefade	equ	$36D66
xyVmMap	equ	$38BD4
rtss2	equ	$3C000
setvideo	equ	$3DD16
DecompressGraphicsPlain	equ	$38958

	org	$372D0

; wait d0 vblanks or until input from either joystick
; return joystick variables (d0-d3) if any
waitx								;wait d0 vblanks or until input from either joystick. Return joystick
									;variables (d0-d3) if any. Called from ScoutingReport and
									;SetupStanleyCupCelebrationScreen
	clr.w	(waitxpad).l			;no pad bits yet
	neg.w	d0
	move.w	d0,(Vcount).l			;frame counter
.wait								;loop
	bsr.w	ReadJoy1
	or.w	d3,(waitxpad).l			;plus its held bits
	tst.w	d1						;any press?
	bne.w	rtss2
	bsr.w	ReadJoy2				;CD: the cartridge has ReadJoy3
	or.w	d3,(waitxpad).l			;plus its held bits
	tst.w	d1						;any press?
	bne.w	rtss2
;CD: no cartridge twin
	tst.w	(FourWayPlay).l
	beq.w	.1
	bsr.w	ReadJoy3				;CD: the cartridge has ReadJoy4
	or.w	d3,(waitxpad).l			;plus its held bits
	tst.w	d1						;any press?
	bne.w	rtss2
;CD: no cartridge twin
	bsr.w	ReadJoy4
	or.w	d3,(waitxpad).l
	tst.w	d1
	bne.w	rtss2
.1									;read pad 1 (and the others)
	move.w	(Vcount).l,d0			;frame counter
.0									;loop
	cmp.w	(Vcount).l,d0			;wait for the next vblank to change Vcount
	beq.w	.0						;wait for a new frame
	tst.w	d0						;time left?
	bmi.w	.wait					;still counting up to zero
	rts
; special version of waitx for zamboni crossing
; wait d0 vblanks or until input from either joystick
; retrun joystick variables (d0-d3) if any
waitxsr								;Wait d0 vblanks while the zamboni crosses
	movem.l	d4-d7/a0-a3,-(sp)
	neg.w	d0						;Vcount counts up from -d0 to 0
	move.w	d0,(Vcount).l			;frame counter
.wait								;loop
	cmpi.w	#$708,(Zamx).l			;zamboni across?
	bhi.w	.nz						;zamboni past $708: stop moving it
	addi.w	#1,(Zamx).l
.nz									;zamboni moved
	moveq	#1,d7					;1 frame
	jsr	(updatecrowdf).l			;4EB8: target below $8000
	jsr	(RunArenaAnim).l
	clr.w	(pausepad).l
	bclr.b	#sfpj,(sflags).l
	bsr.w	ReadJoy1
	bsr.w	ProcessInputWithRepeat
	tst.w	d1						;any press?
	bne.w	.key
	clr.w	(pausepad).l
	bset.b	#sfpj,(sflags).l
	bsr.w	ReadJoy2
	bsr.w	ProcessInputWithRepeat
	tst.w	d1						;any press?
	bne.w	.key
	tst.w	(FourWayPlay).l			;four way?
	beq.w	.vid
	bclr.b	#sfpj,(sflags).l
	move.w	#3,(pausepad).l
	bsr.w	ReadJoy3
	bsr.w	ProcessInputWithRepeat
	tst.w	d1						;any press?
	bne.w	.key
	tst.w	(FourWayPlay).l			;four way?
	beq.w	.vid
	bset.b	#sfpj,(sflags).l
	move.w	#4,(pausepad).l
	bsr.w	ReadJoy4
	bsr.w	ProcessInputWithRepeat
	tst.w	d1						;any press?
	beq.w	.vid
.key								;a button: run the menu
	move.w	(Vcount).l,d0			;frame counter
	cmpi.w	#$FF88,d0				;more than $78 frames left?
	blt.w	.menu
	moveq	#$FFFFFF88,d0
.menu								;timer clamped
	movem.w	d0,-(sp)
	jsr	(HandleMenuInput).l			;4EB8: target below $8000
	bne.w	.resume					;menu did not end the screen: carry on waiting
;CD: no cartridge twin
	adda.w	#$2,sp
	bset	#7,d1					;tell the caller the menu ended it
	bra.w	.ex
.resume								;menu left the screen up
	move.w	(sp)+,(Vcount).l
.vid								;redraw and keep waiting
	bsr.w	setvideo
	move.w	(Vcount).l,d0			;frame counter
.0									;loop
	cmp.w	(Vcount).l,d0			;wait for the next vblank
	beq.w	.0						;wait for a new frame
	tst.w	d0						;time left?
	bmi.w	.wait
.ex									;exit: restore the registers
	movem.l	(sp)+,d4-d7/a0-a3
	rts
; wait for either joystick input
; return d1 = new button presses
waitjoy								;wait for either joystick input. Return d1 = new button presses. it as
									;data (no caller found)
	move.w	(Vcount).l,d0			;frame counter
.0									;loop
	cmp.w	(Vcount).l,d0
	beq.w	.0						;wait for a new frame
	bsr.w	orjoy					;read the pads
	beq.w	waitjoy					;no new press: wait again
	rts
; return d1 = new button presses
orjoy								;return d1 = new button presses from either joystick
	tst.w	(FourWayPlay).l			;check for 4-way play?
	bne.w	.4way
	bsr.w	ReadJoy1
	move.w	d1,-(sp)
	bsr.w	ReadJoy2
	or.w	(sp)+,d1
	rts
.4way								;FourWayPlay <> 0
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
nodiag								;eliminate diagonal direction presses: if held directions (d3 bits 0-3)
									;are not one direction, clear the d1 direction bits
	movem.l	d0/d4-d5,-(sp)
	moveq	#3,d4					;d4 = direction bit 3..0
	move.w	d3,d0
	andi.w	#$F,d0					;held directions
	beq.w	.ok						;none held
.0									;each direction bit
	clr.w	d5						;test each single-bit direction against the held set
	bset	d4,d5					;single direction bit
	cmp.w	d5,d0					;matches?
	dbeq	d4,.0					;loop
	beq.w	.ok						;exactly one direction held
	andi.w	#$FFF0,d1				;diagonal: drop the direction presses
.ok									;exit: restore the registers
	movem.l	(sp)+,d0/d4-d5
	rts
ProcessInputWithRepeat				;nodiag, then key repeat on d1-d3
	bsr.w	nodiag
	tst.w	d3						;anything held?
	beq.w	rtss2
	tst.w	d2						;changed?
	bne.w	.chg					;buttons changed: restart the delay
	subi.w	#1,(repeatdelayframes).l
	bpl.w	rtss2
	move.w	#4,(repeatdelayframes).l	;repeat rate
	move.w	d3,d1					;repeat the held buttons
	rts
.chg								;d2 <> 0
	move.w	#$F,(repeatdelayframes).l
	rts
; Read controller 1
; return d0 = direction (bit 0-3) and new button (bit 4-7) presses
; d1 = new presses (all 8 bits)
; d2 = changed buttons (all 8)
; d3 = current held buttons (all 8)
ReadJoy1							;read controller 1 from the byte ReadPads left in PadRaw1. Return d0 =
									;direction (bit 0-3) and new button (bit 4-7) presses, d1 = new presses
									;(all 8 bits), d2 = changed buttons (all 8), d3 = held buttons (all 8)
	move.b	(PadRaw1).l,d0
	bsr.w	ReadJoy					;d1 = buttons down now
	move.w	(lj1).l,d2				;last frame's buttons
	move.w	d1,(lj1).l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1					;d1 = changed and now down = new presses
	rts
; Read controller 2
; return d0 = direction (bit 0-3) and new button (bit 4-7) presses
; d1 = new presses (all 8 bits)
; d2 = changed buttons (all 8)
; d3 = current held buttons (all 8)
ReadJoy2							;read controller 2 from PadRaw2 (same as ReadJoy1 with lj2)
	move.b	(PadRaw2).l,d0
	bsr.w	ReadJoy
	move.w	(lj2).l,d2
	move.w	d1,(lj2).l				;store the new one
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1					;d1 = new presses
	rts
ReadJoy3							;read 4 way play pad 3 (PadRaw3). Same returns as ReadJoy1
	move.b	(PadRaw3).l,d0
	bsr.w	ReadJoy
	move.w	(lj3).l,d2
	move.w	d1,(lj3).l				;store the new one
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1					;d1 = new presses
	rts
ReadJoy4							;read 4 way play pad 4 (PadRaw4). Same returns as ReadJoy1
	move.b	(PadRaw4).l,d0
	bsr.w	ReadJoy
	move.w	(lj4).l,d2
	move.w	d1,(lj4).l				;store the new one
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1					;d1 = new presses
	rts
ReadJoy								;read controller a0. Return d0 = direction (bit 0-3) and new button (bit
									;4-7) presses, d1 = buttons down (all 8 bits)
	not.b	d0
	clr.w	d1
	move.b	d0,d1
	move.w	d1,-(sp)
	andi.w	#$F0,d0					;buttons
	andi.w	#$F,d1					;directions
;CD: no cartridge twin
	lea	(jdtab).l,a0
	move.b	(a0,d1.w),d1			;direction
	or.w	d1,d0
	move.w	(sp)+,d1
	rts
jdtab	dc.b	8					;convert buttons l,r,d,u into directions 0-7,8
	;convert button l,r,d,u into directions 0-7,8
	dc.b	0,4,8,6,7,5,8,2,1,3,8,8,8,8,8
;CD: no cartridge twin
	movem.l	d7/a0,-(sp)
	move.w	#$2,d7
	movea.l	#$4820A,a0
	jsr	$6044.w
	movem.l	(sp)+,d7/a0
	jsr	$375B6.l
	rts
	movem.l	d0/a0,-(sp)
	lea	(ScoutingReportTextPtr).l,a0
	move.l	#$2B,d0
.L375C6
	clr.l	(a0)+
	dbf	d0,.L375C6
	movem.l	(sp)+,d0/a0
	rts
	dc.w	$563A
	moveq	#$0,d7
	move.w	$375D2.l,d7
	lsr.w	#$1,d7
	bcc.w	.L375E6
	eori.w	#$B400,d7
.L375E6
	move.w	d7,$375D2.l
	divs.w	#$FFFF,d7
	swap	d7
	rts
	movem.l	d0-d1/a0,-(sp)
	movea.l	(FeaturedPicturesPtr).l,a0
	move.l	a0,d1
	moveq	#$1B,d0
.L37602
	add.l	d1,(a0)+
	dbf	d0,.L37602
.L37608
	add.l	d1,(a0)+
	addq.l	#$2,a0
	tst.l	(a0)
	bne.w	.L37608
	addq.l	#$4,a0
	tst.l	(a0)
	bne.w	.L37608
	movem.l	(sp)+,d0-d1/a0
	rts
	movem.l	d0-d1/a0,-(sp)
	movea.l	#$80000,a0
	move.l	a0,d1
	sub.l	(FeaturedPicturesPtr).l,d1
	moveq	#$1B,d0
.L37634
	add.l	d1,(a0)+
	dbf	d0,.L37634
.L3763A
	add.l	d1,(a0)+
	addq.l	#$2,a0
	tst.l	(a0)
	bne.w	.L3763A
	addq.l	#$4,a0
	tst.l	(a0)
	bne.w	.L3763A
	movem.l	(sp)+,d0-d1/a0
	rts
	movem.l	d0-d3/a0-a4,-(sp)
	movea.l	(FeaturedPicturesPtr).l,a0
	movea.l	#$80000,a1
	move.w	#$88B8,d0
.L37666
	move.l	(a0)+,(a1)+
	dbf	d0,.L37666
	movea.l	(FeaturedPicturesPtr).l,a0
	jsr	$37620.l
	movea.l	a0,a1
	adda.l	#$7D0,a1
	movea.l	#$80000,a2
	move.w	(VisTeam).l,d0
	bsr.s	.L376AA
	move.w	(HomeTeam).l,d0
	bsr.s	.L376AA
	adda.l	#$EA60,a0
	move.w	#$2,d7
	jsr	$6044.w
	movem.l	(sp)+,d0-d3/a0-a4
	rts
.L376AA
	move.w	d0,d2
	asl.w	#$2,d2
	move.l	(a0,d2.w),d1
	sub.l	a0,d1
.L376B4
	move.w	#$12C,d3
	movea.l	(a2,d1.w),a3
	movea.l	a1,a4
.L376BE
	move.l	(a3)+,(a1)+
	dbf	d3,.L376BE
	move.l	a4,(a0,d1.w)
	addq.w	#$6,d1
	tst.l	(a0,d1.w)
	bne.w	.L376B4
	rts
	movem.l	d0-d1/a0,-(sp)
	movea.l	(TeamLogoBitmapsPtr).l,a0
	move.l	a0,d1
	move.l	#$1B,d0
.L376E6
	add.l	d1,(a0)+
	dbf	d0,.L376E6
	movem.l	(sp)+,d0-d1/a0
	rts
	movem.l	d0-d7/a0-a2,-(sp)
	bclr.b	#$5,$FF800F.l
.L376FE
	btst.b	#$7,$FF800E.l
	bne.s	.L376FE
	move.w	#$3D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L37718
	btst.b	#$6,$FF800E.l
	beq.s	.L37718
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L37732
	btst.b	#$6,$FF800E.l
	bne.s	.L37732
	bclr.b	#$7,$FF800F.l
	bset.b	#$5,$FF800F.l
	movem.l	(sp)+,d0-d7/a0-a2
	rts
	movem.l	d0-d7/a0-a2,-(sp)
	moveq	#$0,d0
	bsr.w	setVram
	movem.l	(sp)+,d0-d7/a0-a2
	rts
; init dma transfer and protect vblank interruption
; d0 = words to transfer
; d1 = initial vram address
; a0 = address to transfer from
DoDMApro							;initiate dma transfer and protect from vblank interuption. d0 = words to
									;transfer, d1 = initial vram address, a0 = address to transfer from.
									;Jumped to from DecompressGraphics
	move.w	(disflags).l,-(sp)
	bset.b	#dfng,(disflags).l
	bsr.w	DoDMA
	move.w	(sp)+,(disflags).l
	rts
;CD: no cartridge twin
DoDMA								;CD: placed where the disc branches to it
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst.b	#$5,$FF800F.l
	beq.s	.L37794
	move.w	#$1,-(a6)
	bra.s	.L37798
.L37794
	move.w	#$0,-(a6)
.L37798
	bclr.b	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	movem.l	d2-d3/a1-a2,-(sp)
	cmpa.l	#$80000,a0
	bge.w	.L377CC
	move.l	d0,d3
	lsr.w	#$1,d3
	lea	$BC000.l,a2
.L377C0
	move.l	(a0)+,(a2)+
	dbf	d3,.L377C0
	lea	$BC000.l,a0
.L377CC
	lea	$C00004.l,a1
	move.l	(a0),$BBC96.l
	move.l	d1,$BBC9A.l
	adda.l	#$180002,a0
	move.w	#$8154,$BBC88.l
	move.w	#$8F02,$BBC8A.l
	move.w	#$9300,d2
	move.b	d0,d2
	move.w	d2,$BBC8C.l
	move.w	#$9400,d2
	lsr.w	#8,d0
	move.b	d0,d2					;reg 20: length high
;CD: no cartridge twin
	move.w	d2,$BBC8E.l
	move.l	a0,d0
	lsr.l	#1,d0					;source in words
	move.w	#$9500,d2
	move.b	d0,d2					;reg 21: source low
;CD: no cartridge twin
	move.w	d2,$BBC90.l
	lsr.l	#8,d0
	move.w	#$9600,d2
	move.b	d0,d2					;reg 22: source mid
;CD: no cartridge twin
	move.w	d2,$BBC92.l
	lsr.l	#8,d0
	andi.b	#$7F,d0
	move.w	#$9700,d2
	move.b	d0,d2					;reg 23: source high (dma mode bits 7-6 = 0: 68k to vram)
;CD: no cartridge twin
	move.w	d2,$BBC94.l
	clr.l	d0
	move.w	d1,d0					;build the vdp command long for a vram write with dma
	asl.l	#2,d0
	lsr.w	#2,d0
	move.l	d0,d3
	ori.l	#$804000,d0				;vram write with DMA
	move.l	d0,(dmaram).l			;the last command word is written from ram (dma bug workaround)
;CD: no cartridge twin
	jsr	$222C2.l
.L3785A
	btst.b	#$7,$FF800E.l
	bne.s	.L3785A
	move.w	#$8,$FF8020.l
	bset.b	#$6,$FF800F.l
.L37874
	btst.b	#$6,$FF800E.l
	beq.s	.L37874
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3788E
	btst.b	#$6,$FF800E.l
	bne.s	.L3788E
	bclr.b	#$7,$FF800F.l
	jsr	$22268.l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.s	.L378BC
	bset.b	#$5,$FF800F.l
	bra.s	.L378C4
.L378BC
	bclr.b	#$5,$FF800F.l
.L378C4
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	movem.l	(sp)+,d2-d3/a1-a2
	rts
	movem.l	d2-d3/a1-a2,-(sp)
	cmpa.l	#$80000,a0
	bge.w	.L378F6
	move.l	d0,d3
	lsr.w	#$1,d3
	lea	$BC000.l,a2
.L378EA
	move.l	(a0)+,(a2)+
	dbf	d3,.L378EA
	lea	$BC000.l,a0
.L378F6
	lea	$C00004.l,a1
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
	move.l	d0,(dmaram).l
	jsr	$222C2.l
.L37984
	btst.b	#$4,$FF800E.l
	bne.s	.L37984
	move.w	#$32,$FF8026.l
	bset.b	#$3,$FF800F.l
.L3799E
	btst.b	#$3,$FF800E.l
	beq.s	.L3799E
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L379B8
	btst.b	#$3,$FF800E.l
	bne.s	.L379B8
	bclr.b	#$4,$FF800F.l
	jsr	$22268.l
	movem.l	(sp)+,d2-d3/a1-a2
	rts
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst.b	#$5,$FF800F.l
	beq.s	.L379EE
	move.w	#$1,-(a6)
	bra.s	.L379F2
.L379EE
	move.w	#$0,-(a6)
.L379F2
	bclr.b	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	move.w	(disflags).l,-(sp)
	bset.b	#$2,(disflags).l
	move.l	d0,$BBC88.l
	move.l	d1,$BBC8C.l
	move.l	d2,$BBC90.l
	jsr	$222C2.l
.L37A28
	btst.b	#$7,$FF800E.l
	bne.s	.L37A28
	move.w	#$1E,$FF8020.l
	bset.b	#$6,$FF800F.l
.L37A42
	btst.b	#$6,$FF800E.l
	beq.s	.L37A42
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L37A5C
	btst.b	#$6,$FF800E.l
	bne.s	.L37A5C
	bclr.b	#$7,$FF800F.l
	jsr	$22268.l
	move.w	(sp)+,(disflags).l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.s	.L37A90
	bset.b	#$5,$FF800F.l
	bra.s	.L37A98
.L37A90
	bclr.b	#$5,$FF800F.l
.L37A98
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	rts
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst.b	#$5,$FF800F.l
	beq.s	.L37ABA
	move.w	#$1,-(a6)
	bra.s	.L37ABE
.L37ABA
	move.w	#$0,-(a6)
.L37ABE
	bclr.b	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	move.l	d0,$BBC88.l
	move.l	d1,$BBC8C.l
	move.l	d2,$BBC90.l
	jsr	$222C2.l
.L37AE6
	btst.b	#$7,$FF800E.l
	bne.s	.L37AE6
	move.w	#$1F,$FF8020.l
	bset.b	#$6,$FF800F.l
.L37B00
	btst.b	#$6,$FF800E.l
	beq.s	.L37B00
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L37B1A
	btst.b	#$6,$FF800E.l
	bne.s	.L37B1A
	bclr.b	#$7,$FF800F.l
	jsr	$22268.l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.s	.L37B48
	bset.b	#$5,$FF800F.l
	bra.s	.L37B50
.L37B48
	bclr.b	#$5,$FF800F.l
.L37B50
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
WaitDMA								;CD: its first lines have no twin; the rest of it starts here
	rts
; d0 = color to fade to
setVram								;initialize all necesary video parameters based on my variables. d0 =
									;color to fade to. Falls into setVram_0
	movea.l	#$BBCB0,a0				;CD: the cartridge has #(palfadenew-M68K_RAM)
	moveq	#$3F,d1
.0									;fill each target color
	move.w	d0,(a0)+				;fill the 64 target colors with d0
	dbf	d1,.0						;loop
	move.w	#$18,(palcount).l
	bsr.w	forcefade				;fade the screen to that color
;CD: no cartridge twin
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst.b	#$5,$FF800F.l
	beq.s	.L37B8C
	move.w	#$1,-(a6)
	bra.s	.L37B90
.L37B8C
	move.w	#$0,-(a6)
.L37B90
	bclr.b	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	move.w	(disflags).l,-(sp)
	bset.b	#$2,(disflags).l
.L37BAE
	btst.b	#$7,$FF800E.l
	bne.s	.L37BAE
	move.w	#$8F02,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L37BD0
	btst.b	#$6,$FF800E.l
	beq.s	.L37BD0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L37BEA
	btst.b	#$6,$FF800E.l
	bne.s	.L37BEA
	bclr.b	#$7,$FF800F.l
	clr.w	d0
	bsr.w	Vmaddr
	clr.l	d1
.L37C04
	btst.b	#$7,$FF800E.l
	bne.s	.L37C04
	move.w	#$20,$FF8020.l
	bset.b	#$6,$FF800F.l
.L37C1E
	btst.b	#$6,$FF800E.l
	beq.s	.L37C1E
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L37C38
	btst.b	#$6,$FF800E.l
	bne.s	.L37C38
	bclr.b	#$7,$FF800F.l
setVram_0							;CD: its first lines have no twin; the rest of it starts here
	move.w	#$8C00,d0				;8 for shadow mode
	btst.b	#df32c,(disflags).l
	bne.w	.i32					;32 column flag set: leave bits 0 and 7 clear
	ori.w	#$81,d0
;CD: no cartridge twin
.i32								;CD: placed where the disc branches to it
	btst.b	#$7,$FF800E.l
	bne.s	.i32
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L37C7E
	btst.b	#$6,$FF800E.l
	beq.s	.L37C7E
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L37C98
	btst.b	#$6,$FF800E.l
	bne.s	.L37C98
	bclr.b	#$7,$FF800F.l
.L37CAA
	btst.b	#$7,$FF800E.l
	bne.s	.L37CAA
	move.w	#$8014,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L37CCC
	btst.b	#$6,$FF800E.l
	beq.s	.L37CCC
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L37CE6
	btst.b	#$6,$FF800E.l
	bne.s	.L37CE6
	bclr.b	#$7,$FF800F.l
.L37CF8
	btst.b	#$7,$FF800E.l
	bne.s	.L37CF8
	move.w	#$8164,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L37D1A
	btst.b	#$6,$FF800E.l
	beq.s	.L37D1A
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L37D34
	btst.b	#$6,$FF800E.l
	bne.s	.L37D34
	bclr.b	#$7,$FF800F.l
	move.w	#$9001,d0				;playfield is 64x32
	cmpi.w	#6,(Map1col).l			;64 wide?
	beq.w	.i64					;Map1col 6 = 64 columns wide
	move.w	#$9003,d0				;otherwise 128x32
;CD: no cartridge twin
.i64								;CD: placed where the disc branches to it
	btst.b	#$7,$FF800E.l
	bne.s	.i64
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L37D7A
	btst.b	#$6,$FF800E.l
	beq.s	.L37D7A
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L37D94
	btst.b	#$6,$FF800E.l
	bne.s	.L37D94
	bclr.b	#$7,$FF800F.l
	move.w	#$8200,d0				;reg 2: map 1 address
	move.b	(VmMAP1).l,d0
	lsr.b	#2,d0
	andi.b	#$38,d0
;CD: no cartridge twin
.L37DB6
	btst.b	#$7,$FF800E.l
	bne.s	.L37DB6
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L37DD6
	btst.b	#$6,$FF800E.l
	beq.s	.L37DD6
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L37DF0
	btst.b	#$6,$FF800E.l
	bne.s	.L37DF0
	bclr.b	#$7,$FF800F.l
	move.w	#$8400,d0				;reg 4: map 2 address
	move.b	(VmMAP2).l,d0
	lsr.b	#5,d0
;CD: no cartridge twin
.L37E0E
	btst.b	#$7,$FF800E.l
	bne.s	.L37E0E
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L37E2E
	btst.b	#$6,$FF800E.l
	beq.s	.L37E2E
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L37E48
	btst.b	#$6,$FF800E.l
	bne.s	.L37E48
	bclr.b	#$7,$FF800F.l
	move.w	#$8300,d0				;reg 3: map 3 address
	move.b	(VmMAP3).l,d0
	lsr.b	#2,d0
	andi.b	#$3E,d0
;CD: no cartridge twin
.L37E6A
	btst.b	#$7,$FF800E.l
	bne.s	.L37E6A
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L37E8A
	btst.b	#$6,$FF800E.l
	beq.s	.L37E8A
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L37EA4
	btst.b	#$6,$FF800E.l
	bne.s	.L37EA4
	bclr.b	#$7,$FF800F.l
	move.w	#$8500,d0				;reg 5: sprite table
	move.b	(VSPRITES).l,d0
	lsr.b	#1,d0
;CD: no cartridge twin
.L37EC2
	btst.b	#$7,$FF800E.l
	bne.s	.L37EC2
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L37EE2
	btst.b	#$6,$FF800E.l
	beq.s	.L37EE2
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L37EFC
	btst.b	#$6,$FF800E.l
	bne.s	.L37EFC
	bclr.b	#$7,$FF800F.l
	move.w	#$8D00,d0				;reg $D: scroll table
	move.b	$18D30.l,d0				;CD: the cartridge has (VSCRLPM).w
	lsr.b	#2,d0
;CD: no cartridge twin
.L37F1A
	btst.b	#$7,$FF800E.l
	bne.s	.L37F1A
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L37F3A
	btst.b	#$6,$FF800E.l
	beq.s	.L37F3A
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L37F54
	btst.b	#$6,$FF800E.l
	bne.s	.L37F54
	bclr.b	#$7,$FF800F.l
.L37F66
	btst.b	#$7,$FF800E.l
	bne.s	.L37F66
	move.w	#$9100,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L37F88
	btst.b	#$6,$FF800E.l
	beq.s	.L37F88
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L37FA2
	btst.b	#$6,$FF800E.l
	bne.s	.L37FA2
	bclr.b	#$7,$FF800F.l
.L37FB4
	btst.b	#$7,$FF800E.l
	bne.s	.L37FB4
	move.w	#$9200,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L37FD6
	btst.b	#$6,$FF800E.l
	beq.s	.L37FD6
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L37FF0
	btst.b	#$6,$FF800E.l
	bne.s	.L37FF0
	bclr.b	#$7,$FF800F.l
.L38002
	btst.b	#$7,$FF800E.l
	bne.s	.L38002
	move.w	#$8700,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L38024
	btst.b	#$6,$FF800E.l
	beq.s	.L38024
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3803E
	btst.b	#$6,$FF800E.l
	bne.s	.L3803E
	bclr.b	#$7,$FF800F.l
.L38050
	btst.b	#$7,$FF800E.l
	bne.s	.L38050
	move.w	#$8B00,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L38072
	btst.b	#$6,$FF800E.l
	beq.s	.L38072
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3808C
	btst.b	#$6,$FF800E.l
	bne.s	.L3808C
	bclr.b	#$7,$FF800F.l
.L3809E
	btst.b	#$7,$FF800E.l
	bne.s	.L3809E
	move.l	#$40000010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L380C2
	btst.b	#$6,$FF800E.l
	beq.s	.L380C2
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L380DC
	btst.b	#$6,$FF800E.l
	bne.s	.L380DC
	bclr.b	#$7,$FF800F.l
.L380EE
	btst.b	#$7,$FF800E.l
	bne.s	.L380EE
	move.l	#$0,$FF8022.l
	move.w	#$E,$FF8020.l
	bset.b	#$6,$FF800F.l
.L38112
	btst.b	#$6,$FF800E.l
	beq.s	.L38112
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3812C
	btst.b	#$6,$FF800E.l
	bne.s	.L3812C
	bclr.b	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.s	.L3815A
	bset.b	#$5,$FF800F.l
	bra.s	.L38162
.L3815A
	bclr.b	#$5,$FF800F.l
.L38162
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	rts
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst.b	#$5,$FF800F.l
	beq.s	.L38184
	move.w	#$1,-(a6)
	bra.s	.L38188
.L38184
	move.w	#$0,-(a6)
.L38188
	bclr.b	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	move.w	(disflags).l,-(sp)
	bset.b	#$2,(disflags).l
.L381A6
	btst.b	#$7,$FF800E.l
	bne.s	.L381A6
	move.w	#$8F02,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L381C8
	btst.b	#$6,$FF800E.l
	beq.s	.L381C8
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L381E2
	btst.b	#$6,$FF800E.l
	bne.s	.L381E2
	bclr.b	#$7,$FF800F.l
	clr.w	d0
	bsr.w	Vmaddr
	clr.l	d1
	move.w	#$8C00,d0
	btst.b	#$1,(disflags).l
	bne.w	.L38210
	ori.w	#$81,d0
.L38210
	btst.b	#$7,$FF800E.l
	bne.s	.L38210
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L38230
	btst.b	#$6,$FF800E.l
	beq.s	.L38230
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3824A
	btst.b	#$6,$FF800E.l
	bne.s	.L3824A
	bclr.b	#$7,$FF800F.l
.L3825C
	btst.b	#$7,$FF800E.l
	bne.s	.L3825C
	move.w	#$8014,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3827E
	btst.b	#$6,$FF800E.l
	beq.s	.L3827E
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L38298
	btst.b	#$6,$FF800E.l
	bne.s	.L38298
	bclr.b	#$7,$FF800F.l
.L382AA
	btst.b	#$7,$FF800E.l
	bne.s	.L382AA
	move.w	#$8164,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L382CC
	btst.b	#$6,$FF800E.l
	beq.s	.L382CC
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L382E6
	btst.b	#$6,$FF800E.l
	bne.s	.L382E6
	bclr.b	#$7,$FF800F.l
	move.w	#$9001,d0
	cmpi.w	#$6,(Map1col).l
	beq.w	.L3830C
	move.w	#$9003,d0
.L3830C
	btst.b	#$7,$FF800E.l
	bne.s	.L3830C
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3832C
	btst.b	#$6,$FF800E.l
	beq.s	.L3832C
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L38346
	btst.b	#$6,$FF800E.l
	bne.s	.L38346
	bclr.b	#$7,$FF800F.l
	move.w	#$8200,d0
	move.b	(VmMAP1).l,d0
	lsr.b	#$2,d0
	andi.b	#$38,d0
.L38368
	btst.b	#$7,$FF800E.l
	bne.s	.L38368
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L38388
	btst.b	#$6,$FF800E.l
	beq.s	.L38388
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L383A2
	btst.b	#$6,$FF800E.l
	bne.s	.L383A2
	bclr.b	#$7,$FF800F.l
	move.w	#$8400,d0
	move.b	(VmMAP2).l,d0
	lsr.b	#$5,d0
.L383C0
	btst.b	#$7,$FF800E.l
	bne.s	.L383C0
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L383E0
	btst.b	#$6,$FF800E.l
	beq.s	.L383E0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L383FA
	btst.b	#$6,$FF800E.l
	bne.s	.L383FA
	bclr.b	#$7,$FF800F.l
	move.w	#$8300,d0
	move.b	(VmMAP3).l,d0
	lsr.b	#$2,d0
	andi.b	#$3E,d0
.L3841C
	btst.b	#$7,$FF800E.l
	bne.s	.L3841C
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3843C
	btst.b	#$6,$FF800E.l
	beq.s	.L3843C
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L38456
	btst.b	#$6,$FF800E.l
	bne.s	.L38456
	bclr.b	#$7,$FF800F.l
	move.w	#$8500,d0
	move.b	(VSPRITES).l,d0
	lsr.b	#$1,d0
.L38474
	btst.b	#$7,$FF800E.l
	bne.s	.L38474
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L38494
	btst.b	#$6,$FF800E.l
	beq.s	.L38494
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L384AE
	btst.b	#$6,$FF800E.l
	bne.s	.L384AE
	bclr.b	#$7,$FF800F.l
	move.w	#$8D00,d0
	move.b	$18D30.l,d0
	lsr.b	#$2,d0
.L384CC
	btst.b	#$7,$FF800E.l
	bne.s	.L384CC
	move.w	d0,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L384EC
	btst.b	#$6,$FF800E.l
	beq.s	.L384EC
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L38506
	btst.b	#$6,$FF800E.l
	bne.s	.L38506
	bclr.b	#$7,$FF800F.l
.L38518
	btst.b	#$7,$FF800E.l
	bne.s	.L38518
	move.w	#$9100,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3853A
	btst.b	#$6,$FF800E.l
	beq.s	.L3853A
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L38554
	btst.b	#$6,$FF800E.l
	bne.s	.L38554
	bclr.b	#$7,$FF800F.l
.L38566
	btst.b	#$7,$FF800E.l
	bne.s	.L38566
	move.w	#$9200,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L38588
	btst.b	#$6,$FF800E.l
	beq.s	.L38588
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L385A2
	btst.b	#$6,$FF800E.l
	bne.s	.L385A2
	bclr.b	#$7,$FF800F.l
.L385B4
	btst.b	#$7,$FF800E.l
	bne.s	.L385B4
	move.w	#$8700,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L385D6
	btst.b	#$6,$FF800E.l
	beq.s	.L385D6
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L385F0
	btst.b	#$6,$FF800E.l
	bne.s	.L385F0
	bclr.b	#$7,$FF800F.l
.L38602
	btst.b	#$7,$FF800E.l
	bne.s	.L38602
	move.w	#$8B00,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L38624
	btst.b	#$6,$FF800E.l
	beq.s	.L38624
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3863E
	btst.b	#$6,$FF800E.l
	bne.s	.L3863E
	bclr.b	#$7,$FF800F.l
.L38650
	btst.b	#$7,$FF800E.l
	bne.s	.L38650
	move.l	#$40000010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L38674
	btst.b	#$6,$FF800E.l
	beq.s	.L38674
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3868E
	btst.b	#$6,$FF800E.l
	bne.s	.L3868E
	bclr.b	#$7,$FF800F.l
.L386A0
	btst.b	#$7,$FF800E.l
	bne.s	.L386A0
	move.l	#$0,$FF8022.l
	move.w	#$E,$FF8020.l
	bset.b	#$6,$FF800F.l
.L386C4
	btst.b	#$6,$FF800E.l
	beq.s	.L386C4
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L386DE
	btst.b	#$6,$FF800E.l
	bne.s	.L386DE
	bclr.b	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.s	.L3870C
	bset.b	#$5,$FF800F.l
	bra.s	.L38714
.L3870C
	bclr.b	#$5,$FF800F.l
.L38714
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	rts
; set video port to address d0
; d0 = vram address
; returns a0 = Vdata!!!
Vmaddr								;set video port to address d0. d0 = vram address, returns a0 = Vdata!!!
	movea.l	#Vdata,a0
	asl.l	#2,d0					;split the address: bits 0-13 in the first word, 14-15 in the second
	lsr.w	#2,d0
	ori.w	#$4000,d0				;vram write command
	swap	d0						;to the high word
	andi.w	#3,d0
;CD: no cartridge twin
.L38732
	btst.b	#$7,$FF800E.l
	bne.s	.L38732
	move.l	d0,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L38752
	btst.b	#$6,$FF800E.l
	beq.s	.L38752
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3876C
	btst.b	#$6,$FF800E.l
	bne.s	.L3876C
	bclr.b	#$7,$FF800F.l
	rts
	movea.l	#$C00000,a0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	ori.w	#$4000,d0
	swap	d0
	andi.w	#$3,d0
.L38794
	btst.b	#$4,$FF800E.l
	bne.s	.L38794
	move.w	#$30,$FF8026.l
	move.l	d0,$FF8028.l
	bset.b	#$3,$FF800F.l
.L387B4
	btst.b	#$3,$FF800E.l
	beq.s	.L387B4
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L387CE
	btst.b	#$3,$FF800E.l
	bne.s	.L387CE
	bclr.b	#$4,$FF800F.l
	rts
dobitmap							;transfer palette data/map data/tiles data to vram. a0 = palette, a1 =
									;(CD: entered here; the cartridge dobitmap starts at its first twin line,
									;$3880E)
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst.b	#$5,$FF800F.l
	beq.s	.L387FA
	move.w	#$1,-(a6)
	bra.s	.L387FE
.L387FA
	move.w	#$0,-(a6)
.L387FE
	bclr.b	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
;	Bitmap and tile decompression, text and number printing, and the small and big font routines.
;	The decompressor handlers and control code routines sit at the addresses in DecompressOpcodeTable and
;	ControlCodeJumpTable.
;
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp /
;	cmpi; fixopcodes.js patches the cmp encoding after assembly.

									;map, a2 = tiles (DecompressGraphics data), d0 = start x, d1 = start y, d2
									;= width x, d3 = width y, d4 = start char, d5 = pal used bits (0-3) for
									;color fam 1-4. printy is restored and the tiles go last through
									;DecompressGraphics (returns d4 = end char)
	move.w	(printy).l,-(sp)
	move.w	(disflags).l,-(sp)
	bset.b	#dfng,(disflags).l
	movem.l	d0-d3/d5-d6/a0-a3,-(sp)	;2(sp) start x, $A(sp) width x, $E(sp) width y (low words of d0, d2, d3)
	move.w	d1,d6
	movea.l	#$BBCB0,a3				;a3 = target palette, a0 = palette data (CD: the cartridge has
									;#(palfadenew-M68K_RAM))
	bra.w	.00
.01									;loop
	move.b	(a0,d0.w),(a3,d0.w)		;copy the color
	dbf	d0,.01						;loop
.02									;loop
	adda.l	#$20,a0					;next line
	adda.l	#$20,a3					;next line
.00									;copy each palette line chosen in d5
	moveq	#$1F,d0
	lsr.w	#1,d5					;d5 bit n = copy palette line n; stop when no bits left
	bcs.w	.01
	bne.w	.02
	move.w	(printa).l,d5			;d5 = tile attribute bits (priority/palette/flip) from printa
	andi.w	#$F800,d5				;attribute bits
	move.w	$E(sp),d2
	subi.w	#1,d2
.loop2								;each map row
	bsr.w	xyVmMap					;set vram address from printx/printy/printm, a0 = Vdata
	move.w	d6,d0
	mulu.w	(a1),d0
	add.w	2(sp),d0
	asl.w	#1,d0					;d0 = byte offset of the first map word wanted
	move.w	$A(sp),d1
	subi.w	#1,d1
;CD: no cartridge twin
	move.w	d1,$BC000.l
	lea	$BC002.l,a0
.loop1								;each map word of the row
	move.w	$4(a1,d0.w),d3			;map word (map data starts 4 bytes in)
	add.w	d4,d3					;add the start char
	eor.w	d5,d3					;xor the attribute bits
;CD: no cartridge twin
	move.w	d3,(a0)+
	addi.w	#$2,d0
	dbf	d1,.loop1
.L3889A
	btst.b	#$7,$FF800E.l
	bne.s	.L3889A
	move.w	#$21,$FF8020.l
	jsr	$222C2.l
	bset.b	#$6,$FF800F.l
	jsr	$22268.l
.L388C0
	btst.b	#$6,$FF800E.l
	beq.s	.L388C0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L388DA
	btst.b	#$6,$FF800E.l
	bne.s	.L388DA
	bclr.b	#$7,$FF800F.l
	addi.w	#1,(printy).l
	addi.w	#1,d6
	dbf	d2,.loop2					;loop
	btst.b	#0,(sflags6).l			;map as is?
	bne.w	.0
;CD: no cartridge twin
	jsr	(DecompressGraphicsPlain).l
.0									;pop the d0-d3/d5-d6/a0-a3 saved above
	movem.l	(sp)+,d0-d3/d5-d6/a0-a3
	move.w	(sp)+,(disflags).l
	move.w	(sp)+,(printy).l
;CD: no cartridge twin
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.s	.L38934
	bset.b	#$5,$FF800F.l
	bra.s	.L3893C
.L38934
	bclr.b	#$5,$FF800F.l
.L3893C
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	rts
