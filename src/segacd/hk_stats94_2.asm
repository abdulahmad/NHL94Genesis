	include	segacd\hockey.inc
	include	macros\genesis.mac

AttribAdjust	equ	$2AE82
AttributeOffsetTbl	equ	$2D0B2
CC_Font2Pri	equ	$BE
CC_Font3Pri	equ	$BD
CalcAttrib	equ	$2610C
FormatAndPrintTime	equ	$390C0
FormatPlayerNumInitial	equ	$41192
Fprintsmall	equ	$3CEBE
Framer	equ	$38CA0
GetForwardCount	equ	$2EDA0
GetGoalieCount	equ	$2ED60
LOAD	equ	$1B000
Penaltylist	equ	$4165C
PlayerScrollCtr	equ	$1A452
PlayerStatsList	equ	$2DE52
PushNumber	equ	$3915E
PushNumberWidth	equ	$3919A
ReadTeamStats	equ	$408E0
SelectedPlayerIdx	equ	$1A454
VertLineScrolling	equ	$1A450
WriteLineData	equ	$2A5C8
disflags	equ	$18D64
eraser	equ	$38C06
getname	equ	$4112E
move	equ	$2C9C8
potreeteam	equ	$18AA0
print	equ	$38F80
printa	equ	$18D5C
printbigz	equ	$39258
printx	equ	$18D58
printy	equ	$18D5A
printz	equ	$38F6E
scoutcolumn	equ	$1A44E
swap	equ	$2779A
tmstruct	equ	$1834C
X_12366	equ	$12366
X_1236E	equ	$1236E
X_12380	equ	$12380
X_125A0	equ	$125A0
X_125A6	equ	$125A6
X_12672	equ	$12672
X_12724	equ	$12724
X_12904	equ	$12904
X_12936	equ	$12936
X_12A34	equ	$12A34
X_12C82	equ	$12C82
X_12CB4	equ	$12CB4
X_12DB0	equ	$12DB0
X_13728	equ	$13728
X_14988	equ	$14988

	org	$11E66

ClearLineEditorTop						;Erase 40 x 10 at the top of map 2
	jsr	(printz).l
	String	CC_Font2Pri,$0,$0
	moveq	#$28,d0
	moveq	#$A,d1
	move.w	#$7FF,d2		;blank char
	jmp	(eraser).l
	clr.w	$BBD0A.l
	clr.w	$BBD2A.l
	rts
	ori.b	#$C,(a0)
	ori.b	#$4,d4
	dc.w	$000C
	ori.b	#$10,d4
	dc.w	$000C
	ori.b	#$1C,d4
	dc.w	$000C
	ori.b	#$4,d4
	dc.w	$000C
	ori.b	#$10,d4
	dc.w	$000C
	ori.b	#$4,d4
	dc.w	$000C
	ori.b	#$10,d3
	dc.w	$000C
	dc.w	$0003,$FFFF
	btst	d0,d1
	dc.w	$0203,$0405
	move.b	d1,-(a4)
	btst	d0,d1
	dc.w	$0203,$0405
	move.b	d1,-(a4)
	movep.w	$A0B(a1),d4
	dc.w	$0C0D
	move.l	d1,-(a0)
	move.b	(a1),-(a0)
	move.b	(a3),d1
	move.b	(a5),d2
	dc.w	$2101,$0519,$1A1B,$1C1D,$2901,$0D21,$2223,$2425
	dc.w	$3101,$1D29,$2A2B,$2C2C,$0101,$2531,$3233,$3434
	dc.w	$0101,$2531,$3233,$3434,$0101,$6100,$FF76,$33FC
	dc.w	$0018,$0001,$8D62,$4A79,$0001,$8D62,$6A00,$FFF8
	dc.w	$2F39,$0001,$8AD2,$2F39,$0001,$8AD6,$2F39,$0001
	dc.w	$8ADA,$227C,$0003,$C000,$207C,$0004,$27D8,$267C
	dc.w	$0001,$8C26,$302A,$002A,$0640,$0001,$B013,$6700
	dc.w	$0008,$207C,$0004,$2848,$4EB9,$0003,$8D8C,$0004
	dc.w	$FF02,$6100,$F396,$6100,$F6D4,$6100,$2386,$4EB9
	dc.w	$0003,$74BE,$3F01,$6100,$F3F2,$321F,$0241,$00A0
	dc.w	$6700,$FFE4,$4EB9,$0003,$8D8C,$0004,$F900,$3039
	dc.w	$0001,$8AD2,$23DF,$0001,$8ADA,$23DF,$0001,$8AD6
	dc.w	$23DF,$0001,$8AD2,$4A40,$6600,$F9AC,$6000,$19D4
