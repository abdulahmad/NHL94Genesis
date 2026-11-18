TeamLogoPalettes					;Team logo palettes, 16 colors per team. Used by PeriodStatsScreen,
									;ClearCardText, DrawMatchupLogo and DrawTeamLogo
									;24 are the matchup logo palettes of TeamPalettes and incbin those files;
									;BOS, FLA, HFD and SJ differ and have their own
		dc.w	$0EEA,$0000,$0042,$0EEA		;ANH, the TeamPalettes matchup logo palette
; Palette data after TeamLogoPalettes: 12 colour words ($0EEA,$0EEE,$0000,$0888 ...).
	dc.w	$0EEA,$0EEE,$0000,$0888
	dc.w	$0AAA,$0068,$008A,$00CE
	dc.w	$0260,$0040,$0664,$0E8E
		dc.w	$0EE8,$008C,$0000,$0A0A		;BOS: differs from MatchupPalBOSA.pal
; Palette data after TeamLogoPalettes: 12 colour words ($0A0A,$0EEE,$0000,$0C8C ...).
	dc.w	$0A0A,$0EEE,$0000,$0C8C
	dc.w	$008C,$0888,$0068,$0846
	dc.w	$0044,$0422,$08CE,$02AE
		dc.w	$0EE8,$0822,$008C,$0EE8		;BUF, the TeamPalettes matchup logo palette
; Palette data after TeamLogoPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0EC8 ...).
	dc.w	$0EE8,$0EEE,$0000,$0EC8
	dc.w	$048C,$0C88,$006C,$0866
	dc.w	$0268,$0224,$0620,$00CE
		dc.w	$0EE8,$0006,$008C,$0EE8		;CGY, the TeamPalettes matchup logo palette
; Palette data after TeamLogoPalettes: 12 colour words ($0EE8,$0EEE,$0000,$08EE ...).
	dc.w	$0EE8,$0EEE,$0000,$08EE
	dc.w	$02CE,$02AE,$026E,$000C
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0000,$0006,$0EE8		;CHI, the TeamPalettes matchup logo palette
; Palette data after TeamLogoPalettes: 12 colour words ($0EE8,$0EEE,$0000,$08EE ...).
	dc.w	$0EE8,$0EEE,$0000,$08EE
	dc.w	$0A8E,$04AC,$0A88,$046C
	dc.w	$0226,$0644,$022E,$0262
		dc.w	$0EE8,$0000,$0042,$0EE8		;DAL, the TeamPalettes matchup logo palette
; Palette data after TeamLogoPalettes: 12 colour words ($0EE8,$0EEE,$0000,$08AA ...).
	dc.w	$0EE8,$0EEE,$0000,$08AA
	dc.w	$0688,$0488,$0466,$0244
	dc.w	$0260,$0020,$0ACC,$0000
		dc.w	$0EE8,$0006,$0006,$0EE8		;DET, the TeamPalettes matchup logo palette
; Palette data after TeamLogoPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0C8E ...).
	dc.w	$0EE8,$0EEE,$0000,$0C8E
	dc.w	$086E,$044E,$082E,$020E
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0600,$004A,$0EE8		;EDM, the TeamPalettes matchup logo palette
; Palette data after TeamLogoPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0CEA ...).
	dc.w	$0EE8,$0EEE,$0000,$0CEA
	dc.w	$0A8E,$08A8,$044E,$0488
	dc.w	$002E,$0440,$0400,$0EE8
		dc.w	$0E0E,$0000,$008C,$0EE8		;FLA: differs from MatchupPalFLAA.pal
; Palette data after TeamLogoPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0E00 ...).
	dc.w	$0EE8,$0EEE,$0000,$0E00
	dc.w	$0400,$0600,$000E,$000A
	dc.w	$0288,$0266,$02AA,$0CCC
		dc.w	$0EE8,$0042,$0822,$0EE8		;HFD: differs from MatchupPalHFDA.pal
; Palette data after TeamLogoPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0020 ...).
	dc.w	$0EE8,$0EEE,$0000,$0020
	dc.w	$0040,$0A8A,$0020,$0466
	dc.w	$0200,$0224,$0888,$0422
		dc.w	$0EE8,$0000,$0000,$0EE8		;LA, the TeamPalettes matchup logo palette
