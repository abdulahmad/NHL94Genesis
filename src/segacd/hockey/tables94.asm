updatecrowdf_cd0						;$fftt = frame/time for various levels of crowd
									;excitement. Used by updatecrowdf.
									;Used by updatecrowdf, indexed by crowd level and Crowdstep
	movep.w	$20C(a4),d0
	movep.w	$40C(a4),d1
	movep.w	$A0C(a4),d2
	movep.w	$80C(a4),d4
	dc.w	$060c,$070c,$080c,$090c,$0a0c,$050c,$040c,$030c

	dc.w	$0107,$0207,$0307,$0407,$0507,$0b07,$0c07,$0d07
	dc.w	$0607,$0707,$0807,$0907,$0a07,$0b07,$0c07,$0d07

	dc.w	$0e07,$0f07,$1007,$1107,$1207,$0b07,$0c07,$0d07
	dc.w	$1207,$1107,$1007,$0f07,$0e07,$0d07,$0c07,$0b07

	dc.w	$0e03,$0f03,$1003,$1103,$1203,$0b03,$0c03,$0d03
	dc.w	$1203,$1103,$1003,$0f03,$0e03,$0d03,$0c03,$0b03
	dc.b	$00,$03,$C0,$00,$00,$03,$1F,$F2,$00,$03,$20,$E6,$00,$03,$22,$B2
	dc.b	$00,$03,$23,$D2,$00,$03,$25,$76,$00,$03,$26,$36,$00,$03,$1F,$2A
	dc.b	$00,$03,$1E,$CC,$00,$03,$1B,$28,$00,$03,$1D,$0A,$00,$03,$19,$AC
	dc.b	$00,$03,$1B,$A0,$00,$03,$1C,$E2,$00,$03,$29,$26,$00,$03,$32,$3C
	dc.b	$00,$03,$34,$46,$00,$03,$3E,$06,$00,$03,$44,$3C,$00,$03,$43,$30
	dc.b	$00,$03,$1E,$AE,$00,$03,$1E,$B0,$00,$03,$1D,$FE,$00,$03,$1E,$16
	dc.b	$00,$03,$5A,$D4,$00,$03,$5F,$12,$00,$03,$5E,$CE,$00,$03,$4C,$C6
	dc.b	$00,$03,$52,$2A,$00,$03,$27,$BE,$00,$03,$44,$72,$00,$03,$47,$BA
	dc.b	$00,$03,$1D,$9E,$00,$03,$34,$18,$00,$03,$3D,$DC,$00,$02,$29,$26


Penaltylist							;Penalty number = word offset into this table. Entries $2E-$3C are the
									;penalty shot additions (the penalty shot
									;versions of 7 penalties, minutes byte $FF, and a second Face Off). Used
									;by AddPenalty, SetPA2, PenaltyShotBox, ...
	dc.w	$0000
	dc.w	PenDataEOP-Penaltylist
	dc.w	PenDataEOG-Penaltylist
	dc.w	PenDataGhold-Penaltylist
	dc.w	PenDataGhold-Penaltylist
	dc.w	PenDatawhistle-Penaltylist
	dc.w	PenDataice-Penaltylist
	dc.w	PenDataGoal-Penaltylist
	dc.w	PenDataoffsides-Penaltylist
	dc.w	PenDatarough2-Penaltylist
	dc.w	PenDataNoText-Penaltylist
	dc.w	PenDatacharge-Penaltylist
	dc.w	PenDataslash-Penaltylist
	dc.w	PenDatarough-Penaltylist
	dc.w	PenDatacross-Penaltylist
	dc.w	PenDatahook-Penaltylist
	dc.w	PenDatatrip-Penaltylist
	dc.w	PenDataint-Penaltylist
	dc.w	PenDataHold-Penaltylist
	dc.w	PenDatafight-Penaltylist
	dc.w	PenDatafight2-Penaltylist
	dc.w	PenDataInst-Penaltylist
	dc.w	PenDatadelay-Penaltylist
	dc.w	PenDatahookps-Penaltylist
	dc.w	PenDatatripps-Penaltylist
	dc.w	PenDataGhold2-Penaltylist
	dc.w	PenDataintps-Penaltylist
	dc.w	PenDataroughps-Penaltylist
	dc.w	PenDatachargeps-Penaltylist
	dc.w	PenDatacrossps-Penaltylist
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
	dc.b	$00

