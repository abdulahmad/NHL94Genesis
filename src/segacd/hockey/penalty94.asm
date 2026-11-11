;	HOCKEY.BIN $1E41A-$1F0F9 (runtime $3941A-$3A0F9): penalty94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	Part 1 of penalty94. On the disc penalty94 and collide94 are interleaved: penalty94 up to
;	updatepwrplay, collide94 up to setpersonel, then the rest of each (penalty94_2.asm, collide94_2.asm).

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

ShootoutWonBy	equ	$27B50
updatePPTeamTime	equ	$29FF8
getGoalieSCnum	equ	$30A70
assinsert	equ	$362D8
assreplace	equ	$362E4
forceblack	equ	$36D0A
song	equ	$3710C
sfx	equ	$3710C
DecompressGraphicsPlain	equ	$38958
eraser	equ	$38C06
Framer	equ	$38CA0
printz	equ	$38F6E
print	equ	$38F80
GetPeriodTimeRemaining	equ	$3B51E
rtss2	equ	$3C000
SetHor	equ	$3C40A
USBoard	equ	$3C666
NewTicker	equ	$3CCF2
NewTicker3	equ	$3CD3E
Setplass	equ	$3D754
setplayer	equ	$3D770
ShowThreeStars	equ	$40AFA
PenaltyShotBox	equ	$40DFC
ShowGoalBox	equ	$40EFA
GetPlayerName	equ	$41108
Penaltylist	equ	$4165C
PenShotPenalties	equ	$4198A
priolist	equ	$41AD6
stop_current_song	equ	$47DB0

	org	$3941A

;	Penalty logic. This file calls penalties and the other stoppages of play, awards penalty
;	shots on breakaways, sends players to the penalty box, runs power plays, shows the referee's
;	messages and switches the rink between its horizontal and vertical views.

AddPenalty							;add penalty d0 (Penaltylist offset) for player a3. Ignored while the
									;clock is stopped, when penalties are off, for a player with pflags2 bit 2
									;set, or offsides when offsides are off. Falls into AddPenalty2
	btst.b	#gmclock,(gmode).l		;gmclock
	bne.w	rtss2
	cmpi.w	#$C,d0					;icing (92 used 8)
	beq.w	AddPenalty2				;icing is always called
	tst.w	(OptPen).l
	beq.w	rtss2					;penalties off
	btst.b	#2,pflags2(a3)			;pflags2 bit 2, which releasepl sets
	bne.w	rtss2
	btst.b	#gmoffs,(gmode).l		;gmoffs: offsides on
	bne.w	AddPenalty2
	cmpi.w	#$10,d0					;offsides (92 used $A)
	beq.w	rtss2
AddPenalty2							;forced penalties like face off and game over. d0 = penalty number, a3 =
									;player or player on penalized team. From $E (goal) up: crowd sound. A
									;penalty with minutes sets DelayedPen bit 1 (home) or bit 2 (away)
	btst.b	#sfhor,(sflags).l		;sfhor: nothing in horizontal mode
	bne.w	rtss2
	movem.l	d1/a0-a1,-(sp)
	cmpi.w	#$E,d0					;goal (92 used 6) and up
	blt.w	.nonoise
	addi.w	#$C8,(Crowdlevel).l		;200
	move.w	#$C,-(sp)				;crowd boo sound effect (home team)
	btst.b	#pfteam,pflags(a3)		;pfteam
	beq.w	.song
	addi.w	#$14,(CwdExciteLvl).l	;visitors: +20 excitement
	move.w	#$B,(sp)				;crowd cheer sound effect
.song								;sound effect chosen for the penalized team's side
	bsr.w	song
.nonoise							;big penalties only get the crowd sound: log it now
	movea.l	#$18022,a1				;CD: the cartridge has #(PenBuf-M68K_RAM)
	moveq	#$1F,d1					;MaxPen-1
.0									;look for a free PenBuf slot
	tst.w	(a1)+					;find free slot
	dbeq	d1,.0					;find a free slot
	bne.w	.noplayer				;buffer full
	move.b	SCnum+1(a3),-(a1)		;SCnum+1
	move.b	d0,-(a1)				;and the penalty number (first byte)
	movea.l	#Penaltylist,a0
	adda.w	(a0,d0.w),a0
	tst.b	1(a0)					;penalty minutes
	beq.w	.noplayer
	bmi.w	.noplayer				;negative minutes too
	btst.b	#pfteam,pflags(a3)		;pfteam. DelayedPen bit 1 home, bit 2 away
	bne.w	.away
	bset.b	#1,(DelayedPen).l
	bra.w	.setpenflag
.away								;pfteam set
	bset.b	#2,(DelayedPen).l
.setpenflag							;delayed penalty flag set for the team
	bset.b	#pf2pen,pflags2(a3)		;pflags2 bit 4
	beq.w	.noplayer
	clr.w	(a1)					;player already has a penalty, drop this one
.noplayer							;exit: restore the registers
	movem.l	(sp)+,d1/a0-a1
	rts
PenaltyManager						;called periodically. d7 = elapsed time since last call
	bsr.w	updatepentime			;count down the penalty clocks (once a second)
	bsr.w	checkfornewpen			;call any newly queued penalty
	bsr.w	chkprogress				;step the stoppage / ref / penalty box sequence
	bra.w	UpdatePA				;animate the ref and return
