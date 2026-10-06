;	NHL 94 (retail) segment $D09C-$E62D
;	92 Logic.Asm part 3, as 93 logic93_3.asm: asswingo, asscenterd, asscentero, the goalie (assgoaliectrl,
;	assgoaliecpu, ClampYPosition, AdjustFacingDirection, goaliesave), assgoalietopuck, the 94 breakaway code,
;	asspuckc, chkpk / chkpk2, chk4pass and EvadePC. checkob (logic94_4) follows at $E62E.
;	Transcribed from lst/nhl94.bin.lst lines 38682-40488. Global names are the IDA names except ClampYPosition
;	(IDA sub_DB3E) and AdjustFacingDirection (IDA sub_DB68), the 93 names. Local labels are the IDA local names
;	(_x -> .x) or the IDA address (loc_D430 -> .D430). IDA _checkanim is the global checkanim (used across a
;	global label).
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp /
;	cmpi; fixopcodes.js patches the cmp encoding after assembly.
;	SortCords offsets (93 names): Xpos 0, attribute 4, Ypos $14, Xvel $28, Yvel $2A, position $34, assnum $36,
;	temp1 $40, SCnum $52, facedir $54, SPA $58, nopuck $5E, pflags $62, pflags2 $63.

asswingo
	btst	#5,$62(a3)	;check if locked in animation
	bne.w	rtss21	;exit if so
	btst	#0,(gmode).w	;check game clock
	bne.w	assnothing	;assnothing if stopped
	bsr.w	check4bench	;check if player going to bench
	btst	#3,$62(a3)	;check if joystick controlled
	bne.w	rtss21	;exit if so
	bclr	#1,$62(a3)	;clear new assignment bit
	beq.w	.nna	;branch if it was already cleared
	st	$48(a3)	;set old zone # (temp5)
	clr.w	$40(a3)	;clear temp1
	move.w	#8,$42(a3)	;move 8 into temp2
.nna
	sub.b	d7,$40(a3)	;subtract frames elapsed from temp1
	bpl.w	.nodec	;branch if positive
	move.b	$6B(a3),$40(a3)	;move DfA into temp1
	btst	#6,(byte_FFC2FC).w	;check if crowd meter currently broken
	beq.w	.noboost
	tst.b	$40(a3)	;check if temp1 is 0
	beq.w	.noboost
	subq.b	#1,$40(a3)	;subtract 1 from temp1
.noboost
	move.l	#3,d0	;move asswingd into d0
	move.w	(puckc).w,d1	;move puckc SCnum into d1
	bmi.w	.de0	;branch if no puckc
	subq.w	#6,d1	;sub 6 from d1
	move.w	$52(a3),d2	;move SCnum into d2
	subq.w	#6,d2	;sub 6 from d2
	eor.w	d2,d1	;EOR d2 with d1. Checks if puckc on same team
	bmi.w	assreplace	;if not, branch to assreplace
.de0
	move.w	(pucky).w,d0	;pucky into d0
	move.w	(puckvy).w,d3	;puckvy into d3
	asr.w	#6,d3	;divide d3 by 64
	add.w	d0,d3	;add d0 to d3
	btst	#7,$62(a3)	;check which goal shooting on
	bne.w	.de1	;branch if top goal
	neg.w	d0	;negate d0
	neg.w	d3	;negate d3
.de1
	clr.w	d2	;clear zone number
	cmp.w	#$FFA8,d3	;compare bottom blue line with d3
	blt.w	.de2	;branch if in defensive zone
	addq.w	#8,d2	;add 8 to d2 (d2 = 8)
	cmp.w	#$58,d0	;'X'   ; compare top blue line with d0
	blt.w	.de2	;branch if in neutral zone
	btst	#4,$30(a2)	;check bit 4 of offset 30 (currently offside)
	;(C6FE Home, CA62 Away)
	bne.w	.de2	;branch if set
	addq.w	#8,d2	;add 8 to d2 (d2 = $10)
	cmp.w	#$108,d3	;compare top goal line with d3
	blt.w	.de2	;branch if in offensive zone
	addq.w	#8,d2	;add 8 to d2 (d2 = $18)
.de2
	cmp.w	$48(a3),d2	;compare temp5 with d2
	bne.w	.de3	;branch if different zone
	move.w	(VDP_CNTR).l,d0	;move frame counter into d0
	andi.w	#$7F,d0	;pass first 7 bits
	bne.w	.nodec	;branch if not equal to 0 - this allows random movement in zone while waiting
.de3
	move.w	d2,$48(a3)	;move d2 into temp5
	lea	.dedata(pc),a0	;move zonedata address into a0
	move.w	2(a0,d2.w),d0	;move X Coord into d0
	bsr.w	randomd0s	;RNG d0
	add.w	0(a0,d2.w),d0	;add X Coord offset to d0
	move.w	d0,$44(a3)	;move d0 into temp3
	move.w	6(a0,d2.w),d0	;move Y Coord into d0
	bsr.w	randomd0s	;RNG d0
	add.w	4(a0,d2.w),d0	;add Y Coord offset into d0
	move.w	d0,$46(a3)	;move d0 into temp4
	bra.w	.nodec
.dedata
	dc.w	$50	;Skating zones:
	;Defensive zone
	dc.w	$14
	dc.w	$FFBA
	dc.w	$A
	dc.w	$64	;neutral zone
	dc.w	$14
	dc.w	$3A
	dc.w	5
	dc.w	$3C	;offensive zone
	dc.w	$32
	dc.w	$E6
	dc.w	$14
	dc.w	$50	;past goalline
	dc.w	$1E
	dc.w	$FA
	dc.w	$14
.nodec
	move.w	$44(a3),d0	;move temp3 into d0
	cmpi.w	#5,$34(a3)	;compare 5 (RW) to position
	beq.w	.1	;branch if RW
	neg.w	d0	;negate d0
.1
	move.w	$46(a3),d1	;move temp4 into d1
	btst	#7,$62(a3)	;check if shooting up or down
	bne.w	.0	;branch if shooting up
	neg.w	d0	;negate d0
	neg.w	d1	;negate d1
.0
	lea	EvadePC(pc),a0	;add EvadePC as aux routine
	bra.w	skateto	;skate to d0/d1 position
rtss11
	rts
; player a3 is center on defense
; d7 = elapsed frames
asscenterd
	btst	#5,$62(a3)	;pfalock - locked animation
	bne.s	rtss11	;exit if locked
	btst	#0,(gmode).w	;gmclock - check if clock is running
	bne.w	assnothing	;exit if stoppage
	bsr.w	check4bench
	btst	#3,$62(a3)	;pfjoycon - check if joystick controlled
	bne.s	rtss11	;exit if joystick controlled
	bclr	#1,$62(a3)	;pfna - new assignment
	beq.w	.nna	;branch if no new assignment
	clr.w	$40(a3)	;clear temp1
	move.w	#8,$42(a3)	;move 8 into temp2
.nna
	sub.b	d7,$40(a3)	;subtract d7 from temp1
	bpl.w	.nodec
	move.b	$6B(a3),$40(a3)	;move aidef into temp1
	btst	#6,(byte_FFC2FC).w	;check for crowd record flag
	beq.w	.puckcarrier	;jump if not set
	tst.b	$40(a3)	;check if 0
	beq.w	.puckcarrier
	subq.b	#1,$40(a3)	;subtract 1 from temp1
.puckcarrier
	move.w	(puckc).w,d1	;move puck carrier SCnum into d1
	bmi.w	.nodec
	move.l	#6,d0	;asscentero
	subq.w	#6,d1	;subtract 6 from d1
	move.w	$52(a3),d2	;move player's SCnum into d2
	subq.w	#6,d2	;subtract 6 from d2
	eor.w	d2,d1	;compare d2 and d1
	bpl.w	assreplace	;if team has puck, replace assignment with acentero
.nodec
	move.w	(puckx).w,d0	;Xpos of puck
	asr.w	#1,d0	;divide by 2
	move.w	(pucky).w,d2	;Ypos of puck
	btst	#7,$62(a3)	;pfgoal - check which net to shoot on
	bne.w	.1	;branch if top net
	neg.w	d2	;negate d2 if shooting on bottom net
