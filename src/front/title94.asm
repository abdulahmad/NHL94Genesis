;	Title screen and scrolling credits. New in 94.

TitleScreen							;the title screen (TitleScreenImg, NHLShieldImg, PAlogoImg, TitleImg) with
									;the vblank VBlank_TitleScreen, song $78, then the
									;scrolling credits (Credits, CreditsPages text; CreditsPrintRow,
									;CreditsWait) until start. Called from Opening
	move	#$2700,sr				;interrupts off
	move.w	(HVcount).l,(seed).w	;seed the random numbers from the beam position
	move.w	(HVcount).l,(seed+2).w
	move.l	#VBlank_TitleScreen,(VBint).l
	bset	#df32c,(disflags).w		;32 cell mode
	move.w	#5,(Map3col).w
	move.w	#$A000,(VmMAP2).w
	move.w	#7,(Map2col).w
	move.w	#$C000,(VmMAP1).w
	move.w	#7,(Map1col).w
	move.w	#$F000,(VmMAP3).w
	move.w	#$F800,(VSPRITES).w
	move.w	#$FC00,(VSCRLPM).w
	move.w	#0,d0					;fade to color 0
	jsr	(setVram).l
	movea.l	#Vdata,a0
	move.w	#VDPR_WINX,Vctrl-Vdata(a0)
	move.w	#VDPR_WINY+$17,Vctrl-Vdata(a0)	;window plane for the bottom rows
	move.w	#VDPR_MODE3+$03,Vctrl-Vdata(a0)	;line scroll for the credits
	clr.w	(Vscroll).w
	jsr	(printz).l					;map 1 at the top left
	String	CC_Font1,0,0
	move.l	#$80,d0					;clear both text maps
	moveq	#$20,d1
	move.l	#$7FF,d2				;blank char
	jsr	(eraser).l
	jsr	(printz).l					;map 3 at the top left
	String	CC_Font2,0,0
	move.l	#$80,d0
	moveq	#$20,d1
	move.l	#$7FF,d2				;blank char
	jsr	(eraser).l
	clr.w	d4
	move.w	d4,-(sp)
	jsr	(printz).l					;map 2 at the top
	String	CC_Font3,0,0
	movea.l	#TitleScreenImg,a0		;the top of the title picture
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1				;a1 = map data
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	#$17,d3
	moveq	#$F,d5					;palette lines 0-3
	jsr	(dobitmap).l
	move.w	d4,(TempWord1).w
	move.w	(sp)+,d4
	jsr	(printz).l					;then its bottom 5 rows in the window plane
	String	CC_Font2,0,$17
	movea.l	#TitleScreenImg,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1				;a1 = map data
	clr.w	d0
	move.w	#$17,d1
	move.w	(a1),d2
	move.w	#5,d3
	moveq	#0,d5					;no palette lines
	bset	#0,(sflags6).w			;bit 0 of sflags6: dobitmap uses the map as is
	jsr	(dobitmap).l
	bclr	#0,(sflags6).w			;normal maps
	move.w	(TempWord1).w,d4
	jsr	(printz).l					;map at the shield
	String	CC_Font2Pri,1,1
	movea.l	#NHLShieldImg,a0		;NHL shield, NHLPA logo and the title on top
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1				;a1 = map data
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	mapheight(a1),d3
	moveq	#8,d5					;palette line 3
	jsr	(dobitmap).l
	jsr	(printz).l					;map at the NHLPA logo
	String	CC_Font2Pri,$19,1
	movea.l	#PAlogoImg,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1				;a1 = map data
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	mapheight(a1),d3
	moveq	#0,d5					;no palette lines
	jsr	(dobitmap).l
	jsr	(printz).l					;map at the title
	String	CC_Font2Pri,1,$E
	movea.l	#TitleImg,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1				;a1 = map data
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	mapheight(a1),d3
	moveq	#8,d5					;palette line 3
	jsr	(dobitmap).l
	clr.w	(palfadenew).w			;color 0 black and the fade targets cleared
	clr.l	(fofdata2).w
	clr.w	(fofdata2+4).w
	move.w	d4,(smallfontchars).w	;the small font for the credits
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithRemap).l
	dc.l	$0D104567,$89ABCDEF		;remap table: palette assignment for the scrolling credits
	jsr	(printz).l					;map 1 at the top left
	String	CC_Font1Pal1,0,0
	movea.l	#Credits,a1				;the first credits page
	jsr	(CreditsPrintRow).l			;print the first page
	addi.w	#$20,(Vscroll).w		;scroll down 32 lines
	move.w	#$104,(logoslide).w		;clampcounter = how long the first page stays
	move.w	#$120,(playoffspritex).w
	move.w	#$D0,(playoffspritey).w
	clr.w	(asv).w					;(sprite and fade setup for the title)
	move.w	#$FFCE,(titlescrollspeed).w	;attribute display counter
	move.w	#$20,(palcount).w		;fade in
	move.w	#SngTitle,-(sp)			;the title song
	jsr	(song).l
	bsr.w	CreditsLineScroll		;set up the line scroll table
	move	#$2500,sr				;interrupts on
