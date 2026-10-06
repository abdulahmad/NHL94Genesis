;	NHL 94 (retail) segment $E62E-$FFE9
;	92 Logic.Asm part 4, as 93 logic93_4.asm: checkob, assnearest, check4check, asspassrec, assshoot, the 94 shootout /
;	penalty shot code (puckshootout, puckpenshot), puckfaceoff, ChkGoalies, ReturnGoalies, CPgoalie, CompLine,
;	puckfaceoff2, setchgplayer, updatefaceoff, Endfaceoff, pucknorm. ChkOffsides (logic94_5) follows at $FFEA.
;	Transcribed from lst/nhl94.bin.lst lines 40493-42593. Global names are the IDA names; 94-only routines keep the
;	IDA auto names. Local labels are the IDA local names (_x -> .x, gmclock -> .gmclock) or the IDA address
;	(loc_E6A0 -> .E6A0). loc_F612 and locret_F3E2 stay global: they are used across a global label.
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
	cmpi.w	#6,$52(a3)
	blt.w	.E65A
	adda.w	#$300,a0
.E65A
	moveq	#$5C,d1
	btst	#7,$62(a3)
	bne.w	.E6B0
	neg.w	d1
	cmp.w	(pucky).w,d1
	bgt.w	.E688
.E670
	tst.w	$34(a0)
	bmi.w	.E680
	cmp.w	$14(a0),d1
	bgt.w	.E69A
.E680
	adda.w	#$80,a0
	dbf	d0,.E670
.E688
	moveq	#$40,d0
	bclr	#7,(sflags2).w
	bne.w	.E6A4
.E694
	movem.l	(sp)+,d0-d1/a0
	rts
.E69A
	moveq	#6,d0
	bset	#7,(sflags2).w
	bne.s	.E694
.E6A4
	tst.w	(RefCnt).w
	bpl.s	.E694
	bsr.w	PushRef
	bra.s	.E694
.E6B0
	cmp.w	(pucky).w,d1
	blt.s	.E688
.E6B6
	tst.w	$34(a0)
	bmi.w	.E6C4
	cmp.w	$14(a0),d1
	blt.s	.E69A
.E6C4
	adda.w	#$80,a0
	dbf	d0,.E6B6
	bra.s	.E688
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
	bclr	#2,(word_FFC2F6).w
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
	movea.l	#$FFFFC6CE,a2	;put Home Team Struct into a2
	btst	#6,$62(a3)	;pfteam - check home or away
	beq.w	.addcrowd	;jump if home
	movea.l	#$FFFFCA32,a2	;put Away Team Struct into a2
.addcrowd
	addq.w	#1,$358(a2)	;add to breakaway attempt
	addi.w	#$14,(CwdExciteLvl).w	;add to excite level
	addi.w	#$C8,(crowdlevel).w	;add to crowd level
	movem.l	(sp)+,a2	;pop off stack into a2
.nobreak
	clr.w	$44(a3)	;clear temp3
	move.w	#8,$42(a3)	;move 8 into temp2
	clr.w	$40(a3)	;clear temp1
.nna
	move.w	$52(a3),d1	;checks if puck carrier
	cmp.w	(puckc).w,d1
	bne.w	.nopc	;jumps if not
	tst.w	$34(a3)	;check if goalie
	beq.w	assgoaliecpu	;branch if goalie
	move.l	#$10,d0	;10 = asspuckc
	btst	#3,$62(a3)	;pfjoycon - check if controlled
	beq.w	assinsert	;jump if not
	rts
.nopc
	sub.b	d7,$40(a3)	;subtract d7 (elapsed frames) from temp1
	bpl.w	.nodec	;jump if positive
	move.b	$6A(a3),$40(a3)	;move aioff into temp1
	jsr	(ReadGoaliePulled).l	;check if goalie is pulled
	bmi.w	.bonus
	btst	#6,(byte_FFC2FC).w	;check if crowd meter currently broken
	beq.w	.nopc2	;jump if not broken
	tst.b	$40(a3)	;check if temp1 is 0
	beq.w	.nopc2	;jump if so
.bonus
	subq.b	#1,$40(a3)	;subtract 1 from temp1
.nopc2
	btst	#5,(word_FFC2F8).w	;check if slot bit is set (puckc in slot)
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
	move.b	$62(a1),d0	;pflags of puck carrier
	move.b	$62(a3),d1	;pflags of current player
	eor.b	d0,d1	;XOR pflags
	btst	#6,d1	;check pfteam
	beq.w	.switch	;branch if on same team
.np
	moveq	#-1,d2	;-1
	moveq	#5,d4	;5 = # of players on team
	movea.w	$22(a2),a0	;SortCord start value for team
.de0
	tst.w	$34(a0)	;check if goalie
	ble.w	.next	;branch if goalie
	tst.b	$5E(a0)	;check if nopuck (cant touch puck)
	bne.w	.next	;branch if nopuck timer not 0
	btst	#2,$63(a0)	;pf2unav - unavailable
	bne.w	.next	;branch if unavailable
	move.w	$36(a0),d0	;assnum - current assignment
	cmpi.b	#$13,$38(a0,d0.w)	;check if current assignment is asspassrec
	beq.w	.next	;branch if a0 is going to receive puck
	move.l	a0,-(sp)	;push onto stack
	bsr.w	GetHot	;get hot spot
	add.w	(a0),d0	;Xpos to d0
	sub.w	(puckx).w,d0	;sub puck Xpos
	add.w	$14(a0),d1	;add Ypos to d1
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
	adda.w	#$80,a0	;SCstruct size
	dbf	d4,.de0	;iterate through loop
	tst.l	d2	;check if 0
	bmi.w	.de1	;branch if less (no one near puck)
	move.l	d2,$2A(a2)	;moves d2 into $2A(a2)
.switch
	cmpa.w	a1,a3	;a1 = closest to the puck, or puckc (if on same team)
	beq.w	.de1	;branch if same
	btst	#0,(gmode).w	;gmclock - 1 if stopped
	bne.w	.de1	;jump if stopped
	btst	#2,$63(a1)	;pf2unav
	bne.w	.de1	;jump if unavailable
	btst	#3,$64(a1)	;shooting one timer
	bne.w	.de1	;jump if shooting
	exg	a1,a3	;swap addresses
	bclr	#0,$62(a3)	;clear pfdoff
	move.l	#$11,d0	;assnearest
	bsr.w	assinsert
	exg	a1,a3
	bra.w	assexit
