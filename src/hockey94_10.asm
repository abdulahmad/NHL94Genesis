;	NHL 94 (retail) segment $18380-$18CFB
;	92 hockey.asm ResolveGames and the 92 exception handlers, as 93 hockey93_10: ResolveGames, the end of game Stars of the Game box
;	(DisplayPeriodOver, FindMaxAttributeTEam, CalculateTeamAttributes / Values), the injury box (ShowInjuryBox), the 94-only penalty
;	shot box (sub_187B8), the goal box (DisplayPlayerAttributeMenu), box, the player name formatters (sub_18A6E, getname ...
;	FinalizeTextBuffer, getplayername, d0toascii) and AddError, Illinst, ZeroDiv and crash. cd0 (hockey94_11) follows at $18CFC.
;	Transcribed from lst/nhl94.bin.lst lines 55538-56542. Global names are the IDA names, or the 93 name where IDA has an auto name
;	(IDA name in an ;IDA: comment); the exception handlers have the main94 vector names. Locals are the IDA local names (_x -> .x)
;	or the IDA address (loc_183B0 -> .183B0); crash's helper sub_18CDC is the 93 local .ri.
;	IDA gaps written from the retail bytes: the printz / printbigz / appendz strings that IDA shows as code or dc.b, the instructions
;	IDA hid in them (moveq #$1B,d0, moveq #$13,d0, move.w (BA_Checker_Offset).w,d0, two move.w d0,-(sp), the exception handlers'
;	move.l $A(sp),d0 / 2(sp),d0), and the printbig String tables. IDA labels inside those strings (unk_18A3B, unk_18A45) are dropped.
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp / cmpi;
;	fixopcodes.js patches the cmp encoding after assembly.
;	gsstruct game ($10 bytes, 93 gstruct): 0 gst1, 2 gst2, 4 gspotwins, 6 gspobwins, 8 gsper, $A gss1, $C gss2, $E gsflags.
;	Team struct: $C goals, $28 team, $B4 / $CE / $E8 goals / assists / shots bytes per roster slot, $136 frames on ice; tmsize $364.

ResolveGames	;IDA: sub_18380 (93 name). Compute winners and losers for playoff matchups (92 ResolveGames). Called from EncodePW (hockey94_09)
	move.w	(gamenum).w,d0
	mulu.w	#$10,d0
	movea.w	#(gsstruct-M68K_RAM),a0
	move.w	(HmGoals).w,$A(a0,d0.w)	;copy score from played game into game structures (gss1, gss2)
	move.w	(AwGoals).w,$C(a0,d0.w)
	bsr.w	GetShifter
	movea.w	#(gsstruct-M68K_RAM),a0
	moveq	#$10,d3
	mulu.w	d1,d3
	adda.w	d3,a0
	cmpi.w	#7,(bosgames).w
	beq.w	.184D0	;not best of 7
.183B0
	cmpi.w	#4,4(a0)	;series complete? (gspotwins)
	beq.w	.183E8
	cmpi.w	#4,6(a0)
	beq.w	.183E8
	clr.w	d3
	btst	#0,$E(a0)	;teams flipped (92 gsftf)
	beq.w	.183D4
	eori.w	#2,d3
.183D4
	move.w	$A(a0),d0
	sub.w	$C(a0),d0
	bpl.w	.183E4
	eori.w	#2,d3
.183E4
	addq.w	#1,4(a0,d3.w)	;one more win
.183E8
	suba.w	#$10,a0
	dbf	d1,.183B0
	addq.w	#1,(bosgames).w
	cmpi.w	#7,(bosgames).w
	beq.w	.1848A
	move.w	(gamenum).w,d0
	mulu.w	#$10,d0
	movea.w	#(gsstruct-M68K_RAM),a0
	adda.w	d0,a0
	cmpi.w	#4,4(a0)
	beq.w	.18420
	cmpi.w	#4,6(a0)
	bne.w	rtss2
.18420
	cmpi.w	#3,(gamelevel).w	;finish off rest of round games here
	bge.w	.1848A
	bsr.w	GetShifter
	movea.w	#(gsstruct-M68K_RAM),a0
	moveq	#$10,d3
	mulu.w	d1,d3
	adda.w	d3,a0
