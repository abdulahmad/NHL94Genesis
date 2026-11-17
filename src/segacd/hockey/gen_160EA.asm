passto						;pass the puck to player a0: a3 = passer
	btst	#$3,$62(a3)
	beq.w	.next
	tst.w	$34(a3)
	bne.w	.next
	movem.l	d0-d1,-(sp)
	btst	#$3,$62(a0)
	bne.w	.stack
	bset	#$6,$64(a0)		;pflags3 bit 6
	move.w	$17FA6.l,d1
	cmp.w	$17FA8.l,d1
	bne.w	.h2hor1p
	move.w	$52(a0),d0		;SCnum of receiver into d0
	move.w	$52(a3),d1		;SCnum of passer into d1
	cmp.w	$17F9E.l,d1
	bne.w	.p2passing
	jsr	(setc1player).l
	bra.w	.stack
.p2passing	jsr	(setc2player).l
	bra.w	.stack
.h2hor1p	move.w	#$1,d1
	btst	#$6,$62(a3)		;check if home or away team
	beq.w	.0		;branch if home
	move.w	#$2,d1		;away team
.0	move.w	$52(a0),d0		;move SCnum of receiver into d0
	cmp.w	$17FA6.l,d1
	bne.w	.diffteam
	jsr	(setc1player).l
	bra.w	.stack
.diffteam	jsr	(setc2player).l
.stack	movem.l	(sp)+,d0-d1
.next	jsr	$3C958.l
	addi.w	#$1,$12(a2)
	move.w	$52(a0),$17E30.l
	move.w	$17E2E.l,d5
	asr.w	#$2,d5
	exg.l	a0,a3
	moveq	#$13,d0
	bsr.w	AssistListPush
	exg.l	a0,a3
	move.l	a0,-(sp)
	bsr.w	GetHotCount
	add.w	$0(a0),d0
	sub.w	$17B80.l,d0
	add.w	$14(a0),d1
	sub.w	$17B94.l,d1
	movem.w	d0-d1,-(sp)
	movem.w	(sp),d2-d3
	asr.w	#$2,d2
	asr.w	#$2,d3
	move.w	$28(a0),d0
	muls.w	#$F0,d0
	swap	d0
	move.w	$2A(a0),d1
	muls.w	#$F0,d1
	swap	d1
	movem.w	d0-d1,-(sp)
	muls.w	d2,d0
	muls.w	d3,d1
	add.w	d1,d0
	asl.w	#$1,d0
	move.w	d0,d4
	movem.w	(sp),d0-d1
	muls.w	d0,d0
	muls.w	d1,d1
	muls.w	d5,d5
	neg.l	d5
	add.l	d0,d5
	add.l	d1,d5
	muls.w	d2,d2
	muls.w	d3,d3
	add.l	d2,d3
	muls.w	d5,d3
	asl.l	#$2,d3
	move.w	d4,d0
	muls.w	d0,d0
	sub.l	d3,d0
	bsr.w	Sroot
	moveq	#$1,d3
	asr.w	#$2,d5
	bne.w	.loop
	moveq	#$1,d5
.loop	move.w	d0,d2
	neg.w	d0
	sub.w	d4,d2
	ext.l	d2
	divs.w	d5,d2
	dbpl	d3,.loop
	bne.w	.next2
	addi.w	#$1,d2
.next2	cmpi.w	#$18,d2
	bls.w	.next3
	moveq	#$18,d2
.next3	move.b	d2,$17BAC.l
	cmpi.w	#$C,d2
	blt.w	.next4
	move.b	#$C,$17BAC.l
.next4	move.w	d2,d0
	asl.w	#$3,d0
	subi.w	#$A,d0
	move.b	d0,$40(a0)
	subi.w	#$6,d0
	move.b	d0,$17BDE.l
	movem.w	(sp)+,d0-d1
	muls.w	d2,d0
	asr.l	#$1,d0
	add.w	(sp)+,d0
	move.w	$17B80.l,$44(a0)
	add.w	d0,$44(a0)
	muls.w	d2,d1
	asr.l	#$1,d1
	add.w	(sp)+,d1
	move.w	$17B94.l,$46(a0)
	add.w	d1,$46(a0)
	mulu.w	#$78,d2
	swap	d0
	divs.w	d2,d0
	move.w	d0,$17BA8.l
	swap	d1
	divs.w	d2,d1
	move.w	d1,$17BAA.l
	rts
