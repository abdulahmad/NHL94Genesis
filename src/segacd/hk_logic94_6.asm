	include	segacd\hockey.inc
	include	macros\genesis.mac

Acheck	equ	$30E4A
BA_Goalie_SCnum	equ	$1936A
BA_Skater_Offset	equ	$1936C
BA_Sktr_SCnum	equ	$19368
BA_Team	equ	$19366
BreakawayOffsidesFlagSet	equ	$3334E
ChooseSong	equ	$2A478
CountShootoutGoals	equ	$27A98
Crowdlevel	equ	$17CD2
CwdExciteLvl	equ	$17CD8
DecompressGraphicsPlain	equ	$38958
ExtraChars	equ	$18D56
HmTeam	equ	$1A56C
HomeTeam	equ	$17FAE
Hpos	equ	$17CEE
LOAD	equ	$1B000
NextShooter	equ	$27A30
OptPen	equ	$18C08
PuckOnAttackHalf	equ	$22CA4
ReadGoaliePulled	equ	$2AEDC
RefCnt	equ	$1806E
RefsMap	equ	$47D1C
ResetAndSelectPlayers	equ	$35798
ResetBench	equ	$3D6E2
ReturnGoalies	equ	$3508E
SetupPenaltyShot	equ	$3D5E4
ShotMode	equ	$3144C
SongIndex	equ	$1A56E
SongNum	equ	$1A56A
SortCords	equ	$17480
SprSort	equ	$3F03E
StartShootoutPath	equ	$2A686
Stop4Pen	equ	$39A56
Vpos	equ	$17CEA
assreplace	equ	$362E4
awtmstruct	equ	$186B2
breakaway	equ	$332DE
burst	equ	$30DD2
chkpk2	equ	$338C8
cont1team	equ	$17FA6
cont2team	equ	$17FA8
disflags	equ	$18D64
freezewindow	equ	$30094
homeshootnum	equ	$1A428
inputjoy	equ	$1AD7A
move	equ	$2C9C8
onetimerplayer	equ	$17EBC
palcount	equ	$18D62
passReceiverPlayerNum	equ	$17E30
passmodetimer	equ	$17F9A
puckvx	equ	$17BA8
puckvy	equ	$17BAA
puckvz	equ	$17BAC
puckx	equ	$17B80
pucky	equ	$17B94
randomd0	equ	$37050
replaydelay	equ	$1AD92
setc1player	equ	$312B8
setc2player	equ	$312DC
setplayer	equ	$3D770
sflags6	equ	$17F76
sfx	equ	$3710C
shootoutclock	equ	$193B6
shootoutteam	equ	$1A436
skatetopuckinit	equ	$361F0
song	equ	$371D2
tmstruct	equ	$1834C
vtoa	equ	$362F8
X_150B2	equ	$150B2
X_163CA	equ	$163CA
X_16AB6	equ	$16AB6
X_16EB2	equ	$16EB2
X_17926	equ	$17926
X_18DEA	equ	$18DEA
X_1922A	equ	$1922A
X_19C28	equ	$19C28
X_1B008	equ	$1B008
X_1B212	equ	$1B212
X_1B2C4	equ	$1B2C4
X_1B2D8	equ	$1B2D8
X_1B2E4	equ	$1B2E4
X_1B362	equ	$1B362
X_1B3C0	equ	$1B3C0
X_1BD0A	equ	$1BD0A
X_213AC	equ	$213AC

	org	$18DFC

assnearest						;this is a special assignment used for the player who is nearest the puck
									;but doesn't have it. Assignment anearest ($11)
									;a2 = a3's team struct, d7 = elapsed frames. temp1 = re-evaluation timer,
									;temp3 = hold timer
	jsr	(breakaway).l
	bmi.w	X_18DEA
	bclr	#$2,$17F74.l
	bne.w	.chkpuck
	bclr	#$1,$64(a3)		;clear breakaway bit
.chkpuck	move.w	$52(a3),d0		;move SCnum into d0
	cmp.w	$17BE0.l,d0		;compare with puck carrier SCnum
	bne.w	.chkbreak		;jump if not puck carrier
	btst	#$1,$64(a3)		;check breakaway bit
	bne.w	.chkbreak		;jump if set
	btst	#$2,$17F70.l		;check if bit 2 set (cleared on Faceoffs)
	bne.w	.chkbreak		;jump if set
	jsr	(BreakawayOffsidesFlagSet).l
	beq.w	.chkbreak
	move.w	#$22,d0		;22 - assbreakaway if flag set
	bsr.w	X_1B2E4		;assreplace with assbreakaway
	bra.w	.chkbreak
.chkbreak	bclr	#$1,$62(a3)		;pfna - clear new assignment
	beq.w	.nna
	btst	#$1,$64(a3)		;check if breakaway
	beq.w	.chkbreak2		;jump if not
	move.w	#$2,-(sp)		;ding SFX
	jsr	(sfx).l
.chkbreak2	btst	#$1,$64(a3)		;check if breakaway
	beq.w	.nobreak		;jump if not
	movem.l	a2,-(sp)		;push a2 to stack
	movea.l	#tmstruct,a2		;put Home Team Struct into a2
	btst	#$6,$62(a3)		;pfteam - check home or away
	beq.w	.addcrowd		;jump if home
	movea.l	#awtmstruct,a2		;put Away Team Struct into a2
