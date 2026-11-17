	include	segacd\hockey.inc
	include	macros\genesis.mac

BA_Sktr_SCnum	equ	$19368
CC_Font2Pri	equ	$BE
CC_Font3Pri	equ	$BD
FormatPlayerName	equ	$411D6
FormatPlayerNumInitial	equ	$41192
Framer	equ	$38CA0
HotColdIcon	equ	$2B3FE
Hpos	equ	$17CEE
OptNOP	equ	$18BFC
OptPen	equ	$18C08
PositionBoxes	equ	$292E2
PositionBoxesTop	equ	$292F2
PushNumber	equ	$3915E
PushTime	equ	$390F4
PutTeamBlock	equ	$2C59E
SetupScreen	equ	$2E728
TeamRatings	equ	$2A040
Vpos	equ	$17CEA
appendz	equ	$39200
appstring	equ	$39208
arenaanim	equ	$1A556
arenaanimchars	equ	$1A54E
arenaframe	equ	$1A550
arenaspritelist	equ	$1A55C
awtmstruct	equ	$186B2
cont1team	equ	$17FA6
cont2team	equ	$17FA8
goaliemode1	equ	$18C0C
goaliemode2	equ	$18C0E
iconplayer	equ	$1AD8A
mesarea	equ	$17EF2
move	equ	$2C9C8
print	equ	$38F80
printbigz	equ	$39258
printx	equ	$18D58
printy	equ	$18D5A
printz	equ	$38F6E
setc1player	equ	$312B8
setc2player	equ	$312DC
tmstruct	equ	$1834C
X_EB5E	equ	$EB5E
X_EE56	equ	$EE56
X_EF44	equ	$EF44

	org	$E1CE

	dc.w	$48E7,$FFFE,$08F9,$0002,$0001,$7F6C,$4EB9,$0003
	dc.w	$0094,$33FC,$0060,$0001,$AD72,$267C,$0001,$7480
	dc.w	$303C,$0000,$3439,$0001,$A416,$B479,$0001,$A418
	dc.w	$6E00,$0006,$303C,$0006,$EF40,$D6C0,$343C,$0004
	dc.w	$363C,$0006,$6000,$0054,$48A7,$3000,$4EB9,$0003
	dc.w	$D770,$377C,$0002,$0034,$303C,$00F0,$4A79,$0001
	dc.w	$7CEA,$6B00,$0006,$303C,$FF10,$D079,$0001,$7CEA
	dc.w	$3740,$0014,$377C,$0000,$0000,$303C,$0007,$4EB9
	dc.w	$0003,$62D8,$08AB,$0005,$0062,$08AB,$0001,$0063
	dc.w	$08AB,$0002,$0062,$4C9F,$000C,$D7FC,$0000,$0080
	dc.w	$51CA,$FFA6,$4CDF,$7FFF,$4E75
ClampPositionBox						;Unreferenced. Clamp temp3 / temp4(a3) to the box for position(a3) in
									;PositionBoxes (PositionBoxesTop when bit 7 of
									;pflags(a3), the top net)
	movem.l	d0-d7/a0,-(sp)
	move.w	$34(a3),d7
	subi.w	#$1,d7		;position 1 is entry 0
	movea.l	#PositionBoxes,a0
	btst	#$7,$62(a3)		;which net?
	beq.w	.0
	movea.l	#PositionBoxesTop,a0
.0	add.w	d7,d7		;word per position
	move.w	(a0,d7.w),d0		;X min of the box
	cmp.w	$44(a3),d0
	blt.w	.1
	move.w	d0,$44(a3)		;clamp to the left
.1	move.w	$2(a0,d7.w),d0		;X max of the box
	cmp.w	$44(a3),d0
	bgt.w	.2
	move.w	d0,$44(a3)		;clamp to the right
.2	move.w	$4(a0,d7.w),d0		;Y min of the box
	cmp.w	$46(a3),d0
	blt.w	.3
	move.w	d0,$46(a3)		;clamp to the bottom
.3	move.w	$6(a0,d7.w),d0		;Y max of the box
	cmp.w	$46(a3),d0
	bgt.w	.x
	move.w	d0,$46(a3)		;clamp to the top
