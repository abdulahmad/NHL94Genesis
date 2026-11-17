waitxc1
	tst.w	(palcount).l
	bpl.w	L246D0
	eori.w	#$EE,$BBCF2.l
	move.w	#$18,(palcount).l
L246D0	move.w	(ScoutSubStatus).l,d0
	dc.w	$B079,$0001,$7476
	beq.w	L246D0
	dc.w	$33C0,$0001,$7476
	rts
PlayoffScreen_doscores
	movea.l	#mesarea,a1
	move.w	#$6,(a1)+
	move.w	$4(a2),d0
	addi.w	#$30,d0
	move.b	d0,(a1)+
	move.b	#$2D,(a1)+
	move.w	$6(a2),d0
	addi.w	#$30,d0
	move.b	d0,(a1)+
	clr.b	(a1)+
	movea.l	#mesarea,a1
	bra.w	print
PlayoffScreen_doarrow
	movem.l	d0-d7/a0-a3,-(sp)
	movea.l	$47D50.l,a0
	movea.l	a0,a1
	adda.l	(a0),a0
	adda.l	$4(a1),a1
	movea.l	#$1B008,a2
	clr.w	d1
	moveq	#$2,d2
	moveq	#$17,d3
	dc.w	$3839,$0001,$8D56
	moveq	#$0,d5
	bsr.w	dobitmap
	movem.l	(sp)+,d0-d7/a0-a3
	rts
PlayoffScreen_doteam
	movem.l	d0-d7/a0-a3,-(sp)
	movea.l	#$18AA6,a0
	dc.w	$3039,$0001,$8AA0
	move.b	(a0,d0.w),d0
	add.b	d0,d0
	cmp.b	d0,d1
	bne.w	L2476A
	move.w	#$6000,(printa).l
L2476A	movea.l	$47D44.l,a1
	adda.l	$4(a1),a1
	movea.l	#$1B008,a2
	clr.w	d0
	move.w	(a1),d2
	moveq	#$2,d3
	moveq	#$2,d4
	moveq	#$0,d5
	bsr.w	dobitmap
	movem.l	(sp)+,d0-d7/a0-a3
	rts
VBlank_Playoff
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#$2,(disflags).l
	bne.w	L24826
	dc.w	$207C,$000B,$BD30
	dc.w	$3039,$0001,$7F66
	beq.w	L24820
	dc.w	$4279,$0001,$7F66
	dc.w	$3239,$0001,$8D32
	jsr	$378D2.l
	move.w	$18D30.l,d0
	bsr.w	Sub_38780
	move.w	#$FEA0,d0
	add.w	(scoutcolumn).l,d0
L247D4	btst	#$4,$FF800E.l
	bne.b	L247D4
	move.w	#$31,$FF8026.l
	move.w	d0,$FF8028.l
	bset	#$3,$FF800F.l
L247F4	btst	#$3,$FF800E.l
	beq.b	L247F4
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
L2480E	btst	#$3,$FF800E.l
	bne.b	L2480E
	bclr	#$4,$FF800F.l
L24820	jsr	(Sub_36DF6).l
L24826	addq.w	#$1,(ScoutSubStatus).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.w	$000A,$506C,$6179,$6F66,$6673,$0010,$5175,$6172
	dc.w	$7465,$7266,$696E,$616C,$7300,$000C,$5365,$6D69
	dc.w	$6669,$6E61,$6C73,$0008,$4669,$6E61,$6C73,$000C
	dc.w	$4368,$616D,$7069,$6F6E,$7300
InitScoutingDisplay
	move.w	#$FFFF,(VertLineScrolling).l
	move.w	#$FF00,(PlayerScrollCtr).l
	clr.w	(SelectedPlayerIdx).l
	clr.w	(ScoutingReportTimer).l
	movea.l	#TestList,a0
	rts
UpdateScoutingDisplay
	cmpi.w	#$1000,(ScoutingReportTimer).l
	bgt.w	rtss2
	tst.w	(asv).l
	bmi.w	L248B2
	subi.w	#$1,(ScoutingReportTimer).l
	bpl.w	rtss2
