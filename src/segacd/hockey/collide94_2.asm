;	HOCKEY.BIN $22426-$22AB7 (runtime $3D426-$3DAB7): collide94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	Part 2 of collide94, from setpersonel (see penalty94.asm).

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

Set4WayPlayerStub	equ	$22DDE
AttributeCalc	equ	$230D0
GetPeriodTime	equ	$2BA04
GetPlayerCount	equ	$2EDBC
assinsert	equ	$362D8
assreplace	equ	$362E4
rtss2	equ	$3C000
sublist	equ	$41A6C
priolist	equ	$41AD6
chkpk2	equ	$338C8

	org	$3D426

setpersonel							;set personnel on team a2 from its registers (SetPlList), keeping players
									;already on the ice
	movem.l	d0-d5/a0-a4,-(sp)
;CD: no cartridge twin
	movea.l	$22(a2),a3
	moveq	#5,d4					;# of players on team for loop
.10									;clear each sort object
	st.b	newpos(a3)
	st.b	newpnum(a3)				;loop over PlList slots 5..0: find the wanted player already on the ice
	adda.w	#SCstruct,a3			;add size of player struct to a3
	dbf	d4,.10						;loop through each player on team
	bsr.w	SetPlList
	moveq	#5,d4
	movea.l	#(PlList-M68K_RAM),a4	;list of players we want on ice
.1									;each PlList slot
	clr.w	d5
	move.b	(a4,d4.w),d5			;search the sort objects for player d5
	beq.w	.next
	subi.w	#1,d5
	moveq	#5,d3
;CD: no cartridge twin
	movea.l	$22(a2),a3
	suba.w	#SCstruct,a3			;sub player struct size from a3
.2									;each sort object
	adda.w	#SCstruct,a3			;add player struct size to a3
	cmp.b	pnum(a3),d5				;next PlList slot
	dbeq	d3,.2					;loop through player structs while pnum != d5 (find player d5)
	bne.w	.next					;branches if player not found
	move.b	plpos(a4,d4.w),newpos(a3)	;move a4+d4+6 into newpos
	move.b	d5,newpnum(a3)			;second pass: put the players not on the ice into free sort objects
	clr.b	(a4,d4.w)
.next								;next PlList slot
	dbf	d4,.1						;next PlList slot
	moveq	#5,d4
	movea.l	#(PlList-M68K_RAM),a4
.3									;each PlList slot, second pass
	clr.w	d5
	move.b	(a4,d4.w),d5			;find a sort object with no requested player
	beq.w	.next2
	subi.w	#1,d5
	moveq	#5,d3
;CD: no cartridge twin
	movea.l	$22(a2),a3
	suba.w	#SCstruct,a3
.4									;first one without a position wins; the player goes there
	adda.w	#SCstruct,a3			;next sort obj
	tst.b	newpnum(a3)
	dbmi	d3,.4					;find a sort obj with no requested player
	bpl.w	.0
;CD: no cartridge twin
	movea.l	a3,a0
.0									;free slot found
	tst.w	position(a3)			;does this obj have a position yet?
	dbpl	d3,.4					;keep looking while that obj has no position
	move.b	plpos(a4,d4.w),newpos(a0)
	move.b	d5,newpnum(a0)
	clr.b	(a4,d4.w)
.next2								;next PlList slot
	dbf	d4,.3						;next PlList slot
	movem.l	(sp)+,d0-d5/a0-a4
	rts
SetPlList							;create PlList of players who we want on the ice now. a2 = team struct.
									;Takes the current line (tmline) by priolist; an unavailable
									;player (in the box or injured, -3 / -4) is replaced from sublist, or from
									;the whole roster
	movea.l	#(PlList-M68K_RAM),a4
	clr.l	(a4)					;goalie present: use the position priority list from the start
	clr.w	4(a4)
	movea.l	#priolist,a0
	tst.w	tmgoalie(a2)
	bpl.w	.gin					;branch if theres a goalie
;CD: no cartridge twin
	adda.w	#$1,a0
.gin								;line's players
	lea	tmlines(a2),a1				;loop: d5 = position, PlList slot = the line's player there (no player:
									;the goalie)
	move.w	tmline(a2),d0			;current line selected
	asl.w	#3,d0
	adda.w	d0,a1					;add to a1 to set a1 to currently selected line
	move.w	tmap(a2),d4				;tmap - active players (4-6 in normal ROM)
	bra.w	.next
