;	NHL 94 (retail) segment $18CFC-$1A04F
;	Data only, as 93 hockey93_11: the 92 crowd frame table (updatecrowdf .cd0), the player logic assignment table asstab, PenaltyList,
;	the 94 penalty shot table (unk_1913A), bfasciicon, linelist (IDA FaceOffsprites), PlayerPositionText, PerLabels, sizetab, sublist,
;	priolist, the playoff tree layout (PlayoffTreeSetup), the attribute column lists, and the menu item lists for the pause,
;	intermission and line editor exit menus. sram94 (InitSaveRAM) starts at $1A050.
;	Transcribed from lst/nhl94.bin.lst lines 56543-61321 (IDA dc.b / dc.w / dc.l). Global names are the IDA names, or the 93 name where
;	IDA has an auto name or no label (IDA name in an ;IDA: comment). IDA labels the code reads inside a table stay (unk_1940E,
;	dword_19420, unk_19570, dword_19582). IDA read two attribute column longs as offsets (unk_2000A, unk_8000A); they are dc.w pairs.
;	Code addresses in the tables are the routines in the earlier segments (asstab, the menu handlers); handlers in the stats code
;	and the high ROM that no matched segment owns have IDA-style names (sub_xxxx, no IDA label), with the 93 name in the comment.
;	Menu item lists (as 93): two print2 control Strings, then per item a String and the handler address (dc.l). Item 0 leaves the menu,
;	its handler is rtss2. String $FF ends.

cd0	;IDA: _cd0. $fftt = frame/time for various levels of crowd excitement. 92 updatecrowdf .cd0, same bytes as 93.
	;Used by updatecrowdf (hockey94_01), indexed by crowd level and crowdstep
	dc.w	$010c,$020c,$030c,$040c,$050c,$0a0c,$090c,$080c
	dc.w	$060c,$070c,$080c,$090c,$0a0c,$050c,$040c,$030c

	dc.w	$0107,$0207,$0307,$0407,$0507,$0b07,$0c07,$0d07
	dc.w	$0607,$0707,$0807,$0907,$0a07,$0b07,$0c07,$0d07

	dc.w	$0e07,$0f07,$1007,$1107,$1207,$0b07,$0c07,$0d07
	dc.w	$1207,$1107,$1007,$0f07,$0e07,$0d07,$0c07,$0b07

	dc.w	$0e03,$0f03,$1003,$1103,$1203,$0b03,$0c03,$0d03
	dc.w	$1203,$1103,$1003,$0f03,$0e03,$0d03,$0c03,$0b03

asstab	;jump table of all the player logic assignments. 92 / 93 asstab; 94 adds 7 entries ($1D-$23). Used by updateplayers
	dc.l	rtss2		;0 (93 rtss)
	dc.l	assdefo		;1 adefo
	dc.l	assdefd		;2 adefd
	dc.l	asswingd		;3 awingd
	dc.l	asswingo		;4 awingo
	dc.l	asscenterd	;5 acenterd
	dc.l	asscentero	;6 acentero
	dc.l	assscore		;7 ascore
	dc.l	assstanley	;8 astanley
	dc.l	asseben		;9 aeben
	dc.l	assepen		;$A aepen
	dc.l	assbench		;$B abench
	dc.l	asspenalty	;$C apenalty
	dc.l	assdopen		;$D adopen
	dc.l	assgoaliecpu	;$E agoalie (93 assgoalie)
	dc.l	assgoalietopuck	;$F
	dc.l	asspuckc		;$10 apuckc
	dc.l	assnearest	;$11 anearest
	dc.l	assshoot		;$12 ashoot
	dc.l	asspassrec	;$13 apassrec
	dc.l	assfight		;$14 afight
	dc.l	assfwatch		;$15
	dc.l	assfaceoff	;$16
	dc.l	assfaceoffp1	;$17
	dc.l	pucknorm		;$18 puck logic
	dc.l	puckshadow	;$19
	dc.l	puckunflip	;$1A (93 pucknothing)
	dc.l	puckfaceoff	;$1B
	dc.l	puckfaceoff2	;$1C
	dc.l	assgoaliectrl	;$1D 94 only
	dc.l	puckshootout	;$1E 94 only
	dc.l	puckpenshot	;$1F 94 only
	dc.l	assgoaliebreakwait	;$20 94 only
	dc.l	chkpuckc		;$21 94 only
	dc.l	assbreakaway	;$22 94 only
	dc.l	assonetimer	;$23 94 only (high ROM)