L248B2	movea.l	(ScoutingReportText).l,a1
	moveq	#$0,d0
	move.w	(PlayerScrollCtr).l,d0
	cmpi.w	#$FF00,d0
	bne.w	L24906
	clr.w	(scoutcolumn).l
	move.w	(SelectedPlayerIdx).l,d0
	addi.w	#$2,(SelectedPlayerIdx).l
	movea.l	#TestList,a0
	move.w	(a0,d0.w),d0
	bpl.w	L248FC
	move.w	#$7FFF,(ScoutingReportTimer).l
	move.w	#$1E0,(screentimer).l
	rts
L248FC	bsr.w	ScrollDisplayUp
	move.l	(scoutparaoff).l,d0
L24906	lea.l	(a1,d0.l),a2
	move.w	#$A,(ScoutingReportTimer).l
	move.w	(scoutcolumn).l,d0
	cmpi.b	#$5F,(a2)
	beq.w	L24B88
	cmpi.b	#$2B,(a2)
	beq.w	L24B70
	cmpi.b	#$24,(a2)
	beq.w	L24B20
	cmpi.b	#$7B,(a2)
	beq.w	L24B88
	cmpi.b	#$7D,(a2)
	beq.w	L24B7E
	cmpi.b	#$5B,(a2)
	beq.w	L24B4C
	cmpi.b	#$5D,(a2)
	beq.w	L24B42
	cmpi.b	#$3C,(a2)
	beq.w	L24AF8
	cmpi.b	#$3E,(a2)
	beq.w	L24B02
	cmpi.b	#$7C,(a2)
	beq.w	L24B0C
	cmpi.b	#$5C,(a2)
	beq.w	L24B16
	cmpi.b	#$40,(a2)
	beq.w	L24A8A
	cmpi.b	#$23,(a2)
	beq.w	L24A94
	cmpi.b	#$25,(a2)
	beq.w	L24A9E
	cmpi.b	#$3D,(a2)
	beq.w	L24AA8
	cmpi.b	#$2A,(a2)
	beq.w	L24ABC
	cmpi.b	#$5E,(a2)
	beq.w	L24AD0
	cmpi.b	#$3B,(a2)
	beq.w	L24AE4
	move.w	#$FF00,(PlayerScrollCtr).l
	movea.l	#TextBuffer,a0
	clr.w	d1
L249B8	cmpi.b	#$21,(a2)
	bne.w	L249C2
	addq.l	#$3,a2
L249C2	cmpi.b	#$D,(a2)
	beq.w	L24A2A
	addi.w	#$1,d0
L249CE	move.b	(a2),(a0)+
	addi.w	#$1,d1
	cmpi.b	#$2C,(a2)
	beq.w	L249E4
	cmpi.b	#$2E,(a2)
	bne.w	L249EC
L249E4	addi.w	#$28,(ScoutingReportTimer).l
L249EC	cmpi.b	#$20,(a2)+
	bne.w	L249B8
	cmpi.b	#$20,(a2)
	beq.w	L24A00
	bra.w	L24A0E
L24A00	addi.w	#$14,(ScoutingReportTimer).l
	addq.l	#$1,a2
	bra.w	L249CE
L24A0E	subi.w	#$1,d0
	cmpa.l	a2,a1
	ble.w	L24A22
	move.w	#$FF00,(PlayerScrollCtr).l
	dc.w	$6008
L24A22	suba.l	a1,a2
	move.w	a2,(PlayerScrollCtr).l
L24A2A	move.w	d1,(mesarea).l
	addi.w	#$2,(mesarea).l
	btst	#$0,d1
	beq.w	L24A4A
	clr.b	(a0)
	addi.w	#$1,(mesarea).l
L24A4A	movea.l	#mesarea,a1
L24A50	cmpi.w	#$1D,d0
	ble.w	L24A5C
	bsr.w	ScrollDisplayUp
L24A5C	bsr.w	printz
	String	CC_Font1,$9,$4
	move.w	(scoutcolumn).l,d0
	add.w	d0,(printx).l
	move.w	(VertLineScrolling).l,d0
	add.w	d0,(printy).l
	bsr.w	print
	add.w	d1,(scoutcolumn).l
	rts
L24A8A	jsr	(ScoutCrowdRecord).l
	bra.w	L24B92
L24A94	jsr	(PlayedByHome).l
	bra.w	L24B92