.loop								;wait out the first page
	jsr	(CreditsWait).l				;one frame
	tst.w	(logoslide).w			;page time left?
	bne.s	.loop
	move.w	#$3C,d3
.loop2								;then $3C more frames
	jsr	(CreditsWait).l				;one frame
	dbf	d3,.loop2					;loop
	jsr	(printz).l					;map 1 at the top left
	String	CC_Font1Pal1,0,0
	movea.l	#CreditsPages,a1
.loop3								;each credits entry
	jsr	(CreditsPrintRow).l			;print the entry
	adda.w	(a1),a1
	moveq	#$27,d4					;scroll it up $28 lines, a line every 2 frames
.loop4								;one line up every 2 frames
	jsr	(CreditsWait).l				;frame
	jsr	(CreditsWait).l				;frame
	addq.w	#1,(Vscroll).w			;scroll one line
	dbf	d4,.loop4					;loop
	moveq	#$78,d4					;hold it $78 frames
.loop5								;wait
	jsr	(CreditsWait).l				;frame
	dbf	d4,.loop5					;loop
	tst.w	2(a1)					;until the end marker
	bpl.s	.loop3
	rts
CreditsPrintRow						;Credits: clear the row below the screen (Vscroll / 8 + $1C) and print the
									;Strings from a1 centred there
	move.w	(Vscroll).w,d0
	asr.w	#3,d0					;the row just below the screen
	addi.w	#$1C,d0					;plus $1C rows
	andi.w	#$1F,d0					;wrap at 32
	move.w	d0,(printy).w
	move.w	d0,-(sp)
	clr.w	(printx).w
	moveq	#$20,d0					;clear 6 rows there
	moveq	#6,d1
	move.w	#$7FF,d2				;blank char
	jsr	(eraser).l
	move.w	(sp)+,(printy).w
.loop								;each String of the entry
	move.w	(a1),d0
	asr.w	#1,d0					;centred: column $11 - length / 2
	neg.w	d0
	addi.w	#$11,d0
	move.w	d0,(printx).w
	jsr	(print).l
	addq.w	#1,(printy).w
	andi.w	#$1F,(printy).w			;the map wraps at 32 rows
	tst.w	2(a1)					;until the end marker
	bpl.s	.loop
	rts
CreditsWait							;Credits: wait for Vcount, run the clampcounter count down; start (orjoy
									;bit 7) returns from the caller too
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(Vcount).w,d0			;frame count
.loop								;wait for the next vblank
	cmp.w	(Vcount).w,d0
	beq.s	.loop
	subq.w	#2,(logoslide).w		;count down the page time
	bpl.w	.0
	clr.w	(logoslide).w
