	include	segacd\hockey.inc
	include	macros\genesis.mac

BlankValueTxt	equ	$23EA0
FourWayPlay	equ	$18BF8
GameSetUpMap	equ	$47D74
LogoBoxMap	equ	$47D7C
NewYorkITxt	equ	$23E7A
NewYorkRTxt	equ	$23E8E
OldVcount	equ	$17476
OptNOP	equ	$18BFC
OptPlayMode	equ	$18BFA
OptionNames	equ	$242B4
PlayerCardTimer	equ	$24B7C
ProcessInputWithRepeat	equ	$374BE
ReadJoy1	equ	$374F0
ReadJoy2	equ	$3750E
ReadJoy3	equ	$3752C
ReadJoy4	equ	$3754A
ResetCardTimer	equ	$24B5E
ScoutSubStatus	equ	$17474
TeamList	equ	$1B00C
TeamLogoBitmaps	equ	$47D8C
TeamLogoPalettes	equ	$2AF56
UpdateRosterPlayers	equ	$24894
dobitmap	equ	$387E2
homepicchars	equ	$19392
logoteam	equ	$1938A
move	equ	$2C9C8
palcount	equ	$18D62
print	equ	$38F80
printa	equ	$18D5C
printm	equ	$18D5E
printsmall	equ	$38D9E
printx	equ	$18D58
printy	equ	$18D5A
setupfirstline	equ	$19384
setuphome	equ	$1938C
setupvis	equ	$1938E
sflags6	equ	$17F76
vispicchars	equ	$19394
X_9962	equ	$9962
X_99C6	equ	$99C6

	org	$8E20

PrintOptTeamName						;Print team name d3 of option d7 (TeamList city; the full name of the
									;two New York teams, $D / $E).
									;PrintOptionValue
	move.w	(printx).l,-(sp)
	movea.l	#BlankValueTxt,a1
	jsr	(print).l
	move.w	(sp)+,(printx).l
	movea.l	#OptPlayMode,a1
	move.w	(a1,d7.w),d3
	movea.l	#TeamList,a1
	asl.w	#$2,d3
	movea.l	(a1,d3.w),a1
	lsr.w	#$2,d3
	adda.w	$4(a1),a1
	cmpi.w	#$E,d3		;NYR?
	bne.w	.0
	movea.l	#NewYorkRTxt,a1		;full name
	bra.w	.1		;print
.0	cmpi.w	#$D,d3		;NYI?
	bne.w	.1
	movea.l	#NewYorkITxt,a1		;full name