.de1
	btst	#5,$62(a3)	;pfalock - check if locked in animation
	bne.w	rtss2	;exit if locked
	moveq	#2,d1	;move 2 into d1
	cmp.w	#$190,d2	;compare $190 (20^2) to d2. d2 = distance to puck^2
	bhi.w	.nfar	;branch if d2 higher
	subq.w	#2,d1
	cmpi.w	#2,$34(a3)	;compare if position is F or D (1 and 2 are D)
	bls.w	.nodec	;jump if D
.nfar
	btst	#5,(sflags2).w	;sf2pwrplay - check if PP
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
	move.w	#$F0,$44(a3)	;move 240 dec into temp3
.nodec
	btst	#5,$62(a3)	;pfalock - check if anim lock
	bne.w	rtss2	;exit if locked
	btst	#2,(BA_PS_flags).w	;check bit 2
	beq.w	.gmclock	;jump if not set
	btst	#5,(BA_PS_flags).w	;check bit 5
	beq.w	.nodec2	;jump if not set
.gmclock	;IDA: gmclock (a 92 equate name; local so it does not split assnearest or clash with the equate)
	btst	#0,(gmode).w	;check if clock running
	bne.w	assnothing	;branch if not
.nodec2
	btst	#3,$62(a3)	;pfjoycon - check if controlled
	bne.w	rtss2	;jump if controlled
	btst	#2,$30(a2)	;check bit 2 of $30(a2)
	bne.w	.nodec22
	tst.w	(puckc).w	;check if theres a puck carrier
	bmi.w	.topuck	;jump if no puck carrier
	sub.w	d7,$44(a3)	;subtract frames from temp3
	bpl.w	.topuck	;jump if positive
	clr.w	$44(a3)	;clear temp3
.nodec22
	bsr.w	skatetopuckinit
	movem.w	d0-d1,-(sp)	;d0 = future puckx, d1 = future pucky push on stack
	neg.w	d0
	neg.w	d1
	addi.w	#$F4,d1	;add goalline - 20 decimal
	btst	#7,$62(a3)	;pfgoal - check what net shooting on
	beq.w	.nd0	;branch if bottom
	subi.w	#$1E8,d1	;sub bottom goalline - 20 decimal
.nd0
	asr.w	#1,d0	;divide by 2
	asr.w	#1,d1	;divide by 2
	add.w	(sp)+,d0	;add original future puckx
	add.w	(sp)+,d1	;add original future pucky
	btst	#2,$30(a2)	;?? - doesn't seem to be set anywhere
	beq.w	.spdboost
	btst	#7,$62(a3)	;pfgoal
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
	btst	#5,(word_FFC2F8).w	;check if puckc is in the slot
	beq.w	.noslot	;branch if not
	move.b	$69(a3),(TempLegSpd).w	;legspd into FFBF1E
	addq.b	#6,$69(a3)	;add 6 to legspd
	btst	#1,(byte_FFC2FE).w	;check if crowd meter broken (always is)
	bne.w	.spdboostex	;jump if set
	btst	#6,(byte_FFC2FC).w	;check if crowd meter currently broken
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
	btst	#5,(word_FFC2F8).w
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
.exit
	rts
.chkcont
	btst	#5,(word_FFC2F8).w	;check if puckc is in the slot
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
	cmpi.w	#6,$52(a3)	;check if player on home team
	bge.w	.0	;branch if away
	adda.w	#$300,a0	;add if home (checks opposite team in loop)
.0
	tst.w	$34(a0)	;check if goalie
	beq.w	.next	;branch if goalie
	btst	#5,$62(a0)	;check if locked in anim
	bne.w	.next	;branch if locked
	btst	#0,$63(a0)	;check if fighting
	bne.w	.next	;branch if fighting
	move.w	(a0),d0	;move Xpos into d0
	sub.w	(a3),d0	;sub a3 from a0
	cmp.w	#$1E,d0	;compare to 30 decimal
	bgt.w	.next	;branch if more than 30 decimal
	cmp.w	#$FFE2,d0	;compare to -30 decimal
	blt.w	.next	;branch if less than -30
	move.w	$14(a0),d1	;Ypos
	sub.w	$14(a3),d1	;subtract checker Ypos from d1
	cmp.w	#$1E,d1	;compare to 30 decimal
	bgt.w	.next	;branch if more
	cmp.w	#$FFE2,d1	;check with -30 decimal
	blt.w	.next	;branch if less
	bsr.w	vtoa	;determine direction
	cmp.w	$54(a3),d0	;compare facedir with vtoa result
	bne.w	.next	;branch if not facing in that direction
	btst	#5,(word_FFC2F8).w	;check if puckc in slot
	bne.w	Acheck	;branch if in slot
	move.w	(VDP_CNTR).l,d0	;move HVcounter into d0
	andi.w	#3,d0	;pass first 2 bits
	bne.w	burst	;throw check
	bra.w	Acheck
.next
	adda.w	#$80,a0	;move to next SCstruct
	dbf	d2,.0
	rts
; assignment for catching pass
asspassrec
	btst	#5,$62(a3)	;pfalock - animation lock
	bne.w	rtss2	;exit if locked
	btst	#0,(gmode).w	;gmclock - check if clock running
	bne.w	assnothing	;exit if clock stopped
	btst	#3,$62(a3)	;pfjoycon - joystick controlled?
	bne.w	assexit	;exit if controlled
	bclr	#1,$62(a3)	;#pfna - clear new assignment
	beq.w	.nna
	bset	#0,$62(a3)	;#pfdoff - set decceleration off
	move.b	#8,$43(a3)	;move into temp2+1
	clr.b	$42(a3)	;clear temp2 byte
	move.w	#$FFFE,$46(a3)	;move into temp4
.nna
	tst.w	(puckc).w	;check if there is a puck carrier
	bpl.w	.exit	;exit if puck still in possession
	addq.w	#1,$46(a3)	;add to temp4
	beq.w	.0	;branch if temp4 is zero
	bpl.w	.ex2	;branch if temp4 is positive
