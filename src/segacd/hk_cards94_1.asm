	include	segacd\hockey.inc
	include	macros\genesis.mac

AppendTeamName	equ	$260E0
AppendUserName	equ	$25DE8
CC_Font1	equ	$FF
CC_Font1Pri	equ	$BF
CopyString	equ	$25818
LOAD	equ	$1B000
M68K_RAM	equ	$C45C
RecByTxt	equ	$2595C
RecSpaceTxt	equ	$25A4A
RecVsTxt	equ	$25994
TeamList	equ	$1B00C
TempBuffer	equ	$17E70
appstring	equ	$39208
move	equ	$2C9C8
sflags6	equ	$17F76
swap	equ	$2779A
X_7534	equ	$7534

	org	$9C1E

PlayerCardScreen						;Draw a player card on one side. setupcardflags bit 1 set: visitors, logo
									;box and picture on the left (column 3), text frame at $B; clear: home,
									;logo box and picture on the right ($1C), text frame at 3. Shows featured
									;player featuredplayer (0-5, from the FeaturedPictures list of the team;
									;next one after each visitors card), his number and name, and with SRAM
									;his user records (PrintRecordValue, PrintRecordHolder, PrintRecordVs).
									;Called from PlayerCardTimer
	dc.w	$48E7,$FFFE
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1,$0,$0
	dc.w	$33FC,$001C,$0001,$8D58
	dc.w	$0839,$0001,$0001,$9390
	dc.w	$6600,$000A
	dc.w	$33FC,$0003,$0001,$8D58
.l9C4A	dc.w	$33FC,$0005,$0001,$8D5A
	dc.w	$303C,$0008
	dc.w	$323C,$0008
	dc.w	$343C,$07FF
	dc.w	$4EB9,$0003,$8C06
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1,$0,$0
	dc.w	$33FC,$0003,$0001,$8D58
	dc.w	$0839,$0001,$0001,$9390
	dc.w	$6600,$000A
	dc.w	$33FC,$000B,$0001,$8D58
.l9C8C	dc.w	$33FC,$0005,$0001,$8D5A
	dc.w	$303C,$0019
	dc.w	$323C,$0008
	dc.w	$343C,$07FF
	dc.w	$4EB9,$0003,$8C06
	dc.w	$0839,$0001,$0001,$9390
	dc.w	$6600,$000A
	dc.w	$6100,$FE22
	dc.w	$6000,$000E
.l9CBA	dc.w	$6100,$FE3E
	dc.w	$0679,$0001,$0001,$93A0
.l9CC6	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1,$0,$0
	dc.w	$0C79,$0006,$0001,$93A0
	dc.w	$6D00,$0008
	dc.w	$4279,$0001,$93A0
.l9CE4	dc.w	$3039,$0001,$7FAE
	dc.w	$33FC,$001D,$0001,$8D58
	dc.w	$0839,$0001,$0001,$9390
	dc.w	$6700,$0010
	dc.w	$3039,$0001,$7FB0
	dc.w	$33FC,$0004,$0001,$8D58
.l9D0C	dc.w	$33FC,$0006,$0001,$8D5A
	dc.w	$3839,$0001,$9392
	dc.w	$3639,$0001,$93A0
	dc.w	$C6FC,$0006
	dc.w	$E540
	dc.w	$2079,$0004,$7D88
	dc.w	$2070,$0000
	dc.w	$33F0,$3004,$0001,$9396
	dc.w	$2070,$3000
	dc.w	$2248
	dc.w	$2448
	dc.w	$D1DA
	dc.w	$207C,$0004,$28A0
	dc.w	$D1D0
	dc.w	$4A92
	dc.w	$6600,$0012
	dc.w	$227C,$0004,$28A0
	dc.w	$D3E9,$0004
	dc.w	$4A9A
	dc.w	$6000,$0004
.l9D60	dc.w	$D3DA
.l9D62	dc.w	$6100,$5B9E
	dc.w	$247C,$0001,$A8C0
	dc.w	$3639,$0001,$7474