.x	movem.l	(sp)+,d0-d7/a0
	rts
	dc.w	$FFB5,$0000,$0000,$0108,$0000,$004B,$0000,$0108
	dc.w	$FFB5,$0000,$FEF8,$0000,$0000,$004B,$FEF8,$0000
	dc.w	$48E7,$FFFE,$207C,$0001,$A414,$203C,$0000,$0012
	dc.w	$4258,$51C8,$FFFC,$207C,$0001,$834C,$303C,$0365
	dc.w	$4258,$51C8,$FFFC,$207C,$0001,$8022,$203C,$0000
	dc.w	$0024,$4258,$51C8,$FFFC,$4279,$0001,$7F70,$4279
	dc.w	$0001,$7F72,$4279,$0001,$7F76,$4279,$0001,$7F78
	dc.w	$4279,$0001,$9390,$4279,$0001,$93A0,$4CDF,$7FFF
	dc.w	$4E75
AddArenaAnimSprite						;Add the frame arenaframe of the arena animation (sprite list
									;arenaspritelist, see RunArenaAnim) to the sprite table a6 (d6 sprites, 64
									;at most) for the pieces inside the view (Hpos / Vpos). Not in a reverse
									;angle replay (sflags4 bit 4), sflags2 bit 3 or sflags bit 7. Called from
									;setvideo
	tst.w	(arenaanim).l
	bmi.w	.lE48C
	tst.l	(arenaspritelist).l
	beq.w	.lE48C		;not loaded: none
	btst	#$4,$17F72.l		;check if reverse angle replay
	bne.w	.lE48C
	btst	#$3,$17F6C.l
	bne.w	.lE48C		;replay: none
	btst	#$7,$17F6A.l
	bne.w	.lE48C		;horizontal mode: none
	movea.l	(arenaspritelist).l,a1
	adda.l	$4(a1),a1
	move.w	(Hpos).l,d4
	move.w	(Vpos).l,d5
	move.w	(arenaframe).l,d0		;current frame
	bra.w	.spr		;draw the current frame
	andi.w	#$F,d2		;nothing branches here: draw d2 + 1 (4 at most) frames from d3 (.2)
	cmpi.w	#$3,d2
	bls.w	.0
	moveq	#$3,d2
.0	bra.w	.lE3D6
.loop	move.w	d3,d0		;first frame
	add.w	d2,d0		;frame number
	bsr.w	.spr
.lE3D6	dbra	d2,.loop
	rts
.spr	ext.w	d0		;frame number
	beq.w	.lE48C		;frame 0: nothing
	cmpi.w	#$40,d6		;64 sprites?
	bge.w	.lE48C
	movem.l	d0-d5,-(sp)
	add.w	d0,d0		;word per frame
	movea.l	a1,a0
	move.w	$2(a0,d0.w),d1		;next frame offset
	sub.w	(a0,d0.w),d1		;frame length
	lsr.w	#$3,d1		;8 bytes per sprite
	subi.w	#$1,d1		;minus 1 for dbf
	move.w	d1,-(sp)
	adda.w	(a0,d0.w),a0		;the frame's sprites
	move.w	d4,d0
	addi.w	#$C0,d0		;view X center
	move.w	d0,d1
	subi.w	#$90,d0		;X left limit
	addi.w	#$80,d1		;X right limit
	move.w	#$170,d2		;view Y center
	sub.w	d5,d2		;minus the camera Y
	move.w	d2,d3
	subi.w	#$80,d2		;Y top limit
	addi.w	#$70,d3		;Y bottom limit
	move.w	(sp)+,d4
.loop2	cmp.w	$2(a0),d2
	bgt.w	.next		;above the view: skip
	cmp.w	$2(a0),d3
	blt.w	.next		;below the view: skip
	cmp.w	(a0),d0
	bgt.w	.next		;left of the view: skip
	cmp.w	(a0),d1
	blt.w	.next		;right of the view: skip
	move.w	$2(a0),d5
	addi.w	#$70,d5
	sub.w	d2,d5
	move.w	d5,(a6)+
	move.b	$7(a0),(a6)+
	move.b	d6,(a6)+
	move.w	$6(a0),d5		;attribute
	andi.w	#$F800,d5		;flip and palette bits
	add.w	$4(a0),d5
	add.w	(arenaanimchars).l,d5		;plus the animation tile base
	move.w	d5,(a6)+
	move.w	(a0),d5
	addi.w	#$70,d5
	sub.w	d0,d5
	move.w	d5,(a6)+
	addi.w	#$1,d6
	cmpi.w	#$40,d6		;64 sprites at most?
	beq.w	.lE488		;table full: stop
.next	adda.w	#$8,a0
	dbra	d4,.loop2