L24A9E	jsr	(PlayedByAway).l
	bra.w	L24B92
L24AA8	move.l	a2,-(sp)
	movea.l	#tmstruct,a2
	jsr	(GetTeamNickname).l
	movea.l	(sp)+,a2
	bra.w	L24B92
L24ABC	move.l	a2,-(sp)
	movea.l	#awtmstruct,a2
	jsr	(GetTeamNickname).l
	movea.l	(sp)+,a2
	bra.w	L24B92
L24AD0	move.l	a2,-(sp)
	movea.l	#tmstruct,a2
	jsr	(GetTeamArena).l
	movea.l	(sp)+,a2
	bra.w	L24B92
L24AE4	move.l	a2,-(sp)
	movea.l	#awtmstruct,a2
	jsr	(GetTeamArena).l
	movea.l	(sp)+,a2
	bra.w	L24B92
L24AF8	jsr	(NextHomeHotPlayer).l
	bra.w	L24B56
L24B02	jsr	(NextAwayHotPlayer).l
	bra.w	L24B56
L24B0C	jsr	(NextHomeColdPlayer).l
	bra.w	L24B56
L24B16	jsr	(NextAwayColdPlayer).l
	bra.w	L24B56
L24B20	movea.l	#tmstruct,a1
	tst.w	(awayhotter).l
	beq.w	L24B36
	movea.l	#awtmstruct,a1
L24B36	movea.l	$1E(a1),a1
	adda.w	$4(a1),a1
	bra.w	L24B92
L24B42	movea.l	#awtmstruct,a1
	bra.w	L24B52
L24B4C	movea.l	#tmstruct,a1
L24B52	move.w	$28(a1),d1
L24B56	movea.l	$1E(a1),a1
	adda.w	$0(a1),a1
	bra.w	L24B68
L24B62	adda.w	(a1),a1
	adda.w	#$8,a1
L24B68	dbra	d1,L24B62
	bra.w	L24B92
L24B70	movea.l	(AwayTeamRosterPtr).l,a1
	adda.w	$4(a1),a1
	bra.w	L24B92
L24B7E	movea.l	(AwayTeamRosterPtr).l,a1
	bra.w	L24B8E
L24B88	movea.l	(HomeTeamRosterPtr).l,a1
L24B8E	adda.w	$4(a1),a1
L24B92	addi.w	#$1,(PlayerScrollCtr).l
	add.w	(a1),d0
	subi.w	#$1,d0
	move.w	(a1),d1
	subi.w	#$2,d1
	tst.b	$1(a1,d1.w)
	bne.w	L24A50
	subi.w	#$1,d1
	bra.w	L24A50
ScrollDisplayUp
	clr.w	(scoutcolumn).l
	addi.w	#$1,(VertLineScrolling).l
	cmpi.w	#$7,(VertLineScrolling).l
	blt.w	rtss2
	subi.w	#$1,(VertLineScrolling).l
	movem.l	d0-d3,-(sp)
	moveq	#$7,d3
	move.w	(VmMAP1).l,d1
	addi.w	#$212,d1
L24BE8	moveq	#$3A,d0
	move.w	d1,d2
	addi.w	#$80,d2
	move.w	sr,-(sp)
	move.w	#$2700,sr
	jsr	(DoDMA_nd2).l
	move.w	(sp)+,sr
	move.w	d2,d1
	dbra	d3,L24BE8
	movem.l	(sp)+,d0-d3
	rts
	dc.w	$0000
Sub_3FC0C
	jsr	$37598.l
	tst.w	$3FC0A.l
	dc.w	$6706
	jsr	$376F2.l