.0
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
	jsr	(sub_F6C44).l
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
	sub.b	d7,$40(a3)
	bpl.w	rtss2
.exit
	bclr	#0,$62(a3)
	bra.w	assexit
sub_EC72	;no xref (IDA dc.b at $EC72). Skate to temp3 / temp4, then rts (as 93 asspenalty .st)
	move.w	$44(a3),d0		;temp3
	move.w	$46(a3),d1		;temp4
	lea	rtss2(pc),a0
	bra.w	skateto

; assignment for computer shooting
assshoot
	btst	#5,$62(a3)	;pfalock - animation locked
	bne.w	rtss2
	bclr	#1,$62(a3)	;clear pfna
	beq.w	.nna
	bra.w	SetShotMode
.nna
	btst	#3,(sflags).w	;#sfssdir
	beq.w	assexit
	clr.w	d2
	sub.w	d7,$42(a3)
	bpl.w	ShotMode
	bset	#5,d2	;#cbut
	bra.w	ShotMode
puckshootout
	bclr	#1,$62(a3)
	beq.w	.EDB0
	bset	#7,(byte_FFC2FC).w
	clr.l	(padcont).w
	clr.l	(dword_FFBE7E).w
	clr.l	(dword_FFBE82).w
	bclr	#7,(word_FFC2FA).w
	btst	#0,(word_FFC2FA).w
	beq.w	.ECEC
	jsr	(sub_FC4C0).l
	bra.w	.ED0E
.ECEC
	jsr	(sub_FE756).l
	move.l	a2,-(sp)
	movea.l	#$FFFFC6CE,a2
	tst.w	(BA_Team).w
	beq.w	.ED08
	movea.l	#$FFFFCA32,a2
.ED08
	addq.w	#1,$360(a2)
	movea.l	(sp)+,a2
.ED0E
	bclr	#2,(BA_PS_flags).w
	bclr	#4,(BA_PS_flags).w
	bclr	#5,(BA_PS_flags).w
	bclr	#6,(BA_PS_flags).w
	bset	#1,(word_FFC2F8).w
	btst	#3,(gmode).w
	bne.w	Stop4Pen
	bclr	#1,$62(a3)
	btst	#0,(word_FFC2FA).w
	beq.w	.ED70
	tst.w	(word_FFD594).w
	bne.w	.ED8A
	tst.w	(word_FFD586).w
	bne.w	.ED8A
	move.w	(HomeTeam).w,(HmTeam).w
	move.w	#2,(SongIndex).w
	jsr	(ChooseSong).l
	move.w	(SongNum).w,-(sp)
	bra.w	.ED86
.ED70
	move.w	(HomeTeam).w,(HmTeam).w
	move.w	#2,(SongIndex).w
	jsr	(ChooseSong).l
	move.w	(SongNum).w,-(sp)
.ED86
	bsr.w	song
.ED8A
	bset	#0,(gmode).w
	bset	#1,(word_FFC2FA).w
	clr.w	(puckvx).w
	clr.w	(puckvy).w
	move.w	#$19,(word_FFD454).w
	bsr.w	ReturnGoalies
	st	$40(a3)
	st	$42(a3)
.EDB0
	bset	#2,(BA_PS_flags).w
	movem.w	d1-d2,-(sp)
	jsr	(sub_EE58).l
	bmi.w	.EDCC
	movem.w	(sp)+,d1-d2
	bra.w	.EDE0
.EDCC
	movem.w	(sp)+,d1-d2
	bclr	#2,(BA_PS_flags).w
	move.w	#$1B,d0	;puckfaceoff
	bsr.w	assreplace
	rts
.EDE0
	movem.w	d1-d2,-(sp)
	move.w	(BA_Goalie_SCnum).w,d0
	movea.l	#$FFFFB04A,a2
	asl.w	#7,d0
	adda.w	d0,a2
	tst.w	$34(a2)
	bne.w	.EE04
	btst	#2,$63(a2)
	beq.w	.EE48
.EE04
	move.w	(BA_Goalie_SCnum).w,d0
	move.w	#6,d2
.EE0C
	subq.w	#1,d2
	bmi.s	.EDCC
	subq.w	#1,d0
	bpl.w	.EE1E
	move.w	#5,d0
	bra.w	.EE2A
.EE1E
	cmp.w	#5,d0
	bne.w	.EE2A
	move.w	#$B,d0
.EE2A
	movea.l	#$FFFFB04A,a2
	move.w	d0,d1
	asl.w	#7,d1
	adda.w	d1,a2
	tst.w	$34(a2)
	bne.s	.EE0C
	btst	#2,$63(a2)
	bne.s	.EE0C
	move.w	d0,(BA_Goalie_SCnum).w
.EE48
	movem.w	(sp)+,d1-d2
	movea.w	#(HmShots-M68K_RAM),a2
	move.w	#$1F,d0	;puckpenshot
	bra.w	assreplace
sub_EE58
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#$FFFFC6CE,a0
	tst.w	(BA_Team).w
	beq.w	.EE70
	movea.l	#$FFFFCA32,a0
.EE70
	move.w	#0,d1
	move.w	#$FFFF,d6
	move.w	#$FFFF,d5
	movea.l	$1E(a0),a2
	adda.w	(a2),a2
.EE82
	cmpi.w	#2,(a2)
	beq.w	.EF4C
	adda.w	(a2),a2
	move.w	d1,d7
	asl.w	#1,d7
	move.b	5(a2),d0
	andi.w	#$F,d0
	cmp.b	#1,d0
	ble.w	.EF40
	btst	#0,(word_FFC2FA).w
	bne.w	.EF56
	cmpi.w	#$FFFE,$66(a0,d7.w)
	beq.w	.EEBE
	cmpi.w	#$FFFF,$66(a0,d7.w)
	bne.w	.EF40
.EEBE
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
	bne.w	.EF32
	move.w	#$7FFF,d3
.EF32
	cmp.w	d6,d3
	blt.w	.EF40
	move.w	d3,d6
	move.w	d1,d5
	bra.w	*+4
.EF40
	addq.l	#8,a2
	addq.w	#1,d1
	cmp.w	#$1A,d1
	blt.w	.EE82
.EF4C
	tst.w	d5
	bmi.w	.EF80
	move.w	d5,(BA_Skater_Offset).w
