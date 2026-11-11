;	STARTER.BIN $4538-$458B (runtime $F538-$F58B).
;
;	The FilmOpen name tag after filmopen.asm and the strings FilmOpen prints.


	org	$F538

	dc.b	$88,'FilmOpen',0
	dc.w	$0048
	dc.b	'Film Open'
	dc.b	$00
	dc.b	'InitEngine'
	dc.w	$0000,$4865
	dc.b	'aderSects: %d'
	dc.b	$00
	dc.b	'Film at %d is bad'
	dc.b	$00
	dc.b	'FilmOpening %d'
	dc.w	$0000
