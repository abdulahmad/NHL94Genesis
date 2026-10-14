; Season player and team stats screens and league leaders (ported from NHL 95).

DrawTeamScreen4NoSetup	;DrawTeamScreen4 without the screen setup (forceblack, scroll, vdp registers)
	movem.l	d0-d1/a2,-(sp)
	bra.w	DrawTeamScreen4Body

DrawTeamScreen4	;The same as DrawTeamScreen3 with the team block tiles decompressed (Teamblocksmap+8)
	movem.l	d0-d1/a2,-(sp)
	jsr	(forceblack).l
.0
	btst	#0,(disflags).w
	bne.s	.0
	clr.w	(Hscroll).w
	clr.w	(Vscroll).w
	jsr	(SetScroll2).l
	move.w	(disflags).w,-(sp)
	bset	#2,(disflags).w
	movea.l	#VDP_DATA,a0
	move.w	#VDPR_WINX,Vctrl-Vdata(a0)
	move.w	#VDPR_WINY+$1C,Vctrl-Vdata(a0)
	move.w	(VSPRITES).w,d0
	jsr	(Vmaddr).l
	move.l	#0,(a0)
	move.w	#VDPR_MODE4+$81,Vctrl-Vdata(a0)
	move.w	#6,(Map3col1).w
	move.w	#VDPR_HSCROLL,Vctrl-Vdata(a0)
	clr.w	d0
	jsr	(Vmaddr).l
	move.l	#0,(a0)
	move.w	(sp)+,(disflags).w
	bclr	#1,(disflags).w

