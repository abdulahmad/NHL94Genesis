	include	segacd\hockey.inc
	include	macros\genesis.mac

BA_Sktr_SCnum	equ	$19368
CountShootoutGoals	equ	$27A98
Framer	equ	$38CA0
LOAD	equ	$1B000
SortCords	equ	$17480
c1playernum	equ	$17F9E
c2playernum	equ	$17FA0
c3playernum	equ	$17FA2
c4playernum	equ	$17FA4
changeplayer	equ	$312A4
cont1team	equ	$17FA6
cont2team	equ	$17FA8
cont3team	equ	$17FAA
cont4team	equ	$17FAC
dobitmap	equ	$387E2
fofdata	equ	$17D00
freezewindow	equ	$30094
gameclock	equ	$180E6
move	equ	$2C9C8
printsmallz	equ	$38D8C
replaydelay	equ	$1AD92
sflags6	equ	$17F76
tmstruct	equ	$1834C
L1A1D8	equ	$1A1D8
X_15B08	equ	$15B08
X_15B50	equ	$15B50
X_15D64	equ	$15D64
X_162A4	equ	$162A4
X_19EDC	equ	$19EDC
X_1A1AE	equ	$1A1AE
X_1A218	equ	$1A218
X_1A890	equ	$1A890
X_1B2E4	equ	$1B2E4
X_21000	equ	$21000
X_2179E	equ	$2179E

	org	$19C46

EndPenaltyShotPlay						;stop play after a penalty shot or shootout attempt: freeze the window,
									;stop the clock, clear the penalty shot flags
	jsr	(freezewindow).l
	btst	#$0,$17F78.l
	bne.w	.stopplay
	move.w	#$A,(replaydelay).l
	bset	#$2,$17F6C.l
