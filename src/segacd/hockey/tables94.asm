;	HOCKEY.BIN $265CC-$2789F (runtime $415CC-$4289F): tables94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	tables94 after the crowd frame table (src/segacd/crowdtable.asm): asstab, penalties, the
;	playoff tree and the menu lists, the cartridge tables with disc addresses.

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

PlayerCards	equ	$25E56
RecordHoldersScreen	equ	$270E0
ShootoutShooters	equ	$27BD0
PeriodStatsScreen	equ	$2950E
StatsReport	equ	$29A2E
ManualGoalieMenu	equ	$2A092
ShowScores	equ	$2C660
LineEditor	equ	$2C932
DecodeTeamLines	equ	$2CFDE
EncodeTeamLines	equ	$2D046
TeamRosterScreen	equ	$2D0D4
ScoringSummaryScreen	equ	$2D6D6
PenaltySummaryScreen	equ	$2DA4C
PlayoffStatsScreen	equ	$2DE18
PlayerStatsScreen	equ	$2DE50
CrowdMeterScreen	equ	$2E556
TimeoutMenu	equ	$2EB2A
Pausemode_go	equ	$2EBAE
ReplayMode	equ	$2EE04
rtss2	equ	$3C000
CopyTeamLines	equ	$3F208

	org	$415CC

;CD: no cartridge twin
	dc.w	$0003,$C000
	dc.w	$0003,$1FF2
	dc.w	$0003,$20E6
	dc.w	$0003,$22B2
	dc.w	$0003,$23D2
	dc.w	$0003,$2576
	dc.w	$0003,$2636
	dc.w	$0003,$1F2A
	dc.w	$0003,$1ECC
	dc.w	$0003,$1B28
	dc.w	$0003,$1D0A
	dc.w	$0003,$19AC
	dc.w	$0003,$1BA0
	dc.w	$0003,$1CE2
	dc.w	$0003,$2926
	dc.w	$0003,$323C
	dc.w	$0003,$3446
	dc.w	$0003,$3E06
	dc.w	$0003,$443C
	dc.w	$0003,$4330
	dc.w	$0003,$1EAE
	dc.w	$0003,$1EB0
	dc.w	$0003,$1DFE
	dc.w	$0003,$1E16
	dc.w	$0003,$5AD4
	dc.w	$0003,$5F12
	dc.w	$0003,$5ECE
	dc.w	$0003,$4CC6
	dc.w	$0003,$522A
	dc.w	$0003,$27BE
	dc.w	$0003,$4472
	dc.w	$0003,$47BA
	dc.w	$0003,$1D9E
	dc.w	$0003,$3418
	dc.w	$0003,$3DDC
	dc.w	$0002,$2926

Penaltylist							;Penalty number = word offset into this table. Entries $2E-$3C are the
									;penalty shot additions (the penalty shot
									;versions of 7 penalties, minutes byte $FF, and a second Face Off). Used
									;by AddPenalty, SetPA2, PenaltyShotBox, ...
	dc.w	$0000
PenEOP	equ	(*-Penaltylist)			;2 period over
	dc.w	PenDataEOP-Penaltylist
PenEOG	equ	(*-Penaltylist)			;4 game over
	dc.w	PenDataEOG-Penaltylist
PenOOP	equ	(*-Penaltylist)			;6
	dc.w	PenDataGhold-Penaltylist
PenGhold	equ	(*-Penaltylist)		;8
	dc.w	PenDataGhold-Penaltylist
PenWhistle	equ	(*-Penaltylist)		;$A whistle
	dc.w	PenDatawhistle-Penaltylist
PenIcing	equ	(*-Penaltylist)		;$C icing
	dc.w	PenDataice-Penaltylist
PenGoal	equ	(*-Penaltylist)			;$E goal
	dc.w	PenDataGoal-Penaltylist
PenOffsides	equ	(*-Penaltylist)		;$10 offsides
	dc.w	PenDataoffsides-Penaltylist
