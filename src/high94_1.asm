;	NHL 94 (retail) segment $F66EE-$F739D
;	94 code in the high ROM, after the graphics: the one-timer (puckvzadj, OneTimerPass / OneTimerTarget pass target, assonetimer,
;	setonetimeranim, onetimershot), the 4 way play adaptor test (Detect4WayPlay), the crowd meter (LoadCrowdRec, Crowd_Noise),
;	stopna2, the 92 corner wall check (checkwallcoll, wallcollb), the hot / cold tables (Create_HotCold_Table, AttributeCalc) and the
;	hot / cold player lists for the MATCHUPS text (NextHomeHotPlayer ... GetHotColdTotal). 94 only; 93 has no code here.
;	Transcribed from lst/nhl94.bin.lst lines 958869-960186. Names and most comments are the IDA ones (this IDA database is
;	commented); IDA auto names and the IDA placeholders are named for what the
;	code does. IDA gaps written from the retail bytes: unused code IDA left as dc.b (Read4WayPad1
;	... Read4WayPad4, Set4WayPlayer, Clamp0to100 and three rts), and labels for the branches IDA wrote as $F66FC / $F6772 / *+4. Locals
;	are named for what they do (the IDA _x locals keep their name), with the IDA label, unless generic, in an ;IDA: comment.

puckvzadj	;IDA name. 94 only: set puckvz for a top shelf shot from the distance to the goal line ($108) over puckvy, at most $7FFF. Called from doshot (logic94_1)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(pucky).w,d0	;move pucky into d0
	bpl.w	.dist	;branch if positive
	neg.w	d0	;negate d0
.dist
	subi.w	#$108,d0
	;sub top goal line from d0
	bpl.w	.0	;branch if positive
	neg.w	d0	;negate d0
.0
	swap	d0	;swap d0 words
	andi.l	#$FFFF0000,d0	;pass upper word of d0
	move.w	(puckvy).w,d1	;move puckvy into d1
	beq.w	.x	;branch if zero
	bpl.w	.speed	;branch if positive
	neg.w	d1	;negate d1
.speed
	move.w	#$11,d2	;move 11 into d2
	tst.w	(music_global_tick_counter).w	;This byte is never set
	beq.w	.div	;branch if equal (always is)
	move.w	#$16,d2	;move 16 into d2
.div
	divu.w	d1,d0	;divide d1 into d0
	andi.l	#$FFFF,d0	;pass lower word of d0
	divu.w	d2,d0	;divide d2 into d0
	tst.w	d0	;check d0
	bne.w	.calc	;branch if not zero
	move.w	#1,d0	;move 1 into d0
.calc
	move.l	#$A0000,d1
	move.w	d0,d3	;move d0 into d3
	mulu.w	d2,d0	;mult d2 and d0
	divu.w	d0,d1	;divide d0 into d1
	move.w	d2,d4	;move d2 into d4
	add.w	d2,d2	;double d2
	add.w	d4,d2	;add d4 to d2 (now d2 is d2 x 3)
	mulu.w	d3,d2	;multiply d3 and d2
	cmp.l	#$7FFF,d2	;compare to d2
	blt.w	.addvz	;branch if less than
	move.w	#$7FFF,d2	;move 7FFF into d2
.addvz
	add.w	d2,d1	;add d2 to d1
	tst.w	d1	;test d1
	bpl.w	.setvz	;branch if positive
	move.w	#$7FFF,d1	;move 7FFF into d1
.setvz
	move.w	d1,(puckvz).w	;move d1 into puckvz
.x
	movem.l	(sp)+,d0-d7/a0-a6
	rts
OneTimerPass	;94 only. One-timer pass: puckvz = sqrt(12 * onetimerheight), then puckvx / puckvy toward the target onetimertargetx / onetimertargety in puckvz
	;/ 3 frames; flip the puck (puckflip, a3 = the puck at puckx). Called from passmode (logic94_1)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$C,d0
	move.w	(onetimerheight).w,d1
	mulu.w	d1,d0
	swap	d0
	andi.l	#$FFFF0000,d0
	jsr	(sroot).l
	move.w	d0,(puckvz).w
	ext.l	d0
	move.w	#3,d4
	divu.w	d4,d0
	clr.l	d1
	move.w	(onetimertargetx).w,d1
	sub.w	(puckx).w,d1
	swap	d1
	tst.w	d0
	bne.w	.setv
	move.w	#1,d0
.setv
	divs.w	d0,d1
	move.w	d1,(puckvx).w
	clr.l	d1
	move.w	(onetimertargety).w,d1
	sub.w	(pucky).w,d1
	swap	d1
	divs.w	d0,d1
	move.w	d1,(puckvy).w
	movea.l	#puckx,a3
	move.w	(puckvz).w,d0
	jsr	(puckflip).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
OneTimerTarget	;94 only. One-timer pass target for receiver a3: an offset by facing from OneTimerNearTbl / OneTimerFarTbl (skater, near or far from the goal)
	;or OneTimerGoalieTbl (goalie), +-10 at random, into onetimertargetx / onetimertargety; sflags6 bit 2 = near. Called from passmode
	movem.l	d0-d7/a0-a6,-(sp)
	bclr	#2,(sflags6).w
	tst.w	$34(a3)
	bne.w	.skater
	movea.l	#OneTimerGoalieTbl,a0
	bra.w	.facing
