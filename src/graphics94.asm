;	graphics94.asm: retail $4B5C0-$F66ED (700718 bytes), the data after the sound data (sound94 ends with the sound incbins,
;	$1AD90-$4B5BF): the MATCHUPS script and the graphics, up to the 94 code in the high ROM. incbin only, no gap and no overlap. Each file
;	is a slice of lst/nhl94.bin written by npm run extractassets (extractAssets94.js) into Extracted\NHL94\Graphics and Text. One slice
;	per IDA label. Labels are the 93 names, or named for what the data is, the IDA name where it is not an
;	auto name, or the name the matched segment uses (IDA hid it in a string) or, for the team logos,
;	logo<team>. Files use the 92 / 93 name where the 94 asset is the same one (same use, mostly the same size; 94 in the name when it
;	differs), else the extractAssets94.js draft name where its slice lined up, else the label. A map's tiles start past its 8-byte
;	header: the IDA label there is written as label+8.
ScoutTextScript		;retail $4B5C0-$4B79F (480 bytes). the script ScoutTextPlayer (hockey94_06) types out word by word on the ScoutingReport (MATCHUPS) screen
	incbin	..\Extracted\NHL94\Text\ScoutTextScript.bin
	even
GameSetUpMap	;retail $4B7A0-$4DEED (10062 bytes). the game setup screen bitmap, 40 x 28 (93 GameSetUp.map.jim)
	incbin	..\Extracted\NHL94\Graphics\GameSetUp94-1.map.jim
	even
GameSetUpMap2	;retail $4DEEE-$4E45B (1390 bytes). the second game setup bitmap
	incbin	..\Extracted\NHL94\Graphics\GameSetUp94-2.map.jim
	even
TitleScreenImg		;retail $4E45C-$52DA9 (18766 bytes). IDA TitleScreenImg: the newTitleScreen backdrop (high ROM)
	incbin	..\Extracted\NHL94\Graphics\Title94-1.map.jim
	even
NHLShieldImg		;retail $52DAA-$5338B (1506 bytes). IDA NHLShieldImg: the NHL shield on newTitleScreen
	incbin	..\Extracted\NHL94\Graphics\Title94-2.map.jim
	even
PAlogoImg		;retail $5338C-$5394D (1474 bytes). IDA PAlogoImg: the NHLPA logo on newTitleScreen
	incbin	..\Extracted\NHL94\Graphics\Title94-3.map.jim
	even
TitleImg		;retail $5394E-$54E23 (5334 bytes). IDA TitleImg: the title on newTitleScreen
	incbin	..\Extracted\NHL94\Graphics\Title94-4.map.jim
	even
ScoutMap		;retail $54E24-$55B7D (3418 bytes). 93 ScoutMap: the ScoutingReport and PlayoffScreen background
	incbin	..\Extracted\NHL94\Graphics\Scouting94.map.jim
	even
framermap		;retail $55B7E-$55BF5 (120 bytes). IDA framermap (92 / 93 FramerMap): Framer
	incbin	..\Extracted\NHL94\Graphics\Framer.map.jim
	even
;framermap+8: retail $55B86. the framer tiles (AddFramer, ScoutingReport)
FaceOffMap		;retail $55BF6-$56059 (1124 bytes). IDA FaceOffMap (92 / 93 name): puckfaceoff2
	incbin	..\Extracted\NHL94\Graphics\FaceOff.map.jim
	even
;FaceOffMap+8: retail $55BFE. the tiles (puckfaceoff2, ReloadFaceOffMap)
Rinktilelist		;retail $5605A-$5C407 (25518 bytes). IDA Rinktilelist (93 IceRinkMap): the ice rink (updatescroll, setupIceRinkMap, ShowReplayIcon, DisplayPeriodOver, crash)
	incbin	..\Extracted\NHL94\Graphics\IceRink94.map.jim
	even
Rinktiles	equ	Rinktilelist+8	;retail $56062. IDA Rinktiles: the rink tiles (setupice, ClrHor)
RefsMap		;retail $5C408-$5CF63 (2908 bytes). IDA RefsMap (92 / 93 name): the ref (PushRef)
	incbin	..\Extracted\NHL94\Graphics\Refs.map.jim
	even