DrawTeamScreen4Body	;DrawTeamScreen4 after the screen setup; DrawTeamScreen4NoSetup branches here
	moveq	#1,d4
	movem.l	a0-a6,-(sp)
	movea.l	#Teamblocksmap+8,a2
	jsr	(DecompressGraphicsPlain).l
	movem.l	(sp)+,a0-a6
	jsr	(printz).l
	String	-(TXPRI+TXMAP3),0,0,0
	movea.l	(screenarg).w,a1
	adda.l	4(a1),a1
	movea.l	#ZeroLong,a2
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#0,d5
	jsr	(dobitmap).l
	jsr	(printz).l
	String	-TXMAP3,0,0,0
	movem.l	(sp),d0-d1/a2
	add.w	d0,(printy).w
	movea.l	(screenarg).w,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	move.w	d1,d3
	sub.w	d0,d3
	move.w	d0,d1
	clr.w	d0
	moveq	#$28,d2
	moveq	#$F,d5
	jsr	(dobitmap).l
	move.w	d4,(smallfontchars).w
	move.l	#SmallFontMap,(smallfontptr).l
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$83,$44,$67,$89,$AB,$CD,$EF	;remap table
	move.w	d4,(smallfont2chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$8B,$83,$44,$67,$89,$AB,$CD,$EF	;remap table
	move.w	d4,(smallfont3chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$83,$4C,$67,$89,$AB,$CD,$EF	;remap table
	move.w	d4,(smallfont4chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$1B,$83,$4C,$67,$89,$AB,$CD,$EF	;remap table
	move.w	d4,(BigFontChars).w
	movea.l	#BigFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$81,$23,$45,$67,$89,$AB,$CD,$EF	;remap table
	jsr	(printz).l
	String	-TXMAP2,0,0,0
	moveq	#$40,d0
	moveq	#$20,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	move.w	#$18,(palcount).w
	movem.l	(sp)+,d0-d1/a2
	rts

DrawTeamScreen5	;DrawTeamScreen4 with three small fonts and palette word $A00
	movem.l	d0-d1/a2,-(sp)
	jsr	(forceblack).l
.0
	btst	#0,(disflags).w
	bne.s	.0
	clr.w	(Hscroll).w
	clr.w	(Vscroll).w
	jsr	(SetScroll2).l
	move.w	(disflags).w,-(sp)
	bset	#2,(disflags).w
	movea.l	#VDP_DATA,a0
	move.w	#VDPR_WINX,Vctrl-Vdata(a0)
	move.w	#VDPR_WINY+$1C,Vctrl-Vdata(a0)
	move.w	(VSPRITES).w,d0
	jsr	(Vmaddr).l
	move.l	#0,(a0)
	move.w	#VDPR_MODE4+$81,Vctrl-Vdata(a0)
	move.w	#6,(Map3col1).w
	move.w	#VDPR_HSCROLL,Vctrl-Vdata(a0)
	clr.w	d0
	jsr	(Vmaddr).l
	move.l	#0,(a0)
	move.w	(sp)+,(disflags).w
	bclr	#1,(disflags).w
	moveq	#1,d4
	movem.l	a0-a6,-(sp)
	movea.l	#Teamblocksmap+8,a2
	jsr	(DecompressGraphicsPlain).l
	movem.l	(sp)+,a0-a6
	jsr	(printz).l
	String	-(TXPRI+TXMAP3),0,0,0
	movea.l	(screenarg).w,a1
	adda.l	4(a1),a1
	movea.l	#ZeroLong,a2
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#0,d5
	jsr	(dobitmap).l
	jsr	(printz).l
	String	-TXMAP3,0,0,0
	movem.l	(sp),d0-d1/a2
	add.w	d0,(printy).w
	movea.l	(screenarg).w,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	move.w	d1,d3
	sub.w	d0,d3
	move.w	d0,d1
	clr.w	d0
	moveq	#$28,d2
	moveq	#$F,d5
	jsr	(dobitmap).l
	move.w	d4,(smallfontchars).w
	move.l	#SmallFontMap,(smallfontptr).l
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$83,$44,$67,$89,$AB,$CD,$EF	;remap table
	move.w	d4,(smallfont2chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$0B,$83,$4C,$67,$89,$AB,$CD,$EF	;remap table
	move.w	d4,(smallfont3chars).w
	movea.l	#SmallFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$E1,$23,$46,$67,$89,$AB,$CD,$EF	;remap table
	move.w	d4,(BigFontChars).w
	movea.l	#BigFontMap+8,a2
	jsr	(DecompressGraphicsWithCallback).l
	dc.b	$01,$23,$45,$67,$89,$AB,$CD,$EF	;remap table
	jsr	(printz).l
	String	-TXMAP2,0,0,0
	moveq	#$40,d0
	moveq	#$20,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	move.w	#$A00,(palfadenew).w
	move.w	#$18,(palcount).w
	movem.l	(sp)+,d0-d1/a2
	rts

ReadSeasonTeamRecord	;Read the season record of team d7 (save RAM SRTeamStats, or SRPOTeamStats with SeasonDay bit 5) to a0
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	d7,d0
	mulu.w	#$A,d0
	btst	#5,(SeasonDay+1).w
	beq.w	.0
	addi.l	#SRPOTeamStats,d0
	bra.w	.1
.0
	addi.l	#SRTeamStats,d0
.1
	moveq	#$A,d1
	movem.l	d7/a0,-(sp)
	jsr	(ReadSRAM).l
	movem.l	(sp)+,d7/a0
	adda.w	#$A,a0
	move.w	d7,d0
	mulu.w	#3,d0
	btst	#5,(SeasonDay+1).w
	beq.w	.2
	addi.l	#SRPOStandings,d0
	bra.w	.3
.2
	addi.l	#SRStandings,d0
.3
	moveq	#3,d1
	jsr	(ReadSRAM).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

SeasonPlayerStats	;Season Player Stats screen: set the VRAM layout (VSCRLPM ... Map3col1), clear VRAM (setVram), then run the stats screen and return
	bclr	#1,(disflags).w
	move.w	#$C000,(VmMap2).w
	move.w	#6,(Map2col1).w
	move.w	#$DC00,(VSPRITES).w
	move.w	#$E000,(VmMap1).w
	move.w	#6,(Map1col1).w
	move.w	#$F000,(VmMap3).w
	move.w	#5,(Map3col1).w
	move.w	#$FC00,(VSCRLPM).w
	moveq	#0,d0
	jsr	(setVram).l
	bra.w	SeasonStatsList

SeasonPlayersScreen	;Run the season stats screen, then jump to ExitStatsScreen
	bsr.w	SeasonStatsList
	jmp	(ExitStatsScreen).l

.seasonPlayersRedraw	;Wait for vblank, reset scroll, clear the window/scroll VDP areas, draw the team screen (DrawTeamScreen4NoSetup) and enter the stats screen draw
	btst	#0,(disflags).w
	bne.s	.seasonPlayersRedraw
	clr.w	(Hscroll).w
	clr.w	(Vscroll).w
	jsr	(SetScroll2).l
	move.w	(disflags).w,-(sp)
	bset	#2,(disflags).w
	movea.l	#VDP_DATA,a0
	move.w	#VDPR_WINX,Vctrl-Vdata(a0)
	move.w	#VDPR_WINY,Vctrl-Vdata(a0)
	move.w	(VSPRITES).w,d0
	jsr	(Vmaddr).l
	move.l	#0,(a0)
	move.w	#VDPR_MODE4+$81,Vctrl-Vdata(a0)
	move.w	#6,(Map2col1).w
	move.w	#VDPR_HSCROLL,Vctrl-Vdata(a0)
	clr.w	d0
	jsr	(Vmaddr).l
	move.l	#0,(a0)
	move.w	(sp)+,(disflags).w
	bclr	#1,(disflags).w
	move.w	#$800,d0
	move.w	(VmMap1).w,d1
	move.w	#$7FF,d2
	jsr	(DoFill).l
	clr.w	d7
	moveq	#$D,d0
	moveq	#$18,d1
	move.l	#PlayerStatsBgMap,(screenarg).l
	jsr	(DrawTeamScreen4NoSetup).l
	bra.w	SeasonStatsListDraw

SeasonStatsList	;d7 = team 0-$19 (A/B cycles teams); sflags11 bit 3 = playoff variant
	move.b	(SeasonDay+1).w,-(sp)
	btst	#3,(sflags11).w
	bne.w	.0
	bclr	#5,(SeasonDay+1).w
.0
	clr.w	d7
	moveq	#$D,d0
	moveq	#$18,d1
	move.l	#PlayerStatsBgMap,(screenarg).l
	jsr	(DrawTeamScreen4).l

SeasonStatsListDraw	;Draw the season player stats screen for team d7 (SeasonStatsList continues here)
	jsr	(printz).l
	String	-(TXPRI+TXMAP3),$0,$6,$0
	movea.l	#PlayerStatsTitleMap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#4,d5
	jsr	(dobitmap).l
	clr.w	(DispAttribCtr).w
	clr.w	(VertLineScrolling).w
.team
	jsr	(ReadTeamPlayerStats).l
	clr.w	(PlayerScrollCtr).w
	jsr	(printz).l
	String	-(TXPRI+TXMAP3),$5,$1,$0
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,$B,$1A,CC_SetFont,$3,'A,B^-^Switch^Teams',CC_SetFont,$0,$0
	btst	#3,(sflags11).w
	bne.w	.1
	jsr	(printbigz).l
	dc.w	$20	;String length
	dc.b	$BD,$2,$4,'Season',$BD,$F,$4,'Player'
	dc.b	$BD,$1C,$4,'Stats',$BD,$E,$1,$0
	bra.w	.2
.1
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP3),$6,$4,'Playoff',-(TXPRI+TXMAP3),$15,$4,'Players',-(TXPRI+TXMAP3),$E,$1,$0
.2
	clr.w	d0
	move.w	d7,d0
	jsr	(DrawSeasonStatsLogo).l
	bsr.w	DrawSeasonStatsList
	bsr.w	SeasonScrollArrows
.wait
	jsr	(vcountwait).l
	jsr	(orjoy4way).l
	btst	#7,d3
	beq.w	.keys
	move.b	(sp)+,(SeasonDay+1).w
	rts
.keys
	btst	#6,d1
	bne.w	.prev
	btst	#4,d1
	bne.w	.next
	jsr	(nodiag).l
	moveq	#1,d0
	btst	#3,d1
	bne.w	.column
	neg.w	d0
	btst	#2,d1
	bne.w	.column
	moveq	#-2,d0
	btst	#0,d3
	bne.w	.5
	neg.w	d0
	btst	#1,d3
	beq.w	.scroll
.5
	move.w	d0,(PlayerScrollCtr).w
.scroll
	bsr.w	SeasonStatsListScroll
	bra.s	.wait
.column
	add.w	(DispAttribCtr).w,d0
	cmp.w	#$FFFF,d0
	blt.s	.scroll
	cmp.w	#2,d0
	bgt.s	.scroll
	move.w	d0,(DispAttribCtr).w
	bsr.w	DrawSeasonStatsList
	bsr.w	SeasonScrollArrows
	bra.s	.scroll
.prev
	subq.w	#1,d7
	bpl.w	.team
	move.w	#$19,d7
	bra.w	.team
.next
	addq.w	#1,d7
	cmp.w	#NumPlayoffTeams,d7
	bne.w	.team
	clr.w	d7
	bra.w	.team

SeasonStatsListScroll	;Per-frame scroll of the player list
	move.w	(PlayerScrollCtr).w,d0
	beq.w	rtsSeasonStats
	add.w	(VertLineScrolling).w,d0
	bmi.w	rtsSeasonStats
	cmp.w	(SelectedPlayerIdx).w,d0
	bgt.w	rtsSeasonStats
	move.w	(VertLineScrolling).w,d1
	move.w	d0,(VertLineScrolling).w
	andi.w	#$F,d0
	bne.w	.0
	bsr.w	SeasonScrollArrows
	clr.w	(PlayerScrollCtr).w
.0
	andi.w	#$F,d1
	bne.w	SeasonStatsListScrollReg
	move.w	d0,-(sp)
	cmp.w	#$E,d0
	bne.w	.1
	bsr.w	SeasonStatsRowUp
.1
	move.w	(sp)+,d0
	cmp.w	#2,d0
	bne.w	SeasonStatsListScrollReg
	bsr.w	SeasonStatsRowDown

SeasonStatsListScrollReg	;VSRAM = VertLineScrolling - $68
	move.w	(disflags).w,-(sp)
	bset	#2,(disflags).w
	movea.l	#VDP_DATA,a0
	move.l	#VSRAM_W+(2<<16),Vctrl-Vdata(a0)
	move.w	#$FF98,d0
	add.w	(VertLineScrolling).w,d0
	move.w	d0,(a0)
	move.w	(sp)+,(disflags).w

rtsSeasonStats	;rts (shared exit of the SeasonAttribute routines)
	rts

SeasonStatsRowUp	;Draw the season stats row at the top of the view
	move.w	(VertLineScrolling).w,d3
	lsr.w	#4,d3
	bra.w	DrawSeasonStatsRow

SeasonStatsRowDown	;Draw the season stats row at the bottom of the view
	move.w	(VertLineScrolling).w,d3
	lsr.w	#4,d3
	addq.w	#6,d3
	bra.w	DrawSeasonStatsRow

DrawSeasonStatsList	;Headers, sort title, sorted player list at Satt, draws 6 rows
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,$4,$9,CC_SetFont,$1,'Player',CC_AddX,$7,$0
	lea	SeasonStatColumnHeaders(pc),a1
	moveq	#3,d3
	tst.w	(DispAttribCtr).w
	bmi.w	.loop
	adda.w	(a1),a1
	clr.w	d3
.loop
	move.w	#$8000,(printa).w
	cmp.w	(DispAttribCtr).w,d3
	bne.w	.1
	move.w	#$C000,(printa).w
.1
	jsr	(printsmall).l
	addq.w	#1,d3
	cmp.w	#3,d3
	blt.s	.loop
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,$9,$7,$0
	jsr	(printsmallz).l
	String	CC_SetFont,$1
	jsr	(printz).l
	String	-(TXPRI+TXMAP3),$A,$7,$0
	lea	SeasonStatSortTitles(pc),a1
	moveq	#1,d0
	add.w	(DispAttribCtr).w,d0
	jsr	(PrintSmallListItem).l
	clr.w	(printfontset).w
	movea.w	#(Satt-M68K_RAM),a3
	clr.l	d6
	tst.w	(DispAttribCtr).w
	bpl.w	.pick
	jsr	(GetGoalieCountD7).l
	bset	d0,d6
	subq.w	#1,d6
	not.l	d6
.pick
	moveq	#-1,d4
	st	d5
	jsr	(GetPlayerCountD7).l
	bra.w	.5
.scan
	btst	d0,d6
	bne.w	.5
	clr.w	d2
	bclr	#2,(sflags5).w
	move.w	(DispAttribCtr).w,d1
	bmi.w	.4
	bsr.w	SeasonGetStatColumn
.4
	btst	#2,(sflags5).w
	bne.w	.5
	ext.l	d2
	asl.l	#8,d2
	jsr	(GetRosterName).l
	adda.w	(a1),a1
	move.b	#$FF,d2
	sub.b	(a1),d2
	cmp.l	d4,d2
	ble.w	.5
	move.l	d2,d4
	move.w	d0,d5
.5
	dbf	d0,.scan
	bset	d5,d6
	move.b	d5,(a3)+
	bpl.s	.pick
	moveq	#5,d0
.end
	st	0(a3,d0.w)
	dbf	d0,.end
	move.w	a3,d0
	subi.w	#(Satt+6-M68K_RAM),d0
	bpl.w	.7
	clr.w	d0
.7
	asl.w	#4,d0
	move.w	d0,(SelectedPlayerIdx).w
	cmp.w	(VertLineScrolling).w,d0
	bcc.w	.8
	move.w	d0,(VertLineScrolling).w
.8
	moveq	#5,d4
.rows
	move.w	(VertLineScrolling).w,d3
	lsr.w	#4,d3
	add.w	d4,d3
	bsr.w	DrawSeasonStatsRow
	dbf	d4,.rows
	bra.w	SeasonStatsListScrollReg

DrawSeasonStatsRow	;Draws list row d3 (rank, name, 3 stat columns or goalie saves/shots/save %)
	movea.w	#(Satt-M68K_RAM),a4
	adda.w	d3,a4
	jsr	(printz).l
	String	-(TXPRI+TXMAP2),$0,$0,$0
	add.w	d3,d3
	andi.w	#$1F,d3
	move.w	d3,(printy).w
	moveq	#$28,d0
	moveq	#1,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	tst.b	(a4)
	bmi.w	rtsSeasonStats
	subq.w	#1,(printy).w
	move.w	#1,(printx).w
	move.w	a4,d0
	subi.w	#(Satt-1-M68K_RAM),d0
	moveq	#2,d1
	move.w	#$E000,(printa).w
	jsr	(PushNumberWidth).l
	jsr	(print).l
	clr.w	d0
	move.b	(a4),d0
	jsr	(FormatPlayerNameD7).l
	addq.w	#1,(printx).w
	move.w	#$8000,(printa).w
	jsr	(print).l
	move.w	#$11,(printx).w
	tst.w	(DispAttribCtr).w
	bmi.w	.goalie
	clr.w	d5
.cols
	clr.w	d0
	move.b	(a4),d0
	move.w	d5,d1
	bsr.w	SeasonGetStatColumn
	move.w	d2,d0
	moveq	#4,d1
	jsr	(PushNumberWidth).l
	move.w	#$8000,(printa).w
	cmp.w	(DispAttribCtr).w,d5
	bne.w	.1
	move.w	#$C000,(printa).w
.1
	jsr	(print).l
	addq.w	#2,(printx).w
	addq.w	#1,d5
	cmp.w	#3,d5
	bne.s	.cols
	bra.w	.exit
.goalie
	clr.w	d0
	move.b	(a4),d0
	moveq	#3,d1
	bsr.w	SeasonReadStatColumn
	clr.w	d0
	move.b	(a4),d0
	moveq	#0,d1
	move.w	d2,-(sp)
	bsr.w	SeasonReadStatColumn
	move.w	(sp)+,d0
	move.w	d0,d3
	sub.w	d2,d0
	bpl.w	.3
	clr.w	d0
.3
	move.w	d0,d2
	moveq	#4,d1
	jsr	(PushNumberWidth).l
	addq.w	#1,(printx).w
	jsr	(print).l
	move.w	d3,d0
	moveq	#4,d1
	jsr	(PushNumberWidth).l
	addq.w	#2,(printx).w
	jsr	(print).l
	tst.w	d3
	beq.w	.4
	mulu.w	#$64,d2
	divu.w	d3,d2
.4
	move.w	d2,d0
	moveq	#4,d1
	jsr	(PushNumberWidth).l
	addq.w	#2,(printx).w
	jsr	(print).l
	jsr	(printz).l
	String	'%',$0
.exit
	rts

SeasonGetStatColumn	;d2 = stat column d1 for player d0; goalies: columns 1-2 read column 1 (A), others set sflags5 bit 2 (skip)
	bclr	#2,(sflags5).w
	move.w	d0,-(sp)
	jsr	(GetGoalieCountD7).l
	move.w	d0,d2
	move.w	(sp)+,d0
	cmp.w	d2,d0
	bge.w	SeasonReadStatColumn
	clr.w	d2
	btst	d1,#6
	beq.w	SeasonSkipStatColumn
	moveq	#1,d1

SeasonReadStatColumn	;d2 = sum of the season stat words (low 15 bits) at StatBuf + SeasonStatColumnOffsets column offsets, player d0
	movem.w	d0,-(sp)
	movea.l	#StatBuf,a2
	lea	SeasonStatColumnOffsets(pc),a1
	asl.w	#2,d1
	adda.w	d1,a1
	move.w	(a1),d1
	add.w	d0,d0
	add.w	d0,d1
	move.w	0(a2,d1.w),d2
	andi.w	#$7FFF,d2
	move.w	2(a1),d1
	bmi.w	.0
	add.w	d0,d1
	move.w	0(a2,d1.w),d3
	andi.w	#$7FFF,d2	;(sic: masks d2 again, not d3)
	add.w	d3,d2
.0
	movem.w	(sp)+,d0
	rts

SeasonSkipStatColumn	;Column not shown for this goalie: set sflags5 bit 2
	bset	#2,(sflags5).w
	rts

SeasonStatColumnOffsets	;Word offsets into StatBuf per column (G, A, Pts = G+A, SOG, PIM), -1 = none
	dc.w	$0,$FFFF,$34,$FFFF,$0,$34,$68,$FFFF,$D0,$FFFF

SeasonStatColumnHeaders	;Column headers (goalie header, then G, A, Pts, SOG, PIM)
	String	'Saves Shots Save %  '
	String	'   G'
	String	'     A'
	String	'   Pts    '
	String	' SOG'
	String	' PIM'

SeasonStatSortTitles	;Sort column titles
	String	'    Goalie Saves   ]'
	String	'[      Goals       ]'
	String	'[     Assists      ]'
	String	'[      Points       '
	String	'[  Shots On Goal   ]'
	String	'[ Penalty Minutes   '

SeasonScrollArrows	;Up / down arrows (SeasonScrollArrowTbl). Saves d0-d1/a1
	movem.l	d0-d1/a1,-(sp)
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,'$',$C,CC_SetFont,$3,$0
	clr.w	d0
	move.w	(VertLineScrolling).w,d1
	tst.w	d1
	sgt	d0
	neg.b	d0
	cmp.w	(SelectedPlayerIdx).w,d1
	slt	d1
	neg.b	d1
	add.b	d1,d0
	add.b	d1,d0
	lea	SeasonScrollArrowTbl(pc),a1
	jsr	(PrintSmallListItem).l
	movem.l	(sp)+,d0-d1/a1
	rts

SeasonScrollArrowTbl	;None, up, down, both
	String	' ',$FB,$FF,$FA,$E,' ',$F9,$0
	String	'{',$FB,$FF,$FA,$E,' ',$F9,$0
	String	' ',$FB,$FF,$FA,$E,'}',$F9,$0
	String	'{',$FB,$FF,$FA,$E,'}',$F9,$0

DrawSeasonStatsLogo	;Draw bitmap Teamblocksmap via dobitmap with tile base $69A, d1 = 2*d0 (team d0). Saves all regs
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#1,d4
	move.w	d0,d1
	clr.w	d0
	asl.w	#1,d1
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

SeasonTeamStats	;Season TEAM STATS screen (sflags11 bit 3 = playoff "Playoff Teams"): d7 = team 0-$19, left/right (bits 6/4 of d1) change team, start exits
	bclr	#1,(disflags).w
	move.w	#$C000,(VmMap2).w
	move.w	#6,(Map2col1).w
	move.w	#$DC00,(VSPRITES).w
	move.w	#$E000,(VmMap1).w
	move.w	#6,(Map1col1).w
	move.w	#$F000,(VmMap3).w
	move.w	#5,(Map3col1).w
	move.w	#$FC00,(VSCRLPM).w
	moveq	#0,d0
	jsr	(setVram).l
	bra.w	SeasonTeamStatsRun

SeasonTeamsScreen	;Pause / season menu Season Team Stats (Playoff Teams): SeasonTeamStatsRun, then ExitStatsScreen
	bsr.w	SeasonTeamStatsRun
	jmp	(ExitStatsScreen).l

SeasonTeamStatsRun	;Season (or playoff, sflags11 bit 3) team stats screen: team records from ReadSeasonTeamRecord, A / B switch teams
	move.b	(SeasonDay+1).w,-(sp)
	btst	#3,(sflags11).w
	bne.w	.0
	bclr	#5,(SeasonDay+1).w
.0
	clr.w	d7
	move.w	#0,d0
	move.w	#$1B,d1
	move.l	#ControllerBgMap,(screenarg).l
	jsr	(DrawTeamScreen5).l
	btst	#3,(sflags11).w
	bne.w	.1
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP2),$4,$2,'Season',-(TXPRI+TXMAP2),$11,$2,'Team',-(TXPRI+TXMAP2),$1A,$2,'Stats'
	bra.w	.team
.1
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP2),$8,$2,'Playoff',-(TXPRI+TXMAP2),$17,$2,'Teams'
.team
	movea.l	#StatBuf,a0
	jsr	(ReadSeasonTeamRecord).l
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$B,$1A,CC_SetFont,$1,'A,B^-^Switch^Teams',CC_SetFont,$0,$0
	jsr	(printz).l
	String	-(TXPRI+TXMAP3),$E,$6,$0
	move.w	d7,d0
	jsr	(DrawTeamStatsLogo).l
	bsr.w	PrintSeasonTeamStats
.wait
	jsr	(vcountwait).l
	jsr	(orjoy4way).l
	btst	#7,d3
	beq.w	.keys
	move.b	(sp)+,(SeasonDay+1).w
	rts
.keys
	btst	#6,d1
	bne.w	.prev
	btst	#4,d1
	bne.w	.next
	bra.s	.wait
.next
	addq.w	#1,d7
	cmp.w	#NumPlayoffTeams,d7
	bne.s	.team
	clr.w	d7
	bra.s	.team
.prev
	subq.w	#1,d7
	bpl.w	.team
	move.w	#$19,d7
	bra.w	.team

PrintSeasonTeamStats	;print the team stat rows from the record at StatBuf (a6): W,L,T,Pts, then per-game / percentage stats
	movem.l	a6,-(sp)
	movea.l	#StatBuf,a6
	jsr	(printsmallz).l
	String	CC_SetFont,$0
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$3,$9,'Wins,Losses,Ties,Pts  ',$0
	clr.w	(rosterscroll).w
	clr.w	d0
	move.b	$A(a6),d0
	add.w	d0,(rosterscroll).w
	move.w	d0,-(sp)
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	',',$0
	clr.w	d0
	move.b	$C(a6),d0
	add.w	d0,(rosterscroll).w
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	',',$0
	clr.w	d0
	move.b	$B(a6),d0
	add.w	d0,(rosterscroll).w
	move.w	d0,-(sp)
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	',',$0
	move.w	(sp)+,d0
	add.w	(sp),d0
	add.w	(sp)+,d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$3,$B,'Goals Scored Per Game',CC_SetX,$1E
	move.w	(rosterscroll).w,d1
	clr.l	d0
	tst.w	d1
	beq.w	.0
	move.w	(a6),d0
	mulu.w	#$64,d0
	divu.w	d1,d0
	andi.l	#$FFFF,d0
	divu.w	#$64,d0
.0
	swap	d0
	move.w	d0,-(sp)
	swap	d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	'.',$0
	move.w	(sp)+,d0
	move.w	#2,d1
	jsr	(PushNumberWidthZero).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$3,$D,'Goals Allowed Per Game',CC_SetX,$1E,$0
	move.w	(rosterscroll).w,d1
	clr.w	d0
	tst.w	d1
	beq.w	.1
	move.w	2(a6),d0
	mulu.w	#$64,d0
	divu.w	d1,d0
	andi.l	#$FFFF,d0
	divu.w	#$64,d0
.1
	swap	d0
	move.w	d0,-(sp)
	swap	d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	'.',$0
	move.w	(sp)+,d0
	move.w	#2,d1
	jsr	(PushNumberWidthZero).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$3,$F,'Penalty Minutes Per Game',CC_SetX,$1E,$0
	move.w	(rosterscroll).w,d1
	clr.l	d0
	tst.w	d1
	beq.w	.2
	move.w	4(a6),d0
	mulu.w	#$64,d0
	divu.w	d1,d0
	andi.l	#$FFFF,d0
	divu.w	#$64,d0
.2
	swap	d0
	move.w	d0,-(sp)
	swap	d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	'.',$0
	move.w	(sp)+,d0
	move.w	#2,d1
	jsr	(PushNumberWidthZero).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$3,$11,'Save Percentage',CC_SetX,$1F
	move.w	8(a6),d3
	move.w	d3,d2
	sub.w	2(a6),d2
	bpl.w	.3
	clr.w	d2
.3
	tst.w	d3
	beq.w	.4
	mulu.w	#$64,d2
	divu.w	d3,d2
.4
	move.w	d2,d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	'%',$0
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$3,$13,'Shooting Percentage',CC_SetX,$1F
	move.w	6(a6),d3
	move.w	(a6),d2
	tst.w	d3
	beq.w	.5
	mulu.w	#$64,d2
	divu.w	d3,d2
.5
	move.w	d2,d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	'%',$0
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$3,$15,'Shots Per Game',CC_SetX,$1E,$0
	move.w	(rosterscroll).w,d1
	clr.l	d0
	tst.w	d1
	beq.w	.6
	move.w	6(a6),d0
	mulu.w	#$64,d0
	divu.w	d1,d0
	andi.l	#$FFFF,d0
	divu.w	#$64,d0
.6
	swap	d0
	move.w	d0,-(sp)
	swap	d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	'.',$0
	move.w	(sp)+,d0
	move.w	#2,d1
	jsr	(PushNumberWidthZero).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$3,$17,'Shots Allowed Per Game',CC_SetX,$1E,$0
	move.w	(rosterscroll).w,d1
	clr.l	d0
	tst.w	d1
	beq.w	.7
	move.w	8(a6),d0
	mulu.w	#$64,d0
	divu.w	d1,d0
	andi.l	#$FFFF,d0
	divu.w	#$64,d0
.7
	swap	d0
	move.w	d0,-(sp)
	swap	d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	jsr	(printsmallz).l
	String	'.',$0
	move.w	(sp)+,d0
	move.w	#2,d1
	jsr	(PushNumberWidthZero).l
	jsr	(printsmall).l
	movem.l	(sp)+,a6
	rts

DrawTeamStatsLogo	;Draw team d0's logo: frame d0*2 of the bitmap set at Teamblocksmap, tile $69A, via dobitmap
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#1,d4
	move.w	d0,d1
	clr.w	d0
	asl.w	#1,d1
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

LeagueLeadersScreen	;League Leaders screen (season menu): team / individual stat leader lists, scroll and category select
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(MarkSeasonRosters).l
	move.l	#PlayerStatsBgMap,(screenarg).l
	bsr.w	StandingsGfx
	move.w	#$18,(palcount).w
	bclr	#2,(disflags).w
	jsr	(printbigz).l
	String	-(TXPRI+TXMAP1),$6,$2,'League Leaders',$0
	clr.w	(StatWork).w
	clr.w	(SeasonGameCount).w
	move.w	#8,(StatWork+$8).w
	move.w	#7,(StatWork+$6).w
	clr.w	(StatWork+2).w
	movea.l	#.lastrow,a0
	move.w	(StatWork).w,d5
	add.w	d5,d5
	move.w	0(a0,d5.w),(StatWork+$A).w
.build
	bsr.w	BuildLeaders
.draw
	bsr.w	PrintLeadersHeader
	bsr.w	PrintTeamCategory
	move.w	#$18,(palcount).w
	bsr.w	DrawLeaderRows
	bsr.w	LeadersScrollArrows
	bsr.w	LeadersHelp
.input
	bsr.w	ReadLeadersPad
	tst.w	d1
	beq.w	.nopad
	btst	#7,d1
	bne.w	.done
	btst	#4,d1
	beq.w	.left
	jsr	(forceblack).l
	eori.w	#1,(StatWork).w
	clr.w	(StatWork+2).w
	clr.w	(SeasonGameCount).w
	move.w	#7,(StatWork+$6).w
	movea.l	#.lastrow,a0
	move.w	(StatWork).w,d5
	add.w	d5,d5
	move.w	0(a0,d5.w),(StatWork+$A).w
	bra.s	.build
.left
	btst	#2,d1
	beq.w	.up
	bsr.w	ClearLeadersArea
	subq.w	#1,(StatWork+2).w
	bpl.w	.category
	movea.l	#.lastcat,a0
	move.w	(StatWork).w,d0
	add.w	d0,d0
	move.w	0(a0,d0.w),d0
	move.w	d0,(StatWork+2).w
.category
	movea.l	#.lastrow,a0
	move.w	(StatWork).w,d5
	add.w	d5,d5
	move.w	0(a0,d5.w),(StatWork+$A).w
	clr.w	(SeasonGameCount).w
	move.w	#7,(StatWork+$6).w
	bra.w	.build
.lastcat
	dc.w	6,3
.up
	btst	#0,d1
	beq.w	.down
	tst.w	(SeasonGameCount).w
	beq.w	.input
	subq.w	#1,(SeasonGameCount).w
	subq.w	#1,(StatWork+$6).w
	bra.w	.draw
.down
	btst	#1,d1
	beq.w	.right
	move.w	(StatWork+$6).w,d0
	cmp.w	(StatWork+$A).w,d0
	bge.w	.input
	addq.w	#1,(SeasonGameCount).w
	addq.w	#1,(StatWork+$6).w
	bra.w	.draw
.lastrow
	dc.w	$19,$13
.right
	btst	#3,d1
	beq.w	.input
	bsr.w	ClearLeadersArea
	addq.w	#1,(StatWork+2).w
	movea.l	#.lastcat,a0
	move.w	(StatWork).w,d0
	add.w	d0,d0
	move.w	0(a0,d0.w),d0
	cmp.w	(StatWork+2).w,d0
	bge.w	.category
	clr.w	(StatWork+2).w
	bra.w	.category
.nopad
	jmp	(Opening2).l
.done
	movem.l	(sp)+,d0-d7/a0-a6
	rts

LeadersScrollArrows	;League Leaders: draw up/down scroll arrows depending on list position
	movem.l	d0-d7/a0-a6,-(sp)
	tst.w	(SeasonGameCount).w
	beq.w	.0
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$1,$9,'{'
	bra.w	.1
.0
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$1,$9,' '
.1
	move.w	(StatWork+$6).w,d1
	cmp.w	(StatWork+$A).w,d1
	bge.w	.2
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$1,$18,'}'
	bra.w	.3
.2
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$1,$18,' '
.3
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PrintTeamCategory	;League Leaders: print category name, team mode (7 categories); individual mode goes to PrintPlayerCategory
	tst.w	(StatWork).w
	bne.w	PrintPlayerCategory
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$10,$7,$0
	move.w	(StatWork+2).w,d0
	movea.l	#TeamCategoryText,a1
	jsr	(PrintListItem).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

TeamCategoryText
	String	'       Points        ',$0
	String	'      Goals Avg.     ',$0
	String	'  Goals Allowed Avg. ',$0
	String	'   Save Percentage   ',$0
	String	' Shooting Percentage ',$0
	String	'      Shots Avg.     ',$0
	String	'  Shots Allowed Avg. ',$0

PrintPlayerCategory	;League Leaders: print category name, individual mode (4 categories)
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$19,$7,$0
	move.w	(StatWork+2).w,d0
	movea.l	#PlayerCategoryText,a1
	jsr	(PrintListItem).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PlayerCategoryText
	String	'   Goals       ',$0
	String	'  Assists      ',$0
	String	'  Points       ',$0
	String	'      GAA      ',$0

PrintLeadersHeader	;League Leaders: print TEAM / INDIVIDUAL column headers
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),$0,$5,$0
	movea.l	#BlankLine40,a1
	jsr	(print).l
	move.w	(StatWork).w,d0
	movea.l	#LeaderModeText,a1
	jsr	(PrintListItem).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