.skater
	move.w	$14(a3),d0
	btst	#7,$62(a3)
	bne.w	.near
	neg.w	d0
.near
	bset	#2,(sflags6).w
	movea.l	#OneTimerNearTbl,a0
	cmp.w	#$58,d0
	blt.w	.facing
	movea.l	#OneTimerFarTbl,a0
	bclr	#2,(sflags6).w
.facing
	move.w	$54(a3),d0
	btst	#7,$62(a3)
	bne.w	.offset
	addq.w	#4,d0
	andi.w	#7,d0
.offset
	asl.w	#2,d0
	move.w	0(a0,d0.w),d1
	move.w	2(a0,d0.w),d2
	cmpa.l	#OneTimerFarTbl,a0
	bne.w	.side
	move.w	$14(a3),d0
	bpl.w	.chky
	neg.w	d0
.chky
	cmp.w	#$8A,d0
	blt.w	.side
	move.w	(a3),d0
	bpl.w	.chkx
	neg.w	d0
.chkx
	cmp.w	#$37,d0
	bgt.w	.side
	move.w	#$103,d2
.side
	btst	#7,$62(a3)
	bne.w	.rand
	neg.w	d1
	neg.w	d2
.rand
	move.w	#$A,d0
	jsr	(randomd0).l
	add.w	d0,d1
	move.w	#$A,d0
	jsr	(randomd0).l
	add.w	d0,d2
	move.w	d1,(onetimertargetx).w
	tst.w	$34(a3)
	beq.w	.sety
	sub.w	(a3),d1
	bmi.w	.left
	subi.w	#$3C,d1
	bpl.w	.sety
	neg.w	d1
	add.w	d1,(onetimertargetx).w
	bra.w	.sety
.left
	addi.w	#$3C,d1
	bmi.w	.sety
	sub.w	d1,(onetimertargetx).w
.sety
	move.w	d2,(onetimertargety).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
OneTimerNearTbl	;OneTimerTarget target offsets (x, y) by facing, receiver near the goal
	dc.w	$74,$C2,$74,$C2,$74,$C2,$74,$C2
	dc.w	$FF8C,$C2,$FF8C,$C2,$FF8C,$C2,$FF8C,$C2
OneTimerFarTbl	;OneTimerTarget target offsets (x, y) by facing, receiver far from the goal
	dc.w	$FFFB,$AB,$FFFB,$AB,$FFFB,$AB,$FFFB,$AB
	dc.w	$FFFB,$AB,$FFFB,$AB,$FFFB,$AB,$FFFB,$AB
OneTimerGoalieTbl	;OneTimerTarget target offsets (x, y) by facing, goalie
	dc.w	$FFFB,$FFF7,$32,$FFF7,$32,$FFF7,$32,$FFF7
	dc.w	$FFFB,$FFF7,$FFCE,$FFF7,$FFCE,$FFF7,$FFCE,$FFF7
assonetimer	;IDA name (and comments). 94 only: assignment $23 (asstab, hockey94_11), player a3 shooting a one-timer: take control of him
	;(setc1player / setc2player, also for pads 3 and 4), start the animation (setonetimeranim), then shoot when the puck arrives (EndOneTimer)
	bclr	#1,$62(a3)	;pfna - clear new assignment
	beq.w	.checkxpos	;branch if not new assignment
	bset	#3,$64(a3)	;set one timer bit
	bne.w	.checkxpos	;branch if already set
	bclr	#0,(onetimerflags).w
	bclr	#5,(sflags8).w
	clr.w	(onetimerflags).w
	clr.w	(onetimerclock).w
	st	(passplayer).w
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	$52(a3),d0	;move a3 SCnum into d0
	move.w	d0,(onetimerplayer).w	;move d0
	btst	#3,$62(a3)	;check if joystick controlled
	bne.w	.setanim	;branch if so
	tst.w	(inputjoy).w	;check input controller
	bmi.w	.setanim	;branch if minus (no control)
	beq.w	.cont1or3	;branch if controller 1 or 3
	cmpi.w	#1,(TmpJoyPuckCarrier).w	;compare if puck carrier is player 4
	bne.w	.setplayer2	;branch if not
	move.w	(cont2team).w,-(sp)
	move.w	(c2playernum).w,-(sp)
	move.w	(cont4team).w,(cont2team).w
	move.w	(c4playernum).w,(c2playernum).w
	jsr	(setc2player).l
	move.w	(c2playernum).w,(c4playernum).w
	move.w	(cont2team).w,(cont4team).w
	move.w	(sp)+,(c2playernum).w
	move.w	(sp)+,(cont2team).w
	bra.w	.setanim
.setplayer2
	jsr	(setc2player).l
	bra.w	.setanim
.cont1or3
	tst.w	(TmpJoyPuckCarrier).w	;check if puck carrier is player 3
	bne.w	.setplayer1	;branch if not
	move.w	(cont1team).w,-(sp)
	move.w	(c1playernum).w,-(sp)
	move.w	(cont3team).w,(cont1team).w
	move.w	(c3playernum).w,(c1playernum).w
	jsr	(setc1player).l
	move.w	(c1playernum).w,(c3playernum).w
	move.w	(cont1team).w,(cont3team).w
	move.w	(sp)+,(c1playernum).w
	move.w	(sp)+,(cont1team).w
	bra.w	.setanim
