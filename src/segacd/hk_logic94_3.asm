	include	segacd\hockey.inc
	include	macros\genesis.mac

BA_Goalie_SCnum	equ	$1936A
LOAD	equ	$1B000
PBnum	equ	$18068
PadControlBits	equ	$17DC8
Setplass	equ	$3D754
SortCords	equ	$17480
SprSort	equ	$3F03E
fofdata2	equ	$17CF8
move	equ	$2C9C8
randomd0	equ	$37050
X_16AB6	equ	$16AB6
X_16E14	equ	$16E14
X_1B2C4	equ	$1B2C4
X_1B3C0	equ	$1B3C0

	org	$167B8

shotdiradj						;If the opposing goalie
									;covers the middle of the net, set passdir 2 or 6 to shoot at the open
									;side, else 0. Skipped for computer players (pfjoycon clear)
	dc.w	$0000,$000C
	dc.w	$0010,$000C
	dc.w	$0010,$0006
	dc.w	$0010,$0000
	dc.w	$0000,$0000
	dc.w	$FFF0
	dc.l	$FFF0
	dc.w	$0006,$FFF0
	dc.w	$000C
	dc.w	$0000,$0006
	dc.w	$082B,$0003,$0064
	dc.w	$6600,$000C
	dc.w	$082B,$0003,$0062
	dc.w	$6600,$00D8
.l167F0	dc.w	$7008
	dc.w	$7205
	dc.w	$207C,$0001,$7400
	dc.w	$082B,$0006,$0062
	dc.w	$6600,$0006
	dc.w	$D0FC,$0300
.l16808	dc.w	$D0FC,$0080
	dc.w	$4A68,$0034
	dc.w	$57C9,$FFF6
	dc.w	$6600,$008C
	dc.w	$1028,$0028
	dc.w	$4880
	dc.w	$E240
	dc.w	$D068,$0000
	dc.w	$9079,$0001,$7B80
	dc.w	$1228,$002A
	dc.w	$4881
	dc.w	$E241
	dc.w	$D268,$0014
	dc.w	$9279,$0001,$7B94
	dc.w	$48A7,$C000
	dc.w	$C1C0
	dc.w	$C3C1
	dc.w	$D081
	dc.w	$5280
	dc.w	$6100,$5844
	dc.w	$3400
	dc.w	$4C9F,$0003
	dc.w	$7612
	dc.w	$383C,$0108
	dc.w	$082B,$0007,$0062
	dc.w	$6600,$0004
	dc.w	$4444
.l16864	dc.w	$48A7,$1800
	dc.w	$6100,$005E
	dc.w	$3A04
	dc.w	$4C9F,$0018
	dc.w	$4443
	dc.w	$6100,$0052
	dc.w	$D845
	dc.w	$4240
	dc.w	$0C44,$002C
	dc.w	$6E00,$0020
	dc.w	$0C44,$FFD4
	dc.w	$6D00,$0018
	dc.w	$082B,$0007,$0062
	dc.w	$6700,$0004
	dc.w	$4444
.l16898	dc.w	$7002
	dc.w	$4A44
	dc.w	$6A00,$0004
	dc.w	$7006
.l168A2	dc.w	$33C0,$0001,$7E2C
	dc.w	$0839,$0002,$0001,$7F70
	dc.w	$6600,$000E
	dc.w	$0839,$0000,$0001,$7F78
	dc.w	$6700,$0008
.l168C0	dc.w	$4EB9,$0002,$A648
.l168C6	dc.w	$4E75
.l168C8	dc.w	$9679,$0001,$7B80
	dc.w	$9879,$0001,$7B94
	dc.w	$C9C0
	dc.w	$C7C1
	dc.w	$9883
	dc.w	$89C2
	dc.w	$4E75
setpads						;Put SCnum of a3 in the d4 nibble of PadControlBits ; d4 = -2 puck
									;carrier, 0 / 2 pads, 4 replay target. Falls into rtss3
	movem.l	d0-d1,-(sp)
	moveq	#$2,d0
	add.w	d4,d0
	add.w	d0,d0
	move.w	#$FFF0,d1
	rol.w	d0,d1
	and.w	d1,(PadControlBits).l
	move.w	$52(a3),d1
	asl.w	d0,d1
	or.w	d1,(PadControlBits).l
	movem.l	(sp)+,d0-d1
