	include	segacd\hockey.inc
	include	macros\genesis.mac

BA_Goalie_SCnum	equ	$1936A
BA_Skater_Offset	equ	$1936C
BA_Team	equ	$19366
CC_Font1Pri	equ	$BF
CC_Font2	equ	$FE
CC_Font2Pri	equ	$BE
CC_Font3	equ	$FD
CC_SetMapAndPosition	equ	$F8
EASportsBGMap	equ	$47D0C
EndShootout	equ	$291CE
ExitToOpening	equ	$3F2BE
Framer	equ	$38CA0
GAttribOverall	equ	$41DC0
GetGoalieCount	equ	$2ED60
GetNameandAttrib	equ	$2D56A
GetPlayerCount	equ	$2EDBC
HomeTeam	equ	$17FAE
LOAD	equ	$1B000
MenuWaitVblank	equ	$2C63A
PAttribOverall	equ	$41C5E
PlayerScrollCtr	equ	$1A452
ProcessInputWithRepeat	equ	$374BE
Satt	equ	$BBD30
SetupScreen	equ	$2E728
ShooterOverallTxt	equ	$27F28
ShooterOverallTxt2	equ	$27F3E
StartShootoutPath	equ	$2A686
TeamList	equ	$1B00C
TestList	equ	$1A45A
VertLineScrolling	equ	$1A450
VisTeam	equ	$17FB0
awayshooters	equ	$1A42A
awayshootgoals	equ	$1A418
dobitmap	equ	$387E2
eraser	equ	$38C06
getpzjoy	equ	$2F2F0
homeshooters	equ	$1A41C
homeshootgoals	equ	$1A416
homeshootnum	equ	$1A428
move	equ	$2C9C8
null	equ	$1B008
print	equ	$38F80
printa	equ	$18D5C
printbigz	equ	$39258
printsmallz	equ	$38D8C
printy	equ	$18D5A
printz	equ	$38F6E
scoutcolumn	equ	$1A44E
screentimer	equ	$1A458
shootoutteam	equ	$1A436
X_CC80	equ	$CC80
X_CF54	equ	$CF54
X_CF8A	equ	$CF8A
X_D0D6	equ	$D0D6
X_D13E	equ	$D13E

	org	$CA30

NextShooter						;Shootout: the next shooter (BA_Team, BA_Goalie_SCnum, StartShootoutPath),
									;or the end (ExitToOpening).
	btst	#$3,$17F78.l
	beq.w	.0		;shootout running?
	jmp	(ExitToOpening).l		;shootout over: back to the title
.0	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	StartShootoutPath-LOAD
	move.w	(shootoutteam).l,(BA_Team).l
	move.w	#$B,(BA_Goalie_SCnum).l		;home goalie slot $B
	movea.l	#homeshooters,a0
	tst.w	(shootoutteam).l		;visitors shoot?
	beq.w	.1
	move.w	#$5,(BA_Goalie_SCnum).l		;away goalie slot 5
	movea.l	#awayshooters,a0
.1	move.w	(homeshootnum).l,d0
	add.w	d0,d0
	move.w	(a0,d0.w),(BA_Skater_Offset).l		;this round's shooter
	bclr	#$2,$17BE2.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
CountShootoutGoals						;Shootout: count the goals and end it when one team cannot catch up
									;(EndShootout, high ROM). Called from EndPenaltyShotPlay
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#$0,$1A437.l		;away just shot?
	beq.w	.switch		;home just shot: other team
	cmpi.w	#$5,$1A41A.l		;round 5 or later?
	blt.w	.switch		;before round 5: keep going
	move.w	(homeshootgoals).l,d0
	cmp.w	(awayshootgoals).l,d0		;goals differ?
	beq.w	.switch		;tied: keep going
	bset	#$3,$17F78.l		;shootout over
	jsr	(EndShootout).l
	bra.w	.x
.switch	eori.w	#$1,(shootoutteam).l
	bne.w	.x		;home shoots next: done
	addi.w	#$1,(homeshootnum).l
	cmpi.w	#$5,(homeshootnum).l		;past the 5th?
	blt.w	.1
	clr.w	(homeshootnum).l		;back to the first shooter
.1	addi.w	#$1,$1A41A.l
.x	movem.l	(sp)+,d0-d7/a0-a6
	rts
InitShooters						;Shootout: the 6 starters of the home (shootoutteam 0) or away team as the
									;shooter list below homeshootnum / shootoutteam
	movea.l	#homeshootnum,a0
	move.w	(HomeTeam).l,d0
	tst.w	(shootoutteam).l
	beq.w	.0
	move.w	(VisTeam).l,d0
	movea.l	#shootoutteam,a0