.EF56
	move.w	#0,(BA_Sktr_SCnum).w
	tst.w	(BA_Team).w
	beq.w	.EF6A
	move.w	#6,(BA_Sktr_SCnum).w
.EF6A
	move.w	(BA_Sktr_SCnum).w,d0
	asl.w	#7,d0
	movea.l	#$FFFFB04A,a3
	adda.w	d0,a3
	move.w	(BA_Skater_Offset).w,d3
	bra.w	.EF88
.EF80
	move.w	#$FFFF,d0
	bra.w	.EF8C
.EF88
	move.w	#1,d0
.EF8C
	movem.l	(sp)+,d0-d7/a0-a6
	rts
; puck start for penalty shot/shootout
puckpenshot
	bclr	#1,$62(a3)
	beq.w	.F2A8
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	forceblack
.EFA4
	btst	#0,(disflags).w
	bne.s	.EFA4
	cmpi.w	#$258,(crowdlevel).w
	bls.w	.EFC2
	move.w	#$258,(crowdlevel).w
	addi.w	#$14,(CwdExciteLvl).w
.EFC2
	move.w	(ExtraChars).w,d4
	movea.l	#unk_5C410,a2
	jsr	(sub_11738).l
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
	movea.w	#(unk_FFB64A-M68K_RAM),a0	;goal net SCstruct
	clr.w	$28(a0)
	clr.w	$2A(a0)
	clr.w	(a0)
	move.w	#$10C,$14(a0)
	adda.w	#$80,a0	;move to second goal net SCstruct
	clr.w	$28(a0)
	clr.w	$2A(a0)
	clr.w	(a0)
	move.w	#$FEF4,$14(a0)
	movea.w	#(unk_FFB7CA-M68K_RAM),a0	;puck shadow SCstruct
	move.w	#$18A,6(a0)
	clr.w	$58(a0)
	clr.w	4(a0)
	clr.w	(word_FFB74E).w
	bclr	#6,(sflags).w
	moveq	#$64,d4
.F06C
	bsr.w	checkwindow
	dbf	d4,.F06C
	move.w	#$3C,(yleader).w
	bsr.w	ResetBench
	movea.w	#(HmShots-M68K_RAM),a2
	bsr.w	SetPersonel
	bsr.w	sub_1592C
	adda.w	#$364,a2
	bsr.w	SetPersonel
	bsr.w	sub_1592C
	jsr	(resetplstuff).l
	move.l	a3,-(sp)
	movea.l	#$FFFFB5CA,a3	;away goalie SCstruct
	move.w	#$B,d2	;11 = # of player SCstructs
.F0A8
	cmp.w	(BA_Sktr_SCnum).w,d2
	beq.w	.F0D0
	cmp.w	(BA_Goalie_SCnum).w,d2
	beq.w	.F150
	move.w	#$FF10,(a3)
	clr.w	$14(a3)
	clr.w	6(a3)
	move.w	#$20,d0
	bsr.w	assinsert
	bra.w	.F1FC
.F0D0
	tst.w	$34(a3)
	bpl.w	.F104
	bclr	#2,$63(a3)
	beq.w	.F104
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d3
	move.b	$66(a3),d3
	jsr	(setplayer).l
	movem.l	(sp)+,d0-d7/a0-a6
	tst.w	$34(a3)
	beq.w	.F102
	bpl.w	.F104
.F102
	nop
.F104
	move.w	(puckx).w,d0
	subi.w	#0,d0
	move.w	d0,(a3)
	move.w	(pucky).w,d0
	btst	#7,$62(a3)
	bne.w	.F12A
	addi.w	#$10,d0
	move.w	#4,$54(a3)
	bra.w	.F134
.F12A
	addi.w	#-$10,d0
	move.w	#0,$54(a3)
.F134
	move.w	d0,$14(a3)
	clr.w	$28(a3)
	clr.w	$2A(a3)
	clr.w	$2C(a3)
	move.w	#$11,d0
	bsr.w	assinsert
	bra.w	.F1FC
.F150
	btst	#0,(word_FFC2FA).w
	beq.w	.F172
	move.b	(byte_FFD593).w,$66(a3)
	tst.w	(word_FFD594).w
	beq.w	.F184
	move.b	(byte_FFD585).w,$66(a3)
	bra.w	.F184
.F172
	tst.w	$34(a3)
	bpl.w	.F1A6
	bclr	#2,$63(a3)
	beq.w	.F1A6
.F184
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d3
	move.b	$66(a3),d3
	jsr	(setplayer).l
	movem.l	(sp)+,d0-d7/a0-a6
	tst.w	$34(a3)
	bne.w	.F1A4
	bpl.w	.F1A6
.F1A4
	nop
.F1A6
	bclr	#2,$63(a3)
	move.w	#0,d0
	move.w	#$E5,d1
	btst	#7,$62(a3)
	bne.w	.F1C2
	move.w	#$FF1B,d1
.F1C2
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
.F1FC
	suba.l	#$80,a3
	dbf	d2,.F0A8	;cycle to next player
	bsr.w	SprSort
	movea.l	(sp)+,a3
	bsr.w	setchgplayer
	move.w	(BA_Goalie_SCnum).w,d0
	asl.w	#7,d0
	movea.w	#(SortCords-M68K_RAM),a3
	adda.w	d0,a3
	move.w	#0,(a3)
	move.w	#$FF06,$14(a3)
	btst	#7,$62(a3)
	bne.w	.F236
	move.w	#$FA,$14(a3)
.F236
	move.w	(BA_Goalie_SCnum).w,d0
	move.w	#1,d1
	btst	#6,$62(a3)
	beq.w	.F24C
	move.w	#2,d1
.F24C
	cmp.w	(cont1team).w,d1
	bne.w	.F25E
	jsr	(setc1player).l
	bra.w	.F26C
.F25E
	cmp.w	(cont2team).w,d1
	bne.w	.F26C
	jsr	(setc2player).l
.F26C
	move.w	#$E,d0	;assignment D51C?
	bsr.w	assreplace
	bset	#7,(BA_PS_flags).w
	bset	#2,(sflags2).w
	move.w	#$190,(word_FFC31A).w
	tst.w	(cont1team).w
	bne.w	.F29C
	tst.w	(cont2team).w
	bne.w	.F29C
	move.w	#$64,(word_FFC31A).w
