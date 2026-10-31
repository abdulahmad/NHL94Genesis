;	Player assignments. Each computer player is given a job for the moment: skating to the bench
;	or the penalty box and back, lining up for a faceoff, celebrating a goal, or playing his spot
;	as a defenseman or a wing. There is no fighting in this game, so the fight assignments do nothing.

check4bench							;check if player a3 should go to bench
	btst	#2,(BA_PS_flags).w		;BA_PS_flags bit 2 set?
	bne.s	rtss3					;yes: no bench trip
	btst	#pfjoycon,pflags(a3)	;human controlled?
	bne.s	rtss3					;yes: no bench trip
	btst	#pf2pen,pflags2(a3)		;penalty (pf2pen)?
	bne.s	rtss3					;yes: no bench trip
	tst.b	newpos(a3)				;new position set?
	bpl.w	.0						;no: continue
	tst.b	newpnum(a3)				;new player number set?
	bmi.s	rtss3					;no: no bench trip
.0									;a line change is pending (new position, or a new player number)
	move.b	newpnum(a3),d0			;new player number differs from current -> go to the bench; else only
									;change position
	cmp.b	pnum(a3),d0				;same player number?
	beq.w	.samepl					;player should just change positions
	move.w	assnum(a3),d0			;d0 = assignment
	cmpi.b	#$B,asslist(a3,d0.w)	;already going to bench
	beq.s	rtss3					;zero: no bench trip
	move.w	SCnum(a3),d0			;d0 = SCnum
	cmp.w	(puckc).w,d0			;puck carrier?
	beq.s	rtss3					;yes: no bench trip
	addq.w	#4,sp					;drop the return address
	bset	#pf2unav,pflags2(a3)	;set player unavailable (pf2unav)
	clr.w	temp1(a3)				;temp1 0
	move.l	#$B,d0					;assbench
	bra.w	assreplace				;assreplace
.samepl								;same player: no trip to the bench, take the new position here
	addq.w	#4,sp					;drop return address (takes over the assignment); apply new position now
	bclr	#pf2unav,pflags2(a3)	;clear pf2unav
	bclr	#pfnc,pflags(a3)		;clear pfnc
	st	newpnum(a3)					;no new player number
	st	newpos(a3)					;no new position
	move.w	position(a3),d0			;d0 = position
	tst.b	newpos(a3)				;new position set?
	bpl.w	.1						;no: set the player
	jmp	Setplass					;set the player attributes
.1									;newpos set: use it as the position
	move.b	newpos(a3),d0			;d0 = new position
	ext.w	d0						;word
	move.w	d0,position(a3)			;set the position
	jmp	Setplass					;set the player attributes
; player a3 should go to bench

assbench							;player a3 should goto bench
	btst	#pfalock,pflags(a3)		;locked (pfalock)?
	bne.w	rtss3					;yes: done
	cmpi.w	#$64,temp1(a3)			;temp1 = 100 flag: at the bench door
	beq.w	.done					;branch taken: finish the move
	bsr.w	check4bench				;should he go to the bench?
	btst	#pf2pen,pflags2(a3)		;pf2pen
	bne.w	assexit					;yes: exit
	bclr	#pfna,pflags(a3)		;clear pfna
	beq.w	.nna					;it was clear: skate on
	move.w	#8,temp2(a3)			;temp2 8
	moveq	#$50,d0					;80
	btst	#pfteam,pflags(a3)		;which team?
	bne.w	.0						;away: keep the sign
	neg.w	d0						;negate for home
.0									;d0 = bench y: +80 away, -80 home
	move.w	d0,temp4(a3)			;bench y
	move.w	#$88,temp3(a3)			;bench x $88
	neg.w	temp3(a3)				;negated
	subq.w	#8,temp3(a3)			;temp3 = bench x
	clr.w	temp1(a3)				;temp1 0
.nna								;every call: same player only changes position; otherwise skate to the
									;bench door
	move.b	newpnum(a3),d0			;same player? just change position
	cmp.b	pnum(a3),d0				;same player number?
	beq.w	.nobench				;same player, just change position
	sub.w	d7,temp1(a3)			;count temp1 down by d7
	bpl.w	.nodec					;still positive: skate on
	addq.w	#8,temp1(a3)			;reload with 8
	move.w	Ypos(a3),d0				;d0 = y
	sub.w	temp4(a3),d0			;minus the bench y
	cmp.w	#$28,d0					;beyond +$28?
	bgt.w	.nodec					;yes: skate on
	cmp.w	#$FFD8,d0				;beyond -$28?
	blt.w	.nodec					;yes: skate on
	move.w	(a3),d0					;d0 = x
	sub.w	temp3(a3),d0			;minus the bench x
	cmp.w	#$20,d0					;beyond +$20?
	bgt.w	.nodec					;yes: skate on
	move.w	#SPAglide,d1			;glide animation
	tst.w	position(a3)			;goalie?
	bne.w	.gli					;no: keep
	move.w	#SPAgready,d1			;ready animation
.gli								;close to the door: glide (goalie: ready) and turn to face the bench
	bsr.w	SetSPA					;glide (goalie: ready) animation
	bset	#pfnc,pflags(a3)		;set pfnc
	cmpi.w	#4,facedir(a3)			;facing 4?
	beq.w	.ok						;yes: ok
	addq.w	#1,facedir(a3)			;turn toward the bench
	andi.w	#7,facedir(a3)			;keep 0 to 7