.stopplay	bset	#$0,$17F68.l
	bclr	#$2,$17F78.l
	bclr	#$2,$17F70.l
	bclr	#$3,$17F70.l
	bclr	#$5,$17F70.l
	bclr	#$4,$17F70.l
	bclr	#$6,$17F70.l
	movem.l	d0/a0,-(sp)
	movea.l	#SortCords,a0
	move.w	(BA_Sktr_SCnum).l,d0
	asl.w	#$7,d0
	move.b	$17F9C.l,$61(a0,d0.w)
	movem.l	(sp)+,d0/a0
	jsr	(CountShootoutGoals).l
	dc.w	$4E75,$08B9,$0004,$0001,$7F7C,$0839,$0000,$0001
	dc.w	$7F78,$6700,$0016,$4279,$0001,$7BA8,$4279,$0001
	dc.w	$7BAA,$303C,$001E,$6000,$15F8,$08AB,$0001,$0062
	dc.w	$6700,$0276,$08B9,$0000,$0001,$7F7C,$6700,$000E
	dc.w	$4279,$0001,$7EE2,$4279,$0001,$7EE4,$08B9,$0007
	dc.w	$0001,$7F7A,$42B9,$0001,$7DCA,$42B9,$0001,$7DCE
	dc.w	$42B9,$0001,$7DD2,$08B9,$0006,$0001,$7F7A,$08B9
	dc.w	$0002,$0001,$7F7A,$4EB9,$0002,$ACA0,$4A79,$0001
	dc.w	$A560,$6B00,$000C,$3039,$0001,$A560,$6000,$000E
	dc.w	$4EB9,$0002,$AC4E,$4A40,$6B00,$0008,$4EB9,$0002
	dc.w	$A456,$08B9,$0001,$0001,$7F76,$08B9,$0001,$0001
	dc.w	$7F78,$4A79,$0001,$80E6,$6700,$0CC0,$0839,$0006
	dc.w	$0001,$7F68,$6600,$0CB4,$0C79,$0003,$0001,$80E4
	dc.w	$6600,$0012,$3039,$0001,$8358,$B079,$0001,$86BE
	dc.w	$6600,$0266,$0839,$0003,$0001,$7F68,$6600,$4CA4
	dc.w	$3039,$0001,$80EA,$E240,$B079,$0001,$80E6,$6300
	dc.w	$005C,$0C79,$003C,$0001,$80E6,$6D00,$0050,$0839
	dc.w	$0007,$0001,$7F6E,$6700,$0044,$0839,$0000,$0001
	dc.w	$7F68,$6700,$0038,$0839,$0006,$0001,$7F7C,$6600
	dc.w	$002C,$08B9,$0007,$0001,$7F6E,$33F9,$0001,$7FAE
	dc.w	$0001,$A56C,$33FC,$0002,$0001,$A56E,$4EB9,$0002
	dc.w	$A478,$3F39,$0001,$A56A,$6100,$23B4,$6100,$026C
	dc.w	$50EB,$0040,$50EB,$0042,$4A79,$0001,$8C0A,$6600
	dc.w	$0138,$08B9,$0001,$0001,$837E,$08B9,$0001,$0001
	dc.w	$86E4,$207C,$0001,$7480,$700B,$08A8,$0003,$0063
	dc.w	$D0FC,$0080,$51C8,$FFF4,$3039,$0001,$7FA6,$8079
	dc.w	$0001,$7FA8,$6700,$0042,$0839,$0007,$0001,$7F6A
	dc.w	$6700,$0036,$6100,$1E90,$08F9,$0006,$0001,$7F6A
	dc.w	$6100,$7526,$33FC,$0018,$0001,$8D62,$4A79,$0001
	dc.w	$8C0A,$6600,$0014,$0839,$0004,$0001,$7F7A,$6700
	dc.w	$0008,$4279,$0001,$8D62,$3039,$0001,$7F9E,$6B00
	dc.w	$0006,$6100,$0066,$3039,$0001,$7FA0,$6B00,$0006
	dc.w	$6100,$0058,$227C,$0001,$834C,$45E9,$0366,$7002
	dc.w	$6100,$0006,$6000,$0092,$4A79,$0001,$8C0A,$6600
	dc.w	$711C,$0839,$0004,$0001,$7F7A,$6600,$0016,$B079
	dc.w	$0001,$7FA6,$6700,$7106,$B079,$0001,$7FA8,$6700
	dc.w	$70FC,$6100,$0212,$4EB9,$0003,$D426,$6100,$757A
	dc.w	$33FC,$2710,$0001,$7F82,$4E75
StartFaceoffLineChange						;start the line change box for team d0's sort object before a faceoff
	exg.l	a2,a3
	asl.w	#$7,d0
	movea.l	#SortCords,a3
	adda.w	d0,a3
	bclr	#$3,$63(a3)
	move.l	a2,-(sp)
	bsr.w	X_15B08
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
	bpl.w	X_21000
	tst.w	$42(a3)
	bpl.w	X_21000
	movea.l	#tmstruct,a2
	lea.l	$366(a2),a1
	moveq	#$1,d0
	bsr.w	X_19EDC
	move.w	#$FFFF,$1A568.l
	move.w	#$1C,d0		;puckfaceoff2
	bra.w	X_1B2E4
UpdateFaceoffLineChangeTimer						;count down one team's faceoff line change timer at offset d0 of a3
	tst.w	(a3,d0.w)
	bmi.w	X_21000
	move.w	$4(a3,d0.w),d1
	asl.w	#$7,d1
	movea.l	#SortCords,a0
	movea.l	#tmstruct,a2
	btst	#$6,$62(a0,d1.w)
	beq.w	.checkactive
	adda.w	#$366,a2
.checkactive	btst	#$3,$63(a0,d1.w)
	bne.w	.countdown
	st.b	(a3,d0.w)
	bra.w	X_15B50
.countdown	sub.w	d7,(a3,d0.w)
	bpl.w	X_21000
	move.l	a3,-(sp)
	lea.l	(a0,d1.w),a3
	btst	#$3,$63(a3)
	beq.w	.exit
	clr.w	d2
	bsr.w	X_15D64
	bsr.w	X_15B50