.1
	moveq	#$FFFFFF80,d1	;-128 - own high slot
	cmp.w	#$FFA8,d2	;-88 - own blue line
	blt.w	.chkgoal	;branch if puck in defensive zone
	add.w	(pucky).w,d1	;add pucky position to d1
	asr.w	#1,d1	;divide by 2
.chkgoal
	btst	#7,$62(a3)	;pfgoal - check which net to shoot at
	bne.w	.z1	;branch if top net
	neg.w	d1	;shooting at bottom net
.z1
	lea	rtss11(pc),a0	;no extra collision routine
	bra.w	skateto	;d0/d1 - x/y coord for skating to
; player a3 is center on offense
asscentero
	btst	#5,$62(a3)	;pfalock
	bne.w	rtss11	;exit if anim locked
	btst	#0,(gmode).w	;#gmclock
	bne.w	assnothing	;do nothing
	bsr.w	check4bench
	btst	#3,$62(a3)	;pfjoycon - check if joystick controlled
	bne.w	rtss11	;exit if controlled
	bclr	#1,$62(a3)	;clear pfna
	beq.w	.nna
	st	$48(a3)	;old zone number - temp5
	clr.w	$40(a3)	;clear temp1
	move.w	#8,$42(a3)	;move 8 into temp2
.nna
	sub.b	d7,$40(a3)	;subtract d7 from temp1 (d7 = elapsed frames)
	bpl.w	.nodec	;branch if temp1 not zero or neg
	move.b	$6B(a3),$40(a3)	;move aidef into temp1
	btst	#6,(byte_FFC2FC).w	;check if crowd record broken
	beq.w	.noboost
	tst.b	$40(a3)	;check if temp1 is 0
	beq.w	.noboost
	subq.b	#1,$40(a3)	;sub 1 from temp1
.noboost
	move.w	(puckc).w,d1	;move puck carrier SCnum into d1
	bmi.w	.de0
	move.l	#5,d0	;asscenterd
	subq.w	#6,d1
	move.w	$52(a3),d2	;move SCnum into d2
	subq.w	#6,d2
	eor.w	d2,d1	;checks to see if puck carrier is on team
	bmi.w	assreplace	;if not switch to acenterd
.de0
	move.w	(pucky).w,d0	;pucky in d0
	btst	#7,$62(a3)	;#pfgoal - check what goal shooting on
	bne.w	.de1	;branch if top
	neg.w	d0	;negate if bottom net
.de1
	clr.w	d2	;d2 = zone number
	cmp.w	#$FFA8,d0	;check if own blue line
	blt.w	.de2	;branch if in def zone
	addq.w	#8,d2	;set zone to 8
	cmp.w	#$58,d0	;'X'   ; check opponents blue line
	blt.w	.de2	;branch if in neutral zone
	btst	#4,$30(a2)	;Checks if currently offside
	;C6FE - Home
	;CA62 - Away
	bne.w	.de2	;branch if offside
	addq.w	#8,d2
	cmp.w	#$108,d0	;check opponents goal line
	blt.w	.de2	;branch if in offensive zone
	addq.w	#8,d2	;add if past goal line
.de2
	cmp.w	$48(a3),d2	;compare temp5 to d2
	bne.w	.de3
	move.w	(VDP_CNTR).l,d0	;move frame counter into d0.
	;This allows a chance for random movement in zone when waiting
	andi.w	#$7F,d0	;pass bottom 7 bits
	bne.w	.nodec
.de3
	move.w	d2,$48(a3)	;move zone into temp5
	lea	.dedata(pc),a0
	move.w	2(a0,d2.w),d0	;move zone into d0
	bsr.w	randomd0s	;randomize d0
	add.w	0(a0,d2.w),d0	;add to d0
	move.w	d0,$44(a3)	;move into temp3 (X coord)
	move.w	6(a0,d2.w),d0	;move into d0
	bsr.w	randomd0s	;randomize d0
	add.w	4(a0,d2.w),d0	;add into d0
	move.w	d0,$46(a3)	;move into temp4 (Y coord)
	bra.w	.nodec
.dedata
	dc.w	0	;Skating Zones
	;puck location = defensive zone
	dc.w	$3C
	dc.w	$FFBA
	dc.w	$A
	dc.w	0	;neutral zone
	dc.w	$3C
	dc.w	$3C
	dc.w	$A
	dc.w	0	;offensive zone
	dc.w	$28
	dc.w	$AA
	dc.w	$1E
	dc.w	0	;below offensive goal line
	dc.w	$50
	dc.w	$AA
	dc.w	$14
.nodec
	move.w	$44(a3),d0	;move temp3 into d0 (x coord to skate to)
	move.w	$46(a3),d1	;move temp4 into d1 (y coord to skate to)
	btst	#7,$62(a3)	;pfgoal
	bne.w	.0	;branch if top
	neg.w	d1	;negate if bottom
.0
	lea	EvadePC(pc),a0
	bra.w	skateto
; joypad controlled goalie control
; a3 = goalie
assgoaliectrl
	btst	#3,$62(a3)	;is player joystick controlled?
	bne.w	.goaliectrl	;branch is so
	bra.w	assexit
.goaliectrl
	btst	#1,$62(a3)	;check if new assignment
	bne.w	.na	;branch if new assignment
	movem.w	d0-d1,-(sp)	;push to stack
	move.w	(a3),d0	;Xpos
	move.w	$14(a3),d1	;Ypos
	cmp.w	#$AA,d1	;compare $AA to Ypos
	bgt.w	.cont
	cmp.w	#$FF56,d1	;check -$AA to Ypos
	blt.w	.cont	;branch if less than
	btst	#0,(gmode).w	;check if clock stopped
	bne.w	.cont	;branch if so
	move.w	d0,-(sp)	;push to stack
	move.w	#8,d0	;clock stoppage due to goalie out of range
	jsr	(AddPenalty2).l
	move.w	(sp)+,d0	;pop from stack
.cont
	sub.w	(Hpos).w,d0	;sub ice rink horiz position from Xpos
	sub.w	(Vpos).w,d1	;sub ice rink vert position from Ypos
	bclr	#2,$64(a3)	;clear goalie control bit?
	cmp.w	#$74,d0	;'t'   ; compare $74 to Xpos diff
	blt.w	.D430	;branch if less than
	bset	#2,$64(a3)	;set goalie control bit?
	bra.w	.cont2
.D430
	cmp.w	#$FF8C,d0	;compare -$74 to Xpos diff
	bgt.w	.D442	;branch if greater than
	bset	#2,$64(a3)	;set goalie control bit?
	bra.w	.cont2
.D442
	cmp.w	#$64,d1	;'d'   ; compare $64 to Ypos diff
	blt.w	.D454	;branch if less than
	bset	#2,$64(a3)	;set goalie control bit?
	bra.w	.cont2
.D454
	cmp.w	#$FF9C,d1	;compare -$64 to Ypos diff
	bgt.w	.cont2	;branch if greater than
	bset	#2,$64(a3)	;set goalie control bit?
.cont2
	movem.w	(sp)+,d0-d1	;pop from stack
	btst	#2,$64(a3)	;check goalie ctrl bit
	bne.w	checkanim	;branch if set
.na
	btst	#5,$62(a3)	;check if anim lock
	bne.w	rtss2	;exit if so
	bsr.w	check4bench
	bclr	#1,$62(a3)	;clear new assignment bit
	beq.w	.nna	;branch if already cleared
	clr.w	$40(a3)	;clear temp1
	move.w	#8,$42(a3)	;move 8 into temp2
	st	$46(a3)	;FFFF to temp4
.nna
	btst	#1,$63(a3)	;check if anim in progress
	bne.w	rtss2	;exit if so
	btst	#0,(gmode).w	;check if clock stopped
	bne.w	rtss2	;exit if so
	tst.w	$48(a3)	;test temp5
	bmi.w	.nofo	;branch if less than 0
	move.w	$52(a3),d0	;move SCnum into d0
	cmp.w	(puckc).w,d0	;check if puckc is goalie
	beq.w	.mbfo	;branch if equal
	st	$48(a3)	;set temp5 to -1
	bra.w	.nofo