chkprogress							;control progress of ref and game control thru penalty events. While
									;BA_PS_flags bit 2 is set (penalty shot), bit 7 calls PenaltyShotBox and
									;msgtimer counts down; when it runs out the message area is erased. Then,
									;when the stop delay runs out and a penalty with minutes is in PenBuf,
									;switch to the horizontal rink for the player to enter the penalty box
	btst.b	#2,(BA_PS_flags).l		;to.cont
	beq.w	.cont
	btst.b	#7,(BA_PS_flags).l
	bne.w	.sops
	tst.w	(msgtimer).l
	bmi.w	.cont
	subi.w	#1,(msgtimer).l
	bpl.w	.ex
	movem.l	d0-d7/a0-a6,-(sp)
	bclr.b	#sf2drec,(sflags2).l	;sf2drec
	bclr.b	#7,(gmode2).l
	bsr.w	printz
	String	CC_Font1,3,2
	moveq	#$1B,d0
	moveq	#8,d1
	btst.b	#0,(gmode2).l
	beq.w	.0
	move.w	#$C,d1					;12 rows when gmode2 bit 0 is set
.0									;box height chosen
	move.l	#$7FF,d2				;blank tile
	jsr	(eraser).l
	movem.l	(sp)+,d0-d7/a0-a6
	bra.w	.ex
.sops								;bit 7 of BA_PS_flags set
	jsr	(PenaltyShotBox).l
	bclr.b	#7,(BA_PS_flags).l
.ex									;exit (also the end of the code above)
	rts
.cont								;bit 2 of BA_PS_flags clear or msgtimer negative
	btst.b	#gmpen,(gmode).l		;gmpen: penalty called
	beq.w	rtss2					;exit if not
	tst.w	(PenCntDwn).l
	bmi.w	InProgress				;countdown finished earlier: run the ref sequence
	sub.w	d7,(PenCntDwn).l
	bpl.w	rtss2
	bclr.b	#gmpendel,(gmode).l		;gmpendel
	movea.l	#$18022,a0				;CD: the cartridge has #(PenBuf-M68K_RAM)
.find								;loop
	tst.w	(a0)+					;any penalty with minutes
	beq.w	rtss2
	clr.w	d0
	move.b	-2(a0),d0				;step back: penalty byte of the entry just read
	movea.l	#Penaltylist,a1
	adda.w	(a1,d0.w),a1
	tst.b	1(a1)					;penalty minutes
	beq.w	.find
	bmi.w	.find					;negative minutes too
	bset.b	#sf2drec,(sflags2).l	;sf2drec: switch to horizontal mode for player to enter penalty box
	move.w	(Vcount).l,-(sp)		;keep Vcount across the fade to black
	bsr.w	forceblack
	move.w	(sp)+,(Vcount).l
	bsr.w	SetHor					;horizontal rink graphics
	move.w	(ExtraChars).l,d4		;load horizontal ref tiles
;CD: no cartridge twin
	movea.l	(RefMap2Ptr).l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain
	bsr.w	NewTicker				;ticker score of another game, if the clock allows
	bsr.w	NewTicker3
	st.b	(puckc).l				;puck carrier = none
	movea.l	#$17B80,a3				;a3 = puck object (CD: the cartridge has #(puckx-M68K_RAM))
	moveq	#$1A,d0					;puckunflip
	bsr.w	assinsert				;puck does nothing during the sequence
	move.w	#$1C20,temp1(a3)		;temp1 = 120*60
	st.b	(RefStep).l				;ref idle until the first frame is pushed
	clr.w	(RefCnt).l
	bsr.w	UpdatePA
	move.w	#$32,(RefCnt).l			;50
	clr.w	d0
	bsr.w	PushRef					;ref frame 0
	move.w	#$18,(palcount).l		;24
	rts
PenShotChk							;a3 = checker, a2 = player hit, d0 = penalty. If a2 is on a breakaway ($64
									;bit 1), no penalty shot is pending (BA_PS_flags
									;bit 3) and PenShotPenalties has an entry for d0, getBAplayerInfo sets one
									;up and d0 = that penalty (also pspenalty). Called from CCStart before
									;AddPenalty
	movem.l	d1-d3/a0,-(sp)
	btst.b	#pf3break,pflags3(a2)	;breakaway
	beq.w	.loop
	btst.b	#3,(BA_PS_flags).l		;penalty shot pending
	beq.w	.0
.loop								;no penalty shot: d1 = -1 (no shooter)
	move.w	#$FFFF,d1
	bra.w	.end
.0									;bit 3 of BA_PS_flags clear
	movea.l	#PenShotPenalties,a0
	move.w	(a0,d0.w),d1			;penalty shot penalty for d0, -1 = none
	bmi.w	.end
	move.w	SCnum(a2),d2			;SCnum
	movem.w	d0-d1,-(sp)
	move.w	d2,d0
	jsr	(getBAplayerInfo).l
	movem.w	(sp)+,d0-d1
	bpl.w	.found					;N clear: penalty shot set up
	bclr.b	#3,(BA_PS_flags).l
	bra.w	.loop
.found								;d0-d1 >= 0
	move.w	d1,(pspenalty).l
	move.w	d1,d0					;return the penalty shot penalty
.end								;exit: restore the registers
	movem.l	(sp)+,d1-d3/a0
	rts
getBAplayerInfo						;d0 = SCnum (0-5 home team, 6-11 away team) of the player on the
									;breakaway, a3 = checker. If penalties are on and the other team has a
									;goalie in, set BA_PS_flags bit 3 and save BA_Sktr_SCnum, BA_Team,
									;BA_Goalie_SCnum and the skater, goalie and checker team position offsets
									;(pnum). Returns N clear when the penalty shot is set up
	movem.l	d1-d3/a1,-(sp)
	tst.w	(OptPen).l
	beq.w	.noPen
	bset.b	#3,(BA_PS_flags).l
	movem.w	d0,-(sp)
	move.w	#5,d1
	move.w	#0,d2
	cmpi.w	#5,d0
	bgt.w	.findgoalie				;away player: search the home team for its goalie (d1 = 5), else the
									;visitors (d1 = $B)
	move.w	#$B,d1
	move.w	#1,d2
.findgoalie							;d1 = the goalie's team side
	move.w	d1,d0
	jsr	(getGoalieSCnum).l
	tst.w	d0
	bpl.w	.goaliein				;branch if there's a goalie
	movem.w	(sp)+,d0				;no goalie
	bclr.b	#3,(BA_PS_flags).l
	bra.w	.end
