SkipNameNumber
	movem.l	d0-d7/a0/a2-a3,-(sp)
	dc.w	$4EB9,$0004,$1192
	move.w	(a1),d0
	subi.w	#$2,d0
	move.w	d0,$2(a1)
	adda.w	#$2,a1
	movem.l	(sp)+,d0-d7/a0/a2-a3
	rts
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_0E508.bin
StatsReport
	moveq	#$9,d0
	moveq	#$1A,d1
	dc.w	$4EB9,$0002,$E728
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font3Pri,$4,$1
	moveq	#$20,d0
	moveq	#$6,d1
	dc.w	$4EB9,$0003,$8CA0
	dc.w	$4EB9,$0003,$9258
	String	CC_Font3Pri,$6,$4,'Game  Statistics',CC_Font3Pri,$7,$1
	move.w	#$2C,d0
	dc.w	$4EB9,$0002,$C59E
	addi.w	#$4,(printx).l
	clr.w	d0
	dc.w	$4EB9,$0002,$C59E
	clr.w	(scoutcolumn).l
	clr.w	(VertLineScrolling).l
	clr.w	(PlayerScrollCtr).l
	move.w	#$70,(matchupvis).l
	dc.w	$4A79,$0001,$8C08
	bne.w	LEAB2
	move.w	#$30,(matchupvis).l
LEAB2	bsr.w	DisplayStats
	bsr.w	LEC3E
LEABA	jsr	(MenuWaitVblank).l
	dc.w	$4EB9,$0002,$F2F0
	btst	#$7,d3
	beq.w	LEAD4
	dc.w	$4EF9,$0002,$E980
LEAD4	jsr	(nodiag).l
	move.w	#$FFFE,d0
	btst	#$0,d3
	bne.w	LEAF0
	neg.w	d0
	btst	#$1,d3
	beq.w	LEAF6
LEAF0	move.w	d0,(PlayerScrollCtr).l
LEAF6	bsr.w	LEB02
	bsr.w	LEC3E
	bra.w	LEABA
LEB02	move.w	(PlayerScrollCtr).l,d0
	beq.w	Sub_29FF6
	add.w	(VertLineScrolling).l,d0
	bmi.w	Sub_29FF6
	cmp.w	(matchupvis).l,d0
	bgt.w	Sub_29FF6
	move.w	(VertLineScrolling).l,d1
	move.w	d0,(VertLineScrolling).l
	andi.w	#$F,d0
	bne.w	LEB3A
	clr.w	(PlayerScrollCtr).l
LEB3A	andi.w	#$F,d1
	bne.w	LEB5E
	move.w	d0,-(sp)
	cmpi.w	#$E,d0
	bne.w	LEB50
	bsr.w	LEC20
LEB50	move.w	(sp)+,d0
	cmpi.w	#$2,d0
	bne.w	LEB5E
	bsr.w	LEC2C
LEB5E	move.w	(disflags).l,-(sp)
	bset	#$2,(disflags).l
	movea.l	#$C00000,a0
LEB72	btst	#$7,$FF800E.l
	bne.b	LEB72
	move.l	#$40020010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset	#$6,$FF800F.l
LEB96	btst	#$6,$FF800E.l
	beq.b	LEB96
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
LEBB0	btst	#$6,$FF800E.l
	bne.b	LEBB0
	bclr	#$7,$FF800F.l
	move.w	#$FFB0,d0
	add.w	(VertLineScrolling).l,d0
LEBCC	btst	#$7,$FF800E.l
	bne.b	LEBCC
	move.w	d0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset	#$6,$FF800F.l
LEBEC	btst	#$6,$FF800E.l
	beq.b	LEBEC
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
LEC06	btst	#$6,$FF800E.l
	bne.b	LEC06
	bclr	#$7,$FF800F.l
	move.w	(sp)+,(disflags).l
	rts
