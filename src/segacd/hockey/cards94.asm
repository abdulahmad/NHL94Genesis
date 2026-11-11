;	HOCKEY.BIN $9B5E-$B347 (runtime $24B5E-$26347): cards94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	The record bookkeeping (GetRecordValue, UpdateRecords ...) and CalcAttrib are the cartridge code. CD: the
;	save RAM readers (ReadPlayerRecord ... NameLogIO) moved next to sram94 (file $7534); FeaturedPictures and
;	the player card screen (PlayerCards ...
;
;	BuildCardPlayerList) are gone; TeamPalettes stay (read from the disc file); pictures come through
;	FeaturedPicturesPtr ($47D88); MenuWaitVblank became the BIOS call at $6044.

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

TeamList	equ	$1B00C
ReadPlayerRecord	equ	$22534
WritePlayerRecord	equ	$22582
ReadCrowdRecord	equ	$2258E
WriteCrowdRecord	equ	$225CC
ReadTeamRecord	equ	$225D8
WriteTeamRecord	equ	$22616
checkcornercoll	equ	$22FBE
LogoBoxRight	equ	$24AD6
LogoBoxLeft	equ	$24AFA
UnpackPicture	equ	$2A902
GetGoalieCount	equ	$2ED60
GetPlayerCount	equ	$2EDBC
dobitmap	equ	$387E2
eraser	equ	$38C06
Framer	equ	$38CA0
printsmall	equ	$38D9E
printz	equ	$38F6E
appstring	equ	$39208
ConvertByteToDigits	equ	$412A8
PAttribOverallMask	equ	$41C70
GAttribOverallMask	equ	$41DD2
PicturePalette	equ	$428A0
NoPicSkater1	equ	$42CD6
NoPicSkater2	equ	$43040
NoPicGoalie1	equ	$433AA
NoPicGoalie2	equ	$43714
LoadGameGfx	equ	$2B614
ExitStatsScreen	equ	$2E980
forceblack	equ	$36D0A
DoDMApro	equ	$37762

	org	$24B5E

;	New in 94: player cards and saved records. This file times and draws the player cards on the
;	game setup screen, loads team colors and featured player pictures, and keeps the team, player,
;	crowd and user records in save RAM. Print strings follow the calls that print them.

ResetCardTimer						;Reset the player card timer cardtimer to $AA ($53 if C was pressed).
									;Called from ReadSetupPads, PrintOptions and PlayerCardTimer
	move.w	#$AA,(cardtimer).l		;normal wait
	btst.b	#5,(setupcardflags).l	;C held (bit 5): use the shorter wait
	beq.w	.x
	move.w	#$53,(cardtimer).l		;shorter wait
.x									;exit (also the end of the code above)
	rts
PlayerCardTimer						;Player cards, called each frame from ReadSetupPads in the first minute of
									;its wait. When carddelay runs out set setupcardflags bit 0; then count
									;cardtimer down (C skips $50); at $52 switch sides (bit 1), forget the
									;logos and draw the next card (PlayerCardScreen); below 0 restart the
									;timer (ResetCardTimer)
	subi.w	#1,(carddelay).l		;count down the start delay
	bpl.w	.x
	move.w	#$FFFF,(carddelay).l	;keep it run out
	bset.b	#0,(setupcardflags).l	;first run out: the cards may start
	btst.b	#0,(setupcardflags).l	;cards allowed?
	beq.w	.x
	btst.b	#5,(setupcardflags).l	;C held?
	beq.w	.0
	cmpi.w	#$52,(cardtimer).l		;timer below $52?
	bge.w	.0
	subi.w	#$50,(cardtimer).l		;skip $50 of the wait
.0									;C held and the timer still above $52, or no C: count down normally
	subi.w	#1,(cardtimer).l
	bmi.w	.1						;timer ran out: start the next cycle
	cmpi.w	#$52,(cardtimer).l
	bne.w	.x						;only at $52 is a new card drawn
	bclr.b	#2,(setupcardflags).l	;clear setupcardflags bits 2 and 3
	bclr.b	#3,(setupcardflags).l
	bchg.b	#1,(setupcardflags).l	;the next card goes on the other side
	st.b	(setuphome).l			;force the logo boxes to be redrawn later
	st.b	(setupvis).l
	bclr.b	#6,(setupcardflags).l	;clear setupcardflags bits 6 and 7
	bclr.b	#7,(setupcardflags).l
	jsr	(PlayerCardScreen).l
.x									;exit (also the end of the code above)
	rts
.1									;cardtimer negative
	jmp	(ResetCardTimer).l
PlayerCardScreen					;Draw a player card on one side. setupcardflags bit 1 set: visitors, logo
									;box and picture on the left (column 3), text frame at $B; clear: home,
									;logo box and picture on the right ($1C), text frame at 3. Shows featured
									;player featuredplayer (0-5, from the FeaturedPictures list of the team;
									;next one after each visitors card), his number and name, and with SRAM
									;his user records (PrintRecordValue, PrintRecordHolder, PrintRecordVs).
									;Called from PlayerCardTimer
	movem.l	d0-d7/a0-a6,-(sp)		;the whole card is drawn here, keep all registers
	jsr	(printz).l
	String	CC_Font1,0,0			;x3
	move.w	#$1C,(printx).l			;visitors: erase the other logo box at $1C
	btst.b	#1,(setupcardflags).l	;which side?
	bne.w	.0
	move.w	#3,(printx).l			;home: erase the one at 3
.0									;column chosen
	move.w	#5,(printy).l
	move.w	#8,d0					;clear the 8 x 8 logo area
	move.w	#8,d1
	move.w	#$7FF,d2				;blank char
	jsr	(eraser).l
	jsr	(printz).l
	String	CC_Font1,0,0			;x3
	move.w	#3,(printx).l
	btst.b	#1,(setupcardflags).l
	bne.w	.1
	move.w	#$B,(printx).l
.1									;visitors card: block at column 3, home at $B
	move.w	#5,(printy).l
	move.w	#$19,d0					;clear the 25 x 8 card area
	move.w	#8,d1
	move.w	#$7FF,d2				;blank char
	jsr	(eraser).l
	btst.b	#1,(setupcardflags).l	;which side?
	bne.w	.2
	bsr.w	LogoBoxRight			;home logo box
	bra.w	.3
.2									;bit 1 of setupcardflags set
	bsr.w	LogoBoxLeft
	addi.w	#1,(featuredplayer).l	;each visitors card moves to the next featured player
.3									;both sides: wrap featuredplayer after the sixth picture
	jsr	(printz).l
	String	CC_Font1,0,0			;x3 / add.b
	cmpi.w	#6,(featuredplayer).l
	blt.w	.4
	clr.w	(featuredplayer).l		;back to the first picture
.4									;featuredplayer still 0-5: keep it
	move.w	(HomeTeam).l,d0
	move.w	#$1D,(printx).l
	btst.b	#1,(setupcardflags).l	;which side?
	beq.w	.5
	move.w	(VisTeam).l,d0
	move.w	#4,(printx).l
