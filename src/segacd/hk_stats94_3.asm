	include	segacd\hockey.inc
	include	macros\genesis.mac

CC_Font3Pri	equ	$BD
CC_SetMapAndPosition	equ	$F8
FormatAndPrintTime	equ	$390C0
FormatPlayerNumInitial	equ	$41192
Framer	equ	$38CA0
Penaltylist	equ	$4165C
PlayerScrollCtr	equ	$1A452
PushNumber	equ	$3915E
ReadTeamStats	equ	$408E0
SelectedPlayerIdx	equ	$1A454
VertLineScrolling	equ	$1A450
eraser	equ	$38C06
move	equ	$2C9C8
potreeteam	equ	$18AA0
print	equ	$38F80
printa	equ	$18D5C
printbigz	equ	$39258
printsmall	equ	$38D9E
printsmallz	equ	$38D8C
printx	equ	$18D58
printy	equ	$18D5A
printz	equ	$38F6E
scoutcolumn	equ	$1A44E
tmstruct	equ	$1834C
X_12EA8	equ	$12EA8
X_12FFA	equ	$12FFA
X_130BC	equ	$130BC
X_130C8	equ	$130C8
X_133A4	equ	$133A4
X_13436	equ	$13436
X_134EE	equ	$134EE
X_13728	equ	$13728
X_13D60	equ	$13D60
X_14988	equ	$14988

	org	$12CEA

DisplayPenaltyEntry						;Print PenSum entry d3: time, team (bit 7 of byte 2 = away), minutes and
									;name from Penaltylist, player (byte 3)
	move.w	(printy).l,-(sp)
	moveq	#$28,d0		;width 40 cells
	moveq	#$3,d1		;3 rows high
	move.w	#$7FF,d2		;blank tile
	jsr	(eraser).l
	move.w	(sp)+,(printy).l
	movea.l	#$1825C,a0
	move.w	(a0,d3.w),d0		;penalty time
	move.w	#$1,(printx).l
	jsr	(FormatAndPrintTime).l		;print it
	movea.l	#tmstruct,a2
	btst	#$7,$2(a0,d3.w)		;away penalty?
	beq.w	.0
	adda.w	#$366,a2
.0	movea.l	$1E(a2),a1		;team data -> team name string
	adda.w	$4(a1),a1
	adda.w	(a1),a1
	move.w	#$C,(printx).l
	jsr	(print).l
	move.b	$2(a0,d3.w),d0
	andi.w	#$7F,d0		;strip the away bit
	movea.l	#Penaltylist,a3
	adda.w	(a3,d0.w),a3
	clr.w	d0
	move.b	$1(a3),d0		;penalty minutes
	jsr	(PushNumber).l
	move.w	#$23,(printx).l
	jsr	(print).l
	move.w	#$10,(printx).l
	clr.w	d0
	move.b	$3(a0,d3.w),d0
	jsr	(FormatPlayerNumInitial).l		;his number and name
	jsr	(print).l
	addi.w	#$1,(printy).l
	move.w	#$13,(printx).l
	move.w	#$E000,(printa).l
	lea.l	$2(a3),a1		;penalty name string
	jmp	(print).l
	dc.w	$48E7,$C040,$4EB9,$0003,$8D8C,$000A,$F804,$0304
	dc.w	$09F9,$0100,$4240,$3239,$0001,$A450,$4A41,$5EC0
	dc.w	$4400,$B279,$0001,$A454,$5DC1,$4401,$D001,$D001
	dc.w	$43FA,$000E,$4EB9,$0003,$CEBE,$4CDF,$0203,$4E75
	dc.w	$000A,$20FB,$FFFA,$1120,$F900,$000A,$7BFB,$FFFA
	dc.w	$1120,$F900,$000A,$20FB,$FFFA,$117D,$F900,$000A
	dc.w	$7BFB,$FFFA,$117D,$F900