PenRoughing2	equ	(*-Penaltylist)	;$12 roughing, slow down time $A
	dc.w	PenDatarough2-Penaltylist
PenNoText	equ	(*-Penaltylist)		;$14 no text
	dc.w	PenDataNoText-Penaltylist
PenCharging	equ	(*-Penaltylist)		;$16
	dc.w	PenDatacharge-Penaltylist
PenSlashing	equ	(*-Penaltylist)		;$18
	dc.w	PenDataslash-Penaltylist
PenRoughing	equ	(*-Penaltylist)		;$1A
	dc.w	PenDatarough-Penaltylist
PenCrossChk	equ	(*-Penaltylist)		;$1C
	dc.w	PenDatacross-Penaltylist
PenHooking	equ	(*-Penaltylist)		;$1E
	dc.w	PenDatahook-Penaltylist
PenTripping	equ	(*-Penaltylist)		;$20
	dc.w	PenDatatrip-Penaltylist
PenInterference	equ	(*-Penaltylist)	;$22
	dc.w	PenDataint-Penaltylist
PenHolding	equ	(*-Penaltylist)		;$24
	dc.w	PenDataHold-Penaltylist
PenFighting	equ	(*-Penaltylist)		;$26
	dc.w	PenDatafight-Penaltylist
PenFighting2	equ	(*-Penaltylist)	;$28
	dc.w	PenDatafight2-Penaltylist
PenInst	equ	(*-Penaltylist)			;$2A
	dc.w	PenDataInst-Penaltylist
PenDelay	equ	(*-Penaltylist)		;$2C delay
	dc.w	PenDatadelay-Penaltylist
PenHookingPS	equ	(*-Penaltylist)	;$2E penalty shot
	dc.w	PenDatahookps-Penaltylist
PenTrippingPS	equ	(*-Penaltylist)	;$30 penalty shot
	dc.w	PenDatatripps-Penaltylist
PenGhold2	equ	(*-Penaltylist)		;$32 face off, no slow down
	dc.w	PenDataGhold2-Penaltylist
PenInterferencePS	equ	(*-Penaltylist)	;$34 penalty shot
	dc.w	PenDataintps-Penaltylist
PenRoughingPS	equ	(*-Penaltylist)	;$36 penalty shot
	dc.w	PenDataroughps-Penaltylist
PenChargingPS	equ	(*-Penaltylist)	;$38 penalty shot
	dc.w	PenDatachargeps-Penaltylist
PenCrossChkPS	equ	(*-Penaltylist)	;$3A penalty shot
	dc.w	PenDatacrossps-Penaltylist
PenSlashingPS	equ	(*-Penaltylist)	;$3C penalty shot
	dc.w	PenDataslashps-Penaltylist

;format
;	dc.w	$ttmm	;tt=slow dnw time in half secs,mm=penalty min.
;	String  'penalty text' dc.w     $ffdd,$ffdd,$ffdd,... ;ff =
;	frame,dd=delay (neg for end)

PenDataEOP	dc.w	$0100			;ttmm: slow down 1 half sec, 0 minutes; then the text and frame/delay
									;words
	String	'Period Over'
	dc.w	-$0510
PenDataEOG	dc.w	$0100			;ttmm: slow down 1, 0 minutes
	String	'Game Over'
	dc.w	$0510,-$4060
PenDataGoal	dc.w	$0100			;ttmm: slow down 1, 0 minutes; empty text
	dc.w	2						;String with no text
	dc.w	$050a,-$4018
PenDataNoText	dc.w	$0100		;ttmm: slow down 1, 0 minutes; empty text
	dc.w	2						;String with no text
	dc.w	$0510,-$4018
PenDataice	dc.w	$0100			;ttmm: slow down 1, 0 minutes
	String	'Icing'
	dc.w	$0002,$0101,-$0206
PenDataoffsides	dc.w	$0100		;ttmm: slow down 1, 0 minutes
	String	'Off-side'
	dc.w	$0002,$0301,-$040f