.ok									;facing the bench: slide left, at the door hop the boards (wall animation,
									;door flag 100)
	clr.w	Yvel(a3)				;y velocity 0
	move.w	#$F800,Xvel(a3)			;x velocity -$800
	cmp.w	#$10,d0					;x within $10?
	bgt.w	.x						;no: done
	clr.w	Xvel(a3)				;x velocity 0
	cmpi.w	#4,facedir(a3)			;facing 4?
	bne.w	.x						;no: done
	move.w	#$F800,Xvel(a3)			;x velocity -$800
	move.w	#2,facedir(a3)			;facing 2
	move.w	#SPAwallleft,d1			;wall animation
	bsr.w	SetSPA					;set it
	bset	#pfalock,pflags(a3)		;set pfalock
	move.w	#$64,temp1(a3)			;100
.x									;return; skating continues next call
	rts								;done
.done								;door flag 100: the wall animation is over, swap in the new player
	clr.w	frame(a3)				;at the bench door: mark this roster slot on the bench (tmpdst -2),
									;install the new player (d3)
	clr.w	d0						;d0 = 0
	move.b	pnum(a3),d0				;player number
	add.w	d0,d0					;times 2
	movea.l	#tmstruct,a0			;a0 = home team structure
	btst	#pfteam,pflags(a3)		;which team?
	beq.w	.t0						;home: keep
	adda.w	#tmsize,a0				;away team structure
.t0									;put him on the bench
	move.w	#$FFFE,tmpdst(a0,d0.w)	;tmpdst: put used player on bench
	move.b	newpnum(a3),d3			;new player number
	bsr.w	.nobench2				;take the position
	jmp	setplayer					;bring him in
.nodec								;not at the door yet: keep skating to temp3/temp4 (unless pfnc stops the
									;skating)
	btst	#pfnc,pflags(a3)		;pfnc set?
	bne.s	.x						;yes: done
	move.w	temp3(a3),d0			;target x
	move.w	temp4(a3),d1			;target y
	movea.l	#EvadePC,a0				;path evasion routine
	bra.w	skateto					;skate there
.nobench							;same player: just take the new position, no bench trip
	bclr	#pf2unav,pflags2(a3)	;clear pf2unav
.nobench2							;local subroutine
	move.b	newpos(a3),d0			;position = newpos; clear newpos and newpnum
	ext.w	d0						;word
	move.w	d0,position(a3)			;set the position
	jsr	(Setplass).l				;set the player attributes
	st	newpnum(a3)					;no new player number
	st	newpos(a3)					;no new position
rtss4								;shared rts for the early exits nearby
	rts
; player a3 should exit bench area
asseben								;Player a3 should exit the bench area
	btst	#pfalock,pflags(a3)		;locked (pfalock)?
	bne.s	rtss4					;yes: done
	bclr	#pfna,pflags(a3)		;clear pfna
	beq.w	.nna					;it was clear: skate out
	clr.w	Xvel(a3)				;x velocity 0
	clr.w	Yvel(a3)				;y velocity 0
	move.w	SCnum(a3),d0			;d0 = SCnum
	subq.w	#6,d0					;minus 6
	bmi.w	.0						;negative: home
	addq.w	#1,d0					;away: plus 1
.0									;d0 = bench seat: home SCnum - 6 (negative), away SCnum - 5
	muls.w	#$E,d0					;times $E
	move.w	d0,Ypos(a3)				;bench seat y
	move.w	#$88,(a3)				;x $88
	neg.w	(a3)					;negated
	move.w	#2,facedir(a3)			;facing 2
	bset	#pfalock,pflags(a3)		;set pfalock
	move.w	#SPAwallright,d1		;wall animation
	bra.w	SetSPA					;set it
.nna								;wall animation over: face the rink and skate out
	move.w	#4,facedir(a3)			;after the wall animation
	bclr	#pfnc,pflags(a3)		;clear pfnc
	bclr	#pf2npc,pflags2(a3)		;pf2npc
	bclr	#pf2unav,pflags2(a3)	;pf2unav
	clr.w	SPA(a3)					;animation 0
	move.w	#$1000,Xvel(a3)			;x velocity $1000
	bra.w	assexit					;exit
; player a3 should go to penalty box
asspenalty							;player a3 should goto penalty box
	btst	#pfalock,pflags(a3)
	bne.s	rtss4
	bclr	#pfna,pflags(a3)
	beq.w	.nna
	bset	#pf2unav,pflags2(a3)	;set player unavailable (pf2unav)
	bsr.w	.clrplayer
	moveq	#-2,d4					;move -2 into d4
	bsr.w	setpads					;moves player number into a temp value so graphics know who it is
	move.w	#8,temp2(a3)			;move 8 into temp2
	moveq	#$B,d0					;move 11 dec into d0
	move.b	(PBnum).w,d1			;gets number of players in PB. 00HV (H=Home, V=Visitors)
	btst	#pfteam,pflags(a3)		;checks if player is home or away
	bne.w	.0						;branch if away
	lsr.w	#4,d1					;shift 4 bits to get Home players in PB
	neg.w	d0						;make d0 negative (different box)