PenaltyList	;92 Penaltylist, 93 numbers. Penalty number = word offset into this table; 94 adds 8 entries ($2E-$3C: the penalty shot
	;versions of 7 penalties, minutes byte $FF, and a second Face Off). Used by AddPenalty, SetPA2, sub_187B8 (hockey94_10), ...
	dc.w	$0000
	dc.w	.eop-PenaltyList	;$2 period over
	dc.w	.eog-PenaltyList	;$4 game over
	dc.w	.ghold-PenaltyList	;$6
	dc.w	.ghold-PenaltyList	;$8
	dc.w	.whistle-PenaltyList	;$A whistle
	dc.w	.ice-PenaltyList	;$C icing
	dc.w	.goal-PenaltyList	;$E goal
	dc.w	.offsides-PenaltyList	;$10 offsides
	dc.w	.rough2-PenaltyList	;$12 roughing, slow down time $A
	dc.w	.p14-PenaltyList	;$14 no text
	dc.w	.charge-PenaltyList	;$16
	dc.w	.slash-PenaltyList	;$18
	dc.w	.rough-PenaltyList	;$1A
	dc.w	.cross-PenaltyList	;$1C
	dc.w	.hook-PenaltyList	;$1E
	dc.w	.trip-PenaltyList	;$20
	dc.w	.int-PenaltyList	;$22
	dc.w	.hold-PenaltyList	;$24
	dc.w	.fight-PenaltyList	;$26
	dc.w	.fight2-PenaltyList	;$28
	dc.w	.inst-PenaltyList	;$2A
	dc.w	.delay-PenaltyList	;$2C delay
	dc.w	.hookps-PenaltyList	;$2E 94: penalty shot
	dc.w	.tripps-PenaltyList	;$30 94: penalty shot
	dc.w	.ghold2-PenaltyList	;$32 94: face off, no slow down
	dc.w	.intps-PenaltyList	;$34 94: penalty shot
	dc.w	.roughps-PenaltyList	;$36 94: penalty shot
	dc.w	.chargeps-PenaltyList	;$38 94: penalty shot
	dc.w	.crossps-PenaltyList	;$3A 94: penalty shot
	dc.w	.slashps-PenaltyList	;$3C 94: penalty shot

;format
;	dc.w	$ttmm	;tt=slow dnw time in half secs,mm=penalty min.
;	String	'penalty text'
;	dc.w	$ffdd,$ffdd,$ffdd,...	;ff = frame,dd=delay (neg for end)

.eop	dc.w	$0100
	String	'Period Over'
	dc.w	-$0510
.eog	dc.w	$0100
	String	'Game Over'
	dc.w	$0510,-$4060
.goal	dc.w	$0100
	dc.w	2			;String with no text
	dc.w	$050a,-$4018
.p14	dc.w	$0100
	dc.w	2			;String with no text
	dc.w	$0510,-$4018
.ice	dc.w	$0100
	String	'Icing'
	dc.w	$0002,$0101,-$0206
.offsides	dc.w	$0100
	String	'Off-side'
	dc.w	$0002,$0301,-$040f
.ghold	dc.w	$0100
	String	'Face Off'
	dc.w	-$050a
.ghold2	dc.w	$0000
	String	'Face Off'
	dc.w	-$050a
.delay	dc.w	$0000
	String	'Penalty'
	dc.w	$0003,$0301,-$040f
.whistle	dc.w	$0000
	dc.w	2			;String with no text
	dc.w	-$050a
.charge	dc.w	$0402
	String	'Charging'
	dc.w	$0004,$0101,$0a01,$0b01,$0a01,$0b01,$0a01,$0b01,$0a01,$0b01,-$0101
