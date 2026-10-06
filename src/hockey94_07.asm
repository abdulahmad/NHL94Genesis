;	NHL 94 (retail) segment $FCB9A-$FD617
;	The 94 ScoutingReport (93 hockey93_07), rewritten as the pregame MATCHUPS screen, with its 94-only helpers: sub_FCB9A and
;	sub_FD5AE / sub_FD5F4 (team data for the text player's '@', '=' '*' and '^' ';'), the unused sub_FCBD8 / sub_FCC56, the matchup
;	pager sub_FCF86, the rating, picture and position helpers, StatsText, and the advantage marks (sub_FD4CA). 94 moved this screen
;	to the end of the ROM with the menu code (setoptions is hockey94_08). The text player itself (93 InitScoutingDisplay /
;	UpdateScoutingDisplay / ScrollDisplayUp) is hockey94_06 sub_17718 / sub_17730 / sub_179D2. The rest of hockey93_07 (Stanley Cup
;	screen, TitleScreen, the sprite list helpers, CheckSound) is not here. sub_FD618 follows (called from sub_FC516).
;	Transcribed from lst/nhl94.bin.lst lines 969432-970644. Global names are the IDA names, or the 93 name where IDA has an auto
;	name (IDA name in an ;IDA: comment). Local labels are the IDA address (loc_FCBC8 -> .FCBC8).
;	IDA gaps written from the retail bytes: $FCBD8-$FCC75 (sub_FCBD8, sub_FCC56) and $FD60E-$FD617 (an empty routine) are IDA dc.b
;	with no xref, written as instructions with IDA-style names. Each DecompressGraphicsWithCallback is followed by its 8 byte remap
;	table (IDA shows it as code). The printz / printz2 / printbigz strings (IDA ori.b and others, four with a word dropped), the
;	instructions IDA hid in them, and the String tables were read at each address.
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp / cmpi;
;	fixopcodes.js patches the cmp encoding after assembly.
;	printz String first byte, negated: low 2 bits = map, the rest << 9 = printa ($FF / $FE map 1 / 2, $DF / $DE the same with printa
;	$4000). printz2 (93 printsmallz) codes: $F8 attribute,map,x,y; $F9 char set. Pad bits: dbut 1, cbut 5, abut 6, sbut 7.

sub_FCB9A	;94 only. The text player's '@' (sub_17730): return a1 = the home team's crowd record in dB as a String at $FFBF20 (SRAM team record
	;byte 8, 80 if 0). clrCrowdRAM (IDA name) reads the 16 byte SRAM record of team d1 ($B60 + d1 * 16) to a0
	movem.l	d0-d7/a0/a2-a6,-(sp)
	move.w	(HomeTeam).w,d1
	ext.l	d1
	movea.l	#$FFFFCFFE,a0	;SRAM team record buffer
	move.l	a0,-(sp)
	jsr	(clrCrowdRAM).l	;read the HomeTeam record
	movea.l	(sp)+,a0
	movea.l	#$FFFFBF20,a1	;String buffer
	clr.w	d0
	move.b	8(a0),d0	;crowd record
	bne.w	.FCBC8
	move.b	#$50,d0	;none saved: 80 dB
.FCBC8
	move.l	a1,-(sp)
	jsr	(sub_F998E).l	;d0 as a decimal String at a1
	movea.l	(sp)+,a1
	movem.l	(sp)+,d0-d7/a0/a2-a6
	rts
sub_FCBD8	;no IDA label (IDA dc.b, no xref). 94 only, unused: return a1 = 'by <name> ' for the home team's crowd record (SRAM record byte 9 =
	;name number, sub_FA014 reads that 12 char name from the $FFD45A list), or an empty String if byte 9 is 0
	movem.l	d0-d7/a0/a2-a6,-(sp)
	move.w	(HomeTeam).w,d1
	ext.l	d1
	movea.l	#$FFFFCFFE,a0
	move.l	a0,-(sp)
	jsr	(clrCrowdRAM).l
	movea.l	(sp)+,a0
	tst.b	9(a0)	;name number
	beq.w	.FCC3E
	movea.l	#$FFFFCF36,a3	;String buffer (ram_addrs.inc ThreeStars)
	movea.l	#unk_FCC4C,a1
	move.l	a3,-(sp)
	jsr	(sub_F997A).l	;copy the String at a1 to a3: 'by '
	movea.l	(sp)+,a3
	clr.w	d2
	move.b	9(a0),d2
	movea.l	#$FFFFBF20,a1	;name String buffer
	bset	#7,(word_FFC2F8).w
	bsr.w	sub_FA014
	jsr	(appstring).l	;append the name
	movea.l	#unk_FCC52,a1
	jsr	(appstring).l	;and ' '
	movea.l	a3,a1	;a1 = 'by <name> '
	bra.w	.FCC44