.0									;d0 = box side (-11 home, 11 away), d1 = that team's players in the box
	andi.w	#$F,d1					;pass the first 4 bits of d1 (the team's player total in PB)
	cmp.w	#2,d1					;compare to 2
	bls.w	.1						;branch if less than (1 player in box or less)
	moveq	#2,d1					;add 2 if more than 1 player in box
.1									;seat 3 to 5 by the number of players already in the box
	addq.w	#3,d1					;add 3 to d1
	muls.w	d0,d1					;mult d0 with d1, store result in d1
	move.w	d1,temp4(a3)			;move d1 into temp4 (skateto YPos)
	move.w	#$88,temp3(a3)			;move 136 decimal into temp3 (skateto XPos)
	clr.w	temp1(a3)				;clear temp1
	bset	#pf2npc,pflags2(a3)		;set bit for no player collision
	clr.w	Wallcos(a3)				;clear wallCos (angle of last collision)
	clr.w	Wallsin(a3)				;clear wallSin (angle of last collision)
.nna								;every call: at the box door turn and hop in, else skate on (.st)
	move.w	Ypos(a3),d0				;Current Ypos of player
	sub.w	temp4(a3),d0			;sub temp4 (Y pos to skate to) from Ypos
	cmp.w	#$C,d0					;compare to 13 decimal
	bgt.w	.st						;branch if greater than (still skateto)
	;If its within 13 decimal, it will start the animation for hopping over the board
	cmp.w	#$FFF4,d0
	blt.w	.st
	move.w	(a3),d0
	sub.w	temp3(a3),d0
	cmp.w	#$FFE8,d0
	blt.w	.st
	sub.w	d7,temp1(a3)
	bpl.w	rtss4
	addq.w	#8,temp1(a3)
	bset	#pfnc,pflags(a3)
	move.w	#SPAglide,d1
	bsr.w	SetSPA
	moveq	#6,d2
	tst.b	handed(a3)
	beq.w	.left
	moveq	#2,d2					;left handed: face 2 (right)
.left								;label name is 92G's; the branch is taken by right handed players
									;(handed 0), who keep d2 = 6 (face left); left handed set d2 = 2
									;turn one step a frame: right handed faces 6 (left, away
									;from the box), left handed 2 (right, toward the box).
									;Righty faces 6 (mirrored to frame dir 2), lefty faces 2:
									;both show the same glide frame, the righty x-flipped
	cmp.w	facedir(a3),d2			;turn one step toward d2
	beq.w	.ok
	addq.w	#1,facedir(a3)
	andi.w	#7,facedir(a3)
.ok									;slide into the box; when stopped and facing it, hop the boards and go to
									;assdopen
	clr.w	Yvel(a3)
	move.w	#$1000,Xvel(a3)
	cmp.w	#$FFF8,d0
	blt.w	rtss4
	clr.w	Xvel(a3)
	cmp.w	facedir(a3),d2
	bne.w	rtss4
	bset	#pfalock,pflags(a3)
	move.w	#2,facedir(a3)
	move.w	#SPAwallright,d1
	bsr.w	SetSPA
	bclr	#pf2pen,pflags2(a3)		;pf2pen
	move.l	#$D,d0					;assdopen
	bra.w	assreplace
.st									;not at the box yet: skate to temp3/temp4
	move.w	temp3(a3),d0
	move.w	temp4(a3),d1
	movea.l	#rtss2,a0
	bra.w	skateto
.clrplayer							;take the joystick off player a3
	btst	#pfjoycon,pflags(a3)
	beq.w	rtss4
	clr.w	d4
	move.w	SCnum(a3),d0
	cmp.w	(c1playernum).w,d0
	beq.w	changeplayer
	moveq	#2,d4
	bra.w	changeplayer
; add player a3 to penalty box
assdopen							;add player a3 to penalty box
	btst	#pfalock,pflags(a3)		;locked in (pfalock)?
	bne.w	rtss4					;yes: nothing to do
	moveq	#$10,d0					;d0 = $10
	btst	#pfteam,pflags(a3)		;which team?
	beq.w	.1						;home: keep $10
	moveq	#1,d0					;away: d0 = 1
.1									;into the box
	add.b	d0,(PBnum).w			;Players in penalty box
	st	position(a3)				;in the box
	clr.w	frame(a3)				;frame 0
	rts								;done
; player a3 should exit penalty area
assepen								;player a3 should exit penalty area
	btst	#pfalock,pflags(a3)		;locked (pfalock)?
	bne.w	rtss4					;yes: done
	bclr	#pfna,pflags(a3)		;clear pfna
	beq.w	.nna					;it was clear: skate out
	bset	#pfnc,pflags(a3)		;set player in no collision mode
	bset	#pf2unav,pflags2(a3)	;set player unavailable
	moveq	#$10,d0					;d0 = $10
	moveq	#$FFFFFFC4,d1			;d1 = -$3C
	btst	#pfteam,pflags(a3)		;which team?
	beq.w	.0						;home: keep
	moveq	#1,d0					;d0 = 1
	neg.w	d1						;negate d1