.chargeps	dc.w	$04ff
	String	'Charging'
	dc.w	$0004,$0101,$0a01,$0b01,$0a01,$0b01,$0a01,$0b01,$0a01,$0b01,-$0101
.slash	dc.w	$0402
	String	'Slashing'
	dc.w	$0004,$0101,$0201,$0301,$0201,$0301,$0201,$0301,$0201,$0301,-$0101
.slashps	dc.w	$04ff
	String	'Slashing'
	dc.w	$0004,$0101,$0201,$0301,$0201,$0301,$0201,$0301,$0201,$0301,-$0101
.trip	dc.w	$0402
	String	'Tripping'
	dc.w	$0004,$0401,$0501,$0401,$0501,$0401,$0501,$0401,$0501,-$0101
.tripps	dc.w	$04ff
	String	'Tripping'
	dc.w	$0004,$0401,$0501,$0401,$0501,$0401,$0501,$0401,$0501,-$0101
.rough2	dc.w	$0a02
	String	'Roughing'
	dc.w	$0004,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,-$0101
.rough	dc.w	$0402
	String	'Roughing'
	dc.w	$0004,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,-$0101
.roughps	dc.w	$04ff
	String	'Roughing'
	dc.w	$0004,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,-$0101
.hook	dc.w	$0402
	String	'Hooking'
	dc.w	$0004,$0101,$0901,$0801,$0901,$0801,$0901,$0801,$0901,$0801,-$0101
.hookps	dc.w	$04ff
	String	'Hooking'
	dc.w	$0004,$0101,$0901,$0801,$0901,$0801,$0901,$0801,$0901,$0801,-$0101
.cross	dc.w	$0402
	String	'Cross Check'
	dc.w	$0004,$0601,$0f01,$1001,$0f01,$1001,$0f01,$1001,$0f01,$1001,-$0101
.crossps	dc.w	$04ff
	String	'Cross Check'
	dc.w	$0004,$0601,$0f01,$1001,$0f01,$1001,$0f01,$1001,$0f01,$1001,-$0101
.int	dc.w	$0402
	String	'Interference'
	dc.w	$0004,$0101,$0c06,-$0101
.intps	dc.w	$04ff
	String	'Interference'
	dc.w	$0004,$0101,$0c06,-$0101
.hold	dc.w	$0402
	String	'Holding'
	dc.w	$0004,$0101,$0706,-$0101
.fight	dc.w	$2805
	String	'Fighting'
	dc.w	$0004,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,-$0101
.fight2	dc.w	$2805
	String	'Fighting *'
	dc.w	$0004,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,-$0101
.inst	dc.w	$2802
	String	'Fight Instigator'
	dc.w	$0004,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,-$0101

unk_1913A	;IDA name. 94 only: the penalty shot penalty number for penalty number d0 (word offset), -1 none. Used by PenShotChk
	;(penalty94_1)
	dc.w	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,$38,$3C
	dc.w	$36,$3A,$2E,$30,$34,-1,-1,-1,-1,-1,-1,-1

bfasciicon	;IDA: unk_1916A. equates to find each char definition for bigfont.map. 92 bfasciicon, 93 values. Indexed by ascii
	;- $20 in sub_11E8E (middle94_2, called from printbig)
;	 -  -!  "  #  $  %  &  -'  (  )  *  +  ,  -  -.  /
	dc.b	-76,-73,00,00,00,00,00,-71,00,00,00,00,00,00,-72,00
;	 0   1  2  3  4  5  6  7  8  9   :  ;  <  =  >  ?
	dc.b	51,-53,54,56,58,60,62,64,66,68,-71,00,00,00,00,74
;	@  A  B  C  D  E  F  G	H  -I  J  K  L  M  N  O
	dc.b	74,00,02,04,06,08,10,12,14,-16,17,19,21,23,25,27
;	P  Q  R  S  T  U  V  W	X  Y  Z
	dc.b	29,31,33,35,37,39,41,43,45,47,49
	dc.b	$FF			;pad (93 $F0)

