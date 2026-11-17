SkipNameNumber						;Unreferenced. A1 = the FormatPlayerNumInitial String without its first 2
	
	movem.l	d0-d7/a0/a2-a3,-(sp)
	jsr	(FormatPlayerNumInitial).l
	move.w	(a1),d0
	subi.w	#$2,d0
	move.w	d0,$2(a1)
	adda.w	#$2,a1
	movem.l	(sp)+,d0-d7/a0/a2-a3
	rts
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_0E508.bin
StatsReport						;"Game Statistics" menu item (menu lists): both
	
	
	
	moveq	#$9,d0
	moveq	#$1A,d1
	jsr	(Sub_2E728).l
	jsr	(printz).l
	String	CC_Font3Pri,$4,$1
	moveq	#$20,d0
	moveq	#$6,d1
	jsr	(Framer).l
	jsr	(printbigz).l
	String	CC_Font3Pri,$6,$4,'Game  Statistics',CC_Font3Pri,$7,$1
	move.w	#$2C,d0
	jsr	(Sub_2C59E).l
	addi.w	#$4,(printx).l
	clr.w	d0
	jsr	(Sub_2C59E).l
	clr.w	(scoutcolumn).l
	clr.w	(VertLineScrolling).l
	clr.w	(PlayerScrollCtr).l
	move.w	#$70,(matchupvis).l
	dc.w	$4A79,$0001,$8C08
	bne.w	.0
	move.w	#$30,(matchupvis).l
.0	bsr.w	DisplayStats
	bsr.w	LEC3E
.loop	jsr	(MenuWaitVblank).l
	jsr	(Sub_2F2F0).l
	btst	#$7,d3
	beq.w	.1
	jmp	(Sub_2E980).l
.1	jsr	(nodiag).l
	move.w	#$FFFE,d0
	btst	#$0,d3
	bne.w	.2
	neg.w	d0
	btst	#$1,d3
	beq.w	.3
.2	move.w	d0,(PlayerScrollCtr).l
.3	bsr.w	.scroll
	bsr.w	LEC3E
	bra.w	.loop
.scroll	move.w	(PlayerScrollCtr).l,d0
	beq.w	rtsStatTables
	add.w	(VertLineScrolling).l,d0
	bmi.w	rtsStatTables
	cmp.w	(matchupvis).l,d0
	bgt.w	rtsStatTables
	move.w	(VertLineScrolling).l,d1
	move.w	d0,(VertLineScrolling).l
	andi.w	#$F,d0
	bne.w	.5
	clr.w	(PlayerScrollCtr).l
.5	andi.w	#$F,d1
	bne.w	LEB5E
	move.w	d0,-(sp)
	cmpi.w	#$E,d0
	bne.w	.6
	bsr.w	LEC20
.6	move.w	(sp)+,d0
	cmpi.w	#$2,d0
	bne.w	LEB5E
	bsr.w	LEC2C
LEB5E	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movea.l	#$C00000,a0
.lEB72	btst	#$7,$FF800E.l
	bne.b	.lEB72
	move.l	#$40020010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset	#$6,$FF800F.l
.lEB96	btst	#$6,$FF800E.l
	beq.b	.lEB96
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.lEBB0	btst	#$6,$FF800E.l
	bne.b	.lEBB0
	bclr	#$7,$FF800F.l
	move.w	#$FFB0,d0
	add.w	(VertLineScrolling).l,d0
.lEBCC	btst	#$7,$FF800E.l
	bne.b	.lEBCC
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset	#$6,$FF800F.l
.lEBEC	btst	#$6,$FF800E.l
	beq.b	.lEBEC
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.lEC06	btst	#$6,$FF800E.l
	bne.b	.lEC06
	bclr	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	rts
LEC20	move.w	(VertLineScrolling).l,d3
	lsr.w	#$4,d3
	bra.w	LEC3C
LEC2C	move.w	(VertLineScrolling).l,d3
	lsr.w	#$4,d3
	addi.w	#$6,d3
	bra.w	LEC3C
LEC3C	rts
LEC3E	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printsmallz).l
	String	CC_SetFont,$1
	tst.w	(VertLineScrolling).l
	beq.w	.lEC6A
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,$26,$8,CC_SetFont,$1,'{'
	bra.w	.lEC7A