.0									;leave the box
	sub.b	d0,(PBnum).w			;Players in penalty box
	move.w	d1,Ypos(a3)				;y
	clr.w	Xvel(a3)				;x velocity 0
	clr.w	Yvel(a3)				;y velocity 0
	move.w	#$86,(a3)				;x $86
	move.w	#2,facedir(a3)			;facing 2
	bset	#pfalock,pflags(a3)		;set pfalock
	move.w	#SPAwallleft,d1			;wall animation
	bsr.w	SetSPA					;set it
	jmp	SprSort						;sort the sprites
.nna								;pfna was clear
	move.w	#4,facedir(a3)			;facing 4
	st	newpnum(a3)					;no new player number
	st	newpos(a3)					;no new position
	bclr	#pfjoycon,pflags(a3)	;clear pfjoycon
	bclr	#pfnc,pflags(a3)		;clear pfnc
	bclr	#pf2npc,pflags2(a3)		;pf2npc
	bclr	#pf2unav,pflags2(a3)	;pf2unav
	move.w	#$F000,Xvel(a3)			;x velocity -$1000
	bra.w	assexit					;exit
; moves the goalie not being used during shootout/pen shot off the screen
; a3 = goalie who is to be taken off ice
assgoaliebreakwait					;asstab entry. In a shootout or penalty shot park the idle goalie off the
									;ice, else exit
	btst	#pfalock,pflags(a3)		;check if animation locked
	bne.w	.exit					;exit if so
	btst	#2,(BA_PS_flags).w		;check if pen shot
	bne.w	.park					;branch if so
	btst	#0,(gmode2).w			;check for shootout
	bne.w	.park					;branch if so
	nop
	bra.w	assexit
.park								;bit 2 of BA_PS_flags set or bit 0 of gmode2 set
	clr.w	Xvel(a3)				;clear Xvel
	clr.w	Yvel(a3)				;clear Yvel
	movem.l	d0/a0,-(sp)				;push d0 and a0 on stack
	movea.l	#SortCords,a0			;Home SC Sctruct start
	move.w	(BA_Goalie_SCnum).w,d0	;move Goalie SCNum into d0
	asl.w	#7,d0					;shift d0 7 bits left
	adda.w	d0,a0					;add d0 to address a0
	move.w	#$191,Ypos(a3)			;move 401 decimal into Ypos
	btst	#7,pflags(a0)			;check if shooting up or down (a0 is goalie being shot on)
	bne.w	.popstack				;branch if shooting up
	move.w	#$FE6F,Ypos(a3)			;move -191 decimal into Ypos (goalie not being shot on)
.popstack							;pop the d0/a0 saved above
	movem.l	(sp)+,d0/a0
.exit								;exit (also the end of the code above)
	rts
; players do nothing until faceoff is over
assfaceoff							;players do nothing until faceoff is over
	btst	#pfalock,pflags(a3)
	bne.w	.exit
	btst	#sf2faceoff,(sflags2).w
	beq.w	assexit
.exit								;exit (also the end of the code above)
	rts
; assignment for players actually participating in faceoff
; a3 = player
assfaceoffpl						;Face off player
	btst	#pfalock,pflags(a3)		;locked (pfalock)?
	bne.w	.exit2					;yes: done
	btst	#sf2faceoff,(sflags2).w	;faceoff (sf2faceoff)?
	beq.w	.exit					;no: exit
	bclr	#pfna,pflags(a3)		;clear pfna
	beq.w	.nna					;it was clear: set the frame
	clr.w	temp1(a3)				;temp1 0
.nna								;every call: set the big faceoff sprite frame for this team
	movea.l	#fofdata2,a0			;a0 = fofdata2 (home) or +4 (visitor): big faceoff sprite data
	btst	#pfteam,pflags(a3)		;which team?
	beq.w	.0						;home: keep
	addq.w	#4,a0					;visitor entry
.0									;a0 = this team's big sprite entry (visitor +4)
	move.w	SPAnum(a3),d0			;d0 = SPAnum/4 + 1, +3 for right handed: frame code for the big sprite
	lsr.w	#2,d0					;divided by 4
	addq.w	#1,d0					;plus 1
	tst.b	handed(a3)				;left handed?
	bne.w	.lefty					;yes: keep
	addq.w	#3,d0					;plus 3
.lefty								;store the frame; computer players also start the faceoff stance once
	move.w	d0,(a0)					;store the frame
	btst	#pfjoycon,pflags(a3)	;human controlled?
	bne.w	.exit2					;yes: done
	bset	#pf2aip,pflags2(a3)		;set pf2aip
	bne.w	.exit2					;it was set: done
	move.w	#SPAfaceoff,d1			;d1 = faceoff animation
	cmpi.w	#$10,(SortCords+(puckscnum*SCstruct)+temp1).w	;puck temp1 above $10?
	bls.w	.d						;no: use it
	moveq	#8,d0					;range 8
	bsr.w	randomd0				;random value
	tst.w	d0						;zero?
	beq.w	.d						;yes: use it
	move.w	#SPAfaceoffr,d1			;alternate faceoff animation
.d									;one in 8 computer centers takes the alternate stance (SPAfaceoffr)
	bset	#pf2aip,pflags2(a3)		;set pf2aip
	bra.w	SetSPA					;set the animation