.18438
	cmp.w	(gamenum).w,d1
	beq.w	.18474
	cmpi.w	#4,4(a0)
	beq.w	.18474
	cmpi.w	#4,6(a0)
	beq.w	.18474
	addq.w	#1,4(a0)
	move.l	#$C8,d0	;200
	jsr	(randomd0).l
	andi.w	#1,d0
	beq.s	.18438
	subq.w	#1,4(a0)
	addq.w	#1,6(a0)
	bra.s	.18438
.18474
	suba.w	#$10,a0
	dbf	d1,.18438
	movea.w	#(unk_FFD176-M68K_RAM),a3	;bits before advancing to next round (93 tpassbits)
	bsr.w	WritePassBits
	bset	#2,(sflags3).w	;93 sf3alttree
.1848A
	clr.w	(bosgames).w	;advance to next round
	bsr.w	GetShifter
	movea.w	#(gsstruct-M68K_RAM),a0
	moveq	#$10,d3
	mulu.w	d1,d3
	adda.w	d3,a0
	clr.w	d3
.1849E
	cmpi.w	#4,4(a0)
	beq.w	.184AA
	bset	d1,d3
.184AA
	clr.w	4(a0)
	clr.w	6(a0)
	suba.w	#$10,a0
	dbf	d1,.1849E
	moveq	#1,d1
	asl.w	d2,d1
	subq.w	#1,d1
	and.w	d1,(word_FFCEF2).w	;clear this round's winbits (93 WinBits)
	asl.w	d2,d3
	or.w	d3,(word_FFCEF2).w
	addq.w	#1,(gamelevel).w
	rts
.184D0
	clr.w	d3	;solve for no best of 7 playoffs (much simpler)
.184D2
	move.w	$A(a0),d0
	cmp.w	$C(a0),d0
	bhi.w	.184E0
	bset	d1,d3
.184E0
	btst	#0,$E(a0)
	beq.w	.184EC
	bchg	d1,d3
.184EC
	suba.w	#$10,a0
	dbf	d1,.184D2
	moveq	#1,d1
	asl.w	d2,d1
	subq.w	#1,d1
	and.w	d1,(word_FFCEF2).w
	asl.w	d2,d3
	or.w	d3,(word_FFCEF2).w
	addq.w	#1,(gamelevel).w
	rts
DisplayPeriodOver	;IDA: sub_1850A (93 name). End of game Stars of the Game box. Called from UpdatePA (penalty94_1) while RefPen is the game over
	;penalty. Waits for RefCnt <= $40 and runs once (gmode bit 7); 94 then sets disflags bit 3 and waits a vblank. Frames the box, draws a bitmap
	;from Rinktilelist (93 IceRinkMap), then the three best star scores (FindMaxAttributeTEam): team abbreviation and getname. Song $F when the
	;home team won
	cmpi.w	#$40,(RefCnt).w
	bgt.w	rtss2	;ref animation not far enough yet
	bset	#7,(gmode).w
	bne.w	rtss2	;already shown
	movem.l	d0/a1,-(sp)
	bset	#3,(disflags).w
	move.w	(vcount).w,d0
.1852C
	cmp.w	(vcount).w,d0
	beq.s	.1852C
	movem.l	(sp)+,d0/a1
	movem.l	d0-d5/a0-a4,-(sp)
	bsr.w	printz
	String	$BF,2,$E	;IDA: ori.b (and dropped a word)
	moveq	#$1C,d0	;framer size
	moveq	#9,d1
	bsr.w	Framer
	bsr.w	printz
	String	$BF,9,$10,'Stars of the Game',$BF,3,$F	;IDA: code
	movea.l	#Rinktilelist,a1	;IDA hid this in the string. map at offset 4
	movea.w	#$30A,a2	;a zero long (93 #$310)
	adda.l	4(a1),a1
	moveq	#$D,d0
	moveq	#$5B,d1
	moveq	#6,d2
	moveq	#4,d3
.18580
	move.w	(rinkvrcset).w,d4
	clr.w	d5
	bsr.w	dobitmap
	bsr.w	CalculateTeamAttributes
	move.w	#$12,(printy).w
	moveq	#2,d2	;3 stars
.18596
	bsr.w	FindMaxAttributeTEam	;a2 = team, d0 = player
	move.w	#$1A,(printx).w
	addq.w	#1,(printy).w
	movea.l	$1E(a2),a1
	adda.w	4(a1),a1
	adda.w	(a1),a1
	bsr.w	print
	bsr.w	getname	;a1 = number and name of player d0
	move.w	#3,(printx).w
	bsr.w	print
	dbf	d2,.18596
	move.w	(HmGoals).w,d0