.0	movea.l	#TeamList,a1
	asl.w	#$2,d0
	movea.l	(a1,d0.w),a1
	adda.w	$6(a1),a1
	move.w	#$5,d0		;6 starters
.loop	clr.w	d1
	move.b	(a1)+,d1
	subi.w	#$1,d1		;roster index 0-based
	move.w	d1,-(a0)		;store the roster index
	dbra	d0,.loop
	rts
ShootoutWonBy						;Shootout: "SHOOTOUT WON BY" (printbig). Called from SetPA
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	CC_Font1Pri,$1,$D
	move.w	#$6,d1
	move.w	#$1E,d0
	jsr	(Framer).l		;draw the box
	jsr	(printbigz).l
	String	CC_Font1Pri,$2,$E,'SHOOTOUT WON BY'
	dc.w	$0679,$0002,$0001,$8D5A,$3239,$0001,$7FAE,$3039
	dc.w	$0001,$A416,$B079,$0001,$A418,$6E00,$0008,$3239
	dc.w	$0001,$7FB0,$E541,$227C,$0001,$B00C,$2271,$1000
	dc.w	$D2E9,$0004,$33FC,$0002,$0001,$8D58,$4EB9,$0003
	dc.w	$926A,$4CDF,$7FFF,$4E75
ShootoutShooters						;Shootout shooters menu item (menu lists): pick
									;the 3 shooters of each team
	btst	#$0,$17F78.l		;shootout?
	beq.w	X_CC80
	moveq	#$0,d0
	moveq	#$1C,d1
	jsr	(SetupScreen).l		;set up the screen
	clr.w	(scoutcolumn).l
	clr.w	(PlayerScrollCtr).l
	jsr	(printsmallz).l
	dc.w	$0008
	dc.b	$FF,$02,$FD,$00,$FC,$00
	dc.w	$7028,$721C,$343C,$07FF,$4EB9,$0003,$8C06,$6100
	dc.w	$0428,$6100,$0432,$33FC,$0000,$0001,$A45A,$6100
	dc.w	$037C,$6100,$051A,$6100,$04AE
ShootersLoop						;Shootout shooters: the input loop
	jsr	(MenuWaitVblank).l		;wait for the frame
	jsr	(getpzjoy).l		;read the pads
	jsr	(ProcessInputWithRepeat).l		;pad presses with repeat
	btst	#$7,d1		;start?
	bne.w	X_CC80
	move.w	#$1,d0
	btst	#$1,d1		;down?
	bne.w	ShootersMove
	move.w	#$FFFF,d0
	btst	#$0,d1		;up?
	bne.w	ShootersMove
	move.w	#$0,d0
	btst	#$2,d1		;left?
	bne.w	X_CF54		;left: the first slot
	move.w	#$5,d0
	btst	#$3,d1		;right?
	bne.w	X_CF54		;right: the goalie slot
	btst	#$5,d1
	bne.w	ShooterSelectList		;C: the player list
	bra.w	ShootersLoop
	dc.w	$4EF9,$0002,$E980
ShooterSelectList						;Shootout shooters: "{Select Player}" list
	move.w	#$C000,d7		;highlight palette
	movea.l	#homeshooters,a0
	cmpa.l	#$1834C,a2
	beq.w	.0
	movea.l	#awayshooters,a0
.0	move.w	(TestList).l,d0
	asl.w	#$1,d0		;word per slot
	move.w	(a0,d0.w),d6		;current shooter
	jsr	(GetGoalieCount).l
	move.w	d0,d1
	jsr	(GetPlayerCount).l
	sub.w	d1,d0
	subi.w	#$1,d0
	cmpi.w	#$5,(TestList).l		;goalie slot?
	bne.w	.1
	move.w	d1,d0
	subi.w	#$1,d0		;last goalie
	clr.w	d1		;goalies come first
.1	move.w	d0,(screentimer).l
	clr.w	(PlayerScrollCtr).l		;scroll to the top
	clr.w	(VertLineScrolling).l		;cursor on row 0
	movea.l	#Satt,a0
	clr.w	d2
.loop	move.b	d1,(a0,d2.w)		;row = roster index
	cmp.w	d1,d6		;current shooter?
	bne.w	.2
	move.w	d2,(VertLineScrolling).l		;cursor starts on him