SetLineSlot						;Put player d0 (1 based) in line slot d2 of team a2; if he is already in
									;another slot of the same line, the old occupant of d2 moves there (swap)
	movem.l	d0-d2/a0-a1,-(sp)
	lea.l	$16C(a2),a0		;a0 = team line table (8 bytes per line)
	move.w	d2,d1
	andi.w	#$FFF8,d1		;start of its line
	lea.l	(a0,d1.w),a1		;a1 = the line
	moveq	#$5,d1
.find	cmp.b	$1(a1,d1.w),d0		;is player d0 already in this line?
	dbeq	d1,.find
	bne.w	.put		;not there: just put him in
	move.b	(a0,d2.w),$1(a1,d1.w)		;already in the line: move the old occupant to his slot
.put	move.b	d0,(a0,d2.w)		;player into the slot
	movem.l	(sp)+,d0-d2/a0-a1
	rts
DecodeTeamLines						;Load team a2's lines from databuffer: byte 0 = team + 1, then one nibble
									;per slot in AttributeOffsetTbl order, relative to the first forward (or
									;defenseman for slots 1-2). Menu item handler
	movem.l	d0-d4/a0/a3,-(sp)
	movea.l	#$18C26,a0		;saved line data
	adda.w	#$1,a0		;skip the team byte
	bsr.w	GetGoalieCount-LOAD
	move.w	d0,d1
	bsr.w	GetForwardCount-LOAD
	move.w	d0,d3
	movea.l	#AttributeOffsetTbl,a3
	clr.w	d4
	clr.w	d2
.next	move.b	(a3),d2		;d2 = next slot from AttributeOffsetTbl
	bmi.w	.done
	bchg	#$0,d4		;d4 bit 0 toggles low/high nibble
	bne.w	.hi
	move.b	(a0),d0		;first nibble of the byte: low
	bra.w	.nib
.hi	move.b	(a0)+,d0		;high nibble, next byte
	lsr.w	#$4,d0
.nib	andi.w	#$F,d0		;nibble value
	add.b	d1,d0
	andi.w	#$7,d2		;slot within the line
	cmpi.w	#$2,d2		;defense?
	bgt.w	.store		;slots 3-5 are forwards
	add.b	d3,d0		;slots 1-2 defense: + forward count
.store	addi.b	#$1,d0		;1 based player number
	andi.w	#$FF,d0
	move.b	(a3)+,d2		;d2 = slot index
	bsr.w	SetLineSlot		;put him in the slot
	bra.w	.next
.done	movem.l	(sp)+,d0-d4/a0/a3
	rts
EncodeTeamLines						;Reverse of DecodeTeamLines: pack team a2's lines into databuffer and
									;convert it (WriteLineData, high ROM). Menu item handler
	movem.l	d0-d4/a0-a3,-(sp)
	movea.l	#$18C26,a0		;saved line data
	move.w	$2A(a2),d0
	addi.w	#$1,d0
	move.b	d0,(a0)+
	lea.l	$16C(a2),a1
	bsr.w	GetGoalieCount-LOAD
	move.w	d0,d1
	bsr.w	GetForwardCount-LOAD
	movea.l	#AttributeOffsetTbl,a3
	clr.w	d4
	clr.w	d2