PenDataGhold	dc.w	$0100		;ttmm: slow down 1, 0 minutes (also used for out of play / PenOOP)
	String	'Face Off'
	dc.w	-$050a
PenDataGhold2	dc.w	$0000		;face off text with ttmm 0 (no slow down, 0 minutes), Penaltylist entry
									;for a face off
	String	'Face Off'
	dc.w	-$050a
PenDatadelay	dc.w	$0000		;ttmm: no slow down, 0 minutes
	String	'Penalty'
	dc.w	$0003,$0301,-$040f
PenDatawhistle	dc.w	$0000		;ttmm: no slow down, 0 minutes; empty text
	dc.w	2						;String with no text
	dc.w	-$050a
PenDatacharge	dc.w	$0402		;ttmm: slow down 4, 2 minutes
	String	'Charging'
	dc.w	$0004,$0101,$0a01,$0b01,$0a01,$0b01,$0a01,$0b01,$0a01,$0b01,-$0101
PenDatachargeps	dc.w	$04ff		;penalty shot form of PenDatacharge: slow down 4, minutes $FF. Negative
									;minutes are skipped like 0 by AddPenalty and the penalty box code, so no
									;time is served
	String	'Charging'
	dc.w	$0004,$0101,$0a01,$0b01,$0a01,$0b01,$0a01,$0b01,$0a01,$0b01,-$0101
PenDataslash	dc.w	$0402		;ttmm: slow down 4, 2 minutes
	String	'Slashing'
	dc.w	$0004,$0101,$0201,$0301,$0201,$0301,$0201,$0301,$0201,$0301,-$0101
PenDataslashps	dc.w	$04ff		;penalty shot form of PenDataslash: slow down 4, minutes $FF. Negative
									;minutes are skipped like 0 by AddPenalty and the penalty box code, so no
									;time is served
	String	'Slashing'
	dc.w	$0004,$0101,$0201,$0301,$0201,$0301,$0201,$0301,$0201,$0301,-$0101
PenDatatrip	dc.w	$0402			;ttmm: slow down 4, 2 minutes
	String	'Tripping'
	dc.w	$0004,$0401,$0501,$0401,$0501,$0401,$0501,$0401,$0501,-$0101
PenDatatripps	dc.w	$04ff		;penalty shot form of PenDatatrip: slow down 4, minutes $FF. Negative
									;minutes are skipped like 0 by AddPenalty and the penalty box code, so no
									;time is served
	String	'Tripping'
	dc.w	$0004,$0401,$0501,$0401,$0501,$0401,$0501,$0401,$0501,-$0101
PenDatarough2	dc.w	$0a02		;ttmm: slow down $0a, 2 minutes
	String	'Roughing'
	dc.w	$0004,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,-$0101
PenDatarough	dc.w	$0402		;ttmm: slow down 4, 2 minutes
	String	'Roughing'
	dc.w	$0004,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,-$0101
PenDataroughps	dc.w	$04ff		;penalty shot form of PenDatarough: slow down 4, minutes $FF. Negative
									;minutes are skipped like 0 by AddPenalty and the penalty box code, so no
									;time is served
	String	'Roughing'
	dc.w	$0004,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,-$0101
PenDatahook	dc.w	$0402			;ttmm: slow down 4, 2 minutes
	String	'Hooking'
	dc.w	$0004,$0101,$0901,$0801,$0901,$0801,$0901,$0801,$0901,$0801,-$0101
PenDatahookps	dc.w	$04ff		;penalty shot form of PenDatahook: slow down 4, minutes $FF. Negative
									;minutes are skipped like 0 by AddPenalty and the penalty box code, so no
									;time is served
	String	'Hooking'
	dc.w	$0004,$0101,$0901,$0801,$0901,$0801,$0901,$0801,$0901,$0801,-$0101