.5									;home card: home team and column $1D; visitors: VisTeam and column 4
	move.w	#6,(printy).l
	move.w	(homepicchars).l,d4
	move.w	(featuredplayer).l,d3
	mulu.w	#6,d3					;6 bytes per entry: picture.l + roster index.w
	asl.w	#2,d0					;team number * 4 to index the list of team lists
;CD: no cartridge twin
	movea.l	(FeaturedPicturesPtr).l,a0
	movea.l	(a0,d0.w),a0			;this team's list
	move.w	$4(a0,d3.w),(cardroster).l
	movea.l	(a0,d3.w),a0			;the picture
	movea.l	a0,a1					;a1 = picture header
	movea.l	a0,a2
	adda.l	(a2)+,a0				;a0 = the picture's tile data
	movea.l	#PicturePalette,a0
	adda.l	(a0),a0
	tst.l	(a2)					;no map: the PicturePalette one
	bne.w	.6
	movea.l	#PicturePalette,a1
	adda.l	jimdata(a1),a1
	tst.l	(a2)+					;skip the map offset
	bra.w	.7
.6									;picture has its own map: use it
	adda.l	(a2)+,a1
.7									;both: unpack the tiles, map and palette into picturebuf
	bsr.w	UnpackPicture
	movea.l	#picturebuf,a2
	move.w	(Vcount).l,d3			;current frame
.loop								;wait for the next vblank before drawing
	cmp.w	(Vcount).l,d3
	beq.w	.loop
	move.w	#6,d3
	move.w	#6,d2
	clr.w	d0
	clr.w	d1
	move.l	(palfadenew+$22).l,-(sp)	;keep palette colors $22-$29: dobitmap overwrites them
	move.l	(palfadenew+$26).l,-(sp)
	move.w	#2,d5
	jsr	(dobitmap).l
	move.l	(sp)+,(palfadenew+$26).l
	move.l	(sp)+,(palfadenew+$22).l
	jsr	(printz).l
	String	CC_Font1Pri,0,0			;(the routine here)
	move.w	#$6000,(printa).l
	move.w	#3,(printx).l
	move.w	#$19,d0
	btst.b	#1,(setupcardflags).l	;which side?
	beq.w	.8
	move.w	#$B,(printx).l
	move.w	#$19,d0
.8									;visitors frame at column $B, home at 3
	move.w	#5,(printy).l
	move.w	#8,d1
	move.w	(printx).l,(cardprintx).l	;text inside the frame starts one in and one down
	addi.w	#1,(cardprintx).l
	move.w	(printy).l,(cardprinty).l
	addi.w	#1,(cardprinty).l
	jsr	(Framer).l					;25 x 8 box
	move.w	(cardprintx).l,(printx).l	;text inside the frame
	move.w	(cardprinty).l,(printy).l
	move.w	#0,(printa).l
	move.w	#0,(printm).l			;print mode 0
	move.w	(HomeTeam).l,d0
	btst.b	#1,(setupcardflags).l	;which side?
	beq.w	.9
	move.w	(VisTeam).l,d0
.9									;home card: home team, else the visitors
	move.w	d0,(cardteamnum).l
	movea.l	#TeamList,a2
	asl.w	#2,d0
	movea.l	(a2,d0.w),a2
	adda.w	0(a2),a2				;a2 = first player record of the team
	move.w	(cardroster).l,d0		;skip cardroster players to reach the featured one
	bra.w	.10
.loop2								;skip one player record: name length + fixed part
	adda.w	(a2),a2
;CD: no cartridge twin
	adda.w	#$8,a2
.10									;loop until the featured player is reached
	dbf	d0,.loop2
	movea.l	#mesarea,a3
	lea	2(a3),a1					;text after the header
	move.w	#6,(a3)					;string header: 6 = print mode
	move.l	a2,-(sp)				;keep the player record
	adda.w	(a2),a2
	move.b	(a2),d0
	ext.w	d0
	jsr	(ConvertByteToDigits).l		;uniform number as digits
	move.w	#$2000,4(a3)
	movea.l	(sp)+,a1
	jsr	(appstring).l				;then a space and the name
	movea.l	a3,a1
	bset.b	#3,(sflags6).l			;bit 3 of sflags6: printsmall uses the card font
	jsr	(printsmall).l				;print the number and name
	bclr.b	#3,(sflags6).l			;normal font
	movea.l	#mesarea,a1
	move.w	(cardteamnum).l,d0
	move.w	(cardroster).l,d1
	tst.w	(ValidSRAM).l			;no SRAM: no records
	bmi.w	.fade
	jsr	(PrintRecordValue).l
	cmpi.w	#2,(a1)					;PrintRecordValue left an empty string: no records to show
	beq.w	.fade
	move.w	(cardprintx).l,(printx).l	;left edge of the text
	addi.w	#2,(printy).l			;two rows down
	bset.b	#3,(sflags6).l			;card font
	jsr	(printsmall).l				;print it
	bclr.b	#3,(sflags6).l			;normal font
	movea.l	#mesarea,a1
	move.w	(cardteamnum).l,d0
	move.w	(cardroster).l,d1
	movea.l	#$C45C,a0				;CD: the cartridge has #M68K_RAM
	jsr	(PrintRecordHolder).l
	move.w	(cardprintx).l,(printx).l
	cmpi.w	#2,(a1)					;no record holder: skip the line
	beq.w	.11
	addi.w	#1,(printy).l
	bset.b	#3,(sflags6).l			;card font
	jsr	(printsmall).l				;print it
	bclr.b	#3,(sflags6).l			;normal font
.11									;records holder printed, or none: the vs line next
	movea.l	#mesarea,a1
	move.w	(cardteamnum).l,d0
	move.w	(cardroster).l,d1
	movea.l	#$C45C,a0				;CD: the cartridge has #M68K_RAM
	jsr	(PrintRecordVs).l
	move.w	(cardprintx).l,(printx).l	;left edge of the text
	addi.w	#1,(printy).l
	bset.b	#3,(sflags6).l			;card font
	jsr	(printsmall).l				;print it
	bclr.b	#3,(sflags6).l			;normal font
.fade								;all lines printed (or no SRAM / no records): fade the card in
	move.w	#$64,(palcount).l		;fade the palette in over $64 frames
	movem.l	(sp)+,d0-d7/a0-a6
	rts

wallcollduringcheck					;during a check, a skater a2 (not a goalie) near the wall: test the wall
									;at his position with his size + $17. Called from CCStart
	tst.w	position(a2)			;goalies have no wall check during a hit
	beq.w	.end
	movem.l	d0-d7,-(sp)
	move.w	0(a2),d2				;Xpos of checking player
	move.w	Ypos(a2),d3				;Ypos of checking player
	move.w	radiusx(a2),(wcradiusx).l	;make the test box $17 bigger than the skater
	addi.w	#$17,(wcradiusx).l		;add $17 to wcradiusx
	move.w	radiusy(a2),(wcradiusy).l	;radiusy into wcradiusy (height of graphic)
	addi.w	#$17,(wcradiusy).l		;add $17 to wcradiusy
	movem.l	a0-a6,-(sp)
	exg	a2,a3						;checkcornercoll tests the object in a3
	jsr	(checkcornercoll).l
	exg	a2,a3						;swap a2 and a3
	movem.l	(sp)+,a0-a6
	movem.l	(sp)+,d0-d7
