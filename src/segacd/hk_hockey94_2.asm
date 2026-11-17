	include	segacd\hockey.inc
	include	macros\genesis.mac

ChooseSong	equ	$2A478
CwdExciteLvl	equ	$17CD8
HmTeam	equ	$1A56C
HomeTeam	equ	$17FAE
LOAD	equ	$1B000
MaxCwdExciteLvl	equ	$17CDA
OldVcount	equ	$17476
OptLine	equ	$18C0A
RunArenaAnim	equ	$2A1AA
ScoutSubStatus	equ	$17474
SongIndex	equ	$1A56E
SongNum	equ	$1A56A
SumCwdExciteLvl	equ	$17CDE
clockcont	equ	$2BE66
delayedsong	equ	$1AD70
gameclock	equ	$180E6
lldisp	equ	$1747C
move	equ	$2C9C8
periodendtime	equ	$1747E
setvideo	equ	$3DD16
song	equ	$371D2
songdelay	equ	$1AD6E
stop_current_song	equ	$47DB0
tmstruct	equ	$1834C
updatecrowdf	equ	$2BD28
updatepwrplay	equ	$3C2D0
updatereplay	equ	$2F844
updatesound	equ	$3E8CE
X_14988	equ	$14988
X_1498A	equ	$1498A
X_150B2	equ	$150B2

	org	$10B58

	dc.w	$0C79,$0002,$0001,$80E4,$6C00,$000A,$08F9,$0007
	dc.w	$0001,$7F6E,$4EB9,$0003,$7206,$6100,$001A,$6100
	dc.w	$0440,$0839,$0000,$0001,$7F6A,$6700,$FFE8,$6100
	dc.w	$04EC,$6000,$FFE0
DoGameFrame						;wait for at least one vblank, then run one frame of game logic
	move.w	(ScoutSubStatus).l,d7
	sub.w	(OldVcount).l,d7		;number of frames since last loop
	beq.w	DoGameFrame
	move.w	(ScoutSubStatus).l,(OldVcount).l
	bsr.w	periodicevents
	bsr.w	X_1498A		;apply velocity and check collisions
	tst.w	(songdelay).l		;delayed song countdown
	beq.w	.nosong
	bmi.w	.nosong
	subi.w	#$1,(songdelay).l
	bne.w	.nosong
	jsr	(stop_current_song).l
	move.w	(delayedsong).l,-(sp)
	jsr	(song).l
.nosong	jsr	$25000.l
	bsr.w	X_150B2
	bsr.w	updatereplay-LOAD
	jmp	(setvideo).l
periodicevents						;Called every time thru game loop with d7 = elapsed frames
	jsr	$394F2.l
	bsr.w	updatecrowdf-LOAD
	jsr	(RunArenaAnim).l
	jsr	(updatesound).l
	bsr.w	clockcont-LOAD
	btst	#$7,$17F6A.l		;sfhor
	bne.w	X_14988		;exit if in horizontal mode
	sub.w	d7,(lldisp).l		;count down for screen updates
	bpl.w	X_14988
	addi.w	#$18,(lldisp).l		;jps: only update once per second
	jsr	$35012.l
	bsr.w	UpdateCwdExcite
	bsr.w	CheckLateGameSong
	bsr.w	RestoreBenchEnergy
	bsr.w	.l10C44
	jmp	(updatepwrplay).l
.l10C44	subi.w	#$1,$1806A.l
	bne.w	X_14988
	jmp	$40D50.l
RestoreBenchEnergy						;Called once per second. Restore energy for players on the bench
	tst.w	(OptLine).l
	bne.w	.ex		;exit if line changes are off
	movea.l	#tmstruct,a2		;team 1
	bsr.w	.notinprog
	lea.l	$366(a2),a2		;team 2 (tmsize)
.notinprog	moveq	#$32,d0		;(maxros-1)*2
.b0	cmpi.w	#$FFFE,$68(a2,d0.w)		;tmpdst: -2 = bench, -1 = ice, 0+ = pen box
	bne.w	.next
	addi.w	#$9,$34(a2,d0.w)		;tmpde: energy +9
	cmpi.w	#$1000,$34(a2,d0.w)
	blt.w	.next
	move.w	#$1000,$34(a2,d0.w)		;max energy
.next	subi.w	#$2,d0		;next roster slot
	bpl.w	.b0
.ex	rts		;exit (also the end of the code above)
CheckLateGameSong						;Called once per second. 3rd period: choose and play a song once at the
									;random trigger time set by ResetClock
	cmpi.w	#$2,$180E4.l		;3rd period only
	bne.w	.x
	btst	#$4,$17F68.l
	bne.w	.x
	move.w	(gameclock).l,d0
	cmp.w	(periodendtime).l,d0
	bgt.w	.x		;not there yet
	st.b	(periodendtime).l		;high byte $FF: trigger goes negative, fires once
	move.w	(HomeTeam).l,(HmTeam).l
	move.w	#$5,(SongIndex).l
	jsr	(ChooseSong).l
	move.w	(SongNum).l,-(sp)
	jsr	(song).l
.x	rts		;exit (also the end of the code above)
UpdateCwdExcite						;called once per second. Track peak and running total of crowd excitement,
									;then
									;decay the level by 1 (floor 0)
	move.w	(CwdExciteLvl).l,d0
	cmp.w	(MaxCwdExciteLvl).l,d0
	bls.w	.less
	move.w	d0,(MaxCwdExciteLvl).l		;new peak
.less	ext.l	d0		;add to the running total
	add.l	d0,(SumCwdExciteLvl).l		;running total
	addi.w	#$1,$17CDC.l		;sample count
	subi.w	#$1,(CwdExciteLvl).l		;decay
	bpl.w	.ex
	clr.w	(CwdExciteLvl).l
.ex	rts		;exit (also the end of the code above)
