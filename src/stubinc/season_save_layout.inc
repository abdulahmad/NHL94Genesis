;	Season battery RAM map (SEASON=1). Low retail bands stay in equals.inc; from the season
;	header through SRChecksum sizes scale with NumTeams / NumPlayoffTeams. Stock 28-team
;	league must match the fixed offsets in the port plan.

SeasonHeaderMin equ $E22
	IF NameLogEnd<SeasonHeaderMin
SRSeasonHeader equ SeasonHeaderMin
	ELSE
SRSeasonHeader equ NameLogEnd
	ENDIF

SRGameResultsBytes equ $CCC
SRStandingsBytes equ NumPlayoffTeams*3
SRGoalTotalBytes equ 8
SRRosterBytes equ NumTeams*$38
SRRosterPad equ $38
SRPlayerStatBytes equ NumPlayoffTeams*54
SeasonPlayerStatsClear equ 5*SRPlayerStatBytes
SRTeamStatsBytes equ NumPlayoffTeams*10
SeasonPlayerStatSpan equ SRPlayerStatBytes
SRLineDataBytes equ $108

SRGameResults equ SRSeasonHeader+8
SRStandings equ SRGameResults+SRGameResultsBytes
SRGoalTotal equ SRStandings+NumPlayoffTeams*3
SRRosters equ SRGoalTotal+SRGoalTotalBytes
SRGoals equ SRRosters+SRRosterBytes+SRRosterPad
SRAssists equ SRGoals+SRPlayerStatBytes
SRShots equ SRAssists+SRPlayerStatBytes
SRGamesPlayed equ SRShots+SRPlayerStatBytes
SRPenMin equ SRGamesPlayed+SRPlayerStatBytes
SRTeamStats equ SRPenMin+SRPlayerStatBytes
SRLines equ SRTeamStats+SRTeamStatsBytes
SRSavedLines1 equ SRLines+$71C
SRSavedLines2 equ SRSavedLines1+$63C
SRSavedLines3 equ SRSavedLines2+$5CA
SRJerseyNums equ SRSavedLines3+$5CA
SRFreeAgentJerseys equ SRJerseyNums+$380
SRCreatedPlayers equ SRFreeAgentJerseys+$20
SRCreateCount equ SRCreatedPlayers+$281
SRFreeAgentList equ SRCreateCount+1
SRFreeAgentCount equ SRFreeAgentList+$35
SRTeamBlock2 equ SRFreeAgentCount+1
SRInjuries equ SRTeamBlock2+$104
SRSeasonHeaderSave equ SRInjuries+$17A
SRHighlights equ SRSeasonHeaderSave
SRPOPairings equ SRSeasonHeaderSave+$A
SRPORound equ SRPOPairings+$20
SRPODay equ SRPORound+2
SRPOSeries equ SRPODay+2
SRPOSchedule equ SRPOSeries+$80
SRPOStandings equ SRPOSchedule+$EF
SRPOGoals equ SRPOStandings+NumPlayoffTeams*3
SRPOAssists equ SRPOGoals+SRPlayerStatBytes
SRPOShots equ SRPOAssists+SRPlayerStatBytes
SRPOGamesPlayed equ SRPOShots+SRPlayerStatBytes
SRPOPenMin equ SRPOGamesPlayed+SRPlayerStatBytes
SRPOTeamStats equ SRPOPenMin+SRPlayerStatBytes
SeasonPostPlayoffBytes equ $7EE6-$7D2D
SRSeasonMark equ SRPOTeamStats+SeasonPostPlayoffBytes
SRCupWinner equ SRSeasonMark+8
SRLineData equ SRCupWinner+8
SRChecksum equ SRLineData+SRLineDataBytes
SeasonSaveEnd equ SRChecksum+2

	IF SeasonSaveEnd>SaveMirrorBytes
		inform	3,"Season save map exceeds SaveMirrorBytes; shrink the league or repack fixed SR tail"
	ENDIF