PlayoffStatsScreen						;"Playoff Stats": the playoff totals (ReadTeamStats) of the potreeteam
									;team as PlayerStatsList with d7 = 1. Called and the menu lists
	movem.l	a2,-(sp)
	jsr	(ReadTeamStats).l		;load the playoff team stats
	movea.l	#$18AA6,a0
	move.w	(potreeteam).l,d0		;user tree position
	move.b	(a0,d0.w),d0		;his team
	movea.l	#tmstruct,a2
	cmp.w	$2A(a2),d0		;is it home?
	beq.w	.0
	adda.w	#$366,a2
.0	moveq	#$1,d7		;playoff mode: stats come from the playoff RAM tables
	bsr.w	PlayerStatsList
	movem.l	(sp)+,a2
	rts
	dc.w	$4247
PlayerStatsList						;Stats screen for team a2, d7 = 0 game / 1 playoff: the column headers,
									;the players sorted by the selected column (left / right), up / down
									;scroll, A switches teams (game stats only), start exits
	moveq	#$D,d0		;bitmap row $D
	moveq	#$16,d1
	bsr.w	X_13728		;set up the screen
	clr.w	(scoutcolumn).l		;sort column: -1 goalie saves, 0-4 G A Pts SOG PIM; start with goals
	clr.w	(VertLineScrolling).l		;list scrolled to the top
	clr.w	(PlayerScrollCtr).l
	jsr	(printz).l
	String	CC_Font3Pri,$5,$1
	moveq	#$1E,d0
	moveq	#$6,d1
	jsr	(Framer).l		;draw the frame
	tst.w	d7		;playoff stats?
	beq.w	X_12EA8
	jsr	(printbigz).l
	String	CC_Font3Pri,$7,$4,'Playoff  Stats',CC_Font3Pri,$E,$1
	dc.w	$6000,$0040,$4EB9,$0003,$8D8C,$001C,$F806,$030C
	dc.w	$1AF9,$0141,$5E2D,$5E53,$7769,$7463,$685E,$5465
	dc.w	$616D,$73F9,$0000,$4EB9,$0003,$9258,$0016,$BD08
	dc.w	$0450,$6C61,$7965,$7220,$2053,$7461,$7473,$BD0E
	dc.w	$0100,$4240,$B5FC,$0001,$834C,$6700,$0004,$702C
	dc.w	$6100,$E6A8,$6100,$01DE,$6100,$05F0,$6100,$E738
	dc.w	$6100,$13EA,$0803,$0007,$6600,$0A72,$0801,$0006
	dc.w	$6600,$0066,$4EB9,$0003,$7496,$7001,$0801,$0003
	dc.w	$6600,$002E,$4440,$0801,$0002,$6600,$0024,$70FE
	dc.w	$0803,$0000,$6600,$000C,$4440,$0803,$0001,$6700
	dc.w	$0008,$33C0,$0001,$A452,$6100,$004C,$6000,$FFAE
	dc.w	$D079,$0001,$A44E,$0C40,$FFFF,$6D00,$FFEC,$0C40
	dc.w	$0004,$6E00,$FFE4,$33C0,$0001,$A44E,$6100,$0166
	dc.w	$6100,$0578,$6000,$FFD2,$4A47,$6600,$FFCC,$45EA
	dc.w	$0366,$B5FC,$0001,$86B2,$6700,$FED8,$247C,$0001
	dc.w	$834C,$6000,$FECE
UpdateStatsListScroll						;Stats screen per frame: scroll 0 ... SelectedPlayerIdx, stop on a 16 line
									;boundary, draw the row coming into view
	move.w	(PlayerScrollCtr).l,d0
	beq.w	X_14988
	add.w	(VertLineScrolling).l,d0		;new position
	bmi.w	X_14988		;above the top: ignore
	cmp.w	(SelectedPlayerIdx).l,d0		;past the limit?
	bgt.w	X_14988
	move.w	(VertLineScrolling).l,d1		;d1 = old position
	move.w	d0,(VertLineScrolling).l
	andi.w	#$F,d0		;pixels into the current 16 pixel row
	bne.w	.0
	bsr.w	X_134EE		;landed on a row boundary: refresh arrows and stop scrolling
	clr.w	(PlayerScrollCtr).l
.0	andi.w	#$F,d1		;old position within its row
	bne.w	X_12FFA
	move.w	d0,-(sp)
	cmpi.w	#$E,d0		;14 pixels in: moved up, draw the row above
	bne.w	.1
	bsr.w	X_130BC