LeaderModeText
	String	$BF,$11,$5,'TEAM',$BF,$5,$7,'   Team    ',$0
	String	$BF,$F,$5,'INDIVIDUAL',$BF,$6,$7,'No. Player   Team  ',$0

ReadLeadersPad	;League Leaders: wait (frame-synced) until a joypad reports input; d1 = buttons
	move.l	#$5460,d6
.wait
	move.w	#$64,d6
.1
	move.w	(vcount).w,d1
	sub.w	(oldvcount).w,d1
	beq.s	.wait
	move.w	(vcount).w,(oldvcount).w
	jsr	(ReadJoy1).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.2
	bra.w	.exit
.2
	jsr	(ReadJoy2).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.3
	bra.w	.exit
.3
	jsr	(ReadJoy3).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.4
	bra.w	.exit
.4
	jsr	(ReadJoy4).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1
	beq.w	.5
	bra.w	.exit
.5
	dbf	d6,.wait
.exit
	rts

ClearLeadersArea	;League Leaders: clear a $28x$14 text area with tile $7FF (individual mode only; team mode returns at once)
	tst.w	(StatWork).w
	beq.w	.exit
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$28,d0
	move.w	#$14,d1
	move.w	#$7FF,d2
	jsr	(printz).l
	String	-TXMAP1,$0,$7,$0
	jsr	(eraser).l
	movem.l	(sp)+,d0-d7/a0-a6
