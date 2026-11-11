;	HOCKEY.BIN $10E66-$112F7 (runtime $2BE66-$2C2F7): hockey94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	Part 3 of hockey94 ($10D28-$10E65 before it is src/segacd/crowdanim.asm, the cartridge updatecrowdf).

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

ClearPenalties	equ	$2B3A8
Pausemode_top	equ	$2C2F8
HandleMenuInput	equ	$2C368
MenuWaitVblank	equ	$2C63A
getpzjoy	equ	$2F2F0
rtss8	equ	$2F988
freezewindow	equ	$30094
assinsert	equ	$362D8
forceblack	equ	$36D0A
sfx	equ	$3710C
ProcessInputWithRepeat	equ	$374BE
ReadJoy1	equ	$374F0
ReadJoy2	equ	$3750E
ReadJoy3	equ	$3752C
ReadJoy4	equ	$3754A
eraser	equ	$38C06
printsmallz	equ	$38D8C
AddPenalty2	equ	$39456
ClearPenaltyBuffer	equ	$39EE4
ClrHor	equ	$3C3AC
SetHor	equ	$3C40A
printscores1	equ	$3C48C
setvideo	equ	$3DD16
showclock	equ	$3E1CE
ReloadRefHorTiles	equ	$3ECB8
ExitToOpening	equ	$3F2BE
PauseMenuItems	equ	$41EB4
Pausemode_mlist	equ	$41F50
PauseText2	equ	$420DC
p_turnoff	equ	$47DAC
stop_current_song	equ	$47DB0
KillCrowd	equ	$48208
PenEOG	equ	$4
PenEOP	equ	$2

	org	$2BE66


clockcont							;monitor period clock and initiate various clock activated events
	btst.b	#gmclock,(gmode).l		;gmclock
	bne.w	rtss8
	tst.w	(gameclock).l
	bne.w	rtss8
	bset.b	#dfclock,(disflags).l	;dfclock: clock needs update
	jsr	(stop_current_song).l
	move.w	#SFXhorn,-(sp)			;horn
	jsr	(sfx).l
	bsr.w	freezewindow
clockcont_0							;End of period. Also entered from puckfaceoff
	movea.l	#$17B80,a3				;puck (CD: the cartridge has #(puckx-M68K_RAM))
	move.l	#$18,d0					;pucknothing assignment
	jsr	(assinsert).l
	cmpi.w	#2,(gsp).l				;periods 1-2 just end the period
	blt.w	.eop
	move.l	#7,d0					;score assignment
	movea.l	#$17480,a3				;CD: the cartridge has #(SortCords-M68K_RAM)
	cmpi.w	#3,(gamelevel).l		;playoffs?
	bne.w	.t3
	cmpi.w	#7,(bosgames).l
	beq.w	.sc						;bosgames 7 skips the series check

	;Stanley Cup if the winning team already has 3 series wins
	moveq	#gssize,d3				;gssize
	mulu.w	(gamenum).l,d3
	movea.l	#(gstruct-M68K_RAM),a0	;game structs (games stored for playoffs and box scores)
	adda.w	d3,a0
	clr.w	d3
	btst.b	#gsftf,gsflags(a0)		;gsftf, gsflags(a0): teams are flipped
	beq.w	.nf
	eori.w	#2,d3					;gspobwins-gspotwins
.nf	move.w	(HmGoals).l,d1			;goal difference
	sub.w	(AwGoals).l,d1
	bpl.w	.ns1
	eori.w	#2,d3					;gspobwins-gspotwins
.ns1	cmpi.w	#3,gspotwins(a0,d3.w)	;gspotwins(a0,d3)
	bne.w	.t3

.sc	move.l	#8,d0					;stanley cup assignment
	moveq	#$B,d2					;all 12 players lose joystick control
.t0	bclr.b	#pfjoycon,pflags(a3)	;pfjoycon, pflags(a3)
	adda.w	#SCstruct,a3			;SCstruct
	dbf	d2,.t0
	movea.l	#$17480,a3				;CD: the cartridge has #(SortCords-M68K_RAM)