.l9D72	dc.w	$B679,$0001,$7474
	dc.w	$6700,$FFF8
	dc.w	$363C,$0006
	dc.w	$343C,$0006
	dc.w	$4240
	dc.w	$4241
	dc.w	$2F39,$000B,$BCD2
	dc.w	$2F39,$000B,$BCD6
	dc.w	$3A3C,$0002
	dc.w	$4EB9,$0003,$87E2
	dc.w	$23DF,$000B,$BCD6
	dc.w	$23DF,$000B,$BCD2
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1Pri,$0,$0
	dc.w	$33FC,$6000,$0001,$8D5C
	dc.w	$33FC,$0003,$0001,$8D58
	dc.w	$303C,$0019
	dc.w	$0839,$0001,$0001,$9390
	dc.w	$6700,$000E
	dc.w	$33FC,$000B,$0001,$8D58
	dc.w	$303C,$0019
.l9DE2	dc.w	$33FC,$0005,$0001,$8D5A
	dc.w	$323C,$0008
	dc.w	$33F9,$0001,$8D58,$0001,$93A4
	dc.w	$0679,$0001,$0001,$93A4
	dc.w	$33F9,$0001,$8D5A,$0001,$93A6
	dc.w	$0679,$0001,$0001,$93A6
	dc.w	$4EB9,$0003,$8CA0
	dc.w	$33F9,$0001,$93A4,$0001,$8D58
	dc.w	$33F9,$0001,$93A6,$0001,$8D5A
	dc.w	$33FC,$0000,$0001,$8D5C
	dc.w	$33FC,$0000,$0001,$8D5E
	dc.w	$3039,$0001,$7FAE
	dc.w	$0839,$0001,$0001,$9390
	dc.w	$6700,$0008
	dc.w	$3039,$0001,$7FB0
.l9E54	dc.w	$33C0,$0001,$93A8
	dc.w	$247C,$0001,$B00C
	dc.w	$E540
	dc.w	$2472,$0000
	dc.w	$D4EA,$0000
	dc.w	$3039,$0001,$9396
	dc.w	$6000,$0008
.l9E74	dc.w	$D4D2
	dc.w	$D4FC,$0008
.l9E7A	dc.w	$51C8,$FFF8
	dc.w	$267C,$0001,$7EF2
	dc.w	$43EB,$0002
	dc.w	$36BC,$0006
	dc.w	$2F0A
	dc.w	$D4D2
	dc.w	$1012
	dc.w	$4880
	dc.w	$4EB9,$0004,$12A8
	dc.w	$377C,$2000,$0004
	dc.w	$225F
	dc.w	$4EB9,$0003,$9208
	dc.w	$224B
	dc.w	$08F9,$0003,$0001,$7F76
	dc.w	$4EB9,$0003,$8D9E
	dc.w	$08B9,$0003,$0001,$7F76
	dc.w	$227C,$0001,$7EF2
	dc.w	$3039,$0001,$93A8
	dc.w	$3239,$0001,$9396
	dc.w	$4A79,$0001,$93BA
	dc.w	$6B00,$00CC
	dc.w	$4EB9,$0002,$5760
	dc.w	$0C51,$0002
	dc.w	$6700,$00BE
	dc.w	$33F9,$0001,$93A4,$0001,$8D58
	dc.w	$0679,$0002,$0001,$8D5A
	dc.w	$08F9,$0003,$0001,$7F76
	dc.w	$4EB9,$0003,$8D9E
	dc.w	$08B9,$0003,$0001,$7F76
	dc.w	$227C,$0001,$7EF2
	dc.w	$3039,$0001,$93A8
	dc.w	$3239,$0001,$9396
	dc.w	$207C,$0000,$C45C
	dc.w	$4EB9,$0002,$591A
	dc.w	$33F9,$0001,$93A4,$0001,$8D58
	dc.w	$0C51,$0002
	dc.w	$6700,$0020
	dc.w	$0679,$0001,$0001,$8D5A
	dc.w	$08F9,$0003,$0001,$7F76
	dc.w	$4EB9,$0003,$8D9E
	dc.w	$08B9,$0003,$0001,$7F76