L24C20	move.w	#$D,d7
	jsr	$6044.w
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$0,d0
	jsr	$6044.w
	move.l	a0,(ScoutCDArg).l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	move.w	#$3,d7
	jsr	$6044.w
	movea.l	(ScoutCDArg).l,a0
	move.l	a0,d0
	move.l	(a0)+,(ScoutingReportText).l
	add.l	d0,(ScoutingReportText).l
	move.l	(a0)+,(TeamLogoBitmaps).l
	add.l	d0,(TeamLogoBitmaps).l
	move.l	(a0)+,$47D88.l
	add.l	d0,$47D88.l
	move.l	(a0)+,(ScoutSpeechTable).l
	add.l	d0,(ScoutSpeechTable).l
	move.l	(a0)+,(SmallFontMap).l
	add.l	d0,(SmallFontMap).l
	move.l	(a0)+,(HotMap).l
	add.l	d0,(HotMap).l
	move.l	(a0)+,(ColdMap).l
	add.l	d0,(ColdMap).l
	move.l	(a0)+,$47D50.l
	add.l	d0,$47D50.l
	move.l	(a0)+,(BigFontMap).l
	add.l	d0,(BigFontMap).l
	move.l	(a0)+,(FramerMap).l
	add.l	d0,(FramerMap).l
	move.l	(a0)+,(RonBarrMap).l
	add.l	d0,(RonBarrMap).l
	move.l	(a0)+,$47D70.l
	add.l	d0,$47D70.l
	move.l	(a0)+,(EASportsBGMap).l
	add.l	d0,(EASportsBGMap).l
	move.l	(a0)+,$47D08.l
	add.l	d0,$47D08.l
	move.l	(a0)+,$47D78.l
	add.l	d0,$47D78.l
	move.l	(a0)+,$47D44.l
	add.l	d0,$47D44.l
	move.l	(a0)+,$47D7C.l
	add.l	d0,$47D7C.l
	move.l	(a0)+,$47D48.l
	add.l	d0,$47D48.l
	move.l	(a0)+,$47D94.l
	add.l	d0,$47D94.l
	move.l	(a0)+,$47D18.l
	add.l	d0,$47D18.l
	move.l	(a0)+,(ScoutSavedSP).l
	add.l	d0,(ScoutSavedSP).l
	move.l	(a0)+,$47D74.l
	add.l	d0,$47D74.l
	move.l	(a0)+,$47D04.l
	add.l	d0,$47D04.l
	bclr	#$5,$FF800F.l
	jsr	$375F4.l
	jsr	$376D4.l
	st.b	$191CE.l
	moveq	#$0,d0
	tst.w	$3FC0A.l
	dc.w	$6706
	jsr	$37752.l
L24D90	jsr	$21FC8.l
	move.w	#$2,d1
	move.w	#$96,d0
	jsr	$5F22.w
	jsr	$222D6.l
	move.w	#$4,$19364.l
	lea.l	$19364.l,a0
	move.w	#$15,d0
	jsr	$5F22.w
	lea.l	$19364.l,a0
	move.w	#$13,d0
	jsr	$5F22.w
	move.l	#$400,d1
	move.w	#$85,d0
	jsr	$5F22.w
	move.w	#$8400,d1
	move.w	#$85,d0
	jsr	$5F22.w
	rts
EASportsScreen
	move.w	#$1,$3FC0A.l
	bsr.w	Sub_3FC0C
	move.l	#vb2,(VBint).l
	bclr	#$1,(disflags).l
	move.w	#$5,$18D3E.l
	dc.w	$33FC,$A000,$0001,$8D38
	move.w	#$7,(Map2col).l
	move.w	#$C000,(VmMAP1).l
	move.w	#$7,(Map1col).l
	move.w	#$F000,$18D3C.l
	dc.w	$33FC,$F800,$0001,$8D32
	move.w	#$FC00,$18D30.l
	movea.l	#$BBCB0,a0
	moveq	#$1F,d1
L24E4E	clr.l	(a0)+
	dbra	d1,L24E4E
	jsr	$36F72.l
	jsr	$37B74.l
	rts
	dc.w	$4EB9,$0003,$74F0,$0C03,$00E0,$6600,$C192,$08F9
	dc.w	$0005,$00FF,$800F,$23FC,$0003,$DB90,$0001,$8D66
	dc.w	$4EB9,$0004,$7DAC,$4EB9,$0003,$6D0A,$33FC,$0018
	dc.w	$0001,$8D62,$6100,$8EF4,$0012,$F804,$030C,$0143
	dc.w	$6865,$636B,$2053,$6F75,$6E64,$7C14,$3039,$0001
	dc.w	$7474,$B079,$0001,$7474,$6700,$FFF8,$4EB9,$0003
	dc.w	$74F0,$4EB9,$0003,$74BE,$4A01,$6700,$FFE0,$0801
	dc.w	$0007,$6600,$C12A,$0801,$0003,$6700,$0006,$0646
	dc.w	$0001,$0801,$0002,$6700,$0006,$0446,$0001,$0801
	dc.w	$0005,$6700,$0008,$4EB9,$0003,$710C,$3006,$7203
	dc.w	$6100,$9296,$33FC,$0017,$0001,$8D58,$6100,$9070
	dc.w	$6000,$FF9A