.lEC6A	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,$26,$8,CC_SetFont,$1,' '
.lEC7A	move.w	(matchupvis).l,d0
	cmp.w	(VertLineScrolling).l,d0
	beq.w	.lEC9E
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,$26,$1A,CC_SetFont,$1,'}'
	bra.w	.lECAE
.lEC9E	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,$26,$1A,CC_SetFont,$1,' '
.lECAE	jsr	(printsmallz).l
	String	CC_SetFont
	movem.l	(sp)+,d0-d7/a0-a6
	rts
DisplayStats						;Team logos (PutTeamBlock), then each
	
	
	
	jsr	(printz).l
	String	CC_Font3Pri,$2,$7
	move.w	#$2C,d0
	jsr	(Sub_2C59E).l
	jsr	(printz).l
	String	CC_Font3Pri,$1A,$7
	moveq	#$0,d0
	jsr	(Sub_2C59E).l
	bsr.w	LEB5E
	jsr	(printz).l
	String	CC_Font2Pri,$0,$0
	moveq	#$E,d6
	dc.w	$43FA,$015A
	dc.w	$4A79,$0001,$8C08
	bne.w	.row
	move.w	#$A,d6
	dc.w	$43FA,$0236
.row	move.w	(a1),d0
	lsr.w	#$1,d0
	neg.w	d0
	addi.w	#$15,d0
	move.w	d0,(printx).l
	jsr	(print).l
	movea.l	a1,a0
	move.w	#$22,(printx).l
	movea.l	#tmstruct,a2
	bsr.w	PrintStatValue
	move.w	#$9,(printx).l
	lea.l	$366(a2),a2
	bsr.w	PrintStatValue
	lea.l	$4(a0),a1
	addi.w	#$2,(printy).l		;2 map rows per table row
	dbra	d6,.row
	rts
PrintStatValue						;Print TeamStatTextTbl entry a0 for team a2 centred at printx: the value
	
	
	
	movea.l	#mesarea,a3
	move.w	#$2,(a3)
	cmpi.w	#$FFFF,(a0)
	bne.w	.1
	move.w	#$C,d0
	move.w	(a2,d0.w),d0
	mulu.w	#$64,d0
	move.w	#$0,d1
	move.w	(a2,d1.w),d1
	beq.w	.0
	divu.w	d1,d0
.0	jsr	(PushNumber).l
	jsr	(appstring).l
	jsr	(Sub_39200).l
	String	'%'
	bra.w	.6
.1	move.w	(a0),d0
	move.w	(a2,d0.w),d0
	cmpi.w	#$354,(a0)
	bne.w	.2
	bsr.w	.lEE50
	bra.w	.4
.2	cmpi.w	#$A,(a0)
	beq.w	.3
	bsr.w	.lEE4A
.3	cmpi.w	#$A,(a0)
	bne.w	.4
	bsr.w	.lEE50
.4	jsr	(appstring).l
	move.w	$2(a0),d0
	bmi.w	.6
	jsr	(Sub_39200).l
	String	'/'
	move.w	(a2,d0.w),d0
	jsr	(PushNumber).l
	jsr	(appstring).l
	cmpi.w	#$14,(a0)
	bne.w	.6
	jsr	(Sub_39200).l
	String	' ('
	move.w	(a0),d0
	move.w	(a2,d0.w),d0
	mulu.w	#$64,d0
	move.w	$2(a0),d1
	move.w	(a2,d1.w),d1
	beq.w	.5
	divu.w	d1,d0
.5	jsr	(PushNumber).l
	jsr	(appstring).l
	jsr	(Sub_39200).l
	String	'%)'
.6	movea.l	a3,a1
	move.w	(a1),d0
	lsr.w	#$1,d0
	sub.w	d0,(printx).l
	jmp	(print).l
.lEE4A	jmp	(PushNumber).l
.lEE50	jmp	(PushTime).l
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_0EE56.bin
rtsStatTables
	rts
updatePPTeamTime						;One more second of power play time (tmPwrPlayTime) for the team
	
	
	btst	#$5,$17F6C.l
	beq.w	.x
	movea.l	#tmstruct,a2
	btst	#$6,$17F6C.l
	beq.w	.0
	movea.l	#awtmstruct,a2
