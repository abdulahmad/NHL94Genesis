	include	segacd\hockey.inc
	include	macros\genesis.mac

AddPenalty2	equ	$39456
AwGoals	equ	$186BE
CC_SetFont	equ	$F9
CC_SetMapAndPosition	equ	$F8
ClearPenalties	equ	$2B3A8
ClearPenaltyBuffer	equ	$39EE4
Crowdlevel	equ	$17CD2
FormatPlayerNameShort	equ	$41226
FourWayPlay	equ	$18BF8
Fprintsmall	equ	$3CEBE
Framer	equ	$38CA0
GetShifter	equ	$4081C
HmGoals	equ	$18358
OldVcount	equ	$17476
OptLine	equ	$18C0A
OptPlayMode	equ	$18BFA
PAttribColumns	equ	$41C48
PlayerScrollCtr	equ	$1A452
ProcessInputWithRepeat	equ	$374BE
PushNumberWidth	equ	$3919A
ReadJoy1	equ	$374F0
ReadJoy2	equ	$3750E
ReadJoy3	equ	$3752C
ReadJoy4	equ	$3754A
SFXshotfh	equ	$18
Satt	equ	$BBD30
ScoresMap	equ	$47D58
ScoutReport	equ	$8
ScoutSubStatus	equ	$17474
SelectedPlayerIdx	equ	$1A454
SortCords	equ	$17480
TeamList	equ	$1B00C
TestList	equ	$1A45A
VertLineScrolling	equ	$1A450
assinsert	equ	$362D8
auto	equ	$2C58A
bosgames	equ	$18A9C
cont1team	equ	$17FA6
cont2team	equ	$17FA8
disflags	equ	$18D64
dobitmap	equ	$387E2
gameclock	equ	$180E6
gamelevel	equ	$18A9E
gamenum	equ	$18A98
getname	equ	$4112E
goaliemode1	equ	$18C0C
goaliemode2	equ	$18C0E
linelist	equ	$419F6
manual	equ	$2C576
menuitem	equ	$18AD2
menulist	equ	$18AD6
move	equ	$2C9C8
print	equ	$38F80
printa	equ	$18D5C
printfontset	equ	$18D60
printsmall	equ	$38D9E
printsmallz	equ	$38D8C
printx	equ	$18D58
printy	equ	$18D5A
puckx	equ	$17B80
redrawicons	equ	$17F60
sbut	equ	$7
scoutcolumn	equ	$1A44E
screentimer	equ	$1A458
sfx	equ	$3710C
stop_current_song	equ	$47DB0
swap	equ	$2779A
tmstruct	equ	$1834C
X_11016	equ	$11016
X_11022	equ	$11022
X_11034	equ	$11034
X_1104C	equ	$1104C
X_11060	equ	$11060
X_11310	equ	$11310
X_1140E	equ	$1140E
X_1176C	equ	$1176C
X_1182E	equ	$1182E
X_118D4	equ	$118D4
X_11914	equ	$11914
X_11B74	equ	$11B74
X_11BAC	equ	$11BAC
X_11BDA	equ	$11BDA
X_11CB7	equ	$11CB7
X_11D1E	equ	$11D1E
X_11D26	equ	$11D26
X_11D7A	equ	$11D7A
X_11DE8	equ	$11DE8
X_11E66	equ	$11E66
X_11E94	equ	$11E94
X_11EC0	equ	$11EC0
X_11F08	equ	$11F08
X_11FAE	equ	$11FAE
X_1256A	equ	$1256A
X_13980	equ	$13980
X_13D60	equ	$13D60
X_13DA0	equ	$13DA0
X_13DBC	equ	$13DBC
X_142F0	equ	$142F0
X_14988	equ	$14988
X_15094	equ	$15094

	org	$10E66

clockcont
	btst	#$0,$17F68.l
	bne.w	X_14988
	tst.w	(gameclock).l
	bne.w	X_14988
	bset	#$3,(disflags).l
	jsr	(stop_current_song).l
	move.w	#$4,-(sp)
	jsr	(sfx).l
	bsr.w	X_15094