.end								;exit (also the end of the code above)
	rts
setSlotBit							;Sflags6 bit 5 (the slot) = the puck carrier is in the slot in front of
									;the goal. Called from DoGameFrame
	bclr.b	#5,(sflags6).l			;clears Slot Bit
	tst.w	(puckc).l
	bmi.w	.ex						;exit if no puckc
	movem.l	d0/a0,-(sp)
	movea.l	#SortCords,a0
	move.w	(puckc).l,d0			;move puckc SCnum into d0
	asl.w	#7,d0					;mult by 128 decimal
	adda.w	d0,a0					;move to start of puckc SCstruct
	move.w	Ypos(a0),d0
	btst.b	#pfgoal,pflags(a0)		;pfgoal - which goal shooting at
	bne.w	.checkpos				;jump if top goal
	neg.w	d0
.checkpos							;carrier shooting at the top goal, or Ypos flipped for the bottom one
	cmpi.w	#Blueline,d0			;only in the attacking zone (past the blue line)
	blt.w	.restore				;branch if not in off zone
	cmpi.w	#$47,0(a0)				;and within $47 of the middle across the ice
	bgt.w	.restore				;branch if greater than 47
	cmpi.w	#$FFB9,0(a0)			;compare X position to -$47
	blt.w	.restore				;branch if less than -47
	bset.b	#5,(sflags6).l
.restore							;pop the d0/a0 saved above
	movem.l	(sp)+,d0/a0
.ex									;exit (also the end of the code above)
	rts