LEC20	move.w	(VertLineScrolling).l,d3
	lsr.w	#$4,d3
	bra.w	LEC3C
LEC2C	move.w	(VertLineScrolling).l,d3
	lsr.w	#$4,d3
	addi.w	#$6,d3
	bra.w	LEC3C
LEC3C	rts
LEC3E	movem.l	d0-d7/a0-a6,-(sp)
	dc.w	$4EB9,$0003,$8D8C
	String	CC_SetFont,$1
	tst.w	(VertLineScrolling).l
	beq.w	LEC6A
	dc.w	$4EB9,$0003,$8D8C
	String	CC_SetMapAndPosition,$4,$3,$26,$8,CC_SetFont,$1,'{'
	bra.w	LEC7A
LEC6A	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,$26,$8,CC_SetFont,$1,' '
LEC7A	move.w	(matchupvis).l,d0
	cmp.w	(VertLineScrolling).l,d0
	beq.w	LEC9E
	dc.w	$4EB9,$0003,$8D8C
	String	CC_SetMapAndPosition,$4,$3,$26,$1A,CC_SetFont,$1,'}'
	bra.w	LECAE
LEC9E	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$3,$26,$1A,CC_SetFont,$1,' '
LECAE	jsr	(printsmallz).l
	String	CC_SetFont
	movem.l	(sp)+,d0-d7/a0-a6
	rts
DisplayStats
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font3Pri,$2,$7
	move.w	#$2C,d0
	dc.w	$4EB9,$0002,$C59E
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font3Pri,$1A,$7
	moveq	#$0,d0
	dc.w	$4EB9,$0002,$C59E
	bsr.w	LEB5E
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font2Pri,$0,$0
	moveq	#$E,d6
	dc.w	$43FA,$015A
	dc.w	$4A79,$0001,$8C08
	bne.w	LED10
	move.w	#$A,d6
	dc.w	$43FA,$0236
LED10	move.w	(a1),d0
	lsr.w	#$1,d0
	neg.w	d0
	addi.w	#$15,d0
	move.w	d0,(printx).l
	dc.w	$4EB9,$0003,$8F80
	movea.l	a1,a0
	move.w	#$22,(printx).l
	movea.l	#tmstruct,a2
	bsr.w	PrintStatValue
	move.w	#$9,(printx).l
	lea.l	$366(a2),a2
	bsr.w	PrintStatValue
	lea.l	$4(a0),a1
	addi.w	#$2,(printy).l
	dbra	d6,LED10
	rts
PrintStatValue
	movea.l	#mesarea,a3
	move.w	#$2,(a3)
	cmpi.w	#$FFFF,(a0)
	bne.w	LEDA2
	move.w	#$C,d0
	move.w	(a2,d0.w),d0
	mulu.w	#$64,d0
	move.w	#$0,d1
	move.w	(a2,d1.w),d1
	beq.w	LED88
	divu.w	d1,d0
LED88	jsr	(PushNumber).l
	dc.w	$4EB9,$0003,$9208
	dc.w	$4EB9,$0003,$9200
	String	'%'
	bra.w	LEE38
LEDA2	move.w	(a0),d0
	move.w	(a2,d0.w),d0
	cmpi.w	#$354,(a0)
	bne.w	LEDB8
	bsr.w	LEE50
	bra.w	LEDD0
LEDB8	cmpi.w	#$A,(a0)
	beq.w	LEDC4
	bsr.w	LEE4A
LEDC4	cmpi.w	#$A,(a0)
	bne.w	LEDD0
	bsr.w	LEE50
