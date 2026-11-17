; MAIN.BIN $1840-$1E8F. Zero pad after the rts at $FF183E, then the byte table
; in front of the display init. The $01 at $FF188D is the only nonzero byte
; in the first 1404 bytes.


; Data of the file start (8 rows): table or constants used by it.
	dcb.b	$4D,0
	dc.b	$01						; .
	dcb.b	$52E,0
	dc.b	$B8,$B7,$00,$4C,$00,$00,$4A,$B9,$00,$00,$00,$00,$00,$BA,$B2,$00	; ...L..J.........
	dc.b	$33,$CB,'68:<>@BD',$BA,$00,$00,$00,$00,$4A	; 3.68:<>@BD.....J
	dc.b	$3C,$00,$02,$04,$06,$08,$0A,$0C,$0E,$F0,$11,$13,$15,$17,$19,$1B	; <...............
	dc.b	$1D,$1F,$21,$23,$25,$27,')+-/1'	; ..!#%')+-/1
	dcb.b	$9,0
; Start of a RAM-resident code image (bra over its header)
RamImageA	dc.b	$60,$00,$00,$8E			; `...
; Zero padding of image A
RamImageAPad	dcb.b	$8C,0

