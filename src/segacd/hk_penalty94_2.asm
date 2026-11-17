	include	segacd\hockey.inc
	include	macros\genesis.mac

CC_Font1	equ	$FF
CC_Font1Pri	equ	$BF
CC_Font2	equ	$FE
CC_Font2Pri	equ	$BE
ConvertByteToDigits	equ	$412A8
Crowdlevel	equ	$17CD2
CwdExciteLvl	equ	$17CD8
DecompressGraphicsPlain	equ	$38958
DoHiLights	equ	$3CED2
EASNcset	equ	$18D50
EASportsMap	equ	$47D4C
EnergyBarMap	equ	$47D40
ExtraChars	equ	$18D56
Framer	equ	$38CA0
GetLowestPen	equ	$3A0A6
GetShifter	equ	$4081C
Hscroll	equ	$17CF0
LOAD	equ	$1B000
NewTicker3	equ	$3CD3E
Oldrow	equ	$17CEC
OptLine	equ	$18C0A
OptPlayMode	equ	$18BFA
PerLabels	equ	$41A34
PerLabels2	equ	$41A48
PushNumber	equ	$3915E
PushNumberWidth	equ	$3919A
PushTime	equ	$390F4
PutTeamBlock	equ	$2C59E
ResetBench	equ	$3D6E2
Rinktilelist	equ	$47D18
ScoreSum	equ	$180EC
ScoreSumbytes	equ	$180F0
SortCords	equ	$17480
TeamList	equ	$1B00C
TextBuffer	equ	$17EF4
TickerNum	equ	$18ADE
UpdateRecords	equ	$25A4E
Vscroll	equ	$17CF2
WeightedRandomSelect	equ	$36BE2
ZamSprites	equ	$47D34
appstring	equ	$39208
awtmstruct	equ	$186B2
c1playernum	equ	$17F9E
c2playernum	equ	$17FA0
c3playernum	equ	$17FA2
c4playernum	equ	$17FA4
cont1team	equ	$17FA6
cont2team	equ	$17FA8
cont3team	equ	$17FAA
cont4team	equ	$17FAC
crowdnoisedelay	equ	$17F82
disflags	equ	$18D64
dobitmap	equ	$387E2
energybarchars	equ	$18D46
eraser	equ	$38C06
gameclock	equ	$180E6
gamelevel	equ	$18A9E
gamenum	equ	$18A98
lastplayer	equ	$17E2A
mesarea	equ	$17EF2
move	equ	$2C9C8
null	equ	$1B008
passReceiverPlayerNum	equ	$17E30
print	equ	$38F80
printa	equ	$18D5C
printbig	equ	$3926A
printx	equ	$18D58
printy	equ	$18D5A
printz	equ	$38F6E
priolist	equ	$41AD6
randomd0	equ	$37050
rinkvrcset	equ	$18D48
setc1player	equ	$312B8
setc2player	equ	$312DC
sfx	equ	$3710C
shotplayer	equ	$17E28
swap	equ	$2779A
tmstruct	equ	$1834C
waitxsr	equ	$37340
X_1AD28	equ	$1AD28
X_1AEF8	equ	$1AEF8
X_1B362	equ	$1B362
X_1B3C0	equ	$1B3C0
X_1E200	equ	$1E200
X_1F9BE	equ	$1F9BE
X_20FEA	equ	$20FEA
X_21000	equ	$21000
X_21548	equ	$21548
X_21B28	equ	$21B28
X_21D00	equ	$21D00
X_21E8C	equ	$21E8C
X_21EBE	equ	$21EBE
X_2403E	equ	$2403E

	org	$20DE8

puckglue
	move.w	#$7,-(sp)
	move.w	$52(a2),d0
	move.w	d0,$17BE0.l
	movea.l	#tmstruct,a0
	lea.l	$366(a0),a1
	btst	#$6,$62(a2)
	bne.w	.l20E0C
	exg.l	a0,a1
.l20E0C	st.b	$1A(a0)
	st.b	$1C(a0)
	bset	#$3,$32(a0)
	bclr	#$4,$17F6E.l
	beq.w	.l20E4E
	addi.w	#$1,$E(a1)
	addi.w	#$C8,(Crowdlevel).l
	move.w	#$C,(sp)
	cmpa.l	#$1834C,a1
	bne.w	.l20E4E
	addi.w	#$A,(CwdExciteLvl).l
	move.w	#$B,(sp)
.l20E4E	bsr.w	sfx-LOAD
	move.w	$52(a2),d0
	cmp.w	(passReceiverPlayerNum).l,d0
	bne.w	.l20E66
	addi.w	#$1,$14(a1)
.l20E66	st.b	(passReceiverPlayerNum).l
	bclr	#$2,$17F6A.l
	bclr	#$3,$17F6A.l
	tst.w	$34(a2)
	bne.w	.l20E9E
	bsr.w	ChkShotStat
	move.w	#$8C,$48(a2)
	cmpi.w	#$2F4,$58(a2)
	bne.w	.l20E9E
	move.w	#$5,$48(a2)
.l20E9E	cmp.w	(c1playernum).l,d0
	beq.w	X_21000
	cmp.w	(c2playernum).l,d0
	beq.w	X_21000
	tst.w	(cont3team).l
	beq.w	.l20EC6
	cmp.w	(c3playernum).l,d0
	beq.w	X_21000
