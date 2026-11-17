	include	segacd\hockey.inc
	include	macros\genesis.mac

BA_Goalie_SCnum	equ	$1936A
BA_Team	equ	$19366
ChooseSong	equ	$2A478
HmTeam	equ	$1A56C
HomeTeam	equ	$17FAE
LOAD	equ	$1B000
NextShooter	equ	$27A30
PuckOnAttackHalf	equ	$22CA4
SelectPenaltyShotSkater	equ	$34666
SongIndex	equ	$1A56E
SongNum	equ	$1A56A
SortCords	equ	$17480
StartShootoutPath	equ	$2A686
assreplace	equ	$362E4
awtmstruct	equ	$186B2
cont1team	equ	$17FA6
cont2team	equ	$17FA8
homeshootnum	equ	$1A428
inputjoy	equ	$1AD7A
move	equ	$2C9C8
onetimerplayer	equ	$17EBC
passmodetimer	equ	$17F9A
puckc	equ	$17BE0
puckvx	equ	$17BA8
puckvy	equ	$17BAA
randomd0	equ	$37050
sflags6	equ	$17F76
shootoutclock	equ	$193B6
shootoutteam	equ	$1A436
song	equ	$371D2
tmstruct	equ	$1834C
X_163CA	equ	$163CA
X_1644C	equ	$1644C
X_16AB6	equ	$16AB6
X_16EB2	equ	$16EB2
X_19C28	equ	$19C28
X_1A08E	equ	$1A08E
X_1B2C4	equ	$1B2C4
X_1B2E4	equ	$1B2E4
X_1EA56	equ	$1EA56

	org	$18DDC

	dc.w	$302B,$0052,$B079,$0001,$7BE0,$6700,$0014,$08AB
	dc.w	$0001,$0064,$303C,$0011,$6100,$24EE,$6000,$000C
	dc.w	$4EB9,$0003,$32DE,$6B00,$FFE6,$08B9,$0002,$0001
	dc.w	$7F74,$6600,$0008,$08AB,$0001,$0064,$302B,$0052
	dc.w	$B079,$0001,$7BE0,$6600,$002E,$082B,$0001,$0064
	dc.w	$6600,$0024,$0839,$0002,$0001,$7F70,$6600,$0018
	dc.w	$4EB9,$0003,$334E,$6700,$000E,$303C,$0022,$6100
	dc.w	$2498,$6000,$0002,$08AB,$0001,$0062,$6700,$0062
	dc.w	$082B,$0001,$0064,$6700,$000C,$3F3C,$0002,$4EB9
	dc.w	$0003,$710C,$082B,$0001,$0064,$6700,$0036,$48E7
	dc.w	$0020,$247C,$0001,$834C,$082B,$0006,$0062,$6700
	dc.w	$0008,$247C,$0001,$86B2,$066A,$0001,$035A,$0679
	dc.w	$0014,$0001,$7CD8,$0679,$00C8,$0001,$7CD2,$4CDF
	dc.w	$0400,$426B,$0044,$377C,$0008,$0042,$426B,$0040
	dc.w	$322B,$0052,$B279,$0001,$7BE0,$6600,$0018,$4A6B
	dc.w	$0034,$6700,$EA56,$7010,$082B,$0003,$0062,$6700
	dc.w	$23FC,$4E75,$9F2B,$0040,$6A00,$01B0,$176B,$006A
	dc.w	$0040,$4EB9,$0002,$AEDC,$6B00,$0016,$0839,$0006
	dc.w	$0001,$7F7A,$6700,$0010,$4A2B,$0040,$6700,$0008
	dc.w	$042B,$0001,$0040,$0839,$0005,$0001,$7F76,$6700
	dc.w	$003E,$3239,$0001,$7BE0,$0C41,$0005,$6E00,$0026
	dc.w	$082B,$0006,$0062,$6700,$0026,$122B,$0040,$4881
	dc.w	$E241,$1741,$0040,$6600,$0016,$177C,$0001,$0040
	dc.w	$6000,$000C,$082B,$0006,$0062,$6700,$FFDE,$42AA
	dc.w	$002C,$3239,$0001,$7BE0,$6B00,$001E,$EF41,$227C
	dc.w	$0001,$7480,$D2C1,$1029,$0062,$122B,$0062,$B101
	dc.w	$0801,$0006,$6700,$0082,$74FF,$7805,$206A,$0022
	dc.w	$4A68,$0034,$6F00,$0060,$4A28,$005E,$6600,$0058
	dc.w	$0828,$0002,$0063,$6600,$004E,$3028,$0036,$0C30
	dc.w	$0013,$0038,$6700,$0040,$2F08,$6100,$23AA,$D068
	dc.w	$0000,$9079,$0001,$7B80,$D268,$0014,$9279,$0001
	dc.w	$7B94,$3639,$0001,$7BA8,$EC43,$9043,$3639,$0001
	dc.w	$7BAA,$EC43,$9243,$C1C0,$C3C1,$D081,$B082,$6200
	dc.w	$0006,$2400,$2248,$D0FC,$0080,$51CC,$FF94,$4A82
	dc.w	$6B00,$0040,$2542,$002C,$B7C9,$6700,$0036,$0839
	dc.w	$0000,$0001,$7F68,$6600,$002A,$0829,$0002,$0063
	dc.w	$6600,$0020,$0829,$0003,$0064,$6600,$0016,$C34B
	dc.w	$08AB,$0000,$0062,$7011,$6100,$22A2,$C34B,$6000
	dc.w	$2288,$082B,$0005,$0062,$6600,$DA70,$7202,$0C42
	dc.w	$0190,$6200,$0010,$0441,$0002,$0C6B,$0002,$0034
	dc.w	$6300,$0038,$0839,$0005,$0001,$7F6C,$6700,$0012
	dc.w	$0441,$0002,$6100,$F856,$6600,$0006,$0641,$0004
	dc.w	$7028,$902B,$0075,$E360,$6100,$2FCA,$0C40,$0002
	dc.w	$6200,$0008,$377C,$00F0,$0044,$082B,$0005,$0062
	dc.w	$6600,$DA18,$0839,$0002,$0001,$7F70,$6700,$000E
	dc.w	$0839,$0005,$0001,$7F70,$6700,$000E,$0839,$0000
	dc.w	$0001,$7F68,$6600,$DDF0,$082B,$0003,$0062,$6600
	dc.w	$D9EA,$082A,$0002,$0032,$6600,$0018,$4A79,$0001
	dc.w	$7BE0,$6B00,$0146,$9F6B,$0044,$6A00,$013E,$426B
	dc.w	$0044,$6100,$2100,$48A7,$C000,$4440,$4441,$0641
	dc.w	$00F4,$082B,$0007,$0062,$6700,$0006,$0441,$01E8
	dc.w	$E240,$E241,$D05F,$D25F,$082A,$0002,$0032,$6700
	dc.w	$0028,$082B,$0007,$0062,$6700,$0012,$0C41,$0053
	dc.w	$6D00,$0016,$323C,$0044,$6000,$000E,$0C41,$FFAD
	dc.w	$6E00,$0006,$323C,$FFBC,$0839,$0005,$0001,$7F76
	dc.w	$6700,$0054,$13EB,$0069,$0001,$7E6E,$062B,$0006
	dc.w	$0069,$0839,$0001,$0001,$7F7C,$6600,$000E,$0839
	dc.w	$0006,$0001,$7F7A,$6700,$0008,$062B,$0002,$0069
	dc.w	$0C2B,$001E,$0069,$6F00,$0008,$177C,$001E,$0069
	dc.w	$41F9,$0003,$41EE,$6100,$1E74,$1779,$0001,$7E6E
	dc.w	$0069,$6000,$000C,$41F9,$0003,$41EE,$6100,$1E5E
	dc.w	$0839,$0005,$0001,$7F76,$6700,$003A,$3039,$0001
	dc.w	$7B94,$342B,$0014,$4A40,$6A00,$0006,$4440,$4442
	dc.w	$9440,$0C42,$000A,$6D00,$001A,$302B,$0000,$9079
	dc.w	$0001,$7B80,$6A00,$0004,$4440,$0C40,$000F,$6D00
	dc.w	$0004,$4E75,$0839,$0005,$0001,$7F76,$6700,$0030
	dc.w	$102B,$0075,$4880,$48E7,$8010,$D000,$0C00,$001E
	dc.w	$6D00,$0006,$103C,$001E,$1740,$0075,$6100,$0010
	dc.w	$4CDF,$0801,$1740,$0075,$4E75,$6100,$1FEA,$4A6B
	dc.w	$0034,$6600,$0004,$4E75,$303C,$0028,$902B,$0075
	dc.w	$4A79,$0001,$8C08,$6700,$0004,$E340,$6100,$2E06
	dc.w	$0C40,$0006,$6200,$D864,$7405,$207C,$0001,$7480
	dc.w	$0C6B,$0006,$0052,$6C00,$0006,$D0FC,$0300,$4A68
	dc.w	$0034,$6700,$00B6,$0828,$0005,$0062,$6600,$00AC
	dc.w	$0828,$0000,$0063,$6600,$00A2,$3028,$0000,$906B
	dc.w	$0000,$0C40,$001E,$6E00,$0092,$0C40,$FFE2,$6D00
	dc.w	$008A,$3228,$0014,$926B,$0014,$0C41,$001E,$6E00
	dc.w	$007A,$0C41,$FFE2,$6D00,$0072,$6100,$2040,$B06B
	dc.w	$0054,$6600,$0066,$0839,$0005,$0001,$7F76,$6600
	dc.w	$CB7E,$0839,$0007,$00FF,$800E,$66F6,$33FC,$001B
	dc.w	$00FF,$8020,$08F9,$0006,$00FF,$800F,$0839,$0006
	dc.w	$00FF,$800E,$67F6,$3039,$00FF,$8010,$08F9,$0007
	dc.w	$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839,$0006
	dc.w	$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F,$0240
	dc.w	$0003,$6600,$CAB2,$6000,$CB26,$D0FC,$0080,$51CA
	dc.w	$FF3E,$4E75