FaceOffsprites	String	'Sc1'	;IDA name (93 linelist). text list for line choices. Used by SetLCmode2 and puckfaceoff2
	String	'Sc2'
	String	'Chk'
	String	'PP1'
	String	'PP2'
	String	'PK1'
	String	'PK2'

PlayerPositionText	String	'LD'	;IDA: unk_191D0 (93 name). position names for the line slots. Used by sub_8BA6
	String	'RD'
	String	'LW'
	String	'C'
	String	'RW'

PerLabels	String	'1',$12	;IDA: unk_191E4 (93 name). text list for periods; 94 ' F' (93 'Final'). Used by PrintScores1, NewTicker3
	String	'2',$13
	String	'3',$14
	String	'OT'
	String	' F'

unk_191F8	String	'1',$12	;IDA name. 94 only: the same with a blank last entry. Used by PrintScores1
	String	'2',$13
	String	'3',$14
	String	'OT'
	String	'  '

sizetab	;sprite size code to tile count. 92 video.asm sizetab, used by addframe2
	dc.b	1,2,3,4,2,4,6,8,3,6,9,12,4,8,12,16

sublist	;substitution lists by position (goalie, LD, RD, LW, C, RW, extra attacker). 92 sublist; 93 / 94 word offsets from
	;sublist. Used by SetPlList
	dc.w	.defl-sublist		;goalie
	dc.w	.defl-sublist
	dc.w	.defr-sublist
	dc.w	.wingl-sublist
	dc.w	.center-sublist
	dc.w	.wingr-sublist
	dc.w	.center-sublist

.defl	dc.b	0+1,8+1,16+1,24+1,32+1,40+1,48+1	;list of players in there lines/each line = 8 bytes
	dc.b	0+2,8+2,16+2,24+2,32+2,40+2,48+2
.defr	dc.b	0+2,8+2,16+2,24+2,32+2,40+2,48+2
	dc.b	0+1,8+1,16+1,24+1,32+1,40+1,48+1
.wingl	dc.b	0+3,8+3,16+3,24+3,32+3,40+3,48+3
	dc.b	0+5,8+5,16+5,24+5,32+5,40+5,48+5
	dc.b	0+4,8+4,16+4,24+4,32+4,40+4,48+4
.wingr	dc.b	0+5,8+5,16+5,24+5,32+5,40+5,48+5
	dc.b	0+3,8+3,16+3,24+3,32+3,40+3,48+3
	dc.b	0+4,8+4,16+4,24+4,32+4,40+4,48+4
.center	dc.b	0+4,8+4,16+4,24+4,32+4,40+4,48+4
	dc.b	0+3,8+3,16+3,24+3,32+3,40+3,48+3
	dc.b	0+5,8+5,16+5,24+5,32+5,40+5,48+5
	dc.b	-1

priolist	dc.b	0,1,2,4,3,5,6	;positions in order of importance. 92 priolist. Used by SetPlList,
	;releasepl and getlinee
	dc.b	$FF			;pad (93 $23)

PlayoffTreeSetup	;IDA: unk_1928E (93 name). Playoff tree layout by gamelevel. 92 PlayoffScreen .setup, same layout with 94
	;columns. Used by PlayoffScreen (hockey94_06)
	dc.w	.l0-PlayoffTreeSetup
	dc.w	.l1-PlayoffTreeSetup
	dc.w	.l2-PlayoffTreeSetup
	dc.w	.l3-PlayoffTreeSetup
	dc.w	.l4-PlayoffTreeSetup

	;tree graphics for level 0: teams-1 then x,y per team (DrawTeamBlocks), arrows-1 then x,d0 per arrow
	;(DrawPlayoffBracket), scores-1 then x,y per score (FormatScore, negative: none)
.l0	dc.b	16-1
	dc.b	46,2,46,5,46,8,46,11,46,14,46,17,46,20,46,23
	dc.b	71,2,71,5,71,8,71,11,71,14,71,17,71,20,71,23
	dc.b	1,57,0,69,10
	dc.b	7,50,4,50,10,50,16,50,22,75,4,75,10,75,16,75,22

	;tree graphics for level 1