UpdatePlayoffLevel
	dc.w	$0C79,$0002,$0001,$8BFA
	blt.w	rtss2
	dc.w	$0C79,$0004,$0001,$8BFA
	beq.w	rtss2
	moveq	#$7,d0
	dc.w	$4A79,$0001,$8BF8
	beq.w	L24F3E
	move.w	#$B,d0
L24F3E	sub.w	(OptNOP).l,d0
	dc.w	$33C0,$0001,$8AA2
	rts
TeamIcons
	movem.l	d0-d7/a0-a2,-(sp)
	dc.w	$0C79,$0004,$0001,$8BFA
	beq.w	L24F66
	dc.w	$4A79,$0001,$8BFA
	bne.w	L24F7A
L24F66	dc.w	$33F9,$0001,$8BFE,$0001,$7FAE
	dc.w	$33F9,$0001,$8C00,$0001,$7FB0
L24F7A	bsr.w	printz
	String	CC_Font1Pri,$7,$1
	move.w	(VisTeam).l,d1
	move.w	d1,d0
	asl.w	#$6,d0
	movea.l	#$25060,a0
	move.l	$26(a0,d0.w),$BBCD6.l
	dc.w	$3839,$0001,$939C
	bsr.w	DrawTeamBitmap
	bsr.w	printz
	String	CC_Font1Pri,$16,$1
	move.w	(HomeTeam).l,d1
	move.w	d1,d0
	asl.w	#$6,d0
	movea.l	#$25060,a0
	move.l	$2(a0,d0.w),$BBCD2.l
	move.w	#$EEE,$BBCDA.l
	move.w	#$2,d4
	bsr.w	DrawTeamBitmap
	bsr.w	setteams
	move.w	#$64,(palcount).l
	movem.l	(sp)+,d0-d7/a0-a2
	rts
DrawTeamBitmap
	clr.w	d0
	asl.w	#$1,d1
	movea.l	$47D48.l,a0
	movea.l	a0,a1
	adda.l	(a0),a0
	adda.l	$4(a1),a1
	movea.l	#$1B008,a2
	move.w	(a1),d2
	moveq	#$2,d3
	moveq	#$0,d5
	bra.w	dobitmap
dotb
	clr.w	d0
	asl.w	#$1,d1
	movea.l	$47D44.l,a0
	movea.l	a0,a1
	adda.l	(a0),a0
	adda.l	$4(a1),a1
	movea.l	#$1B008,a2
	move.w	(a1),d2
	moveq	#$2,d3
	moveq	#$2,d4
	moveq	#$2,d5
	bra.w	dobitmap
ClearRosterName
	bsr.w	L25040
	moveq	#$C,d0
	moveq	#$2,d1
	move.w	#$7FF,d2
	bra.w	eraser
L25040	bsr.w	printz
	String	CC_Font1Pri,$2,$A
	cmpa.l	#$1834C,a2
	bne.w	rtss2
	move.w	#$1A,(printx).l
	rts
PickStartingGoalie
	movem.l	d0/a0,-(sp)
	clr.w	$28(a2)
	bsr.w	FigureJoy
	cmpa.l	#$1834C,a2
	seq.b	d0
	ext.w	d0
	addi.w	#$2,d0
	dc.w	$B079,$0001,$7FA6
	beq.w	L250CA
	dc.w	$B079,$0001,$7FA8
	beq.w	L250CA
	moveq	#$0,d0
	dc.w	$0C79,$0002,$0001,$8A9E
	bgt.w	L250C6
	dc.w	$4A79,$0001,$8C0A
	bne.w	L250C6
	movea.l	#TeamList,a0
	move.w	$0(a2),d0
	asl.w	#$2,d0
	movea.l	(a0,d0.w),a0
	adda.w	$A(a0),a0
	moveq	#$4,d0
	jsr	(UnpackNibbles).l
	jsr	(WeightedRandomSelect).l
