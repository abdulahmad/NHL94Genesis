;	*** ANONYMIZED: the player names and team nicknames are placeholders. ***
;	Players are P001 ... P684, nicknames N01 ... N26. The real ones are NHLPA / NHL licensed
;	data and are not in this repository.

;	Each Player row and each nickname String has a placeholder of the same length as the
;	real text (the Player macro writes the row length, so it must not change). The ratings
;	after a name are unchanged.

;	This file does not assemble into the real game by itself and is not included directly:
;	it needs the original ROM.

;	tools/extractAssets94.js reads the names from your ROM into Extracted/PlayerNames.txt
;	and Extracted/TeamNicknames.txt (one per line, in the order they appear below).

;	tools/build.js (the 'names' step) copies this file to output/obj/teamdata94.asm with the
;	real names put back, and nhl94.asm includes that copy.

;	Keep the placeholder lengths when editing a name or adding a player.
;
;	Team data. TeamList points to one record per team, the two All-Star teams included. A record
;	holds the players, colors, name, lines, scouting report and scoring odds. The playoff seeds and
;	the credits come after the teams.

null								;92 null: a zero long, the tile pointer when there is nothing to draw
									;(no tiles). Not part of TeamList
	dc.l	0

TeamList							;List Pointer Table Start. Team number = index (ANH 0 ... WPG 25, ASE 26,
									;ASW 27)
	dc.l	Anaheim					;0 ANH
	dc.l	Boston					;1 BOS
	dc.l	Buffalo					;2 BUF
	dc.l	Calgary					;3 CGY
	dc.l	Chicago					;4 CHI
	dc.l	Dallas					;5 DAL
	dc.l	Detroit					;6 DET
	dc.l	Edmonton				;7 EDM
	dc.l	Florida					;8 FLA
	dc.l	Hartford				;9 HFD
	dc.l	LosAngeles				;10 LA
	dc.l	Montreal				;11 MTL
	dc.l	NewJersey				;12 NJ
	dc.l	NewYorkI				;13 NYI
	dc.l	NewYorkR				;14 NYR
	dc.l	Ottawa					;15 OTW
	dc.l	Philadelphia			;16 PHI
	dc.l	Pittsburgh				;17 PIT
	dc.l	Quebec					;18 QUE
	dc.l	SanJose					;19 SJ
	dc.l	StLouis					;20 STL
	dc.l	TampaBay				;21 TB
	dc.l	Toronto					;22 TOR
	dc.l	Vancouver				;23 VAN
	dc.l	Washington				;24 WSH
	dc.l	Winnipeg				;25 WPG
	dc.l	AllStarsEast			;26 ASE
	dc.l	AllStarsWest			;27 ASW

NumofTeams	=	(*-TeamList)/4		;number of teams in TeamList (26)
	IF NumofTeams<>NumTeams
		inform	3,"TeamList needs one entry per team"
	ENDIF

;------------------------
; Team block: 6 offset words (in equals.inc), .pad home and visitor palettes (16 colours each, incbin
; <team>h.pal / <team>v.pal; files with 94 in the name have new colours)
; .sr (4 bytes of bonuses), .godds (starting goalie weights), .ls 8 lines of 8 player numbers (1 = first
; .pld entry), .pld players ended by an empty String, then 4 Strings: city, abbreviation, nickname, arena.
; .ls lines: 1 = the line used when line changes are Off or Auto (no line changes, in place of Sc1), then
; 2 Sc1, 3 Sc2, 4 Chk, 5 PP1, 6 PP2, 7 PK1, 8 PK2. InitTeamStructure copies 7 of them to tmlines.
;------------------------
; .sr: 4 bytes. byte 0: scoring odds of simulated games (SetScore): bits 4-6 = offense
; row, bits 0-2 = defense row of the weights table; byte 1: high nibble = penalty kill deficit, low nibble =
; power play bonus; byte 2: high nibble = home bonus, low nibble = visitor bonus (negated); byte 3: high
; nibble = forward count (GetForwardCount). Field names srodds .. srforwards in equals.inc
;q - scoring odds offense row (bits 4-6)
;r - scoring odds defense row (bits 0-2)
;e - penalty kill deficit
;b - power play bonus

;h - home bonus
;v - visitor bonus
;x - not read
;x - not read
; Player ratings (Player macro: name, then 16 nibbles unwl,sodp,chga,eytm)
;u - uniform # x10
;n - uniform # x1
;w - weight
;l - leg power
;s - speed
;o - offensive awareness
;d - defensive awareness
;p - shot power / NA for goalie
;c - checking strength / NA
;h - shooting hand / glove hand
;g - stickhandling / glove left saves
;a - shooting accuracy / glove right saves
;e - endurance / stick right saves
;y - shot/pass decision / stick left saves
;t - passing accuracy / consistency
;m - aggressiveness (PIM) / NA
;------------------------

AllStarsEast						;ASE
.0									;team data start: offsets to the parts
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad								;home and visitor palettes
	incbin	..\Extracted\NHL94\Graphics\Pals\ASEh.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\ASEv.pal
.sr									;team ratings (qreb,hvxx)
;		qreb,hvxx
	dc.w	$7720,$00E8
.godds								;starting goalie weights, 4 nibbles (PickStartingGoalie)
	dc.b	203,192
.ls									;8 lines of 8 player numbers
;			-G,LD,RD,LW,-C,RW,XA,00
	dc.b	01,19,18,07,04,16,09,00	;line 1 NLC (no line changes)
	dc.b	01,19,18,07,04,16,10,00	;line 2 Sc1
	dc.b	01,22,20,11,10,17,07,00	;line 3 Sc2
	dc.b	01,23,24,05,12,14,07,00	;line 4 Chk
	dc.b	01,19,22,07,04,16,09,00	;line 5 PP1
	dc.b	01,18,21,08,09,17,07,00	;line 6 PP2
	dc.b	01,19,23,13,05,06,15,00	;line 7 PK1
	dc.b	01,24,25,15,06,05,13,00	;line 8 PK2
.pld								;player data: one player per row, ended by an empty String
;										unwl,sodp,chga,eytm
	Player	'P001_______',				3366,4446,0100,5566
	Player	'P002______',				3175,4555,0000,4455
	Player	'P003________',				35A4,4554,0000,4444
	Player	'P004_________',			66A5,4644,3366,6062
	Player	'P005________',				11A5,4443,5453,4053
	Player	'P006_______',				1094,4444,4444,4143
	Player	'P007______',				1275,4653,3154,5061
	Player	'P008_____',				1964,4544,2045,5252
	Player	'P009__________',			7894,4534,3445,5141
	Player	'P010__________',			1655,4643,3354,6052
	Player	'P011_________',			25B3,4533,3644,5344
	Player	'P012________',				68A5,4433,4453,4142
	Player	'P013________',				1364,6433,2044,4232
	Player	'P014________',				2275,5445,2353,5552
	Player	'P015________',				2392,2544,3735,4134
	Player	'P016____________',			8976,6634,2455,4452
	Player	'P017_______',				0865,4534,3445,4143
	Player	'P018________',				55A4,3454,3242,5143
	Player	'P019_______',				77A5,4465,6055,6252
	Player	'P020________',				0266,3444,2651,5252
	Player	'P021__________',			2884,4444,2442,4142
	Player	'P022______',				34B4,4446,4642,4444
	Player	'P023_________',			04B4,4344,5642,5043
	Player	'P024___________',			03A5,4454,4442,5133
	Player	'P025_______',				2685,4344,3641,4442
	dc.w	2						;end of player data: empty String
.tn									;city
	String	'All Stars East'
.ta									;abbreviation
	String	'ASE'
.tm									;nickname
	dc.w	2						;empty String
.ar									;arena
	String	'Madison Square Garden'

AllStarsWest						;ASW
.0									;team data start: offsets to the parts
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad								;home and visitor palettes
	incbin	..\Extracted\NHL94\Graphics\Pals\ASWh.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\ASWv.pal
.sr									;team ratings (qreb,hvxx)
	dc.w	$7720,$00E8
.godds								;starting goalie weights
	dc.b	237,144
.ls									;8 lines of 8 player numbers
	dc.b	01,20,22,11,04,15,14,00
	dc.b	01,24,22,11,04,15,13,00
	dc.b	01,20,23,14,06,13,04,00
	dc.b	01,18,21,10,08,12,04,00
	dc.b	01,20,19,11,09,13,04,00
	dc.b	01,18,22,06,04,15,09,00
	dc.b	01,25,21,08,12,09,17,00
	dc.b	01,23,24,09,17,08,12,00
.pld								;player data: one player per row, ended by an empty String
	Player	'P026______',				3066,4665,0000,6655
	Player	'P027_________',			3264,4444,0000,4344
	Player	'P028________',				2964,4664,0000,4444
	Player	'P029_________',			1966,5644,1155,6152
	Player	'P030_______',				0975,5445,2452,5243
	Player	'P031__________',			2745,5445,2355,5253
	Player	'P032_________',			2344,3434,3335,4233
	Player	'P033________',				9345,4554,4444,6043
	Player	'P034_________',			9946,4542,2262,6060
	Player	'P035________',				1174,4544,4845,5134
	Player	'P036__________',			2074,4534,2456,5243
	Player	'P037__________',			1435,5454,4743,6133
	Player	'P038______',				1694,4536,3353,4432
	Player	'P039______',				1055,6544,2054,4442
	Player	'P040_________',			1365,6534,3345,5442
	Player	'P041_______',				1874,4323,1342,4531
	Player	'P042______',				1784,3444,2143,4132
	Player	'P043______',				2275,4454,4642,5243
	Player	'P044______',				2193,3445,2343,5142
	Player	'P045_______',				7796,5434,2461,5153
	Player	'P046_________',			0774,4465,4751,6245
	Player	'P047________',				0666,5433,2462,4062
	Player	'P048_______',				2494,4355,4A41,5434
	Player	'P049_______',				05B4,4344,4641,5244
	Player	'P050__________',			0394,3444,3641,4234
	dc.w	2						;end of player data: empty String
.tn									;city
	String	'All Stars West'
.ta									;abbreviation
	String	'ASW'
.tm									;nickname
	dc.w	2
.ar									;arena
	String	'Madison Square Garden'

Boston								;BOS
.0									;team data start: offsets to the parts
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad								;home and visitor palettes
	incbin	..\Extracted\NHL94\Graphics\Pals\BOSh.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\BOSv.pal
