;	Shared helpers used all over the game. They fade palettes, make random numbers and square
;	roots, start sounds, read up to four joysticks and wait for buttons, move and fill video
;	memory and set up the screen.

UnpackNibbles						;a0 = packed data, d0 = count: unpack 4-bit values into words at
									;nibblebuffer
	movem.l	d0-d2/a0-a1,-(sp)
	movea.w	#(nibblebuffer-M68K_RAM),a1	;a1 = output words
	clr.w	d2						;d2 bit 0 = which nibble is next
	bra.w	.next
.loop								;each nibble
	move.b	(a0)+,d1				;next nibble (one count per pass)
	bchg	#0,d2					;toggle high/low nibble
	bne.w	.lo						;low nibble?
	subq.w	#1,a0					;high nibble: read the same byte again next time
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
	movea.w	#(nibblebuffer-M68K_RAM),a1	;weights
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
	bpl.s	.findloop
	suba.w	#(nibblebuffer-M68K_RAM),a1
	move.w	a1,d0
	lsr.w	#1,d0					;word offset -> index
	movem.l	(sp)+,d1/a1
	rts

remap								;a0 = data (char set), d0 = size in words, d1 = vram dest, a1 = mapping
									;data (two color nibbles per byte, high nibble for even colors). Jumped to
									;from DecompressGraphics
	move.w	(disflags).w,-(sp)
	bset	#dfng,(disflags).w
	movem.l	d0-d4/a0-a2,-(sp)
	exg	d1,d0						;(keep EA register order)
	movea.l	a0,a2					;a2 = source tile words
	bsr.w	Vmaddr					;set vram write address; a0 = Vdata
	subq.w	#1,d1					;d1 = word count - 1
.1									;each source word
	moveq	#3,d0					;4 pixels per word (one pass per source word)
	move.w	(a2)+,d2
	clr.w	d3						;d3 = remapped word being built
.11									;each pixel
	move.w	d2,d4					;one pixel (low nibble of d2) per pass
	andi.w	#$F,d4
	lsr.w	#1,d4					;map byte = color/2
	move.b	0(a1,d4.w),d4
	btst	#0,d2					;odd color?
	bne.w	.2
	lsr.w	#4,d4					;even: high nibble
.2									;map nibble chosen
	andi.w	#$F,d4
	or.b	d4,d3					;put the new color into the result
	ror.w	#4,d3
	ror.w	#4,d2					;next pixel
	dbf	d0,.11						;loop
	move.w	d3,(a0)					;write the word to vram
	dbf	d1,.1						;loop
	movem.l	(sp)+,d0-d4/a0-a2
	move.w	(sp)+,(disflags).w
	rts
; fade all colors to black but don't upset palfadenew
forceblack							;fade all colors to black but don't upset palfadenew
	movem.l	d0/a0,-(sp)
	movea.w	#(palfadenew-M68K_RAM),a0
	moveq	#$1F,d0
.0									;black out each target color, saving it
	move.l	(a0),-(sp)				;save the target palette while blacking it
	clr.l	(a0)+
	dbf	d0,.0						;loop
	move.w	#$18,(palcount).w
	bsr.w	forcefade				;fade to the all-black palfadenew
	moveq	#$1F,d0					;32 longs
.1									;put each color back
	move.l	(sp)+,-(a0)				;put the saved palette back (reverse order)
	dbf	d0,.1						;loop
	movem.l	(sp)+,d0/a0
	rts
forceblack2							;fade to black, keeping palfadenew (saved on the stack and restored)
	movem.l	d0/a0,-(sp)
	movea.w	#(palfadenew-M68K_RAM),a0
	moveq	#$1F,d0					;32 longs
.loop								;black out each target color, saving it
	move.l	(a0),-(sp)
	clr.l	(a0)+
	dbf	d0,.loop					;loop
	move.w	#$64,(palcount).w		;copy now
	bsr.w	forcefade
	moveq	#$1F,d0					;32 longs
.loop2								;put each color back
	move.l	(sp)+,-(a0)
	dbf	d0,.loop2					;loop
	movem.l	(sp)+,d0/a0
	rts
forcefade							;regardless of interupts/disflags fade in new palettes, don't upset
									;anything else
	move	sr,-(sp)
	move.l	(VBint).w,-(sp)			;save the vblank routine
	move.w	(disflags).w,-(sp)
	bclr	#dfng,(disflags).w
	move.l	#vb2,(VBint).l			;minimal vblank handler (vb2) that runs the fade
	move	#$2500,sr				;interrupts on