.0									;each position
	clr.w	d5
	move.b	(a0,d4.w),d5			;move position into d5
	move.b	(a1,d5.w),(a4,d4.w)
	move.b	d5,plpos(a4,d4.w)
	bne.w	.next
	moveq	#1,d3					;loop: replace injured or penalized players
	add.w	tmgoalie(a2),d3
	move.b	d3,(a4,d4.w)
.next								;next position
	dbf	d4,.0
	moveq	#5,d4					;now check to see if player is available
.1									;each PlList slot
	move.b	(a4,d4.w),d3
	beq.w	.next1
	ext.w	d3
	subi.w	#1,d3
	add.w	d3,d3
	cmpi.w	#$FFFD,tmpdst(a2,d3.w)	;injured or not on the bench: find a substitute from sublist
	beq.w	.unavail
	cmpi.w	#$FFFC,tmpdst(a2,d3.w)	;check if player injured for game
	beq.w	.unavail
	tst.w	tmpdst(a2,d3.w)
	ble.w	.next1
.unavail							;find another player for the position
	lea	tmlines(a2),a1				;now find a player of similar position who is available move Line Lists
									;again into d0
	move.b	plpos(a4,d4.w),d0		;move 6+a4+d4 into d0 (previous d5)
	ext.w	d0
	asl.w	#1,d0
	movea.l	#sublist,a0				;move sublist into a0
	adda.w	(a0,d0.w),a0			;move a0+d0 into a0
.s1									;loop
	clr.w	d0
	move.b	(a0)+,d0
	bmi.w	.error
	move.b	(a1,d0.w),d0
	bsr.w	TryAddPlayerToList
	beq.w	.s1
.next1								;next PlList slot
	dbf	d4,.1
	rts
.error								;d0 negative
	jsr	(GetPlayerCount).l			;then try the players from d0 down
	move.w	d0,d3
.try								;loop
	move.w	d3,d0					;d0 = candidate player number, d3 counts down
	subi.w	#1,d3
	bmi.w	.next1					;none available
	bsr.w	TryAddPlayerToList
	beq.w	.try
	bra.w	.next1
TryAddPlayerToList					;d0 = player number (1 based), d4 = PlList slot. Put d0 in the slot if he
									;is on the bench or ice (not in the box, not injured) and not in PlList
									;yet; return d1 = 0 (Z set) if not
	move.w	d0,d1
	subi.w	#1,d0
	add.w	d0,d0
	tst.w	tmpdst(a2,d0.w)
	bgt.w	.0						;loop: is d1 already in PlList?
	cmpi.w	#$FFFD,tmpdst(a2,d0.w)
	beq.w	.0
	cmpi.w	#$FFFC,tmpdst(a2,d0.w)
	beq.w	.0
	moveq	#5,d0
.loop								;d1 not usable: return 0
	cmp.b	(a4,d0.w),d1
	dbeq	d0,.loop
	beq.w	.0
	move.b	d1,(a4,d4.w)
	rts
.0									;already in the list
	clr.w	d1
	rts
SetupPenaltyShot					;Penalty shot set up for team a2 (called from puckpenshot): the shooter
									;loop over the team: shooter plays center, goalie stays, others leave
	movem.l	d0-d5/a0-a3,-(sp)
;CD: no cartridge twin
	movea.l	$22(a2),a3
	moveq	#5,d4
.loop								;each sort object
	move.w	SCnum(a3),d0
	cmp.w	(BA_Sktr_SCnum).l,d0
	beq.w	.0
	cmp.w	(BA_Goalie_SCnum).l,d0
	beq.w	.1
	bset.b	#2,pflags2(a3)			;set player unavailable
	move.w	#$20,d0					;assgoaliebreakwait
	bsr.w	assreplace
	bra.w	.3
.0									;d0 = BA_Sktr_SCnum
	bsr.w	Setplass
	move.b	newpnum(a3),(savednewpnum).l
	move.b	(BA_Skater_Offset+1).l,newpnum(a3)	;put the player on the ice
	move.w	#4,position(a3)
	bra.w	.2
.1									;d0 = BA_Goalie_SCnum
	bsr.w	Setplass
	clr.w	position(a3)
