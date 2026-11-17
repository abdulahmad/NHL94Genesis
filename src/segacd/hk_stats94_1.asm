	include	segacd\hockey.inc
	include	macros\genesis.mac

AddPenalty2	equ	$39456
AwGoals	equ	$186BE
CC_Font2	equ	$FE
CC_Font2Pri	equ	$BE
CC_Font3	equ	$FD
CC_Font3Pri	equ	$BD
CC_SetFont	equ	$F9
CC_SetMapAndPosition	equ	$F8
ClearPenalties	equ	$2B3A8
ClearPenaltyBuffer	equ	$39EE4
Crowdlevel	equ	$17CD2
EASportsBGMap	equ	$47D0C
ExitToOpening	equ	$3F2BE
FourWayPlay	equ	$18BF8
Fprintsmall	equ	$3CEBE
Framer	equ	$38CA0
GetForwardCount	equ	$2EDA0
GetGoalieCount	equ	$2ED60
HmGoals	equ	$18358
LOAD	equ	$1B000
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
goaliemode1	equ	$18C0C
goaliemode2	equ	$18C0E
linelist	equ	$419F6
manual	equ	$2C576
menudraw	equ	$18ADA
menulist	equ	$18AD6
move	equ	$2C9C8
null	equ	$1B008
palcount	equ	$18D62
pausepad	equ	$17F94
print	equ	$38F80
printa	equ	$18D5C
printbigz	equ	$39258
printsmall	equ	$38D9E
printsmallz	equ	$38D8C
printx	equ	$18D58
printy	equ	$18D5A
printz	equ	$38F6E
puckx	equ	$17B80
redrawicons	equ	$17F60
sbut	equ	$7
scoutcolumn	equ	$1A44E
screentimer	equ	$1A458
sfx	equ	$3710C
stop_current_song	equ	$47DB0
swap	equ	$2779A
tmstruct	equ	$1834C
X_11022	equ	$11022
X_11034	equ	$11034
X_1104C	equ	$1104C
X_11060	equ	$11060
X_1149C	equ	$1149C
X_1159E	equ	$1159E
X_1176C	equ	$1176C
X_118D4	equ	$118D4
X_11CB7	equ	$11CB7
X_11D7A	equ	$11D7A
X_11E66	equ	$11E66
X_11E94	equ	$11E94
X_11EC0	equ	$11EC0
X_11F08	equ	$11F08
X_1256A	equ	$1256A
X_13728	equ	$13728
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
	bsr.w	EndDemoOnPress
	jsr	(ReadJoy2).l
	btst	#$7,d1
	bne.w	X_11034
	tst.w	(FourWayPlay).l
	beq.w	EndDemoOnPress
	jsr	(ReadJoy3).l
	btst	#$7,d1
	bne.w	X_1104C
	bsr.w	EndDemoOnPress
	jsr	(ReadJoy4).l
	btst	#$7,d1
	bne.w	X_11060
EndDemoOnPress
	tst.w	d1
	beq.w	X_14988
	jmp	(ExitToOpening).l
	clr.w	(pausepad).l
	bclr	#$1,$17F6A.l
	bra.w	.l11042
	clr.w	(pausepad).l
	bset	#$1,$17F6A.l
