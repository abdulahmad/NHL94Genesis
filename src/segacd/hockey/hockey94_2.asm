;	HOCKEY.BIN $10B58-$10D27 (runtime $2BB58-$2BD27): hockey94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	Part 2 of hockey94 ($10B1E-$10B57 before it is src/segacd/songplay.asm). CD: ChkGoalies is no
;	longer called between periods, so the comments of the calls after it are one line off.

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

RunArenaAnim	equ	$2A1AA
ChooseSong	equ	$2A478
updatecrowdf	equ	$2BD28
clockcont	equ	$2BE66
Pausemode	equ	$2C074
rtss8	equ	$2F988
updateplayers	equ	$2F98A
song	equ	$371D2
PenaltyManager	equ	$394F2
updatesound	equ	$3E8CE
ShowInjuryBox	equ	$40D50
stop_current_song	equ	$47DB0
setSlotBit	equ	$25000
demoread	equ	$2BFB8
updatereplay	equ	$2F844
checkwindow	equ	$300B2
ChkGoalies	equ	$35012
updatepwrplay	equ	$3C2D0

	org	$2BB58

StartPer							;CD: its first lines have no twin; the rest of it starts here
	cmpi.w	#2,(gsp).l
	bge.w	Gameloop
	bset.b	#sf3fosong,(sflags3).l	;set for periods 1 and 2 only
Gameloop							;CD: placed where the disc branches to it
.nosong	jsr	$37206.l				;CD: the cartridge has (setSlotBit).l
	bsr.w	DoGameFrame				;CD: the cartridge has checkwindow
	bsr.w	demoread				;CD: the cartridge has updatereplay
	btst.b	#sfpz,(sflags).l		;sfpz
	beq.w	Gameloop
	bsr.w	Pausemode
	bra.w	Gameloop

DoGameFrame							;wait for at least one vblank, then run one frame of game logic
	move.w	(Vcount).l,d7
	sub.w	(OldVcount).l,d7		;number of frames since last loop
	beq.w	DoGameFrame
	move.w	(Vcount).l,(OldVcount).l
	bsr.w	periodicevents
	bsr.w	updateplayers			;apply velocity and check collisions
	tst.w	(songdelay).l			;delayed song countdown
	beq.w	.L2BBDC					;CD: the cartridge has .nosong
	bmi.w	.L2BBDC					;CD: the cartridge has .nosong
	subi.w	#1,(songdelay).l
	bne.w	.L2BBDC					;CD: the cartridge has .nosong
	jsr	(stop_current_song).l
	move.w	(delayedsong).l,-(sp)
	jsr	(song).l
;CD: no cartridge twin
.L2BBDC
	jsr	(setSlotBit).l
	bsr.w	checkwindow				;CD: the cartridge has RestoreBenchEnergy
	bsr.w	updatereplay			;CD: the cartridge has CheckInjury
	jmp	$3DD16.l					;CD: the cartridge has updatepwrplay

periodicevents						;Called every time thru game loop with d7 = elapsed frames
	jsr	(PenaltyManager).l
	bsr.w	updatecrowdf
	jsr	(RunArenaAnim).l
	jsr	(updatesound).l
	bsr.w	clockcont
	btst.b	#sfhor,(sflags).l		;sfhor
	bne.w	rtss8					;exit if in horizontal mode
	sub.w	d7,(lldisp).l			;count down for screen updates
	bpl.w	rtss8
	addi.w	#jps,(lldisp).l			;jps: only update once per second
;CD: no cartridge twin
	jsr	(ChkGoalies).l
	bsr.w	UpdateCwdExcite			;CD: the cartridge has ChkGoalies
	bsr.w	CheckLateGameSong		;CD: the cartridge has UpdateCwdExcite
	bsr.w	RestoreBenchEnergy		;CD: the cartridge has CheckLateGameSong
;CD: no cartridge twin
	bsr.w	CheckInjury
	jmp	(updatepwrplay).l

CheckInjury							;Called once per second. Count down InjCntDown, act on it at zero
	subi.w	#1,(InjCntDown).l
	bne.w	rtss8
	jmp	(ShowInjuryBox).l			;countdown expired

RestoreBenchEnergy					;Called once per second. Restore energy for players on the bench
	tst.w	(OptLine).l
	bne.w	.ex						;exit if line changes are off
	movea.l	#$1834C,a2				;team 1 (CD: the cartridge has #(tmstruct-M68K_RAM))
	bsr.w	.notinprog
	lea	tmsize(a2),a2				;team 2 (tmsize)
.notinprog							;local subroutine
	moveq	#(maxros-1)*2,d0		;(maxros-1)*2
.b0	cmpi.w	#$FFFE,tmpdst(a2,d0.w)	;tmpdst: -2 = bench, -1 = ice, 0+ = pen box
	bne.w	.next
	addi.w	#9,tmpde(a2,d0.w)		;tmpde: energy +9
	cmpi.w	#$1000,tmpde(a2,d0.w)
	blt.w	.next
	move.w	#$1000,tmpde(a2,d0.w)	;max energy
.next	subi.w	#2,d0				;next roster slot
	bpl.w	.b0
.ex	rts								;exit (also the end of the code above)

CheckLateGameSong					;Called once per second. 3rd period: choose and play a song once at the
									;random trigger time set by ResetClock
	cmpi.w	#2,(gsp).l				;3rd period only
	bne.w	.x
	btst.b	#gmhl,(gmode).l
	bne.w	.x
	move.w	(gameclock).l,d0
	cmp.w	(periodendtime).l,d0
	bgt.w	.x						;not there yet
	st.b	(periodendtime).l		;high byte $FF: trigger goes negative, fires once
	move.w	(HomeTeam).l,(HmTeam).l
	move.w	#SngLateGame,(SongIndex).l
	jsr	(ChooseSong).l
	move.w	(SongNum).l,-(sp)
	jsr	(song).l
.x	rts								;exit (also the end of the code above)

UpdateCwdExcite						;called once per second. Track peak and running total of crowd excitement,
									;then
									;decay the level by 1 (floor 0)
	move.w	(CwdExciteLvl).l,d0
	cmp.w	(MaxCwdExciteLvl).l,d0
	bls.w	.less
	move.w	d0,(MaxCwdExciteLvl).l	;new peak
.less	ext.l	d0					;add to the running total
	add.l	d0,(SumCwdExciteLvl).l	;running total
	addi.w	#1,(NumCwdExciteLvl).l	;sample count
	subi.w	#1,(CwdExciteLvl).l		;decay
	bpl.w	.ex
	clr.w	(CwdExciteLvl).l
.ex	rts								;exit (also the end of the code above)
