;	Scouting report. This file shows the pregame matchups screen with its pages of team text,
;	ratings, pictures and positions, and marks which team has the advantage.

ScoutCrowdRecord					;The text player's '@' (ScoutTextPlayer): return a1 = the home team's
									;crowd record in dB as a String at TempBuffer (SRAM team record crpeak, 80
									;if 0). ReadCrowdRecord reads the 16 byte SRAM record of team d1
									;(CrowdRecBase + d1 * 16) to a0
	movem.l	d0-d7/a0/a2-a6,-(sp)	;save
	move.w	(HomeTeam).w,d1			;home team
	ext.l	d1						;long
	movea.l	#teamrecbuf,a0			;SRAM team record buffer
	move.l	a0,-(sp)				;save the buffer
	jsr	(ReadCrowdRecord).l			;read the HomeTeam record
	movea.l	(sp)+,a0				;restore it
	movea.l	#TempBuffer,a1			;String buffer
	clr.w	d0						;clear
	move.b	crpeak(a0),d0			;crowd record
	bne.w	.0
	move.b	#$50,d0					;none saved: 80 dB
.0									;crowd record ready
	move.l	a1,-(sp)				;save
	jsr	(AppendNumber).l			;d0 as a decimal String at a1
	movea.l	(sp)+,a1				;restore
	movem.l	(sp)+,d0-d7/a0/a2-a6	;restore
	rts								;return
ScoutCrowdRecordBy					;unused: return a1 = 'by <name> ' for the home team's crowd record (SRAM
									;record crpeakuser = name number, AppendUserName reads that 12 char name
									;from namelog), or an empty String if crpeakuser is 0
	movem.l	d0-d7/a0/a2-a6,-(sp)	;save
	move.w	(HomeTeam).w,d1			;home team
	ext.l	d1						;long
	movea.l	#teamrecbuf,a0			;SRAM team record buffer
	move.l	a0,-(sp)				;save the buffer
	jsr	(ReadCrowdRecord).l			;read the HomeTeam record
	movea.l	(sp)+,a0				;restore it
	tst.b	crpeakuser(a0)			;name number
	beq.w	.0
	movea.l	#ThreeStars,a3			;String buffer
	movea.l	#ScoutByTxt,a1
	move.l	a3,-(sp)				;save
	jsr	(CopyString).l				;copy the String at a1 to a3: 'by '
	movea.l	(sp)+,a3				;restore
	clr.w	d2						;clear
	move.b	crpeakuser(a0),d2		;name number
	movea.l	#TempBuffer,a1			;name String buffer
	bset	#7,(sflags6).w
	bsr.w	AppendUserName			;name String
	jsr	(appstring).l				;append the name
	movea.l	#ScoutSpaceTxt,a1
	jsr	(appstring).l				;and ' '
	movea.l	a3,a1					;a1 = 'by <name> '
	bra.w	.x
.0									;no name: empty text
	movea.l	#ScoutEmptyTxt,a1
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0/a2-a6
	rts								;return
ScoutEmptyTxt	String	''			;empty String: no name number in the crowd record
ScoutByTxt	String	'by '			;start of the "by <name> " String
ScoutSpaceTxt	String	' '			;space after the name
GetTeamCity							;unused: return a1 = the city String of team byte tmATOP(a0) (TeamList,
									;Teamname offset)
	movem.l	d0-d7/a0/a2-a6,-(sp)	;save
	clr.w	d2						;clear
	move.b	$A(a0),d2				;team number
	asl.w	#2,d2					;long index
	movea.l	#TeamList,a1			;team table
	movea.l	0(a1,d2.w),a1			;team data
	adda.w	Teamname(a1),a1			;team name String
	movem.l	(sp)+,d0-d7/a0/a2-a6	;restore
	rts								;return