.FCC3E
	movea.l	#unk_FCC4A,a1
.FCC44
	movem.l	(sp)+,d0-d7/a0/a2-a6
	rts
unk_FCC4A	String	''
unk_FCC4C	String	'by '
unk_FCC52	String	' '
sub_FCC56	;no IDA label (IDA dc.b, no xref). 94 only, unused: return a1 = the city String of team byte $A(a0) (TeamList, Teamname offset)
	movem.l	d0-d7/a0/a2-a6,-(sp)
	clr.w	d2
	move.b	$A(a0),d2
	asl.w	#2,d2
	movea.l	#TeamList,a1
	movea.l	0(a1,d2.w),a1
	adda.w	4(a1),a1
	movem.l	(sp)+,d0-d7/a0/a2-a6
	rts
ScoutingReport	;IDA: sub_FCC76 (93 name). 94 pregame MATCHUPS screen, called from Opening2. Draws the Ron Barr picture, the text box and the matchup:
	;matchup 0 is both team logos with the team ratings, 1-6 the two players at center, left forward, right forward, left defense, right defense
	;and goalie with their ratings, with marks toward the side that has the advantage. The text player (hockey94_06 sub_17730, 93
	;UpdateScoutingDisplay) types the paragraph list. A / C page the matchups (the page also turns by itself about every $10E frames), down types fast, start leaves
	jsr	(sub_F9C68).l	;read the $80 byte SRAM name list at $DA0 to $FFD45A
	jsr	(sub_F71A2).l	;hot / cold players for the text (not matched yet)
	clr.w	(word_FFD5A4).w	;advantage mark frame
	move.w	#$7A,-(sp)	;song $7A (93 $37)
	jsr	(song).l
	move.l	#vb2,(vbint).w
	jsr	(clearTeamStats).l
	move.l	a0,-(sp)
	movea.l	#HmShots,a0
	jsr	(Create_HotCold_Table).l	;new random hot / cold tables ($1A2(a0))
	movea.l	#AwShots,a0
	jsr	(Create_HotCold_Table).l
	movea.l	(sp)+,a0
	jsr	(sub_F71A2).l	;again with the new tables
	bclr	#1,(disflags).w	;df32c
	move.w	#6,(Map1col1).w
	move.w	#6,(Map2col1).w
	move.w	#0,d0	;fade to color
	jsr	(setvram).l
	move.w	#2,d4	;vram chars from 2
	move.w	d4,(word_FFD430).w	;home picture chars (6 x 6)
	addi.w	#$24,d4
	move.w	d4,(word_FFD432).w	;visitors picture chars
	addi.w	#$24,d4
	move.w	d4,(word_FFB010).w	;93 BigFontChars
	movea.l	#unk_A9A18,a2	;big font tiles
	jsr	(DecompressGraphicsWithCallback).l
	dc.l	$05431567,$79ABCDEF	;remap table (IDA: bchg / move.b / muls.w / ori.b)
	jsr	(AddSmallFont).l	;IDA hid this in the table
	move.w	d4,(word_FFB014).w	;1st vram char of the 2nd small font set (93)
	movea.l	#unk_AAC5A,a2	;small font tiles (as AddSmallFont), remapped
	jsr	(DecompressGraphicsWithCallback).l
	dc.l	$0A234567,$89ABCDEF	;remap table (IDA: eori.b / or.l)
	movea.l	#unk_55B86,a2	;framer tiles (as AddFramer), remapped
	move.w	d4,(framercset).w
	jsr	(DecompressGraphicsWithCallback).l
	dc.l	$05422561,$89ABCDEF	;remap table (IDA: bchg / move.l / muls.w / ori.b)
	jsr	(printz).l
	String	$FE,0,0
	movea.l	#unk_54E24,a0	;IDA hid the jsr, the string and this (ori.b x4)
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$28,d2	;40 x 28 background (93 ScoutMap)
	moveq	#$1C,d3
	moveq	#3,d5	;color fam 1-2
	jsr	(dobitmap).l
	jsr	(printbigz).l
	String	$DF,$C,$D,'MATCHUPS'	;IDA: ori.b / movep.l / subq x2 (and dropped a word)
	move.w	#0,(word_FFB030).w	;char set 0
	jsr	(printz).l
	String	$FF,$10,$11,'ADVANTAGE:'	;IDA: ori.b / move.b / addq / move.w (and dropped a word)
	jsr	(printz).l
	String	$DE,6,3		;IDA: ori.b / btst d1,d0
	moveq	#$21,d0	;33 x 9 text box frame
	moveq	#9,d1
	jsr	(Framer).l
	jsr	(printz).l
	String	$DE,1,$E	;IDA: ori.b (and dropped a word)
	move.w	#8,d0	;8 x 8 frame: visitors picture
	move.w	#8,d1
	jsr	(Framer).l
	jsr	(printz).l
	String	$DE,$1F,$E	;IDA: ori.b (and dropped a word)
	move.w	#8,d0	;8 x 8 frame: home picture
	move.w	#8,d1
	jsr	(Framer).l
	jsr	(printz).l
	String	$FF,1,1		;IDA: ori.b / btst d0,d0
	movea.l	#unk_B389C,a0	;Ron Barr picture (93 Ronbarrmap): palette offset, then map header offset
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	moveq	#$C,d5	;color fam 3-4
	jsr	(dobitmap).l
	movea.l	#unk_F5AFE,a2
	move.w	d4,(word_FFDEE4).w	;tiles: 1st vram char
	jsr	(DoDMA_clearCallbackPointer).l
	movea.l	#unk_F5D24,a2
	move.w	d4,(word_FFDEE6).w	;tiles: 1st vram char
	jsr	(DoDMA_clearCallbackPointer).l
	clr.w	(word_FFD598).w	;matchup 0: the teams
	clr.w	(word_FFD59A).w
	move.w	#$10D,(word_FFD5A8).l	;frames to the next matchup
	bsr.w	sub_FD46C	;the matchup players
	bsr.w	sub_FD084	;pictures
	bsr.w	sub_FD1FE	;ratings
	move.w	#$18,(palcount).w	;24
	move.l	#vb2,(vbint).w
	move	#$2500,sr
	jsr	(sub_17718).l	;93 InitScoutingDisplay: a0 = the paragraph list
	move.w	#$1B,(a0)+	;paragraph numbers in unk_4B5C0: 'Hi, I'm Ron Barr ...'
	move.w	#$1D,(a0)+	;empty paragraph: a blank line
	move.w	#$1A,(a0)+	;'Welcome to a sold out ^ ...'
	move.w	#$1D,(a0)+
	jsr	(sub_F7318).l	;d0 = $22 / $23 ('Lately $ has been playing (extremely) well.') when the team totals (sub_F737E) differ by $5E / $BD or more, else -1
	tst.w	d0
	bmi.w	.FCE84
	move.w	d0,(a0)+
	move.w	#$1D,(a0)+
