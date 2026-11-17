	include	segacd\hockey.inc
	include	macros\genesis.mac


	org	$21D3E

NewTicker3
	dc.w	$4A43
	dc.w	$6B00,$F2BE
	dc.w	$6100,$0152
	dc.w	$6100,$BF56
	dc.w	$0679,$0001,$0001,$8D58
	dc.w	$0479,$0004,$0001,$8D5A
	dc.w	$3F39,$0001,$8D58
	dc.w	$6100,$3AB8
	dc.w	$33FC,$A000,$0001,$8D5C
	dc.w	$6100,$C1FE
	dc.w	$001A,$2020,$2020,$2020,$2020,$2020,$2020,$2020,$2020,$2020,$2020,$2020,$2020
	dc.w	$33D7,$0001,$8D58
	dc.w	$7001
	dc.w	$D079,$0001,$8A9E
	dc.w	$4A79,$0001,$8BFA
	dc.w	$6600,$0004
	dc.w	$4240
.l21DA6	dc.w	$43FA,$0094
	dc.w	$6100,$0112
	dc.w	$3028,$0008
	dc.w	$0440,$0001
	dc.w	$227C,$0004,$1A34
	dc.w	$6100,$0108
	dc.w	$3011
	dc.w	$E248
	dc.w	$4440
	dc.w	$D057
	dc.w	$0640,$0017
	dc.w	$33C0,$0001,$8D58
	dc.w	$6100,$C1AC
	dc.w	$33FC,$8000,$0001,$8D5C
	dc.w	$3028,$0002
	dc.w	$3228,$000C
	dc.w	$6100,$0014
	dc.w	$3028,$0000
	dc.w	$3228,$000A
	dc.w	$6100,$0008
	dc.w	$DEFC,$0002
	dc.w	$4E75
.l21DFC	dc.w	$33EF,$0004,$0001,$8D58
	dc.w	$0679,$0001,$0001,$8D5A
	dc.w	$227C,$0001,$B00C
	dc.w	$E540
	dc.w	$2271,$0000
	dc.w	$D2E9,$0004
	dc.w	$6100,$C162
	dc.w	$33EF,$0004,$0001,$8D58
	dc.w	$0679,$0015,$0001,$8D58
	dc.w	$3001
	dc.w	$7202
	dc.w	$6100,$C364
	dc.w	$6000,$C146
	dc.w	$0012,$4541
	dc.w	$2048
	dc.w	$6F63
	dc.w	$6B65
	dc.w	$7920
	dc.w	$4E69
	dc.w	$6768
	dc.w	$7400
	dc.w	$0018,$5374
	dc.w	$616E
	dc.w	$6C65
	dc.w	$7920
	dc.w	$4375
	dc.w	$7020
	dc.w	$5175,$616C,$6966
	dc.w	$6965
	dc.w	$7200
	dc.w	$000E
	dc.w	$5175,$6172,$7465,$7266,$696E
	dc.w	$616C
	dc.w	$0018,$5374
	dc.w	$616E
	dc.w	$6C65
	dc.w	$7920
	dc.w	$4375
	dc.w	$7020
	dc.w	$5365
	dc.w	$6D69
	dc.w	$6669
	dc.w	$6E61
	dc.w	$6C00,$6100
	dc.w	$000A
	dc.w	$343C,$07FF
	dc.w	$6000,$BD70
SetTickerAreaPosition
	dc.w	$6100,$C0D4
	dc.w	$0006,$BD03,$1700
	dc.w	$0839,$0000,$0001,$7F6A
	dc.w	$6600,$000C
	dc.w	$6100,$C0BE
	dc.w	$0006,$BF03,$1700
.l21EB8	dc.w	$701A
	dc.w	$7205
	dc.w	$4E75
Fprintsmall
	dc.w	$6100,$0006
	dc.w	$6000,$BEDA
.l21EC6	dc.w	$6000,$0004
.l21ECA	dc.w	$D2D1
.l21ECC	dc.w	$51C8,$FFFC
	dc.w	$4E75
