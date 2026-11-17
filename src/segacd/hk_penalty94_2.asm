	include	segacd\hockey.inc
	include	macros\genesis.mac

CC_Font1Pri	equ	$BF
CC_Font2	equ	$FE
Crowdlevel	equ	$17CD2
CwdExciteLvl	equ	$17CD8
EASNcset	equ	$18D50
EASportsMap	equ	$47D4C
EnergyBarMap	equ	$47D40
Hscroll	equ	$17CF0
LOAD	equ	$1B000
OptLine	equ	$18C0A
PerLabels	equ	$41A34
PerLabels2	equ	$41A48
PushNumberWidth	equ	$3919A
PutTeamBlock	equ	$2C59E
SortCords	equ	$17480
TickerNum	equ	$18ADE
Vscroll	equ	$17CF2
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
gamelevel	equ	$18A9E
gamenum	equ	$18A98
lastplayer	equ	$17E2A
mesarea	equ	$17EF2
move	equ	$2C9C8
null	equ	$1B008
passReceiverPlayerNum	equ	$17E30
print	equ	$38F80
printa	equ	$18D5C
printx	equ	$18D58
printy	equ	$18D5A
printz	equ	$38F6E
priolist	equ	$41AD6
puckc	equ	$17BE0
setc1player	equ	$312B8
setc2player	equ	$312DC
sfx	equ	$3710C
swap	equ	$2779A
tmstruct	equ	$1834C
X_1C050	equ	$1C050
X_1E0F4	equ	$1E0F4
X_1E15E	equ	$1E15E
X_1E200	equ	$1E200
X_1E26A	equ	$1E26A
X_1F0A6	equ	$1F0A6
X_21000	equ	$21000
X_21350	equ	$21350
X_2139C	equ	$2139C
X_21542	equ	$21542
X_21548	equ	$21548
X_2162A	equ	$2162A
X_216E0	equ	$216E0
X_2181E	equ	$2181E
X_21BDE	equ	$21BDE
X_21D00	equ	$21D00
X_21EBE	equ	$21EBE
X_226E2	equ	$226E2
X_2403E	equ	$2403E
X_2581C	equ	$2581C

	org	$20DE8

puckglue
	move.w	#$7,-(sp)
	move.w	$52(a2),d0
	move.w	d0,(puckc).l
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
	bsr.w	X_2181E
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
	dc.w	$082A,$0003,$0064,$6600,$0096,$0C6B,$0008,$0018
	dc.w	$6E00,$000C,$3200,$0241,$000F,$6600,$0082,$6100
	dc.w	$9DA6,$3F3C,$0024,$6100,$B182,$426B,$002C,$157C
	dc.w	$0008,$005E,$302B,$0000,$906A,$0000,$322B,$0014
	dc.w	$926A,$0014,$6600,$0008,$2F0A,$6100,$A3B4,$342B
	dc.w	$0028,$362B,$002A,$1740,$0028,$1741,$002A,$6100
	dc.w	$9F36,$0C6B,$0008,$0018,$6F00,$0034,$C5C2,$C7C3
	dc.w	$D483,$0C82,$0900,$0000,$6300,$000E,$0C6B,$000C
	dc.w	$0018,$6E00,$E9D8,$4E75,$08EA,$0005,$0062,$6600
	dc.w	$000E,$323C,$10D0,$C54B,$6100,$A3C4,$C54B,$4E75
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
	beq.w	X_2139C		;same number on the ice
	bpl.w	.t0		;team 1 has more
	btst	#$6,$17F6C.l		;sf2pwrtm: 0 home, 1 visitors
	bne.w	.upp
	bsr.w	X_2139C		;power play team changed: remove the old display
	bset	#$6,$17F6C.l
	bra.w	.upp
.t0	exg.l	a2,a3		;a2 = shorthanded team 2, a3 = power play team 1
	btst	#$6,$17F6C.l
	beq.w	.upp
	bsr.w	X_2139C
	bclr	#$6,$17F6C.l
.upp	bset	#$5,$17F6C.l		;sf2pwrplay
	bne.w	X_21350		;already showing a power play
	addi.w	#$1,$4(a3)		;tmPwrPlays
	cmpa.l	#$1834C,a3		;home team (93 played song $33 here)
	bne.w	.away
