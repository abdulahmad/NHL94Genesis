;	HOCKEY.BIN $1BBB2-$1C10B (runtime $36BB2-$3710B): middle94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	Part 1 of middle94 (part 2 is middle94_2.asm; $1C10C-$1C2CF between them is src/segacd/sfxcd.asm,
;	gate34.asm, cdrequest.asm and cdtrack.asm).

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

Vmaddr	equ	$3871E
rtss2	equ	$3C000
vb2	equ	$3DB90

	org	$36BB2

;	Shared helpers used all over the game. They fade palettes, make random numbers and square
;	roots, start sounds, read up to four joysticks and wait for buttons, move and fill video
;	memory and set up the screen.

UnpackNibbles						;a0 = packed data, d0 = count: unpack 4-bit values into words at
									;nibblebuffer
	movem.l	d0-d2/a0-a1,-(sp)
	movea.l	#(nibblebuffer-M68K_RAM),a1	;a1 = output words
	clr.w	d2						;d2 bit 0 = which nibble is next
	bra.w	.next
.loop								;each nibble
	move.b	(a0)+,d1				;next nibble (one count per pass)
	bchg	#0,d2					;toggle high/low nibble
	bne.w	.lo						;low nibble?
;CD: no cartridge twin
	suba.w	#$1,a0
	lsr.w	#4,d1					;high nibble down
.lo									;nibble in the low bits
	andi.w	#$F,d1
	move.w	d1,(a1)+
.next								;loop d0 times
	dbf	d0,.loop					;loop count in d0
	movem.l	(sp)+,d0-d2/a0-a1
	rts
WeightedRandomSelect				;d0 = number of word weights at nibblebuffer:
									;return a weighted random index
	movem.l	d1/a1,-(sp)
	movea.l	#(nibblebuffer-M68K_RAM),a1	;weights
	clr.w	d1						;d1 = running total of the weights
	bra.w	.pick
.sumloop							;add each weight
	add.w	(a1)+,d1
.pick								;loop d0 times
	dbf	d0,.sumloop					;loop
	move.w	d1,d0
	bsr.w	randomd0				;random 0 to total-1
.findloop							;loop
	sub.w	-(a1),d0				;minus the weight
	bpl.w	.findloop
	suba.l	#(nibblebuffer-M68K_RAM),a1
	move.w	a1,d0
	lsr.w	#1,d0					;word offset -> index
	movem.l	(sp)+,d1/a1
	rts
;CD: no cartridge twin
remap								;a0 = data (char set), d0 = size in words, d1 = vram dest, a1 = mapping
									;(CD: entered here; the cartridge remap starts at its first twin line,
									;$36C40)
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst.b	#$5,$FF800F.l
	beq.s	.L36C2C
	move.w	#$1,-(a6)
	bra.s	.L36C30
.L36C2C
	move.w	#$0,-(a6)
.L36C30
	bclr.b	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6

									;data (two color nibbles per byte, high nibble for even colors). Jumped to
									;from DecompressGraphics
	move.w	(disflags).l,-(sp)
	bset.b	#dfng,(disflags).l
	movem.l	d0-d4/a0-a2,-(sp)
;CD: no cartridge twin
	exg	d0,d1
	movea.l	a0,a2					;a2 = source tile words
	bsr.w	Vmaddr					;set vram write address; a0 = Vdata
	subi.w	#1,d1					;d1 = word count - 1
.1									;each source word
	moveq	#3,d0					;4 pixels per word (one pass per source word)
	move.w	(a2)+,d2
	clr.w	d3						;d3 = remapped word being built
.11									;each pixel
	move.w	d2,d4					;one pixel (low nibble of d2) per pass
	andi.w	#$F,d4
	lsr.w	#1,d4					;map byte = color/2
	move.b	(a1,d4.w),d4
	btst	#0,d2					;odd color?
	bne.w	.2
	lsr.w	#4,d4					;even: high nibble
