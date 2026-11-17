vb2						;Vblank used for palfades only, no dmas (VBint target). No rte here: falls
									;into IRQ7
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#$2,(disflags).l
	bne.w	.nograph
	bsr.w	ForceBlackStep
.nograph	addq.w	#$1,(ScoutSubStatus).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
; Vertical interrupt: runs the dma list
VBlankDmaList	bsr.w	DmaListWait
	movea.l	#$BBD30,a0
	move.w	$17F66.l,d0
	move.w	$18D32.l,d1
	dc.w	$6100,$9D0A		; bsr.w X_378D2
	movea.l	$191CA.l,a6
	cmpa.l	#$18D6A,a6
	beq.w	rtss2
.loop	move.w	-(a6),d1
	move.w	-(a6),d0
	movea.l	-(a6),a0
	dc.w	$6100,$9CF0		; bsr.w X_378D2
	cmpa.l	#$18D6A,a6
	bgt.w	.loop
	rts	
dodmalist
	movea.l	$191CA.l,a6
	cmpa.l	#$18D6A,a6
	beq.w	rtss2
.0	move.w	-(a6),d1
	move.w	-(a6),d0
	movea.l	-(a6),a0
	bsr.w	DoDMAProQueue
	cmpa.l	#$18D6A,a6
	bgt.w	.0
	rts
; Waits for the sub CPU and writes the dma list
DmaListWait	move.w	$18D30.l,d0
	addi.w	#$2,d0
	bsr.w	SetVramWriteAddr2
.loop	btst.b	#$4,$FF800E.l
	bne.s	.loop
	move.w	#$31,$FF8026.l
	move.w	$17CF0.l,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop2	btst.b	#$3,$FF800E.l
	beq.s	.loop2
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop3	btst.b	#$3,$FF800E.l
	bne.s	.loop3
	bclr.b	#$4,$FF800F.l
.loop4	btst.b	#$4,$FF800E.l
	bne.s	.loop4
	move.w	#$30,$FF8026.l
	move.l	#$40020010,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop5	btst.b	#$3,$FF800E.l
	beq.s	.loop5
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop6	btst.b	#$3,$FF800E.l
	bne.s	.loop6
	bclr.b	#$4,$FF800F.l
.loop7	btst.b	#$4,$FF800E.l
	bne.s	.loop7
	move.w	#$31,$FF8026.l
	move.w	$17CF2.l,$FF8028.l
	bset.b	#$3,$FF800F.l
.loop8	btst.b	#$3,$FF800E.l
	beq.s	.loop8
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.loop9	btst.b	#$3,$FF800E.l
	bne.s	.loop9
	bclr.b	#$4,$FF800F.l
	rts
setvideo
	movem.l	d0-d7/a0-a6,-(sp)
.p	btst	#$0,(disflags).l
	bne.w	.p
	movea.l	#$18D6A,a5
	bsr.w	updatescroll
	movea.l	#$BBD30,a6
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
	cmpa.l	#$BBD30,a6
	bne.w	.n
	clr.l	(a6)+
	clr.l	(a6)+
.n	clr.b	-$5(a6)
	move.l	a6,d0
	subi.l	#$BBD30,d0
	lsr.w	#$1,d0
	move.w	d0,$17F66.l
	move.l	a5,$191CA.l
	move.l	a5,$1AD96.l
	bset	#$0,(disflags).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
updatescroll						;Using hpos and vpos set scroll cords; queue rink map rows on the dma list
									;(a5) when vertical scrolling needs new rows. Called from setvideo. Takes
									;the rows from Rinktilelist, or RevRinkTilelist in a reverse angle replay
									;(sflags4 bit 4)
	btst	#$7,$17F6A.l		;sfhor
	bne.w	rtss2
	moveq	#-64,d0		;-192+128 (#$FFFFFFC0)
	sub.w	$17CEE.l,d0
	move.w	$17CEA.l,d1
	move.w	d0,$17CF0.l
	move.w	d1,$17CF2.l
	neg.w	$17CF2.l
	move.w	$17CEC.l,d4
	asr.w	#$3,d1
	move.w	d1,$17CEC.l
	moveq	#$1F,d3		;max lines to update
	cmp.w	d4,d1
	beq.w	rtss2		;same row as last frame
	movea.l	$47D18.l,a0
	btst	#$4,$17F72.l		;reverse angle replay
	beq.w	.0
	movea.l	$47D64.l,a0