.addcrowd	addi.w	#$1,$35A(a2)		;add to breakaway attempt
	addi.w	#$14,(CwdExciteLvl).l		;add to excite level
	addi.w	#$C8,(Crowdlevel).l		;add to crowd level
	movem.l	(sp)+,a2		;pop off stack into a2
.nobreak	clr.w	$44(a3)		;clear temp3
	move.w	#$8,$42(a3)		;move 8 into temp2
	clr.w	$40(a3)		;clear temp1
.nna	move.w	$52(a3),d1		;checks if puck carrier
	cmp.w	$17BE0.l,d1
	bne.w	.nopc		;jumps if not
	tst.w	$34(a3)		;check if goalie
	beq.w	X_17926		;branch if goalie
	moveq	#$10,d0
	btst	#$3,$62(a3)		;pfjoycon - check if controlled
	beq.w	X_1B2D8		;jump if not
	rts		;human controlled: leave as is
.nopc	sub.b	d7,$40(a3)		;subtract d7 (elapsed frames) from temp1
	bpl.w	.nodec		;jump if positive
	move.b	$6A(a3),$40(a3)		;move aioff into temp1
	jsr	(ReadGoaliePulled).l		;check if goalie is pulled
	bmi.w	.bonus
	btst	#$6,$17F7A.l		;check if crowd meter currently broken
	beq.w	.nopc2		;jump if not broken
	tst.b	$40(a3)		;check if temp1 is 0
	beq.w	.nopc2		;jump if so
.bonus	subi.b	#$1,$40(a3)		;subtract 1 from temp1
.nopc2	btst	#$5,(sflags6).l		;check if slot bit is set (puckc in slot)
	beq.w	.nopc3		;branch if not set
	move.w	$17BE0.l,d1		;move puck carrier SCnum
	cmpi.w	#$5,d1		;check if its home (5 or less) or away (6-11)
	bgt.w	.pcaway		;jump if away
	btst	#$6,$62(a3)		;pfteam
	beq.w	.nopc3		;jump if home
.tmnopc	move.b	$40(a3),d1		;temp1 into d1
	ext.w	d1		;extend d1
	asr.w	#$1,d1		;divide by 2
	move.b	d1,$40(a3)		;move d1 into temp1 - cutting the timer in half
	bne.w	.nopc3		;jump if not zero
	move.b	#$1,$40(a3)		;move 1 into temp1
	bra.w	.nopc3
.pcaway	btst	#$6,$62(a3)		;pfteam - 0 home, 1 away
	beq.w	.tmnopc		;jump if home
.nopc3	clr.l	$2C(a2)		;no nearest skater yet
	move.w	$17BE0.l,d1		;move puck carrier SCnum into d1
	bmi.w	.np		;branch if no puck carrier
	asl.w	#$7,d1		;scsize
	movea.l	#SortCords,a1		;Move SortCords into a1
	adda.w	d1,a1		;use d1 as offset
	move.b	$62(a1),d0		;pflags of puck carrier
	move.b	$62(a3),d1		;pflags of current player
	eor.b	d0,d1		;XOR pflags
	btst	#$6,d1		;check pfteam
	beq.w	.switch		;branch if on same team
.np	moveq	#-1,d2		;-1
	moveq	#$5,d4		;5 = # of players on team
	movea.l	$22(a2),a0		;SortCord start value for team