; Jumps to the pass routine at $2B4E2.
PassToJump
	jmp	$2B4E2.l
Sweepcheck						;start sweep check on player a3
	bset	#$5,$62(a3)
	move.w	#$B24,d1
	bra.w	SetSPA
setc1player
	cmp.w	$17F9E.l,d0
	beq.w	.ex
	movem.l	d1/a0-a1,-(sp)
	move.w	$17F9E.l,d1
	bsr.w	restorepl
	move.w	d0,$17F9E.l
	movem.l	(sp)+,d1/a0-a1
.ex	rts
setc2player
	cmp.w	$17FA0.l,d0
	beq.w	.ex
	movem.l	d1/a0-a1,-(sp)
	move.w	$17FA0.l,d1
	bsr.w	restorepl
	move.w	d0,$17FA0.l
	movem.l	(sp)+,d1/a0-a1
.ex	rts
restorepl						;restore old joy controlled player d1, give d0 the joystick; a d1 in line
									;change mode keeps control
	movea.l	#$17480,a0
	tst.w	d1
	blt.w	.spd
	cmpi.w	#$B,d1
	bgt.w	.spd
	asl.w	#$7,d1		;multiply d0 by 80 hex (SCsize)
	btst	#$3,$63(a0,d1.w)		;#pfnp - no joystick pad
	beq.w	.cont
	lsr.w	#$7,d1		;divide by 80 hex
	move.w	d1,d0
	rts
.cont	bclr	#$3,$62(a0,d1.w)		;#pfjoycon
	btst	#$3,$64(a0,d1.w)		;bit 3, pflags3
	bne.w	.spd
	bset	#$1,$62(a0,d1.w)		;#pfna - new assignment
.spd	tst.w	d0		;checks if d0 0 or higher
	blt.w	.ex
	cmpi.w	#$B,d0		;checks if d0 11 or less
	bgt.w	.ex
	move.w	d0,d1		;copies d0 into d1
	asl.w	#$7,d1
	btst	#$2,$17F70.l
	bne.w	.chkgoalie
	btst	#$0,$17F78.l
	beq.w	.3
.chkgoalie	tst.w	$34(a0,d1.w)
	bne.w	.3
	btst	#$6,$62(a0,d1.w)		;check if home or away
	beq.w	.next
	tst.w	$18C0E.l
	bra.w	.1
.next	tst.w	$18C0C.l
.1	beq.w	.3
	move.w	#$0,d0		;first position of home SCNum
	btst	#$6,$62(a0,d1.w)		;check if home or away
	beq.w	.2
	move.w	#$6,d0		;first position of away SCNum
.2	bra.w	.ex
.3	bset	#$3,$62(a0,d1.w)		;set pfjoycon for SCNum
.ex	rts
Findhittype						;look for type of swing (forhand or backhand)
									;input d0 = launch dir
									;ouput beq forhand
	neg.w	d0
	add.w	$54(a3),d0		;facedir
	andi.w	#$7,d0
	btst	#$3,$4(a3)		;attribute bit 3
	beq.w	.next
	dc.w	$013C,$00F0,$4E75
.next	dc.w	$013C,$001E,$4E75
SetShotMode
	btst	#$2,$17F70.l
	beq.w	.next
	bclr	#$2,$17F78.l
	bset	#$5,$17F70.l
	bne.w	doinput_islockedExit
	bclr	#$5,$17F78.l
	move.w	#$64,$17F9A.l
.next	move.w	#$8,$17E2C.l
	bset	#$3,$17F6A.l
	clr.w	d0
	move.w	#$128,d1
	btst	#$7,$62(a3)
	bne.w	.next2
	neg.w	d1
