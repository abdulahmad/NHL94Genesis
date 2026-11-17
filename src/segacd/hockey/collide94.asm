checkcoll						;d2 = new x coord, d3 = new y coord, a3 = struct of object. Check wall
									;collision (around the hot spot and the end of the stick) and player
									;collisions, then move a3 in the OOlist sort order by its y. If a player
									;collision set collflag, restore the old x/y instead. Called from
									;updateplayers
	clr.w	(collflag).l
	btst	#$7,(sflags).l		;check if in horiz mode
	beq.w	.nhor1		;branch if not horizontal
	exg.l	d2,d3
.nhor1	btst	#$2,$62(a3)		;check if in no collision mode
	bne.w	.ex		;branch if no collision
	movem.l	d0-d7,-(sp)
	move.w	$0(a3),d2		;Xpos
	move.w	$14(a3),d3		;Ypos - check coll around hot spot with wall
	move.w	$4A(a3),(wcradiusx).l
	move.w	$4C(a3),(wcradiusy).l
	bsr.w	checkwallcoll
	move.w	$4E(a3),d0
	or.w	$50(a3),d0
	bne.w	.xx		;coll didnt happen
	cmpi.w	#$B,$52(a3)		;check if a3 is a player
	bgt.w	.xx		;branch if not a player
	movem.l	(sp),d0-d7
	move.l	a3,-(sp)
	bsr.w	GetHotCount
	move.w	$0(a3),d2		;Xpos
	move.w	$14(a3),d3
	add.w	d0,d2
	add.w	d1,d3		;check coll around end of stick with wall
	move.w	#$1,(wcradiusx).l
	move.w	#$1,(wcradiusy).l
	bsr.w	checkwallcoll
.xx	movem.l	(sp)+,d0-d7
	bsr.w	checkplcoll		;check coll with other players
.ex	tst.w	(collflag).l		;now check order of sprites
	bne.w	.restoreold
	move.w	$52(a3),d0
	asl.w	#$1,d0		;current object number
	movea.l	#OOlistpos,a0
	movea.l	#OOlist,a1
	movea.l	#Ylist,a2
	move.w	(a0,d0.w),d1		;current objects pos in OOlist
.loop	cmpi.w	#$F,d1		;Sortobjs-1
	beq.w	.cl2		;is it top sprite on screen
	clr.w	d4
	move.b	$1(a1,d1.w),d4		;next higher object number
	cmp.w	(a2,d4.w),d3		;YPos of next higher object
	ble.w	.cl2
	addq.w	#$1,(a0,d0.w)
	subq.w	#$1,(a0,d4.w)
	move.b	d4,(a1,d1.w)		;next higher object into this entry
	move.b	d0,$1(a1,d1.w)		;this object into the next entry
	addq.w	#$1,d1
	bra.w	.loop
.cl2	move.w	(a0,d0.w),d1		;current objects pos in OOlist
	beq.w	.ex2
.3	clr.w	d4
	move.b	-$1(a1,d1.w),d4		;next lower object number
	cmp.w	(a2,d4.w),d3		;compare to Y pos of next lower object
	bge.w	.ex2
	subq.w	#$1,(a0,d0.w)
	addq.w	#$1,(a0,d4.w)
	move.b	d4,(a1,d1.w)		;next lower object into this entry
	move.b	d0,-$1(a1,d1.w)		;this object into the previous entry
	subq.w	#$1,d1
	bne.w	.3
.ex2	move.w	d3,(a2,d0.w)		;update Ylist
	rts
.restoreold	move.w	$1C(a3),$0(a3)		;move OldXpos into Xpos
	move.w	$20(a3),$14(a3)		;move OldYpos into Ypos
	rts
checkplcoll						;check collision with other players. d2/d3 = x/y cords, a3 = struct. Walk
									;up and down the OOlist from a3 and call checkcx for each object within
									;$10 in y. Called from checkcoll
	btst	#$5,$63(a3)		;no player collision?
	bne.w	.ex
	cmpi.w	#$B,$52(a3)
	bgt.w	.ex
	move.w	$52(a3),d0
	asl.w	#$1,d0		;current object number
	movea.l	#OOlistpos,a0
	movea.l	#OOlist,a1
	movea.l	#Ylist,a2
	move.w	(a0,d0.w),d1		;current objects pos in OOlist
.loop	cmpi.w	#$F,d1		;#sortobjs-1
	beq.w	.cl		;it is top sprite on screen
	clr.w	d4
	move.b	$1(a1,d1.w),d4		;next higher object number
	move.w	(a2,d4.w),d5		;y pos of next higher object
	sub.w	d3,d5
	cmpi.w	#$10,d5
	bgt.w	.cl		;no higher sprite coll
	bsr.w	checkcx
	addq.w	#$1,d1
	bra.w	.loop
.cl	move.w	(a0,d0.w),d1
	beq.w	.ex
.1	clr.w	d4		;loop: lower neighbours
	move.b	-$1(a1,d1.w),d4		;next lower object number
	move.w	d3,d5
	sub.w	(a2,d4.w),d5		;y pos of next lower object
	cmpi.w	#$10,d5
	bgt.w	.ex
	bsr.w	checkcx
	subq.w	#$1,d1
	bne.w	.1
.ex	rts
checkcx						;d4 = obj. # * 2 for possible collision so check x range and distance for
									;collision. d2 = x, d5 = delta y, a3 = moving object. Opposing players add
									;impact and run newcheck, checkint, checkcheck and checkfight (an rts);
									;then momentum moves from a3 to a2. Called from checkplcoll
	movem.l	d0-d7/a0-a3,-(sp)
	asl.w	#$6,d4
	movea.l	#SortCords,a2
	adda.w	d4,a2		;add d4 to a2. a2 now address of SCStruct-1
	btst	#$2,$62(a2)		;test pfnc pflags = no collision mode
	bne.w	.exit		;object has no collision mode on
	btst	#$5,$63(a2)		;pf2npc(pflags2) = another no collision mode
	bne.w	.exit		;exit if no collision mode on
	cmpi.w	#$B,$52(a2)		;comparing 11 with SCnum for player. Player SCnum are 0-11.
	bgt.w	.exit
	move.w	$0(a2),d0		;Xpos
	btst	#$7,(sflags).l		;sfhor(sflags) = screen in horizontal mode
	beq.w	.nhor		;branch if not in horiz mode
	move.w	$14(a2),d0
.nhor	sub.w	d2,d0		;subtract d2 from d0
	cmpi.w	#$FFF0,d0		;compare delta Xpos to -collrad*2
	blt.w	.exit		;branch if less than
	cmpi.w	#$10,d0		;compare delta Xpos to collrad*2
	bgt.w	.exit		;branch if greater than
	muls.w	d5,d5
	muls.w	d0,d0
	add.l	d5,d0
	cmpi.l	#$100,d0		;compare d0 to (collrad*2)*(collrad*2)
	bgt.w	.exit		;branch if outside of radius
	move.w	#$0,(evalue).l		;evalue = elasticity value
	move.b	$62(a3),d6		;move pflags into d6
	move.b	$62(a2),d0		;move pflags into d0
	eor.b	d0,d6		;xor d0 with d6
	move.w	$28(a3),d0		;Now do momentum transfer from object a3 to object a2 Xvel
	sub.w	$28(a2),d0		;subtract Xvel a2 from Xvel a3 (Vx)
	move.w	$2A(a3),d1
	sub.w	$2A(a2),d1		;subtract Yvel a2 from Yvel a3 (Vy)
	move.w	$0(a3),d2		;Xpos
	sub.w	$0(a2),d2		;subtract Xpos of a2 from Xpos of a3
	neg.w	d2
	move.w	$14(a3),d3
	sub.w	$14(a2),d3		;subtract Ypos of a2 from Ypos of a3
	neg.w	d3
	movem.w	d0-d1,-(sp)
	muls.w	d3,d1
	muls.w	d2,d0
	add.l	d0,d1
	bmi.w	.exit4		;no collision if v1n < 0
	asr.l	#$4,d1
	btst	#$6,d6
	beq.w	.not		;players are on same team
	move.w	d1,d4
	lsr.w	#$8,d4
	cmpi.w	#$5,d4
	bgt.w	.g40
	moveq	#$5,d4		;minimum impact value
.g40	add.w	d4,$32(a3)
	add.w	d4,$32(a2)
	btst	#$0,$63(a2)
	bne.w	.if
	move.w	$52(a3),$2E(a2)		;SCnum(a3), impactp(a2) = moves a3 SCnum into past impact player for a2
.if	btst	#$0,$63(a3)
	bne.w	.next4
	move.w	$52(a2),$2E(a3)		;SCnum(a2), impactp(a3) = moves a2 SCnum into past impact player for a3
.next4	cmpi.w	#$14,d4		;impact under 20: no check sound
	blt.w	.n1
	move.w	(puckc).l,d0		;check sound only if one of them has the puck
	cmp.w	$52(a3),d0
	beq.w	.nc
	cmp.w	$52(a2),d0
	bne.w	.n1
.nc	bsr.w	newcheck
.n1	bsr.w	checkint		;interference, check and fight tests
	bsr.w	CheckIntBothSides
	bsr.w	setInjuryTypeExit
.not	move.w	d1,d4
	movem.w	(sp)+,d0-d1
	tst.w	(collflag).l		;set to -1 by holdcheck / Bcheck: no transfer
	bmi.w	.exit
	muls.w	d2,d1
	muls.w	d3,d0
	sub.l	d1,d0
	asr.l	#$4,d0
	move.w	d0,d5
	clr.w	d0
	move.b	$67(a3),d0		;wgt, m1 in calc below
	addi.w	#$8C,d0
	clr.w	d1
	move.b	$67(a2),d1		;wgt, m2 in calc below
	addi.w	#$8C,d1
	move.w	(evalue).l,d7
	mulu.w	d1,d7
	lsr.w	#$4,d7
	add.w	d0,d1
	sub.w	d7,d0
	muls.w	d4,d0
	divs.w	d1,d0
	move.w	(evalue).l,d1
	muls.w	d4,d1
	asr.w	#$4,d1
	add.w	d0,d1
	movem.w	d2-d3,-(sp)
	muls.w	d5,d3
	muls.w	d0,d2
	add.l	d2,d3
	asr.l	#$4,d3
	add.w	$28(a2),d3
	move.w	d3,$28(a3)
	movem.w	(sp),d2-d3
	muls.w	d5,d2
	muls.w	d0,d3
	sub.l	d2,d3
	asr.l	#$4,d3
	add.w	$2A(a2),d3
	move.w	d3,$2A(a3)
	movem.w	(sp)+,d2-d3		;Pop d2 and d3 off stack
	muls.w	d1,d2
	asr.l	#$4,d2
	add.w	d2,$28(a2)
	muls.w	d1,d3
	asr.l	#$4,d3
	add.w	d3,$2A(a2)
	st.b	(collflag).l
.exit	movem.l	(sp)+,d0-d7/a0-a3
	rts
.exit4	addq.w	#$4,sp
	bra.w	.exit
newcheck						;start a new check sound: one of 4 sounds $1C-$1F, never the last one
									;again. Called from checkcx; FallDown branches here when the player who
									;fell did not have the puck
	move.l	d0,-(sp)
	moveq	#$3,d0
	bsr.w	randomd0
	addq.w	#$1,d0		;1-3 sounds on from the last one
	add.w	(ltack).l,d0
	andi.w	#$3,d0
	move.w	d0,(ltack).l
	addi.w	#$1C,d0		;first check sound (92 used 18)
	move.w	d0,-(sp)
	bsr.w	sfx
	move.l	(sp)+,d0
	rts
checkint						;check for interference penalty. player a2 interferes with a3 or
									;vice-versa; goalie is only player who can cause an interference call.
									;Called from checkcx
	move.l	d0,-(sp)
	bsr.w	.ci
	exg.l	a2,a3
	bsr.w	.ci
	exg.l	a2,a3
	move.l	(sp)+,d0
	rts
.ci	tst.w	$34(a2)
	bne.w	rtss2		;exits if not goalie
	btst	#$0,(gmode).l		;test gmclock(gmode). Is there play
	bne.w	rtss2		;no fall downs during celebration
	move.w	(puckc).l,d0		;Puck carrier's SCnum
	cmp.w	$52(a3),d0		;SCnum of this struct
	beq.w	.minimpact		;jump if a3 carrying puck
	cmpi.w	#$19,$32(a3)		;compare $19 to impact
	ble.w	rtss2		;exit if less than or equal