.2									;mark him on the ice
	clr.w	d3						;next sort object
	move.b	newpnum(a3),d3
	add.w	d3,d3
	move.w	#$FFFF,tmpdst(a2,d3.w)
	lsr.w	#1,d3
	bsr.w	setplayer
.3									;next sort object
	st.b	newpnum(a3)
	st.b	newpos(a3)
	adda.w	#$80,a3
	dbf	d4,.loop
	movem.l	(sp)+,d0-d5/a0-a3
	rts								;loop over the team: apply the requested position and player
forcepldata							;no skating on/off: force players to correct data (for faceoffs only). a2
									;= team struct
	movem.l	d0-d4/a0-a3,-(sp)
;CD: no cartridge twin
	movea.l	$22(a2),a3
	moveq	#5,d4					;will run the loop 6 times
.top								;each sort object
	move.b	newpos(a3),d0			;newpos = requested next pos of player
	ext.w	d0
	tst.w	position(a3)
	bne.w	.0
	tst.w	d0						;set the position and its assignment; centers also get assnearest
	beq.w	.0
	move.w	SCnum(a3),-(sp)			;push SCNum to stack
	move.w	#$F,SCnum(a3)			;put F into SCNum
	jsr	(Set4WayPlayerStub).l
	move.w	(sp)+,SCnum(a3)			;pop original SCNum back into SCNum
.0									;set the position
	move.w	d0,position(a3)			;move newpos(d0) into position
	bmi.w	.next					;put the requested player on the ice
	bsr.w	Setplass
	cmpi.w	#4,position(a3)
	bne.w	.notnear
	moveq	#$11,d0					;$11 = anearest
	bsr.w	assinsert
.notnear							;mark him on the ice
	clr.w	d3						;d3 = requested player number
	move.b	newpnum(a3),d3			;next sort object
	add.w	d3,d3					;add d3 to itself
	move.w	#$FFFF,tmpdst(a2,d3.w)	;move -1 into tmpdst
									;put player on the ice
	lsr.w	#1,d3					;divide d3 by 2
	bsr.w	setplayer
.next								;next sort object
	st.b	newpnum(a3)				;set newpnum to FF
	st.b	newpos(a3)				;set newpos to FF
;CD: no cartridge twin
	adda.l	#$80,a3
	dbf	d4,.top
	movem.l	(sp)+,d0-d4/a0-a3
	rts
ResetBench							;remove all players from penalty box / put all players on their own bench
									;(not the injured, -3 / -4). Counts the players left in the box in PBnum
									;(home in the high nibble). .rb runs for the home team, then falls in for
									;the visitors
	clr.b	(PBnum).l
									;H = home players in PB
									;V = away players in PB
	moveq	#$10,d1
	movea.l	#$1834C,a0				;CD: the cartridge has #(tmstruct-M68K_RAM)
	bsr.w	.rb
	moveq	#1,d1
	adda.w	#tmsize,a0				;change to Away Team
.rb									;local subroutine
	moveq	#$32,d0					;$32 = (MaxRos-1)*2 = 50 decimal
.rb1								;loop
	add.b	d1,(PBnum).l
	tst.w	tmpdst(a0,d0.w)
									;check and see which players are in the box
									;(-2=bench, -1=ice, 0+=pen box)
									;starts from end of list and works backwards through loop
	ble.w	.cont
	btst.b	#4,tmpdst(a0,d0.w)		;test 3rd bit in tmpdst (4 decimal)
	beq.w	.next					;not in the box: mark on the bench unless injured
	move.w	tmpdst(a0,d0.w),d2		;move tmpdst into d2
	andi.w	#$7FF,d2				;mask 7FF with d2. Passes lowest 11 bits
	bne.w	.next
	sub.b	d1,(PBnum).l
	bra.w	.next
.cont								;penalty over: back to the bench
	sub.b	d1,(PBnum).l
	cmpi.w	#$FFFD,tmpdst(a0,d0.w)	;compare -3 with tmpdst
	beq.w	.next
	cmpi.w	#$FFFC,tmpdst(a0,d0.w)	;compare -4 with tmpdst
	beq.w	.next
	move.w	#$FFFE,tmpdst(a0,d0.w)	;move -2 into tmpdst