.exit								;shared exit of assfaceoffpl
	move.b	#$14,nopuck(a3)			;nopuck $14
	bra.w	assexit					;exit
.exit2								;exit
	rts								;done
assfight							;rts only: there is no fighting
	rts								;assfight - possible location where fighting logic used to be
assfwatch							;rts only: there is no fighting
	rts								;assfwatch - possible location where players watching fight
; player should do nothing
donothing							;player should do nothing
	btst	#pfalock,pflags(a3)		;#pfalock
	bne.s	assfwatch
	btst	#pfjoycon,pflags(a3)	;#pfjoycon
	bne.s	assfwatch
	moveq	#8,d0
	bra.w	doplayeracc
; player skates with stanley cup overhead
assstanley							;player a3 skates with stanley cup overhead
	btst	#pfalock,pflags(a3)		;locked (pfalock)?
	bne.s	assfwatch				;yes: watch
	bclr	#pfna,pflags(a3)		;clear pfna
	beq.w	.nna					;it was clear: skate
	move.w	#$5A,temp3(a3)			;90
	tst.w	(Hpos).w				;Hpos negative?
	bpl.w	.0						;no: keep
	neg.w	temp3(a3)				;negate temp3
.0									;target Y from Vpos
	move.w	(Vpos).w,temp4(a3)		;temp4 = y from Vpos
	move.w	#SPAstanley,d1			;stanley animation
	bsr.w	SetSPA					;set it
.nna								;skate toward the target
	move.w	temp3(a3),d0			;face and accelerate toward the target
	sub.w	(a3),d0					;minus x
	move.w	temp4(a3),d1			;d1 = temp4
	sub.w	Ypos(a3),d1				;minus y
	bsr.w	vtoa					;direction
	cmp.w	#7,d0					;beyond 7?
	bgt.s	assfwatch				;yes: watch
	move.w	d0,d2					;d2 = direction
	move.w	d2,facedir(a3)			;facing
	bra.w	playeracc				;accelerate
; player a3 celebrates, if scoreing player then do arm pump
assscore							;player a3 celebrates, if scoring player then do arm pump
	btst	#pfalock,pflags(a3)		;locked (pfalock)?
	bne.s	assfwatch				;yes: watch
	bclr	#pfna,pflags(a3)		;clear pfna
	beq.w	.nna					;it was clear: celebrate
	bsr.w	.1						;random time
	move.w	#8,temp2(a3)			;temp2 8
	move.w	#$5A,temp3(a3)			;temp3 $5A
	tst.w	(Hpos).w				;Hpos negative?
	bpl.w	.0						;no: keep
	neg.w	temp3(a3)				;negate temp3
.0									;temp4 = Vpos; celebrate where the camera is
	move.w	(Vpos).w,temp4(a3)		;temp4 = Vpos
.nna								;every call: in a shootout hold the skater until shootoutdelay runs out
	movea.l	#rtss2,a0				;a0 = rtss2
	move.w	temp3(a3),d0			;d0 = temp3
	move.w	temp4(a3),d1			;d1 = temp4
	btst	#0,(gmode2).w			;start of new code
	beq.w	.noso					;branch taken: skip
	tst.w	(shootoutdelay).w		;shootout delay zero?
	beq.w	.chkx					;yes: check x
	subq.w	#1,(shootoutdelay).w	;count it down
	bne.w	.chkx					;not zero: check x
	bset	#sf2drec,(sflags2).w	;set sf2drec
.chkx								;shootout: skater near the middle (x within -$88..$88) stays on the center
									;line
	cmpi.w	#$88,(a3)				;x beyond $88?
	bgt.w	.3						;yes: outside
	cmpi.w	#$FF78,(a3)				;x beyond -$88?
	bgt.w	.noso					;yes: celebrate
.3									;outside that band: y = 0
	clr.w	d1						;end of new code
.noso								;celebration timer: when it runs out start a new celebrate (pump for the
									;scorer)
	sub.w	d7,temp1(a3)			;count temp1 down by d7
	bpl.w	.ckcon					;still positive: continue
	bset	#pfalock,pflags(a3)		;set pfalock
	move.w	#SPAcelebrate,d1		;celebrate animation
	move.w	(shotplayer).w,d0		;d0 = shot player
	cmp.w	SCnum(a3),d0			;is it a3?
	bne.w	.nopump					;no: celebrate
	move.w	#SPApump,d1				;pump animation
.nopump								;shooter or not: set the animation and a new random time
	bsr.w	SetSPA					;set the animation
.1									;local subroutine
	moveq	#$78,d0					;120
	bsr.w	randomd0				;random value
	move.w	d0,temp1(a3)			;new time
	rts								;done
.ckcon								;timer still running: computer players skate to the spot
	btst	#pfjoycon,pflags(a3)	;human controlled?
	beq.w	skateto					;no: skate
rtss6								;shared rts for the early exits nearby
	rts