asspassrec						;assignment for catching a pass (apassrec)
	btst	#$5,$62(a3)		;pfalock - animation lock
	bne.w	X_16AB6		;exit if locked
	btst	#$0,$17F68.l		;gmclock - check if clock running
	bne.w	X_16EB2		;exit if clock stopped
	btst	#$3,$62(a3)		;pfjoycon - joystick controlled?
	bne.w	X_1B2C4		;exit if controlled
	bclr	#$1,$62(a3)		;#pfna - clear new assignment
	beq.w	.nna
	bset	#$0,$62(a3)		;#pfdoff - set decceleration off
	move.b	#$8,$43(a3)		;move into temp2+1
	clr.b	$42(a3)		;clear temp2 byte
	move.w	#$FFFE,$46(a3)		;move into temp4
.nna	tst.w	(puckc).l		;check if there is a puck carrier
	bpl.w	.exit		;exit if puck still in possession
	addi.w	#$1,$46(a3)		;add to temp4
	beq.w	.0		;branch if temp4 is zero
	bpl.w	.ex2		;branch if temp4 is positive
.0	tst.w	(onetimerplayer).l
	bpl.w	.ex2
	tst.w	$34(a3)		;test if goalie
	beq.w	.ex2		;exit if goalie
	move.w	d0,-(sp)		;push d0 on stack
	clr.w	$46(a3)		;clear temp4
	move.w	#$1,d0
	btst	#$6,$62(a3)		;check if home or away
	beq.w	.1
	move.w	#$2,d0		;away team