.exit
	rts

BuildLeaders	;League Leaders: build sorted team leader list for category StatWork+2 (TeamLeaderJumps) or individual list
	tst.w	(StatWork).w
	bne.w	BuildPlayerLeaders
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(StatWork+2).w,d0
	asl.w	#2,d0
	movea.l	#TeamLeaderJumps,a0
	movea.l	0(a0,d0.w),a0
	jmp	(a0)

TeamLeaderJumps
	dc.l	LeadersPoints,LeadersGoalsAvg,LeadersGoalsAllowed,LeadersSavePct,LeadersShootPct,LeadersShotsAvg,LeadersShotsAllowed

LeadersPoints	;Points: 2*wins+ties per team, sort descending
	movea.l	#StatBuf,a0
	jsr	(ReadStandings).l
	move.w	#$19,d3
	clr.w	d4
	movea.l	#picturebuf,a0
	movea.l	#TeamLeaderValues,a1
	movea.l	#StatBuf,a2
.loop
	move.b	d4,(a0)+
	clr.w	d0
	move.b	(a2),d0
	add.b	d0,d0
	add.b	1(a2),d0
	move.w	d0,(a1)+
	addq.w	#3,a2
	addq.w	#1,d4
	dbf	d3,.loop
	movea.l	#picturebuf,a0
	bsr.w	SortLeadersDown
	bra.w	BuildLeadersDone