.setplayer1
	jsr	(setc1player).l
	bra.w	.setanim	;IDA: *+4
.setanim
	move.w	d0,-(sp)
	bsr.w	setonetimeranim	;sets the one timer animation
	clr.w	$5A(a3)	;clear SPAnum
	jsr	(SetSPA).l
	bset	#5,$62(a3)	;lock animation
	bset	#1,$63(a3)	;set anim in progress
	move.w	(sp)+,d0
	movem.l	(sp)+,d0-d7/a0-a6
	bra.w	.ex
.checkxpos
	btst	#0,(onetimerflags).w	;check if shot initiated
	bne.w	.chkcarrier	;branch if set
	movem.w	d0-d1,-(sp)	;push to stack
	move.w	(puckx).w,d0	;move puckx to d0
	sub.w	(a3),d0	;sub Xpos from d0
	cmp.w	#$3C,d0	;'<'   ; compare diff to 3C (60 pixels)
	bgt.w	.chkxvel	;branch if greater than
	cmp.w	#$FFC4,d0	;compare to -60 pixels
	bgt.w	.chkypos	;branch if greater than
.chkxvel
	move.w	(puckvx).w,d1	;move puckvx into d1
	eor.w	d1,d0	;EOR d1 with d0
	bmi.w	.chkypos	;branch if minus
.notcoming
	movem.w	(sp)+,d0-d1	;pop from stack d0 and d1
	bra.w	.cancel
.chkypos
	move.w	(pucky).w,d0	;move pucky into d0
	sub.w	$14(a3),d0	;sub Ypos from d0
	cmp.w	#$3C,d0	;'<'   ; compare diff to 60 pix
	bgt.w	.chkyvel	;branch if greater than
	cmp.w	#$FFC4,d0	;check with -60 pix
	bgt.w	.coming	;branch if greater than
.chkyvel
	move.w	(puckvy).w,d1	;move puckvy into d0
	eor.w	d1,d0	;EOR d1 with d0
	bpl.s	.notcoming	;branch if positive
.coming
	movem.w	(sp)+,d0-d1	;pop d0 and d1 from stack
.chkcarrier
	tst.w	(puckc).w	;check if puck carrier
	bmi.w	.loose	;branch if no puck carrier
.cancel
	bclr	#7,(sflags8).w	;clear bit 7
	bra.w	.shoot
.loose
	btst	#0,(gmode).w	;check if game clock
	bne.w	.shoot	;branch if clock stopped
	movem.l	d0-d1,-(sp)	;push to stack
	cmpi.w	#$10,$5A(a3)	;compare 10 to SPAnum
	bge.w	.windup	;branch if greater than or equal
	btst	#2,(onetimerflags).w	;check bit 2
	bne.w	.windup	;branch if set
	move.w	(a3),d0	;move Xpos into d0
	move.w	(puckx).w,d1	;move puckx into d1
	sub.w	d1,d0	;sub d1 from d0
	bpl.w	.dy	;branch if positive
	neg.w	d0	;negate d0
.dy
	move.w	$14(a3),d1	;move Ypos into d1
	move.w	(pucky).w,d2	;move pucky into d2
	sub.w	d2,d1	;sub d2 from d1
	bpl.w	.vel	;branch if positive
	neg.w	d1	;negate d1
.vel
	move.w	(puckvx).w,d2	;move puckvx into d2
	beq.w	.usey	;branch if d2 is 0
	cmp.w	d0,d1	;compare d0 to d1
	ble.w	.frames	;branch if less than or equal
.usey
	move.w	(puckvy).w,d2
	move.w	d1,d0
.frames
	swap	d0
	andi.l	#$FFFF0000,d0
	tst.w	d2
	bpl.w	.speed
	neg.w	d2
.speed
	move.w	#$11,d1
	tst.w	(music_global_tick_counter).w
	beq.w	.chkzero
	move.w	#$16,d1
.chkzero
	tst.w	d2
	bne.w	.div
	move.w	#1,d2
.div
	divu.w	d2,d0
	andi.l	#$FFFF,d0
	divu.w	d1,d0
	move.w	$5A(a3),d2
	lsr.w	#2,d2
	subq.w	#6,d2
	neg.w	d2
	asl.w	#2,d2
	cmp.w	d2,d0
	bgt.w	.wait
	neg.w	$5A(a3)
	addi.w	#$18,$5A(a3)
	bra.w	.chkanim
.wait
	add.w	d7,(onetimerclock).w
	bra.w	.chkhold
.windup
	bset	#2,(onetimerflags).w
	btst	#1,(onetimerflags).w
	bne.w	.chkhold
	cmpi.w	#$18,$5A(a3)
	bne.w	.chkhold
	addi.w	#$30,$5C(a3)
	bset	#1,(onetimerflags).w
.chkhold
	btst	#1,(onetimerflags).w
	beq.w	.chkshot
	cmpi.w	#$18,$5A(a3)
	ble.w	.chkshot
	btst	#0,(onetimerflags).w
	bne.w	.chkshot
	movem.l	(sp)+,d0-d1
	bra.w	.shoot