PenDatacross	dc.w	$0402		;ttmm: slow down 4, 2 minutes
	String	'Cross Check'
	dc.w	$0004,$0601,$0f01,$1001,$0f01,$1001,$0f01,$1001,$0f01,$1001,-$0101
PenDatacrossps	dc.w	$04ff		;penalty shot form of PenDatacross: slow down 4, minutes $FF. Negative
									;minutes are skipped like 0 by AddPenalty and the penalty box code, so no
									;time is served
	String	'Cross Check'
	dc.w	$0004,$0601,$0f01,$1001,$0f01,$1001,$0f01,$1001,$0f01,$1001,-$0101
PenDataint	dc.w	$0402			;ttmm: slow down 4, 2 minutes
	String	'Interference'
	dc.w	$0004,$0101,$0c06,-$0101
PenDataintps	dc.w	$04ff		;penalty shot form of PenDataint: slow down 4, minutes $FF. Negative
									;minutes are skipped like 0 by AddPenalty and the penalty box code, so no
									;time is served
	String	'Interference'
	dc.w	$0004,$0101,$0c06,-$0101
PenDataHold	dc.w	$0402			;ttmm: slow down 4, 2 minutes
	String	'Holding'
	dc.w	$0004,$0101,$0706,-$0101
PenDatafight	dc.w	$2805		;ttmm: slow down $28, 5 minutes
	String	'Fighting'
	dc.w	$0004,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,-$0101
PenDatafight2	dc.w	$2805		;ttmm: slow down $28, 5 minutes
	String	'Fighting *'
	dc.w	$0004,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,-$0101
PenDataInst	dc.w	$2802			;ttmm: slow down $28, 2 minutes
	String	'Fight Instigator'
	dc.w	$0004,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,-$0101

PenShotPenalties					;the penalty shot penalty number for penalty number d0 (word offset), -1
									;none. Used by PenShotChk
	dc.w	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,$38,$3C
	dc.w	$36,$3A,$2E,$30,$34,-1,-1,-1,-1,-1,-1,-1

bfasciicon							;equates to find each char definition for bigfont.map.. Indexed by ascii -
									;$20 in PrintBigChar (called from printbig)
	;    -sp  -!  "  #  $  %  &  -'  (  )  *  +  ,  -  -.  /
	dc.b -76,-73,00,00,00,00,00,-71,00,00,00,00,00,00,-72,00
	;     0  -1  2  3  4  5  6  7  8  9  -:  ;  <  =  >  ?
	dc.b 51,-53,54,56,58,60,62,64,66,68,-71,00,00,00,00,74
	;     @  A  B  C  D  E  F  G  H  -I  J  K  L  M  N  O
	dc.b 74,00,02,04,06,08,10,12,14,-16,17,19,21,23,25,27
	;     P  Q  R  S  T  U  V  W  X  Y  Z
	dc.b 29,31,33,35,37,39,41,43,45,47,49
;CD: no cartridge twin
	dc.b	$00

linelist	String	'Sc1'			;text list for line choices. Used by SetLCmode2 and puckfaceoff2
	String	'Sc2'
	String	'Chk'
	String	'PP1'
	String	'PP2'
	String	'PK1'
	String	'PK2'

PlayerPositionText	String	'LD'	;position names for the line slots. Used by DisplayPlayerList
	String	'RD'
	String	'LW'
	String	'C'
	String	'RW'

PerLabels	String	'1',$12			;text list for periods; ' F' is the final. Used
									;by printscores1, NewTicker3
	String	'2',$13
	String	'3',$14
	String	'OT'
	String	' F'

PerLabels2	String	'1',$12			;the same with a blank last entry. Used by printscores1
	String	'2',$13
	String	'3',$14
	String	'OT'
	String	'  '

sizetab								;sprite size code to tile count. sizetab, used by addframe2
	dc.b	1,2,3,4,2,4,6,8,3,6,9,12,4,8,12,16

