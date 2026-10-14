;	Controller setup before name entry and the scouting report. Ported from NHL 95 goal95.asm (new in 95).
;	Runs from Opening2 when SEASON=1. Practice Mode UI only appears when sflags9 bit 7 is set (never in this port).

SetContTeams	;Pick the team of each pad (cont1team ... cont4team). A demo or a timeout clears all pads
	tst.w	(demoflag).w
	bmi.w	.setup
.clear
	clr.w	(cont1team).w
	clr.w	(cont2team).w
	clr.w	(cont3team).w
	clr.w	(cont4team).w
	rts
.setup
	clr.w	(setupvalues).w
	clr.w	(setupvalues+2).w
	move.w	#1,(cont1team).w
	clr.w	(cont2team).w
	clr.w	(cont3team).w
	clr.w	(cont4team).w
	bsr.w	ControllerSetupScreen
	bsr.w	PrintPracticeTitle
	bsr.w	DrawPadSetup
	btst	#7,(sflags9).w
	beq.w	.2
	bsr.w	PrintPracticePlayers
.2
	move.w	#$18,(palcount).w
	bclr	#2,(disflags).w
	clr.w	(carddelay).w
.frame
	move.w	(vcount).w,d0
.wait
	cmp.w	(vcount).w,d0
	beq.s	.wait
	addq.w	#1,(carddelay).w
	cmpi.w	#$5460,(carddelay).w
	bge.s	.clear
	bsr.w	ReadAllPads
	tst.w	(TempLegSpd).w
	beq.w	.keys
	clr.w	(carddelay).w
.keys
	btst	#7,(TempLegSpd+1).w
	bne.w	.exit
	btst	#1,(TempLegSpd+1).w
	beq.w	.up
	tst.w	(setupvalues).w
	bne.w	.up
	btst	#7,(sflags9).w
	beq.w	.up
	eori.w	#1,(setupvalues).w
	bsr.w	PrintPracticeTitle
.up
	btst	#0,(TempLegSpd+1).w
	beq.w	.pads
	tst.w	(setupvalues).w
	beq.w	.pads
	eori.w	#1,(setupvalues).w
	bsr.w	PrintPracticeTitle
.pads
	move.w	#1,d4
	tst.w	(FourWayPlay).w
	beq.w	.8
	btst	#0,(gmode2).w
	bne.w	.8
	move.w	#3,d4
.8
	movea.l	#cont1team,a0
	movea.l	#TempWord1+1,a3
.pad
	move.b	(a3),d1
	btst	#2,d1
	beq.w	.right
	tst.w	(setupvalues).w
	bne.w	.fewer
	move.w	(a0),d0
	cmp.w	#2,d0
	beq.w	.right
	movea.l	#ContTeamOrder1,a4
	move.b	(a4,d0.w),d0
	move.w	d0,(a0)
	bsr.w	DrawPadSetup
	bra.w	.nextpad
.fewer
	subq.w	#1,(setupvalues+2).w
	bpl.w	.11
	move.w	#7,(setupvalues+2).l
.11
	bsr.w	PrintPracticePlayers
	bra.w	.nextpad
.right
	btst	#3,d1
	beq.w	.nextpad
	tst.w	(setupvalues).w
	bne.w	.more
	move.w	(a0),d0
	cmp.w	#1,d0
	beq.w	.nextpad
	movea.l	#ContTeamOrder2,a4
	move.b	(a4,d0.w),d0
	move.w	d0,(a0)
	bsr.w	DrawPadSetup
	bra.w	.nextpad
.more
	addq.w	#1,(setupvalues+2).w
	cmpi.w	#7,(setupvalues+2).l
	ble.w	.14
	move.w	#0,(setupvalues+2).w
.14
	bsr.w	PrintPracticePlayers
	bra.w	*+4
.nextpad
	addq.w	#2,a0
	addq.w	#2,a3
	dbf	d4,.pad
	bra.w	.frame
.exit
	rts

ContTeamOrder1	;Pad team order tables for SetContTeams
	dc.b	2,0,2,$FF

ContTeamOrder2
	dc.b	1,1,0,$FF

PrintPracticePlayers	;Practice Mode is out of scope in the 94 season port
	rts

PrintPlayerCount
	rts