LEDD0	jsr	(appstring).l
	move.w	$2(a0),d0
	bmi.w	LEE38
	dc.w	$4EB9,$0003,$9200
	String	'/'
	move.w	(a2,d0.w),d0
	dc.w	$4EB9,$0003,$915E
	dc.w	$4EB9,$0003,$9208
	cmpi.w	#$14,(a0)
	bne.w	LEE38
	dc.w	$4EB9,$0003,$9200
	String	' ('
	move.w	(a0),d0
	move.w	(a2,d0.w),d0
	mulu.w	#$64,d0
	move.w	$2(a0),d1
	move.w	(a2,d1.w),d1
	beq.w	LEE22
	divu.w	d1,d0
LEE22	jsr	(PushNumber).l
	dc.w	$4EB9,$0003,$9208
	dc.w	$4EB9,$0003,$9200
	String	'%)'
LEE38	movea.l	a3,a1
	move.w	(a1),d0
	lsr.w	#$1,d0
	sub.w	d0,(printx).l
	dc.w	$4EF9,$0003,$8F80
LEE4A	jmp	(PushNumber).l
LEE50	jmp	(PushTime).l
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_0EE56.bin
Sub_29FF6
	rts
updatePPTeamTime
	btst	#$5,$17F6C.l
	beq.w	LF022
	movea.l	#tmstruct,a2
	btst	#$6,$17F6C.l
	beq.w	LF01C
	movea.l	#awtmstruct,a2
LF01C	addi.w	#$1,$354(a2)
LF022	rts
GetTeamRating
	movem.l	d1-d7/a0-a6,-(sp)
	move.w	$2A(a2),d0
	movea.l	#$2A040,a0
	clr.w	d1
	move.b	(a0,d0.w),d1
	move.w	d1,d0
	movem.l	(sp)+,d1-d7/a0-a6
	rts
	dc.w	$334C,$494B,$4E43,$4B43,$3442,$4A49,$4442,$4A37
	dc.w	$454B,$4738,$4538,$4847,$4846,$5B59
ShortenMsgTimer
	movem.l	d0,-(sp)
	dc.w	$4A79,$0001,$7FA8
	beq.w	LF078
	move.w	$52(a3),d0
	cmp.w	$17BE0.l,d0
	bne.w	LF08C
LF078	cmpi.w	#$2,$17F98.l
	ble.w	LF08C
	move.w	#$2,$17F98.l
LF08C	movem.l	(sp)+,d0
	rts
ManualGoalieMenu
	movem.l	d0-d7/a0-a6,-(sp)
	tst.w	(OptNOP).l
	beq.w	LF0DC
	dc.w	$3039,$0001,$7FA6
	dc.w	$B079,$0001,$7FA8
	bne.w	LF0BC
	dc.w	$0A79,$0001,$0001,$8C0E
	bra.w	LF0D4
LF0BC	btst	#$1,$17F6A.l
	beq.w	LF0D4
	dc.w	$0A79,$0001,$0001,$8C0E
	bra.w	LF0DC
LF0D4	dc.w	$0A79,$0001,$0001,$8C0C
LF0DC	btst	#$0,$17F78.l
	bne.w	LF0F4
	btst	#$2,$17F70.l
	beq.w	LF1A4
LF0F4	btst	#$1,$17F6A.l
	bne.w	LF164
	cmpi.w	#$2,(OptNOP).l
	bne.w	LF11C
	dc.w	$0C79,$0005,$0001,$9368
	bgt.w	LF1A4
	bra.w	LF128
LF11C	dc.w	$0C79,$0005,$0001,$9368
	ble.w	LF1A4
LF128	move.w	#$0,d0
	cmpi.w	#$2,(OptNOP).l
	bne.w	LF13C
	move.w	#$6,d0
LF13C	dc.w	$4A79,$0001,$8C0C
	bne.w	LF15A
	move.w	#$5,d0
	cmpi.w	#$2,(OptNOP).l
	bne.w	LF15A
	move.w	#$B,d0
LF15A	jsr	(Sub_312B8).l
	bra.w	LF1A4
LF164	cmpi.w	#$2,(OptNOP).l
	bne.w	LF180
	dc.w	$0C79,$0005,$0001,$9368
	ble.w	LF1A4
	bra.w	LF18C
