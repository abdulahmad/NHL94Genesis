Sub_24348
	move.l	#$400D0,(VBint).l
	bset	#$5,$FF800F.l
	bclr	#$0,(disflags).l
	bset	#$2,(disflags).l
	bclr	#$1,(disflags).l
	move.w	#$0,$18D30.l
	dc.w	$33FC,$B400,$0001,$8D32
	move.w	#$B800,$18D3C.l
	move.w	#$5,$18D3E.l
	dc.w	$33FC,$C000,$0001,$8D38
	move.w	#$6,(Map2col).l
	move.w	#$E000,(VmMAP1).l
	move.w	#$6,(Map1col).l
	dc.w	$203C,$0000,$0000
	jsr	(setVram).l
	jsr	(orjoy).l
	jsr	$24866.l
	move.w	d4,(framercset).l
	movea.l	$47D78.l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
	dc.l	$03567564,$89ABCDEF
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_093E6.bin
ReadSetupPads						;wait up to $5460 frames (6 minutes) for a press on any pad (4 with
	
	
	
	
	
	
	move.l	#$5460,d6
.l952A	move.w	(ScoutSubStatus).l,d1
	dc.w	$9279,$0001,$7476
	beq.w	.l952A
	dc.w	$33F9,$0001,$7474,$0001,$7476
	bclr	#$5,$19390.l
	jsr	$24894.l
	jsr	(ReadJoy1).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.1
	btst	#$5,d1
	beq.w	.l965E
	btst	#$5,d2
	beq.w	.0
	move.w	#$53,$1939E.l
.0	bset	#$5,$19390.l
.1	jsr	(ReadJoy2).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.l95A6
	btst	#$5,d1
	beq.w	.l965E
	bset	#$5,$19390.l
.l95A6	dc.w	$4A79,$0001,$8BF8
	beq.w	.4
	jsr	$3752C.l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.3
	btst	#$5,d1
	beq.w	.l965E
	bset	#$5,$19390.l
.3	jsr	$3754A.l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.4
	btst	#$5,d1
	beq.w	.l965E
	bset	#$5,$19390.l
.4	btst	#$6,$19390.l
	beq.w	.5
	btst	#$7,$19390.l
	bne.w	.6
	dc.w	$33F9,$0001,$938E,$0001,$938A
	bsr.w	DrawVisBlock
.5	btst	#$7,$19390.l
	beq.w	.6
	dc.w	$33F9,$0001,$938C,$0001,$938A
	bsr.w	DrawHomeBlock
.6	cmpi.l	#$4650,d6
	bgt.w	.l9654
	btst	#$0,$19390.l
	bne.w	.l9654
	jsr	(ResetCardTimer).l
	bra.w	.l965A
.l9654	jsr	(PlayerCardTimer).l
.l965A	dbra	d6,.l952A
.l965E	rts
Sub_24660
	dc.w	$4279,$0001,$8C16
.l9666	btst	#$7,$FF800E.l
	bne.b	.l9666
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.l9680	btst	#$6,$FF800E.l
	beq.b	.l9680
	move.w	$FF8010.l,$18C18.l
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l96A4	btst	#$6,$FF800E.l
	bne.b	.l96A4
	bclr	#$7,$FF800F.l
.l96B6	btst	#$7,$FF800E.l
	bne.b	.l96B6
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.l96D0	btst	#$6,$FF800E.l
	beq.b	.l96D0
	move.w	$FF8010.l,$18C1A.l
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l96F4	btst	#$6,$FF800E.l
	bne.b	.l96F4
	bclr	#$7,$FF800F.l
	dc.w	$4279,$0001,$8BFA
	clr.w	(OptNOP).l
	dc.w	$4279,$0001,$8C0A
	dc.w	$33FC,$0001,$0001,$8C08
Sub_24720
	move.w	$18C04.l,-(sp)
	dc.w	$33D7,$0001,$8C0C
	dc.w	$33DF,$0001,$8C0E
	jsr	(UpdatePlayoffLevel).l
.l9738	btst	#$7,$FF800E.l
	bne.b	.l9738
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.l9752	btst	#$6,$FF800E.l
	beq.b	.l9752
	move.w	$FF8010.l,$18C18.l
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l9776	btst	#$6,$FF800E.l
	bne.b	.l9776
	bclr	#$7,$FF800F.l
.l9788	btst	#$7,$FF800E.l
	bne.b	.l9788
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.l97A2	btst	#$6,$FF800E.l
	beq.b	.l97A2
	move.w	$FF8010.l,$18C1A.l
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l97C6	btst	#$6,$FF800E.l
	bne.b	.l97C6
	bclr	#$7,$FF800F.l
	dc.w	$33F9,$0001,$8C0A,$0001,$8C22
	dc.w	$0C79,$0002,$0001,$8C0A
	bne.w	.l97FC
	dc.w	$4279,$0001,$8C0A
	bset	#$4,$17F7A.l
.l97FC	dc.w	$33F9,$0001,$8BFA,$0001,$8C24
	dc.w	$0C79,$0004,$0001,$8BFA
	bne.w	.l9828
	dc.w	$33FC,$0000,$0001,$8BFA
	bset	#$0,$17F78.l
	jsr	(ClearShootout).l
.l9828	jmp	(MakeTree).l
CheckNOPUnused						;unreferenced. Tests OptNOP for 0, 5, 6, 9 and $A and returns: no effect
	tst.w	(OptNOP).l
	beq.w	.x
	cmpi.w	#$5,(OptNOP).l
	beq.w	.x
	cmpi.w	#$6,(OptNOP).l
	beq.w	.x
	cmpi.w	#$9,(OptNOP).l
	beq.w	.x
	cmpi.w	#$A,(OptNOP).l
.x	rts
	moveq	#$2,d4
	movea.l	$47D48.l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsPlain).l
	dc.w	$33C4,$0001,$939C
	movea.l	$47D48.l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
	dc.l	$03412567,$89ABCDEF
	rts
	rts
	dc.w	$4E75