.l11042	bset	#$0,$17F6A.l
	rts
	move.w	#$3,(pausepad).l
	bclr	#$1,$17F6A.l
	dc.w	$6000,$FFE4,$33FC,$0004,$0001,$7F94,$08F9,$0001
	dc.w	$0001,$7F6A,$6000,$FFD0,$4EB9,$0003,$6D0A,$3F00
	dc.w	$3039,$0001,$7474,$B079,$0001,$7474,$6700,$FFF8
	dc.w	$301F,$4EB9,$0004,$7DAC,$3F39,$0001,$7F6A,$6100
	dc.w	$022C,$207C,$0004,$1F50,$43FA,$0152,$0839,$0000
	dc.w	$0001,$7F78,$6700,$000C,$207C,$0004,$1EB4,$6000
	dc.w	$0012,$082A,$0002,$0032,$6700,$0008,$207C,$0004
	dc.w	$20DC,$6100,$0228,$6100,$0566,$6100,$3218,$4EB9
	dc.w	$0003,$E1CE,$4EB9,$0003,$74BE,$6100,$0280,$6600
	dc.w	$FFE6,$4EB9,$0003,$6D0A,$33DF,$0001,$7F6A,$0839
	dc.w	$0007,$0001,$7F6A,$6700,$0012,$4EB9,$0003,$ECB8
	dc.w	$4EB9,$0003,$C40A,$6000,$0008,$4EB9,$0003,$C3AC
	dc.w	$207C,$00C0,$0000,$0839,$0007,$00FF,$800E,$66F6
	dc.w	$33FC,$9100,$00FF,$8022,$33FC,$000A,$00FF,$8020
	dc.w	$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF,$800E
	dc.w	$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007
	dc.w	$00FF,$800F,$0839,$0007,$00FF,$800E,$66F6,$33FC
	dc.w	$9200,$00FF,$8022,$33FC,$000A,$00FF,$8020,$08F9
	dc.w	$0006,$00FF,$800F,$0839,$0006,$00FF,$800E,$67F6
	dc.w	$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF,$800F
	dc.w	$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007,$00FF
	dc.w	$800F,$08F9,$0003,$0001,$8D64,$08B9,$0000,$0001
	dc.w	$7F6A,$4EB9,$0003,$C48C,$4EB9,$0003,$DD16,$33FC
	dc.w	$0018,$0001,$8D62,$4A79,$0001,$8D62,$6A00,$FFF8
	dc.w	$33F9,$0001,$7474,$0001,$7476,$4E75,$207C,$00C0
	dc.w	$0000,$0839,$0007,$00FF,$800E,$66F6,$33FC,$9100
	dc.w	$00FF,$8022,$33FC,$000A,$00FF,$8020,$08F9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$67F6,$08F9
	dc.w	$0007,$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F
	dc.w	$0839,$0007,$00FF,$800E,$66F6,$33FC,$921C,$00FF
	dc.w	$8022,$33FC,$000A,$00FF,$8020,$08F9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$67F6,$08F9,$0007
	dc.w	$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839,$0006
	dc.w	$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F,$4EB9
	dc.w	$0003,$C40A,$4EB9,$0003,$DD16,$4EB9,$0004,$8208
	dc.w	$4EB9,$0003,$8D8C,$0008,$FF03,$FD00,$FC00,$7020
	dc.w	$721C,$343C,$07FF,$4EF9,$0003,$8C06
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
	dc.w	$8AD2,$4279,$0001,$8AD4
DrawMenuScreen
	movea.l	(menudraw).l,a0
	jsr	(a0)
	jsr	(printsmallz).l
	String	CC_Font2,$4,$FC,$C
	bsr.w	SetMenuPrintX
	moveq	#$16,d0
	moveq	#$6,d1
	jsr	(Framer).l
	bsr.w	Pausemode_Pmenu
	move.w	#$18,(palcount).l
	tst.w	(palcount).l
	dc.w	$6A00,$FFF8,$4E75
SetMenuPrintX
	move.w	#$5,(printx).l
	btst	#$1,(disflags).l
	bne.w	X_14988
	addi.w	#$4,(printx).l
	rts
HandleMenuInput
	btst	#$7,d1
	bne.w	.l113DE
	btst	#$1,d1
	beq.w	.l11384
	addi.w	#$1,$18AD2.l
	bra.w	Pausemode_Pmenu
.l11384	btst	#$0,d1
	beq.w	.l11398
	subi.w	#$1,$18AD2.l
	bra.w	Pausemode_Pmenu
.l11398	btst	#$5,d1
	beq.w	.l113DE
	bsr.w	seta2
	move.w	$18AD2.l,d0
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
	bsr.w	DrawMenuScreen
.l113D6	tst.w	$18AD2.l
	rts
.l113DE	eori.b	#$4,ccr
	rts
Pausemode_Pmenu
	move.w	$18AD2.l,d0
	bpl.w	.l113F6
	clr.w	$18AD2.l
	clr.w	d0
.l113F6	movea.l	(menulist).l,a0
	adda.w	(a0),a0
	adda.w	(a0),a0
	bra.w	.l1140E
	adda.w	(a0),a0
	adda.w	#$4,a0
	tst.w	$2(a0)
.l1140E	dbmi	d0,$11404
	addi.w	#$1,d0
	sub.w	d0,$18AD2.l
	move.w	$18AD2.l,d0
	cmp.w	$18AD4.l,d0
	bge.w	.l11432
	move.w	d0,$18AD4.l
.l11432	subi.w	#$3,d0
	cmp.w	$18AD4.l,d0
	ble.w	.l11446
	move.w	d0,$18AD4.l
