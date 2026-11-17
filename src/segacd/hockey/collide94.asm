checkcoll						;d2 = new x coord, d3 = new y coord, a3 = struct of object. Check wall
									;collision (around the hot spot and the end of the stick) and player
									;collisions, then move a3 in the OOlist sort order by its y. If a player
									;collision set collflag, restore the old x/y instead. Called from
									;updateplayers
	clr.w	$17EEE.l
	btst	#$7,$17F6A.l		;check if in horiz mode
	beq.w	.next		;branch if not horizontal
	exg.l	d2,d3
.next	btst	#$2,$62(a3)		;check if in no collision mode
	bne.w	.next3		;branch if no collision
	movem.l	d0-d7,-(sp)
	move.w	$0(a3),d2		;Xpos
	move.w	$14(a3),d3		;Ypos - check coll around hot spot with wall
	move.w	$4A(a3),$17CF4.l
	move.w	$4C(a3),$17CF6.l
	bsr.w	checkwallcoll
	move.w	$4E(a3),d0
	or.w	$50(a3),d0
	bne.w	.next2		;coll didnt happen
	cmpi.w	#$B,$52(a3)		;check if a3 is a player
	bgt.w	.next2		;branch if not a player
	movem.l	(sp),d0-d7
	move.l	a3,-(sp)
	bsr.w	GetHotCount
	move.w	$0(a3),d2		;Xpos
	move.w	$14(a3),d3
	add.w	d0,d2
	add.w	d1,d3		;check coll around end of stick with wall
	move.w	#$1,$17CF4.l
	move.w	#$1,$17CF6.l
	bsr.w	checkwallcoll
.next2	movem.l	(sp)+,d0-d7
	bsr.w	checkplcoll		;check coll with other players
.next3	tst.w	$17EEE.l		;now check order of sprites
	bne.w	.next6
	move.w	$52(a3),d0
	asl.w	#$1,d0		;current object number
	movea.l	#$17CA0,a0
	movea.l	#$17CC0,a1
	movea.l	#$17C80,a2
	move.w	(a0,d0.w),d1		;current objects pos in OOlist
.loop	cmpi.w	#$F,d1		;Sortobjs-1
	beq.w	.next4		;is it top sprite on screen
	clr.w	d4
	move.b	$1(a1,d1.w),d4		;next higher object number
	cmp.w	(a2,d4.w),d3		;YPos of next higher object
	ble.w	.next4
	addq.w	#$1,(a0,d0.w)
	subq.w	#$1,(a0,d4.w)
	move.b	d4,(a1,d1.w)		;next higher object into this entry
	move.b	d0,$1(a1,d1.w)		;this object into the next entry
	addq.w	#$1,d1
	bra.w	.loop
.next4	move.w	(a0,d0.w),d1		;current objects pos in OOlist
	beq.w	.next5
.loop2	clr.w	d4
	move.b	-$1(a1,d1.w),d4		;next lower object number
	cmp.w	(a2,d4.w),d3		;compare to Y pos of next lower object
	bge.w	.next5
	subq.w	#$1,(a0,d0.w)
	addq.w	#$1,(a0,d4.w)
	move.b	d4,(a1,d1.w)		;next lower object into this entry
	move.b	d0,-$1(a1,d1.w)		;this object into the previous entry
	subq.w	#$1,d1
	bne.w	.loop2
.next5	move.w	d3,(a2,d0.w)		;update Ylist
	rts
.next6	move.w	$1C(a3),$0(a3)		;move OldXpos into Xpos
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
	movea.l	#$17CA0,a0
	movea.l	#$17CC0,a1
	movea.l	#$17C80,a2
	move.w	(a0,d0.w),d1		;current objects pos in OOlist
.loop	cmpi.w	#$F,d1		;#sortobjs-1
	beq.w	.next		;it is top sprite on screen
	clr.w	d4
	move.b	$1(a1,d1.w),d4		;next higher object number
	move.w	(a2,d4.w),d5		;y pos of next higher object
	sub.w	d3,d5
	cmpi.w	#$10,d5
	bgt.w	.next		;no higher sprite coll
	bsr.w	checkcx
	addq.w	#$1,d1
	bra.w	.loop
.next	move.w	(a0,d0.w),d1
	beq.w	.ex
.loop2	clr.w	d4		;loop: lower neighbours
	move.b	-$1(a1,d1.w),d4		;next lower object number
	move.w	d3,d5
	sub.w	(a2,d4.w),d5		;y pos of next lower object
	cmpi.w	#$10,d5
	bgt.w	.ex
	bsr.w	checkcx
	subq.w	#$1,d1
	bne.w	.loop2