ScoutingReport						;pregame MATCHUPS screen, called from Opening2. Draws the Ron Barr
									;picture, the text box and the matchup
									;matchup 0 is both team logos with the team ratings, 1-6 the two players
									;at center, left forward, right forward, left defense, right defense and
									;goalie with their ratings, with marks toward the side that has the
									;advantage. The text player (ScoutTextPlayer) types the paragraph list. A
									;/ C page the matchups (the page also turns by itself about every $10E
									;frames), down types fast, start leaves
	jsr	(ReadNameLog).l				;read the $80 byte SRAM name list at NameLogBase to namelog
	jsr	(BuildHotColdLists).l		;hot / cold players for the text
	clr.w	(advframe).w			;advantage mark frame
	move.w	#SngScouting,-(sp)		;song $7A
	jsr	(song).l
	move.l	#vb2,(VBint).w
	jsr	(clearTeamStats).l			;clear the game stats
	move.l	a0,-(sp)				;save
	movea.l	#tmstruct,a0			;home team struct
	jsr	(Create_HotCold_Table).l	;new random hot / cold tables (end of the team structs)
	movea.l	#AwShots,a0				;away team struct
	jsr	(Create_HotCold_Table).l	;its tables
	movea.l	(sp)+,a0				;restore
	jsr	(BuildHotColdLists).l		;again with the new tables
	bclr	#df32c,(disflags).w		;40 cell mode
	move.w	#6,(Map1col).w			;map 1 width
	move.w	#6,(Map2col).w			;map 2 width
	move.w	#0,d0					;fade to color
	jsr	(setVram).l
	move.w	#2,d4					;vram chars from 2
	move.w	d4,(homepicchars).w		;home picture chars (6 x 6)
	addi.w	#$24,d4					;$24 chars on
	move.w	d4,(vispicchars).w		;visitors picture chars
	addi.w	#$24,d4					;$24 chars on
	move.w	d4,(BigFontchars).w		;big font chars
	movea.l	#BigFontMap+8,a2		;big font tiles
	jsr	(DecompressGraphicsWithCallback).l
	dc.l	$05431567,$79ABCDEF		;remap table
	jsr	(AddSmallFont).l			;in the table
	move.w	d4,(smallfont2chars).w	;1st vram char of the 2nd small font set
	movea.l	#SmallFontMap+8,a2		;small font tiles (as AddSmallFont), remapped
	jsr	(DecompressGraphicsWithCallback).l
	dc.l	$0A234567,$89ABCDEF		;remap table
	movea.l	#FramerMap+8,a2			;framer tiles (as AddFramer), remapped
	move.w	d4,(framercset).w
	jsr	(DecompressGraphicsWithCallback).l	;send them
	dc.l	$05422561,$89ABCDEF		;remap table
	jsr	(printz).l
	String	-TXMAP2,0,0
	movea.l	#ScoutMap,a0			;the jsr, the string and this (ori.b x4)
	movea.l	a0,a1					;a1 = map header
	movea.l	a0,a2					;a2 = offsets
	adda.l	(a2)+,a0				;a0 = palette
	adda.l	(a2)+,a1				;a1 = map data
	clr.w	d0						;x 0
	clr.w	d1						;y 0
	moveq	#$28,d2					;40 x 28 background
	moveq	#$1C,d3
	moveq	#3,d5					;color fam 1-2
	jsr	(dobitmap).l				;draw it
	jsr	(printbigz).l
	String	-(TXPAL2+TXMAP1),$C,$D,'MATCHUPS'
	move.w	#0,(printfontset).w		;char set 0
	jsr	(printz).l					;map at the header
	String	-TXMAP1,$10,$11,'ADVANTAGE:'
	jsr	(printz).l					;map at the box
	String	-(TXPAL2+TXMAP2),6,3
	moveq	#$21,d0					;33 x 9 text box frame
	moveq	#9,d1
	jsr	(Framer).l
	jsr	(printz).l					;map at the visitors picture
	String	-(TXPAL2+TXMAP2),1,$E	;(and dropped a word)
	move.w	#8,d0					;8 x 8 frame: visitors picture
	move.w	#8,d1
	jsr	(Framer).l
	jsr	(printz).l					;map at the home picture
	String	-(TXPAL2+TXMAP2),$1F,$E	;(and dropped a word)
	move.w	#8,d0					;8 x 8 frame: home picture
	move.w	#8,d1
	jsr	(Framer).l
	jsr	(printz).l					;map at Ron Barr
	String	-TXMAP1,1,1
	movea.l	#RonBarrMap,a0			;Ron Barr picture: palette offset, then map header offset
	movea.l	a0,a1					;a1 = map header
	movea.l	a0,a2					;a2 = offsets
	adda.l	(a2)+,a0				;a0 = palette
	adda.l	(a2)+,a1				;a1 = map data
	clr.w	d0						;x 0
	clr.w	d1						;y 0
	move.w	(a1),d2					;width
	move.w	mapheight(a1),d3		;height
	moveq	#$C,d5					;color fam 3-4
	jsr	(dobitmap).l				;draw it
	movea.l	#HotIconMap+8,a2		;hot icon tiles
	move.w	d4,(hoticonchars).w		;tiles: 1st vram char
	jsr	(DecompressGraphicsPlain).l	;send them
	movea.l	#ColdIconMap+8,a2		;cold icon tiles
	move.w	d4,(coldiconchars).w	;tiles: 1st vram char
	jsr	(DecompressGraphicsPlain).l	;send them
	clr.w	(matchup).w				;matchup 0: the teams
	clr.w	(scoutunused).w
	move.w	#$10D,(matchuptimer).l	;frames to the next matchup
	bsr.w	GetMatchupPlayers		;the matchup players
	bsr.w	DrawMatchupPictures		;pictures
	bsr.w	PrintMatchupRatings		;ratings
	move.w	#$18,(palcount).w		;24
	move.l	#vb2,(VBint).w			;vblank routine
	move	#$2500,sr				;interrupts on
	jsr	(InitScoutingDisplay).l		;a0 = the paragraph list
	move.w	#$1B,(a0)+				;paragraph numbers in ScoutTextScript: 'Hi, I'm Ron Barr ...'
	move.w	#$1D,(a0)+				;empty paragraph: a blank line
	move.w	#$1A,(a0)+				;'Welcome to a sold out ^ ...'
	move.w	#$1D,(a0)+				;blank line
	jsr	(CompareHotColdTotals).l	;d0 = $22 / $23 ('Lately $ has been playing (extremely) well.') when the
									;team totals (GetHotColdTotal) differ by $5E / $BD or more, else -1
	tst.w	d0						;any?
	bmi.w	.0						;no
	move.w	d0,(a0)+				;add it
	move.w	#$1D,(a0)+				;blank line