.sr									;team ratings (qreb,hvxx)
	dc.w	$4121,$21F8
.godds								;starting goalie weights
	dc.b	180,0
.ls									;8 lines of 8 player numbers
	dc.b	01,19,18,07,03,12,08,00
	dc.b	01,19,18,08,03,12,05,00
	dc.b	01,20,21,07,05,13,03,00
	dc.b	01,22,23,09,04,14,03,00
	dc.b	01,20,18,08,03,12,05,00
	dc.b	01,22,21,07,05,13,03,00
	dc.b	01,19,18,09,04,03,06,00
	dc.b	01,20,21,03,06,09,04,00
.pld								;player data: one player per row, ended by an empty String
	Player	'P051_____',				3544,4224,0000,4343
	Player	'P052_____',				3963,4553,0000,4343
	Player	'P053______',				1275,4653,3154,5061
	Player	'P054_______',				1974,3343,4433,4142
	Player	'P055____________',			38A4,4334,2643,3332
	Player	'P056______',				2143,4343,3033,3332
	Player	'P057______',				4954,4434,2043,4041
	Player	'P058_____________',		1064,4423,2043,4241
	Player	'P059_____',				1792,3333,1424,4420
	Player	'P060______________',		1364,4222,1233,2431
	Player	'P061________',				4263,3132,3632,2534
	Player	'P062_____',				08A4,4544,4945,5344
	Player	'P063_________',			2763,3333,3732,4533
	Player	'P064__________',			2363,3333,3333,3531
	Player	'P065______',				1863,3223,2533,2322
	Player	'P066________',				2991,1211,2924,1315
	Player	'P067________',				1683,4333,2533,2421
	Player	'P068_______',				77A5,4465,6055,6252
	Player	'P069_______',				3244,4344,4441,4142
	Player	'P070_______',				2685,4344,3641,4442
	Player	'P071______',				3492,2242,3322,4523
	Player	'P072_______',				2885,4234,4931,3333
	Player	'P073__________',			1473,2231,3423,3023
	Player	'P074___________',			06B3,3222,4823,2324
	Player	'P075______',				36A2,1221,2820,2324
	dc.w	2						;end of player data: empty String
.tn									;city
	String	'Boston'
.ta									;abbreviation
	String	'BOS'
.tm									;nickname
	String	'N01___'
.ar									;arena
	String	'Boston Garden'

Buffalo								;BUF
.0									;team data start: offsets to the parts
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad								;home and visitor palettes
	incbin	..\Extracted\NHL94\Graphics\Pals\BUFh.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\BUFv.pal
.sr									;team ratings (qreb,hvxx)
	dc.w	$6410,$21E8
.godds								;starting goalie weights
	dc.b	178,80
.ls									;8 lines of 8 player numbers
	dc.b	01,18,19,05,04,13,06,00
	dc.b	01,18,20,09,04,13,05,00
	dc.b	01,19,22,11,05,15,04,00
	dc.b	01,21,23,08,06,14,04,00
	dc.b	01,18,19,05,04,13,06,00
	dc.b	01,21,22,08,06,15,04,00
	dc.b	01,20,22,09,06,08,04,00
	dc.b	01,18,19,08,04,09,06,00
.pld								;player data: one player per row, ended by an empty String
	Player	'P076______',				3175,4555,0100,4455
	Player	'P077______',				3562,3332,0000,2222
	Player	'P078_________',			3943,3552,0000,2222
	Player	'P079__________',			1655,4643,3354,6052
	Player	'P080__________',			1065,4443,2051,3052
	Player	'P081_______',				2094,2353,4734,4233
	Player	'P082_______',				1462,2232,2623,2022
	Player	'P083______',				1981,5332,3622,3423
	Player	'P084________',				1374,3344,3134,3332
	Player	'P085____',					2792,2222,3A23,2514
	Player	'P086_____',				1264,4242,4432,4523
	Player	'P087___',					32A3,4111,3A22,1514
	Player	'P088____________',			8976,6634,2455,4452
	Player	'P089_________',			1863,3334,2723,3323
	Player	'P090__________',			2853,3333,2933,3523
	Player	'P091______',				29A2,2132,2322,3522
	Player	'P092___________',			1784,4231,3523,2522
	Player	'P093_______',				08A2,3342,3621,4133
	Player	'P094________',				0754,4343,3640,4033
	Player	'P095___________',			42A3,3343,4431,3032
	Player	'P096______',				4182,2242,1412,3232
	Player	'P097_________',			0394,3231,3C10,2323
	Player	'P098_________',			3491,2231,3B11,2225
	Player	'P099________',				24A3,2212,3921,1124
	Player	'P100________',				0692,3212,3622,1424
	dc.w	2						;end of player data: empty String
.tn									;city
	String	'Buffalo'
.ta									;abbreviation
	String	'BUF'
.tm									;nickname
	String	'N02___'
.ar									;arena
	String	'Memorial Auditorium'

Calgary								;CGY
.0									;team data start: offsets to the parts
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad								;home and visitor palettes
	incbin	..\Extracted\NHL94\Graphics\Pals\CGYh.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\CGYv.pal
.sr									;team ratings (qreb,hvxx)
	dc.w	$4200,$00DA
.godds								;starting goalie weights
	dc.b	197,0
.ls									;8 lines of 8 player numbers
	dc.b	01,16,17,07,03,12,04,00
	dc.b	01,20,17,07,03,13,04,00
	dc.b	01,16,22,08,04,12,03,00
	dc.b	01,18,23,10,05,15,03,00
	dc.b	01,16,17,07,03,13,04,00
	dc.b	01,23,22,04,05,12,03,00
	dc.b	01,16,22,08,12,07,05,00
	dc.b	01,23,19,07,05,08,12,00
.pld								;player data: one player per row, ended by an empty String
	Player	'P101_______',				3043,4444,0000,4433
	Player	'P102______',				3542,3442,0000,2233
	Player	'P103__________',			2584,4434,3444,4322
	Player	'P104__________',			2664,4434,2444,3242
	Player	'P105_____',				29B4,3352,5734,4124
	Player	'P106___________',			3984,2242,4633,4434
	Player	'P107________',				1074,4544,4845,5134
	Player	'P108________',				2884,4343,1343,3431
	Player	'P109________',				15A3,3343,4632,4433
	Player	'P110__________',			1173,4232,2433,2321
	Player	'P111________',				1692,3112,2A11,1414
	Player	'P112__________',			1435,5454,4743,6133
	Player	'P113__________',			4265,4422,1054,3052
	Player	'P114__________',			2372,2313,2134,2220
	Player	'P115________',				2282,2212,3723,1324
	Player	'P116______',				2075,4454,4642,5243
	Player	'P117_______',				0284,4436,3541,5243
	Player	'P118___________',			3474,3222,3431,2332
	Player	'P119________',				1873,2242,3630,3133
	Player	'P120_______',				0394,4232,3621,3523
	Player	'P121________',				0793,3234,3941,3333
	Player	'P122______',				0472,3242,3331,3132
	Player	'P123___________',			0583,3143,3431,3523
	Player	'P124_____________',		21A2,3222,3822,3512
	Player	'P125______',				06A0,0100,1901,1404
	dc.w	2						;end of player data: empty String
.tn									;city
	String	'Calgary'
.ta									;abbreviation
	String	'CGY'
.tm									;nickname
	String	'N03___'
.ar									;arena
	String	'Olympic Saddledome'

Chicago								;CHI
.0									;team data start: offsets to the parts
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad								;home and visitor palettes
	incbin	..\Extracted\NHL94\Graphics\Pals\CHIh.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\CHIv.pal
.sr									;team ratings (qreb,hvxx)
	dc.w	$2010,$21F8
.godds								;starting goalie weights
	dc.b	228,0
.ls									;8 lines of 8 player numbers
	dc.b	01,19,18,07,03,12,05,00
	dc.b	01,19,18,07,03,12,04,00
	dc.b	01,20,21,09,04,14,03,00
	dc.b	01,22,24,10,05,13,03,00
	dc.b	01,19,18,07,03,12,04,00
	dc.b	01,20,21,04,05,14,03,00
	dc.b	01,19,18,05,12,03,13,00
	dc.b	01,21,23,03,13,05,12,00
.pld								;player data: one player per row, ended by an empty String
	Player	'P126______',				3066,4665,0000,6655
	Player	'P127_____',				2963,3332,0000,2233
	Player	'P128__________',			2745,5445,2355,5253
	Player	'P129___________',			2284,4343,4442,4243
	Player	'P130________',				1263,2453,4343,5133
	Player	'P131_______',				1984,3242,4331,3533
	Player	'P132_________',			1684,3332,2635,3312
	Player	'P133____________',			3282,2321,3623,3213
	Player	'P134________',				1472,2332,4633,3112
	Player	'P135___________',			2693,4334,2622,2213
	Player	'P136_______',				23B1,1021,3A11,2514
	Player	'P137________',				2874,4464,4444,6342
	Player	'P138_______',				3384,3353,4732,4534
	Player	'P139________',				1073,3334,3343,4533
	Player	'P140__________',			2583,3233,2331,3231
	Player	'P141______',				1774,4434,3233,4243
	Player	'P142_____',				4464,3322,2841,2024
	Player	'P143_________',			0774,4465,4751,6245
	Player	'P144_______',				05B4,4344,4641,5244
	Player	'P145___________',			0283,3242,4621,3215
	Player	'P146___________',			0692,2243,1321,3422
	Player	'P147______',				0392,2132,4620,4223
	Player	'P148_______',				0472,2232,3931,3433
	Player	'P149_______',				0853,3132,3431,3524
	Player	'P150________',				4792,2111,2520,1412
	dc.w	2						;end of player data: empty String
.tn									;city
	String	'Chicago'
.ta									;abbreviation
	String	'CHI'
.tm									;nickname
	String	'N04_______'
.ar									;arena
	String	'Chicago Stadium'

Detroit								;DET
.0									;team data start: offsets to the parts
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad								;home and visitor palettes
	incbin	..\Extracted\NHL94\Graphics\Pals\DETh.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\DETv.pal
.sr									;team ratings (qreb,hvxx)
	dc.w	$7321,$00F8
.godds								;starting goalie weights
	dc.b	212,0