.ex	rts
checkcx						;d4 = obj. # * 2 for possible collision so check x range and distance for
									;collision. d2 = x, d5 = delta y, a3 = moving object. Opposing players add
									;impact and run newcheck, checkint, checkcheck and checkfight (an rts);
									;then momentum moves from a3 to a2. Called from checkplcoll
	movem.l	d0-d7/a0-a3,-(sp)
	asl.w	#$6,d4
	movea.l	#$17480,a2
	adda.w	d4,a2		;add d4 to a2. a2 now address of SCStruct-1
	btst	#$2,$62(a2)		;test pfnc pflags = no collision mode
	bne.w	.loop		;object has no collision mode on
	btst	#$5,$63(a2)		;pf2npc(pflags2) = another no collision mode
	bne.w	.loop		;exit if no collision mode on
	cmpi.w	#$B,$52(a2)		;comparing 11 with SCnum for player. Player SCnum are 0-11.
	bgt.w	.loop
	move.w	$0(a2),d0		;Xpos
	btst	#$7,$17F6A.l		;sfhor(sflags) = screen in horizontal mode
	beq.w	.next		;branch if not in horiz mode
	move.w	$14(a2),d0
.next	sub.w	d2,d0		;subtract d2 from d0
	cmpi.w	#$FFF0,d0		;compare delta Xpos to -collrad*2
	blt.w	.loop		;branch if less than
	cmpi.w	#$10,d0		;compare delta Xpos to collrad*2
	bgt.w	.loop		;branch if greater than
	muls.w	d5,d5
	muls.w	d0,d0
	add.l	d5,d0
	cmpi.l	#$100,d0		;compare d0 to (collrad*2)*(collrad*2)
	bgt.w	.loop		;branch if outside of radius
	move.w	#$0,$17EF0.l		;evalue = elasticity value
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
	bmi.w	.next8		;no collision if v1n < 0
	asr.l	#$4,d1
	btst	#$6,d6
	beq.w	.next7		;players are on same team
	move.w	d1,d4
	lsr.w	#$8,d4
	cmpi.w	#$5,d4
	bgt.w	.next2
	moveq	#$5,d4		;minimum impact value
.next2	add.w	d4,$32(a3)
	add.w	d4,$32(a2)
	btst	#$0,$63(a2)
	bne.w	.next3
	move.w	$52(a3),$2E(a2)		;SCnum(a3), impactp(a2) = moves a3 SCnum into past impact player for a2
.next3	btst	#$0,$63(a3)
	bne.w	.next4
	move.w	$52(a2),$2E(a3)		;SCnum(a2), impactp(a3) = moves a2 SCnum into past impact player for a3
.next4	cmpi.w	#$14,d4		;impact under 20: no check sound
	blt.w	.next6
	move.w	$17BE0.l,d0		;check sound only if one of them has the puck
	cmp.w	$52(a3),d0
	beq.w	.next5
	cmp.w	$52(a2),d0
	bne.w	.next6
.next5	bsr.w	newcheck
.next6	bsr.w	checkint		;interference, check and fight tests
	bsr.w	CheckIntBothSides
	bsr.w	setInjuryTypeExit
.next7	move.w	d1,d4
	movem.w	(sp)+,d0-d1
	tst.w	$17EEE.l		;set to -1 by holdcheck / Bcheck: no transfer
	bmi.w	.loop
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
	move.w	$17EF0.l,d7
	mulu.w	d1,d7
	lsr.w	#$4,d7
	add.w	d0,d1
	sub.w	d7,d0
	muls.w	d4,d0
	divs.w	d1,d0
	move.w	$17EF0.l,d1
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
	st.b	$17EEE.l
.loop	movem.l	(sp)+,d0-d7/a0-a3
	rts
.next8	addq.w	#$4,sp
	bra.w	.loop
newcheck						;start a new check sound: one of 4 sounds $1C-$1F, never the last one
									;again. Called from checkcx; FallDown branches here when the player who
									;fell did not have the puck
	move.l	d0,-(sp)
	moveq	#$3,d0
	bsr.w	randomd0
	addq.w	#$1,d0		;1-3 sounds on from the last one
	add.w	$17F62.l,d0
	andi.w	#$3,d0
	move.w	d0,$17F62.l
	addi.w	#$1C,d0		;first check sound (92 used 18)
	move.w	d0,-(sp)
	bsr.w	sfx
	move.l	(sp)+,d0
	rts
checkint						;check for interference penalty. player a2 interferes with a3 or
									;vice-versa; goalie is only player who can cause an interference call.
									;Called from checkcx
	move.l	d0,-(sp)
	bsr.w	.next
	exg.l	a2,a3
	bsr.w	.next
	exg.l	a2,a3
	move.l	(sp)+,d0
	rts
