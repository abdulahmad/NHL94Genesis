	include	segacd\hockey.inc
	include	macros\genesis.mac

CC_Font1Pri	equ	$BF
CountButtonPress	equ	$2AD3A
Fprintsmall	equ	$3CEBE
Framer	equ	$38CA0
GoalieOdds	equ	$A
LOAD	equ	$1B000
OneTimerPass	equ	$2273A
OneTimerTarget	equ	$227B8
OptLine	equ	$18C0A
PuckOnAttackHalf	equ	$22CA4
ReadGoaliePulled	equ	$2AEDC
SortCords	equ	$17480
Sroot	equ	$3708E
TempWord1	equ	$17E62
assreplace	equ	$362E4
c1playernum	equ	$17F9E
c2playernum	equ	$17FA0
checkob	equ	$33D20
cont1team	equ	$17FA6
cont2team	equ	$17FA8
dirtab	equ	$36B8E
eraser	equ	$38C06
getpde	equ	$3C2A0
goaliemode1	equ	$18C0C
goaliemode2	equ	$18C0E
inputjoy	equ	$1AD7A
lastplayer	equ	$17E2A
linebar	equ	$3C746
linelist	equ	$419F6
loadTeamStruct	equ	$3C958
makepde	equ	$3C274
mesarea	equ	$17EF2
move	equ	$2C9C8
onetimerheight	equ	$1937A
passReceiverPlayerNum	equ	$17E30
passdir	equ	$17E2C
passmodetimer	equ	$17F9A
passspeed	equ	$17E2E
print	equ	$38F80
printscores1	equ	$3C48C
printx	equ	$18D58
printy	equ	$18D5A
printz	equ	$38F6E
puckvx	equ	$17BA8
puckvy	equ	$17BAA
puckvz	equ	$17BAC
puckvzadj	equ	$226A8
puckx	equ	$17B80
pucky	equ	$17B94
randomd0	equ	$37050
setc1player	equ	$312B8
setc2player	equ	$312DC
setpde	equ	$3C2C2
sflags6	equ	$17F76
sfx	equ	$3710C
shotplayer	equ	$17E28
swap	equ	$2779A
tmstruct	equ	$1834C
vtoa	equ	$362F8
X_15606	equ	$15606
X_15A6E	equ	$15A6E
X_15B08	equ	$15B08
X_15B50	equ	$15B50
X_15C58	equ	$15C58
X_15C9E	equ	$15C9E
X_15D64	equ	$15D64
X_15EC4	equ	$15EC4
X_16170	equ	$16170
X_16176	equ	$16176
X_1617A	equ	$1617A
X_162A4	equ	$162A4
X_162FE	equ	$162FE
X_163CA	equ	$163CA
X_16448	equ	$16448
X_167B6	equ	$167B6
X_167B8	equ	$167B8
X_167DC	equ	$167DC
X_1B3C0	equ	$1B3C0
X_1B3D6	equ	$1B3D6
X_1C044	equ	$1C044

	org	$157C4

doinput_chkanim						;Nothing while a3's animation runs (pflags2 bit 1); else skate a3
									;(doplayeracc)
	bchg	d0,d6
	bchg	d0,$250.w
	andi.l	#$1EC021E,-(a2)
	dc.w	$148E
	move.b	d0,(a2)+
	dc.w	$14F2,$1544
	btst	#$1,$63(a3)
	beq.w	.0
	rts
.0	tst.w	$34(a3)
	bne.w	X_1B3D6
	bclr	#$1,$17F70.l
	cmpi.w	#$24,$0(a3)
	ble.w	.1
	tst.w	$28(a3)
	bmi.w	.1
	beq.w	.1
	bset	#$1,$17F70.l
	clr.w	$28(a3)
.1	cmpi.w	#$FFDC,$0(a3)
	bge.w	.2
	tst.w	$28(a3)
	bpl.w	.2
	bset	#$1,$17F70.l
	clr.w	$28(a3)
.2	cmpi.w	#$E7,$14(a3)
	bgt.w	.4
	cmpi.w	#$FF19,$14(a3)
	ble.w	.4
	bra.w	.3
.3	movem.w	d0-d1,-(sp)
	move.w	$14(a3),d0
	move.w	$2A(a3),d1
	eor.w	d1,d0
	movem.w	(sp)+,d0-d1
	bpl.w	.4
	tst.w	$2A(a3)
	beq.w	.4
	bset	#$1,$17F70.l
	clr.w	$2A(a3)
.4	btst	#$1,$17F70.l
	bne.w	X_15606
	move.w	(TempWord1).l,d0
	bra.w	X_1B3D6
