;	Collisions. This file bounces players off the walls and each other, runs body checks, holds
;	and hooks, and decides when a player falls or is hurt.


;Sort struct (SortCords, SCstruct each): the fields are named in ram94.asm.

checkcoll							;d2 = new x coord, d3 = new y coord, a3 = struct of object. Check wall
									;collision (around the hot spot and the end of the stick) and player
									;collisions, then move a3 in the OOlist sort order by its y. If a player
									;collision set collflag, restore the old x/y instead. Called from
									;updateplayers
	clr.w	(collflag).w
	btst	#sfhor,(sflags).w		;check if in horiz mode
	beq.w	.nhor1					;branch if not horizontal
	exg	d2,d3
.nhor1								;no collision mode?
	btst	#pfnc,pflags(a3)		;check if in no collision mode
	bne.w	.ex						;branch if no collision
	movem.l	d0-d7,-(sp)
	move.w	(a3),d2					;Xpos
	move.w	Ypos(a3),d3				;Ypos - check coll around hot spot with wall
	move.w	radiusx(a3),(wcradiusx).w	;wall coll radius X
	move.w	radiusy(a3),(wcradiusy).w	;wall coll radius Y
	bsr.w	checkwallcoll
	move.w	Wallcos(a3),d0
	or.w	Wallsin(a3),d0
	bne.w	.xx						;coll didnt happen
	cmpi.w	#$B,SCnum(a3)			;check if a3 is a player
	bgt.w	.xx						;branch if not a player
	movem.l	(sp),d0-d7
	move.l	a3,-(sp)
	bsr.w	GetHot
	move.w	(a3),d2					;Xpos
	move.w	Ypos(a3),d3
	add.w	d0,d2
	add.w	d1,d3					;check coll around end of stick with wall
	move.w	#1,(wcradiusx).w
	move.w	#1,(wcradiusy).w
	bsr.w	checkwallcoll
.xx									;pop the d0-d7 saved above
	movem.l	(sp)+,d0-d7
	bsr.w	checkplcoll				;check coll with other players
.ex									;check the sprite order
	tst.w	(collflag).w			;now check order of sprites
	bne.w	.restoreold
	move.w	SCnum(a3),d0
	asl.w	#1,d0					;current object number
	movea.w	#(OOlistpos-M68K_RAM),a0
	movea.w	#(OOlist-M68K_RAM),a1
	movea.w	#(Ylist-M68K_RAM),a2
	move.w	0(a0,d0.w),d1			;current objects pos in OOlist
.2									;loop
	cmp.w	#$F,d1					;Sortobjs-1
	beq.w	.cl2					;is it top sprite on screen
	clr.w	d4
	move.b	1(a1,d1.w),d4			;next higher object number
	cmp.w	0(a2,d4.w),d3			;YPos of next higher object
	ble.w	.cl2
	addq.w	#1,0(a0,d0.w)
	subq.w	#1,0(a0,d4.w)
	move.b	d4,0(a1,d1.w)			;next higher object into this entry
	move.b	d0,1(a1,d1.w)			;this object into the next entry
	addq.w	#1,d1
	bra.s	.2
.cl2								;moved up past every higher object: now try moving down
	move.w	0(a0,d0.w),d1			;current objects pos in OOlist
	beq.w	.ex2
.3									;loop
	clr.w	d4
	move.b	-1(a1,d1.w),d4			;next lower object number
	cmp.w	0(a2,d4.w),d3			;compare to Y pos of next lower object
	bge.w	.ex2
	subq.w	#1,0(a0,d0.w)
	addq.w	#1,0(a0,d4.w)
	move.b	d4,0(a1,d1.w)			;next lower object into this entry
	move.b	d0,-1(a1,d1.w)			;this object into the previous entry
	subq.w	#1,d1
	bne.s	.3
.ex2								;sorted: store the new y in Ylist
	move.w	d3,0(a2,d0.w)			;update Ylist
	rts
.restoreold							;collflag <> 0
	move.w	OldXpos(a3),(a3)		;move OldXpos into Xpos
	move.w	OldYpos(a3),Ypos(a3)	;move OldYpos into Ypos
	rts
checkplcoll							;check collision with other players. d2/d3 = x/y cords, a3 = struct. Walk
									;up and down the OOlist from a3 and call checkcx for each object within
									;$10 in y. Called from checkcoll
	btst	#pf2npc,pflags2(a3)		;no player collision?
	bne.w	.ex
	cmpi.w	#$B,SCnum(a3)
	bgt.w	.ex
	move.w	SCnum(a3),d0
	asl.w	#1,d0					;current object number
	movea.w	#(OOlistpos-M68K_RAM),a0
	movea.w	#(OOlist-M68K_RAM),a1
	movea.w	#(Ylist-M68K_RAM),a2
	move.w	0(a0,d0.w),d1			;current objects pos in OOlist
.0									;loop
	cmp.w	#$F,d1					;#sortobjs-1
	beq.w	.cl						;it is top sprite on screen
	clr.w	d4
	move.b	1(a1,d1.w),d4			;next higher object number
	move.w	0(a2,d4.w),d5			;y pos of next higher object
	sub.w	d3,d5
	cmp.w	#collrad*2,d5
	bgt.w	.cl						;no higher sprite coll
	bsr.w	checkcx
	addq.w	#1,d1
	bra.s	.0
.cl									;d1 = $F or d5 > #collrad*2
	move.w	0(a0,d0.w),d1
	beq.w	.ex
.1									;loop
	clr.w	d4						;loop: lower neighbours
	move.b	-1(a1,d1.w),d4			;next lower object number
	move.w	d3,d5
	sub.w	0(a2,d4.w),d5			;y pos of next lower object
	cmp.w	#collrad*2,d5
	bgt.w	.ex
	bsr.w	checkcx
	subq.w	#1,d1
	bne.s	.1
.ex									;exit (also the end of the code above)
	rts
checkcx								;d4 = obj. # * 2 for possible collision so check x range and distance for
									;collision. d2 = x, d5 = delta y, a3 = moving object. Opposing players add
									;impact and run newcheck, checkint, checkcheck and checkfight (an rts);
									;then momentum moves from a3 to a2. Called from checkplcoll
	movem.l	d0-d7/a0-a3,-(sp)
	asl.w	#6,d4					;6 = scsize-1
	movea.l	#SortCords,a2			;start of the player sort objects
	adda.w	d4,a2					;add d4 to a2. a2 now address of SCStruct-1
	btst	#pfnc,pflags(a2)		;test pfnc pflags = no collision mode
	bne.w	.exit					;object has no collision mode on
	btst	#pf2npc,pflags2(a2)		;pf2npc(pflags2) = another no collision mode
	bne.w	.exit					;exit if no collision mode on
	cmpi.w	#$B,SCnum(a2)			;comparing 11 with SCnum for player. Player SCnum are 0-11.
	bgt.w	.exit
	move.w	(a2),d0					;Xpos
	btst	#sfhor,(sflags).w		;sfhor(sflags) = screen in horizontal mode
	beq.w	.nhor					;branch if not in horiz mode
	move.w	Ypos(a2),d0
.nhor								;delta to the other player
	sub.w	d2,d0					;subtract d2 from d0
	cmp.w	#-collrad*2,d0			;compare delta Xpos to -collrad*2
	blt.w	.exit					;branch if less than
	cmp.w	#collrad*2,d0			;compare delta Xpos to collrad*2
	bgt.w	.exit					;branch if greater than
	muls.w	d5,d5
	muls.w	d0,d0
	add.l	d5,d0
	cmp.l	#(collrad*2)*(collrad*2),d0	;compare d0 to (collrad*2)*(collrad*2)
	bgt.w	.exit					;branch if outside of radius
	move.w	#0,(evalue).w			;evalue = elasticity value
	move.b	pflags(a3),d6			;move pflags into d6
	move.b	pflags(a2),d0			;move pflags into d0
	eor.b	d0,d6					;xor d0 with d6
	move.w	Xvel(a3),d0				;Now do momentum transfer from object a3 to object a2 Xvel
	sub.w	Xvel(a2),d0				;subtract Xvel a2 from Xvel a3 (Vx)
	move.w	Yvel(a3),d1
	sub.w	Yvel(a2),d1				;subtract Yvel a2 from Yvel a3 (Vy)
	move.w	(a3),d2					;Xpos
	sub.w	(a2),d2					;subtract Xpos of a2 from Xpos of a3
	neg.w	d2
	move.w	Ypos(a3),d3
	sub.w	Ypos(a2),d3				;subtract Ypos of a2 from Ypos of a3
	neg.w	d3
	movem.w	d0-d1,-(sp)
	muls.w	d3,d1
	muls.w	d2,d0
	add.l	d0,d1
	bmi.w	.exit4					;no collision if v1n < 0
	asr.l	#4,d1
	btst	#pfteam,d6
	beq.w	.not					;players are on same team
	move.w	d1,d4
	lsr.w	#8,d4
	cmp.w	#5,d4
	bgt.w	.g40
	moveq	#5,d4					;minimum impact value
.g40								;add the impact
	add.w	d4,impact(a3)
	add.w	d4,impact(a2)
	btst	#pf2fight,pflags2(a2)
	bne.w	.if
	move.w	SCnum(a3),impactp(a2)	;SCnum(a3), impactp(a2) = moves a3 SCnum into past impact player for a2
.if									;a2 impactp set
	btst	#pf2fight,pflags2(a3)
	bne.w	.if2
	move.w	SCnum(a2),impactp(a3)	;SCnum(a2), impactp(a3) = moves a2 SCnum into past impact player for a3
.if2								;impact recorded
	cmp.w	#$14,d4					;impact under 20: no check sound
	blt.w	.n1
	move.w	(puckc).w,d0			;check sound only if one of them has the puck
	cmp.w	SCnum(a3),d0
	beq.w	.nc
	cmp.w	SCnum(a2),d0
	bne.w	.n1
.nc									;a puck carrier is involved: play a check sound
	bsr.w	newcheck
.n1									;then the interference, check and fight tests
	bsr.w	checkint				;interference, check and fight tests
	bsr.w	checkcheck
	bsr.w	checkfight
.not								;no check: bounce
	move.w	d1,d4
	movem.w	(sp)+,d0-d1
	tst.w	(collflag).w			;set to -1 by holdcheck / Bcheck: no transfer
	bmi.w	.exit
	muls.w	d2,d1
	muls.w	d3,d0
	sub.l	d1,d0
	asr.l	#4,d0
	move.w	d0,d5
	clr.w	d0
	move.b	weight(a3),d0			;wgt, m1 in calc below
	addi.w	#$8C,d0
	clr.w	d1
	move.b	weight(a2),d1			;wgt, m2 in calc below
	addi.w	#$8C,d1
	move.w	(evalue).w,d7
	mulu.w	d1,d7
	lsr.w	#4,d7
	add.w	d0,d1
	sub.w	d7,d0
	muls.w	d4,d0
	divs.w	d1,d0
	move.w	(evalue).w,d1
	muls.w	d4,d1
	asr.w	#4,d1
	add.w	d0,d1
	movem.w	d2-d3,-(sp)
	muls.w	d5,d3
	muls.w	d0,d2
	add.l	d2,d3
	asr.l	#4,d3
	add.w	Xvel(a2),d3
	move.w	d3,Xvel(a3)
	movem.w	(sp),d2-d3
	muls.w	d5,d2
	muls.w	d0,d3
	sub.l	d2,d3
	asr.l	#4,d3
	add.w	Yvel(a2),d3
	move.w	d3,Yvel(a3)
	movem.w	(sp)+,d2-d3				;Pop d2 and d3 off stack
	muls.w	d1,d2
	asr.l	#4,d2
	add.w	d2,Xvel(a2)
	muls.w	d1,d3
	asr.l	#4,d3
	add.w	d3,Yvel(a2)
	st	(collflag).w
.exit								;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a3
	rts
.exit4								;d1 negative
	addq.w	#4,sp
	bra.s	.exit
newcheck							;start a new check sound: one of 4 sounds $1C-$1F, never the last one
									;again. Called from checkcx; FallDown branches here when the player who
									;fell did not have the puck
	move.l	d0,-(sp)
	moveq	#3,d0
	bsr.w	randomd0
	addq.w	#1,d0					;1-3 sounds on from the last one
	add.w	(ltack).w,d0
	andi.w	#3,d0
	move.w	d0,(ltack).w
	addi.w	#SFXcheck,d0			;first check sound (92 used 18)
	move.w	d0,-(sp)
	bsr.w	sfx
	move.l	(sp)+,d0
	rts
checkint							;check for interference penalty. player a2 interferes with a3 or
									;vice-versa; goalie is only player who can cause an interference call.
									;Called from checkcx
	move.l	d0,-(sp)
	bsr.w	.ci
	exg	a2,a3
	bsr.w	.ci
	exg	a2,a3
	move.l	(sp)+,d0
	rts
.ci									;a2 = goalie, a3 = player interfering with goalie. a3 falls. The
									;interference penalty ($22) needs a3
									;in the crease area (y $EF-$10A toward a2's goal, x within $14), a CPU
									;player or a pad player's joystick player, and randomd0($28 - aggres) <= 4
									;(($14 - byte $73) <= 2)
	tst.w	position(a2)
	bne.w	rtss2					;exits if not goalie
	btst	#gmclock,(gmode).w		;test gmclock(gmode). Is there play
	bne.w	rtss2					;no fall downs during celebration
	move.w	(puckc).w,d0			;Puck carrier's SCnum
	cmp.w	SCnum(a3),d0			;SCnum of this struct
	beq.w	.minimpact				;jump if a3 carrying puck
	cmpi.w	#$19,impact(a3)			;compare $19 to impact
	ble.w	rtss2					;exit if less than or equal
.minimpact							;a3 has the puck, or a hard enough hit: knock a2 down if the impact is
									;over 2
	cmpi.w	#2,impact(a3)			;compare 2 to impact
	ble.w	rtss2					;exit if impact is less than 2
	exg	a2,a3
	bsr.w	FallDown
	exg	a2,a3
	cmpi.w	#$1E,impact(a2)			;compare 30 decimal to impact
	ble.w	rtss2					;exit if impact is less than 30 decimal
	btst	#pf2pen,pflags2(a3)		;pf2pen(pflags2) - Check if player already committed a penalty
	bne.w	rtss2					;exit if player is already penalized
	tst.w	position(a2)
	bne.w	rtss2					;double check to make sure player is goalie
	move.w	#1,d0					;set d0 to team1 value
	btst	#pfteam,pflags(a3)		;check if home or away
	beq.w	.control				;jump if home (team1)
	move.w	#2,d0					;set d0 to team2 value
.control							;team's pad
	cmp.w	(cont1team).w,d0		;cont1team: 0= none, 1=team1, 2=team2
	beq.w	.playercont				;branch if on player 1's team
	cmp.w	(cont2team).w,d0		;check if on player 2's team
	bne.w	.checky					;branch if controlled by CPU
.playercont							;only a pad-controlled goalie
	btst	#pfjoycon,pflags(a3)	;pfjoycon - check if player controlled
	beq.w	rtss2					;exit if not player controlled
.checky								;check the Y
	move.w	Ypos(a2),d0
	btst	#pfgoal,pflags(a2)		;pfgoal - 0 shooting bottom, 1 shooting top
	beq.w	.checkcrease
	neg.w	d0						;negative d0 if shooting bottom
.checkcrease						;in the crease?
	cmp.w	#$EF,d0					;compare to Ypos. Looks like it compares to both ends of crease
	blt.w	rtss2
	cmp.w	#$10A,d0
	bgt.w	rtss2
	move.w	(a2),d0					;Xpos
	cmp.w	#$14,d0					;compare Xpos to goalpost
	bgt.w	rtss2
	cmp.w	#$FFEC,d0				;compare Xpos to goalpost
	blt.w	rtss2
	move.w	#$28,d0
	sub.b	aggress(a3),d0
	bsr.w	randomd0
	cmp.w	#4,d0					;d0 = RNG(28-aggres)
	bhi.w	rtss2
	btst	#gmhl,(gmode).w			;Check if highlight, exit if so
	bne.w	rtss2
	move.l	#$22,d0					;Interference Penalty
	bra.w	AddPenalty
checkcheck							;player is in contact: look for various contact events. Runs CCStart for
									;a3 on a2, then for a2 on a3. d4 = impact. Called from checkcx
	movem.l	d0-d4/a0-a3,-(sp)
	bsr.w	CCStart
	exg	a2,a3
	bsr.w	CCStart
	movem.l	(sp)+,d0-d4/a0-a3
	rts
CCStart								;Player a3 is checking player a2. Holds (SPAHold, SPAhook) go to
									;holdcheck, SPAsweepchk to Bcheck; otherwise
									;only a3 in SPAburst checks. Sets a3's check anim from checkinglist; a big
									;enough hit on a skater makes a2 fall, with a charging ($16 / $18) or
									;roughing ($1A / $1C) roll from checkagr. The hit uses wallcollduringcheck
									;and half the Chk rating, and each penalty goes through PenShotChk
	cmpi.w	#SPAHold,SPA(a2)
	beq.w	holdcheck
	cmpi.w	#SPAhook,SPA(a2)		;this anim also holds
	beq.w	holdcheck
	cmpi.w	#SPAsweepchk,SPA(a2)	;this anim goes to Bcheck
	beq.w	Bcheck
	cmpi.w	#SPAburst,SPA(a3)
	bne.w	rtss2
	btst	#gmclock,(gmode).w		;gmclock: increased fight chance after clock stops
	beq.w	.nofight
	move.w	#$100,impact(a3)
	move.w	#$100,impact(a2)
.nofight							;pick the check animation
	move.w	(a2),d0					;sprite to use during checking. Xpos a2
	sub.w	(a3),d0					;Xpos a3
	move.w	Ypos(a2),d1
	sub.w	Ypos(a3),d1
	bsr.w	vtoa
	sub.w	facedir(a3),d0
	andi.w	#7,d0
	btst	#3,attribute(a3)		;check attribute xflip?
	beq.w	.0
	neg.w	d0
	addq.w	#8,d0
	andi.w	#7,d0
.0									;d0 = direction from a3 to a2, mirrored for flipped sprites: pick the
									;check animation
	asl.w	#1,d0					;Sets the sprite animation
	lea	checkinglist(pc),a0			;loads address of check list into a0
	move.w	0(a0,d0.w),d1			;moves check anim. value into d1, based on d0 offset
	bset	#pfalock,pflags(a3)		;pfalock - lock until animation done
	bsr.w	SetSPA
	tst.w	position(a2)			;check if a2 is goalie
	beq.w	rtss2
	cmp.w	#$14,d4					;d4 = impact value
	blt.w	rtss2
	moveq	#$78,d0					;uses 60 decimal, this is 120 decimal (most likely due to change in
									;attribute math)
	btst	#pfjoycon,pflags(a3)	;checks if player a3 is player controlled
	beq.w	.CheckingCalc