.2	addi.w	#$1,d1		;next roster index
	addi.w	#$1,d2
	dbra	d0,.loop
	bsr.w	ClearShooterScreen
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$0,$3,$1,$0
	dc.w	$303C,$0012,$323C,$0003,$4EB9,$0003,$8CA0,$4EB9
	dc.w	$0003,$8D8C,$0006,$FD15,$FC00,$303C,$0012,$323C
	dc.w	$0003,$4EB9,$0003,$8CA0,$4EB9,$0003,$8D8C,$0016
	dc.w	$F804,$0202,$017B,$5365,$6C65,$6374,$2050,$6C61
	dc.w	$7965,$727D,$4240,$6000,$0064,$4EB9,$0002,$C63A
	dc.w	$4EB9,$0002,$F2F0,$4EB9,$0003,$74BE,$0801,$0007
	dc.w	$6600,$FEA0,$0801,$0005,$6600,$0088,$7001,$0801
	dc.w	$0001,$6600,$0038,$0801,$0003,$6600,$0018,$70FF
	dc.w	$0801,$0000,$6600,$0026,$0801,$0002,$6600,$0006
	dc.w	$6000,$FFB8,$D079,$0001,$A44E,$6B00,$FFAE,$33C0
	dc.w	$0001,$A44E,$6100,$0082,$6000,$FFA0,$D079,$0001
	dc.w	$A450,$6B00,$FF96,$B079,$0001,$A458,$6E00,$FF8C
	dc.w	$33C0,$0001,$A450,$B079,$0001,$A452,$6E00,$0008
	dc.w	$33C0,$0001,$A452,$0440,$0005,$B079,$0001,$A452
	dc.w	$6F00,$0008,$33C0,$0001,$A452,$6100,$003C,$6000
	dc.w	$FF5A,$267C,$000B,$BD30,$D6F9,$0001,$A450,$4240
	dc.w	$1013,$3439,$0001,$A45A,$207C,$0001,$A41C,$B5FC
	dc.w	$0001,$834C,$6700,$0008,$207C,$0001,$A42A,$E342
	dc.w	$3180,$2000,$6000,$FDDC
PrintShooterList						;Shootout shooters: the player list rows (getNameandAttrib)
	jsr	(printz).l
	String	CC_Font2Pri,$16,$1
.loop	movea.l	#PAttribOverall,a1		;skater columns
	cmpi.w	#$5,(TestList).l		;goalie slot?
	bne.w	.0
	movea.l	#GAttribOverall,a1		;goalie columns
.0	move.w	(scoutcolumn).l,d0
	bra.w	.1
	adda.w	(a1),a1
	adda.w	#$4,a1
.1	tst.w	(a1)
	dbmi	d0,$CE72
	bpl.w	.found		;page found?
	subi.w	#$1,(scoutcolumn).l		;past the end: back one page
	bra.w	.loop
.found	cmpa.l	#$41C5E,a1		;skater columns?
	bne.w	.3
	movea.l	#ShooterOverallTxt,a1		;skater header
.3	cmpa.l	#$41DC0,a1		;goalie columns?
	bne.w	.4
	movea.l	#ShooterOverallTxt2,a1		;goalie header
.4	jsr	(print).l
	move.l	(a1),d4		;rating weights
	movea.l	#Satt,a3
	move.w	(PlayerScrollCtr).l,d2
	move.w	(screentimer).l,d1
	sub.w	d2,d1
	cmpi.w	#$5,d1		;more than 6?
	bls.w	.5
	moveq	#$5,d1		;at most 6 rows
.5	move.w	#$2,(printy).l
.loop3	jsr	(printsmallz).l
	dc.w	$0020
	dc.b	$FE,$04,$FD,$05,$FA,$01,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$FD,$05
	cmp.w	(VertLineScrolling).l,d2		;cursor row?
	bne.w	.6
	move.w	d7,(printa).l
.6	clr.w	d0
	move.b	(a3,d2.w),d0		;roster index
	jsr	(GetNameandAttrib).l		;print name and rating
	addi.w	#$1,d2
	dbra	d1,.loop3
	rts
	dc.w	$0012,$2020,$2020,$4F76,$6572,$616C,$6C20,$2020
	dc.w	$205D,$1F3A,$000A,$0012,$2020,$2020,$4F76,$6572
	dc.w	$616C,$6C20,$2020,$205D,$1B0F,$000A,$B079,$0001
	dc.w	$A45A,$6700,$FCCE,$6000,$002A
ShootersMove						;Shootout shooters: move the slot cursor by d0, wrapping in 0 ... 4 (not
									;on slot 5)
	cmpi.w	#$5,(TestList).l		;on the goalie slot?
	beq.w	ShootersLoop		;goalie slot: no moving
	add.w	(TestList).l,d0
	bmi.w	ShootersSelect		;above the first?
	cmpi.w	#$5,d0		;past the 5th?
	blt.w	X_CF8A
	clr.w	d0		;wrap to the first
	bra.w	X_CF8A
