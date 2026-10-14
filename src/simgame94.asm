;	Simulated game player stats (ported from NHL 95 season95.asm). Called from SimDayGames.

SimGameStats	;Fill the team structs for a simulated game a0 (teams, scores, shots, scorers, goalies) and SaveSimGame
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(vcount).w,d0
	jsr	(randomd0).l
	movea.l	#tmstruct,a1
	move.w	#$365,d0
.loop
	clr.w	(a1)+
	dbf	d0,.loop
	clr.w	d0
	move.b	(a0),d0
	move.w	d0,(HomeTeam).w
	clr.w	d0
	move.b	1(a0),d0
	move.w	d0,(VisTeam).w
	movea.l	#tmstruct,a1
	movea.l	#AwShots,a2
	move.w	(HomeTeam).w,$28(a1)
	move.w	(VisTeam).w,Xvel(a2)
	clr.w	d0
	move.b	2(a0),d0
	move.w	d0,tmscore(a1)
	move.w	d0,(rosterscroll).w
	move.w	(HomeTeam).w,d1
	bsr.w	SimShots
	move.w	d0,(a1)
	bsr.w	SimScorers
	clr.w	d0
	move.b	3(a0),d0
	move.w	d0,tmscore(a2)
	move.w	d0,(rosterscroll).w
	move.w	(VisTeam).w,d1
	bsr.w	SimShots
	move.w	d0,(a2)
	movea.l	a2,a1
	bsr.w	SimScorers
	bsr.w	SimGoalieStats
	tst.b	(SeasonPen).w
	beq.w	.3
	move.l	a0,-(sp)
	movea.l	#SimTeamTbl,a0
	move.w	(HomeTeam).w,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d1
	move.w	#$258,d0
	jsr	(randomd0s).l
	add.w	d0,d1
	bpl.w	.1
	clr.w	d1
.1
	ext.l	d1
	divu.w	#$64,d1
	move.w	d1,(tmstruct+8).w
	movea.l	#SimTeamTbl,a0
	move.w	(VisTeam).w,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d1
	move.w	#$258,d0
	jsr	(randomd0s).l
	add.w	d0,d1
	bpl.w	.2
	clr.w	d1
.2
	ext.l	d1
	divu.w	#$64,d1
	move.w	d1,(AwShots+8).w
	movea.l	(sp)+,a0
.3
	bclr	#1,(SimFlags).w
	jsr	(SaveSimGame).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

SimTeamTbl	;Penalty minutes x100 per team: SimGameStats adds random +-$258 and stores /100 at team struct +8
	dc.w	$73A,$6AE,$834,$8CA,$99C,$8DE,$85C,$8C0,$7A8,$898,$9A6,$712,$820
	dc.w	$866,$820,$7DA,$7BC,$758,$7B2,$654,$758,$708,$8AC,$910,$956,$A0A

SimGoalieStats	;SimGoalie for the home and the away team
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(HomeTeam).w,d7
	movea.l	#tmstruct,a1
	movea.l	#AwShots,a2
	bsr.w	SimGoalie
	move.w	(VisTeam).w,d7
	movea.l	#AwShots,a1
	movea.l	#tmstruct,a2
	bsr.w	SimGoalie
	movem.l	(sp)+,d0-d7/a0-a6
	rts

SimGoalie	;Credit the goalie (1/16 the backup): $E10 more time, the shots and goals against
	jsr	(GetGoalieCountD7).l
	subq.w	#1,d0
	bsr.w	PickSimGoalie
	move.w	d0,d3
	add.w	d3,d3
	addi.w	#$138,d3
	addi.w	#$E10,(a1,d3.w)
	move.w	(a2),d4
	cmp.w	#$FF,d4
	ble.w	.0
	move.w	#$FF,d4
.0
	move.w	d0,d3
	addi.w	#$EA,d3
	move.b	d4,(a1,d3.w)
	move.w	$C(a2),d4
	move.w	d0,d3
	addi.w	#$B6,d3
	move.b	d4,(a1,d3.w)
	rts

