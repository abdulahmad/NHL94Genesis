;	HOCKEY.BIN $F902-$FE67 (runtime $2A902-$2AE67): ui94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	Most of it is the cartridge code. CD: PlayedByText and the playoff sprites use the graphics
;	pointer table ($47D90-$47DA8) and word RAM ($BBD30); the first lines of DrawPlayoffSprite and
;	CountButtonPress have no twin.

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

ReadCrowdRecord	equ	$2258E
CopyString	equ	$25818
GetLogName	equ	$26E0E
randomd0	equ	$37050
DecompressGraphicsPlain	equ	$38958
printz	equ	$38F6E
print	equ	$38F80
PushNumberWidth	equ	$3919A
appendz	equ	$39200
appstring	equ	$39208
SetSframe	equ	$3E028
SPAbenchcheckl	equ	$193E
SPAbenchcheckr	equ	$1A00
SPAboardback	equ	$185A
SPAboardfront	equ	$1776
SPAboardleft	equ	$18CC
SPAboardright	equ	$17E8

	org	$2A902

;	High-ROM leftover screens and print helpers packed after the shootout paths:
;	picture unpack, home-team rink gfx, board fall, HiScore, "played by". New in 94.
;	ROM-contiguous from UnpackPicture through PlayedByAway.

UnpackPicture						;Unpack a picture a2: count.w, then 3 bytes per row of 8 pixels to 4 bit
									;pixels + 5 at picturebuf (count first). Called from DrawPictureBox,
									;DrawMatchupPicture and PlayerCardScreen
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#picturebuf,a0
	movea.l	#picturebits,a1
	move.w	(a2)+,d0				;row count: first word of the picture
	move.w	d0,(a0)+
	asl.w	#3,d0					;8 rows per tile
	subi.w	#1,d0
.loop								;each row: 3 bytes = 8 pixels of 3 bits
	clr.l	(a0)
	clr.l	(a1)
	move.b	(a2)+,(a1)
	move.b	(a2)+,1(a1)
	move.b	(a2)+,2(a1)
	move.l	#0,-(sp)				;build the 8 pixels of 4 bits each, + 5 for the card palette
	move.l	(a1),d2
	andi.l	#$E0000000,d2			;pixel 0 (bits 31-29)
	lsr.l	#1,d2
	addi.l	#$50000000,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$1C000000,d2			;pixel 1
	lsr.l	#2,d2
	addi.l	#$5000000,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$3800000,d2			;pixel 2
	lsr.l	#3,d2
	addi.l	#$500000,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$700000,d2				;pixel 3
	lsr.l	#4,d2
	addi.l	#$50000,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$E0000,d2				;pixel 4
	lsr.l	#5,d2
	addi.l	#$5000,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$1C000,d2				;pixel 5
	lsr.l	#6,d2
	addi.l	#$500,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$3800,d2				;pixel 6
	lsr.l	#7,d2
	addi.l	#$50,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$700,d2				;pixel 7
	move.w	#8,d5
	lsr.l	d5,d2
	addi.l	#5,d2
	or.l	d2,(sp)
	move.l	(sp)+,(a0)+
	dbf	d0,.loop					;loop
	movem.l	(sp)+,d0-d7/a0-a6
	rts
LoadHomeTeamGfx						;Load the HomeTeam graphics of TeamGfxList to VRAM d4 - $18
									;(DecompressGraphicsPlain). Called from setupice, ClrHor and
									;ReloadRinkGraphics
	move.w	d0,-(sp)
	subi.w	#$18,d4					;the team graphics sit $18 tiles before d4
;CD: no cartridge twin
	tst.w	$17468.l
	beq.s	.L2A9E6
	movea.l	$47DA8.l,a2
	bra.s	.L2A9EC
.L2A9E6
	movea.l	(HomeTeamGfxPtr).l,a2
.L2A9EC
	adda.w	#$8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	(sp)+,d0
	rts
;CD: no cartridge twin
	ori.b	#$23,d0
	ori.b	#$3C,d0
	ori.b	#$24,d0
	ori.b	#$25,d0
	ori.b	#$26,d0
	ori.b	#$27,d0
	ori.b	#$28,d0
	ori.b	#$29,d0
	ori.b	#$2A,d0
	ori.b	#$2B,d0
	ori.b	#$2C,d0
	ori.b	#$2D,d0
	ori.b	#$2E,d0
	ori.b	#$2F,d0
	ori.b	#$30,d0
	ori.b	#$31,d0
	ori.b	#$32,d0
	ori.b	#$33,d0
	ori.b	#$34,d0
	ori.b	#$35,d0
	ori.b	#$36,d0
	ori.b	#$37,d0
	ori.b	#$38,d0
	ori.b	#$39,d0
	ori.b	#$3A,d0
	ori.b	#$3B,d0
	ori.b	#$3D,d0
	ori.b	#$3E,d0