.next	move.b	(a3)+,d2
	bmi.w	.done
	move.b	(a1,d2.w),d3		;player in the slot
	subi.b	#$1,d3		;0-based
	sub.b	d1,d3		;relative to the first non-goalie
	andi.w	#$7,d2
	cmpi.w	#$2,d2		;defense?
	bgt.w	.pack
	sub.b	d0,d3		;slots 1-2: also minus forward count
.pack	bchg	#$0,d4		;alternate low / high nibble
	bne.w	.hi
	move.b	d3,(a0)		;low nibble (high is or'ed in next)
	bra.w	.next
.hi	asl.b	#$4,d3		;second nibble goes in the high half
	or.b	d3,(a0)+
	bra.w	.next
.done	jsr	(WriteLineData).l
	movem.l	(sp)+,d0-d4/a0-a3
	rts
	dc.w	$0102,$0304,$0509,$0A0B,$0C0D,$1112,$1314,$1519
	dc.w	$1A1B,$1C1D,$2122,$2324,$2529,$2A2B,$2C31,$3233
	dc.w	$34FF
TeamRosterScreen						;"Team Roster" screen for team a2: pages of players (DisplayPlayerList:
									;goalies, then the lines), left / right attribute column, A switches
									;teams, start exits. Menu item handler
	moveq	#$D,d0		;bitmap row $D
	moveq	#$17,d1
	bsr.w	X_13728		;set up the screen
	moveq	#$1,d0
	add.w	$16(a2),d0		;start on the current line
	move.w	d0,(SelectedPlayerIdx).l		;page 0 = goalies, 1.. = lines
	clr.w	(scoutcolumn).l		;attribute page 0
	jsr	(printz).l
	String	CC_Font3Pri,$7,$1
	moveq	#$1A,d0
	moveq	#$6,d1
	jsr	(Framer).l		;draw the frame
	jsr	(printbigz).l
	String	CC_Font3Pri,$9,$4,'Team  Roster',CC_Font3Pri,$E,$1
	dc.w	$4240,$B5FC,$0001,$834C,$6700,$0004,$702C,$6100
	dc.w	$F470,$4EB9,$0003,$8D8C,$0034,$F806,$0302,$0CF9
	dc.w	$0150,$6F73,$2E5E,$506C,$6179,$6572,$FD1E,$FC0C
	dc.w	$5261,$7469,$6E67,$FD0C,$FC1A,$415E,$2D5E,$5377
	dc.w	$6974,$6368,$5E54,$6561,$6D73,$F900,$4EB9,$0003
	dc.w	$8F6E,$0006,$BD01,$0800,$7012,$7203,$4EB9,$0003
	dc.w	$8CA0,$4EB9,$0003,$8F6E,$0006,$BD15,$0800,$7012
	dc.w	$7203,$4EB9,$0003,$8CA0,$6100,$01FE,$3039,$0001
	dc.w	$A454,$C0FC,$0080,$33C0,$0001,$A450,$6100,$00B8
	dc.w	$4279,$0001,$A452,$6100,$F484,$6100,$2136,$4EB9
	dc.w	$0003,$74BE,$0803,$0007,$6600,$17B8,$0801,$0006
	dc.w	$6600,$0060,$4EB9,$0003,$7496,$7001,$0801,$0003
	dc.w	$6600,$0038,$4440,$0801,$0002,$6600,$002E,$4A79
	dc.w	$0001,$A452,$6600,$001C,$70FE,$0803,$0000,$6600
	dc.w	$000C,$4440,$0803,$0001,$6700,$0008,$33C0,$0001
	dc.w	$A452,$6100,$0036,$6000,$FF9E,$D079,$0001,$A44E
	dc.w	$6B00,$FFF0,$33C0,$0001,$A44E,$6100,$016C,$6000
	dc.w	$FFE2,$45EA,$0366,$B5FC,$0001,$86B2,$6700,$FEB2
	dc.w	$247C,$0001,$834C,$6000,$FEA8
CheckPlayerListScroll						;TeamRosterScreen per frame: add PlayerScrollCtr to VertLineScrolling (0
									;... $380)
	move.w	(PlayerScrollCtr).l,d0
	beq.w	X_14988
	add.w	(VertLineScrolling).l,d0		;new position
	bmi.w	X_12366
	cmpi.w	#$380,d0		;past the last page?
	bgt.w	X_12366
	move.w	(VertLineScrolling).l,d1
	move.w	d0,(VertLineScrolling).l
	ext.l	d0
	divs.w	#$80,d0
	swap	d0
	tst.w	d0
	bne.w	.l12284
	clr.w	(PlayerScrollCtr).l
.l12284	andi.w	#$7F,d1
	bne.w	.l122A4
	cmpi.w	#$7E,d0
	bne.w	.l12298
	bsr.w	X_1236E
.l12298	cmpi.w	#$2,d0
	bne.w	.l122A4
	bsr.w	X_12380
.l122A4	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movea.l	#$C00000,a0
	dc.w	$0839,$0007,$00FF,$800E,$66F6,$23FC,$4002,$0010
	dc.w	$00FF,$8022,$33FC,$000B,$00FF,$8020,$08F9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$67F6,$08F9
	dc.w	$0007,$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F
	dc.w	$303C,$FF90,$D079,$0001,$A450,$0839,$0007,$00FF
	dc.w	$800E,$66F6,$33C0,$00FF,$8022,$33FC,$000D,$00FF
	dc.w	$8020,$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9
	dc.w	$0007,$00FF,$800F,$33DF,$0001,$8D64,$4E75,$4279
	dc.w	$0001,$A452,$4E75,$2F00,$4840,$33C0,$0001,$A454
	dc.w	$6100,$001C,$201F,$4E75,$2F00,$4840,$0640,$0001
	dc.w	$33C0,$0001,$A454,$6100,$0006,$201F,$4E75,$4EB9
	dc.w	$0003,$8D8C,$000A,$F807,$0302,$09F9,$0100,$3039
	dc.w	$0001,$A454,$43FA,$012C,$4EB9,$0003,$CEC6,$4EB9
	dc.w	$0003,$8D9E,$4EB9,$0003,$8D8C,$0006,$FD16,$FC09
	dc.w	$227C,$0004,$1C48,$3039,$0001,$A44E,$4A79,$0001
	dc.w	$A454,$6600,$0012,$227C,$0004,$1DAA,$6000,$0008
	dc.w	$D2D1,$D2FC,$0004,$4A51,$5BC8,$FFF6,$6A00,$000E
	dc.w	$0479,$0001,$0001,$A44E,$6000,$FFC6,$4EB9,$0003
	dc.w	$8D9E,$2811,$4EB9,$0003,$8D8C,$000A,$F804,$0200
	dc.w	$00F9,$0000,$0839,$0000,$0001,$A455,$6700,$000A
	dc.w	$0679,$0010,$0001,$8D5A,$3F39,$0001,$8D5A,$7028
	dc.w	$7210,$343C,$07FF,$4EB9,$0003,$8C06,$33DF,$0001
	dc.w	$8D5A,$6100,$1914,$3200,$0441,$0001,$2A7C,$0002
	dc.w	$D4CA,$267C,$000B,$BD30,$26BC,$0102,$0304,$3039
	dc.w	$0001,$A454,$0440,$0001,$6B00,$0024,$E740,$47EA
	dc.w	$016C,$47F3,$0001,$2A7C,$0004,$1A20,$7204,$0C79
	dc.w	$0005,$0001,$A454,$6F00,$0006,$0441,$0001,$33FC
	dc.w	$0002,$0001,$8D58,$224D,$4EB9,$0003,$8F80,$2A49
	dc.w	$33FC,$0007,$0001,$8D58,$4240,$101B,$0440,$0001
	dc.w	$6100,$00B0,$0679,$0002,$0001,$8D5A,$51C9,$FFD0
	dc.w	$4E75,$0004,$4700,$0004,$4700,$0004,$4700,$0004
	dc.w	$4700,$0012,$2020,$2020,$476F,$616C,$6965,$7320
	dc.w	$2020,$207D,$0012,$7B20,$2053,$636F,$7269,$6E67
	dc.w	$2020,$3120,$207D,$0012,$7B20,$2053,$636F,$7269
	dc.w	$6E67,$2020,$3220,$207D,$0012,$7B20,$2020,$4368
	dc.w	$6563,$6B69,$6E67,$2020,$207D,$0012,$7B20,$506F
	dc.w	$7765,$7220,$506C,$6179,$2031,$207D,$0012,$7B20
	dc.w	$506F,$7765,$7220,$506C,$6179,$2032,$207D,$0012
	dc.w	$7B50,$656E,$616C,$7479,$204B,$696C,$6C20,$317D
	dc.w	$0012,$7B50,$656E,$616C,$7479,$204B,$696C,$6C20
	dc.w	$3220
GetNameandAttrib						;Print player d0's name, then at x $1E the column d4 picks (attribjmp;
									;above 2 a rating through CalcAttrib, high ROM). Saves d0-d4/a0-a1/a4-a5
	movem.l	d0-d4/a0-a1/a4-a5,-(sp)
	pea.l	X_125A0(pc)		;handlers return here
	jsr	(getname).l		;a1 = his number and name
	jsr	(print).l
	move.w	#$1E,(printx).l
	cmpi.w	#$2,d4		;status or energy column?
	bls.w	.jump
	jsr	(CalcAttrib).l
	swap	d4
