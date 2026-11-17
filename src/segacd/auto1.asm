	include	segacd\hockey.inc
	include	macros\genesis.mac

CC_Font1	equ	$FF
ClearGameStats	equ	$29302
FigureJoy	equ	$40318
Framer	equ	$38CA0
GameSetUpMap	equ	$47D74
HomeTeam	equ	$17FAE
Opt1team	equ	$18BFE
Opt2team	equ	$18C00
OptLine	equ	$18C0A
OptNOP	equ	$18BFC
OptPen	equ	$18C08
OptPlayMode	equ	$18BFA
OptUserRec	equ	$18C06
ReadNameLog	equ	$2262E
ReadPassBits	equ	$4057C
TempBuffer	equ	$17E70
TempWord1	equ	$17E62
TempWord2	equ	$17E64
ValidSRAM	equ	$193BA
VisTeam	equ	$17FB0
awayhotter	equ	$17EA0
awtmstruct	equ	$186B2
demoflag	equ	$18C16
disflags	equ	$18D64
dobitmap	equ	$387E2
goaliemode1	equ	$18C0C
goaliemode2	equ	$18C0E
logoteam	equ	$1938A
move	equ	$2C9C8
palcount	equ	$18D62
passbits	equ	$18C38
printa	equ	$18D5C
printx	equ	$18D58
printy	equ	$18D5A
printz	equ	$38F6E
randomd0	equ	$37050
setupfirstline	equ	$19384
setuphome	equ	$1938C
setupmenuchars	equ	$19388
setupprevline	equ	$19386
setupvis	equ	$1938E
sflags6	equ	$17F76
tmstruct	equ	$1834C
X_81F2	equ	$81F2
X_8A8C	equ	$8A8C
X_8CB6	equ	$8CB6
X_9238	equ	$9238
X_9348	equ	$9348
X_9524	equ	$9524
X_9660	equ	$9660
X_9720	equ	$9720
X_9962	equ	$9962
X_99C6	equ	$99C6

	org	$82FC

CopyHottestPlayer
	movem.l	d0-d1/a0-a1,-(sp)
	movea.l	#TempBuffer,a1
	move.w	#$0,d0
L830A	clr.b	(a0)+
	move.b	(a1),d1
	move.b	d1,(a0)+
	tst.w	(a1)+
	dbra	d0,L830A
	movem.l	(sp)+,d0-d1/a0-a1
	rts
CopyColdestPlayer
	movem.l	d0/a0-a1,-(sp)
	movea.l	#$17E7A,a1
	move.w	#$0,d0
L832A	clr.b	(a0)+
	move.b	(a1),(a0)+
	tst.w	-(a1)
	dbra	d0,L832A
	movem.l	(sp)+,d0/a0-a1
	rts
CompareHotColdTotals
	movem.l	d1-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a0
	bsr.w	GetHotColdTotal
	move.w	d1,(TempWord1).l
	movea.l	#awtmstruct,a0
	bsr.w	GetHotColdTotal
	move.w	d1,(TempWord2).l
	move.w	(TempWord1).l,d1
	move.w	(TempWord2).l,d2
	sub.w	d1,d2
	move.w	#$0,(awayhotter).l
	tst.w	d2
	bmi.w	L8382
	move.w	#$1,(awayhotter).l
L8382	tst.w	d2
	bpl.w	L838A
	neg.w	d2
L838A	move.w	#$FFFF,d0
	cmpi.w	#$5E,d2
	blt.w	L83A6
	move.w	#$22,d0
	cmpi.w	#$BD,d2
	blt.w	L83A6
	move.w	#$23,d0
L83A6	movem.l	(sp)+,d1-d7/a0-a6
	rts
GetHotColdTotal
	bsr.w	X_81F2
	move.w	#$6,d0
	movea.l	#TempBuffer,a0
	clr.w	d1
L83BC	move.b	$1(a0),d2
	ext.w	d2
	add.w	d2,d1
	tst.w	(a0)+
	dbra	d0,L83BC
	rts