; Palette data after TeamLogoPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0AAA ...).
	dc.w	$0EE8,$0EEE,$0000,$0AAA
	dc.w	$0888,$0666,$0444,$0222
	dc.w	$0CCC,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0600,$0006,$0EE8		;MTL, the TeamPalettes matchup logo palette
; Palette data after TeamLogoPalettes: 12 colour words ($0EE8,$0EEE,$0000,$088E ...).
	dc.w	$0EE8,$0EEE,$0000,$088E
	dc.w	$026E,$0C68,$002E,$0A24
	dc.w	$0EAA,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0020,$0006,$0EE8		;NJ, the TeamPalettes matchup logo palette
; Palette data after TeamLogoPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0AAA ...).
	dc.w	$0EE8,$0EEE,$0000,$0AAA
	dc.w	$000A,$0888,$000C,$0022
	dc.w	$0006,$0CCC,$0EE8,$0EE8
		dc.w	$0EE8,$0822,$004A,$0EE8		;NYI, the TeamPalettes matchup logo palette
; Palette data after TeamLogoPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0AA8 ...).
	dc.w	$0EE8,$0EEE,$0000,$0AA8
	dc.w	$066E,$0864,$022C,$062A
	dc.w	$0008,$0622,$0222,$0A8E
		dc.w	$0EE8,$0600,$0006,$0EE8		;NYR, the TeamPalettes matchup logo palette
; Palette data after TeamLogoPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0AAA ...).
	dc.w	$0EE8,$0EEE,$0000,$0AAA
	dc.w	$0C86,$002E,$0C60,$0844
	dc.w	$0444,$0840,$0008,$0EC8
		dc.w	$0EE8,$0006,$006A,$0EE8		;OTW, the TeamPalettes matchup logo palette
; Palette data after TeamLogoPalettes: 12 colour words ($0EE8,$0EEE,$0000,$068A ...).
	dc.w	$0EE8,$0EEE,$0000,$068A
	dc.w	$0688,$0466,$0244,$022C
	dc.w	$0228,$0008,$0AAA,$0004
		dc.w	$0EE8,$0000,$004A,$0EE8		;PHI, the TeamPalettes matchup logo palette
; Palette data after TeamLogoPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0CCC ...).
	dc.w	$0EE8,$0EEE,$0000,$0CCC
	dc.w	$088E,$0AAA,$046E,$006E
	dc.w	$0888,$0666,$002E,$0444
		dc.w	$0EE8,$0000,$008C,$0EE8		;PIT, the TeamPalettes matchup logo palette
; Palette data after TeamLogoPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0AAA ...).
	dc.w	$0EE8,$0EEE,$0000,$0AAA
	dc.w	$088A,$066A,$04EE,$0464
	dc.w	$0440,$02CE,$0244,$0AEE
		dc.w	$0EE8,$0600,$0006,$0EE8		;QUE, the TeamPalettes matchup logo palette
; Palette data after TeamLogoPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0C00 ...).
	dc.w	$0EE8,$0EEE,$0000,$0C00
	dc.w	$000E,$0E44,$0ECE,$0E80
	dc.w	$088E,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0000,$0822,$0EE8		;SJ: differs from MatchupPalSJA.pal
; Palette data after TeamLogoPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0860 ...).
	dc.w	$0EE8,$0EEE,$0000,$0860
	dc.w	$0642,$0888,$0CA8,$0ACC
	dc.w	$02AE,$006E,$0048,$046A
		dc.w	$0EE8,$0822,$006A,$0EE8		;STL, the TeamPalettes matchup logo palette
; Palette data after TeamLogoPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0602 ...).
	dc.w	$0EE8,$0EEE,$0000,$0602
	dc.w	$024C,$0002,$0026,$0068
	dc.w	$0428,$086E,$0EE8,$0EE8
		dc.w	$0EE8,$0000,$0600,$0EE8		;TB, the TeamPalettes matchup logo palette
; Palette data after TeamLogoPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0C86 ...).
	dc.w	$0EE8,$0EEE,$0000,$0C86
	dc.w	$0E84,$0A84,$0C44,$0822
	dc.w	$0E20,$0600,$0A00,$0EA8
		dc.w	$0EE8,$0600,$0600,$0EE8		;TOR, the TeamPalettes matchup logo palette