L250C6	move.w	d0,$28(a2)
L250CA	movem.l	(sp)+,d0/a0
	rts
	dc.w	$48E7,$FFFE,$0839,$0002,$0001,$8D64,$6600,$0018
	dc.w	$08B9,$0000,$0001,$8D64,$6700,$0006,$6100,$DAC6
	dc.w	$4EB9,$0003,$6DF6,$5279,$0001,$7474,$4CDF,$7FFF
	dc.w	$4E75
DefaultMenus
	dc.w	$50F9,$0001,$8C16
	dc.w	$207C,$0001,$8BFA
	movea.l	#$40120,a1
	move.w	#$8,d0
L25118	move.w	(a1)+,(a0)+
	dbra	d0,L25118
	rts
	dc.w	$0000,$0001,$000B,$000A,$0001,$0000,$0001,$0000
	dc.w	$0001
	movem.l	d0-d7/a0-a3,-(sp)
	dc.w	$267C,$0001,$8C38
	bsr.w	Sub_4057C
	dc.w	$3039,$0001,$8A9E
	dc.w	$8079,$0001,$8A9C
	beq.w	L251BE
	bsr.w	MakeTree
	moveq	#$7,d0
	dc.w	$4A79,$0001,$8BF8
	beq.w	L25164
	move.w	#$B,d0
L25164	dc.w	$4A79,$0001,$8BF8
	bne.w	L25186
	dc.w	$0C79,$0002,$0001,$8AA2
	ble.w	L251B2
	dc.w	$0479,$0002,$0001,$8AA2
	bra.w	L251B2
L25186	dc.w	$0C79,$0001,$0001,$8AA2
	bne.w	L2519E
	dc.w	$33FC,$0003,$0001,$8AA2
	bra.w	L251B2
L2519E	dc.w	$0C79,$0002,$0001,$8AA2
	bne.w	L251B2
	dc.w	$33FC,$0004,$0001,$8AA2
L251B2	dc.w	$9079,$0001,$8AA2
	move.w	d0,(OptNOP).l
L251BE	movem.l	(sp)+,d0-d7/a0-a3
	rts
	moveq	#$20,d0
	jsr	(randomd0).l
L251CC	addi.w	#$1,d0
	andi.w	#$1F,d0
	asl.w	#$4,d0
	movea.l	#$1FFDA,a0
	adda.w	d0,a0
	lsr.w	#$4,d0
	moveq	#$F,d1
	dc.w	$3439,$0001,$8BFE
	cmpi.w	#$19,d2
	bls.w	L251F2
	moveq	#$19,d2
L251F2	cmp.b	(a0)+,d2
	dbeq	d1,L251F2
	bne.w	L251CC
	eori.w	#$F,d1
	dc.w	$33C1,$0001,$8AA0
	dc.w	$33C0,$0001,$8A9A
	dc.w	$4279,$0001,$8A9E
	dc.w	$33FC,$0007,$0001,$8A9C
	dc.w	$0C79,$0002,$0001,$8BFA
	beq.w	MakeTree
	dc.w	$4279,$0001,$8A9C
	moveq	#$7,d0
	movea.l	#$18A18,a0
L25234	clr.w	$4(a0)
	clr.w	$6(a0)
	adda.w	#$10,a0
	dbra	d0,L25234
MakeTree
	movem.l	d0-d4/a0-a3,-(sp)
	dc.w	$3239,$0001,$8A9A
	asl.w	#$4,d1
	movea.l	#$18AA6,a0
	movea.l	#$1FFDA,a1
	adda.w	d1,a1
	move.l	(a1),(a0)
	move.l	$4(a1),$4(a0)
	move.l	$8(a1),$8(a0)
	move.l	$C(a1),$C(a0)
	lea.l	$10(a0),a1
	moveq	#$E,d2
	dc.w	$3039,$0001,$8AA4