.l1	dc.b	16+8-1
	dc.b	32,2,32,5,32,8,32,11,32,14,32,17,32,20,32,23
	dc.b	85,2,85,5,85,8,85,11,85,14,85,17,85,20,85,23
	dc.b	46,4,46,10,46,15,46,21
	dc.b	71,4,71,10,71,15,71,21
	dc.b	3,43,0,57,2,69,8,83,10
	dc.b	3,50,8,50,18,75,8,75,18

	;tree graphics for level 2
.l2	dc.b	16+8+4-1
	dc.b	18,2,18,5,18,8,18,11,18,14,18,17,18,20,18,23
	dc.b	99,2,99,5,99,8,99,11,99,14,99,17,99,20,99,23
	dc.b	32,4,32,10,32,15,32,21
	dc.b	85,4,85,10,85,15,85,21
	dc.b	46,7,46,18
	dc.b	71,7,71,18
	dc.b	5,29,0,43,2,57,4,69,6,83,8,97,10
	dc.b	1,50,13,75,13

	;tree graphics for level 3
.l3	dc.b	16+8+4+2-1
	dc.b	4,2,4,5,4,8,4,11,4,14,4,17,4,20,4,23
	dc.b	113,2,113,5,113,8,113,11,113,14,113,17,113,20,113,23
	dc.b	18,4,18,10,18,15,18,21
	dc.b	99,4,99,10,99,15,99,21
	dc.b	32,7,32,18
	dc.b	85,7,85,18
	dc.b	46,12
	dc.b	71,12
	dc.b	5,15,0,29,2,43,4,83,6,97,8,111,10
	dc.b	0,63,23

	;tree graphics for level 4
.l4	dc.b	16+8+4+2+1-1
	dc.b	4,2,4,5,4,8,4,11,4,14,4,17,4,20,4,23
	dc.b	113,2,113,5,113,8,113,11,113,14,113,17,113,20,113,23
	dc.b	18,4,18,10,18,15,18,21
	dc.b	99,4,99,10,99,15,99,21
	dc.b	32,7,32,18
	dc.b	85,7,85,18
	dc.b	46,12
	dc.b	71,12
	dc.b	58,23
	dc.b	5,15,0,29,2,43,4,83,6,97,8,111,10
	dc.b	-1			;no scores
	dc.b	$FF			;pad (93 $47)

PAttribColumns	;IDA name (93 PAttribColumns). Skater attribute columns for PrintAttribHeader / the player list. String header,
	;then a long for getNameandAttrib: high word = mask of rating nibbles to average, low word = attribjmp offset (0 status, 2 energy,
	;4 handed, 6 weight, 8 fighting, $A rating). A negative word ends the list. 94 has no Fighting column. unk_1940E / dword_19420 (the
	;Overall entry) are read by sub_FC850, sub_FA8AC and hockey94_07
	String	'     Status    ]'
	dc.w	$0000,$0		;status
unk_1940E	String	'[   Overall    ]'
dword_19420	dc.w	$1fba,$a
	String	'[   Energy     ]'
	dc.w	$0000,$2		;energy
	String	'[   Agility    ]'
	dc.w	$1000,$a
	String	'[    Speed     ]'
	dc.w	$0800,$a
	String	'[   Handed     ]'
	dc.w	$0040,$4		;handed
	String	'[Off. Awareness]'
	dc.w	$0400,$a
	String	'[Def. Awareness]'
	dc.w	$0200,$a
	String	'[  Shot Power  ]'
	dc.w	$0100,$a
	String	'[Shot  Accuracy]'
	dc.w	$0010,$a
	String	'[Pass  Accuracy]'
	dc.w	$0002,$a
	String	'[Stick Handling]'
	dc.w	$0020,$a
	String	'[    Weight    ]'
	dc.w	$2000,$6		;weight
	String	'[  Endurance   ]'
	dc.w	$0008,$a
	String	'[Aggressiveness]'
	dc.w	$0001,$a
	String	'[   Checking    '
	dc.w	$0080,$a
	dc.w	-1