.0									;hot / cold paragraphs
	move.w	(HomeTeam).w,d0			;home team
	move.w	#$1E,(a0)+				;home hot / cold player
	move.w	#$1D,(a0)+
	cmp.w	(VisTeam).w,d0
	beq.w	.1						;same team: one hot / cold paragraph
	move.w	#$1F,(a0)+				;visitors hot / cold player
.1									;crowd record paragraph
	move.w	#$1D,(a0)+				;blank line
	move.w	#$20,(a0)+				;'The ^ crowd record is @ dB.'
	move.w	#$1D,(a0)+				;blank line
	move.w	#$21,(a0)+				;'Hit the start button ...'
	move.w	#$FFFF,(a0)				;end of list
	clr.w	(asv).w					;fast text flag
	move.w	#$7FFF,(screentimer).w	;frames left on the screen
	move.l	#$8CA0,(scoutwait).w	;then 36000 more when OptNOP is not 0
.top								;loop
	moveq	#0,d0					;one frame
	jsr	(waitx).l					;d1 = new presses
	subq.w	#1,(matchuptimer).w		;count down
	bpl.w	.2						;not run out
	move.w	#$10E,(matchuptimer).l	;restart
.2									;timer counted
	bsr.w	PrintAdvantageMarks		;advantage marks
	btst	#sbut,d1				;Start?
	bne.w	.exit					;start leaves
	cmpi.w	#$10E,(matchuptimer).w
	beq.w	.3						;timer ran out: next matchup
	btst	#cbut,d1				;C?
	beq.w	.4						;no
	move.w	#$7FFF,(screentimer).w	;restart the screen timer
	move.l	#$8CA0,(scoutwait).w	;and the wait
.3									;next matchup
	bsr.w	RestartAdvantageMarks
	move.w	#1,d0					;next matchup
	bsr.w	PageMatchup
	bra.w	.6
.4									;cbut clear
	btst	#abut,d1				;A?
	beq.w	.5						;no
	move.w	#$7FFF,(screentimer).w	;restart the screen timer
	move.l	#$8CA0,(scoutwait).w	;and the wait
	bsr.w	RestartAdvantageMarks	;restart the marks
	move.w	#$FFFF,d0				;previous matchup
	bsr.w	PageMatchup
	bra.w	.6						;show it