.jump	lea.l	X_125A6(pc),a0
	adda.w	(a0,d4.w),a0		;this handler
	jmp	(a0)
	movem.l	(sp)+,d0-d4/a0-a1/a4-a5
	rts
	dc.w	$000C
	dc.w	$009E,$00E8,$010E,$00B8,$00C0,$D040,$3032,$0068
	dc.w	$6A00,$001E,$4640,$0C40,$0003,$6300,$000A,$7001
	dc.w	$6000,$0004,$7003,$43FA,$0040,$4EF9,$0003,$CEBE
	dc.w	$0800,$000C,$6600,$FFEE,$0479,$0001,$0001,$8D58
	dc.w	$3200,$0240,$0FFF,$4EB9,$0003,$90F4,$4EB9,$0003
	dc.w	$8F80,$7004,$0881,$000E,$6700,$0004,$7005,$43FA
	dc.w	$0008,$4EF9,$0003,$CEBE,$000A,$4963,$6520,$2020
	dc.w	$2020,$000A,$4265,$6E63,$6820,$2020,$000A,$496E
	dc.w	$6A75,$7279,$2050,$000A,$496E,$6A75,$7279,$2047
	dc.w	$0006,$2020,$2020,$0006,$2043,$2020
AttribEnergy						;Energy: tmpde(a2) word / 40, at most 100 (AttribPrintPct)
	add.w	d0,d0
	move.w	$34(a2,d0.w),d0		;his energy
	ext.l	d0
	divu.w	#$28,d0
	cmpi.w	#$64,d0		;over 100?
	ble.w	X_12672
	moveq	#$64,d0
	bra.w	X_12672		;print it