doinput_onetimer						;a3 is set for a one-timer: C (bit 5) starts the one-timer shot, else
									;skate
	move.w	(TempWord1).l,d0
	btst	#$3,$64(a3)
	bne.w	X_15A6E
	btst	#$5,d1
	beq.w	X_1B3D6
	movem.l	d7/a0,-(sp)
	move.w	(lastplayer).l,d7
	asl.w	#$7,d7
	movea.l	#SortCords,a0
	adda.w	d7,a0
	tst.w	$34(a0)
	movem.l	(sp)+,d7/a0
	beq.w	burst
	movem.w	d7,-(sp)
	move.w	$52(a3),d7
	cmp.w	(passReceiverPlayerNum).l,d7
	movem.w	(sp)+,d7
	bne.w	burst
	tst.w	$17BE0.l
	bpl.w	burst
	jsr	(PuckOnAttackHalf).l
	beq.w	burst
	move.w	d0,-(sp)
	move.w	d4,(inputjoy).l
	move.w	$17F96.l,$1AD7C.l
	move.w	#$23,d0		;assonetimer
	jsr	(assreplace).l
	move.w	(sp)+,d0
	rts
doinput_ispc						;a3 has the puck: pass mode, shot mode, or start a pass / shot by the
									;buttons
	bsr.w	checkob-LOAD
	tst.w	$34(a3)
	bne.w	.0
	btst	#$1,$63(a3)
	bne.w	X_15606
.0	btst	#$2,$17F6A.l
	bne.w	passmode
	btst	#$3,$17F6A.l
	bne.w	ShotMode
	btst	#$4,d1
	beq.w	.1
	jsr	(CountButtonPress).l
	bra.w	setpassmode
.1	btst	#$6,d1
	beq.w	.ahold
	tst.w	d4
	beq.w	.2
	move.b	#$F,$19381.l
	bra.w	.ahold
.2	move.b	#$F,$19380.l
.ahold	btst	#$6,d3
	beq.w	.arel
	tst.w	d4
	beq.w	.c1
	subi.b	#$1,$19381.l
	bpl.w	.4
	move.b	#$0,$19381.l
.4	tst.b	$19381.l
	bne.w	.arel
	bset	#$3,$17F74.l
	jsr	(setpassmode+LOAD).l
	bra.w	X_15B08
.c1	subi.b	#$1,$19380.l
	bpl.w	.6
	move.b	#$0,$19380.l
.6	tst.b	$19380.l
	bne.w	.arel
	bset	#$3,$17F74.l
	jsr	(setpassmode+LOAD).l
	bra.w	X_15B08
.arel	btst	#$6,d3
	bne.w	.8
	btst	#$6,d2
	beq.w	.8
	bset	#$3,$17F74.l
	bra.w	setpassmode
.8	tst.w	$34(a3)
	bne.w	.shot
	bra.w	X_1B3D6
.shot	btst	#$5,d1
	beq.w	X_1B3D6
	jsr	(CountButtonPress).l
	bra.w	X_163CA
doinput_islocked						;a3 is locked in an animation: B (bit 4) changes the controlled player
	move.w	$17BE0.l,d5
	cmp.w	$52(a3),d5
	beq.w	X_15606
	btst	#$4,d1
	beq.w	X_15A6E
	btst	#$6,$17F74.l
	bne.w	X_15A6E
	bsr.w	X_162A4
	movem.l	d0/a0,-(sp)
	move.w	(c1playernum).l,d0
	tst.w	d4
	beq.w	.0
	move.w	(c2playernum).l,d0
.0	tst.w	d0
	bmi.w	.x
	asl.w	#$7,d0
	movea.l	#SortCords,a0
	adda.w	d0,a0
	bset	#$6,$64(a0)
.x	movem.l	(sp)+,d0/a0
	dc.w	$4E75
getGoalieSCnum						;d0 = SCnum of the goalie in the 6 sort objects
									;up to object d0, -1 if none
	movem.l	d1/a0,-(sp)
	movea.l	#SortCords,a0
	asl.w	#$7,d0
	adda.w	d0,a0
	move.w	#$5,d1
.loop	tst.w	$34(a0)
	beq.w	.goalie
	suba.w	#$80,a0
	dbra	d1,.loop
	move.w	#$FFFF,d0
	bra.w	.end
.goalie	move.w	$52(a0),d0
.end	movem.l	(sp)+,d1/a0
	rts
faceoffinput						;controller processing for faceoff
	btst	#$6,$17F74.l
	beq.w	.0
	rts
.0	move.w	$36(a3),d4		;move assnum into d4
	cmpi.b	#$17,$38(a3,d4.w)		;check if afaceoffpl is in asslist at assnum position
	bne.w	X_15A6E		;exit if this is not a faceoff player
	movea.l	#$17EE6,a0		;faceoff direction of puck control variable
	btst	#$7,$62(a3)		;check which goal shooting on
	beq.w	.2		;branch if bottom goal
	movea.l	#$17EE8,a0
.2	move.w	d0,(a0)		;store dpad for faceoff pull
	btst	#$1,$63(a3)		;check if anim in progress
	beq.w	.l15AE8
	jmp	$30AB0.l
.l15AE8	btst	#$4,d1		;test for b button press
	beq.w	.1		;branch if pressed
	move.w	#$FEA,d1
	bset	#$1,$63(a3)		;set anim in progress
	bra.w	X_1B3C0