clockcont_0
	movea.l	#puckx,a3
	move.l	#SFXshotfh,d0
	jsr	(assinsert).l
	cmpi.w	#$2,$180E4.l
	blt.w	.l10F98
	move.l	#sbut,d0
	movea.l	#SortCords,a3
	cmpi.w	#$3,(gamelevel).l
	bne.w	.l10F34
	cmpi.w	#$7,(bosgames).l
	beq.w	.l10F18
	moveq	#$10,d3
	mulu.w	(gamenum).l,d3
	movea.l	#$18A18,a0
	adda.w	d3,a0
	clr.w	d3
	btst	#$0,$E(a0)
	beq.w	.l10EFA
	eori.w	#$2,d3
.l10EFA	move.w	(HmGoals).l,d1
	sub.w	(AwGoals).l,d1
	bpl.w	.l10F0E
	eori.w	#$2,d3
.l10F0E	cmpi.w	#$3,$4(a0,d3.w)
	bne.w	.l10F34
.l10F18	move.l	#ScoutReport,d0
	moveq	#$B,d2
.l10F20	bclr	#$3,$62(a3)
	adda.w	#$80,a3
	dbra	d2,.l10F20
	movea.l	#SortCords,a3
.l10F34	moveq	#$5,d2
	move.w	(HmGoals).l,d1
	sub.w	(AwGoals).l,d1
	beq.w	.l10F98
	bpl.w	.l10F4E
	adda.w	#$300,a3
.l10F4E	tst.w	$34(a3)
	ble.w	.l10F62
	jsr	(assinsert).l
	move.l	#sbut,d0
.l10F62	adda.w	#$80,a3
	dbra	d2,.l10F4E
.l10F6A	jsr	(ClearPenaltyBuffer).l
	addi.w	#$3E8,(Crowdlevel).l
	bset	#$0,$17F68.l
	bset	#$6,$17F68.l
	jsr	(ClearPenalties).l
	move.w	#$4,d0
	jmp	(AddPenalty2).l
.l10F98	cmpi.w	#$3,$180E4.l
	bne.w	.l10FAE
	tst.w	(OptPlayMode).l
	beq.w	.l10F6A
.l10FAE	move.w	#$2,d0
	jmp	(AddPenalty2).l