.mbfo
	sub.w	d7,$48(a3)	;subtract d7(frames elapsed) from temp5
	bpl.w	.nofo	;branch if more than 0
	btst	#2,(BA_PS_flags).w	;check bit 2
	beq.w	.stoppage	;branch if not set
	bset	#4,(BA_PS_flags).w
	bra.w	.nofo
.stoppage
	move.l	#8,d0
	bsr.w	AddPenalty2
.nofo
	sub.b	d7,$40(a3)	;sub d7(frames elapsed) from temp1
	bpl.w	.ex	;branch if positive
	move.b	$6B(a3),d0	;DfA into d0
	beq.w	.D508	;branch if value was 0
	btst	#6,(byte_FFC2FC).w	;check if crowd meter broken
	beq.w	.D508	;jump if not
	subq.b	#1,d0	;sub 1 from d0
.D508
	lsr.b	#2,d0	;divide by 4
	move.b	d0,$40(a3)	;move d0 into temp1
	move.w	$52(a3),d0	;move SCnum into d0
	cmp.w	(puckc).w,d0	;compare puckc to d0
	beq.w	*+4	;jump to assgoaliecpu if the same
.ex
	rts
; a3 = goalie
assgoaliecpu
	btst	#3,$62(a3)	;is goalie joystick controlled?
	bne.w	assgoaliectrl	;branch if so
checkanim	;IDA: _checkanim, a local of assgoaliecpu. Global here: assgoaliectrl branches to it
	move.w	(puckx).w,(TmpPuckX).w
	btst	#0,(word_FFC2F4).w	;test bit 0
	beq.w	.assstart
	btst	#1,$63(a3)	;check if animation in progress
	bne.w	.assstart	;branch if so
	btst	#1,(word_FFC2F4).w	;test bit 1
	beq.w	.D57A	;branch if 0
	btst	#3,(word_FFC2F4).w	;test bit 3
	bne.w	.assstart	;branch if set
	cmpi.w	#$2C4,6(a3)	;compare to alice frame number
	bne.w	.assstart	;branch if not equal
	cmpi.w	#$2C8,6(a3)	;compare to alice frame number
	bne.w	.assstart	;branch if not equal
	bset	#3,(word_FFC2F4).w	;set bit 3
	move.w	#$1C,-(sp)	;SFX
	bsr.w	sfx
	bra.w	.assstart	;set bit 3
.D57A
	movem.w	d0-d1,-(sp)
	move.w	(pucky).w,d0	;pucky to d0
	move.w	$14(a3),d1	;move Ypos to d1
	eor.w	d1,d0	;XOR d1 to d0
	movem.w	(sp)+,d0-d1
	bmi.w	.assstart	;branch if d0 is negative
	cmpi.w	#$14,(a3)	;compare 14 to Xpos
	bgt.w	.assstart	;branch if greater
	cmpi.w	#$FFEC,(a3)	;compare -14 to Xpos
	ble.w	.assstart	;branch if less than
	bset	#1,(word_FFC2F4).w	;set bit 1
	bclr	#3,(word_FFC2F4).w	;clear bit 3
	move.w	#$1596,d1	;move 1596 into d1
	btst	#7,$62(a3)	;check what goal shooting at
	beq.w	.D5BE	;branch if bottom
	move.w	#$1684,d1	;move 1684 into d1
.D5BE
	bsr.w	SetSPA	;set animation of d1
	bset	#1,$63(a3)	;set anim in progress
.assstart
	btst	#5,$62(a3)	;check if locked in animation
	bne.w	rtss2	;exit if so
	bsr.w	check4bench
	bclr	#1,$62(a3)	;clear new assignment
	beq.w	.nna	;jump if it was cleared already
	clr.w	$40(a3)	;clear temp1
	move.w	#8,$42(a3)	;move 8 into temp2
	st	$46(a3)	;set temp5 (FFFF)
.nna
	cmpi.w	#$34,(a3)	;'4' ; compare 34 hex with Xpos
	bgt.w	.nna2	;branch if greater
	cmpi.w	#$FFCC,(a3)	;compare -34 hex with Xpos
	blt.w	.nna2	;branch if less than
	cmpi.w	#$10E,$14(a3)	;compare 10E with Ypos
	bgt.w	.nna2
	cmpi.w	#$FEF2,$14(a3)
	blt.w	.nna2
	cmpi.w	#$D2,$14(a3)
	bgt.w	.noskate
	cmpi.w	#$FF2E,$14(a3)
	blt.w	.noskate
.nna2
	lea	rtss2(pc),a0	;goalie will skate back to middle position
	moveq	#4,d0
	tst.w	(a3)	;test Xpos
	bpl.w	.D634	;branch if positive
	neg.w	d0
.D634
	move.w	#$E4,d1
	btst	#7,$62(a3)	;check what goal shooting at
	beq.w	skateto	;branch if bottom
	neg.w	d1
	bra.w	skateto
.noskate
	btst	#1,$63(a3)	;check if anim in progress
	bne.w	rtss2	;exit if so
	btst	#0,(word_FFC2F4).w	;check bit 0
	beq.w	.noskate3	;branch if not set
	cmpi.w	#$2C5,6(a3)	;check alice frame
	beq.w	.noskate2	;branch if equal
	cmpi.w	#$2C9,6(a3)	;check alice frame
	bne.w	.noskate3	;branch if not equal
	move.w	#4,$54(a3)	;set 4 to facedir - face down
	bra.w	.noskate3
.noskate2
	move.w	#0,$54(a3)	;set 0 to facedir - face up
.noskate3
	move.w	#2,d1	;2 = SPAgready
	bsr.w	SetSPA
	btst	#2,(BA_PS_flags).w	;check bit 2
	bne.w	.noskate4	;branch if set
	btst	#0,(gmode).w	;check if clock
	bne.w	rtss2	;exit if clock stopped
.noskate4
	tst.w	$48(a3)	;temp5
	bmi.w	.nofo	;branch if minus
	move.w	$52(a3),d0	;move SCnum to d0
	cmp.w	(puckc).w,d0	;check if puckc
	beq.w	.mbfo	;branch if so
	st	$48(a3)	;set temp5 to FFFF
	bra.w	.nofo
.mbfo
	sub.w	d7,$48(a3)	;subtract frames from temp5
	bpl.w	.nofo	;branch if positive
	btst	#2,(BA_PS_flags).w	;check if bit 2 set
	beq.w	.mbfo2	;branch if not
	bset	#4,(BA_PS_flags).w	;set bit 4
	bra.w	.nofo
.mbfo2
	move.l	#8,d0	;PenGhold
	bsr.w	AddPenalty2	;blow whistle for FO
.nofo
	sub.b	d7,$40(a3)	;sub d7 from temp1
	bpl.w	.nodec	;branch if still positive
	move.b	$6B(a3),d0	;move aidef into d0 (DfA)
	beq.w	.nofo2	;branch if 0
	btst	#6,(byte_FFC2FC).w	;check if crowd meter broken
	beq.w	.nofo2	;branch if not
	subq.b	#1,d0	;sub from d0
.nofo2
	lsr.b	#2,d0	;divide by 4
	move.b	d0,$40(a3)	;move d0 into temp1
	btst	#3,$62(a3)	;check if joy controlled
	beq.w	.nocontrol	;branch if not
	btst	#2,$64(a3)	;check bit 2
	bne.w	.nocontrol	;branch if set
	move.l	#$1D,d0	;assignment assgoaliectrl
	bra.w	assinsert
.nocontrol
	move.w	(pucky).w,d0	;move pucky into d0
	move.w	$14(a3),d1	;move Ypos into d1
	eor.w	d0,d1	;XOR
	bpl.w	.D742	;branch if positive
	clr.w	d0
	move.w	#$F4,d2	;move F4 into d2
	btst	#7,$62(a3)	;check which net shooting at
	beq.w	.de5	;branch if bottom
	neg.w	d2
	bra.w	.de5