.minimpact	cmpi.w	#$2,$32(a3)		;compare 2 to impact
	ble.w	rtss2		;exit if impact is less than 2
	exg.l	a2,a3
	bsr.w	FallDown
	exg.l	a2,a3
	cmpi.w	#$1E,$32(a2)		;compare 30 decimal to impact
	ble.w	rtss2		;exit if impact is less than 30 decimal
	btst	#$4,$63(a3)		;pf2pen(pflags2) - Check if player already committed a penalty
	bne.w	rtss2		;exit if player is already penalized
	tst.w	$34(a2)
	bne.w	rtss2		;double check to make sure player is goalie
	move.w	#$1,d0		;set d0 to team1 value
	btst	#$6,$62(a3)		;check if home or away
	beq.w	.control		;jump if home (team1)
	move.w	#$2,d0		;set d0 to team2 value
.control	cmp.w	(cont1team).l,d0
	beq.w	.playercont
	cmp.w	(cont2team).l,d0
	bne.w	.checky		;branch if controlled by CPU
.playercont	btst	#$3,$62(a3)		;pfjoycon - check if player controlled
	beq.w	rtss2		;exit if not player controlled
.checky	move.w	$14(a2),d0
	btst	#$7,$62(a2)		;pfgoal - 0 shooting bottom, 1 shooting top
	beq.w	.next6
	neg.w	d0		;negative d0 if shooting bottom
.next6	cmpi.w	#$EF,d0		;compare to Ypos. Looks like it compares to both ends of crease
	blt.w	rtss2
	cmpi.w	#$10A,d0
	bgt.w	rtss2
	move.w	$0(a2),d0		;Xpos
	cmpi.w	#$14,d0		;compare Xpos to goalpost
	bgt.w	rtss2
	cmpi.w	#$FFEC,d0		;compare Xpos to goalpost
	blt.w	rtss2
	move.w	#$28,d0
	sub.b	$73(a3),d0
	bsr.w	randomd0
	cmpi.w	#$4,d0		;d0 = RNG(28-aggres)
	bhi.w	rtss2
	btst	#$4,(gmode).l		;Check if highlight, exit if so
	bne.w	rtss2
	moveq	#$22,d0
	bra.w	AddPenalty
; Runs the check for both a3 and a2.
CheckIntBothSides	movem.l	d0-d4/a0-a3,-(sp)
	bsr.w	.next
	exg.l	a2,a3
	bsr.w	.next
	movem.l	(sp)+,d0-d4/a0-a3
	rts
.next	cmpi.w	#$C90,$58(a2)
	beq.w	holdcheck
	cmpi.w	#$1122,$58(a2)
	beq.w	holdcheck
	cmpi.w	#$B24,$58(a2)
	beq.w	Bcheck
	cmpi.w	#$C5E,$58(a3)
	bne.w	rtss2
	btst	#$0,(gmode).l
	beq.w	.next2
	move.w	#$100,$32(a3)
	move.w	#$100,$32(a2)
.next2	move.w	$0(a2),d0
	sub.w	$0(a3),d0
	move.w	$14(a2),d1
	sub.w	$14(a3),d1
	bsr.w	vtoa
	sub.w	$54(a3),d0
	andi.w	#$7,d0
	btst	#$3,$4(a3)
	beq.w	.next3
	neg.w	d0
	addi.w	#$8,d0
	andi.w	#$7,d0
.next3	asl.w	#$1,d0
	lea.l	checkagr(pc),a0
	move.w	(a0,d0.w),d1
	bset	#$5,$62(a3)
	bsr.w	SetSPA
	tst.w	$34(a2)
	beq.w	rtss2
	cmpi.w	#$14,d4
	blt.w	rtss2
	moveq	#$78,d0
	btst	#$3,$62(a3)
	beq.w	.next4
	asl.w	#$1,d0
.next4	sub.b	$67(a3),d0
	add.b	$67(a2),d0
	lsr.w	#$1,d0
	exg.l	a2,a3
	jsr	(PlayerCardDrawPortrait).l
	exg.l	a2,a3
	sub.w	$32(a2),d0
	beq.w	.next5
	bmi.w	.next5
	btst	#$4,$64(a3)
	bne.w	.next5
	bsr.w	randomd0
	clr.w	(TempWord1).l
	move.b	$75(a3),$17E63.l
	lsr.w	(TempWord1).l
	cmp.b	$17E63.l,d0
	ble.w	.next5
	bsr.w	CheckAggressionScale
	cmpi.w	#$4,d0
	bhi.w	rtss2
	btst	#$4,(gmode).l
	bne.w	rtss2
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.w	#$1C,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	move.b	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	andi.w	#$2,d0
	addi.w	#$16,d0
	jsr	(PenShotChk).l
	bra.w	AddPenalty
.next5	bsr.w	CheckAggressionScale
	cmpi.w	#$3,d0
	bhi.w	.next6
	btst	#$4,(gmode).l
	bne.w	.next6
.loop4	btst	#$7,$FF800E.l
	bne.b	.loop4
	move.w	#$1C,$FF8020.l
	bset	#$6,$FF800F.l
.loop5	btst	#$6,$FF800E.l
	beq.b	.loop5
	move.b	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop6	btst	#$6,$FF800E.l
	bne.b	.loop6
	bclr	#$7,$FF800F.l
	andi.w	#$2,d0
	addi.w	#$1A,d0
	bsr.w	PenShotChk
	bsr.w	AddPenalty
.next6	bra.w	FallDown
checkagr						;use Agression attribute and RNG to determine if there will be a penalty.
									;a3 = checking player, a2 = player being checked. d0 =
									;randomd0(((40 - Agr) / 2) * 13), doubled for a joystick player, halved
									;within $28 of the puck in x and y.
									;Then: a2 on a breakaway rolls randomd0 again, of 8 / 7 / 4 / 3 by a2's
									;distance in y from the goal line; and d0 = $7F (no penalty) while the
									;other team has a delayed penalty (DelayedPen). The callers call a penalty
									;when d0 is small. Called from CCStart, holdcheck and Bcheck
	bclr	d5,(a6)
	movep.l	d5,$C2C(a0)
; Instruction bytes inside checkagr that the assembler would encode differently, kept as words (2 rows).
	dc.w	$0C2C,$0C2C,$0BFA
	dc.w	$0BFA,$0B96
; Scales the aggression value from $73.
CheckAggressionScale
	move.w	#$28,d0
	sub.b	$73(a3),d0
	lsr.b	#$1,d0
	mulu.w	#$D,d0
	btst	#$3,$62(a3)
	beq.w	.next
	asl.w	#$1,d0
.next	move.w	$0(a3),d1
	sub.w	(puckx).l,d1
	cmpi.w	#$28,d1
	bgt.w	.next2
	cmpi.w	#$FFD8,d1
	blt.w	.next2
	move.w	$14(a3),d1
	sub.w	(pucky).l,d1
	cmpi.w	#$28,d1
	bgt.w	.next2
	cmpi.w	#$FFD8,d1
	blt.w	.next2
	asr.w	#$1,d0
.next2	bsr.w	randomd0
	btst	#$1,$64(a2)
	beq.w	.next5
	move.w	$14(a2),d1
	bpl.w	.next3
	neg.w	d1
.next3	subi.w	#$108,d1
	neg.w	d1
	move.w	#$8,d0
	cmpi.w	#$75,d1
	bgt.w	.next4
	move.w	#$7,d0
	cmpi.w	#$3A,d1
	bgt.w	.next4
	move.w	#$4,d0
	cmpi.w	#$2C,d1
	bgt.w	.next4
	move.w	#$3,d0
.next4	bsr.w	randomd0
.next5	btst	#$6,$62(a3)
	bne.w	.next6
	btst	#$2,(DelayedPen).l
	bne.w	.next7
	bra.w	.ex
.next6	btst	#$1,(DelayedPen).l
	beq.w	.ex
.next7	move.w	#$7F,d0
.ex	rts
holdcheck
	btst	#$5,$62(a3)
	bne.w	rtss2
	tst.w	$34(a3)
	beq.w	rtss2
	btst	#$0,$63(a3)
	bne.w	rtss2
	move.w	$0(a3),d0
	sub.w	$0(a2),d0
	move.w	$14(a3),d1
	sub.w	$14(a2),d1
	bsr.w	vtoa
	sub.w	$54(a2),d0
	addi.w	#$1,d0
	andi.w	#$7,d0
	cmpi.w	#$2,d0
	bhi.w	rtss2
	move.w	(puckc).l,d0
	cmp.w	$52(a3),d0
	bne.w	.holdcheck
	bclr	#$3,(sflags).l
.holdcheck	move.w	$28(a3),d0
	add.w	$28(a2),d0
	asr.w	#$1,d0
	move.w	d0,$28(a3)
	move.w	d0,$28(a2)
	move.w	$2A(a3),d0
	add.w	$2A(a2),d0
	asr.w	#$1,d0
	move.w	d0,$2A(a3)
	move.w	d0,$2A(a2)
	bset	#$5,$62(a3)
	move.w	#$CF4,d1
	bsr.w	SetSPA
	exg.l	a2,a3
	bset	#$5,$62(a3)
	move.w	#$CC2,d1
	cmpi.w	#$C90,$58(a3)
	beq.w	.setanimation
	move.w	#$1154,d1
.setanimation	bsr.w	SetSPA
	bsr.w	CheckAggressionScale
	cmpi.w	#$6,d0
	bhi.w	.next4
	btst	#$4,(gmode).l
	bne.w	.next4
	move.w	#$24,d0
	cmpi.w	#$CC2,$58(a3)
	beq.w	.addpen
	move.w	#$1E,d0
.addpen	jsr	(PenShotChk).l
	bsr.w	AddPenalty
.next4	exg.l	a2,a3
	st.b	(collflag).l
	rts
Bcheck
	btst	#$5,$62(a3)
	bne.w	rtss2
	tst.w	$34(a3)
	beq.w	rtss2
	btst	#$0,$63(a3)
	bne.w	rtss2
	tst.w	(OptPen).l
	bne.w	.checkdir
	btst	#$3,$62(a2)
	beq.w	.checkdir
	moveq	#$20,d0
	add.b	$75(a2),d0
	sub.b	$68(a3),d0
	btst	#$1,(sflags8).l
	bne.w	.next
	btst	#$6,(sflags7).l
	beq.w	.rnd
.next	subi.b	#$2,d0
.rnd	bsr.w	randomd0
	cmpi.w	#$18,d0
	blt.w	rtss2
.checkdir	move.w	$0(a3),d0
	sub.w	$0(a2),d0
	move.w	$14(a3),d1
	sub.w	$14(a2),d1
	bsr.w	vtoa
	sub.w	$54(a2),d0
	addi.w	#$1,d0
	andi.w	#$7,d0
	cmpi.w	#$2,d0
	bhi.w	rtss2
	exg.l	a2,a3
	bsr.w	FallDown
	bsr.w	CheckAggressionScale
	cmpi.w	#$4,d0
	bhi.w	.next4
	move.w	#$20,d0
	jsr	(PenShotChk).l
	bsr.w	AddPenalty
.next4	exg.l	a2,a3
	st.b	(collflag).l
	rts

FallDown
	cmpi.w	#$B,$52(a2)
	bgt.w	rtss2
	cmpi.w	#$145C,$58(a2)
	beq.w	rtss2
	cmpi.w	#$1AF4,$58(a2)
	beq.w	rtss2
	cmpi.w	#$11E6,$58(a2)
	beq.w	rtss2
	cmpi.w	#$D26,$58(a2)
	beq.w	rtss2
	cmpi.w	#$DD8,$58(a2)
	beq.w	rtss2
	cmpi.w	#$136A,$58(a2)
	beq.w	rtss2
	cmpa.l	(PlayerChked).l,a2
	bne.w	.cont
	cmpa.l	(PlayerChking).l,a3
	bne.w	.cont
	rts
.cont	move.l	a2,(PlayerChked).l
	move.l	a3,(PlayerChking).l
	btst	#$3,$64(a2)
	bne.w	rtss2
	btst	#$3,$64(a3)
	bne.w	rtss2
	move.w	#$11E6,d1
	btst	#$4,$64(a3)
	bne.w	.cont2
	cmpi.b	#$18,$71(a2)
	blt.w	.cont2
	tst.b	$5F(a2)
	bne.w	.cont2
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	andi.w	#$F,d0
	addi.w	#$10,d0
	cmp.w	$32(a2),d0
	ble.w	.cont2
	move.b	#$3C,$5F(a2)
	bra.w	FallDownStart
.cont2	tst.w	$34(a3)
	beq.w	.chkpos
	movea.l	#tmstruct,a0
	btst	#$6,$62(a3)
	beq.w	.next3
	adda.w	#$366,a0