sublist								;substitution lists by position (goalie, LD, RD, LW, C, RW, extra
									;attacker), as word offsets from
									;sublist. Used by SetPlList
	dc.w	.defl-sublist			;goalie
	dc.w	.defl-sublist
	dc.w	.defr-sublist
	dc.w	.wingl-sublist
	dc.w	.center-sublist
	dc.w	.wingr-sublist
	dc.w	.center-sublist

.defl	dc.b	0+1,8+1,16+1,24+1,32+1,40+1,48+1	;list of players in there lines/each line = 8 bytes
	dc.b	0+2,8+2,16+2,24+2,32+2,40+2,48+2
.defr	dc.b	0+2,8+2,16+2,24+2,32+2,40+2,48+2	;defensive RD slots first, then LD slots
	dc.b	0+1,8+1,16+1,24+1,32+1,40+1,48+1
.wingl	dc.b	0+3,8+3,16+3,24+3,32+3,40+3,48+3	;left wing slots, then right wing, then center
	dc.b	0+5,8+5,16+5,24+5,32+5,40+5,48+5
	dc.b	0+4,8+4,16+4,24+4,32+4,40+4,48+4
.wingr	dc.b	0+5,8+5,16+5,24+5,32+5,40+5,48+5	;right wing slots, then left wing, then center
	dc.b	0+3,8+3,16+3,24+3,32+3,40+3,48+3
	dc.b	0+4,8+4,16+4,24+4,32+4,40+4,48+4
.center	dc.b	0+4,8+4,16+4,24+4,32+4,40+4,48+4	;center slots, then left wing, then right wing; -1 ends
	dc.b	0+3,8+3,16+3,24+3,32+3,40+3,48+3
	dc.b	0+5,8+5,16+5,24+5,32+5,40+5,48+5
	dc.b	-1

priolist	dc.b	0,1,2,4,3,5,6	;positions in order of importance. Used by
;CD: no cartridge twin
	dc.b	$00

PlayoffScreen_setup					;Playoff tree layout by gamelevel, one column per round. Used by
									;PlayoffScreen
	dc.w	.l0-PlayoffScreen_setup
	dc.w	.l1-PlayoffScreen_setup
	dc.w	.l2-PlayoffScreen_setup
	dc.w	.l3-PlayoffScreen_setup
	dc.w	.l4-PlayoffScreen_setup

	;tree graphics for level 0: teams-1 then x,y per team (PlayoffScreen_doteam), arrows-1 then x,d0 per arrow
	;(PlayoffScreen_doarrow), scores-1 then x,y per score (PlayoffScreen_doscores, negative: none)
.l0	dc.b	16-1					;level 0: 16 team blocks, then arrows and series scores
	dc.b	46,2,46,5,46,8,46,11,46,14,46,17,46,20,46,23
	dc.b	71,2,71,5,71,8,71,11,71,14,71,17,71,20,71,23
	dc.b	1,57,0,69,10
	dc.b	7,50,4,50,10,50,16,50,22,75,4,75,10,75,16,75,22

	;tree graphics for level 1
.l1	dc.b	16+8-1					;level 1: 16+8 team blocks
	dc.b	32,2,32,5,32,8,32,11,32,14,32,17,32,20,32,23
	dc.b	85,2,85,5,85,8,85,11,85,14,85,17,85,20,85,23
	dc.b	46,4,46,10,46,15,46,21
	dc.b	71,4,71,10,71,15,71,21
	dc.b	3,43,0,57,2,69,8,83,10
	dc.b	3,50,8,50,18,75,8,75,18

	;tree graphics for level 2
.l2	dc.b	16+8+4-1				;level 2: 16+8+4 team blocks
	dc.b	18,2,18,5,18,8,18,11,18,14,18,17,18,20,18,23
	dc.b	99,2,99,5,99,8,99,11,99,14,99,17,99,20,99,23
	dc.b	32,4,32,10,32,15,32,21
	dc.b	85,4,85,10,85,15,85,21
	dc.b	46,7,46,18
	dc.b	71,7,71,18
	dc.b	5,29,0,43,2,57,4,69,6,83,8,97,10
	dc.b	1,50,13,75,13

	;tree graphics for level 3