; Palette data after TeamLogoPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0ECA ...).
	dc.w	$0EE8,$0EEE,$0000,$0ECA
	dc.w	$0AAA,$0C66,$0822,$0CCC
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0000,$008C,$0EE8		;VAN, the TeamPalettes matchup logo palette
; Palette data after TeamLogoPalettes: 12 colour words ($0EE8,$0EEE,$0000,$00CE ...).
	dc.w	$0EE8,$0EEE,$0000,$00CE
	dc.w	$006A,$004E,$0028,$0022
	dc.w	$0020,$008E,$0888,$06CE
		dc.w	$0EE8,$0006,$0600,$0EE8		;WSH, the TeamPalettes matchup logo palette
; Palette data after TeamLogoPalettes: 12 colour words ($0EE8,$0EEE,$0000,$022C ...).
	dc.w	$0EE8,$0EEE,$0000,$022C
	dc.w	$0C86,$0EA8,$088E,$0842
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0600,$0006,$0EE8		;WPG, the TeamPalettes matchup logo palette
; Palette data after TeamLogoPalettes: 12 colour words ($0EE8,$0EEE,$0000,$022C ...).
	dc.w	$0EE8,$0EEE,$0000,$022C
	dc.w	$0422,$0AAC,$0666,$0CAA
	dc.w	$0444,$066E,$08CE,$0226
		dc.w	$0EE8,$0006,$006A,$0EE8		;ASE, the TeamPalettes matchup logo palette
; Palette data after TeamLogoPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0AAA ...).
	dc.w	$0EE8,$0EEE,$0000,$0AAA
	dc.w	$0888,$0684,$0444,$022C
	dc.w	$0008,$0880,$0660,$0440
		dc.w	$0EE8,$0006,$006A,$0EE8		;ASW, the TeamPalettes matchup logo palette
; Palette data after TeamLogoPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0AAA ...).
	dc.w	$0EE8,$0EEE,$0000,$0AAA
	dc.w	$0888,$0466,$0444,$022C
	dc.w	$0008,$0400,$0800,$0C00
; Compares the goalie of both team structs and updates the swap flags in $17F6C
GoalieSwapCheck	movem.l	d0/a0-a3,-(sp)
	move.w	(sflags2).l,-(sp)
	btst.b	#$1,(gmode2).l
	bne.w	GoalieSwapCheckRestore
	movea.l	#tmstruct,a2
	lea.l	$366(a2),a3
	move.w	$26(a2),d0
	sub.w	$26(a3),d0
	beq.w	GoalieSwapCheckRestore
	bpl.w	.next
	btst.b	#$6,(sflags2).l
	bne.w	.next2
	bsr.w	GoalieSwapCheckEnd
	bset.b	#$6,(sflags2).l
	bra.w	.next2
.next	exg.l	a2,a3
	btst.b	#$6,(sflags2).l
	beq.w	.next2
	bsr.w	GoalieSwapCheckEnd
	bclr.b	#$6,(sflags2).l
.next2	bset.b	#$5,(sflags2).l
	bne.w	GoalieSwapCheckRestore
	cmpa.l	#tmstruct,a3
	bne.w	.next3
	move.w	(HomeTeam).l,(HmTeam).l
	move.w	#$1,(SongIndex).l
	jsr	(ChooseSong).l
.loop	bset.b	#$6,(sflags8).l
	bra.w	GoalieSwapCheckRestore
.next3	move.w	(HomeTeam).l,(HmTeam).l
	move.w	#$4,(SongIndex).l
	jsr	(ChooseSong).l
	bra.w	.loop
; Clears flag 5 of $17F6C, restores the flags and returns
GoalieSwapCheckEnd	bclr.b	#$5,(sflags2).l
	rts
; Restores the flags and registers of GoalieSwapCheck
GoalieSwapCheckRestore	move.w	(sp)+,(sflags2).l
	movem.l	(sp)+,d0/a0-a3
	rts