.ls									;8 lines of 8 player numbers
	dc.b	01,19,18,04,03,13,08,00
	dc.b	01,21,25,11,03,13,04,00
	dc.b	01,18,23,08,04,14,03,00
	dc.b	01,19,20,09,05,15,03,00
	dc.b	01,18,20,08,03,13,15,00
	dc.b	01,19,21,15,04,14,03,00
	dc.b	01,19,23,08,04,03,05,00
	dc.b	01,21,25,05,03,08,04,00
.pld								;player data: one player per row, ended by an empty String
	Player	'P151_________',			3264,4444,0000,4344
	Player	'P152____________',			3763,3222,0000,3223
	Player	'P153_________',			1966,5644,1155,6152
	Player	'P154__________',			9175,4444,3254,4153
	Player	'P155________',				2844,4343,2033,4133
	Player	'P156__________',			2373,3332,2332,4021
	Player	'P157___________',			1354,3223,1233,3533
	Player	'P158_________',			2174,4443,2644,3342
	Player	'P159______',				1162,2332,4622,3123
	Player	'P160_________',			55B3,3343,1624,3124
	Player	'P161__________',			1762,2333,4633,3134
	Player	'P162__________',			2593,3333,3234,2130
	Player	'P163___________',			2255,4425,2355,4143
	Player	'P164________',				2662,2433,3334,3222
	Player	'P165_______',				24B4,3333,4A22,4235
	Player	'P166___________',			1543,3322,2324,2522
	Player	'P167______',				1472,2212,3722,1424
	Player	'P168_______',				7796,5434,2461,5153
	Player	'P169__________',			0394,3444,3641,4234
	Player	'P170_______',				3363,3344,3431,4233
	Player	'P171____________',			0554,3344,3441,4241
	Player	'P172_____',				0463,3343,3231,3031
	Player	'P173_______________',		1663,3243,4731,4233
	Player	'P174_________',			0883,3232,4421,3233
	Player	'P175__________',			0283,2242,4610,3133
	dc.w	2						;end of player data: empty String
.tn									;city
	String	'Detroit'
.ta									;abbreviation
	String	'DET'
.tm									;nickname
	String	'N05______'
.ar									;arena
	String	'Joe Louis Sports Arena'

Edmonton							;EDM
.0									;team data start: offsets to the parts
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad								;home and visitor palettes
	incbin	..\Extracted\NHL94\Graphics\Pals\EDMh.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\EDMv.pal
.sr									;team ratings (qreb,hvxx)
	dc.w	$1602,$12F8
.godds								;starting goalie weights
	dc.b	213,0
.ls									;8 lines of 8 player numbers
	dc.b	01,18,19,09,03,15,10,00
	dc.b	01,18,19,10,03,15,04,00
	dc.b	01,21,20,09,04,16,03,00
	dc.b	01,22,23,11,12,05,03,00
	dc.b	01,18,19,10,09,15,07,00
	dc.b	01,22,20,11,07,16,10,00
	dc.b	01,18,20,09,05,12,03,00
	dc.b	01,21,23,12,03,09,05,00
.pld								;player data: one player per row, ended by an empty String
	Player	'P176________',				3044,3334,0000,4454
	Player	'P177_______',				0122,3331,0000,1112
	Player	'P178_______',				3963,3343,3443,3132
	Player	'P179_____',				3473,4332,2433,3123
	Player	'P180___________',			1484,3242,4432,5223
	Player	'P181______',				1553,4333,3632,3332
	Player	'P182________',				2692,2322,2624,2512
	Player	'P183_______',				2093,3242,4820,3233
	Player	'P184_________',			0994,4343,4642,4234
	Player	'P185_________',			1883,3434,2345,3132
	Player	'P186_______',				0874,3333,2033,3230
	Player	'P187____________',			16A2,2232,4A13,3213
	Player	'P188__________',			0783,3223,2432,2422
	Player	'P189_________',			29C1,1212,3C14,1515
	Player	'P190______',				8575,5324,1355,4533
	Player	'P191__________',			2791,1333,4723,3324
	Player	'P192_______',				12B2,2212,1321,1223
	Player	'P193_______',				2494,4355,4A41,5434
	Player	'P194_________',			2194,3343,3242,4432
	Player	'P195_________',			1982,2343,3622,4234
	Player	'P196_______',				2594,3231,1431,3231
	Player	'P197_______',				06B3,3234,3421,4323
	Player	'P198___________',			22B3,3132,4630,2434
	Player	'P199________',				02A3,3313,3531,1233
	Player	'P200________',				3693,3223,2633,2523
	dc.w	2						;end of player data: empty String
.tn									;city
	String	'Edmonton'
.ta									;abbreviation
	String	'EDM'
.tm									;nickname
	String	'N06___'
.ar									;arena
	String	'Northlands Coliseum'

Hartford							;HFD
.0									;team data start: offsets to the parts
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad								;both palettes new
	incbin	..\Extracted\NHL94\Graphics\Pals\HFDh94.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\HFDv94.pal
.sr									;team ratings (qreb,hvxx)
	dc.w	$1702,$00F7
.godds								;starting goalie weights
	dc.b	163,96
.ls									;8 lines of 8 player numbers
	dc.b	01,19,20,09,04,14,05,00
	dc.b	01,19,25,09,04,14,05,00
	dc.b	01,24,20,11,05,15,04,00
	dc.b	01,21,23,10,06,16,04,00
	dc.b	01,19,20,09,04,14,06,00
	dc.b	01,21,22,10,05,06,04,00
	dc.b	01,24,20,16,15,09,04,00
	dc.b	01,19,25,09,04,16,15,00
.pld								;player data: one player per row, ended by an empty String
	Player	'P201______',				01A4,3224,0000,4444
	Player	'P202__________',			3132,3442,0000,1122
	Player	'P203____________',			4063,3113,0000,2222
	Player	'P204__________',			2173,3442,2034,4032
	Player	'P205______',				2563,3433,3334,4032
	Player	'P206___________',			3654,3323,2232,3132
	Player	'P207_______',				3853,3342,2233,3432
	Player	'P208_____________',		3954,3223,2231,3433
	Player	'P209___________',			0864,4434,2044,4331
	Player	'P210__________',			24A3,3323,3033,3232
	Player	'P211__________',			1182,2232,3812,3311
	Player	'P212________',				3392,2112,2422,2314
	Player	'P213____________',			0762,3232,3622,3533
	Player	'P214_______',				1673,4434,3744,4244
	Player	'P215_________',			22B3,3333,4633,4124
	Player	'P216________',				2082,2221,3624,3415
	Player	'P217______',				1771,1210,1511,1013
	Player	'P218_______',				3483,3212,3923,1520
	Player	'P219___________',			03A5,4454,4442,5133
	Player	'P220_________',			04A3,4343,3432,4133
	Player	'P221_____',				0674,3234,3441,4334
	Player	'P222_______',				3772,2231,1622,2513
	Player	'P223______',				2772,2122,2921,2414
	Player	'P224___________',			29B3,3131,2421,3514
	Player	'P225__________',			41A2,3132,3621,2123
	dc.w	2						;end of player data: empty String
.tn									;city
	String	'Hartford'
.ta									;abbreviation
	String	'HFD'
.tm									;nickname
	String	'N07____'
.ar									;arena
	String	'Hartford Civic Center'

LosAngeles							;LA
.0									;team data start: offsets to the parts
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad								;home and visitor palettes
	incbin	..\Extracted\NHL94\Graphics\Pals\LAh.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\LAv.pal
.sr									;team ratings (qreb,hvxx)
	dc.w	$6612,$11D9
.godds								;starting goalie weights
	dc.b	150,32
.ls									;8 lines of 8 player numbers
	dc.b	01,17,18,08,04,13,05,00
	dc.b	01,17,19,08,04,13,05,00
	dc.b	01,18,21,09,05,14,04,00
	dc.b	01,20,22,10,06,15,04,00
	dc.b	01,19,17,08,04,14,05,00
	dc.b	01,20,18,09,05,13,04,00
	dc.b	01,21,18,09,15,04,14,00
	dc.b	01,19,22,04,14,09,15,00
.pld								;player data: one player per row, ended by an empty String
	Player	'P226________',				3263,3444,0000,2223
	Player	'P227________',				3562,3553,0000,2222
	Player	'P228________',				0122,3332,0000,2221
	Player	'P229_________',			9946,4542,2262,6060
	Player	'P230________',				1294,4434,2345,4241
	Player	'P231________',				2343,4432,1534,3333
	Player	'P232________',				1462,2201,2322,0322
	Player	'P233__________',			2074,4534,2456,5243
	Player	'P234________',				2164,5443,3334,3334
	Player	'P235________',				2962,3322,2623,2222
	Player	'P236________',				1572,2222,2423,2431
	Player	'P237_________',			1072,2211,3612,1515
	Player	'P238___________',			0794,4535,3845,3233
	Player	'P239______',				1784,3444,2143,4132
	Player	'P240_________',			1164,4432,3423,4332
	Player	'P241_______',				1873,2233,3532,3323
	Player	'P242_____',				04B4,4444,3341,4344
	Player	'P243__________',			33E3,3343,3932,4436
	Player	'P244__________',			0254,4343,3432,4133
	Player	'P245________',				2593,3233,3431,3232
	Player	'P246_________',			22A3,2243,3431,3132
	Player	'P247______',				2483,3231,3620,2123
	Player	'P248__________',			0352,2121,2820,2114
	Player	'P249_______',				0562,2121,2620,2122
	Player	'P250___________',			0881,1010,1510,1313
	dc.w	2						;end of player data: empty String
.tn									;city
	String	'Los Angeles'
.ta									;abbreviation
	String	'LA'
.tm									;nickname
	String	'N08__'
.ar									;arena
	String	'Great Western Forum'

Dallas								;DAL
.0									;team data start: offsets to the parts
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad								;palettes unchanged
	incbin	..\Extracted\NHL94\Graphics\Pals\DALh.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\DALv.pal
.sr									;team ratings (qreb,hvxx)
	dc.w	$1410,$00E9
.godds								;starting goalie weights
	dc.b	181,0
.ls									;8 lines of 8 player numbers
	dc.b	01,17,18,04,03,11,12,00
	dc.b	01,17,20,03,12,16,04,00
	dc.b	01,19,21,08,04,14,12,00
	dc.b	01,22,18,09,05,11,12,00
	dc.b	01,17,18,11,03,12,04,00
	dc.b	01,22,19,08,04,13,11,00
	dc.b	01,24,20,05,11,08,09,00
	dc.b	01,17,21,08,09,05,11,00