.1									;loop
	tst.w	(palcount).w			;wait until the fade has finished (palcount < 0)
	bpl.s	.1
	move.w	(sp)+,(disflags).w
	move.l	(sp)+,(VBint).w			;restore the vblank routine
	move	(sp)+,sr
	rts
; fade from current color in color ram to color held in palfadenew
; this should be called during vblank because palette changes punch holes in video
cramfade							;fade from current color in color ram to color held in palfadenew. This
									;should be called during vblank because palette changes punch holes in
									;video. palcount 100 copies the palette with no fade (CopyPaletteToCRAM)
	tst.w	(palcount).w			;fading?
	bmi.w	rtss2
	cmpi.w	#$64,(palcount).w		;100 = copy now
	beq.w	CopyPaletteToCRAM
	subq.w	#1,(palcount).w
	bmi.w	rtss2
	clr.l	d0
	move.w	(palcount).w,d0
	cmp.w	#$18,d0					;above $18?
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
	movea.l	#palfadenew,a1			;a1 = destination colors
	movea.l	#Vdata,a0
	clr.w	d6						;d6 = cram address, 2 per color
.top								;loop
	move.w	d3,d2					;d2 = signed step for this color
	move.w	d6,d0
	swap	d0						;to the high word
	move.w	#$20,d0					;cram read
	move.l	d0,Vctrl-Vdata(a0)
	move.w	(a0),d7					;current color
	move.w	d7,d0					;current color
	and.w	d5,d0
	move.w	(a1)+,d1				;dest color
	and.w	d5,d1					;target component
	cmp.w	d1,d0					;same?
	beq.w	.next					;component already at target
	blt.w	.nn						;below target: step up
	neg.w	d2						;above target: step down
.nn									;component stepped
	add.w	d2,d0					;apply the step to the component
	and.w	d4,d7
	or.w	d0,d7					;merge the new component into the color
	move.l	#$C000,d0				;cram write
	move.b	d6,d0
	swap	d0						;to the high word
	move.l	d0,Vctrl-Vdata(a0)
	move.w	d7,(a0)
.next								;next color
	addq.w	#2,d6					;next color
	cmp.w	#$80,d6					;64 colors done?
	bne.s	.top
	rts
CopyPaletteToCRAM					;Copy all 64 palfadenew colours to colour ram, protected from vblank
	movem.l	d0/a0-a1,-(sp)
	move.w	(disflags).w,-(sp)
	bset	#dfng,(disflags).w
	movea.w	#(palfadenew-M68K_RAM),a1
	movea.l	#Vdata,a0
	move.l	#CRAM_W,Vctrl-Vdata(a0)
	moveq	#$1F,d0					;32 longs
.0									;copy each color pair
	move.l	(a1)+,(a0)				;two colors per long
	dbf	d0,.0						;loop
	st	(palcount).w
	move.w	(sp)+,(disflags).w
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
	move.w	(seed+2).w,d0			;seed+2 (92)
	move.w	d0,d1					;seed low
	move.w	(seed).w,d2
	mulu.w	#$E62D,d0
	mulu.w	#$BB40,d1
	mulu.w	#$E62D,d2
	add.w	d2,d1					;add the cross term
	swap	d0						;to the high word
	add.w	d1,d0
	swap	d0
	addq.l	#1,d0
	move.l	d0,(seed).w
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
	cmp.l	#$640,d0
	bhi.w	.m2						;large value: Newton iteration / binary search below
	move.l	d1,-(sp)				;find square root of d0
	moveq	#-1,d1
.0									;loop
	addq.w	#2,d1					;next odd number
	sub.w	d1,d0					;minus the odd number
	bcc.s	.0
	lsr.w	#1,d1					;d1 = 2*root+1 -> root
	move.w	d1,d0
	move.l	(sp)+,d1
	rts
.m2									;d0 > $640
	movem.l	d1-d4,-(sp)
	moveq	#9,d3					;max number of reps
	move.w	#$8000,d1				;binary search start
	cmp.l	#$F00000,d0				;over $F00000?
	bhi.w	.big					;too big for divu: binary search
	move.l	d0,d1
	lsr.l	#8,d1					;first guess = d0/256 + 2
	addq.w	#2,d1
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
	beq.s	.done					;no step left: d1 is the root
	move.w	d3,d4
	mulu.w	d3,d3
	cmp.l	d3,d0
	bcc.w	.lo						;d0 >= mid^2: raise low
	move.w	d4,d2
	bra.s	.bs