.l20EC6	tst.w	(cont4team).l
	beq.w	.l20EDA
	cmp.w	(c4playernum).l,d0
	beq.w	X_21000
.l20EDA	tst.w	(cont3team).l
	bne.w	.l20EEE
	tst.w	(cont4team).l
	beq.w	.l20F16
.l20EEE	movem.l	d0/a3,-(sp)
	asl.w	#$7,d0
	movea.l	#SortCords,a3
	tst.w	$34(a3,d0.w)
	bne.w	.l20F12
	btst	#$3,$62(a3,d0.w)
	beq.w	.l20F12
	movem.l	(sp)+,d0/a3
	rts
.l20F12	movem.l	(sp)+,d0/a3
.l20F16	cmpi.w	#$6,d0
	slt.b	d1
	ext.w	d1
	addi.w	#$2,d1
	move.w	(lastplayer).l,d2
	cmp.w	(c2playernum).l,d2
	beq.w	.l20F42
	cmp.w	(cont1team).l,d1
	bne.w	.l20F42
	jmp	(setc1player).l
.l20F42	cmp.w	(cont2team).l,d1
	bne.w	.l20F52
	jmp	(setc2player).l
.l20F52	cmp.w	(cont1team).l,d1
	bne.w	X_21000
	jmp	(setc1player).l
puckbody
	btst	#$3,$64(a2)
	bne.w	X_21000
	cmpi.w	#$8,$18(a3)
	bgt.w	.l20F80
	move.w	d0,d1
	andi.w	#$F,d1
	bne.w	X_21000
.l20F80	bsr.w	X_1AD28
	move.w	#$24,-(sp)
	bsr.w	sfx-LOAD
	clr.w	$2C(a3)
	move.b	#$8,$5E(a2)
	move.w	$0(a3),d0
	sub.w	$0(a2),d0
	move.w	$14(a3),d1
	sub.w	$14(a2),d1
	bne.w	.l20FB0
	move.l	a2,-(sp)
	bsr.w	X_1B362
.l20FB0	move.w	$28(a3),d2
	move.w	$2A(a3),d3
	move.b	d0,$28(a3)
	move.b	d1,$2A(a3)
	bsr.w	X_1AEF8
	cmpi.w	#$8,$18(a3)
	ble.w	X_21000
	muls.w	d2,d2
	muls.w	d3,d3
	add.l	d3,d2
	cmpi.l	#$9000000,d2
	bls.w	X_20FEA
	cmpi.w	#$C,$18(a3)
	bgt.w	X_1F9BE
	rts
	bset	#$5,$62(a2)
	bne.w	.l21000
	move.w	#$10D0,d1
	exg.l	a2,a3
	bsr.w	X_1B3C0
	exg.l	a2,a3
.l21000	rts
	dc.w	$0839,$0004,$0001,$7F68,$6600,$FFF4,$4242,$0C6B
	dc.w	$0008,$0018,$6E00,$0006,$0642,$0002,$4440,$4441
	dc.w	$6100,$A2D4,$906A,$0054,$0240,$0007,$3200,$0241
	dc.w	$0003,$6600,$004E,$0839,$0007,$00FF,$800E,$66F6
	dc.w	$33FC,$001B,$00FF,$8020,$08F9,$0006,$00FF,$800F
	dc.w	$0839,$0006,$00FF,$800E,$67F6,$3039,$00FF,$8010
	dc.w	$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF,$800F
	dc.w	$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007,$00FF
	dc.w	$800F,$0240,$0004,$E448,$0A40,$0001,$D440,$D442
	dc.w	$41FA,$01AA,$3030,$2000,$720F,$D232,$0000,$41FA
	dc.w	$01A4,$082A,$0003,$0004,$6700,$0006,$0A42,$0002
	dc.w	$302A,$0006,$3F3C,$0197,$0C40,$0233,$6D00,$000A
	dc.w	$3EBC,$0292,$41FA,$017E,$905F,$1030,$0000,$E468
	dc.w	$0240,$0003,$08B9,$0002,$0001,$7F72,$6100,$073E
	dc.w	$6100,$9C44,$0C79,$3000,$0001,$7BAA,$6E00,$000E
	dc.w	$0C79,$D000,$0001,$7BAA,$6E00,$0018,$3F3C,$000B
	dc.w	$082A,$0006,$0062,$6700,$0006,$3EBC,$000D,$6100
	dc.w	$AFFA,$3F3C,$0024,$6100,$AFF2,$3439,$0001,$7BE0
	dc.w	$6B00,$0070,$50F9,$0001,$7BE0,$EF42,$207C,$0001
	dc.w	$7480,$D0C2,$117C,$0014,$005E,$33E8,$0052,$0001
	dc.w	$7E2A,$08B9,$0002,$0001,$7F6A,$08B9,$0003,$0001
	dc.w	$7F6A,$426B,$002C,$157C,$000A,$005E,$357C,$0004
	dc.w	$0046,$302B,$0000,$906A,$0000,$322B,$0014,$926A
	dc.w	$0014,$6600,$0008,$2F0A,$6100,$A1E6,$1740,$0028
	dc.w	$1741,$002A,$6000,$9D70,$08F9,$0002,$0001,$7F72
	dc.w	$4E75,$0C6A,$02F4,$0058,$6700,$FFB8,$7002,$D02A
	dc.w	$006C,$E140,$E340,$6100,$AEA6,$0640,$0C00,$D040
	dc.w	$6A00,$0006,$303C,$7FFF,$082A,$0001,$0063,$6600
	dc.w	$0040,$0C6B,$002C,$0000,$6E00,$0036,$0C6B,$FFD4
	dc.w	$0000,$6D00,$002C,$0C6B,$010E,$0014,$6E00,$0022
	dc.w	$0C6B,$FEF2,$0014,$6D00,$0018,$0C6B,$00D2,$0014
	dc.w	$6E00,$000C,$0C6B,$FF2E,$0014,$6E00,$0004,$E440
	dc.w	$B079,$0001,$7BA8,$6D00,$FF4A,$B079,$0001,$7BAA
	dc.w	$6D00,$FF40,$4440,$B079,$0001,$7BA8,$6E00,$FF34
	dc.w	$B079,$0001,$7BAA,$6E00,$FF2A,$082A,$0002,$0063
	dc.w	$6600,$FF20,$426B,$002C,$6000,$FBAC,$0073,$006E
	dc.w	$0070,$0072,$50F9,$0001,$7BE0,$303C,$1000,$6100
	dc.w	$ADF2,$3740,$002A,$303C,$1000,$6100,$ADE6,$3740
	dc.w	$0028,$303C,$1000,$6100,$ADE6,$3740,$002C,$6000
	dc.w	$9C86