.F29C
	move.w	#$18,(palcount).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.F2A8
	bset	#2,(word_FFC2FA).w
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
sub_F2F4
	movem.w	d0,-(sp)
	move.w	(puckc).w,d0
	cmp.w	(BA_Goalie_SCnum).w,d0
	movem.w	(sp)+,d0
	beq.w	.F342
	btst	#5,(BA_PS_flags).w
	beq.w	.F348
	btst	#5,(word_FFC2FA).w
	bne.w	.F32A
	tst.w	(puckc).w
	bpl.w	.F332
	bset	#5,(word_FFC2FA).w
.F32A
	tst.w	(puckc).w
	bpl.w	.F342
.F332
	tst.w	(word_FFC31C).w
	bmi.w	.F342
	subq.w	#1,(word_FFC31C).w
	bra.w	.F348
.F342
	bset	#4,(BA_PS_flags).w
.F348
	tst.w	(word_FFD454).w
	bne.w	.F356
	bset	#4,(BA_PS_flags).w
.F356
	btst	#4,(BA_PS_flags).w
	bne.w	.F362
	rts
.F362
	btst	#6,(BA_PS_flags).w
	bne.w	locret_F3E2
	bset	#6,(BA_PS_flags).w
	move.w	#$A,d0
	jsr	(AddPenalty2).l
sub_F37C
	jsr	(freezewindow).l
	btst	#0,(word_FFC2FA).w
	bne.w	.F398
	move.w	#$A,(word_FFDEF0).w
	bset	#2,(sflags2).w
.F398
	bset	#0,(gmode).w
	bclr	#2,(word_FFC2FA).w
	bclr	#2,(BA_PS_flags).w
	bclr	#3,(BA_PS_flags).w
	bclr	#5,(BA_PS_flags).w
	bclr	#4,(BA_PS_flags).w
	bclr	#6,(BA_PS_flags).w
	movem.l	d0/a0,-(sp)
	movea.l	#$FFFFB04A,a0
	move.w	(BA_Sktr_SCnum).w,d0
	asl.w	#7,d0
	move.b	(byte_FFC31E).w,$61(a0,d0.w)
	movem.l	(sp)+,d0/a0
	jsr	(sub_FC516).l
locret_F3E2
	rts
; this is where the action starts
puckfaceoff
	bclr	#4,(byte_FFC2FE).w
	btst	#0,(word_FFC2FA).w
	beq.w	.F404
	clr.w	(puckvx).w
	clr.w	(puckvy).w
	move.w	#$1E,d0	;assignment ECB6?
	bra.w	assreplace
.F404
	bclr	#1,$62(a3)
	beq.w	loc_F612
	bclr	#0,(byte_FFC2FE).w
	beq.w	.F420
	clr.w	(fox).w
	clr.w	(foy).w
.F420
	bclr	#7,(byte_FFC2FC).w
	clr.l	(padcont).w
	clr.l	(dword_FFBE7E).w
	clr.l	(dword_FFBE82).w
	bclr	#6,(byte_FFC2FC).w
	bclr	#2,(byte_FFC2FC).w
	jsr	(sub_FECF8).l
	tst.w	(word_FFD6BE).w
	bmi.w	.F454
	move.w	(word_FFD6BE).w,d0
	bra.w	.F460
.F454
	jsr	(sub_FECAA).l
	tst.w	d0
	bmi.w	.F466
.F460
	jsr	(sub_FE53C).l
.F466
	bclr	#1,(word_FFC2F8).w
	bclr	#1,(word_FFC2FA).w
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
	btst	#3,(gmode).w
	bne.w	Stop4Pen
	move.w	(PerTimeTotal).w,d0
	asr.w	#1,d0
	cmp.w	(gameclock).w,d0
	bls.w	.F4F2
	cmpi.w	#$3C,(gameclock).w
	blt.w	.F4F2
	bclr	#7,(sflags3).w
	beq.w	.F4F2
	btst	#0,(gmode).w
	beq.w	.F4F2
	btst	#6,(byte_FFC2FE).w
	bne.w	.F4F2
	move.w	(HomeTeam).w,(HmTeam).w
	move.w	#2,(SongIndex).w
	jsr	(ChooseSong).l
	bset	#4,(byte_FFC2FE).w
.F4F2
	bsr.w	ReturnGoalies
	st	$40(a3)
	st	$42(a3)
	tst.w	(OptLine).w
	bne.w	loc_F612
	bclr	#1,(byte_FFC6FE).w
	bclr	#1,(byte_FFCA62).w
	movea.w	#(SortCords-M68K_RAM),a0
	moveq	#$B,d0
.F518
	bclr	#3,$63(a0)
	adda.w	#$80,a0
	dbf	d0,.F518
	move.w	(cont1team).w,d0
	or.w	(cont2team).w,d0
	beq.w	.F566
	btst	#7,(sflags).w
	beq.w	.F566
	bsr.w	forceblack
	bset	#6,(sflags).w
	bsr.w	ClrHor
	move.w	#$18,(palcount).w
	tst.w	(OptLine).w
	bne.w	.F566
	btst	#4,(byte_FFC2FC).w
	beq.w	.F566
	clr.w	(palcount).w
.F566
	move.w	(c1playernum).w,d0
	bmi.w	.F572
	bsr.w	sub_F5C6
.F572
	move.w	(c2playernum).w,d0
	bmi.w	.F57E
	bsr.w	sub_F5C6
.F57E
	movea.w	#(HmShots-M68K_RAM),a1
	lea	$364(a1),a2
	moveq	#2,d0
	bsr.w	sub_F590
	bra.w	loc_F612
sub_F590
	tst.w	(OptLine).w
	bne.w	rtss2
	btst	#4,(byte_FFC2FC).w
	bne.w	.F5B2
	cmp.w	(cont1team).w,d0
	beq.w	rtss2
	cmp.w	(cont2team).w,d0
	beq.w	rtss2
.F5B2
	bsr.w	CompLine
	bsr.w	SetPersonel
	bsr.w	PrintScores1
	move.w	#$2710,(word_FFC304).w
	rts