.l9F60	dc.w	$227C,$0001,$7EF2
	dc.w	$3039,$0001,$93A8
	dc.w	$3239,$0001,$9396
	dc.w	$207C,$0000,$C45C
	dc.w	$4EB9,$0002,$5962
	dc.w	$33F9,$0001,$93A4,$0001,$8D58
	dc.w	$0679,$0001,$0001,$8D5A
	dc.w	$08F9,$0003,$0001,$7F76
	dc.w	$4EB9,$0003,$8D9E
	dc.w	$08B9,$0003,$0001,$7F76
.l9FA6	dc.w	$33FC,$0064,$0001,$8D62
	dc.w	$4CDF,$7FFF
	dc.w	$4E75
	dc.w	$4A6A,$0034
	dc.w	$6700,$0044
	dc.w	$48E7,$FF00
	dc.w	$342A,$0000
	dc.w	$362A,$0014
	dc.w	$33EA,$004A,$0001,$7CF4
	dc.w	$0679,$0017,$0001,$7CF4
	dc.w	$33EA,$004C,$0001,$7CF6
	dc.w	$0679,$0017,$0001,$7CF6
	dc.w	$48E7,$00FE
	dc.w	$C54B
	dc.w	$4EB9,$0002,$2FBE
	dc.w	$C54B
	dc.w	$4CDF,$7F00
	dc.w	$4CDF,$00FF
.l9FFE	dc.w	$4E75
	dc.w	$08B9,$0005,$0001,$7F76
	dc.w	$4A79,$0001,$7BE0
	dc.w	$6B00,$004E
	dc.w	$48E7,$8080
	dc.w	$207C,$0001,$7480
	dc.w	$3039,$0001,$7BE0
	dc.w	$EF40
	dc.w	$D0C0
	dc.w	$3028,$0014
	dc.w	$0828,$0007,$0062
	dc.w	$6600,$0004
	dc.w	$4440
.lA036	dc.w	$0C40,$0058
	dc.w	$6D00,$001E
	dc.w	$0C68,$0047,$0000
	dc.w	$6E00,$0014
	dc.w	$0C68,$FFB9,$0000
	dc.w	$6D00,$000A
	dc.w	$08F9,$0005,$0001,$7F76