.5									;abut clear
	clr.w	(asv).w					;normal text speed
	btst	#dbut,d1				;down?
	beq.w	.6						;no
	st	(asv).w						;down: type the rest without delays
.6									;down held?
	btst	#1,(waitxpad+1).w		;down held (waitx pad bits)
	beq.w	.upd					;no
	st	(asv).w						;fast text
.upd								;show the next text
	jsr	(UpdateScoutingDisplay).l
	subq.w	#1,(screentimer).w		;count down
	bpl.w	.top					;loop
	tst.w	(OptNOP).w
	beq.w	.exit					;OptNOP 0: leave when the text is done
	move.w	#$FFFF,(screentimer).w	;else wait for start, up to scoutwait frames
	subq.l	#1,(scoutwait).w		;count down
	bpl.w	.top					;loop
.exit								;leave the scouting report
	move.w	#0,(printfontset).w		;char set 0
	rts
PageMatchup							;Page the matchup by d0 (+1 / -1, 0-6 wrapping), restart the page timer
									;and redraw. Called from ScoutingReport
	move.w	#$10E,(matchuptimer).w	;restart the matchup timer
	add.w	(matchup).w,d0			;plus the matchup
	bmi.w	.0						;below 0: wrap to 6
	cmp.w	#7,d0					;past 6?
	blt.w	.1						;no
	clr.w	d0						;wrap to 0
	bra.w	.1						;set it
.0									;d0 negative
	move.w	#6,d0
.1									;set the matchup
	move.w	d0,(matchup).w			;store it
	bsr.w	GetMatchupPlayers		;its players
	bsr.w	DrawMatchupPictures		;pictures
	bsr.w	PrintMatchupRatings		;ratings
	rts								;return
PrintMatchupRating					;Print the team rating of team a0 (GetTeamRating: the TeamRatings byte for
									;team number tmteam(a0)) as 2 digits at printx / printy; return d0 = the
									;rating.
									;Called from PrintMatchupRatings
	bsr.w	PrintTwoSpaces			;clear the old number
	move.l	a2,-(sp)				;save
	movea.l	a0,a2					;team a0
	bsr.w	GetTeamRating			;d0 = rating
	movea.l	(sp)+,a2				;restore
	move.l	d0,-(sp)				;save
	move.w	#2,d1					;2 digits
	jsr	(PushNumberWidth).l			;as a String
	jsr	(printsmall).l				;print it
	move.l	(sp)+,d0				;restore
	rts								;return
PrintTwoSpaces						;Print 2 spaces at printx / printy and keep printx
	move.l	a1,-(sp)				;save
	move.w	(printx).w,-(sp)		;save the column
	movea.l	#TwoSpacesTxt,a1		;2 spaces
	jsr	(printsmall).l				;print them
	move.w	(sp)+,(printx).w		;restore the column
	movea.l	(sp)+,a1				;restore
	rts								;return
TwoSpacesTxt						;A two space String (printsmall by PrintTwoSpaces)
	String	'  '
ScoutRatingText						;rating names; only ' Overall ' is printed (PrintMatchupRatings, matchup
									;0); -1 ends the list
	String	'Shooting'
	String	'Skating'
	String	'Passing'
	String	'Defense'
	String	'Checking'
	String	'Fighting'
	String	'Goalkeeping'
	String	'Power Play Adv.'
	String	'-    Home Team Adv.    '
	String	'    Overall     '
	dc.w	-1