.pld								;player data: one player per row, ended by an empty String
	Player	'P251_____',				3024,3443,0000,2234
	Player	'P252_________',			3562,3333,0000,2232
	Player	'P253_______',				0975,5445,2452,5243
	Player	'P254_______',				1564,4443,2444,4244
	Player	'P255_______',				0744,4353,3032,4341
	Player	'P256___________',			4164,3223,2042,2532
	Player	'P257_______',				18A3,3232,2632,3440
	Player	'P258_______',				1794,3333,4422,4422
	Player	'P259___________',			1093,4232,3423,3511
	Player	'P260_______',				1683,3323,3632,2530
	Player	'P261__________',			2665,6424,2133,3432
	Player	'P262______',				2283,4433,2044,4330
	Player	'P263______',				2063,3333,3743,3223
	Player	'P264_______',				2992,2312,1521,1122
	Player	'P265________',				2791,2221,2922,2125
	Player	'P266_________',			1273,3221,2022,2513
	Player	'P267________',				2493,3344,4433,4224
	Player	'P268________',				3364,3334,2131,3331
	Player	'P269_______',				0672,3242,3631,4143
	Player	'P270__________',			0293,2232,2421,4224
	Player	'P271________',				03C2,2132,3420,3424
	Player	'P272_____________',		0472,3133,3630,3522
	Player	'P273________',				2392,2122,2520,1312
	Player	'P274______',				0572,2032,3420,3514
	Player	'P275__________',			3991,1022,2820,3525
	dc.w	2						;end of player data: empty String
.tn									;city
	String	'Dallas'
.ta									;abbreviation
	String	'DAL'
.tm									;nickname
	String	'N09__'
.ar									;arena
	String	'Reunion Arena'

Montreal							;MTL
.0									;team data start: offsets to the parts
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad								;home and visitor palettes
	incbin	..\Extracted\NHL94\Graphics\Pals\MTLh.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\MTLv.pal
.sr									;team ratings (qreb,hvxx)
	dc.w	$5211,$21E9
.godds								;starting goalie weights
	dc.b	197,0
.ls									;8 lines of 8 player numbers
	dc.b	01,18,17,07,03,12,04,00
	dc.b	01,23,18,07,03,12,04,00
	dc.b	01,22,17,08,04,14,03,00
	dc.b	01,19,20,09,05,13,03,00
	dc.b	01,18,17,07,03,12,05,00
	dc.b	01,19,20,08,04,05,03,00
	dc.b	01,17,23,07,06,03,13,00
	dc.b	01,22,19,03,13,07,06,00
.pld								;player data: one player per row, ended by an empty String
	Player	'P276_______',				3366,4446,0000,5566
	Player	'P277_________',			3742,3333,0000,2222
	Player	'P278_______',				1194,4444,4444,4143
	Player	'P279__________',			4754,4433,2145,4031
	Player	'P280________',				1855,4433,2353,3043
	Player	'P281__________',			2164,3242,4141,3341
	Player	'P282______________',		2564,4433,2053,4243
	Player	'P283__________',			4583,4333,2433,3232
	Player	'P284________',				17B3,4333,3033,3222
	Player	'P285_________',			2262,2322,2223,2222
	Player	'P286_________',			3261,1112,3813,1314
	Player	'P287_________',			2384,4434,2344,4242
	Player	'P288______',				1253,4432,3323,3033
	Player	'P289_______',				2654,4323,2933,3232
	Player	'P290_____',				36B1,1211,3712,2314
	Player	'P291____',					3182,2212,3322,1421
	Player	'P292___________',			2894,3343,4342,4233
	Player	'P293__________',			2773,4333,3442,4243
	Player	'P294_____________',		4353,3333,3722,4323
	Player	'P295________',				1462,2231,2612,4523
	Player	'P296______',				0593,2233,4731,3534
	Player	'P297___________',			4864,3244,3432,4422
	Player	'P298________',				2493,2242,3620,3324
	Player	'P299_____',				3882,2222,3521,2314
	Player	'P300___________',			3492,2122,3921,2313
	dc.w	2						;end of player data: empty String
.tn									;city
	String	'Montreal'
.ta									;abbreviation
	String	'MTL'
.tm									;nickname
	String	'N10______'
.ar									;arena
	String	'Montreal Forum'

NewJersey							;NJ
.0									;team data start: offsets to the parts
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad								;home and visitor palettes
	incbin	..\Extracted\NHL94\Graphics\Pals\NJh.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\NJv.pal
.sr									;team ratings (qreb,hvxx)
	dc.w	$3411,$12F8
.godds								;starting goalie weights
	dc.b	152,0
.ls									;8 lines of 8 player numbers
	dc.b	01,19,18,12,03,13,08,00
	dc.b	01,18,21,08,04,12,03,00
	dc.b	01,19,22,07,03,15,04,00
	dc.b	01,20,23,09,05,13,04,00
	dc.b	01,18,20,12,05,13,07,00
	dc.b	01,23,21,08,09,07,13,00
	dc.b	01,18,23,07,17,08,03,00
	dc.b	01,20,19,08,03,07,17,00
.pld								;player data: one player per row, ended by an empty String
	Player	'P301_________',			3124,4443,0000,3333
	Player	'P302____________',			0143,4221,0000,2222
	Player	'P303__________',			2064,3443,3144,3242
	Player	'P304___________',			1963,3433,1342,3043
	Player	'P305_________',			2694,3343,3044,3241
	Player	'P306________',				3492,2322,2222,2232
	Player	'P307____________',			2564,4433,1043,3143
	Player	'P308________',				1593,3344,3733,4423
	Player	'P309_______',				16A3,4333,3333,4533
	Player	'P310_______',				0992,2321,2332,2232
	Player	'P311_________',			08A2,2221,1824,1313
	Player	'P312___________',			4494,4435,2143,4432
	Player	'P313__________',			22B4,4434,3732,4334
	Player	'P314_______',				1292,2323,2333,2323
	Player	'P315_______',				2162,2222,2922,3424
	Player	'P316__________',			1862,3332,2623,2223
	Player	'P317_____',				1183,3233,3323,3222
	Player	'P318_________',			04B4,4344,5642,5043
	Player	'P319____________',			02B4,2244,4441,3044
	Player	'P320________',				2363,3342,3432,4232
	Player	'P321____________',			2793,3333,3432,3132
	Player	'P322____________',			07B4,3234,4441,3142
	Player	'P323_______',				03A2,2141,4620,4414
	Player	'P324_________',			0673,2232,2230,3322
	Player	'P325__________',			0571,1011,1210,1303
	dc.w	2						;end of player data: empty String
.tn									;city
	String	'New Jersey'
.ta									;abbreviation
	String	'NJ'
.tm									;nickname
	String	'N11___'
.ar									;arena
	String	'Byrne Meadowlands Arena'

NewYorkI							;NYI
.0									;team data start: offsets to the parts
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad								;home and visitor palettes
	incbin	..\Extracted\NHL94\Graphics\Pals\NYIh.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\NYIv.pal
.sr									;team ratings (qreb,hvxx)
	dc.w	$5321,$00F8
.godds								;starting goalie weights
	dc.b	151,0
.ls									;8 lines of 8 player numbers
	dc.b	01,19,18,09,03,04,10,00
	dc.b	01,23,20,09,03,12,04,00
	dc.b	01,18,19,10,04,13,03,00
	dc.b	01,21,22,11,07,15,03,00
	dc.b	01,18,22,09,03,10,04,00
	dc.b	01,21,20,07,04,12,09,00
	dc.b	01,23,21,13,12,04,15,00
	dc.b	01,18,25,04,15,12,13,00
.pld								;player data: one player per row, ended by an empty String
	Player	'P326_______',				3552,4442,0000,2222
	Player	'P327___________',			3072,4223,0000,2222
	Player	'P328__________',			7794,4534,3445,5141
	Player	'P329________',				3374,5433,2445,4143
	Player	'P330_________',			1843,3322,2333,3022
	Player	'P331________',				3982,2322,3121,2322
	Player	'P332_______',				2063,3334,2643,4333
	Player	'P333___________',			1083,2211,3833,1524
	Player	'P334________',				3264,4433,4433,4243
	Player	'P335______',				2793,2434,1445,4222
	Player	'P336______',				2564,4322,1242,4532
	Player	'P337___________',			2683,2432,3342,4042
	Player	'P338________',				1663,3333,2433,4531
	Player	'P339_________',			15B1,2321,1524,2123
	Player	'P340__________',			1482,2232,2122,3222
	Player	'P341______',				1773,3213,1531,2423
	Player	'P342_______',				1282,3111,1911,2414
	Player	'P343_____________',		23A3,3434,3432,4233
	Player	'P344_____________',		1174,3233,4431,3234
	Player	'P345_______',				0883,3432,2422,4132
	Player	'P346_____',				04E2,2343,3322,4132
	Player	'P347_______',				2883,3434,2631,4132
	Player	'P348__________',			0782,2243,3432,4133
	Player	'P349________',				37A1,1212,2611,1113
	Player	'P350_________',			4793,3123,3821,2515
	dc.w	2						;end of player data: empty String
.tn									;city
	String	'New York'
.ta									;abbreviation
	String	'NYI'
.tm									;nickname
	String	'N12______'
.ar									;arena
	String	'Nassau Coliseum'

NewYorkR							;NYR
.0									;team data start: offsets to the parts
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad								;home and visitor palettes
	incbin	..\Extracted\NHL94\Graphics\Pals\NYRh.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\NYRv.pal
.sr									;team ratings (qreb,hvxx)
	dc.w	$3411,$11F8
.godds								;starting goalie weights
	dc.b	150,0
.ls									;8 lines of 8 player numbers
	dc.b	01,19,18,07,03,12,08,00
	dc.b	01,18,21,08,03,13,06,00
	dc.b	01,19,22,07,06,14,03,00
	dc.b	01,20,25,09,04,12,03,00
	dc.b	01,18,19,13,03,12,05,00
	dc.b	01,20,23,08,05,14,12,00
	dc.b	01,18,21,08,03,05,04,00
	dc.b	01,19,25,05,04,08,03,00
