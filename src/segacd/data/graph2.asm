;	GRAPH2.BIN (3,051,520 bytes, 1490 sectors): the graphics archive. Written by tools/segacd_graph2.py. 99
;	resources, each starting on a 2048-byte sector, ending with the mark $12345678 and zero filled to the next
;	sector. GTABLE.BIN (gtable.asm) is the index: the start sector and byte size of each, in this order.
;
;	HOCKEY.BIN, STARTER.BIN and PLAYER.BIN ask for resource n with the BIOS call $6044, d7 = 1 and d0 = n, and
;	get its address in a0.
;
;	Resources 0 and 1 are packs: a table of long offsets from the pack start, then the pieces.
;
;	The code adds the pack address to each offset and keeps the pointers in HOCKEY.BIN's graphics pointer
;	table (src/segacd/hockey/cdgfxptrs.asm): scoutload.asm for resource 0, LoadGameGfx (hockey94.asm) for
;	resource 1.
;
;	A piece is named R0_ or R1_ and the cartridge label (graphics94.asm) of the graphic it is; the comment
;	names the cartridge file when the bytes are that file's. All the data is read from the disc file, as the
;	cartridge build reads its graphics from Extracted/.
;
;	A $0808 picture (resources 5, 64, 97 and the pieces of 68-95): the word $0808, the tile count, the
;	tiles (32 bytes each), a 64-colour palette (128 bytes), then the map: width, height, the map words.

	org	0

Graph2

;	resource 0 (sector $000, 325,336 bytes): the start-up pack. scoutload.asm loads it (d0 = 0)
Res00
	dc.l	R0_ScoutingReportText-Res00	;0 -> $47CFC
	dc.l	R0_TeamLogoBitmaps-Res00	;1 -> TeamLogoBitmapsPtr
	dc.l	R0_FeaturedPictures-Res00	;2 -> FeaturedPicturesPtr
	dc.l	R0_ScoutingSpeechClips-Res00	;3 -> ScoutingSpeechClipsPtr
	dc.l	R0_SmallFontMap-Res00	;4 -> SmallFontMapPtr
	dc.l	R0_HotMap-Res00			;5 -> HotMapPtr
	dc.l	R0_ColdMap-Res00		;6 -> ColdMapPtr
	dc.l	R0_Arrowsmap-Res00		;7 -> ArrowsmapPtr
	dc.l	R0_BigFontMap-Res00		;8 -> BigFontMapPtr
	dc.l	R0_FramerMap-Res00		;9 -> FramerMapPtr
	dc.l	R0_RonBarrMap-Res00		;10 -> RonBarrMapPtr
	dc.l	R0_PrintFont2Map-Res00	;11 -> PrintFont2MapPtr
	dc.l	R0_EASportsBGMap-Res00	;12 -> EASportsBGMapPtr
	dc.l	R0_13-Res00				;13 -> $47D08
	dc.l	R0_SetupFramerMap-Res00	;14 -> SetupFramerMapPtr
	dc.l	R0_Teamblocksmap-Res00	;15 -> TeamblocksmapPtr
	dc.l	R0_LogoBoxMap-Res00		;16 -> LogoBoxMapPtr
	dc.l	R0_TeamBitmaps-Res00	;17 -> TeamBitmapsPtr
	dc.l	R0_StanleyCupSprite-Res00	;18 -> StanleyCupSpritePtr
	dc.l	R0_Rinktilelist-Res00	;19 -> RinktilelistPtr
	dc.l	R0_GameSetUpMap-Res00	;20 -> GameSetUpMapPtr
	dc.l	R0_SetupMenuMap-Res00	;21 -> SetupMenuMapPtr
	dc.l	R0_GameSetUpMap2-Res00	;22 -> GameSetUpMap2Ptr
R0_ScoutingReportText	incbin	..\cdbin\GRAPH2.BIN,$5C,61370	;the scouting script (the disc has its own,
									;longer than the cartridge text)
R0_TeamLogoBitmaps	incbin	..\cdbin\GRAPH2.BIN,$F016,27768	;the team logos: a table of offsets, then the
									;pictures (resource 4 holds the same)
R0_FeaturedPictures	incbin	..\cdbin\GRAPH2.BIN,$15C8E,132154	;the player pictures: a table of offsets, then
									;the pictures (resource 3 holds the same)
R0_ScoutingSpeechClips	incbin	..\cdbin\GRAPH2.BIN,$360C8,8960	;the scouting report's speech clips: start
									;sector and sectors of RON*.PCM files (resource 98 holds the same)
R0_SmallFontMap	incbin	..\cdbin\GRAPH2.BIN,$383C8,3278	;= SmallFont.map.jim
R0_HotMap	incbin	..\cdbin\GRAPH2.BIN,$39096,550	;= Hot.map.jim
R0_ColdMap	incbin	..\cdbin\GRAPH2.BIN,$392BC,754	;= Cold.map.jim
R0_Arrowsmap	incbin	..\cdbin\GRAPH2.BIN,$395AE,604	;= Arrows.map.jim
R0_BigFontMap	incbin	..\cdbin\GRAPH2.BIN,$3980A,4674	;= BigFont94.map.jim
R0_FramerMap	incbin	..\cdbin\GRAPH2.BIN,$3AA4C,120	;= Framer.map.jim
R0_RonBarrMap	incbin	..\cdbin\GRAPH2.BIN,$3AAC4,1496	;= RonBarr.map.jim
R0_PrintFont2Map	incbin	..\cdbin\GRAPH2.BIN,$3B09C,3406	;= SmallFont94.map.jim
R0_EASportsBGMap	incbin	..\cdbin\GRAPH2.BIN,$3BDEA,3418	;= EASportsBG.map.jim
R0_13	incbin	..\cdbin\GRAPH2.BIN,$3CB44,1426	;a screen map with no cartridge twin
R0_SetupFramerMap	incbin	..\cdbin\GRAPH2.BIN,$3D0D6,448	;= GameSetupBkgd2.map.jim
R0_Teamblocksmap	incbin	..\cdbin\GRAPH2.BIN,$3D296,17022	;the disc has its own (the cartridge
									;TeamBlocks.map.jim is another size)
R0_LogoBoxMap	incbin	..\cdbin\GRAPH2.BIN,$41514,462	;= GameSetupLogoBorder.map.jim
R0_TeamBitmaps	incbin	..\cdbin\GRAPH2.BIN,$416E2,14110	;= TeamBlocks94.map.jim
R0_StanleyCupSprite	incbin	..\cdbin\GRAPH2.BIN,$44E00,4832	;the first 4,832 bytes of the cartridge
									;StanleyCup.anim