.D742
	subq.w	#1,$46(a3)	;sub 1 from temp4
	bpl.w	.D750	;branch if positive
	move.w	#$FFFF,$46(a3)	;move -1 into temp4
.D750
	move.w	$52(a3),d0	;SCnum into d0
	cmp.w	(puckc).w,d0	;check if puckc
	bne.w	.notpuckc	;branch if not
	tst.w	$48(a3)	;check temp5
	bpl.w	.D76A	;branch if positive
	move.w	#$5A,$48(a3)	;'Z' ; move 5A into temp5
.D76A
	st	$46(a3)	;FFFF into temp4
	cmpi.w	#$5A,$48(a3)	;'Z' ; compare to temp5
	bgt.w	.de1	;branch if greater
	move.w	(VDP_CNTR).l,d0
	andi.w	#3,d0	;pass first 2 bits
	bne.w	.de1	;branch if not 0
	moveq	#5,d0
	movea.w	#(SortCords-M68K_RAM),a0
	btst	#6,$62(a3)	;check home or away
	bne.w	.opploop	;branch if away
	adda.w	#$300,a0
.opploop
	btst	#2,$63(a0)	;check if player unavailable
	bne.w	.opploop2	;branch if so
	move.w	(pucky).w,d1	;pucky into d1
	sub.w	$14(a0),d1	;sub Ypos a0 from d1
	cmp.w	#$1C,d1	;compare 1C to difference
	bgt.w	.opploop2	;branch if greater
	cmp.w	#$FFE4,d1	;compare -1C
	blt.w	.opploop2	;branch if less than
	move.w	(puckx).w,d1	;puckx into d1
	sub.w	(a0),d1	;sub Xpos a0 from d1
	cmp.w	#$19,d1	;compare 19 to difference
	bgt.w	.opploop2	;branch if greater
	cmp.w	#$FFE7,d1	;compare -19 to diff
	bgt.w	.de1	;branch if greater
.opploop2
	adda.w	#$80,a0	;move to next struct
	dbf	d0,.opploop
	move.w	#1,(threat).w	;dir of threat on puck handler
	bsr.w	chk4pass
	bra.w	.de1
.notpuckc
	tst.w	$46(a3)	;check temp4
	bne.w	.de1	;branch if not 0
	tst.w	(puckc).w	;check puckc
	bpl.w	.de1	;branch if there is a puckc
	move.w	(puckx).w,d0
	sub.w	(a3),d0	;sub Xpos
	cmp.w	#$14,d0	;compare 14 to diff
	bgt.w	.de1	;branch if greater
	cmp.w	#$FFEC,d0	;-14
	blt.w	.de1	;branch if less
	move.w	(pucky).w,d1
	cmp.w	#$108,d1	;check goalline
	bgt.w	.de1	;branch if past goalline
	cmp.w	#$FEF8,d1	;check other goalline
	blt.w	.de1	;branch if past
	sub.w	$14(a3),d1	;sub Ypos from d1
	cmp.w	#$1E,d1	;compare to 1E
	bgt.w	.de1	;branch if greater
	cmp.w	#$FFE2,d1	;compare to -1E
	blt.w	.de1	;branch if less
	movem.w	d0-d1,-(sp)
	move.w	(puckvx).w,d0
	bpl.w	.D844
	neg.w	d0
.D844
	move.w	(puckvy).w,d1
	bpl.w	.D84E
	neg.w	d1
.D84E
	add.w	d1,d0	;add puckvx and vy
	cmp.w	#$1000,d0	;compare to 1000
	movem.w	(sp)+,d0-d1
	bgt.w	.de1	;branch if greater
	bsr.w	vtoa
	move.w	d0,$54(a3)	;d0 into facedir. Goalie will face puck
	move.b	#8,$5E(a3)	;move 8 to nopuck collision
	move.w	#$2F4,d1	;goalie dive anim.
	bsr.w	SetSPA	;set animation
	bset	#1,$63(a3)	;set anim in progress
	addi.w	#$96,(crowdlevel).w
	rts
.de1
	movea.w	#(puckcross-M68K_RAM),a0	;puckcross = xcord/frames top to bottom for goalies to react to
	move.w	#$104,d3
	btst	#7,$62(a3)	;check what net shooting at
	beq.w	.D896	;branch if bottom
	addq.w	#4,a0
	neg.w	d3
.D896
	cmpi.w	#$104,$14(a3)
	bgt.w	.D8AA
	cmpi.w	#$FEFC,$14(a3)
	bgt.w	.D8CE
.D8AA
	clr.w	d2
	clr.w	d0
	cmpi.w	#$2C,(a3)
	bgt.w	.de5
	cmpi.w	#$FFD4,(a3)
	blt.w	.de5
	move.w	#$88,d0
	tst.w	(a3)
	bpl.w	.de5
	neg.w	d0
	bra.w	.de5
.D8CE
	tst.w	(puckc).w
	bmi.w	.D902
	move.w	$52(a3),d0
	cmp.w	(puckc).w,d0
	beq.w	.D902
	move.l	a0,-(sp)
	movea.l	#$FFFFB04A,a0
	move.w	(puckc).w,d0
	asl.w	#7,d0
	adda.w	d0,a0
	move.w	(puckx).w,d0
	sub.w	(a0),d0
	asr.w	#1,d0
	add.w	(a0),d0
	move.w	d0,(TmpPuckX).w
	movea.l	(sp)+,a0
.D902
	move.w	(TmpPuckX).w,d0
	move.w	(pucky).w,d1
	bsr.w	ClampYPosition
	bsr.w	vtoa
	bsr.w	AdjustFacingDirection
	move.w	(gameclock).w,d0
	andi.w	#7,d0
	asl.w	#4,d0
	addi.w	#$A0,d0
	cmpi.w	#$DB,(pucky).w
	bgt.w	.D938
	cmpi.w	#$FF25,(pucky).w
	bgt.w	.D93C
.D938
	subi.w	#$40,d0
.D93C
	move.w	d0,d1
	muls.w	(puckvx).w,d0
	swap	d0
	add.w	(TmpPuckX).w,d0
	muls.w	(puckvy).w,d1
	swap	d1
	add.w	(pucky).w,d1
	bsr.w	ClampYPosition
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	cmp.l	#$384,d0
	bhi.w	.D972
	movem.w	(sp)+,d0-d1
	bra.w	.D996
.D972
	bsr.w	sroot
	moveq	#1,d2
	add.w	d0,d2
	moveq	#$12,d4
	btst	#3,(sflags).w
	beq.w	.D988
	addq.w	#8,d4
.D988
	movem.w	(sp)+,d0-d1
	muls.w	d4,d1
	addq.w	#8,d4
	muls.w	d4,d0
	divs.w	d2,d0
	divs.w	d2,d1
.D996
	add.w	d3,d1
	move.w	d1,d2
	btst	#0,(word_FFC2FA).w
	bne.w	.D9EE
	btst	#2,(BA_PS_flags).w
	bne.w	.D9EE
	btst	#3,(sflags).w
	beq.w	.D9EE
	cmpi.w	#$D0,(pucky).w
	bgt.w	.D9D0
	cmpi.w	#$FF30,(pucky).w
	blt.w	.D9D0
	bra.w	.D9EE
.D9D0
	cmpi.w	#$14,(a3)
	bgt.w	.D9EE
	cmpi.w	#$FFEC,(a3)
	blt.w	.D9EE
	btst	#1,(gameclock+1).w
	bne.w	.D9EE
	bra.w	.DA12
.D9EE
	cmpi.w	#$22,2(a0)
	bhi.w	.de5
	cmpi.w	#$18,(a0)
	bgt.w	.DAB6
	cmpi.w	#$FFE8,(a0)
	blt.w	.DAB6
	cmpi.w	#$C,2(a0)
	bhi.w	.DA36
.DA12
	cmpi.w	#$108,(pucky).w
	bgt.w	.DA36
	cmpi.w	#$FEF8,(pucky).w
	blt.w	.DA36
	bset	#1,$63(a3)
	bne.w	.DA36
	jsr	(goaliesave).l