DrawMatchupPictures					;Draw the matchup's 6 x 6 pictures, visitors at x 2, home at x $20, y $F:
									;matchup 0 the team logos (GetTeamLogo, DrawMatchupLogo)
									;1-6 the two players' pictures (DrawPlayerPicture, DrawMatchupPicture).
									;Called from ScoutingReport and PageMatchup
	movem.l	d0-d7/a0-a6,-(sp)		;save
	tst.w	(matchup).w				;the teams?
	bne.w	.0						;no: players
	move.w	(VisTeam).w,d3			;visitors
	bsr.w	GetTeamLogo				;a0 = visitors logo
	move.w	#2,(printx).w			;column 2
	move.w	#$F,(printy).w			;row $F
	move.w	(vispicchars).w,d4		;visitors picture chars
	move.w	#4,d5					;palette offset
	move.w	#$6000,(printa).w		;palette 3
	bsr.w	DrawMatchupLogo			;draw it
	move.w	(HomeTeam).w,d3			;home team
	bsr.w	GetTeamLogo				;a0 = home logo
	move.w	#$20,(printx).w			;column $20
	move.w	#$F,(printy).w			;row $F
	move.w	(homepicchars).w,d4		;home picture chars
	move.w	#0,(printa).w			;palette 0
	move.w	#2,d5					;palette offset
	bsr.w	DrawMatchupLogo			;draw it
	move.w	#$64,(palcount).w		;100
	bra.w	.x						;done
.0									;matchup <> 0
	move.w	(VisTeam).w,d1			;visitors
	move.w	(matchupvis).w,d0		;matchup player
	jsr	(DrawPlayerPicture).l		;a0 = picture of player d0 of team d1 (visitors)
	move.w	#2,(printx).w			;column 2
	move.w	#$F,(printy).w			;row $F
	move.w	(vispicchars).w,d4		;visitors picture chars
	move.w	#2,d5					;palette line 2
	move.w	#0,(printa).w			;palette 0
	bsr.w	DrawMatchupPicture		;draw it
	move.w	(HomeTeam).w,d1			;home team
	move.w	(matchuphome).w,d0		;matchup player
	jsr	(DrawPlayerPicture).l		;home
	move.w	#$20,(printx).w			;column $20
	move.w	#$F,(printy).w			;row $F
	move.w	(homepicchars).w,d4		;home picture chars
	move.w	#0,d5					;palette line 0
	move.w	#0,(printa).w			;palette 0
	bsr.w	DrawMatchupPicture		;draw it
	move.w	#$64,(palcount).w		;100
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a6
	rts								;return
DrawMatchupPicture					;Draw player picture a0 at printx / printy with the PicturePalette
									;palette. A picture with no map (offset 0) uses the PicturePalette map.
									;UnpackPicture, then the picturebuf tiles. Falls into DrawMatchupBitmap
	movea.l	a0,a1					;a1 = map header
	movea.l	a0,a2					;a2 = offsets
	adda.l	(a2)+,a0				;skip the palette offset
	movea.l	#PicturePalette,a0		;palette from PicturePalette
	adda.l	(a0),a0					;its palette
	tst.l	(a2)					;no map?
	bne.w	.0						;yes
	movea.l	#PicturePalette,a1
	adda.l	jimdata(a1),a1			;its map
	tst.l	(a2)+					;skip it
	bra.w	.1						;unpack
.0									;a2 <> 0
	adda.l	(a2)+,a1				;map data
.1									;unpack the logo
	bsr.w	UnpackPicture
	movea.l	#picturebuf,a2			;tiles
	bra.w	DrawMatchupBitmap		;draw it
DrawMatchupLogo						;Draw team logo a0 at printx / printy, palette TeamLogoPalettes + team d3
									;* 8 - $20 (d5 = 4: - $40). Falls into DrawMatchupBitmap
	movea.l	a0,a1					;a1 = map header
	movea.l	a0,a2					;a2 = offsets
	adda.l	(a2)+,a0				;skip the palette offset
	asl.w	#3,d3					;8 bytes per team
	cmp.w	#4,d5					;visitors?
	beq.w	.0						;yes
	subi.w	#$20,d3					;home palette
	bra.w	.1
.0									;d5 = 4
	subi.w	#$40,d3					;visitors palette
.1									;palette offset chosen
	movea.l	#TeamLogoPalettes,a0
	adda.w	d3,a0					;this team's palette
	adda.l	(a2)+,a1				;map data
DrawMatchupBitmap					;6 x 6 dobitmap, then erase the 8 x 3 name area at y $19 on that side (x 2
									;or $20). Branched to from DrawMatchupPicture
	move.w	#6,d3					;height 6
	move.w	#6,d2					;width 6
	clr.w	d0						;x 0
	clr.w	d1						;y 0
	jsr	(dobitmap).l				;draw it
	cmpi.w	#$14,(printx).w			;right side?
	bgt.w	.0						;yes
	move.w	#2,(printx).l			;column 2
	bra.w	.1						;erase