.goaliein							;d0 >= 0
	move.w	d0,d1					;d1 = goalie's SCnum
	move.w	(sp)+,d0				;d0 now back to player checked on breakaway SCnum
	move.w	d0,(BA_Sktr_SCnum).l
	movea.l	#SortCords,a1
	move.w	d0,d3
	asl.w	#scsize,d3				;scsize
	move.w	#0,(BA_Team).l
	btst.b	#pfteam,pflags(a1,d3.w)	;pfteam
	beq.w	.0						;branch if home
	move.w	#1,(BA_Team).l
.0									;BA_Team set
	move.w	#0,(BA_Skater_Offset).l
	move.b	pnum(a1,d3.w),(BA_Skater_Offset+1).l	;store BA player's team position offset
	move.w	d1,(BA_Goalie_SCnum).l
	asl.w	#scsize,d1				;scsize
	move.w	#0,(BA_Goalie_Offset).l
	move.b	pnum(a1,d1.w),(BA_Goalie_Offset+1).l	;store goalie's team position offset
	move.w	#0,(BA_Checker_Offset).l
	move.b	pnum(a3),(BA_Checker_Offset+1).l	;store checker's team position offset
.end								;exit: restore the registers
	movem.l	(sp)+,d1-d3/a1
	rts
.noPen								;OptPen = 0
	move.w	#$FFFF,d1				;N set: no penalty shot
	bra.w	.end
InProgress							;ref in progress-- update graphics and stats and penalty information.
									;Takes the last PenBuf entry; the first pass logs a penalty
									;with minutes and sends the player to the box, later passes wait until he
									;is off the ice and drop the entry. When PenBuf is empty, recount players
									;and go to the face off, or the penalty shot. Only a 5 minute penalty is
									;matched as coincidental. Entered from chkprogress
	tst.w	(RefCnt).l
	bpl.w	rtss2					;animation in progress
	tst.w	(RefStep).l
	bpl.w	rtss2
	movem.l	d0/a0-a3,-(sp)
.top								;loop
	movea.l	#$18022,a0				;penalty buffer (CD: the cartridge has #(PenBuf-M68K_RAM))
	tst.w	(a0)+
	beq.w	.4
.0									;loop
	tst.w	(a0)+					;find end of list
	bne.w	.0						;find end of list
;CD: no cartridge twin
	suba.w	#$4,a0
	bclr.b	#7,pbscnum(a0)			;player who is guilty
	bne.w	.Sa						;first pass: log it
	move.l	a3,-(sp)
	clr.w	d1
	move.b	pbscnum(a0),d1
	asl.w	#scsize,d1				;scsize
	movea.l	#$17480,a3				;CD: the cartridge has #(SortCords-M68K_RAM)
	adda.w	d1,a3					;a3 = the player
	tst.w	position(a3)			;position
	movea.l	(sp)+,a3
	bpl.w	.ex						;still on the ice
	clr.w	(a0)					;gone: remove the entry
	bra.w	.ex
.Sa									;7 was set
	clr.w	d0						;first pass: d0 = penalty number
	move.b	(a0),d0
	movea.l	#Penaltylist,a1
	adda.w	(a1,d0.w),a1
	bclr.b	#5,(sflags5).l			;bit 5 = this penalty is 5 minutes
	clr.w	d2
	move.b	1(a1),d2				;penalty minutes
	beq.w	.sa2					;no player involved
	bmi.w	.sa2					;negative minutes too
	cmpi.b	#5,d2
	bne.w	.1
	bset.b	#5,(sflags5).l
.1									;5 minute penalty noted
	movem.l	d0-d1/a1-a4,-(sp)
	bsr.w	GetPeriodTimeRemaining	;log time, penalty and player
	movea.l	#(PenSum-M68K_RAM),a4
	adda.w	(PenSumLength).l,a4
	cmpi.w	#$EC,(PenSumLength).l	;log full: keep overwriting the last entry
	beq.w	.full
	addi.w	#4,(PenSumLength).l
.full								;slot chosen (the last one when the log is full)
	move.w	d0,(a4)+				;time
	move.b	(a0),(a4)+				;penalty
	clr.w	d1
	move.b	pbscnum(a0),d1
	asl.w	#scsize,d1				;scsize
	movea.l	#$17480,a3				;CD: the cartridge has #(SortCords-M68K_RAM)
	adda.w	d1,a3					;a3 = the guilty player
	clr.w	d0						;d0 = player id (bit 15 = visitors)
	movea.l	#$1834C,a2				;a2 = his team, a1 = the other team (CD: the cartridge has
									;#(tmstruct-M68K_RAM))
	lea	tmsize(a2),a1				;tmsize: visitors
	btst.b	#pfteam,pflags(a3)		;pfteam
	beq.w	.2
	bset.b	#7,-1(a4)				;log: visitors
	move.w	#$8000,d0
	exg	a1,a2
.2									;team struct of the penalized side chosen
	addi.w	#1,tmPenalties(a2)		;tmPenalties
	add.w	d2,tmPenmin(a2)			;tmPenmin
	move.b	pnum(a3),d0				;pnum
	move.b	d0,(a4)					;log: player
	move.w	d0,(TempPlOffset).l
	ext.w	d0
	addi.w	#$104,d0				;per-player penalty minutes byte at $102+pnum (CD: the cartridge has
									;#$102)
	add.b	d2,(a2,d0.w)
	subi.w	#$104,d0				;CD: the cartridge has #$102
	asl.w	#1,d0					;d0 = roster offset (player*2) for tmpdst
	ext.w	d2
	mulu.w	#$3C,d2					;60
	bset	#$D,d2					;tmpdst bit 13
	tst.w	tmpdst(a2,d0.w)			;tmpdst
	bmi.w	.3
	btst.b	#4,tmpdst(a2,d0.w)
	beq.w	.3
	bset	#$C,d2					;keep byte bit 4 (word bit 12) of an old penalty time