.185C8
	sub.w	(AwGoals).w,d0
	ble.w	.185DA
	move.w	#$F,-(sp)	;song $F: home team won
	jsr	(song).l
.185DA
	movem.l	(sp)+,d0-d5/a0-a4
	rts
FindMaxAttributeTEam	;IDA: sub_185E0 (93 name). Take the highest of the 52 star scores at ThreeStars (93 DispAttribCtr; 26 per team, home first)
	;and clear it. Returns d0 = player slot, a2 = its team struct. Called from DisplayPeriodOver
	movem.l	d1-d2/a1/a4,-(sp)
	movea.w	#(ThreeStars-M68K_RAM),a4
	clr.l	d0
	moveq	#$33,d2
.185EC
	cmp.l	(a4)+,d0
	bge.w	.185F8	;not higher
	lea	-4(a4),a1
	move.l	(a1),d0
.185F8
	dbf	d2,.185EC
	clr.l	(a1)
	move.w	a1,d0
	subi.w	#(ThreeStars-M68K_RAM),d0
	lsr.w	#2,d0	;entry number
	movea.w	#(HmShots-M68K_RAM),a2
	cmp.w	#$1A,d0
	blt.w	.1861A
	subi.w	#$1A,d0
	adda.w	#$364,a2	;26-51: away team (tmsize)
.1861A
	movem.l	(sp)+,d1-d2/a1/a4
	rts
CalculateTeamAttributes	;IDA: sub_18620 (93 name). Star score for every roster slot of both teams to ThreeStars (26 longs per team, home first). d5 =
	;GetPeriodTime + d2, the goalie ice time needed. If gsp is 3 and the score is not tied, the scorer of the last goal gets $7FFFFFFF. Called
	;from DisplayPeriodOver
	movea.w	#(ThreeStars-M68K_RAM),a4
	jsr	(GetPeriodTime).w	;IDA: ClockLength
	move.w	d0,d5
	add.w	d2,d5
	movea.w	#(HmShots-M68K_RAM),a2
	lea	$364(a2),a3
	bsr.w	CalculateTeamAttributeValues	;home
	movea.w	a3,a2
	lea	-$364(a2),a3
	bsr.w	CalculateTeamAttributeValues	;away (d3 = away - home score)
	cmpi.w	#3,(gsp).w
	bne.w	.1867C
	tst.w	d3
	beq.w	.1867C	;tied
	movea.w	#(ChkCnt-M68K_RAM),a0	;+ ScoreSumbytes = last goal entry
	adda.w	(ScoreSumbytes).w,a0
	clr.w	d0
	btst	#7,2(a0)
	beq.w	.1866A
	addi.w	#$1A,d0	;away goal: second 26 entries
.1866A
	add.b	3(a0),d0
	asl.w	#2,d0
	movea.w	#(ThreeStars-M68K_RAM),a0
	move.l	#$7FFFFFFF,0(a0,d0.w)	;game winner is the first star
.1867C
	rts
CalculateTeamAttributeValues	;IDA: sub_1867E (93 name). Star scores of team a2 (a3 = other team) to (a4)+, one long per roster slot (26). Each
	;starts at the goal difference. Skaters: goals*11000 + assists*10100 + shots*10, or in a tied game shots*1000 + frames on ice. Goalies on ice
	;at least d5 with shots against: +32000 if goals against*100/shots <= 4, +75000 more for a shutout. Called from CalculateTeamAttributes
	movea.w	a2,a1
	move.w	$C(a2),d3
	sub.w	$C(a3),d3	;goal difference (HmGoals / AwGoals)
	ext.l	d3
	moveq	#$19,d4	;26 slots
	jsr	(sub_9F40).l	;d0 = goalies on the team (93 ReadAttributeNibble)
	neg.w	d0
	add.w	d4,d0
