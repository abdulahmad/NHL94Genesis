SelectPenaltyShotSkater						;pick the skater for the penalty shot from team BA_Team
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a0
	dc.w	$4A79,$0001,$9366
	beq.w	.hometeam
	movea.l	#awtmstruct,a0
.hometeam	move.w	#$0,d1
	move.w	#$FFFF,d6
	move.w	#$FFFF,d5
	movea.l	$1E(a0),a2
	adda.w	$0(a2),a2
.playerloop	cmpi.w	#$2,(a2)
	beq.w	.doneplayers
	adda.w	(a2),a2
	move.w	d1,d7
	asl.w	#$1,d7
	move.b	$5(a2),d0
	andi.w	#$F,d0
	cmpi.b	#$1,d0
	ble.w	.nextplayer
	btst	#$0,$17F78.l
	bne.w	.l19774
	cmpi.w	#$FFFE,$68(a0,d7.w)
	beq.w	.scorecandidate
	cmpi.w	#$FFFF,$68(a0,d7.w)
	bne.w	.nextplayer
.scorecandidate	clr.w	d3
	clr.w	d0
	move.b	$1(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	$2(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	$2(a2),d0
	andi.w	#$F0,d0
	lsr.w	#$4,d0
	add.w	d0,d3
	move.b	$3(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	$3(a2),d0
	andi.w	#$F0,d0
	lsr.w	#$4,d0
	add.w	d0,d3
	move.b	$5(a2),d0
	andi.w	#$F,d0
	add.w	d0,d3
	move.b	$5(a2),d0
	andi.w	#$F0,d0
	lsr.w	#$4,d0
	add.w	d0,d3
	move.b	$6(a2),d0
	andi.w	#$F0,d0
	lsr.w	#$4,d0
	add.w	d0,d3
	move.b	$7(a2),d0
	andi.w	#$F0,d0
	lsr.w	#$4,d0
	add.w	d0,d3
	dc.w	$B279,$0001,$936C
	bne.w	.comparebest
	move.w	#$7FFF,d3
.comparebest	cmp.w	d6,d3
	blt.w	.nextplayer
	move.w	d3,d6
	move.w	d1,d5
	bra.w	.nextplayer
.nextplayer	adda.l	#$8,a2
	addi.w	#$1,d1
	cmpi.w	#$1A,d1
	blt.w	.playerloop
.doneplayers	tst.w	d5
	bmi.w	.noeligible
	dc.w	$33C5,$0001,$936C
.l19774	dc.w	$33FC,$0000,$0001,$9368
	dc.w	$4A79,$0001,$9366
	beq.w	.l1978E
	dc.w	$33FC,$0006,$0001,$9368
.l1978E	dc.w	$3039,$0001,$9368
	asl.w	#$7,d0
	dc.w	$267C,$0001,$7480
	adda.w	d0,a3
	dc.w	$3639,$0001,$936C
	bra.w	.eligible
.noeligible	move.w	#$FFFF,d0
	bra.w	.exit
.eligible	move.w	#$1,d0
.exit	movem.l	(sp)+,d0-d7/a0-a6
	rts
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_197BA.bin
UpdatePenaltyShotEnd						;end the penalty shot when the goalie has the puck, the puck is loose or
									;the timer runs out
	movem.w	d0,-(sp)
	move.w	$17BE0.l,d0
	dc.w	$B079,$0001,$936A
	movem.w	(sp)+,d0
	beq.w	.l19C00
	btst	#$5,$17F70.l
	beq.w	.l19C08
	btst	#$5,$17F78.l
	bne.w	.puckloose
	tst.w	$17BE0.l
	bpl.w	.l19BEC
	bset	#$5,$17F78.l
.puckloose	tst.w	$17BE0.l
	bpl.w	.l19C00
.l19BEC	dc.w	$4A79,$0001,$7F9A
	bmi.w	.l19C00
	dc.w	$5379,$0001,$7F9A
	bra.w	.l19C08
.l19C00	bset	#$4,$17F70.l
.l19C08	dc.w	$4A79,$0001,$93B6
	bne.w	.checkended
	bset	#$4,$17F70.l
.checkended	btst	#$4,$17F70.l
	bne.w	.finishshot
	rts
.finishshot	btst	#$6,$17F70.l
	bne.w	L19CC4
	bset	#$6,$17F70.l
	move.w	#$A,d0
	dc.w	$4EB9,$0003,$9456
EndPenaltyShotPlay						;stop play after a penalty shot or shootout attempt: freeze the window,
									;stop the clock, clear the penalty shot flags
	jsr	(freezewindow).l
	btst	#$0,$17F78.l
	bne.w	.stopplay
	dc.w	$33FC,$000A,$0001,$AD92
	bset	#$2,$17F6C.l
.stopplay	bset	#$0,$17F68.l
	bclr	#$2,$17F78.l
	bclr	#$2,$17F70.l
	bclr	#$3,$17F70.l
	bclr	#$5,$17F70.l
	bclr	#$4,$17F70.l
	bclr	#$6,$17F70.l
	movem.l	d0/a0,-(sp)
	dc.w	$207C,$0001,$7480
	dc.w	$3039,$0001,$9368
	asl.w	#$7,d0
	move.b	$17F9C.l,$61(a0,d0.w)
	movem.l	(sp)+,d0/a0
	jsr	(CountShootoutGoals).l
L19CC4	rts
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_19CC6.bin
L19EDC	dc.w	$4A79,$0001,$8C0A
	bne.w	rtss2
	btst	#$4,$17F7A.l
	bne.w	.l19F06
	dc.w	$B079,$0001,$7FA6
	beq.w	rtss2
	dc.w	$B079,$0001,$7FA8
	beq.w	rtss2
.l19F06	bsr.w	CompLine
	dc.w	$4EB9,$0003,$D426
	bsr.w	printscores1
	dc.w	$33FC,$2710,$0001,$7F82
	rts
StartFaceoffLineChange						;start the line change box for team d0's sort object before a faceoff
	exg.l	a2,a3
	asl.w	#$7,d0
	dc.w	$267C,$0001,$7480
	adda.w	d0,a3
	bclr	#$3,$63(a3)
	move.l	a2,-(sp)
	bsr.w	Sub_30B08
	movea.l	(sp)+,a2
	btst	#$3,$63(a3)
	beq.w	.exit
	btst	#$6,$62(a3)
	beq.w	.homeplayer
	move.w	#$168,$42(a2)
	move.w	$52(a3),$46(a2)
	bra.w	.exit
.homeplayer	move.w	#$258,$40(a2)
	move.w	$52(a3),$44(a2)
.exit	exg.l	a2,a3
	rts
WaitForFaceoffLineChanges						;run both teams' faceoff line change timers (temp1 / temp2); continue when
									;both have run out
	move.w	#$40,d0
	bsr.w	UpdateFaceoffLineChangeTimer
	move.w	#$42,d0
	bsr.w	UpdateFaceoffLineChangeTimer
	tst.w	$40(a3)
	bpl.w	rtss2
	tst.w	$42(a3)
	bpl.w	rtss2
	movea.l	#tmstruct,a2
	lea.l	$366(a2),a1
	moveq	#$1,d0
	bsr.w	L19EDC
	move.w	#$FFFF,$1A568.l
	move.w	#$1C,d0		;puckfaceoff2
	bra.w	Sub_362E4
UpdateFaceoffLineChangeTimer						;count down one team's faceoff line change timer at offset d0 of a3
	tst.w	(a3,d0.w)
	bmi.w	rtss2
	move.w	$4(a3,d0.w),d1
	asl.w	#$7,d1
	dc.w	$207C,$0001,$7480
	movea.l	#tmstruct,a2
	btst	#$6,$62(a0,d1.w)
	beq.w	.checkactive
	adda.w	#$366,a2
.checkactive	btst	#$3,$63(a0,d1.w)
	bne.w	.countdown
	st.b	(a3,d0.w)
	bra.w	Sub_30B50
.countdown	sub.w	d7,(a3,d0.w)
	bpl.w	rtss2
	move.l	a3,-(sp)
	lea.l	(a0,d1.w),a3
	btst	#$3,$63(a3)
	beq.w	.exit
	clr.w	d2
	bsr.w	Sub_30D64
	bsr.w	Sub_30B50
.exit	movea.l	(sp)+,a3
	rts
	dc.w	$4EF9,$0002,$BE98
ChkGoalies						;computer pulls goalie on delayed penalty. Called from periodicevents
	btst	#$0,$17F68.l		;check if clock running
	bne.w	rtss2
	movea.l	#tmstruct,a2		;a2 = team being tested, a1 = the other team
	lea.l	$366(a2),a1
	moveq	#$1,d0		;d0 = team number (1 home, 2 visitors)
	bsr.w	.chkgoalie
	moveq	#$2,d0
	exg.l	a1,a2
.chkgoalie	tst.w	$28(a2)		;check for goalie
	bmi.w	rtss2		;no goalie, exit
	move.w	$17BE0.l,d1		;move puck carrier SCnum into d1
	bmi.w	rtss2
	subi.w	#$6,d1
	cmpa.l	#$1834C,a2
	beq.w	.chkpen
	not.w	d1		;makes d1 negative if away team
.chkpen	tst.w	d1
	bpl.w	rtss2
	btst	#$3,$17F68.l		;#gmpendel - delayed penalty called
	beq.w	.l1A070
	st.b	$28(a2)		;sets to FFFF (no goalie)
	dc.w	$4EF9,$0003,$D426
.l1A070	dc.w	$B079,$0001,$7FA6
	beq.w	rtss2
	dc.w	$B079,$0001,$7FA8
	beq.w	rtss2
	dc.w	$3239,$0001,$7B94
	bra.w	CPgoalie
ReturnGoalies						;if computer pulled goalie, look to see if computer should return him.
									;Called from puckfaceoff
	movea.l	#tmstruct,a2		;a2 = team being tested, a1 = the other team
	lea.l	$366(a2),a1
	moveq	#$1,d0		;d0 = team number
	bsr.w	.r		;home team first ...
	moveq	#$2,d0
	exg.l	a1,a2		;... then fall into .r for the visitors
.r	cmpi.w	#$FFFF,$28(a2)
	beq.w	rtss2		;still no goalie
	clr.b	$28(a2)		;clear for goalie return
	dc.w	$B079,$0001,$7FA6
	beq.w	rtss2
	dc.w	$B079,$0001,$7FA8
	beq.w	rtss2
	move.w	$17EE4.l,d1
CPgoalie						;see if computer should pull his goalie. d1 = puck/faceoff y. Falls in
									;from ReturnGoalies; also entered from ChkGoalies
	cmpi.w	#$2,$180E4.l		;check if 3rd period
	bne.w	rtss2		;exit if not
	move.w	$C(a1),d0		;tmscore
	sub.w	$C(a2),d0
	bmi.w	rtss2		;exit if leading in the game
	cmpi.w	#$2,d0
	bne.w	rtss2		;exit if behind by more than 2
	dc.w	$0C79,$003C,$0001,$80E6
	bgt.w	rtss2		;exit if more than 1 min left
	move.l	a0,-(sp)
	movea.l	$22(a2),a0		;moves a player struct address into a0
	btst	#$7,$62(a0)		;#pfgoal
	movea.l	(sp)+,a0
	bne.w	.0
	neg.w	d1		;make y positive toward the goal I shoot at
.0	tst.w	d1
	bmi.w	rtss2		;exit if d1 negative (faceoff in own zone)
	st.b	$28(a2)		;set to FFFF (no goalie)
	dc.w	$4EF9,$0003,$D426
CompLine						;find good line for comp to switch to. a2 = team, a1 = other team. Called
									;from chk4lc and puckfaceoff
	movem.l	d0-d2/a0,-(sp)
	moveq	#$3,d0		;d0 = first of the 2 special lines (3-4) used with a man advantage
	move.w	$26(a2),d1		;tmap
	sub.w	$26(a1),d1		;compare the numbers of active players
	beq.w	L1A15A		;equal: normal line
	bpl.w	.0
	addi.w	#$2,d0		;fewer players: lines 5-6 instead
.0	move.w	d0,-(sp)		;find pk/pp line
	bsr.w	getlinee		;d0 = energy of the first candidate
	move.w	d0,d1
	move.w	(sp),d0
	addi.w	#$1,d0
	bsr.w	getlinee		;d0 = energy of the second candidate
	cmp.w	d0,d1
	bge.w	.1
	addi.w	#$1,(sp)		;second one has more energy: take it
.1	move.w	(sp)+,$16(a2)		;tmline
Sub_35154
	movem.l	(sp)+,d0-d2/a0
	rts
L1A15A	cmpa.l	#$1834C,a2
	bne.w	Sub_351D8
	moveq	#$2,d1
	dc.w	$41FA,$0046
	cmpi.w	#$2,$180E4.l
	bne.w	.l1A18E
	move.w	$C(a2),d2
	cmp.w	$C(a1),d2
	beq.w	.l1A18E
	adda.w	#$E,a0
	bgt.w	.l1A18E
	adda.w	#$E,a0
.l1A18E	move.w	$16(a1),d1
	asl.w	#$1,d1
	move.w	(a0,d1.w),d0
	bsr.w	getlinee
	cmpi.w	#$C00,d0
	bls.w	Sub_351D8
	move.w	(a0,d1.w),$16(a2)
	bra.w	Sub_35154
	dc.w	$0000,$0001,$0002,$0000,$0001,$0000,$0001,$0002
	dc.w	$0000,$0001,$0002,$0000,$0002,$0000,$0000,$0001
	dc.w	$0000,$0000,$0001,$0000,$0001