.pld								;player data: one player per row, ended by an empty String
	Player	'P351___________',			3453,4553,0000,3434
	Player	'P352________',				3573,4443,0000,4444
	Player	'P353________',				11A5,4443,5453,4053
	Player	'P354____________',			1364,3353,4034,5232
	Player	'P355___________',			0864,4433,2443,4432
	Player	'P356_____',				1294,3334,2443,3442
	Player	'P357________',				1095,5344,5442,4443
	Player	'P358_______',				0964,4432,3633,4534
	Player	'P359________',				2982,4232,4832,3222
	Player	'P360______',				2083,3232,2233,3031
	Player	'P361_______',				2572,2322,1323,3422
	Player	'P362________',				2275,5445,2353,5552
	Player	'P363_______',				3364,4433,1333,4332
	Player	'P364__________',			2774,3333,1034,3433
	Player	'P365_______',				3771,1231,2312,2312
	Player	'P366______',				2682,1132,3921,2424
	Player	'P367________',				1872,3101,3611,1514
	Player	'P368________',				0266,3444,2651,5252
	Player	'P369_________',			0394,4344,4341,4243
	Player	'P370________',				2173,3343,3332,3130
	Player	'P371__________',			23B2,2242,3720,3024
	Player	'P372______',				0484,3243,4241,3133
	Player	'P373___________',			0592,3322,2231,2432
	Player	'P374_____',				24A2,2222,3620,2124
	Player	'P375_______',				06A3,3223,2922,3323
	dc.w	2						;end of player data: empty String
.tn									;city
	String	'New York'
.ta									;abbreviation
	String	'NYR'
.tm									;nickname
	String	'N13____'
.ar									;arena
	String	'Madison Square Garden'

Ottawa								;OTW
.0									;team data start: offsets to the parts
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad								;new visitor palette
	incbin	..\Extracted\NHL94\Graphics\Pals\OTWh.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\OTWv94.pal
.sr									;team ratings (qreb,hvxx)
	dc.w	$0702,$13F8
.godds								;starting goalie weights
	dc.b	197,0
.ls									;8 lines of 8 player numbers
	dc.b	01,20,19,10,03,15,11,00
	dc.b	01,20,19,10,03,15,07,00
	dc.b	01,22,25,12,07,17,03,00
	dc.b	01,21,23,11,04,16,03,00
	dc.b	01,20,19,15,03,16,05,00
	dc.b	01,23,22,10,05,08,16,00
	dc.b	01,19,23,06,07,12,04,00
	dc.b	01,20,25,12,04,07,06,00
.pld								;player data: one player per row, ended by an empty String
	Player	'P376____________',			3162,3112,0000,2222
	Player	'P377_____________',		3213,3112,0000,2222
	Player	'P378_______',				1373,3333,2433,4232
	Player	'P379_____',				0764,3242,3031,3333
	Player	'P380______',				1292,2332,2622,3133
	Player	'P381______',				1162,2332,2423,4322
	Player	'P382___________',			1664,2242,3432,3523
	Player	'P383___________',			1572,2232,1622,3522
	Player	'P384______',				1891,2222,3621,2412
	Player	'P385___________',			6194,4333,2432,3523
	Player	'P386_______',				4492,2232,3A13,3525
	Player	'P387______',				0953,3232,2621,2423
	Player	'P388_______',				2863,3312,2833,1522
	Player	'P389________',				1062,2122,1612,2424
	Player	'P390________',				2693,3333,2334,3432
	Player	'P391_____',				1792,2332,3122,3321
	Player	'P392_________',			2092,2332,3522,2122
	Player	'P393_________',			2572,2222,1632,2513
	Player	'P394________',				2263,3443,3022,4133
	Player	'P395_____',				0473,2333,2331,3232
	Player	'P396_________',			3492,2232,3420,3423
	Player	'P397________',				2362,2131,1320,2423
	Player	'P398_______',				0573,2132,3621,3513
	Player	'P399_______',				0681,1221,2311,2513
	Player	'P400______',				14B2,2031,3610,2522
	dc.w	2						;end of player data: empty String
.tn									;city
	String	'Ottawa'
.ta									;abbreviation
	String	'OTW'
.tm									;nickname
	String	'N14_____'
.ar									;arena
	String	'Ottawa Civic Center'

Philadelphia						;PHI
.0									;team data start: offsets to the parts
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad								;home and visitor palettes
	incbin	..\Extracted\NHL94\Graphics\Pals\PHIh.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\PHIv.pal
.sr									;team ratings (qreb,hvxx)
	dc.w	$3602,$22E8
.godds								;starting goalie weights
	dc.b	134,48
.ls									;8 lines of 8 player numbers
	dc.b	01,19,18,05,04,15,16,00
	dc.b	01,19,18,10,04,15,05,00
	dc.b	01,21,23,12,05,16,04,00
	dc.b	01,20,22,11,06,17,04,00
	dc.b	01,18,20,05,04,15,06,00
	dc.b	01,21,19,10,06,16,04,00
	dc.b	01,18,23,08,15,10,05,00
	dc.b	01,21,19,10,05,08,15,00
.pld								;player data: one player per row, ended by an empty String
	Player	'P401____________',			3034,4554,0000,3434
	Player	'P402___________',			3363,3333,0000,3322
	Player	'P403____________',			3572,3001,0100,2222
	Player	'P404________',				88C4,3444,5946,5244
	Player	'P405__________',			1794,3444,3444,4243
	Player	'P406________',				0955,4433,3243,4041
	Player	'P407_________',			4263,3332,1033,3433
	Player	'P408_______',				2542,2243,4032,4232
	Player	'P409_____________',		2262,2222,2620,2123
	Player	'P410_______',				1882,2433,3323,3122
	Player	'P411______',				1562,2222,2423,2223
	Player	'P412__________',			2374,3323,1233,3242
	Player	'P413__________',			1473,3222,2631,2531
	Player	'P414_________',			1091,1212,2814,1214
	Player	'P415_______',				0865,4534,3445,4143
	Player	'P416________',				1174,5342,2733,4534
	Player	'P417______',				2191,1021,2910,2513
	Player	'P418________',				0372,2342,3631,3233
	Player	'P419______________',		0274,3343,2431,4333
	Player	'P420________',				2074,3333,2432,3133
	Player	'P421_________',			29A2,2232,3621,3024
	Player	'P422________',				05A2,2332,2523,3322
	Player	'P423_______',				2782,2232,2721,3414
	Player	'P424______',				2642,2221,3222,2522
	Player	'P425________',				44A1,1111,2C13,1513
	dc.w	2						;end of player data: empty String
.tn									;city
	String	'Philadelphia'
.ta									;abbreviation
	String	'PHI'
.tm									;nickname
	String	'N15___'
.ar									;arena
	String	'Spectrum'

Pittsburgh							;PIT
.0									;team data start: offsets to the parts
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad								;home and visitor palettes
	incbin	..\Extracted\NHL94\Graphics\Pals\PITh.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\PITv.pal
.sr									;team ratings (qreb,hvxx)
	dc.w	$7120,$21E9
.godds								;starting goalie weights
	dc.b	197,0
.ls									;8 lines of 8 player numbers
	dc.b	01,17,18,07,03,11,12,00
	dc.b	01,17,18,07,03,11,04,00
	dc.b	01,21,19,09,04,12,03,00
	dc.b	01,23,20,08,05,13,03,00
	dc.b	01,17,20,07,03,11,13,00
	dc.b	01,23,18,04,13,12,03,00
	dc.b	01,17,18,12,03,04,13,00
	dc.b	01,23,22,04,13,03,12,00
.pld								;player data: one player per row, ended by an empty String
	Player	'P426________',				35A4,4554,0100,4444
	Player	'P427_______',				3182,3442,0000,3232
	Player	'P428_________',			66A5,4644,3366,6062
	Player	'P429_______',				1094,3444,4443,4042
	Player	'P430___________',			1573,3333,2433,4332
	Player	'P431__________',			2663,2222,2121,2530
	Player	'P432_________',			25B3,4533,3644,5344
	Player	'P433________',				1462,3232,2422,3122
	Player	'P434______',				24A2,3232,4621,3213
	Player	'P435________',				2092,2122,2623,2421
	Player	'P436________',				68A5,4433,4453,4142
	Player	'P437________',				2292,2544,3735,4134
	Player	'P438______',				0764,3433,3145,4230
	Player	'P439_________',			8253,3322,2222,2032
	Player	'P440________',				3962,2222,2523,2521
	Player	'P441________',				16E1,2011,3B10,1314
	Player	'P442________',				55A4,3454,3342,5143
	Player	'P443__________',			0584,4353,5630,4135
	Player	'P444____',					0282,3222,2421,3122
	Player	'P445________',				2383,3234,3321,3543
	Player	'P446____________',			3292,2233,4430,4324
	Player	'P447_______',				0683,2232,3622,3122
	Player	'P448____________',			28E2,2134,4731,4523
	Player	'P449__________',			0392,2132,3820,2313
	Player	'P450_________',			3381,1211,2220,1011
	dc.w	2						;end of player data: empty String
.tn									;city
	String	'Pittsburgh'
.ta									;abbreviation
	String	'PIT'
.tm									;nickname
	String	'N16_____'
.ar									;arena
	String	'Civic Arena'

Quebec								;QUE
.0									;team data start: offsets to the parts
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad								;home and visitor palettes
	incbin	..\Extracted\NHL94\Graphics\Pals\QUEh.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\QUEv.pal
.sr									;team ratings (qreb,hvxx)
	dc.w	$7521,$00F8
.godds								;starting goalie weights
	dc.b	166,0
.ls									;8 lines of 8 player numbers
	dc.b	01,19,18,03,14,15,17,00
	dc.b	01,19,18,07,03,14,04,00
	dc.b	01,20,21,08,04,15,03,00
	dc.b	01,22,23,06,05,16,03,00
	dc.b	01,19,18,04,03,15,16,00
	dc.b	01,20,21,07,14,16,03,00
	dc.b	01,20,22,03,17,05,14,00
	dc.b	01,19,18,05,14,03,17,00
