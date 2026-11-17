	include	segacd\hockey.inc
	include	macros\genesis.mac

AddPenalty	equ	$3941A
Crowdlevel	equ	$17CD2
CwdExciteLvl	equ	$17CD8
LOAD	equ	$1B000
OptPen	equ	$18C08
PenShotChk	equ	$3964C
SortCords	equ	$17480
TempPlOffset	equ	$180EE
TempWord1	equ	$17E62
cont1team	equ	$17FA6
cont2team	equ	$17FA8
ltack	equ	$17F62
move	equ	$2C9C8
puckx	equ	$17B80
pucky	equ	$17B94
randomd0	equ	$37050
sfx	equ	$3710C
tmstruct	equ	$1834C
vtoa	equ	$362F8
X_1B3C0	equ	$1B3C0
X_1F55C	equ	$1F55C
X_1F75C	equ	$1F75C
X_1F822	equ	$1F822
X_1F90A	equ	$1F90A
X_1F9BE	equ	$1F9BE
X_1FAC0	equ	$1FAC0
X_1FF3E	equ	$1FF3E
X_21000	equ	$21000

	org	$1F212

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
.0	cmpi.w	#$F,d1		;#sortobjs-1
	beq.w	.cl		;it is top sprite on screen
	clr.w	d4
	move.b	$1(a1,d1.w),d4		;next higher object number
	move.w	(a2,d4.w),d5		;y pos of next higher object
	sub.w	d3,d5
	cmpi.w	#$10,d5
	bgt.w	.cl		;no higher sprite coll
	bsr.w	checkcx
	addq.w	#$1,d1
	bra.w	.0
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
	asl.w	#$6,d4		;6 = scsize-1
	movea.l	#SortCords,a2		;start of the player sort objects
	adda.w	d4,a2		;add d4 to a2. a2 now address of SCStruct-1
	btst	#$2,$62(a2)		;test pfnc pflags = no collision mode
	bne.w	.exit		;object has no collision mode on
	btst	#$5,$63(a2)		;pf2npc(pflags2) = another no collision mode
	bne.w	.exit		;exit if no collision mode on
	cmpi.w	#$B,$52(a2)		;comparing 11 with SCnum for player. Player SCnum are 0-11.
	bgt.w	.exit
	move.w	$0(a2),d0		;Xpos
	btst	#$7,$17F6A.l		;sfhor(sflags) = screen in horizontal mode
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
	bne.w	.if2
	move.w	$52(a2),$2E(a3)		;SCnum(a2), impactp(a3) = moves a2 SCnum into past impact player for a3
.if2	cmpi.w	#$14,d4		;impact under 20: no check sound
	blt.w	.n1
	move.w	$17BE0.l,d0		;check sound only if one of them has the puck
	cmp.w	$52(a3),d0
	beq.w	.nc
	cmp.w	$52(a2),d0
	bne.w	.n1
.nc	bsr.w	newcheck
.n1	bsr.w	checkint		;interference, check and fight tests
	bsr.w	X_1F55C
	bsr.w	X_1FF3E
.not	move.w	d1,d4
	movem.w	(sp)+,d0-d1
	tst.w	$17EEE.l		;set to -1 by holdcheck / Bcheck: no transfer
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
.exit	movem.l	(sp)+,d0-d7/a0-a3
	rts
.exit4	addq.w	#$4,sp
	bra.w	.exit
newcheck						;start a new check sound: one of 4 sounds $1C-$1F, never the last one
									;again. Called from checkcx; FallDown branches here when the player who
									;fell did not have the puck
	move.l	d0,-(sp)
	moveq	#$3,d0
	bsr.w	randomd0-LOAD
	addq.w	#$1,d0		;1-3 sounds on from the last one
	add.w	(ltack).l,d0
	andi.w	#$3,d0
	move.w	d0,(ltack).l
	addi.w	#$1C,d0		;first check sound (92 used 18)
	move.w	d0,-(sp)
	bsr.w	sfx-LOAD
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
	bne.w	X_21000		;exits if not goalie
	btst	#$0,$17F68.l		;test gmclock(gmode). Is there play
	bne.w	X_21000		;no fall downs during celebration
	move.w	$17BE0.l,d0		;Puck carrier's SCnum
	cmp.w	$52(a3),d0		;SCnum of this struct
	beq.w	.minimpact		;jump if a3 carrying puck
	cmpi.w	#$19,$32(a3)		;compare $19 to impact
	ble.w	X_21000		;exit if less than or equal