L9898	movem.l	d0-d7,-(sp)
	bclr	#$0,$19390.l
	beq.w	.l995C
	bclr	#$6,$19390.l
	bclr	#$7,$19390.l
	jsr	(printz).l
	String	CC_Font1Pal1,$0,$0
	move.w	#$5,(printy).l
	moveq	#$8,d0
	moveq	#$8,d1
	move.w	#$7FF,d2
	btst	#$1,$19390.l
	beq.w	.l9920
	move.w	#$3,(printx).l
	jsr	(eraser).l
	jsr	(printz).l
	String	CC_Font1,$0,$0
	move.w	#$B,(printx).l
	move.w	#$5,(printy).l
	move.w	#$19,d0
	move.w	#$8,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	bra.w	.l995C
.l9920	move.w	#$1C,(printx).l
	jsr	(eraser).l
	jsr	(printz).l
	String	CC_Font1,$0,$0
	move.w	#$3,(printx).l
	move.w	#$5,(printy).l
	move.w	#$19,d0
	move.w	#$8,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
.l995C	movem.l	(sp)+,d0-d7
	rts
DrawHomeBlock						;Draw the home team block: the logo box and the HomeTeam logo (logoteam)
	
	
	
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	L9898
	bset	#$2,$19390.l
	bset	#$6,$19390.l
	bsr.w	L9AE8
	bclr	#$3,$19390.l
	beq.w	.0
	jsr	(printz).l
	String	CC_Font1Pal1,$0,$0
	move.w	#$8,(printx).l
	move.w	#$5,(printy).l
	moveq	#$8,d0
	moveq	#$8,d1
	move.w	#$7FF,d2
.0	jsr	(printz).l
	String	CC_Font1,$0,$0		;x3
	move.w	#$19,(printx).l
	bra.w	DrawTeamLogo
DrawVisBlock						;The same for the visitors: logo box, logo at x 9. setupcardflags bit 3,
	
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	L9898
	bset	#$3,$19390.l
	bset	#$7,$19390.l
	bsr.w	L9B0C
	bclr	#$2,$19390.l
	beq.w	.0
	jsr	(printz).l
	String	CC_Font1Pal1,$0,$0
	move.w	#$18,(printx).l
	move.w	#$5,(printy).l
	moveq	#$8,d0
	moveq	#$8,d1
	move.w	#$7FF,d2
.0	jsr	(printz).l
	String	CC_Font1Pal3,$0,$0
	move.w	#$9,(printx).l
DrawTeamLogo						;Draw the logo of team logoteam at printx, y 6, 6 x 6, palette
	
	
	
	
	move.w	#$B4,$193A2.l
	move.w	#$6,(printy).l
	move.w	(homepicchars).l,d4
	btst	#$2,$19390.l
	bne.w	.l9A4E
	move.w	(vispicchars).l,d4