.lo									;d0 >= d3
	move.w	d4,d1
sfxarg = 16*4						;sfx / song: stack offset of the number word after the movem
	bra.s	.bs
; play sound effect number
; one word passed on stack
sfx									;play sound effect number. One word passed on stack
	movem.l	d0-d7/a0-a6,-(sp)		;sfxarg(sp) = the number word (above 15 longs and the return address)
	clr.l	d0
	move.w	sfxarg(sp),d0
	bmi.w	.none					;negative = no sound
	move.w	d0,(lastsfx).w			;remember the last effect
	jsr	(play_sfx_or_music_track).l
.none								;pop the d0-d7/a0-a6 saved above
	movem.l	(sp)+,d0-d7/a0-a6
	move.l	(sp),2(sp)				;return address over the number word
	addq.w	#2,sp					;(callee pops its own argument)
	rts
; play song number
; one word passed on stack
song								;play song number. One word passed on stack
	movem.l	d0-d7/a0-a6,-(sp)		;sfxarg(sp) = the number word (above 15 longs and the return address)
	clr.l	d0
	move.w	sfxarg(sp),d0
	bmi.w	.none					;negative = no song
	jsr	(play_sfx_or_music_track).l	;same call as sfx, without lastsfx
.none								;pop the d0-d7/a0-a6 saved above
	movem.l	(sp)+,d0-d7/a0-a6
	move.l	(sp),2(sp)				;return address over the number word
	addq.w	#2,sp					;drop the number word
	rts
; wait d0 vblanks or until input from either joystick
; return joystick variables (d0-d3) if any
waitx								;wait d0 vblanks or until input from either joystick. Return joystick
									;variables (d0-d3) if any. Called from ScoutingReport and
									;SetupStanleyCupCelebrationScreen
	clr.w	(waitxpad).w			;no pad bits yet
	neg.w	d0
	move.w	d0,(Vcount).w			;frame counter
.wait								;loop
	bsr.w	ReadJoy1
	move.w	d3,(waitxpad).w
	tst.w	d1						;any press?
	bne.w	rtss2
	bsr.w	ReadJoy2
	or.w	d3,(waitxpad).w			;plus its held bits
	tst.w	d1						;any press?
	bne.w	rtss2
	tst.w	(FourWayPlay).w			;four way?
	beq.w	.1
	bsr.w	ReadJoy3
	or.w	d3,(waitxpad).w			;plus its held bits
	tst.w	d1						;any press?
	bne.w	rtss2
	bsr.w	ReadJoy4
	or.w	d3,(waitxpad).w			;plus its held bits
	tst.w	d1						;any press?
	bne.w	rtss2
.1									;read pad 1 (and the others)
	move.w	(Vcount).w,d0			;frame counter
.0									;loop
	cmp.w	(Vcount).w,d0			;wait for the next vblank to change Vcount
	beq.s	.0						;wait for a new frame
	tst.w	d0						;time left?
	bmi.s	.wait					;still counting up to zero
	rts
; special version of waitx for zamboni crossing
; wait d0 vblanks or until input from either joystick
; retrun joystick variables (d0-d3) if any
waitxsr								;Wait d0 vblanks while the zamboni crosses
	movem.l	d4-d7/a0-a3,-(sp)
	neg.w	d0						;Vcount counts up from -d0 to 0
	move.w	d0,(Vcount).w			;frame counter
.wait								;loop
	cmpi.w	#$708,(Zamx).w			;zamboni across?
	bhi.w	.nz						;zamboni past $708: stop moving it
	addq.w	#1,(Zamx).w
.nz									;zamboni moved
	moveq	#1,d7					;1 frame
	jsr	(updatecrowdf).w			;4EB8: target below $8000
	jsr	(RunArenaAnim).l
	clr.w	(pausepad).w
	bclr	#sfpj,(sflags).w
	bsr.w	ReadJoy1
	bsr.w	ProcessInputWithRepeat
	tst.w	d1						;any press?
	bne.w	.key
	clr.w	(pausepad).w
	bset	#sfpj,(sflags).w
	bsr.w	ReadJoy2
	bsr.w	ProcessInputWithRepeat
	tst.w	d1						;any press?
	bne.w	.key
	tst.w	(FourWayPlay).w			;four way?
	beq.w	.vid
	bclr	#sfpj,(sflags).w
	move.w	#3,(pausepad).w
	bsr.w	ReadJoy3
	bsr.w	ProcessInputWithRepeat
	tst.w	d1						;any press?
	bne.w	.key
	tst.w	(FourWayPlay).w			;four way?
	beq.w	.vid
	bset	#sfpj,(sflags).w
	move.w	#4,(pausepad).w
	bsr.w	ReadJoy4
	bsr.w	ProcessInputWithRepeat
	tst.w	d1						;any press?
	beq.w	.vid