.minimpact	cmpi.w	#$2,$32(a3)		;compare 2 to impact
	ble.w	X_21000		;exit if impact is less than 2
	exg.l	a2,a3
	bsr.w	X_1F9BE
	exg.l	a2,a3
	cmpi.w	#$1E,$32(a2)		;compare 30 decimal to impact
	ble.w	X_21000		;exit if impact is less than 30 decimal
	btst	#$4,$63(a3)		;pf2pen(pflags2) - Check if player already committed a penalty
	bne.w	X_21000		;exit if player is already penalized
	tst.w	$34(a2)
	bne.w	X_21000		;double check to make sure player is goalie
	move.w	#$1,d0		;set d0 to team1 value
	btst	#$6,$62(a3)		;check if home or away
	beq.w	.control		;jump if home (team1)
	move.w	#$2,d0		;set d0 to team2 value
.control	cmp.w	(cont1team).l,d0		;cont1team: 0= none, 1=team1, 2=team2
	beq.w	.playercont		;branch if on player 1's team
	cmp.w	(cont2team).l,d0		;check if on player 2's team
	bne.w	.checky		;branch if controlled by CPU
.playercont	btst	#$3,$62(a3)		;pfjoycon - check if player controlled
	beq.w	X_21000		;exit if not player controlled
.checky	move.w	$14(a2),d0
	btst	#$7,$62(a2)		;pfgoal - 0 shooting bottom, 1 shooting top
	beq.w	.checkcrease
	neg.w	d0		;negative d0 if shooting bottom
.checkcrease	cmpi.w	#$EF,d0		;compare to Ypos. Looks like it compares to both ends of crease
	blt.w	X_21000
	cmpi.w	#$10A,d0
	bgt.w	X_21000
	move.w	$0(a2),d0		;Xpos
	cmpi.w	#$14,d0		;compare Xpos to goalpost
	bgt.w	X_21000
	cmpi.w	#$FFEC,d0		;compare Xpos to goalpost
	blt.w	X_21000
	move.w	#$28,d0
	sub.b	$73(a3),d0
	bsr.w	randomd0-LOAD
	cmpi.w	#$4,d0		;d0 = RNG(28-aggres)
	bhi.w	X_21000
	btst	#$4,$17F68.l		;Check if highlight, exit if so
	bne.w	X_21000
	moveq	#$22,d0
	bra.w	AddPenalty-LOAD
	movem.l	d0-d4/a0-a3,-(sp)
	bsr.w	.l1F570
	exg.l	a2,a3
	bsr.w	.l1F570
	movem.l	(sp)+,d0-d4/a0-a3
	rts
.l1F570	cmpi.w	#$C90,$58(a2)
	beq.w	X_1F822
	cmpi.w	#$1122,$58(a2)
	beq.w	X_1F822
	cmpi.w	#$B24,$58(a2)
	beq.w	X_1F90A
	cmpi.w	#$C5E,$58(a3)
	bne.w	X_21000
	btst	#$0,$17F68.l
	beq.w	.l1F5B0
	move.w	#$100,$32(a3)
	move.w	#$100,$32(a2)
.l1F5B0	move.w	$0(a2),d0
	sub.w	$0(a3),d0
	move.w	$14(a2),d1
	sub.w	$14(a3),d1
	bsr.w	vtoa-LOAD
	sub.w	$54(a3),d0
	andi.w	#$7,d0
	btst	#$3,$4(a3)
	beq.w	.l1F5E0
	neg.w	d0
	addi.w	#$8,d0
	andi.w	#$7,d0
.l1F5E0	asl.w	#$1,d0
	dc.w	$41FA,$0168
	move.w	(a0,d0.w),d1
	bset	#$5,$62(a3)
	bsr.w	X_1B3C0
	tst.w	$34(a2)
	beq.w	X_21000
	cmpi.w	#$14,d4
	blt.w	X_21000
	moveq	#$78,d0
	btst	#$3,$62(a3)
	beq.w	.l1F612
	asl.w	#$1,d0