.next3	addi.w	#$1,$10(a0)
	clr.w	d0
	move.b	$66(a3),d0
	adda.w	d0,a0
	addi.b	#$1,$11E(a0)
	addi.w	#$1,$180EC.l
	tst.b	$74(a3)
	bne.w	.chkpos
	addi.w	#$2,$180EC.l
.chkpos	move.b	#$78,$5E(a2)
	move.w	$0(a3),d0
	sub.w	$0(a2),d0
	move.w	$14(a3),d1
	sub.w	$14(a2),d1
	bsr.w	vtoa
	tst.w	$34(a2)
	beq.w	FallDownSpeed
	jsr	(PlayerCardDrawPortrait).l
	btst	#$4,$64(a2)
	beq.w	FallDownSpeed
	movem.l	d1-d4,-(sp)
	move.w	$28(a2),d1
	bpl.w	.yvel
	neg.w	d1
.yvel	move.w	$2A(a2),d2
	bpl.w	.chkpos2
	neg.w	d2
.chkpos2	move.w	$0(a2),d3
	sub.w	$0(a3),d3
	move.w	$14(a2),d4
	sub.w	$14(a3),d4
	cmpi.w	#$108,$14(a3)
	bgt.w	.bnet1
	cmpi.w	#$FEF8,$14(a3)
	blt.w	.bnet2
	tst.w	$0(a3)
	bpl.w	.posx
	tst.w	d3
	bpl.w	.chktowardcenterice
	cmpi.w	#$FFFD,d3
	bgt.w	.chktowardcenterice
	bra.w	.chkawayfromcenterice
.posx	tst.w	d3
	bmi.w	.chktowardcenterice
	cmpi.w	#$3,d3
	blt.w	.chktowardcenterice
	bra.w	.chkawayfromcenterice
.bnet2	tst.w	d4
	bpl.w	.chktowardcenterice
	bra.w	.chkawayfromcenterice
.bnet1	tst.w	d4
	bmi.w	.chktowardcenterice
	bra.w	.chkawayfromcenterice
.chktowardcenterice	movem.l	(sp)+,d1-d4
	bra.w	FallDownSpeed
.chkawayfromcenterice	movem.l	(sp)+,d1-d4
	bra.w	.playerpos
.playerpos	cmpi.w	#$10C,$14(a2)
	bgt.w	.chkawayfrommiddle
	cmpi.w	#$FEF4,$14(a2)
	blt.w	.chkawayfrommiddle
	cmpi.w	#$68,$0(a2)
	bgt.w	.chkawayfrommiddle
	cmpi.w	#$FF98,$0(a2)
	blt.w	.chkawayfrommiddle
	bra.w	FallDownSpeed
.chkawayfrommiddle	cmpi.w	#$B,$52(a3)
	bgt.w	.0
	addi.w	#$A,(CwdExciteLvl).l
	addi.w	#$96,(Crowdlevel).l
	move.w	d1,-(sp)
	move.b	#$0,$40(a3)
	move.b	#$0,$65(a3)
	move.w	#$1AC2,d1
	jsr	(SetSPA).l
	clr.w	$28(a3)
	clr.w	$2A(a3)
	move.w	(sp)+,d1
.0	movem.l	d0/a0,-(sp)
	cmpi.w	#$10C,$14(a2)
	bgt.w	.playerabovetopgoalline
	cmpi.w	#$FEF4,$14(a2)
	blt.w	.playerbelowbottomgoalline
	tst.w	$0(a2)
	bmi.w	.playerleftofcenter
	move.w	#$2,d0
	bra.w	.getchkanim
.playerleftofcenter	move.w	#$6,d0
	bra.w	.getchkanim
.playerabovetopgoalline	move.w	#$0,d0
	bra.w	.getchkanim
.playerbelowbottomgoalline	move.w	#$4,d0
.getchkanim	add.w	d0,d0
	movea.l	#$3AD3A,a0
	move.w	(a0,d0.w),d1
	move.w	$14(a2),(FallYPos).l
	move.w	$0(a2),(FallXPos).l
	cmpi.w	#$18CC,d1
	bne.w	.next19
	cmpi.w	#$59,$14(a2)
	bgt.w	.next19
	cmpi.w	#$FFA7,$14(a2)
	blt.w	.next19
	move.w	d0,-(sp)
	move.w	#$7,d0
	jsr	(StartArenaAnim).l
	move.w	(sp)+,d0
	move.w	#$193E,d1
	btst	#$3,$4(a2)
	beq.w	.6
	move.w	#$1A00,d1
	bra.w	.6
.next19	cmpi.w	#$17E8,d1
	bne.w	.4
	cmpi.w	#$38,$14(a2)
	bgt.w	.4
	cmpi.w	#$FFC8,$14(a2)
	blt.w	.4
	move.w	#$1A00,d1
	btst	#$3,$4(a2)
	beq.w	.6
	move.w	#$193E,d1
	bra.w	.6
.4	btst	#$3,$4(a2)
	beq.w	.6
	cmpi.w	#$17E8,d1
	beq.w	.5
	cmpi.w	#$18CC,d1
	bne.w	.6
	move.w	#$17E8,d1
	bra.w	.6
.5	move.w	#$18CC,d1
.6	clr.w	$28(a2)
	clr.w	$2A(a2)
	bset	#$5,$64(a2)
	bset	#$0,$62(a2)
	movem.l	(sp)+,d0/a0
	bra.w	FallDownCheckStage
; Data that follows FallDown (strings, small tables)
FallDownData	dc.w	$1776,$1776,$17E8,$17E8,$185A,$185A,$18CC,$18CC
; FallDown: computes the slide speed
FallDownSpeed
	move.w	#$DD8,d1
	sub.w	$54(a2),d0
	addi.w	#$1,d0
	andi.w	#$7,d0
	cmpi.w	#$2,d0
	bls.w	FallDownStart
	move.w	#$D26,d1
; FallDown: checks the fall stage
FallDownCheckStage
	move.w	$54(a2),d0
	andi.w	#$3,d0
	bne.w	FallDownStart
	cmpi.b	#$14,$75(a3)
	blt.w	FallDownStart
	cmpi.w	#$B,$52(a3)
	bgt.w	FallDownStart
	btst	#$5,$64(a2)
	bne.w	FallDownStart
	move.w	#$136A,d1
; FallDown: starts the fall animation
FallDownStart
	exg.l	a2,a3
	bset	#$5,$62(a3)
	bsr.w	SetSPA
	exg.l	a2,a3
	tst.w	$34(a3)
	beq.w	.next
	tst.w	$34(a2)
	beq.w	.next
	addi.w	#$12C,(Crowdlevel).l
	addi.w	#$F,(CwdExciteLvl).l
.next	move.w	(puckc).l,d0
	bmi.w	newcheck
	cmp.w	$52(a2),d0
	bne.w	newcheck
	st.b	(puckc).l
	btst	#$4,(gmode).l
	bne.w	.next3
	cmpi.w	#$DD8,$58(a2)
	bne.w	.next3
	move.w	$54(a2),d0
	andi.w	#$3,d0
	bne.w	.next3
	btst	#$4,$63(a2)
	bne.w	.next3
	move.l	#$A0,d0
	bsr.w	randomd0
	cmp.w	$32(a2),d0
	bgt.w	.next3
	btst	#$0,(gmode).l
	bne.w	.next3
	exg.l	a2,a3
	move.w	#$145C,d1
	bsr.w	SetSPA
	exg.l	a2,a3
	bsr.w	setInjuryType
	btst	#$5,(sflags7).l
	bne.w	.next2
	exg.l	a2,a3
	move.w	#$1AF4,d1
	bsr.w	SetSPA
	exg.l	a2,a3
.next2	move.w	#$4,$1806A.l
	moveq	#$14,d0
	tst.w	$34(a3)
	beq.w	AddPenalty2
	tst.w	(OptPen).l
	beq.w	AddPenalty2
	moveq	#$12,d0
	bsr.w	AddPenalty2
	bra.w	Stop4Pen
.next3	move.w	#$B,-(sp)
	btst	#$6,$62(a2)
	bne.w	.next4
	move.w	#$C,(sp)
.next4	bsr.w	sfx
	rts
setInjuryType						;determines if injury will be for period or game. a2 = player injured, a3
									;= player checking. Marks a2 unavailable, pumps up the crowd, plays sfx
									;$D, locks the scroll on a2 and sets TempPlOffset (pnum, bit 15 set for
									;the away team). a2's tmpdst becomes $FFFD (injured for the period) or,
									;from a3's Fgt byte (getFgtbyte, chkFgtBit1), $FFFC (injured for the game,
									;sflags7 bit 5). Called from FallDown
	move.w	d0,-(sp)
	bset	#$2,$63(a2)
	addi.w	#$12C,(Crowdlevel).l		;pump up crowd
	addi.w	#$1E,(CwdExciteLvl).l
	move.w	#$D,-(sp)
	bsr.w	sfx
	move.w	$0(a2),(xc1).l		;move Xpos to scroll center
	move.w	$14(a2),(yc1).l		;move Ypos to scroll center
	bset	#$6,(sflags).l		;set sfslock (scroll lock)
	clr.w	d1
	movea.l	#tmstruct,a0		;move Home team Struct to a0
	btst	#$6,$62(a2)		;check if player home or away
	beq.w	.0
	move.w	#$8000,d1		;move $8000 into d1
	adda.w	#$366,a0		;add $364 to a0 (Away Team Struct start)
.0	move.b	$66(a2),d1		;move roster offset into d1
	move.w	d1,(TempPlOffset).l
	ext.w	d1		;sign extend - in this case just makes upper bye of word 00
	add.w	d1,d1		;add d1 to itself
	exg.l	a2,a3		;swap a2 and a3
	jsr	(getFgtbyte).l		;get the Fgt byte (divided by 4)
	exg.l	a2,a3
	tst.w	d0		;check if d0 is zero
	bne.w	.not0		;branch if H/F was more than 3
	bclr	#$5,(sflags7).l		;clear injury game bit
	move.w	#$FFFD,$68(a0,d1.w)		;update status of player
	bra.w	.exit
.not0	cmpi.w	#$3,d0		;compare d0 to 3 (if H/F was 12, d0 = 3)
	beq.w	.injurygame
	bclr	#$5,(sflags7).l
	move.w	#$FFFD,$68(a0,d1.w)		;update status of player
	jsr	(GetFgtByteReturn).l		;check Fgt bit 1 of player.
	beq.w	.exit		;jump if Fgt not 2,6,A
.injurygame	bset	#$5,(sflags7).l		;set injury game bit
	move.w	#$FFFC,$68(a0,d1.w)		;update status of player
.exit	move.w	(sp)+,d0
	rts
setInjuryTypeExit
	rts
checkwallcoll						;d2/d3 = x/y to test, a3 = object, wcradiusx/wcradiusy = radius. Check the
									;corner circles, the goals (checkgoal with a2 = SortCords+(13*SCstruct)
									;top, SortCords+(12*SCstruct) bottom) and then the side and end boards.
									;Calls wallcollb on a hit, with d0/d1 = cos/sin of the wall. Called from
									;checkcoll
	bclr	#$4,$64(a3)
	move.w	#$88,d4
	sub.w	(wcradiusx).l,d4
	move.w	#$12A,d5
	sub.w	(wcradiusy).l,d5
	movem.w	d2-d5,-(sp)
	neg.w	d4
	neg.w	d5
	addi.w	#$40,d4		;corner circle radius 64
	addi.w	#$40,d5
	cmp.w	d5,d3
	bgt.w	.0
	cmp.w	d4,d2
	blt.w	.1
	neg.w	d4
	cmp.w	d4,d2
	bgt.w	.1
	movea.l	#$17B00,a2
	bsr.w	.next
	bra.w	.2
.0	neg.w	d5
	cmp.w	d5,d3
	blt.w	.2
	cmp.w	d4,d2
	blt.w	.1
	neg.w	d4
	cmp.w	d4,d2
	bgt.w	.1
	movea.l	#$17A80,a2
	bsr.w	.next
	bra.w	.2
.1	sub.w	d4,d2		;corner circle: d2/d3 = offset from the circle centre
	sub.w	d5,d3
	move.w	d3,d0
	move.w	d2,d1
	neg.w	d1
	muls.w	d3,d3
	muls.w	d2,d2
	add.l	d2,d3		;dist from dot
	cmpi.l	#$1000,d3		;inside the corner circle (64*64)
	bls.w	.2
	exg.l	d0,d3
	bsr.w	Sroot		;distance from the circle center
	exg.l	d0,d3
	ext.l	d0
	asl.l	#$8,d0
	divs.w	d3,d0
	ext.l	d1
	asl.l	#$8,d1
	divs.w	d3,d1
	bsr.w	wallcollb