.PlayerControlled					;(entry point inside CCStart). Changes d0 from 120 to 240 changes d0 from
									;120 to 240
	asl.w	#1,d0
.CheckingCalc						;(a label inside CCStart)
	sub.b	weight(a3),d0			;subtract wgt of a3 player from d0. a3 is player checking.
	add.b	weight(a2),d0			;add wgt of a2 player to d0
	lsr.w	#1,d0					;shift d0 1 right word length (divide by 2)
	exg	a2,a3						;swap addresses in a2 and a3 registers
	jsr	(wallcollduringcheck).l
	exg	a2,a3
	sub.w	impact(a2),d0			;subtract impact value of player getting checked (a2)
	beq.w	.down
	bmi.w	.down					;If result was neg., branch
	btst	#pf3wall,pflags3(a3)
	bne.w	.down					;branch if bit set
	bsr.w	randomd0				;d0 is the RNG range.
									;Result will be in d0 (0 <= d0 < range)
	clr.w	(TempWord1).w
	move.b	checking(a3),(TempWord1+1).w	;$75 is Chk attrib. in player struct
	lsr.w	(TempWord1).w			;Shift right 1 bit
	cmp.b	(TempWord1+1).w,d0		;d0 - Chk rating / 2
	ble.w	.down					;branch if d0 is not more
	bsr.w	checkagr
	cmp.w	#4,d0
	bhi.w	rtss2
	btst	#gmhl,(gmode).w			;checks if highlight
	bne.w	rtss2
	move.b	(HVcount).l,d0
	andi.w	#2,d0
	addi.w	#PenCharging,d0
	jsr	(PenShotChk).l				;penalty shot on a breakaway
	bra.w	AddPenalty
.down								;not a hold: check the aggression roll for a charging penalty
	bsr.w	checkagr
	cmp.w	#3,d0
	bhi.w	.dn2
	btst	#gmhl,(gmode).w			;checks if highlight
	bne.w	.dn2
	move.b	(HVcount).l,d0
	andi.w	#2,d0
	addi.w	#PenRoughing,d0
	jsr	(PenShotChk).l				;penalty shot on a breakaway
	bsr.w	AddPenalty
.dn2								;fall down
	bra.w	FallDown
checkinglist						;Check anim by direction from a3 to a2, SPA offsets
	dc.w	SPAshoulderchkl
	dc.w	SPAshoulderchkr
	dc.w	SPAhipchkr
	dc.w	SPAhipchkr
	dc.w	SPAhipchkr
	dc.w	SPAhipchkl
	dc.w	SPAhipchkl
	dc.w	SPAshoulderchkl
checkagr							;use Agression attribute and RNG to determine if there will be a penalty.
									;a3 = checking player, a2 = player being checked. d0 =
									;randomd0(((40 - Agr) / 2) * 13), doubled for a joystick player, halved
									;within $28 of the puck in x and y.
									;Then: a2 on a breakaway rolls randomd0 again, of 8 / 7 / 4 / 3 by a2's
									;distance in y from the goal line; and d0 = $7F (no penalty) while the
									;other team has a delayed penalty (DelayedPen). The callers call a penalty
									;when d0 is small. Called from CCStart, holdcheck and Bcheck
	move.w	#$28,d0					;Start calculation with 40 decimal (28 hex)
	sub.b	aggress(a3),d0			;Agr(a3) - subtract Agr from d0
	lsr.b	#1,d0					;divide result by 2
	mulu.w	#$D,d0					;multiply d0 with 13 decimal
	btst	#pfjoycon,pflags(a3)	;test if player controlled
	beq.w	.checkpos				;branch if CPU player
	asl.w	#1,d0
.checkpos							;check the position
	move.w	(a3),d1
	sub.w	(puckx).w,d1			;subtract x pos of puck with X pos of player
	cmp.w	#$28,d1					;Checking position with respect to puck
	bgt.w	.random					;if d1 is greater than 28 hex (40 dec), jump
	cmp.w	#$FFD8,d1				;checking the inverse position (other side of rink)
	blt.w	.random
	move.w	Ypos(a3),d1
	sub.w	(pucky).w,d1
	cmp.w	#$28,d1					;same as above
	bgt.w	.random
	cmp.w	#$FFD8,d1				;checking the inverse position (other side of rink)
	blt.w	.random
	asr.w	#1,d0
.random								;d0 = random 0..range: a low roll means a penalty
	bsr.w	randomd0
	btst	#pf3break,pflags3(a2)	;Check for player on breakaway
	beq.w	.teamchk				;branch if bit is 0
	move.w	Ypos(a2),d1				;Ypos of player being checked
	bpl.w	.calc					;will jump if Ypos is positive
	neg.w	d1						;flip result (other side of rink)
.calc								;distance from the goal line
	subi.w	#$108,d1				;subtract from Ypos
	neg.w	d1						;flip Y pos
	move.w	#8,d0					;move 8 into d0. Removes any trace of Agr here
	cmp.w	#$75,d1					;compares Ypos calc to 75 hex
	bgt.w	.rand2					;branch if higher than 75 hex
	move.w	#7,d0					;move 7 into d0
	cmp.w	#$3A,d1					;compare 3A hex to Ypos calc
	bgt.w	.rand2					;jump if higher than 3A hex
	move.w	#4,d0					;moves 4 into d0
	cmp.w	#$2C,d1					;compares 2C hex to Ypos calc
	bgt.w	.rand2					;jump if higher than 2C hex
	move.w	#3,d0					;finally, just move 3 in d0
.rand2								;breakaway: worse odds further from the goal (d0 = 3..5)
	bsr.w	randomd0
.teamchk							;penalty check by team
	btst	#pfteam,pflags(a3)		;checks if home or away team
	bne.w	.away
	btst	#2,(DelayedPen).w		;visitors have a delayed penalty
	bne.w	.nopen
	bra.w	.end
.away								;pfteam set
	btst	#1,(DelayedPen).w		;home team has a delayed penalty
	beq.w	.end
.nopen								;no penalty
	move.w	#$7F,d0
.end								;exit (also the end of the code above)
	rts
holdcheck							;player a2 is in hold animation looking to hold opponent a3. Entered from
									;CCStart for SPAHold or SPAhook. a3 must be within 1 direction of where a2
									;faces. a3 flails, a2 goes to SPAHold2 (or SPAhook2), and checkagr rolls
									;penalty $24 after SPAHold2 or $1E after SPAhook2 (through PenShotChk)
	btst	#pfalock,pflags(a3)		;#pfalock - locked animation
	bne.w	rtss2
	tst.w	position(a3)			;position - no hold on goalies
	beq.w	rtss2
	btst	#pf2fight,pflags2(a3)	;#pf2fight - no hold on fighters
	bne.w	rtss2
	move.w	(a3),d0					;Xpos a3
	sub.w	(a2),d0					;Xpos a2
	move.w	Ypos(a3),d1
	sub.w	Ypos(a2),d1
	bsr.w	vtoa					;direction from a2 to a3
	sub.w	facedir(a2),d0
	addq.w	#1,d0
	andi.w	#7,d0
	cmp.w	#2,d0
	bhi.w	rtss2
	move.w	(puckc).w,d0
	cmp.w	SCnum(a3),d0
	bne.w	.holdcheck
	bclr	#sfssdir,(sflags).w		;a3 has the puck
.holdcheck							;a3 does not have the puck: average the two players' velocities (they
									;skate together)
	move.w	Xvel(a3),d0
	add.w	Xvel(a2),d0
	asr.w	#1,d0
	move.w	d0,Xvel(a3)
	move.w	d0,Xvel(a2)
	move.w	Yvel(a3),d0
	add.w	Yvel(a2),d0
	asr.w	#1,d0
	move.w	d0,Yvel(a3)
	move.w	d0,Yvel(a2)
	bset	#pfalock,pflags(a3)
	move.w	#SPAflail,d1
	bsr.w	SetSPA
	exg	a2,a3
	bset	#pfalock,pflags(a3)
	move.w	#SPAHold2,d1
	cmpi.w	#SPAHold,SPA(a3)
	beq.w	.setanimation
	move.w	#SPAhook2,d1			;holding anim after SPAhook
.setanimation						;start the hold animation (SPAHold2 after a hold, SPAhook2 after a hook)
	bsr.w	SetSPA					;start the hold animation
	bsr.w	checkagr
	cmp.w	#6,d0
	bhi.w	.ex
	btst	#gmhl,(gmode).w
	bne.w	.ex
	move.w	#$24,d0					;penalty $24 (holding) after SPAHold2
	cmpi.w	#SPAHold2,SPA(a3)
	beq.w	.addpen
	move.w	#$1E,d0					;penalty $1E after SPAhook2 (holding)
.addpen								;d0 = the hold or hook penalty for the animation
	jsr	(PenShotChk).l
	bsr.w	AddPenalty
.ex									;exit: swap back
	exg	a2,a3
	st	(collflag).w
	rts
Bcheck								;a2 = player that is B checking, a3 = player being checked. Entered from
									;CCStart. If OptPen is 0 and a2 is joystick controlled a2 needs
									;randomd0($20 + a2 Chk - a3 legstr, 2 less when sflags8 bit 1 or sflags7
									;bit 6 is set) >= $18 (93 used $10 + Chk - legstr, >= $C). If a3 is within
									;1 direction of where a2 faces, a3 falls and checkagr may call penalty $20
									;(tripping) on a2. Sets collflag
	btst	#pfalock,pflags(a3)		;check if locked in animation
	bne.w	rtss2
	tst.w	position(a3)
	beq.w	rtss2
	btst	#pf2fight,pflags2(a3)	;is player fighting?
	bne.w	rtss2					;exit if fighting
	tst.w	(OptPen).w
	bne.w	.checkdir
	btst	#pfjoycon,pflags(a2)	;check if player controlled
	beq.w	.checkdir
	move.w	#$20,d0					;20 hex starting value
	add.b	checking(a2),d0			;add Chk of player B checking
	sub.b	legstr(a3),d0			;sub Agl of player being checked
	btst	#1,(sflags8).w
	bne.w	.sub2
	btst	#6,(sflags7).w
	beq.w	.rnd
.sub2								;agility penalty
	subq.b	#2,d0					;sub 2 from d0
.rnd								;random trip check
	bsr.w	randomd0
	cmp.w	#$18,d0
	blt.w	rtss2					;if less than, unsuccessful B check
.checkdir							;check the direction
	move.w	(a3),d0					;Xpos a3
	sub.w	(a2),d0					;sub Xpos a2 from Xpos a3
	move.w	Ypos(a3),d1
	sub.w	Ypos(a2),d1				;sub Ypos a2 from Ypos a3
	bsr.w	vtoa					;direction from a2 to a3
	sub.w	facedir(a2),d0			;sub facedir from d0
	addq.w	#1,d0
	andi.w	#7,d0					;pass first 3 bits of d0
	cmp.w	#2,d0
	bhi.w	rtss2					;exit if higher than 2
	exg	a2,a3
	bsr.w	FallDown				;a3 falls, a2 is the hitter
	bsr.w	checkagr
	cmp.w	#4,d0
	bhi.w	.exit
	move.w	#$20,d0					;Tripping
	jsr	(PenShotChk).l
	bsr.w	AddPenalty
.exit								;exit: swap back
	exg	a2,a3
	st	(collflag).w
	rts
FallDown							;player a2 falls down, player a3 is the hitting player. Skips a2 in some
									;anims, or the same pair as the last call. A skater hitter adds check
									;stats (team $10, player $11C, ChkCnt). A hit into the wall picks a fall
									;anim from .FallList by where a2 is (the SPAboardright / SPAboardleft
									;falls near center ice (|Ypos| up to $59 / $38) become SPAbenchcheckl /
									;SPAbenchcheckr), a strong Stk player may just stumble, and an injury
									;(setInjuryType) adds penalty $12 (or $14) and stops play. Then the crowd
									;and a check sound (newcheck). Called from checkint (.ci), CCStart and
									;Bcheck
	cmpi.w	#$B,SCnum(a2)			;0-11 are player structs
	bgt.w	rtss2					;exit if not a player struct
	cmpi.w	#SPAinjuryfall,SPA(a2)	;checks various animations and exits if one of them
	beq.w	rtss2
	cmpi.w	#SPAinjury1,SPA(a2)
	beq.w	rtss2
	cmpi.w	#SPAstumble,SPA(a2)
	beq.w	rtss2
	cmpi.w	#SPAfallfwd,SPA(a2)
	beq.w	rtss2
	cmpi.w	#SPAfallback,SPA(a2)
	beq.w	rtss2
	cmpi.w	#SPAflip,SPA(a2)
	beq.w	rtss2
	cmpa.l	(PlayerChked).w,a2		;compared to previous player checked
	bne.w	.cont					;branch if not the same
	cmpa.l	(PlayerChking).w,a3		;compares a3 to previous player checking
	bne.w	.cont					;branch if not the same
	rts								;exit if both players are the same as last Fall Down attempt
.cont								;a2 <> PlayerChked or a3 <> PlayerChking
	move.l	a2,(PlayerChked).w
	move.l	a3,(PlayerChking).w		;player checking
	btst	#pf3onetimer,pflags3(a2)	;is player a2 doing a one-timer
	bne.w	rtss2
	btst	#pf3onetimer,pflags3(a3)	;Is player a3 doing a one-timer
	bne.w	rtss2
	move.w	#SPAstumble,d1			;toddle animation?
	btst	#pf3wall,pflags3(a3)
	bne.w	.cont2					;jump if hitting wall
.CmpPlayerStk						;(entry point inside FallDown). a2's Stk value. Compares to $18 (24
									;decimal) a2's Stk value. Compares to 18 (24 decimal)
	cmpi.b	#$18,stickhand(a2)		;Start of toddle check
	blt.w	.cont2					;jump if less than
	tst.b	nopuckb(a2)				;check if puck collision possible
	bne.w	.cont2
	move.w	(HVcount).l,d0			;frame counter
	andi.w	#$F,d0					;pass 1st byte of d0
	addi.w	#$10,d0					;add 10 hex to d0
	cmp.w	impact(a2),d0			;compare impact value to d0.
									;d0 will be 10-1F hex (16-31 decimal)
	ble.w	.cont2					;no toddle if d0 <= impact
	move.b	#$3C,nopuckb(a2)		;$3C (60) into nopuckb
	bra.w	.hitter
.cont2								;not toppled: count the check for the hitter's team stats
	tst.w	position(a3)
	beq.w	.chkpos
	movea.w	#(tmstruct-M68K_RAM),a0	;Start of Home Team Stats Struct
	btst	#pfteam,pflags(a3)
	beq.w	.AddChktoPlayerStats
	adda.w	#tmsize,a0				;Change to Away Team Stats