.lE488	movem.l	(sp)+,d0-d5
.lE48C	rts
PrintPlayerNameRight						;Print the name of player d0 of team a2 (FormatPlayerName), moved left so
									;it ends before column $29 (a trailing pad byte or
									;two not counted), then the icon of HotColdIcon. Called from
									;PrintMatchupRatings
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	d0,(iconplayer).l		;player for the icon
	move.l	a2,-(sp)
	jsr	(FormatPlayerName).l
	movea.l	a1,a0
	move.w	(a0),d0
	move.w	d0,d5
	tst.b	-$1(a0,d5.w)		;trailing pad byte?
	bne.w	.0
	subi.w	#$1,d0		;first pad byte
	tst.b	-$2(a0,d5.w)		;second pad byte?
	bne.w	.0
	subi.w	#$1,d0		;second pad byte
.0	add.w	(printx).l,d0
	subi.w	#$29,d0		;past column $29?
	bmi.w	.1		;fits: leave printx
	neg.w	d0
	add.w	d0,(printx).l
.1	movea.l	a0,a1
	jsr	(print).l
	movea.l	(sp)+,a2
	jsr	(HotColdIcon).l		;hot / cold icon
	movem.l	(sp)+,d0-d7/a0-a6
	rts
SkipNameNumber						;Unreferenced. A1 = the FormatPlayerNumInitial String without its first 2
									;characters (the length word moved up 2)
	movem.l	d0-d7/a0/a2-a3,-(sp)
	jsr	(FormatPlayerNumInitial).l
	move.w	(a1),d0
	subi.w	#$2,d0
	move.w	d0,$2(a1)		;2 characters shorter
	adda.w	#$2,a1		;length word moved up
	movem.l	(sp)+,d0-d7/a0/a2-a3
	rts
	dc.w	$0006,$202E,$2000,$48E7,$FFFE,$48E7,$0180,$2079
	dc.w	$0004,$7D24,$3E3C,$0002,$4EB8,$6044,$4CDF,$0180
	dc.w	$2F0E,$2C79,$0001,$9360,$0839,$0005,$00FF,$800F
	dc.w	$6706,$3D3C,$0001,$6004,$3D3C,$0000,$08B9,$0005
	dc.w	$00FF,$800F,$23CE,$0001,$9360,$2C5F,$48E7,$E1C0
	dc.w	$3E3C,$0001,$303C,$0004,$4EB8,$6044,$23C8,$0004
	dc.w	$7D8C,$4CDF,$0387,$2F0E,$2C79,$0001,$9360,$4A5E
	dc.w	$670A,$08F9,$0005,$00FF,$800F,$6008,$08B9,$0005
	dc.w	$00FF,$800F,$23CE,$0001,$9360,$2C5F,$303C,$0002
	dc.w	$4EB8,$5F22,$303C,$0002,$4EB8,$5F22,$303C,$0080
	dc.w	$4EB8,$5F22,$6500,$FFF6,$303C,$0081,$4EB8,$5F22
	dc.w	$3410,$0242,$FF00,$0C42,$0000,$66EC,$33FC,$0005
	dc.w	$0001,$9364,$303C,$0013,$41F9,$0001,$9364,$4EB8
	dc.w	$5F22,$4EB9,$0003,$76D4,$4279,$0001,$A43A,$7000
	dc.w	$721C,$4EB9,$0002,$E728,$4EB9,$0003,$8F6E,$0006
	dc.w	$BE01,$0B00,$303C,$0008,$323C,$0008,$4EB9,$0003
	dc.w	$8CA0,$4EB9,$0003,$8F6E,$0006,$BE01,$1300,$303C
	dc.w	$0008,$323C,$0008,$4EB9,$0003,$8CA0,$4EB9,$0003
	dc.w	$8F6E,$0006,$9E02,$0C00,$2079,$0004,$7D8C,$3039
	dc.w	$0001,$7FB0,$E540,$2070,$0000,$2248,$2448,$D1DA
	dc.w	$E740,$207C,$0002,$AF56,$0440,$0040,$D0C0,$D3DA
	dc.w	$4281,$4280,$7406,$363C,$0006,$7A04,$4EB9,$0003
	dc.w	$87E2,$207C,$000B,$BCF0,$227C,$000B,$BD10,$303C
	dc.w	$0007,$22D8,$51C8,$FFFC,$4EB9,$0003,$8F6E,$0006
	dc.w	$8E02,$1400,$2079,$0004,$7D8C,$3039,$0001,$7FAE
	dc.w	$E540,$2070,$0000,$2248,$2448,$D1DA,$E740,$0440
	dc.w	$0040,$207C,$0002,$AF56,$D0C0,$D3DA,$4241,$4240
	dc.w	$7406,$363C,$0006,$7A04,$4EB9,$0003,$87E2,$4EB9
	dc.w	$0003,$8F6E,$0006,$BD04,$0100,$7020,$7206,$4EB9
	dc.w	$0003,$8CA0,$4EB9,$0003,$9258,$0018,$BD06,$0320
	dc.w	$2050,$6572,$696F,$6420,$5374,$6174,$7320,$20BE
	dc.w	$0601,$0839,$0001,$0001,$7F7A,$6700,$004A,$4EB9
	dc.w	$0003,$8F6E,$001C,$BE0C,$0931,$BE11,$0932,$BE16
	dc.w	$0933,$BE1A,$094F,$54BE,$2009,$546F,$7461,$6C00
	dc.w	$4EB9,$0003,$8F6E,$001C,$BE0C,$0A3C,$BE11,$0A3C
	dc.w	$BE16,$0A3C,$BE1A,$0A3C,$3CBE,$200A,$3C3C,$3C3C
	dc.w	$3C00,$6000,$003A,$4EB9,$0003,$8F6E,$0016,$BE0C
	dc.w	$0931,$BE11,$0932,$BE16,$0933,$BE20,$0954,$6F74
	dc.w	$616C,$4EB9,$0003,$8F6E,$0016,$BE0C,$0A3C,$BE11
	dc.w	$0A3C,$BE16,$0A3C,$BE20,$0A3C,$3C3C,$3C3C,$6100
	dc.w	$0132,$6100,$0178,$33FC,$0018,$0001,$8D62,$4EB9
	dc.w	$0002,$EDE2,$0801,$0007,$6600,$004E,$0801,$0002
	dc.w	$6600,$002A,$0801,$0003,$6600,$0006,$6000,$FFE0
	dc.w	$4A79,$0001,$A43A,$6600,$FFD6,$50F9,$0001,$A43A
	dc.w	$6100,$00F0,$6100,$0136,$6000,$FFC4,$4A79,$0001
	dc.w	$A43A,$6700,$FFBA,$4279,$0001,$A43A,$6100,$00D4
	dc.w	$6100,$011A,$6000,$FFA8,$4CDF,$7FFF,$48E7,$0180
	dc.w	$2079,$0004,$7D8C,$3E3C,$0002,$4EB8,$6044,$4CDF
	dc.w	$0180,$2F0E,$2C79,$0001,$9360,$0839,$0005,$00FF
	dc.w	$800F,$6706,$3D3C,$0001,$6004,$3D3C,$0000,$08B9
	dc.w	$0005,$00FF,$800F,$23CE,$0001,$9360,$2C5F,$48E7
	dc.w	$E1C0,$3E3C,$0001,$303C,$0002,$4EB8,$6044,$23C8
	dc.w	$0004,$7D24,$4CDF,$0387,$2F0E,$2C79,$0001,$9360
	dc.w	$4A5E,$670A,$08F9,$0005,$00FF,$800F,$6008,$08B9
	dc.w	$0005,$00FF,$800F,$23CE,$0001,$9360,$2C5F,$303C
	dc.w	$0002,$4EB8,$5F22,$303C,$0080,$4EB8,$5F22,$6500
	dc.w	$FFF6,$303C,$0081,$4EB8,$5F22,$3410,$0242,$FF00
	dc.w	$0C42,$0000,$66EC,$33FC,$0005,$0001,$9364,$303C
	dc.w	$0013,$41F9,$0001,$9364,$4EB8,$5F22,$4EF9,$0002
	dc.w	$E980,$4A79,$0001,$A43A,$6700,$0022,$4EB9,$0003
	dc.w	$8F6E,$0018,$BE12,$0753,$686F,$7473,$BE0F,$1A5B
	dc.w	$2046,$6F72,$2047,$6F61,$6C73,$4E75,$4EB9,$0003
	dc.w	$8F6E,$0018,$BE12,$0747,$6F61,$6C73,$BE0F,$1A46
	dc.w	$6F72,$2053,$686F,$7473,$205D,$4E75,$48E7,$FFFE
	dc.w	$4EB9,$0003,$8F6E,$0006,$BE00,$0000,$247C,$0001
	dc.w	$86B2,$33FC,$000E,$0001,$8D5A,$6100,$001A,$247C
	dc.w	$0001,$834C,$33FC,$0016,$0001,$8D5A,$6100,$0008
	dc.w	$4CDF,$7FFF,$4E75,$41EA,$0344,$4A79,$0001,$A43A
	dc.w	$6700,$0006,$41EA,$034C,$4279,$0001,$A44A,$33FC
	dc.w	$000B,$0001,$8D58,$6100,$0096,$0C79,$0001,$0001
	dc.w	$80E4,$6D00,$004A,$33FC,$0010,$0001,$8D58,$6100
	dc.w	$007E,$0C79,$0002,$0001,$80E4,$6D00,$0032,$33FC
	dc.w	$0015,$0001,$8D58,$6100,$0066,$0C79,$0003,$0001
	dc.w	$80E4,$6D00,$001A,$0839,$0001,$0001,$7F7A,$6700
	dc.w	$000E,$33FC,$001A,$0001,$8D58,$6100,$0042,$33FC
	dc.w	$0021,$0001,$8D58,$4EB9,$0003,$8F6E,$0006,$2020
	dc.w	$2000,$0479,$0003,$0001,$8D58,$3039,$0001,$A44A
	dc.w	$323C,$0002,$0C40,$0064,$6D00,$0006,$323C,$0003
	dc.w	$4EB9,$0003,$919A,$4EB9,$0003,$8F80,$4E75,$3018
	dc.w	$D179,$0001,$A44A,$4EB9,$0003,$8F6E,$0006,$2020
	dc.w	$2000,$0479,$0003,$0001,$8D58,$323C,$0002,$0C40
	dc.w	$0064,$6D00,$0006,$323C,$0003,$4EB9,$0003,$919A
	dc.w	$4EF9,$0003,$8F80