.0									;printx > $14
	move.w	#$20,(printx).l			;column $20
.1									;print x chosen
	move.w	#$19,(printy).l			;row $19
	move.w	#8,d0					;width 8
	move.w	#3,d1					;height 3
	move.w	#$7FF,d2				;blank char
	jsr	(eraser).l					;erase the name area
	rts								;return
GetTeamLogo							;Return a0 = the logo bitmap of team d3 (TeamLogoBitmaps table)
	asl.w	#2,d3					;long index
	movea.l	#TeamLogoBitmaps,a0		;logo table
	movea.l	0(a0,d3.w),a0			;its logo
	rts								;return
PrintMatchupRatings					;Print the matchup ratings. Matchup 0: 'Overall' at y $13, the team
									;ratings (PrintMatchupRating), home at x $22, visitors at x 4, y $16. 1-6:
									;the position name at y $13, the player names on y $17
									;(PrintPlayerNameRight; home right justified), and the player ratings at x
									;$22 / 4, y $16: CalcAttrib with the PAttribOverallMask (skater) or
									;GAttribOverallMask (goalie) long in d4, * 100 / d1, AttribAdjust. The
									;ratings go to homerating (home) / visrating (visitors) for
									;PrintAdvantageMarks. Called from ScoutingReport and PageMatchup
	tst.w	(matchup).w				;the teams?
	bne.w	.matchup				;no
	jsr	(printsmallz).l				;map at the title
	String	CC_SetMapAndPosition,0,1,$16,$16,CC_SetFont,1
	lea	ScoutRatingText(pc),a1		;rating names
	move.w	#0,d7					;line 0
.loop								;loop
	move.w	(a1),d0					;String length
	asr.w	#1,d0					;half
	neg.w	d0						;negated
	addi.w	#$16,d0					;center on column 22
	move.w	d0,(printx).w
	cmp.w	#9,d7					;only the 10th, 'Overall'
	beq.w	.0
	adda.w	(a1),a1					;skip it
	bra.w	.1						;next
.0									;d7 = 9
	move.w	#2,(printfontset).w		;font set 2
	move.w	(printy).w,-(sp)		;save the row
	subq.w	#3,(printy).w			;y $13
	jsr	(printsmall).l				;print it
	move.w	(sp)+,(printy).w		;restore the row
.1									;next line
	addq.w	#1,d7					;count
	tst.w	(a1)					;more?
	bpl.s	.loop					;loop
	move.w	#2,(printfontset).w		;font set 2
	jsr	(printz).l					;map at the home rating
	String	-TXMAP1,0,$17,'                                        '	;40 spaces
	jsr	(printz).l					;its position
	String	-TXMAP1,$22,$16
	movea.l	#tmstruct,a0			;home team struct
	movea.l	#AwShots,a2				;away team struct
	bsr.w	PrintMatchupRating		;home
	move.w	d0,(homerating).w
	move.w	#2,(printfontset).w
	jsr	(printz).l					;map at the visitors rating
	String	-TXMAP1,4,$16
	exg	a0,a2						;swap the teams
	bsr.w	PrintMatchupRating		;visitors
	move.w	d0,(visrating).w
	bra.w	.x						;done
.matchup							;matchup <> 0
	move.w	(matchup).w,d0			;matchup
	subq.w	#1,d0					;minus 1
	movea.l	#MatchupPosNames,a1		;position name of matchup - 1
	bra.w	.3
.loop2								;skip one name
	adda.w	(a1),a1
.3									;loop the skip
	dbf	d0,.loop2
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,0,1,$D,$13,CC_SetFont,1
	jsr	(printsmall).l				;print it
	move.w	#$16,(printy).w			;row $16
	move.w	#2,(printfontset).w		;font set 2
	movea.l	#tmstruct,a2			;home team struct
	move.l	(PAttribOverallMask).l,d4	;skater rating weights
	tst.w	(matchupslot).w			;line slot 0: goalie
	bne.w	.4
	move.l	(GAttribOverallMask).l,d4	;goalie