DrawPadSetup	;Draw the pads, their icons (DrawPadIcon) and the cursor (DrawPadCursor)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$A,(printy).w
	move.w	#1,d4
	tst.w	(FourWayPlay).w
	beq.w	.0
	btst	#0,(gmode2).w
	bne.w	.0
	move.w	#3,d4
.0
	movea.l	#cont1team,a0
	move.w	#0,d7
.loop
	move.w	(printy).w,-(sp)
	subq.w	#1,(printy).w
	movea.l	#BlankLineTxt,a1
	bsr.w	PrintSetupStr
	addq.w	#1,(printy).w
	bsr.w	PrintSetupStr
	addq.w	#1,(printy).w
	bsr.w	PrintSetupStr
	jsr	(printz).l
	String	-TXMAP1,0,0,0
	move.w	(sp)+,(printy).w
	move.w	#$F,(printx).w
	tst.w	(a0)
	beq.w	.draw
	move.w	#$1B,(printx).w
	cmpi.w	#1,(a0)
	beq.w	.draw
	move.w	#3,(printx).w
.draw
	bsr.w	DrawPadIcon
	bsr.w	DrawPadCursor
	addq.w	#2,a0
	addq.w	#3,(printy).w
	addq.w	#1,d7
	dbf	d4,.loop
	movem.l	(sp)+,d0-d7/a0-a6
	rts

DrawPadIcon	;Draw pad icon d7 (PadIconMaps at PadIconChars)
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#PadIconMaps,a0
	asl.w	#2,d7
	movea.l	#PadIconChars,a1
	movea.l	(a1,d7.w),a1
	move.w	(a1),d4
	movea.l	(a0,d7.w),a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#2,d2
	moveq	#2,d3
	moveq	#4,d5
	jsr	(dobitmap).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PadIconMaps	;Pad icon bitmaps, then (PadIconChars) the RAM words with their chars
	dc.l	PadIconMap1,PadIconMap2,PadIconMap3,PadIconMap4

PadIconChars
	dc.l	padiconchars1,padiconchars2,padiconchars3,padiconchars4

DrawPadCursor	;Draw the pad cursor (PadCursorMap, padcursorchars) beside printx / printy
	move.w	(printx).w,-(sp)
	move.w	(printy).w,-(sp)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(padcursorchars).w,d4
	movea.l	#PadCursorMap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	addq.w	#4,(printx).w
	clr.w	d1
	subq.w	#1,(printy).w
	moveq	#7,d2
	moveq	#3,d3
	moveq	#0,d5
	jsr	(dobitmap).l
	movem.l	(sp)+,d0-d7/a0-a6
	move.w	(sp)+,(printy).w
	move.w	(sp)+,(printx).w
	rts

BlankLineTxt	;A blank line
	String	$FD,$0,'                                        '

PrintPracticeTitle	;Practice Mode title (PrintSetupStrHi when setupvalues is not 0)
	btst	#7,(sflags9).w
	beq.w	.exit
	movea.l	#PracticePlayersTxt,a1
	tst.w	(setupvalues).w
	beq.w	.normal
	bsr.w	PrintSetupStrHi
	bra.w	.exit
.normal
	bsr.w	PrintSetupStr
.exit
	rts

PracticePlayersTxt
	String	$FD,$C,$FC,$16,'PRACTICE PLAYERS',$FD,$19,$FC,$17,'No. of Players',$FD,$2,'No. of Players'