R0_Rinktilelist	incbin	..\cdbin\GRAPH2.BIN,$460E0,25518	;= IceRink94.map.jim
R0_GameSetUpMap	incbin	..\cdbin\GRAPH2.BIN,$4C48E,10062	;= GameSetUp94-1.map.jim
R0_SetupMenuMap	incbin	..\cdbin\GRAPH2.BIN,$4EBDC,1418	;= GameSetupBkgd1.map.jim
R0_GameSetUpMap2	incbin	..\cdbin\GRAPH2.BIN,$4F166,1390	;GameSetUp94-2.map.jim and more
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$4F800-*,0				;zero fill to sector $09F

;	resource 1 (sector $09F, 130,114 bytes): the game graphics pack. LoadGameGfx (hockey94.asm)
;	loads it (d0 = 1)
Res01
	dc.l	R1_SmallFontMap-Res01	;0 -> SmallFontMapPtr
	dc.l	R1_Rinktilelist-Res01	;1 -> RinktilelistPtr
	dc.l	R1_EnergyBarMap-Res01	;2 -> EnergyBarMapPtr
	dc.l	R1_CrowdSprites-Res01	;3 -> CrowdSpritesPtr
	dc.l	R1_BigFontMap-Res01		;4 -> BigFontMapPtr
	dc.l	R1_EASportsMap-Res01	;5 -> EASportsMapPtr
	dc.l	R1_ZamSprites-Res01		;6 -> ZamSpritesPtr
	dc.l	R1_FaceOffSprites-Res01	;7 -> FaceOffSpritesPtr
	dc.l	R1_RefsMap-Res01		;8 -> RefsMapPtr
	dc.l	R1_RefMap2-Res01		;9 -> RefMap2Ptr
	dc.l	R1_Teamblocksmap-Res01	;10 -> TeamblocksmapPtr
	dc.l	R1_FramerMap-Res01		;11 -> FramerMapPtr
	dc.l	R1_ScoresMap-Res01		;12 -> ScoresMapPtr
	dc.l	R1_FaceOffMap-Res01		;13 -> FaceOffMapPtr
	dc.l	R1_HotList-Res01		;14 -> HotListPtr
	dc.l	R1_EASportsBGMap-Res01	;15 -> EASportsBGMapPtr
	dc.l	R1_RevRinkTilelist-Res01	;16 -> RevRinkTilelistPtr
	dc.l	R1_ReplayMap-Res01		;17 -> ReplayMapPtr
	dc.l	R1_IceRinkHorMap-Res01	;18 -> IceRinkHorMapPtr
	dc.l	R1_PrintFont2Map-Res01	;19 -> PrintFont2MapPtr
	dc.l	R1_NHLLogoMap-Res01		;20 -> NHLLogoMapPtr
	dc.l	R1_NHLPALogoMap-Res01	;21 -> NHLPALogoMapPtr
	dc.l	R1_HotMap-Res01			;22 -> HotMapPtr
	dc.l	R1_ColdMap-Res01		;23 -> ColdMapPtr
	dc.l	R1_24-Res01				;24 -> $47DA8
R1_SmallFontMap	incbin	..\cdbin\GRAPH2.BIN,$4F864,3278	;= SmallFont.map.jim
R1_Rinktilelist	incbin	..\cdbin\GRAPH2.BIN,$50532,25518	;= IceRink94.map.jim
R1_EnergyBarMap	incbin	..\cdbin\GRAPH2.BIN,$568E0,244	;= EnergyBar.map.jim
R1_CrowdSprites	incbin	..\cdbin\GRAPH2.BIN,$569D4,11610	;= Crowd.anim
R1_BigFontMap	incbin	..\cdbin\GRAPH2.BIN,$5972E,4674	;= BigFont94.map.jim
R1_EASportsMap	incbin	..\cdbin\GRAPH2.BIN,$5A970,272	;= EASports.map.jim
R1_ZamSprites	incbin	..\cdbin\GRAPH2.BIN,$5AA80,4334	;= Zam.anim
R1_FaceOffSprites	incbin	..\cdbin\GRAPH2.BIN,$5BB6E,4212	;= FaceOff.anim
R1_RefsMap	incbin	..\cdbin\GRAPH2.BIN,$5CBE2,2908	;= Refs.map.jim
R1_RefMap2	incbin	..\cdbin\GRAPH2.BIN,$5D73E,3862	;= Refs2.map.jim
R1_Teamblocksmap	incbin	..\cdbin\GRAPH2.BIN,$5E654,17022	;the disc has its own (resource 0 holds the
									;same)
R1_FramerMap	incbin	..\cdbin\GRAPH2.BIN,$628D2,120	;= Framer.map.jim
R1_ScoresMap	incbin	..\cdbin\GRAPH2.BIN,$6294A,998	;= Scores.map.jim
R1_FaceOffMap	incbin	..\cdbin\GRAPH2.BIN,$62D30,1124	;= FaceOff.map.jim
R1_HotList	incbin	..\cdbin\GRAPH2.BIN,$63194,1674	;the first 1,674 bytes of the cartridge HotList.bin
R1_EASportsBGMap	incbin	..\cdbin\GRAPH2.BIN,$6381E,3418	;= EASportsBG.map.jim
R1_RevRinkTilelist	incbin	..\cdbin\GRAPH2.BIN,$64578,25454	;= IceRink94Reverse.map.jim
R1_ReplayMap	incbin	..\cdbin\GRAPH2.BIN,$6A8E6,2926	;= ReplayOptions.map.jim
R1_IceRinkHorMap	incbin	..\cdbin\GRAPH2.BIN,$6B454,8718	;= IceRinkHor.map.jim
R1_PrintFont2Map	incbin	..\cdbin\GRAPH2.BIN,$6D662,3406	;= SmallFont94.map.jim
R1_NHLLogoMap	incbin	..\cdbin\GRAPH2.BIN,$6E3B0,1110	;= NHLLogo.map.jim
R1_NHLPALogoMap	incbin	..\cdbin\GRAPH2.BIN,$6E806,1046	;the first 1,046 bytes of the cartridge
									;NHLPALogo.map.jim