ClearPenalties						;Clear the penalties: PBnum, Penaltytimer, PenCntDwn, PenBuf and both
									;teams' penalty slots (clrTmPdst). Called from clockcontAssists
	movem.l	d0/a0,-(sp)
	clr.w	(PBnum).l
	clr.w	(Penaltytimer).l
	clr.w	(PenCntDwn).l
	move.w	#$10,d0
	movea.l	#PenBuf,a0
.loop	clr.l	(a0)+
	dbra	d0,.loop
	movea.l	#tmstruct,a0
	bsr.w	clrTmPdst
	movea.l	#awtmstruct,a0
	bsr.w	clrTmPdst
	movem.l	(sp)+,d0/a0
	rts
clrTmPdst						;Put all 26 players of team struct a0 on the bench (tmpdst -2), then the
									;end word -1
	move.w	#$19,d0		;19 = 25 decimal (max roster size)
	adda.w	#$68,a0		;tmpdst
.loop	move.w	#$FFFE,(a0)+		;-2 = bench
	dbra	d0,.loop
	move.w	#$FFFF,(a0)
	rts

HotColdIcon						;The icon by the name of player iconplayer of team a2 at x iconx, y $19:
									;HotMap when he is awayhotplayer /
									;homehotplayer, ColdMap when awaycoldplayer / homecoldplayer, else
									;clear it (eraser)
	movem.l	d0/a0-a1,-(sp)
	movea.l	#awayhotplayer,a0
	move.w	#$2,(iconx).l
	cmpa.l	#tmstruct,a2		;home team?
	bne.w	.0
	movea.l	#homehotplayer,a0
	move.w	#$20,(iconx).l		;home: the home lists and column $20
.0	move.w	#$0,d0
.loop	move.w	(a0)+,d1		;1 hot player per team
	cmp.w	(iconplayer).l,d1
	beq.w	.hot
	dbra	d0,.loop
	movea.l	#awaycoldplayer,a0
	cmpa.l	#tmstruct,a2
	bne.w	.1
	movea.l	#homecoldplayer,a0
.1	move.w	#$0,d0
.loop2	move.w	(a0)+,d1
	cmp.w	(iconplayer).l,d1
	beq.w	.cold
	dbra	d0,.loop2
	move.w	(iconx).l,(printx).l
	move.w	#$19,(printy).l
	move.w	#$8,d0
	move.w	#$3,d1
	move.w	#$7FF,d2		;blank char
	jsr	(eraser).l
	bra.w	.x
.hot	move.w	(hoticonchars).l,d4
	movea.l	(HotMap).l,a0
	bra.w	.draw
.cold	move.w	(coldiconchars).l,d4
	movea.l	(ColdMap).l,a0
.draw	move.w	(iconx).l,(printx).l
	move.w	#$19,(printy).l
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1		;a1 = map data
	movea.l	#$1B008,a2
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	mapheight(a1),d3
	moveq	#$0,d5		;no palette lines
	jsr	(dobitmap).l
.x	movem.l	(sp)+,d0/a0-a1
	rts
; Hot/cold icon: draws the icon at the puck position.
HotColdIconDraw
	btst	#$6,(sflags5).l
	bne.w	HotColdIconExit
	movem.l	d0-d6/a0-a1,-(sp)
	move.w	(puckvx).l,d0
	asr.w	#$8,d0
	add.w	(puckx).l,d0
	move.w	(puckvy).l,d1
	asr.w	#$8,d1
	add.w	(pucky).l,d1
	movem.w	d0-d1,-(sp)
	moveq	#$5,d2
	move.w	d4,d3
	eori.w	#$2,d3
	moveq	#-1,d5
	movea.l	#SortCords,a0
	movea.l	#cont1team,a1
	cmpi.w	#$1,(a1,d4.w)
	beq.w	.next7
	adda.w	#$300,a0
.next7	movea.l	#c1playernum,a1
.loop3	tst.w	$34(a0)
	ble.w	.next10
	btst	#$2,$63(a0)
	bne.w	.next10
	movem.w	d1,-(sp)
	move.w	$52(a0),d1
	cmp.w	(a1,d4.w),d1
	movem.w	(sp)+,d1
	beq.w	.next8
	btst	#$3,$62(a0)
	bne.w	.next10
