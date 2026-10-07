;	NHL 94 (retail) segment $E62E-$FFE9
;	92 Logic.Asm part 4, as 93 logic93_4.asm: checkob, assnearest, check4check, asspassrec, assshoot, the 94 shootout /
;	penalty shot code (puckshootout, puckpenshot), puckfaceoff, ChkGoalies, ReturnGoalies, CPgoalie, CompLine,
;	puckfaceoff2, ResetAndSelectPlayers, updatefaceoff, Endfaceoff, pucknorm. ChkOffsides (logic94_5) follows at $FFEA.
;	Transcribed from lst/nhl94.bin.lst lines 40493-42593. Global names are the IDA names; 94-only routines keep the
;	IDA auto names. Local labels are the IDA local names (_x -> .x, gmclock -> .gmclock) or the 93 local where the code matches, else in the 93 style (.x exit, .loop, numbered), with the
;	IDA label in an ;IDA: comment. WaitForFaceoffLineChanges and PenaltyShotEndReturn stay global: they are used across a global label.
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp /
;	cmpi; fixopcodes.js patches the cmp encoding after assembly.
;	Inline print strings after printz / printz2 use the String macro (length word includes itself).
;	SortCords offsets (93 names): Xpos 0, Ypos $14, Xvel $28, Yvel $2A, position $34, assnum $36, temp1 $40,
;	temp3 $44, temp4 $46, SCnum $52, facedir $54, SPA $58, pflags $62, pflags2 $63.

checkob
	btst	#5,(gmode).w
	beq.w	rtss2
	btst	#2,(BA_PS_flags).w
	bne.w	rtss2
	movem.l	d0-d1/a0,-(sp)
	moveq	#5,d0
	movea.w	#(SortCords-M68K_RAM),a0
	cmpi.w	#6,SCnum(a3)
	blt.w	.0
	adda.w	#6*SCstruct,a0
.0	;IDA: loc_E65A
	moveq	#$5C,d1
	btst	#pfgoal,pflags(a3)
	bne.w	.top
	neg.w	d1
	cmp.w	(pucky).w,d1
	bgt.w	.nob
.bottom	;IDA: loc_E670
	tst.w	position(a0)
	bmi.w	.bn
	cmp.w	Ypos(a0),d1
	bgt.w	.ob
.bn	;IDA: loc_E680
	adda.w	#SCstruct,a0
	dbf	d0,.bottom
.nob	;IDA: loc_E688
	moveq	#$40,d0
	bclr	#sf2offsig,(sflags2).w
	bne.w	.dref
.ex	;IDA: loc_E694
	movem.l	(sp)+,d0-d1/a0
	rts
.ob	;IDA: loc_E69A
	moveq	#6,d0
	bset	#sf2offsig,(sflags2).w
	bne.s	.ex
.dref	;IDA: loc_E6A4
	tst.w	(RefCnt).w
	bpl.s	.ex
	bsr.w	PushRef
	bra.s	.ex
.top	;IDA: loc_E6B0
	cmp.w	(pucky).w,d1
	blt.s	.nob
.top1	;IDA: loc_E6B6
	tst.w	position(a0)
	bmi.w	.tn
	cmp.w	Ypos(a0),d1
	blt.s	.ob
.tn	;IDA: loc_E6C4
	adda.w	#SCstruct,a0
	dbf	d0,.top1
	bra.s	.nob
; assignment for breakaway
assbreakaway
	move.w	$52(a3),d0	;Move SCnum into d0
	cmp.w	(puckc).w,d0	;compare puck carrier SCnum with d0
	beq.w	.puckc	;branch if puck carrier
.notpuckc
	bclr	#1,$64(a3)	;clear breakaway bit
	move.w	#$11,d0	;11 - assnearest
	bsr.w	assreplace
	bra.w	assnearest
.puckc
	jsr	(breakaway).l
	bmi.s	.notpuckc
; this is a special assignment used for the player who is nearest the puck but doesn't have it
assnearest
	bclr	#2,(sflags5).w
	bne.w	.chkpuck
	bclr	#1,$64(a3)	;clear breakaway bit
.chkpuck
	move.w	$52(a3),d0	;move SCnum into d0
	cmp.w	(puckc).w,d0	;compare with puck carrier SCnum
	bne.w	.chkbreak	;jump if not puck carrier
	btst	#1,$64(a3)	;check breakaway bit
	bne.w	.chkbreak	;jump if set
	btst	#2,(BA_PS_flags).w	;check if bit 2 set (cleared on Faceoffs)
	bne.w	.chkbreak	;jump if set
	jsr	(BreakawayOffsidesFlagSet).l
	beq.w	.chkbreak
	move.w	#$22,d0	;'"'   ; 22 - assbreakaway if flag set
	bsr.w	assreplace	;assreplace with assbreakaway
	bra.w	*+4
.chkbreak
	bclr	#1,$62(a3)	;pfna - clear new assignment
	beq.w	.nna
	btst	#1,$64(a3)	;check if breakaway
	beq.w	.chkbreak2	;jump if not
	move.w	#1,-(sp)	;ding SFX
	jsr	(sfx).l
.chkbreak2
	btst	#1,$64(a3)	;check if breakaway
	beq.w	.nobreak	;jump if not
	movem.l	a2,-(sp)	;push a2 to stack
	movea.l	#HmShots,a2	;put Home Team Struct into a2
	btst	#6,$62(a3)	;pfteam - check home or away
	beq.w	.addcrowd	;jump if home
	movea.l	#AwShots,a2	;put Away Team Struct into a2
.addcrowd
	addq.w	#1,$358(a2)	;add to breakaway attempt
	addi.w	#$14,(CwdExciteLvl).w	;add to excite level
	addi.w	#$C8,(crowdlevel).w	;add to crowd level
	movem.l	(sp)+,a2	;pop off stack into a2
.nobreak
	clr.w	temp3(a3)	;clear temp3
	move.w	#8,temp2(a3)	;move 8 into temp2
	clr.w	temp1(a3)	;clear temp1
.nna
	move.w	SCnum(a3),d1	;checks if puck carrier
	cmp.w	(puckc).w,d1
	bne.w	.nopc	;jumps if not
	tst.w	position(a3)	;check if goalie
	beq.w	assgoaliecpu	;branch if goalie
	move.l	#$10,d0	;10 = asspuckc
	btst	#pfjoycon,pflags(a3)	;pfjoycon - check if controlled
	beq.w	assinsert	;jump if not
	rts
.nopc
	sub.b	d7,temp1(a3)	;subtract d7 (elapsed frames) from temp1
	bpl.w	.nodec	;jump if positive
	move.b	aioff(a3),temp1(a3)	;move aioff into temp1
	jsr	(ReadGoaliePulled).l	;check if goalie is pulled
	bmi.w	.bonus
	btst	#6,(sflags7).w	;check if crowd meter currently broken
	beq.w	.nopc2	;jump if not broken
	tst.b	$40(a3)	;check if temp1 is 0
	beq.w	.nopc2	;jump if so
.bonus
	subq.b	#1,$40(a3)	;subtract 1 from temp1
.nopc2
	btst	#5,(sflags6).w	;check if slot bit is set (puckc in slot)
	beq.w	.nopc3	;branch if not set
	move.w	(puckc).w,d1	;move puck carrier SCnum
	cmp.w	#5,d1	;check if its home (5 or less) or away (6-11)
	bgt.w	.pcaway	;jump if away
	btst	#6,$62(a3)	;pfteam
	beq.w	.nopc3	;jump if home
.tmnopc
	move.b	$40(a3),d1	;temp1 into d1
	ext.w	d1	;extend d1
	asr.w	#1,d1	;divide by 2
	move.b	d1,$40(a3)	;move d1 into temp1 - cutting the timer in half
	bne.w	.nopc3	;jump if not zero
	move.b	#1,$40(a3)	;move 1 into temp1
	bra.w	.nopc3
.pcaway
	btst	#6,$62(a3)	;pfteam - 0 home, 1 away
	beq.s	.tmnopc	;jump if home
.nopc3
	clr.l	$2A(a2)	;Calculated future Ypos of the player closest to the puck
	move.w	(puckc).w,d1	;move puck carrier SCnum into d1
	bmi.w	.np	;branch if no puck carrier
	asl.w	#7,d1	;scsize
	movea.w	#(SortCords-M68K_RAM),a1	;Move SortCords into a1
	adda.w	d1,a1	;use d1 as offset
	move.b	pflags(a1),d0	;pflags of puck carrier
	move.b	pflags(a3),d1	;pflags of current player
	eor.b	d0,d1	;XOR pflags
	btst	#pfteam,d1	;check pfteam
	beq.w	.switch	;branch if on same team
.np
	moveq	#-1,d2	;-1
	moveq	#5,d4	;5 = # of players on team
	movea.w	tmsort(a2),a0	;SortCord start value for team