DoHiLights
	dc.w	$6100,$3948
	dc.w	$7610
	dc.w	$C6C1
	dc.w	$207C,$0001,$8A18
	dc.w	$D0C3
.l21EE2	dc.w	$0828,$0002,$000E
	dc.w	$6600,$0010
	dc.w	$08A8,$0001,$000E
	dc.w	$6700,$0006
	dc.w	$6100,$000C
.l21EFA	dc.w	$90FC,$0010
	dc.w	$51C9,$FFE2
	dc.w	$4E75
StartHL
	dc.w	$48E7,$FFFE
	dc.w	$0839,$0003,$0001,$7F6E
	dc.w	$6600,$040C
	dc.w	$6100,$04A4
	dc.w	$3601
	dc.w	$6100,$FE00
	dc.w	$6100,$FE1E
	dc.w	$0839,$0003,$0001,$7F6E
	dc.w	$6600,$03E6,$33FC,$0004,$0001,$8D58,$0479,$0006
	dc.w	$0001,$8D5A,$7018,$7203,$6100,$BD5C,$0679,$0001
	dc.w	$0001,$8D58,$0479,$0002,$0001,$8D5A,$6100,$C016
	dc.w	$0016,$4869,$6768,$6C69,$6768,$7420,$6672,$6F6D
	dc.w	$2067,$616D,$653A,$303C,$00B4,$6100,$A3CA,$0801
	dc.w	$0007,$6600,$0394,$50F9,$0001,$7CE2,$4279,$0001
	dc.w	$7CD8,$33E8,$0000,$0001,$7FAE,$33E8,$0002,$0001
	dc.w	$7FB0,$2F08,$4279,$0001,$8374,$4279,$0001,$86DA
	dc.w	$4EB9,$0003,$F11E,$4EB9,$0002,$B996,$50F9,$0001
	dc.w	$7F9E,$50F9,$0001,$7FA0,$4279,$0001,$7FA6,$4279
	dc.w	$0001,$7FA8,$7078,$6100,$A07E,$0640,$003C,$33C0
	dc.w	$0001,$80E6,$2057,$33E8,$0008,$0001,$80E4,$0479
	dc.w	$0001,$0001,$80E4,$33E8,$000A,$0001,$8358,$33E8
	dc.w	$000C,$0001,$86BE,$13FC,$0010,$0001,$7F68,$0839
	dc.w	$0000,$0001,$80E5,$6700,$000A,$08F9,$0001,$0001
	dc.w	$7F68,$4239,$0001,$7F6A,$13FC,$0004,$0001,$7F6C
	dc.w	$4239,$0001,$7F6E,$08B9,$0004,$0001,$8D64,$08F9
	dc.w	$0003,$0001,$8D64,$4279,$0001,$7E32,$4239,$0001
	dc.w	$7ECE,$50F9,$0001,$806E,$50F9,$0001,$7E38,$50F9
	dc.w	$0001,$7E3C,$4EB9,$0004,$7DAC,$6100,$1AD6,$33FC
	dc.w	$0001,$0001,$7468,$6100,$F33A,$33FC,$0000,$0001
	dc.w	$7468,$207C,$00C0,$0000,$0839,$0007,$00FF,$800E
	dc.w	$66F6,$33FC,$9100,$00FF,$8022,$33FC,$000A,$00FF
	dc.w	$8020,$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9
	dc.w	$0007,$00FF,$800F,$0839,$0007,$00FF,$800E,$66F6
	dc.w	$33FC,$9200,$00FF,$8022,$33FC,$000A,$00FF,$8020
	dc.w	$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF,$800E
	dc.w	$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007
	dc.w	$00FF,$800F,$3839,$0001,$8D56,$2479,$0004,$7D1C
	dc.w	$508A,$6100,$B82A,$4279,$0001,$7CEA,$4279,$0001
	dc.w	$7CEE,$6100,$05A4,$247C,$0001,$834C,$6100,$01DE
	dc.w	$D4FC,$0366,$6100,$01D6,$6100,$1F72,$700B,$207C
	dc.w	$0003,$D3F6,$227C,$0001,$7480,$3229,$0034,$0829
	dc.w	$0007,$0062,$6600,$0006,$0641,$0006,$E541,$3370
	dc.w	$1000,$0000,$3370,$1002,$0014,$4269,$0028,$4269
	dc.w	$002A,$D2FC,$0080,$51C8,$FFD2,$6100,$1EA8,$33FC
	dc.w	$0018,$0001,$8D62,$33F9,$0001,$7474,$0001,$7476
	dc.w	$3F3C,$00B4,$4EB9,$0002,$BB8E,$0839,$0000,$0001
	dc.w	$7F68,$6700,$000A,$0457,$0001,$6B00,$0086,$6100
	dc.w	$A296,$0801,$0005,$6600,$000A,$0801,$0007,$6700
	dc.w	$FFD4,$3039,$0001,$8358,$B079,$0001,$86BE,$6600
	dc.w	$0062,$0839,$0007,$00FF,$800E,$66F6,$33FC,$001B
	dc.w	$00FF,$8020,$08F9,$0006,$00FF,$800F,$0839,$0006
	dc.w	$00FF,$800E,$67F6,$3039,$00FF,$8010,$08F9,$0007
	dc.w	$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839,$0006
	dc.w	$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F,$0240
	dc.w	$0001,$D179,$0001,$8358,$0A40,$0001,$D179,$0001
	dc.w	$86BE,$DEFC,$0002,$205F,$48E7,$4080,$4EB9,$0004
	dc.w	$8208,$4EB9,$0004,$7DAC,$4CDF,$0102,$3179,$0001
	dc.w	$8358,$000A,$3179,$0001,$86BE,$000C,$6100,$9A92
	dc.w	$700F,$207C,$0001,$7480,$4268,$0000,$D0FC,$0080
	dc.w	$51C8,$FFF6,$6100,$0148,$6100,$1FB8,$6100,$F172
	dc.w	$6100,$0A7A,$4EB9,$0002,$C1F8,$4EB9,$0002,$C310
	dc.w	$33FC,$0018,$0001,$8D62,$3F3C,$0079,$6100,$9F1A
	dc.w	$4CD7,$7FFF,$317C,$0004,$0008,$3028,$000A,$B068
	dc.w	$000C,$6700,$FC3A,$317C,$0005,$0008,$3601,$6100
	dc.w	$FA42,$6100,$FA60,$303C,$00B4,$6100,$A05A,$0801
	dc.w	$0007,$6600,$0016,$6100,$FB9A,$303C,$003C,$6100
	dc.w	$A046,$0801,$0007,$6700,$000A,$08F9,$0003,$0001
	dc.w	$7F6E,$4CDF,$7FFF,$4E75,$6100,$00C4,$6100,$0032
	dc.w	$6000,$FFE8,$6100,$002A,$6000,$FFE8,$4EB9,$0003
	dc.w	$C9E0,$6100,$00F8,$6100,$0336,$50EA,$0018,$08B9
	dc.w	$0007,$0001,$7F7C,$50EA,$001A,$50EA,$001C,$4E75
	dc.w	$3028,$000A,$B068,$000C,$6600,$005E,$0839,$0007
	dc.w	$00FF,$800E,$66F6,$33FC,$001B,$00FF,$8020,$08F9
	dc.w	$0006,$00FF,$800F,$0839,$0006,$00FF,$800E,$67F6
	dc.w	$3039,$00FF,$8010,$08F9,$0007,$00FF,$800F,$08B9
	dc.w	$0006,$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6
	dc.w	$08B9,$0007,$00FF,$800F,$0240,$0001,$D168,$000A
	dc.w	$0A40,$0001,$D168,$000C,$317C,$0005,$0008,$4E75
	dc.w	$303C,$0557,$227C,$0001,$7F68,$247C,$0000,$C45C
	dc.w	$34D9,$51C8,$FFFC,$34F9,$0001,$80F0,$4E75,$303C
	dc.w	$0557,$247C,$0001,$7F68,$227C,$0000,$C45C,$34D9
	dc.w	$51C8,$FFFC,$33D9,$0001,$80F0,$4E75,$0000,$FF10
	dc.w	$FFBA,$FF74,$0014,$FF92,$FF9C,$FFC4,$0019,$FFD8
	dc.w	$0046,$FFB0,$0000,$00F0,$0022,$005A,$FFC9,$0050
	dc.w	$0064,$0028,$FFF6,$000A,$FFCE,$0000,$48E7,$FCF8
	dc.w	$266A,$0022,$7805,$50EB,$0060,$50EB,$0061,$D6FC
	dc.w	$0080,$51CC,$FFF2,$6100,$0096,$7805,$287C,$0001
	dc.w	$8AC6,$4245,$1A34,$4000,$6700,$002E,$0445,$0001
	dc.w	$7605,$266A,$0022,$96FC,$0080,$D6FC,$0080,$BA2B
	dc.w	$0066,$57CB,$FFF6,$6600,$0010,$1774,$4006,$0060
	dc.w	$1745,$0061,$4234,$4000,$51CC,$FFC8,$7805,$287C
	dc.w	$0001,$8AC6,$4245,$1A34,$4000,$6700,$0038,$0445
	dc.w	$0001,$7605,$266A,$0022,$96FC,$0080,$D6FC,$0080
	dc.w	$4A2B,$0061,$5BCB,$FFF6,$6A00,$0004,$204B,$4A6B
	dc.w	$0034,$5ACB,$FFE8,$1174,$4006,$0060,$1145,$0061
	dc.w	$4234,$4000,$51CC,$FFBE,$4CDF,$1F3F,$4E75