.l1F612	sub.b	$67(a3),d0
	add.b	$67(a2),d0
	lsr.w	#$1,d0
	exg.l	a2,a3
	jsr	$24FB4.l
	exg.l	a2,a3
	sub.w	$32(a2),d0
	beq.w	.l1F6D4
	bmi.w	.l1F6D4
	btst	#$4,$64(a3)
	bne.w	.l1F6D4
	bsr.w	randomd0-LOAD
	clr.w	(TempWord1).l
	move.b	$75(a3),$17E63.l
	lsr.w	(TempWord1).l
	cmp.b	$17E63.l,d0
	ble.w	.l1F6D4
	bsr.w	X_1F75C
	cmpi.w	#$4,d0
	bhi.w	X_21000
	btst	#$4,$17F68.l
	bne.w	X_21000
.l1F676	btst	#$7,$FF800E.l
	bne.b	.l1F676
	move.w	#$1C,$FF8020.l
	bset	#$6,$FF800F.l
.l1F690	btst	#$6,$FF800E.l
	beq.b	.l1F690
	move.b	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l1F6B0	btst	#$6,$FF800E.l
	bne.b	.l1F6B0
	bclr	#$7,$FF800F.l
	andi.w	#$2,d0
	addi.w	#$16,d0
	jsr	(PenShotChk).l
	bra.w	AddPenalty-LOAD
.l1F6D4	bsr.w	X_1F75C
	cmpi.w	#$3,d0
	bhi.w	.l1F748
	btst	#$4,$17F68.l
	bne.w	.l1F748
.l1F6EC	btst	#$7,$FF800E.l
	bne.b	.l1F6EC
	move.w	#$1C,$FF8020.l
	bset	#$6,$FF800F.l
.l1F706	btst	#$6,$FF800E.l
	beq.b	.l1F706
	move.b	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l1F726	btst	#$6,$FF800E.l
	bne.b	.l1F726
	bclr	#$7,$FF800F.l
	andi.w	#$2,d0
	addi.w	#$1A,d0
	bsr.w	PenShotChk-LOAD
	bsr.w	AddPenalty-LOAD
.l1F748	bra.w	X_1F9BE
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
	dc.w	$0C2C,$0C2C,$0BFA
	dc.w	$0BFA
	bclr	d5,(a6)
.l1F75C	move.w	#$28,d0		;Start calculation with 40 decimal (28 hex)
	sub.b	$73(a3),d0		;Agr(a3) - subtract Agr from d0
	lsr.b	#$1,d0		;divide result by 2
	mulu.w	#$D,d0		;multiply d0 with 13 decimal
	btst	#$3,$62(a3)		;test if player controlled
	beq.w	.checkpos		;branch if CPU player
	asl.w	#$1,d0
.checkpos	move.w	$0(a3),d1
	sub.w	(puckx).l,d1		;subtract x pos of puck with X pos of player
	cmpi.w	#$28,d1		;Checking position with respect to puck
	bgt.w	.random		;if d1 is greater than 28 hex (40 dec), jump
	cmpi.w	#$FFD8,d1		;checking the inverse position (other side of rink)
	blt.w	.random
	move.w	$14(a3),d1
	sub.w	(pucky).l,d1
	cmpi.w	#$28,d1		;same as above
	bgt.w	.random
	cmpi.w	#$FFD8,d1		;checking the inverse position (other side of rink)
	blt.w	.random
	asr.w	#$1,d0
.random	bsr.w	randomd0-LOAD
	btst	#$1,$64(a2)		;Check for player on breakaway
	beq.w	.teamchk		;branch if bit is 0
	move.w	$14(a2),d1		;Ypos of player being checked
	bpl.w	.calc		;will jump if Ypos is positive
	neg.w	d1		;flip result (other side of rink)
.calc	subi.w	#$108,d1		;subtract from Ypos
	neg.w	d1		;flip Y pos
	move.w	#$8,d0		;move 8 into d0. Removes any trace of Agr here
	cmpi.w	#$75,d1		;compares Ypos calc to 75 hex
	bgt.w	.rand2		;branch if higher than 75 hex
	move.w	#$7,d0		;move 7 into d0
	cmpi.w	#$3A,d1		;compare 3A hex to Ypos calc
	bgt.w	.rand2		;jump if higher than 3A hex
	move.w	#$4,d0		;moves 4 into d0
	cmpi.w	#$2C,d1		;compares 2C hex to Ypos calc
	bgt.w	.rand2		;jump if higher than 2C hex
	move.w	#$3,d0		;finally, just move 3 in d0