.2	movem.w	(sp)+,d2-d5
	move.w	$4E(a3),d0		;wallcos: already hit
	or.w	$50(a3),d0
	bne.w	rtss2
	move.w	#$100,d0		;now check side walls
	clr.w	d1
	cmp.w	d5,d3
	bge.w	wallcollb
	neg.w	d5
	neg.w	d0
	cmp.w	d5,d3
	ble.w	wallcollb
	exg.l	d0,d1
	cmp.w	d4,d2
	bge.w	wallcollb
	neg.w	d4
	neg.w	d1
	cmp.w	d4,d2
	ble.w	wallcollb
	rts
.next	cmpi.w	#$D,$18(a3)
	bgt.w	rtss2
	cmpi.w	#$E,$52(a3)
	bne.w	checkgoalp
	sub.w	$0(a2),d2
	moveq	#$10,d4
	add.w	(wcradiusx).l,d4
	cmp.w	d4,d2
	bgt.w	rtss2
	neg.w	d4
	cmp.w	d4,d2
	blt.w	rtss2
	sub.w	$14(a2),d3
	move.w	#$2,d5
	add.w	(wcradiusy).l,d5
	cmp.w	d5,d3
	bgt.w	rtss2
	neg.w	d5
	cmp.w	d5,d3
	blt.w	rtss2
	st.b	(collflag).l
	cmpi.w	#$D,$24(a3)
	blt.w	.next2
	move.w	$24(a3),$18(a3)
	bra.w	.next9
.next2	bclr	#$7,$62(a3)
	move.w	(puckc).l,d0
	bmi.w	.next4
	st.b	(puckc).l
	asl.w	#$7,d0
	movea.l	#SortCords,a0
	move.b	#$8,$5E(a0,d0.w)
	move.w	(pucky).l,d1
	btst	#$7,$62(a0,d0.w)
	bne.w	.next3
	neg.w	d1
.next3	tst.w	d1
	bpl.w	.next4
	bset	#$7,$62(a3)
.next4	move.w	#$FF00,d0
	move.l	$14(a3),d1
	sub.l	$20(a3),d1
	asr.l	#$8,d1
	beq.w	.next10
	bmi.w	.next5
	neg.w	d0
	neg.w	d5
.next5	add.w	d3,d5
	move.l	$0(a3),d3
	sub.l	$1C(a3),d3
	asr.l	#$8,d3
	muls.w	d3,d5
	divs.w	d1,d5
	bvs.w	.next10
	sub.w	d5,d2
	cmp.w	d4,d2
	blt.w	.next10
	neg.w	d4
	cmp.w	d4,d2
	bgt.w	.next10
	clr.w	d1
	move.w	$14(a3),d3
	eor.w	d0,d3
	bmi.w	wallcoll
	neg.w	d0
	btst	#$7,$62(a3)
	bne.w	wallcoll
	cmpi.w	#$D,$18(a3)
	beq.w	.next6
	subi.w	#$1,d4
	cmp.w	d4,d2
	bgt.w	.next6
	neg.w	d4
	cmp.w	d4,d2
	bge.w	.next11
.next6	bsr.w	ChkShotStat
	move.w	#$25,-(sp)
	btst	#$0,(gmode).l
	bne.w	.next7
	move.w	#$8,(sp)
	addi.w	#$12C,(Crowdlevel).l
	addi.w	#$28,(CwdExciteLvl).l
.next7	bsr.w	sfx
	move.w	#$1000,d0
	bsr.w	randomd0
	tst.w	$14(a3)
	bmi.w	.next8
	neg.w	d0
.next8	move.w	d0,$2A(a3)
	move.w	#$1000,d0
	bsr.w	randomd0s
	move.w	d0,$28(a3)
	move.w	#$1000,d0
	bsr.w	randomd0s
	move.w	d0,$2C(a3)
	bra.w	puckflip
.next9	neg.w	$2C(a3)
	bpl.w	rtss2
	neg.w	$2C(a3)
	rts
.next10	clr.w	d0
	move.w	#$100,d1
	move.w	$0(a3),d2
	sub.w	$1C(a3),d2
	bmi.w	wallcoll
	neg.w	d1
	bra.w	wallcoll
.next11	btst	#$2,(BA_PS_flags).l
	beq.w	.next18
	btst	#$0,(gmode2).l
	bne.w	.next12
	movem.l	d0/a0,-(sp)
	move.w	(BA_Sktr_SCnum).l,d0
	asl.w	#$7,d0
	movea.l	#SortCords,a0
	adda.w	d0,a0
	btst	#$7,$62(a0)
	movem.l	(sp)+,d0/a0
	bne.w	.next13
	bra.w	.next14
.next12	tst.w	(shootoutteam).l
	bne.w	.next14
.next13	tst.w	(pucky).l
	bmi.w	rtss2
	bra.w	.next15
.next14	tst.w	(pucky).l
	bpl.w	rtss2
.next15	bset	#$5,$17F72.l
	tst.w	(shootoutteam).l
	beq.w	.next16
	addi.w	#$1,(awayshootgoals).l
	bra.w	.next17
.next16	addi.w	#$1,(homeshootgoals).l
.next17	bset	#$0,(sflags8).l
	jsr	(EndPenaltyShotPlay).l
	bra.w	.next19
.next18	btst	#$0,(gmode).l
	bne.w	rtss2
.next19	bset	#$0,$17F72.l
	bclr	#$3,(sflags8).l
	bsr.w	ChkShotStat
	jsr	(HockeyRtsStubB).l
	move.w	d0,-(sp)
	move.w	(ScoutSubStatus).l,d0
.loop	cmp.w	(ScoutSubStatus).l,d0
	beq.w	.loop
	move.w	(sp)+,d0
	move.w	#$0,-(sp)
	bsr.w	sfx
	jsr	(freezewindow).l
	addi.w	#$1F4,(Crowdlevel).l
	movea.l	#tmstruct,a2
	lea.l	$366(a2),a1
	tst.w	$14(a3)
	bpl.w	.next20
	exg.l	a1,a2
.next20	btst	#$1,(gmode).l
	beq.w	.next21
	exg.l	a1,a2
.next21	addi.w	#$1,$C(a2)
	btst	#$5,$17F72.l
	beq.w	.next22
	btst	#$0,(gmode2).l
	bne.w	.next22
	addi.w	#$1,$364(a2)
.next22	bclr	#$4,(gmode2).l
	beq.w	.next23
	addi.w	#$1,$35C(a2)
.next23	btst	#$5,(sflags2).l
	beq.w	.next25
	btst	#$6,(sflags2).l
	bne.w	.next24
	cmpa.l	#awtmstruct,a2
	bne.w	.next25
.loop2	addi.w	#$1,$358(a2)
	bra.w	.next25
.next24	cmpa.l	#tmstruct,a2
	beq.w	.loop2
.next25	movem.l	d0/a2,-(sp)
	move.w	(gsp).l,d0
	add.w	d0,d0
	adda.w	d0,a2
	addi.w	#$1,$344(a2)
	movem.l	(sp)+,d0/a2
	bclr	#$7,(sflags8).l
	beq.w	.next26
	addi.w	#$1,$360(a2)
.next26	cmpa.l	#tmstruct,a2
	bne.w	.next27
	move.w	(HomeTeam).l,(HmTeam).l
	move.w	#$3,(SongIndex).l
	jsr	(ChooseSong).l
	move.w	(SongNum).l,-(sp)
	bsr.w	song
.next27	cmpi.w	#$168,(ScoreSumbytes).l
	bne.w	.next28
	subi.w	#$6,(ScoreSumbytes).l
.next28	movea.l	#$180F2,a0
	adda.w	(ScoreSumbytes).l,a0
	addi.w	#$6,(ScoreSumbytes).l
	bsr.w	GetPeriodTimeRemaining
	move.w	d0,(a0)+
	moveq	#$2,d0
	add.w	$26(a2),d0
	sub.w	$26(a1),d0
	move.b	d0,(a0)+
	addi.w	#$1E,(CwdExciteLvl).l
	cmpa.l	#tmstruct,a2
	beq.w	.next29
	subi.w	#$14,(CwdExciteLvl).l
	bset	#$7,-$1(a0)
.next29	move.w	$18(a2),d0
	move.b	d0,(a0)+
	move.w	#$FFFF,(a0)
	addi.w	#$B6,d0
	addi.b	#$1,(a2,d0.w)
	move.w	$1A(a2),d0
	bmi.w	.next30
	cmp.w	$18(a2),d0
	beq.w	.next30
	move.b	d0,(a0)+
	addi.w	#$D0,d0
	addi.b	#$1,(a2,d0.w)
	move.w	$1C(a2),d0
	bmi.w	.next30
	cmp.w	$18(a2),d0
	beq.w	.next30
	move.b	d0,(a0)
	addi.w	#$D0,d0
	addi.b	#$1,(a2,d0.w)
.next30	move.w	$28(a1),d0
	bmi.w	.next31
	addi.w	#$B6,d0
	addi.b	#$1,(a1,d0.w)
.next31	bsr.w	ChkShotStat
	bsr.w	PenGoalStuff
	bclr	#$3,(BA_PS_flags).l
	bsr.w	printscores1
	move.w	#$2710,(crowdnoisedelay).l
	btst	#$0,(gmode2).l
	beq.w	.next32
	bra.w	.next33
.next32	moveq	#$7,d0
	bsr.w	.next36
.next33	clr.w	(collflag).l
	clr.w	$28(a3)
	clr.w	$2A(a3)
	moveq	#$6,d0
	tst.w	$0(a3)
	bpl.w	.next34
	neg.w	d0
.next34	move.w	d0,$0(a3)
	move.w	#$110,d0
	tst.w	$14(a3)
	bpl.w	.next35
	neg.w	d0
.next35	move.w	d0,$14(a3)
	move.w	#$600,$2C(a3)
	clr.w	$18(a3)
	st.b	$17E38.l
	st.b	$17E3C.l
	bset	#$2,$62(a3)
	move.w	#$1A,d0
	bsr.w	assreplace
	move.l	a3,-(sp)
	adda.w	#$80,a3
	move.w	#$102E,d1
	bsr.w	SetSPA
	movea.l	$22(a1),a3
	moveq	#$E,d0
	bsr.w	AddPenalty2
	movea.l	(sp)+,a3
	rts
.next36	move.l	a3,-(sp)
	movea.l	$22(a2),a3
	moveq	#$5,d3
.loop3	tst.w	$34(a3)
	ble.w	.next38
	btst	#$0,$63(a3)
	bne.w	.next38
	bclr	#$2,$62(a3)
	bclr	#$3,$64(a3)
	beq.w	.next37
	jsr	(EndOneTimer).l
.next37	bsr.w	AssistListPush
.next38	adda.w	#$80,a3
	dbra	d3,.loop3
	movea.l	(sp)+,a3
	rts
GetPeriodTimeRemaining
	move.w	(gsp).l,d0
	swap	d0
	clr.w	d0
	lsr.l	#$2,d0
	or.w	(PerTimeTotal).l,d0
	sub.w	(gameclock).l,d0
	rts
checkgoalp	btst	#$5,$63(a3)
	bne.w	rtss2
	cmpi.w	#$A,$18(a3)
	bgt.w	rtss2
	cmpi.w	#$B,$52(a3)
	bgt.w	rtss2
	movem.w	d2-d3,-(sp)
	sub.w	$14(a2),d3
	move.w	d3,d0
	sub.w	$0(a2),d2
	move.w	d2,d1
	neg.w	d0
	asl.w	#$4,d2
	muls.w	d2,d2
	divu.w	#$400,d2
	cmpi.w	#$100,d2
	bhi.w	.exit
	asl.w	#$4,d3
	muls.w	d3,d3
	divu.w	#$79,d3
	add.w	d2,d3
	cmpi.w	#$100,d3
	bhi.w	.exit
	movem.w	(sp)+,d2-d3
	bsr.w	.next2
	movem.w	d2-d3,-(sp)
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	bsr.w	Sroot
	move.w	d0,d2
	movem.w	(sp)+,d0-d1
	addi.w	#$1,d2
	asl.l	#$8,d0
	divs.w	d2,d0
	asl.l	#$8,d1
	divs.w	d2,d1
	bset	#$4,(sflags6).l
	bsr.w	wallcoll
	bclr	#$4,(sflags6).l
.exit	movem.w	(sp)+,d2-d3
	rts