.de0	tst.w	$34(a0)		;check if goalie
	ble.w	.next		;branch if goalie
	tst.b	$5E(a0)		;check if nopuck (cant touch puck)
	bne.w	.next		;branch if nopuck timer not 0
	btst	#$2,$63(a0)		;pf2unav - unavailable
	bne.w	.next		;branch if unavailable
	move.w	$36(a0),d0		;assnum - current assignment
	cmpi.b	#$13,$38(a0,d0.w)		;check if current assignment is asspassrec
	beq.w	.next		;branch if a0 is going to receive puck
	move.l	a0,-(sp)		;push onto stack
	bsr.w	X_1B362		;get hot spot
	add.w	$0(a0),d0		;Xpos to d0
	sub.w	(puckx).l,d0		;sub puck Xpos
	add.w	$14(a0),d1		;add Ypos to d1
	sub.w	(pucky).l,d1		;sub puck Ypos
	move.w	(puckvx).l,d3		;puckvx into d3
	asr.w	#$6,d3		;divide by 64
	sub.w	d3,d0		;sub d3 from d0 (X distance between player and puck)
	move.w	(puckvy).l,d3		;puckvy into d3
	asr.w	#$6,d3		;divide by 64
	sub.w	d3,d1		;sub d3 from d1 (Y distance between player and puck)
	muls.w	d0,d0		;square d0
	muls.w	d1,d1		;square d1
	add.l	d1,d0		;add d1 to d0
	cmp.l	d2,d0		;compare d2 to d0
	bhi.w	.next		;branch if d0 higher than d2 (0 or a positive # first run)
	move.l	d0,d2		;move d0 into d2
	movea.l	a0,a1		;move a0 address into a1
.next	adda.w	#$80,a0		;SCstruct size
	dbra	d4,.de0
	tst.l	d2		;check if 0
	bmi.w	.de1		;branch if less (no one near puck)
	move.l	d2,$2C(a2)		;nearest skater's distance^2 to the puck
.switch	cmpa.l	a1,a3		;a1 = closest to the puck, or puckc (if on same team)
	beq.w	.de1		;branch if same
	btst	#$0,$17F68.l		;gmclock - 1 if stopped
	bne.w	.de1		;jump if stopped
	btst	#$2,$63(a1)		;pf2unav
	bne.w	.de1		;jump if unavailable
	btst	#$3,$64(a1)		;shooting one timer
	bne.w	.de1		;jump if shooting
	exg.l	a1,a3		;swap addresses
	bclr	#$0,$62(a3)		;clear pfdoff
	moveq	#$11,d0
	bsr.w	X_1B2D8		;... and give him the assnearest assignment
	exg.l	a1,a3
	bra.w	X_1B2C4		;I (old a3) drop this assignment
.de1	btst	#$5,$62(a3)		;pfalock - check if locked in animation
	bne.w	X_16AB6		;exit if locked
	moveq	#$2,d1		;move 2 into d1
	cmpi.w	#$190,d2		;compare $190 (20^2) to d2. d2 = distance to puck^2
	bhi.w	.nfar		;branch if d2 higher
	subi.w	#$2,d1		;close: d1 = 0
	cmpi.w	#$2,$34(a3)		;compare if position is F or D (1 and 2 are D)
	bls.w	.nodec		;jump if D
.nfar	btst	#$5,$17F6C.l		;sf2pwrplay - check if PP
	beq.w	.l1907C		;branch if no PP
	subi.w	#$2,d1		;sub 2 from d1
	bsr.w	chkpk2-LOAD
	bne.w	.l1907C		;branch if on PK
	addi.w	#$4,d1		;add 4 to d1
.l1907C	moveq	#$28,d0
	sub.b	$75(a3),d0		;sub checking from d0
	asl.w	d1,d0		;shift d0 by value of d1
	bsr.w	randomd0-LOAD		;RNG
	cmpi.w	#$2,d0		;compare 2 to d0
	bhi.w	.nodec		;branch if d0 more than 2
	move.w	#$F0,$44(a3)		;move 240 dec into temp3
.nodec	btst	#$5,$62(a3)		;pfalock - check if anim lock
	bne.w	X_16AB6		;exit if locked
	btst	#$2,$17F70.l		;check bit 2
	beq.w	.gmclock		;jump if not set
	btst	#$5,$17F70.l		;check bit 5
	beq.w	.nodec2		;jump if not set
.gmclock	btst	#$0,$17F68.l		;check if clock running
	bne.w	X_16EB2		;branch if not
.nodec2	btst	#$3,$62(a3)		;pfjoycon - check if controlled
	bne.w	X_16AB6		;jump if controlled
	btst	#$2,$32(a2)		;tmfmid of tmflags(a2)
	bne.w	.nodec22
	tst.w	$17BE0.l		;check if theres a puck carrier
	bmi.w	check4check		;jump if no puck carrier
	sub.w	d7,$44(a3)		;subtract frames from temp3
	bpl.w	check4check		;jump if positive
	clr.w	$44(a3)		;clear temp3
.nodec22	bsr.w	skatetopuckinit-LOAD		;d0/d1 = halfway between
	movem.w	d0-d1,-(sp)		;d0 = future puckx, d1 = future pucky push on stack
	neg.w	d0		;or (0,-$F4) if pfgoal
	neg.w	d1
	addi.w	#$F4,d1		;add goalline - 20 decimal
	btst	#$7,$62(a3)		;pfgoal - check what net shooting on
	beq.w	.nd0		;branch if bottom
	subi.w	#$1E8,d1		;sub bottom goalline - 20 decimal
.nd0	asr.w	#$1,d0		;divide by 2
	asr.w	#$1,d1		;divide by 2
	add.w	(sp)+,d0		;add original future puckx
	add.w	(sp)+,d1		;add original future pucky
	btst	#$2,$32(a2)		;?? - doesn't seem to be set anywhere
	beq.w	.spdboost
	btst	#$7,$62(a3)		;pfgoal
	beq.w	.botshoot		;branch if bottom
	cmpi.w	#$53,d1		;check if y pos of puck near blue line
	blt.w	.spdboost		;branch if in neutral zone or D zone
	move.w	#$44,d1		;move 44 hex into d1
	bra.w	.spdboost
.botshoot	cmpi.w	#$FFAD,d1		;check if pucky near bottom blue line
	bgt.w	.spdboost		;branch if in neutral zone or D zone
	move.w	#$FFBC,d1		;move FFBC into d1
.spdboost	btst	#$5,(sflags6).l		;check if puckc is in the slot
	beq.w	.noslot		;branch if not
	move.b	$69(a3),$17E6E.l		;legspd into TempLegSpd
	addi.b	#$6,$69(a3)		;add 6 to legspd
	btst	#$1,$17F7C.l		;check if crowd meter broken (always is)
	bne.w	.spdboostex		;jump if set
	btst	#$6,$17F7A.l		;check if crowd meter currently broken
	beq.w	.spdlimit		;jump if not set
.spdboostex	addi.b	#$2,$69(a3)
.spdlimit	cmpi.b	#$1E,$69(a3)		;check speed limit
	ble.w	.cont
	move.b	#$1E,$69(a3)		;limit legspd to $1E (30 decimal)
.cont	lea.l	$341EE.l,a0
	bsr.w	X_1B008
	move.b	$17E6E.l,$69(a3)		;move original legpsd back into player
	bra.w	.chkslot
.noslot	lea.l	$341EE.l,a0
	bsr.w	X_1B008
.chkslot	btst	#$5,(sflags6).l
	beq.w	.chkcont
	move.w	(pucky).l,d0
	move.w	$14(a3),d2		;Ypos into d2
	tst.w	d0		;check if d0 is 0
	bpl.w	.pospuck		;branch if positive
	neg.w	d0		;make d0 negative
	neg.w	d2		;make d2 negative
.pospuck	sub.w	d0,d2		;sub d0 from d2 (equals how far puck is from player Ypos)
	cmpi.w	#$A,d2		;check difference with A (10 decimal)
	blt.w	.exit
	move.w	$0(a3),d0		;Xpos of player (gets here if player is between net and puck carrier)
	sub.w	(puckx).l,d0		;sub puckx from Xpos
	bpl.w	.chkx		;branch if positive difference
	neg.w	d0		;make d0 negative
.chkx	cmpi.w	#$F,d0		;compare F (15 dec) with Xpos difference
	blt.w	.chkcont		;branch if less than (within 15 pix in X direction)
.exit	rts
.chkcont	btst	#$5,(sflags6).l		;check if puckc is in the slot
	beq.w	X_1922A		;branch if not in slot
	move.b	$75(a3),d0		;move Chk into d0
	ext.w	d0		;clear top byte of d0
	movem.l	d0/a3,-(sp)		;push to stack
	add.b	d0,d0		;add d0 to itself
	cmpi.b	#$1E,d0		;compare max Chk to d0
	blt.w	.chkcont2		;branch if less
	move.b	#$1E,d0		;move 1E into d0
.chkcont2	move.b	d0,$75(a3)		;move d0 into Chk
	bsr.w	X_1922A
	movem.l	(sp)+,d0/a3		;pop off stack
	move.b	d0,$75(a3)		;move original Chk into player
	rts
check4check						;look for good opportunity for checking opponent. Falls in from
									;assnearest; also entered from assfwatch and asswingd roll against
									;the checking rating first, then look for an opponent within 30 units
									;whom a3 is facing
	bsr.w	X_1B212
	tst.w	$34(a3)		;check if goalie
	bne.w	.player		;branch if not
	rts
.player	move.w	#$28,d0		;start with 28 hex (40 decimal)
	sub.b	$75(a3),d0		;subtract Chk from d0 (Chk max is 1E or 30 decimal)
	tst.w	(OptPen).l		;check for penalties option
	beq.w	.nopen		;branch if not on
	asl.w	#$1,d0		;mult by 2
.nopen	bsr.w	randomd0-LOAD		;RNG d0
	cmpi.w	#$6,d0		;compare 6 to d0
	bhi.w	X_16AB6		;exit if d0 higher than 6
	moveq	#$5,d2		;move 5 into d2
	movea.l	#SortCords,a0
	cmpi.w	#$6,$52(a3)		;check if player on home team
	bge.w	.0		;branch if away
	adda.w	#$300,a0		;add if home (checks opposite team in loop)
.0	tst.w	$34(a0)		;check if goalie
	beq.w	.next		;branch if goalie
	btst	#$5,$62(a0)		;check if locked in anim
	bne.w	.next		;branch if locked
	btst	#$0,$63(a0)		;check if fighting
	bne.w	.next		;branch if fighting
	move.w	$0(a0),d0		;move Xpos into d0
	sub.w	$0(a3),d0		;sub a3 from a0
	cmpi.w	#$1E,d0		;compare to 30 decimal
	bgt.w	.next		;branch if more than 30 decimal
	cmpi.w	#$FFE2,d0		;compare to -30 decimal
	blt.w	.next		;branch if less than -30
	move.w	$14(a0),d1		;Ypos
	sub.w	$14(a3),d1		;subtract checker Ypos from d1
	cmpi.w	#$1E,d1		;compare to 30 decimal
	bgt.w	.next		;branch if more
	cmpi.w	#$FFE2,d1		;check with -30 decimal
	blt.w	.next		;branch if less
	bsr.w	vtoa-LOAD		;determine direction
	cmp.w	$54(a3),d0		;compare facedir with vtoa result
	bne.w	.next		;branch if not facing in that direction
	btst	#$5,(sflags6).l		;check if puckc in slot
	bne.w	Acheck-LOAD		;branch if in slot
.l192CE	btst	#$7,$FF800E.l
	bne.b	.l192CE
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.l192E8	btst	#$6,$FF800E.l
	beq.b	.l192E8
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l19308	btst	#$6,$FF800E.l
	bne.b	.l19308
	bclr	#$7,$FF800F.l
	andi.w	#$3,d0		;pass first 2 bits
	bne.w	burst-LOAD		;throw check
	bra.w	Acheck-LOAD		;1 in 4: hold or hook on a0
.next	adda.w	#$80,a0		;move to next SCstruct
	dbra	d2,.0
	rts
asspassrec						;assignment for catching a pass (apassrec)
	btst	#$5,$62(a3)		;pfalock - animation lock
	bne.w	X_16AB6		;exit if locked
	btst	#$0,$17F68.l		;gmclock - check if clock running
	bne.w	X_16EB2		;exit if clock stopped
	btst	#$3,$62(a3)		;pfjoycon - joystick controlled?
	bne.w	X_1B2C4		;exit if controlled
	bclr	#$1,$62(a3)		;#pfna - clear new assignment
	beq.w	.nna
	bset	#$0,$62(a3)		;#pfdoff - set decceleration off
	move.b	#$8,$43(a3)		;move into temp2+1
	clr.b	$42(a3)		;clear temp2 byte
	move.w	#$FFFE,$46(a3)		;move into temp4
.nna	tst.w	$17BE0.l		;check if there is a puck carrier
	bpl.w	.exit		;exit if puck still in possession
	addi.w	#$1,$46(a3)		;add to temp4
	beq.w	.0		;branch if temp4 is zero
	bpl.w	.ex2		;branch if temp4 is positive
.0	tst.w	(onetimerplayer).l
	bpl.w	.ex2
	tst.w	$34(a3)		;test if goalie
	beq.w	.ex2		;exit if goalie
	move.w	d0,-(sp)		;push d0 on stack
	clr.w	$46(a3)		;clear temp4
	move.w	#$1,d0
	btst	#$6,$62(a3)		;check if home or away
	beq.w	.1
	move.w	#$2,d0		;away team
.1	cmp.w	(cont1team).l,d0		;check if player on cont 1 team
	beq.w	.pop		;branch if so
	cmp.w	(cont2team).l,d0		;check if player on cont 2 team
	beq.w	.pop		;branch if so
	jsr	(PuckOnAttackHalf).l
	beq.w	.pop
	move.w	$14(a3),d0		;Ypos
	btst	#$7,$62(a3)		;pfgoal
	bne.w	.chkpos		;branch if shooting at top
	neg.w	d0
.chkpos	cmpi.w	#$58,d0		;blueline
	blt.w	.nozone
	cmpi.w	#$108,d0		;goalline
	bgt.w	.nozone
	bra.w	.atkzone
.nozone	move.w	#$8,d0		;outside of attack zone
	jsr	(randomd0).l
	tst.w	d0		;check if d0 is zero
	bne.w	.pop
.atkzone	move.w	(sp)+,d0
	move.w	#$FFFF,(inputjoy).l
	move.w	#$23,d0		;assonetimer
	jmp	(assreplace).l
.pop	move.w	(sp)+,d0
.ex2	sub.b	d7,$40(a3)
	bpl.w	X_16AB6
.exit	bclr	#$0,$62(a3)
	bra.w	X_1B2C4
	dc.w	$302B,$0044,$322B,$0046,$41FA,$7BCA,$6000,$1BCE
assshoot						;assignment for computer shooting. Assignment ashoot ($12)
	btst	#$5,$62(a3)		;pfalock - animation locked
	bne.w	X_16AB6
	bclr	#$1,$62(a3)		;clear pfna
	beq.w	.nna
	bra.w	X_163CA		;first frame: start the shot (temp2 = swing time set by CompShoot)
.nna	btst	#$3,$17F6A.l		;#sfssdir
	beq.w	X_1B2C4		;no: the shot is done
	clr.w	d2
	sub.w	d7,$42(a3)		;count the swing time down
	bpl.w	ShotMode-LOAD		;still swinging: feed ShotMode no buttons
	bset	#$5,d2		;#cbut
	bra.w	ShotMode-LOAD		;swing time over: press the shot button (cbut)
puckshootout						;puck logic for the shootout: on a new assignment clear the pads and
									;select the skater, then run the attempt
	bclr	#$1,$62(a3)
	beq.w	.selectskater
	bset	#$7,$17F7A.l
	clr.l	$17DCA.l
	clr.l	$17DCE.l
	clr.l	$17DD2.l
	bclr	#$7,$17F78.l
	btst	#$0,$17F78.l
	beq.w	.startattempt
	jsr	(NextShooter).l
	bra.w	.initflags
.startattempt	jsr	(StartShootoutPath).l
	move.l	a2,-(sp)
	movea.l	#tmstruct,a2
	tst.w	(BA_Team).l
	beq.w	.countattempt
	movea.l	#awtmstruct,a2
.countattempt	addi.w	#$1,$362(a2)
	movea.l	(sp)+,a2
.initflags	bclr	#$2,$17F70.l
	bclr	#$4,$17F70.l
	bclr	#$5,$17F70.l
	bclr	#$6,$17F70.l
	bset	#$1,(sflags6).l
	btst	#$3,$17F68.l
	bne.w	Stop4Pen-LOAD
	bclr	#$1,$62(a3)
	btst	#$0,$17F78.l
	beq.w	.selectsong
	tst.w	(shootoutteam).l
	bne.w	.setstopped
	tst.w	(homeshootnum).l
	bne.w	.setstopped
	move.w	(HomeTeam).l,(HmTeam).l
	move.w	#$2,(SongIndex).l
	jsr	(ChooseSong).l
	move.w	(SongNum).l,-(sp)
	bra.w	.playsong
.selectsong	move.w	(HomeTeam).l,(HmTeam).l
	move.w	#$2,(SongIndex).l
	jsr	(ChooseSong).l
	move.w	(SongNum).l,-(sp)
.playsong	bsr.w	song-LOAD
.setstopped	bset	#$0,$17F68.l
	bset	#$1,$17F78.l
	clr.w	(puckvx).l
	clr.w	(puckvy).l
	move.w	#$19,(shootoutclock).l
	bsr.w	ReturnGoalies-LOAD
	st.b	$40(a3)
	st.b	$42(a3)
.selectskater	bset	#$2,$17F70.l
	movem.w	d1-d2,-(sp)
	jsr	(SelectPenaltyShotSkater+LOAD).l
	bmi.w	.noeligible
	movem.w	(sp)+,d1-d2
	bra.w	.checkgoalie
.noeligible	movem.w	(sp)+,d1-d2
	bclr	#$2,$17F70.l
	move.w	#$1B,d0		;puckfaceoff
	bsr.w	X_1B2E4
	rts
.checkgoalie	movem.w	d1-d2,-(sp)
	move.w	(BA_Goalie_SCnum).l,d0
	movea.l	#SortCords,a2
	asl.w	#$7,d0
	adda.w	d0,a2
	tst.w	$34(a2)
	bne.w	.findgoalie
	btst	#$2,$63(a2)
	beq.w	.startpenshot
.findgoalie	move.w	(BA_Goalie_SCnum).l,d0
	move.w	#$6,d2
.goalieloop	subi.w	#$1,d2
	bmi.w	.noeligible
	subi.w	#$1,d0
	bpl.w	.wraphome
	move.w	#$5,d0
	bra.w	.checkcandidate
.wraphome	cmpi.w	#$5,d0
	bne.w	.checkcandidate
	move.w	#$B,d0
.checkcandidate	movea.l	#SortCords,a2
	move.w	d0,d1
	asl.w	#$7,d1
	adda.w	d1,a2
	tst.w	$34(a2)
	bne.w	.goalieloop
	btst	#$2,$63(a2)
	bne.w	.goalieloop
	move.w	d0,(BA_Goalie_SCnum).l
.startpenshot	movem.w	(sp)+,d1-d2
	movea.l	#tmstruct,a2
	move.w	#$1F,d0		;puckpenshot
	bra.w	X_1B2E4
SelectPenaltyShotSkater						;pick the skater for the penalty shot from team BA_Team
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a0
	tst.w	(BA_Team).l
	beq.w	.hometeam
	movea.l	#awtmstruct,a0
.hometeam	move.w	#$0,d1
	move.w	#$FFFF,d6
	move.w	#$FFFF,d5
	movea.l	$1E(a0),a2
	adda.w	$0(a2),a2
.playerloop	cmpi.w	#$2,(a2)
	beq.w	.doneplayers
	adda.w	(a2),a2
	move.w	d1,d7
	asl.w	#$1,d7
	move.b	$5(a2),d0
	andi.w	#$F,d0
	cmpi.b	#$1,d0
	ble.w	.nextplayer
	btst	#$0,$17F78.l
	bne.w	.setskaterscnum
	cmpi.w	#$FFFE,$68(a0,d7.w)
	beq.w	.scorecandidate
	cmpi.w	#$FFFF,$68(a0,d7.w)
	bne.w	.nextplayer
.scorecandidate	clr.w	d3
	clr.w	d0
	move.b	$1(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	$2(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	$2(a2),d0
	andi.w	#$F0,d0
	lsr.w	#$4,d0
	add.w	d0,d3
	move.b	$3(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	$3(a2),d0
	andi.w	#$F0,d0
	lsr.w	#$4,d0
	add.w	d0,d3
	move.b	$5(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	$5(a2),d0
	andi.w	#$F0,d0
	lsr.w	#$4,d0
	add.w	d0,d3
	move.b	$6(a2),d0
	andi.w	#$F0,d0
	lsr.w	#$4,d0
	add.w	d0,d3
	move.b	$7(a2),d0
	andi.w	#$F0,d0
	lsr.w	#$4,d0
	add.w	d0,d3
	cmp.w	(BA_Skater_Offset).l,d1
	bne.w	.comparebest
	move.w	#$7FFF,d3
.comparebest	cmp.w	d6,d3
	blt.w	.nextplayer
	move.w	d3,d6
	move.w	d1,d5
	bra.w	.nextplayer
.nextplayer	adda.l	#$8,a2
	addi.w	#$1,d1
	cmpi.w	#$1A,d1
	blt.w	.playerloop
.doneplayers	tst.w	d5
	bmi.w	.noeligible
	move.w	d5,(BA_Skater_Offset).l
.setskaterscnum	move.w	#$0,(BA_Sktr_SCnum).l
	tst.w	(BA_Team).l
	beq.w	.loadskater
	move.w	#$6,(BA_Sktr_SCnum).l
.loadskater	move.w	(BA_Sktr_SCnum).l,d0
	asl.w	#$7,d0
	movea.l	#SortCords,a3
	adda.w	d0,a3
	move.w	(BA_Skater_Offset).l,d3
	bra.w	.eligible
.noeligible	move.w	#$FFFF,d0
	bra.w	.exit
.eligible	move.w	#$1,d0
.exit	movem.l	(sp)+,d0-d7/a0-a6
	rts
	bclr	#$1,$62(a3)
	beq.w	.l19B52
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	X_1BD0A
.l197CC	btst	#$0,(disflags).l
	bne.w	.l197CC
	cmpi.w	#$258,(Crowdlevel).l
	bls.w	.l197F4
	move.w	#$258,(Crowdlevel).l
	addi.w	#$14,(CwdExciteLvl).l
.l197F4	move.w	(ExtraChars).l,d4
	movea.l	(RefsMap).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsPlain).l
	bset	#$3,(disflags).l
	bclr	#$0,$17F6A.l
	bclr	#$0,$17F6E.l
	clr.w	$17E32.l
	clr.b	$17ECE.l
	st.b	(RefCnt).l
	bclr	#$1,$17F6C.l
	st.b	(passReceiverPlayerNum).l
	bsr.w	X_213AC
	clr.w	(Vpos).l
	clr.w	(Hpos).l
	move.w	#$0,(puckx).l
	move.w	#$0,(pucky).l
	clr.w	$17B98.l
	clr.w	(puckvx).l
	clr.w	(puckvy).l
	clr.w	(puckvz).l
	st.b	$17BE0.l
	movea.l	#$17A80,a0
	clr.w	$28(a0)
	clr.w	$2A(a0)
	clr.w	$0(a0)
	move.w	#$10C,$14(a0)
	adda.w	#$80,a0
	clr.w	$28(a0)
	clr.w	$2A(a0)
	clr.w	$0(a0)
	move.w	#$FEF4,$14(a0)
	movea.l	#$17C00,a0
	move.w	#$18A,$6(a0)
	clr.w	$58(a0)
	clr.w	$4(a0)
	clr.w	$17B84.l
	bclr	#$6,$17F6A.l
	moveq	#$64,d4
.l198D0	bsr.w	X_150B2
	dbra	d4,.l198D0
	move.w	#$3C,$17EE0.l
	jsr	(ResetBench).l
	movea.l	#tmstruct,a2
	jsr	$3D426.l
	jsr	(SetupPenaltyShot).l
	adda.l	#$366,a2
	jsr	$3D426.l
	jsr	(SetupPenaltyShot).l
	jsr	$3F0C6.l
	move.l	a3,-(sp)
	movea.l	#$17A00,a3
	move.w	#$B,d2
.l1991C	cmp.w	(BA_Sktr_SCnum).l,d2
	beq.w	.l1994A
	cmp.w	(BA_Goalie_SCnum).l,d2
	beq.w	.l199D0
	move.w	#$FF10,$0(a3)
	clr.w	$14(a3)
	clr.w	$6(a3)
	move.w	#$20,d0
	bsr.w	X_1B2D8
	bra.w	.l19A8A
.l1994A	tst.w	$34(a3)
	bpl.w	.l1997E
	bclr	#$2,$63(a3)
	beq.w	.l1997E
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d3
	move.b	$66(a3),d3
	jsr	(setplayer).l
	movem.l	(sp)+,d0-d7/a0-a6
	tst.w	$34(a3)
	beq.w	.l1997C
	bpl.w	.l1997E
.l1997C	nop
.l1997E	move.w	(puckx).l,d0
	subi.w	#$0,d0
	move.w	d0,$0(a3)
	move.w	(pucky).l,d0
	btst	#$7,$62(a3)
	bne.w	.l199AA
	addi.w	#$10,d0
	move.w	#$4,$54(a3)
	bra.w	.l199B4
.l199AA	addi.w	#$FFF0,d0
	move.w	#$0,$54(a3)
.l199B4	move.w	d0,$14(a3)
	clr.w	$28(a3)
	clr.w	$2A(a3)
	clr.w	$2C(a3)
	move.w	#$11,d0
	bsr.w	X_1B2D8
	bra.w	.l19A8A
.l199D0	btst	#$0,$17F78.l
	beq.w	.l199FA
	move.b	$1A435.l,$66(a3)
	tst.w	(shootoutteam).l
	beq.w	.l19A0C
	move.b	$1A427.l,$66(a3)
	bra.w	.l19A0C
.l199FA	tst.w	$34(a3)
	bpl.w	.l19A2E
	bclr	#$2,$63(a3)
	beq.w	.l19A2E
.l19A0C	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d3
	move.b	$66(a3),d3
	jsr	(setplayer).l
	movem.l	(sp)+,d0-d7/a0-a6
	tst.w	$34(a3)
	bne.w	.l19A2C
	bpl.w	.l19A2E
.l19A2C	nop
.l19A2E	bclr	#$2,$63(a3)
	move.w	#$0,d0
	move.w	#$E5,d1
	btst	#$7,$62(a3)
	bne.w	.l19A4A
	move.w	#$FF1B,d1
.l19A4A	move.w	d0,$0(a3)
	move.w	d1,$14(a3)
	clr.w	$28(a3)
	clr.w	$2A(a3)
	clr.w	$18(a3)
	sub.w	(puckx).l,d0
	sub.w	(pucky).l,d1
	neg.w	d0
	neg.w	d1
	bsr.w	vtoa-LOAD
	move.w	d0,$54(a3)
	bclr	#$2,$63(a3)
	bclr	#$5,$62(a3)
	move.w	#$50C,d1
	bsr.w	X_1B3C0
.l19A8A	suba.l	#$80,a3
	dbra	d2,.l1991C
	jsr	(SprSort).l
	movea.l	(sp)+,a3
	bsr.w	ResetAndSelectPlayers-LOAD
	move.w	(BA_Goalie_SCnum).l,d0
	asl.w	#$7,d0
	movea.l	#SortCords,a3
	adda.w	d0,a3
	move.w	#$0,$0(a3)
	move.w	#$FF06,$14(a3)
	btst	#$7,$62(a3)
	bne.w	.l19ACC
	move.w	#$FA,$14(a3)
.l19ACC	move.w	(BA_Goalie_SCnum).l,d0
	move.w	#$1,d1
	btst	#$6,$62(a3)
	beq.w	.l19AE4
	move.w	#$2,d1
.l19AE4	cmp.w	(cont1team).l,d1
	bne.w	.l19AF8
	jsr	(setc1player).l
	bra.w	.l19B08
.l19AF8	cmp.w	(cont2team).l,d1
	bne.w	.l19B08
	jsr	(setc2player).l
.l19B08	move.w	#$E,d0
	bsr.w	X_1B2E4
	bset	#$7,$17F70.l
	bset	#$2,$17F6C.l
	move.w	#$190,$17F98.l
	tst.w	(cont1team).l
	bne.w	.l19B44
	tst.w	(cont2team).l
	bne.w	.l19B44
	move.w	#$64,$17F98.l
.l19B44	move.w	#$18,(palcount).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.l19B52	bset	#$2,$17F78.l
	move.w	#$18,d0
	dc.w	$6100,$1784,$426B,$0028,$426B,$002A,$4E75,$0001
	dc.w	$0203,$0405,$0600,$0001,$0503,$0402,$0000,$0003
	dc.w	$0501,$0400,$0000,$0000,$FF06,$FFDD,$FFCE,$0023
	dc.w	$FFCE,$FFCE,$FFF6,$0000,$FFF1,$0032,$FFF6,$0000
	dc.w	$FFC4
UpdatePenaltyShotEnd						;end the penalty shot when the goalie has the puck, the puck is loose or
									;the timer runs out
	movem.w	d0,-(sp)
	move.w	$17BE0.l,d0
	cmp.w	(BA_Goalie_SCnum).l,d0
	movem.w	(sp)+,d0
	beq.w	.setended
	btst	#$5,$17F70.l
	beq.w	.checktimer
	btst	#$5,$17F78.l
	bne.w	.puckloose
	tst.w	$17BE0.l
	bpl.w	.countdown
	bset	#$5,$17F78.l
.puckloose	tst.w	$17BE0.l
	bpl.w	.setended
.countdown	tst.w	(passmodetimer).l
	bmi.w	.setended
	subq.w	#$1,(passmodetimer).l
	bra.w	.checktimer
.setended	bset	#$4,$17F70.l
.checktimer	tst.w	(shootoutclock).l
	bne.w	.checkended
	bset	#$4,$17F70.l
.checkended	btst	#$4,$17F70.l
	bne.w	X_19C28
	rts
	dc.w	$0839,$0006,$0001,$7F70,$6600,$0092,$08F9,$0006
	dc.w	$0001,$7F70,$303C,$000A,$4EB9,$0003,$9456
EndPenaltyShotPlay						;stop play after a penalty shot or shootout attempt: freeze the window,
									;stop the clock, clear the penalty shot flags
	jsr	(freezewindow).l
	btst	#$0,$17F78.l
	bne.w	.stopplay
	move.w	#$A,(replaydelay).l
	bset	#$2,$17F6C.l
.stopplay	bset	#$0,$17F68.l
	bclr	#$2,$17F78.l
	bclr	#$2,$17F70.l
	bclr	#$3,$17F70.l
	bclr	#$5,$17F70.l
	bclr	#$4,$17F70.l
	bclr	#$6,$17F70.l
	movem.l	d0/a0,-(sp)
	movea.l	#SortCords,a0
	move.w	(BA_Sktr_SCnum).l,d0
	asl.w	#$7,d0
	move.b	$17F9C.l,$61(a0,d0.w)
	movem.l	(sp)+,d0/a0
	jsr	(CountShootoutGoals).l
