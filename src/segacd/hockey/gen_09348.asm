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
	dc.w	$4EB9,$0003,$7B5A
	dc.w	$4EB9,$0003,$7460
	jsr	$24866.l
	move.w	d4,(framercset).l
	movea.l	$47D78.l,a2
	addq.l	#$8,a2
	dc.w	$4EB9,$0003,$8946
	dc.l	$03567564,$89ABCDEF
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_093E6.bin
ReadSetupPads
	move.l	#$5460,d6
L952A	move.w	(ScoutSubStatus).l,d1
	dc.w	$9279,$0001,$7476
	beq.w	L952A
	dc.w	$33F9,$0001,$7474,$0001,$7476
	bclr	#$5,$19390.l
	jsr	$24894.l
	dc.w	$4EB9,$0003,$74F0
	dc.w	$4EB9,$0003,$74BE
	tst.w	d1
	beq.w	L9584
	btst	#$5,d1
	beq.w	L965E
	btst	#$5,d2
	beq.w	L957C
	move.w	#$53,$1939E.l
L957C	bset	#$5,$19390.l
L9584	jsr	(ReadJoy2).l
	dc.w	$4EB9,$0003,$74BE
	tst.w	d1
	beq.w	L95A6
	btst	#$5,d1
	beq.w	L965E
	bset	#$5,$19390.l
L95A6	dc.w	$4A79,$0001,$8BF8
	beq.w	L95F4
	jsr	$3752C.l
	dc.w	$4EB9,$0003,$74BE
	tst.w	d1
	beq.w	L95D2
	btst	#$5,d1
	beq.w	L965E
	bset	#$5,$19390.l
L95D2	jsr	$3754A.l
	dc.w	$4EB9,$0003,$74BE
	tst.w	d1
	beq.w	L95F4
	btst	#$5,d1
	beq.w	L965E
	bset	#$5,$19390.l
L95F4	btst	#$6,$19390.l
	beq.w	L961A
	btst	#$7,$19390.l
	bne.w	L9634
	dc.w	$33F9,$0001,$938E,$0001,$938A
	bsr.w	DrawVisBlock
L961A	btst	#$7,$19390.l
	beq.w	L9634
	dc.w	$33F9,$0001,$938C,$0001,$938A
	bsr.w	DrawHomeBlock
L9634	cmpi.l	#$4650,d6
	bgt.w	L9654
	btst	#$0,$19390.l
	bne.w	L9654
	dc.w	$4EB9,$0002,$4B5E
	bra.w	L965A
L9654	jsr	(PlayerCardTimer).l
L965A	dbra	d6,L952A
L965E	rts
Sub_24660
	dc.w	$4279,$0001,$8C16
L9666	btst	#$7,$FF800E.l
	bne.b	L9666
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
L9680	btst	#$6,$FF800E.l
	beq.b	L9680
	move.w	$FF8010.l,$18C18.l
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L96A4	btst	#$6,$FF800E.l
	bne.b	L96A4
	bclr	#$7,$FF800F.l
L96B6	btst	#$7,$FF800E.l
	bne.b	L96B6
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
L96D0	btst	#$6,$FF800E.l
	beq.b	L96D0
	move.w	$FF8010.l,$18C1A.l
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L96F4	btst	#$6,$FF800E.l
	bne.b	L96F4
	bclr	#$7,$FF800F.l
	dc.w	$4279,$0001,$8BFA
	clr.w	(OptNOP).l
	dc.w	$4279,$0001,$8C0A
	dc.w	$33FC,$0001,$0001,$8C08
Sub_24720
	move.w	$18C04.l,-(sp)
	dc.w	$33D7,$0001,$8C0C
	dc.w	$33DF,$0001,$8C0E
	dc.w	$4EB9,$0003,$FF16
L9738	btst	#$7,$FF800E.l
	bne.b	L9738
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
L9752	btst	#$6,$FF800E.l
	beq.b	L9752
	move.w	$FF8010.l,$18C18.l
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L9776	btst	#$6,$FF800E.l
	bne.b	L9776
	bclr	#$7,$FF800F.l
L9788	btst	#$7,$FF800E.l
	bne.b	L9788
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
L97A2	btst	#$6,$FF800E.l
	beq.b	L97A2
	move.w	$FF8010.l,$18C1A.l
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
L97C6	btst	#$6,$FF800E.l
	bne.b	L97C6
	bclr	#$7,$FF800F.l
	dc.w	$33F9,$0001,$8C0A,$0001,$8C22
	dc.w	$0C79,$0002,$0001,$8C0A
	bne.w	L97FC
	dc.w	$4279,$0001,$8C0A
	bset	#$4,$17F7A.l
L97FC	dc.w	$33F9,$0001,$8BFA,$0001,$8C24
	dc.w	$0C79,$0004,$0001,$8BFA
	bne.w	L9828
	dc.w	$33FC,$0000,$0001,$8BFA
	bset	#$0,$17F78.l
	dc.w	$4EB9,$0002,$79DA
L9828	jmp	(MakeTree).l
CheckNOPUnused
	tst.w	(OptNOP).l
	beq.w	L9864
	cmpi.w	#$5,(OptNOP).l
	beq.w	L9864
	cmpi.w	#$6,(OptNOP).l
	beq.w	L9864
	cmpi.w	#$9,(OptNOP).l
	beq.w	L9864
	cmpi.w	#$A,(OptNOP).l
