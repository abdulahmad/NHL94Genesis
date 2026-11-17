waitxc1						;Each time palcount runs out, eor the color
									;word at palfadenew+$42 with $EE and restart palcount at $18; then wait
									;for the next vblank
	tst.w	(palcount).l
	bpl.w	.wait		;palcount still counting
	eori.w	#$EE,$BBCF2.l		;blink the color
	move.w	#$18,(palcount).l		;restart the count
.wait	move.w	(ScoutSubStatus).l,d0		;wait until the vblank handler bumps Vcount
	cmp.w	$17476.l,d0
	beq.w	.wait
	move.w	d0,$17476.l
	rts
PlayoffScreen_doscores						;Print best of 7 wins "t-b" for game struct a2 at printx/printy
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
PlayoffScreen_doarrow						;Draw tree arrow d0 from the arrows map (Arrowsmap) at printx/printy
	movem.l	d0-d7/a0-a3,-(sp)
	movea.l	$47D50.l,a0		;a0 = arrows map
	movea.l	a0,a1		;a1 = map header
	adda.l	(a0),a0		;a0 = arrow frames
	adda.l	$4(a1),a1		;a1 = map data
	movea.l	#$1B008,a2
	clr.w	d1
	moveq	#$2,d2
	moveq	#$17,d3
	move.w	$18D56.l,d4
	moveq	#$0,d5
	bsr.w	dobitmap
	movem.l	(sp)+,d0-d7/a0-a3
	rts
PlayoffScreen_doteam						;Draw team block d1 (team*2) from the TeamBlocks map (Teamblocksmap) at
									;printx/printy; the user's team (potreeteam entry of potree) is
									;highlighted (printa $6000)
	movem.l	d0-d7/a0-a3,-(sp)
	movea.l	#$18AA6,a0
	move.w	$18AA0.l,d0
	move.b	(a0,d0.w),d0
	add.b	d0,d0
	cmp.b	d0,d1		;this block?
	bne.w	.nohi
	move.w	#$6000,(printa).l
.nohi	movea.l	$47D44.l,a1		;a1 = map header of the team blocks
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
VBlank_Playoff						;the PlayoffScreen vblank handler (VBint): dma the sprite table, write
									;$FEA0+DispAttribCtr to the hscroll, cramfade. Always Vcount+1,
									;p_music_vblank, rte
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#$2,(disflags).l
	bne.w	.next2
	movea.l	#$BBD30,a0
	move.w	$17F66.l,d0
	beq.w	.next
	clr.w	$17F66.l
	move.w	$18D32.l,d1
	jsr	$378D2.l
	move.w	$18D30.l,d0
	bsr.w	SetVramWriteAddr2
	move.w	#$FEA0,d0
	add.w	(scoutcolumn).l,d0
.loop	btst	#$4,$FF800E.l		;graphics not allowed?
	bne.b	.loop
	move.w	#$31,$FF8026.l		;sprite attribute table
	move.w	d0,$FF8028.l		;size of the table
	bset	#$3,$FF800F.l
.loop2	btst	#$3,$FF800E.l
	beq.b	.loop2
	bset	#$4,$FF800F.l
	bclr	#$3,$FF800F.l
.loop3	btst	#$3,$FF800E.l
	bne.b	.loop3
	bclr	#$4,$FF800F.l
.next	jsr	(ForceBlackStep).l
.next2	addq.w	#$1,(ScoutSubStatus).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.b	$00,$0A,'Playoffs',$00,$10,'Quar'
	dc.b	'terfinals',$00,$00,$0C,'Semi'
	dc.b	'finals',$00,$08,'Finals',$00,$0C
	dc.b	'Champions',$00
InitScoutingDisplay						;Start the text player UpdateScoutingDisplay: VertLineScrolling = -1,
									;PlayerScrollCtr = -1, clear SelectedPlayerIdx / ScoutingReportTimer;
									;return a0 =
									;TestList. Called from ScoutingReport
	move.w	#$FFFF,(VertLineScrolling).l
	move.w	#$FF00,(PlayerScrollCtr).l
	clr.w	(SelectedPlayerIdx).l		;TestList index
	clr.w	(ScoutingReportTimer).l
	movea.l	#TestList,a0
	rts