sub_F5C6
	exg	a2,a3
	asl.w	#7,d0
	movea.w	#(SortCords-M68K_RAM),a3
	adda.w	d0,a3
	bclr	#3,$63(a3)
	move.l	a2,-(sp)
	bsr.w	SetLCmode
	movea.l	(sp)+,a2
	btst	#3,$63(a3)
	beq.w	.F60E
	btst	#6,$62(a3)
	beq.w	.F602
	move.w	#$168,$42(a2)
	move.w	$52(a3),$46(a2)
	bra.w	.F60E
.F602
	move.w	#$258,$40(a2)
	move.w	$52(a3),$44(a2)
.F60E
	exg	a2,a3
	rts
loc_F612
	move.w	#$40,d0
	bsr.w	sub_F64E
	move.w	#$42,d0
	bsr.w	sub_F64E
	tst.w	$40(a3)
	bpl.w	rtss2
	tst.w	$42(a3)
	bpl.w	rtss2
	movea.w	#(HmShots-M68K_RAM),a2
	lea	$364(a2),a1
	moveq	#1,d0
	bsr.w	sub_F590
	move.w	#$FFFF,(word_FFD6C6).w
	move.w	#$1C,d0	;puckfaceoff2
	bra.w	assreplace
sub_F64E
	tst.w	0(a3,d0.w)
	bmi.w	rtss2
	move.w	4(a3,d0.w),d1
	asl.w	#7,d1
	movea.w	#(SortCords-M68K_RAM),a0
	movea.w	#(HmShots-M68K_RAM),a2
	btst	#6,$62(a0,d1.w)
	beq.w	.F672
	adda.w	#$364,a2
.F672
	btst	#3,$63(a0,d1.w)
	bne.w	.F684
	st	0(a3,d0.w)
	bra.w	sub_B92E
.F684
	sub.w	d7,0(a3,d0.w)
	bpl.w	rtss2
	move.l	a3,-(sp)
	lea	0(a0,d1.w),a3
	btst	#3,$63(a3)
	beq.w	.F6A6
	clr.w	d2
	bsr.w	lcfound
	bsr.w	sub_B92E
.F6A6
	movea.l	(sp)+,a3
	rts
; computer pulls goalie on delayed penalty
ChkGoalies
	btst	#0,(gmode).w	;check if clock running
	bne.w	rtss2
	movea.w	#(HmShots-M68K_RAM),a2
	lea	$364(a2),a1
	moveq	#1,d0
	bsr.w	.chkgoalie
	moveq	#2,d0
	exg	a1,a2
.chkgoalie
	tst.w	$26(a2)	;check for goalie
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
	btst	#3,(gmode).w	;#gmpendel - delayed penalty called
	beq.w	.nopen
	st	$26(a2)	;sets to FFFF (no goalie)
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
	lea	$364(a2),a1
	moveq	#1,d0
	bsr.w	.r
	moveq	#2,d0
	exg	a1,a2
.r
	cmpi.w	#$FFFF,$26(a2)
	beq.w	rtss2	;still no goalie
	clr.b	$26(a2)	;clear for goalie return
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
	move.w	$C(a1),d0	;tmscore
	sub.w	$C(a2),d0
	bmi.w	rtss2	;exit if leading in the game
	cmp.w	#2,d0
	bne.w	rtss2	;exit if behind by more than 2
	cmpi.w	#$3C,(gameclock).w	;'<' ; #60
	bgt.w	rtss2	;exit if more than 1 min left
	move.l	a0,-(sp)
	movea.w	$22(a2),a0	;moves a player struct address into a0
	btst	#7,$62(a0)	;#pfgoal
	movea.l	(sp)+,a0
	bne.w	.0
	neg.w	d1	;if shooting on bottom goal, make d1 negative
.0
	tst.w	d1
	bmi.w	rtss2	;exit if d1 negative (faceoff in own zone)
	st	$26(a2)	;set to FFFF (no goalie)
	bra.w	SetPersonel
; find good line for comp to switch to
CompLine
	movem.l	d0-d2/a0,-(sp)
	moveq	#3,d0
	move.w	$24(a2),d1	;tmap
	sub.w	$24(a1),d1
	beq.w	.nopwr
	bpl.w	.0
	addq.w	#2,d0
.0
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
	move.w	(sp)+,$16(a2)	;tmline
.ex
	movem.l	(sp)+,d0-d2/a0
	rts
.nopwr
	cmpa.w	#$C6CE,a2	;find normal line
	bne.w	.away
	moveq	#2,d1
	lea	.hl1(pc),a0
	cmpi.w	#2,(gsp).w
	bne.w	.h0
	move.w	$C(a2),d2	;tmscore
	cmp.w	$C(a1),d2
	beq.w	.h0
	adda.w	#$E,a0
	bgt.w	.h0
	adda.w	#$E,a0
.h0
	move.w	$16(a1),d1	;tmline
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
	move.w	$C(a2),d2	;tmscore
	cmp.w	$C(a1),d2
	beq.w	.a0
	addq.w	#6,a0
	bgt.w	.a0
	addq.w	#6,a0
.a0
	move.w	(a0)+,d0
	bsr.w	getlinee
	cmp.w	#$C00,d0	;#(19*$1000)/20
	dbhi	d1,.a0
	move.w	-(a0),$16(a2)	;tmline
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
	bclr	#0,(word_FFC2F4).w
	bclr	#1,(word_FFC2F4).w
	bclr	#0,(DelayedPen).w
	bclr	#1,(DelayedPen).w
	bclr	#2,(DelayedPen).w
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	forceblack
.p
	btst	#0,(disflags).w
	bne.s	.p
	move	sr,-(sp)
	move.w	#$3C,(word_FFD412).w
	tst.w	(fox).w
	bne.w	.F8F4
	tst.w	(foy).w
	bne.w	.F8F4
	move.w	#$FFFF,(word_FFD6BE).w
	bra.w	.F8F8
.F8F4
	move	#$2700,sr
.F8F8
	cmpi.w	#$258,(crowdlevel).w
	bls.w	.ntm
	move.w	#$258,(crowdlevel).w	;limit crowd level