LeadersGoalsAvg	;Goals Avg: goals*100/games per team, sort descending
	move.l	#SRTeamStats,d0
	move.l	#$104,d1
	movea.l	#StatBuf,a0
	jsr	(ReadSRAM).l
	movea.l	#StandingsRecs,a0
	jsr	(ReadStandings).l
	move.w	#$19,d3
	clr.w	d4
	movea.l	#LeaderTeamTbls+$1A,a0
	movea.l	#TeamLeaderValues,a1
	movea.l	#StatBuf,a2
	movea.l	#StandingsRecs,a3
.loop
	move.b	d4,(a0)+
	move.w	0(a2),d0
	beq.w	.1
	mulu.w	#$64,d0
	clr.w	d1
	move.b	(a3),d1
	add.b	2(a3),d1
	add.b	1(a3),d1
	divu.w	d1,d0
.1
	move.w	d0,(a1)+
	addq.w	#3,a3
	adda.w	#$A,a2
	addq.w	#1,d4
	dbf	d3,.loop
	movea.l	#LeaderTeamTbls+$1A,a0
	bsr.w	SortLeadersDown
	bra.w	BuildLeadersDone

LeadersGoalsAllowed	;Goals Allowed Avg: goals against*100/games per team, sort ascending
	move.l	#SRTeamStats,d0
	move.l	#$104,d1
	movea.l	#StatBuf,a0
	jsr	(ReadSRAM).l
	movea.l	#StandingsRecs,a0
	jsr	(ReadStandings).l
	move.w	#$19,d3
	clr.w	d4
	movea.l	#LeaderTeamTbls+$34,a0
	movea.l	#TeamLeaderValues,a1
	movea.l	#StatBuf,a2
	movea.l	#StandingsRecs,a3
.loop
	move.b	d4,(a0)+
	move.w	2(a2),d0
	beq.w	.1
	mulu.w	#$64,d0
	clr.w	d1
	move.b	(a3),d1
	add.b	2(a3),d1
	add.b	1(a3),d1
	divu.w	d1,d0
.1
	move.w	d0,(a1)+
	addq.w	#3,a3
	adda.w	#$A,a2
	addq.w	#1,d4
	dbf	d3,.loop
	movea.l	#LeaderTeamTbls+$34,a0
	bsr.w	SortLeadersUp
	bra.w	BuildLeadersDone

LeadersPenMinAvg	;Unreferenced: penalty minutes*100/games per team, sort descending
	move.l	#SRTeamStats,d0
	move.l	#$104,d1
	movea.l	#StatBuf,a0
	jsr	(ReadSRAM).l
	movea.l	#StandingsRecs,a0
	jsr	(ReadStandings).l
	move.w	#$19,d3
	clr.w	d4
	movea.l	#LeaderTeamTbls+$4E,a0
	movea.l	#TeamLeaderValues,a1
	movea.l	#StatBuf,a2
	movea.l	#StandingsRecs,a3
