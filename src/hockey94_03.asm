;	NHL 94 (retail) segment $138AC-$14549
;	92 hockey.asm part 2, first half, as 93 hockey93_03.asm: checkcoll, checkplcoll, checkcx, newcheck, checkint and
;	checkint_ci, checkcheck and CCStart, checkinglist, checkagr, holdcheck, Bcheck, FallDown, setInjuryType. checkfight
;	(hockey94_04, an rts in 94) follows at $1454A (bsr.w displacement at $13B1E).
;	Transcribed from lst/nhl94.bin.lst lines 48480-49542. Global names are the IDA names (this range has no IDA auto names).
;	IDA labels that would split a routine are locals: .PlayerControlled and .CheckingCalc in CCStart, .CmpPlayerStk,
;	.AddChktoPlayerStats and .FallList in FallDown. Local labels are the IDA local names (_x -> .x) or the IDA address
;	(loc_14264 -> .14264).
;	SPA values are frames94 table offsets, written as numbers with the frames94 name in the comment.
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp / cmpi;
;	fixopcodes.js patches the cmp encoding after assembly.
;	Sort struct (SortCords, $80 each): 0 Xpos, 4 attribute, $14 Ypos, $1C OldXpos, $20 OldYpos, $28 Xvel, $2A Yvel,
;	$2E impactp, $32 impact, $34 position, $40 temp1, $4A / $4C wall radius x / y, $4E wallcos, $50 wallsin, $52 SCnum,
;	$54 facedir, $58 SPA, $5E / $5F nopuck, $62 pflags, $63 pflags2, $64 bit 1 breakaway, bit 3 one-timer, bit 4 wall
;	collision, bit 5 fell, $66 pnum, $67 weight, $68 Agl, $71 Stk, $73 aggres, $74 Fgt, $75 Chk.

checkcoll	;d2 = new x coord, d3 = new y coord, a3 = struct of object. Check wall collision (around the hot spot and the end of the stick) and
	;player collisions, then move a3 in the OOlist sort order by its y. If a player collision set collflag, restore the old x/y instead. Called
	;from updateplayers
	clr.w	(collflag).w
	btst	#7,(sflags).w	;check if in horiz mode
	beq.w	.nhor1	;branch if not horizontal
	exg	d2,d3
.nhor1
	btst	#2,$62(a3)	;check if in no collision mode
	bne.w	.ex	;branch if no collision
	movem.l	d0-d7,-(sp)
	move.w	(a3),d2	;Xpos
	move.w	$14(a3),d3	;Ypos - check coll around hot spot with wall
	move.w	$4A(a3),(wcradiusx).w	;wall coll radius X
	move.w	$4C(a3),(wcradiusy).w	;wall coll radius Y
	bsr.w	checkwallcoll2
	move.w	$4E(a3),d0	;wallcos
	or.w	$50(a3),d0	;wallsin
	bne.w	.xx	;coll didnt happen
	cmpi.w	#$B,$52(a3)	;check if a3 is a player
	bgt.w	.xx	;branch if not a player
	movem.l	(sp),d0-d7
	move.l	a3,-(sp)
	bsr.w	GetHot
	move.w	(a3),d2	;Xpos
	move.w	$14(a3),d3	;Ypos
	add.w	d0,d2
	add.w	d1,d3	;check coll around end of stick with wall
	move.w	#1,(wcradiusx).w
	move.w	#1,(wcradiusy).w
	bsr.w	checkwallcoll2
.xx
	movem.l	(sp)+,d0-d7
	bsr.w	checkplcoll	;check coll with other players
.ex
	tst.w	(collflag).w	;now check order of sprites
	bne.w	.restoreold
	move.w	$52(a3),d0	;SCnum
	asl.w	#1,d0	;current object number
	movea.w	#(OOlistpos-M68K_RAM),a0
	movea.w	#(OOlist-M68K_RAM),a1
	movea.w	#(Ylist-M68K_RAM),a2
	move.w	0(a0,d0.w),d1	;current objects pos in OOlist
.2
	cmp.w	#$F,d1	;Sortobjs-1
	beq.w	.cl2	;is it top sprite on screen
	clr.w	d4
	move.b	1(a1,d1.w),d4	;next higher object number
	cmp.w	0(a2,d4.w),d3	;YPos of next higher object
	ble.w	.cl2
	addq.w	#1,0(a0,d0.w)
	subq.w	#1,0(a0,d4.w)
	move.b	d4,0(a1,d1.w)
	move.b	d0,1(a1,d1.w)
	addq.w	#1,d1
	bra.s	.2
.cl2
	move.w	0(a0,d0.w),d1	;current objects pos in OOlist
	beq.w	.ex2
.3
	clr.w	d4
	move.b	-1(a1,d1.w),d4	;next lower object number
	cmp.w	0(a2,d4.w),d3	;compare to Y pos of next lower object
	bge.w	.ex2
	subq.w	#1,0(a0,d0.w)
	addq.w	#1,0(a0,d4.w)
	move.b	d4,0(a1,d1.w)
	move.b	d0,-1(a1,d1.w)
	subq.w	#1,d1
	bne.s	.3
.ex2
	move.w	d3,0(a2,d0.w)	;update Ylist
	rts
.restoreold
	move.w	$1C(a3),(a3)	;move OldXpos into Xpos
	move.w	$20(a3),$14(a3)	;move OldYpos into Ypos
	rts
checkplcoll	;check collision with other players. d2/d3 = x/y cords, a3 = struct. Walk up and down the OOlist from a3 and call checkcx for each
	;object within $10 in y (92 collrad*2). Called from checkcoll
	btst	#5,$63(a3)	;pflags2 bit 5 (93: no player coll bit, 92 pf2npc = 7; IDA comment: line change mode)
	bne.w	.ex
	cmpi.w	#$B,$52(a3)	;#11, SCnum
	bgt.w	.ex
	move.w	$52(a3),d0	;SCnum
	asl.w	#1,d0	;current object number
	movea.w	#(OOlistpos-M68K_RAM),a0
	movea.w	#(OOlist-M68K_RAM),a1
	movea.w	#(Ylist-M68K_RAM),a2
	move.w	0(a0,d0.w),d1	;current objects pos in OOlist