.l3	dc.b	16+8+4+2-1				;level 3: 16+8+4+2 team blocks
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
.l4	dc.b	16+8+4+2+1-1			;level 4: 16+8+4+2+1 team blocks
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
	dc.b	-1						;no scores
;CD: no cartridge twin
	dc.b	$00

PAttribColumns						;Skater attribute columns for PrintAttribHeader / the player list.
									;String header then a long for getNameandAttrib: high word = mask of
									;rating nibbles to average, low word = attribjmp offset (0 status, 2
									;energy, 4 handed, 6 weight, 8 fighting, $A rating). A negative word ends
									;the list.
									;There is no Fighting column. PAttribOverall / PAttribOverallMask (the
									;Overall entry) are read by PrintShooterList, PrintOverallRating
	String	'     Status    ]'
	dc.w	$0000,$0				;status
PAttribOverall	String	'[   Overall    ]'	;skater Overall column title (the rating is computed from the mask
									;below)
PAttribOverallMask	dc.w	$1fba,$a	;skater Overall: attribute weight bits and column value, read as one
									;long by CalcAttrib callers
	String	'[   Energy     ]'
	dc.w	$0000,$2				;energy
	String	'[   Agility    ]'
	dc.w	$1000,$a
	String	'[    Speed     ]'
	dc.w	$0800,$a
	String	'[   Handed     ]'
	dc.w	$0040,$4				;handed
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
	dc.w	$2000,$6				;weight
	String	'[  Endurance   ]'
	dc.w	$0008,$a
	String	'[Aggressiveness]'
	dc.w	$0001,$a
	String	'[   Checking    '
	dc.w	$0080,$a
	dc.w	-1

GAttribColumns						;Goalie attribute columns, same format as PAttribColumns. GAttribOverall /
									;GAttribOverallMask (the Overall entry) are read by PrintShooterList,
									;PrintOverallRating
	String	'     Status    ]'
	dc.w	$0000,$0				;status
GAttribOverall	String	'[   Overall    ]'	;goalie Overall column title (the rating is computed from the mask
									;below)
GAttribOverallMask	dc.w	$130f,$a	;goalie Overall: attribute weight bits and column value, read as one
									;long by CalcAttrib callers
	String	'[   Agility    ]'
	dc.w	$1000,$a
	String	'[    Speed     ]'
	dc.w	$0800,$a
	String	'[  Glove Hand  ]'
	dc.w	$0040,$4				;handed
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
	dc.w	$2000,$6				;weight
	dc.w	-1

PauseMenuItems						;pause menu item list (PauseMode)
	String	CC_SetAttribute,5
	String	CC_SetAttribute,4
	String	'   Resume Game    '
	dc.l	rtss2
	String	'  Instant Replay  '
	dc.l	ReplayMode
	String	'   Team Roster    '
	dc.l	TeamRosterScreen
	String	'   Player Cards   '
	dc.l	PlayerCards
	String	'  Record Holders  '
	dc.l	RecordHoldersScreen
	String	'x Manual Goalie   '
	dc.l	ManualGoalieMenu
	String	CC_ListEnd