R1_HotMap	incbin	..\cdbin\GRAPH2.BIN,$6EC1C,550	;= Hot.map.jim
R1_ColdMap	incbin	..\cdbin\GRAPH2.BIN,$6EE42,754	;= Cold.map.jim
R1_24	incbin	..\cdbin\GRAPH2.BIN,$6F134,778	;a TeamGfxList entry, as the per-team resources 35-62
									;(LoadHomeTeamGfx's other choice)
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$6F800-*,0				;zero fill to sector $0DF

;	resource 2 (sector $0DF, 288,340 bytes):
;	the sprite pack: two offsets, then Spritetiles.bin (from +$A) and frameSprData.bin (at +$408AA).
;	hockey94 LoadGameGfx and period94 load it into $47D24
Res02	incbin	..\cdbin\GRAPH2.BIN,$6F800,288336
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$B6000-*,0				;zero fill to sector $16C

;	resource 3 (sector $16C, 132,158 bytes): the player pictures (FeaturedPictures): a table of offsets, then
;	the pictures (NoPic*.map.jim, PicturePalette.bin, Card*.map.jim). Resource 0 piece 2 is the same without
;	the end mark; no load of this one found
Res03	incbin	..\cdbin\GRAPH2.BIN,$B6000,132154
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$D6800-*,0				;zero fill to sector $1AD

;	resource 4 (sector $1AD, 27,772 bytes):
;	the team logos (TeamLogoBitmaps): a table of offsets, then logoANA.map.jim ... (period94 loads it
;	into TeamLogoBitmapsPtr). Resource 0 piece 1 is the same without the end mark
Res04	incbin	..\cdbin\GRAPH2.BIN,$D6800,27768
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$DD800-*,0				;zero fill to sector $1BB

;	resource 5 (sector $1BB, 36,148 bytes):
;	two $0808 pictures, 40 x 28 each, with the same goalie: the legal screen (the copyright and licence
;	notices), then Loading... please wait (from +$5BC8). STARTER.BIN loads it (d0 = 5)
Res05	incbin	..\cdbin\GRAPH2.BIN,$DD800,36144
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$E6800-*,0				;zero fill to sector $1CD

;	resource 6 (sector $1CD, 25,076 bytes):
;	per team: ANH's player photos, a table of offsets then the pictures. PLAYER.BIN
;	loads 6 + team for the home and away teams ($1C(a6), $20(a6); docs/segacd_stats.md)
Res06	incbin	..\cdbin\GRAPH2.BIN,$E6800,25072
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$ED000-*,0				;zero fill to sector $1DA

;	resource 7 (sector $1DA, 39,822 bytes):
;	per team: BOS's player photos, a table of offsets then the pictures. PLAYER.BIN
;	loads 6 + team for the home and away teams ($1C(a6), $20(a6); docs/segacd_stats.md)
Res07	incbin	..\cdbin\GRAPH2.BIN,$ED000,39818
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$F7000-*,0				;zero fill to sector $1EE

;	resource 8 (sector $1EE, 34,922 bytes):
;	per team: BUF's player photos, a table of offsets then the pictures. PLAYER.BIN
;	loads 6 + team for the home and away teams ($1C(a6), $20(a6); docs/segacd_stats.md)
Res08	incbin	..\cdbin\GRAPH2.BIN,$F7000,34918
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$100000-*,0				;zero fill to sector $200

;	resource 9 (sector $200, 35,836 bytes):
;	per team: CGY's player photos, a table of offsets then the pictures. PLAYER.BIN
;	loads 6 + team for the home and away teams ($1C(a6), $20(a6); docs/segacd_stats.md)
Res09	incbin	..\cdbin\GRAPH2.BIN,$100000,35832
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$109000-*,0				;zero fill to sector $212

;	resource 10 (sector $212, 36,176 bytes):
;	per team: CHI's player photos, a table of offsets then the pictures. PLAYER.BIN
;	loads 6 + team for the home and away teams ($1C(a6), $20(a6); docs/segacd_stats.md)
Res10	incbin	..\cdbin\GRAPH2.BIN,$109000,36172
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$112000-*,0				;zero fill to sector $224

;	resource 11 (sector $224, 34,784 bytes):
;	per team: DAL's player photos, a table of offsets then the pictures. PLAYER.BIN
;	loads 6 + team for the home and away teams ($1C(a6), $20(a6); docs/segacd_stats.md)
Res11	incbin	..\cdbin\GRAPH2.BIN,$112000,34780
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$11A800-*,0				;zero fill to sector $235

;	resource 12 (sector $235, 34,238 bytes):
;	per team: DET's player photos, a table of offsets then the pictures. PLAYER.BIN
;	loads 6 + team for the home and away teams ($1C(a6), $20(a6); docs/segacd_stats.md)
Res12	incbin	..\cdbin\GRAPH2.BIN,$11A800,34234
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$123000-*,0				;zero fill to sector $246

;	resource 13 (sector $246, 32,012 bytes):
;	per team: EDM's player photos, a table of offsets then the pictures. PLAYER.BIN
;	loads 6 + team for the home and away teams ($1C(a6), $20(a6); docs/segacd_stats.md)
Res13	incbin	..\cdbin\GRAPH2.BIN,$123000,32008
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$12B000-*,0				;zero fill to sector $256

;	resource 14 (sector $256, 22,784 bytes):
;	per team: FLA's player photos, a table of offsets then the pictures. PLAYER.BIN
;	loads 6 + team for the home and away teams ($1C(a6), $20(a6); docs/segacd_stats.md)
Res14	incbin	..\cdbin\GRAPH2.BIN,$12B000,22780
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$131000-*,0				;zero fill to sector $262

;	resource 15 (sector $262, 33,656 bytes):
;	per team: HFD's player photos, a table of offsets then the pictures. PLAYER.BIN
;	loads 6 + team for the home and away teams ($1C(a6), $20(a6); docs/segacd_stats.md)
Res15	incbin	..\cdbin\GRAPH2.BIN,$131000,33652
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$139800-*,0				;zero fill to sector $273

;	resource 16 (sector $273, 38,756 bytes):
;	per team: LA's player photos, a table of offsets then the pictures. PLAYER.BIN
;	loads 6 + team for the home and away teams ($1C(a6), $20(a6); docs/segacd_stats.md)
Res16	incbin	..\cdbin\GRAPH2.BIN,$139800,38752
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$143000-*,0				;zero fill to sector $286

;	resource 17 (sector $286, 34,442 bytes):
;	per team: MTL's player photos, a table of offsets then the pictures. PLAYER.BIN
;	loads 6 + team for the home and away teams ($1C(a6), $20(a6); docs/segacd_stats.md)
Res17	incbin	..\cdbin\GRAPH2.BIN,$143000,34438
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$14B800-*,0				;zero fill to sector $297

;	resource 18 (sector $297, 34,946 bytes):
;	per team: NJ's player photos, a table of offsets then the pictures. PLAYER.BIN
;	loads 6 + team for the home and away teams ($1C(a6), $20(a6); docs/segacd_stats.md)
Res18	incbin	..\cdbin\GRAPH2.BIN,$14B800,34942
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$154800-*,0				;zero fill to sector $2A9

;	resource 19 (sector $2A9, 33,988 bytes):
;	per team: NYI's player photos, a table of offsets then the pictures. PLAYER.BIN
;	loads 6 + team for the home and away teams ($1C(a6), $20(a6); docs/segacd_stats.md)
Res19	incbin	..\cdbin\GRAPH2.BIN,$154800,33984
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$15D000-*,0				;zero fill to sector $2BA

;	resource 20 (sector $2BA, 35,864 bytes):
;	per team: NYR's player photos, a table of offsets then the pictures. PLAYER.BIN
;	loads 6 + team for the home and away teams ($1C(a6), $20(a6); docs/segacd_stats.md)
Res20	incbin	..\cdbin\GRAPH2.BIN,$15D000,35860
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$166000-*,0				;zero fill to sector $2CC

;	resource 21 (sector $2CC, 39,404 bytes):
;	per team: OTW's player photos, a table of offsets then the pictures. PLAYER.BIN
;	loads 6 + team for the home and away teams ($1C(a6), $20(a6); docs/segacd_stats.md)
Res21	incbin	..\cdbin\GRAPH2.BIN,$166000,39400
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$170000-*,0				;zero fill to sector $2E0

;	resource 22 (sector $2E0, 33,008 bytes):
;	per team: PHI's player photos, a table of offsets then the pictures. PLAYER.BIN
;	loads 6 + team for the home and away teams ($1C(a6), $20(a6); docs/segacd_stats.md)
Res22	incbin	..\cdbin\GRAPH2.BIN,$170000,33004
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$178800-*,0				;zero fill to sector $2F1

;	resource 23 (sector $2F1, 38,362 bytes):
;	per team: PIT's player photos, a table of offsets then the pictures. PLAYER.BIN
;	loads 6 + team for the home and away teams ($1C(a6), $20(a6); docs/segacd_stats.md)
Res23	incbin	..\cdbin\GRAPH2.BIN,$178800,38358
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$182000-*,0				;zero fill to sector $304

;	resource 24 (sector $304, 31,716 bytes):
;	per team: QUE's player photos, a table of offsets then the pictures. PLAYER.BIN
;	loads 6 + team for the home and away teams ($1C(a6), $20(a6); docs/segacd_stats.md)
Res24	incbin	..\cdbin\GRAPH2.BIN,$182000,31712
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$18A000-*,0				;zero fill to sector $314

;	resource 25 (sector $314, 31,870 bytes):
;	per team: SJ's player photos, a table of offsets then the pictures. PLAYER.BIN
;	loads 6 + team for the home and away teams ($1C(a6), $20(a6); docs/segacd_stats.md)
Res25	incbin	..\cdbin\GRAPH2.BIN,$18A000,31866
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$192000-*,0				;zero fill to sector $324

;	resource 26 (sector $324, 35,778 bytes):
;	per team: STL's player photos, a table of offsets then the pictures. PLAYER.BIN
;	loads 6 + team for the home and away teams ($1C(a6), $20(a6); docs/segacd_stats.md)
Res26	incbin	..\cdbin\GRAPH2.BIN,$192000,35774
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$19B000-*,0				;zero fill to sector $336

;	resource 27 (sector $336, 36,654 bytes):
;	per team: TB's player photos, a table of offsets then the pictures. PLAYER.BIN
;	loads 6 + team for the home and away teams ($1C(a6), $20(a6); docs/segacd_stats.md)
Res27	incbin	..\cdbin\GRAPH2.BIN,$19B000,36650
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1A4000-*,0				;zero fill to sector $348

;	resource 28 (sector $348, 36,106 bytes):
;	per team: TOR's player photos, a table of offsets then the pictures. PLAYER.BIN
;	loads 6 + team for the home and away teams ($1C(a6), $20(a6); docs/segacd_stats.md)
Res28	incbin	..\cdbin\GRAPH2.BIN,$1A4000,36102
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1AD000-*,0				;zero fill to sector $35A

;	resource 29 (sector $35A, 33,768 bytes):
;	per team: VAN's player photos, a table of offsets then the pictures. PLAYER.BIN
;	loads 6 + team for the home and away teams ($1C(a6), $20(a6); docs/segacd_stats.md)
Res29	incbin	..\cdbin\GRAPH2.BIN,$1AD000,33764
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1B5800-*,0				;zero fill to sector $36B

;	resource 30 (sector $36B, 35,880 bytes):
;	per team: WSH's player photos, a table of offsets then the pictures. PLAYER.BIN
;	loads 6 + team for the home and away teams ($1C(a6), $20(a6); docs/segacd_stats.md)
Res30	incbin	..\cdbin\GRAPH2.BIN,$1B5800,35876
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1BE800-*,0				;zero fill to sector $37D

;	resource 31 (sector $37D, 34,124 bytes):
;	per team: WPG's player photos, a table of offsets then the pictures. PLAYER.BIN
;	loads 6 + team for the home and away teams ($1C(a6), $20(a6); docs/segacd_stats.md)
Res31	incbin	..\cdbin\GRAPH2.BIN,$1BE800,34120
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1C7000-*,0				;zero fill to sector $38E

;	resource 32 (sector $38E, 59,118 bytes):
;	per team: ASE's player photos, a table of offsets then the pictures. PLAYER.BIN
;	loads 6 + team for the home and away teams ($1C(a6), $20(a6); docs/segacd_stats.md)
Res32	incbin	..\cdbin\GRAPH2.BIN,$1C7000,59114
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1D5800-*,0				;zero fill to sector $3AB

;	resource 33 (sector $3AB, 57,602 bytes):
;	per team: ASW's player photos, a table of offsets then the pictures. PLAYER.BIN
;	loads 6 + team for the home and away teams ($1C(a6), $20(a6); docs/segacd_stats.md)
Res33	incbin	..\cdbin\GRAPH2.BIN,$1D5800,57598
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1E4000-*,0				;zero fill to sector $3C8

;	resource 34 (sector $3C8, 18,660 bytes):
;	each team's player stats and career records, the players' names included: 28 long offsets, one
;	per team, then the records. PLAYER.BIN keeps it at $86(a6) and its pages read it
Res34	incbin	..\cdbin\GRAPH2.BIN,$1E4000,18656
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1E9000-*,0				;zero fill to sector $3D2

;	resource 35 (sector $3D2, 782 bytes):
;	per team: ANH's TeamGfxList graphics (HOCKEY.BIN $2A9FA lists one per team; LoadGameGfx
;	loads the home team's into HomeTeamGfxPtr, LoadHomeTeamGfx draws it)
Res35	incbin	..\cdbin\GRAPH2.BIN,$1E9000,778
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1E9800-*,0				;zero fill to sector $3D3

;	resource 36 (sector $3D3, 782 bytes):
;	per team: BUF's TeamGfxList graphics (HOCKEY.BIN $2A9FA lists one per team; LoadGameGfx
;	loads the home team's into HomeTeamGfxPtr, LoadHomeTeamGfx draws it)
Res36	incbin	..\cdbin\GRAPH2.BIN,$1E9800,778
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1EA000-*,0				;zero fill to sector $3D4

;	resource 37 (sector $3D4, 782 bytes):
;	per team: CGY's TeamGfxList graphics (HOCKEY.BIN $2A9FA lists one per team; LoadGameGfx
;	loads the home team's into HomeTeamGfxPtr, LoadHomeTeamGfx draws it)
Res37	incbin	..\cdbin\GRAPH2.BIN,$1EA000,778
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1EA800-*,0				;zero fill to sector $3D5

;	resource 38 (sector $3D5, 782 bytes):
;	per team: CHI's TeamGfxList graphics (HOCKEY.BIN $2A9FA lists one per team; LoadGameGfx
;	loads the home team's into HomeTeamGfxPtr, LoadHomeTeamGfx draws it)
Res38	incbin	..\cdbin\GRAPH2.BIN,$1EA800,778
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1EB000-*,0				;zero fill to sector $3D6

;	resource 39 (sector $3D6, 782 bytes):
;	per team: DAL's TeamGfxList graphics (HOCKEY.BIN $2A9FA lists one per team; LoadGameGfx
;	loads the home team's into HomeTeamGfxPtr, LoadHomeTeamGfx draws it)
Res39	incbin	..\cdbin\GRAPH2.BIN,$1EB000,778
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1EB800-*,0				;zero fill to sector $3D7

;	resource 40 (sector $3D7, 782 bytes):
;	per team: DET's TeamGfxList graphics (HOCKEY.BIN $2A9FA lists one per team; LoadGameGfx
;	loads the home team's into HomeTeamGfxPtr, LoadHomeTeamGfx draws it)
Res40	incbin	..\cdbin\GRAPH2.BIN,$1EB800,778
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1EC000-*,0				;zero fill to sector $3D8

;	resource 41 (sector $3D8, 782 bytes):
;	per team: EDM's TeamGfxList graphics (HOCKEY.BIN $2A9FA lists one per team; LoadGameGfx
;	loads the home team's into HomeTeamGfxPtr, LoadHomeTeamGfx draws it)
Res41	incbin	..\cdbin\GRAPH2.BIN,$1EC000,778
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1EC800-*,0				;zero fill to sector $3D9

;	resource 42 (sector $3D9, 782 bytes):
;	per team: FLA's TeamGfxList graphics (HOCKEY.BIN $2A9FA lists one per team; LoadGameGfx
;	loads the home team's into HomeTeamGfxPtr, LoadHomeTeamGfx draws it)
Res42	incbin	..\cdbin\GRAPH2.BIN,$1EC800,778
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1ED000-*,0				;zero fill to sector $3DA

;	resource 43 (sector $3DA, 782 bytes):
;	per team: HFD's TeamGfxList graphics (HOCKEY.BIN $2A9FA lists one per team; LoadGameGfx
;	loads the home team's into HomeTeamGfxPtr, LoadHomeTeamGfx draws it)
Res43	incbin	..\cdbin\GRAPH2.BIN,$1ED000,778
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1ED800-*,0				;zero fill to sector $3DB

;	resource 44 (sector $3DB, 782 bytes):
;	per team: LA's TeamGfxList graphics (HOCKEY.BIN $2A9FA lists one per team; LoadGameGfx
;	loads the home team's into HomeTeamGfxPtr, LoadHomeTeamGfx draws it)
Res44	incbin	..\cdbin\GRAPH2.BIN,$1ED800,778
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1EE000-*,0				;zero fill to sector $3DC

;	resource 45 (sector $3DC, 782 bytes):
;	per team: MTL's TeamGfxList graphics (HOCKEY.BIN $2A9FA lists one per team; LoadGameGfx
;	loads the home team's into HomeTeamGfxPtr, LoadHomeTeamGfx draws it)
Res45	incbin	..\cdbin\GRAPH2.BIN,$1EE000,778
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1EE800-*,0				;zero fill to sector $3DD

;	resource 46 (sector $3DD, 782 bytes):
;	per team: NJ's TeamGfxList graphics (HOCKEY.BIN $2A9FA lists one per team; LoadGameGfx
;	loads the home team's into HomeTeamGfxPtr, LoadHomeTeamGfx draws it)
Res46	incbin	..\cdbin\GRAPH2.BIN,$1EE800,778
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1EF000-*,0				;zero fill to sector $3DE

;	resource 47 (sector $3DE, 782 bytes):
;	per team: NYI's TeamGfxList graphics (HOCKEY.BIN $2A9FA lists one per team; LoadGameGfx
;	loads the home team's into HomeTeamGfxPtr, LoadHomeTeamGfx draws it)
Res47	incbin	..\cdbin\GRAPH2.BIN,$1EF000,778
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1EF800-*,0				;zero fill to sector $3DF

;	resource 48 (sector $3DF, 782 bytes):
;	per team: NYR's TeamGfxList graphics (HOCKEY.BIN $2A9FA lists one per team; LoadGameGfx
;	loads the home team's into HomeTeamGfxPtr, LoadHomeTeamGfx draws it)
Res48	incbin	..\cdbin\GRAPH2.BIN,$1EF800,778
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1F0000-*,0				;zero fill to sector $3E0

;	resource 49 (sector $3E0, 782 bytes):
;	per team: OTW's TeamGfxList graphics (HOCKEY.BIN $2A9FA lists one per team; LoadGameGfx
;	loads the home team's into HomeTeamGfxPtr, LoadHomeTeamGfx draws it)
Res49	incbin	..\cdbin\GRAPH2.BIN,$1F0000,778
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1F0800-*,0				;zero fill to sector $3E1

;	resource 50 (sector $3E1, 782 bytes):
;	per team: PHI's TeamGfxList graphics (HOCKEY.BIN $2A9FA lists one per team; LoadGameGfx
;	loads the home team's into HomeTeamGfxPtr, LoadHomeTeamGfx draws it)
Res50	incbin	..\cdbin\GRAPH2.BIN,$1F0800,778
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1F1000-*,0				;zero fill to sector $3E2

;	resource 51 (sector $3E2, 782 bytes):
;	per team: PIT's TeamGfxList graphics (HOCKEY.BIN $2A9FA lists one per team; LoadGameGfx
;	loads the home team's into HomeTeamGfxPtr, LoadHomeTeamGfx draws it)
Res51	incbin	..\cdbin\GRAPH2.BIN,$1F1000,778
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1F1800-*,0				;zero fill to sector $3E3

;	resource 52 (sector $3E3, 782 bytes):
;	per team: QUE's TeamGfxList graphics (HOCKEY.BIN $2A9FA lists one per team; LoadGameGfx
;	loads the home team's into HomeTeamGfxPtr, LoadHomeTeamGfx draws it)
Res52	incbin	..\cdbin\GRAPH2.BIN,$1F1800,778
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1F2000-*,0				;zero fill to sector $3E4

;	resource 53 (sector $3E4, 782 bytes):
;	per team: SJ's TeamGfxList graphics (HOCKEY.BIN $2A9FA lists one per team; LoadGameGfx
;	loads the home team's into HomeTeamGfxPtr, LoadHomeTeamGfx draws it)
Res53	incbin	..\cdbin\GRAPH2.BIN,$1F2000,778
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1F2800-*,0				;zero fill to sector $3E5

;	resource 54 (sector $3E5, 782 bytes):
;	per team: STL's TeamGfxList graphics (HOCKEY.BIN $2A9FA lists one per team; LoadGameGfx
;	loads the home team's into HomeTeamGfxPtr, LoadHomeTeamGfx draws it)
Res54	incbin	..\cdbin\GRAPH2.BIN,$1F2800,778
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1F3000-*,0				;zero fill to sector $3E6

;	resource 55 (sector $3E6, 782 bytes):
;	per team: TB's TeamGfxList graphics (HOCKEY.BIN $2A9FA lists one per team; LoadGameGfx
;	loads the home team's into HomeTeamGfxPtr, LoadHomeTeamGfx draws it)
Res55	incbin	..\cdbin\GRAPH2.BIN,$1F3000,778
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1F3800-*,0				;zero fill to sector $3E7

;	resource 56 (sector $3E7, 782 bytes):
;	per team: TOR's TeamGfxList graphics (HOCKEY.BIN $2A9FA lists one per team; LoadGameGfx
;	loads the home team's into HomeTeamGfxPtr, LoadHomeTeamGfx draws it)
Res56	incbin	..\cdbin\GRAPH2.BIN,$1F3800,778
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1F4000-*,0				;zero fill to sector $3E8

;	resource 57 (sector $3E8, 782 bytes):
;	per team: VAN's TeamGfxList graphics (HOCKEY.BIN $2A9FA lists one per team; LoadGameGfx
;	loads the home team's into HomeTeamGfxPtr, LoadHomeTeamGfx draws it)
Res57	incbin	..\cdbin\GRAPH2.BIN,$1F4000,778
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1F4800-*,0				;zero fill to sector $3E9

;	resource 58 (sector $3E9, 782 bytes):
;	per team: WSH's TeamGfxList graphics (HOCKEY.BIN $2A9FA lists one per team; LoadGameGfx
;	loads the home team's into HomeTeamGfxPtr, LoadHomeTeamGfx draws it)
Res58	incbin	..\cdbin\GRAPH2.BIN,$1F4800,778
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1F5000-*,0				;zero fill to sector $3EA

;	resource 59 (sector $3EA, 782 bytes):
;	per team: WPG's TeamGfxList graphics (HOCKEY.BIN $2A9FA lists one per team; LoadGameGfx
;	loads the home team's into HomeTeamGfxPtr, LoadHomeTeamGfx draws it)
Res59	incbin	..\cdbin\GRAPH2.BIN,$1F5000,778
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1F5800-*,0				;zero fill to sector $3EB

;	resource 60 (sector $3EB, 782 bytes):
;	per team: BOS's TeamGfxList graphics (HOCKEY.BIN $2A9FA lists one per team; LoadGameGfx
;	loads the home team's into HomeTeamGfxPtr, LoadHomeTeamGfx draws it)
Res60	incbin	..\cdbin\GRAPH2.BIN,$1F5800,778
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1F6000-*,0				;zero fill to sector $3EC

;	resource 61 (sector $3EC, 782 bytes):
;	per team: ASE's TeamGfxList graphics (HOCKEY.BIN $2A9FA lists one per team; LoadGameGfx
;	loads the home team's into HomeTeamGfxPtr, LoadHomeTeamGfx draws it)
Res61	incbin	..\cdbin\GRAPH2.BIN,$1F6000,778
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1F6800-*,0				;zero fill to sector $3ED

;	resource 62 (sector $3ED, 782 bytes):
;	per team: ASW's TeamGfxList graphics (HOCKEY.BIN $2A9FA lists one per team; LoadGameGfx
;	loads the home team's into HomeTeamGfxPtr, LoadHomeTeamGfx draws it)
Res62	incbin	..\cdbin\GRAPH2.BIN,$1F6800,778
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1F7000-*,0				;zero fill to sector $3EE

;	resource 63 (sector $3EE, 782 bytes): the per-team form; no team in the HOCKEY.BIN $2A9FA list uses it
Res63	incbin	..\cdbin\GRAPH2.BIN,$1F7000,778
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1F7800-*,0				;zero fill to sector $3EF

;	resource 64 (sector $3EF, 3,308 bytes):
;	a font, 93 characters from the space ($0808 picture, map 32 x 3). STARTER.BIN loads it into $C43A,
;	PLAYER.BIN into $70(a6)
Res64	incbin	..\cdbin\GRAPH2.BIN,$1F7800,3304
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1F8800-*,0				;zero fill to sector $3F1

;	resource 65 (sector $3F1, 4,836 bytes):
;	the Stanley Cup sprite (resource 0 piece 18 without the end mark); no load of this one found
Res65	incbin	..\cdbin\GRAPH2.BIN,$1F8800,4832
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1FA000-*,0				;zero fill to sector $3F4

;	resource 66 (sector $3F4, 554 bytes): Hot.map.jim (HotMap); no load of this one found
Res66	incbin	..\cdbin\GRAPH2.BIN,$1FA000,550
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1FA800-*,0				;zero fill to sector $3F5

;	resource 67 (sector $3F5, 758 bytes): Cold.map.jim (ColdMap); no load of this one found
Res67	incbin	..\cdbin\GRAPH2.BIN,$1FA800,754
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$1FB000-*,0				;zero fill to sector $3F6

;	resource 68 (sector $3F6, 31,400 bytes): per team: ANH's three page backgrounds (team name, logo and a
;	frame: the arena picture, a small photo frame, a large frame), three offsets then three $0808 pictures.
;	PLAYER.BIN loads 68 + team for the home and away teams (pointers at $0-$8(a6) and $C-$14(a6))
Res68	incbin	..\cdbin\GRAPH2.BIN,$1FB000,31396
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$203000-*,0				;zero fill to sector $406

