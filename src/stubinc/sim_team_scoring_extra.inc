;	Extra TeamScoring* blocks when NumPlayoffTeams > 26 (duplicate team 25 weights as a neutral default).

	IF 26<NumPlayoffTeams
TeamScoring26
	dc.b	$15,$13,0,$A,$1A,$2D,$13,$20,$D,$1B,4,8,7,7,$29,$28
	dc.b	4,8,4,8,$15,$25,6,2,$19,$1D,5,$D,$21,$29,8,$B
	dc.b	3,$D,0,4,5,$12,8,$12,0,7,0,$11,4,$11,2,8
	ENDIF
	IF 27<NumPlayoffTeams
TeamScoring27
	dc.b	$15,$13,0,$A,$1A,$2D,$13,$20,$D,$1B,4,8,7,7,$29,$28
	dc.b	4,8,4,8,$15,$25,6,2,$19,$1D,5,$D,$21,$29,8,$B
	dc.b	3,$D,0,4,5,$12,8,$12,0,7,0,$11,4,$11,2,8
	ENDIF
	IF 28<NumPlayoffTeams
TeamScoring28
	dc.b	$15,$13,0,$A,$1A,$2D,$13,$20,$D,$1B,4,8,7,7,$29,$28
	dc.b	4,8,4,8,$15,$25,6,2,$19,$1D,5,$D,$21,$29,8,$B
	dc.b	3,$D,0,4,5,$12,8,$12,0,7,0,$11,4,$11,2,8
	ENDIF
	IF 29<NumPlayoffTeams
TeamScoring29
	dc.b	$15,$13,0,$A,$1A,$2D,$13,$20,$D,$1B,4,8,7,7,$29,$28
	dc.b	4,8,4,8,$15,$25,6,2,$19,$1D,5,$D,$21,$29,8,$B
	dc.b	3,$D,0,4,5,$12,8,$12,0,7,0,$11,4,$11,2,8
	ENDIF
	IF 30<NumPlayoffTeams
TeamScoring30
	dc.b	$15,$13,0,$A,$1A,$2D,$13,$20,$D,$1B,4,8,7,7,$29,$28
	dc.b	4,8,4,8,$15,$25,6,2,$19,$1D,5,$D,$21,$29,8,$B
	dc.b	3,$D,0,4,5,$12,8,$12,0,7,0,$11,4,$11,2,8
	ENDIF
	IF 31<NumPlayoffTeams
TeamScoring31
	dc.b	$15,$13,0,$A,$1A,$2D,$13,$20,$D,$1B,4,8,7,7,$29,$28
	dc.b	4,8,4,8,$15,$25,6,2,$19,$1D,5,$D,$21,$29,8,$B
	dc.b	3,$D,0,4,5,$12,8,$12,0,7,0,$11,4,$11,2,8
	ENDIF
