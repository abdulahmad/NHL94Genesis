;	New in 94: the EA Sports screen shown at startup (EASportsScreen, called from Begin).

EASportsScreen						;Called from Begin. Show the EA Sports screen until a button, or $50 x 4
									;frames (about 5 s)
	move.l	#vb2,(VBint).w			;vblank handler
	bclr	#df32c,(disflags).w
	move.w	#5,(Map3col).w
	move.w	#$A000,(VmMAP2).w
	move.w	#7,(Map2col).w
	move.w	#$C000,(VmMAP1).w
	move.w	#7,(Map1col).w
	move.w	#$F000,(VmMAP3).w
	move.w	#$F800,(VSPRITES).w
	move.w	#$FC00,(VSCRLPM).w
	movea.w	#(palfadenew-M68K_RAM),a0
	moveq	#$1F,d1					;32 longs: all 64 colours black
.clr	clr.l	(a0)+
	dbf	d1,.clr
	bsr.w	CopyPaletteToCRAM
	bsr.w	setVram_0
	bsr.w	printz
	String	-TXMAP2,0,0,0
	movea.l	#EASportsMap,a2			;screen map
	movea.l	a2,a0
	movea.l	a2,a1
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	mapheight(a1),d3
	clr.w	d4
	moveq	#$F,d5
	bsr.w	dobitmap
	move.w	#$EEE,(palfadenew).w
	move.w	#0,(palfadenew+$E).w
	move.w	#$18,(palcount).w		;fade in
	move	#$2500,sr				;vblank on
	move.w	#$50,(seed).w			;frame count down in the random seed word
.wait	moveq	#4,d0
	bsr.w	waitx					;4 frames; d1 = buttons
	tst.w	d1
	bne.w	.ex						;Button pressed
	subq.w	#1,(seed).w
	bpl.s	.wait
.ex	move	#$2700,sr
	rts