TeamPalettes						;Matchup and player card palettes: 56 of 16 colors, two per team (28
									;teams, TeamList order). A is the matchup logo palette (the
									;TeamLogoPalettes
									;entry, except BOS, FLA, HFD, SJ), B the other side (A with colors 1-2 and
									;3-4 swapped). Used by TeamIcons and the player cards
	incbin	..\cdbin\HOCKEY.BIN,$A060,32	;ANH matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A080,32	;ANH other side (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A0A0,32	;BOS matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A0C0,32	;BOS other side (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A0E0,32	;BUF matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A100,32	;BUF other side (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A120,32	;CGY matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A140,32	;CGY other side (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A160,32	;CHI matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A180,32	;CHI other side (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A1A0,32	;DAL matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A1C0,32	;DAL other side (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A1E0,32	;DET matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A200,32	;DET other side (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A220,32	;EDM matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A240,32	;EDM other side (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A260,32	;FLA matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A280,32	;FLA other side (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A2A0,32	;HFD matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A2C0,32	;HFD other side (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A2E0,32	;LA matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A300,32	;LA other side (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A320,32	;MTL matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A340,32	;MTL other side (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A360,32	;NJ matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A380,32	;NJ other side (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A3A0,32	;NYI matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A3C0,32	;NYI other side (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A3E0,32	;NYR matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A400,32	;NYR other side (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A420,32	;OTW matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A440,32	;OTW other side (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A460,32	;PHI matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A480,32	;PHI other side (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A4A0,32	;PIT matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A4C0,32	;PIT other side (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A4E0,32	;QUE matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A500,32	;QUE other side (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A520,32	;SJ matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A540,32	;SJ other side (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A560,32	;STL matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A580,32	;STL other side (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A5A0,32	;TB matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A5C0,32	;TB other side (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A5E0,32	;TOR matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A600,32	;TOR other side (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A620,32	;VAN matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A640,32	;VAN other side (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A660,32	;WSH matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A680,32	;WSH other side (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A6A0,32	;WPG matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A6C0,32	;WPG other side (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A6E0,32	;ASE matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A700,32	;ASE other side (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A720,32	;ASW matchup logo palette (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A740,32	;ASW other side (from the disc file)
PrintRecordValue					;Record line for a player card (PlayerCardScreen): copy RecordTxt to a3,
									;then the record value of player d1 (GetRecordValue) and goals / goal or
									;saves / save. An empty String when there is no value
	movem.l	d0-d7/a1-a6,-(sp)
	move.l	a1,-(sp)				;keep the output start: it is reset if there is no record
	movea.l	a1,a3
	movea.l	#RecordTxt,a1
	movem.l	d0-d1,-(sp)				;save team and player
	bsr.w	CopyString				;output starts with "Record "
	movem.l	(sp)+,d0-d1
	bsr.w	GetRecordValue			;d0 = value, d1 = 1 for a goalie
	tst.w	d0						;any value?
	bne.w	.0						;record value 0: no record for this player
	movea.l	(sp)+,a1
	move.w	#2,(a1)					;length 2 = empty String, the card skips this line
	bra.w	.x
.0									;player has a record: append the number and the unit
	movea.l	#TempBuffer,a1
	move.w	d0,(TempWord2).l		;keep the value: AppendNumber's result is joined next
	bsr.w	AppendNumber			;value as a String
	movea.l	(sp),a3
	movea.l	#TempBuffer,a1
	jsr	(appstring).l
	move.w	(TempWord2).l,d0
	movea.l	#RecSavesTxt,a1			;goalie units: "saves", or "save" when it is 1
	cmpi.w	#1,d0					;just one?
	bne.w	.1
	movea.l	#RecSaveTxt,a1
.1									;more than one save, or a skater: check the skater unit
	tst.w	d1						;d1 = 0: a skater, so goals instead of saves
	bne.w	.2
	movea.l	#RecGoalsTxt,a1
	cmpi.w	#1,d0
	bne.w	.2
	movea.l	#RecGoalTxt,a1
.2									;unit chosen (goals/goal/saves/save): append it
	movea.l	(sp)+,a3
	jsr	(appstring).l				;append the unit
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a1-a6
	rts
RecordTxt	dc.b	0				;PrintRecordValue text
	dc.b	$A
	dc.b	$52						;R
	dc.b	$65						;e
	dc.b	$63						;c
	dc.b	$6F						;o
	dc.b	$72						;r
	dc.b	$64						;d
	dc.b	$20,0
RecGoalsTxt	dc.b	0				;PrintRecordValue text
	dc.b	8,$20
	dc.b	$67						;g
	dc.b	$6F						;o
	dc.b	$61						;a
	dc.b	$6C						;l
	dc.b	$73						;s
RecGoalTxt	dc.b	0				;PrintRecordValue text
	dc.b	8,$20
	dc.b	$67						;g
	dc.b	$6F						;o
	dc.b	$61						;a
	dc.b	$6C						;l
	dc.b	0
RecSavesTxt	dc.b	0				;PrintRecordValue text
	dc.b	8,$20
	dc.b	$73						;s
	dc.b	$61						;a
	dc.b	$76						;v
	dc.b	$65						;e
	dc.b	$73						;s
RecSaveTxt	dc.b	0				;PrintRecordValue text
	dc.b	8,$20
	dc.b	$73						;s
	dc.b	$61						;a
	dc.b	$76						;v
	dc.b	$65						;e
	dc.b	0
CopyString							;Copy String a1 (length word first) to a3
	movem.l	d0,-(sp)
	move.w	(a1),d0					;the length word counts the header too
	subi.w	#1,d0
.loop								;copy one byte
	move.b	(a1)+,(a3)+				;copy the whole String including its length word
	dbf	d0,.loop					;next byte
	movem.l	(sp)+,d0
	rts
AppendNumber						;Write d0 (0 ... 999, no leading zeros) as a String at a1, padded to an
									;even length
	movem.w	d0-d6/a0,-(sp)
	move.l	a1,-(sp)				;keep the String start
	move.w	d0,d6
;CD: no cartridge twin
	adda.l	#$2,a1
	clr.w	d1
	ext.l	d0
	divu.w	#$64,d0					;hundreds digit
	tst.w	d0						;any hundreds?
	beq.w	.0						;no hundreds: no leading zero
	addi.w	#$30,d0
	move.b	d0,(a1)+
	addi.w	#1,d1
.0									;no hundreds digit, or it was written: now the tens
	swap	d0
	ext.l	d0						;clear the high word
	divu.w	#$A,d0					;tens digit
	addi.w	#$30,d0
	cmpi.b	#$30,d0					;tens 0 is skipped only for values below 10
	bne.w	.1
	cmpi.w	#$A,d6					;below 10?
	blt.w	.2						;yes: no tens digit
.1									;tens digit wanted (non-zero, or a hundreds digit came before)
	move.b	d0,(a1)+
	addi.w	#1,d1
.2									;value below 10, or the tens is written: now the ones
	swap	d0						;ones digit from the remainder
	addi.w	#$30,d0
	move.b	d0,(a1)+
	addi.w	#1,d1
	btst	#0,d1					;odd length: pad with a 0 byte so the String stays word aligned
	beq.w	.3						;even already
	move.b	#0,(a1)+				;pad byte
	addi.w	#1,d1
.3									;length now even: write the length word
	movea.l	(sp)+,a0
	addi.w	#2,d1					;length counts the 2-byte header
	move.w	d1,(a0)
	movem.w	(sp)+,d0-d6/a0
	rts
GetRecordValue						;d0 = record d0 of player d1 of team d0 from save RAM (ReadPlayerRecord
									;into M68K_RAM); d1 = 1 when the player is a goalie
	movem.l	d2-d7/a0-a6,-(sp)
	move.w	d0,-(sp)
	movea.l	#TeamList,a2
	asl.w	#2,d0
	movea.l	(a2,d0.w),a2
	adda.w	0(a2),a2				;a2 = the team's first player record
	move.w	d1,d0					;skip d1 records to reach the player
	bra.w	.0
.loop								;skip one player record: name length + fixed part
	adda.w	(a2),a2
;CD: no cartridge twin
	adda.w	#$8,a2
.0									;loop until the player is reached
	dbf	d0,.loop
	move.w	d1,d0
	move.w	(sp)+,d1
	move.w	d0,d5
	move.w	d1,d4
	ext.l	d0
	movea.l	#$C45C,a0				;CD: the cartridge has #M68K_RAM
	bsr.w	ReadPlayerRecord		;his save record into M68K_RAM
	move.b	(a0),d0					;byte 0 = the record value
	ext.w	d0
	movea.l	#TeamList,a5
	asl.w	#2,d4
	movea.l	(a5,d4.w),a5
	adda.w	GoalieOdds(a5),a5		;the goalie nibbles in GoalieOdds give the goalie count
	move.w	(a5),d1
	movem.w	d0,-(sp)
	clr.w	d0
.loop2								;count the nibbles of the goalie word
	addi.w	#1,d0
	asl.w	#4,d1					;next nibble
	bne.w	.loop2
	cmp.w	d5,d0					;roster index past the goalies: a skater
	movem.w	(sp)+,d0
	bgt.w	.1						;index below the goalie count: a goalie
	clr.w	d1						;d1 = 0: a skater
	bra.w	.x
.1									;player is one of the goalies
	move.w	#1,d1					;d1 = 1: a goalie
.x									;exit: restore the registers
	movem.l	(sp)+,d2-d7/a0-a6
	rts
PrintRecordHolder					;Record holder line: RecByTxt ("by") then the holder's user name
									;(AppendRecordHolder). An empty String when there is none
	movem.l	d0-d7/a1-a6,-(sp)
	move.l	a1,-(sp)				;keep the output start
	movea.l	a1,a3
	movea.l	#RecByTxt,a1
	movem.l	d0-d1,-(sp)				;save team and player
	bsr.w	CopyString
	movem.l	(sp)+,d0-d1
	movea.l	#TempBuffer,a1			;holder name buffer
	bsr.w	AppendRecordHolder
	movea.l	(sp)+,a3
	cmpi.w	#2,(a1)					;no holder name: give back an empty String
	bne.w	.0
	move.w	#2,(a3)					;length 2 = empty String
	bra.w	.x
.0									;holder name found: append it after "by "
	jsr	(appstring).l				;append the name
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a1-a6
	rts
RecByTxt	dc.b	0				;PrintRecordHolder text
	dc.b	6
	dc.b	$62						;b
	dc.b	$79						;y
	dc.b	$20,0
PrintRecordVs						;Record line: RecVsTxt ("vs.") then the user name and the opponent team
									;(AppendRecordVs)
	movem.l	d0-d7/a1-a6,-(sp)
	move.l	a1,-(sp)				;keep the output start
	movea.l	a1,a3
	movea.l	#RecVsTxt,a1
	movem.l	d0-d1,-(sp)				;save team and player
	bsr.w	CopyString
	movem.l	(sp)+,d0-d1
	movea.l	#TempBuffer,a1
	bsr.w	AppendRecordVs			;user name and opponent
	movea.l	(sp)+,a3
	jsr	(appstring).l
	movem.l	(sp)+,d0-d7/a1-a6
	rts
RecVsTxt	dc.b	0				;PrintRecordVs text
	dc.b	6
	dc.b	$76						;v
	dc.b	$73						;s
	dc.b	$2E
	dc.b	$20
AppendRecordHolder					;Append the user name of the record holder (byte 1 of record a0, or read
									;record d0 / d1 when a0 is 0) to a1 (AppendUserName)
	movem.l	d0-d7/a1-a2,-(sp)
	cmpa.l	#0,a0
	bne.w	.0						;a record was passed in a0: use it
	movem.l	d0-d7/a1-a6,-(sp)
	move.w	d0,-(sp)				;swap d0 and d1
	move.w	d1,d0					;swap d0/d1 into ReadPlayerRecord's order: d0 player, d1 team
	move.w	(sp)+,d1
	ext.l	d1
	ext.l	d0
	movea.l	#$C45C,a0				;CD: the cartridge has #M68K_RAM
	bsr.w	ReadPlayerRecord
	movea.l	#$C45C,a0				;a0 = the record (CD: the cartridge has #M68K_RAM)
	movem.l	(sp)+,d0-d7/a1-a6
.0									;record ready (passed in, or read into M68K_RAM): byte 1 = holder
	move.b	1(a0),d2
	ext.w	d2
	bset.b	#7,(sflags6).l			;bit 7 of sflags6: AppendUserName uses the record name list
	bsr.w	AppendUserName
	movem.l	(sp)+,d0-d7/a1-a2
	rts
AppendRecordVs						;Append the user name (byte 3 of record a0), a space and the opponent team
									;name (byte 2, AppendTeamName) to a1
	movem.l	d0-d7/a0-a6,-(sp)
	cmpa.l	#0,a0
	bne.w	.0						;a record was passed in a0: use it
	movem.l	d0-d7/a1-a6,-(sp)
	move.w	d0,-(sp)				;swap d0 and d1
	move.w	d1,d0					;swap d0/d1 into ReadPlayerRecord's order: d0 player, d1 team
	move.w	(sp)+,d1
	ext.l	d1
	ext.l	d0
	movea.l	#$C45C,a0				;CD: the cartridge has #M68K_RAM
	bsr.w	ReadPlayerRecord
	movea.l	#$C45C,a0				;a0 = the record (CD: the cartridge has #M68K_RAM)
	movem.l	(sp)+,d0-d7/a1-a6
.0									;record ready (passed in, or read into M68K_RAM): byte 3 = the user
	move.b	3(a0),d2
	ext.w	d2
	movem.l	d0/a1,-(sp)
	bset.b	#7,(sflags6).l			;record name list
	bsr.w	AppendUserName
	movea.l	a1,a3
	movea.l	#RecSpaceTxt,a1
	jsr	(appstring).l
	movem.l	(sp)+,d0/a1
	move.b	2(a0),d0				;byte 2 = the opponent team
	jsr	(AppendTeamName).l			;append the team name
	movem.l	(sp)+,d0-d7/a0-a6
	rts
RecSpaceTxt	dc.b	0				;AppendRecordVs text
	dc.b	4,$20,0
UpdateRecords						;With save RAM (ValidSRAM) and user records on (OptUserRec 0), update the
									;team and player records after a game (UpdateTeamRecord UpdateCrowdRecord,
									;UpdatePlayerRecords), then the save RAM checksum (MakeSRAMChecksum).
									;Called from Intermission
	tst.w	(ValidSRAM).l
	bmi.w	.x						;no save RAM: nothing to update
	tst.w	(OptUserRec).l
	bne.w	.x						;user records turned off in the options
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	CountGoalies			;goalies of each team
	bsr.w	CountPlayers			;players of each team
	move.w	(HomeTeam).l,d1
	ext.l	d1
	movea.l	#recordbuf,a0
	movea.l	#tmstruct,a2
	move.w	(homegoalies).l,d5		;goalie count: the first players of the roster are goalies
	move.w	(VisTeam).l,d6			;opponent team for the records
	bsr.w	UpdatePlayerRecords
	move.w	(VisTeam).l,d1
	ext.l	d1
	movea.l	#awtmstruct,a2
	move.w	(awaygoalies).l,d5
	move.w	(HomeTeam).l,d6
	bsr.w	UpdatePlayerRecords
	clr.w	d7						;d7 = "a record was changed" flag
	movea.l	#tmstruct,a1
	move.w	(homeuser).l,d4
	move.w	(awayuser).l,d5
	move.w	(HomeTeam).l,d1
	move.w	(VisTeam).l,d2
	move.w	(homegoalies).l,d6
	ext.l	d1
	movea.l	#recordbuf,a0
	bsr.w	UpdateCrowdRecord
	movea.l	#awtmstruct,a1
	move.w	(awayuser).l,d4
	move.w	(homeuser).l,d5
	move.w	(VisTeam).l,d1
	move.w	(HomeTeam).l,d2
	move.w	(awaygoalies).l,d6
	ext.l	d1
	movea.l	#recordbuf,a0
	bsr.w	UpdateCrowdRecord
	movea.l	#recordbuf,a0
	move.w	(homeuser).l,d1
	ext.l	d1
	move.w	(awayuser).l,d2
	move.w	(HomeTeam).l,d3
	move.w	(VisTeam).l,d4
	movea.l	#tmstruct,a1
	movea.l	#awtmstruct,a2			;opponent team struct
	bsr.w	UpdateTeamRecord
	movea.l	#recordbuf,a0
	move.w	(awayuser).l,d1
	ext.l	d1
	move.w	(homeuser).l,d2
	move.w	(VisTeam).l,d3
	move.w	(HomeTeam).l,d4
	movea.l	#awtmstruct,a1
	movea.l	#tmstruct,a2
	bsr.w	UpdateTeamRecord
	movem.l	(sp)+,d0-d7/a0-a6
.x									;exit (also the end of the code above)
	rts
UpdateTeamRecord					;After a game: add the game to team record block d1 (games, wins, ties),
									;and keep the biggest win and loss margins with the user names
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	ReadTeamRecord			;team record block to a0
	st.b	d7						;d7 set: the team record is always written back
	movem.w	d0,-(sp)
	clr.w	d0						;games, big endian
	move.b	urgames(a0),d0
	lsl.w	#8,d0
	move.b	urgames+1(a0),d0
	cmpi.w	#$2328,d0				;stop counting games at 9000
	bge.w	.1
	addi.w	#1,d0					;count the game
	move.b	d0,urgames+1(a0)
	lsr.w	#8,d0
	move.b	d0,urgames(a0)
	move.w	tmscore(a1),d0
	cmp.w	tmscore(a2),d0			;against the opponent's
	bgt.w	.0						;home team won: count a win
	blt.w	.1						;lost: only the game is counted
	clr.w	d0						;tie: count a tie
	move.b	urties(a0),d0			;ties, big endian
	lsl.w	#8,d0
	move.b	urties+1(a0),d0
	addi.w	#1,d0
	move.b	d0,urties+1(a0)
	lsr.w	#8,d0
	move.b	d0,urties(a0)
	bra.w	.1
.0									;won: count a win
	clr.w	d0
	move.b	urwins(a0),d0			;wins, big endian
	lsl.w	#8,d0
	move.b	urwins+1(a0),d0
	addi.w	#1,d0
	move.b	d0,urwins+1(a0)
	lsr.w	#8,d0
	move.b	d0,urwins(a0)
.1									;game counted: now the margin records
	movem.w	(sp)+,d0
	movem.w	d0,-(sp)
	move.w	tmscore(a1),d0
	cmp.w	tmscore(a2),d0			;against the opponent's
	movem.w	(sp)+,d0
	ble.w	.write					;not a win: no margin record
	move.w	tmscore(a1),d5
	cmp.b	0(a0),d5				;biggest goals scored in a win
	ble.w	.2
	st.b	d7
	move.b	d5,0(a0)				;new goals record
	move.b	d3,urgoalsteam(a0)
	move.b	d4,urgoalsopp(a0)
	move.b	d2,urgoalsoppuser(a0)
.2									;goals record kept or set: check the saves record
	move.w	tmscore(a2),d5			;opponent goals
	move.w	0(a2),d6				;shots - goals = saves of the other goalie
	sub.w	d5,d6
	cmp.b	ursaves(a0),d6			;above the record?
	ble.w	.write
	st.b	d7
	move.b	d6,ursaves(a0)
	move.b	d3,ursavesteam(a0)
	move.b	d4,ursavesopp(a0)
	move.b	d2,ursavesoppuser(a0)
.write								;write the block back to save RAM
	bsr.w	WriteTeamRecord
	movem.l	(sp)+,d0-d7/a0-a6
	rts
UpdateCrowdRecord					;Update the crowd records (ReadCrowdRecord, WriteCrowdRecord)
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	ReadCrowdRecord			;crowd record block to a0
	move.w	$C(a1),d3				;team goals of this game
	cmp.b	0(a0),d3				;more goals than the record: new crowd goals record
	ble.w	.0
	move.b	d3,0(a0)
	move.b	d4,crgoalsuser(a0)
	move.b	d5,crgoalsoppuser(a0)
	move.b	d2,crgoalsopp(a0)
	st.b	d7
.0									;goals record done: find the best goalie save total
	subi.w	#1,d6					;d6 = goalie count - 1
	clr.w	d3						;best so far
.loop								;saves of goalie d6 = shots against - goals against
	move.w	d6,d0
	addi.w	#tmpshots,d0			;his shots against
	move.b	(a1,d0.w),(TempWord1).l
	addi.w	#tmgoals-tmpshots,d0	;his goals against
	move.b	(a1,d0.w),d0
	sub.b	d0,(TempWord1).l
	cmp.b	(TempWord1).l,d3		;best so far?
	bge.w	.1
	move.b	(TempWord1).l,d3
.1									;next goalie
	dbf	d6,.loop
	cmp.b	crsaves(a0),d3			;best saves above the record: new saves record
	ble.w	.2
	st.b	d7
	move.b	d3,crsaves(a0)
	move.b	d4,crsavesuser(a0)
	move.b	d5,crsavesoppuser(a0)
	move.b	d2,crsavesopp(a0)
.2									;saves record done: crowd peak only for the home team
	cmp.w	(HomeTeam).l,d1			;home team?
	bne.w	.3
	move.b	crpeak(a0),d3
	andi.w	#$FF,d3
	cmp.w	(CrowdPeak).l,d3
	bge.w	.3						;the record is as loud or louder: keep it
	move.w	(CrowdPeak).l,d3
	st.b	d7
	move.b	d3,crpeak(a0)
	move.b	d4,crpeakuser(a0)
	move.b	d5,crpeakoppuser(a0)
	move.b	d2,crpeakopp(a0)
.3									;records checked: write back only when one changed (d7)
	tst.w	d7
	beq.w	.x						;nothing changed
	bsr.w	WriteCrowdRecord		;write the block back
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a6
	rts
UpdatePlayerRecords					;After a game: for the 26 players of team a2, keep each new best (goals,
									;or saves for the goalies) in his player record with the user names and
									;opponent d6
	clr.l	d0
	move.w	#$19,d2					;26 roster slots
.loop								;each player: read his record
	bsr.w	ReadPlayerRecord		;his record to a0
	cmp.w	d5,d0					;goalie?
	blt.w	.0						;d0 >= goalie count: a skater, use his goals
	move.w	d0,-(sp)
	addi.w	#tmgoals,d0				;goals of this game
	move.b	(a2,d0.w),d4			;d4 = goals
	move.w	(sp)+,d0
	bra.w	.1
.0									;a goalie: saves = shots against - goals against
	move.w	d0,-(sp)
	addi.w	#tmpshots,d0			;his shots against
	move.b	(a2,d0.w),d4			;d4 = shots against
	addi.w	#tmgoals-tmpshots,d0	;his goals against
	sub.b	(a2,d0.w),d4			;d4 = saves
	move.w	(sp)+,d0
.1									;this game's value in d4
	move.b	0(a0),d3				;his record
	cmp.b	d3,d4
	ble.w	.3						;not above his record: next player
	move.b	d4,0(a0)
	move.b	(homeuser+1).l,pruser(a0)	;home team: the home user holds it
	move.b	(awayuser+1).l,proppuser(a0)
	cmpa.l	#tmstruct,a2			;home team?
	beq.w	.2						;home team: names already right
	move.b	(awayuser+1).l,pruser(a0)
	move.b	(homeuser+1).l,proppuser(a0)
.2									;user names set for this team
	move.b	d6,propp(a0)
	bsr.w	WritePlayerRecord
.3									;next player
	addi.w	#1,d0
	dbf	d2,.loop					;loop
	rts
CountGoalies						;homegoalies / awaygoalies = goalies of the home / away team
									;(GetGoalieCount). Called and PlayerCards
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a2
	jsr	(GetGoalieCount).l
	move.w	d0,(homegoalies).l
	movea.l	#awtmstruct,a2
	jsr	(GetGoalieCount).l
	move.w	d0,(awaygoalies).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
CountPlayers						;homeplayers / awayplayers = players of the home / away team
									;(GetPlayerCount)
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a2
	jsr	(GetPlayerCount).l
	move.w	d0,(homeplayers).l
	movea.l	#awtmstruct,a2
	jsr	(GetPlayerCount).l
	move.w	d0,(awayplayers).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
AppendUserName						;Append user name d2 (12 bytes of the name log at namelog, spaces for 0)
									;to a1, or NoNameTxt when d2 is 0; trailing spaces trimmed (TrimSpaces)
	movem.l	d0-d3/a0-a3,-(sp)
	movea.l	a1,a2					;keep the String start
	tst.w	d2						;no user?
	beq.w	.2
	move.w	#$B,d0
	clr.w	d3
	movea.l	#namelog,a0
	mulu.w	#$C,d2					;12 bytes per name
	adda.l	d2,a0					;this user's name
.loop								;copy one name byte
	move.b	(a0,d3.w),d1			;0 bytes print as spaces
	bne.w	.0
	move.b	#$20,d1
.0									;name byte ready (a 0 became a space)
	move.b	d1,2(a1)				;after the length word
	tst.b	(a1)+
	addi.w	#1,d3					;next name byte
	dbf	d0,.loop					;loop
	move.w	#$E,(a2)				;length = 12 + header
	btst.b	#7,(sflags6).l
	beq.w	.1						;trim only when asked (bit 7)
	bsr.w	TrimSpaces				;trim the trailing spaces
.1									;name copied
	bra.w	.x
.2									;no user: "No Name" instead
	movea.l	a1,a3
	move.l	a3,-(sp)
	movea.l	#NoNameTxt,a1
	jsr	(CopyString).l
	movea.l	(sp)+,a2
	bsr.w	TrimSpaces				;trim the trailing spaces
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d3/a0-a3
	rts
NoNameTxt	dc.b	0				;AppendUserName data
	dc.b	2
;CD: no cartridge twin
RunPlayerOverlay					;CD-only routine (a name given here, not a cartridge name)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$9,d7
	jsr	$6044.w
	movea.l	#$AFF60,a0
.L25E68
	btst.b	#$7,$FF800E.l
	bne.s	.L25E68
	move.l	#$0,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L25E8C
	btst.b	#$6,$FF800E.l
	beq.s	.L25E8C
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L25EA6
	btst.b	#$6,$FF800E.l
	bne.s	.L25EA6
	bclr.b	#$7,$FF800F.l
	move.l	#$3FFF,d0
.L25EBE
	btst.b	#$7,$FF800E.l
	bne.s	.L25EBE
	move.w	#$16,$FF8020.l
	bset.b	#$6,$FF800F.l
.L25ED8
	btst.b	#$6,$FF800E.l
	beq.s	.L25ED8
	move.l	$FF8010.l,(a0)+
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L25EF8
	btst.b	#$6,$FF800E.l
	bne.s	.L25EF8
	bclr.b	#$7,$FF800F.l
	dbf	d0,.L25EBE
	move.l	#$27,d0
.L25F14
	btst.b	#$7,$FF800E.l
	bne.s	.L25F14
	move.l	#$10,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L25F38
	btst.b	#$6,$FF800E.l
	beq.s	.L25F38
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L25F52
	btst.b	#$6,$FF800E.l
	bne.s	.L25F52
	bclr.b	#$7,$FF800F.l
.L25F64
	btst.b	#$7,$FF800E.l
	bne.s	.L25F64
	move.w	#$15,$FF8020.l
	bset.b	#$6,$FF800F.l
.L25F7E
	btst.b	#$6,$FF800E.l
	beq.s	.L25F7E
	move.w	$FF8010.l,(a0)+
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L25F9E
	btst.b	#$6,$FF800E.l
	bne.s	.L25F9E
	bclr.b	#$7,$FF800F.l
	dbf	d0,.L25F64
	jsr	(forceblack).l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst.b	#$5,$FF800F.l
	beq.s	.L25FD2
	move.w	#$1,-(a6)
	bra.s	.L25FD6
.L25FD2
	move.w	#$0,-(a6)
.L25FD6
	bclr.b	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	move.w	(Opt1team).l,d0
	move.w	(Opt2team).l,d1
	move.w	(FourWayPlay).l,d2
	move.w	#$5,d7
	jsr	$6044.w
	jsr	(LoadGameGfx).l
	jsr	$21FC8.l
	move.w	#$2,d0
	jsr	$5F22.w
.L26014
	move.w	#$80,d0
	jsr	$5F22.w
	bcs.w	.L26014
.L26020
	move.w	#$81,d0
	jsr	$5F22.w
	move.w	(a0),d2
	andi.w	#$FF00,d2
	cmpi.w	#$0,d2
	bne.s	.L26020
	move.w	#$5,$19364.l
	move.w	#$13,d0
	lea	$19364.l,a0
	jsr	$5F22.w
	jsr	(forceblack).l
	move.w	#$8000,d0
	move.w	#$0,d1
	movea.l	#$AFF60,a0
	jsr	(DoDMApro).l
	jsr	$3816C.l
.L2606A
	btst.b	#$7,$FF800E.l
	bne.s	.L2606A
	move.w	#$27,$FF8020.l
	bset.b	#$6,$FF800F.l
.L26084
	btst.b	#$6,$FF800E.l
	beq.s	.L26084
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2609E
	btst.b	#$6,$FF800E.l
	bne.s	.L2609E
	bclr.b	#$7,$FF800F.l
	movem.l	(sp)+,d0-d7/a0-a6
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.s	.L260CA
	bset.b	#$5,$FF800F.l
	bra.s	.L260D2
.L260CA
	bclr.b	#$5,$FF800F.l
.L260D2
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	jmp	(ExitStatsScreen).l
AppendTeamName						;Append the city name of team d0 (TeamList block Strings) to a1
									;(appstring)
	movem.l	d0/a0-a3,-(sp)
	ext.w	d0
	asl.w	#2,d0
	movea.l	#TeamList,a0
	movea.l	(a0,d0.w),a0
	move.w	Teamname(a0),d0			;offset of the team's Strings block
	ext.l	d0
	adda.l	d0,a0					;a0 = Strings block
	adda.w	(a0),a0					;first String: the city
	movea.l	a1,a3
	movea.l	a0,a1					;city name
	jsr	(appstring).l
	movem.l	(sp)+,d0/a0-a3
	rts
CalcAttrib							;The overall rating of player d0: his attributes weighted by
									;OvrPlayerWgtList (skaters) or
									;OvrGoalWgtList (goalies), and by AttribWgtList. Called from
									;getNameandAttrib and PrintOverallRating
	move.l	a6,-(sp)				;push a6 to stack
	clr.w	(OvrDivisor).l
	clr.w	(OvrDividend).l
	movea.l	#AttribWgtList,a6
	cmp.l	(PAttribOverallMask).l,d4	;compare long word (1FBA000A) to d4
	bne.w	.1						;branch if not equal
	movea.l	#OvrPlayerWgtList,a6
.1									;not the skater mask: maybe the goalie mask
	cmp.l	(GAttribOverallMask).l,d4	;compare long word 130F000A to d4
	bne.w	.11						;branch if not equal
	movea.l	#OvrGoalWgtList,a6
.11									;weight list chosen (AttribWgtList unless an overall mask)
	movea.l	tmdata(a2),a0			;move ROM address of Team Data into a0
	lea	tmHotCold(a2),a4			;move start of Hot/Cold table to a4
	clr.l	d1
	move.w	d0,d1					;move d0 into d1. d0 is the offset of the player
	asl.w	#4,d1					;mult d1 by 16
	adda.l	d1,a4					;add d1 to a4
	adda.l	#$10,a4					;add 16 dec to a4. Move to start of Hot/Cold for player.
	adda.w	0(a0),a0				;add player table offset to Team Data start
.skip								;skip one player record: name length + fixed part
	adda.w	(a0),a0					;add Player Name length to a0
;CD: no cartridge twin
	adda.w	#$8,a0
	dbf	d0,.skip					;skip until at player
	clr.w	d0
	clr.w	d1
	moveq	#$F,d2					;move 15 dec into d2 (start at bit 15)
	swap	d4						;swap words in d4
.bit								;each set bit of the mask is an attribute in the rating
	btst	d2,d4					;bit test d2 bit in d4
	beq.w	.next					;branch if bit is 0
	move.w	d2,d3					;move d2 into d3
	lsr.w	#1,d3					;divide d3 by 2
	neg.w	d3
	move.b	-$1(a0,d3.w),d3			;move a0+d3-1 into d3. a0 currently at end of player data.
									;Sets d3 byte to attribute
	btst	#0,d2					;test bit 0 of d2
	beq.w	.0
	lsr.w	#4,d3					;divide d3 by 16. Shifts upper nibble to lower in case d2 was odd
.0									;attribute nibble in the low 4 bits
	andi.w	#$F,d3					;pass bottom nibble of d3
	cmpi.w	#$D,d2					;compare d2 to 13 dec (check if Wgt nibble)
	bne.w	.cont					;branch if not equal
	bra.w	.00
.cont								;d2 <> $D
	cmpi.w	#6,d2					;compare d2 to 6 (Fight nibble)
	beq.w	.00
	movem.l	d5-d7,-(sp)
	move.b	(a6,d2.w),d5			;move a6+d2 into d5
	ext.w	d5
	cmpi.w	#2,d5					;comare d5 to 2
	beq.w	.000
	move.w	d3,-(sp)				;push d3 to stack (current attribute)
	subi.w	#2,d5					;sub 2 from d5
.attribadd							;add the attribute d5 - 1 more times, then halve: weight d5 / 2
	add.w	(sp),d3					;add stack value to d3
	dbf	d5,.attribadd				;loop until d5 is 0
	asr.w	#1,d3					;divide d3 by 2
	tst.w	(sp)+					;test stack and increment
.000								;pop the d5-d7 saved above
	movem.l	(sp)+,d5-d7				;pop off stack into d5-d7
	cmpa.l	#AttribWgtList,a6		;check if a6 is AttribWgtList
	beq.w	.2
	neg.w	d2
	move.w	d7,-(sp)				;push d7 to stack
	move.b	-$1(a4,d2.w),d7			;move data at a4+d2-1 into d7
	ext.w	d7
	add.w	d7,(OvrDivisor).l		;add d7 to OvrDivisor
	addi.w	#1,(OvrDividend).l		;add 1 to OvrDividend
	move.w	(sp)+,d7				;pop from stack into d7
	neg.w	d2
	bra.w	.00
.2									;a6 = #AttribWgtList
	move.w	d3,-(sp)				;push d3 onto stack
	asl.w	#4,d3					;mult d3 by 16
	add.w	(sp),d3					;add value on stack to d3
	add.w	(sp)+,d3				;add value again from stack into d3 and increment
	neg.w	d2
	add.b	-$1(a4,d2.w),d3			;add data at a4+s2-1 into d3
	bpl.w	.pos
	clr.b	d3
.pos								;adjusted value clamped at 0
	neg.w	d2
.00									;weighted value ready (or Wgt / Fight, unweighted)
	add.w	d3,d0					;add d3 to d0 (d0 = attribute value)
	addi.w	#$64,d1					;add 100 dec to d1
.next								;next mask bit
	dbf	d2,.bit
	cmpa.l	#AttribWgtList,a6		;compare AttribWgtList with a6
	beq.w	.3
	move.w	#$64,d1					;move 100 dec into d1
	movem.l	d6-d7,-(sp)				;push d6 and d7 to stack
	move.w	(OvrDivisor).l,d6
	ext.l	d6
	move.w	(OvrDividend).l,d7
	divs.w	d7,d6					;divide d7 into d6
	add.w	d6,d0					;add d6 to d0
	movem.l	(sp)+,d6-d7
.3									;rating summed: keep it below the maximum d1
	cmp.w	d1,d0
	blt.w	.4
	move.w	d0,d1
	subi.w	#1,d0
.4									;rating in range
	movea.l	(sp)+,a6
	rts
OvrPlayerWgtList	dc.b	2		;CalcAttrib skater weights
	dc.b	2,2,2,4,6,2,4,2,4,6,6,4,2,2,2
OvrGoalWgtList	dc.b	2			;CalcAttrib goalie weights
	dc.b	2,2,2,2,2,2,2,9,9,2,2,9,2,2,2
AttribWgtList	dc.b	2			;CalcAttrib attribute weights
	dc.b	2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
DrawPlayerPicture					;Draw the player picture (NoPicSkater1 ... NoPicGoalie2, Card<player>)
	movem.l	d0-d7/a1-a6,-(sp)
;CD: no cartridge twin
	movea.l	(FeaturedPicturesPtr).l,a0
	move.w	d1,d2
	asl.w	#2,d2
	movea.l	(a0,d2.w),a0			;this team's list
	move.w	#$FFFF,d2				;d2 = entry counter
	bra.w	.1
.loop								;this team's featured list: look for player d0
	cmp.w	4(a0),d0
	bne.w	.0						;not him: next entry
	movea.l	(a0),a0					;his picture
	bra.w	.x
;CD: no cartridge twin
.0									;CD: placed where the disc branches to it
	adda.l	#$6,a0
.1									;stop at the 0 that ends the list
	addi.w	#1,d2
	tst.l	(a0)
	bne.w	.loop
	movea.l	#TeamList,a0			;no own picture: pick a generic one
	asl.w	#2,d1
	movea.l	(a0,d1.w),a0
	movea.l	a0,a6					;a6 = team data
	move.w	d0,d6
	adda.w	0(a6),a6
	bra.w	.2
.loop2								;skip one player record: name length + fixed part
	adda.w	(a6),a6
;CD: no cartridge twin
	adda.w	#$8,a6
.2									;loop until the player is reached
	dbf	d6,.loop2
	adda.w	(a6),a6					;past his name
	adda.w	GoalieOdds(a0),a0
	move.w	(a0),d1
	clr.w	d3
.loop3								;count the goalie nibbles
	addi.w	#1,d3
	asl.w	#4,d1					;next nibble
	bne.w	.loop3
	movea.l	#NoPicGoalie1,a0
	btst.b	#0,4(a6)				;bit 0 of the player byte picks one of the two generic pictures
	bne.w	.3
	movea.l	#NoPicGoalie2,a0
.3									;generic goalie picked: goalies stop here
	cmp.w	d3,d0					;a skater: the generic skater picture instead
	blt.w	.x
	movea.l	#NoPicSkater2,a0
	btst.b	#0,4(a6)				;same bit picks the skater picture
	bne.w	.x						;NoPicSkater2
	movea.l	#NoPicSkater1,a0
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a1-a6
	rts
TrimSpaces							;Trim the trailing spaces of String a2 and pad it to an even length
	movem.l	a3,-(sp)
	movea.l	a2,a3
	adda.w	(a2),a3					;a3 = end of the String
.loop								;loop
	move.b	-(a3),d0
	cmpi.b	#$20,d0					;space?
	bne.w	.0						;last character not a space: done
	move.b	#0,(a3)
	subi.w	#1,(a2)					;one shorter
	bra.w	.loop
.0									;add the header and round up to even
	addi.w	#1,(a2)
	andi.w	#$FE,(a2)
	movem.l	(sp)+,a3
	rts