AttribFighting						;Bit 0 of the nibble is the handedness: drop it, then a rating out of d1 -
									;1
	andi.w	#$E,d0
	subi.w	#$1,d1
	mulu.w	#$64,d0
	divu.w	d1,d0
	jsr	(AttribAdjust).l
	moveq	#$4,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l
	String	'    '
	dc.w	$4E75,$0240,$0001,$0A40,$0001,$43FA,$0008,$4EF9
	dc.w	$0003,$CEBE,$000A
AttribWeight						;Weight: 140 + 8 * rating lb
	addq.w	#$1,$6768(a1)
	moveq	#$79,d2
	move.l	-(a0),d0
	dc.w	$000A
	dc.w	$4C65
	bne.b	X_12724
	dc.w	$7920
	move.l	-(a0),d0
	asl.w	#$3,d0		;jump for weight - mult by 8
	addi.w	#$8C,d0		;add 140 lbs (minimum weight)
	jsr	(PushNumber).l
	jsr	(print).l
	jsr	(printz).l
	String	' lb  '
	rts
ScoringSummaryScreen						;"Scoring Summary": one 4 row entry per goal (6 bytes each from ScoreSum),
									;scrolled with up / down, start exits. Menu item handler
	moveq	#$A,d0		;SetupScreen d0/d1: row offset / height
	moveq	#$1A,d1
	bsr.w	X_13728		;set up the screen
	jsr	(printz).l
	String	CC_Font3Pri,$4,$1
	moveq	#$20,d0
	moveq	#$6,d1
	jsr	(Framer).l		;draw the frame
	jsr	(printbigz).l
	String	CC_Font3Pri,$6,$4,'Scoring Summary',CC_Font3Pri,$7,$1
	dc.w	$702C,$6100,$EE88,$0679,$0004,$0001,$8D58,$4240
	dc.w	$6100,$EE7A,$4EB9,$0003,$8D8C,$0034,$F806,$0300
	dc.w	$08F9,$015E,$5065,$725E,$5E54,$696D,$655E,$5E54
	dc.w	$6D5E,$5E47,$6F61,$6C2F,$4173,$7369,$7374,$5E5E
	dc.w	$5E5E,$5E5E,$5E5E,$502F,$535E,$5EF9,$0000,$4280
	dc.w	$3039,$0001,$80F0,$80FC,$0006,$EB40,$33C0,$0001
	dc.w	$A450,$0440,$0080,$6A00,$0004,$4240,$33C0,$0001
	dc.w	$A454,$3039,$0001,$A450,$6100,$EEAE,$6100,$006C
	dc.w	$3039,$0001,$A450,$0440,$0002,$B079,$0001,$A454
	dc.w	$6C00,$FFE6,$4279,$0001,$A452,$6100,$EE8C,$6100
	dc.w	$1B3E,$0803,$0007,$6600,$11C6,$70FE,$0803,$0000
	dc.w	$6600,$000C,$4440,$0803,$0001,$6700,$0008,$33C0
	dc.w	$0001,$A452,$6100,$0006,$6000,$FFD0