StatsReport						;"Game Statistics" menu item (menu lists): both
									;teams' totals (DisplayStats). There are more rows than the screen:
									;up / down scroll them (matchupvis the most, $70 or $30 without penalties,
									;OptPen), start exits (ExitStatsScreen)
	moveq	#$9,d0
	moveq	#$1A,d1
	jsr	(SetupScreen).l		;set up the screen
	jsr	(printz).l
	String	CC_Font3Pri,$4,$1
	moveq	#$20,d0
	moveq	#$6,d1
	jsr	(Framer).l		;draw the box
	jsr	(printbigz).l
	String	CC_Font3Pri,$6,$4,'Game  Statistics',CC_Font3Pri,$7,$1
	dc.w	$303C,$002C,$4EB9,$0002,$C59E,$0679,$0004,$0001
	dc.w	$8D58,$4240,$4EB9,$0002,$C59E,$4279,$0001,$A44E
	dc.w	$4279,$0001,$A450,$4279,$0001,$A452,$33FC,$0070
	dc.w	$0001,$A440,$4A79,$0001,$8C08,$6600,$000A,$33FC
	dc.w	$0030,$0001,$A440,$6100,$020A,$6100,$0186,$4EB9
	dc.w	$0002,$C63A,$4EB9,$0002,$F2F0,$0803,$0007,$6700
	dc.w	$0008,$4EF9,$0002,$E980,$4EB9,$0003,$7496,$303C
	dc.w	$FFFE,$0803,$0000,$6600,$000C,$4440,$0803,$0001
	dc.w	$6700,$0008,$33C0,$0001,$A452,$6100,$000A,$6100
	dc.w	$0142,$6000,$FFBA,$3039,$0001,$A452,$6700,$04EC
	dc.w	$D079,$0001,$A450,$6B00,$04E2,$B079,$0001,$A440
	dc.w	$6E00,$04D8,$3239,$0001,$A450,$33C0,$0001,$A450
	dc.w	$0240,$000F,$6600,$0008,$4279,$0001,$A452,$0241
	dc.w	$000F,$6600,$001E,$3F00,$0C40,$000E,$6600,$0006
	dc.w	$6100,$00D2,$301F,$0C40,$0002,$6600,$0006,$6100
	dc.w	$00D0,$3F39,$0001,$8D64,$08F9,$0002,$0001,$8D64
	dc.w	$207C,$00C0,$0000,$0839,$0007,$00FF,$800E,$66F6
	dc.w	$23FC,$4002,$0010,$00FF,$8022,$33FC,$000B,$00FF
	dc.w	$8020,$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9
	dc.w	$0007,$00FF,$800F,$303C,$FFB0,$D079,$0001,$A450
	dc.w	$0839,$0007,$00FF,$800E,$66F6,$33C0,$00FF,$8022
	dc.w	$33FC,$000D,$00FF,$8020,$08F9,$0006,$00FF,$800F
	dc.w	$0839,$0006,$00FF,$800E,$67F6,$08F9,$0007,$00FF
	dc.w	$800F,$08B9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$66F6,$08B9,$0007,$00FF,$800F,$33DF,$0001
	dc.w	$8D64,$4E75,$3639,$0001,$A450,$E84B,$6000,$0012
	dc.w	$3639,$0001,$A450,$E84B,$0643,$0006,$6000,$0002
	dc.w	$4E75,$48E7,$FFFE,$4EB9,$0003,$8D8C,$0004,$F901
	dc.w	$4A79,$0001,$A450,$6700,$0016,$4EB9,$0003,$8D8C
	dc.w	$000A,$F804,$0326,$08F9,$017B,$6000,$0012,$4EB9
	dc.w	$0003,$8D8C,$000A,$F804,$0326,$08F9,$0120,$3039
	dc.w	$0001,$A440,$B079,$0001,$A450,$6700,$0016,$4EB9
	dc.w	$0003,$8D8C,$000A,$F804,$0326,$1AF9,$017D,$6000
	dc.w	$0012,$4EB9,$0003,$8D8C,$000A,$F804,$0326,$1AF9
	dc.w	$0120,$4EB9,$0003,$8D8C,$0004,$F900,$4CDF,$7FFF
	dc.w	$4E75
