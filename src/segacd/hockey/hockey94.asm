;	HOCKEY.BIN $10614-$10B1D (runtime $2B614-$2BB1D): hockey94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	Part 1 of hockey94 (parts 2 and 3 are hockey94_2.asm and hockey94_3.asm). StartGame, the period
;	start and the clock are the cartridge code. CD: VBjsr and Begin (the cold start) are not here (Begin is
;	in sram94.asm, file $7096). LoadGameGfx (CD-only, called from StartGame and cards94) loads the game
;
;	graphics file through the BIOS and fills the graphics pointer table (cdgfxptrs.asm). BIOS calls ($5F22,
;	$6044) and the sub CPU flag ($FF800F bit 5) replace the interrupt masking around screen setups.

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

LoadCrowdRec	equ	$22E38
Create_HotCold_Table	equ	$2308E
ChooseSong	equ	$2A478
DoGameFrame	equ	$2BB8E
PeriodOver_sp	equ	$35A94
assreplace	equ	$362E4
randomd0	equ	$37050
ReadJoy1	equ	$374F0
InitSaveRAM	equ	$37598
InitScores	equ	$3CB50
setupice	equ	$3E91C
clearTeamStats	equ	$3F11E
p_turnoff	equ	$47DAC
GamePcmSounds	equ	$222EA
GamePcmSampleList	equ	$223D6

	org	$2B614

LoadGameGfx							;CD-only routine (a name given here, not a cartridge name)
	jsr	(InitSaveRAM).l
;CD: no cartridge twin
	move.w	#$D,d7
	jsr	$6044.w
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$60,d0
	jsr	$6044.w
	move.l	a0,$47DA0.l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	$47DA0.l,a1
	lea	(GamePcmSampleList).l,a2
	lea	(GamePcmSounds).l,a3
	move.w	#$8,d7
	jsr	$6044.w
	jsr	(InitSaveRAM).l
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$1,d0
	jsr	$6044.w
	move.l	a0,$47D60.l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	$47D60.l,a0
	move.l	a0,d0
	move.l	(a0)+,(SmallFontMapPtr).l
	add.l	d0,(SmallFontMapPtr).l
	move.l	(a0)+,(RinktilelistPtr).l
	add.l	d0,(RinktilelistPtr).l
	move.l	(a0)+,(EnergyBarMapPtr).l
	add.l	d0,(EnergyBarMapPtr).l
	move.l	(a0)+,(CrowdSpritesPtr).l
	add.l	d0,(CrowdSpritesPtr).l
	move.l	(a0)+,(BigFontMapPtr).l
	add.l	d0,(BigFontMapPtr).l
	move.l	(a0)+,(EASportsMapPtr).l
	add.l	d0,(EASportsMapPtr).l
	move.l	(a0)+,(ZamSpritesPtr).l
	add.l	d0,(ZamSpritesPtr).l
	move.l	(a0)+,(FaceOffSpritesPtr).l
	add.l	d0,(FaceOffSpritesPtr).l
	move.l	(a0)+,(RefsMapPtr).l
	add.l	d0,(RefsMapPtr).l
	move.l	(a0)+,(RefMap2Ptr).l
	add.l	d0,(RefMap2Ptr).l
	move.l	(a0)+,(TeamblocksmapPtr).l
	add.l	d0,(TeamblocksmapPtr).l
	move.l	(a0)+,(FramerMapPtr).l
	add.l	d0,(FramerMapPtr).l
	move.l	(a0)+,(ScoresMapPtr).l
	add.l	d0,(ScoresMapPtr).l
	move.l	(a0)+,(FaceOffMapPtr).l
	add.l	d0,(FaceOffMapPtr).l
	move.l	(a0)+,(HotListPtr).l
	add.l	d0,(HotListPtr).l
	move.l	(a0)+,(EASportsBGMapPtr).l
	add.l	d0,(EASportsBGMapPtr).l
	move.l	(a0)+,(RevRinkTilelistPtr).l
	add.l	d0,(RevRinkTilelistPtr).l
	move.l	(a0)+,(ReplayMapPtr).l
	add.l	d0,(ReplayMapPtr).l
	move.l	(a0)+,(IceRinkHorMapPtr).l
	add.l	d0,(IceRinkHorMapPtr).l
	move.l	(a0)+,(PrintFont2MapPtr).l
	add.l	d0,(PrintFont2MapPtr).l
	move.l	(a0)+,(NHLLogoMapPtr).l
	add.l	d0,(NHLLogoMapPtr).l
	move.l	(a0)+,(NHLPALogoMapPtr).l
	add.l	d0,(NHLPALogoMapPtr).l
	move.l	(a0)+,(HotMapPtr).l
	add.l	d0,(HotMapPtr).l
	move.l	(a0)+,(ColdMapPtr).l
	add.l	d0,(ColdMapPtr).l
	move.l	(a0)+,$47DA8.l
	add.l	d0,$47DA8.l
	lea	$2A9FA.l,a2
	move.w	(HomeTeam).l,d0
	asl.w	#$2,d0
	movea.l	(a2,d0.w),a2
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	a2,d0
	jsr	$6044.w
	move.l	a0,(HomeTeamGfxPtr).l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$2,d0
	jsr	$6044.w
	move.l	a0,$47D24.l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	move.w	#$2,d0
	jsr	$5F22.w
	rts