.next	tst.w	$34(a2)
	bne.w	rtss2		;exits if not goalie
	btst	#$0,$17F68.l		;test gmclock(gmode). Is there play
	bne.w	rtss2		;no fall downs during celebration
	move.w	$17BE0.l,d0		;Puck carrier's SCnum
	cmp.w	$52(a3),d0		;SCnum of this struct
	beq.w	.next2		;jump if a3 carrying puck
	cmpi.w	#$19,$32(a3)		;compare $19 to impact
	ble.w	rtss2		;exit if less than or equal
.next2	cmpi.w	#$2,$32(a3)		;compare 2 to impact
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
	beq.w	.next3		;jump if home (team1)
	move.w	#$2,d0		;set d0 to team2 value
.next3	cmp.w	$17FA6.l,d0
	beq.w	.next4
	cmp.w	$17FA8.l,d0
	bne.w	.next5		;branch if controlled by CPU
.next4	btst	#$3,$62(a3)		;pfjoycon - check if player controlled
	beq.w	rtss2		;exit if not player controlled
.next5	move.w	$14(a2),d0
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
	btst	#$4,$17F68.l		;Check if highlight, exit if so
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
	btst	#$0,$17F68.l
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
	clr.w	$17E62.l
	move.b	$75(a3),$17E63.l
	lsr.w	$17E62.l
	cmp.b	$17E63.l,d0
	ble.w	.next5
	bsr.w	CheckAggressionScale
	cmpi.w	#$4,d0
	bhi.w	rtss2
	btst	#$4,$17F68.l
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
	btst	#$4,$17F68.l
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
	sub.w	$17B80.l,d1
	cmpi.w	#$28,d1
	bgt.w	.next2
	cmpi.w	#$FFD8,d1
	blt.w	.next2
	move.w	$14(a3),d1
	sub.w	$17B94.l,d1
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
	btst	#$2,$17F7E.l
	bne.w	.next7
	bra.w	.ex
.next6	btst	#$1,$17F7E.l
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
	move.w	$17BE0.l,d0
	cmp.w	$52(a3),d0
	bne.w	.next
	bclr	#$3,$17F6A.l
.next	move.w	$28(a3),d0
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
	beq.w	.next2
	move.w	#$1154,d1
.next2	bsr.w	SetSPA
	bsr.w	CheckAggressionScale
	cmpi.w	#$6,d0
	bhi.w	.next4
	btst	#$4,$17F68.l
	bne.w	.next4
	move.w	#$24,d0
	cmpi.w	#$CC2,$58(a3)
	beq.w	.next3
	move.w	#$1E,d0
.next3	jsr	(PenShotChk).l
	bsr.w	AddPenalty
.next4	exg.l	a2,a3
	st.b	$17EEE.l
	rts
Bcheck
	btst	#$5,$62(a3)
	bne.w	rtss2
	tst.w	$34(a3)
	beq.w	rtss2
	btst	#$0,$63(a3)
	bne.w	rtss2
	tst.w	$18C08.l
	bne.w	.next3
	btst	#$3,$62(a2)
	beq.w	.next3
	moveq	#$20,d0
	add.b	$75(a2),d0
	sub.b	$68(a3),d0
	btst	#$1,$17F7C.l
	bne.w	.next
	btst	#$6,$17F7A.l
	beq.w	.next2
.next	subi.b	#$2,d0
.next2	bsr.w	randomd0
	cmpi.w	#$18,d0
	blt.w	rtss2
.next3	move.w	$0(a3),d0
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
	st.b	$17EEE.l
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
	cmpa.l	$1AD7E.l,a2
	bne.w	.next
	cmpa.l	$1AD82.l,a3
	bne.w	.next
	rts
.next	move.l	a2,$1AD7E.l
	move.l	a3,$1AD82.l
	btst	#$3,$64(a2)
	bne.w	rtss2
	btst	#$3,$64(a3)
	bne.w	rtss2
	move.w	#$11E6,d1
	btst	#$4,$64(a3)
	bne.w	.next2
	cmpi.b	#$18,$71(a2)
	blt.w	.next2
	tst.b	$5F(a2)
	bne.w	.next2
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
	ble.w	.next2
	move.b	#$3C,$5F(a2)
	bra.w	FallDownStart
.next2	tst.w	$34(a3)
	beq.w	.next4
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
	bne.w	.next4
	addi.w	#$2,$180EC.l
.next4	move.b	#$78,$5E(a2)
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
	bpl.w	.next5
	neg.w	d1
.next5	move.w	$2A(a2),d2
	bpl.w	.next6
	neg.w	d2