.18696
	move.l	d3,(a4)
	cmp.w	d0,d4
	bhi.w	.186D8	;goalie slot
	clr.w	d1
	move.b	$B4(a2),d1
	mulu.w	#$2AF8,d1	;goals * 11000
	add.l	d1,(a4)
	clr.w	d1
	move.b	$CE(a2),d1
	mulu.w	#$2774,d1	;assists * 10100
	add.l	d1,(a4)
	clr.w	d1
	move.b	$E8(a2),d1
	mulu.w	#$A,d1
	tst.w	d3
	bne.w	.186D2	;not tied: shots * 10
	mulu.w	#$64,d1	;tied: shots * 1000
	add.l	d1,(a4)
	clr.l	d1
	add.w	$136(a1),d1	;+ frames on ice
.186D2
	add.l	d1,(a4)
	bra.w	.18710
.186D8
	cmp.w	$136(a1),d5
	bhi.w	.18710	;not on ice long enough
	clr.w	d1
	move.b	$B4(a2),d1
	mulu.w	#$64,d1
	clr.w	d2
	move.b	$E8(a2),d2
	beq.w	.18710
	divu.w	d2,d1
	cmp.w	#4,d1
	bhi.w	.18710
	addi.l	#$7D00,(a4)	;32000
	tst.w	d1
	bne.w	.18710
	addi.l	#$124F8,(a4)	;75000 for a shutout
.18710
	addq.w	#2,a1
	addq.w	#1,a2
	addq.w	#4,a4
	dbf	d4,.18696
	rts
ShowInjuryBox	;IDA: loc_1871C (93 name). Injury box: 'Injury to:' player TempPlOffset (GetPlayerNameWithAttrib), 'Out for period', or 'Out for game'
	;when byte_FFC2FC bit 5 is set (94), and 'the game' over 'period' when puck_pflags2 bit 0 (93 pf2fight) is set. Jumped to from CheckInjury
	;(hockey94_01), so global
	movem.l	d0-d2/a0-a4,-(sp)
	bsr.w	printz
	String	$BF,$B,3	;IDA: ori.b / btst
	moveq	#$12,d0	;framer size
	moveq	#5,d1
	bsr.w	Framer
	btst	#5,(byte_FFC2FC).w
	bne.w	.18768
	bsr.w	printz
	String	$BF,$C,4,'Injury to:',$BF,$C,6,'Out for period',$BF,$C,5	;IDA: code
	bra.w	.1878E
.18768
	bsr.w	printz
	String	$BF,$C,4,'Injury to:',$BF,$C,6,'Out for game',$BF,$C,5	;IDA: code
.1878E
	bsr.w	GetPlayerNameWithAttrib
	bsr.w	print
	btst	#0,(puck_pflags2).w
	beq.w	.187B2
	bsr.w	printz
	String	$BF,$14,6,'the game'	;IDA: ori.b / addi.w / bsr.s
.187B2
	movem.l	(sp)+,d0-d2/a0-a4	;IDA: bcs.w / move.b (IDA hid this in the string)
	rts
sub_187B8	;94 only. Penalty shot box, called from chkprogress (penalty94_1). Sets word_FFC2FA bit 7; in Shootout (bit 0) jumps to loc_FC320
	;instead. Otherwise: printbig 'PENALTY SHOT!', the shooter (BA_Sktr_SCnum, BA_Team), the penalty name (PenaltyList, word_FFD410) and ' by' the
	;player BA_Checker_Offset of the other team
	bset	#7,(word_FFC2FA).w
	btst	#0,(word_FFC2FA).w
.187C4
	beq.w	.187CE
	jmp	loc_FC320
.187CE
	movem.l	d0-d2/a0-a4,-(sp)
	move.w	#$FFFF,d0
	jsr	(prefmes).l	;d0 = -1
	bsr.w	printz
	String	$BF,3,2	;IDA: ori.b / andi.b
	moveq	#$1B,d0	;IDA hid this in the string
.187E8
	moveq	#8,d1
	bsr.w	Framer
.187EE
	lea	unk_18884(pc),a1
.187F2
	bsr.w	printbig
	move.w	(BA_Sktr_SCnum).w,d0
	asl.w	#7,d0	;sprite structs are $80 bytes
	movea.l	#SortCords,a2
	adda.w	d0,a2
	clr.w	d0
	move.b	$66(a2),d0	;roster slot
	movea.l	#HmShots,a2
	tst.w	(BA_Team).w
	beq.w	.1881E
.18818
	movea.l	#AwShots,a2