CheckScoringScroll						;ScoringSummaryScreen per frame: add PlayerScrollCtr to VertLineScrolling
									;(0 ... SelectedPlayerIdx). Falls into UpdateScoringScroll
	move.w	(PlayerScrollCtr).l,d0
	beq.w	X_14988
	add.w	(VertLineScrolling).l,d0		;new position
	bmi.w	X_14988		;above the top: ignore
	cmp.w	(SelectedPlayerIdx).l,d0		;past the limit?
	bgt.w	X_14988
	move.w	(VertLineScrolling).l,d1
	move.w	d0,(VertLineScrolling).l
	ext.l	d0
	divs.w	#$20,d0
	swap	d0
	tst.w	d0
	bne.w	.l12820
	bsr.w	X_12DB0
	clr.w	(PlayerScrollCtr).l
.l12820	andi.w	#$1F,d1
	bne.w	.l12844
	move.l	d0,-(sp)
	cmpi.w	#$1E,d0
	bne.w	.l12836
	bsr.w	X_12904
.l12836	move.l	(sp)+,d0
	cmpi.w	#$2,d0
	bne.w	.l12844
	bsr.w	X_12936
.l12844	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	dc.w	$207C,$00C0,$0000,$0839,$0007,$00FF,$800E,$66F6
	dc.w	$23FC,$4002,$0010,$00FF,$8022,$33FC,$000B,$00FF
	dc.w	$8020,$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9
	dc.w	$0007,$00FF,$800F,$70B0,$D079,$0001,$A450,$0839
	dc.w	$0007,$00FF,$800E,$66F6,$33C0,$00FF,$8022,$33FC
	dc.w	$000D,$00FF,$8020,$08F9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$67F6,$08F9,$0007,$00FF,$800F
	dc.w	$08B9,$0006,$00FF,$800F,$0839,$0006,$00FF,$800E
	dc.w	$66F6,$08B9,$0007,$00FF,$800F,$33DF,$0001,$8D64
	dc.w	$4E75,$2F00,$4840,$7606,$C6C0,$4EB9,$0003,$8F6E
	dc.w	$0006,$BE00,$0000,$3039,$0001,$A450,$E648,$0440
	dc.w	$0003,$0240,$001F,$33C0,$0001,$8D5A,$6100,$003C
	dc.w	$201F,$4E75,$2F00,$4840,$0640,$0004,$7606,$C6C0
	dc.w	$4EB9,$0003,$8F6E,$0006,$BE00,$0000,$3039,$0001
	dc.w	$A450,$E648,$0640,$0010,$0240,$001F,$33C0,$0001
	dc.w	$8D5A,$6100,$0006,$201F,$4E75
