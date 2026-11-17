	include	segacd\hockey.inc
	include	macros\genesis.mac

ColdMap	equ	$47D9C
HotMap	equ	$47D98
OptPlayMode	equ	$18BFA
PBnum	equ	$18068
PenBuf	equ	$18022
PenCntDwn	equ	$18064
Penaltytimer	equ	$18066
PerTimeTotal	equ	$180EA
SetSPA	equ	$363C0
Setplass	equ	$3D754
assexit	equ	$362C4
awaycoldplayer	equ	$17EB0
awayhotplayer	equ	$17EAC
awtmstruct	equ	$186B2
coldiconchars	equ	$1AD88
dobitmap	equ	$387E2
eraser	equ	$38C06
gameclock	equ	$180E6
homecoldplayer	equ	$17EB2
homehotplayer	equ	$17EAE
hoticonchars	equ	$1AD86
iconplayer	equ	$1AD8A
move	equ	$2C9C8
null	equ	$1B008
onetimerflags	equ	$17EC6
onetimerplayer	equ	$17EBC
periodendtime	equ	$1747E
printx	equ	$18D58
printy	equ	$18D5A
randomd0	equ	$37050
tmstruct	equ	$1834C
X_103E8	equ	$103E8
X_10A04	equ	$10A04

	org	$FF00

EndOneTimer
	movem.l	d0/a0,-(sp)
	bclr	#$3,$64(a3)
	bclr	#$5,$62(a3)
	bclr	#$1,$63(a3)
	clr.w	(onetimerflags).l
	st.b	(onetimerplayer).l
	move.w	d1,-(sp)
	move.w	#$50C,d1
	jsr	(SetSPA).l
	tst.w	$34(a3)
	bpl.w	.lFF40
	jsr	(assexit).l
	bra.w	.lFF46
