	include	segacd\hockey.inc
	include	macros\genesis.mac

AttributeOffsetTbl	equ	$2D0B2
CC_Font3Pri	equ	$BD
CC_SetFont	equ	$F9
CalcAttrib	equ	$2610C
FormatAndPrintTime	equ	$390C0
Fprintsmall	equ	$3CEBE
Framer	equ	$38CA0
GAttribColumns	equ	$41DAA
LineIconPosTable	equ	$2CE94
OptLine	equ	$18C0A
PAttribColumns	equ	$41C48
PlayerScrollCtr	equ	$1A452
ProcessInputWithRepeat	equ	$374BE
SelectedPlayerIdx	equ	$1A454
VertLineScrolling	equ	$1A450
WriteLineData	equ	$2A5C8
eraser	equ	$38C06
getname	equ	$4112E
move	equ	$2C9C8
nodiag	equ	$37496
print	equ	$38F80
printa	equ	$18D5C
printbigz	equ	$39258
printsmallz	equ	$38D8C
printx	equ	$18D58
printy	equ	$18D5A
printz	equ	$38F6E
scoutcolumn	equ	$1A44E
swap	equ	$2779A
tmstruct	equ	$1834C
X_112F8	equ	$112F8
X_11368	equ	$11368
X_1163A	equ	$1163A
X_120EE	equ	$120EE
X_12248	equ	$12248
X_12264	equ	$12264
X_12396	equ	$12396
X_12404	equ	$12404
X_125A0	equ	$125A0
X_125A6	equ	$125A6
X_12672	equ	$12672
X_12A18	equ	$12A18
X_12A34	equ	$12A34
X_13728	equ	$13728
X_13980	equ	$13980
X_13D60	equ	$13D60
X_13DA0	equ	$13DA0
X_142F0	equ	$142F0

	org	$11D88

	moveq	#$28,d0
	moveq	#$12,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	move.w	$2CE96.l,(printy).l
	move.w	(LineIconPosTable).l,(printx).l
	tst.w	(OptLine).l
	beq.w	.l11DBE
	move.w	$2CE8E.l,(printx).l
.l11DBE	jsr	(printsmallz).l
	dc.w	$0022
	dc.b	$FE,$04,$FB,$FD,$FA,$02,$4C,$44,$FB,$FE,$FA,$02,$52,$44,$FB,$FE,$FA,$02,$4C,$57,$FB,$FE,$FA,$02,$43,$20,$FB,$FE,$FA,$02,$52,$57
	dc.w	$4E75,$6100,$007C,$48E7,$FCE0,$4EB9,$0003,$8F6E
	dc.w	$0006,$FD00,$0000,$2279,$0004,$7D0C,$D3E9,$0004
	dc.w	$247C,$0001,$B008,$4240,$4241,$3411,$3629,$0002
	dc.w	$7801,$7A00,$4EB9,$0003,$87E2,$4CDF,$073F,$4EB9
	dc.w	$0003,$8F6E,$0006,$BE07,$0100,$701A,$7206,$4EB9
	dc.w	$0003,$8CA0,$4EB9,$0003,$9258,$0014,$BE0A,$044C
	dc.w	$696E,$6520,$4564,$6974,$6F72,$BE0E,$0100,$4240
	dc.w	$B5FC,$0001,$834C,$6700,$F740,$702C,$6000,$F73A
	dc.w	$4EB9,$0003,$8F6E,$0006,$BE00,$0000,$7028,$720A
	dc.w	$343C,$07FF,$4EF9,$0003,$8C06,$4279,$000B,$BD0A
	dc.w	$4279,$000B,$BD2A,$4E75,$0010,$000C,$0004,$0004
	dc.w	$000C,$0004,$0010,$000C,$0004,$001C,$000C,$0004
	dc.w	$0004,$000C,$0004,$0010,$000C,$0004,$0004,$000C
	dc.w	$0003,$0010,$000C,$0003,$FFFF,$0101,$0203,$0405
	dc.w	$1901,$0101,$0203,$0405,$1901,$0909,$0A0B,$0C0D
	dc.w	$2101,$1111,$1213,$1415,$2101,$0519,$1A1B,$1C1D
	dc.w	$2901,$0D21,$2223,$2425,$3101,$1D29,$2A2B,$2C2C
	dc.w	$0101,$2531,$3233,$3434,$0101,$2531,$3233,$3434
	dc.w	$0101,$6100,$FF76,$33FC,$0018,$0001,$8D62,$4A79
	dc.w	$0001,$8D62,$6A00,$FFF8,$2F39,$0001,$8AD2,$2F39
	dc.w	$0001,$8AD6,$2F39,$0001,$8ADA,$227C,$0003,$C000
	dc.w	$207C,$0004,$27D8,$267C,$0001,$8C26,$302A,$002A
	dc.w	$0640,$0001,$B013,$6700,$0008,$207C,$0004,$2848
	dc.w	$4EB9,$0003,$8D8C,$0004,$FF02
	bsr.w	X_112F8