.chkshot
	btst	#0,(onetimerflags).w
	beq.w	.chkanim
	cmpi.w	#$18,$5A(a3)
	bne.w	.chkanim
	cmpi.w	#1,$5C(a3)
	ble.w	.chkanim
	move.w	#1,$5C(a3)
.chkanim
	btst	#1,$63(a3)
	bne.w	.animon
	movem.l	(sp)+,d0-d1
	bra.w	.chkdone
.animon
	move.w	$5A(a3),d0
	movem.l	(sp)+,d0-d1
	btst	#0,(onetimerflags).w
	beq.w	.nop
	bclr	#5,$62(a3)
	bra.w	.chkdone
.nop
	nop
.chkdone
	btst	#1,$63(a3)
	bne.w	.ex
.shoot
	jsr	(EndOneTimer).l
.ex
	rts
setonetimeranim	;IDA name. 94 only: the one-timer animation: d1 = $7FC or $92E from the angle to the goal (vtoa, CheckOneTimerFacing)
	move.w	#$7FC,d1
	movem.w	d0-d1,-(sp)	;push to stack d0 and d1
	move.w	(a3),d0	;move XPos of a3 into d0
	neg.w	d0	;negate d0
	move.w	#$108,d1	;move top goal line into d1
	btst	#7,$62(a3)	;check which goal shooting at
	bne.w	.top	;branch if top
	neg.w	d1	;negate d1
.top
	sub.w	$14(a3),d1	;sub Ypos from d1
	jsr	(vtoa).l
	jsr	(CheckOneTimerFacing).l	;code doesnt save any changes
	movem.w	(sp)+,d0-d1	;pop from stack d0 and d1
	beq.w	.ex
	move.w	#$92E,d1
.ex
	rts
PuckOnAttackHalf	;94 only. d0 = 1 when the puck is on the half of the goal player a3 shoots at, else 0 (the code after the bra is never used). Called from doinput (logic94_1) and
	;logic94_4
	movem.w	d0-d1,-(sp)
	move.w	(pucky).w,d0
	btst	#7,$62(a3)	;pfgoal - check which goal shooting at
	bne.w	.cont	;branch if top goal
	neg.w	d0
.cont
	tst.w	d0	;check if d0 is 0
	bpl.w	.plus	;branch if higher
	bra.w	.0
	move.w	(passdir).w,d0	;code never used from here up to _0
	addq.w	#4,d0
	andi.w	#7,d0
	move.w	$54(a3),d1
	cmp.w	d0,d1
	bra.w	.plus
	beq.w	.plus
	addq.w	#1,d1
	andi.w	#7,d1
	cmp.w	d0,d1
	beq.w	.plus
	addq.w	#1,d1
	andi.w	#7,d1
	cmp.w	d0,d1
	beq.w	.plus
	subq.w	#3,d1
	andi.w	#7,d1
	cmp.w	d0,d1
	beq.w	.plus
	subq.w	#1,d1
	andi.w	#7,d1
	beq.w	.plus
.0
	move.w	#0,d0
	bra.w	.ex
.plus
	move.w	#1,d0
.ex
	movem.w	(sp)+,d0-d1
	rts
onetimershot	;IDA name (and comments). 94 only: do the one-timer shot (doshot), credit the last two passers as the assists, add to crowdlevel /
	;CwdExciteLvl and to the one-timer attempts ($35C of the team struct). Called from puckstick (hockey94_05)
	move.w	#4,(passdir).w
	jsr	(doshot).l
	movem.l	d0/a0,-(sp)
	movea.l	#HmShots,a0	;Home Stats
	btst	#6,$62(a3)	;check if home or away
	beq.w	.home	;branch if home
	lea	$364(a0),a0	;add if away
.home
	clr.w	d0
	move.b	$66(a3),d0	;player offset in roster
	move.w	$1A(a0),$1C(a0)	;move assist 1 player to assist 2
	move.w	$18(a0),$1A(a0)	;move last player to touch puck to assist 1
	move.w	d0,$18(a0)	;move d0 into player touching puck
	bset	#7,(sflags8).w	;set bit 7
	addi.w	#$96,(crowdlevel).w	;add to crowdlevel
	addi.w	#$A,(CwdExciteLvl).w	;add to Excite Level
	addq.w	#1,$35C(a0)	;add to one timer attempt
	movem.l	(sp)+,d0/a0
	bset	#0,(onetimerflags).w	;set bit 0
	bset	#1,$63(a3)	;set animation in progress
	bset	#1,(sflags6).w	;set bit 1
	rts
CheckOneTimerFacing	;94 only, called from setonetimeranim. IDA comment: it does nothing, d0 and d1 are restored at the end; it seems meant to
	;change the way the one-timer player faces
	movem.w	d0-d1,-(sp)	;push d0 and d1 on stack
	neg.w	d0	;negate d0
	addq.w	#8,d0	;add 8 to d0
	andi.w	#7,d0	;pass first 3 bits of d0
	move.w	$54(a3),d1	;move facedir into d1
	add.w	d0,d1	;add d0 to d1
	andi.w	#7,d1	;pass first 3 bits of d1
	cmp.w	#4,d1	;compare to 4
	bgt.w	.g0	;branch if greater than
	move.w	4(a3),d0	;move attribute into d0
	eori.w	#$FFFF,d0	;EOR FFFF with d0. Makes d0 opposite.
	andi.w	#$800,d0	;pass 12th bit of d0
	bra.w	.ex
