;	Stanley Cup celebration screen. Ported from NHL 95 title95.asm. Uses SngEOG for music.

StanleyCupScreen	;Cup picture, winner team block, sprites, then wait for start
	movem.l	d0-d7/a0-a6,-(sp)
	move.l	#CupVBlank,(vbint).l
	bclr	#1,(disflags).w
	move.w	#0,(VSCRLPM).w
	move.w	#$BC00,(VSPRITES).w
	move.w	#$B000,(VmMap3).w
	move.w	#6,(Map3col1).w
	move.w	#$C000,(VmMap2).w
	move.w	#7,(Map2col1).w
	move.w	#$E000,(VmMap1).w
	move.w	#7,(Map1col1).w
	move.w	#0,d0
	jsr	(setVram).l
	clr.w	(cupframe).w
	move.w	#1,d4
	move.w	d4,(teamblocksmapptr).w
	movea.l	#Teamblocksmap+8,a2
	jsr	(DecompressGraphicsPlain).l
	movea.l	#CupSprites,a1
	lea	8(a1),a2
	adda.l	(a1),a1
	move.w	d4,(energybarchars).w
	jsr	(DecompressGraphicsPlain).l
	jsr	(printz).l
	String	-TXMAP2,$0,$0,$0
	movea.l	#StanleyCupImg,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#$F,d5
	jsr	(dobitmap).l
	bsr.w	CupDrawTeam
	move.w	#$18,(palcount).w
	jsr	(stop_current_song).l
	move.w	#SngEOG,-(sp)
	jsr	(song).l
.loop
	jsr	(CupWaitFrame).l
	jsr	(CupBuildSprites).l
	jsr	(CupReadPads).l
	bra.s	.loop

CupReadPads	;All pads; start leaves StanleyCupScreen
	jsr	(ReadJoy1).l
	move.w	d3,-(sp)
	jsr	(ReadJoy2).l
	or.w	d3,(sp)
	tst.w	(FourWayPlay).w
	beq.w	.0
	jsr	(ReadJoy3).l
	or.w	d3,(sp)
	jsr	(ReadJoy4).l
	or.w	d3,(sp)
.0
	move.w	(sp)+,d3
	btst	#7,d3
	bne.w	CupExit
	rts

CupWaitFrame	;Wait for the next vblank
	move.w	(vcount).w,d0
.loop
	cmp.w	(vcount).w,d0
	beq.s	.loop
	rts

CupExit	;CupReadPads on start drops its return address
	addq.w	#4,sp
	movem.l	(sp)+,d0-d7/a0-a6
	rts

CupVBlank	;Sprites, cramfade, music
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#2,(disflags).w
	bne.w	.skip
	movea.w	#(Satt-M68K_RAM),a0
	move.w	(Sattsize).w,d0
	beq.w	.nodma
	clr.w	(Sattsize).w
	move.w	(VSPRITES).w,d1
	jsr	(DoDMA).l
.nodma
	jsr	(cramfade).l
.skip
	addq.w	#1,(vcount).w
	jsr	(p_music_vblank).l
	movem.l	(sp)+,d0-d7/a0-a6
	rte

CupDrawTeam	;Team block of cupwinner
	movem.l	d0-d7/a0-a3,-(sp)
	jsr	(printz).l
	String	-TXMAP2,$17,$16,$0
	move.w	(cupwinner).w,d1
	add.w	d1,d1
	movea.l	#Teamblocksmap,a1
	adda.l	4(a1),a1
	movea.l	#ZeroLong,a2
	clr.w	d0
	move.w	(a1),d2
	moveq	#2,d3
	move.w	(teamblocksmapptr).w,d4
	moveq	#0,d5
	jsr	(dobitmap).l
	movem.l	(sp)+,d0-d7/a0-a3
	rts

CupBuildSprites	;Animated CupSprites into Satt
	movea.w	#(Satt-M68K_RAM),a6
	moveq	#1,d6
	movea.l	#CupSprites,a0
	move.w	(energybarchars).w,d3
	ori.w	#$8000,d3
	move.w	#$80,d0
	move.w	#$80,d1
	move.w	(cupframe).w,d2
	addq.w	#1,(cupticks).w
	cmpi.w	#$A,(cupticks).w
	blt.w	.add
	clr.w	(cupticks).w
	addq.w	#1,(cupframe).w
	cmpi.w	#$E,(cupframe).w
	blt.w	.add
	clr.w	(cupframe).w
.add
	jsr	(AddSpriteFrame).l
	cmpa.w	#(Satt-M68K_RAM),a6
	bne.w	.1
	clr.l	(a6)+
	clr.l	(a6)+
.1
	clr.b	-5(a6)
	move.l	a6,d0
	subi.l	#Satt,d0
	lsr.w	#1,d0
	move.w	d0,(Sattsize).w
	rts

AddSpriteFrame	;Frame d2 of sprite map a0 into list a6 (d6 count, max $40)
	cmp.w	#$40,d6
	bge.w	.exit
	movem.l	d0-d5/a0,-(sp)
	adda.l	4(a0),a0
	add.w	d2,d2
	move.w	2(a0,d2.w),d4
	sub.w	(a0,d2.w),d4
	lsr.w	#3,d4
	subq.w	#1,d4
	adda.w	(a0,d2.w),a0
.loop
	move.w	2(a0),d2
	andi.w	#$F000,d2
	lsr.w	#1,d2
	move.w	d2,-(sp)
	move.w	4(a0),d2
	andi.w	#$7FF,d2
	or.w	(sp)+,d2
	add.w	d3,d2
	move.w	(a0),(a6)
	add.w	d1,(a6)+
	move.b	2(a0),(a6)+
	move.b	d6,(a6)+
	move.w	d2,(a6)+
	move.w	6(a0),(a6)
	add.w	d0,(a6)+
	addq.w	#1,d6
	cmp.w	#$40,d6
	beq.w	.full
	addq.w	#8,a0
	dbf	d4,.loop
.full
	movem.l	(sp)+,d0-d5/a0
.exit
	rts

StanleyCupImg
	incbin	..\Extracted\NHL94\Season\StanleyCupImg.map.jim
CupSprites
	incbin	..\Extracted\NHL94\Season\CupSprites.map.jim