.1881E
	bsr.w	FormatPlayerNameWithAttrib
	bsr.w	print
	bsr.w	printz
	String	$BF,4,7	;IDA: ori.b / btst
	movem.l	a1/a3,-(sp)
	move.w	(word_FFD410).w,d0
	movea.l	#PenaltyList,a1
	adda.w	0(a1,d0.w),a1
	lea	2(a1),a1
	bsr.w	print
	movem.l	(sp)+,a1/a3
	bsr.w	printz
	String	' by',$BF,4,8	;IDA: ori.b / subi.b / add.b
	move.w	(BA_Checker_Offset).w,d0	;IDA hid this in the string
	movea.l	#AwShots,a2
	tst.w	(BA_Team).w
	beq.w	.18872
	movea.l	#HmShots,a2
.18872
	jsr	(FormatPlayerNameWithAttrib).l
	jsr	(print).l
	movem.l	(sp)+,d0-d2/a0-a4
	rts
unk_18884	String	$BF,4,3,'PENALTY SHOT!',$BF,4,5	;IDA name. printbig String for sub_187B8
DisplayPlayerAttributeMenu	;IDA: loc_1889A (93 name). Goal box. Closes both line change boxes, then printbig 'GOAL!' ('PP GOAL!' when DelayedPen
	;bit 0 is set, cleared here), or 'HAT TRICK!' on the scorer's third goal when the scorer's slot is at least word_FFBF48 (word_FFD448 home /
	;word_FFD44A visitors), then the scorer and up to two assists of the last goal entry (FormatPlayerName). 94 calls sub_F9FC0, sub_FE510 (home
	;hat trick), sub_FEAFA and sub_FEAE4 (not matched yet); BA_PS_flags bit 2 sets sflags2 bit 2. Called from SetPA (penalty94_1)
	movem.l	d0-d2/a0-a4,-(sp)
	btst	#2,(BA_PS_flags).w
	beq.w	.188AE
	bset	#2,(sflags2).w
.188AE
	movea.w	#(HmShots-M68K_RAM),a2
	jsr	(lcfound2).l	;close lc box
	adda.w	#$364,a2
	jsr	(lcfound2).l
	movea.w	#(ChkCnt-M68K_RAM),a4	;+ ScoreSumbytes = last goal entry
	adda.w	(ScoreSumbytes).w,a4
	bsr.w	printz
	String	$BF,$B,2	;IDA: ori.b / andi.b
	moveq	#$13,d0	;IDA hid this in the string
	move.w	#5,d1	;5 rows: no assist
	tst.b	4(a4)
	bmi.w	.188EE
	addq.w	#2,d1	;7: one assist
	tst.b	5(a4)
	bmi.w	.188EE
	addq.w	#1,d1	;8: two assists
.188EE
	bsr.w	Framer
	jsr	(sub_F9FC0).l
	movea.w	#(HmShots-M68K_RAM),a2
	move.w	(word_FFD448).w,(word_FFBF48).w
	btst	#7,2(a4)
	beq.w	.18916	;home team scored
	adda.w	#$364,a2
	move.w	(word_FFD44A).w,(word_FFBF48).w
.18916
	lea	unk_18A14(pc),a1
	bclr	#0,(DelayedPen).w
	beq.w	.18928
	lea	unk_18A34(pc),a1
.18928
	clr.w	d0
	move.b	3(a4),d0	;scorer
	addi.w	#$B4,d0
	cmpi.b	#3,0(a2,d0.w)	;goals
	bne.w	.1896E
	movem.w	d1,-(sp)
	clr.w	d1
	move.b	3(a4),d1
	cmp.w	(word_FFBF48).w,d1
	movem.w	(sp)+,d1
	blt.w	.1896E
	adda.w	(a1),a1	;HAT TRICK!
	move.w	d0,-(sp)
	move.w	$28(a2),d0
	cmp.w	(HomeTeam).w,d0
	bne.w	.1896C
	move.w	#0,d0
	jsr	(sub_FE510).l
.1896C
	move.w	(sp)+,d0
.1896E
	bsr.w	printbig
	clr.w	d0
	move.b	3(a4),d0
	move.w	d0,-(sp)
	move.w	#$C,(printx).w
	bsr.w	FormatPlayerName
	bsr.w	print
	move.w	(sp)+,d0
	movem.w	d1,-(sp)
	clr.w	d1
	move.b	3(a4),d1
	cmp.w	(word_FFBF48).w,d1
	movem.w	(sp)+,d1
	blt.w	.189A6
	jsr	(sub_FEAFA).l
