;	Playoff seeding, schedule, series tracking, and PlayoffTreeScreen. Ported from NHL 95 awards95.asm.
InitPlayoffs	;Seed the playoffs: the two conferences (ConferenceTeams1 / 2) sorted by points (SortSeeds), 1 v 8 ... 4 v 5 to save RAM SRPOPairings
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$B,d0
	movea.l	#AwardIds,a0
	movea.l	#ConferenceTeams1,a1
	bsr.w	CopyBytes
	move.w	#$D,d0
	movea.l	#AwardIds+$14,a0
	movea.l	#ConferenceTeams2,a1
	bsr.w	CopyBytes
	movea.l	#StandingsBuf,a0
	jsr	(ReadStandings).l
	bsr.w	CalcSeedPoints
	move.w	#$C,(SeedCount).w
	movea.l	#AwardIds,a0
	bsr.w	SortSeeds
	move.w	#$E,(SeedCount).w
	movea.l	#AwardIds+$14,a0
	bsr.w	SortSeeds
	movea.l	#SaveRAM+2*SRPOPairings,a0
	movea.l	#AwardIds,a1
	movea.l	#AwardIds+$14,a2
	bsr.w	SeedPairings
	exg	a1,a2
	bsr.w	SeedPairings
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

SeedPairings	;Write the pairings 1 v 8, 2 v 7, 3 v 6, 4 v 5 of the sorted teams a1 to a0
	clr.w	d0
	move.b	(a1),d0
	move.w	d0,(a0)+
	move.b	7(a1),d0
	move.w	d0,(a0)+
	move.b	1(a1),d0
	move.w	d0,(a0)+
	move.b	6(a1),d0
	move.w	d0,(a0)+
	move.b	2(a1),d0
	move.w	d0,(a0)+
	move.b	5(a1),d0
	move.w	d0,(a0)+
	move.b	3(a1),d0
	move.w	d0,(a0)+
	move.b	4(a1),d0
	move.w	d0,(a0)+
	rts

SortSeeds	;Bubble sort the SeedCount team bytes at a0 by SeedPoints, then SeedGames, highest first
	movea.l	#SeedPoints,a1
	movea.l	#SeedGames,a2
.pass
	bclr	#6,(sflags6).w
	clr.w	d7
.cmp
	clr.w	d6
	move.b	(a0,d7.w),d6
	move.b	(a1,d6.w),d0
	move.b	1(a0,d7.w),d6
	cmp.b	(a1,d6.w),d0
	bhi.w	.next
	blo.w	.swap
	move.b	(a0,d7.w),d6
	move.b	(a2,d6.w),d0
	move.b	1(a0,d7.w),d6
	cmp.b	(a2,d6.w),d0
	bls.w	.next
.swap
	bset	#6,(sflags6).w
	move.b	(a0,d7.w),d5
	move.b	1(a0,d7.w),d4
	move.b	d5,1(a0,d7.w)
	move.b	d4,(a0,d7.w)
.next
	addq.w	#2,d7
	cmp.w	(SeedCount).w,d7
	bge.w	.chk
	subq.w	#1,d7
	bra.s	.cmp
.chk
	btst	#6,(sflags6).w
	bne.s	.pass
	rts

CalcSeedPoints	;SeedPoints = 2 * wins + ties and SeedGames = wins + losses + ties of the 26 teams (StandingsBuf)
	move.w	#$1A,d0
	movea.l	#StandingsBuf,a1
	movea.l	#SeedPoints,a2
	movea.l	#SeedGames,a3
	clr.w	d2
	bra.w	.next
.team
	move.w	d2,d5
	mulu.w	#3,d2
	clr.w	d3
	move.b	(a1,d2.w),d3
	add.b	d3,d3
	add.b	1(a1,d2.w),d3
	move.b	d3,(a2,d5.w)
	move.b	(a1,d2.w),d3
	add.b	1(a1,d2.w),d3
	add.b	2(a1,d2.w),d3
	move.b	d3,(a3,d5.w)
	move.w	d5,d2
	addq.w	#1,d2
