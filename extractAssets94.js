const fs = require('fs').promises;
const path = require('path');
const crc32 = require('crc-32'); // Requires 'crc-32' package: npm install crc-32

// Asset definitions from the .lst file
const assets = [
    // { name: 'EALogo.bin', folder: 'NHL94/Graphics', start: 0x00000306, end: 0x00001164 },
    // NHL 94 team palettes, src/teamdata94.asm .pad of each team block (block + $C): home then visitor, 32 bytes each, in ROM order.
    // The 93 file name (extractAssets93-1.1.js) where the bytes equal 93's, 94 added where they differ; Dallas keeps the 93 Minnesota palettes.
    { name: 'ASEh.pal', folder: 'NHL94/Graphics/Pals', start: 0x0000038A, end: 0x000003AA }, // ASE home
    { name: 'ASEv.pal', folder: 'NHL94/Graphics/Pals', start: 0x000003AA, end: 0x000003CA }, // ASE visitor
    { name: 'ASWh.pal', folder: 'NHL94/Graphics/Pals', start: 0x00000680, end: 0x000006A0 }, // ASW home
    { name: 'ASWv.pal', folder: 'NHL94/Graphics/Pals', start: 0x000006A0, end: 0x000006C0 }, // ASW visitor
    { name: 'BOSh.pal', folder: 'NHL94/Graphics/Pals', start: 0x00000972, end: 0x00000992 }, // BOS home
    { name: 'BOSv.pal', folder: 'NHL94/Graphics/Pals', start: 0x00000992, end: 0x000009B2 }, // BOS visitor
    { name: 'BUFh.pal', folder: 'NHL94/Graphics/Pals', start: 0x00000C58, end: 0x00000C78 }, // BUF home
    { name: 'BUFv.pal', folder: 'NHL94/Graphics/Pals', start: 0x00000C78, end: 0x00000C98 }, // BUF visitor
    { name: 'CGYh.pal', folder: 'NHL94/Graphics/Pals', start: 0x00000F46, end: 0x00000F66 }, // CGY home
    { name: 'CGYv.pal', folder: 'NHL94/Graphics/Pals', start: 0x00000F66, end: 0x00000F86 }, // CGY visitor
    { name: 'CHIh.pal', folder: 'NHL94/Graphics/Pals', start: 0x00001240, end: 0x00001260 }, // CHI home
    { name: 'CHIv.pal', folder: 'NHL94/Graphics/Pals', start: 0x00001260, end: 0x00001280 }, // CHI visitor
    { name: 'DETh.pal', folder: 'NHL94/Graphics/Pals', start: 0x0000153A, end: 0x0000155A }, // DET home
    { name: 'DETv.pal', folder: 'NHL94/Graphics/Pals', start: 0x0000155A, end: 0x0000157A }, // DET visitor
    { name: 'EDMh.pal', folder: 'NHL94/Graphics/Pals', start: 0x00001854, end: 0x00001874 }, // EDM home
    { name: 'EDMv.pal', folder: 'NHL94/Graphics/Pals', start: 0x00001874, end: 0x00001894 }, // EDM visitor
    { name: 'HFDh94.pal', folder: 'NHL94/Graphics/Pals', start: 0x00001B50, end: 0x00001B70 }, // HFD home
    { name: 'HFDv94.pal', folder: 'NHL94/Graphics/Pals', start: 0x00001B70, end: 0x00001B90 }, // HFD visitor
    { name: 'LAh.pal', folder: 'NHL94/Graphics/Pals', start: 0x00001E5E, end: 0x00001E7E }, // LA home
    { name: 'LAv.pal', folder: 'NHL94/Graphics/Pals', start: 0x00001E7E, end: 0x00001E9E }, // LA visitor
    { name: 'MINh.pal', folder: 'NHL94/Graphics/Pals', start: 0x0000215A, end: 0x0000217A }, // DAL home
    { name: 'MINv.pal', folder: 'NHL94/Graphics/Pals', start: 0x0000217A, end: 0x0000219A }, // DAL visitor
    { name: 'MTLh.pal', folder: 'NHL94/Graphics/Pals', start: 0x0000244A, end: 0x0000246A }, // MTL home
    { name: 'MTLv.pal', folder: 'NHL94/Graphics/Pals', start: 0x0000246A, end: 0x0000248A }, // MTL visitor
    { name: 'NJh.pal', folder: 'NHL94/Graphics/Pals', start: 0x0000274C, end: 0x0000276C }, // NJ home
    { name: 'NJv.pal', folder: 'NHL94/Graphics/Pals', start: 0x0000276C, end: 0x0000278C }, // NJ visitor
    { name: 'LIh.pal', folder: 'NHL94/Graphics/Pals', start: 0x00002A64, end: 0x00002A84 }, // NYI home
    { name: 'LIv.pal', folder: 'NHL94/Graphics/Pals', start: 0x00002A84, end: 0x00002AA4 }, // NYI visitor
    { name: 'NYh.pal', folder: 'NHL94/Graphics/Pals', start: 0x00002D68, end: 0x00002D88 }, // NYR home
    { name: 'NYv.pal', folder: 'NHL94/Graphics/Pals', start: 0x00002D88, end: 0x00002DA8 }, // NYR visitor
    { name: 'OTWh.pal', folder: 'NHL94/Graphics/Pals', start: 0x00003060, end: 0x00003080 }, // OTW home
    { name: 'OTWv94.pal', folder: 'NHL94/Graphics/Pals', start: 0x00003080, end: 0x000030A0 }, // OTW visitor
    { name: 'PHIh.pal', folder: 'NHL94/Graphics/Pals', start: 0x00003354, end: 0x00003374 }, // PHI home
    { name: 'PHIv.pal', folder: 'NHL94/Graphics/Pals', start: 0x00003374, end: 0x00003394 }, // PHI visitor
    { name: 'PITh.pal', folder: 'NHL94/Graphics/Pals', start: 0x00003652, end: 0x00003672 }, // PIT home
    { name: 'PITv.pal', folder: 'NHL94/Graphics/Pals', start: 0x00003672, end: 0x00003692 }, // PIT visitor
    { name: 'QUEh.pal', folder: 'NHL94/Graphics/Pals', start: 0x00003948, end: 0x00003968 }, // QUE home
    { name: 'QUEv.pal', folder: 'NHL94/Graphics/Pals', start: 0x00003968, end: 0x00003988 }, // QUE visitor
    { name: 'SJh.pal', folder: 'NHL94/Graphics/Pals', start: 0x00003C4E, end: 0x00003C6E }, // SJ home
    { name: 'SJv.pal', folder: 'NHL94/Graphics/Pals', start: 0x00003C6E, end: 0x00003C8E }, // SJ visitor
    { name: 'STLh94.pal', folder: 'NHL94/Graphics/Pals', start: 0x00003F3C, end: 0x00003F5C }, // STL home
    { name: 'STLv.pal', folder: 'NHL94/Graphics/Pals', start: 0x00003F5C, end: 0x00003F7C }, // STL visitor
    { name: 'TBYh.pal', folder: 'NHL94/Graphics/Pals', start: 0x00004222, end: 0x00004242 }, // TB home
    { name: 'TBYv.pal', folder: 'NHL94/Graphics/Pals', start: 0x00004242, end: 0x00004262 }, // TB visitor
    { name: 'TORh.pal', folder: 'NHL94/Graphics/Pals', start: 0x00004524, end: 0x00004544 }, // TOR home
    { name: 'TORv.pal', folder: 'NHL94/Graphics/Pals', start: 0x00004544, end: 0x00004564 }, // TOR visitor
    { name: 'VANh94.pal', folder: 'NHL94/Graphics/Pals', start: 0x00004828, end: 0x00004848 }, // VAN home
    { name: 'VANv.pal', folder: 'NHL94/Graphics/Pals', start: 0x00004848, end: 0x00004868 }, // VAN visitor
    { name: 'WPGh.pal', folder: 'NHL94/Graphics/Pals', start: 0x00004B16, end: 0x00004B36 }, // WPG home
    { name: 'WPGv.pal', folder: 'NHL94/Graphics/Pals', start: 0x00004B36, end: 0x00004B56 }, // WPG visitor
    { name: 'WSHh.pal', folder: 'NHL94/Graphics/Pals', start: 0x00004E08, end: 0x00004E28 }, // WSH home
    { name: 'WSHv.pal', folder: 'NHL94/Graphics/Pals', start: 0x00004E28, end: 0x00004E48 }, // WSH visitor
    { name: 'FLAh.pal', folder: 'NHL94/Graphics/Pals', start: 0x000050F2, end: 0x00005112 }, // FLA home
    { name: 'FLAv.pal', folder: 'NHL94/Graphics/Pals', start: 0x00005112, end: 0x00005132 }, // FLA visitor
    { name: 'ANHh.pal', folder: 'NHL94/Graphics/Pals', start: 0x0000533C, end: 0x0000535C }, // ANH home
    { name: 'ANHv.pal', folder: 'NHL94/Graphics/Pals', start: 0x0000535C, end: 0x0000537C }, // ANH visitor
    // { name: 'Hockey.snd', folder: 'NHL94/Sound', start: 0x0000F4C8, end: 0x00024214 },
    // NHL 94 $1AD90-$F66ED, the incbins of src/sound94.asm ($1AD90-$4B5BF) and src/graphics94.asm: one slice per IDA label (the 92 / 93 file name where the asset
    // lines up, else the label), contiguous, end exclusive. Labels IDA made from constants or from data read as code are not slice
    // boundaries (see graphics94.asm). Replaces the 94 draft entries $4B7A0-$C0D12 (unknown6, unknown7, unknown9 broken; logos overlapping).
    { name: 'z80_snd_drv94.bin', folder: 'NHL94/Sound', start: 0x0001AD90, end: 0x0001B01C }, // unk_1AD90
    { name: 'pcm_sample_table.bin', folder: 'NHL94/Sound', start: 0x0001B01C, end: 0x0002C248 }, // unk_1B01C
    { name: 'fm_instrument_patches.bin', folder: 'NHL94/Sound', start: 0x0002C248, end: 0x0002C648 }, // unk_2C248
    { name: 'MusicTrackPointerTable.bin', folder: 'NHL94/Sound', start: 0x0002C648, end: 0x0002C708 }, // unk_2C648
    { name: 'SongPointerTable.bin', folder: 'NHL94/Sound', start: 0x0002C708, end: 0x0002CEF2 }, // off_2C708
    { name: 'SongStreams.bin', folder: 'NHL94/Sound', start: 0x0002CEF2, end: 0x0004B5C0 }, // unk_2CEF2
    { name: 'ScoutTextScript.bin', folder: 'NHL94/Text', start: 0x0004B5C0, end: 0x0004B7A0 }, // unk_4B5C0
    { name: 'GameSetUp94-1.map.jim', folder: 'NHL94/Graphics', start: 0x0004B7A0, end: 0x0004DEEE }, // unk_4B7A0
    { name: 'GameSetUp94-2.map.jim', folder: 'NHL94/Graphics', start: 0x0004DEEE, end: 0x0004E45C }, // unk_4DEEE
    { name: 'Title94-1.map.jim', folder: 'NHL94/Graphics', start: 0x0004E45C, end: 0x00052DAA }, // TitleScreenImg
    { name: 'Title94-2.map.jim', folder: 'NHL94/Graphics', start: 0x00052DAA, end: 0x0005338C }, // NHLShieldImg
    { name: 'Title94-3.map.jim', folder: 'NHL94/Graphics', start: 0x0005338C, end: 0x0005394E }, // PAlogoImg
    { name: 'Title94-4.map.jim', folder: 'NHL94/Graphics', start: 0x0005394E, end: 0x00054E24 }, // TitleImg
    { name: 'Scouting94.map.jim', folder: 'NHL94/Graphics', start: 0x00054E24, end: 0x00055B7E }, // unk_54E24
    { name: 'Framer.map.jim', folder: 'NHL94/Graphics', start: 0x00055B7E, end: 0x00055BF6 }, // framermap
    { name: 'FaceOff.map.jim', folder: 'NHL94/Graphics', start: 0x00055BF6, end: 0x0005605A }, // FaceOffMap
    { name: 'IceRink94.map.jim', folder: 'NHL94/Graphics', start: 0x0005605A, end: 0x0005C408 }, // Rinktilelist
    { name: 'Refs.map.jim', folder: 'NHL94/Graphics', start: 0x0005C408, end: 0x0005CF64 }, // RefsMap
    { name: 'Refs2.map.jim', folder: 'NHL94/Graphics', start: 0x0005CF64, end: 0x0005DE7A }, // unk_5CF64
    { name: 'Sprites.bin', folder: 'NHL94/Graphics', start: 0x0005DE7A, end: 0x0005DE84 }, // off_5DE7A
    { name: 'Spritetiles.bin', folder: 'NHL94/Graphics', start: 0x0005DE84, end: 0x0009E724 }, // Spritetiles
    { name: 'frameSprData.bin', folder: 'NHL94/Graphics', start: 0x0009E724, end: 0x000A44C8 }, // frameSprData
    { name: 'Hotlist.bin', folder: 'NHL94/Graphics', start: 0x000A44C8, end: 0x000A4B54 }, // Hotlist
    { name: 'Crowd.anim', folder: 'NHL94/Graphics', start: 0x000A4B54, end: 0x000A78AE }, // CrowdFrameList
    { name: 'FaceOff.anim', folder: 'NHL94/Graphics', start: 0x000A78AE, end: 0x000A8922 }, // unk_A78AE
    { name: 'Zam.anim', folder: 'NHL94/Graphics', start: 0x000A8922, end: 0x000A9A10 }, // ZamFrameList
    { name: 'BigFont94.map.jim', folder: 'NHL94/Graphics', start: 0x000A9A10, end: 0x000AAC52 }, // unk_A9A10
    { name: 'SmallFont.map.jim', folder: 'NHL94/Graphics', start: 0x000AAC52, end: 0x000AB920 }, // unk_AAC52
    { name: 'EnergyBar.map.jim', folder: 'NHL94/Graphics', start: 0x000AB920, end: 0x000ABA14 }, // unk_AB920
    { name: 'TeamBlocks.map.jim', folder: 'NHL94/Graphics', start: 0x000ABA14, end: 0x000AFE12 }, // unk_ABA14
    { name: 'TeamBlocks94.map.jim', folder: 'NHL94/Graphics', start: 0x000AFE12, end: 0x000B3530 }, // unk_AFE12
    { name: 'EASN.map.jim', folder: 'NHL94/Graphics', start: 0x000B3530, end: 0x000B3640 }, // unk_B3530
    { name: 'Arrows.map.jim', folder: 'NHL94/Graphics', start: 0x000B3640, end: 0x000B389C }, // unk_B3640
    { name: 'RonBarr.map.jim', folder: 'NHL94/Graphics', start: 0x000B389C, end: 0x000B3E74 }, // unk_B389C
    { name: 'Scores.map.jim', folder: 'NHL94/Graphics', start: 0x000B3E74, end: 0x000B425A }, // unk_B3E74
    { name: 'EASportsMap.bin', folder: 'NHL94/Graphics', start: 0x000B425A, end: 0x000B5180 }, // unk_B425A
    { name: 'IceRink94Reverse.map.jim', folder: 'NHL94/Graphics', start: 0x000B5180, end: 0x000BB4EE }, // RevRinkTilelist
    { name: 'ReplayOptions.map.jim', folder: 'NHL94/Graphics', start: 0x000BB4EE, end: 0x000BC05C }, // unk_BB4EE
    { name: 'PauseScreen.map.jim', folder: 'NHL94/Graphics', start: 0x000BC05C, end: 0x000BE26A }, // unk_BC05C
    { name: 'SmallFont94.map.jim', folder: 'NHL94/Graphics', start: 0x000BE26A, end: 0x000BEFB8 }, // unk_BE26A
    { name: 'GameSetupBkgd1.map.jim', folder: 'NHL94/Graphics', start: 0x000BEFB8, end: 0x000BF542 }, // unk_BEFB8
    { name: 'GameSetupBkgd2.map.jim', folder: 'NHL94/Graphics', start: 0x000BF542, end: 0x000BF702 }, // unk_BF542
    { name: 'GameSetupLogoBorder.map.jim', folder: 'NHL94/Graphics', start: 0x000BF702, end: 0x000BF8D0 }, // unk_BF702
    { name: 'logoANA.map.jim', folder: 'NHL94/Graphics', start: 0x000BF8D0, end: 0x000BFD66 }, // logoANA
    { name: 'logoBOS.map.jim', folder: 'NHL94/Graphics', start: 0x000BFD66, end: 0x000C00BC }, // logoBOS
    { name: 'logoBUF.map.jim', folder: 'NHL94/Graphics', start: 0x000C00BC, end: 0x000C0412 }, // logoBUF
    { name: 'logoCGY.map.jim', folder: 'NHL94/Graphics', start: 0x000C0412, end: 0x000C08A8 }, // logoCGY
    { name: 'logoCHI.map.jim', folder: 'NHL94/Graphics', start: 0x000C08A8, end: 0x000C0CDE }, // logoCHI
    { name: 'logoDET.map.jim', folder: 'NHL94/Graphics', start: 0x000C0CDE, end: 0x000C1034 }, // logoDET
    { name: 'logoEDM.map.jim', folder: 'NHL94/Graphics', start: 0x000C1034, end: 0x000C142A }, // logoEDM
    { name: 'logoFLA.map.jim', folder: 'NHL94/Graphics', start: 0x000C142A, end: 0x000C1900 }, // logoFLA
    { name: 'logoHFD.map.jim', folder: 'NHL94/Graphics', start: 0x000C1900, end: 0x000C1B96 }, // logoHFD
    { name: 'logoNYI.map.jim', folder: 'NHL94/Graphics', start: 0x000C1B96, end: 0x000C1FEC }, // logoNYI
    { name: 'logoLA.map.jim', folder: 'NHL94/Graphics', start: 0x000C1FEC, end: 0x000C2362 }, // logoLA
    { name: 'logoDAL.map.jim', folder: 'NHL94/Graphics', start: 0x000C2362, end: 0x000C2638 }, // logoDAL
    { name: 'logoMTL.map.jim', folder: 'NHL94/Graphics', start: 0x000C2638, end: 0x000C29AE }, // logoMTL
    { name: 'logoNJ.map.jim', folder: 'NHL94/Graphics', start: 0x000C29AE, end: 0x000C2E64 }, // logoNJ
    { name: 'logoNYR.map.jim', folder: 'NHL94/Graphics', start: 0x000C2E64, end: 0x000C333A }, // logoNYR
    { name: 'logoOTW.map.jim', folder: 'NHL94/Graphics', start: 0x000C333A, end: 0x000C3750 }, // logoOTW
    { name: 'logoPHI.map.jim', folder: 'NHL94/Graphics', start: 0x000C3750, end: 0x000C3B06 }, // logoPHI
    { name: 'logoPIT.map.jim', folder: 'NHL94/Graphics', start: 0x000C3B06, end: 0x000C3E7C }, // logoPIT
    { name: 'logoQUE.map.jim', folder: 'NHL94/Graphics', start: 0x000C3E7C, end: 0x000C41D2 }, // logoQUE
    { name: 'logoSJ.map.jim', folder: 'NHL94/Graphics', start: 0x000C41D2, end: 0x000C4608 }, // logoSJ
    { name: 'logoSTL.map.jim', folder: 'NHL94/Graphics', start: 0x000C4608, end: 0x000C49DE }, // logoSTL
    { name: 'logoTB.map.jim', folder: 'NHL94/Graphics', start: 0x000C49DE, end: 0x000C4DF4 }, // logoTB
    { name: 'logoTOR.map.jim', folder: 'NHL94/Graphics', start: 0x000C4DF4, end: 0x000C514A }, // logoTOR
    { name: 'logoVAN.map.jim', folder: 'NHL94/Graphics', start: 0x000C514A, end: 0x000C5560 }, // logoVAN
    { name: 'logoWSH.map.jim', folder: 'NHL94/Graphics', start: 0x000C5560, end: 0x000C57D6 }, // logoWSH
    { name: 'logoWPG.map.jim', folder: 'NHL94/Graphics', start: 0x000C57D6, end: 0x000C5C4C }, // logoWPG
    { name: 'logoASE.map.jim', folder: 'NHL94/Graphics', start: 0x000C5C4C, end: 0x000C6022 }, // logoASE
    { name: 'logoASW.map.jim', folder: 'NHL94/Graphics', start: 0x000C6022, end: 0x000C63F8 }, // logoASW
    { name: 'PicturePalette.bin', folder: 'NHL94/Graphics', start: 0x000C63F8, end: 0x000C682E }, // unk_C63F8
    { name: 'NoPicSkater1.bin', folder: 'NHL94/Graphics', start: 0x000C682E, end: 0x000C6B98 }, // unk_C682E
    { name: 'NoPicSkater2.bin', folder: 'NHL94/Graphics', start: 0x000C6B98, end: 0x000C6F02 }, // unk_C6B98
    { name: 'NoPicGoalie1.bin', folder: 'NHL94/Graphics', start: 0x000C6F02, end: 0x000C726C }, // unk_C6F02
    { name: 'PlayerPictures.bin', folder: 'NHL94/Graphics', start: 0x000C726C, end: 0x000E9A80 }, // unk_C726C
    { name: 'CornerLogoMap.bin', folder: 'NHL94/Graphics', start: 0x000E9A80, end: 0x000E9ED6 }, // unk_E9A80
    { name: 'ArenaGfxBank.bin', folder: 'NHL94/Graphics', start: 0x000E9ED6, end: 0x000F3098 }, // unk_E9ED6
    { name: 'PlayoffSprite.bin', folder: 'NHL94/Graphics', start: 0x000F3098, end: 0x000F5338 }, // unk_F3098
    { name: 'HiScoreImg.bin', folder: 'NHL94/Graphics', start: 0x000F5338, end: 0x000F5AF6 }, // HiScoreImg
    { name: 'HotIconMap.bin', folder: 'NHL94/Graphics', start: 0x000F5AF6, end: 0x000F5D1C }, // unk_F5AF6
    { name: 'ColdIconMap.bin', folder: 'NHL94/Graphics', start: 0x000F5D1C, end: 0x000F600E }, // unk_F5D1C
    { name: 'revframetbl.bin', folder: 'NHL94/Graphics', start: 0x000F600E, end: 0x000F66EE }, // revframetbl

    // { name: 'Title1.map.jim', folder: 'NHL94/Graphics', start: 0x00025642, end: 0x0002ADF0 },
    // { name: 'Title2.map.jim', folder: 'NHL94/Graphics', start: 0x0002ADF0, end: 0x0002C0FE },
    // { name: 'NHLSpin.map.jim', folder: 'NHL94/Graphics', start: 0x0002C0FE, end: 0x0002E9EC },
    // { name: 'Puck.anim', folder: 'NHL94/Graphics', start: 0x0002E9EC, end: 0x0002F262 },
    // { name: 'Scouting.map.jim', folder: 'NHL94/Graphics', start: 0x0002F262, end: 0x00033590 },
    // { name: 'Framer.map.jim', folder: 'NHL94/Graphics', start: 0x00033590, end: 0x000336B0 },
    // { name: 'FaceOff.map.jim', folder: 'NHL94/Graphics', start: 0x000336B0, end: 0x00033AAE },
    // { name: 'IceRink.map.jim', folder: 'NHL94/Graphics', start: 0x00033AAE, end: 0x0003A3DC },
    // { name: 'Refs.map.jim', folder: 'NHL94/Graphics', start: 0x0003A3DC, end: 0x0003D5EE },
    // { name: 'Sprites.anim', folder: 'NHL94/Graphics', start: 0x0003D5EE, end: 0x0007216C },
    // { name: 'Crowd.anim', folder: 'NHL94/Graphics', start: 0x0007216C, end: 0x00075790 },
    // { name: 'FaceOff.anim', folder: 'NHL94/Graphics', start: 0x00075790, end: 0x0007716C },
    // { name: 'Zam.anim', folder: 'NHL94/Graphics', start: 0x0007716C, end: 0x000778D2 },
    // { name: 'BigFont.map.jim', folder: 'NHL94/Graphics', start: 0x000778D2, end: 0x00078C20 },
    // { name: 'SmallFont.map.jim', folder: 'NHL94/Graphics', start: 0x00078C20, end: 0x00079C2E },
    // { name: 'TeamBlocks.map.jim', folder: 'NHL94/Graphics', start: 0x00079C2E, end: 0x0007E79C },
    // { name: 'Arrows.map.jim', folder: 'NHL94/Graphics', start: 0x0007E79C, end: 0x0007EB12 },
    // { name: 'Stanley.map.jim', folder: 'NHL94/Graphics', start: 0x0007EB12, end: 0x0007FC20 },
    // { name: 'EASN.map.jim', folder: 'NHL94/Graphics', start: 0x0007FC20, end: 0x0007FE8A }
];