.FCE84
	move.w	(HomeTeam).w,d0
	move.w	#$1E,(a0)+	;home hot / cold player
	move.w	#$1D,(a0)+
	cmp.w	(VisTeam).w,d0
	beq.w	.FCE9C	;same team: one hot / cold paragraph
	move.w	#$1F,(a0)+	;visitors hot / cold player
.FCE9C
	move.w	#$1D,(a0)+
	move.w	#$20,(a0)+	;'The ^ crowd record is @ dB.'
	move.w	#$1D,(a0)+
	move.w	#$21,(a0)+	;'Hit the start button ...'
	move.w	#$FFFF,(a0)	;end of list
	clr.w	(asv).w	;fast text flag
	move.w	#$7FFF,(word_FFD5B6).w	;frames left on the screen (93 word_FFC9D4)
	move.l	#$8CA0,(dword_FFDEEC).w	;then 36000 more when OptNOP is not 0
.FCEC2
	moveq	#0,d0
	jsr	(waitx).l	;d1 = new presses
	subq.w	#1,(word_FFD5A8).w
	bpl.w	.FCEDA
	move.w	#$10E,(word_FFD5A8).l
.FCEDA
	bsr.w	sub_FD4CA	;advantage marks
	btst	#7,d1	;sbut
	bne.w	.FCF7E	;start leaves
	cmpi.w	#$10E,(word_FFD5A8).w
	beq.w	.FCF06	;timer ran out: next matchup
	btst	#5,d1	;cbut
	beq.w	.FCF16
	move.w	#$7FFF,(word_FFD5B6).w
	move.l	#$8CA0,(dword_FFDEEC).w
