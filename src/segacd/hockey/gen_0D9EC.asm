ScoutParaOffset
	cmpi.w	#$1A,d0
	bne.s	.next3
	move.w	#$EA,d0
	cmpi.w	#$1A,(HomeTeam).l
	bge.s	.next
	add.w	(HomeTeam).l,d0
	bra.s	.next3
.next	cmpi.w	#$1A,(VisTeam).l
	bge.s	.next2
	addi.w	#$1A,d0
	bra.s	.next3
.next2	addi.w	#$1B,d0
.next3	movea.l	(ScoutingReportText).l,a1
	movea.l	a1,a2
	move.w	#$0,d1
	bra.w	.next4
.loop	addq.w	#$1,d1
.loop2	cmpi.b	#$D,(a2)+
	bne.w	.loop2
	cmpi.b	#$A,(a2)
	bne.w	.next4
	addq.l	#$1,a2
	cmpi.b	#$21,-$3(a2)
	beq.w	.loop
.next4	dbra	d0,.loop
	suba.l	a1,a2
	move.l	a2,d0
	rts
PageMatchup						;Page the matchup by d0 (+1 / -1, 0-6 wrapping), restart the page timer
	
	move.w	#$10E,(matchuptimer).l
	add.w	(matchup).l,d0
	bmi.w	.0
	cmpi.w	#$7,d0
	blt.w	.1
	clr.w	d0
	bra.w	.1
.0	move.w	#$6,d0
.1	move.w	d0,(matchup).l
	bsr.w	GetMatchupPlayers
	bsr.w	DrawMatchupPictures
	move.w	(ScoutSubStatus).l,d0
.loop	cmp.w	(ScoutSubStatus).l,d0
	beq.b	.loop
.loop2	btst	#$7,$FF800E.l
	bne.b	.loop2
	move.w	#$3C,$FF8020.l
	bset	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	beq.b	.loop3
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop4	btst	#$6,$FF800E.l
	bne.b	.loop4
	bclr	#$7,$FF800F.l
	bsr.w	PrintMatchupRatings
	rts
