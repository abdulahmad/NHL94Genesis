;	Graphics and text data, all loaded from the extracted files: the rink, sprites, fonts, screen
;	maps, pictures and one file per player card, in roster order.

ScoutTextScript						;the script UpdateScoutingDisplay types out word by word on the
									;ScoutingReport (MATCHUPS) screen
	incbin	..\Extracted\NHL94\Text\ScoutTextScript.bin
	even
GameSetUpMap						;the game setup screen bitmap, 40 x 28
	incbin	..\Extracted\NHL94\Graphics\GameSetUp94-1.map.jim
	even
GameSetUpMap2						;the second game setup bitmap
	incbin	..\Extracted\NHL94\Graphics\GameSetUp94-2.map.jim
	even
TitleScreenImg						;the newTitleScreen backdrop (high ROM)
	incbin	..\Extracted\NHL94\Graphics\Title94-1.map.jim
	even
NHLShieldImg						;the NHL shield on newTitleScreen
	incbin	..\Extracted\NHL94\Graphics\Title94-2.map.jim
	even
PAlogoImg							;the NHLPA logo on newTitleScreen
	incbin	..\Extracted\NHL94\Graphics\Title94-3.map.jim
	even
TitleImg							;the title on newTitleScreen
	incbin	..\Extracted\NHL94\Graphics\Title94-4.map.jim
	even
ScoutMap							;the ScoutingReport and PlayoffScreen background
	incbin	..\Extracted\NHL94\Graphics\Scouting94.map.jim
	even
FramerMap							;Framer
	incbin	..\Extracted\NHL94\Graphics\Framer.map.jim
	even
;FramerMap+8: the framer tiles (AddFramer, ScoutingReport)
FaceOffMap							;: puckfaceoff2
	incbin	..\Extracted\NHL94\Graphics\FaceOff.map.jim
	even
;FaceOffMap+8: the tiles (puckfaceoff2, ReloadFaceOffMap)
Rinktilelist						;the ice rink (updatescroll, setupIceRinkPal,
									;ShowReplayIcon, ShowThreeStars, crash)
	incbin	..\Extracted\NHL94\Graphics\IceRink94.map.jim
	even
Rinktiles	equ	Rinktilelist+8		;the rink tiles (setupice, ClrHor)
RefsMap								;: the ref (PushRef)
	incbin	..\Extracted\NHL94\Graphics\Refs.map.jim
	even
;RefsMap+8: the tiles (puckpenshot, Endfaceoff, StartHL2, ReloadRefTiles)
RefMap2								;the horizontal ref (PushRef)
	incbin	..\Extracted\NHL94\Graphics\Refs2.map.jim
	even