.next								;previous roster entry
	subi.w	#2,d0					;previous roster entry
	bpl.w	.rb1
	rts
Setplass							;set players (a3) initial assignment from .alist by position
	move.w	position(a3),d0
	bmi.w	rtss2
	lea	.alist(pc),a0
	move.b	(a0,d0.w),d0
	bra.w	assreplace
.alist	dc.b	$E					;assgoalie
									;assgoalie??
	dc.b	2						;assdefd
	dc.b	2						;assdefd
	dc.b	3						;asswingd
	dc.b	5						;asscenterd
	dc.b	3						;asswingd
	dc.b	5						;asscenterd
;CD: no cartridge twin
	dc.b	$00
setplayer							;bring player onto the ice and set his attributes. d3 = offset of player
									;on roster, a3 = sortcord of player. Reads the roster bytes through
									;AttributeCalc (attribute number in TempWord2). Adds the PP / PK, home /
									;away and third period bonuses (team ScoutReport bytes) to some attributes
									;and clamps them with ClampNibble
	bclr.b	#pf2inj,pflags2(a3)		;clear line change mode? (I believe pflags2 are 1 off because of fighting
									;missing)
	movea.l	#$1834C,a0				;Start of Team Struct (CD: the cartridge has #(tmstruct-M68K_RAM))
	btst.b	#pfteam,pflags(a3)		;checks if home or away (if 0, home)
	beq.w	.0
.AwayTeam							;(entry point inside setplayer)
									;$364 = size of Team Struct
	adda.w	#tmsize,a0
.0									;roster offset
	move.b	d3,pnum(a3)				;move d3 into pnum (offset on roster)
	moveq	#$A,d0					;$A = #aepen
	ext.w	d3
	add.w	d3,d3					;= asl #1,d3. Accomplishes the same. Doubles d3
	move.w	tmpdst(a0,d3.w),d1		;move tmpdst(a0, d3) into d1
	bpl.w	.da						;from the penalty box
	moveq	#9,d0					;assben
	cmpi.w	#$FFFE,d1				;not from the box or bench: clear the slot status, then read the team data
	bne.w	.nda
.da									;box or bench exit assignment
	bsr.w	assinsert				;enter the penalty box / bench exit assignment d0
	bclr.b	#pfalock,pflags(a3)
	clr.w	SPA(a3)
.nda								;free his slot
	move.w	#$FFFF,tmpdst(a0,d3.w)	;clear out temp space
	lsr.w	#1,d3					;shift d3 back to its original value
	movea.l	tmdata(a0),a0			;tmdata: the address of the team's data
									;(roster, etc)
	move.l	a0,-(sp)				;pushes starting position onto the stack
	adda.w	ScoutReport(a0),a0		;moves to offset where Off/Def byte is
	clr.l	(PPBonus).l
	tst.w	position(a3)
	beq.w	.playdatamove
	btst.b	#sf2pwrplay,(sflags2).l	;might be checking for a PP
	beq.w	.habonus				;penalty kill: minus the high nibble of the PP/PK byte
;CD: no cartridge twin
	jsr	(chkpk2).l
	beq.w	.pk
	move.b	srpppk(a0),(PPBonus).l	;moves PP/PK byte into PPBonus
	andi.b	#$F,(PPBonus).l			;passes lower nibble of PP/PK byte (bug)
	bra.w	.habonus				;home / away advantage: home gets the high nibble, away minus the low one
.pk									;penalty kill bonus
	move.b	srpppk(a0),d0			;moves PP/PK byte into d0
	lsr.b	#4,d0					;shifts d0.b 4 places, to remove the lower nibble
	neg.b	d0						;switches value to negative (because its a PK, its negative bonus)
	move.b	d0,(PKBonus).l			;move d0 into PKBonus
.habonus							;home / away bonus
	move.b	srhomeaway(a0),d0		;This is location of Home/Away adv
	andi.b	#$F,d0					;pass the lower nibble (Away) to d0
	neg.b	d0						;make d0 negative (away disadvantage)
	btst.b	#pfteam,pflags(a3)		;check if player is home or away
	bne.w	.3rdperbonuscheck
	move.b	srhomeaway(a0),d0		;player is home, move Home/Away byte back in to d0
	lsr.b	#4,d0					;Shift d0 4 places right, to move upper nibble into d0