.1	move.w	#$1014,d1		;#SPAfaceoffr anim
	bra.w	X_1B3C0
	rts
	tst.w	(OptLine).l
	bne.w	X_15A6E
	btst	#$4,$17F7A.l
	bne.w	X_15A6E
	jsr	(loadTeamStruct).l
	bset	#$1,$32(a2)
	bne.w	X_15A6E
	btst	#$3,$17F74.l
	bne.w	.l15B42
	bclr	#$2,$17F6A.l
.l15B42	bclr	#$3,$17F6A.l
	bset	#$3,$63(a3)
	bsr.w	setlccords
	cmpi.w	#$F,(printy).l
	blt.w	.l15B6C
	bset	#$0,$17F6E.l
	bra.w	.l15B76
.l15B6C	jsr	$410EC.l
	bsr.w	setlccords
.l15B76	jsr	(Framer).l
	subi.w	#$2,(printy).l
	addi.w	#$1,(printx).l
	moveq	#$2,d4
.l15B8E	move.w	d4,d0
	bsr.w	X_15C58
	tst.w	d0
	bmi.w	.l15BEC
	btst	#$1,$32(a2)
	bne.w	.l15BB0
	cmp.w	$30(a2),d4
	bne.w	.l15BE4
	move.w	$16(a2),d0
.l15BB0	movea.l	#mesarea,a1
	move.l	#$44120,(a1)
	add.b	d4,$2(a1)
	jsr	(print).l
	move.w	d0,-(sp)
	movea.l	#linelist,a1
	jsr	(Fprintsmall).l
	move.w	(sp)+,d0
	jsr	(linebar).l
	subi.w	#$5,(printx).l
.l15BE4	subi.w	#$1,(printy).l
.l15BEC	dbra	d4,.l15B8E
	movea.l	$1E(a2),a1
	adda.w	$4(a1),a1
	adda.w	(a1),a1
	addi.w	#$2,(printx).l
	dc.w	$4EF9,$0003,$8F80
setlccords						;set printx/y to cords for lc box on team a2
	clr.w	d0
	cmpa.l	#$1834C,a2
	bne.w	.0
	eori.w	#$16,d0
.0	btst	#$1,$17F68.l		;reverse direction: flip to the other end
	beq.w	.l15C28
	eori.w	#$16,d0
.l15C28	jsr	(printz).l
	String	CC_Font1Pri,$16,$0
	add.w	d0,(printy).l
	moveq	#$2,d0
	bsr.w	.l15C58
	moveq	#$6,d1		;3 rows
	tst.w	d0
	bpl.w	.ex
	subi.w	#$1,d1		;no third choice: 2 rows
	addi.w	#$1,(printy).l
.ex	moveq	#$9,d0
	rts
.l15C58	movem.l	d1-d2,-(sp)
	move.w	$38C(a2),d2
	cmpa.l	#$1834C,a2
	beq.w	getlchoice2
	move.w	-$340(a2),d2
getlchoice2						;add $15 to d0 for each player more or fewer than the other team has on
									;the ice
	sub.w	$26(a2),d2
	beq.w	.0
	addi.w	#$15,d0
	tst.w	d2
	bmi.w	.0
	addi.w	#$15,d0
.0	move.w	$16(a2),d1
	add.w	d1,d0
	add.w	d1,d0
	add.w	d1,d0
	lea.l	X_15C9E(pc),a0
	move.b	(a0,d0.w),d0
	ext.w	d0
	movem.l	(sp)+,d1-d2
	rts
	dc.w	$0001,$0201,$0200,$0200,$0100,$0102,$0001,$0200
	dc.w	$0102,$0001,$0203,$04FF,$0304,$FF03,$04FF,$0304
	dc.w	$FF04,$03FF,$0304,$FF03,$04FF,$0506,$FF05,$06FF
	dc.w	$0506,$FF05,$06FF,$0506,$FF05,$06FF,$0605,$FF00
lineinput						;process input for line changes
									;d1 = new button presses
	btst	#$3,$17F74.l
	beq.w	.0
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(passmode+LOAD).l
	movem.l	(sp)+,d0-d7/a0-a6
.0	move.w	d1,-(sp)
	movea.l	#tmstruct,a2
	btst	#$6,$62(a3)
	beq.w	.2
	adda.w	#$366,a2
.2	bclr	#$0,$32(a2)		;Flag to start lc mode
	beq.w	.1
	bsr.w	lcfound_close		;close the old box
	bsr.w	X_15B50		;start lc mode
.1	move.w	(sp)+,d1
	clr.w	d2
	btst	#$6,d1
	bne.w	X_15D64
	addi.w	#$1,d2
	btst	#$4,d1
	bne.w	X_15D64
	addi.w	#$1,d2
	btst	#$5,d1
	bne.w	X_15D64
	btst	#$3,$62(a3)
	beq.w	.x
	btst	#$5,$62(a3)
	bne.w	.x
	btst	#$0,$63(a3)
	beq.w	X_1B3D6		;skate with dpad if not fighting