.AddChktoPlayerStats				;(a label inside FallDown)
	addq.w	#1,tmchecks(a0)			;Add 1 Chk to Team Total
	clr.w	d0
	move.b	pnum(a3),d0
	adda.w	d0,a0
	addq.b	#1,pchecks(a0)			;Add 1 Chk to Player Stats
	addq.w	#1,(ChkCnt).w			;Add 1 to ChkCnt
	tst.b	fighting(a3)			;checks fight attribute?
	bne.w	.chkpos					;jump if fight attribute not 0
	addq.w	#2,(ChkCnt).w			;add 2 to ChkCnt
.chkpos								;goalie hitters skip the stats: pick the fall by direction
	move.b	#$78,nopuck(a2)
	move.w	(a3),d0					;Xpos
	sub.w	(a2),d0					;sub Xpos
	move.w	Ypos(a3),d1
	sub.w	Ypos(a2),d1
	bsr.w	vtoa
	tst.w	position(a2)			;check if goalie a2
	beq.w	.7
	jsr	(wallcollduringcheck).l		;check for wall collision
	btst	#pf3wall,pflags3(a2)	;check wall collision bit
	beq.w	.7						;jump if not collision
	movem.l	d1-d4,-(sp)
	move.w	Xvel(a2),d1				;move Xvel into d1
	bpl.w	.yvel
	neg.w	d1
.yvel								;|Yvel|
	move.w	Yvel(a2),d2				;move Yvel into d2
	bpl.w	.chkpos2
	neg.w	d2
.chkpos2							;check the position
	move.w	(a2),d3					;Xpos of player into d3
	sub.w	(a3),d3					;sub Xpos of checker
	move.w	Ypos(a2),d4				;Ypos of player into d4
	sub.w	Ypos(a3),d4				;sub Ypos of checker
	cmpi.w	#$108,Ypos(a3)			;compare Ypos of a3 to top goal line
	bgt.w	.bnet1					;branch if behind net
	cmpi.w	#$FEF8,Ypos(a3)			;compare to bottom goal line Y
	blt.w	.bnet2					;branch if behind net
	tst.w	(a3)					;In between goal lines
									;Check Xpos of checker
	bpl.w	.posx					;branch if positive (right side of center)
	tst.w	d3						;check diff of Xpos
	bpl.w	.chktowardcenterice		;branch if positive (player to right of checker)
	cmp.w	#$FFFD,d3				;comp diff of Xpos with -3
	bgt.w	.chktowardcenterice		;branch if greater than
	bra.w	.chkawayfromcenterice	;player to left of checker
.posx								;a3 >= 0
	tst.w	d3						;check diff of Xpos
	bmi.w	.chktowardcenterice		;branch if negative (player to left of checker)
	cmp.w	#3,d3					;comp diff of Xpos with 3
	blt.w	.chktowardcenterice		;branch if less than
	bra.w	.chkawayfromcenterice	;player to right of checker
.bnet2								;behind the bottom net: compare y to choose the board animation
	tst.w	d4						;check diff of Ypos
	bpl.w	.chktowardcenterice
									;player higher than checker
	bra.w	.chkawayfromcenterice	;player lower than checker
.bnet1								;behind the top net: the other way round
	tst.w	d4						;check diff of Ypos
	bmi.w	.chktowardcenterice
									;player lower than checker
	bra.w	.chkawayfromcenterice	;player higher than checker
.chktowardcenterice					;pop the d1-d4 saved above
	movem.l	(sp)+,d1-d4
	bra.w	.7
.chkawayfromcenterice				;pop the d1-d4 saved above
	movem.l	(sp)+,d1-d4
	bra.w	*+4						;to the next instruction (.playerpos)
.playerpos							;past the goal lines or wide of the crease: board check, else a normal
									;fall (.7)
	cmpi.w	#$10C,Ypos(a2)
									;check if player is above top goal line
	bgt.w	.chkawayfrommiddle
	cmpi.w	#$FEF4,Ypos(a2)			;Check if player is below bottom goal line
	blt.w	.chkawayfrommiddle
	cmpi.w	#$68,(a2)				;Xpos player
									;check if right of crease?
	bgt.w	.chkawayfrommiddle		;branch if to the right
	cmpi.w	#$FF98,(a2)				;check if left of crease?
	blt.w	.chkawayfrommiddle		;branch if to the left
	bra.w	.7
.chkawayfrommiddle					;board check: excite the crowd and start a crosscheck (players only)
	cmpi.w	#$B,SCnum(a3)			;check if SCNum is a player
	bgt.w	.0						;branch if not player
	addi.w	#$A,(CwdExciteLvl).w
	addi.w	#$96,(Crowdlevel).w
	move.w	d1,-(sp)
	move.b	#0,temp1(a3)
	move.b	#0,glitch(a3)
	move.w	#SPAcrosscheck,d1
	jsr	(SetSPA).l
	clr.w	Xvel(a3)
	clr.w	Yvel(a3)
	move.w	(sp)+,d1
.0									;pick the board animation by where a2 is (0 top, 2 right, 4 bottom, 6
									;left)
	movem.l	d0/a0,-(sp)
	cmpi.w	#$10C,Ypos(a2)			;check player Ypos with top goal line
	bgt.w	.playerabovetopgoalline
	cmpi.w	#$FEF4,Ypos(a2)			;check player Ypos with bottom goal line
	blt.w	.playerbelowbottomgoalline
	tst.w	(a2)					;test player Xpos
	bmi.w	.playerleftofcenter
	move.w	#2,d0					;player right of center
	bra.w	.getchkanim
.playerleftofcenter					;a2 negative
	move.w	#6,d0
	bra.w	.getchkanim
.playerabovetopgoalline				;above the top goal line: FallList entry 0
	move.w	#0,d0
	bra.w	.getchkanim
.playerbelowbottomgoalline			;below the bottom goal line: FallList entry 4
	move.w	#4,d0
.getchkanim							;d1 = the board animation for that side, saved fall position
	add.w	d0,d0
	movea.l	#.FallList,a0
	move.w	0(a0,d0.w),d1			;move animation from list into d1
	move.w	Ypos(a2),(FallYPos).w
	move.w	(a2),(FallXPos).w
	cmp.w	#SPAboardleft,d1		;player left of center
	bne.w	.1
	cmpi.w	#$59,Ypos(a2)			;compare $59 to Ypos
	bgt.w	.1
	cmpi.w	#$FFA7,Ypos(a2)			;compare -$59 to Ypos
	blt.w	.1
	move.w	d0,-(sp)
	move.w	#7,d0
	jsr	(StartArenaAnim).l
	move.w	(sp)+,d0
	move.w	#SPAbenchcheckl,d1
	btst	#3,attribute(a2)
	beq.w	.6
	move.w	#SPAbenchcheckr,d1
	bra.w	.6
.1									;not a left board hit near the bench: check the right side
	cmp.w	#SPAboardright,d1		;player right of center
	bne.w	.4
	cmpi.w	#$38,Ypos(a2)			;compare $38 to Ypos
	bgt.w	.4
	cmpi.w	#$FFC8,Ypos(a2)			;compare -38 to Ypos
	blt.w	.4
	move.w	#SPAbenchcheckr,d1		;change anim value
	btst	#3,attribute(a2)		;check bit 3 of frame
	beq.w	.6
	move.w	#SPAbenchcheckl,d1		;change anim value
	bra.w	.6
.4									;not by the bench: mirror the animation for flipped sprites
	btst	#3,attribute(a2)		;check bit 3 of frame
	beq.w	.6
	cmp.w	#SPAboardright,d1
	beq.w	.5						;branch if right of center
	cmp.w	#SPAboardleft,d1
	bne.w	.6						;branch if not left of center
	move.w	#SPAboardright,d1		;change anim to same as right of center
	bra.w	.6
.5									;d1 = #SPAboardright
	move.w	#SPAboardleft,d1		;change anim
.6									;fall animation chosen: stop a2 and mark the fall
	clr.w	Xvel(a2)
	clr.w	Yvel(a2)
	bset	#pf3fall,pflags3(a2)
	bset	#pfdoff,pflags(a2)
	movem.l	(sp)+,d0/a0
	bra.w	.8
.FallList							;(a table inside FallDown). Fall anim by where a2 is: above, right, below,
									;left (2 words each)
	dc.w	SPAboardfront
	dc.w	SPAboardfront
	dc.w	SPAboardright
	dc.w	SPAboardright
	dc.w	SPAboardback
	dc.w	SPAboardback
	dc.w	SPAboardleft
	dc.w	SPAboardleft
.7									;open-ice hit: fall back if hit from the front, else forward
	move.w	#SPAfallback,d1
	sub.w	facedir(a2),d0
	addq.w	#1,d0
	andi.w	#7,d0
	cmp.w	#2,d0
	bls.w	.hitter
	move.w	#SPAfallfwd,d1
.8									;fall chosen; a strong (checking 20+) square hit may flip a2 instead
	move.w	facedir(a2),d0
	andi.w	#3,d0
	bne.w	.hitter					;branch if first 2 bits of d0 arent zero
	cmpi.b	#$14,checking(a3)		;compare $14 to checker Chk attribute
	blt.w	.hitter					;branch if less than
	cmpi.w	#$B,SCnum(a3)			;check if SCNum of checker is a player
	bgt.w	.hitter
	btst	#pf3fall,pflags3(a2)	;check if falldown bit is set for player
	bne.w	.hitter
	move.w	#SPAflip,d1				;third fall anim
.hitter								;start a2's fall animation (a2/a3 swapped for SetSPA)
	exg	a2,a3						;swap a2 and a3
	bset	#pfalock,pflags(a3)
	bsr.w	SetSPA					;set animation with d1 value
	exg	a2,a3						;swap back a2 and a3
	tst.w	position(a3)			;check if checking player is goalie
	beq.w	.21
	tst.w	position(a2)			;check if player checked is goalie
	beq.w	.21
	addi.w	#$12C,(Crowdlevel).w	;add to crowd level
	addi.w	#$F,(CwdExciteLvl).w	;add to crowd excite level
.21									;a2 had the puck: knock it loose; then the check sound
	move.w	(puckc).w,d0			;move puck carrier SCNum into d0
	bmi.w	newcheck
	cmp.w	SCnum(a2),d0			;check if puck carrier is a2
	bne.w	newcheck
	st	(puckc).w					;clear out puck carrier
	btst	#gmhl,(gmode).w
	bne.w	.22
	cmpi.w	#SPAfallback,SPA(a2)	;injury: only from a fall back
	bne.w	.22						;jump if not equal
	move.w	facedir(a2),d0
	andi.w	#3,d0					;pass first 2 bits of d0
	bne.w	.22
	btst	#pf2pen,pflags2(a2)		;check if player is unavailable
	bne.w	.22
	move.l	#$A0,d0
	bsr.w	randomd0
	cmp.w	impact(a2),d0			;compare impact to d0
	bgt.w	.22						;jump if d0 higher than impact
	btst	#gmclock,(gmode).w		;check if clock running
	bne.w	.22
	exg	a2,a3
	move.w	#SPAinjuryfall,d1
	bsr.w	SetSPA
	exg	a2,a3
	bsr.w	setInjuryType
	btst	#5,(sflags7).w			;check if game injury
	bne.w	.9						;branch if game injury
	exg	a2,a3
	move.w	#SPAinjury1,d1
	bsr.w	SetSPA
	exg	a2,a3
.9									;injury count down
	move.w	#4,(InjCntDown).w
	move.l	#$14,d0					;penalty $14 if the hitter is a goalie or OptPen is 0
	tst.w	position(a3)			;check if a3 goalie
	beq.w	AddPenalty2
	tst.w	(OptPen).w
	beq.w	AddPenalty2
	move.l	#$12,d0					;Pen Roughing
	bsr.w	AddPenalty2
	bra.w	Stop4Pen
.22									;fight or injury cases done: cheer for home hits, boo for away ones
	move.w	#SFXcrowdcheer,-(sp)
	btst	#pfteam,pflags(a2)
	bne.w	.3						;jump if away team
	move.w	#SFXcrowdboo,(sp)
.3									;crowd sound
	bsr.w	song
	rts
setInjuryType						;determines if injury will be for period or game. a2 = player injured, a3
									;= player checking. Marks a2 unavailable, pumps up the crowd, plays sfx
									;$D, locks the scroll on a2 and sets TempPlOffset (pnum, bit 15 set for
									;the away team). a2's tmpdst becomes $FFFD (injured for the period) or,
									;from a3's Fgt byte (getFgtbyte, chkFgtBit1), $FFFC (injured for the game,
									;sflags7 bit 5). Called from FallDown
	move.w	d0,-(sp)
	bset	#pf2unav,pflags2(a2)
	addi.w	#$12C,(Crowdlevel).w	;pump up crowd
	addi.w	#$1E,(CwdExciteLvl).w
	move.w	#SFXoooh2,-(sp)
	bsr.w	sfx
	move.w	(a2),(xc1).w			;move Xpos to scroll center
	move.w	Ypos(a2),(yc1).w		;move Ypos to scroll center
	bset	#sfslock,(sflags).w		;set sfslock (scroll lock)
	clr.w	d1
	movea.w	#(tmstruct-M68K_RAM),a0	;move Home team Struct to a0
	btst	#pfteam,pflags(a2)		;check if player home or away
	beq.w	.0
	move.w	#$8000,d1				;move $8000 into d1
	adda.w	#tmsize,a0				;add $364 to a0 (Away Team Struct start)
.0									;roster offset
	move.b	pnum(a2),d1				;move roster offset into d1
	move.w	d1,(TempPlOffset).w
	ext.w	d1						;sign extend - in this case just makes upper bye of word 00
	add.w	d1,d1					;add d1 to itself
	exg	a2,a3						;swap a2 and a3
	jsr	(getFgtbyte).l				;get the Fgt byte (divided by 4)
	exg	a2,a3
	tst.w	d0						;check if d0 is zero
	bne.w	.not0					;branch if H/F was more than 3
	bclr	#5,(sflags7).w			;clear injury game bit
	move.w	#$FFFD,tmpdst(a0,d1.w)	;update status of player
	bra.w	.exit
.not0								;d0 <> 0
	cmp.w	#3,d0					;compare d0 to 3 (if H/F was 12, d0 = 3)
	beq.w	.injurygame
	bclr	#5,(sflags7).w
	move.w	#$FFFD,tmpdst(a0,d1.w)	;update status of player
	jsr	(chkFgtBit1).l				;check Fgt bit 1 of player.
	beq.w	.exit					;jump if Fgt not 2,6,A
.injurygame							;game injury
	bset	#5,(sflags7).w			;set injury game bit
	move.w	#$FFFC,tmpdst(a0,d1.w)	;update status of player
.exit								;injury type set: restore d0
	move.w	(sp)+,d0
	rts
;	Goal, wall and puck collision routines, from checkfight (an rts) to checkpuckcoll.
;
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp /
;	cmpi; fixopcodes.js patches the cmp encoding after assembly.

;Sort struct (SortCords, SCstruct each) and team struct (tmstruct / awtmstruct, tmsize bytes): the fields are
;named in ram94.asm. 94 adds the hot / cold table and goals by period, power play, breakaway,
;one-timer, penalty shot and shorthanded stats at the end of the team struct.

checkfight							;an rts: there is no fighting (93 looked for the start of a fight between
									;a2 and a3 here). Called from checkcx
	rts
checkwallcoll						;d2/d3 = x/y to test, a3 = object, wcradiusx/wcradiusy = radius. Check the
									;corner circles, the goals (checkgoal with a2 = SortCords+(13*SCstruct)
									;top, SortCords+(12*SCstruct) bottom) and then the side and end boards.
									;Calls wallcollb on a hit, with d0/d1 = cos/sin of the wall. Called from
									;checkcoll
	bclr	#pf3wall,pflags3(a3)
	move.w	#$88,d4
	sub.w	(wcradiusx).w,d4
	move.w	#$12A,d5				;298: end boards
	sub.w	(wcradiusy).w,d5
	movem.w	d2-d5,-(sp)
	neg.w	d4
	neg.w	d5
	addi.w	#$40,d4					;corner circle radius 64
	addi.w	#$40,d5
	cmp.w	d5,d3
	bgt.w	.0
	cmp.w	d4,d2
	blt.w	.1
	neg.w	d4
	cmp.w	d4,d2
	bgt.w	.1
	movea.w	#(SortCords+(13*SCstruct)-M68K_RAM),a2
	bsr.w	checkgoal
	bra.w	.2
.0									;d3 > d5
	neg.w	d5
	cmp.w	d5,d3
	blt.w	.2
	cmp.w	d4,d2
	blt.w	.1
	neg.w	d4
	cmp.w	d4,d2
	bgt.w	.1
	movea.w	#(SortCords+(12*SCstruct)-M68K_RAM),a2
	bsr.w	checkgoal
	bra.w	.2