L2527E	move.w	d0,d1
	andi.w	#$1,d1
	move.b	(a0,d1.w),(a1)+
	adda.w	#$2,a0
	lsr.w	#$1,d0
	dbra	d2,L2527E
	bsr.w	GetShifter
	tst.w	d1
	bmi.w	L252CE
	movea.l	#$18AA6,a0
	adda.w	d2,a0
	adda.w	d2,a0
	movea.l	#$18A18,a1
L252AC	clr.w	$A(a1)
	clr.w	$C(a1)
	clr.w	$8(a1)
	bclr	#$1,$E(a1)
	bsr.w	L252D4
	adda.w	#$10,a1
	dbra	d1,L252AC
	bsr.w	FigureJoy
L252CE	movem.l	(sp)+,d0-d4/a0-a3
	rts
L252D4	dc.w	$0C79,$0002,$0001,$8A9C
	beq.w	L25308
	dc.w	$0C79,$0003,$0001,$8A9C
	beq.w	L25308
	dc.w	$0C79,$0005,$0001,$8A9C
	beq.w	L25308
	bset	#$0,$E(a1)
	move.b	(a0)+,$3(a1)
	move.b	(a0)+,$1(a1)
	rts
L25308	bclr	#$0,$E(a1)
	move.b	(a0)+,$1(a1)
	move.b	(a0)+,$3(a1)
	rts
FigureJoy
	movem.l	d0-d3/a0-a1,-(sp)
	dc.w	$4279,$0001,$7FA6
	dc.w	$4279,$0001,$7FA8
	dc.w	$4279,$0001,$7FAA
	dc.w	$4279,$0001,$7FAC
	dc.w	$4A79,$0001,$8C16
	beq.w	Sub_4050C
	dc.w	$4A79,$0001,$8BFA
	beq.w	Sub_404B6
	btst	#$0,$17F78.l
	bne.w	Sub_404B6
	bsr.w	GetShifter
	movea.l	#$18AA6,a0
	dc.w	$3439,$0001,$8AA0
	move.b	(a0,d2.w),d2
	movea.l	#$18A18,a1
	moveq	#$10,d4
	mulu.w	d1,d4
	adda.w	d4,a1
	dc.w	$50F9,$0001,$8A98
	clr.w	d0
L2537C	cmp.w	$0(a1),d2
	beq.w	L253BC
	cmp.w	$2(a1),d2
	beq.w	L25398
	suba.w	#$10,a1
	dbra	d1,L2537C
	bra.w	Sub_40510
L25398	moveq	#$4,d0
	dc.w	$4A79,$0001,$8BF8
	beq.w	L253A8
	move.w	#$5,d0
L253A8	dc.w	$33E9,$0000,$0001,$8C00
	dc.w	$33E9,$0002,$0001,$8BFE
	bra.w	L253CE
L253BC	clr.w	d0
	dc.w	$33E9,$0002,$0001,$8C00
	dc.w	$33E9,$0000,$0001,$8BFE
L253CE	dc.w	$D079,$0001,$8AA2
	dc.w	$33C1,$0001,$8A98
	move.w	$0(a1),(HomeTeam).l
	move.w	$2(a1),(VisTeam).l
	asl.w	#$2,d0
	dc.w	$41FA,$0080
	dc.w	$4A79,$0001,$8BF8
	beq.w	L253FE
	dc.w	$41FA,$0092
L253FE	dc.w	$33F0,$0000,$0001,$7FA6
	dc.w	$33F0,$0002,$0001,$7FA8
	dc.w	$4A79,$0001,$8BF8
	beq.w	Sub_40510
	cmpi.w	#$4,d0
	beq.w	L2542C
	cmpi.w	#$18,d0
	beq.w	L2542C
	bra.w	L25444
L2542C	dc.w	$33F9,$0001,$7FA6,$0001,$7FAA
	dc.w	$33F9,$0001,$7FA8,$0001,$7FAC
	bra.w	Sub_40510
L25444	cmpi.w	#$8,d0
	beq.w	L25458
	cmpi.w	#$1C,d0
	beq.w	L25458
	bra.w	Sub_40510