.4									;rating weights chosen
	move.w	(matchuphome).w,d0		;home player
	jsr	(printz).l
	String	-TXMAP1,0,$17,'                                        '	;40 spaces
	jsr	(printz).l					;its position
	String	-TXMAP1,$23,$17
	bsr.w	PrintPlayerNameRight	;print the name, moved left to fit the line
	bsr.w	CalcAttrib				;d0 = weighted total, d1 = weights
	mulu.w	#$64,d0					;* 100
	divu.w	d1,d0
	bsr.w	AttribAdjust			;adjusted rating
	move.w	#2,d1					;2 digits
	move.w	d0,(homerating).w
	jsr	(PushNumberWidth).l			;as a String
	jsr	(printz).l					;map at the number
	String	-TXMAP1,$22,$16
	bsr.w	PrintTwoSpaces			;clear the old number
	jsr	(printsmall).l				;print it
	movea.l	#AwShots,a2				;away team struct
	move.l	(PAttribOverallMask).l,d4	;skater rating weights
	tst.w	(matchupslot).w			;goalie?
	bne.w	.5						;no
	move.l	(GAttribOverallMask).l,d4	;goalie weights
.5									;rating weights chosen
	move.w	(matchupvis).w,d0		;visitors player
	jsr	(printz).l					;map at the name
	String	-TXMAP1,0,$17
	bsr.w	PrintPlayerNameRight
	bsr.w	CalcAttrib				;d0 = weighted total, d1 = weights
	mulu.w	#$64,d0					;* 100
	divu.w	d1,d0					;/ weights
	bsr.w	AttribAdjust			;adjusted rating
	move.w	d0,(visrating).w
	move.w	#2,d1					;2 digits
	jsr	(PushNumberWidth).l			;as a String
	jsr	(printz).l					;map at the number
	String	-TXMAP1,4,$16
	bsr.w	PrintTwoSpaces			;clear the old number
	jsr	(printsmall).l				;print it
.x									;exit (also the end of the code above)
	rts
MatchupPosNames						;Position names of matchups 1-6
	String	'     center     '
	String	' left forward   '
	String	' right forward  '
	String	'left defenseman '
	String	'right defenseman'
	String	'     goalie     '
GetMatchupPlayers					;matchuphome / matchupvis = the home / visitors player of the matchup.
									;Called from ScoutingReport and PageMatchup
	movem.l	d0/a0-a1,-(sp)			;save
	movea.l	#tmstruct,a0			;home team struct
	bsr.w	GetMatchupPlayer		;its player
	move.w	d0,(matchuphome).w
	movea.l	#AwShots,a0				;away team struct
	bsr.w	GetMatchupPlayer		;its player
	move.w	d0,(matchupvis).w
	movem.l	(sp)+,d0/a0-a1			;restore
	rts								;return
GetMatchupPlayer					;Return d0 = the roster index of team a0's player for matchup: the first
									;line of the team's line sets, slot
									;MatchupLineSlots[matchup] (matchupslot; 0 goalie, 1 left defense, 2 right
									;defense, 3 left wing, 4 center, 5 right wing)
	movea.l	tmdata(a0),a0			;tmdata
	adda.w	LineSets(a0),a0			;LineSets
	move.w	(matchup).w,d0			;matchup
	movea.l	#MatchupLineSlots,a1	;line slot table
	move.b	0(a1,d0.w),d0			;slot
	ext.w	d0						;word
	move.w	d0,(matchupslot).w		;store it
	move.b	0(a0,d0.w),d0			;player number in the slot
	ext.w	d0						;word
	subq.w	#1,d0					;player numbers start at 1
	rts
MatchupLineSlots					;Line slot by matchup 0-6 (0 for the teams, then 4 center, 3 left forward,
									;5 right forward, 1 left defense, 2 right defense,
									;0 goalie), and a pad byte
	dc.b	0,4,3,5,1,2,0,0
RestartAdvantageMarks				;Restart the advantage marks (PrintAdvantageMarks)
	clr.w	(advcount).w			;restart the count
	clr.w	(advframe).w			;first frame
	rts								;return