TeamGfxListEnd						;end of TeamGfxList (size check below)
PrintPlayerAssists					;Print " (n)": tmassists + d0 of team a2, then the next row at x $E.
									;Called from ShowGoalBox
	movem.l	d0/a2,-(sp)
	jsr	(printz).l					;print " ("
	String	' ('
	adda.w	#tmassists,a2			;assists of this game
	bra.w	PrintParenNumber
PrintPlayerGoals					;As PrintPlayerAssists with tmgoals + d0. Called from ShowGoalBox
	movem.l	d0/a2,-(sp)
	jsr	(printz).l					;print " ("
	String	' ('
	adda.w	#tmgoals,a2				;goals of this game
PrintParenNumber					;PrintPlayerAssists / PrintPlayerGoals: the number (1 to 3 digits,
									;PushNumberWidth) and ")"
	move.b	(a2,d0.w),d0
	ext.w	d0
	move.w	#1,d1					;width 1 digit
	cmpi.w	#9,d0					;over 9?
	ble.w	.0						;up to 9: 1 digit
	move.w	#2,d1					;2 wide
	cmpi.w	#$63,d0					;up to 99: 2 digits
	ble.w	.0						;up to 99: 2 digits
	move.w	#3,d1					;3 wide
.0									;width chosen
	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l					;print ")"
	String	')'
	addi.w	#1,(printy).l			;the next line of the goal box
	move.w	#$E,(printx).l
	movem.l	(sp)+,d0/a2
	rts
PlaceBoardFall						;A player falling into the boards (SPAboardfront ... SPAbenchcheckl). For
									;frames SPAboardfront / SPAboardback (y to $124 / $FEDC, or $116 / $FEEA
									;by FallXPos) and SPAboardright / SPAbenchcheckr / SPAboardleft /
									;SPAbenchcheckl (x to +-$82 / $88 by attribute bit 3) of SPA(a3): move
									;player a3 half way there. Called from updateplayers
	cmpi.w	#SPAbenchcheckl,SPA(a3)	;left bench check?
	beq.w	.12
	cmpi.w	#SPAbenchcheckr,SPA(a3)	;right bench check?
	beq.w	.8
	cmpi.w	#SPAboardleft,SPA(a3)	;left boards?
	beq.w	.10
	cmpi.w	#SPAboardright,SPA(a3)	;right boards?
	beq.w	.6
	cmpi.w	#SPAboardfront,SPA(a3)	;front boards?
	beq.w	.0
	cmpi.w	#SPAboardback,SPA(a3)	;back boards?
	beq.w	.3
	bra.w	.x						;any other frame: nothing to move
.0									;front boards: the wall Y, closer in near the corners
	move.w	#$124,d0
	cmpi.w	#$56,(FallXPos).l		;right corner: closer wall
	bgt.w	.1
	cmpi.w	#$FFAA,(FallXPos).l		;middle: the full wall
	bgt.w	.2
.1									;near a corner: the closer wall
	move.w	#$116,d0
.2									;wall Y chosen: move half way there
	sub.w	Ypos(a3),d0
	bmi.w	.x						;already past it
	asr.w	#1,d0
	add.w	d0,Ypos(a3)
	bra.w	.x
.3									;back boards: the same at the far end
	move.w	#$FEDC,d0
	cmpi.w	#$56,(FallXPos).l		;right corner: closer wall
	bgt.w	.4
	cmpi.w	#$FFAA,(FallXPos).l		;middle: the full wall
	bgt.w	.5
.4									;near a corner: the closer wall
	move.w	#$FEEA,d0
.5									;wall Y chosen: move half way there
	sub.w	Ypos(a3),d0
	bpl.w	.x						;already past it
	asr.w	#1,d0
	add.w	d0,Ypos(a3)
	bra.w	.x
.6									;right boards: X to the wall
	move.w	#$82,d0
	btst.b	#3,attribute(a3)		;attribute bit 3: the other wall
	beq.w	.7
	move.w	#$FF7E,d0
.7									;move half way there
	sub.w	0(a3),d0
	asr.w	#1,d0
	add.w	d0,0(a3)
	bra.w	.x
.8									;right bench boards: a little further out
	move.w	#$88,d0					;bench wall X
	btst.b	#3,attribute(a3)		;attribute bit 3: the other side
	beq.w	.9
	move.w	#$FF78,d0				;other side