.2									;map nibble chosen
	andi.w	#$F,d4
	or.b	d4,d3					;put the new color into the result
	ror.w	#4,d3
	ror.w	#4,d2					;next pixel
	dbf	d0,.11						;loop
;CD: no cartridge twin
.L36C88
	btst.b	#$7,$FF800E.l
	bne.s	.L36C88
	move.w	d3,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L36CA8
	btst.b	#$6,$FF800E.l
	beq.s	.L36CA8
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L36CC2
	btst.b	#$6,$FF800E.l
	bne.s	.L36CC2
	bclr.b	#$7,$FF800F.l
	dbf	d1,.1						;loop
	movem.l	(sp)+,d0-d4/a0-a2
	move.w	(sp)+,(disflags).l
;CD: no cartridge twin
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.s	.L36CF8
	bset.b	#$5,$FF800F.l
	bra.s	.L36D00
.L36CF8
	bclr.b	#$5,$FF800F.l
.L36D00
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	rts
; fade all colors to black but don't upset palfadenew
forceblack							;fade all colors to black but don't upset palfadenew
	movem.l	d0/a0,-(sp)
	movea.l	#$BBCB0,a0				;CD: the cartridge has #(palfadenew-M68K_RAM)
	moveq	#$1F,d0
.0									;black out each target color, saving it
	move.l	(a0),-(sp)				;save the target palette while blacking it
	clr.l	(a0)+
	dbf	d0,.0						;loop
	move.w	#$18,(palcount).l
	bsr.w	forcefade				;fade to the all-black palfadenew
	moveq	#$1F,d0					;32 longs
.1									;put each color back
	move.l	(sp)+,-(a0)				;put the saved palette back (reverse order)
	dbf	d0,.1						;loop
	movem.l	(sp)+,d0/a0
	rts
forceblack2							;fade to black, keeping palfadenew (saved on the stack and restored)
	movem.l	d0/a0,-(sp)
	movea.l	#$BBCB0,a0				;CD: the cartridge has #(palfadenew-M68K_RAM)
	moveq	#$1F,d0					;32 longs
.loop								;black out each target color, saving it
	move.l	(a0),-(sp)
	clr.l	(a0)+
	dbf	d0,.loop					;loop
	move.w	#$64,(palcount).l		;copy now
	bsr.w	forcefade
	moveq	#$1F,d0					;32 longs
.loop2								;put each color back
	move.l	(sp)+,-(a0)
	dbf	d0,.loop2					;loop
	movem.l	(sp)+,d0/a0
	rts
forcefade							;CD: its first lines have no twin; the rest of it starts here
	move.l	(VBint).l,-(sp)			;save the vblank routine
	move.w	(disflags).l,-(sp)
	bclr.b	#dfng,(disflags).l
	move.l	#vb2,(VBint).l			;minimal vblank handler (vb2) that runs the fade
;CD: no cartridge twin
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst.b	#$5,$FF800F.l
	beq.s	.L36D9C
	move.w	#$1,-(a6)
	bra.s	.L36DA0
.L36D9C
	move.w	#$0,-(a6)
.L36DA0
	bclr.b	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	bset.b	#$5,$FF800F.l
.L36DB8
	tst.w	(palcount).l
	bpl.w	.L36DB8
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.s	.L36DD8
	bset.b	#$5,$FF800F.l
	bra.s	.L36DE0
.L36DD8
	bclr.b	#$5,$FF800F.l
.L36DE0
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	move.w	(sp)+,(disflags).l
	move.l	(sp)+,(VBint).l
	rts