makepde
	ext.w	d0
	move.w	d0,-(sp)
	movem.l	d1/a2-a3,-(sp)
	movea.l	a0,a3
	bsr.w	getpde
	btst	#$4,$17F7A.l
	beq.w	.l21292
	move.w	#$1000,d0
.l21292	movem.l	(sp)+,d1/a2-a3
	muls.w	(sp)+,d0
	asl.l	#$4,d0
	swap	d0
	ext.l	d0
	rts
getpde
	movea.l	#tmstruct,a2
	btst	#$6,$62(a3)
	beq.w	.l212B4
	adda.w	#$366,a2
.l212B4	move.b	$66(a3),d1
	ext.w	d1
	add.w	d1,d1
	move.w	$34(a2,d1.w),d0
	rts
	dc.w	$4A40,$6A00,$0004,$4240,$3580,$1034,$4E75
updatepwrplay						;show graphic and time remaining for power plays. Nothing when gmode2 bit
									;1 is set, and no song at the start of a home power
									;play (the gmode2 test is kept but both ways go to .uppt). Prints the time
									;and the team on the power play
	btst	#$1,$17F78.l
	bne.w	X_21000
	movea.l	#tmstruct,a2
	lea.l	$366(a2),a3		;tmsize
	move.w	$26(a2),d0		;tmap
	sub.w	$26(a3),d0		;players on ice: team 1 minus team 2
	beq.w	.clrpwrplay		;same number on the ice
	bpl.w	.t0		;team 1 has more
	btst	#$6,$17F6C.l		;sf2pwrtm: 0 home, 1 visitors
	bne.w	.upp
	bsr.w	.clrpwrplay		;power play team changed: remove the old display
	bset	#$6,$17F6C.l
	bra.w	.upp
.t0	exg.l	a2,a3		;a2 = shorthanded team 2, a3 = power play team 1
	btst	#$6,$17F6C.l
	beq.w	.upp
	bsr.w	.clrpwrplay
	bclr	#$6,$17F6C.l
.upp	bset	#$5,$17F6C.l		;sf2pwrplay
	bne.w	.uppt		;already showing a power play
	addi.w	#$1,$4(a3)		;tmPwrPlays
	cmpa.l	#$1834C,a3		;home team (93 played song $33 here)
	bne.w	.away
.home	bra.w	.uppt
.away	bra.w	.home
.uppt	bsr.w	printz-LOAD
	dc.w	$0012
	dc.b	$BF,$01,$19,$20,$20,$20,$16,$17,$18,$19,$BF,$01,$1A,$20,$20,$00
	bsr.w	GetLowestPen-LOAD		;d0 = time left
	bsr.w	PushTime-LOAD		;a1 = m:ss string
	bsr.w	print-LOAD
	movea.l	$1E(a3),a0		;tmdata
	movea.l	#mesarea,a3
	move.w	#$2,(a3)		;empty string in mesarea, then append the position string and name
	bsr.w	X_1E200
	String	CC_Font1Pri,$1,$19
	adda.w	$4(a0),a0		;team name
	adda.w	(a0),a0
	movea.l	a0,a1
	bsr.w	appstring-LOAD
	movea.l	a3,a1
	bra.w	print-LOAD
.clrpwrplay	bclr	#$5,$17F6C.l
	beq.w	X_21000
	bra.w	EASNLogo
ClrHor						;revert the graphics back to vertical ice rink mode. Reloads Rinktiles and
									;calls LoadHomeTeamGfx
	movem.l	d0-d7/a0-a6,-(sp)
	bclr	#$7,$17F6A.l		;sfhor
	move.w	#$3E8,(Oldrow).l		;1000
	move.w	(rinkvrcset).l,d4
	movea.l	(Rinktilelist).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsPlain).l
	jsr	$2A9D0.l
	bsr.w	X_2403E
	btst	#$0,$17F6A.l		;sfpz
	bne.w	.ex
	bsr.w	printz-LOAD
	String	CC_Font1,$0,$0
	moveq	#$20,d0		;32
	moveq	#$1C,d1		;28
	move.w	#$7FF,d2		;blank tile
	bsr.w	eraser-LOAD		;blank the 32x28 area
	bsr.w	printscores1		;redraw the score board
