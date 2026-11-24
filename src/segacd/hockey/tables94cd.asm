updatecrowdf_cd0					;$fftt = frame/time for various levels of crowd
									;excitement. Data, not code: updatecrowdf reads byte 0 (frame) and
									;byte 1 (time) of the word at crowd level * 32 + Crowdstep (16 words
									;per level). Same rows as the cartridge's
	dc.w	$010c,$020c,$030c,$040c,$050c,$0a0c,$090c,$080c
	dc.w	$060c,$070c,$080c,$090c,$0a0c,$050c,$040c,$030c

; Table of 16 words after updatecrowdf_cd0, 32 bytes: $0107,$0207,$0307,$0407,$0507,$0B07 ...
	dc.w	$0107,$0207,$0307,$0407,$0507,$0b07,$0c07,$0d07
	dc.w	$0607,$0707,$0807,$0907,$0a07,$0b07,$0c07,$0d07

; Table of 16 words after updatecrowdf_cd0, 32 bytes: $0E07,$0F07,$1007,$1107,$1207,$0B07 ...
	dc.w	$0e07,$0f07,$1007,$1107,$1207,$0b07,$0c07,$0d07
	dc.w	$1207,$1107,$1007,$0f07,$0e07,$0d07,$0c07,$0b07

; Table of 160 words after updatecrowdf_cd0, 176 bytes: $0E03,$0F03,$1003,$1103,$1203,$0B03 ...
	dc.w	$0e03,$0f03,$1003,$1103,$1203,$0b03,$0c03,$0d03
	dc.w	$1203,$1103,$1003,$0f03,$0e03,$0d03,$0c03,$0b03
asstab								;jump table of all the player logic assignments. There is no "do nothing"
									;entry, so assignment numbers from assscore on are one lower than in 92.
									;Entries $1D-$23 are new in 94. Used by updateplayers
	dc.l	rtss2		;anull: entry 0: empty assignment (rtss2)

	dc.l	assdefo		;adefo: entry 1: defensive player on offense (assdefo)
	dc.l	assdefd		;adefd: entry 2: defensive player on defense
	dc.l	asswingd		;awingd: entry 3: winger on defense
	dc.l	asswingo		;awingo: entry 4: winger on offense
	dc.l	asscenterd		;acenterd: entry 5: center on defense
	dc.l	asscentero		;acentero: entry 6: center on offense

	dc.l	assscore		;ascore: celebrating a goal
	dc.l	assstanley		;astanley: skating with the Stanley Cup overhead
	dc.l	asseben		;aeben: exit the bench area
	dc.l	assepen		;aepen: exit the penalty area
	dc.l	assbench		;abench: go to the bench
	dc.l	asspenalty		;apenalty: go to the penalty box
	dc.l	assdopen		;adopen: add the player to the penalty box

	dc.l	assgoalie		;agoalie: goalie logic
	dc.l	assgoalietopuck		;agoalietopuck: goalie skates out to a loose puck
	dc.l	asspuckc		;apuckc: puck handler
	dc.l	assnearest		;anearest: player nearest the puck without it
	dc.l	assshoot		;ashoot: computer shooting
	dc.l	asspassrec		;apassrec: catching a pass
	dc.l	assfight		;afight: fighting
	dc.l	assfwatch		;afwatch: watching a fight
	dc.l	assfaceoff		;afaceoff: wait until the faceoff is over
	dc.l	assfaceoffpl		;afaceoffpl: players taking part in the faceoff

	dc.l	pucknorm		;pnorm: puck object: normal movement (pucknorm)
	dc.l	puckshadow		;pshad: puck object: puck shadow
	dc.l	puckunflip		;pnothing: puck object: just slides along
	dc.l	puckfaceoff		;pfaceoff: puck object: faceoff start
	dc.l	puckfaceoff2		;pfaceoff2: puck object: faceoff control and setup

	dc.l	assgoaliectrl		;agoaliectrl: joystick goalie
	dc.l	puckshootout		;pshootout: puck object: shootout
	dc.l	puckpenshot		;ppenshot: puck object: penalty shot
	dc.l	assgoaliebreakwait		;agoaliebreakwait: goalie waits for a breakaway
	dc.l	chkpuckc		;achkpuckc: breakaway carrier check, then asspuckc
	dc.l	assbreakaway		;abreakaway: breakaway
	dc.l	assonetimer		;aonetimer: one-timer shot