StartGame							;reset game state for a new game, then start the first period (CD: entered
									;here; the cartridge StartGame starts at its first twin line, $2B808)
	move.w	#$2,d0
	jsr	$5F22.w
	bclr.b	#$5,$FF800F.l

	st.b	(arenaanim).l
	clr.l	(homepresses).l
	clr.l	(awaypresses).l
	clr.l	(homedirpresses).l
	clr.l	(awaydirpresses).l
;CD: no cartridge twin
	clr.w	$191CE.l
	jsr	(InitSaveRAM).l
	jsr	$376F2.l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst.b	#$5,$FF800F.l
	beq.s	.L2B850
	move.w	#$1,-(a6)
	bra.s	.L2B854
.L2B850
	move.w	#$0,-(a6)
.L2B854
	bclr.b	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	jsr	(LoadGameGfx).l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.s	.L2B880
	bset.b	#$5,$FF800F.l
	bra.s	.L2B888
.L2B880
	bclr.b	#$5,$FF800F.l
.L2B888
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	jsr	$37752.l
	lea	$1746A.l,a0
	move.w	#$10,d0
	jsr	$5F22.w
	move.w	#$2,d0
	jsr	$5F22.w
.L2B8AC
	move.w	#$80,d0
	jsr	$5F22.w
	bcs.w	.L2B8AC
.L2B8B8
	move.w	#$81,d0
	jsr	$5F22.w
	move.w	(a0),d2
	andi.w	#$FF00,d2
	cmpi.w	#$0,d2
	bne.s	.L2B8B8
	move.w	#$5,$19364.l
	move.w	#$13,d0
	lea	$19364.l,a0
	jsr	$5F22.w
	jsr	(ReadJoy1).l				;pad 1 = $E0 at game start forces 30 second periods
	cmpi.b	#$E0,d3
	bne.w	.chkpen
	move.w	#3,(Optperlen).l		;period length index 3 = 30 seconds
.chkpen	clr.b	(gmode).l			;clear the game mode
	cmpi.w	#1,(OptPen).l
	bne.w	.0
	bset.b	#gmoffs,(gmode).l		;gmoffs: offsides pen. is active
.0	cmpi.w	#1,(OptPlayMode).l		;OptPlayMode test (shot buffer)
	ble.w	.1						;OptPlayMode 0-1 keep the shot buffer
	bsr.w	ClearShotData
.1	jsr	(clearTeamStats).l			;reset team stats
	btst.b	#0,(gmode2).l
	beq.w	.noso
	move.l	a0,-(sp)
	movea.l	#tmstruct,a0
	jsr	(Create_HotCold_Table).l
	movea.l	#awtmstruct,a0
	jsr	(Create_HotCold_Table).l
	movea.l	(sp)+,a0
.noso	clr.w	(ScoreSumbytes).l	;no shootout: clear the summaries
	clr.w	(PenSumLength).l
	clr.w	(gsp).l					;first period
	clr.w	(ChkCnt).l
	bsr.w	restoreteams
	jsr	(InitScores).l
	jsr	(setupice).l
	jsr	(LoadCrowdRec).l
	jmp	(PeriodOver_sp).l			;on to period start