DisplayStats						;Team logos (PutTeamBlock), then each
									;TeamStatTextTbl row (TeamStatTextTblNoPen when penalties are off, OptPen)
									;centred, with the home value at x $22 and the visitors' at x 9
									;(PrintStatValue); SetStatScroll first
	jsr	(printz).l
	String	CC_Font3Pri,$2,$7		;visitors logo position
	move.w	#$2C,d0
	jsr	(PutTeamBlock).l
	jsr	(printz).l
	String	CC_Font3Pri,$1A,$7		;home logo position
	moveq	#$0,d0
	jsr	(PutTeamBlock).l
	bsr.w	X_EB5E
	jsr	(printz).l
	String	CC_Font2Pri,$0,$0
	moveq	#$E,d6		;15 rows
	lea.l	X_EE56(pc),a1
	tst.w	(OptPen).l
	bne.w	.row
	move.w	#$A,d6		;11 rows
	lea.l	X_EF44(pc),a1
.row	move.w	(a1),d0
	lsr.w	#$1,d0		;half the label width
	neg.w	d0
	addi.w	#$15,d0		;centre the label around x $15
	move.w	d0,(printx).l
	jsr	(print).l
	movea.l	a1,a0		;a0 = stat offsets
	move.w	#$22,(printx).l
	movea.l	#tmstruct,a2
	bsr.w	PrintStatValue
	move.w	#$9,(printx).l
	lea.l	$366(a2),a2
	bsr.w	PrintStatValue		;away team value, centred at x 9
	lea.l	$4(a0),a1
	addi.w	#$2,(printy).l		;2 map rows per table row
	dbra	d6,.row
	rts