;	resource 69 (sector $406, 29,128 bytes): per team: BOS's three page backgrounds (team name, logo and a
;	frame: the arena picture, a small photo frame, a large frame), three offsets then three $0808 pictures.
;	PLAYER.BIN loads 68 + team for the home and away teams (pointers at $0-$8(a6) and $C-$14(a6))
Res69	incbin	..\cdbin\GRAPH2.BIN,$203000,29124
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$20A800-*,0				;zero fill to sector $415

;	resource 70 (sector $415, 32,136 bytes): per team: BUF's three page backgrounds (team name, logo and a
;	frame: the arena picture, a small photo frame, a large frame), three offsets then three $0808 pictures.
;	PLAYER.BIN loads 68 + team for the home and away teams (pointers at $0-$8(a6) and $C-$14(a6))
Res70	incbin	..\cdbin\GRAPH2.BIN,$20A800,32132
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$212800-*,0				;zero fill to sector $425

;	resource 71 (sector $425, 31,912 bytes): per team: CGY's three page backgrounds (team name, logo and a
;	frame: the arena picture, a small photo frame, a large frame), three offsets then three $0808 pictures.
;	PLAYER.BIN loads 68 + team for the home and away teams (pointers at $0-$8(a6) and $C-$14(a6))
Res71	incbin	..\cdbin\GRAPH2.BIN,$212800,31908
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$21A800-*,0				;zero fill to sector $435