.ntm
	bset	#3,(disflags).w	;stop clock
	bclr	#0,(sflags).w	;no pause
	bclr	#0,(sflags3).w	;no line changes
	clr.w	(glovecords).w	;no fighting gloves
	clr.b	(iflags).w	;no icing
	st	(RefCnt).w	;no refs
	st	(puckcross2).w	;no goalie moves
	st	(puckcross6).w
	bclr	#1,(sflags2).w	;no ref refresh
	bset	#0,(sflags2).w	;face off in progress
	bset	#2,(sflags2).w	;dont record yet
	st	(passplayer).w
	st	(onetimerplayer).w
	bset	#4,(disflags).w
	bsr.w	ClrHor	;vertical ice rink
	move.w	#$2710,(word_FFC304).w
	clr.w	(Vpos).w	;clear h/v pos
	clr.w	(Hpos).w
	move.w	(fox).w,(puckx).w
	move.w	(foy).w,(pucky).w
	st	(puckz).w	;no visible puck
	clr.w	(puckvx).w
	clr.w	(puckvy).w
	clr.w	(puckvz).w
	st	(puckc).w
	movea.w	#(unk_FFB64A-M68K_RAM),a0	;reposition goal nets
	clr.w	$28(a0)	;Xvel
	clr.w	$2A(a0)	;Yvel
	clr.w	(a0)	;Xpos
	move.w	#$10C,$14(a0)	;Ypos
	adda.w	#$80,a0	;add SCstruct to move to next goal net
	clr.w	$28(a0)
	clr.w	$2A(a0)
	clr.w	(a0)
	move.w	#$FEF4,$14(a0)	;Ypos
	movea.w	#(unk_FFB7CA-M68K_RAM),a0	;move to puck shadow SCnum
	move.w	#$18A,6(a0)	;#SPFpuck, Frame
	clr.w	$58(a0)	;SPA
	clr.w	4(a0)	;attribute
	clr.w	(word_FFB74E).w	;clear puck SCnum attribute
	bclr	#6,(sflags).w
	moveq	#$64,d4
.cw
	bsr.w	checkwindow	;scroll to faceoff spot
	dbf	d4,.cw
	move.w	#$3C,(yleader).w
	bsr.w	ResetBench
	movea.w	#(HmShots-M68K_RAM),a2
	bsr.w	SetPersonel
	bsr.w	forcepldata
	adda.w	#$364,a2
	bsr.w	SetPersonel
	bsr.w	forcepldata
	bsr.w	resetplstuff
	move.l	a3,-(sp)
	movea.w	#(SortCords-M68K_RAM),a3
	moveq	#$B,d2
.10
	move.w	#$FF10,(a3)	;-240, Xpos
	clr.w	$14(a3)	;Ypos
	clr.w	6(a3)	;frame
	move.w	$34(a3),d1	;position
	bmi.w	.next
	beq.w	.goalie1
	move.l	#$16,d0	;#afaceoff - assignment faceoff
	cmp.w	#4,d1	;find the center (position 4)
	bne.w	.11
	movea.w	#(HmShots-M68K_RAM),a2
	btst	#6,$62(a3)	;#pfgoal - what goal to score on
	beq.w	.clr
	adda.w	#$364,a2
.clr
	clr.w	$18(a2)
	move.b	$66(a3),$19(a2)	;66(a3) = player offset on roster 19(a2) = player who touches puck
	bclr	#7,(byte_FFC2FE).w
	st	$1A(a2)	;clear last player to touch puck (assist 1)
	st	$1C(a2)	;clear second last player to touch puck (assist 2)
	bclr	#3,$30(a2)
	move.l	#$17,d0	;#afaceoffpl - faceoff player assignment
.11
	bsr.w	assinsert
.goalie1
	move.w	(tmap).w,d4	;tmap = active players on ice (4-6)
	btst	#6,$62(a3)	;#pfteam - 0=home 1=away
	beq.w	.t0
	move.w	(tmsize).w,d4
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
	btst	#7,$62(a3)	;#pfgoal - 0=bottom, 1=top
	bne.w	.f0
	neg.w	d0
	neg.w	d1
.f0
	tst.w	$34(a3)	;check for goalie
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
	move.w	d1,$14(a3)	;Ypos
	clr.w	$28(a3)	;Xvel
	clr.w	$2A(a3)	;Yvel
	sub.w	(puckx).w,d0
	sub.w	(pucky).w,d1
	neg.w	d0
	neg.w	d1
	bsr.w	vtoa
	move.w	d0,$54(a3)	;facedir
	bclr	#2,$63(a3)	;#pf2unav
	bclr	#5,$62(a3)	;#pfalock
	move.w	#$50C,d1	;#SPAglide
	bsr.w	SetSPA
.next
	adda.w	#$80,a3	;#Scstruct
	dbf	d2,.10
	bsr.w	SprSort
	movea.l	(sp)+,a3
	bsr.w	setchgplayer
	move.w	(ExtraChars).w,d4
	movea.l	#unk_55BFE,a2
	jsr	(sub_11738).l
	move.w	d4,(word_FFB01C).w
	movea.l	#unk_A78B6,a2
	bsr.w	sub_11738
	move.w	#$FFFF,(word_FFD6B4).w
	btst	#0,(byte_FFC2FC).w
	beq.w	.FB54
	move.w	(word_FFD6BE).w,d0
	bmi.w	.FB54
	jsr	(sub_FE510).l
.FB54
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
	bset	#0,(word_FFC2F8).w
	bsr.w	dobitmap
	bclr	#0,(word_FFC2F8).w
	tst.w	(OptLine).w
	bne.w	.FC08
	bsr.w	printz2
	String	$FA,$A,$FE,4		;$FBC2. IDA shows ori.b #$A,d6 and drops the $FE04 word
	moveq	#$C,d0
	moveq	#3,d1
	bsr.w	Framer
	move.w	(word_FFC6E4).w,d0
	move.w	(word_FFCA48).w,d1
	btst	#1,(gmode).w
	bne.w	.FBE4
	exg	d0,d1
.FBE4
	bsr.w	printz2
	String	$FB,1,$FA,$FE		;$FBE8. IDA shows ori.b #1,d6 and drops the $FAFE word
	movea.l	#FaceOffsprites,a1
	bsr.w	sub_13508
	addq.w	#4,(printx).w
	move.w	d1,d0
	movea.l	#FaceOffsprites,a1
	bsr.w	sub_13508