.next
	dbf	d0,.team
	rts

CopyBytes	;Copy d0 + 1 bytes from a1 to a0
	move.b	(a1)+,(a0)+
	dbf	d0,CopyBytes
	rts

ConferenceTeams1	;The 12 teams of the first conference
	dc.b	0,3,7,$A,$13,$17,4,5,6,$14,$16,$19

ConferenceTeams2	;The 14 teams of the second conference
	dc.b	1,2,9,$B,$F,$11,$12,8,$C,$D,$E,$10,$15,$18

SetupPlayoffs	;Start the playoffs: save the season header (SRSeasonHeaderSave), reset it for the playoffs (SeasonFlags bit 5), clear the playoff stats, round 1 (NextPlayoffRound)
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#SaveRAM+2*SRSeasonHeader,a0
	movea.l	#SaveRAM+2*SRSeasonHeaderSave,a1
	move.w	#8,d0
	subq.w	#1,d0
.save
	move.w	(a0)+,(a1)+
	dbf	d0,.save
	movea.l	#SaveRAM+2*SRSeasonHeader,a0
	clr.w	(a0)
	move.w	#1,d0
	btst	#1,(SeasonDay+1).w
	beq.w	.games
	move.w	#7,d0
.games
	move.w	d0,2(a0)
	clr.w	4(a0)
	jsr	(ReadSeasonHeader).l
	bset	#5,(SeasonDay+1).w
	jsr	(WriteSeasonHeader).l
	movea.l	#SaveRAM+2*SRGameResults,a0
	move.w	#$CCC,d0
	subq.w	#1,d0
.clrres
	clr.w	(a0)+
	dbf	d0,.clrres
	movea.l	#SaveRAM+2*SRPOStandings,a0
	move.w	#$4E,d0
	subq.w	#1,d0
.clrpost
	clr.w	(a0)+
	dbf	d0,.clrpost
	movea.l	#SaveRAM+2*SRPOGoals,a0
	move.w	#$1B6C,d0
	subq.w	#1,d0
.clrgoals
	clr.w	(a0)+
	dbf	d0,.clrgoals
	movea.l	#SaveRAM+2*SRPOTeamStats,a0
	move.w	#$104,d0
	subq.w	#1,d0
.clrteam
	clr.w	(a0)+
	dbf	d0,.clrteam
	clr.l	(SaveRAM+2*(SRSeasonHeaderSave+8)).l
	move.l	#0,(SaveRAM+2*SRPORound).l
	bsr.w	NextPlayoffRound
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

RestoreSeasonHeader	;Put back the season header saved by SetupPlayoffs. Nothing calls it
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#SaveRAM+2*SRSeasonHeader,a0
	movea.l	#SaveRAM+2*SRSeasonHeaderSave,a1
	move.w	#8,d0
	subq.w	#1,d0
.copy
	move.w	(a1)+,(a0)+
	dbf	d0,.copy
	jsr	(ReadSeasonHeader).l
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

NextPlayoffRound	;Next playoff round: the winners of the last round (CollectSeriesWinners), the series (InitPlayoffSeries) and the games (BuildPlayoffDayGames)
	movem.l	d0-d7/a0-a6,-(sp)
	clr.l	(SaveRAM+2*SRPODay).l
	move.l	(SaveRAM+2*SRPORound).l,d0
	tst.b	d0
	beq.w	.first
	bsr.w	CollectSeriesWinners
.first
	bsr.w	InitPlayoffSeries
	bsr.w	BuildPlayoffDayGames
	movem.l	(sp)+,d0-d7/a0-a6
	rts

InitPlayoffSeries	;The series of the round at save RAM SRPOSeries ($20 bytes each: the two teams, wins cleared)
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	GetRoundPairings
	movea.l	#SaveRAM+2*SRPOSeries,a0
	bsr.w	SeriesInRound
	move.w	d0,d5
	subq.w	#1,d5