.ex	movem.l	(sp)+,d0-d7/a0-a6
	rts
SetHor						;switch graphics to horizontal ice rink graphics mode
	movem.l	d0-d7/a0-a6,-(sp)
	bset	#$7,$17F6A.l		;sfhor
.p	btst	#$0,(disflags).l		;dfok
	bne.w	.p
	clr.w	(Hscroll).l
	clr.w	(Vscroll).l
	bsr.w	X_2403E
	bsr.w	printz-LOAD
	String	CC_Font2,$0,$0
	movea.l	$47D6C.l,a1		;tiles start at IceRinkHorMap+8
	dc.w	$D3E9,$0004,$2479,$0004,$7D6C,$508A,$4240,$323C
	dc.w	$0000,$7420,$761C,$3839,$0001,$8D48,$7A00,$6100
	dc.w	$C380,$6100,$0200,$0839,$0000,$0001,$7F6A,$6600
	dc.w	$0014,$303C,$0800,$3239,$0001,$8D34,$343C,$07FF
	dc.w	$6100,$B61E,$4CDF,$7FFF,$4E75
printscores1						;Draw scoreboard. Vertical rink: period box and the score box (team names
									;and scores). Horizontal rink .sbscreen: period and both team logos with
									;big scores. The period name is gsp of PerLabels, or name 4 of PerLabels2
									;when gmode2 bit 1 is set; the horizontal rink uses PerLabels2 (name 4
									;when bit 0 is set).
									;sflags5 bit 7 sets crowdnoisedelay = $78. Called from USBoard, Pausemode,
									;lcfound_close and others
	movem.l	d0-d2/a0-a3,-(sp)
	btst	#$7,$17F6A.l		;sfhor
	bne.w	X_21548
	bclr	#$7,$17F74.l
	beq.w	.0
	move.w	#$78,(crowdnoisedelay).l
.0	bsr.w	printz-LOAD
	String	CC_Font1Pri,$0,$17
	moveq	#$9,d0		;period box: 9x5 frame at x 0, y $17
	moveq	#$5,d1
	bsr.w	Framer-LOAD
	bset	#$3,(disflags).l		;dfclock
	bsr.w	printz-LOAD
	String	CC_Font1Pri,$1,$18
	move.w	$180E4.l,d0		;period name
	movea.l	#PerLabels,a1
	btst	#$1,$17F78.l
	beq.w	.1
	move.w	#$4,d0
	movea.l	#PerLabels2,a1
.1	bsr.w	X_21EBE		;print the period name in the box
	bsr.w	EASNLogo		;logo under it (unless a power play is shown)
	btst	#$0,$17F6E.l		;sf3llcs: lower line change box is up
	bne.w	.ex
	bsr.w	printz-LOAD
	String	CC_Font1Pri,$17,$17
	moveq	#$8,d0		;score box: 8x5 frame at x $17, y $17
	moveq	#$5,d1
	bsr.w	Framer-LOAD
	bsr.w	printz-LOAD
	String	CC_Font1Pri,$18,$1A		;home team on the lower row
	movea.l	#tmstruct,a2
	bsr.w	printscores1_ps
	bsr.w	printz-LOAD
	String	CC_Font1Pri,$18,$18
	adda.w	#$366,a2		;tmsize
	bsr.w	printscores1_ps
.ex	movem.l	(sp)+,d0-d2/a0-a3
	rts
	dc.w	$6100,$CA24,$0006,$BE11,$0200,$3039,$0001,$80E4
	dc.w	$0839,$0000,$0001,$7F78,$6700,$0006,$303C,$0004
	dc.w	$227C,$0004,$1A48,$6100,$0956,$3011,$E248,$9179
	dc.w	$0001,$8D58,$6100,$CA02,$6100,$C9EC,$0006,$BE17
	dc.w	$0200,$247C,$0001,$834C,$4240,$6100,$003E,$6100
	dc.w	$C9D6,$0006,$BE08,$0200,$D4FC,$0366,$702C,$6100
	dc.w	$002A,$6000,$FF96
printscores1_ps						;Print the team name of team a2 at printx/printy, then its score as 2
									;digits at x $1C. Called twice from printscores1
	movea.l	$1E(a2),a1		;tmdata
	adda.w	$4(a1),a1
	adda.w	(a1),a1		;skip the first string to the team name
	bsr.w	print-LOAD
	move.w	#$1C,(printx).l		;score column
	move.w	$C(a2),d0		;tmscore
	moveq	#$2,d1		;2 digits
	bsr.w	PushNumberWidth-LOAD
	bra.w	print-LOAD		;print the score and return
PrintTeamLogoAndScore						;Draw the team logo map (PutTeamBlock, d0 = offset) 5 columns left of
									;printx then the score of team a2 in big font, centered 2 rows lower; a 2
									;digit score is moved one more left.
									;Called twice from printscores1
	move.w	(printx).l,-(sp)
	subi.w	#$5,(printx).l
	jsr	(PutTeamBlock).l
	move.w	(sp)+,(printx).l
	addi.w	#$2,(printy).l
	move.w	$C(a2),d0		;tmscore
	cmpi.w	#$A,d0
	bge.w	.0
	bra.w	.1