.pld								;player data: one player per row, ended by an empty String
	Player	'P451_______',				2774,4444,0000,4433
	Player	'P452__________',			3553,4332,0000,2222
	Player	'P453_____',				1964,4544,2045,5252
	Player	'P454______',				0974,4433,3435,3043
	Player	'P455___________',			4753,3342,2432,3123
	Player	'P456___________',			2553,2323,1433,3132
	Player	'P457___________',			3184,4435,2543,4142
	Player	'P458______',				1873,2333,2432,3233
	Player	'P459__________',			44B1,3222,2423,2222
	Player	'P460_________',			2292,2222,3624,3524
	Player	'P461________',				2061,2222,2221,2321
	Player	'P462_______',				12D1,1101,2811,0515
	Player	'P463______',				15A1,1101,1C10,1414
	Player	'P464_______',				1374,4544,1345,4043
	Player	'P465______',				1184,4434,1744,4334
	Player	'P466____________',			5133,4433,3434,4132
	Player	'P467_______',				4873,3343,2133,3431
	Player	'P468__________',			2884,4444,2442,4142
	Player	'P469_____________',		0793,4342,3423,4032
	Player	'P470__________',			0563,3333,3033,4032
	Player	'P471_________',			0293,3333,3631,3223
	Player	'P472______',				5262,2241,3321,3224
	Player	'P473_______',				2982,2233,3622,3424
	Player	'P474_____________',		0483,3225,4641,2443
	Player	'P475_________',			0692,2221,2811,2114
	dc.w	2						;end of player data: empty String
.tn									;city
	String	'Quebec'
.ta									;abbreviation
	String	'QUE'
.tm									;nickname
	String	'N17______'
.ar									;arena
	String	'Colisee de Quebec'

SanJose								;SJ
.0									;team data start: offsets to the parts
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad								;home and visitor palettes
	incbin	..\Extracted\NHL94\Graphics\Pals\SJh.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\SJv.pal
.sr									;team ratings (qreb,hvxx)
	dc.w	$0702,$12D9
.godds								;starting goalie weights
	dc.b	102,48
.ls									;8 lines of 8 player numbers
	dc.b	01,18,17,10,04,14,05,00
	dc.b	01,18,21,10,04,14,05,00
	dc.b	01,19,23,12,05,15,04,00
	dc.b	01,17,25,11,06,16,04,00
	dc.b	01,17,19,10,04,14,06,00
	dc.b	01,18,21,11,05,06,04,00
	dc.b	01,21,24,04,14,05,07,00
	dc.b	01,18,23,07,05,04,14,00
.pld								;player data: one player per row, ended by an empty String
	Player	'P476_______',				3252,4443,0000,3322
	Player	'P477________',				3052,3112,0000,2222
	Player	'P478_________',			0162,3002,0000,2222
	Player	'P479_______',				1162,2443,3334,4033
	Player	'P480________',				3763,3333,2323,4531
	Player	'P481_______',				1261,1232,3323,3323
	Player	'P482_________',			4762,3232,1021,4521
	Player	'P483_________',			1674,4222,3322,2533
	Player	'P484______',				26B2,2112,1514,1323
	Player	'P485___________',			1063,3422,1033,3122
	Player	'P486_______',				3691,2322,2623,3415
	Player	'P487_______',				2042,2222,2821,2523
	Player	'P488_______',				2581,1112,3820,1414
	Player	'P489_______',				1774,4323,1342,4531
	Player	'P490________',				3992,2331,1313,2121
	Player	'P491_________',			1882,2322,2623,2522
	Player	'P492_______',				2474,3336,3641,3343
	Player	'P493__________',			0573,3132,3530,4443
	Player	'P494___________',			0673,3333,3632,4233
	Player	'P495________',				4141,2322,2522,2432
	Player	'P496_______',				19C2,2232,3621,3524
	Player	'P497__________',			0382,2222,2520,2213
	Player	'P498____',					0473,2134,3331,3534
	Player	'P499_______',				2192,2132,3621,3422
	Player	'P500_______',				0272,2132,2430,3434
	dc.w	2						;end of player data: empty String
.tn									;city
	String	'San Jose'
.ta									;abbreviation
	String	'SJ'
.tm									;nickname
	String	'N18___'
.ar									;arena
	String	'San Jose Arena'

StLouis								;STL
.0									;team data start: offsets to the parts
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad								;new home palette
	incbin	..\Extracted\NHL94\Graphics\Pals\STLh94.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\STLv.pal
.sr									;team ratings (qreb,hvxx)
	dc.w	$2220,$21E9
.godds								;starting goalie weights
	dc.b	212,0
.ls									;8 lines of 8 player numbers
	dc.b	01,17,18,12,03,13,04,00
	dc.b	01,17,18,11,06,13,03,00
	dc.b	01,20,24,10,03,12,06,00
	dc.b	01,19,21,09,04,15,06,00
	dc.b	01,17,19,12,03,13,05,00
	dc.b	01,21,22,04,05,14,12,00
	dc.b	01,20,24,06,05,10,15,00
	dc.b	01,21,18,10,15,05,06,00
.pld								;player data: one player per row, ended by an empty String
	Player	'P501_________',			3164,4664,0000,3344
	Player	'P502______',				2962,3332,0000,2222
	Player	'P503________',				1574,3543,2044,4040
	Player	'P504__________',			0744,4433,2343,4132
	Player	'P505______',				2263,3342,4533,4343
	Player	'P506______',				1863,3241,2022,4322
	Player	'P507______',				2843,4222,4833,2323
	Player	'P508__________',			3662,2222,1621,2513
	Player	'P509________',				3872,2232,2021,3021
	Player	'P510______',				1082,2232,3622,3424
	Player	'P511_______',				1792,2222,2C21,3415
	Player	'P512____________',			19A3,3544,2745,4244
	Player	'P513______',				1694,4536,3353,4432
	Player	'P514________',				1474,3343,3733,4333
	Player	'P515_______',				2373,3241,2322,4523
	Player	'P516_______',				3981,1121,1911,2315
	Player	'P517______',				2193,3445,2343,5142
	Player	'P518_________',			0592,3242,4731,4434
	Player	'P519_________',			0672,2332,2623,4032
	Player	'P520______',				0482,2233,2320,4023
	Player	'P521____________',			33B2,2142,3730,4433
	Player	'P522_______',				2082,2231,3822,3224
	Player	'P523________',				4482,2112,3620,1322
	Player	'P524______',				0253,2131,2220,3312
	Player	'P525________',				34A3,3122,2621,2513
	dc.w	2						;end of player data: empty String
.tn									;city
	String	'St. Louis'
.ta									;abbreviation
	String	'STL'
.tm									;nickname
	String	'N19__'
.ar									;arena
	String	'St. Louis Arena'

TampaBay							;TB
.0									;team data start: offsets to the parts
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad								;home and visitor palettes
	incbin	..\Extracted\NHL94\Graphics\Pals\TBh.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\TBv.pal
.sr									;team ratings (qreb,hvxx)
	dc.w	$0502,$00F7
.godds								;starting goalie weights
	dc.b	104,64
.ls									;8 lines of 8 player numbers
	dc.b	01,20,19,12,04,05,06,00
	dc.b	01,22,23,13,04,15,06,00
	dc.b	01,21,24,12,06,17,04,00
	dc.b	01,19,20,14,05,16,04,00
	dc.b	01,20,21,13,04,15,05,00
	dc.b	01,19,22,12,06,05,04,00
	dc.b	01,22,19,12,17,15,16,00
	dc.b	01,20,21,16,15,12,17,00
.pld								;player data: one player per row, ended by an empty String
	Player	'P526_________',			0163,3223,0000,3233
	Player	'P527_________',			3552,3222,0100,2222
	Player	'P528_________',			3072,3222,0000,1111
	Player	'P529_________',			1944,3434,3335,4233
	Player	'P530________',				1683,3433,3035,4330
	Player	'P531__________',			10A3,2322,3422,3433
	Player	'P532_______',				2873,3332,2132,3324
	Player	'P533______',				1852,3332,2522,3223
	Player	'P534________',				1153,3132,4433,3231
	Player	'P535____________',			1762,2332,1324,2212
	Player	'P536________',				2072,2132,3221,3521
	Player	'P537____________',			3462,4232,1032,4530
	Player	'P538_______',				0792,3322,3432,3322
	Player	'P539_________',			37A2,2232,3021,3422
	Player	'P540_______',				1492,3333,2332,3233
	Player	'P541_______',				2473,3332,2122,3421
	Player	'P542________',				2182,2132,2321,3522
	Player	'P543_______',				2771,2102,2312,0512
	Player	'P544_____',				0293,3332,2322,3323
	Player	'P545_________',			4473,2233,2431,3423
	Player	'P546__________',			2292,2332,2221,3222
	Player	'P547_________',			2562,2223,3420,3322
	Player	'P548______',				29B3,2223,2630,3223
	Player	'P549________',				4061,1211,0210,1114
	Player	'P550_______',				2691,1211,2910,1304
	dc.w	2						;end of player data: empty String
.tn									;city
	String	'Tampa Bay'
.ta									;abbreviation
	String	'TB'
.tm									;nickname
	String	'N20______'
.ar									;arena
	String	'Fairgrounds Expo Hall'

Toronto								;TOR
.0									;team data start: offsets to the parts
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad								;home and visitor palettes
	incbin	..\Extracted\NHL94\Graphics\Pals\TORh.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\TORv.pal
.sr									;team ratings (qreb,hvxx)
	dc.w	$2020,$11E8
.godds								;starting goalie weights
	dc.b	150,16
.ls									;8 lines of 8 player numbers
	dc.b	01,19,18,09,04,13,15,00
	dc.b	01,22,18,09,04,13,06,00
	dc.b	01,24,23,11,06,14,04,00
	dc.b	01,19,20,10,05,15,04,00
	dc.b	01,19,18,09,04,13,15,00
	dc.b	01,20,22,15,05,14,04,00
	dc.b	01,19,24,06,04,12,07,00
	dc.b	01,22,18,12,07,04,06,00
.pld								;player data: one player per row, ended by an empty String
	Player	'P551________',				2964,4664,0000,4444
	Player	'P552_______',				0193,4552,0100,2233
	Player	'P553________',				3062,3002,0000,2222
	Player	'P554________',				9345,4554,4444,6043
	Player	'P555_______',				1974,3433,2344,4143
	Player	'P556___________',			2693,3342,3434,4322
	Player	'P557_______',				2593,3333,4033,4141
	Player	'P558_________',			0773,2231,3433,3532
	Player	'P559___________',			14B3,3444,4334,5432
	Player	'P560________',				1783,3335,4643,4344
	Player	'P561________',				2192,2242,3422,4413
	Player	'P562_____',				1072,2232,3423,4523
	Player	'P563______________',		1664,4423,2044,4241
	Player	'P564__________',			0974,4433,2643,4143
	Player	'P565_______',				1262,2331,1123,4524
	Player	'P566________',				7182,2232,5533,3523
	Player	'P567__________',			2292,2021,2A10,2324
	Player	'P568_____',				2363,3332,4422,4123
	Player	'P569_______',				0494,4345,4441,4242
	Player	'P570___________',			1573,2333,1232,3132
	Player	'P571____________',			55A2,2332,3522,3023
	Player	'P572________',				3483,3244,4431,4442
	Player	'P573_____',				03A3,3242,4320,4423
	Player	'P574____________',			0292,2131,3420,4433
	Player	'P575______',				0882,2023,3523,2324
	dc.w	2						;end of player data: empty String