ShootersSelect						;Shootout shooters: TestList = d0, redraw the names and the player box,
									;back to the loop
	move.w	#$4,d0
	move.w	d0,(TestList).l
	bsr.w	X_D13E
	bsr.w	X_D0D6		;redraw the box
	bra.w	ShootersLoop		;back to the input loop
	bsr.w	ClearShooterScreen
	movem.l	d0-d5/a0-a2,-(sp)
	jsr	(printz).l
	String	CC_Font3,$0,$0
	movea.l	(EASportsBGMap).l,a1
	adda.l	$4(a1),a1
	movea.l	#null,a2
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	$2(a1),d3
	moveq	#$1,d4
	moveq	#$0,d5
	jsr	(dobitmap).l
	movem.l	(sp)+,d0-d5/a0-a2
	dc.w	$4EB9,$0003,$8F6E,$0006,$BE07,$0100,$701A,$7206
	dc.w	$4EB9,$0003,$8CA0,$4EB9,$0003,$9258,$0014,$BE0A
	dc.w	$0420,$2053,$686F,$6F74,$6F75,$7420,$20BE,$0F01
	dc.w	$4240,$B5FC,$0001,$834C,$6700,$0006,$303C,$002C
	dc.w	$4EF9,$0002,$C59E
ClearShooterScreen						;Shootout shooters: erase the screen
	jsr	(printz).l
	String	CC_Font2Pri,$0,$0
	moveq	#$28,d0
	moveq	#$A,d1
	move.w	#$7FF,d2
	jmp	(eraser).l
	clr.w	$BBD0A.l
	clr.w	$BBD2A.l
	rts
	jsr	(printsmallz).l
	dc.w	$0008
	dc.b	$FF,$02,$FD,$00,$FC,$0A
	jsr	(printsmallz).l
	String	CC_Font2,$4
	jsr	(printsmallz).l
	String	CC_Font3,$7,$FC,$C,'Shooters'
	jsr	(printsmallz).l
	String	CC_Font3,$3,$FC,$E,'1. '
	jsr	(printsmallz).l
	String	CC_Font3,$3,$FC,$10,'2. '
	jsr	(printsmallz).l
	String	CC_Font3,$3,$FC,$12,'3. '
	dc.w	$4EB9,$0003,$8D8C,$000A,$FD03,$FC14,$342E,$2000
	dc.w	$4EB9,$0003,$8D8C,$000A,$FD03,$FC16,$352E,$2000
	dc.w	$4EB9,$0003,$8D8C,$000C,$FD1A,$FC0C,$476F,$616C
	dc.w	$6965,$4E75,$4EB9,$0003,$8D8C,$000A,$F804,$0208
	dc.w	$07F9,$0100,$7018,$7203,$4EB9,$0003,$8CA0,$4EB9
	dc.w	$0003,$8D8C,$0008,$FD15,$FC08,$FE06,$227C,$0001
	dc.w	$A41C,$B5FC,$0001,$834C,$6700,$0008,$227C,$0001
	dc.w	$A42A,$3039,$0001,$A45A,$E340,$3031,$0000,$4EB9
	dc.w	$0004,$112E,$3011,$E248,$9179,$0001,$8D58,$4EB9
	dc.w	$0003,$8D9E,$4279,$0001,$8D60,$4E75,$48E7,$FFFE
	dc.w	$4EB9,$0003,$8D8C,$0008,$FD06,$FC0E,$FE06,$323C
	dc.w	$0000,$207C,$0001,$A41C,$B5FC,$0001,$834C,$6700
	dc.w	$0008,$207C,$0001,$A42A,$3001,$E340,$3030,$0000
	dc.w	$4EB9,$0004,$1226,$3F39,$0001,$8D58,$B279,$0001
	dc.w	$A45A,$6600,$000A,$33FC,$0002,$0001,$8D60,$0C41
	dc.w	$0005,$6600,$0012,$33FC,$0019,$0001,$8D58,$33FC
	dc.w	$000E,$0001,$8D5A,$4EB9,$0003,$8D9E,$4279,$0001
	dc.w	$8D60,$33DF,$0001,$8D58,$0679,$0002,$0001,$8D5A
	dc.w	$0641,$0001,$0C41,$0006,$6D00,$FF9E,$4CDF,$7FFF
	dc.w	$4E75