; fade from current color in color ram to color held in palfadenew
; this should be called during vblank because palette changes punch holes in video
cramfade							;fade from current color in color ram to color held in palfadenew. This
									;should be called during vblank because palette changes punch holes in
									;video. palcount 100 copies the palette with no fade (CopyPaletteToCRAM)
	tst.w	(palcount).l			;fading?
	bmi.w	rtss2
	cmpi.w	#$64,(palcount).l		;100 = copy now
	beq.w	CopyPaletteToCRAM
	subq.w	#1,(palcount).l
	bmi.w	rtss2
	clr.l	d0
	move.w	(palcount).l,d0
	cmpi.w	#$18,d0					;above $18?
	bgt.w	rtss2
	divu.w	#3,d0
	swap	d0						;d0 = palcount mod 3
	asl.w	#2,d0					;shifter 0/4/8
	moveq	#2,d3					;d3 = one step of the component (2 << shift)
	asl.w	d0,d3
	moveq	#$E,d5					;d5 = component mask ($E << shift)
	asl.w	d0,d5
	move.w	d5,d4
	not.w	d4						;d4 = mask of the other components
;CD: no cartridge twin
	move.l	d3,$BBC88.l
	move.l	d4,$BBC8C.l
	move.l	d5,$BBC90.l
	jsr	$222C2.l
.L36E52
	btst.b	#$4,$FF800E.l
	bne.s	.L36E52
	move.w	#$1D,$FF8026.l
	bset.b	#$3,$FF800F.l
.L36E6C
	btst.b	#$3,$FF800E.l
	beq.s	.L36E6C
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L36E86
	btst.b	#$3,$FF800E.l
	bne.s	.L36E86
	bclr.b	#$4,$FF800F.l
	jsr	$22268.l
	rts
CopyPaletteToCRAM					;Copy all 64 palfadenew colours to colour ram, protected from vblank
	movem.l	d0/a0-a1,-(sp)
	move.w	(disflags).l,-(sp)
	bset.b	#dfng,(disflags).l
	movea.l	#$BBCB0,a1				;CD: the cartridge has #(palfadenew-M68K_RAM)
	movea.l	#Vdata,a0
;CD: no cartridge twin
.L36EBE
	btst.b	#$4,$FF800E.l
	bne.s	.L36EBE
	move.w	#$30,$FF8026.l
	move.l	#$C0000000,$FF8028.l
	bset.b	#$3,$FF800F.l
.L36EE2
	btst.b	#$3,$FF800E.l
	beq.s	.L36EE2
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L36EFC
	btst.b	#$3,$FF800E.l
	bne.s	.L36EFC
	bclr.b	#$4,$FF800F.l
	moveq	#$1F,d0
.0									;CD: placed where the disc branches to it
.L36F10
	btst.b	#$4,$FF800E.l
	bne.s	.L36F10
	move.w	#$33,$FF8026.l
	move.l	(a1)+,$FF8028.l
	bset.b	#$3,$FF800F.l
.L36F30
	btst.b	#$3,$FF800E.l
	beq.s	.L36F30
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L36F4A
	btst.b	#$3,$FF800E.l
	bne.s	.L36F4A
	bclr.b	#$4,$FF800F.l
	dbf	d0,.0						;loop
	st.b	(palcount).l
	move.w	(sp)+,(disflags).l
	movem.l	(sp)+,d0/a0-a1
	rts
;CD: no cartridge twin
	movem.l	d0/a0-a1,-(sp)
	move.w	(disflags).l,-(sp)
	bset.b	#$2,(disflags).l
	movea.l	#palfadenew,a1
	movea.l	#$C00000,a0
.L36F90
	btst.b	#$7,$FF800E.l
	bne.s	.L36F90
	move.l	#$C0000000,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L36FB4
	btst.b	#$6,$FF800E.l
	beq.s	.L36FB4
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L36FCE
	btst.b	#$6,$FF800E.l
	bne.s	.L36FCE
	bclr.b	#$7,$FF800F.l
	moveq	#$1F,d0
.L36FE2
	btst.b	#$7,$FF800E.l
	bne.s	.L36FE2
	move.l	(a1)+,$FF8022.l
	move.w	#$E,$FF8020.l
	bset.b	#$6,$FF800F.l