.rand2	bsr.w	randomd0-LOAD
.teamchk	btst	#$6,$62(a3)		;checks if home or away team
	bne.w	.away
	btst	#$2,$17F7E.l		;visitors have a delayed penalty
	bne.w	.nopen
	bra.w	.end
.away	btst	#$1,$17F7E.l		;home team has a delayed penalty
	beq.w	.end
.nopen	move.w	#$7F,d0
.end	rts
	btst	#$5,$62(a3)
	bne.w	X_21000
	tst.w	$34(a3)
	beq.w	X_21000
	btst	#$0,$63(a3)
	bne.w	X_21000
	move.w	$0(a3),d0
	sub.w	$0(a2),d0
	move.w	$14(a3),d1
	sub.w	$14(a2),d1
	bsr.w	vtoa-LOAD
	sub.w	$54(a2),d0
	addi.w	#$1,d0
	andi.w	#$7,d0
	cmpi.w	#$2,d0
	bhi.w	X_21000
	move.w	$17BE0.l,d0
	cmp.w	$52(a3),d0
	bne.w	.l1F87C
	bclr	#$3,$17F6A.l
.l1F87C	move.w	$28(a3),d0
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
	bsr.w	X_1B3C0
	exg.l	a2,a3
	bset	#$5,$62(a3)
	move.w	#$CC2,d1
	cmpi.w	#$C90,$58(a3)
	beq.w	.l1F8C8
	move.w	#$1154,d1
.l1F8C8	bsr.w	X_1B3C0
	bsr.w	.l1F75C
	cmpi.w	#$6,d0
	bhi.w	.l1F900
	btst	#$4,$17F68.l
	bne.w	.l1F900
	move.w	#$24,d0
	cmpi.w	#$CC2,$58(a3)
	beq.w	.l1F8F6
	move.w	#$1E,d0
.l1F8F6	jsr	(PenShotChk).l
	bsr.w	AddPenalty-LOAD
.l1F900	exg.l	a2,a3
	st.b	$17EEE.l
	rts
	btst	#$5,$62(a3)
	bne.w	X_21000
	tst.w	$34(a3)
	beq.w	X_21000
	btst	#$0,$63(a3)
	bne.w	X_21000
	tst.w	(OptPen).l
	bne.w	.l1F96C
	btst	#$3,$62(a2)
	beq.w	.l1F96C
	moveq	#$20,d0
	add.b	$75(a2),d0
	sub.b	$68(a3),d0
	btst	#$1,$17F7C.l
	bne.w	.l1F95C
	btst	#$6,$17F7A.l
	beq.w	.l1F960
.l1F95C	subi.b	#$2,d0
.l1F960	bsr.w	randomd0-LOAD
	cmpi.w	#$18,d0
	blt.w	X_21000
.l1F96C	move.w	$0(a3),d0
	sub.w	$0(a2),d0
	move.w	$14(a3),d1
	sub.w	$14(a2),d1
	bsr.w	vtoa-LOAD
	sub.w	$54(a2),d0
	addi.w	#$1,d0
	andi.w	#$7,d0
	cmpi.w	#$2,d0
	bhi.w	X_21000
	exg.l	a2,a3
	bsr.w	.l1F9BE
	bsr.w	.l1F75C
	cmpi.w	#$4,d0
	bhi.w	.l1F9B4
	move.w	#$20,d0
	jsr	(PenShotChk).l
	bsr.w	AddPenalty-LOAD
.l1F9B4	exg.l	a2,a3
	st.b	$17EEE.l
	rts