Penaltylist							;Penalty number = word offset into this table. Entries $2E-$3C are the
									;penalty shot additions (the penalty shot
									;versions of 7 penalties, minutes byte $FF, and a second Face Off). Used
									;by AddPenalty, SetPA2, PenaltyShotBox, ...
; Data of Penaltylist (31 rows): table or constants used by it.
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
; Instruction bytes inside PenDataEOP that the assembler would encode differently, kept as words (1 row).
	dc.w	-$0510
PenDataEOG	dc.w	$0100			;ttmm: slow down 1, 0 minutes
	String	'Game Over'
; Instruction bytes inside PenDataEOG that the assembler would encode differently, kept as words (1 row).
	dc.w	$0510,-$4060
PenDataGoal	dc.w	$0100			;ttmm: slow down 1, 0 minutes; empty text
	dc.w	2						;String with no text
	dc.w	$050a,-$4018
PenDataNoText	dc.w	$0100		;ttmm: slow down 1, 0 minutes; empty text
	dc.w	2						;String with no text
	dc.w	$0510,-$4018
PenDataice	dc.w	$0100			;ttmm: slow down 1, 0 minutes
	String	'Icing'
; Instruction bytes inside PenDataice that the assembler would encode differently, kept as words (1 row).
	dc.w	$0002,$0101,-$0206
PenDataoffsides	dc.w	$0100		;ttmm: slow down 1, 0 minutes
	String	'Off-side'
; Instruction bytes inside PenDataoffsides that the assembler would encode differently, kept as words (1 row).
	dc.w	$0002,$0301,-$040f
PenDataGhold	dc.w	$0100		;ttmm: slow down 1, 0 minutes (also used for out of play / PenOOP)
	String	'Face Off'
; Instruction bytes inside PenDataGhold that the assembler would encode differently, kept as words (1 row).
	dc.w	-$050a
PenDataGhold2	dc.w	$0000		;face off text with ttmm 0 (no slow down, 0 minutes), Penaltylist entry
									;for a face off
	String	'Face Off'
; Instruction bytes inside PenDataGhold2 that the assembler would encode differently, kept as words (1 row).
	dc.w	-$050a
PenDatadelay	dc.w	$0000		;ttmm: no slow down, 0 minutes
	String	'Penalty'
; Instruction bytes inside PenDatadelay that the assembler would encode differently, kept as words (1 row).
	dc.w	$0003,$0301,-$040f
PenDatawhistle	dc.w	$0000		;ttmm: no slow down, 0 minutes; empty text
	dc.w	2						;String with no text
	dc.w	-$050a
PenDatacharge	dc.w	$0402		;ttmm: slow down 4, 2 minutes
	String	'Charging'
; Instruction bytes inside PenDatacharge that the assembler would encode differently, kept as words (1 row).
	dc.w	$0004,$0101,$0a01,$0b01,$0a01,$0b01,$0a01,$0b01,$0a01,$0b01,-$0101
PenDatachargeps	dc.w	$04ff		;penalty shot form of PenDatacharge: slow down 4, minutes $FF. Negative
									;minutes are skipped like 0 by AddPenalty and the penalty box code, so no
									;time is served
	String	'Charging'
; Instruction bytes inside PenDatachargeps that the assembler would encode differently, kept as words (1 row).
	dc.w	$0004,$0101,$0a01,$0b01,$0a01,$0b01,$0a01,$0b01,$0a01,$0b01,-$0101
PenDataslash	dc.w	$0402		;ttmm: slow down 4, 2 minutes
	String	'Slashing'
; Instruction bytes inside PenDataslash that the assembler would encode differently, kept as words (1 row).
	dc.w	$0004,$0101,$0201,$0301,$0201,$0301,$0201,$0301,$0201,$0301,-$0101