.0	subi.w	#$1,(printx).l
.1	bsr.w	PushNumber-LOAD		;a1 = score string
	move.w	(a1),d0		;center on the old printx
	subi.w	#$2,d0
	lsr.w	#$1,d0
	sub.w	d0,(printx).l
	addi.w	#$1,(printx).l
	bra.w	printbig-LOAD
EASNLogo						;Draw the EASN logo map at x 1, y $19 on the vertical ice rink if no power
									;play. Called from printscores1 and updatepwrplay
	btst	#$5,$17F6C.l		;sf2pwrplay
	bne.w	X_21000
	bsr.w	printz-LOAD
	String	CC_Font1Pri,$1,$19
	movea.l	(EASportsMap).l,a1
	adda.l	$4(a1),a1
	movea.l	#null,a2
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2		;width and height from the map header
	move.w	$2(a1),d3
	move.w	(EASNcset).l,d4
	clr.w	d5
	bra.w	dobitmap-LOAD
USBoard						;Update score board, including the players in the penalty box and their
									;time remaining. Called from InProgress and SetHor
	movem.l	d0-d7/a0-a3,-(sp)
	bset	#$3,(disflags).l		;dfclock
	bsr.w	printscores1
	bsr.w	printz-LOAD
	String	CC_Font2Pri,$14,$8
	movea.l	#tmstruct,a2		;home team
	bsr.w	.dispen
	bsr.w	printz-LOAD
	String	CC_Font2Pri,$5,$8
	movea.l	#awtmstruct,a2		;visitors
	bsr.w	.dispen
	movem.l	(sp)+,d0-d7/a0-a3
	rts
.dispen	lea.l	$9C(a2),a0
.l1	clr.w	d0		;pass 1: players with bit 14 (coincidental) clear
	move.b	(a0)+,d0
	bmi.w	.p2		;end of list
	btst	#$6,$68(a2,d0.w)		;coincidental (tmpdst high byte bit 6)
	bne.w	.l1
	bsr.w	pplpen
	bra.w	.l1
.p2	lea.l	$9C(a2),a0
.l2	clr.w	d0
	move.b	(a0)+,d0
	bmi.w	X_21000
	btst	#$6,$68(a2,d0.w)
	beq.w	.l2
	bsr.w	pplpen
	bra.w	.l2
pplpen						;print one penalty box line: player number and time remaining. a2 = team,
									;d0 = roster offset (player*2). Only
									;rows up to y $A are printed; printy += 1. Called from USBoard .dispen
	cmpi.w	#$A,(printy).l
	bhi.w	X_21000		;no room for more rows
	move.w	$68(a2,d0.w),d2
	andi.w	#$7FF,d2		;penalty time
	movea.l	$1E(a2),a1		;tmdata
	adda.w	$0(a1),a1		;a1 = roster in the team data
	lsr.w	#$1,d0		;d0 = player index
.find	adda.w	(a1),a1		;skip d0+1 roster entries (name string + 8 bytes)
	adda.w	#$8,a1
	dbra	d0,.find
	clr.w	d0
	move.b	-$8(a1),d0		;player number (BCD)
	move.w	(printx).l,-(sp)
	movea.l	#TextBuffer,a1		;mesarea+2
	bsr.w	ConvertByteToDigits-LOAD		;two digits to TextBuffer
	movea.l	#mesarea,a1
	move.w	#$4,(a1)		;string length: 2 digits
	bsr.w	print-LOAD		;print the number
	move.w	d2,d0
	bsr.w	PushTime-LOAD		;m:ss string
	bsr.w	print-LOAD		;print the time next to it
	move.w	(sp)+,(printx).l
	addi.w	#$1,(printy).l		;next row
	rts
linebar						;Draw the energy bar of line d0 for team a2 at printx/printy (bitmap from
									;the bar map, 16 steps). Called from SetLCmode2
	movem.l	d0-d5/a0-a2,-(sp)
	bsr.w	getlinee
	move.w	(printa).l,-(sp)
	move.w	#$8000,(printa).l		;priority attribute for the bar
	ext.l	d0
	divu.w	#$100,d0		;4096/16
	cmpi.w	#$F,d0
	bls.w	.ok
	moveq	#$F,d0		;clamp to 15
.ok	moveq	#$F,d1		;d1 = bar frame (15 = empty)
	sub.w	d0,d1		;d1 = bar frame (15 = empty)
	clr.w	d0
	movea.l	(EnergyBarMap).l,a1
	adda.l	$4(a1),a1
	movea.l	#null,a2		;tile pointer null (as in SetHor)
	move.w	(a1),d2		;map width
	moveq	#$1,d3		;1 row high
	move.w	(energybarchars).l,d4
	moveq	#$0,d5
	bsr.w	dobitmap-LOAD		;d1 = start row in the map = frame
	move.w	(sp)+,(printa).l
	movem.l	(sp)+,d0-d5/a0-a2
	rts
getlinee						;d0 = line number, a2 = team struct. Return d0 = energy level of this line
	movem.l	d1-d5/a0-a3,-(sp)
	lea.l	$16C(a2),a1		;line sets
	asl.w	#$3,d0		;8 bytes per line
	adda.w	d0,a1		;a1 = this line (one player number per position)
	clr.l	d0		;d0 = energy sum
	clr.w	d1		;d1 = players counted
	movea.l	#priolist,a0
	move.w	$26(a2),d4		;tmap
	bra.w	.l217D6