PlayoffScreen_setup					;Playoff tree layout by gamelevel, one column per round. Used by
									;PlayoffScreen
	dc.w	.next-PlayoffScreen_setup
	dc.w	.next2-PlayoffScreen_setup
	dc.w	.next3-PlayoffScreen_setup
	dc.w	.next4-PlayoffScreen_setup
	dc.w	.next5-PlayoffScreen_setup

	;tree graphics for level 0: teams-1 then x,y per team (PlayoffScreen_doteam), arrows-1 then x,d0 per arrow
	;(PlayoffScreen_doarrow), scores-1 then x,y per score (PlayoffScreen_doscores, negative: none)
.next	dc.b	16-1					;level 0: 16 team blocks, then arrows and series scores
	dc.b	46,2,46,5,46,8,46,11,46,14,46,17,46,20,46,23
	dc.b	71,2,71,5,71,8,71,11,71,14,71,17,71,20,71,23
	dc.b	1,57,0,69,10
	dc.b	7,50,4,50,10,50,16,50,22,75,4,75,10,75,16,75,22

	;tree graphics for level 1
.next2	dc.b	16+8-1					;level 1: 16+8 team blocks
	dc.b	32,2,32,5,32,8,32,11,32,14,32,17,32,20,32,23
	dc.b	85,2,85,5,85,8,85,11,85,14,85,17,85,20,85,23
	dc.b	46,4,46,10,46,15,46,21
	dc.b	71,4,71,10,71,15,71,21
	dc.b	3,43,0,57,2,69,8,83,10
	dc.b	3,50,8,50,18,75,8,75,18

	;tree graphics for level 2
.next3	dc.b	16+8+4-1				;level 2: 16+8+4 team blocks
	dc.b	18,2,18,5,18,8,18,11,18,14,18,17,18,20,18,23
	dc.b	99,2,99,5,99,8,99,11,99,14,99,17,99,20,99,23
	dc.b	32,4,32,10,32,15,32,21
	dc.b	85,4,85,10,85,15,85,21
	dc.b	46,7,46,18
	dc.b	71,7,71,18
	dc.b	5,29,0,43,2,57,4,69,6,83,8,97,10
	dc.b	1,50,13,75,13

	;tree graphics for level 3