.1	cmp.w	(cont1team).l,d0		;check if player on cont 1 team
	beq.w	.pop		;branch if so
	cmp.w	(cont2team).l,d0		;check if player on cont 2 team
	beq.w	.pop		;branch if so
	jsr	(PuckOnAttackHalf).l
	beq.w	.pop
	move.w	$14(a3),d0		;Ypos
	btst	#$7,$62(a3)		;pfgoal
	bne.w	.chkpos		;branch if shooting at top
	neg.w	d0
.chkpos	cmpi.w	#$58,d0		;blueline
	blt.w	.nozone
	cmpi.w	#$108,d0		;goalline
	bgt.w	.nozone
	bra.w	.atkzone
.nozone	move.w	#$8,d0		;outside of attack zone
	jsr	(randomd0).l
	tst.w	d0		;check if d0 is zero
	bne.w	.pop
.atkzone	move.w	(sp)+,d0
	move.w	#$FFFF,(inputjoy).l
	move.w	#$23,d0		;assonetimer
	jmp	(assreplace).l
.pop	move.w	(sp)+,d0
.ex2	sub.b	d7,$40(a3)
	bpl.w	X_16AB6
.exit	bclr	#$0,$62(a3)
	bra.w	X_1B2C4
	dc.w	$302B,$0044,$322B,$0046,$41FA,$7BCA,$6000,$1BCE