PickSimGoalie	;d0 = 1 one time in 16, else 0
	movem.l	d1-d7,-(sp)
	clr.w	d1
	move.w	#$F,d0
	jsr	(randomd0).l
	bne.w	.0
	move.w	#1,d1
.0
	move.w	d1,d0
	movem.l	(sp)+,d1-d7
	rts

SimScorers	;Give each goal of team d1 to a skater picked from TeamScoringTbls, with SimAssists
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	d1,d7
	jsr	(GetGoalieCountD7).l
	move.w	d0,d2
	move.w	d0,(TempRawSpd).w
	jsr	(GetPlayerCountD7).l
	move.w	d0,d3
	move.w	d0,(TempMaxSpd).w
	move.w	d3,d0
	sub.w	d2,d0
	movea.l	#TeamScoringTbls,a2
	move.w	d1,d7
	asl.w	#2,d7
	movea.l	(a2,d7.w),a2
	clr.w	d7
	clr.w	d4
	move.w	d2,d5
	add.w	d5,d5
	bra.w	.1
.loop
	clr.w	d6
	move.b	(a2,d5.w),d6
	add.w	d6,d7
	move.b	1(a2,d5.w),d6
	add.w	d6,d4
	addq.w	#2,d5
.1
	dbf	d0,.loop
	move.w	d4,(rosterteam).w
	move.w	(rosterscroll).w,d1
	bra.w	.5
.goal
	move.w	d7,d0
	subq.w	#1,d0
	jsr	(randomd0).l
	clr.w	d6
	move.w	d2,d5
	add.w	d5,d5
	move.w	d2,d3
.pick
	clr.w	d4
	move.b	(a2,d5.w),d4
	add.w	d4,d6
	cmp.w	d0,d6
	bge.w	.4
	addq.w	#2,d5
	addq.w	#1,d3
	bra.s	.pick
.4
	move.l	a1,-(sp)
	adda.w	#$B6,a1
	addq.b	#1,(a1,d3.w)
	movea.l	(sp)+,a1
	bsr.w	SimAssists
.5
	dbf	d1,.goal
	movem.l	(sp)+,d0-d7/a0-a6
	rts

SimAssists	;Up to 2 assists for a goal (95% one, 75% two), PickAssist
	movem.l	d0-d7,-(sp)
	move.w	#$64,d0
	jsr	(randomd0).l
	cmp.w	#5,d0
	ble.w	.0
	move.w	d3,(TempLegSpd).w
	move.w	d3,(recwins).w
	move.w	d0,-(sp)
	bsr.w	PickAssist
	move.l	a1,-(sp)
	adda.w	#$D0,a1
	addq.b	#1,(a1,d0.w)
	movea.l	(sp)+,a1
	move.w	d0,(recwins).w
	move.w	(sp)+,d0
	cmp.w	#$19,d0
	ble.w	.0
	bsr.w	PickAssist
	move.l	a1,-(sp)
	adda.w	#$D0,a1
	addq.b	#1,(a1,d0.w)
	movea.l	(sp)+,a1
.0
	movem.l	(sp)+,d0-d7
	rts

PickAssist	;d0 = a skater picked from the assist weights, not the scorer or the first assist
	move.w	(rosterteam).w,d0
	subq.w	#1,d0
	jsr	(randomd0).l
	clr.w	d6
	move.w	(TempRawSpd).w,d5
	add.w	d5,d5
	move.w	(TempRawSpd).w,d3
.loop
	clr.w	d4
	move.b	1(a2,d5.w),d4
	add.w	d4,d6
	cmp.w	d0,d6
	bge.w	.1
	addq.w	#2,d5
	addq.w	#1,d3
	bra.s	.loop
.1
	cmp.w	(TempLegSpd).w,d0
	beq.s	PickAssist
	cmp.w	(recwins).w,d0
	beq.s	PickAssist
	move.w	d3,d0
	rts