demoread
	tst.w	(cont1team).l
	bne.w	X_14988
	tst.w	(cont2team).l
	bne.w	X_14988
	jsr	(ReadJoy1).l
	btst	#$7,d1
	bne.w	X_11022
	bsr.w	X_11016
	jsr	(ReadJoy2).l
	btst	#$7,d1
	bne.w	X_11034
	tst.w	(FourWayPlay).l
	beq.w	X_11016
	jsr	(ReadJoy3).l
	btst	#$7,d1
	bne.w	X_1104C
	bsr.w	X_11016
	jsr	(ReadJoy4).l
	btst	#$7,d1
	bne.w	X_11060
	dc.w	$4A41,$6700,$396E,$4EF9,$0003,$F2BE,$4279,$0001
	dc.w	$7F94,$08B9,$0001,$0001,$7F6A,$6000,$0010,$4279
	dc.w	$0001,$7F94,$08F9,$0001,$0001,$7F6A,$08F9,$0000
	dc.w	$0001,$7F6A,$4E75,$33FC,$0003,$0001,$7F94,$08B9
	dc.w	$0001,$0001,$7F6A,$6000,$FFE4,$33FC,$0004,$0001
	dc.w	$7F94,$08F9,$0001,$0001,$7F6A,$6000,$FFD0,$4EB9
	dc.w	$0003,$6D0A,$3F00,$3039,$0001,$7474,$B079,$0001
	dc.w	$7474,$6700,$FFF8,$301F,$4EB9,$0004,$7DAC,$3F39
	dc.w	$0001,$7F6A,$6100,$022C,$207C,$0004,$1F50,$43FA
	dc.w	$0152,$0839,$0000,$0001,$7F78,$6700,$000C,$207C
	dc.w	$0004,$1EB4,$6000,$0012,$082A,$0002,$0032,$6700
	dc.w	$0008,$207C,$0004,$20DC,$6100,$0228,$6100,$0566
	dc.w	$6100,$3218,$4EB9,$0003,$E1CE,$4EB9,$0003,$74BE
	dc.w	$6100,$0280,$6600,$FFE6,$4EB9,$0003,$6D0A,$33DF
	dc.w	$0001,$7F6A,$0839,$0007,$0001,$7F6A,$6700,$0012
	dc.w	$4EB9,$0003,$ECB8,$4EB9,$0003,$C40A,$6000,$0008
	dc.w	$4EB9,$0003,$C3AC,$207C,$00C0,$0000,$0839,$0007
	dc.w	$00FF,$800E,$66F6,$33FC,$9100,$00FF,$8022,$33FC
	dc.w	$000A,$00FF,$8020,$08F9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$67F6,$08F9,$0007,$00FF,$800F
	dc.w	$08B9,$0006,$00FF,$800F,$0839,$0006,$00FF,$800E
	dc.w	$66F6,$08B9,$0007,$00FF,$800F,$0839,$0007,$00FF
	dc.w	$800E,$66F6,$33FC,$9200,$00FF,$8022,$33FC,$000A
	dc.w	$00FF,$8020,$08F9,$0006,$00FF,$800F,$0839,$0006
	dc.w	$00FF,$800E,$67F6,$08F9,$0007,$00FF,$800F,$08B9
	dc.w	$0006,$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6
	dc.w	$08B9,$0007,$00FF,$800F,$08F9,$0003,$0001,$8D64
	dc.w	$08B9,$0000,$0001,$7F6A,$4EB9,$0003,$C48C,$4EB9
	dc.w	$0003,$DD16,$33FC,$0018,$0001,$8D62,$4A79,$0001
	dc.w	$8D62,$6A00,$FFF8,$33F9,$0001,$7474,$0001,$7476
	dc.w	$4E75,$207C,$00C0,$0000,$0839,$0007,$00FF,$800E
	dc.w	$66F6,$33FC,$9100,$00FF,$8022,$33FC,$000A,$00FF
	dc.w	$8020,$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9
	dc.w	$0007,$00FF,$800F,$0839,$0007,$00FF,$800E,$66F6
	dc.w	$33FC,$921C,$00FF,$8022,$33FC,$000A,$00FF,$8020
	dc.w	$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF,$800E
	dc.w	$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007
	dc.w	$00FF,$800F,$4EB9,$0003,$C40A,$4EB9,$0003,$DD16
	dc.w	$4EB9,$0004,$8208,$4EB9,$0003,$8D8C,$0008,$FF03
	dc.w	$FD00,$FC00,$7020,$721C,$343C,$07FF,$4EF9,$0003
	dc.w	$8C06
seta2
	movea.l	#tmstruct,a2
	btst	#$1,$17F6A.l
	beq.w	.l112E6
	cmpi.w	#$1,(cont2team).l
	bra.w	.l112EE
.l112E6	cmpi.w	#$1,(cont1team).l
.l112EE	beq.w	.l112F6
	adda.w	#$366,a2
.l112F6	rts
	dc.w	$23C8,$0001,$8AD6,$23C9,$0001,$8ADA,$4279,$0001
	dc.w	$8AD2,$4279,$0001,$8AD4,$2079,$0001,$8ADA,$4E90
	dc.w	$4EB9,$0003,$8D8C,$0006,$FE04,$FC0C,$6100,$0024
	dc.w	$7016,$7206,$4EB9,$0003,$8CA0,$6100,$00B0,$33FC
	dc.w	$0018,$0001,$8D62,$4A79,$0001,$8D62,$6A00,$FFF8
	dc.w	$4E75,$33FC,$0005,$0001,$8D58,$0839,$0001,$0001
	dc.w	$8D64,$6600,$362C,$0679,$0004,$0001,$8D58,$4E75
HandleMenuInput
	btst	#$7,d1
	bne.w	.l113DE
	btst	#$1,d1
	beq.w	.l11384
	addi.w	#$1,(menuitem).l
	bra.w	Pausemode_Pmenu
.l11384	btst	#$0,d1
	beq.w	.l11398
	subi.w	#$1,(menuitem).l
	bra.w	Pausemode_Pmenu
.l11398	btst	#$5,d1
	beq.w	.l113DE
	bsr.w	seta2
	move.w	(menuitem).l,d0
	movea.l	(menulist).l,a0
	adda.w	(a0),a0
	adda.w	(a0),a0
	bra.w	.l113BC