.l11F64	bsr.w	X_1163A
	bsr.w	X_142F0
	jsr	(ProcessInputWithRepeat).l
	move.w	d1,-(sp)
	bsr.w	X_11368
	move.w	(sp)+,d1
	andi.w	#$A0,d1
	beq.w	.l11F64
	jsr	(printsmallz).l
	String	CC_SetFont
	dc.w	$3039,$0001,$8AD2,$23DF,$0001,$8ADA,$23DF,$0001
	dc.w	$8AD6,$23DF,$0001,$8AD2,$4A40,$6600,$F9AC,$6000
	dc.w	$19D4
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
	bsr.w	X_13D60
	move.w	d0,d1
	bsr.w	X_13DA0
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
	bsr.w	X_13D60
	move.w	d0,d1
	bsr.w	X_13DA0
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
	dc.w	$8CA0,$4EB9,$0003,$8F6E,$0006,$BD15,$0800
	moveq	#$12,d0
	moveq	#$3,d1
	jsr	(Framer).l		;draw the frame
	bsr.w	X_12396		;draw the current page
	move.w	(SelectedPlayerIdx).l,d0
	mulu.w	#$80,d0		;128 pixels per line page
	move.w	d0,(VertLineScrolling).l
	bsr.w	X_12264		;set the scroll register for it
	clr.w	(PlayerScrollCtr).l
.loop	bsr.w	X_1163A		;wait for the next frame
	bsr.w	X_142F0		;read the pads
	jsr	(ProcessInputWithRepeat).l
	btst	#$7,d3		;start?
	bne.w	X_13980
	btst	#$6,d1		;A?
	bne.w	.team
	jsr	(nodiag).l
	moveq	#$1,d0
	btst	#$3,d1		;right?
	bne.w	.col
	neg.w	d0
	btst	#$2,d1		;left?
	bne.w	.col		;previous column page
	tst.w	(PlayerScrollCtr).l
	bne.w	.scroll
	moveq	#-2,d0
	btst	#$0,d3		;up?
	bne.w	.set
	neg.w	d0
	btst	#$1,d3		;down?
	beq.w	.scroll
.set	move.w	d0,(PlayerScrollCtr).l
.scroll	bsr.w	X_12248
	bra.w	.loop
.col	add.w	(scoutcolumn).l,d0		;new attribute column page (not below 0)
	bmi.w	.scroll		;below 0: ignore
	move.w	d0,(scoutcolumn).l
	bsr.w	X_12396
	bra.w	.scroll
.team	lea.l	$366(a2),a2
	cmpa.l	#$186B2,a2		;was the home team?
	beq.w	X_120EE		;yes: show the away team
	movea.l	#tmstruct,a2		;away -> back to home
	bra.w	X_120EE
	dc.w	$3039,$0001,$A452,$6700,$2738,$D079,$0001,$A450
	dc.w	$6B00,$010C,$0C40,$0380,$6E00,$0104,$3239,$0001
	dc.w	$A450,$33C0,$0001,$A450,$48C0,$81FC,$0080,$4840
	dc.w	$4A40,$6600,$0008,$4279,$0001,$A452,$0241,$007F
	dc.w	$6600,$001A,$0C40,$007E,$6600,$0006,$6100,$00D8
	dc.w	$0C40,$0002,$6600,$0006,$6100,$00DE,$3F39,$0001
	dc.w	$8D64,$08F9,$0002,$0001,$8D64,$207C,$00C0,$0000
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
.l123C8	movea.l	#PAttribColumns,a1
	move.w	(scoutcolumn).l,d0
	tst.w	(SelectedPlayerIdx).l
	bne.w	.l123EE
	movea.l	#GAttribColumns,a1
	bra.w	.l123EE
	adda.w	(a1),a1
	adda.w	#$4,a1