.tn									;city
	String	'Toronto'
.ta									;abbreviation
	String	'TOR'
.tm									;nickname
	String	'N21________'
.ar									;arena
	String	'Maple Leaf Gardens'

Vancouver							;VAN
.0									;team data start: offsets to the parts
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad								;new home palette
	incbin	..\Extracted\NHL94\Graphics\Pals\VANh94.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\VANv.pal
.sr									;team ratings (qreb,hvxx)
	dc.w	$6102,$11F8
.godds								;starting goalie weights
	dc.b	166,0
.ls									;8 lines of 8 player numbers
	dc.b	01,19,18,07,03,13,04,00
	dc.b	01,19,22,10,03,14,05,00
	dc.b	01,24,18,09,05,13,03,00
	dc.b	01,20,25,07,04,16,03,00
	dc.b	01,18,20,13,04,14,09,00
	dc.b	01,19,23,07,03,09,13,00
	dc.b	01,24,18,13,05,04,16,00
	dc.b	01,19,23,04,16,13,05,00
.pld								;player data: one player per row, ended by an empty String
	Player	'P576_______',				0184,4444,0000,4433
	Player	'P577________',				3552,3552,0000,2323
	Player	'P578_________',			0755,5432,2043,5141
	Player	'P579_______',				1952,2432,1036,4233
	Player	'P580___________',			2073,3343,2033,4032
	Player	'P581______',				15A2,2332,2223,3022
	Player	'P582___________',			1475,5433,1443,3244
	Player	'P583_________',			3263,3433,3434,3031
	Player	'P584______',				0873,3443,3235,4131
	Player	'P585__________',			27B4,3333,4623,4424
	Player	'P586_______',				29B2,2232,3A21,3326
	Player	'P587______',				2372,2232,3623,3323
	Player	'P588______',				1055,6544,2054,4442
	Player	'P589_________',			1694,4444,3344,4342
	Player	'P590______',				1792,3333,2125,3123
	Player	'P591_______',				25B1,2333,2922,3324
	Player	'P592______',				2692,2122,3923,2324
	Player	'P593_______',				2174,3342,3441,4142
	Player	'P594________',				0393,3233,4341,4142
	Player	'P595__________',			0672,2332,3622,3023
	Player	'P596______',				24A3,3333,2631,4134
	Player	'P597_________',			04A3,3234,4731,3434
	Player	'P598_______',				44B2,2343,2630,4233
	Player	'P599_______',				0592,3234,4621,4424
	Player	'P600_______',				22B2,2132,3632,3324
	dc.w	2						;end of player data: empty String
.tn									;city
	String	'Vancouver'
.ta									;abbreviation
	String	'VAN'
.tm									;nickname
	String	'N22____'
.ar									;arena
	String	'Pacific Coliseum'

Winnipeg							;WPG
.0									;team data start: offsets to the parts
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad								;home and visitor palettes
	incbin	..\Extracted\NHL94\Graphics\Pals\WPGh.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\WPGv.pal
.sr									;team ratings (qreb,hvxx)
	dc.w	$4511,$11F8
.godds								;starting goalie weights
	dc.b	214,0
.ls									;8 lines of 8 player numbers
	dc.b	01,19,18,04,03,13,09,00
	dc.b	01,22,18,08,03,13,04,00
	dc.b	01,19,21,09,04,14,03,00
	dc.b	01,20,24,10,06,17,03,00
	dc.b	01,20,18,08,03,13,04,00
	dc.b	01,19,21,09,04,14,03,00
	dc.b	01,19,21,10,06,05,16,00
	dc.b	01,24,22,05,16,10,06,00
.pld								;player data: one player per row, ended by an empty String
	Player	'P601_______',				3534,4554,0000,4444
	Player	'P602_______',				3062,3222,0000,2222
	Player	'P603__________',			1075,3433,3054,4152
	Player	'P604________',				2584,3433,3444,4053
	Player	'P605___________',			3843,3332,3134,3232
	Player	'P606_______',				3673,3242,5422,5123
	Player	'P607______',				1452,3332,2323,3421
	Player	'P608__________',			3492,2343,4034,4033
	Player	'P609_________',			0793,2334,3623,4424
	Player	'P610_____',				17A3,3242,3622,4324
	Player	'P611_________',			2163,2122,3623,2522
	Player	'P612_________',			2392,2221,3220,2030
	Player	'P613_________',			1365,6534,3345,5442
	Player	'P614__________',			1164,4334,1334,3532
	Player	'P615______',				1592,2332,3322,3122
	Player	'P616__________',			1852,3332,3322,3121
	Player	'P617____',					2092,2232,3923,4126
	Player	'P618________',				0666,5433,2462,4062
	Player	'P619__________',			2774,3353,3142,4132
	Player	'P620____________',			0494,3434,1142,3141
	Player	'P621_________',			0363,3243,4431,4233
	Player	'P622_______',				0592,2242,3621,4024
	Player	'P623______',				2293,2132,2420,4523
	Player	'P624________',				2692,2132,3320,4423
	Player	'P625_________',			0892,2122,3621,2522
	dc.w	2						;end of player data: empty String
.tn									;city
	String	'Winnipeg'
.ta									;abbreviation
	String	'WPG'
.tm									;nickname
	String	'N23_'
.ar									;arena
	String	'Winnipeg Arena'

Washington							;WSH
.0									;team data start: offsets to the parts
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad								;home and visitor palettes
	incbin	..\Extracted\NHL94\Graphics\Pals\WSHh.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\WSHv.pal
.sr									;team ratings (qreb,hvxx)
	dc.w	$5220,$11E8
.godds								;starting goalie weights
	dc.b	181,0
.ls									;8 lines of 8 player numbers
	dc.b	01,18,17,04,03,12,13,00
	dc.b	01,18,17,10,04,14,03,00
	dc.b	01,19,20,09,03,12,04,00
	dc.b	01,21,22,11,05,13,04,00
	dc.b	01,20,17,04,03,12,06,00
	dc.b	01,18,19,06,05,13,04,00
	dc.b	01,21,17,03,14,10,06,00
	dc.b	01,19,20,10,06,03,14,00
.pld								;player data: one player per row, ended by an empty String
	Player	'P626_______',				3343,4333,0000,3333
	Player	'P627__________',			3162,3112,0000,3322
	Player	'P628_______',				1794,4433,2044,4042
	Player	'P629_____________',		0873,3434,3146,4142
	Player	'P630_______',				3282,2443,4624,4044
	Player	'P631__________',			2083,3433,3443,4043
	Player	'P632____________',			2262,2222,3222,2222
	Player	'P633_________',			1572,2212,2622,1322
	Player	'P634_________',			1174,4333,2432,3443
	Player	'P635________',				2162,3232,2422,3512
	Player	'P636____',					1692,2233,3722,3425
	Player	'P637________',				1264,6433,2044,4232
	Player	'P638_______',				1963,3333,2335,3122
	Player	'P639________',				1084,4333,2043,3241
	Player	'P640_______',				2672,2222,3323,2234
	Player	'P641__________',			2392,2232,4724,3323
	Player	'P642_________',			04C3,3445,4342,4443
	Player	'P643______',				34B4,4446,4642,4444
	Player	'P644________',				0363,3343,3132,4432
	Player	'P645___________',			0694,3344,3441,4142
	Player	'P646__________',			14A3,3233,3431,3532
	Player	'P647__________',			3692,2122,3621,2331
	Player	'P648_________',			2562,2111,2220,1212
	Player	'P649_______',				05B3,2022,3230,2323
	dc.w	2						;end of player data: empty String
.tn									;city
	String	'Washington'
.ta									;abbreviation
	String	'WSH'
.tm									;nickname
	String	'N24_____'
.ar									;arena
	String	'Capital Centre'

Florida								;FLA
.0									;team data start: offsets to the parts
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad								;new team palettes
	incbin	..\Extracted\NHL94\Graphics\Pals\FLAh.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\FLAv.pal
.sr									;team ratings (qreb,hvxx)
	dc.w	$0702,$1396
.godds								;starting goalie weights
	dc.b	214,0
.ls									;8 lines of 8 player numbers
	dc.b	01,14,12,08,05,04,07,00
	dc.b	01,14,17,08,05,03,04,00
	dc.b	01,16,12,06,10,11,05,00
	dc.b	01,13,15,07,09,04,05,00
	dc.b	01,14,12,08,05,04,10,00
	dc.b	01,13,17,06,10,03,05,00
	dc.b	01,14,12,09,05,07,08,00
	dc.b	01,13,17,07,08,09,05,00
.pld								;player data: one player per row, ended by an empty String
	Player	'P650___________',			3453,4553,0000,3434
	Player	'P651___________',			3072,4223,0000,2222
	Player	'P652__________',			1482,2232,2122,3222
	Player	'P653__________',			2791,1333,4723,3324
	Player	'P654___________',			3984,2242,4633,4434
	Player	'P655______',				1873,2333,2432,3233
	Player	'P656______',				1082,2232,3622,3424
	Player	'P657__________',			2374,3323,1233,3242
	Player	'P658________',				2072,2132,3221,3521
	Player	'P659__________',			2941,2312,2022,1421
	Player	'P660________',				2271,2222,2022,2421
	Player	'P661_______',				06A3,3223,2922,3323
	Player	'P662_____________',		21A2,3222,3822,3512
	Player	'P663_______',				2885,4234,4931,3333
	Player	'P664______',				2642,2221,3222,2522
	Player	'P665_______',				4383,2112,3821,2224
	Player	'P666___________',			2593,3333,3332,3322
	dc.w	2						;end of player data: empty String
.tn									;city
	String	'Florida'
.ta									;abbreviation
	String	'FLA'
.tm									;nickname
	String	'N25_____'
.ar									;arena
	String	'Miami Arena'

Anaheim								;ANH
.0									;team data start: offsets to the parts
	dc.w	.pld-.0
	dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	.ls-.0
	dc.w	.sr-.0
	dc.w	.godds-.0
