;	HOCKEY.BIN $0-$5431 (runtime $1B000-$20431): teamdata94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	The file header (jmp to Begin, a word, null, TeamList) and the team data. The player names and team
;	nicknames are licensed: those lines are incbin from the disc file, with the line (text masked, ratings and
;	the P id kept) as the comment; every block with no cartridge twin is read from the disc file too.
;
;	The record structure, palettes, lines and ratings are the cartridge source. TeamList keeps the cartridge
;	order (team number = index); the records are laid out in another order, Florida and Anaheim last.

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

Begin	equ	$22096

	org	$1B000

	jmp	Begin						;the file header: the loader enters the game here
	dc.w	$01FF					;not known
null								;a zero long, the tile pointer when there is nothing to draw
	dc.l	0
TeamList							;the team record pointers; team number = index
	dc.l	Anaheim					;0
	dc.l	Boston					;1
	dc.l	Buffalo					;2
	dc.l	Calgary					;3
	dc.l	Chicago					;4
	dc.l	Dallas					;5
	dc.l	Detroit					;6
	dc.l	Edmonton				;7
	dc.l	Florida					;8
	dc.l	Hartford				;9
	dc.l	LosAngeles				;10
	dc.l	Montreal				;11
	dc.l	NewJersey				;12
	dc.l	NewYorkI				;13
	dc.l	NewYorkR				;14
	dc.l	Ottawa					;15
	dc.l	Philadelphia			;16
	dc.l	Pittsburgh				;17
	dc.l	Quebec					;18
	dc.l	SanJose					;19
	dc.l	StLouis					;20
	dc.l	TampaBay				;21
	dc.l	Toronto					;22
	dc.l	Vancouver				;23
	dc.l	Washington				;24
	dc.l	Winnipeg				;25
	dc.l	AllStarsEast			;26
	dc.l	AllStarsWest			;27

;NumofTeams	=	(*-TeamList)/4		;number of teams in TeamList	(defined in hockey.inc)
;NumTeams	=	NumofTeams			;same count; the rest of the code uses this name. ram94.asm	(defined in
;hockey.inc)
									;checks it against ASW+1 once the team numbers are defined.
;Playerdata	=	0					;record offset of the word offset to the player data (.pld)	(defined in
;hockey.inc)
;Palettedata	=	2					;record offset of the word offset to the palettes (.pad)	(defined
;in hockey.inc)
;Teamname	=	4					;record offset of the word offset to the team name (.tn)	(defined in
;hockey.inc)
;LineSets	=	6					;record offset of the word offset to the line sets (.ls)	(defined in
;hockey.inc)
;ScoutReport	=	8					;record offset of the word offset to the scouting report ratings
;(.sr)	(defined in hockey.inc)
;GoalieOdds	=	10					;record offset of the word offset to the starting goalie weights
;(.godds)	(defined in hockey.inc)

AllStarsEast						;team record: All Stars East (ASE), team 26
.0									;record base: six word offsets (Playerdata ... GoalieOdds) from here
	dc.w	.pld-.0					;Playerdata
	dc.w	.pad-.0					;Palettedata
	dc.w	.tn-.0					;Teamname
	dc.w	.ls-.0					;LineSets
	dc.w	.sr-.0					;ScoutReport
	dc.w	.godds-.0				;GoalieOdds