.0
	cmp.w	#$F,d1	;#sortobjs-1
	beq.w	.cl	;it is top sprite on screen
	clr.w	d4
	move.b	1(a1,d1.w),d4	;next higher object number
	move.w	0(a2,d4.w),d5	;y pos of next higher object
	sub.w	d3,d5
	cmp.w	#$10,d5	;#collrad*2
	bgt.w	.cl	;no higher sprite coll
	bsr.w	checkcx
	addq.w	#1,d1
	bra.s	.0
.cl
	move.w	0(a0,d0.w),d1
	beq.w	.ex
.1
	clr.w	d4
	move.b	-1(a1,d1.w),d4	;next lower object number
	move.w	d3,d5
	sub.w	0(a2,d4.w),d5	;y pos of next lower object
	cmp.w	#$10,d5	;#collrad*2
	bgt.w	.ex
	bsr.w	checkcx
	subq.w	#1,d1
	bne.s	.1
.ex
	rts
checkcx	;d4 = obj. # * 2 for possible collision so check x range and distance for collision. d2 = x, d5 = delta y, a3 = moving object. Opposing
	;players add impact and run newcheck, checkint, checkcheck and checkfight (94: an rts); then momentum moves from a3 to a2. Called from
	;checkplcoll
	movem.l	d0-d7/a0-a3,-(sp)
	asl.w	#6,d4	;6 = scsize-1
	movea.l	#SortCords,a2	;B04A = Start of player structs (SortCords)
	adda.w	d4,a2	;add d4 to a2. a2 now address of SCStruct-1
	btst	#2,$62(a2)	;test pfnc pflags = no collision mode
	bne.w	.exit	;object has no collision mode on
	btst	#5,$63(a2)	;pf2npc(pflags2) = another no collision mode
	bne.w	.exit	;exit if no collision mode on
	cmpi.w	#$B,$52(a2)	;comparing 11 with SCnum for player. Player SCnum are 0-11.
	bgt.w	.exit	;not a player
	move.w	(a2),d0	;Xpos
	btst	#7,(sflags).w	;sfhor(sflags) = screen in horizontal mode
	beq.w	.nhor	;branch if not in horiz mode
	move.w	$14(a2),d0	;Ypos
.nhor
	sub.w	d2,d0	;subtract d2 from d0
	cmp.w	#$FFF0,d0	;compare delta Xpos to -collrad*2
	blt.w	.exit	;branch if less than
	cmp.w	#$10,d0	;compare delta Xpos to collrad*2
	bgt.w	.exit	;branch if greater than
	muls.w	d5,d5	;delta y^2
	muls.w	d0,d0	;delta x^2
	add.l	d5,d0
	cmp.l	#$100,d0	;compare d0 to (collrad*2)*(collrad*2)
	bgt.w	.exit	;branch if outside of radius
	move.w	#0,(evalue).w	;evalue = elasticity value
	move.b	$62(a3),d6	;move pflags into d6
	move.b	$62(a2),d0	;move pflags into d0
	eor.b	d0,d6	;xor d0 with d6
	move.w	$28(a3),d0	;Now do momentum transfer from object a3 to object a2
	;Xvel
	sub.w	$28(a2),d0	;subtract Xvel a2 from Xvel a3 (Vx)
	move.w	$2A(a3),d1	;Yvel
	sub.w	$2A(a2),d1	;subtract Yvel a2 from Yvel a3 (Vy)
	move.w	(a3),d2	;Xpos
	sub.w	(a2),d2	;subtract Xpos of a2 from Xpos of a3
	neg.w	d2	;Dx
	move.w	$14(a3),d3	;Ypos
	sub.w	$14(a2),d3	;subtract Ypos of a2 from Ypos of a3
	neg.w	d3	;Dy
	movem.w	d0-d1,-(sp)
	muls.w	d3,d1	;Vy*Dy
	muls.w	d2,d0	;Vx*Dx
	add.l	d0,d1	;(Vy*Dy)+(Vx*Dx)
	bmi.w	.exit4	;no collision if v1n < 0
	asr.l	#4,d1	;divide by 8
	btst	#6,d6	;pfteam(d6)
	beq.w	.not	;players are on same team
	move.w	d1,d4
	lsr.w	#8,d4	;divide by 128
	cmp.w	#5,d4
	bgt.w	.g40
	moveq	#5,d4	;minimum impact value
.g40
	add.w	d4,$32(a3)	;$32 = impact value
	add.w	d4,$32(a2)
	btst	#0,$63(a2)	;pf2fight(pflags2)
	bne.w	.if
	move.w	$52(a3),$2E(a2)	;SCnum(a3), impactp(a2) = moves a3 SCnum into past impact player for a2
.if
	btst	#0,$63(a3)	;pf2fight(pflags2)
	bne.w	.if2
	move.w	$52(a2),$2E(a3)	;SCnum(a2), impactp(a3) = moves a2 SCnum into past impact player for a3
.if2
	cmp.w	#$14,d4
	blt.w	.n1
	move.w	(puckc).w,d0
	cmp.w	$52(a3),d0	;SCnum
	beq.w	.nc
	cmp.w	$52(a2),d0	;SCNum
	bne.w	.n1
.nc
	bsr.w	newcheck
.n1
	bsr.w	checkint
	bsr.w	checkcheck
	bsr.w	checkfight	;94: an rts (hockey94_04)
.not
	move.w	d1,d4	;d1 = V1n
	movem.w	(sp)+,d0-d1
	tst.w	(collflag).w
	bmi.w	.exit
	muls.w	d2,d1	;Vy*Dx
	muls.w	d3,d0	;Vx*Dy
	sub.l	d1,d0	;(Vx*Dy)-(Vy*Dx)
	asr.l	#4,d0
	move.w	d0,d5	;V1t
	clr.w	d0
	move.b	$67(a3),d0	;wgt, m1 in calc below
	addi.w	#$8C,d0
	clr.w	d1
	move.b	$67(a2),d1	;wgt, m2 in calc below
	addi.w	#$8C,d1
	move.w	(evalue).w,d7	;e*16 value (0-16)
	mulu.w	d1,d7
	lsr.w	#4,d7	;m2*e
	add.w	d0,d1	;m1+m2
	sub.w	d7,d0	;(m1-m2*e)
	muls.w	d4,d0	;V1n*(m1-m2*e)
	divs.w	d1,d0	;V1n'=(V1n*(m1-m2*e))/(m1+m2)
	move.w	(evalue).w,d1
	muls.w	d4,d1	;V1n*e
	asr.w	#4,d1
	add.w	d0,d1	;V2n'=V1n'+V1n*e
	movem.w	d2-d3,-(sp)	;Save Dx,Dy
	muls.w	d5,d3	;V1t'*Dy
	muls.w	d0,d2	;V1n'*Dx
	add.l	d2,d3	;V1t'*Dy+V1n'*Dx
	asr.l	#4,d3
	add.w	$28(a2),d3	;Xvel
	move.w	d3,$28(a3)
	movem.w	(sp),d2-d3	;Restore Dx,Dy
	muls.w	d5,d2	;V1t'*Dx
	muls.w	d0,d3	;V1n'*Dy
	sub.l	d2,d3	;V1n'*Dy-V1t'*Dx
	asr.l	#4,d3
	add.w	$2A(a2),d3	;Yvel
	move.w	d3,$2A(a3)
	movem.w	(sp)+,d2-d3	;Pop d2 and d3 off stack
	muls.w	d1,d2	;V2n'*Dx
	asr.l	#4,d2
	add.w	d2,$28(a2)	;Xvel
	muls.w	d1,d3	;V2n'*Dy
	asr.l	#4,d3
	add.w	d3,$2A(a2)	;Yvel
	st	(collflag).w