.next2	sub.w	$0(a3),d0
	sub.w	$14(a3),d1
	bsr.w	vtoa
	move.w	#$F,$17E2E.l
	move.w	#$7FC,d1
	bsr.w	Findhittype
	beq.w	.next3
	move.w	#$92E,d1
	move.w	#$F,$17E2E.l
.next3	bra.w	SetSPA
ShotMode						;shot input
									;swing frame reached (anim frame 7*4): shoot, else dpad sets shot
									;direction
	cmpi.w	#$1C,$5A(a3)
	bge.w	prepshot		;end of animation so shoot
	btst	#$3,d0		;checks dpad for direction
	bne.w	.next
	andi.w	#$7,d0		;pass the first 3 bits of d0
	move.w	d0,$17E2C.l
.next	cmpi.w	#$10,$5A(a3)
	bge.w	doshot_1
	add.w	d7,$17E2E.l
	cmpi.b	#$14,$6C(a3)		;6C = shot speed
	bge.w	.checkcbut
	cmpi.w	#$8,$5A(a3)		;SPANum
	bgt.w	.chganim
.checkcbut	btst	#$5,d2		;5 = #cbut
	beq.w	doshot_1		;button hasnt changed so continue windup
.chganim	neg.w	$5A(a3)		;end windup and swing through
	addi.w	#$1C,$5A(a3)		;Add to SPANum
	rts
prepshot						;check the conditions before a shot: d0 = SCnum of the opposing goalie
									;(getGoalieSCnum)
	bclr	#$4,$17F74.l
	move.w	#$B,d0
	btst	#$6,$62(a3)		;check if home or away
	beq.w	.getGoalie		;gets opponents Goalie SCnum
	move.w	#$5,d0		;opponent is home
.getGoalie	jsr	(getGoalieSCnum).l
	tst.w	d0
	bmi.w	.next
	movem.l	a0,-(sp)
	asl.w	#$7,d0
	movea.l	#$17480,a0
	cmpi.w	#$250,$58(a0,d0.w)		;Checking goalie animations - pad stack right
	beq.w	.svgoalie
	cmpi.w	#$2A2,$58(a0,d0.w)		;Checking another goalie animation - pad stack left
.svgoalie	movem.l	(sp)+,a0		;pop stack value into a0
	bne.w	.cont
.next	cmpi.w	#$1,$17E2C.l
	ble.w	.next2
	cmpi.w	#$7,$17E2C.l
	bne.w	.cont
.next2	move.w	$17B94.l,d0
	btst	#$7,$62(a3)		;#pfgoal - goal to shoot at (0=bottom, 1=top)
	bne.w	.cmppuck		;branch if top
	neg.w	d0		;flips d0 for compare calc
.cmppuck	cmpi.w	#$D8,d0		;compares location of puck
	blt.w	.cont
	bset	#$4,$17F74.l		;set flag for in-close top shelf shooting
.cont	bra.w	doshot
doshot						;stick is at puck so launch puck toward goal
	movem.l	d0-d7/a0-a3,-(sp)
	bclr	#$4,$17F78.l
	btst	#$1,$64(a3)		;check if player on breakaway
	beq.w	.cont
	bset	#$4,$17F78.l		;set if breakaway
.cont	bsr.w	ShotDirAdjustCheck
	move.w	#$5,-(sp)		;#SFXshotwiff - sound effect
	move.w	$52(a3),$17E28.l
	bclr	#$3,$17F6A.l		;#sfssdir - shot direction mode
	bset	#$5,$62(a3)		;#pfalock
	btst	#$3,$64(a3)		;check if shooting one timer
	bne.w	.shottype		;jump if yes
	move.w	$17BE0.l,d0		;puck carrier SCnum into d0
	cmp.w	$52(a3),d0		;is player puck carrier?
	bne.w	.ex		;wiffed shot
.shottype	move.w	#$18,(sp)		;#SFXshotfh
	bset	#$4,$17F6C.l		;#sf2shot - shot was taken
	cmpi.w	#$92E,$58(a3)
	bne.w	.nbh		;no backhand
	move.w	#$14,(sp)		;#SFXshotbh
	move.w	$17E2E.l,d0
	lsr.w	#$2,d0
	sub.w	d0,$17E2E.l
