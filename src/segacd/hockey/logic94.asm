;	HOCKEY.BIN $1498A-$1BBB1 (runtime $2F98A-$36BB1): logic94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	Player update, input and the assignments are the cartridge code. CD: the team struct offsets
;	from tmap on are a word further on; several early exits branch to a nearer rts than the
;	cartridge's shared rtss2 (left as X_ equates, noted); the pad reads and a few other lines are new.

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

SPAlist	equ	$20432
puckvzadj	equ	$226A8
OneTimerPass	equ	$2273A
OneTimerTarget	equ	$227B8
PuckOnAttackHalf	equ	$22CA4
stopna2	equ	$22F74
NextShooter	equ	$27A30
CountShootoutGoals	equ	$27A98
ShortenMsgTimer	equ	$2A05C
StartArenaAnim	equ	$2A41E
SetFaceoffAnim	equ	$2A456
EndArenaAnim	equ	$2A466
ChooseSong	equ	$2A478
PSandSOpassdir	equ	$2A648
StartShootoutPath	equ	$2A686
SkatePath	equ	$2A7B6
ShootoutShootCheck	equ	$2A84A
PlaceBoardFall	equ	$2AAE0
RandomFaceoffAnim	equ	$2AC4E
CheckScoreLeader	equ	$2ACA0
CountButtonPress	equ	$2AD3A
SetSflags8Bit1	equ	$2AE68
ReadGoaliePulled	equ	$2AEDC
LeadSong	equ	$2B2D6
chgplayer	equ	$2B4E2
startpause1	equ	$2C022
startpause2	equ	$2C034
startpause3	equ	$2C04C
startpause4	equ	$2C060
forceblack	equ	$36D0A
randomd0s	equ	$37044
randomd0	equ	$37050
Sroot	equ	$3708E
sfx	equ	$3710C
song	equ	$371D2
ReadJoy1	equ	$374F0
ReadJoy2	equ	$3750E
ReadJoy3	equ	$3752C
ReadJoy4	equ	$3754A
dobitmap	equ	$387E2
DecompressGraphicsPlain	equ	$38958
eraser	equ	$38C06
Framer	equ	$38CA0
printsmallz	equ	$38D8C
printz	equ	$38F6E
AddPenalty	equ	$3941A
AddPenalty2	equ	$39456
Stop4Pen	equ	$39A56
PushRef	equ	$39D02
checkcoll	equ	$3A0FA
checkpuckcoll	equ	$3B882
rtss2	equ	$3C000
makepde	equ	$3C274
getpde	equ	$3C2A0
setpde	equ	$3C2C2
ClrHor	equ	$3C3AC
printscores1	equ	$3C48C
getlinee	equ	$3C79E
loadTeamStruct	equ	$3C958
Fprintsmall	equ	$3CEBE
setpersonel	equ	$3D426
Setplass	equ	$3D754
setplayer	equ	$3D770
SprSort	equ	$3F03E
resetplstuff	equ	$3F0C6
box	equ	$410EC
asstab	equ	$415CC
linelist	equ	$419F6
ResetClock	equ	$2B9BC
clockcont_0	equ	$2BE98
X_317B6	equ	$317B6
X_31AB6	equ	$31AB6
X_31E14	equ	$31E14
X_33056	equ	$33056
X_3500C	equ	$3500C
X_358D4	equ	$358D4
X_35A3E	equ	$35A3E
DoDMA	equ	$3777C
print	equ	$38F80
linebar	equ	$3C746
AvgCline	equ	$3C7E2
Intermission	equ	$3CA0C
UpdateScores	equ	$3CBA0
SetupPenaltyShot	equ	$3D5E4
forcepldata	equ	$3D668
ResetBench	equ	$3D6E2
GameOver	equ	$3F29E
AddPlayoffTeamStats	equ	$40838
PenGhold	equ	$8
PenIcing	equ	$C
SPAHold	equ	$C90
SPAbenchcheckl	equ	$193E
SPAbenchcheckr	equ	$1A00
SPAboardback	equ	$185A
SPAboardfront	equ	$1776
SPAboardleft	equ	$18CC
SPAboardright	equ	$17E8
SPAburst	equ	$C5E
SPAcelebrate	equ	$E8A
SPAfaceoff	equ	$FEA
SPAfaceoffr	equ	$1014
SPAgdive	equ	$2F4
SPAgglovel	equ	$178
SPAgglovel2	equ	$1AA
SPAgglover	equ	$146
SPAghighl	equ	$14C0
SPAghighr	equ	$148E
SPAglide	equ	$50C
SPAglideback	equ	$A60
SPAgready	equ	$2
SPAgskate	equ	$3D8
SPAgslambot	equ	$1684
SPAgslamtop	equ	$1596
SPAgstackl	equ	$2A2
SPAgstackr	equ	$250
SPAgstick2l	equ	$1544
SPAgstick2r	equ	$14F2
SPAgstickl	equ	$21E
SPAgstickr	equ	$1EC
SPAgswing	equ	$366
SPAhook	equ	$1122
SPAinjury1	equ	$1AF4
SPAinjuryfall	equ	$145C
SPApassb	equ	$78A
SPApassf	equ	$718
SPApflip	equ	$46A
SPApump	equ	$EFC
SPAshotb	equ	$92E
SPAshotf	equ	$7FC
SPAskate	equ	$5D0
SPAskateback	equ	$A92
SPAskatewp	equ	$53E
SPAstanley	equ	$109E
SPAstop	equ	$6C6
SPAstumble	equ	$11E6
SPAsweepchk	equ	$B24
SPAturnl	equ	$662
SPAturnr	equ	$694
SPAwallleft	equ	$FAC
SPAwallright	equ	$F6E
SPFpuck	equ	$18A
SPFslambot	equ	$2C8
SPFslamtop	equ	$2C4

	org	$2F98A

;	Player logic. Turns controller input into skater actions (passing, shooting, checking, line changes) and
;	runs the computer players, with an assignment per position and for the goalie, bench and penalty box.
;	Also the puck at faceoffs, offsides and icing, plus the per-frame player update and scroll window.


; this routine calls all collision/animation/assignment code for all players
; d7 = elapse frames since last call
updateplayers						;this routine calls all collision/animation/assignment code for all
									;players. d7 = elapsed frames
	btst.b	#sfhor,(sflags).l		;check if screen is in horiz mode
	bne.w	.checkcrowd				;jump if horiz mode
	ori.w	#$F,(PadControlBits).l	;pads off
	cmpi.w	#5,(puckz).l			;check puckz with 5
	bgt.w	.gt
.clrcnt								;loop
	clr.w	(PuckZCntr).l
	bra.w	.checkcrowd
.gt									;puckz > 5
	move.w	(TmpPuckZ).l,d0
	cmp.w	(puckz).l,d0			;same?
	beq.w	.pzeq					;branch if puckz equal to TmpPuckZ
	move.w	(puckz).l,(TmpPuckZ).l
	bra.w	.clrcnt
.pzeq								;d0 = puckz
	addi.w	#1,(PuckZCntr).l		;add 1 to counter
	cmpi.w	#$10,(PuckZCntr).l		;compare counter to 10 (16 decmial)
	blt.w	.checkcrowd				;branch if less than
	clr.w	(PuckZCntr).l
	subi.w	#1,(puckz).l			;subtract 1 from puckz
.checkcrowd							;puck height done
	bclr.b	#6,(sflags7).l			;Bit 6 = Crowd Meter bit
	move.w	(CurCrowdMeter).l,d0	;Move cur crowd meter to d0
	cmp.w	(CrowdRecord).l,d0		;compare with crowd record
	blt.w	.nobreak				;branch if less than
	bset.b	#6,(sflags7).l			;set Crowd Meter bit
.nobreak							;crowd record flag set when the meter passes it
	jsr	(SetSflags8Bit1).l			;turn on bit 1 of sflags8
	tst.w	(puckc).l
	bmi.w	.scload					;branch if no puck carrier
	bclr.b	#7,(sflags8).l
	bclr.b	#1,(sflags6).l
	move.w	(puckc).l,d0			;move puckc SCnum into d0
	asl.w	#7,d0
	movea.l	#SortCords,a3			;start of player SCstructs
	adda.w	d0,a3					;add offset to a3
	btst.b	#pf3break,pflags3(a3)	;checks if there is a breakaway
	beq.w	.scload					;branch if no breakaway
	bclr.b	#4,(gmode2).l			;clear if breakaway
.scload								;breakaway flag handled
	movea.l	#$17480,a3				;CD: the cartridge has #(SortCords-M68K_RAM)
.top								;loop
	move.l	0(a3),OldXpos(a3)		;Xpos, oldXpos
	move.l	Ypos(a3),OldYpos(a3)
	move.l	Zpos(a3),OldZpos(a3)
	btst.b	#pf3fall,pflags3(a3)	;falling down?
	beq.w	.top2
	clr.w	Xvel(a3)
	clr.w	Yvel(a3)
	tst.w	SPAnum(a3)
	bne.w	.0						;branch if index not 0
	jsr	(PlaceBoardFall).l			;place him on the boards
	bra.w	.top2
.0									;falling in mid animation
	cmpi.w	#SPAbenchcheckl,SPA(a3)
	beq.w	.10
	cmpi.w	#SPAbenchcheckr,SPA(a3)	;right bench check?
	beq.w	.8
	cmpi.w	#SPAboardleft,SPA(a3)	;left boards?
	beq.w	.9
	cmpi.w	#SPAboardright,SPA(a3)	;right boards?
	beq.w	.7
	cmpi.w	#SPAboardfront,SPA(a3)	;front boards?
	beq.w	.1
	cmpi.w	#SPAboardback,SPA(a3)	;back boards?
	beq.w	.4
	bra.w	.top2
.1									;front boards: the wall Y
	move.w	#$124,d0				;wall Y
	cmpi.w	#$56,(FallXPos).l		;right corner?
	bgt.w	.2
	cmpi.w	#$FFAA,(FallXPos).l		;middle?
	bgt.w	.3
.2									;near a corner: the closer wall
	move.w	#$116,d0				;closer wall
.3									;set Y on the wall
	move.w	d0,Ypos(a3)
	bra.w	.top2
.4									;back boards
	move.w	#$FEDC,d0				;wall Y
	cmpi.w	#$56,(FallXPos).l		;right corner?
	bgt.w	.5
	cmpi.w	#$FFAA,(FallXPos).l		;middle?
	bgt.w	.6
.5									;near a corner: the closer wall
	move.w	#$FEEA,d0				;closer wall
.6									;set Y on the wall
	move.w	d0,Ypos(a3)
	bra.w	.top2
.7									;right boards
	move.w	#$82,0(a3)				;wall X
	btst.b	#3,attribute(a3)		;flipped?
	beq.w	.top2
	move.w	#$FF7E,0(a3)			;other side
	bra.w	.top2
.8									;right bench boards
	move.w	#$88,0(a3)				;wall X
	btst.b	#3,attribute(a3)		;flipped?
	beq.w	.top2
	move.w	#$FF78,0(a3)			;other side
	bra.w	.top2
.9									;left boards
	move.w	#$FF7E,0(a3)			;wall X
	btst.b	#3,attribute(a3)		;flipped?
	beq.w	.top2
	move.w	#$82,0(a3)				;other side
	bra.w	.top2
.10									;left bench boards
	move.w	#$FF78,0(a3)			;wall X
	btst.b	#3,attribute(a3)		;flipped?
	beq.w	.top2
	move.w	#$88,0(a3)				;other side
.top2								;each player on the ice
	tst.w	position(a3)			;check if on ice
	bmi.w	.nf1					;branch if not on ice
	move.w	SCnum(a3),d0
	cmp.w	(puckc).l,d0			;check if player has puck
	beq.w	.top3					;branch if puck carrier
	bclr.b	#pf3break,pflags3(a3)	;clear breakaway bit
	bclr.b	#pf3oside,pflags3(a3)
.top3								;puck carrier keeps his flags
	bsr.w	updateanim
	sub.b	d7,nopuck(a3)
	bpl.w	.np
	clr.b	nopuck(a3)				;clear upper byte of nopuck
.np									;upper byte done
	sub.b	d7,nopuck+1(a3)			;subtract # of frames from nopuck+1
	bpl.w	.np2
	clr.b	nopuck+1(a3)			;clear lower byte of nopuck
.np2								;lower byte done
	btst.b	#sf3icetime,(sflags3).l	;check if penalty timer is up
	beq.w	.11
	clr.w	d0
	move.b	pnum(a3),d0				;player offset on roster
	bmi.w	.11
	add.w	d0,d0
	addi.w	#$138,d0				;ice time table (CD: the cartridge has #$136)
	jsr	(loadTeamStruct).l			;a2 = team struct
	addi.w	#1,(a2,d0.w)			;add 1 to TOI for player
.11									;ice time counted
	cmpi.w	#SPAinjuryfall,SPA(a3)
	beq.w	.done
	cmpi.w	#SPAinjury1,SPA(a3)
	beq.w	.done
	moveq	#$11,d4					;NTSC speed
	tst.w	(PalMode).l				;PAL?
	beq.w	.notoside
	moveq	#$16,d4					;PAL speed
.notoside							;speed scale for NTSC or PAL
	mulu.w	d7,d4
	tst.w	Zpos(a3)
	bne.w	.y2
	moveq	#6,d2					;normal deceleration
	btst.b	#pfdoff,pflags(a3)		;pfdoff - player deceleration
	beq.w	.off
	moveq	#9,d2					;this value used when player receiving pass. Also the puck will use this
									;when "normal"
.off								;deceleration shift chosen
	move.w	Xvel(a3),d0
	beq.w	.x2
	asr.w	d2,d0					;shift d0 right d2 times
	bne.w	.x1						;branch if d0 not zero
	move.l	#1,d0					;make d0 1 if it was 0
.x1									;at least 1
	sub.w	d0,Xvel(a3)
.x2									;Xvel slowed
	move.w	Yvel(a3),d0
	beq.w	.y2						;branch if d0 is 0
	asr.w	d2,d0					;shift d0 to the right d2 times
	bne.w	.y1						;branch if d0 not 0
	move.l	#1,d0					;make d0 1 if it was 0
.y1									;at least 1
	sub.w	d0,Yvel(a3)				;sub d0 from Yvel
.y2									;Yvel slowed
	move.w	Xvel(a3),d0
	beq.w	.x3						;branch if d0 is 0
	muls.w	d4,d0					;mult d0 by d4
	add.l	d0,0(a3)				;add to Xpos
.x3									;X moved
	move.w	Yvel(a3),d0
	beq.w	.y3						;branch if d0 is 0
	muls.w	d4,d0					;mult d0 by d4
	add.l	d0,Ypos(a3)
.y3									;Y moved
	tst.w	Zpos(a3)
	bmi.w	.done
	bne.w	.z1						;branch if not 0
	tst.w	Zvel(a3)
	beq.w	.done
.z1									;in the air: gravity
	asl.w	#1,d4					;gravity: d4 = 32*d7
	sub.w	d4,Zvel(a3)				;Zvel -= it
	asl.w	#1,d4					;d4 = 64*d7
	sub.w	d4,Zvel(a3)				;Zvel -= it (96*d7 a frame in all)
	lsr.w	#2,d4					;d4 back to 16*d7, the position step
	move.w	Zvel(a3),d0				;move Zvel into d0
	muls.w	d4,d0					;mult d0 by d4
	add.l	d0,Zpos(a3)				;add d0 to Zpos
	bpl.w	.done					;branch if d0+Zpos is positive
	clr.l	Zpos(a3)
	neg.w	Zvel(a3)
	asr.w	Zvel(a3)				;divide Zvel by 2
	moveq	#5,d0					;move 5 into d0
	sub.b	Zvel(a3),d0				;sub Zvel from d0
	bpl.w	.chkpuck				;branch if result is positive
	clr.w	d0
.chkpuck							;bounce sound strength
	cmpi.w	#3,d0					;compare d0 to 3
	bhi.w	.done					;branch if higher than 3
	addi.w	#SFXpuckice,d0
	move.w	d0,-(sp)
	bsr.w	sfx
.done								;movement done
	move.w	SCnum(a3),d6
	cmp.w	(puckc).l,d6			;check if puck carrier
	bne.w	.tp						;not puck carrier
	btst.b	#pf2fight,pflags2(a3)	;pf2fight - check if fighting
	bne.w	.tp
	btst.b	#sfhor,(sflags).l		;#sfhor - check if in horiz mode
	bne.w	.tp
	moveq	#-2,d4					;-2 - pad index for puck carrier
	bsr.w	setpads					;set the pads
.tp									;pads checked
	btst.b	#sf2faceoff,(sflags2).l	;sf2faceoff- check for faceoff
	bne.w	.tp2
	tst.w	(holdreset).l			;reset hold?
	beq.w	.tp2
	subi.w	#1,(holdreset).l
	beq.w	.12						;ran out
	bpl.w	.tp2
.12									;hold timer ran out: reset the hold timers
	clr.w	(holdreset).l
	move.w	#$1111,(bholdtimer).l	;reset the B hold timers
	move.w	#$1111,(bholdtimer34).l
.tp2								;check each pad's player
	cmp.w	(c1playernum).l,d6		;check if cont 1 is puck carrier
	bne.w	.t0
	bsr.w	ReadJoy1
	clr.w	d4						;pad index for cont 1 player
	move.w	#$FFFF,(joypuckcarrier).l	;home pad
	bsr.w	doinput
	bra.w	.t1
.t0									;d6 <> c1playernum
	cmp.w	(c2playernum).l,d6		;check if cont 2 is puck carrier
	bne.w	.t1
	bsr.w	ReadJoy2
	move.l	#2,d4					;pad index for cont 2 player
	move.w	#$FFFF,(joypuckcarrier).l
	bsr.w	doinput
.t1									;pad 2 done
	cmpi.w	#$B,d6					;check if SCnum 0-11 were puck carrier (players)
	bgt.w	.t1cont
	tst.w	(cont3team).l			;check if there is 3 controllers?
	beq.w	.13
	cmp.w	(c3playernum).l,d6		;pad 3's player?
	bne.w	.13
	jsr	(ReadJoy3).l
	clr.l	d4
	clr.w	(joypuckcarrier).l
	move.w	(cont1team).l,-(sp)		;swap pad 3 into pad 1
	move.w	(cont3team).l,(cont1team).l
	move.w	(c1playernum).l,-(sp)
	move.w	(c3playernum).l,(c1playernum).l
	move.w	(bholdtimer).l,-(sp)
	move.w	(bholdtimer34).l,(bholdtimer).l
	move.w	(padword1).l,-(sp)
	move.w	(padword3).l,(padword1).l
	move.w	(aholdtimer).l,-(sp)
	move.w	(aholdtimer34).l,(aholdtimer).l
	move.w	(PadControlBits).l,-(sp)
	move.w	(PadControlBits34).l,(PadControlBits).l
	bsr.w	doinput
	move.w	(PadControlBits).l,(PadControlBits34).l
	move.w	(sp)+,(PadControlBits).l
	move.w	(aholdtimer).l,(aholdtimer34).l
	move.w	(sp)+,(aholdtimer).l
	move.w	(padword1).l,(padword3).l
	move.w	(sp)+,(padword1).l
	move.w	(bholdtimer).l,(bholdtimer34).l
	move.w	(sp)+,(bholdtimer).l
	move.w	(c1playernum).l,(c3playernum).l
	move.w	(sp)+,(c1playernum).l
	move.w	(cont1team).l,(cont3team).l
	move.w	(sp)+,(cont1team).l
.13									;pad 3 swap done
	tst.w	(cont4team).l			;check if there is 4 controllers?
	beq.w	.t1cont
	cmp.w	(c4playernum).l,d6		;pad 4's player?
	bne.w	.t1cont
	jsr	(ReadJoy4).l
	move.l	#2,d4					;pad index 2
	move.w	#1,(joypuckcarrier).l
	move.w	(cont2team).l,-(sp)		;swap pad 4 into pad 2
	move.w	(cont4team).l,(cont2team).l
	move.w	(c2playernum).l,-(sp)
	move.w	(c4playernum).l,(c2playernum).l
	move.w	(bholdtimer).l,-(sp)
	move.w	(bholdtimer34).l,(bholdtimer).l
	move.w	(padword2).l,-(sp)
	move.w	(padword4).l,(padword2).l
	move.w	(aholdtimer).l,-(sp)
	move.w	(aholdtimer34).l,(aholdtimer).l
	move.w	(PadControlBits).l,-(sp)
	move.w	(PadControlBits34).l,(PadControlBits).l
	bsr.w	doinput
	move.w	(PadControlBits).l,(PadControlBits34).l
	move.w	(sp)+,(PadControlBits).l
	move.w	(aholdtimer).l,(aholdtimer34).l
	move.w	(sp)+,(aholdtimer).l
	move.w	(padword2).l,(padword4).l
	move.w	(sp)+,(padword2).l
	move.w	(bholdtimer).l,(bholdtimer34).l
	move.w	(sp)+,(bholdtimer).l
	move.w	(c2playernum).l,(c4playernum).l
	move.w	(sp)+,(c2playernum).l
	move.w	(cont2team).l,(cont4team).l
	move.w	(sp)+,(cont2team).l
.t1cont								;pads done
	move.w	assnum(a3),d0
	clr.w	d1
	move.b	asslist(a3,d0.w),d1		;asslist of SCstruct
	asl.w	#2,d1
	movea.l	#asstab,a0
	movea.l	(a0,d1.w),a0			;get address of assignment to use for jmp
	jsr	(loadTeamStruct).l			;a2 = team struct
	jsr	(a0)						;call assignment for this player
	clr.w	Wallcos(a3)
	clr.w	Wallsin(a3)
	move.w	0(a3),d2				;Xpos
	move.w	Ypos(a3),d3
	cmp.w	OldXpos(a3),d2
	bne.w	.cc						;branch if not equal
	cmp.w	OldYpos(a3),d3
	beq.w	.nf
.cc									;moved: check for collisions
	jsr	(checkcoll).l
.nf									;collisions done or not moved
	move.w	d7,d0					;move d7 into d0 (elapsed frames)
	asl.w	#1,d0
	sub.w	d0,impact(a3)			;reduce impact at a constant rate
	bpl.w	.nf1
	clr.w	impact(a3)				;clear impact if negative or zero
.nf1								;impact ready
	move.w	impact(a3),limpact(a3)	;move impact into limpact
;CD: no cartridge twin
	adda.l	#$80,a3
	cmpi.w	#$F,SCnum-SCstruct(a3)	;compare Sortobjs-1 to SCnum-SCstruct
	blt.w	.top					;loop for all Sort objects
	rts
; frame switch control on struct a3
updateanim							;frame switch control on struct a3
	tst.w	SPA(a3)
	bne.w	.ia						;branch if not 0
	bclr.b	#pfalock,pflags(a3)
	bclr.b	#pf2aip,pflags2(a3)		;clear anim in progress
	rts
.ia									;an animation is set
	movea.l	#SPAlist,a0				;animation data tables
	adda.w	SPA(a3),a0				;add SPA to a0 address
	move.w	SPAattr(a0),d1			;16 dec - attributes for anim
	move.w	facedir(a3),d0
	btst.b	#sfhor,(sflags).l		;check if horizontal mode
	beq.w	.nhor
	cmpi.w	#$C,SCnum(a3)			;compare to 12 (check if a player, not the puck or nets)
	bge.w	.nhor					;branch if greater than (puck or nets)
	subi.w	#2,d0					;direction adjust for horizontal rink
	andi.w	#7,d0
.nhor								;direction ready
	btst.b	#3,attribute(a3)		;x flip flag
	beq.w	.nox					;branch if no flip
	neg.w	d0
	addi.w	#8,d0					;add 8 to d0 for flipping
	andi.w	#7,d0					;pass first 3 bits
.nox								;flip handled
	asl.w	#1,d0
	adda.w	(a0,d0.w),a0			;add a0 + d0 offset to a0 - This moves the SPF value into a0
	move.w	SPAnum(a3),d0			;SPANum into d0 (index into animation)
	move.w	(a0,d0.w),d2			;a0 + d0 offset into d2 - this is the new SPF frame of this animation
	tst.w	SPAcnt(a3)				;check if SPAcnt is 0 (time for a new frame)
	bmi.w	.1						;branch if so (SPAcnt is negative)
	sub.w	d7,SPAcnt(a3)			;sub frames elasped from SPAcnt
	bpl.w	.cframe					;branch if SPAcnt is positive
	addi.w	#4,SPAnum(a3)			;add 4 to SPAnum (set for next index)
	addi.w	#4,d0					;add 4 to d0 (currently holds current index)
	tst.w	-$2(a0,d0.w)			;test -2 offset from a0 + d0 (this is the frame
									;time for the previous frame)
	bpl.w	.1						;branch if positive (not the end of the animation)
	clr.w	d0
	clr.w	SPAnum(a3)
	bclr.b	#pfalock,pflags(a3)
	bclr.b	#pf2aip,pflags2(a3)		;clear animation in progress
	bclr.b	#pf3fall,pflags3(a3)	;clear fall down flag
	btst	#0,d1					;check if anim attribute loops
	bne.w	.1
	clr.w	SPA(a3)
.1									;looping animation keeps SPA
	move.w	$2(a0,d0.w),d0			;move frame time for animation frame into d0
	bpl.w	.0
	neg.w	d0						;make d0 negative (this is the case if final frame)
.0									;frame time ready
	move.w	d0,SPAcnt(a3)			;move d0 into SPAcnt
.cframe								;count down to the next frame
	sub.b	d7,glitch(a3)			;sub frames elapsed from glitch - limit minimum
									;time between frame switches
	bpl.w	.rtss					;branch if glitch is positive still
	clr.b	glitch(a3)
	cmp.w	frame(a3),d2			;compare frame to d2
	beq.w	.rtss
	move.w	d2,frame(a3)			;move d2 into frame
	move.b	#4,glitch(a3)			;move 4 into glitch - /60 sec min frame switch time
.rtss								;exit (also the end of the code above)
	rts
freezewindow						;lock scrolling to the current position
	move.w	(Vpos).l,(yc1).l
	move.w	(Hpos).l,(xc1).l
	bset.b	#sfslock,(sflags).l
	rts
checkwindow							;set Hpos and Vpos according to how the screen should follow the puck
	move.w	(yc1).l,d2
	move.w	(xc1).l,d3				;if locked, use these cordinates
	btst.b	#sfslock,(sflags).l		;locked?
	bne.w	.dd
	movea.l	#$17B80,a3				;CD: the cartridge has #(puckx-M68K_RAM)
	move.w	(puckc).l,d0
	bmi.w	.0
	asl.w	#7,d0					;* SCstruct
	movea.l	#$17480,a3				;CD: the cartridge has #(SortCords-M68K_RAM)
	adda.w	d0,a3
	move.w	d7,d0
	add.w	d0,d0
	btst.b	#pfgoal,pflags(a3)		;top goal?
	beq.w	.gd
	add.w	d0,(yleader).l
	cmpi.w	#$32,(yleader).l		;.ylmax = 50
	blt.w	.0
	move.w	#$32,(yleader).l		;limit
	bra.w	.0
.gd									;pfgoal clear
	sub.w	d0,(yleader).l
	cmpi.w	#$FFCE,(yleader).l		;past -$32?
	bgt.w	.0
	move.w	#$FFCE,(yleader).l		;limit
.0									;leader at its limit
	move.w	Yvel(a3),d2				;target y = Ypos + Yvel/128 + yleader
	asr.w	#7,d2
	add.w	Ypos(a3),d2
	add.w	(yleader).l,d2
	move.w	0(a3),d3				;Xpos
	move.w	d2,(yc1).l
	move.w	d3,(xc1).l
.dd									;target ready: scroll toward it
	move.w	d2,d0
	sub.w	(Vpos).l,d0
	cmpi.w	#$FFF6,d0				;near the top?
	bge.w	.1
	move.w	d2,d1
	subi.w	#$FFF6,d1				;-.ylim
	cmpi.w	#$FF38,d1				;past -$C8?
	bgt.w	.2
	move.w	#$FF38,d1				;limit
	bra.w	.2
.1									;below the top edge zone
	cmpi.w	#$A,d0					;near the bottom?
	ble.w	.2x
	move.w	d2,d1
	subi.w	#$A,d1
	cmpi.w	#$100,d1				;past $100?
	blt.w	.2
	move.w	#$100,d1				;limit
.2									;scroll target set
	sub.w	(Vpos).l,d1				;d1 = distance to scroll
	beq.w	.2x
	asr.w	#4,d1
	bne.w	.v2
	addi.w	#1,d1					;at least 1
.v2									;at least 1 pixel
	add.w	d1,(Vpos).l
.2x									;vertical done
	move.w	d3,d0
	sub.w	(Hpos).l,d0
	cmpi.w	#$FFD8,d0				;near the left?
	bge.w	.3
	move.w	d3,d1
	subi.w	#$FFD8,d1
	cmpi.w	#$FFC4,d1				;past -$3C?
	bge.w	.4
	move.w	#$FFC4,d1				;limit
	bra.w	.4
.3									;right of the left edge zone
	cmpi.w	#$28,d0					;near the right?
	ble.w	.x
	move.w	d3,d1
	subi.w	#$28,d1
	cmpi.w	#$3C,d1					;past $3C?
	ble.w	.4
	move.w	#$3C,d1					;limit
.4									;scroll target set
	sub.w	(Hpos).l,d1
	beq.w	.x
	asr.w	#4,d1
	bne.w	.h2
	addi.w	#1,d1					;at least 1
.h2									;at least 1 pixel
	add.w	d1,(Hpos).l
.x									;exit (also the end of the code above)
	rts


doinput								;process controller input: d0 = dpad, d1 = new buttons, d2 = changed
									;buttons, d3 = held buttons, d4 = controller 0/2
	btst	#4,d1					;B button
	beq.w	.1						;branch if not pressed
	btst	#5,d1					;C button
	beq.w	.1						;branch if not pressed
	bclr	#4,d1
	bset.b	#6,pflags3(a3)
	bra.w	.5
.1									;bit 4 of d1 clear or bit 5 of d1 clear
	btst	#4,d1
	beq.w	.2
	bclr.b	#6,pflags3(a3)
.2									;bit 4 of d2 check
	btst	#4,d2
	beq.w	.5
	bclr.b	#6,pflags3(a3)
	beq.w	.5
	tst.w	d4
	bne.w	.3
	move.b	#$11,(bholdtimer).l
	bra.w	.4
.3									;d4 <> 0
	move.b	#$11,(bholdtimer+1).l
.4									;timer set: drop the B change bit
	bclr	#4,d2
.5									;A+B+C cases done; in goalie mode shorten the message timer
	btst.b	#7,(gmode2).l
	beq.w	.6
;CD: no cartridge twin
	bclr	#$6,d0
	bclr	#$6,d1
	bclr	#$6,d2
	bclr	#$6,d3
	cmpi.b	#8,d0
	beq.w	.6
	jsr	(ShortenMsgTimer).l
;CD: no cartridge twin
	move.l	#$8,d0
	clr.l	d1
	clr.l	d2
	clr.l	d3
.6									;keep the pad
	move.w	d0,(TempWord1).l
	andi.w	#$F,(TempWord1).l
	bsr.w	setpads
	btst	#7,d1					;start button
	beq.w	.nostart				;branch if no start button pressed
	tst.w	(joypuckcarrier).l
	bpl.w	.7
	tst.w	d4
	beq.w	startpause1
	bra.w	startpause2
.7									;joypuckcarrier >= 0
	btst	#7,d1
	beq.w	.nostart
	tst.w	(joypuckcarrier).l
	beq.w	startpause3
	bra.w	startpause4
.nostart							;bit 7 of d1 clear
	btst.b	#sfhor,(sflags).l
	beq.w	.nhor
	btst	#3,d0
	bne.w	.nhor
	addi.w	#2,d0
	andi.w	#7,d0
.nhor								;faceoff check
	btst.b	#sf2faceoff,(sflags2).l
	bne.w	faceoffinput
	btst.b	#pf2lcm,pflags2(a3)
	bne.w	lineinput
	btst.b	#pfjoycon,pflags(a3)
	beq.w	rtss15
	movem.l	d0-d2/a0/a3,-(sp)
	move.w	(lastplayer).l,d0
	cmp.w	SCnum(a3),d0
	bne.w	.noot
	tst.w	(passReceiverPlayerNum).l
	bmi.w	.noot
	tst.w	(onetimerplayer).l
	bpl.w	.noot
	btst	#5,d1
	beq.w	.noot
	move.w	(passReceiverPlayerNum).l,d0
	asl.w	#7,d0
	movea.l	#SortCords,a3
	adda.w	d0,a3
	tst.w	position(a3)
	beq.w	.noot
	jsr	(PuckOnAttackHalf).l
	beq.w	.noot
	btst.b	#pfjoycon,pflags(a3)
	bne.w	.noot
	btst.b	#pf3onetimer,pflags3(a3)
	bne.w	.noot
	move.w	d4,(inputjoy).l
	move.w	(joypuckcarrier).l,(TmpJoyPuckCarrier).l
	move.w	#$23,d0					;assonetimer
	jsr	(assreplace).l
	movem.l	(sp)+,d0-d2/a0/a3
	rts
.noot								;pop the d0-d2/a0/a3 saved above
	movem.l	(sp)+,d0-d2/a0/a3
	btst.b	#pf3onetimer,pflags3(a3)
	bne.w	.chkfight
	btst.b	#pfalock,pflags(a3)
	bne.w	doinput_islocked
.chkfight							;fighting?
	btst.b	#pf2fight,pflags2(a3)	;fighting in progress
	bne.w	fightinput
	move.w	(puckc).l,d5
	cmp.w	SCnum(a3),d5
	beq.w	doinput_ispc
	tst.w	position(a3)
	beq.w	.11
	btst.b	#pf3onetimer,pflags3(a3)
	beq.w	.10
	bra.w	.11
.10									;pf3onetimer clear
	btst	#6,d1
	bne.w	Holdplayer
.11									;skater (position <> 0) or goalie: pick how B is handled
	tst.w	position(a3)
	beq.w	.12
	btst.b	#2,(BA_PS_flags).l
	bne.w	.noswitch
	bra.w	.bhold
.12									;goalie: B switches players only in goalie mode, and not from the puck
									;carrier
	btst.b	#6,(sflags5).l
	bne.w	.bhold
	tst.w	d4
	beq.w	.13
	tst.w	(goaliemode2).l
	bra.w	.14
.13									;d4 = 0
	tst.w	(goaliemode1).l
.14									;flags from this pad's goaliemode: off = B hold checks
	beq.w	.bhold
	movem.w	d0,-(sp)
	move.w	SCnum(a3),d0
	cmp.w	(puckc).l,d0
	movem.w	(sp)+,d0
	beq.w	.bhold
	bra.w	changeplayer
.bhold								;B still held (no holdreset): count down the hold timer, else treat it as
									;a press
	btst	#4,d3
	beq.w	.bpress
	tst.w	(holdreset).l
	bne.w	.bpress
	tst.w	d4
	beq.w	.c1
	tst.b	(bholdtimer+1).l
	beq.w	.noswitch
	subi.b	#1,(bholdtimer+1).l
	bpl.w	.16
	move.b	#0,(bholdtimer+1).l
.16									;timer clamped at 0
	tst.b	(bholdtimer+1).l
	bne.w	.bpress
	tst.w	d4
	beq.w	.17
	tst.w	(goaliemode2).l
	bra.w	.18
.17									;d4 = 0
	tst.w	(goaliemode1).l
.18									;goalie mode: handle as a press, else go to the goalie
	bne.w	.bpress
	bra.w	.goalie
.c1									;d4 = 0
	tst.b	(bholdtimer).l
	beq.w	.noswitch
	subi.b	#1,(bholdtimer).l
	bpl.w	.20
	move.b	#0,(bholdtimer).l
.20									;timer clamped at 0
	tst.w	d4
	beq.w	.21
	tst.w	(goaliemode2).l
	bra.w	.22
.21									;d4 = 0
	tst.w	(goaliemode1).l
.22									;goalie mode: press; else the goalie once the hold timer is out
	bne.w	.bpress
	tst.b	(bholdtimer).l
	beq.w	.goalie
.bpress								;B pressed: start this pad's hold timer; released (.brel): switch players
	btst	#4,d1
	beq.w	.brel
	tst.w	d4
	bne.w	.24
	move.b	#$11,(bholdtimer).l
	bra.w	.noswitch
.24									;d4 <> 0
	move.b	#$11,(bholdtimer+1).l
	bra.w	.noswitch
.brel								;bit 4 of d1 clear
	btst	#4,d2
	beq.w	.noswitch
	btst	#4,d3
	bne.w	.noswitch
	move.w	(bholdtimer).l,d0
	tst.w	d4
	beq.w	.28
	move.b	#$11,(bholdtimer+1).l
	andi.w	#$FF,d0
	bne.w	changeplayer
	tst.w	d4
	beq.w	.26
	tst.w	(goaliemode2).l
	bra.w	.27
.26									;d4 = 0
	tst.w	(goaliemode1).l
.27									;goalie mode: switch players, else take the goalie
	bne.w	changeplayer
	bra.w	.goalie
.28									;d4 = 0
	move.b	#$11,(bholdtimer).l
	andi.w	#$FF00,d0
	bne.w	changeplayer
	tst.w	d4
	beq.w	.29
	tst.w	(goaliemode2).l
	bra.w	.30
.29									;d4 = 0
	tst.w	(goaliemode1).l
.30									;goalie mode: switch players, else take the goalie
	bne.w	changeplayer
.goalie								;take the goalie of a3's team (SCnum 5 home, 11 away) unless holdreset
	tst.w	(holdreset).l
	bne.w	changeplayer
	move.w	#5,d0
	cmpi.w	#5,d6
	ble.w	.32
	move.w	#$B,d0
.32									;pad's goalie
	jsr	(getGoalieSCnum).l
	tst.w	d0
	bmi.w	rtss15
	movem.l	d0/a3,-(sp)
	movea.l	#SortCords,a3
	asl.w	#7,d0
	adda.w	d0,a3
	btst.b	#pfjoycon,pflags(a3)
	movem.l	(sp)+,d0/a3
	bne.w	rtss15
	tst.w	d4
	beq.w	setc1player
	bra.w	setc2player
.noswitch							;no switch: one-timer setup, A pass / line change, or the C button
	tst.w	position(a3)
	bne.w	doinput_onetimer
	btst	#6,d1
	beq.w	doinput_cbut
	move.w	(TempWord1).l,d0
	cmpi.b	#8,d0
	beq.w	doinput_cbut
	move.w	d0,facedir(a3)
	move.b	#8,nopuck(a3)
	move.w	#SPAgdive,d1			;goalie dive animation
	bsr.w	SetSPA
	bset.b	#pf2aip,pflags2(a3)
	bset.b	#pfalock,pflags(a3)
	addi.w	#$96,(Crowdlevel).l
rtss15								;shared rts for the early exits nearby
	rts
doinput_cbut						;C button (bit 5): hold / release handling for a3, then doinput_chkanim
	btst	#5,d1
	bne.w	.press
	btst	#5,d3
	bne.w	.held
	bclr.b	#7,pflags2(a3)
	bra.w	doinput_chkanim
.held								;bit 5 of d3 set
	btst.b	#7,pflags2(a3)
	beq.w	doinput_chkanim
	movem.l	d0-d3/a0-a3,-(sp)
	movea.l	#SPAlist,a0
	adda.w	SPA(a3),a0
	move.w	facedir(a3),d0
	btst.b	#3,attribute(a3)
	beq.w	.1
	neg.w	d0
	addi.w	#8,d0
	andi.w	#7,d0
.1									;facedir mirrored for flipped animations (attribute bit 3)
	asl.w	#1,d0
	adda.w	(a0,d0.w),a0
	tst.b	SPAnum+1(a3)
	movem.l	(sp)+,d0-d3/a0-a3
	bpl.w	rtss15
	move.w	#$A,SPAcnt(a3)
	rts
.press								;bit 5 of d1 set
	btst.b	#pfalock,pflags(a3)
	bne.w	doinput_chkanim
	movem.w	d0-d1,-(sp)
	move.w	(puckx).l,d0
	sub.w	0(a3),d0
	move.w	(pucky).l,d1
	sub.w	Ypos(a3),d1
	bsr.w	vtoa
	move.w	d0,facedir(a3)
	movem.w	(sp)+,d0-d1
	move.w	(TempWord1).l,d0
	bclr.b	#0,(BA_PS_flags).l
	move.w	(gameclock).l,d0
	andi.w	#7,d0
	asl.w	#4,d0
	addi.w	#$A0,d0
	cmpi.w	#$DB,(pucky).l
	bgt.w	.3
	cmpi.w	#$FF25,(pucky).l
	bgt.w	.4
.3									;puck Y outside the zone
	subi.w	#$40,d0
.4									;d0 = lead time: shorter near the ends (pucky past the blue lines)
	move.w	d0,d1
	muls.w	(puckvx).l,d0
	swap	d0
	add.w	(puckx).l,d0
	muls.w	(puckvy).l,d1
	swap	d1
	add.w	(pucky).l,d1
	bsr.w	ClampTargetY
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	cmpi.l	#$384,d0
	bhi.w	.far
	movem.w	(sp)+,d0-d1
	bra.w	.near
.far								;d0 > $384
	bsr.w	Sroot
	moveq	#1,d2
	add.w	d0,d2
	moveq	#$12,d4
	btst.b	#sfssdir,(sflags).l
	beq.w	.6
	addi.w	#8,d4
.6									;pop the d0-d1 saved above
	movem.w	(sp)+,d0-d1
	muls.w	d4,d1
	addi.w	#8,d4
	muls.w	d4,d0
	divs.w	d2,d0
	divs.w	d2,d1
.near								;target within 30 pixels: no scaling
	add.w	d3,d1
	move.w	d1,d2
	cmpi.w	#$22,2(a0)
	cmpi.w	#$18,(a0)
	cmpi.w	#$FFE8,(a0)
	cmpi.w	#$C,2(a0)
	cmpi.w	#$108,(pucky).l
	cmpi.w	#$FEF8,(pucky).l
	bset.b	#pf2aip,pflags2(a3)
	bne.w	doinput_chkanim
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#puckcross,a0
	move.w	#$108,d3
	btst.b	#pfgoal,pflags(a3)		;check which net shooting on
	beq.w	.save					;branch if bottom net
	neg.w	d3						;negate d3 (-108 hex)
;CD: no cartridge twin
	adda.w	#$4,a0
.save								;goalie save
	jsr	(goaliesave).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ClampTargetY						;clamp the target y d1 for player a3 (d0 cleared when a3 has the puck)
	move.w	(puckc).l,d2
	cmp.w	SCnum(a3),d2
	bne.w	.0
	clr.w	d0
.0									;d0 cleared when a3 is the puck carrier
	cmpi.w	#$103,d1
	blt.w	.1
	move.w	#$103,d1
.1									;clamp X high
	cmpi.w	#$FEFD,d1
	bgt.w	.2
	move.w	#$FEFD,d1
.2									;clamp d1 to the top limit
	sub.w	d3,d1
	rts
	;10 SPA offsets, unreferenced: SPAgglover, SPAgglovel, SPAgstackr, SPAgstackl
	;SPAgstickr, SPAgstickl, then the newer tables SPAghighr, SPAghighl, SPAgstick2r, SPAgstick2l
	dc.w	SPAgglover,SPAgglovel,SPAgstackr,SPAgstackl,SPAgstickr,SPAgstickl,SPAghighr,SPAghighl,SPAgstick2r,SPAgstick2l
doinput_chkanim						;Nothing while a3's animation runs (pflags2 bit 1); else skate a3
									;(doplayeracc)
	btst.b	#pf2aip,pflags2(a3)
	beq.w	.0
	rts
.0									;pf2aip clear
	tst.w	position(a3)
	bne.w	doplayeracc
	bclr.b	#1,(BA_PS_flags).l
	cmpi.w	#$24,0(a3)
	ble.w	.1
	tst.w	Xvel(a3)
	bmi.w	.1
	beq.w	.1
	bset.b	#1,(BA_PS_flags).l
	clr.w	Xvel(a3)
.1									;both x limits checked; now y
	cmpi.w	#$FFDC,0(a3)
	bge.w	.2
	tst.w	Xvel(a3)
	bpl.w	.2
	bset.b	#1,(BA_PS_flags).l
	clr.w	Xvel(a3)
.2									;x inside -36: keep Xvel
	cmpi.w	#$E7,Ypos(a3)
	bgt.w	.4
	cmpi.w	#$FF19,Ypos(a3)
	ble.w	.4
	bra.w	.3
.3									;in the y band: test whether a3 skates outward
	movem.w	d0-d1,-(sp)
	move.w	Ypos(a3),d0
	move.w	Yvel(a3),d1
	eor.w	d1,d0
	movem.w	(sp)+,d0-d1
	bpl.w	.4
	tst.w	Yvel(a3)
	beq.w	.4
	bset.b	#1,(BA_PS_flags).l
	clr.w	Yvel(a3)
.4									;stopped at a limit (BA_PS_flags bit 1): no skating this frame
	btst.b	#1,(BA_PS_flags).l
	bne.w	rtss15
	move.w	(TempWord1).l,d0
	bra.w	doplayeracc
doinput_onetimer					;a3 is set for a one-timer: C (bit 5) starts the one-timer shot, else
									;skate
	move.w	(TempWord1).l,d0
	btst.b	#pf3onetimer,pflags3(a3)
	bne.w	rtss7
	btst	#5,d1
	beq.w	doplayeracc
	movem.l	d7/a0,-(sp)
	move.w	(lastplayer).l,d7
	asl.w	#7,d7
	movea.l	#SortCords,a0
	adda.w	d7,a0
	tst.w	position(a0)
	movem.l	(sp)+,d7/a0
	beq.w	burst
	movem.w	d7,-(sp)
	move.w	SCnum(a3),d7
	cmp.w	(passReceiverPlayerNum).l,d7
	movem.w	(sp)+,d7
	bne.w	burst
	tst.w	(puckc).l
	bpl.w	burst
	jsr	(PuckOnAttackHalf).l
	beq.w	burst
	move.w	d0,-(sp)
	move.w	d4,(inputjoy).l
	move.w	(joypuckcarrier).l,(TmpJoyPuckCarrier).l
	move.w	#$23,d0					;assonetimer
	jsr	(assreplace).l
	move.w	(sp)+,d0
	rts
doinput_ispc						;a3 has the puck: pass mode, shot mode, or start a pass / shot by the
									;buttons
	bsr.w	checkob
	tst.w	position(a3)
	bne.w	.0
	btst.b	#pf2aip,pflags2(a3)
	bne.w	rtss15
.0									;goalies without pf2aip go on to pass / shot mode
	btst.b	#sfspdir,(sflags).l
	bne.w	passmode
	btst.b	#sfssdir,(sflags).l
	bne.w	ShotMode
	btst	#4,d1
	beq.w	.1
	jsr	(CountButtonPress).l
	bra.w	setpassmode
.1									;bit 4 of d1 clear
	btst	#6,d1
	beq.w	.ahold
	tst.w	d4
	beq.w	.2
	move.b	#$F,(aholdtimer+1).l
	bra.w	.ahold
.2									;d4 = 0
	move.b	#$F,(aholdtimer).l
.ahold								;B hold timer set for this pad
	btst	#6,d3
	beq.w	.arel
	tst.w	d4
	beq.w	.c1
	subi.b	#1,(aholdtimer+1).l
	bpl.w	.4
	move.b	#0,(aholdtimer+1).l
.4									;timer clamped at 0
	tst.b	(aholdtimer+1).l
	bne.w	.arel
	bset.b	#3,(sflags5).l
	jsr	(setpassmode).l
	bra.w	SetLCmode
.c1									;d4 = 0
	subi.b	#1,(aholdtimer).l
	bpl.w	.6
	move.b	#0,(aholdtimer).l
.6									;timer clamped at 0
	tst.b	(aholdtimer).l
	bne.w	.arel
	bset.b	#3,(sflags5).l
	jsr	(setpassmode).l
	bra.w	SetLCmode
.arel								;A not held: release starts a pass or a line change
	btst	#6,d3
	bne.w	.8
	btst	#6,d2
	beq.w	.8
	bset.b	#3,(sflags5).l
	bra.w	setpassmode
.8									;bit 6 of d3 set or bit 6 of d2 clear
	tst.w	position(a3)
	bne.w	.shot
	bra.w	doplayeracc
.shot								;skater: C starts a shot
	btst	#5,d1
	beq.w	doplayeracc
	jsr	(CountButtonPress).l
	bra.w	SetShotMode
doinput_islocked					;a3 is locked in an animation: B (bit 4) changes the controlled player
	move.w	(puckc).l,d5
	cmp.w	SCnum(a3),d5
	beq.w	rtss15
	btst	#4,d1
	beq.w	rtss7
	btst.b	#6,(sflags5).l
	bne.w	rtss7
	bsr.w	changeplayer
	movem.l	d0/a0,-(sp)
	move.w	(c1playernum).l,d0
	tst.w	d4
	beq.w	.0
	move.w	(c2playernum).l,d0
.0									;player chosen
	tst.w	d0
	bmi.w	.x
	asl.w	#7,d0
	movea.l	#SortCords,a0
	adda.w	d0,a0
	bset.b	#6,pflags3(a0)
.x									;exit: restore the registers
	movem.l	(sp)+,d0/a0
rtss7								;shared rts for the early exits nearby
	rts
; Find goalie SCnum, store in d0
; If no goalie, store FFFF in d0
getGoalieSCnum						;d0 = SCnum of the goalie in the 6 sort objects
									;up to object d0, -1 if none
	movem.l	d1/a0,-(sp)
	movea.l	#SortCords,a0
	asl.w	#7,d0
	adda.w	d0,a0
	move.w	#5,d1
.loop								;scan the 6 objects down from d0 for the goalie (position 0)
	tst.w	position(a0)
	beq.w	.goalie
	suba.w	#$80,a0
	dbf	d1,.loop
	move.w	#$FFFF,d0
	bra.w	.end
.goalie								;found: d0 = its SCnum
	move.w	SCnum(a0),d0
.end								;exit: restore the registers
	movem.l	(sp)+,d1/a0
	rts
faceoffinput						;controller processing for faceoff
	btst.b	#6,(sflags5).l
	beq.w	.0
	rts
.0									;bit 6 of sflags5 clear
	move.w	assnum(a3),d4			;move assnum into d4
	cmpi.b	#$17,asslist(a3,d4.w)	;check if afaceoffpl is in asslist at assnum position
	bne.w	rtss7					;exit if this is not a faceoff player
	movea.l	#(fodir1-M68K_RAM),a0	;faceoff direction of puck control variable
	btst.b	#pfgoal,pflags(a3)		;check which goal shooting on
	beq.w	.2						;branch if bottom goal
	movea.l	#(fodir2-M68K_RAM),a0
.2									;store the faceoff dpad
	move.w	d0,(a0)					;store dpad for faceoff pull
	btst.b	#pf2aip,pflags2(a3)		;check if anim in progress
;CD: no cartridge twin
	beq.w	.L30AE8
	jmp	$30AB0.l
.L30AE8
	btst	#4,d1					;test for b button press
	beq.w	.1						;branch if pressed
	move.w	#SPAfaceoff,d1
	bset.b	#pf2aip,pflags2(a3)		;set anim in progress
	bra.w	SetSPA
.1									;bit 4 of d1 clear
	move.w	#SPAfaceoffr,d1			;#SPAfaceoffr anim
	bra.w	SetSPA
fightinput							;controller processing for fighting
	rts								;controller processing for fighting
; initiate line change option if available
SetLCmode							;Initiate line change option if available (abut
									;pressed by the puck carrier)
	tst.w	(OptLine).l
	bne.w	rtss7
	btst.b	#4,(sflags7).l
	bne.w	rtss7
;CD: no cartridge twin
	jsr	(loadTeamStruct).l
	bset.b	#$1,$32(a2)
	bne.w	rtss7
	btst.b	#3,(sflags5).l
	bne.w	.0
	bclr.b	#sfspdir,(sflags).l
.0									;clear the shot dir
	bclr.b	#sfssdir,(sflags).l
	bset.b	#pf2lcm,pflags2(a3)
SetLCmode2							;a2 = team struct. Draw the line change box
	bsr.w	setlccords				;set screen cords for this teams lc box
	cmpi.w	#$F,(printy).l
	blt.w	.box
	bset.b	#sf3llcs,(sflags3).l	;flag for lower (on screen) line change
	bra.w	.frame
.box								;printy < $F
	jsr	(box).l
	bsr.w	setlccords
;CD: no cartridge twin
.frame								;CD: placed where the disc branches to it
	jsr	(Framer).l
	subi.w	#2,(printy).l
.0									;first row: the three line choices
	addi.w	#1,(printx).l
	moveq	#2,d4
.loop								;d4 = 2..0: one row per button
	move.w	d4,d0					;next row; d4 = row/button number
	bsr.w	getlchoice
	tst.w	d0
	bmi.w	.next					;no line for this button
	btst.b	#tmflcm,tmflags(a2)
	bne.w	.pr
	cmp.w	tmlcchoice(a2),d4		;box being closed: only the chosen row
	bne.w	.up
	move.w	tmline(a2),d0
.pr									;print the row
	movea.l	#$17EF2,a1				;a1 = message area; row letter string (CD: the cartridge has
									;#(mesarea-M68K_RAM))
	move.l	#$44120,(a1)			;String length 4, 'A '
	add.b	d4,2(a1)				;'A'-'C'
;CD: no cartridge twin
	jsr	(print).l
	move.w	d0,-(sp)
	movea.l	#linelist,a1
	jsr	(Fprintsmall).l
	move.w	(sp)+,d0
	jsr	(linebar).l
	subi.w	#5,(printx).l
.up									;next row up
	subi.w	#1,(printy).l
.next								;loop the rows
	dbf	d4,.loop					;repeat for the other rows
	movea.l	tmdata(a2),a1			;team name
	adda.w	Teamname(a1),a1
	adda.w	(a1),a1
	addi.w	#2,(printx).l
;CD: no cartridge twin
	jmp	(print).l
setlccords							;set printx/y to cords for lc box on team a2
	clr.w	d0
	cmpa.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
	bne.w	.0
	eori.w	#$16,d0
.0									;side chosen
	btst.b	#gmdir,(gmode).l		;reverse direction: flip to the other end
	beq.w	.noflip
	eori.w	#$16,d0
;CD: no cartridge twin
.noflip								;CD: placed where the disc branches to it
	jsr	(printz).l
	String	CC_Font1Pri,$16,0,0
	add.w	d0,(printy).l
	moveq	#2,d0
	bsr.w	getlchoice
	moveq	#6,d1					;3 rows
	tst.w	d0
	bpl.w	.ex
	subi.w	#1,d1					;no third choice: 2 rows
	addi.w	#1,(printy).l
.ex									;set the box size
	moveq	#9,d0
	rts
getlchoice							;d0 = 0-2 (a2 = team)
	movem.l	d1-d2,-(sp)
	move.w	tmsize+tmap(a2),d2
	cmpa.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
	beq.w	getlchoice2
	move.w	tmap-tmsize(a2),d2
getlchoice2							;add $15 to d0 for each player more or fewer than the other team has on
									;the ice
	sub.w	tmap(a2),d2
	beq.w	.0
	addi.w	#$15,d0
	tst.w	d2
	bmi.w	.0
	addi.w	#$15,d0
.0									;row offset chosen
	move.w	tmline(a2),d1
	add.w	d1,d0
	add.w	d1,d0
	add.w	d1,d0
	lea	.tab(pc),a0
	move.b	(a0,d0.w),d0
	ext.w	d0
	movem.l	(sp)+,d1-d2
	rts
.tab	dc.b	0
	dc.b	1,2,1,2,0,2,0,1,0,1,2,0,1,2,0,1
	dc.b	2,0,1,2,3,4,$FF,3,4,$FF,3,4,$FF,3,4,$FF
	dc.b	4,3,$FF,3,4,$FF,3,4,$FF,5,6,$FF,5,6,$FF,5
;CD: no cartridge twin
	dc.b	$06
	dc.w	$FF05
	dc.w	$06FF
	btst	d2,d6
	dc.w	$FF05
	dc.w	$06FF
	dc.w	$0605,$FF00
; process input for line changes
; d1 = new button presses
lineinput							;process input for line changes
									;d1 = new button presses
	btst.b	#3,(sflags5).l
	beq.w	.0
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(passmode).l
	movem.l	(sp)+,d0-d7/a0-a6
.0									;line change check
	move.w	d1,-(sp)
	movea.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
	btst.b	#pfteam,pflags(a3)
	beq.w	.2
	adda.w	#tmsize,a2
.2									;team struct chosen
	bclr.b	#tmflcc,tmflags(a2)		;Flag to start lc mode
	beq.w	.1
	bsr.w	lcfound_close			;close the old box
	bsr.w	SetLCmode2				;start lc mode
.1									;restore d1
	move.w	(sp)+,d1
	clr.w	d2
	btst	#6,d1
	bne.w	lcfound
	addi.w	#1,d2
	btst	#4,d1
	bne.w	lcfound
	addi.w	#1,d2
	btst	#5,d1
	bne.w	lcfound
	btst.b	#pfjoycon,pflags(a3)
	beq.w	.x
	btst.b	#pfalock,pflags(a3)
	bne.w	.x
	btst.b	#pf2fight,pflags2(a3)
	beq.w	doplayeracc				;skate with dpad if not fighting
.x									;exit (also the end of the code above)
	rts
; d2 = choice made 0-2
lcfound								;d2 = choice made 0-2
	move.w	d2,d0
	move.w	d2,tmlcchoice(a2)		;chosen row: the box redraw shows only that row
	bsr.w	getlchoice				;translate choice 0-2 into line number 0-6
	tst.w	d0
;CD: no cartridge twin
	bpl.w	.L30D7A
	jmp	$30AB0.l
.L30D7A
	bclr.b	#$3,$63(a3)
	bset.b	#$3,$62(a3)
	jsr	(loadTeamStruct).l
	bclr.b	#$1,$32(a2)
	move.w	d0,tmline(a2)
	jsr	(setpersonel).l
lcfound_close						;close lc box
	btst.b	#sfhor,(sflags).l
	bne.w	rtss
	bsr.w	setlccords
	cmpi.w	#$F,(printy).l
	blt.w	.nollcm
	bclr.b	#sf3llcs,(sflags3).l
.nollcm								;erase the box
	addi.w	#1,d1					;d1 = 1 and d2 = $7FF tile: erase the box area
	move.w	#$7FF,d2
	bsr.w	eraser
;CD: no cartridge twin
	jmp	(printscores1).l
; c button press check/speed
burst								;cbut press check/speed. Also entered from check4check burst costs energy
									;$CC (only when line changes are on, OptLine = 0)
	jsr	(getpde).l					;get players energy
	tst.w	(OptLine).l
	bne.w	.0
	subi.w	#$CC,d0
	jsr	(setpde).l					;decrease players energy
	btst.b	#4,(sflags7).l
	beq.w	.0
	move.w	#$1000,d0
.0									;energy drain for the line time
	lsr.w	#7,d0					;d0 will be $1000 with lines off
									;d0 / 64 will be 20 hex if max energy
	move.w	d0,d1					;energy = speed increase (check violence)
	move.w	facedir(a3),d2			;facedir
	asl.w	#2,d2
	movea.l	#dirtab,a0
	muls.w	(a0,d2.w),d0
	muls.w	$2(a0,d2.w),d1
	add.w	d0,Xvel(a3)				;add to X Vel
	add.w	d1,Yvel(a3)				;add to Y Vel
	bset.b	#pfalock,pflags(a3)		;lock in this animation
	move.w	#SPAburst,d1
	bra.w	SetSPA
; A button press hold
; CPU hold jumps in at Acheck
;
; a3 = holder
; a0 = player being held
Holdplayer							;abut press hold. a0 = the player this one is
									;assigned to, falls into Acheck
	bset.b	#pfalock,pflags(a3)		;lock animation
	move.w	#SPAhook,d1				;move anim into d1 - normal hold check
	tst.w	impact(a3)				;check if impact = 0
	beq.w	SetSPA					;set anim if 0
	movea.l	#$17480,a0				;move SortCord into a0 (CD: the cartridge has #(SortCords-M68K_RAM))
	move.w	impactp(a3),d0			;move last impact player into d0
	asl.w	#7,d0					;calc offset
	adda.w	d0,a0					;add offset to a0
Acheck								;start SPAhook, or SPAHold if a0 is ahead
	bset.b	#pfalock,pflags(a3)		;lock animation
	move.w	#SPAhook,d1				;move anim into d1 - normal hold check
	tst.w	impact(a3)				;check if impact = 0
	beq.w	.ex						;branch if 0
	move.w	Ypos(a3),d0				;move Ypos checker into d0
	sub.w	Ypos(a0),d0				;sub Ypos of player
	btst.b	#pfgoal,pflags(a3)		;check goal checker is shooting at
	beq.w	.air					;jump if bottom
	neg.w	d0						;make d0 negative
.air								;in the air?
	bmi.w	.ex
	move.w	#SPAHold,d1				;set anim - hold check stick in air
.ex									;either way: start the animation in d1
	bra.w	SetSPA
; initialize pass mode
setpassmode							;initialize pass mode
	move.w	facedir(a3),(passdir).l	;facedir, default pass direction
	andi.w	#7,(passdir).l			;Passes first 3 bits of passdir
	btst.b	#2,(BA_PS_flags).l
	beq.w	.0
	bclr.b	#2,(gmode2).l
	bset.b	#5,(BA_PS_flags).l
	bne.w	rtss7
	bclr.b	#5,(gmode2).l
	move.w	#$64,(passmodetimer).l
.0									;set pass dir mode
	bset.b	#sfspdir,(sflags).l		;#sfspdir - set pass dir mode
rtss								;shared rts
	rts
; start passing sequence
passmode							;dpad sets passdir until bbut changes
	btst	#4,d2					;has b button changed?
	bne.w	dopass					;yes
	btst.b	#3,(sflags5).l			;Not in NHL Hockey Source
	bne.w	dopass
	btst	#3,d0					;look for dpad
	bne.w	rtss
	andi.w	#7,d0					;pass first 3 bits of d0
	move.w	d0,(passdir).l			;new pass dir
	bset	#3,d0
dopass								;pass the puck in passdir, to the best teammate there if any
	movem.l	d0-d5/a0-a1,-(sp)
	bclr.b	#sfspdir,(sflags).l		;#sfspdir
	st.b	(puckc).l				;player is not puck handler anymore
	move.b	#$10,nopuck(a3)
	move.w	SCnum(a3),(lastplayer).l
	bclr.b	#3,(sflags5).l			;Not in NHL Hockey Source
	beq.w	.noot
	jsr	(OneTimerTarget).l
	move.w	#$12,(onetimerheight).l
	btst.b	#2,(sflags6).l
	beq.w	.1
	move.w	#$3A,(onetimerheight).l
.1									;pass to the one timer
	jsr	(OneTimerPass).l
	bra.w	.exit
.noot								;3 was clear
	moveq	#8,d0					;moves 8 into d0
	tst.w	position(a3)			;checks if goalie
	beq.w	.calc					;jump if goalie
.LoadPassAttribForPassStart			;skater: pass speed from passacc
	move.b	passacc(a3),d0			;Passacc
.calc								;d0 = passacc (8 for a goalie)
	asl.w	#2,d0					;d0 = passacc for player, 8 for goalie
	asr.w	#1,d0					;change from NHL Hockey Source,
									;because max passacc can be 30
									;(15 in 92)
	addi.w	#$A0,d0
	move.w	d0,(passspeed).l		;Passspeed = PassAcc (0 to 30 decimal) * 2 + A0 (160 decimal)
	btst.b	#0,passacc(a3)			;Checks to see if bit 0 in Passacc is 0
	beq.w	.findplayer				;Jumps if 0 (even number)
	asr.w	#4,d0					;divide d0 by 16
	add.w	d0,(passspeed).l		;add d0 to passspeed
.findplayer							;odd passacc: speed + 1/16
	moveq	#-1,d4					;look for closest and best player to pass to
	moveq	#5,d3					;Set total number of players (6 total, set to 5)
	movea.l	#$17480,a1				;start of the home players' sort objects (CD: the cartridge has
									;#(SortCords-M68K_RAM))
	cmpi.w	#6,SCnum(a3)			;compares 6 to SCnum(a3) (current player with puck) to check if
									;player is away team or home team
	blt.w	.0						;Jump if player is Home, continue if Away
	adda.w	#6*SCstruct,a1			;Switch to Away Team Players
	btst.b	#2,(BA_PS_flags).l
	bne.w	.nopp
.0									;a1 = the passer's team (away +6 objects)
	cmpa.l	a1,a3					;Check to see if passing to self
	beq.w	.next					;skip if this is passing player
	tst.w	position(a1)			;position(a1)
	beq.w	.next					;skip if goalie
	btst.b	#pf2unav,pflags2(a1)	;check if player is unavailable
	bne.w	.next					;player unavailable
	move.w	0(a1),d0				;X Position of receiving player
	sub.w	(puckx).l,d0			;sub puckx from d0
	move.w	Ypos(a1),d1				;Y position of receiving player
	sub.w	(pucky).l,d1			;sub pucky from d1
	movem.w	d0-d1,-(sp)				;push to stack
	bsr.w	vtoa					;get direction of pass in d0
	movem.w	(sp)+,d1-d2				;pop from stack d1 is dX, d2 is dY
	sub.w	(passdir).l,d0			;sub passdir from d0
	andi.w	#7,d0					;pass only lower 3 bits in d0
	asl.b	#5,d0					;Multiply d0 by 32 (224 decimal is max)
	ext.w	d0						;sign extend d0 byte to d0 word
	asl.w	#3,d0					;mult d0 by 8 (700 decimal max)
	muls.w	d0,d0					;square d0 = max is 490000 decimal
	cmpi.l	#$10000,d0				;compare to 65536 decimal (#256^2: power, SNASM ^ is xor)
	bhi.w	.next					;if higher branch to next
	muls.w	d1,d1					;square d1 (dX)
	muls.w	d2,d2					;square d2 (dY)
	add.l	d1,d2					;add together
	add.l	d0,d2					;add modified passdir to d2
	cmp.l	d4,d2					;compare d4 to d2
	bhi.w	.next					;branch if higher (player is farther away than the closest player)
	move.l	d2,d4					;move d2 into d4
	movea.l	a1,a0					;move a1 address into a0 (receiving player)
.next								;next teammate
	adda.w	#SCstruct,a1			;Skip to next player (80 hex is length of player struct)
	dbf	d3,.0
	tst.l	d4						;check if there's a player to pass to
	bmi.w	.nopp					;skip if no player to pass to
	bsr.w	passto
	bra.w	.exit
.nopp								;bit 2 of BA_PS_flags set or d4 negative
	move.w	(passdir).l,d0			;just hit puck in pass dir not to any player
	asl.w	#2,d0
	movea.l	#dirtab,a0
	move.w	$2(a0,d0.w),d1			;y inc
	muls.w	(passspeed).l,d1
	move.l	#$A,d2
	asl.l	d2,d1
	divs.w	#runspeed*15,d1
	add.w	Yvel(a3),d1				;Yvel
	move.w	d1,(puckvy).l
	move.w	(a0,d0.w),d1			;X inc
	muls.w	(passspeed).l,d1
	asl.l	d2,d1
	divs.w	#runspeed*15,d1
	add.w	Xvel(a3),d1				;Xvel
	move.w	d1,(puckvx).l
	move.w	#$1000,d0
	bsr.w	randomd0
	move.w	d0,(puckvz).l
.exit								;goalie passes: point the puck up ice
	tst.w	position(a3)			;$34 = position
	bne.w	.notgoalie
	tst.w	(puckvy).l
	btst.b	#pfgoal,pflags(a3)		;$62 = pflags Checks for what goal team is shooting at (0=bottom, 1=top)
	beq.w	.g0
	bmi.w	.nvy
	bra.w	.notgoalie
.g0									;pfgoal clear
	bmi.w	.notgoalie
.nvy								;goalie shooting at the top net with the puck moving down (or the bottom
									;and up): flip it
	neg.w	(puckvy).l				;negative velocity on puck
.notgoalie							;d0/d1 = puck velocity for the pass animation direction
	move.w	(puckvx).l,d0			;d0/d1 = puck velocity -> direction for the animation (goalie swing,
									;forehand or backhand pass)
	move.w	(puckvy).l,d1
	bsr.w	vtoa
	move.w	#SPAgswing,d1			;SPA = Sprite Animation
	tst.w	position(a3)			;$34 = position
	beq.w	.e1						;goalie anim.
	move.w	#SPApassf,d1
	bsr.w	Findhittype
	beq.w	.e1
	move.w	#SPApassb,d1
.e1									;goalie: swing animation
	bsr.w	SetSPA					;start the pass animation d1
	bset.b	#pfalock,pflags(a3)		;#pfalock, $62 = pflags
	moveq	#$C,d0					;Rest to rts, not in NHL Hockey Source
									;Used to make puck sound
	sub.b	(puckvz).l,d0
	lsr.w	#2,d0
	andi.w	#3,d0
;CD: no cartridge twin
	move.w	#$10,d0
	move.w	d0,-(sp)				;#SFXpass
	bsr.w	sfx
	movem.l	(sp)+,d0-d5/a0-a1
	rts
; pass puck to player a0
; a3 = passer
passto								;pass the puck to player a0: a3 = passer
	btst.b	#pfjoycon,pflags(a3)
	beq.w	passtoa0
	tst.w	position(a3)
	bne.w	passtoa0
	movem.l	d0-d1,-(sp)
	btst.b	#3,pflags(a0)
	bne.w	.stack
	bset.b	#6,pflags3(a0)			;pflags3 bit 6
	move.w	(cont1team).l,d1
	cmp.w	(cont2team).l,d1		;checks to see if 2 player co-op (on same team)
	bne.w	.h2hor1p
	move.w	SCnum(a0),d0			;SCnum of receiver into d0
	move.w	SCnum(a3),d1			;SCnum of passer into d1
	cmp.w	(c1playernum).l,d1		;checks if cont 1 controlling passer
	bne.w	.p2passing
	jsr	(setc1player).l
	bra.w	.stack
.p2passing							;d1 <> c1playernum
	jsr	(setc2player).l
	bra.w	.stack
.h2hor1p							;d1 <> cont2team
	move.w	#1,d1
	btst.b	#pfteam,pflags(a3)		;check if home or away team
	beq.w	.0						;branch if home
	move.w	#2,d1					;away team
.0									;receiver's team pad
	move.w	SCnum(a0),d0			;move SCnum of receiver into d0
	cmp.w	(cont1team).l,d1		;compare cont1 team with d1 (1=home, 2=away)
	bne.w	.diffteam
	jsr	(setc1player).l
	bra.w	.stack
.diffteam							;d1 <> cont1team
	jsr	(setc2player).l
.stack								;pop the d0-d1 saved above
	movem.l	(sp)+,d0-d1
;CD: no cartridge twin
passtoa0							;CD: placed where the disc branches to it
	jsr	(loadTeamStruct).l
	addi.w	#1,tmpasses(a2)			;add 1 to total pass attempts
	move.w	SCnum(a0),(passReceiverPlayerNum).l	;Moves index number for a0 player
	move.w	(passspeed).l,d5		;passspeed = pix/sec
	asr.w	#2,d5					;divides pass speed by 4
	exg	a0,a3						;tell pass recipient to get puck - swaps a3 and a0 for assinsert
	moveq	#$13,d0					;#apassrec - assignment for receiving pass
	bsr.w	assinsert
	exg	a0,a3
	move.l	a0,-(sp)				;This routine uses passspeed and player's a0 x/y speed to determine the
									;x/y velocity of the puck so it will meet player a0
	bsr.w	GetHot					;and player's a0 x/y speed to determine
	add.w	0(a0),d0				;Xpos
	sub.w	(puckx).l,d0			;meet player a0
	add.w	Ypos(a0),d1				;Ypos
	sub.w	(pucky).l,d1
	movem.w	d0-d1,-(sp)
	movem.w	(sp),d2-d3				;pop d0-d1 off into d2-d3
	asr.w	#2,d2					;d2 divide by 4
	asr.w	#2,d3					;d3 divide by 4
	move.w	Xvel(a0),d0				;Xvel
	muls.w	#$F0,d0					;#(16 * 60)/4 = $F0 xpix / (1/4) sec
	swap	d0						;swap upper and lower bytes
	move.w	Yvel(a0),d1				;Yvel
	muls.w	#$F0,d1
	swap	d1						;swap upper and lower bytes
	movem.w	d0-d1,-(sp)				;push on stack
	muls.w	d2,d0					;d0 = (d2 = Xpos puck / 4) * d0 (x pix per 1/4 sec)
	muls.w	d3,d1					;d1 = (d3 = Ypos puck /4) * d1 (y pix per 1/4 sec)
	add.w	d1,d0					;add d1 to d0
	asl.w	#1,d0					;d0 mult by 2
	move.w	d0,d4					;j = move d0 into d4
	movem.w	(sp),d0-d1				;pop d0 and d1 off stack
	muls.w	d0,d0					;(x pix per 1/4 sec)^2
	muls.w	d1,d1					;(y pix per 1/4 sec)^2
	muls.w	d5,d5					;passspeed^2
	neg.l	d5						;negative d5
	add.l	d0,d5					;add d0 to d5
	add.l	d1,d5					;k = add d1 to d5
	muls.w	d2,d2
	muls.w	d3,d3
	add.l	d2,d3					;a^2 = add d2 to d3
	muls.w	d5,d3					;multiply k * a^2
	asl.l	#2,d3					;divide by 4
	move.w	d4,d0					;d0 = j
	muls.w	d0,d0					;j^2
	sub.l	d3,d0					;j^2 - ((k*a^2)/4)
	bsr.w	Sroot					;square root of d0
	moveq	#1,d3					;limit infinite loop
	asr.w	#2,d5					;k divide by 4
	bne.w	.0
	moveq	#1,d5					;no div by zero
.0									;k at least 1
	move.w	d0,d2					;d2 = (sqrt(disc) - j) / k = intercept time; dbpl retries with the other
									;root (d0 negated)
	neg.w	d0
	sub.w	d4,d2
	ext.l	d2
	divs.w	d5,d2
	dbpl	d3,.0
	bne.w	.1
	addi.w	#1,d2					;can't be zero
.1									;time to the target, at least 1
	cmpi.w	#$18,d2					;limit to 3 sec.
	bls.w	.2
	moveq	#$18,d2					;d2 = time in 1/8 sec to intersection
.2									;time clamped
	move.b	d2,(puckvz).l
	cmpi.w	#$C,d2
	blt.w	.3
	move.b	#$C,(puckvz).l
.3									;puckvz clamped
	move.w	d2,d0					;d2 = time (1/8 s): receiver temp1(a0) = d2*8-10
									;(temp1), puck lockout = that - 6
	asl.w	#3,d0
	subi.w	#$A,d0					;only subtract #6 in NHL Hockey
	move.b	d0,temp1(a0)			;$40 = temp1
	subi.w	#6,d0					;sub. #10 in NHL Hockey
	move.b	d0,(puckx_nopuck).l
	movem.w	(sp)+,d0-d1
	muls.w	d2,d0
	asr.l	#1,d0
	add.w	(sp)+,d0				;x distance
	move.w	(puckx).l,temp3(a0)		;receiver target x/y
	add.w	d0,temp3(a0)			;$44 = temp3
	muls.w	d2,d1
	asr.l	#1,d1
	add.w	(sp)+,d1				;y distance
	move.w	(pucky).l,temp4(a0)
	add.w	d1,temp4(a0)			;$46 = temp4
	mulu.w	#$78,d2					;$78 = 60*2
	swap	d0
	divs.w	d2,d0
	move.w	d0,(puckvx).l
	swap	d1
	divs.w	d2,d1
	move.w	d1,(puckvy).l
	rts
; Attributes: thunk
changeplayer						;switch controller d4 (0/2) to the teammate nearest the puck, or sweep
									;check if that is the current player
	jmp	(chgplayer).l
Sweepcheck							;start sweep check on player a3
	bset.b	#pfalock,pflags(a3)
	move.w	#SPAsweepchk,d1
	bra.w	SetSPA
; restore old player and switch to new d0 player on cont. 1
setc1player							;restore old player and switch to new d0 player on cont. 1
	cmp.w	(c1playernum).l,d0
	beq.w	.ex
	movem.l	d1/a0-a1,-(sp)
	move.w	(c1playernum).l,d1
	bsr.w	restorepl
	move.w	d0,(c1playernum).l
	movem.l	(sp)+,d1/a0-a1
.ex									;exit (also the end of the code above)
	rts
; restore old player and switch to new d0 player on cont. 2
setc2player							;restore old player and switch to new d0 player on cont. 2
	cmp.w	(c2playernum).l,d0
	beq.w	.ex
	movem.l	d1/a0-a1,-(sp)
	move.w	(c2playernum).l,d1
	bsr.w	restorepl
	move.w	d0,(c2playernum).l
	movem.l	(sp)+,d1/a0-a1
.ex									;exit (also the end of the code above)
	rts
; d1 = old player
restorepl							;restore old joy controlled player d1, give d0 the joystick; a d1 in line
									;change mode keeps control
	movea.l	#$17480,a0				;CD: the cartridge has #(SortCords-M68K_RAM)
	tst.w	d1
	blt.w	.spd
	cmpi.w	#$B,d1
	bgt.w	.spd
	asl.w	#scsize,d1				;multiply d0 by 80 hex (SCsize)
	btst.b	#pf2lcm,pflags2(a0,d1.w)	;#pfnp - no joystick pad
	beq.w	.cont
	lsr.w	#7,d1					;divide by 80 hex
	move.w	d1,d0
	rts
.cont								;pf2lcm clear
	bclr.b	#pfjoycon,pflags(a0,d1.w)	;#pfjoycon
	btst.b	#3,pflags3(a0,d1.w)		;bit 3, pflags3
	bne.w	.spd
	bset.b	#pfna,pflags(a0,d1.w)	;#pfna - new assignment
.spd								;d0 = the new player: take the joystick if it is in range
	tst.w	d0						;checks if d0 0 or higher
	blt.w	.ex
	cmpi.w	#$B,d0					;checks if d0 11 or less
	bgt.w	.ex
	move.w	d0,d1					;copies d0 into d1
	asl.w	#7,d1
	btst.b	#2,(BA_PS_flags).l
	bne.w	.chkgoalie
	btst.b	#0,(gmode2).l
	beq.w	.3
.chkgoalie							;Local: only restorepl uses it, and a global here would split restorepl
	tst.w	position(a0,d1.w)
	bne.w	.3
	btst.b	#6,pflags(a0,d1.w)		;check if home or away
	beq.w	.0
	tst.w	(goaliemode2).l
	bra.w	.1
.0									;pad 1: goaliemode1 sets the flags
	tst.w	(goaliemode1).l
.1									;no goalie mode: the goalie keeps no joystick
	beq.w	.3
	move.w	#0,d0					;first position of home SCNum
	btst.b	#6,pflags(a0,d1.w)		;check if home or away
	beq.w	.2
	move.w	#6,d0					;first position of away SCNum
.2									;d0 = first SCnum of the team
	bra.w	.ex
.3									;goalie mode (or a skater): this player gets the joystick
	bset.b	#pfjoycon,pflags(a0,d1.w)	;set pfjoycon for SCNum
.ex									;exit (also the end of the code above)
	rts
; look for type of swing (forehand or backhand)
; input d0 = launch dir
Findhittype							;look for type of swing (forhand or backhand)
									;input d0 = launch dir
									;ouput beq forhand
	neg.w	d0
	add.w	facedir(a3),d0			;facedir
	andi.w	#7,d0
	btst.b	#3,attribute(a3)		;attribute bit 3
	beq.w	.1
	btst	d0,#$F0					;%11110000: beq forehand, bne backhand. show btst Dn,#imm
	rts
.1	btst	d0,#$1E					;%00011110
	rts
; initiate shot by player a3
SetShotMode							;initiate shot by player a3
	btst.b	#2,(BA_PS_flags).l		;check for PS or SO
	beq.w	.start					;branch if not
	bclr.b	#2,(gmode2).l
	bset.b	#5,(BA_PS_flags).l
	bne.w	rtss7
	bclr.b	#5,(gmode2).l
	move.w	#$64,(passmodetimer).l
.start								;start the shot
	move.w	#8,(passdir).l			;default shot direction
	bset.b	#sfssdir,(sflags).l		;#sfssdir
	clr.w	d0						;find dx/dy for shot
	move.w	#$128,d1				;#296 = top Y boards
	btst.b	#pfgoal,pflags(a3)		;#pfgoal - which goal to shoot on
	bne.w	.ck0					;branch if top goal
	neg.w	d1						;flip if bottom goal
.ck0								;dx / dy to the goal
	sub.w	0(a3),d0				;Sub Xpos of player from d0. d0 starts as 0 (middle of rink in X)
	sub.w	Ypos(a3),d1				;Sub Ypos of player from Y boards
	bsr.w	vtoa
	move.w	#$F,(passspeed).l
	move.w	#SPAshotf,d1
	bsr.w	Findhittype
	beq.w	.ck1
	move.w	#SPAshotb,d1
	move.w	#$F,(passspeed).l		;minimum shot speed
.ck1								;forehand or backhand chosen: start the shot animation
	bra.w	SetSPA
; shot input
ShotMode							;shot input
									;swing frame reached (anim frame 7*4): shoot, else dpad sets shot
									;direction
	cmpi.w	#$1C,SPAnum(a3)
	bge.w	prepshot				;end of animation so shoot
	btst	#3,d0					;checks dpad for direction
	bne.w	.ss0
	andi.w	#7,d0					;pass the first 3 bits of d0
	move.w	d0,(passdir).l			;set shot direction
.ss0								;shot animation check
	cmpi.w	#$10,SPAnum(a3)
	bge.w	X_317B6					;past full windup so no more passspeed (CD: the cartridge has .end)
	add.w	d7,(passspeed).l
	cmpi.b	#$14,shotspd(a3)		;6C = shot speed
	bge.w	.checkcbut
	cmpi.w	#8,SPAnum(a3)			;SPANum
	bgt.w	.chganim
.checkcbut							;under full shot speed: check for the C release
	btst	#cbut,d2				;5 = #cbut
	beq.w	X_317B6					;button hasnt changed so continue windup (CD: the cartridge has .end)
.chganim							;C released or past the windup: swing through
	neg.w	SPAnum(a3)				;end windup and swing through
	addi.w	#$1C,SPAnum(a3)			;Add to SPANum
.end								;exit (also the end of the code above)
	rts
; Check certain conditions before shooting
prepshot							;check the conditions before a shot: d0 = SCnum of the opposing goalie
									;(getGoalieSCnum)
	bclr.b	#4,(sflags5).l
	move.w	#$B,d0
	btst.b	#pfteam,pflags(a3)		;check if home or away
	beq.w	.getGoalie				;gets opponents Goalie SCnum
	move.w	#5,d0					;opponent is home
.getGoalie							;opponent goalie
	jsr	(getGoalieSCnum).l
	tst.w	d0
	bmi.w	.nogoalie
	movem.l	a0,-(sp)
	asl.w	#7,d0
	movea.l	#SortCords,a0
	cmpi.w	#SPAgstackr,SPA(a0,d0.w)	;Checking goalie animations - pad stack right
	beq.w	.svgoalie
	cmpi.w	#SPAgstackl,SPA(a0,d0.w)	;Checking another goalie animation - pad stack left
.svgoalie							;pop the a0 saved above
	movem.l	(sp)+,a0				;pop stack value into a0
	bne.w	.cont
.nogoalie							;no goalie in a save
	cmpi.w	#1,(passdir).l
	ble.w	.dir017					;branch if passdir is 0 or 1
	cmpi.w	#7,(passdir).l
	bne.w	.cont					;branch if passdir is not 7
.dir017								;shooting straight: check the puck Y
	move.w	(pucky).l,d0
	btst.b	#pfgoal,pflags(a3)		;#pfgoal - goal to shoot at (0=bottom, 1=top)
	bne.w	.cmppuck				;branch if top
	neg.w	d0						;flips d0 for compare calc
.cmppuck							;puck Y for his end
	cmpi.w	#$D8,d0					;compares location of puck
	blt.w	.cont
	bset.b	#4,(sflags5).l			;set flag for in-close top shelf shooting
.cont								;no in-close top shelf flag
	bra.w	doshot
; stick is at puck so launch puck toward goal
; a3 = shooter
doshot								;stick is at puck so launch puck toward goal
	movem.l	d0-d7/a0-a3,-(sp)
	bclr.b	#4,(gmode2).l
	btst.b	#pf3break,pflags3(a3)	;check if player on breakaway
	beq.w	.cont
	bset.b	#4,(gmode2).l			;set if breakaway
.cont								;shot direction adjust
	bsr.w	shotdiradj
	move.w	#SFXshotwiff,-(sp)		;#SFXshotwiff - sound effect
	move.w	SCnum(a3),(shotplayer).l
	bclr.b	#sfssdir,(sflags).l		;#sfssdir - shot direction mode
	bset.b	#pfalock,pflags(a3)		;#pfalock
	btst.b	#pf3onetimer,pflags3(a3)	;check if shooting one timer
	bne.w	.shottype				;jump if yes
	move.w	(puckc).l,d0			;puck carrier SCnum into d0
	cmp.w	SCnum(a3),d0			;is player puck carrier?
	bne.w	.ex						;wiffed shot
.shottype							;shot sound
	move.w	#SFXshotfh,(sp)			;#SFXshotfh
	bset.b	#sf2shot,(sflags2).l	;#sf2shot - shot was taken
	cmpi.w	#SPAshotb,SPA(a3)
	bne.w	.nbh					;no backhand
	move.w	#SFXshotbh,(sp)			;#SFXshotbh
	move.w	(passspeed).l,d0
	lsr.w	#2,d0					;sub 25% for backhand shots
	sub.w	d0,(passspeed).l
.nbh								;forehand shot or backhand already reduced
	btst.b	#pf3onetimer,pflags3(a3)	;check if shooting one timer
	beq.w	.cont2					;jump if not
	movem.l	d0-d1,-(sp)				;push d0-d1 on stack
	move.w	#$1F,d0					;1F into d0 - one timer min speed
	move.w	d0,(passspeed).l		;make passspeed start with a higher value
	movem.l	(sp)+,d0-d1				;Pop off stack d0-d1
.cont2								;shot speed
	clr.w	d0
	move.b	shotspd(a3),d0			;6C = shotspd (ShP)
	lsr.b	#1,d0					;divide by 2
	movea.l	a3,a0					;move a3 address into a0
	jsr	(makepde).l					;scale d0 based on energy level
	addi.w	#$14,d0					;add 14 to d0
	mulu.w	(passspeed).l,d0		;shot speed ranged by energy level
	mulu.w	#$5249,d0				;($4000*45)/35
	swap	d0						;swaps the upper and lower words of d0
	move.w	d0,(passspeed).l		;move d0 into passspeed
	btst.b	#0,shotspd(a3)			;checks if ShP value is even or odd
	beq.w	.even
	asr.w	#4,d0					;divide by 16
	add.w	(passspeed).l,d0		;add passspeed to d0
.even								;odd shotspd: speed + 1/16
	lsr.w	#4,d0					;divide by 16 (d0 is passspeed)
	neg.w	d0						;negative
	addi.w	#3,d0					;add 3 to d0
	bpl.w	.nbh2
	clr.w	d0						;clear if negative
.nbh2								;speed bonus for the sound
	add.w	d0,(sp)					;add to stack current value (Shot SFX)
	st.b	(puckc).l				;clear puck carrier
	move.b	#$10,nopuck(a3)			;5E = nopuck - no puck collision till 0
	move.w	SCnum(a3),(lastplayer).l	;SCNum
	move.w	#$108,d1				;$108 = top goal line Y position
	btst.b	#pfgoal,pflags(a3)		;pfgoal, pflags
	bne.w	.0						;branch if shooting up
	neg.w	d1						;flip d1 if shooting down
.0									;aim for the goal line
	move.w	(passdir).l,d2			;passdir into d2
	asl.w	#2,d2					;mult by 4
	lea	shotsets(pc),a0				;table of shot directions
	move.w	(a0,d2.w),d0			;xoffset
	move.w	$2(a0,d2.w),d2			;z offset
	sub.w	(puckx).l,d0
	sub.w	(pucky).l,d1
	movem.w	d0-d2,-(sp)				;push d0-d2(dx,dy,z offset) on stack
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	bsr.w	Sroot
	tst.w	d0						;distance in pix to goal
	bne.w	.1
	addi.w	#1,d0
.1									;distance at least 1
	move.w	d0,d3					;straight line distance from puck to spot aiming for with passdir
	btst.b	#gmhl,(gmode).l			;check if highlight (always perfect)
	bne.w	.perf
	cmpi.w	#$C8,d3					;C8 = 200 decimal
	bhi.w	.notperf				;too far away from perfect shot
	jsr	(ReadGoaliePulled).l		;checks if shooting team's G pulled
	bmi.w	.perf					;perfect shot with pulled goalie
	btst.b	#0,(gmode2).l			;check if shootout
	bne.w	.perf					;perfect shot in shootout
	moveq	#$10,d0					;start value for ShA calc
	add.b	shotacc(a3),d0			;shotacc(a3)
	bsr.w	randomd0
	cmpi.w	#$E,d0					;chance of perfect shot
	bgt.w	.perf					;branch if higher - perfect shot
.notperf							;random miss
	clr.w	d0
	move.b	shotacc(a3),d0			;shotacc(a3)
	lsr.w	#1,d0					;divide by 2
	move.b	d0,-(sp)				;push on stack
	move.w	(passspeed).l,d0		;move passspeed into d0
	lsr.w	#4,d0					;divide by 16
	sub.b	(sp)+,d0				;shotacc(a3) / 2
	addi.b	#$10,d0					;add $10 to d0
	mulu.w	d3,d0					;mult straight line distance with d0
	lsr.w	#6,d0					;shot accuracy adjust - divide by 64
	cmpi.w	#$FA,d3					;250 pixels straight line distance
	bhi.w	.chkvalue				;branch if higher
	lsr.w	#1,d0					;extra shot accuracy adjust
.chkvalue							;adjust clamped
	cmpi.w	#$88,d0					;compare to $88 (max adj value in X)
	blt.w	.cont3
	move.w	#$88,d0
.cont3								;push the adjust
	move.w	d0,-(sp)				;push adjusting value: 2(sp) / 4(sp) = x / y diff pushed before
	bsr.w	randomd0s				;RNG adj value
	add.w	d0,2(sp)				;add result to x diff
	move.w	(sp),d0					;move adjusting value into d0
	cmpi.w	#$3C,d0					;compare to $3C (max adjustment in Y)
	bls.w	.lessx					;branch if less
	moveq	#$3C,d0
	move.w	d0,(sp)
.lessx								;Y adjust clamped
	tst.w	4(sp)
	bpl.w	.ycalc
	lsr.w	#1,d0
.ycalc								;d0 = random adjustment of the y aim
	bsr.w	randomd0s				;RNG adjustment
	add.w	d0,4(sp)				;add to y diff
	move.w	(sp)+,d0				;pop adj value
	lsr.w	#1,d0					;divide by 2
	bsr.w	randomd0				;RNG result
	add.w	d0,4(sp)				;add to Z diff
.perf								;aim set: puck velocity from shot speed and distance
	move.w	(passspeed).l,d2		;shot speed
	muls.w	#$44,d2					;1024/15
	muls.w	(sp)+,d2				;mult by x dist
	divs.w	d3,d2					;divide d2 by straight line distance
	move.w	d2,(puckvx).l			;move into puckvx
	move.w	(passspeed).l,d2
	muls.w	#$44,d2					;1024/15
	muls.w	(sp)+,d2				;mult by y dist
	divs.w	d3,d2					;divide d2 by straight line distance
	move.w	d2,(puckvy).l			;move into puckvy
	move.w	#$8000,d1				;this is the highest negative puckvy possible
	btst.b	#pfgoal,pflags(a3)		;check direction of shooting net
	beq.w	.2						;branch if bottom goal
	clr.w	d1
.2									;limit puckvy
	eor.w	d2,d1					;EOR - checking to see if exceeding maximum puckvy
	bpl.w	.3						;branch if positive
	move.w	#$3810,(puckvy).l		;move into puckvy
	btst.b	#pfgoal,pflags(a3)		;check net shooting on
	bne.w	.3						;branch if top
	move.w	#$C7F0,(puckvy).l		;move into puckvy (shooting on bottom net)
.3									;puck height in the goal (pix)
	move.w	(sp)+,d1				;pix height in goal
	beq.w	.ex						;exit if zero
	mulu.w	(passspeed).l,d1
	mulu.w	#$44,d1					;1024/15
	divu.w	d3,d1					;by d3 = distance in pix to goal
	mulu.w	#$B33,d3				;(1024*42)/15
	divu.w	(passspeed).l,d3		;divide by passspeed
	add.w	d1,d3
	cmpi.w	#$1800,d3
	bls.w	.noup					;branch if less than
	move.w	#$1800,d3				;set max puckvz
.noup								;puckvz set (capped)
	move.w	d3,(puckvz).l			;move into puckvz
	bclr.b	#4,(sflags5).l			;check in-close top shelf bit
	beq.w	.ex						;if bit was cleared, exit
	btst.b	#pf3onetimer,pflags3(a3)	;check if one timer
	bne.w	.ex						;branch if so
	jsr	(puckvzadj).l				;adjust puckvz for top shelf shot
.ex									;play the shot sound and return
	bsr.w	sfx						;play the shot sound
	movem.l	(sp)+,d0-d7/a0-a3
	rts
shotsets	dc.w	0				;shot offsets for each pass direction (x,z word pairs), read by the shot
									;code
	;offsets for different directions on the shot
	;passdir 0(x,z)
	dc.w	$C
	dc.w	$10						;passdir 1
	dc.w	$C
	dc.w	$10						;passdir 2
	dc.w	6
	dc.w	$10						;passdir 3
	dc.w	0
	dc.w	0						;passdir 4
	dc.w	0
	dc.w	$FFF0					;passdir 5
	dc.w	0
	dc.w	$FFF0					;passdir 6
	dc.w	6
	dc.w	$FFF0					;passdir 7
	dc.w	$C
	dc.w	0						;passdir 8
	dc.w	6
; a3 = shooter
; Determines where to shoot for CPU player or on a one timer
shotdiradj							;If the opposing goalie
									;covers the middle of the net, set passdir 2 or 6 to shoot at the open
									;side, else 0. Skipped for computer players (pfjoycon clear)
	btst.b	#pf3onetimer,pflags3(a3)	;check if shooting one timer
	bne.w	.0						;jump if shooting one timer
	btst.b	#pfjoycon,pflags(a3)	;pfjoycon - checks if player is joystick controlled
	bne.w	.ex						;exit if joystick
.0									;aim adjust
	moveq	#8,d0
	moveq	#5,d1
	movea.l	#(GoalieStruct-M68K_RAM),a0	;SC Struct start - 80
	btst.b	#pfteam,pflags(a3)		;pfteam - check if home or away
	bne.w	.loop					;jump if away
	adda.w	#$300,a0				;add 300 to a0 (start on away team)
.loop								;each player of the other team
	adda.w	#$80,a0					;move to next player struct
	tst.w	position(a0)			;check if goalie. Find opponents goalie
	dbeq	d1,.loop
	bne.w	.setpassdir				;branches if no goalie
	move.b	Xvel(a0),d0				;Opponent's G is A0. Move Xvel into d0
	ext.w	d0						;sign extend d0
	asr.w	#1,d0					;divide by 2
	add.w	0(a0),d0				;Xpos
	sub.w	(puckx).l,d0			;sub puckx from d0
	move.b	Yvel(a0),d1				;Yvel
	ext.w	d1						;sign extend d1
	asr.w	#1,d1					;divide by 2
	add.w	Ypos(a0),d1				;Ypos
	sub.w	(pucky).l,d1			;sub pucky from d1
	movem.w	d0-d1,-(sp)				;push to stack
	muls.w	d0,d0					;square d0
	muls.w	d1,d1					;square d1
	add.l	d1,d0					;add d1 to d0
	addq.l	#1,d0					;add 1 to d0
	bsr.w	Sroot					;get square root
	move.w	d0,d2					;move result into d2
	movem.w	(sp)+,d0-d1				;pop from stack (distance x and y from G to puck)
	moveq	#$12,d3					;post?
	move.w	#$108,d4				;Goal line
	btst.b	#pfgoal,pflags(a3)		;check which goal shooting at
	bne.w	.chkposts				;jump if top goal
	neg.w	d4						;negate if bottom goal
.chkposts							;check the posts
	movem.w	d3-d4,-(sp)				;push to stack
	bsr.w	CalcAngleOffset
	move.w	d4,d5
	movem.w	(sp)+,d3-d4				;pop from stack
	neg.w	d3						;negate d3 (other post)
	bsr.w	CalcAngleOffset
	add.w	d5,d4					;add results to d4
	clr.w	d0						;clear d0
	cmpi.w	#$2C,d4					;2C - right X edge of crease
	bgt.w	.setpassdir
	cmpi.w	#$FFD4,d4				;FFD4 - left X edge of crease
	blt.w	.setpassdir
	btst.b	#pfgoal,pflags(a3)		;check what net shooting on
	beq.w	.passdir				;branch if bottom
	neg.w	d4						;negate d4
.passdir							;direction from the crease side
	moveq	#2,d0					;move 2 into d0
	tst.w	d4						;check if d4 is 0
	bpl.w	.setpassdir				;branch if positive
	moveq	#6,d0					;move 6 into d0
.setpassdir							;passdir 2 or 6 toward the goalie side, then shootout / penalty shot
									;handling
	move.w	d0,(passdir).l			;will be 0,2,6, or 8 (no goalie)
	btst.b	#2,(BA_PS_flags).l
	bne.w	.PSorSO					;branch if bit 2 is set
	btst.b	#0,(gmode2).l			;check if shootout
	beq.w	.ex						;branch if not set
.PSorSO								;penalty shot or shootout: aim direction
	jsr	(PSandSOpassdir).l
.ex									;exit (also the end of the code above)
	rts
; Gets the area with respect to puck location, goalie location, and the post and divides it by the straight
; distance from goalie to puck
;
; d0 = difference in X from G to puck
; d1 = difference in Y from G to puck
; d2 = distance from G to puck (straight line)
; d3 = post X position
; d4 = goalline
;
CalcAngleOffset						;d4 = cross product of goalie vector d0/d1 and post vector d3/d4 (relative
									;to the puck), divided by d2
	sub.w	(puckx).l,d3			;sub puckx from post X
	sub.w	(pucky).l,d4			;sub pucky from goalline
	muls.w	d0,d4					;mult d0 with d4
	muls.w	d1,d3					;mult d1 with d3
	sub.l	d3,d4					;sub d3 from d4
	divs.w	d2,d4					;divide d2 into d4
	rts
; copy info into pad cont so graphics know which player/number
setpads								;Put SCnum of a3 in the d4 nibble of PadControlBits ; d4 = -2 puck
									;carrier, 0 / 2 pads, 4 replay target. Falls into rtss3
	movem.l	d0-d1,-(sp)
	moveq	#2,d0
	add.w	d4,d0
	add.w	d0,d0
	move.w	#$FFF0,d1
	rol.w	d0,d1
	and.w	d1,(PadControlBits).l
	move.w	SCnum(a3),d1
	asl.w	d0,d1
	or.w	d1,(PadControlBits).l
	movem.l	(sp)+,d0-d1
rtss3								;shared rts for the early exits nearby
	rts

check4bench							;check if player a3 should go to bench
	btst.b	#2,(BA_PS_flags).l
	bne.w	rtss3
	btst.b	#pfjoycon,pflags(a3)
	bne.w	rtss3
	btst.b	#pf2pen,pflags2(a3)
	bne.w	rtss3
	tst.b	newpos(a3)
	bpl.w	.0
	tst.b	newpnum(a3)
	bmi.w	rtss3
.0									;a line change is pending (new position, or a new player number)
	move.b	newpnum(a3),d0			;new player number differs from current -> go to the bench; else only
									;change position
	cmp.b	pnum(a3),d0
	beq.w	.samepl					;player should just change positions
	move.w	assnum(a3),d0
	cmpi.b	#$B,asslist(a3,d0.w)	;already going to bench
	beq.w	rtss3
	move.w	SCnum(a3),d0
	cmp.w	(puckc).l,d0
	beq.w	rtss3
;CD: no cartridge twin
	adda.w	#$4,sp
	bset.b	#pf2unav,pflags2(a3)	;set player unavailable (pf2unav)
	clr.w	temp1(a3)
	moveq	#$B,d0					;assbench
	bra.w	assreplace
;CD: no cartridge twin
.samepl								;CD: placed where the disc branches to it
	adda.w	#$4,sp
	bclr.b	#pf2unav,pflags2(a3)
	bclr.b	#pfnc,pflags(a3)
	st.b	newpnum(a3)
	st.b	newpos(a3)
	move.w	position(a3),d0
	tst.b	newpos(a3)
	bpl.w	.1
	jmp	(Setplass).l
.1									;newpos set: use it as the position
	move.b	newpos(a3),d0
	ext.w	d0
	move.w	d0,position(a3)
	jmp	(Setplass).l
; player a3 should go to bench

assbench							;player a3 should goto bench
	btst.b	#pfalock,pflags(a3)
	bne.w	rtss3
	cmpi.w	#$64,temp1(a3)			;temp1 = 100 flag: at the bench door
	beq.w	.done
	bsr.w	check4bench
	btst.b	#pf2pen,pflags2(a3)		;pf2pen
	bne.w	assexit
	bclr.b	#pfna,pflags(a3)
	beq.w	.nna
	move.w	#8,temp2(a3)
	moveq	#$50,d0					;80
	btst.b	#pfteam,pflags(a3)
	bne.w	.0
	neg.w	d0
.0									;d0 = bench y: +80 away, -80 home
	move.w	d0,temp4(a3)
	move.w	#$88,temp3(a3)
	neg.w	temp3(a3)
	subi.w	#8,temp3(a3)			;temp3 = bench x
	clr.w	temp1(a3)
.nna								;every call: same player only changes position; otherwise skate to the
									;bench door
	move.b	newpnum(a3),d0			;same player? just change position
	cmp.b	pnum(a3),d0
	beq.w	.nobench				;same player, just change position
	sub.w	d7,temp1(a3)
	bpl.w	.nodec
	addi.w	#8,temp1(a3)
	move.w	Ypos(a3),d0
	sub.w	temp4(a3),d0
	cmpi.w	#$28,d0
	bgt.w	.nodec
	cmpi.w	#$FFD8,d0
	blt.w	.nodec
	move.w	0(a3),d0
	sub.w	temp3(a3),d0
	cmpi.w	#$20,d0
	bgt.w	.nodec
	move.w	#SPAglide,d1
	tst.w	position(a3)
	bne.w	.gli
	move.w	#SPAgready,d1
.gli								;close to the door: glide (goalie: ready) and turn to face the bench
	bsr.w	SetSPA					;glide (goalie: ready) animation
	bset.b	#pfnc,pflags(a3)
	cmpi.w	#4,facedir(a3)
	beq.w	.ok
	addi.w	#1,facedir(a3)			;turn toward the bench
	andi.w	#7,facedir(a3)
.ok									;facing the bench: slide left, at the door hop the boards (wall animation,
									;door flag 100)
	clr.w	Yvel(a3)
	move.w	#$F800,Xvel(a3)
	cmpi.w	#$10,d0
	bgt.w	.x
	clr.w	Xvel(a3)
	cmpi.w	#4,facedir(a3)
	bne.w	.x
	move.w	#$F800,Xvel(a3)
	move.w	#2,facedir(a3)
	move.w	#SPAwallleft,d1
	bsr.w	SetSPA
	bset.b	#pfalock,pflags(a3)
	move.w	#$64,temp1(a3)			;100
.x									;return; skating continues next call
	rts
.done								;door flag 100: the wall animation is over, swap in the new player
	clr.w	frame(a3)				;at the bench door: mark this roster slot on the bench (tmpdst -2),
									;install the new player (d3)
	clr.w	d0
	move.b	pnum(a3),d0
	add.w	d0,d0
	movea.l	#tmstruct,a0
	btst.b	#pfteam,pflags(a3)
	beq.w	.t0
	adda.w	#tmsize,a0
.t0									;put him on the bench
	move.w	#$FFFE,tmpdst(a0,d0.w)	;tmpdst: put used player on bench
	move.b	newpnum(a3),d3
	bsr.w	.nobench2
	jmp	(setplayer).l
.nodec								;not at the door yet: keep skating to temp3/temp4 (unless pfnc stops the
									;skating)
	btst.b	#pfnc,pflags(a3)
	bne.w	.x
	move.w	temp3(a3),d0
	move.w	temp4(a3),d1
	movea.l	#EvadePC,a0
	bra.w	skateto
.nobench							;same player: just take the new position, no bench trip
	bclr.b	#pf2unav,pflags2(a3)
.nobench2							;local subroutine
	move.b	newpos(a3),d0			;position = newpos; clear newpos and newpnum
	ext.w	d0
	move.w	d0,position(a3)
	jsr	(Setplass).l
	st.b	newpnum(a3)
	st.b	newpos(a3)
rtss4								;shared rts for the early exits nearby
	rts
; player a3 should exit bench area
asseben								;Player a3 should exit the bench area
	btst.b	#pfalock,pflags(a3)
	bne.w	X_31AB6					;CD: the cartridge has rtss4
	bclr.b	#pfna,pflags(a3)
	beq.w	.nna
	clr.w	Xvel(a3)
	clr.w	Yvel(a3)
	move.w	SCnum(a3),d0
	subi.w	#6,d0
	bmi.w	.0
	addi.w	#1,d0
.0									;d0 = bench seat: home SCnum - 6 (negative), away SCnum - 5
	muls.w	#$E,d0
	move.w	d0,Ypos(a3)
	move.w	#$88,0(a3)
	neg.w	0(a3)
	move.w	#2,facedir(a3)
	bset.b	#pfalock,pflags(a3)
	move.w	#SPAwallright,d1
	bra.w	SetSPA
.nna								;wall animation over: face the rink and skate out
	move.w	#4,facedir(a3)			;after the wall animation
	bclr.b	#pfnc,pflags(a3)
	bclr.b	#pf2npc,pflags2(a3)		;pf2npc
	bclr.b	#pf2unav,pflags2(a3)	;pf2unav
	clr.w	SPA(a3)
	move.w	#$1000,Xvel(a3)
	bra.w	assexit
; player a3 should go to penalty box
asspenalty							;player a3 should goto penalty box
	btst.b	#pfalock,pflags(a3)
	bne.w	X_31AB6					;CD: the cartridge has rtss4
	bclr.b	#pfna,pflags(a3)
	beq.w	.nna
	bset.b	#pf2unav,pflags2(a3)	;set player unavailable (pf2unav)
	bsr.w	.clrplayer
	moveq	#-2,d4					;move -2 into d4
	bsr.w	setpads					;moves player number into a temp value so graphics know who it is
	move.w	#8,temp2(a3)			;move 8 into temp2
	moveq	#$B,d0					;move 11 dec into d0
	move.b	(PBnum).l,d1			;gets number of players in PB. 00HV (H=Home, V=Visitors)
	btst.b	#pfteam,pflags(a3)		;checks if player is home or away
	bne.w	.0						;branch if away
	lsr.w	#4,d1					;shift 4 bits to get Home players in PB
	neg.w	d0						;make d0 negative (different box)
.0									;d0 = box side (-11 home, 11 away), d1 = that team's players in the box
	andi.w	#$F,d1					;pass the first 4 bits of d1 (the team's player total in PB)
	cmpi.w	#2,d1					;compare to 2
	bls.w	.1						;branch if less than (1 player in box or less)
	moveq	#2,d1					;add 2 if more than 1 player in box
.1									;seat 3 to 5 by the number of players already in the box
	addq.w	#3,d1					;add 3 to d1
	muls.w	d0,d1					;mult d0 with d1, store result in d1
	move.w	d1,temp4(a3)			;move d1 into temp4 (skateto YPos)
	move.w	#$88,temp3(a3)			;move 136 decimal into temp3 (skateto XPos)
	clr.w	temp1(a3)				;clear temp1
	bset.b	#pf2npc,pflags2(a3)		;set bit for no player collision
	clr.w	Wallcos(a3)				;clear wallCos (angle of last collision)
	clr.w	Wallsin(a3)				;clear wallSin (angle of last collision)
.nna								;every call: at the box door turn and hop in, else skate on (.st)
	move.w	Ypos(a3),d0				;Current Ypos of player
	sub.w	temp4(a3),d0			;sub temp4 (Y pos to skate to) from Ypos
	cmpi.w	#$C,d0					;compare to 13 decimal
	bgt.w	.st						;branch if greater than (still skateto)
	;If its within 13 decimal, it will start the animation for hopping over the board
	cmpi.w	#$FFF4,d0
	blt.w	.st
	move.w	0(a3),d0
	sub.w	temp3(a3),d0
	cmpi.w	#$FFE8,d0
	blt.w	.st
	sub.w	d7,temp1(a3)
	bpl.w	X_31AB6					;CD: the cartridge has rtss4
	addi.w	#8,temp1(a3)
	bset.b	#pfnc,pflags(a3)
	move.w	#SPAglide,d1
	bsr.w	SetSPA
	moveq	#6,d2
	tst.b	handed(a3)
	beq.w	.left
	moveq	#2,d2					;left handed: face 2 (right)
.left								;label name is 92G's; the branch is taken by right handed players
									;(handed 0), who keep d2 = 6 (face left); left handed set d2 = 2
									;turn one step a frame: right handed faces 6 (left, away
									;from the box), left handed 2 (right, toward the box).
									;Righty faces 6 (mirrored to frame dir 2), lefty faces 2:
									;both show the same glide frame, the righty x-flipped
	cmp.w	facedir(a3),d2			;turn one step toward d2
	beq.w	.ok
	addi.w	#1,facedir(a3)
	andi.w	#7,facedir(a3)
.ok									;slide into the box; when stopped and facing it, hop the boards and go to
									;assdopen
	clr.w	Yvel(a3)
	move.w	#$1000,Xvel(a3)
	cmpi.w	#$FFF8,d0
	blt.w	X_31AB6					;CD: the cartridge has rtss4
	clr.w	Xvel(a3)
	cmp.w	facedir(a3),d2
	bne.w	X_31AB6					;CD: the cartridge has rtss4
	bset.b	#pfalock,pflags(a3)
	move.w	#2,facedir(a3)
	move.w	#SPAwallright,d1
	bsr.w	SetSPA
	bclr.b	#pf2pen,pflags2(a3)		;pf2pen
	moveq	#$D,d0					;assdopen
	bra.w	assreplace
.st									;not at the box yet: skate to temp3/temp4
	move.w	temp3(a3),d0
	move.w	temp4(a3),d1
	movea.l	#$31AB6,a0				;CD: the cartridge has #rtss2
	bra.w	skateto
.clrplayer							;take the joystick off player a3
	btst.b	#pfjoycon,pflags(a3)
	beq.w	X_31AB6					;CD: the cartridge has rtss4
	clr.w	d4
	move.w	SCnum(a3),d0
	cmp.w	(c1playernum).l,d0
	beq.w	changeplayer
	moveq	#2,d4
	bra.w	changeplayer
; add player a3 to penalty box
assdopen							;add player a3 to penalty box
	btst.b	#pfalock,pflags(a3)
	bne.w	X_31AB6					;CD: the cartridge has rtss4
	moveq	#$10,d0
	btst.b	#pfteam,pflags(a3)
	beq.w	.1
	moveq	#1,d0
.1									;into the box
	add.b	d0,(PBnum).l			;Players in penalty box
	st.b	position(a3)
	clr.w	frame(a3)
	rts
; player a3 should exit penalty area
assepen								;player a3 should exit penalty area
	btst.b	#pfalock,pflags(a3)
	bne.w	X_31AB6					;CD: the cartridge has rtss4
	bclr.b	#pfna,pflags(a3)
	beq.w	.nna
	bset.b	#pfnc,pflags(a3)		;set player in no collision mode
	bset.b	#pf2unav,pflags2(a3)	;set player unavailable
	moveq	#$10,d0
	moveq	#$FFFFFFC4,d1
	btst.b	#pfteam,pflags(a3)
	beq.w	.0
	moveq	#1,d0
	neg.w	d1
.0									;leave the box
	sub.b	d0,(PBnum).l			;Players in penalty box
	move.w	d1,Ypos(a3)
	clr.w	Xvel(a3)
	clr.w	Yvel(a3)
	move.w	#$86,0(a3)
	move.w	#2,facedir(a3)
	bset.b	#pfalock,pflags(a3)
	move.w	#SPAwallleft,d1
	bsr.w	SetSPA
	jmp	(SprSort).l
.nna								;pfna was clear
	move.w	#4,facedir(a3)
	st.b	newpnum(a3)
	st.b	newpos(a3)
	bclr.b	#pfjoycon,pflags(a3)
	bclr.b	#pfnc,pflags(a3)
	bclr.b	#pf2npc,pflags2(a3)		;pf2npc
	bclr.b	#pf2unav,pflags2(a3)	;pf2unav
	move.w	#$F000,Xvel(a3)
	bra.w	assexit
; moves the goalie not being used during shootout/pen shot off the screen
; a3 = goalie who is to be taken off ice
assgoaliebreakwait					;asstab entry. In a shootout or penalty shot park the idle goalie off the
									;ice, else exit
	btst.b	#pfalock,pflags(a3)		;check if animation locked
	bne.w	.exit					;exit if so
	btst.b	#2,(BA_PS_flags).l		;check if pen shot
	bne.w	.park					;branch if so
	btst.b	#0,(gmode2).l			;check for shootout
	bne.w	.park					;branch if so
	nop
	bra.w	assexit
.park								;bit 2 of BA_PS_flags set or bit 0 of gmode2 set
	clr.w	Xvel(a3)				;clear Xvel
	clr.w	Yvel(a3)				;clear Yvel
	movem.l	d0/a0,-(sp)				;push d0 and a0 on stack
	movea.l	#SortCords,a0			;Home SC Sctruct start
	move.w	(BA_Goalie_SCnum).l,d0	;move Goalie SCNum into d0
	asl.w	#7,d0					;shift d0 7 bits left
	adda.w	d0,a0					;add d0 to address a0
	move.w	#$191,Ypos(a3)			;move 401 decimal into Ypos
	btst.b	#7,pflags(a0)			;check if shooting up or down (a0 is goalie being shot on)
	bne.w	.popstack				;branch if shooting up
	move.w	#$FE6F,Ypos(a3)			;move -191 decimal into Ypos (goalie not being shot on)
.popstack							;pop the d0/a0 saved above
	movem.l	(sp)+,d0/a0
.exit								;exit (also the end of the code above)
	rts
; players do nothing until faceoff is over
assfaceoff							;players do nothing until faceoff is over
	btst.b	#pfalock,pflags(a3)
	bne.w	.exit
	btst.b	#sf2faceoff,(sflags2).l
	beq.w	assexit
.exit								;exit (also the end of the code above)
	rts
; assignment for players actually participating in faceoff
; a3 = player
assfaceoffpl						;Face off player
	btst.b	#pfalock,pflags(a3)
	bne.w	X_31E14					;CD: the cartridge has .exit2
	btst.b	#sf2faceoff,(sflags2).l
	beq.w	.exit
	bclr.b	#pfna,pflags(a3)
	beq.w	.nna
	clr.w	temp1(a3)
.nna								;every call: set the big faceoff sprite frame for this team
	movea.l	#fofdata2,a0			;a0 = fofdata2 (home) or +4 (visitor): big faceoff sprite data
	btst.b	#pfteam,pflags(a3)
	beq.w	.0
;CD: no cartridge twin
	adda.w	#$4,a0
.0									;a0 = this team's big sprite entry (visitor +4)
	move.w	SPAnum(a3),d0			;d0 = SPAnum/4 + 1, +3 for right handed: frame code for the big sprite
	lsr.w	#2,d0
	addi.w	#1,d0
	tst.b	handed(a3)
	bne.w	.lefty
	addi.w	#3,d0
.lefty								;store the frame; computer players also start the faceoff stance once
	move.w	d0,(a0)
	btst.b	#pfjoycon,pflags(a3)
	bne.w	X_31AB6					;CD: the cartridge has .exit2
	bset.b	#pf2aip,pflags2(a3)
	bne.w	X_31AB6					;CD: the cartridge has .exit2
	move.w	#SPAfaceoff,d1
	cmpi.w	#$10,(SortCords+(puckscnum*SCstruct)+temp1).l
	bls.w	.d
	moveq	#8,d0
	bsr.w	randomd0
	tst.w	d0
	beq.w	.d
	move.w	#SPAfaceoffr,d1
.d									;one in 8 computer centers takes the alternate stance (SPAfaceoffr)
	bset.b	#pf2aip,pflags2(a3)
	bra.w	SetSPA
.exit								;shared exit of assfaceoffpl
	move.b	#$14,nopuck(a3)
	bra.w	assexit
.exit2								;exit
	rts
assfight							;rts only: there is no fighting
	rts								;assfight - possible location where fighting logic used to be
; player should do nothing
donothing							;player should do nothing
	btst.b	#pfalock,pflags(a3)		;#pfalock
	bne.w	X_31AB6					;CD: the cartridge has assfwatch
	btst.b	#pfjoycon,pflags(a3)	;#pfjoycon
	bne.w	X_31AB6					;CD: the cartridge has assfwatch
	moveq	#8,d0
	bra.w	doplayeracc
; player skates with stanley cup overhead
assstanley							;player a3 skates with stanley cup overhead
	btst.b	#pfalock,pflags(a3)
	bne.w	X_31AB6					;CD: the cartridge has assfwatch
	bclr.b	#pfna,pflags(a3)
	beq.w	.nna
	move.w	#$5A,temp3(a3)			;90
	tst.w	(Hpos).l
	bpl.w	.0
	neg.w	temp3(a3)
.0									;target Y from Vpos
	move.w	(Vpos).l,temp4(a3)		;temp4 = y from Vpos
	move.w	#SPAstanley,d1
	bsr.w	SetSPA
.nna								;skate toward the target
	move.w	temp3(a3),d0			;face and accelerate toward the target
	sub.w	0(a3),d0
	move.w	temp4(a3),d1
	sub.w	Ypos(a3),d1
	bsr.w	vtoa
	cmpi.w	#7,d0
	bgt.w	X_31AB6					;CD: the cartridge has assfwatch
	move.w	d0,d2
	move.w	d2,facedir(a3)
	bra.w	playeracc
; player a3 celebrates, if scoreing player then do arm pump
assscore							;player a3 celebrates, if scoring player then do arm pump
	btst.b	#pfalock,pflags(a3)
	bne.w	X_31AB6					;CD: the cartridge has assfwatch
	bclr.b	#pfna,pflags(a3)
	beq.w	.nna
	bsr.w	.1
	move.w	#8,temp2(a3)
	move.w	#$5A,temp3(a3)
	tst.w	(Hpos).l
	bpl.w	.0
	neg.w	temp3(a3)
.0									;temp4 = Vpos; celebrate where the camera is
	move.w	(Vpos).l,temp4(a3)
.nna								;every call: in a shootout hold the skater until shootoutdelay runs out
	movea.l	#$31AB6,a0				;CD: the cartridge has #rtss2
	move.w	temp3(a3),d0
	move.w	temp4(a3),d1
	btst.b	#0,(gmode2).l			;start of new code
	beq.w	.noso
	tst.w	(shootoutdelay).l
	beq.w	.chkx
	subi.w	#1,(shootoutdelay).l
	bne.w	.chkx
	bset.b	#sf2drec,(sflags2).l
.chkx								;shootout: skater near the middle (x within -$88..$88) stays on the center
									;line
	cmpi.w	#$88,0(a3)
	bgt.w	.3
	cmpi.w	#$FF78,0(a3)
	bgt.w	.noso
.3									;outside that band: y = 0
	clr.w	d1						;end of new code
.noso								;celebration timer: when it runs out start a new celebrate (pump for the
									;scorer)
	sub.w	d7,temp1(a3)
	bpl.w	.ckcon
	bset.b	#pfalock,pflags(a3)
	move.w	#SPAcelebrate,d1
	move.w	(shotplayer).l,d0
	cmp.w	SCnum(a3),d0
	bne.w	.nopump
	move.w	#SPApump,d1
.nopump								;shooter or not: set the animation and a new random time
	bsr.w	SetSPA
.1									;local subroutine
	moveq	#$78,d0					;120
	bsr.w	randomd0
	move.w	d0,temp1(a3)
	rts
.ckcon								;timer still running: computer players skate to the spot
	btst.b	#pfjoycon,pflags(a3)
	beq.w	skateto
rtss6								;shared rts for the early exits nearby
	rts
; player a3 is defensive player on offense
assdefo								;player a3 is defensive player on offense
	btst.b	#pfalock,pflags(a3)
	bne.w	X_31AB6					;CD: the cartridge has rtss6
	btst.b	#gmclock,(gmode).l		;#gmclock
	bne.w	donothing				;Whistle blown, do nothing
	bsr.w	check4bench				;check if player should go to bench
	btst.b	#pfjoycon,pflags(a3)	;#pfjoycon - is player joystick controlled
	bne.w	X_31AB6					;yes, then exit (CD: the cartridge has rtss6)
	bclr.b	#pfna,pflags(a3)		;#pfna - checks if theres a new assignment
	beq.w	.nna
	clr.w	temp1(a3)				;clears temp1 if new assignment
	move.w	#8,temp2(a3)			;moves 8 into temp2 if new assignment
.nna								;count down the timer
	sub.b	d7,temp1(a3)			;subtract frames elapsed since last call from temp1
	bpl.w	.nodec					;temp1 not zero or negative
	move.b	aioff(a3),temp1(a3)		;Loads aioff into temp1
	jsr	(ReadGoaliePulled).l
	bmi.w	.boost					;branch if goalie is pulled
	btst.b	#6,(sflags7).l			;check if crowd meter broken
	beq.w	.noboost				;branch if not
	tst.b	temp1(a3)				;check if temp1 is 0
	beq.w	.noboost				;branch if so
.boost								;goalie pulled, or crowd meter broken: temp1 one lower (probably a quicker
									;reaction)
	subi.b	#1,temp1(a3)			;sub 1 from temp1
.noboost							;switch to assdefd when offside, then pick the spot by the puck carrier
	moveq	#2,d0					;assdefd
	btst.b	#tmfoside,tmflags(a2)	;check if team is offsides
	bne.w	assreplace				;if so, assreplace
	move.w	(pucky).l,d1			;move pucky into d1
	btst.b	#pfgoal,pflags(a3)		;#pfgoal - check which net to score on
	bne.w	.de1					;branch if top
	neg.w	d1						;Negates d1- shooting on bottom net
.de1								;puck Y for his end
	cmpi.w	#$5D,d1					;slightly above top blueline - checks Y position of puck
	blt.w	assreplace				;not in offensive zone, change assignment
	move.w	(puckc).l,d1			;puck carrier (SCnum) into d1
	bmi.w	.nodec					;branch if no puckc
	subi.w	#6,d1					;sub 6 from d1
	move.w	SCnum(a3),d2			;move SCnum into d2
	subi.w	#6,d2					;sub 6 from d2
	eor.w	d2,d1					;EOR d2 with d1
	bmi.w	assreplace				;ass replace if puckc not on same team
.nodec								;no carrier or our team has the puck: hold the blue line (x 80 to the side
									;of the position)
	lea	EvadePC(pc),a0				;EvadePC, extra collision routine for skateto
	moveq	#$50,d0					;move 80 dec into d0
	cmpi.w	#2,position(a3)			;position(a3) - checks that player is RD
	beq.w	.1						;branch if RD
	neg.w	d0						;player is LD, so negates d0
.1									;d0 = x for RD (+80) or LD (-80); d1 = just inside the blue line
	move.w	#$62,d1					;just inside of blueline
	btst.b	#pfgoal,pflags(a3)		;#pfgoal
	bne.w	.0						;branch if top net shooting
	neg.w	d0						;shooting on bottom net, so negate d0 and d1
	neg.w	d1
.0									;coordinates for his end
	move.w	(puckx).l,d2			;move puckx into d2
	eor.w	d0,d2					;XOR d0 with d2
	bmi.w	.2						;branch if puck on the other side of X center
	move.w	(puckx).l,d0			;move puckx to d0
	bra.w	skateto					;d0/d1 are x/y positions, a0 is extra collision routine
.2									;puck on our side of center: move half way toward it
	move.w	(puckx).l,d2			;move puckx into d2
	asr.w	#1,d2					;divide by 2
	add.w	d2,d0					;add d2 to d0
	bra.w	skateto					;skateto routine
; player a3 is defensive player on defense
assdefd								;player a3 is defensive player on defense
	btst.b	#pfalock,pflags(a3)		;check if locked in animiation
	bne.w	X_31AB6					;exit if so (CD: the cartridge has rtss6)
	btst.b	#gmclock,(gmode).l		;check if clock running
	bne.w	donothing				;donothing if no clock
	bsr.w	check4bench				;check if going to bench
	btst.b	#pfjoycon,pflags(a3)	;check if joystick controlled
	bne.w	X_31AB6					;exit if so (CD: the cartridge has rtss6)
	bclr.b	#pfna,pflags(a3)		;clear new assignment bit
	beq.w	.nna					;branch if no new assignment
	clr.w	temp1(a3)				;clear temp1
	move.w	#8,temp2(a3)			;move 8 into temp2
.nna								;count down the timer
	sub.b	d7,temp1(a3)			;sub frames elapsed from temp1
	bpl.w	.nodec					;branch if not 0
	move.b	aidef(a3),temp1(a3)		;move DfA into temp1
	btst.b	#6,(sflags7).l			;check if crowd meter currently broken
	beq.w	.noboost				;branch if not
	tst.b	temp1(a3)				;check if temp1 is 0
	beq.w	.noboost				;branch if so
	subi.b	#1,temp1(a3)			;sub 1 from temp1
.noboost							;defenseman: shadow the puck, using its y velocity to lead it
	move.w	(pucky).l,d1			;move pucky into d1
	move.w	(puckvy).l,d3			;move puckvy into d3
	asr.w	#6,d3					;divide by 64
	btst.b	#pfgoal,pflags(a3)		;check which net shooting on
	bne.w	.de00					;branch if top
	neg.w	d1						;negate d1 and d3 if bottom
	neg.w	d3
.de00								;puck Y for his end
	tst.w	d3						;check if d3 is zero
	bpl.w	.de000					;branch if positive
	clr.w	d3						;clear d3
.de000								;look-ahead at least 0
	add.w	d1,d3					;add d1 to d3
	cmpi.w	#Blueline,d3			;compare top blueline to d3
	blt.w	.de0
	btst.b	#tmfoside,tmflags(a2)	;check if team is offsides
	bne.w	.de0					;branch if offsides
	move.w	(puckc).l,d1			;move puckc into d1
	bmi.w	.de0					;branch if no puckc
	bsr.w	chkpk					;check if theres a PK
	beq.w	.de0					;branch if on PK
	moveq	#1,d0					;assdefo into d0
	subi.w	#6,d1					;sub 6 from d1
	move.w	SCnum(a3),d2			;move SCnum into d2
	subi.w	#6,d2					;sub 6 from d2
	eor.w	d2,d1					;EOR d2 and d1
	bpl.w	assreplace				;assreplace if puckc on same team
.de0								;other team has the puck: guard x 65 to our side
	move.w	#$41,temp3(a3)			;move 65 dec into temp3
	cmpi.w	#2,position(a3)			;compare if player is RD
	beq.w	.de1					;branch if RD
	neg.w	temp3(a3)				;negate temp3 if LD
.de1								;a0 = the opposing team's players (home 0-5, away 6-11)
	movea.l	#$17480,a0				;move SC struct start into a0 (CD: the cartridge has
									;#(SortCords-M68K_RAM))
	cmpi.w	#6,SCnum(a3)			;compare 6 with player SCnum
	bge.w	.de2					;branch if away team
	adda.w	#6*SCstruct,a0			;add 300 to a0 (start at away SC Struct)
.de2								;find the deepest opponent (d2 = 5..0, start d0 = -1000 or 1000)
	moveq	#5,d2					;move 5 into d2
	move.w	#$FC18,d0				;move -1000 dec into d0
	btst.b	#pfgoal,pflags(a3)		;check what net shooting at
	beq.w	.gdwn					;branch if bottom net
	neg.w	d0						;negate d0
.gup								;d0 = the smallest opponent y (led by Yvel / 16) when we shoot at the top
									;net
	btst.b	#pf2unav,pflags2(a0)	;check if a0 player unavailable
	bne.w	.gu0					;branch if so
	tst.w	position(a0)			;check a0 position
	bmi.w	.gu0					;branch if empty position
	move.w	Yvel(a0),d1				;move Yvel of a0 into d1
	bmi.w	.gu2					;branch if Yvel was negative
	clr.w	d1						;clear d1
.gu2								;look-ahead Y (back only)
	asr.w	#4,d1					;divide d1 by 16
	add.w	Ypos(a0),d1				;add Ypos of a0 player to d1
	cmp.w	d0,d1					;compare d0 to d1
	bgt.w	.gu0					;branch if d1 is greater
	move.w	d1,d0					;move d1 into d0
.gu0								;next opponent
	adda.w	#SCstruct,a0			;add 80 (offset to next player struct) to a0
	dbf	d2,.gup						;loop
	subi.w	#$32,d0					;sub $32 (50 dec) from d0
	cmpi.w	#$FF42,d0				;compare to $FF42 (-190 dec)
	bgt.w	.gu1					;branch if greater than
	move.w	#$FF24,d0				;move -220 dec into d0
.gu1								;temp4 = guard y; if the puck is across center, stay in the middle (x 0)
	move.w	d0,temp4(a3)			;move d0 into temp4
	move.w	(puckx).l,d0			;move puckx into d0
	move.w	temp3(a3),d1			;move temp3 into d1
	eor.w	d0,d1					;EOR d0 and d1
	bpl.w	.nodec					;branch if puck on same side
	clr.w	temp3(a3)				;clear temp3 if not
	bra.w	.nodec
.gdwn								;pfgoal clear
	btst.b	#pf2unav,pflags2(a0)	;check if player a0 unavail
	bne.w	.gd0					;branch if so
	tst.w	position(a0)			;check a0 position
	bmi.w	.gd0					;branch if empty (goalie)
	move.w	Yvel(a0),d1				;move Yvel of a0 into d1
	bpl.w	.gd2					;branch if positive
	clr.w	d1						;clear d1
.gd2								;look-ahead Y (forward only)
	asr.w	#4,d1					;divide d1 by 16
	add.w	Ypos(a0),d1				;add Ypos of a0 to d1
	cmp.w	d0,d1					;compare d0 to d1
	blt.w	.gd0					;branch if less than d0
	move.w	d1,d0					;move d1 into d0
.gd0								;next opponent (bottom net: d0 = the largest y)
	adda.w	#SCstruct,a0			;add offset to next player struct
	dbf	d2,.gdwn					;loop
	addi.w	#$32,d0					;add 32 to d0
	cmpi.w	#$BE,d0					;compare 190 dec to d0
	blt.w	.gd1					;branch if d0 less than
	move.w	#$DC,d0					;move 220 dec into d0
.gd1								;target Y clamped
	move.w	d0,temp4(a3)			;move d0 into temp4
	neg.w	temp3(a3)				;negate temp3
	move.w	(puckx).l,d0			;move puckx into d0
	move.w	temp3(a3),d1			;move temp3 into d1
	eor.w	d0,d1					;EOR d0 and d1
	bpl.w	.nodec					;branch if puck on same side
	clr.w	temp3(a3)				;clear temp3 if not
.nodec								;skate to the guard spot with collision avoidance, then try a check
	move.w	temp3(a3),d0			;move temp3 to d0
	move.w	temp4(a3),d1			;move temp4 to d1
	movea.l	#EvadePC,a0				;EvadePC to a0
	bsr.w	skateto
	bra.w	check4check
rtss21								;shared rts for the early exits nearby
	rts
; player a3 is winger on defense
asswingd							;player a3 is wing on defense
	btst.b	#pfalock,pflags(a3)		;check if locked in animation
	bne.w	rtss21					;exit if so
	btst.b	#gmclock,(gmode).l		;check if clock is running
	bne.w	donothing				;donothing if its stopped
	bsr.w	check4bench				;check if going to bench
	btst.b	#pfjoycon,pflags(a3)	;check if joystick controlled
	bne.w	rtss21					;exit if so
	bclr.b	#pfna,pflags(a3)		;clear new assignment bit
	beq.w	.nna					;branch if cleared already (no new assignment)
	clr.w	temp1(a3)				;clear temp1
	move.w	#8,temp2(a3)			;move 8 into temp2
.nna								;count down the timer
	sub.b	d7,temp1(a3)			;sub frames elapsed from temp1
	bpl.w	.nodec					;branch if not 0
	move.b	aidef(a3),temp1(a3)		;move DfA into temp1
	btst.b	#6,(sflags7).l			;check if crowd meter currently broken
	beq.w	.noboost				;branch if not
	tst.b	temp1(a3)				;check if temp1 is 0
	beq.w	.noboost				;branch if 0
	subi.b	#1,temp1(a3)			;sub 1 from temp1
.noboost							;if our team has the puck, switch to asswingo
	move.w	(puckc).l,d1			;move puckc into d1
	bmi.w	.nodec					;branch if no puck carrier
	moveq	#4,d0					;asswingo into d0
	subi.w	#6,d1					;sub 6 from d1
	move.w	SCnum(a3),d2			;move SCnum into d2
	subi.w	#6,d2					;sub 6 from d2
	eor.w	d2,d1					;EOR d2 with d1. Checks if player on same team
	bpl.w	assreplace				;branch if team has puck
.nodec								;defending: x 100 to the wing side, y below our blue line
	moveq	#$64,d0					;move 64 (100 dec) into d0
	cmpi.w	#5,position(a3)			;check if player is RW
	bne.w	.1						;branch if not
	neg.w	d0						;make d0 negative
.1									;d1 = blue line + 70 for the side we defend
	move.l	#$9E,d1					;move $9E into d1 (blueline + 70 dec)
	btst.b	#pfgoal,pflags(a3)		;check which goal shooting at
	beq.w	.0						;branch if bottom goal
	neg.w	d0						;negate d0
	neg.w	d1						;negate d1
	moveq	#$FFFFFFB2,d2			;move into d2 (slightly above bottom blue line)
	btst.b	#tmfoside,tmflags(a2)	;currently offside (tmfoside of the team's tmflags)
									;the home team's (tmstruct) or the away team's
									;(awtmstruct) flags word
	bne.w	.dg11					;branch if set
	cmp.w	(pucky).l,d2			;compare pucky to d2
	bgt.w	.ug1					;branch if puck in defensive zone
	move.w	(pucky).l,d1			;move pucky into d1
	bra.w	.z1
.ug1								;d2 > pucky
	move.w	#$FEF8,d2				;move bottom goal line into d2
	cmp.w	(pucky).l,d2			;compare pucky to d2
	blt.w	.z1						;branch if puck in defensive zone
	move.w	d2,d1					;move d2 into d1 if puck behind goal line
	bra.w	.z1
.0									;pfgoal clear
	moveq	#$4E,d2					;defending top goal
									;4E - slightly below top blue line
	btst.b	#tmfoside,tmflags(a2)	;currently offside (tmfoside of the team's tmflags)
									;the home team's (tmstruct) or the away team's
									;(awtmstruct) flags word
	bne.w	.dg11					;branch if set
	cmp.w	(pucky).l,d2			;compare pucky to d2
	blt.w	.dg1					;branch if puck in defensive zone
	move.w	(pucky).l,d1			;move pucky into d1
	bra.w	.z1
.dg1								;d2 < pucky
	move.w	#$108,d2				;move top goal line into d2
	cmp.w	(pucky).l,d2			;compare pucky to d2
	bgt.w	.z1						;branch if puck in between goal line and blue line
.dg11								;clamp to the goal line
	move.w	d2,d1					;move d2 into d1 if puck behind goal line
.z1									;puck on the other side of center: hold x; else follow the puck x
	lea	(rtss21).l,a0
	move.w	(puckx).l,d2			;move puckx into d2
	eor.w	d0,d2					;EOR d0 and d2
	bmi.w	skateto					;branch if minus - skate to d0/d1, no extra routine
	move.w	(puckx).l,d0			;move puckx into d0
	bra.w	skateto					;skate to d0/d1 no extra routine
; player a3 is winger on offense

asswingo							;player a3 is winger on offense
	btst.b	#pfalock,pflags(a3)		;check if locked in animation
	bne.w	rtss21					;exit if so
	btst.b	#gmclock,(gmode).l		;check game clock
	bne.w	donothing				;donothing if stopped
	bsr.w	check4bench				;check if player going to bench
	btst.b	#pfjoycon,pflags(a3)	;check if joystick controlled
	bne.w	rtss21					;exit if so
	bclr.b	#pfna,pflags(a3)		;clear new assignment bit
	beq.w	.nna					;branch if it was already cleared
	st.b	temp5(a3)				;set old zone # (temp5)
	clr.w	temp1(a3)				;clear temp1
	move.w	#8,temp2(a3)			;move 8 into temp2
.nna								;count down the timer
	sub.b	d7,temp1(a3)			;subtract frames elapsed from temp1
	bpl.w	.nodec					;branch if positive
	move.b	aidef(a3),temp1(a3)		;move DfA into temp1
	btst.b	#6,(sflags7).l			;check if crowd meter currently broken
	beq.w	.noboost
	tst.b	temp1(a3)				;check if temp1 is 0
	beq.w	.noboost
	subi.b	#1,temp1(a3)			;subtract 1 from temp1
.noboost							;winger on offense: switch to asswingd if the other team has the puck
	moveq	#3,d0					;move asswingd into d0
	move.w	(puckc).l,d1			;move puckc SCnum into d1
	bmi.w	.de0					;branch if no puckc
	subi.w	#6,d1					;sub 6 from d1
	move.w	SCnum(a3),d2			;move SCnum into d2
	subi.w	#6,d2					;sub 6 from d2
	eor.w	d2,d1					;EOR d2 with d1. Checks if puckc on same team
	bmi.w	assreplace				;if not, branch to assreplace
.de0								;puck carrier on his team
	move.w	(pucky).l,d0			;pucky into d0
	move.w	(puckvy).l,d3			;puckvy into d3
	asr.w	#6,d3					;divide d3 by 64
	add.w	d0,d3					;add d0 to d3
	btst.b	#pfgoal,pflags(a3)		;check which goal shooting on
	bne.w	.de1					;branch if top goal
	neg.w	d0						;negate d0
	neg.w	d3						;negate d3
.de1								;coordinates for his end
	clr.w	d2						;clear zone number
	cmpi.w	#$FFA8,d3				;compare bottom blue line with d3
	blt.w	.de2					;branch if in defensive zone
	addi.w	#8,d2					;add 8 to d2 (d2 = 8)
	cmpi.w	#$58,d0					;compare top blue line with d0
	blt.w	.de2					;branch if in neutral zone
	btst.b	#tmfoside,tmflags(a2)	;currently offside (tmfoside of the team's tmflags)
									;(the home team's tmstruct or the away team's awtmstruct)
	bne.w	.de2					;branch if set
	addi.w	#8,d2					;add 8 to d2 (d2 = $10)
	cmpi.w	#$108,d3				;compare top goal line with d3
	blt.w	.de2					;branch if in offensive zone
	addi.w	#8,d2					;add 8 to d2 (d2 = $18)
.de2								;d2 = zone index by where the puck is (offensive zone and past the goal
									;line)
	cmp.w	temp5(a3),d2			;compare temp5 with d2
	bne.w	.de3					;branch if different zone
;CD: no cartridge twin
.L324AA
	btst.b	#$7,$FF800E.l
	bne.s	.L324AA
	move.w	#$1B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L324C4
	btst.b	#$6,$FF800E.l
	beq.s	.L324C4
	move.w	$FF8010.l,d0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L324E4
	btst.b	#$6,$FF800E.l
	bne.s	.L324E4
	bclr.b	#$7,$FF800F.l
	andi.w	#$7F,d0					;pass first 7 bits
	bne.w	.nodec					;branch if not equal to 0 - this allows random
									;movement in zone while waiting
.de3								;new zone (or 1 frame in 128): pick a new random spot from .dedata
	move.w	d2,temp5(a3)			;move d2 into temp5
	lea	.dedata(pc),a0				;move zonedata address into a0
	move.w	$2(a0,d2.w),d0			;move X Coord into d0
	bsr.w	randomd0s				;RNG d0
	add.w	(a0,d2.w),d0			;add X Coord offset to d0
	move.w	d0,temp3(a3)			;move d0 into temp3
	move.w	$6(a0,d2.w),d0			;move Y Coord into d0
	bsr.w	randomd0s				;RNG d0
	add.w	$4(a0,d2.w),d0			;add Y Coord offset into d0
	move.w	d0,temp4(a3)			;move d0 into temp4
	bra.w	.nodec
.dedata								;x, x random, y, y random
	dc.w	$50						;Skating zones:
									;Defensive zone
	dc.w	$14
	dc.w	$FFBA
	dc.w	$A
	dc.w	$64						;neutral zone
	dc.w	$14
	dc.w	$3A
	dc.w	5
	dc.w	$3C						;offensive zone
	dc.w	$32
	dc.w	$E6
	dc.w	$14
	dc.w	$50						;past goalline
	dc.w	$1E
	dc.w	$FA
	dc.w	$14
.nodec								;skate to the spot; LW mirrors x
	move.w	temp3(a3),d0			;move temp3 into d0
	cmpi.w	#5,position(a3)			;compare 5 (RW) to position
	beq.w	.1						;branch if RW
	neg.w	d0						;negate d0
.1									;d1 = spot y; flip both for the bottom net
	move.w	temp4(a3),d1			;move temp4 into d1
	btst.b	#pfgoal,pflags(a3)		;check if shooting up or down
	bne.w	.0						;branch if shooting up
	neg.w	d0						;negate d0
	neg.w	d1						;negate d1
.0									;coordinates for his end
	lea	EvadePC(pc),a0				;add EvadePC as aux routine
	bra.w	skateto					;skate to d0/d1 position
rtss11								;shared rts for the early exits nearby
	rts
; player a3 is center on defense
; d7 = elapsed frames
asscenterd							;player a3 is center on defense
	btst.b	#pfalock,pflags(a3)		;pfalock - locked animation
	bne.w	rtss11					;exit if locked
	btst.b	#gmclock,(gmode).l		;gmclock - check if clock is running
	bne.w	donothing				;exit if stoppage
	bsr.w	check4bench
	btst.b	#pfjoycon,pflags(a3)	;pfjoycon - check if joystick controlled
	bne.w	rtss11					;exit if joystick controlled
	bclr.b	#pfna,pflags(a3)		;pfna - new assignment
	beq.w	.nna					;branch if no new assignment
	clr.w	temp1(a3)				;clear temp1
	move.w	#8,temp2(a3)			;move 8 into temp2
.nna								;count down the timer
	sub.b	d7,temp1(a3)			;subtract d7 from temp1
	bpl.w	.nodec
	move.b	aidef(a3),temp1(a3)		;move aidef into temp1
	btst.b	#6,(sflags7).l			;check for crowd record flag
	beq.w	.puckcarrier			;jump if not set
	tst.b	temp1(a3)				;check if 0
	beq.w	.puckcarrier
	subi.b	#1,temp1(a3)			;subtract 1 from temp1
.puckcarrier						;center on defense: switch to asscentero if our team has the puck
	move.w	(puckc).l,d1			;move puck carrier SCnum into d1
	bmi.w	.nodec
	moveq	#6,d0					;asscentero
	subi.w	#6,d1					;subtract 6 from d1
	move.w	SCnum(a3),d2			;move player's SCnum into d2
	subi.w	#6,d2					;subtract 6 from d2
	eor.w	d2,d1					;compare d2 and d1
	bpl.w	assreplace				;if team has puck, replace assignment with acentero
.nodec								;no carrier or the other team has it: cover between the puck and our net
	move.w	(puckx).l,d0			;Xpos of puck
	asr.w	#1,d0					;divide by 2
	move.w	(pucky).l,d2			;Ypos of puck
	btst.b	#pfgoal,pflags(a3)		;pfgoal - check which net to shoot on
	bne.w	.1						;branch if top net
	neg.w	d2						;negate d2 if shooting on bottom net
.1									;X for his end
	moveq	#$FFFFFF80,d1			;-128 - own high slot
	cmpi.w	#$FFA8,d2				;-88 - own blue line
	blt.w	.chkgoal				;branch if puck in defensive zone
	add.w	(pucky).l,d1			;add pucky position to d1
	asr.w	#1,d1					;divide by 2
.chkgoal							;puck in our zone: use its y as is
	btst.b	#pfgoal,pflags(a3)		;pfgoal - check which net to shoot at
	bne.w	.z1						;branch if top net
	neg.w	d1						;shooting at bottom net
.z1									;Y for his end
	lea	(rtss11).l,a0				;no extra collision routine
	bra.w	skateto					;d0/d1 - x/y coord for skating to
; player a3 is center on offense
asscentero							;player a3 is center on offense
	btst.b	#pfalock,pflags(a3)		;pfalock
	bne.w	rtss11					;exit if anim locked
	btst.b	#gmclock,(gmode).l		;#gmclock
	bne.w	donothing				;do nothing
	bsr.w	check4bench
	btst.b	#pfjoycon,pflags(a3)	;pfjoycon - check if joystick controlled
	bne.w	rtss11					;exit if controlled
	bclr.b	#pfna,pflags(a3)		;clear pfna
	beq.w	.nna
	st.b	temp5(a3)				;old zone number - temp5
	clr.w	temp1(a3)				;clear temp1
	move.w	#8,temp2(a3)			;move 8 into temp2
.nna								;count down the timer
	sub.b	d7,temp1(a3)			;subtract d7 from temp1 (d7 = elapsed frames)
	bpl.w	.nodec					;branch if temp1 not zero or neg
	move.b	aidef(a3),temp1(a3)		;move aidef into temp1
	btst.b	#6,(sflags7).l			;check if crowd record broken
	beq.w	.noboost
	tst.b	temp1(a3)				;check if temp1 is 0
	beq.w	.noboost
	subi.b	#1,temp1(a3)			;sub 1 from temp1
.noboost							;center on offense: switch to asscenterd if the other team has the puck
	move.w	(puckc).l,d1			;move puck carrier SCnum into d1
	bmi.w	.de0
	moveq	#5,d0					;asscenterd
	subi.w	#6,d1
	move.w	SCnum(a3),d2			;move SCnum into d2
	subi.w	#6,d2
	eor.w	d2,d1					;checks to see if puck carrier is on team
	bmi.w	assreplace				;if not switch to acenterd
.de0								;puck carrier on his team
	move.w	(pucky).l,d0			;pucky in d0
	btst.b	#pfgoal,pflags(a3)		;#pfgoal - check what goal shooting on
	bne.w	.de1					;branch if top
	neg.w	d0						;negate if bottom net
.de1								;coordinates for his end
	clr.w	d2						;d2 = zone number
	cmpi.w	#$FFA8,d0				;check if own blue line
	blt.w	.de2					;branch if in def zone
	addi.w	#8,d2					;set zone to 8
	cmpi.w	#$58,d0					;check opponents blue line
	blt.w	.de2					;branch if in neutral zone
	btst.b	#tmfoside,tmflags(a2)	;Checks if currently offside
									;the home team's (tmstruct) or the away team's
									;(awtmstruct) flags word
	bne.w	.de2					;branch if offside
	addi.w	#8,d2
	cmpi.w	#$108,d0				;check opponents goal line
	blt.w	.de2					;branch if in offensive zone
	addi.w	#8,d2					;add if past goal line
.de2								;d2 = zone index by where the puck is
	cmp.w	temp5(a3),d2			;compare temp5 to d2
	bne.w	.de3
;CD: no cartridge twin
.L32702
	btst.b	#$7,$FF800E.l
	bne.s	.L32702
	move.w	#$1B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L3271C
	btst.b	#$6,$FF800E.l
	beq.s	.L3271C
	move.w	$FF8010.l,d0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L3273C
	btst.b	#$6,$FF800E.l
	bne.s	.L3273C
	bclr.b	#$7,$FF800F.l
									;This allows a chance for random movement in zone when waiting
	andi.w	#$7F,d0					;pass bottom 7 bits
	bne.w	.nodec
.de3								;new zone (or 1 frame in 128): pick a new random spot from .dedata
	move.w	d2,temp5(a3)			;move zone into temp5
	lea	.dedata(pc),a0
	move.w	$2(a0,d2.w),d0			;move zone into d0
	bsr.w	randomd0s				;randomize d0
	add.w	(a0,d2.w),d0			;add to d0
	move.w	d0,temp3(a3)			;move into temp3 (X coord)
	move.w	$6(a0,d2.w),d0			;move into d0
	bsr.w	randomd0s				;randomize d0
	add.w	$4(a0,d2.w),d0			;add into d0
	move.w	d0,temp4(a3)			;move into temp4 (Y coord)
	bra.w	.nodec
.dedata								;x, x random, y, y random per zone
	dc.w	0						;Skating Zones
									;puck location = defensive zone
	dc.w	$3C
	dc.w	$FFBA
	dc.w	$A
	dc.w	0						;neutral zone
	dc.w	$3C
	dc.w	$3C
	dc.w	$A
	dc.w	0						;offensive zone
	dc.w	$28
	dc.w	$AA
	dc.w	$1E
	dc.w	0						;below offensive goal line
	dc.w	$50
	dc.w	$AA
	dc.w	$14
.nodec								;skate to the spot, mirrored for the bottom net
	move.w	temp3(a3),d0			;move temp3 into d0 (x coord to skate to)
	move.w	temp4(a3),d1			;move temp4 into d1 (y coord to skate to)
	btst.b	#pfgoal,pflags(a3)		;pfgoal
	bne.w	.0						;branch if top
	neg.w	d1						;negate if bottom
.0									;Y for his end
	lea	EvadePC(pc),a0
	bra.w	skateto
; joypad controlled goalie control
; a3 = goalie
assgoaliectrl						;joypad controlled goalie control: a3 = goalie; a goalie not on the
									;joystick leaves through assexit
	btst.b	#pfjoycon,pflags(a3)	;is player joystick controlled?
	bne.w	.goaliectrl				;branch is so
	bra.w	assexit
.goaliectrl							;pfjoycon set
	btst.b	#pfna,pflags(a3)		;check if new assignment
	bne.w	.na						;branch if new assignment
	movem.w	d0-d1,-(sp)				;push to stack
	move.w	0(a3),d0				;Xpos
	move.w	Ypos(a3),d1				;Ypos
	cmpi.w	#$AA,d1					;compare $AA to Ypos
	bgt.w	.cont
	cmpi.w	#$FF56,d1				;check -$AA to Ypos
	blt.w	.cont					;branch if less than
	btst.b	#gmclock,(gmode).l		;check if clock stopped
	bne.w	.cont					;branch if so
	move.w	d0,-(sp)				;push to stack
	move.w	#8,d0					;clock stoppage due to goalie out of range
	jsr	(AddPenalty2).l
	move.w	(sp)+,d0				;pop from stack
.cont								;goalie on the joystick: clear control when far from the screen center
	sub.w	(Hpos).l,d0				;sub ice rink horiz position from Xpos
	sub.w	(Vpos).l,d1				;sub ice rink vert position from Ypos
	bclr.b	#pf3gctrl,pflags3(a3)	;clear goalie control bit?
	cmpi.w	#$74,d0					;compare $74 to Xpos diff
	blt.w	.0						;branch if less than
	bset.b	#pf3gctrl,pflags3(a3)	;set goalie control bit?
	bra.w	.cont2
.0									;d0 < $74
	cmpi.w	#$FF8C,d0				;compare -$74 to Xpos diff
	bgt.w	.1						;branch if greater than
	bset.b	#pf3gctrl,pflags3(a3)	;set goalie control bit?
	bra.w	.cont2
.1									;x on screen: check y
	cmpi.w	#$64,d1					;compare $64 to Ypos diff
	blt.w	.2						;branch if less than
	bset.b	#pf3gctrl,pflags3(a3)	;set goalie control bit?
	bra.w	.cont2
.2									;d1 < $64
	cmpi.w	#$FF9C,d1				;compare -$64 to Ypos diff
	bgt.w	.cont2					;branch if greater than
	bset.b	#pf3gctrl,pflags3(a3)	;set goalie control bit?
.cont2								;pop the d0-d1 saved above
	movem.w	(sp)+,d0-d1				;pop from stack
	btst.b	#pf3gctrl,pflags3(a3)	;check goalie ctrl bit
	bne.w	checkanim				;branch if set
.na									;no new assignment
	btst.b	#pfalock,pflags(a3)		;check if anim lock
	bne.w	X_31AB6					;exit if so (CD: the cartridge has rtss2)
	bsr.w	check4bench
	bclr.b	#pfna,pflags(a3)		;clear new assignment bit
	beq.w	.nna					;branch if already cleared
	clr.w	temp1(a3)				;clear temp1
	move.w	#8,temp2(a3)			;move 8 into temp2
	st.b	temp4(a3)				;FFFF to temp4
.nna								;count down the timer
	btst.b	#pf2aip,pflags2(a3)		;check if anim in progress
	bne.w	.ex						;exit if so (CD: the cartridge has rtss2)
	btst.b	#gmclock,(gmode).l		;check if clock stopped
	bne.w	X_31AB6					;exit if so (CD: the cartridge has rtss2)
	tst.w	temp5(a3)				;test temp5
	bmi.w	.nofo					;branch if less than 0
	move.w	SCnum(a3),d0			;move SCnum into d0
	cmp.w	(puckc).l,d0			;check if puckc is goalie
	beq.w	.mbfo					;branch if equal
	st.b	temp5(a3)				;set temp5 to -1
	bra.w	.nofo
.mbfo								;d0 = puckc
	sub.w	d7,temp5(a3)			;subtract d7(frames elapsed) from temp5
	bpl.w	.nofo					;branch if more than 0
	btst.b	#2,(BA_PS_flags).l		;check bit 2
	beq.w	.stoppage				;branch if not set
	bset.b	#4,(BA_PS_flags).l
	bra.w	.nofo
.stoppage							;bit 2 of BA_PS_flags clear
	moveq	#8,d0
	bsr.w	AddPenalty2
.nofo								;no faceoff needed: count down the reaction timer (defensive awareness)
	sub.b	d7,temp1(a3)			;sub d7(frames elapsed) from temp1
	bpl.w	.ex						;branch if positive
	move.b	aidef(a3),d0			;DfA into d0
	beq.w	.3						;branch if value was 0
	btst.b	#6,(sflags7).l			;check if crowd meter broken
	beq.w	.3						;jump if not
	subi.b	#1,d0					;sub 1 from d0
.3									;random check
	lsr.b	#2,d0					;divide by 4
	move.b	d0,temp1(a3)			;move d0 into temp1
	move.w	SCnum(a3),d0			;move SCnum into d0
	cmp.w	(puckc).l,d0			;compare puckc to d0
	beq.w	.ex						;jump to assgoaliecpu if the same
.ex									;exit (also the end of the code above)
	rts
; a3 = goalie
assgoalie							;Player a3 is goalie (92 name; asstab agoalie and assnearest)
assgoaliecpu						;CPU goalie logic (a joypad goalie goes to assgoaliectrl)
	btst.b	#pfjoycon,pflags(a3)	;is goalie joystick controlled?
	bne.w	assgoaliectrl			;branch if so
checkanim							;Goalie animation check; assgoaliectrl branches here too
	move.w	(puckx).l,(TmpPuckX).l
	btst.b	#0,(sflags4).l			;test bit 0
	beq.w	.assstart
	btst.b	#pf2aip,pflags2(a3)		;check if animation in progress
	bne.w	.assstart				;branch if so
	btst.b	#1,(sflags4).l			;test bit 1
	beq.w	.0						;branch if 0
	btst.b	#3,(sflags4).l			;test bit 3
	bne.w	.assstart				;branch if set
	cmpi.w	#SPFslamtop,frame(a3)	;compare to alice frame number
	bne.w	.assstart				;branch if not equal
	cmpi.w	#SPFslambot,frame(a3)	;compare to alice frame number
	bne.w	.assstart				;branch if not equal
	bset.b	#3,(sflags4).l			;set bit 3
	move.w	#SFXcheck,-(sp)			;SFX
	bsr.w	sfx
	bra.w	.assstart				;set bit 3
.0									;bit 1 of sflags4 clear
	movem.w	d0-d1,-(sp)
	move.w	(pucky).l,d0			;pucky to d0
	move.w	Ypos(a3),d1				;move Ypos to d1
	eor.w	d1,d0					;XOR d1 to d0
	movem.w	(sp)+,d0-d1
	bmi.w	.assstart				;branch if d0 is negative
	cmpi.w	#$14,0(a3)				;compare 14 to Xpos
	bgt.w	.assstart				;branch if greater
	cmpi.w	#$FFEC,0(a3)			;compare -14 to Xpos
	ble.w	.assstart				;branch if less than
	bset.b	#1,(sflags4).l			;set bit 1
	bclr.b	#3,(sflags4).l			;clear bit 3
	move.w	#SPAgslamtop,d1			;goalie stick slam after a goal, top net
	btst.b	#pfgoal,pflags(a3)		;check what goal shooting at
	beq.w	.1						;branch if bottom
	move.w	#SPAgslambot,d1			;bottom net
.1									;slam animation set
	bsr.w	SetSPA					;set animation of d1
	bset.b	#pf2aip,pflags2(a3)		;set anim in progress
.assstart							;goalie assignment proper: bench check and new assignment setup
	btst.b	#pfalock,pflags(a3)		;check if locked in animation
	bne.w	X_33056					;exit if so (CD: the cartridge has rtss2)
	bsr.w	check4bench
	bclr.b	#pfna,pflags(a3)		;clear new assignment
	beq.w	.nna					;jump if it was cleared already
	clr.w	temp1(a3)				;clear temp1
	move.w	#8,temp2(a3)			;move 8 into temp2
	st.b	temp4(a3)				;set temp5 (FFFF)
.nna								;count down the timer
	cmpi.w	#$34,0(a3)				;compare 34 hex with Xpos
	bgt.w	.nna2					;branch if greater
	cmpi.w	#$FFCC,0(a3)			;compare -34 hex with Xpos
	blt.w	.nna2					;branch if less than
	cmpi.w	#$10E,Ypos(a3)			;compare 10E with Ypos
	bgt.w	.nna2
	cmpi.w	#$FEF2,Ypos(a3)
	blt.w	.nna2
	cmpi.w	#$D2,Ypos(a3)
	bgt.w	.noskate
	cmpi.w	#$FF2E,Ypos(a3)
	blt.w	.noskate
.nna2								;near the net: skate back to the middle of the crease
	lea	X_33056(pc),a0				;goalie will skate back to middle position (CD: the cartridge has
									;rtss2(pc))
	moveq	#4,d0
	tst.w	0(a3)					;test Xpos
	bpl.w	.2						;branch if positive
	neg.w	d0
.2									;set the X offset
	move.w	#$E4,d1
	btst.b	#pfgoal,pflags(a3)		;check what goal shooting at
	beq.w	skateto					;branch if bottom
	neg.w	d1
	bra.w	skateto
.noskate							;in position: ready stance, facing up or down the ice
	btst.b	#pf2aip,pflags2(a3)		;check if anim in progress
	bne.w	X_33056					;exit if so (CD: the cartridge has rtss2)
	btst.b	#0,(sflags4).l			;check bit 0
	beq.w	.noskate3				;branch if not set
	cmpi.w	#SPFslamtop+1,frame(a3)	;check alice frame
	beq.w	.noskate2				;branch if equal
	cmpi.w	#SPFslambot+1,frame(a3)	;check alice frame
	bne.w	.noskate3				;branch if not equal
	move.w	#4,facedir(a3)			;set 4 to facedir - face down
	bra.w	.noskate3
.noskate2							;facing the top net
	move.w	#0,facedir(a3)			;set 0 to facedir - face up
.noskate3							;ready stance; a penalty shot keeps the goalie set
	move.w	#SPAgready,d1
	bsr.w	SetSPA
	btst.b	#2,(BA_PS_flags).l		;check bit 2
	bne.w	.noskate4				;branch if set
	btst.b	#gmclock,(gmode).l		;check if clock
	bne.w	X_33056					;exit if clock stopped (CD: the cartridge has rtss2)
.noskate4							;skate to the spot
	tst.w	temp5(a3)				;temp5
	bmi.w	.nofo					;branch if minus
	move.w	SCnum(a3),d0			;move SCnum to d0
	cmp.w	(puckc).l,d0			;check if puckc
	beq.w	.mbfo					;branch if so
	st.b	temp5(a3)				;set temp5 to FFFF
	bra.w	.nofo
.mbfo								;d0 = puckc
	sub.w	d7,temp5(a3)			;subtract frames from temp5
	bpl.w	.nofo					;branch if positive
	btst.b	#2,(BA_PS_flags).l		;check if bit 2 set
	beq.w	.mbfo2					;branch if not
	bset.b	#4,(BA_PS_flags).l		;set bit 4
	bra.w	.nofo
.mbfo2								;bit 2 of BA_PS_flags clear
	moveq	#PenGhold,d0
	bsr.w	AddPenalty2				;blow whistle for FO
.nofo								;no faceoff: count down the reaction timer
	sub.b	d7,temp1(a3)			;sub d7 from temp1
	bpl.w	.nodec					;branch if still positive
	move.b	aidef(a3),d0			;move aidef into d0 (DfA)
	beq.w	.nofo2					;branch if 0
	btst.b	#6,(sflags7).l			;check if crowd meter broken
	beq.w	.nofo2					;branch if not
	subi.b	#1,d0					;sub from d0
.nofo2								;faceoff odds
	lsr.b	#2,d0					;divide by 4
	move.b	d0,temp1(a3)			;move d0 into temp1
	btst.b	#pfjoycon,pflags(a3)	;check if joy controlled
	beq.w	.nocontrol				;branch if not
	btst.b	#pf3gctrl,pflags3(a3)	;check bit 2
	bne.w	.nocontrol				;branch if set
	moveq	#$1D,d0					;assignment assgoaliectrl
	bra.w	assinsert
.nocontrol							;pfjoycon clear or pf3gctrl set
	move.w	(pucky).l,d0			;move pucky into d0
	move.w	Ypos(a3),d1				;move Ypos into d1
	eor.w	d0,d1					;XOR
	bpl.w	.3						;branch if positive
	clr.w	d0
	move.w	#$F4,d2					;move F4 into d2
	btst.b	#pfgoal,pflags(a3)		;check which net shooting at
	beq.w	.de5					;branch if bottom
	neg.w	d2
	bra.w	.de5
.3									;timer out: count temp4 down to -1
	subi.w	#1,temp4(a3)			;sub 1 from temp4
	bpl.w	.4						;branch if positive
	move.w	#$FFFF,temp4(a3)		;move -1 into temp4
.4									;is the goalie the puck carrier?
	move.w	SCnum(a3),d0			;SCnum into d0
	cmp.w	(puckc).l,d0			;check if puckc
	bne.w	.notpuckc				;branch if not
	tst.w	temp5(a3)				;check temp5
	bpl.w	.5						;branch if positive
	move.w	#$5A,temp5(a3)			;move 5A into temp5
.5									;goalie holding the puck: freeze timer at 90, then pass or whistle
	st.b	temp4(a3)				;FFFF into temp4
	cmpi.w	#$5A,temp5(a3)			;compare to temp5
	bgt.w	.de1					;branch if greater
;CD: no cartridge twin
.L32BAC
	btst.b	#$7,$FF800E.l
	bne.s	.L32BAC
	move.w	#$1B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L32BC6
	btst.b	#$6,$FF800E.l
	beq.s	.L32BC6
	move.w	$FF8010.l,d0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L32BE6
	btst.b	#$6,$FF800E.l
	bne.s	.L32BE6
	bclr.b	#$7,$FF800F.l
	andi.w	#3,d0					;pass first 2 bits
	bne.w	.de1					;branch if not 0
	moveq	#5,d0
	movea.l	#$17480,a0				;CD: the cartridge has #(SortCords-M68K_RAM)
	btst.b	#pfteam,pflags(a3)		;check home or away
	bne.w	.opploop				;branch if away
	adda.w	#$300,a0
.opploop							;each player of the other team
	btst.b	#pf2unav,pflags2(a0)	;check if player unavailable
	bne.w	.opploop2				;branch if so
	move.w	(pucky).l,d1			;pucky into d1
	sub.w	Ypos(a0),d1				;sub Ypos a0 from d1
	cmpi.w	#$1C,d1					;compare 1C to difference
	bgt.w	.opploop2				;branch if greater
	cmpi.w	#$FFE4,d1				;compare -1C
	blt.w	.opploop2				;branch if less than
	move.w	(puckx).l,d1			;puckx into d1
	sub.w	0(a0),d1				;sub Xpos a0 from d1
	cmpi.w	#$19,d1					;compare 19 to difference
	bgt.w	.opploop2				;branch if greater
	cmpi.w	#$FFE7,d1				;compare -19 to diff
	bgt.w	.de1					;branch if greater
.opploop2							;next opponent; none close: look for a pass
	adda.w	#$80,a0					;move to next struct
	dbf	d0,.opploop
	move.w	#1,(threat).l			;dir of threat on puck handler
	bsr.w	chk4pass
	bra.w	.de1
.notpuckc							;d0 <> puckc
	tst.w	temp4(a3)				;check temp4
	bne.w	.de1					;branch if not 0
	tst.w	(puckc).l				;check puckc
	bpl.w	.de1					;branch if there is a puckc
	move.w	(puckx).l,d0
	sub.w	0(a3),d0				;sub Xpos
	cmpi.w	#$14,d0					;compare 14 to diff
	bgt.w	.de1					;branch if greater
	cmpi.w	#$FFEC,d0				;-14
	blt.w	.de1					;branch if less
	move.w	(pucky).l,d1
	cmpi.w	#$108,d1				;check goalline
	bgt.w	.de1					;branch if past goalline
	cmpi.w	#$FEF8,d1				;check other goalline
	blt.w	.de1					;branch if past
	sub.w	Ypos(a3),d1				;sub Ypos from d1
	cmpi.w	#$1E,d1					;compare to 1E
	bgt.w	.de1					;branch if greater
	cmpi.w	#$FFE2,d1				;compare to -1E
	blt.w	.de1					;branch if less
	movem.w	d0-d1,-(sp)
	move.w	(puckvx).l,d0
	bpl.w	.6
	neg.w	d0
.6									;|puckvx|
	move.w	(puckvy).l,d1
	bpl.w	.7
	neg.w	d1
.7									;|puckvy|
	add.w	d1,d0					;add puckvx and vy
	cmpi.w	#$1000,d0				;compare to 1000
	movem.w	(sp)+,d0-d1
	bgt.w	.de1					;branch if greater
	bsr.w	vtoa
	move.w	d0,facedir(a3)			;d0 into facedir. Goalie will face puck
	move.b	#8,nopuck(a3)			;move 8 to nopuck collision
	move.w	#SPAgdive,d1			;goalie dive anim.
	bsr.w	SetSPA					;set animation
	bset.b	#pf2aip,pflags2(a3)		;set anim in progress
	addi.w	#$96,(Crowdlevel).l
	rts
.de1								;not holding the puck: play the shot (puckcross at the goal line)
	movea.l	#$17E36,a0				;puckcross = xcord/frames top to bottom for goalies to react to (CD: the
									;cartridge has #(puckcross-M68K_RAM))
	move.w	#$104,d3
	btst.b	#pfgoal,pflags(a3)		;check what net shooting at
	beq.w	.8						;branch if bottom
;CD: no cartridge twin
	adda.w	#$4,a0
	neg.w	d3
.8									;coordinates for his end
	cmpi.w	#$104,Ypos(a3)
	bgt.w	.9
	cmpi.w	#$FEFC,Ypos(a3)
	bgt.w	.10
.9									;far from the goal line: stand in the crease middle
	clr.w	d2
	clr.w	d0
	cmpi.w	#$2C,0(a3)
	bgt.w	.de5
	cmpi.w	#$FFD4,0(a3)
	blt.w	.de5
	move.w	#$88,d0
	tst.w	0(a3)
	bpl.w	.de5
	neg.w	d0
	bra.w	.de5
.10									;near the goal line: follow the puck
	tst.w	(puckc).l
	bmi.w	.11
	move.w	SCnum(a3),d0
	cmp.w	(puckc).l,d0
	beq.w	.11
	move.l	a0,-(sp)
	movea.l	#SortCords,a0
	move.w	(puckc).l,d0
	asl.w	#7,d0
	adda.w	d0,a0
	move.w	(puckx).l,d0
	sub.w	0(a0),d0
	asr.w	#1,d0
	add.w	0(a0),d0
	move.w	d0,(TmpPuckX).l
	movea.l	(sp)+,a0
.11									;target X set
	move.w	(TmpPuckX).l,d0
	move.w	(pucky).l,d1
	bsr.w	ClampYPosition
	bsr.w	vtoa
	bsr.w	AdjustFacingDirection
	move.w	(gameclock).l,d0
	andi.w	#7,d0
	asl.w	#4,d0
	addi.w	#$A0,d0
	cmpi.w	#$DB,(pucky).l
	bgt.w	.12
	cmpi.w	#$FF25,(pucky).l
	bgt.w	.13
.12									;puck outside the zone
	subi.w	#$40,d0
.13									;d0 = lead time (shorter near the ends): where the puck will be
	move.w	d0,d1
	muls.w	(puckvx).l,d0
	swap	d0
	add.w	(TmpPuckX).l,d0
	muls.w	(puckvy).l,d1
	swap	d1
	add.w	(pucky).l,d1
	bsr.w	ClampYPosition
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	cmpi.l	#$384,d0
	bhi.w	.far
	movem.w	(sp)+,d0-d1
	bra.w	.near
.far								;d0 > $384
	bsr.w	Sroot
	moveq	#1,d2
	add.w	d0,d2
	moveq	#$12,d4
	btst.b	#sfssdir,(sflags).l
	beq.w	.15
	addi.w	#8,d4
.15									;pop the d0-d1 saved above
	movem.w	(sp)+,d0-d1
	muls.w	d4,d1
	addi.w	#8,d4
	muls.w	d4,d0
	divs.w	d2,d0
	divs.w	d2,d1
.near								;target set: d2 = goal line; shootouts skip the next test
	add.w	d3,d1
	move.w	d1,d2
	btst.b	#0,(gmode2).l
	bne.w	.18
	btst.b	#2,(BA_PS_flags).l
	bne.w	.18
	btst.b	#sfssdir,(sflags).l
	beq.w	.18
	cmpi.w	#$D0,(pucky).l
	bgt.w	.17
	cmpi.w	#$FF30,(pucky).l
	blt.w	.17
	bra.w	.18
.17									;puck in front of the net: stay in the crease width
	cmpi.w	#$14,0(a3)
	bgt.w	.18
	cmpi.w	#$FFEC,0(a3)
	blt.w	.18
	btst.b	#1,(gameclock+1).l
	bne.w	.18
	bra.w	.save
.18									;crossing point near enough: try a save
	cmpi.w	#$22,2(a0)
	bhi.w	.de5
	cmpi.w	#$18,(a0)
	bgt.w	.22
	cmpi.w	#$FFE8,(a0)
	blt.w	.22
	cmpi.w	#$C,2(a0)
	bhi.w	.20
.save								;puck inside the goal lines: save attempt (once, pf2aip)
	cmpi.w	#$108,(pucky).l
	bgt.w	.20
	cmpi.w	#$FEF8,(pucky).l
	blt.w	.20
	bset.b	#pf2aip,pflags2(a3)
	bne.w	.20
	jsr	(goaliesave).l
.20									;follow the crossing x along the goal line
	move.w	(a0),d0
	cmpi.w	#$FC,(pucky).l
	bgt.w	.21
	cmpi.w	#$FF04,(pucky).l
	bgt.w	.de5
.21									;puck in the zone
	moveq	#$18,d0
	tst.w	(TmpPuckX).l
	bpl.w	.de5
	neg.w	d0
.de5								;d0/d1 = the spot; turn the goalie toward it
	move.w	d2,d1
	movem.w	d0-d1,-(sp)
	move.b	Xvel(a3),d0
	ext.w	d0
	neg.w	d0
	add.w	(sp)+,d0
	sub.w	0(a3),d0
	move.b	Yvel(a3),d1
	ext.w	d1
	neg.w	d1
	add.w	(sp)+,d1
	sub.w	Ypos(a3),d1
	cmpi.w	#4,d0
	bgt.w	.vt
	cmpi.w	#$FFFC,d0
	blt.w	.vt
	cmpi.w	#4,d1
	bgt.w	.vt
	cmpi.w	#$FFFC,d1
	blt.w	.vt
	clr.w	d0
	clr.w	d1
.vt									;direction to the spot (zero when close)
	bsr.w	vtoa
	move.b	d0,temp2+1(a3)			;move d0 into temp2+1
.nodec								;d2 = wanted direction: accelerate (or stop for 8)
	move.b	temp2+1(a3),d2			;temp2+1
	ext.w	d2
	cmpi.w	#7,d2
	ble.w	playeracc
	bra.w	stopna
.22									;nobody has the puck and no icing: follow it
	tst.w	(puckc).l
	bpl.w	.de5
	btst.b	#ifok,(iflags).l
	bne.w	.de5
	movea.l	#$1834C,a1				;CD: the cartridge has #(tmstruct-M68K_RAM)
	lea	tmsize(a1),a2
	btst.b	#pfteam,pflags(a3)
	beq.w	.23
	exg	a1,a2
.23									;team structs chosen
	cmpi.l	#$1324,tmnear(a1)
	blt.w	.de5
	cmpi.l	#$9C4,tmnear(a2)
	blt.w	.de5
	cmpi.w	#$E0,(pucky).l
	bgt.w	.24
	cmpi.w	#$FF20,(pucky).l
	bgt.w	.de5
.24									;puck past the circles
	tst.w	(puckvy).l
	btst.b	#pfgoal,pflags(a3)
	beq.w	.25
	eori.b	#8,ccr
.25									;puck direction check
	bmi.w	.de5
	move.w	(puckvx).l,d0
	bpl.w	.26
	neg.w	d0
.26									;|puckvx|
	move.w	(puckvy).l,d1
	bpl.w	.27
	neg.w	d1
.27									;|puckvy|
	cmp.w	d0,d1
	blt.w	.de5
	moveq	#$F,d0					;assignment DD2E?
	bra.w	assinsert
ClampYPosition						;d1 = y clamped to +-$103, minus goal line d3. d0 = 0 if a3 has the puck
	move.w	(puckc).l,d2
	cmp.w	SCnum(a3),d2			;is this player the puck carrier?
	bne.w	.0
	clr.w	d0						;carrier: d0 = 0
.0									;d0 cleared when a3 is the carrier
	cmpi.w	#$103,d1				;clamp d1 to the range -$103..$103
	blt.w	.1
	move.w	#$103,d1				;upper limit
.1									;clamp the bottom
	cmpi.w	#$FEFD,d1
	bgt.w	.2
	move.w	#$FEFD,d1
.2									;y clamped: minus the goal line
	sub.w	d3,d1
	rts
AdjustFacingDirection				;Turn facedir one step toward direction d0
	move.w	facedir(a3),d1			;facedir
	sub.w	d1,d0					;d0 = wanted - current
	beq.w	X_31AB6					;CD: the cartridge has rtss2
	neg.w	d0
	andi.w	#4,d0					;bit 2 of (current - wanted) picks the turn sense
	lsr.w	#1,d0
	subi.w	#1,d0					;d0 = +1/-1
	btst.b	#pfjoycon,pflags(a3)	;pfjoycon
	bne.w	.add
	btst	d1,#$42					;facing 1 or 6
	beq.w	.add					;no: plain single step
	add.w	d0,d1					;step once and test the new facing
	btst.b	#pfgoal,pflags(a3)		;pfgoal
	bne.w	.dn
	btst	d1,#$83					;0, 1 or 7
	bra.w	.t
.dn	btst	d1,#$38					;3, 4 or 5
.t	beq.w	.set					;new facing not in the mask: keep the step
	neg.w	d0						;in the mask: undo it and turn the other way instead
	add.w	d0,d1
.add	add.w	d0,d1				;apply the step
.set	andi.w	#7,d1				;wrap to 0-7
	move.w	d1,facedir(a3)			;facedir
	rts
; set save animation for goalie depending on puck location
; a3 = goalie
; a0 = puckcross
; d3 = goalline of goalie
goaliesave							;pick the goalie save for a puck crossing the goal line: a0 = puckcross,
									;d3 = goal line of goalie
	move.w	(a0),d0					;puckcross x frames into d0
	sub.w	0(a3),d0				;sub goalie Xpos from d0
	move.w	d3,d1					;move goalline into d1
	sub.w	Ypos(a3),d1				;sub goalie Ypos from d1
	bsr.w	vtoa
	sub.w	facedir(a3),d0			;sub facedir from d0
	andi.w	#7,d0					;pass first 3 bits of d0
	move.w	d0,d3					;move d0 into d3
	lsr.w	#2,d0					;divide d0 by 4
	btst.b	#3,attribute(a3)
	beq.w	.0
	eori.w	#1,d0
.0									;mirrored for flipped goalies; low or high save by the puck height
	cmpi.w	#8,(puckz).l
	bgt.w	.1
	cmpi.w	#$800,(puckvz).l
	bgt.w	.1
	bra.w	.low
.1									;puckz > 8 or puckvz > $800
	movem.l	d0,-(sp)
	move.w	0(a3),d0
	sub.w	(a0),d0
	cmpi.w	#$10,d0
	bgt.w	.2
	cmpi.w	#$FFF0,d0
	blt.w	.2
	movem.l	(sp)+,d0
	addi.w	#6,d0
	bra.w	.done
.2									;pop the d0 saved above
	movem.l	(sp)+,d0
	bra.w	.done
.low								;low save (entry +4) unless the puck is close
	addi.w	#4,d0
	cmpi.w	#8,2(a0)
	bls.w	.9
	cmpi.w	#2,facedir(a3)
	beq.w	.done
	cmpi.w	#6,facedir(a3)
	beq.w	.done
	tst.w	(puckc).l
	bmi.w	.done
	subi.w	#2,d0
	move.w	d1,-(sp)
	move.w	#$1000,d1
	move.w	d1,Xvel(a3)
	ori.w	#1,d0
	btst.b	#pfgoal,pflags(a3)
	bne.w	.4
	eori.w	#1,d0
.4									;post for his end
	move.w	#$FFFA,d1
	tst.w	Xvel(a3)
	bmi.w	.5
	neg.w	Xvel(a3)
.5									;keep the goalie inside the posts while sliding
	tst.w	0(a3)
	bpl.w	.7
	tst.w	Xvel(a3)
	bpl.w	.6
	neg.w	Xvel(a3)
.6									;other post
	move.w	#6,d1
	eori.w	#1,d0
.7									;post set
	add.w	d1,0(a3)
	btst.b	#0,handed(a3)			;check hand of goalie
	beq.w	.8						;Branch if goalie is Full Right
	eori.w	#1,d0
.8									;glove hand flips the side
	move.w	(sp)+,d1
	bra.w	.done
.9									;puck not straight in: save by side
	movem.l	d0,-(sp)
	move.w	0(a3),d0
	sub.w	(a0),d0
	cmpi.w	#$10,d0
	ble.w	.10
	movem.l	(sp)+,d0
	bra.w	.11
.10									;d0 <= $10
	cmpi.w	#$FFF0,d0
	movem.l	(sp)+,d0
	bgt.w	.done
.11									;high on the far side: entry +4
	addi.w	#4,d0
.done								;d1 = the save animation (glove right/left, stick, ...)
	add.w	d0,d0
	lea	.saveanim(pc),a1
	move.w	(a1,d0.w),d1
	cmpi.w	#SPAgglovel,d1
	bne.w	.13
	andi.w	#3,d3
	beq.w	.13
	cmpi.b	#$B,GGSleft(a3)			;goalie glove save left rating 11 or more?
	blt.w	.13						;branch if less than
	move.w	#SPAgglovel2,d1			;reach out glove save
.13									;start the save animation and excite the crowd
	bsr.w	SetSPA
	addi.w	#$96,(Crowdlevel).l
	addi.w	#$A,(CwdExciteLvl).l
	asr.w	Xvel(a3)
	asr.w	Xvel(a3)
	asr.w	Yvel(a3)
	asr.w	Yvel(a3)
	rts
.saveanim							;SPA per save type. Same 10 words as the
									;unreferenced table in the input code
	dc.w	SPAgglover
	;blocker save
	dc.w	SPAgglovel				;glove save
	dc.w	SPAgstackr				;pad stack right
	dc.w	SPAgstackl				;pad stack left
	dc.w	SPAgstickr				;kick save
	dc.w	SPAgstickl				;blocking butterfly save
	dc.w	SPAghighr				;high shoulder save right
	dc.w	SPAghighl				;high shoulder save left
	dc.w	SPAgstick2r				;stick save right
	dc.w	SPAgstick2l				;stick save left
; assignment to have goalie skate to the puck when it is loose
assgoalietopuck						;goalie skates out to a loose puck (inserted by
									;assgoalie)
	btst.b	#pfjoycon,pflags(a3)	;human controlled goalie: nothing to do
	bne.w	assexit
	btst.b	#gmclock,(gmode).l		;clock stopped: nothing to do
	bne.w	assexit
	bsr.w	check4bench
	bclr.b	#pfna,pflags(a3)		;new assignment? (clears the flag)
	beq.w	.0
	clr.w	temp1(a3)
.0									;count down the timer
	sub.b	d7,temp1(a3)			;count the timer down by d7 (elapsed frames)
	bpl.w	.go						;still running: keep skating to the puck
	move.b	aidef(a3),d0			;aidef
	beq.w	.1
	btst.b	#6,(sflags7).l
	beq.w	.1
	subi.b	#1,d0
.1									;random check
	lsr.b	#2,d0
	move.b	d0,temp1(a3)			;reload timer = defensive rating / 4
	tst.w	(puckc).l
	bpl.w	assexit					;someone has the puck: stay
	tst.w	(puckvy).l				;N = puck y velocity sign
	btst.b	#pfgoal,pflags(a3)
	beq.w	.dir
	eori.b	#8,ccr					;flip N for the other goal end
.dir								;direction for his end
	bmi.w	assexit					;puck moving away from this goalie
	movea.l	#$1834C,a1				;load home team struct into a1 (CD: the cartridge has
									;#(tmstruct-M68K_RAM))
	lea	tmsize(a1),a2				;load away team struct into a2
	btst.b	#pfteam,pflags(a3)		;check if player is home or away
	beq.w	.t0						;branch if home
	exg	a1,a2						;swap if away
.t0									;team structs chosen
	cmpi.l	#$E10,tmnear(a1)		;each team's nearest distance^2 (tmnear) vs limits
	blt.w	assexit
	cmpi.l	#$640,tmnear(a2)
	blt.w	assexit
.go									;puck close enough and both teams far: skate to it
	bra.w	skatetopuck
breakaway							;puck carrier a3 on a breakaway: beep on a new assignment and check the
									;skating direction toward the net
	bset.b	#2,(sflags5).l
	bclr.b	#pfna,pflags(a3)		;pfna - clear new assignment
	beq.w	.nna					;jump if no new assignment
;CD: no cartridge twin
	move.w	#$2,-(sp)
	jsr	(sfx).l
	movem.l	a2,-(sp)				;push a2 on stack
	movea.l	#tmstruct,a2			;move Home Team Struct into a2
	btst.b	#pfteam,pflags(a3)		;pfteam - check if home or away
	beq.w	.c0						;jump if home
	movea.l	#awtmstruct,a2			;move Away Team Struct into a2
.c0									;team struct chosen
	addi.w	#1,tmBreakaways(a2)		;add one to breakaway attempt
	addi.w	#$14,(CwdExciteLvl).l	;add to CwdExcite
	addi.w	#$C8,(Crowdlevel).l		;add to Crowdlevel
	movem.l	(sp)+,a2
.nna								;count down the timer
	movem.w	d1,-(sp)				;push d1 on stack
	move.w	Ypos(a3),d0				;move Ypos into d0
	move.w	Yvel(a3),d1				;move Yvel into d1
	beq.w	.yvel0					;jump if Yvel = 0
	eor.w	d1,d0					;EOR d1 with d0. d0 will be negative if skating opposite direction of net
.exit								;exit: restore the registers
	movem.w	(sp)+,d1				;pop d1 off stack
	rts
.yvel0								;d1 = 0
	move.w	#$FFFF,d1
	bra.w	.exit
BreakawayOffsidesFlagSet			;On a new assignment clear the offsides and breakaway bits of a3. Behind
									;the goal line or not yet in the attack zone set pf3oside, else end the
									;assignment
	btst.b	#pfna,pflags(a3)		;check for new assignment
	beq.w	.loadYpos				;branch if no new assignment
	bclr.b	#pf3oside,pflags3(a3)	;clear player offsides flag
	bclr.b	#pf3break,pflags3(a3)	;clear player breakaway flag
.loadYpos							;load Ypos
	movem.w	d0-d1/a0,-(sp)
	move.w	#$108,d0				;108 = top goal line Y pos
	move.w	Ypos(a3),d1				;Ypos
	bpl.w	.cmpgoalline			;branch if Ypos is positive
	neg.w	d1						;negate d1
.cmpgoalline						;|Ypos|
	cmp.w	d0,d1					;compare position to top goal line
	bge.w	.nogood					;Branch if above it
	move.w	#$58,d0					;58 = top blue line Y pos
	move.w	Ypos(a3),d1				;Ypos
	btst.b	#pfgoal,pflags(a3)		;check goal to shoot on (0=bottom, 1=top)
	bne.w	.top					;branch if top goal
	neg.w	d0						;bottom goal, so negate d0
	cmp.w	d1,d0					;compare Ypos to blue line Y
	blt.w	.setoffside				;branch if not in attack zone
	bra.w	.offzone				;branch if in attack zone
.top								;pfgoal set
	cmp.w	d1,d0					;compare Ypos to blue line Y
	blt.w	.offzone				;branch if in offensive zone
.setoffside							;set offside
	bset.b	#pf3oside,pflags3(a3)	;set offsides flag
	bra.w	.nogood
.offzone							;carrier not offside: check for defenders ahead
	bclr.b	#pf3oside,pflags3(a3)	;clear offside bit
	beq.w	.nogood					;branch if on the blue line
	movea.l	#SortCords+(11*SCstruct),a0	;loads last SCScruct player struct (Away pos #6)
	move.w	#$B,d0					;B = # of player structs to check (12)
	tst.w	d1						;checks if d1 is negative (determines what zone to check)
	bmi.w	.checkYpos
.checkYpos2							;loop: any skater of the other team ahead of the carrier (top end)?
	cmp.w	Ypos(a0),d1				;compare Ypos of a0 player to d1 (Ypos puckc)
	bge.w	.substruct2				;branch if d1 greater than or equal
	tst.w	position(a0)			;check if goalie
	beq.w	.substruct2				;branch if goalie
	bra.w	.nogood
.substruct2							;next player
	suba.w	#$80,a0
	dbf	d0,.checkYpos2
.setBAbit							;loop
	bset.b	#pf3break,pflags3(a3)	;set breakaway bit
	move.w	#1,d0					;moves 1 into d0 (used by returned subroutine)
.exit								;exit: restore the registers
	movem.w	(sp)+,d0-d1/a0
	rts
.nogood								;not a breakaway: d0 = 0
	move.w	#0,d0					;move 0 into d0 (used on return to subroutine)
	bra.w	.exit
.checkYpos							;d1 negative
	cmp.w	Ypos(a0),d1				;check Ypos with d1 (d1 = blue line Y)
	ble.w	.substruct
	tst.w	position(a0)			;checks if goalie (who would be below blue line)
	beq.w	.substruct
	bra.w	.nogood
.substruct							;next player (bottom end)
	suba.w	#$80,a0					;subtract SCstruct size (80 hex)
	dbf	d0,.checkYpos
	bra.w	.setBAbit
chkpuckc							;puck carrier a3: check for a breakaway (not in a shootout or penalty
									;shot), else assign asspuckc
	btst.b	#0,(gmode2).l
	bne.w	.0
	btst.b	#2,(BA_PS_flags).l
	bne.w	.0
	bsr.w	breakaway
	bpl.w	asspuckc				;currently skating towards net in Y
.0									;penalty shot / shootout path
	bclr.b	#pf3break,pflags3(a3)	;clear breakaway bit
	move.w	#$10,d0					;asspuckc
	bsr.w	assreplace
asspuckc							;player a3 is puck handler
	bclr.b	#2,(sflags5).l
	bne.w	.0
	bclr.b	#pf3break,pflags3(a3)
.0									;check the message timer
	move.w	(puckc).l,d0
	cmp.w	SCnum(a3),d0
	bne.w	assexit
	btst.b	#2,(BA_PS_flags).l
	beq.w	.1
	cmpi.w	#1,(msgtimer).l
	bgt.w	.x
.1									;breakaway check
	btst.b	#pf3break,pflags3(a3)
	bne.w	.2
	btst.b	#2,(BA_PS_flags).l
	bne.w	.2
	jsr	(BreakawayOffsidesFlagSet).l
	beq.w	.2						;branch if breakaway flag not set
	move.w	#$21,d0					;chkpuckc assignment
	bsr.w	assreplace
	bra.w	.2
.2									;no breakaway: normal puck carrier play
	btst.b	#pfalock,pflags(a3)
	bne.w	.x						;CD: the cartridge has rtss2
	btst.b	#2,(BA_PS_flags).l
	bne.w	.3
	btst.b	#gmclock,(gmode).l
	bne.w	donothing
.3									;breakaway check
	btst.b	#pfjoycon,pflags(a3)
	bne.w	assexit
	bclr.b	#pfna,pflags(a3)
	beq.w	.7
	btst.b	#pf3break,pflags3(a3)
	beq.w	.4
;CD: no cartridge twin
	move.w	#$2,-(sp)
	jsr	(sfx).l
.4									;breakaway crowd
	btst.b	#pf3break,pflags3(a3)
	beq.w	.6
	movem.l	a2,-(sp)
	movea.l	#tmstruct,a2
	btst.b	#pfteam,pflags(a3)
	beq.w	.5
	movea.l	#awtmstruct,a2
.5									;team struct chosen
	addi.w	#1,tmBreakaways(a2)
	addi.w	#$14,(CwdExciteLvl).l
	addi.w	#$C8,(Crowdlevel).l
	movem.l	(sp)+,a2
.6									;breakaway check done
	clr.w	temp1(a3)
	move.w	#8,temp2(a3)
;CD: no cartridge twin
.L3353C
	btst.b	#$7,$FF800E.l
	bne.s	.L3353C
	move.w	#$1B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L33556
	btst.b	#$6,$FF800E.l
	beq.s	.L33556
	move.w	$FF8010.l,d0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L33576
	btst.b	#$6,$FF800E.l
	bne.s	.L33576
	bclr.b	#$7,$FF800F.l
	andi.w	#3,d0
	move.w	d0,temp3(a3)
.7									;count down the timer
	sub.b	d7,temp1(a3)
	bpl.w	.nodec
	move.b	aioff(a3),temp1(a3)
	jsr	(ReadGoaliePulled).l
	bmi.w	.8
	btst.b	#6,(sflags7).l
	beq.w	.9
	tst.b	temp1(a3)
	beq.w	.9
.8									;goalie pulled or crowd meter broken: quicker decisions
	subi.b	#1,temp1(a3)
.9									;shootout or penalty shot: the shootout shot check
	btst.b	#2,(BA_PS_flags).l
	bne.w	.soshot
	btst.b	#0,(gmode2).l
	bne.w	.soshot
	bsr.w	checkob
	bsr.w	chk4lc
	btst.b	#0,(gmode2).l
	bne.w	.soshot
	btst.b	#2,(BA_PS_flags).l
	bne.w	.soshot
	btst.b	#pf3break,pflags3(a3)
	bne.w	.shot
	move.w	#1,d0
	btst.b	#pfteam,pflags(a3)
	beq.w	.10
	move.w	#2,d0
.10									;team pad chosen
	cmp.w	(cont1team).l,d0
	beq.w	.shot
	cmp.w	(cont2team).l,d0
	beq.w	.shot
	btst.b	#1,(Vcount+1).l
	bne.w	.pass
.shot								;shoot check (on a computer pad, every other frame)
	bsr.w	chk4shot
	bra.w	.pass
.soshot								;bit 2 of BA_PS_flags set or bit 0 of gmode2 set
	jsr	(ShootoutShootCheck).l
	bne.w	.nodec
	jsr	(CompShoot).l
.pass								;then the pass check
	bsr.w	chk4pass
.nodec								;skate on toward the target spot (.postab2)
	moveq	#6,d0
	add.w	temp3(a3),d0			;add temp3 to d0
	lea	.postab2(pc),a0
	btst.b	#sf2offsig,(sflags2).l	;#sf2offsig
	beq.w	.nd1
	move.w	position(a3),d0			;position
.nd1								;position for the offside check
	asl.w	#2,d0
	move.w	$2(a0,d0.w),d1
	move.w	(a0,d0.w),d0
	btst.b	#2,(BA_PS_flags).l
	bne.w	.path
	btst.b	#0,(gmode2).l
	beq.w	.15
.path								;skate the shootout path
	jsr	(SkatePath).l
	cmpi.b	#$80,(sopathx).l
	beq.w	.x
.15									;normal skating
	btst.b	#pfgoal,pflags(a3)		;pfgoal - 0 for bottom 1 for top
	bne.w	.nd0
	neg.w	d0
	neg.w	d1
.nd0								;coordinates for his end
	lea	.chkdir(pc),a0
	btst.b	#2,(BA_PS_flags).l
	bne.w	.16
	btst.b	#0,(gmode2).l
	beq.w	.17
.16									;shootout or penalty shot: path done
	lea	.x(pc),a0
.17									;skate the path
	bra.w	skateto
.chkdir								;d0 = wanted direction: look for opponents in the way
	ext.w	d0
	move.b	Xvel(a3),d2				;Xvel
	ext.w	d2
	add.w	(puckx).l,d2
	move.b	Yvel(a3),d3				;Yvel
	ext.w	d3
	add.w	(pucky).l,d3
	clr.w	(threat).l
	moveq	#5,d4
	movea.l	#$17480,a0				;CD: the cartridge has #(SortCords-M68K_RAM)
	cmpi.w	#6,SCnum(a3)
	bge.w	.loop
	adda.w	#6*SCstruct,a0			;away team SCstruct start
.loop								;loop over the opponents
	move.b	Xvel(a0),d1				;Xvel
	ext.w	d1
	add.w	0(a0),d1				;Xpos
	sub.w	d2,d1
	cmpi.w	#$14,d1
	bgt.w	.next
	cmpi.w	#$FFEC,d1
	blt.w	.next
	move.b	Yvel(a0),d1				;Yvel
	ext.w	d1
	add.w	Ypos(a0),d1				;Ypos
	sub.w	d3,d1
	cmpi.w	#$14,d1
	bgt.w	.next
	cmpi.w	#$FFEC,d1
	blt.w	.next
	addi.w	#1,(threat).l
	move.w	0(a3),d0				;Xpos
	sub.w	0(a0),d0
	move.w	Ypos(a3),d1				;Ypos
	sub.w	Ypos(a0),d1
	bsr.w	vtoa
	move.w	facedir(a3),d1			;facedir
	eori.w	#4,d1
	cmp.w	d0,d1
	bne.w	.next
;CD: no cartridge twin
.L3376A
	btst.b	#$7,$FF800E.l
	bne.s	.L3376A
	move.w	#$1B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L33784
	btst.b	#$6,$FF800E.l
	beq.s	.L33784
	move.w	$FF8010.l,d1
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L337A4
	btst.b	#$6,$FF800E.l
	bne.s	.L337A4
	bclr.b	#$7,$FF800F.l
	andi.w	#1,d1
	add.w	d1,d0
	andi.w	#7,d0
.next								;next opponent
	adda.w	#SCstruct,a0			;SCstruct size
	dbf	d4,.loop
.x									;exit (also the end of the code above)
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
chk4lc								;see if computer should call line change
	btst.b	#4,(sflags7).l
	bne.w	.L338B4					;CD: the cartridge has rtss2
	move.w	(pucky).l,d0
	btst.b	#pfgoal,pflags(a3)
	bne.w	.0
	neg.w	d0
.0									;coordinates for his end
	tst.w	d0
	bmi.w	X_31AB6					;CD: the cartridge has rtss2
	cmpi.w	#$58,d0
	bgt.w	X_31AB6					;CD: the cartridge has rtss2
;CD: no cartridge twin
.L3381E
	btst.b	#$7,$FF800E.l
	bne.s	.L3381E
	move.w	#$1B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L33838
	btst.b	#$6,$FF800E.l
	beq.s	.L33838
	move.w	$FF8010.l,d0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L33858
	btst.b	#$6,$FF800E.l
	bne.s	.L33858
	bclr.b	#$7,$FF800F.l
	andi.w	#3,d0
	bne.w	X_31AB6					;CD: the cartridge has rtss2
	btst.b	#pf2lcm,pflags2(a3)
	bne.w	X_31AB6					;CD: the cartridge has rtss2
	movea.l	#$1834C,a2				;a2 = own team struct, a1 = the other one (CD: the cartridge has
									;#(tmstruct-M68K_RAM))
	lea	tmsize(a2),a1
	btst.b	#pfteam,pflags(a3)
	beq.w	.1
;CD: no cartridge twin
	exg	a1,a2
.1									;CD: placed where the disc branches to it
	jsr	(AvgCline).l
	cmpi.w	#$C00,d0
	bhi.w	X_31AB6					;CD: the cartridge has rtss2
	bsr.w	CompLine				;pick and apply the new line
;CD: no cartridge twin
	jsr	(setpersonel).l
	jsr	(printscores1).l
	bra.w	CompShoot
.L338B4
	rts
; return z flag set if killing penalty
; return z flag clr if not
chkpk								;return z flag set if killing penalty
									;return z flag clr if not
	btst.b	#sf2pwrplay,(sflags2).l	;#sf2pwrplay - check if power play in progress
	bne.w	chkpk2
	eori.b	#4,ccr					;Z flag
	rts
chkpk2								;return z flag set if a3's team is the one on the power play (sf2pwrtm
									;against pfteam)
	movem.l	d0-d1,-(sp)
	btst.b	#sf2pwrtm,(sflags2).l	;#sf2pwrtm - 0 for team 1, 1 for team 2
	move.w	sr,d0
	btst.b	#pfteam,pflags(a3)		;pfteam - 0 home, 1 away
	move.w	sr,d1
	eor.w	d1,d0
	move.w	d0,ccr
	movem.l	(sp)+,d0-d1
	rts
; player a3 looks for shot (computer controlled)
chk4shot							;player a3 looks for shot (computer controlled)
									;decide whether the computer carrier shoots; rtss = no shot, else falls to
									;CompShoot
	bsr.w	chkpk
	bne.w	.pkill					;killing penalty
	tst.w	(threat).l
	beq.w	.pkill					;no threat
;CD: no cartridge twin
.L338FA
	btst.b	#$7,$FF800E.l
	bne.s	.L338FA
	move.w	#$1B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L33914
	btst.b	#$6,$FF800E.l
	beq.s	.L33914
	move.w	$FF8010.l,d0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L33934
	btst.b	#$6,$FF800E.l
	bne.s	.L33934
	bclr.b	#$7,$FF800F.l
	andi.w	#3,d0
	bne.w	.pkill
	move.w	#$58,d0					;top blue line Y position
	btst.b	#pfgoal,pflags(a3)
	beq.w	.cmphome
	move.w	#$FFA8,d0				;bottom blue line Y pos
	cmp.w	Ypos(a3),d0
	blt.w	CompShoot				;clear puck
	bra.w	.0
.cmphome							;pfgoal clear
	cmp.w	Ypos(a3),d0
	bgt.w	CompShoot				;clear puck
.0									;clear the puck: pass straight ahead
	bset.b	#3,(sflags5).l
	jmp	(dopass).l
	dc.b	$60						;`
	dc.b	0,1
;CD: no cartridge twin
	dc.b	$44
.pkill								;penalty kill: shoot it out on a breakaway roll
	btst.b	#pf3break,pflags3(a3)
	beq.w	.npk
	move.w	#$1E,d0
	jsr	(randomd0).l
	addi.w	#$82,d0
	cmp.w	(pucky).l,d0
	blt.w	.1
	neg.w	d0
	cmp.w	(pucky).l,d0
	bgt.w	.1
	bra.w	.npk
.1									;d0 < pucky or d0 > pucky
	move.w	#2,d0
	jsr	(randomd0s).l
	add.w	facedir(a3),d0
	andi.w	#7,d0
	move.w	d0,facedir(a3)
	bra.w	CompShoot
.npk								;d4 = shot range from the shot odds (spodds)
	moveq	#$20,d4
	clr.w	d1
	move.b	spodds(a3),d1
	lsr.w	#1,d1
	sub.b	d1,d4
	asl.w	#4,d4
	move.w	#$108,d1				;top goal line Y
	btst.b	#pfgoal,pflags(a3)
	bne.w	.c0
	neg.w	d1
.c0									;Y for his end
	sub.w	(pucky).l,d1			;d1 = y distance to the goal line, d0 = x distance to center
	move.w	(puckx).l,d0
	neg.w	d0
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d0,d1					;distance from goal squared
	cmpi.l	#$2710,d1
	movem.w	(sp)+,d0-d1
	bhi.w	.no1					;farther than 100 from the goal: keep d4 as is
	lsr.w	#4,d4					;close: d4 = $20 - odds
	bsr.w	vtoa					;d0 = direction to the goal
	move.w	d0,d5					;d5 = shot direction
	moveq	#5,d3					;check the 6 opposing sort objects
	movea.l	#$17480,a1				;CD: the cartridge has #(SortCords-M68K_RAM)
	cmpi.w	#6,SCnum(a3)
	bge.w	.loop
	adda.w	#6*SCstruct,a1
.loop								;loop over the opponents: defenders in the shot line make the range bigger
	tst.w	position(a1)
	beq.w	.2
	move.w	0(a1),d0				;direction from puck to this skater
	sub.w	(puckx).l,d0
	move.w	Ypos(a1),d1
	sub.w	(pucky).l,d1
	bsr.w	vtoa
	cmp.w	d5,d0
	bne.w	.co1
	asl.w	#1,d4					;defender in the shot line
	bra.w	.co1
.2									;goalie: shoot now if he is busy
	btst.b	#pf2aip,pflags2(a1)		;goalie busy, shoot now
	beq.w	.co1
	clr.w	d3						;end the loop after this object
	moveq	#1,d4					;tiny range: shot is almost certain
.co1								;next opponent
	adda.w	#SCstruct,a1
	dbf	d3,.loop
.no1								;roll against the range
	move.w	d4,d0
	bsr.w	randomd0
	btst.b	#0,spodds(a3)
	beq.w	.3
	cmpi.w	#7,d0
	bgt.w	X_31AB6					;CD: the cartridge has rtss2
	bra.w	.4
.3									;odd spodds: a roll of 7 or less shoots; even: 8 or less
	cmpi.w	#8,d0
	bgt.w	X_31AB6					;CD: the cartridge has rtss2
.4									;shoot only from inside the shooting distance
	move.w	(pucky).l,d0
	btst.b	#pfgoal,pflags(a3)
	bne.w	.ds0
	neg.w	d0
.ds0								;coordinates for his end
	tst.w	d0
	bmi.w	X_31AB6					;CD: the cartridge has rtss2
	move.w	#$108,d1
	sub.w	d0,d1
	bmi.w	X_31AB6					;CD: the cartridge has rtss2
	btst.b	#sf2offsig,(sflags2).l
	bne.w	X_31AB6					;CD: the cartridge has rtss2
;CD: no cartridge twin
CompShoot							;CD: placed where the disc branches to it
	adda.w	#$4,sp
	move.w	(pucky).l,d0
	btst.b	#pfgoal,pflags(a3)
	bne.w	.ds0
	neg.w	d0
.ds0								;coordinates for his end
	move.w	#$108,d1				;d0 is now puck y toward the goal I shoot at
	sub.w	d0,d1					;d1 = distance to $108 along the shooting direction
	lsr.w	#3,d1
	cmpi.w	#$14,d1
	blt.w	.0
	moveq	#$14,d1
.0									;d1 clamped
	move.w	d1,temp2(a3)
	moveq	#$12,d0					;assshoot
	bra.w	assreplace
chk4pass							;player a3 looks for good pass (computer controlled)
	tst.w	(threat).l
	bne.w	.dp0					;an opponent is close: always consider a pass
	moveq	#$10,d0
	add.b	spodds(a3),d0
	bsr.w	randomd0				;0 <= d0 < $10 + odds
	cmpi.w	#$C,d0
	bgt.w	X_31AB6					;CD: the cartridge has rtss2
.dp0								;threat check passed
	moveq	#6,d0					;Set up pass assignment
	bsr.w	randomd0				;d0 = random teammate index 0-5
	cmpi.w	#6,SCnum(a3)
	blt.w	.0
	addi.w	#6,d0
.0									;d0 = random teammate on a3's team
	tst.w	position(a3)
	beq.w	.1
	cmpi.w	#$28,(puckx).l
	bgt.w	.1
	cmpi.w	#$FFD8,(puckx).l
	blt.w	.1
	cmpi.w	#$CC,(pucky).l
	bgt.w	X_31AB6					;CD: the cartridge has rtss2
	cmpi.w	#$FF34,(pucky).l
	blt.w	X_31AB6					;CD: the cartridge has rtss2
.1									;not to himself
	cmp.w	SCnum(a3),d0
	beq.w	X_31AB6					;CD: the cartridge has rtss2
	asl.w	#7,d0					;d0 * SCstruct ($80)
	movea.l	#$17480,a0				;CD: the cartridge has #(SortCords-M68K_RAM)
	adda.w	d0,a0					;a0 = receiver sort object
	tst.w	position(a0)
	ble.w	X_31AB6					;CD: the cartridge has rtss2
	btst.b	#pf2unav,pflags2(a0)
	bne.w	X_31AB6					;CD: the cartridge has rtss2
	btst.b	#pfalock,pflags(a0)
	bne.w	X_31AB6					;CD: the cartridge has rtss2
	move.w	Ypos(a0),d0				;check for pass across blue line
	move.w	Ypos(a3),d1				;d0 = receiver y, d1 = my y (toward the goal I shoot at)
	btst.b	#pfgoal,pflags(a3)
	bne.w	.f0
	neg.w	d0
	neg.w	d1
.f0									;coordinates for his end
	btst.b	#gmoffs,(gmode).l		;offsides on?
	beq.w	.oko
	movem.w	d0-d1,-(sp)
	subi.w	#$58,d0					;y relative to the blue line
	subi.w	#$58,d1
	eor.w	d0,d1					;sign differs if the pass crosses the blue line
	movem.w	(sp)+,d0-d1
	bmi.w	X_31AB6					;CD: the cartridge has rtss2
.oko								;not across the blue line
	cmpi.w	#$58,d0
	bgt.w	.ok
	sub.w	d1,d0
	cmpi.w	#$FFF1,d0
	blt.w	X_31AB6					;CD: the cartridge has rtss2
.ok									;pass is safe
	move.w	0(a0),d0				;receiver accepted: get the pass direction
	sub.w	(puckx).l,d0
	move.w	Ypos(a0),d1
	sub.w	(pucky).l,d1
	movem.w	d0-d1,-(sp)
	bsr.w	vtoa					;direction puck -> receiver
	move.w	d0,(passdir).l
	movem.w	(sp)+,d1-d2
	muls.w	d1,d1
	muls.w	d2,d2
	add.l	d1,d2					;d2 = squared distance to the receiver
	moveq	#5,d3
	movea.l	#$17480,a1				;CD: the cartridge has #(SortCords-M68K_RAM)
	cmpi.w	#6,SCnum(a3)
	bge.w	.co0
	adda.w	#6*SCstruct,a1			;loop over the 6 opponents
.co0								;loop over the 6 opponents: anyone in the pass lane?
	move.w	0(a1),d0				;next opponent: is he in the pass lane?
	sub.w	(puckx).l,d0
	move.w	Ypos(a1),d1
	sub.w	(pucky).l,d1
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d0,d1					;d1 = squared distance to this opponent
	cmp.l	d2,d1
	movem.w	(sp)+,d0-d1
	bhi.w	.co1					;farther than the receiver: ignore
	bsr.w	vtoa
	cmp.w	(passdir).l,d0
	beq.w	X_31AB6					;CD: the cartridge has rtss2
.co1								;next opponent
	adda.w	#SCstruct,a1			;next opponent
	dbf	d3,.co0
	bsr.w	dopass					;lane is clear: pass in passdir
	tst.w	position(a3)
	beq.w	X_31AB6					;CD: the cartridge has rtss2
;CD: no cartridge twin
	adda.w	#$4,sp
	bra.w	assexit
; player a3 should avoid the puck carrier if he's on their team
EvadePC								;player a3 should avoid the puck carrier if he's on my team out: d0 =
									;direction 0-7 pointing away from the puck (from vtoa), adjusted near the
									;blue line
	tst.w	(puckc).l
	bmi.w	X_31AB6					;no puck carrier (CD: the cartridge has rtss2)
	move.b	Xvel(a3),d2				;Xvel
	sub.b	(puckvx).l,d2			;sub puckvx from Xvel
	ext.w	d2
	add.w	0(a3),d2				;add Xpos
	sub.w	(puckx).l,d2			;Sub puckx
	cmpi.w	#$28,d2					;compare to 40 decimal
	bgt.w	X_31AB6					;exit if greater than 40 (CD: the cartridge has rtss2)
	cmpi.w	#$FFD8,d2				;compare to -40
	blt.w	X_31AB6					;exit if less than -40 (CD: the cartridge has rtss2)
	move.b	Yvel(a3),d1				;Yvel
	sub.b	(puckvy).l,d1			;sub puckvy from Yvel
	ext.w	d1
	add.w	Ypos(a3),d1				;add Ypos to d1
	sub.w	(pucky).l,d1			;Sub pucky
	cmpi.w	#$28,d1					;compare to 40 dec
	bgt.w	X_31AB6					;exit if greater than (CD: the cartridge has rtss2)
	cmpi.w	#$FFD8,d1				;compare to -40 dec
	blt.w	X_31AB6					;exit if less than (CD: the cartridge has rtss2)
	move.w	0(a3),d0				;Xpos
	sub.w	(puckx).l,d0			;Sub puckx from Xpos
	move.w	Ypos(a3),d1				;Ypos
	sub.w	(pucky).l,d1			;Sub pucky from Ypos
	bsr.w	vtoa					;find direction and convert to 0-7
	btst.b	#gmoffs,(gmode).l		;check if offsides is on
	beq.w	.ex						;exit if not
	move.w	Ypos(a3),d1				;Ypos
	btst.b	#pfgoal,pflags(a3)		;check what net shooting at
	bne.w	.0						;branch if top
	neg.w	d1						;negate d1 (Ypos)
.0									;Y for his end
	subi.w	#$58,d1					;sub 88 from Ypos (top blue line)
	cmpi.w	#$A,d1					;compare to 10 decimal
	bgt.w	.ex						;exit if greater
	cmpi.w	#-50,d1
	blt.w	.ex						;branch if less than
	moveq	#2,d0					;near the blue line: go sideways, d0 = 2 if x > puck x...
	move.w	0(a3),d1				;Xpos
	cmp.w	(puckx).l,d1			;compare puckx with Ypos difference
	bgt.w	.ex						;exit if greater
	moveq	#6,d0
.ex									;exit (also the end of the code above)
	rts
;	Late routines of the logic code: offsides, the puck state routines, skating and acceleration.
;	The penalty shot and faceoff code sit among the assignment routines.
;
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp /
;	cmpi; fixopcodes.js patches the cmp encoding after assembly.

;SortCords offsets: Xpos 0, Ypos $14, Xvel $28, Yvel $2A, position $34, assnum $36, temp1 $40,
;temp3 $44, temp4 $46, SCnum $52, facedir $54, SPA $58, pflags $62, pflags2 $63.

checkob								;bring up little warning ref if a player on your team is over blue line
	btst.b	#gmoffs,(gmode).l
	beq.w	X_31AB6					;CD: the cartridge has rtss2
	btst.b	#2,(BA_PS_flags).l
	bne.w	.L33D94					;CD: the cartridge has rtss2
	movem.l	d0-d1/a0,-(sp)
	moveq	#5,d0					;6 players of a3's team
	movea.l	#$17480,a0				;CD: the cartridge has #(SortCords-M68K_RAM)
	cmpi.w	#6,SCnum(a3)
	blt.w	.0
	adda.w	#6*SCstruct,a0			;a0 = first sort object of a3's team
.0									;d1 = the blue line for the net a3 shoots at
	moveq	#$5C,d1
	btst.b	#pfgoal,pflags(a3)
	bne.w	.top					;shooting at the top goal: mirrored tests below
	neg.w	d1						;d1 = -$5C
	cmp.w	(pucky).l,d1
	bgt.w	.nob					;puck already across the line: nobody can be offside
.bottom								;loop: any player over the blue line (bottom end)?
	tst.w	position(a0)			;loop over the team, skipping negative positions
	bmi.w	.bn
	cmp.w	Ypos(a0),d1
	bgt.w	.ob						;this player is over the line
.bn									;next player
	adda.w	#SCstruct,a0
	dbf	d0,.bottom
.nob								;next player down
	moveq	#$40,d0					;no one offside: d0 = $40 = clear the ref window (PushRef)
	bclr.b	#sf2offsig,(sflags2).l	;clear the offsides ref flag
	bne.w	.dref					;it was on: update the ref
.ex									;exit: restore the registers
	movem.l	(sp)+,d0-d1/a0
.L33D94
	rts
.ob									;offside: show the little ref once
	moveq	#6,d0
	bset.b	#sf2offsig,(sflags2).l	;someone is offsides: show the little ref
	bne.w	.ex						;already shown
.dref								;show the little ref
	tst.w	(RefCnt).l				;only when the ref queue is idle (negative)
	bpl.w	.ex
	bsr.w	PushRef
	bra.w	.ex
.top								;pfgoal set
	cmp.w	(pucky).l,d1
	blt.w	.nob
.top1								;loop: any player over the blue line (top end)?
	tst.w	position(a0)			;loop over the team's players (top goal)
	bmi.w	.tn
	cmp.w	Ypos(a0),d1
	blt.w	.ob
.tn									;next player
	adda.w	#SCstruct,a0			;next player
	dbf	d0,.top1
	bra.w	.nob
; assignment for breakaway
assbreakaway						;assignment for a breakaway: the puck carrier skates in, anyone else goes
									;back to assnearest
	move.w	SCnum(a3),d0			;Move SCnum into d0
	cmp.w	(puckc).l,d0			;compare puck carrier SCnum with d0
	beq.w	.puckc					;branch if puck carrier
.notpuckc							;loop
	bclr.b	#pf3break,pflags3(a3)	;clear breakaway bit
	move.w	#$11,d0					;11 - assnearest
	bsr.w	assreplace
	bra.w	assnearest
.puckc								;d0 = puckc
	jsr	(breakaway).l
	bmi.w	.notpuckc
; this is a special assignment used for the player who is nearest the puck but doesn't have it
assnearest							;this is a special assignment used for the player who is nearest the puck
									;but doesn't have it. Assignment anearest ($11)
									;a2 = a3's team struct, d7 = elapsed frames. temp1 = re-evaluation timer,
									;temp3 = hold timer
	bclr.b	#2,(sflags5).l
	bne.w	.chkpuck
	bclr.b	#pf3break,pflags3(a3)	;clear breakaway bit
.chkpuck							;check the puck
	move.w	SCnum(a3),d0			;move SCnum into d0
	cmp.w	(puckc).l,d0			;compare with puck carrier SCnum
	bne.w	.chkbreak				;jump if not puck carrier
	btst.b	#pf3break,pflags3(a3)	;check breakaway bit
	bne.w	.chkbreak				;jump if set
	btst.b	#2,(BA_PS_flags).l		;check if bit 2 set (cleared on Faceoffs)
	bne.w	.chkbreak				;jump if set
	jsr	(BreakawayOffsidesFlagSet).l
	beq.w	.chkbreak
	move.w	#$22,d0					;22 - assbreakaway if flag set
	bsr.w	assreplace				;assreplace with assbreakaway
	bra.w	.chkbreak
.chkbreak							;assnearest: breakaway carriers switch to assbreakaway
	bclr.b	#pfna,pflags(a3)		;pfna - clear new assignment
	beq.w	.nna
	btst.b	#pf3break,pflags3(a3)	;check if breakaway
	beq.w	.chkbreak2				;jump if not
;CD: no cartridge twin
	move.w	#$2,-(sp)
	jsr	(sfx).l
.chkbreak2							;breakaway crowd
	btst.b	#pf3break,pflags3(a3)	;check if breakaway
	beq.w	.nobreak				;jump if not
	movem.l	a2,-(sp)				;push a2 to stack
	movea.l	#tmstruct,a2			;put Home Team Struct into a2
	btst.b	#pfteam,pflags(a3)		;pfteam - check home or away
	beq.w	.addcrowd				;jump if home
	movea.l	#awtmstruct,a2			;put Away Team Struct into a2
.addcrowd							;team struct chosen
	addi.w	#1,tmBreakaways(a2)		;add to breakaway attempt
	addi.w	#$14,(CwdExciteLvl).l	;add to excite level
	addi.w	#$C8,(Crowdlevel).l		;add to crowd level
	movem.l	(sp)+,a2				;pop off stack into a2
.nobreak							;breakaway check done
	clr.w	temp3(a3)				;clear temp3
	move.w	#8,temp2(a3)			;move 8 into temp2
	clr.w	temp1(a3)				;clear temp1
.nna								;count down the timer
	move.w	SCnum(a3),d1			;checks if puck carrier
	cmp.w	(puckc).l,d1
	bne.w	.nopc					;jumps if not
	tst.w	position(a3)			;check if goalie
	beq.w	assgoalie				;branch if goalie
	moveq	#$10,d0					;10 = asspuckc
	btst.b	#pfjoycon,pflags(a3)	;pfjoycon - check if controlled
	beq.w	assinsert				;jump if not
	rts								;human controlled: leave as is
.nopc								;d1 <> puckc
	sub.b	d7,temp1(a3)			;subtract d7 (elapsed frames) from temp1
	bpl.w	.nodec					;jump if positive
	move.b	aioff(a3),temp1(a3)		;move aioff into temp1
	jsr	(ReadGoaliePulled).l		;check if goalie is pulled
	bmi.w	.bonus
	btst.b	#6,(sflags7).l			;check if crowd meter currently broken
	beq.w	.nopc2					;jump if not broken
	tst.b	temp1(a3)				;check if temp1 is 0
	beq.w	.nopc2					;jump if so
.bonus								;goalie pulled or crowd meter broken: quicker reactions
	subi.b	#1,temp1(a3)			;subtract 1 from temp1
.nopc2								;puck carrier in the slot: count it for the right team
	btst.b	#5,(sflags6).l			;check if slot bit is set (puckc in slot)
	beq.w	.nopc3					;branch if not set
	move.w	(puckc).l,d1			;move puck carrier SCnum
	cmpi.w	#5,d1					;check if its home (5 or less) or away (6-11)
	bgt.w	.pcaway					;jump if away
	btst.b	#pfteam,pflags(a3)		;pfteam
	beq.w	.nopc3					;jump if home
.tmnopc								;loop
	move.b	temp1(a3),d1			;temp1 into d1
	ext.w	d1						;extend d1
	asr.w	#1,d1					;divide by 2
	move.b	d1,temp1(a3)			;move d1 into temp1 - cutting the timer in half
	bne.w	.nopc3					;jump if not zero
	move.b	#1,temp1(a3)			;move 1 into temp1
	bra.w	.nopc3
.pcaway								;d1 > 5
	btst.b	#pfteam,pflags(a3)		;pfteam - 0 home, 1 away
	beq.w	.tmnopc					;jump if home
.nopc3								;find our skater nearest the puck
	clr.l	tmnear(a2)				;no nearest skater yet
	move.w	(puckc).l,d1			;move puck carrier SCnum into d1
	bmi.w	.np						;branch if no puck carrier
	asl.w	#scsize,d1				;scsize
	movea.l	#$17480,a1				;Move SortCords into a1 (CD: the cartridge has #(SortCords-M68K_RAM))
	adda.w	d1,a1					;use d1 as offset
	move.b	pflags(a1),d0			;pflags of puck carrier
	move.b	pflags(a3),d1			;pflags of current player
	eor.b	d0,d1					;XOR pflags
	btst	#pfteam,d1				;check pfteam
	beq.w	.switch					;branch if on same team
.np									;not the carrier
	moveq	#-1,d2					;-1
	moveq	#5,d4					;5 = # of players on team
;CD: no cartridge twin
	movea.l	$22(a2),a0
.de0								;loop over our skaters: d2 = smallest distance^2 to the puck
	tst.w	position(a0)			;check if goalie
	ble.w	.next					;branch if goalie
	tst.b	nopuck(a0)				;check if nopuck (cant touch puck)
	bne.w	.next					;branch if nopuck timer not 0
	btst.b	#pf2unav,pflags2(a0)	;pf2unav - unavailable
	bne.w	.next					;branch if unavailable
	move.w	assnum(a0),d0			;assnum - current assignment
	cmpi.b	#$13,asslist(a0,d0.w)	;check if current assignment is asspassrec
	beq.w	.next					;branch if a0 is going to receive puck
	move.l	a0,-(sp)				;push onto stack
	bsr.w	GetHot					;get hot spot
	add.w	0(a0),d0				;Xpos to d0
	sub.w	(puckx).l,d0			;sub puck Xpos
	add.w	Ypos(a0),d1				;add Ypos to d1
	sub.w	(pucky).l,d1			;sub puck Ypos
	move.w	(puckvx).l,d3			;puckvx into d3
	asr.w	#6,d3					;divide by 64
	sub.w	d3,d0					;sub d3 from d0 (X distance between player and puck)
	move.w	(puckvy).l,d3			;puckvy into d3
	asr.w	#6,d3					;divide by 64
	sub.w	d3,d1					;sub d3 from d1 (Y distance between player and puck)
	muls.w	d0,d0					;square d0
	muls.w	d1,d1					;square d1
	add.l	d1,d0					;add d1 to d0
	cmp.l	d2,d0					;compare d2 to d0
	bhi.w	.next					;branch if d0 higher than d2 (0 or a positive # first run)
	move.l	d0,d2					;move d0 into d2
;CD: no cartridge twin
	movea.l	a0,a1
.next								;next skater
	adda.w	#SCstruct,a0			;SCstruct size
	dbf	d4,.de0						;iterate through loop
	tst.l	d2						;check if 0
	bmi.w	.de1					;branch if less (no one near puck)
	move.l	d2,tmnear(a2)			;nearest skater's distance^2 to the puck
;CD: no cartridge twin
.switch								;CD: placed where the disc branches to it
	cmpa.l	a1,a3
	beq.w	.de1					;branch if same
	btst.b	#gmclock,(gmode).l		;gmclock - 1 if stopped
	bne.w	.de1					;jump if stopped
	btst.b	#pf2unav,pflags2(a1)	;pf2unav
	bne.w	.de1					;jump if unavailable
	btst.b	#pf3onetimer,pflags3(a1)	;shooting one timer
	bne.w	.de1					;jump if shooting
	exg	a1,a3						;swap addresses
	bclr.b	#pfdoff,pflags(a3)		;clear pfdoff
	moveq	#$11,d0					;assnearest
	bsr.w	assinsert				;... and give him the assnearest assignment
	exg	a1,a3
	bra.w	assexit					;I (old a3) drop this assignment
.de1								;nobody nearer: go to the puck
	btst.b	#pfalock,pflags(a3)		;pfalock - check if locked in animation
	bne.w	X_31AB6					;exit if locked (CD: the cartridge has rtss2)
	moveq	#2,d1					;move 2 into d1
	cmpi.w	#$190,d2				;compare $190 (20^2) to d2. d2 = distance to puck^2
	bhi.w	.nfar					;branch if d2 higher
	subi.w	#2,d1					;close: d1 = 0
	cmpi.w	#2,position(a3)			;compare if position is F or D (1 and 2 are D)
	bls.w	.nodec					;jump if D
.nfar								;far from the puck
	btst.b	#sf2pwrplay,(sflags2).l	;sf2pwrplay - check if PP
	beq.w	.x						;branch if no PP
	subi.w	#2,d1					;sub 2 from d1
	bsr.w	chkpk2
	bne.w	.x						;branch if on PK
	addi.w	#4,d1					;add 4 to d1
;CD: no cartridge twin
.x									;CD: placed where the disc branches to it
	moveq	#$28,d0
	sub.b	checking(a3),d0			;sub checking from d0
	asl.w	d1,d0					;shift d0 by value of d1
	bsr.w	randomd0				;RNG
	cmpi.w	#2,d0					;compare 2 to d0
	bhi.w	.nodec					;branch if d0 more than 2
	move.w	#$F0,temp3(a3)			;move 240 dec into temp3
.nodec								;temp3 = 240 on a low roll: probably a hit timer
	btst.b	#pfalock,pflags(a3)		;pfalock - check if anim lock
	bne.w	X_31AB6					;exit if locked (CD: the cartridge has rtss2)
	btst.b	#2,(BA_PS_flags).l		;check bit 2
	beq.w	.gmclock				;jump if not set
	btst.b	#5,(BA_PS_flags).l		;check bit 5
	beq.w	.nodec2					;jump if not set
.gmclock							;clock running?
	btst.b	#gmclock,(gmode).l		;check if clock running
	bne.w	donothing				;branch if not
.nodec2								;clock running: count down
	btst.b	#pfjoycon,pflags(a3)	;pfjoycon - check if controlled
	bne.w	X_31AB6					;jump if controlled (CD: the cartridge has rtss2)
	btst.b	#tmfmid,tmflags(a2)		;tmfmid of tmflags(a2)
	bne.w	.nodec22
	tst.w	(puckc).l				;check if theres a puck carrier
	bmi.w	.topuck					;jump if no puck carrier
	sub.w	d7,temp3(a3)			;subtract frames from temp3
	bpl.w	.topuck					;jump if positive
	clr.w	temp3(a3)				;clear temp3
.nodec22							;skate to the puck
	bsr.w	skatetopuckinit			;d0/d1 = halfway between
	movem.w	d0-d1,-(sp)				;d0 = future puckx, d1 = future pucky push on stack
	neg.w	d0						;or (0,-$F4) if pfgoal
	neg.w	d1
	addi.w	#$F4,d1					;add goalline - 20 decimal
	btst.b	#pfgoal,pflags(a3)		;pfgoal - check what net shooting on
	beq.w	.nd0					;branch if bottom
	subi.w	#$1E8,d1				;sub bottom goalline - 20 decimal
.nd0								;Y target for his end
	asr.w	#1,d0					;divide by 2
	asr.w	#1,d1					;divide by 2
	add.w	(sp)+,d0				;add original future puckx
	add.w	(sp)+,d1				;add original future pucky
	btst.b	#tmfmid,tmflags(a2)		;?? - doesn't seem to be set anywhere
	beq.w	.spdboost
	btst.b	#pfgoal,pflags(a3)		;pfgoal
	beq.w	.botshoot				;branch if bottom
	cmpi.w	#$53,d1					;check if y pos of puck near blue line
	blt.w	.spdboost				;branch if in neutral zone or D zone
	move.w	#$44,d1					;move 44 hex into d1
	bra.w	.spdboost
.botshoot							;pfgoal clear
	cmpi.w	#$FFAD,d1				;check if pucky near bottom blue line
	bgt.w	.spdboost				;branch if in neutral zone or D zone
	move.w	#$FFBC,d1				;move FFBC into d1
.spdboost							;carrier in the slot: speed boost toward the puck
	btst.b	#5,(sflags6).l			;check if puckc is in the slot
	beq.w	.noslot					;branch if not
	move.b	legspd(a3),(TempLegSpd).l	;legspd into TempLegSpd
	addi.b	#6,legspd(a3)			;add 6 to legspd
	btst.b	#1,(sflags8).l			;check if crowd meter broken (always is)
	bne.w	.spdboostex				;jump if set
	btst.b	#6,(sflags7).l			;check if crowd meter currently broken
	beq.w	.spdlimit				;jump if not set
.spdboostex							;crowd meter boost
	addi.b	#2,legspd(a3)
.spdlimit							;limit the speed
	cmpi.b	#$1E,legspd(a3)			;check speed limit
	ble.w	.cont
	move.b	#$1E,legspd(a3)			;limit legspd to $1E (30 decimal)
.cont								;skate, then put the leg speed back
	lea	$341EE.l,a0
	bsr.w	skateto
	move.b	(TempLegSpd).l,legspd(a3)	;move original legpsd back into player
	bra.w	.chkslot
.noslot								;bit 5 of sflags6 clear
	lea	$341EE.l,a0
	bsr.w	skateto
.chkslot							;in the slot: chase the carrier
	btst.b	#5,(sflags6).l
	beq.w	.chkcont
	move.w	(pucky).l,d0
	move.w	Ypos(a3),d2				;Ypos into d2
	tst.w	d0						;check if d0 is 0
	bpl.w	.pospuck				;branch if positive
	neg.w	d0						;make d0 negative
	neg.w	d2						;make d2 negative
.pospuck							;puck side
	sub.w	d0,d2					;sub d0 from d2 (equals how far puck is from player Ypos)
	cmpi.w	#$A,d2					;check difference with A (10 decimal)
	blt.w	.exit
	move.w	0(a3),d0				;Xpos of player (gets here if player is between net and puck carrier)
	sub.w	(puckx).l,d0			;sub puckx from Xpos
	bpl.w	.chkx					;branch if positive difference
	neg.w	d0						;make d0 negative
.chkx								;|dx|
	cmpi.w	#$F,d0					;compare F (15 dec) with Xpos difference
	blt.w	.chkcont				;branch if less than (within 15 pix in X direction)
.exit								;exit (also the end of the code above)
	rts
.chkcont							;bit 5 of sflags6 clear or d0 < $F
	btst.b	#5,(sflags6).l			;check if puckc is in the slot
	beq.w	check4check				;branch if not in slot
	move.b	checking(a3),d0			;move Chk into d0
	ext.w	d0						;clear top byte of d0
	movem.l	d0/a3,-(sp)				;push to stack
	add.b	d0,d0					;add d0 to itself
	cmpi.b	#$1E,d0					;compare max Chk to d0
	blt.w	.chkcont2				;branch if less
	move.b	#$1E,d0					;move 1E into d0
.chkcont2							;check odds clamped
	move.b	d0,checking(a3)			;move d0 into Chk
	bsr.w	check4check
	movem.l	(sp)+,d0/a3				;pop off stack
	move.b	d0,checking(a3)			;move original Chk into player
	rts
.topuck								;skate to the puck (falls into check4check)
	bsr.w	skatetopuck
; look for good opportunity for checking opponent
; a3 = player
check4check							;look for good opportunity for checking opponent. Falls in from
									;assnearest; also entered from assfwatch and asswingd roll against
									;the checking rating first, then look for an opponent within 30 units
									;whom a3 is facing
	tst.w	position(a3)			;check if goalie
	bne.w	.player					;branch if not
	rts
.player								;skater: d0 = check range, less checking skill, more with penalties off
	move.w	#$28,d0					;start with 28 hex (40 decimal)
	sub.b	checking(a3),d0			;subtract Chk from d0 (Chk max is 1E or 30 decimal)
	tst.w	(OptPen).l				;check for penalties option
	beq.w	.nopen					;branch if not on
	asl.w	#1,d0					;mult by 2
.nopen								;penalty odds
	bsr.w	randomd0				;RNG d0
	cmpi.w	#6,d0					;compare 6 to d0
	bhi.w	X_31AB6					;exit if d0 higher than 6 (CD: the cartridge has rtss2)
	moveq	#5,d2					;move 5 into d2
	movea.l	#$17480,a0				;CD: the cartridge has #(SortCords-M68K_RAM)
	cmpi.w	#6,SCnum(a3)			;check if player on home team
	bge.w	.0						;branch if away
	adda.w	#6*SCstruct,a0			;add if home (checks opposite team in loop)
.0									;loop over the opponents for a check target
	tst.w	position(a0)			;check if goalie
	beq.w	.next					;branch if goalie
	btst.b	#pfalock,pflags(a0)		;check if locked in anim
	bne.w	.next					;branch if locked
	btst.b	#pf2fight,pflags2(a0)	;check if fighting
	bne.w	.next					;branch if fighting
	move.w	0(a0),d0				;move Xpos into d0
	sub.w	0(a3),d0				;sub a3 from a0
	cmpi.w	#$1E,d0					;compare to 30 decimal
	bgt.w	.next					;branch if more than 30 decimal
	cmpi.w	#$FFE2,d0				;compare to -30 decimal
	blt.w	.next					;branch if less than -30
	move.w	Ypos(a0),d1				;Ypos
	sub.w	Ypos(a3),d1				;subtract checker Ypos from d1
	cmpi.w	#$1E,d1					;compare to 30 decimal
	bgt.w	.next					;branch if more
	cmpi.w	#$FFE2,d1				;check with -30 decimal
	blt.w	.next					;branch if less
	bsr.w	vtoa					;determine direction
	cmp.w	facedir(a3),d0			;compare facedir with vtoa result
	bne.w	.next					;branch if not facing in that direction
	btst.b	#5,(sflags6).l			;check if puckc in slot
	bne.w	Acheck					;branch if in slot
;CD: no cartridge twin
.L342CE
	btst.b	#$7,$FF800E.l
	bne.s	.L342CE
	move.w	#$1B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L342E8
	btst.b	#$6,$FF800E.l
	beq.s	.L342E8
	move.w	$FF8010.l,d0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L34308
	btst.b	#$6,$FF800E.l
	bne.s	.L34308
	bclr.b	#$7,$FF800F.l
	andi.w	#3,d0					;pass first 2 bits
	bne.w	burst					;throw check
	bra.w	Acheck					;1 in 4: hold or hook on a0
.next								;next opponent
	adda.w	#SCstruct,a0			;move to next SCstruct
	dbf	d2,.0
	rts
; assignment for catching pass
asspassrec							;assignment for catching a pass (apassrec)
	btst.b	#pfalock,pflags(a3)		;pfalock - animation lock
	bne.w	X_31AB6					;exit if locked (CD: the cartridge has rtss2)
	btst.b	#gmclock,(gmode).l		;gmclock - check if clock running
	bne.w	donothing				;exit if clock stopped
	btst.b	#pfjoycon,pflags(a3)	;pfjoycon - joystick controlled?
	bne.w	assexit					;exit if controlled
	bclr.b	#pfna,pflags(a3)		;#pfna - clear new assignment
	beq.w	.nna
	bset.b	#pfdoff,pflags(a3)		;#pfdoff - set decceleration off
	move.b	#8,temp2+1(a3)			;move into temp2+1
	clr.b	temp2(a3)				;clear temp2 byte
	move.w	#$FFFE,temp4(a3)		;move into temp4
.nna								;count down the timer
	tst.w	(puckc).l				;check if there is a puck carrier
	bpl.w	.exit					;exit if puck still in possession
	addi.w	#1,temp4(a3)			;add to temp4
	beq.w	.0						;branch if temp4 is zero
	bpl.w	.ex2					;branch if temp4 is positive
.0									;pass missed or gone: back to normal play unless a one-timer is set
	tst.w	(onetimerplayer).l
	bpl.w	.ex2
	tst.w	position(a3)			;test if goalie
	beq.w	.ex2					;exit if goalie
	move.w	d0,-(sp)				;push d0 on stack
	clr.w	temp4(a3)				;clear temp4
	move.w	#1,d0
	btst.b	#pfteam,pflags(a3)		;check if home or away
	beq.w	.1
	move.w	#2,d0					;away team
.1									;team pad chosen
	cmp.w	(cont1team).l,d0		;check if player on cont 1 team
	beq.w	.pop					;branch if so
	cmp.w	(cont2team).l,d0		;check if player on cont 2 team
	beq.w	.pop					;branch if so
	jsr	(PuckOnAttackHalf).l
	beq.w	.pop
	move.w	Ypos(a3),d0				;Ypos
	btst.b	#pfgoal,pflags(a3)		;pfgoal
	bne.w	.chkpos					;branch if shooting at top
	neg.w	d0
.chkpos								;position check
	cmpi.w	#Blueline,d0			;blueline
	blt.w	.nozone
	cmpi.w	#Blueline+goalline,d0	;goalline
	bgt.w	.nozone
	bra.w	.atkzone
.nozone								;d0 < #Blueline or d0 > #Blueline+goalline
	move.w	#8,d0					;outside of attack zone
	jsr	(randomd0).l
	tst.w	d0						;check if d0 is zero
	bne.w	.pop
.atkzone							;in the attack zone (or 1 in 8 outside): set up a one-timer
	move.w	(sp)+,d0
	move.w	#$FFFF,(inputjoy).l
	move.w	#$23,d0					;assonetimer
	jmp	(assreplace).l
.pop								;no one-timer: drop the saved d0
	move.w	(sp)+,d0
.ex2								;count down the pass timer; when out, back to normal play
	sub.b	d7,temp1(a3)
	bpl.w	X_31AB6					;CD: the cartridge has rtss2
.exit								;exit
	bclr.b	#pfdoff,pflags(a3)
	bra.w	assexit
SkateToTempTarget					;unreferenced. Skate to temp3 / temp4, then rts
	move.w	temp3(a3),d0			;temp3
	move.w	temp4(a3),d1			;temp4
	lea	rtss2(pc),a0
	bra.w	skateto

; assignment for computer shooting
assshoot							;assignment for computer shooting. Assignment ashoot ($12)
	btst.b	#pfalock,pflags(a3)		;pfalock - animation locked
	bne.w	X_31AB6					;CD: the cartridge has rtss2
	bclr.b	#pfna,pflags(a3)		;clear pfna
	beq.w	.nna
	bra.w	SetShotMode				;first frame: start the shot (temp2 = swing time set by CompShoot)
.nna								;pfna was clear
	btst.b	#sfssdir,(sflags).l		;#sfssdir
	beq.w	assexit					;no: the shot is done
	clr.w	d2
	sub.w	d7,temp2(a3)			;count the swing time down
	bpl.w	ShotMode				;still swinging: feed ShotMode no buttons
	bset	#cbut,d2				;#cbut
	bra.w	ShotMode				;swing time over: press the shot button (cbut)
puckshootout						;puck logic for the shootout: on a new assignment clear the pads and
									;select the skater, then run the attempt
	bclr.b	#pfna,pflags(a3)
	beq.w	.selectskater
	bset.b	#7,(sflags7).l
	clr.l	(padcont).l
	clr.l	(padcont+4).l
	clr.l	(padcont+8).l
	bclr.b	#7,(gmode2).l
	btst.b	#0,(gmode2).l
	beq.w	.startattempt
	jsr	(NextShooter).l
	bra.w	.initflags
.startattempt						;bit 0 of gmode2 clear
	jsr	(StartShootoutPath).l
	move.l	a2,-(sp)
	movea.l	#tmstruct,a2
	tst.w	(BA_Team).l
	beq.w	.countattempt
	movea.l	#awtmstruct,a2
.countattempt						;count the attempt
	addi.w	#1,tmPenShots(a2)
	movea.l	(sp)+,a2
.initflags							;attempt counted: clear the penalty shot state flags
	bclr.b	#2,(BA_PS_flags).l
	bclr.b	#4,(BA_PS_flags).l
	bclr.b	#5,(BA_PS_flags).l
	bclr.b	#6,(BA_PS_flags).l
	bset.b	#1,(sflags6).l
	btst.b	#gmpendel,(gmode).l
	bne.w	Stop4Pen
	bclr.b	#pfna,pflags(a3)
	btst.b	#0,(gmode2).l
	beq.w	.selectsong
	tst.w	(shootoutteam).l
	bne.w	.setstopped
	tst.w	(homeshootnum).l
	bne.w	.setstopped
	move.w	(HomeTeam).l,(HmTeam).l
	move.w	#SngFaceoff,(SongIndex).l
	jsr	(ChooseSong).l
	move.w	(SongNum).l,-(sp)
	bra.w	.playsong
.selectsong							;bit 0 of gmode2 clear
	move.w	(HomeTeam).l,(HmTeam).l
	move.w	#SngFaceoff,(SongIndex).l
	jsr	(ChooseSong).l
	move.w	(SongNum).l,-(sp)
.playsong							;play the chosen song, then stop the clock for the attempt
	bsr.w	song
.setstopped							;stop the clock
	bset.b	#gmclock,(gmode).l
	bset.b	#1,(gmode2).l
	clr.w	(puckvx).l
	clr.w	(puckvy).l
	move.w	#$19,(shootoutclock).l
	bsr.w	ReturnGoalies
	st.b	temp1(a3)
	st.b	temp2(a3)
.selectskater						;select the skater
	bset.b	#2,(BA_PS_flags).l
	movem.w	d1-d2,-(sp)
	jsr	(SelectPenaltyShotSkater).l
	bmi.w	.noeligible
	movem.w	(sp)+,d1-d2
	bra.w	.checkgoalie
.noeligible							;pop the d1-d2 saved above
	movem.w	(sp)+,d1-d2
	bclr.b	#2,(BA_PS_flags).l
	move.w	#$1B,d0					;puckfaceoff
	bsr.w	assreplace
	rts
.checkgoalie						;shootout: make sure the shooting team's goalie is in net
	movem.w	d1-d2,-(sp)
	move.w	(BA_Goalie_SCnum).l,d0
	movea.l	#SortCords,a2
	asl.w	#7,d0
	adda.w	d0,a2
	tst.w	position(a2)
	bne.w	.findgoalie
	btst.b	#2,pflags2(a2)
	beq.w	.startpenshot
.findgoalie							;goalie not available: search the team for another goalie slot
	move.w	(BA_Goalie_SCnum).l,d0
	move.w	#6,d2
.goalieloop							;loop
	subi.w	#1,d2
	bmi.w	.noeligible
	subi.w	#1,d0
	bpl.w	.wraphome
	move.w	#5,d0
	bra.w	.checkcandidate
.wraphome							;d0 >= 0
	cmpi.w	#5,d0
	bne.w	.checkcandidate
	move.w	#$B,d0
.checkcandidate						;wrap from home to away numbering, then try this candidate
	movea.l	#SortCords,a2
	move.w	d0,d1
	asl.w	#7,d1
	adda.w	d1,a2
	tst.w	position(a2)
	bne.w	.goalieloop
	btst.b	#2,pflags2(a2)
	bne.w	.goalieloop
	move.w	d0,(BA_Goalie_SCnum).l
.startpenshot						;pop the d1-d2 saved above
	movem.w	(sp)+,d1-d2
	movea.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
	move.w	#$1F,d0					;puckpenshot
	bra.w	assreplace
SelectPenaltyShotSkater				;pick the skater for the penalty shot from team BA_Team
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a0
	tst.w	(BA_Team).l
	beq.w	.hometeam
	movea.l	#awtmstruct,a0
.hometeam							;team struct chosen
	move.w	#0,d1
	move.w	#$FFFF,d6
	move.w	#$FFFF,d5
	movea.l	tmdata(a0),a2
	adda.w	0(a2),a2
.playerloop							;loop
	cmpi.w	#2,(a2)
	beq.w	.doneplayers
	adda.w	(a2),a2
	move.w	d1,d7
	asl.w	#1,d7
	move.b	pldstick(a2),d0
	andi.w	#$F,d0
	cmpi.b	#1,d0
	ble.w	.nextplayer
	btst.b	#0,(gmode2).l
	bne.w	.setskaterscnum
	cmpi.w	#$FFFE,tmpdst(a0,d7.w)
	beq.w	.scorecandidate
	cmpi.w	#$FFFF,tmpdst(a0,d7.w)
	bne.w	.nextplayer
.scorecandidate						;on the bench or ice: rate this player as a shooter
	clr.w	d3
	clr.w	d0
	move.b	pldweight(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	pldlegspd(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	pldlegspd(a2),d0
	andi.w	#$F0,d0
	lsr.w	#4,d0
	add.w	d0,d3
	move.b	pldaidef(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	pldaidef(a2),d0
	andi.w	#$F0,d0
	lsr.w	#4,d0
	add.w	d0,d3
	move.b	pldstick(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	pldstick(a2),d0
	andi.w	#$F0,d0
	lsr.w	#4,d0
	add.w	d0,d3
	move.b	pldendur(a2),d0
	andi.w	#$F0,d0
	lsr.w	#4,d0
	add.w	d0,d3
	move.b	pldpass(a2),d0
	andi.w	#$F0,d0
	lsr.w	#4,d0
	add.w	d0,d3
	cmp.w	(BA_Skater_Offset).l,d1
	bne.w	.comparebest
	move.w	#$7FFF,d3
.comparebest						;compare with the best
	cmp.w	d6,d3
	blt.w	.nextplayer
	move.w	d3,d6
	move.w	d1,d5
	bra.w	.nextplayer
;CD: no cartridge twin
.nextplayer							;CD: placed where the disc branches to it
	adda.l	#$8,a2
	addi.w	#1,d1
	cmpi.w	#$1A,d1
	blt.w	.playerloop
.doneplayers						;all players checked
	tst.w	d5
	bmi.w	.noeligible
	move.w	d5,(BA_Skater_Offset).l
.setskaterscnum						;set the skater SCnum
	move.w	#0,(BA_Sktr_SCnum).l
	tst.w	(BA_Team).l
	beq.w	.loadskater
	move.w	#6,(BA_Sktr_SCnum).l
.loadskater							;load the skater
	move.w	(BA_Sktr_SCnum).l,d0
	asl.w	#7,d0
	movea.l	#SortCords,a3
	adda.w	d0,a3
	move.w	(BA_Skater_Offset).l,d3
	bra.w	.eligible
.noeligible							;d5 negative
	move.w	#$FFFF,d0
	bra.w	.exit
.eligible							;found a skater: d0 = 1
	move.w	#1,d0
.exit								;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a6
	rts
; puck start for penalty shot/shootout
puckpenshot							;puck start for a penalty shot or shootout: on the first call (pfna) black
									;the screen and set up the shot
	bclr.b	#pfna,pflags(a3)
	beq.w	.resumeplay
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	forceblack
.waitvblank							;loop
	btst.b	#dfok,(disflags).l
	bne.w	.waitvblank
	cmpi.w	#$258,(Crowdlevel).l
	bls.w	.setuprink
	move.w	#$258,(Crowdlevel).l
	addi.w	#$14,(CwdExciteLvl).l
.setuprink							;set up the rink
	move.w	(ExtraChars).l,d4
;CD: no cartridge twin
	movea.l	(RefsMapPtr).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsPlain).l
	bset.b	#dfclock,(disflags).l
	bclr.b	#sfpz,(sflags).l
	bclr.b	#sf3llcs,(sflags3).l
	clr.w	(glovecords).l
	clr.b	(iflags).l
	st.b	(RefCnt).l
	bclr.b	#sf2refref,(sflags2).l
	st.b	(passReceiverPlayerNum).l
	bsr.w	ClrHor
	clr.w	(Vpos).l
	clr.w	(Hpos).l
	move.w	#0,(puckx).l
	move.w	#0,(pucky).l
	clr.w	(puckz).l
	clr.w	(puckvx).l
	clr.w	(puckvy).l
	clr.w	(puckvz).l
	st.b	(puckc).l
	movea.l	#$17A80,a0				;goal net SCstruct (CD: the cartridge has
									;#(SortCords+(12*SCstruct)-M68K_RAM))
	clr.w	Xvel(a0)
	clr.w	Yvel(a0)
	clr.w	0(a0)
	move.w	#$10C,Ypos(a0)
	adda.w	#$80,a0					;move to second goal net SCstruct
	clr.w	Xvel(a0)
	clr.w	Yvel(a0)
	clr.w	0(a0)
	move.w	#$FEF4,Ypos(a0)
	movea.l	#$17C00,a0				;puck shadow SCstruct (CD: the cartridge has
									;#(SortCords+((puckscnum+1)*SCstruct)-M68K_RAM))
	move.w	#SPFpuck,frame(a0)
	clr.w	SPA(a0)
	clr.w	attribute(a0)
	clr.w	(SortCords+(puckscnum*SCstruct)+attribute).l
	bclr.b	#sfslock,(sflags).l
	moveq	#$64,d4
.scrollloop							;run the scroll window 101 times so it settles
	bsr.w	checkwindow
	dbf	d4,.scrollloop
	move.w	#$3C,(yleader).l
;CD: no cartridge twin
	jsr	(ResetBench).l
	movea.l	#tmstruct,a2
	jsr	(setpersonel).l
	jsr	(SetupPenaltyShot).l
	adda.l	#$366,a2
	jsr	(setpersonel).l
	jsr	(SetupPenaltyShot).l
	jsr	(resetplstuff).l
	move.l	a3,-(sp)
	movea.l	#SortCords+(11*SCstruct),a3	;away goalie SCstruct
	move.w	#$B,d2					;11 = # of player SCstructs
.playerloop							;loop over the 12 players: set up the shooter and goalie, park the rest
	cmp.w	(BA_Sktr_SCnum).l,d2
	beq.w	.setupskater
	cmp.w	(BA_Goalie_SCnum).l,d2
	beq.w	.setupgoalie
	move.w	#$FF10,0(a3)
	clr.w	Ypos(a3)
	clr.w	frame(a3)
	move.w	#$20,d0
	bsr.w	assinsert
	bra.w	.nextplayer
.setupskater						;d2 = BA_Sktr_SCnum
	tst.w	position(a3)
	bpl.w	.placeskater
	bclr.b	#2,pflags2(a3)
	beq.w	.placeskater
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d3
	move.b	pnum(a3),d3
	jsr	(setplayer).l
	movem.l	(sp)+,d0-d7/a0-a6
	tst.w	position(a3)
	beq.w	.skaterready
	bpl.w	.placeskater
.skaterready						;shooter on the ice: place him at the puck
	nop
.placeskater						;shooter starts at the puck, facing the goal he shoots at
	move.w	(puckx).l,d0
	subi.w	#0,d0
	move.w	d0,0(a3)
	move.w	(pucky).l,d0
	btst.b	#pfgoal,pflags(a3)
	bne.w	.skaterattop
	addi.w	#$10,d0
	move.w	#4,facedir(a3)
	bra.w	.setskaterpos
.skaterattop						;pfgoal set
	addi.w	#-$10,d0
	move.w	#0,facedir(a3)
.setskaterpos						;set the shooter's y and stop him
	move.w	d0,Ypos(a3)
	clr.w	Xvel(a3)
	clr.w	Yvel(a3)
	clr.w	Zvel(a3)
	move.w	#$11,d0
	bsr.w	assinsert
	bra.w	.nextplayer
.setupgoalie						;d2 = BA_Goalie_SCnum
	btst.b	#0,(gmode2).l
	beq.w	.goalieactive
	move.b	(shootoutteam-1).l,pnum(a3)
	tst.w	(shootoutteam).l
	beq.w	.loadgoalieplayer
	move.b	(homeshootnum-1).l,pnum(a3)
	bra.w	.loadgoalieplayer
.goalieactive						;bit 0 of gmode2 clear
	tst.w	position(a3)
	bpl.w	.placegoalie
	bclr.b	#2,pflags2(a3)
	beq.w	.placegoalie
.loadgoalieplayer					;goalie not on the ice: bring him on
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d3
	move.b	pnum(a3),d3
	jsr	(setplayer).l
	movem.l	(sp)+,d0-d7/a0-a6
	tst.w	position(a3)
	bne.w	.goalieok
	bpl.w	.placegoalie
.goalieok							;goalie on the ice
	nop
.placegoalie						;goalie in his crease, facing out
	bclr.b	#2,pflags2(a3)
	move.w	#0,d0
	move.w	#$E5,d1
	btst.b	#pfgoal,pflags(a3)
	bne.w	.goalieattop
	move.w	#$FF1B,d1
.goalieattop						;goalie Y set
	move.w	d0,0(a3)
	move.w	d1,Ypos(a3)
	clr.w	Xvel(a3)
	clr.w	Yvel(a3)
	clr.w	Zpos(a3)
	sub.w	(puckx).l,d0
	sub.w	(pucky).l,d1
	neg.w	d0
	neg.w	d1
	bsr.w	vtoa
	move.w	d0,facedir(a3)
	bclr.b	#2,pflags2(a3)
	bclr.b	#pfalock,pflags(a3)
	move.w	#SPAglide,d1
	bsr.w	SetSPA
.nextplayer							;next player
	suba.l	#$80,a3
	dbf	d2,.playerloop				;cycle to next player
;CD: no cartridge twin
	jsr	(SprSort).l
	movea.l	(sp)+,a3
	bsr.w	ResetAndSelectPlayers
	move.w	(BA_Goalie_SCnum).l,d0
	asl.w	#7,d0
	movea.l	#$17480,a3				;CD: the cartridge has #(SortCords-M68K_RAM)
	adda.w	d0,a3
	move.w	#0,0(a3)
	move.w	#$FF06,Ypos(a3)
	btst.b	#pfgoal,pflags(a3)
	bne.w	.goalieatbottom
	move.w	#$FA,Ypos(a3)
.goalieatbottom						;goalie Y set
	move.w	(BA_Goalie_SCnum).l,d0
	move.w	#1,d1
	btst.b	#pfteam,pflags(a3)
	beq.w	.checkcont1
	move.w	#2,d1
.checkcont1							;pad for his team
	cmp.w	(cont1team).l,d1
	bne.w	.checkcont2
	jsr	(setc1player).l
	bra.w	.setgoalieassignment
.checkcont2							;d1 <> cont1team
	cmp.w	(cont2team).l,d1
	bne.w	.setgoalieassignment
	jsr	(setc2player).l
.setgoalieassignment				;give the goalie his penalty shot assignment
	move.w	#$E,d0					;assignment D51C?
	bsr.w	assreplace
	bset.b	#7,(BA_PS_flags).l
	bset.b	#sf2drec,(sflags2).l
	move.w	#$190,(msgtimer).l
	tst.w	(cont1team).l
	bne.w	.finishsetup
	tst.w	(cont2team).l
	bne.w	.finishsetup
	move.w	#$64,(msgtimer).l
.finishsetup						;finish the setup
	move.w	#$18,(palcount).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.resumeplay							;pfna was clear
	bset.b	#2,(gmode2).l
	move.w	#$18,d0					;pucknorm
	bsr.w	assreplace
	clr.w	Xvel(a3)
	clr.w	Yvel(a3)
	rts
	dc.b	0,1,2,3,4,5,6,0,0,1,5,3,4,2,0,0
	dc.b	0,3,5,1,4,0,0,0,0,0,$FF,6,$FF,$DD,$FF,$CE
	dc.b	0
	dc.b	$23						;#
	dc.b	$FF,$CE,$FF,$CE,$FF,$F6,0,0,$FF,$F1,0
	dc.b	$32						;2
	dc.b	$FF,$F6,0,0,$FF,$C4
UpdatePenaltyShotEnd				;end the penalty shot when the goalie has the puck, the puck is loose or
									;the timer runs out
	movem.w	d0,-(sp)
	move.w	(puckc).l,d0
	cmp.w	(BA_Goalie_SCnum).l,d0
	movem.w	(sp)+,d0
	beq.w	.setended
	btst.b	#5,(BA_PS_flags).l
	beq.w	.checktimer
	btst.b	#5,(gmode2).l
	bne.w	.puckloose
	tst.w	(puckc).l
	bpl.w	.countdown
	bset.b	#5,(gmode2).l
.puckloose							;puck loose
	tst.w	(puckc).l
	bpl.w	.setended
.countdown							;count down the shot clock
	tst.w	(passmodetimer).l
	bmi.w	.setended
	subq.w	#1,(passmodetimer).l
	bra.w	.checktimer
.setended							;pass mode timer out: the attempt is over
	bset.b	#4,(BA_PS_flags).l
.checktimer							;shootout clock out: the attempt is over
	tst.w	(shootoutclock).l
	bne.w	.checkended
	bset.b	#4,(BA_PS_flags).l
.checkended							;check the end
	btst.b	#4,(BA_PS_flags).l
	bne.w	.finishshot
	rts
.finishshot							;bit 4 of BA_PS_flags set
	btst.b	#6,(BA_PS_flags).l
	bne.w	PenaltyShotEndReturn
	bset.b	#6,(BA_PS_flags).l
	move.w	#$A,d0
	jsr	(AddPenalty2).l
EndPenaltyShotPlay					;stop play after a penalty shot or shootout attempt: freeze the window,
									;stop the clock, clear the penalty shot flags
	jsr	(freezewindow).l
	btst.b	#0,(gmode2).l
	bne.w	.stopplay
	move.w	#$A,(replaydelay).l
	bset.b	#sf2drec,(sflags2).l
.stopplay							;stop play
	bset.b	#gmclock,(gmode).l
	bclr.b	#2,(gmode2).l
	bclr.b	#2,(BA_PS_flags).l
	bclr.b	#3,(BA_PS_flags).l
	bclr.b	#5,(BA_PS_flags).l
	bclr.b	#4,(BA_PS_flags).l
	bclr.b	#6,(BA_PS_flags).l
	movem.l	d0/a0,-(sp)
	movea.l	#SortCords,a0
	move.w	(BA_Sktr_SCnum).l,d0
	asl.w	#7,d0
	move.b	(savednewpnum).l,newpnum(a0,d0.w)
	movem.l	(sp)+,d0/a0
	jsr	(CountShootoutGoals).l
PenaltyShotEndReturn				;penalty shot already finished: return without adding another
	rts
; this is where the action starts
puckfaceoff							;puck controller for the face off: a3 = the face off controller (shootout
									;mode skips to its own setup)
	bclr.b	#4,(sflags8).l
	btst.b	#0,(gmode2).l
	beq.w	.normalfaceoff
	clr.w	(puckvx).l
	clr.w	(puckvy).l
	move.w	#$1E,d0					;assignment ECB6?
	bra.w	assreplace
.normalfaceoff						;bit 0 of gmode2 clear
	bclr.b	#pfna,pflags(a3)
	beq.w	WaitForFaceoffLineChanges
	bclr.b	#0,(sflags8).l
	beq.w	.resetpads
	clr.w	(fox).l
	clr.w	(foy).l
.resetpads							;reset the pads
	bclr.b	#7,(sflags7).l
	clr.l	(padcont).l
	clr.l	(padcont+4).l
	clr.l	(padcont+8).l
	bclr.b	#6,(sflags7).l
	bclr.b	#2,(sflags7).l
	jsr	(CheckScoreLeader).l
	tst.w	(faceoffanim).l
	bmi.w	.choosefaceoffspot
	move.w	(faceoffanim).l,d0
	bra.w	.handlefaceoffspot
.choosefaceoffspot					;faceoffanim negative
	jsr	(RandomFaceoffAnim).l
	tst.w	d0
	bmi.w	.checkperiod
.handlefaceoffspot					;set the faceoff animation for the spot
	jsr	(SetFaceoffAnim).l
.checkperiod						;period check
	bclr.b	#1,(sflags6).l
	bclr.b	#1,(gmode2).l
	tst.w	(gameclock).l
	beq.w	X_35A3E					;CD: the cartridge has PeriodOver
	btst.b	#gmeog,(gmode).l
	bne.w	X_35A3E					;CD: the cartridge has PeriodOver
	cmpi.w	#3,(gsp).l
	bne.w	.npo
	move.w	(HmGoals).l,d0
	cmp.w	(AwGoals).l,d0
	bne.w	X_3500C					;CD: the cartridge has clockcont_0
.npo								;no overtime win
	btst.b	#gmpendel,(gmode).l
	bne.w	Stop4Pen
	move.w	(PerTimeTotal).l,d0
	asr.w	#1,d0
	cmp.w	(gameclock).l,d0
	bls.w	.returngoalies
	cmpi.w	#$3C,(gameclock).l
	blt.w	.returngoalies
;CD: no cartridge twin
	btst.b	#$7,(sflags3).l
	beq.w	.returngoalies
	btst.b	#gmclock,(gmode).l
	beq.w	.returngoalies
	btst.b	#6,(sflags8).l
	bne.w	.returngoalies
;CD: no cartridge twin
	bclr.b	#$7,(sflags3).l
	move.w	(HomeTeam).l,(HmTeam).l
	move.w	#SngFaceoff,(SongIndex).l
	jsr	(ChooseSong).l
;CD: no cartridge twin
	move.w	(SongNum).l,-(sp)
	bsr.w	song
.returngoalies						;return pulled goalies and start the faceoff timers
	bsr.w	ReturnGoalies
	st.b	temp1(a3)
	st.b	temp2(a3)
	tst.w	(OptLine).l
	bne.w	WaitForFaceoffLineChanges
	bclr.b	#tmflcm,(tmstruct+tmflags).l
	bclr.b	#tmflcm,(awtmstruct+tmflags).l
	movea.l	#$17480,a0				;CD: the cartridge has #(SortCords-M68K_RAM)
	moveq	#$B,d0
.clearlcmloop						;loop: clear the line change mode of all 12 players
	bclr.b	#pf2lcm,pflags2(a0)
	adda.w	#SCstruct,a0
	dbf	d0,.clearlcmloop
	move.w	(cont1team).l,d0
	or.w	(cont2team).l,d0
	beq.w	.checkc1line
	btst.b	#sfhor,(sflags).l
	beq.w	.checkc1line
	bsr.w	forceblack
	bset.b	#sfslock,(sflags).l
	bsr.w	ClrHor
	move.w	#$18,(palcount).l
	tst.w	(OptLine).l
	bne.w	.checkc1line
	btst.b	#4,(sflags7).l
	beq.w	.checkc1line
	clr.w	(palcount).l
.checkc1line						;start the line change box for each pad's team
	move.w	(c1playernum).l,d0
	bmi.w	.checkc2line
	bsr.w	StartFaceoffLineChange
.checkc2line						;pad 2 line change
	move.w	(c2playernum).l,d0
	bmi.w	.checkcomputerline
	bsr.w	StartFaceoffLineChange
.checkcomputerline					;computer line change
	movea.l	#$1834C,a1				;CD: the cartridge has #(tmstruct-M68K_RAM)
	lea	tmsize(a1),a2
	moveq	#2,d0
	bsr.w	SetFaceoffComputerLine
	bra.w	WaitForFaceoffLineChanges
SetFaceoffComputerLine				;faceoff: start a line change for team d0 when the computer controls it
									;(line changes on)
	tst.w	(OptLine).l
	bne.w	rtss2
	btst.b	#4,(sflags7).l
	bne.w	.dochange
	cmp.w	(cont1team).l,d0
	beq.w	rtss2
	cmp.w	(cont2team).l,d0
	beq.w	rtss2
.dochange							;change the line
	bsr.w	CompLine
;CD: no cartridge twin
	jsr	(setpersonel).l
	bsr.w	printscores1
	move.w	#$2710,(crowdnoisedelay).l
	rts
StartFaceoffLineChange				;start the line change box for team d0's sort object before a faceoff
	exg	a2,a3
	asl.w	#7,d0
	movea.l	#$17480,a3				;CD: the cartridge has #(SortCords-M68K_RAM)
	adda.w	d0,a3
	bclr.b	#3,pflags2(a3)
	move.l	a2,-(sp)
	bsr.w	SetLCmode
	movea.l	(sp)+,a2
	btst.b	#3,pflags2(a3)
	beq.w	.exit
	btst.b	#pfteam,pflags(a3)
	beq.w	.homeplayer
	move.w	#$168,temp2(a2)
	move.w	SCnum(a3),temp4(a2)
	bra.w	.exit
.homeplayer							;pfteam clear
	move.w	#$258,temp1(a2)
	move.w	SCnum(a3),temp3(a2)
.exit								;return with a2/a3 swapped back
	exg	a2,a3
	rts
WaitForFaceoffLineChanges			;run both teams' faceoff line change timers (temp1 / temp2); continue when
									;both have run out
	move.w	#$40,d0
	bsr.w	UpdateFaceoffLineChangeTimer
	move.w	#$42,d0
	bsr.w	UpdateFaceoffLineChangeTimer
	tst.w	temp1(a3)
	bpl.w	rtss2
	tst.w	temp2(a3)
	bpl.w	rtss2
	movea.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
	lea	tmsize(a2),a1
	moveq	#1,d0
	bsr.w	SetFaceoffComputerLine
	move.w	#$FFFF,(facelcwait).l
	move.w	#$1C,d0					;puckfaceoff2
	bra.w	assreplace
UpdateFaceoffLineChangeTimer		;count down one team's faceoff line change timer at offset d0 of a3
	tst.w	(a3,d0.w)
	bmi.w	rtss2
	move.w	$4(a3,d0.w),d1
	asl.w	#7,d1
	movea.l	#$17480,a0				;CD: the cartridge has #(SortCords-M68K_RAM)
	movea.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
	btst.b	#6,pflags(a0,d1.w)
	beq.w	.checkactive
	adda.w	#tmsize,a2
.checkactive						;a2 = that team's struct: still in line change mode, count down
	btst.b	#pf2lcm,pflags2(a0,d1.w)
	bne.w	.countdown
	st.b	(a3,d0.w)
	bra.w	SetLCmode2
.countdown							;pf2lcm set
	sub.w	d7,(a3,d0.w)
	bpl.w	rtss2
	move.l	a3,-(sp)
	lea	(a0,d1.w),a3
	btst.b	#3,pflags2(a3)
	beq.w	.exit
	clr.w	d2
	bsr.w	lcfound
	bsr.w	SetLCmode2
.exit								;done
	movea.l	(sp)+,a3
	rts
;CD: no cartridge twin
	jmp	(clockcont_0).l
; computer pulls goalie on delayed penalty
ChkGoalies							;computer pulls goalie on delayed penalty. Called from periodicevents
	btst.b	#gmclock,(gmode).l		;check if clock running
	bne.w	rtss2
	movea.l	#$1834C,a2				;a2 = team being tested, a1 = the other team (CD: the cartridge has
									;#(tmstruct-M68K_RAM))
	lea	tmsize(a2),a1
	moveq	#1,d0					;d0 = team number (1 home, 2 visitors)
	bsr.w	.chkgoalie
	moveq	#2,d0
	exg	a1,a2
.chkgoalie							;local subroutine
	tst.w	tmgoalie(a2)			;check for goalie
	bmi.w	rtss2					;no goalie, exit
	move.w	(puckc).l,d1			;move puck carrier SCnum into d1
	bmi.w	rtss2
	subi.w	#6,d1
	cmpa.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
	beq.w	.chkpen
	not.w	d1						;makes d1 negative if away team
.chkpen								;penalty check
	tst.w	d1
	bpl.w	rtss2
	btst.b	#gmpendel,(gmode).l		;#gmpendel - delayed penalty called
	beq.w	.nopen
	st.b	tmgoalie(a2)			;sets to FFFF (no goalie)
;CD: no cartridge twin
	jmp	(setpersonel).l
.nopen								;gmpendel clear
	cmp.w	(cont1team).l,d0
	beq.w	rtss2					;exit if team is joy controlled
	cmp.w	(cont2team).l,d0
	beq.w	rtss2					;exit if team is joy controlled
	move.w	(pucky).l,d1
	bra.w	CPgoalie
; if computer pulled goalie, look to see if computer should return him
ReturnGoalies						;if computer pulled goalie, look to see if computer should return him.
									;Called from puckfaceoff
	movea.l	#$1834C,a2				;a2 = team being tested, a1 = the other team (CD: the cartridge has
									;#(tmstruct-M68K_RAM))
	lea	tmsize(a2),a1
	moveq	#1,d0					;d0 = team number
	bsr.w	.r						;home team first ...
	moveq	#2,d0
	exg	a1,a2						;... then fall into .r for the visitors
.r									;local subroutine
	cmpi.w	#$FFFF,tmgoalie(a2)
	beq.w	rtss2					;still no goalie
	clr.b	tmgoalie(a2)			;clear for goalie return
	cmp.w	(cont1team).l,d0
	beq.w	rtss2					;exit if team is joy controlled
	cmp.w	(cont2team).l,d0
	beq.w	rtss2					;exit if team is joy controlled
	move.w	(foy).l,d1
; see if computer should pull his goalie
; d1 = Faceoff Y position
CPgoalie							;see if computer should pull his goalie. d1 = puck/faceoff y. Falls in
									;from ReturnGoalies; also entered from ChkGoalies
	cmpi.w	#2,(gsp).l				;check if 3rd period
	bne.w	rtss2					;exit if not
	move.w	tmscore(a1),d0			;tmscore
	sub.w	tmscore(a2),d0
	bmi.w	rtss2					;exit if leading in the game
	cmpi.w	#2,d0
	bne.w	rtss2					;exit if behind by more than 2
	cmpi.w	#$3C,(gameclock).l		;#60
	bgt.w	rtss2					;exit if more than 1 min left
	move.l	a0,-(sp)
;CD: no cartridge twin
	movea.l	$22(a2),a0
	btst.b	#pfgoal,pflags(a0)		;#pfgoal
	movea.l	(sp)+,a0
	bne.w	.0
	neg.w	d1						;make y positive toward the goal I shoot at
.0									;Y for his end
	tst.w	d1
	bmi.w	rtss2					;exit if d1 negative (faceoff in own zone)
	st.b	tmgoalie(a2)			;set to FFFF (no goalie)
;CD: no cartridge twin
	jmp	(setpersonel).l
; find good line for comp to switch to
CompLine							;find good line for comp to switch to. a2 = team, a1 = other team. Called
									;from chk4lc and puckfaceoff
	movem.l	d0-d2/a0,-(sp)
	moveq	#3,d0					;d0 = first of the 2 special lines (3-4) used with a man advantage
	move.w	tmap(a2),d1				;tmap
	sub.w	tmap(a1),d1				;compare the numbers of active players
	beq.w	.nopwr					;equal: normal line
	bpl.w	.0
	addi.w	#2,d0					;fewer players: lines 5-6 instead
.0									;d0 = line set (+2 when short handed): pick the freshest line
	move.w	d0,-(sp)				;find pk/pp line
	bsr.w	getlinee				;d0 = energy of the first candidate
	move.w	d0,d1
	move.w	(sp),d0
	addi.w	#1,d0
	bsr.w	getlinee				;d0 = energy of the second candidate
	cmp.w	d0,d1
	bge.w	.1
	addi.w	#1,(sp)					;second one has more energy: take it
.1									;more rested player chosen
	move.w	(sp)+,tmline(a2)		;tmline
.ex									;exit: restore the registers
	movem.l	(sp)+,d0-d2/a0
	rts
.nopwr								;d1 = 0
	cmpa.l	#$1834C,a2				;find normal line (CD: the cartridge has #(tmstruct-M68K_RAM))
	bne.w	.away					;visitors use the other table
	moveq	#2,d1
	lea	.hl1(pc),a0					;a0 = row of .hl1 (7 words, indexed by the other team's line)
	cmpi.w	#2,(gsp).l
	bne.w	.h0						;not 3rd period: first row
	move.w	tmscore(a2),d2			;tmscore
	cmp.w	tmscore(a1),d2
	beq.w	.h0						;tied: first row
	adda.w	#$E,a0					;(adda keeps the flags of the cmp) next row ...
	bgt.w	.h0						;... if leading
	adda.w	#$E,a0					;third row if trailing
.h0									;a0 = the line order row for the score (tied, leading, trailing)
	move.w	tmline(a1),d1			;tmline
	asl.w	#1,d1
	move.w	(a0,d1.w),d0
	bsr.w	getlinee
	cmpi.w	#$C00,d0				;#(3*$1000)/4
	bls.w	.away
	move.w	(a0,d1.w),tmline(a2)	;tmline
	bra.w	.ex
.hl1								;line order table for the home team
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
.away								;a2 <> tmstruct or d0 <= $C00
	moveq	#2,d1					;try up to 3 lines in the row order
	lea	.al1(pc),a0
	cmpi.w	#2,(gsp).l
	bne.w	.a0
	move.w	tmscore(a2),d2			;tmscore
	cmp.w	tmscore(a1),d2
	beq.w	.a0						;tied or not 3rd period: first row
;CD: no cartridge twin
	adda.w	#$6,a0
	bgt.w	.a0
	adda.w	#$6,a0
.a0									;try the lines in order until one has energy over 3/4
	move.w	(a0)+,d0
	bsr.w	getlinee
	cmpi.w	#$C00,d0				;#(19*$1000)/20
	dbhi	d1,.a0					;energy above 3/4: stop, else try the next
	move.w	-(a0),tmline(a2)		;tmline
	bra.w	.ex
.al1								;line order table for the away team
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
puckfaceoff2						;face off control logic and general setup for action a3 = the puck. First
									;call sets the whole face off up (players, puck, scoreboard box, map);
									;later calls count temp1 down to the drop (updatefaceoff / Endfaceoff)
	bclr.b	#pfna,pflags(a3)		;new assignment? (clears the flag)
	beq.w	.nna					;not first time thru
	bclr.b	#2,(BA_PS_flags).l
	bclr.b	#5,(BA_PS_flags).l
	bclr.b	#0,(sflags4).l
	bclr.b	#1,(sflags4).l
	bclr.b	#0,(DelayedPen).l
	bclr.b	#1,(DelayedPen).l
	bclr.b	#2,(DelayedPen).l
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	forceblack
.p									;loop
	btst.b	#dfok,(disflags).l
	bne.w	.p
	move.w	#$3C,(holdreset).l
	tst.w	(fox).l
	bne.w	.lockinterrupts
	tst.w	(foy).l
	bne.w	.lockinterrupts
	move.w	#$FFFF,(faceoffanim).l
	bra.w	.limitcrowd
;CD: no cartridge twin
.lockinterrupts						;CD: placed where the disc branches to it
	bclr.b	#$5,$FF800F.l
.limitcrowd							;cap the crowd level
	cmpi.w	#$258,(Crowdlevel).l
	bls.w	.ntm
	move.w	#$258,(Crowdlevel).l	;limit crowd level
.ntm								;crowd level set
	bset.b	#dfclock,(disflags).l	;stop clock
	bclr.b	#sfpz,(sflags).l		;no pause
	bclr.b	#sf3llcs,(sflags3).l	;no line changes
	clr.w	(glovecords).l			;no fighting gloves
	clr.b	(iflags).l				;no icing
	st.b	(RefCnt).l				;no refs
	st.b	(puckcross2).l			;no goalie moves
	st.b	(puckcross6).l
	bclr.b	#sf2refref,(sflags2).l	;no ref refresh
	bset.b	#sf2faceoff,(sflags2).l	;face off in progress
	bset.b	#sf2drec,(sflags2).l	;dont record yet
	st.b	(passReceiverPlayerNum).l
	st.b	(onetimerplayer).l
	bset.b	#dffaceoff,(disflags).l
	bsr.w	ClrHor					;vertical ice rink
	move.w	#$2710,(crowdnoisedelay).l
	clr.w	(Vpos).l				;clear h/v pos
	clr.w	(Hpos).l
	move.w	(fox).l,(puckx).l		;puck on the face off spot (fox/foy)
	move.w	(foy).l,(pucky).l
	st.b	(puckz).l				;no visible puck
	clr.w	(puckvx).l
	clr.w	(puckvy).l
	clr.w	(puckvz).l
	st.b	(puckc).l				;nobody carries it
	movea.l	#$17A80,a0				;reposition goal nets (CD: the cartridge has
									;#(SortCords+(12*SCstruct)-M68K_RAM))
	clr.w	Xvel(a0)				;Xvel
	clr.w	Yvel(a0)				;Yvel
	clr.w	0(a0)					;Xpos
	move.w	#$10C,Ypos(a0)			;Ypos
;CD: no cartridge twin
	adda.l	#$80,a0
	clr.w	Xvel(a0)
	clr.w	Yvel(a0)
	clr.w	0(a0)
	move.w	#$FEF4,Ypos(a0)			;Ypos
	movea.l	#$17C00,a0				;move to puck shadow SCnum (CD: the cartridge has
									;#(SortCords+((puckscnum+1)*SCstruct)-M68K_RAM))
	move.w	#SPFpuck,frame(a0)
	clr.w	SPA(a0)					;SPA
	clr.w	attribute(a0)			;attribute
	clr.w	(SortCords+(puckscnum*SCstruct)+attribute).l	;clear puck SCnum attribute
	bclr.b	#sfslock,(sflags).l		;free up scrolling
	moveq	#$64,d4					;run the scroll window 101 times so it settles
.cw									;run the scroll window 101 times so it settles
	bsr.w	checkwindow				;scroll to faceoff spot
	dbf	d4,.cw
	move.w	#$3C,(yleader).l
;CD: no cartridge twin
	jsr	(ResetBench).l
	movea.l	#tmstruct,a2
	jsr	(setpersonel).l
	jsr	(forcepldata).l
	adda.w	#$366,a2
	jsr	(setpersonel).l
	jsr	(forcepldata).l
	jsr	(resetplstuff).l
	move.l	a3,-(sp)				;keep the puck pointer
	movea.l	#$17480,a3				;CD: the cartridge has #(SortCords-M68K_RAM)
	moveq	#$B,d2					;loop over the 12 players
.10									;loop over the 12 players: park them off ice, then set the faceoff spots
	move.w	#$FF10,0(a3)			;-240, Xpos
	clr.w	Ypos(a3)				;Ypos
	clr.w	frame(a3)				;frame
	move.w	position(a3),d1			;position
	bmi.w	.next					;absent
	beq.w	.goalie1				;goalie: no assignment change
	moveq	#$16,d0					;#afaceoff - assignment faceoff
	cmpi.w	#4,d1					;find the center (position 4)
	bne.w	.11
	movea.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
	btst.b	#pfteam,pflags(a3)		;#pfgoal - what goal to score on
	beq.w	.clr
	adda.w	#tmsize,a2
.clr								;clear the touches
	clr.w	tmtouch1(a2)
	move.b	pnum(a3),tmtouch1+1(a2)	;this player is the last touch
	bclr.b	#7,(sflags8).l
	st.b	tmtouch2(a2)			;clear last player to touch puck (assist 1)
	st.b	tmtouch3(a2)			;clear second last player to touch puck (assist 2)
	bclr.b	#tmflast,tmflags(a2)
	moveq	#$17,d0					;#afaceoffpl - faceoff player assignment
.11									;player position
	bsr.w	assinsert
.goalie1							;d4 = active players of this player's team
	move.w	(tmstruct+tmap).l,d4	;tmap = active players on ice (4-6). (tmap).w
	btst.b	#pfteam,pflags(a3)		;#pfteam - 0=home 1=away
	beq.w	.t0
	move.w	(awtmstruct+tmap).l,d4	;(tmsize).w
.t0									;players to place
	neg.w	d4						;d4 = 6 - active players: formation row
	addi.w	#6,d4					;6 - active players
	asl.w	#3,d4					;8 bytes per row of .apl
	movea.l	#.apl,a1
	adda.w	d4,a1					;row for this team size ...
	move.b	(a1,d1.w),d4
	asl.w	#2,d4
	movea.l	#.ptab,a1
	move.w	(a1,d4.w),d0
	move.w	$2(a1,d4.w),d1
	btst.b	#pfgoal,pflags(a3)		;#pfgoal - 0=bottom, 1=top
	bne.w	.f0
	neg.w	d0						;mirror for the team shooting the other way
	neg.w	d1
.f0									;coordinates for his end
	tst.w	position(a3)			;check for goalie
	beq.w	.goalie2
	cmpi.w	#8,d4
	bgt.w	.nodef					;slots above 2 are not shifted by the spot
	move.w	(fox).l,d3
	eor.w	d0,d3
	bpl.w	.notmid					;fox and slot x on the same side
	move.w	(foy).l,d3
	asr.w	#3,d3
	sub.w	d3,d1					;opposite side: also pull y toward the spot
.notmid								;pull the slot x toward the faceoff spot
	move.w	(fox).l,d3				;pull x toward the spot by fox/4
	asr.w	#2,d3
	sub.w	d3,d0
.nodef								;set the position
	add.w	(fox).l,d0
	add.w	(foy).l,d1
.goalie2							;place the player at the slot plus the spot
	move.w	d0,0(a3)				;Xpos
	move.w	d1,Ypos(a3)				;Ypos
	clr.w	Xvel(a3)				;Xvel
	clr.w	Yvel(a3)				;Yvel
	sub.w	(puckx).l,d0
	sub.w	(pucky).l,d1
	neg.w	d0
	neg.w	d1
	bsr.w	vtoa					;face the direction from the puck to the player
	move.w	d0,facedir(a3)			;facedir
	bclr.b	#pf2unav,pflags2(a3)	;#pf2unav
	bclr.b	#pfalock,pflags(a3)		;#pfalock
	move.w	#SPAglide,d1
	bsr.w	SetSPA					;glide animation
;CD: no cartridge twin
.next								;CD: placed where the disc branches to it
	adda.l	#$80,a3
	dbf	d2,.10
	jsr	(SprSort).l
	movea.l	(sp)+,a3
	bsr.w	ResetAndSelectPlayers
	move.w	(ExtraChars).l,d4
;CD: no cartridge twin
	movea.l	(FaceOffMapPtr).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,$18D4C.l
	movea.l	(FaceOffSpritesPtr).l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain
	move.w	#$FFFF,(arenaanim).l
	btst.b	#0,(sflags7).l
	beq.w	.drawfaceoffwindow
	move.w	(faceoffanim).l,d0
	bmi.w	.drawfaceoffwindow
	jsr	(StartArenaAnim).l
.drawfaceoffwindow					;draw the faceoff window
	bsr.w	printz
	dc.b	0,6,$FF,0,0,0
	moveq	#$36,d0					;X Position of the faceoff window
	tst.w	(fox).l
	bpl.w	.fok
	move.w	#$BE,d0					;(18*8)+46
.fok								;faceoff X set
	move.w	d0,(fodropx).l			;drop box x: left or right depending on the sign of fox
	subi.w	#$2E,d0
	asr.w	#3,d0
	move.w	d0,(printx).l			;print column = (x - 46) / 8
	moveq	#$5C,d0					;Y position of the faceoff window
	move.w	d0,(fodropy).l
	subi.w	#$44,d0
	asr.w	#3,d0
	move.w	d0,(printy).l			;print row = (y - 68) / 8
	move.w	(ExtraChars).l,d4		;space for faceoff map
;CD: no cartridge twin
	movea.l	(FaceOffMapPtr).l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0						;d0/d1 = 0, d2/d3 = $C/$A (dobitmap size arguments)
	clr.w	d1
	moveq	#$C,d2
	moveq	#$A,d3
	moveq	#0,d5
	bset.b	#0,(sflags6).l
	bsr.w	dobitmap
	bclr.b	#0,(sflags6).l
	tst.w	(OptLine).l
	bne.w	.setdroptime
	bsr.w	printsmallz
	String	CC_AddY,$A,CC_SetAttribute,4	;$FBC2. ori.b #$A,d6 and drops the $FE04 word
	moveq	#$C,d0					;frame the line names box (Framer args d0 = $C, d1 = 3)
	moveq	#3,d1
	bsr.w	Framer
	move.w	(tmstruct+tmline).l,d0	;d0/d1 = current lines of home / visitors
	move.w	(awtmstruct+tmline).l,d1
	btst.b	#gmdir,(gmode).l
	bne.w	.printline2
	exg	d0,d1
.printline2							;print the line names
	bsr.w	printsmallz
	String	CC_AddX,1,CC_AddY,$FE
	movea.l	#linelist,a1
	bsr.w	Fprintsmall				;first line name (d0)
	addi.w	#4,(printx).l
	move.w	d1,d0
	movea.l	#linelist,a1
	bsr.w	Fprintsmall				;second line name (d1)
.setdroptime						;drop time
	move.w	#$78,d0					;random time before the puck drop
	bsr.w	randomd0				;0-$77
	addi.w	#$B4,d0					;$B4-$12B frames until the drop
	cmpi.w	#0,(arenaanim).l
	beq.w	.chkmintime
	cmpi.w	#1,(arenaanim).l
	beq.w	.chkmintime
	cmpi.w	#5,(arenaanim).l
	beq.w	.chkmintime
	cmpi.w	#4,(arenaanim).l
	beq.w	.chkmintime
	cmpi.w	#2,(arenaanim).l
	bne.w	.time
.chkmintime							;an arena animation is running: wait at least $10E frames
	cmpi.w	#$10E,d0
	bgt.w	.time
	move.w	#$10E,d0				;sets minimum value in d0 to 10E
.time								;set the drop time
	move.w	d0,temp1(a3)			;time for puck drop
	move.w	#$18,(palcount).l
	movea.l	#fofdata2,a0			;second half of the big face off sprite data
	move.w	#1,(a0)
	move.w	#$8000,foattr(a0)
	move.w	#4,fosize+foframe(a0)
	move.w	#$A800,fosize+foattr(a0)
	move.w	#7,2*fosize+foframe(a0)	;frame of ref
	move.w	#$8000,2*fosize+foattr(a0)
	btst.b	#gmdir,(gmode).l		;#gmdir - 0 = home team goes up
	bne.w	.nfl
	eori.w	#$800,foattr(a0)		;flip attribute bit $800 (two of the sprites) when gmdir is clear
	eori.w	#$800,fosize+foattr(a0)
.nfl								;draw the faceoff sprites
	move.w	#$FFFF,$17EE6.l			;-1 (CD: the cartridge has (fodir1).w)
	move.w	#$FFFF,$17EE8.l			;-1 (CD: the cartridge has (fodir2).w)
	jsr	(LeadSong).l
	bclr.b	#6,(sflags8).l
	bne.w	.playqueuedsong
	bclr.b	#4,(sflags8).l
	beq.w	.restorestate
.playqueuedsong						;play the queued song
	bclr.b	#4,(sflags8).l
	move.w	(SongNum).l,-(sp)
	bsr.w	song
.restorestate						;restore the state
	move.w	#$18,(palcount).l
;CD: no cartridge twin
	bset.b	#$5,$FF800F.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.nna								;pfna was clear
	subi.w	#1,temp1(a3)
	bpl.w	updatefaceoff
	jsr	(EndArenaAnim).l
	bra.w	X_358D4					;CD: the cartridge has Endfaceoff
.apl	dc.b	0
	dc.b	1,2,3,4,5,6,0,0,1,5,3,4,2,0,0,0
	dc.b	3,5,1,4,0,0,0
.ptab								;faceoff slot offsets by position (x, y pairs)
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
ResetAndSelectPlayers				;c1playernum / c2playernum = -1, then changeplayer for each human team
	move.w	#$FFFF,(c1playernum).l
	move.w	#$FFFF,(c2playernum).l
	tst.w	(cont1team).l
	beq.w	.checkcont2
	clr.w	d4
	bsr.w	changeplayer
.checkcont2							;pad 2
	tst.w	(cont2team).l
	beq.w	.checkcont3
	moveq	#2,d4
	bsr.w	changeplayer
.checkcont3							;pads 3 and 4
	tst.w	(cont3team).l
	beq.w	.checkcont4
	move.w	(cont1team).l,-(sp)
	move.w	(cont3team).l,(cont1team).l
	move.w	(c1playernum).l,-(sp)
	move.w	#$FFFF,(c1playernum).l
	clr.w	d4
	jsr	(changeplayer).l
	move.w	(c1playernum).l,(c3playernum).l
	move.w	(cont1team).l,(cont3team).l
	move.w	(sp)+,(c1playernum).l
	move.w	(sp)+,(cont1team).l
.checkcont4							;restore pad 4
	tst.w	(cont4team).l
	beq.w	.exit
	move.w	(cont2team).l,-(sp)
	move.w	(cont4team).l,(cont2team).l
	move.w	(c2playernum).l,-(sp)
	move.w	#$FFFF,(c2playernum).l
	move.w	#2,d4
	jsr	(changeplayer).l
	move.w	(c2playernum).l,(c4playernum).l
	move.w	(cont2team).l,(cont4team).l
	move.w	(sp)+,(c2playernum).l
	move.w	(sp)+,(cont2team).l
.exit								;exit (also the end of the code above)
	rts
updatefaceoff						;a3 = puck. Drop animation frame from temp1; at 0 erases the faceoff box
	move.w	temp1(a3),d0			;frames left until the drop
	beq.w	.erase					;0: remove the face off box
	addi.w	#6,d0
	lsr.w	#3,d0					;(temp1 + 6) / 8
	cmpi.w	#2,d0
	bgt.w	rtss2
	neg.w	d0
	addi.w	#$A,d0					;frame $A - d0 (8 to 10) as the drop approaches
	move.w	d0,(fofdata).l			;+8
	rts
.erase								;d0 = 0
	bclr.b	#dffaceoff,(disflags).l
	bsr.w	printz
	String	CC_Font1Pri,0,0,0
	move.w	(fodropx).l,d0
	subi.w	#$2E,d0
	asr.w	#3,d0
	move.w	d0,(printx).l			;same print column as in puckfaceoff2
	moveq	#$64,d0					;(4*8)+68, overwritten (as in 92)
	move.w	(fodropy).l,d0
	subi.w	#$44,d0
	asr.w	#3,d0
	move.w	d0,(printy).l
	moveq	#$C,d0					;eraser: d0/d1 = x/y size, d2 = fill char word
	moveq	#$D,d1
	move.w	#$7FF,d2
	bra.w	eraser
;CD: no cartridge twin
	movea.l	#$BBD30,a0
	move.w	(Sattsize).l,d0
	move.w	(VSPRITES).l,d1
	jsr	(DoDMA).l
Endfaceoff							;drop the puck: pick the faceoff winner and send the puck off
	move.w	#SFXpuckice+3,-(sp)		;SFXpuckice
	bsr.w	sfx
	bclr.b	#sf2faceoff,(sflags2).l	;face off over
	move.w	#$3C,(holdreset).l
	move.w	(ExtraChars).l,d4
;CD: no cartridge twin
	movea.l	(RefsMapPtr).l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain	;ref cam chars
	bclr.b	#sf2drec,(sflags2).l	;replay recording may start
	bclr.b	#gmclock,(gmode).l		;start the game clock
	bclr.b	#pf2fight,pflags2(a3)
	clr.w	(crowdnoisedelay).l
	bset.b	#sf3fo,(sflags3).l		;flag the faceoff drop
	move.w	$17EE6.l,d3				;figure out who won face off (CD: the cartridge has (fodir1).w)
	move.w	#$800,d4				;d4 = y velocity added to the puck: +$800 ...
	movea.l	#.ftab,a0
	movea.l	#$17CF8,a1				;a1 = the two face off sprite records (CD: the cartridge has
									;#(fofdata2-M68K_RAM))
	moveq	#$10,d2
	move.w	(a1),d1					;first record's word 0 (index into .ftab, 1-based)
	sub.b	-$1(a0,d1.w),d2			;d2 = $10 - .ftab[first] ...
	move.w	fosize+foframe(a1),d1
	add.b	-$1(a0,d1.w),d2			;... + .ftab[second]
	moveq	#$21,d0
	bsr.w	randomd0				;random 0-$20
	cmp.b	d0,d2
	bls.w	.p1won					;d2 <= random: stay with the first record
;CD: no cartridge twin
	adda.w	#$4,a1
.p1won								;faceoff record chosen
	btst.b	#3,foattr(a1)			;bit 3 of the winner's attribute word ($800 flips)
	beq.w	.pos
	move.w	$17EE8.l,d3				;visiting player won: use his pull direction ... (CD: the cartridge has
									;(fodir2).w)
	neg.w	d4						;... and push the puck the other way (-$800)
.pos								;d0 = the winner's pull direction (bit 3 = none: random)
	move.w	d3,d0					;d0 = winner's pull direction; bit 3 set = no joystick
	btst	#3,d0
	bne.w	.nojoy
	andi.w	#7,d0
;CD: no cartridge twin
.L35990
	btst.b	#$7,$FF800E.l
	bne.s	.L35990
	move.w	#$1B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L359AA
	btst.b	#$6,$FF800E.l
	beq.s	.L359AA
	move.w	$FF8010.l,d1
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L359CA
	btst.b	#$6,$FF800E.l
	bne.s	.L359CA
	bclr.b	#$7,$FF800F.l
	andi.w	#3,d1
	bne.w	.nj2					;3 in 4: use his direction as is
.nojoy								;random direction
	moveq	#5,d0					;no direction (or 1 in 4): random 0-4 ...
	bsr.w	randomd0
	subi.w	#2,d0
	andi.w	#7,d0					;... minus 2, wrapped to 0-7
	tst.w	d4
	bmi.w	.nj2
	eori.w	#4,d0					;home won: turn the direction around
.nj2								;faceoff direction set
	asl.w	#2,d0
	movea.l	#dirtab,a0
	move.w	(a0,d0.w),d1
	asl.w	#5,d1
	move.w	d1,Xvel(a3)				;puck x velocity = dirtab x * 32
	move.w	$2(a0,d0.w),d1
	asl.w	#5,d1
	add.w	d4,d1
.setpuckvy							;puck y velocity from dirtab, then a random lift
	move.w	d1,Yvel(a3)				;puck y velocity = dirtab y * 32 +- $800
	move.w	#$800,d0
	bsr.w	randomd0
	move.w	d0,Zvel(a3)				;random upward velocity 0-$7FF
	clr.w	(puckz).l				;puck now at ice level (visible)
	bclr.b	#pfnc,pflags(a3)		;collisions on
	moveq	#$18,d0					;pucknorm
	bra.w	assreplace
.ftab								;direction offsets into dirtab for the faceoff pull
	dc.b	0,8,$10,0,8,$10
;CD: no cartridge twin
	addi.w	#$1,(gsp).l
	bchg.b	#$1,(gmode).l
	cmpi.w	#$3,(gsp).l
	blt.w	.L35A90
	beq.w	.L35A78
	move.w	#$3,(gsp).l
	tst.w	(OptPlayMode).l
	bne.w	.L35A78
	move.w	#$4,(gsp).l
.L35A78
	move.w	(HmGoals).l,d0
	sub.w	(AwGoals).l,d0
	beq.w	.L35A90
	move.w	#$4,(gsp).l
.L35A90
	bsr.w	forceblack
	jsr	(ResetClock).l
	move.w	#$79,-(sp)
	bsr.w	song
	bsr.w	UpdateScores
	cmpi.w	#$4,(gsp).l
	bne.w	.L35AB8
	jsr	(AddPlayoffTeamStats).l
.L35AB8
	bsr.w	Intermission
	cmpi.w	#$4,(gsp).l
	beq.w	.L35ACE
	jmp	$2BA1E.l
.L35ACE
	jmp	(GameOver).l
; assignment for puck most of the time
; a3 = puck
; d7 = elapse frames since last call
pucknorm							;assignment for puck most of the time. a3 = puck, d7 = elapse frames since
									;last call
	btst.b	#2,(BA_PS_flags).l		;check if flag is clear (normal play)
	beq.w	.normalplay
	bsr.w	UpdatePenaltyShotEnd
.normalplay							;normal play
	bclr.b	#pfna,pflags(a3)		;#pfna clear
	beq.w	.nna
	clr.w	temp1(a3)				;temp1
	move.w	#$78,temp2(a3)			;temp2
.nna								;count down the timer
	movea.l	#$17E36,a1				;table for puck crossing lines (CD: the cartridge has
									;#(puckcross-M68K_RAM))
	sub.w	d7,pcframes(a1)			;sub elapse frames from time til crossing
	sub.w	d7,pcsize+pcframes(a1)
	sub.w	d7,temp1(a3)			;temp1
	bpl.w	.0
	addi.w	#5,temp1(a3)
	bsr.w	findpc
.0									;puck carried: the puck follows the carrier's stick
	move.w	(puckc).l,d0			;is the puck carried?
	bmi.w	.nothandled				;loose puck
	asl.w	#scsize,d0				;#scsize
	movea.l	#$17480,a2				;CD: the cartridge has #(SortCords-M68K_RAM)
	adda.w	d0,a2					;a2 = the puck carrier
	bsr.w	a2touchpuck
	move.l	a2,-(sp)				;GetHot takes the structure address on the stack
	bsr.w	GetHot					;d0/d1 = hot spot of the carrier
	add.w	0(a2),d0				;Xpos - bungie the puck towards the hot spot on player a2
	sub.w	0(a3),d0
	asr.w	#2,d0					;move a quarter of the distance per call
	add.w	d0,0(a3)
	add.w	Ypos(a2),d1				;Ypos
	sub.w	Ypos(a3),d1
	asr.w	#2,d1
	add.w	d1,Ypos(a3)
	move.w	Xvel(a2),Xvel(a3)		;Xvel
	move.w	Yvel(a2),Yvel(a3)		;Yvel
.nothandled							;done
	bsr.w	PuckIChk				;icing check
	bsr.w	ChkOffsides				;offsides check
	btst.b	#gmclock,(gmode).l		;check for play stoppage
	bne.w	.end
	tst.w	(puckc).l
	bpl.w	.resetstilltimer
	move.w	0(a3),d0				;Xpos
	cmp.w	OldXpos(a3),d0			;oldXpos
	bne.w	.resetstilltimer
	move.w	Ypos(a3),d0				;Ypos
	cmp.w	OldYpos(a3),d0			;oldYpos
	bne.w	.resetstilltimer
	moveq	#6,d0
	subi.w	#1,temp2(a3)			;temp3
.maybepenalty						;still puck timer out: whistle (penalty number 6)
	bpl.w	.stillpuckdone
	bsr.w	AddPenalty2
.stillpuckdone						;puck has moved or the penalty is in: on to the collision checks
	bra.w	.end
.resetstilltimer					;puck moved: restart the still puck timer (120 frames)
	move.w	#$78,temp2(a3)			;move 78 hex into temp2
.end								;puck in the air or above the ice: collision checks
	tst.b	Zvel(a3)				;Zvel
	bne.w	checkpuckcoll
	tst.w	Zpos(a3)				;Zpos
	bne.w	checkpuckcoll
	bsr.w	puckunflip				;on the ice and not rising: stop the spin
	bra.w	checkpuckcoll
;	Helpers from PuckIChk to WeightedRandomSelect: puck flipping, skating, assignment lists and
;	acceleration. remap follows.
;
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp /
;	cmpi; fixopcodes.js patches the cmp encoding after assembly.

;SortCords offsets: Xpos 0, attribute 4, Ypos $14, Zpos $18, Xvel $28, Yvel $2A, position $34
;SCnum $52, facedir $54, SPA $58, SPAnum $5A, SPAcnt $5C, pflags $62, pflags2 $63.

ChkOffsides							;check for offsides penalty. a3 = puck. Flags the whole team
	btst.b	#gmoffs,(gmode).l
	beq.w	rtss2
	btst.b	#2,(BA_PS_flags).l
	bne.w	rtss2
	movea.l	#$1834C,a1				;CD: the cartridge has #(tmstruct-M68K_RAM)
	lea	tmsize(a1),a2				;team 2 (tmsize)
	bsr.w	ClearOffsidesIfAllPlayers	;first drop the flag of any team with no one over the line
	exg	a1,a2
	bsr.w	ClearOffsidesIfAllPlayers
	move.w	#$54,d0
	cmp.w	Ypos(a3),d0
	bgt.w	.neg					;puck y < Blueline-4: go to the bottom line test
	cmp.w	OldYpos(a3),d0			;OldYpos: puck crossed the top line this frame?
	ble.w	rtss2
	addi.w	#$A,d0					;d0 = Blueline+6: players must be past this
	btst.b	#gmdir,(gmode).l		;pick which team is attacking this end
	beq.w	.t0
;CD: no cartridge twin
	exg	a1,a2
.t0									;CD: placed where the disc branches to it
	moveq	#$5,d2
	movea.l	$22(a2),a0
.0									;loop over the team: anyone past the blue line?
	tst.w	position(a0)			;position: skip off ice
	bmi.w	.1
	cmp.w	Ypos(a0),d0
	bge.w	.1						;not past the line
	bset.b	#tmfoside,tmflags(a2)	;player past the line: team offsides
	rts
.1									;next player
	adda.w	#SCstruct,a0			;next player
	dbf	d2,.0
	rts
.neg								;bottom blue line: the same test mirrored
	neg.w	d0
	cmp.w	Ypos(a3),d0
	blt.w	rtss2
	cmp.w	OldYpos(a3),d0
	bge.w	rtss2
	subi.w	#$A,d0
	btst.b	#gmdir,(gmode).l
	bne.w	.t1
;CD: no cartridge twin
	exg	a1,a2
.t1									;CD: placed where the disc branches to it
	moveq	#$5,d2
	movea.l	$22(a2),a0
.2									;loop over the team (bottom line)
	tst.w	position(a0)			;loop over the team's players (bottom line)
	bmi.w	.3
	cmp.w	Ypos(a0),d0
	ble.w	.3						;not past the line
	bset.b	#tmfoside,tmflags(a2)	;team offsides
	rts
.3									;next player
	adda.w	#SCstruct,a0			;next player
	dbf	d2,.2
	rts
ClearOffsidesIfAllPlayers			;a2 = team struct: clear the team offsides flag once no skater is past the
									;line
	btst.b	#tmfoside,tmflags(a2)
	beq.w	rtss2
;CD: no cartridge twin
	movea.l	$22(a2),a0
	moveq	#5,d1
.top								;loop: d0 = each player's y toward the goal he shoots at
	tst.w	position(a0)			;position: off ice keeps the last d0
	bmi.w	.next
	move.w	Ypos(a0),d0				;d0 = y toward the goal this player shoots at
	btst.b	#pfgoal,pflags(a0)
	bne.w	.next
	neg.w	d0
.next								;next player; stop when one is past the line
	adda.w	#SCstruct,a0
	cmpi.w	#$58,d0
	dbgt	d1,.top
	bgt.w	rtss2
	bclr.b	#tmfoside,tmflags(a2)
	rts
a2offsides							;player a2 touched the puck: offsides penalty if his team is flagged and
									;the puck is past the blue line
	btst.b	#gmoffs,(gmode).l
	beq.w	rtss2
	move.w	(pucky).l,d0			;puck y toward the goal a2 shoots at
	btst.b	#pfgoal,pflags(a2)
	bne.w	.0
	neg.w	d0
.0									;Y for his end
	cmpi.w	#$68,d0
	blt.w	rtss2
	movea.l	#$1834C,a0				;a0 = a2's team struct (CD: the cartridge has #(tmstruct-M68K_RAM))
	btst.b	#pfteam,pflags(a2)
	beq.w	.1
	adda.w	#tmsize,a0
.1									;team struct chosen
	btst.b	#tmfoside,tmflags(a0)
	beq.w	rtss2
	btst.b	#gmhl,(gmode).l
	bne.w	rtss2
	exg	a2,a3
	moveq	#$10,d0
	bsr.w	AddPenalty
	exg	a2,a3
	rts
; player a2 touches puck
; look for penalties/offsides/other junk
a2touchpuck							;player a2 touches puck. Look for penalties/offsides/other junk. Called
									;from pucknorm, puckstick and others
	move.w	0(a2),(ltx).l			;move Xpos to last touch X
	move.w	Ypos(a2),(lty).l		;move Ypos to last touch Y
	move.w	SCnum(a2),(ltplayer).l	;move SCnum to last touch player
	movea.l	#$1834C,a0				;move Home Shots into a0 (CD: the cartridge has #(tmstruct-M68K_RAM))
	btst.b	#pfteam,pflags(a2)		;check if home or away
	beq.w	.t						;branch if home
	lea	tmsize(a0),a0				;add to a0 if away
.t									;team struct chosen
	clr.w	d0
	move.b	pnum(a2),d0				;move pnum into d0
	btst.b	#pf3onetimer,pflags3(a2)	;check if one timer
	beq.w	.checklast				;branch if not
	bset.b	#7,(sflags8).l			;set if one timer
.checklast							;last touch
	cmp.w	tmtouch1(a0),d0			;already the last touch?
	beq.w	.same					;branch if equal
	bclr.b	#tmflast,tmflags(a0)	;clear bit 3
	bne.w	.st						;branch if not cleared before
	move.w	tmtouch2(a0),tmtouch3(a0)	;first assist becomes second assist
	move.w	tmtouch1(a0),tmtouch2(a0)	;last touch becomes first assist
.st									;scorer and assists set
	move.w	d0,tmtouch1(a0)			;this player is the last touch
	cmp.w	tmtouch3(a0),d0			;also the second assist?
	bne.w	.same					;branch if not
	st.b	tmtouch3(a0)			;then clear the second assist
.same								;assists updated: clear the shot flag, then offside and icing checks
	bclr.b	#sf2shot,(sflags2).l	;clear shot taken
	bsr.w	a2offsides
	btst.b	#ifok,(iflags).l		;check if icing
	beq.w	.notice					;branch if not
	btst.b	#ifcgl,(iflags).l		;test if crossed goalline
	beq.w	.notice					;branch if not
	tst.w	position(a2)			;check if goalie
	beq.w	.notice					;branch if so
	btst.b	#ifdir,(iflags).l		;check if must cross top line
	bne.w	.up						;branch if so
	btst.b	#pfgoal,pflags(a2)		;check if top or bottom shooting goal
	beq.w	.notice					;branch if bottom
.icing								;loop
	clr.w	d0
	move.b	(icingPlayer).l,d0		;move iflags+1 into d0
	asl.w	#7,d0
	move.l	a3,-(sp)				;push on stack
	movea.l	#$17480,a3				;CD: the cartridge has #(SortCords-M68K_RAM)
	adda.w	d0,a3					;a3 now player struct
	move.w	#PenIcing,d0
	bsr.w	AddPenalty
	movea.l	(sp)+,a3
	rts
.up									;ifdir set
	btst.b	#pfgoal,pflags(a2)		;check top or bottom shooting goal
	beq.w	.icing					;branch if bottom
.notice								;start a new icing check from where this player touched the puck
	clr.b	(iflags).l				;start over: clear the icing state
	move.b	SCnum+1(a2),(icingPlayer).l	;move SCnum+1 into icingPlayer
	move.w	(pucky).l,d0			;move pucky into d0
	btst.b	#pfgoal,pflags(a2)		;check if shooting up or down
	beq.w	.0						;branch if down
	bset.b	#ifdir,(iflags).l		;set icing direction up
	neg.w	d0						;negate d0
.0									;icing check
	bmi.w	rtss2					;exit if minus
	move.w	(tmstruct+tmap).l,d0	;(tmap).w
	sub.w	(awtmstruct+tmap).l,d0	;(tmsize).w
	btst.b	#pfteam,pflags(a2)		;check home or away
	beq.w	.1						;branch if home
	neg.w	d0						;negate d0
.1									;icing for his team
	bmi.w	rtss2					;exit if minus
	bset.b	#ifok,(iflags).l		;set icing flag
	rts
; check for icing of puck penalty
PuckIChk							;check for icing of puck penalty. Called from pucknorm
	btst.b	#ifok,(iflags).l		;#ifok
	beq.w	rtss2
	btst.b	#ifcgl,(iflags).l		;#ifcgl - if crossed goal line
	bne.w	rtss2
	tst.w	(puckc).l
	bpl.w	rtss2
	move.w	#Blueline+goalline,d0	;goalline
	btst.b	#ifdir,(iflags).l		;#ifdir - 1 = must cross top line
	bne.w	.0
	neg.w	d0						;other direction: d0 = -(goal line y)
	cmp.w	(pucky).l,d0			;check other goalline
	bgt.w	.chkx					;puck y reached the goal line
	rts
.0									;ifdir set
	cmp.w	(pucky).l,d0
	bgt.w	rtss2
.chkx								;check the X
	cmpi.w	#$2C,(puckx).l			;2C - edge of crease
	bgt.w	.set
	cmpi.w	#$FFD4,(puckx).l		;FFD4 - edge of crease
	blt.w	.set
	bclr.b	#ifok,(iflags).l		;#ifok cleared
	rts
.set								;puck within the crease width: icing goes on to the goal line check
	bset.b	#ifcgl,(iflags).l		;#ifcgl
	rts
; stop spinning puck
; a3 = puck
puckunflip							;stop spinning puck. a3 = puck. Entered from
									;pucknothing, called from pucknorm
	cmpi.w	#8,SPAnum(a3)			;2*4 SPAnum
	blt.w	.k
	cmpi.w	#$18,SPAnum(a3)			;6*4
	bge.w	.k
	eori.w	#2,facedir(a3)			;facedir
.k									;set facedir bit 2 (puck lies flat) and stop the spin animation
	ori.w	#4,facedir(a3)			;facedir bit 2 set
	clr.w	SPAnum(a3)				;SPAnum
	st.b	SPAcnt(a3)				;SPAcnt
	rts
; start puck spinning
; a3 = puck
puckflip							;start puck spinning. a3 = puck, d0 bit 0 = flip. Called from checkgoal,
									;wallcoll and others
	andi.w	#1,d0
	eor.w	d0,facedir(a3)			;facedir
	andi.w	#3,facedir(a3)			;keep 0-3
	st.b	SPAcnt(a3)				;SPAcnt
	move.w	#SPApflip,d1
	bra.w	SetSPA					;start the puck flip animation
; assignment for puck shadow
; a3 = puck shadow
puckshadow							;assignment for puck shadow. a3 = puck shadow (struct after the puck)
	cmpi.w	#SPFpuck,frame(a3)
	bne.w	.siren					;shadow turns into siren on goals
	move.w	Xpos-SCstruct(a3),0(a3)	;Xpos-SCstruct, Xpos
	move.w	Ypos-SCstruct(a3),Ypos(a3)	;Ypos-SCstruct, Ypos
	clr.w	Zpos(a3)				;Zpos
	moveq	#Ypos,d0				;Ypos
	btst.b	#sfhor,(sflags).l		;#sfhor - check if horizontal mode
	beq.w	.nhor
	moveq	#Xpos,d0				;Xpos
.nhor								;coordinate chosen
	addi.w	#1,(a3,d0.w)
	rts
.siren								;the goal light: only when it is lit
	tst.w	frame(a3)				;frame
	beq.w	rtss2
	clr.w	0(a3)					;Xpos
	move.w	#$12C,Ypos(a3)			;Ypos
	move.w	#$E,Zpos(a3)			;Zpos
	tst.w	Ypos-SCstruct(a3)		;Ypos-SCstruct
	bpl.w	.s0						;puck y >= 0: siren at the top, as set
	move.w	#$8000,attribute(a3)	;attribute
	neg.w	Ypos(a3)				;Ypos
	subi.w	#1,Zpos(a3)				;Zpos
.s0									;exit (also the end of the code above)
	rts
; find puck crossing lines
; calculate when puck will cross goalline (if at all)
findpc								;find puck crossing lines: calculate when puck will cross goalline (if at
									;all). Called from pucknorm fills puckcross (2 entries of x word, time
									;word): top goal line first, then bottom
	movem.l	d0-d4/a1-a2,-(sp)
	movea.l	#$17E36,a1				;CD: the cartridge has #(puckcross-M68K_RAM)
	move.w	#Sideline,d1			;sideline - distance from center to side boards
	move.w	#$108,d4				;goaline
	bsr.w	.calc					;top goal line (y = d4)
	neg.w	d4						;make d4 negative to check bottom goal line
	bsr.w	.calc					;bottom goal line (y = -d4)
	movem.l	(sp)+,d0-d4/a1-a2
	rts
.calc								;local subroutine
	move.w	d4,d0					;move goaline into d0
	sub.w	(pucky).l,d0			;sub pucky from d0
	tst.w	(puckvy).l				;check puckvy
	beq.w	.nocross				;branch if 0
	move.w	d0,d2					;move d0 into d2
	swap	d2						;swap upper and lower word of d2
	clr.w	d2						;clear bottom word of d2
	asr.l	#4,d2					;shift 4 bits right (divide by 16)
	divs.w	(puckvy).l,d2			;divide puckvy into d2
	bmi.w	.nocross				;branch if negative
	move.w	d2,pcframes(a1)			;time until crossing in frames (puckcross y)
	muls.w	(puckvx).l,d0			;mult puckvx with d0
	divs.w	(puckvy).l,d0			;divide puckvy into d0
	bvs.w	.nocross				;branch if overflow set
	add.w	(puckx).l,d0			;add puckx to d0
	cmp.w	d1,d0					;compare d1 (sideline) to d0
	blt.w	.o1						;branch if less than (in play)
	neg.w	d0						;negate d0
	add.w	d1,d0					;add d1 3 times to d0
	add.w	d1,d0
	add.w	d1,d0
.o1									;offset added
	neg.w	d1						;negate d1
	cmp.w	d1,d0					;compare d1 (other sideline) to d0
	bgt.w	.o2						;branch if greater than (in play)
	neg.w	d0						;negate d0
	add.w	d1,d0					;add d1 to d0 3 times
	add.w	d1,d0
	add.w	d1,d0
.o2									;offset added
	neg.w	d1						;negate d1
	move.w	d0,(a1)					;move d0 into puckcross
	bra.w	.next
.nocross							;puck does not reach this goal line
	move.w	#$FFFF,pcframes(a1)		;move -1 into puckcross y
;CD: no cartridge twin
.next								;CD: placed where the disc branches to it
	adda.w	#$4,a1
	rts
; a0 = extra routine for collision avoidance
; d0/d1 = x/y coord to skate to
; d7 = elapsed frames
skateto								;a0 = extra routine for collision avoidance, d0/d1 = x/y cord to skate to,
									;d7 = elapse frames
	sub.b	d7,temp2(a3)			;sub d7 from temp2
	bpl.w	.ex						;exit if not 0 or less
	addi.b	#$C,temp2(a3)			;add 12 - only execute every 12 frames
	bsr.w	avdgoal					;avoid the goal nets
	movem.w	d0-d1,-(sp)				;no deltax/deltay test
	move.w	Xvel(a3),d0				;Xvel
	asr.w	#8,d0					;divide by 256
	neg.w	d0						;make negative
	add.w	(sp)+,d0				;add new x coord from stack
	sub.w	0(a3),d0				;sub Xpos
	move.w	Yvel(a3),d1				;Yvel
	asr.w	#8,d1					;divide by 256
	neg.w	d1						;make negative
	add.w	(sp)+,d1				;add new y coord from stack
	sub.w	Ypos(a3),d1				;sub Ypos
	cmpi.w	#$C,d0					;compare 12 to d0
	bgt.w	.vt
	cmpi.w	#$FFF4,d0				;cmp -12
	blt.w	.vt
	cmpi.w	#$C,d1					;compare 12 to d1
	bgt.w	.vt
	cmpi.w	#$FFF4,d1				;cmp -12
	blt.w	.vt
	moveq	#9,d0					;close enough: no direction
	bra.w	.nvt
.vt									;direction to the target
	bsr.w	vtoa
.nvt								;let the extra routine (a0) change the direction
	jsr	(a0)						;extra collision routine
	move.b	d0,temp2+1(a3)			;move d0 into temp2+1
	cmpi.w	#7,d0					;compare to 7
	ble.w	.ex						;a real direction: go accelerate
	move.w	Xvel(a3),d0				;Xvel
	or.w	Yvel(a3),d0				;Yvel
	bne.w	.ex						;still moving
	move.w	(puckx).l,d0			;move puckx into d0
	move.w	(pucky).l,d1			;move pucky into d1
	btst.b	#pf2fight,(puck_pflags2).l	;#pf2fight, puckx+pflags2
	beq.w	.nf
	move.w	(xc1).l,d0				;scroll lock x coord
	move.w	(yc1).l,d1				;scroll lock y coord
.nf									;scroll to the target
	sub.w	0(a3),d0				;Xpos
	sub.w	Ypos(a3),d1				;Ypos - face towards puck
	bsr.w	vtoa
	sub.w	facedir(a3),d0			;facedir
	beq.w	.ex						;already facing it
	neg.w	d0
	andi.w	#4,d0
	lsr.w	#1,d0					;divide by 2
	subi.w	#1,d0					;+1/-1: one step in the shorter turn direction
	add.w	facedir(a3),d0			;facedir
	andi.w	#7,d0
	move.w	d0,facedir(a3)			;facedir
.ex									;accelerate in the stored direction
	clr.w	d0						;d0 = stored direction
	move.b	temp2+1(a3),d0			;temp2+1
	bra.w	doplayeracc				;accelerate that way
; Don't try to skate through goal
; If d0/d1 coords intersect through goal, then provide new d0/d1 coords
; a3 = player
; .xr = 80
; .yr = 30
; .ye = 30
; .gl = 258
avdgoal								;don't try to skate thru goal: if d0/d1 cords intersect thru goal then
									;provide new d0/d1 cords. a3 = player. .gl 254 ($FE), .yr/.ye 35 (92
									;258/30/30), .xr 80 in: d0/d1 = target x/y. out: d0/d1 moved by (deltax,
									;deltay) so the straight line from a3 to the target misses both nets (x
									;within +-$50, y within 35 of the goal lines at +-254)
	clr.w	(deltax).l
	clr.w	(deltay).l
	tst.w	position(a3)			;goalie? If so, quit
	beq.w	rtss2
	move.w	0(a3),d2				;Xpos
	eor.w	d0,d2
	bpl.w	.chbar					;target on the same side of x = 0: line does not cross the center
	move.w	d1,d2					;d2 = y where the line a3 -> target crosses x = 0
	sub.w	Ypos(a3),d2				;Ypos
	move.w	0(a3),d3				;Xpos
	muls.w	d3,d2
	sub.w	d0,d3
	divs.w	d3,d2
	add.w	Ypos(a3),d2				;Ypos
	cmpi.w	#$121,d2				;.gl+.yr
	bgt.w	.chbar					;passes above the top net area
	cmpi.w	#$DB,d2					;.gl-.yr
	blt.w	.lower					;below the top net area: maybe the bottom one
	move.w	#$144,d3				;.gl-.yr-.ye
	cmpi.w	#$FE,d2					;.gl
	bgt.w	.2						;above the goal line: go around the outside
	blt.w	.1						;below it: go around the inside
	cmpi.w	#$FE,Ypos(a3)			;.gl, Ypos
	bgt.w	.2						;exactly on it: decide by which side I am on
.1									;above the net: go around the outside
	move.w	#$B8,d3					;.gl-.yr-.ye
.2									;deltay = wanted y - crossing y
	sub.w	d2,d3					;deltay = wanted y - crossing y
	move.w	d3,(deltay).l			;deltay = wanted y - crossing y
	bra.w	.chbar
.lower								;d2 < $DB
	cmpi.w	#$FF25,d2				;-.gl+.yr
	bgt.w	.chbar
	cmpi.w	#$FEDF,d2				;-.gl-.yr
	blt.w	.chbar
	move.w	#$FF48,d3				;-.gl+.yr+.ye
	cmpi.w	#$FF02,d2				;-.gl
	bgt.w	.4
	blt.w	.3
	cmpi.w	#$FF02,Ypos(a3)			;-.gl, Ypos
	bgt.w	.4
.3									;below the bottom net: go around
	move.w	#$FEBC,d3				;-.gl-.yr-.ye
.4									;deltay for the bottom net
	sub.w	d2,d3
	move.w	d3,(deltay).l
.chbar								;second test: does the path cross a goal line inside the net width?
	move.w	d1,d3					;second test: does the line cross a goal line inside the net width?
	subi.w	#$FE,d3					;.gl
	move.w	Ypos(a3),d2
	subi.w	#$FE,d2
	bsr.w	.ch1					;top goal line
	move.w	d1,d3
	addi.w	#$FE,d3
	move.w	Ypos(a3),d2
	addi.w	#$FE,d2
	bsr.w	.ch1					;bottom goal line
	add.w	(deltax).l,d0			;apply the corrections to the target
	add.w	(deltay).l,d1
	rts
.ch1								;local subroutine
	move.w	d3,d4
	eor.w	d2,d4
	bpl.w	rtss2
	move.w	d0,d4
	sub.w	0(a3),d4				;Xpos
	muls.w	d2,d4
	sub.w	d3,d2
	divs.w	d2,d4
	add.w	0(a3),d4				;Xpos
	cmpi.w	#$50,d4					;#.xr
	bgt.w	rtss2
	cmpi.w	#$FFB0,d4				;#-.xr
	blt.w	rtss2
	moveq	#$50,d3					;#.xr
	tst.w	d4
	bne.w	.ch2
	tst.w	0(a3)					;Xpos
.ch2								;X sign
	bpl.w	.ch3
	neg.w	d3
.ch3								;compare the distance
	sub.w	d4,d3					;deltax = net edge - crossing x
	move.w	d3,(deltax).l			;deltax = net edge - crossing x
	rts
; find where the puck is going to be
skatetopuckinit						;d0/d1 = puck x/y plus half the high byte of its
									;velocity. Called from skatetopuck and assnearest
	move.b	(puckvx).l,d0			;high byte of the puck x velocity (signed)
	asr.b	#1,d0					;halved
	ext.w	d0
	add.w	(puckx).l,d0			;d0 = puck x + vx/2
	move.b	(puckvy).l,d1
	asr.b	#1,d1
	ext.w	d1
	add.w	(pucky).l,d1			;d1 = puck y + vy/2
	rts
; player a3 should skate to puck
skatetopuck							;player a3 should skate to puck. d7 = elapse frames
	bsr.w	skatetopuckinit			;d0/d1 = predicted puck spot
	sub.b	d7,temp2(a3)			;temp2
	bpl.w	.ex						;not due: reuse the last direction
	addi.b	#$A,temp2(a3)			;temp2
	bsr.w	avdgoal					;go around the nets
	movem.w	d0-d1,-(sp)				;save the target
	move.l	a3,-(sp)				;GetHot argument: this player
	bsr.w	GetHot					;d0/d1 = hot spot x/y of this player
	neg.b	d0
	neg.b	d1
	sub.b	Xvel(a3),d0				;Xvel
	ext.w	d0
	add.w	(sp)+,d0				;+ target x
	sub.w	0(a3),d0				;Xpos
	sub.b	Yvel(a3),d1				;Yvel
	ext.w	d1
	add.w	(sp)+,d1
	sub.w	Ypos(a3),d1				;Ypos
	bsr.w	vtoa					;direction to the puck
	move.b	d0,temp2+1(a3)			;temp2 lower byte
	tst.w	position(a3)			;goalie skips the sweep check
	beq.w	.ex
	move.w	(puckvx).l,d0
	move.w	(puckvy).l,d1
	bsr.w	vtoa					;direction the puck is moving
	eori.w	#4,d0					;opposite of that
	cmp.w	facedir(a3),d0			;facedir
	beq.w	.ex						;puck is coming towards players
	move.w	(puckx).l,d0
	sub.w	0(a3),d0				;Xpos
	move.w	(pucky).l,d1
	sub.w	Ypos(a3),d1				;Ypos
	movem.w	d0-d1,-(sp)
	bsr.w	vtoa					;direction from me to the puck
	cmp.w	facedir(a3),d0
	movem.w	(sp)+,d0-d1
	bne.w	.ex						;not facing the puck
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0					;squared distance to the puck
	cmpi.l	#$384,d0				;#30^2
	bls.w	.ex
	cmpi.l	#$5A4,d0				;#38^2
	bls.w	Sweepcheck
.ex									;not near enough to check: keep skating that way
	move.b	temp2+1(a3),d0
	bra.w	doplayeracc
; exit current assignment on player a3
assexit								;exit current assignment on player a3
	addi.w	#1,assnum(a3)			;add 1 to current assignment index
	andi.w	#7,assnum(a3)			;mask passing first 3 bits
	bset.b	#pfna,pflags(a3)		;signal next assignment
	rts
; insert new assignment on player a3
assinsert							;insert new assignment on player a3. d0 =
									;assignment. Falls into assreplace
	subi.w	#1,assnum(a3)
	andi.w	#7,assnum(a3)
; replace current assignment on player a3
assreplace							;replace current assignment on player a3. d0 = assignment
	move.l	d1,-(sp)				;push on stack
	move.w	assnum(a3),d1
	move.b	d0,asslist(a3,d1.w)		;replace current assignment with d0 on asslist
	bset.b	#pfna,pflags(a3)		;set flag to start new assignment
	move.l	(sp)+,d1				;pop on stack
	rts
; d0/d1 are x/y distances which are converted into direction 0-7 and returned in d0
vtoa								;d0/d1 are x/y distances which are converted into direction 0-7 and
									;returned in d0 (8 = no direction)
	movem.l	d2/a0,-(sp)
	move.w	d0,d2
	or.w	d1,d2
	beq.w	.nodir					;both zero: no direction
	clr.w	d2						;d2 = 4 bit index built from the signs and slope tests
	tst.w	d0
	bpl.w	.0
	neg.w	d0						;|dx|
	bset	#0,d2					;bit 0: dx negative
.0									;|dy|
	tst.w	d1						;y sign
	bpl.w	.1
	neg.w	d1						;|dy|
	bset	#1,d2					;bit 1: dy negative
.1									;|dx| check
	asl.w	#1,d1					;slope test: |dx| against 2|dy|
	cmp.w	d1,d0
	bhi.w	.2						;|dx| > 2|dy|
	bset	#2,d2					;bit 2: |dx| <= 2|dy|
.2									;|dy| check
	lsr.w	#1,d1					;slope test: |dy| against 2|dx|
	asl.w	#1,d0
	cmp.w	d0,d1
	bhi.w	.3						;|dy| > 2|dx|
	bset	#3,d2					;bit 3: |dy| <= 2|dx|
.3									;direction bits set
	movea.l	#.dt,a0					;#.dt
	clr.w	d0
	move.b	(a0,d2.w),d0
	movem.l	(sp)+,d2/a0
	rts
.nodir								;d2 = 0
	moveq	#8,d0					;8 = no direction
	movem.l	(sp)+,d2/a0
	rts
.dt	dc.b	1
	dc.b	7,3,5,0,0,4,4,2,6,2,6,1,7,3,5
; Push long address of structure to get hot spot from
; hot spot x/y returned in d0/d1
GetHot								;push long address of structure to get hot spot from. Hot spot x/y
									;returned in d0/d1. Reads a byte pair per frame from HotList
	movem.l	a0-a1,-(sp)				;$C(sp) = the address the caller pushed (above 2 longs and the return
									;address)
	movea.l	$C(sp),a0				;move stored address before sub routine call into a0
	clr.w	d0						;clear d0
	clr.w	d1						;clear d1
	tst.w	frame(a0)
	ble.w	.ex						;branch if <= 0
;CD: no cartridge twin
	movea.l	(HotListPtr).l,a1
	subq.l	#$2,a1
	move.w	frame(a0),d0			;move frame into d0
	add.w	d0,d0					;double d0
	move.b	$1(a1,d0.w),d1			;SprStrHot Y byte
	ext.w	d1						;extend d1
	move.b	(a1,d0.w),d0			;SprStrHot X byte
	ext.w	d0						;extend d0
	btst.b	#3,attribute(a0)		;check attribute for X flip
	beq.w	.nox					;branch if equal
	neg.w	d0						;negate d0 (flip)
.nox								;x flipped sprites mirror the hot spot x
	btst.b	#4,attribute(a0)		;check attribute for Y flip
	bne.w	.noy					;branch if no flip
	neg.w	d1						;negate d1 (flip)
.noy								;y flipped sprites mirror the hot spot y; horizontal mode swaps x and y
	btst.b	#sfhor,(sflags).l		;check if horizontal mode
	beq.w	.ex						;branch if not
	exg	d0,d1						;swap d0 and d1
	neg.w	d1						;ngate d1 (x now)
.ex									;pop the a0-a1 saved above
	movem.l	(sp)+,a0-a1				;restore registers, drop the argument
	move.l	(sp)+,(sp)				;drop the caller's argument (replaces it with the return address)
	rts
; set sprite animation on struct a3
; d1 = new animation
SetSPA								;set sprite animation on struct a3. d1 = new animation
	cmp.w	SPA(a3),d1
	beq.w	rtss2
	clr.w	SPAnum(a3)
	move.w	d1,SPA(a3)
	st.b	SPAcnt(a3)				;restart animation
	rts
; player a3 gets acc. in d0 dir
doplayeracc							;player a3 gets acc. in d0 dir
									;in: d0 = wanted direction (0-7; 8/9 = none), d7 = elapsed frames. Chooses
									;forward or backward skating, turns facedir gradually, and ends in
									;playeracc (accelerate along d2)
	tst.w	position(a3)
	beq.w	goalieacc				;goalie is special
	move.w	#SPAglide,d1			;d1 = animation to use if standing: glide
	btst.b	#pfrev,pflags(a3)		;check if skating backwards
	beq.w	.d0						;branch if not
	move.w	#SPAglideback,d1		;skating backwards: glide back
.d0									;set the glide
	andi.w	#$F,d0					;pass first 4 bits of d0
	cmpi.w	#7,d0					;compare to 7
	ble.w	.d1						;branch if less than
	cmpi.w	#9,d0					;compare to 9
	bne.w	.cgl					;branch if not equal
	move.w	Xvel(a3),d0				;Xvel
	or.w	Yvel(a3),d0				;OR Yvel with Xvel
	bne.w	dostop					;stop if not equal
.cgl								;glide check
	btst.b	#pf2aip,pflags2(a3)		;check if anim in progress
	beq.w	SetSPA					;if not set animation
	rts
.d1									;d0 <= 7
	movem.w	d0-d1,-(sp)				;save wanted direction and animation
	move.w	d0,d2					;d2 = wanted direction
	move.w	SCnum(a3),d0			;move SCnum into d0
	cmp.w	(puckc).l,d0			;check if puckc
	beq.w	.clrrev					;branch if so
	move.w	(puckx).l,d0			;puckx into d0
	sub.w	0(a3),d0				;sub Xpos
	move.w	Ypos(a3),d3				;Ypos into d3
	move.b	(puckvy).l,d1			;puckvy into d1
	ext.w	d1
	add.w	(pucky).l,d1			;add pucky to d1
	sub.w	d3,d1					;sub Ypos from d1
	btst.b	#pfgoal,pflags(a3)		;check which goal shooting at
	bne.w	.c1						;branch if top
	neg.w	d0						;mirror everything into the frame of the team shooting
	neg.w	d1						;toward +y (d3 = my y, d2 = wanted direction)
	neg.w	d3
	eori.w	#4,d2
.c1									;direction check
	btst.b	#pfrev,pflags(a3)		;check if skating in reverse
	bne.w	.inrev					;branch if so
	tst.w	d3
	bpl.w	.clrrev					;skate back in own zone only
	cmpi.w	#4,d2
	bne.w	.clrrev
	bsr.w	vtoa					;direction to the puck (mirrored frame)
	addi.w	#1,d0
	andi.w	#7,d0
	cmpi.w	#2,d0
	bhi.w	.clrrev
	bra.w	.rev
.inrev								;pfrev set
	subi.w	#3,d2					;already backwards: stay so only if the wanted direction ...
	andi.w	#7,d2
	cmpi.w	#2,d2
	bhi.w	.clrrev
	bsr.w	vtoa
	addi.w	#2,d0
	andi.w	#7,d0
	cmpi.w	#4,d0
	bhi.w	.clrrev
.rev								;within one step of the motion: skate backwards (pfrev)
	btst.b	#pfrev,pflags(a3)		;check if skating in reverse
	bne.w	.done					;branch if so
	move.w	Xvel(a3),d0				;move Xvel into d0
	or.w	Yvel(a3),d0				;or with Yvel
	beq.w	.setrev					;branch if equal
	move.w	Xvel(a3),d0				;move Xvel into d0
	move.w	Yvel(a3),d1				;Yvel to d1
	bsr.w	vtoa					;direction of motion
	sub.w	(sp),d0					;minus the wanted direction
	addi.w	#1,d0
	andi.w	#7,d0
	cmpi.w	#2,d0
	bhi.w	.done					;motion not within one step of the wanted direction: stay forward
.setrev								;skate backward
	bset.b	#pfrev,pflags(a3)		;set skating in reverse flag
	bra.w	.done
.clrrev								;too far round: skate forwards
	bclr.b	#pfrev,pflags(a3)		;clear skating in reverse flag
.done								;pop the d0-d1 saved above
	movem.w	(sp)+,d0-d1				;d0 = wanted direction, d1 = animation
	move.w	facedir(a3),d2			;facedir into d2
	sub.w	d2,d0
	andi.w	#7,d0					;d0 = wanted - facing (0-7)
	movea.l	#.ftab,a0
	asl.w	#1,d0
	tst.w	(a0,d0.w)
	beq.w	noturn0					;facing the right way (or opposite): no turn rate
	move.w	Xvel(a3),d4				;Xvel to d4
	muls.w	d4,d4					;square d4
	move.w	Yvel(a3),d3				;Yvel to d3
	muls.w	d3,d3					;square d3
	add.l	d4,d3					;add d4 and d3
	swap	d3						;swap upper and lower words
	move.w	#$300,d4
	sub.w	d3,d4					;turn rate falls as speed rises ...
	cmpi.w	#$180,d4				;compare to d4
	bge.w	.iok					;branch if greater than or equal
	move.w	#$180,d4				;... down to $180
.iok								;turn rate clamped
	muls.w	(a0,d0.w),d4
	btst.b	#pfrev,pflags(a3)		;check if skating in reverse
	beq.w	.i0						;branch if not
	neg.l	d4						;backwards: turn the other way
.i0									;turn rate
	add.l	d4,facedir(a3)			;add d4 to facedir
	andi.w	#7,facedir(a3)			;pass the first 3 bits to facedir
	move.w	facedir(a3),d2			;move facedir to d2
	cmpi.w	#$14,d3
	bls.w	.s3
	clr.w	d1
	tst.w	(a0,d0.w)
	bpl.w	.s1
	eori.w	#SPAturnl-SPAturnr,d1
.s1									;turn sense from the table sign
	btst.b	#3,attribute(a3)		;test bit 3 of attribute
	beq.w	.s2
	eori.w	#SPAturnl-SPAturnr,d1	;attribute bit 3 swaps the sense
.s2									;flipped sprites swap the turn sense; start the turn animation
	addi.w	#SPAturnr,d1
	bset.b	#pf2aip,pflags2(a3)		;set animation in progress flag
.s3									;turn done
	bsr.w	SetSPA					;set the animation
	cmpi.w	#2,d3
	bhi.w	noturn					;moving at some speed: accelerate (reversed when pfrev)
	rts								;almost still: no acceleration this call
.ftab	dc.w	0
	dc.w	$10
	dc.w	$10
	dc.w	$10
	dc.w	0
	dc.w	$FFF0
	dc.w	$FFF0
	dc.w	$FFF0
goalieacc							;goalie gets acc. in direction d0. Turns facedir one step toward d0
	btst.b	#pfjoycon,pflags(a3)
	beq.w	.normalgoalie
	movem.w	d0,-(sp)
	move.w	(puckc).l,d0
	cmp.w	SCnum(a3),d0
	movem.w	(sp)+,d0
	beq.w	.normalgoalie
	cmpi.w	#$30,0(a3)
	bgt.w	.normalgoalie
	cmpi.w	#$FFD0,0(a3)
	blt.w	.normalgoalie
	cmpi.w	#$FF40,Ypos(a3)
	bgt.w	.checkbottom
	cmpi.w	#$FEFA,Ypos(a3)
	blt.w	.normalgoalie
	bra.w	.facepuck
.checkbottom						;near the bottom net: face the puck
	cmpi.w	#$C0,Ypos(a3)
	blt.w	.normalgoalie
	cmpi.w	#$106,Ypos(a3)
	bgt.w	.normalgoalie
.facepuck							;in the crease: turn toward the puck
	movem.w	d0-d1,-(sp)
	move.w	(puckx).l,d0
	sub.w	0(a3),d0
	move.w	(pucky).l,d1
	sub.w	Ypos(a3),d1
	cmpi.w	#$10,d0
	bgt.w	.usevtoa
	cmpi.w	#$FFF0,d0
	blt.w	.usevtoa
	cmpi.w	#$10,d1
	bgt.w	.usevtoa
	cmpi.w	#$FFF0,d1
	blt.w	.usevtoa
	move.w	facedir(a3),d0
	bra.w	.checkadjust
.usevtoa							;direction to the puck
	bsr.w	vtoa
.checkadjust						;turn one step toward it (sflags4 bit 0 keeps the direction)
	btst.b	#0,(sflags4).l
	bne.w	.adjustkeepdir
	bsr.w	AdjustFacingDirection
	movem.w	(sp)+,d0-d1
	bra.w	.setready
.adjustkeepdir						;pop the d0-d1 saved above
	movem.w	(sp)+,d0-d1
	cmpi.w	#8,d0
	beq.w	.setready
	movem.w	d0-d1,-(sp)
	bsr.w	AdjustFacingDirection
	movem.w	(sp)+,d0-d1
.setready							;ready stance unless a save animation runs
	move.w	#SPAgready,d1
	btst.b	#pf2aip,pflags2(a3)
	bne.w	.exit
	bsr.w	SetSPA
	cmpi.w	#8,d0
	bne.w	.playermove
	tst.w	position(a3)
	bne.w	.playermove
	btst.b	#pfjoycon,pflags(a3)
	beq.w	.playermove
	move.w	d0,-(sp)
	move.w	Ypos(a3),d0
	btst.b	#pfgoal,pflags(a3)
	beq.w	.topstay
	neg.w	d0
.topstay							;stay at the spot
	cmpi.w	#$D8,d0
	blt.w	.stopandrestore
	move.w	0(a3),d0
	cmpi.w	#$20,d0
	bgt.w	.stopandrestore
	cmpi.w	#$FFE0,d0
	blt.w	.stopandrestore
	move.w	(sp)+,d0
	jsr	(stopna2).l
	bra.w	.playermove
.stopandrestore						;stop and restore the direction
	jsr	(stopna2).l
	move.w	(sp)+,d0
.playermove							;accelerate in d0
	move.w	d0,d2
	bra.w	playeracc
.normalgoalie						;out of the crease: normal goalie skating
	move.w	#SPAgready,d1
	btst.b	#pfjoycon,pflags(a3)
	beq.w	.goalieacc2
	btst.b	#pfnc,pflags(a3)
	bne.w	.cgl
	cmpi.w	#8,d0
	bne.w	.turnskater
	tst.w	position(a3)
	bne.w	.cgl
	move.w	d0,-(sp)
	move.w	Ypos(a3),d0
	btst.b	#pfgoal,pflags(a3)
	beq.w	.topstop
	neg.w	d0
.topstop							;stop at the spot
	cmpi.w	#$D8,d0
	blt.w	.restoreidle
	move.w	0(a3),d0
	cmpi.w	#$20,d0
	bgt.w	.restoreidle
	cmpi.w	#$FFE0,d0
	blt.w	.restoreidle
	move.w	(sp)+,d0
	bsr.w	stopna
	bra.w	.cgl
.restoreidle						;restore the direction, then the glide check
	move.w	(sp)+,d0
	bra.w	.cgl
.turnskater							;d0 <> 8
	bra.w	.d1
.goalieacc2							;pfjoycon clear
	andi.w	#$F,d0
	cmpi.w	#7,d0
	ble.w	.d1
	cmpi.w	#9,d0
	bne.w	.cgl
	move.w	Xvel(a3),d0
	or.w	Yvel(a3),d0
	beq.w	.cgl
	jmp	(stopna2).l
.cgl								;not moving: ready / glide animation unless one runs
	btst.b	#pf2aip,pflags2(a3)
	beq.w	SetSPA
.exit								;exit (also the end of the code above)
	rts
.d1									;d0 = turn needed: one step a frame
	sub.w	facedir(a3),d0
	beq.w	.d11
	neg.w	d0
	andi.w	#4,d0
	lsr.w	#1,d0
	subi.w	#1,d0
	add.w	facedir(a3),d0
	andi.w	#7,d0
	move.w	d0,facedir(a3)
.d11								;facing set
	move.w	#SPAgskate,d1
	bsr.w	SetSPA
	move.w	facedir(a3),d2
	bra.w	playeracc
noturn0								;doplayeracc when the wanted direction needs no turn (.ftab entry 0). d0 =
									;direction minus facedir, times 2
	moveq	#2,d4					;d4 = 2 forwards, 6 when skating backwards
	btst.b	#pfrev,pflags(a3)
	beq.w	.0
	addi.w	#4,d4
	eori.w	#8,d0					;backwards: swap "straight" and "opposite"
.0									;turn direction
	tst.w	d0						;straight ahead?
	beq.w	.nochg					;the wanted direction is already the way I skate
	move.w	Xvel(a3),d0				;opposite: look at the current motion
	move.w	Yvel(a3),d1
	bsr.w	vtoa
	btst	#3,d0					;not moving
	bne.w	.nostop
	sub.w	facedir(a3),d0
	add.w	d4,d0
	andi.w	#7,d0
	cmpi.w	#4,d0
	blt.w	dostop					;moving along the facing: brake first
.nostop								;turn toward the wanted direction
	addi.w	#1,facedir(a3)			;turn one step (the way depends on attribute bit 3)
	btst.b	#3,attribute(a3)
	beq.w	.nos0
	subi.w	#2,facedir(a3)
.nos0								;wrap the facing; glide (or the backwards glide)
	andi.w	#7,facedir(a3)			;wrap facing to 0-7
	move.w	#SPAglide,d1
	btst.b	#pfrev,pflags(a3)
	beq.w	SetSPA
	move.w	#SPAglideback,d1
	bra.w	SetSPA
.nochg								;d0 = 0
	move.w	#SPAskateback,d1		;pick the skating animation
	btst.b	#pfrev,pflags(a3)
	bne.w	.ns
	move.w	#SPAskate,d1
	btst.b	#pf2inj,pflags2(a3)		;injured: stumble animation
	beq.w	.nb6
	move.w	#SPAstumble,d1
.nb6								;set the animation
	move.w	(puckc).l,d4			;puck carrier check
	cmp.w	SCnum(a3),d4
	bne.w	.ns
	move.w	#SPAskatewp,d1			;carrying the puck: skate with puck animation
.ns									;skate (or skate with the puck) unless an animation runs
	btst.b	#pf2aip,pflags2(a3)		;set the animation unless one is in progress
	bne.w	noturn					;animation in progress: leave it
	bsr.w	SetSPA
noturn								;reverse the acc. direction when skating backwards, then falls into
									;playeracc
	btst.b	#pfrev,pflags(a3)
	beq.w	playeracc
	eori.w	#4,d2					;opposite direction
; d2 = direction of acc
playeracc							;d2 = direction of acc
	asl.w	#2,d2					;4 bytes per dirtab entry
	lea	dirtab(pc),a0
	move.w	$2(a0,d2.w),d1			;Y Inc
	move.w	(a0,d2.w),d0			;x Inc
	move.w	Wallsin(a3),d2			;check acc dir and dont push wall
									;wallsin
	beq.w	.nox
	eor.w	d0,d2
	bpl.w	.nox					;same sign as the wall normal: allowed
	clr.w	d0						;pushing into the wall in x: cancel x
.nox								;x allowed; test y against the wall
	move.w	Wallcos(a3),d2			;wallcos
	beq.w	.noy
	eor.w	d1,d2
	bmi.w	.noy
	clr.w	d1						;same for y (the sign test is the other way round)
.noy								;y done: acceleration scaled by weight (lighter is faster)
	clr.w	d2						;clear d2
	move.b	weight(a3),d2			;move wgt of player into d2
	lsr.w	#2,d2					;divide d2 by 2
	neg.w	d2						;make it negative
	addi.w	#$40,d2					;add 40 hex (64 decimal) to d2
	add.b	legstr(a3),d2			;add agl (legstr) of player to d2
	btst.b	#1,(sflags8).l
	bne.w	.incagl
	btst.b	#6,(sflags7).l			;check flag for crowd meter record
	beq.w	.incaglg				;branch if not set
.incagl								;crowd meter boost
	addi.b	#2,d2					;add 2 to d2 (crowd meter boost)
;CD: no cartridge twin
	addi.b	#$2,d2
.incaglg							;agility clamped
	tst.w	position(a3)			;test for goalie
	bne.w	.noy2
	add.b	legstr(a3),d2			;goalie gets double agl
	addi.w	#$10,d2					;double agl + 10 hex
.noy2								;goalies use double agility
	asr.w	#1,d2					;divide by 2
	muls.w	d2,d0					;x
	muls.w	d2,d1					;y
	asr.l	#5,d0					;divide by 32
	asr.l	#5,d1
	muls.w	d7,d0					;mult d0 with frames elapsed (d7)
	muls.w	d7,d1					;mult d1 by frames elapsed (d7)
	tst.w	position(a3)			;test goalie
	bne.w	.noy3
	btst.b	#pfjoycon,pflags(a3)	;joypad controlled
	beq.w	.noy3					;no, then jump
	move.w	(puckc).l,d2			;puck carrier SCnum
	cmp.w	SCnum(a3),d2			;carrying puck?
	bne.w	.noy3					;jump if not
	asr.w	#1,d0					;divide by 2 (puck carrier, joypad controlled)
	asr.w	#1,d1					;divide by 2
.noy3								;puck carrier on the joystick: half the acceleration
	add.w	Xvel(a3),d0				;Xvel
	add.w	Yvel(a3),d1				;Yvel
	move.w	d0,d2					;move d0 into d2
	move.w	d1,d3					;move d1 into d3
	muls.w	d2,d2					;square d2
	muls.w	d3,d3					;square d3
	add.l	d2,d3					;add together
	movem.w	d0-d1,-(sp)				;push d0 and d1 to stack
	bsr.w	getpde					;d0 = this player's energy level
	btst.b	#4,(sflags7).l
	beq.w	.noy4
	move.w	#$1000,d0				;d0 = energy, move 1000 hex into d0
.noy4								;speed from energy
	clr.w	d2						;clear d2
	move.b	legspd(a3),d2			;add speed (legspd) to d2
	btst.b	#1,(sflags8).l
	bne.w	.incspd
	btst.b	#6,(sflags7).l			;skip boost if 0
	beq.w	.noy5
.incspd								;crowd meter boost
	addi.b	#2,d2					;add 2 to d2 (speed)
	cmpi.b	#$1E,d2					;compare to max speed attribute (1E or 30)
	ble.w	.noy5					;branch if less than
	move.b	#$1E,d2					;limit it to max speed
.noy5								;speed clamped
	move.w	d2,(TempRawSpd).l		;hold spd value
	lsr.w	#1,d2					;divide by 2
	mulu.w	d0,d2					;multiply energy with spd
	asl.l	#4,d2					;mult by 16
	swap	d2						;swap d2 words (this math is to adjust for energy. Line Changes off, d2 =
									;Spd value / 2)
	asl.w	#2,d2					;mult by 4 (No Line changes result from above = Spd value * 2)
	andi.w	#$3F,d2					;pass first 6 bits. Limits d2 to $3F (63 decimal)
	lea	MaxSpeed(pc),a2				;move Maxspeed table address into a2
	move.w	d2,(TempEnergySpd).l	;hold new spd value
	move.l	(a2,d2.w),d2			;use value from MaxSpeed list
	move.l	d2,(TempMaxSpd).l		;hold MaxSpeed value
	cmpi.w	#$3C,(TempEnergySpd).l	;compare new spd value with 60 decimal
	bge.w	.fgtinj					;branch if greater than or equal
	btst.b	#0,(TempRawSpd+1).l		;check if TempRawSpd is odd
	beq.w	.fgtinj					;branch if even
	move.w	(TempEnergySpd).l,d2	;move TempEnergySpd into d2
	addi.w	#4,d2					;add 4 to d2
	move.l	(a2,d2.w),d2			;use value from MaxSpeed list (rounding the odd number up)
	sub.l	(TempMaxSpd).l,d2		;sub TempMaxSpd from d2
	asr.l	#1,d2					;divide by 2
	add.l	(TempMaxSpd).l,d2		;add TempMaxSpd to d2 (so halves the difference between the 2 Speed steps)
.fgtinj								;injured in a fight: one eighth of the top speed
	btst.b	#pf2inj,pflags2(a3)		;check if injured during fight
	beq.w	.puckc					;branch if not
	lsr.l	#3,d2					;divide d2 by 8
.puckc								;puck carrier check
	tst.w	position(a3)			;test goalie
	bne.w	.noy6					;branch if not goalie
	move.w	(puckc).l,d0			;puck carrier SCnum
	cmp.w	SCnum(a3),d0			;check if puck carrier
	bne.w	.noy6					;branch if not puck carrier
	asr.l	#1,d2					;divide d2 by 2
.noy6								;pop the d0-d1 saved above
	movem.w	(sp)+,d0-d1				;pop from stack
	cmp.l	d2,d3					;Compare d3 to d2 (max speed check)
	bhi.w	.sube					;branch if d3 is higher than d2 (no increase in velocity)
	move.w	d0,Xvel(a3)				;move new Xvel into Xvel
	move.w	d1,Yvel(a3)				;move new Yvel into Yvel
.sube								;energy drain
	tst.w	(OptLine).l
	bne.w	rtss2
;CD: no cartridge twin
.L36A0E
	btst.b	#$7,$FF800E.l
	bne.s	.L36A0E
	move.w	#$1B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L36A28
	btst.b	#$6,$FF800E.l
	beq.s	.L36A28
	move.w	$FF8010.l,d0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L36A48
	btst.b	#$6,$FF800E.l
	bne.s	.L36A48
	bclr.b	#$7,$FF800F.l
	andi.w	#$7F,d0
	bne.w	rtss2
	bsr.w	getpde
	subi.w	#$21,d0					;33
	cmpi.w	#$C00,d0
	blt.w	setpde					;below $C00: just lower by 33
	move.b	endurance(a3),d2		;endurance
	ext.w	d2
	lsr.w	#1,d2
	add.w	d2,d0
	bsr.w	setpde
	btst.b	#0,endurance(a3)
	beq.w	.ex
	btst.b	#0,(Vcount+1).l
	beq.w	.ex
	addi.w	#1,d0
	bra.w	setpde
.ex									;exit
	rts
MaxSpeed							;max speed values for each rating level 0-$F: ((n+20)*275)^2 (92 used 250)
	dc.l	(20*275)*(20*275)		;$1CD9410
	dc.l	(21*275)*(21*275)		;$1FCE3E1
	dc.l	(22*275)*(22*275)		;$22E8284
	dc.l	(23*275)*(23*275)		;$2626FF9
	dc.l	(24*275)*(24*275)		;$298AC40
	dc.l	(25*275)*(25*275)		;$2D13759
	dc.l	(26*275)*(26*275)		;$30C1144
	dc.l	(27*275)*(27*275)		;$3493A01
	dc.l	(28*275)*(28*275)		;$388B190
	dc.l	(29*275)*(29*275)		;$3CA77F1
	dc.l	(30*275)*(30*275)		;$40E8D24
	dc.l	(31*275)*(31*275)		;$454F129
	dc.l	(32*275)*(32*275)		;$49DA400
	dc.l	(33*275)*(33*275)		;$4E8A5A9
	dc.l	(34*275)*(34*275)		;$535F624
	dc.l	(35*275)*(35*275)		;$5859571
; player a3 stops
; .slim = 1000
dostop								;player a3 stops. Entered from doplayeracc and noturn0
	cmpi.w	#$1000,Xvel(a3)			;Xvel
	bgt.w	.set
	cmpi.w	#$F000,Xvel(a3)
	blt.w	.set
	cmpi.w	#$1000,Yvel(a3)			;Yvel
	bgt.w	.set
	cmpi.w	#$F000,Yvel(a3)
	blt.w	.set
	tst.w	position(a3)			;check if goalie
	bne.w	stopna
	jmp	(stopna2).l
	bra.w	stopna
.set								;not stopped yet: skid animation (forward only)
	move.w	#SPAglide,d1			;backwards: plain glide animation, no skid
	btst.b	#pfrev,pflags(a3)		;#pfrev - skating backwards
	bne.w	.0
	bset.b	#pf2aip,pflags2(a3)		;#pf2aip
	move.w	#SPAstop,d1				;... the skid stop
.0									;set the stop animation
	bsr.w	SetSPA
	tst.w	position(a3)
	bne.w	stopna
	jmp	(stopna2).l
; stop with no animation
stopna								;slow player a3 by 150 on each axis, no animation change. Falls in from
									;dostop, also entered from goalieacc and others
	tst.w	Xvel(a3)				;Xvel
	bpl.w	.xp
	addi.w	#$96,Xvel(a3)			;150
	bmi.w	.y						;still negative: done
	clr.w	Xvel(a3)				;crossed zero: clear (the code below then also ends at 0)
.xp									;positive x speed: subtract 150, stop at 0
	subi.w	#$96,Xvel(a3)			;positive x: subtract 150
	bpl.w	.y
	clr.w	Xvel(a3)
.y									;same for y
	tst.w	Yvel(a3)				;Yvel
	bpl.w	.yp
	addi.w	#$96,Yvel(a3)
	bmi.w	rtss2
	clr.w	Yvel(a3)
.yp									;positive y speed: subtract 150, stop at 0
	subi.w	#$96,Yvel(a3)
	bpl.w	rtss2
	clr.w	Yvel(a3)
	rts
runspeed	equ	200					;acc speed equate for table below
dirtab	dc.w	0					;x,y speed for each direction 0-7 (8 x,y word pairs); diagonals are
									;runspeed/1.414
	;X/Y acc speed for each direction 0-7
	dc.w	runspeed
	dc.w	runspeed*1000/1414		;runspeed / sqrt(2)
	dc.w	runspeed*1000/1414
	dc.w	runspeed
	dc.w	0
	dc.w	runspeed*1000/1414
	dc.w	-runspeed*1000/1414		;- runspeed / sqrt(2)
	dc.w	0
	dc.w	-runspeed				;- runspeed
	dc.w	-runspeed*1000/1414
	dc.w	-runspeed*1000/1414
	dc.w	-runspeed
	dc.w	0
	dc.w	-runspeed*1000/1414
	dc.w	runspeed*1000/1414
	dc.w	0
	dc.w	0
