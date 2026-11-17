	include	segacd\hockey.inc
	include	macros\genesis.mac

BA_Goalie_SCnum	equ	$1936A
BA_Team	equ	$19366
CC_Font1Pri	equ	$BF
CC_Font2Pri	equ	$BE
CC_SetMapAndPosition	equ	$F8
EndShootout	equ	$291CE
ExitToOpening	equ	$3F2BE
FormatPlayerNameShort	equ	$41226
Framer	equ	$38CA0
GAttribOverall	equ	$41DC0
GetGoalieCount	equ	$2ED60
GetNameandAttrib	equ	$2D56A
GetPlayerCount	equ	$2EDBC
HomeTeam	equ	$17FAE
MenuWaitVblank	equ	$2C63A
PAttribOverall	equ	$41C5E
PlayerScrollCtr	equ	$1A452
ProcessInputWithRepeat	equ	$374BE
PushNumberWidth	equ	$3919A
Satt	equ	$BBD30
SetupScreen	equ	$2E728
SortCords	equ	$17480
TeamList	equ	$1B00C
TestList	equ	$1A45A
VertLineScrolling	equ	$1A450
VisTeam	equ	$17FB0
awayshooters	equ	$1A42A
getname	equ	$4112E
getpzjoy	equ	$2F2F0
homeshooters	equ	$1A41C
homeshootgoals	equ	$1A416
homeshootnum	equ	$1A428
move	equ	$2C9C8
print	equ	$38F80
printa	equ	$18D5C
printbig	equ	$3926A
printbigz	equ	$39258
printfontset	equ	$18D60
printsmall	equ	$38D9E
printsmallz	equ	$38D8C
printx	equ	$18D58
printy	equ	$18D5A
printz	equ	$38F6E
scoutcolumn	equ	$1A44E
screentimer	equ	$1A458
shootoutdelay	equ	$1AD72
shootoutteam	equ	$1A436
tmstruct	equ	$1834C
X_CC1E	equ	$CC1E
X_CC80	equ	$CC80
X_CE44	equ	$CE44
X_CE8E	equ	$CE8E
X_CEDC	equ	$CEDC
X_CF54	equ	$CF54
X_CF86	equ	$CF86
X_CF8A	equ	$CF8A
X_D01E	equ	$D01E
X_F686	equ	$F686

	org	$C926

	movea.l	#tmstruct,a1
	movea.l	$1E(a1),a1
	adda.w	$4(a1),a1
	jsr	(print).l
	move.w	#$15,(printx).l
	move.w	(homeshootgoals).l,d0
	move.w	#$3,d1
	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l
	String	CC_Font1Pri,$4,$A
	dc.w	$227C,$0001,$86B2,$2269,$001E,$D2E9,$0004,$4EB9
	dc.w	$0003,$8F80,$33FC,$0015,$0001,$8D58,$3039,$0001
	dc.w	$A418,$323C,$0003,$4EB9,$0003,$919A,$4EB9,$0003
	dc.w	$8F80,$4EB9,$0003,$8F6E,$000A,$BF04,$0C52,$6F75
	dc.w	$6E64,$2000,$3039,$0001,$A41A,$323C,$0002,$4EB9
	dc.w	$0003,$919A,$4EB9,$0003,$8F80,$4CDF,$7FFF,$4E75
	dc.w	$0016,$BF04,$0353,$484F,$4F54,$4F55,$5420,$4D4F
	dc.w	$4445,$BF04,$0500
ClearShootout						;Clear the player structs (SortCords) and the shootout state.
	movea.l	#SortCords,a0
	move.w	#$3FF,d0
.loop	clr.w	(a0)+
	dbra	d0,.loop
	clr.w	(shootoutdelay).l
	move.w	#$1,$1A41A.l
	bclr	#$3,$17F78.l
	clr.w	(homeshootgoals).l
	clr.w	$1A418.l
	clr.w	(homeshootnum).l
	clr.w	(shootoutteam).l
	bsr.w	InitShooters
	move.w	#$1,(shootoutteam).l
	bsr.w	InitShooters
	clr.w	(shootoutteam).l
	rts
NextShooter						;Shootout: the next shooter (BA_Team, BA_Goalie_SCnum, StartShootoutPath),
									;or the end (ExitToOpening).
	btst	#$3,$17F78.l
	beq.w	.0		;shootout running?
	jmp	(ExitToOpening).l		;shootout over: back to the title
.0	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	X_F686
	move.w	(shootoutteam).l,(BA_Team).l
	move.w	#$B,(BA_Goalie_SCnum).l		;home goalie slot $B
	movea.l	#homeshooters,a0
	tst.w	(shootoutteam).l		;visitors shoot?
	beq.w	.1
	move.w	#$5,(BA_Goalie_SCnum).l		;away goalie slot 5
	movea.l	#awayshooters,a0