.next8	btst	#$2,(BA_PS_flags).l
	beq.w	.next9
	movem.l	d0,-(sp)
	move.w	(BA_Sktr_SCnum).l,d0
	cmp.w	$52(a0),d0
	movem.l	(sp)+,d0
	beq.w	.next9
	movem.l	d0,-(sp)
	move.w	(BA_Goalie_SCnum).l,d0
	cmp.w	$52(a0),d0
	movem.l	(sp)+,d0
	bne.w	.next10
.next9	btst	#$5,$62(a0)
	bne.w	.next10
	movem.w	(sp),d0-d1
	sub.w	$0(a0),d0
	muls.w	d0,d0
	sub.w	$14(a0),d1
	muls.w	d1,d1
	add.l	d1,d0
	cmp.l	d5,d0
	bhi.w	.next10
	move.w	$52(a0),d1
	cmp.w	(a1,d3.w),d1
	beq.w	.next10
	move.l	d0,d5
	move.w	d1,d6
.next10	adda.w	#$80,a0
	dbra	d2,.loop3
	adda.w	#$4,sp
	pea.l	$2B5FC.l
	cmp.w	(a1,d4.w),d6
	beq.w	HotColdIconExitSweepcheck
	move.w	d6,d0
	tst.w	d4
	beq.w	HotColdIconExitSetC1
	bra.w	HotColdIconExitSetC2
	movem.l	(sp)+,d0-d6/a0-a1
HotColdIconExit
	rts
; Stub: jumps to Sweepcheck
HotColdIconExitSweepcheck
	jmp	(Sweepcheck).l
; Stub: jumps to setc1player
HotColdIconExitSetC1
	jmp	(setc1player).l
; Stub: jumps to setc2player
HotColdIconExitSetC2
	jmp	(setc2player).l
; Loads the graphics block for the hot/cold icon.
HotColdIconExitSetC2Load
	jsr	(ScoutingReportTextLoad).l
	move.w	#$D,d7
	jsr	$6044.w
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$60,d0
	jsr	$6044.w
	move.l	a0,$47DA0.l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	$47DA0.l,a1
	lea.l	FileLoadOrder.l,a2
	lea.l	FileLoadTable.l,a3
	move.w	#$8,d7
	jsr	$6044.w
	jsr	(ScoutingReportTextLoad).l
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$1,d0
	jsr	$6044.w
	move.l	a0,(ScoutCDArg).l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	(ScoutCDArg).l,a0
	move.l	a0,d0
	move.l	(a0)+,(SmallFontMap).l
	add.l	d0,(SmallFontMap).l
	move.l	(a0)+,$47D18.l
	add.l	d0,$47D18.l
	move.l	(a0)+,$47D40.l
	add.l	d0,$47D40.l
	move.l	(a0)+,$47D2C.l
	add.l	d0,$47D2C.l
	move.l	(a0)+,(BigFontMap).l
	add.l	d0,(BigFontMap).l
	move.l	(a0)+,$47D4C.l
	add.l	d0,$47D4C.l
	move.l	(a0)+,$47D34.l
	add.l	d0,$47D34.l
	move.l	(a0)+,$47D30.l
	add.l	d0,$47D30.l
	move.l	(a0)+,$47D1C.l
	add.l	d0,$47D1C.l
	move.l	(a0)+,$47D20.l
	add.l	d0,$47D20.l
	move.l	(a0)+,$47D44.l
	add.l	d0,$47D44.l
	move.l	(a0)+,(FramerMap).l
	add.l	d0,(FramerMap).l
	move.l	(a0)+,$47D58.l
	add.l	d0,$47D58.l
	move.l	(a0)+,$47D14.l
	add.l	d0,$47D14.l
	move.l	(a0)+,$47D28.l
	add.l	d0,$47D28.l
	move.l	(a0)+,(EASportsBGMap).l
	add.l	d0,(EASportsBGMap).l
	move.l	(a0)+,$47D64.l
	add.l	d0,$47D64.l
	move.l	(a0)+,$47D68.l
	add.l	d0,$47D68.l
	move.l	(a0)+,$47D6C.l
	add.l	d0,$47D6C.l
	move.l	(a0)+,$47D70.l
	add.l	d0,$47D70.l
	move.l	(a0)+,$47D80.l
	add.l	d0,$47D80.l
	move.l	(a0)+,$47D84.l
	add.l	d0,$47D84.l
	move.l	(a0)+,(HotMap).l
	add.l	d0,(HotMap).l
	move.l	(a0)+,(ColdMap).l
	add.l	d0,(ColdMap).l
	move.l	(a0)+,$47DA8.l
	add.l	d0,$47DA8.l
	lea.l	(TeamGfxListEnd).l,a2
	move.w	(HomeTeam).l,d0
	asl.w	#$2,d0
	movea.l	(a2,d0.w),a2
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	a2,d0
	jsr	$6044.w
	move.l	a0,$47D90.l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$2,d0
	jsr	$6044.w
	move.l	a0,$47D24.l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	move.w	#$2,d0
	jsr	$5F22.w
	rts