UpdateScoutingDisplay						;Text player for ScoutingReport: prints the ScoutingReportText script
									;word by word with a typing delay (ScoutingReportTimer, longer)
									;after , and .). $D ends a line; special characters ( _ + $ { } [ ] < > |
									;\ @ # % = * ^ ; ) insert team data through the team routines
									;(GetTeamNickname / GetTeamArena for tmstruct / awtmstruct). Line breaks
									;scroll the text box. Called from ScoutingReport
	cmpi.w	#$1000,(ScoutingReportTimer).l		;text finished?
	bgt.w	rtss2		;yes: nothing to do
	tst.w	(asv).l		;button held?
	bmi.w	.0
	subi.w	#$1,(ScoutingReportTimer).l		;count down the delay
	bpl.w	rtss2
.0	movea.l	(ScoutingReportText).l,a1
	moveq	#$0,d0
	move.w	(PlayerScrollCtr).l,d0
	cmpi.w	#$FF00,d0
	bne.w	.3
	clr.w	(scoutcolumn).l
	move.w	(SelectedPlayerIdx).l,d0		;TestList index
	addi.w	#$2,(SelectedPlayerIdx).l
	movea.l	#TestList,a0
	move.w	(a0,d0.w),d0		;this paragraph number
	bpl.w	.1		;not the end of the list
	move.w	#$7FFF,(ScoutingReportTimer).l		;text finished
	move.w	#$1E0,(screentimer).l		;and leave the screen in 480 frames
	rts
.1	bsr.w	ScrollDisplayUp
	move.l	(scoutparaoff).l,d0		;d0 = paragraph offset
.3	lea.l	(a1,d0.l),a2		;a2 = next character
	move.w	#$A,(ScoutingReportTimer).l		;typing delay
	move.w	(scoutcolumn).l,d0
	cmpi.b	#$5F,(a2)
	beq.w	.29
	cmpi.b	#$2B,(a2)
	beq.w	.27
	cmpi.b	#$24,(a2)
	beq.w	.20		;the hotter team's name
	cmpi.b	#$7B,(a2)		;'{' home team name
	beq.w	.29
	cmpi.b	#$7D,(a2)		;'}' away team name
	beq.w	.28
	cmpi.b	#$5B,(a2)		;'[' home player name
	beq.w	.23
	cmpi.b	#$5D,(a2)		;']' away player name
	beq.w	.22
	cmpi.b	#$3C,(a2)
	beq.w	.16		;next home hot player
	cmpi.b	#$3E,(a2)
	beq.w	.17		;next away hot player
	cmpi.b	#$7C,(a2)
	beq.w	.18		;next home cold player
	cmpi.b	#$5C,(a2)
	beq.w	.19		;next away cold player
	cmpi.b	#$40,(a2)
	beq.w	.9		;crowd record
	cmpi.b	#$23,(a2)
	beq.w	.10
	cmpi.b	#$25,(a2)
	beq.w	.11
	cmpi.b	#$3D,(a2)
	beq.w	.12
	cmpi.b	#$2A,(a2)
	beq.w	.13
	cmpi.b	#$5E,(a2)
	beq.w	.14
	cmpi.b	#$3B,(a2)
	beq.w	.15
	move.w	#$FF00,(PlayerScrollCtr).l
	movea.l	#TextBuffer,a0
	clr.w	d1
.loop	cmpi.b	#$21,(a2)
	bne.w	.next
	addq.l	#$3,a2
.next	cmpi.b	#$D,(a2)		;end of line?
	beq.w	.print		;yes: print what we have
	addi.w	#$1,d0
.loop2	move.b	(a2),(a0)+
	addi.w	#$1,d1
	cmpi.b	#$2C,(a2)
	beq.w	.4
	cmpi.b	#$2E,(a2)
	bne.w	.5
.4	addi.w	#$28,(ScoutingReportTimer).l		;longer delay
.5	cmpi.b	#$20,(a2)+		;space ends the word
	bne.w	.loop		;not a space: next character
	cmpi.b	#$20,(a2)		;more spaces?
	beq.w	.next2		;copy them too
	bra.w	.next3
.next2	addi.w	#$14,(ScoutingReportTimer).l
	addq.l	#$1,a2
	bra.w	.loop2
.next3	subi.w	#$1,d0
	cmpa.l	a2,a1
	ble.w	.next4
	move.w	#$FF00,(PlayerScrollCtr).l
	bra.s	.print
.next4	suba.l	a1,a2		;offset into the script
	move.w	a2,(PlayerScrollCtr).l		;offset of the next word
.print	move.w	d1,(mesarea).l
	addi.w	#$2,(mesarea).l		;plus the length word
	btst	#$0,d1		;odd length?
	beq.w	.7
	clr.b	(a0)
	addi.w	#$1,(mesarea).l		;count the pad
.7	movea.l	#mesarea,a1
.loop3	cmpi.w	#$1D,d0		;past column 29?
	ble.w	.8
	bsr.w	ScrollDisplayUp		;wrap to a new line
.8	bsr.w	printz		;map 1 at 9,4
	String	CC_Font1,$9,$4
	move.w	(scoutcolumn).l,d0
	add.w	d0,(printx).l		;x 9 + column
	move.w	(VertLineScrolling).l,d0
	add.w	d0,(printy).l		;y 4 + text line
	bsr.w	print
	add.w	d1,(scoutcolumn).l
	rts
.9	jsr	(ScoutCrowdRecord).l
	bra.w	.append
.10	jsr	(PlayedByHome).l
	bra.w	.append
.11	jsr	(PlayedByAway).l
	bra.w	.append
.12	move.l	a2,-(sp)		;save the script pointer
	movea.l	#tmstruct,a2
	jsr	(GetTeamNickname).l
	movea.l	(sp)+,a2
	bra.w	.append
.13	move.l	a2,-(sp)
	movea.l	#awtmstruct,a2
	jsr	(GetTeamNickname).l
	movea.l	(sp)+,a2
	bra.w	.append
.14	move.l	a2,-(sp)
	movea.l	#tmstruct,a2
	jsr	(GetTeamArena).l
	movea.l	(sp)+,a2
	bra.w	.append
.15	move.l	a2,-(sp)
	movea.l	#awtmstruct,a2
	jsr	(GetTeamArena).l
	movea.l	(sp)+,a2
	bra.w	.append
.16	jsr	(NextHomeHotPlayer).l
	bra.w	.roster		;player d1 of team a1
.17	jsr	(NextAwayHotPlayer).l
	bra.w	.roster		;player d1 of team a1
.18	jsr	(NextHomeColdPlayer).l
	bra.w	.roster		;player d1 of team a1
.19	jsr	(NextAwayColdPlayer).l
	bra.w	.roster		;player d1 of team a1
.20	movea.l	#tmstruct,a1
	tst.w	(awayhotter).l		;away team hotter?
	beq.w	.21
	movea.l	#awtmstruct,a1
.21	movea.l	$1E(a1),a1
	adda.w	$4(a1),a1
	bra.w	.append
.22	movea.l	#awtmstruct,a1
	bra.w	.24
.23	movea.l	#tmstruct,a1
.24	move.w	$28(a1),d1
.roster	movea.l	$1E(a1),a1
	adda.w	$0(a1),a1
	bra.w	.next5
.loop4	adda.w	(a1),a1
	adda.w	#$8,a1		;skip the fixed part
.next5	dbra	d1,.loop4
	bra.w	.append		;a1 = player name
.27	movea.l	(AwayTeamRosterPtr).l,a1
	adda.w	$4(a1),a1
	bra.w	.append
.28	movea.l	(AwayTeamRosterPtr).l,a1
	bra.w	.30
.29	movea.l	(HomeTeamRosterPtr).l,a1
.30	adda.w	$4(a1),a1
.append	addi.w	#$1,(PlayerScrollCtr).l		;go on after the special character
	add.w	(a1),d0		;column + string length - 1
	subi.w	#$1,d0
	move.w	(a1),d1
	subi.w	#$2,d1
	tst.b	$1(a1,d1.w)		;pad byte?
	bne.w	.loop3
	subi.w	#$1,d1		;less the pad byte
	bra.w	.loop3		;print it
ScrollDisplayUp						;Next text line for UpdateScoutingDisplay: VertLineScrolling + 1; at 7
									;lines, scroll the 8 rows up by vram dma (DoDMA_nd2)
	clr.w	(scoutcolumn).l
	addi.w	#$1,(VertLineScrolling).l
	cmpi.w	#$7,(VertLineScrolling).l		;past the box?
	blt.w	rtss2
	subi.w	#$1,(VertLineScrolling).l		;stay on the last line
	movem.l	d0-d3,-(sp)
	moveq	#$7,d3
	move.w	(VmMAP1).l,d1
	addi.w	#$212,d1
.loop	moveq	#$3A,d0
	move.w	d1,d2
	addi.w	#$80,d2		;text box top left
	move.w	sr,-(sp)		;copy 8 rows of the text box up by one row
	move.w	#$2700,sr
	jsr	(DoDMA_nd2).l
	move.w	(sp)+,sr
	move.w	d2,d1
	dbra	d3,.loop
	movem.l	(sp)+,d0-d3
	rts
ScrollDisplayUpTbl1	dc.w	$0000
; Calls the display helpers and the $6044 routine.
ScrollDisplayUpCall
	jsr	$37598.l
	tst.w	ScrollDisplayUpTbl1.l
	beq.s	.next
	jsr	$376F2.l
.next	move.w	#$D,d7
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
	tst.w	ScrollDisplayUpTbl1.l
	beq.s	.next2
	jsr	$37752.l
.next2	jsr	$21FC8.l
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
EASportsScreen						;Called from Begin. Show the EA Sports screen until a button, or $50 x 4
									;frames (about 5 s)
	move.w	#$1,ScrollDisplayUpTbl1.l
	bsr.w	ScrollDisplayUpCall
	move.l	#vb2,(VBint).l
	bclr	#$1,(disflags).l
	move.w	#$5,$18D3E.l
	move.w	#$A000,$18D38.l
	move.w	#$7,(Map2col).l
	move.w	#$C000,(VmMAP1).l
	move.w	#$7,(Map1col).l
	move.w	#$F000,$18D3C.l
	move.w	#$F800,$18D32.l
	move.w	#$FC00,$18D30.l
	movea.l	#$BBCB0,a0
	moveq	#$1F,d1		;32 longs: all 64 colours black
.clr	clr.l	(a0)+
	dbra	d1,.clr
	jsr	$36F72.l
	jsr	$37B74.l
	rts
	dc.w	$4EB9,$0003,$74F0,$0C03,$00E0,$6600,$C192,$08F9
	dc.w	$0005,$00FF,$800F,$23FC,$0003,$DB90,$0001,$8D66
	dc.w	$4EB9,$0004,$7DAC,$4EB9,$0003,$6D0A,$33FC,$0018
	dc.w	$0001,$8D62,$6100,$8EF4,$0012,$F804,$030C,$0143
	dc.b	'heck Sound|',$14,'09',$00,$01
	dc.w	$7474,$B079,$0001,$7474,$6700,$FFF8,$4EB9,$0003
	dc.w	$74F0,$4EB9,$0003,$74BE,$4A01,$6700,$FFE0,$0801
	dc.w	$0007,$6600,$C12A,$0801,$0003,$6700,$0006,$0646
	dc.w	$0001,$0801,$0002,$6700,$0006,$0446,$0001,$0801
	dc.w	$0005,$6700,$0008,$4EB9,$0003,$710C,$3006,$7203
	dc.w	$6100,$9296,$33FC,$0017,$0001,$8D58,$6100,$9070
	dc.w	$6000,$FF9A
UpdatePlayoffLevel						;Set pojoy from the number of players for play modes 2 and 3.
	cmpi.w	#$2,$18BFA.l
	blt.w	rtss2
	cmpi.w	#$4,$18BFA.l
	beq.w	rtss2
	moveq	#$7,d0
	tst.w	$18BF8.l
	beq.w	.set
	move.w	#$B,d0		;4 way play
.set	sub.w	(OptNOP).l,d0		;pojoy = pad layouts minus the player count option
	move.w	d0,$18AA2.l
	rts
TeamIcons						;draw the visitor and home team bitmaps and set colors.
									;Called from PrintOptions. 92 TeamIcons drew name bars (dotb)
	movem.l	d0-d7/a0-a2,-(sp)
	cmpi.w	#$4,$18BFA.l
	beq.w	.next
	tst.w	$18BFA.l
	bne.w	.draw
.next	move.w	$18BFE.l,(HomeTeam).l
	move.w	$18C00.l,(VisTeam).l
.draw	bsr.w	printz		;teams set: print them
	String	CC_Font1Pri,$7,$1
	move.w	(VisTeam).l,d1
	move.w	d1,d0
	asl.w	#$6,d0		;64 bytes per team
	movea.l	#TeamPalettes,a0
	move.l	$26(a0,d0.w),$BBCD6.l		;B palette colors into palette 1
	move.w	$1939C.l,d4
	bsr.w	DrawTeamBitmap
	bsr.w	printz
	String	CC_Font1Pri,$16,$1
	move.w	(HomeTeam).l,d1
	move.w	d1,d0
	asl.w	#$6,d0		;64 bytes per team
	movea.l	#TeamPalettes,a0
	move.l	$2(a0,d0.w),$BBCD2.l		;A palette colors into palette 1
	move.w	#$EEE,$BBCDA.l		;colour 5 white
	move.w	#$2,d4		;first bitmap char
	bsr.w	DrawTeamBitmap		;draw the home team
	bsr.w	setteams		;set up the team structs
	move.w	#$64,(palcount).l		;fade over $64 frames
	movem.l	(sp)+,d0-d7/a0-a2
	rts
DrawTeamBitmap						;dobitmap entry d1 of TeamBitmaps (d4 from the caller)
	clr.w	d0
	asl.w	#$1,d1
	movea.l	$47D48.l,a0
	movea.l	a0,a1		;a1 = map header
	adda.l	(a0),a0		;a0 = tile data
	adda.l	$4(a1),a1		;a1 = map data
	movea.l	#$1B008,a2
	move.w	(a1),d2
	moveq	#$2,d3
	moveq	#$0,d5
	bra.w	dobitmap
dotb						;unreferenced. Like DrawTeamBitmap with Teamblocksmap, d4 = 2, d5 = 2
	clr.w	d0
	asl.w	#$1,d1
	movea.l	$47D44.l,a0
	movea.l	a0,a1		;a1 = map header
	adda.l	(a0),a0		;a0 = tile data
	adda.l	$4(a1),a1		;a1 = map data
	movea.l	#$1B008,a2		;tile data: word 0 at $310 = no tiles
	move.w	(a1),d2
	moveq	#$2,d3
	moveq	#$2,d4
	moveq	#$2,d5		;color fam 2
	bra.w	dobitmap
ClearRosterName						;unreferenced. Set the print position, then erase 12 x 2 at it
	bsr.w	.next
	moveq	#$C,d0
	moveq	#$2,d1
	move.w	#$7FF,d2		;blank char
	bra.w	eraser
.next	bsr.w	printz
	String	CC_Font1Pri,$2,$A
	cmpa.l	#$1834C,a2
	bne.w	rtss2
	move.w	#$1A,(printx).l
	rts
PickStartingGoalie						;unreferenced. tmgoalie = 0 if a pad has team a2, else (gamelevel <= 2,
									;line changes on) a value from the team's .godds
	movem.l	d0/a0,-(sp)
	clr.w	$28(a2)
	bsr.w	FigureJoy		;sets cont1team / cont2team
	cmpa.l	#$1834C,a2
	seq.b	d0		;home: d0 = -1
	ext.w	d0
	addi.w	#$2,d0		;1 for the home team, 2 for the away team
	cmp.w	$17FA6.l,d0
	beq.w	.x
	cmp.w	$17FA8.l,d0
	beq.w	.x
	moveq	#$0,d0
	cmpi.w	#$2,$18A9E.l
	bgt.w	.set
	tst.w	$18C0A.l
	bne.w	.set		;line changes off
	movea.l	#TeamList,a0
	move.w	$0(a2),d0
	asl.w	#$2,d0
	movea.l	(a0,d0.w),a0		;team block
	adda.w	$A(a0),a0		;GoalieOdds offset: a0 = .godds
	moveq	#$4,d0		;4 goalie weights
	jsr	(UnpackNibbles).l
	jsr	(WeightedRandomSelect).l
.set	move.w	d0,$28(a2)		;store the pick (0 = first goalie)
.x	movem.l	(sp)+,d0/a0
	rts
PickStartingGoalieTbl1	dc.w	$48E7,$FFFE,$0839,$0002,$0001,$8D64,$6600,$0018
	dc.w	$08B9,$0000,$0001,$8D64,$6700,$0006,$6100,$DAC6
	dc.w	$4EB9,$0003,$6DF6,$5279,$0001,$7474,$4CDF,$7FFF
	rts
DefaultMenus						;Set the default menu choices for the beginning of the game: the 9 option
									;words from defmenuoptions (93 had 7). Called once from Begin
	st.b	$18C16.l
	movea.l	#$18BFA,a0
	movea.l	#$40120,a1		;Start of Menu Options in RAM
	move.w	#$8,d0
.loop	move.w	(a1)+,(a0)+		;9 options
	dbra	d0,.loop
	rts
DefaultMenusTbl1	dc.w	$0000,$0001,$000B,$000A,$0001,$0000,$0001,$0000
	dc.w	$0001
	movem.l	d0-d7/a0-a3,-(sp)
	movea.l	#$18C38,a3
	bsr.w	InitPlayerSlots
	move.w	$18A9E.l,d0
	or.w	$18A9C.l,d0
	beq.w	.next5
	bsr.w	MakeTree
	moveq	#$7,d0
	tst.w	$18BF8.l
	beq.w	.next
	move.w	#$B,d0
.next	tst.w	$18BF8.l
	bne.w	.next2
	cmpi.w	#$2,$18AA2.l
	ble.w	.next4
	subi.w	#$2,$18AA2.l
	bra.w	.next4
.next2	cmpi.w	#$1,$18AA2.l
	bne.w	.next3
	move.w	#$3,$18AA2.l
	bra.w	.next4
.next3	cmpi.w	#$2,$18AA2.l
	bne.w	.next4
	move.w	#$4,$18AA2.l
.next4	sub.w	$18AA2.l,d0
	move.w	d0,(OptNOP).l
.next5	movem.l	(sp)+,d0-d7/a0-a3
	rts
	moveq	#$20,d0
	jsr	(randomd0).l
.loop	addi.w	#$1,d0
	andi.w	#$1F,d0
	asl.w	#$4,d0
	movea.l	#$1FFDA,a0
	adda.w	d0,a0
	lsr.w	#$4,d0
	moveq	#$F,d1
	move.w	$18BFE.l,d2
	cmpi.w	#$19,d2
	bls.w	.loop2
	moveq	#$19,d2
.loop2	cmp.b	(a0)+,d2
	dbeq	d1,.loop2
	bne.w	.loop
	eori.w	#$F,d1
	move.w	d1,$18AA0.l
	move.w	d0,$18A9A.l
	clr.w	$18A9E.l
	move.w	#$7,$18A9C.l
	cmpi.w	#$2,$18BFA.l
	beq.w	MakeTree
	clr.w	$18A9C.l
	moveq	#$7,d0
	movea.l	#$18A18,a0
.loop3	clr.w	$4(a0)
	clr.w	$6(a0)
	adda.w	#$10,a0
	dbra	d0,.loop3
MakeTree						;Make the playoff tree (potree) from playoffseats and WinBits, clear the
									;scores of this round's games and set their teams
									;(.sett), then FigureJoy. Called from ContinuePlayoffs and EncodePW; falls
									;in from NewPO
	movem.l	d0-d4/a0-a3,-(sp)
	move.w	$18A9A.l,d1
	asl.w	#$4,d1		;16 bytes a tree
	movea.l	#$18AA6,a0
	movea.l	#$1FFDA,a1
	adda.w	d1,a1
	move.l	(a1),(a0)		;first round: 16 teams from the tree
	move.l	$4(a1),$4(a0)
	move.l	$8(a1),$8(a0)
	move.l	$C(a1),$C(a0)
	lea.l	$10(a0),a1		;a1 = next round
	moveq	#$E,d2		;15 winners
	move.w	$18AA4.l,d0
.0	move.w	d0,d1		;d1 = lowest WinBits bit: pick the pair member
	andi.w	#$1,d1		;winbit picks the top or bottom team of the pair
	move.b	(a0,d1.w),(a1)+		;winner
	adda.w	#$2,a0		;next pair
	lsr.w	#$1,d0		;next winner bit
	dbra	d2,.0
	bsr.w	GetShifter		;d1 = games, d2 = first
	tst.w	d1		;any games left?
	bmi.w	.nogames		;playoffs over
	movea.l	#$18AA6,a0
	adda.w	d2,a0
	adda.w	d2,a0		;(2 bytes a game)
	movea.l	#$18A18,a1
.loop	clr.w	$A(a1)		;gstruct: gss1
	clr.w	$C(a1)
	clr.w	$8(a1)
	bclr	#$1,$E(a1)		;hilite requested
	bsr.w	.next
	adda.w	#$10,a1
	dbra	d1,.loop
	bsr.w	FigureJoy		;assign the pads
.nogames	movem.l	(sp)+,d0-d4/a0-a3
	rts
.next	cmpi.w	#$2,$18A9C.l
	beq.w	.1
	cmpi.w	#$3,$18A9C.l
	beq.w	.1
	cmpi.w	#$5,$18A9C.l
	beq.w	.1		;tree order
	bset	#$0,$E(a1)		;teams are flipped
	move.b	(a0)+,$3(a1)
	move.b	(a0)+,$1(a1)
	rts
.1	bclr	#$0,$E(a1)		;gsftf: teams not flipped
	move.b	(a0)+,$1(a1)
	move.b	(a0)+,$3(a1)
	rts
FigureJoy						;Set contteams appropriately: cont1team ... cont4team (3 and 4 for
									;FourWayPlay). In the playoffs (not Shootout, gmode2 bit 0) find this
									;round's game of the po team and set the teams and pads from .pojoylist
									;(.pojoylist2 with FourWayPlay); otherwise from .noplist by OptNOP.
									;After a demo (demoflag clear), and outside the playoffs, fill gstruct
									;with random matchups (InitializeGameStructures). Called from MakeTree and
									;GameSetUp
	movem.l	d0-d3/a0-a1,-(sp)
	clr.w	$17FA6.l
	clr.w	$17FA8.l
	clr.w	$17FAA.l
	clr.w	$17FAC.l
	tst.w	$18C16.l
	beq.w	.next12
	tst.w	$18BFA.l
	beq.w	.next10		;regular season
	btst	#$0,$17F78.l
	bne.w	.next10
	bsr.w	GetShifter		;d1 = last game
	movea.l	#$18AA6,a0
	move.w	$18AA0.l,d2
	move.b	(a0,d2.w),d2
	movea.l	#$18A18,a1
	moveq	#$10,d4
	mulu.w	d1,d4		;times the last game
	adda.w	d4,a1		;a1 = last game
	st.b	$18A98.l
	clr.w	d0
.f0	cmp.w	$0(a1),d2		;first team?
	beq.w	.next3
	cmp.w	$2(a1),d2		;second team?
	beq.w	.next
	suba.w	#$10,a1		;previous game
	dbra	d1,.f0
	bra.w	.next13
.next	moveq	#$4,d0
	tst.w	$18BF8.l
	beq.w	.next2
	move.w	#$5,d0
.next2	move.w	$0(a1),$18C00.l
	move.w	$2(a1),$18BFE.l
	bra.w	.next4
.next3	clr.w	d0
	move.w	$2(a1),$18C00.l
	move.w	$0(a1),$18BFE.l
.next4	add.w	$18AA2.l,d0
	move.w	d1,$18A98.l
	move.w	$0(a1),(HomeTeam).l
	move.w	$2(a1),(VisTeam).l
	asl.w	#$2,d0		;4 bytes an entry
	lea.l	.next8(pc),a0
	tst.w	$18BF8.l
	beq.w	.next5
	lea.l	.next9(pc),a0
.next5	move.w	(a0,d0.w),$17FA6.l
	move.w	$2(a0,d0.w),$17FA8.l
	tst.w	$18BF8.l
	beq.w	.next13
	cmpi.w	#$4,d0		;layout 1?
	beq.w	.next6		;pojoy 1: cont3team / cont4team = cont1team / cont2team
	cmpi.w	#$18,d0		;layout 6?
	beq.w	.next6
	bra.w	.2
.next6	move.w	$17FA6.l,$17FAA.l
	move.w	$17FA8.l,$17FAC.l
	bra.w	.next13
.2	cmpi.w	#$8,d0		;layout 2?
	beq.w	.next7		;pojoy 2: cont3team = cont1team, cont4team 0
	cmpi.w	#$1C,d0		;layout 7?
	beq.w	.next7
	bra.w	.next13
.next7	move.w	$17FA6.l,$17FAA.l
	move.w	#$0,$17FAC.l
	bra.w	.next13
.next8	dc.w	$0001,$0000,$0001,$0001,$0001,$0002,$0002,$0001
	dc.w	$0002,$0000,$0002,$0002,$0002,$0001,$0001,$0002
.next9	dc.w	$0001,$0000,$0001,$0002,$0001,$0002,$0001,$0001
	dc.w	$0001,$0002,$0002,$0000,$0002,$0001,$0002,$0001
	dc.w	$0002,$0002,$0002,$0001
.next10
	move.w	(OptNOP).l,d0
	asl.w	#$2,d0
	lea.l	InitializeGameStructures(pc),a0
	move.w	(a0,d0.w),$17FA6.l
	move.w	$2(a0,d0.w),$17FA8.l
	cmpi.w	#$14,d0
	bne.w	.next11
	move.w	$17FA6.l,$17FAA.l
	move.w	#$0,$17FAC.l
	bra.w	.next12
.next11	cmpi.w	#$18,d0
	bne.w	.next12
	move.w	$17FA6.l,$17FAA.l
	move.w	$17FA8.l,$17FAC.l
.next12
	bsr.w	InitTeamMask
.next13
	movem.l	(sp)+,d0-d3/a0-a1
	rts
InitializeGameStructures						;Random team pairs for all 8 gstruct games, none of them HomeTeam or
									;VisTeam. Called from FigureJoy
	ori.b	#$0,d0
	ori.b	#$0,d1
	ori.b	#$0,d2
	ori.b	#$1,d1
	ori.b	#$2,d1
	ori.b	#$2,d1
	ori.b	#$2,d1
; Builds the mask of the two playing teams.
InitTeamMask
	st.b	$18A98.l
	clr.l	d3
	move.w	(HomeTeam).l,d1
	bset	d1,d3
	move.w	(VisTeam).l,d1
	bset	d1,d3
	movea.l	#$18A18,a1
	moveq	#$7,d2
.loop	bsr.w	.loop2
	move.w	d0,$0(a1)
	bsr.w	.loop2
	move.w	d0,$2(a1)
	adda.w	#$10,a1
	dbra	d2,.loop
	rts
.loop2	moveq	#$1A,d0
	jsr	(randomd0).l
	bset	d0,d3
	bne.w	.loop2
	rts
; Initialises the player slot structures.
InitPlayerSlots
	moveq	#$4,d0
	lea.l	$A(a3),a0
.loop	move.w	-(a0),-(sp)
	dbra	d0,.loop
	moveq	#$7,d2
	movea.l	#$18A88,a1
.loop2	bclr	#$2,$E(a1)
	moveq	#$5,d0
	bsr.w	SuperDiv
	move.w	d0,$6(a1)
	cmpi.w	#$4,d0
	bne.w	.next
	bset	#$2,$E(a1)
.next	moveq	#$5,d0
	bsr.w	SuperDiv
	move.w	d0,$4(a1)
	cmpi.w	#$4,d0
	bne.w	.next2
	bset	#$2,$E(a1)
.next2	suba.w	#$10,a1
	dbra	d2,.loop2
	move.w	#$4000,d0
	bsr.w	SuperDiv
	move.w	d0,$18AA4.l
	move.w	#$8,d0
	bsr.w	SuperDiv
	move.w	d0,$18AA2.l
	tst.w	$18BF8.l
	beq.w	.next4
	cmpi.w	#$1,$18AA2.l
	bne.w	.next3
	move.w	#$3,$18AA2.l
	bra.w	.next4
.next3	cmpi.w	#$2,$18AA2.l
	bne.w	.next4
	move.w	#$4,$18AA2.l
.next4	moveq	#$10,d0
	bsr.w	SuperDiv
	move.w	d0,$18AA0.l
	moveq	#$4,d0
	bsr.w	SuperDiv
	move.w	d0,$18A9E.l
	moveq	#$8,d0
	bsr.w	SuperDiv
	move.w	d0,$18A9C.l
	moveq	#$20,d0
	bsr.w	SuperDiv
	move.w	d0,$18A9A.l
	moveq	#$4,d0
	lea.l	(a3),a0
.loop3	move.w	(sp)+,(a0)+
	dbra	d0,.loop3
	rts