.DA36
	move.w	(a0),d0
	cmpi.w	#$FC,(pucky).w
	bgt.w	.DA4C
	cmpi.w	#$FF04,(pucky).w
	bgt.w	.de5
.DA4C
	moveq	#$18,d0
	tst.w	(TmpPuckX).w
	bpl.w	.de5
	neg.w	d0
.de5
	move.w	d2,d1
	movem.w	d0-d1,-(sp)
	move.b	$28(a3),d0
	ext.w	d0
	neg.w	d0
	add.w	(sp)+,d0
	sub.w	(a3),d0
	move.b	$2A(a3),d1
	ext.w	d1
	neg.w	d1
	add.w	(sp)+,d1
	sub.w	$14(a3),d1
	cmp.w	#4,d0
	bgt.w	.vt
	cmp.w	#$FFFC,d0
	blt.w	.vt
	cmp.w	#4,d1
	bgt.w	.vt
	cmp.w	#$FFFC,d1
	blt.w	.vt
	clr.w	d0
	clr.w	d1
.vt
	bsr.w	vtoa
	move.b	d0,$43(a3)	;move d0 into temp2+1
.nodec
	move.b	$43(a3),d2	;temp2+1
	ext.w	d2
	cmp.w	#7,d2
	ble.w	playeracc
	bra.w	stopna
.DAB6
	tst.w	(puckc).w
	bpl.s	.de5
	btst	#2,(iflags).w
	bne.s	.de5
	movea.w	#(HmShots-M68K_RAM),a1
	lea	$364(a1),a2
	btst	#6,$62(a3)
	beq.w	.DAD8
	exg	a1,a2
.DAD8
	cmpi.l	#$1324,$2A(a1)
	blt.w	.de5
	cmpi.l	#$9C4,$2A(a2)
	blt.w	.de5
	cmpi.w	#$E0,(pucky).w
	bgt.w	.DB04
	cmpi.w	#$FF20,(pucky).w
	bgt.w	.de5
.DB04
	tst.w	(puckvy).w
	btst	#7,$62(a3)
	beq.w	.DB16
	eori	#8,ccr
.DB16
	bmi.w	.de5
	move.w	(puckvx).w,d0
	bpl.w	.DB24
	neg.w	d0
.DB24
	move.w	(puckvy).w,d1
	bpl.w	.DB2E
	neg.w	d1
.DB2E
	cmp.w	d0,d1
	blt.w	.de5
	move.l	#$F,d0	;assignment DD2E?
	bra.w	assinsert
ClampYPosition	;IDA: sub_DB3E (93 name). d1 = y clamped to +-$103, minus goal line d3. d0 = 0 if a3 has the puck
	move.w	(puckc).w,d2
	cmp.w	$52(a3),d2
	bne.w	.DB4C
	clr.w	d0
.DB4C
	cmp.w	#$103,d1
	blt.w	.DB58
	move.w	#$103,d1
.DB58
	cmp.w	#$FEFD,d1
	bgt.w	.DB64
	move.w	#$FEFD,d1
.DB64
	sub.w	d3,d1
	rts
AdjustFacingDirection	;IDA: sub_DB68 (93 name). Turn facedir one step toward direction d0. IDA cannot show
	;btst Dn,#imm, so it lost the three btst lines and the .t / .set targets; written from the retail bytes as 93
	move.w	$54(a3),d1		;facedir
	sub.w	d1,d0
	beq.w	rtss2
	neg.w	d0
	andi.w	#4,d0
	lsr.w	#1,d0
	subq.w	#1,d0			;d0 = +1/-1
	btst	#3,$62(a3)		;pfjoycon
	bne.w	.DBAE
	btst	d1,#$42			;facing 1 or 6
	beq.w	.DBAE
	add.w	d0,d1
	btst	#7,$62(a3)		;pfgoal
	bne.w	.DBA2
	btst	d1,#$83			;0, 1 or 7
	bra.w	.t
.DBA2	btst	d1,#$38			;3, 4 or 5
.t	beq.w	.set			;$DBA6, no IDA label
	neg.w	d0
	add.w	d0,d1
.DBAE	add.w	d0,d1
.set	andi.w	#7,d1			;$DBB0, no IDA label
	move.w	d1,$54(a3)		;facedir
	rts
; set save animation for goalie depending on puck location
; a3 = goalie
; a0 = puckcross
; d3 = goalline of goalie
goaliesave
	move.w	(a0),d0	;puckcross x frames into d0
	sub.w	(a3),d0	;sub goalie Xpos from d0
	move.w	d3,d1	;move goalline into d1
	sub.w	$14(a3),d1	;sub goalie Ypos from d1
	bsr.w	vtoa
	sub.w	$54(a3),d0	;sub facedir from d0
	andi.w	#7,d0	;pass first 3 bits of d0
	move.w	d0,d3	;move d0 into d3
	lsr.w	#2,d0	;divide d0 by 4
	btst	#3,4(a3)
	beq.w	.DBE2
	eori.w	#1,d0
.DBE2
	cmpi.w	#8,(puckz).w
	bgt.w	.DBFA
	cmpi.w	#$800,(puckvz).w
	bgt.w	.DBFA
	bra.w	.DC24
.DBFA
	movem.l	d0,-(sp)
	move.w	(a3),d0
	sub.w	(a0),d0
	cmp.w	#$10,d0
	bgt.w	.DC1C
	cmp.w	#$FFF0,d0
	blt.w	.DC1C
	movem.l	(sp)+,d0
	addq.w	#6,d0
	bra.w	.DCD0
.DC1C
	movem.l	(sp)+,d0
	bra.w	.DCD0
.DC24
	addq.w	#4,d0
	cmpi.w	#8,2(a0)
	bls.w	.DCAA
	cmpi.w	#2,$54(a3)
	beq.w	.DCD0
	cmpi.w	#6,$54(a3)
	beq.w	.DCD0
	tst.w	(puckc).w
	bmi.w	.DCD0
	subq.w	#2,d0
	move.w	d1,-(sp)
	move.w	#$1000,d1
	move.w	d1,$28(a3)
	ori.w	#1,d0
	btst	#7,$62(a3)
	bne.w	.DC6A
	eori.w	#1,d0
.DC6A
	move.w	#$FFFA,d1
	tst.w	$28(a3)
	bmi.w	.DC7A
	neg.w	$28(a3)
.DC7A
	tst.w	(a3)
	bpl.w	.DC94
	tst.w	$28(a3)
	bpl.w	.DC8C
	neg.w	$28(a3)
.DC8C
	move.w	#6,d1
	eori.w	#1,d0
.DC94
	add.w	d1,(a3)
	btst	#0,$76(a3)	;check hand of goalie
	beq.w	.DCA4	;Branch if goalie is Full Right
	eori.w	#1,d0
.DCA4
	move.w	(sp)+,d1
	bra.w	.DCD0
.DCAA
	movem.l	d0,-(sp)
	move.w	(a3),d0
	sub.w	(a0),d0
	cmp.w	#$10,d0
	ble.w	.DCC2
	movem.l	(sp)+,d0
	bra.w	.DCCE
.DCC2
	cmp.w	#$FFF0,d0
	movem.l	(sp)+,d0
	bgt.w	.DCD0
.DCCE
	addq.w	#4,d0
.DCD0
	add.w	d0,d0
	lea	.saveanim(pc),a1
	move.w	0(a1,d0.w),d1
	cmp.w	#$178,d1
	bne.w	.DCF8
	andi.w	#3,d3
	beq.w	.DCF8
	cmpi.b	#$B,$73(a3)	;73 = Glove Left. Compares 11 dec to GloveL
	blt.w	.DCF8	;branch if less than
	move.w	#$1AA,d1	;reach out glove save
.DCF8
	bsr.w	SetSPA
	addi.w	#$96,(crowdlevel).w
	addi.w	#$A,(CwdExciteLvl).w
	asr.w	$28(a3)
	asr.w	$28(a3)
	asr.w	$2A(a3)
	asr.w	$2A(a3)
	rts