;CD: no cartridge twin
ClearShotData						;CD: placed where the disc branches to it
	move.w	#$71,d0
	movea.l	#(outputbuffer-M68K_RAM),a0	;shot data buffer
.0	clr.w	(a0)+					;clear one word
	dbf	d0,.0
	rts

restoreteams						;Put both teams' rosters on the bench
	movea.l	#$1834C,a2				;team 1 (CD: the cartridge has #(tmstruct-M68K_RAM))
	bsr.w	.r
	adda.w	#tmsize,a2				;team 2
.r									;reset one team struct (a2), falls in for team 2
	move.w	#6,tmap(a2)				;tmap: no players in pen. box
	moveq	#(maxros-1)*2,d0		;(maxros-1)*2
.0	move.w	#$FFFE,tmpdst(a2,d0.w)	;tmpdst: -2 = all players on bench
	subi.w	#2,d0
	bpl.w	.0
	rts

ResetClock							;set period length and stop clock
	bsr.w	GetPeriodTime			;d0 = period length in seconds
	cmpi.w	#3,(gsp).l				;overtime?
	blt.w	.0
	tst.w	(OptPlayMode).l
	bne.w	.0
	move.w	#$258,d0				;OptPlayMode 0 overtime is always 10:00
.0	move.w	d0,(gameclock).l		;set the clock
	move.w	d0,(PerTimeTotal).l
	move.w	d0,(periodendtime).l	;CheckLateGameSong trigger time =
	asr.w	#1,d0
	jsr	(randomd0).l
	sub.w	d0,(periodendtime).l	;length - random(length/2)
	bset.b	#gmclock,(gmode).l		;gmclock: stop clock
	rts

GetPeriodTime						;Return d0 = period length in seconds for the period length option
	move.w	(Optperlen).l,d0
	asl.w	#1,d0
	lea	.timetab(pc),a0
	move.w	(a0,d0.w),d0
	rts
.timetab							;Period length in seconds: 5, 10, 20 min, 30 sec
	dc.w	5*60,10*60,20*60,30
;CD: no cartridge twin
	bclr.b	#$5,$FF800F.l
	move.w	#$FFFF,(palcount).l
	move.w	#$8400,d1
	move.w	#$85,d0
	jsr	$5F22.w

StartPer							;start a period: reset stack, rink and clock, face off, run the game loop
	cmpi.w	#3,(gsp).l
	bne.w	.reg
	bset.b	#1,(sflags7).l			;overtime
.reg	st.b	(faceoffanim).l		;start the faceoff
	jsr	(p_turnoff).l				;sound off
	jsr	(setupice).l
	bsr.w	ResetClock
	ori.w	#$F000,(PadControlBits).l
	st.b	(c1playernum).l			;no controlled player yet
	st.b	(c2playernum).l
	movea.l	#$17B80,a3				;puck (CD: the cartridge has #(puckx-M68K_RAM))
	clr.w	(fox).l					;face off at center ice
	clr.w	(foy).l
	btst.b	#0,(gmode2).l
	beq.w	.fo
	move.w	#$1E,d0
	move.w	#8,(BA_Skater_Offset).l
	move.w	#$B,(BA_Goalie_SCnum).l
	bra.w	.ass
.fo	moveq	#$1B,d0					;pfaceoff
.ass	jsr	(assreplace).l			;face off starts period
	bset.b	#sf2drec,(sflags2).l	;sf2drec: don't record
	bclr.b	#sfwrap,(sflags).l		;sfwrap: reset replay stuff
	move.w	#$FFFF,(lastsfx).l
	move.l	#replaystart,(recbpr).l	;replaystart
	move.w	(Vcount).l,(OldVcount).l
	bsr.w	DoGameFrame				;run two frames before the loop
	move.w	#$FFFF,(palcount).l
	bsr.w	DoGameFrame
	move.w	(gamelevel).l,d0
	asl.w	#4,d0
	move.w	d0,(CwdExciteLvl).l		;starting excitement = gamelevel*16
	clr.w	(CurCrowdMeter).l
	move.w	(HomeTeam).l,(HmTeam).l
	move.w	#SngPeriodStart,(SongIndex).l
	jsr	(ChooseSong).l