.0									;counter done: check the start button
	jsr	(orjoy).l					;read the pads
	btst	#7,d1					;start?
	movem.l	(sp)+,d0-d7/a0-a6		;(the flags of the btst survive the movem)
	beq.w	.x						;no start: keep waiting
	addq.w	#4,sp					;start: drop the caller's return address and leave his loop too
.x									;exit (also the end of the code above)
	rts
VBlank_TitleScreen					;TitleScreen vblank: line scroll table (SortCords) and Vscroll,
									;sprites, cramfade, CreditsScrollStep, p_music_vblank
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#dfng,(disflags).w		;screen off?
	bne.w	.1						;screen off: skip the DMA
	movea.w	#(SortCords-M68K_RAM),a0
	move.w	(VSCRLPM).w,d1
	move.w	#$1C0,d0				;$1C0 bytes: the line scroll table
	jsr	(DoDMA).l
	movea.l	#Vdata,a0
	move.l	#VSRAM_W,Vctrl-Vdata(a0)
	move.w	(Vscroll).w,(a0)		;vertical scroll of the credits
	movea.w	#(Satt-M68K_RAM),a0
	move.w	(Sattsize).w,d0
	beq.w	.0						;no sprites this frame
	clr.w	(Sattsize).w
	move.w	(VSPRITES).w,d1
	jsr	(DoDMA).l
.0									;sprites done
	jsr	(cramfade).l
.1									;drawing done (or skipped)
	addq.w	#1,(Vcount).w			;count the frame
	jsr	(CreditsScrollStep).l
	jsr	(p_music_vblank).l
	movem.l	(sp)+,d0-d7/a0-a6
	rte
CreditsLineScroll					;Credits: the line scroll table at SortCords
	movem.l	d0-d1,-(sp)
	move.w	#$14,(Hscroll).w		;scroll step per update
	move.w	#$50,(TempWord2).w		;first update after $50 frames
	move.w	#$50,d0					;$51 lines: the top part, slanted
	movea.l	#SortCords,a0
	move.l	#$FD80,d1				;start far left
.loop								;fill the top lines
	move.l	d1,(a0)+
	btst	#0,d0					;every other line one pixel further
	bne.w	.0
	subq.w	#1,d1
.0									;next line
	dbf	d0,.loop					;loop
	move.w	#$60,d0					;the lower $61 lines
	move.l	#$100,d1
.loop2								;start further right each line
	move.l	d1,(a0)+
	addq.l	#4,d1
	dbf	d0,.loop2					;loop
	movem.l	(sp)+,d0-d1
	rts
CreditsScrollStep					;Credits: line scroll step, every TempWord2 frames
	subq.w	#1,(TempWord2).w
	bmi.w	.0
	rts
.0									;time for a step
	clr.w	(TempWord2).w
	movem.l	d0-d2/a0,-(sp)
	move.w	#$DF,d0					;each of the $E0 lines
	movea.w	#(SortCords-M68K_RAM),a0
.loop								;step each line
	tst.l	(a0)+
	cmp.w	#$28,d0					;the top $28 lines stay still
	ble.w	.2						;top lines: still
	move.w	(Hscroll).w,d1
	cmp.w	#$8F,d0					;lines from $8F: move right
	blt.w	.1						;middle lines
	move.w	-2(a0),d2				;this line
	beq.w	.2						;already at 0: stays
	add.w	d1,d2
	move.w	d2,-2(a0)
	andi.w	#$FC00,d2				;until they pass 0
	cmp.w	#$FC00,d2
	beq.w	.2
	move.w	#0,-2(a0)				;past 0: stop there
	bra.w	.2
.1									;middle lines: move left
	sub.w	d1,-2(a0)
	bpl.w	.2						;not past 0 yet
	clr.w	-2(a0)					;stop at 0
.2									;next line
	dbf	d0,.loop					;loop
	movem.l	(sp)+,d0-d2/a0
	rts