.1	move.w	(homeshootnum).l,d0
	add.w	d0,d0
	move.w	(a0,d0.w),$1936C.l		;this round's shooter
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
	cmp.w	$1A418.l,d0		;goals differ?
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
	dc.w	$48E7,$FFFE,$4EB9,$0003,$8F6E,$0006,$BF01,$0D00
	dc.w	$323C,$0006,$303C,$001E,$4EB9,$0003,$8CA0,$4EB9
	dc.w	$0003,$9258,$0014,$BF02,$0E53,$484F,$4F54,$4F55
	dc.w	$5420,$574F,$4E20,$4259
	addi.w	#$2,(printy).l
	move.w	(HomeTeam).l,d1
	move.w	(homeshootgoals).l,d0
	cmp.w	$1A418.l,d0
	bgt.w	.lCBAC
	move.w	(VisTeam).l,d1
.lCBAC	asl.w	#$2,d1
	movea.l	#TeamList,a1
	movea.l	(a1,d1.w),a1
	adda.w	$4(a1),a1
	move.w	#$2,(printx).l
	jsr	(printbig).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
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
	bsr.w	X_D01E
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$0,$3,$1,$0
	dc.w	$303C,$0012,$323C,$0003,$4EB9,$0003,$8CA0,$4EB9
	dc.w	$0003,$8D8C,$0006,$FD15,$FC00
	move.w	#$12,d0
	move.w	#$3,d1
	jsr	(Framer).l		;frame of the list
	jsr	(printsmallz).l
	String	CC_SetMapAndPosition,$4,$2,$2,$1,'{Select Player}'		;title
	clr.w	d0
	bra.w	.scroll
.loop2	jsr	(MenuWaitVblank).l
	jsr	(getpzjoy).l
	jsr	(ProcessInputWithRepeat).l
	btst	#$7,d1
	bne.w	X_CC1E		;start: back to the shooters
	btst	#$5,d1
	bne.w	.pick
	moveq	#$1,d0		;down / right: +1
	btst	#$1,d1
	bne.w	.scroll
	btst	#$3,d1
	bne.w	.page
	moveq	#-1,d0		;up / left: -1
	btst	#$0,d1
	bne.w	.scroll
	btst	#$2,d1
	bne.w	.page
	bra.w	.loop2
.page	add.w	(scoutcolumn).l,d0
	bmi.w	.loop2		;before the first page: ignore
	move.w	d0,(scoutcolumn).l
	bsr.w	X_CE44
	bra.w	.loop2
.scroll	add.w	(VertLineScrolling).l,d0
	bmi.w	.loop2		;above the first: ignore
	cmp.w	(screentimer).l,d0
	bgt.w	.loop2		;past the last: ignore
	move.w	d0,(VertLineScrolling).l
	cmp.w	(PlayerScrollCtr).l,d0		;above the rows shown?
	bgt.w	.8
	move.w	d0,(PlayerScrollCtr).l
.8	subi.w	#$5,d0		;6 rows shown
	cmp.w	(PlayerScrollCtr).l,d0		;below the rows shown?
	ble.w	.9
	move.w	d0,(PlayerScrollCtr).l
.9	bsr.w	X_CE44
	bra.w	.loop2
.pick	movea.l	#Satt,a3
	adda.w	(VertLineScrolling).l,a3
	clr.w	d0
	move.b	(a3),d0
	move.w	(TestList).l,d2
	movea.l	#homeshooters,a0
	cmpa.l	#$1834C,a2
	beq.w	.11
	movea.l	#awayshooters,a0
.11	asl.w	#$1,d2		;word per slot
	move.w	d0,(a0,d2.w)		;store the pick
	bra.w	X_CC1E
	dc.w	$4EB9,$0003,$8F6E,$0006,$BE16,$0100
.lCE50	movea.l	#PAttribOverall,a1
	cmpi.w	#$5,(TestList).l
	bne.w	.lCE68
	movea.l	#GAttribOverall,a1
.lCE68	move.w	(scoutcolumn).l,d0
	bra.w	.lCE78
	adda.w	(a1),a1
	adda.w	#$4,a1
.lCE78	tst.w	(a1)
	dbmi	d0,$CE72
	bpl.w	X_CE8E
	subi.w	#$1,(scoutcolumn).l
	bra.w	.lCE50
	dc.w	$B3FC,$0004,$1C5E,$6600,$0008,$227C,$0002,$7F28
	dc.w	$B3FC,$0004,$1DC0,$6600,$0008,$227C,$0002,$7F3E
	dc.w	$4EB9,$0003,$8F80,$2811,$267C,$000B,$BD30,$3439
	dc.w	$0001,$A452,$3239,$0001,$A458,$9242,$0C41,$0005
	dc.w	$6300,$0004,$7205,$33FC,$0002,$0001,$8D5A,$4EB9
	dc.w	$0003,$8D8C,$0020,$FE04,$FD05,$FA01,$2020,$2020
	dc.w	$2020,$2020,$2020,$2020,$2020,$2020,$2020,$2020
	dc.w	$2020,$FD05
	cmp.w	(VertLineScrolling).l,d2
	bne.w	.lCF12
	move.w	d7,(printa).l