; Resets the hot/cold icon state and the stat counters.
HotColdIconExitReset
	move.w	#$2,d0
	jsr	$5F22.w
	bclr	#$5,$FF800F.l
	st.b	(arenaanim).l
	clr.l	(homepresses).l
	clr.l	(awaypresses).l
	clr.l	(homedirpresses).l
	clr.l	(awaydirpresses).l
	clr.w	$191CE.l
	jsr	(ScoutingReportTextLoad).l
	jsr	(SubCmd3DSend).l
	move.l	a6,-(sp)
	movea.l	(DiscDmaListPtr).l,a6
	btst	#$5,$FF800F.l
	beq.s	.next
	move.w	#$1,-(a6)
	bra.s	.next2
.next	move.w	#$0,-(a6)
.next2	bclr	#$5,$FF800F.l
	move.l	a6,(DiscDmaListPtr).l
	movea.l	(sp)+,a6
	jsr	(HotColdIconExitSetC2Load).l
	move.l	a6,-(sp)
	movea.l	(DiscDmaListPtr).l,a6
	tst.w	(a6)+
	beq.s	.next3
	bset	#$5,$FF800F.l
	bra.s	.next4
.next3	bclr	#$5,$FF800F.l
.next4	move.l	a6,(DiscDmaListPtr).l
	movea.l	(sp)+,a6
	jsr	(ClearVramViaSetVram).l
	lea.l	$1746A.l,a0
	move.w	#$10,d0
	jsr	$5F22.w
	move.w	#$2,d0
	jsr	$5F22.w
.loop	move.w	#$80,d0
	jsr	$5F22.w
	bcs.w	.loop
.loop2	move.w	#$81,d0
	jsr	$5F22.w
	move.w	(a0),d2
	andi.w	#$FF00,d2
	cmpi.w	#$0,d2
	bne.b	.loop2
	move.w	#$5,(CdCommandArg).l
	move.w	#$13,d0
	lea.l	(CdCommandArg).l,a0
	jsr	$5F22.w
	jsr	(ReadJoy1).l
	cmpi.b	#$E0,d3
	bne.w	.next5
	move.w	#$3,(Optperlen).l
.next5	clr.b	(gmode).l
	cmpi.w	#$1,(OptPen).l
	bne.w	.next6
	bset	#$5,(gmode).l
.next6	cmpi.w	#$1,(OptPlayMode).l
	ble.w	.next7
	bsr.w	.next9
.next7	jsr	(clearTeamStats).l
	btst	#$0,(gmode2).l
	beq.w	.next8
	move.l	a0,-(sp)
	movea.l	#tmstruct,a0
	jsr	(Create_HotCold_Table).l
	movea.l	#awtmstruct,a0
	jsr	(Create_HotCold_Table).l
	movea.l	(sp)+,a0
.next8	clr.w	(ScoreSumbytes).l
	clr.w	(PenSumLength).l
	clr.w	(gsp).l
	clr.w	(ChkCnt).l
	bsr.w	restoreteams
	jsr	(InitScores).l
	jsr	(UpdateSoundVdpSetup).l
	jsr	(LoadCrowdRec).l
	jmp	(PeriodOverIntermission).l
.next9	move.w	#$71,d0
	movea.l	#$18C42,a0
.loop3	clr.w	(a0)+
	dbra	d0,.loop3
	rts