GAttribColumns	;IDA name (93 GAttribColumns). Goalie attribute columns, same format as PAttribColumns. unk_19570 /
	;dword_19582 (the Overall entry) are read by sub_FC850, sub_FA8AC and hockey94_07
	String	'     Status    ]'
	dc.w	$0000,$0		;status
unk_19570	String	'[   Overall    ]'
dword_19582	dc.w	$130f,$a
	String	'[   Agility    ]'
	dc.w	$1000,$a
	String	'[    Speed     ]'
	dc.w	$0800,$a
	String	'[  Glove Hand  ]'
	dc.w	$0040,$4		;handed
	String	'[Def. Awareness]'
	dc.w	$0200,$a
	String	'[ Puck Control ]'
	dc.w	$0100,$a
	String	'[ Stick  Right ]'
	dc.w	$0008,$a
	String	'[  Stick Left  ]'
	dc.w	$0004,$a
	String	'[ Glove  Right ]'
	dc.w	$0002,$a
	String	'[  Glove Left  ]'
	dc.w	$0001,$a
	String	'[    Weight     '
	dc.w	$2000,$6		;weight
	dc.w	-1

unk_19664	;IDA name. 94 only: pause menu item list (PauseMode; hockey94_01)
	String	$FE,5
	String	$FE,4
	String	'   Resume Game    '
	dc.l	rtss2
	String	'  Instant Replay  '
	dc.l	ReplayMode
	String	'   Team Roster    '
	dc.l	sub_89AC	;93 TeamRosterScreen
	String	'   Player Cards   '
	dc.l	sub_FA07E	;94 only
	String	'  Record Holders  '
	dc.l	sub_FBC14	;94 only
	String	'x Manual Goalie   '
	dc.l	sub_FE1D8	;94 only
	String	$FF

PauseText	;IDA: unk_19700 (93 name). Pause menu item list (PauseMode, hockey94_01)
	String	$FE,5
	String	$FE,4
	String	'   Resume Game    '
	dc.l	rtss2
	String	'  Instant Replay  '
	dc.l	ReplayMode
	String	'  Change Goalie   '
	dc.l	sub_9DE6	;93 SelectGoalieMenu
	String	'    Edit Lines    '
	dc.l	sub_82DA	;93 LineEditor
	String	'    Game Stats    '
	dc.l	sub_FDC5A	;93 GameStatisticsScreen
	String	'   Player Stats   '
	dc.l	sub_945A	;93 PlayerStatsScreen
	String	' Scoring Summary  '
	dc.l	sub_8EB0	;93 ScoringSummaryScreen
	String	' Penalty Summary  '
	dc.l	sub_9142	;93 PenaltySummaryScreen
	String	'   Team Roster    '
	dc.l	sub_89AC	;93 TeamRosterScreen
	String	'   Other Scores   '
	dc.l	sub_80D4	;93 ShowScores
	String	'   Crowd Meter    '
	dc.l	sub_9A2A	;93 CrowdMeterScreen
	String	'     Timeout      '
	dc.l	sub_9D7A	;93 TimeoutMenu
	String	'   Player Cards   '
	dc.l	sub_FA07E	;94 only
	String	'  Record Holders  '
	dc.l	sub_FBC14	;94 only
	String	'   Period Stats   '
	dc.l	sub_FD90C	;94 only
	String	'x Manual Goalie   '
	dc.l	sub_FE1D8	;94 only
	String	$FF