.nbh	btst	#$3,$64(a3)		;check if shooting one timer
	beq.w	.cont2		;jump if not
	movem.l	d0-d1,-(sp)		;push d0-d1 on stack
	move.w	#$1F,d0		;1F into d0 - one timer min speed
	move.w	d0,$17E2E.l
	movem.l	(sp)+,d0-d1		;Pop off stack d0-d1
.cont2	clr.w	d0
	move.b	$6C(a3),d0		;6C = shotspd (ShP)
	lsr.b	#$1,d0		;divide by 2
	movea.l	a3,a0		;move a3 address into a0
	jsr	(makepde).l
	addi.w	#$14,d0
	mulu.w	$17E2E.l,d0
	mulu.w	#$5249,d0
	swap	d0
	move.w	d0,$17E2E.l
	btst	#$0,$6C(a3)		;checks if ShP value is even or odd
	beq.w	.even
	asr.w	#$4,d0		;divide by 16
	add.w	$17E2E.l,d0
.even	lsr.w	#$4,d0		;divide by 16 (d0 is passspeed)
	neg.w	d0		;negative
	addi.w	#$3,d0		;add 3 to d0
	bpl.w	.nbh2
	clr.w	d0		;clear if negative
.nbh2	add.w	d0,(sp)		;add to stack current value (Shot SFX)
	st.b	$17BE0.l		;clear puck carrier
	move.b	#$10,$5E(a3)		;5E = nopuck - no puck collision till 0
	move.w	$52(a3),$17E2A.l
	move.w	#$108,d1		;$108 = top goal line Y position
	btst	#$7,$62(a3)		;pfgoal, pflags
	bne.w	.next		;branch if shooting up
	neg.w	d1		;flip d1 if shooting down
.next	move.w	$17E2C.l,d2
	asl.w	#$2,d2
	lea.l	shotdiradj(pc),a0
	move.w	(a0,d2.w),d0
	move.w	$2(a0,d2.w),d2
	sub.w	$17B80.l,d0
	sub.w	$17B94.l,d1
	movem.w	d0-d2,-(sp)		;push d0-d2(dx,dy,z offset) on stack
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	bsr.w	Sroot
	tst.w	d0		;distance in pix to goal
	bne.w	.1
	addi.w	#$1,d0
.1	move.w	d0,d3		;straight line distance from puck to spot aiming for with passdir
	btst	#$4,$17F68.l		;check if highlight (always perfect)
	bne.w	.next2
	cmpi.w	#$C8,d3		;C8 = 200 decimal
	bhi.w	.notperf		;too far away from perfect shot
	jsr	(ReadGoaliePulled).l		;checks if shooting team's G pulled
	bmi.w	.next2		;perfect shot with pulled goalie
	btst	#$0,$17F78.l		;check if shootout
	bne.w	.next2		;perfect shot in shootout
	moveq	#$10,d0		;start value for ShA calc
	add.b	$6D(a3),d0		;shotacc(a3)
	bsr.w	randomd0
	cmpi.w	#$E,d0		;chance of perfect shot
	bgt.w	.next2		;branch if higher - perfect shot
.notperf	clr.w	d0
	move.b	$6D(a3),d0		;shotacc(a3)
	lsr.w	#$1,d0		;divide by 2
	move.b	d0,-(sp)		;push on stack
	move.w	$17E2E.l,d0
	lsr.w	#$4,d0		;divide by 16
	sub.b	(sp)+,d0		;shotacc(a3) / 2
	addi.b	#$10,d0		;add $10 to d0
	mulu.w	d3,d0		;mult straight line distance with d0
	lsr.w	#$6,d0		;shot accuracy adjust - divide by 64
	cmpi.w	#$FA,d3		;250 pixels straight line distance
	bhi.w	.chkvalue		;branch if higher
	lsr.w	#$1,d0		;extra shot accuracy adjust