.lFF40	jsr	(Setplass).l
.lFF46	clr.w	$5A(a3)
	st.b	$5C(a3)
	move.w	(sp)+,d1
	movem.l	(sp)+,d0/a0
	rts
	dc.w	$0EEA,$0000,$0042,$0EEA,$0EEA,$0EEE,$0000,$0888
	dc.w	$0AAA,$0068,$008A,$00CE,$0260,$0040,$0664,$0E8E
	dc.w	$0EE8,$008C,$0000,$0A0A,$0A0A,$0EEE,$0000,$0C8C
	dc.w	$008C,$0888,$0068,$0846,$0044,$0422,$08CE,$02AE
	dc.w	$0EE8,$0822,$008C,$0EE8,$0EE8,$0EEE,$0000,$0EC8
	dc.w	$048C,$0C88,$006C,$0866,$0268,$0224,$0620,$00CE
	dc.w	$0EE8,$0006,$008C,$0EE8,$0EE8,$0EEE,$0000,$08EE
	dc.w	$02CE,$02AE,$026E,$000C,$0EE8,$0EE8,$0EE8,$0EE8
	dc.w	$0EE8,$0000,$0006,$0EE8,$0EE8,$0EEE,$0000,$08EE
	dc.w	$0A8E,$04AC,$0A88,$046C,$0226,$0644,$022E,$0262
	dc.w	$0EE8,$0000,$0042,$0EE8,$0EE8,$0EEE,$0000,$08AA
	dc.w	$0688,$0488,$0466,$0244,$0260,$0020,$0ACC,$0000
	dc.w	$0EE8,$0006,$0006,$0EE8,$0EE8,$0EEE,$0000,$0C8E
	dc.w	$086E,$044E,$082E,$020E,$0EE8,$0EE8,$0EE8,$0EE8
	dc.w	$0EE8,$0600,$004A,$0EE8,$0EE8,$0EEE,$0000,$0CEA
	dc.w	$0A8E,$08A8,$044E,$0488,$002E,$0440,$0400,$0EE8
	dc.w	$0E0E,$0000,$008C,$0EE8,$0EE8,$0EEE,$0000,$0E00
	dc.w	$0400,$0600,$000E,$000A,$0288,$0266,$02AA,$0CCC
	dc.w	$0EE8,$0042,$0822,$0EE8,$0EE8,$0EEE,$0000,$0020
	dc.w	$0040,$0A8A,$0020,$0466,$0200,$0224,$0888,$0422
	dc.w	$0EE8,$0000,$0000,$0EE8,$0EE8,$0EEE,$0000,$0AAA
	dc.w	$0888,$0666,$0444,$0222,$0CCC,$0EE8,$0EE8,$0EE8
	dc.w	$0EE8,$0600,$0006,$0EE8,$0EE8,$0EEE,$0000,$088E
	dc.w	$026E,$0C68,$002E,$0A24,$0EAA,$0EE8,$0EE8,$0EE8
	dc.w	$0EE8,$0020,$0006,$0EE8,$0EE8,$0EEE,$0000,$0AAA
	dc.w	$000A,$0888,$000C,$0022,$0006,$0CCC,$0EE8,$0EE8
	dc.w	$0EE8,$0822,$004A,$0EE8,$0EE8,$0EEE,$0000,$0AA8
	dc.w	$066E,$0864,$022C,$062A,$0008,$0622,$0222,$0A8E
	dc.w	$0EE8,$0600,$0006,$0EE8,$0EE8,$0EEE,$0000,$0AAA
	dc.w	$0C86,$002E,$0C60,$0844,$0444,$0840,$0008,$0EC8
	dc.w	$0EE8,$0006,$006A,$0EE8,$0EE8,$0EEE,$0000,$068A
	dc.w	$0688,$0466,$0244,$022C,$0228,$0008,$0AAA,$0004
	dc.w	$0EE8,$0000,$004A,$0EE8,$0EE8,$0EEE,$0000,$0CCC
	dc.w	$088E,$0AAA,$046E,$006E,$0888,$0666,$002E,$0444
	dc.w	$0EE8,$0000,$008C,$0EE8,$0EE8,$0EEE,$0000,$0AAA
	dc.w	$088A,$066A,$04EE,$0464,$0440,$02CE,$0244,$0AEE
	dc.w	$0EE8,$0600,$0006,$0EE8,$0EE8,$0EEE,$0000,$0C00
	dc.w	$000E,$0E44,$0ECE,$0E80,$088E,$0EE8,$0EE8,$0EE8
	dc.w	$0EE8,$0000,$0822,$0EE8,$0EE8,$0EEE,$0000,$0860
	dc.w	$0642,$0888,$0CA8,$0ACC,$02AE,$006E,$0048,$046A
	dc.w	$0EE8,$0822,$006A,$0EE8,$0EE8,$0EEE,$0000,$0602
	dc.w	$024C,$0002,$0026,$0068,$0428,$086E,$0EE8,$0EE8
	dc.w	$0EE8,$0000,$0600,$0EE8,$0EE8,$0EEE,$0000,$0C86
	dc.w	$0E84,$0A84,$0C44,$0822,$0E20,$0600,$0A00,$0EA8
	dc.w	$0EE8,$0600,$0600,$0EE8,$0EE8,$0EEE,$0000,$0ECA
	dc.w	$0AAA,$0C66,$0822,$0CCC,$0EE8,$0EE8,$0EE8,$0EE8
	dc.w	$0EE8,$0000,$008C,$0EE8,$0EE8,$0EEE,$0000,$00CE
	dc.w	$006A,$004E,$0028,$0022,$0020,$008E,$0888,$06CE
	dc.w	$0EE8,$0006,$0600,$0EE8,$0EE8,$0EEE,$0000,$022C
	dc.w	$0C86,$0EA8,$088E,$0842,$0EE8,$0EE8,$0EE8,$0EE8
	dc.w	$0EE8,$0600,$0006,$0EE8,$0EE8,$0EEE,$0000,$022C
	dc.w	$0422,$0AAC,$0666,$0CAA,$0444,$066E,$08CE,$0226
	dc.w	$0EE8,$0006,$006A,$0EE8,$0EE8,$0EEE,$0000,$0AAA
	dc.w	$0888,$0684,$0444,$022C,$0008,$0880,$0660,$0440
	dc.w	$0EE8,$0006,$006A,$0EE8,$0EE8,$0EEE,$0000,$0AAA
	dc.w	$0888,$0466,$0444,$022C,$0008,$0400,$0800,$0C00
	dc.w	$48E7,$80F0,$3F39,$0001,$7F6C,$0839,$0001,$0001
	dc.w	$7F78,$6600,$00B2,$247C,$0001,$834C,$47EA,$0366
	dc.w	$302A,$0026,$906B,$0026,$6700,$009C,$6A00,$001E
	dc.w	$0839,$0006,$0001,$7F6C,$6600,$002C,$6100,$007E
	dc.w	$08F9,$0006,$0001,$7F6C,$6000,$001C,$C54B,$0839
	dc.w	$0006,$0001,$7F6C,$6700,$000E,$6100,$0060,$08B9
	dc.w	$0006,$0001,$7F6C,$08F9,$0005,$0001,$7F6C,$6600
	dc.w	$0056,$B7FC,$0001,$834C,$6600,$0026,$33F9,$0001
	dc.w	$7FAE,$0001,$A56C,$33FC,$0001,$0001,$A56E,$4EB9
	dc.w	$0002,$A478,$08F9,$0006,$0001,$7F7C,$6000,$0028
	dc.w	$33F9,$0001,$7FAE,$0001,$A56C,$33FC,$0004,$0001
	dc.w	$A56E,$4EB9,$0002,$A478,$6000,$FFDA,$08B9,$0005
	dc.w	$0001,$7F6C,$4E75,$33DF,$0001,$7F6C,$4CDF,$0F01
	dc.w	$4E75