.l11446	bsr.w	SetMenuPrintX
	move.w	#$D,(printy).l
	movea.l	(menulist).l,a1
	jsr	(printsmall).l
	jsr	(printsmallz).l
	dc.w	$0026
	dc.b	$FB,$01,$20,$FB,$FF,$FA,$01,$20,$FB,$FF,$FA,$01,$20,$FB,$FF,$FA,$01,$20,$FB,$12,$20,$FB,$FF,$FA,$FF,$20,$FB,$FF,$FA,$FF,$20,$FB,$FF,$FA,$FF,$20
	adda.w	(a1),a1
	move.w	$18AD4.l,d0
	bra.w	X_1149C
	dc.w	$D2D1,$D2FC,$0004,$51C8,$FFF8,$7203,$33FC,$000C
	dc.w	$0001,$8D5A,$6100,$FE9E,$3039,$0001,$8AD4,$6700
	dc.w	$0014,$4EB9,$0003,$8D8C,$000C,$FE05,$FB01,$FA01
	dc.w	$7BFA,$FF00,$6100,$FE7E,$4EB9,$0003,$8D8C,$0006
	dc.w	$FB02,$FA01,$2F09,$2279,$0001,$8AD6,$4EB9,$0003
	dc.w	$8D9E,$B079,$0001,$8AD2,$6600,$0008,$4EB9,$0003
	dc.w	$8D9E,$225F,$4EB9,$0002,$C528,$0640,$0001,$D2FC
	dc.w	$0004,$4A69,$0002,$5BC9,$FFBC,$6B00,$0014,$6100
	dc.w	$FE34,$4EB9,$0003,$8D8C,$0008,$FE05,$FB01,$7D00
	dc.w	$4E75
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
PutTeamBlock
	dc.w	$0014,$2020
	dc.w	$4D61
	dc.w	$6E75
	dc.w	$616C
	dc.w	$2047
	dc.w	$6F61
	dc.w	$6C69
	dc.w	$6520
	dc.w	$2020
	dc.w	$0014,$2020
	dc.w	$2041
	dc.w	$7574
	dc.w	$6F20
	dc.w	$476F
	dc.w	$616C
	dc.w	$6965
	dc.w	$2020
	dc.w	$2020
	dc.w	$48E7,$E0C0
	dc.w	$3F39,$0001,$8D64
.l115A8	dc.w	$08F9,$0002,$0001,$8D64
	dc.w	$227C,$0001,$7FB2
	dc.w	$D2C0
	dc.w	$7401
.l115BA	dc.w	$4EB9,$0003,$8BD4
	dc.w	$720A
.l115C2	dc.w	$0839,$0007,$00FF,$800E
	dc.w	$66F6
	dc.w	$33D9,$00FF,$8022
	dc.w	$33FC,$000D,$00FF,$8020
	dc.w	$08F9,$0006,$00FF,$800F
.l115E2	dc.w	$0839,$0006,$00FF,$800E
	dc.w	$67F6
.l115EC	dc.w	$08F9,$0007,$00FF,$800F
	dc.w	$08B9,$0006,$00FF,$800F
.l115FC	dc.w	$0839,$0006,$00FF,$800E
.l11604	dc.w	$66F6
	dc.w	$08B9,$0007,$00FF,$800F
	dc.w	$51C9,$FFB2
	dc.w	$0679,$0001,$0001,$8D5A
	dc.w	$51CA,$FF9E
	dc.w	$0679,$000B,$0001,$8D58
	dc.w	$0479,$0002,$0001,$8D5A
	dc.w	$33DF,$0001,$8D64
	dc.w	$4CDF,$0307
	dc.w	$4E75
MenuWaitVblank
	move.w	d0,-(sp)
	move.w	(OldVcount).l,d0
	move.w	(OldVcount).l,d0
.l11648	cmp.w	(ScoutSubStatus).l,d0
	beq.w	.l11648
	move.w	(OldVcount).l,(ScoutSubStatus).l
	move.w	(sp)+,d0
	rts