PrintStatValue						;Print TeamStatTextTbl entry a0 for team a2 centred at printx: the value
									;(tmATOP and tmPwrPlayTime are times
									;PushTime), "/second" if any, " (pct%)" for passing. Offset $FFFF is the
									;shooting percentage (tmscore * 100 / tmshots), printed with a "%"
	movea.l	#mesarea,a3
	move.w	#$2,(a3)		;empty string
	cmpi.w	#$FFFF,(a0)		;shooting percentage row
	bne.w	.1
	move.w	#$C,d0
	move.w	(a2,d0.w),d0
	mulu.w	#$64,d0
	move.w	#$0,d1
	move.w	(a2,d1.w),d1
	beq.w	.0
	divu.w	d1,d0
.0	jsr	(PushNumber).l
	jsr	(appstring).l
	jsr	(appendz).l
	String	'%'
	bra.w	.6		;print it
.1	move.w	(a0),d0
	move.w	(a2,d0.w),d0
	cmpi.w	#$354,(a0)		;PP minutes row?
	bne.w	.2
	bsr.w	.8
	bra.w	.4		;time appended
.2	cmpi.w	#$A,(a0)		;ATOP row?
	beq.w	.3
	bsr.w	.7
.3	cmpi.w	#$A,(a0)		;ATOP row?
	bne.w	.4
	bsr.w	.8