PauseText2	;IDA: unk_1988C (93 name). Pause menu item list without Timeout (PauseMode)
	String	$FE,5
	String	$FE,4
	String	'   Resume Game    '
	dc.l	rtss2
	String	'  Instant Replay  '
	dc.l	ReplayMode
	String	'  Change Goalie   '
	dc.l	sub_9DE6	;93 SelectGoalieMenu
	String	'    Edit Lines    '
	dc.l	sub_82DA	;93 LineEditor
	String	'    Game Stats    '
	dc.l	sub_FDC5A	;93 GameStatisticsScreen
	String	'   Player Stats   '
	dc.l	sub_945A	;93 PlayerStatsScreen
	String	' Scoring Summary  '
	dc.l	sub_8EB0	;93 ScoringSummaryScreen
	String	' Penalty Summary  '
	dc.l	sub_9142	;93 PenaltySummaryScreen
	String	'   Team Roster    '
	dc.l	sub_89AC	;93 TeamRosterScreen
	String	'   Other Scores   '
	dc.l	sub_80D4	;93 ShowScores
	String	'   Crowd Meter    '
	dc.l	sub_9A2A	;93 CrowdMeterScreen
	String	'   Player Cards   '
	dc.l	sub_FA07E	;94 only
	String	'  Record Holders  '
	dc.l	sub_FBC14	;94 only
	String	'   Period Stats   '
	dc.l	sub_FD90C	;94 only
	String	'x Manual Goalie   '
	dc.l	sub_FE1D8	;94 only
	String	$FF

unk_19A00	;IDA name. 94 only: Intermission menu in Shootout (word_FFC2FA bit 0; penalty94_2)
	String	$FE,5
	String	$FE,4
	String	'  Start Shootout  '
	dc.l	rtss2
	String	'  Shootout SetUp  '
	dc.l	sub_FC620	;94 only
	String	'   Team Roster    '
	dc.l	sub_89AC	;93 TeamRosterScreen
	String	'   Player Cards   '
	dc.l	sub_FA07E	;94 only
	String	'  Record Holders  '
	dc.l	sub_FBC14	;94 only
	String	$FF

StartGameText	;no IDA label (93 name). Intermission menu for gsp 0 (penalty94_2 .sslist)
	String	$FE,5
	String	$FE,4
	String	'    Start Game    '
	dc.l	rtss2
	String	'  Change Goalie   '
	dc.l	sub_9DE6	;93 SelectGoalieMenu
	String	'    Edit Lines    '
	dc.l	sub_82DA	;93 LineEditor
	String	'   Team Roster    '
	dc.l	sub_89AC	;93 TeamRosterScreen
	String	'   Other Scores   '
	dc.l	sub_80D4	;93 ShowScores
	String	'   Player Cards   '
	dc.l	sub_FA07E	;94 only
	String	'  Record Holders  '
	dc.l	sub_FBC14	;94 only
	String	$FF

StartGameTextPO	;no IDA label (93 name). Intermission menu for gsp 0 in the playoffs (penalty94_2 .sslist)
	String	$FE,5
	String	$FE,4
	String	'    Start Game    '
	dc.l	rtss2
	String	'  Change Goalie   '
	dc.l	sub_9DE6	;93 SelectGoalieMenu
	String	'    Edit Lines    '
	dc.l	sub_82DA	;93 LineEditor
	String	'   Team Roster    '
	dc.l	sub_89AC	;93 TeamRosterScreen
	String	'  Playoff Stats   '
	dc.l	sub_9428	;93 DisplayTeamStats
	String	'   Other Scores   '
	dc.l	sub_80D4	;93 ShowScores
	String	'   Player Cards   '
	dc.l	sub_FA07E	;94 only
	String	'  Record Holders  '
	dc.l	sub_FBC14	;94 only
	String	$FF

IntermissionText	;no IDA label (93 name). Intermission menu for gsp 1-3 (penalty94_2 .sslist)
	String	$FE,5
	String	$FE,4
	String	'   Resume Game    '
	dc.l	rtss2
	String	'    Game Stats    '
	dc.l	sub_FDC5A	;93 GameStatisticsScreen
	String	'   Player Stats   '
	dc.l	sub_945A	;93 PlayerStatsScreen
	String	' Scoring Summary  '
	dc.l	sub_8EB0	;93 ScoringSummaryScreen
	String	' Penalty Summary  '
	dc.l	sub_9142	;93 PenaltySummaryScreen
	String	'   Team Roster    '
	dc.l	sub_89AC	;93 TeamRosterScreen
	String	'   Other Scores   '
	dc.l	sub_80D4	;93 ShowScores
	String	'   Crowd Meter    '
	dc.l	sub_9A2A	;93 CrowdMeterScreen
	String	'  Change Goalie   '
	dc.l	sub_9DE6	;93 SelectGoalieMenu
	String	'    Edit Lines    '
	dc.l	sub_82DA	;93 LineEditor
	String	'   Player Cards   '
	dc.l	sub_FA07E	;94 only
	String	'  Record Holders  '
	dc.l	sub_FBC14	;94 only
	String	'   Period Stats   '
	dc.l	sub_FD90C	;94 only
	String	'x Manual Goalie   '
	dc.l	sub_FE1D8	;94 only
	String	$FF