L9864	rts
	moveq	#$2,d4
	movea.l	$47D48.l,a2
	addq.l	#$8,a2
	dc.w	$4EB9,$0003,$8958
	dc.w	$33C4,$0001,$939C
	movea.l	$47D48.l,a2
	addq.l	#$8,a2
	dc.w	$4EB9,$0003,$8946
	dc.l	$03412567,$89ABCDEF
	rts
	rts
	dc.w	$4E75
L9898	movem.l	d0-d7,-(sp)
	bclr	#$0,$19390.l
	beq.w	L995C
	bclr	#$6,$19390.l
	bclr	#$7,$19390.l
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1Pal1,$0,$0
	move.w	#$5,(printy).l
	moveq	#$8,d0
	moveq	#$8,d1
	move.w	#$7FF,d2
	btst	#$1,$19390.l
	beq.w	L9920
	move.w	#$3,(printx).l
	dc.w	$4EB9,$0003,$8C06
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1,$0,$0
	move.w	#$B,(printx).l
	move.w	#$5,(printy).l
	move.w	#$19,d0
	move.w	#$8,d1
	move.w	#$7FF,d2
	dc.w	$4EB9,$0003,$8C06
	bra.w	L995C
L9920	move.w	#$1C,(printx).l
	dc.w	$4EB9,$0003,$8C06
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1,$0,$0
	move.w	#$3,(printx).l
	move.w	#$5,(printy).l
	move.w	#$19,d0
	move.w	#$8,d1
	move.w	#$7FF,d2
	dc.w	$4EB9,$0003,$8C06
L995C	movem.l	(sp)+,d0-d7
	rts
DrawHomeBlock
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	L9898
	bset	#$2,$19390.l
	bset	#$6,$19390.l
	bsr.w	L9AE8
	bclr	#$3,$19390.l
	beq.w	L99AE
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1Pal1,$0,$0
	move.w	#$8,(printx).l
	move.w	#$5,(printy).l
	moveq	#$8,d0
	moveq	#$8,d1
	move.w	#$7FF,d2
L99AE	jsr	(printz).l
	String	CC_Font1,$0,$0
	move.w	#$19,(printx).l
	bra.w	DrawTeamLogo
DrawVisBlock
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	L9898
	bset	#$3,$19390.l
	bset	#$7,$19390.l
	bsr.w	L9B0C
	bclr	#$2,$19390.l
	beq.w	L9A12
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1Pal1,$0,$0
	move.w	#$18,(printx).l
	move.w	#$5,(printy).l
	moveq	#$8,d0
	moveq	#$8,d1
	move.w	#$7FF,d2
L9A12	jsr	(printz).l
	String	CC_Font1Pal3,$0,$0
	move.w	#$9,(printx).l
DrawTeamLogo
	move.w	#$B4,$193A2.l
	move.w	#$6,(printy).l
	move.w	(homepicchars).l,d4
	btst	#$2,$19390.l
	bne.w	L9A4E
	move.w	(vispicchars).l,d4
L9A4E	dc.w	$3639,$0001,$938A
	asl.w	#$2,d3
	movea.l	(TeamLogoBitmaps).l,a0
	movea.l	(a0,d3.w),a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	asl.w	#$3,d3
	movea.l	#TeamLogoPalettes,a0
	btst	#$2,$19390.l
	beq.w	L9A82
	subi.w	#$20,d3
	bra.w	L9A86
L9A82	subi.w	#$40,d3
L9A86	adda.w	d3,a0
	adda.l	(a2)+,a1
	move.w	#$6,d3
	move.w	#$6,d2
	clr.w	d0
	clr.w	d1
	move.l	$BBCD2.l,-(sp)
	move.l	$BBCD6.l,-(sp)
	move.w	#$4,d5
	btst	#$2,$19390.l
	beq.w	L9AB6
	move.w	#$2,d5
L9AB6	jsr	(dobitmap).l
	move.l	(sp)+,$BBCD6.l
	move.l	(sp)+,$BBCD2.l
	move.w	#$64,(palcount).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
TeamLogoBitmapsEnd
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
DrawLogoBox
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
	dc.w	$4EB9,$0003,$87E2
	bclr	#$0,(sflags6).l
	rts
ResetCardTimer
	move.w	#$AA,$1939E.l
	btst	#$5,$19390.l
	beq.w	L9B7A
	move.w	#$53,$1939E.l
L9B7A	rts
PlayerCardTimer
	subi.w	#$1,$193A2.l
	bpl.w	L9C16
	move.w	#$FFFF,$193A2.l
	bset	#$0,$19390.l
	btst	#$0,$19390.l
	beq.w	L9C16
	btst	#$5,$19390.l
	beq.w	L9BC4
	cmpi.w	#$52,$1939E.l
	bge.w	L9BC4
	subi.w	#$50,$1939E.l
L9BC4	subi.w	#$1,$1939E.l
	bmi.w	L9C18
	cmpi.w	#$52,$1939E.l
	bne.w	L9C16
	bclr	#$2,$19390.l
	bclr	#$3,$19390.l
	bchg	#$1,$19390.l
	dc.w	$50F9,$0001,$938C
	dc.w	$50F9,$0001,$938E
	bclr	#$6,$19390.l
	bclr	#$7,$19390.l
	dc.w	$4EB9,$0002,$4C1E
L9C16	rts
L9C18	jmp	(ResetCardTimer).l