.exit	movea.l	(sp)+,a3
	rts
	dc.w	$4EF9,$0002,$BE98,$0839,$0000,$0001,$7F68,$6600
	dc.w	$6FE4,$247C,$0001,$834C,$43EA,$0366,$7001,$6100
	dc.w	$0006,$7002,$C34A,$4A6A,$0028,$6B00,$6FC8,$3239
	dc.w	$0001,$7BE0,$6B00,$6FBE,$0441,$0006,$B5FC,$0001
	dc.w	$834C,$6700,$0004,$4641,$4A41,$6A00,$6FA8,$0839
	dc.w	$0003,$0001,$7F68,$6700,$000C,$50EA,$0028,$4EF9
	dc.w	$0003,$D426,$B079,$0001,$7FA6,$6700,$6F88,$B079
	dc.w	$0001,$7FA8,$6700,$6F7E,$3239,$0001,$7B94,$6000
	dc.w	$003E
ReturnGoalies						;if computer pulled goalie, look to see if computer should return him.
									;Called from puckfaceoff
	movea.l	#tmstruct,a2		;a2 = team being tested, a1 = the other team
	lea.l	$366(a2),a1
	moveq	#$1,d0		;d0 = team number
	bsr.w	.r		;home team first ...
	moveq	#$2,d0
	exg.l	a1,a2		;... then fall into .r for the visitors
.r	cmpi.w	#$FFFF,$28(a2)
	beq.w	X_21000		;still no goalie
	clr.b	$28(a2)		;clear for goalie return
	cmp.w	(cont1team).l,d0
	beq.w	X_21000		;exit if team is joy controlled
	cmp.w	(cont2team).l,d0
	beq.w	X_21000		;exit if team is joy controlled
	move.w	$17EE4.l,d1
CPgoalie						;see if computer should pull his goalie. d1 = puck/faceoff y. Falls in
									;from ReturnGoalies; also entered from ChkGoalies
	cmpi.w	#$2,$180E4.l		;check if 3rd period
	bne.w	X_21000		;exit if not
	move.w	$C(a1),d0		;tmscore
	sub.w	$C(a2),d0
	bmi.w	X_21000		;exit if leading in the game
	cmpi.w	#$2,d0
	bne.w	X_21000		;exit if behind by more than 2
	cmpi.w	#$3C,(gameclock).l		;#60
	bgt.w	X_21000		;exit if more than 1 min left
	move.l	a0,-(sp)
	movea.l	$22(a2),a0		;moves a player struct address into a0
	btst	#$7,$62(a0)		;#pfgoal
	movea.l	(sp)+,a0
	bne.w	.0
	neg.w	d1		;make y positive toward the goal I shoot at
.0	tst.w	d1
	bmi.w	X_21000		;exit if d1 negative (faceoff in own zone)
	st.b	$28(a2)		;set to FFFF (no goalie)
	jmp	$3D426.l
CompLine						;find good line for comp to switch to. a2 = team, a1 = other team. Called
									;from chk4lc and puckfaceoff
	movem.l	d0-d2/a0,-(sp)
	moveq	#$3,d0		;d0 = first of the 2 special lines (3-4) used with a man advantage
	move.w	$26(a2),d1		;tmap
	sub.w	$26(a1),d1		;compare the numbers of active players
	beq.w	.nopwr		;equal: normal line
	bpl.w	.0
	addi.w	#$2,d0		;fewer players: lines 5-6 instead
.0	move.w	d0,-(sp)		;find pk/pp line
	bsr.w	X_2179E		;d0 = energy of the first candidate
	move.w	d0,d1
	move.w	(sp),d0
	addi.w	#$1,d0
	bsr.w	X_2179E		;d0 = energy of the second candidate
	cmp.w	d0,d1
	bge.w	.1
	addi.w	#$1,(sp)		;second one has more energy: take it
.1	move.w	(sp)+,$16(a2)		;tmline
.ex	movem.l	(sp)+,d0-d2/a0
	rts