.loop
	move.b	d4,(a0)+
	move.w	4(a2),d0
	beq.w	.1
	mulu.w	#$64,d0
	clr.w	d1
	move.b	(a3),d1
	add.b	2(a3),d1
	add.b	1(a3),d1
	divu.w	d1,d0
.1
	move.w	d0,(a1)+
	addq.w	#3,a3
	adda.w	#$A,a2
	addq.w	#1,d4
	dbf	d3,.loop
	movea.l	#LeaderTeamTbls+$4E,a0
	bsr.w	SortLeadersDown
	bra.w	BuildLeadersDone

LeadersSavePct	;Save Percentage: (shots against - goals against)*100/shots against per team, sort descending
	move.l	#SRTeamStats,d0
	move.l	#$104,d1
	movea.l	#StatBuf,a0
	jsr	(ReadSRAM).l
	move.w	#$19,d3
	clr.w	d4
	movea.l	#LeaderTeamTbls+$68,a0
	movea.l	#TeamLeaderValues,a1
	movea.l	#StatBuf,a2
.loop
	move.b	d4,(a0)+
	move.w	8(a2),d0
	move.w	d0,d1
	beq.w	.2
	sub.w	2(a2),d1
	bpl.w	.1
	clr.w	d1
.1
	mulu.w	#$64,d1
	divu.w	d0,d1
.2
	move.w	d1,(a1)+
	adda.w	#$A,a2
	addq.w	#1,d4
	dbf	d3,.loop
	movea.l	#LeaderTeamTbls+$68,a0
	bsr.w	SortLeadersDown
	bra.w	BuildLeadersDone

LeadersShootPct	;Shooting Percentage: goals*100/shots per team, sort descending
	move.l	#SRTeamStats,d0
	move.l	#$104,d1
	movea.l	#StatBuf,a0
	jsr	(ReadSRAM).l
	move.w	#$19,d3
	clr.w	d4
	movea.l	#LeaderTeamTbls+$82,a0
	movea.l	#TeamLeaderValues,a1
	movea.l	#StatBuf,a2
.loop
	move.b	d4,(a0)+
	clr.w	d1
	move.w	6(a2),d0
	beq.w	.2
	move.w	(a2),d1
	cmp.w	d0,d1
	ble.w	.1
	move.w	d1,d0
.1
	mulu.w	#$64,d1
	divu.w	d0,d1
.2
	move.w	d1,(a1)+
	adda.w	#$A,a2
	addq.w	#1,d4
	dbf	d3,.loop
	movea.l	#LeaderTeamTbls+$82,a0
	bsr.w	SortLeadersDown
	bra.w	BuildLeadersDone

LeadersShotsAvg	;Shots Avg: shots*100/games per team, sort descending
	move.l	#SRTeamStats,d0
	move.l	#$104,d1
	movea.l	#StatBuf,a0
	jsr	(ReadSRAM).l
	movea.l	#StandingsRecs,a0
	jsr	(ReadStandings).l
	move.w	#$19,d3
	clr.w	d4
	movea.l	#LeaderTeamTbls+$9C,a0
	movea.l	#TeamLeaderValues,a1
	movea.l	#StatBuf,a2
	movea.l	#StandingsRecs,a3
.loop
	move.b	d4,(a0)+
	move.w	6(a2),d0
	beq.w	.1
	mulu.w	#$64,d0
	clr.w	d1
	move.b	(a3),d1
	add.b	2(a3),d1
	add.b	1(a3),d1
	divu.w	d1,d0
.1
	move.w	d0,(a1)+
	addq.w	#3,a3
	adda.w	#$A,a2
	addq.w	#1,d4
	dbf	d3,.loop
	movea.l	#LeaderTeamTbls+$9C,a0
	bsr.w	SortLeadersDown
	bra.w	BuildLeadersDone

LeadersShotsAllowed	;Shots Allowed Avg: shots against*100/games per team, sort ascending
	move.l	#SRTeamStats,d0
	move.l	#$104,d1
	movea.l	#StatBuf,a0
	jsr	(ReadSRAM).l
	movea.l	#StandingsRecs,a0
	jsr	(ReadStandings).l
	move.w	#$19,d3
	clr.w	d4
	movea.l	#LeaderTeamTbls+$B6,a0
	movea.l	#TeamLeaderValues,a1
	movea.l	#StatBuf,a2
	movea.l	#StandingsRecs,a3
.loop
	move.b	d4,(a0)+
	move.w	8(a2),d0
	beq.w	.1
	mulu.w	#$64,d0
	clr.w	d1
	move.b	(a3),d1
	add.b	2(a3),d1
	add.b	1(a3),d1
	divu.w	d1,d0
.1
	move.w	d0,(a1)+
	addq.w	#3,a3
	adda.w	#$A,a2
	addq.w	#1,d4
	dbf	d3,.loop
	movea.l	#LeaderTeamTbls+$B6,a0
	bsr.w	SortLeadersUp
	bra.w	BuildLeadersDone

BuildLeadersDone	;Shared exit of the team leader builders
	movem.l	(sp)+,d0-d7/a0-a6
	rts

SortLeadersDown	;League Leaders: bubble sort word values at TeamLeaderValues (25 pairs) descending, swapping index bytes at a0
	movea.l	#TeamLeaderValues,a1
.pass
	clr.w	d1
	clr.w	d0
	clr.w	(TempWord1).w
	move.w	#$18,d2
.cmp
	move.w	0(a1,d1.w),d5
	move.w	2(a1,d1.w),d6
	cmp.w	d5,d6
	ble.w	.noswap
	st	(TempWord1).w
	move.w	0(a1,d1.w),-(sp)
	move.w	2(a1,d1.w),-(sp)
	move.w	(sp)+,0(a1,d1.w)
	move.w	(sp)+,2(a1,d1.w)
	move.b	0(a0,d0.w),-(sp)
	move.b	1(a0,d0.w),-(sp)
	move.b	(sp)+,0(a0,d0.w)
	move.b	(sp)+,1(a0,d0.w)
.noswap
	addq.w	#1,d0
	addq.w	#2,d1
	dbf	d2,.cmp
	tst.w	(TempWord1).w
	bne.s	.pass
	rts

SortLeadersUp	;League Leaders: same bubble sort, ascending
	movea.l	#TeamLeaderValues,a1
.pass
	clr.w	d1
	clr.w	d0
	clr.w	(TempWord1).w
	move.w	#$18,d2
.cmp
	move.w	0(a1,d1.w),d5
	move.w	2(a1,d1.w),d6
	cmp.w	d5,d6
	bge.w	.noswap
	st	(TempWord1).w
	move.w	0(a1,d1.w),-(sp)
	move.w	2(a1,d1.w),-(sp)
	move.w	(sp)+,0(a1,d1.w)
	move.w	(sp)+,2(a1,d1.w)
	move.b	0(a0,d0.w),-(sp)
	move.b	1(a0,d0.w),-(sp)
	move.b	(sp)+,0(a0,d0.w)
	move.b	(sp)+,1(a0,d0.w)
.noswap
	addq.w	#1,d0
	addq.w	#2,d1
	dbf	d2,.cmp
	tst.w	(TempWord1).w
	bne.s	.pass
	rts

BuildPlayerLeaders	;League Leaders: individual mode, dispatch on category StatWork+2 through PlayerLeaderJumps
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(StatWork+2).w,d0
	asl.w	#2,d0
	movea.l	#PlayerLeaderJumps,a0
	movea.l	0(a0,d0.w),a0
	jmp	(a0)

BuildPlayerLeadersDone	;Shared exit of the player leader builders
	movem.l	(sp)+,d0-d7/a0-a6
	rts

PlayerLeaderJumps	;League Leaders: per category (StatWork+2) handler that builds and sorts the leader list
	dc.l	PlayerLeadersGoals
	dc.l	PlayerLeadersAssists
	dc.l	PlayerLeadersPoints
	dc.l	PlayerLeadersGAA

BuildLeaderList	;One stat: list each player whose stat is above 0
	movem.l	d0-d3/a0-a3,-(sp)
	movea.l	#SaveRAM,a1
	add.l	d0,d0
	asr.w	#1,d1
	subq.l	#1,d1
	clr.w	(a2)
	clr.l	d3
.loop
	move.b	1(a1,d0.l),d2
	lsl.w	#8,d2
	move.b	3(a1,d0.l),d2
	tst.w	d2
	beq.w	.next
	bmi.w	.next
	move.w	d3,(a3)+
	addq.w	#1,(a2)
	move.w	d2,(a0)+