assshoot						;assignment for computer shooting. Assignment ashoot ($12)
	btst	#$5,$62(a3)		;pfalock - animation locked
	bne.w	X_16AB6
	bclr	#$1,$62(a3)		;clear pfna
	beq.w	.nna
	bra.w	X_163CA		;first frame: start the shot (temp2 = swing time set by CompShoot)
.nna	btst	#$3,$17F6A.l		;#sfssdir
	beq.w	X_1B2C4		;no: the shot is done
	clr.w	d2
	sub.w	d7,$42(a3)		;count the swing time down
	bpl.w	X_1644C		;still swinging: feed ShotMode no buttons
	bset	#$5,d2		;#cbut
	bra.w	X_1644C		;swing time over: press the shot button (cbut)
puckshootout						;puck logic for the shootout: on a new assignment clear the pads and
									;select the skater, then run the attempt
	bclr	#$1,$62(a3)
	beq.w	.selectskater
	bset	#$7,$17F7A.l
	clr.l	$17DCA.l
	clr.l	$17DCE.l
	clr.l	$17DD2.l
	bclr	#$7,$17F78.l
	btst	#$0,$17F78.l
	beq.w	.startattempt
	jsr	(NextShooter).l
	bra.w	.initflags
.startattempt	jsr	(StartShootoutPath).l
	move.l	a2,-(sp)
	movea.l	#tmstruct,a2
	tst.w	(BA_Team).l
	beq.w	.countattempt
	movea.l	#awtmstruct,a2
.countattempt	addi.w	#$1,$362(a2)
	movea.l	(sp)+,a2
.initflags	bclr	#$2,$17F70.l
	bclr	#$4,$17F70.l
	bclr	#$5,$17F70.l
	bclr	#$6,$17F70.l
	bset	#$1,(sflags6).l
	btst	#$3,$17F68.l
	bne.w	X_1EA56
	bclr	#$1,$62(a3)
	btst	#$0,$17F78.l
	beq.w	.selectsong
	tst.w	(shootoutteam).l
	bne.w	.setstopped
	tst.w	(homeshootnum).l
	bne.w	.setstopped
	move.w	(HomeTeam).l,(HmTeam).l
	move.w	#$2,(SongIndex).l
	jsr	(ChooseSong).l
	move.w	(SongNum).l,-(sp)
	bra.w	.playsong
.selectsong	move.w	(HomeTeam).l,(HmTeam).l
	move.w	#$2,(SongIndex).l
	jsr	(ChooseSong).l
	move.w	(SongNum).l,-(sp)
.playsong	bsr.w	song-LOAD
.setstopped	bset	#$0,$17F68.l
	bset	#$1,$17F78.l
	clr.w	(puckvx).l
	clr.w	(puckvy).l
	move.w	#$19,(shootoutclock).l
	bsr.w	X_1A08E
	st.b	$40(a3)
	st.b	$42(a3)