ControllerSetupScreen	;VRAM, fonts, team blocks, pad tiles, ControllerBgMap and title, then team blocks for VisTeam / HomeTeam
	move.l	#VBlank_SetOptions,(vbint).w
	move	#$2500,sr
	bclr	#0,(disflags).w
	bset	#2,(disflags).w
	bclr	#1,(disflags).w
	move.w	#0,(VSCRLPM).w
	move.w	#$B400,(VSPRITES).w
	move.w	#$B800,(VmMap3).w
	move.w	#5,(Map3col1).w
	move.w	#$C000,(VmMap2).w
	move.w	#6,(Map2col1).w
	move.w	#$E000,(VmMap1).w
	move.w	#6,(Map1col1).w
	move.w	#0,d0
	jsr	(setVram).l
	jsr	(orjoy).l
	move.w	#1,d4
	move.w	d4,(smallfontchars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,(smallfont2chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$05,$23,$45,$67,$89,$AB,$CD,$EF
	move.w	d4,(smallfont3chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0D,$23,$45,$67,$89,$AB,$CD,$EF
	move.l	#SmallFontMap,(smallfontptr).l
	move.w	d4,(BigFontChars).w
	movea.l	#BigFontMap+8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,(teamblocksmapptr).w
	movea.l	#Teamblocksmap+8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,(padcursorchars).w
	movea.l	#PadCursorMap+8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,(padiconchars1).w
	movea.l	#PadIconMap1+8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,(padiconchars2).w
	movea.l	#PadIconMap2+8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,(padiconchars3).w
	movea.l	#PadIconMap3+8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,(padiconchars4).w
	movea.l	#PadIconMap4+8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	(VisTeam).w,d1
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),2,6,0
	bsr.w	DrawSetupTeamBlock
	move.w	(HomeTeam).w,d1
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$1B,6,0
	bsr.w	DrawSetupTeamBlock
	jsr	(printz).l
	String	-TXMAP2,0,0,0
	movea.l	#ControllerBgMap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$28,d2
	moveq	#$1C,d3
	moveq	#3,d5
	jsr	(dobitmap).l
	jsr	(printz).l
	String	-TXMAP2,$E,6,0
	movea.l	#ControllerTitleMap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$C,d2
	moveq	#2,d3
	moveq	#0,d5
	jsr	(dobitmap).l
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP1),5,2,'Controller SetUp'
	rts

DrawSetupTeamBlock	;Draw team block d1 (Teamblocksmap) at printx / printy
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d0
	asl.w	#1,d1
	move.w	(teamblocksmapptr).w,d4
	movea.l	#Teamblocksmap,a0
	movea.l	a0,a1
	adda.l	(a0),a0
	adda.l	4(a1),a1
	movea.l	#ZeroLong,a2
	move.w	(a1),d2
	moveq	#2,d3
	moveq	#0,d5
	jsr	(dobitmap).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PrintSetupStr	;Print String a1 (printsmallz $FE,5,$FF,1,$F9,0, then printsmall)
	movem.l	d0-d7/a0-a6,-(sp)
	move.l	a1,-(sp)
	jsr	(printsmallz).l
	String	CC_SetAttribute,5,CC_SetMap,1,CC_SetFont,0
	movea.l	(sp)+,a1
	jsr	(printsmall).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PrintSetupStrHi	;The same highlighted ($F9,1)
	movem.l	d0-d7/a0-a6,-(sp)
	move.l	a1,-(sp)
	jsr	(printsmallz).l
	String	CC_SetAttribute,5,CC_SetMap,1,CC_SetFont,1
	movea.l	(sp)+,a1
	jsr	(printsmall).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

ReadAllPads	;Read the 4 pads into TempWord1 ... TempMaxSpd; or them in TempLegSpd
	jsr	(ReadJoy1).l
	jsr	(nodiag).l
	move.w	d1,(TempWord1).w
	jsr	(ReadJoy2).l
	jsr	(nodiag).l
	move.w	d1,(TempWord2).w
	jsr	(ReadJoy3).l
	jsr	(nodiag).l
	move.w	d1,(TempRawSpd).w
	jsr	(ReadJoy4).l
	jsr	(nodiag).l
	move.w	d1,(TempMaxSpd).w
	move.w	(TempWord1).w,d1
	or.w	(TempWord2).w,d1
	or.w	(TempRawSpd).w,d1
	or.w	(TempMaxSpd).w,d1
	move.w	d1,(TempLegSpd).w
	rts

ControllerTitleMap
	incbin	..\Extracted\NHL94\Season\ControllerTitleMap.map.jim
PadCursorMap
	incbin	..\Extracted\NHL94\Season\PadCursorMap.map.jim
PadIconMap1
	incbin	..\Extracted\NHL94\Season\PadIconMap1.map.jim
PadIconMap2
	incbin	..\Extracted\NHL94\Season\PadIconMap2.map.jim
PadIconMap3
	incbin	..\Extracted\NHL94\Season\PadIconMap3.map.jim
PadIconMap4
	incbin	..\Extracted\NHL94\Season\PadIconMap4.map.jim