ShowScores						;"Scores" screen: the other games of the night in gstruct over the Scores
									;bitmap (ScoresMap); up / down scroll, start exits (ExitStatsScreen). Menu
									;item handler (menu lists)
	moveq	#$6,d0		;SetupScreen d0/d1: bitmap row offset / height
	moveq	#$1A,d1
	bsr.w	X_13728		;set up the screen
	jsr	(printz).l
	String	CC_Font3Pri,$5,$0
	moveq	#$1E,d0
	moveq	#$6,d1
	jsr	(Framer).l		;draw the frame
	jsr	(printbigz).l
	String	CC_Font3Pri,$E,$3,'Scores',CC_Font3Pri,$B,$1
	dc.w	$2279,$0004,$7D58,$45E9,$0008,$D3E9,$0004,$4240
	dc.w	$4241,$3411,$3629,$0002,$4245,$4EB9,$0003,$87E2
	dc.w	$4EB9,$0003,$8D8C,$0008,$F804,$0204,$0000,$4279
	dc.w	$0001,$A450,$6100,$00A4,$4EB9,$0004,$081C,$3601
	dc.w	$6F00,$000A,$6100,$0156,$51CB,$FFFA,$4279,$0001
	dc.w	$A454,$3039,$0001,$8D5A,$0440,$0015,$6B00,$000E
	dc.w	$E740,$33C0,$0001,$A454,$6100,$01D8,$6100,$FF3A
	dc.w	$6100,$2BEC,$0803,$0007,$6600,$2274,$70FE,$0803
	dc.w	$0000,$6600,$000C,$4440,$0803,$0001,$6700,$0008
	dc.w	$33C0,$0001,$A452,$6100,$0006,$6000,$FFD0
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
	dc.w	$06F9,$0100,$4240,$3239,$0001,$A450,$4A41,$5EC0
	dc.w	$4400,$B279,$0001,$A454,$5DC1,$4401,$D001,$D001
	dc.w	$43FA,$000E,$4EB9,$0003,$CEBE,$4CDF,$0203,$4E75
	dc.w	$000A,$20FB,$FFFA,$1320,$F900,$000A,$7BFB,$FFFA
	dc.w	$1320,$F900,$000A,$20FB,$FFFA,$137D,$F900,$08EA
	dc.w	$0000,$0032,$7000,$721C,$6100,$1DEA,$4279,$0001
	dc.w	$A44E,$4279,$0001,$A452,$33FC,$0001,$0001,$A45A
	dc.w	$4EB9,$0003,$8D8C,$0008,$FF02,$FD00,$FC00,$7028
	dc.w	$721C,$343C,$07FF,$4EB9,$0003,$8C06,$50F9,$0001
	dc.w	$7F60,$6100,$0508
LineEditorMenu						;Slot cursor loop: start exits, C picks a player for the slot
									;(SelectLinePlayer), up / down /
									;left / right move the slot cursor (LineCursorTable). Also entered from
									;SelectLinePlayer when it is done
	bsr.w	DrawTeamScreen
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
	bsr.w	GetGoalieCount-LOAD
	move.w	d0,d1		;d1 = first forward
	bsr.w	GetForwardCount-LOAD
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
	dc.w	$0006,$FD15,$FC00,$7012,$7203,$4EB9,$0003,$8CA0
	dc.w	$4EB9,$0003,$8D8C,$0018,$F804,$0202,$017B,$5365
	dc.w	$6C65,$6374,$2020,$506C,$6179,$6572,$7D00,$4240
	dc.w	$6000,$0060,$6100,$FB88,$6100,$283A,$4EB9,$0003
	dc.w	$74BE,$0801,$0007,$6600,$FEB6,$0801,$0005,$6600
	dc.w	$0088,$7001,$0801,$0001,$6600,$0038,$0801,$0003
	dc.w	$6600,$0018,$70FF,$0801,$0000,$6600,$0026,$0801
	dc.w	$0002,$6600,$0006,$6000,$FFBC,$D079,$0001,$A44E
	dc.w	$6B00,$FFB2,$33C0,$0001,$A44E,$6100,$006C,$6000
	dc.w	$FFA4,$D079,$0001,$A450,$6B00,$FF9A,$B079,$0001
	dc.w	$A458,$6E00,$FF90,$33C0,$0001,$A450,$B079,$0001
	dc.w	$A452,$6E00,$0008,$33C0,$0001,$A452,$0440,$0005
	dc.w	$B079,$0001,$A452,$6F00,$0008,$33C0,$0001,$A452
	dc.w	$6100,$0026,$6000,$FF5E,$267C,$000B,$BD30,$D6F9
	dc.w	$0001,$A450,$1013,$0600,$0001,$3439,$0001,$A45A
	dc.w	$6100,$0440,$6000,$FE08