.pad								;new team palettes
	incbin	..\Extracted\NHL94\Graphics\Pals\ANHh.pal
	incbin	..\Extracted\NHL94\Graphics\Pals\ANHv.pal
.sr									;team ratings (qreb,hvxx)
	dc.w	$0702,$1397
.godds								;starting goalie weights
	dc.b	214,0
.ls									;8 lines of 8 player numbers
	dc.b	01,12,14,04,06,08,03,00
	dc.b	01,12,16,03,06,11,04,00
	dc.b	01,14,15,09,08,07,03,00
	dc.b	01,13,18,04,10,05,03,00
	dc.b	01,12,16,04,06,08,04,00
	dc.b	01,13,15,03,09,11,03,00
	dc.b	01,12,14,06,07,04,08,00
	dc.b	01,17,16,04,08,07,06,00
.pld								;player data: one player per row, ended by an empty String
	Player	'P667______',				2962,3332,0000,2222
	Player	'P668_______',				0122,3331,0000,1112
	Player	'P669_______',				2772,2322,1323,3422
	Player	'P670______',				24A2,3232,4621,3213
	Player	'P671_______',				23B1,1021,3A11,2514
	Player	'P672______',				2563,3433,3334,4032
	Player	'P673______',				30A2,2132,2322,3522
	Player	'P674___________',			2073,3343,2033,4032
	Player	'P675________',				2862,3322,2623,2222
	Player	'P676______',				26B2,2112,1514,1323
	Player	'P677_______',				4152,2322,1022,1411
	Player	'P678____________',			07B4,3234,4441,3142
	Player	'P679_____',				3882,2222,3521,2314
	Player	'P680___________',			39B3,3131,2421,3514
	Player	'P681__________',			0382,2222,2520,2213
	Player	'P682________',				33B3,2332,3422,2421
	Player	'P683________',				32B2,1121,2110,2111
	Player	'P684_______',				17B1,1121,3810,2113
	dc.w	2						;end of player data: empty String
.tn									;city
	String	'Anaheim'
.ta									;abbreviation
	String	'ANH'
.tm									;nickname
	String	'N26_________'
.ar									;arena
	String	'Pond'

playoffseats						;32 rows of 16 team numbers (PlayoffRows by
									;PlayoffRowTeams). Not one entry per team.
									;NewPO picks a row at random, then finds the chosen team in that row.
									;All-star teams are not seeded. A new team is inserted into these rows;
									;the row count stays 32.
	dc.b	BUF,BOS,MTL,QUE, NYI,WSH,NJ,PIT, TOR,DET,STL,CHI, LA,CGY,WPG,VAN
	dc.b	NYI,BUF,TB,MTL, QUE,PIT,NYR,BOS, CGY,TOR,LA,VAN, STL,DET,DAL,CHI
	dc.b	NJ,PIT,PHI,BUF, HFD,MTL,WSH,BOS, DAL,TOR,EDM,CHI, SJ,VAN,LA,DET
	dc.b	HFD,PIT,QUE,MTL, WSH,BOS,NJ,BUF, LA,TOR,EDM,DET, DAL,CHI,CGY,VAN
	dc.b	QUE,BUF,NJ,PIT, HFD,MTL,PHI,BOS, CGY,DET,SJ,TOR, DAL,VAN,EDM,CHI
	dc.b	OTW,BOS,HFD,MTL, NYI,PIT,NYR,BUF, SJ,VAN,CGY,DET, DAL,CHI,EDM,TOR
	dc.b	PHI,MTL,OTW,PIT, TB,BUF,NYI,BOS, STL,DET,WPG,CHI, ANH,VAN,CGY,TOR
	dc.b	NJ,BOS,QUE,PIT, PHI,MTL,NYI,BUF, ANH,DET,CGY,CHI, DAL,VAN,LA,TOR

	dc.b	OTW,PIT,HFD,BOS, FLA,MTL,WSH,BUF, CGY,TOR,DAL,VAN, WPG,CHI,LA,DET
	dc.b	NYR,BUF,PHI,BOS, QUE,MTL,HFD,PIT, WPG,CHI,SJ,DET, STL,VAN,CGY,TOR
	dc.b	PHI,MTL,QUE,BOS, NJ,PIT,NYI,BUF, SJ,DET,WPG,TOR, LA,VAN,CGY,CHI
	dc.b	NYI,PIT,OTW,MTL, NYR,BUF,NJ,BOS, DAL,DET,LA,CHI, SJ,TOR,STL,VAN
	dc.b	QUE,BOS,NYR,BUF, OTW,MTL,PHI,PIT, DAL,VAN,SJ,TOR, EDM,CHI,CGY,DET
	dc.b	NJ,MTL,NYR,PIT, OTW,BOS,HFD,BUF, STL,TOR,SJ,CHI, DAL,DET,EDM,VAN
	dc.b	WSH,NYI,NYR,MTL, PHI,BUF,TB,PIT, TOR,STL,ANH,LA, WPG,CHI,SJ,VAN
	dc.b	QUE,BUF,TB,NYI, NJ,MTL,HFD,PIT, EDM,STL,DAL,LA, SJ,VAN,DET,CHI

	dc.b	BOS,TB,OTW,BUF, NJ,MTL,QUE,PIT, TOR,STL,SJ,LA, DAL,VAN,WPG,CHI
	dc.b	HFD,NYI,NJ,BUF, OTW,MTL,BOS,PIT, CGY,VAN,DAL,LA, TOR,CHI,EDM,STL
	dc.b	OTW,PIT,HFD,MTL, FLA,BUF,NYR,NYI, TOR,STL,WPG,CHI, DET,VAN,EDM,LA
	dc.b	WSH,NYI,NJ,PIT, NYR,BUF,BOS,MTL, DET,VAN,DAL,LA, EDM,CHI,WPG,STL
	dc.b	OTW,MTL,QUE,BUF, BOS,NYI,WSH,PIT, EDM,STL,CGY,LA, WPG,VAN,DET,CHI
	dc.b	OTW,PIT,TB,MTL, QUE,NYI,NJ,BUF, SJ,LA,CGY,CHI, WPG,STL,EDM,VAN
	dc.b	OTW,MTL,PHI,BUF, NJ,FLA,QUE,PIT, DAL,CHI,TOR,LA, WPG,STL,SJ,VAN
	dc.b	NJ,MTL,QUE,PIT, OTW,NYI,PHI,BUF, DET,VAN,SJ,LA, TOR,STL,EDM,CHI

	dc.b	HFD,PIT,QUE,NYI, OTW,MTL,BOS,BUF, DET,CHI,EDM,STL, CGY,LA,TOR,VAN
	dc.b	NYR,NYI,BOS,BUF, WSH,MTL,OTW,PIT, DET,CHI,DAL,VAN, EDM,LA,WPG,STL
	dc.b	HFD,BUF,OTW,NYI, NJ,PIT,BOS,MTL, TOR,LA,CGY,STL, DET,VAN,SJ,CHI
	dc.b	QUE,NYI,TB,BUF, BOS,MTL,FLA,PIT, EDM,LA,WPG,STL, CGY,CHI,DAL,VAN
	dc.b	HFD,MTL,NJ,NYI, WSH,BUF,QUE,PIT, SJ,STL,ANH,VAN, CGY,CHI,DET,LA
	dc.b	NYR,BUF,FLA,TB, WSH,PIT,BOS,MTL, TOR,CHI,WPG,VAN, DAL,LA,ANH,STL
	dc.b	NJ,MTL,OTW,BUF, TB,PIT,NYR,NYI, EDM,LA,SJ,CHI, ANH,VAN,DET,STL
	dc.b	WSH,FLA,NJ,PIT, BOS,MTL,TB,BUF, SJ,STL,DET,CHI, ANH,LA,WPG,VAN
PlayoffSeatsEnd						;end of playoffseats (size check below)
	IF (PlayoffSeatsEnd-playoffseats)<>(PlayoffRows*PlayoffRowTeams)
		inform	3,"playoffseats must be 32 rows of 16 teams"
	ENDIF

Credits								;title screen scroller: movea.l #Credits (copyright lines), then
									;#CreditsList
	String	'$ 1993 Electronic Arts'
	String	'Licensed by'
	String	'Sega Enterprises Ltd.'
	String	CC_PageEnd

CreditsList							;the credits after the copyright lines
	String	'Design adapted by'
	String	'Michael Brook'
	String	CC_PageEnd

	String	'Programmed by'
	String	'Mark Lesser'
	String	CC_PageEnd

	String	'Graphics by'
	String	'Doug Wike'
	String	CC_PageEnd

	String	'Based on NHLPA 93 by'
	String	'Jim Simmons'
	String	CC_PageEnd

	String	'Music and Sound by'
	String	'Rob Hubbard'
	String	CC_PageEnd

	String	'Organ Music by'
	String	'Dieter Ruehle'
	String	CC_PageEnd

	String	'Executive Producer'
	String	'Scott Orr'
	String	CC_PageEnd

	String	'Produced by'
	String	'Michael Brook'
	String	CC_PageEnd

	String	'Assistant Producer'
	String	'Kevin Hogan'
	String	CC_PageEnd

	String	'Technical Directors'
	String	'Rob Harris'
	String	'Lon Meinecke'
	String	CC_PageEnd

	String	'Testing by'
	String	'Yun Shin'
	String	'Ken Rogers'
	String	'Craig Wike'
	String	CC_PageEnd

	String	'Testing by'
	String	'John Boerio'
	String	'Jed Garvey'
	String	'Gabe Boys'
	String	CC_PageEnd

	String	'Player Ratings by'
	String	'Igor Kuperman'
	String	CC_PageEnd

	String	'Player Card Photos by'
	String	'Steve Babineau'
	String	CC_PageEnd

	String	'Special Thanks to'
	String	'Bob Borgen'
	String	'Dan Brook'
	String	'Julie Cressa'
	String	CC_PageEnd

	String	'Special Thanks to'
	String	'Randy Delucchi'
	String	'Jeff Fennel'
	String	'Chip Lange'
	String	CC_PageEnd

	String	'Special Thanks to'
	String	'Barry Melrose'
	String	'Scott Probin'
	String	'Ian Pulver'
	String	CC_PageEnd

	String	'Special Thanks to'
	String	'Mike Rubinelli'
	String	'Kyra Woody'
	String	CC_PageEnd

	String	'EA Hockey League Champion'
	String	'Kevin Hogan'
	String	CC_PageEnd

	dc.w	2
	String	CC_PageEnd

	String	CC_PageEnd