PenDataslashps	dc.w	$04ff		;penalty shot form of PenDataslash: slow down 4, minutes $FF. Negative
									;minutes are skipped like 0 by AddPenalty and the penalty box code, so no
									;time is served
	String	'Slashing'
; Instruction bytes inside PenDataslashps that the assembler would encode differently, kept as words (1 row).
	dc.w	$0004,$0101,$0201,$0301,$0201,$0301,$0201,$0301,$0201,$0301,-$0101
PenDatatrip	dc.w	$0402			;ttmm: slow down 4, 2 minutes
	String	'Tripping'
; Instruction bytes inside PenDatatrip that the assembler would encode differently, kept as words (1 row).
	dc.w	$0004,$0401,$0501,$0401,$0501,$0401,$0501,$0401,$0501,-$0101
PenDatatripps	dc.w	$04ff		;penalty shot form of PenDatatrip: slow down 4, minutes $FF. Negative
									;minutes are skipped like 0 by AddPenalty and the penalty box code, so no
									;time is served
	String	'Tripping'
; Instruction bytes inside PenDatatripps that the assembler would encode differently, kept as words (1 row).
	dc.w	$0004,$0401,$0501,$0401,$0501,$0401,$0501,$0401,$0501,-$0101
PenDatarough2	dc.w	$0a02		;ttmm: slow down $0a, 2 minutes
	String	'Roughing'
; Instruction bytes inside PenDatarough2 that the assembler would encode differently, kept as words (1 row).
	dc.w	$0004,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,-$0101
PenDatarough	dc.w	$0402		;ttmm: slow down 4, 2 minutes
	String	'Roughing'
; Instruction bytes inside PenDatarough that the assembler would encode differently, kept as words (1 row).
	dc.w	$0004,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,-$0101
PenDataroughps	dc.w	$04ff		;penalty shot form of PenDatarough: slow down 4, minutes $FF. Negative
									;minutes are skipped like 0 by AddPenalty and the penalty box code, so no
									;time is served
	String	'Roughing'
; Instruction bytes inside PenDataroughps that the assembler would encode differently, kept as words (1 row).
	dc.w	$0004,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,-$0101
PenDatahook	dc.w	$0402			;ttmm: slow down 4, 2 minutes
	String	'Hooking'
; Instruction bytes inside PenDatahook that the assembler would encode differently, kept as words (1 row).
	dc.w	$0004,$0101,$0901,$0801,$0901,$0801,$0901,$0801,$0901,$0801,-$0101
PenDatahookps	dc.w	$04ff		;penalty shot form of PenDatahook: slow down 4, minutes $FF. Negative
									;minutes are skipped like 0 by AddPenalty and the penalty box code, so no
									;time is served
	String	'Hooking'
; Instruction bytes inside PenDatahookps that the assembler would encode differently, kept as words (1 row).
	dc.w	$0004,$0101,$0901,$0801,$0901,$0801,$0901,$0801,$0901,$0801,-$0101
PenDatacross	dc.w	$0402		;ttmm: slow down 4, 2 minutes
	String	'Cross Check'
; Instruction bytes inside PenDatacross that the assembler would encode differently, kept as words (1 row).
	dc.w	$0004,$0601,$0f01,$1001,$0f01,$1001,$0f01,$1001,$0f01,$1001,-$0101
PenDatacrossps	dc.w	$04ff		;penalty shot form of PenDatacross: slow down 4, minutes $FF. Negative
									;minutes are skipped like 0 by AddPenalty and the penalty box code, so no
									;time is served
	String	'Cross Check'
; Instruction bytes inside PenDatacrossps that the assembler would encode differently, kept as words (1 row).
	dc.w	$0004,$0601,$0f01,$1001,$0f01,$1001,$0f01,$1001,$0f01,$1001,-$0101
PenDataint	dc.w	$0402			;ttmm: slow down 4, 2 minutes
	String	'Interference'
; Instruction bytes inside PenDataint that the assembler would encode differently, kept as words (1 row).
	dc.w	$0004,$0101,$0c06,-$0101
