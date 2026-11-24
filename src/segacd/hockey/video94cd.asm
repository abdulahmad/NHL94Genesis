vb2						;Vblank used for palfades only, no dmas (VBint target). No rte here: falls
									;into IRQ7
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#dfng,(disflags).l
	bne.w	.nograph
	bsr.w	cramfade
.nograph	addq.w	#$1,(Vcount).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
; Vertical interrupt: runs the dma list
VBlankDmaList	bsr.w	DmaListWait
	movea.l	#Satt,a0
	move.w	(Sattsize).l,d0
	move.w	(VSPRITES).l,d1
	bsr.w	DmaCopyFromWordRam
	movea.l	(DMAlistend).l,a6
	cmpa.l	#DMAList,a6
	beq.w	rtss2
.loop	move.w	-(a6),d1
	move.w	-(a6),d0
	movea.l	-(a6),a0
	bsr.w	DmaCopyFromWordRam
	cmpa.l	#DMAList,a6
	bgt.w	.loop
	rts	
dodmalist
	movea.l	(DMAlistend).l,a6
	cmpa.l	#DMAList,a6
	beq.w	rtss2
.0	move.w	-(a6),d1
	move.w	-(a6),d0
	movea.l	-(a6),a0
	bsr.w	DoDMAProQueue
	cmpa.l	#DMAList,a6
	bgt.w	.0
	rts
; Waits for the sub CPU and writes the dma list
DmaListWait	move.w	(VSCRLPM).l,d0
	addi.w	#$2,d0
	bsr.w	SetVramWriteAddr2
.loop	btst.b	#$4,(GA_COMFLAGS).l
	bne.s	.loop
	move.w	#$31,(GA_COMSTAT3).l
	move.w	(Hscroll).l,(GA_COMSTAT4).l
	bset.b	#$3,(GA_COMFLAGS+1).l
.loop2	btst.b	#$3,(GA_COMFLAGS).l
	beq.s	.loop2
	bset.b	#$4,(GA_COMFLAGS+1).l
	bclr.b	#$3,(GA_COMFLAGS+1).l
.loop3	btst.b	#$3,(GA_COMFLAGS).l
	bne.s	.loop3
	bclr.b	#$4,(GA_COMFLAGS+1).l
.loop4	btst.b	#$4,(GA_COMFLAGS).l
	bne.s	.loop4
	move.w	#$30,(GA_COMSTAT3).l
	move.l	#$40020010,(GA_COMSTAT4).l
	bset.b	#$3,(GA_COMFLAGS+1).l
.loop5	btst.b	#$3,(GA_COMFLAGS).l
	beq.s	.loop5
	bset.b	#$4,(GA_COMFLAGS+1).l
	bclr.b	#$3,(GA_COMFLAGS+1).l
.loop6	btst.b	#$3,(GA_COMFLAGS).l
	bne.s	.loop6
	bclr.b	#$4,(GA_COMFLAGS+1).l
.loop7	btst.b	#$4,(GA_COMFLAGS).l
	bne.s	.loop7
	move.w	#$31,(GA_COMSTAT3).l
	move.w	(Vscroll).l,(GA_COMSTAT4).l
	bset.b	#$3,(GA_COMFLAGS+1).l
.loop8	btst.b	#$3,(GA_COMFLAGS).l
	beq.s	.loop8
	bset.b	#$4,(GA_COMFLAGS+1).l
	bclr.b	#$3,(GA_COMFLAGS+1).l
.loop9	btst.b	#$3,(GA_COMFLAGS).l
	bne.s	.loop9
	bclr.b	#$4,(GA_COMFLAGS+1).l
	rts
setvideo
	movem.l	d0-d7/a0-a6,-(sp)
.p	btst	#dfok,(disflags).l
	bne.w	.p
	movea.l	#DMAList,a5
	bsr.w	updatescroll
	movea.l	#Satt,a6
	moveq	#$1,d6
	bsr.w	checkfo
	bsr.w	checksso
	bsr.w	setsortcords
	bsr.w	setffo
	bsr.w	showclock
	bsr.w	showzam
	jsr	(AddArenaAnimSprite).l
	bsr.w	showcrowd
	bsr.w	showref
	jsr	(Crowd_Noise).l
	cmpa.l	#Satt,a6
	bne.w	.n
	clr.l	(a6)+
	clr.l	(a6)+
.n	clr.b	-$5(a6)
	move.l	a6,d0
	subi.l	#Satt,d0
	lsr.w	#$1,d0
	move.w	d0,(Sattsize).l
	move.l	a5,(DMAlistend).l
	move.l	a5,(DMAlistendCopy).l
	bset	#dfok,(disflags).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
updatescroll						;Using hpos and vpos set scroll cords; queue rink map rows on the dma list
									;(a5) when vertical scrolling needs new rows. Called from setvideo. Takes
									;the rows from Rinktilelist, or RevRinkTilelist in a reverse angle replay
									;(sflags4 bit 4)
	btst	#sfhor,(sflags).l		;sfhor
	bne.w	rtss2
	moveq	#-64,d0		;-192+128 (#$FFFFFFC0)
	sub.w	(Hpos).l,d0
	move.w	(Vpos).l,d1
	move.w	d0,(Hscroll).l
	move.w	d1,(Vscroll).l
	neg.w	(Vscroll).l
	move.w	(Oldrow).l,d4
	asr.w	#$3,d1
	move.w	d1,(Oldrow).l
	moveq	#$1F,d3		;max lines to update
	cmp.w	d4,d1
	beq.w	rtss2		;same row as last frame
	movea.l	(Rinktilelist).l,a0
	btst	#$4,(sflags4).l		;reverse angle replay
	beq.w	.0
	movea.l	(RevRinkTilelist).l,a0