.l113B8	adda.w	#$4,a0
.l113BC	adda.w	(a0),a0
	dbra	d0,.l113B8
	movea.l	(a0),a0
	jsr	(a0)
	bclr	#$1,$17F74.l
	bne.w	.l113D6
	bsr.w	X_11310
.l113D6	tst.w	(menuitem).l
	rts
.l113DE	eori.b	#$4,ccr
	rts
Pausemode_Pmenu
	move.w	(menuitem).l,d0
	bpl.w	.l113F6
	clr.w	(menuitem).l
	clr.w	d0
.l113F6	movea.l	(menulist).l,a0
	adda.w	(a0),a0
	adda.w	(a0),a0
	bra.w	X_1140E
	dc.w	$D0D0,$D0FC,$0004,$4A68,$0002,$5BC8,$FFF4,$0640
	dc.w	$0001,$9179,$0001,$8AD2,$3039,$0001,$8AD2,$B079
	dc.w	$0001,$8AD4,$6C00,$0008,$33C0,$0001,$8AD4,$0440
	dc.w	$0003,$B079,$0001,$8AD4,$6F00,$0008,$33C0,$0001
	dc.w	$8AD4,$6100,$FF02,$33FC,$000D,$0001,$8D5A,$2279
	dc.w	$0001,$8AD6,$4EB9,$0003,$8D9E,$4EB9,$0003,$8D8C
	dc.w	$0026,$FB01,$20FB,$FFFA,$0120,$FBFF,$FA01,$20FB
	dc.w	$FFFA,$0120,$FB12,$20FB,$FFFA,$FF20,$FBFF,$FAFF
	dc.w	$20FB,$FFFA,$FF20,$D2D1,$3039,$0001,$8AD4,$6000
	dc.w	$0008,$D2D1,$D2FC,$0004,$51C8,$FFF8,$7203,$33FC
	dc.w	$000C,$0001,$8D5A,$6100,$FE9E,$3039,$0001,$8AD4
	dc.w	$6700,$0014,$4EB9,$0003,$8D8C,$000C,$FE05,$FB01
	dc.w	$FA01,$7BFA,$FF00,$6100,$FE7E,$4EB9,$0003,$8D8C
	dc.w	$0006,$FB02,$FA01,$2F09,$2279,$0001,$8AD6,$4EB9
	dc.w	$0003,$8D9E,$B079,$0001,$8AD2,$6600,$0008,$4EB9
	dc.w	$0003,$8D9E,$225F,$4EB9,$0002,$C528,$0640,$0001
	dc.w	$D2FC,$0004,$4A69,$0002,$5BC9,$FFBC,$6B00,$0014
	dc.w	$6100,$FE34,$4EB9,$0003,$8D8C,$0008,$FE05,$FB01
	dc.w	$7D00,$4E75
PrintMenuItem
	cmpi.b	#$78,$2(a1)
	bne.w	.l1156E
	move.l	a1,-(sp)
	movea.l	#manual,a1
	btst	#$1,$17F6A.l
	beq.w	.l11550
	tst.w	(goaliemode2).l
	bra.w	.l11556
.l11550	tst.w	(goaliemode1).l
.l11556	beq.w	.l11560
	movea.l	#auto,a1
.l11560	jsr	(printsmall).l
	movea.l	(sp)+,a1
	adda.w	(a1),a1
	bra.w	.l11574
.l1156E	jsr	(printsmall).l
.l11574	rts
	dc.w	$0014,$2020,$4D61,$6E75,$616C,$2047,$6F61,$6C69
	dc.w	$6520,$2020,$0014,$2020,$2041,$7574,$6F20,$476F
	dc.w	$616C,$6965,$2020,$2020,$48E7,$E0C0,$3F39,$0001
	dc.w	$8D64,$08F9,$0002,$0001,$8D64,$227C,$0001,$7FB2
	dc.w	$D2C0,$7401,$4EB9,$0003,$8BD4,$720A,$0839,$0007
	dc.w	$00FF,$800E,$66F6,$33D9,$00FF,$8022,$33FC,$000D
	dc.w	$00FF,$8020,$08F9,$0006,$00FF,$800F,$0839,$0006
	dc.w	$00FF,$800E,$67F6,$08F9,$0007,$00FF,$800F,$08B9
	dc.w	$0006,$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6
	dc.w	$08B9,$0007,$00FF,$800F,$51C9,$FFB2,$0679,$0001
	dc.w	$0001,$8D5A,$51CA,$FF9E,$0679,$000B,$0001,$8D58
	dc.w	$0479,$0002,$0001,$8D5A,$33DF,$0001,$8D64,$4CDF
	dc.w	$0307,$4E75