.3									;old penalty bit kept when needed
	move.w	d2,tmpdst(a2,d0.w)		;store the penalty time (seconds) for this player
.coinsearch	andi.w	#$EFFF,d2		;drop bit 12 for the comparison below
	moveq	#(maxros-1)*2+2,d1		;(MaxRos-1)*2+2
.ctop								;loop
	subi.w	#2,d1					;same time on the other team
	bmi.w	.nocoin
	move.w	tmpdst(a1,d1.w),d3
	andi.w	#$EFFF,d3
	cmp.w	d3,d2
	bne.w	.ctop
	btst.b	#5,(sflags5).l			;coincidental for a 5 minute penalty only
	beq.w	.ctop
	bset.b	#6,tmpdst(a1,d1.w)		;coincidental (byte bit 6, word bit 14)
	bset.b	#6,tmpdst(a2,d0.w)
.nocoin								;coincidental checked: put him in the box list
	movem.l	a0,-(sp)				;add player to penalty box list
	lea	tmboxlist(a2),a0			;add player to penalty box list
	moveq	#$18,d1
.pl									;find the end of the box list
	tst.b	(a0)+					;find end of list
	dbmi	d1,.pl					;find end of list
	move.b	d0,-1(a0)				;append the roster offset
	st.b	(a0)					;and a new -1 terminator
	movem.l	(sp)+,a0
	move.w	#$C,d0					;asspenalty
	bsr.w	assreplace				;a3 = the player: send him to the penalty box
	movem.l	(sp)+,d0-d1/a1-a4
	bsr.w	SetPA					;ref animation and message for this penalty
	bsr.w	USBoard					;update the penalty box lines on the score board
	bra.w	.ex
.sa2								;no player to send off: drop the entry
	clr.w	(a0)					;clear the entry
	btst.b	#sfhor,(sflags).l		;sfhor
	bne.w	.top					;horizontal mode: go on with the next entry
	bsr.w	SetPA
	bra.w	.ex
.4									;all entries done: coincidental check for both teams
	movea.l	#$1834C,a2				;home team struct (CD: the cartridge has #(tmstruct-M68K_RAM))
	bsr.w	InProgress_ap
	adda.w	#tmsize,a2				;tmsize
	bsr.w	InProgress_ap
	bclr.b	#gmpen,(gmode).l		;gmpen
	movea.l	#$17B80,a3				;a3 = puck object (CD: the cartridge has #(puckx-M68K_RAM))
	bclr.b	#6,(BA_PS_flags).l
	move.w	#$1B,d0					;puckfaceoff
	btst.b	#3,(BA_PS_flags).l
	beq.w	.5
	move.w	#$1E,d0					;puckshootout: penalty shot
.5									;faceoff or penalty shot chosen
	bsr.w	assreplace
.ex									;exit: restore the registers
	movem.l	(sp)+,d0/a0-a3
	rts
InProgress_ap						;a2 = team. Clears tmpdst bit 5, counts players kept off the ice by
									;penalties (coincidental and bit 4
									;times do not count, at most 2) and sets tmap. Called twice from
									;InProgress
	moveq	#6,d1					;d1 = players on ice, starts at 6
	moveq	#(maxros-1)*2,d0		;(MaxRos-1)*2
.loop								;loop
	tst.w	tmpdst(a2,d0.w)			;loop over the roster (d0 = player*2, counting down)
	ble.w	.nap					;not in the penalty box
	bclr.b	#5,tmpdst(a2,d0.w)		;clear the "just called" bit
	btst.b	#6,tmpdst(a2,d0.w)		;coincidental
	bne.w	.nap
	btst.b	#4,tmpdst(a2,d0.w)
	bne.w	.nap
	cmpi.w	#4,d1					;never below 4 players
	beq.w	.nap
	subi.w	#1,d1					;this player keeps the team one man short
.nap								;next player
	subi.w	#2,d0
	bpl.w	.loop
	move.w	d1,tmap(a2)				;tmap
	rts
checkfornewpen						;look for new penalty (entered thru addpenalty(2)). Stops play at once for
									;penalties without minutes or when the guilty team does not have the puck,
									;otherwise starts a delayed penalty call
	btst.b	#sfhor,(sflags).l		;sfhor
	bne.w	rtss2
.0									;unreferenced entry
	movea.l	#$18022,a0				;CD: the cartridge has #(PenBuf-M68K_RAM)
.next								;loop
	tst.w	(a0)+
	beq.w	rtss2
	btst.b	#gmpen,(gmode).l		;gmpen
	bne.w	.iscalled				;stoppage already running: just mark it called
	clr.w	d0
	move.b	-2(a0),d0				;step back: penalty byte of the entry just read
	movea.l	#Penaltylist,a1
	adda.w	(a1,d0.w),a1
	tst.b	1(a1)					;time for penalty
	beq.w	.callit					;no minutes (whistle, goal, icing ...): stop play now penalty with
									;minutes: puckc and the player number are both compared as (number - 6),
									;so the sign tells the team; different teams (or a loose puck) = delayed
									;call, play goes on
	move.w	(puckc).l,d0
	bmi.w	.dc						;loose puck
	subi.w	#6,d0
	move.b	-1(a0),d1				;player penalized
	ext.w	d1
	subi.w	#6,d1
	eor.w	d1,d0
	bmi.w	.dc						;delayed penalty call
.callit								;call it now
	bsr.w	Stop4Pen
.iscalled							;penalty called: mark the entry
	bset.b	#7,-1(a0)				;mark the entry as called (InProgress logs it)
	bne.w	.next					;was already marked: next entry
	clr.w	d0
	move.b	-2(a0),d0				;penalty called
	movea.l	#Penaltylist,a1
	adda.w	(a1,d0.w),a1
	clr.w	d1
	move.b	0(a1),d1				;delay for stopping action
	asl.w	#5,d1					;delay * 32 frames
	cmp.w	(PenCntDwn).l,d1
	ble.w	.next
	move.w	d1,(PenCntDwn).l		;keep the longest delay of the called penalties
	bra.w	.next