GameSetUp
	jsr	$2A58C.l
	movea.l	#passbits,a3
	jsr	(ReadPassBits).l
	move.w	$18C22.l,(OptLine).l
	move.w	$18C24.l,(OptPlayMode).l
	bclr.b	#$1,$17F7A.l
	jsr	(ClearGameStats).l
	jsr	(ReadNameLog).l
	bsr.w	X_9348
	clr.w	(setupfirstline).l
	clr.w	(setupprevline).l
	bsr.w	X_9238
	tst.w	(demoflag).l
	bne.w	L8440
	moveq	#$1C,d0
	jsr	(randomd0).l
	move.w	d0,(Opt1team).l
	moveq	#$1C,d0
	jsr	(randomd0).l
	move.w	d0,(Opt2team).l
L8440	st.b	(demoflag).l
	cmpi.w	#$4,(OptPlayMode).l
	bne.w	L8456
	bra.w	L8476
L8456	cmpi.w	#$2,(OptPlayMode).l
	blt.w	L8466
	bsr.w	L8798
L8466	cmpi.w	#$1,(OptPlayMode).l
	bne.w	L8476
	bsr.w	L879E
L8476	clr.w	d7
	clr.w	d0
	bsr.w	MoveMenuFrame
	bsr.w	FixModeOptions
	move.w	(HomeTeam).l,(setuphome).l
	move.w	(HomeTeam).l,(logoteam).l
	bsr.w	X_9962
	move.w	(VisTeam).l,(setupvis).l
	move.w	(VisTeam).l,(logoteam).l
	bsr.w	X_99C6
	move.w	#$18,(palcount).l
	bclr.b	#$2,(disflags).l
L84C2	cmpi.w	#$4,(OptPlayMode).l
	bne.w	L84E6
	move.w	#$1,(OptLine).l
	move.w	#$0,(OptPen).l
	move.w	#$1,(OptUserRec).l
L84E6	bsr.w	X_9524
	tst.w	d1
	bne.w	L84F4
	bra.w	X_9660
L84F4	btst	#$7,d1
	bne.w	X_9720
	btst	#$1,d1
	beq.w	L85A0
	tst.w	(OptNOP).l
	bne.w	L851E
	cmpi.w	#$8,d7
	bne.w	L851E
	move.w	#$4,d0
	bra.w	L8522
L851E	move.w	#$2,d0
L8522	cmpi.w	#$4,(OptPlayMode).l
	beq.w	L8548
	tst.w	(OptNOP).l
	bne.w	L8548
	cmpi.w	#$8,d7
	bne.w	L8548
	move.w	#$6,d0
	bra.w	L8594
L8548	cmpi.w	#$6,d7
	bne.w	L856C
	cmpi.w	#$4,(OptPlayMode).l
	bne.w	L856C
	tst.w	(OptNOP).l
	bne.w	L8590
	clr.w	d0
	bra.w	L8594
L856C	cmpi.w	#$A,d7
	bne.w	L8594
	cmpi.w	#$4,(OptPlayMode).l
	bne.w	L8586
	clr.w	d0
	bra.w	L8594
L8586	tst.w	(ValidSRAM).l
	bpl.w	L8594
L8590	move.w	#$4,d0
L8594	bsr.w	MoveMenuFrame
	bsr.w	FixModeOptions
	bra.w	L84C2
L85A0	btst	#$0,d1
	beq.w	L862E
	tst.w	(OptNOP).l
	bne.w	L85C2
	cmpi.w	#$C,d7
	bne.w	L85C2
	move.w	#$FFFC,d0
	bra.w	L85EC
L85C2	move.w	#$FFFE,d0
	cmpi.w	#$4,(OptPlayMode).l
	beq.w	L85EC
	tst.w	(OptNOP).l
	bne.w	L85EC
	cmpi.w	#$E,d7
	bne.w	L85EC
	move.w	#$FFFA,d0
	bra.w	L8622
L85EC	cmpi.w	#$A,d7
	bne.w	L8600
	cmpi.w	#$4,(OptPlayMode).l
	beq.w	L861E
L8600	cmpi.w	#$E,d7
	bne.w	L8622
	cmpi.w	#$4,(OptPlayMode).l
	beq.w	L861E
	tst.w	(ValidSRAM).l
	bpl.w	L8622