.pad								;team palettes (home and visitor)
	incbin	..\cdbin\HOCKEY.BIN,$88,32	;home colors (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$A8,32	;visitor colors (from the disc file)
;------------------------
;q - scoring odds offense row (bits 4-6, SetScore)
;r - scoring odds defense row (bits 0-2)
;e - penalty kill deficit
;b - power play bonus

;h - home bonus
;v - visitor bonus (negated)
;f - forward count (GetForwardCount)
;x - not read
;------------------------
.sr									;scouting report ratings
;			qreb,hvfx
	dc.w	$7720,$00E8
.godds								;starting goalie weights, 4 nibbles (PickStartingGoalie)
	dc.b	203,192
.ls									;line sets: 8 lines of 8 roster numbers, by position
;			-G,LD,RD,LW,-C,RW,XA,00
	dc.b	01,19,18,07,04,16,09,00	;line 1 NLC (no line changes)
	dc.b	01,19,18,07,04,16,10,00	;line 2 Sc1
	dc.b	01,22,20,11,10,17,07,00	;line 3 Sc2
	dc.b	01,23,24,05,12,14,07,00	;line 4 Chk
	dc.b	01,19,22,07,04,16,09,00	;line 5 PP1
	dc.b	01,18,21,08,09,17,07,00	;line 6 PP2
	dc.b	01,19,23,13,05,06,15,00	;line 7 PK1
	dc.b	01,24,25,15,06,05,13,00	;line 8 PK2
;------------------------
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
.pld								;player data: one player per row, ended by an empty String
;									unwl,sodp,chga,eytm
	incbin	..\cdbin\HOCKEY.BIN,$10E,22	;Player	<text>,		3366,4446,0100,5566 ;P001 Card061
	incbin	..\cdbin\HOCKEY.BIN,$124,20	;Player	<text>,		3175,4555,0000,4455 ;P002 Card011
	incbin	..\cdbin\HOCKEY.BIN,$138,22	;Player	<text>,		35A4,4554,0000,4444 ;P003 Card091
	incbin	..\cdbin\HOCKEY.BIN,$14E,24	;Player	<text>,	66A5,4644,3366,6062 ;P004 Card092
	incbin	..\cdbin\HOCKEY.BIN,$166,22	;Player	<text>,		11A5,4443,5453,4053 ;P005 Card074
	incbin	..\cdbin\HOCKEY.BIN,$17C,22	;Player	<text>,		1094,4444,4444,4143 ;P006 Card064
	incbin	..\cdbin\HOCKEY.BIN,$192,20	;Player	<text>,		1275,4653,3154,5061 ;P007 Card003
	incbin	..\cdbin\HOCKEY.BIN,$1A6,20	;Player	<text>,		1964,4544,2045,5252 ;P008 Card100
	incbin	..\cdbin\HOCKEY.BIN,$1BA,24	;Player	<text>,	7894,4534,3445,5141 ;P009 Card045
	incbin	..\cdbin\HOCKEY.BIN,$1D2,24	;Player	<text>,	1655,4643,3354,6052 ;P010 Card008
	incbin	..\cdbin\HOCKEY.BIN,$1EA,24	;Player	<text>,	25B3,4533,3644,5344 ;P011 Card093
	incbin	..\cdbin\HOCKEY.BIN,$202,22	;Player	<text>,		68A5,4433,4453,4142 ;P012 Card094
	incbin	..\cdbin\HOCKEY.BIN,$218,22	;Player	<text>,		1364,6433,2044,4232 ;P013 Card136
	incbin	..\cdbin\HOCKEY.BIN,$22E,22	;Player	<text>,		2275,5445,2353,5552 ;P014 Card076
	incbin	..\cdbin\HOCKEY.BIN,$244,22	;Player	<text>,		2392,2544,3735,4134 ;P015
	incbin	..\cdbin\HOCKEY.BIN,$25A,26	;Player	<text>,	8976,6634,2455,4452 ;P016 Card007
	incbin	..\cdbin\HOCKEY.BIN,$274,22	;Player	<text>,		0865,4534,3445,4143 ;P017 Card088
	incbin	..\cdbin\HOCKEY.BIN,$28A,22	;Player	<text>,		55A4,3454,3242,5143 ;P018 Card095
	incbin	..\cdbin\HOCKEY.BIN,$2A0,22	;Player	<text>,		77A5,4465,6055,6252 ;P019 Card002
	incbin	..\cdbin\HOCKEY.BIN,$2B6,22	;Player	<text>,		0266,3444,2651,5252 ;P020 Card077
	incbin	..\cdbin\HOCKEY.BIN,$2CC,24	;Player	<text>,	2884,4444,2442,4142 ;P021 Card099
	incbin	..\cdbin\HOCKEY.BIN,$2E4,20	;Player	<text>,		34B4,4446,4642,4444 ;P022 Card138
	incbin	..\cdbin\HOCKEY.BIN,$2F8,24	;Player	<text>,	04B4,4344,5642,5043 ;P023 Card067
	incbin	..\cdbin\HOCKEY.BIN,$310,26	;Player	<text>,	03A5,4454,4442,5133 ;P024 Card041
	incbin	..\cdbin\HOCKEY.BIN,$32A,22	;Player	<text>,		2685,4344,3641,4442 ;P025
	dc.b	0,2						;end of player data: empty String
.tn									;team name: city string (Teamname)
	String	'All Stars East'
.ta									;team abbreviation string
	String	'ASE'
;CD: no cartridge twin
	incbin	..\cdbin\HOCKEY.BIN,$358,18	;read from the disc file
.ar									;arena string
	String	'Madison Square Garden'

AllStarsWest						;team record: All Stars West (ASW), team 27
.0									;record base: six word offsets (Playerdata ... GoalieOdds) from here
	dc.w	.pld-.0					;Playerdata
	dc.w	.pad-.0					;Palettedata
	dc.w	.tn-.0					;Teamname
	dc.w	.ls-.0					;LineSets
	dc.w	.sr-.0					;ScoutReport
	dc.w	.godds-.0				;GoalieOdds
.pad								;team palettes (home and visitor)
	incbin	..\cdbin\HOCKEY.BIN,$38E,32	;home colors (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$3AE,32	;visitor colors (from the disc file)
.sr									;scouting report ratings
;			qreb,hvfx
	dc.w	$7720,$00E8
.godds								;starting goalie weights, 4 nibbles (PickStartingGoalie)
	dc.b	237,144
.ls									;line sets: 8 lines of 8 roster numbers, by position
;			-G,LD,RD,LW,-C,RW,XA,00
	dc.b	01,20,22,11,04,15,14,00	;line 1 NLC (no line changes)
	dc.b	01,24,22,11,04,15,13,00	;line 2 Sc1
	dc.b	01,20,23,14,06,13,04,00	;line 3 Sc2
	dc.b	01,18,21,10,08,12,04,00	;line 4 Chk
	dc.b	01,20,19,11,09,13,04,00	;line 5 PP1
	dc.b	01,18,22,06,04,15,09,00	;line 6 PP2
	dc.b	01,25,21,08,12,09,17,00	;line 7 PK1
	dc.b	01,23,24,09,17,08,12,00	;line 8 PK2
.pld								;player data: one player per row, ended by an empty String
;									unwl,sodp,chga,eytm
	incbin	..\cdbin\HOCKEY.BIN,$414,20	;Player	<text>,		3066,4665,0000,6655 ;P026 Card019
	incbin	..\cdbin\HOCKEY.BIN,$428,24	;Player	<text>,	3264,4444,0000,4344 ;P027 Card025
	incbin	..\cdbin\HOCKEY.BIN,$440,22	;Player	<text>,		2964,4664,0000,4444 ;P028 Card121
	incbin	..\cdbin\HOCKEY.BIN,$456,24	;Player	<text>,	1966,5644,1155,6152 ;P029 Card026
	incbin	..\cdbin\HOCKEY.BIN,$46E,22	;Player	<text>,		0975,5445,2452,5243 ;P030 Card056
	incbin	..\cdbin\HOCKEY.BIN,$484,24	;Player	<text>,	2745,5445,2355,5253 ;P031 Card020
	incbin	..\cdbin\HOCKEY.BIN,$49C,24	;Player	<text>,	2344,3434,3335,4233 ;P032 Card115
	incbin	..\cdbin\HOCKEY.BIN,$4B4,22	;Player	<text>,		9345,4554,4444,6043 ;P033 Card122
	incbin	..\cdbin\HOCKEY.BIN,$4CA,24	;Player	<text>,	9946,4542,2262,6060 ;P034 Card050
	incbin	..\cdbin\HOCKEY.BIN,$4E2,22	;Player	<text>,		1174,4544,4845,5134 ;P035 Card014
	incbin	..\cdbin\HOCKEY.BIN,$4F8,24	;Player	<text>,	2074,4534,2456,5243 ;P036 Card051
	incbin	..\cdbin\HOCKEY.BIN,$510,24	;Player	<text>,	1435,5454,4743,6133 ;P037 Card015
	incbin	..\cdbin\HOCKEY.BIN,$528,20	;Player	<text>,		1694,4536,3353,4432 ;P038 Card111
	incbin	..\cdbin\HOCKEY.BIN,$53C,20	;Player	<text>,		1055,6544,2054,4442 ;P039 Card129
	incbin	..\cdbin\HOCKEY.BIN,$550,24	;Player	<text>,	1365,6534,3345,5442 ;P040 Card140
	incbin	..\cdbin\HOCKEY.BIN,$568,22	;Player	<text>,		1874,4323,1342,4531 ;P041 Card105
	incbin	..\cdbin\HOCKEY.BIN,$57E,20	;Player	<text>,		1784,3444,2143,4132 ;P042
	incbin	..\cdbin\HOCKEY.BIN,$592,20	;Player	<text>,		2275,4454,4642,5243 ;P043 Card016
	incbin	..\cdbin\HOCKEY.BIN,$5A6,20	;Player	<text>,		2193,3445,2343,5142 ;P044 Card113
	incbin	..\cdbin\HOCKEY.BIN,$5BA,22	;Player	<text>,		7796,5434,2461,5153 ;P045 Card028
	incbin	..\cdbin\HOCKEY.BIN,$5D0,24	;Player	<text>,	0774,4465,4751,6245 ;P046 Card022
	incbin	..\cdbin\HOCKEY.BIN,$5E8,22	;Player	<text>,		0666,5433,2462,4062 ;P047 Card141
	incbin	..\cdbin\HOCKEY.BIN,$5FE,22	;Player	<text>,		2494,4355,4A41,5434 ;P048 Card032
	incbin	..\cdbin\HOCKEY.BIN,$614,22	;Player	<text>,		05B4,4344,4641,5244 ;P049 Card023
	incbin	..\cdbin\HOCKEY.BIN,$62A,24	;Player	<text>,	0394,3444,3641,4234 ;P050 Card029
	dc.b	0,2						;end of player data: empty String
.tn									;team name: city string (Teamname)
	String	'All Stars West'
.ta									;team abbreviation string
	String	'ASW'
;CD: no cartridge twin
	incbin	..\cdbin\HOCKEY.BIN,$65A,18	;read from the disc file
.ar									;arena string
	String	'Madison Square Garden'

Boston								;team record: Boston (BOS), team 1
.0									;record base: six word offsets (Playerdata ... GoalieOdds) from here
	dc.w	.pld-.0					;Playerdata
	dc.w	.pad-.0					;Palettedata
	dc.w	.tn-.0
	dc.w	.ls-.0					;LineSets
	dc.w	.sr-.0					;ScoutReport
	dc.w	.godds-.0				;GoalieOdds
.pad								;team palettes (home and visitor)
	incbin	..\cdbin\HOCKEY.BIN,$690,32	;home colors (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$6B0,32	;visitor colors (from the disc file)
.sr									;scouting report ratings
;			qreb,hvfx
	dc.w	$4121,$21F7
.godds								;starting goalie weights, 4 nibbles (PickStartingGoalie)
	dc.b	180,0
.ls									;line sets: 8 lines of 8 roster numbers, by position
;			-G,LD,RD,LW,-C,RW,XA,00
	dc.b	01,19,18,07,03,12,08,00	;line 1 NLC (no line changes)
	dc.b	01,19,18,08,03,12,05,00	;line 2 Sc1
	dc.b	01,20,21,07,05,13,03,00	;line 3 Sc2
	dc.b	01,22,23,09,04,14,03,00	;line 4 Chk
	dc.b	01,20,18,08,03,12,05,00	;line 5 PP1
	dc.b	01,22,21,07,05,13,03,00	;line 6 PP2
;CD: no cartridge twin
	incbin	..\cdbin\HOCKEY.BIN,$706,8	;read from the disc file
	dc.b	01,20,21,03,06,09,04,00	;line 8 PK2
.pld								;player data: one player per row, ended by an empty String
;									unwl,sodp,chga,eytm
	incbin	..\cdbin\HOCKEY.BIN,$716,20	;Player	<text>,		3544,4224,0000,4343 ;P051 Card001
	incbin	..\cdbin\HOCKEY.BIN,$72A,20	;Player	<text>,		3963,4553,0000,4343 ;P052
	incbin	..\cdbin\HOCKEY.BIN,$73E,20	;Player	<text>,		1275,4653,3154,5061 ;P053 Card003
	incbin	..\cdbin\HOCKEY.BIN,$752,22	;Player	<text>,		1974,3343,4433,4142 ;P054
	incbin	..\cdbin\HOCKEY.BIN,$768,26	;Player	<text>,	38A4,4334,2643,3332 ;P055
	incbin	..\cdbin\HOCKEY.BIN,$782,20	;Player	<text>,		2143,4343,3033,3332 ;P056
	incbin	..\cdbin\HOCKEY.BIN,$796,20	;Player	<text>,		4954,4434,2043,4041 ;P057 Card005
	incbin	..\cdbin\HOCKEY.BIN,$7AA,28	;Player	<text>,	1064,4423,2043,4241 ;P058
	incbin	..\cdbin\HOCKEY.BIN,$7C6,20	;Player	<text>,		1792,3333,1424,4420 ;P059
	incbin	..\cdbin\HOCKEY.BIN,$7DA,28	;Player	<text>,	1364,4222,1233,2431 ;P060
	incbin	..\cdbin\HOCKEY.BIN,$7F6,22	;Player	<text>,		4263,3132,3632,2534 ;P061
	incbin	..\cdbin\HOCKEY.BIN,$80C,20	;Player	<text>,		08A4,4544,4945,5344 ;P062 Card006
	incbin	..\cdbin\HOCKEY.BIN,$820,24	;Player	<text>,	2763,3333,3732,4533 ;P063
	incbin	..\cdbin\HOCKEY.BIN,$838,24	;Player	<text>,	2363,3333,3333,3531 ;P064
	incbin	..\cdbin\HOCKEY.BIN,$850,20	;Player	<text>,		1863,3223,2533,2322 ;P065
	incbin	..\cdbin\HOCKEY.BIN,$864,22	;Player	<text>,		2991,1211,2924,1315 ;P066
	incbin	..\cdbin\HOCKEY.BIN,$87A,22	;Player	<text>,		1683,4333,2533,2421 ;P067
	incbin	..\cdbin\HOCKEY.BIN,$890,22	;Player	<text>,		77A5,4465,6055,6252 ;P068 Card002
	incbin	..\cdbin\HOCKEY.BIN,$8A6,22	;Player	<text>,		3244,4344,4441,4142 ;P069 Card004
	incbin	..\cdbin\HOCKEY.BIN,$8BC,22	;Player	<text>,		2685,4344,3641,4442 ;P070
	incbin	..\cdbin\HOCKEY.BIN,$8D2,20	;Player	<text>,		3492,2242,3322,4523 ;P071
	incbin	..\cdbin\HOCKEY.BIN,$8E6,24	;Player	<text>,	1473,2231,3423,3023 ;P073
	incbin	..\cdbin\HOCKEY.BIN,$8FE,26	;Player	<text>,	06B3,3222,4823,2324 ;P074
	incbin	..\cdbin\HOCKEY.BIN,$918,20	;Player	<text>,		36A2,1221,2820,2324 ;P075
	dc.b	0,2						;end of player data: empty String
.tn									;team name: city string (Teamname)
	String	'Boston'
.ta									;team abbreviation string
	String	'BOS'
.tm									;team nickname string
	incbin	..\cdbin\HOCKEY.BIN,$93C,8	;String	<text>
.ar									;arena string
	String	'Boston Garden'

Buffalo								;team record: Buffalo (BUF), team 2
.0									;record base: six word offsets (Playerdata ... GoalieOdds) from here
	dc.w	$0092					;dc.w	.pld-.0
	dc.w	.pad-.0					;Palettedata
	dc.w	.tn-.0
	dc.w	$0052					;dc.w	.ls-.0
	dc.w	$004C					;dc.w	.sr-.0
	dc.w	$0050					;dc.w	.godds-.0
.pad								;team palettes (home and visitor)
	incbin	..\cdbin\HOCKEY.BIN,$960,32	;home colors (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$980,32	;visitor colors (from the disc file)
;CD: no cartridge twin
	incbin	..\cdbin\HOCKEY.BIN,$9A0,90	;read from the disc file
	incbin	..\cdbin\HOCKEY.BIN,$9FA,20	;Player	<text>,		3562,3332,0000,2222 ;P077
	incbin	..\cdbin\HOCKEY.BIN,$A0E,24	;Player	<text>,	3943,3552,0000,2222 ;P078
	incbin	..\cdbin\HOCKEY.BIN,$A26,24	;Player	<text>,	1655,4643,3354,6052 ;P079 Card008
	incbin	..\cdbin\HOCKEY.BIN,$A3E,24	;Player	<text>,	1065,4443,2051,3052 ;P080 Card009
	incbin	..\cdbin\HOCKEY.BIN,$A56,22	;Player	<text>,		2094,2353,4734,4233 ;P081
	incbin	..\cdbin\HOCKEY.BIN,$A6C,22	;Player	<text>,		1462,2232,2623,2022 ;P082
	incbin	..\cdbin\HOCKEY.BIN,$A82,20	;Player	<text>,		1981,5332,3622,3423 ;P083
	incbin	..\cdbin\HOCKEY.BIN,$A96,22	;Player	<text>,		1374,3344,3134,3332 ;P084
	incbin	..\cdbin\HOCKEY.BIN,$AAC,18	;Player	<text>,			2792,2222,3A23,2514 ;P085
	incbin	..\cdbin\HOCKEY.BIN,$ABE,20	;Player	<text>,		1264,4242,4432,4523 ;P086
	incbin	..\cdbin\HOCKEY.BIN,$AD2,18	;Player	<text>,			32A3,4111,3A22,1514 ;P087
	incbin	..\cdbin\HOCKEY.BIN,$AE4,26	;Player	<text>,	8976,6634,2455,4452 ;P088 Card007
	incbin	..\cdbin\HOCKEY.BIN,$AFE,24	;Player	<text>,	1863,3334,2723,3323 ;P089
	incbin	..\cdbin\HOCKEY.BIN,$B16,24	;Player	<text>,	2853,3333,2933,3523 ;P090
	incbin	..\cdbin\HOCKEY.BIN,$B2E,26	;Player	<text>,	1784,4231,3523,2522 ;P092
	incbin	..\cdbin\HOCKEY.BIN,$B48,22	;Player	<text>,		08A2,3342,3621,4133 ;P093 Card010
	incbin	..\cdbin\HOCKEY.BIN,$B5E,22	;Player	<text>,		0754,4343,3640,4033 ;P094 Card012
	incbin	..\cdbin\HOCKEY.BIN,$B74,26	;Player	<text>,	42A3,3343,4431,3032 ;P095
	incbin	..\cdbin\HOCKEY.BIN,$B8E,20	;Player	<text>,		4182,2242,1412,3232 ;P096
	incbin	..\cdbin\HOCKEY.BIN,$BA2,24	;Player	<text>,	0394,3231,3C10,2323 ;P097
	incbin	..\cdbin\HOCKEY.BIN,$BBA,24	;Player	<text>,	3491,2231,3B11,2225 ;P098
	incbin	..\cdbin\HOCKEY.BIN,$BD2,22	;Player	<text>,		24A3,2212,3921,1124 ;P099
	incbin	..\cdbin\HOCKEY.BIN,$BE8,22	;Player	<text>,		0692,3212,3622,1424 ;P100
	dc.b	0,2						;end of player data: empty String
.tn									;team name: city string (Teamname)
	String	'Buffalo'
.ta									;team abbreviation string
	String	'BUF'
.tm									;team nickname string
	incbin	..\cdbin\HOCKEY.BIN,$C10,8	;String	<text>
.ar									;arena string
	String	'Memorial Auditorium'

Calgary								;team record: Calgary (CGY), team 3
.0									;record base: six word offsets (Playerdata ... GoalieOdds) from here
	dc.w	.pld-.0					;Playerdata
	dc.w	.pad-.0					;Palettedata
	dc.w	.tn-.0
	dc.w	$0052					;dc.w	.ls-.0
	dc.w	$004C					;dc.w	.sr-.0
	dc.w	$0050					;dc.w	.godds-.0
.pad								;team palettes (home and visitor)
	incbin	..\cdbin\HOCKEY.BIN,$C3A,32	;home colors (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$C5A,32	;visitor colors (from the disc file)
;CD: no cartridge twin
	incbin	..\cdbin\HOCKEY.BIN,$C7A,70	;read from the disc file
.pld								;player data: one player per row, ended by an empty String
;									unwl,sodp,chga,eytm
	incbin	..\cdbin\HOCKEY.BIN,$CC0,22	;Player	<text>,		3043,4444,0000,4433 ;P101 Card013
	incbin	..\cdbin\HOCKEY.BIN,$CD6,20	;Player	<text>,		3542,3442,0000,2233 ;P102
	incbin	..\cdbin\HOCKEY.BIN,$CEA,24	;Player	<text>,	2584,4434,3444,4322 ;P103 Card018
	incbin	..\cdbin\HOCKEY.BIN,$D02,24	;Player	<text>,	2664,4434,2444,3242 ;P104
	incbin	..\cdbin\HOCKEY.BIN,$D1A,20	;Player	<text>,		29B4,3352,5734,4124 ;P105
	incbin	..\cdbin\HOCKEY.BIN,$D2E,22	;Player	<text>,		1074,4544,4845,5134 ;P107 Card014
	incbin	..\cdbin\HOCKEY.BIN,$D44,22	;Player	<text>,		2884,4343,1343,3431 ;P108
	incbin	..\cdbin\HOCKEY.BIN,$D5A,22	;Player	<text>,		15A3,3343,4632,4433 ;P109
	incbin	..\cdbin\HOCKEY.BIN,$D70,24	;Player	<text>,	1173,4232,2433,2321 ;P110
	incbin	..\cdbin\HOCKEY.BIN,$D88,22	;Player	<text>,		1692,3112,2A11,1414 ;P111
	incbin	..\cdbin\HOCKEY.BIN,$D9E,24	;Player	<text>,	1435,5454,4743,6133 ;P112 Card015
	incbin	..\cdbin\HOCKEY.BIN,$DB6,24	;Player	<text>,	4265,4422,1054,3052 ;P113
	incbin	..\cdbin\HOCKEY.BIN,$DCE,24	;Player	<text>,	2372,2313,2134,2220 ;P114
	incbin	..\cdbin\HOCKEY.BIN,$DE6,22	;Player	<text>,		2282,2212,3723,1324 ;P115
	incbin	..\cdbin\HOCKEY.BIN,$DFC,20	;Player	<text>,		2075,4454,4642,5243 ;P116 Card016
	incbin	..\cdbin\HOCKEY.BIN,$E10,22	;Player	<text>,		0284,4436,3541,5243 ;P117 Card017
	incbin	..\cdbin\HOCKEY.BIN,$E26,26	;Player	<text>,	3474,3222,3431,2332 ;P118
	incbin	..\cdbin\HOCKEY.BIN,$E40,22	;Player	<text>,		1873,2242,3630,3133 ;P119
	incbin	..\cdbin\HOCKEY.BIN,$E56,22	;Player	<text>,		0394,4232,3621,3523 ;P120
	incbin	..\cdbin\HOCKEY.BIN,$E6C,22	;Player	<text>,		0793,3234,3941,3333 ;P121
	incbin	..\cdbin\HOCKEY.BIN,$E82,20	;Player	<text>,		0472,3242,3331,3132 ;P122
	incbin	..\cdbin\HOCKEY.BIN,$E96,26	;Player	<text>,	0583,3143,3431,3523 ;P123
	incbin	..\cdbin\HOCKEY.BIN,$EB0,20	;Player	<text>,		06A0,0100,1901,1404 ;P125
	dc.b	0,2						;end of player data: empty String
.tn									;team name: city string (Teamname)
	String	'Calgary'
.ta									;team abbreviation string
	String	'CGY'
.tm									;team nickname string
	incbin	..\cdbin\HOCKEY.BIN,$ED6,8	;String	<text>
.ar									;arena string
	String	'Olympic Saddledome'

Chicago								;team record: Chicago (CHI), team 4
.0									;record base: six word offsets (Playerdata ... GoalieOdds) from here
	dc.w	.pld-.0					;Playerdata
	dc.w	.pad-.0					;Palettedata
	dc.w	.tn-.0
	dc.w	$0052					;dc.w	.ls-.0
	dc.w	$004C					;dc.w	.sr-.0
	dc.w	$0050					;dc.w	.godds-.0
.pad								;team palettes (home and visitor)
	incbin	..\cdbin\HOCKEY.BIN,$EFE,32	;home colors (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$F1E,32	;visitor colors (from the disc file)
;CD: no cartridge twin
	incbin	..\cdbin\HOCKEY.BIN,$F3E,70	;read from the disc file
.pld								;player data: one player per row, ended by an empty String
;									unwl,sodp,chga,eytm
	incbin	..\cdbin\HOCKEY.BIN,$F84,20	;Player	<text>,		3066,4665,0000,6655 ;P126 Card019
	incbin	..\cdbin\HOCKEY.BIN,$F98,20	;Player	<text>,		2963,3332,0000,2233 ;P127
	incbin	..\cdbin\HOCKEY.BIN,$FAC,24	;Player	<text>,	2745,5445,2355,5253 ;P128 Card020
	incbin	..\cdbin\HOCKEY.BIN,$FC4,26	;Player	<text>,	2284,4343,4442,4243 ;P129
	incbin	..\cdbin\HOCKEY.BIN,$FDE,22	;Player	<text>,		1263,2453,4343,5133 ;P130
	incbin	..\cdbin\HOCKEY.BIN,$FF4,22	;Player	<text>,		1984,3242,4331,3533 ;P131
	incbin	..\cdbin\HOCKEY.BIN,$100A,24	;Player	<text>,	1684,3332,2635,3312 ;P132 Card024
	incbin	..\cdbin\HOCKEY.BIN,$1022,26	;Player	<text>,	3282,2321,3623,3213 ;P133
	incbin	..\cdbin\HOCKEY.BIN,$103C,22	;Player	<text>,		1472,2332,4633,3112 ;P134
	incbin	..\cdbin\HOCKEY.BIN,$1052,26	;Player	<text>,	2693,4334,2622,2213 ;P135
	incbin	..\cdbin\HOCKEY.BIN,$106C,22	;Player	<text>,		2874,4464,4444,6342 ;P137 Card021
	incbin	..\cdbin\HOCKEY.BIN,$1082,22	;Player	<text>,		3384,3353,4732,4534 ;P138
	incbin	..\cdbin\HOCKEY.BIN,$1098,22	;Player	<text>,		1073,3334,3343,4533 ;P139
	incbin	..\cdbin\HOCKEY.BIN,$10AE,24	;Player	<text>,	2583,3233,2331,3231 ;P140
	incbin	..\cdbin\HOCKEY.BIN,$10C6,20	;Player	<text>,		1774,4434,3233,4243 ;P141
	incbin	..\cdbin\HOCKEY.BIN,$10DA,20	;Player	<text>,		4464,3322,2841,2024 ;P142
	incbin	..\cdbin\HOCKEY.BIN,$10EE,24	;Player	<text>,	0774,4465,4751,6245 ;P143 Card022
	incbin	..\cdbin\HOCKEY.BIN,$1106,22	;Player	<text>,		05B4,4344,4641,5244 ;P144 Card023
	incbin	..\cdbin\HOCKEY.BIN,$111C,26	;Player	<text>,	0283,3242,4621,3215 ;P145
	incbin	..\cdbin\HOCKEY.BIN,$1136,26	;Player	<text>,	0692,2243,1321,3422 ;P146
	incbin	..\cdbin\HOCKEY.BIN,$1150,20	;Player	<text>,		0392,2132,4620,4223 ;P147
	incbin	..\cdbin\HOCKEY.BIN,$1164,22	;Player	<text>,		0472,2232,3931,3433 ;P148
	incbin	..\cdbin\HOCKEY.BIN,$117A,22	;Player	<text>,		0853,3132,3431,3524 ;P149
	incbin	..\cdbin\HOCKEY.BIN,$1190,22	;Player	<text>,		4792,2111,2520,1412 ;P150
	dc.b	0,2						;end of player data: empty String
.tn									;team name: city string (Teamname)
	String	'Chicago'
.ta									;team abbreviation string
	String	'CHI'
.tm									;team nickname string
	incbin	..\cdbin\HOCKEY.BIN,$11B8,12	;String	<text>
.ar									;arena string
	String	'Chicago Stadium'

Detroit								;team record: Detroit (DET), team 6
.0									;record base: six word offsets (Playerdata ... GoalieOdds) from here
	dc.w	.pld-.0					;Playerdata
	dc.w	.pad-.0					;Palettedata
	dc.w	.tn-.0					;Teamname
	dc.w	.ls-.0					;LineSets
	dc.w	.sr-.0					;ScoutReport
	dc.w	.godds-.0				;GoalieOdds
.pad								;team palettes (home and visitor)
	incbin	..\cdbin\HOCKEY.BIN,$11E2,32	;home colors (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$1202,32	;visitor colors (from the disc file)
.sr									;scouting report ratings
;			qreb,hvfx
	dc.w	$7321,$00F8
.godds								;starting goalie weights, 4 nibbles (PickStartingGoalie)
	dc.b	212,0
.ls									;line sets: 8 lines of 8 roster numbers, by position
;			-G,LD,RD,LW,-C,RW,XA,00
	dc.b	01,19,18,04,03,13,08,00	;line 1 NLC (no line changes)
	dc.b	01,21,25,11,03,13,04,00	;line 2 Sc1
	dc.b	01,18,23,08,04,14,03,00	;line 3 Sc2
	dc.b	01,19,20,09,05,15,03,00	;line 4 Chk
	dc.b	01,18,20,08,03,13,15,00	;line 5 PP1
	dc.b	01,19,21,15,04,14,03,00	;line 6 PP2
	dc.b	01,19,23,08,04,03,05,00	;line 7 PK1
	dc.b	01,21,25,05,03,08,04,00	;line 8 PK2
.pld								;player data: one player per row, ended by an empty String
;									unwl,sodp,chga,eytm
	incbin	..\cdbin\HOCKEY.BIN,$1268,24	;Player	<text>,	3264,4444,0000,4344 ;P151 Card025
	incbin	..\cdbin\HOCKEY.BIN,$1280,26	;Player	<text>,	3763,3222,0000,3223 ;P152
	incbin	..\cdbin\HOCKEY.BIN,$129A,24	;Player	<text>,	1966,5644,1155,6152 ;P153 Card026
	incbin	..\cdbin\HOCKEY.BIN,$12B2,24	;Player	<text>,	9175,4444,3254,4153 ;P154 Card027
	incbin	..\cdbin\HOCKEY.BIN,$12CA,22	;Player	<text>,		2844,4343,2033,4133 ;P155
	incbin	..\cdbin\HOCKEY.BIN,$12E0,24	;Player	<text>,	2373,3332,2332,4021 ;P156
	incbin	..\cdbin\HOCKEY.BIN,$12F8,26	;Player	<text>,	1354,3223,1233,3533 ;P157
	incbin	..\cdbin\HOCKEY.BIN,$1312,24	;Player	<text>,	2174,4443,2644,3342 ;P158
	incbin	..\cdbin\HOCKEY.BIN,$132A,20	;Player	<text>,		1162,2332,4622,3123 ;P159
	incbin	..\cdbin\HOCKEY.BIN,$133E,24	;Player	<text>,	55B3,3343,1624,3124 ;P160
	incbin	..\cdbin\HOCKEY.BIN,$1356,24	;Player	<text>,	1762,2333,4633,3134 ;P161
	incbin	..\cdbin\HOCKEY.BIN,$136E,24	;Player	<text>,	2593,3333,3234,2130 ;P162
	incbin	..\cdbin\HOCKEY.BIN,$1386,26	;Player	<text>,	2255,4425,2355,4143 ;P163 Card030
	incbin	..\cdbin\HOCKEY.BIN,$13A0,22	;Player	<text>,		2662,2433,3334,3222 ;P164
	incbin	..\cdbin\HOCKEY.BIN,$13B6,22	;Player	<text>,		24B4,3333,4A22,4235 ;P165
	incbin	..\cdbin\HOCKEY.BIN,$13CC,26	;Player	<text>,	1543,3322,2324,2522 ;P166
	incbin	..\cdbin\HOCKEY.BIN,$13E6,20	;Player	<text>,		1472,2212,3722,1424 ;P167
	incbin	..\cdbin\HOCKEY.BIN,$13FA,22	;Player	<text>,		7796,5434,2461,5153 ;P168 Card028
	incbin	..\cdbin\HOCKEY.BIN,$1410,24	;Player	<text>,	0394,3444,3641,4234 ;P169 Card029
	incbin	..\cdbin\HOCKEY.BIN,$1428,22	;Player	<text>,		3363,3344,3431,4233 ;P170
	incbin	..\cdbin\HOCKEY.BIN,$143E,26	;Player	<text>,	0554,3344,3441,4241 ;P171
	incbin	..\cdbin\HOCKEY.BIN,$1458,20	;Player	<text>,		0463,3343,3231,3031 ;P172
	incbin	..\cdbin\HOCKEY.BIN,$146C,30	;Player	<text>,	1663,3243,4731,4233 ;P173
	incbin	..\cdbin\HOCKEY.BIN,$148A,24	;Player	<text>,	0883,3232,4421,3233 ;P174
	incbin	..\cdbin\HOCKEY.BIN,$14A2,24	;Player	<text>,	0283,2242,4610,3133 ;P175
	dc.b	0,2						;end of player data: empty String
.tn									;team name: city string (Teamname)
	String	'Detroit'
.ta									;team abbreviation string
	String	'DET'
.tm									;team nickname string
	incbin	..\cdbin\HOCKEY.BIN,$14CC,12	;String	<text>
.ar									;arena string
	String	'Joe Louis Sports Arena'

Edmonton							;team record: Edmonton (EDM), team 7
.0									;record base: six word offsets (Playerdata ... GoalieOdds) from here
	dc.w	$0092					;dc.w	.pld-.0
	dc.w	.pad-.0					;Palettedata
	dc.w	.tn-.0
	dc.w	$0052					;dc.w	.ls-.0
	dc.w	$004C					;dc.w	.sr-.0
	dc.w	$0050					;dc.w	.godds-.0
.pad								;team palettes (home and visitor)
	incbin	..\cdbin\HOCKEY.BIN,$14FC,32	;home colors (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$151C,32	;visitor colors (from the disc file)
;CD: no cartridge twin
	incbin	..\cdbin\HOCKEY.BIN,$153C,92	;read from the disc file
	incbin	..\cdbin\HOCKEY.BIN,$1598,22	;Player	<text>,		3963,3343,3443,3132 ;P178 Card035
	incbin	..\cdbin\HOCKEY.BIN,$15AE,20	;Player	<text>,		3473,4332,2433,3123 ;P179
	incbin	..\cdbin\HOCKEY.BIN,$15C2,26	;Player	<text>,	1484,3242,4432,5223 ;P180
	incbin	..\cdbin\HOCKEY.BIN,$15DC,20	;Player	<text>,		1553,4333,3632,3332 ;P181
	incbin	..\cdbin\HOCKEY.BIN,$15F0,22	;Player	<text>,		2692,2322,2624,2512 ;P182
	incbin	..\cdbin\HOCKEY.BIN,$1606,22	;Player	<text>,		2093,3242,4820,3233 ;P183
	incbin	..\cdbin\HOCKEY.BIN,$161C,24	;Player	<text>,	0994,4343,4642,4234 ;P184 Card034
	incbin	..\cdbin\HOCKEY.BIN,$1634,24	;Player	<text>,	1883,3434,2345,3132 ;P185
	incbin	..\cdbin\HOCKEY.BIN,$164C,22	;Player	<text>,		0874,3333,2033,3230 ;P186
	incbin	..\cdbin\HOCKEY.BIN,$1662,26	;Player	<text>,	16A2,2232,4A13,3213 ;P187
	incbin	..\cdbin\HOCKEY.BIN,$167C,24	;Player	<text>,	0783,3223,2432,2422 ;P188
	incbin	..\cdbin\HOCKEY.BIN,$1694,24	;Player	<text>,	29C1,1212,3C14,1515 ;P189
	incbin	..\cdbin\HOCKEY.BIN,$16AC,20	;Player	<text>,		8575,5324,1355,4533 ;P190 Card036
	incbin	..\cdbin\HOCKEY.BIN,$16C0,22	;Player	<text>,		12B2,2212,1321,1223 ;P192
	incbin	..\cdbin\HOCKEY.BIN,$16D6,22	;Player	<text>,		2494,4355,4A41,5434 ;P193 Card032
	incbin	..\cdbin\HOCKEY.BIN,$16EC,24	;Player	<text>,	2194,3343,3242,4432 ;P194 Card033
	incbin	..\cdbin\HOCKEY.BIN,$1704,24	;Player	<text>,	1982,2343,3622,4234 ;P195
	incbin	..\cdbin\HOCKEY.BIN,$171C,22	;Player	<text>,		2594,3231,1431,3231 ;P196
	incbin	..\cdbin\HOCKEY.BIN,$1732,22	;Player	<text>,		06B3,3234,3421,4323 ;P197
	incbin	..\cdbin\HOCKEY.BIN,$1748,26	;Player	<text>,	22B3,3132,4630,2434 ;P198
	incbin	..\cdbin\HOCKEY.BIN,$1762,22	;Player	<text>,		02A3,3313,3531,1233 ;P199
	incbin	..\cdbin\HOCKEY.BIN,$1778,22	;Player	<text>,		3693,3223,2633,2523 ;P200
	dc.b	0,2						;end of player data: empty String
.tn									;team name: city string (Teamname)
	String	'Edmonton'
.ta									;team abbreviation string
	String	'EDM'
.tm									;team nickname string
	incbin	..\cdbin\HOCKEY.BIN,$17A0,8	;String	<text>
.ar									;arena string
	String	'Northlands Coliseum'

Hartford							;team record: Hartford (HFD), team 9
.0									;record base: six word offsets (Playerdata ... GoalieOdds) from here
	dc.w	.pld-.0					;Playerdata
	dc.w	$000C					;dc.w	.pad-.0
	dc.w	.tn-.0
	dc.w	$0052					;dc.w	.ls-.0
	dc.w	$004C					;dc.w	.sr-.0
	dc.w	$0050					;dc.w	.godds-.0
;CD: no cartridge twin
	incbin	..\cdbin\HOCKEY.BIN,$17CA,134	;read from the disc file
.pld								;player data: one player per row, ended by an empty String
;									unwl,sodp,chga,eytm
	incbin	..\cdbin\HOCKEY.BIN,$1850,20	;Player	<text>,		01A4,3224,0000,4444 ;P201 Card037
	incbin	..\cdbin\HOCKEY.BIN,$1864,24	;Player	<text>,	3132,3442,0000,1122 ;P202
	incbin	..\cdbin\HOCKEY.BIN,$187C,26	;Player	<text>,	4063,3113,0000,2222 ;P203
	incbin	..\cdbin\HOCKEY.BIN,$1896,24	;Player	<text>,	2173,3442,2034,4032 ;P204 Card038
	incbin	..\cdbin\HOCKEY.BIN,$18AE,26	;Player	<text>,	3654,3323,2232,3132 ;P206
	incbin	..\cdbin\HOCKEY.BIN,$18C8,22	;Player	<text>,		3853,3342,2233,3432 ;P207
	incbin	..\cdbin\HOCKEY.BIN,$18DE,28	;Player	<text>,	3954,3223,2231,3433 ;P208
	incbin	..\cdbin\HOCKEY.BIN,$18FA,26	;Player	<text>,	0864,4434,2044,4331 ;P209 Card039
	incbin	..\cdbin\HOCKEY.BIN,$1914,24	;Player	<text>,	24A3,3323,3033,3232 ;P210
	incbin	..\cdbin\HOCKEY.BIN,$192C,24	;Player	<text>,	1182,2232,3812,3311 ;P211
	incbin	..\cdbin\HOCKEY.BIN,$1944,22	;Player	<text>,		3392,2112,2422,2314 ;P212
	incbin	..\cdbin\HOCKEY.BIN,$195A,26	;Player	<text>,	0762,3232,3622,3533 ;P213
	incbin	..\cdbin\HOCKEY.BIN,$1974,22	;Player	<text>,		1673,4434,3744,4244 ;P214 Card040
	incbin	..\cdbin\HOCKEY.BIN,$198A,24	;Player	<text>,	22B3,3333,4633,4124 ;P215
	incbin	..\cdbin\HOCKEY.BIN,$19A2,22	;Player	<text>,		2082,2221,3624,3415 ;P216
	incbin	..\cdbin\HOCKEY.BIN,$19B8,20	;Player	<text>,		1771,1210,1511,1013 ;P217
	incbin	..\cdbin\HOCKEY.BIN,$19CC,22	;Player	<text>,		3483,3212,3923,1520 ;P218
	incbin	..\cdbin\HOCKEY.BIN,$19E2,26	;Player	<text>,	03A5,4454,4442,5133 ;P219 Card041
	incbin	..\cdbin\HOCKEY.BIN,$19FC,24	;Player	<text>,	04A3,4343,3432,4133 ;P220 Card042
	incbin	..\cdbin\HOCKEY.BIN,$1A14,20	;Player	<text>,		0674,3234,3441,4334 ;P221
	incbin	..\cdbin\HOCKEY.BIN,$1A28,22	;Player	<text>,		3772,2231,1622,2513 ;P222
	incbin	..\cdbin\HOCKEY.BIN,$1A3E,20	;Player	<text>,		2772,2122,2921,2414 ;P223
	incbin	..\cdbin\HOCKEY.BIN,$1A52,24	;Player	<text>,	41A2,3132,3621,2123 ;P225
	dc.b	0,2						;end of player data: empty String
.tn									;team name: city string (Teamname)
	String	'Hartford'
.ta									;team abbreviation string
	String	'HFD'
.tm									;team nickname string
	incbin	..\cdbin\HOCKEY.BIN,$1A7C,10	;String	<text>
.ar									;arena string
	String	'Hartford Civic Center'

LosAngeles							;team record: Los Angeles (LA), team 10
.0									;record base: six word offsets (Playerdata ... GoalieOdds) from here
	dc.w	.pld-.0					;Playerdata
	dc.w	.pad-.0					;Palettedata
	dc.w	.tn-.0
	dc.w	$0052					;dc.w	.ls-.0
	dc.w	$004C					;dc.w	.sr-.0
	dc.w	$0050					;dc.w	.godds-.0
.pad								;team palettes (home and visitor)
	incbin	..\cdbin\HOCKEY.BIN,$1AAA,32	;home colors (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$1ACA,32	;visitor colors (from the disc file)
;CD: no cartridge twin
	incbin	..\cdbin\HOCKEY.BIN,$1AEA,70	;read from the disc file
.pld								;player data: one player per row, ended by an empty String
;									unwl,sodp,chga,eytm
	incbin	..\cdbin\HOCKEY.BIN,$1B30,22	;Player	<text>,		3263,3444,0000,2223 ;P226 Card049
	incbin	..\cdbin\HOCKEY.BIN,$1B46,22	;Player	<text>,		3562,3553,0000,2222 ;P227
	incbin	..\cdbin\HOCKEY.BIN,$1B5C,22	;Player	<text>,		0122,3332,0000,2221 ;P228
	incbin	..\cdbin\HOCKEY.BIN,$1B72,24	;Player	<text>,	9946,4542,2262,6060 ;P229 Card050
	incbin	..\cdbin\HOCKEY.BIN,$1B8A,22	;Player	<text>,		1294,4434,2345,4241 ;P230
	incbin	..\cdbin\HOCKEY.BIN,$1BA0,22	;Player	<text>,		2343,4432,1534,3333 ;P231
	incbin	..\cdbin\HOCKEY.BIN,$1BB6,22	;Player	<text>,		1462,2201,2322,0322 ;P232
	incbin	..\cdbin\HOCKEY.BIN,$1BCC,24	;Player	<text>,	2074,4534,2456,5243 ;P233 Card051
	incbin	..\cdbin\HOCKEY.BIN,$1BE4,22	;Player	<text>,		2164,5443,3334,3334 ;P234
	incbin	..\cdbin\HOCKEY.BIN,$1BFA,22	;Player	<text>,		1572,2222,2423,2431 ;P236
	incbin	..\cdbin\HOCKEY.BIN,$1C10,24	;Player	<text>,	1072,2211,3612,1515 ;P237
	incbin	..\cdbin\HOCKEY.BIN,$1C28,26	;Player	<text>,	0794,4535,3845,3233 ;P238 Card052
	incbin	..\cdbin\HOCKEY.BIN,$1C42,20	;Player	<text>,		1784,3444,2143,4132 ;P239
	incbin	..\cdbin\HOCKEY.BIN,$1C56,24	;Player	<text>,	1164,4432,3423,4332 ;P240
	incbin	..\cdbin\HOCKEY.BIN,$1C6E,22	;Player	<text>,		1873,2233,3532,3323 ;P241
	incbin	..\cdbin\HOCKEY.BIN,$1C84,20	;Player	<text>,		04B4,4444,3341,4344 ;P242 Card053
	incbin	..\cdbin\HOCKEY.BIN,$1C98,24	;Player	<text>,	33E3,3343,3932,4436 ;P243 Card054
	incbin	..\cdbin\HOCKEY.BIN,$1CB0,24	;Player	<text>,	0254,4343,3432,4133 ;P244
	incbin	..\cdbin\HOCKEY.BIN,$1CC8,22	;Player	<text>,		2593,3233,3431,3232 ;P245
	incbin	..\cdbin\HOCKEY.BIN,$1CDE,24	;Player	<text>,	22A3,2243,3431,3132 ;P246
	incbin	..\cdbin\HOCKEY.BIN,$1CF6,20	;Player	<text>,		2483,3231,3620,2123 ;P247
	incbin	..\cdbin\HOCKEY.BIN,$1D0A,24	;Player	<text>,	0352,2121,2820,2114 ;P248
	incbin	..\cdbin\HOCKEY.BIN,$1D22,22	;Player	<text>,		0562,2121,2620,2122 ;P249
	incbin	..\cdbin\HOCKEY.BIN,$1D38,26	;Player	<text>,	0881,1010,1510,1313 ;P250
	dc.b	0,2						;end of player data: empty String
.tn									;team name: city string (Teamname)
	String	'Los Angeles'
.ta									;team abbreviation string
	String	'LA'
.tm									;team nickname string
	incbin	..\cdbin\HOCKEY.BIN,$1D66,8	;String	<text>
.ar									;arena string
	String	'Great Western Forum'

Dallas								;team record: Dallas (DAL), team 5
.0									;record base: six word offsets (Playerdata ... GoalieOdds) from here
	dc.w	$0092					;dc.w	.pld-.0
	dc.w	.pad-.0					;Palettedata
	dc.w	.tn-.0
	dc.w	$0052					;dc.w	.ls-.0
	dc.w	$004C					;dc.w	.sr-.0
	dc.w	$0050					;dc.w	.godds-.0
.pad								;team palettes (home and visitor)
	incbin	..\cdbin\HOCKEY.BIN,$1D90,32	;home colors (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$1DB0,32	;visitor colors (from the disc file)
;CD: no cartridge twin
	incbin	..\cdbin\HOCKEY.BIN,$1DD0,90	;read from the disc file
	incbin	..\cdbin\HOCKEY.BIN,$1E2A,24	;Player	<text>,	3562,3333,0000,2232 ;P252
	incbin	..\cdbin\HOCKEY.BIN,$1E42,22	;Player	<text>,		0975,5445,2452,5243 ;P253 Card056
	incbin	..\cdbin\HOCKEY.BIN,$1E58,22	;Player	<text>,		1564,4443,2444,4244 ;P254 Card059
	incbin	..\cdbin\HOCKEY.BIN,$1E6E,22	;Player	<text>,		0744,4353,3032,4341 ;P255
	incbin	..\cdbin\HOCKEY.BIN,$1E84,26	;Player	<text>,	4164,3223,2042,2532 ;P256
	incbin	..\cdbin\HOCKEY.BIN,$1E9E,22	;Player	<text>,		1794,3333,4422,4422 ;P258
	incbin	..\cdbin\HOCKEY.BIN,$1EB4,26	;Player	<text>,	1093,4232,3423,3511 ;P259
	incbin	..\cdbin\HOCKEY.BIN,$1ECE,22	;Player	<text>,		1683,3323,3632,2530 ;P260
	incbin	..\cdbin\HOCKEY.BIN,$1EE4,24	;Player	<text>,	2665,6424,2133,3432 ;P261 Card060
	incbin	..\cdbin\HOCKEY.BIN,$1EFC,20	;Player	<text>,		2283,4433,2044,4330 ;P262
	incbin	..\cdbin\HOCKEY.BIN,$1F10,20	;Player	<text>,		2063,3333,3743,3223 ;P263
	incbin	..\cdbin\HOCKEY.BIN,$1F24,22	;Player	<text>,		2992,2312,1521,1122 ;P264
	incbin	..\cdbin\HOCKEY.BIN,$1F3A,22	;Player	<text>,		2791,2221,2922,2125 ;P265
	incbin	..\cdbin\HOCKEY.BIN,$1F50,24	;Player	<text>,	1273,3221,2022,2513 ;P266
	incbin	..\cdbin\HOCKEY.BIN,$1F68,22	;Player	<text>,		2493,3344,4433,4224 ;P267 Card057
	incbin	..\cdbin\HOCKEY.BIN,$1F7E,22	;Player	<text>,		3364,3334,2131,3331 ;P268 Card058
	incbin	..\cdbin\HOCKEY.BIN,$1F94,22	;Player	<text>,		0672,3242,3631,4143 ;P269
	incbin	..\cdbin\HOCKEY.BIN,$1FAA,24	;Player	<text>,	0293,2232,2421,4224 ;P270
	incbin	..\cdbin\HOCKEY.BIN,$1FC2,22	;Player	<text>,		03C2,2132,3420,3424 ;P271
	incbin	..\cdbin\HOCKEY.BIN,$1FD8,28	;Player	<text>,	0472,3133,3630,3522 ;P272
	incbin	..\cdbin\HOCKEY.BIN,$1FF4,22	;Player	<text>,		2392,2122,2520,1312 ;P273
	incbin	..\cdbin\HOCKEY.BIN,$200A,20	;Player	<text>,		0572,2032,3420,3514 ;P274
	incbin	..\cdbin\HOCKEY.BIN,$201E,24	;Player	<text>,	3991,1022,2820,3525 ;P275
	dc.b	0,2						;end of player data: empty String
.tn									;team name: city string (Teamname)
	String	'Dallas'
.ta									;team abbreviation string
	String	'DAL'
.tm									;team nickname string
	incbin	..\cdbin\HOCKEY.BIN,$2046,8	;String	<text>
.ar									;arena string
	String	'Reunion Arena'

Montreal							;team record: Montreal (MTL), team 11
.0									;record base: six word offsets (Playerdata ... GoalieOdds) from here
	dc.w	.pld-.0					;Playerdata
	dc.w	.pad-.0					;Palettedata
	dc.w	.tn-.0
	dc.w	.ls-.0					;LineSets
	dc.w	.sr-.0					;ScoutReport
	dc.w	.godds-.0				;GoalieOdds
.pad								;team palettes (home and visitor)
	incbin	..\cdbin\HOCKEY.BIN,$206A,32	;home colors (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$208A,32	;visitor colors (from the disc file)
.sr									;scouting report ratings
;			qreb,hvfx
	dc.w	$5211,$21E8
.godds								;starting goalie weights, 4 nibbles (PickStartingGoalie)
	dc.b	197,0
.ls									;line sets: 8 lines of 8 roster numbers, by position
;			-G,LD,RD,LW,-C,RW,XA,00
	dc.b	01,18,17,07,03,12,04,00	;line 1 NLC (no line changes)
	dc.b	01,23,18,07,03,12,04,00	;line 2 Sc1
	dc.b	01,22,17,08,04,14,03,00	;line 3 Sc2
	dc.b	01,19,20,09,05,13,03,00	;line 4 Chk
	dc.b	01,18,17,07,03,12,05,00	;line 5 PP1
	dc.b	01,19,20,08,04,05,03,00	;line 6 PP2
	dc.b	01,17,23,07,06,03,13,00	;line 7 PK1
	dc.b	01,22,19,03,13,07,06,00	;line 8 PK2
.pld								;player data: one player per row, ended by an empty String
;									unwl,sodp,chga,eytm
	incbin	..\cdbin\HOCKEY.BIN,$20F0,22	;Player	<text>,		3366,4446,0000,5566 ;P276 Card061
	incbin	..\cdbin\HOCKEY.BIN,$2106,24	;Player	<text>,	3742,3333,0000,2222 ;P277
	incbin	..\cdbin\HOCKEY.BIN,$211E,22	;Player	<text>,		1194,4444,4444,4143 ;P278 Card064
	incbin	..\cdbin\HOCKEY.BIN,$2134,24	;Player	<text>,	4754,4433,2145,4031 ;P279
	incbin	..\cdbin\HOCKEY.BIN,$214C,22	;Player	<text>,		1855,4433,2353,3043 ;P280
	incbin	..\cdbin\HOCKEY.BIN,$2162,24	;Player	<text>,	2164,3242,4141,3341 ;P281
	incbin	..\cdbin\HOCKEY.BIN,$217A,28	;Player	<text>,	2564,4433,2053,4243 ;P282 Card065
	incbin	..\cdbin\HOCKEY.BIN,$2196,24	;Player	<text>,	4583,4333,2433,3232 ;P283
	incbin	..\cdbin\HOCKEY.BIN,$21AE,22	;Player	<text>,		17B3,4333,3033,3222 ;P284
	incbin	..\cdbin\HOCKEY.BIN,$21C4,24	;Player	<text>,	2262,2322,2223,2222 ;P285
	incbin	..\cdbin\HOCKEY.BIN,$21DC,24	;Player	<text>,	3261,1112,3813,1314 ;P286
	incbin	..\cdbin\HOCKEY.BIN,$21F4,24	;Player	<text>,	2384,4434,2344,4242 ;P287 Card066
	incbin	..\cdbin\HOCKEY.BIN,$220C,20	;Player	<text>,		1253,4432,3323,3033 ;P288
	incbin	..\cdbin\HOCKEY.BIN,$2220,22	;Player	<text>,		2654,4323,2933,3232 ;P289
	incbin	..\cdbin\HOCKEY.BIN,$2236,20	;Player	<text>,		36B1,1211,3712,2314 ;P290
	incbin	..\cdbin\HOCKEY.BIN,$224A,18	;Player	<text>,			3182,2212,3322,1421 ;P291
	incbin	..\cdbin\HOCKEY.BIN,$225C,26	;Player	<text>,	2894,3343,4342,4233 ;P292 Card062
	incbin	..\cdbin\HOCKEY.BIN,$2276,24	;Player	<text>,	2773,4333,3442,4243 ;P293 Card063
	incbin	..\cdbin\HOCKEY.BIN,$228E,28	;Player	<text>,	4353,3333,3722,4323 ;P294
	incbin	..\cdbin\HOCKEY.BIN,$22AA,22	;Player	<text>,		1462,2231,2612,4523 ;P295
	incbin	..\cdbin\HOCKEY.BIN,$22C0,20	;Player	<text>,		0593,2233,4731,3534 ;P296
	incbin	..\cdbin\HOCKEY.BIN,$22D4,26	;Player	<text>,	4864,3244,3432,4422 ;P297
	incbin	..\cdbin\HOCKEY.BIN,$22EE,22	;Player	<text>,		2493,2242,3620,3324 ;P298
	incbin	..\cdbin\HOCKEY.BIN,$2304,26	;Player	<text>,	3492,2122,3921,2313 ;P300
	dc.b	0,2						;end of player data: empty String
.tn									;team name: city string (Teamname)
	String	'Montreal'
.ta									;team abbreviation string
	String	'MTL'
.tm									;team nickname string
	incbin	..\cdbin\HOCKEY.BIN,$2330,12	;String	<text>
.ar									;arena string
	String	'Montreal Forum'

NewJersey							;team record: New Jersey (NJ), team 12
.0									;record base: six word offsets (Playerdata ... GoalieOdds) from here
	dc.w	.pld-.0					;Playerdata
	dc.w	.pad-.0					;Palettedata
	dc.w	.tn-.0
	dc.w	.ls-.0					;LineSets
	dc.w	.sr-.0					;ScoutReport
	dc.w	.godds-.0				;GoalieOdds
.pad								;team palettes (home and visitor)
	incbin	..\cdbin\HOCKEY.BIN,$2358,32	;home colors (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$2378,32	;visitor colors (from the disc file)
.sr									;scouting report ratings
;			qreb,hvfx
	dc.w	$3411,$12F7
.godds								;starting goalie weights, 4 nibbles (PickStartingGoalie)
	dc.b	152,0
.ls									;line sets: 8 lines of 8 roster numbers, by position
;			-G,LD,RD,LW,-C,RW,XA,00
	dc.b	01,19,18,12,03,13,08,00	;line 1 NLC (no line changes)
	dc.b	01,18,21,08,04,12,03,00	;line 2 Sc1
;CD: no cartridge twin
	incbin	..\cdbin\HOCKEY.BIN,$23AE,40	;read from the disc file
	dc.b	01,20,19,08,03,07,17,00	;line 8 PK2
.pld								;player data: one player per row, ended by an empty String
;									unwl,sodp,chga,eytm
	incbin	..\cdbin\HOCKEY.BIN,$23DE,24	;Player	<text>,	3124,4443,0000,3333 ;P301 Card068
	incbin	..\cdbin\HOCKEY.BIN,$23F6,26	;Player	<text>,	0143,4221,0000,2222 ;P302
	incbin	..\cdbin\HOCKEY.BIN,$2410,24	;Player	<text>,	2064,3443,3144,3242 ;P303 Card071
	incbin	..\cdbin\HOCKEY.BIN,$2428,26	;Player	<text>,	1963,3433,1342,3043 ;P304
	incbin	..\cdbin\HOCKEY.BIN,$2442,24	;Player	<text>,	2694,3343,3044,3241 ;P305
	incbin	..\cdbin\HOCKEY.BIN,$245A,22	;Player	<text>,		3492,2322,2222,2232 ;P306
	incbin	..\cdbin\HOCKEY.BIN,$2470,26	;Player	<text>,	2564,4433,1043,3143 ;P307
	incbin	..\cdbin\HOCKEY.BIN,$248A,22	;Player	<text>,		1593,3344,3733,4423 ;P308
	incbin	..\cdbin\HOCKEY.BIN,$24A0,22	;Player	<text>,		16A3,4333,3333,4533 ;P309
	incbin	..\cdbin\HOCKEY.BIN,$24B6,22	;Player	<text>,		0992,2321,2332,2232 ;P310
	incbin	..\cdbin\HOCKEY.BIN,$24CC,24	;Player	<text>,	08A2,2221,1824,1313 ;P311
	incbin	..\cdbin\HOCKEY.BIN,$24E4,26	;Player	<text>,	4494,4435,2143,4432 ;P312 Card070
	incbin	..\cdbin\HOCKEY.BIN,$24FE,24	;Player	<text>,	22B4,4434,3732,4334 ;P313 Card072
	incbin	..\cdbin\HOCKEY.BIN,$2516,22	;Player	<text>,		1292,2323,2333,2323 ;P314
	incbin	..\cdbin\HOCKEY.BIN,$252C,22	;Player	<text>,		2162,2222,2922,3424 ;P315
	incbin	..\cdbin\HOCKEY.BIN,$2542,24	;Player	<text>,	1862,3332,2623,2223 ;P316
	incbin	..\cdbin\HOCKEY.BIN,$255A,20	;Player	<text>,		1183,3233,3323,3222 ;P317
	incbin	..\cdbin\HOCKEY.BIN,$256E,24	;Player	<text>,	04B4,4344,5642,5043 ;P318 Card067
	incbin	..\cdbin\HOCKEY.BIN,$2586,26	;Player	<text>,	02B4,2244,4441,3044 ;P319 Card069
	incbin	..\cdbin\HOCKEY.BIN,$25A0,22	;Player	<text>,		2363,3342,3432,4232 ;P320
	incbin	..\cdbin\HOCKEY.BIN,$25B6,26	;Player	<text>,	2793,3333,3432,3132 ;P321
	incbin	..\cdbin\HOCKEY.BIN,$25D0,22	;Player	<text>,		03A2,2141,4620,4414 ;P323
	incbin	..\cdbin\HOCKEY.BIN,$25E6,24	;Player	<text>,	0673,2232,2230,3322 ;P324
	incbin	..\cdbin\HOCKEY.BIN,$25FE,24	;Player	<text>,	0571,1011,1210,1303 ;P325
	dc.b	0,2						;end of player data: empty String
.tn									;team name: city string (Teamname)
	String	'New Jersey'
.ta									;team abbreviation string
	String	'NJ'
.tm									;team nickname string
	incbin	..\cdbin\HOCKEY.BIN,$2628,8	;String	<text>
.ar									;arena string
	String	'Byrne Meadowlands Arena'

NewYorkI							;team record: New York (NYI), team 13
.0									;record base: six word offsets (Playerdata ... GoalieOdds) from here
	dc.w	$0092					;dc.w	.pld-.0
	dc.w	.pad-.0					;Palettedata
	dc.w	.tn-.0
	dc.w	$0052					;dc.w	.ls-.0
	dc.w	$004C					;dc.w	.sr-.0
	dc.w	$0050					;dc.w	.godds-.0
.pad								;team palettes (home and visitor)
	incbin	..\cdbin\HOCKEY.BIN,$2656,32	;home colors (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$2676,32	;visitor colors (from the disc file)
;CD: no cartridge twin
	incbin	..\cdbin\HOCKEY.BIN,$2696,92	;read from the disc file
	incbin	..\cdbin\HOCKEY.BIN,$26F2,24	;Player	<text>,	7794,4534,3445,5141 ;P328 Card045
	incbin	..\cdbin\HOCKEY.BIN,$270A,22	;Player	<text>,		3374,5433,2445,4143 ;P329 Card043
	incbin	..\cdbin\HOCKEY.BIN,$2720,24	;Player	<text>,	1843,3322,2333,3022 ;P330
	incbin	..\cdbin\HOCKEY.BIN,$2738,22	;Player	<text>,		3982,2322,3121,2322 ;P331
	incbin	..\cdbin\HOCKEY.BIN,$274E,22	;Player	<text>,		2063,3334,2643,4333 ;P332
	incbin	..\cdbin\HOCKEY.BIN,$2764,26	;Player	<text>,	1083,2211,3833,1524 ;P333
	incbin	..\cdbin\HOCKEY.BIN,$277E,22	;Player	<text>,		3264,4433,4433,4243 ;P334 Card044
	incbin	..\cdbin\HOCKEY.BIN,$2794,20	;Player	<text>,		2793,2434,1445,4222 ;P335
	incbin	..\cdbin\HOCKEY.BIN,$27A8,20	;Player	<text>,		2564,4322,1242,4532 ;P336
	incbin	..\cdbin\HOCKEY.BIN,$27BC,26	;Player	<text>,	2683,2432,3342,4042 ;P337
	incbin	..\cdbin\HOCKEY.BIN,$27D6,22	;Player	<text>,		1663,3333,2433,4531 ;P338
	incbin	..\cdbin\HOCKEY.BIN,$27EC,24	;Player	<text>,	15B1,2321,1524,2123 ;P339
	incbin	..\cdbin\HOCKEY.BIN,$2804,22	;Player	<text>,		1282,3111,1911,2414 ;P342
	incbin	..\cdbin\HOCKEY.BIN,$281A,28	;Player	<text>,	23A3,3434,3432,4233 ;P343 Card048
	incbin	..\cdbin\HOCKEY.BIN,$2836,28	;Player	<text>,	1174,3233,4431,3234 ;P344 Card047
	incbin	..\cdbin\HOCKEY.BIN,$2852,22	;Player	<text>,		0883,3432,2422,4132 ;P345
	incbin	..\cdbin\HOCKEY.BIN,$2868,20	;Player	<text>,		04E2,2343,3322,4132 ;P346
	incbin	..\cdbin\HOCKEY.BIN,$287C,22	;Player	<text>,		2883,3434,2631,4132 ;P347
	incbin	..\cdbin\HOCKEY.BIN,$2892,24	;Player	<text>,	0782,2243,3432,4133 ;P348
	incbin	..\cdbin\HOCKEY.BIN,$28AA,22	;Player	<text>,		37A1,1212,2611,1113 ;P349
	incbin	..\cdbin\HOCKEY.BIN,$28C0,24	;Player	<text>,	4793,3123,3821,2515 ;P350
	dc.b	0,2						;end of player data: empty String
.tn									;team name: city string (Teamname)
	String	'New York'
.ta									;team abbreviation string
	String	'NYI'
.tm									;team nickname string
	incbin	..\cdbin\HOCKEY.BIN,$28EA,12	;String	<text>
.ar									;arena string
	String	'Nassau Coliseum'

NewYorkR							;team record: New York (NYR), team 14
.0									;record base: six word offsets (Playerdata ... GoalieOdds) from here
	dc.w	$0092					;dc.w	.pld-.0
	dc.w	.pad-.0					;Palettedata
	dc.w	.tn-.0
	dc.w	$0052					;dc.w	.ls-.0
	dc.w	$004C					;dc.w	.sr-.0
	dc.w	$0050					;dc.w	.godds-.0
.pad								;team palettes (home and visitor)
	incbin	..\cdbin\HOCKEY.BIN,$2914,32	;home colors (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$2934,32	;visitor colors (from the disc file)
;CD: no cartridge twin
	incbin	..\cdbin\HOCKEY.BIN,$2954,92	;read from the disc file
	incbin	..\cdbin\HOCKEY.BIN,$29B0,22	;Player	<text>,		11A5,4443,5453,4053 ;P353 Card074
	incbin	..\cdbin\HOCKEY.BIN,$29C6,26	;Player	<text>,	1364,3353,4034,5232 ;P354
	incbin	..\cdbin\HOCKEY.BIN,$29E0,26	;Player	<text>,	0864,4433,2443,4432 ;P355
	incbin	..\cdbin\HOCKEY.BIN,$29FA,20	;Player	<text>,		1294,3334,2443,3442 ;P356
	incbin	..\cdbin\HOCKEY.BIN,$2A0E,22	;Player	<text>,		1095,5344,5442,4443 ;P357 Card078
	incbin	..\cdbin\HOCKEY.BIN,$2A24,22	;Player	<text>,		0964,4432,3633,4534 ;P358
	incbin	..\cdbin\HOCKEY.BIN,$2A3A,22	;Player	<text>,		2982,4232,4832,3222 ;P359
	incbin	..\cdbin\HOCKEY.BIN,$2A50,20	;Player	<text>,		2083,3232,2233,3031 ;P360
	incbin	..\cdbin\HOCKEY.BIN,$2A64,22	;Player	<text>,		2275,5445,2353,5552 ;P362 Card076
	incbin	..\cdbin\HOCKEY.BIN,$2A7A,22	;Player	<text>,		3364,4433,1333,4332 ;P363
	incbin	..\cdbin\HOCKEY.BIN,$2A90,24	;Player	<text>,	2774,3333,1034,3433 ;P364
	incbin	..\cdbin\HOCKEY.BIN,$2AA8,22	;Player	<text>,		3771,1231,2312,2312 ;P365
	incbin	..\cdbin\HOCKEY.BIN,$2ABE,20	;Player	<text>,		2682,1132,3921,2424 ;P366
	incbin	..\cdbin\HOCKEY.BIN,$2AD2,22	;Player	<text>,		1872,3101,3611,1514 ;P367
	incbin	..\cdbin\HOCKEY.BIN,$2AE8,22	;Player	<text>,		0266,3444,2651,5252 ;P368 Card077
	incbin	..\cdbin\HOCKEY.BIN,$2AFE,24	;Player	<text>,	0394,4344,4341,4243 ;P369 Card075
	incbin	..\cdbin\HOCKEY.BIN,$2B16,22	;Player	<text>,		2173,3343,3332,3130 ;P370
	incbin	..\cdbin\HOCKEY.BIN,$2B2C,24	;Player	<text>,	23B2,2242,3720,3024 ;P371
	incbin	..\cdbin\HOCKEY.BIN,$2B44,20	;Player	<text>,		0484,3243,4241,3133 ;P372
	incbin	..\cdbin\HOCKEY.BIN,$2B58,26	;Player	<text>,	0592,3322,2231,2432 ;P373
	incbin	..\cdbin\HOCKEY.BIN,$2B72,20	;Player	<text>,		24A2,2222,3620,2124 ;P374
	dc.b	0,2						;end of player data: empty String
.tn									;team name: city string (Teamname)
	String	'New York'
.ta									;team abbreviation string
	String	'NYR'
.tm									;team nickname string
	incbin	..\cdbin\HOCKEY.BIN,$2B98,10	;String	<text>
.ar									;arena string
	String	'Madison Square Garden'

Ottawa								;team record: Ottawa (OTW), team 15
.0									;record base: six word offsets (Playerdata ... GoalieOdds) from here
	dc.w	.pld-.0					;Playerdata
	dc.w	.pad-.0					;Palettedata
	dc.w	.tn-.0					;Teamname
	dc.w	.ls-.0					;LineSets
	dc.w	$004C					;dc.w	.sr-.0
	dc.w	.godds-.0				;GoalieOdds
.pad								;team palettes (home and visitor)
	incbin	..\cdbin\HOCKEY.BIN,$2BC6,32	;home colors (from the disc file)
;CD: no cartridge twin
	incbin	..\cdbin\HOCKEY.BIN,$2BE6,36	;read from the disc file
.godds								;starting goalie weights, 4 nibbles (PickStartingGoalie)
	dc.b	197,0
.ls									;line sets: 8 lines of 8 roster numbers, by position
;			-G,LD,RD,LW,-C,RW,XA,00
	dc.b	01,20,19,10,03,15,11,00	;line 1 NLC (no line changes)
	dc.b	01,20,19,10,03,15,07,00	;line 2 Sc1
	dc.b	01,22,25,12,07,17,03,00	;line 3 Sc2
	dc.b	01,21,23,11,04,16,03,00	;line 4 Chk
	dc.b	01,20,19,15,03,16,05,00	;line 5 PP1
	dc.b	01,23,22,10,05,08,16,00	;line 6 PP2
	dc.b	01,19,23,06,07,12,04,00	;line 7 PK1
	dc.b	01,20,25,12,04,07,06,00	;line 8 PK2
.pld								;player data: one player per row, ended by an empty String
;									unwl,sodp,chga,eytm
	incbin	..\cdbin\HOCKEY.BIN,$2C4C,26	;Player	<text>,	3162,3112,0000,2222 ;P376 Card079
	incbin	..\cdbin\HOCKEY.BIN,$2C66,28	;Player	<text>,	3213,3112,0000,2222 ;P377
	incbin	..\cdbin\HOCKEY.BIN,$2C82,22	;Player	<text>,		1373,3333,2433,4232 ;P378 Card083
	incbin	..\cdbin\HOCKEY.BIN,$2C98,20	;Player	<text>,		0764,3242,3031,3333 ;P379
	incbin	..\cdbin\HOCKEY.BIN,$2CAC,20	;Player	<text>,		1292,2332,2622,3133 ;P380
	incbin	..\cdbin\HOCKEY.BIN,$2CC0,20	;Player	<text>,		1162,2332,2423,4322 ;P381
	incbin	..\cdbin\HOCKEY.BIN,$2CD4,26	;Player	<text>,	1664,2242,3432,3523 ;P382
	incbin	..\cdbin\HOCKEY.BIN,$2CEE,26	;Player	<text>,	1572,2232,1622,3522 ;P383
	incbin	..\cdbin\HOCKEY.BIN,$2D08,20	;Player	<text>,		1891,2222,3621,2412 ;P384
	incbin	..\cdbin\HOCKEY.BIN,$2D1C,26	;Player	<text>,	6194,4333,2432,3523 ;P385 Card080
	incbin	..\cdbin\HOCKEY.BIN,$2D36,22	;Player	<text>,		4492,2232,3A13,3525 ;P386
	incbin	..\cdbin\HOCKEY.BIN,$2D4C,20	;Player	<text>,		0953,3232,2621,2423 ;P387
	incbin	..\cdbin\HOCKEY.BIN,$2D60,22	;Player	<text>,		2863,3312,2833,1522 ;P388
	incbin	..\cdbin\HOCKEY.BIN,$2D76,22	;Player	<text>,		1062,2122,1612,2424 ;P389
	incbin	..\cdbin\HOCKEY.BIN,$2D8C,22	;Player	<text>,		2693,3333,2334,3432 ;P390 Card084
	incbin	..\cdbin\HOCKEY.BIN,$2DA2,20	;Player	<text>,		1792,2332,3122,3321 ;P391
	incbin	..\cdbin\HOCKEY.BIN,$2DB6,24	;Player	<text>,	2092,2332,3522,2122 ;P392
	incbin	..\cdbin\HOCKEY.BIN,$2DCE,24	;Player	<text>,	2572,2222,1632,2513 ;P393
	incbin	..\cdbin\HOCKEY.BIN,$2DE6,22	;Player	<text>,		2263,3443,3022,4133 ;P394 Card081
	incbin	..\cdbin\HOCKEY.BIN,$2DFC,20	;Player	<text>,		0473,2333,2331,3232 ;P395 Card082
	incbin	..\cdbin\HOCKEY.BIN,$2E10,24	;Player	<text>,	3492,2232,3420,3423 ;P396
	incbin	..\cdbin\HOCKEY.BIN,$2E28,22	;Player	<text>,		2362,2131,1320,2423 ;P397
	incbin	..\cdbin\HOCKEY.BIN,$2E3E,22	;Player	<text>,		0573,2132,3621,3513 ;P398
	incbin	..\cdbin\HOCKEY.BIN,$2E54,22	;Player	<text>,		0681,1221,2311,2513 ;P399
	incbin	..\cdbin\HOCKEY.BIN,$2E6A,20	;Player	<text>,		14B2,2031,3610,2522 ;P400
	dc.b	0,2						;end of player data: empty String
.tn									;team name: city string (Teamname)
	String	'Ottawa'
.ta									;team abbreviation string
	String	'OTW'
.tm									;team nickname string
	incbin	..\cdbin\HOCKEY.BIN,$2E8E,10	;String	<text>
.ar									;arena string
	String	'Ottawa Civic Center'

Philadelphia						;team record: Philadelphia (PHI), team 16
.0									;record base: six word offsets (Playerdata ... GoalieOdds) from here
	dc.w	.pld-.0					;Playerdata
	dc.w	.pad-.0					;Palettedata
	dc.w	.tn-.0
	dc.w	$0052					;dc.w	.ls-.0
	dc.w	$004C					;dc.w	.sr-.0
	dc.w	$0050					;dc.w	.godds-.0
.pad								;team palettes (home and visitor)
	incbin	..\cdbin\HOCKEY.BIN,$2EBA,32	;home colors (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$2EDA,32	;visitor colors (from the disc file)
;CD: no cartridge twin
	incbin	..\cdbin\HOCKEY.BIN,$2EFA,70	;read from the disc file
.pld								;player data: one player per row, ended by an empty String
;									unwl,sodp,chga,eytm
	incbin	..\cdbin\HOCKEY.BIN,$2F40,26	;Player	<text>,	3034,4554,0000,3434 ;P401 Card089
	incbin	..\cdbin\HOCKEY.BIN,$2F5A,26	;Player	<text>,	3363,3333,0000,3322 ;P402
	incbin	..\cdbin\HOCKEY.BIN,$2F74,26	;Player	<text>,	3572,3001,0100,2222 ;P403
	incbin	..\cdbin\HOCKEY.BIN,$2F8E,22	;Player	<text>,		88C4,3444,5946,5244 ;P404 Card085
	incbin	..\cdbin\HOCKEY.BIN,$2FA4,24	;Player	<text>,	1794,3444,3444,4243 ;P405 Card086
	incbin	..\cdbin\HOCKEY.BIN,$2FBC,22	;Player	<text>,		0955,4433,3243,4041 ;P406
	incbin	..\cdbin\HOCKEY.BIN,$2FD2,24	;Player	<text>,	4263,3332,1033,3433 ;P407
	incbin	..\cdbin\HOCKEY.BIN,$2FEA,22	;Player	<text>,		2542,2243,4032,4232 ;P408
	incbin	..\cdbin\HOCKEY.BIN,$3000,28	;Player	<text>,	2262,2222,2620,2123 ;P409
	incbin	..\cdbin\HOCKEY.BIN,$301C,22	;Player	<text>,		1882,2433,3323,3122 ;P410
	incbin	..\cdbin\HOCKEY.BIN,$3032,20	;Player	<text>,		1562,2222,2423,2223 ;P411
	incbin	..\cdbin\HOCKEY.BIN,$3046,24	;Player	<text>,	1473,3222,2631,2531 ;P413
	incbin	..\cdbin\HOCKEY.BIN,$305E,24	;Player	<text>,	1091,1212,2814,1214 ;P414
	incbin	..\cdbin\HOCKEY.BIN,$3076,22	;Player	<text>,		0865,4534,3445,4143 ;P415 Card088
	incbin	..\cdbin\HOCKEY.BIN,$308C,22	;Player	<text>,		1174,5342,2733,4534 ;P416
	incbin	..\cdbin\HOCKEY.BIN,$30A2,20	;Player	<text>,		2191,1021,2910,2513 ;P417
	incbin	..\cdbin\HOCKEY.BIN,$30B6,22	;Player	<text>,		0372,2342,3631,3233 ;P418 Card087
	incbin	..\cdbin\HOCKEY.BIN,$30CC,28	;Player	<text>,	0274,3343,2431,4333 ;P419 Card090
	incbin	..\cdbin\HOCKEY.BIN,$30E8,22	;Player	<text>,		2074,3333,2432,3133 ;P420
	incbin	..\cdbin\HOCKEY.BIN,$30FE,24	;Player	<text>,	29A2,2232,3621,3024 ;P421
	incbin	..\cdbin\HOCKEY.BIN,$3116,22	;Player	<text>,		05A2,2332,2523,3322 ;P422
	incbin	..\cdbin\HOCKEY.BIN,$312C,22	;Player	<text>,		2782,2232,2721,3414 ;P423
	incbin	..\cdbin\HOCKEY.BIN,$3142,22	;Player	<text>,		44A1,1111,2C13,1513 ;P425
	dc.b	0,2						;end of player data: empty String
.tn									;team name: city string (Teamname)
	String	'Philadelphia'
.ta									;team abbreviation string
	String	'PHI'
.tm									;team nickname string
	incbin	..\cdbin\HOCKEY.BIN,$316E,8	;String	<text>
.ar									;arena string
	String	'Spectrum'

Pittsburgh							;team record: Pittsburgh (PIT), team 17
.0									;record base: six word offsets (Playerdata ... GoalieOdds) from here
	dc.w	.pld-.0					;Playerdata
	dc.w	.pad-.0					;Palettedata
	dc.w	.tn-.0
	dc.w	$0052					;dc.w	.ls-.0
	dc.w	$004C					;dc.w	.sr-.0
	dc.w	$0050					;dc.w	.godds-.0
.pad								;team palettes (home and visitor)
	incbin	..\cdbin\HOCKEY.BIN,$318C,32	;home colors (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$31AC,32	;visitor colors (from the disc file)
;CD: no cartridge twin
	incbin	..\cdbin\HOCKEY.BIN,$31CC,70	;read from the disc file
.pld								;player data: one player per row, ended by an empty String
;									unwl,sodp,chga,eytm
	incbin	..\cdbin\HOCKEY.BIN,$3212,22	;Player	<text>,		35A4,4554,0100,4444 ;P426 Card091
	incbin	..\cdbin\HOCKEY.BIN,$3228,22	;Player	<text>,		3182,3442,0000,3232 ;P427
	incbin	..\cdbin\HOCKEY.BIN,$323E,24	;Player	<text>,	66A5,4644,3366,6062 ;P428 Card092
	incbin	..\cdbin\HOCKEY.BIN,$3256,22	;Player	<text>,		1094,3444,4443,4042 ;P429
	incbin	..\cdbin\HOCKEY.BIN,$326C,26	;Player	<text>,	1573,3333,2433,4332 ;P430
	incbin	..\cdbin\HOCKEY.BIN,$3286,24	;Player	<text>,	2663,2222,2121,2530 ;P431
	incbin	..\cdbin\HOCKEY.BIN,$329E,24	;Player	<text>,	25B3,4533,3644,5344 ;P432 Card093
	incbin	..\cdbin\HOCKEY.BIN,$32B6,22	;Player	<text>,		1462,3232,2422,3122 ;P433
	incbin	..\cdbin\HOCKEY.BIN,$32CC,22	;Player	<text>,		2092,2122,2623,2421 ;P435
	incbin	..\cdbin\HOCKEY.BIN,$32E2,22	;Player	<text>,		68A5,4433,4453,4142 ;P436 Card094
	incbin	..\cdbin\HOCKEY.BIN,$32F8,22	;Player	<text>,		2292,2544,3735,4134 ;P437
	incbin	..\cdbin\HOCKEY.BIN,$330E,20	;Player	<text>,		0764,3433,3145,4230 ;P438
	incbin	..\cdbin\HOCKEY.BIN,$3322,24	;Player	<text>,	8253,3322,2222,2032 ;P439
	incbin	..\cdbin\HOCKEY.BIN,$333A,22	;Player	<text>,		3962,2222,2523,2521 ;P440
	incbin	..\cdbin\HOCKEY.BIN,$3350,22	;Player	<text>,		16E1,2011,3B10,1314 ;P441
	incbin	..\cdbin\HOCKEY.BIN,$3366,22	;Player	<text>,		55A4,3454,3342,5143 ;P442 Card095
	incbin	..\cdbin\HOCKEY.BIN,$337C,24	;Player	<text>,	0584,4353,5630,4135 ;P443 Card096
	incbin	..\cdbin\HOCKEY.BIN,$3394,18	;Player	<text>,			0282,3222,2421,3122 ;P444
	incbin	..\cdbin\HOCKEY.BIN,$33A6,22	;Player	<text>,		2383,3234,3321,3543 ;P445
	incbin	..\cdbin\HOCKEY.BIN,$33BC,26	;Player	<text>,	3292,2233,4430,4324 ;P446
	incbin	..\cdbin\HOCKEY.BIN,$33D6,22	;Player	<text>,		0683,2232,3622,3122 ;P447
	incbin	..\cdbin\HOCKEY.BIN,$33EC,26	;Player	<text>,	28E2,2134,4731,4523 ;P448
	incbin	..\cdbin\HOCKEY.BIN,$3406,24	;Player	<text>,	0392,2132,3820,2313 ;P449
	incbin	..\cdbin\HOCKEY.BIN,$341E,24	;Player	<text>,	3381,1211,2220,1011 ;P450
	dc.b	0,2						;end of player data: empty String
.tn									;team name: city string (Teamname)
	String	'Pittsburgh'
.ta									;team abbreviation string
	String	'PIT'
.tm									;team nickname string
	incbin	..\cdbin\HOCKEY.BIN,$344A,10	;String	<text>
.ar									;arena string
	String	'Civic Arena'

Quebec								;team record: Quebec (QUE), team 18
.0									;record base: six word offsets (Playerdata ... GoalieOdds) from here
	dc.w	.pld-.0					;Playerdata
	dc.w	.pad-.0					;Palettedata
	dc.w	.tn-.0
	dc.w	$0052					;dc.w	.ls-.0
	dc.w	$004C					;dc.w	.sr-.0
	dc.w	$0050					;dc.w	.godds-.0
.pad								;team palettes (home and visitor)
	incbin	..\cdbin\HOCKEY.BIN,$346E,32	;home colors (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$348E,32	;visitor colors (from the disc file)
;CD: no cartridge twin
	incbin	..\cdbin\HOCKEY.BIN,$34AE,70	;read from the disc file
.pld								;player data: one player per row, ended by an empty String
;									unwl,sodp,chga,eytm
	incbin	..\cdbin\HOCKEY.BIN,$34F4,22	;Player	<text>,		2774,4444,0000,4433 ;P451 Card097
	incbin	..\cdbin\HOCKEY.BIN,$350A,24	;Player	<text>,	3553,4332,0000,2222 ;P452
	incbin	..\cdbin\HOCKEY.BIN,$3522,20	;Player	<text>,		1964,4544,2045,5252 ;P453 Card100
	incbin	..\cdbin\HOCKEY.BIN,$3536,20	;Player	<text>,		0974,4433,3435,3043 ;P454
	incbin	..\cdbin\HOCKEY.BIN,$354A,26	;Player	<text>,	4753,3342,2432,3123 ;P455
	incbin	..\cdbin\HOCKEY.BIN,$3564,26	;Player	<text>,	2553,2323,1433,3132 ;P456
	incbin	..\cdbin\HOCKEY.BIN,$357E,26	;Player	<text>,	3184,4435,2543,4142 ;P457
	incbin	..\cdbin\HOCKEY.BIN,$3598,24	;Player	<text>,	44B1,3222,2423,2222 ;P459
	incbin	..\cdbin\HOCKEY.BIN,$35B0,24	;Player	<text>,	2292,2222,3624,3524 ;P460
	incbin	..\cdbin\HOCKEY.BIN,$35C8,22	;Player	<text>,		12D1,1101,2811,0515 ;P462
	incbin	..\cdbin\HOCKEY.BIN,$35DE,20	;Player	<text>,		15A1,1101,1C10,1414 ;P463
	incbin	..\cdbin\HOCKEY.BIN,$35F2,22	;Player	<text>,		1374,4544,1345,4043 ;P464 Card102
	incbin	..\cdbin\HOCKEY.BIN,$3608,20	;Player	<text>,		1184,4434,1744,4334 ;P465 Card098
	incbin	..\cdbin\HOCKEY.BIN,$361C,26	;Player	<text>,	5133,4433,3434,4132 ;P466
	incbin	..\cdbin\HOCKEY.BIN,$3636,22	;Player	<text>,		4873,3343,2133,3431 ;P467
	incbin	..\cdbin\HOCKEY.BIN,$364C,24	;Player	<text>,	2884,4444,2442,4142 ;P468 Card099
	incbin	..\cdbin\HOCKEY.BIN,$3664,28	;Player	<text>,	0793,4342,3423,4032 ;P469 Card101
	incbin	..\cdbin\HOCKEY.BIN,$3680,24	;Player	<text>,	0563,3333,3033,4032 ;P470
	incbin	..\cdbin\HOCKEY.BIN,$3698,24	;Player	<text>,	0293,3333,3631,3223 ;P471
	incbin	..\cdbin\HOCKEY.BIN,$36B0,20	;Player	<text>,		5262,2241,3321,3224 ;P472
	incbin	..\cdbin\HOCKEY.BIN,$36C4,22	;Player	<text>,		2982,2233,3622,3424 ;P473
	incbin	..\cdbin\HOCKEY.BIN,$36DA,28	;Player	<text>,	0483,3225,4641,2443 ;P474
	incbin	..\cdbin\HOCKEY.BIN,$36F6,24	;Player	<text>,	0692,2221,2811,2114 ;P475
	dc.b	0,2						;end of player data: empty String
.tn									;team name: city string (Teamname)
	String	'Quebec'
.ta									;team abbreviation string
	String	'QUE'
.tm									;team nickname string
	incbin	..\cdbin\HOCKEY.BIN,$371E,12	;String	<text>
.ar									;arena string
	String	'Colisee de Quebec'

SanJose								;team record: San Jose (SJ), team 19
.0									;record base: six word offsets (Playerdata ... GoalieOdds) from here
	dc.w	.pld-.0					;Playerdata
	dc.w	.pad-.0					;Palettedata
	dc.w	.tn-.0
	dc.w	$0052					;dc.w	.ls-.0
	dc.w	$004C					;dc.w	.sr-.0
	dc.w	$0050					;dc.w	.godds-.0
.pad								;team palettes (home and visitor)
	incbin	..\cdbin\HOCKEY.BIN,$374A,32	;home colors (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$376A,32	;visitor colors (from the disc file)
;CD: no cartridge twin
	incbin	..\cdbin\HOCKEY.BIN,$378A,70	;read from the disc file
.pld								;player data: one player per row, ended by an empty String
;									unwl,sodp,chga,eytm
	incbin	..\cdbin\HOCKEY.BIN,$37D0,22	;Player	<text>,		3252,4443,0000,3322 ;P476 Card106
	incbin	..\cdbin\HOCKEY.BIN,$37E6,22	;Player	<text>,		3052,3112,0000,2222 ;P477
	incbin	..\cdbin\HOCKEY.BIN,$37FC,24	;Player	<text>,	0162,3002,0000,2222 ;P478
	incbin	..\cdbin\HOCKEY.BIN,$3814,22	;Player	<text>,		1162,2443,3334,4033 ;P479 Card103
	incbin	..\cdbin\HOCKEY.BIN,$382A,22	;Player	<text>,		3763,3333,2323,4531 ;P480
	incbin	..\cdbin\HOCKEY.BIN,$3840,22	;Player	<text>,		1261,1232,3323,3323 ;P481
	incbin	..\cdbin\HOCKEY.BIN,$3856,24	;Player	<text>,	4762,3232,1021,4521 ;P482
	incbin	..\cdbin\HOCKEY.BIN,$386E,24	;Player	<text>,	1674,4222,3322,2533 ;P483
	incbin	..\cdbin\HOCKEY.BIN,$3886,26	;Player	<text>,	1063,3422,1033,3122 ;P485 Card108
	incbin	..\cdbin\HOCKEY.BIN,$38A0,22	;Player	<text>,		3691,2322,2623,3415 ;P486
	incbin	..\cdbin\HOCKEY.BIN,$38B6,22	;Player	<text>,		2042,2222,2821,2523 ;P487
	incbin	..\cdbin\HOCKEY.BIN,$38CC,22	;Player	<text>,		2581,1112,3820,1414 ;P488
	incbin	..\cdbin\HOCKEY.BIN,$38E2,22	;Player	<text>,		1774,4323,1342,4531 ;P489 Card105
	incbin	..\cdbin\HOCKEY.BIN,$38F8,22	;Player	<text>,		3992,2331,1313,2121 ;P490
	incbin	..\cdbin\HOCKEY.BIN,$390E,24	;Player	<text>,	1882,2322,2623,2522 ;P491
	incbin	..\cdbin\HOCKEY.BIN,$3926,22	;Player	<text>,		2474,3336,3641,3343 ;P492 Card104
	incbin	..\cdbin\HOCKEY.BIN,$393C,24	;Player	<text>,	0573,3132,3530,4443 ;P493 Card107
	incbin	..\cdbin\HOCKEY.BIN,$3954,26	;Player	<text>,	0673,3333,3632,4233 ;P494
	incbin	..\cdbin\HOCKEY.BIN,$396E,22	;Player	<text>,		4141,2322,2522,2432 ;P495
	incbin	..\cdbin\HOCKEY.BIN,$3984,22	;Player	<text>,		19C2,2232,3621,3524 ;P496
	incbin	..\cdbin\HOCKEY.BIN,$399A,18	;Player	<text>,			0473,2134,3331,3534 ;P498
	incbin	..\cdbin\HOCKEY.BIN,$39AC,22	;Player	<text>,		2192,2132,3621,3422 ;P499
	incbin	..\cdbin\HOCKEY.BIN,$39C2,22	;Player	<text>,		0272,2132,2430,3434 ;P500
	dc.b	0,2						;end of player data: empty String
.tn									;team name: city string (Teamname)
	String	'San Jose'
.ta									;team abbreviation string
	String	'SJ'
.tm									;team nickname string
	incbin	..\cdbin\HOCKEY.BIN,$39E8,8	;String	<text>
.ar									;arena string
	String	'San Jose Arena'

StLouis								;team record: St. Louis (STL), team 20
.0									;record base: six word offsets (Playerdata ... GoalieOdds) from here
	dc.w	$0092					;dc.w	.pld-.0
	dc.w	.pad-.0					;Palettedata
	dc.w	.tn-.0
	dc.w	$0052					;dc.w	.ls-.0
	dc.w	$004C					;dc.w	.sr-.0
	dc.w	$0050					;dc.w	.godds-.0
.pad								;team palettes (home and visitor)
	incbin	..\cdbin\HOCKEY.BIN,$3A0C,32	;visitor colors (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$3A2C,32	;visitor colors (from the disc file)
;CD: no cartridge twin
	incbin	..\cdbin\HOCKEY.BIN,$3A4C,94	;read from the disc file
	incbin	..\cdbin\HOCKEY.BIN,$3AAA,22	;Player	<text>,		1574,3543,2044,4040 ;P503 Card110
	incbin	..\cdbin\HOCKEY.BIN,$3AC0,24	;Player	<text>,	0744,4433,2343,4132 ;P504
	incbin	..\cdbin\HOCKEY.BIN,$3AD8,20	;Player	<text>,		2263,3342,4533,4343 ;P505
	incbin	..\cdbin\HOCKEY.BIN,$3AEC,20	;Player	<text>,		1863,3241,2022,4322 ;P506
	incbin	..\cdbin\HOCKEY.BIN,$3B00,20	;Player	<text>,		2843,4222,4833,2323 ;P507
	incbin	..\cdbin\HOCKEY.BIN,$3B14,24	;Player	<text>,	3662,2222,1621,2513 ;P508
	incbin	..\cdbin\HOCKEY.BIN,$3B2C,22	;Player	<text>,		3872,2232,2021,3021 ;P509
	incbin	..\cdbin\HOCKEY.BIN,$3B42,22	;Player	<text>,		1792,2222,2C21,3415 ;P511
	incbin	..\cdbin\HOCKEY.BIN,$3B58,26	;Player	<text>,	19A3,3544,2745,4244 ;P512 Card114
	incbin	..\cdbin\HOCKEY.BIN,$3B72,20	;Player	<text>,		1694,4536,3353,4432 ;P513 Card111
	incbin	..\cdbin\HOCKEY.BIN,$3B86,22	;Player	<text>,		1474,3343,3733,4333 ;P514
	incbin	..\cdbin\HOCKEY.BIN,$3B9C,22	;Player	<text>,		2373,3241,2322,4523 ;P515
	incbin	..\cdbin\HOCKEY.BIN,$3BB2,22	;Player	<text>,		3981,1121,1911,2315 ;P516
	incbin	..\cdbin\HOCKEY.BIN,$3BC8,20	;Player	<text>,		2193,3445,2343,5142 ;P517 Card113
	incbin	..\cdbin\HOCKEY.BIN,$3BDC,24	;Player	<text>,	0592,3242,4731,4434 ;P518 Card112
	incbin	..\cdbin\HOCKEY.BIN,$3BF4,24	;Player	<text>,	0672,2332,2623,4032 ;P519
	incbin	..\cdbin\HOCKEY.BIN,$3C0C,20	;Player	<text>,		0482,2233,2320,4023 ;P520
	incbin	..\cdbin\HOCKEY.BIN,$3C20,26	;Player	<text>,	33B2,2142,3730,4433 ;P521
	incbin	..\cdbin\HOCKEY.BIN,$3C3A,22	;Player	<text>,		2082,2231,3822,3224 ;P522
	incbin	..\cdbin\HOCKEY.BIN,$3C50,22	;Player	<text>,		4482,2112,3620,1322 ;P523
	incbin	..\cdbin\HOCKEY.BIN,$3C66,20	;Player	<text>,		0253,2131,2220,3312 ;P524
	incbin	..\cdbin\HOCKEY.BIN,$3C7A,22	;Player	<text>,		34A3,3122,2621,2513 ;P525
	dc.b	0,2						;end of player data: empty String
.tn									;team name: city string (Teamname)
	String	'St. Louis'
.ta									;team abbreviation string
	String	'STL'
.tm									;team nickname string
	incbin	..\cdbin\HOCKEY.BIN,$3CA4,8	;String	<text>
.ar									;arena string
	String	'St. Louis Arena'

TampaBay							;team record: Tampa Bay (TB), team 21
.0									;record base: six word offsets (Playerdata ... GoalieOdds) from here
	dc.w	.pld-.0					;Playerdata
	dc.w	.pad-.0					;Palettedata
	dc.w	.tn-.0
	dc.w	$0052					;dc.w	.ls-.0
	dc.w	$004C					;dc.w	.sr-.0
	dc.w	$0050					;dc.w	.godds-.0
.pad								;team palettes (home and visitor)
	incbin	..\cdbin\HOCKEY.BIN,$3CCA,32	;home colors (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$3CEA,32	;visitor colors (from the disc file)
;CD: no cartridge twin
	incbin	..\cdbin\HOCKEY.BIN,$3D0A,70	;read from the disc file
.pld								;player data: one player per row, ended by an empty String
;									unwl,sodp,chga,eytm
	incbin	..\cdbin\HOCKEY.BIN,$3D50,24	;Player	<text>,	0163,3223,0000,3233 ;P526 Card116
	incbin	..\cdbin\HOCKEY.BIN,$3D68,24	;Player	<text>,	3552,3222,0100,2222 ;P527
	incbin	..\cdbin\HOCKEY.BIN,$3D80,24	;Player	<text>,	3072,3222,0000,1111 ;P528
	incbin	..\cdbin\HOCKEY.BIN,$3D98,24	;Player	<text>,	1944,3434,3335,4233 ;P529 Card115
	incbin	..\cdbin\HOCKEY.BIN,$3DB0,22	;Player	<text>,		1683,3433,3035,4330 ;P530 Card120
	incbin	..\cdbin\HOCKEY.BIN,$3DC6,24	;Player	<text>,	10A3,2322,3422,3433 ;P531
	incbin	..\cdbin\HOCKEY.BIN,$3DDE,22	;Player	<text>,		2873,3332,2132,3324 ;P532
	incbin	..\cdbin\HOCKEY.BIN,$3DF4,20	;Player	<text>,		1852,3332,2522,3223 ;P533
	incbin	..\cdbin\HOCKEY.BIN,$3E08,22	;Player	<text>,		1153,3132,4433,3231 ;P534
	incbin	..\cdbin\HOCKEY.BIN,$3E1E,26	;Player	<text>,	1762,2332,1324,2212 ;P535
	incbin	..\cdbin\HOCKEY.BIN,$3E38,26	;Player	<text>,	3462,4232,1032,4530 ;P537 Card119
	incbin	..\cdbin\HOCKEY.BIN,$3E52,22	;Player	<text>,		0792,3322,3432,3322 ;P538
	incbin	..\cdbin\HOCKEY.BIN,$3E68,24	;Player	<text>,	37A2,2232,3021,3422 ;P539
	incbin	..\cdbin\HOCKEY.BIN,$3E80,22	;Player	<text>,		1492,3333,2332,3233 ;P540
	incbin	..\cdbin\HOCKEY.BIN,$3E96,22	;Player	<text>,		2473,3332,2122,3421 ;P541
	incbin	..\cdbin\HOCKEY.BIN,$3EAC,22	;Player	<text>,		2182,2132,2321,3522 ;P542
	incbin	..\cdbin\HOCKEY.BIN,$3EC2,22	;Player	<text>,		2771,2102,2312,0512 ;P543
	incbin	..\cdbin\HOCKEY.BIN,$3ED8,20	;Player	<text>,		0293,3332,2322,3323 ;P544 Card118
	incbin	..\cdbin\HOCKEY.BIN,$3EEC,24	;Player	<text>,	4473,2233,2431,3423 ;P545 Card117
	incbin	..\cdbin\HOCKEY.BIN,$3F04,24	;Player	<text>,	2292,2332,2221,3222 ;P546
	incbin	..\cdbin\HOCKEY.BIN,$3F1C,24	;Player	<text>,	2562,2223,3420,3322 ;P547
	incbin	..\cdbin\HOCKEY.BIN,$3F34,20	;Player	<text>,		29B3,2223,2630,3223 ;P548
	incbin	..\cdbin\HOCKEY.BIN,$3F48,22	;Player	<text>,		4061,1211,0210,1114 ;P549
	incbin	..\cdbin\HOCKEY.BIN,$3F5E,22	;Player	<text>,		2691,1211,2910,1304 ;P550
	dc.b	0,2						;end of player data: empty String
.tn									;team name: city string (Teamname)
	String	'Tampa Bay'
.ta									;team abbreviation string
	String	'TB'
.tm									;team nickname string
	incbin	..\cdbin\HOCKEY.BIN,$3F86,12	;String	<text>
;CD: no cartridge twin
	incbin	..\cdbin\HOCKEY.BIN,$3F92,18	;read from the disc file
Toronto								;team record 22: TeamList points here; its first lines have no twin
.0									;record base
	incbin	..\cdbin\HOCKEY.BIN,$3FA4,6	;read from the disc file
	dc.w	$0052					;dc.w	.ls-.0
	dc.w	$004C					;dc.w	.sr-.0
	dc.w	$0050					;dc.w	.godds-.0
.pad								;team palettes (home and visitor)
	incbin	..\cdbin\HOCKEY.BIN,$3FB0,32	;home colors (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$3FD0,32	;visitor colors (from the disc file)
;CD: no cartridge twin
	incbin	..\cdbin\HOCKEY.BIN,$3FF0,136	;read from the disc file
	incbin	..\cdbin\HOCKEY.BIN,$4078,22	;Player	<text>,		1974,3433,2344,4143 ;P555
	incbin	..\cdbin\HOCKEY.BIN,$408E,26	;Player	<text>,	2693,3342,3434,4322 ;P556
	incbin	..\cdbin\HOCKEY.BIN,$40A8,22	;Player	<text>,		2593,3333,4033,4141 ;P557
	incbin	..\cdbin\HOCKEY.BIN,$40BE,24	;Player	<text>,	0773,2231,3433,3532 ;P558
	incbin	..\cdbin\HOCKEY.BIN,$40D6,26	;Player	<text>,	14B3,3444,4334,5432 ;P559 Card126
	incbin	..\cdbin\HOCKEY.BIN,$40F0,22	;Player	<text>,		1783,3335,4643,4344 ;P560
	incbin	..\cdbin\HOCKEY.BIN,$4106,22	;Player	<text>,		2192,2242,3422,4413 ;P561
	incbin	..\cdbin\HOCKEY.BIN,$411C,20	;Player	<text>,		1072,2232,3423,4523 ;P562
	incbin	..\cdbin\HOCKEY.BIN,$4130,28	;Player	<text>,	1664,4423,2044,4241 ;P563 Card123
	incbin	..\cdbin\HOCKEY.BIN,$414C,24	;Player	<text>,	0974,4433,2643,4143 ;P564
	incbin	..\cdbin\HOCKEY.BIN,$4164,22	;Player	<text>,		1262,2331,1123,4524 ;P565
	incbin	..\cdbin\HOCKEY.BIN,$417A,22	;Player	<text>,		7182,2232,5533,3523 ;P566
	incbin	..\cdbin\HOCKEY.BIN,$4190,24	;Player	<text>,	2292,2021,2A10,2324 ;P567
	incbin	..\cdbin\HOCKEY.BIN,$41A8,20	;Player	<text>,		2363,3332,4422,4123 ;P568 Card125
	incbin	..\cdbin\HOCKEY.BIN,$41BC,22	;Player	<text>,		0494,4345,4441,4242 ;P569 Card124
	incbin	..\cdbin\HOCKEY.BIN,$41D2,26	;Player	<text>,	1573,2333,1232,3132 ;P570
	incbin	..\cdbin\HOCKEY.BIN,$41EC,26	;Player	<text>,	55A2,2332,3522,3023 ;P571
	incbin	..\cdbin\HOCKEY.BIN,$4206,22	;Player	<text>,		3483,3244,4431,4442 ;P572
	incbin	..\cdbin\HOCKEY.BIN,$421C,20	;Player	<text>,		03A3,3242,4320,4423 ;P573
	incbin	..\cdbin\HOCKEY.BIN,$4230,26	;Player	<text>,	0292,2131,3420,4433 ;P574
	incbin	..\cdbin\HOCKEY.BIN,$424A,20	;Player	<text>,		0882,2023,3523,2324 ;P575
	dc.b	0,2						;end of player data: empty String
.tn									;team name: city string (Teamname)
	String	'Toronto'
.ta									;team abbreviation string
	String	'TOR'
.tm									;team nickname string
	incbin	..\cdbin\HOCKEY.BIN,$4270,14	;String	<text>
.ar									;arena string
	String	'Maple Leaf Gardens'

Vancouver							;team record: Vancouver (VAN), team 23
.0									;record base: six word offsets (Playerdata ... GoalieOdds) from here
	dc.w	$0092					;dc.w	.pld-.0
	dc.w	.pad-.0					;Palettedata
	dc.w	.tn-.0
	dc.w	$0052					;dc.w	.ls-.0
	dc.w	$004C					;dc.w	.sr-.0
	dc.w	$0050					;dc.w	.godds-.0
.pad								;team palettes (home and visitor)
	incbin	..\cdbin\HOCKEY.BIN,$429E,32	;visitor colors (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$42BE,32	;visitor colors (from the disc file)
;CD: no cartridge twin
	incbin	..\cdbin\HOCKEY.BIN,$42DE,92	;read from the disc file
	incbin	..\cdbin\HOCKEY.BIN,$433A,22	;Player	<text>,		3552,3552,0000,2323 ;P577
	incbin	..\cdbin\HOCKEY.BIN,$4350,24	;Player	<text>,	0755,5432,2043,5141 ;P578 Card132
	incbin	..\cdbin\HOCKEY.BIN,$4368,22	;Player	<text>,		1952,2432,1036,4233 ;P579
	incbin	..\cdbin\HOCKEY.BIN,$437E,20	;Player	<text>,		15A2,2332,2223,3022 ;P581
	incbin	..\cdbin\HOCKEY.BIN,$4392,26	;Player	<text>,	1475,5433,1443,3244 ;P582 Card128
	incbin	..\cdbin\HOCKEY.BIN,$43AC,24	;Player	<text>,	3263,3433,3434,3031 ;P583
	incbin	..\cdbin\HOCKEY.BIN,$43C4,20	;Player	<text>,		0873,3443,3235,4131 ;P584
	incbin	..\cdbin\HOCKEY.BIN,$43D8,24	;Player	<text>,	27B4,3333,4623,4424 ;P585
	incbin	..\cdbin\HOCKEY.BIN,$43F0,22	;Player	<text>,		29B2,2232,3A21,3326 ;P586
	incbin	..\cdbin\HOCKEY.BIN,$4406,20	;Player	<text>,		2372,2232,3623,3323 ;P587
	incbin	..\cdbin\HOCKEY.BIN,$441A,20	;Player	<text>,		1055,6544,2054,4442 ;P588 Card129
	incbin	..\cdbin\HOCKEY.BIN,$442E,24	;Player	<text>,	1694,4444,3344,4342 ;P589
	incbin	..\cdbin\HOCKEY.BIN,$4446,20	;Player	<text>,		1792,3333,2125,3123 ;P590
	incbin	..\cdbin\HOCKEY.BIN,$445A,22	;Player	<text>,		25B1,2333,2922,3324 ;P591
	incbin	..\cdbin\HOCKEY.BIN,$4470,20	;Player	<text>,		2692,2122,3923,2324 ;P592
	incbin	..\cdbin\HOCKEY.BIN,$4484,22	;Player	<text>,		2174,3342,3441,4142 ;P593 Card130
	incbin	..\cdbin\HOCKEY.BIN,$449A,22	;Player	<text>,		0393,3233,4341,4142 ;P594 Card131
	incbin	..\cdbin\HOCKEY.BIN,$44B0,24	;Player	<text>,	0672,2332,3622,3023 ;P595
	incbin	..\cdbin\HOCKEY.BIN,$44C8,20	;Player	<text>,		24A3,3333,2631,4134 ;P596
	incbin	..\cdbin\HOCKEY.BIN,$44DC,24	;Player	<text>,	04A3,3234,4731,3434 ;P597
	incbin	..\cdbin\HOCKEY.BIN,$44F4,22	;Player	<text>,		44B2,2343,2630,4233 ;P598
	incbin	..\cdbin\HOCKEY.BIN,$450A,22	;Player	<text>,		0592,3234,4621,4424 ;P599
	incbin	..\cdbin\HOCKEY.BIN,$4520,22	;Player	<text>,		22B2,2132,3632,3324 ;P600
	dc.b	0,2						;end of player data: empty String
.tn									;team name: city string (Teamname)
	String	'Vancouver'
.ta									;team abbreviation string
	String	'VAN'
.tm									;team nickname string
	incbin	..\cdbin\HOCKEY.BIN,$454A,10	;String	<text>
.ar									;arena string
	String	'Pacific Coliseum'

Winnipeg							;team record: Winnipeg (WPG), team 25
.0									;record base: six word offsets (Playerdata ... GoalieOdds) from here
	dc.w	.pld-.0					;Playerdata
	dc.w	.pad-.0					;Palettedata
	dc.w	.tn-.0					;Teamname
	dc.w	.ls-.0					;LineSets
	dc.w	.sr-.0					;ScoutReport
	dc.w	.godds-.0				;GoalieOdds
.pad								;team palettes (home and visitor)
	incbin	..\cdbin\HOCKEY.BIN,$4572,32	;home colors (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$4592,32	;visitor colors (from the disc file)
.sr									;scouting report ratings
;			qreb,hvfx
	dc.w	$4511,$11F8
.godds								;starting goalie weights, 4 nibbles (PickStartingGoalie)
	dc.b	214,0
.ls									;line sets: 8 lines of 8 roster numbers, by position
;			-G,LD,RD,LW,-C,RW,XA,00
	dc.b	01,19,18,04,03,13,09,00	;line 1 NLC (no line changes)
	dc.b	01,22,18,08,03,13,04,00	;line 2 Sc1
	dc.b	01,19,21,09,04,14,03,00	;line 3 Sc2
	dc.b	01,20,24,10,06,17,03,00	;line 4 Chk
	dc.b	01,20,18,08,03,13,04,00	;line 5 PP1
	dc.b	01,19,21,09,04,14,03,00	;line 6 PP2
	dc.b	01,19,21,10,06,05,16,00	;line 7 PK1
	dc.b	01,24,22,05,16,10,06,00	;line 8 PK2
.pld								;player data: one player per row, ended by an empty String
;									unwl,sodp,chga,eytm
	incbin	..\cdbin\HOCKEY.BIN,$45F8,22	;Player	<text>,		3534,4554,0000,4444 ;P601 Card142
	incbin	..\cdbin\HOCKEY.BIN,$460E,22	;Player	<text>,		3062,3222,0000,2222 ;P602
	incbin	..\cdbin\HOCKEY.BIN,$4624,24	;Player	<text>,	1075,3433,3054,4152 ;P603 Card144
	incbin	..\cdbin\HOCKEY.BIN,$463C,22	;Player	<text>,		2584,3433,3444,4053 ;P604 Card139
	incbin	..\cdbin\HOCKEY.BIN,$4652,26	;Player	<text>,	3843,3332,3134,3232 ;P605
	incbin	..\cdbin\HOCKEY.BIN,$466C,22	;Player	<text>,		3673,3242,5422,5123 ;P606
	incbin	..\cdbin\HOCKEY.BIN,$4682,20	;Player	<text>,		1452,3332,2323,3421 ;P607
	incbin	..\cdbin\HOCKEY.BIN,$4696,24	;Player	<text>,	3492,2343,4034,4033 ;P608
	incbin	..\cdbin\HOCKEY.BIN,$46AE,24	;Player	<text>,	0793,2334,3623,4424 ;P609
	incbin	..\cdbin\HOCKEY.BIN,$46C6,20	;Player	<text>,		17A3,3242,3622,4324 ;P610
	incbin	..\cdbin\HOCKEY.BIN,$46DA,24	;Player	<text>,	2163,2122,3623,2522 ;P611
	incbin	..\cdbin\HOCKEY.BIN,$46F2,24	;Player	<text>,	2392,2221,3220,2030 ;P612
	incbin	..\cdbin\HOCKEY.BIN,$470A,24	;Player	<text>,	1365,6534,3345,5442 ;P613 Card140
	incbin	..\cdbin\HOCKEY.BIN,$4722,24	;Player	<text>,	1164,4334,1334,3532 ;P614
	incbin	..\cdbin\HOCKEY.BIN,$473A,20	;Player	<text>,		1592,2332,3322,3122 ;P615
	incbin	..\cdbin\HOCKEY.BIN,$474E,24	;Player	<text>,	1852,3332,3322,3121 ;P616
	incbin	..\cdbin\HOCKEY.BIN,$4766,18	;Player	<text>,			2092,2232,3923,4126 ;P617
	incbin	..\cdbin\HOCKEY.BIN,$4778,22	;Player	<text>,		0666,5433,2462,4062 ;P618 Card141
	incbin	..\cdbin\HOCKEY.BIN,$478E,24	;Player	<text>,	2774,3353,3142,4132 ;P619 Card143
	incbin	..\cdbin\HOCKEY.BIN,$47A6,26	;Player	<text>,	0494,3434,1142,3141 ;P620
	incbin	..\cdbin\HOCKEY.BIN,$47C0,24	;Player	<text>,	0363,3243,4431,4233 ;P621
	incbin	..\cdbin\HOCKEY.BIN,$47D8,22	;Player	<text>,		0592,2242,3621,4024 ;P622
	incbin	..\cdbin\HOCKEY.BIN,$47EE,20	;Player	<text>,		2293,2132,2420,4523 ;P623
	incbin	..\cdbin\HOCKEY.BIN,$4802,22	;Player	<text>,		2692,2132,3320,4423 ;P624
	incbin	..\cdbin\HOCKEY.BIN,$4818,24	;Player	<text>,	0892,2122,3621,2522 ;P625
	dc.b	0,2						;end of player data: empty String
.tn									;team name: city string (Teamname)
	String	'Winnipeg'
.ta									;team abbreviation string
	String	'WPG'
.tm									;team nickname string
	incbin	..\cdbin\HOCKEY.BIN,$4842,6	;String	<text>
.ar									;arena string
	String	'Winnipeg Arena'

Washington							;team record: Washington (WSH), team 24
.0									;record base: six word offsets (Playerdata ... GoalieOdds) from here
	dc.w	.pld-.0					;Playerdata
	dc.w	.pad-.0					;Palettedata
	dc.w	.tn-.0					;Teamname
	dc.w	.ls-.0					;LineSets
	dc.w	.sr-.0					;ScoutReport
	dc.w	.godds-.0				;GoalieOdds
.pad								;team palettes (home and visitor)
	incbin	..\cdbin\HOCKEY.BIN,$4864,32	;home colors (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$4884,32	;visitor colors (from the disc file)
.sr									;scouting report ratings
;			qreb,hvfx
	dc.w	$5220,$11E8
.godds								;starting goalie weights, 4 nibbles (PickStartingGoalie)
	dc.b	181,0
.ls									;line sets: 8 lines of 8 roster numbers, by position
;			-G,LD,RD,LW,-C,RW,XA,00
	dc.b	01,18,17,04,03,12,13,00	;line 1 NLC (no line changes)
	dc.b	01,18,17,10,04,14,03,00	;line 2 Sc1
	dc.b	01,19,20,09,03,12,04,00	;line 3 Sc2
	dc.b	01,21,22,11,05,13,04,00	;line 4 Chk
	dc.b	01,20,17,04,03,12,06,00	;line 5 PP1
	dc.b	01,18,19,06,05,13,04,00	;line 6 PP2
	dc.b	01,21,17,03,14,10,06,00	;line 7 PK1
	dc.b	01,19,20,10,06,03,14,00	;line 8 PK2
.pld								;player data: one player per row, ended by an empty String
;									unwl,sodp,chga,eytm
	incbin	..\cdbin\HOCKEY.BIN,$48EA,22	;Player	<text>,		3343,4333,0000,3333 ;P626 Card133
	incbin	..\cdbin\HOCKEY.BIN,$4900,24	;Player	<text>,	3162,3112,0000,3322 ;P627
	incbin	..\cdbin\HOCKEY.BIN,$4918,22	;Player	<text>,		1794,4433,2044,4042 ;P628 Card134
	incbin	..\cdbin\HOCKEY.BIN,$492E,28	;Player	<text>,	0873,3434,3146,4142 ;P629 Card135
	incbin	..\cdbin\HOCKEY.BIN,$494A,22	;Player	<text>,		3282,2443,4624,4044 ;P630
	incbin	..\cdbin\HOCKEY.BIN,$4960,24	;Player	<text>,	2083,3433,3443,4043 ;P631
	incbin	..\cdbin\HOCKEY.BIN,$4978,26	;Player	<text>,	2262,2222,3222,2222 ;P632
	incbin	..\cdbin\HOCKEY.BIN,$4992,24	;Player	<text>,	1572,2212,2622,1322 ;P633
	incbin	..\cdbin\HOCKEY.BIN,$49AA,24	;Player	<text>,	1174,4333,2432,3443 ;P634
	incbin	..\cdbin\HOCKEY.BIN,$49C2,22	;Player	<text>,		2162,3232,2422,3512 ;P635
	incbin	..\cdbin\HOCKEY.BIN,$49D8,18	;Player	<text>,			1692,2233,3722,3425 ;P636
	incbin	..\cdbin\HOCKEY.BIN,$49EA,22	;Player	<text>,		1264,6433,2044,4232 ;P637 Card136
	incbin	..\cdbin\HOCKEY.BIN,$4A00,22	;Player	<text>,		1963,3333,2335,3122 ;P638
	incbin	..\cdbin\HOCKEY.BIN,$4A16,22	;Player	<text>,		1084,4333,2043,3241 ;P639
	incbin	..\cdbin\HOCKEY.BIN,$4A2C,22	;Player	<text>,		2672,2222,3323,2234 ;P640
	incbin	..\cdbin\HOCKEY.BIN,$4A42,24	;Player	<text>,	2392,2232,4724,3323 ;P641
	incbin	..\cdbin\HOCKEY.BIN,$4A5A,24	;Player	<text>,	04C3,3445,4342,4443 ;P642 Card137
	incbin	..\cdbin\HOCKEY.BIN,$4A72,20	;Player	<text>,		34B4,4446,4642,4444 ;P643 Card138
	incbin	..\cdbin\HOCKEY.BIN,$4A86,22	;Player	<text>,		0363,3343,3132,4432 ;P644
	incbin	..\cdbin\HOCKEY.BIN,$4A9C,26	;Player	<text>,	0694,3344,3441,4142 ;P645
	incbin	..\cdbin\HOCKEY.BIN,$4AB6,24	;Player	<text>,	14A3,3233,3431,3532 ;P646
	incbin	..\cdbin\HOCKEY.BIN,$4ACE,24	;Player	<text>,	3692,2122,3621,2331 ;P647
	incbin	..\cdbin\HOCKEY.BIN,$4AE6,24	;Player	<text>,	2562,2111,2220,1212 ;P648
	incbin	..\cdbin\HOCKEY.BIN,$4AFE,22	;Player	<text>,		05B3,2022,3230,2323 ;P649
	dc.b	0,2						;end of player data: empty String
.tn									;team name: city string (Teamname)
	String	'Washington'
.ta									;team abbreviation string
	String	'WSH'
.tm									;team nickname string
	incbin	..\cdbin\HOCKEY.BIN,$4B28,10	;String	<text>
.ar									;arena string
	String	'Capital Centre'

Florida								;team record: Florida (FLA), team 8
.0									;record base: six word offsets (Playerdata ... GoalieOdds) from here
	dc.w	.pld-.0					;Playerdata
	dc.w	.pad-.0					;Palettedata
	dc.w	.tn-.0					;Teamname
	dc.w	.ls-.0					;LineSets
	dc.w	.sr-.0					;ScoutReport
	dc.w	.godds-.0				;GoalieOdds
.pad								;new team palettes (home and visitor)
	incbin	..\cdbin\HOCKEY.BIN,$4B4E,32	;home colors (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$4B6E,32	;visitor colors (from the disc file)
.sr									;scouting report ratings
;			qreb,hvfx
	dc.w	$0702,$1396
.godds								;starting goalie weights, 4 nibbles (PickStartingGoalie)
	dc.b	214,0
.ls									;line sets: 8 lines of 8 roster numbers, by position
;			-G,LD,RD,LW,-C,RW,XA,00
	dc.b	01,14,12,08,05,04,07,00	;line 1 NLC (no line changes)
	dc.b	01,14,17,08,05,03,04,00	;line 2 Sc1
	dc.b	01,16,12,06,10,11,05,00	;line 3 Sc2
	dc.b	01,13,15,07,09,04,05,00	;line 4 Chk
	dc.b	01,14,12,08,05,04,10,00	;line 5 PP1
	dc.b	01,13,17,06,10,03,05,00	;line 6 PP2
	dc.b	01,14,12,09,05,07,08,00	;line 7 PK1
	dc.b	01,13,17,07,08,09,05,00	;line 8 PK2
.pld								;player data: one player per row, ended by an empty String
;									unwl,sodp,chga,eytm
	incbin	..\cdbin\HOCKEY.BIN,$4BD4,26	;Player	<text>,	3453,4553,0000,3434 ;P650
	incbin	..\cdbin\HOCKEY.BIN,$4BEE,26	;Player	<text>,	3072,4223,0000,2222 ;P651
	incbin	..\cdbin\HOCKEY.BIN,$4C08,24	;Player	<text>,	1482,2232,2122,3222 ;P652
	incbin	..\cdbin\HOCKEY.BIN,$4C20,24	;Player	<text>,	2791,1333,4723,3324 ;P653
	incbin	..\cdbin\HOCKEY.BIN,$4C38,26	;Player	<text>,	3984,2242,4633,4434 ;P654
	incbin	..\cdbin\HOCKEY.BIN,$4C52,20	;Player	<text>,		1873,2333,2432,3233 ;P655
	incbin	..\cdbin\HOCKEY.BIN,$4C66,20	;Player	<text>,		1082,2232,3622,3424 ;P656
	incbin	..\cdbin\HOCKEY.BIN,$4C7A,24	;Player	<text>,	2374,3323,1233,3242 ;P657
	incbin	..\cdbin\HOCKEY.BIN,$4C92,22	;Player	<text>,		2072,2132,3221,3521 ;P658
	incbin	..\cdbin\HOCKEY.BIN,$4CA8,24	;Player	<text>,	2941,2312,2022,1421 ;P659
	incbin	..\cdbin\HOCKEY.BIN,$4CC0,22	;Player	<text>,		2271,2222,2022,2421 ;P660
	incbin	..\cdbin\HOCKEY.BIN,$4CD6,22	;Player	<text>,		06A3,3223,2922,3323 ;P661
	incbin	..\cdbin\HOCKEY.BIN,$4CEC,28	;Player	<text>,	21A2,3222,3822,3512 ;P662
	incbin	..\cdbin\HOCKEY.BIN,$4D08,22	;Player	<text>,		2885,4234,4931,3333 ;P663
	incbin	..\cdbin\HOCKEY.BIN,$4D1E,20	;Player	<text>,		2642,2221,3222,2522 ;P664
	incbin	..\cdbin\HOCKEY.BIN,$4D32,22	;Player	<text>,		4383,2112,3821,2224 ;P665
	incbin	..\cdbin\HOCKEY.BIN,$4D48,26	;Player	<text>,	2593,3333,3332,3322 ;P666
	dc.b	0,2						;end of player data: empty String
.tn									;team name: city string (Teamname)
	String	'Florida'
.ta									;team abbreviation string
	String	'FLA'
.tm									;team nickname string
	incbin	..\cdbin\HOCKEY.BIN,$4D74,10	;String	<text>
.ar									;arena string
	String	'Miami Arena'

Anaheim								;team record: Anaheim (ANH), team 0
.0									;record base: six word offsets (Playerdata ... GoalieOdds) from here
	dc.w	.pld-.0					;Playerdata
	dc.w	.pad-.0					;Palettedata
	dc.w	.tn-.0					;Teamname
	dc.w	.ls-.0					;LineSets
	dc.w	.sr-.0					;ScoutReport
	dc.w	.godds-.0				;GoalieOdds
.pad								;new team palettes (home and visitor)
	incbin	..\cdbin\HOCKEY.BIN,$4D98,32	;home colors (from the disc file)
	incbin	..\cdbin\HOCKEY.BIN,$4DB8,32	;visitor colors (from the disc file)
.sr									;scouting report ratings
;			qreb,hvfx
	dc.w	$0702,$1397
.godds								;starting goalie weights, 4 nibbles (PickStartingGoalie)
	dc.b	214,0
.ls									;line sets: 8 lines of 8 roster numbers, by position
;			-G,LD,RD,LW,-C,RW,XA,00
	dc.b	01,12,14,04,06,08,03,00	;line 1 NLC (no line changes)
	dc.b	01,12,16,03,06,11,04,00	;line 2 Sc1
	dc.b	01,14,15,09,08,07,03,00	;line 3 Sc2
	dc.b	01,13,18,04,10,05,03,00	;line 4 Chk
	dc.b	01,12,16,04,06,08,04,00	;line 5 PP1
	dc.b	01,13,15,03,09,11,03,00	;line 6 PP2
	dc.b	01,12,14,06,07,04,08,00	;line 7 PK1
	dc.b	01,17,16,04,08,07,06,00	;line 8 PK2
.pld								;player data: one player per row, ended by an empty String
;									unwl,sodp,chga,eytm
	incbin	..\cdbin\HOCKEY.BIN,$4E1E,20	;Player	<text>,		2962,3332,0000,2222 ;P667
	incbin	..\cdbin\HOCKEY.BIN,$4E32,22	;Player	<text>,		0122,3331,0000,1112 ;P668
	incbin	..\cdbin\HOCKEY.BIN,$4E48,22	;Player	<text>,		2772,2322,1323,3422 ;P669
	incbin	..\cdbin\HOCKEY.BIN,$4E5E,20	;Player	<text>,		24A2,3232,4621,3213 ;P670
	incbin	..\cdbin\HOCKEY.BIN,$4E72,22	;Player	<text>,		23B1,1021,3A11,2514 ;P671
	incbin	..\cdbin\HOCKEY.BIN,$4E88,20	;Player	<text>,		2563,3433,3334,4032 ;P672
	incbin	..\cdbin\HOCKEY.BIN,$4E9C,20	;Player	<text>,		30A2,2132,2322,3522 ;P673
	incbin	..\cdbin\HOCKEY.BIN,$4EB0,26	;Player	<text>,	2073,3343,2033,4032 ;P674
	incbin	..\cdbin\HOCKEY.BIN,$4ECA,22	;Player	<text>,		2862,3322,2623,2222 ;P675
	incbin	..\cdbin\HOCKEY.BIN,$4EE0,20	;Player	<text>,		26B2,2112,1514,1323 ;P676
	incbin	..\cdbin\HOCKEY.BIN,$4EF4,22	;Player	<text>,		4152,2322,1022,1411 ;P677
	incbin	..\cdbin\HOCKEY.BIN,$4F0A,26	;Player	<text>,	07B4,3234,4441,3142 ;P678
	incbin	..\cdbin\HOCKEY.BIN,$4F24,20	;Player	<text>,		3882,2222,3521,2314 ;P679
	incbin	..\cdbin\HOCKEY.BIN,$4F38,26	;Player	<text>,	39B3,3131,2421,3514 ;P680
	incbin	..\cdbin\HOCKEY.BIN,$4F52,24	;Player	<text>,	0382,2222,2520,2213 ;P681
	incbin	..\cdbin\HOCKEY.BIN,$4F6A,22	;Player	<text>,		33B3,2332,3422,2421 ;P682
	incbin	..\cdbin\HOCKEY.BIN,$4F80,22	;Player	<text>,		32B2,1121,2110,2111 ;P683
	incbin	..\cdbin\HOCKEY.BIN,$4F96,22	;Player	<text>,		17B1,1121,3810,2113 ;P684
	dc.b	0,2						;end of player data: empty String
.tn									;team name: city string (Teamname)
	String	'Anaheim'
.ta									;team abbreviation string
	String	'ANH'
;CD: no cartridge twin
	incbin	..\cdbin\HOCKEY.BIN,$4FBE,22	;read from the disc file
.ar									;arena string
	String	'Pond'

;PlayoffRows equ 32					;playoffseats rows (NewPO picks one at random)	(defined in hockey.inc)
;PlayoffRowTeams equ 16				;teams per playoffseats row	(defined in hockey.inc)
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
;CD: no cartridge twin
	incbin	..\cdbin\HOCKEY.BIN,$504A,64	;read from the disc file
	dc.b	NYI,PIT,OTW,MTL, NYR,BUF,NJ,BOS, DAL,DET,LA,CHI, SJ,TOR,STL,VAN
	dc.b	QUE,BOS,NYR,BUF, OTW,MTL,PHI,PIT, DAL,VAN,SJ,TOR, EDM,CHI,CGY,DET
	dc.b	NJ,MTL,NYR,PIT, OTW,BOS,HFD,BUF, STL,TOR,SJ,CHI, DAL,DET,EDM,VAN
;CD: no cartridge twin
	incbin	..\cdbin\HOCKEY.BIN,$50BA,16	;read from the disc file
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
;CD: no cartridge twin
	incbin	..\cdbin\HOCKEY.BIN,$51DA,24	;read from the disc file
Credits								;CD: its first lines have no twin; the rest of it starts here
	String	'Licensed by'
	String	'Sega Enterprises Ltd.'
	String	CC_PageEnd

CreditsPages						;CD: its first lines have no twin; the rest of it starts here
	dc.w	2
	String	CC_PageEnd

	String	CC_PageEnd
;CD: no cartridge twin
	incbin	..\cdbin\HOCKEY.BIN,$5226,202	;read from the disc file
	String	CC_PageEnd

	String	'Produced by'
	String	'Michael Brook'
	String	CC_PageEnd

	String	'Assistant Producer'
;CD: no cartridge twin
	incbin	..\cdbin\HOCKEY.BIN,$532A,122	;read from the disc file
	String	CC_PageEnd

	String	'Player Ratings by'
	String	'Igor Kuperman'
	String	CC_PageEnd
;CD: no cartridge twin
	incbin	..\cdbin\HOCKEY.BIN,$53D0,98	;read from the disc file