.t3	moveq	#5,d2					;winning team's skaters celebrate
	move.w	(HmGoals).l,d1
	sub.w	(AwGoals).l,d1
	beq.w	.eop					;tied
	bpl.w	.t2						;home team leads
	adda.w	#6*SCstruct,a3			;6*SCstruct: away team leads
.t2	tst.w	position(a3)			;position
	ble.w	.n2						;skip the goalie
	jsr	(assinsert).l				;first skater gets d0, the rest get score
	move.l	#7,d0					;score assignment
.n2	adda.w	#SCstruct,a3			;SCstruct
	dbf	d2,.t2
.eog	jsr	(ClearPenaltyBuffer).l	;end of game
	addi.w	#$3E8,(Crowdlevel).l	;1000
	bset.b	#gmclock,(gmode).l		;gmclock: stop clock
	bset.b	#gmeog,(gmode).l		;set at end of game
	jsr	(ClearPenalties).l
	move.w	#PenEOG,d0
	jmp	(AddPenalty2).l

.eop	cmpi.w	#3,(gsp).l			;end of OT?
	bne.w	.eop_ex
	tst.w	(OptPlayMode).l
	beq.w	.eog					;gsp 3 with OptPlayMode 0 ends the game
.eop_ex	move.w	#PenEOP,d0			;end of the period
	jmp	(AddPenalty2).l

demoread							;monitor joystick if in demo mode (called every game loop)
	tst.w	(cont1team).l
	bne.w	rtss8					;not demo
	tst.w	(cont2team).l
	bne.w	rtss8					;not demo
	jsr	(ReadJoy1).l
	btst	#sbut,d1				;Start?
	bne.w	startpause1				;start on pad 1 pauses
	bsr.w	EndDemoOnPress
	jsr	(ReadJoy2).l
	btst	#7,d1
	bne.w	startpause2
	tst.w	(FourWayPlay).l			;pads 3 and 4 on the 4 way play adapter
	beq.w	EndDemoOnPress
	jsr	(ReadJoy3).l
	btst	#7,d1
	bne.w	startpause3
	bsr.w	EndDemoOnPress
	jsr	(ReadJoy4).l
	btst	#7,d1
	bne.w	startpause4
	;falls into EndDemoOnPress with pad 4 in d1

EndDemoOnPress						;Any button on the pad just read (d1) ends the demo
	tst.w	d1
	beq.w	rtss8					;nothing pressed
	jmp	(ExitToOpening).l			;exit demo

startpause1							;pause initiated by cont 1
	clr.w	(pausepad).l			;pausing pad number (0 = pad 1 or 2)
	bclr.b	#sfpj,(sflags).l		;sfpj
	bra.w	startpause
startpause2							;pause initiated by cont 2
	clr.w	(pausepad).l
	bset.b	#sfpj,(sflags).l		;sfpj
startpause							;set sfpz: pause at the end of this frame
	bset.b	#sfpz,(sflags).l		;sfpz
	rts

startpause3							;pause initiated by cont 3 (4 way play). Also from doinput
	move.w	#3,(pausepad).l
	bclr.b	#sfpj,(sflags).l		;sfpj
	bra.w	startpause
startpause4							;pause initiated by cont 4 (4 way play). Also from doinput
	move.w	#4,(pausepad).l
	bset.b	#sfpj,(sflags).l		;sfpj
	bra.w	startpause

Pausemode							;Game is in pause mode now
	jsr	(forceblack).l				;fade screen to black
	move.w	d0,-(sp)
	move.w	(Vcount).l,d0
.vb	cmp.w	(Vcount).l,d0			;Wait for the next vblank
	beq.w	.vb
	move.w	(sp)+,d0
	jsr	(p_turnoff).l				;shut off sound
	move.w	(sflags).l,-(sp)
	bsr.w	seta2					;a2 = team of pausing controller
	movea.l	#Pausemode_mlist,a0		;menu item list
	lea	Pausemode_pall(pc),a1		;screen draw routine
	btst.b	#0,(gmode2).l
	beq.w	.chk2
	movea.l	#PauseMenuItems,a0		;third item list
	bra.w	.0