.saveanim	;IDA: _saveanim (93 GoalieSaveList): SPA per save type. Same 10 words as the unreferenced table at $B602
	;(logic94_1)
	dc.w	$146
	;blocker save
	dc.w	$178	;glove save
	dc.w	$250	;pad stack right
	dc.w	$2A2	;pad stack left
	dc.w	$1EC	;kick save
	dc.w	$21E	;blocking butterfly save
	dc.w	$148E	;high shoulder save right
	dc.w	$14C0	;high shoulder save left
	dc.w	$14F2
	dc.w	$1544	;stick save left
; assignment to have goalie skate to the puck when it is loose
assgoalietopuck
	btst	#3,$62(a3)
	bne.w	assexit
	btst	#0,(gmode).w
	bne.w	assexit
	bsr.w	check4bench
	bclr	#1,$62(a3)
	beq.w	.DD54
	clr.w	$40(a3)
.DD54
	sub.b	d7,$40(a3)
	bpl.w	.DDC0
	move.b	$6B(a3),d0	;aidef
	beq.w	.DD70
	btst	#6,(byte_FFC2FC).w
	beq.w	.DD70
	subq.b	#1,d0
.DD70
	lsr.b	#2,d0
	move.b	d0,$40(a3)
	tst.w	(puckc).w
	bpl.w	assexit
	tst.w	(puckvy).w
	btst	#7,$62(a3)
	beq.w	.DD90
	eori	#8,ccr
.DD90
	bmi.w	assexit
	movea.w	#(HmShots-M68K_RAM),a1	;load home team struct into a1
	lea	$364(a1),a2	;load away team struct into a2
	btst	#6,$62(a3)	;check if player is home or away
	beq.w	.DDA8	;branch if home
	exg	a1,a2	;swap if away
.DDA8
	cmpi.l	#$E10,$2A(a1)
	blt.w	assexit
	cmpi.l	#$640,$2A(a2)
	blt.w	assexit
.DDC0
	bra.w	skatetopuck
breakaway
	bset	#2,(word_FFC2F6).w
	bclr	#1,$62(a3)	;pfna - clear new assignment
	beq.w	.nna	;jump if no new assignment
	move.w	#1,-(sp)	;ding SFX
	jsr	(sfx).l
	movem.l	a2,-(sp)	;push a2 on stack
	movea.l	#$FFFFC6CE,a2	;move Home Team Struct into a2
	btst	#6,$62(a3)	;pfteam - check if home or away
	beq.w	.c0	;jump if home
	movea.l	#$FFFFCA32,a2	;move Away Team Struct into a2
.c0
	addq.w	#1,$358(a2)	;add one to breakaway attempt
	addi.w	#$14,(CwdExciteLvl).w	;add to CwdExcite
	addi.w	#$C8,(crowdlevel).w	;add to crowdlevel
	movem.l	(sp)+,a2
.nna
	movem.w	d1,-(sp)	;push d1 on stack
	move.w	$14(a3),d0	;move Ypos into d0
	move.w	$2A(a3),d1	;move Yvel into d1
	beq.w	.yvel0	;jump if Yvel = 0
	eor.w	d1,d0	;EOR d1 with d0. d0 will be negative if skating opposite direction of net
.exit
	movem.w	(sp)+,d1	;pop d1 off stack
	rts
.yvel0
	move.w	#$FFFF,d1
	bra.s	.exit
BreakawayOffsidesFlagSet
	btst	#1,$62(a3)	;check for new assignment
	beq.w	.loadYpos	;branch if no new assignment
	bclr	#0,$64(a3)	;clear player offsides flag
	bclr	#1,$64(a3)	;clear player breakaway flag
.loadYpos
	movem.w	d0-d1/a0,-(sp)
	move.w	#$108,d0	;108 = top goal line Y pos
	move.w	$14(a3),d1	;Ypos
	bpl.w	.cmpgoalline	;branch if Ypos is positive
	neg.w	d1	;negate d1
.cmpgoalline
	cmp.w	d0,d1	;compare position to top goal line
	bge.w	.nogood	;Branch if above it
	move.w	#$58,d0	;'X'   ; 58 = top blue line Y pos
	move.w	$14(a3),d1	;Ypos
	btst	#7,$62(a3)	;check goal to shoot on (0=bottom, 1=top)
	bne.w	.top	;branch if top goal
	neg.w	d0	;bottom goal, so negate d0
	cmp.w	d1,d0	;compare Ypos to blue line Y
	blt.w	.setoffside	;branch if not in attack zone
	bra.w	.offzone	;branch if in attack zone
.top
	cmp.w	d1,d0	;compare Ypos to blue line Y
	blt.w	.offzone	;branch if in offensive zone
.setoffside
	bset	#0,$64(a3)	;set offsides flag
	bra.w	.nogood
.offzone
	bclr	#0,$64(a3)	;clear offside bit
	beq.w	.nogood	;branch if on the blue line
	movea.l	#$FFFFB5CA,a0	;loads last SCScruct player struct (Away pos #6)
	move.w	#$B,d0	;B = # of player structs to check (12)
	tst.w	d1	;checks if d1 is negative (determines what zone to check)
	bmi.w	.checkYpos
.checkYpos2
	cmp.w	$14(a0),d1	;compare Ypos of a0 player to d1 (Ypos puckc)
	bge.w	.substruct2	;branch if d1 greater than or equal
	tst.w	$34(a0)	;check if goalie
	beq.w	.substruct2	;branch if goalie
	bra.w	.nogood
.substruct2
	suba.w	#$80,a0
	dbf	d0,.checkYpos2
.setBAbit
	bset	#1,$64(a3)	;set breakaway bit
	move.w	#1,d0	;moves 1 into d0 (used by returned subroutine)
.exit
	movem.w	(sp)+,d0-d1/a0
	rts
.nogood
	move.w	#0,d0	;move 0 into d0 (used on return to subroutine)
	bra.s	.exit
.checkYpos
	cmp.w	$14(a0),d1	;check Ypos with d1 (d1 = blue line Y)
	ble.w	.substruct
	tst.w	$34(a0)	;checks if goalie (who would be below blue line)
	beq.w	.substruct
	bra.s	.nogood
.substruct
	suba.w	#$80,a0	;subtract SCstruct size (80 hex)
	dbf	d0,.checkYpos
	bra.s	.setBAbit
chkpuckc
	btst	#0,(word_FFC2FA).w
	bne.w	.DF0A
	btst	#2,(BA_PS_flags).w
	bne.w	.DF0A
	bsr.w	breakaway
	bpl.w	asspuckc	;currently skating towards net in Y
.DF0A
	bclr	#1,$64(a3)	;clear breakaway bit
	move.w	#$10,d0	;asspuckc
	bsr.w	assreplace
asspuckc
	bclr	#2,(word_FFC2F6).w
	bne.w	.DF28
	bclr	#1,$64(a3)
.DF28
	move.w	(puckc).w,d0
	cmp.w	$52(a3),d0
	bne.w	assexit
	btst	#2,(BA_PS_flags).w
	beq.w	.DF48
	cmpi.w	#1,(word_FFC31A).w
	bgt.w	.E1CA
.DF48
	btst	#1,$64(a3)
	bne.w	.DF72
	btst	#2,(BA_PS_flags).w
	bne.w	.DF72
	jsr	(BreakawayOffsidesFlagSet).l
	beq.w	.DF72	;branch if breakaway flag not set
	move.w	#$21,d0	;'!'   ; chkpuckc assignment
	bsr.w	assreplace
	bra.w	*+4
.DF72
	btst	#5,$62(a3)
	bne.w	rtss2
	btst	#2,(BA_PS_flags).w
	bne.w	.DF90
	btst	#0,(gmode).w
	bne.w	assnothing
.DF90
	btst	#3,$62(a3)
	bne.w	assexit
	bclr	#1,$62(a3)
	beq.w	.E008
	btst	#1,$64(a3)
	beq.w	.DFB8
	move.w	#1,-(sp)
	jsr	(sfx).l
.DFB8
	btst	#1,$64(a3)
	beq.w	.DFF0
	movem.l	a2,-(sp)
	movea.l	#$FFFFC6CE,a2
	btst	#6,$62(a3)
	beq.w	.DFDC
	movea.l	#$FFFFCA32,a2