LF180	dc.w	$0C79,$0005,$0001,$9368
	bgt.w	LF1A4
LF18C	move.w	#$6,d0
	dc.w	$4A79,$0001,$8C0E
	bne.w	LF19E
	move.w	#$B,d0
LF19E	jsr	(Sub_312DC).l
LF1A4	movem.l	(sp)+,d0-d7/a0-a6
	rts
RunArenaAnim
	dc.w	$4A79,$0001,$A556
	bmi.w	LF21C
	movem.l	d0-d7/a0-a6,-(sp)
	dc.w	$4AB9,$0001,$A55C
	bne.w	LF202
	dc.w	$3039,$0001,$A556
	asl.w	#$3,d0
	movea.l	#$2A26C,a0
	dc.w	$23F0,$0000,$0001,$A558
	dc.w	$23F0,$0004,$0001,$A55C
	movea.l	$4(a0,d0.w),a2
	adda.w	#$8,a2
	dc.w	$3839,$0001,$A54E
	dc.w	$4EB9,$0003,$8958
	dc.w	$4279,$0001,$A552
	bsr.w	NextArenaFrame
	bra.w	LF218
LF202	dc.w	$9F79,$0001,$A554
	bpl.w	LF218
	dc.w	$0679,$0001,$0001,$A552
	bsr.w	NextArenaFrame
LF218	movem.l	(sp)+,d0-d7/a0-a6
LF21C	rts
NextArenaFrame
	dc.w	$2079,$0001,$A558
	dc.w	$3039,$0001,$A552
	add.w	d0,d0
	move.b	(a0,d0.w),d1
	ext.w	d1
	dc.w	$33C1,$0001,$A550
	move.b	$1(a0,d0.w),d1
	ext.w	d1
	dc.w	$33C1,$0001,$A554
	dc.w	$0C79,$FFFF,$0001,$A550
	bne.w	LF25A
	dc.w	$4279,$0001,$A552
	bra.w	NextArenaFrame
LF25A	dc.w	$0C79,$FFFE,$0001,$A550
	bne.w	LF26A
	bsr.w	Sub_2A466
LF26A	rts
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_0F26C.bin
StartArenaAnim
	movem.l	d0-d7/a0-a6,-(sp)
	dc.w	$33C0,$0001,$A556
	dc.w	$23FC,$0000,$0000,$0001,$A558
	dc.w	$23FC,$0000,$0000,$0001,$A55C
	dc.w	$33FC,$0001,$0001,$A550
	dc.w	$4279,$0001,$A552
	dc.w	$50F9,$0001,$A560
	movem.l	(sp)+,d0-d7/a0-a6
	rts
SetFaceoffAnim
	bset	#$0,$17F7A.l
	dc.w	$33C0,$0001,$A560
	rts
Sub_2A466
	dc.w	$33FC,$FFFF,$0001,$A556
	bclr	#$0,$17F7A.l
	rts
ChooseSong
	movem.l	d0-d1/a0-a1,-(sp)
	btst	#$4,$17F68.l
	beq.w	LF490
	move.w	#$FFFF,d1
	bra.w	LF4D0
LF490	bclr	#$6,$17F7C.l
	dc.w	$207C,$0002,$A4DC
	movea.l	#$2A584,a1
	dc.w	$3039,$0001,$A56C
	mulu.w	#$6,d0
	dc.w	$D079,$0001,$A56E
	clr.w	d1
	move.b	(a0,d0.w),d1
	bne.w	LF4D0
	move.w	#$8,d0
	dc.w	$4EB9,$0003,$7050
	andi.w	#$7,d0
	move.b	(a1,d0.w),d1
LF4D0	dc.w	$33C1,$0001,$A56A
	movem.l	(sp)+,d0-d1/a0-a1
	rts
TeamSongs
	dc.w	$7775