SetPlList						;create PlList of players who we want on the ice now. a2 = team struct.
									;Takes the current line (tmline) by priolist; an unavailable
									;player (in the box or injured, -3 / -4) is replaced from sublist, or from
									;the whole roster
	dc.w	$287C,$0001,$8AC6
	dc.w	$4294
	dc.w	$426C,$0004
	dc.w	$207C,$0004,$1AD6
	dc.w	$4A6A,$0028
	dc.w	$6A00,$0006
	dc.w	$D0FC,$0001
.l224F6	dc.w	$43EA,$016C
	dc.w	$302A,$0016
	dc.w	$E740
	dc.w	$D2C0
	dc.w	$382A,$0026
	dc.w	$6000,$0020
.l2250A	dc.w	$4245
	dc.w	$1A30,$4000
	dc.w	$19B1,$5000,$4000
	dc.w	$1985,$4006
	dc.w	$6600,$000C
	dc.w	$7601
	dc.w	$D66A,$0028
	dc.w	$1983,$4000
.l22528	dc.w	$51CC,$FFE0
	dc.w	$7805
.l2252E	dc.w	$1634,$4000
	dc.w	$6700,$0050
	dc.w	$4883
	dc.w	$0443,$0001
	dc.w	$D643
	dc.w	$0C72,$FFFD,$3068
	dc.w	$6700,$0014
	dc.w	$0C72,$FFFC,$3068
	dc.w	$6700,$000A
	dc.w	$4A72,$3068
	dc.w	$6F00,$002C