.3rdperbonuscheck					;home / away bonus set
	move.b	d0,(HmAwBonus).l		;move d0 into HA bonus
	cmpi.w	#2,(gsp).l				;Check if period is 3rd or OT
	blt.w	.playdatamove			;late in the game: the leading team gets the 3rd period bonus
	bgt.w	.chklead
	jsr	(GetPeriodTime).l
	lsr.w	#1,d0					;divide by 2 (5 min length = 2:30)
	cmp.w	(gameclock).l,d0		;compare to game clock
	bgt.w	.playdatamove			;branch if d0 greater than gameclock (bug)
.chklead							;tied or trailing?
	move.w	(HmGoals).l,d0
	sub.w	(AwGoals).l,d0			;HmGoals-AwGoals
	beq.w	.load3pbonus
	btst.b	#pfteam,pflags(a3)		;Check if home or away
	beq.w	.home
	eori.b	#8,ccr					;If Aw team, checks if N flag is set from HmGoals-AwGoals.
									;a0 = this player's data in the team roster
.home								;leading: no bonus
	bpl.w	.playdatamove			;loop: skip to player d3
.load3pbonus						;tied or trailing late: third period bonus
	move.b	#2,(ThirdPBonus).l		;move 2 into 3rd Per Bonus
.playdatamove						;find the player's data
	movea.l	(sp)+,a0				;moves Team Data start to a0
	adda.w	0(a0),a0				;moves to player data offset (byte 0 and 1 of Team Data)
.skiploop							;skip each player before d3
	adda.w	(a0),a0					;skips the player's name length (current byte is name length)
;CD: no cartridge twin
	adda.w	#$8,a0
	dbf	d3,.skiploop
	suba.w	#$8,a0
	move.b	(a0),rostnum(a3)		;Jersey Number (pldnum)
	move.b	pldweight(a0),d3		;move weight / leg power byte to d3
	andi.w	#$F0,d3					;Mask Wgt nibble
	lsr.w	#1,d3					;shift d3 1 bit right (This is taking Wgt and mult by 8)
	move.b	d3,weight(a3)			;store in player struct
	move.b	pldweight(a0),d3		;move weight / leg power byte to d3
	andi.b	#$F,d3					;mask leg power nibble (legstr)
	move.w	#3,(TempWord2).l
	jsr	(AttributeCalc).l			;attribute math and add hot/cold
	move.b	d3,legstr(a3)			;move leg power byte (legstr) to player struct
	move.b	pldlegspd(a0),d3		;load Spd/OfA byte to d3
	lsr.b	#4,d3					;remove OfA nibble by shifting 4 bits right, moving Spd into lower nibble
	move.w	#4,(TempWord2).l
	jsr	(AttributeCalc).l
	move.b	d3,legspd(a3)			;move Spd byte into player struct
	move.b	pldlegspd(a0),d3		;move Spd/OfA byte to d3
	andi.b	#$F,d3					;mask d3 and pass only OfA nibble
	move.w	#5,(TempWord2).l
	jsr	(AttributeCalc).l
	add.b	(PPBonus).l,d3			;add Bonsuses to OfA
	add.b	(PKBonus).l,d3
	add.b	(HmAwBonus).l,d3
	add.b	(ThirdPBonus).l,d3
	bsr.w	ClampNibble
	lsr.b	#1,d3					;shift right 1 bit (divide by 2)
	eori.b	#$F,d3					;XOR d3 with F
	addi.b	#$F,d3					;add F to d3
	lsr.b	#1,d3
	move.b	d3,aioff(a3)			;OfA byte = (30-((OfA + Bonuses)/2))/2
	move.b	pldaidef(a0),d3			;move DfA/ShP byte to d3
	lsr.b	#4,d3					;see above
	move.w	#6,(TempWord2).l
	jsr	(AttributeCalc).l
	add.b	(HmAwBonus).l,d3
	bsr.w	ClampNibble
	lsr.b	#1,d3
	eori.b	#$F,d3
	addi.b	#$F,d3
	lsr.b	#1,d3
	move.b	d3,aidef(a3)			;same math and formula as OfA
	move.b	pldaidef(a0),shotspd(a3)
	andi.b	#$F,shotspd(a3)
	move.b	shotspd(a3),d3
	move.w	#7,(TempWord2).l
	jsr	(AttributeCalc).l
	move.b	d3,shotspd(a3)			;ShP does not get any bonuses
	move.b	pldcheck(a0),d3			;move Chk/Hnd byte into d3
	lsr.b	#4,d3
	move.w	#8,(TempWord2).l
	jsr	(AttributeCalc).l
	add.b	(ThirdPBonus).l,d3		;Chk gets 3rd P bonus only
	bsr.w	ClampNibble
	move.b	d3,checking(a3)			;move Chk into player struct
	bclr.b	#3,attribute(a3)		;clear bit 3 in attribute of player struct
	move.b	pldcheck(a0),handed(a3)	;move Chk/Hnd byte to Hnd in player struct
	andi.b	#1,handed(a3)			;Hnd bit
	eori.b	#1,handed(a3)			;XOR Hnd byte with 1. Sets to opposite what the bit was.
									;So L will be a 1 and R will be a 0
	bne.w	.attribloadcont
	bset.b	#3,attribute(a3)		;right handed: attribute bit 3 set (flipped sprite)
