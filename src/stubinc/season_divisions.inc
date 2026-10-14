;	Standings division team lists (count byte, then team indices). DivisionTeamTotal must equal NumPlayoffTeams.

	IF NumPlayoffTeams=26
DivisionTeamTotal equ 6+6+7+7
StandingsGroup0
	dc.b	6,0,3,7,$A,$13,$17
StandingsGroup1
	dc.b	6,4,5,6,$14,$16,$19
StandingsGroup2
	dc.b	7,1,2,9,$B,$F,$11,$12
StandingsGroup3
	dc.b	7,8,$C,$D,$E,$10,$15,$18
	ENDIF

	IF NumPlayoffTeams=32
DivisionTeamTotal equ 8+8+8+8
StandingsGroup0
	dc.b	8,0,1,2,3,4,5,6,7
StandingsGroup1
	dc.b	8,8,9,$A,$B,$C,$D,$E,$F
StandingsGroup2
	dc.b	8,$10,$11,$12,$13,$14,$15,$16,$17
StandingsGroup3
	dc.b	8,$18,$19,$1A,$1B,$1C,$1D,$1E,$1F
	ENDIF

	IF NumPlayoffTeams<>26
	IF NumPlayoffTeams<>32
		inform	3,"Add StandingsGroup0-3 for this NumPlayoffTeams in season_divisions.inc"
	ENDIF
	ENDIF

	IF NumPlayoffTeams<>DivisionTeamTotal
		inform	3,"Division team counts must sum to NumPlayoffTeams"
	ENDIF