.l2255A	dc.w	$43EA,$016C
	dc.w	$1034,$4006
	dc.w	$4880
	dc.w	$E340
	dc.w	$207C,$0004,$1A6C
	dc.w	$D0F0,$0000
.l22570	dc.w	$4240
	dc.w	$1018
	dc.w	$6B00,$0014
	dc.w	$1031,$0000
	dc.w	$6100,$002A
	dc.w	$6700,$FFEE
.l22584	dc.w	$51CC,$FFA8
	dc.w	$4E75
.l2258A	dc.w	$4EB9,$0002,$EDBC
	dc.w	$3600
.l22592	dc.w	$3003
	dc.w	$0443,$0001
	dc.w	$6B00,$FFEA
	dc.w	$6100,$000A
	dc.w	$6700,$FFF0
	dc.w	$6000,$FFDE
TryAddPlayerToList						;d0 = player number (1 based), d4 = PlList slot. Put d0 in the slot if he
									;is on the bench or ice (not in the box, not injured) and not in PlList
									;yet; return d1 = 0 (Z set) if not
	dc.w	$3200
	dc.w	$0440,$0001
	dc.w	$D040
	dc.w	$4A72,$0068
	dc.w	$6E00,$002A
	dc.w	$0C72,$FFFD,$0068
	dc.w	$6700,$0020
	dc.w	$0C72,$FFFC,$0068
	dc.w	$6700,$0016
	dc.w	$7005