.key								;a button: run the menu
	move.w	(Vcount).w,d0			;frame counter
	cmp.w	#$FF88,d0				;more than $78 frames left?
	blt.w	.menu
	moveq	#$FFFFFF88,d0
.menu								;timer clamped
	movem.w	d0,-(sp)
	jsr	(HandleMenuInput).w			;4EB8: target below $8000
	bne.w	.resume					;menu did not end the screen: carry on waiting
	addq.w	#2,sp					;drop it
	bset	#7,d1					;tell the caller the menu ended it
	bra.w	.ex
.resume								;menu left the screen up
	move.w	(sp)+,(Vcount).w
.vid								;redraw and keep waiting
	bsr.w	setvideo
	move.w	(Vcount).w,d0			;frame counter
.0									;loop
	cmp.w	(Vcount).w,d0			;wait for the next vblank
	beq.s	.0						;wait for a new frame
	tst.w	d0						;time left?
	bmi.w	.wait
.ex									;exit: restore the registers
	movem.l	(sp)+,d4-d7/a0-a3
	rts
; wait for either joystick input
; return d1 = new button presses
waitjoy								;wait for either joystick input. Return d1 = new button presses. it as
									;data (no caller found)
	move.w	(Vcount).w,d0			;frame counter
.0									;loop
	cmp.w	(Vcount).w,d0
	beq.s	.0						;wait for a new frame
	bsr.w	orjoy					;read the pads
	beq.s	waitjoy					;no new press: wait again
	rts
; return d1 = new button presses
orjoy								;return d1 = new button presses from either joystick
	tst.w	(FourWayPlay).w			;check for 4-way play?
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
	bsr.s	nodiag
	tst.w	d3						;anything held?
	beq.w	rtss2
	tst.w	d2						;changed?
	bne.w	.chg					;buttons changed: restart the delay
	subq.w	#1,(repeatdelayframes).w
	bpl.w	rtss2
	move.w	#4,(repeatdelayframes).w	;repeat rate
	move.w	d3,d1					;repeat the held buttons
	rts
.chg								;d2 <> 0
	move.w	#$F,(repeatdelayframes).w
	rts
; Read controller 1
; return d0 = direction (bit 0-3) and new button (bit 4-7) presses
; d1 = new presses (all 8 bits)
; d2 = changed buttons (all 8)
; d3 = current held buttons (all 8)
ReadJoy1							;read controller 1 from the byte ReadPads left in PadRaw1. Return d0 =
									;direction (bit 0-3) and new button (bit 4-7) presses, d1 = new presses
									;(all 8 bits), d2 = changed buttons (all 8), d3 = held buttons (all 8)
	move.b	(pad4way1).w,d0
	bsr.w	ReadJoy					;d1 = buttons down now
	move.w	(lj1).w,d2				;last frame's buttons
	move.w	d1,(lj1).w
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
	move.b	(pad4way2).w,d0
	bsr.w	ReadJoy
	move.w	(lj2).w,d2
	move.w	d1,(lj2).w				;store the new one
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1					;d1 = new presses
	rts
ReadJoy3							;read 4 way play pad 3 (pad4way3). Same returns as ReadJoy1
	move.b	(pad4way3).w,d0
	bsr.w	ReadJoy
	move.w	(lj3).w,d2
	move.w	d1,(lj3).w				;store the new one
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1					;d1 = new presses
	rts
ReadJoy4							;read 4 way play pad 4 (pad4way4). Same returns as ReadJoy1
	move.b	(pad4way4).w,d0
	bsr.w	ReadJoy
	move.w	(lj4).w,d2
	move.w	d1,(lj4).w				;store the new one
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
	movea.l	#jdtab,a0
	move.b	0(a0,d1.w),d1			;direction
	or.w	d1,d0
	move.w	(sp)+,d1
	rts