.0	adda.l	$4(a0),a0		;a0 = map header: (a0) = chars per row, data at 4(a0) (the move / adda
	blt.w	.su0		;row went up
.sd	move.w	d1,d0		;scrolling down: queue map rows, one per pass (d3 = max rows)
	neg.w	d0
	addi.w	#$1E,d0
	andi.w	#$1F,d0
	asl.w	#$7,d0		;chars per row screen format
	add.w	$18D38.l,d0
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
	add.w	$18D38.l,d0
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
	bclr	#$1,$17F6C.l		;sf2refref
	beq.w	rtss2
	movea.l	#$18074,a0
	movea.l	#VmMAP1,a1
	move.w	$2(a1),d2
	moveq	#$2,d0		;refy: Xpos on ice screen
	btst	#$7,$17F6A.l
	beq.w	.1
	moveq	#$F,d0		;Ypos on scoreboard screen
.1	asl.w	d2,d0		;row * map row size
	moveq	#$2,d1
	asl.w	d2,d1		;d1 = vram step of 2 map rows
	addi.w	#$2,d0		;refx
	btst	#$7,$17F6A.l
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
	btst	#$0,$17F6A.l		;sfpz
	bne.w	rtss2
	btst	#$4,(disflags).l		;face off flag
	beq.w	rtss2
	movea.l	#$17CF8,a3
	moveq	#$2,d0
.loop	move.w	(a3),d4
	bmi.w	.next
	beq.w	.next
	movea.l	$47D30.l,a2
	adda.l	$4(a2),a2
	add.w	d4,d4
	move.w	$2(a2,d4.w),d5
	sub.w	(a2,d4.w),d5
	lsr.w	#$3,d5
	subi.w	#$1,d5
	adda.w	(a2,d4.w),a2
.loop2	move.w	$2(a2),d2
	addi.w	#$80,d2
	add.w	$1746E.l,d2
	move.w	d2,(a6)
	move.w	(a2),d2
	btst	#$3,$2(a3)		;x flip
	beq.w	.0
	move.b	$7(a2),d2
	andi.w	#$C,d2
	addi.w	#$4,d2
	asl.w	#$1,d2
	neg.w	d2
	sub.w	(a2),d2
.0	addi.w	#$80,d2
	add.w	$1746C.l,d2
	move.w	d2,$6(a6)
	move.b	$7(a2),$2(a6)
	move.b	d6,$3(a6)
	move.w	$6(a2),d2
	andi.w	#$F800,d2
	or.w	$4(a2),d2
	move.w	$2(a3),d1
	andi.w	#$F800,d1
	eor.w	d1,d2
	add.w	$18D4C.l,d2
	move.w	d2,$4(a6)
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
	move.w	$17CE2.l,d0
	bmi.w	rtss2		;no zamboni
	movea.l	$47D34.l,a0
	lsr.w	#$2,d0
	move.w	#$12A,d1		;y (92 128+200)
	moveq	#$1,d2		;frame
	move.w	$18D56.l,d3
	bsr.w	SetSframe
	move.w	d0,d2
	lsr.w	#$1,d2
	ext.l	d2
	divu.w	#$3,d2
	swap	d2
	addi.w	#$2,d2		;frame 2 + (x/2 mod 3)
	bsr.w	SetSframe
	moveq	#$5,d2
	move.w	$18358.l,d4
	cmp.w	$186BE.l,d4
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
	adda.l	$4(a0),a0
	add.w	d2,d2
	move.w	$2(a0,d2.w),d4
	sub.w	(a0,d2.w),d4
	lsr.w	#$3,d4
	subi.w	#$1,d4
	adda.w	(a0,d2.w),a0
.loop	move.w	$2(a0),(a6)
	add.w	d1,(a6)+
	move.b	$7(a0),(a6)+
	move.b	d6,(a6)+
	move.w	$6(a0),d2
	andi.w	#$F800,d2
	add.w	$4(a0),d2
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
	btst	#$4,$17F72.l		;check if reverse angle replay
	bne.w	.x		;branch if so
	movea.l	$47D2C.l,a1
	adda.l	$4(a1),a1		;a1 = frame offset table
	move.w	$17CEE.l,d4
	move.w	$17CEA.l,d5
	btst	#$7,$17F6A.l
	beq.w	.v
	moveq	#-64,d4		;(#$FFFFFFC0)
	move.l	#$100,d5
.v	clr.w	d0		;d4/d5 = x/y of the view
	move.b	$18068.l,d2
	moveq	#$1A,d3
	bsr.w	.pb
	move.b	$18068.l,d2
	lsr.w	#$4,d2		;high nibble
	moveq	#$1D,d3		;frames 29+ (high nibble)
	bsr.w	.pb
	move.b	(Crowdframe).l,d0
	bsr.w	.sc
	move.b	$17CD1.l,d0
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
	btst	#$7,$17F6A.l
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
.loop	cmp.w	$2(a0),d2		;per sprite: skip it if outside the window d0-d3
	bgt.w	.next2
	cmp.w	$2(a0),d3
	blt.w	.next2
	cmp.w	(a0),d0
	bgt.w	.next2
	cmp.w	(a0),d1
	blt.w	.next2
	move.w	$2(a0),d5
	addi.w	#$70,d5		;128-16
	sub.w	d2,d5
	move.w	d5,(a6)+
	move.b	$7(a0),(a6)+
	move.b	d6,(a6)+
	move.w	$6(a0),d5
	andi.w	#$F800,d5
	add.w	$4(a0),d5
	add.w	$18D4A.l,d5
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
	btst	#$7,$17F6A.l		;sfhor
	beq.w	showclockVertical
	btst	#$0,$17F78.l		;shootout
	bne.w	.x
	move.l	a1,-(sp)
	jsr	(printz).l
	String	CC_Font2Pri,$D,$5
	move.w	$180E6.l,d0
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
	movea.l	#$3E274,a1
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
	btst	#$3,$17F6C.l
	bne.w	rtss2
	cmpi.w	#$4,$180E4.l
	beq.w	rtss2
	movea.l	#$17EDA,a0
	movea.l	(SmallFontMap).l,a1
	adda.l	$4(a1),a1
	move.w	$78(a1),d0
	add.w	$18D42.l,d0
	ori.w	#$8000,d0
	move.w	d0,$17ED4.l
	move.w	$180E6.l,d0
	btst	#$1,$17F78.l
	beq.w	.next
	move.w	$193B6.l,d0
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
	btst	#$7,$17F6A.l
	beq.w	.next3
	movea.l	#$18D38,a1
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
	add.w	$18D42.l,d0
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
	btst	#$7,$17F6A.l
	bne.w	rtss2
	movea.l	#$17D20,a0
	movea.l	#$17DD8,a3
	move.w	#$180,d3		;frame numbers are 6 higher than 92
	bsr.w	.ca
	adda.w	#$1C,a0		;next pad object
	adda.w	#$14,a3		;ssosize
	move.w	#$183,d3
	bsr.w	.ca
	tst.w	$17FAA.l
	beq.w	rtss2		;on screen: no arrow
	movea.l	#$17D74,a0
	adda.w	#$14,a3
	move.w	#$346,d3
	bsr.w	.ca
	tst.w	$17FAC.l
	beq.w	rtss2
	movea.l	#$17D90,a0
	adda.w	#$14,a3
	move.w	#$349,d3
.ca	tst.w	$18(a0)
	bmi.w	rtss2		;not on the ice
	st.b	$6(a3)
	move.w	$0(a0),d0
	btst	#$0,$17F78.l
	bne.w	.0
	btst	#$3,$17F6C.l
	bne.w	.0
	btst	#$2,$17F70.l
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
.7	move.w	$14(a0),d1
	btst	#$7,$17F6A.l
	beq.w	.nhor
	exg.l	d0,d1		;horizontal view: swap axes
	neg.w	d0
	subi.w	#$C5,d1		;horoff
	bra.w	.hord
.nhor	sub.w	$17CEE.l,d0
	sub.w	$17CEA.l,d1
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
	movea.l	#$37588,a1
	move.b	(a1,d2.w),d2
	asl.w	#$3,d2
	movea.l	#$3E4D4,a1
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
	move.w	d3,$6(a3)
	move.w	$6(a1,d2.w),$4(a3)		;flip bits
	bra.w	addframe2
; Data that follows checksso (strings, small tables)
checkssoData	dc.w	$0000,$0064,$0000,$0000,$0074,$0064,$0001,$0000		;x spot, y spot, frame add, attribute per direction
	dc.w	$0074,$0000,$0002,$0000,$0074,$FF9C,$0001,$1000		;.xspot = 116, .yspot = 100
	dc.w	$0000,$FF9C,$0000,$1000,$FF8C,$FF9C,$0001,$1800
	dc.w	$FF8C,$0000,$0002,$0800,$FF8C,$0064,$0001,$0800
setsortcords						;setup sort cord graphics: addframe for the 16 objects in OOlist order. a5
									;= dmalist, a6 = sprite attribute table, d6 = link counter
	movea.l	#$17CC0,a4		;move OOlist into a4
	move.w	#$F,d0		;sortobj-1 (15 dec)
.top	clr.w	d1
	move.b	(a4)+,d1		;move next sortcord into d1
	asl.w	#$6,d1		;mult by 64
	movea.l	#$17480,a3
	adda.w	d1,a3
	bsr.w	addframe
	dbra	d0,.top
	rts
setffo						;draw the 7 objects tied to icerink scrolling (gloves and pads), moving
									;each by its x offset. Called from setvideo
	bsr.w	uppads
	move.w	#$6,d0		;ffo obj -1
	movea.l	#$17D04,a3		;move start of struct into a3
.top	movea.l	a6,a0		;per object: a0 = first sprite this object writes
	bsr.w	addframe
	cmpa.l	a6,a0
	beq.w	.next		;no sprites added
	move.w	$2(a3),d1		;x offset (set by QueuePadLabel)
	add.w	d1,$6(a0)		;sprite 1 x
	add.w	d1,$E(a0)
.next	adda.w	#$1C,a3		;move to next struct
	dbra	d0,.top
	rts
uppads						;update the gloves object and the 6 pad objects, and queue new pad labels
									;(QueuePadLabel). The pad players
									;come from the PadControlBits / PadControlBits34 nibbles ($E = no change,
									;$F = none)
	movea.l	#$17DAC,a0		;pads+(4*ffosize): gloves
	st.b	$18(a0)		;set Zpos
	move.b	$17E32.l,d0
	beq.w	.0		;branch if 0
	move.b	$17E33.l,d1
	ext.w	d0
	asl.w	#$2,d0
	move.w	d0,$0(a0)		;move d0 into Xpos
	ext.w	d1
	asl.w	#$2,d1
	move.w	d1,$14(a0)		;move d1 into Ypos
	clr.w	$18(a0)		;clear Zpos
.0	move.w	#$5,d4
	movea.l	#$17D04,a0
	movea.l	#$17DCA,a1		;last label code per pad
	movea.l	#$17480,a2
	move.w	$17DC8.l,d3
.loop	cmpi.w	#$1,d4
	bne.w	.nibble
	move.w	$17DD6.l,d3
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
	move.w	$14(a2,d0.w),$14(a0)
	clr.w	$18(a0)		;shown
	move.b	$35(a2,d0.w),d1		;label code = position << 8 | rostnum
	asl.w	#$8,d1
	move.b	$6F(a2,d0.w),d1
.chg	cmp.w	(a1),d1		;new label code vs the last one for this pad
	beq.w	.next		;same label as last time
	move.w	d1,(a1)
	bsr.w	QueuePadLabel
.next	lsr.w	#$4,d3
	adda.w	#$1C,a0
	adda.w	#$2,a1
	dbra	d4,.loop
	rts
QueuePadLabel						;Queue the 3 character label of a pad object. d1 = label code: bits 7-4
									;and 3-0 are digits ($F = blank), bits 10-8 index ButtonLabelCharTable
									;(none while sflags7 bit 7 is set).
									;a0 = pad object, a5 = dma list. Falls into uppads_pd for the
									;last char
; Table of 2 words after QueuePadLabel, 4 bytes: $49FA,$0098 ...
	dc.w	$49FA,$0098
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
	btst	#$7,$17F7A.l
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
	adda.l	$4(a3),a3
	add.w	d2,d2
	move.w	$4(a3,d2.w),d2
	andi.w	#$7FF,d2
	asl.w	#$5,d2		;32 bytes per tile
	movea.l	(SmallFontMap).l,a3
	lea.l	$A(a3,d2.w),a3		;tile data
	move.l	a3,(a5)+
	move.w	#$10,(a5)+		;words to transfer
	add.w	$12(a0),d0
	asl.w	#$5,d0
	move.w	d0,(a5)+		;vram destination
	rts
; Text of uppads_pd (1 row).
	dc.b	' DDLCRX',$00
addframe
	movem.l	d0-d2,-(sp)
	move.w	$0(a3),d0
	move.w	$14(a3),d1
	move.w	$18(a3),d2
	bmi.w	.exit
	bsr.w	find3d
	cmpi.w	#$4E20,d1
	beq.w	.exit
	bsr.w	addframe2
.exit	movem.l	(sp)+,d0-d2
	rts

addframe2
	move.w	$4(a3),-(sp)
	movem.l	d0-d5/a0-a2,-(sp)
	move.w	$6(a3),d4
	bmi.w	.exit
	beq.w	.exit
	andi.w	#$F800,d4
	eor.w	d4,$4(a3)
	move.w	$6(a3),d4
	andi.w	#$7FF,d4
	movea.l	$47D24.l,a2
	adda.l	$4(a2),a2
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
	move.w	$6(a3),d0
	andi.w	#$7FF,d0
	cmp.w	$8(a3),d0
	beq.w	.noref
	tst.w	d5
	bne.w	.nn
	move.w	d0,$8(a3)
.nn	movem.w	d0-d4,-(sp)
	move.w	$4(a2),d2
	clr.w	d4
	move.b	$7(a2),d4
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
	add.w	$12(a3),d3
	ext.l	d2
	asl.l	#$5,d2
	add.l	$47D24.l,d2
	addi.l	#$A,d2
	asl.w	#$4,d4
	asl.w	#$5,d3
	move.l	d2,(a5)+
	move.w	d4,(a5)+
	move.w	d3,(a5)+
	movem.w	(sp)+,d0-d4
.dup	move.b	d3,$A(a3,d5.w)
.noref	move.w	(sp)+,d0
	movem.w	d0-d2,-(sp)
	move.w	$2(a2),d2
	btst	#$4,$4(a3)
	beq.w	.noyflip
	move.b	$7(a2),d2
	andi.w	#$3,d2
	addi.w	#$1,d2
	asl.w	#$3,d2
	neg.w	d2
	sub.w	$2(a2),d2
.noyflip	add.w	d2,d1
	move.w	d1,(a6)
	move.w	(a2),d2
	btst	#$3,$4(a3)
	beq.w	.noxflip
	move.b	$7(a2),d2
	andi.w	#$C,d2
	addi.w	#$4,d2
	asl.w	#$1,d2
	neg.w	d2
	sub.w	(a2),d2
.noxflip	add.w	d2,d0
	move.w	d0,$6(a6)
	move.b	$7(a2),$2(a6)
	move.b	d6,$3(a6)
	move.w	$6(a2),d2
	move.w	$4(a3),d0
	eor.w	d0,d2
	andi.w	#$F800,d2
	btst	#$0,$5(a3)
	beq.w	.nospec
	btst	#$E,d2
	beq.w	.nospec
	bset	#$D,d2
.nospec	or.b	$A(a3,d5.w),d2
	add.w	$12(a3),d2
	move.w	d2,$4(a6)
	movem.w	(sp)+,d0-d2
	addi.w	#$1,d6
	adda.w	#$8,a6
	adda.w	#$8,a2
	dbra	d5,.sloop
.exit	movem.l	(sp)+,d0-d5/a0-a2
	move.w	(sp)+,$4(a3)
	rts
find3d						;input: d0 = xfield, d1 = yfield, d2 = height off field. Output: d0 =
									;xscreen, d1 = yscreen, or d1 = $4E20 when off screen
	btst	#$7,$17F6A.l
	beq.w	.nhor
	exg.l	d0,d1
	neg.w	d0
	subi.w	#$C5,d1
	bra.w	.next2
.nhor	sub.w	$17CEE.l,d0
	sub.w	$17CEA.l,d1
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
UpdateSoundVdpSetup
	movem.l	d0-d7/a0-a6,-(sp)
	bset	#$1,(disflags).l
	move.w	#$C000,$18D38.l
	move.w	#$6,(Map2col).l
	move.w	#$DC00,$18D32.l
	move.w	#$E000,(VmMAP1).l
	move.w	#$6,(Map1col).l
	move.w	#$F000,$18D3C.l
	move.w	#$5,$18D3E.l
	move.w	#$FC00,$18D30.l
	moveq	#$0,d0
	bsr.w	setVram
	bclr	#$0,$17F6A.l
	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	clr.w	$17CEE.l
	clr.w	$17CEA.l
	move.w	#$7D0,$17CEC.l
	st.b	$17CE2.l
	move.w	#$800,d0
	move.w	(VmMAP1).l,d1
	move.w	#$7FF,d2
	bsr.w	DoDMANd2Queue
	clr.w	d4
	move.w	d4,$18D48.l
	movea.l	$47D18.l,a2
	addq.l	#$8,a2
	btst	#$4,$17F72.l
	beq.w	.next4
	movea.l	$47D64.l,a2
	addq.l	#$8,a2
.next4	bsr.w	DecompressGraphicsPlain
	jsr	(UnpackPictureSelectGfx).l
	move.w	d4,$18D50.l
	bsr.w	SetupIceRinkPalRemap
	move.w	d4,$18D46.l
	movea.l	$47D40.l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain
	move.w	d4,$18D4A.l
	movea.l	$47D2C.l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain
	move.w	d4,$1A54E.l
	addi.w	#$32,d4
	move.w	d4,$18D54.l
	bsr.w	CopyTeamBlockMapDataFill
	move.w	d4,$18C1C.l
	bsr.w	setupIceRinkPal
	bsr.w	AddSmallFontFramer
	move.w	d4,$18D42.l
	movea.l	(SmallFontMap).l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsWithRemap
; Inline data read by DecompressGraphicsWithRemap from the return address (16 rows).
	dc.w	$4343,$4567,$89AB,$CDEF,$33C4,$0001,$8D40,$2479
	dc.w	$0004,$7D38,$508A,$6100,$9EEE,$7123,$4567,$89AB
	dc.w	$CDEF,$6100,$029C,$33C4,$0001,$8D56,$0839,$0001
	dc.w	$0001,$7F68,$6700,$0018,$267C,$0001,$7480,$700B
	dc.w	$086B,$0007,$0062,$D6FC,$0080,$51C8,$FFF4,$6100
	dc.w	$07BC,$33FC,$FFFF,$0001,$7DC8,$33FC,$FFFF,$0001
	dc.w	$7DD6,$42B9,$0001,$7DCA,$42B9,$0001,$7DCE,$42B9
	dc.w	$0001,$7DD2,$50F9,$0001,$7F9E,$50F9,$0001,$7FA0
	dc.w	$2A7C,$0001,$8D6A,$2C7C,$000B,$BD30,$7C01,$267C
	dc.w	$0001,$7D04,$4240,$4241,$6100,$FC0C,$D6FC,$001C
	dc.w	$6100,$FC04,$D6FC,$001C,$6100,$FBFC,$D6FC,$001C
	dc.w	$6100,$FBF4,$D6FC,$001C,$6100,$FBEC,$D6FC,$001C
	dc.w	$6100,$FBE4,$23CD,$0001,$91CA,$6100,$F0E4,$33DF
	dc.w	$0001,$8D64,$23FC,$0003,$DAB8,$0001,$8D66,$08B9
	dc.w	$0000,$0001,$8D64,$08B9,$0002,$0001,$8D64,$08F9
	dc.w	$0005,$00FF,$800F,$4CDF,$7FFF,$4E75