;	resource 72 (sector $435, 31,816 bytes): per team: CHI's three page backgrounds (team name, logo and a
;	frame: the arena picture, a small photo frame, a large frame), three offsets then three $0808 pictures.
;	PLAYER.BIN loads 68 + team for the home and away teams (pointers at $0-$8(a6) and $C-$14(a6))
Res72	incbin	..\cdbin\GRAPH2.BIN,$21A800,31812
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$222800-*,0				;zero fill to sector $445

;	resource 73 (sector $445, 24,360 bytes): per team: DAL's three page backgrounds (team name, logo and a
;	frame: the arena picture, a small photo frame, a large frame), three offsets then three $0808 pictures.
;	PLAYER.BIN loads 68 + team for the home and away teams (pointers at $0-$8(a6) and $C-$14(a6))
Res73	incbin	..\cdbin\GRAPH2.BIN,$222800,24356
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$228800-*,0				;zero fill to sector $451

;	resource 74 (sector $451, 30,088 bytes): per team: DET's three page backgrounds (team name, logo and a
;	frame: the arena picture, a small photo frame, a large frame), three offsets then three $0808 pictures.
;	PLAYER.BIN loads 68 + team for the home and away teams (pointers at $0-$8(a6) and $C-$14(a6))
Res74	incbin	..\cdbin\GRAPH2.BIN,$228800,30084
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$230000-*,0				;zero fill to sector $460