L25458	dc.w	$33F9,$0001,$7FA6,$0001,$7FAA
	dc.w	$33FC,$0000,$0001,$7FAC
	bra.w	Sub_40510
	dc.w	$0001,$0000,$0001,$0001,$0001,$0002,$0002,$0001
	dc.w	$0002,$0000,$0002,$0002,$0002,$0001,$0001,$0002
	dc.w	$0001,$0000,$0001,$0002,$0001,$0002,$0001,$0001
	dc.w	$0001,$0002,$0002,$0000,$0002,$0001,$0002,$0001
	dc.w	$0002,$0002,$0002,$0001
Sub_404B6
	move.w	(OptNOP).l,d0
	asl.w	#$2,d0
	dc.w	$41FA,$0056
	dc.w	$33F0,$0000,$0001,$7FA6
	dc.w	$33F0,$0002,$0001,$7FA8
	cmpi.w	#$14,d0
	bne.w	L254F0
	dc.w	$33F9,$0001,$7FA6,$0001,$7FAA
	dc.w	$33FC,$0000,$0001,$7FAC
	bra.w	Sub_4050C
L254F0	cmpi.w	#$18,d0
	bne.w	Sub_4050C
	dc.w	$33F9,$0001,$7FA6,$0001,$7FAA
	dc.w	$33F9,$0001,$7FA8,$0001,$7FAC
Sub_4050C
	bsr.w	Sub_40532
Sub_40510
	movem.l	(sp)+,d0-d3/a0-a1
	rts
InitializeGameStructures
	ori.b	#$0,d0
	ori.b	#$0,d1
	ori.b	#$0,d2
	ori.b	#$1,d1
	ori.b	#$2,d1
	ori.b	#$2,d1
	ori.b	#$2,d1
Sub_40532
	dc.w	$50F9,$0001,$8A98
	clr.l	d3
	move.w	(HomeTeam).l,d1
	bset	d1,d3
	move.w	(VisTeam).l,d1
	bset	d1,d3
	movea.l	#$18A18,a1
	moveq	#$7,d2
L25552	bsr.w	L2556C
	move.w	d0,$0(a1)
	bsr.w	L2556C
	move.w	d0,$2(a1)
	adda.w	#$10,a1
	dbra	d2,L25552
	rts
L2556C	moveq	#$1A,d0
	jsr	(randomd0).l
	bset	d0,d3
	bne.w	L2556C
	rts
Sub_4057C
	moveq	#$4,d0
	lea.l	$A(a3),a0
L25582	move.w	-(a0),-(sp)
	dbra	d0,L25582
	moveq	#$7,d2
	movea.l	#$18A88,a1
L25590	bclr	#$2,$E(a1)
	moveq	#$5,d0
	bsr.w	SuperDiv
	move.w	d0,$6(a1)
	cmpi.w	#$4,d0
	bne.w	L255AE
	bset	#$2,$E(a1)
L255AE	moveq	#$5,d0
	bsr.w	SuperDiv
	move.w	d0,$4(a1)
	cmpi.w	#$4,d0
	bne.w	L255C6
	bset	#$2,$E(a1)
L255C6	suba.w	#$10,a1
	dbra	d2,L25590
	move.w	#$4000,d0
	bsr.w	SuperDiv
	dc.w	$33C0,$0001,$8AA4
	move.w	#$8,d0
	bsr.w	SuperDiv
	dc.w	$33C0,$0001,$8AA2
	dc.w	$4A79,$0001,$8BF8
	beq.w	L25620
	dc.w	$0C79,$0001,$0001,$8AA2
	bne.w	L2560C
	dc.w	$33FC,$0003,$0001,$8AA2
	bra.w	L25620
L2560C	dc.w	$0C79,$0002,$0001,$8AA2
	bne.w	L25620
	dc.w	$33FC,$0004,$0001,$8AA2
L25620	moveq	#$10,d0
	bsr.w	SuperDiv
	dc.w	$33C0,$0001,$8AA0
	moveq	#$4,d0
	bsr.w	SuperDiv
	dc.w	$33C0,$0001,$8A9E
	moveq	#$8,d0
	bsr.w	SuperDiv
	dc.w	$33C0,$0001,$8A9C
	moveq	#$20,d0
	bsr.w	SuperDiv
	dc.w	$33C0,$0001,$8A9A
	moveq	#$4,d0
	lea.l	(a3),a0
L25654	move.w	(sp)+,(a0)+
	dbra	d0,L25654
	rts