ClearPenalties
	movem.l	d0/a0,-(sp)
	clr.w	(PBnum).l
	clr.w	(Penaltytimer).l
	clr.w	(PenCntDwn).l
	move.w	#$10,d0
	movea.l	#PenBuf,a0
.l103C8	clr.l	(a0)+
	dbra	d0,.l103C8
	movea.l	#tmstruct,a0
	bsr.w	X_103E8
	movea.l	#awtmstruct,a0
	bsr.w	X_103E8
	movem.l	(sp)+,d0/a0
	rts
	dc.w	$303C,$0019,$D0FC,$0068,$30FC,$FFFE,$51C8,$FFFA
	dc.w	$30BC,$FFFF,$4E75
HotColdIcon
	movem.l	d0/a0-a1,-(sp)
	movea.l	#awayhotplayer,a0
	move.w	#$2,$1AD8C.l
	cmpa.l	#$1834C,a2
	bne.w	.l10428
	movea.l	#homehotplayer,a0
	move.w	#$20,$1AD8C.l
.l10428	move.w	#$0,d0
.l1042C	move.w	(a0)+,d1
	cmp.w	(iconplayer).l,d1
	beq.w	.l1048E
	dbra	d0,.l1042C
	movea.l	#awaycoldplayer,a0
	cmpa.l	#$1834C,a2
	bne.w	.l10452
	movea.l	#homecoldplayer,a0
.l10452	move.w	#$0,d0
.l10456	move.w	(a0)+,d1
	cmp.w	(iconplayer).l,d1
	beq.w	.l1049E
	dbra	d0,.l10456
	move.w	$1AD8C.l,(printx).l
	move.w	#$19,(printy).l
	move.w	#$8,d0
	move.w	#$3,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	bra.w	.l104DC
.l1048E	move.w	(hoticonchars).l,d4
	movea.l	(HotMap).l,a0
	bra.w	.l104AA