.l9A4E	dc.w	$3639,$0001,$938A
	asl.w	#$2,d3
	movea.l	(TeamLogoBitmaps).l,a0
	movea.l	(a0,d3.w),a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	asl.w	#$3,d3
	movea.l	#TeamLogoPalettes,a0
	btst	#$2,$19390.l
	beq.w	.1
	subi.w	#$20,d3
	bra.w	.2
.1	subi.w	#$40,d3
.2	adda.w	d3,a0
	adda.l	(a2)+,a1
	move.w	#$6,d3
	move.w	#$6,d2
	clr.w	d0
	clr.w	d1
	move.l	$BBCD2.l,-(sp)
	move.l	$BBCD6.l,-(sp)
	move.w	#$4,d5
	btst	#$2,$19390.l
	beq.w	.draw
	move.w	#$2,d5
.draw	jsr	(dobitmap).l
	move.l	(sp)+,$BBCD6.l
	move.l	(sp)+,$BBCD2.l
	move.w	#$64,(palcount).l		;fade in
	movem.l	(sp)+,d0-d7/a0-a6
	rts
TeamLogoBitmapsEnd						;end of TeamLogoBitmaps (size check below)
	dc.w	$3839,$0001,$9398
	move.w	#$1C,(printx).l
	bra.w	DrawLogoBox
L9AE8	dc.w	$3839,$0001,$9398
	move.w	#$18,(printx).l
	bra.w	DrawLogoBox
Sub_24AFA
	move.w	$1939A.l,d4
	move.w	#$3,(printx).l
	bra.w	DrawLogoBox
L9B0C	move.w	$1939A.l,d4
	move.w	#$8,(printx).l
DrawLogoBox						;Draw the LogoBoxMap box at printx, y 5 (sflags6 bit 0 set). Branched to
	
	clr.w	(printa).l
	move.w	#$5,(printy).l
	movea.l	$47D7C.l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	move.w	#$8,d3
	move.w	#$8,d2
	clr.w	d0
	clr.w	d1
	move.w	#$0,d5
	bset	#$0,(sflags6).l
	jsr	(dobitmap).l
	bclr	#$0,(sflags6).l
	rts
ResetCardTimer						;Reset the player card timer cardtimer to $AA ($53 if C was pressed).
									;Called from ReadSetupPads, PrintOptions and PlayerCardTimer
	move.w	#$AA,$1939E.l		;normal wait
	btst	#$5,$19390.l		;C held (bit 5): use the shorter wait
	beq.w	.l9B7A
	move.w	#$53,$1939E.l		;shorter wait
.l9B7A	rts
PlayerCardTimer						;Player cards, called each frame from ReadSetupPads in the first minute of
									;its wait. When carddelay runs out set setupcardflags bit 0; then count
									;cardtimer down (C skips $50); at $52 switch sides (bit 1), forget the
									;logos and draw the next card (PlayerCardScreen); below 0 restart the
									;timer (ResetCardTimer)
	subi.w	#$1,$193A2.l		;count down the start delay
	bpl.w	.l9C16
	move.w	#$FFFF,$193A2.l		;keep it run out
	bset	#$0,$19390.l		;first run out: the cards may start
	btst	#$0,$19390.l		;cards allowed?
	beq.w	.l9C16
	btst	#$5,$19390.l		;C held?
	beq.w	.l9BC4
	cmpi.w	#$52,$1939E.l		;timer below $52?
	bge.w	.l9BC4
	subi.w	#$50,$1939E.l		;skip $50 of the wait
.l9BC4	subi.w	#$1,$1939E.l
	bmi.w	.l9C18		;timer ran out: start the next cycle
	cmpi.w	#$52,$1939E.l
	bne.w	.l9C16		;only at $52 is a new card drawn
	bclr	#$2,$19390.l		;clear setupcardflags bits 2 and 3
	bclr	#$3,$19390.l
	bchg	#$1,$19390.l		;the next card goes on the other side
	dc.w	$50F9,$0001,$938C
	dc.w	$50F9,$0001,$938E
	bclr	#$6,$19390.l
	bclr	#$7,$19390.l
	jsr	(PlayerCardScreen).l
.l9C16	rts
.l9C18	jmp	(ResetCardTimer).l