MenuWaitVblank
	move.w	d0,-(sp)
	move.w	(OldVcount).l,d0
	move.w	(OldVcount).l,d0
.l11648	cmp.w	(ScoutSubStatus).l,d0
	beq.w	.l11648
	move.w	(OldVcount).l,(ScoutSubStatus).l
	move.w	(sp)+,d0
	rts
	dc.w	$7006,$721A,$6100,$20C2,$4EB9,$0003,$8F6E,$0006
	dc.w	$BD05,$0000,$701E,$7206,$4EB9,$0003,$8CA0,$4EB9
	dc.w	$0003,$9258,$000E,$BD0E,$0353,$636F,$7265,$73BD
	dc.w	$0B01
	movea.l	(ScoresMap).l,a1
	lea.l	$8(a1),a2
	adda.l	$4(a1),a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	$2(a1),d3
	clr.w	d5
	jsr	(dobitmap).l
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$4,$0
	clr.w	(VertLineScrolling).l
	bsr.w	X_1176C
	jsr	(GetShifter).l
	move.w	d1,d3
	ble.w	.l116DE
.l116D6	bsr.w	X_1182E
	dbra	d3,.l116D6
.l116DE	clr.w	(SelectedPlayerIdx).l
	move.w	(printy).l,d0
	subi.w	#$15,d0
	bmi.w	.l116FE
	asl.w	#$3,d0
	move.w	d0,(SelectedPlayerIdx).l
	bsr.w	X_118D4
.l116FE	bsr.w	MenuWaitVblank
	bsr.w	X_142F0
	btst	#$7,d3
	bne.w	X_13980
	moveq	#-2,d0
	btst	#$0,d3
	bne.w	.l11722
	neg.w	d0
	btst	#$1,d3
	beq.w	.l11728
.l11722	move.w	d0,(PlayerScrollCtr).l
.l11728	bsr.w	UpdateScoresScroll
	bra.w	.l116FE
UpdateScoresScroll						;Called every frame by ShowScores: add PlayerScrollCtr to
									;VertLineScrolling (0 ... SelectedPlayerIdx), stop
									;on a 24 line boundary (DrawScrollArrows). Falls into UpdateVertScrollReg
	move.w	(PlayerScrollCtr).l,d0
	beq.w	X_14988
	add.w	(VertLineScrolling).l,d0		;new position
	bmi.w	X_14988		;would pass the top: stop
	cmp.w	(SelectedPlayerIdx).l,d0
	bgt.w	X_14988		;would pass the bottom: stop
	move.w	d0,(VertLineScrolling).l
	ext.l	d0
	divu.w	#$18,d0		;3 rows of 8 pixels
	swap	d0
	tst.w	d0
	bne.w	X_1176C		;not on a 3 row boundary yet
	bsr.w	X_118D4
	clr.w	(PlayerScrollCtr).l
	dc.w	$3F39,$0001,$8D64,$08F9,$0002,$0001,$8D64,$207C
	dc.w	$00C0,$0000,$0839,$0007,$00FF,$800E,$66F6,$23FC
	dc.w	$4002,$0010,$00FF,$8022,$33FC,$000B,$00FF,$8020
	dc.w	$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF,$800E
	dc.w	$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007
	dc.w	$00FF,$800F,$303C,$FFD0,$D079,$0001,$A450,$0839
	dc.w	$0007,$00FF,$800E,$66F6,$33C0,$00FF,$8022,$33FC
	dc.w	$000D,$00FF,$8020,$08F9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$67F6,$08F9,$0007,$00FF,$800F
	dc.w	$08B9,$0006,$00FF,$800F,$0839,$0006,$00FF,$800E
	dc.w	$66F6,$08B9,$0007,$00FF,$800F,$33DF,$0001,$8D64
	dc.w	$4E75,$B679,$0001,$8A98,$6700,$3152,$7010,$C0C3
	dc.w	$207C,$0001,$8A18,$D0C0,$0828,$0001,$000E,$6600
	dc.w	$313C,$0828,$0002,$000E,$6600,$3132,$3028,$0002
	dc.w	$3228,$000C,$6100,$003C,$0679,$0001,$0001,$8D5A
	dc.w	$3028,$0000,$3228,$000A,$6100,$0028,$3028,$0008
	dc.w	$0440,$0001,$227C,$0004,$1A34,$33FC,$001C,$0001
	dc.w	$8D58,$4EB9,$0003,$CEBE,$0679,$0002,$0001,$8D5A
	dc.w	$4E75