.attribloadcont						;load the rest of the attributes
	move.b	pldcheck(a0),fighting(a3)	;moves Chk/Hnd byte into Fgt byte in player struct
	andi.b	#$E,fighting(a3)		;mask the byte with E, ignoring the Hnd bit - will always be even
	move.b	pldstick(a0),d3			;move Stk/ShA byte into d3
	lsr.b	#4,d3
	move.w	#$A,(TempWord2).l
	jsr	(AttributeCalc).l
	add.b	(PPBonus).l,d3
	add.b	(PKBonus).l,d3
	add.b	(HmAwBonus).l,d3
	bsr.w	ClampNibble
	move.b	d3,stickhand(a3)		;Stk gets PP/PK/Tm Bonus
	move.b	pldstick(a0),d3
	andi.b	#$F,d3
	move.w	#$B,(TempWord2).l
	jsr	(AttributeCalc).l
	add.b	(PPBonus).l,d3
	add.b	(PKBonus).l,d3
	add.b	(HmAwBonus).l,d3
	bsr.w	ClampNibble
	move.b	d3,shotacc(a3)			;ShA gets PP/PK/Tm Bonus
	move.b	pldendur(a0),d3			;move End/PS Bias byte into d3
	lsr.b	#4,d3
	move.w	#$C,(TempWord2).l
	jsr	(AttributeCalc).l
	move.b	d3,endurance(a3)		;End gets no bonuses
	move.b	pldendur(a0),d3
	andi.b	#$F,d3
	move.w	#$D,(TempWord2).l
	jsr	(AttributeCalc).l
	add.b	(ThirdPBonus).l,d3
	add.b	(ThirdPBonus).l,d3
	bsr.w	ClampNibble
	move.b	d3,spodds(a3)			;PS Bias gets a double 3rd P bonus
	move.b	pldpass(a0),d3			;move Pas/Agr byte into d3
	lsr.b	#4,d3
	move.w	#$E,(TempWord2).l
	jsr	(AttributeCalc).l
	add.b	(PPBonus).l,d3
	add.b	(HmAwBonus).l,d3
	bsr.w	ClampNibble
	move.b	d3,passacc(a3)			;Pas gets PP and Tm bonus
	move.b	pldpass(a0),aggress(a3)	;moves Pas/Agr into Agr byte in player struct
	move.b	aggress(a3),d3			;moves Pas/Agr byte into d3 (weird way to do it)
	andi.b	#$F,d3
	move.w	#$F,(TempWord2).l
	jsr	(AttributeCalc).l
	move.b	d3,aggress(a3)			;Agr gets no bonus
	andi.b	#$F,aggress(a3)			;mask Agr byte with F, so max is 15 decimal
	rts
ClampNibble							;Clamp byte d3 to 0-$1E (93 clamped to 0-15). Called by setplayer
	tst.b	d3						;test if d3 is zero or higher
	bpl.w	.pos
	clr.w	d3
.pos								;clamp the top
	cmpi.b	#$1E,d3
	ble.w	.withinlimits
	move.w	#$1E,d3					;if higher, set to 1E
.withinlimits						;exit (also the end of the code above)
	rts