.next6	move.w	$0(a2),d3
	sub.w	$0(a3),d3
	move.w	$14(a2),d4
	sub.w	$14(a3),d4
	cmpi.w	#$108,$14(a3)
	bgt.w	.next9
	cmpi.w	#$FEF8,$14(a3)
	blt.w	.next8
	tst.w	$0(a3)
	bpl.w	.next7
	tst.w	d3
	bpl.w	.next10
	cmpi.w	#$FFFD,d3
	bgt.w	.next10
	bra.w	.next11
.next7	tst.w	d3
	bmi.w	.next10
	cmpi.w	#$3,d3
	blt.w	.next10
	bra.w	.next11
.next8	tst.w	d4
	bpl.w	.next10
	bra.w	.next11
.next9	tst.w	d4
	bmi.w	.next10
	bra.w	.next11
.next10	movem.l	(sp)+,d1-d4
	bra.w	FallDownSpeed
.next11	movem.l	(sp)+,d1-d4
	bra.w	.next12
.next12	cmpi.w	#$10C,$14(a2)
	bgt.w	.next13
	cmpi.w	#$FEF4,$14(a2)
	blt.w	.next13
	cmpi.w	#$68,$0(a2)
	bgt.w	.next13
	cmpi.w	#$FF98,$0(a2)
	blt.w	.next13
	bra.w	FallDownSpeed
.next13	cmpi.w	#$B,$52(a3)
	bgt.w	.next14
	addi.w	#$A,$17CD8.l
	addi.w	#$96,(Crowdlevel).l
	move.w	d1,-(sp)
	move.b	#$0,$40(a3)
	move.b	#$0,$65(a3)
	move.w	#$1AC2,d1
	jsr	(SetSPA).l
	clr.w	$28(a3)
	clr.w	$2A(a3)
	move.w	(sp)+,d1
.next14	movem.l	d0/a0,-(sp)
	cmpi.w	#$10C,$14(a2)
	bgt.w	.next16
	cmpi.w	#$FEF4,$14(a2)
	blt.w	.next17
	tst.w	$0(a2)
	bmi.w	.next15
	move.w	#$2,d0
	bra.w	.next18
.next15	move.w	#$6,d0
	bra.w	.next18
.next16	move.w	#$0,d0
	bra.w	.next18
.next17	move.w	#$4,d0
.next18	add.w	d0,d0
	movea.l	#$3AD3A,a0
	move.w	(a0,d0.w),d1
	move.w	$14(a2),$1937C.l
	move.w	$0(a2),$1937E.l
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
	beq.w	.next22
	move.w	#$1A00,d1
	bra.w	.next22
.next19	cmpi.w	#$17E8,d1
	bne.w	.next20
	cmpi.w	#$38,$14(a2)
	bgt.w	.next20
	cmpi.w	#$FFC8,$14(a2)
	blt.w	.next20
	move.w	#$1A00,d1
	btst	#$3,$4(a2)
	beq.w	.next22
	move.w	#$193E,d1
	bra.w	.next22
.next20	btst	#$3,$4(a2)
	beq.w	.next22
	cmpi.w	#$17E8,d1
	beq.w	.next21
	cmpi.w	#$18CC,d1
	bne.w	.next22
	move.w	#$17E8,d1
	bra.w	.next22
.next21	move.w	#$18CC,d1
.next22	clr.w	$28(a2)
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
	addi.w	#$F,$17CD8.l
.next	move.w	$17BE0.l,d0
	bmi.w	newcheck
	cmp.w	$52(a2),d0
	bne.w	newcheck
	st.b	$17BE0.l
	btst	#$4,$17F68.l
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
	btst	#$0,$17F68.l
	bne.w	.next3
	exg.l	a2,a3
	move.w	#$145C,d1
	bsr.w	SetSPA
	exg.l	a2,a3
	bsr.w	setInjuryType
	btst	#$5,$17F7A.l
	bne.w	.next2
	exg.l	a2,a3
	move.w	#$1AF4,d1
	bsr.w	SetSPA
	exg.l	a2,a3
.next2	move.w	#$4,$1806A.l
	moveq	#$14,d0
	tst.w	$34(a3)
	beq.w	AddPenalty2
	tst.w	$18C08.l
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
	addi.w	#$1E,$17CD8.l
	move.w	#$D,-(sp)
	bsr.w	sfx
	move.w	$0(a2),$17EDC.l		;move Xpos to scroll center
	move.w	$14(a2),$17EDE.l		;move Ypos to scroll center
	bset	#$6,$17F6A.l		;set sfslock (scroll lock)
	clr.w	d1
	movea.l	#tmstruct,a0		;move Home team Struct to a0
	btst	#$6,$62(a2)		;check if player home or away
	beq.w	.0
	move.w	#$8000,d1		;move $8000 into d1
	adda.w	#$366,a0		;add $364 to a0 (Away Team Struct start)