PrintGameInfo						;Print team d0's name (TeamList) at x 6 and score d1 (2 digits) at x $18
	movea.l	#TeamList,a1
	asl.w	#$2,d0
	movea.l	(a1,d0.w),a1
	adda.w	$4(a1),a1
	move.w	#$6,(printx).l
	jsr	(print).l
	move.w	#$18,(printx).l
	move.w	d1,d0
	moveq	#$2,d1		;2 digits
	jsr	(PushNumberWidth).l
	jmp	(print).l
	dc.w	$48E7,$C040,$4EB9,$0003,$8D8C,$000A,$F804,$0304
	dc.w	$06F9,$0100
	clr.w	d0
	move.w	(VertLineScrolling).l,d1
	tst.w	d1
	sgt.b	d0
	neg.b	d0
	cmp.w	(SelectedPlayerIdx).l,d1
	slt.b	d1
	neg.b	d1
	add.b	d1,d0
	add.b	d1,d0
	lea.l	X_11914(pc),a1
	jsr	(Fprintsmall).l
	movem.l	(sp)+,d0-d1/a1
	rts
	dc.w	$000A
	dc.w	$20FB,$FFFA,$1320,$F900,$000A,$7BFB,$FFFA,$1320
	dc.w	$F900,$000A,$20FB,$FFFA,$137D,$F900,$08EA,$0000
	dc.w	$0032,$7000,$721C,$6100,$1DEA,$4279,$0001,$A44E
	dc.w	$4279,$0001,$A452,$33FC,$0001,$0001,$A45A,$4EB9
	dc.w	$0003,$8D8C,$0008,$FF02,$FD00,$FC00,$7028,$721C
	dc.w	$343C,$07FF,$4EB9,$0003,$8C06,$50F9,$0001,$7F60
	dc.w	$6100,$0508
LineEditorMenu						;Slot cursor loop: start exits, C picks a player for the slot
									;(SelectLinePlayer), up / down /
									;left / right move the slot cursor (LineCursorTable). Also entered from
									;SelectLinePlayer when it is done
	bsr.w	X_11DE8
	bsr.w	DrawLineIcons
.loop	bsr.w	MenuWaitVblank		;wait for the next frame
	bsr.w	X_142F0		;read the pads
	jsr	(ProcessInputWithRepeat).l
	btst	#$7,d1		;start: exit menu
	bne.w	X_11F08
	btst	#$5,d1		;C: pick a player for this slot
	bne.w	SelectLinePlayer		;C: pick a player for the slot
	moveq	#$1,d0
	btst	#$1,d1		;down?
	bne.w	.move
	moveq	#-1,d0
	btst	#$0,d1		;up?
	bne.w	.move
	moveq	#$8,d0		;right: next line (8 slots per line)
	btst	#$3,d1		;right?
	bne.w	.move
	moveq	#-8,d0		;left: previous line
	btst	#$2,d1		;left?
	beq.w	.loop
.move	add.w	(TestList).l,d0		;d0 = tentative new slot
	tst.w	(OptLine).l
	beq.w	.set		;manual lines off: free movement
	cmpi.w	#$1,d0
	blt.w	.loop		;OptLine set: only slots 1-5
	cmpi.w	#$5,d0
	bgt.w	.loop
.set	lea.l	X_11EC0(pc),a0		;the slot after the move
	move.b	$8(a0,d0.w),$1A45B.l		;wrap/skip through the table
	bsr.w	DrawLineIcons
	bra.w	.loop