Pausemode_mlist						;Pause menu item list (PauseMode)
	String	CC_SetAttribute,5
	String	CC_SetAttribute,4
	String	'   Resume Game    '
	dc.l	rtss2
	String	'  Instant Replay  '
	dc.l	ReplayMode
	String	'  Change Goalie   '
	dc.l	Pausemode_go
	String	'    Edit Lines    '
	dc.l	LineEditor
	String	'    Game Stats    '
	dc.l	StatsReport
	String	'   Player Stats   '
	dc.l	PlayerStatsScreen
	String	' Scoring Summary  '
	dc.l	ScoringSummaryScreen
	String	' Penalty Summary  '
	dc.l	PenaltySummaryScreen
	String	'   Team Roster    '
	dc.l	TeamRosterScreen
	String	'   Other Scores   '
	dc.l	ShowScores
	String	'   Crowd Meter    '
	dc.l	CrowdMeterScreen
	String	'     Timeout      '
	dc.l	TimeoutMenu
	String	'   Player Cards   '
	dc.l	PlayerCards
	String	'  Record Holders  '
	dc.l	RecordHoldersScreen
	String	'   Period Stats   '
	dc.l	PeriodStatsScreen
	String	'x Manual Goalie   '
	dc.l	ManualGoalieMenu
	String	CC_ListEnd

PauseText2							;Pause menu item list without Timeout (PauseMode)
	String	CC_SetAttribute,5
	String	CC_SetAttribute,4
	String	'   Resume Game    '
	dc.l	rtss2
	String	'  Instant Replay  '
	dc.l	ReplayMode
	String	'  Change Goalie   '
	dc.l	Pausemode_go
	String	'    Edit Lines    '
	dc.l	LineEditor
	String	'    Game Stats    '
	dc.l	StatsReport
	String	'   Player Stats   '
	dc.l	PlayerStatsScreen
	String	' Scoring Summary  '
	dc.l	ScoringSummaryScreen
	String	' Penalty Summary  '
	dc.l	PenaltySummaryScreen
	String	'   Team Roster    '
	dc.l	TeamRosterScreen
	String	'   Other Scores   '
	dc.l	ShowScores
	String	'   Crowd Meter    '
	dc.l	CrowdMeterScreen
	String	'   Player Cards   '
	dc.l	PlayerCards
	String	'  Record Holders  '
	dc.l	RecordHoldersScreen
	String	'   Period Stats   '
	dc.l	PeriodStatsScreen
	String	'x Manual Goalie   '
	dc.l	ManualGoalieMenu
	String	CC_ListEnd

ShootoutIntermissionMenu			;Intermission menu in Shootout (gmode2 bit 0)
	String	CC_SetAttribute,5
	String	CC_SetAttribute,4
	String	'  Start Shootout  '
	dc.l	rtss2
	String	'  Shootout SetUp  '
	dc.l	ShootoutShooters
	String	'   Team Roster    '
	dc.l	TeamRosterScreen
	String	'   Player Cards   '
	dc.l	PlayerCards
	String	'  Record Holders  '
	dc.l	RecordHoldersScreen
	String	CC_ListEnd

StartGameText						;Intermission menu for gsp 0
	String	CC_SetAttribute,5
	String	CC_SetAttribute,4
	String	'    Start Game    '
	dc.l	rtss2
	String	'  Change Goalie   '
	dc.l	Pausemode_go
	String	'    Edit Lines    '
	dc.l	LineEditor
	String	'   Team Roster    '
	dc.l	TeamRosterScreen
	String	'   Other Scores   '
	dc.l	ShowScores
	String	'   Player Cards   '
	dc.l	PlayerCards
	String	'  Record Holders  '
	dc.l	RecordHoldersScreen
	String	CC_ListEnd

StartGameTextPO						;Intermission menu for gsp 0 in the playoffs
	String	CC_SetAttribute,5
	String	CC_SetAttribute,4
	String	'    Start Game    '
	dc.l	rtss2
	String	'  Change Goalie   '
	dc.l	Pausemode_go
	String	'    Edit Lines    '
	dc.l	LineEditor
	String	'   Team Roster    '
	dc.l	TeamRosterScreen
	String	'  Playoff Stats   '
	dc.l	PlayoffStatsScreen
	String	'   Other Scores   '
	dc.l	ShowScores
	String	'   Player Cards   '
	dc.l	PlayerCards
	String	'  Record Holders  '
	dc.l	RecordHoldersScreen
	String	CC_ListEnd