.dc									;other team has the puck: delay the call
	bset.b	#gmpendel,(gmode).l		;gmpendel
	bne.w	.next					;already signalled
	move.w	#$2C,d0					;delayed penalty (92 used $24)
	bsr.w	SetPA
	bra.w	.next
Stop4Pen							;a0 = penaltylist penalty +2. Stop the clock, set the face off spot from
									;the penalty type, blow the whistle, with stop_current_song before the
									;whistle. Also entered from puckfaceoff
	bset.b	#gmclock,(gmode).l		;gmclock
	bne.w	.skipfo					;already stopped: keep the face off spot
	clr.w	d0
	clr.w	d1
	cmpi.b	#$E,-2(a0)				;goal (92 used 6): center ice
	beq.w	.noticing
	move.w	(ltx).l,d0
	move.w	(lty).l,d1
	cmpi.b	#6,-2(a0)				;OOP (92 used $C)
	beq.w	.noticing
	move.w	(puckx).l,d0
	move.w	(pucky).l,d1
	cmpi.b	#$C,-2(a0)				;icing (92 used 8)
	bne.w	.noticing
	move.l	a3,-(sp)				;icing: the sign of y depends on the pfgoal flag of the icing player
	movea.l	#$17480,a3				;CD: the cartridge has #(SortCords-M68K_RAM)
	move.b	-1(a0),d1				;step back: player byte of the entry just read
	ext.w	d1
	asl.w	#scsize,d1				;scsize
	adda.w	d1,a3					;a3 = the icing player
	move.w	#$258,d1				;600
	btst.b	#pfgoal,pflags(a3)		;pfgoal
	movea.l	(sp)+,a3
	beq.w	.noticing
	neg.w	d1
.noticing							;faceoff Y at this end
	movem.w	d0-d1,-(sp)				;keep the unclamped x/y (x sign is tested below)
	cmpi.w	#$46,d0					;.xspot = 70
	blt.w	.0
	move.w	#$46,d0
.0									;X not past the right spot
	cmpi.w	#$FFBA,d0				;-.xspot
	bgt.w	.1
	move.w	#$FFBA,d0
.1									;X not past the left spot
	cmpi.w	#$A6,d1					;.yspot-.ygive = 206-40
	blt.w	.2
	move.w	#$CE,d1					;.yspot = 206
	move.w	#$46,d0
	tst.w	(sp)
	bpl.w	.2
	neg.w	d0
.2									;Y not past the top spot
	cmpi.w	#$FF5A,d1				;-.yspot+.ygive
	bgt.w	.3
	move.w	#$FF32,d1				;-.yspot
	move.w	#$46,d0
	tst.w	(sp)
	bpl.w	.3
	neg.w	d0
.3									;Y not past the bottom spot
	move.w	d0,(fox).l				;store the face off spot
	move.w	d1,(foy).l
;CD: no cartridge twin
	adda.w	#$4,sp
	bsr.w	limitfo					;pull it away from walls near any penalized player's end
.skipfo								;faceoff spot set (or clock already stopped)
	clr.w	(PenCntDwn).l
	bset.b	#gmpen,(gmode).l		;gmpen
	jsr	(stop_current_song).l
	move.w	#SFXwhistle,-(sp)		;whistle (92 used 10)
	bsr.w	sfx
	move.w	#$A,d0					;whistle (92 used $26)
	bra.w	SetPA
limitfo								;limit face off to 5-20 feet from walls of rink.
									;Checks every player in PenBuf
	movem.l	d0-d1/a0-a1,-(sp)
	movea.l	#$18022,a0				;CD: the cartridge has #(PenBuf-M68K_RAM)
.loop								;loop
	bsr.w	.lf						;adjust for this entry's player
;CD: no cartridge twin
	adda.w	#$2,a0
	tst.w	(a0)
	bne.w	.loop
	movem.l	(sp)+,d0-d1/a0-a1
	rts
.lf									;local subroutine
	move.b	pbscnum(a0),d0
	andi.w	#$7F,d0
	asl.w	#scsize,d0				;scsize
	movea.l	#$17480,a1				;CD: the cartridge has #(SortCords-M68K_RAM)
	move.w	#$58,d1					;limit +-88 on foy, by the player's pfgoal side
	btst.b	#pfgoal,pflags(a1,d0.w)	;pfgoal
	bne.w	.0
	neg.w	d1
	cmp.w	(foy).l,d1
	blt.w	rtss2
	move.w	#$FFBF,(foy).l			;-.nuy = -65
	bra.w	.sx
.0									;pfgoal set
	cmp.w	(foy).l,d1
	bgt.w	rtss2
	move.w	#$41,(foy).l			;.nuy = 65
.sx									;Y past the limit: keep the spot X out of the corner
	move.w	#$46,d0					;.nux = 70
	tst.w	(fox).l
	bpl.w	.1
	neg.w	d0						;keep the sign of fox
.1									;sign of fox kept
	move.w	d0,(fox).l
	rts
UpdatePA							;animate ref in ref window. Runs ShowThreeStars for game over, and the
									;horizontal penalty message line is reprinted when penmsgtimer runs out
	tst.w	(RefCnt).l
	bmi.w	rtss2
	sub.w	d7,(RefCnt).l
	bpl.w	.0						;frame delay not over
	bsr.w	SetPA2					;next frame
.0									;frame delay running
	cmpi.w	#4,(RefPen).l			;game over (92 used 4)
	bne.w	.1
	bsr.w	ShowThreeStars