SelectLinePlayer						;Line editor: C pressed on slot TestList. Build the list of players that
									;can go in the slot in Satt (roster order is goalies, forwards, defense)
									;and let the user pick one (left / right pages the attribute columns). C
									;stores the pick with SetLineSlot, start goes back. Both return to
									;LineEditorMenu
	bsr.w	X_13D60
	move.w	d0,d1		;d1 = first forward
	bsr.w	X_13DA0
	move.w	(TestList).l,d2
	andi.w	#$7,d2		;slot within the line
	cmpi.w	#$2,d2
	bgt.w	.n		;slots 3-5 (forwards): after the goalies
	add.w	d0,d1		;slots 1-2 (defense): after goalies+forwards
	bsr.w	X_13DBC
	sub.w	d1,d0		;d0 = candidates, d1 = first roster index
.n	subi.w	#$1,d0		;count - 1 for dbf
	move.w	d0,(screentimer).l		;last candidate row (also the dbf count)
	clr.w	(PlayerScrollCtr).l
	clr.w	(VertLineScrolling).l
	movea.l	#Satt,a0
	clr.w	d2
.fill	move.b	d1,(a0,d2.w)		;store the roster index
	cmp.w	d1,d6		;player now in the slot?
	bne.w	.nc
	move.w	d2,(VertLineScrolling).l		;start the cursor on him
.nc	addi.w	#$1,d1		;next candidate
	addi.w	#$1,d2
	dbra	d0,.fill
	bsr.w	X_11E66		;clear the top area
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$0,$3,$1,$0
	dc.w	$7012,$7203,$4EB9,$0003,$8CA0,$4EB9,$0003,$8D8C
	dc.w	$0006,$FD15,$FC00
	moveq	#$12,d0
	moveq	#$3,d1
	jsr	(Framer).l		;draw the frame
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$2,$1,'{Select  Player}'
	clr.w	d0		;draw the list with the cursor
	bra.w	.vert
.loop	bsr.w	MenuWaitVblank		;wait for the next frame
	bsr.w	X_142F0		;read the pads
	jsr	(ProcessInputWithRepeat).l
	btst	#$7,d1		;start: back to slot cursor
	bne.w	LineEditorMenu
	btst	#$5,d1		;C: take this player
	bne.w	.pick
	moveq	#$1,d0
	btst	#$1,d1
	bne.w	.vert
	btst	#$3,d1		;right: next attribute page
	bne.w	.horz
	moveq	#-1,d0
	btst	#$0,d1
	bne.w	.vert
	btst	#$2,d1		;left: previous attribute page
	bne.w	.horz
	bra.w	.loop
.horz	add.w	(scoutcolumn).l,d0		;change attribute page (not below 0)
	bmi.w	.loop		;below 0: ignore
	move.w	d0,(scoutcolumn).l
	bsr.w	X_11B74
	bra.w	.loop
.vert	add.w	(VertLineScrolling).l,d0		;Cursor row 0..screentimer
	bmi.w	.loop		;above the top: ignore
	cmp.w	(screentimer).l,d0		;past the last?
	bgt.w	.loop
	move.w	d0,(VertLineScrolling).l
	cmp.w	(PlayerScrollCtr).l,d0		;above the first row shown?
	bgt.w	.top
	move.w	d0,(PlayerScrollCtr).l		;scroll up to it
.top	subi.w	#$5,d0		;6 rows shown
	cmp.w	(PlayerScrollCtr).l,d0		;below the last row shown?
	ble.w	.draw
	move.w	d0,(PlayerScrollCtr).l		;scroll down to it
.draw	bsr.w	X_11B74
	bra.w	.loop
.pick	movea.l	#Satt,a3		;C: chosen row's roster index
	adda.w	(VertLineScrolling).l,a3
	move.b	(a3),d0
	addi.b	#$1,d0		;SetLineSlot wants 1 based
	move.w	(TestList).l,d2
	bsr.w	X_11FAE		;put the picked player in the slot
	bra.w	LineEditorMenu		;back to the slot cursor
	dc.w	$4EB9,$0003,$8F6E,$0006,$BE16,$0100
.l11B80	movea.l	#PAttribColumns,a1
	move.w	(scoutcolumn).l,d0
	bra.w	.l11B96
	adda.w	(a1),a1
	adda.w	#$4,a1