rtss3						;shared rts for the early exits nearby
	rts
	btst	#$2,$17F70.l
	bne.w	rtss3
	btst	#$3,$62(a3)
	bne.w	rtss3
	dc.w	$082B,$0004,$0063,$6600,$FFE0,$4A2B,$0060,$6A00
	dc.w	$000A,$4A2B,$0061,$6B00,$FFD0,$102B,$0061,$B02B
	dc.w	$0066,$6700,$0032,$302B,$0036,$0C33,$000B,$0038
	dc.w	$6700,$FFB6,$302B,$0052,$B079,$0001,$7BE0,$6700
	dc.w	$FFA8,$DEFC,$0004,$08EB,$0002,$0063,$426B,$0040
	dc.w	$700B,$6000,$4974,$DEFC,$0004,$08AB,$0002,$0063
	dc.w	$08AB,$0002,$0062,$50EB,$0061,$50EB,$0060,$302B
	dc.w	$0034,$4A2B,$0060,$6A00,$0008,$4EF9,$0003,$D754
	dc.w	$102B,$0060,$4880,$3740,$0034,$4EF9,$0003,$D754
	dc.w	$082B,$0005,$0062,$6600,$FF50,$0C6B,$0064,$0040
	dc.w	$6700,$00FA,$6100,$FF44,$082B,$0004,$0063,$6600
	dc.w	$48F8,$08AB,$0001,$0062,$6700,$002E,$377C,$0008
	dc.w	$0042,$7050,$082B,$0006,$0062,$6600,$0004,$4440
	dc.w	$3740,$0046,$377C,$0088,$0044,$446B,$0044,$046B
	dc.w	$0008,$0044,$426B,$0040,$102B,$0061,$B02B,$0066
	dc.w	$6700,$00FA,$9F6B,$0040,$6A00,$00D6,$066B,$0008
	dc.w	$0040,$302B,$0014,$906B,$0046,$0C40,$0028,$6E00
	dc.w	$00C0,$0C40,$FFD8,$6D00,$00B8,$302B,$0000,$906B
	dc.w	$0044,$0C40,$0020,$6E00,$00A8,$323C,$050C,$4A6B
	dc.w	$0034,$6600,$0006,$323C,$0002,$6100,$4968,$08EB
	dc.w	$0002,$0062,$0C6B,$0004,$0054,$6700,$000E,$066B
	dc.w	$0001,$0054,$026B,$0007,$0054,$426B,$002A,$377C
	dc.w	$F800,$0028,$0C40,$0010,$6E00,$0030,$426B,$0028
	dc.w	$0C6B,$0004,$0054,$6600,$0022,$377C,$F800,$0028
	dc.w	$377C,$0002,$0054,$323C,$0FAC,$6100,$4918,$08EB
	dc.w	$0005,$0062,$377C,$0064,$0040,$4E75,$426B,$0006
	dc.w	$4240,$102B,$0066,$D040,$207C,$0001,$834C,$082B
	dc.w	$0006,$0062,$6700,$0006,$D0FC,$0366,$31BC,$FFFE
	dc.w	$0068,$162B,$0061,$6100,$002A,$4EF9,$0003,$D770
	dc.w	$082B,$0002,$0062,$6600,$FFC2,$302B,$0044,$322B
	dc.w	$0046,$207C,$0003,$3C6E,$6000,$4502