PrintAdvantageMarks					;Called every frame by ScoutingReport. Print the advantage marks at x $13,
									;y $16: ']' marks growing toward the home
									;side (right) when the home rating is higher, '[' marks toward the
									;visitors (left) when lower, one more every 7 frames up to 3; blank if
									;equal
	movem.l	d0-d7/a0-a6,-(sp)		;save
	addq.w	#1,(advcount).w			;count frames
	cmpi.w	#7,(advcount).w			;7 frames?
	blt.w	.0						;no
	clr.w	(advcount).w			;restart the count
	addq.w	#1,(advframe).w			;next mark frame
	cmpi.w	#6,(advframe).w			;past 5?
	blt.w	.0						;no
	move.w	#5,(advframe).w			;stay on 5
.0									;frame set
	move.w	(advframe).w,d1			;frame
	asl.w	#2,d1					;long index
	movea.l	#HomeAdvMarks,a1		;home marks
	move.w	(homerating).w,d0		;home rating
	cmp.w	(visrating).w,d0		;home - visitors
	bgt.w	.1						;home better
	beq.w	.2						;even
	movea.l	#VisAdvMarks,a1			;visitors better
.1									;advantage marks chosen
	movea.l	0(a1,d1.w),a1			;marks for the frame
	bra.w	.3						;print
.2									;even matchup
	movea.l	#EvenAdvTxt,a1			;equal
.3									;print the marks
	move.w	#2,(printfontset).w		;font set 2
	jsr	(printz).l					;map at the marks
	String	-TXMAP1,$13,$16
	jsr	(printsmall).l				;print them
	move.w	#0,(printfontset).w		;font set 0
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
HomeAdvMarks						;Home advantage marks, by advframe (0-5)
	dc.l	HomeAdv0Txt,HomeAdv1Txt,HomeAdv2Txt,HomeAdv3Txt,HomeAdv3Txt,HomeAdv3Txt
VisAdvMarks							;Visitors advantage marks
	dc.l	VisAdv0Txt,VisAdv1Txt,VisAdv2Txt,VisAdv3Txt,VisAdv3Txt,VisAdv3Txt
HomeAdv0Txt	String	'   '			;home advantage marks: none
HomeAdv1Txt	String	']  '			;home advantage: one mark
HomeAdv2Txt	String	']] '			;home advantage: two marks
HomeAdv3Txt	String	']]]'			;home advantage: three marks
VisAdv0Txt	String	'   '			;visitors advantage marks: none
VisAdv1Txt	String	'  ['			;visitors advantage: one mark
VisAdv2Txt	String	' [['			;visitors advantage: two marks
VisAdv3Txt	String	'[[['			;visitors advantage: three marks
EvenAdvTxt	String	'   '			;Even teams
GetTeamNickname						;The text player's '=' (a2 = tmstruct) and '*' (AwShots): return a1 = the
									;team nickname String, or 'Home' / 'Visitors' when it is empty (the all
									;star teams)
	movem.l	d0/a0/a2,-(sp)			;save
	movea.l	a2,a1					;team struct
	movea.l	tmdata(a1),a1			;tmdata
	adda.w	Teamname(a1),a1			;city
	adda.w	(a1),a1					;abbreviation
	adda.w	(a1),a1					;nickname
	cmpi.w	#2,(a1)					;empty String?
	bne.w	.x
	movea.l	#HomeTxt,a1				;no: "Home"
	cmpa.l	#tmstruct,a2			;home team?
	beq.w	.x						;yes
	movea.l	#VisitorsTxt,a1			;"Visitors"
.x									;exit: restore the registers
	movem.l	(sp)+,d0/a0/a2			;restore
	rts								;return
HomeTxt	String	'Home'				;name used when the home team has no nickname
VisitorsTxt	String	'Visitors'		;name used when the visiting team has no nickname
GetTeamArena						;The text player's '^' (a2 = tmstruct) and ';' (AwShots): return a1 = the
									;team arena String
	movem.l	d0/a0/a2,-(sp)			;save
	movea.l	a2,a1					;team struct
	movea.l	tmdata(a1),a1			;tmdata
	adda.w	Teamname(a1),a1			;city
	adda.w	(a1),a1					;abbreviation
	adda.w	(a1),a1					;nickname
	adda.w	(a1),a1					;arena
	movem.l	(sp)+,d0/a0/a2			;restore
	rts								;return
ScoutStub							;An empty routine
	movem.l	d0-d7/a0-a6,-(sp)		;save
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