.DFDC
	addq.w	#1,$358(a2)
	addi.w	#$14,(CwdExciteLvl).w
	addi.w	#$C8,(crowdlevel).w
	movem.l	(sp)+,a2
.DFF0
	clr.w	$40(a3)
	move.w	#8,$42(a3)
	move.w	(VDP_CNTR).l,d0
	andi.w	#3,d0
	move.w	d0,$44(a3)
.E008
	sub.b	d7,$40(a3)
	bpl.w	.E0B8
	move.b	$6A(a3),$40(a3)
	jsr	(ReadGoaliePulled).l
	bmi.w	.E032
	btst	#6,(byte_FFC2FC).w
	beq.w	.E036
	tst.b	$40(a3)
	beq.w	.E036
.E032
	subq.b	#1,$40(a3)
.E036
	btst	#2,(BA_PS_flags).w
	bne.w	.E0A4
	btst	#0,(word_FFC2FA).w
	bne.w	.E0A4
	bsr.w	checkob
	bsr.w	sub_E1F4
	btst	#0,(word_FFC2FA).w
	bne.w	.E0A4
	btst	#2,(BA_PS_flags).w
	bne.w	.E0A4
	btst	#1,$64(a3)
	bne.w	.E09C
	move.w	#1,d0
	btst	#6,$62(a3)
	beq.w	.E082
	move.w	#2,d0
.E082
	cmp.w	(cont1team).w,d0
	beq.w	.E09C
	cmp.w	(cont2team).w,d0
	beq.w	.E09C
	btst	#1,(vcount+1).w
	bne.w	.E0B4
.E09C
	bsr.w	chk4shot
	bra.w	.E0B4
.E0A4
	jsr	(sub_FE8EC).l
	bne.w	.E0B8
	jsr	(compshoot).l
.E0B4
	bsr.w	chk4pass
.E0B8
	moveq	#6,d0
	add.w	$44(a3),d0	;add temp3 to d0
	lea	.postab2(pc),a0
	btst	#7,(sflags2).w	;#sf2offsig
	beq.w	.E0D0
	move.w	$34(a3),d0	;position
.E0D0
	asl.w	#2,d0
	move.w	2(a0,d0.w),d1
	move.w	0(a0,d0.w),d0
	btst	#2,(BA_PS_flags).w
	bne.w	.E0EE
	btst	#0,(word_FFC2FA).w
	beq.w	.E0FE
.E0EE
	jsr	(sub_FE864).l
	cmpi.b	#$80,(word_FFDA16).w
	beq.w	.E1CA
.E0FE
	btst	#7,$62(a3)	;pfgoal - 0 for bottom 1 for top
	bne.w	.E10C
	neg.w	d0
	neg.w	d1
.E10C
	lea	.E12C(pc),a0
	btst	#2,(BA_PS_flags).w
	bne.w	.E124
	btst	#0,(word_FFC2FA).w
	beq.w	.E128
.E124
	lea	.E1CA(pc),a0
.E128
	bra.w	skateto
.E12C
	ext.w	d0
	move.b	$28(a3),d2	;Xvel
	ext.w	d2
	add.w	(puckx).w,d2
	move.b	$2A(a3),d3	;Yvel
	ext.w	d3
	add.w	(pucky).w,d3
	clr.w	(threat).w
	moveq	#5,d4
	movea.w	#(SortCords-M68K_RAM),a0
	cmpi.w	#6,$52(a3)
	bge.w	.E15A
	adda.w	#$300,a0	;away team SCstruct start
.E15A
	move.b	$28(a0),d1	;Xvel
	ext.w	d1
	add.w	(a0),d1	;Xpos
	sub.w	d2,d1
	cmp.w	#$14,d1
	bgt.w	.E1C2
	cmp.w	#$FFEC,d1
	blt.w	.E1C2
	move.b	$2A(a0),d1	;Yvel
	ext.w	d1
	add.w	$14(a0),d1	;Ypos
	sub.w	d3,d1
	cmp.w	#$14,d1
	bgt.w	.E1C2
	cmp.w	#$FFEC,d1
	blt.w	.E1C2
	addq.w	#1,(threat).w
	move.w	(a3),d0	;Xpos
	sub.w	(a0),d0
	move.w	$14(a3),d1	;Ypos
	sub.w	$14(a0),d1
	bsr.w	vtoa
	move.w	$54(a3),d1	;facedir
	eori.w	#4,d1
	cmp.w	d0,d1
	bne.w	.E1C2
	move.w	(VDP_CNTR).l,d1
	andi.w	#1,d1
	add.w	d1,d0
	andi.w	#7,d0
.E1C2
	adda.w	#$80,a0	;SCstruct size
	dbf	d4,.E15A
.E1CA
	rts
.postab2	dc.w	$FF9C
	dc.w	$FFEC
	dc.w	$64
	dc.w	$FFEC
	dc.w	$FF88
	dc.w	$28
	dc.w	$14
	dc.w	$28
	dc.w	$78
	dc.w	$28
	dc.w	$FFEC
	dc.w	$28
	dc.w	$FFD8
	dc.w	$F0
	dc.w	0
	dc.w	$DC
	dc.w	$14
	dc.w	$E6
	dc.w	$1E
	dc.w	$E6
sub_E1F4
	btst	#4,(byte_FFC2FC).w
	bne.w	rtss2
	move.w	(pucky).w,d0
	btst	#7,$62(a3)
	bne.w	.E20E
	neg.w	d0
.E20E
	tst.w	d0
	bmi.w	rtss2
	cmp.w	#$58,d0
	bgt.w	rtss2
	move.w	(VDP_CNTR).l,d0
	andi.w	#3,d0
	bne.w	rtss2
	btst	#3,$63(a3)
	bne.w	rtss2
	movea.w	#(HmShots-M68K_RAM),a2
	lea	$364(a2),a1
	btst	#6,$62(a3)
	beq.w	.E248
	exg	a2,a1
.E248
	bsr.w	sub_12EF6
	cmp.w	#$C00,d0
	bhi.w	rtss2
	bsr.w	CompLine
	bsr.w	SetPersonel
	bsr.w	PrintScores1
	bra.w	compshoot
; return z flag set if killing penalty
; return z flag clr if not
chkpk
	btst	#5,(sflags2).w	;#sf2pwrplay - check if power play in progress
	bne.w	chkpk2
	eori	#4,ccr	;Z flag
	rts
chkpk2
	movem.l	d0-d1,-(sp)
	btst	#6,(sflags2).w	;#sf2pwrtm - 0 for team 1, 1 for team 2
	move	sr,d0
	btst	#6,$62(a3)	;pfteam - 0 home, 1 away
	move	sr,d1
	eor.w	d1,d0
	move	d0,ccr
	movem.l	(sp)+,d0-d1
	rts
; player a3 looks for shot (computer controlled)
chk4shot
	bsr.s	chkpk
	bne.w	.pkill	;killing penalty
	tst.w	(threat).w
	beq.w	.pkill	;no threat
	move.w	(VDP_CNTR).l,d0
	andi.w	#3,d0
	bne.w	.pkill
	move.w	#$58,d0	;'X'   ; top blue line Y position
	btst	#7,$62(a3)
	beq.w	.cmphome
	move.w	#$FFA8,d0	;bottom blue line Y pos
	cmp.w	$14(a3),d0
	blt.w	compshoot	;clear puck
	bra.w	.E2D4
.cmphome
	cmp.w	$14(a3),d0
	bgt.w	compshoot	;clear puck
