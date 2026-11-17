	include	segacd\hockey.inc
	include	macros\genesis.mac

CC_Font2Pri	equ	$BE
CrowdSprites	equ	$47D2C
Crowdframe	equ	$17CD0
FaceOffSprites	equ	$47D30
Hpos	equ	$17CEE
Hscroll	equ	$17CF0
Oldrow	equ	$17CEC
PBnum	equ	$18068
RevRinkTilelist	equ	$47D64
Rinktilelist	equ	$47D18
SmallFontMap	equ	$47D3C
SortCords	equ	$17480
VmMAP1	equ	$18D34
VmMAP2	equ	$18D38
Vpos	equ	$17CEA
Vscroll	equ	$17CF2
clockram	equ	$17ED4
crowdvrcset	equ	$18D4A
disflags	equ	$18D64
faceoffvrcset	equ	$18D4C
fodropx	equ	$1746C
fodropy	equ	$1746E
fofdata2	equ	$17CF8
gameclock	equ	$180E6
move	equ	$2C9C8
printx	equ	$18D58
printz	equ	$38F6E
shootoutclock	equ	$193B6
smallfontchars	equ	$18D42
swap	equ	$2779A
tmstruct	equ	$1834C
X_21000	equ	$21000
X_23214	equ	$23214
X_2321A	equ	$2321A
X_23260	equ	$23260
X_2329C	equ	$2329C
X_23566	equ	$23566
X_23684	equ	$23684
X_236B4	equ	$236B4
X_236BC	equ	$236BC

	org	$226E2

ResetBench
	clr.b	(PBnum).l
	moveq	#$10,d1
	movea.l	#tmstruct,a0
	bsr.w	.l226FA
	moveq	#$1,d1
	adda.w	#$366,a0
.l226FA	moveq	#$32,d0
.l226FC	add.b	d1,(PBnum).l
	tst.w	$68(a0,d0.w)
	ble.w	.l2272A
	btst	#$4,$68(a0,d0.w)
	beq.w	.l2274A
	move.w	$68(a0,d0.w),d2
	andi.w	#$7FF,d2
	bne.w	.l2274A
	sub.b	d1,(PBnum).l
	bra.w	.l2274A
.l2272A	sub.b	d1,(PBnum).l
	cmpi.w	#$FFFD,$68(a0,d0.w)
	beq.w	.l2274A
	cmpi.w	#$FFFC,$68(a0,d0.w)
	beq.w	.l2274A
	move.w	#$FFFE,$68(a0,d0.w)
