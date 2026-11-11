;	HOCKEY.BIN $FE68-$FF55 (runtime $2AE68-$2AF55): helpers94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	Same code as the cartridge. (title94, the title screen and credits, is not on the disc: the
;	CD has its own title, and logos94 follows straight on.)

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

assexit	equ	$362C4
SetSPA	equ	$363C0
Setplass	equ	$3D754
SPAglide	equ	$50C

	org	$2AE68

;	Small high-ROM helpers packed before the title screen: sflags8 bit 1,
;	attribute adjust, unused puck test, goalie-pulled, EndOneTimer. New in 94.
;	ROM-contiguous from SetSflags8Bit1 through EndOneTimer.

SetSflags8Bit1						;Always sets sflags8 bit 1 (the bclr is skipped).
									;Called from updateplayers
	bra.w	.set					;(the bclr below is always skipped)
	bclr.b	#1,(sflags8).l
	bra.w	.ex
.set								;set bit 1 of sflags8
	bset.b	#1,(sflags8).l			;set bit 1 of sflags8
.ex									;exit (also the end of the code above)
	rts
AttribAdjust						;An attribute under $32 becomes d0 / 2 + $19. Called from AttribRating,
									;PrintOverallRating and PrintMatchupRatings
	cmpi.w	#$32,d0					;compare $32 to d0
	bge.w	.exit					;branch if greater than
	asr.w	#1,d0
	addi.w	#$19,d0					;add $19 (25 dec)
.exit								;exit (also the end of the code above)
	rts
PuckComingToward					;nothing calls it. Z clear when the puck is within $1E of player a3 and
									;moving toward him (x, then y); d0-d1 kept
	movem.w	d0-d1,-(sp)
	move.w	(puckx).l,d0
	sub.w	0(a3),d0				;minus the player X
	cmpi.w	#$1E,d0					;puck more than $1E ahead in X: no
	bgt.w	.x
	move.w	(puckvx).l,d1
	eor.w	d1,d0					;sign of dx against the puck's X speed
	andi.w	#$8000,d0
	beq.w	.x						;same sign: moving away
	move.w	(pucky).l,d0
	sub.w	Ypos(a3),d0				;minus the player Y
	cmpi.w	#$1E,d0					;puck more than $1E ahead in Y: no
	bgt.w	.x
	move.w	(puckvy).l,d1
	eor.w	d1,d0					;sign of dy against the Y speed (Z clear = toward him)
	andi.w	#$8000,d0
.x									;(Z holds the answer)
	movem.w	(sp)+,d0-d1
	rts
ReadGoaliePulled					;Z clear when the team of a3 pulled its goalie ($26 of the team struct).
									;Called from doshot assdefo, asspuckc and assnearest
	movem.l	a1,-(sp)
	movea.l	#tmstruct,a1
	btst.b	#pfteam,pflags(a3)		;check if home or away 0=home 1=away
	beq.w	.chkgoalie
	movea.l	#awtmstruct,a1
.chkgoalie							;team chosen: tmgoalie 0 = goalie in (Z set)
	tst.w	tmgoalie(a1)
	movem.l	(sp)+,a1
	rts
EndOneTimer							;End a one-timer for a3: bits cleared, onetimerplayer = -1, SetSPA
									;SPAglide, then assexit (goalie) or Setplass. Called from assonetimer and
									;checkgoal (.setass)
	movem.l	d0/a0,-(sp)
	bclr.b	#pf3onetimer,pflags3(a3)
	bclr.b	#pfalock,pflags(a3)		;clear the a lock
	bclr.b	#pf2aip,pflags2(a3)		;clear the AI flag
	clr.w	(onetimerflags).l		;clear the one-timer flags
	st.b	(onetimerplayer).l
	move.w	d1,-(sp)
	move.w	#SPAglide,d1
	jsr	(SetSPA).l
	tst.w	position(a3)			;a goalie: back to his goalie logic
	bpl.w	.0
	jsr	(assexit).l					;a skater: normal assignment
	bra.w	.1
.0									;skater: give him a new assignment
	jsr	(Setplass).l
.1									;both: restart the animation
	clr.w	SPAnum(a3)				;first frame
	st.b	SPAcnt(a3)
	move.w	(sp)+,d1
	movem.l	(sp)+,d0/a0
	rts