.1									;message timer next
	sub.w	d7,(penmsgtimer).l
	bpl.w	rtss2
	move.w	#$7FFF,(penmsgtimer).l	;timer ran out (horizontal mode): reprint the line again
	bsr.w	ClearPenaltyMessage		;with the penalized player's name (TempPlOffset) at x $11, row $B
	bsr.w	printz
	String	CC_Font1Pri,$11,$B
	bsr.w	GetPlayerName
	move.w	(a1),d0
	lsr.w	#1,d0
	sub.w	d0,(printx).l			;center it
	bra.w	print
SetPA								;start ref animation. d0 = animation (penalty number). Animations from $2E
									;up are ignored, and ShootoutWonBy is called when gmode2 bits 0 and 3 are
									;set. Goal calls ShowGoalBox. Falls into SetPA2
	move.w	d0,(RefPen).l
	cmpi.w	#$2E,d0					;not on the penalty list
	blt.w	.1
	rts
.1									;d0 < $2E
	clr.w	(RefStep).l				;start the animation list from the beginning
	bsr.w	prefmes					;print its message
	cmpi.w	#$E,d0					;goal (92 used 6)
	bne.w	.2
	bsr.w	ShowGoalBox
.2									;goal box shown when it was a goal
	btst.b	#0,(gmode2).l
	beq.w	.0
	btst.b	#3,(gmode2).l
	beq.w	.0
	jsr	(ShootoutWonBy).l
.0									;shootout result shown when needed
	move.w	#$7FFF,(penmsgtimer).l	;vertical mode: never reprint
	btst.b	#sfhor,(sflags).l		;sfhor
	beq.w	SetPA2
	move.w	#$3C,(penmsgtimer).l	;60
SetPA2								;update animation for ref. Next frame/delay pair from the Penaltylist
									;animation of RefPen. The delay is doubled
									;when gmode2 bits 0 and 3 are set. Also called from UpdatePA
	movem.l	d0-d2/a0-a1,-(sp)
	moveq	#$40,d0					;clear ref window
	tst.w	(RefStep).l
	bmi.w	.pr						;idle: clear the window
	move.w	(RefStep).l,d0			;d0 = offset into the animation list
	addi.w	#2,(RefStep).l
	move.w	(RefPen).l,d1
	movea.l	#Penaltylist,a0
	adda.w	(a0,d1.w),a0
;CD: no cartridge twin
	adda.w	#$2,a0
	adda.w	(a0),a0
	move.w	(a0,d0.w),d0
	bpl.w	.0
	neg.w	d0						;negative = last frame
	st.b	(RefStep).l				;ref idle after this frame
.0									;frame number ready
	clr.w	d1						;low byte = delay
	move.b	d0,d1					;delay
	asl.w	#3,d1					;delay * 8 = frames to show this ref frame
	move.w	d1,(RefCnt).l
	btst.b	#0,(gmode2).l
	beq.w	.1
	btst.b	#3,(gmode2).l
	beq.w	.1
	move.w	d0,-(sp)
	move.w	(RefCnt).l,d0
	add.w	d0,d0
	move.w	d0,(RefCnt).l
	move.w	(sp)+,d0
.1									;delay doubled in a shootout
	lsr.w	#8,d0
.pr									;show the frame
	bsr.w	PushRef					;show the frame (d0 = $40 clears the window)
	movem.l	(sp)+,d0-d2/a0-a1
	rts
PushRef								;tell vblank what to display. d0 = ref frame, $40 clears the window. The
									;horizontal ref uses RefMap2
	movem.l	d0-d2/a0-a1,-(sp)
	cmpi.w	#$40,d0
	beq.w	.clearit
	mulu.w	#$70,d0					;refwidth*refheight*2
;CD: no cartridge twin
	movea.l	(RefsMapPtr).l,a0
	btst.b	#$7,(sflags).l
	beq.w	.L39D2A
	movea.l	(RefMap2Ptr).l,a0
.L39D2A
	adda.l	$4(a0),a0
	adda.w	#$4,a0
	adda.w	d0,a0					;+ frame offset
	movea.l	#(RefRamMap-M68K_RAM),a1	;a1 = ram copy of the ref map that vblank sends to vram
	move.w	(ExtraChars).l,d2		;d2 = start char of the ref tiles
	btst.b	#sfhor,(sflags).l
	bne.w	.4
	ori.w	#$8000,d2				;priority
.4									;priority set for vertical mode
	moveq	#$37,d0					;(refheight*refwidth)-1
.1									;copy each map word
	move.w	(a0)+,(a1)				;map word + start char/attributes
	add.w	d2,(a1)+
	dbf	d0,.1
	bset.b	#sf2refref,(sflags2).l	;sf2refref
	bra.w	.ex
.clearit							;d0 = $40
	btst.b	#sfhor,(sflags).l		;sfhor: horizontal mode only clears the line
	bne.w	.cl
	movea.l	#(RefRamMap-M68K_RAM),a1
	moveq	#$37,d0					;(refheight*refwidth)-1
.2									;blank each map word
	move.w	#$7FF,(a1)+				;blank tile
	dbf	d0,.2
	bset.b	#sf2refref,(sflags2).l	;sf2refref
.cl									;map cleared (vertical mode): now the message line
	moveq	#-1,d0					;clear line
	bsr.w	prefmes
.ex									;exit: restore the registers
	movem.l	(sp)+,d0-d2/a0-a1
	rts
prefmes								;print message for penalty d0 (negative clears it). Vertical mode: framed
									;under the ref. Horizontal mode: one centered line on row $B
	movem.l	d0-d2/a1,-(sp)
	btst.b	#sfhor,(sflags).l		;sfhor
	bne.w	.hor
	tst.w	d0
	bpl.w	.noblank
	bsr.w	printz					;negative d0: erase the 13x3 message area at x 0, y $A
	String	CC_Font1Pri,0,$A
	moveq	#$D,d0
	moveq	#3,d1
	move.w	#$7FF,d2				;blank tile
	bsr.w	eraser
	bra.w	.ex