.E2D4
	bset	#3,(word_FFC2F6).w
	jmp	dopass
	dc.b	$60	;`
	dc.b	0,1
	dc.b	$30	;0
.pkill
	btst	#1,$64(a3)
	beq.w	.E32C
	move.w	#$1E,d0
	jsr	(randomd0).l
	addi.w	#$82,d0
	cmp.w	(pucky).w,d0
	blt.w	.E312
	neg.w	d0
	cmp.w	(pucky).w,d0
	bgt.w	.E312
	bra.w	.E32C
.E312
	move.w	#2,d0
	jsr	(randomd0s).l
	add.w	$54(a3),d0
	andi.w	#7,d0
	move.w	d0,$54(a3)
	bra.w	compshoot
.E32C
	moveq	#$20,d4
	clr.w	d1
	move.b	$70(a3),d1
	lsr.w	#1,d1
	sub.b	d1,d4
	asl.w	#4,d4
	move.w	#$108,d1	;top goal line Y
	btst	#7,$62(a3)
	bne.w	.E34A
	neg.w	d1
.E34A
	sub.w	(pucky).w,d1
	move.w	(puckx).w,d0
	neg.w	d0
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d0,d1
	cmp.l	#$2710,d1
	movem.w	(sp)+,d0-d1
	bhi.w	.E3C4
	lsr.w	#4,d4
	bsr.w	vtoa
	move.w	d0,d5
	moveq	#5,d3
	movea.w	#(SortCords-M68K_RAM),a1
	cmpi.w	#6,$52(a3)
	bge.w	.E388
	adda.w	#$300,a1
.E388
	tst.w	$34(a1)
	beq.w	.E3AE
	move.w	(a1),d0
	sub.w	(puckx).w,d0
	move.w	$14(a1),d1
	sub.w	(pucky).w,d1
	bsr.w	vtoa
	cmp.w	d5,d0
	bne.w	.E3BC
	asl.w	#1,d4
	bra.w	.E3BC
.E3AE
	btst	#1,$63(a1)
	beq.w	.E3BC
	clr.w	d3
	moveq	#1,d4
.E3BC
	adda.w	#$80,a1
	dbf	d3,.E388
.E3C4
	move.w	d4,d0
	bsr.w	randomd0
	btst	#0,$70(a3)
	beq.w	.E3E0
	cmp.w	#7,d0
	bgt.w	rtss2
	bra.w	.E3E8
.E3E0
	cmp.w	#8,d0
	bgt.w	rtss2
.E3E8
	move.w	(pucky).w,d0
	btst	#7,$62(a3)
	bne.w	.E3F8
	neg.w	d0
.E3F8
	tst.w	d0
	bmi.w	rtss2
	move.w	#$108,d1
	sub.w	d0,d1
	bmi.w	rtss2
	btst	#7,(sflags2).w
	bne.w	rtss2
compshoot
	addq.w	#4,sp
	move.w	(pucky).w,d0
	btst	#7,$62(a3)
	bne.w	.E424
	neg.w	d0
.E424
	move.w	#$108,d1
	sub.w	d0,d1
	lsr.w	#3,d1
	cmp.w	#$14,d1
	blt.w	.E436
	moveq	#$14,d1
.E436
	move.w	d1,$42(a3)
	move.l	#$12,d0	;assshoot
	bra.w	assreplace
chk4pass
	tst.w	(threat).w
	bne.w	.E45E
	moveq	#$10,d0
	add.b	$70(a3),d0
	bsr.w	randomd0
	cmp.w	#$C,d0
	bgt.w	rtss2
.E45E
	moveq	#6,d0
	bsr.w	randomd0
	cmpi.w	#6,$52(a3)
	blt.w	.E470
	addq.w	#6,d0
.E470
	tst.w	$34(a3)
	beq.w	.E4A0
	cmpi.w	#$28,(puckx).w
	bgt.w	.E4A0
	cmpi.w	#$FFD8,(puckx).w
	blt.w	.E4A0
	cmpi.w	#$CC,(pucky).w
	bgt.w	rtss2
	cmpi.w	#$FF34,(pucky).w
	blt.w	rtss2
.E4A0
	cmp.w	$52(a3),d0
	beq.w	rtss2
	asl.w	#7,d0
	movea.w	#(SortCords-M68K_RAM),a0
	adda.w	d0,a0
	tst.w	$34(a0)
	ble.w	rtss2
	btst	#2,$63(a0)
	bne.w	rtss2
	btst	#5,$62(a0)
	bne.w	rtss2
	move.w	$14(a0),d0
	move.w	$14(a3),d1
	btst	#7,$62(a3)
	bne.w	.E4E2
	neg.w	d0
	neg.w	d1
.E4E2
	btst	#5,(gmode).w
	beq.w	.E502
	movem.w	d0-d1,-(sp)
	subi.w	#$58,d0
	subi.w	#$58,d1
	eor.w	d0,d1
	movem.w	(sp)+,d0-d1
	bmi.w	rtss2
.E502
	cmp.w	#$58,d0
	bgt.w	.E514
	sub.w	d1,d0
	cmp.w	#$FFF1,d0
	blt.w	rtss2
.E514
	move.w	(a0),d0
	sub.w	(puckx).w,d0
	move.w	$14(a0),d1
	sub.w	(pucky).w,d1
	movem.w	d0-d1,-(sp)
	bsr.w	vtoa
	move.w	d0,(passdir).w
	movem.w	(sp)+,d1-d2
	muls.w	d1,d1
	muls.w	d2,d2
	add.l	d1,d2
	moveq	#5,d3
	movea.w	#(SortCords-M68K_RAM),a1
	cmpi.w	#6,$52(a3)
	bge.w	.E54C
	adda.w	#$300,a1
.E54C
	move.w	(a1),d0
	sub.w	(puckx).w,d0
	move.w	$14(a1),d1
	sub.w	(pucky).w,d1
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d0,d1
	cmp.l	d2,d1
	movem.w	(sp)+,d0-d1
	bhi.w	.E57A
	bsr.w	vtoa
	cmp.w	(passdir).w,d0
	beq.w	rtss2
.E57A
	adda.w	#$80,a1
	dbf	d3,.E54C
	bsr.w	dopass
	tst.w	$34(a3)
	beq.w	rtss2
	addq.w	#4,sp
	bra.w	assexit
; player a3 should avoid the puck carrier if he's on their team
EvadePC
	tst.w	(puckc).w
	bmi.w	rtss2	;no puck carrier
	move.b	$28(a3),d2	;Xvel
	sub.b	(puckvx).w,d2	;sub puckvx from Xvel
	ext.w	d2
	add.w	(a3),d2	;add Xpos
	sub.w	(puckx).w,d2	;Sub puckx
	cmp.w	#$28,d2	;'('   ; compare to 40 decimal
	bgt.w	rtss2	;exit if greater than 40
	cmp.w	#$FFD8,d2	;compare to -40
	blt.w	rtss2	;exit if less than -40
	move.b	$2A(a3),d1	;Yvel
	sub.b	(puckvy).w,d1	;sub puckvy from Yvel
	ext.w	d1
	add.w	$14(a3),d1	;add Ypos to d1
	sub.w	(pucky).w,d1	;Sub pucky
	cmp.w	#$28,d1	;'('   ; compare to 40 dec
	bgt.w	rtss2	;exit if greater than
	cmp.w	#$FFD8,d1	;compare to -40 dec
	blt.w	rtss2	;exit if less than
	move.w	(a3),d0	;Xpos
	sub.w	(puckx).w,d0	;Sub puckx from Xpos
	move.w	$14(a3),d1	;Ypos
	sub.w	(pucky).w,d1	;Sub pucky from Ypos
	bsr.w	vtoa	;find direction and convert to 0-7
	btst	#5,(gmode).w	;check if offsides is on
	beq.w	.ex	;exit if not
	move.w	$14(a3),d1	;Ypos
	btst	#7,$62(a3)	;check what net shooting at
	bne.w	.0	;branch if top
	neg.w	d1	;negate d1 (Ypos)
.0
	subi.w	#$58,d1	;'X'   ; sub 88 from Ypos (top blue line)
	cmp.w	#$A,d1	;compare to 10 decimal
	bgt.w	.ex	;exit if greater
	cmp.w	#$FFCE,d1	;compare to -50
	blt.w	.ex	;branch if less than
	moveq	#2,d0
	move.w	(a3),d1	;Xpos
	cmp.w	(puckx).w,d1	;compare puckx with Ypos difference
	bgt.w	.ex	;exit if greater
	moveq	#6,d0
.ex
	rts