rtss4						;shared rts for the early exits nearby
	bclr	#$2,$63(a3)
	move.b	$60(a3),d0
	ext.w	d0
	move.w	d0,$34(a3)
	jsr	(Setplass).l
	st.b	$61(a3)
	dc.w	$50EB,$0060,$4E75,$082B,$0005,$0062,$6600,$FF86
	dc.w	$08AB,$0001,$0062,$6700,$0040,$426B,$0028,$426B
	dc.w	$002A,$302B,$0052,$0440,$0006,$6B00,$0006,$0640
	dc.w	$0001,$C1FC,$000E,$3740,$0014,$377C,$0088,$0000
	dc.w	$446B,$0000,$377C,$0002,$0054,$08EB,$0005,$0062
	dc.w	$323C,$0F6E,$6000,$4848,$377C,$0004,$0054,$08AB
	dc.w	$0002,$0062,$08AB,$0005,$0063,$08AB,$0002,$0063
	dc.w	$426B,$0058,$377C,$1000,$0028,$6000,$4726,$082B
	dc.w	$0005,$0062,$6600,$FF0E,$08AB,$0001,$0062,$6700
	dc.w	$005C,$08EB,$0002,$0063,$6100,$0106,$78FE,$6100
	dc.w	$FD1C,$377C,$0008,$0042,$700B,$1239,$0001,$8068
	dc.w	$082B,$0006,$0062,$6600,$0006,$E849,$4440,$0241
	dc.w	$000F,$0C41,$0002,$6300,$0004,$7202,$5641,$C3C0
	dc.w	$3741,$0046,$377C,$0088,$0044,$426B,$0040,$08EB
	dc.w	$0005,$0063,$426B,$004E,$426B,$0050,$302B,$0014
	dc.w	$906B,$0046,$0C40,$000C,$6E00,$0094,$0C40,$FFF4
	dc.w	$6D00,$008C,$302B,$0000,$906B,$0044,$0C40,$FFE8
	dc.w	$6D00,$007C,$9F6B,$0040,$6A00,$FE7A,$066B,$0008
	dc.w	$0040,$08EB,$0002,$0062,$323C,$050C,$6100,$4770
	dc.w	$7406,$4A2B,$0076,$6700,$0004,$7402,$B46B,$0054
	dc.w	$6700,$000E,$066B,$0001,$0054,$026B,$0007,$0054
	dc.w	$426B,$002A,$377C,$1000,$0028,$0C40,$FFF8,$6D00
	dc.w	$FE34,$426B,$0028,$B46B,$0054,$6600,$FE28,$08EB
	dc.w	$0005,$0062,$377C,$0002,$0054,$323C,$0F6E,$6100
	dc.w	$471E,$08AB,$0004,$0063,$700D,$6000,$4636,$302B
	dc.w	$0044,$322B,$0046,$207C,$0003,$1AB6,$6000,$4348
	dc.w	$082B,$0003,$0062,$6700,$FDEC,$4244,$302B,$0052
	dc.w	$B079,$0001,$7F9E,$6700,$F5CA,$7802,$6000,$F5C4
assdopen						;add player a3 to penalty box
	btst	#$5,$62(a3)
	bne.w	X_16AB6
	moveq	#$10,d0
	btst	#$6,$62(a3)
	beq.w	.1
	moveq	#$1,d0
.1	add.b	d0,(PBnum).l		;Players in penalty box
	st.b	$34(a3)
	clr.w	$6(a3)
	rts
assepen						;player a3 should exit penalty area
	btst	#$5,$62(a3)
	bne.w	X_16AB6
	bclr	#$1,$62(a3)
	beq.w	.nna
	bset	#$2,$62(a3)		;set player in no collision mode
	bset	#$2,$63(a3)		;set player unavailable
	moveq	#$10,d0
	moveq	#-60,d1
	btst	#$6,$62(a3)
	beq.w	.0
	moveq	#$1,d0
	neg.w	d1
.0	sub.b	d0,(PBnum).l		;Players in penalty box
	move.w	d1,$14(a3)
	clr.w	$28(a3)
	clr.w	$2A(a3)
	move.w	#$86,$0(a3)
	move.w	#$2,$54(a3)
	bset	#$5,$62(a3)
	move.w	#$FAC,d1
	bsr.w	X_1B3C0
	jmp	(SprSort).l
.nna	move.w	#$4,$54(a3)
	st.b	$61(a3)
	st.b	$60(a3)
	bclr	#$3,$62(a3)
	bclr	#$2,$62(a3)
	bclr	#$5,$63(a3)		;pf2npc
	bclr	#$2,$63(a3)		;pf2unav
	move.w	#$F000,$28(a3)
	bra.w	X_1B2C4
assgoaliebreakwait						;asstab entry. In a shootout or penalty shot park the idle goalie off the
									;ice, else exit
	btst	#$5,$62(a3)		;check if animation locked
	bne.w	.exit		;exit if so
	btst	#$2,$17F70.l		;check if pen shot
	bne.w	.park		;branch if so
	btst	#$0,$17F78.l		;check for shootout
	bne.w	.park		;branch if so
	nop
	bra.w	X_1B2C4