;	resource 75 (sector $460, 31,016 bytes): per team: EDM's three page backgrounds (team name, logo and a
;	frame: the arena picture, a small photo frame, a large frame), three offsets then three $0808 pictures.
;	PLAYER.BIN loads 68 + team for the home and away teams (pointers at $0-$8(a6) and $C-$14(a6))
Res75	incbin	..\cdbin\GRAPH2.BIN,$230000,31012
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$238000-*,0				;zero fill to sector $470

;	resource 76 (sector $470, 28,968 bytes): per team: FLA's three page backgrounds (team name, logo and a
;	frame: the arena picture, a small photo frame, a large frame), three offsets then three $0808 pictures.
;	PLAYER.BIN loads 68 + team for the home and away teams (pointers at $0-$8(a6) and $C-$14(a6))
Res76	incbin	..\cdbin\GRAPH2.BIN,$238000,28964
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$23F800-*,0				;zero fill to sector $47F

;	resource 77 (sector $47F, 29,864 bytes): per team: HFD's three page backgrounds (team name, logo and a
;	frame: the arena picture, a small photo frame, a large frame), three offsets then three $0808 pictures.
;	PLAYER.BIN loads 68 + team for the home and away teams (pointers at $0-$8(a6) and $C-$14(a6))
Res77	incbin	..\cdbin\GRAPH2.BIN,$23F800,29860
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$247000-*,0				;zero fill to sector $48E