.selectskater	bset	#$2,$17F70.l
	movem.w	d1-d2,-(sp)
	jsr	(SelectPenaltyShotSkater).l
	bmi.w	.noeligible
	movem.w	(sp)+,d1-d2
	bra.w	.checkgoalie
.noeligible	movem.w	(sp)+,d1-d2
	bclr	#$2,$17F70.l
	move.w	#$1B,d0		;puckfaceoff
	bsr.w	X_1B2E4
	rts
.checkgoalie	movem.w	d1-d2,-(sp)
	move.w	(BA_Goalie_SCnum).l,d0
	movea.l	#SortCords,a2
	asl.w	#$7,d0
	adda.w	d0,a2
	tst.w	$34(a2)
	bne.w	.findgoalie
	btst	#$2,$63(a2)
	beq.w	.startpenshot
.findgoalie	move.w	(BA_Goalie_SCnum).l,d0
	move.w	#$6,d2
.goalieloop	subi.w	#$1,d2
	bmi.w	.noeligible
	subi.w	#$1,d0
	bpl.w	.wraphome
	move.w	#$5,d0
	bra.w	.checkcandidate
.wraphome	cmpi.w	#$5,d0
	bne.w	.checkcandidate
	move.w	#$B,d0
.checkcandidate	movea.l	#SortCords,a2
	move.w	d0,d1
	asl.w	#$7,d1
	adda.w	d1,a2
	tst.w	$34(a2)
	bne.w	.goalieloop
	btst	#$2,$63(a2)
	bne.w	.goalieloop
	move.w	d0,(BA_Goalie_SCnum).l