PenDataintps	dc.w	$04ff		;penalty shot form of PenDataint: slow down 4, minutes $FF. Negative
									;minutes are skipped like 0 by AddPenalty and the penalty box code, so no
									;time is served
	String	'Interference'
; Instruction bytes inside PenDataintps that the assembler would encode differently, kept as words (1 row).
	dc.w	$0004,$0101,$0c06,-$0101
PenDataHold	dc.w	$0402			;ttmm: slow down 4, 2 minutes
	String	'Holding'
; Instruction bytes inside PenDataHold that the assembler would encode differently, kept as words (1 row).
	dc.w	$0004,$0101,$0706,-$0101
PenDatafight	dc.w	$2805		;ttmm: slow down $28, 5 minutes
	String	'Fighting'
; Instruction bytes inside PenDatafight that the assembler would encode differently, kept as words (1 row).
	dc.w	$0004,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,-$0101
PenDatafight2	dc.w	$2805		;ttmm: slow down $28, 5 minutes
	String	'Fighting *'
; Instruction bytes inside PenDatafight2 that the assembler would encode differently, kept as words (1 row).
	dc.w	$0004,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,-$0101
PenDataInst	dc.w	$2802			;ttmm: slow down $28, 2 minutes
	String	'Fight Instigator'
; Instruction bytes inside PenDataInst that the assembler would encode differently, kept as words (1 row).
	dc.w	$0004,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,$0d01,$0e01,-$0101

PenShotPenalties					;the penalty shot penalty number for penalty number d0 (word offset), -1
									;none. Used by PenShotChk
; Table of 24 words after PenShotPenalties, 48 bytes: $FFFF,$FFFF,$FFFF,$FFFF,$FFFF,$FFFF ...
	dc.w	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,$38,$3C
	dc.w	$36,$3A,$2E,$30,$34,-1,-1,-1,-1,-1,-1,-1

bfasciicon							;equates to find each char definition for bigfont.map.. Indexed by ascii -
									;$20 in PrintBigChar (called from printbig)
	;    -sp  -!  "  #  $  %  &  -'  (  )  *  +  ,  -  -.  /
; Data of bfasciicon (1 row): table or constants used by it.
	dc.b -76,-73,00,00,00,00,00,-71,00,00,00,00,00,00,-72,00
	;     0  -1  2  3  4  5  6  7  8  9  -:  ;  <  =  >  ?
; Data of bfasciicon (1 row): table or constants used by it.
	dc.b 51,-53,54,56,58,60,62,64,66,68,-71,00,00,00,00,74
	;     @  A  B  C  D  E  F  G  H  -I  J  K  L  M  N  O
; Data of bfasciicon (1 row): table or constants used by it.
	dc.b 74,00,02,04,06,08,10,12,14,-16,17,19,21,23,25,27
	;     P  Q  R  S  T  U  V  W  X  Y  Z
; Data of bfasciicon (2 rows): table or constants used by it.
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

; Data of sublist (2 rows): table or constants used by it.
.defl	dc.b	0+1,8+1,16+1,24+1,32+1,40+1,48+1	;list of players in there lines/each line = 8 bytes
	dc.b	0+2,8+2,16+2,24+2,32+2,40+2,48+2
; Data of sublist (2 rows): table or constants used by it.
.defr	dc.b	0+2,8+2,16+2,24+2,32+2,40+2,48+2	;defensive RD slots first, then LD slots
	dc.b	0+1,8+1,16+1,24+1,32+1,40+1,48+1
; Data of sublist (3 rows): table or constants used by it.
.wingl	dc.b	0+3,8+3,16+3,24+3,32+3,40+3,48+3	;left wing slots, then right wing, then center
	dc.b	0+5,8+5,16+5,24+5,32+5,40+5,48+5
	dc.b	0+4,8+4,16+4,24+4,32+4,40+4,48+4
; Data of sublist (3 rows): table or constants used by it.
.wingr	dc.b	0+5,8+5,16+5,24+5,32+5,40+5,48+5	;right wing slots, then left wing, then center
	dc.b	0+3,8+3,16+3,24+3,32+3,40+3,48+3
	dc.b	0+4,8+4,16+4,24+4,32+4,40+4,48+4