jdtab	dc.b	8					;convert buttons l,r,d,u into directions 0-7,8
	;convert button l,r,d,u into directions 0-7,8
	dc.b	0,4,8,6,7,5,8,2,1,3,8,8,8,8,8
; init dma transfer and protect vblank interruption
; d0 = words to transfer
; d1 = initial vram address
; a0 = address to transfer from
DoDMApro							;initiate dma transfer and protect from vblank interuption. d0 = words to
									;transfer, d1 = initial vram address, a0 = address to transfer from.
									;Jumped to from DecompressGraphics
	move.w	(disflags).w,-(sp)
	bset	#dfng,(disflags).w
	bsr.w	DoDMA
	move.w	(sp)+,(disflags).w
	rts
; initiate dma transfer (dma transfer bug is compensated for)
; d0 = words to transfer
; d1 = destination vram address
; a0 = source address
DoDMA								;initiate dma transfer (dma transfer bug is compensated for). d0 = words
									;to transfer, d1 = destination vram address, a0 = source address
	movem.l	d2-d3/a1,-(sp)
	move.w	d0,d2
	add.w	d2,d2
	add.w	a0,d2					;carry out = source+length crosses a 64k boundary
	bcc.w	.nd						;no boundary crossed
	beq.w	.nd						;ends exactly on the boundary: one transfer
	lsr.w	#1,d2					;do 2 transers if source address crosses 64k boundary
	sub.w	d2,d0					;d0 = words before the boundary, d2 = words after it
	move.w	d0,-(sp)
	bsr.w	.dd
	move.w	(sp)+,d0
	add.w	d0,d0					;advance vram dest and source by the words done
	add.w	d0,d1					;plus the bytes done
	adda.w	d0,a0
	move.w	d2,d0					;second part: the rest, falls into .nd
	bra.w	.nd						;second part
.dd									;(a global in ; local here, only DoDMA uses it)
	movem.l	d2-d3/a1,-(sp)
.nd									;DMA the part
	lea	(Vctrl).l,a1				;vdp control port
	move.w	#VDPR_MODE2+$54,(a1)
	move.w	#VDPR_AUTOINC+$02,(a1)
	move.w	#$9300,d2
	move.b	d0,d2					;reg 19: length low
	move.w	d2,(a1)
	move.w	#$9400,d2
	lsr.w	#8,d0
	move.b	d0,d2					;reg 20: length high
	move.w	d2,(a1)
	move.l	a0,d0
	lsr.l	#1,d0					;source in words
	move.w	#$9500,d2
	move.b	d0,d2					;reg 21: source low
	move.w	d2,(a1)
	lsr.l	#8,d0
	move.w	#$9600,d2
	move.b	d0,d2					;reg 22: source mid
	move.w	d2,(a1)
	lsr.l	#8,d0
	andi.b	#$7F,d0
	move.w	#$9700,d2
	move.b	d0,d2					;reg 23: source high (dma mode bits 7-6 = 0: 68k to vram)
	move.w	d2,(a1)
	clr.l	d0
	move.w	d1,d0					;build the vdp command long for a vram write with dma
	asl.l	#2,d0
	lsr.w	#2,d0
	move.l	d0,d3
	ori.l	#$804000,d0				;vram write with DMA
	move.l	d0,(dmaram).w			;the last command word is written from ram (dma bug workaround)
	move	sr,-(sp)
	move	#$2700,sr				;interrupts off
	move.w	#$100,(IO_Z80BUS).l		;stop the Z80
.loop								;loop
	btst	#0,(IO_Z80BUS).l		;stopped?
	bne.s	.loop
	move.w	(dmaram+2).w,(a1)
	move.w	(dmaram).w,(a1)			;this write starts the dma
	bsr.w	WaitDMA					;wait for the DMA
	move.w	#VDPR_MODE2+$64,(a1)
	clr.w	(IO_Z80BUS).l
	cmpa.w	#0,a0					;ram source?
	bge.w	.0
	ori.w	#$4000,d3
	swap	d3						;to the high word
	andi.w	#3,d3
	move.l	d3,(a1)					;vram write command, no dma
	move.w	(a0),-4(a1)				;write the first word again
.0									;DMA or single word done
	move	(sp)+,sr
	movem.l	(sp)+,d2-d3/a1
	rts