.next2	movem.l	d0-d1,-(sp)
.loop	btst	#$7,$FF800E.l
	bne.b	.loop
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.loop2	btst	#$6,$FF800E.l
	beq.b	.loop2
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.loop3	btst	#$6,$FF800E.l
	bne.b	.loop3
	bclr	#$7,$FF800F.l
	andi.w	#$1F,d0
	bne.w	.next3
	move.w	(pucky).l,d0
	sub.w	$14(a2),d0
	cmpi.w	#$28,d0
	bgt.w	.next3
	cmpi.w	#$FFD8,d0
	blt.w	.next3
	move.w	$28(a3),d0
	move.w	$2A(a3),d1
	cmpi.w	#$2000,d0
	bgt.w	.next4
	cmpi.w	#$E000,d0
	blt.w	.next4
	cmpi.w	#$2000,d1
	bgt.w	.next4
	cmpi.w	#$E000,d1
	blt.w	.next4
.next3	movem.l	(sp)+,d0-d1
	rts
.next4	adda.w	#$C,sp
	asr.w	#$2,d0
	asr.w	#$2,d1
	move.w	d0,$28(a2)
	move.w	d1,$2A(a2)
	clr.w	$28(a3)
	clr.w	$2A(a3)
	bset	#$6,(sflags).l
	btst	#$0,(gmode).l
	bne.w	rtss2
	moveq	#$8,d0
	bra.w	AddPenalty2
wallcollb	cmpi.w	#$E,$52(a3)
	bne.w	wallcoll
	cmpi.w	#$1D,$18(a3)
	bgt.w	.0
	cmpi.w	#$12,$18(a3)
	bls.w	wallcoll
	cmpi.w	#$118,$14(a3)
	blt.w	.0
	cmpi.w	#$D,$0(a3)
	blt.w	wallcoll
	cmpi.w	#$F,$0(a3)
	bgt.w	wallcoll
	cmpi.w	#$FA0,$2A(a3)
	blt.w	wallcoll
	move.l	a3,-(sp)
	asr.w	$2A(a3)
	adda.w	#$80,a3
	move.w	#$1078,d1
	bsr.w	SetSPA
	movea.l	(sp)+,a3
	move.w	#$E,-(sp)
	bsr.w	sfx
	addi.w	#$258,(Crowdlevel).l
	addi.w	#$F,(CwdExciteLvl).l
.0	bset	#$6,(sflags).l
	bset	#$2,$62(a3)
	tst.w	$14(a3)
	bpl.w	.1
	ori.w	#$8000,$4(a3)
.1	clr.w	$86(a3)
	btst	#$0,(gmode).l
	bne.w	rtss2
	move.l	a3,-(sp)
	move.w	(ltplayer).l,d0
	asl.w	#$7,d0
	movea.l	#SortCords,a3
	adda.w	d0,a3
	moveq	#$6,d0
	bsr.w	AddPenalty2
	movea.l	(sp)+,a3
	rts
wallcoll						;d0 = cosine, d1 = sine of angle of incidence with wall, a3 = object.
									;Bounce a3 off the wall: the puck loses speed, flips and plays
									;sfx $28-$2B; a player sets the wall collision bit (unless sflags6 bit 4)
									;and plays SFXplayerwall on a hard hit. Called from checkgoal, checkgoalp
									;and wallcollb
	move.w	d0,$4E(a3)
	move.w	d1,$50(a3)
	movem.l	d2-d3,-(sp)
	movem.w	d0-d1,-(sp)
	muls.w	$2A(a3),d0
	muls.w	$28(a3),d1
	sub.l	d1,d0
	asr.l	#$8,d0
	move.w	d0,d2
	movem.w	(sp),d0-d1
	muls.w	$28(a3),d0
	muls.w	$2A(a3),d1
	add.l	d1,d0
	asr.l	#$8,d0
	move.w	d0,d3
	neg.w	d2
	cmpi.w	#$E,$52(a3)
	bne.w	.player
	bclr	#$4,(sflags2).l
	tst.w	d2
	bpl.w	.nocoll
	asr.w	#$2,d2		;reduce normal speed on puck
	cmpi.w	#$FC00,d2
	bgt.w	.pok
	move.w	#$800,d0
	bsr.w	randomd0
	neg.w	d0
	move.w	d0,$2C(a3)
	bsr.w	puckflip
	move.w	d2,d0		;sfx $28 + ((v1n >> 10) + 4) & 3
	asr.w	#$8,d0
	asr.w	#$2,d0
	addi.w	#$4,d0
	bpl.w	.sf0
	clr.w	d0
.sf0	andi.w	#$3,d0
	addi.w	#$28,d0
	move.w	d0,-(sp)
	bsr.w	sfx
.pok	move.w	d3,d0		;reduce tangent speed on puck
	asr.w	#$6,d0
	sub.w	d0,d3
	asr.w	#$1,d0
	sub.w	d0,d3
	bra.w	.noadd
.player	cmpi.w	#$3E8,d2
	bgt.w	.nocoll
	bclr	#$4,(sflags6).l		;set by checkgoalp
	bne.w	.0
	bset	#$4,$64(a3)		;set wall collision bit
.0	cmpi.w	#$F000,d2
	bgt.w	.nosfx
	cmpi.w	#$A,$32(a3)
	blt.w	.nosfx
	move.w	#$20,-(sp)
	bsr.w	sfx
.nosfx	asr.w	#$2,d2		;reduce normal speed on player to 1/4
	cmpi.w	#$FC7C,d2
	blt.w	.noadd
	move.w	#$FC18,d2
.noadd	movem.w	(sp),d0-d1		;rotate normal/tangent speeds (d2/d3) back into Xvel/Yvel
	movem.w	d2-d3,-(sp)
	muls.w	d0,d3
	muls.w	d1,d2
	sub.l	d2,d3
	asr.l	#$8,d3
	move.w	d3,$28(a3)
	movem.w	(sp)+,d2-d3
	movem.w	(sp),d0-d1
	muls.w	d1,d3
	muls.w	d0,d2
	add.l	d2,d3
	asr.l	#$8,d3
	move.w	d3,$2A(a3)
	tst.w	$2C(a3)
	bmi.w	.nocoll
	clr.w	$2C(a3)
.nocoll	adda.w	#$4,sp		;drop saved cos/sin
	movem.l	(sp)+,d2-d3
	rts

checkpuckcoll_sfx						;Entered from checkpuckcoll. Puck in the air: sfx 5 once when sflags4 bit
									;2 is set
	bclr	#$2,$17F72.l
	beq.w	rtss2
	move.w	#$5,-(sp)
	bra.w	sfx
; Puck collision: checks the position limits
PuckCollisionLimits	cmpi.w	#$190,$14(a3)
	bgt.w	.next
	cmpi.w	#$FE70,$14(a3)
	bgt.w	.next2
.next	clr.w	$2A(a3)
.next2	cmpi.w	#$10,$18(a3)
	bgt.w	checkpuckcoll_sfx
	move.w	$52(a3),d0
	asl.w	#$1,d0
	movea.l	#OOlistpos,a0
	movea.l	#OOlist,a1
	movea.l	#Ylist,a2
	move.w	(a0,d0.w),d1
.loop	cmpi.w	#$F,d1
	beq.w	.next3
	clr.w	d4
	move.b	$1(a1,d1.w),d4
	move.w	(a2,d4.w),d5
	sub.w	$14(a3),d5
	cmpi.w	#$16,d5
	bgt.w	.next3
	bsr.w	PuckCollisionCheck
	addq.w	#$1,d1
	bra.w	.loop
.next3	move.w	(a0,d0.w),d1
	beq.w	.ex
.loop2	clr.w	d4
	move.b	-$1(a1,d1.w),d4
	move.w	$14(a3),d5
	sub.w	(a2,d4.w),d5
	cmpi.w	#$16,d5
	bgt.w	.ex
	bsr.w	PuckCollisionCheck
	subq.w	#$1,d1
	bne.w	.loop2
.ex	rts
; Puck collision: tests the object
PuckCollisionCheck	movem.l	d0-d7/a0-a3,-(sp)
	lsr.w	#$1,d4
	cmp.w	(puckc).l,d4
	beq.w	PuckCollisionReturn
	cmpi.w	#$B,d4
	bgt.w	PuckCollisionReturn
	asl.w	#$7,d4
	movea.l	#SortCords,a2
	adda.w	d4,a2
	btst.b	#$2,(BA_PS_flags).l
	beq.w	.next
	asr.w	#$7,d4
	cmp.w	(BA_Sktr_SCnum).l,d4
	beq.w	.next
	cmp.w	(BA_Goalie_SCnum).l,d4
	bne.w	PuckCollisionReturn
.next	btst.b	#$2,$62(a2)
	bne.w	PuckCollisionReturn
	tst.b	$5E(a2)
	bne.w	PuckCollisionReturn
	btst.b	#$2,$63(a2)
	bne.w	.next3
	cmpi.w	#$5,$18(a3)
	bgt.w	.next3
	cmpi.w	#$200,$2C(a3)
	bgt.w	.next3
	move.l	a2,-(sp)
	bsr.w	GetHotCount
	add.w	$0(a2),d0
	sub.w	$0(a3),d0
	cmpi.w	#$E,d0
	bgt.w	.next3
	cmpi.w	#$FFF2,d0
	blt.w	.next3
	add.w	$14(a2),d1
	sub.w	$14(a3),d1
	cmpi.w	#$E,d1
	bgt.w	.next3
	cmpi.w	#$FFF2,d1
	blt.w	.next3
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	move.l	#$C4,d1
	tst.b	$5E(a3)
	ble.w	.next2
	lsr.w	#$2,d1
.next2	cmp.l	d1,d0
	bhi.w	.next3
	bsr.w	puckstick
	bra.w	PuckCollisionReturn
.next3	tst.w	$34(a2)
	beq.w	PuckCollisionTable
	btst.b	#$3,$64(a2)
	bne.w	PuckCollisionReturn
	move.w	$0(a2),d0
	sub.w	$0(a3),d0
	cmpi.w	#$8,d0
	bgt.w	PuckCollisionReturn
	cmpi.w	#$FFF8,d0
	blt.w	PuckCollisionReturn
	move.w	$14(a2),d1
	sub.w	$14(a3),d1
	cmpi.w	#$8,d1
	bgt.w	PuckCollisionReturn
	cmpi.w	#$FFF8,d1
	blt.w	PuckCollisionReturn
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	cmpi.l	#$40,d0
	bhi.w	PuckCollisionReturn
	bsr.w	puckbody
; Puck collision: restores the registers
PuckCollisionExit
; Puck collision: return
PuckCollisionReturn	movem.l	(sp)+,d0-d7/a0-a3
	rts
; Table of 80 bytes after PuckCollisionReturn, 80 bytes: $00,$0C,$00,$0C,$00,$0D ...
	dc.b	$00,$0C,$00,$0C,$00,$0D,$00,$0D,$00,$0D,$00,$0D,$00,$0D,$00,$0D	; ................
	dc.b	$00,$0D,$00,$0D,$00,$0E,$00,$0E,$00,$0E,$00,$0E,$00,$0F,$00,$0F	; ................
	dc.b	$00,$0F,$00,$0F,$00,$0F,$00,$0F,$00,$90,$00,$90,$00,$A9,$00,$A9	; ................
	dc.b	$00,$A9,$00,$A9,$00,$A9,$00,$A9,$00,$A9,$00,$A9,$00,$C4,$00,$C4	; ................
	dc.b	$00,$C4,$00,$C4,$00,$E1,$00,$E1,$00,$E1,$00,$E1,$00,$E1,$00,$E1	; ................
; Puck collision: table lookup
PuckCollisionTable	move.l	a0,-(sp)
	movea.l	#$3BA3C,a0
	clr.w	d0
	move.b	$68(a2),d0
	btst.b	#$1,(sflags8).l
	bne.w	.next
	btst.b	#$6,(sflags7).l
	beq.w	.next2
.next	addi.b	#$2,d0
.next2	lsr.w	#$1,d0
	btst.b	#$3,$62(a2)
	beq.w	.next3
	move.w	#$F,d0
.next3	add.w	d0,d0
	btst.b	#$0,(gmode2).l
	beq.w	.next4
	tst.w	d0
	beq.w	.next4
	subi.w	#$2,d0
.next4	cmpi.w	#$1E,d0
	blt.w	.next5
	move.w	#$1E,d0
.next5	move.w	(a0,d0.w),$17EB4.l
	movea.l	#$3BA64,a0
	clr.l	$17EB6.l
	move.w	(a0,d0.w),$17EB8.l
	move.w	$17EB4.l,$17EBA.l
	neg.w	$17EBA.l
	btst.b	#$1,(sflags6).l
	beq.w	.next6
	move.w	#$C,$17EB4.l
	move.l	#$90,$17EB6.l
	move.w	#$FFF4,$17EBA.l