.chkvalue	cmpi.w	#$88,d0		;compare to $88 (max adj value in X)
	blt.w	.cont3
	move.w	#$88,d0
.cont3	move.w	d0,-(sp)		;push adjusting value: 2(sp) / 4(sp) = x / y diff pushed before
	bsr.w	randomd0s		;RNG adj value
	add.w	d0,$2(sp)		;add result to x diff
	move.w	(sp),d0		;move adjusting value into d0
	cmpi.w	#$3C,d0		;compare to $3C (max adjustment in Y)
	bls.w	.lessx		;branch if less
	moveq	#$3C,d0
	move.w	d0,(sp)
.lessx	tst.w	$4(sp)
	bpl.w	.ycalc
	lsr.w	#$1,d0
.ycalc	bsr.w	randomd0s		;RNG adjustment
	add.w	d0,$4(sp)		;add to y diff
	move.w	(sp)+,d0		;pop adj value
	lsr.w	#$1,d0		;divide by 2
	bsr.w	randomd0		;RNG result
	add.w	d0,$4(sp)		;add to Z diff
.next2	move.w	$17E2E.l,d2
	muls.w	#$44,d2		;1024/15
	muls.w	(sp)+,d2		;mult by x dist
	divs.w	d3,d2		;divide d2 by straight line distance
	move.w	d2,$17BA8.l
	move.w	$17E2E.l,d2
	muls.w	#$44,d2		;1024/15
	muls.w	(sp)+,d2		;mult by y dist
	divs.w	d3,d2		;divide d2 by straight line distance
	move.w	d2,$17BAA.l
	move.w	#$8000,d1		;this is the highest negative puckvy possible
	btst	#$7,$62(a3)		;check direction of shooting net
	beq.w	.2		;branch if bottom goal
	clr.w	d1
.2	eor.w	d2,d1		;EOR - checking to see if exceeding maximum puckvy
	bpl.w	.next3		;branch if positive
	move.w	#$3810,$17BAA.l
	btst	#$7,$62(a3)
	bne.w	.next3
	move.w	#$C7F0,$17BAA.l
.next3	move.w	(sp)+,d1
	beq.w	.ex
	mulu.w	$17E2E.l,d1
	mulu.w	#$44,d1		;1024/15
	divu.w	d3,d1		;by d3 = distance in pix to goal
	mulu.w	#$B33,d3		;(1024*42)/15
	divu.w	$17E2E.l,d3
	add.w	d1,d3
	cmpi.w	#$1800,d3
	bls.w	.next4		;branch if less than
	move.w	#$1800,d3		;set max puckvz
.next4	move.w	d3,$17BAC.l
	bclr	#$4,$17F74.l		;check in-close top shelf bit
	beq.w	.ex		;if bit was cleared, exit
	btst	#$3,$64(a3)		;check if one timer
	bne.w	.ex		;branch if so
	jsr	(puckvzadj).l		;adjust puckvz for top shelf shot
.ex	bsr.w	sfx		;play the shot sound
	movem.l	(sp)+,d0-d7/a0-a3
doshot_1	rts
shotdiradj						;If the opposing goalie
									;covers the middle of the net, set passdir 2 or 6 to shoot at the open
									;side, else 0. Skipped for computer players (pfjoycon clear)
	ori.b	#$C,d0
	ori.b	#$C,(a0)
	ori.b	#$6,(a0)
	ori.b	#$0,(a0)
	ori.b	#$0,d0
	dc.w	$FFF0
	dc.l	$FFF0
	dc.w	$0006,$FFF0
	dc.w	$000C,$0000,$0006
; Checks the direction bits before adjusting a shot.
ShotDirAdjustCheck
	btst	#$3,$64(a3)
	bne.w	.next
	btst	#$3,$62(a3)
	bne.w	.ex
.next	moveq	#$8,d0
	moveq	#$5,d1
	movea.l	#$17400,a0
	btst	#$6,$62(a3)
	bne.w	.loop
	adda.w	#$300,a0