TeamScoring0
	dc.b	$14,$1E,3,5,$17,$1C,$F,$B,$B,$13,8,$19,$13,$12,$15,$1F
	dc.b	$C,$16,9,9,8,3,$D,6,$12,$1B,1,5,$10,$1B,$C,$B
	dc.b	5,$F,7,$14,9,$B,3,9,$E,$19,3,5,1,9

TeamScoring1
	dc.b	$1E,$18,9,$B,$20,$50,8,$F,0,1,$1F,$14,7,3,$32,$18
	dc.b	5,$A,$A,$B,$12,$D,2,1,$D,$B,$C,7,$16,$20,6,$11
	dc.b	3,7,$14,$47,1,9,$F,$2B,6,$F,$E,$2C,1,6,1,8

TeamScoring2
	dc.b	$D,$F,$1E,$1A,6,$F,5,$D,$23,$33,$B,$E,3,4,$16,$10
	dc.b	$1B,$1F,$12,$1B,8,8,6,7,$15,$23,$20,$2F,$11,8,$1D,$1E
	dc.b	2,4,2,$B,7,$20,4,$14,6,8,2,$C,2,$E,$E,$1B

TeamScoring3
	dc.b	$1A,$16,$D,$D,$24,$27,$28,$35,$B,$C,$D,$2A,7,$17,$1B,$12
	dc.b	$29,$2B,3,8,$B,$1B,$28,$2D,5,5,9,$14,1,6,$A,$25
	dc.b	$A,$19,$1C,$36,1,$15,6,$F,1,8,2,$15,0,3,1,$B

TeamScoring4
	dc.b	$25,$1E,2,$F,$2E,$3D,9,$14,9,$1D,3,$D,2,6,$E,$15
	dc.b	$10,$E,$D,$B,$E,$E,4,2,$F,$12,$11,$19,$C,$E,$1F,$27
	dc.b	4,$18,$10,$2C,5,$16,3,9,4,8,1,1,6,$C,1,7

TeamScoring5
	dc.b	$18,$1B,$12,$F,$32,$2B,$20,$1D,$11,$23,2,5,$B,$21,$E,$18
	dc.b	3,$11,$11,$E,$14,$F,5,7,6,7,$D,$18,1,0,$17,$39
	dc.b	$C,$C,1,4,6,$12,$C,$13,1,$D,0,3,9,$25,$B,$21

TeamScoring6
	dc.b	$17,$2D,$17,$D,$18,$3A,$38,$40,$1F,$2A,5,8,6,$B,$22,$27
	dc.b	$A,$C,7,$A,4,4,8,$15,$1C,$1D,$34,$29,9,$11,6,7
	dc.b	0,7,$E,$3F,$D,$21,1,6,$A,$2E,4,$14,$C,$15,1,4

TeamScoring7
	dc.b	$16,$2D,3,$D,$18,$32,0,1,$21,$23,6,$15,4,7,$C,$D
	dc.b	$D,5,$19,$1D,4,6,$13,$12,$16,$23,$11,$F,3,5,$B,8
	dc.b	3,$12,8,$14,$C,$26,$B,$18,3,6,$B,$20,2,6,7,$18

TeamScoring8
	dc.b	$15,$24,$C,$E,$F,$19,$17,$18,9,$11,$11,$21,$12,$E,6,$17
	dc.b	$F,$16,$13,$1C,6,6,3,5,$D,$D,$1E,$1E,$28,$1E,4,5
	dc.b	6,$18,1,8,4,7,$E,$1D,1,9,2,0,4,8,2,2

TeamScoring9
	dc.b	$11,$1D,5,$C,5,$C,$10,$2A,2,$A,6,$C,4,$B,4,$F
	dc.b	$29,$1A,$C,$11,3,2,6,$A,$12,9,$A,$11,$25,$26,6,2
	dc.b	$18,$1A,4,$B,3,$13,1,$11,1,5,5,$10,5,$19,1,2

TeamScoring10
	dc.b	$16,$26,4,$10,$26,$5C,9,$A,8,$E,1,3,$F,$D,$2C,$2A
	dc.b	$A,9,$15,$15,$1F,$2E,7,$E,$C,3,3,4,$E,$11,$14,$30
	dc.b	$C,$28,7,$18,8,$1B,5,$D,1,5,2,6,1,9