.l225CE	dc.w	$B234,$0000
	dc.w	$57C8,$FFFA
	dc.w	$6700,$0008
	dc.w	$1981,$4000
	dc.w	$4E75
.l225E0	dc.w	$4241
	dc.w	$4E75
SetupPenaltyShot						;Penalty shot set up for team a2 (called from puckpenshot): the shooter
									;loop over the team: shooter plays center, goalie stays, others leave
	dc.w	$48E7,$FCF0
	dc.w	$266A,$0022
	dc.w	$7805
.l225EE	dc.w	$302B,$0052
	dc.w	$B079,$0001,$9368
	dc.w	$6700,$001E
	dc.w	$B079,$0001,$936A
	dc.w	$6700,$0032
	dc.w	$08EB,$0002,$0063
	dc.w	$303C,$0020
	dc.w	$6100,$8CD2
	dc.w	$6000,$003C
.l22618	dc.w	$6100,$013A
	dc.w	$13EB,$0061,$0001,$7F9C
	dc.w	$1779,$0001,$936D,$0061
	dc.w	$377C,$0004,$0034
	dc.w	$6000,$000A
.l22636	dc.w	$6100,$011C
	dc.w	$426B,$0034
.l2263E	dc.w	$4243
	dc.w	$162B,$0061
	dc.w	$D643
	dc.w	$35BC,$FFFF,$3068
	dc.w	$E24B
	dc.w	$6100,$0120
.l22652	dc.w	$50EB,$0061
	dc.w	$50EB,$0060
	dc.w	$D6FC,$0080
	dc.w	$51CC,$FF8E
	dc.w	$4CDF,$0F3F
	dc.w	$4E75
forcepldata						;no skating on/off: force players to correct data (for faceoffs only). a2
									;= team struct
	dc.w	$48E7,$F8F0
	dc.w	$266A,$0022
	dc.w	$7805
.l22672	dc.w	$102B,$0060
	dc.w	$4880
	dc.w	$4A6B,$0034
	dc.w	$6600,$001C
	dc.w	$4A40
	dc.w	$6700,$0016
	dc.w	$3F2B,$0052
	dc.w	$377C,$000F,$0052
	dc.w	$4EB9,$0002,$2DDE
	dc.w	$375F,$0052
.l2269A	dc.w	$3740,$0034
	dc.w	$6B00,$002A
	dc.w	$6100,$00B0
	dc.w	$0C6B,$0004,$0034
	dc.w	$6600,$0008
	dc.w	$7011
	dc.w	$6100,$8C24
.l226B6	dc.w	$4243
	dc.w	$162B,$0061
	dc.w	$D643
	dc.w	$35BC,$FFFF,$3068
	dc.w	$E24B
	dc.w	$6100,$00A8
.l226CA	dc.w	$50EB,$0061
	dc.w	$50EB,$0060
	dc.w	$D7FC,$0000,$0080
	dc.w	$51CC,$FF98
	dc.w	$4CDF,$0F1F
	dc.w	$4E75