L861E	move.w	#$FFFC,d0
L8622	bsr.w	MoveMenuFrame
	bsr.w	FixModeOptions
	bra.w	L84C2
L862E	moveq	#$1,d2
	btst	#$3,d1
	bne.w	L8642
	btst	#$2,d1
	beq.w	L84C2
	moveq	#-1,d2
L8642	cmpi.w	#$4,(OptPlayMode).l
	beq.w	L8654
	jsr	(FigureJoy).l
L8654	move.w	(Opt2team).l,-(sp)
	move.w	(Opt1team).l,-(sp)
	bsr.w	X_8A8C
	move.w	(sp)+,d0
	cmpi.w	#$4,(OptPlayMode).l
	beq.w	L867C
	tst.w	(OptPlayMode).l
	bne.w	L8690
L867C	move.w	(Opt1team).l,(HomeTeam).l
	move.w	(Opt2team).l,(VisTeam).l
L8690	move.w	(HomeTeam).l,(logoteam).l
	btst.b	#$6,$19390.l
	beq.w	L86BE
	movem.w	d0,-(sp)
	move.w	(setuphome).l,d0
	cmp.w	(HomeTeam).l,d0
	movem.w	(sp)+,d0
	beq.w	L86CC
L86BE	move.w	(HomeTeam).l,(setuphome).l
	bsr.w	X_9962
L86CC	btst.b	#$7,$19390.l
	beq.w	L86F0
	movem.w	d0,-(sp)
	move.w	(setupvis).l,d0
	cmp.w	(VisTeam).l,d0
	movem.w	(sp)+,d0
	beq.w	L8712
L86F0	move.w	(VisTeam).l,(setupvis).l
	move.w	(VisTeam).l,(logoteam).l
	bsr.w	X_99C6
	move.w	(HomeTeam).l,(logoteam).l
L8712	tst.w	(sp)+
	bra.w	L878E
	move.w	(sp)+,d0
	cmp.w	(VisTeam).l,d0
	beq.w	L878E
	move.w	(VisTeam).l,(logoteam).l
	movem.w	d0,-(sp)
	move.w	(VisTeam).l,d0
	cmp.w	(VisTeam).l,d0
	movem.w	(sp)+,d0
	beq.w	L8754
	move.w	(VisTeam).l,(setupvis).l
	bsr.w	X_99C6
L8754	movem.w	d0,-(sp)
	move.w	(setuphome).l,d0
	cmp.w	(HomeTeam).l,d0
	movem.w	(sp)+,d0
	beq.w	L878E
	move.w	(HomeTeam).l,(setuphome).l
	move.w	(HomeTeam).l,(logoteam).l
	bsr.w	X_9962
	move.w	(VisTeam).l,(logoteam).l
L878E	bsr.w	FixModeOptions
	bra.w	L84C2
	rts
L8798	jmp	$401C4.l
L879E	jmp	$40132.l
MoveMenuFrame
	move.w	d7,d3
L87A6	bclr.b	#$2,$17F74.l
	tst.w	d0
	bpl.w	L87EA
	move.w	d0,-(sp)
	move.w	d7,d0
	asr.w	#$1,d0
	cmp.w	(setupfirstline).l,d0
	bne.w	L87E8
	move.w	(setupfirstline).l,(setupprevline).l
	bset.b	#$2,$17F74.l
	subi.w	#$1,(setupfirstline).l
	bpl.w	L87E8
	clr.w	(setupfirstline).l
L87E8	move.w	(sp)+,d0
L87EA	move.w	d7,(TempWord1).l
	add.w	d0,d7
	bpl.w	L87F8
	clr.w	d7
L87F8	tst.w	d0
	bmi.w	L8860
	move.w	d0,-(sp)
	move.w	d7,d0
	asr.w	#$1,d0
	sub.w	(setupfirstline).l,d0
	cmpi.w	#$5,d0
	bgt.w	L8816
	bra.w	L885E
L8816	move.w	(setupfirstline).l,(setupprevline).l
	bset.b	#$2,$17F74.l
	addi.w	#$1,(setupfirstline).l
	move.w	d7,d0
	asr.w	#$1,d0
	sub.w	(setupfirstline).l,d0
	cmpi.w	#$5,d0
	ble.w	L884A
	addi.w	#$1,(setupfirstline).l