.l1049E	move.w	(coldiconchars).l,d4
	movea.l	(ColdMap).l,a0
.l104AA	move.w	$1AD8C.l,(printx).l
	move.w	#$19,(printy).l
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	movea.l	#null,a2
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	$2(a1),d3
	moveq	#$0,d5
	jsr	(dobitmap).l
.l104DC	movem.l	(sp)+,d0/a0-a1
	rts
	dc.w	$0839,$0006,$0001,$7F74,$6600,$0114,$48E7,$FEC0
	dc.w	$3039,$0001,$7BA8,$E040,$D079,$0001,$7B80,$3239
	dc.w	$0001,$7BAA,$E041,$D279,$0001,$7B94,$48A7,$C000
	dc.w	$7405,$3604,$0A43,$0002,$7AFF,$207C,$0001,$7480
	dc.w	$227C,$0001,$7FA6,$0C71,$0001,$4000,$6700,$0006
	dc.w	$D0FC,$0300,$227C,$0001,$7F9E,$4A68,$0034,$6F00
	dc.w	$0094,$0828,$0002,$0063,$6600,$008A,$48A7,$4000
	dc.w	$3228,$0052,$B271,$4000,$4C9F,$0002,$6700,$000C
	dc.w	$0828,$0003,$0062,$6600,$006C,$0839,$0002,$0001
	dc.w	$7F70,$6700,$002E,$48E7,$8000,$3039,$0001,$9368
	dc.w	$B068,$0052,$4CDF,$0001,$6700,$0018,$48E7,$8000
	dc.w	$3039,$0001,$936A,$B068,$0052,$4CDF,$0001,$6600
	dc.w	$0034,$0828,$0005,$0062,$6600,$002A,$4C97,$0003
	dc.w	$9068,$0000,$C1C0,$9268,$0014,$C3C1,$D081,$B085
	dc.w	$6200,$0012,$3228,$0052,$B271,$3000,$6700,$0006
	dc.w	$2A00,$3C01,$D0FC,$0080,$51CA,$FF60,$DEFC,$0004
	dc.w	$4879,$0002,$B5FC,$BC71,$4000,$6700,$0014,$3006
	dc.w	$4A44,$6700,$0012,$6000,$0014,$4CDF,$037F,$4E75
	dc.w	$4EF9,$0003,$12AA,$4EF9,$0003,$12B8,$4EF9,$0003
	dc.w	$12DC,$4EB9,$0003,$7598,$3E3C,$000D,$4EB8,$6044
	dc.w	$48E7,$E1C0,$3E3C,$0001,$303C,$0060,$4EB8,$6044
	dc.w	$23C8,$0004,$7DA0,$4CDF,$0387,$2279,$0004,$7DA0
	dc.w	$45F9,$0002,$23D6,$47F9,$0002,$22EA,$3E3C,$0008
	dc.w	$4EB8,$6044,$4EB9,$0003,$7598,$48E7,$E1C0,$3E3C
	dc.w	$0001,$303C,$0001,$4EB8,$6044,$23C8,$0004,$7D60
	dc.w	$4CDF,$0387,$2079,$0004,$7D60,$2008,$23D8,$0004
	dc.w	$7D3C,$D1B9,$0004,$7D3C,$23D8,$0004,$7D18,$D1B9
	dc.w	$0004,$7D18,$23D8,$0004,$7D40,$D1B9,$0004,$7D40
	dc.w	$23D8,$0004,$7D2C,$D1B9,$0004,$7D2C,$23D8,$0004
	dc.w	$7D38,$D1B9,$0004,$7D38,$23D8,$0004,$7D4C,$D1B9
	dc.w	$0004,$7D4C,$23D8,$0004,$7D34,$D1B9,$0004,$7D34
	dc.w	$23D8,$0004,$7D30,$D1B9,$0004,$7D30,$23D8,$0004
	dc.w	$7D1C,$D1B9,$0004,$7D1C,$23D8,$0004,$7D20,$D1B9
	dc.w	$0004,$7D20,$23D8,$0004,$7D44,$D1B9,$0004,$7D44
	dc.w	$23D8,$0004,$7D10,$D1B9,$0004,$7D10,$23D8,$0004
	dc.w	$7D58,$D1B9,$0004,$7D58,$23D8,$0004,$7D14,$D1B9
	dc.w	$0004,$7D14,$23D8,$0004,$7D28,$D1B9,$0004,$7D28
	dc.w	$23D8,$0004,$7D0C,$D1B9,$0004,$7D0C,$23D8,$0004
	dc.w	$7D64,$D1B9,$0004,$7D64,$23D8,$0004,$7D68,$D1B9
	dc.w	$0004,$7D68,$23D8,$0004,$7D6C,$D1B9,$0004,$7D6C
	dc.w	$23D8,$0004,$7D70,$D1B9,$0004,$7D70,$23D8,$0004
	dc.w	$7D80,$D1B9,$0004,$7D80,$23D8,$0004,$7D84,$D1B9
	dc.w	$0004,$7D84,$23D8,$0004,$7D98,$D1B9,$0004,$7D98
	dc.w	$23D8,$0004,$7D9C,$D1B9,$0004,$7D9C,$23D8,$0004
	dc.w	$7DA8,$D1B9,$0004,$7DA8,$45F9,$0002,$A9FA,$3039
	dc.w	$0001,$7FAE,$E540,$2472,$0000,$48E7,$E1C0,$3E3C
	dc.w	$0001,$300A,$4EB8,$6044,$23C8,$0004,$7D90,$4CDF
	dc.w	$0387,$48E7,$E1C0,$3E3C,$0001,$303C,$0002,$4EB8
	dc.w	$6044,$23C8,$0004,$7D24,$4CDF,$0387,$303C,$0002
	dc.w	$4EB8,$5F22,$4E75,$303C,$0002,$4EB8,$5F22,$08B9
	dc.w	$0005,$00FF,$800F,$50F9,$0001,$A556,$42B9,$0001
	dc.w	$AD46,$42B9,$0001,$AD4E,$42B9,$0001,$AD4A,$42B9
	dc.w	$0001,$AD52,$4279,$0001,$91CE,$4EB9,$0003,$7598
	dc.w	$4EB9,$0003,$76F2,$2F0E,$2C79,$0001,$9360,$0839
	dc.w	$0005,$00FF,$800F,$6706,$3D3C,$0001,$6004,$3D3C
	dc.w	$0000,$08B9,$0005,$00FF,$800F,$23CE,$0001,$9360
	dc.w	$2C5F,$4EB9,$0002,$B614,$2F0E,$2C79,$0001,$9360
	dc.w	$4A5E,$670A,$08F9,$0005,$00FF,$800F,$6008,$08B9
	dc.w	$0005,$00FF,$800F,$23CE,$0001,$9360,$2C5F,$4EB9
	dc.w	$0003,$7752,$41F9,$0001,$746A,$303C,$0010,$4EB8
	dc.w	$5F22,$303C,$0002,$4EB8,$5F22,$303C,$0080,$4EB8
	dc.w	$5F22,$6500,$FFF6,$303C,$0081,$4EB8,$5F22,$3410
	dc.w	$0242,$FF00,$0C42,$0000,$66EC,$33FC,$0005,$0001
	dc.w	$9364,$303C,$0013,$41F9,$0001,$9364,$4EB8,$5F22
	dc.w	$4EB9,$0003,$74F0,$0C03,$00E0,$6600,$000A,$33FC
	dc.w	$0003,$0001,$8C02,$4239,$0001,$7F68,$0C79,$0001
	dc.w	$0001,$8C08,$6600,$000A,$08F9,$0005,$0001,$7F68
	dc.w	$0C79,$0001,$0001,$8BFA,$6F00,$0006,$6100,$0064
	dc.w	$4EB9,$0003,$F11E,$0839,$0000,$0001,$7F78,$6700
	dc.w	$001E,$2F08,$207C,$0001,$834C,$4EB9,$0002,$308E
	dc.w	$207C,$0001,$86B2,$4EB9,$0002,$308E,$205F,$4279
	dc.w	$0001,$80F0,$4279,$0001,$825A,$4279,$0001,$80E4
	dc.w	$4279,$0001,$80EC,$6100,$002C,$4EB9,$0003,$CB50
	dc.w	$4EB9,$0003,$E91C,$4EB9,$0002,$2E38,$4EF9,$0003
	dc.w	$5A94,$303C,$0071,$207C,$0001,$8C42,$4258,$51C8
	dc.w	$FFFC,$4E75