.next4	dc.b	16+8+4+2-1				;level 3: 16+8+4+2 team blocks
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
.next5	dc.b	16+8+4+2+1-1			;level 4: 16+8+4+2+1 team blocks
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
	dc.b	$00,$04,$FE,$05,$00,$04,$FE,$04
	String	'   Resume Game    '
	dc.b	$00,$03,$C0,$00
	String	'  Instant Replay  '
	dc.b	$00,$02,$EE,$04
	String	'   Team Roster    '
	dc.b	$00,$02,$D0,$D4
	String	'   Player Cards   '
	dc.b	$00,$02,$5E,$56
	String	'  Record Holders  '
	dc.b	$00,$02,$70,$E0
	String	'x Manual Goalie   '
	dc.b	$00,$02,$A0,$92,$00,$04,$FF,$00,$00,$04,$FE,$05,$00,$04,$FE,$04
	String	'   Resume Game    '
	dc.b	$00,$03,$C0,$00
	String	'  Instant Replay  '
	dc.b	$00,$02,$EE,$04
	String	'  Change Goalie   '
	dc.b	$00,$02,$EB,$AE
	String	'    Edit Lines    '
	dc.b	$00,$02,$C9,$32
	String	'    Game Stats    '
	dc.b	$00,$02,$9A,$2E
	String	'   Player Stats   '
	dc.b	$00,$02,$DE,$50
	String	' Scoring Summary  '
	dc.b	$00,$02,$D6,$D6
	String	' Penalty Summary  '
	dc.b	$00,$02,$DA,$4C
	String	'   Team Roster    '
	dc.b	$00,$02,$D0,$D4
	String	'   Other Scores   '
	dc.b	$00,$02,$C6,$60
	String	'   Crowd Meter    '
	dc.b	$00,$02,$E5,$56
	String	'     Timeout      '
	dc.b	$00,$02,$EB,$2A
	String	'   Player Cards   '
	dc.b	$00,$02,$5E,$56
	String	'  Record Holders  '
	dc.b	$00,$02,$70,$E0
	String	'   Period Stats   '
	dc.b	$00,$02,$95,$0E
	String	'x Manual Goalie   '
	dc.b	$00,$02,$A0,$92,$00,$04,$FF,$00,$00,$04,$FE,$05,$00,$04,$FE,$04
	String	'   Resume Game    '
	dc.b	$00,$03,$C0,$00
	String	'  Instant Replay  '
	dc.b	$00,$02,$EE,$04
	String	'  Change Goalie   '
	dc.b	$00,$02,$EB,$AE
	String	'    Edit Lines    '
	dc.b	$00,$02,$C9,$32
	String	'    Game Stats    '
	dc.b	$00,$02,$9A,$2E
	String	'   Player Stats   '
	dc.b	$00,$02,$DE,$50
	String	' Scoring Summary  '
	dc.b	$00,$02,$D6,$D6
	String	' Penalty Summary  '
	dc.b	$00,$02,$DA,$4C
	String	'   Team Roster    '
	dc.b	$00,$02,$D0,$D4
	String	'   Other Scores   '
	dc.b	$00,$02,$C6,$60
	String	'   Crowd Meter    '
	dc.b	$00,$02,$E5,$56
	String	'   Player Cards   '
	dc.b	$00,$02,$5E,$56
	String	'  Record Holders  '
	dc.b	$00,$02,$70,$E0
	String	'   Period Stats   '
	dc.b	$00,$02,$95,$0E
	String	'x Manual Goalie   '
	dc.b	$00,$02,$A0,$92,$00,$04,$FF,$00,$00,$04,$FE,$05,$00,$04,$FE,$04
	String	'  Start Shootout  '
	dc.b	$00,$03,$C0,$00
	String	'  Shootout SetUp  '
	dc.b	$00,$02,$7B,$D0
	String	'   Team Roster    '
	dc.b	$00,$02,$D0,$D4
	String	'   Player Cards   '
	dc.b	$00,$02,$5E,$56
	String	'  Record Holders  '
	dc.b	$00,$02,$70,$E0,$00,$04,$FF,$00,$00,$04,$FE,$05,$00,$04,$FE,$04
	String	'    Start Game    '
	dc.b	$00,$03,$C0,$00
	String	'  Change Goalie   '
	dc.b	$00,$02,$EB,$AE
	String	'    Edit Lines    '
	dc.b	$00,$02,$C9,$32
	String	'   Team Roster    '
	dc.b	$00,$02,$D0,$D4
	String	'   Other Scores   '
	dc.b	$00,$02,$C6,$60
	String	'   Player Cards   '
	dc.b	$00,$02,$5E,$56
	String	'  Record Holders  '
	dc.b	$00,$02,$70,$E0,$00,$04,$FF,$00,$00,$04,$FE,$05,$00,$04,$FE,$04
	String	'    Start Game    '
	dc.b	$00,$03,$C0,$00
	String	'  Change Goalie   '
	dc.b	$00,$02,$EB,$AE
	String	'    Edit Lines    '
	dc.b	$00,$02,$C9,$32
	String	'   Team Roster    '
	dc.b	$00,$02,$D0,$D4
	String	'  Playoff Stats   '
	dc.b	$00,$02,$DE,$18
	String	'   Other Scores   '
	dc.b	$00,$02,$C6,$60
	String	'   Player Cards   '
	dc.b	$00,$02,$5E,$56
	String	'  Record Holders  '
	dc.b	$00,$02,$70,$E0,$00,$04,$FF,$00,$00,$04,$FE,$05,$00,$04,$FE,$04
	String	'   Resume Game    '
	dc.b	$00,$03,$C0,$00
	String	'    Game Stats    '
	dc.b	$00,$02,$9A,$2E
	String	'   Player Stats   '
	dc.b	$00,$02,$DE,$50
	String	' Scoring Summary  '
	dc.b	$00,$02,$D6,$D6
	String	' Penalty Summary  '
	dc.b	$00,$02,$DA,$4C
	String	'   Team Roster    '
	dc.b	$00,$02,$D0,$D4
	String	'   Other Scores   '
	dc.b	$00,$02,$C6,$60
	String	'   Crowd Meter    '
	dc.b	$00,$02,$E5,$56
	String	'  Change Goalie   '
	dc.b	$00,$02,$EB,$AE
	String	'    Edit Lines    '
	dc.b	$00,$02,$C9,$32
	String	'   Player Cards   '
	dc.b	$00,$02,$5E,$56
	String	'  Record Holders  '
	dc.b	$00,$02,$70,$E0
	String	'   Period Stats   '
	dc.b	$00,$02,$95,$0E
	String	'x Manual Goalie   '
	dc.b	$00,$02,$A0,$92,$00,$04,$FF,$00,$00,$04,$FE,$05,$00,$04,$FE,$04
	String	'    Exit Game     '
	dc.b	$00,$03,$C0,$00
	String	'    Game Stats    '
	dc.b	$00,$02,$9A,$2E
	String	'   Player Stats   '
	dc.b	$00,$02,$DE,$50
	String	' Scoring Summary  '
	dc.b	$00,$02,$D6,$D6
	String	' Penalty Summary  '
	dc.b	$00,$02,$DA,$4C
	String	'   Team Roster    '
	dc.b	$00,$02,$D0,$D4
	String	'   Other Scores   '

	dc.b	$00,$02,$C6,$60
	String	'   Crowd Meter    '
	dc.b	$00,$02,$E5,$56
	String	'   Player Cards   '
	dc.b	$00,$02,$5E,$56
	String	'  Record Holders  '
	dc.b	$00,$02,$70,$E0
	String	'   Period Stats   '
	dc.b	$00,$02,$95,$0E,$00,$04,$FF,$00