.l2274A	subi.w	#$2,d0
	bpl.w	.l226FC
	rts
	dc.w	$302B,$0034,$6B00,$E8A6,$41FA,$000A,$1030,$0000
	dc.w	$6000,$8B7E,$0E02,$0203,$0503,$0500,$08AB,$0006
	dc.w	$0063,$207C,$0001,$834C,$082B,$0006,$0062,$6700
	dc.w	$0006,$D0FC,$0366,$1743,$0066,$700A,$4883,$D643
	dc.w	$3230,$3068,$6A00,$000C,$7009,$0C41,$FFFE,$6600
	dc.w	$0010,$6100,$8B30,$08AB,$0005,$0062,$426B,$0058
	dc.w	$31BC,$FFFF,$3068,$E24B,$2068,$001E,$2F08,$D0E8
	dc.w	$0008,$42B9,$0001,$8AE0,$4A6B,$0034,$6700,$00A6
	dc.w	$0839,$0005,$0001,$7F6C,$6700,$002E,$4EB9,$0003
	dc.w	$38C8,$6700,$0016,$13E8,$0001,$0001,$8AE0,$0239
	dc.w	$000F,$0001,$8AE0,$6000,$0010,$1028,$0001,$E808
	dc.w	$4400,$13C0,$0001,$8AE1,$1028,$0002,$0200,$000F
	dc.w	$4400,$082B,$0006,$0062,$6600,$0008,$1028,$0002
	dc.w	$E808,$13C0,$0001,$8AE3,$0C79,$0002,$0001,$80E4
	dc.w	$6D00,$0042,$6E00,$0014,$4EB9,$0002,$BA04,$E248
	dc.w	$B079,$0001,$80E6,$6E00,$002C,$3039,$0001,$8358
	dc.w	$9079,$0001,$86BE,$6700,$0014,$082B,$0006,$0062
	dc.w	$6700,$0006,$0A3C,$0008,$6A00,$000A,$13FC,$0002
	dc.w	$0001,$8AE2,$205F,$D0E8,$0000,$D0D0,$D0FC,$0008
	dc.w	$51CB,$FFF8,$90FC,$0008,$1750,$006F,$1628,$0001
	dc.w	$0243,$00F0,$E24B,$1743,$0067,$1628,$0001,$0203
	dc.w	$000F,$33FC,$0003,$0001,$7E64,$4EB9,$0002,$30D0
	dc.w	$1743,$0068,$1628,$0002,$E80B,$33FC,$0004,$0001
	dc.w	$7E64,$4EB9,$0002,$30D0,$1743,$0069,$1628,$0002
	dc.w	$0203,$000F,$33FC,$0005,$0001,$7E64,$4EB9,$0002
	dc.w	$30D0,$D639,$0001,$8AE0,$D639,$0001,$8AE1,$D639
	dc.w	$0001,$8AE3,$D639,$0001,$8AE2,$6100,$01A2,$E20B
	dc.w	$0A03,$000F,$0603,$000F,$E20B,$1743,$006A,$1628
	dc.w	$0003,$E80B,$33FC,$0006,$0001,$7E64,$4EB9,$0002
	dc.w	$30D0,$D639,$0001,$8AE3,$6100,$0174,$E20B,$0A03
	dc.w	$000F,$0603,$000F,$E20B,$1743,$006B,$1768,$0003
	dc.w	$006C,$022B,$000F,$006C,$162B,$006C,$33FC,$0007
	dc.w	$0001,$7E64,$4EB9,$0002,$30D0,$1743,$006C,$1628
	dc.w	$0004,$E80B,$33FC,$0008,$0001,$7E64,$4EB9,$0002
	dc.w	$30D0,$D639,$0001,$8AE2,$6100,$0124,$1743,$0075
	dc.w	$08AB,$0003,$0004,$1768,$0004,$0076,$022B,$0001
	dc.w	$0076,$0A2B,$0001,$0076,$6600,$0008,$08EB,$0003
	dc.w	$0004,$1768,$0004,$0074,$022B,$000E,$0074,$1628
	dc.w	$0005,$E80B,$33FC,$000A,$0001,$7E64,$4EB9,$0002
	dc.w	$30D0,$D639,$0001,$8AE0,$D639,$0001,$8AE1,$D639
	dc.w	$0001,$8AE3,$6100,$00C8,$1743,$0071,$1628,$0005
	dc.w	$0203,$000F,$33FC,$000B,$0001,$7E64,$4EB9,$0002
	dc.w	$30D0,$D639,$0001,$8AE0,$D639,$0001,$8AE1,$D639
	dc.w	$0001,$8AE3,$6100,$0098,$1743,$006D,$1628,$0006
	dc.w	$E80B,$33FC,$000C,$0001,$7E64,$4EB9,$0002,$30D0
	dc.w	$1743,$0072,$1628,$0006,$0203,$000F,$33FC,$000D
	dc.w	$0001,$7E64,$4EB9,$0002,$30D0,$D639,$0001,$8AE2
	dc.w	$D639,$0001,$8AE2,$6100,$0056,$1743,$0070,$1628
	dc.w	$0007,$E80B,$33FC,$000E,$0001,$7E64,$4EB9,$0002
	dc.w	$30D0,$D639,$0001,$8AE0,$D639,$0001,$8AE3,$6100
	dc.w	$002E,$1743,$006E,$1768,$0007,$0073,$162B,$0073
	dc.w	$0203,$000F,$33FC,$000F,$0001,$7E64,$4EB9,$0002
	dc.w	$30D0,$1743,$0073,$022B,$000F,$0073,$4E75,$4A03
	dc.w	$6A00,$0004,$4243,$0C03,$001E,$6F00,$0006,$363C
	dc.w	$001E,$4E75,$48E7,$FFFE,$0839,$0002,$0001,$8D64
	dc.w	$6600,$0016,$08B9,$0000,$0001,$8D64,$6700,$0006
	dc.w	$6100,$00DA,$6100,$931C,$0839,$0000,$0001,$7F6A
	dc.w	$6600,$006A,$0839,$0002,$0001,$7F78,$6600,$000E
	dc.w	$0839,$0000,$0001,$7F68,$6600,$0052,$0839,$0001
	dc.w	$0001,$7F78,$6600,$0052,$4A79,$0001,$80E6,$6700
	dc.w	$003C,$0479,$0AAA,$0001,$80E8,$6400,$0030,$08F9
	dc.w	$0003,$0001,$8D64,$5379,$0001,$80E6,$0C79,$003D
	dc.w	$0001,$80E6,$6E00,$0016,$0C79,$003C,$0001,$80E6
	dc.w	$6D00,$000A,$3F3C,$0002,$6100,$9626,$5279,$0001
	dc.w	$7474,$4CDF,$7FFF,$4E75,$4A79,$0001,$93B6,$6700
	dc.w	$FFEC,$0479,$0AAA,$0001,$93B8,$6400,$FFE0,$08F9
	dc.w	$0003,$0001,$8D64,$0839,$0007,$0001,$7F78,$6600
	dc.w	$FFCC,$5379,$0001,$93B6,$6000,$FFC2,$48E7,$FFFE
	dc.w	$0839,$0002,$0001,$8D64,$6600,$0006,$6100,$9254
	dc.w	$5279,$0001,$7474,$4CDF,$7FFF,$4E75,$6100,$0064
	dc.w	$207C,$000B,$BD30,$3039,$0001,$7F66,$3239,$0001
	dc.w	$8D32,$6100,$9D0A,$2C79,$0001,$91CA,$BDFC,$0001
	dc.w	$8D6A,$6700,$E428,$3226,$3026,$2066,$6100,$9CF0
	dc.w	$BDFC,$0001,$8D6A,$6E00,$FFEE,$4E75,$2C79,$0001
	dc.w	$91CA,$BDFC,$0001,$8D6A,$6700,$E402,$3226,$3026
	dc.w	$2066,$6100,$9B74,$BDFC,$0001,$8D6A,$6E00,$FFEE
	dc.w	$4E75,$3039,$0001,$8D30,$0640,$0002,$6100,$AB5E
	dc.w	$0839,$0004,$00FF,$800E,$66F6,$33FC,$0031,$00FF
	dc.w	$8026,$33F9,$0001,$7CF0,$00FF,$8028,$08F9,$0003
	dc.w	$00FF,$800F,$0839,$0003,$00FF,$800E,$67F6,$08F9
	dc.w	$0004,$00FF,$800F,$08B9,$0003,$00FF,$800F,$0839
	dc.w	$0003,$00FF,$800E,$66F6,$08B9,$0004,$00FF,$800F
	dc.w	$0839,$0004,$00FF,$800E,$66F6,$33FC,$0030,$00FF
	dc.w	$8026,$23FC,$4002,$0010,$00FF,$8028,$08F9,$0003
	dc.w	$00FF,$800F,$0839,$0003,$00FF,$800E,$67F6,$08F9
	dc.w	$0004,$00FF,$800F,$08B9,$0003,$00FF,$800F,$0839
	dc.w	$0003,$00FF,$800E,$66F6,$08B9,$0004,$00FF,$800F
	dc.w	$0839,$0004,$00FF,$800E,$66F6,$33FC,$0031,$00FF
	dc.w	$8026,$33F9,$0001,$7CF2,$00FF,$8028,$08F9,$0003
	dc.w	$00FF,$800F,$0839,$0003,$00FF,$800E,$67F6,$08F9
	dc.w	$0004,$00FF,$800F,$08B9,$0003,$00FF,$800F,$0839
	dc.w	$0003,$00FF,$800E,$66F6,$08B9,$0004,$00FF,$800F
	dc.w	$4E75,$48E7,$FFFE,$0839,$0000,$0001,$8D64,$6600
	dc.w	$FFF6,$2A7C,$0001,$8D6A,$6100,$0072,$2C7C,$000B
	dc.w	$BD30,$7C01,$6100,$019C,$6100,$063C,$6100,$07D2
	dc.w	$6100,$07F0,$6100,$0484,$6100,$0250,$4EB9,$0002
	dc.w	$9364,$6100,$032E,$6100,$011A,$4EB9,$0002,$2E70
	dc.w	$BDFC,$000B,$BD30,$6600,$0006,$429E,$429E,$422E
	dc.w	$FFFB,$200E,$0480,$000B,$BD30,$E248,$33C0,$0001
	dc.w	$7F66,$23CD,$0001,$91CA,$23CD,$0001,$AD96,$08F9
	dc.w	$0000,$0001,$8D64,$4CDF,$7FFF,$4E75