DoDMA_nd2							;vram to vram copy by dma, protected from vblank
	movem.l	d0-d3/a1,-(sp)
	move.w	(disflags).w,-(sp)
	bset	#dfng,(disflags).w
	lea	(Vctrl).l,a1				;vdp control port
	move.w	#VDPR_MODE2+$54,(a1)
	move.w	#VDPR_AUTOINC+$01,(a1)
	move.w	#$9300,d3
	move.b	d0,d3
	move.w	d3,(a1)
	move.w	#$9400,d3
	lsr.w	#8,d0
	move.b	d0,d3
	move.w	d3,(a1)
	move.w	#$9500,d3				;source low
	move.b	d2,d3
	move.w	d3,(a1)
	move.w	#$9600,d3				;source high
	lsr.w	#8,d2
	move.b	d2,d3
	move.w	d3,(a1)
	move.w	#VDPR_DMASRCH+$C0,(a1)
	clr.l	d0
	move.w	d1,d0					;destination address -> vdp command (address bits 14-15 go to the second
									;word)
	asl.l	#2,d0
	lsr.w	#2,d0
	swap	d0						;to the high word
	ori.w	#$C0,d0					;vram copy command
	move.l	d0,(dmaram).w
	move.w	#$100,(IO_Z80BUS).l		;stop the Z80
.loop								;loop
	btst	#0,(IO_Z80BUS).l		;stopped?
	bne.s	.loop
	move.w	(dmaram).w,(a1)
	move.w	(dmaram+2).w,(a1)
	bsr.w	WaitDMA					;wait for the DMA
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
DoFill								;fill vram. d0 = words to fill, d1 = vram address, d2 = data to fill with
	movem.l	d3/a1,-(sp)
	movea.l	#Vdata,a1
	andi.l	#$FFFF,d1
	asl.l	#2,d1					;build the vram write command for address d1
	lsr.w	#2,d1
	ori.w	#$4000,d1
	swap	d1						;to the high word
	move.l	d1,Vctrl-Vdata(a1)
	move.w	d2,d3
	swap	d3						;to the high word
	move.w	d2,d3					;d3 = fill word twice, for long writes
	lsr.w	#1,d0					;words -> longs
	subq.w	#1,d0
.0									;each long of the fill
	move.l	d3,(dmaram).w
	move.w	(dmaram).w,(a1)
	move.w	(dmaram+2).w,(a1)
	dbf	d0,.0						;loop
	movem.l	(sp)+,d3/a1
	rts
WaitDMA								;wait for dma completion
	move.w	(Vctrl).l,-(sp)			;read the vdp status: 1(sp) is its low byte
	btst	#1,1(sp)				;status bit 1 = dma busy
	addq.w	#2,sp					;drop it
	bne.s	WaitDMA
	rts
; d0 = color to fade to
setVram								;initialize all necesary video parameters based on my variables. d0 =
									;color to fade to. Falls into setVram_0
	movea.w	#(palfadenew-M68K_RAM),a0
	moveq	#$3F,d1
.0									;fill each target color
	move.w	d0,(a0)+				;fill the 64 target colors with d0
	dbf	d1,.0						;loop
	move.w	#$18,(palcount).w
	bsr.w	forcefade				;fade the screen to that color
setVram_0							;second half of setVram without the fade: clear vram and set the VDP
									;registers from disflags, Map1col, VmMAP1-3, VSPRITES and VSCRLPM.
									;Falls in from setVram, called from EASportsScreen and HiScoreScreen
	move.w	(disflags).w,-(sp)
	bset	#dfng,(disflags).w
	move.w	#VDPR_AUTOINC+$02,(Vctrl).l
	clr.w	d0
	bsr.w	Vmaddr					;vram address 0, a0 = Vdata
	move.w	#$3FFF,d0				;$4000 longs
	clr.l	d1
.9									;clear each long of VRAM
	move.l	d1,(a0)
	dbf	d0,.9						;loop
	move.w	#$8C00,d0				;8 for shadow mode
	btst	#df32c,(disflags).w
	bne.w	.i32					;32 column flag set: leave bits 0 and 7 clear
	ori.w	#$81,d0
.i32								;column mode set
	move.w	d0,Vctrl-Vdata(a0)		;40 col mode, no interlace, normal brightness
	move.w	#VDPR_MODE1+$04,Vctrl-Vdata(a0)	;512 color palette enable
	move.w	#VDPR_MODE2+$64,Vctrl-Vdata(a0)
	move.w	#$9001,d0				;playfield is 64x32
	cmpi.w	#6,(Map1col).w			;64 wide?
	beq.w	.i64					;Map1col 6 = 64 columns wide
	move.w	#$9003,d0				;otherwise 128x32