.1	jmp	(print).l
	dc.w	$0014,$4E65,$7720,$596F,$726B,$2049,$736C,$616E
	dc.w	$6465,$7273,$0012,$4E65,$7720,$596F,$726B,$2052
	dc.w	$616E,$6765,$7273,$0016,$2020,$2020,$2020,$2020
	dc.w	$2020,$2020,$2020,$2020,$2020,$2020,$0016,$4E2F
	dc.w	$4120,$2020,$2020,$2020,$2020,$2020,$2020,$2020
	dc.w	$2020,$0012,$0080,$02FE,$02FE,$0238,$0290,$02FE
	dc.w	$02BC,$032A,$0016,$5265,$6775,$6C61,$7220,$5365
	dc.w	$6173,$6F6E,$2020,$2020,$2020,$0016,$436F,$6E74
	dc.w	$696E,$7565,$2050,$6C61,$796F,$6666,$7320,$2020
	dc.w	$0016,$4E65,$7720,$506C,$6179,$6F66,$6673,$2020
	dc.w	$2020,$2020,$2020,$0016,$4E65,$7720,$506C,$6179
	dc.w	$6F66,$6673,$2F37,$2067,$616D,$6520,$0016,$5368
	dc.w	$6F6F,$746F,$7574,$2020,$2020,$2020,$2020,$2020
	dc.w	$2020,$0016,$4465,$6D6F,$2020,$2020,$2020,$2020
	dc.w	$2020,$2020,$2020,$2020,$0016,$4F6E,$6520,$2D20
	dc.w	$486F,$6D65,$2020,$2020,$2020,$2020,$2020,$0016
	dc.w	$4F6E,$6520,$2D20,$5669,$7369,$746F,$7220,$2020
	dc.w	$2020,$2020,$0016,$5477,$6F20,$2D20,$5465,$616D
	dc.w	$6D61,$7465,$7320,$2020,$2020,$0016,$5477,$6F20
	dc.w	$2D20,$4865,$6164,$2074,$6F20,$4865,$6164,$2020
	dc.w	$0016,$5477,$6F20,$2D20,$4865,$6164,$2074,$6F20
	dc.w	$4865,$6164,$2020,$0016,$5477,$6F20,$2D20,$5465
	dc.w	$616D,$6D61,$7465,$7320,$2020,$2020,$0016,$4F6E
	dc.w	$6520,$2020,$2020,$2020,$2020,$2020,$2020,$2020
	dc.w	$2020,$0016,$4465,$6D6F,$2020,$2020,$2020,$2020
	dc.w	$2020,$2020,$2020,$2020,$0016,$4F6E,$6520,$2D20
	dc.w	$486F,$6D65,$2020,$2020,$2020,$2020,$2020,$0016
	dc.w	$4F6E,$6520,$2D20,$5669,$7369,$746F,$7220,$2020
	dc.w	$2020,$2020,$0016,$5477,$6F20,$2D20,$5465,$616D
	dc.w	$6D61,$7465,$7320,$2020,$2020,$0016,$5477,$6F20
	dc.w	$2D20,$4865,$6164,$2074,$6F20,$4865,$6164,$2020
	dc.w	$0016,$5468,$7265,$6520,$2020,$2020,$2020,$2020
	dc.w	$2020,$2020,$2020,$0016,$466F,$7572,$2020,$2020
	dc.w	$2020,$2020,$2020,$2020,$2020,$2020,$0016,$5477
	dc.w	$6F20,$2D20,$4865,$6164,$2074,$6F20,$4865,$6164
	dc.w	$2020,$0016,$5477,$6F20,$2D20,$5465,$616D,$6D61
	dc.w	$7465,$7320,$2020,$2020,$0016,$5468,$7265,$6520
	dc.w	$2020,$2020,$2020,$2020,$2020,$2020,$2020,$0016
	dc.w	$466F,$7572,$2020,$2020,$2020,$2020,$2020,$2020
	dc.w	$2020,$2020,$0016,$4F6E,$6520,$2020,$2020,$2020
	dc.w	$2020,$2020,$2020,$2020,$2020,$0016,$3520,$4D69
	dc.w	$6E75,$7465,$7320,$2020,$2020,$2020,$2020,$2020
	dc.w	$0016,$3130,$204D,$696E,$7574,$6573,$2020,$2020
	dc.w	$2020,$2020,$2020,$0016,$3230,$204D,$696E,$7574
	dc.w	$6573,$2020,$2020,$2020,$2020,$2020,$0016,$3330
	dc.w	$2053,$6563,$6F6E,$6473,$2020,$2020,$2020,$2020
	dc.w	$2020,$0016,$4D61,$6E75,$616C,$2043,$6F6E,$7472
	dc.w	$6F6C,$2020,$2020,$2020,$0016,$4175,$746F,$2043
	dc.w	$6F6E,$7472,$6F6C,$2020,$2020,$2020,$2020,$0016
	dc.w	$4F66,$6620,$2020,$2020,$2020,$2020,$2020,$2020
	dc.w	$2020,$2020,$0016,$4F6E,$2020,$2020,$2020,$2020
	dc.w	$2020,$2020,$2020,$2020,$2020,$0016,$4F6E,$2C20
	dc.w	$4578,$6365,$7074,$204F,$6666,$2D73,$6964,$6573
	dc.w	$0016,$4F6E,$2020,$2020,$2020,$2020,$2020,$2020
	dc.w	$2020,$2020,$2020,$0016,$4F66,$6620,$2020,$2020
	dc.w	$2020,$2020,$2020,$2020,$2020,$2020,$0016,$4F6E
	dc.w	$2020,$2020,$2020,$2020,$2020,$2020,$2020,$2020
	dc.w	$2020,$0016,$4F66,$6620,$2020,$2020,$2020,$2020
	dc.w	$2020,$2020,$2020,$2020,$0016,$4175,$746F,$2020
	dc.w	$2020,$2020,$2020,$2020,$2020,$2020,$2020