.0	move.b	$66(a2),d1		;move roster offset into d1
	move.w	d1,$180EE.l
	ext.w	d1		;sign extend - in this case just makes upper bye of word 00
	add.w	d1,d1		;add d1 to itself
	exg.l	a2,a3		;swap a2 and a3
	jsr	(getFgtbyte).l		;get the Fgt byte (divided by 4)
	exg.l	a2,a3
	tst.w	d0		;check if d0 is zero
	bne.w	.not0		;branch if H/F was more than 3
	bclr	#$5,$17F7A.l		;clear injury game bit
	move.w	#$FFFD,$68(a0,d1.w)		;update status of player
	bra.w	.exit
.not0	cmpi.w	#$3,d0		;compare d0 to 3 (if H/F was 12, d0 = 3)
	beq.w	.injurygame
	bclr	#$5,$17F7A.l
	move.w	#$FFFD,$68(a0,d1.w)		;update status of player
	jsr	(GetFgtByteReturn).l		;check Fgt bit 1 of player.
	beq.w	.exit		;jump if Fgt not 2,6,A
.injurygame	bset	#$5,$17F7A.l		;set injury game bit
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
	sub.w	$17CF4.l,d4
	move.w	#$12A,d5
	sub.w	$17CF6.l,d5
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
	add.w	$17CF4.l,d4
	cmp.w	d4,d2
	bgt.w	rtss2
	neg.w	d4
	cmp.w	d4,d2
	blt.w	rtss2
	sub.w	$14(a2),d3
	move.w	#$2,d5
	add.w	$17CF6.l,d5
	cmp.w	d5,d3
	bgt.w	rtss2
	neg.w	d5
	cmp.w	d5,d3
	blt.w	rtss2
	st.b	$17EEE.l
	cmpi.w	#$D,$24(a3)
	blt.w	.next2
	move.w	$24(a3),$18(a3)
	bra.w	.next9
.next2	bclr	#$7,$62(a3)
	move.w	$17BE0.l,d0
	bmi.w	.next4
	st.b	$17BE0.l
	asl.w	#$7,d0
	movea.l	#$17480,a0
	move.b	#$8,$5E(a0,d0.w)
	move.w	$17B94.l,d1
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
	btst	#$0,$17F68.l
	bne.w	.next7
	move.w	#$8,(sp)
	addi.w	#$12C,(Crowdlevel).l
	addi.w	#$28,$17CD8.l
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
.next11	btst	#$2,$17F70.l
	beq.w	.next18
	btst	#$0,$17F78.l
	bne.w	.next12
	movem.l	d0/a0,-(sp)
	move.w	$19368.l,d0
	asl.w	#$7,d0
	movea.l	#$17480,a0
	adda.w	d0,a0
	btst	#$7,$62(a0)
	movem.l	(sp)+,d0/a0
	bne.w	.next13
	bra.w	.next14
.next12	tst.w	$1A436.l
	bne.w	.next14
.next13	tst.w	$17B94.l
	bmi.w	rtss2
	bra.w	.next15
.next14	tst.w	$17B94.l
	bpl.w	rtss2
.next15	bset	#$5,$17F72.l
	tst.w	$1A436.l
	beq.w	.next16
	addi.w	#$1,$1A418.l
	bra.w	.next17
.next16	addi.w	#$1,$1A416.l
.next17	bset	#$0,$17F7C.l
	jsr	(EndPenaltyShotPlay).l
	bra.w	.next19
.next18	btst	#$0,$17F68.l
	bne.w	rtss2
.next19	bset	#$0,$17F72.l
	bclr	#$3,$17F7C.l
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
.next20	btst	#$1,$17F68.l
	beq.w	.next21
	exg.l	a1,a2
.next21	addi.w	#$1,$C(a2)
	btst	#$5,$17F72.l
	beq.w	.next22
	btst	#$0,$17F78.l
	bne.w	.next22
	addi.w	#$1,$364(a2)
.next22	bclr	#$4,$17F78.l
	beq.w	.next23
	addi.w	#$1,$35C(a2)
.next23	btst	#$5,$17F6C.l
	beq.w	.next25
	btst	#$6,$17F6C.l
	bne.w	.next24
	cmpa.l	#$186B2,a2
	bne.w	.next25
.loop2	addi.w	#$1,$358(a2)
	bra.w	.next25
.next24	cmpa.l	#$1834C,a2
	beq.w	.loop2
.next25	movem.l	d0/a2,-(sp)
	move.w	$180E4.l,d0
	add.w	d0,d0
	adda.w	d0,a2
	addi.w	#$1,$344(a2)
	movem.l	(sp)+,d0/a2
	bclr	#$7,$17F7C.l
	beq.w	.next26
	addi.w	#$1,$360(a2)