.lA05A	dc.w	$4CDF,$0101
.lA05E	dc.w	$4E75
	dc.w	$EEA
	dc.w	$0000,$0042
	dc.w	$0EEA
	dc.w	$0EEA
	dc.w	$EEE
	dc.l	$888
	dc.w	$0AAA,$0068,$008A,$00CE
	dc.w	$0260,$0040
	dc.w	$0664,$0E8E
	dc.w	$0EEA
	dc.w	$0EEA
	dc.w	$EEA
	dc.w	$0000,$0042
	dc.w	$EEE
	dc.l	$888
	dc.w	$0AAA,$0068,$008A,$00CE
	dc.w	$0260,$0040
	dc.w	$0664,$0E8E
	dc.w	$EE8
	dc.w	$0000,$008C
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EEE
	dc.l	$C8C
	dc.w	$008C
	dc.w	$0888
	dc.w	$0068,$0846,$0044
	dc.w	$0422,$08CE
	dc.w	$02AE,$0EE8,$0EE8,$0EE8
	dc.w	$0000,$008C
	dc.w	$EEE
	dc.l	$C8C
	dc.w	$008C
	dc.w	$0888
	dc.w	$0068,$0846,$0044
	dc.w	$0422,$08CE
	dc.w	$02AE,$0EE8,$0822,$008C
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EEE
	dc.l	$EC8
	dc.w	$048C
	dc.w	$0C88
	dc.w	$006C,$0866,$0268
	dc.w	$0224,$0620
	dc.w	$00CE
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0822,$008C
	dc.w	$EEE
	dc.l	$EC8
	dc.w	$048C
	dc.w	$0C88
	dc.w	$006C,$0866,$0268
	dc.w	$0224,$0620
	dc.w	$00CE
	dc.w	$EE8
	dc.w	$0006,$008C
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EEE
	dc.l	$8EE
	dc.w	$02CE
	dc.w	$02AE,$026E,$000C,$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EE8
	dc.w	$0006,$008C
	dc.w	$EEE
	dc.l	$8EE
	dc.w	$02CE
	dc.w	$02AE,$026E,$000C,$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EE8
	dc.w	$0000,$0006
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EEE
	dc.l	$8EE
	dc.w	$0A8E
	dc.w	$04AC,$0A88,$046C,$0226
	dc.w	$0644,$022E
	dc.w	$0262,$0EE8
	dc.w	$0EE8
	dc.w	$EE8
	dc.w	$0000,$0006
	dc.w	$EEE
	dc.l	$8EE
	dc.w	$0A8E
	dc.w	$04AC,$0A88,$046C,$0226
	dc.w	$0644,$022E
	dc.w	$0262,$0EE8
	dc.w	$0000,$0042
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EEE
	dc.l	$8AA
	dc.w	$0688
	dc.w	$0488
	dc.w	$0466,$0244
	dc.w	$0260,$0020
	dc.w	$0ACC
	dc.l	$EE8
	dc.w	$0EE8
	dc.w	$EE8
	dc.w	$0000,$0042
	dc.w	$EEE
	dc.l	$8AA
	dc.w	$0688
	dc.w	$0488
	dc.w	$0466,$0244
	dc.w	$0260,$0020
	dc.w	$0ACC
	dc.l	$EE8
	dc.w	$0006,$0006
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EEE
	dc.l	$C8E
	dc.w	$086E
	dc.w	$044E
	dc.w	$082E
	dc.w	$020E
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EE8
	dc.w	$0006,$0006
	dc.w	$EEE
	dc.l	$C8E
	dc.w	$086E
	dc.w	$044E
	dc.w	$082E
	dc.w	$020E
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0600,$004A
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EEE
	dc.l	$CEA
	dc.w	$0A8E
	dc.w	$08A8
	dc.w	$044E
	dc.w	$0488
	dc.w	$002E,$0440,$0400
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0600,$004A
	dc.w	$EEE
	dc.l	$CEA
	dc.w	$0A8E
	dc.w	$08A8
	dc.w	$044E
	dc.w	$0488
	dc.w	$002E,$0440,$0400
	dc.w	$0EE8
	dc.w	$0EEA
	dc.w	$004A
	dc.w	$0600,$0EEA
	dc.w	$0EEA
	dc.w	$EEE
	dc.w	$0000,$000A
	dc.w	$0004,$0046
	dc.w	$008E
	dc.w	$0CEE
	dc.w	$0466,$0442
	dc.w	$0EC6
	dc.w	$0200,$0EEA
	dc.w	$0EEA
	dc.w	$0EEA
	dc.w	$004A
	dc.w	$0600,$0EEE
	dc.w	$0000,$000A
	dc.w	$0004,$0046
	dc.w	$008E
	dc.w	$0CEE
	dc.w	$0466,$0442
	dc.w	$0EC6
	dc.w	$0200,$0EE8
	dc.w	$0042,$0822
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EEE
	dc.w	$0000,$00E8
	dc.w	$04C4
	dc.w	$0A8A
	dc.w	$00A2,$0466,$0600
	dc.w	$0224,$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EE8
	dc.w	$0042,$0822
	dc.w	$EEE
	dc.w	$0000,$00E8
	dc.w	$04C4
	dc.w	$0A8A
	dc.w	$00A2,$0466,$0600
	dc.w	$0224,$0EE8
	dc.w	$0EE8
	dc.w	$EE8
	dc.w	$0000,$0000
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EEE
	dc.l	$AAA
	dc.w	$0888
	dc.w	$0666,$0444
	dc.w	$0222,$0CCC
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EE8
	dc.w	$0000,$0000
	dc.w	$EEE
	dc.l	$AAA
	dc.w	$0888
	dc.w	$0666,$0444
	dc.w	$0222,$0CCC
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0600,$0006
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EEE
	dc.l	$88E
	dc.w	$026E,$0C68,$002E
	dc.w	$0A24,$0EAA
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0600,$0006
	dc.w	$EEE
	dc.l	$88E
	dc.w	$026E,$0C68,$002E
	dc.w	$0A24,$0EAA
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0020,$0006
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EEE
	dc.l	$AAA
	dc.w	$000A
	dc.w	$0888
	dc.w	$000C
	dc.w	$0022,$0006
	dc.w	$0CCC
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0020,$0006
	dc.w	$EEE
	dc.l	$AAA
	dc.w	$000A
	dc.w	$0888
	dc.w	$000C
	dc.w	$0022,$0006
	dc.w	$0CCC
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0822,$004A
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EEE
	dc.l	$AA8
	dc.w	$066E,$0864,$022C
	dc.w	$062A,$0008,$0622
	dc.w	$0222,$0A8E
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0822,$004A
	dc.w	$EEE
	dc.l	$AA8
	dc.w	$066E,$0864,$022C
	dc.w	$062A,$0008,$0622
	dc.w	$0222,$0A8E
	dc.w	$0EE8
	dc.w	$0600,$0006
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EEE
	dc.l	$AAA
	dc.w	$0C86,$002E,$0C60
	dc.w	$0844
	dc.w	$0444,$0840
	dc.w	$0008
	dc.w	$0EC8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0600,$0006
	dc.w	$EEE
	dc.l	$AAA
	dc.w	$0C86,$002E,$0C60
	dc.w	$0844
	dc.w	$0444,$0840
	dc.w	$0008
	dc.w	$0EC8
	dc.w	$EE8
	dc.w	$0006,$006A
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EEE
	dc.l	$68A
	dc.w	$0688
	dc.w	$0466,$0244
	dc.w	$022C,$0228,$0008
	dc.w	$0AAA,$0004,$0EE8,$0EE8
	dc.w	$EE8
	dc.w	$0006,$006A
	dc.w	$EEE
	dc.l	$68A
	dc.w	$0688
	dc.w	$0466,$0244
	dc.w	$022C,$0228,$0008
	dc.w	$0AAA,$0004,$0EE8,$0000
	dc.w	$004A
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EEE
	dc.l	$CCC
	dc.w	$088E
	dc.w	$0AAA,$046E,$006E,$0888
	dc.w	$0666,$002E
	dc.w	$0444,$0EE8
	dc.w	$0EE8
	dc.w	$EE8
	dc.w	$0000,$004A
	dc.w	$EEE
	dc.l	$CCC
	dc.w	$088E
	dc.w	$0AAA,$046E,$006E,$0888
	dc.w	$0666,$002E
	dc.w	$0444,$0EE8
	dc.w	$0000,$008C
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EEE
	dc.l	$AAA
	dc.w	$088A
	dc.w	$066A,$04EE,$0464
	dc.w	$0440,$02CE
	dc.w	$0244,$0AEE
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EE8
	dc.w	$0000,$008C
	dc.w	$EEE
	dc.l	$AAA
	dc.w	$088A
	dc.w	$066A,$04EE,$0464
	dc.w	$0440,$02CE
	dc.w	$0244,$0AEE
	dc.w	$0EE8
	dc.w	$0600,$0006
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EEE
	dc.l	$C00
	dc.w	$000E
	dc.w	$0E44
	dc.w	$0ECE
	dc.w	$0E80
	dc.w	$088E
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0600,$0006
	dc.w	$EEE
	dc.l	$C00
	dc.w	$000E
	dc.w	$0E44
	dc.w	$0ECE
	dc.w	$0E80
	dc.w	$088E
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EE8
	dc.l	$860
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EEE
	dc.l	$860
	dc.w	$0642,$0888
	dc.w	$0CA8,$0ACC,$02AE,$006E
	dc.w	$0048
	dc.w	$046A,$0EE8,$0EE8
	dc.w	$EE8
	dc.l	$860
	dc.w	$EEE
	dc.l	$860
	dc.w	$0642,$0888
	dc.w	$0CA8,$0ACC,$02AE,$006E
	dc.w	$0048
	dc.w	$046A,$0EE8,$0822
	dc.w	$006A,$0EE8,$0EE8
	dc.w	$EEE
	dc.l	$602
	dc.w	$024C
	dc.w	$0002,$0026
	dc.w	$0068,$0428,$086E
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0822,$006A
	dc.w	$EEE
	dc.l	$602
	dc.w	$024C
	dc.w	$0002,$0026
	dc.w	$0068,$0428,$086E
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EE8
	dc.l	$600
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EEE
	dc.l	$C86
	dc.w	$0E84
	dc.w	$0A84,$0C44,$0822
	dc.w	$0E20
	dc.w	$0600,$0A00
	dc.w	$0EA8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EE8
	dc.l	$600
	dc.w	$EEE
	dc.l	$C86
	dc.w	$0E84
	dc.w	$0A84,$0C44,$0822
	dc.w	$0E20
	dc.w	$0600,$0A00
	dc.w	$0EA8
	dc.w	$0EE8
	dc.w	$0600,$0600
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EEE
	dc.l	$ECA
	dc.w	$0AAA,$0C66,$0822,$0CCC
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0600,$0600
	dc.w	$EEE
	dc.l	$ECA
	dc.w	$0AAA,$0C66,$0822,$0CCC
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EE8
	dc.w	$0000,$008C
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EEE
	dc.w	$0000,$00CE
	dc.w	$006A,$004E,$0028
	dc.w	$0022,$0020
	dc.w	$008E
	dc.w	$0888
	dc.w	$6CE
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EE8
	dc.w	$0000,$008C
	dc.w	$EEE
	dc.w	$0000,$00CE
	dc.w	$006A,$004E,$0028
	dc.w	$0022,$0020
	dc.w	$008E
	dc.w	$0888
	dc.w	$6CE
	dc.w	$EE8
	dc.w	$0006,$0600
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EEE
	dc.l	$22C
	dc.w	$0C86,$0EA8,$088E
	dc.w	$0842
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EE8
	dc.w	$0006,$0600
	dc.w	$EEE
	dc.l	$22C
	dc.w	$0C86,$0EA8,$088E
	dc.w	$0842
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0600,$0006
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EEE
	dc.l	$22C
	dc.w	$0422,$0AAC
	dc.w	$0666,$0CAA
	dc.w	$0444,$066E
	dc.w	$08CE
	dc.w	$0226,$0EE8
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$0600,$0006
	dc.w	$EEE
	dc.l	$22C
	dc.w	$0422,$0AAC
	dc.w	$0666,$0CAA
	dc.w	$0444,$066E
	dc.w	$08CE
	dc.w	$0226,$0EE8
	dc.w	$0000,$004A
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EEE
	dc.l	$688
	dc.w	$0464,$0244
	dc.w	$0222,$004E
	dc.w	$000A
	dc.w	$0022,$0AAA
	dc.l	$EE8
	dc.w	$0EE8
	dc.w	$EE8
	dc.w	$0000,$004A
	dc.w	$EEE
	dc.l	$688
	dc.w	$0464,$0244
	dc.w	$0222,$004E
	dc.w	$000A
	dc.w	$0022,$0AAA
	dc.l	$EE8
	dc.w	$0000,$004A
	dc.w	$0EE8
	dc.w	$0EE8
	dc.w	$EEE
	dc.l	$688
	dc.w	$0464,$0244
	dc.w	$0222,$004E
	dc.w	$000A
	dc.w	$0022,$0AAA
	dc.l	$EE8
	dc.w	$0EE8
	dc.w	$EE8
	dc.w	$0000,$004A
	dc.w	$EEE
	dc.l	$688
	dc.w	$0464,$0244
	dc.w	$0222,$004E
	dc.w	$000A
	dc.w	$0022,$0AAA
	dc.l	$48E7
	dc.w	$FF7E
	dc.w	$2F09
	dc.w	$2649
	dc.w	$227C,$0002,$57EE
	dc.w	$48E7,$C000
	dc.w	$6100,$00A4
	dc.w	$4CDF,$0003
	dc.w	$6100,$0124
	dc.w	$4A40
	dc.w	$6600,$000C
	dc.w	$225F
	dc.w	$32BC,$0002
	dc.w	$6000,$005C