.9									;move half way there
	sub.w	0(a3),d0
	asr.w	#1,d0
	add.w	d0,0(a3)
	bra.w	.x
.10									;left boards
	move.w	#$FF7E,d0				;wall X
	btst.b	#3,attribute(a3)		;attribute bit 3: the other side
	beq.w	.11
	move.w	#$82,d0					;other side
.11									;move half way there
	sub.w	0(a3),d0
	asr.w	#1,d0
	add.w	d0,0(a3)
	bra.w	.x
.12									;left bench boards
	move.w	#$FF78,d0				;bench wall X
	btst.b	#3,attribute(a3)		;attribute bit 3: the other side
	beq.w	.13
	move.w	#$88,d0					;other side
.13									;move half way there
	sub.w	0(a3),d0
	asr.w	#1,d0
	add.w	d0,0(a3)
.x									;exit (also the end of the code above)
	rts
GetLeagueCrowdRecord				;d0 = the team (of NumTeams) with the highest crowd record (crpeak)
									;(ReadCrowdRecord; 0 counts as $50). Called from PrintCrowdMeter
	movem.l	d1-d7/a0-a6,-(sp)
	move.w	#NumTeams-1,d1
	ext.l	d1
	clr.w	d7						;d7 = highest so far
	movea.l	#ThreeStars,a0
.loop								;read each team's crowd block
	jsr	(ReadCrowdRecord).l			;read team d1's records
	clr.w	d2
	move.b	crpeak(a0),d2
	bne.w	.0						;a record: use it
	move.w	#$50,d2					;none: $50 dB
.0									;this team's peak
	cmp.w	d7,d2					;higher?
	ble.w	.next
	move.w	d2,d7
	move.w	d1,d0
.next								;next team
	dbf	d1,.loop					;loop
	movem.l	(sp)+,d1-d7/a0-a6
	rts
getFgtbyte							;d0 = fighting byte of a2 / 4. Called from setInjuryType
	clr.w	d0
	move.b	fighting(a2),d0			;move H/F bit into d0 (this is always even)
	lsr.w	#2,d0					;shift 2 right (divide by 4)
	rts
chkFgtBit1							;test bit 1 of fighting(a2). Called from setInjuryType
	btst.b	#1,fighting(a2)
	rts
RandomFaceoffAnim					;d0 = a random faceoff animation from FaceoffAnims, 6 when fox <= -$40 and
									;foy <= $C0. Called from puckfaceoff
	movem.l	a0,-(sp)
	movea.l	#FaceoffAnims,a0
	move.w	#$64,d0					;random 0-99
	jsr	(randomd0).l
	andi.w	#7,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d0			;the animation number
	cmpi.w	#$FFC0,(fox).l			;dropped left of center?
	bgt.w	.x						;puck dropped off center: keep the random one
	cmpi.w	#$C0,(foy).l			;dropped below?
	bgt.w	.x
	move.w	#6,d0					;center ice: animation 6
.x									;exit: restore the registers
	movem.l	(sp)+,a0
	rts
FaceoffAnims						;RandomFaceoffAnim animations
	dc.w	3,5,3,1,5,2,3,3,$FFFF
CheckScoreLeader					;Compare tmap (players on ice) of tmstruct / awtmstruct and test tmteam of
									;the team with more for $13 (SJ); the result is not used (bne.w *+4).
									;Called from puckfaceoff
	movem.l	d0-d2/a0-a2,-(sp)
	movea.l	#tmstruct,a0
	movea.l	#awtmstruct,a1
	move.w	tmap(a0),d0				;home players on ice
	sub.w	tmap(a1),d0
	beq.w	.x						;same number on the ice: done
	bpl.w	.0						;home has more: test home
	exg	a0,a1						;away has more: test the away team
.0									;team with more players
	cmpi.w	#$13,tmteam(a0)
	bne.w	.x						;(the branch goes to the next line either way)
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d2/a0-a2
	rts
DrawPlayoffSprite					;The StanleyCupSprite sprite at playoffspritex / playoffspritey in Satt,
									;then
									;end the sprite list (Sattsize = its size). Called from PlayoffScreen
	movea.l	#(Satt-M68K_RAM),a6
	moveq	#1,d6