// Expected CRC32 of lst/nhl94.bin
const EXPECTED_CRC32 = 0x9438F5DD;

async function verifyCRC32(filePath) {
    try {
        const data = await fs.readFile(filePath);
        const calculatedCRC = crc32.buf(data) >>> 0; // Convert to unsigned 32-bit integer
        console.log('Caclulated CRC32:', calculatedCRC, EXPECTED_CRC32);
        return calculatedCRC === EXPECTED_CRC32;
    } catch (error) {
        console.error(`Error reading ROM file for CRC32 check: ${error.message}`);
        return false;
    }
}

async function extractAssets(romPath, options = {}) {
    // Set default options
    const extractOptions = {
        outputDir: options.outputDir || 'Extracted',
        verbose: options.verbose || false
    };
    
    try {
        // Verify CRC32
        const isValid = await verifyCRC32(romPath);
        if (!isValid) {
            console.error(`CRC32 checksum mismatch. Expected ${EXPECTED_CRC32.toString(16).toUpperCase()}. Aborting extraction.`);
            return;
        }

        // Read the ROM file
        const romData = await fs.readFile(romPath);

        // Create base Extracted directory
        const baseDir = extractOptions.outputDir;
        await fs.mkdir(baseDir, { recursive: true });

        // Extract each asset
        for (const asset of assets) {
            // Create output directory
            const outputDir = path.join(baseDir, asset.folder);
            await fs.mkdir(outputDir, { recursive: true });

            // Extract data
            const assetData = romData.slice(asset.start, asset.end);

            // Write to file
            const outputPath = path.join(outputDir, asset.name);
            await fs.writeFile(outputPath, assetData);
            
            if (extractOptions.verbose) {
                console.log(`Extracted ${asset.name} (${assetData.length} bytes) from offset 0x${asset.start.toString(16)} to 0x${asset.end.toString(16)}`);
                console.log(`Saved to ${outputPath}`);
            } else {
                console.log(`Extracted ${asset.name} to ${outputPath}`);
            }
        }

        console.log('Extraction completed successfully.');
        console.log(`Extracted ${assets.length} assets from NHL 94 ROM.`);
    } catch (error) {
        console.error(`Error during extraction: ${error.message}`);
    }
}