.FCF06
	bsr.w	sub_FD4C0
	move.w	#1,d0	;next matchup
	bsr.w	sub_FCF86
	bra.w	.FCF4C
.FCF16
	btst	#6,d1	;abut
	beq.w	.FCF3C
	move.w	#$7FFF,(word_FFD5B6).w
	move.l	#$8CA0,(dword_FFDEEC).w
	bsr.w	sub_FD4C0
	move.w	#$FFFF,d0	;previous matchup
	bsr.w	sub_FCF86
	bra.w	.FCF4C
.FCF3C
	clr.w	(asv).w
	btst	#1,d1	;dbut
	beq.w	.FCF4C
	st	(asv).w	;down: type the rest without delays
.FCF4C
	btst	#1,(word_FFDED4+1).w	;down held (waitx pad bits)
	beq.w	.FCF5A
	st	(asv).w
.FCF5A
	jsr	(sub_17730).l	;93 UpdateScoutingDisplay
	subq.w	#1,(word_FFD5B6).w
	bpl.w	.FCEC2
	tst.w	(OptNOP).w
	beq.w	.FCF7E	;OptNOP 0: leave when the text is done
	move.w	#$FFFF,(word_FFD5B6).w	;else wait for start, up to dword_FFDEEC frames
	subq.l	#1,(dword_FFDEEC).w
	bpl.w	.FCEC2
.FCF7E
	move.w	#0,(word_FFB030).w	;char set 0
	rts
sub_FCF86	;94 only. Page the matchup by d0 (+1 / -1, 0-6 wrapping), restart the page timer and redraw. Called from ScoutingReport
	move.w	#$10E,(word_FFD5A8).w
	add.w	(word_FFD598).w,d0
	bmi.w	.FCFA2
	cmp.w	#7,d0
	blt.w	.FCFA6
	clr.w	d0
	bra.w	.FCFA6
.FCFA2
	move.w	#6,d0
.FCFA6
	move.w	d0,(word_FFD598).w
	bsr.w	sub_FD46C
	bsr.w	sub_FD084
	bsr.w	sub_FD1FE
	rts
sub_FCFB8	;94 only. Print the team rating of team a0 (sub_FE172: the unk_FE18E byte for team number $28(a0)) as 2 digits at printx / printy; return d0 = the rating. Called from sub_FD1FE
	bsr.w	sub_FCFDC	;clear the old number
	move.l	a2,-(sp)
	movea.l	a0,a2
	bsr.w	sub_FE172
	movea.l	(sp)+,a2
	move.l	d0,-(sp)
	move.w	#2,d1	;2 digits
	jsr	(PushNumberWidth).l
	jsr	(print2).l
	move.l	(sp)+,d0
	rts