.x	rts
	dc.w	$3002,$3542,$0030,$6100,$FEEC,$4A40,$6A00,$0008
	dc.w	$4EF9,$0003,$0AB0,$08AB,$0003,$0063,$08EB,$0003
	dc.w	$0062,$4EB9,$0003,$C958,$08AA,$0001,$0032,$3540
	dc.w	$0016,$4EB9,$0003,$D426
lcfound_close						;close lc box
	btst	#$7,$17F6A.l
	bne.w	X_15EC4
	bsr.w	setlccords
	cmpi.w	#$F,(printy).l
	blt.w	.nollcm
	bclr	#$0,$17F6E.l
.nollcm	addi.w	#$1,d1		;d1 = 1 and d2 = $7FF tile: erase the box area
	move.w	#$7FF,d2
	bsr.w	eraser-LOAD
	jmp	(printscores1).l
burst						;cbut press check/speed. Also entered from check4check burst costs energy
									;$CC (only when line changes are on, OptLine = 0)
	jsr	(getpde).l		;get players energy
	tst.w	(OptLine).l
	bne.w	.0
	subi.w	#$CC,d0
	jsr	(setpde).l		;decrease players energy
	btst	#$4,$17F7A.l
	beq.w	.0
	move.w	#$1000,d0
.0	lsr.w	#$7,d0		;d0 will be $1000 with lines off
	move.w	d0,d1		;energy = speed increase (check violence)
	move.w	$54(a3),d2		;facedir
	asl.w	#$2,d2
	movea.l	#dirtab,a0
	muls.w	(a0,d2.w),d0
	muls.w	$2(a0,d2.w),d1
	add.w	d0,$28(a3)		;add to X Vel
	add.w	d1,$2A(a3)		;add to Y Vel
	bset	#$5,$62(a3)		;lock in this animation
	move.w	#$C5E,d1
	bra.w	X_1B3C0
Holdplayer						;abut press hold. a0 = the player this one is
									;assigned to, falls into Acheck
	bset	#$5,$62(a3)		;lock animation
	move.w	#$1122,d1		;move anim into d1 - normal hold check
	tst.w	$32(a3)		;check if impact = 0
	beq.w	X_1B3C0		;set anim if 0
	movea.l	#SortCords,a0		;move SortCord into a0
	move.w	$2E(a3),d0		;move last impact player into d0
	asl.w	#$7,d0		;calc offset
	adda.w	d0,a0		;add offset to a0
Acheck						;start SPAhook, or SPAHold if a0 is ahead
	bset	#$5,$62(a3)		;lock animation
	move.w	#$1122,d1		;move anim into d1 - normal hold check
	tst.w	$32(a3)		;check if impact = 0
	beq.w	.ex		;branch if 0
	move.w	$14(a3),d0		;move Ypos checker into d0
	sub.w	$14(a0),d0		;sub Ypos of player
	btst	#$7,$62(a3)		;check goal checker is shooting at
	beq.w	.air		;jump if bottom
	neg.w	d0		;make d0 negative
.air	bmi.w	.ex
	move.w	#$C90,d1		;set anim - hold check stick in air
.ex	bra.w	X_1B3C0
setpassmode						;initialize pass mode
	move.w	$54(a3),(passdir).l		;facedir, default pass direction
	andi.w	#$7,(passdir).l		;Passes first 3 bits of passdir
	btst	#$2,$17F70.l
	beq.w	.0
	bclr	#$2,$17F78.l
	bset	#$5,$17F70.l
	bne.w	X_15A6E
	bclr	#$5,$17F78.l
	move.w	#$64,(passmodetimer).l
.0	bset	#$2,$17F6A.l		;#sfspdir - set pass dir mode
	dc.w	$4E75
passmode						;dpad sets passdir until bbut changes
	btst	#$4,d2		;has b button changed?
	bne.w	dopass		;yes
	btst	#$3,$17F74.l		;Not in NHL Hockey Source
	bne.w	dopass
	btst	#$3,d0		;look for dpad
	bne.w	X_15EC4
	andi.w	#$7,d0		;pass first 3 bits of d0
	move.w	d0,(passdir).l		;new pass dir
	bset	#$3,d0
dopass						;pass the puck in passdir, to the best teammate there if any
	movem.l	d0-d5/a0-a1,-(sp)
	bclr	#$2,$17F6A.l		;#sfspdir
	st.b	$17BE0.l		;player is not puck handler anymore
	move.b	#$10,$5E(a3)
	move.w	$52(a3),(lastplayer).l
	bclr	#$3,$17F74.l		;Not in NHL Hockey Source
	beq.w	.noot
	jsr	(OneTimerTarget).l
	move.w	#$12,(onetimerheight).l
	btst	#$2,(sflags6).l
	beq.w	.1
	move.w	#$3A,(onetimerheight).l
.1	jsr	(OneTimerPass).l
	bra.w	.exit
.noot	moveq	#$8,d0		;moves 8 into d0
	tst.w	$34(a3)		;checks if goalie
	beq.w	.calc		;jump if goalie
	move.b	$6E(a3),d0		;Passacc