DrawScoringRow						;Print ScoreSum entry d3: time, team (bit 7 of byte 2 = away), goal type
									;(GoalTypeTbl), scorer and the two assists (PrintScorerName)
	move.w	(printy).l,-(sp)
	moveq	#$28,d0		;width 40 cells
	moveq	#$4,d1		;4 rows high
	move.w	#$7FF,d2		;blank tile
	jsr	(eraser).l
	move.w	(sp)+,(printy).l
	movea.l	#$180F2,a0
	move.w	(a0,d3.w),d0		;goal time
	move.w	#$1,(printx).l
	jsr	(FormatAndPrintTime).l		;print it
	movea.l	#tmstruct,a2
	btst	#$7,$2(a0,d3.w)
	beq.w	.0
	adda.w	#$366,a2
.0	movea.l	$1E(a2),a1		;team data -> team name string
	adda.w	$4(a1),a1
	adda.w	(a1),a1
	move.w	#$C,(printx).l
	jsr	(print).l
	move.w	#$23,(printx).l
	lea.l	X_12A34(pc),a1
	move.b	$2(a0,d3.w),d0
	andi.w	#$7F,d0		;strip the away bit -> string index
	jsr	(Fprintsmall).l		;print the type
	move.w	#$10,(printx).l
	move.b	$3(a0,d3.w),d0
	bsr.w	PrintScorerName		;print him
	move.w	#$E000,(printa).l
	move.w	#$12,(printx).l
	move.b	$4(a0,d3.w),d0
	bsr.w	PrintScorerName
	move.w	#$12,(printx).l
	move.b	$5(a0,d3.w),d0		;second assist, falls into PrintScorerName
PrintScorerName						;Print player d0 (byte, negative = none) and go down a row
	ext.w	d0		;sign extend: $FF = no player
	bmi.w	.0		;nothing to print, just advance the row
	jsr	(FormatPlayerNumInitial).l		;a1 = "NN F. Last" for player d0 of team a2
	jsr	(print).l
.0	addi.w	#$1,(printy).l
	rts
	dc.w	$0006,$5348
	move.w	d0,d1
	dc.w	$0004,$5348
	dc.w	$0004,$2000
	dc.w	$0004,$5050
	dc.w	$0006,$5050
	move.w	d0,d1