.1									;d2 < d4 or d2 > d4
	sub.w	d4,d2					;corner circle: d2/d3 = offset from the circle centre
	sub.w	d5,d3
	move.w	d3,d0
	move.w	d2,d1
	neg.w	d1
	muls.w	d3,d3
	muls.w	d2,d2
	add.l	d2,d3					;dist from dot
	cmp.l	#$1000,d3				;inside the corner circle (64*64)
	bls.w	.2
	exg	d0,d3
	bsr.w	Sroot					;distance from the circle center
	exg	d0,d3
	ext.l	d0
	asl.l	#8,d0
	divs.w	d3,d0
	ext.l	d1
	asl.l	#8,d1
	divs.w	d3,d1
	bsr.w	wallcollb
.2									;pop the d2-d5 saved above
	movem.w	(sp)+,d2-d5
	move.w	Wallcos(a3),d0			;wallcos: already hit
	or.w	Wallsin(a3),d0
	bne.w	rtss2
	move.w	#$100,d0				;now check side walls
	clr.w	d1
	cmp.w	d5,d3
	bge.w	wallcollb
	neg.w	d5
	neg.w	d0
	cmp.w	d5,d3
	ble.w	wallcollb
	exg	d0,d1
	cmp.w	d4,d2
	bge.w	wallcollb
	neg.w	d4
	neg.w	d1
	cmp.w	d4,d2
	ble.w	wallcollb
	rts
checkgoal							;look for coll with goal/net. a2 = goal struct, a3 = object, d2/d3 = x/y.
									;A puck under the crossbar hits a post or the net (deflect,
									;sfx $25 or 8 and crowd) or goes in (Goal); a player goes to checkgoalp.
									;Called from checkwallcoll
	cmpi.w	#$D,Zpos(a3)			;13 pix for zside = height of goal (puck only check)
	bgt.w	rtss2					;over goal
	cmpi.w	#puckscnum,SCnum(a3)
	bne.w	checkgoalp				;coll with player not puck
	sub.w	(a2),d2					;Xpos
	moveq	#$10,d4					;xside = 16  width of goal/2
	add.w	(wcradiusx).w,d4
	cmp.w	d4,d2
	bgt.w	rtss2
	neg.w	d4
	cmp.w	d4,d2
	blt.w	rtss2
	sub.w	Ypos(a2),d3
	move.w	#2,d5					;yside = 2 depth of goal/2
	add.w	(wcradiusy).w,d5
	cmp.w	d5,d3
	bgt.w	rtss2
	neg.w	d5
	cmp.w	d5,d3
	blt.w	rtss2
	st	(collflag).w				;inside goal area now
	cmpi.w	#$D,OldZpos(a3)			;compare OldZpos to zside
	blt.w	.nod					;branch if less than (in net)
	move.w	OldZpos(a3),Zpos(a3)
	bra.w	.deflectz
.nod								;puck in the net (below the crossbar): it loses its carrier
	bclr	#pfgoal,pflags(a3)		;puck was below the top of the net
	move.w	(puckc).w,d0
	bmi.w	.nocon					;no puck carrier
	st	(puckc).w
	asl.w	#7,d0
	movea.w	#(SortCords-M68K_RAM),a0
	move.b	#8,nopuck(a0,d0.w)		;92 wrote a word
	move.w	(pucky).w,d1
	btst	#pfgoal,pflags(a0,d0.w)
	bne.w	.an
	neg.w	d1
.an									;carrier's side
	tst.w	d1						;carrier's side sign
	bpl.w	.nocon
	bset	#pfgoal,pflags(a3)
.nocon								;set the puck velocity
	move.w	#$FF00,d0
	move.l	Ypos(a3),d1
	sub.l	OldYpos(a3),d1
	asr.l	#8,d1
	beq.w	.sideentry
	bmi.w	.0
	neg.w	d0
	neg.w	d5
.0									;d0/d5 = where the puck crossed the goal line
	add.w	d3,d5
	move.l	(a3),d3					;Xpos
	sub.l	OldXpos(a3),d3
	asr.l	#8,d3
	muls.w	d3,d5
	divs.w	d1,d5
	bvs.w	.sideentry
	sub.w	d5,d2
	cmp.w	d4,d2
	blt.w	.sideentry
	neg.w	d4
	cmp.w	d4,d2
	bgt.w	.sideentry
	clr.w	d1
	move.w	Ypos(a3),d3
	eor.w	d0,d3
	bmi.w	wallcoll
	neg.w	d0
	btst	#pfgoal,pflags(a3)
	bne.w	wallcoll
	cmpi.w	#$D,Zpos(a3)			;.zside, Zpos
	beq.w	.deflectsf
	subq.w	#1,d4
	cmp.w	d4,d2
	bgt.w	.deflectsf
	neg.w	d4
	cmp.w	d4,d2
	bge.w	Goal
.deflectsf							;deflection off the post or crossbar: count the shot and play the sound
	bsr.w	ChkShotStat				;deflection: count the shot
	move.w	#$25,-(sp)				;sfx $25 when the clock is stopped (92 used 9)
	btst	#gmclock,(gmode).w		;gmclock: no goal after the whistle
	bne.w	.deflectsf2
	move.w	#8,(sp)					;sfx 8 (92 used 31) and crowd
	addi.w	#$12C,(Crowdlevel).w
	addi.w	#$28,(CwdExciteLvl).w
.deflectsf2							;play the sound
	bsr.w	sfx
	move.w	#$1000,d0
	bsr.w	randomd0
	tst.w	Ypos(a3)
	bmi.w	.df0
	neg.w	d0
.df0								;d0 = random y speed away from the net
	move.w	d0,Yvel(a3)
	move.w	#$1000,d0
	bsr.w	randomd0s
	move.w	d0,Xvel(a3)
	move.w	#$1000,d0
	bsr.w	randomd0s
	move.w	d0,Zvel(a3)
	bra.w	puckflip
.deflectz							;puck over the net: bounce down (Zvel kept downward)
	neg.w	Zvel(a3)
	bpl.w	rtss2
	neg.w	Zvel(a3)
	rts
.sideentry							;through the side or back: treat the net as a wall along x
	clr.w	d0						;through the side or back: wall normal along x, sign from x motion
	move.w	#$100,d1
	move.w	(a3),d2					;Xpos
	sub.w	OldXpos(a3),d2
	bmi.w	wallcoll
	neg.w	d1
	bra.w	wallcoll
Goal								;puck in goal. First: in a penalty shot or shootout (BA_PS_flags bit 2)
									;only the shooter's end counts (gmode2 bit 0
									;shootout, shootoutteam picks the end); it counts the shootout goal
									;(homeshootgoals / awayshootgoals) and calls EndPenaltyShotPlay
	btst	#2,(BA_PS_flags).w
	beq.w	.7
	btst	#0,(gmode2).w
	bne.w	.1
	movem.l	d0/a0,-(sp)
	move.w	(BA_Sktr_SCnum).w,d0
	asl.w	#7,d0
	movea.l	#SortCords,a0
	adda.w	d0,a0
	btst	#7,pflags(a0)
	movem.l	(sp)+,d0/a0
	bne.w	.2
	bra.w	.3
.1									;bit 0 of gmode2 set
	tst.w	(shootoutteam).w
	bne.w	.3
.2									;check the puck end
	tst.w	(pucky).w
	bmi.w	rtss2
	bra.w	.4
.3									;away shooter (shootoutteam set): a goal only at the negative y end
	tst.w	(pucky).w
	bpl.w	rtss2
.4									;goal in a penalty shot or shootout: count it for the shooter's team
	bset	#5,(sflags4).w			;penalty shot / shootout goal
	tst.w	(shootoutteam).w
	beq.w	.5
	addq.w	#1,(awayshootgoals).w
	bra.w	.6
.5									;shootoutteam = 0
	addq.w	#1,(homeshootgoals).w
.6									;the shootout goal is counted: end the penalty shot play
	bset	#0,(sflags8).w
	jsr	(EndPenaltyShotPlay).l
	bra.w	.8
.7									;bit 2 of BA_PS_flags clear
	btst	#gmclock,(gmode).w
	bne.w	rtss2
.8									;normal goal: score it
	bset	#0,(sflags4).w
	bclr	#3,(sflags8).w
	bsr.w	ChkShotStat
	bsr.w	stop_current_song
	move.w	d0,-(sp)
	move.w	(Vcount).w,d0
.loop								;loop
	cmp.w	(Vcount).w,d0			;wait for the next vblank
	beq.s	.loop
	move.w	(sp)+,d0
	move.w	#SFXsiren,-(sp)
	bsr.w	sfx
	jsr	(freezewindow).l
	addi.w	#$1F4,(Crowdlevel).w	;add 500 (92 800)
	movea.w	#(tmstruct-M68K_RAM),a2
	lea	tmsize(a2),a1
	tst.w	Ypos(a3)
	bpl.w	.9
	exg	a2,a1
.9									;a2 = the team that scored (top end: home, unless gmdir swaps it)
	btst	#gmdir,(gmode).w
	beq.w	.addg
	exg	a2,a1
.addg								;add the goal
	addq.w	#1,tmscore(a2)			;tmscore: add to Goals
	btst	#5,(sflags4).w			;penalty shot / shootout goal
	beq.w	.11
	btst	#0,(gmode2).w			;shootout: no penalty shot goal counted
	bne.w	.11
	addq.w	#1,tmPenShotGoals(a2)	;penalty shot goal (sflags4 bit 5)
.11									;breakaway goal?
	bclr	#4,(gmode2).w
	beq.w	.12
	addq.w	#1,tmBreakawayGoals(a2)	;breakaway goal (gmode2 bit 4)
.12									;power play goal?
	btst	#sf2pwrplay,(sflags2).w
	beq.w	.14
	btst	#sf2pwrtm,(sflags2).w	;sf2pwrtm: 0 home, 1 visitors
	bne.w	.13
	cmpa.l	#awtmstruct,a2
	bne.w	.14
.loop2								;loop
	addq.w	#1,tmSHGoals(a2)		;shorthanded goal: a2 is the team without the power play
	bra.w	.14
.13									;sf2pwrtm set
	cmpa.l	#tmstruct,a2
	beq.s	.loop2
.14									;shorthanded or not: count the goal in this period
	movem.l	d0/a2,-(sp)
	move.w	(gsp).w,d0
	add.w	d0,d0
	adda.w	d0,a2
	addq.w	#1,tmPerGoals(a2)		;goal in this period (gsp)
	movem.l	(sp)+,d0/a2
	bclr	#7,(sflags8).w
	beq.w	.15
	addq.w	#1,tmOneTimerGoals(a2)	;one-timer goal (sflags8 bit 7)
.15									;home goal song
	cmpa.w	#(tmstruct-M68K_RAM),a2	;home goal: ChooseSong
	bne.w	.16
	move.w	(HomeTeam).w,(HmTeam).w
	move.w	#SngGoal,(SongIndex).w
	jsr	(ChooseSong).l
	move.w	#$78,(songdelay).w
	move.w	(SongNum).w,-(sp)
	move.w	(sp)+,(delayedsong).w
.16									;score summary
	cmpi.w	#$168,(ScoreSumbytes).w	;60 entries of 6 bytes full? (93 kept 30)
	bne.w	.sum
	subq.w	#6,(ScoreSumbytes).w	;overwrite the last entry
.sum								;add the ScoreSum entry
	movea.w	#(ScoreSum-M68K_RAM),a0	;a0 = next 6 byte ScoreSum entry
	adda.w	(ScoreSumbytes).w,a0
	addq.w	#6,(ScoreSumbytes).w
	bsr.w	GetPeriodTimeRemaining
	move.w	d0,(a0)+				;entry word 0 = period/time
	moveq	#2,d0
	add.w	tmap(a2),d0
	sub.w	tmap(a1),d0
	move.b	d0,(a0)+				;byte 2 = 2 + tmap(a2) - tmap(a1)
	addi.w	#$1E,(CwdExciteLvl).w
	cmpa.w	#(tmstruct-M68K_RAM),a2
	beq.w	.18
	subi.w	#$14,(CwdExciteLvl).w	;less for an away goal
	bset	#7,-1(a0)				;byte 2 bit 7 = away team scored
.18									;scorer byte
	move.w	tmtouch1(a2),d0
	move.b	d0,(a0)+
	move.w	#$FFFF,(a0)				;no assists yet
	addi.w	#tmgoals,d0
	addq.b	#1,0(a2,d0.w)			;tmgoals of the scorer +1
	move.w	tmtouch2(a2),d0
	bmi.w	.19
	cmp.w	tmtouch1(a2),d0
	beq.w	.19
	move.b	d0,(a0)+
	addi.w	#tmassists,d0
	addq.b	#1,0(a2,d0.w)
	move.w	tmtouch3(a2),d0			;second assist
	bmi.w	.19
	cmp.w	tmtouch1(a2),d0
	beq.w	.19
	move.b	d0,(a0)
	addi.w	#tmassists,d0
	addq.b	#1,0(a2,d0.w)
.19									;goal scorer stat done: credit the shot against to the goalie
	move.w	tmgoalie(a1),d0			;tmgoalie of the other team
	bmi.w	.stat
	addi.w	#tmgoals,d0
	addq.b	#1,0(a1,d0.w)
.stat								;shot stats
	bsr.w	ChkShotStat
	bsr.w	PenGoalStuff
	bclr	#3,(BA_PS_flags).w
	bsr.w	printscores1
	move.w	#$2710,(crowdnoisedelay).w
	btst	#0,(gmode2).w
	beq.w	.21
	bra.w	.22
.21									;bit 0 of gmode2 clear
	move.l	#7,d0					;assignment 7 (92 used 8)
	bsr.w	.setass
.22									;reset the puck to center (x 6, behind the goal line)
	clr.w	(collflag).w
	clr.w	Xvel(a3)
	clr.w	Yvel(a3)
	moveq	#6,d0
	tst.w	(a3)					;Xpos
	bpl.w	.23
	neg.w	d0
.23									;set Xpos
	move.w	d0,(a3)					;Xpos
	move.w	#$110,d0				;+goalline+8
	tst.w	Ypos(a3)
	bpl.w	.24
	neg.w	d0
.24									;y = goal line + 8 on the puck's side
	move.w	d0,Ypos(a3)
	move.w	#$600,Zvel(a3)
	clr.w	Zpos(a3)
	st	(puckcross2).w
	st	(puckcross6).w
	bset	#pfnc,pflags(a3)
	move.w	#$1A,d0					;puckunflip
	bsr.w	assreplace
	move.l	a3,-(sp)
	adda.w	#$80,a3					;SCstruct
	move.w	#SPAsiren,d1			;92 used $FE8
	bsr.w	SetSPA
	movea.w	tmsort(a1),a3			;first sort obj of the other team
	move.l	#$E,d0					;penalty $E (92 used 6)
	bsr.w	AddPenalty2
	movea.l	(sp)+,a3
	rts
.setass								;d0 = assignment, a2 = team. Give each skater of team a2 that is not
									;fighting assignment d0, clear pfnc. Also clears $64 bit 3 (one-timer) and
									;then calls EndOneTimer.
									;Called from Goal
	move.l	a3,-(sp)				;d0 = assignment, a2 = team
	movea.w	tmsort(a2),a3
	moveq	#5,d3
.loop3								;next skater
	tst.w	position(a3)
	ble.w	.nl
	btst	#pf2fight,pflags2(a3)
	bne.w	.nl
	bclr	#pfnc,pflags(a3)
	bclr	#pf3onetimer,pflags3(a3)
	beq.w	.insert
	jsr	(EndOneTimer).l
.insert								;put him back in the assignments
	bsr.w	assinsert
.nl									;next player
	adda.w	#$80,a3
	dbf	d3,.loop3
	movea.l	(sp)+,a3
	rts
GetPeriodTimeRemaining				;Return d0 = (gsp << 14 | PerTimeTotal) - gameclock. Called from checkgoal
									;(ScoreSum entry) and InProgress
	move.w	(gsp).w,d0
	swap	d0
	clr.w	d0
	lsr.l	#2,d0					;gsp in bits 14-15
	or.w	(PerTimeTotal).w,d0
	sub.w	(gameclock).w,d0
	rts