sub_FCFDC	;94 only. Print 2 spaces at printx / printy (unk_FCFF6) and keep printx
	move.l	a1,-(sp)
	move.w	(printx).w,-(sp)
	movea.l	#unk_FCFF6,a1
	jsr	(print2).l
	move.w	(sp)+,(printx).w
	movea.l	(sp)+,a1
	rts
unk_FCFF6	;IDA name. A two space String (print2 by sub_FCFDC)
	String	'  '
StatsText	;no IDA label (93 name). The 93 rating names (93 StatsText). 94 prints only '    Overall     ' (sub_FD1FE, matchup 0); -1 ends the list
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
sub_FD084	;94 only. Draw the matchup's 6 x 6 pictures, visitors at x 2, home at x $20, y $F: matchup 0 the team logos (sub_FD1F0, sub_FD17E),
	;1-6 the two players' pictures (sub_FAE26, sub_FD14A). Called from ScoutingReport and sub_FCF86
	movem.l	d0-d7/a0-a6,-(sp)
	tst.w	(word_FFD598).w
	bne.w	.FD0E6
	move.w	(VisTeam).w,d3
	bsr.w	sub_FD1F0	;a0 = visitors logo
	move.w	#2,(printx).w
	move.w	#$F,(printy).w
	move.w	(word_FFD432).w,d4
	move.w	#4,d5
	move.w	#$6000,(printa).w
	bsr.w	sub_FD17E
	move.w	(HomeTeam).w,d3
	bsr.w	sub_FD1F0	;a0 = home logo
	move.w	#$20,(printx).w
	move.w	#$F,(printy).w
	move.w	(word_FFD430).w,d4
	move.w	#0,(printa).w
	move.w	#2,d5
	bsr.w	sub_FD17E
	move.w	#$64,(palcount).w	;100
	bra.w	.FD144
.FD0E6
	move.w	(VisTeam).w,d1
	move.w	(word_FFD59E).w,d0
	jsr	(sub_FAE26).l	;a0 = picture of player d0 of team d1 (visitors)
	move.w	#2,(printx).w
	move.w	#$F,(printy).w
	move.w	(word_FFD432).w,d4
	move.w	#2,d5
	move.w	#0,(printa).w
	bsr.w	sub_FD14A
	move.w	(HomeTeam).w,d1
	move.w	(word_FFD59C).w,d0
	jsr	(sub_FAE26).l	;home
	move.w	#$20,(printx).w
	move.w	#$F,(printy).w
	move.w	(word_FFD430).w,d4
	move.w	#0,d5
	move.w	#0,(printa).w
	bsr.w	sub_FD14A
	move.w	#$64,(palcount).w	;100
.FD144
	movem.l	(sp)+,d0-d7/a0-a6
	rts
sub_FD14A	;94 only. Draw player picture a0 at printx / printy with the unk_C63F8 palette. A picture with no map (offset 0) uses the unk_C63F8
	;map. sub_FE98A (not matched yet) then the $FFDA1E tiles. Falls into loc_FD1A4
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	movea.l	#unk_C63F8,a0	;palette from unk_C63F8
	adda.l	(a0),a0
	tst.l	(a2)	;no map?
	bne.w	.FD16E
	movea.l	#unk_C63F8,a1
	adda.l	4(a1),a1
	tst.l	(a2)+
	bra.w	.FD170
.FD16E
	adda.l	(a2)+,a1
.FD170
	bsr.w	sub_FE98A
	movea.l	#$FFFFDA1E,a2	;tiles
	bra.w	loc_FD1A4
sub_FD17E	;94 only. Draw team logo a0 at printx / printy, palette unk_FF462 + team d3 * 8 - $20 (d5 = 4: - $40). Falls into loc_FD1A4
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	asl.w	#3,d3
	cmp.w	#4,d5
	beq.w	.FD196
	subi.w	#$20,d3
	bra.w	.FD19A