;RefsMap+8: retail $5C410. the tiles (puckpenshot, Endfaceoff, StartHL2, ReloadRefTiles)
RefMap2		;retail $5CF64-$5DE79 (3862 bytes). 93 RefMap2: the horizontal ref (PushRef)
	incbin	..\Extracted\NHL94\Graphics\Refs2.map.jim
	even
;RefMap2+8: retail $5CF6C. the tiles (chkprogress, ReloadRefHorTiles)
Sprites		;retail $5DE7A-$5DE83 (10 bytes). the sprite header (93 Sprites; addframe2): long offsets from here $4082A (to
	;$9E6A4) and $408AA (to frameSprData), then a word
	incbin	..\Extracted\NHL94\Graphics\Sprites.bin
	even
Spritetiles		;retail $5DE84-$9E723 (264352 bytes). IDA Spritetiles: the sprite tiles (93 Sprites+$A; addframe2 adds the frame tile offset
	;to #Spritetiles)
	incbin	..\Extracted\NHL94\Graphics\Spritetiles.bin
	even
frameSprData		;retail $9E724-$A44C7 (23972 bytes). IDA frameSprData: the frame data at Sprites + $408AA (93 FrameDataOff and SprDataBytes)
	incbin	..\Extracted\NHL94\Graphics\frameSprData.bin
	even
Hotlist		;retail $A44C8-$A4B53 (1676 bytes). IDA Hotlist (93 HotList): the hot spot byte pair of each frame (GetHot)
	incbin	..\Extracted\NHL94\Graphics\Hotlist.bin
	even
CrowdFrameList		;retail $A4B54-$A78AD (11610 bytes). IDA CrowdFrameList (93 CrowdSprites): showcrowd
	incbin	..\Extracted\NHL94\Graphics\Crowd.anim
	even
;CrowdFrameList+8: retail $A4B5C. the tiles (setupice, ReloadCrowdTiles)
FaceOffSprites		;retail $A78AE-$A8921 (4212 bytes). 93 FaceOffSprites, same size: checkfo
	incbin	..\Extracted\NHL94\Graphics\FaceOff.anim
	even
;FaceOffSprites+8: retail $A78B6. the tiles (puckfaceoff2, ReloadFaceOffTiles)
ZamFrameList		;retail $A8922-$A9A0F (4334 bytes). IDA ZamFrameList (93 ZamSprites): showzam
	incbin	..\Extracted\NHL94\Graphics\Zam.anim
	even
;ZamFrameList+8: retail $A892A. the tiles (Intermission)
BigFontMap		;retail $A9A10-$AAC51 (4674 bytes). 93 BigFontMap: the big font (PrintBigChar)
	incbin	..\Extracted\NHL94\Graphics\BigFont94.map.jim
	even
;BigFontMap+8: retail $A9A18. the tiles (setupice, ScoutingReport, BuildCardPlayerList)
SmallFontMap		;retail $AAC52-$AB91F (3278 bytes). 93 SmallFontMap, same size: the small font (print, printsmall, showclock, RenderSmallFontChar)
	incbin	..\Extracted\NHL94\Graphics\SmallFont.map.jim
	even
;SmallFontMap+8: retail $AAC5A. the tiles (AddSmallFont, setupice, ScoutingReport, setoptions)
EnergyBarMap		;retail $AB920-$ABA13 (244 bytes). 93 EnergyBarMap, same size: the line energy bar frames (linebar)
	incbin	..\Extracted\NHL94\Graphics\EnergyBar.map.jim
	even
;EnergyBarMap+8: retail $AB928. the tiles (setupice, ReloadEnergyBarTiles)
Teamblocksmap		;retail $ABA14-$AFE11 (17406 bytes). 93 Teamblocksmap: the team blocks (setupTeamBlocksMap, DrawTeamBlocks, DrawTeamBlockBitmap)
	incbin	..\Extracted\NHL94\Graphics\TeamBlocks.map.jim
	even
;Teamblocksmap+8: retail $ABA1C. the tiles (AddTeamBlock)
TeamBitmaps		;retail $AFE12-$B352F (14110 bytes). 94 only, dobitmap entries (DrawTeamBitmap)
	incbin	..\Extracted\NHL94\Graphics\TeamBlocks94.map.jim
	even
;TeamBitmaps+8: retail $AFE1A. the tiles (LoadSetupTiles, where 93 setoptions called AddTeamBlock)
EASNmap		;retail $B3530-$B363F (272 bytes). 93 EASNmap: the EASN logo (EASNLogo)
	incbin	..\Extracted\NHL94\Graphics\EASN.map.jim
	even
;EASNmap+8: retail $B3538. the tiles (setupEASNmap)
Arrowsmap		;retail $B3640-$B389B (604 bytes). 93 Arrowsmap, same size: the playoff tree arrows (DrawPlayoffBracket)
	incbin	..\Extracted\NHL94\Graphics\Arrows.map.jim
	even
;Arrowsmap+8: retail $B3648. the tiles (PlayoffScreen)
RonBarrMap		;retail $B389C-$B3E73 (1496 bytes). 93 Ronbarrmap, same size: the Ron Barr picture (ScoutingReport). The old
	;extractAssets94.js RonBarrCompressed.map.jim ran 4 bytes into ScoresMap
	incbin	..\Extracted\NHL94\Graphics\RonBarr.map.jim
	even
ScoresMap		;retail $B3E74-$B4259 (998 bytes). 93 ScoresMap, same size: read by the 93 ShowScores code (stats94, from $80D4; not matched yet)
	incbin	..\Extracted\NHL94\Graphics\Scores.map.jim
	even
EASportsMap	;retail $B425A-$B517F (3878 bytes). the EA Sports screen map
	incbin	..\Extracted\NHL94\Graphics\EASportsMap.bin
	even
RevRinkTilelist		;retail $B5180-$BB4ED (25454 bytes). IDA RevRinkTilelist: the reversed ice rink (updatescroll, ShowReplayIcon)
	incbin	..\Extracted\NHL94\Graphics\IceRink94Reverse.map.jim
	even
RevRinkTiles	equ	RevRinkTilelist+8	;retail $B5188. IDA RevRinkTiles: the tiles (setupice)
ReplayMap		;retail $BB4EE-$BC05B (2926 bytes). the replay map ShowReplayBanner shows at 0,0 (16 x 11)
	incbin	..\Extracted\NHL94\Graphics\ReplayOptions.map.jim
	even
;ReplayMap+8: retail $BB4F6. the tiles (ReplayMode)
HorRinkMap	;retail $BC05C-$BE269 (8718 bytes). SetHor (93 IceRinkMap)
	incbin	..\Extracted\NHL94\Graphics\PauseScreen.map.jim
	even
icerinkmap	equ	HorRinkMap+8	;retail $BC064. IDA icerinkmap: the tiles (SetHor)
PrintFont2Map		;retail $BE26A-$BEFB7 (3406 bytes). the second print font (print, printsmall)
	incbin	..\Extracted\NHL94\Graphics\SmallFont94.map.jim
	even
;PrintFont2Map+8: retail $BE272. the tiles (setoptions: the setup screen font)
SetupMenuMap		;retail $BEFB8-$BF541 (1418 bytes). the setoptions menu background (setoptions, MoveMenuFrame)
	incbin	..\Extracted\NHL94\Graphics\GameSetupBkgd1.map.jim
	even
SetupFramerMap		;retail $BF542-$BF701 (448 bytes). the setoptions framer
	incbin	..\Extracted\NHL94\Graphics\GameSetupBkgd2.map.jim
	even
;SetupFramerMap+8: retail $BF54A. the framer tiles (setoptions; 93 FramerMap+8)
LogoBoxMap		;retail $BF702-$BF8CF (462 bytes). the logo box (DrawLogoBox, LogoBoxRight)
	incbin	..\Extracted\NHL94\Graphics\GameSetupLogoBorder.map.jim
	even
;LogoBoxMap+8: retail $BF70A. the tiles (setoptions, BuildCardPlayerList)
logoANA		;retail $BF8D0-$BFD65 (1174 bytes). the ANA logo, team 0 in TeamLogoBitmaps (hockey94_08 DrawTeamLogo, hockey94_07 GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoANA.map.jim
	even
logoBOS		;retail $BFD66-$C00BB (854 bytes). the BOS logo, team 1 in TeamLogoBitmaps (hockey94_08 DrawTeamLogo, hockey94_07 GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoBOS.map.jim
	even
logoBUF		;retail $C00BC-$C0411 (854 bytes). the BUF logo, team 2 in TeamLogoBitmaps (hockey94_08 DrawTeamLogo, hockey94_07 GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoBUF.map.jim
	even
logoCGY		;retail $C0412-$C08A7 (1174 bytes). the CGY logo, team 3 in TeamLogoBitmaps (hockey94_08 DrawTeamLogo, hockey94_07 GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoCGY.map.jim
	even
logoCHI		;retail $C08A8-$C0CDD (1078 bytes). the CHI logo, team 4 in TeamLogoBitmaps (hockey94_08 DrawTeamLogo, hockey94_07 GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoCHI.map.jim
	even
logoDET		;retail $C0CDE-$C1033 (854 bytes). the DET logo, team 6 in TeamLogoBitmaps (hockey94_08 DrawTeamLogo, hockey94_07 GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoDET.map.jim
	even
logoEDM		;retail $C1034-$C1429 (1014 bytes). the EDM logo, team 7 in TeamLogoBitmaps (hockey94_08 DrawTeamLogo, hockey94_07 GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoEDM.map.jim
	even
logoFLA		;retail $C142A-$C18FF (1238 bytes). the FLA logo, team 8 in TeamLogoBitmaps (hockey94_08 DrawTeamLogo, hockey94_07 GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoFLA.map.jim
	even
logoHFD		;retail $C1900-$C1B95 (662 bytes). the HFD logo, team 9 in TeamLogoBitmaps (hockey94_08 DrawTeamLogo, hockey94_07 GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoHFD.map.jim
	even
logoNYI		;retail $C1B96-$C1FEB (1110 bytes). the NYI logo, team 13 in TeamLogoBitmaps (hockey94_08 DrawTeamLogo, hockey94_07 GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoNYI.map.jim
	even
logoLA		;retail $C1FEC-$C2361 (886 bytes). the LA logo, team 10 in TeamLogoBitmaps (hockey94_08 DrawTeamLogo, hockey94_07 GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoLA.map.jim
	even
logoDAL		;retail $C2362-$C2637 (726 bytes). the DAL logo, team 5 in TeamLogoBitmaps (hockey94_08 DrawTeamLogo, hockey94_07 GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoDAL.map.jim
	even
logoMTL		;retail $C2638-$C29AD (886 bytes). the MTL logo, team 11 in TeamLogoBitmaps (hockey94_08 DrawTeamLogo, hockey94_07 GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoMTL.map.jim
	even
logoNJ		;retail $C29AE-$C2E63 (1206 bytes). the NJ logo, team 12 in TeamLogoBitmaps (hockey94_08 DrawTeamLogo, hockey94_07 GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoNJ.map.jim
	even
logoNYR		;retail $C2E64-$C3339 (1238 bytes). the NYR logo, team 14 in TeamLogoBitmaps (hockey94_08 DrawTeamLogo, hockey94_07 GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoNYR.map.jim
	even
logoOTW		;retail $C333A-$C374F (1046 bytes). the OTW logo, team 15 in TeamLogoBitmaps (hockey94_08 DrawTeamLogo, hockey94_07 GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoOTW.map.jim
	even
logoPHI		;retail $C3750-$C3B05 (950 bytes). the PHI logo, team 16 in TeamLogoBitmaps (hockey94_08 DrawTeamLogo, hockey94_07 GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoPHI.map.jim
	even
logoPIT		;retail $C3B06-$C3E7B (886 bytes). the PIT logo, team 17 in TeamLogoBitmaps (hockey94_08 DrawTeamLogo, hockey94_07 GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoPIT.map.jim
	even
logoQUE		;retail $C3E7C-$C41D1 (854 bytes). the QUE logo, team 18 in TeamLogoBitmaps (hockey94_08 DrawTeamLogo, hockey94_07 GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoQUE.map.jim
	even
logoSJ		;retail $C41D2-$C4607 (1078 bytes). the SJ logo, team 19 in TeamLogoBitmaps (hockey94_08 DrawTeamLogo, hockey94_07 GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoSJ.map.jim
	even
logoSTL		;retail $C4608-$C49DD (982 bytes). the STL logo, team 20 in TeamLogoBitmaps (hockey94_08 DrawTeamLogo, hockey94_07 GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoSTL.map.jim
	even
logoTB		;retail $C49DE-$C4DF3 (1046 bytes). the TB logo, team 21 in TeamLogoBitmaps (hockey94_08 DrawTeamLogo, hockey94_07 GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoTB.map.jim
	even
logoTOR		;retail $C4DF4-$C5149 (854 bytes). the TOR logo, team 22 in TeamLogoBitmaps (hockey94_08 DrawTeamLogo, hockey94_07 GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoTOR.map.jim
	even
logoVAN		;retail $C514A-$C555F (1046 bytes). the VAN logo, team 23 in TeamLogoBitmaps (hockey94_08 DrawTeamLogo, hockey94_07 GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoVAN.map.jim
	even
logoWSH		;retail $C5560-$C57D5 (630 bytes). the WSH logo, team 24 in TeamLogoBitmaps (hockey94_08 DrawTeamLogo, hockey94_07 GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoWSH.map.jim
	even
logoWPG		;retail $C57D6-$C5C4B (1142 bytes). the WPG logo, team 25 in TeamLogoBitmaps (hockey94_08 DrawTeamLogo, hockey94_07 GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoWPG.map.jim
	even
logoASE		;retail $C5C4C-$C6021 (982 bytes). the ASE logo, team 26 in TeamLogoBitmaps (hockey94_08 DrawTeamLogo, hockey94_07 GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoASE.map.jim
	even
logoASW		;retail $C6022-$C63F7 (982 bytes). the ASW logo, team 27 in TeamLogoBitmaps (hockey94_08 DrawTeamLogo, hockey94_07 GetTeamLogo)
	incbin	..\Extracted\NHL94\Graphics\logoASW.map.jim
	even
PicturePalette		;retail $C63F8-$C682D (1078 bytes). the player picture palette, and the picture of a player with none (DrawMatchupPicture, PlayerCardScreen)
	incbin	..\Extracted\NHL94\Graphics\PicturePalette.bin
	even
NoPicSkater1		;retail $C682E-$C6B97 (874 bytes). read by DrawPlayerPicture (high ROM, not matched yet)
	incbin	..\Extracted\NHL94\Graphics\NoPicSkater1.bin
	even
NoPicSkater2		;retail $C6B98-$C6F01 (874 bytes). read by DrawPlayerPicture (high ROM, not matched yet)
	incbin	..\Extracted\NHL94\Graphics\NoPicSkater2.bin
	even
NoPicGoalie1		;retail $C6F02-$C726B (874 bytes). read by DrawPlayerPicture (high ROM, not matched yet)
	incbin	..\Extracted\NHL94\Graphics\NoPicGoalie1.bin
	even
PlayerPictures		;retail $C726C-$E9A7F (141332 bytes). read by DrawPlayerPicture (high ROM, not matched yet)
	incbin	..\Extracted\NHL94\Graphics\PlayerPictures.bin
	even
CornerLogoMap		;retail $E9A80-$E9ED5 (1110 bytes). read in the high ROM near NoNameTxt and by SkipOtherUserName (not matched yet)
	incbin	..\Extracted\NHL94\Graphics\CornerLogoMap.bin
	even
ArenaGfxBank		;retail $E9ED6-$F3097 (37314 bytes). read in the high ROM near NoNameTxt and by SkipOtherUserName (not matched yet)
	incbin	..\Extracted\NHL94\Graphics\ArenaGfxBank.bin
	even
PlayoffSprite		;retail $F3098-$F5337 (8864 bytes). PlayoffScreen and DrawPlayoffSprite
	incbin	..\Extracted\NHL94\Graphics\PlayoffSprite.bin
	even
HiScoreImg		;retail $F5338-$F5AF5 (1982 bytes). IDA HiScoreImg: HiScoreScreen (high ROM)
	incbin	..\Extracted\NHL94\Graphics\HiScoreImg.bin
	even
HotIconMap		;retail $F5AF6-$F5D1B (550 bytes). read by HotColdIcon (high ROM, not matched yet)
	incbin	..\Extracted\NHL94\Graphics\HotIconMap.bin
	even
;HotIconMap+8: retail $F5AFE. the tiles (ScoutingReport)
ColdIconMap		;retail $F5D1C-$F600D (754 bytes). read by HotColdIcon (high ROM, not matched yet)
	incbin	..\Extracted\NHL94\Graphics\ColdIconMap.bin
	even
;ColdIconMap+8: retail $F5D24. the tiles (ScoutingReport)
revframetbl		;retail $F600E-$F66ED (1760 bytes). IDA revframetbl: the replay frame table (RestoreReplayFrame)
	incbin	..\Extracted\NHL94\Graphics\revframetbl.bin
	even