PrintOptionNames						;Print the option names from OptionNames at x 3, 2 rows apart from row $F
									;- setupfirstline * 2, rows $F-$19 only.
									;from
									;GameSetUp and FixModeOptions
	movem.l	d0-d1,-(sp)
	bset	#$3,(sflags6).l		;print all
	movea.l	#OptionNames,a1
	move.w	#$F,d0
	move.w	(setupfirstline).l,d1
	add.w	d1,d1		;2 rows a line
	sub.w	d1,d0
	move.w	d0,(printy).l
.loop	cmpi.w	#$F,(printy).l		;above the menu?
	bge.w	.0
	adda.w	(a1),a1
	bra.w	.1
.0	cmpi.w	#$19,(printy).l		;past row $19?
	bgt.w	.done
	move.w	#$3,(printx).l
	move.w	#$0,(printa).l
	move.w	#$0,(printm).l
	jsr	(printsmall).l		;print it
.1	addi.w	#$2,(printy).l		;2 rows on
	bra.w	.loop
.done	bclr	#$3,(sflags6).l		;normal
	movem.l	(sp)+,d0-d1
	rts
	dc.w	$0010,$506C,$6179,$204D,$6F64,$6520,$2020,$2000
	dc.w	$0010,$506C,$6179,$6572,$7320,$2020,$2020,$2000
	dc.w	$0010,$5465,$616D,$2031,$2020,$2020,$2020,$2000
	dc.w	$0010,$5465,$616D,$2032,$2020,$2020,$2020,$2000
	dc.w	$0010,$5065,$722E,$204C,$656E,$6774,$6820,$2000
	dc.w	$0010,$476F,$616C,$6965,$7320,$2020,$2020,$2000
	dc.w	$0010,$5573,$6572,$2052,$6563,$6F72,$6473,$2000
	dc.w	$0010,$5065,$6E61,$6C74,$6965,$7320,$2020,$2000
	dc.w	$0010,$4C69,$6E65,$2043,$6861,$6E67,$6573,$2000
	dc.w	$0004,$0000,$23FC,$0004,$00D0,$0001,$8D66,$08F9
	dc.w	$0005,$00FF,$800F,$08B9,$0000,$0001,$8D64,$08F9
	dc.w	$0002,$0001,$8D64,$08B9,$0001,$0001,$8D64,$33FC
	dc.w	$0000,$0001,$8D30,$33FC,$B400,$0001,$8D32,$33FC
	dc.w	$B800,$0001,$8D3C,$33FC,$0005,$0001,$8D3E,$33FC
	dc.w	$C000,$0001,$8D38,$33FC,$0006,$0001,$8D3A,$33FC
	dc.w	$E000,$0001,$8D34,$33FC,$0006,$0001,$8D36,$203C
	dc.w	$0000,$0000,$4EB9,$0003,$7B5A,$4EB9,$0003,$7460
	dc.w	$4EB9,$0002,$4866,$33C4,$0001,$8D4E,$2479,$0004
	dc.w	$7D78,$508A,$4EB9,$0003,$8946,$0356,$7564,$89AB
	dc.w	$CDEF,$33C4,$0001,$8D42,$2479,$0004,$7D3C,$508A
	dc.w	$4EB9,$0003,$8946,$0FC0,$4567,$89AB,$CDEF,$33C4
	dc.w	$0001,$7EA2,$2479,$0004,$7D70,$508A,$4EB9,$0003
	dc.w	$8946,$0123,$4567,$89AB,$CDEF,$4EB9,$0003,$8F6E
	dc.w	$0006,$FF00,$0000,$7028,$721C,$343C,$07FF,$4EB9
	dc.w	$0003,$8C06,$4EB9,$0003,$8F6E,$0006,$FE00,$0000
	dc.w	$2079,$0004,$7D00,$2248,$2448,$D1DA,$D3DA,$4240
	dc.w	$4241,$7428,$761C,$7A0D,$4EB9,$0003,$87E2,$33C4
	dc.w	$0001,$9394,$0644,$0024,$4EB9,$0003,$8F6E,$0006
	dc.w	$FF00,$0000,$2079,$0004,$7D04,$2248,$2448,$D1DA
	dc.w	$D3DA,$4240,$4241,$7428,$7604,$7A00,$4EB9,$0003
	dc.w	$87E2,$4EB9,$0003,$8F6E,$0006,$FF01,$0E00,$33C4
	dc.w	$0001,$9388
	movea.l	(GameSetUpMap).l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$26,d2
	moveq	#$D,d3
	moveq	#$0,d5
	jsr	(dobitmap).l
	move.w	d4,(homepicchars).l
	addi.w	#$24,d4
	move.w	d4,$19398.l
	movea.l	(LogoBoxMap).l,a2
	dc.w	$508A,$4EB9,$0003,$8958,$33C4,$0001,$939A,$2479
	dc.w	$0004,$7D7C,$508A,$4EB9,$0003,$8946,$0341,$4567
	dc.w	$89AB,$CDEF,$4EB9,$0003,$EE84,$33FC,$0028,$0001
	dc.w	$749C,$33FC,$0028,$0001,$779C,$50F9,$0001,$834C
	dc.w	$50F9,$0001,$86B2,$4E75