.FD196
	subi.w	#$40,d3
.FD19A
	movea.l	#unk_FF462,a0
	adda.w	d3,a0
	adda.l	(a2)+,a1
loc_FD1A4	;94 only. 6 x 6 dobitmap, then erase the 8 x 3 name area at y $19 on that side (x 2 or $20). Branched to from sub_FD14A
	move.w	#6,d3
	move.w	#6,d2
	clr.w	d0
	clr.w	d1
	jsr	(dobitmap).l
	cmpi.w	#$14,(printx).w
	bgt.w	.FD1CC
	move.w	#2,(printx).l
	bra.w	.FD1D4
.FD1CC
	move.w	#$20,(printx).l
.FD1D4
	move.w	#$19,(printy).l
	move.w	#8,d0
	move.w	#3,d1
	move.w	#$7FF,d2	;blank char
	jsr	(eraser).l
	rts
sub_FD1F0	;94 only. Return a0 = the logo bitmap of team d3 (unk_F86F2 table)
	asl.w	#2,d3
	movea.l	#unk_F86F2,a0
	movea.l	0(a0,d3.w),a0
	rts
sub_FD1FE	;94 only. Print the matchup ratings. Matchup 0: 'Overall' at y $13, the team ratings (sub_FCFB8), home at x $22, visitors at x 4, y
	;$16. 1-6: the position name at y $13, the player names on y $17 (sub_FD89A; home right justified), and the player ratings at x $22 / 4, y
	;$16: CalcAttrib with the dword_19420 (skater) or dword_19582 (goalie) long in d4, * 100 / d1, AttribAdjust. The ratings go to word_FFD5A0
	;(home) / word_FFD5A2 (visitors) for sub_FD4CA. Called from ScoutingReport and sub_FCF86
	tst.w	(word_FFD598).w
	bne.w	.FD2D2
	jsr	(printz2).l
	String	$F8,0,1,$16,$16,$F9,1	;IDA: ori.b / btst / move.b
	lea	StatsText(pc),a1	;IDA hid this in the string (and dropped its displacement)
	move.w	#0,d7
.FD21E
	move.w	(a1),d0
	asr.w	#1,d0
	neg.w	d0
	addi.w	#$16,d0	;center on column 22
	move.w	d0,(printx).w
	cmp.w	#9,d7	;only the 10th, 'Overall'
	beq.w	.FD23A
	adda.w	(a1),a1
	bra.w	.FD252
.FD23A
	move.w	#2,(word_FFB030).w
	move.w	(printy).w,-(sp)
	subq.w	#3,(printy).w	;y $13
	jsr	(print2).l
	move.w	(sp)+,(printy).w
.FD252
	addq.w	#1,d7
	tst.w	(a1)
	bpl.s	.FD21E
	move.w	#2,(word_FFB030).w
	jsr	(printz).l
	String	$FF,0,$17,'                                        '	;40 spaces. IDA: ori.b / move.l x20
	jsr	(printz).l
	String	$FF,$22,$16	;IDA: ori.b / move.b d0,d3
	movea.l	#HmShots,a0
	movea.l	#AwShots,a2
	bsr.w	sub_FCFB8	;home
	move.w	d0,(word_FFD5A0).w
	move.w	#2,(word_FFB030).w
	jsr	(printz).l
	String	$FF,4,$16	;IDA: ori.b / move.b d0,d3
	exg	a0,a2
	bsr.w	sub_FCFB8	;visitors
	move.w	d0,(word_FFD5A2).w
	bra.w	.FD3FE
.FD2D2
	move.w	(word_FFD598).w,d0
	subq.w	#1,d0
	movea.l	#unk_FD400,a1	;position name of matchup - 1
	bra.w	.FD2E4
.FD2E2
	adda.w	(a1),a1