ExitGameText	;no IDA label (93 name). Intermission menu for gsp 4 (penalty94_2 .sslist)
	String	$FE,5
	String	$FE,4
	String	'    Exit Game     '
	dc.l	rtss2
	String	'    Game Stats    '
	dc.l	sub_FDC5A	;93 GameStatisticsScreen
	String	'   Player Stats   '
	dc.l	sub_945A	;93 PlayerStatsScreen
	String	' Scoring Summary  '
	dc.l	sub_8EB0	;93 ScoringSummaryScreen
	String	' Penalty Summary  '
	dc.l	sub_9142	;93 PenaltySummaryScreen
	String	'   Team Roster    '
	dc.l	sub_89AC	;93 TeamRosterScreen
	String	'   Other Scores   '
	dc.l	sub_80D4	;93 ShowScores
	String	'   Crowd Meter    '
	dc.l	sub_9A2A	;93 CrowdMeterScreen
	String	'   Player Cards   '
	dc.l	sub_FA07E	;94 only
	String	'  Record Holders  '
	dc.l	sub_FBC14	;94 only
	String	'   Period Stats   '
	dc.l	sub_FD90C	;94 only
	String	$FF

ExitGameTextPO	;no IDA label (93 name). Intermission menu for gsp 4 in the playoffs (penalty94_2 .sslist)
	String	$FE,5
	String	$FE,4
	String	'    Exit Game     '
	dc.l	rtss2
	String	'    Game Stats    '
	dc.l	sub_FDC5A	;93 GameStatisticsScreen
	String	'   Player Stats   '
	dc.l	sub_945A	;93 PlayerStatsScreen
	String	' Scoring Summary  '
	dc.l	sub_8EB0	;93 ScoringSummaryScreen
	String	' Penalty Summary  '
	dc.l	sub_9142	;93 PenaltySummaryScreen
	String	'   Team Roster    '
	dc.l	sub_89AC	;93 TeamRosterScreen
	String	'   Other Scores   '
	dc.l	sub_80D4	;93 ShowScores
	String	'   Crowd Meter    '
	dc.l	sub_9A2A	;93 CrowdMeterScreen
	String	'   Player Cards   '
	dc.l	sub_FA07E	;94 only
	String	'  Record Holders  '
	dc.l	sub_FBC14	;94 only
	String	'   Period Stats   '
	dc.l	sub_FD90C	;94 only
	String	$FF

AttributeScreenText	;IDA: unk_19F88 (93 name). Line editor exit menu (the line editor at $882E)
	String	$FE,6,$F9,1
	String	$FE,4,$F9,1
	String	'       Exit       '
	dc.l	rtss2
	String	'Set Original lines'
	dc.l	InitTeamSructure+$10	;the line copy loop of InitTeamSructure (hockey94_06), as 93
	String	'  Save Team Line  '
	dc.l	sub_8928	;93 EncodePlayerAttributes
	String	'  Load Team Line  '
	dc.l	sub_88C8	;93 DecodePlayerAttributes
	String	$FF

ExitAttribText	;IDA: unk_19FF8 (93 name). Line editor exit menu without Load Team Line ($8844)
	String	$FE,6,$F9,1
	String	$FE,4,$F9,1
	String	'       Exit       '
	dc.l	rtss2
	String	'Set Original lines'
	dc.l	InitTeamSructure+$10	;the line copy loop of InitTeamSructure (hockey94_06), as 93
	String	'  Save Team Line  '
	dc.l	sub_8928	;93 EncodePlayerAttributes
	String	$FF