// Parse command line arguments
function parseArgs() {
    const args = process.argv.slice(2);
    const options = {
        romFile: null,
        outputDir: 'Extracted',
        verbose: false
    };

    for (let i = 0; i < args.length; i++) {
        const arg = args[i];
        
        if (arg === '-h' || arg === '--help') {
            displayHelp();
            process.exit(0);
        } else if (arg === '-v' || arg === '--verbose') {
            options.verbose = true;
        } else if (arg === '-o' || arg === '--output') {
            if (i + 1 < args.length) {
                options.outputDir = args[++i];
            } else {
                console.error('Error: Output directory not specified');
                displayHelp();
                process.exit(1);
            }
        } else if (!options.romFile) {
            options.romFile = arg;
        }
    }

    return options;
}

// Display help information
function displayHelp() {
    console.log(`
NHL 92 Asset Extractor
======================

This script extracts assets from NHL Hockey (1991/1992) ROM files.

Usage: node extractAssets92.js [options] <rom_file_path>

Options:
  -h, --help              Display this help message
  -v, --verbose           Display detailed extraction information
  -o, --output <dir>      Specify output directory (default: 'Extracted')

Notes:
  - This script extracts all known assets from the NHL 92 ROM
  - ROM checksums are verified to ensure correct ROM is used

Examples:
  node extractAssets92.js nhl94retail.bin
  node extractAssets92.js --verbose --output NHL94Assets nhl94retail.bin
    `);
}

// Main execution
const options = parseArgs();

if (!options.romFile) {
    console.error('Error: ROM file path not provided');
    displayHelp();
    process.exit(1);
}

console.log(`Extracting assets from: ${options.romFile}`);
console.log(`Output directory: ${options.outputDir}`);
if (options.verbose) {
    console.log('Verbose mode enabled');
}

extractAssets(options.romFile, {
    outputDir: options.outputDir,
    verbose: options.verbose
});