PenaltySummaryScreen						;"Penalty Summary": one 3 row entry per penalty (4 bytes each from PenSum,
									;PenSumLength bytes), scrolled as ScoringSummaryScreen. Menu item handler
	moveq	#$A,d0		;bitmap row $A
	moveq	#$19,d1
	bsr.w	X_13728		;set up the screen
	jsr	(printz).l
	String	CC_Font3Pri,$4,$1
	moveq	#$20,d0
	moveq	#$6,d1
	jsr	(Framer).l		;draw the frame
	jsr	(printbigz).l
	String	CC_Font3Pri,$5,$4,'Penalty  Summary',CC_Font3Pri,$7,$1
	dc.w	$702C,$6100,$EB12,$0679,$0004,$0001,$8D58,$4240
	dc.w	$6100,$EB04,$4EB9,$0003,$8D8C,$0034,$F806,$0300
	dc.w	$08F9,$015E,$5065,$725E,$5E54,$696D,$655E,$5E54
	dc.w	$6D5E,$5E50,$6C61,$7965,$722F,$5065,$6E61,$6C74
	dc.w	$795E,$5E5E,$5E6D,$696E,$5E5E,$5EF9,$0000,$4280
	dc.w	$3039,$0001,$825A,$E448,$C0FC,$0018,$33C0,$0001
	dc.w	$A450,$0440,$0078,$6A00,$0004,$4240,$33C0,$0001
	dc.w	$A454,$3039,$0001,$A450,$6100,$EB38,$6100,$006C
	dc.w	$3039,$0001,$A450,$0440,$0002,$B079,$0001,$A454
	dc.w	$6C00,$FFE6,$4279,$0001,$A452,$6100,$EB16,$6100
	dc.w	$17C8,$0803,$0007,$6600,$0E50,$70FE,$0803,$0000
	dc.w	$6600,$000C,$4440,$0803,$0001,$6700,$0008,$33C0
	dc.w	$0001,$A452,$6100,$0006,$6000,$FFD0
CheckPenaltyScroll						;PenaltySummaryScreen per frame: add PlayerScrollCtr to VertLineScrolling
									;(0 ... SelectedPlayerIdx). Falls into UpdatePenaltyScroll
	move.w	(PlayerScrollCtr).l,d0
	beq.w	X_14988
	add.w	(VertLineScrolling).l,d0		;new position
	bmi.w	X_14988		;above the top: ignore
	cmp.w	(SelectedPlayerIdx).l,d0		;past the limit?
	bgt.w	X_14988
	move.w	(VertLineScrolling).l,d1
	move.w	d0,(VertLineScrolling).l
	ext.l	d0
	divs.w	#$18,d0
	swap	d0
	tst.w	d0
	bne.w	.l12B96
	bsr.w	X_12DB0
	clr.w	(PlayerScrollCtr).l
.l12B96	ext.l	d1
	divs.w	#$18,d1
	swap	d1
	tst.w	d1
	bne.w	.l12BC0
	move.l	d0,-(sp)
	cmpi.w	#$16,d0
	bne.w	.l12BB2
	bsr.w	X_12C82
.l12BB2	move.l	(sp)+,d0
	cmpi.w	#$2,d0
	bne.w	.l12BC0
	bsr.w	X_12CB4
.l12BC0	move.w	(disflags).l,-(sp)
	dc.w	$08F9,$0002,$0001,$8D64,$207C,$00C0,$0000,$0839
	dc.w	$0007,$00FF,$800E,$66F6,$23FC,$4002,$0010,$00FF
	dc.w	$8022,$33FC,$000B,$00FF,$8020,$08F9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$67F6,$08F9,$0007
	dc.w	$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839,$0006
	dc.w	$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F,$303C
	dc.w	$FFB0,$D079,$0001,$A450,$0839,$0007,$00FF,$800E
	dc.w	$66F6,$33C0,$00FF,$8022,$33FC,$000D,$00FF,$8020
	dc.w	$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF,$800E
	dc.w	$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007
	dc.w	$00FF,$800F,$33DF,$0001,$8D64,$4E75,$2F00,$4840
	dc.w	$3600,$E543,$4EB9,$0003,$8F6E,$0006,$BE00,$0000
	dc.w	$3039,$0001,$A450,$E648,$0440,$0002,$0240,$001F
	dc.w	$33C0,$0001,$8D5A,$6100,$003C,$201F,$4E75,$2F00
	dc.w	$4840,$0640,$0005,$3600,$E543,$4EB9,$0003,$8F6E
	dc.w	$0006,$BE00,$0000,$3039,$0001,$A450,$E648,$0640
	dc.w	$000F,$0240,$001F,$33C0,$0001,$8D5A,$6100,$0006
	dc.w	$201F,$4E75
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
	bsr.w	PlayerStatsList-LOAD
	movem.l	(sp)+,a2
	rts
	dc.w	$4247