ResetBench						;remove all players from penalty box / put all players on their own bench
									;(not the injured, -3 / -4). Counts the players left in the box in PBnum
									;(home in the high nibble). .rb runs for the home team, then falls in for
									;the visitors
	dc.w	$4239,$0001,$8068
	dc.w	$7210
	dc.w	$207C,$0001,$834C
	dc.w	$6100,$0008
	dc.w	$7201
	dc.w	$D0FC,$0366
.l226FA	dc.w	$7032
.l226FC	dc.w	$D339,$0001,$8068
	dc.w	$4A70,$0068
	dc.w	$6F00,$0022
	dc.w	$0830,$0004,$0068
	dc.w	$6700,$0038
	dc.w	$3430,$0068
	dc.w	$0242,$07FF
	dc.w	$6600,$002C
	dc.w	$9339,$0001,$8068
	dc.w	$6000,$0022
.l2272A	dc.w	$9339,$0001,$8068
	dc.w	$0C70,$FFFD,$0068
	dc.w	$6700,$0012
	dc.w	$0C70,$FFFC,$0068
	dc.w	$6700,$0008
	dc.w	$31BC,$FFFE,$0068
.l2274A	dc.w	$0440,$0002
	dc.w	$6A00,$FFAC
	dc.w	$4E75
Setplass						;set players (a3) initial assignment from .alist by position
	dc.w	$302B,$0034		;assgoalie
	dc.w	$6B00,$E8A6		;assdefd
	dc.w	$41FA,$000A		;assdefd
	dc.w	$1030,$0000		;asswingd
	dc.w	$6000,$8B7E		;asscenterd
	dc.w	$0E02		;asswingd
setplayer						;bring player onto the ice and set his attributes. d3 = offset of player
									;on roster, a3 = sortcord of player. Reads the roster bytes through
									;AttributeCalc (attribute number in TempWord2). Adds the PP / PK, home /
									;away and third period bonuses (team ScoutReport bytes) to some attributes
									;and clamps them with ClampNibble
	dc.w	$0203,$0503
	dc.w	$0500
	dc.w	$08AB,$0006,$0063
	dc.w	$207C,$0001,$834C
	dc.w	$082B,$0006,$0062
	dc.w	$6700,$0006
	dc.w	$D0FC,$0366
.l2278A	dc.w	$1743,$0066
	dc.w	$700A
	dc.w	$4883
	dc.w	$D643
	dc.w	$3230,$3068
	dc.w	$6A00,$000C
	dc.w	$7009
	dc.w	$0C41,$FFFE
	dc.w	$6600,$0010
.l227A6	dc.w	$6100,$8B30
	dc.w	$08AB,$0005,$0062
	dc.w	$426B,$0058
.l227B4	dc.w	$31BC,$FFFF,$3068
	dc.w	$E24B
	dc.w	$2068,$001E
	dc.w	$2F08
	dc.w	$D0E8,$0008
	dc.w	$42B9,$0001,$8AE0
	dc.w	$4A6B,$0034
	dc.w	$6700,$00A6
	dc.w	$0839,$0005,$0001,$7F6C
	dc.w	$6700,$002E
	dc.w	$4EB9,$0003,$38C8
	dc.w	$6700,$0016
	dc.w	$13E8,$0001,$0001,$8AE0
	dc.w	$0239,$000F,$0001,$8AE0
	dc.w	$6000,$0010
.l227FE	dc.w	$1028,$0001
	dc.w	$E808
	dc.w	$4400
	dc.w	$13C0,$0001,$8AE1
.l2280C	dc.w	$1028,$0002
	dc.w	$0200,$000F
	dc.w	$4400
	dc.w	$082B,$0006,$0062
	dc.w	$6600,$0008
	dc.w	$1028,$0002
	dc.w	$E808