.lA78E	dc.w	$227C,$0001,$7E70
	dc.w	$33C0,$0001,$7E64
	dc.w	$6100,$0092
	dc.w	$2657
	dc.w	$227C,$0001,$7E70
	dc.w	$4EB9,$0003,$9208
	dc.w	$3039,$0001,$7E64
	dc.w	$227C,$0002,$5808
	dc.w	$0C40,$0001
	dc.w	$6600,$0008
	dc.w	$227C,$0002,$5810
.lA7C6	dc.w	$4A41
	dc.w	$6600,$0016
	dc.w	$227C,$0002,$57F8
	dc.w	$0C40,$0001
	dc.w	$6600,$0008
	dc.w	$227C,$0002,$5800
.lA7E0	dc.w	$265F
	dc.w	$4EB9,$0003,$9208
.lA7E8	dc.w	$4CDF,$7EFF
	dc.w	$4E75
	dc.w	$000A
	dc.w	$5265
	dc.w	$636F
	dc.w	$7264
	dc.w	$2000,$0008,$2067,$6F61,$6C73,$0008,$2067,$6F61
	dc.w	$6C00,$0008,$2073,$6176,$6573,$0008,$2073,$6176
	dc.w	$6500,$48E7,$8000,$3011,$0440,$0001,$16D9,$51C8
	dc.w	$FFFC,$4CDF,$0001,$4E75