.loop	clr.w	d5
	move.b	(a0,d4.w),d5		;position
	beq.w	.l217D6		;goalie energy doesn't count
	clr.w	d3
	move.b	(a1,d5.w),d3		;player number
	asl.w	#$1,d3
	addi.w	#$1,d1
	add.w	$32(a2,d3.w),d0		;tmpde-2
.l217D6	dbra	d4,.loop
	divu.w	d1,d0		;average energy
	movem.l	(sp)+,d1-d5/a0-a3
	rts
AvgCline						;Return d0 = average energy of current line on team a2
	movem.l	d1-d3/a0,-(sp)
	clr.l	d0		;d0 = energy sum
	clr.w	d1		;d1 = skaters counted
	moveq	#$5,d2		;6 sort objects of the team
	movea.l	$22(a2),a0		;tmsort
.loop	tst.w	$34(a0)		;position
	ble.w	.next
	clr.w	d3
	move.b	$66(a0),d3		;pnum
	add.w	d3,d3
	add.w	$34(a2,d3.w),d0		;tmpde
	addi.w	#$1,d1
.next	adda.w	#$80,a0
	dbra	d2,.loop
	tst.w	d1
	beq.w	.ex		;nobody: avoid the divide
	divu.w	d1,d0		;average
.ex	movem.l	(sp)+,d1-d3/a0
	rts
ChkShotStat						;determine if shot taken, add to appropriate stats: crowd, team, shooter
									;and goalie shots against. Nothing while the
									;clock is stopped or in a highlight, PP shots and period shots
									;and a second path (sflags4 bit 0, sflags8 bit 3 every second
									;call) that counts the shot for the player in the last ScoreSum entry
	btst	#$0,$17F68.l		;gmclock: clock stopped
	bne.w	X_21000		;exit if so
	btst	#$4,$17F68.l		;gmhl: highlight
	bne.w	X_21000		;exit if so
	bclr	#$4,$17F6C.l		;sf2shot: shot taken
	bne.w	.Cwdupdate		;it was set
	btst	#$0,$17F72.l
	beq.w	X_21000		;exit if cleared
	bclr	#$3,$17F7C.l
	bne.w	.0
	bset	#$3,$17F7C.l
	bra.w	X_21000
.0	movem.l	d0-d1/a1-a3,-(sp)
	move.l	a4,-(sp)
	movea.l	#ScoreSum,a4		;ChkCnt. +ScoreSumbytes, then 2(a4) = the last ScoreSum entry
	adda.w	(ScoreSumbytes).l,a4
	movea.l	#tmstruct,a2		;home team
	btst	#$7,$2(a4)		;entry flag: visitors
	beq.w	.pllookup
	adda.w	#$366,a2		;tmsize
.pllookup	clr.w	d0
	move.b	$3(a4),d0		;pnum (roster offset)
	movea.l	(sp)+,a4
	movea.l	$22(a2),a2		;tmsort
	move.w	#$5,d1
.findplayer	cmp.b	$66(a2),d0		;pnum
	beq.w	.foundplayer
	adda.w	#$80,a2		;SCstruct
	dbra	d1,.findplayer
	bra.w	.ex
.foundplayer	move.w	$52(a2),d0		;SCnum
	bra.w	.addShot
.Cwdupdate	movem.l	d0-d1/a1-a3,-(sp)
	addi.w	#$64,(Crowdlevel).l		;100
	addi.w	#$A,(CwdExciteLvl).l
	move.w	(shotplayer).l,d0
.addShot	asl.w	#$7,d0		;scsize
	movea.l	#SortCords,a3
	adda.w	d0,a3
	bsr.w	.l21958
	addi.w	#$1,$0(a2)		;tmshots
	btst	#$5,$17F6C.l		;sf2pwrplay
	beq.w	.2
	btst	#$6,$17F6C.l		;sf2pwrtm: 0 home, 1 visitors
	bne.w	.1
	btst	#$6,$62(a3)		;pfteam
	bne.w	.2		;not the team on the power play
.PPshot	addi.w	#$1,$356(a2)		;power play shots
	bra.w	.2
.1	btst	#$6,$62(a3)		;pfteam
	bne.w	.PPshot
.2	move.l	a2,-(sp)
	move.w	$180E4.l,d0		;period
	add.w	d0,d0
	adda.w	d0,a2
	addi.w	#$1,$34C(a2)		;shots by period
	movea.l	(sp)+,a2
	clr.w	d0
	move.b	$66(a3),d0		;pnum
	addi.w	#$EA,d0
	addi.b	#$1,(a2,d0.w)		;shooter's shot count
	move.w	$28(a1),d0		;other team's tmgoalie
	bmi.w	.ex		;empty net
	addi.w	#$EA,d0
	addi.b	#$1,(a1,d0.w)		;goalie's shots against
.ex	movem.l	(sp)+,d0-d1/a1-a3
	rts
.l21958	movea.l	#tmstruct,a2
	lea.l	$366(a2),a1
	btst	#$6,$62(a3)
	beq.w	X_21000
	exg.l	a1,a2
	rts
SetupTeamForIntermission						;Reset the bench, then for each team refill energy and pick the starting
									;line: power play 1 (3) for the team with more players on ice, PK1 (5) for
									;the team with fewer, else 0. Called from Intermission
	bsr.w	ResetBench-LOAD
	movea.l	#tmstruct,a2
	lea.l	$366(a2),a3
	bsr.w	.r
	exg.l	a2,a3		;falls in for the other team