.l22826	dc.w	$13C0,$0001,$8AE3
	dc.w	$0C79,$0002,$0001,$80E4
	dc.w	$6D00,$0042
	dc.w	$6E00,$0014
	dc.w	$4EB9,$0002,$BA04
	dc.w	$E248
	dc.w	$B079,$0001,$80E6
	dc.w	$6E00,$002C
.l2284E	dc.w	$3039,$0001,$8358
	dc.w	$9079,$0001,$86BE
	dc.w	$6700,$0014
	dc.w	$082B,$0006,$0062
	dc.w	$6700,$0006
	dc.w	$0A3C,$0008
.l2286C	dc.w	$6A00,$000A
.l22870	dc.w	$13FC,$0002,$0001,$8AE2
.l22878	dc.w	$205F
	dc.w	$D0E8,$0000
.l2287E	dc.w	$D0D0
	dc.w	$D0FC,$0008
	dc.w	$51CB,$FFF8
	dc.w	$90FC,$0008
	dc.w	$1750,$006F
	dc.w	$1628,$0001
	dc.w	$0243,$00F0
	dc.w	$E24B
	dc.w	$1743,$0067
	dc.w	$1628,$0001
	dc.w	$0203,$000F
	dc.w	$33FC,$0003,$0001,$7E64
	dc.w	$4EB9,$0002,$30D0
	dc.w	$1743,$0068
	dc.w	$1628,$0002
	dc.w	$E80B
	dc.w	$33FC,$0004,$0001,$7E64
	dc.w	$4EB9,$0002,$30D0
	dc.w	$1743,$0069
	dc.w	$1628,$0002
	dc.w	$0203,$000F
	dc.w	$33FC,$0005,$0001,$7E64
	dc.w	$4EB9,$0002,$30D0
	dc.w	$D639,$0001,$8AE0
	dc.w	$D639,$0001,$8AE1
	dc.w	$D639,$0001,$8AE3
	dc.w	$D639,$0001,$8AE2
	dc.w	$6100,$01A2
	dc.w	$E20B
	dc.w	$0A03,$000F
	dc.w	$0603,$000F
	dc.w	$E20B
	dc.w	$1743,$006A
	dc.w	$1628,$0003
	dc.w	$E80B
	dc.w	$33FC,$0006,$0001,$7E64
	dc.w	$4EB9,$0002,$30D0
	dc.w	$D639,$0001,$8AE3
	dc.w	$6100,$0174
	dc.w	$E20B
	dc.w	$0A03,$000F
	dc.w	$0603,$000F
	dc.w	$E20B
	dc.w	$1743,$006B
	dc.w	$1768,$0003,$006C
	dc.w	$022B,$000F,$006C
	dc.w	$162B,$006C
	dc.w	$33FC,$0007,$0001,$7E64
	dc.w	$4EB9,$0002,$30D0
	dc.w	$1743,$006C
	dc.w	$1628,$0004
	dc.w	$E80B
	dc.w	$33FC,$0008,$0001,$7E64
	dc.w	$4EB9,$0002,$30D0
	dc.w	$D639,$0001,$8AE2
	dc.w	$6100,$0124
	dc.w	$1743,$0075
	dc.w	$08AB,$0003,$0004
	dc.w	$1768,$0004,$0076
	dc.w	$022B,$0001,$0076
	dc.w	$0A2B,$0001,$0076
	dc.w	$6600,$0008
	dc.w	$08EB,$0003,$0004