AppendNumber						;Write d0 (0 ... 999, no leading zeros) as a String at a1, padded to an
									;even length
	movem.w	d0-d6/a0,-(sp)
	move.l	a1,-(sp)		;keep the String start
	move.w	d0,d6
	adda.l	#$2,a1		;leave room for the length word
	clr.w	d1
	ext.l	d0
	divu.w	#$64,d0		;hundreds digit
	tst.w	d0		;any hundreds?
	beq.w	.0		;no hundreds: no leading zero
	addi.w	#$30,d0
	move.b	d0,(a1)+
	addi.w	#$1,d1
.0	swap	d0
	ext.l	d0		;clear the high word
	divu.w	#$A,d0		;tens digit
	addi.w	#$30,d0
	cmpi.b	#$30,d0		;tens 0 is skipped only for values below 10
	bne.w	.1
	cmpi.w	#$A,d6		;below 10?
	blt.w	.2		;yes: no tens digit
.1	move.b	d0,(a1)+
	addi.w	#$1,d1
.2	swap	d0		;ones digit from the remainder
	addi.w	#$30,d0
	move.b	d0,(a1)+
	addi.w	#$1,d1
	btst	#$0,d1		;odd length: pad with a 0 byte so the String stays word aligned
	beq.w	.3		;even already
	move.b	#$0,(a1)+		;pad byte
	addi.w	#$1,d1