; player a3 is defensive player on offense
assdefo								;player a3 is defensive player on offense
	btst	#pfalock,pflags(a3)
	bne.s	rtss6
	btst	#gmclock,(gmode).w		;#gmclock
	bne.w	donothing				;Whistle blown, do nothing
	bsr.w	check4bench				;check if player should go to bench
	btst	#pfjoycon,pflags(a3)	;#pfjoycon - is player joystick controlled
	bne.s	rtss6					;yes, then exit
	bclr	#pfna,pflags(a3)		;#pfna - checks if theres a new assignment
	beq.w	.nna
	clr.w	temp1(a3)				;clears temp1 if new assignment
	move.w	#8,temp2(a3)			;moves 8 into temp2 if new assignment
.nna								;count down the timer
	sub.b	d7,temp1(a3)			;subtract frames elapsed since last call from temp1
	bpl.w	.nodec					;temp1 not zero or negative
	move.b	aioff(a3),temp1(a3)		;Loads aioff into temp1
	jsr	(ReadGoaliePulled).l
	bmi.w	.boost					;branch if goalie is pulled
	btst	#6,(sflags7).w			;check if crowd meter broken
	beq.w	.noboost				;branch if not
	tst.b	temp1(a3)				;check if temp1 is 0
	beq.w	.noboost				;branch if so
.boost								;goalie pulled, or crowd meter broken: temp1 one lower (probably a quicker
									;reaction)
	subq.b	#1,temp1(a3)			;sub 1 from temp1
.noboost							;switch to assdefd when offside, then pick the spot by the puck carrier
	move.l	#2,d0					;assdefd
	btst	#tmfoside,tmflags(a2)	;check if team is offsides
	bne.w	assreplace				;if so, assreplace
	move.w	(pucky).w,d1			;move pucky into d1
	btst	#pfgoal,pflags(a3)		;#pfgoal - check which net to score on
	bne.w	.de1					;branch if top
	neg.w	d1						;Negates d1- shooting on bottom net
.de1								;puck Y for his end
	cmp.w	#$5D,d1					;slightly above top blueline - checks Y position of puck
	blt.w	assreplace				;not in offensive zone, change assignment
	move.w	(puckc).w,d1			;puck carrier (SCnum) into d1
	bmi.w	.nodec					;branch if no puckc
	subq.w	#6,d1					;sub 6 from d1
	move.w	SCnum(a3),d2			;move SCnum into d2
	subq.w	#6,d2					;sub 6 from d2
	eor.w	d2,d1					;EOR d2 with d1
	bmi.w	assreplace				;ass replace if puckc not on same team
.nodec								;no carrier or our team has the puck: hold the blue line (x 80 to the side
									;of the position)
	lea	EvadePC(pc),a0				;EvadePC, extra collision routine for skateto
	moveq	#$50,d0					;move 80 dec into d0
	cmpi.w	#2,position(a3)			;position(a3) - checks that player is RD
	beq.w	.1						;branch if RD
	neg.w	d0						;player is LD, so negates d0
.1									;d0 = x for RD (+80) or LD (-80); d1 = just inside the blue line
	move.w	#$62,d1					;just inside of blueline
	btst	#pfgoal,pflags(a3)		;#pfgoal
	bne.w	.0						;branch if top net shooting
	neg.w	d0						;shooting on bottom net, so negate d0 and d1
	neg.w	d1
.0									;coordinates for his end
	move.w	(puckx).w,d2			;move puckx into d2
	eor.w	d0,d2					;XOR d0 with d2
	bmi.w	.2						;branch if puck on the other side of X center
	move.w	(puckx).w,d0			;move puckx to d0
	bra.w	skateto					;d0/d1 are x/y positions, a0 is extra collision routine
.2									;puck on our side of center: move half way toward it
	move.w	(puckx).w,d2			;move puckx into d2
	asr.w	#1,d2					;divide by 2
	add.w	d2,d0					;add d2 to d0
	bra.w	skateto					;skateto routine
; player a3 is defensive player on defense
assdefd								;player a3 is defensive player on defense
	btst	#pfalock,pflags(a3)		;check if locked in animiation
	bne.w	rtss6					;exit if so
	btst	#gmclock,(gmode).w		;check if clock running
	bne.w	donothing				;donothing if no clock
	bsr.w	check4bench				;check if going to bench
	btst	#pfjoycon,pflags(a3)	;check if joystick controlled
	bne.w	rtss6					;exit if so
	bclr	#pfna,pflags(a3)		;clear new assignment bit
	beq.w	.nna					;branch if no new assignment
	clr.w	temp1(a3)				;clear temp1
	move.w	#8,temp2(a3)			;move 8 into temp2
.nna								;count down the timer
	sub.b	d7,temp1(a3)			;sub frames elapsed from temp1
	bpl.w	.nodec					;branch if not 0
	move.b	aidef(a3),temp1(a3)		;move DfA into temp1
	btst	#6,(sflags7).w			;check if crowd meter currently broken
	beq.w	.noboost				;branch if not
	tst.b	temp1(a3)				;check if temp1 is 0
	beq.w	.noboost				;branch if so
	subq.b	#1,temp1(a3)			;sub 1 from temp1
.noboost							;defenseman: shadow the puck, using its y velocity to lead it
	move.w	(pucky).w,d1			;move pucky into d1
	move.w	(puckvy).w,d3			;move puckvy into d3
	asr.w	#6,d3					;divide by 64
	btst	#pfgoal,pflags(a3)		;check which net shooting on
	bne.w	.de00					;branch if top
	neg.w	d1						;negate d1 and d3 if bottom
	neg.w	d3