.FD2E4
	dbf	d0,.FD2E2
	jsr	(printz2).l
	String	$F8,0,1,$D,$13,$F9,1	;IDA: ori.b / movep.w / btst
	jsr	(print2).l
	move.w	#$16,(printy).w
	move.w	#2,(word_FFB030).w
	movea.l	#HmShots,a2
	move.l	(dword_19420).l,d4	;skater rating weights
	tst.w	(word_FFD5AA).w	;line slot 0: goalie
	bne.w	.FD324
	move.l	(dword_19582).l,d4	;goalie
.FD324
	move.w	(word_FFD59C).w,d0	;home player
	jsr	(printz).l
	String	$FF,0,$17,'                                        '	;40 spaces. IDA: ori.b / move.l x20
	jsr	(printz).l
	String	$FF,$23,$17	;IDA: ori.b / move.b d0,-(a3)
	bsr.w	sub_FD89A	;print the name, moved left to fit the line
	bsr.w	CalcAttrib
	mulu.w	#$64,d0	;* 100
	divu.w	d1,d0
	bsr.w	AttribAdjust
	move.w	#2,d1
	move.w	d0,(word_FFD5A0).w
	jsr	(PushNumberWidth).l
	jsr	(printz).l
	String	$FF,$22,$16	;IDA: ori.b / move.b d0,d3
	bsr.w	sub_FCFDC
	jsr	(print2).l
	movea.l	#AwShots,a2
	move.l	(dword_19420).l,d4
	tst.w	(word_FFD5AA).w
	bne.w	.FD3B8
	move.l	(dword_19582).l,d4
.FD3B8
	move.w	(word_FFD59E).w,d0	;visitors player
	jsr	(printz).l
	String	$FF,0,$17	;IDA: ori.b / move.b d0,-(a3)
	bsr.w	sub_FD89A
	bsr.w	CalcAttrib
	mulu.w	#$64,d0	;* 100
	divu.w	d1,d0
	bsr.w	AttribAdjust
	move.w	d0,(word_FFD5A2).w
	move.w	#2,d1
	jsr	(PushNumberWidth).l
	jsr	(printz).l
	String	$FF,4,$16	;IDA: ori.b / move.b d0,d3
	bsr.w	sub_FCFDC
	jsr	(print2).l
.FD3FE
	rts
unk_FD400	;IDA name. Position names of matchups 1-6
	String	'     center     '
	String	' left forward   '
	String	' right forward  '
	String	'left defenseman '
	String	'right defenseman'
	String	'     goalie     '
sub_FD46C	;94 only. word_FFD59C / word_FFD59E = the home / visitors player of the matchup (sub_FD492). Called from ScoutingReport and sub_FCF86
	movem.l	d0/a0-a1,-(sp)
	movea.l	#HmShots,a0
	bsr.w	sub_FD492
	move.w	d0,(word_FFD59C).w
	movea.l	#AwShots,a0
	bsr.w	sub_FD492
	move.w	d0,(word_FFD59E).w
	movem.l	(sp)+,d0/a0-a1
	rts
sub_FD492	;94 only. Return d0 = the roster index of team a0's player for matchup word_FFD598: the first line of the team's line sets, slot
	;unk_FD4B8[matchup] (word_FFD5AA; 0 goalie, 1 left defense, 2 right defense, 3 left wing, 4 center, 5 right wing)
	movea.l	$1E(a0),a0	;tmdata
	adda.w	6(a0),a0	;LineSets
	move.w	(word_FFD598).w,d0
	movea.l	#unk_FD4B8,a1
	move.b	0(a1,d0.w),d0
	ext.w	d0
	move.w	d0,(word_FFD5AA).w
	move.b	0(a0,d0.w),d0
	ext.w	d0
	subq.w	#1,d0	;player numbers start at 1
	rts
unk_FD4B8	;IDA name. Line slot by matchup 0-6 (0 for the teams, then 4 center, 3 left forward, 5 right forward, 1 left defense, 2 right defense,
	;0 goalie), and a pad byte
	dc.b	0,4,3,5,1,2,0,0