.nopwr	cmpa.l	#$1834C,a2		;find normal line
	bne.w	L1A1D8		;visitors use the other table
	moveq	#$2,d1
	lea.l	X_1A1AE(pc),a0		;a0 = row of .hl1 (7 words, indexed by the other team's line)
	cmpi.w	#$2,$180E4.l
	bne.w	.h0		;not 3rd period: first row
	move.w	$C(a2),d2		;tmscore
	cmp.w	$C(a1),d2
	beq.w	.h0		;tied: first row
	adda.w	#$E,a0		;(adda keeps the flags of the cmp) next row ...
	bgt.w	.h0		;... if leading
	adda.w	#$E,a0		;third row if trailing
.h0	move.w	$16(a1),d1		;tmline
	asl.w	#$1,d1
	move.w	(a0,d1.w),d0
	bsr.w	X_2179E
	cmpi.w	#$C00,d0		;#(3*$1000)/4
	bls.w	L1A1D8
	move.w	(a0,d1.w),$16(a2)		;tmline
	bra.w	.ex
	ori.b	#$1,d0
	ori.b	#$0,d2
	ori.b	#$0,d1
	ori.b	#$2,d1
	ori.b	#$1,d0
	ori.b	#$0,d2
	ori.b	#$0,d2
	ori.b	#$1,d0
	ori.b	#$0,d0
	ori.b	#$0,d1
	dc.w	$0001,$7202
	lea.l	X_1A218(pc),a0
	cmpi.w	#$2,$180E4.l
	bne.w	.a0
	move.w	$C(a2),d2		;tmscore
	cmp.w	$C(a1),d2
	beq.w	.a0		;tied or not 3rd period: first row
	adda.w	#$6,a0		;(flags of the cmp are kept) next row ...
	bgt.w	.a0		;... if leading
	adda.w	#$6,a0		;third row if trailing
.a0	move.w	(a0)+,d0
	bsr.w	X_2179E
	cmpi.w	#$C00,d0		;#(19*$1000)/20
	dbhi	d1,.a0		;energy above 3/4: stop, else try the next
	move.w	-(a0),$16(a2)		;tmline
	bra.w	.ex
	dc.w	$0000,$0001,$0002,$0000,$0002,$0001,$0000,$0001
	dc.w	$0000,$08AB,$0001,$0062,$6700,$051E,$08B9,$0002
	dc.w	$0001,$7F70,$08B9,$0005,$0001,$7F70,$08B9,$0000
	dc.w	$0001,$7F72,$08B9,$0001,$0001,$7F72,$08B9,$0000
	dc.w	$0001,$7F7E,$08B9,$0001,$0001,$7F7E,$08B9,$0002
	dc.w	$0001,$7F7E,$48E7,$FFFE,$6100,$1A98,$0839,$0000
	dc.w	$0001,$8D64,$6600,$FFF6,$33FC,$003C,$0001,$9374
	dc.w	$4A79,$0001,$7EE2,$6600,$0018,$4A79,$0001,$7EE4
	dc.w	$6600,$000E,$33FC,$FFFF,$0001,$A560,$6000,$000A
	dc.w	$08B9,$0005,$00FF,$800F,$0C79,$0258,$0001,$7CD2
	dc.w	$6300,$000A,$33FC,$0258,$0001,$7CD2,$08F9,$0003
	dc.w	$0001,$8D64,$08B9,$0000,$0001,$7F6A,$08B9,$0000
	dc.w	$0001,$7F6E,$4279,$0001,$7E32,$4239,$0001,$7ECE
	dc.w	$50F9,$0001,$806E,$50F9,$0001,$7E38,$50F9,$0001
	dc.w	$7E3C,$08B9,$0001,$0001,$7F6C,$08F9,$0000,$0001
	dc.w	$7F6C,$08F9,$0002,$0001,$7F6C,$50F9,$0001,$7E30
	dc.w	$50F9,$0001,$7EBC,$08F9,$0004,$0001,$8D64,$6100
	dc.w	$7084,$33FC,$2710,$0001,$7F82,$4279,$0001,$7CEA
	dc.w	$4279,$0001,$7CEE,$33F9,$0001,$7EE2,$0001,$7B80
	dc.w	$33F9,$0001,$7EE4,$0001,$7B94,$50F9,$0001,$7B98
	dc.w	$4279,$0001,$7BA8,$4279,$0001,$7BAA,$4279,$0001
	dc.w	$7BAC,$50F9,$0001,$7BE0,$207C,$0001,$7A80,$4268
	dc.w	$0028,$4268,$002A,$4268,$0000,$317C,$010C,$0014
	dc.w	$D1FC,$0000,$0080,$4268,$0028,$4268,$002A,$4268
	dc.w	$0000,$317C,$FEF4,$0014,$207C,$0001,$7C00,$317C
	dc.w	$018A,$0006,$4268,$0058,$4268,$0004,$4279,$0001
	dc.w	$7B84,$08B9,$0006,$0001,$7F6A,$7864,$6100,$ACEC
	dc.w	$51CC,$FFFA,$33FC,$003C,$0001,$7EE0,$4EB9,$0003
	dc.w	$D6E2,$247C,$0001,$834C,$4EB9,$0003,$D426,$4EB9
	dc.w	$0003,$D668,$D4FC,$0366,$4EB9,$0003,$D426,$4EB9
	dc.w	$0003,$D668,$4EB9,$0003,$F0C6,$2F0B,$267C,$0001
	dc.w	$7480,$740B,$377C,$FF10,$0000,$426B,$0014,$426B
	dc.w	$0006,$322B,$0034,$6B00,$010A,$6700,$0046,$7016
	dc.w	$0C41,$0004,$6600,$0038,$247C,$0001,$834C,$082B
	dc.w	$0006,$0062,$6700,$0006,$D4FC,$0366,$426A,$0018
	dc.w	$156B,$0066,$0019,$08B9,$0007,$0001,$7F7C,$50EA
	dc.w	$001A,$50EA,$001C,$08AA,$0003,$0032,$7017,$6100
	dc.w	$0E70,$3839,$0001,$8372,$082B,$0006,$0062,$6700
	dc.w	$0008,$3839,$0001,$86D8,$4444,$0644,$0006,$E744
	dc.w	$227C,$0003,$5764,$D2C4,$1831,$1000,$E544,$227C
	dc.w	$0003,$577C,$3031,$4000,$3231,$4002,$082B,$0007
	dc.w	$0062,$6600,$0006,$4440,$4441,$4A6B,$0034,$6700
	dc.w	$0036,$0C44,$0008,$6E00,$0022,$3639,$0001,$7EE2
	dc.w	$B143,$6A00,$000C,$3639,$0001,$7EE4,$E643,$9243
	dc.w	$3639,$0001,$7EE2,$E443,$9043,$D079,$0001,$7EE2
	dc.w	$D279,$0001,$7EE4,$3740,$0000,$3741,$0014,$426B
	dc.w	$0028,$426B,$002A,$9079,$0001,$7B80,$9279,$0001
	dc.w	$7B94,$4440,$4441,$6100,$0DE8,$3740,$0054,$08AB
	dc.w	$0002,$0063,$08AB,$0005,$0062,$323C,$050C,$6100
	dc.w	$0E98,$D7FC,$0000,$0080,$51CA,$FEDA,$4EB9,$0003
	dc.w	$F03E,$265F,$6100,$025A,$3839,$0001,$8D56,$2479
	dc.w	$0004,$7D14,$508A,$4EB9,$0003,$8958,$33C4,$0001
	dc.w	$8D4C,$2479,$0004,$7D30,$508A,$6100,$33F4,$33FC
	dc.w	$FFFF,$0001,$A556,$0839,$0000,$0001,$7F7A,$6700
	dc.w	$0012,$3039,$0001,$A560,$6B00,$0008,$4EB9,$0002
	dc.w	$A41E,$6100,$39E2,$0006,$FF00,$0000,$7036,$4A79
	dc.w	$0001,$7EE2,$6A00,$0006,$303C,$00BE,$33C0,$0001
	dc.w	$746C,$0440,$002E,$E640,$33C0,$0001,$8D58,$705C
	dc.w	$33C0,$0001,$746E,$0440,$0044,$E640,$33C0,$0001
	dc.w	$8D5A,$3839,$0001,$8D56
	dc.w	$2079,$0004,$7D14
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$C,d2
	moveq	#$A,d3
	moveq	#$0,d5
	bset	#$0,(sflags6).l
	bsr.w	dobitmap-LOAD
	dc.w	$08B9,$0000,$0001,$7F76,$4A79,$0001,$8C0A,$6600
	dc.w	$0056,$6100,$3784,$0006,$FA0A,$FE04
	moveq	#$C,d0
	moveq	#$3,d1
	bsr.w	Framer-LOAD
	move.w	$18362.l,d0
	move.w	$186C8.l,d1
	btst	#$1,$17F68.l
	bne.w	.l1A632
	exg.l	d0,d1
.l1A632	bsr.w	printsmallz-LOAD
	dc.w	$0006
	dc.b	$FB,$01,$FA,$FE
	dc.w	$227C,$0004,$19F6,$6100,$787A,$0679,$0004,$0001
	dc.w	$8D58,$3001,$227C,$0004,$19F6,$6100,$7866,$303C
	dc.w	$0078,$6100,$19F0,$0640,$00B4,$0C79,$0000,$0001
	dc.w	$A556,$6700,$0032,$0C79,$0001,$0001,$A556,$6700
	dc.w	$0026,$0C79,$0005,$0001,$A556,$6700,$001A,$0C79
	dc.w	$0004,$0001,$A556,$6700,$000E,$0C79,$0002,$0001
	dc.w	$A556,$6600,$000E,$0C40,$010E,$6E00,$0006,$303C
	dc.w	$010E,$3740,$0040,$33FC,$0018,$0001,$8D62,$207C
	dc.w	$0001,$7CF8,$30BC,$0001,$317C,$8000,$0002,$317C
	dc.w	$0004,$0004,$317C,$A800,$0006,$317C,$0007,$0008
	dc.w	$317C,$8000,$000A,$0839,$0001,$0001,$7F68,$6600
	dc.w	$000E,$0A68,$0800,$0002,$0A68,$0800,$0006,$33FC
	dc.w	$FFFF,$0001,$7EE6,$33FC,$FFFF,$0001,$7EE8,$4EB9
	dc.w	$0002,$B2D6,$08B9,$0006,$0001,$7F7C,$6600,$000E
	dc.w	$08B9,$0004,$0001,$7F7C,$6700,$0014,$08B9,$0004
	dc.w	$0001,$7F7C,$3F39,$0001,$A56A,$6100,$1A9A,$33FC
	dc.w	$0018,$0001,$8D62,$08F9,$0005,$00FF,$800F,$4CDF
	dc.w	$7FFF,$4E75,$046B,$0001,$0040,$6A00,$0114,$4EB9
	dc.w	$0002,$A466,$6000,$0172,$0001,$0203,$0405,$0600
	dc.w	$0001,$0503,$0402,$0000,$0003,$0501,$0400,$0000
	dc.w	$0000,$FF06,$FFDD,$FFCE,$0023,$FFCE,$FFCE,$FFF6
	dc.w	$0000,$FFF1,$0032,$FFF6,$0000,$FFC4
ResetAndSelectPlayers						;c1playernum / c2playernum = -1, then changeplayer for each human team
	move.w	#$FFFF,(c1playernum).l
	move.w	#$FFFF,(c2playernum).l
	tst.w	(cont1team).l
	beq.w	.checkcont2
	clr.w	d4
	bsr.w	X_162A4
.checkcont2	tst.w	(cont2team).l
	beq.w	.checkcont3
	moveq	#$2,d4
	bsr.w	X_162A4
.checkcont3	tst.w	(cont3team).l
	beq.w	.checkcont4
	move.w	(cont1team).l,-(sp)
	move.w	(cont3team).l,(cont1team).l
	move.w	(c1playernum).l,-(sp)
	move.w	#$FFFF,(c1playernum).l
	clr.w	d4
	jsr	(changeplayer).l
	move.w	(c1playernum).l,(c3playernum).l
	move.w	(cont1team).l,(cont3team).l
	move.w	(sp)+,(c1playernum).l
	move.w	(sp)+,(cont1team).l
.checkcont4	tst.w	(cont4team).l
	beq.w	.exit
	move.w	(cont2team).l,-(sp)
	move.w	(cont4team).l,(cont2team).l
	move.w	(c2playernum).l,-(sp)
	move.w	#$FFFF,(c2playernum).l
	move.w	#$2,d4
	jsr	(changeplayer).l
	move.w	(c2playernum).l,(c4playernum).l
	move.w	(cont2team).l,(cont4team).l
	move.w	(sp)+,(c2playernum).l
	move.w	(sp)+,(cont2team).l
.exit	rts
updatefaceoff						;a3 = puck. Drop animation frame from temp1; at 0 erases the faceoff box
	move.w	$40(a3),d0		;frames left until the drop
	beq.w	X_1A890		;0: remove the face off box
	addi.w	#$6,d0
	lsr.w	#$3,d0		;(temp1 + 6) / 8
	cmpi.w	#$2,d0
	bgt.w	X_21000
	neg.w	d0
	addi.w	#$A,d0		;frame $A - d0 (8 to 10) as the drop approaches
	move.w	d0,(fofdata).l		;+8
	rts
	dc.w	$08B9,$0004,$0001,$8D64,$6100,$36D4,$0006,$BF00
	dc.w	$0000,$3039,$0001,$746C,$0440,$002E,$E640,$33C0
	dc.w	$0001,$8D58,$7064,$3039,$0001,$746E,$0440,$0044
	dc.w	$E640,$33C0,$0001,$8D5A,$700C,$720D,$343C,$07FF
	dc.w	$6000,$3334,$207C,$000B,$BD30,$3039,$0001,$7F66
	dc.w	$3239,$0001,$8D32,$4EB9,$0003,$777C,$3F3C,$002F
	dc.w	$6100,$181A,$08B9,$0000,$0001,$7F6C,$33FC,$003C
	dc.w	$0001,$9374,$3839,$0001,$8D56,$2479,$0004,$7D1C
	dc.w	$508A,$6100,$3044,$08B9,$0002,$0001,$7F6C,$08B9
	dc.w	$0000,$0001,$7F68,$08AB,$0000,$0063,$4279,$0001
	dc.w	$7F82,$08F9,$0004,$0001,$7F6E,$3639,$0001,$7EE6
	dc.w	$383C,$0800,$207C,$0003,$5A38,$227C,$0001,$7CF8
	dc.w	$7410,$3211,$9430,$10FF,$3229,$0004,$D430,$10FF
	dc.w	$7021,$6100,$16EC,$B400,$6300,$0006,$D2FC,$0004
	dc.w	$0829,$0003,$0002,$6700,$000A,$3639,$0001,$7EE8
	dc.w	$4444,$3003,$0800,$0003,$6600,$005A,$0240,$0007
	dc.w	$0839,$0007,$00FF,$800E,$66F6,$33FC,$001B,$00FF
	dc.w	$8020,$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$67F6,$3239,$00FF,$8010,$08F9,$0007,$00FF
	dc.w	$800F,$08B9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$66F6,$08B9,$0007,$00FF,$800F,$0241,$0003
	dc.w	$6600,$001A,$7005,$6100,$1668,$0440,$0002,$0240
	dc.w	$0007,$4A44,$6B00,$0006,$0A40,$0004,$E540,$207C
	dc.w	$0003,$6B8E,$3230,$0000,$EB41,$3741,$0028,$3230
	dc.w	$0002,$EB41,$D244,$3741,$002A,$303C,$0800,$6100
	dc.w	$1630,$3740,$002C,$4279,$0001,$7B98,$08AB,$0002
	dc.w	$0062,$7018,$6000,$08AE,$0008,$1000,$0810