.de00								;puck Y for his end
	tst.w	d3						;check if d3 is zero
	bpl.w	.de000					;branch if positive
	clr.w	d3						;clear d3
.de000								;look-ahead at least 0
	add.w	d1,d3					;add d1 to d3
	cmp.w	#Blueline,d3			;compare top blueline to d3
	blt.w	.de0
	btst	#tmfoside,tmflags(a2)	;check if team is offsides
	bne.w	.de0					;branch if offsides
	move.w	(puckc).w,d1			;move puckc into d1
	bmi.w	.de0					;branch if no puckc
	bsr.w	chkpk					;check if theres a PK
	beq.w	.de0					;branch if on PK
	move.l	#1,d0					;assdefo into d0
	subq.w	#6,d1					;sub 6 from d1
	move.w	SCnum(a3),d2			;move SCnum into d2
	subq.w	#6,d2					;sub 6 from d2
	eor.w	d2,d1					;EOR d2 and d1
	bpl.w	assreplace				;assreplace if puckc on same team
.de0								;other team has the puck: guard x 65 to our side
	move.w	#$41,temp3(a3)			;move 65 dec into temp3
	cmpi.w	#2,position(a3)			;compare if player is RD
	beq.w	.de1					;branch if RD
	neg.w	temp3(a3)				;negate temp3 if LD
.de1								;a0 = the opposing team's players (home 0-5, away 6-11)
	movea.w	#(SortCords-M68K_RAM),a0	;move SC struct start into a0
	cmpi.w	#6,SCnum(a3)			;compare 6 with player SCnum
	bge.w	.de2					;branch if away team
	adda.w	#6*SCstruct,a0			;add 300 to a0 (start at away SC Struct)
.de2								;find the deepest opponent (d2 = 5..0, start d0 = -1000 or 1000)
	moveq	#5,d2					;move 5 into d2
	move.w	#$FC18,d0				;move -1000 dec into d0
	btst	#pfgoal,pflags(a3)		;check what net shooting at
	beq.w	.gdwn					;branch if bottom net
	neg.w	d0						;negate d0
.gup								;d0 = the smallest opponent y (led by Yvel / 16) when we shoot at the top
									;net
	btst	#pf2unav,pflags2(a0)	;check if a0 player unavailable
	bne.w	.gu0					;branch if so
	tst.w	position(a0)			;check a0 position
	bmi.w	.gu0					;branch if empty position
	move.w	Yvel(a0),d1				;move Yvel of a0 into d1
	bmi.w	.gu2					;branch if Yvel was negative
	clr.w	d1						;clear d1
.gu2								;look-ahead Y (back only)
	asr.w	#4,d1					;divide d1 by 16
	add.w	Ypos(a0),d1				;add Ypos of a0 player to d1
	cmp.w	d0,d1					;compare d0 to d1
	bgt.w	.gu0					;branch if d1 is greater
	move.w	d1,d0					;move d1 into d0
.gu0								;next opponent
	adda.w	#SCstruct,a0			;add 80 (offset to next player struct) to a0
	dbf	d2,.gup						;loop
	subi.w	#$32,d0					;sub $32 (50 dec) from d0
	cmp.w	#$FF42,d0				;compare to $FF42 (-190 dec)
	bgt.w	.gu1					;branch if greater than
	move.w	#$FF24,d0				;move -220 dec into d0
.gu1								;temp4 = guard y; if the puck is across center, stay in the middle (x 0)
	move.w	d0,temp4(a3)			;move d0 into temp4
	move.w	(puckx).w,d0			;move puckx into d0
	move.w	temp3(a3),d1			;move temp3 into d1
	eor.w	d0,d1					;EOR d0 and d1
	bpl.w	.nodec					;branch if puck on same side
	clr.w	temp3(a3)				;clear temp3 if not
	bra.w	.nodec
.gdwn								;pfgoal clear
	btst	#pf2unav,pflags2(a0)	;check if player a0 unavail
	bne.w	.gd0					;branch if so
	tst.w	position(a0)			;check a0 position
	bmi.w	.gd0					;branch if empty (goalie)
	move.w	Yvel(a0),d1				;move Yvel of a0 into d1
	bpl.w	.gd2					;branch if positive
	clr.w	d1						;clear d1
.gd2								;look-ahead Y (forward only)
	asr.w	#4,d1					;divide d1 by 16
	add.w	Ypos(a0),d1				;add Ypos of a0 to d1
	cmp.w	d0,d1					;compare d0 to d1
	blt.w	.gd0					;branch if less than d0
	move.w	d1,d0					;move d1 into d0
.gd0								;next opponent (bottom net: d0 = the largest y)
	adda.w	#SCstruct,a0			;add offset to next player struct
	dbf	d2,.gdwn					;loop
	addi.w	#$32,d0					;add 32 to d0
	cmp.w	#$BE,d0					;compare 190 dec to d0
	blt.w	.gd1					;branch if d0 less than
	move.w	#$DC,d0					;move 220 dec into d0