.4	jsr	(appstring).l
	move.w	$2(a0),d0		;second offset
	bmi.w	.6
	jsr	(appendz).l
	String	'/'
	move.w	(a2,d0.w),d0
	jsr	(PushNumber).l
	jsr	(appstring).l
	cmpi.w	#$14,(a0)		;passing row?
	bne.w	.6
	jsr	(appendz).l
	String	' ('
	move.w	(a0),d0
	move.w	(a2,d0.w),d0
	mulu.w	#$64,d0
	move.w	$2(a0),d1
	move.w	(a2,d1.w),d1
	beq.w	.5
	divu.w	d1,d0
.5	jsr	(PushNumber).l
	jsr	(appstring).l
	jsr	(appendz).l
	String	'%)'
.6	movea.l	a3,a1
	move.w	(a1),d0
	lsr.w	#$1,d0
	sub.w	d0,(printx).l
	jmp	(print).l
.7	jmp	(PushNumber).l
.8	jmp	(PushTime).l
	dc.w	$0008
	dc.w	$5363,$6F72,$6500,$000C,$FFFF,$0008,$5368,$6F74
	dc.w	$7300,$0000,$FFFF,$000E,$5368,$6F6F,$7469,$6E67
	dc.w	$2050,$6374,$FFFF,$FFFF,$000C,$506F,$7765,$7220
	dc.w	$506C,$6179,$0002,$0004,$000C,$5050,$204D,$696E
	dc.w	$7574,$6573,$0354,$FFFF,$000A,$5050,$2053,$686F
	dc.w	$7473,$0356,$FFFF,$000A,$5348,$2047,$6F61,$6C73
	dc.w	$0358,$FFFF,$000C,$4272,$6561,$6B61,$7761,$7973
	dc.w	$035C,$035A,$000C,$4F6E,$652D,$5469,$6D65,$7273
	dc.w	$0360,$035E,$0010,$5065,$6E61,$6C74,$7920,$5368
	dc.w	$6F74,$7300,$0364,$0362,$000E,$4661,$6365,$6F66
	dc.w	$6673,$2057,$6F6E,$000E,$FFFF,$000E,$426F,$6479
	dc.w	$2043,$6865,$636B,$7300,$0010,$FFFF,$000C,$5065
	dc.w	$6E61,$6C74,$6965,$7300,$0006,$0008,$000E,$4174
	dc.w	$7461,$636B,$205A,$6F6E,$6500,$000A,$FFFF,$000A
	dc.w	$5061,$7373,$696E,$6700,$0014,$0012,$0008,$5363
	dc.w	$6F72,$6500,$000C,$FFFF,$0008,$5368,$6F74,$7300
	dc.w	$0000,$FFFF,$000E,$5368,$6F6F,$7469,$6E67,$2050
	dc.w	$6374,$FFFF,$FFFF,$000C,$4272,$6561,$6B61,$7761
	dc.w	$7973,$035C,$035A,$000C,$4F6E,$652D,$5469,$6D65
	dc.w	$7273,$0360,$035E,$0010,$5065,$6E61,$6C74,$7920
	dc.w	$5368,$6F74,$7300,$0364,$0362,$000E,$4661,$6365
	dc.w	$6F66,$6673,$2057,$6F6E,$000E,$FFFF,$000E,$426F
	dc.w	$6479,$2043,$6865,$636B,$7300,$0010,$FFFF,$000C
	dc.w	$5065,$6E61,$6C74,$6965,$7300,$0006,$0008,$000E
	dc.w	$4174,$7461,$636B,$205A,$6F6E,$6500,$000A,$FFFF
	dc.w	$000A,$5061,$7373,$696E,$6700,$0014,$0012,$4E75
updatePPTeamTime						;One more second of power play time (tmPwrPlayTime) for the team
									;on the power play (sflags2 bit 5, bit 6 the visitors). Called from
									;updatepentime
	btst	#$5,$17F6C.l
	beq.w	.x
	movea.l	#tmstruct,a2		;move home team struct into a2
	btst	#$6,$17F6C.l		;check who's on PP
	beq.w	.0		;branch if home (team 1)
	movea.l	#awtmstruct,a2		;move away team struct into a2