.noblank							;d0 >= 0
	bsr.w	printz
	String	CC_Font1Pri,5,$A
	movea.l	#Penaltylist,a1
	adda.w	(a1,d0.w),a1
;CD: no cartridge twin
	adda.w	#$2,a1
	move.w	(a1),d0
	subi.w	#2,d0					;empty string
	beq.w	.ex
	lsr.w	#1,d0
	sub.w	d0,(printx).l			;center: back up by half the text length
	bpl.w	.nb0
	clr.w	(printx).l
.nb0								;text start kept on screen
	move.w	(a1),d0					;d0 = frame width from the string length
	tst.b	-$1(a1,d0.w)
	bne.w	.nb1
	subi.w	#1,d0					;one less when the last string byte is 0 (padding)
.nb1								;width set
	moveq	#3,d1					;frame height 3
	bsr.w	Framer
	subi.w	#2,(printy).l			;back inside the frame
	addi.w	#1,(printx).l
	bsr.w	print
	bra.w	.ex
.hor								;sfhor set
	bsr.w	ClearPenaltyMessage		;clear the line first
	tst.w	d0
	bmi.w	.ex
	bsr.w	printz					;print the message centered on x $11, row $B
	String	CC_Font1Pri,$11,$B
	movea.l	#Penaltylist,a1
	adda.w	(a1,d0.w),a1
;CD: no cartridge twin
	adda.w	#$2,a1
	move.w	(a1),d0
	lsr.w	#1,d0
	sub.w	d0,(printx).l
	bsr.w	print
.ex									;exit: restore the registers
	movem.l	(sp)+,d0-d2/a1
	rts
ClearPenaltyMessage					;Blank the horizontal mode penalty message line (22 spaces at x 5, y $B).
									;Called from UpdatePA and prefmes
	bsr.w	printz
	String	CC_Font1Pri,5,$B,'                      ',0	;22 spaces
	rts
PenGoalStuff						;do this stuff after a goal. a1 = scored on team, a2 = scoring team.
									;Clears PenBuf only when the scored
									;on team has 6 on the ice. If the scoring team had more players on ice,
									;the first scored on player in the box without a coincidental penalty is
									;released (also sets DelayedPen bit 0)
	movem.l	d0-d2/a0,-(sp)
	cmpi.w	#6,tmap(a1)				;tmap
	bne.w	.1
	bsr.w	ClearPenaltyBuffer
.1									;box list cleared when the team was back to 6
	move.w	tmap(a2),d2				;end p.killing by scored on team
	cmp.w	tmap(a1),d2
	ble.w	.ex						;scoring team did not have more players on the ice
	lea	tmboxlist(a1),a0			;penalty box list of the scored on team
.0									;loop
	clr.w	d2						;next box list entry
	move.b	(a0)+,d2				;d2 = roster offset of the next player in the box
	bmi.w	.ex						;end of list
	btst.b	#6,tmpdst(a1,d2.w)		;coincidental
	bne.w	.0						;skip those
	clr.w	tmpdst(a1,d2.w)			;release this player
	bsr.w	RemovePlayerFromList
	bset.b	#0,(DelayedPen).l
	addi.w	#1,tmap(a1)				;tmap
	addi.w	#1,tmPwrGoals(a2)		;tmPwrGoals
	bset.b	#tmflcc,(tmstruct+tmflags).l	;home tmflags: tmflcc
	bset.b	#tmflcc,(awtmstruct+tmflags).l	;visitors tmflags: tmflcc
.ex									;exit: restore the registers
	movem.l	(sp)+,d0-d2/a0
	rts
ClearPenaltyBuffer					;Clear PenBuf. Called from clockcont and PenGoalStuff
	moveq	#$1F,d0					;MaxPen-1
	movea.l	#$18022,a0				;CD: the cartridge has #(PenBuf-M68K_RAM)
.loop								;clear each word
	clr.w	(a0)+
	dbf	d0,.loop
	rts
updatepentime						;update the time remaining on all penalized players, once a second. Sets
									;sflags3 bit 6 on that tick, then updatePPTeamTime. Falls into
									;updatepentime_ut for team 2
	bclr.b	#sf3icetime,(sflags3).l	;clear last second's tick flag
	btst.b	#gmclock,(gmode).l		;gmclock
	bne.w	rtss2
	sub.w	d7,(Penaltytimer).l
	bpl.w	rtss2
	addi.w	#jps,(Penaltytimer).l	;jps
	bset.b	#sf3icetime,(sflags3).l	;one second tick
	bsr.w	chkatop					;attack time stat
	jsr	(updatePPTeamTime).l
	movea.l	#$1834C,a2				;team 1, then fall through for team 2 (CD: the cartridge has
									;#(tmstruct-M68K_RAM))
	bsr.w	updatepentime_ut
	adda.w	#tmsize,a2				;tmsize
updatepentime_ut					;a2 = team. Walks the penalty box list (tmboxlist): the first two players
									;without a coincidental penalty count down one second and the rest wait.
									;Beeps when the first served time gets to 5 or less and releases the
									;player at 0. Coincidental penalties count down on their own
	lea	tmboxlist(a2),a0			;penalty box list
	movea.l	#$17EF2,a1				;serving players (CD: the cartridge has #(mesarea-M68K_RAM))
	moveq	#2,d1					;two can serve at once
	moveq	#2,d3
.next								;loop
	clr.w	d0						;next list entry
	move.b	(a0)+,d0
	bmi.w	.done					;end of list
	btst.b	#6,tmpdst(a2,d0.w)		;coincidental
	bne.w	.1
	subi.w	#1,d1
	bmi.w	.next					;third or later player waits
	move.w	d0,(a1)+				;remember the serving player
	subi.w	#1,tmpdst(a2,d0.w)		;one second off
	bne.w	.cont
	bsr.w	RemovePlayerFromList	;time is up