; Data of sublist (4 rows): table or constants used by it.
.center	dc.b	0+4,8+4,16+4,24+4,32+4,40+4,48+4	;center slots, then left wing, then right wing; -1 ends
	dc.b	0+3,8+3,16+3,24+3,32+3,40+3,48+3
	dc.b	0+5,8+5,16+5,24+5,32+5,40+5,48+5
	dc.b	-1

priolist	dc.b	0,1,2,4,3,5,6	;positions in order of importance. Used by
	dc.b	$00

PlayoffScreen_setup					;Playoff tree layout by gamelevel, one column per round. Used by
									;PlayoffScreen
; Data of PlayoffScreen_setup (5 rows): table or constants used by it.
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
; Instruction bytes inside PAttribOverallMask that the assembler would encode differently, kept as words (1 row).
	dc.w	$1000,$a
	String	'[    Speed     ]'
	dc.w	$0800,$000A		; btst #$A,d0
	String	'[   Handed     ]'
	dc.w	$0040,$0004		; ori.w #$4,d0
	String	'[Off. Awareness]'
	dc.w	$0400,$000A		; subi.b #$A,d0
	String	'[Def. Awareness]'
	dc.w	$0200,$000A		; andi.b #$A,d0
	String	'[  Shot Power  ]'
; Instruction bytes inside PAttribOverallMask that the assembler would encode differently, kept as words (1 row).
	dc.w	$0100,$a
	String	'[Shot  Accuracy]'
	dc.w	$0010,$000A		; ori.b #$A,(a0)
	String	'[Pass  Accuracy]'
	dc.w	$0002,$000A		; ori.b #$A,d2
	String	'[Stick Handling]'
	dc.w	$0020,$000A		; ori.b #$A,-(a0)
	String	'[    Weight    ]'
	dc.w	$2000,$6				;weight
	String	'[  Endurance   ]'
; Instruction bytes inside PAttribOverallMask that the assembler would encode differently, kept as words (1 row).
	dc.w	$0008,$a
	String	'[Aggressiveness]'
	dc.w	$0001,$000A		; ori.b #$A,d1
	String	'[   Checking    '
; Instruction bytes inside PAttribOverallMask that the assembler would encode differently, kept as words (2 rows).
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
; Instruction bytes inside GAttribOverallMask that the assembler would encode differently, kept as words (1 row).
	dc.w	$1000,$a
	String	'[    Speed     ]'
	dc.w	$0800,$000A		; btst #$A,d0
	String	'[  Glove Hand  ]'
	dc.w	$0040,$0004		; ori.w #$4,d0
	String	'[Def. Awareness]'
	dc.w	$0200,$000A		; andi.b #$A,d0
	String	'[ Puck Control ]'
; Instruction bytes inside GAttribOverallMask that the assembler would encode differently, kept as words (1 row).
	dc.w	$0100,$a
	String	'[ Stick  Right ]'
; Instruction bytes inside GAttribOverallMask that the assembler would encode differently, kept as words (1 row).
	dc.w	$0008,$a
	String	'[  Stick Left  ]'
	dc.w	$0004,$000A		; ori.b #$A,d4
	String	'[ Glove  Right ]'
	dc.w	$0002,$000A		; ori.b #$A,d2
	String	'[  Glove Left  ]'
	dc.w	$0001,$000A		; ori.b #$A,d1
	String	'[    Weight     '
	dc.w	$2000		; move.l d0,d0
	dc.w	$0006,$FFFF		; ori.b #$FF,d6
PauseMenuItems	dc.w	$0004,$FE05		; ori.b #$5,d4
	dc.w	$0004,$FE04		; ori.b #$4,d4
	String	'   Resume Game    '
	dc.w	$0003,$C000		; ori.b #$0,d3
	String	'  Instant Replay  '
	dc.w	$0002,$EE04		; ori.b #$4,d2
	String	'   Team Roster    '
	dc.w	$0002,$D0D4		; ori.b #$D4,d2
	String	'   Player Cards   '
	dc.w	$0002,$5E56		; ori.b #$56,d2
	String	'  Record Holders  '
	dc.w	$0002,$70E0		; ori.b #$E0,d2
	String	'x Manual Goalie   '
	dc.w	$0002,$A092		; ori.b #$92,d2
	dc.w	$0004,$FF00		; ori.b #$0,d4