.g0
	move.w	4(a3),d0	;move attribute into d0
	andi.w	#$800,d0	;pass 12th bit of d0
.ex
	movem.w	(sp)+,d0-d1	;pop from stack
	rts
Detect4WayPlay	;94 only: detect the 4 way play adaptor (EA 4 Way Play) on port 2: FourWayPlay = 1 when found. Called from Begin (hockey94_01)
	move.w	#0,(IO_Z80RES).l
	move.b	#$40,(IO_CT1_CTRL+1).l
	move.b	#$43,(IO_CT2_CTRL+1).l
	nop
	move.b	#$7C,(IO_CT2_DATA+1).l
	nop
	move.b	#$7F,(IO_CT2_CTRL+1).l
	nop
	move.b	#$7C,(IO_CT2_DATA+1).l
	nop
	move.b	(IO_CT1_DATA+1).l,d0
	andi.b	#3,d0
	cmp.b	#0,d0
	bne.s	.none
	move.w	#1,(FourWayPlay).w
	bra.s	.x
.none
	move.w	#0,(FourWayPlay).w
	move.b	#$40,(IO_CT2_CTRL+1).l
.x
	move.w	#$100,(IO_Z80RES).l
	rts
Read4WayPad1	;IDA dc.b, no xref. 94 only, unused: read 4 way play pad 1 (ReadJoy1 with the pad word swapped in)
	move.b	#0,(IO_CT2_DATA+1).l	;4 way play: select pad
	move.w	(pad4waysave1).w,(pad4wayword).w
	jsr	(ReadJoy1).l
	move.w	(pad4wayword).w,(pad4waysave1).w
	rts
Read4WayPad2	;IDA dc.b, no xref. 94 only, unused: the same for pad 2
	move.b	#$10,(IO_CT2_DATA+1).l	;4 way play: select pad
	move.w	(pad4waysave2).w,(pad4wayword).w
	jsr	(ReadJoy1).l
	move.w	(pad4wayword).w,(pad4waysave2).w
	rts
Read4WayPad3	;IDA dc.b, no xref. 94 only, unused: the same for pad 3
	move.b	#$20,(IO_CT2_DATA+1).l	;4 way play: select pad
	move.w	(pad4waysave3).w,(pad4wayword).w
	jsr	(ReadJoy1).l
	move.w	(pad4wayword).w,(pad4waysave3).w
	rts
Read4WayPad4	;IDA dc.b, no xref. 94 only, unused: the same for pad 4
	move.b	#$30,(IO_CT2_DATA+1).l	;4 way play: select pad
	move.w	(pad4waysave4).w,(pad4wayword).w
	jsr	(ReadJoy1).l
	move.w	(pad4wayword).w,(pad4waysave4).w
	rts
	rts	;IDA dc.b, no xref
Set4WayPlayerStub	;An empty Set4WayPlayer (just rts): forcepldata (hockey94_05) calls it with SCnum $F when a goalie is pulled
	rts
Set4WayPlayer	;IDA dc.b, no xref. 94 only, unused: put player a3's number ($52) in the home or away nibble of PadControlBits34 (unless PadControlBits is -1)
	cmpi.w	#$FFFF,(PadControlBits).w
	beq.w	.x
	movem.l	d0-d2,-(sp)
	move.w	#1,d0
	btst	#6,$62(a3)
	beq.w	.chkpad3
	move.w	#2,d0
.chkpad3
	cmp.w	(cont3team).w,d0
	beq.w	.pad3
	move.w	#$F,d1
	move.w	#4,d0
	bra.w	.set
.pad3
	move.w	#$F0,d1
	move.w	#0,d0
.set
	and.w	d1,(PadControlBits34).w
	move.w	$52(a3),d1
	asl.w	d0,d1
	or.w	d1,(PadControlBits34).w
	movem.l	(sp)+,d0-d2
.x
	rts
LoadCrowdRec	;IDA name. 94 only: CrowdRecord = the arena record of HomeTeam from save RAM (clrCrowdRAM into the buffer at ThreeStars), $50 when none. Called from StartGame (hockey94_01)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(HomeTeam).w,d1
	ext.l	d1
	movea.l	#ThreeStars,a0
	jsr	(clrCrowdRAM).l
	move.b	8(a0),d0
	beq.w	.none
	andi.w	#$FF,d0
	bra.w	.ex
.none
	move.w	#$50,d0
.ex
	move.w	d0,(CrowdRecord).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
Crowd_Noise	;IDA name (Crowd_Noise?). 94 only: the crowd meter each frame: crowd noise on / off (sflags5 bit 7) from CwdExciteLvl against
	;CrowdRecord / CrowdAvg, and every $14 ticks CurCrowdMeter (sqrt(level * 4) + 65 dB) and CrowdPeak. Called from setvideo (video94_1)
	btst	#7,(sflags).w	;screen is in horizontal mode
	bne.w	.ex1
	btst	#0,(gmode2).w
	bne.w	.ex1
	btst	#0,(sflags3).w	;check if game paused
	bne.w	.ex2
	btst	#7,(sflags5).w
	bne.w	.chkoff
	tst.w	(crowdnoisedelay).w
	beq.w	.chkon
	subq.w	#1,(crowdnoisedelay).w
	bpl.w	.ex1
	clr.w	(crowdnoisedelay).w