.de0
	tst.w	position(a0)	;check if goalie
	ble.w	.next	;branch if goalie
	tst.b	nopuck(a0)	;check if nopuck (cant touch puck)
	bne.w	.next	;branch if nopuck timer not 0
	btst	#2,pflags2(a0)	;pf2unav - unavailable
	bne.w	.next	;branch if unavailable
	move.w	assnum(a0),d0	;assnum - current assignment
	cmpi.b	#$13,asslist(a0,d0.w)	;check if current assignment is asspassrec
	beq.w	.next	;branch if a0 is going to receive puck
	move.l	a0,-(sp)	;push onto stack
	bsr.w	GetHot	;get hot spot
	add.w	(a0),d0	;Xpos to d0
	sub.w	(puckx).w,d0	;sub puck Xpos
	add.w	Ypos(a0),d1	;add Ypos to d1
	sub.w	(pucky).w,d1	;sub puck Ypos
	move.w	(puckvx).w,d3	;puckvx into d3
	asr.w	#6,d3	;divide by 64
	sub.w	d3,d0	;sub d3 from d0 (X distance between player and puck)
	move.w	(puckvy).w,d3	;puckvy into d3
	asr.w	#6,d3	;divide by 64
	sub.w	d3,d1	;sub d3 from d1 (Y distance between player and puck)
	muls.w	d0,d0	;square d0
	muls.w	d1,d1	;square d1
	add.l	d1,d0	;add d1 to d0
	cmp.l	d2,d0	;compare d2 to d0
	bhi.w	.next	;branch if d0 higher than d2 (0 or a positive # first run)
	move.l	d0,d2	;move d0 into d2
	movea.w	a0,a1	;move a0 address into a1
.next
	adda.w	#SCstruct,a0	;SCstruct size
	dbf	d4,.de0	;iterate through loop
	tst.l	d2	;check if 0
	bmi.w	.de1	;branch if less (no one near puck)
	move.l	d2,$2A(a2)	;moves d2 into $2A(a2)
.switch
	cmpa.w	a1,a3	;a1 = closest to the puck, or puckc (if on same team)
	beq.w	.de1	;branch if same
	btst	#gmclock,(gmode).w	;gmclock - 1 if stopped
	bne.w	.de1	;jump if stopped
	btst	#2,pflags2(a1)	;pf2unav
	bne.w	.de1	;jump if unavailable
	btst	#3,$64(a1)	;shooting one timer
	bne.w	.de1	;jump if shooting
	exg	a1,a3	;swap addresses
	bclr	#pfdoff,pflags(a3)	;clear pfdoff
	move.l	#$11,d0	;assnearest
	bsr.w	assinsert
	exg	a1,a3
	bra.w	assexit
.de1
	btst	#pfalock,pflags(a3)	;pfalock - check if locked in animation
	bne.w	rtss2	;exit if locked
	moveq	#2,d1	;move 2 into d1
	cmp.w	#$190,d2	;compare $190 (20^2) to d2. d2 = distance to puck^2
	bhi.w	.nfar	;branch if d2 higher
	subq.w	#2,d1
	cmpi.w	#2,position(a3)	;compare if position is F or D (1 and 2 are D)
	bls.w	.nodec	;jump if D
.nfar
	btst	#sf2pwrplay,(sflags2).w	;sf2pwrplay - check if PP
	beq.w	.x	;branch if no PP
	subq.w	#2,d1	;sub 2 from d1
	bsr.w	chkpk2
	bne.w	.x	;branch if on PK
	addq.w	#4,d1	;add 4 to d1
.x
	move.w	#$28,d0	;'('   ; move $28 into d0 (40 dec)
	sub.b	$75(a3),d0	;sub checking from d0
	asl.w	d1,d0	;shift d0 by value of d1
	bsr.w	randomd0	;RNG
	cmp.w	#2,d0	;compare 2 to d0
	bhi.w	.nodec	;branch if d0 more than 2
	move.w	#$F0,temp3(a3)	;move 240 dec into temp3
.nodec
	btst	#pfalock,pflags(a3)	;pfalock - check if anim lock
	bne.w	rtss2	;exit if locked
	btst	#2,(BA_PS_flags).w	;check bit 2
	beq.w	.gmclock	;jump if not set
	btst	#5,(BA_PS_flags).w	;check bit 5
	beq.w	.nodec2	;jump if not set
.gmclock	;IDA: gmclock (a 92 equate name; local so it does not split assnearest or clash with the equate)
	btst	#0,(gmode).w	;check if clock running
	bne.w	assnothing	;branch if not
.nodec2
	btst	#pfjoycon,pflags(a3)	;pfjoycon - check if controlled
	bne.w	rtss2	;jump if controlled
	btst	#2,tmflags(a2)	;check bit 2 of $30(a2)
	bne.w	.nodec22
	tst.w	(puckc).w	;check if theres a puck carrier
	bmi.w	.topuck	;jump if no puck carrier
	sub.w	d7,temp3(a3)	;subtract frames from temp3
	bpl.w	.topuck	;jump if positive
	clr.w	temp3(a3)	;clear temp3
.nodec22
	bsr.w	skatetopuckinit
	movem.w	d0-d1,-(sp)	;d0 = future puckx, d1 = future pucky push on stack
	neg.w	d0
	neg.w	d1
	addi.w	#$F4,d1	;add goalline - 20 decimal
	btst	#pfgoal,pflags(a3)	;pfgoal - check what net shooting on
	beq.w	.nd0	;branch if bottom
	subi.w	#$1E8,d1	;sub bottom goalline - 20 decimal
.nd0
	asr.w	#1,d0	;divide by 2
	asr.w	#1,d1	;divide by 2
	add.w	(sp)+,d0	;add original future puckx
	add.w	(sp)+,d1	;add original future pucky
	btst	#2,tmflags(a2)	;?? - doesn't seem to be set anywhere
	beq.w	.spdboost
	btst	#pfgoal,pflags(a3)	;pfgoal
	beq.w	.botshoot	;branch if bottom
	cmp.w	#$53,d1	;'S'   ; check if y pos of puck near blue line
	blt.w	.spdboost	;branch if in neutral zone or D zone
	move.w	#$44,d1	;'D'   ; move 44 hex into d1
	bra.w	.spdboost
.botshoot
	cmp.w	#$FFAD,d1	;check if pucky near bottom blue line
	bgt.w	.spdboost	;branch if in neutral zone or D zone
	move.w	#$FFBC,d1	;move FFBC into d1
.spdboost
	btst	#5,(sflags6).w	;check if puckc is in the slot
	beq.w	.noslot	;branch if not
	move.b	$69(a3),(TempLegSpd).w	;legspd into FFBF1E
	addq.b	#6,$69(a3)	;add 6 to legspd
	btst	#1,(sflags8).w	;check if crowd meter broken (always is)
	bne.w	.spdboostex	;jump if set
	btst	#6,(sflags7).w	;check if crowd meter currently broken
	beq.w	.spdlimit	;jump if not set
.spdboostex
	addq.b	#2,$69(a3)
.spdlimit
	cmpi.b	#$1E,$69(a3)	;check speed limit
	ble.w	.cont
	move.b	#$1E,$69(a3)	;limit legspd to $1E (30 decimal)
.cont
	lea	rtss2(pc),a0
	bsr.w	skateto
	move.b	(TempLegSpd).w,$69(a3)	;move original legpsd back into player
	bra.w	.chkslot
.noslot
	lea	rtss2(pc),a0
	bsr.w	skateto
.chkslot
	btst	#5,(sflags6).w
	beq.w	.chkcont
	move.w	(pucky).w,d0
	move.w	$14(a3),d2	;Ypos into d2
	tst.w	d0	;check if d0 is 0
	bpl.w	.pospuck	;branch if positive
	neg.w	d0	;make d0 negative
	neg.w	d2	;make d2 negative
.pospuck
	sub.w	d0,d2	;sub d0 from d2 (equals how far puck is from player Ypos)
	cmp.w	#$A,d2	;check difference with A (10 decimal)
	blt.w	.exit
	move.w	(a3),d0	;Xpos of player (gets here if player is between net and puck carrier)
	sub.w	(puckx).w,d0	;sub puckx from Xpos
	bpl.w	.chkx	;branch if positive difference
	neg.w	d0	;make d0 negative
.chkx
	cmp.w	#$F,d0	;compare F (15 dec) with Xpos difference
	blt.w	.chkcont	;branch if less than (within 15 pix in X direction)
.exit	;IDA: loc_FDBC
	rts
.chkcont
	btst	#5,(sflags6).w	;check if puckc is in the slot
	beq.w	check4check	;branch if not in slot
	move.b	$75(a3),d0	;move Chk into d0
	ext.w	d0	;clear top byte of d0
	movem.l	d0/a3,-(sp)	;push to stack
	add.b	d0,d0	;add d0 to itself
	cmp.b	#$1E,d0	;compare max Chk to d0
	blt.w	.chkcont2	;branch if less
	move.b	#$1E,d0	;move 1E into d0
.chkcont2
	move.b	d0,$75(a3)	;move d0 into Chk
	bsr.w	check4check
	movem.l	(sp)+,d0/a3	;pop off stack
	move.b	d0,$75(a3)	;move original Chk into player
	rts
.topuck
	bsr.w	skatetopuck
; look for good opportunity for checking opponent
; a3 = player
check4check
	tst.w	$34(a3)	;check if goalie
	bne.w	.player	;branch if not
	rts
.player
	move.w	#$28,d0	;'('   ; start with 28 hex (40 decimal)
	sub.b	$75(a3),d0	;subtract Chk from d0 (Chk max is 1E or 30 decimal)
	tst.w	(OptPen).w	;check for penalties option
	beq.w	.nopen	;branch if not on
	asl.w	#1,d0	;mult by 2
.nopen
	bsr.w	randomd0	;RNG d0
	cmp.w	#6,d0	;compare 6 to d0
	bhi.w	rtss2	;exit if d0 higher than 6
	moveq	#5,d2	;move 5 into d2
	movea.w	#(SortCords-M68K_RAM),a0
	cmpi.w	#6,SCnum(a3)	;check if player on home team
	bge.w	.0	;branch if away
	adda.w	#6*SCstruct,a0	;add if home (checks opposite team in loop)
.0	;IDA: loc_E65A
	tst.w	position(a0)	;check if goalie
	beq.w	.next	;branch if goalie
	btst	#pfalock,pflags(a0)	;check if locked in anim
	bne.w	.next	;branch if locked
	btst	#pf2fight,pflags2(a0)	;check if fighting
	bne.w	.next	;branch if fighting
	move.w	(a0),d0	;move Xpos into d0
	sub.w	(a3),d0	;sub a3 from a0
	cmp.w	#$1E,d0	;compare to 30 decimal
	bgt.w	.next	;branch if more than 30 decimal
	cmp.w	#$FFE2,d0	;compare to -30 decimal
	blt.w	.next	;branch if less than -30
	move.w	Ypos(a0),d1	;Ypos
	sub.w	Ypos(a3),d1	;subtract checker Ypos from d1
	cmp.w	#$1E,d1	;compare to 30 decimal
	bgt.w	.next	;branch if more
	cmp.w	#$FFE2,d1	;check with -30 decimal
	blt.w	.next	;branch if less
	bsr.w	vtoa	;determine direction
	cmp.w	facedir(a3),d0	;compare facedir with vtoa result
	bne.w	.next	;branch if not facing in that direction
	btst	#5,(sflags6).w	;check if puckc in slot
	bne.w	Acheck	;branch if in slot
	move.w	(VDP_CNTR).l,d0	;move HVcounter into d0
	andi.w	#3,d0	;pass first 2 bits
	bne.w	burst	;throw check
	bra.w	Acheck
.next
	adda.w	#SCstruct,a0	;move to next SCstruct
	dbf	d2,.0
	rts
; assignment for catching pass
asspassrec
	btst	#pfalock,pflags(a3)	;pfalock - animation lock
	bne.w	rtss2	;exit if locked
	btst	#gmclock,(gmode).w	;gmclock - check if clock running
	bne.w	assnothing	;exit if clock stopped
	btst	#pfjoycon,pflags(a3)	;pfjoycon - joystick controlled?
	bne.w	assexit	;exit if controlled
	bclr	#pfna,pflags(a3)	;#pfna - clear new assignment
	beq.w	.nna
	bset	#pfdoff,pflags(a3)	;#pfdoff - set decceleration off
	move.b	#8,temp2+1(a3)	;move into temp2+1
	clr.b	temp2(a3)	;clear temp2 byte
	move.w	#$FFFE,$46(a3)	;move into temp4
.nna
	tst.w	(puckc).w	;check if there is a puck carrier
	bpl.w	.exit	;exit if puck still in possession
	addq.w	#1,$46(a3)	;add to temp4
	beq.w	.0	;branch if temp4 is zero
	bpl.w	.ex2	;branch if temp4 is positive
.0	;IDA: loc_E65A
	tst.w	(onetimerplayer).w
	bpl.w	.ex2
	tst.w	$34(a3)	;test if goalie
	beq.w	.ex2	;exit if goalie
	move.w	d0,-(sp)	;push d0 on stack
	clr.w	$46(a3)	;clear temp4
	move.w	#1,d0
	btst	#6,$62(a3)	;check if home or away
	beq.w	.1
	move.w	#2,d0	;away team
.1
	cmp.w	(cont1team).w,d0	;check if player on cont 1 team
	beq.w	.pop	;branch if so
	cmp.w	(cont2team).w,d0	;check if player on cont 2 team
	beq.w	.pop	;branch if so
	jsr	(PuckOnAttackHalf).l
	beq.w	.pop
	move.w	$14(a3),d0	;Ypos
	btst	#7,$62(a3)	;pfgoal
	bne.w	.chkpos	;branch if shooting at top
	neg.w	d0
.chkpos
	cmp.w	#$58,d0	;'X'   ; blueline
	blt.w	.nozone
	cmp.w	#$108,d0	;goalline
	bgt.w	.nozone
	bra.w	.atkzone
.nozone
	move.w	#8,d0	;outside of attack zone
	jsr	(randomd0).l
	tst.w	d0	;check if d0 is zero
	bne.w	.pop
.atkzone
	move.w	(sp)+,d0
	move.w	#$FFFF,(inputjoy).w
	move.w	#$23,d0	;'#'   ; assonetimer
	jmp	assreplace
.pop
	move.w	(sp)+,d0
.ex2
	sub.b	d7,temp1(a3)
	bpl.w	rtss2
.exit	;IDA: loc_FDBC
	bclr	#pfdoff,pflags(a3)
	bra.w	assexit
SkateToTempTarget	;no xref (IDA dc.b at $EC72). Skate to temp3 / temp4, then rts (as 93 asspenalty .st)	;IDA: sub_EC72
	move.w	$44(a3),d0		;temp3
	move.w	$46(a3),d1		;temp4
	lea	rtss2(pc),a0
	bra.w	skateto

; assignment for computer shooting
assshoot
	btst	#pfalock,pflags(a3)	;pfalock - animation locked
	bne.w	rtss2
	bclr	#pfna,pflags(a3)	;clear pfna
	beq.w	.nna
	bra.w	SetShotMode
.nna
	btst	#sfssdir,(sflags).w	;#sfssdir
	beq.w	assexit
	clr.w	d2
	sub.w	d7,temp2(a3)
	bpl.w	ShotMode
	bset	#5,d2	;#cbut
	bra.w	ShotMode
puckshootout
	bclr	#1,$62(a3)
	beq.w	.selectskater
	bset	#7,(sflags7).w
	clr.l	(padcont).w
	clr.l	(padcont+4).w
	clr.l	(padcont+8).w
	bclr	#7,(gmode2).w
	btst	#0,(gmode2).w
	beq.w	.startattempt
	jsr	(NextShooter).l
	bra.w	.initflags
.startattempt	;IDA: loc_ECEC
	jsr	(StartShootoutPath).l
	move.l	a2,-(sp)
	movea.l	#HmShots,a2
	tst.w	(BA_Team).w
	beq.w	.countattempt
	movea.l	#AwShots,a2
.countattempt	;IDA: loc_ED08
	addq.w	#1,$360(a2)
	movea.l	(sp)+,a2
.initflags	;IDA: loc_ED0E
	bclr	#2,(BA_PS_flags).w
	bclr	#4,(BA_PS_flags).w
	bclr	#5,(BA_PS_flags).w
	bclr	#6,(BA_PS_flags).w
	bset	#1,(sflags6).w
	btst	#3,(gmode).w
	bne.w	Stop4Pen
	bclr	#1,$62(a3)
	btst	#0,(gmode2).w
	beq.w	.selectsong
	tst.w	(shootoutteam).w
	bne.w	.setstopped
	tst.w	(homeshootnum).w
	bne.w	.setstopped
	move.w	(HomeTeam).w,(HmTeam).w
	move.w	#2,(SongIndex).w
	jsr	(ChooseSong).l
	move.w	(SongNum).w,-(sp)
	bra.w	.playsong
.selectsong	;IDA: loc_ED70
	move.w	(HomeTeam).w,(HmTeam).w
	move.w	#2,(SongIndex).w
	jsr	(ChooseSong).l
	move.w	(SongNum).w,-(sp)
.playsong	;IDA: loc_ED86
	bsr.w	song
.setstopped	;IDA: loc_ED8A
	bset	#0,(gmode).w
	bset	#1,(gmode2).w
	clr.w	(puckvx).w
	clr.w	(puckvy).w
	move.w	#$19,(shootoutclock).w
	bsr.w	ReturnGoalies
	st	$40(a3)
	st	$42(a3)
.selectskater	;IDA: loc_EDB0
	bset	#2,(BA_PS_flags).w
	movem.w	d1-d2,-(sp)
	jsr	(SelectPenaltyShotSkater).l
	bmi.w	.noeligible
	movem.w	(sp)+,d1-d2
	bra.w	.checkgoalie
.noeligible	;IDA: loc_EF80
	movem.w	(sp)+,d1-d2
	bclr	#2,(BA_PS_flags).w
	move.w	#$1B,d0	;puckfaceoff
	bsr.w	assreplace
	rts
.checkgoalie	;IDA: loc_EDE0
	movem.w	d1-d2,-(sp)
	move.w	(BA_Goalie_SCnum).w,d0
	movea.l	#SortCords,a2
	asl.w	#7,d0
	adda.w	d0,a2
	tst.w	$34(a2)
	bne.w	.findgoalie
	btst	#2,$63(a2)
	beq.w	.startpenshot
.findgoalie	;IDA: loc_EE04
	move.w	(BA_Goalie_SCnum).w,d0
	move.w	#6,d2
.goalieloop	;IDA: loc_EE0C
	subq.w	#1,d2
	bmi.s	.noeligible
	subq.w	#1,d0
	bpl.w	.wraphome
	move.w	#5,d0
	bra.w	.checkcandidate
.wraphome	;IDA: loc_EE1E
	cmp.w	#5,d0
	bne.w	.checkcandidate
	move.w	#$B,d0
.checkcandidate	;IDA: loc_EE2A
	movea.l	#SortCords,a2
	move.w	d0,d1
	asl.w	#7,d1
	adda.w	d1,a2
	tst.w	$34(a2)
	bne.s	.goalieloop
	btst	#2,$63(a2)
	bne.s	.goalieloop
	move.w	d0,(BA_Goalie_SCnum).w
.startpenshot	;IDA: loc_EE48
	movem.w	(sp)+,d1-d2
	movea.w	#(HmShots-M68K_RAM),a2
	move.w	#$1F,d0	;puckpenshot
	bra.w	assreplace
SelectPenaltyShotSkater	;IDA: sub_EE58
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#HmShots,a0
	tst.w	(BA_Team).w
	beq.w	.hometeam
	movea.l	#AwShots,a0
.hometeam	;IDA: loc_EE70
	move.w	#0,d1
	move.w	#$FFFF,d6
	move.w	#$FFFF,d5
	movea.l	$1E(a0),a2
	adda.w	(a2),a2
.playerloop	;IDA: loc_F0A8
	cmpi.w	#2,(a2)
	beq.w	.doneplayers
	adda.w	(a2),a2
	move.w	d1,d7
	asl.w	#1,d7
	move.b	5(a2),d0
	andi.w	#$F,d0
	cmp.b	#1,d0
	ble.w	.nextplayer
	btst	#0,(gmode2).w
	bne.w	.setskaterscnum
	cmpi.w	#$FFFE,$66(a0,d7.w)
	beq.w	.scorecandidate
	cmpi.w	#$FFFF,$66(a0,d7.w)
	bne.w	.nextplayer
.scorecandidate	;IDA: loc_EEBE
	clr.w	d3
	clr.w	d0
	move.b	1(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	2(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	2(a2),d0
	andi.w	#$F0,d0
	lsr.w	#4,d0
	add.w	d0,d3
	move.b	3(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	3(a2),d0
	andi.w	#$F0,d0
	lsr.w	#4,d0
	add.w	d0,d3
	move.b	5(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	5(a2),d0
	andi.w	#$F0,d0
	lsr.w	#4,d0
	add.w	d0,d3
	move.b	6(a2),d0
	andi.w	#$F0,d0
	lsr.w	#4,d0
	add.w	d0,d3
	move.b	7(a2),d0
	andi.w	#$F0,d0
	lsr.w	#4,d0
	add.w	d0,d3
	cmp.w	(BA_Skater_Offset).w,d1
	bne.w	.comparebest
	move.w	#$7FFF,d3
.comparebest	;IDA: loc_EF32
	cmp.w	d6,d3
	blt.w	.nextplayer
	move.w	d3,d6
	move.w	d1,d5
	bra.w	*+4
.nextplayer	;IDA: loc_F1FC
	addq.l	#8,a2
	addq.w	#1,d1
	cmp.w	#$1A,d1
	blt.w	.playerloop
.doneplayers	;IDA: loc_EF4C
	tst.w	d5
	bmi.w	.noeligible
	move.w	d5,(BA_Skater_Offset).w
.setskaterscnum	;IDA: loc_EF56
	move.w	#0,(BA_Sktr_SCnum).w
	tst.w	(BA_Team).w
	beq.w	.loadskater
	move.w	#6,(BA_Sktr_SCnum).w
.loadskater	;IDA: loc_EF6A
	move.w	(BA_Sktr_SCnum).w,d0
	asl.w	#7,d0
	movea.l	#SortCords,a3
	adda.w	d0,a3
	move.w	(BA_Skater_Offset).w,d3
	bra.w	.eligible
.noeligible	;IDA: loc_EF80
	move.w	#$FFFF,d0
	bra.w	.exit
.eligible	;IDA: loc_EF88
	move.w	#1,d0
.exit	;IDA: loc_FDBC
	movem.l	(sp)+,d0-d7/a0-a6
	rts
; puck start for penalty shot/shootout
puckpenshot
	bclr	#1,$62(a3)
	beq.w	.resumeplay
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	forceblack
.waitvblank	;IDA: loc_EFA4
	btst	#0,(disflags).w
	bne.s	.waitvblank
	cmpi.w	#$258,(crowdlevel).w
	bls.w	.setuprink
	move.w	#$258,(crowdlevel).w
	addi.w	#$14,(CwdExciteLvl).w
.setuprink	;IDA: loc_EFC2
	move.w	(ExtraChars).w,d4
	movea.l	#RefsMap+8,a2
	jsr	(DoDMA_clearCallbackPointer).l
	bset	#3,(disflags).w
	bclr	#0,(sflags).w
	bclr	#0,(sflags3).w
	clr.w	(glovecords).w
	clr.b	(iflags).w
	st	(RefCnt).w
	bclr	#1,(sflags2).w
	st	(passplayer).w
	bsr.w	ClrHor
	clr.w	(Vpos).w
	clr.w	(Hpos).w
	move.w	#0,(puckx).w
	move.w	#0,(pucky).w
	clr.w	(puckz).w
	clr.w	(puckvx).w
	clr.w	(puckvy).w
	clr.w	(puckvz).w
	st	(puckc).w
	movea.w	#(SortCords+(12*SCstruct)-M68K_RAM),a0	;goal net SCstruct
	clr.w	$28(a0)
	clr.w	$2A(a0)
	clr.w	(a0)
	move.w	#$10C,$14(a0)
	adda.w	#$80,a0	;move to second goal net SCstruct
	clr.w	$28(a0)
	clr.w	$2A(a0)
	clr.w	(a0)
	move.w	#$FEF4,$14(a0)
	movea.w	#(SortCords+((puckscnum+1)*SCstruct)-M68K_RAM),a0	;puck shadow SCstruct
	move.w	#$18A,6(a0)
	clr.w	$58(a0)
	clr.w	4(a0)
	clr.w	(SortCords+(puckscnum*SCstruct)+attribute).w
	bclr	#6,(sflags).w
	moveq	#$64,d4
.scrollloop	;IDA: loc_F06C
	bsr.w	checkwindow
	dbf	d4,.scrollloop
	move.w	#$3C,(yleader).w
	bsr.w	ResetBench
	movea.w	#(HmShots-M68K_RAM),a2
	bsr.w	SetPersonel
	bsr.w	SetupPenaltyShot
	adda.w	#$364,a2
	bsr.w	SetPersonel
	bsr.w	SetupPenaltyShot
	jsr	(resetplstuff).l
	move.l	a3,-(sp)
	movea.l	#SortCords+(11*SCstruct),a3	;away goalie SCstruct
	move.w	#$B,d2	;11 = # of player SCstructs
.playerloop	;IDA: loc_F0A8
	cmp.w	(BA_Sktr_SCnum).w,d2
	beq.w	.setupskater
	cmp.w	(BA_Goalie_SCnum).w,d2
	beq.w	.setupgoalie
	move.w	#$FF10,(a3)
	clr.w	$14(a3)
	clr.w	6(a3)
	move.w	#$20,d0
	bsr.w	assinsert
	bra.w	.nextplayer
.setupskater	;IDA: loc_F0D0
	tst.w	$34(a3)
	bpl.w	.placeskater
	bclr	#2,$63(a3)
	beq.w	.placeskater
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d3
	move.b	$66(a3),d3
	jsr	(setplayer).l
	movem.l	(sp)+,d0-d7/a0-a6
	tst.w	$34(a3)
	beq.w	.skaterready
	bpl.w	.placeskater
.skaterready	;IDA: loc_F102
	nop
.placeskater	;IDA: loc_F104
	move.w	(puckx).w,d0
	subi.w	#0,d0
	move.w	d0,(a3)
	move.w	(pucky).w,d0
	btst	#7,$62(a3)
	bne.w	.skaterattop
	addi.w	#$10,d0
	move.w	#4,$54(a3)
	bra.w	.setskaterpos
.skaterattop	;IDA: loc_F12A
	addi.w	#-$10,d0
	move.w	#0,$54(a3)
.setskaterpos	;IDA: loc_F134
	move.w	d0,$14(a3)
	clr.w	$28(a3)
	clr.w	$2A(a3)
	clr.w	$2C(a3)
	move.w	#$11,d0
	bsr.w	assinsert
	bra.w	.nextplayer
.setupgoalie	;IDA: loc_F150
	btst	#0,(gmode2).w
	beq.w	.goalieactive
	move.b	(shootoutteam-1).w,$66(a3)
	tst.w	(shootoutteam).w
	beq.w	.loadgoalieplayer
	move.b	(homeshootnum-1).w,$66(a3)
	bra.w	.loadgoalieplayer
.goalieactive	;IDA: loc_F172
	tst.w	$34(a3)
	bpl.w	.placegoalie
	bclr	#2,$63(a3)
	beq.w	.placegoalie
.loadgoalieplayer	;IDA: loc_F184
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d3
	move.b	$66(a3),d3
	jsr	(setplayer).l
	movem.l	(sp)+,d0-d7/a0-a6
	tst.w	$34(a3)
	bne.w	.goalieok
	bpl.w	.placegoalie
.goalieok	;IDA: loc_F1A4
	nop
.placegoalie	;IDA: loc_F1A6
	bclr	#2,$63(a3)
	move.w	#0,d0
	move.w	#$E5,d1
	btst	#7,$62(a3)
	bne.w	.goalieattop
	move.w	#$FF1B,d1
.goalieattop	;IDA: loc_F1C2
	move.w	d0,(a3)
	move.w	d1,$14(a3)
	clr.w	$28(a3)
	clr.w	$2A(a3)
	clr.w	$18(a3)
	sub.w	(puckx).w,d0
	sub.w	(pucky).w,d1
	neg.w	d0
	neg.w	d1
	bsr.w	vtoa
	move.w	d0,$54(a3)
	bclr	#2,$63(a3)
	bclr	#5,$62(a3)
	move.w	#$50C,d1
	bsr.w	SetSPA
.nextplayer	;IDA: loc_F1FC
	suba.l	#$80,a3
	dbf	d2,.playerloop	;cycle to next player
	bsr.w	SprSort
	movea.l	(sp)+,a3
	bsr.w	ResetAndSelectPlayers
	move.w	(BA_Goalie_SCnum).w,d0
	asl.w	#7,d0
	movea.w	#(SortCords-M68K_RAM),a3
	adda.w	d0,a3
	move.w	#0,(a3)
	move.w	#$FF06,$14(a3)
	btst	#7,$62(a3)
	bne.w	.goalieatbottom
	move.w	#$FA,$14(a3)
.goalieatbottom	;IDA: loc_F236
	move.w	(BA_Goalie_SCnum).w,d0
	move.w	#1,d1
	btst	#6,$62(a3)
	beq.w	.checkcont1
	move.w	#2,d1
.checkcont1	;IDA: loc_F24C
	cmp.w	(cont1team).w,d1
	bne.w	.checkcont2
	jsr	(setc1player).l
	bra.w	.setgoalieassignment
.checkcont2	;IDA: loc_FD3C
	cmp.w	(cont2team).w,d1
	bne.w	.setgoalieassignment
	jsr	(setc2player).l
.setgoalieassignment	;IDA: loc_F26C
	move.w	#$E,d0	;assignment D51C?
	bsr.w	assreplace
	bset	#7,(BA_PS_flags).w
	bset	#2,(sflags2).w
	move.w	#$190,(msgtimer).w
	tst.w	(cont1team).w
	bne.w	.finishsetup
	tst.w	(cont2team).w
	bne.w	.finishsetup
	move.w	#$64,(msgtimer).w
.finishsetup	;IDA: loc_F29C
	move.w	#$18,(palcount).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.resumeplay	;IDA: loc_F2A8
	bset	#2,(gmode2).w
	move.w	#$18,d0	;pucknorm
	bsr.w	assreplace
	clr.w	$28(a3)
	clr.w	$2A(a3)
	rts
	dc.b	0,1,2,3,4,5,6,0,0,1,5,3,4,2,0,0
	dc.b	0,3,5,1,4,0,0,0,0,0,$FF,6,$FF,$DD,$FF,$CE
	dc.b	0
	dc.b	$23	;#
	dc.b	$FF,$CE,$FF,$CE,$FF,$F6,0,0,$FF,$F1,0
	dc.b	$32	;2
	dc.b	$FF,$F6,0,0,$FF,$C4
UpdatePenaltyShotEnd	;IDA: sub_F2F4
	movem.w	d0,-(sp)
	move.w	(puckc).w,d0
	cmp.w	(BA_Goalie_SCnum).w,d0
	movem.w	(sp)+,d0
	beq.w	.setended
	btst	#5,(BA_PS_flags).w
	beq.w	.checktimer
	btst	#5,(gmode2).w
	bne.w	.puckloose
	tst.w	(puckc).w
	bpl.w	.countdown
	bset	#5,(gmode2).w
.puckloose	;IDA: loc_F32A
	tst.w	(puckc).w
	bpl.w	.setended
.countdown	;IDA: loc_F684
	tst.w	(passmodetimer).w
	bmi.w	.setended
	subq.w	#1,(passmodetimer).w
	bra.w	.checktimer
.setended	;IDA: loc_F342
	bset	#4,(BA_PS_flags).w
.checktimer	;IDA: loc_F348
	tst.w	(shootoutclock).w
	bne.w	.checkended
	bset	#4,(BA_PS_flags).w
.checkended	;IDA: loc_F356
	btst	#4,(BA_PS_flags).w
	bne.w	.finishshot
	rts
.finishshot	;IDA: loc_F362
	btst	#6,(BA_PS_flags).w
	bne.w	PenaltyShotEndReturn
	bset	#6,(BA_PS_flags).w
	move.w	#$A,d0
	jsr	(AddPenalty2).l
EndPenaltyShotPlay	;IDA: sub_F37C
	jsr	(freezewindow).l
	btst	#0,(gmode2).w
	bne.w	.stopplay
	move.w	#$A,(replaydelay).w
	bset	#2,(sflags2).w
.stopplay	;IDA: loc_F398
	bset	#0,(gmode).w
	bclr	#2,(gmode2).w
	bclr	#2,(BA_PS_flags).w
	bclr	#3,(BA_PS_flags).w
	bclr	#5,(BA_PS_flags).w
	bclr	#4,(BA_PS_flags).w
	bclr	#6,(BA_PS_flags).w
	movem.l	d0/a0,-(sp)
	movea.l	#SortCords,a0
	move.w	(BA_Sktr_SCnum).w,d0
	asl.w	#7,d0
	move.b	(savednewpnum).w,$61(a0,d0.w)
	movem.l	(sp)+,d0/a0
	jsr	(CountShootoutGoals).l
PenaltyShotEndReturn	;IDA: locret_F3E2
	rts
; this is where the action starts
puckfaceoff
	bclr	#4,(sflags8).w
	btst	#0,(gmode2).w
	beq.w	.normalfaceoff
	clr.w	(puckvx).w
	clr.w	(puckvy).w
	move.w	#$1E,d0	;assignment ECB6?
	bra.w	assreplace
.normalfaceoff	;IDA: loc_F404
	bclr	#1,$62(a3)
	beq.w	WaitForFaceoffLineChanges
	bclr	#0,(sflags8).w
	beq.w	.resetpads
	clr.w	(fox).w
	clr.w	(foy).w
.resetpads	;IDA: loc_F420
	bclr	#7,(sflags7).w
	clr.l	(padcont).w
	clr.l	(padcont+4).w
	clr.l	(padcont+8).w
	bclr	#6,(sflags7).w
	bclr	#2,(sflags7).w
	jsr	(CheckScoreLeader).l
	tst.w	(faceoffanim).w
	bmi.w	.choosefaceoffspot
	move.w	(faceoffanim).w,d0
	bra.w	.handlefaceoffspot
.choosefaceoffspot	;IDA: loc_F454
	jsr	(RandomFaceoffAnim).l
	tst.w	d0
	bmi.w	.checkperiod
.handlefaceoffspot	;IDA: loc_F460
	jsr	(SetFaceoffAnim).l
.checkperiod	;IDA: loc_F466
	bclr	#1,(sflags6).w
	bclr	#1,(gmode2).w
	tst.w	(gameclock).w
	beq.w	PeriodOver
	btst	#6,(gmode).w
	bne.w	PeriodOver
	cmpi.w	#3,(gsp).w
	bne.w	.npo
	move.w	(HmGoals).w,d0
	cmp.w	(AwGoals).w,d0
	bne.w	clockcont_0
.npo
	btst	#gmpendel,(gmode).w
	bne.w	Stop4Pen
	move.w	(PerTimeTotal).w,d0
	asr.w	#1,d0
	cmp.w	(gameclock).w,d0
	bls.w	.returngoalies
	cmpi.w	#$3C,(gameclock).w
	blt.w	.returngoalies
	bclr	#7,(sflags3).w
	beq.w	.returngoalies
	btst	#gmclock,(gmode).w
	beq.w	.returngoalies
	btst	#6,(sflags8).w
	bne.w	.returngoalies
	move.w	(HomeTeam).w,(HmTeam).w
	move.w	#2,(SongIndex).w
	jsr	(ChooseSong).l
	bset	#4,(sflags8).w
.returngoalies	;IDA: loc_F4F2
	bsr.w	ReturnGoalies
	st	temp1(a3)
	st	temp2(a3)
	tst.w	(OptLine).w
	bne.w	WaitForFaceoffLineChanges
	bclr	#1,(HmShots+tmflags).w
	bclr	#1,(AwShots+tmflags).w
	movea.w	#(SortCords-M68K_RAM),a0
	moveq	#$B,d0
.clearlcmloop	;IDA: loc_F518
	bclr	#3,pflags2(a0)
	adda.w	#SCstruct,a0
	dbf	d0,.clearlcmloop
	move.w	(cont1team).w,d0
	or.w	(cont2team).w,d0
	beq.w	.checkc1line
	btst	#sfhor,(sflags).w
	beq.w	.checkc1line
	bsr.w	forceblack
	bset	#sfslock,(sflags).w
	bsr.w	ClrHor
	move.w	#$18,(palcount).w
	tst.w	(OptLine).w
	bne.w	.checkc1line
	btst	#4,(sflags7).w
	beq.w	.checkc1line
	clr.w	(palcount).w
.checkc1line	;IDA: loc_F566
	move.w	(c1playernum).w,d0
	bmi.w	.checkc2line
	bsr.w	StartFaceoffLineChange
.checkc2line	;IDA: loc_F572
	move.w	(c2playernum).w,d0
	bmi.w	.checkcomputerline
	bsr.w	StartFaceoffLineChange
.checkcomputerline	;IDA: loc_F57E
	movea.w	#(HmShots-M68K_RAM),a1
	lea	tmsize(a1),a2
	moveq	#2,d0
	bsr.w	SetFaceoffComputerLine
	bra.w	WaitForFaceoffLineChanges
SetFaceoffComputerLine	;IDA: sub_F590
	tst.w	(OptLine).w
	bne.w	rtss2
	btst	#4,(sflags7).w
	bne.w	.dochange
	cmp.w	(cont1team).w,d0
	beq.w	rtss2
	cmp.w	(cont2team).w,d0
	beq.w	rtss2
.dochange	;IDA: loc_F5B2
	bsr.w	CompLine
	bsr.w	SetPersonel
	bsr.w	PrintScores1
	move.w	#$2710,(crowdnoisedelay).w
	rts
StartFaceoffLineChange	;IDA: sub_F5C6
	exg	a2,a3
	asl.w	#7,d0
	movea.w	#(SortCords-M68K_RAM),a3
	adda.w	d0,a3
	bclr	#3,$63(a3)
	move.l	a2,-(sp)
	bsr.w	SetLCmode
	movea.l	(sp)+,a2
	btst	#3,$63(a3)
	beq.w	.exit
	btst	#6,$62(a3)
	beq.w	.homeplayer
	move.w	#$168,$42(a2)
	move.w	$52(a3),$46(a2)
	bra.w	.exit
.homeplayer	;IDA: loc_F602
	move.w	#$258,$40(a2)
	move.w	$52(a3),$44(a2)
.exit	;IDA: loc_FDBC
	exg	a2,a3
	rts
WaitForFaceoffLineChanges	;IDA: loc_F612
	move.w	#$40,d0
	bsr.w	UpdateFaceoffLineChangeTimer
	move.w	#$42,d0
	bsr.w	UpdateFaceoffLineChangeTimer
	tst.w	$40(a3)
	bpl.w	rtss2
	tst.w	$42(a3)
	bpl.w	rtss2
	movea.w	#(HmShots-M68K_RAM),a2
	lea	$364(a2),a1
	moveq	#1,d0
	bsr.w	SetFaceoffComputerLine
	move.w	#$FFFF,(facelcwait).w
	move.w	#$1C,d0	;puckfaceoff2
	bra.w	assreplace
UpdateFaceoffLineChangeTimer	;IDA: sub_F64E
	tst.w	0(a3,d0.w)
	bmi.w	rtss2
	move.w	4(a3,d0.w),d1
	asl.w	#7,d1
	movea.w	#(SortCords-M68K_RAM),a0
	movea.w	#(HmShots-M68K_RAM),a2
	btst	#6,$62(a0,d1.w)
	beq.w	.checkactive
	adda.w	#$364,a2
.checkactive	;IDA: loc_F672
	btst	#3,$63(a0,d1.w)
	bne.w	.countdown
	st	0(a3,d0.w)
	bra.w	SetLCmode2
.countdown	;IDA: loc_F684
	sub.w	d7,0(a3,d0.w)
	bpl.w	rtss2
	move.l	a3,-(sp)
	lea	0(a0,d1.w),a3
	btst	#3,$63(a3)
	beq.w	.exit
	clr.w	d2
	bsr.w	lcfound
	bsr.w	SetLCmode2
.exit	;IDA: loc_FDBC
	movea.l	(sp)+,a3
	rts
; computer pulls goalie on delayed penalty
ChkGoalies
	btst	#gmclock,(gmode).w	;check if clock running
	bne.w	rtss2
	movea.w	#(HmShots-M68K_RAM),a2
	lea	tmsize(a2),a1
	moveq	#1,d0
	bsr.w	.chkgoalie
	moveq	#2,d0
	exg	a1,a2
.chkgoalie
	tst.w	tmgoalie(a2)	;check for goalie
	bmi.w	rtss2	;no goalie, exit
	move.w	(puckc).w,d1	;move puck carrier SCnum into d1
	bmi.w	rtss2
	subq.w	#6,d1
	cmpa.w	#$C6CE,a2
	beq.w	.chkpen
	not.w	d1	;makes d1 negative if away team
.chkpen
	tst.w	d1
	bpl.w	rtss2
	btst	#gmpendel,(gmode).w	;#gmpendel - delayed penalty called
	beq.w	.nopen
	st	tmgoalie(a2)	;sets to FFFF (no goalie)
	bra.w	SetPersonel
.nopen
	cmp.w	(cont1team).w,d0
	beq.w	rtss2	;exit if team is joy controlled
	cmp.w	(cont2team).w,d0
	beq.w	rtss2	;exit if team is joy controlled
	move.w	(pucky).w,d1
	bra.w	CPgoalie
; if computer pulled goalie, look to see if computer should return him
ReturnGoalies
	movea.w	#(HmShots-M68K_RAM),a2
	lea	tmsize(a2),a1
	moveq	#1,d0
	bsr.w	.r
	moveq	#2,d0
	exg	a1,a2
.r
	cmpi.w	#$FFFF,tmgoalie(a2)
	beq.w	rtss2	;still no goalie
	clr.b	tmgoalie(a2)	;clear for goalie return
	cmp.w	(cont1team).w,d0
	beq.w	rtss2	;exit if team is joy controlled
	cmp.w	(cont2team).w,d0
	beq.w	rtss2	;exit if team is joy controlled
	move.w	(foy).w,d1
; see if computer should pull his goalie
; d1 = Faceoff Y position
CPgoalie
	cmpi.w	#2,(gsp).w	;check if 3rd period
	bne.w	rtss2	;exit if not
	move.w	tmscore(a1),d0	;tmscore
	sub.w	tmscore(a2),d0
	bmi.w	rtss2	;exit if leading in the game
	cmp.w	#2,d0
	bne.w	rtss2	;exit if behind by more than 2
	cmpi.w	#$3C,(gameclock).w	;'<' ; #60
	bgt.w	rtss2	;exit if more than 1 min left
	move.l	a0,-(sp)
	movea.w	tmsort(a2),a0	;moves a player struct address into a0
	btst	#pfgoal,pflags(a0)	;#pfgoal
	movea.l	(sp)+,a0
	bne.w	.0
	neg.w	d1	;if shooting on bottom goal, make d1 negative
.0	;IDA: loc_E65A
	tst.w	d1
	bmi.w	rtss2	;exit if d1 negative (faceoff in own zone)
	st	tmgoalie(a2)	;set to FFFF (no goalie)
	bra.w	SetPersonel
; find good line for comp to switch to
CompLine
	movem.l	d0-d2/a0,-(sp)
	moveq	#3,d0
	move.w	tmap(a2),d1	;tmap
	sub.w	tmap(a1),d1
	beq.w	.nopwr
	bpl.w	.0
	addq.w	#2,d0
.0	;IDA: loc_E65A
	move.w	d0,-(sp)	;find pk/pp line
	bsr.w	getlinee
	move.w	d0,d1
	move.w	(sp),d0
	addq.w	#1,d0
	bsr.w	getlinee
	cmp.w	d0,d1
	bge.w	.1
	addq.w	#1,(sp)
.1
	move.w	(sp)+,tmline(a2)	;tmline
.ex	;IDA: loc_E694
	movem.l	(sp)+,d0-d2/a0
	rts
.nopwr
	cmpa.w	#$C6CE,a2	;find normal line
	bne.w	.away
	moveq	#2,d1
	lea	.hl1(pc),a0
	cmpi.w	#2,(gsp).w
	bne.w	.h0
	move.w	tmscore(a2),d2	;tmscore
	cmp.w	tmscore(a1),d2
	beq.w	.h0
	adda.w	#$E,a0
	bgt.w	.h0
	adda.w	#$E,a0
.h0
	move.w	tmline(a1),d1	;tmline
	asl.w	#1,d1
	move.w	0(a0,d1.w),d0
	bsr.w	getlinee
	cmp.w	#$C00,d0	;#(3*$1000)/4
	bls.w	.away
	move.w	0(a0,d1.w),$16(a2)	;tmline
	bra.s	.ex
.hl1
	dc.w	0
	dc.w	1
	dc.w	2
	dc.w	0
	dc.w	1
	dc.w	0
	dc.w	1
	dc.w	2
	dc.w	0
	dc.w	1
	dc.w	2
	dc.w	0
	dc.w	2
	dc.w	0
	dc.w	0
	dc.w	1
	dc.w	0
	dc.w	0
	dc.w	1
	dc.w	0
	dc.w	1
.away
	moveq	#2,d1
	lea	.al1(pc),a0
	cmpi.w	#2,(gsp).w
	bne.w	.a0
	move.w	tmscore(a2),d2	;tmscore
	cmp.w	tmscore(a1),d2
	beq.w	.a0
	addq.w	#6,a0
	bgt.w	.a0
	addq.w	#6,a0
.a0
	move.w	(a0)+,d0
	bsr.w	getlinee
	cmp.w	#$C00,d0	;#(19*$1000)/20
	dbhi	d1,.a0
	move.w	-(a0),tmline(a2)	;tmline
	bra.w	.ex
.al1
	dc.w	0
	dc.w	1
	dc.w	2
	dc.w	0
	dc.w	2
	dc.w	1
	dc.w	0
	dc.w	1
	dc.w	0
; face off control logic and general setup for action
puckfaceoff2
	bclr	#1,$62(a3)
	beq.w	.nna
	bclr	#2,(BA_PS_flags).w
	bclr	#5,(BA_PS_flags).w
	bclr	#0,(sflags4).w
	bclr	#1,(sflags4).w
	bclr	#0,(DelayedPen).w
	bclr	#1,(DelayedPen).w
	bclr	#2,(DelayedPen).w
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	forceblack
.p
	btst	#dfok,(disflags).w
	bne.s	.p
	move	sr,-(sp)
	move.w	#$3C,(holdreset).w
	tst.w	(fox).w
	bne.w	.lockinterrupts
	tst.w	(foy).w
	bne.w	.lockinterrupts
	move.w	#$FFFF,(faceoffanim).w
	bra.w	.limitcrowd
.lockinterrupts	;IDA: loc_F8F4
	move	#$2700,sr
.limitcrowd	;IDA: loc_F8F8
	cmpi.w	#$258,(crowdlevel).w
	bls.w	.ntm
	move.w	#$258,(crowdlevel).w	;limit crowd level
.ntm
	bset	#dfclock,(disflags).w	;stop clock
	bclr	#sfpz,(sflags).w	;no pause
	bclr	#sf3llcs,(sflags3).w	;no line changes
	clr.w	(glovecords).w	;no fighting gloves
	clr.b	(iflags).w	;no icing
	st	(RefCnt).w	;no refs
	st	(puckcross2).w	;no goalie moves
	st	(puckcross6).w
	bclr	#sf2refref,(sflags2).w	;no ref refresh
	bset	#sf2faceoff,(sflags2).w	;face off in progress
	bset	#sf2drec,(sflags2).w	;dont record yet
	st	(passplayer).w
	st	(onetimerplayer).w
	bset	#4,(disflags).w
	bsr.w	ClrHor	;vertical ice rink
	move.w	#$2710,(crowdnoisedelay).w
	clr.w	(Vpos).w	;clear h/v pos
	clr.w	(Hpos).w
	move.w	(fox).w,(puckx).w
	move.w	(foy).w,(pucky).w
	st	(puckz).w	;no visible puck
	clr.w	(puckvx).w
	clr.w	(puckvy).w
	clr.w	(puckvz).w
	st	(puckc).w
	movea.w	#(SortCords+(12*SCstruct)-M68K_RAM),a0	;reposition goal nets
	clr.w	Xvel(a0)	;Xvel
	clr.w	Yvel(a0)	;Yvel
	clr.w	(a0)	;Xpos
	move.w	#$10C,Ypos(a0)	;Ypos
	adda.w	#SCstruct,a0	;add SCstruct to move to next goal net
	clr.w	Xvel(a0)
	clr.w	Yvel(a0)
	clr.w	(a0)
	move.w	#$FEF4,Ypos(a0)	;Ypos
	movea.w	#(SortCords+((puckscnum+1)*SCstruct)-M68K_RAM),a0	;move to puck shadow SCnum
	move.w	#$18A,frame(a0)	;#SPFpuck, Frame
	clr.w	SPA(a0)	;SPA
	clr.w	attribute(a0)	;attribute
	clr.w	(SortCords+(puckscnum*SCstruct)+attribute).w	;clear puck SCnum attribute
	bclr	#sfslock,(sflags).w
	moveq	#$64,d4
.cw
	bsr.w	checkwindow	;scroll to faceoff spot
	dbf	d4,.cw
	move.w	#$3C,(yleader).w
	bsr.w	ResetBench
	movea.w	#(HmShots-M68K_RAM),a2
	bsr.w	SetPersonel
	bsr.w	forcepldata
	adda.w	#tmsize,a2
	bsr.w	SetPersonel
	bsr.w	forcepldata
	bsr.w	resetplstuff
	move.l	a3,-(sp)
	movea.w	#(SortCords-M68K_RAM),a3
	moveq	#$B,d2
.10
	move.w	#$FF10,(a3)	;-240, Xpos
	clr.w	Ypos(a3)	;Ypos
	clr.w	frame(a3)	;frame
	move.w	position(a3),d1	;position
	bmi.w	.next
	beq.w	.goalie1
	move.l	#$16,d0	;#afaceoff - assignment faceoff
	cmp.w	#4,d1	;find the center (position 4)
	bne.w	.11
	movea.w	#(HmShots-M68K_RAM),a2
	btst	#pfteam,pflags(a3)	;#pfgoal - what goal to score on
	beq.w	.clr
	adda.w	#tmsize,a2
.clr
	clr.w	$18(a2)
	move.b	pnum(a3),$19(a2)	;66(a3) = player offset on roster 19(a2) = player who touches puck
	bclr	#7,(sflags8).w
	st	$1A(a2)	;clear last player to touch puck (assist 1)
	st	$1C(a2)	;clear second last player to touch puck (assist 2)
	bclr	#3,tmflags(a2)
	move.l	#$17,d0	;#afaceoffpl - faceoff player assignment
.11
	bsr.w	assinsert
.goalie1
	move.w	(HmShots+tmap).w,d4	;tmap = active players on ice (4-6). IDA (tmap).w
	btst	#pfteam,pflags(a3)	;#pfteam - 0=home 1=away
	beq.w	.t0
	move.w	(AwShots+tmap).w,d4	;IDA (tmsize).w
.t0
	neg.w	d4
	addq.w	#6,d4
	asl.w	#3,d4
	movea.l	#$FCEE,a1	;#.apl
	adda.w	d4,a1
	move.b	0(a1,d1.w),d4
	asl.w	#2,d4
	movea.l	#$FD06,a1	;#.ptab
	move.w	0(a1,d4.w),d0
	move.w	2(a1,d4.w),d1
	btst	#pfgoal,pflags(a3)	;#pfgoal - 0=bottom, 1=top
	bne.w	.f0
	neg.w	d0
	neg.w	d1
.f0
	tst.w	position(a3)	;check for goalie
	beq.w	.goalie2
	cmp.w	#8,d4
	bgt.w	.nodef
	move.w	(fox).w,d3
	eor.w	d0,d3
	bpl.w	.notmid
	move.w	(foy).w,d3
	asr.w	#3,d3
	sub.w	d3,d1
.notmid
	move.w	(fox).w,d3
	asr.w	#2,d3
	sub.w	d3,d0
.nodef
	add.w	(fox).w,d0
	add.w	(foy).w,d1
.goalie2
	move.w	d0,(a3)	;Xpos
	move.w	d1,Ypos(a3)	;Ypos
	clr.w	Xvel(a3)	;Xvel
	clr.w	Yvel(a3)	;Yvel
	sub.w	(puckx).w,d0
	sub.w	(pucky).w,d1
	neg.w	d0
	neg.w	d1
	bsr.w	vtoa
	move.w	d0,facedir(a3)	;facedir
	bclr	#2,pflags2(a3)	;#pf2unav
	bclr	#pfalock,pflags(a3)	;#pfalock
	move.w	#$50C,d1	;#SPAglide
	bsr.w	SetSPA
.next
	adda.w	#$80,a3	;#Scstruct
	dbf	d2,.10
	bsr.w	SprSort
	movea.l	(sp)+,a3
	bsr.w	ResetAndSelectPlayers
	move.w	(ExtraChars).w,d4
	movea.l	#FaceOffMap+8,a2
	jsr	(DoDMA_clearCallbackPointer).l
	move.w	d4,(faceoffvrcset).w
	movea.l	#FaceOffSprites+8,a2
	bsr.w	DoDMA_clearCallbackPointer
	move.w	#$FFFF,(arenaanim).w
	btst	#0,(sflags7).w
	beq.w	.drawfaceoffwindow
	move.w	(faceoffanim).w,d0
	bmi.w	.drawfaceoffwindow
	jsr	(StartArenaAnim).l
.drawfaceoffwindow	;IDA: loc_FB54
	bsr.w	printz
	dc.b	0,6,$FF,0,0,0
	moveq	#$36,d0	;'6'   ; X Position of the faceoff window
	tst.w	(fox).w
	bpl.w	.fok
	move.w	#$BE,d0
.fok
	move.w	d0,(fodropx).w
	subi.w	#$2E,d0
	asr.w	#3,d0
	move.w	d0,(printx).w
	moveq	#$5C,d0	;'\'   ; Y position of the faceoff window
	move.w	d0,(fodropy).w
	subi.w	#$44,d0
	asr.w	#3,d0
	move.w	d0,(printy).w
	move.w	(ExtraChars).w,d4	;space for faceoff map
	movea.l	#FaceOffMap,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$C,d2
	moveq	#$A,d3
	moveq	#0,d5
	bset	#0,(sflags6).w
	bsr.w	dobitmap
	bclr	#0,(sflags6).w
	tst.w	(OptLine).w
	bne.w	.setdroptime
	bsr.w	printz2
	String	$FA,$A,$FE,4		;$FBC2. IDA shows ori.b #$A,d6 and drops the $FE04 word
	moveq	#$C,d0
	moveq	#3,d1
	bsr.w	Framer
	move.w	(HmShots+tmline).w,d0
	move.w	(AwShots+tmline).w,d1
	btst	#gmdir,(gmode).w
	bne.w	.printline2
	exg	d0,d1
.printline2	;IDA: loc_FBE4
	bsr.w	printz2
	String	$FB,1,$FA,$FE		;$FBE8. IDA shows ori.b #1,d6 and drops the $FAFE word
	movea.l	#linelist,a1
	bsr.w	PrintStringFromList
	addq.w	#4,(printx).w
	move.w	d1,d0
	movea.l	#linelist,a1
	bsr.w	PrintStringFromList
.setdroptime	;IDA: loc_FC08
	move.w	#$78,d0
	bsr.w	randomd0
	addi.w	#$B4,d0
	cmpi.w	#0,(arenaanim).w
	beq.w	.chkmintime
	cmpi.w	#1,(arenaanim).w
	beq.w	.chkmintime
	cmpi.w	#5,(arenaanim).w
	beq.w	.chkmintime
	cmpi.w	#4,(arenaanim).w
	beq.w	.chkmintime
	cmpi.w	#2,(arenaanim).w
	bne.w	.time
.chkmintime
	cmp.w	#$10E,d0
	bgt.w	.time
	move.w	#$10E,d0	;sets minimum value in d0 to 10E
.time
	move.w	d0,temp1(a3)	;time for puck drop
	move.w	#$18,(palcount).w
	movea.l	#fofdata2,a0
	move.w	#1,(a0)
	move.w	#$8000,2(a0)
	move.w	#4,4(a0)
	move.w	#$A800,6(a0)
	move.w	#7,8(a0)	;frame of ref
	move.w	#$8000,$A(a0)
	btst	#gmdir,(gmode).w	;#gmdir - 0 = home team goes up
	bne.w	.nfl
	eori.w	#$800,2(a0)
	eori.w	#$800,6(a0)
.nfl
	move.w	#$FFFF,(fodir1).w	;-1
	move.w	#$FFFF,(fodir2).w	;-1
	jsr	(LeadSong).l
	bclr	#6,(sflags8).w
	bne.w	.playqueuedsong
	bclr	#4,(sflags8).w
	beq.w	.restorestate
.playqueuedsong	;IDA: loc_FCC0
	bclr	#4,(sflags8).w
	move.w	(SongNum).w,-(sp)
	bsr.w	song
.restorestate	;IDA: loc_FCCE
	move.w	#$18,(palcount).w
	move	(sp)+,sr
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.nna
	subq.w	#1,temp1(a3)
	bpl.w	updatefaceoff
	jsr	(EndArenaAnim).l
	bra.w	Endfaceoff
.apl	dc.b	0
	dc.b	1,2,3,4,5,6,0,0,1,5,3,4,2,0,0,0
	dc.b	3,5,1,4,0,0,0
.ptab
	dc.w	0
	dc.w	$FF06
	dc.w	$FFDD
	dc.w	$FFCE
	dc.w	$23
	dc.w	$FFCE
	dc.w	$FFCE
	dc.w	$FFF6
	dc.w	0
	dc.w	$FFF1
	dc.w	$32
	dc.w	$FFF6
	dc.w	0
	dc.w	$FFC4
ResetAndSelectPlayers	;IDA name (93 ResetAndSelectPlayers). c1playernum / c2playernum = -1, then changeplayer for each human team	;IDA: setchgplayer
	move.w	#$FFFF,(c1playernum).w
	move.w	#$FFFF,(c2playernum).w
	tst.w	(cont1team).w
	beq.w	.checkcont2
	clr.w	d4
	bsr.w	changeplayer
.checkcont2	;IDA: loc_FD3C
	tst.w	(cont2team).w
	beq.w	.checkcont3
	moveq	#2,d4
	bsr.w	changeplayer
.checkcont3	;IDA: loc_FD4A
	tst.w	(cont3team).w
	beq.w	.checkcont4
	move.w	(cont1team).w,-(sp)
	move.w	(cont3team).w,(cont1team).w
	move.w	(c1playernum).w,-(sp)
	move.w	#$FFFF,(c1playernum).w
	clr.w	d4
	jsr	(changeplayer).l
	move.w	(c1playernum).w,(c3playernum).w
	move.w	(cont1team).w,(cont3team).w
	move.w	(sp)+,(c1playernum).w
	move.w	(sp)+,(cont1team).w
.checkcont4	;IDA: loc_FD82
	tst.w	(cont4team).w
	beq.w	.exit
	move.w	(cont2team).w,-(sp)
	move.w	(cont4team).w,(cont2team).w
	move.w	(c2playernum).w,-(sp)
	move.w	#$FFFF,(c2playernum).w
	move.w	#2,d4
	jsr	(changeplayer).l
	move.w	(c2playernum).w,(c4playernum).w
	move.w	(cont2team).w,(cont4team).w
	move.w	(sp)+,(c2playernum).w
	move.w	(sp)+,(cont2team).w
.exit	;IDA: loc_FDBC
	rts
updatefaceoff
	move.w	temp1(a3),d0
	beq.w	.erase
	addq.w	#6,d0
	lsr.w	#3,d0
	cmp.w	#2,d0
	bgt.w	rtss2
	neg.w	d0
	addi.w	#$A,d0
	move.w	d0,(fofdata).w
	rts
.erase	;IDA: loc_FDDE
	bclr	#4,(disflags).w
	bsr.w	printz
	String	$BF,0,0,0		;$FDE6. IDA hid this and the next five instructions in ori.b / cmp.b
	move.w	(fodropx).w,d0
	subi.w	#$2E,d0
	asr.w	#3,d0
	move.w	d0,(printx).w
	moveq	#$64,d0
	move.w	(fodropy).w,d0
	subi.w	#$44,d0
	asr.w	#3,d0
	move.w	d0,(printy).w
	moveq	#$C,d0
	moveq	#$D,d1
	move.w	#$7FF,d2
	bra.w	eraser
Endfaceoff
	move.w	#$2F,-(sp)
	bsr.w	sfx
	bclr	#sf2faceoff,(sflags2).w
	move.w	#$3C,(holdreset).w
	move.w	(ExtraChars).w,d4
	movea.l	#RefsMap+8,a2
	bsr.w	DoDMA_clearCallbackPointer
	bclr	#sf2drec,(sflags2).w
	bclr	#gmclock,(gmode).w
	bclr	#pf2fight,pflags2(a3)
	clr.w	(crowdnoisedelay).w
	bset	#4,(sflags3).w
	move.w	(fodir1).w,d3
	move.w	#$800,d4
	movea.l	#$FF06,a0
	movea.w	#(fofdata2-M68K_RAM),a1
	moveq	#$10,d2
	move.w	(a1),d1
	sub.b	-1(a0,d1.w),d2
	move.w	4(a1),d1
	add.b	-1(a0,d1.w),d2
	moveq	#$21,d0
	bsr.w	randomd0
	cmp.b	d0,d2
	bls.w	.p1won
	addq.w	#4,a1
.p1won
	btst	#3,2(a1)
	beq.w	.pos
	move.w	(fodir2).w,d3
	neg.w	d4
.pos
	move.w	d3,d0
	btst	#3,d0
	bne.w	.nojoy
	andi.w	#7,d0
	move.w	(VDP_CNTR).l,d1
	andi.w	#3,d1
	bne.w	.nj2
.nojoy
	moveq	#5,d0
	bsr.w	randomd0
	subq.w	#2,d0
	andi.w	#7,d0
	tst.w	d4
	bmi.w	.nj2
	eori.w	#4,d0
.nj2
	asl.w	#2,d0
	movea.l	#dirtab,a0
	move.w	0(a0,d0.w),d1
	asl.w	#5,d1
	move.w	d1,Xvel(a3)
	move.w	2(a0,d0.w),d1
	asl.w	#5,d1
	add.w	d4,d1
.setpuckvy	;IDA: loc_FEE2
	move.w	d1,Yvel(a3)
	move.w	#$800,d0
	bsr.w	randomd0
	move.w	d0,Zvel(a3)
	clr.w	(puckz).w
	bclr	#pfnc,pflags(a3)
	move.l	#$18,d0	;pucknorm
	bra.w	assreplace
.ftab
	dc.b	0,8,$10,0,8,$10
; assignment for puck most of the time
; a3 = puck
; d7 = elapse frames since last call
pucknorm
	btst	#2,(BA_PS_flags).w	;check if flag is clear (normal play)
	beq.w	.normalplay
	bsr.w	UpdatePenaltyShotEnd
.normalplay	;IDA: loc_FF1A
	bclr	#pfna,pflags(a3)	;#pfna clear
	beq.w	.nna
	clr.w	temp1(a3)	;temp1
	move.w	#$78,temp2(a3)	;'x' ; temp2
.nna
	movea.w	#(puckcross-M68K_RAM),a1	;table for puck crossing lines
	sub.w	d7,2(a1)	;sub elapse frames from time til crossing
	sub.w	d7,6(a1)
	sub.w	d7,temp1(a3)	;temp1
	bpl.w	.0
	addq.w	#5,temp1(a3)
	bsr.w	findpc
.0	;IDA: loc_E65A
	move.w	(puckc).w,d0
	bmi.w	.nothandled
	asl.w	#7,d0	;#scsize
	movea.w	#(SortCords-M68K_RAM),a2
	adda.w	d0,a2
	bsr.w	a2touchpuck
	move.l	a2,-(sp)
	bsr.w	GetHot
	add.w	(a2),d0	;Xpos - bungie the puck towards the hot spot on player a2
	sub.w	(a3),d0
	asr.w	#2,d0
	add.w	d0,(a3)
	add.w	Ypos(a2),d1	;Ypos
	sub.w	Ypos(a3),d1
	asr.w	#2,d1
	add.w	d1,Ypos(a3)
	move.w	Xvel(a2),Xvel(a3)	;Xvel
	move.w	Yvel(a2),Yvel(a3)	;Yvel
.nothandled
	bsr.w	puckIChk
	bsr.w	ChkOffsides
	btst	#0,(gmode).w	;check for play stoppage
	bne.w	.end
	tst.w	(puckc).w
	bpl.w	.resetstilltimer
	move.w	(a3),d0	;Xpos
	cmp.w	OldXpos(a3),d0	;oldXpos
	bne.w	.resetstilltimer
	move.w	Ypos(a3),d0	;Ypos
	cmp.w	OldYpos(a3),d0	;oldYpos
	bne.w	.resetstilltimer
	move.l	#6,d0
	subq.w	#1,temp2(a3)	;temp3
.maybepenalty	;IDA: loc_FFC0
	bpl.w	.stillpuckdone
	bsr.w	AddPenalty2
.stillpuckdone	;IDA: loc_FFC8
	bra.w	.end
.resetstilltimer	;IDA: loc_FFCC
	move.w	#$78,temp2(a3)	;'x' ; move 78 hex into temp2
.end
	tst.b	Zvel(a3)	;Zvel
	bne.w	checkpuckcoll
	tst.w	Zpos(a3)	;Zpos
	bne.w	checkpuckcoll
	bsr.w	puckunflip
	bra.w	checkpuckcoll