updatescroll						;Using hpos and vpos set scroll cords; queue rink map rows on the dma list
									;(a5) when vertical scrolling needs new rows. Called from setvideo. Takes
									;the rows from Rinktilelist, or RevRinkTilelist in a reverse angle replay
									;(sflags4 bit 4)
	btst	#$7,$17F6A.l		;sfhor
	bne.w	X_21000
	moveq	#-64,d0		;-192+128 (#$FFFFFFC0)
	sub.w	(Hpos).l,d0
	move.w	(Vpos).l,d1
	move.w	d0,(Hscroll).l
	move.w	d1,(Vscroll).l
	neg.w	(Vscroll).l
	move.w	(Oldrow).l,d4
	asr.w	#$3,d1		;d1 = Vpos in 8 pixel rows
	move.w	d1,(Oldrow).l		;d4 = previous row
	moveq	#$1F,d3		;max lines to update
	cmp.w	d4,d1
	beq.w	X_21000		;same row as last frame
	movea.l	(Rinktilelist).l,a0
	btst	#$4,$17F72.l		;reverse angle replay
	beq.w	.0
	movea.l	(RevRinkTilelist).l,a0
.0	adda.l	$4(a0),a0		;a0 = map header: (a0) = chars per row, data at 4(a0) (the move / adda
	blt.w	.su0		;row went up
.sd	move.w	d1,d0		;scrolling down: queue map rows, one per pass (d3 = max rows)
	neg.w	d0
	addi.w	#$1E,d0
	andi.w	#$1F,d0
	asl.w	#$7,d0		;chars per row screen format
	add.w	(VmMAP2).l,d0
	move.w	d0,$6(a5)		;vram address
	move.w	#$1E,d0		;60-30
	sub.w	d1,d0
	move.w	(a0),$4(a5)		;words = one map row
	mulu.w	(a0),d0
	add.w	d0,d0
	lea.l	$4(a0,d0.w),a1
	move.l	a1,(a5)		;source = map row
	adda.w	#$8,a5
	subq.w	#$1,d1
	cmp.w	d4,d1
	dbeq	d3,.sd
	rts
.su0	move.w	d1,d0		;scrolling up: same as .sd with rows going the other way
	neg.w	d0
	addi.w	#$1D,d0
	andi.w	#$1F,d0
	asl.w	#$7,d0
	add.w	(VmMAP2).l,d0
	move.w	d0,$6(a5)
	move.w	#$3D,d0
	sub.w	d1,d0
	move.w	(a0),$4(a5)
	mulu.w	(a0),d0
	add.w	d0,d0
	lea.l	$4(a0,d0.w),a1
	move.l	a1,(a5)
	adda.w	#$8,a5
	addq.w	#$1,d1
	cmp.w	d4,d1
	dbeq	d3,.su0
	rts
showref						;draw ref graphics. a5 = dma list, a6 = sprite table, d6 = link counter.
									;Called from setvideo
	bclr	#$1,$17F6C.l		;sf2refref
	beq.w	X_21000
	movea.l	#$18074,a0
	movea.l	#VmMAP1,a1
	move.w	$2(a1),d2
	moveq	#$2,d0		;refy: Xpos on ice screen
	btst	#$7,$17F6A.l
	beq.w	.1
	moveq	#$F,d0		;Ypos on scoreboard screen
.1	asl.w	d2,d0		;row * map row size
	moveq	#$2,d1
	asl.w	d2,d1		;d1 = vram step of 2 map rows
	addi.w	#$2,d0		;refx
	btst	#$7,$17F6A.l
	beq.w	.2
	addi.w	#$B,d0
.2	asl.w	#$1,d0		;cells to bytes
	add.w	(a1),d0		;d0 = vram address of the ref block in map 1
	moveq	#$7,d2		;refheight-1
.0	move.l	a0,(a5)+
	move.w	#$7,(a5)+
	move.w	d0,(a5)+
	adda.w	#$E,a0		;refwidth*2
	add.w	d1,d0
	dbra	d2,.0
	rts
checkfo						;check for face off sprites. 3 entries of fofdata2: word frame, word
									;flags. Called from setvideo
	btst	#$0,$17F6A.l		;sfpz
	bne.w	X_21000
	btst	#$4,(disflags).l		;face off flag
	beq.w	X_21000
	movea.l	#fofdata2,a3
	moveq	#$2,d0
.loop	move.w	(a3),d4
	bmi.w	.l22F98
	beq.w	.l22F98
	movea.l	(FaceOffSprites).l,a2
	adda.l	$4(a2),a2
	add.w	d4,d4
	move.w	$2(a2,d4.w),d5
	sub.w	(a2,d4.w),d5
	lsr.w	#$3,d5
	subi.w	#$1,d5
	adda.w	(a2,d4.w),a2
.loop2	move.w	$2(a2),d2
	addi.w	#$80,d2
	add.w	(fodropy).l,d2
	move.w	d2,(a6)
	move.w	(a2),d2
	btst	#$3,$2(a3)		;x flip
	beq.w	.0
	move.b	$7(a2),d2
	andi.w	#$C,d2
	addi.w	#$4,d2
	asl.w	#$1,d2
	neg.w	d2
	sub.w	(a2),d2
.0	addi.w	#$80,d2
	add.w	(fodropx).l,d2
	move.w	d2,$6(a6)
	move.b	$7(a2),$2(a6)
	move.b	d6,$3(a6)
	move.w	$6(a2),d2
	andi.w	#$F800,d2
	or.w	$4(a2),d2
	move.w	$2(a3),d1
	andi.w	#$F800,d1
	eor.w	d1,d2
	add.w	(faceoffvrcset).l,d2
	move.w	d2,$4(a6)
	addi.w	#$1,d6
	adda.w	#$8,a6
	adda.w	#$8,a2
	dbra	d5,.loop2
	adda.w	#$4,a3
.l22F98	dbra	d0,.loop
	rts
	dc.w	$3039,$0001,$7CE2,$6B00,$E05A,$2079,$0004,$7D34
	dc.w	$E448,$323C,$012A,$7401,$3639,$0001,$8D56,$6100
	dc.w	$006A,$3400,$E24A,$48C2,$84FC,$0003,$4842,$0642
	dc.w	$0002,$6100,$0056,$7405,$3839,$0001,$8358,$B879
	dc.w	$0001,$86BE,$6300,$0044,$3400,$0442,$00DA,$6A00
	dc.w	$0004,$4242,$E44A,$D442,$0C42,$001A,$6D00,$0004
	dc.w	$7418,$43F9,$0003,$E00E,$3431,$2000,$6000,$001C
	dc.w	$0005,$0006,$0007,$0008,$0007,$0008,$0007,$0008
	dc.w	$0007,$0008,$0007,$0006,$0005,$0C46,$0040,$6C00
	dc.w	$DFD2,$48E7,$FC80,$D1E8,$0004,$D442,$3830,$2002
	dc.w	$9870,$2000,$E64C,$0444,$0001,$D0F0,$2000,$3CA8
	dc.w	$0002,$D35E,$1CE8,$0007,$1CC6,$3428,$0006,$0242
	dc.w	$F800,$D468,$0004,$D443,$3CC2,$3C90,$D15E,$0646
	dc.w	$0001,$0C46,$0040,$6700,$000A,$D0FC,$0008,$51CC
	dc.w	$FFCE,$4CDF,$013F,$4E75
showcrowd						;draw crowd sprites: up to 3 frames per PBnum nibble, then the two
									;Crowdframe frames. a5 = dma list, a6 = sprite table, d6 = link counter.
									;No crowd in a reverse angle replay. Called from setvideo
	btst	#$4,$17F72.l		;check if reverse angle replay
	bne.w	.l231CC		;branch if so
	movea.l	(CrowdSprites).l,a1
	adda.l	$4(a1),a1		;a1 = frame offset table
	move.w	(Hpos).l,d4
	move.w	(Vpos).l,d5
	btst	#$7,$17F6A.l
	beq.w	.v
	moveq	#-64,d4		;(#$FFFFFFC0)
	move.l	#$100,d5
.v	clr.w	d0		;d4/d5 = x/y of the view
	move.b	(PBnum).l,d2		;low nibble
	moveq	#$1A,d3		;frames 26+ (low nibble)
	bsr.w	.pb
	move.b	(PBnum).l,d2
	lsr.w	#$4,d2		;high nibble
	moveq	#$1D,d3		;frames 29+ (high nibble)
	bsr.w	.pb
	move.b	(Crowdframe).l,d0
	bsr.w	.sc
	move.b	$17CD1.l,d0
	bra.w	.sc
.pb	andi.w	#$F,d2		;d2 = count, d3 = first frame
	cmpi.w	#$3,d2
	bls.w	.pb0
	moveq	#$3,d2		;max 3
.pb0	bra.w	.l23106
.pbt	move.w	d3,d0		;frame = first frame + counter
	add.w	d2,d0
	bsr.w	.sc
.l23106	dbra	d2,.pbt
	rts
.sc	ext.w	d0
	beq.w	X_21000
	btst	#$7,$17F6A.l
	beq.w	.chk
	addi.w	#$1F,d0		;horizontal frames are 31 later
.chk	cmpi.w	#$40,d6		;MaxSprites
	bge.w	X_21000
	movem.l	d0-d5,-(sp)
	add.w	d0,d0
	movea.l	a1,a0
	move.w	$2(a0,d0.w),d1
	sub.w	(a0,d0.w),d1
	lsr.w	#$3,d1
	subi.w	#$1,d1
	move.w	d1,-(sp)		;number of sprites in frame
	adda.w	(a0,d0.w),a0
	move.w	d4,d0		;x window d0-d1
	addi.w	#$C0,d0
	move.w	d0,d1
	subi.w	#$90,d0		;128+16
	addi.w	#$80,d1
	move.w	#$170,d2		;y window d2-d3
	sub.w	d5,d2
	move.w	d2,d3
	subi.w	#$80,d2		;112+16
	addi.w	#$70,d3		;112
	move.w	(sp)+,d4
.loop	cmp.w	$2(a0),d2		;per sprite: skip it if outside the window d0-d3
	bgt.w	.next
	cmp.w	$2(a0),d3
	blt.w	.next
	cmp.w	(a0),d0
	bgt.w	.next
	cmp.w	(a0),d1
	blt.w	.next
	move.w	$2(a0),d5
	addi.w	#$70,d5		;128-16
	sub.w	d2,d5
	move.w	d5,(a6)+
	move.b	$7(a0),(a6)+
	move.b	d6,(a6)+
	move.w	$6(a0),d5
	andi.w	#$F800,d5
	add.w	$4(a0),d5
	add.w	(crowdvrcset).l,d5		;crowd start char
	move.w	d5,(a6)+
	move.w	(a0),d5
	addi.w	#$70,d5		;128-16
	sub.w	d0,d5
	move.w	d5,(a6)+
	addi.w	#$1,d6
	cmpi.w	#$40,d6
	beq.w	.l231C8
.next	adda.w	#$8,a0
	dbra	d4,.loop
.l231C8	movem.l	(sp)+,d0-d5
.l231CC	rts
showclock						;put the game clock on screen. Called from setvideo and PauseMode. On the
									;horizontal rink the clock is printed (printz / print with .digits; not in
									;a shootout, gmode2 bit 0). On the vertical rink (.3) it goes in the dma
									;list, only when dfclock is set; with gmode2 bit 1 (penalty shot /
									;shootout) shootoutclock is shown instead of gameclock. a5 = dma list
	btst	#$7,$17F6A.l		;sfhor
	beq.w	X_2329C
	btst	#$0,$17F78.l		;shootout
	bne.w	X_23260
	move.l	a1,-(sp)
	jsr	(printz).l
	String	CC_Font2Pri,$D,$5
	move.w	(gameclock).l,d0
	ext.l	d0
	divu.w	#$258,d0		;tens of minutes (600 seconds)
	move.l	d0,-(sp)
	tst.w	d0
	bne.w	X_23214
	addi.w	#$1,(printx).l
	bra.w	X_2321A
	dc.w	$4EB9,$0003,$E262,$201F,$4840,$48C0,$80FC,$003C
	dc.w	$2F00,$4EB9,$0003,$E262,$201F,$4840,$48C0,$0679
	dc.w	$0002,$0001,$8D58,$80FC,$000A,$2F00,$4EB9,$0003
	dc.w	$E262,$201F,$4840,$48C0,$4EB9,$0003,$E262,$225F
	dc.w	$4EB9,$0003,$8F6E,$0006,$BD0D,$0500,$4E75,$227C
	dc.w	$0003,$E274,$E540,$D2C0,$4EB9,$0003,$8F80,$4E75
	dc.w	$0004,$3000,$0004,$3100,$0004,$3200,$0004,$3300
	dc.w	$0004,$3400,$0004,$3500,$0004,$3600,$0004,$3700
	dc.w	$0004,$3800,$0004,$3900
	bclr	#$3,(disflags).l		;dfclock
	beq.w	X_21000
	btst	#$3,$17F6C.l
	bne.w	X_21000
	cmpi.w	#$4,$180E4.l		;no clock update when gsp = 4
	beq.w	X_21000
	movea.l	#$17EDA,a0		;end of the 5 word clock buffer; written backward
	movea.l	(SmallFontMap).l,a1
	adda.l	$4(a1),a1
	move.w	$78(a1),d0		;4+(':'*2)
	add.w	(smallfontchars).l,d0
	ori.w	#$8000,d0
	move.w	d0,(clockram).l		;colon
	move.w	(gameclock).l,d0
	btst	#$1,$17F78.l		;penalty shot / shootout clock
	beq.w	.4
	move.w	(shootoutclock).l,d0
.4	ext.l	d0
	divu.w	#$A,d0
	bsr.w	.char		;seconds ones
	divu.w	#$6,d0
	bsr.w	.char		;seconds tens
	suba.w	#$2,a0		;skip the colon
	divu.w	#$A,d0
	bsr.w	.char		;minutes ones
	swap	d0
	tst.l	d0		;minutes tens is zero?
	bne.w	.0
	moveq	#-16,d0		;' '-'0': blank leading zero (#$FFFFFFF0)
	swap	d0
.0	bsr.w	.char		;minutes tens
	move.l	a0,(a5)+
	move.w	#$5,(a5)+		;words to transfer
	movea.l	#VmMAP1,a1
	moveq	#$18,d0		;.clocky = 24
	moveq	#$3,d2		;.clockx = 3
	btst	#$7,$17F6A.l		;sfhor (always clear here: the horizontal rink prints the clock above)
	beq.w	.cv
	movea.l	#VmMAP2,a1
	moveq	#$5,d0		;clock y (93 used 4)
	moveq	#$D,d2		;.clockx2 = 13
.cv	move.w	$2(a1),d1		;map width shift (d0 = y, d2 = x of the clock)
	asl.w	d1,d0
	add.w	d2,d0
	asl.w	#$1,d0
	add.w	(a1),d0
	move.w	d0,(a5)+		;vram destination
	rts
.char	swap	d0
	asl.w	#$1,d0
	move.w	$64(a1,d0.w),d0		;4+('0'*2)
	add.w	(smallfontchars).l,d0
	ori.w	#$8000,d0
	move.w	d0,-(a0)
	swap	d0
	ext.l	d0
	rts
	dc.w	$0839,$0007,$0001,$7F6A,$6600,$DC7C,$207C,$0001
	dc.w	$7D20,$267C,$0001,$7DD8,$363C,$0180,$6100,$0046
	dc.w	$D0FC,$001C,$D6FC,$0014,$363C,$0183,$6100,$0036
	dc.w	$4A79,$0001,$7FAA,$6700,$DC4E,$207C,$0001,$7D74
	dc.w	$D6FC,$0014,$363C,$0346,$6100,$001A,$4A79,$0001
	dc.w	$7FAC,$6700,$DC32,$207C,$0001,$7D90,$D6FC,$0014
	dc.w	$363C,$0349,$4A68,$0018,$6B00,$DC1C,$50EB,$0006
	dc.w	$3028,$0000,$0839,$0000,$0001,$7F78,$6600,$001A
	dc.w	$0839,$0003,$0001,$7F6C,$6600,$000E,$0839,$0002
	dc.w	$0001,$7F70,$6700,$001A,$3F00,$4A40,$6A00,$0004
	dc.w	$4440,$0C40,$00A6,$6D00,$0006,$301F,$4E75,$301F
	dc.w	$3228,$0014,$0839,$0007,$0001,$7F6A,$6700,$000E
	dc.w	$C141,$4440,$0441,$00C5,$6000,$000E,$9079,$0001
	dc.w	$7CEE,$9279,$0001,$7CEA,$4242,$0C40,$0074,$6D00
	dc.w	$0006,$08C2,$0003,$0C40,$FF8C,$6E00,$0006,$08C2
	dc.w	$0002,$0C41,$0064,$6D00,$0006,$08C2,$0000,$0C41
	dc.w	$FF9C,$6E00,$0006,$08C2,$0001,$4A42,$6700,$DB78
	dc.w	$227C,$0003,$7588,$1431,$2000,$E742,$227C,$0003
	dc.w	$E4D4,$3831,$2000,$6700,$0004,$3004,$0640,$0100
	dc.w	$3740,$0000,$3831,$2002,$6700,$0004,$3204,$4441
	dc.w	$0641,$00F0,$3741,$0002,$D671,$2004,$3743,$0006
	dc.w	$3771,$2006,$0004,$6000,$0214,$0000,$0064,$0000
	dc.w	$0000,$0074,$0064,$0001,$0000,$0074,$0000,$0002
	dc.w	$0000,$0074,$FF9C,$0001,$1000,$0000,$FF9C,$0000
	dc.w	$1000,$FF8C,$FF9C,$0001,$1800,$FF8C,$0000,$0002
	dc.w	$0800,$FF8C,$0064,$0001,$0800
setsortcords						;setup sort cord graphics: addframe for the 16 objects in OOlist order. a5
									;= dmalist, a6 = sprite attribute table, d6 = link counter
	movea.l	#$17CC0,a4		;move OOlist into a4
	move.w	#$F,d0		;sortobj-1 (15 dec)
.top	clr.w	d1
	move.b	(a4)+,d1		;move next sortcord into d1
	asl.w	#$6,d1		;mult by 64
	movea.l	#SortCords,a3		;SortCords into a3
	adda.w	d1,a3		;add offset to next struct
	bsr.w	X_236BC
	dbra	d0,.top
	rts
setffo						;draw the 7 objects tied to icerink scrolling (gloves and pads), moving
									;each by its x offset. Called from setvideo
	bsr.w	X_23566
	move.w	#$6,d0		;ffo obj -1
	movea.l	#$17D04,a3		;move start of struct into a3
.top	movea.l	a6,a0		;per object: a0 = first sprite this object writes
	bsr.w	X_236BC
	cmpa.l	a6,a0
	beq.w	.next		;no sprites added
	move.w	$2(a3),d1		;x offset (set by QueuePadLabel)
	add.w	d1,$6(a0)		;sprite 1 x
	add.w	d1,$E(a0)
.next	adda.w	#$1C,a3		;move to next struct
	dbra	d0,.top
	rts
	dc.w	$207C,$0001,$7DAC,$50E8,$0018,$1039,$0001,$7E32
	dc.w	$6700,$001C,$1239,$0001,$7E33,$4880,$E540,$3140
	dc.w	$0000,$4881,$E541,$3141,$0014,$4268,$0018,$383C
	dc.w	$0005,$207C,$0001,$7D04,$227C,$0001,$7DCA,$247C
	dc.w	$0001,$7480,$3639,$0001,$7DC8,$0C44,$0001,$6600
	dc.w	$000E,$3639,$0001,$7DD6,$E84B,$6000,$0002,$3003
	dc.w	$0240,$000F,$323C,$000F,$0C40,$000E,$6700,$002A
	dc.w	$50E8,$0018,$0C40,$000F,$6700,$002A,$EF40,$3172
	dc.w	$0000,$0000,$3172,$0014,$0014,$4268,$0018,$1232
	dc.w	$0035,$E141,$1232,$006F,$B251,$6700,$0008,$3281
	dc.w	$6100,$0012,$E84B,$D0FC,$001C,$D2FC,$0002,$51CC
	dc.w	$FF9A,$4E75
QueuePadLabel						;Queue the 3 character label of a pad object. d1 = label code: bits 7-4
									;and 3-0 are digits ($F = blank), bits 10-8 index ButtonLabelCharTable
									;(none while sflags7 bit 7 is set).
									;a0 = pad object, a5 = dma list. Falls into uppads_pd for the
									;last char
	lea.l	X_236B4(pc),a4
	clr.w	$2(a0)		;x offset (setffo adds it to the sprites)
	move.w	d1,d2
	lsr.w	#$4,d2
	andi.w	#$F,d2
	bne.w	.hi
	move.w	#$FFF0,d2		;' '-'0': blank leading zero
	subi.w	#$4,$2(a0)
.hi	addi.w	#$30,d2		;'0' (tens digit of the label, or blank)
	clr.w	d0		;char slot 0
	bsr.w	X_23684
	move.w	d1,d2
	andi.w	#$F,d2
	cmpi.w	#$F,d2
	bne.w	.lo
	move.w	#$FFF0,d2		;$F: blank
.lo	addi.w	#$30,d2		;'0' (ones digit of the label, or blank)
	moveq	#$1,d0		;char slot 1
	bsr.w	X_23684
	move.w	d1,d2
	btst	#$7,$17F7A.l
	beq.w	.0
	clr.w	d2
.0	lsr.w	#$8,d2
	andi.w	#$7,d2
	bne.w	.1
	addi.w	#$4,$2(a0)
.1	move.b	(a4,d2.w),d2
	moveq	#$2,d0