.home	bra.w	X_21350
.away	bra.w	.home
	dc.w	$6100,$CC1C,$0012,$BF01,$1920,$2020,$1617,$1819
	dc.w	$BF01,$1A20,$2000
	bsr.w	X_1F0A6		;d0 = time left
	bsr.w	X_1E0F4		;a1 = m:ss string
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
	bclr	#$5,$17F6C.l
	beq.w	X_21000
	bra.w	X_2162A
	dc.w	$48E7,$FFFE,$08B9,$0007,$0001,$7F6A,$33FC,$03E8
	dc.w	$0001,$7CEC,$3839,$0001,$8D48,$2479,$0004,$7D18
	dc.w	$508A,$4EB9,$0003,$8958,$4EB9,$0002,$A9D0,$6100
	dc.w	$2C62,$0839,$0000,$0001,$7F6A,$6600,$001C,$6100
	dc.w	$CB82,$0006,$FF00,$0000,$7020,$721C,$343C,$07FF
	dc.w	$6100,$C808,$6100,$008A,$4CDF,$7FFF,$4E75
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
	dc.w	$2279,$0004,$7D6C,$D3E9,$0004,$2479,$0004,$7D6C
	dc.w	$508A,$4240,$323C,$0000,$7420,$761C,$3839,$0001
	dc.w	$8D48,$7A00,$6100,$C380,$6100,$0200,$0839,$0000
	dc.w	$0001,$7F6A,$6600,$0014,$303C,$0800,$3239,$0001
	dc.w	$8D34,$343C,$07FF,$6100,$B61E,$4CDF,$7FFF,$4E75
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
	dc.w	$7009,$7205,$6100,$C7E0,$08F9,$0003,$0001,$8D64
	dc.w	$6100,$CAA2,$0006,$BF01,$1800
	move.w	$180E4.l,d0		;period name
	movea.l	#PerLabels,a1
	btst	#$1,$17F78.l
	beq.w	.1
	move.w	#$4,d0
	movea.l	#PerLabels2,a1
.1	bsr.w	X_21EBE		;print the period name in the box
	bsr.w	X_2162A		;logo under it (unless a power play is shown)
	btst	#$0,$17F6E.l		;sf3llcs: lower line change box is up
	bne.w	X_21542
	bsr.w	printz-LOAD
	String	CC_Font1Pri,$17,$17
	dc.w	$7008,$7205,$6100,$C786,$6100,$CA50,$0006,$BF18
	dc.w	$1A00,$247C,$0001,$834C,$6100,$0080,$6100,$CA3C
	dc.w	$0006,$BF18,$1800,$D4FC,$0366,$6100,$006E,$4CDF
	dc.w	$0F07,$4E75,$6100,$CA24,$0006,$BE11,$0200,$3039
	dc.w	$0001,$80E4,$0839,$0000,$0001,$7F78,$6700,$0006
	dc.w	$303C,$0004,$227C,$0004,$1A48,$6100,$0956,$3011
	dc.w	$E248,$9179,$0001,$8D58,$6100,$CA02,$6100,$C9EC
	dc.w	$0006,$BE17,$0200,$247C,$0001,$834C,$4240,$6100
	dc.w	$003E,$6100,$C9D6,$0006,$BE08,$0200,$D4FC,$0366
	dc.w	$702C,$6100,$002A,$6000,$FF96
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
.1	bsr.w	X_1E15E		;a1 = score string
	move.w	(a1),d0		;center on the old printx
	subi.w	#$2,d0
	lsr.w	#$1,d0
	sub.w	d0,(printx).l
	addi.w	#$1,(printx).l
	bra.w	X_1E26A
	dc.w	$0839,$0005,$0001,$7F6C,$6600,$F9CC,$6100,$C936
	dc.w	$0006,$BF01,$1900
	movea.l	(EASportsMap).l,a1
	adda.l	$4(a1),a1
	movea.l	#null,a2
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	$2(a1),d3
	move.w	(EASNcset).l,d4
	clr.w	d5
	bra.w	dobitmap-LOAD
	dc.w	$48E7,$FFF0,$08F9,$0003,$0001,$8D64,$6100,$FE18
	dc.w	$6100,$C8F6,$0006,$BE14,$0800,$247C,$0001,$834C
	dc.w	$6100,$001C,$6100,$C8E2,$0006,$BE05,$0800
	movea.l	#awtmstruct,a2
	bsr.w	.l216A4
	movem.l	(sp)+,d0-d7/a0-a3
	rts