.chk2	btst.b	#tmftimeout,tmflags(a2)	;tmflags
	beq.w	.0
	movea.l	#PauseText2,a0			;alternate item list
.0	bsr.w	Pausemode_top			;build menu from list a0, draw routine a1
.loop	bsr.w	MenuWaitVblank		;loop
	bsr.w	getpzjoy
	jsr	(showclock).l
	jsr	(ProcessInputWithRepeat).l
	bsr.w	HandleMenuInput
	bne.w	.loop					;eq = leave pause

	;restore graphics and return from pause mode
	jsr	(forceblack).l
	move.w	(sp)+,(sflags).l
	btst.b	#sfhor,(sflags).l		;sfhor
	beq.w	.clr
	jsr	(ReloadRefHorTiles).l
	jsr	(SetHor).l
	bra.w	.hor
.clr	jsr	(ClrHor).l				;sfhor clear
.hor	movea.l	#Vdata,a0
;CD: no cartridge twin
.L2C122
	btst.b	#$7,$FF800E.l
	bne.s	.L2C122
	move.w	#$9100,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2C144
	btst.b	#$6,$FF800E.l
	beq.s	.L2C144
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2C15E
	btst.b	#$6,$FF800E.l
	bne.s	.L2C15E
	bclr.b	#$7,$FF800F.l
.L2C170
	btst.b	#$7,$FF800E.l
	bne.s	.L2C170
	move.w	#$9200,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2C192
	btst.b	#$6,$FF800E.l
	beq.s	.L2C192
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2C1AC
	btst.b	#$6,$FF800E.l
	bne.s	.L2C1AC
	bclr.b	#$7,$FF800F.l
	bset.b	#dfclock,(disflags).l	;dfclock: clock needs update
	bclr.b	#sfpz,(sflags).l		;sfpz
	jsr	(printscores1).l
	jsr	(setvideo).l
	move.w	#$18,(palcount).l
.wait	tst.w	(palcount).l		;wait for the palette fade to finish
	bpl.w	.wait
	move.w	(Vcount).l,(OldVcount).l
	rts

Pausemode_pall						;Draw routine for the pause menu.
									;also called
	movea.l	#Vdata,a0
;CD: no cartridge twin
.L2C1FE
	btst.b	#$7,$FF800E.l
	bne.s	.L2C1FE
	move.w	#$9100,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2C220
	btst.b	#$6,$FF800E.l
	beq.s	.L2C220
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2C23A
	btst.b	#$6,$FF800E.l
	bne.s	.L2C23A
	bclr.b	#$7,$FF800F.l
.L2C24C
	btst.b	#$7,$FF800E.l
	bne.s	.L2C24C
	move.w	#$921C,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2C26E
	btst.b	#$6,$FF800E.l
	beq.s	.L2C26E
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2C288
	btst.b	#$6,$FF800E.l
	bne.s	.L2C288
	bclr.b	#$7,$FF800F.l
	jsr	(SetHor).l
	jsr	(setvideo).l
	jsr	(KillCrowd).l
	jsr	(printsmallz).l				;erase playfield 3
	String	CC_SetMap,3,CC_SetX,0,CC_SetY,0
	moveq	#$20,d0					;32
	moveq	#$1C,d1					;28
	move.w	#$7FF,d2
	jmp	(eraser).l

seta2								;Set a2 to the team struct of the pause joystick also called from
									;HandleMenuInput
	movea.l	#$1834C,a2				;CD: the cartridge has #(tmstruct-M68K_RAM)
	btst.b	#sfpj,(sflags).l		;sfpj
	beq.w	.seta20
	cmpi.w	#1,(cont2team).l
	bra.w	.seta21
.seta20	cmpi.w	#1,(cont1team).l	;pad 1 paused
.seta21	beq.w	.x					;a2 stays home if the pausing pad controls team 1
	adda.w	#tmsize,a2				;tmsize
.x	rts								;exit (also the end of the code above)