.r	bsr.w	reenergizeteam		;refill energy for this team
	clr.w	$16(a3)		;tmline
	tst.w	(OptLine).l
	bne.w	X_21000		;line changes off
	move.w	$26(a3),d0
	sub.w	$26(a2),d0
	beq.w	X_21000
	move.w	#$3,$16(a3)		;Pw1
	tst.w	d0
	bpl.w	X_21000
	move.w	#$5,$16(a3)		;PK1
	rts
RestoreTeamEnergy						;a2 = team: max energy (tmpde $1000) for every player. The skip needs
									;tmpdst to be both -3 and -4, so it never happens.
									;Called from the menu code before ReplayMode
	moveq	#$32,d0		;(MaxRos-1)*2
.loop	cmpi.w	#$FFFD,$68(a2,d0.w)
	bne.w	.0
	cmpi.w	#$FFFC,$68(a2,d0.w)
	bne.w	.0
	bra.w	.1
.0	move.w	#$1000,$34(a2,d0.w)		;tmpde
.1	subi.w	#$2,d0
	bpl.w	.loop
	rts
reenergizeteam						;Set all players to max energy on team a2 except those at tmpdst -4;
									;players marked -3 in tmpdst go to
									;the bench (-2). Called from SetupTeamForIntermission and StartHL2
									;.setteam
	moveq	#$32,d0		;(MaxRos-1)*2
.loop	cmpi.w	#$FFFC,$68(a2,d0.w)
	beq.w	.nb
	move.w	#$1000,$34(a2,d0.w)		;tmpde
	cmpi.w	#$FFFD,$68(a2,d0.w)
	bne.w	.nb
	move.w	#$FFFE,$68(a2,d0.w)		;on bench
.nb	subi.w	#$2,d0
	bpl.w	.loop
	rts
Intermission						;end of period junk (zamboni/stats). Opens the pause menu screen (item
									;list by period, +5 in playoffs), shows the ticker scores of the other
									;games, then the highlights; Start on either pad cuts it short. When gsp
									;is 4 the clock is cleared and UpdateRecords runs first, and gmode2 bit 0
									;picks the ShootoutIntermissionMenu item list.
									;Called from PeriodOver
	cmpi.w	#$4,$180E4.l
	bne.w	.1
	move.w	#$0,(gameclock).l
	jsr	(UpdateRecords).l
.1	bsr.w	SetupTeamForIntermission
	moveq	#$F,d0
	movea.l	#SortCords,a0
.clr	clr.w	$0(a0)		;Xpos
	adda.w	#$80,a0		;SCstruct
	dbra	d0,.clr
	move.w	(ExtraChars).l,d4
	movea.l	(ZamSprites).l,a2
	addq.l	#$8,a2
	bsr.w	DecompressGraphicsPlain-LOAD
	move.w	#$140,$17CE2.l		;320
	move.w	$180E4.l,d0
	tst.w	(OptPlayMode).l
	beq.w	.ss
	addi.w	#$5,d0		;playoffs
.ss	asl.w	#$2,d0
	lea.l	X_21B28(pc),a0
	movea.l	(a0,d0.w),a0
	btst	#$0,$17F78.l
	beq.w	.2
	movea.l	#$42250,a0
.2	bset	#$0,$17F6A.l		;sfpz
	movea.l	#$2C1F8,a1
	jsr	$2C2F8.l
	bsr.w	GetShifter-LOAD		;d1 = highest game index
	move.w	d1,(TickerNum).l		;ticker starts from the last game
	bset	#$5,$FF800F.l
.top	tst.w	(TickerNum).l		;one ticker game per pass
	bmi.w	.doh		;no more ticker games
	bsr.w	X_21D00		;d3 = next game to show
	bsr.w	NewTicker3-LOAD		;show its score
	move.w	#$96,d0		;150 frames
	bsr.w	waitxsr-LOAD
	btst	#$7,d1		;Start?
	bne.w	.clrh
	bsr.w	X_21E8C		;blank pause, then the next game
	move.w	#$3C,d0		;60 frames
	bsr.w	waitxsr-LOAD
	btst	#$7,d1
	beq.w	.top
.clrh	bset	#$3,$17F6E.l		;sf3sbut
.doh	bsr.w	DoHiLights-LOAD		;show the requested highlights
	bclr	#$3,$17F6E.l
	bne.w	.clrz		;start pressed (flag set by .clrh or by a highlight): leave
.wait	move.w	#$1E0,d0		;480 frames
	bsr.w	waitxsr-LOAD
	btst	#$7,d1
	bne.w	.clrz
	tst.w	(cont1team).l
	bne.w	.wait		;keep waiting while a pad is on a team
	tst.w	(cont2team).l
	bne.w	.wait
.clrz	st.b	$17CE2.l		;zamboni off
	rts
	dc.w	$0004,$22D4
	dc.w	$0004,$2454
	dc.w	$0004,$2454
	dc.w	$0004,$2454
	dc.w	$0004,$25B0
	dc.w	$0004,$2388
	dc.w	$0004,$2454
	dc.w	$0004,$2454
	dc.w	$0004,$2454
	dc.w	$0004,$26C4