.l216A4	lea.l	$9C(a2),a0
.l216A8	clr.w	d0
	move.b	(a0)+,d0
	bmi.w	.l216C2
	btst	#$6,$68(a2,d0.w)
	bne.w	.l216A8
	bsr.w	X_216E0
	bra.w	.l216A8
.l216C2	lea.l	$9C(a2),a0
.l216C6	clr.w	d0
	move.b	(a0)+,d0
	bmi.w	X_21000
	btst	#$6,$68(a2,d0.w)
	beq.w	.l216C6
	bsr.w	X_216E0
	bra.w	.l216C6
	dc.w	$0C79,$000A,$0001,$8D5A,$6200,$F916,$3432,$0068
	dc.w	$0242,$07FF,$226A,$001E,$D2E9,$0000,$E248,$D2D1
	dc.w	$D2FC,$0008,$51C8,$FFF8,$4240,$1029,$FFF8,$3F39
	dc.w	$0001,$8D58,$227C,$0001,$7EF4,$6100,$4B8C,$227C
	dc.w	$0001,$7EF2,$32BC,$0004,$6100,$C856,$3002,$6100
	dc.w	$C9C4,$6100,$C84C,$33DF,$0001,$8D58,$0679,$0001
	dc.w	$0001,$8D5A,$4E75
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
	dc.w	$0839,$0000,$0001,$7F68,$6600,$F7D8,$0839,$0004
	dc.w	$0001,$7F68,$6600,$F7CC,$08B9,$0004,$0001,$7F6C
	dc.w	$6600,$0078,$0839,$0000,$0001,$7F72,$6700,$F7B4
	dc.w	$08B9,$0003,$0001,$7F7C,$6600,$000E,$08F9,$0003
	dc.w	$0001,$7F7C,$6000,$F79C,$48E7,$C070,$2F0C,$287C
	dc.w	$0001,$80EC,$D8F9,$0001,$80F0,$247C,$0001,$834C
	dc.w	$082C,$0007,$0002,$6700,$0006,$D4FC,$0366,$4240
	dc.w	$102C,$0003,$285F,$246A,$0022,$323C,$0005,$B02A
	dc.w	$0066,$6700,$000E,$D4FC,$0080,$51C9,$FFF2,$6000
	dc.w	$00A4,$302A,$0052,$6000,$001C,$48E7,$C070,$0679
	dc.w	$0064,$0001,$7CD2,$0679,$000A,$0001,$7CD8,$3039
	dc.w	$0001,$7E28,$EF40,$267C,$0001,$7480,$D6C0,$6100
	dc.w	$007A,$066A,$0001,$0000,$0839,$0005,$0001,$7F6C
	dc.w	$6700,$002C,$0839,$0006,$0001,$7F6C,$6600,$0016
	dc.w	$082B,$0006,$0062,$6600,$0016,$066A,$0001,$0356
	dc.w	$6000,$000C,$082B,$0006,$0062,$6600,$FFEE,$2F0A
	dc.w	$3039,$0001,$80E4,$D040,$D4C0,$066A,$0001,$034C
	dc.w	$245F,$4240,$102B,$0066,$0640,$00EA,$0632,$0001
	dc.w	$0000,$3029,$0028,$6B00,$000C,$0640,$00EA,$0631
	dc.w	$0001,$0000,$4CDF,$0E03,$4E75,$247C,$0001,$834C
	dc.w	$43EA,$0366,$082B,$0006,$0062,$6700,$F696,$C34A
	dc.w	$4E75