sub_FD4C0	;94 only. Restart the advantage marks (sub_FD4CA)
	clr.w	(word_FFD5A6).w
	clr.w	(word_FFD5A4).w
	rts
sub_FD4CA	;94 only. Called every frame by ScoutingReport. Print the advantage marks at x $13, y $16: ']' marks growing toward the home
	;side (right) when the home rating is higher, '[' marks toward the visitors (left) when lower, one more every 7 frames up to 3; blank if equal
	movem.l	d0-d7/a0-a6,-(sp)
	addq.w	#1,(word_FFD5A6).w
	cmpi.w	#7,(word_FFD5A6).w
	blt.w	.FD4F4
	clr.w	(word_FFD5A6).w
	addq.w	#1,(word_FFD5A4).w
	cmpi.w	#6,(word_FFD5A4).w
	blt.w	.FD4F4
	move.w	#5,(word_FFD5A4).w
.FD4F4
	move.w	(word_FFD5A4).w,d1
	asl.w	#2,d1
	movea.l	#unk_FD548,a1
	move.w	(word_FFD5A0).w,d0
	cmp.w	(word_FFD5A2).w,d0	;home - visitors
	bgt.w	.FD516
	beq.w	.FD51E
	movea.l	#unk_FD560,a1
.FD516
	movea.l	0(a1,d1.w),a1
	bra.w	.FD524
.FD51E
	movea.l	#unk_FD5A8,a1	;equal
.FD524
	move.w	#2,(word_FFB030).w
	jsr	(printz).l
	String	$FF,$13,$16	;IDA: ori.b / move.b d0,d3
	jsr	(print2).l
	move.w	#0,(word_FFB030).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
unk_FD548	;IDA name. Home advantage marks, by word_FFD5A4 (0-5)
	dc.l	unk_FD578,unk_FD57E,unk_FD584,unk_FD58A,unk_FD58A,unk_FD58A
unk_FD560	;IDA name. Visitors advantage marks
	dc.l	unk_FD590,unk_FD596,unk_FD59C,unk_FD5A2,unk_FD5A2,unk_FD5A2
unk_FD578	String	'   '
unk_FD57E	String	']  '
unk_FD584	String	']] '
unk_FD58A	String	']]]'
unk_FD590	String	'   '
unk_FD596	String	'  ['
unk_FD59C	String	' [['
unk_FD5A2	String	'[[['
unk_FD5A8	String	'   '	;IDA name. Even teams
sub_FD5AE	;94 only. The text player's '=' (a2 = HmShots) and '*' (AwShots): return a1 = the team nickname String, or 'Home' / 'Visitors' when it is empty (the all star teams)
	movem.l	d0/a0/a2,-(sp)
	movea.l	a2,a1
	movea.l	$1E(a1),a1	;tmdata
	adda.w	4(a1),a1	;city
	adda.w	(a1),a1	;abbreviation
	adda.w	(a1),a1	;nickname
	cmpi.w	#2,(a1)	;empty String?
	bne.w	.FD5DE
	movea.l	#unk_FD5E4,a1
	cmpa.l	#HmShots,a2
	beq.w	.FD5DE
	movea.l	#unk_FD5EA,a1
.FD5DE
	movem.l	(sp)+,d0/a0/a2
	rts
unk_FD5E4	String	'Home'	;IDA name
unk_FD5EA	String	'Visitors'	;IDA name
sub_FD5F4	;94 only. The text player's '^' (a2 = HmShots) and ';' (AwShots): return a1 = the team arena String
	movem.l	d0/a0/a2,-(sp)
	movea.l	a2,a1
	movea.l	$1E(a1),a1	;tmdata
	adda.w	4(a1),a1	;city
	adda.w	(a1),a1
	adda.w	(a1),a1
	adda.w	(a1),a1	;arena
	movem.l	(sp)+,d0/a0/a2
	rts
sub_FD60E	;no IDA label (IDA dc.b, no xref). An empty routine
	movem.l	d0-d7/a0-a6,-(sp)
	movem.l	(sp)+,d0-d7/a0-a6
	rts