.next6	cmpi.w	#$250,$58(a2)
	beq.w	.next7
	cmpi.w	#$2A2,$58(a2)
	bne.w	.next8
.next7	move.w	#$12,$17EB4.l
	move.l	#$144,$17EB6.l
	move.w	#$FFEE,$17EBA.l
.next8	movea.l	(sp)+,a0
	cmpi.w	#$F,(puckz).l
	bgt.w	.next14
	move.w	$0(a2),d0
	cmpi.w	#$250,$58(a2)
	beq.w	.next9
	cmpi.w	#$2A2,$58(a2)
	bne.w	.next13
	move.w	#$6,d1
	bra.w	.next10
.next9	move.w	#$FFFA,d1
.next10	btst.b	#$7,$62(a2)
	bne.w	.next11
	neg.w	d1
.next11	btst.b	#$0,$76(a2)
	beq.w	.next12
	neg.w	d1
.next12	add.w	d1,d0
.next13	sub.w	$0(a3),d0
	cmp.w	$17EB4.l,d0
	bgt.w	.next14
	cmp.w	$17EBA.l,d0
	blt.w	.next14
	move.w	$14(a2),d1
	sub.w	$14(a3),d1
	cmp.w	$17EB4.l,d1
	bgt.w	.next14
	cmp.w	$17EBA.l,d1
	blt.w	.next14
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	cmp.l	$17EB6.l,d0
	movem.w	(sp)+,d0-d1
	bhi.w	.next14
	bsr.w	PuckCollisionStick
	bra.w	PuckCollisionExit
.next14	bclr.b	#$2,$17F72.l
	beq.w	PuckCollisionExit
	move.w	(puckc).l,d0
	cmp.w	$52(a2),d0
	beq.w	PuckCollisionExit
	move.w	#$5,-(sp)
	bsr.w	sfx
	bra.w	PuckCollisionExit
puckstick						;puck collides with stick. a2 = player who collided, a3 = puck, d0 =
									;distance^2 (from checkpuckcoll .ccx). A stick check on the puck carrier
									;can steal the puck (Stk rolls, smaller ranges when the carrier is in the
									;slot, sflags6 bit 5), else a slow enough puck is caught (puckglue); a
									;one-timer shoots it (onetimershot). Uses the slot ranges and the
									;skater, or no highlight: the stick takes the puck (steal check if someone
									;has it)
	tst.w	$34(a2)		;a2 = player who collided
	bne.w	.0		;branch if not goalie
	btst	#$4,(gmode).l
	bne.w	rtss2		;exit if so (goalie always lets the shot in)
.0	bclr	#$0,$62(a2)
	move.w	(puckc).l,d1		;move puckc into d1
	bmi.w	.nosteal		;branch if no puck carrier
	asl.w	#$7,d1
	movea.l	#SortCords,a0
	adda.w	d1,a0		;a0 = Struct of puck carrier
	move.b	$62(a0),d1
	move.b	$62(a2),d2
	eor.w	d1,d2		;compare pflags of each player
	btst	#$6,d2		;check if on same team
	beq.w	rtss2		;no stealing from teammate
	btst	#$5,(sflags6).l		;check if puckc is in slot
	beq.w	.next2
	cmpi.l	#$40,d0		;steal range met: goalies always steal, nobody steals from a goalie
	bhi.w	rtss2
	bra.w	.1
.next2	cmpi.l	#$24,d0
	bhi.w	rtss2
.1	tst.w	$34(a2)		;check if colliding player is goalie
	beq.w	.steal
	tst.w	$34(a0)
	beq.w	rtss2		;no stealing from goalie
	move.b	$71(a0),d0
	lsr.b	#$1,d0
	bsr.w	makepde		;adjust for energy level
	move.w	d0,-(sp)
	exg.l	a0,a2		;swap a2 and a0 (a0 now collider)
	move.b	$71(a0),d0		;Stk for collider
	lsr.b	#$1,d0		;divie by 2
	bsr.w	makepde		;adjust for energy
	exg.l	a0,a2		;swap back (a0 now puckc)
	neg.w	d0
	add.w	(sp)+,d0		;add puckc modified Stk
	addi.w	#$24,d0		;add 24 hex (36 decimal)
	bsr.w	randomd0
	btst	#$5,(sflags6).l		;check if puckc is in slot
	beq.w	.next4
	cmpi.w	#$4,d0		;steal: the carrier cannot touch the puck for a while (stick handling,
	bhi.w	rtss2		;exit if higher (not losing puck)
	bra.w	.steal
.next4	cmpi.w	#$2,d0		;compare 2 to d0
	bhi.w	rtss2		;exit if higher (not losing puck)
.steal	move.b	$71(a0),d0		;Stk of puckc
	lsr.b	#$1,d0
	bsr.w	makepde		;adj for energy
	addi.w	#$14,d0		;add 14 hex (20 dec)
	move.b	d0,$5E(a0)		;move result into nopuck (cant get puck timer)
	exg.l	a0,a2		;swap a0 and a2 (a0 now collider)
	move.b	$71(a0),d0		;Stk of collider
	lsr.b	#$1,d0
	bsr.w	makepde		;adj for energy
	addi.w	#$14,d0		;add 14 hex (20 dec)
	move.b	d0,$5E(a0)		;move result into nopuck
	exg.l	a0,a2
	move.w	$52(a0),(lastplayer).l
	bclr	#$2,(sflags).l		;clear pass dir mode
	bclr	#$3,(sflags).l		;clear shot dir mode
.stdef	move.w	#$6,-(sp)
	bsr.w	sfx
	bsr.w	a2touchpuck		;deflect
	bra.w	deflect		;no carrier (goalie in the smaller range): one-timer check
.nosteal	tst.w	$34(a2)
	bne.w	.onetimerchk
	cmpi.l	#$40,d0
	bhi.w	rtss2		;smaller range for stealing puck
.onetimerchk	btst	#$3,$64(a2)
	beq.w	.nosteal2
	cmpi.l	#$64,d0		;not a one-timer, or past its frame: catch or deflect by puck speed
	bhi.w	.next11
	cmpi.w	#$18,$5A(a2)
	bge.w	.nosteal2
	move.w	#$18,$5A(a2)
	bset	#$7,(sflags8).l
.nosteal2	move.w	(puckvx).l,d0
	move.w	(puckvy).l,d1
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	clr.w	d1
	btst	#$4,(sflags2).l		;check if shot was taken
	bne.w	.nohand
	btst	#$3,$64(a2)		;check if one timer
	bne.w	.next10
	move.b	$71(a2),d1
	mulu.w	#$15E,d1
.nohand	addi.w	#$32C8,d1
	mulu.w	d1,d1
	cmp.l	d1,d0
	bls.w	puckglue
	move.b	#$8,$5E(a2)
	bra.w	.stdef
.next10	exg.l	a2,a3
	jsr	(onetimershot).l
	exg.l	a2,a3
	rts
.next11	cmpi.l	#$144,d0
	bhi.w	.ex2
	cmpi.w	#$18,$5A(a2)
	bge.w	.ex2
	move.w	#$18,$5A(a2)
.ex2	rts
puckglue						;part of puckstick that puckgoalie also branches to. Player a2 takes the
									;puck: faceoff and pass stats, crowd song, goalie hold time (temp5), then
									;.setd0player
	move.w	#$7,-(sp)
	move.w	$52(a2),d0		;move SCnum into d0
	move.w	d0,(puckc).l		;move d0 into puckc
	movea.l	#tmstruct,a0		;Move Home Stats struct into a0
	lea.l	$366(a0),a1
	btst	#$6,$62(a2)		;check if player is home or away
	bne.w	.next
	exg.l	a0,a1
.next	st.b	$1A(a0)		;FF into assist 1
	st.b	$1C(a0)		;FF into assist 2
	bset	#$3,$32(a0)		;set a flag (not sure what)
	bclr	#$4,(sflags3).l		;clear flag (not sure what, might have to do with faceoff)
	beq.w	.snd		;branch if it was cleared already
	addi.w	#$1,$E(a1)		;add 1 to faceoff won
	addi.w	#$C8,(Crowdlevel).l
	move.w	#$C,(sp)		;move C to stack
	cmpa.l	#tmstruct,a1		;compare if a1 is home
	bne.w	.snd
	addi.w	#$A,(CwdExciteLvl).l
	move.w	#$B,(sp)		;Move B into stack
.snd	bsr.w	sfx
	move.w	$52(a2),d0		;move SCnum into d0
	cmp.w	(passReceiverPlayerNum).l,d0
	bne.w	.next3
	addi.w	#$1,$14(a1)
.next3	st.b	(passReceiverPlayerNum).l
	bclr	#$2,(sflags).l		;clear pass dir mode
	bclr	#$3,(sflags).l		;clear shot dir mode
	tst.w	$34(a2)		;check if a2 is goalie
	bne.w	.setd0player
	bsr.w	ChkShotStat
	move.w	#$8C,$48(a2)		;move 8C to temp5 - countdown for faceoff?
	cmpi.w	#$2F4,$58(a2)		;check for goalie dive animation
	bne.w	.setd0player		;branch if not equal
	move.w	#$5,$48(a2)		;set temp5 to 5
.setd0player	cmp.w	(c1playernum).l,d0
	beq.w	rtss2
	cmp.w	(c2playernum).l,d0
	beq.w	rtss2
	tst.w	(cont3team).l
	beq.w	.cont4chk
	cmp.w	(c3playernum).l,d0
	beq.w	rtss2
.cont4chk	tst.w	(cont4team).l
	beq.w	.0
	cmp.w	(c4playernum).l,d0
	beq.w	rtss2
.0	tst.w	(cont3team).l
	bne.w	.1
	tst.w	(cont4team).l
	beq.w	.next9		;branch if no team
.1	movem.l	d0/a3,-(sp)
	asl.w	#$7,d0
	movea.l	#SortCords,a3
	tst.w	$34(a3,d0.w)
	bne.w	.2
	btst	#$3,$62(a3,d0.w)		;check if d0 player controlled
	beq.w	.2
	movem.l	(sp)+,d0/a3		;exit if player controlled
	rts
.2	movem.l	(sp)+,d0/a3
.next9	cmpi.w	#$6,d0
	slt.b	d1
	ext.w	d1
	addi.w	#$2,d1
	move.w	(lastplayer).l,d2
	cmp.w	(c2playernum).l,d2
	beq.w	.3
	cmp.w	(cont1team).l,d1
	bne.w	.3
	jmp	(setc1player).l
.3	cmp.w	(cont2team).l,d1
	bne.w	.4
	jmp	(setc2player).l
.4	cmp.w	(cont1team).l,d1
	bne.w	rtss2
	jmp	(setc1player).l
puckbody						;puck hits player a2. a3 = puck, d0 = distance^2 (from checkpuckcoll
									;.ccx). The puck bounces off. A high puck (Zpos > 8) that is fast makes a2
									;fall (FallDown, Zpos > $C); a slower one starts SPAcatch on a2
	btst	#$3,$64(a2)
	bne.w	rtss2		;real hit (low or near center): a2 touched the puck
	cmpi.w	#$8,$18(a3)
	bgt.w	.hit
	move.w	d0,d1
	andi.w	#$F,d1		;radius^2 from center
	bne.w	rtss2
.hit	bsr.w	a2touchpuck		;real hit: a2 touched the puck
	move.w	#$24,-(sp)
	bsr.w	sfx
	clr.w	$2C(a3)
	move.b	#$8,$5E(a2)
	move.w	$0(a3),d0		;Xpos
	sub.w	$0(a2),d0
	move.w	$14(a3),d1
	sub.w	$14(a2),d1
	bne.w	.0
	move.l	a2,-(sp)
	bsr.w	GetHotCount
.0	move.w	$28(a3),d2
	move.w	$2A(a3),d3
	move.b	d0,$28(a3)
	move.b	d1,$2A(a3)
	bsr.w	puckflip
	cmpi.w	#$8,$18(a3)
	ble.w	rtss2
	muls.w	d2,d2
	muls.w	d3,d3
	add.l	d3,d2		;slow puck: a2 catches it (SPAcatch) unless locked
	cmpi.l	#$9000000,d2		;fast puck
	bls.w	.1
	cmpi.w	#$C,$18(a3)
	bgt.w	FallDown
	rts
.1	bset	#$5,$62(a2)
	bne.w	rtss2
	move.w	#$10D0,d1
	exg.l	a2,a3
	bsr.w	SetSPA
	exg.l	a2,a3