.next26	cmpa.l	#$1834C,a2
	bne.w	.next27
	move.w	(HomeTeam).l,$1A56C.l
	move.w	#$3,$1A56E.l
	jsr	(ChooseSong).l
	move.w	$1A56A.l,-(sp)
	bsr.w	song
.next27	cmpi.w	#$168,$180F0.l
	bne.w	.next28
	subi.w	#$6,$180F0.l
.next28	movea.l	#$180F2,a0
	adda.w	$180F0.l,a0
	addi.w	#$6,$180F0.l
	bsr.w	GetPeriodTimeRemaining
	move.w	d0,(a0)+
	moveq	#$2,d0
	add.w	$26(a2),d0
	sub.w	$26(a1),d0
	move.b	d0,(a0)+
	addi.w	#$1E,$17CD8.l
	cmpa.l	#$1834C,a2
	beq.w	.next29
	subi.w	#$14,$17CD8.l
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
	bclr	#$3,$17F70.l
	bsr.w	printscores1
	move.w	#$2710,$17F82.l
	btst	#$0,$17F78.l
	beq.w	.next32
	bra.w	.next33
.next32	moveq	#$7,d0
	bsr.w	.next36
.next33	clr.w	$17EEE.l
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
	move.w	$180E4.l,d0
	swap	d0
	clr.w	d0
	lsr.l	#$2,d0
	or.w	$180EA.l,d0
	sub.w	$180E6.l,d0
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
	bhi.w	.next
	asl.w	#$4,d3
	muls.w	d3,d3
	divu.w	#$79,d3
	add.w	d2,d3
	cmpi.w	#$100,d3
	bhi.w	.next
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
.next	movem.w	(sp)+,d2-d3
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
	move.w	$17B94.l,d0
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
	bset	#$6,$17F6A.l
	btst	#$0,$17F68.l
	bne.w	rtss2
	moveq	#$8,d0
	bra.w	AddPenalty2
wallcollb	cmpi.w	#$E,$52(a3)
	bne.w	wallcoll
	cmpi.w	#$1D,$18(a3)
	bgt.w	.next
	cmpi.w	#$12,$18(a3)
	bls.w	wallcoll
	cmpi.w	#$118,$14(a3)
	blt.w	.next
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
	addi.w	#$F,$17CD8.l
.next	bset	#$6,$17F6A.l
	bset	#$2,$62(a3)
	tst.w	$14(a3)
	bpl.w	.next2
	ori.w	#$8000,$4(a3)
.next2	clr.w	$86(a3)
	btst	#$0,$17F68.l
	bne.w	rtss2
	move.l	a3,-(sp)
	move.w	$17EC8.l,d0
	asl.w	#$7,d0
	movea.l	#$17480,a3
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
	bclr	#$4,$17F6C.l
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
	movea.l	#$17CA0,a0
	movea.l	#$17CC0,a1
	movea.l	#$17C80,a2
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
	cmp.w	$17BE0.l,d4
	beq.w	PuckCollisionReturn
	cmpi.w	#$B,d4
	bgt.w	PuckCollisionReturn
	asl.w	#$7,d4
	movea.l	#$17480,a2
	adda.w	d4,a2
	btst.b	#$2,$17F70.l
	beq.w	.next
	asr.w	#$7,d4
	cmp.w	$19368.l,d4
	beq.w	.next
	cmp.w	$1936A.l,d4
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
	btst.b	#$1,$17F7C.l
	bne.w	.next
	btst.b	#$6,$17F7A.l
	beq.w	.next2
.next	addi.b	#$2,d0
.next2	lsr.w	#$1,d0
	btst.b	#$3,$62(a2)
	beq.w	.next3
	move.w	#$F,d0
.next3	add.w	d0,d0
	btst.b	#$0,$17F78.l
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
	btst.b	#$1,$17F76.l
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
	cmpi.w	#$F,$17B98.l
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
	move.w	$17BE0.l,d0
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
	bne.w	.next		;branch if not goalie
	btst	#$4,$17F68.l
	bne.w	rtss2		;exit if so (goalie always lets the shot in)
.next	bclr	#$0,$62(a2)
	move.w	$17BE0.l,d1		;move puckc into d1
	bmi.w	.next6		;branch if no puck carrier
	asl.w	#$7,d1
	movea.l	#$17480,a0
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
	bra.w	.next3
.next2	cmpi.l	#$24,d0
	bhi.w	rtss2
.next3	tst.w	$34(a2)		;check if colliding player is goalie
	beq.w	.next5
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
	bra.w	.next5
.next4	cmpi.w	#$2,d0		;compare 2 to d0
	bhi.w	rtss2		;exit if higher (not losing puck)