.gd1								;target Y clamped
	move.w	d0,temp4(a3)			;move d0 into temp4
	neg.w	temp3(a3)				;negate temp3
	move.w	(puckx).w,d0			;move puckx into d0
	move.w	temp3(a3),d1			;move temp3 into d1
	eor.w	d0,d1					;EOR d0 and d1
	bpl.w	.nodec					;branch if puck on same side
	clr.w	temp3(a3)				;clear temp3 if not
.nodec								;skate to the guard spot with collision avoidance, then try a check
	move.w	temp3(a3),d0			;move temp3 to d0
	move.w	temp4(a3),d1			;move temp4 to d1
	movea.l	#EvadePC,a0				;EvadePC to a0
	bsr.w	skateto
	bra.w	check4check
rtss21								;shared rts for the early exits nearby
	rts
; player a3 is winger on defense
asswingd							;player a3 is wing on defense
	btst	#pfalock,pflags(a3)		;check if locked in animation
	bne.s	rtss21					;exit if so
	btst	#gmclock,(gmode).w		;check if clock is running
	bne.w	donothing				;donothing if its stopped
	bsr.w	check4bench				;check if going to bench
	btst	#pfjoycon,pflags(a3)	;check if joystick controlled
	bne.s	rtss21					;exit if so
	bclr	#pfna,pflags(a3)		;clear new assignment bit
	beq.w	.nna					;branch if cleared already (no new assignment)
	clr.w	temp1(a3)				;clear temp1
	move.w	#8,temp2(a3)			;move 8 into temp2
.nna								;count down the timer
	sub.b	d7,temp1(a3)			;sub frames elapsed from temp1
	bpl.w	.nodec					;branch if not 0
	move.b	aidef(a3),temp1(a3)		;move DfA into temp1
	btst	#6,(sflags7).w			;check if crowd meter currently broken
	beq.w	.noboost				;branch if not
	tst.b	temp1(a3)				;check if temp1 is 0
	beq.w	.noboost				;branch if 0
	subq.b	#1,temp1(a3)			;sub 1 from temp1
.noboost							;if our team has the puck, switch to asswingo
	move.w	(puckc).w,d1			;move puckc into d1
	bmi.w	.nodec					;branch if no puck carrier
	move.l	#4,d0					;asswingo into d0
	subq.w	#6,d1					;sub 6 from d1
	move.w	SCnum(a3),d2			;move SCnum into d2
	subq.w	#6,d2					;sub 6 from d2
	eor.w	d2,d1					;EOR d2 with d1. Checks if player on same team
	bpl.w	assreplace				;branch if team has puck
.nodec								;defending: x 100 to the wing side, y below our blue line
	moveq	#$64,d0					;move 64 (100 dec) into d0
	cmpi.w	#5,position(a3)			;check if player is RW
	bne.w	.1						;branch if not
	neg.w	d0						;make d0 negative
.1									;d1 = blue line + 70 for the side we defend
	move.l	#$9E,d1					;move $9E into d1 (blueline + 70 dec)
	btst	#pfgoal,pflags(a3)		;check which goal shooting at
	beq.w	.0						;branch if bottom goal
	neg.w	d0						;negate d0
	neg.w	d1						;negate d1
	moveq	#$FFFFFFB2,d2			;move into d2 (slightly above bottom blue line)
	btst	#tmfoside,tmflags(a2)	;currently offside (tmfoside of the team's tmflags)
									;the home team's (tmstruct) or the away team's
									;(awtmstruct) flags word
	bne.w	.dg11					;branch if set
	cmp.w	(pucky).w,d2			;compare pucky to d2
	bgt.w	.ug1					;branch if puck in defensive zone
	move.w	(pucky).w,d1			;move pucky into d1
	bra.w	.z1
.ug1								;d2 > pucky
	move.w	#$FEF8,d2				;move bottom goal line into d2
	cmp.w	(pucky).w,d2			;compare pucky to d2
	blt.w	.z1						;branch if puck in defensive zone
	move.w	d2,d1					;move d2 into d1 if puck behind goal line
	bra.w	.z1
.0									;pfgoal clear
	moveq	#$4E,d2					;defending top goal
									;4E - slightly below top blue line
	btst	#tmfoside,tmflags(a2)	;currently offside (tmfoside of the team's tmflags)
									;the home team's (tmstruct) or the away team's
									;(awtmstruct) flags word
	bne.w	.dg11					;branch if set
	cmp.w	(pucky).w,d2			;compare pucky to d2
	blt.w	.dg1					;branch if puck in defensive zone
	move.w	(pucky).w,d1			;move pucky into d1
	bra.w	.z1
.dg1								;d2 < pucky
	move.w	#$108,d2				;move top goal line into d2
	cmp.w	(pucky).w,d2			;compare pucky to d2
	bgt.w	.z1						;branch if puck in between goal line and blue line
.dg11								;clamp to the goal line
	move.w	d2,d1					;move d2 into d1 if puck behind goal line
.z1									;puck on the other side of center: hold x; else follow the puck x
	lea	rtss21(pc),a0
	move.w	(puckx).w,d2			;move puckx into d2
	eor.w	d0,d2					;EOR d0 and d2
	bmi.w	skateto					;branch if minus - skate to d0/d1, no extra routine
	move.w	(puckx).w,d0			;move puckx into d0
	bra.w	skateto					;skate to d0/d1 no extra routine
; player a3 is winger on offense