ReadSetupPads						;wait up to $5460 frames (6 minutes) for a press on any pad (4 with
									;FourWayPlay); return d1 = the presses, 0 on timeout. C does not return:
									;it sets setupcardflags bit 5 (next player card sooner). When only one
									;logo is shown (after a player card) redraws the team blocks. For the
									;first $E10 frames of the wait, and while a card is up, runs the player
									;cards (PlayerCardTimer), else resets their timer (ResetCardTimer). Called
									;from GameSetUp
	move.l	#$5460,d6
.loop	move.w	(ScoutSubStatus).l,d1		;frame count
	sub.w	(OldVcount).l,d1		;changed?
	beq.w	.loop
	move.w	(ScoutSubStatus).l,(OldVcount).l		;new frame count
	bclr	#$5,$19390.l		;no press yet
	jsr	(UpdateRosterPlayers).l
	jsr	(ReadJoy1).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1		;any press?
	beq.w	.1
	btst	#$5,d1		;C?
	beq.w	.l965E		;another button: return
	btst	#$5,d2		;C?
	beq.w	.0
	move.w	#$53,$1939E.l
.0	bset	#$5,$19390.l
.1	jsr	(ReadJoy2).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1		;any press?
	beq.w	.2
	btst	#$5,d1		;C?
	beq.w	.l965E		;no: return the press
	bset	#$5,$19390.l		;press seen
.2	tst.w	(FourWayPlay).l		;four way?
	beq.w	.4
	jsr	(ReadJoy3).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1		;any press?
	beq.w	.3
	btst	#$5,d1		;C?
	beq.w	.l965E		;no: return the press
	bset	#$5,$19390.l		;press seen
.3	jsr	(ReadJoy4).l
	jsr	(ProcessInputWithRepeat).l
	tst.w	d1		;any press?
	beq.w	.4
	btst	#$5,d1		;C?
	beq.w	.l965E		;no: return the press
	bset	#$5,$19390.l		;press seen
.4	btst	#$6,$19390.l		;visitors block flagged?
	beq.w	.5
	btst	#$7,$19390.l		;home flagged too?
	bne.w	.6
	move.w	(setupvis).l,(logoteam).l
	bsr.w	X_99C6
.5	btst	#$7,$19390.l		;home block flagged?
	beq.w	.6
	move.w	(setuphome).l,(logoteam).l
	bsr.w	X_9962
.6	cmpi.l	#$4650,d6		;the first $E10 frames (a minute)?
	bgt.w	.timer
	btst	#$0,$19390.l		;card up?
	bne.w	.timer
	jsr	(ResetCardTimer).l		;restart the card timer
	bra.w	.l965A