.exit
	movem.l	(sp)+,d0-d7/a0-a3
	rts
.exit4
	addq.w	#4,sp
	bra.s	.exit
newcheck	;start a new check sound: one of 4 sounds $1C-$1F, never the last one again. Called from checkcx; FallDown branches here when the player who fell did not have the puck
	move.l	d0,-(sp)
	moveq	#3,d0
	bsr.w	randomd0
	addq.w	#1,d0	;1-3 sounds on from the last one
	add.w	(ltack).w,d0	;last tackle sound (92 ltack)
	andi.w	#3,d0
	move.w	d0,(ltack).w
	addi.w	#$1C,d0	;first check sound (92 SFXcheck = 18)
	move.w	d0,-(sp)
	bsr.w	sfx
	move.l	(sp)+,d0
	rts
checkint	;check for interference penalty. player a2 interferes with a3 or vice-versa; goalie is only player who can cause an interference call. Called from checkcx
	move.l	d0,-(sp)
	bsr.w	checkint_ci
	exg	a2,a3
	bsr.w	checkint_ci
	exg	a2,a3
	move.l	(sp)+,d0
	rts
checkint_ci	;IDA name (93 checkint .ci). a2 = goalie, a3 = player interfering with goalie. a3 falls. 94: the interference penalty ($22) needs a3
	;in the crease area (y $EF-$10A toward a2's goal, x within $14), a CPU player or a pad player's joystick player, and randomd0($28 - aggres) <=
	;4 (93: randomd0($14 - byte $73) <= 2)
	tst.w	$34(a2)	;test for goalie
	bne.w	rtss2	;exits if not goalie
	btst	#0,(gmode).w	;test gmclock(gmode). Is there play
	bne.w	rtss2	;no fall downs during celebration
	move.w	(puckc).w,d0	;Puck carrier's SCnum
	cmp.w	$52(a3),d0	;SCnum of this struct
	beq.w	.minimpact	;jump if a3 carrying puck
	cmpi.w	#$19,$32(a3)	;compare $19 to impact
	ble.w	rtss2	;exit if less than or equal
.minimpact
	cmpi.w	#2,$32(a3)	;compare 2 to impact
	ble.w	rtss2	;exit if impact is less than 2
	exg	a2,a3
	bsr.w	FallDown
	exg	a2,a3
	cmpi.w	#$1E,$32(a2)	;compare 30 decimal to impact
	ble.w	rtss2	;exit if impact is less than 30 decimal
	btst	#4,$63(a3)	;pf2pen(pflags2) - Check if player already committed a penalty
	bne.w	rtss2	;exit if player is already penalized
	tst.w	$34(a2)	;test if goalie
	bne.w	rtss2	;double check to make sure player is goalie
	move.w	#1,d0	;set d0 to team1 value
	btst	#6,$62(a3)	;check if home or away
	beq.w	.control	;jump if home (team1)
	move.w	#2,d0	;set d0 to team2 value
.control
	cmp.w	(cont1team).w,d0	;cont1team: 0= none, 1=team1, 2=team2
	beq.w	.playercont	;branch if on player 1's team
	cmp.w	(cont2team).w,d0	;check if on player 2's team
	bne.w	.checky	;branch if controlled by CPU
.playercont
	btst	#3,$62(a3)	;pfjoycon - check if player controlled
	beq.w	rtss2	;exit if not player controlled
.checky
	move.w	$14(a2),d0	;Ypos
	btst	#7,$62(a2)	;pfgoal - 0 shooting bottom, 1 shooting top
	beq.w	.checkcrease
	neg.w	d0	;negative d0 if shooting bottom
.checkcrease
	cmp.w	#$EF,d0	;compare to Ypos. Looks like it compares to both ends of crease
	blt.w	rtss2
	cmp.w	#$10A,d0
	bgt.w	rtss2
	move.w	(a2),d0	;Xpos
	cmp.w	#$14,d0	;compare Xpos to goalpost
	bgt.w	rtss2
	cmp.w	#$FFEC,d0	;compare Xpos to goalpost
	blt.w	rtss2
	move.w	#$28,d0
	sub.b	$73(a3),d0	;aggres
	bsr.w	randomd0
	cmp.w	#4,d0	;d0 = RNG(28-aggres)
	bhi.w	rtss2
	btst	#4,(gmode).w	;Check if highlight, exit if so
	bne.w	rtss2
	move.l	#$22,d0	;Interference Penalty
	bra.w	AddPenalty
checkcheck	;player is in contact: look for various contact events. Runs CCStart for a3 on a2, then for a2 on a3. d4 = impact. Called from checkcx
	movem.l	d0-d4/a0-a3,-(sp)
	bsr.w	CCStart
	exg	a2,a3
	bsr.w	CCStart
	movem.l	(sp)+,d0-d4/a0-a3
	rts
CCStart	;IDA name (93 checkcheck .cc). Player a3 is checking player a2. Holds (SPAHold, SPAhook) go to holdcheck, SPAsweepchk to Bcheck; otherwise
	;only a3 in SPAburst checks. Sets a3's check anim from checkinglist; a big enough hit on a skater makes a2 fall, with a charging ($16 / $18)
	;or roughing ($1A / $1C) roll from checkagr. 94: the hit uses wallcollduringcheck and half the Chk rating, and each penalty goes through
	;PenShotChk
	cmpi.w	#$C90,$58(a2)	;SPAHold
	beq.w	holdcheck
	cmpi.w	#$1122,$58(a2)	;SPAhook
	beq.w	holdcheck
	cmpi.w	#$B24,$58(a2)	;SPAsweepchk. B check animation
	beq.w	Bcheck
	cmpi.w	#$C5E,$58(a3)	;SPAburst
	bne.w	rtss2
	btst	#0,(gmode).w	;gmclock: increased fight chance after clock stops
	beq.w	.nofight
	move.w	#$100,$32(a3)	;impact
	move.w	#$100,$32(a2)
.nofight
	move.w	(a2),d0	;sprite to use during checking. Xpos a2
	sub.w	(a3),d0	;Xpos a3
	move.w	$14(a2),d1	;Ypos a2
	sub.w	$14(a3),d1	;Ypos a3
	bsr.w	vtoa
	sub.w	$54(a3),d0	;facedir a3
	andi.w	#7,d0
	btst	#3,4(a3)	;check attribute xflip?
	beq.w	.0
	neg.w	d0
	addq.w	#8,d0
	andi.w	#7,d0
.0
	asl.w	#1,d0	;Sets the sprite animation
	lea	checkinglist(pc),a0	;loads address of check list into a0
	move.w	0(a0,d0.w),d1	;moves check anim. value into d1, based on d0 offset
	bset	#5,$62(a3)	;pfalock - lock until animation done
	bsr.w	SetSPA
	tst.w	$34(a2)	;check if a2 is goalie
	beq.w	rtss2
	cmp.w	#$14,d4	;d4 = impact value
	blt.w	rtss2
	moveq	#$78,d0	;NHL92 uses 60 decimal, this is 120 decimal (most likely due to change in attribute math)
	btst	#3,$62(a3)	;checks if player a3 is player controlled
	beq.w	.CheckingCalc
.PlayerControlled	;IDA: PlayerControlled (no xref; a label inside CCStart). Changes d0 from 120 to 240
	;changes d0 from 120 to 240
	asl.w	#1,d0
.CheckingCalc	;IDA: CheckingCalc (a label inside CCStart)
	sub.b	$67(a3),d0	;subtract wgt of a3 player from d0. a3 is player checking.
	add.b	$67(a2),d0	;add wgt of a2 player to d0
	lsr.w	#1,d0	;shift d0 1 right word length (divide by 2)
	exg	a2,a3	;swap addresses in a2 and a3 registers
	jsr	(wallcollduringcheck).l	;94 only
	exg	a2,a3
	sub.w	$32(a2),d0	;subtract impact value of player getting checked (a2)
	beq.w	.down	;If result=0, branch
	bmi.w	.down	;If result was neg., branch
	btst	#4,$64(a3)	;wall collision bit
	bne.w	.down	;branch if bit set
	bsr.w	randomd0	;d0 is the RNG range.
	;Result will be in d0 (0 <= d0 < range)
	clr.w	(word_FFBF12).w
	move.b	$75(a3),(word_FFBF12+1).w	;$75 is Chk attrib. in player struct
	lsr.w	(word_FFBF12).w	;Shift right 1 bit
	cmp.b	(word_FFBF12+1).w,d0	;d0 - Chk rating / 2
	ble.w	.down	;branch if d0 less than FFBF13
	bsr.w	checkagr
	cmp.w	#4,d0
	bhi.w	rtss2
	btst	#4,(gmode).w	;checks if highlight
	bne.w	rtss2
	move.b	(VDP_CNTR).l,d0	;HVcount
	andi.w	#2,d0
	addi.w	#$16,d0	;#PenCharging
	jsr	(PenShotChk).l	;penalty shot on a breakaway (penalty94_1)
	bra.w	AddPenalty
.down
	bsr.w	checkagr
	cmp.w	#3,d0
	bhi.w	.dn2
	btst	#4,(gmode).w	;checks if highlight
	bne.w	.dn2
	move.b	(VDP_CNTR).l,d0	;HVcount
	andi.w	#2,d0
	addi.w	#$1A,d0	;#PenRoughing2
	jsr	(PenShotChk).l	;penalty shot on a breakaway (penalty94_1)
	bsr.w	AddPenalty
.dn2
	bra.w	FallDown
checkinglist	;IDA name (93 checkcheck .list). Check anim by direction from a3 to a2, SPA offsets
	dc.w	$B96	;SPAshoulderchkl
	dc.w	$BC8	;SPAshoulderchkr
	dc.w	$C2C	;SPAhipchkr
	dc.w	$C2C	;SPAhipchkr
	dc.w	$C2C	;SPAhipchkr
	dc.w	$BFA	;SPAhipchkl
	dc.w	$BFA	;SPAhipchkl
	dc.w	$B96	;SPAshoulderchkl
checkagr	;use Agression attribute and RNG to determine if there will be a penalty. a3 = checking player, a2 = player being checked. d0 =
	;randomd0(((40 - Agr) / 2) * 13), doubled for a joystick player, halved within $28 of the puck in x and y. 94 then: a2 on a breakaway rolls
	;randomd0 again, of 8 / 7 / 4 / 3 by a2's distance in y from the goal line; and d0 = $7F (no penalty) while the other team has a delayed
	;penalty (DelayedPen). The callers call a penalty when d0 is small. Called from CCStart, holdcheck and Bcheck
	move.w	#$28,d0	;Start calculation with 40 decimal (28 hex)
	sub.b	$73(a3),d0	;Agr(a3) - subtract Agr from d0
	lsr.b	#1,d0	;divide result by 2
	mulu.w	#$D,d0	;multiply d0 with 13 decimal
	btst	#3,$62(a3)	;test if player controlled
	beq.w	.checkpos	;branch if CPU player
	asl.w	#1,d0	;multiply by 2
.checkpos
	move.w	(a3),d1	;XPos
	sub.w	(puckx).w,d1	;subtract x pos of puck with X pos of player
	cmp.w	#$28,d1	;Checking position with respect to puck
	bgt.w	.random	;if d1 is greater than 28 hex (40 dec), jump
	cmp.w	#$FFD8,d1	;checking the inverse position (other side of rink)
	blt.w	.random
	move.w	$14(a3),d1	;Ypos
	sub.w	(pucky).w,d1
	cmp.w	#$28,d1	;same as above
	bgt.w	.random
	cmp.w	#$FFD8,d1	;checking the inverse position (other side of rink)
	blt.w	.random
	asr.w	#1,d0	;divide by 2
.random
	bsr.w	randomd0
	btst	#1,$64(a2)	;Check for player on breakaway
	beq.w	.teamchk	;branch if bit is 0
	move.w	$14(a2),d1	;Ypos of player being checked
	bpl.w	.calc	;will jump if Ypos is positive
	neg.w	d1	;flip result (other side of rink)
.calc
	subi.w	#$108,d1	;subtract from Ypos
	neg.w	d1	;flip Y pos
	move.w	#8,d0	;move 8 into d0. Removes any trace of Agr here
	cmp.w	#$75,d1	;compares Ypos calc to 75 hex
	bgt.w	.rand2	;branch if higher than 75 hex
	move.w	#7,d0	;move 7 into d0
	cmp.w	#$3A,d1	;compare 3A hex to Ypos calc
	bgt.w	.rand2	;jump if higher than 3A hex
	move.w	#4,d0	;moves 4 into d0
	cmp.w	#$2C,d1	;compares 2C hex to Ypos calc
	bgt.w	.rand2	;jump if higher than 2C hex
	move.w	#3,d0	;finally, just move 3 in d0
.rand2
	bsr.w	randomd0
.teamchk
	btst	#6,$62(a3)	;checks if home or away team
	bne.w	.away
	btst	#2,(DelayedPen).w	;visitors have a delayed penalty
	bne.w	.nopen
	bra.w	.end
.away
	btst	#1,(DelayedPen).w	;home team has a delayed penalty
	beq.w	.end
.nopen
	move.w	#$7F,d0
.end
	rts
holdcheck	;player a2 is in hold animation looking to hold opponent a3. Entered from CCStart for SPAHold or SPAhook. a3 must be within 1
	;direction of where a2 faces. a3 flails, a2 goes to SPAHold2 (or SPAhook2), and checkagr rolls penalty $24 after SPAHold2 or $1E after
	;SPAhook2 (94: through PenShotChk)
	btst	#5,$62(a3)	;#pfalock - locked animation
	bne.w	rtss2
	tst.w	$34(a3)	;position - no hold on goalies
	beq.w	rtss2
	btst	#0,$63(a3)	;#pf2fight - no hold on fighters
	bne.w	rtss2
	move.w	(a3),d0	;Xpos a3
	sub.w	(a2),d0	;Xpos a2
	move.w	$14(a3),d1	;Ypos a3
	sub.w	$14(a2),d1	;Ypos a2
	bsr.w	vtoa
	sub.w	$54(a2),d0	;facedir(a2)
	addq.w	#1,d0
	andi.w	#7,d0
	cmp.w	#2,d0
	bhi.w	rtss2
	move.w	(puckc).w,d0
	cmp.w	$52(a3),d0
	bne.w	.holdcheck
	bclr	#3,(sflags).w	;a3 has the puck (93 sfssdir)
.holdcheck
	move.w	$28(a3),d0	;Xvel(a3)
	add.w	$28(a2),d0	;Xvel(a2)
	asr.w	#1,d0
	move.w	d0,$28(a3)
	move.w	d0,$28(a2)
	move.w	$2A(a3),d0	;Yvel(a3)
	add.w	$2A(a2),d0	;Yvel(a2)
	asr.w	#1,d0
	move.w	d0,$2A(a3)
	move.w	d0,$2A(a2)
	bset	#5,$62(a3)	;pfalock
	move.w	#$CF4,d1	;SPAflail
	bsr.w	SetSPA
	exg	a2,a3
	bset	#5,$62(a3)	;pfalock
	move.w	#$CC2,d1	;SPAHold2
	cmpi.w	#$C90,$58(a3)	;SPAHold
	beq.w	.setanimation
	move.w	#$1154,d1	;SPAhook2
.setanimation
	bsr.w	SetSPA
	bsr.w	checkagr
	cmp.w	#6,d0
	bhi.w	.ex
	btst	#4,(gmode).w	;check for highlight
	bne.w	.ex
	move.w	#$24,d0	;penalty $24 after SPAHold2 (IDA comment: PenHooking?)
	cmpi.w	#$CC2,$58(a3)	;SPAHold2
	beq.w	.addpen
	move.w	#$1E,d0	;penalty $1E after SPAhook2 (IDA comment: PenHolding)
.addpen
	jsr	(PenShotChk).l
	bsr.w	AddPenalty
.ex
	exg	a2,a3
	st	(collflag).w
	rts
Bcheck	;a2 = player that is B checking (SPAsweepchk), a3 = player being checked. Entered from CCStart. If OptPen is 0 and a2 is joystick controlled,
	;a2 needs randomd0($20 + a2 Chk - a3 Agl, 2 less when byte_FFC2FE bit 1 or byte_FFC2FC bit 6 is set) >= $18 (93: $10 + Chk - legstr, >= $C).
	;If a3 is within 1 direction of where a2 faces, a3 falls and checkagr may call penalty $20 (tripping) on a2. Sets collflag
	btst	#5,$62(a3)	;check if locked in animation
	bne.w	rtss2	;exit if locked
	tst.w	$34(a3)	;check if goalie
	beq.w	rtss2	;exit if goalie
	btst	#0,$63(a3)	;is player fighting?
	bne.w	rtss2	;exit if fighting
	tst.w	(OptPen).w	;check for penalties
	bne.w	.checkdir	;Branch if penalties
	btst	#3,$62(a2)	;check if player controlled
	beq.w	.checkdir	;branch if not
	move.w	#$20,d0	;20 hex starting value
	add.b	$75(a2),d0	;add Chk of player B checking
	sub.b	$68(a3),d0	;sub Agl of player being checked
	btst	#1,(byte_FFC2FE).w	;94 only
	bne.w	.sub2
	btst	#6,(byte_FFC2FC).w
	beq.w	.rnd
.sub2
	subq.b	#2,d0	;sub 2 from d0
.rnd
	bsr.w	randomd0
	cmp.w	#$18,d0
	blt.w	rtss2	;if less than, unsuccessful B check
.checkdir
	move.w	(a3),d0	;Xpos a3
	sub.w	(a2),d0	;sub Xpos a2 from Xpos a3
	move.w	$14(a3),d1	;Ypos a3
	sub.w	$14(a2),d1	;sub Ypos a2 from Ypos a3
	bsr.w	vtoa
	sub.w	$54(a2),d0	;sub facedir from d0
	addq.w	#1,d0
	andi.w	#7,d0	;pass first 3 bits of d0
	cmp.w	#2,d0
	bhi.w	rtss2	;exit if higher than 2
	exg	a2,a3
	bsr.w	FallDown
	bsr.w	checkagr
	cmp.w	#4,d0
	bhi.w	.exit
	move.w	#$20,d0	;Tripping
	jsr	(PenShotChk).l
	bsr.w	AddPenalty
.exit
	exg	a2,a3
	st	(collflag).w
	rts
FallDown	;player a2 falls down, player a3 is the hitting player. Skips a2 in some anims, or the same pair as the last call. A skater hitter
	;adds check stats (team $10, player $11C, ChkCnt). 94: a hit into the wall picks a fall anim from .FallList by where a2 is (the SPA_17E8 /
	;SPA_18CC falls near center ice (|Ypos| up to $59 / $38) become SPA_193E / SPA_1A00), a strong Stk player may just stumble, and an injury
	;(setInjuryType) adds penalty $12 (or $14) and stops play. Then the crowd and a check sound (newcheck). Called from checkint_ci, CCStart and
	;Bcheck
	cmpi.w	#$B,$52(a2)	;0-11 are player structs
	bgt.w	rtss2	;exit if not a player struct
	cmpi.w	#$145C,$58(a2)	;SPA_145C. checks various animations and exits if one of them
	beq.w	rtss2
	cmpi.w	#$1AF4,$58(a2)	;SPAinjury1
	beq.w	rtss2
	cmpi.w	#$11E6,$58(a2)	;SPAstumble
	beq.w	rtss2
	cmpi.w	#$D26,$58(a2)	;SPAfallfwd
	beq.w	rtss2
	cmpi.w	#$DD8,$58(a2)	;SPAfallback
	beq.w	rtss2
	cmpi.w	#$136A,$58(a2)	;SPAflip
	beq.w	rtss2
	cmpa.l	(PlayerChked).w,a2	;compared to previous player checked
	bne.w	.cont	;branch if not the same
	cmpa.l	(PlayerChking).w,a3	;compares a3 to previous player checking
	bne.w	.cont	;branch if not the same
	rts	;exit if both players are the same as last Fall Down attempt
.cont
	move.l	a2,(PlayerChked).w	;player checked
	move.l	a3,(PlayerChking).w	;player checking
	btst	#3,$64(a2)	;is player a2 doing a one-timer
	bne.w	rtss2	;exit if yes
	btst	#3,$64(a3)	;Is player a3 doing a one-timer
	bne.w	rtss2	;exit if yes
	move.w	#$11E6,d1	;SPAstumble. toddle animation?
	btst	#4,$64(a3)	;wall collision bit
	bne.w	.cont2	;jump if hitting wall
.CmpPlayerStk	;IDA: CmpPlayerStk (no xref; a label inside FallDown). a2's Stk value. Compares to $18 (24 decimal)
	;a2's Stk value. Compares to 18 (24 decimal)
	cmpi.b	#$18,$71(a2)	;Start of toddle check
	blt.w	.cont2	;jump if less than
	tst.b	$5F(a2)	;check if puck collision possible
	bne.w	.cont2	;jump if not
	move.w	(VDP_CNTR).l,d0	;frame counter
	andi.w	#$F,d0	;pass 1st byte of d0
	addi.w	#$10,d0	;add 10 hex to d0
	cmp.w	$32(a2),d0	;compare impact value to d0.
	;d0 will be 10-1F hex (16-31 decimal)
	ble.w	.cont2	;no toddle if d0 <= impact
	move.b	#$3C,$5F(a2)	;move 3C (60 decimal) into nopuck
	bra.w	.2
.cont2
	tst.w	$34(a3)	;check for goalie
	beq.w	.chkpos	;jump if goalie
	movea.w	#(HmShots-M68K_RAM),a0	;Start of Home Team Stats Struct
	btst	#6,$62(a3)
	beq.w	.AddChktoPlayerStats
	adda.w	#$364,a0	;Change to Away Team Stats
.AddChktoPlayerStats	;IDA: AddChktoPlayerStats (a label inside FallDown)
	addq.w	#1,$10(a0)	;Add 1 Chk to Team Total
	clr.w	d0
	move.b	$66(a3),d0	;Index of Player
	adda.w	d0,a0
	addq.b	#1,$11C(a0)	;Add 1 Chk to Player Stats
	addq.w	#1,(ChkCnt).w	;Add 1 to ChkCnt
	tst.b	$74(a3)	;checks fight attribute?
	bne.w	.chkpos	;jump if fight attribute not 0
	addq.w	#2,(ChkCnt).w	;add 2 to ChkCnt
.chkpos
	move.b	#$78,$5E(a2)
	move.w	(a3),d0	;Xpos
	sub.w	(a2),d0	;sub Xpos
	move.w	$14(a3),d1	;Ypos
	sub.w	$14(a2),d1	;sub Ypos
	bsr.w	vtoa
	tst.w	$34(a2)	;check if goalie a2
	beq.w	.14378	;branch if goalie
	jsr	(wallcollduringcheck).l	;check for wall collision
	btst	#4,$64(a2)	;check wall collision bit
	beq.w	.14378	;jump if not collision
	movem.l	d1-d4,-(sp)
	move.w	$28(a2),d1	;move Xvel into d1
	bpl.w	.yvel	;branch if positive
	neg.w	d1	;negate d1
.yvel
	move.w	$2A(a2),d2	;move Yvel into d2
	bpl.w	.chkpos2	;branch if positive
	neg.w	d2	;negate d2
.chkpos2
	move.w	(a2),d3	;Xpos of player into d3
	sub.w	(a3),d3	;sub Xpos of checker
	move.w	$14(a2),d4	;Ypos of player into d4
	sub.w	$14(a3),d4	;sub Ypos of checker
	cmpi.w	#$108,$14(a3)	;compare Ypos of a3 to top goal line
	bgt.w	.bnet1	;branch if behind net
	cmpi.w	#$FEF8,$14(a3)	;compare to bottom goal line Y
	blt.w	.bnet2	;branch if behind net
	tst.w	(a3)	;In between goal lines
	;Check Xpos of checker
	bpl.w	.posx	;branch if positive (right side of center)
	tst.w	d3	;check diff of Xpos
	bpl.w	.chktowardcenterice	;branch if positive (player to right of checker)
	cmp.w	#$FFFD,d3	;comp diff of Xpos with -3
	bgt.w	.chktowardcenterice	;branch if greater than
	bra.w	.chkawayfromcenterice	;player to left of checker
.posx
	tst.w	d3	;check diff of Xpos
	bmi.w	.chktowardcenterice	;branch if negative (player to left of checker)
	cmp.w	#3,d3	;comp diff of Xpos with 3
	blt.w	.chktowardcenterice	;branch if less than
	bra.w	.chkawayfromcenterice	;player to right of checker
.bnet2
	tst.w	d4	;check diff of Ypos
	bpl.w	.chktowardcenterice	;branch if positive
	;player higher than checker
	bra.w	.chkawayfromcenterice	;player lower than checker
.bnet1
	tst.w	d4	;check diff of Ypos
	bmi.w	.chktowardcenterice	;branch if negative
	;player lower than checker
	bra.w	.chkawayfromcenterice	;player higher than checker
.chktowardcenterice
	movem.l	(sp)+,d1-d4
	bra.w	.14378
.chkawayfromcenterice
	movem.l	(sp)+,d1-d4	;pop from stack
	bra.w	*+4	;to the next instruction (.playerpos)
.playerpos
	cmpi.w	#$10C,$14(a2)	;Ypos player
	;check if player is above top goal line
	bgt.w	.chkawayfrommiddle	;branch if above
	cmpi.w	#$FEF4,$14(a2)	;Check if player is below bottom goal line
	blt.w	.chkawayfrommiddle	;branch if below
	cmpi.w	#$68,(a2)	;Xpos player
	;check if right of crease?
	bgt.w	.chkawayfrommiddle	;branch if to the right
	cmpi.w	#$FF98,(a2)	;check if left of crease?
	blt.w	.chkawayfrommiddle	;branch if to the left
	bra.w	.14378	;right of crease
.chkawayfrommiddle
	cmpi.w	#$B,$52(a3)	;check if SCNum is a player
	bgt.w	.14264	;branch if not player
	addi.w	#$A,(CwdExciteLvl).w
	addi.w	#$96,(crowdlevel).w
	move.w	d1,-(sp)	;push to stack
	move.b	#0,$40(a3)	;clear temp1
	move.b	#0,$65(a3)	;clear glitch
	move.w	#$1AC2,d1	;SPA_1AC2
	jsr	(SetSPA).l	;set animation
	clr.w	$28(a3)	;clear Xvel
	clr.w	$2A(a3)	;clear Yvel
	move.w	(sp)+,d1	;pop from stack
.14264
	movem.l	d0/a0,-(sp)	;push to stack
	cmpi.w	#$10C,$14(a2)	;check player Ypos with top goal line
	bgt.w	.playerabovetopgoalline	;branch if above
	cmpi.w	#$FEF4,$14(a2)	;check player Ypos with bottom goal line
	blt.w	.playerbelowbottomgoalline	;branch if below
	tst.w	(a2)	;test player Xpos
	bmi.w	.playerleftofcenter	;branch if negative
	move.w	#2,d0	;player right of center
	bra.w	.getchkanim
.playerleftofcenter
	move.w	#6,d0
	bra.w	.getchkanim
.playerabovetopgoalline
	move.w	#0,d0
	bra.w	.getchkanim
.playerbelowbottomgoalline
	move.w	#4,d0
.getchkanim
	add.w	d0,d0
	movea.l	#.FallList,a0
	move.w	0(a0,d0.w),d1	;move animation from list into d1
	move.w	$14(a2),(FallYPos).w
	move.w	(a2),(FallXPos).w
	cmp.w	#$18CC,d1	;SPA_18CC. player left of center
	bne.w	.142F4	;branch if not
	cmpi.w	#$59,$14(a2)	;compare $59 to Ypos
	bgt.w	.142F4	;branch if higher
	cmpi.w	#$FFA7,$14(a2)	;compare -$59 to Ypos
	blt.w	.142F4	;branch if lower
	move.w	d0,-(sp)
	move.w	#7,d0
	jsr	(sub_FE510).l	;94 only
	move.w	(sp)+,d0
	move.w	#$193E,d1	;SPA_193E. anim value
	btst	#3,4(a2)
	beq.w	.1434C
	move.w	#$1A00,d1	;SPA_1A00
	bra.w	.1434C
.142F4
	cmp.w	#$17E8,d1	;SPA_17E8. player right of center
	bne.w	.14326	;branch if not
	cmpi.w	#$38,$14(a2)	;compare $38 to Ypos
	bgt.w	.14326	;branch if higher
	cmpi.w	#$FFC8,$14(a2)	;compare -38 to Ypos
	blt.w	.14326	;branch if lower
	move.w	#$1A00,d1	;SPA_1A00. change anim value
	btst	#3,4(a2)	;check bit 3 of frame
	beq.w	.1434C	;branch if zero
	move.w	#$193E,d1	;SPA_193E. change anim value
	bra.w	.1434C
.14326
	btst	#3,4(a2)	;check bit 3 of frame
	beq.w	.1434C	;branch if zero
	cmp.w	#$17E8,d1	;SPA_17E8. right of center
	beq.w	.14348	;branch if right of center
	cmp.w	#$18CC,d1	;SPA_18CC. left of center
	bne.w	.1434C	;branch if not left of center
	move.w	#$17E8,d1	;SPA_17E8. change anim to same as right of center
	bra.w	.1434C
.14348
	move.w	#$18CC,d1	;SPA_18CC. change anim
.1434C
	clr.w	$28(a2)	;clear Xvel
	clr.w	$2A(a2)	;clear Yvel
	bset	#5,$64(a2)	;set falldown bit
	bset	#0,$62(a2)	;set pfdoff (deceleration)
	movem.l	(sp)+,d0/a0	;pop from stack
	bra.w	.14392
.FallList	;IDA: FallList (a table inside FallDown). Fall anim by where a2 is: above, right, below, left (2 words each)
	dc.w	$1776	;SPA_1776
	dc.w	$1776	;SPA_1776
	dc.w	$17E8	;SPA_17E8
	dc.w	$17E8	;SPA_17E8
	dc.w	$185A	;SPA_185A
	dc.w	$185A	;SPA_185A
	dc.w	$18CC	;SPA_18CC
	dc.w	$18CC	;SPA_18CC
.14378
	move.w	#$DD8,d1	;SPAfallback
	sub.w	$54(a2),d0	;facedir
	addq.w	#1,d0
	andi.w	#7,d0
	cmp.w	#2,d0
	bls.w	.2
	move.w	#$D26,d1	;SPAfallfwd
.14392
	move.w	$54(a2),d0	;facedir
	andi.w	#3,d0
	bne.w	.2	;branch if first 2 bits of d0 arent zero
	cmpi.b	#$14,$75(a3)	;compare $14 to checker Chk attribute
	blt.w	.2	;branch if less than
	cmpi.w	#$B,$52(a3)	;check if SCNum of checker is a player
	bgt.w	.2	;branch if not
	btst	#5,$64(a2)	;check if falldown bit is set for player
	bne.w	.2	;branch if set
	move.w	#$136A,d1	;SPAflip. move anim into d1
.2
	exg	a2,a3	;swap a2 and a3
	bset	#5,$62(a3)	;set animation lock
	bsr.w	SetSPA	;set animation with d1 value
	exg	a2,a3	;swap back a2 and a3
	tst.w	$34(a3)	;check if checking player is goalie
	beq.w	.21	;jump if goalie
	tst.w	$34(a2)	;check if player checked is goalie
	beq.w	.21	;jump if goalie
	addi.w	#$12C,(crowdlevel).w	;add to crowd level
	addi.w	#$F,(CwdExciteLvl).w	;add to crowd excite level
.21
	move.w	(puckc).w,d0	;move puck carrier SCNum into d0
	bmi.w	newcheck	;make check sound
	cmp.w	$52(a2),d0	;check if puck carrier is a2
	bne.w	newcheck
	st	(puckc).w	;clear out puck carrier
	btst	#4,(gmode).w	;check if highlight
	bne.w	.22	;jump if highlight
	cmpi.w	#$DD8,$58(a2)	;SPAfallback. check animation (player who is checked)
	bne.w	.22	;jump if not equal
	move.w	$54(a2),d0	;facedir into d0
	andi.w	#3,d0	;pass first 2 bits of d0
	bne.w	.22
	btst	#4,$63(a2)	;check if player is unavailable
	bne.w	.22	;jump if unavailable
	move.l	#$A0,d0
	bsr.w	randomd0
	cmp.w	$32(a2),d0	;compare impact to d0
	bgt.w	.22	;jump if d0 higher than impact
	btst	#0,(gmode).w	;check if clock running
	bne.w	.22	;jump if not
	exg	a2,a3
	move.w	#$145C,d1	;SPA_145C. set injury animation
	bsr.w	SetSPA
	exg	a2,a3
	bsr.w	setInjuryType
	btst	#5,(byte_FFC2FC).w	;check if game injury
	bne.w	.1446A	;branch if game injury
	exg	a2,a3
	move.w	#$1AF4,d1	;SPAinjury1. set injury animation
	bsr.w	SetSPA
	exg	a2,a3
.1446A
	move.w	#4,(InjCntDown).w
	move.l	#$14,d0	;move 14 into d0 - Pen ???
	tst.w	$34(a3)	;check if a3 goalie
	beq.w	AddPenalty2	;jump if goalie
	tst.w	(OptPen).w	;check penalties
	beq.w	AddPenalty2	;jump if off
	move.l	#$12,d0	;Pen Roughing
	bsr.w	AddPenalty2
	bra.w	Stop4Pen
.22
	move.w	#$B,-(sp)	;#SFXcrowdcheer
	btst	#6,$62(a2)	;check team
	bne.w	.3	;jump if away team
	move.w	#$C,(sp)	;#SFXcrowdboo
.3
	bsr.w	song
	rts
setInjuryType	;determines if injury will be for period or game. a2 = player injured, a3 = player checking. Marks a2 unavailable, pumps up the crowd,
	;plays sfx $D, locks the scroll on a2 and sets TempPlOffset (pnum, bit 15 set for the away team). a2's tmpdst becomes $FFFD (injured for the
	;period) or, from a3's Fgt byte (getFgtbyte, chkFgtBit1), $FFFC (injured for the game, byte_FFC2FC bit 5). Called from FallDown
	move.w	d0,-(sp)
	bset	#2,$63(a2)	;set player unavailable
	addi.w	#$12C,(crowdlevel).w
	addi.w	#$1E,(CwdExciteLvl).w
	move.w	#$D,-(sp)	;sound effect
	bsr.w	sfx
	move.w	(a2),(xc1).w	;move Xpos to scroll center
	move.w	$14(a2),(yc1).w	;move Ypos to scroll center
	bset	#6,(sflags).w	;set sfslock (scroll lock)
	clr.w	d1	;clear d1
	movea.w	#(HmShots-M68K_RAM),a0	;move Home team Struct to a0
	btst	#6,$62(a2)	;check if player home or away
	beq.w	.0	;branch if home
	move.w	#$8000,d1	;move $8000 into d1
	adda.w	#$364,a0	;add $364 to a0 (Away Team Struct start)