.lCF12	clr.w	d0
	move.b	(a3,d2.w),d0
	jsr	(GetNameandAttrib).l
	addi.w	#$1,d2
	dbra	d1,X_CEDC
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
	bmi.w	X_CF86		;above the first?
	cmpi.w	#$5,d0		;past the 5th?
	blt.w	X_CF8A
	clr.w	d0		;wrap to the first
	bra.w	X_CF8A
	dc.w	$303C,$0004,$33C0,$0001,$A45A,$6100,$01AC,$6100
	dc.w	$0140,$6000,$FC90,$6100,$0080,$48E7,$FCE0,$4EB9
	dc.w	$0003,$8F6E,$0006,$FD00,$0000,$2279,$0004,$7D0C
	dc.w	$D3E9,$0004,$247C,$0001,$B008,$4240,$4241,$3411
	dc.w	$3629,$0002,$7801,$7A00,$4EB9,$0003,$87E2,$4CDF
	dc.w	$073F,$4EB9,$0003,$8F6E,$0006,$BE07,$0100
	moveq	#$1A,d0
	moveq	#$6,d1
	jsr	(Framer).l
	jsr	(printbigz).l
	String	CC_Font2Pri,$A,$4,'  Shootout  ',CC_Font2Pri,$F,$1
	dc.w	$4240,$B5FC,$0001,$834C,$6700,$0006,$303C,$002C
	dc.w	$4EF9,$0002,$C59E,$4EB9,$0003,$8F6E,$0006,$BE00
	dc.w	$0000,$7028,$720A,$343C,$07FF,$4EF9,$0003,$8C06
	dc.w	$4279,$000B,$BD0A,$4279,$000B,$BD2A,$4E75,$4EB9
	dc.w	$0003,$8D8C,$0008,$FF02,$FD00,$FC0A,$4EB9,$0003
	dc.w	$8D8C,$0004,$FE04,$4EB9,$0003,$8D8C,$000E,$FD07
	dc.w	$FC0C,$5368,$6F6F,$7465,$7273,$4EB9,$0003,$8D8C
	dc.w	$000A,$FD03,$FC0E,$312E,$2000,$4EB9,$0003,$8D8C
	dc.w	$000A,$FD03,$FC10,$322E,$2000,$4EB9,$0003,$8D8C
	dc.w	$000A,$FD03,$FC12,$332E,$2000,$4EB9,$0003,$8D8C
	dc.w	$000A,$FD03,$FC14,$342E,$2000,$4EB9,$0003,$8D8C
	dc.w	$000A,$FD03,$FC16,$352E,$2000,$4EB9,$0003,$8D8C
	dc.w	$000C,$FD1A,$FC0C,$476F,$616C,$6965,$4E75,$4EB9
	dc.w	$0003,$8D8C,$000A,$F804,$0208,$07F9,$0100,$7018
	dc.w	$7203,$4EB9,$0003,$8CA0,$4EB9,$0003,$8D8C,$0008
	dc.w	$FD15,$FC08,$FE06
	movea.l	#homeshooters,a1
	cmpa.l	#$1834C,a2
	beq.w	.lD114
	movea.l	#awayshooters,a1
.lD114	move.w	(TestList).l,d0
	asl.w	#$1,d0
	move.w	(a1,d0.w),d0
	jsr	(getname).l
	move.w	(a1),d0
	lsr.w	#$1,d0
	sub.w	d0,(printx).l
	jsr	(printsmall).l
	clr.w	(printfontset).l
	rts
	dc.w	$48E7,$FFFE,$4EB9,$0003,$8D8C,$0008,$FD06,$FC0E
	dc.w	$FE06
	move.w	#$0,d1
	movea.l	#homeshooters,a0
	cmpa.l	#$1834C,a2
	beq.w	.lD16A
	movea.l	#awayshooters,a0
.lD16A	move.w	d1,d0
	asl.w	#$1,d0
	move.w	(a0,d0.w),d0
	jsr	(FormatPlayerNameShort).l
	move.w	(printx).l,-(sp)
	cmp.w	(TestList).l,d1
	bne.w	.lD190
	move.w	#$2,(printfontset).l
.lD190	cmpi.w	#$5,d1
	bne.w	.lD1A8
	move.w	#$19,(printx).l
	move.w	#$E,(printy).l
.lD1A8	jsr	(printsmall).l
	clr.w	(printfontset).l
	move.w	(sp)+,(printx).l
	addi.w	#$2,(printy).l
	addi.w	#$1,d1
	cmpi.w	#$6,d1
	blt.w	.lD16A
	movem.l	(sp)+,d0-d7/a0-a6
	rts