;RefMap2+8: the tiles (chkprogress, ReloadRefHorTiles)
Sprites								;the sprite header (addframe2): long offsets from here (to
	incbin	..\Extracted\NHL94\Graphics\Sprites.bin
	even
Spritetiles							;the sprite tiles (+$A; addframe2 adds the frame tile offset to
									;#Spritetiles)
	incbin	..\Extracted\NHL94\Graphics\Spritetiles.bin
	even
frameSprData						;sprite piece data of each frame
	incbin	..\Extracted\NHL94\Graphics\frameSprData.bin
	even
HotList								;the hot spot byte pair of each frame
	incbin	..\Extracted\NHL94\Graphics\HotList.bin
	even
Crowdframelist						;showcrowd
	incbin	..\Extracted\NHL94\Graphics\Crowd.anim
	even
;Crowdframelist+8: the tiles (setupice, ReloadCrowdTiles)
FaceOffSprites						;same size: checkfo
	incbin	..\Extracted\NHL94\Graphics\FaceOff.anim
	even
;FaceOffSprites+8: the tiles (puckfaceoff2, ReloadFaceOffTiles)
ZamFrameList						;showzam
	incbin	..\Extracted\NHL94\Graphics\Zam.anim
	even
;ZamFrameList+8: the tiles (Intermission)
BigFontMap							;the big font (PrintBigChar)
	incbin	..\Extracted\NHL94\Graphics\BigFont94.map.jim
	even
;BigFontMap+8: the tiles (setupice, ScoutingReport, BuildCardPlayerList)
SmallFontMap						;same size: the small font (print, printsmall,
									;showclock, RenderSmallFontChar)
	incbin	..\Extracted\NHL94\Graphics\SmallFont.map.jim
	even
;SmallFontMap+8: the tiles (AddSmallFont, setupice, ScoutingReport, setoptions)
EnergyBarMap						;same size: the line energy bar frames (linebar)
	incbin	..\Extracted\NHL94\Graphics\EnergyBar.map.jim
	even
;EnergyBarMap+8: the tiles (setupice, ReloadEnergyBarTiles)
Teamblocksmap						;the team blocks (setupTeamBlocksMap, DrawTeamBlocks, dotb)
	incbin	..\Extracted\NHL94\Graphics\TeamBlocks.map.jim
	even
;Teamblocksmap+8: the tiles (AddTeamBlock)
TeamBitmaps							;dobitmap entries (DrawTeamBitmap)
	incbin	..\Extracted\NHL94\Graphics\TeamBlocks94.map.jim
	even
	include	..\output\teamcounts.inc
	IF TeamblocksEntries<>NumTeams
		inform	3,"Teamblocksmap needs one entry per team"
	ENDIF
	IF TeamBitmapsEntries<>NumTeams
		inform	3,"TeamBitmaps needs one entry per team"
	ENDIF
;TeamBitmaps+8: the tiles (LoadSetupTiles)
EASNmap								;the EASN logo (EASNLogo)
	incbin	..\Extracted\NHL94\Graphics\EASN.map.jim
	even
;EASNmap+8: the tiles (setupEASNmap)
Arrowsmap							;same size: the playoff tree arrows (DrawTreeArrow)
	incbin	..\Extracted\NHL94\Graphics\Arrows.map.jim
	even
;Arrowsmap+8: the tiles (PlayoffScreen)
RonBarrMap							;same size: the Ron Barr picture (ScoutingReport). The old
									;RonBarrCompressed.map.jim ran 4 bytes into ScoresMap
	incbin	..\Extracted\NHL94\Graphics\RonBarr.map.jim
	even
ScoresMap							;same size
	incbin	..\Extracted\NHL94\Graphics\Scores.map.jim
	even
EASportsMap							;the EA Sports screen map
	incbin	..\Extracted\NHL94\Graphics\EASportsMap.bin
	even
RevRinkTilelist						;the reversed ice rink (updatescroll, ShowReplayIcon)
	incbin	..\Extracted\NHL94\Graphics\IceRink94Reverse.map.jim
	even
RevRinkTiles	equ	RevRinkTilelist+8	;the tiles (setupice)
ReplayMap							;the replay map ShowReplayBanner shows at 0,0 (16 x 11)
	incbin	..\Extracted\NHL94\Graphics\ReplayOptions.map.jim
	even
;ReplayMap+8: the tiles (ReplayMode)
HorRinkMap							;SetHor
	incbin	..\Extracted\NHL94\Graphics\PauseScreen.map.jim
	even
HorRinkTiles	equ	HorRinkMap+8	;the tiles (SetHor)
PrintFont2Map						;the second print font (print, printsmall)
	incbin	..\Extracted\NHL94\Graphics\SmallFont94.map.jim
	even
;PrintFont2Map+8: the tiles (setoptions: the setup screen font)
SetupMenuMap						;the setoptions menu background (setoptions, MoveMenuFrame)
	incbin	..\Extracted\NHL94\Graphics\GameSetupBkgd1.map.jim
	even
SetupFramerMap						;the setoptions framer
	incbin	..\Extracted\NHL94\Graphics\GameSetupBkgd2.map.jim
	even
;SetupFramerMap+8: the framer tiles (setoptions)
LogoBoxMap							;the logo box (DrawLogoBox, LogoBoxRight)
	incbin	..\Extracted\NHL94\Graphics\GameSetupLogoBorder.map.jim
	even
;LogoBoxMap+8: the tiles (setoptions, BuildCardPlayerList)
logoANH								;the ANH logo, team 0 in TeamLogoBitmaps (DrawTeamLogo, GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoANA.map.jim
	even
logoBOS								;the BOS logo, team 1 in TeamLogoBitmaps (DrawTeamLogo, GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoBOS.map.jim
	even
logoBUF								;the BUF logo, team 2 in TeamLogoBitmaps (DrawTeamLogo, GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoBUF.map.jim
	even
logoCGY								;the CGY logo, team 3 in TeamLogoBitmaps (DrawTeamLogo, GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoCGY.map.jim
	even
logoCHI								;the CHI logo, team 4 in TeamLogoBitmaps (DrawTeamLogo, GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoCHI.map.jim
	even
logoDET								;the DET logo, team 6 in TeamLogoBitmaps (DrawTeamLogo, GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoDET.map.jim
	even
logoEDM								;the EDM logo, team 7 in TeamLogoBitmaps (DrawTeamLogo, GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoEDM.map.jim
	even
logoFLA								;the FLA logo, team 8 in TeamLogoBitmaps (DrawTeamLogo, GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoFLA.map.jim
	even
logoHFD								;the HFD logo, team 9 in TeamLogoBitmaps (DrawTeamLogo, GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoHFD.map.jim
	even
logoNYI								;the NYI logo, team 13 in TeamLogoBitmaps (DrawTeamLogo, GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoNYI.map.jim
	even
logoLA								;the LA logo, team 10 in TeamLogoBitmaps (DrawTeamLogo, GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoLA.map.jim
	even
logoDAL								;the DAL logo, team 5 in TeamLogoBitmaps (DrawTeamLogo, GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoDAL.map.jim
	even
logoMTL								;the MTL logo, team 11 in TeamLogoBitmaps (DrawTeamLogo, GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoMTL.map.jim
	even
logoNJ								;the NJ logo, team 12 in TeamLogoBitmaps (DrawTeamLogo, GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoNJ.map.jim
	even
logoNYR								;the NYR logo, team 14 in TeamLogoBitmaps (DrawTeamLogo, GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoNYR.map.jim
	even
logoOTW								;the OTW logo, team 15 in TeamLogoBitmaps (DrawTeamLogo, GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoOTW.map.jim
	even
logoPHI								;the PHI logo, team 16 in TeamLogoBitmaps (DrawTeamLogo, GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoPHI.map.jim
	even
logoPIT								;the PIT logo, team 17 in TeamLogoBitmaps (DrawTeamLogo, GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoPIT.map.jim
	even
logoQUE								;the QUE logo, team 18 in TeamLogoBitmaps (DrawTeamLogo, GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoQUE.map.jim
	even
logoSJ								;the SJ logo, team 19 in TeamLogoBitmaps (DrawTeamLogo, GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoSJ.map.jim
	even
logoSTL								;the STL logo, team 20 in TeamLogoBitmaps (DrawTeamLogo, GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoSTL.map.jim
	even
logoTB								;the TB logo, team 21 in TeamLogoBitmaps (DrawTeamLogo, GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoTB.map.jim
	even
logoTOR								;the TOR logo, team 22 in TeamLogoBitmaps (DrawTeamLogo, GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoTOR.map.jim
	even
logoVAN								;the VAN logo, team 23 in TeamLogoBitmaps (DrawTeamLogo, GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoVAN.map.jim
	even
logoWSH								;the WSH logo, team 24 in TeamLogoBitmaps (DrawTeamLogo, GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoWSH.map.jim
	even
logoWPG								;the WPG logo, team 25 in TeamLogoBitmaps (DrawTeamLogo, GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoWPG.map.jim
	even
logoASE								;the ASE logo, team 26 in TeamLogoBitmaps (DrawTeamLogo, GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoASE.map.jim
	even
logoASW								;the ASW logo, team 27 in TeamLogoBitmaps (DrawTeamLogo, GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoASW.map.jim
	even
PicturePalette						;the player picture palette, and the picture of a player with none
									;(DrawMatchupPicture, PlayerCardScreen)
	incbin	..\Extracted\NHL94\Graphics\PicturePalette.bin
	even
NoPicSkater1						;read by DrawPlayerPicture (high ROM)
	incbin	..\Extracted\NHL94\Graphics\NoPicSkater1.bin
	even
NoPicSkater2						;read by DrawPlayerPicture (high ROM)
	incbin	..\Extracted\NHL94\Graphics\NoPicSkater2.bin
	even
NoPicGoalie1						;read by DrawPlayerPicture (high ROM)
	incbin	..\Extracted\NHL94\Graphics\NoPicGoalie1.bin
	even
NoPicGoalie2						;the generic goalie card: DrawPlayerPicture uses it for a goalie with no
									;card whose hand rating (h) bit 0 is clear (NoPicGoalie1 when set). Also
									;listed for ANH 0 and FLA 0
	incbin	..\Extracted\NHL94\Graphics\NoPicGoalie2.bin
	even
Card001								;Player card 1 (FeaturedPictures BOS 0)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card001.bin
	even
Card002								;Player card 2 (FeaturedPictures BOS 17, ASE 18)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card002.bin
	even
Card003								;Player card 3 (FeaturedPictures BOS 2, ASE 6)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card003.bin
	even
Card004								;Player card 4 (FeaturedPictures BOS 18)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card004.bin
	even
Card005								;Player card 5 (FeaturedPictures BOS 6)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card005.bin
	even
Card006								;Player card 6 (FeaturedPictures BOS 11)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card006.bin
	even
Card007								;Player card 7 (FeaturedPictures BUF 12, ASE 15)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card007.bin
	even
Card008								;Player card 8 (FeaturedPictures BUF 3, ASE 9)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card008.bin
	even
Card009								;Player card 9 (FeaturedPictures BUF 4)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card009.bin
	even
Card010								;Player card 10 (FeaturedPictures BUF 17)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card010.bin
	even
Card011								;Player card 11 (FeaturedPictures BUF 0, ASE 1)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card011.bin
	even
Card012								;Player card 12 (FeaturedPictures BUF 18)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card012.bin
	even
Card013								;Player card 13 (FeaturedPictures CGY 0)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card013.bin
	even
Card014								;Player card 14 (FeaturedPictures CGY 6, ASW 9)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card014.bin
	even
Card015								;Player card 15 (FeaturedPictures CGY 11, ASW 11)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card015.bin
	even
Card016								;Player card 16 (FeaturedPictures CGY 15, ASW 17)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card016.bin
	even
Card017								;Player card 17 (FeaturedPictures CGY 16)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card017.bin
	even
Card018								;Player card 18 (FeaturedPictures CGY 2)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card018.bin
	even
Card019								;Player card 19 (FeaturedPictures CHI 0, ASW 0)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card019.bin
	even
Card020								;Player card 20 (FeaturedPictures CHI 2, ASW 5)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card020.bin
	even
Card021								;Player card 21 (FeaturedPictures CHI 11)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card021.bin
	even
Card022								;Player card 22 (FeaturedPictures CHI 17, ASW 20)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card022.bin
	even
Card023								;Player card 23 (FeaturedPictures CHI 18, ASW 23)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card023.bin
	even
Card024								;Player card 24 (FeaturedPictures CHI 6)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card024.bin
	even
Card025								;Player card 25 (FeaturedPictures DET 0, ASW 1)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card025.bin
	even
Card026								;Player card 26 (FeaturedPictures DET 2, ASW 3)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card026.bin
	even
Card027								;Player card 27 (FeaturedPictures DET 3)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card027.bin
	even
Card028								;Player card 28 (FeaturedPictures DET 17, ASW 19)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card028.bin
	even
Card029								;Player card 29 (FeaturedPictures DET 18, ASW 24)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card029.bin
	even
Card030								;Player card 30 (FeaturedPictures DET 12)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card030.bin
	even
Card031								;Player card 31 (FeaturedPictures EDM 0)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card031.bin
	even
Card032								;Player card 32 (FeaturedPictures EDM 17, ASW 22)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card032.bin
	even
Card033								;Player card 33 (FeaturedPictures EDM 18)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card033.bin
	even
Card034								;Player card 34 (FeaturedPictures EDM 8)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card034.bin
	even
Card035								;Player card 35 (FeaturedPictures EDM 2). Own palette and tile
									;layout, header 0000033A 000003BA 0022
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card035.bin
	even
Card036								;Player card 36 (FeaturedPictures EDM 14)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card036.bin
	even
Card037								;Player card 37 (FeaturedPictures HFD 0)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card037.bin
	even
Card038								;Player card 38 (FeaturedPictures HFD 3)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card038.bin
	even
Card039								;Player card 39 (FeaturedPictures HFD 8)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card039.bin
	even
Card040								;Player card 40 (FeaturedPictures HFD 13)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card040.bin
	even
Card041								;Player card 41 (FeaturedPictures HFD 18, ASE 23)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card041.bin
	even
Card042								;Player card 42 (FeaturedPictures HFD 19)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card042.bin
	even
Card043								;Player card 43 (FeaturedPictures NYI 3)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card043.bin
	even
Card044								;Player card 44 (FeaturedPictures NYI 8)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card044.bin
	even
Card045								;Player card 45 (FeaturedPictures NYI 2, ASE 8)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card045.bin
	even
Card046								;Player card 46 (FeaturedPictures NYI 0)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card046.bin
	even
Card047								;Player card 47 (FeaturedPictures NYI 18)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card047.bin
	even
Card048								;Player card 48 (FeaturedPictures NYI 17). Own palette and
									;tile layout, header 0000033A 000003BA 0022
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card048.bin
	even
Card049								;Player card 49 (FeaturedPictures LA 0). Own palette and tile
									;layout, header 00000322 000003A2 0021
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card049.bin
	even
Card050								;Player card 50 (FeaturedPictures LA 3, ASW 8)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card050.bin
	even
Card051								;Player card 51 (FeaturedPictures LA 7, ASW 10)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card051.bin
	even
Card052								;Player card 52 (FeaturedPictures LA 12)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card052.bin
	even
Card053								;Player card 53 (FeaturedPictures LA 16)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card053.bin
	even
Card054								;Player card 54 (FeaturedPictures LA 17)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card054.bin
	even
Card055								;Player card 55 (FeaturedPictures DAL 0)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card055.bin
	even
Card056								;Player card 56 (FeaturedPictures DAL 2, ASW 4)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card056.bin
	even
Card057								;Player card 57 (FeaturedPictures DAL 16)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card057.bin
	even
Card058								;Player card 58 (FeaturedPictures DAL 17)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card058.bin
	even
Card059								;Player card 59 (FeaturedPictures DAL 3)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card059.bin
	even
Card060								;Player card 60 (FeaturedPictures DAL 10)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card060.bin
	even
Card061								;Player card 61 (FeaturedPictures MTL 0, ASE 0)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card061.bin
	even
Card062								;Player card 62 (FeaturedPictures MTL 16)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card062.bin
	even
Card063								;Player card 63 (FeaturedPictures MTL 17). Own palette and
									;tile layout, header 0000030A 0000038A 0020
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card063.bin
	even
Card064								;Player card 64 (FeaturedPictures MTL 2, ASE 5)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card064.bin
	even
Card065								;Player card 65 (FeaturedPictures MTL 6)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card065.bin
	even
Card066								;Player card 66 (FeaturedPictures MTL 11)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card066.bin
	even
Card067								;Player card 67 (FeaturedPictures NJ 17, ASE 22)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card067.bin
	even
Card068								;Player card 68 (FeaturedPictures NJ 0)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card068.bin
	even
Card069								;Player card 69 (FeaturedPictures NJ 18)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card069.bin
	even
Card070								;Player card 70 (FeaturedPictures NJ 11)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card070.bin
	even
Card071								;Player card 71 (FeaturedPictures NJ 2)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card071.bin
	even
Card072								;Player card 72 (FeaturedPictures NJ 12)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card072.bin
	even
Card073								;Player card 73 (FeaturedPictures NYR 0). Own palette and
									;tile layout, header 0000030A 0000038A 0020
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card073.bin
	even
Card074								;Player card 74 (FeaturedPictures NYR 2, ASE 4)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card074.bin
	even
Card075								;Player card 75 (FeaturedPictures NYR 18)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card075.bin
	even
Card076								;Player card 76 (FeaturedPictures NYR 11, ASE 13)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card076.bin
	even
Card077								;Player card 77 (FeaturedPictures NYR 17, ASE 19)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card077.bin
	even
Card078								;Player card 78 (FeaturedPictures NYR 6)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card078.bin
	even
Card079								;Player card 79 (FeaturedPictures OTW 0). Own palette and
									;tile layout, header 0000030A 0000038A 0020
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card079.bin
	even
Card080								;Player card 80 (FeaturedPictures OTW 9)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card080.bin
	even
Card081								;Player card 81 (FeaturedPictures OTW 18)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card081.bin
	even
Card082								;Player card 82 (FeaturedPictures OTW 19)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card082.bin
	even
Card083								;Player card 83 (FeaturedPictures OTW 2)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card083.bin
	even
Card084								;Player card 84 (FeaturedPictures OTW 14)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card084.bin
	even
Card085								;Player card 85 (FeaturedPictures PHI 3)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card085.bin
	even
Card086								;Player card 86 (FeaturedPictures PHI 4)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card086.bin
	even
Card087								;Player card 87 (FeaturedPictures PHI 17)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card087.bin
	even
Card088								;Player card 88 (FeaturedPictures PHI 14, ASE 16)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card088.bin
	even
Card089								;Player card 89 (FeaturedPictures PHI 0)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card089.bin
	even
Card090								;Player card 90 (FeaturedPictures PHI 18)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card090.bin
	even
Card091								;Player card 91 (FeaturedPictures PIT 0, ASE 2)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card091.bin
	even
Card092								;Player card 92 (FeaturedPictures PIT 2, ASE 3)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card092.bin
	even
Card093								;Player card 93 (FeaturedPictures PIT 6, ASE 10)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card093.bin
	even
Card094								;Player card 94 (FeaturedPictures PIT 10, ASE 11)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card094.bin
	even
Card095								;Player card 95 (FeaturedPictures PIT 16, ASE 17)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card095.bin
	even
Card096								;Player card 96 (FeaturedPictures PIT 17)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card096.bin
	even
Card097								;Player card 97 (FeaturedPictures QUE 0). Own palette and tile
									;layout, header 0000030A 0000038A 0020
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card097.bin
	even
Card098								;Player card 98 (FeaturedPictures QUE 14)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card098.bin
	even
Card099								;Player card 99 (FeaturedPictures QUE 17, ASE 20)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card099.bin
	even
Card100								;Player card 100 (FeaturedPictures QUE 2, ASE 7)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card100.bin
	even
Card101								;Player card 101 (FeaturedPictures QUE 18)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card101.bin
	even
Card102								;Player card 102 (FeaturedPictures QUE 13)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card102.bin
	even
Card103								;Player card 103 (FeaturedPictures SJ 3)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card103.bin
	even
Card104								;Player card 104 (FeaturedPictures SJ 16)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card104.bin
	even
Card105								;Player card 105 (FeaturedPictures SJ 13, ASW 15)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card105.bin
	even
Card106								;Player card 106 (FeaturedPictures SJ 0)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card106.bin
	even
Card107								;Player card 107 (FeaturedPictures SJ 17)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card107.bin
	even
Card108								;Player card 108 (FeaturedPictures SJ 9)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card108.bin
	even
Card109								;Player card 109 (FeaturedPictures STL 0)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card109.bin
	even
Card110								;Player card 110 (FeaturedPictures STL 2)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card110.bin
	even
Card111								;Player card 111 (FeaturedPictures STL 12, ASW 12)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card111.bin
	even
Card112								;Player card 112 (FeaturedPictures STL 17)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card112.bin
	even
Card113								;Player card 113 (FeaturedPictures STL 16, ASW 18)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card113.bin
	even
Card114								;Player card 114 (FeaturedPictures STL 11)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card114.bin
	even
Card115								;Player card 115 (FeaturedPictures TB 3, ASW 6)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card115.bin
	even
Card116								;Player card 116 (FeaturedPictures TB 0)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card116.bin
	even
Card117								;Player card 117 (FeaturedPictures TB 19)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card117.bin
	even
Card118								;Player card 118 (FeaturedPictures TB 18)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card118.bin
	even
Card119								;Player card 119 (FeaturedPictures TB 11)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card119.bin
	even
Card120								;Player card 120 (FeaturedPictures TB 4)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card120.bin
	even
Card121								;Player card 121 (FeaturedPictures TOR 0, ASW 2)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card121.bin
	even
Card122								;Player card 122 (FeaturedPictures TOR 3, ASW 7)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card122.bin
	even
Card123								;Player card 123 (FeaturedPictures TOR 12)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card123.bin
	even
Card124								;Player card 124 (FeaturedPictures TOR 18)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card124.bin
	even
Card125								;Player card 125 (FeaturedPictures TOR 17)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card125.bin
	even
Card126								;Player card 126 (FeaturedPictures TOR 8). Own palette and
									;tile layout, header 0000033A 000003BA 0022
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card126.bin
	even
Card127								;Player card 127 (FeaturedPictures VAN 0)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card127.bin
	even
Card128								;Player card 128 (FeaturedPictures VAN 6)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card128.bin
	even
Card129								;Player card 129 (FeaturedPictures VAN 12, ASW 13)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card129.bin
	even
Card130								;Player card 130 (FeaturedPictures VAN 17)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card130.bin
	even
Card131								;Player card 131 (FeaturedPictures VAN 18)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card131.bin
	even
Card132								;Player card 132 (FeaturedPictures VAN 2)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card132.bin
	even
Card133								;Player card 133 (FeaturedPictures WSH 0)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card133.bin
	even
Card134								;Player card 134 (FeaturedPictures WSH 2)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card134.bin
	even
Card135								;Player card 135 (FeaturedPictures WSH 3)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card135.bin
	even
Card136								;Player card 136 (FeaturedPictures WSH 11, ASE 12)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card136.bin
	even
Card137								;Player card 137 (FeaturedPictures WSH 16)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card137.bin
	even
Card138								;Player card 138 (FeaturedPictures WSH 17, ASE 21)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card138.bin
	even
Card139								;Player card 139 (FeaturedPictures WPG 3)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card139.bin
	even
Card140								;Player card 140 (FeaturedPictures WPG 12, ASW 14)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card140.bin
	even
Card141								;Player card 141 (FeaturedPictures WPG 17, ASW 21)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card141.bin
	even
Card142								;Player card 142 (FeaturedPictures WPG 0)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card142.bin
	even
Card143								;Player card 143 (FeaturedPictures WPG 18). Own palette and
									;tile layout, header 00000352 000003D2 0023
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card143.bin
	even
Card144								;Player card 144 (FeaturedPictures WPG 2)
	incbin	..\Extracted\NHL94\Graphics\PlayerCards\Card144.bin
	even
PlayerCardsScreenPic				;the Player Cards screen picture, 40 x 28 tiles with its own palette and
									;layout (PlayerCards)
	incbin	..\Extracted\NHL94\Graphics\PlayerCardsScreenPic.bin
	even
CornerLogoMap						;read in the high ROM near NoNameTxt and by SkipOtherUserName
	incbin	..\Extracted\NHL94\Graphics\CornerLogoMap.bin
	even
ArenaGfxBank						;read in the high ROM near NoNameTxt and by SkipOtherUserName
	incbin	..\Extracted\NHL94\Graphics\ArenaGfxBank.bin
	even
PlayoffSprite						;PlayoffScreen and DrawPlayoffSprite
	incbin	..\Extracted\NHL94\Graphics\PlayoffSprite.bin
	even
HiScoreImg							;HiScoreScreen (high ROM)
	incbin	..\Extracted\NHL94\Graphics\HiScoreImg.bin
	even
HotIconMap							;read by HotColdIcon (high ROM)
	incbin	..\Extracted\NHL94\Graphics\HotIconMap.bin
	even
;HotIconMap+8: the tiles (ScoutingReport)
ColdIconMap							;read by HotColdIcon (high ROM)
	incbin	..\Extracted\NHL94\Graphics\ColdIconMap.bin
	even
;ColdIconMap+8: the tiles (ScoutingReport)
revframetbl							;the replay frame table (RestoreReplayFrame)
	incbin	..\Extracted\NHL94\Graphics\revframetbl.bin
	even
