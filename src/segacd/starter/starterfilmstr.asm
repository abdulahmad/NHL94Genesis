; Sierra C name tag of the routine above (length byte, 'FilmOpen', zero padding).
	dc.b	$88,'FilmOpen',$00,$00,$48	; .FilmOpen..H
; Debug text
FilmOpenStrTitle	dc.b	'Film Open',$00	; Film Open.
; Debug text
FilmOpenStrInit	dc.b	'InitEngine',$00,$00	; InitEngine..
; Debug text
FilmOpenStrSects	dc.b	'HeaderSects: %d',$00	; HeaderSects: %d.
; Debug text
FilmOpenStrBad	dc.b	'Film at %d is ba'	; Film at %d is ba
	dc.b	$64,$00	; d.
; Debug text
FilmOpenStrOpening	dc.b	'FilmOpening %d',$00,$00	; FilmOpening %d..