.cont								;next player
	bra.w	.next
.done								;d0 negative
	move.w	(mesarea).l,d0			;first serving player
	cmpi.w	#1,d1					;one serving
	beq.w	.0
	tst.w	d1
	bne.w	.n1
	bsr.w	.0						;two serving: check the first, then the second
	bra.w	.two
.n1									;d1 <> 0
	cmpi.w	#$FFFF,d1				;exactly three in the list: check the second only
	bne.w	rtss2
.two								;check the second serving player
	move.w	(TextBuffer).l,d0		;second serving player (mesarea+2)
.0									;check one serving player: beep in his last 5 seconds
	cmpi.w	#5,tmpdst(a2,d0.w)
	bgt.w	rtss2
	move.w	#SFXbeep1,-(sp)			;SFXbeep1
	tst.w	tmpdst(a2,d0.w)
	bne.w	.snd
	bsr.w	releasepl				;time is 0: let him out
	move.w	#SFXbeep2,(sp)			;SFXbeep2
.snd								;beep (the release beep at 0)
	bsr.w	sfx
	rts
.1									;coincidental penalty: count down, released with no man change
	subi.w	#1,tmpdst(a2,d0.w)		;coincidental penalty
	btst.b	#3,tmpdst(a2,d0.w)		;high byte bit 3 (word bit 11), probably set when the count has run out
	beq.w	.next
	btst.b	#4,tmpdst(a2,d0.w)		;high byte bit 4 (word bit 12)
	bne.w	.2
	move.w	#$1000,tmpdst(a2,d0.w)
	bra.w	RemovePlayerFromList
.2									;count done: clear the time
	clr.w	tmpdst(a2,d0.w)			;falls into RemovePlayerFromList
RemovePlayerFromList				;Remove the entry before a0 from a penalty box list by shifting the rest
									;down (list ends with a negative byte). Return a0 = removed slot. Called
									;from PenGoalStuff, updatepentime_ut
	moveq	#-1,d2
.shift								;loop
	addi.w	#1,d2
	move.b	(a0,d2.w),-$1(a0,d2.w)
	bpl.w	.shift
;CD: no cartridge twin
	suba.w	#$1,a0
	rts
chkatop								;attack time of possession stat update. Called once a second from
									;updatepentime
	moveq	#0,d1					;d1 = struct offset of the team credited
	move.w	(pucky).l,d0
	cmpi.w	#$58,d0
	bgt.w	.1						;puck beyond y +$58: team 1 (d1 = 0)
	move.l	#tmsize,d1				;tmsize
	neg.w	d0
	cmpi.w	#$58,d0
	blt.w	rtss2
.1									;puck deep in a zone: credit that team
	btst.b	#gmdir,(gmode).l		;gmdir
	beq.w	.0
	eori.w	#tmsize,d1				;gmdir set: swap the teams
.0									;credited team chosen
	movea.l	#$1834C,a2				;a2 = team 1; d1 = offset of the credited team (CD: the cartridge has
									;#(tmstruct-M68K_RAM))
	addi.w	#1,tmATOP(a2,d1.w)		;attack time
	rts
releasepl							;player's penalty time is up so let him out (if appropriate). a2 = team,
									;d0 = player*2. Called from updatepentime_ut
	movem.l	d0-d3/a0-a3,-(sp)
;CD: no cartridge twin
	movea.l	$22(a2),a3
	suba.w	#SCstruct,a3
.0									;loop
	adda.w	#SCstruct,a3			;first sort obj not on the ice
	tst.w	position(a3)
	bpl.w	.0						;position >= 0 = on the ice
	move.w	d0,d3
	lsr.w	#1,d3					;d3 = player number
	move.w	tmap(a2),d1				;tmap
	addi.w	#1,tmap(a2)				;one more on the ice
	bset.b	#tmflcc,(tmstruct+tmflags).l	;home tmflags: tmflcc
	bset.b	#tmflcc,(awtmstruct+tmflags).l	;visitors tmflags: tmflcc
	movea.l	#priolist,a0
	tst.w	tmgoalie(a2)			;tmgoalie
	bpl.w	.1
;CD: no cartridge twin
	adda.w	#$1,a0
.1									;priority list chosen (no goalie: skip his entry)
	clr.w	position(a3)			;position
	move.b	(a0,d1.w),position+1(a3)
	bsr.w	Setplass				;initial assignment
	bsr.w	setplayer				;bring him onto the ice
	bset.b	#pf2unav,pflags2(a3)	;pflags2 bit 2
	movem.l	(sp)+,d0-d3/a0-a3
	rts
GetLowestPen						;a2 = shorthanded team, a3 = team on the power play. Return d0 = power
									;play time left from the penalty box times. Called from updatepwrplay
	clr.w	d0						;d0 = running total, d3 = previous time
	clr.w	d3
	lea	tmboxlist(a2),a0			;penalty box list
.getstatus							;loop
	clr.w	d2
	move.b	(a0)+,d2
	bmi.w	.endoflist
	move.w	tmpdst(a2,d2.w),d2		;tmpdst
	btst	#$E,d2					;bit 14: coincidental
	bne.w	.getstatus
	sub.w	d3,d2
	add.w	d2,d0
	move.w	d2,d3
	bra.w	.getstatus
.endoflist							;d2 negative
	cmpi.w	#6,tmap(a3)				;tmap: 6 on ice, done
	beq.w	rtss2
	sub.w	d3,d0
	lea	tmboxlist(a3),a0			;then the other team's box list
	clr.w	d2
.getstatusopp						;loop
	move.b	(a0)+,d2
	bmi.w	rtss2
	btst.b	#6,tmpdst(a3,d2.w)		;coincidental (byte bit 6, word bit 14)
	bne.w	.getstatusopp
	cmp.w	tmpdst(a3,d2.w),d0
	blt.w	rtss2
	add.w	d3,d0
	rts