TeamScoring11
	dc.b	$23,$1C,$C,$14,$17,$22,$13,$18,$E,$18,$D,$14,2,$A,$13,$1A
	dc.b	$28,$33,$A,$14,1,2,4,5,$10,$1E,$21,$26,$C,$F,6,8
	dc.b	$C,$17,$14,$20,2,$15,4,9,1,2,2,$C,$B,$1D,2,$C

TeamScoring12
	dc.b	$14,$F,$1B,$13,$C,$11,$13,$1B,$14,$1E,$A,$17,5,$A,$1A,$1F
	dc.b	$D,$14,$C,$F,$15,$14,4,$10,$12,$1A,$19,$13,$25,$21,$24,$24
	dc.b	0,5,$12,$3C,1,$E,8,$18,$A,$24,1,9,2,$11,2,$F

TeamScoring13
	dc.b	$1B,$20,8,$D,$26,$38,$15,$20,2,7,$12,$16,1,1,$24,$21
	dc.b	$19,$1F,$1E,$28,0,6,5,9,$2A,$21,$B,$13,$C,$1E,3,1
	dc.b	2,1,$A,$2F,1,$A,7,$E,9,$1F,3,$B,2,$B,1,4

TeamScoring14
	dc.b	$2A,$12,$A,$E,$1A,$3A,$16,$1B,$14,$D,$17,$21,3,5,$34,$1B
	dc.b	3,5,$16,$20,4,$B,4,7,$15,$14,$13,$13,$15,$27,2,1
	dc.b	$12,$17,$17,$38,3,$F,$C,$4D,8,8,5,$E,0,2,2,7

TeamScoring15
	dc.b	$B,$2D,0,2,$14,$1F,$1E,$31,2,4,$B,$F,$A,8,0,3
	dc.b	7,$10,2,5,2,4,$11,$1A,$B,8,7,$D,8,$B,2,3
	dc.b	2,5,0,2,3,$14,4,$13,6,9,4,$E,1,4,0,$15

TeamScoring16
	dc.b	$1D,$19,6,$16,$2C,$35,$23,$3E,$C,$18,4,$B,$B,$C,$14,$12
	dc.b	$26,$2C,$1C,$15,8,5,$28,$43,$13,$17,1,4,4,3,$A,$3C
	dc.b	5,$19,1,5,9,$2B,0,7,1,8,1,3,0,2,1,3

TeamScoring17
	dc.b	$16,$14,$15,$13,$11,$14,$1B,$42,$14,$16,4,$B,$29,$2F,$26,$20
	dc.b	$1E,$22,3,5,$12,$25,$E,$1A,$20,$43,$17,$23,4,7,0,0
	dc.b	5,8,5,$18,$11,$38,2,$C,2,2,3,8,6,$1C,2,4

TeamScoring18
	dc.b	$14,$1D,8,$10,$1C,$40,$1E,$15,$20,$35,$F,$19,$B,$11,9,$17
	dc.b	$1C,$25,4,4,0,4,$11,$14,6,8,$D,$F,2,2,$10,$11
	dc.b	$1A,$19,4,$F,5,$11,5,$14,0,$B,5,$C,4,$D,1,$B

TeamScoring19
	dc.b	$1E,$2C,3,7,$12,$26,$19,$29,$C,5,3,6,$C,$B,$C,$12
	dc.b	$C,$12,$12,$23,$E,$1A,$D,8,$F,$14,$19,$2C,$16,$1F,$1E,$26
	dc.b	7,$21,1,3,$1A,$26,6,$13,0,2,1,9,1,6

TeamScoring20
	dc.b	$24,$22,4,$A,$10,$44,5,$B,6,$E,6,$E,1,2,$34,$32
	dc.b	$F,$A,2,3,$39,$28,$17,$19,9,$10,9,$C,6,$A,2,5
	dc.b	1,0,7,$F,2,7,5,9,2,8,$C,$13,1,7,4,$14