checkgoalp							;check for player a3 collision with goal/net a2. Entered from checkgoal.
									;Oval goal; skipped for no player coll (pflags2 bit 5), a high
									;player or a non-player. CheckBump, then wallcoll with sflags6 bit 4 set
									;(no wall collision bit)
	btst	#pf2npc,pflags2(a3)		;no player collision?
	bne.w	rtss2
	cmpi.w	#$A,Zpos(a3)
	bgt.w	rtss2
	cmpi.w	#$B,SCnum(a3)			;SCnum: players only
	bgt.w	rtss2
	movem.w	d2-d3,-(sp)
	sub.w	Ypos(a2),d3
	move.w	d3,d0
	sub.w	(a2),d2					;Xpos
	move.w	d2,d1
	neg.w	d0
	asl.w	#4,d2
	muls.w	d2,d2
	divu.w	#$400,d2				;.radiusx*.radiusx
	cmp.w	#$100,d2
	bhi.w	.exit
	asl.w	#4,d3
	muls.w	d3,d3
	divu.w	#$79,d3					;.radiusy*.radiusy
	add.w	d2,d3
	cmp.w	#$100,d3
	bhi.w	.exit					;outside the oval
	movem.w	(sp)+,d2-d3
	bsr.w	CheckBump
	movem.w	d2-d3,-(sp)
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	bsr.w	Sroot
	move.w	d0,d2
	movem.w	(sp)+,d0-d1
	addq.w	#1,d2
	asl.l	#8,d0
	divs.w	d2,d0
	asl.l	#8,d1
	divs.w	d2,d1
	bset	#4,(sflags6).w			;wallcoll: do not set the wall collision bit
	bsr.w	wallcoll
	bclr	#4,(sflags6).w
.exit								;exit: restore the registers
	movem.w	(sp)+,d2-d3
	rts
CheckBump							;supply minimum separation velocity for coll with walls/goal/net. a2 =
									;goal, a3 = player. On one frame in 32, a player near the puck in y moving
									;faster than $2000 knocks the net (a2 gets a quarter of a3's velocity, a3
									;stops, sfslock) and, while the clock runs, calls penalty 8. Called from
									;checkgoalp
	movem.l	d0-d1,-(sp)
	move.w	(HVcount).l,d0
	andi.w	#$1F,d0
	bne.w	.ex
	move.w	(pucky).w,d0
	sub.w	Ypos(a2),d0
	cmp.w	#$28,d0
	bgt.w	.ex
	cmp.w	#$FFD8,d0
	blt.w	.ex
	move.w	Xvel(a3),d0
	move.w	Yvel(a3),d1
	cmp.w	#$2000,d0				;.minv
	bgt.w	.bb
	cmp.w	#$E000,d0				;-.minv
	blt.w	.bb
	cmp.w	#$2000,d1
	bgt.w	.bb
	cmp.w	#$E000,d1
	blt.w	.bb
.ex									;exit: restore the registers
	movem.l	(sp)+,d0-d1
	rts
.bb									;inside the net bounds: bounce the player back (drop to checkgoal's
									;caller)
	adda.w	#$C,sp					;drop the saved d0-d1 and the return to checkgoalp:
									;return to checkgoal's caller
	asr.w	#2,d0
	asr.w	#2,d1
	move.w	d0,Xvel(a2)
	move.w	d1,Yvel(a2)
	clr.w	Xvel(a3)
	clr.w	Yvel(a3)
	bset	#sfslock,(sflags).w
	btst	#gmclock,(gmode).w
	bne.w	rtss2
	move.l	#8,d0
	bra.w	AddPenalty2
wallcollb							;Check for puck over wall. a3 = object, d0/d1 = cos/sin of the wall. Not
									;the puck, or Zpos up to $12 wallcoll. Zpos above $1D, or above $12 with
									;Ypos below $118: out of play.
									;Otherwise only at x $D-$F with
									;Yvel >= $FA0 (else wallcoll): halve Yvel, SPA $1078 on the next struct,
									;sfx $E and crowd, then out of play. Out of play: sfslock, pfnc, and while
									;the clock runs penalty 6 (PenOOP) for ltplayer. Called from checkwallcoll
	cmpi.w	#puckscnum,SCnum(a3)
	bne.w	wallcoll				;not puck so wall coll
	cmpi.w	#$1D,Zpos(a3)
	bgt.w	.0
	cmpi.w	#$12,Zpos(a3)
	bls.w	wallcoll
	cmpi.w	#$118,Ypos(a3)
	blt.w	.0
	cmpi.w	#$D,(a3)				;14, Xpos
	blt.w	wallcoll
	cmpi.w	#$F,(a3)				;15, Xpos
	bgt.w	wallcoll
	cmpi.w	#$FA0,Yvel(a3)
	blt.w	wallcoll
	move.l	a3,-(sp)
	asr.w	Yvel(a3)
	adda.w	#$80,a3					;next struct (SCstruct)
	move.w	#SPAbglass,d1
	bsr.w	SetSPA
	movea.l	(sp)+,a3
	move.w	#SFXbglass,-(sp)		;sfx $E
	bsr.w	sfx
	addi.w	#$258,(Crowdlevel).w
	addi.w	#$F,(CwdExciteLvl).w
.0									;glass break done: stop the screen and lock the puck
	bset	#sfslock,(sflags).w
	bset	#pfnc,pflags(a3)
	tst.w	Ypos(a3)
	bpl.w	.1
	ori.w	#$8000,attribute(a3)
.1									;clear the frame; nothing more after the whistle
	clr.w	frame+SCstruct(a3)
	btst	#gmclock,(gmode).w
	bne.w	rtss2
	move.l	a3,-(sp)
	move.w	(ltplayer).w,d0
	asl.w	#scsize,d0
	movea.w	#(SortCords-M68K_RAM),a3
	adda.w	d0,a3
	move.l	#PenOOP,d0
	bsr.w	AddPenalty2
	movea.l	(sp)+,a3
	rts
wallcoll							;d0 = cosine, d1 = sine of angle of incidence with wall, a3 = object.
									;Bounce a3 off the wall: the puck loses speed, flips and plays
									;sfx $28-$2B; a player sets the wall collision bit (unless sflags6 bit 4)
									;and plays SFXplayerwall on a hard hit. Called from checkgoal, checkgoalp
									;and wallcollb
	move.w	d0,Wallcos(a3)
	move.w	d1,Wallsin(a3)
	movem.l	d2-d3,-(sp)
	movem.w	d0-d1,-(sp)
	muls.w	Yvel(a3),d0
	muls.w	Xvel(a3),d1
	sub.l	d1,d0
	asr.l	#8,d0
	move.w	d0,d2
	movem.w	(sp),d0-d1
	muls.w	Xvel(a3),d0
	muls.w	Yvel(a3),d1
	add.l	d1,d0
	asr.l	#8,d0
	move.w	d0,d3
	neg.w	d2
	cmpi.w	#puckscnum,SCnum(a3)
	bne.w	.player
	bclr	#sf2shot,(sflags2).w
	tst.w	d2
	bpl.w	.nocoll
	asr.w	#2,d2					;reduce normal speed on puck
	cmp.w	#$FC00,d2
	bgt.w	.pok
	move.w	#$800,d0
	bsr.w	randomd0
	neg.w	d0
	move.w	d0,Zvel(a3)
	bsr.w	puckflip
	move.w	d2,d0					;sfx $28 + ((v1n >> 10) + 4) & 3
	asr.w	#8,d0
	asr.w	#2,d0
	addq.w	#4,d0
	bpl.w	.sf0
	clr.w	d0
.sf0								;sound index at least 0
	andi.w	#3,d0
	addi.w	#$28,d0
	move.w	d0,-(sp)
	bsr.w	sfx
.pok								;puck: cut the tangent speed
	move.w	d3,d0					;reduce tangent speed on puck
	asr.w	#6,d0
	sub.w	d0,d3
	asr.w	#1,d0
	sub.w	d0,d3
	bra.w	.noadd
.player								;player: wall collision unless checkgoalp set sflags6 bit 4
	cmp.w	#$3E8,d2
	bgt.w	.nocoll
	bclr	#4,(sflags6).w			;set by checkgoalp
	bne.w	.0
	bset	#pf3wall,pflags3(a3)	;set wall collision bit
.0									;wall collision sound
	cmp.w	#$F000,d2
	bgt.w	.nosfx
	cmpi.w	#$A,impact(a3)
	blt.w	.nosfx
	move.w	#SFXplayerwall,-(sp)
	bsr.w	sfx
.nosfx								;no wall sound: cut the normal speed to 1/4 (at least -1000)
	asr.w	#2,d2					;reduce normal speed on player to 1/4
	cmp.w	#$FC7C,d2
	blt.w	.noadd
	move.w	#$FC18,d2
.noadd								;rotate the speeds back into Xvel/Yvel
	movem.w	(sp),d0-d1				;rotate normal/tangent speeds (d2/d3) back into Xvel/Yvel
	movem.w	d2-d3,-(sp)
	muls.w	d0,d3
	muls.w	d1,d2
	sub.l	d2,d3
	asr.l	#8,d3
	move.w	d3,Xvel(a3)
	movem.w	(sp)+,d2-d3
	movem.w	(sp),d0-d1
	muls.w	d1,d3
	muls.w	d0,d2
	add.l	d2,d3
	asr.l	#8,d3
	move.w	d3,Yvel(a3)
	tst.w	Zvel(a3)
	bmi.w	.nocoll
	clr.w	Zvel(a3)
.nocoll								;done: drop the saved cos/sin
	addq.w	#4,sp					;drop saved cos/sin
	movem.l	(sp)+,d2-d3
	rts
checkpuckcoll_sfx					;Entered from checkpuckcoll. Puck in the air: sfx 5 once when sflags4 bit
									;2 is set
	bclr	#2,(sflags4).w
	beq.w	rtss2
	move.w	#5,-(sp)
	bra.w	sfx
checkpuckcoll						;look for puck coll with players. a3 = puck. Clears Yvel past the back
									;boards, then walks up and down the OOlist from the puck and runs .ccx on
									;each object within 22 in y: stick (puckstick), body (puckbody) or goalie
									;(puckgoalie). In a penalty shot only the shooter and the goalie touch the
									;puck, and the goalie reach comes from.cbg /.cbgsq by Agl. Entered from
									;pucknorm
	cmpi.w	#$190,Ypos(a3)			;compare 190 hex to Ypos (back board?)
	bgt.w	.resetYvel				;branch if greater than
	cmpi.w	#$FE70,Ypos(a3)			;compare -190 to Ypos (back board?)
	bgt.w	.setup					;branch if greater than
.resetYvel							;behind the boards: stop the y movement
	clr.w	Yvel(a3)
.setup								;puck on the ice (z 16 or less): check it against the players
	cmpi.w	#$10,Zpos(a3)			;compare 10 hex to Zpos (feet in air)
	bgt.s	checkpuckcoll_sfx
	move.w	SCnum(a3),d0			;move SCnum into d0
	asl.w	#1,d0					;current obj number
	movea.w	#(OOlistpos-M68K_RAM),a0
	movea.w	#(OOlist-M68K_RAM),a1
	movea.w	#(Ylist-M68K_RAM),a2
	move.w	0(a0,d0.w),d1			;current obj position in OOlist
.0									;loop
	cmp.w	#$F,d1					;15 = Total sprites -1
	beq.w	.cl						;it is top sprite on screen
	clr.w	d4
	move.b	1(a1,d1.w),d4			;next higher object number
	move.w	0(a2,d4.w),d5			;Y pos of next higher object
	sub.w	Ypos(a3),d5				;sub Ypos from d5
	cmp.w	#$16,d5					;16 = cbody + cstick
	bgt.w	.cl						;no higher sprite coll
	bsr.w	.ccx
	addq.w	#1,d1
	bra.s	.0
.cl									;d1 = $F or d5 > $16
	move.w	0(a0,d0.w),d1
	beq.w	.ex
.1									;loop
	clr.w	d4						;loop: examine the next lower object
	move.b	-1(a1,d1.w),d4			;next lower object number
	move.w	Ypos(a3),d5				;move Ypos into d5
	sub.w	0(a2,d4.w),d5			;sub Y pos of next lower object
	cmp.w	#$16,d5					;compare cbody+cstick to d5
	bgt.w	.ex
	bsr.w	.ccx
	subq.w	#1,d1
	bne.s	.1
.ex									;exit (also the end of the code above)
	rts
.ccx								;local subroutine
	movem.l	d0-d7/a0-a3,-(sp)		;d4 = object number * 2
	lsr.w	#1,d4
	cmp.w	(puckc).w,d4			;compare puckc to d4
	beq.w	.exit					;puck carrier
	cmp.w	#$B,d4					;compare 11 to d4
	bgt.w	.exit
	asl.w	#scsize,d4
	movea.w	#(SortCords-M68K_RAM),a2
	adda.w	d4,a2					;a2 now has address of player struct
	btst	#2,(BA_PS_flags).w
	beq.w	.ccx2					;branch if not set
	asr.w	#7,d4					;change d4 back to SCnum of puckc
	cmp.w	(BA_Sktr_SCnum).w,d4	;check d4 with SCnum of breakaway skater
	beq.w	.ccx2					;branch if the same
	cmp.w	(BA_Goalie_SCnum).w,d4	;check d4 with SCnum of breakaway goalie
	bne.w	.exit					;exit if not equal
.ccx2								;check the collision
	btst	#pfnc,pflags(a2)		;check if no player collision
	bne.w	.exit
	tst.b	nopuck(a2)				;check if nopuck collision
	bne.w	.exit					;branch if nopuck
	btst	#pf2unav,pflags2(a2)	;check if player unavailable
	bne.w	.chkbody
	cmpi.w	#5,Zpos(a3)				;compare 5 to Zpos
	bgt.w	.chkbody
	cmpi.w	#$200,Zvel(a3)			;compare 200 hex to Zvel
	bgt.w	.chkbody
	move.l	a2,-(sp)
	bsr.w	GetHot					;Get Hot Spot d0/d1 = x/y
	add.w	(a2),d0					;add Xpos a2
	sub.w	(a3),d0					;sub Xpos a3
	cmp.w	#$E,d0					;compare to cstick (E hex)
	bgt.w	.chkbody
	cmp.w	#$FFF2,d0
	blt.w	.chkbody				;branch if less than
	add.w	Ypos(a2),d1
	sub.w	Ypos(a3),d1
	cmp.w	#$E,d1
	bgt.w	.chkbody
	cmp.w	#$FFF2,d1
	blt.w	.chkbody				;branch if less than
	muls.w	d0,d0
	muls.w	d1,d1					;puck within stick reach (smaller while nopuck counts down): puckstick
	add.l	d1,d0					;add d1 to d0
	move.l	#$C4,d1					;move cstick squared to d1
	tst.b	nopuck(a3)				;check nopuck - puck not ready to be caught
	ble.w	.lo						;branch if less than or equal
	lsr.w	#2,d1					;not in stick reach: try the body (goalies use their own reach)
.lo									;stick reach check
	cmp.l	d1,d0					;compare d1 to d0
	bhi.w	.chkbody
	bsr.w	puckstick
	bra.w	.exit
.chkbody							;body check
	tst.w	position(a2)
	beq.w	.chkgoalie
	btst	#pf3onetimer,pflags3(a2)	;check if doing one timer
	bne.w	.exit
	move.w	(a2),d0					;Xpos into d0
	sub.w	(a3),d0					;sub Xpos a3
	cmp.w	#8,d0
	bgt.w	.exit
	cmp.w	#$FFF8,d0
	blt.w	.exit					;exit if less than
	move.w	Ypos(a2),d1
	sub.w	Ypos(a3),d1
	cmp.w	#8,d1
	bgt.w	.exit
	cmp.w	#$FFF8,d1
	blt.w	.exit					;exit if less than
	muls.w	d0,d0					;done with this player
	muls.w	d1,d1
	add.l	d1,d0					;add d1 to d0
	cmp.l	#$40,d0					;compare cbody squared to d0
	bhi.w	.exit
	bsr.w	puckbody
.ret								;(not branched to)
.exit								;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a3
	rts
.cbg								;Goalie body reach by Agl/2 (words, 0-$1E)
	dc.w	$C						;Agility 0 (rounded down to nearest even number)
	dc.w	$C						;2
	dc.w	$D						;4 (0.8 or 1)
	dc.w	$D						;6
	dc.w	$D						;8
	dc.w	$D						;10 (2 or 2.2)
	dc.w	$D						;12
	dc.w	$D						;14 (2.8 or 3)
	dc.w	$D						;16
	dc.w	$D						;18
	dc.w	$E						;20 (4 or 4.2)
	dc.w	$E						;22
	dc.w	$E						;24
	dc.w	$E						;26
	dc.w	$F						;28
	dc.w	$F						;30 (6)
	dc.w	$F						;32
	dc.w	$F						;34
	dc.w	$F						;36
	dc.w	$F						;38
.cbgsq								;Reach squared
	dc.w	$90
	dc.w	$90
	dc.w	$A9
	dc.w	$A9
	dc.w	$A9
	dc.w	$A9
	dc.w	$A9
	dc.w	$A9
	dc.w	$A9
	dc.w	$A9
	dc.w	$C4
	dc.w	$C4
	dc.w	$C4
	dc.w	$C4
	dc.w	$E1						;goalie: body reach from .cbg by leg strength (agility)
	dc.w	$E1
	dc.w	$E1
	dc.w	$E1
	dc.w	$E1
	dc.w	$E1