.l123EE	tst.w	(a1)
	dbmi	d0,$123E8
	bpl.w	X_12404
	subi.w	#$1,(scoutcolumn).l
	bra.w	.l123C8
	dc.w	$4EB9,$0003,$8D9E,$2811,$4EB9,$0003,$8D8C,$000A
	dc.w	$F804,$0200,$00F9,$0000,$0839,$0000,$0001,$A455
	dc.w	$6700,$000A,$0679,$0010,$0001,$8D5A,$3F39,$0001
	dc.w	$8D5A,$7028,$7210,$343C,$07FF,$4EB9,$0003,$8C06
	dc.w	$33DF,$0001,$8D5A,$6100,$1914,$3200,$0441,$0001
	dc.w	$2A7C,$0002,$D4CA,$267C,$000B,$BD30,$26BC,$0102
	dc.w	$0304,$3039,$0001,$A454,$0440,$0001,$6B00,$0024
	dc.w	$E740,$47EA,$016C,$47F3,$0001,$2A7C,$0004,$1A20
	dc.w	$7204,$0C79,$0005,$0001,$A454,$6F00,$0006,$0441
	dc.w	$0001,$33FC,$0002,$0001,$8D58,$224D,$4EB9,$0003
	dc.w	$8F80,$2A49,$33FC,$0007,$0001,$8D58,$4240,$101B
	dc.w	$0440,$0001,$6100,$00B0,$0679,$0002,$0001,$8D5A
	dc.w	$51C9,$FFD0,$4E75,$0004,$4700,$0004,$4700,$0004
	dc.w	$4700,$0004,$4700,$0012,$2020,$2020,$476F,$616C
	dc.w	$6965,$7320,$2020,$207D,$0012,$7B20,$2053,$636F
	dc.w	$7269,$6E67,$2020,$3120,$207D,$0012,$7B20,$2053
	dc.w	$636F,$7269,$6E67,$2020,$3220,$207D,$0012,$7B20
	dc.w	$2020,$4368,$6563,$6B69,$6E67,$2020,$207D,$0012
	dc.w	$7B20,$506F,$7765,$7220,$506C,$6179,$2031,$207D
	dc.w	$0012,$7B20,$506F,$7765,$7220,$506C,$6179,$2032
	dc.w	$207D,$0012,$7B50,$656E,$616C,$7479,$204B,$696C
	dc.w	$6C20,$317D,$0012,$7B50,$656E,$616C,$7479,$204B
	dc.w	$696C,$6C20,$3220
	movem.l	d0-d4/a0-a1/a4-a5,-(sp)
	pea.l	X_125A0(pc)
	jsr	(getname).l
	jsr	(print).l
	move.w	#$1E,(printx).l
	cmpi.w	#$2,d4
	bls.w	.l12596
	jsr	(CalcAttrib).l
	swap	d4