.park	clr.w	$28(a3)		;clear Xvel
	clr.w	$2A(a3)		;clear Yvel
	movem.l	d0/a0,-(sp)		;push d0 and a0 on stack
	movea.l	#SortCords,a0		;Home SC Sctruct start
	move.w	(BA_Goalie_SCnum).l,d0		;move Goalie SCNum into d0
	asl.w	#$7,d0		;shift d0 7 bits left
	adda.w	d0,a0		;add d0 to address a0
	move.w	#$191,$14(a3)		;move 401 decimal into Ypos
	btst	#$7,$62(a0)		;check if shooting up or down (a0 is goalie being shot on)
	bne.w	.popstack		;branch if shooting up
	move.w	#$FE6F,$14(a3)		;move -191 decimal into Ypos (goalie not being shot on)
.popstack	movem.l	(sp)+,d0/a0
.exit	rts
assfaceoff						;players do nothing until faceoff is over
	btst	#$5,$62(a3)
	bne.w	.exit
	btst	#$0,$17F6C.l
	beq.w	X_1B2C4
.exit	rts
assfaceoffpl						;Face off player
	btst	#$5,$62(a3)
	bne.w	X_16E14
	btst	#$0,$17F6C.l
	beq.w	.exit
	bclr	#$1,$62(a3)
	beq.w	.nna
	clr.w	$40(a3)
.nna	movea.l	#fofdata2,a0		;a0 = fofdata2 (home) or +4 (visitor): big faceoff sprite data
	btst	#$6,$62(a3)
	beq.w	.0
	adda.w	#$4,a0
.0	move.w	$5A(a3),d0		;d0 = SPAnum/4 + 1, +3 for right handed: frame code for the big sprite
	lsr.w	#$2,d0
	addi.w	#$1,d0
	tst.b	$76(a3)
	bne.w	.lefty
	addi.w	#$3,d0
.lefty	move.w	d0,(a0)
	btst	#$3,$62(a3)
	bne.w	X_16AB6
	bset	#$1,$63(a3)
	bne.w	X_16AB6
	move.w	#$FEA,d1
	cmpi.w	#$10,$17BC0.l
	bls.w	.d
	moveq	#$8,d0
	bsr.w	randomd0-LOAD
	tst.w	d0
	beq.w	.d
	move.w	#$1014,d1
.d	bset	#$1,$63(a3)
	bra.w	X_1B3C0
.exit	move.b	#$14,$5E(a3)
	bra.w	X_1B2C4
	rts
assfwatch						;rts only: there is no fighting
	rts
	btst	#$5,$62(a3)
	bne.w	X_16AB6
	btst	#$3,$62(a3)
	bne.w	X_16AB6
	moveq	#$8,d0
	dc.w	$6000,$450C,$082B,$0005,$0062,$6600,$FBE2,$08AB
	dc.w	$0001,$0062,$6700,$0026,$377C,$005A,$0044,$4A79
	dc.w	$0001,$7CEE,$6A00,$0006,$446B,$0044,$3779,$0001
	dc.w	$7CEA,$0046,$323C,$109E,$6100,$44BE,$302B,$0044
	dc.w	$906B,$0000,$322B,$0046,$926B,$0014,$6100,$43E2
	dc.w	$0C40,$0007,$6E00,$FB98,$3400,$3742,$0054,$6000
	dc.w	$4950,$082B,$0005,$0062,$6600,$FB84,$08AB,$0001
	dc.w	$0062,$6700,$0028,$6100,$009A,$377C,$0008,$0042
	dc.w	$377C,$005A,$0044,$4A79,$0001,$7CEE,$6A00,$0006
	dc.w	$446B,$0044,$3779,$0001,$7CEA,$0046,$207C,$0003
	dc.w	$1AB6,$302B,$0044,$322B,$0046,$0839,$0000,$0001
	dc.w	$7F78,$6700,$0036,$4A79,$0001,$AD72,$6700,$0016
	dc.w	$0479,$0001,$0001,$AD72,$6600,$000A,$08F9,$0002
	dc.w	$0001,$7F6C,$0C6B,$0088,$0000,$6E00,$000C,$0C6B
	dc.w	$FF78,$0000,$6E00,$0004,$4241,$9F6B,$0040,$6A00
	dc.w	$002E,$08EB,$0005,$0062,$323C,$0E8A,$3039,$0001
	dc.w	$7E28,$B06B,$0052,$6600,$0006,$323C,$0EFC,$6100
	dc.w	$43E8,$7078,$6100,$5072,$3740,$0040,$4E75