.1	move.w	(sp)+,d0		;restore the pixels into the row
	cmpi.w	#$2,d0		;2 pixels in: moved down, draw the row below
	bne.w	X_12FFA
	bsr.w	X_130C8		;falls into the scroll register write
	dc.w	$3F39,$0001,$8D64,$08F9,$0002,$0001,$8D64,$207C
	dc.w	$00C0,$0000,$0839,$0007,$00FF,$800E,$66F6,$23FC
	dc.w	$4002,$0010,$00FF,$8022,$33FC,$000B,$00FF,$8020
	dc.w	$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF,$800E
	dc.w	$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007
	dc.w	$00FF,$800F,$303C,$FF98,$D079,$0001,$A450,$0839
	dc.w	$0007,$00FF,$800E,$66F6,$33C0,$00FF,$8022,$33FC
	dc.w	$000D,$00FF,$8020,$08F9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$67F6,$08F9,$0007,$00FF,$800F
	dc.w	$08B9,$0006,$00FF,$800F,$0839,$0006,$00FF,$800E
	dc.w	$66F6,$08B9,$0007,$00FF,$800F,$33DF,$0001,$8D64
	dc.w	$4E75,$3639,$0001,$A450,$E84B,$6000,$0166,$3639
	dc.w	$0001,$A450,$E84B,$0643,$0006,$6000,$0156,$4EB9
	dc.w	$0003,$8D8C,$0012,$F806,$0304,$0BF9,$0150,$6C61
	dc.w	$7965,$72FB,$0700
	lea.l	X_13436(pc),a1
	moveq	#$5,d3
	tst.w	(scoutcolumn).l
	bmi.w	.l13104
	adda.w	(a1),a1
	clr.w	d3
.l13104	move.w	#$8000,(printa).l
	cmp.w	(scoutcolumn).l,d3
	bne.w	.l1311E
	move.w	#$C000,(printa).l
.l1311E	jsr	(printsmall).l
	addi.w	#$1,d3
	cmpi.w	#$5,d3
	blt.w	.l13104
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,$9,$7
	dc.w	$7016,$7203,$4EB9,$0003,$8CA0,$4EB9,$0003,$8F6E
	dc.w	$0006,$8D0A,$0800,$43FA,$0314,$7001,$D079,$0001
	dc.w	$A44E,$4EB9,$0003,$CEBE,$4279,$0001,$8D60,$267C
	dc.w	$000B,$BD30,$4286,$4A79,$0001,$A44E,$6A00,$000E
	dc.w	$6100,$0BE0,$01C6,$0446,$0001,$4686,$78FF,$50C5
	dc.w	$6100,$0C2C,$6000,$0044,$0106,$6600,$003E,$4242
	dc.w	$3239,$0001,$A44E,$6B00,$0006,$6100,$01DE,$48C2
	dc.w	$E182,$226A,$001E,$D2E9,$0000,$3200,$92FC,$0008
	dc.w	$D2FC,$0008,$D2D1,$51C9,$FFF8,$143C,$00FF,$9411
	dc.w	$B484,$6F00,$0006,$2802,$3A00,$51C8,$FFBC,$0BC6
	dc.w	$16C5,$6A00,$FFA8,$7005,$50F3,$0000,$51C8,$FFFA
	dc.w	$200B,$0480,$000B,$BD36,$6A00,$0004,$4240,$E940
	dc.w	$33C0,$0001,$A454,$B079,$0001,$A450,$6400,$0008
	dc.w	$33C0,$0001,$A450,$7805,$3639,$0001,$A450,$E84B
	dc.w	$D644,$6100,$000A,$51CC,$FFF0,$6000,$FDD0,$287C
	dc.w	$000B,$BD30,$D8C3,$4EB9,$0003,$8F6E,$0006,$BE00
	dc.w	$0000,$D643,$0243,$001F,$33C3,$0001,$8D5A,$7028
	dc.w	$7201,$343C,$07FF,$4EB9,$0003,$8C06,$4A14,$6B00
	dc.w	$172A,$0479,$0001,$0001,$8D5A,$33FC,$0001,$0001
	dc.w	$8D58,$200C,$0480,$000B,$BD2F,$7202,$33FC,$E000
	dc.w	$0001,$8D5C,$4EB9,$0003,$919A,$4EB9,$0003,$8F80
	dc.w	$4240,$1014,$4EB9,$0004,$11D6,$0679,$0001,$0001
	dc.w	$8D58,$33FC,$8000,$0001,$8D5C,$4EB9,$0003,$8F80
	dc.w	$33FC,$0011,$0001,$8D58,$4A79,$0001,$A44E,$6B00
	dc.w	$0048,$4245,$4240,$1014,$3205,$6100,$00BE,$3002
	dc.w	$7204,$4EB9,$0003,$919A,$33FC,$8000,$0001,$8D5C
	dc.w	$BA79,$0001,$A44E,$6600,$000A,$33FC,$C000,$0001
	dc.w	$8D5C,$4EB9,$0003,$8F80,$0645,$0001,$0C45,$0005
	dc.w	$6600,$FFC2,$6000,$0082,$4240,$1014,$7203,$6100
	dc.w	$0096,$4240,$1014,$7200,$3F02,$6100,$008A,$301F
	dc.w	$3600,$9042,$6A00,$0004,$4240,$3400,$7204,$4EB9
	dc.w	$0003,$919A,$0679,$0001,$0001,$8D58,$4EB9,$0003
	dc.w	$8F80,$3003,$7204,$4EB9,$0003,$919A,$0679,$0002
	dc.w	$0001,$8D58,$4EB9,$0003,$8F80,$4A43,$6700,$0008
	dc.w	$C4FC,$0064,$84C3,$3002,$7204,$4EB9,$0003,$919A
	dc.w	$0679,$0002,$0001,$8D58,$4EB9,$0003,$8F80,$4EB9
	dc.w	$0003,$8F6E,$0004,$2500,$4E75