.ex2
	rts
.chkon
	move.w	(CrowdRecord).w,d0
	move.w	d0,(CrowdAvg).w
	subi.w	#$B,(CrowdAvg).w
	subi.w	#$49,d0
	muls.w	d0,d0
	asr.l	#2,d0
	addq.w	#6,d0
	cmp.w	(CwdExciteLvl).w,d0
	bgt.w	.ex1
	bset	#7,(sflags5).w
	rts
.chkoff
	move.w	(CrowdAvg).w,d0
	subi.w	#$41,d0
	muls.w	d0,d0
	asr.l	#2,d0
	cmp.w	(CwdExciteLvl).w,d0
	blt.w	.meter
	bclr	#7,(sflags5).w
.meter
	sub.w	d7,(CwdChkCntr).w
	bpl.w	.ex1
	move.w	#$14,(CwdChkCntr).w
	addq.w	#1,(CwdChkCnt).w
	move.w	(CwdExciteLvl).w,d0
	ext.l	d0
	asl.w	#2,d0
	jsr	(sroot).l
	addi.w	#$41,d0
	move.w	d0,(CurCrowdMeter).w
	cmp.w	(CrowdPeak).w,d0
	ble.w	.chkrec
	move.w	d0,(CrowdPeak).w
.chkrec
	move.w	(CurCrowdMeter).w,d0
	cmp.w	(CrowdRecord).w,d0
	blt.w	.stack
	bra.w	.stack	;IDA: *+4
.stack
	movem.l	d0-d7/a0-a6,-(sp)
	movem.l	(sp)+,d0-d7/a0-a6
.ex1
	rts
stopna2	;IDA name (92 / 93 name). Slow the velocity at $28 / $2A of a3 toward 0 by $7D0. Called from logic94_5 (goalieacc)
	tst.w	$28(a3)
	bpl.w	.xp
	addi.w	#$7D0,$28(a3)
	bmi.w	.y
	clr.w	$28(a3)
.xp
	subi.w	#$7D0,$28(a3)
	bpl.w	.y
	clr.w	$28(a3)
.y
	tst.w	$2A(a3)
	bpl.w	.yp
	addi.w	#$7D0,$2A(a3)
	bmi.w	.ex
	clr.w	$2A(a3)
.yp
	subi.w	#$7D0,$2A(a3)
	bpl.w	.ex
	clr.w	$2A(a3)
.ex
	rts
checkwallcoll	;IDA name (and comments; 92 name). IDA: ywall 210 = blue line to the end of the rink, corner radius 64. Corner circles and side walls
	;for object a3 at d2 / d3 (wcradiusx / wcradiusy); a hit goes to
	;wallcollb. Called from wallcollduringcheck (high94_2). 93 checkwallcoll is checkwallcoll2 (hockey94_04)
	bclr	#4,$64(a3)	;clears bit 4 in pflags3 (not used in 92)
	move.w	#$88,d4	;sideline
	sub.w	(wcradiusx).w,d4	;BD22 = wcradiusx
	move.w	#$12A,d5	;ywall
	sub.w	(wcradiusy).w,d5	;BD24 = wcradiusy
	movem.w	d2-d5,-(sp)
	neg.w	d4
	neg.w	d5
	addi.w	#$40,d4	;'@'   ; radius
	addi.w	#$40,d5
	cmp.w	d5,d3
	bgt.w	.ctc
	cmp.w	d4,d2
	blt.w	.circle
	neg.w	d4
	cmp.w	d4,d2
	bgt.w	.circle
	bra.w	.exit
.ctc
	neg.w	d5
	cmp.w	d5,d3
	blt.w	.exit
	cmp.w	d4,d2
	blt.w	.circle
	neg.w	d4
	cmp.w	d4,d2
	bgt.w	.circle
	bra.w	.exit
.circle
	sub.w	d4,d2
	sub.w	d5,d3
	move.w	d3,d0	;cos0 = dy/r
	move.w	d2,d1	;sin0 = -dx/r
	neg.w	d1
	muls.w	d3,d3
	muls.w	d2,d2
	add.l	d2,d3	;dist from dot
	cmp.l	#$1000,d3	;.radius^2 = $1000
	bls.w	.exit
	exg	d0,d3
	jsr	(sroot).l
	exg	d0,d3
	ext.l	d0
	asl.l	#8,d0
	divs.w	d3,d0
	ext.l	d1
	asl.l	#8,d1
	divs.w	d3,d1
	bsr.w	wallcollb