.next5	move.b	$71(a0),d0		;Stk of puckc
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
	move.w	$52(a0),$17E2A.l
	bclr	#$2,$17F6A.l		;clear pass dir mode
	bclr	#$3,$17F6A.l		;clear shot dir mode
.loop	move.w	#$6,-(sp)
	bsr.w	sfx
	bsr.w	a2touchpuck		;deflect
	bra.w	deflect		;no carrier (goalie in the smaller range): one-timer check
.next6	tst.w	$34(a2)
	bne.w	.next7
	cmpi.l	#$40,d0
	bhi.w	rtss2		;smaller range for stealing puck
.next7	btst	#$3,$64(a2)
	beq.w	.next8
	cmpi.l	#$64,d0		;not a one-timer, or past its frame: catch or deflect by puck speed
	bhi.w	.next11
	cmpi.w	#$18,$5A(a2)
	bge.w	.next8
	move.w	#$18,$5A(a2)
	bset	#$7,$17F7C.l
.next8	move.w	$17BA8.l,d0
	move.w	$17BAA.l,d1
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	clr.w	d1
	btst	#$4,$17F6C.l		;check if shot was taken
	bne.w	.next9
	btst	#$3,$64(a2)		;check if one timer
	bne.w	.next10
	move.b	$71(a2),d1
	mulu.w	#$15E,d1
.next9	addi.w	#$32C8,d1
	mulu.w	d1,d1
	cmp.l	d1,d0
	bls.w	puckglue
	move.b	#$8,$5E(a2)
	bra.w	.loop
.next10	exg.l	a2,a3
	jsr	(onetimershot).l
	exg.l	a2,a3
	rts
.next11	cmpi.l	#$144,d0
	bhi.w	.ex
	cmpi.w	#$18,$5A(a2)
	bge.w	.ex
	move.w	#$18,$5A(a2)
.ex	rts
puckglue						;part of puckstick that puckgoalie also branches to. Player a2 takes the
									;puck: faceoff and pass stats, crowd song, goalie hold time (temp5), then
									;.setd0player
	move.w	#$7,-(sp)
	move.w	$52(a2),d0		;move SCnum into d0
	move.w	d0,$17BE0.l		;move d0 into puckc
	movea.l	#tmstruct,a0		;Move Home Stats struct into a0
	lea.l	$366(a0),a1
	btst	#$6,$62(a2)		;check if player is home or away
	bne.w	.next
	exg.l	a0,a1
.next	st.b	$1A(a0)		;FF into assist 1
	st.b	$1C(a0)		;FF into assist 2
	bset	#$3,$32(a0)		;set a flag (not sure what)
	bclr	#$4,$17F6E.l		;clear flag (not sure what, might have to do with faceoff)
	beq.w	.next2		;branch if it was cleared already
	addi.w	#$1,$E(a1)		;add 1 to faceoff won
	addi.w	#$C8,(Crowdlevel).l
	move.w	#$C,(sp)		;move C to stack
	cmpa.l	#$1834C,a1		;compare if a1 is home
	bne.w	.next2
	addi.w	#$A,$17CD8.l
	move.w	#$B,(sp)		;Move B into stack
.next2	bsr.w	sfx
	move.w	$52(a2),d0		;move SCnum into d0
	cmp.w	$17E30.l,d0
	bne.w	.next3
	addi.w	#$1,$14(a1)
.next3	st.b	$17E30.l
	bclr	#$2,$17F6A.l		;clear pass dir mode
	bclr	#$3,$17F6A.l		;clear shot dir mode
	tst.w	$34(a2)		;check if a2 is goalie
	bne.w	.next4
	bsr.w	ChkShotStat
	move.w	#$8C,$48(a2)		;move 8C to temp5 - countdown for faceoff?
	cmpi.w	#$2F4,$58(a2)		;check for goalie dive animation
	bne.w	.next4		;branch if not equal
	move.w	#$5,$48(a2)		;set temp5 to 5
.next4	cmp.w	$17F9E.l,d0
	beq.w	rtss2
	cmp.w	$17FA0.l,d0
	beq.w	rtss2
	tst.w	$17FAA.l
	beq.w	.next5
	cmp.w	$17FA2.l,d0
	beq.w	rtss2
.next5	tst.w	$17FAC.l
	beq.w	.next6
	cmp.w	$17FA4.l,d0
	beq.w	rtss2
.next6	tst.w	$17FAA.l
	bne.w	.next7
	tst.w	$17FAC.l
	beq.w	.next9		;branch if no team
