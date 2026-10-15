;	Season-only work RAM that scales with NumPlayoffTeams (league leaders / standings scratch).

LeaderTeamTblStride equ NumPlayoffTeams
LeaderTeamTblBytes equ 7*LeaderTeamTblStride
LeaderTeamTbls equ $FFFFDA1E
TeamLeaderValues equ LeaderTeamTbls+LeaderTeamTblBytes
TeamLeaderValuesBytes equ 7*NumPlayoffTeams*2
StandingsBufBytes equ NumPlayoffTeams*3
StandingsBuf equ TeamLeaderValues+TeamLeaderValuesBytes
StandingsRecs equ StandingsBuf
CreatedPlayerBufMin equ $FFFFE0FA

	IF StandingsBuf+StandingsBufBytes>CreatedPlayerBufMin
		inform	3,"StandingsBuf overlaps CreatedPlayerBuf; reduce NumPlayoffTeams or move season work RAM"
	ENDIF

CreatedPlayerBuf equ CreatedPlayerBufMin