;	resource 78 (sector $48E, 31,304 bytes): per team: LA's three page backgrounds (team name, logo and a
;	frame: the arena picture, a small photo frame, a large frame), three offsets then three $0808 pictures.
;	PLAYER.BIN loads 68 + team for the home and away teams (pointers at $0-$8(a6) and $C-$14(a6))
Res78	incbin	..\cdbin\GRAPH2.BIN,$247000,31300
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$24F000-*,0				;zero fill to sector $49E

;	resource 79 (sector $49E, 31,912 bytes): per team: MTL's three page backgrounds (team name, logo and a
;	frame: the arena picture, a small photo frame, a large frame), three offsets then three $0808 pictures.
;	PLAYER.BIN loads 68 + team for the home and away teams (pointers at $0-$8(a6) and $C-$14(a6))
Res79	incbin	..\cdbin\GRAPH2.BIN,$24F000,31908
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$257000-*,0				;zero fill to sector $4AE

;	resource 80 (sector $4AE, 31,976 bytes): per team: NJ's three page backgrounds (team name, logo and a
;	frame: the arena picture, a small photo frame, a large frame), three offsets then three $0808 pictures.
;	PLAYER.BIN loads 68 + team for the home and away teams (pointers at $0-$8(a6) and $C-$14(a6))
Res80	incbin	..\cdbin\GRAPH2.BIN,$257000,31972
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$25F000-*,0				;zero fill to sector $4BE

;	resource 81 (sector $4BE, 32,552 bytes): per team: NYI's three page backgrounds (team name, logo and a
;	frame: the arena picture, a small photo frame, a large frame), three offsets then three $0808 pictures.
;	PLAYER.BIN loads 68 + team for the home and away teams (pointers at $0-$8(a6) and $C-$14(a6))
Res81	incbin	..\cdbin\GRAPH2.BIN,$25F000,32548
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$267000-*,0				;zero fill to sector $4CE

;	resource 82 (sector $4CE, 33,512 bytes): per team: NYR's three page backgrounds (team name, logo and a
;	frame: the arena picture, a small photo frame, a large frame), three offsets then three $0808 pictures.
;	PLAYER.BIN loads 68 + team for the home and away teams (pointers at $0-$8(a6) and $C-$14(a6))
Res82	incbin	..\cdbin\GRAPH2.BIN,$267000,33508
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$26F800-*,0				;zero fill to sector $4DF

;	resource 83 (sector $4DF, 28,072 bytes): per team: OTW's three page backgrounds (team name, logo and a
;	frame: the arena picture, a small photo frame, a large frame), three offsets then three $0808 pictures.
;	PLAYER.BIN loads 68 + team for the home and away teams (pointers at $0-$8(a6) and $C-$14(a6))
Res83	incbin	..\cdbin\GRAPH2.BIN,$26F800,28068
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$276800-*,0				;zero fill to sector $4ED

;	resource 84 (sector $4ED, 31,880 bytes): per team: PHI's three page backgrounds (team name, logo and a
;	frame: the arena picture, a small photo frame, a large frame), three offsets then three $0808 pictures.
;	PLAYER.BIN loads 68 + team for the home and away teams (pointers at $0-$8(a6) and $C-$14(a6))
Res84	incbin	..\cdbin\GRAPH2.BIN,$276800,31876
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$27E800-*,0				;zero fill to sector $4FD