ExitGameText						;Intermission menu for gsp 4
	dc.b	$00,$04,$FE,$05,$00,$04,$FE,$04
	String	'    Exit Game     '
	dc.b	$00,$03,$C0,$00
	String	'    Game Stats    '
	dc.b	$00,$02,$9A,$2E
	String	'   Player Stats   '
	dc.b	$00,$02,$DE,$50
	String	' Scoring Summary  '
	dc.b	$00,$02,$D6,$D6
	String	' Penalty Summary  '
	dc.b	$00,$02,$DA,$4C
	String	'   Team Roster    '
	dc.b	$00,$02,$D0,$D4
	String	'   Other Scores   '
	dc.b	$00,$02,$C6,$60
	String	'   Crowd Meter    '
	dc.b	$00,$02,$E5,$56
	String	'   Player Cards   '
	dc.b	$00,$02,$5E,$56
	String	'  Record Holders  '
	dc.b	$00,$02,$70,$E0
	String	'   Period Stats   '
	dc.b	$00,$02,$95,$0E,$00,$04,$FF,$00

LineEditorMenuText					;Line editor exit menu
	dc.b	$00,$06,$FE,$06,$F9,$01,$00,$06,$FE,$04,$F9,$01
	String	'       Exit       '
	dc.b	$00,$03,$C0,$00
	String	'Set Original lines'
	dc.b	$00,$03,$F2,$08
	String	'  Save Team Line  '
	dc.b	$00,$02,$D0,$46
	String	'  Load Team Line  '
	dc.b	$00,$02,$CF,$DE,$00,$04,$FF,$00

LineEditorMenuNoLoad				;Line editor exit menu without Load Team Line
	dc.b	$00,$06,$FE,$06,$F9,$01,$00,$06,$FE,$04,$F9,$01
	String	'       Exit       '
	dc.b	$00,$03,$C0,$00
	String	'Set Original lines'
	dc.b	$00,$03,$F2,$08
	String	'  Save Team Line  '
	dc.w	2							;end of the list: an empty String
	dc.w	$D046,4,$FF00				;not read: the bytes between the list and PicturePalette