.exit
	movem.w	(sp)+,d2-d5
	move.w	$4E(a3),d0	;wallcos(a3)
	or.w	$50(a3),d0	;wallsin(a3)
	bne.w	.rtss3
	move.w	#$100,d0	;now check side walls
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
.rtss3	;IDA: rtss3 (a second IDA rtss3; the global one is logic94_1's). 93 checkwallcoll branches to the shared rtss here
	rts
wallcollb	;IDA name (92 name). Thunk: jmp wallcollb2 (hockey94_04)
	jmp	wallcollb2
Create_HotCold_Table	;IDA name (and comments). 94 only: fill the hot / cold table at $1A2 of team struct a0 with 416 random values (-9 ... 8,
	;randomd0s). Called from StartGame (hockey94_01) and ScoutingReport (hockey94_07)
	movem.l	d0-d7,-(sp)
	move.w	#$19F,d1	;$19F = 415. Loop will run 416 times.
	;(26 players/team * 8) * 2 teams = 416
HotColdLoop	;IDA name. The Create_HotCold_Table loop
	move.w	#9,d0	;sets RNG limit (-9 - +8)
	jsr	(randomd0s).l
	move.l	a0,-(sp)
	adda.l	#$1A2,a0	;offset to Hot/Cold table
	move.b	d0,0(a0,d1.w)
	movea.l	(sp)+,a0
	dbf	d1,HotColdLoop
	movem.l	(sp)+,d0-d7
	rts
Clamp0to100	;IDA dc.b, no xref. 94 only, unused: clamp d3 to 0 ... 100
	tst.w	d3
	bpl.w	.chkmax
	clr.w	d3
	rts
.chkmax
	cmp.w	#$64,d3
	ble.w	.x
	move.w	#$64,d3
.x
	rts
AttributeCalc	;IDA name (and comments). 94 only: attribute d3 of player a3 * 5 plus his hot / cold value / 3, limited to 0 ... $1E. Called from setplayer (hockey94_05)
	movem.l	d0-d2/a1,-(sp)
	move.w	(TempWord2).w,d1	;BF14 goes to d1
	movea.l	#HmShots,a1	;Start of Home Team struct
	btst	#6,$62(a3)	;Check if home or away
	beq.w	.attribmath
.away
	;shift to start of Away Team struct
	adda.l	#$364,a1
.attribmath
	clr.w	d1
	move.b	$66(a3),d1	;move roster offset into d1
	asl.w	#4,d1	;shifts d1 4 bits left, moving the values over 1 nibble
	adda.l	#$1A2,a1	;a1 points to Hot/Cold Table Start
	move.b	0(a1,d1.w),d1	;move data at add. (a1 + d1) into d1
	ext.w	d1	;sign-extend word. Ex: F5 (-5) -> FFF5
	ext.l	d1	;sign-extend long word. Ex: FFF5 -> FFFFFFF5
	divs.w	#3,d1	;Signed-Div D1 by 3 (FFFFFFF5 / 3, or -5 / 3 = -1r2, or FFFEFFFF
	;Remainder is 4 MS Nibbles, result is 4 LS Nibbles)
	move.w	d3,-(sp)	;push d3 onto stack
	asl.w	#2,d3	;shift left 2 bits (mult. by 4)
	add.w	(sp)+,d3	;Pop off d3 value and add to d3 (attrib X 5)
	add.w	d1,d3	;add d1 (H/C value) to d3
	bmi.w	.LowerLimit
.UpperLimitCheck
	;check if above upper limit (1E or 30 decimal)
	cmp.w	#$1E,d3
	blt.w	.MaskAttribMathResult
.UpperLimit
	;if above, set to 1E
	move.w	#$1E,d3
	bra.w	.MaskAttribMathResult
.LowerLimit
	clr.w	d3	;if below lower limit (0), set to 0
.MaskAttribMathResult
	andi.w	#$FF,d3	;pass only lower byte
	movem.l	(sp)+,d0-d2/a1
	rts
NextHomeHotPlayer	;94 only. d1 = the next home hot player (homehotidx index into the list at homehotplayer), a1 = HmShots. Called from ScoutTextPlayer (hockey94_06, the MATCHUPS text)
	movem.l	d0/a0,-(sp)
	movea.l	#homehotplayer,a0
	move.w	(homehotidx).w,d0
	add.w	d0,d0
	move.w	0(a0,d0.w),d1
	cmpi.w	#0,(homehotidx).w
	bge.w	.x
	addq.w	#1,(homehotidx).w
.x
	movem.l	(sp)+,d0/a0
	movea.l	#HmShots,a1
	rts
NextAwayHotPlayer	;94 only. The same for the away team (awayhotplayer, awayhotidx), a1 = AwShots. Called from ScoutTextPlayer
	movem.l	d0/a0,-(sp)
	movea.l	#awayhotplayer,a0
	move.w	(awayhotidx).w,d0
	add.w	d0,d0
	move.w	0(a0,d0.w),d1
	cmpi.w	#0,(awayhotidx).w
	bge.w	.x
	addq.w	#1,(awayhotidx).w
.x
	movem.l	(sp)+,d0/a0
	movea.l	#AwShots,a1
	rts
	rts	;IDA dc.b, no xref
BuildHotColdLists	;94 only. Build the hot / cold player lists of both teams (SortHotColdStarters, CopyHottestPlayer, CopyColdestPlayer). Called from ScoutingReport
	clr.w	(awayhotidx).w
	clr.w	(homehotidx).w
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#HmShots,a0
	bsr.w	SortHotColdStarters
	movea.l	#homehotplayer,a0
	bsr.w	CopyHottestPlayer
	movea.l	#homecoldplayer,a0
	bsr.w	CopyColdestPlayer
	movea.l	#AwShots,a0
	bsr.w	SortHotColdStarters
	movea.l	#awayhotplayer,a0
	bsr.w	CopyHottestPlayer
	movea.l	#awaycoldplayer,a0
	bsr.w	CopyColdestPlayer
	movem.l	(sp)+,d0-d7/a0-a6
	rts