.next
	addq.l	#4,d0
	addq.l	#1,d3
	dbf	d1,.loop
	movem.l	(sp)+,d0-d3/a0-a3
	rts

BuildLeaderListSum	;Goals plus assists for points
	movem.l	d0-d5/a0-a3,-(sp)
	movea.l	#SaveRAM,a1
	move.l	d0,d4
	addi.l	#$57C,d4
	add.l	d4,d4
	add.l	d0,d0
	asr.w	#1,d1
	subq.l	#1,d1
	clr.w	(a2)
	clr.l	d3
.loop
	move.b	1(a1,d0.l),d2
	lsl.w	#8,d2
	move.b	3(a1,d0.l),d2
	tst.w	d2
	bpl.w	.add
	clr.w	d2
.add
	move.b	1(a1,d4.l),d5
	lsl.w	#8,d5
	move.b	3(a1,d4.l),d5
	add.w	d5,d2
	beq.w	.next
	move.w	d3,(a3)+
	addq.w	#1,(a2)
	move.w	d2,(a0)+
.next
	addq.l	#4,d0
	addq.l	#4,d4
	addq.l	#1,d3
	dbf	d1,.loop
	movem.l	(sp)+,d0-d5/a0-a3
	rts

BuildLeaderListPct	;Goalie GAA from goals against and minutes
	movem.l	d0-d7/a0-a3,-(sp)
	movea.l	#SaveRAM,a1
	move.l	d0,d4
	addi.l	#$1074,d4
	add.l	d4,d4
	add.l	d0,d0
	asr.w	#1,d1
	subq.l	#1,d1
	clr.w	(a2)
	clr.w	d6
	move.b	(SeasonDay).w,d6
	sub.b	(SeasonStartDay).w,d6
	clr.w	d3
	move.b	(SeasonLength).w,d3
	mulu.w	#$19,d6
	mulu.w	#$54,d3
	divu.w	d3,d6
	clr.l	d3
.loop
	move.b	1(a1,d0.l),d2
	lsl.w	#8,d2
	move.b	3(a1,d0.l),d2
	tst.w	d2
	bpl.w	.next
	move.l	d0,-(sp)
	movem.l	d0-d1,-(sp)
	move.l	d0,d1
	addi.l	#$15F0,d1
	clr.w	d0
	move.b	1(a1,d1.l),d0
	asl.w	#8,d0
	move.b	3(a1,d1.l),d0
	andi.w	#$7FFF,d0
	movem.l	(sp)+,d0-d1
	bne.w	.get
	move.l	(sp)+,d0
	bra.w	.next
.get
	addi.l	#$2BE0,d0
	move.b	1(a1,d0.l),d2
	lsl.w	#8,d2
	move.b	3(a1,d0.l),d2
	move.l	(sp)+,d0
	andi.l	#$7FFF,d2
	move.b	1(a1,d4.l),d5
	lsl.w	#8,d5
	move.b	3(a1,d4.l),d5
	tst.w	d5
	beq.w	.next
	cmp.w	d6,d5
	blt.w	.next
	mulu.w	#$64,d2
	divu.w	d5,d2
	move.w	d3,(a3)+
	addq.w	#1,(a2)
	move.w	d2,(a0)+
.next
	addq.l	#4,d0
	addq.l	#4,d4
	addq.l	#1,d3
	dbf	d1,.loop
	movem.l	(sp)+,d0-d7/a0-a3
	rts

PlayerLeadersGoals	;Category 0: gather with BuildLeaderList (d0 = SRGoals, d1 = $548), sort descending
	move.l	#SRGoals,d0
	move.l	#$548,d1
	movea.l	#BuildLeaderList,a5
	bclr	#1,(BA_PS_flags).w
	bsr.w	GatherAndSort
	bra.w	BuildPlayerLeadersDone

PlayerLeadersAssists	;Category 1: gather with BuildLeaderList (d0 = SRAssists, d1 = $548), sort descending
	move.l	#SRAssists,d0
	move.l	#$548,d1
	movea.l	#BuildLeaderList,a5
	bclr	#1,(BA_PS_flags).w
	bsr.w	GatherAndSort
	bra.w	BuildPlayerLeadersDone

PlayerLeadersPoints	;Category 2: gather with BuildLeaderListSum (d0 = SRGoals, d1 = $548), sort descending
	move.l	#SRGoals,d0
	move.l	#$548,d1
	movea.l	#BuildLeaderListSum,a5
	bclr	#1,(BA_PS_flags).w
	bsr.w	GatherAndSort
	bra.w	BuildPlayerLeadersDone

PlayerLeadersGAA	;Category 3: gather with BuildLeaderListPct (d0 = SRGoals, d1 = $548), sort ascending (bit 1 of BA_PS_flags set)
	move.l	#SRGoals,d0
	move.l	#$548,d1
	movea.l	#BuildLeaderListPct,a5
	bset	#1,(BA_PS_flags).w
	bsr.w	GatherAndSort
	bra.w	BuildPlayerLeadersDone

GatherAndSort	;Call a5 to fill values at LeaderValues / players at LeaderPlayers (count StatWork+$C), then bubble sort both lists by value (descending, or ascending when bit 1 of BA_PS_flags)
	movea.l	#LeaderValues,a0
	movea.l	#StatWork+$C,a2
	movea.l	#LeaderPlayers,a3
	jsr	(a5)
	move.w	(StatWork+$C).w,d3
	beq.w	.rtsSortValues
	subq.w	#1,d3
	clr.w	d4
	movea.l	#LeaderValues,a1
	movea.l	#LeaderPlayers,a0
	btst	#1,(BA_PS_flags).w
	bne.w	.sortValuesUp

.sortValuesDown	;Descending pass: swap neighbours where the next value is larger, repeat until no swap
	clr.w	d0
	clr.w	(TempWord1).w
	move.w	(StatWork+$C).w,d2
	beq.w	.rtsSortValues
	subq.w	#2,d2
	beq.w	.rtsSortValues
	bmi.w	.rtsSortValues
.loop
	move.w	0(a1,d0.w),d5
	move.w	2(a1,d0.w),d6
	cmp.w	d5,d6
	ble.w	.1
	st	(TempWord1).w
	move.w	0(a1,d0.w),-(sp)
	move.w	2(a1,d0.w),-(sp)
	move.w	(sp)+,0(a1,d0.w)
	move.w	(sp)+,2(a1,d0.w)
	move.w	0(a0,d0.w),-(sp)
	move.w	2(a0,d0.w),-(sp)
	move.w	(sp)+,0(a0,d0.w)
	move.w	(sp)+,2(a0,d0.w)
.1
	addq.w	#2,d0
	dbf	d2,.loop
	tst.w	(TempWord1).w
	bne.s	.sortValuesDown

.rtsSortValues
	rts

.sortValuesUp	;Ascending pass: swap neighbours where the next value is smaller, repeat until no swap
	clr.w	d0
	clr.w	(TempWord1).w
	move.w	(StatWork+$C).w,d2
	beq.s	.rtsSortValues
	subq.w	#2,d2
	beq.s	.rtsSortValues
	bmi.s	.rtsSortValues
.loop2
	move.w	0(a1,d0.w),d5
	move.w	2(a1,d0.w),d6
	cmp.w	d5,d6
	bge.w	.3
	st	(TempWord1).w
	move.w	0(a1,d0.w),-(sp)
	move.w	2(a1,d0.w),-(sp)
	move.w	(sp)+,0(a1,d0.w)
	move.w	(sp)+,2(a1,d0.w)
	move.w	0(a0,d0.w),-(sp)
	move.w	2(a0,d0.w),-(sp)
	move.w	(sp)+,0(a0,d0.w)
	move.w	(sp)+,2(a0,d0.w)
.3
	addq.w	#2,d0
	dbf	d2,.loop2
	tst.w	(TempWord1).w
	bne.s	.sortValuesUp
	rts

DrawLeaderRows	;Draw the leader rows (StatWork+8 rows from StatWork+4): when StatWork is set use the sorted list (DrawPlayerLeaderRows), else rank, team logo (DrawLeaderLogo), and the category value (LeaderPrintJumps) from the RAM tables in LeaderTables
	tst.w	(StatWork).w
	bne.w	DrawPlayerLeaderRows
	clr.w	d6
	movea.l	#LeaderTables,a5
	move.w	(StatWork+2).w,d0
	asl.w	#2,d0
	movea.l	(a5,d0.w),a5
	movea.l	a5,a0
	move.w	#9,(printy).w