.timer	jsr	(PlayerCardTimer).l
.l965A	dbra	d6,.loop
.l965E	rts
	dc.w	$4279,$0001,$8C16,$0839,$0007,$00FF,$800E,$66F6
	dc.w	$33FC,$001B,$00FF,$8020,$08F9,$0006,$00FF,$800F
	dc.w	$0839,$0006,$00FF,$800E,$67F6,$33F9,$00FF,$8010
	dc.w	$0001,$8C18,$08F9,$0007,$00FF,$800F,$08B9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9
	dc.w	$0007,$00FF,$800F,$0839,$0007,$00FF,$800E,$66F6
	dc.w	$33FC,$001B,$00FF,$8020,$08F9,$0006,$00FF,$800F
	dc.w	$0839,$0006,$00FF,$800E,$67F6,$33F9,$00FF,$8010
	dc.w	$0001,$8C1A,$08F9,$0007,$00FF,$800F,$08B9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9
	dc.w	$0007,$00FF,$800F,$4279,$0001,$8BFA,$4279,$0001
	dc.w	$8BFC,$4279,$0001,$8C0A,$33FC,$0001,$0001,$8C08
	dc.w	$3F39,$0001,$8C04,$33D7,$0001,$8C0C,$33DF,$0001
	dc.w	$8C0E,$4EB9,$0003,$FF16,$0839,$0007,$00FF,$800E
	dc.w	$66F6,$33FC,$001B,$00FF,$8020,$08F9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$67F6,$33F9,$00FF
	dc.w	$8010,$0001,$8C18,$08F9,$0007,$00FF,$800F,$08B9
	dc.w	$0006,$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6
	dc.w	$08B9,$0007,$00FF,$800F,$0839,$0007,$00FF,$800E
	dc.w	$66F6,$33FC,$001B,$00FF,$8020,$08F9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$67F6,$33F9,$00FF
	dc.w	$8010,$0001,$8C1A,$08F9,$0007,$00FF,$800F,$08B9
	dc.w	$0006,$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6
	dc.w	$08B9,$0007,$00FF,$800F,$33F9,$0001,$8C0A,$0001
	dc.w	$8C22,$0C79,$0002,$0001,$8C0A,$6600,$0010,$4279
	dc.w	$0001,$8C0A,$08F9,$0004,$0001,$7F7A,$33F9,$0001
	dc.w	$8BFA,$0001,$8C24,$0C79,$0004,$0001,$8BFA,$6600
	dc.w	$0018,$33FC,$0000,$0001,$8BFA,$08F9,$0000,$0001
	dc.w	$7F78,$4EB9,$0002,$79DA,$4EF9,$0004,$0244
CheckNOPUnused						;unreferenced. Tests OptNOP for 0, 5, 6, 9 and $A and returns: no effect
	tst.w	(OptNOP).l		;0?
	beq.w	.x
	cmpi.w	#$5,(OptNOP).l		;5?
	beq.w	.x
	cmpi.w	#$6,(OptNOP).l		;6?
	beq.w	.x
	cmpi.w	#$9,(OptNOP).l		;9?
	beq.w	.x
	cmpi.w	#$A,(OptNOP).l		;$A?
.x	rts
	dc.w	$7802,$2479,$0004,$7D48,$508A,$4EB9,$0003,$8958
	dc.w	$33C4,$0001,$939C,$2479,$0004,$7D48,$508A,$4EB9
	dc.w	$0003,$8946,$0341,$2567,$89AB,$CDEF,$4E75,$4E75
	dc.w	$4E75,$48E7,$FF00,$08B9,$0000,$0001,$9390,$6700
	dc.w	$00B6,$08B9,$0006,$0001,$9390,$08B9,$0007,$0001
	dc.w	$9390,$4EB9,$0003,$8F6E,$0006,$EF00,$0000,$33FC
	dc.w	$0005,$0001,$8D5A,$7008,$7208,$343C,$07FF,$0839
	dc.w	$0001,$0001,$9390,$6700,$0042,$33FC,$0003,$0001
	dc.w	$8D58,$4EB9,$0003,$8C06,$4EB9,$0003,$8F6E,$0006
	dc.w	$FF00,$0000,$33FC,$000B,$0001,$8D58,$33FC,$0005
	dc.w	$0001,$8D5A,$303C,$0019,$323C,$0008,$343C,$07FF
	dc.w	$4EB9,$0003,$8C06,$6000,$003E,$33FC,$001C,$0001
	dc.w	$8D58,$4EB9,$0003,$8C06,$4EB9,$0003,$8F6E,$0006
	dc.w	$FF00,$0000,$33FC,$0003,$0001,$8D58,$33FC,$0005
	dc.w	$0001,$8D5A,$303C,$0019,$323C,$0008,$343C,$07FF
	dc.w	$4EB9,$0003,$8C06,$4CDF,$00FF,$4E75,$48E7,$FFFE
	dc.w	$6100,$FF30,$08F9,$0002,$0001,$9390,$08F9,$0006
	dc.w	$0001,$9390,$6100,$016C,$08B9,$0003,$0001,$9390
	dc.w	$6700,$0026,$4EB9,$0003,$8F6E,$0006,$EF00,$0000
	dc.w	$33FC,$0008,$0001,$8D58,$33FC,$0005,$0001,$8D5A
	dc.w	$7008,$7208,$343C,$07FF,$4EB9,$0003,$8F6E,$0006
	dc.w	$FF00,$0000,$33FC,$0019,$0001,$8D58,$6000,$0062
	dc.w	$48E7,$FFFE,$6100,$FECC,$08F9,$0003,$0001,$9390
	dc.w	$08F9,$0007,$0001,$9390,$6100,$012C,$08B9,$0002
	dc.w	$0001,$9390,$6700,$0026,$4EB9,$0003,$8F6E,$0006
	dc.w	$EF00,$0000,$33FC,$0018,$0001,$8D58,$33FC,$0005
	dc.w	$0001,$8D5A,$7008,$7208,$343C,$07FF,$4EB9,$0003
	dc.w	$8F6E,$0006,$CF00,$0000,$33FC,$0009,$0001,$8D58