;CD: no cartridge twin
	movea.l	(StanleyCupSpritePtr).l,a0
	move.w	(logochars).l,d3
	ori.w	#$8000,d3				;high priority
	move.w	(playoffspritex).l,d0
	move.w	(playoffspritey).l,d1
	move.w	#1,d2					;frame 1
	jsr	(SetSframe).l
	cmpa.l	#(Satt-M68K_RAM),a6		;any drawn?
	bne.w	.0						;sprites drawn: end the list
	clr.l	(a6)+					;no sprite drawn: add an empty one
	clr.l	(a6)+
.0									;end the link chain at the last sprite
	clr.b	satLink-satLen(a6)
	move.l	a6,d0					;end of the list
	subi.l	#$BBD30,d0				;CD: the cartridge has #Satt
	lsr.w	#1,d0
	move.w	d0,(Sattsize).l
	rts
GetTeamStruct						;a2 = tmstruct, or awtmstruct when team d2 is not tmteam of tmstruct.
									;Called from PrintStartingLine
	movea.l	#tmstruct,a2
	cmp.w	tmteam(a2),d2			;team d2 is the home team
	beq.w	.x
	movea.l	#awtmstruct,a2
.x									;exit (also the end of the code above)
	rts
;CD: no cartridge twin
CountButtonPress					;CD: entered here; the cartridge CountButtonPress starts at its first twin
									;line, $2AD3E
	movem.l	d1/a0,-(sp)
	btst.b	#gmclock,(gmode).l		;clock running?
	bne.w	.x						;no count while the clock is stopped
	move.w	(TempWord1).l,d1		;pad direction
	movea.l	#homepresses,a0			;home pad counters
	tst.w	d4						;away pad?
	beq.w	.0
	movea.l	#awaypresses,a0
.0									;pad counter chosen
	addi.l	#1,(a0)					;every press counts
	cmpi.w	#8,d1
	beq.w	.x						;no direction: not a turn
	cmp.w	facedir(a3),d1
	beq.w	.x						;same direction as he faces: not a turn
	addi.l	#1,4(a0)				;presses that change direction
;CD: no cartridge twin
.x									;CD: placed where the disc branches to it
	movem.l	(sp)+,d1/a0
	rts
TerminateLogName					;Unreferenced. The GetLogName String at lognametext, ended with 0 at
									;namelength and its length word made even
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#lognametext,a1
	bsr.w	GetLogName
	move.w	(namelength).l,d0
	move.b	#0,(a1,d0.w)			;end the name with 0
	addi.w	#1,d0
	andi.w	#$FFFE,d0				;length rounded to even
	move.w	d0,-2(a1)
	movem.l	(sp)+,d0-d7/a0-a6
	rts
PlayedByHome						;a1 = String "(played by NAME)" for homeuser (GetLogName name), or an
									;empty String for 0. Called from UpdateScoutingDisplay
	movem.l	d0-d7/a0/a2-a6,-(sp)
	move.w	(homeuser).l,d0
PlayedByText						;PlayedByHome / PlayedByAway body
	tst.w	d0						;a user?
	beq.w	PlayedByNone			;no user: the empty String
	movea.l	#nameentrybuf+2,a1		;the name after a length word
	move.w	d0,(namelogsel).l
	bsr.w	GetLogName
	adda.w	(namelength).l,a1		;end the name with 0
	move.b	#0,(a1)
	addi.w	#1,(namelength).l
	andi.w	#$FFFE,(namelength).l	;rounded to even
	addi.w	#2,(namelength).l		;rounded to even + the header
	move.w	(namelength).l,(nameentrybuf).l
	movea.l	#nameentrybuf,a1
	move.l	a1,-(sp)
	movea.l	#TempBuffer,a3
	movea.l	#PlayedByTxt,a1			;"(played by " then the name and ")"
	bsr.w	CopyString				;copy "(played by "
	movea.l	(sp)+,a1
	movea.l	#TempBuffer,a3
	jsr	(appstring).l				;append the name
	movea.l	#TempBuffer,a3
	jsr	(appendz).l
	String	')'
	movea.l	#TempBuffer,a1			;a1 = the String
PlayedByExit						;Exit
	movem.l	(sp)+,d0-d7/a0/a2-a6
	rts
PlayedByTxt							;PlayedByHome text
	String	'(played by '
PlayedByEmptyTxt					;PlayedByHome: the empty String
	dc.w	2						;empty String
PlayedByNone						;PlayedByHome: no name
	movea.l	#PlayedByEmptyTxt,a1
	bra.w	PlayedByExit
PlayedByAway						;As PlayedByHome for awayuser. Called from UpdateScoutingDisplay
	movem.l	d0-d7/a0/a2-a6,-(sp)
	move.w	(awayuser).l,d0
	bra.w	PlayedByText			;share the body