.calc	asl.w	#$2,d0		;d0 = passacc for player, 8 for goalie
	asr.w	#$1,d0		;change from NHL Hockey Source,
	addi.w	#$A0,d0
	move.w	d0,(passspeed).l		;Passspeed = PassAcc (0 to 30 decimal) * 2 + A0 (160 decimal)
	btst	#$0,$6E(a3)		;Checks to see if bit 0 in Passacc is 0
	beq.w	.findplayer		;Jumps if 0 (even number)
	asr.w	#$4,d0		;divide d0 by 16
	add.w	d0,(passspeed).l		;add d0 to passspeed
.findplayer	moveq	#-1,d4		;look for closest and best player to pass to
	moveq	#$5,d3		;Set total number of players (6 total, set to 5)
	movea.l	#SortCords,a1		;start of the home players' sort objects
	cmpi.w	#$6,$52(a3)		;compares 6 to SCnum(a3) (current player with puck) to check if
	blt.w	.0		;Jump if player is Home, continue if Away
	adda.w	#$300,a1		;Switch to Away Team Players
	btst	#$2,$17F70.l
	bne.w	.nopp
.0	cmpa.l	a1,a3		;Check to see if passing to self
	beq.w	.next		;skip if this is passing player
	tst.w	$34(a1)		;position(a1)
	beq.w	.next		;skip if goalie
	btst	#$2,$63(a1)		;check if player is unavailable
	bne.w	.next		;player unavailable
	move.w	$0(a1),d0		;X Position of receiving player
	sub.w	(puckx).l,d0		;sub puckx from d0
	move.w	$14(a1),d1		;Y position of receiving player
	sub.w	(pucky).l,d1		;sub pucky from d1
	movem.w	d0-d1,-(sp)		;push to stack
	bsr.w	vtoa-LOAD		;get direction of pass in d0
	movem.w	(sp)+,d1-d2		;pop from stack d1 is dX, d2 is dY
	sub.w	(passdir).l,d0		;sub passdir from d0
	andi.w	#$7,d0		;pass only lower 3 bits in d0
	asl.b	#$5,d0		;Multiply d0 by 32 (224 decimal is max)
	ext.w	d0		;sign extend d0 byte to d0 word
	asl.w	#$3,d0		;mult d0 by 8 (700 decimal max)
	muls.w	d0,d0		;square d0 = max is 490000 decimal
	cmpi.l	#$10000,d0		;compare to 65536 decimal (#256^2: power, SNASM ^ is xor)
	bhi.w	.next		;if higher branch to next
	muls.w	d1,d1		;square d1 (dX)
	muls.w	d2,d2		;square d2 (dY)
	add.l	d1,d2		;add together
	add.l	d0,d2		;add modified passdir to d2
	cmp.l	d4,d2		;compare d4 to d2
	bhi.w	.next		;branch if higher (player is farther away than the closest player)
	move.l	d2,d4		;move d2 into d4
	movea.l	a1,a0		;move a1 address into a0 (receiving player)
.next	adda.w	#$80,a1		;Skip to next player (80 hex is length of player struct)
	dbra	d3,.0
	tst.l	d4		;check if there's a player to pass to
	bmi.w	.nopp		;skip if no player to pass to
	bsr.w	passto
	bra.w	.exit
.nopp	move.w	(passdir).l,d0		;just hit puck in pass dir not to any player
	asl.w	#$2,d0
	movea.l	#dirtab,a0
	move.w	$2(a0,d0.w),d1		;y inc
	muls.w	(passspeed).l,d1
	move.l	#GoalieOdds,d2
	asl.l	d2,d1
	divs.w	#$BB8,d1
	add.w	$2A(a3),d1		;Yvel
	move.w	d1,(puckvy).l
	move.w	(a0,d0.w),d1		;X inc
	muls.w	(passspeed).l,d1
	asl.l	d2,d1
	divs.w	#$BB8,d1
	add.w	$28(a3),d1		;Xvel
	move.w	d1,(puckvx).l
	move.w	#$1000,d0
	bsr.w	randomd0-LOAD
	move.w	d0,(puckvz).l
.exit	tst.w	$34(a3)		;$34 = position
	bne.w	.notgoalie
	tst.w	(puckvy).l
	btst	#$7,$62(a3)		;$62 = pflags Checks for what goal team is shooting at (0=bottom, 1=top)
	beq.w	.g0
	bmi.w	.nvy
	bra.w	.notgoalie