.189A6
	clr.w	d0
	move.b	4(a4),d0	;first assist
	bmi.w	.18A08
	bclr	#5,(word_FFC2F4).w
	bne.w	.18A08	;word_FFC2F4 bit 5 set: no assists
	bsr.w	printz
	String	$BF,$E,6,'Assist by:',$BF,$C,7	;IDA: code
	move.w	d0,-(sp)	;IDA hid this in the string
	bsr.w	FormatPlayerName
	bsr.w	print
	move.w	(sp)+,d0
	jsr	(sub_FEAE4).l
	clr.w	d0
	move.b	5(a4),d0	;second assist
	bmi.w	.18A08
	bsr.w	printz
	String	$BF,$C,8	;IDA: ori.b / #0
	move.w	d0,-(sp)	;IDA hid this in the string
	bsr.w	FormatPlayerName
	bsr.w	print
	move.w	(sp)+,d0
	jsr	(sub_FEAE4).l
.18A08
	bclr	#5,(word_FFC2F4).w
	movem.l	(sp)+,d0-d2/a0-a4
	rts
unk_18A14	String	$BF,$F,3,'GOAL!',$BF,$C,5	;IDA name. printbig Strings for DisplayPlayerAttributeMenu (93 attrText): GOAL!, then HAT TRICK!
	String	$BF,$C,3,'HAT TRICK!',$BF,$C,5
unk_18A34	String	$BF,$D,3,'PP GOAL!',$BF,$C,5	;IDA name. The same after DelayedPen bit 0: PP GOAL!, then HAT TRICK!
	String	$BF,$C,3,'HAT TRICK!',$BF,$C,5
box	;IDA name (93 box). Fill a $13 x 8 rectangle at printz position $FF,$B,2 with char $7FF (eraser). Called from SetLCmode2 (logic94_1)
	bsr.w	printz
	String	$FF,$B,2	;IDA dc.b
	moveq	#$13,d0	;IDA hid this in the string
	moveq	#8,d1
	move.l	#$7FF,d2
	bra.w	eraser
sub_18A6E	;93 GetPlayerName, but that is the same symbol as getplayername (SNASM symbols are case-insensitive).
	;a1 = mesarea "NN First Last" (getname) for player TempPlOffset (bit 15 set: away team). Called from UpdatePA (penalty94_1)
	movem.l	d0/a2,-(sp)
	movea.w	#(HmShots-M68K_RAM),a2
	move.w	(TempPlOffset).w,d0
	bpl.w	.18A86
	andi.w	#$FF,d0
	adda.w	#$364,a2	;away team (tmsize)
.18A86
	bsr.w	getname
	movem.l	(sp)+,d0/a2
	rts