.0	addi.w	#$1,$354(a2)		;one more second of power play time
.x	rts
GetTeamRating						;d0 = the TeamRatings byte of team tmteam(a2). Called from PrintTeamRating
	
	movem.l	d1-d7/a0-a6,-(sp)
	move.w	$2A(a2),d0
	movea.l	#$2A040,a0
	clr.w	d1
	move.b	(a0,d0.w),d1
	move.w	d1,d0
	movem.l	(sp)+,d1-d7/a0-a6
	rts
	dc.w	$334C,$494B,$4E43,$4B43,$3442,$4A49,$4442,$4A37
	dc.w	$454B,$4738,$4538,$4847,$4846,$5B59
ShortenMsgTimer						;Cap msgtimer at 2, unless a second pad is on (cont2team) and a3 is not
	
	movem.l	d0,-(sp)
	dc.w	$4A79,$0001,$7FA8
	beq.w	.0
	move.w	$52(a3),d0
	cmp.w	$17BE0.l,d0
	bne.w	.x
.0	cmpi.w	#$2,$17F98.l
	ble.w	.x
	move.w	#$2,$17F98.l
.x	movem.l	(sp)+,d0
	rts
ManualGoalieMenu						;"x Manual Goalie" menu item (menu lists; PrintMenuItem prints Manual /
	
	
	
	
	
	
	movem.l	d0-d7/a0-a6,-(sp)
	tst.w	(OptNOP).l
	beq.w	.chkso
	dc.w	$3039,$0001,$7FA6
	dc.w	$B079,$0001,$7FA8
	bne.w	.0
	dc.w	$0A79,$0001,$0001,$8C0E
	bra.w	.lF0D4
.0	btst	#$1,$17F6A.l
	beq.w	.lF0D4
	dc.w	$0A79,$0001,$0001,$8C0E
	bra.w	.chkso
.lF0D4	dc.w	$0A79,$0001,$0001,$8C0C
.chkso	btst	#$0,$17F78.l
	bne.w	.so
	btst	#$2,$17F70.l
	beq.w	.x
.so	btst	#$1,$17F6A.l
	bne.w	.p2
	cmpi.w	#$2,(OptNOP).l
	bne.w	.lF11C
	dc.w	$0C79,$0005,$0001,$9368
	bgt.w	.x
	bra.w	.5
.lF11C	dc.w	$0C79,$0005,$0001,$9368
	ble.w	.x
.5	move.w	#$0,d0
	cmpi.w	#$2,(OptNOP).l
	bne.w	.lF13C
	move.w	#$6,d0
.lF13C	dc.w	$4A79,$0001,$8C0C
	bne.w	.set1
	move.w	#$5,d0
	cmpi.w	#$2,(OptNOP).l
	bne.w	.set1
	move.w	#$B,d0
.set1	jsr	(setc1player).l
	bra.w	.x
.p2	cmpi.w	#$2,(OptNOP).l
	bne.w	.lF180
	dc.w	$0C79,$0005,$0001,$9368
	ble.w	.x
	bra.w	.lF18C
.lF180	dc.w	$0C79,$0005,$0001,$9368
	bgt.w	.x
.lF18C	move.w	#$6,d0
	dc.w	$4A79,$0001,$8C0E
	bne.w	.set2		;manual: the goalie
	move.w	#$B,d0		;skater slot
.set2	jsr	(setc2player).l
.x	movem.l	(sp)+,d0-d7/a0-a6
	rts
RunArenaAnim						;Run the arena animation arenaanim (negative: none): the first time, its
									;frame list and graphics from ArenaAnims
									;(arenaframelist / arenaspritelist, tiles to VRAM d4 = arenaanimchars:
									;DecompressGraphicsPlain); then count down the frame time arenaframetime
									;by d7 and step (NextArenaFrame). Called from periodicevents and waitxsr
	dc.w	$4A79,$0001,$A556
	bmi.w	.lF21C
	movem.l	d0-d7/a0-a6,-(sp)
	dc.w	$4AB9,$0001,$A55C
	bne.w	.lF202
	dc.w	$3039,$0001,$A556
	asl.w	#$3,d0
	movea.l	#$2A26C,a0
	dc.w	$23F0,$0000,$0001,$A558
	dc.w	$23F0,$0004,$0001,$A55C
	movea.l	$4(a0,d0.w),a2
	adda.w	#$8,a2
	dc.w	$3839,$0001,$A54E
	jsr	(DecompressGraphicsPlain).l
	dc.w	$4279,$0001,$A552
	bsr.w	NextArenaFrame
	bra.w	.lF218
.lF202	dc.w	$9F79,$0001,$A554
	bpl.w	.lF218
	dc.w	$0679,$0001,$0001,$A552
	bsr.w	NextArenaFrame		;read the next frame
.lF218	movem.l	(sp)+,d0-d7/a0-a6
.lF21C	rts
NextArenaFrame						;Read frame arenaframeidx of the list: arenaframe = frame, arenaframetime
									;= time; frame $FF loops to the start, $FE ends the animation
									;(EndArenaAnim)
	dc.w	$2079,$0001,$A558
	dc.w	$3039,$0001,$A552
	add.w	d0,d0		;2 bytes per entry
	move.b	(a0,d0.w),d1		;frame byte
	ext.w	d1
	dc.w	$33C1,$0001,$A550
	move.b	$1(a0,d0.w),d1
	ext.w	d1
	dc.w	$33C1,$0001,$A554
	dc.w	$0C79,$FFFF,$0001,$A550
	bne.w	.lF25A
	dc.w	$4279,$0001,$A552
	bra.w	NextArenaFrame
.lF25A	dc.w	$0C79,$FFFE,$0001,$A550
	bne.w	.lF26A
	bsr.w	EndArenaAnim		;$FE: end the animation
.lF26A	rts
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_0F26C.bin
StartArenaAnim						;Start arena animation d0 (ArenaAnims): arenaanim = d0, RunArenaAnim loads
									;it. Called from FallDown (7)
									;ShowGoalBox (0 on a home hat trick) and puckfaceoff2 (the one
									;SetFaceoffAnim set)
	movem.l	d0-d7/a0-a6,-(sp)
	dc.w	$33C0,$0001,$A556
	dc.w	$23FC,$0000,$0000,$0001,$A558
	dc.w	$23FC,$0000,$0000,$0001,$A55C
	dc.w	$33FC,$0001,$0001,$A550
	dc.w	$4279,$0001,$A552
	dc.w	$50F9,$0001,$A560
	movem.l	(sp)+,d0-d7/a0-a6
	rts
SetFaceoffAnim						;Set the faceoff animation: sflags7 bit 0, faceoffanim = d0. Called from
									;puckfaceoff
	bset	#$0,$17F7A.l
	dc.w	$33C0,$0001,$A560
	rts
EndArenaAnim
	dc.w	$33FC,$FFFF,$0001,$A556
	bclr	#$0,$17F7A.l
	rts
ChooseSong						;SongNum = byte SongIndex of the 6 song bytes of team HmTeam, or one of
									;the 8 of RandomSongs at random when 0; $FFFF with gmode bit 4. Called
									;from StartPer, checkgoal, puckshootout and LeadSong
	movem.l	d0-d1/a0-a1,-(sp)
	btst	#$4,$17F68.l		;highlight reel?
	beq.w	.lF490		;not the highlight reel: pick a song
	move.w	#$FFFF,d1		;highlights: no song
	bra.w	.lF4D0
.lF490	bclr	#$6,$17F7C.l		;clear sflags8 bit 6
	dc.w	$207C,$0002,$A4DC
	movea.l	#$2A584,a1
	dc.w	$3039,$0001,$A56C
	mulu.w	#$6,d0
	dc.w	$D079,$0001,$A56E
	clr.w	d1
	move.b	(a0,d0.w),d1		;team song
	bne.w	.lF4D0		;a team song: use it
	move.w	#$8,d0		;slot 0: one of the 8 random songs
	jsr	(randomd0).l
	andi.w	#$7,d0
	move.b	(a1,d0.w),d1
.lF4D0	dc.w	$33C1,$0001,$A56A
	movem.l	(sp)+,d0-d1/a0-a1
	rts
TeamSongs						;ChooseSong: 6 songs per team (TeamList order), 0 = random (RandomSongs)
	dc.w	$7775
