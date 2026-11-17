; Column ids for one skater stat page, $FFFF ends the list.
StatColumnIdsSkaterA	dc.b	$00,$00,$00,$01,$00,$02,$00,$05,$00,$06,$00,$07,$FF,$FF	; ..............
; Column ids for the second skater stat page.
StatColumnIdsSkaterB	dc.b	$00,$00,$00,$01,$00,$02,$00,$03,$00,$04,$00,$05,$00,$08,$00,$09	; ................
	dc.b	$00,$0A,$00,$0B,$00,$0C,$FF,$FF	; ........
; Column widths for the first page.
StatColumnWidthsA	dc.b	$07,$FF,$05,$03,$03,$03,$03,$04,$03,$03,$03,$03,$04,$00	; ..............
; Column widths for the second page.
StatColumnWidthsB	dc.b	$07,$FF,$05,$03,$03,$03,$03,$04,$03,$02,$04,$03,$03,$03,$05,$03	; ................
	dc.b	$03,$04	; ..
; 'Players'.
StrPlayers	dc.b	'Players',$00,$20,$00	; Players. .
; 'Goalies'.
StrGoalies	dc.b	'Goalies',$00,$20,$00	; Goalies. .
; Skater column headings: Gp G A Pts +/- Pim PP Sh Gw Gt S Pctg.
StrSkaterStatHeaders	dc.b	$47,$70,$00,$47,$00,$41,$00,$50,$74,$73,$00,$2B,$2F,$2D,$00,$50	; Gp.G.A.Pts.+/-.P
	dc.b	$69,$6D,$00,$50,$50,$00,$53,$68,$00,$47,$77,$00,$47,$74,$00,$53	; im.PP.Sh.Gw.Gt.S
	dc.b	$00,'Pctg',$FF	; .Pctg.
; Goalie column headings: Gp Mins Ga Avg. W L T SO En Shts and the per-game forms.
StrGoalieStatHeaders	dc.b	$47,$70,$00,'Mins',$00,$47,$61,$00,'Avg.',$00	; Gp.Mins.Ga.Avg..
	dc.b	$57,$00,$4C,$00,$54,$00,$53,$4F,$00,$45,$6E,$00,'Shts'	; W.L.T.SO.En.Shts
	dc.b	$00,$70,$47,$50,$00,'pMIN',$00,$70,$47,$41,$00,$70,$41	; .pGP.pMIN.pGA.pA
	dc.b	$56,$47,$00,$70,$57,$00,$70,$4C,$00,$70,$53,$4F,$00,$70,$45,$4E	; VG.pW.pL.pSO.pEN
	dc.b	$00,$70,$53,$41,$FF	; .pSA.
; 'Regular'.
StrRegular	dc.b	'Regular',$00	; Regular.
; 'Playoff'.
StrPlayoff	dc.b	'Playoff',$00	; Playoff.
; Skater career headings: Season Club Lea Gp G A Tp Pim.
StrSkaterCareerHeaders	dc.b	'Season',$00,'Club',$00,$4C,$65,$61,$00	; Season.Club.Lea.
	dc.b	$47,$70,$00,$47,$00,$41,$00,$54,$70,$00,$50,$69,$6D,$00,$47,$70	; Gp.G.A.Tp.Pim.Gp
	dc.b	$00,$47,$00,$41,$00,$54,$70,$00,$50,$69,$6D,$00	; .G.A.Tp.Pim.
; Goalie career headings: Season Club Lea Gp W L T Mins Ga So Avg.
StrGoalieCareerHeaders	dc.b	'Season',$00,'Club',$00,$4C,$65,$61,$00	; Season.Club.Lea.
	dc.b	$47,$70,$00,$57,$00,$4C,$00,$54,$00,'Mins',$00,$47,$61	; Gp.W.L.T.Mins.Ga
	dc.b	$00,$53,$6F,$00,$41,$76,$67,$00,$47,$70,$00,$57,$00,$4C,$00,$4D	; .So.Avg.Gp.W.L.M
	dc.b	$69,$6E,$73,$00,$47,$61,$00,$53,$6F,$00,$41,$76,$67,$00,$00	; ins.Ga.So.Avg..
; Picture tile data, single frame (page A).
PicTilesStillA	incbin	..\Extracted\SegaCD\PLAYER\player_040C4.bin
; Picture tile data, animation frames (page A).
PicTilesFramesA	incbin	..\Extracted\SegaCD\PLAYER\player_045C8.bin
.next	incbin	..\Extracted\SegaCD\PLAYER\player_06044.bin
; Picture tile data, single frame (page B).
PicTilesStillB	incbin	..\Extracted\SegaCD\PLAYER\player_068E4.bin
; Picture tile data, three animation frames (page B), $504 bytes each.
PicTilesFramesB	incbin	..\Extracted\SegaCD\PLAYER\player_06DE8.bin
; Table of $34-byte records indexed by the current page.
PlRecordTable	incbin	..\Extracted\SegaCD\PLAYER\player_07CF4.bin
; Background image: width, height, then tile data.
PlBackgroundImage	incbin	..\Extracted\SegaCD\PLAYER\player_082A4.bin
; Data of PlBackgroundImage (1 row): table or constants used by it.
	dcb.b	$8DC,0