.next7	movem.l	d0/a3,-(sp)
	asl.w	#$7,d0
	movea.l	#$17480,a3
	tst.w	$34(a3,d0.w)
	bne.w	.next8
	btst	#$3,$62(a3,d0.w)		;check if d0 player controlled
	beq.w	.next8
	movem.l	(sp)+,d0/a3		;exit if player controlled
	rts
.next8	movem.l	(sp)+,d0/a3
.next9	cmpi.w	#$6,d0
	slt.b	d1
	ext.w	d1
	addi.w	#$2,d1
	move.w	$17E2A.l,d2
	cmp.w	$17FA0.l,d2
	beq.w	.next10
	cmp.w	$17FA6.l,d1
	bne.w	.next10
	jmp	(setc1player).l
.next10	cmp.w	$17FA8.l,d1
	bne.w	.next11
	jmp	(setc2player).l
.next11	cmp.w	$17FA6.l,d1
	bne.w	rtss2
	jmp	(setc1player).l
puckbody						;puck hits player a2. a3 = puck, d0 = distance^2 (from checkpuckcoll
									;.ccx). The puck bounces off. A high puck (Zpos > 8) that is fast makes a2
									;fall (FallDown, Zpos > $C); a slower one starts SPAcatch on a2
	btst	#$3,$64(a2)
	bne.w	rtss2		;real hit (low or near center): a2 touched the puck
	cmpi.w	#$8,$18(a3)
	bgt.w	.next
	move.w	d0,d1
	andi.w	#$F,d1		;radius^2 from center
	bne.w	rtss2
.next	bsr.w	a2touchpuck		;real hit: a2 touched the puck
	move.w	#$24,-(sp)
	bsr.w	sfx
	clr.w	$2C(a3)
	move.b	#$8,$5E(a2)
	move.w	$0(a3),d0		;Xpos
	sub.w	$0(a2),d0
	move.w	$14(a3),d1
	sub.w	$14(a2),d1
	bne.w	.next2
	move.l	a2,-(sp)
	bsr.w	GetHotCount
.next2	move.w	$28(a3),d2
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
	bls.w	.next3
	cmpi.w	#$C,$18(a3)
	bgt.w	FallDown
	rts
.next3	bset	#$5,$62(a2)
	bne.w	rtss2
	move.w	#$10D0,d1
	exg.l	a2,a3
	bsr.w	SetSPA
	exg.l	a2,a3
rtss2						;shared rts
	rts
; Puck collision: stick check
PuckCollisionStick	btst.b	#$4,$17F68.l
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
	cmpi.w	#$3000,$17BAA.l
	bgt.w	.next5
	cmpi.w	#$D000,$17BAA.l
	bgt.w	.next7
.next5	move.w	#$B,-(sp)
	btst.b	#$6,$62(a2)
	beq.w	.next6
	move.w	#$D,(sp)
.next6	bsr.w	sfx
.next7	move.w	#$24,-(sp)
	bsr.w	sfx
	move.w	$17BE0.l,d2
	bmi.w	.next9
	st.b	$17BE0.l
	asl.w	#$7,d2
	movea.l	#$17480,a0
	adda.w	d2,a0
	move.b	#$14,$5E(a0)
	move.w	$52(a0),$17E2A.l
	bclr.b	#$2,$17F6A.l
	bclr.b	#$3,$17F6A.l
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
.next12	cmp.w	$17BA8.l,d0
	blt.w	.loop4
	cmp.w	$17BAA.l,d0
	blt.w	.loop4
	neg.w	d0
	cmp.w	$17BA8.l,d0
	bgt.w	.loop4
	cmp.w	$17BAA.l,d0
	bgt.w	.loop4
	btst.b	#$2,$63(a2)
	bne.w	.loop4
	clr.w	$2C(a3)
	bra.w	puckglue
; Four words used by the stick check
PuckCollisionWords	dc.b	$00,$73,$00,$6E,$00,$70,$00,$72	; .s.n.p.r
deflect
	st.b	$17BE0.l
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
	btst	#$4,$17F7A.l
	beq.w	.next
	move.w	#$1000,d0
.next	movem.l	(sp)+,d1/a2-a3
	muls.w	(sp)+,d0
	asl.l	#$4,d0
	swap	d0
	ext.l	d0		;d0 = d0 * energy / 4096
	rts
getpde						;get player a3's energy level into d0. Return a2 = his team struct, d1 =
									;pnum*2
	movea.l	#tmstruct,a2
	btst	#$6,$62(a3)		;#pfteam - home or away
	beq.w	.next
	adda.w	#$366,a2
.next	move.b	$66(a3),d1
	ext.w	d1
	add.w	d1,d1
	move.w	$34(a2,d1.w),d0
	rts
setpde
	tst.w	d0
	bpl.w	.next
	clr.w	d0
.next	move.w	d0,$34(a2,d1.w)
	rts