.l1F9BE	cmpi.w	#$B,$52(a2)
	bgt.w	X_21000
	cmpi.w	#$145C,$58(a2)
	beq.w	X_21000
	cmpi.w	#$1AF4,$58(a2)
	beq.w	X_21000
	cmpi.w	#$11E6,$58(a2)
	beq.w	X_21000
	cmpi.w	#$D26,$58(a2)
	beq.w	X_21000
	cmpi.w	#$DD8,$58(a2)
	beq.w	X_21000
	cmpi.w	#$136A,$58(a2)
	beq.w	X_21000
	cmpa.l	$1AD7E.l,a2
	bne.w	.l1FA1A
	cmpa.l	$1AD82.l,a3
	bne.w	.l1FA1A
	rts
.l1FA1A	move.l	a2,$1AD7E.l
	move.l	a3,$1AD82.l
	btst	#$3,$64(a2)
	bne.w	X_21000
	btst	#$3,$64(a3)
	bne.w	X_21000
	move.w	#$11E6,d1
	btst	#$4,$64(a3)
	bne.w	X_1FAC0
	cmpi.b	#$18,$71(a2)
	dc.w	$6D00,$0070,$4A2A,$005F,$6600,$0068,$0839,$0007
	dc.w	$00FF,$800E,$66F6,$33FC,$001B,$00FF,$8020,$08F9
	dc.w	$0006,$00FF,$800F,$0839,$0006,$00FF,$800E,$67F6
	dc.w	$3039,$00FF,$8010,$08F9,$0007,$00FF,$800F,$08B9
	dc.w	$0006,$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6
	dc.w	$08B9,$0007,$00FF,$800F,$0240,$000F,$0640,$0010
	dc.w	$B06A,$0032,$6F00,$000C,$157C,$003C,$005F,$6000
	dc.w	$02D6,$4A6B,$0034,$6700,$0042,$207C,$0001,$834C
	dc.w	$082B,$0006,$0062,$6700,$0006,$D0FC,$0366,$0668
	dc.w	$0001,$0010,$4240,$102B,$0066,$D0C0,$0628,$0001
	dc.w	$011E,$0679,$0001,$0001,$80EC,$4A2B,$0074,$6600
	dc.w	$000A,$0679,$0002,$0001,$80EC,$157C,$0078,$005E
	dc.w	$302B,$0000,$906A,$0000,$322B,$0014,$926A,$0014
	dc.w	$6100,$B7D8,$4A6A,$0034,$6700,$0222,$4EB9,$0002
	dc.w	$4FB4,$082A,$0004,$0064,$6700,$0212,$48E7,$7800
	dc.w	$322A,$0028,$6A00,$0004,$4441,$342A,$002A,$6A00
	dc.w	$0004,$4442,$362A,$0000,$966B,$0000,$382A,$0014
	dc.w	$986B,$0014,$0C6B,$0108,$0014,$6E00,$0042,$0C6B
	dc.w	$FEF8,$0014,$6D00,$002E,$4A6B,$0000,$6A00,$0014
	dc.w	$4A43,$6A00,$0034,$0C43,$FFFD,$6E00,$002C,$6000
	dc.w	$0030,$4A43,$6B00,$0022,$0C43,$0003,$6D00,$001A
	dc.w	$6000,$001E,$4A44,$6A00,$0010,$6000,$0014,$4A44
	dc.w	$6B00,$0006,$6000,$000A,$4CDF,$001E,$6000,$018E
	dc.w	$4CDF,$001E,$6000,$0002,$0C6A,$010C,$0014,$6E00
	dc.w	$0024,$0C6A,$FEF4,$0014,$6D00,$001A,$0C6A,$0068
	dc.w	$0000,$6E00,$0010,$0C6A,$FF98,$0000,$6D00,$0006
	dc.w	$6000,$015A,$0C6B,$000B,$0052,$6E00,$0034,$0679
	dc.w	$000A,$0001,$7CD8,$0679,$0096,$0001,$7CD2,$3F01
	dc.w	$177C,$0000,$0040,$177C,$0000,$0065,$323C,$1AC2
	dc.w	$4EB9,$0003,$63C0,$426B,$0028,$426B,$002A,$321F
	dc.w	$48E7,$8080,$0C6A,$010C,$0014,$6E00,$0024,$0C6A
	dc.w	$FEF4,$0014,$6D00,$0022,$4A6A,$0000,$6B00,$000A
	dc.w	$303C,$0002,$6000,$0016,$303C,$0006,$6000,$000E
	dc.w	$303C,$0000,$6000,$0006,$303C,$0004,$D040,$207C
	dc.w	$0003,$AD3A,$3230,$0000,$33EA,$0014,$0001,$937C
	dc.w	$33EA,$0000,$0001,$937E,$0C41,$18CC,$6600,$003A
	dc.w	$0C6A,$0059,$0014,$6E00,$0030,$0C6A,$FFA7,$0014
	dc.w	$6D00,$0026,$3F00,$303C,$0007,$4EB9,$0002,$A41E
	dc.w	$301F,$323C,$193E,$082A,$0003,$0004,$6700,$0062
	dc.w	$323C,$1A00,$6000,$005A,$0C41,$17E8,$6600,$002C
	dc.w	$0C6A,$0038,$0014,$6E00,$0022,$0C6A,$FFC8,$0014
	dc.w	$6D00,$0018,$323C,$1A00,$082A,$0003,$0004,$6700
	dc.w	$0030,$323C,$193E,$6000,$0028,$082A,$0003,$0004
	dc.w	$6700,$001E,$0C41,$17E8,$6700,$0012,$0C41,$18CC
	dc.w	$6600,$000E,$323C,$17E8,$6000,$0006,$323C,$18CC
	dc.w	$426A,$0028,$426A,$002A,$08EA,$0005,$0064,$08EA
	dc.w	$0000,$0062,$4CDF,$0101,$6000,$002E,$1776,$1776
	dc.w	$17E8,$17E8,$185A,$185A,$18CC,$18CC,$323C,$0DD8
	dc.w	$906A,$0054,$0640,$0001,$0240,$0007,$0C40,$0002
	dc.w	$6300,$0034,$323C,$0D26,$302A,$0054,$0240,$0003
	dc.w	$6600,$0024,$0C2B,$0014,$0075,$6D00,$001A,$0C6B
	dc.w	$000B,$0052,$6E00,$0010,$082A,$0005,$0064,$6600
	dc.w	$0006,$323C,$136A,$C54B,$08EB,$0005,$0062,$6100
	dc.w	$B622,$C54B,$4A6B,$0034,$6700,$001A,$4A6A,$0034
	dc.w	$6700,$0012,$0679,$012C,$0001,$7CD2,$0679,$000F
	dc.w	$0001,$7CD8,$3039,$0001,$7BE0,$6B00,$F674,$B06A
	dc.w	$0052,$6600,$F66C,$50F9,$0001,$7BE0,$0839,$0004
	dc.w	$0001,$7F68,$6600,$008E,$0C6A,$0DD8,$0058,$6600
	dc.w	$0084,$302A,$0054,$0240,$0003,$6600,$0078,$082A
	dc.w	$0004,$0063,$6600,$006E,$203C,$0000,$00A0,$6100
	dc.w	$C242,$B06A,$0032,$6E00,$005C,$0839,$0000,$0001
	dc.w	$7F68,$6600,$0050,$C54B,$323C,$145C,$6100,$B594
	dc.w	$C54B,$6100,$0058,$0839,$0005,$0001,$7F7A,$6600
	dc.w	$000E,$C54B,$323C,$1AF4,$6100,$B578,$C54B,$33FC
	dc.w	$0004,$0001,$806A,$7014,$4A6B,$0034,$6700,$E5FA
	dc.w	$4A79,$0001,$8C08,$6700,$E5F0,$7012,$6100,$E5EA
	dc.w	$6000,$EBE6,$3F3C,$000B,$082A,$0006,$0062,$6600
	dc.w	$0006,$3EBC,$000C,$6100,$C286,$4E75
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
	bsr.w	sfx-LOAD
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
	move.w	d1,(TempPlOffset).l
	ext.w	d1		;sign extend - in this case just makes upper bye of word 00
	add.w	d1,d1		;add d1 to itself
	exg.l	a2,a3		;swap a2 and a3
	jsr	$2AC3C.l		;get the Fgt byte (divided by 4)
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
	jsr	$2AC46.l		;check Fgt bit 1 of player.
	beq.w	.exit		;jump if Fgt not 2,6,A
.injurygame	bset	#$5,$17F7A.l		;set injury game bit
	move.w	#$FFFC,$68(a0,d1.w)		;update status of player
.exit	move.w	(sp)+,d0
	rts
	rts
