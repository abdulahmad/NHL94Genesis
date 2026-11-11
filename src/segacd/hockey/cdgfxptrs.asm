;	HOCKEY.BIN $2CCFC-$2CDAB (runtime $47CFC-$47DAB): the graphics pointer table. CD-only, written by hand.
;
;	44 long pointers, zeros on the disc, filled at run time.
;
;	Where the cartridge loads a graphic by its ROM label (movea.l #SetupMenuMap,a0), the disc loads the
;	pointer from here (movea.l SetupMenuMapPtr,a0). scoutload.asm fills most of them from GRAPH2 resource 0
;	and LoadGameGfx (hockey94.asm) from resource 1: the comment names the pack piece
;
;	(src/segacd/data/graph2.asm), whose bytes are the cartridge graphic.
;
;	An entry is named <label>Ptr after the cartridge label of that graphic, which the code sites replaced
;	(tools/segacd_hockey.sh passes the names with --cdname so the HOCKEY.BIN fragments use them). Entries left
;	unnamed have no cartridge label.

	org	$47CFC

GfxPointers
ScoutingReportTextPtr	dc.l	0	;$47CFC R0_ScoutingReportText; scout94 reads the script from it
GameSetUpMapPtr	dc.l	0			;$47D00 R0_GameSetUpMap; optsetup94: the replaced line loaded GameSetUpMap
GameSetUpMap2Ptr	dc.l	0		;$47D04 R0_GameSetUpMap2; optsetup94: GameSetUpMap2
	dc.l	0						;$47D08 R0_13: a screen map with no cartridge twin
EASportsBGMapPtr	dc.l	0		;$47D0C R0_EASportsBGMap, R1_EASportsBGMap; six files: EASportsBGMap every
									;time
FramerMapPtr	dc.l	0			;$47D10 R0_FramerMap, R1_FramerMap; FramerMap in 6 of 8 sites
FaceOffMapPtr	dc.l	0			;$47D14 R1_FaceOffMap; FaceOffMap 3, FaceOffSprites 2
RinktilelistPtr	dc.l	0			;$47D18 R0_Rinktilelist, R1_Rinktilelist; Rinktilelist in 5 sites
RefsMapPtr	dc.l	0				;$47D1C R1_RefsMap; RefsMap 5, RefMap2 2
RefMap2Ptr	dc.l	0				;$47D20 R1_RefMap2; RefMap2 3, RefsMap 2
	dc.l	0						;$47D24 the sprite pack, GRAPH2 resource 2 (LoadGameGfx, period94)
HotListPtr	dc.l	0				;$47D28 R1_HotList; one site, HotList replaced
CrowdSpritesPtr	dc.l	0			;$47D2C R1_CrowdSprites; CrowdSprites 3 of 7
FaceOffSpritesPtr	dc.l	0		;$47D30 R1_FaceOffSprites; FaceOffSprites 3, FaceOffMap 2
ZamSpritesPtr	dc.l	0			;$47D34 R1_ZamSprites; ZamSprites 2
BigFontMapPtr	dc.l	0			;$47D38 R0_BigFontMap, R1_BigFontMap; BigFontMap 3 of 4
SmallFontMapPtr	dc.l	0			;$47D3C R0_SmallFontMap, R1_SmallFontMap; SmallFontMap 11 of 15
EnergyBarMapPtr	dc.l	0			;$47D40 R1_EnergyBarMap; EnergyBarMap 3 of 7
TeamblocksmapPtr	dc.l	0		;$47D44 R0_Teamblocksmap, R1_Teamblocksmap; Teamblocksmap 4
TeamBitmapsPtr	dc.l	0			;$47D48 R0_TeamBitmaps; TeamBitmaps 3
EASportsMapPtr	dc.l	0			;$47D4C R1_EASportsMap; EASportsMap 2
ArrowsmapPtr	dc.l	0			;$47D50 R0_Arrowsmap; Arrowsmap 2
RonBarrMapPtr	dc.l	0			;$47D54 R0_RonBarrMap; scout94: RonBarrMap
ScoresMapPtr	dc.l	0			;$47D58 R1_ScoresMap; stats94: ScoresMap
	dc.l	0						;$47D5C not known
	dc.l	0						;$47D60 the pack scoutload.asm or LoadGameGfx has just loaded, while they read its table
RevRinkTilelistPtr	dc.l	0		;$47D64 R1_RevRinkTilelist; Rinktilelist and RevRinkTilelist two sites
									;each
ReplayMapPtr	dc.l	0			;$47D68 R1_ReplayMap; ReplayMap 2
IceRinkHorMapPtr	dc.l	0		;$47D6C R1_IceRinkHorMap; penalty94: IceRinkHorMap
PrintFont2MapPtr	dc.l	0		;$47D70 R0_PrintFont2Map, R1_PrintFont2Map; PrintFont2Map 3, SmallFontMap
									;2
SetupMenuMapPtr	dc.l	0			;$47D74 R0_SetupMenuMap; optsetup94: SetupMenuMap 2
SetupFramerMapPtr	dc.l	0		;$47D78 R0_SetupFramerMap; optsetup94: SetupFramerMap
LogoBoxMapPtr	dc.l	0			;$47D7C R0_LogoBoxMap; LogoBoxMap 4 of 5
NHLLogoMapPtr	dc.l	0			;$47D80 R1_NHLLogoMap; records94: NHLLogoMap
NHLPALogoMapPtr	dc.l	0			;$47D84 R1_NHLPALogoMap; records94: NHLPALogoMap
FeaturedPicturesPtr	dc.l	0		;$47D88 R0_FeaturedPictures; cards94, middle94: the replaced lines loaded
									;FeaturedPictures (the player pictures)
TeamLogoBitmapsPtr	dc.l	0		;$47D8C R0_TeamLogoBitmaps; optsetup94, period94, records94, scout94,
									;middle94: TeamLogoBitmaps every time
HomeTeamGfxPtr	dc.l	0			;$47D90 CD name: the HomeTeam entry of the cartridge TeamGfxList
									;(LoadHomeTeamGfx in ui94)
StanleyCupSpritePtr	dc.l	0		;$47D94 R0_StanleyCupSprite; StanleyCupSprite 2
HotMapPtr	dc.l	0				;$47D98 R0_HotMap, R1_HotMap; logos94 loads it for a hot player
ColdMapPtr	dc.l	0				;$47D9C R0_ColdMap, R1_ColdMap; logos94: the cold player icon
	dc.l	0						;$47DA0 GRAPH2 resource 96, the game's PCM samples (LoadGameGfx; for OSInitMainSound, boot/sp.asm)
ScoutingSpeechClipsPtr	dc.l	0	;$47DA4 R0_ScoutingSpeechClips: the scouting report's speech clips
									;(scout94_2, scoutopen copies them to $C458)
	dc.l	0						;$47DA8 R1_24: the same form as HomeTeamGfxPtr; LoadHomeTeamGfx (ui94) takes it instead when $17468 is set