.3	movea.l	(sp)+,a0
	addi.w	#$2,d1		;length counts the 2-byte header
	move.w	d1,(a0)
	movem.w	(sp)+,d0-d6/a0
	rts
GetRecordValue						;d0 = record d0 of player d1 of team d0 from save RAM (ReadPlayerRecord
									;into M68K_RAM); d1 = 1 when the player is a goalie
	movem.l	d2-d7/a0-a6,-(sp)
	move.w	d0,-(sp)
	movea.l	#TeamList,a2
	asl.w	#$2,d0
	movea.l	(a2,d0.w),a2
	adda.w	$0(a2),a2		;a2 = the team's first player record
	move.w	d1,d0		;skip d1 records to reach the player
	bra.w	.lA8C2
.loop	adda.w	(a2),a2
	adda.w	#$8,a2
.lA8C2	dbra	d0,.loop
	move.w	d1,d0
	move.w	(sp)+,d1
	move.w	d0,d5
	move.w	d1,d4
	ext.l	d0
	movea.l	#M68K_RAM,a0
	bsr.w	X_7534		;his save record into M68K_RAM
	move.b	(a0),d0		;byte 0 = the record value
	ext.w	d0
	movea.l	#TeamList,a5
	asl.w	#$2,d4
	movea.l	(a5,d4.w),a5
	adda.w	$A(a5),a5		;the goalie nibbles in GoalieOdds give the goalie count
	move.w	(a5),d1
	movem.w	d0,-(sp)
	clr.w	d0
.loop2	addi.w	#$1,d0
	asl.w	#$4,d1		;next nibble
	bne.w	.loop2
	cmp.w	d5,d0		;roster index past the goalies: a skater
	movem.w	(sp)+,d0
	bgt.w	.1		;index below the goalie count: a goalie
	clr.w	d1		;d1 = 0: a skater
	bra.w	.x
.1	move.w	#$1,d1		;d1 = 1: a goalie
.x	movem.l	(sp)+,d2-d7/a0-a6
	rts