.i64								;map width set
	move.w	d0,Vctrl-Vdata(a0)
	move.w	#$8200,d0				;reg 2: map 1 address
	move.b	(VmMAP1).w,d0
	lsr.b	#2,d0
	andi.b	#$38,d0
	move.w	d0,Vctrl-Vdata(a0)
	move.w	#$8400,d0				;reg 4: map 2 address
	move.b	(VmMAP2).w,d0
	lsr.b	#5,d0
	move.w	d0,Vctrl-Vdata(a0)
	move.w	#$8300,d0				;reg 3: map 3 address
	move.b	(VmMAP3).w,d0
	lsr.b	#2,d0
	andi.b	#$3E,d0
	move.w	d0,Vctrl-Vdata(a0)
	move.w	#$8500,d0				;reg 5: sprite table
	move.b	(VSPRITES).w,d0
	lsr.b	#1,d0
	move.w	d0,Vctrl-Vdata(a0)
	move.w	#$8D00,d0				;reg $D: scroll table
	move.b	(VSCRLPM).w,d0
	lsr.b	#2,d0
	move.w	d0,Vctrl-Vdata(a0)
	move.w	#VDPR_WINX,Vctrl-Vdata(a0)	;disable plane 3 graphics
	move.w	#VDPR_WINY,Vctrl-Vdata(a0)	;disable plane 3 graphics
	move.w	#VDPR_BGCOL,Vctrl-Vdata(a0)	;Palette # 0 is border/transparent
	move.w	#VDPR_MODE3,Vctrl-Vdata(a0)	;Scroll mode (entire scroll)
	move.l	#VSRAM_W,Vctrl-Vdata(a0)
	move.l	#0,(a0)					;playfield 1/2
	move.w	(sp)+,(disflags).w
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
	bset	#dfng,(disflags).w
	movem.l	d0-d3/d5-d6/a0-a3,-(sp)	;2(sp) start x, $A(sp) width x, $E(sp) width y (low words of d0, d2, d3)
	move.w	d1,d6
	movea.w	#(palfadenew-M68K_RAM),a3	;a3 = target palette, a0 = palette data
	bra.w	.00
.01									;loop
	move.b	0(a0,d0.w),0(a3,d0.w)	;copy the color
	dbf	d0,.01						;loop
.02									;loop
	adda.l	#$20,a0					;next line
	adda.l	#$20,a3					;next line
.00									;copy each palette line chosen in d5
	moveq	#$1F,d0
	lsr.w	#1,d5					;d5 bit n = copy palette line n; stop when no bits left
	bcs.s	.01
	bne.s	.02
	move.w	(printa).w,d5			;d5 = tile attribute bits (priority/palette/flip) from printa
	andi.w	#$F800,d5				;attribute bits
	move.w	$E(sp),d2
	subq.w	#1,d2
.loop2								;each map row
	bsr.w	xyVmMap					;set vram address from printx/printy/printm, a0 = Vdata
	move.w	d6,d0
	mulu.w	(a1),d0
	add.w	2(sp),d0
	asl.w	#1,d0					;d0 = byte offset of the first map word wanted
	move.w	$A(sp),d1
	subq.w	#1,d1
.loop1								;each map word of the row
	move.w	4(a1,d0.w),d3			;map word (map data starts 4 bytes in)
	add.w	d4,d3					;add the start char
	eor.w	d5,d3					;xor the attribute bits
	move.w	d3,(a0)					;write the name table entry
	addq.w	#2,d0
	dbf	d1,.loop1					;loop
	addq.w	#1,(printy).w
	addq.w	#1,d6
	dbf	d2,.loop2					;loop
	btst	#0,(sflags6).w			;map as is?
	bne.w	.0
	bsr.w	DecompressGraphicsPlain
.0									;pop the d0-d3/d5-d6/a0-a3 saved above
	movem.l	(sp)+,d0-d3/d5-d6/a0-a3
	move.w	(sp)+,(disflags).w
	move.w	(sp)+,(printy).w
	rts
	include	decompress94.asm		;DecompressGraphicsWithCallback ... FlushOutputBuffer (93G layout)
	include	print94.asm				;xyVmMap ... AddTeamBlock (93G layout)