IntermissionText					;Intermission menu for gsp 1-3
	String	CC_SetAttribute,5
	String	CC_SetAttribute,4
	String	'   Resume Game    '
	dc.l	rtss2
	String	'    Game Stats    '
	dc.l	StatsReport
	String	'   Player Stats   '
	dc.l	PlayerStatsScreen
	String	' Scoring Summary  '
	dc.l	ScoringSummaryScreen
	String	' Penalty Summary  '
	dc.l	PenaltySummaryScreen
	String	'   Team Roster    '
	dc.l	TeamRosterScreen
	String	'   Other Scores   '
	dc.l	ShowScores
	String	'   Crowd Meter    '
	dc.l	CrowdMeterScreen
	String	'  Change Goalie   '
	dc.l	Pausemode_go
	String	'    Edit Lines    '
	dc.l	LineEditor
	String	'   Player Cards   '
	dc.l	PlayerCards
	String	'  Record Holders  '
	dc.l	RecordHoldersScreen
	String	'   Period Stats   '
	dc.l	PeriodStatsScreen
	String	'x Manual Goalie   '
	dc.l	ManualGoalieMenu
	String	CC_ListEnd

ExitGameText						;Intermission menu for gsp 4
	String	CC_SetAttribute,5
	String	CC_SetAttribute,4
	String	'    Exit Game     '
	dc.l	rtss2
	String	'    Game Stats    '
	dc.l	StatsReport
	String	'   Player Stats   '
	dc.l	PlayerStatsScreen
	String	' Scoring Summary  '
	dc.l	ScoringSummaryScreen
	String	' Penalty Summary  '
	dc.l	PenaltySummaryScreen
	String	'   Team Roster    '
	dc.l	TeamRosterScreen
	String	'   Other Scores   '
	dc.l	ShowScores
	String	'   Crowd Meter    '
	dc.l	CrowdMeterScreen
	String	'   Player Cards   '
	dc.l	PlayerCards
	String	'  Record Holders  '
	dc.l	RecordHoldersScreen
	String	'   Period Stats   '
	dc.l	PeriodStatsScreen
	String	CC_ListEnd

ExitGameTextPO						;Intermission menu for gsp 4 in the playoffs
	String	CC_SetAttribute,5
	String	CC_SetAttribute,4
	String	'    Exit Game     '
	dc.l	rtss2
	String	'    Game Stats    '
	dc.l	StatsReport
	String	'   Player Stats   '
	dc.l	PlayerStatsScreen
	String	' Scoring Summary  '
	dc.l	ScoringSummaryScreen
	String	' Penalty Summary  '
	dc.l	PenaltySummaryScreen
	String	'   Team Roster    '
	dc.l	TeamRosterScreen
	String	'   Other Scores   '
	dc.l	ShowScores
	String	'   Crowd Meter    '
	dc.l	CrowdMeterScreen
	String	'   Player Cards   '
	dc.l	PlayerCards
	String	'  Record Holders  '
	dc.l	RecordHoldersScreen
	String	'   Period Stats   '
	dc.l	PeriodStatsScreen
	String	CC_ListEnd

LineEditorMenuText					;Line editor exit menu
	String	CC_SetAttribute,6,CC_SetFont,1
	String	CC_SetAttribute,4,CC_SetFont,1
	String	'       Exit       '
	dc.l	rtss2
	String	'Set Original lines'
	dc.l	CopyTeamLines
	String	'  Save Team Line  '
	dc.l	EncodeTeamLines
	String	'  Load Team Line  '
	dc.l	DecodeTeamLines
	String	CC_ListEnd

LineEditorMenuNoLoad				;Line editor exit menu without Load Team Line
	String	CC_SetAttribute,6,CC_SetFont,1
	String	CC_SetAttribute,4,CC_SetFont,1
	String	'       Exit       '
	dc.l	rtss2
	String	'Set Original lines'
	dc.l	CopyTeamLines
	String	'  Save Team Line  '
	dc.l	EncodeTeamLines
	String	CC_ListEnd