SortHotColdStarters	;94 only. Sum the hot / cold values of the 6 starters of team a0 into TempBuffer (byte pairs: player, sum), then sort them by sum
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	a0,a2
	adda.l	#$1A2,a2
	movea.l	$1E(a0),a0
	adda.w	6(a0),a0
	movea.l	#TempBuffer,a1
	move.w	#5,d0
.player
	move.b	(a0)+,d1
	subq.b	#1,d1
	move.b	d1,(a1)+
	ext.w	d1
	asl.w	#4,d1
	clr.b	(a1)
	addq.w	#3,d1
	move.w	#3,d7
.attrib
	clr.w	d2
	move.b	0(a2,d1.w),d2
	cmp.b	#9,d7
	beq.w	.nextattr
	cmp.b	#$D,d7
	beq.w	.nextattr
	add.b	d2,(a1)
.nextattr
	addq.w	#1,d1
	addq.w	#1,d7
	cmp.b	#$10,d7
	bne.s	.attrib
	tst.b	(a1)+
	dbf	d0,.player
.sort
	movea.l	#TempBuffer,a1
	clr.w	d1
	move.w	#4,d0
.cmp
	move.b	3(a1),d6
	cmp.b	1(a1),d6
	ble.w	.next
	st	d1
	move.w	2(a1),d2
	move.w	(a1),2(a1)
	move.w	d2,(a1)
.next
	tst.w	(a1)+
	dbf	d0,.cmp
	tst.w	d1
	bne.s	.sort
	movem.l	(sp)+,d0-d7/a0-a6
	rts
NextHomeColdPlayer	;94 only. d1 = the next home cold player (homecoldidx, homecoldplayer), a1 = HmShots. Called from ScoutTextPlayer
	movem.l	d0/a0,-(sp)
	movea.l	#homecoldplayer,a0
	move.w	(homecoldidx).w,d0
	add.w	d0,d0
	move.w	0(a0,d0.w),d1
	cmpi.w	#0,(homecoldidx).w
	bge.w	.x
	addq.w	#1,(homecoldidx).w
.x
	movem.l	(sp)+,d0/a0
	movea.l	#HmShots,a1
	rts
NextAwayColdPlayer	;94 only. The same for the away team (awaycoldidx, awaycoldplayer), a1 = AwShots. Called from ScoutTextPlayer
	movem.l	d0/a0,-(sp)
	movea.l	#awaycoldplayer,a0
	move.w	(awaycoldidx).w,d0
	add.w	d0,d0
	move.w	0(a0,d0.w),d1
	cmpi.w	#0,(awaycoldidx).w
	bge.w	.x
	addq.w	#1,(awaycoldidx).w
.x
	movem.l	(sp)+,d0/a0
	movea.l	#AwShots,a1
	rts
	rts	;IDA dc.b, no xref
CopyHottestPlayer	;94 only. Copy the hottest player of TempBuffer to the list at a0
	movem.l	d0-d1/a0-a1,-(sp)
	movea.l	#TempBuffer,a1
	move.w	#0,d0
.copy
	clr.b	(a0)+
	move.b	(a1),d1
	move.b	d1,(a0)+
	tst.w	(a1)+
	dbf	d0,.copy
	movem.l	(sp)+,d0-d1/a0-a1
	rts
CopyColdestPlayer	;94 only. Copy the coldest player (TempBuffer+10) to the list at a0
	movem.l	d0/a0-a1,-(sp)
	movea.l	#TempBuffer+10,a1
	move.w	#0,d0
.copy
	clr.b	(a0)+
	move.b	(a1),(a0)+
	tst.w	-(a1)
	dbf	d0,.copy
	movem.l	(sp)+,d0/a0-a1
	rts
CompareHotColdTotals	;94 only. Compare the teams' hot / cold totals (GetHotColdTotal into TempWord1 / TempWord2): awayhotter = 1 when the away total is
	;higher; d0 = -1, $22 or $23 by the difference (ScoutingReport text "Lately ... has been playing (extremely) well")
	movem.l	d1-d7/a0-a6,-(sp)
	movea.l	#HmShots,a0
	bsr.w	GetHotColdTotal
	move.w	d1,(TempWord1).w
	movea.l	#AwShots,a0
	bsr.w	GetHotColdTotal
	move.w	d1,(TempWord2).w
	move.w	(TempWord1).w,d1
	move.w	(TempWord2).w,d2
	sub.w	d1,d2
	move.w	#0,(awayhotter).w
	tst.w	d2
	bmi.w	.abs
	move.w	#1,(awayhotter).w
.abs
	tst.w	d2
	bpl.w	.level
	neg.w	d2
.level
	move.w	#$FFFF,d0
	cmp.w	#$5E,d2
	blt.w	.x
	move.w	#$22,d0
	cmp.w	#$BD,d2
	blt.w	.x
	move.w	#$23,d0
.x
	movem.l	(sp)+,d1-d7/a0-a6
	rts
GetHotColdTotal	;94 only. d1 = the hot / cold total of the starters of team a0 (SortHotColdStarters)
	bsr.w	SortHotColdStarters
	move.w	#6,d0
	movea.l	#TempBuffer,a0
	clr.w	d1
.sum
	move.b	1(a0),d2
	ext.w	d2
	add.w	d2,d1
	tst.w	(a0)+
	dbf	d0,.sum
	rts