GetStatColumn						;d2 = stat column d1 for player d0. Goalies only have PIM (btst d1,#6
									;picks the columns kept)
	move.w	d0,-(sp)
	bsr.w	X_13D60
	move.w	d0,d2
	move.w	(sp)+,d0
	cmp.w	d2,d0		;goalie?
	bge.w	X_133A4		;skater: read the column as is
	clr.w	d2		;goalie: columns 1 and 2 (A, Pts) show column 1 (assists), the rest 0
	dc.w	$033C,$0006,$6700
	dc.w	$15E8
	dc.w	$7201,$4A47,$6600,$002A,$43FA,$0076,$E541,$D2C1
	dc.w	$4281,$3211,$D240,$4282,$1432,$1800,$3229,$0002
	dc.w	$6B00,$15C4,$D240,$4243,$1632,$1800,$D443,$4E75
	dc.w	$E541,$D040,$4242,$6100,$000E,$0641,$0002,$6100
	dc.w	$0006,$E248,$4E75,$227C,$0002,$E40E,$4A71,$1000
	dc.w	$6700,$1594,$3271,$1000,$2F07,$2E09,$0287,$0000
	dc.w	$FFFF,$2247,$2E1F,$D471,$0000,$4E75,$B000,$0000
	dc.w	$B034,$0000,$B000,$B034,$B068,$0000,$B09C,$0000
	dc.w	$00B6,$FFFF,$00D0,$FFFF,$00B6,$00D0,$00EA,$FFFF
	dc.w	$0104,$FFFF,$0016,$5361,$7665,$7320,$5368,$6F74
	dc.w	$7320,$5361,$7665,$2025,$2020,$0006,$2020,$2047
	dc.w	$0006,$2020,$2041,$0006,$2050,$7473,$0006,$2053
	dc.w	$4F47,$0006,$2050,$494D,$0016,$2020,$2020,$476F
	dc.w	$616C,$6965,$2053,$6176,$6573,$2020,$205D,$0016
	dc.w	$5B20,$2020,$2020,$2047,$6F61,$6C73,$2020,$2020
	dc.w	$2020,$205D,$0016,$5B20,$2020,$2020,$4173,$7369
	dc.w	$7374,$7320,$2020,$2020,$205D,$0016,$5B20,$2020
	dc.w	$2020,$2050,$6F69,$6E74,$7320,$2020,$2020,$205D
	dc.w	$0016,$5B20,$2053,$686F,$7473,$204F,$6E20,$476F
	dc.w	$616C,$2020,$205D,$0016,$5B20,$5065,$6E61,$6C74
	dc.w	$7920,$4D69,$6E75,$7465,$7320,$2020,$48E7,$C040
	dc.w	$4EB9,$0003,$8D8C,$000A,$F804,$0302,$0BF9,$0100
	dc.w	$4240,$3239,$0001,$A450,$4A41,$5EC0,$4400,$B279
	dc.w	$0001,$A454,$5DC1,$4401,$D001,$D001,$43FA,$000E
	dc.w	$4EB9,$0003,$CEBE,$4CDF,$0203,$4E75,$000A,$20FB
	dc.w	$FFFA,$0C20,$F900,$000A,$7BFB,$FFFA,$0C20,$F900
	dc.w	$000A,$20FB,$FFFA,$0C7D,$F900,$000A,$7BFB,$FFFA
	dc.w	$0C7D,$F900,$7009,$721C,$6100,$01CC,$4EB9,$0003
	dc.w	$8F6E,$0006,$BD06,$0100,$701C,$7206,$4EB9,$0003
	dc.w	$8CA0,$4EB9,$0003,$9258,$0014,$BD09,$0443,$726F
	dc.w	$7764,$2020,$4D65,$7465,$72BD,$0701,$702C,$6100
	dc.w	$E00C,$0679,$0004,$0001,$8D58,$4240,$6100,$DFFE
	dc.w	$6100,$0012,$6100,$083A,$0801,$0007,$6600,$03D0
	dc.w	$6000,$FFF2,$4EB9,$0003,$8D8C,$0016,$F804,$0204
	dc.w	$0C43,$7572,$7265,$6E74,$204C,$6576,$656C,$FD1C
	dc.w	$3039,$0001,$7CD8,$6100,$0124,$4EB9,$0003,$8D8C
	dc.w	$0016,$FD04,$FA02,$4176,$6572,$6167,$6520,$4C65
	dc.w	$7665,$6CFD,$1C00,$2039,$0001,$7CDE,$80F9,$0001
	dc.w	$7CDC,$6100,$00F8,$4EB9,$0003,$8D8C,$0012,$FD04
	dc.w	$FA02,$5065,$616B,$204C,$6576,$656C,$FD1C,$3039
	dc.w	$0001,$7CDA,$6100,$00D6,$48E7,$FFFE,$4A79,$0001
	dc.w	$93BA,$6B00,$00C2,$3239,$0001,$7FAE,$48C1,$207C
	dc.w	$000B,$C000,$4EB9,$0002,$258E,$1028,$0008,$6600
	dc.w	$0006,$103C,$0050,$0240,$00FF,$3F00,$4EB9,$0003
	dc.w	$8D8C,$0014,$FD04,$FA02,$4172,$656E,$6120,$5265
	dc.w	$636F,$7264,$FD1C,$301F,$323C,$0003,$4EB9,$0003
	dc.w	$919A,$4EB9,$0003,$8F80,$4EB9,$0003,$8F6E,$0006
	dc.w	$2064,$4200,$4EB9,$0002,$AC02,$3200,$48C1,$207C
	dc.w	$000B,$C000,$4EB9,$0002,$258E,$1028,$0008,$6600
	dc.w	$0006,$303C,$0050,$0240,$00FF,$3F00,$4EB9,$0003
	dc.w	$8D8C,$0016,$FD04,$FA02,$4C65,$6167,$7565,$2052
	dc.w	$6563,$6F72,$64FD,$1C00,$301F,$323C,$0003,$4EB9
	dc.w	$0003,$919A,$4EB9,$0003,$8F80,$4EB9,$0003,$8F6E
	dc.w	$0006,$2064,$4200,$4CDF,$7FFF,$4E75,$48C0,$E540
	dc.w	$4EB9,$0003,$708E,$0640,$0041,$7203,$4EB9,$0003
	dc.w	$919A,$4EB9,$0003,$8F80,$4EB9,$0003,$8F6E,$0006
	dc.w	$2064,$4200,$4E75,$48E7,$C020,$4EB9,$0003,$6D0A
	dc.w	$08B9,$0000,$0001,$8D64,$3F39,$0001,$8D64,$08F9
	dc.w	$0002,$0001,$8D64,$3039,$0001,$8D32,$4EB9,$0003
	dc.w	$871E,$0839,$0007,$00FF,$800E,$66F6,$23FC,$0000
	dc.w	$0000,$00FF,$8022,$33FC,$000E,$00FF,$8020,$08F9
	dc.w	$0006,$00FF,$800F,$0839,$0006,$00FF,$800E,$67F6
	dc.w	$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF,$800F
	dc.w	$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007,$00FF
	dc.w	$800F,$0839,$0007,$00FF,$800E,$66F6,$33FC,$8C81
	dc.w	$00FF,$8022,$33FC,$000A,$00FF,$8020,$08F9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$67F6,$08F9
	dc.w	$0007,$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F
	dc.w	$33FC,$0006,$0001,$8D3E,$0839,$0007,$00FF,$800E
	dc.w	$66F6,$33FC,$8D00,$00FF,$8022,$33FC,$000A,$00FF
	dc.w	$8020,$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9
	dc.w	$0007,$00FF,$800F,$4240,$4EB9,$0003,$871E,$0839
	dc.w	$0007,$00FF,$800E,$66F6,$23FC,$0000,$0000,$00FF
	dc.w	$8022,$33FC,$000E,$00FF,$8020,$08F9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$67F6,$08F9,$0007
	dc.w	$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839,$0006
	dc.w	$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F,$33DF
	dc.w	$0001,$8D64,$08B9,$0001,$0001,$8D64,$3839,$0001
	dc.w	$8D4E,$2479,$0004,$7D10,$508A,$4EB9,$0003,$8946
	dc.w	$9123,$4567,$89AB,$CDEF,$3839,$0001,$8D42,$4EB9
	dc.w	$0003,$93E8,$4EB9,$0003,$8F6E,$0006,$BD00,$0000
	dc.w	$2279,$0004,$7D0C,$D3E9,$0004,$247C,$0001,$B008
	dc.w	$4240,$4241,$3411,$3629,$0002,$7801,$7A00,$4EB9
	dc.w	$0003,$87E2,$4EB9,$0003,$8F6E,$0006,$FD00,$0000
	dc.w	$4CD7,$0403,$D179,$0001,$8D5A,$2079,$0004,$7D0C
	dc.w	$2248,$2448,$D1DA,$D3DA,$3601,$9640,$3200,$4240
	dc.w	$7428,$7A0D,$4EB9,$0003,$87E2,$33C4,$0001,$8D44
	dc.w	$2479,$0004,$7D3C,$508A,$4EB9,$0003,$8946,$D123
	dc.w	$4567,$89AB,$CDEF,$4EB9,$0003,$8F6E,$0006,$FE00
	dc.w	$0000,$7040,$7220,$343C,$07FF,$4EB9,$0003,$8C06
	dc.w	$33FC,$0018,$0001,$8D62,$4CDF,$0403,$4E75,$4EB9
	dc.w	$0003,$6D0A,$3F39,$0001,$8D64,$08F9,$0002,$0001
	dc.w	$8D64,$3039,$0001,$8D30,$4EB9,$0003,$871E,$0839
	dc.w	$0007,$00FF,$800E,$66F6,$23FC,$0000,$0000,$00FF
	dc.w	$8022,$33FC,$000E,$00FF,$8020,$08F9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$67F6,$08F9,$0007
	dc.w	$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839,$0006
	dc.w	$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F,$303C
	dc.w	$8D00,$1039,$0001,$8D30,$E408,$0839,$0007,$00FF
	dc.w	$800E,$66F6,$33C0,$00FF,$8022,$33FC,$000A,$00FF
	dc.w	$8020,$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9
	dc.w	$0007,$00FF,$800F,$0839,$0007,$00FF,$800E,$66F6
	dc.w	$33FC,$8C00,$00FF,$8022,$33FC,$000A,$00FF,$8020
	dc.w	$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF,$800E
	dc.w	$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007
	dc.w	$00FF,$800F,$33FC,$0005,$0001,$8D3E,$4A79,$0001
	dc.w	$8D62,$6A00,$FFF8,$33DF,$0001,$8D64,$08F9,$0001
	dc.w	$0001,$8D64,$3839,$0001,$8D48,$2479,$0004,$7D18
	dc.w	$508A,$0839,$0004,$0001,$7F72,$6700,$000A,$2479
	dc.w	$0004,$7D64,$508A,$4EB9,$0003,$8958,$4EB9,$0002
	dc.w	$A9D0,$3839,$0001,$8D42,$2479,$0004,$7D3C,$508A
	dc.w	$4EB9,$0003,$8946,$4343,$4567,$89AB,$CDEF,$3839
	dc.w	$0001,$8D4E,$4EB9,$0003,$93FA,$4EB9,$0003,$EC78
	dc.w	$4EB9,$0003,$EC94,$4EB9,$0003,$ECA6,$4EB9,$0003
	dc.w	$EC60,$4EF9,$0003,$F24C,$0479,$0001,$0001,$8AD2
	dc.w	$0479,$0001,$0001,$8AD4,$23FC,$0004,$20DC,$0001
	dc.w	$8AD6,$08EA,$0002,$0032,$4EB9,$0003,$8F6E,$0006
	dc.w	$BD05,$0C00,$7016,$7206,$4EB9,$0003,$8CA0,$4EB9
	dc.w	$0003,$8F6E,$0010,$BD0C,$0E54,$696D,$656F,$7574
	dc.w	$BD11,$0F00,$226A,$001E,$D2E9,$0004,$3011,$E248
	dc.w	$9179,$0001,$8D58,$4EB9,$0003,$8F80,$247C,$0001
	dc.w	$834C,$4EB9,$0003,$C9B6,$D5FC,$0000,$0366,$4EB9
	dc.w	$0003,$C9B6,$7078,$4EF9,$0003,$72D0,$3F39,$0001
	dc.w	$8AD2,$3F39,$0001,$8AD4,$6100,$01A4,$33C0,$0001
	dc.w	$8AD4,$4EB9,$0003,$8F6E,$0006,$BD04,$0C00,$7018
	dc.w	$7203,$D279,$0001,$8AD4,$4EB9,$0003,$8CA0,$302A
	dc.w	$0028,$6A00,$0004,$70FF,$0640,$0001,$33C0,$0001
	dc.w	$8AD2,$6100,$0084,$6100,$01E8,$0801,$0007,$6600
	dc.w	$0048,$0801,$0005,$6600,$0040,$0801,$0001,$6700
	dc.w	$001A,$3039,$0001,$8AD2,$5240,$B079,$0001,$8AD4
	dc.w	$6E00,$FFD0,$33C0,$0001,$8AD2,$0801,$0000,$6700
	dc.w	$FFC2,$0479,$0001,$0001,$8AD2,$6A00,$FFB6,$4279
	dc.w	$0001,$8AD2,$6000,$FFAC,$3039,$0001,$8AD2,$0440
	dc.w	$0001,$6A00,$000C,$0C6A,$FFFF,$0028,$6D00,$000C
	dc.w	$3540,$0028,$4EB9,$0003,$D426,$33DF,$0001,$8AD4
	dc.w	$33DF,$0001,$8AD2,$4E75,$33FC,$000D,$0001,$8D5A
	dc.w	$3239,$0001,$8AD4,$7000,$33FC,$0005,$0001,$8D58
	dc.w	$33FC,$A000,$0001,$8D5C,$B079,$0001,$8AD2,$6600
	dc.w	$000A,$33FC,$8000,$0001,$8D5C,$4EB9,$0003,$8F6E
	dc.w	$0018,$2020,$2020,$2020,$2020,$2020,$2020,$2020
	dc.w	$2020,$2020,$2020,$2020,$4A40,$6600,$0020,$33FC
	dc.w	$000B,$0001,$8D58,$4EB9,$0003,$8F6E,$000C,$6E6F
	dc.w	$2067,$6F61,$6C69,$6500