.L37002
	btst.b	#$6,$FF800E.l
	beq.s	.L37002
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3701C
	btst.b	#$6,$FF800E.l
	bne.s	.L3701C
	bclr.b	#$7,$FF800F.l
	dbf	d0,.L36FE2
	st.b	(palcount).l
	move.w	(sp)+,(disflags).l
	movem.l	(sp)+,d0/a0-a1
	rts
; d0 = range
; return d0 = random number (-range < d0 < range)
randomd0s							;d0 = range. Return d0 = random number (-range < d0 < range)
	move.w	d0,-(sp)
	asl.w	#1,d0					;range*2
	bsr.w	randomd0
	sub.w	(sp)+,d0				;shift down to -range+1 .. range-1
	rts
; d0 = range
; return random number in d0 (0 <= d0 < range)
randomd0							;d0 = range. Return random number in d0 (0 <= d0 < range)
	movem.l	d0-d2,-(sp)				;2(sp) = range (the saved d0 low word)
	move.w	(seed+2).l,d0			;seed+2 (92)
	move.w	d0,d1					;seed low
	move.w	(seed).l,d2
	mulu.w	#$E62D,d0
	mulu.w	#$BB40,d1
	mulu.w	#$E62D,d2
	add.w	d2,d1					;add the cross term
	swap	d0						;to the high word
	add.w	d1,d0
	swap	d0
	addq.l	#1,d0
	move.l	d0,(seed).l
	asr.l	#8,d0
	mulu.w	2(sp),d0				;times the range
	swap	d0						;d0 = result 0 <= d0 < range
	addq.w	#4,sp					;skip the saved d0 so the result survives
	movem.l	(sp)+,d1-d2
	rts
; returns d0.L^.5 in d0
Sroot								;Square Root, this returns (d0.L)^.5 in d0. Large values use a binary
									;search
	tst.l	d0						;zero?
	beq.w	rtss2
	cmpi.l	#$640,d0
	bhi.w	.m2						;large value: Newton iteration / binary search below
	move.l	d1,-(sp)				;find square root of d0
	moveq	#-1,d1
.0									;loop
	addq.w	#2,d1					;next odd number
	sub.w	d1,d0					;minus the odd number
	bcc.w	.0
	lsr.w	#1,d1					;d1 = 2*root+1 -> root
	move.w	d1,d0
	move.l	(sp)+,d1
	rts
.m2									;d0 > $640
	movem.l	d1-d4,-(sp)
	moveq	#9,d3					;max number of reps
	move.w	#$8000,d1				;binary search start
	cmpi.l	#$F00000,d0				;over $F00000?
	bhi.w	.big					;too big for divu: binary search
	move.l	d0,d1
	lsr.l	#8,d1					;first guess = d0/256 + 2
	addi.w	#2,d1
.top								;Newton steps until the guess settles
	move.w	d1,d2					;Newton step: d1 = (d0/guess + guess)/2
	move.l	d0,d1
	divu.w	d2,d1
	add.w	d2,d1
	lsr.w	#1,d1
	cmp.w	d1,d2					;stop when the guess stops changing, or after 10 steps
	dbeq	d3,.top					;loop
.done								;loop
	move.w	d1,d0					;d0 = root (shared exit of both methods)
	movem.l	(sp)+,d1-d4
	rts
.big								;binary search for large values
	moveq	#0,d1
	moveq	#-1,d2
.bs									;loop
	move.w	d1,d3					;d3 = (low+high)/2, carry shifted back in
	add.w	d2,d3
	roxr.w	#1,d3
	cmp.w	d3,d1					;same as low?
	beq.w	.done					;no step left: d1 is the root
	move.w	d3,d4
	mulu.w	d3,d3
	cmp.l	d3,d0
	bcc.w	.lo						;d0 >= mid^2: raise low
	move.w	d4,d2
	bra.w	.bs
.lo									;d0 >= d3
	move.w	d4,d1
sfxarg = 16*4						;sfx / song: stack offset of the number word after the movem
	bra.w	.bs