.chkgoalie							;goalie: body reach from agility
	move.l	a0,-(sp)
	movea.l	#.cbg,a0
	clr.w	d0
	move.b	legstr(a2),d0			;move Agl into d0
	btst	#1,(sflags8).w			;check if cwd meter broken (always is)
	bne.w	.boost
	btst	#6,(sflags7).w			;check if crowd meter currently broken
	beq.w	.joycont
.boost								;crowd meter boost
	addq.b	#2,d0
.joycont							;joystick goalie: fixed agility
	lsr.w	#1,d0
	btst	#pfjoycon,pflags(a2)	;check if joystick controlled
	beq.w	.calcagl
	move.w	#$F,d0					;move F into d0 (remove Agl)
.calcagl							;reach index
	add.w	d0,d0					;add d0 to itself
	btst	#0,(gmode2).w
	beq.w	.maxagl
	tst.w	d0						;check that d0 is 0
	beq.w	.maxagl
	subq.w	#2,d0					;sub 2 from d0
.maxagl								;reach index clamped
	cmp.w	#$1E,d0
	blt.w	.checkbody				;branch if less than
	move.w	#$1E,d0					;move 1E into d0
.checkbody							;body reach from the table
	move.w	0(a0,d0.w),(ChkBodyG).w
	movea.l	#.cbgsq,a0
	clr.l	(ChkBodySqG).w
	move.w	0(a0,d0.w),(ChkBodySqG+2).w
	move.w	(ChkBodyG).w,(NegChkBodyG).w
	neg.w	(NegChkBodyG).w
	btst	#1,(sflags6).w			;check if one timer
	beq.w	.2						;branch if not set
	move.w	#$C,(ChkBodyG).w
	move.l	#$90,(ChkBodySqG).w
	move.w	#$FFF4,(NegChkBodyG).w	;pad stack save animation: the wider body reach
.2									;pad stack?
	cmpi.w	#SPAgstackr,SPA(a2)		;check animation (pad stack)
	beq.w	.3
	cmpi.w	#SPAgstackl,SPA(a2)		;reach set: only a puck at z 15 or lower can hit the goalie
	bne.w	.4						;branch if not equal
.3									;pad stack: wider reach
	move.w	#$12,(ChkBodyG).w
	move.l	#$144,(ChkBodySqG).w
	move.w	#$FFEE,(NegChkBodyG).w
.4									;reach set
	movea.l	(sp)+,a0				;pop stack into a0
	cmpi.w	#$F,(puckz).w			;compare F to puckz
	bgt.w	.exit2
	move.w	(a2),d0					;Xpos into d0
	cmpi.w	#SPAgstackr,SPA(a2)		;pad stack right: offset -6 (mirrored for the net and the glove hand)
	beq.w	.neg
	cmpi.w	#SPAgstackl,SPA(a2)		;d1 = the pad offset for the facing and the net end
	bne.w	.8						;branch if not equal
	move.w	#6,d1					;move 6 into d1
	bra.w	.5
.neg								;facing the other way
	move.w	#$FFFA,d1				;move -6 into d1
.5									;pad offset for the net end
	btst	#pfgoal,pflags(a2)		;check which goal shooting at
	bne.w	.6						;add the pad offset to the goalie x
	neg.w	d1
.6									;goalie x minus puck x must be inside the body reach
	btst	#0,handed(a2)			;check bit zero of handedness
	beq.w	.7
	neg.w	d1
.7									;add the pad offset
	add.w	d1,d0					;add d1 to d0
.8									;goalie x minus puck x
	sub.w	(a3),d0					;sub Xpos a3 from d0
	cmp.w	(ChkBodyG).w,d0
	bgt.w	.exit2					;exit if greater than
	cmp.w	(NegChkBodyG).w,d0
	blt.w	.exit2					;exit if less than
	move.w	Ypos(a2),d1				;move Ypos into d1
	sub.w	Ypos(a3),d1				;sub Ypos a3 from d1
	cmp.w	(ChkBodyG).w,d1
	bgt.w	.exit2
	cmp.w	(NegChkBodyG).w,d1
	blt.w	.exit2					;exit if less than
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0					;no goalie hit: a missed shot plays the whiff sound once
	cmp.l	(ChkBodySqG).w,d0
	movem.w	(sp)+,d0-d1
	bhi.w	.exit2
	bsr.w	puckgoalie
	bra.w	.exit
.exit2								;missed the goalie
	bclr	#2,(sflags4).w
	beq.w	.exit					;exit if it was cleared already
	move.w	(puckc).w,d0			;move puckc into d0
	cmp.w	SCnum(a2),d0			;compare SCnum to d0
	beq.w	.exit
	move.w	#SFXshotwiff,-(sp)
	bsr.w	sfx
	bra.w	.exit
;	Puck contact routines (stick, glue, body, goalie, deflection) and the player list and setup code
;	that follows them, down to setplayer and ClampNibble. rtss2 is the shared rts.
;
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp /
;	cmpi; fixopcodes.js patches the cmp encoding after assembly.

;Sort struct (SortCords, SCstruct each) and team struct (tmstruct / awtmstruct): the fields are named in
;ram94.asm. setplayer writes the player attributes from weight to handed.

puckstick							;puck collides with stick. a2 = player who collided, a3 = puck, d0 =
									;distance^2 (from checkpuckcoll .ccx). A stick check on the puck carrier
									;can steal the puck (Stk rolls, smaller ranges when the carrier is in the
									;slot, sflags6 bit 5), else a slow enough puck is caught (puckglue); a
									;one-timer shoots it (onetimershot). Uses the slot ranges and the
									;skater, or no highlight: the stick takes the puck (steal check if someone
									;has it)
	tst.w	position(a2)			;a2 = player who collided
									;a3 = puck
	bne.w	.0						;branch if not goalie
	btst	#gmhl,(gmode).w
	bne.w	rtss2					;exit if so (goalie always lets the shot in)
.0									;clear offside
	bclr	#pfdoff,pflags(a2)
	move.w	(puckc).w,d1			;move puckc into d1
	bmi.w	.nosteal				;branch if no puck carrier
	asl.w	#7,d1
	movea.w	#(SortCords-M68K_RAM),a0
	adda.w	d1,a0					;a0 = Struct of puck carrier
	move.b	pflags(a0),d1
	move.b	pflags(a2),d2
	eor.w	d1,d2					;compare pflags of each player
	btst	#pfteam,d2				;check if on same team
	beq.w	rtss2					;no stealing from teammate
	btst	#5,(sflags6).w			;check if puckc is in slot
	beq.w	.noslot
	cmp.l	#$40,d0					;steal range met: goalies always steal, nobody steals from a goalie
	bhi.w	rtss2
	bra.w	.1
.noslot								;bit 5 of sflags6 clear
	cmp.l	#$24,d0
	bhi.w	rtss2
.1									;in range: goalie or skater
	tst.w	position(a2)			;check if colliding player is goalie
	beq.w	.steal
	tst.w	position(a0)
	beq.w	rtss2					;no stealing from goalie
.CheckStkForContactWithSkater		;(entry point inside puckstick). Stk for puckc
									;Stk for puckc
	move.b	stickhand(a0),d0
	lsr.b	#1,d0
	bsr.w	makepde					;adjust for energy level
	move.w	d0,-(sp)
	exg	a0,a2						;swap a2 and a0 (a0 now collider)
	move.b	stickhand(a0),d0		;Stk for collider
	lsr.b	#1,d0					;divie by 2
	bsr.w	makepde					;adjust for energy
	exg	a0,a2						;swap back (a0 now puckc)
	neg.w	d0
	add.w	(sp)+,d0				;add puckc modified Stk
	addi.w	#$24,d0					;add 24 hex (36 decimal)
	bsr.w	randomd0
	btst	#5,(sflags6).w			;check if puckc is in slot
	beq.w	.2
	cmp.w	#4,d0					;steal: the carrier cannot touch the puck for a while (stick handling,
									;energy)
	bhi.w	rtss2					;exit if higher (not losing puck)
	bra.w	.steal
.2									;bit 5 of sflags6 clear
	cmp.w	#2,d0					;compare 2 to d0
	bhi.w	rtss2					;exit if higher (not losing puck)
.steal								;steal check
	move.b	stickhand(a0),d0		;Stk of puckc
	lsr.b	#1,d0
	bsr.w	makepde					;adj for energy
	addi.w	#$14,d0					;add 14 hex (20 dec)
	move.b	d0,nopuck(a0)			;move result into nopuck (cant get puck timer)
	exg	a0,a2						;swap a0 and a2 (a0 now collider)
	move.b	stickhand(a0),d0		;Stk of collider
	lsr.b	#1,d0
	bsr.w	makepde					;adj for energy
	addi.w	#$14,d0					;add 14 hex (20 dec)
	move.b	d0,nopuck(a0)			;move result into nopuck
	exg	a0,a2
	move.w	SCnum(a0),(lastplayer).w	;SCNum of puckc into lastplayer
	bclr	#sfspdir,(sflags).w		;clear pass dir mode
	bclr	#sfssdir,(sflags).w		;clear shot dir mode
.stdef								;loop
	move.w	#SFXstdef,-(sp)
	bsr.w	sfx
	bsr.w	a2touchpuck				;deflect
	bra.w	deflect					;no carrier (goalie in the smaller range): one-timer check
.nosteal							;d1 negative
	tst.w	position(a2)
	bne.w	.onetimerchk
	cmp.l	#$40,d0
	bhi.w	rtss2					;smaller range for stealing puck
.onetimerchk						;one timer?
	btst	#pf3onetimer,pflags3(a2)
	beq.w	.nosteal2
	cmp.l	#$64,d0					;not a one-timer, or past its frame: catch or deflect by puck speed
	bhi.w	.3
	cmpi.w	#$18,SPAnum(a2)
	bge.w	.nosteal2
	move.w	#$18,SPAnum(a2)
	bset	#7,(sflags8).w
.nosteal2							;no steal: catch check
	move.w	(puckvx).w,d0			;d0 = puck speed^2, d1 = catch limit
	move.w	(puckvy).w,d1
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	clr.w	d1
	btst	#sf2shot,(sflags2).w	;check if shot was taken
	bne.w	.nohand
	btst	#pf3onetimer,pflags3(a2)	;check if one timer
	bne.w	.onetimer
.PlayerPassOrLoosePuckStkLoad		;(entry point inside puckstick)
	move.b	stickhand(a2),d1
	mulu.w	#$15E,d1
.nohand								;stick handling catch limit
	addi.w	#$32C8,d1
	mulu.w	d1,d1
	cmp.l	d1,d0
	bls.w	puckglue
	move.b	#8,nopuck(a2)
	bra.w	.stdef
.onetimer							;pf3onetimer set
	exg	a2,a3
	jsr	(onetimershot).l
	exg	a2,a3
	rts
.3									;d0 > $64
	cmp.l	#$144,d0
	bhi.w	.ex2
	cmpi.w	#$18,SPAnum(a2)
	bge.w	.ex2
	move.w	#$18,SPAnum(a2)
.ex2								;exit (also the end of the code above)
	rts
puckglue							;part of puckstick that puckgoalie also branches to. Player a2 takes the
									;puck: faceoff and pass stats, crowd song, goalie hold time (temp5), then
									;.setd0player
	move.w	#SFXpuckget,-(sp)
	move.w	SCnum(a2),d0			;move SCnum into d0
	move.w	d0,(puckc).w			;move d0 into puckc
	movea.w	#(tmstruct-M68K_RAM),a0	;Move Home Stats struct into a0
	lea	tmsize(a0),a1
	btst	#pfteam,pflags(a2)		;check if player is home or away
	bne.w	.tm
	exg	a0,a1
.tm									;team structs chosen
	st	tmtouch2(a0)				;FF into assist 1
	st	tmtouch3(a0)				;FF into assist 2
	bset	#tmflast,tmflags(a0)	;set a flag (not sure what)
	bclr	#sf3fo,(sflags3).w		;clear flag (not sure what, might have to do with faceoff)
	beq.w	.snd					;branch if it was cleared already
	addq.w	#1,tmfowon(a1)			;add 1 to faceoff won
	addi.w	#$C8,(Crowdlevel).w
	move.w	#$C,(sp)				;move C to stack
	cmpa.w	#(tmstruct-M68K_RAM),a1	;compare if a1 is home
	bne.w	.snd
	addi.w	#$A,(CwdExciteLvl).w
	move.w	#$B,(sp)				;Move B into stack
.snd								;play the song
	bsr.w	song
	move.w	SCnum(a2),d0			;move SCnum into d0
	cmp.w	(passReceiverPlayerNum).w,d0
	bne.w	.nrec					;branch if not equal
	addq.w	#1,tmpasscomp(a1)		;add 1 to pass completed
.nrec								;pass done
	st	(passReceiverPlayerNum).w
	bclr	#sfspdir,(sflags).w		;clear pass dir mode
	bclr	#sfssdir,(sflags).w		;clear shot dir mode
	tst.w	position(a2)			;check if a2 is goalie
	bne.w	.setd0player
	bsr.w	ChkShotStat
	move.w	#$8C,temp5(a2)			;move 8C to temp5 - countdown for faceoff?
	cmpi.w	#SPAgdive,SPA(a2)		;check for goalie dive animation
	bne.w	.setd0player			;branch if not equal
	move.w	#5,temp5(a2)			;set temp5 to 5
.setd0player						;Give control of player d0 to a controller if his team is controlled.
									;Checks the pads 3 and 4 too (cont3team / cont4team)
	cmp.w	(c1playernum).w,d0
	beq.w	rtss2					;exit if player controlled
	cmp.w	(c2playernum).w,d0
	beq.w	rtss2					;exit if player controlled
	tst.w	(cont3team).w
	beq.w	.cont4chk
	cmp.w	(c3playernum).w,d0
	beq.w	rtss2					;exit if player controlled
.cont4chk							;check pad 4
	tst.w	(cont4team).w
	beq.w	.0
	cmp.w	(c4playernum).w,d0
	beq.w	rtss2					;exit if player controlled
.0									;check the other pads
	tst.w	(cont3team).w
	bne.w	.1						;branch if no team
	tst.w	(cont4team).w
	beq.w	.setd0player2			;branch if no team
.1									;check the 3 / 4 player
	movem.l	d0/a3,-(sp)
	asl.w	#7,d0
	movea.l	#SortCords,a3
	tst.w	position(a3,d0.w)
	bne.w	.2
	btst	#3,pflags(a3,d0.w)		;check if d0 player controlled
	beq.w	.2
	movem.l	(sp)+,d0/a3				;exit if player controlled
	rts
.2									;pop the d0/a3 saved above
	movem.l	(sp)+,d0/a3
.setd0player2						;compare d0 with player 2
	cmp.w	#6,d0
	slt	d1
	ext.w	d1
	addq.w	#2,d1
	move.w	(lastplayer).w,d2
	cmp.w	(c2playernum).w,d2
	beq.w	.3
	cmp.w	(cont1team).w,d1
	bne.w	.3
	jmp	setc1player
.3									;d2 = c2playernum or d1 <> cont1team
	cmp.w	(cont2team).w,d1
	bne.w	.4
	jmp	setc2player
.4									;d1 <> cont2team
	cmp.w	(cont1team).w,d1
	bne.w	rtss2
	jmp	setc1player
puckbody							;puck hits player a2. a3 = puck, d0 = distance^2 (from checkpuckcoll
									;.ccx). The puck bounces off. A high puck (Zpos > 8) that is fast makes a2
									;fall (FallDown, Zpos > $C); a slower one starts SPAcatch on a2
	btst	#pf3onetimer,pflags3(a2)
	bne.w	rtss2					;real hit (low or near center): a2 touched the puck
	cmpi.w	#8,Zpos(a3)
	bgt.w	.hit
	move.w	d0,d1
	andi.w	#$F,d1					;radius^2 from center
	bne.w	rtss2
.hit								;puck hits the body
	bsr.w	a2touchpuck				;real hit: a2 touched the puck
	move.w	#SFXpuckbody,-(sp)
	bsr.w	sfx
	clr.w	Zvel(a3)
	move.b	#8,nopuck(a2)
	move.w	(a3),d0					;Xpos
	sub.w	(a2),d0
	move.w	Ypos(a3),d1
	sub.w	Ypos(a2),d1
	bne.w	.0
	move.l	a2,-(sp)
	bsr.w	GetHot
.0									;rebound off the body
	move.w	Xvel(a3),d2
	move.w	Yvel(a3),d3
	move.b	d0,Xvel(a3)
	move.b	d1,Yvel(a3)
	bsr.w	puckflip
	cmpi.w	#8,Zpos(a3)
	ble.w	rtss2
	muls.w	d2,d2
	muls.w	d3,d3
	add.l	d3,d2					;slow puck: a2 catches it (SPAcatch) unless locked
	cmp.l	#$9000000,d2			;fast puck
	bls.w	.1
	cmpi.w	#$C,Zpos(a3)
	bgt.w	FallDown
	rts