.l12596	lea.l	X_125A6(pc),a0
	adda.w	(a0,d4.w),a0
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
	add.w	d0,d0
	move.w	$34(a2,d0.w),d0
	ext.l	d0
	divu.w	#$28,d0
	cmpi.w	#$64,d0
	ble.w	X_12672
	moveq	#$64,d0
	bra.w	X_12672
	dc.w	$0240,$000E,$0441,$0001,$C0FC,$0064,$80C1,$4EB9
	dc.w	$0002,$AE82,$7204,$4EB9,$0003,$919A,$4EB9,$0003
	dc.w	$8F80,$4EB9,$0003,$8F6E,$0006,$2020,$2020,$4E75
	dc.w	$0240,$0001,$0A40,$0001,$43FA,$0008,$4EF9,$0003
	dc.w	$CEBE,$000A,$5269,$6768,$7479,$2020,$000A,$4C65
	dc.w	$6674,$7920,$2020,$E740,$0640,$008C,$4EB9,$0003
	dc.w	$915E,$4EB9,$0003,$8F80,$4EB9,$0003,$8F6E,$0008
	dc.w	$206C,$6220,$2000,$4E75,$700A,$721A,$6100,$104C
	dc.w	$4EB9,$0003,$8F6E,$0006,$BD04,$0100
	moveq	#$20,d0
	moveq	#$6,d1
	jsr	(Framer).l
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
	dc.w	$0001,$A452,$6100,$0006,$6000,$FFD0,$3039,$0001
	dc.w	$A452,$6700,$21A2,$D079,$0001,$A450,$6B00,$2198
	dc.w	$B079,$0001,$A454,$6E00,$218E,$3239,$0001,$A450
	dc.w	$33C0,$0001,$A450,$48C0,$81FC,$0020,$4840,$4A40
	dc.w	$6600,$000C,$6100,$0598,$4279,$0001,$A452,$0241
	dc.w	$001F,$6600,$001E,$2F00,$0C40,$001E,$6600,$0006
	dc.w	$6100,$00D0,$201F,$0C40,$0002,$6600,$0006,$6100
	dc.w	$00F4,$3F39,$0001,$8D64,$08F9,$0002,$0001,$8D64
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
	bsr.w	X_12A18		;print him
	move.w	#$E000,(printa).l
	move.w	#$12,(printx).l
	move.b	$4(a0,d3.w),d0
	bsr.w	X_12A18
	move.w	#$12,(printx).l
	move.b	$5(a0,d3.w),d0		;second assist, falls into PrintScorerName
	dc.w	$4880,$6B00,$000E,$4EB9,$0004,$1192,$4EB9,$0003
	dc.w	$8F80,$0679,$0001,$0001,$8D5A,$4E75,$0006,$5348
	dc.w	$3200,$0004,$5348,$0004,$2000,$0004,$5050,$0006
	dc.w	$5050,$3200,$700A,$7219,$6100,$0CD6,$4EB9,$0003
	dc.w	$8F6E,$0006,$BD04,$0100
	moveq	#$20,d0
	moveq	#$6,d1
	jsr	(Framer).l
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
	dc.w	$0001,$A452,$6100,$0006,$6000,$FFD0,$3039,$0001
	dc.w	$A452,$6700,$1E2C,$D079,$0001,$A450,$6B00,$1E22
	dc.w	$B079,$0001,$A454,$6E00,$1E18,$3239,$0001,$A450
	dc.w	$33C0,$0001,$A450,$48C0,$81FC,$0018,$4840,$4A40
	dc.w	$6600,$000C,$6100,$0222,$4279,$0001,$A452,$48C1
	dc.w	$83FC,$0018,$4841,$4A41,$6600,$001E,$2F00,$0C40
	dc.w	$0016,$6600,$0006,$6100,$00D2,$201F,$0C40,$0002
	dc.w	$6600,$0006,$6100,$00F6,$3F39,$0001,$8D64,$08F9
	dc.w	$0002,$0001,$8D64,$207C,$00C0,$0000,$0839,$0007
	dc.w	$00FF,$800E,$66F6,$23FC,$4002,$0010,$00FF,$8022
	dc.w	$33FC,$000B,$00FF,$8020,$08F9,$0006,$00FF,$800F
	dc.w	$0839,$0006,$00FF,$800E,$67F6,$08F9,$0007,$00FF
	dc.w	$800F,$08B9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$66F6,$08B9,$0007,$00FF,$800F,$303C,$FFB0
	dc.w	$D079,$0001,$A450,$0839,$0007,$00FF,$800E,$66F6
	dc.w	$33C0,$00FF,$8022,$33FC,$000D,$00FF,$8020,$08F9
	dc.w	$0006,$00FF,$800F,$0839,$0006,$00FF,$800E,$67F6
	dc.w	$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF,$800F
	dc.w	$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007,$00FF
	dc.w	$800F,$33DF,$0001,$8D64,$4E75,$2F00,$4840,$3600
	dc.w	$E543,$4EB9,$0003,$8F6E,$0006,$BE00,$0000,$3039
	dc.w	$0001,$A450,$E648,$0440,$0002,$0240,$001F,$33C0
	dc.w	$0001,$8D5A,$6100,$003C,$201F,$4E75,$2F00,$4840
	dc.w	$0640,$0005,$3600,$E543,$4EB9,$0003,$8F6E,$0006
	dc.w	$BE00,$0000,$3039,$0001,$A450,$E648,$0640,$000F
	dc.w	$0240,$001F,$33C0,$0001,$8D5A,$6100,$0006,$201F
	dc.w	$4E75