getname	;IDA name (93 getname). gets player number and name, appends to string: a1 = mesarea "NN First Last" for player d0 (roster offset) of team struct a2. The number is the bcd byte after the name
	movem.l	d0-d3/a0/a2-a3,-(sp)	;push to stack
	bsr.w	getplayername	;get to start of player name
	move.l	a0,-(sp)	;push a0 (address to start of player name) to stack
	movea.w	#(mesarea-M68K_RAM),a3	;move mesarea to a3 address
	move.w	#4,(a3)	;move 4 into a3 address location
	lea	2(a3),a1	;move long address at a3+2 into a1
	adda.w	(a0),a0	;add data at a0 (player name length) to a0
	move.b	(a0),d0	;move a0 data (jersey #) to d0
	bsr.w	d0toascii	;convert JNo to ascii
	bsr.w	appendz	;add space after JNo
	String	' '
	movea.l	(sp)+,a1	;pop from stack into a1 (address to start of player name)
	bsr.w	appstring	;add player name to string a3
	movea.w	#(mesarea-M68K_RAM),a1	;move mesarea address into a1
	movem.l	(sp)+,d0-d3/a0/a2-a3	;pop from stack
	rts
GetPlayerNameWithAttrib	;IDA: sub_18AC6 (93 name). a1 = mesarea "NN F. Last" (FormatPlayerNameWithAttrib) for player TempPlOffset (bit 15 set: away team). Called from ShowInjuryBox
	movem.l	d0/a2,-(sp)
	movea.w	#(HmShots-M68K_RAM),a2
	move.w	(TempPlOffset).w,d0
	bpl.w	.18ADE
	andi.w	#$FF,d0
	adda.w	#$364,a2
.18ADE
	bsr.w	FormatPlayerNameWithAttrib
	movem.l	(sp)+,d0/a2
	rts
FormatPlayerNameWithAttrib	;IDA: sub_18AE8 (93 name). a1 = mesarea string "NN F. Last" for player d0 of team a2, built in word_FFBFA6 (93 TextBuffer). Called from sub_187B8 and others
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	getplayername
	move.l	a0,-(sp)
	movea.w	#(word_FFBFA6-M68K_RAM),a1
	adda.w	(a0),a0
	move.b	(a0),d0
	bsr.w	d0toascii
	move.b	#$20,(a1)+
	movea.l	(sp)+,a0
	move.w	(a0)+,d0
	lea	-2(a0,d0.w),a2
	move.b	(a0)+,(a1)+	;first initial
	move.w	#$2E20,(a1)+	;'. '
.18B10
	cmpi.b	#$20,(a0)+
	bne.s	.18B10
.18B16
	move.b	(a0)+,(a1)+
	cmpa.l	a0,a2
	bne.s	.18B16
	bsr.w	FinalizeTextBuffer
	movem.l	(sp)+,d0-d3/a0/a2
	rts
FormatPlayerName	;IDA: sub_18B26 (93 name). a1 = mesarea string "NN Last" for player d0 of team a2, built in word_FFBFA6. Called from DisplayPlayerAttributeMenu and others
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	getplayername
	move.l	a0,-(sp)
	movea.w	#(word_FFBFA6-M68K_RAM),a1
	adda.w	(a0),a0
	move.b	(a0),d0
	bsr.w	d0toascii
	move.b	#$20,(a1)+
	movea.l	(sp)+,a0
	move.w	(a0)+,d0
	lea	-2(a0,d0.w),a2
.18B48
	cmpi.b	#$20,(a0)+
	bne.s	.18B48
.18B4E
	move.b	(a0)+,(a1)+
	cmpa.l	a0,a2
	bne.s	.18B4E
	bsr.w	FinalizeTextBuffer
	movem.l	(sp)+,d0-d3/a0/a2
	rts
sub_18B5E	;94 only. FormatPlayerNameShort without the leading space ("Last", space padded). Branches into loc_18B7E
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	getplayername
	movea.w	#(word_FFBFA6-M68K_RAM),a1
	bra.w	loc_18B7E
FormatPlayerNameShort	;IDA: sub_18B6E (93 name). a1 = mesarea string " Last" for player d0 of team a2, space padded to 12 characters; a 0 byte also ends the name
	movem.l	d0-d3/a0/a2,-(sp)
	bsr.w	getplayername
	movea.w	#(word_FFBFA6-M68K_RAM),a1
	move.b	#$20,(a1)+
loc_18B7E	;IDA label. Skip the first name, copy the last name, pad; branched to from sub_18B5E, so global
	move.w	(a0)+,d0
	lea	-2(a0,d0.w),a2
.18B84
	cmpi.b	#$20,(a0)+
	bne.s	.18B84
.18B8A
	move.b	(a0)+,(a1)+
	cmpa.l	a0,a2
	beq.w	.18B9E
	tst.b	(a0)
	bne.s	.18B8A
	bra.w	.18B9E
.18B9A
	move.b	#$20,(a1)+
.18B9E
	cmpa.w	#$BFB2,a1	;word_FFBFA6+12
	blt.s	.18B9A
	bsr.w	FinalizeTextBuffer
	movem.l	(sp)+,d0-d3/a0/a2
	rts
FinalizeTextBuffer	;IDA: sub_18BAE (93 name). mesarea length word = a1 - mesarea, with a 0 pad byte when odd. Returns a1 = mesarea. Called from the FormatPlayerName routines
	move.w	a1,d0
	subi.w	#(mesarea-M68K_RAM),d0
	btst	#0,d0
	beq.w	.18BC0
	clr.b	(a1)+
	addq.w	#1,d0
.18BC0
	movea.w	#(mesarea-M68K_RAM),a1
	move.w	d0,(a1)
	rts
getplayername	;IDA name (93 GetPlayerNamePointer). loops through team roster to get to d0 player: a0 = name string of player d0 (roster offset) of
	;team struct a2. Each record is a length word String and 8 more bytes
	movea.l	$1E(a2),a0	;offset $1E - ROM address of team data?
	adda.w	(a0),a0	;add offset (player data start) to a0 address
	bra.w	.loop
.skip
	adda.w	(a0),a0	;add player name length to a0
	addq.w	#8,a0	;add 8 to a0 (player attributes field)
.loop
	dbf	d0,.skip	;loop until at player offset
	rts
d0toascii	;IDA name (93 ConverByteToDigits). converts decimal number in d0 to ascii: two ascii digits of bcd byte d0 to (a1)+, a leading 0 becomes a space ($F0 + '0')
	move.w	d0,-(sp)	;push to stack
	lsr.b	#4,d0	;divide by 16 (get upper digit in d0)
	bne.w	.n0	;branch if not 0
	move.b	#$F0,d0	;move $F0 into d0
.n0
	addi.b	#$30,d0	;'0'   ; add $30 (48 dec) to d0
	move.b	d0,(a1)+	;move d0 into a1 and increment
	move.w	(sp)+,d0	;pop d0 from stack
	andi.w	#$F,d0	;pass bottom 4 bytes of d0 (lower digit in d0)
	addi.b	#$30,d0	;'0'   ; add $30 (48 dec) to d0
	move.b	d0,(a1)+	;move d0 into a1 and increment
	rts
AddError	;IDA: AdrErr (92 / 93 name, main94 vectors). Address error vector; 94 has no BusError, the bus error vector also points here
	move	#$2700,sr
	bsr.w	printbigz
	String	$BD,0,0,'Address Error'	;IDA dc.b
	move.l	$A(sp),d0	;pc. IDA dc.b
	move.l	2(sp),d1	;access address
	bra.w	crash
Illinst	;IDA: InvOpCode (92 / 93 name, main94 vectors). Illegal instruction vector
	move	#$2700,sr
	bsr.w	printbigz
	String	$BD,0,0,'Illegal Instruction'	;IDA dc.b
	move.l	2(sp),d0	;IDA dc.b
	move.l	d0,d1
	bra.w	crash
ZeroDiv	;IDA: DivBy0 (92 / 93 name, main94 vectors). Divide by zero vector, falls into crash
	move	#$2700,sr
	bsr.w	printbigz
	String	$BD,0,0,'Division by zero'	;IDA dc.b
	move.l	2(sp),d0	;IDA dc.b
	move.l	d0,d1
crash	;IDA: loc_18C70 (92 / 93 name). printbig d1 then d0 as hex, set the vdp up, copy 8 longs from the Rinktilelist palette + $20 (93 IceRinkMap)
	;to cram $20 and hang. Branched to from AddError and Illinst, falls in from ZeroDiv
	movea.w	#(mesarea-M68K_RAM),a0
	move.w	#$18,(a0)+	;2+3+8+3+8 (93 form)
	move.b	#$BD,(a0)+	;92 -$43
	move.b	#0,(a0)+
	move.b	#2,(a0)+
	move.l	d1,-(sp)
	bsr.w	.ri	;d1
	move.b	#$BD,(a0)+
	move.b	#0,(a0)+
	move.b	#4,(a0)+
	move.l	(sp)+,d0
	bsr.w	.ri	;d0
	movea.w	#(mesarea-M68K_RAM),a1
	bsr.w	printbig
	movea.l	#VDP_DATA,a0
	move.w	#$9100,4(a0)
	move.w	#$9206,4(a0)
	move.w	#$8F02,4(a0)
	move.l	#$C0200000,4(a0)	;cram write $20 (92 $C0060000)
	movea.l	#Rinktilelist,a1
	adda.l	(a1),a1
	adda.w	#$20,a1
	moveq	#7,d0
.18CD2
	move.l	(a1)+,(a0)
	dbf	d0,.18CD2
.18CD8
	bra.w	.18CD8
.ri	;IDA: sub_18CDC (93 local .ri). d0 as 8 hex digits to (a0)+
	moveq	#7,d2
.18CDE
	rol.l	#4,d0
	move.w	d0,d1
	andi.w	#$F,d1
	addi.w	#$30,d1
	cmp.w	#$39,d1
	ble.w	.18CF4
	addq.w	#7,d1	;'A'-'0'-10
.18CF4
	move.b	d1,(a0)+
	dbf	d2,.18CDE
	rts