L884A	cmpi.w	#$3,(setupfirstline).l
	ble.w	L885E
	move.w	#$3,(setupfirstline).l
L885E	move.w	(sp)+,d0
L8860	btst.b	#$2,$17F74.l
	bne.w	L8876
	move.w	(setupfirstline).l,(setupprevline).l
L8876	cmpi.w	#$12,d7
	blt.w	L8880
	sub.w	d0,d7
L8880	cmpi.w	#$1,(OptPlayMode).l
	bne.w	L889A
	tst.w	d7
	beq.w	L889A
	cmpi.w	#$6,d7
	bls.w	L87A6
L889A	cmpi.w	#$2,(OptPlayMode).l
	blt.w	L88BA
	cmpi.w	#$4,(OptPlayMode).l
	beq.w	L88BA
	cmpi.w	#$6,d7
	beq.w	L87A6
L88BA	bsr.w	L891E
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(setupmenuchars).l,d4
	movea.l	(GameSetUpMap).l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	move.w	(printx).l,d0
	subi.w	#$1,d0
	move.w	d1,d3
	move.w	(printy).l,d1
	subi.w	#$E,d1
	moveq	#$17,d2
	moveq	#$0,d5
	bset.b	#$0,(sflags6).l
	jsr	(dobitmap).l
	bclr.b	#$0,(sflags6).l
	movem.l	(sp)+,d0-d7/a0-a6
	move.w	d7,d3
	bsr.w	L8984
	move.w	#$6000,(printa).l
	jmp	(Framer).l
L891E	jsr	(printz).l
	String	CC_Font1,$10,$E
	move.w	#$17,d0
	move.w	#$D,d1
	rts
SetFrameRectUnused
	add.w	d3,(printy).l
	move.w	(setupprevline).l,d0
	add.w	d0,d0
	sub.w	d0,(printy).l
	cmpi.w	#$18,(printy).l
	ble.w	L895C
	move.w	#$18,(printy).l
L895C	moveq	#$17,d0
	moveq	#$3,d1
	cmpi.w	#$2,(OptPlayMode).l
	blt.w	L89CA
	cmpi.w	#$4,(OptPlayMode).l
	beq.w	L89CA
	cmpi.w	#$4,d3
	bne.w	L89CA
	moveq	#$5,d1
	rts
L8984	jsr	(printz).l
	String	CC_Font1,$10,$E
M
	add.w	d3,(printy).l
	move.w	(setupfirstline).l,d0
	add.w	d0,d0
	sub.w	d0,(printy).l
	moveq	#$17,d0
	moveq	#$3,d1
	cmpi.w	#$2,(OptPlayMode).l
	blt.w	L89CA
	cmpi.w	#$4,(OptPlayMode).l
	beq.w	L89CA
	cmpi.w	#$4,d3
	bne.w	L89CA
	moveq	#$5,d1
L89CA	rts
FixModeOptions
	movem.l	d0-d7/a0-a6,-(sp)
	cmpi.w	#$4,(OptPlayMode).l
	bne.w	L89E4
	move.w	#$1,(OptUserRec).l
L89E4	tst.w	(OptNOP).l
	bne.w	L89F6
	move.w	#$1,(OptUserRec).l
L89F6	tst.w	(OptNOP).l
	bne.w	L8A3A
	move.w	#$0,$18C04.l
	move.w	#$0,(goaliemode1).l
	move.w	#$0,(goaliemode2).l
	tst.w	(OptNOP).l
	bne.w	L8A3A
	move.w	#$1,$18C04.l
	move.w	#$1,(goaliemode1).l
	move.w	#$1,(goaliemode2).l
L8A3A	move.w	(setupfirstline).l,d0
	cmp.w	(setupprevline).l,d0
	beq.w	L8A4E
	bsr.w	X_9238
L8A4E	bset.b	#$3,(sflags6).l
	bsr.w	X_8CB6
	bclr.b	#$3,(sflags6).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	ori.b	#$8,d5
	ori.b	#$1C,(a4)+
	ori.b	#$2,d3
	ori.b	#$3,d2
	ori.b	#$5,d3
	dc.w	$000C