PrintAttribHeader						;Line editor player list: the column header of attribute page
									;DispAttribCtr, then 6 rows of names and that attribute, the selected row
									;highlighted
	jsr	(printz).l
	String	CC_Font2Pri,$16,$1
.top	movea.l	#PAttribColumns,a1		;list of column entries: word length, 4 byte flags, text
	move.w	(scoutcolumn).l,d0
	bra.w	.2
	adda.w	(a1),a1
	adda.w	#$4,a1
.2	tst.w	(a1)		;Negative = end of list
	dbmi	d0,$11B90
	bpl.w	.found
	subi.w	#$1,(scoutcolumn).l		;past the last page: back one
	bra.w	.top
.found	jsr	(print).l
	move.l	(a1),d4		;column flags for GetNameandAttrib
	movea.l	#Satt,a3
	move.w	(PlayerScrollCtr).l,d2		;d2 = first row shown
	move.w	(screentimer).l,d1
	sub.w	d2,d1		;rows below the first shown
	cmpi.w	#$5,d1
	bls.w	.4
	moveq	#$5,d1		;at most 6 rows
.4	move.w	#$2,(printy).l
.row	jsr	(printsmallz).l
	dc.w	$0020
	dc.b	$FE,$04,$FD,$05,$FA,$01,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$FD,$05
	cmp.w	(VertLineScrolling).l,d2		;cursor row?
	bne.w	.5
	move.w	d7,(printa).l		;use the highlight attribute
.5	clr.w	d0
	move.b	(a3,d2.w),d0		;roster index
	bsr.w	X_1256A		;print his name and attributes
	addi.w	#$1,d2
	dbra	d1,.row
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
	dc.w	$0006,$FD15,$FC08,$3006,$4EB9,$0004,$112E,$3011
	dc.w	$E248,$9179,$0001,$8D58,$33C7,$0001,$8D5C,$4EB9
	dc.w	$0003,$8D9E,$4279,$0001,$8D60,$4E75,$0107,$0707
	dc.w	$1818,$6060
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
	dc.w	$FE06,$4240,$1033,$4000,$0440,$0001,$4EB9,$0004
	dc.w	$1226,$B879,$0001,$A45A,$6600,$0012,$3C00,$3E39
	dc.w	$0001,$8D5C,$33FC,$0002,$0001,$8D60,$4EB9,$0003
	dc.w	$8D9E,$4279,$0001,$8D60,$0644,$0001,$51CB,$FFB0
	dc.w	$4E75,$4EB9,$0003,$8D8C,$0008,$FF02,$FD00,$FC0A
	dc.w	$7028,$7212,$343C,$07FF,$4EB9,$0003,$8C06,$33F9
	dc.w	$0002,$CE96,$0001,$8D5A,$33F9,$0002,$CE94,$0001
	dc.w	$8D58,$4A79,$0001,$8C0A,$6700,$000C,$33F9,$0002
	dc.w	$CE8E,$0001,$8D58,$4EB9,$0003,$8D8C,$0022,$FE04
	dc.w	$FBFD,$FA02,$4C44,$FBFE,$FA02,$5244,$FBFE,$FA02
	dc.w	$4C57,$FBFE,$FA02,$4320,$FBFE,$FA02,$5257,$4E75
DrawTeamScreen						;Line editor background: bitmap (EASportsBGMap), frame, "Line Editor"
									;title and
									;the team logo map (PutTeamBlock)
	bsr.w	X_11E66
	movem.l	d0-d5/a0-a2,-(sp)
	jsr	(printz).l
	String	CC_Font3,$0,$0
	movea.l	(EASportsBGMap).l,a1
	adda.l	$4(a1),a1
	movea.l	#null,a2		;a2 saved/restored around this block
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	$2(a1),d3
	moveq	#$1,d4
	moveq	#$0,d5
	jsr	(dobitmap).l
	movem.l	(sp)+,d0-d5/a0-a2
	jsr	(printz).l
	String	CC_Font2Pri,$7,$1
	moveq	#$1A,d0
	moveq	#$6,d1
	jsr	(Framer).l		;draw the frame
	jsr	(printbigz).l
	String	CC_Font2Pri,$A,$4,'Line Editor',CC_Font2Pri,$E,$1
	clr.w	d0		;map offset: home 0, away $2C
	cmpa.l	#$1834C,a2		;home team?
	beq.w	X_1159E
	moveq	#$2C,d0
	bra.w	X_1159E