SetupTeamForIntermission						;Reset the bench, then for each team refill energy and pick the starting
									;line: power play 1 (3) for the team with more players on ice, PK1 (5) for
									;the team with fewer, else 0. Called from Intermission
	bsr.w	X_226E2
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
	dc.w	$0C79,$0004,$0001,$80E4,$6600,$0010,$33FC,$0000
	dc.w	$0001,$80E6,$4EB9,$0002,$5A4E,$6100,$FF48,$700F
	dc.w	$207C,$0001,$7480,$4268,$0000,$D0FC,$0080,$51C8
	dc.w	$FFF6,$3839,$0001,$8D56,$2479,$0004,$7D34,$508A
	dc.w	$6100,$BF0A,$33FC,$0140,$0001,$7CE2,$3039,$0001
	dc.w	$80E4,$4A79,$0001,$8BFA,$6700,$0006,$0640,$0005
	dc.w	$E540,$41FA,$00B8,$2070,$0000,$0839,$0000,$0001
	dc.w	$7F78,$6700,$0008,$207C,$0004,$2250,$08F9,$0000
	dc.w	$0001,$7F6A,$227C,$0002,$C1F8,$4EB9,$0002,$C2F8
	dc.w	$6100,$3D7E,$33C1,$0001,$8ADE,$08F9,$0005,$00FF
	dc.w	$800F,$4A79,$0001,$8ADE,$6B00,$0036,$6100,$0246
	dc.w	$6100,$0280,$303C,$0096,$6100,$A87A,$0801,$0007
	dc.w	$6600,$0016,$6100,$03BA,$303C,$003C,$6100,$A866
	dc.w	$0801,$0007,$6700,$FFCC,$08F9,$0003,$0001,$7F6E
	dc.w	$6100,$03E4,$08B9,$0003,$0001,$7F6E,$6600,$0026
	dc.w	$303C,$01E0,$6100,$A83E,$0801,$0007,$6600,$0016
	dc.w	$4A79,$0001,$7FA6,$6600,$FFE8,$4A79,$0001,$7FA8
	dc.w	$6600,$FFDE,$50F9,$0001,$7CE2,$4E75,$0004,$22D4
	dc.w	$0004,$2454,$0004,$2454,$0004,$2454,$0004,$25B0
	dc.w	$0004,$2388,$0004,$2454,$0004,$2454,$0004,$2454
	dc.w	$0004,$26C4
InitScores						;initialize other games scores/period in playoffs. Called from StartGame
	cmpi.w	#$1,(gamelevel).l
	bgt.w	X_21000
	bsr.w	X_2581C
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
	bsr.w	X_1C050		;random 0-2: score that many plus one periods
	bra.w	.l21B92
.0	bsr.w	X_21BDE
.l21B92	dbra	d0,.0
.l21B96	suba.w	#$10,a0
	dbra	d1,.top
	rts
UpdateScores						;update ticker score values. Called from PeriodOver
	bsr.w	X_2581C		;d1 = highest game index
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
	bsr.w	X_21BDE		;one more period for this game
.next	suba.w	#$10,a0		;gssize
	dbra	d1,.top
	rts
	dc.w	$0C68,$0004,$0008,$6C00,$F41A,$48E7,$C0C0,$0C68
	dc.w	$0003,$0008,$6600,$0030,$317C,$0005,$0008,$3028
	dc.w	$000A,$9068,$000C,$0C40,$0001,$6E00,$0040,$0C40
	dc.w	$FFFF,$6D00,$0038,$317C,$0003,$0008,$08E8,$0001
	dc.w	$000E,$6000,$0028,$0668,$0001,$0008,$3028,$0000
	dc.w	$3228,$0002,$6100,$001C,$D168,$000A,$3028,$0002
	dc.w	$3228,$0000,$6100,$000C,$D168,$000C,$4CDF,$0303
	dc.w	$4E75,$E540,$227C,$0001,$B00C,$2271,$0000,$D2E9
	dc.w	$0008,$1011,$0240,$0070,$E248,$43FA,$0048,$23F1
	dc.w	$0000,$0001,$8BE8,$23F1,$0004,$0001,$8BEC,$E541
	dc.w	$227C,$0001,$B00C,$2271,$1000,$D2E9,$0008,$1011
	dc.w	$0240,$0007,$E740,$43FA,$001C,$2231,$0000,$D3B9
	dc.w	$0001,$8BE8,$2231,$0004,$D3B9,$0001,$8BEC,$7004
	dc.w	$6000,$9F32,$002B,$001E,$0017,$0004,$0027,$0020
	dc.w	$0018,$0005,$0023,$0021,$001A,$0006,$001E,$0022
	dc.w	$001E,$0006,$001A,$0024,$001E,$0008,$0016,$0025
	dc.w	$001F,$000A,$0013,$0026,$001F,$000C,$000F,$0026
	dc.w	$0020,$000F,$76FF,$0C79,$01E0,$0001,$80E6,$6E00
	dc.w	$F302,$3639,$0001,$8ADE,$6B00,$F2F8,$0479,$0001
	dc.w	$0001,$8ADE,$B679,$0001,$8A98,$6700,$FFE6
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