.l11B96	tst.w	(a1)
	dbmi	d0,$11B90
	bpl.w	X_11BAC
	subi.w	#$1,(scoutcolumn).l
	bra.w	.l11B80
	dc.w	$4EB9,$0003,$8F80,$2811,$267C,$000B,$BD30,$3439
	dc.w	$0001,$A452,$3239,$0001,$A458,$9242,$0C41,$0005
	dc.w	$6300,$0004,$7205,$33FC,$0002,$0001,$8D5A,$4EB9
	dc.w	$0003,$8D8C,$0020,$FE04,$FD05,$FA01,$2020,$2020
	dc.w	$2020,$2020,$2020,$2020,$2020,$2020,$2020,$2020
	dc.w	$2020,$FD05
	cmp.w	(VertLineScrolling).l,d2
	bne.w	.l11C10
	move.w	d7,(printa).l
.l11C10	clr.w	d0
	move.b	(a3,d2.w),d0
	bsr.w	X_1256A
	addi.w	#$1,d2
	dbra	d1,X_11BDA
	rts
DrawLineIcons						;Line editor: draw the line icons for the cursor's line (LineIconGroups
									;bit masks, DrawLineIcon), then the selected player box
	moveq	#$6,d5		;7 lines
	lea.l	X_11CB7(pc),a0
	move.w	(TestList).l,d0
	lsr.w	#$3,d0		;line number
	adda.w	d0,a0		;this line's group
	tst.w	(OptLine).l
	beq.w	.0
	suba.w	#$1,a0		;OptLine set: table starts one byte earlier
.0	move.b	(a0),d0		;group mask for this line
	cmp.b	(redrawicons).l,d0
	beq.w	.line		;same group as last time: no clear
	move.b	d0,(redrawicons).l
	bsr.w	X_11D7A
.line	btst	d5,(redrawicons).l		;Line d5 in this group?
	beq.w	.l11C66
	bsr.w	DrawLineIcon
.l11C66	dbra	d5,.line
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$8,$7,CC_SetFont,$1
	dc.w	$7018,$7203,$4EB9,$0003,$8CA0,$4EB9,$0003,$8D8C
	dc.w	$0006,$FD15,$FC08
	move.w	d6,d0		;name of the cursor slot's player
	jsr	(getname).l
	move.w	(a1),d0
	lsr.w	#$1,d0
	sub.w	d0,(printx).l		;...used to centre it
	move.w	d7,(printa).l
	jsr	(printsmall).l		;print it
	clr.w	(printfontset).l
	rts
	btst	d0,d7
	btst	d3,d7
	move.b	(a0)+,d4
	bra.b	X_11D1E
DrawLineIcon						;Line editor: draw line d5 (its name from linelist, then its player slots)
									;at LineIconPosTable (OptLine: the entry before)
	moveq	#$6,d0		;6 bytes per entry
	mulu.w	d5,d0
	lea.l	X_11E94(pc),a0		;position table
	adda.w	d0,a0
	tst.w	(OptLine).l
	beq.w	.0
	suba.w	#$6,a0		;OptLine set: use the entry before
.0	move.w	(a0),(printx).l		;x, y of the entry
	move.w	$2(a0),(printy).l
	move.w	d5,d0		;line name string index
	movea.l	#linelist,a1
	move.w	#$8000,(printa).l		;priority
	jsr	(Fprintsmall).l		;print the line name
	jsr	(printsmallz).l
	String	' Line'
	dc.w	$33D0,$0001,$8D58,$3805,$E744,$0644,$0001,$33E8
	dc.w	$0002,$0001,$8D5A,$3628,$0004,$47EA,$016C,$33D0
	dc.w	$0001,$8D58,$4EB9,$0003,$8D8C,$0008,$FBFF,$FA02
	dc.w	$FE06
	clr.w	d0
	move.b	(a3,d4.w),d0		;player in this slot
	subi.w	#$1,d0		;0-based
	jsr	(FormatPlayerNameShort).l
	cmp.w	(TestList).l,d4		;cursor slot?
	bne.w	.nocur
	move.w	d0,d6		;player in the cursor slot
	move.w	(printa).l,d7
	move.w	#$2,(printfontset).l		;highlight while printing
.nocur	jsr	(printsmall).l		;print it
	clr.w	(printfontset).l
	addi.w	#$1,d4
	dbra	d3,X_11D26
	rts
	dc.w	$4EB9,$0003,$8D8C,$0008,$FF02,$FD00,$FC0A