.0	adda.l	jimdata(a0),a0		;a0 = map header: (a0) = chars per row, data at 4(a0) (the move / adda
	blt.w	.su0		;row went up
.sd	move.w	d1,d0		;scrolling down: queue map rows, one per pass (d3 = max rows)
	neg.w	d0
	addi.w	#$1E,d0
	andi.w	#$1F,d0
	asl.w	#$7,d0		;chars per row screen format
	add.w	(VmMAP2).l,d0
	move.w	d0,$6(a5)		;vram address
	move.w	#$1E,d0		;60-30
	sub.w	d1,d0
	move.w	(a0),$4(a5)		;words = one map row
	mulu.w	(a0),d0
	add.w	d0,d0
	lea.l	$4(a0,d0.w),a1
	move.l	a1,(a5)		;source = map row
	adda.w	#$8,a5
	subq.w	#$1,d1
	cmp.w	d4,d1
	dbeq	d3,.sd
	rts
.su0	move.w	d1,d0		;scrolling up: same as .sd with rows going the other way
	neg.w	d0
	addi.w	#$1D,d0
	andi.w	#$1F,d0
	asl.w	#$7,d0
	add.w	(VmMAP2).l,d0
	move.w	d0,$6(a5)
	move.w	#$3D,d0
	sub.w	d1,d0
	move.w	(a0),$4(a5)
	mulu.w	(a0),d0
	add.w	d0,d0
	lea.l	$4(a0,d0.w),a1
	move.l	a1,(a5)
	adda.w	#$8,a5
	addq.w	#$1,d1
	cmp.w	d4,d1
	dbeq	d3,.su0
	rts
showref						;draw ref graphics. a5 = dma list, a6 = sprite table, d6 = link counter.
									;Called from setvideo
	bclr	#sf2refref,(sflags2).l		;sf2refref
	beq.w	rtss2
	movea.l	#RefRamMap,a0
	movea.l	#VmMAP1,a1
	move.w	$2(a1),d2
	moveq	#$2,d0		;refy: Xpos on ice screen
	btst	#sfhor,(sflags).l
	beq.w	.1
	moveq	#$F,d0		;Ypos on scoreboard screen
.1	asl.w	d2,d0		;row * map row size
	moveq	#$2,d1
	asl.w	d2,d1		;d1 = vram step of 2 map rows
	addi.w	#$2,d0		;refx
	btst	#sfhor,(sflags).l
	beq.w	.2
	addi.w	#$B,d0
.2	asl.w	#$1,d0		;cells to bytes
	add.w	(a1),d0		;d0 = vram address of the ref block in map 1
	moveq	#$7,d2		;refheight-1
.0	move.l	a0,(a5)+
	move.w	#$7,(a5)+
	move.w	d0,(a5)+
	adda.w	#$E,a0		;refwidth*2
	add.w	d1,d0
	dbra	d2,.0
	rts
checkfo						;check for face off sprites. 3 entries of fofdata2: word frame, word
									;flags. Called from setvideo
	btst	#sfpz,(sflags).l		;sfpz
	bne.w	rtss2
	btst	#dffaceoff,(disflags).l		;face off flag
	beq.w	rtss2
	movea.l	#fofdata2,a3
	moveq	#$2,d0
.loop	move.w	(a3),d4
	bmi.w	.next
	beq.w	.next
	movea.l	(FaceOffSprites).l,a2
	adda.l	jimdata(a2),a2
	add.w	d4,d4
	move.w	$2(a2,d4.w),d5
	sub.w	(a2,d4.w),d5
	lsr.w	#$3,d5
	subi.w	#$1,d5
	adda.w	(a2,d4.w),a2
.loop2	move.w	seY(a2),d2
	addi.w	#$80,d2
	add.w	(fodropy).l,d2
	move.w	d2,(a6)
	move.w	(a2),d2
	btst	#$3,foattr(a3)		;x flip
	beq.w	.0
	move.b	seSize(a2),d2
	andi.w	#$C,d2
	addi.w	#$4,d2
	asl.w	#$1,d2
	neg.w	d2
	sub.w	(a2),d2
.0	addi.w	#$80,d2
	add.w	(fodropx).l,d2
	move.w	d2,satX(a6)
	move.b	seSize(a2),satSize(a6)
	move.b	d6,satLink(a6)
	move.w	seAttr(a2),d2
	andi.w	#$F800,d2
	or.w	seTile(a2),d2
	move.w	foattr(a3),d1
	andi.w	#$F800,d1
	eor.w	d1,d2
	add.w	(faceoffvrcset).l,d2
	move.w	d2,satTile(a6)
	addi.w	#$1,d6
	adda.w	#$8,a6
	adda.w	#$8,a2
	dbra	d5,.loop2
	adda.w	#$4,a3
.next	dbra	d0,.loop
	rts
showzam						;zamboni. a5 = dma list, a6 = sprite table, d6 = link counter. Draws frame
									;1, frame 2-4 picked by x, then frame 5 (home score not ahead) or a .ftab
									;frame. Called from setvideo
	move.w	(Zamx).l,d0
	bmi.w	rtss2		;no zamboni
	movea.l	(ZamSprites).l,a0
	lsr.w	#$2,d0
	move.w	#$12A,d1		;y (92 128+200)
	moveq	#$1,d2		;frame
	move.w	(ExtraChars).l,d3
	bsr.w	SetSframe
	move.w	d0,d2
	lsr.w	#$1,d2
	ext.l	d2
	divu.w	#$3,d2
	swap	d2
	addi.w	#$2,d2		;frame 2 + (x/2 mod 3)
	bsr.w	SetSframe
	moveq	#$5,d2
	move.w	(HmGoals).l,d4
	cmp.w	(AwGoals).l,d4
	bls.w	SetSframe		;home not ahead: frame 5
	move.w	d0,d2
	subi.w	#$DA,d2
	bpl.w	.pos
	clr.w	d2		;x below $DA: first entry
.pos	lsr.w	#$2,d2		;(x-$DA)/4
	add.w	d2,d2		;word index
	cmpi.w	#$1A,d2
	blt.w	.next
	moveq	#$18,d2
.next	lea.l	showzamData.l,a1
	move.w	(a1,d2.w),d2
	bra.w	SetSframe
; Data that follows showzam (strings, small tables)
showzamData	dc.w	$0005,$0006,$0007,$0008,$0007,$0008,$0007,$0008		;frame by (x-$DA)/4
	dc.w	$0007,$0008,$0007,$0006,$0005
SetSframe
	cmpi.w	#$40,d6
	bge.w	rtss2
	movem.l	d0-d5/a0,-(sp)
	adda.l	jimdata(a0),a0
	add.w	d2,d2
	move.w	$2(a0,d2.w),d4
	sub.w	(a0,d2.w),d4
	lsr.w	#$3,d4
	subi.w	#$1,d4
	adda.w	(a0,d2.w),a0
.loop	move.w	seY(a0),(a6)
	add.w	d1,(a6)+
	move.b	seSize(a0),(a6)+
	move.b	d6,(a6)+
	move.w	seAttr(a0),d2
	andi.w	#$F800,d2
	add.w	seTile(a0),d2
	add.w	d3,d2
	move.w	d2,(a6)+
	move.w	(a0),(a6)
	add.w	d0,(a6)+
	addi.w	#$1,d6
	cmpi.w	#$40,d6
	beq.w	.ex
	adda.w	#$8,a0
	dbra	d4,.loop
.ex	movem.l	(sp)+,d0-d5/a0
	rts
showcrowd						;draw crowd sprites: up to 3 frames per PBnum nibble, then the two
									;Crowdframe frames. a5 = dma list, a6 = sprite table, d6 = link counter.
									;No crowd in a reverse angle replay. Called from setvideo
	btst	#$4,(sflags4).l		;check if reverse angle replay
	bne.w	.x		;branch if so
	movea.l	(CrowdSprites).l,a1
	adda.l	jimdata(a1),a1		;a1 = frame offset table
	move.w	(Hpos).l,d4
	move.w	(Vpos).l,d5
	btst	#sfhor,(sflags).l
	beq.w	.v
	moveq	#-64,d4		;(#$FFFFFFC0)
	move.l	#$100,d5
.v	clr.w	d0		;d4/d5 = x/y of the view
	move.b	(PBnum).l,d2
	moveq	#$1A,d3
	bsr.w	.pb
	move.b	(PBnum).l,d2
	lsr.w	#$4,d2		;high nibble
	moveq	#$1D,d3		;frames 29+ (high nibble)
	bsr.w	.pb
	move.b	(Crowdframe).l,d0
	bsr.w	.sc
	move.b	(Crowdframe+1).l,d0
	bra.w	.sc
.pb	andi.w	#$F,d2		;d2 = count, d3 = first frame
	cmpi.w	#$3,d2
	bls.w	.pb0
	moveq	#$3,d2		;max 3
.pb0	bra.w	.next
.pbt	move.w	d3,d0		;frame = first frame + counter
	add.w	d2,d0
	bsr.w	.sc
.next	dbra	d2,.pbt
	rts
.sc	ext.w	d0
	beq.w	rtss2
	btst	#sfhor,(sflags).l
	beq.w	.chk
	addi.w	#$1F,d0		;horizontal frames are 31 later
.chk	cmpi.w	#$40,d6		;MaxSprites
	bge.w	rtss2
	movem.l	d0-d5,-(sp)
	add.w	d0,d0
	movea.l	a1,a0
	move.w	$2(a0,d0.w),d1
	sub.w	(a0,d0.w),d1
	lsr.w	#$3,d1
	subi.w	#$1,d1
	move.w	d1,-(sp)		;number of sprites in frame
	adda.w	(a0,d0.w),a0
	move.w	d4,d0		;x window d0-d1
	addi.w	#$C0,d0
	move.w	d0,d1
	subi.w	#$90,d0		;128+16
	addi.w	#$80,d1
	move.w	#$170,d2		;y window d2-d3
	sub.w	d5,d2
	move.w	d2,d3
	subi.w	#$80,d2		;112+16
	addi.w	#$70,d3		;112
	move.w	(sp)+,d4
.loop	cmp.w	seY(a0),d2		;per sprite: skip it if outside the window d0-d3
	bgt.w	.next2
	cmp.w	seY(a0),d3
	blt.w	.next2
	cmp.w	(a0),d0
	bgt.w	.next2
	cmp.w	(a0),d1
	blt.w	.next2
	move.w	seY(a0),d5
	addi.w	#$70,d5		;128-16
	sub.w	d2,d5
	move.w	d5,(a6)+
	move.b	seSize(a0),(a6)+
	move.b	d6,(a6)+
	move.w	seAttr(a0),d5
	andi.w	#$F800,d5
	add.w	seTile(a0),d5
	add.w	(crowdvrcset).l,d5
	move.w	d5,(a6)+
	move.w	(a0),d5
	addi.w	#$70,d5		;128-16
	sub.w	d0,d5
	move.w	d5,(a6)+
	addi.w	#$1,d6
	cmpi.w	#$40,d6
	beq.w	.ex
.next2	adda.w	#$8,a0
	dbra	d4,.loop
.ex	movem.l	(sp)+,d0-d5
.x	rts
showclock						;put the game clock on screen. Called from setvideo and PauseMode. On the
									;horizontal rink the clock is printed (printz / print with .digits; not in
									;a shootout, gmode2 bit 0). On the vertical rink (.3) it goes in the dma
									;list, only when dfclock is set; with gmode2 bit 1 (penalty shot /
									;shootout) shootoutclock is shown instead of gameclock. a5 = dma list
	btst	#sfhor,(sflags).l		;sfhor
	beq.w	showclockVertical
	btst	#$0,(gmode2).l		;shootout
	bne.w	.x
	move.l	a1,-(sp)
	jsr	(printz).l
	String	CC_Font2Pri,$D,$5
	move.w	(gameclock).l,d0
	ext.l	d0
	divu.w	#$258,d0		;tens of minutes (600 seconds)
	move.l	d0,-(sp)
	tst.w	d0
	bne.w	.1
	addi.w	#$1,(printx).l
	bra.w	.2
.1	jsr	(ShowClockPrintDigit).l
.2	move.l	(sp)+,d0
	swap	d0
	ext.l	d0
	divu.w	#$3C,d0		;minutes
	move.l	d0,-(sp)
	jsr	(ShowClockPrintDigit).l
	move.l	(sp)+,d0
	swap	d0
	ext.l	d0
	addi.w	#$2,(printx).l
	divu.w	#$A,d0		;tens of seconds
	move.l	d0,-(sp)
	jsr	(ShowClockPrintDigit).l
	move.l	(sp)+,d0
	swap	d0
	ext.l	d0
	jsr	(ShowClockPrintDigit).l
	movea.l	(sp)+,a1
	jsr	(printz).l
	String	CC_Font3Pri,$D,$5
.x	rts
; Prints one clock digit from the digit table.
ShowClockPrintDigit
	movea.l	#showclockData,a1
	asl.w	#$2,d0
	adda.w	d0,a1
	jsr	(print).l
	rts
; Data that follows showclock (strings, small tables)
showclockData	dc.w	$0004,$3000,$0004,$3100,$0004,$3200,$0004,$3300
	dc.w	$0004,$3400,$0004,$3500,$0004,$3600,$0004,$3700
	dc.w	$0004,$3800,$0004,$3900
; showclock: vertical rink case
showclockVertical
	bclr	#$3,(disflags).l
	beq.w	rtss2
	btst	#$3,(sflags2).l
	bne.w	rtss2
	cmpi.w	#$4,(gsp).l
	beq.w	rtss2
	movea.l	#clockram+6,a0
	movea.l	(SmallFontMap).l,a1
	adda.l	$4(a1),a1
	move.w	$78(a1),d0
	add.w	(smallfontchars).l,d0
	ori.w	#$8000,d0
	move.w	d0,(clockram).l
	move.w	(gameclock).l,d0
	btst	#$1,(gmode2).l
	beq.w	.next
	move.w	(shootoutclock).l,d0
.next	ext.l	d0
	divu.w	#$A,d0
	bsr.w	.next4
	divu.w	#$6,d0
	bsr.w	.next4
	suba.w	#$2,a0
	divu.w	#$A,d0
	bsr.w	.next4
	swap	d0
	tst.l	d0
	bne.w	.next2
	moveq	#-16,d0
	swap	d0
.next2	bsr.w	.next4
	move.l	a0,(a5)+
	move.w	#$5,(a5)+
	movea.l	#VmMAP1,a1
	moveq	#$18,d0
	moveq	#$3,d2
	btst	#$7,(sflags).l
	beq.w	.next3
	movea.l	#VmMAP2,a1
	moveq	#$5,d0
	moveq	#$D,d2
.next3	move.w	$2(a1),d1
	asl.w	d1,d0
	add.w	d2,d0
	asl.w	#$1,d0
	add.w	(a1),d0
	move.w	d0,(a5)+
	rts
.next4	swap	d0
	asl.w	#$1,d0
	move.w	$64(a1,d0.w),d0
	add.w	(smallfontchars).l,d0
	ori.w	#$8000,d0
	move.w	d0,-(a0)
	swap	d0
	ext.l	d0
	rts
checksso						;do graphics for sso structure: arrows for the players when they are off
									;screen. Called from setvideo. a5 = dma list, a6 = sprite table, d6 = link
									;counter. Returns on the horizontal rink. Includes the pads 3 and 4
									;(Joy3Struct / Joy4Struct when cont3team / cont4team). Falls into .ca for
									;the last one
	btst	#sfhor,(sflags).l
	bne.w	rtss2
	movea.l	#Joy1Struct,a0
	movea.l	#sso,a3
	move.w	#$180,d3		;frame numbers are 6 higher than 92
	bsr.w	.ca
	adda.w	#ffosize,a0		;next pad object
	adda.w	#$14,a3		;ssosize
	move.w	#$183,d3
	bsr.w	.ca
	tst.w	(cont3team).l
	beq.w	rtss2		;on screen: no arrow
	movea.l	#Joy3Struct,a0
	adda.w	#$14,a3
	move.w	#$346,d3
	bsr.w	.ca
	tst.w	(cont4team).l
	beq.w	rtss2
	movea.l	#Joy4Struct,a0
	adda.w	#$14,a3
	move.w	#$349,d3
.ca	tst.w	Zpos(a0)
	bmi.w	rtss2		;not on the ice
	st.b	$6(a3)
	move.w	$0(a0),d0
	btst	#$0,(gmode2).l
	bne.w	.0
	btst	#sf2replay,(sflags2).l
	bne.w	.0
	btst	#$2,(BA_PS_flags).l
	beq.w	.7
.0	move.w	d0,-(sp)
	tst.w	d0
	bpl.w	.2
	neg.w	d0
.2	cmpi.w	#$A6,d0
	blt.w	.6
	move.w	(sp)+,d0
	rts
.6	move.w	(sp)+,d0
.7	move.w	Ypos(a0),d1
	btst	#sfhor,(sflags).l
	beq.w	.nhor
	exg.l	d0,d1		;horizontal view: swap axes
	neg.w	d0
	subi.w	#horoff,d1		;horoff
	bra.w	.hord
.nhor	sub.w	(Hpos).l,d0
	sub.w	(Vpos).l,d1
.hord	clr.w	d2
	cmpi.w	#$74,d0		;.xoff = 116
	blt.w	.8
	bset	#$3,d2
.8	cmpi.w	#$FF8C,d0		;-.xoff
	bgt.w	.1
	bset	#$2,d2
.1	cmpi.w	#$64,d1		;.yoff = 100
	blt.w	.9
	bset	#$0,d2
.9	cmpi.w	#$FF9C,d1		;-.yoff
	bgt.w	.3
	bset	#$1,d2
.3	tst.w	d2
	beq.w	rtss2
	movea.l	#ReadJoyDataTable,a1
	move.b	(a1,d2.w),d2
	asl.w	#$3,d2
	movea.l	#checkssoData,a1
	move.w	(a1,d2.w),d4
	beq.w	.4
	move.w	d4,d0
.4	addi.w	#$100,d0		;128+128
	move.w	d0,$0(a3)		;Xcord
	move.w	$2(a1,d2.w),d4		;y spot, 0 = keep player y
	beq.w	.5
	move.w	d4,d1
.5	neg.w	d1		;y up is negative on screen
	addi.w	#$F0,d1		;112+128
	move.w	d1,$2(a3)		;Ycord
	add.w	$4(a1,d2.w),d3
	move.w	d3,frame(a3)
	move.w	$6(a1,d2.w),attribute(a3)		;flip bits
	bra.w	addframe2
; Data that follows checksso (strings, small tables)
checkssoData	dc.w	$0000,$0064,$0000,$0000,$0074,$0064,$0001,$0000		;x spot, y spot, frame add, attribute per direction
	dc.w	$0074,$0000,$0002,$0000,$0074,$FF9C,$0001,$1000		;.xspot = 116, .yspot = 100
	dc.w	$0000,$FF9C,$0000,$1000,$FF8C,$FF9C,$0001,$1800
	dc.w	$FF8C,$0000,$0002,$0800,$FF8C,$0064,$0001,$0800
setsortcords						;setup sort cord graphics: addframe for the 16 objects in OOlist order. a5
									;= dmalist, a6 = sprite attribute table, d6 = link counter
	movea.l	#OOlist,a4		;move OOlist into a4
	move.w	#$F,d0		;sortobj-1 (15 dec)
.top	clr.w	d1
	move.b	(a4)+,d1		;move next sortcord into d1
	asl.w	#$6,d1		;mult by 64
	movea.l	#SortCords,a3
	adda.w	d1,a3
	bsr.w	addframe
	dbra	d0,.top
	rts
setffo						;draw the 7 objects tied to icerink scrolling (gloves and pads), moving
									;each by its x offset. Called from setvideo
	bsr.w	uppads
	move.w	#$6,d0		;ffo obj -1
	movea.l	#pads,a3		;move start of struct into a3
.top	movea.l	a6,a0		;per object: a0 = first sprite this object writes
	bsr.w	addframe
	cmpa.l	a6,a0
	beq.w	.next		;no sprites added
	move.w	$2(a3),d1		;x offset (set by QueuePadLabel)
	add.w	d1,$6(a0)		;sprite 1 x
	add.w	d1,$E(a0)
.next	adda.w	#ffosize,a3		;move to next struct
	dbra	d0,.top
	rts
uppads						;update the gloves object and the 6 pad objects, and queue new pad labels
									;(QueuePadLabel). The pad players
									;come from the PadControlBits / PadControlBits34 nibbles ($E = no change,
									;$F = none)
	movea.l	#glovestruct,a0		;pads+(4*ffosize): gloves
	st.b	$18(a0)		;set Zpos
	move.b	(glovecords).l,d0
	beq.w	.0		;branch if 0
	move.b	(glovecords+1).l,d1
	ext.w	d0
	asl.w	#$2,d0
	move.w	d0,$0(a0)		;move d0 into Xpos
	ext.w	d1
	asl.w	#$2,d1
	move.w	d1,Ypos(a0)		;move d1 into Ypos
	clr.w	Zpos(a0)		;clear Zpos
.0	move.w	#$5,d4
	movea.l	#pads,a0
	movea.l	#padcont,a1		;last label code per pad
	movea.l	#SortCords,a2
	move.w	(PadControlBits).l,d3
.loop	cmpi.w	#$1,d4
	bne.w	.nibble
	move.w	(PadControlBits34).l,d3
	lsr.w	#$4,d3
	bra.w	.nibble		;to the next instruction
.nibble	move.w	d3,d0		;per pad: d3 holds the remaining nibbles
	andi.w	#$F,d0		;this pad's nibble: player number, $E or $F
	move.w	#$F,d1		;label code for $E
	cmpi.w	#$E,d0
	beq.w	.chg		;$E: leave the pad position alone
	st.b	$18(a0)		;hidden
	cmpi.w	#$F,d0
	beq.w	.next		;$F: pad hidden, label unchanged
	asl.w	#$7,d0
	move.w	(a2,d0.w),$0(a0)
	move.w	Ypos(a2,d0.w),Ypos(a0)
	clr.w	Zpos(a0)		;shown
	move.b	$35(a2,d0.w),d1		;label code = position << 8 | rostnum
	asl.w	#$8,d1
	move.b	rostnum(a2,d0.w),d1
.chg	cmp.w	(a1),d1		;new label code vs the last one for this pad
	beq.w	.next		;same label as last time
	move.w	d1,(a1)
	bsr.w	QueuePadLabel
.next	lsr.w	#$4,d3
	adda.w	#ffosize,a0
	adda.w	#$2,a1
	dbra	d4,.loop
	rts
QueuePadLabel						;Queue the 3 character label of a pad object. d1 = label code: bits 7-4
									;and 3-0 are digits ($F = blank), bits 10-8 index ButtonLabelCharTable
									;(none while sflags7 bit 7 is set).
									;a0 = pad object, a5 = dma list. Falls into uppads_pd for the
									;last char
	lea	ButtonLabelCharTable(pc),a4
	clr.w	$2(a0)		;x offset (setffo adds it to the sprites)
	move.w	d1,d2
	lsr.w	#$4,d2
	andi.w	#$F,d2
	bne.w	.hi
	move.w	#$FFF0,d2		;' '-'0': blank leading zero
	subi.w	#$4,$2(a0)
.hi	addi.w	#$30,d2		;'0' (tens digit of the label, or blank)
	clr.w	d0		;char slot 0
	bsr.w	uppads_pd
	move.w	d1,d2
	andi.w	#$F,d2
	cmpi.w	#$F,d2
	bne.w	.lo
	move.w	#$FFF0,d2		;$F: blank
.lo	addi.w	#$30,d2		;'0' (ones digit of the label, or blank)
	moveq	#$1,d0		;char slot 1
	bsr.w	uppads_pd
	move.w	d1,d2
	btst	#$7,(sflags7).l
	beq.w	.0
	clr.w	d2
.0	lsr.w	#$8,d2
	andi.w	#$7,d2
	bne.w	.1
	addi.w	#$4,$2(a0)
.1	move.b	(a4,d2.w),d2
	moveq	#$2,d0
uppads_pd						;Dma one small font tile (SmallFontMap) to the object's chars. d2 = ascii
									;char, d0 = char slot, a0 = object (VRchar), a5 = dma list
	movea.l	(SmallFontMap).l,a3
	adda.l	jimdata(a3),a3
	add.w	d2,d2
	move.w	mapwords(a3,d2.w),d2
	andi.w	#$7FF,d2
	asl.w	#$5,d2		;32 bytes per tile
	movea.l	(SmallFontMap).l,a3
	lea.l	$A(a3,d2.w),a3		;tile data
	move.l	a3,(a5)+
	move.w	#$10,(a5)+		;words to transfer
	add.w	VRchar(a0),d0
	asl.w	#$5,d0
	move.w	d0,(a5)+		;vram destination
	rts
ButtonLabelCharTable				;Third label character by bits 10-8 of the label code
	dc.b	' DDLCRX',$0		;pad byte ($FF on the cartridge)
addframe
	movem.l	d0-d2,-(sp)
	move.w	$0(a3),d0
	move.w	Ypos(a3),d1
	move.w	Zpos(a3),d2
	bmi.w	.exit
	bsr.w	find3d
	cmpi.w	#$4E20,d1
	beq.w	.exit
	bsr.w	addframe2
.exit	movem.l	(sp)+,d0-d2
	rts

addframe2
	move.w	attribute(a3),-(sp)
	movem.l	d0-d5/a0-a2,-(sp)
	move.w	frame(a3),d4
	bmi.w	.exit
	beq.w	.exit
	andi.w	#$F800,d4
	eor.w	d4,attribute(a3)
	move.w	frame(a3),d4
	andi.w	#$7FF,d4
	movea.l	(Sprites).l,a2
	adda.l	jimdata(a2),a2
	add.w	d4,d4
	cmp.w	$2(a2),d4
	bge.w	.exit
	move.w	$2(a2,d4.w),d5
	sub.w	(a2,d4.w),d5
	lsr.w	#$3,d5
	subi.w	#$1,d5
	adda.w	(a2,d4.w),a2
	clr.w	d3
	clr.w	d4
.sloop	move.w	d0,-(sp)
	move.w	frame(a3),d0
	andi.w	#$7FF,d0
	cmp.w	oldframe(a3),d0
	beq.w	.noref
	tst.w	d5
	bne.w	.nn
	move.w	d0,oldframe(a3)
.nn	movem.w	d0-d4,-(sp)
	move.w	seTile(a2),d2
	clr.w	d4
	move.b	seSize(a2),d4
	movea.l	#sizetab,a0
	move.b	(a0,d4.w),d4
	cmp.w	$8(sp),d4
	bgt.w	.nodup
	cmp.w	$4(sp),d2
	blt.w	.nodup
	move.w	$4(sp),d0
	add.w	$8(sp),d0
	sub.w	d2,d0
	sub.w	d4,d0
	bmi.w	.nodup
	movem.w	(sp)+,d0-d1
	adda.w	#$6,sp
	bra.w	.dup
.nodup	add.w	$8(sp),d3
	movem.w	(sp)+,d0-d1
	adda.w	#$6,sp
	movem.w	d0-d4,-(sp)
	add.w	VRchar(a3),d3
	ext.l	d2
	asl.l	#$5,d2
	add.l	(Sprites).l,d2
	addi.l	#$A,d2
	asl.w	#$4,d4
	asl.w	#$5,d3
	move.l	d2,(a5)+
	move.w	d4,(a5)+
	move.w	d3,(a5)+
	movem.w	(sp)+,d0-d4
.dup	move.b	d3,VRoffs(a3,d5.w)
.noref	move.w	(sp)+,d0
	movem.w	d0-d2,-(sp)
	move.w	seY(a2),d2
	btst	#$4,attribute(a3)
	beq.w	.noyflip
	move.b	seSize(a2),d2
	andi.w	#$3,d2
	addi.w	#$1,d2
	asl.w	#$3,d2
	neg.w	d2
	sub.w	seY(a2),d2
.noyflip	add.w	d2,d1
	move.w	d1,(a6)
	move.w	(a2),d2
	btst	#$3,attribute(a3)
	beq.w	.noxflip
	move.b	seSize(a2),d2
	andi.w	#$C,d2
	addi.w	#$4,d2
	asl.w	#$1,d2
	neg.w	d2
	sub.w	(a2),d2
.noxflip	add.w	d2,d0
	move.w	d0,satX(a6)
	move.b	seSize(a2),satSize(a6)
	move.b	d6,satLink(a6)
	move.w	seAttr(a2),d2
	move.w	attribute(a3),d0
	eor.w	d0,d2
	andi.w	#$F800,d2
	btst	#$0,$5(a3)
	beq.w	.nospec
	btst	#$E,d2
	beq.w	.nospec
	bset	#$D,d2
.nospec	or.b	VRoffs(a3,d5.w),d2
	add.w	VRchar(a3),d2
	move.w	d2,satTile(a6)
	movem.w	(sp)+,d0-d2
	addi.w	#$1,d6
	adda.w	#$8,a6
	adda.w	#$8,a2
	dbra	d5,.sloop
.exit	movem.l	(sp)+,d0-d5/a0-a2
	move.w	(sp)+,attribute(a3)
	rts
find3d						;input: d0 = xfield, d1 = yfield, d2 = height off field. Output: d0 =
									;xscreen, d1 = yscreen, or d1 = $4E20 when off screen
	btst	#sfhor,(sflags).l
	beq.w	.nhor
	exg.l	d0,d1
	neg.w	d0
	subi.w	#horoff,d1
	bra.w	.next2
.nhor	sub.w	(Hpos).l,d0
	sub.w	(Vpos).l,d1
.next2	cmpi.w	#$90,d0
	bgt.w	.offscr
	cmpi.w	#$FF70,d0
	blt.w	.offscr
	addi.w	#$100,d0		;128+128
	add.w	d2,d1
	asr.w	#$1,d2
	add.w	d2,d1		;y + 1.5 * height
	cmpi.w	#$90,d1		;112+32
	bgt.w	.offscr
	cmpi.w	#$FF70,d1
	blt.w	.offscr
	neg.w	d1
	addi.w	#$F0,d1		;112+128
	rts
.offscr	move.w	#$4E20,d1
	rts
updatesound						;move the crowd noise volume (psg noise channel, asv) toward Crowdlevel.
									;Called from periodicevents
	move.w	(Crowdlevel).l,d0
	asl.w	#$3,d0
	addi.w	#$400,d0
	cmpi.w	#$EFF,d0
	bls.w	.ip
	move.w	#$EFF,d0
.ip	moveq	#$28,d2		;max step 40 (d0 = target level, asv = current)
	sub.w	(asv).l,d0
	cmp.w	d2,d0
	bgt.w	.iasv
	neg.w	d2
	cmp.w	d2,d0
	bge.w	.non		;within 40: no change
.iasv	add.w	d2,(asv).l		;step asv toward the target
	bpl.w	.non
	clr.w	(asv).l
.non	move.b	(asv).l,d0		;psg: noise channel setup, then attenuation below
	eori.b	#$F,d0
	ori.b	#$F0,d0
	rts
; Sets the VDP planes and scroll for the sound update screen.
setupice
	movem.l	d0-d7/a0-a6,-(sp)
	bset	#$1,(disflags).l
	move.w	#$C000,(VmMAP2).l
	move.w	#$6,(Map2col).l
	move.w	#$DC00,(VSPRITES).l
	move.w	#$E000,(VmMAP1).l
	move.w	#$6,(Map1col).l
	move.w	#$F000,(VmMAP3).l
	move.w	#$5,(Map3col).l
	move.w	#$FC00,(VSCRLPM).l
	moveq	#$0,d0
	bsr.w	setVram
	bclr	#$0,(sflags).l
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	clr.w	(Hpos).l
	clr.w	(Vpos).l
	move.w	#$7D0,(Oldrow).l
	st.b	(Zamx).l
	move.w	#$800,d0
	move.w	(VmMAP1).l,d1
	move.w	#$7FF,d2
	bsr.w	DoDMANd2Queue
	clr.w	d4
	move.w	d4,(rinkvrcset).l
	movea.l	(Rinktilelist).l,a2
	addq.l	#$8,a2
	btst	#$4,(sflags4).l
	beq.w	.next4
	movea.l	(RevRinkTilelist).l,a2
	addq.l	#$8,a2
.next4	bsr.w	DecompressGraphicsPlain
	jsr	(LoadHomeTeamGfx).l
	move.w	d4,(EASNcset).l
	bsr.w	setupEASportsMap
	move.w	d4,(energybarchars).l
	movea.l	(EnergyBarMap).l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain
	move.w	d4,(crowdvrcset).l
	movea.l	(CrowdSprites).l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain
	move.w	d4,(arenaanimchars).l
	addi.w	#$32,d4
	move.w	d4,(spritechars).l
	bsr.w	defaultsprites
	move.w	d4,(dmaram).l
	bsr.w	setupIceRinkPal
	bsr.w	AddSmallFontFramer
	move.w	d4,(smallfontchars).l
	movea.l	(SmallFontMap).l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsWithRemap
	dc.l	$43434567,$89ABCDEF		;remap table
	move.w	d4,(BigFontchars).l		;1st vram char for Bigfont tiles
	movea.l	(BigFontMap).l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsWithRemap
	dc.l	$71234567,$89ABCDEF		;remap table
	bsr.w	setupTeamBlocksMap		;team blocks for both teams
	move.w	d4,(ExtraChars).l		;char space for extra graphics
	btst	#gmdir,(gmode).l		;gmdir: flip pfgoal for the 12 players
	beq.w	.gok
	movea.l	#SortCords,a3
	moveq	#$B,d0
.flip	bchg	#pfgoal,pflags(a3)		;flip each player's goal
	adda.w	#SCstruct,a3
	dbra	d0,.flip
.gok	bsr.w	CopyTeamLinesCheckTeam		;cartridge: setplayercolors
	move.w	#$FFFF,(PadControlBits).l		;no pad assignments
	move.w	#$FFFF,(PadControlBits34).l		;pads 3 and 4 off
	clr.l	(padcont).l
	clr.l	(padcont+4).l
	clr.l	(padcont+8).l
	st	(c1playernum).l		;no player for pad 1
	st	(c2playernum).l		;no player for pad 2
	movea.l	#DMAList,a5		;dump pad sprites so numbers
	movea.l	#Satt,a6		;aren't written over later.
	moveq	#$1,d6		;1 frame
	movea.l	#pads,a3
	clr.w	d0
	clr.w	d1
	bsr.w	addframe2		;pads1 addframe
	adda.w	#ffosize,a3
	bsr.w	addframe2		;pads2 addframe
	adda.w	#ffosize,a3
	bsr.w	addframe2		;pads3 addframe
	adda.w	#ffosize,a3
	bsr.w	addframe2		;center ice logo addframe
	adda.w	#ffosize,a3
	bsr.w	addframe2		;stick/gloves addframe?
	adda.w	#ffosize,a3
	bsr.w	addframe2
	move.l	a5,(DMAlistend).l		;end of the DMA list
	bsr.w	dodmalist
	move.w	(sp)+,(disflags).l
	move.l	#VBlank,(VBint).l
	bclr	#dfok,(disflags).l		;graphics not ready
	bclr	#dfng,(disflags).l
	bset	#$5,(GA_COMFLAGS+1).l		;cartridge: move #$2300,sr (interrupts on)
	movem.l	(sp)+,d0-d7/a0-a6
	rts