Pausemode_mlist	dc.w	$0004,$FE05		; ori.b #$5,d4
	dc.w	$0004,$FE04		; ori.b #$4,d4
	String	'   Resume Game    '
	dc.w	$0003,$C000		; ori.b #$0,d3
	String	'  Instant Replay  '
	dc.w	$0002,$EE04		; ori.b #$4,d2
	String	'  Change Goalie   '
	dc.w	$0002,$EBAE		; ori.b #$AE,d2
	String	'    Edit Lines    '
	dc.w	$0002,$C932		; ori.b #$32,d2
	String	'    Game Stats    '
	dc.w	$0002,$9A2E		; ori.b #$2E,d2
	String	'   Player Stats   '
	dc.w	$0002,$DE50		; ori.b #$50,d2
	String	' Scoring Summary  '
	dc.w	$0002,$D6D6		; ori.b #$D6,d2
	String	' Penalty Summary  '
	dc.w	$0002,$DA4C		; ori.b #$4C,d2
	String	'   Team Roster    '
	dc.w	$0002,$D0D4		; ori.b #$D4,d2
	String	'   Other Scores   '
	dc.w	$0002,$C660		; ori.b #$60,d2
	String	'   Crowd Meter    '
	dc.w	$0002,$E556		; ori.b #$56,d2
	String	'     Timeout      '
	dc.w	$0002,$EB2A		; ori.b #$2A,d2
	String	'   Player Cards   '
	dc.w	$0002,$5E56		; ori.b #$56,d2
	String	'  Record Holders  '
	dc.w	$0002,$70E0		; ori.b #$E0,d2
	String	'   Period Stats   '
	dc.w	$0002,$950E		; ori.b #$E,d2
	String	'x Manual Goalie   '
	dc.w	$0002,$A092		; ori.b #$92,d2
	dc.w	$0004,$FF00		; ori.b #$0,d4
PauseText2	String	CC_SetAttribute,$5		;Pause menu item list without Timeout (PauseMode); the cartridge PauseText2
	String	CC_SetAttribute,$4
	String	'   Resume Game    '
	dc.w	$0003,$C000		; ori.b #$0,d3
	String	'  Instant Replay  '
	dc.w	$0002,$EE04		; ori.b #$4,d2
	String	'  Change Goalie   '
	dc.w	$0002,$EBAE		; ori.b #$AE,d2
	String	'    Edit Lines    '
	dc.w	$0002,$C932		; ori.b #$32,d2
	String	'    Game Stats    '
	dc.w	$0002,$9A2E		; ori.b #$2E,d2
	String	'   Player Stats   '
	dc.w	$0002,$DE50		; ori.b #$50,d2
	String	' Scoring Summary  '
	dc.w	$0002,$D6D6		; ori.b #$D6,d2
	String	' Penalty Summary  '
	dc.w	$0002,$DA4C		; ori.b #$4C,d2
	String	'   Team Roster    '
	dc.w	$0002,$D0D4		; ori.b #$D4,d2
	String	'   Other Scores   '
	dc.w	$0002,$C660		; ori.b #$60,d2
	String	'   Crowd Meter    '
	dc.w	$0002,$E556		; ori.b #$56,d2
	String	'   Player Cards   '
	dc.w	$0002,$5E56		; ori.b #$56,d2
	String	'  Record Holders  '
	dc.w	$0002,$70E0		; ori.b #$E0,d2
	String	'   Period Stats   '
	dc.w	$0002,$950E		; ori.b #$E,d2
	String	'x Manual Goalie   '
	dc.w	$0002,$A092		; ori.b #$92,d2
	dc.w	$0004,$FF00		; ori.b #$0,d4