.row
	move.w	#5,(printx).w
	movea.l	#BlankLine40,a1
	jsr	(print).l
	move.w	#5,(printx).w
	addq.w	#1,(printy).w
	movea.l	#BlankLine40,a1
	jsr	(print).l
	move.w	#2,(printx).w
	move.w	d6,d0
	add.w	(SeasonGameCount).w,d0
	addq.w	#1,d0
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	subq.w	#1,(printy).w
	move.w	d6,d0
	add.w	(SeasonGameCount).w,d0
	clr.w	d1
	move.b	(a5,d0.w),d1
	move.w	#5,(printx).w
	bsr.w	DrawLeaderLogo
	addq.w	#1,(printy).w
	move.w	#$18,(printx).w
	movea.l	#TeamLeaderValues,a0
	adda.w	(SeasonGameCount).w,a0
	adda.w	(SeasonGameCount).w,a0
	move.w	d6,d0
	asl.w	#1,d0
	move.w	(a0,d0.w),d0
	movea.l	#LeaderPrintJumps,a6
	move.w	(StatWork+2).w,d4
	asl.w	#2,d4
	movea.l	(a6,d4.w),a6
	jsr	(a6)
	addq.w	#1,(printy).w
	addq.w	#1,d6
	cmp.w	(StatWork+$8).w,d6
	blt.w	.row
	bra.w	rtsLeaderRows

LeaderPrintJumps	;Value print handlers per category (StatWork+2)
	dc.l	PrintLeaderNum
	dc.l	PrintLeaderAvg
	dc.l	PrintLeaderAvg
	dc.l	PrintLeaderPct
	dc.l	PrintLeaderPct
	dc.l	PrintLeaderAvg
	dc.l	PrintLeaderAvg

PrintLeaderNum	;Print d0 3 wide
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jmp	(print).l

PrintLeaderAvg	;Print d0 / 100 as nn.nn (3 wide, '.', 2 digits)
	ext.l	d0
	divu.w	#$64,d0
	swap	d0
	move.w	d0,-(sp)
	swap	d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l
	String	'.',$0
	move.w	(sp)+,d0
	move.w	#2,d1
	jsr	(PushNumberWidthZero).l
	jmp	(print).l

PrintLeaderPct	;Print d0 3 wide followed by '%'
	jsr	(PrintLeaderNum).l
	jsr	(printz).l
	String	'%',$0
	rts

DrawPlayerLeaderRows	;Sorted list rows: rank, player name (TeamList, d7 = value / 26 team, remainder player) and value from LeaderValues (category 3 as nn.nn); records the last row in StatWork+$A
	clr.w	d6
	movea.l	#LeaderValues,a5
	move.w	#9,(printy).w
.row
	move.w	#5,(printx).w
	movea.l	#BlankLine40,a1
	jsr	(print).l
	move.w	#5,(printx).w
	addq.w	#1,(printy).w
	movea.l	#BlankLine40,a1
	jsr	(print).l
	move.w	d6,d0
	add.w	(SeasonGameCount).w,d0
	cmp.w	(StatWork+$C).w,d0
	blt.w	.entry
	movea.l	#BlankLine40,a1
	move.w	#1,(printx).w
	jsr	(print).l
	move.w	d6,d0
	add.w	(SeasonGameCount).w,d0
	cmp.w	(StatWork+$A).w,d0
	bge.w	.next
	move.w	d0,(StatWork+$A).w
	bra.w	.next
.entry
	move.w	#2,(printx).w
	move.w	d6,d0
	add.w	(SeasonGameCount).w,d0
	addq.w	#1,d0
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	move.w	#6,(printx).w
	movea.l	#LeaderPlayers,a0
	move.w	d6,d0
	add.w	(SeasonGameCount).w,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d0
	ext.l	d0
	divu.w	#RosterSlots,d0
	move.w	d0,d7
	swap	d0
	jsr	(FormatPlayerNameD7).l
	jsr	(print).l
	move.w	#$14,(printx).w
	movea.l	#TeamList,a1
	move.w	d7,d0
	asl.w	#2,d0
	movea.l	(a1,d0.w),a1
	adda.w	4(a1),a1
	adda.w	(a1),a1
	jsr	(print).l
	move.w	#$1D,(printx).w
	movea.l	#LeaderValues,a0
	move.w	d6,d0
	add.w	(SeasonGameCount).w,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d0
	cmpi.w	#3,(StatWork+2).w
	bne.w	.2
	ext.l	d0
	divu.w	#$64,d0
	swap	d0
	move.w	d0,-(sp)
	swap	d0
	move.w	#3,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l
	String	'.',$0
	move.w	(sp)+,d0
	move.w	#2,d1
	jsr	(PushNumberWidthZero).l
	bra.w	.3
.2
	move.w	#3,d1
	jsr	(PushNumberWidth).l
.3
	jsr	(print).l
.next
	addq.w	#1,(printy).w
	addq.w	#1,d6
	cmp.w	(StatWork+$8).w,d6
	blt.w	.row
	bra.w	rtsLeaderRows

rtsLeaderRows	;rts (DrawLeaderRows)
	rts

LeaderTables	;RAM tables (team order) per category for DrawLeaderRows
	dc.l	LeaderTeamTbls
	dc.l	LeaderTeamTbls+$1A
	dc.l	LeaderTeamTbls+$34
	dc.l	LeaderTeamTbls+$68
	dc.l	LeaderTeamTbls+$82
	dc.l	LeaderTeamTbls+$9C
	dc.l	LeaderTeamTbls+$B6

DrawLeaderLogo	;Draw small team logo d1 from Teamblocksmap at printx / printy. Saves all
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

BlankLine40	;String record (40 spaces) used by the League Leaders code
	String	'                                       ',0

LeadersHelp	;League Leaders footer: "[]=Change Stats  B=Individual Leaders", or "B=Team Leaders" in individual mode (StatWork set)
	movem.l	d0-d7/a0-a6,-(sp)
	tst.w	(StatWork).w
	beq.w	.0
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),2,$1A,0
	jsr	(printsmallz).l
	String	CC_SetFont,1,'[]=Change Stats       B=Team Leaders ',CC_SetFont,0,0
	bra.w	.1
.0
	jsr	(printz).l
	String	-(TXPRI+TXMAP1),2,$1A,0
	jsr	(printsmallz).l
	String	CC_SetFont,1,'[]=Change Stats  B=Individual Leaders',CC_SetFont,0,0
.1
	movem.l	(sp)+,d0-d7/a0-a6
	rts

orjoy4way	;Pads 1-4: d1 new presses, d3 held buttons
	jsr	(ReadJoy1).l
	move.w	d1,-(sp)
	move.w	d3,-(sp)
	jsr	(ReadJoy2).l
	or.w	(sp)+,d3
	or.w	(sp)+,d1
	tst.w	(FourWayPlay).w
	beq.w	.o4x
	move.w	d1,-(sp)
	move.w	d3,-(sp)
	jsr	(ReadJoy3).l
	or.w	(sp)+,d3
	or.w	(sp)+,d1
	move.w	d1,-(sp)
	move.w	d3,-(sp)
	jsr	(ReadJoy4).l
	or.w	(sp)+,d3
	or.w	(sp)+,d1
.o4x
	rts

PushNumberWidthZero	;PushNumberWidth with leading zeros
	movem.l	d0-d3,-(sp)
	movea.w	#(PushWidthBuf+2-M68K_RAM),a1
	moveq	#1,d2
	sub.w	d2,d1
	bra.w	.pnz1
.pnzpow
	mulu.w	#$A,d2
.pnz1
	dbf	d1,.pnzpow
	moveq	#$30,d3
.pnzdigit
	ext.l	d0
	divu.w	d2,d0
	bne.w	.pnznum
	cmp.w	#1,d2
	beq.w	.pnznum
	move.w	d3,d0
	bra.w	.pnzput
.pnznum
	moveq	#$30,d3
	add.w	d3,d0
.pnzput
	move.b	d0,(a1)+
	swap	d0
	divu.w	#$A,d2
	bne.s	.pnzdigit
	move.l	a1,d0
	subi.w	#(PushWidthBuf-M68K_RAM),d0
	btst	#0,d0
	beq.w	.pnz5
	clr.b	(a1)+
	addq.w	#1,d0
.pnz5
	movea.w	#(PushWidthBuf-M68K_RAM),a1
	move.w	d0,(a1)
	movem.l	(sp)+,d0-d3
	rts

PlayerStatsBgMap
	incbin	..\Extracted\NHL94\Season\PlayerStatsBgMap.map.jim
PlayerStatsTitleMap
	incbin	..\Extracted\NHL94\Season\PlayerStatsTitleMap.map.jim