.0
	move.b	$66(a2),d1	;move roster offset into d1
	move.w	d1,(TempPlOffset).w
	ext.w	d1	;sign extend - in this case just makes upper bye of word 00
	add.w	d1,d1	;add d1 to itself
	exg	a2,a3	;swap a2 and a3
	jsr	(getFgtbyte).l	;get the Fgt byte (divided by 4)
	exg	a2,a3	;swap back
	tst.w	d0	;check if d0 is zero
	bne.w	.not0	;branch if H/F was more than 3
	bclr	#5,(byte_FFC2FC).w	;clear injury game bit
	move.w	#$FFFD,$66(a0,d1.w)	;update status of player
	bra.w	.exit
.not0
	cmp.w	#3,d0	;compare d0 to 3 (if H/F was 12, d0 = 3)
	beq.w	.injurygame
	bclr	#5,(byte_FFC2FC).w
	move.w	#$FFFD,$66(a0,d1.w)	;update status of player
	jsr	(chkFgtBit1).l	;check Fgt bit 1 of player.
	beq.w	.exit	;jump if Fgt not 2,6,A
.injurygame
	bset	#5,(byte_FFC2FC).w	;set injury game bit
	move.w	#$FFFC,$66(a0,d1.w)	;update status of player
.exit
	move.w	(sp)+,d0
	rts