restoreteams						;Put both teams' rosters on the bench
	movea.l	#tmstruct,a2		;team 1
	bsr.w	.r
	adda.w	#$366,a2		;team 2
.r	move.w	#$6,$26(a2)		;tmap: no players in pen. box
	moveq	#$32,d0		;(maxros-1)*2
.0	move.w	#$FFFE,$68(a2,d0.w)		;tmpdst: -2 = all players on bench
	subi.w	#$2,d0
	bpl.w	.0
	rts
ResetClock						;set period length and stop clock
	bsr.w	X_10A04		;d0 = period length in seconds
	cmpi.w	#$3,$180E4.l		;overtime?
	blt.w	.0
	tst.w	(OptPlayMode).l
	bne.w	.0
	move.w	#$258,d0		;OptPlayMode 0 overtime is always 10:00
.0	move.w	d0,(gameclock).l		;set the clock
	move.w	d0,(PerTimeTotal).l
	move.w	d0,(periodendtime).l		;CheckLateGameSong trigger time =
	asr.w	#$1,d0
	jsr	(randomd0).l
	sub.w	d0,(periodendtime).l		;length - random(length/2)
	bset	#$0,$17F68.l		;gmclock: stop clock
	rts
	dc.w	$3039,$0001,$8C02,$E340,$41FA,$0008,$3030,$0000
	dc.w	$4E75,$012C,$0258,$04B0,$001E,$08B9,$0005,$00FF
	dc.w	$800F,$33FC,$FFFF,$0001,$8D62,$323C,$8400,$303C
	dc.w	$0085,$4EB8,$5F22,$0C79,$0003,$0001,$80E4,$6600
	dc.w	$000A,$08F9,$0001,$0001,$7F7A,$50F9,$0001,$A560
	dc.w	$4EB9,$0004,$7DAC,$4EB9,$0003,$E91C,$6100,$FF5A
	dc.w	$0079,$F000,$0001,$7DC8,$50F9,$0001,$7F9E,$50F9
	dc.w	$0001,$7FA0,$267C,$0001,$7B80,$4279,$0001,$7EE2
	dc.w	$4279,$0001,$7EE4,$0839,$0000,$0001,$7F78,$6700
	dc.w	$001A,$303C,$001E,$33FC,$0008,$0001,$936C,$33FC
	dc.w	$000B,$0001,$936A,$6000,$0004,$701B,$4EB9,$0003
	dc.w	$62E4,$08F9,$0002,$0001,$7F6C,$08B9,$0004,$0001
	dc.w	$7F6A,$33FC,$FFFF,$0001,$7F64,$23FC,$0000,$C45C
	dc.w	$0001,$7470,$33F9,$0001,$7474,$0001,$7476,$6100
	dc.w	$00AA,$33FC,$FFFF,$0001,$8D62,$6100,$009E,$3039
	dc.w	$0001,$8A9E,$E940,$33C0,$0001,$7CD8,$4279,$0001
	dc.w	$7F8C,$33F9,$0001,$7FAE,$0001,$A56C,$33FC,$0000
	dc.w	$0001,$A56E,$4EB9,$0002,$A478