rtss2						;shared rts
	rts
; Puck collision: stick check
PuckCollisionStick	btst.b	#$4,(gmode).l
	bne.w	rtss2
	clr.w	d2
	cmpi.w	#$8,$18(a3)
	bgt.w	.next
	addi.w	#$2,d2
.next	neg.w	d0
	neg.w	d1
	bsr.w	vtoa
	sub.w	$54(a2),d0
	andi.w	#$7,d0
	move.w	d0,d1
	andi.w	#$3,d1
	bne.w	.next2
.loop	btst.b	#$7,$FF800E.l
	bne.s	.loop
	move.w	#$1B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop2	btst.b	#$6,$FF800E.l
	beq.s	.loop2
	move.w	$FF8010.l,d0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop3	btst.b	#$6,$FF800E.l
	bne.s	.loop3
	bclr.b	#$7,$FF800F.l
.next2	andi.w	#$4,d0
	lsr.w	#$2,d0
	eori.w	#$1,d0
	add.w	d0,d2
	add.w	d2,d2
	lea.l	PuckCollisionWords(pc),a0
	move.w	(a0,d2.w),d0
	moveq	#$F,d1
	add.b	(a2,d0.w),d1
	dc.w	$41FA,$01A4		; lea.l X_3C246(pc),a0
	btst.b	#$3,$4(a2)
	beq.w	.next3
	eori.w	#$2,d2
.next3	move.w	$6(a2),d0
	move.w	#$197,-(sp)
	cmpi.w	#$233,d0
	blt.w	.next4
	move.w	#$292,(sp)
	dc.w	$41FA,$017E		; lea.l X_3C246(pc),a0
.next4	sub.w	(sp)+,d0
	move.b	(a0,d0.w),d0
	lsr.w	d2,d0
	andi.w	#$3,d0
	bclr.b	#$2,$17F72.l
	bsr.w	ChkShotStat
	bsr.w	a2touchpuck
	cmpi.w	#$3000,(puckvy).l
	bgt.w	.next5
	cmpi.w	#$D000,(puckvy).l
	bgt.w	.next7
.next5	move.w	#$B,-(sp)
	btst.b	#$6,$62(a2)
	beq.w	.next6
	move.w	#$D,(sp)
.next6	bsr.w	sfx
.next7	move.w	#$24,-(sp)
	bsr.w	sfx
	move.w	(puckc).l,d2
	bmi.w	.next9
	st.b	(puckc).l
	asl.w	#$7,d2
	movea.l	#SortCords,a0
	adda.w	d2,a0
	move.b	#$14,$5E(a0)
	move.w	$52(a0),(lastplayer).l
	bclr.b	#$2,(sflags).l
	bclr.b	#$3,(sflags).l
.loop4	clr.w	$2C(a3)
	move.b	#$A,$5E(a2)
	move.w	#$4,$46(a2)
	move.w	$0(a3),d0
	sub.w	$0(a2),d0
	move.w	$14(a3),d1
	sub.w	$14(a2),d1
	bne.w	.next8
	move.l	a2,-(sp)
	bsr.w	GetHotCount
.next8	move.b	d0,$28(a3)
	move.b	d1,$2A(a3)
	bra.w	puckflip
	bset.b	#$2,$17F72.l
	rts
.next9	cmpi.w	#$2F4,$58(a2)
	beq.w	.loop4
	moveq	#$2,d0
	add.b	$6C(a2),d0
	asl.w	#$8,d0
	asl.w	#$1,d0
	bsr.w	randomd0
	addi.w	#$C00,d0
	add.w	d0,d0
	bpl.w	.next10
	move.w	#$7FFF,d0
.next10	btst.b	#$1,$63(a2)
	bne.w	.next12
	cmpi.w	#$2C,$0(a3)
	bgt.w	.next12
	cmpi.w	#$FFD4,$0(a3)
	blt.w	.next12
	cmpi.w	#$10E,$14(a3)
	bgt.w	.next12
	cmpi.w	#$FEF2,$14(a3)
	blt.w	.next12
	cmpi.w	#$D2,$14(a3)
	bgt.w	.next11
	cmpi.w	#$FF2E,$14(a3)
	bgt.w	.next12
.next11	asr.w	#$2,d0
.next12	cmp.w	(puckvx).l,d0
	blt.w	.loop4
	cmp.w	(puckvy).l,d0
	blt.w	.loop4
	neg.w	d0
	cmp.w	(puckvx).l,d0
	bgt.w	.loop4
	cmp.w	(puckvy).l,d0
	bgt.w	.loop4
	btst.b	#$2,$63(a2)
	bne.w	.loop4
	clr.w	$2C(a3)
	bra.w	puckglue
; Four words used by the stick check
PuckCollisionWords	dc.b	$00,$73,$00,$6E,$00,$70,$00,$72	; .s.n.p.r
deflect
	st.b	(puckc).l
	move.w	#$1000,d0
	bsr.w	randomd0s
	move.w	d0,$2A(a3)
	move.w	#$1000,d0
	bsr.w	randomd0s
	move.w	d0,$28(a3)
	move.w	#$1000,d0
	bsr.w	randomd0
	move.w	d0,$2C(a3)
	bra.w	puckflip
makepde						;pass d0 as value to be scaled by player a0's energy level (full energy
									;while sflags7 bit 4 is set). Return d0 as result
	ext.w	d0
	move.w	d0,-(sp)
	movem.l	d1/a2-a3,-(sp)
	movea.l	a0,a3
	bsr.w	getpde
	btst	#$4,(sflags7).l
	beq.w	.0
	move.w	#$1000,d0
.0	movem.l	(sp)+,d1/a2-a3
	muls.w	(sp)+,d0
	asl.l	#$4,d0
	swap	d0
	ext.l	d0		;d0 = d0 * energy / 4096
	rts
getpde						;get player a3's energy level into d0. Return a2 = his team struct, d1 =
									;pnum*2
	movea.l	#tmstruct,a2
	btst	#$6,$62(a3)		;#pfteam - home or away
	beq.w	.0
	adda.w	#$366,a2
.0	move.b	$66(a3),d1
	ext.w	d1
	add.w	d1,d1
	move.w	$34(a2,d1.w),d0
	rts
setpde
	tst.w	d0
	bpl.w	.0
	clr.w	d0
.0	move.w	d0,$34(a2,d1.w)
	rts
	include	segacd\hockey\scoreboard94.asm
setpersonel
	movem.l	d0-d5/a0-a4,-(sp)
	movea.l	$22(a2),a3
	moveq	#$5,d4
.loop	st.b	$60(a3)
	st.b	$61(a3)
	adda.w	#$80,a3
	dbra	d4,.loop
	bsr.w	SetPlList
	moveq	#$5,d4
	movea.l	#$18AC6,a4
.1	clr.w	d5
	move.b	(a4,d4.w),d5
	beq.w	.next
	subi.w	#$1,d5
	moveq	#$5,d3
	movea.l	$22(a2),a3
	suba.w	#$80,a3
.2	adda.w	#$80,a3
	cmp.b	$66(a3),d5
	dbeq	d3,.2
	bne.w	.next
	move.b	$6(a4,d4.w),$60(a3)
	move.b	d5,$61(a3)
	clr.b	(a4,d4.w)
.next	dbra	d4,.1
	moveq	#$5,d4
	movea.l	#$18AC6,a4
.3	clr.w	d5
	move.b	(a4,d4.w),d5
	beq.w	.next3
	subi.w	#$1,d5
	moveq	#$5,d3
	movea.l	$22(a2),a3
	suba.w	#$80,a3
.4	adda.w	#$80,a3
	tst.b	$61(a3)
	dbmi	d3,.4
	bpl.w	.0
	movea.l	a3,a0
.0	tst.w	$34(a3)
	dbpl	d3,.4
	move.b	$6(a4,d4.w),$60(a0)
	move.b	d5,$61(a0)
	clr.b	(a4,d4.w)
.next3	dbra	d4,.3
	movem.l	(sp)+,d0-d5/a0-a4
	rts
SetPlList						;create PlList of players who we want on the ice now. a2 = team struct.
									;Takes the current line (tmline) by priolist; an unavailable
									;player (in the box or injured, -3 / -4) is replaced from sublist, or from
									;the whole roster
	movea.l	#$18AC6,a4
	clr.l	(a4)		;goalie present: use the position priority list from the start
	clr.w	$4(a4)
	movea.l	#priolist,a0
	tst.w	$28(a2)
	bpl.w	.next		;branch if theres a goalie
	adda.w	#$1,a0		;add 1 to a0
.next	lea.l	$16C(a2),a1		;loop: d5 = position, PlList slot = the line's player there (no player:
	move.w	$16(a2),d0		;current line selected
	asl.w	#$3,d0
	adda.w	d0,a1		;add to a1 to set a1 to currently selected line
	move.w	$26(a2),d4		;tmap - active players (4-6 in normal ROM)
	bra.w	.next2
.0	clr.w	d5
	move.b	(a0,d4.w),d5		;move position into d5
	move.b	(a1,d5.w),(a4,d4.w)
	move.b	d5,$6(a4,d4.w)
	bne.w	.next2
	moveq	#$1,d3		;loop: replace injured or penalized players
	add.w	$28(a2),d3
	move.b	d3,(a4,d4.w)
.next2	dbra	d4,.0
	moveq	#$5,d4		;now check to see if player is available
.1	move.b	(a4,d4.w),d3
	beq.w	.loop4
	ext.w	d3
	subi.w	#$1,d3
	add.w	d3,d3
	cmpi.w	#$FFFD,$68(a2,d3.w)		;injured or not on the bench: find a substitute from sublist
	beq.w	.next3
	cmpi.w	#$FFFC,$68(a2,d3.w)		;check if player injured for game
	beq.w	.next3
	tst.w	$68(a2,d3.w)
	ble.w	.loop4
.next3	lea.l	$16C(a2),a1		;now find a player of similar position who is available move Line Lists
	move.b	$6(a4,d4.w),d0		;move 6+a4+d4 into d0 (previous d5)
	ext.w	d0
	asl.w	#$1,d0
	movea.l	#sublist,a0		;move sublist into a0
	adda.w	(a0,d0.w),a0		;move a0+d0 into a0
.s1	clr.w	d0
	move.b	(a0)+,d0
	bmi.w	.error
	move.b	(a1,d0.w),d0
	bsr.w	TryAddPlayerToList
	beq.w	.s1
.loop4	dbra	d4,.1
	rts
.error	jsr	(GetPlayerCount).l		;then try the players from d0 down
	move.w	d0,d3
.try	move.w	d3,d0		;d0 = candidate player number, d3 counts down
	subi.w	#$1,d3
	bmi.w	.loop4		;none available
	bsr.w	TryAddPlayerToList
	beq.w	.try
	bra.w	.loop4
TryAddPlayerToList						;d0 = player number (1 based), d4 = PlList slot. Put d0 in the slot if he
									;is on the bench or ice (not in the box, not injured) and not in PlList
									;yet; return d1 = 0 (Z set) if not
	move.w	d0,d1
	subi.w	#$1,d0
	add.w	d0,d0
	tst.w	$68(a2,d0.w)
	bgt.w	.0		;loop: is d1 already in PlList?
	cmpi.w	#$FFFD,$68(a2,d0.w)
	beq.w	.0
	cmpi.w	#$FFFC,$68(a2,d0.w)
	beq.w	.0
	moveq	#$5,d0
.loop	cmp.b	(a4,d0.w),d1
	dbeq	d0,.loop
	beq.w	.0
	move.b	d1,(a4,d4.w)
	rts
.0	clr.w	d1
	rts
SetupPenaltyShot						;Penalty shot set up for team a2 (called from puckpenshot): the shooter
									;loop over the team: shooter plays center, goalie stays, others leave
	movem.l	d0-d5/a0-a3,-(sp)
	movea.l	$22(a2),a3
	moveq	#$5,d4
.loop	move.w	$52(a3),d0
	cmp.w	(BA_Sktr_SCnum).l,d0
	beq.w	.0
	cmp.w	(BA_Goalie_SCnum).l,d0
	beq.w	.1
	bset	#$2,$63(a3)		;set player unavailable
	move.w	#$20,d0		;assgoaliebreakwait
	bsr.w	assreplace
	bra.w	.next4
.0	bsr.w	Setplass
	move.b	$61(a3),(savednewpnum).l
	move.b	$1936D.l,$61(a3)		;put the player on the ice
	move.w	#$4,$34(a3)
	bra.w	.2
.1	bsr.w	Setplass
	clr.w	$34(a3)