;	resource 85 (sector $4FD, 31,144 bytes): per team: PIT's three page backgrounds (team name, logo and a
;	frame: the arena picture, a small photo frame, a large frame), three offsets then three $0808 pictures.
;	PLAYER.BIN loads 68 + team for the home and away teams (pointers at $0-$8(a6) and $C-$14(a6))
Res85	incbin	..\cdbin\GRAPH2.BIN,$27E800,31140
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$286800-*,0				;zero fill to sector $50D

;	resource 86 (sector $50D, 30,184 bytes): per team: QUE's three page backgrounds (team name, logo and a
;	frame: the arena picture, a small photo frame, a large frame), three offsets then three $0808 pictures.
;	PLAYER.BIN loads 68 + team for the home and away teams (pointers at $0-$8(a6) and $C-$14(a6))
Res86	incbin	..\cdbin\GRAPH2.BIN,$286800,30180
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$28E000-*,0				;zero fill to sector $51C

;	resource 87 (sector $51C, 30,024 bytes): per team: SJ's three page backgrounds (team name, logo and a
;	frame: the arena picture, a small photo frame, a large frame), three offsets then three $0808 pictures.
;	PLAYER.BIN loads 68 + team for the home and away teams (pointers at $0-$8(a6) and $C-$14(a6))
Res87	incbin	..\cdbin\GRAPH2.BIN,$28E000,30020
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$295800-*,0				;zero fill to sector $52B

;	resource 88 (sector $52B, 28,200 bytes): per team: STL's three page backgrounds (team name, logo and a
;	frame: the arena picture, a small photo frame, a large frame), three offsets then three $0808 pictures.
;	PLAYER.BIN loads 68 + team for the home and away teams (pointers at $0-$8(a6) and $C-$14(a6))
Res88	incbin	..\cdbin\GRAPH2.BIN,$295800,28196
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$29C800-*,0				;zero fill to sector $539

;	resource 89 (sector $539, 32,296 bytes): per team: TB's three page backgrounds (team name, logo and a
;	frame: the arena picture, a small photo frame, a large frame), three offsets then three $0808 pictures.
;	PLAYER.BIN loads 68 + team for the home and away teams (pointers at $0-$8(a6) and $C-$14(a6))
Res89	incbin	..\cdbin\GRAPH2.BIN,$29C800,32292
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$2A4800-*,0				;zero fill to sector $549

;	resource 90 (sector $549, 31,912 bytes): per team: TOR's three page backgrounds (team name, logo and a
;	frame: the arena picture, a small photo frame, a large frame), three offsets then three $0808 pictures.
;	PLAYER.BIN loads 68 + team for the home and away teams (pointers at $0-$8(a6) and $C-$14(a6))
Res90	incbin	..\cdbin\GRAPH2.BIN,$2A4800,31908
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$2AC800-*,0				;zero fill to sector $559

;	resource 91 (sector $559, 32,552 bytes): per team: VAN's three page backgrounds (team name, logo and a
;	frame: the arena picture, a small photo frame, a large frame), three offsets then three $0808 pictures.
;	PLAYER.BIN loads 68 + team for the home and away teams (pointers at $0-$8(a6) and $C-$14(a6))
Res91	incbin	..\cdbin\GRAPH2.BIN,$2AC800,32548
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$2B4800-*,0				;zero fill to sector $569

;	resource 92 (sector $569, 30,440 bytes): per team: WSH's three page backgrounds (team name, logo and a
;	frame: the arena picture, a small photo frame, a large frame), three offsets then three $0808 pictures.
;	PLAYER.BIN loads 68 + team for the home and away teams (pointers at $0-$8(a6) and $C-$14(a6))
Res92	incbin	..\cdbin\GRAPH2.BIN,$2B4800,30436
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$2BC000-*,0				;zero fill to sector $578

;	resource 93 (sector $578, 29,096 bytes): per team: WPG's three page backgrounds (team name, logo and a
;	frame: the arena picture, a small photo frame, a large frame), three offsets then three $0808 pictures.
;	PLAYER.BIN loads 68 + team for the home and away teams (pointers at $0-$8(a6) and $C-$14(a6))
Res93	incbin	..\cdbin\GRAPH2.BIN,$2BC000,29092
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$2C3800-*,0				;zero fill to sector $587

;	resource 94 (sector $587, 29,416 bytes): per team: ASE's three page backgrounds (team name, logo and a
;	frame: the arena picture, a small photo frame, a large frame), three offsets then three $0808 pictures.
;	PLAYER.BIN loads 68 + team for the home and away teams (pointers at $0-$8(a6) and $C-$14(a6))
Res94	incbin	..\cdbin\GRAPH2.BIN,$2C3800,29412
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$2CB000-*,0				;zero fill to sector $596

;	resource 95 (sector $596, 28,328 bytes): per team: ASW's three page backgrounds (team name, logo and a
;	frame: the arena picture, a small photo frame, a large frame), three offsets then three $0808 pictures.
;	PLAYER.BIN loads 68 + team for the home and away teams (pointers at $0-$8(a6) and $C-$14(a6))
Res95	incbin	..\cdbin\GRAPH2.BIN,$2CB000,28324
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$2D2000-*,0				;zero fill to sector $5A4

;	resource 96 (sector $5A4, 62,202 bytes): the game's PCM wave samples: a record directory of 13 type 2
;	records (as StarterPcmRecords).
;
;	LoadGameGfx loads it (d0 = $60) into $47DA0 and passes it to OSInitMainSound (service 8, boot/sp.asm),
;	which installs it in the sub CPU PCM driver; GamePcmSampleList (HOCKEY.BIN $223D6) loads the samples,
;	which GamePcmSounds ($222EA) plays: the whistle, passes, shots, checks, hits, the crowd, the glass
;
;	(docs/segacd_main_shell.md, the sound engine)
Res96	incbin	..\cdbin\GRAPH2.BIN,$2D2000,62198
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$2E1800-*,0				;zero fill to sector $5C3

;	resource 97 (sector $5C3, 20,428 bytes):
;	the arena scoreboard frame around the film window ($0808 picture, 40 x 28). STARTER.BIN loads it
;	(d0 = $61) into $C436
Res97	incbin	..\cdbin\GRAPH2.BIN,$2E1800,20424
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$2E6800-*,0				;zero fill to sector $5CD

;	resource 98 (sector $5CD, 8,964 bytes):
;	resource 0 piece 3 (the scouting speech clips) without the end mark; no load of this one found
Res98	incbin	..\cdbin\GRAPH2.BIN,$2E6800,8960
	dc.b	$12,$34,$56,$78			;the end mark
	dcb.b	$2E9000-*,0				;zero fill to the end of the last sector