.FC08
	move.w	#$78,d0
	bsr.w	randomd0
	addi.w	#$B4,d0
	cmpi.w	#0,(word_FFD6B4).w
	beq.w	.chkmintime
	cmpi.w	#1,(word_FFD6B4).w
	beq.w	.chkmintime
	cmpi.w	#5,(word_FFD6B4).w
	beq.w	.chkmintime
	cmpi.w	#4,(word_FFD6B4).w
	beq.w	.chkmintime
	cmpi.w	#2,(word_FFD6B4).w
	bne.w	.time
.chkmintime
	cmp.w	#$10E,d0
	bgt.w	.time
	move.w	#$10E,d0	;sets minimum value in d0 to 10E
.time
	move.w	d0,$40(a3)	;time for puck drop
	move.w	#$18,(palcount).w
	movea.l	#$FFFFBDA8,a0	;#fofdata
	move.w	#1,(a0)
	move.w	#$8000,2(a0)
	move.w	#4,4(a0)
	move.w	#$A800,6(a0)
	move.w	#7,8(a0)	;frame of ref
	move.w	#$8000,$A(a0)
	btst	#1,(gmode).w	;#gmdir - 0 = home team goes up
	bne.w	.nfl
	eori.w	#$800,2(a0)
	eori.w	#$800,6(a0)
.nfl
	move.w	#$FFFF,(fodir1).w	;-1
	move.w	#$FFFF,(fodir2).w	;-1
	jsr	(sub_FF7E2).l
	bclr	#6,(byte_FFC2FE).w
	bne.w	.FCC0
	bclr	#4,(byte_FFC2FE).w
	beq.w	.FCCE
.FCC0
	bclr	#4,(byte_FFC2FE).w
	move.w	(SongNum).w,-(sp)
	bsr.w	song
.FCCE
	move.w	#$18,(palcount).w
	move	(sp)+,sr
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.nna
	subq.w	#1,$40(a3)
	bpl.w	updatefaceoff
	jsr	(sub_FE548).l
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
setchgplayer	;IDA name (93 ResetAndSelectPlayers). c1playernum / c2playernum = -1, then changeplayer for each human team
	move.w	#$FFFF,(c1playernum).w
	move.w	#$FFFF,(c2playernum).w
	tst.w	(cont1team).w
	beq.w	.FD3C
	clr.w	d4
	bsr.w	changeplayer
.FD3C
	tst.w	(cont2team).w
	beq.w	.FD4A
	moveq	#2,d4
	bsr.w	changeplayer
.FD4A
	tst.w	(cont3team).w
	beq.w	.FD82
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
.FD82
	tst.w	(cont4team).w
	beq.w	.FDBC
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
.FDBC
	rts
updatefaceoff
	move.w	$40(a3),d0
	beq.w	.FDDE
	addq.w	#6,d0
	lsr.w	#3,d0
	cmp.w	#2,d0
	bgt.w	rtss2
	neg.w	d0
	addi.w	#$A,d0
	move.w	d0,(word_FFBDB0).w
	rts
.FDDE
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
	bclr	#0,(sflags2).w
	move.w	#$3C,(word_FFD412).w
	move.w	(ExtraChars).w,d4
	movea.l	#unk_5C410,a2
	bsr.w	sub_11738
	bclr	#2,(sflags2).w
	bclr	#0,(gmode).w
	bclr	#0,$63(a3)
	clr.w	(word_FFC304).w
	bset	#4,(sflags3).w
	move.w	(fodir1).w,d3
	move.w	#$800,d4
	movea.l	#$FF06,a0
	movea.w	#(dword_FFBDA8-M68K_RAM),a1
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
	move.w	d1,$28(a3)
	move.w	2(a0,d0.w),d1
	asl.w	#5,d1
	add.w	d4,d1
.FEE2
	move.w	d1,$2A(a3)
	move.w	#$800,d0
	bsr.w	randomd0
	move.w	d0,$2C(a3)
	clr.w	(puckz).w
	bclr	#2,$62(a3)
	move.l	#$18,d0	;pucknorm
	bra.w	assreplace
.ftab
	dc.b	0,8,$10,0,8,$10
; assignment for puck most of the time
; a3 = puck
; d7 = elapse frames since last call
pucknorm
	btst	#2,(BA_PS_flags).w	;check if flag is clear (normal play)
	beq.w	.FF1A
	bsr.w	sub_F2F4
.FF1A
	bclr	#1,$62(a3)	;#pfna clear
	beq.w	.nna
	clr.w	$40(a3)	;temp1
	move.w	#$78,$42(a3)	;'x' ; temp2
.nna
	movea.w	#(puckcross-M68K_RAM),a1	;table for puck crossing lines
	sub.w	d7,2(a1)	;sub elapse frames from time til crossing
	sub.w	d7,6(a1)
	sub.w	d7,$40(a3)	;temp1
	bpl.w	.0
	addq.w	#5,$40(a3)
	bsr.w	findpc
.0
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
	add.w	$14(a2),d1	;Ypos
	sub.w	$14(a3),d1
	asr.w	#2,d1
	add.w	d1,$14(a3)
	move.w	$28(a2),$28(a3)	;Xvel
	move.w	$2A(a2),$2A(a3)	;Yvel
.nothandled
	bsr.w	puckIChk
	bsr.w	ChkOffsides
	btst	#0,(gmode).w	;check for play stoppage
	bne.w	.end
	tst.w	(puckc).w
	bpl.w	.FFCC
	move.w	(a3),d0	;Xpos
	cmp.w	$1C(a3),d0	;oldXpos
	bne.w	.FFCC
	move.w	$14(a3),d0	;Ypos
	cmp.w	$20(a3),d0	;oldYpos
	bne.w	.FFCC
	move.l	#6,d0
	subq.w	#1,$42(a3)	;temp3
.FFC0
	bpl.w	.FFC8
	bsr.w	AddPenalty2
.FFC8
	bra.w	.end
.FFCC
	move.w	#$78,$42(a3)	;'x' ; move 78 hex into temp2
.end
	tst.b	$2C(a3)	;Zvel
	bne.w	checkpuckcoll
	tst.w	$18(a3)	;Zpos
	bne.w	checkpuckcoll
	bsr.w	puckunflip
	bra.w	checkpuckcoll