.2	clr.w	d3		;next sort object
	move.b	$61(a3),d3
	add.w	d3,d3
	move.w	#$FFFF,$68(a2,d3.w)
	lsr.w	#$1,d3
	bsr.w	SetPlayerSide
.next4	st.b	$61(a3)
	st.b	$60(a3)
	adda.w	#$80,a3
	dbra	d4,.loop
	movem.l	(sp)+,d0-d5/a0-a3
	rts
forcepldata						;no skating on/off: force players to correct data (for faceoffs only). a2
									;= team struct
	movem.l	d0-d4/a0-a3,-(sp)
	movea.l	$22(a2),a3		;22 offset of team struct is tmsort (address of first sort obj)
	moveq	#$5,d4		;will run the loop 6 times
.top	move.b	$60(a3),d0		;newpos = requested next pos of player
	ext.w	d0
	tst.w	$34(a3)
	bne.w	.0
	tst.w	d0		;set the position and its assignment; centers also get assnearest
	beq.w	.0
	move.w	$52(a3),-(sp)		;push SCNum to stack
	move.w	#$F,$52(a3)		;put F into SCNum
	jsr	(CheckOneTimerFacingReturn).l
	move.w	(sp)+,$52(a3)		;pop original SCNum back into SCNum
.0	move.w	d0,$34(a3)		;move newpos(d0) into position
	bmi.w	.next3		;put the requested player on the ice
	bsr.w	Setplass
	cmpi.w	#$4,$34(a3)
	bne.w	.notnear
	moveq	#$11,d0
	bsr.w	AssistListPush
.notnear	clr.w	d3		;d3 = requested player number
	move.b	$61(a3),d3		;next sort object
	add.w	d3,d3		;add d3 to itself
	move.w	#$FFFF,$68(a2,d3.w)		;move -1 into tmpdst
	lsr.w	#$1,d3		;divide d3 by 2
	bsr.w	SetPlayerSide
.next3	st.b	$61(a3)		;set newpnum to FF
	st.b	$60(a3)		;set newpos to FF
	adda.l	#$80,a3		;move to next sortobj (player struct)
	dbra	d4,.top
	movem.l	(sp)+,d0-d4/a0-a3
	rts
ResetBench						;remove all players from penalty box / put all players on their own bench
									;(not the injured, -3 / -4). Counts the players left in the box in PBnum
									;(home in the high nibble). .rb runs for the home team, then falls in for
									;the visitors
	clr.b	(PBnum).l
	moveq	#$10,d1
	movea.l	#tmstruct,a0
	bsr.w	.rb
	moveq	#$1,d1
	adda.w	#$366,a0		;change to Away Team
.rb	moveq	#$32,d0		;$32 = (MaxRos-1)*2 = 50 decimal
.rb1	add.b	d1,(PBnum).l
	tst.w	$68(a0,d0.w)
	ble.w	.cont
	btst	#$4,$68(a0,d0.w)		;test 3rd bit in tmpdst (4 decimal)
	beq.w	.next3		;not in the box: mark on the bench unless injured
	move.w	$68(a0,d0.w),d2		;move tmpdst into d2
	andi.w	#$7FF,d2		;mask 7FF with d2. Passes lowest 11 bits
	bne.w	.next3
	sub.b	d1,(PBnum).l
	bra.w	.next3
.cont	sub.b	d1,(PBnum).l
	cmpi.w	#$FFFD,$68(a0,d0.w)		;compare -3 with tmpdst
	beq.w	.next3
	cmpi.w	#$FFFC,$68(a0,d0.w)		;compare -4 with tmpdst
	beq.w	.next3
	move.w	#$FFFE,$68(a0,d0.w)		;move -2 into tmpdst
.next3	subi.w	#$2,d0		;previous roster entry
	bpl.w	.rb1
	rts
Setplass						;set players (a3) initial assignment from .alist by position
	move.w	$34(a3),d0
	bmi.w	rtss2
	lea.l	.next(pc),a0
	move.b	(a0,d0.w),d0
	bra.w	assreplace
.next	dc.w	$0E02		;assgoalie
setplayer						;bring player onto the ice and set his attributes. d3 = offset of player
									;on roster, a3 = sortcord of player. Reads the roster bytes through
									;AttributeCalc (attribute number in TempWord2). Adds the PP / PK, home /
									;away and third period bonuses (team ScoutReport bytes) to some attributes
									;and clamps them with ClampNibble
; Table of 2 words after setplayer, 4 bytes: $0203,$0503 ...
	dc.w	$0203,$0503
	btst	d2,d0

; Chooses the team structure for the player.
SetPlayerSide
	bclr	#$6,$63(a3)
	movea.l	#tmstruct,a0
	btst	#$6,$62(a3)
	beq.w	.next
	adda.w	#$366,a0
.next	move.b	d3,$66(a3)
	moveq	#$A,d0
	ext.w	d3
	add.w	d3,d3
	move.w	$68(a0,d3.w),d1
	bpl.w	.next2
	moveq	#$9,d0
	cmpi.w	#$FFFE,d1
	bne.w	.next3
.next2	bsr.w	AssistListPush
	bclr	#$5,$62(a3)
	clr.w	$58(a3)
.next3	move.w	#$FFFF,$68(a0,d3.w)
	lsr.w	#$1,d3
	movea.l	$1E(a0),a0
	move.l	a0,-(sp)
	adda.w	$8(a0),a0
	clr.l	$18AE0.l
	tst.w	$34(a3)
	beq.w	.next10
	btst	#$5,(sflags2).l
	beq.w	.next5
	jsr	(chkpk2).l
	beq.w	.next4
	move.b	$1(a0),$18AE0.l
	andi.b	#$F,$18AE0.l
	bra.w	.next5
.next4	move.b	$1(a0),d0
	lsr.b	#$4,d0
	neg.b	d0
	move.b	d0,$18AE1.l
.next5	move.b	$2(a0),d0
	andi.b	#$F,d0
	neg.b	d0
	btst	#$6,$62(a3)
	bne.w	.next6
	move.b	$2(a0),d0
	lsr.b	#$4,d0
.next6	move.b	d0,$18AE3.l
	cmpi.w	#$2,(gsp).l
	blt.w	.next10
	bgt.w	.next7
	jsr	(GetPeriodTime).l
	lsr.w	#$1,d0
	cmp.w	(gameclock).l,d0
	bgt.w	.next10
.next7	move.w	(HmGoals).l,d0
	sub.w	(AwGoals).l,d0
	beq.w	.next9
	btst	#$6,$62(a3)
	beq.w	.next8
	eori.b	#$8,ccr
.next8	bpl.w	.next10
.next9	move.b	#$2,$18AE2.l
.next10	movea.l	(sp)+,a0
	adda.w	$0(a0),a0
.loop	adda.w	(a0),a0
	adda.w	#$8,a0
	dbra	d3,.loop
	suba.w	#$8,a0
	move.b	(a0),$6F(a3)
	move.b	$1(a0),d3
	andi.w	#$F0,d3
	lsr.w	#$1,d3
	move.b	d3,$67(a3)
	move.b	$1(a0),d3
	andi.b	#$F,d3
	move.w	#$3,(TempWord2).l
	jsr	(AttributeCalc).l
	move.b	d3,$68(a3)
	move.b	$2(a0),d3
	lsr.b	#$4,d3
	move.w	#$4,(TempWord2).l
	jsr	(AttributeCalc).l
	move.b	d3,$69(a3)
	move.b	$2(a0),d3
	andi.b	#$F,d3
	move.w	#$5,(TempWord2).l
	jsr	(AttributeCalc).l
	add.b	$18AE0.l,d3
	add.b	$18AE1.l,d3
	add.b	$18AE3.l,d3
	add.b	$18AE2.l,d3
	bsr.w	.next12
	lsr.b	#$1,d3
	eori.b	#$F,d3
	addi.b	#$F,d3
	lsr.b	#$1,d3
	move.b	d3,$6A(a3)
	move.b	$3(a0),d3
	lsr.b	#$4,d3
	move.w	#$6,(TempWord2).l
	jsr	(AttributeCalc).l
	add.b	$18AE3.l,d3
	bsr.w	.next12
	lsr.b	#$1,d3
	eori.b	#$F,d3
	addi.b	#$F,d3
	lsr.b	#$1,d3
	move.b	d3,$6B(a3)
	move.b	$3(a0),$6C(a3)
	andi.b	#$F,$6C(a3)
	move.b	$6C(a3),d3
	move.w	#$7,(TempWord2).l
	jsr	(AttributeCalc).l
	move.b	d3,$6C(a3)
	move.b	$4(a0),d3
	lsr.b	#$4,d3
	move.w	#$8,(TempWord2).l
	jsr	(AttributeCalc).l
	add.b	$18AE2.l,d3
	bsr.w	.next12
	move.b	d3,$75(a3)
	bclr	#$3,$4(a3)
	move.b	$4(a0),$76(a3)
	andi.b	#$1,$76(a3)
	eori.b	#$1,$76(a3)
	bne.w	.next11
	bset	#$3,$4(a3)
.next11	move.b	$4(a0),$74(a3)
	andi.b	#$E,$74(a3)
	move.b	$5(a0),d3
	lsr.b	#$4,d3
	move.w	#$A,(TempWord2).l
	jsr	(AttributeCalc).l
	add.b	$18AE0.l,d3
	add.b	$18AE1.l,d3
	add.b	$18AE3.l,d3
	bsr.w	.next12
	move.b	d3,$71(a3)
	move.b	$5(a0),d3
	andi.b	#$F,d3
	move.w	#$B,(TempWord2).l
	jsr	(AttributeCalc).l
	add.b	$18AE0.l,d3
	add.b	$18AE1.l,d3
	add.b	$18AE3.l,d3
	bsr.w	.next12
	move.b	d3,$6D(a3)
	move.b	$6(a0),d3
	lsr.b	#$4,d3
	move.w	#$C,(TempWord2).l
	jsr	(AttributeCalc).l
	move.b	d3,$72(a3)
	move.b	$6(a0),d3
	andi.b	#$F,d3
	move.w	#$D,(TempWord2).l
	jsr	(AttributeCalc).l
	add.b	$18AE2.l,d3
	add.b	$18AE2.l,d3
	bsr.w	.next12
	move.b	d3,$70(a3)
	move.b	$7(a0),d3
	lsr.b	#$4,d3
	move.w	#$E,(TempWord2).l
	jsr	(AttributeCalc).l
	add.b	$18AE0.l,d3
	add.b	$18AE3.l,d3
	bsr.w	.next12
	move.b	d3,$6E(a3)
	move.b	$7(a0),$73(a3)
	move.b	$73(a3),d3
	andi.b	#$F,d3
	move.w	#$F,(TempWord2).l
	jsr	(AttributeCalc).l
	move.b	d3,$73(a3)
	andi.b	#$F,$73(a3)
	rts
.next12	tst.b	d3
	bpl.w	.next13
	clr.w	d3
.next13	cmpi.b	#$1E,d3
	ble.w	.ex
	move.w	#$1E,d3
.ex	rts
; Vertical interrupt handler of the ice setup
SetupIceVBlankHandler
; Vertical interrupt body: dma list, palettes and the sub CPU handshake
VBlankMainHandler	movem.l	d0-d7/a0-a6,-(sp)
	btst.b	#$2,(disflags).l
	bne.w	.next2
	bclr.b	#$0,(disflags).l
	beq.w	.next
	bsr.w	VBlankDmaList
.next	bsr.w	ForceBlackStep
.next2	btst.b	#$0,(sflags).l
	bne.w	.loop
	btst.b	#$2,(gmode2).l
	bne.w	.next3
	btst.b	#$0,(gmode).l
	bne.w	.loop
.next3	btst.b	#$1,(gmode2).l
	bne.w	.next4
	tst.w	(gameclock).l
	beq.w	.loop
	subi.w	#$AAA,$180E8.l
	bcc.w	.loop
	bset.b	#$3,(disflags).l
	subq.w	#$1,(gameclock).l
	cmpi.w	#$3D,(gameclock).l
	bgt.w	.loop
	cmpi.w	#$3C,(gameclock).l
	blt.w	.loop
	move.w	#$2,-(sp)
	bsr.w	GateArrayCommandSend
.loop	addq.w	#$1,(ScoutSubStatus).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.next4	tst.w	(shootoutclock).l
	beq.w	.loop
	subi.w	#$AAA,$193B8.l
	bcc.w	.loop
	bset.b	#$3,(disflags).l
	btst.b	#$7,(gmode2).l
	bne.w	.loop
	subq.w	#$1,(shootoutclock).l
	bra.w	.loop