.0	addi.w	#$1,$354(a2)		;one more second of power play time
.x	rts
GetTeamRating						;d0 = the TeamRatings byte of team tmteam(a2). Called from PrintTeamRating
									;(the player card "Team Rating") and PrintMatchupRating
	movem.l	d1-d7/a0-a6,-(sp)
	move.w	$2A(a2),d0
	movea.l	#TeamRatings,a0
	clr.w	d1
	move.b	(a0,d0.w),d1
	move.w	d1,d0
	movem.l	(sp)+,d1-d7/a0-a6
	rts
	dc.w	$334C,$494B,$4E43,$4B43,$3442,$4A49,$4442,$4A37
	dc.w	$454B,$4738,$4538,$4847,$4846,$5B59
ShortenMsgTimer						;Cap msgtimer at 2, unless a second pad is on (cont2team) and a3 is not
									;the puck carrier. Called from doinput
	movem.l	d0,-(sp)
	tst.w	(cont2team).l
	beq.w	.0
	move.w	$52(a3),d0
	cmp.w	$17BE0.l,d0
	bne.w	.x
.0	cmpi.w	#$2,$17F98.l
	ble.w	.x
	move.w	#$2,$17F98.l
.x	movem.l	(sp)+,d0
	rts
ManualGoalieMenu						;"x Manual Goalie" menu item (menu lists; PrintMenuItem prints Manual /
									;Auto Goalie from the same words): with OptNOP set, toggle the goalie mode
									;of the pause pad (goaliemode2 for pad 2, sflags bit 1, else goaliemode1;
									;both when the pads are on one team). In a penalty shot or shootout
									;(gmode2 bit 0, BA_PS_flags bit 2) the pad then takes player 0 / 6 or 5 /
									;$B by its mode, when BA_Sktr_SCnum is on its side (setc1player /
									;setc2player)
	movem.l	d0-d7/a0-a6,-(sp)
	tst.w	(OptNOP).l		;goalie option set?
	beq.w	.chkso		;no goalie option: switch only
	move.w	(cont1team).l,d0
	cmp.w	(cont2team).l,d0		;same team?
	bne.w	.0		;pads on different teams
	eori.w	#$1,(goaliemode2).l		;toggle pad 2's goalie mode
	bra.w	.g1		;same team: pad 1 too
.0	btst	#$1,$17F6A.l		;which pad paused?
	beq.w	.g1		;pad 1 paused
	eori.w	#$1,(goaliemode2).l		;toggle pad 2's goalie mode
	bra.w	.chkso
.g1	eori.w	#$1,(goaliemode1).l		;toggle pad 1's goalie mode
.chkso	btst	#$0,$17F78.l		;shootout?
	bne.w	.so
	btst	#$2,$17F70.l		;penalty shot?
	beq.w	.x
.so	btst	#$1,$17F6A.l		;which pad paused?
	bne.w	.p2		;pad 2 paused
	cmpi.w	#$2,(OptNOP).l		;OptNOP 2?
	bne.w	.4
	cmpi.w	#$5,(BA_Sktr_SCnum).l		;visiting shooter?
	bgt.w	.x		;skater on the other side
	bra.w	.5
.4	cmpi.w	#$5,(BA_Sktr_SCnum).l		;home shooter?
	ble.w	.x		;skater on the other side
.5	move.w	#$0,d0		;goalie slot 0
	cmpi.w	#$2,(OptNOP).l
	bne.w	.6		;not OptNOP 2
	move.w	#$6,d0		;OptNOP 2: slot 6
.6	tst.w	(goaliemode1).l		;goalie mode of pad 1
	bne.w	.set1		;manual: the goalie
	move.w	#$5,d0		;skater slot 5
	cmpi.w	#$2,(OptNOP).l
	bne.w	.set1
	move.w	#$B,d0		;OptNOP 2: skater slot $B
.set1	jsr	(setc1player).l
	bra.w	.x
.p2	cmpi.w	#$2,(OptNOP).l		;OptNOP 2?
	bne.w	.9
	cmpi.w	#$5,(BA_Sktr_SCnum).l		;home shooter?
	ble.w	.x		;skater on the other side
	bra.w	.10
.9	cmpi.w	#$5,(BA_Sktr_SCnum).l		;visiting shooter?
	bgt.w	.x		;skater on the other side
.10	move.w	#$6,d0		;goalie slot 6
	tst.w	(goaliemode2).l		;goalie mode of pad 2
	bne.w	.set2		;manual: the goalie
	move.w	#$B,d0		;skater slot
.set2	jsr	(setc2player).l
.x	movem.l	(sp)+,d0-d7/a0-a6
	rts