InitScores						;initialize other games scores/period in playoffs. Called from StartGame
	cmpi.w	#$1,(gamelevel).l
	bgt.w	X_21000
	bsr.w	GetShifter-LOAD
	movea.l	#$18A18,a0
	moveq	#$10,d0		;gssize
	mulu.w	d1,d0
	adda.w	d0,a0		;a0 = gstruct of game d1, counting down
.top	cmp.w	(gamenum).l,d1		;per game
	beq.w	.l21B96		;not the game being played
	btst	#$2,$E(a0)		;gsfso
	bne.w	.l21B96		;series already over
	clr.w	$8(a0)		;gsper
	moveq	#$3,d0
	bsr.w	randomd0-LOAD		;random 0-2: score that many plus one periods
	bra.w	.l21B92
.0	bsr.w	SetScore
.l21B92	dbra	d0,.0
.l21B96	suba.w	#$10,a0
	dbra	d1,.top
	rts
UpdateScores						;update ticker score values. Called from PeriodOver
	bsr.w	GetShifter-LOAD		;d1 = highest game index
	move.w	d1,(TickerNum).l		;restart the ticker
	movea.l	#$18A18,a0
	moveq	#$10,d0		;gssize
	mulu.w	d1,d0
	adda.w	d0,a0		;a0 = gstruct of game d1, counting down
.top	cmp.w	(gamenum).l,d1		;per game
	beq.w	.next		;not the game being played
	bclr	#$1,$E(a0)		;gsfhl
	btst	#$2,$E(a0)		;gsfso
	bne.w	.next		;series over
	bsr.w	SetScore		;one more period for this game
.next	suba.w	#$10,a0		;gssize
	dbra	d1,.top
	rts
SetScore						;add to score for game in a0. After period 3 a game within one goal goes
									;to OT (gsper 3) and asks for a highlight
	cmpi.w	#$4,$8(a0)		;gsper
	bge.w	X_21000
	movem.l	d0-d1/a0-a1,-(sp)
	cmpi.w	#$3,$8(a0)
	bne.w	.o
	move.w	#$5,$8(a0)		;final
	move.w	$A(a0),d0		;gss1
	sub.w	$C(a0),d0		;gss2
	cmpi.w	#$1,d0
	bgt.w	.ex
	cmpi.w	#$FFFF,d0
	blt.w	.ex
	move.w	#$3,$8(a0)		;close game: overtime
	bset	#$1,$E(a0)		;gsfhl
	bra.w	.ex
.o	addi.w	#$1,$8(a0)
	move.w	$0(a0),d0		;gst1
	move.w	$2(a0),d1		;gst2
	bsr.w	.getscore
	add.w	d0,$A(a0)		;gss1
	move.w	$2(a0),d0
	move.w	$0(a0),d1
	bsr.w	.getscore		;goals for team 2
	add.w	d0,$C(a0)		;gss2
.ex	movem.l	(sp)+,d0-d1/a0-a1
	rts
.getscore	asl.w	#$2,d0
	movea.l	#TeamList,a1
	movea.l	(a1,d0.w),a1
	adda.w	$8(a1),a1
	move.b	(a1),d0
	andi.w	#$70,d0
	lsr.w	#$1,d0		;row * 8
	dc.w	$43FA,$0048
	move.l	(a1,d0.w),$18BE8.l
	move.l	$4(a1,d0.w),$18BEC.l
	asl.w	#$2,d1
	movea.l	#TeamList,a1
	movea.l	(a1,d1.w),a1
	adda.w	$8(a1),a1
	move.b	(a1),d0
	andi.w	#$7,d0
	asl.w	#$3,d0
	dc.w	$43FA,$001C
	move.l	(a1,d0.w),d1
	add.l	d1,$18BE8.l
	move.l	$4(a1,d0.w),d1
	add.l	d1,$18BEC.l
	moveq	#$4,d0		;4 weights
	bra.w	WeightedRandomSelect-LOAD
NewTicker						;show the next ticker score once the clock is at 8:00 or less. d3 = -1 if
									;not. Called from chkprogress. Falls into NewTicker2
	ori.b	#$1E,$17(a3)
	ori.b	#$27,d4
	ori.b	#$18,-(a0)
	ori.b	#$23,d5
	ori.b	#$1A,-(a1)
	ori.b	#$1E,d6
	ori.b	#$1E,-(a2)
	ori.b	#$1A,d6
	ori.b	#$1E,-(a4)
	dc.w	$0008
	ori.b	#$25,(a6)
	ori.b	#$A,(sp)+
	ori.b	#$26,(a3)
	ori.b	#$C,(sp)+
	dc.w	$000F
	ori.b	#$20,-(a6)
	dc.w	$000F
	dc.w	$76FF,$0C79,$01E0,$0001,$80E6,$6E00,$F302,$3639
	dc.w	$0001,$8ADE,$6B00,$F2F8,$0479,$0001,$0001,$8ADE
	dc.w	$B679,$0001,$8A98,$6700,$FFE6
CheckGameTickerStatus						;d3 = game. Return a0 = its gstruct; skip to the next ticker game if a
									;highlight is coming up or the series is over. Called from StartHL2
	moveq	#$10,d0		;gssize
	mulu.w	d3,d0
	movea.l	#$18A18,a0
	adda.w	d0,a0
	btst	#$1,$E(a0)		;gsfhl
	bne.w	X_21D00		;don't show if hilite coming up
	btst	#$2,$E(a0)		;gsfso
	bne.w	X_21D00		;don't show if the series is over for this game
	rts