ShootoutIntermissionMenu	dc.w	$0004,$FE05		; ori.b #$5,d4
	dc.w	$0004,$FE04		; ori.b #$4,d4
	String	'  Start Shootout  '
	dc.w	$0003,$C000		; ori.b #$0,d3
	String	'  Shootout SetUp  '
	dc.w	$0002,$7BD0		; ori.b #$D0,d2
	String	'   Team Roster    '
	dc.w	$0002,$D0D4		; ori.b #$D4,d2
	String	'   Player Cards   '
	dc.w	$0002,$5E56		; ori.b #$56,d2
	String	'  Record Holders  '
	dc.w	$0002,$70E0		; ori.b #$E0,d2
	dc.w	$0004,$FF00		; ori.b #$0,d4
	dc.w	$0004,$FE05		; ori.b #$5,d4
	dc.w	$0004,$FE04		; ori.b #$4,d4
	String	'    Start Game    '
	dc.w	$0003,$C000		; ori.b #$0,d3
	String	'  Change Goalie   '
	dc.w	$0002,$EBAE		; ori.b #$AE,d2
	String	'    Edit Lines    '
	dc.w	$0002,$C932		; ori.b #$32,d2
	String	'   Team Roster    '
	dc.w	$0002,$D0D4		; ori.b #$D4,d2
	String	'   Other Scores   '
	dc.w	$0002,$C660		; ori.b #$60,d2
	String	'   Player Cards   '
	dc.w	$0002,$5E56		; ori.b #$56,d2
	String	'  Record Holders  '
	dc.w	$0002,$70E0		; ori.b #$E0,d2
	dc.w	$0004,$FF00		; ori.b #$0,d4
	dc.w	$0004,$FE05		; ori.b #$5,d4
	dc.w	$0004,$FE04		; ori.b #$4,d4
	String	'    Start Game    '
	dc.w	$0003,$C000		; ori.b #$0,d3
	String	'  Change Goalie   '
	dc.w	$0002,$EBAE		; ori.b #$AE,d2
	String	'    Edit Lines    '
	dc.w	$0002,$C932		; ori.b #$32,d2
	String	'   Team Roster    '
	dc.w	$0002,$D0D4		; ori.b #$D4,d2
	String	'  Playoff Stats   '
	dc.w	$0002,$DE18		; ori.b #$18,d2
	String	'   Other Scores   '
	dc.w	$0002,$C660		; ori.b #$60,d2
	String	'   Player Cards   '
	dc.w	$0002,$5E56		; ori.b #$56,d2
	String	'  Record Holders  '
	dc.w	$0002,$70E0		; ori.b #$E0,d2
	dc.w	$0004,$FF00		; ori.b #$0,d4
	dc.w	$0004,$FE05		; ori.b #$5,d4
	dc.w	$0004,$FE04		; ori.b #$4,d4
	String	'   Resume Game    '
	dc.w	$0003,$C000		; ori.b #$0,d3
	String	'    Game Stats    '
	dc.w	$0002,$9A2E		; ori.b #$2E,d2
	String	'   Player Stats   '
	dc.w	$0002,$DE50		; ori.b #$50,d2
	String	' Scoring Summary  '
	dc.w	$0002,$D6D6		; ori.b #$D6,d2
	String	' Penalty Summary  '
	dc.w	$0002,$DA4C		; ori.b #$4C,d2
	String	'   Team Roster    '
	dc.w	$0002,$D0D4		; ori.b #$D4,d2
	String	'   Other Scores   '
	dc.w	$0002,$C660		; ori.b #$60,d2
	String	'   Crowd Meter    '
	dc.w	$0002,$E556		; ori.b #$56,d2
	String	'  Change Goalie   '
	dc.w	$0002,$EBAE		; ori.b #$AE,d2
	String	'    Edit Lines    '
	dc.w	$0002,$C932		; ori.b #$32,d2
	String	'   Player Cards   '
	dc.w	$0002,$5E56		; ori.b #$56,d2
	String	'  Record Holders  '
	dc.w	$0002,$70E0		; ori.b #$E0,d2
	String	'   Period Stats   '
	dc.w	$0002,$950E		; ori.b #$E,d2
	String	'x Manual Goalie   '
	dc.w	$0002,$A092		; ori.b #$92,d2
	dc.w	$0004,$FF00		; ori.b #$0,d4
	dc.w	$0004,$FE05		; ori.b #$5,d4
	dc.w	$0004,$FE04		; ori.b #$4,d4
	String	'    Exit Game     '
	dc.w	$0003,$C000		; ori.b #$0,d3
	String	'    Game Stats    '
	dc.w	$0002,$9A2E		; ori.b #$2E,d2
	String	'   Player Stats   '
	dc.w	$0002,$DE50		; ori.b #$50,d2
	String	' Scoring Summary  '
	dc.w	$0002,$D6D6		; ori.b #$D6,d2
	String	' Penalty Summary  '
	dc.w	$0002,$DA4C		; ori.b #$4C,d2
	String	'   Team Roster    '
	dc.w	$0002,$D0D4		; ori.b #$D4,d2
	String	'   Other Scores   '