.loop	adda.w	#$80,a0
	tst.w	$34(a0)
	dbeq	d1,.loop
	bne.w	.next4
	move.b	$28(a0),d0
	ext.w	d0
	asr.w	#$1,d0
	add.w	$0(a0),d0
	sub.w	$17B80.l,d0
	move.b	$2A(a0),d1
	ext.w	d1
	asr.w	#$1,d1
	add.w	$14(a0),d1
	sub.w	$17B94.l,d1
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	addq.l	#$1,d0
	bsr.w	Sroot
	move.w	d0,d2
	movem.w	(sp)+,d0-d1
	moveq	#$12,d3
	move.w	#$108,d4
	btst	#$7,$62(a3)
	bne.w	.next2
	neg.w	d4
.next2	movem.w	d3-d4,-(sp)
	bsr.w	.next6
	move.w	d4,d5
	movem.w	(sp)+,d3-d4
	neg.w	d3
	bsr.w	.next6
	add.w	d5,d4
	clr.w	d0
	cmpi.w	#$2C,d4
	bgt.w	.next4
	cmpi.w	#$FFD4,d4
	blt.w	.next4
	btst	#$7,$62(a3)
	beq.w	.next3
	neg.w	d4
.next3	moveq	#$2,d0
	tst.w	d4
	bpl.w	.next4
	moveq	#$6,d0
.next4	move.w	d0,$17E2C.l
	btst	#$2,$17F70.l
	bne.w	.next5
	btst	#$0,$17F78.l
	beq.w	.ex
.next5	jsr	(PSandSOpassdir).l
.ex	rts
.next6	sub.w	$17B80.l,d3
	sub.w	$17B94.l,d4
	muls.w	d0,d4
	muls.w	d1,d3
	sub.l	d3,d4
	divs.w	d2,d4
	rts
setpads						;Put SCnum of a3 in the d4 nibble of PadControlBits ; d4 = -2 puck
									;carrier, 0 / 2 pads, 4 replay target. Falls into rtss3
	movem.l	d0-d1,-(sp)
	moveq	#$2,d0
	add.w	d4,d0
	add.w	d0,d0
	move.w	#$FFF0,d1
	rol.w	d0,d1
	and.w	d1,$17DC8.l
	move.w	$52(a3),d1
	asl.w	d0,d1
	or.w	d1,$17DC8.l
	movem.l	(sp)+,d0-d1
setpads_1	rts
check4bench
	btst	#$2,$17F70.l
	bne.w	setpads_1
	btst	#$3,$62(a3)
	bne.w	setpads_1
	btst	#$4,$63(a3)
	bne.w	setpads_1
	tst.b	$60(a3)
	bpl.w	.next
	tst.b	$61(a3)
	bmi.w	setpads_1
.next	move.b	$61(a3),d0
	cmp.b	$66(a3),d0
	beq.w	.next2
	move.w	$36(a3),d0
	cmpi.b	#$B,$38(a3,d0.w)
	beq.w	setpads_1
	move.w	$52(a3),d0
	cmp.w	$17BE0.l,d0
	beq.w	setpads_1
	adda.w	#$4,sp
	bset	#$2,$63(a3)
	clr.w	$40(a3)
	moveq	#$B,d0
	bra.w	assreplace
.next2	adda.w	#$4,sp
	bclr	#$2,$63(a3)
	bclr	#$2,$62(a3)
	st.b	$61(a3)
	st.b	$60(a3)
	move.w	$34(a3),d0
	tst.b	$60(a3)
	bpl.w	.next3
	jmp	(Setplass).l
.next3	move.b	$60(a3),d0
	ext.w	d0
	move.w	d0,$34(a3)
	jmp	(Setplass).l
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_169AC.bin
check4benchExit
	rts
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_16AB8.bin
assdopen						;add player a3 to penalty box
	btst	#$5,$62(a3)
	bne.w	check4benchExit
	moveq	#$10,d0
	btst	#$6,$62(a3)
	beq.w	.next
	moveq	#$1,d0
.next	add.b	d0,$18068.l
	st.b	$34(a3)
	clr.w	$6(a3)
	rts