DrawTeamLogo						;Draw the logo of team logoteam at printx, y 6, 6 x 6, palette
									;TeamLogoPalettes + team * 8 - $20 (home, color fam
									;2) or - $40 (visitors, color fam 3), then wait $B4 frames before a player
									;card (carddelay). Branched to
									;from DrawHomeBlock
	move.w	#$B4,$193A2.l
	move.w	#$6,(printy).l
	move.w	(homepicchars).l,d4
	btst	#$2,$19390.l		;home?
	bne.w	.0
	move.w	(vispicchars).l,d4
.0	move.w	(logoteam).l,d3
	asl.w	#$2,d3
	movea.l	(TeamLogoBitmaps).l,a0
	movea.l	(a0,d3.w),a0		;its logo
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0		;skip the palette offset
	asl.w	#$3,d3		;32 bytes per team
	movea.l	#TeamLogoPalettes,a0
	btst	#$2,$19390.l		;home?
	beq.w	.1
	subi.w	#$20,d3
	bra.w	.2
.1	subi.w	#$40,d3
.2	adda.w	d3,a0
	adda.l	(a2)+,a1
	move.w	#$6,d3
	move.w	#$6,d2
	clr.w	d0
	clr.w	d1
	move.l	$BBCD2.l,-(sp)
	move.l	$BBCD6.l,-(sp)
	move.w	#$4,d5
	btst	#$2,$19390.l		;home?
	beq.w	.draw
	move.w	#$2,d5
.draw	jsr	(dobitmap).l
	move.l	(sp)+,$BBCD6.l
	move.l	(sp)+,$BBCD2.l
	move.w	#$64,(palcount).l		;fade in
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.w	$3839,$0001,$9398,$33FC,$001C,$0001,$8D58,$6000
	dc.w	$0034,$3839,$0001,$9398,$33FC,$0018,$0001,$8D58
	dc.w	$6000,$0022,$3839,$0001,$939A,$33FC,$0003,$0001
	dc.w	$8D58,$6000,$0010,$3839,$0001,$939A,$33FC,$0008
	dc.w	$0001,$8D58
DrawLogoBox						;Draw the LogoBoxMap box at printx, y 5 (sflags6 bit 0 set). Branched to
									;from LogoBoxRight ... LogoBoxVis
	clr.w	(printa).l
	move.w	#$5,(printy).l
	movea.l	(LogoBoxMap).l,a0		;logo box map
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1		;a1 = map data
	move.w	#$8,d3
	move.w	#$8,d2
	clr.w	d0
	clr.w	d1
	move.w	#$0,d5		;no palette lines
	bset	#$0,(sflags6).l
	jsr	(dobitmap).l
	bclr	#$0,(sflags6).l		;normal maps
	rts
	dc.w	$33FC,$00AA,$0001,$939E,$0839,$0005,$0001,$9390
	dc.w	$6700,$000A,$33FC,$0053,$0001,$939E,$4E75