.g0	bmi.w	.notgoalie
.nvy	neg.w	(puckvy).l		;negative velocity on puck
.notgoalie	move.w	(puckvx).l,d0		;d0/d1 = puck velocity -> direction for the animation (goalie swing,
	move.w	(puckvy).l,d1
	bsr.w	vtoa-LOAD
	move.w	#$366,d1		;SPA = Sprite Animation
	tst.w	$34(a3)		;$34 = position
	beq.w	.e1		;goalie anim.
	move.w	#$718,d1
	bsr.w	Findhittype
	beq.w	.e1
	move.w	#$78A,d1
.e1	bsr.w	X_1B3C0		;start the pass animation d1
	bset	#$5,$62(a3)		;#pfalock, $62 = pflags
	moveq	#$C,d0		;Rest to rts, not in NHL Hockey Source
	sub.b	(puckvz).l,d0
	lsr.w	#$2,d0
	andi.w	#$3,d0
	move.w	#$10,d0
	move.w	d0,-(sp)		;#SFXpass
	bsr.w	sfx-LOAD
	movem.l	(sp)+,d0-d5/a0-a1
	rts
passto						;pass the puck to player a0: a3 = passer
	btst	#$3,$62(a3)
	beq.w	X_1617A
	tst.w	$34(a3)
	bne.w	X_1617A
	movem.l	d0-d1,-(sp)
	btst	#$3,$62(a0)
	bne.w	X_16176
	bset	#$6,$64(a0)		;pflags3 bit 6
	move.w	(cont1team).l,d1
	cmp.w	(cont2team).l,d1		;checks to see if 2 player co-op (on same team)
	bne.w	.h2hor1p
	move.w	$52(a0),d0		;SCnum of receiver into d0
	move.w	$52(a3),d1		;SCnum of passer into d1
	cmp.w	(c1playernum).l,d1		;checks if cont 1 controlling passer
	bne.w	.p2passing
	jsr	(setc1player).l
	bra.w	X_16176
.p2passing	jsr	(setc2player).l
	bra.w	X_16176
.h2hor1p	move.w	#$1,d1
	btst	#$6,$62(a3)		;check if home or away team
	beq.w	.0		;branch if home
	move.w	#$2,d1		;away team
.0	move.w	$52(a0),d0		;move SCnum of receiver into d0
	cmp.w	(cont1team).l,d1		;compare cont1 team with d1 (1=home, 2=away)
	bne.w	X_16170
	jsr	(setc1player).l
	bra.w	X_16176
	dc.w	$4EB9,$0003,$12DC,$4CDF,$0003,$4EB9,$0003,$C958
	dc.w	$066A,$0001,$0012,$33E8,$0052,$0001,$7E30,$3A39
	dc.w	$0001,$7E2E,$E445,$C14B,$7013,$6100,$513C,$C14B
	dc.w	$2F08,$6100,$51BE,$D068,$0000,$9079,$0001,$7B80
	dc.w	$D268,$0014,$9279,$0001,$7B94,$48A7,$C000,$4C97
	dc.w	$000C,$E442,$E443,$3028,$0028,$C1FC,$00F0,$4840
	dc.w	$3228,$002A,$C3FC,$00F0,$4841,$48A7,$C000,$C1C2
	dc.w	$C3C3,$D041,$E340,$3800,$4C97,$0003,$C1C0,$C3C1
	dc.w	$CBC5,$4485,$DA80,$DA81,$C5C2,$C7C3,$D682,$C7C5
	dc.w	$E583,$3004,$C1C0,$9083,$6100,$5E84,$7601,$E445
	dc.w	$6600,$0004,$7A01,$3400,$4440,$9444,$48C2,$85C5
	dc.w	$5ACB,$FFF4,$6600,$0006,$0642,$0001,$0C42,$0018
	dc.w	$6300,$0004,$7418,$13C2,$0001,$7BAC,$0C42,$000C
	dc.w	$6D00,$000A,$13FC,$000C,$0001,$7BAC,$3002,$E740
	dc.w	$0440,$000A,$1140,$0040,$0440,$0006,$13C0,$0001
	dc.w	$7BDE,$4C9F,$0003,$C1C2,$E280,$D05F,$3179,$0001
	dc.w	$7B80,$0044,$D168,$0044,$C3C2,$E281,$D25F,$3179
	dc.w	$0001,$7B94,$0046,$D368,$0046,$C4FC,$0078,$4840
	dc.w	$81C2,$33C0,$0001,$7BA8,$4841,$83C2,$33C1,$0001
	dc.w	$7BAA,$4E75,$4EF9,$0002,$B4E2
Sweepcheck						;start sweep check on player a3
	bset	#$5,$62(a3)
	move.w	#$B24,d1
	bra.w	X_1B3C0
	cmp.w	(c1playernum).l,d0
	beq.w	.l162DA
	movem.l	d1/a0-a1,-(sp)
	move.w	(c1playernum).l,d1
	bsr.w	restorepl
	move.w	d0,(c1playernum).l
	movem.l	(sp)+,d1/a0-a1
.l162DA	rts
	cmp.w	(c2playernum).l,d0
	beq.w	X_162FE
	movem.l	d1/a0-a1,-(sp)
	move.w	(c2playernum).l,d1
	bsr.w	restorepl
	dc.w	$33C0,$0001,$7FA0,$4CDF,$0302,$4E75
restorepl						;restore old joy controlled player d1, give d0 the joystick; a d1 in line
									;change mode keeps control
	movea.l	#SortCords,a0
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
	beq.w	.0
	tst.w	(goaliemode2).l
	bra.w	.1
.0	tst.w	(goaliemode1).l
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
	beq.w	.l163C4
	dc.w	$013C,$00F0,$4E75
.l163C4	dc.w	$013C,$001E,$4E75
	btst	#$2,$17F70.l
	beq.w	.l163FA
	bclr	#$2,$17F78.l
	bset	#$5,$17F70.l
	bne.w	X_15A6E
	bclr	#$5,$17F78.l
	move.w	#$64,(passmodetimer).l
.l163FA	move.w	#$8,(passdir).l
	bset	#$3,$17F6A.l
	clr.w	d0
	move.w	#$128,d1
	btst	#$7,$62(a3)
	bne.w	.l1641C
	neg.w	d1
.l1641C	sub.w	$0(a3),d0
	sub.w	$14(a3),d1
	bsr.w	vtoa-LOAD
	move.w	#$F,(passspeed).l
	move.w	#$7FC,d1
	bsr.w	Findhittype
	beq.w	X_16448
	dc.w	$323C,$092E,$33FC,$000F,$0001,$7E2E,$6000,$4F76
ShotMode						;shot input
									;swing frame reached (anim frame 7*4): shoot, else dpad sets shot
									;direction
	cmpi.w	#$1C,$5A(a3)
	bge.w	prepshot		;end of animation so shoot
	btst	#$3,d0		;checks dpad for direction
	bne.w	.ss0
	andi.w	#$7,d0		;pass the first 3 bits of d0
	move.w	d0,(passdir).l		;set shot direction
.ss0	cmpi.w	#$10,$5A(a3)
	bge.w	X_167B6		;past full windup so no more passspeed
	add.w	d7,(passspeed).l
	cmpi.b	#$14,$6C(a3)		;6C = shot speed
	bge.w	.checkcbut
	cmpi.w	#$8,$5A(a3)		;SPANum
	bgt.w	.chganim
.checkcbut	btst	#$5,d2		;5 = #cbut
	beq.w	X_167B6		;button hasnt changed so continue windup
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
.getGoalie	jsr	(getGoalieSCnum+LOAD).l
	tst.w	d0
	bmi.w	.nogoalie
	movem.l	a0,-(sp)
	asl.w	#$7,d0
	movea.l	#SortCords,a0
	cmpi.w	#$250,$58(a0,d0.w)		;Checking goalie animations - pad stack right
	beq.w	.svgoalie
	cmpi.w	#$2A2,$58(a0,d0.w)		;Checking another goalie animation - pad stack left
.svgoalie	movem.l	(sp)+,a0		;pop stack value into a0
	bne.w	.cont
.nogoalie	cmpi.w	#$1,(passdir).l
	ble.w	.dir017		;branch if passdir is 0 or 1
	cmpi.w	#$7,(passdir).l
	bne.w	.cont		;branch if passdir is not 7
.dir017	move.w	(pucky).l,d0
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
.cont	bsr.w	X_167DC
	move.w	#$5,-(sp)		;#SFXshotwiff - sound effect
	move.w	$52(a3),(shotplayer).l
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
	move.w	(passspeed).l,d0
	lsr.w	#$2,d0		;sub 25% for backhand shots
	sub.w	d0,(passspeed).l
.nbh	btst	#$3,$64(a3)		;check if shooting one timer
	beq.w	.cont2		;jump if not
	movem.l	d0-d1,-(sp)		;push d0-d1 on stack
	move.w	#$1F,d0		;1F into d0 - one timer min speed
	move.w	d0,(passspeed).l		;make passspeed start with a higher value
	movem.l	(sp)+,d0-d1		;Pop off stack d0-d1
.cont2	clr.w	d0
	move.b	$6C(a3),d0		;6C = shotspd (ShP)
	lsr.b	#$1,d0		;divide by 2
	movea.l	a3,a0		;move a3 address into a0
	jsr	(makepde).l		;scale d0 based on energy level
	addi.w	#$14,d0		;add 14 to d0
	mulu.w	(passspeed).l,d0		;shot speed ranged by energy level
	mulu.w	#$5249,d0		;($4000*45)/35
	swap	d0		;swaps the upper and lower words of d0
	move.w	d0,(passspeed).l		;move d0 into passspeed
	btst	#$0,$6C(a3)		;checks if ShP value is even or odd
	beq.w	.even
	asr.w	#$4,d0		;divide by 16
	add.w	(passspeed).l,d0		;add passspeed to d0
.even	lsr.w	#$4,d0		;divide by 16 (d0 is passspeed)
	neg.w	d0		;negative
	addi.w	#$3,d0		;add 3 to d0
	bpl.w	.nbh2
	clr.w	d0		;clear if negative
.nbh2	add.w	d0,(sp)		;add to stack current value (Shot SFX)
	st.b	$17BE0.l		;clear puck carrier
	move.b	#$10,$5E(a3)		;5E = nopuck - no puck collision till 0
	move.w	$52(a3),(lastplayer).l		;SCNum
	move.w	#$108,d1		;$108 = top goal line Y position
	btst	#$7,$62(a3)		;pfgoal, pflags
	bne.w	.0		;branch if shooting up
	neg.w	d1		;flip d1 if shooting down
.0	move.w	(passdir).l,d2		;passdir into d2
	asl.w	#$2,d2		;mult by 4
	lea.l	X_167B8(pc),a0		;table of shot directions
	move.w	(a0,d2.w),d0		;xoffset
	move.w	$2(a0,d2.w),d2		;z offset
	sub.w	(puckx).l,d0
	sub.w	(pucky).l,d1
	movem.w	d0-d2,-(sp)		;push d0-d2(dx,dy,z offset) on stack
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	bsr.w	Sroot-LOAD
	tst.w	d0		;distance in pix to goal
	bne.w	.1
	addi.w	#$1,d0
.1	move.w	d0,d3		;straight line distance from puck to spot aiming for with passdir
	btst	#$4,$17F68.l		;check if highlight (always perfect)
	bne.w	.perf
	cmpi.w	#$C8,d3		;C8 = 200 decimal
	bhi.w	.notperf		;too far away from perfect shot
	jsr	(ReadGoaliePulled).l		;checks if shooting team's G pulled
	bmi.w	.perf		;perfect shot with pulled goalie
	btst	#$0,$17F78.l		;check if shootout
	bne.w	.perf		;perfect shot in shootout
	moveq	#$10,d0		;start value for ShA calc
	add.b	$6D(a3),d0		;shotacc(a3)
	bsr.w	randomd0-LOAD
	cmpi.w	#$E,d0		;chance of perfect shot
	bgt.w	.perf		;branch if higher - perfect shot
.notperf	clr.w	d0
	move.b	$6D(a3),d0		;shotacc(a3)
	lsr.w	#$1,d0		;divide by 2
	move.b	d0,-(sp)		;push on stack
	move.w	(passspeed).l,d0		;move passspeed into d0
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
	bsr.w	X_1C044		;RNG adj value
	add.w	d0,$2(sp)		;add result to x diff
	move.w	(sp),d0		;move adjusting value into d0
	cmpi.w	#$3C,d0		;compare to $3C (max adjustment in Y)
	bls.w	.lessx		;branch if less
	moveq	#$3C,d0
	move.w	d0,(sp)
.lessx	tst.w	$4(sp)
	bpl.w	.ycalc
	lsr.w	#$1,d0
.ycalc	bsr.w	X_1C044		;RNG adjustment
	add.w	d0,$4(sp)		;add to y diff
	move.w	(sp)+,d0		;pop adj value
	lsr.w	#$1,d0		;divide by 2
	bsr.w	randomd0-LOAD		;RNG result
	add.w	d0,$4(sp)		;add to Z diff
.perf	move.w	(passspeed).l,d2		;shot speed
	muls.w	#$44,d2		;1024/15
	muls.w	(sp)+,d2		;mult by x dist
	divs.w	d3,d2		;divide d2 by straight line distance
	move.w	d2,(puckvx).l		;move into puckvx
	move.w	(passspeed).l,d2
	muls.w	#$44,d2		;1024/15
	muls.w	(sp)+,d2		;mult by y dist
	divs.w	d3,d2		;divide d2 by straight line distance
	move.w	d2,(puckvy).l		;move into puckvy
	move.w	#$8000,d1		;this is the highest negative puckvy possible
	btst	#$7,$62(a3)		;check direction of shooting net
	beq.w	.2		;branch if bottom goal
	clr.w	d1
.2	eor.w	d2,d1		;EOR - checking to see if exceeding maximum puckvy
	bpl.w	.3		;branch if positive
	move.w	#$3810,(puckvy).l		;move into puckvy
	btst	#$7,$62(a3)		;check net shooting on
	bne.w	.3		;branch if top
	move.w	#$C7F0,(puckvy).l		;move into puckvy (shooting on bottom net)
.3	move.w	(sp)+,d1		;pix height in goal
	beq.w	.ex		;exit if zero
	mulu.w	(passspeed).l,d1
	mulu.w	#$44,d1		;1024/15
	divu.w	d3,d1		;by d3 = distance in pix to goal
	mulu.w	#$B33,d3		;(1024*42)/15
	divu.w	(passspeed).l,d3		;divide by passspeed
	add.w	d1,d3
	cmpi.w	#$1800,d3
	bls.w	.noup		;branch if less than
	move.w	#$1800,d3		;set max puckvz
.noup	move.w	d3,(puckvz).l		;move into puckvz
	bclr	#$4,$17F74.l		;check in-close top shelf bit
	beq.w	.ex		;if bit was cleared, exit
	btst	#$3,$64(a3)		;check if one timer
	bne.w	.ex		;branch if so
	jsr	(puckvzadj).l		;adjust puckvz for top shelf shot
.ex	bsr.w	sfx-LOAD		;play the shot sound
	movem.l	(sp)+,d0-d7/a0-a3
	rts