.1									;slow puck: stop it
	bset	#pfalock,pflags(a2)
	bne.w	rtss2
	move.w	#SPAcatch,d1
	exg	a2,a3
	bsr.w	SetSPA
	exg	a2,a3
rtss2								;shared rts
	rts
puckgoalie							;puck hits goalie a2. a3 = puck, d0/d1 = goalie - puck x/y. The save odds
									;come from the goalie's glove / stick attributes (.list) and the frame
									;tables .list2 (older goalie frames) and .list3 (frames from $292); a save
									;bounces the puck off (.bounceoff), a slow puck near the crease is held
									;(puckglue)
	btst	#gmhl,(gmode).w			;puck region: 2 when low (z 8 or under)
	bne.s	rtss2
	clr.w	d2						;puck region
	cmpi.w	#8,Zpos(a3)
	bgt.w	.1
	addq.w	#2,d2					;add 2 to d2
.1									;puck region set
	neg.w	d0
	neg.w	d1
	bsr.w	vtoa					;convert directions
	sub.w	facedir(a2),d0			;sub facedir into d0
	andi.w	#7,d0					;pass first 3 bits to d0
									;0 = puck straight in front of G
									;1-3 = puck to G right
									;4 = puck straight behind G
									;5-7 = puck to G left
	move.w	d0,d1					;move d0 into d1
	andi.w	#3,d1					;pass first 2 bits of d1
	bne.w	.2						;will branch if puck is to the left or right of G
	move.w	(HVcount).l,d0			;just for random bit
.2									;side of the goalie
	andi.w	#4,d0					;pass 3rd bit of d0. d0 will be either 4 (left) or 0 (right)
	lsr.w	#2,d0					;divide by 4. d0 will be either 1 (left) or 0 (right)
	eori.w	#1,d0					;XOR d0 - will make 1 a 0 (left), and 0 a 1 (right)
	add.w	d0,d2					;add to d2. d2 will now be 0 or 1 (Zpos > 8) or 2 or 3 (Zpos <= 8)
	add.w	d2,d2					;add d2 to itself. 0 Glove L, 2 Glove R, 4 Stick L, 6 Stick R
	lea	.list(pc),a0				;contains offsets for save attributes
	move.w	0(a0,d2.w),d0			;move from list into d0
	moveq	#$F,d1					;mirrored for flipped goalies; pick the save table by frame (old or new
									;goalie frames)
	add.b	0(a2,d0.w),d1			;save odds = save attribute + F (15 dec)
	lea	.list2(pc),a0
	btst	#3,attribute(a2)		;attribute a2 - x flip?
	beq.w	.3
	eori.w	#2,d2					;XOR d2 with 2
.3									;frame table index
	move.w	frame(a2),d0			;move frame into d0
	move.w	#SPFGoalie,-(sp)
	cmp.w	#SPFSiren,d0			;goal light frame, all frames before are goalie frames
	blt.w	.32						;branch if less than (old goalie frame)
	move.w	#SPFghighr,(sp)			;the newer goalie frames
	lea	.list3(pc),a0
.32									;frame offset
	sub.w	(sp)+,d0				;sub stack value (SPFGoalie) from d0
	move.b	0(a0,d0.w),d0			;move value from list2 or list3 at offset to d0
	lsr.w	d2,d0					;shift d0 by d2
	andi.w	#3,d0					;pass first 2 bits of d0
	bclr	#2,(sflags4).w			;clear bit 2 - this is not used anywhere, might have been a debug flag
	bsr.w	ChkShotStat				;fast shot (y speed over $3000): play the save song
	bsr.w	a2touchpuck
	cmpi.w	#$3000,(puckvy).w		;compare with puck velocity y
	bgt.w	.setsfx
	cmpi.w	#$D000,(puckvy).w		;compare -3000 with puckvy
	bgt.w	.nosong
.setsfx								;save sound
	move.w	#$B,-(sp)				;no song: the save sound, and the carrier loses the puck
	btst	#pfteam,pflags(a2)		;check home or away
	beq.w	.song
	move.w	#$D,(sp)				;away song
.song								;play the song
	bsr.w	song
.nosong								;puck sound
	move.w	#SFXpuckbody,-(sp)
	bsr.w	sfx
	move.w	(puckc).w,d2			;move puckc into d2
	bmi.w	.chkanim				;branch if no puckc
	st	(puckc).w
	asl.w	#7,d2
	movea.w	#(SortCords-M68K_RAM),a0
	adda.w	d2,a0
	move.b	#$14,nopuck(a0)			;carrier nopuck = 20
	move.w	SCnum(a0),(lastplayer).w
	bclr	#sfspdir,(sflags).w
	bclr	#sfssdir,(sflags).w
.bounceoff							;loop
	clr.w	Zvel(a3)
	move.b	#$A,nopuck(a2)			;move A into nopuck collision
	move.w	#4,temp4(a2)			;move 4 into temp4
	move.w	(a3),d0					;move puck Xpos into d0
	sub.w	(a2),d0					;sub Xpos of goalie from d0
	move.w	Ypos(a3),d1				;move puck Ypos into d1
	sub.w	Ypos(a2),d1				;sub Ypos of goalie from d1
	bne.w	.0						;branch if not equal
	move.l	a2,-(sp)
	bsr.w	GetHot
.0									;puck velocity
	move.b	d0,Xvel(a3)				;move d0 into puck Xvel
	move.b	d1,Yvel(a3)				;move d1 into puck Yvel
	bra.w	puckflip
	bset	#2,(sflags4).w			;not reached (after bra.w puckflip)
	rts
.chkanim							;d2 negative
	cmpi.w	#SPAgdive,SPA(a2)		;check for goalie dive animation
	beq.s	.bounceoff
	moveq	#2,d0					;move 2 into d0
	add.b	shotspd(a2),d0			;add puck control to d0
	asl.w	#8,d0
	asl.w	#1,d0
	bsr.w	randomd0
	addi.w	#$C00,d0				;add C00 to d0
	add.w	d0,d0
	bpl.w	.pos
	move.w	#$7FFF,d0				;make max positive
.pos								;speed clamped
	btst	#pf2aip,pflags2(a2)		;check if in animation
	bne.w	.chkpuckv
	cmpi.w	#$2C,(a3)				;compare 2C to Xpos of puck
	bgt.w	.chkpuckv				;branch if greater than
	cmpi.w	#$FFD4,(a3)
	blt.w	.chkpuckv				;branch if less than -2C
	cmpi.w	#$10E,Ypos(a3)			;compare 10E to puck Ypos
	bgt.w	.chkpuckv				;branch if greater than
	cmpi.w	#$FEF2,Ypos(a3)			;close to the net: a quarter of the speed is enough to bounce
	blt.w	.chkpuckv				;branch if less than
	cmpi.w	#$D2,Ypos(a3)			;compare the puck speed with the bounce limit
	bgt.w	.closepuck				;branch if greater than
	cmpi.w	#$FF2E,Ypos(a3)			;compare -D2 to Ypos
	bgt.w	.chkpuckv				;branch if greater than
.closepuck							;close puck: less speed
	asr.w	#2,d0
.chkpuckv							;puck fast enough to bounce?
	cmp.w	(puckvx).w,d0			;compare puckvx with d0
	blt.w	.bounceoff				;branch if less than
	cmp.w	(puckvy).w,d0			;compare puckvy to d0
	blt.w	.bounceoff				;branch if less than
	neg.w	d0						;negate d0, compare if shot going down
	cmp.w	(puckvx).w,d0
	bgt.w	.bounceoff				;branch if greater than
	cmp.w	(puckvy).w,d0
	bgt.w	.bounceoff				;branch if greater than
	btst	#pf2unav,pflags2(a2)	;check if player unavailable
	bne.w	.bounceoff
	clr.w	Zvel(a3)
	bra.w	puckglue				;goalie holds the puck
.list	dc.w	GGSleft,passacc		;save attribute offsets (92 had stickhand, shotacc)
	dc.w	spodds,endurance
.list2								;2 bit save odds per quadrant, one byte per goalie frame from SPFgoalie
									;odds for stopping puck in each quadrant for each possible goalie frame
	pix	1111,2131,1213				;ready/glover/glovel
	pix	1111,2131,1213
	pix	1111,2131,1213
	pix	1111,2131,1213
	pix	1111,2131,1213
	pix	1111,2131,1213
	pix	1111,2131,1213
	pix	1111,2131,1213
	pix	1111,1111					;goalie swing
	pix	1111,1111
	pix	1111,1111
	pix	1111,1111
	pix	1111,1111
	pix	1111,1111
	pix	1111,1111
	pix	1111,1111
	pix	1111,3300					;goalie stack right/left
	pix	1111,3300
	pix	1111,3300
	pix	1111,3300
	pix	1111,3300
	pix	1111,3300
	pix	1111,3300
	pix	1111,3300
	pix	1111,3300					;goalie stack left
	pix	1111,3300
	pix	1111,3300
	pix	1111,3300
	pix	3111,1311					;goalie stick right/left
	pix	3111,1311
	pix	3111,1311
	pix	3111,1311
	pix	3111,1311
	pix	3111,1311
	pix	3111,1311
	pix	3111,1311
	pix	1111,1111					;from here
	pix	1111,1111
	pix	1111,1111
	pix	1111,1111
	pix	1111,1111
	pix	1111,1111
	pix	1111,1111
	pix	1111,1111
	pix	1111,1111
	pix	1111,1111
	pix	1111,1111
	pix	1111,1111
	pix	1111,1111
	pix	1111,1111
	pix	1111,1111
	pix	1111,1111
	pix	3300,3300
	pix	3300,3300
	pix	3300,3300
	pix	3300,3300
	pix	3300,3300
	pix	3300,3300
	pix	3300,3300
	pix	3300,3300
	pix	1113,1113
	pix	1113,1113
	pix	2211,2211
	pix	2211,2211
	pix	2211,2211
	pix	2211,2211
	pix	2211,2211
	pix	2211,2211
	pix	2211,2211
	pix	2211,2211
	pix	2211,2211
	pix	2211,2211
	pix	2211,2211
	pix	2211,2211
.list3								;the same for the newer goalie frames from $292
	pix	2131,1213
	pix	2131,1213
	pix	2131,1213
	pix	2131,1213
	pix	2131,1213
	pix	2131,1213
	pix	2131,1213
	pix	2131,1213
	pix	3111,3111
	pix	1311,1311
	pix	3111,3111
	pix	1311,1311
	pix	3111,3111
	pix	1311,1311
	pix	3111,3111
	pix	1311,1311
	pix	3111,3111
	pix	1311,1311
	pix	3111,3111
	pix	1311,1311
	pix	3111,3111
	pix	1311,1311
	pix	3111,3111
	pix	1311,1311
deflect								;random puck direction on deflection, puck = a3. Entered from puckstick
	st	(puckc).w
	move.w	#$1000,d0
	bsr.w	randomd0s
	move.w	d0,Yvel(a3)
	move.w	#$1000,d0
	bsr.w	randomd0s
	move.w	d0,Xvel(a3)
	move.w	#$1000,d0
	bsr.w	randomd0
	move.w	d0,Zvel(a3)
	bra.w	puckflip
makepde								;pass d0 as value to be scaled by player a0's energy level (full energy
									;while sflags7 bit 4 is set). Return d0 as result
	ext.w	d0
	move.w	d0,-(sp)
	movem.l	d1/a2-a3,-(sp)
	movea.l	a0,a3
	bsr.w	getpde
	btst	#4,(sflags7).w
	beq.w	.0
	move.w	#$1000,d0
.0									;pop the d1/a2-a3 saved above
	movem.l	(sp)+,d1/a2-a3
	muls.w	(sp)+,d0
	asl.l	#4,d0
	swap	d0
	ext.l	d0						;d0 = d0 * energy / 4096
	rts
getpde								;get player a3's energy level into d0. Return a2 = his team struct, d1 =
									;pnum*2
	movea.w	#(tmstruct-M68K_RAM),a2
	btst	#pfteam,pflags(a3)		;#pfteam - home or away
	beq.w	.0
	adda.w	#tmsize,a2
.0									;roster offset
	move.b	pnum(a3),d1
	ext.w	d1
	add.w	d1,d1
	move.w	tmpde(a2,d1.w),d0
	rts
setpde								;d1 = rostnum of player * 2, a2 = team struct, d0 = new energy level (0 if
									;negative)
	tst.w	d0
	bpl.w	.0
	clr.w	d0
.0									;energy at least 0
	move.w	d0,tmpde(a2,d1.w)
	rts
setpersonel							;set personnel on team a2 from its registers (SetPlList), keeping players
									;already on the ice
	movem.l	d0-d5/a0-a4,-(sp)
	movea.w	tmsort(a2),a3
	moveq	#5,d4					;# of players on team for loop
.10									;clear each sort object
	st	newpos(a3)
	st	newpnum(a3)					;loop over PlList slots 5..0: find the wanted player already on the ice
	adda.w	#SCstruct,a3			;add size of player struct to a3
	dbf	d4,.10						;loop through each player on team
	bsr.w	SetPlList
	moveq	#5,d4
	movea.w	#(PlList-M68K_RAM),a4	;list of players we want on ice
.1									;each PlList slot
	clr.w	d5
	move.b	0(a4,d4.w),d5			;search the sort objects for player d5
	beq.w	.next
	subq.w	#1,d5
	moveq	#5,d3
	movea.w	tmsort(a2),a3
	suba.w	#SCstruct,a3			;sub player struct size from a3
.2									;each sort object
	adda.w	#SCstruct,a3			;add player struct size to a3
	cmp.b	pnum(a3),d5				;next PlList slot
	dbeq	d3,.2					;loop through player structs while pnum != d5 (find player d5)
	bne.w	.next					;branches if player not found
	move.b	plpos(a4,d4.w),newpos(a3)	;move a4+d4+6 into newpos
	move.b	d5,newpnum(a3)			;second pass: put the players not on the ice into free sort objects
	clr.b	0(a4,d4.w)
.next								;next PlList slot
	dbf	d4,.1						;next PlList slot
	moveq	#5,d4
	movea.w	#(PlList-M68K_RAM),a4
.3									;each PlList slot, second pass
	clr.w	d5
	move.b	0(a4,d4.w),d5			;find a sort object with no requested player
	beq.w	.next2
	subq.w	#1,d5
	moveq	#5,d3
	movea.w	tmsort(a2),a3
	suba.w	#SCstruct,a3
.4									;first one without a position wins; the player goes there
	adda.w	#SCstruct,a3			;next sort obj
	tst.b	newpnum(a3)
	dbmi	d3,.4					;find a sort obj with no requested player
	bpl.w	.0
	movea.w	a3,a0
.0									;free slot found
	tst.w	position(a3)			;does this obj have a position yet?
	dbpl	d3,.4					;keep looking while that obj has no position
	move.b	plpos(a4,d4.w),newpos(a0)
	move.b	d5,newpnum(a0)
	clr.b	0(a4,d4.w)
.next2								;next PlList slot
	dbf	d4,.3						;next PlList slot
	movem.l	(sp)+,d0-d5/a0-a4
	rts
SetPlList							;create PlList of players who we want on the ice now. a2 = team struct.
									;Takes the current line (tmline) by priolist; an unavailable
									;player (in the box or injured, -3 / -4) is replaced from sublist, or from
									;the whole roster
	movea.w	#(PlList-M68K_RAM),a4
	clr.l	(a4)					;goalie present: use the position priority list from the start
	clr.w	4(a4)
	movea.l	#priolist,a0
	tst.w	tmgoalie(a2)
	bpl.w	.gin					;branch if theres a goalie
	addq.w	#1,a0					;add 1 to a0
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
	move.b	0(a0,d4.w),d5			;move position into d5
	move.b	0(a1,d5.w),0(a4,d4.w)
	move.b	d5,plpos(a4,d4.w)
	bne.w	.next
	moveq	#1,d3					;loop: replace injured or penalized players
	add.w	tmgoalie(a2),d3
	move.b	d3,0(a4,d4.w)
.next								;next position
	dbf	d4,.0
	moveq	#5,d4					;now check to see if player is available
.1									;each PlList slot
	move.b	0(a4,d4.w),d3
	beq.w	.next1
	ext.w	d3
	subq.w	#1,d3
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
	adda.w	0(a0,d0.w),a0			;move a0+d0 into a0
.s1									;loop
	clr.w	d0
	move.b	(a0)+,d0
	bmi.w	.error
	move.b	0(a1,d0.w),d0
	bsr.w	TryAddPlayerToList
	beq.s	.s1
.next1								;next PlList slot
	dbf	d4,.1
	rts
.error								;d0 negative
	jsr	(GetPlayerCount).l			;then try the players from d0 down
	move.w	d0,d3
.try								;loop
	move.w	d3,d0					;d0 = candidate player number, d3 counts down
	subq.w	#1,d3
	bmi.s	.next1					;none available
	bsr.w	TryAddPlayerToList
	beq.s	.try
	bra.s	.next1