PrintMatchupRating						;Print the team rating of team a0 (GetTeamRating: the TeamRatings byte for
	
	
	
	bsr.w	PrintTwoSpaces
	move.l	a2,-(sp)
	movea.l	a0,a2
	bsr.w	GetTeamRating
	movea.l	(sp)+,a2
	move.l	d0,-(sp)
	move.w	#$2,d1
	jsr	(PushNumberWidth).l
	jsr	(printsmall).l
	move.l	(sp)+,d0
	rts
PrintTwoSpaces						;Print 2 spaces at printx / printy and keep printx
	move.l	a1,-(sp)
	move.w	(printx).l,-(sp)
	movea.l	#$28B22,a1
	jsr	(printsmall).l
	move.w	(sp)+,(printx).l
	movea.l	(sp)+,a1
	rts
TwoSpacesTxt						;A two space String (printsmall by PrintTwoSpaces)
TwoSpacesTxtTbl1	dc.w	$0004,$2020
ScoutRatingText						;rating names; only ' Overall ' is printed (PrintMatchupRatings, matchup
	
	dc.b	$00,$0A,'Shooting',$00,$0A,'Skat'
	dc.b	'ing',$00,$00,$0A,'Passing',$00,$00,$0A
	dc.b	'Defense',$00,$00,$0A,'Checki'
	dc.b	'ng',$00,$0A,'Fighting',$00,$0E,'Go'
	dc.b	'alkeeping',$00,$00,$12,'Powe'
	dc.b	'r Play Adv.',$00,$00,$1A,'- '
	dc.b	'   Home Team Adv'
	dc.b	'.    ',$00,$00,$12,'    Over'
	dc.b	'all     ',$FF,$FF
DrawMatchupPictures						;Draw the matchup's 6 x 6 pictures, visitors at x 2, home at x $20, y $F:
	
	
	
	movem.l	d0-d7/a0-a6,-(sp)
	tst.w	(matchup).l
	bne.w	.0
	move.w	(VisTeam).l,d3
	bsr.w	GetTeamLogo
	move.w	#$2,(printx).l
	move.w	#$F,(printy).l
	move.w	(vispicchars).l,d4
	move.w	#$4,d5
	move.w	#$6000,(printa).l
	bsr.w	DrawMatchupLogo
	move.w	(HomeTeam).l,d3
	bsr.w	GetTeamLogo
	move.w	#$20,(printx).l
	move.w	#$F,(printy).l
	move.w	(homepicchars).l,d4
	move.w	#$0,(printa).l
	move.w	#$2,d5
	bsr.w	DrawMatchupLogo
	move.w	#$64,(palcount).l
	bra.w	.x
.0	move.w	(VisTeam).l,d1
	move.w	(matchupvis).l,d0
	jsr	(DrawPlayerPicture).l
	move.w	#$2,(printx).l
	move.w	#$F,(printy).l
	move.w	(vispicchars).l,d4
	move.w	#$2,d5
	move.w	#$0,(printa).l
	bsr.w	DrawMatchupPicture
	move.w	(HomeTeam).l,d1
	move.w	(matchuphome).l,d0
	jsr	(DrawPlayerPicture).l
	move.w	#$20,(printx).l
	move.w	#$F,(printy).l
	move.w	(homepicchars).l,d4
	move.w	#$0,d5
	move.w	#$0,(printa).l
	bsr.w	DrawMatchupPicture
	move.w	#$64,(palcount).l
.x	movem.l	(sp)+,d0-d7/a0-a6
	rts
DrawMatchupPicture						;Draw player picture a0 at printx / printy with the PicturePalette
	
	
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	movea.l	#PicturePalette,a0
	adda.l	(a0),a0
	tst.l	(a2)
	bne.w	.0
	movea.l	#PicturePalette,a1
	adda.l	$4(a1),a1
	tst.l	(a2)+
	bra.w	.1
.0	adda.l	(a2)+,a1
.1	bsr.w	UnpackPicture
	movea.l	#picturebuf,a2
	bra.w	DrawMatchupBitmap
DrawMatchupLogo						;Draw team logo a0 at printx / printy, palette TeamLogoPalettes + team d3
	
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	asl.w	#$3,d3
	cmpi.w	#$4,d5
	beq.w	.0
	subi.w	#$20,d3
	bra.w	.1
.0	subi.w	#$40,d3
.1	movea.l	#TeamLogoPalettes,a0
	adda.w	d3,a0
	adda.l	(a2)+,a1
DrawMatchupBitmap						;6 x 6 dobitmap, then erase the 8 x 3 name area at y $19 on that side (x 2
	
	move.w	#$6,d3
	move.w	#$6,d2
	clr.w	d0
	clr.w	d1
	jsr	(dobitmap).l
	cmpi.w	#$14,(printx).l
	bgt.w	.0
	move.w	#$2,(printx).l
	bra.w	.1
.0	move.w	#$20,(printx).l
.1	move.w	#$19,(printy).l
	move.w	#$8,d0
	move.w	#$3,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	rts
GetTeamLogo						;Return a0 = the logo bitmap of team d3 (TeamLogoBitmaps table)
	asl.w	#$2,d3
	movea.l	(TeamLogoBitmaps).l,a0
	movea.l	(a0,d3.w),a0
	rts
PrintMatchupRatings						;Print the matchup ratings. Matchup 0: 'Overall' at y $13, the team
	
	
	
	
	
	
	
	tst.w	(matchup).l
	bne.w	.matchup
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$0,$1,$16,$16,CC_SetFont,$1
	lea.l	ScoutRatingText(pc),a1
	move.w	#$0,d7
.loop	move.w	(a1),d0
	asr.w	#$1,d0
	neg.w	d0
	addi.w	#$16,d0
	move.w	d0,(printx).l
	cmpi.w	#$9,d7
	beq.w	.0
	adda.w	(a1),a1
	bra.w	.1
.0	move.w	#$2,(printfontset).l
	move.w	(printy).l,-(sp)
	subi.w	#$3,(printy).l
	jsr	(printsmall).l
	move.w	(sp)+,(printy).l
.1	addi.w	#$1,d7
	tst.w	(a1)
	bpl.w	.loop
	move.w	#$2,(printfontset).l
	jsr	(printz).l
	String	CC_Font1,$0,$17,'                                        '
	jsr	(printz).l
	String	CC_Font1,$22,$16
	movea.l	#tmstruct,a0
	movea.l	#awtmstruct,a2
	bsr.w	PrintMatchupRating
	move.w	d0,(homerating).l
	move.w	#$2,(printfontset).l
	jsr	(printz).l
	String	CC_Font1,$4,$16
	exg.l	a0,a2
	bsr.w	PrintMatchupRating
	move.w	d0,(visrating).l
	bra.w	.ex
.matchup	move.w	(matchup).l,d0
	subi.w	#$1,d0
	movea.l	#$28F8E,a1
	bra.w	.next
.loop2	adda.w	(a1),a1
.next	dbra	d0,.loop2
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$0,$1,$D,$13,CC_SetFont,$1
	jsr	(printsmall).l
	move.w	#$16,(printy).l
	move.w	#$2,(printfontset).l
	movea.l	#tmstruct,a2
	move.l	(PAttribOverallMask).l,d4
	tst.w	(matchupslot).l
	bne.w	.4
	move.l	(GAttribOverallMask).l,d4
.4	move.w	(matchuphome).l,d0
	jsr	(printz).l
	String	CC_Font1,$0,$17,'                                        '
	jsr	(printz).l
	String	CC_Font1,$23,$17
	bsr.w	PrintPlayerNameRight
	bsr.w	CalcAttrib
	mulu.w	#$64,d0
	divu.w	d1,d0
	bsr.w	AttribAdjust
	move.w	#$2,d1
	move.w	d0,(homerating).l
	jsr	(PushNumberWidth).l
	jsr	(printz).l
	String	CC_Font1,$22,$16
	bsr.w	PrintTwoSpaces
	jsr	(printsmall).l
	movea.l	#awtmstruct,a2
	move.l	(PAttribOverallMask).l,d4
	tst.w	(matchupslot).l
	bne.w	.5
	move.l	(GAttribOverallMask).l,d4
.5	move.w	(matchupvis).l,d0
	jsr	(printz).l
	String	CC_Font1,$0,$17
	bsr.w	PrintPlayerNameRight
	bsr.w	CalcAttrib
	mulu.w	#$64,d0
	divu.w	d1,d0
	bsr.w	AttribAdjust
	move.w	d0,(visrating).l
	move.w	#$2,d1		;2 digits
	jsr	(PushNumberWidth).l
	jsr	(printz).l
	String	CC_Font1,$4,$16
	bsr.w	PrintTwoSpaces
	jsr	(printsmall).l
.ex	rts
MatchupPosNames						;Position names of matchups 1-6
MatchupPosNamesTbl1	dc.w	$0012,$2020
	move.l	-(a0),d0
	movea.l	-(a3),a0
	bcs.s	*+112
	moveq	#$65,d2
	moveq	#$20,d1
	move.l	-(a0),d0
	move.l	-(a0),d0
	dc.w	$0012,$206C
	bcs.s	*+104
	moveq	#$20,d2
	bne.s	*+113
	moveq	#$77,d1
	dc.w	$6172
	bcc.s	.next
	move.l	-(a0),d0
	dc.w	$0012,$2072
	bvs.s	*+105
	bvc.s	*+118
	movea.l	-(a6),a0
	ble.s	*+116
	dc.b	'ward  ',$00,$12,'left def'
	bcs.s	L2903E
.next
	dc.b	'seman ',$00,$12,'right de'
	dc.b	'fenseman',$00,$12,'     g'
	dc.b	'oalie     '
GetMatchupPlayers						;matchuphome / matchupvis = the home / visitors player of the matchup.
	
	movem.l	d0/a0-a1,-(sp)
	movea.l	#tmstruct,a0
	bsr.w	GetMatchupPlayer
	move.w	d0,(matchuphome).l
	movea.l	#awtmstruct,a0
	bsr.w	GetMatchupPlayer
	move.w	d0,(matchupvis).l
	movem.l	(sp)+,d0/a0-a1
	rts
GetMatchupPlayer						;Return d0 = the roster index of team a0's player for matchup: the first
	
	
	
	movea.l	$1E(a0),a0
	adda.w	$6(a0),a0
	move.w	(matchup).l,d0
	movea.l	#$29050,a1
	move.b	(a1,d0.w),d0
	ext.w	d0
L2903E	move.w	d0,(matchupslot).l
	move.b	(a0,d0.w),d0
	ext.w	d0
	subi.w	#$1,d0		;player numbers start at 1
	rts
MatchupLineSlots						;Line slot by matchup 0-6 (0 for the teams, then 4 center, 3 left forward,
	
	
MatchupLineSlotsTbl1	dc.w	$0004,$0305
	dc.w	$0102
	dc.l	$4279
	dc.w	$0001,$A448
	clr.w	(advframe).l
	rts
PrintAdvantageMarks						;Called every frame by ScoutingReport. Print the advantage marks at x $13,
	
	
	
	
	movem.l	d0-d7/a0-a6,-(sp)
	addi.w	#$1,(advcount).l
	cmpi.w	#$7,(advcount).l
	blt.w	.0
	clr.w	(advcount).l
	addi.w	#$1,(advframe).l
	cmpi.w	#$6,(advframe).l
	blt.w	.0
	move.w	#$5,(advframe).l
.0	move.w	(advframe).l,d1
	asl.w	#$2,d1
	movea.l	#$290FE,a1
	move.w	(homerating).l,d0
	cmp.w	(visrating).l,d0
	bgt.w	.1
	beq.w	.2
	movea.l	#$29116,a1
.1	movea.l	(a1,d1.w),a1
	bra.w	.3
.2	movea.l	#EvenAdvTxt,a1
.3	move.w	#$2,(printfontset).l
	jsr	(printz).l
	String	CC_Font1,$13,$16
	jsr	(printsmall).l
	move.w	#$0,(printfontset).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
HomeAdvMarks						;Home advantage marks, by advframe (0-5)
HomeAdvMarksTbl1	dc.w	$0002,$912E
	dc.w	$0002,$9134
	dc.w	$0002,$913A
	dc.w	$0002,$9140
	dc.w	$0002,$9140
	dc.w	$0002,$9140
VisAdvMarks						;Visitors advantage marks
VisAdvMarksTbl1	dc.w	$0002,$9146
	dc.w	$0002,$914C
	dc.w	$0002,$9152
	dc.w	$0002,$9158
	dc.w	$0002,$9158
	dc.w	$0002,$9158
HomeAdv0Txt						;home advantage marks: none
	dc.w	$0006,$2020
	move.l	d0,d0
HomeAdv1Txt						;home advantage: one mark
	dc.w	$0006,$5D20
	move.l	d0,d0
HomeAdv2Txt						;home advantage: two marks
	dc.w	$0006,$5D5D
	move.l	d0,d0
HomeAdv3Txt						;home advantage: three marks
	dc.w	$0006,$5D5D
	subq.b	#$6,d0
VisAdv0Txt						;visitors advantage marks: none
	dc.w	$0006,$2020
	move.l	d0,d0
VisAdv1Txt						;visitors advantage: one mark
	dc.w	$0006,$2020
	subq.b	#$5,d0
VisAdv2Txt						;visitors advantage: two marks
	dc.w	$0006,$205B
	subq.b	#$5,d0
VisAdv3Txt						;visitors advantage: three marks
	dc.w	$0006,$5B5B
	subq.b	#$5,d0
EvenAdvTxt						;Even teams
	dc.w	$0006,$2020
	move.l	d0,d0
GetTeamNickname						;The text player's '=' (a2 = tmstruct) and '*' (awtmstruct): return a1 =
	
	
	
	movem.l	d0/a0/a2,-(sp)
	movea.l	a2,a1
	movea.l	$1E(a1),a1
	adda.w	$4(a1),a1
	adda.w	(a1),a1
	adda.w	(a1),a1
	cmpi.w	#$2,(a1)
	bne.w	.next
	movea.l	#$2919A,a1
	cmpa.l	#$1834C,a2
	beq.w	.next
	movea.l	#$291A0,a1
.next	movem.l	(sp)+,d0/a0/a2
	rts
HomeTxt						;name used when the home team has no nickname
HomeTxtTbl1	dc.w	$0006,$486F
	blt.s	*+103
VisitorsTxt						;name used when the visiting team has no nickname
VisitorsTxtTbl1	dc.b	$00,$0A,'Visitors'
GetTeamArena						;The text player's '^' (a2 = tmstruct) and ';' (awtmstruct): return a1 =
	
	
	movem.l	d0/a0/a2,-(sp)
	movea.l	a2,a1
	movea.l	$1E(a1),a1
	adda.w	$4(a1),a1
	adda.w	(a1),a1
	adda.w	(a1),a1
	adda.w	(a1),a1
	movem.l	(sp)+,d0/a0/a2
	rts
ScoutStub						;An empty routine
	movem.l	d0-d7/a0-a6,-(sp)
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	movem.l	d0-d7/a0-a6,-(sp)
	bset	#$2,$17F6C.l
	jsr	(freezewindow).l
	move.w	#$60,$1AD72.l
	movea.l	#$17480,a3
	move.w	#$0,d0
	move.w	$1A416.l,d2
	cmp.w	$1A418.l,d2
	bgt.w	.next
	move.w	#$6,d0
.next	asl.w	#$7,d0
	adda.w	d0,a3
	move.w	#$4,d2
	move.w	#$6,d3
	bra.w	.next3
.loop	movem.w	d2-d3,-(sp)
	jsr	(SetPlayerSide).l
	move.w	#$2,$34(a3)
	move.w	#$F0,d0
	tst.w	$17CEA.l
	bmi.w	.next2
	move.w	#$FF10,d0
.next2	add.w	$17CEA.l,d0
	move.w	d0,$14(a3)
	move.w	#$0,$0(a3)
	move.w	#$7,d0
	jsr	(AssistListPush).l
	bclr	#$5,$62(a3)
	bclr	#$1,$63(a3)
	bclr	#$2,$62(a3)
	movem.w	(sp)+,d2-d3
.next3	adda.l	#$80,a3
	dbra	d2,.loop
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ClampPositionBox						;Unreferenced. Clamp temp3 / temp4(a3) to the box for position(a3) in
									;PositionBoxes (PositionBoxesTop when bit 7 of
									;pflags(a3), the top net)
	movem.l	d0-d7/a0,-(sp)
	move.w	$34(a3),d7
	subi.w	#$1,d7		;position 1 is entry 0
	movea.l	#$292E2,a0
	btst	#$7,$62(a3)		;which net?
	beq.w	.next
	movea.l	#$292F2,a0
.next	add.w	d7,d7		;word per position
	move.w	(a0,d7.w),d0		;X min of the box
	cmp.w	$44(a3),d0
	blt.w	.next2
	move.w	d0,$44(a3)		;clamp to the left
.next2	move.w	$2(a0,d7.w),d0		;X max of the box
	cmp.w	$44(a3),d0
	bgt.w	.next3
	move.w	d0,$44(a3)		;clamp to the right
.next3	move.w	$4(a0,d7.w),d0		;Y min of the box
	cmp.w	$46(a3),d0
	blt.w	.next4
	move.w	d0,$46(a3)		;clamp to the bottom
.next4	move.w	$6(a0,d7.w),d0		;Y max of the box
	cmp.w	$46(a3),d0
	bgt.w	.next5
	move.w	d0,$46(a3)		;clamp to the top
.next5	movem.l	(sp)+,d0-d7/a0
	rts
ClampPositionBoxTbl1	dc.w	$FFB5,$0000,$0000,$0108,$0000,$004B,$0000,$0108
ClampPositionBoxTbl2	dc.w	$FFB5,$0000,$FEF8,$0000,$0000,$004B,$FEF8,$0000
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#$1A414,a0
	move.l	#$12,d0
.loop	clr.w	(a0)+
	dbra	d0,.loop
	movea.l	#tmstruct,a0
	move.w	#$365,d0
.loop2	clr.w	(a0)+
	dbra	d0,.loop2
	movea.l	#$18022,a0
	move.l	#$24,d0
.loop3	clr.w	(a0)+
	dbra	d0,.loop3
	clr.w	$17F70.l
	clr.w	$17F72.l
	clr.w	(sflags6).l
	clr.w	$17F78.l
	clr.w	$19390.l
	clr.w	$193A0.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
AddArenaAnimSprite						;Add the frame arenaframe of the arena animation (sprite list
									;arenaspritelist, see RunArenaAnim) to the sprite table a6 (d6 sprites, 64
									;at most) for the pieces inside the view (Hpos / Vpos). Not in a reverse
									;angle replay (sflags4 bit 4), sflags2 bit 3 or sflags bit 7. Called from
									;setvideo
	tst.w	$1A556.l
	bmi.w	AddArenaAnimSpriteExit
	tst.l	$1A55C.l
	beq.w	AddArenaAnimSpriteExit		;not loaded: none
	btst	#$4,$17F72.l		;check if reverse angle replay
	bne.w	AddArenaAnimSpriteExit
	btst	#$3,$17F6C.l
	bne.w	AddArenaAnimSpriteExit		;replay: none
	btst	#$7,$17F6A.l
	bne.w	AddArenaAnimSpriteExit		;horizontal mode: none
	movea.l	$1A55C.l,a1
	adda.l	$4(a1),a1
	move.w	$17CEE.l,d4
	move.w	$17CEA.l,d5
	move.w	$1A550.l,d0
	bra.w	.next
	dc.w	$0242,$000F,$0C42,$0003,$6300,$0004,$7403,$6000
	dc.w	$000A,$3003,$D042,$6100,$0008,$51CA,$FFF6,$4E75
.next
	ext.w	d0
	beq.w	AddArenaAnimSpriteExit
	cmpi.w	#$40,d6
	bge.w	AddArenaAnimSpriteExit
	movem.l	d0-d5,-(sp)
	add.w	d0,d0
	movea.l	a1,a0
	move.w	$2(a0,d0.w),d1
	sub.w	(a0,d0.w),d1
	lsr.w	#$3,d1
	subi.w	#$1,d1
	move.w	d1,-(sp)
	adda.w	(a0,d0.w),a0
	move.w	d4,d0
	addi.w	#$C0,d0
	move.w	d0,d1
	subi.w	#$90,d0
	addi.w	#$80,d1
	move.w	#$170,d2
	sub.w	d5,d2
	move.w	d2,d3
	subi.w	#$80,d2
	addi.w	#$70,d3
	move.w	(sp)+,d4
.loop	cmp.w	$2(a0),d2
	bgt.w	.next2
	cmp.w	$2(a0),d3
	blt.w	.next2
	cmp.w	(a0),d0
	bgt.w	.next2
	cmp.w	(a0),d1
	blt.w	.next2
	move.w	$2(a0),d5
	addi.w	#$70,d5
	sub.w	d2,d5
	move.w	d5,(a6)+
	move.b	$7(a0),(a6)+
	move.b	d6,(a6)+
	move.w	$6(a0),d5
	andi.w	#$F800,d5
	add.w	$4(a0),d5
	add.w	$1A54E.l,d5
	move.w	d5,(a6)+
	move.w	(a0),d5
	addi.w	#$70,d5
	sub.w	d0,d5
	move.w	d5,(a6)+
	addi.w	#$1,d6
	cmpi.w	#$40,d6
	beq.w	.next3
.next2	adda.w	#$8,a0
	dbra	d4,.loop
.next3	movem.l	(sp)+,d0-d5
AddArenaAnimSpriteExit
	rts
PrintPlayerNameRight						;Print the name of player d0 of team a2 (FormatPlayerName), moved left so
									;it ends before column $29 (a trailing pad byte or
									;two not counted), then the icon of HotColdIcon. Called from
									;PrintMatchupRatings
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	d0,$1AD8A.l
	move.l	a2,-(sp)
	jsr	(FormatPlayerName).l
	movea.l	a1,a0
	move.w	(a0),d0
	move.w	d0,d5
	tst.b	-$1(a0,d5.w)		;trailing pad byte?
	bne.w	.next
	subi.w	#$1,d0		;first pad byte
	tst.b	-$2(a0,d5.w)		;second pad byte?
	bne.w	.next
	subi.w	#$1,d0		;second pad byte
.next	add.w	(printx).l,d0
	subi.w	#$29,d0		;past column $29?
	bmi.w	.next2		;fits: leave printx
	neg.w	d0
	add.w	d0,(printx).l
.next2	movea.l	a0,a1
	jsr	(print).l
	movea.l	(sp)+,a2
	jsr	(HotColdIcon).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