.l229A6	dc.w	$1768,$0004,$0074
	dc.w	$022B,$000E,$0074
	dc.w	$1628,$0005
	dc.w	$E80B
	dc.w	$33FC,$000A,$0001,$7E64
	dc.w	$4EB9,$0002,$30D0
	dc.w	$D639,$0001,$8AE0
	dc.w	$D639,$0001,$8AE1
	dc.w	$D639,$0001,$8AE3
	dc.w	$6100,$00C8
	dc.w	$1743,$0071
	dc.w	$1628,$0005
	dc.w	$0203,$000F
	dc.w	$33FC,$000B,$0001,$7E64
	dc.w	$4EB9,$0002,$30D0
	dc.w	$D639,$0001,$8AE0
	dc.w	$D639,$0001,$8AE1
	dc.w	$D639,$0001,$8AE3
	dc.w	$6100,$0098
	dc.w	$1743,$006D
	dc.w	$1628,$0006
	dc.w	$E80B
	dc.w	$33FC,$000C,$0001,$7E64
	dc.w	$4EB9,$0002,$30D0
	dc.w	$1743,$0072
	dc.w	$1628,$0006
	dc.w	$0203,$000F
	dc.w	$33FC,$000D,$0001,$7E64
	dc.w	$4EB9,$0002,$30D0
	dc.w	$D639,$0001,$8AE2
	dc.w	$D639,$0001,$8AE2
	dc.w	$6100,$0056
	dc.w	$1743,$0070
	dc.w	$1628,$0007
	dc.w	$E80B
	dc.w	$33FC,$000E,$0001,$7E64
	dc.w	$4EB9,$0002,$30D0
	dc.w	$D639,$0001,$8AE0
	dc.w	$D639,$0001,$8AE3
	dc.w	$6100,$002E
	dc.w	$1743,$006E
	dc.w	$1768,$0007,$0073
	dc.w	$162B,$0073
	dc.w	$0203,$000F
	dc.w	$33FC,$000F,$0001,$7E64
	dc.w	$4EB9,$0002,$30D0
	dc.w	$1743,$0073
	dc.w	$022B,$000F,$0073
	dc.w	$4E75
.l22AA2	dc.w	$4A03
	dc.w	$6A00,$0004
	dc.w	$4243
.l22AAA	dc.w	$0C03,$001E
	dc.w	$6F00,$0006
	dc.w	$363C,$001E
.l22AB6	dc.w	$4E75
	dc.w	$48E7,$FFFE
	dc.w	$0839,$0002,$0001,$8D64
	dc.w	$6600,$0016
	dc.w	$08B9,$0000,$0001,$8D64
	dc.w	$6700,$0006
	dc.w	$6100,$00DA
.l22AD8	dc.w	$6100,$931C
.l22ADC	dc.w	$0839,$0000,$0001,$7F6A
	dc.w	$6600,$006A
	dc.w	$0839,$0002,$0001,$7F78
	dc.w	$6600,$000E
	dc.w	$0839,$0000,$0001,$7F68
	dc.w	$6600,$0052
.l22B00	dc.w	$0839,$0001,$0001,$7F78
	dc.w	$6600,$0052
	dc.w	$4A79,$0001,$80E6
	dc.w	$6700,$003C
	dc.w	$0479,$0AAA,$0001,$80E8
	dc.w	$6400,$0030
	dc.w	$08F9,$0003,$0001,$8D64
	dc.w	$5379,$0001,$80E6
	dc.w	$0C79,$003D,$0001,$80E6
	dc.w	$6E00,$0016
	dc.w	$0C79,$003C,$0001,$80E6
	dc.w	$6D00,$000A
	dc.w	$3F3C,$0002
	dc.w	$6100,$9626
.l22B50	dc.w	$5279,$0001,$7474
	dc.w	$4CDF,$7FFF
	dc.w	$4E75
.l22B5C	dc.w	$4A79,$0001,$93B6
	dc.w	$6700,$FFEC
	dc.w	$0479,$0AAA,$0001,$93B8
	dc.w	$6400,$FFE0
	dc.w	$08F9,$0003,$0001,$8D64
	dc.w	$0839,$0007,$0001,$7F78
	dc.w	$6600,$FFCC
	dc.w	$5379,$0001,$93B6
	dc.w	$6000,$FFC2
	dc.w	$48E7,$FFFE
	dc.w	$0839,$0002,$0001,$8D64
	dc.w	$6600,$0006
	dc.w	$6100,$9254
.l22BA4	dc.w	$5279,$0001,$7474
	dc.w	$4CDF,$7FFF
	dc.w	$4E75