TryAddPlayerToList					;d0 = player number (1 based), d4 = PlList slot. Put d0 in the slot if he
									;is on the bench or ice (not in the box, not injured) and not in PlList
									;yet; return d1 = 0 (Z set) if not
	move.w	d0,d1
	subq.w	#1,d0
	add.w	d0,d0
	tst.w	tmpdst(a2,d0.w)
	bgt.w	.0						;loop: is d1 already in PlList?
	cmpi.w	#$FFFD,tmpdst(a2,d0.w)
	beq.w	.0
	cmpi.w	#$FFFC,tmpdst(a2,d0.w)
	beq.w	.0
	moveq	#5,d0
.loop								;d1 not usable: return 0
	cmp.b	0(a4,d0.w),d1
	dbeq	d0,.loop
	beq.w	.0
	move.b	d1,0(a4,d4.w)
	rts
.0									;already in the list
	clr.w	d1
	rts
SetupPenaltyShot					;Penalty shot set up for team a2 (called from puckpenshot): the shooter
									;loop over the team: shooter plays center, goalie stays, others leave
	movem.l	d0-d5/a0-a3,-(sp)
	movea.w	tmsort(a2),a3
	moveq	#5,d4
.loop								;each sort object
	move.w	SCnum(a3),d0
	cmp.w	(BA_Sktr_SCnum).w,d0
	beq.w	.0
	cmp.w	(BA_Goalie_SCnum).w,d0
	beq.w	.1
	bset	#2,pflags2(a3)			;set player unavailable
	move.w	#$20,d0					;assgoaliebreakwait
	bsr.w	assreplace
	bra.w	.3
.0									;d0 = BA_Sktr_SCnum
	bsr.w	Setplass
	move.b	newpnum(a3),(savednewpnum).w
	move.b	(BA_Skater_Offset+1).w,newpnum(a3)	;put the player on the ice
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
	st	newpnum(a3)
	st	newpos(a3)
	adda.w	#$80,a3
	dbf	d4,.loop
	movem.l	(sp)+,d0-d5/a0-a3
	rts								;loop over the team: apply the requested position and player
forcepldata							;no skating on/off: force players to correct data (for faceoffs only). a2
									;= team struct
	movem.l	d0-d4/a0-a3,-(sp)
	movea.w	tmsort(a2),a3			;22 offset of team struct is tmsort (address of first sort obj)
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
	move.l	#$11,d0					;$11 = anearest
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
	st	newpnum(a3)					;set newpnum to FF
	st	newpos(a3)					;set newpos to FF
	adda.w	#SCstruct,a3			;move to next sortobj (player struct)
	dbf	d4,.top
	movem.l	(sp)+,d0-d4/a0-a3
	rts
ResetBench							;remove all players from penalty box / put all players on their own bench
									;(not the injured, -3 / -4). Counts the players left in the box in PBnum
									;(home in the high nibble). .rb runs for the home team, then falls in for
									;the visitors
	clr.b	(PBnum).w
									;H = home players in PB
									;V = away players in PB
	moveq	#$10,d1
	movea.w	#(tmstruct-M68K_RAM),a0
	bsr.w	.rb
	moveq	#1,d1
	adda.w	#tmsize,a0				;change to Away Team
.rb									;local subroutine
	moveq	#$32,d0					;$32 = (MaxRos-1)*2 = 50 decimal
.rb1								;loop
	add.b	d1,(PBnum).w
	tst.w	tmpdst(a0,d0.w)
									;check and see which players are in the box
									;(-2=bench, -1=ice, 0+=pen box)
									;starts from end of list and works backwards through loop
	ble.w	.cont
	btst	#4,tmpdst(a0,d0.w)		;test 3rd bit in tmpdst (4 decimal)
	beq.w	.next					;not in the box: mark on the bench unless injured
	move.w	tmpdst(a0,d0.w),d2		;move tmpdst into d2
	andi.w	#$7FF,d2				;mask 7FF with d2. Passes lowest 11 bits
	bne.w	.next
	sub.b	d1,(PBnum).w
	bra.w	.next
.cont								;penalty over: back to the bench
	sub.b	d1,(PBnum).w
	cmpi.w	#$FFFD,tmpdst(a0,d0.w)	;compare -3 with tmpdst
	beq.w	.next
	cmpi.w	#$FFFC,tmpdst(a0,d0.w)	;compare -4 with tmpdst
	beq.w	.next
	move.w	#$FFFE,tmpdst(a0,d0.w)	;move -2 into tmpdst
.next								;previous roster entry
	subq.w	#2,d0					;previous roster entry
	bpl.s	.rb1
	rts
Setplass							;set players (a3) initial assignment from .alist by position
	move.w	position(a3),d0
	bmi.w	rtss2
	lea	.alist(pc),a0
	move.b	0(a0,d0.w),d0
	bra.w	assreplace
.alist	dc.b	$E					;assgoalie
									;assgoalie??
	dc.b	2						;assdefd
	dc.b	2						;assdefd
	dc.b	3						;asswingd
	dc.b	5						;asscenterd
	dc.b	3						;asswingd
	dc.b	5						;asscenterd
	dc.b	$FF
setplayer							;bring player onto the ice and set his attributes. d3 = offset of player
									;on roster, a3 = sortcord of player. Reads the roster bytes through
									;AttributeCalc (attribute number in TempWord2). Adds the PP / PK, home /
									;away and third period bonuses (team ScoutReport bytes) to some attributes
									;and clamps them with ClampNibble
	bclr	#pf2inj,pflags2(a3)		;clear line change mode? (I believe pflags2 are 1 off because of fighting
									;missing)
	movea.w	#(tmstruct-M68K_RAM),a0	;Start of Team Struct
	btst	#pfteam,pflags(a3)		;checks if home or away (if 0, home)
	beq.w	.0
.AwayTeam							;(entry point inside setplayer)
									;$364 = size of Team Struct
	adda.w	#tmsize,a0
.0									;roster offset
	move.b	d3,pnum(a3)				;move d3 into pnum (offset on roster)
	move.l	#$A,d0					;$A = #aepen
	ext.w	d3
	add.w	d3,d3					;= asl #1,d3. Accomplishes the same. Doubles d3
	move.w	tmpdst(a0,d3.w),d1		;move tmpdst(a0, d3) into d1
	bpl.w	.da						;from the penalty box
	move.l	#9,d0					;assben
	cmp.w	#$FFFE,d1				;not from the box or bench: clear the slot status, then read the team data
	bne.w	.nda
.da									;box or bench exit assignment
	bsr.w	assinsert				;enter the penalty box / bench exit assignment d0
	bclr	#pfalock,pflags(a3)
	clr.w	SPA(a3)
.nda								;free his slot
	move.w	#$FFFF,tmpdst(a0,d3.w)	;clear out temp space
	lsr.w	#1,d3					;shift d3 back to its original value
	movea.l	tmdata(a0),a0			;tmdata: the address of the team's data
									;(roster, etc)
	move.l	a0,-(sp)				;pushes starting position onto the stack
	adda.w	ScoutReport(a0),a0		;moves to offset where Off/Def byte is
	clr.l	(PPBonus).w
	tst.w	position(a3)
	beq.w	.playdatamove
	btst	#sf2pwrplay,(sflags2).w	;might be checking for a PP
	beq.w	.habonus				;penalty kill: minus the high nibble of the PP/PK byte
	bsr.w	chkpk2					;prob determines what team is PP or PK
	beq.w	.pk
	move.b	srpppk(a0),(PPBonus).w	;moves PP/PK byte into PPBonus
	andi.b	#$F,(PPBonus).w			;passes lower nibble of PP/PK byte (bug)
	bra.w	.habonus				;home / away advantage: home gets the high nibble, away minus the low one
.pk									;penalty kill bonus
	move.b	srpppk(a0),d0			;moves PP/PK byte into d0
	lsr.b	#4,d0					;shifts d0.b 4 places, to remove the lower nibble
	neg.b	d0						;switches value to negative (because its a PK, its negative bonus)
	move.b	d0,(PKBonus).w			;move d0 into PKBonus
.habonus							;home / away bonus
	move.b	srhomeaway(a0),d0		;This is location of Home/Away adv
	andi.b	#$F,d0					;pass the lower nibble (Away) to d0
	neg.b	d0						;make d0 negative (away disadvantage)
	btst	#pfteam,pflags(a3)		;check if player is home or away
	bne.w	.3rdperbonuscheck
	move.b	srhomeaway(a0),d0		;player is home, move Home/Away byte back in to d0
	lsr.b	#4,d0					;Shift d0 4 places right, to move upper nibble into d0
.3rdperbonuscheck					;home / away bonus set
	move.b	d0,(HmAwBonus).w		;move d0 into HA bonus
	cmpi.w	#2,(gsp).w				;Check if period is 3rd or OT
	blt.w	.playdatamove			;late in the game: the leading team gets the 3rd period bonus
	bgt.w	.chklead
	jsr	(GetPeriodTime).w
	lsr.w	#1,d0					;divide by 2 (5 min length = 2:30)
	cmp.w	(gameclock).w,d0		;compare to game clock
	bgt.w	.playdatamove			;branch if d0 greater than gameclock (bug)
.chklead							;tied or trailing?
	move.w	(HmGoals).w,d0
	sub.w	(AwGoals).w,d0			;HmGoals-AwGoals
	beq.w	.load3pbonus
	btst	#pfteam,pflags(a3)		;Check if home or away
	beq.w	.home
	eori	#8,ccr					;If Aw team, checks if N flag is set from HmGoals-AwGoals.
									;a0 = this player's data in the team roster
.home								;leading: no bonus
	bpl.w	.playdatamove			;loop: skip to player d3
.load3pbonus						;tied or trailing late: third period bonus
	move.b	#2,(ThirdPBonus).w		;move 2 into 3rd Per Bonus
.playdatamove						;find the player's data
	movea.l	(sp)+,a0				;moves Team Data start to a0
	adda.w	(a0),a0					;moves to player data offset (byte 0 and 1 of Team Data)
.skiploop							;skip each player before d3
	adda.w	(a0),a0					;skips the player's name length (current byte is name length)
	addq.w	#pldsize,a0				;skips players attributes
	dbf	d3,.skiploop				;loops until current player index is met (which was stored in d3)
	subq.w	#pldsize,a0				;Jump back to start of players attributes
	move.b	(a0),rostnum(a3)		;Jersey Number (pldnum)
	move.b	pldweight(a0),d3		;move weight / leg power byte to d3
	andi.w	#$F0,d3					;Mask Wgt nibble
	lsr.w	#1,d3					;shift d3 1 bit right (This is taking Wgt and mult by 8)
	move.b	d3,weight(a3)			;store in player struct
	move.b	pldweight(a0),d3		;move weight / leg power byte to d3
	andi.b	#$F,d3					;mask leg power nibble (legstr)
	move.w	#3,(TempWord2).w
	jsr	(AttributeCalc).l			;attribute math and add hot/cold
	move.b	d3,legstr(a3)			;move leg power byte (legstr) to player struct
	move.b	pldlegspd(a0),d3		;load Spd/OfA byte to d3
	lsr.b	#4,d3					;remove OfA nibble by shifting 4 bits right, moving Spd into lower nibble
	move.w	#4,(TempWord2).w
	jsr	(AttributeCalc).l
	move.b	d3,legspd(a3)			;move Spd byte into player struct
	move.b	pldlegspd(a0),d3		;move Spd/OfA byte to d3
	andi.b	#$F,d3					;mask d3 and pass only OfA nibble
	move.w	#5,(TempWord2).w
	jsr	(AttributeCalc).l
	add.b	(PPBonus).w,d3			;add Bonsuses to OfA
	add.b	(PKBonus).w,d3
	add.b	(HmAwBonus).w,d3
	add.b	(ThirdPBonus).w,d3
	bsr.w	ClampNibble
	lsr.b	#1,d3					;shift right 1 bit (divide by 2)
	eori.b	#$F,d3					;XOR d3 with F
	addi.b	#$F,d3					;add F to d3
	lsr.b	#1,d3
	move.b	d3,aioff(a3)			;OfA byte = (30-((OfA + Bonuses)/2))/2
	move.b	pldaidef(a0),d3			;move DfA/ShP byte to d3
	lsr.b	#4,d3					;see above
	move.w	#6,(TempWord2).w
	jsr	(AttributeCalc).l
	add.b	(HmAwBonus).w,d3
	bsr.w	ClampNibble
	lsr.b	#1,d3
	eori.b	#$F,d3
	addi.b	#$F,d3
	lsr.b	#1,d3
	move.b	d3,aidef(a3)			;same math and formula as OfA
	move.b	pldaidef(a0),shotspd(a3)
	andi.b	#$F,shotspd(a3)
	move.b	shotspd(a3),d3
	move.w	#7,(TempWord2).w
	jsr	(AttributeCalc).l
	move.b	d3,shotspd(a3)			;ShP does not get any bonuses
	move.b	pldcheck(a0),d3			;move Chk/Hnd byte into d3
	lsr.b	#4,d3
	move.w	#8,(TempWord2).w
	jsr	(AttributeCalc).l
	add.b	(ThirdPBonus).w,d3		;Chk gets 3rd P bonus only
	bsr.w	ClampNibble
	move.b	d3,checking(a3)			;move Chk into player struct
	bclr	#3,attribute(a3)		;clear bit 3 in attribute of player struct
	move.b	pldcheck(a0),handed(a3)	;move Chk/Hnd byte to Hnd in player struct
	andi.b	#1,handed(a3)			;Hnd bit
	eori.b	#1,handed(a3)			;XOR Hnd byte with 1. Sets to opposite what the bit was.
									;So L will be a 1 and R will be a 0
	bne.w	.attribloadcont
	bset	#3,attribute(a3)		;right handed: attribute bit 3 set (flipped sprite)
.attribloadcont						;load the rest of the attributes
	move.b	pldcheck(a0),fighting(a3)	;moves Chk/Hnd byte into Fgt byte in player struct
	andi.b	#$E,fighting(a3)		;mask the byte with E, ignoring the Hnd bit - will always be even
	move.b	pldstick(a0),d3			;move Stk/ShA byte into d3
	lsr.b	#4,d3
	move.w	#$A,(TempWord2).w
	jsr	(AttributeCalc).l
	add.b	(PPBonus).w,d3
	add.b	(PKBonus).w,d3
	add.b	(HmAwBonus).w,d3
	bsr.w	ClampNibble
	move.b	d3,stickhand(a3)		;Stk gets PP/PK/Tm Bonus
	move.b	pldstick(a0),d3
	andi.b	#$F,d3
	move.w	#$B,(TempWord2).w
	jsr	(AttributeCalc).l
	add.b	(PPBonus).w,d3
	add.b	(PKBonus).w,d3
	add.b	(HmAwBonus).w,d3
	bsr.w	ClampNibble
	move.b	d3,shotacc(a3)			;ShA gets PP/PK/Tm Bonus
	move.b	pldendur(a0),d3			;move End/PS Bias byte into d3
	lsr.b	#4,d3
	move.w	#$C,(TempWord2).w
	jsr	(AttributeCalc).l
	move.b	d3,endurance(a3)		;End gets no bonuses
	move.b	pldendur(a0),d3
	andi.b	#$F,d3
	move.w	#$D,(TempWord2).w
	jsr	(AttributeCalc).l
	add.b	(ThirdPBonus).w,d3
	add.b	(ThirdPBonus).w,d3
	bsr.w	ClampNibble
	move.b	d3,spodds(a3)			;PS Bias gets a double 3rd P bonus
	move.b	pldpass(a0),d3			;move Pas/Agr byte into d3
	lsr.b	#4,d3
	move.w	#$E,(TempWord2).w
	jsr	(AttributeCalc).l
	add.b	(PPBonus).w,d3
	add.b	(HmAwBonus).w,d3
	bsr.w	ClampNibble
	move.b	d3,passacc(a3)			;Pas gets PP and Tm bonus
	move.b	pldpass(a0),aggress(a3)	;moves Pas/Agr into Agr byte in player struct
	move.b	aggress(a3),d3			;moves Pas/Agr byte into d3 (weird way to do it)
	andi.b	#$F,d3
	move.w	#$F,(TempWord2).w
	jsr	(AttributeCalc).l
	move.b	d3,aggress(a3)			;Agr gets no bonus
	andi.b	#$F,aggress(a3)			;mask Agr byte with F, so max is 15 decimal
	rts
ClampNibble							;Clamp byte d3 to 0-$1E (93 clamped to 0-15). Called by setplayer
	tst.b	d3						;test if d3 is zero or higher
	bpl.w	.pos
	clr.w	d3
.pos								;clamp the top
	cmp.b	#$1E,d3
	ble.w	.withinlimits
	move.w	#$1E,d3					;if higher, set to 1E
.withinlimits						;exit (also the end of the code above)
	rts