PrintRecordHolder						;Record holder line: RecByTxt ("by") then the holder's user name
									;(AppendRecordHolder). An empty String when there is none
	movem.l	d0-d7/a1-a6,-(sp)
	move.l	a1,-(sp)		;keep the output start
	movea.l	a1,a3
	movea.l	#RecByTxt,a1
	movem.l	d0-d1,-(sp)		;save team and player
	bsr.w	CopyString-LOAD
	movem.l	(sp)+,d0-d1
	movea.l	#TempBuffer,a1		;holder name buffer
	bsr.w	AppendRecordHolder
	movea.l	(sp)+,a3
	cmpi.w	#$2,(a1)		;no holder name: give back an empty String
	bne.w	.0
	move.w	#$2,(a3)		;length 2 = empty String
	bra.w	.x
.0	jsr	(appstring).l		;append the name
.x	movem.l	(sp)+,d0-d7/a1-a6
	rts
	dc.w	$0006,$6279,$2000
PrintRecordVs						;Record line: RecVsTxt ("vs.") then the user name and the opponent team
									;(AppendRecordVs)
	movem.l	d0-d7/a1-a6,-(sp)
	move.l	a1,-(sp)		;keep the output start
	movea.l	a1,a3
	movea.l	#RecVsTxt,a1
	movem.l	d0-d1,-(sp)		;save team and player
	bsr.w	CopyString-LOAD
	movem.l	(sp)+,d0-d1
	movea.l	#TempBuffer,a1
	bsr.w	AppendRecordVs		;user name and opponent
	movea.l	(sp)+,a3
	jsr	(appstring).l
	movem.l	(sp)+,d0-d7/a1-a6
	rts
	dc.w	$0006,$7673,$2E20
AppendRecordHolder						;Append the user name of the record holder (byte 1 of record a0, or read
									;record d0 / d1 when a0 is 0) to a1 (AppendUserName)
	movem.l	d0-d7/a1-a2,-(sp)
	cmpa.l	#$0,a0
	bne.w	.0		;a record was passed in a0: use it
	movem.l	d0-d7/a1-a6,-(sp)
	move.w	d0,-(sp)		;swap d0 and d1
	move.w	d1,d0		;swap d0/d1 into ReadPlayerRecord's order: d0 player, d1 team
	move.w	(sp)+,d1
	ext.l	d1
	ext.l	d0
	movea.l	#M68K_RAM,a0
	bsr.w	X_7534
	movea.l	#M68K_RAM,a0		;a0 = the record
	movem.l	(sp)+,d0-d7/a1-a6
.0	move.b	$1(a0),d2
	ext.w	d2
	bset	#$7,(sflags6).l		;bit 7 of sflags6: AppendUserName uses the record name list
	bsr.w	AppendUserName-LOAD
	movem.l	(sp)+,d0-d7/a1-a2
	rts
AppendRecordVs						;Append the user name (byte 3 of record a0), a space and the opponent team
									;name (byte 2, AppendTeamName) to a1
	movem.l	d0-d7/a0-a6,-(sp)
	cmpa.l	#$0,a0
	bne.w	.0		;a record was passed in a0: use it
	movem.l	d0-d7/a1-a6,-(sp)
	move.w	d0,-(sp)		;swap d0 and d1
	move.w	d1,d0		;swap d0/d1 into ReadPlayerRecord's order: d0 player, d1 team
	move.w	(sp)+,d1
	ext.l	d1
	ext.l	d0
	movea.l	#M68K_RAM,a0
	bsr.w	X_7534
	movea.l	#M68K_RAM,a0		;a0 = the record
	movem.l	(sp)+,d0-d7/a1-a6
.0	move.b	$3(a0),d2
	ext.w	d2
	movem.l	d0/a1,-(sp)
	bset	#$7,(sflags6).l		;record name list
	bsr.w	AppendUserName-LOAD
	movea.l	a1,a3
	movea.l	#RecSpaceTxt,a1
	jsr	(appstring).l
	movem.l	(sp)+,d0/a1
	move.b	$2(a0),d0		;byte 2 = the opponent team
	jsr	(AppendTeamName).l		;append the team name
	movem.l	(sp)+,d0-d7/a0-a6
	rts