.startpenshot	movem.w	(sp)+,d1-d2
	movea.l	#tmstruct,a2
	move.w	#$1F,d0		;puckpenshot
	bra.w	X_1B2E4
	dc.w	$48E7,$FFFE,$207C,$0001,$834C,$4A79,$0001,$9366
	dc.w	$6700,$0008,$207C,$0001,$86B2,$323C,$0000,$3C3C
	dc.w	$FFFF,$3A3C,$FFFF,$2468,$001E,$D4EA,$0000,$0C52
	dc.w	$0002,$6700,$00CE,$D4D2,$3E01,$E347,$102A,$0005
	dc.w	$0240,$000F,$0C00,$0001,$6F00,$00A6,$0839,$0000
	dc.w	$0001,$7F78,$6600,$00B8,$0C70,$FFFE,$7068,$6700
	dc.w	$000C,$0C70,$FFFF,$7068,$6600,$0086,$4243,$4240
	dc.w	$102A,$0001,$0240,$000F,$D640,$102A,$0002,$0240
	dc.w	$000F,$D640,$102A,$0002,$0240,$00F0,$E848,$D640
	dc.w	$102A,$0003,$0240,$000F,$D640,$102A,$0003,$0240
	dc.w	$00F0,$E848,$D640,$102A,$0005,$0240,$000F,$D640
	dc.w	$102A,$0005,$0240,$00F0,$E848,$D640,$102A,$0006
	dc.w	$0240,$00F0,$E848,$D640,$102A,$0007,$0240,$00F0
	dc.w	$E848,$D640,$B279,$0001,$936C,$6600,$0006,$363C
	dc.w	$7FFF,$B646,$6D00,$000A,$3C03,$3A01,$6000,$0002
	dc.w	$D5FC,$0000,$0008,$0641,$0001,$0C41,$001A,$6D00
	dc.w	$FF2E,$4A45,$6B00,$003C,$33C5,$0001,$936C,$33FC
	dc.w	$0000,$0001,$9368,$4A79,$0001,$9366,$6700,$000A
	dc.w	$33FC,$0006,$0001,$9368,$3039,$0001,$9368,$EF40
	dc.w	$267C,$0001,$7480,$D6C0,$3639,$0001,$936C,$6000
	dc.w	$000A,$303C,$FFFF,$6000,$0006,$303C,$0001,$4CDF
	dc.w	$7FFF,$4E75,$08AB,$0001,$0062,$6700,$0390,$48E7
	dc.w	$FFFE,$6100,$2540,$0839,$0000,$0001,$8D64,$6600
	dc.w	$FFF6,$0C79,$0258,$0001,$7CD2,$6300,$0012,$33FC
	dc.w	$0258,$0001,$7CD2,$0679,$0014,$0001,$7CD8,$3839
	dc.w	$0001,$8D56,$2479,$0004,$7D1C,$508A,$4EB9,$0003
	dc.w	$8958,$08F9,$0003,$0001,$8D64,$08B9,$0000,$0001
	dc.w	$7F6A,$08B9,$0000,$0001,$7F6E,$4279,$0001,$7E32
	dc.w	$4239,$0001,$7ECE,$50F9,$0001,$806E,$08B9,$0001
	dc.w	$0001,$7F6C,$50F9,$0001,$7E30,$6100,$7B6A,$4279
	dc.w	$0001,$7CEA,$4279,$0001,$7CEE,$33FC,$0000,$0001
	dc.w	$7B80,$33FC,$0000,$0001,$7B94,$4279,$0001,$7B98
	dc.w	$4279,$0001,$7BA8,$4279,$0001,$7BAA,$4279,$0001
	dc.w	$7BAC,$50F9,$0001,$7BE0,$207C,$0001,$7A80,$4268
	dc.w	$0028,$4268,$002A,$4268,$0000,$317C,$010C,$0014
	dc.w	$D0FC,$0080,$4268,$0028,$4268,$002A,$4268,$0000
	dc.w	$317C,$FEF4,$0014,$207C,$0001,$7C00,$317C,$018A
	dc.w	$0006,$4268,$0058,$4268,$0004,$4279,$0001,$7B84
	dc.w	$08B9,$0006,$0001,$7F6A,$7864,$6100,$B7E0,$51CC
	dc.w	$FFFA,$33FC,$003C,$0001,$7EE0,$4EB9,$0003,$D6E2
	dc.w	$247C,$0001,$834C,$4EB9,$0003,$D426,$4EB9,$0003
	dc.w	$D5E4,$D5FC,$0000,$0366,$4EB9,$0003,$D426,$4EB9
	dc.w	$0003,$D5E4,$4EB9,$0003,$F0C6,$2F0B,$267C,$0001
	dc.w	$7A00,$343C,$000B,$B479,$0001,$9368,$6700,$0026
	dc.w	$B479,$0001,$936A,$6700,$00A2,$377C,$FF10,$0000
	dc.w	$426B,$0014,$426B,$0006,$303C,$0020,$6100,$1994
	dc.w	$6000,$0142,$4A6B,$0034,$6A00,$002E,$08AB,$0002
	dc.w	$0063,$6700,$0024,$48E7,$FFFE,$4243,$162B,$0066
	dc.w	$4EB9,$0003,$D770,$4CDF,$7FFF,$4A6B,$0034,$6700
	dc.w	$0006,$6A00,$0004,$4E71,$3039,$0001,$7B80,$0440
	dc.w	$0000,$3740,$0000,$3039,$0001,$7B94,$082B,$0007
	dc.w	$0062,$6600,$0010,$0640,$0010,$377C,$0004,$0054
	dc.w	$6000,$000C,$0640,$FFF0,$377C,$0000,$0054,$3740
	dc.w	$0014,$426B,$0028,$426B,$002A,$426B,$002C,$303C
	dc.w	$0011,$6100,$190E,$6000,$00BC,$0839,$0000,$0001
	dc.w	$7F78,$6700,$0020,$1779,$0001,$A435,$0066,$4A79
	dc.w	$0001,$A436,$6700,$0020,$1779,$0001,$A427,$0066
	dc.w	$6000,$0014,$4A6B,$0034,$6A00,$002E,$08AB,$0002
	dc.w	$0063,$6700,$0024,$48E7,$FFFE,$4243,$162B,$0066
	dc.w	$4EB9,$0003,$D770,$4CDF,$7FFF,$4A6B,$0034,$6600
	dc.w	$0006,$6A00,$0004,$4E71,$08AB,$0002,$0063,$303C
	dc.w	$0000,$323C,$00E5,$082B,$0007,$0062,$6600,$0006
	dc.w	$323C,$FF1B,$3740,$0000,$3741,$0014,$426B,$0028
	dc.w	$426B,$002A,$426B,$0018,$9079,$0001,$7B80,$9279
	dc.w	$0001,$7B94,$4440,$4441,$6100,$1888,$3740,$0054
	dc.w	$08AB,$0002,$0063,$08AB,$0005,$0062,$323C,$050C
	dc.w	$6100,$1938,$97FC,$0000,$0080,$51CA,$FE8A,$4EB9
	dc.w	$0003,$F03E,$265F,$6100,$0CFA,$3039,$0001,$936A
	dc.w	$EF40,$267C,$0001,$7480,$D6C0,$377C,$0000,$0000
	dc.w	$377C,$FF06,$0014,$082B,$0007,$0062,$6600,$0008
	dc.w	$377C,$00FA,$0014,$3039,$0001,$936A,$323C,$0001
	dc.w	$082B,$0006,$0062,$6700,$0006,$323C,$0002,$B279
	dc.w	$0001,$7FA6,$6600,$000C,$4EB9,$0003,$12B8,$6000
	dc.w	$0012,$B279,$0001,$7FA8,$6600,$0008,$4EB9,$0003
	dc.w	$12DC,$303C,$000E,$6100,$17D6,$08F9,$0007,$0001
	dc.w	$7F70,$08F9,$0002,$0001,$7F6C,$33FC,$0190,$0001
	dc.w	$7F98,$4A79,$0001,$7FA6,$6600,$0014,$4A79,$0001
	dc.w	$7FA8,$6600,$000A,$33FC,$0064,$0001,$7F98,$33FC
	dc.w	$0018,$0001,$8D62,$4CDF,$7FFF,$4E75,$08F9,$0002
	dc.w	$0001,$7F78,$303C,$0018,$6100,$1784,$426B,$0028
	dc.w	$426B,$002A,$4E75,$0001,$0203,$0405,$0600,$0001
	dc.w	$0503,$0402,$0000,$0003,$0501,$0400,$0000,$0000
	dc.w	$FF06,$FFDD,$FFCE,$0023,$FFCE,$FFCE,$FFF6,$0000
	dc.w	$FFF1,$0032,$FFF6,$0000,$FFC4
UpdatePenaltyShotEnd						;end the penalty shot when the goalie has the puck, the puck is loose or
									;the timer runs out
	movem.w	d0,-(sp)
	move.w	(puckc).l,d0
	cmp.w	(BA_Goalie_SCnum).l,d0
	movem.w	(sp)+,d0
	beq.w	.setended
	btst	#$5,$17F70.l
	beq.w	.checktimer
	btst	#$5,$17F78.l
	bne.w	.puckloose
	tst.w	(puckc).l
	bpl.w	.countdown
	bset	#$5,$17F78.l
.puckloose	tst.w	(puckc).l
	bpl.w	.setended
.countdown	tst.w	(passmodetimer).l
	bmi.w	.setended
	subq.w	#$1,(passmodetimer).l
	bra.w	.checktimer
.setended	bset	#$4,$17F70.l
.checktimer	tst.w	(shootoutclock).l
	bne.w	.checkended
	bset	#$4,$17F70.l
.checkended	btst	#$4,$17F70.l
	bne.w	X_19C28
	rts
	dc.w	$0839,$0006,$0001,$7F70,$6600,$0092,$08F9,$0006
	dc.w	$0001,$7F70,$303C,$000A,$4EB9,$0003,$9456