; Instruction bytes inside GAttribOverallMask that the assembler would encode differently, kept as words (1 row).
	dc.b	$00,$02,$C6,$60
	String	'   Crowd Meter    '
	dc.w	$0002,$E556		; ori.b #$56,d2
	String	'   Player Cards   '
	dc.w	$0002,$5E56		; ori.b #$56,d2
	String	'  Record Holders  '
	dc.w	$0002,$70E0		; ori.b #$E0,d2
	String	'   Period Stats   '
; Instruction bytes inside GAttribOverallMask that the assembler would encode differently, kept as words (1 row).
	dc.b	$00,$02,$95,$0E,$00,$04,$FF,$00

ExitGameText						;Intermission menu for gsp 4
	dc.b	$00,$04,$FE,$05,$00,$04,$FE,$04
	String	'    Exit Game     '
	dc.w	$0003,$C000		; ori.b #$0,d3
	String	'    Game Stats    '
	dc.w	$0002,$9A2E		; ori.b #$2E,d2
	String	'   Player Stats   '
	dc.w	$0002,$DE50		; ori.b #$50,d2
	String	' Scoring Summary  '
	dc.w	$0002,$D6D6		; ori.b #$D6,d2
	String	' Penalty Summary  '
	dc.w	$0002,$DA4C		; ori.b #$4C,d2
	String	'   Team Roster    '
	dc.w	$0002,$D0D4		; ori.b #$D4,d2
	String	'   Other Scores   '
	dc.w	$0002,$C660		; ori.b #$60,d2
	String	'   Crowd Meter    '
	dc.w	$0002,$E556		; ori.b #$56,d2
	String	'   Player Cards   '
	dc.w	$0002,$5E56		; ori.b #$56,d2
	String	'  Record Holders  '
	dc.w	$0002,$70E0		; ori.b #$E0,d2
	String	'   Period Stats   '
; Instruction bytes inside ExitGameText that the assembler would encode differently, kept as words (1 row).
	dc.b	$00,$02,$95,$0E,$00,$04,$FF,$00

LineEditorMenuText					;Line editor exit menu
	dc.b	$00,$06,$FE,$06,$F9,$01,$00,$06,$FE,$04,$F9,$01
	String	'       Exit       '
	dc.w	$0003,$C000		; ori.b #$0,d3
	String	'Set Original lines'
	dc.w	$0003,$F208		; ori.b #$8,d3
	String	'  Save Team Line  '
	dc.w	$0002,$D046		; ori.b #$46,d2
	String	'  Load Team Line  '
; Instruction bytes inside LineEditorMenuText that the assembler would encode differently, kept as words (1 row).
	dc.b	$00,$02,$CF,$DE,$00,$04,$FF,$00

LineEditorMenuNoLoad				;Line editor exit menu without Load Team Line
	dc.b	$00,$06,$FE,$06,$F9,$01,$00,$06,$FE,$04,$F9,$01
	String	'       Exit       '
	dc.w	$0003,$C000		; ori.b #$0,d3
	String	'Set Original lines'
	dc.w	$0003,$F208		; ori.b #$8,d3
	String	'  Save Team Line  '
	dc.w	2							;end of the list: an empty String
	dc.w	$D046,4,$FF00				;not read: the bytes between the list and PicturePalette