TeamScoring21
	dc.b	2,4,$16,$27,$D,$1D,$18,$28,$12,$1C,8,7,4,9,$14,$17
	dc.b	$A,$A,$D,$C,6,6,$D,$F,$11,$17,$1C,$1B,1,2,$B,$14
	dc.b	3,$12,$B,$17,1,$F,3,6,1,2,0,0

TeamScoring22
	dc.b	$22,$1F,9,$A,8,$A,$1B,$54,$D,$11,5,6,8,8,4,4
	dc.b	$2E,$1E,$35,$2D,8,$B,7,9,9,$10,$E,$15,$22,$1E,$C,$12
	dc.b	4,$17,7,$24,9,$1B,2,8,3,$1B,5,$B,2,9,0,1

TeamScoring23
	dc.b	$17,$1D,$12,$E,$19,$2B,$B,$11,$F,$28,3,6,$1A,$2C,$10,$D
	dc.b	$D,$18,1,2,$E,$D,3,4,$3C,$2F,$20,$1D,$E,$E,7,7
	dc.b	0,$C,$D,$2A,$E,$34,1,9,5,$21,4,$1C,6,$E,1,$A

TeamScoring25
	dc.b	$15,$13,0,$A,$1A,$2D,$13,$20,$D,$1B,4,8,7,7,$29,$28
	dc.b	4,8,4,8,$15,$25,6,2,$19,$1D,5,$D,$21,$29,8,$B
	dc.b	3,$D,0,4,5,$12,8,$12,0,7,0,$11,4,$11,2,8

TeamScoring24
	dc.b	$18,$18,$D,$10,2,2,$1A,$2C,$13,$42,9,$1D,$E,$24,6,$13
	dc.b	$E,$19,$1D,$1D,7,7,$19,$11,$18,$13,$C,$E,$C,$12,$10,$13
	dc.b	$B,$12,$10,$18,1,$10,$10,$23,9,$21,0,7,0,9,7,9

TeamScoringTbls	;Per team: the goal / assist weights (2 bytes a player) used by SimScorers
	dc.l	TeamScoring0,TeamScoring1,TeamScoring2,TeamScoring3
	dc.l	TeamScoring4,TeamScoring5,TeamScoring6,TeamScoring7
	dc.l	TeamScoring8,TeamScoring9,TeamScoring10,TeamScoring11
	dc.l	TeamScoring12,TeamScoring13,TeamScoring14,TeamScoring15
	dc.l	TeamScoring16,TeamScoring17,TeamScoring18,TeamScoring19
	dc.l	TeamScoring20,TeamScoring21,TeamScoring22,TeamScoring23
	dc.l	TeamScoring24,TeamScoring25

SimShots	;d0 = d0 + 7 + a random pick from SimShotsTbl (46 weights)
	movem.l	d1-d7/a0-a6,-(sp)
	move.w	d0,-(sp)
	move.w	#$2D,d0
	movea.l	#SimShotsTbl,a1
	clr.w	d7
.loop
	clr.w	d6
	move.b	(a1)+,d6
	add.w	d6,d7
	dbf	d0,.loop
	move.w	d7,d0
	jsr	(randomd0).l
	move.w	#$2D,d1
	movea.l	#SimShotsTbl,a3
	clr.w	d2
	move.w	#7,d3
.loop2
	clr.w	d4
	move.b	(a3)+,d4
	add.w	d4,d2
	cmp.w	d0,d2
	bgt.w	.2
	addq.w	#1,d3
	dbf	d1,.loop2
.2
	add.w	(sp)+,d3
	move.w	d3,d0
	movem.l	(sp)+,d1-d7/a0-a6
	rts

SimShotsTbl	;Shot count weights for SimShots
	dc.b	1,0,0,0,0,0,2,3,4,3,$C,$E,$A,$10,$13,$A
	dc.b	$19,$E,$B,$E,$13,$F,$F,$F,$D,$A,$A,$A,9,9,5,$B
	dc.b	4,4,2,5,3,1,1,1,0,1,0,1,0,0