.series
	move.w	(a1)+,d0
	andi.w	#$FF,d0
	ext.l	d0
	move.l	d0,(a0)
	move.w	(a1)+,d0
	andi.w	#$FF,d0
	ext.l	d0
	move.l	d0,4(a0)
	move.l	#$10000,$1C(a0)
	clr.l	8(a0)
	clr.l	$C(a0)
	adda.w	#$20,a0
	dbf	d5,.series
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

BuildPlayoffDayGames	;The games of day SeasonDay: the series of the round not yet won (4 wins, 1 without SeasonFlags bit 1); d0 = the count (0 = round over)
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#SaveRAM+2*(SRPOSchedule+1),a0
	clr.w	d0
	move.b	(SeasonDay).w,d0
	bra.w	.day
.skipday
	move.w	(a0)+,d1
	andi.w	#$FF,d1
	asl.w	#2,d1
	adda.w	d1,a0
.day
	dbf	d0,.skipday
	bsr.w	GetRoundPairings
	movea.l	a0,a2
	clr.w	(a0)
	addq.w	#2,a2
	bsr.w	SeriesInRound
	subq.w	#1,d0
	movea.l	#SaveRAM+2*(SRPOSeries+4),a4
.series
	move.w	2(a4),d1
	move.b	#4,d6
	btst	#1,(SeasonDay+1).w
	bne.w	.3
	move.b	#1,d6
.3
	cmp.b	d6,d1
	bge.w	.next
	move.w	6(a4),d1
	move.b	#4,d6
	btst	#1,(SeasonDay+1).w
	bne.w	.4
	move.b	#1,d6
.4
	cmp.b	d6,d1
	bge.w	.next
	move.w	(a1),(a2)+
	move.w	2(a1),(a2)+
	addq.w	#1,(a0)
.next
	addq.w	#4,a1
	adda.w	#$20,a4
	dbf	d0,.series
	move.l	a0,-(sp)
	jsr	(MakeSRAMChecksum).l
	movea.l	(sp)+,a0
	move.w	(a0),d0
	tst.b	d0
	movem.l	(sp)+,d0-d7/a0-a6
	rts

SeriesInRound	;d0 = the series in the round (SeriesCountTbl)
	movem.l	a3,-(sp)
	movea.l	#SeriesCountTbl,a3
	move.w	(SaveRAM+2*(SRPORound+1)).l,d0
	andi.w	#$FF,d0
	add.w	d0,d0
	move.w	(a3,d0.w),d0
	movem.l	(sp)+,a3
	rts

SeriesCountTbl	;Series per round
	dc.w	8,4,2,1

GetRoundPairings	;a1 = the pairings of the round in save RAM SRPOPairings
	movem.l	d0/a0,-(sp)
	movea.l	#SaveRAM+2*SRPOPairings,a1
	move.w	(SaveRAM+2*(SRPORound+1)).l,d0
	andi.w	#$FF,d0
	movea.l	#RoundPairOffsets,a0
	move.b	(a0,d0.w),d0
	andi.w	#$FF,d0
	adda.w	d0,a1
	movem.l	(sp)+,d0/a0
	rts

RoundPairOffsets	;GetRoundPairings offset of each round
	dc.b	0,$20,$30,$38,$3C,$FF

ReadPlayoffSchedule	;PlayoffSchedule = the low bytes of the $EF words at save RAM SRPOSchedule
	movem.l	d4-d5/a5-a6,-(sp)
	movea.l	#SaveRAM+2*SRPOSchedule,a5
	move.w	#$EF,d4
	subq.w	#1,d4
	movea.l	#picturebuf,a6
.copy
	move.w	(a5)+,d5
	move.b	d5,(a6)+
	dbf	d4,.copy
	movem.l	(sp)+,d4-d5/a5-a6
	rts