assepen						;player a3 should exit penalty area
	btst	#$5,$62(a3)
	bne.w	check4benchExit
	bclr	#$1,$62(a3)
	beq.w	.nna
	bset	#$2,$62(a3)		;set player in no collision mode
	bset	#$2,$63(a3)		;set player unavailable
	moveq	#$10,d0
	moveq	#-60,d1
	btst	#$6,$62(a3)
	beq.w	.next
	moveq	#$1,d0
	neg.w	d1
.next	sub.b	d0,$18068.l
	move.w	d1,$14(a3)
	clr.w	$28(a3)
	clr.w	$2A(a3)
	move.w	#$86,$0(a3)
	move.w	#$2,$54(a3)
	bset	#$5,$62(a3)
	move.w	#$FAC,d1
	bsr.w	SetSPA
	jmp	(SprSortSetup).l
.nna	move.w	#$4,$54(a3)
	st.b	$61(a3)
	st.b	$60(a3)
	bclr	#$3,$62(a3)
	bclr	#$2,$62(a3)
	bclr	#$5,$63(a3)		;pf2npc
	bclr	#$2,$63(a3)		;pf2unav
	move.w	#$F000,$28(a3)
	bra.w	assexit
assgoaliebreakwait						;asstab entry. In a shootout or penalty shot park the idle goalie off the
									;ice, else exit
	btst	#$5,$62(a3)		;check if animation locked
	bne.w	.exit		;exit if so
	btst	#$2,$17F70.l		;check if pen shot
	bne.w	.park		;branch if so
	btst	#$0,$17F78.l		;check for shootout
	bne.w	.park		;branch if so
	nop
	bra.w	assexit
.park	clr.w	$28(a3)		;clear Xvel
	clr.w	$2A(a3)		;clear Yvel
	movem.l	d0/a0,-(sp)		;push d0 and a0 on stack
	movea.l	#$17480,a0
	move.w	$1936A.l,d0
	asl.w	#$7,d0		;shift d0 7 bits left
	adda.w	d0,a0		;add d0 to address a0
	move.w	#$191,$14(a3)		;move 401 decimal into Ypos
	btst	#$7,$62(a0)		;check if shooting up or down (a0 is goalie being shot on)
	bne.w	.popstack		;branch if shooting up
	move.w	#$FE6F,$14(a3)		;move -191 decimal into Ypos (goalie not being shot on)
.popstack	movem.l	(sp)+,d0/a0
.exit	rts
assfaceoff						;players do nothing until faceoff is over
	btst	#$5,$62(a3)
	bne.w	assfaceoff_1
	btst	#$0,$17F6C.l
	beq.w	assexit
assfaceoff_1	rts
assfaceoffpl						;Face off player
	btst	#$5,$62(a3)
	bne.w	assfaceoff_1
	btst	#$0,$17F6C.l
	beq.w	.exit
	bclr	#$1,$62(a3)
	beq.w	.next
	clr.w	$40(a3)
.next	movea.l	#$17CF8,a0
	btst	#$6,$62(a3)
	beq.w	.0
	adda.w	#$4,a0
.0	move.w	$5A(a3),d0		;d0 = SPAnum/4 + 1, +3 for right handed: frame code for the big sprite
	lsr.w	#$2,d0
	addi.w	#$1,d0
	tst.b	$76(a3)
	bne.w	.lefty
	addi.w	#$3,d0
.lefty	move.w	d0,(a0)
	btst	#$3,$62(a3)
	bne.w	check4benchExit
	bset	#$1,$63(a3)
	bne.w	check4benchExit
	move.w	#$FEA,d1
	cmpi.w	#$10,$17BC0.l
	bls.w	.d
	moveq	#$8,d0
	bsr.w	randomd0
	tst.w	d0
	beq.w	.d
	move.w	#$1014,d1
.d	bset	#$1,$63(a3)
	bra.w	SetSPA
.exit	move.b	#$14,$5E(a3)
	bra.w	assexit
	dc.w	$4E75,$4E75
