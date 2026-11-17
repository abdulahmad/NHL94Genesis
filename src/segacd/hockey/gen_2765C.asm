	dc.b	$00,$02,$C6,$60
	String	'   Crowd Meter    '
	dc.b	$00,$02,$E5,$56
	String	'   Player Cards   '
	dc.b	$00,$02,$5E,$56
	String	'  Record Holders  '
	dc.b	$00,$02,$70,$E0
	String	'   Period Stats   '
	dc.b	$00,$02,$95,$0E,$00,$04,$FF,$00

ExitGameText						;Intermission menu for gsp 4
	dc.b	$00,$04,$FE,$05,$00,$04,$FE,$04
	String	'    Exit Game     '
	dc.b	$00,$03,$C0,$00
	String	'    Game Stats    '
	dc.b	$00,$02,$9A,$2E
	String	'   Player Stats   '
	dc.b	$00,$02,$DE,$50
	String	' Scoring Summary  '
	dc.b	$00,$02,$D6,$D6
	String	' Penalty Summary  '
	dc.b	$00,$02,$DA,$4C
	String	'   Team Roster    '
	dc.b	$00,$02,$D0,$D4
	String	'   Other Scores   '
	dc.b	$00,$02,$C6,$60
	String	'   Crowd Meter    '
	dc.b	$00,$02,$E5,$56
	String	'   Player Cards   '
	dc.b	$00,$02,$5E,$56
	String	'  Record Holders  '
	dc.b	$00,$02,$70,$E0
	String	'   Period Stats   '
	dc.b	$00,$02,$95,$0E,$00,$04,$FF,$00

LineEditorMenuText					;Line editor exit menu
	dc.b	$00,$06,$FE,$06,$F9,$01,$00,$06,$FE,$04,$F9,$01
	String	'       Exit       '
	dc.b	$00,$03,$C0,$00
	String	'Set Original lines'
	dc.b	$00,$03,$F2,$08
	String	'  Save Team Line  '
	dc.b	$00,$02,$D0,$46
	String	'  Load Team Line  '
	dc.b	$00,$02,$CF,$DE,$00,$04,$FF,$00

LineEditorMenuNoLoad				;Line editor exit menu without Load Team Line
	dc.b	$00,$06,$FE,$06,$F9,$01,$00,$06,$FE,$04,$F9,$01
	String	'       Exit       '
	dc.b	$00,$03,$C0,$00
	String	'Set Original lines'
	dc.b	$00,$03,$F2,$08
	String	'  Save Team Line  '
	dc.w	2							;end of the list: an empty String
	dc.w	$D046,4,$FF00				;not read: the bytes between the list and PicturePalette
PicturePalette						;the player picture palette, and the picture words (a $036A byte card has $3EA words)
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_278A0.bin
NoPicSkater1						;read by DrawPlayerPicture (high ROM)
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_27CD6.bin
NoPicSkater2						;read by DrawPlayerPicture (high ROM)
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_28040.bin
NoPicGoalie1						;read by DrawPlayerPicture (high ROM)
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_283AA.bin