RecordPlayoffGame	;In the playoffs (SeasonFlags bit 5): add the game a0 (teams, scores) to its series wins
	btst	#5,(SeasonDay+1).w
	beq.w	.exit
	movem.l	d0-d7/a0-a6,-(sp)
	clr.w	d0
	move.b	(a0),d0
	movea.l	#SaveRAM+2*SRPOSeries,a1
.find
	move.l	(a1),d1
	cmp.b	d0,d1
	beq.w	.found
	move.l	4(a1),d1
	cmp.b	d0,d1
	beq.w	.found
	adda.w	#$20,a1
	bra.s	.find
.found
	move.b	3(a0),d1
	cmp.b	2(a0),d1
	blt.w	.winner
	move.b	1(a0),d0
.winner
	move.l	(a1),d1
	cmp.b	d0,d1
	beq.w	.team1
	move.l	$C(a1),d1
	addq.b	#1,d1
	move.l	d1,$C(a1)
	bra.w	.done
.team1
	move.l	8(a1),d1
	addq.b	#1,d1
	move.l	d1,8(a1)
.done
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d7/a0-a6
.exit
	rts

CollectSeriesWinners	;The winners of the round series to the next round pairings (RoundSeriesOffsets, RoundSeriesCounts)
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#SaveRAM+2*SRPOPairings,a0
	move.l	(SaveRAM+2*SRPORound).l,d0
	andi.w	#$FF,d0
	move.w	d0,-(sp)
	add.w	d0,d0
	movea.l	#RoundSeriesOffsets,a1
	move.w	(a1,d0.w),d0
	adda.w	d0,a0
	movea.l	#RoundSeriesCounts,a1
	move.w	(sp)+,d0
	move.b	(a1,d0.w),d0
	move.w	d0,d1
	asr.w	#1,d1
	subq.w	#1,d1
	movea.l	#SaveRAM+2*SRPOSeries,a1
.pair
	move.l	(a1),d2
	move.l	8(a1),d3
	move.l	$C(a1),d4
	cmp.b	d4,d3
	bgt.w	.1
	move.l	4(a1),d2
.1
	move.w	d2,-(sp)
	adda.w	#$20,a1
	move.l	(a1),d2
	move.l	8(a1),d3
	move.l	$C(a1),d4
	cmp.b	d4,d3
	bgt.w	.2
	move.l	4(a1),d2
.2
	adda.w	#$20,a1
	move.w	(sp)+,(a0)+
	move.w	d2,(a0)+
	dbf	d1,.pair
	jsr	(MakeSRAMChecksum).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

RoundSeriesOffsets	;CollectSeriesWinners pairing offset of each round
	dc.w	0,$20,$30,$38

RoundSeriesCounts	;CollectSeriesWinners series of each round
	dc.b	0,8,4,2,1,$FF

PlayoffTreeScreen	;Playoff tree: the series (gsstruct), bosgames, gamelevel and the pairings (potree) from save RAM, then PlayoffScreen (sflags11 bit 2)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#7,d0
	movea.l	#gsstruct,a0
	movea.l	#SaveRAM+2*SRPOSeries,a1
	move.w	#$40,d1
.series
	move.l	(a1)+,d2
	andi.w	#$FF,d2
	move.w	d2,(a0)+
	dbf	d1,.series
	move.l	(SaveRAM+2*SRPODay).l,d0
	andi.w	#$FF,d0
	move.w	d0,(bosgames).w
	btst	#1,(SeasonDay+1).w
	bne.w	.1
	move.w	#7,(bosgames).w
.1
	move.l	(SaveRAM+2*SRPORound).l,d0
	andi.w	#$FF,d0
	move.w	d0,(gamelevel).w
	bset	#2,(sflags11).w
	move.w	#$20,d0
	subq.w	#1,d0
	movea.l	#SaveRAM+2*SRPOPairings,a0
	movea.l	#potree,a1
.pairs
	move.w	(a0)+,d1
	move.b	d1,(a1)+
	dbf	d0,.pairs
	jsr	(PlayoffScreen).l
	bclr	#2,(sflags11).w
	movem.l	(sp)+,d0-d7/a0-a6
	rts
