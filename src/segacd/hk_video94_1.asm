	include	segacd\hockey.inc
	include	macros\genesis.mac

AwGoals	equ	$186BE
CC_Font2Pri	equ	$BE
CC_Font3Pri	equ	$BD
CrowdSprites	equ	$47D2C
Crowdframe	equ	$17CD0
ExtraChars	equ	$18D56
FaceOffSprites	equ	$47D30
HmGoals	equ	$18358
Hpos	equ	$17CEE
Hscroll	equ	$17CF0
Oldrow	equ	$17CEC
PBnum	equ	$18068
PadControlBits	equ	$17DC8
PadControlBits34	equ	$17DD6
RevRinkTilelist	equ	$47D64
Rinktilelist	equ	$47D18
Satt	equ	$BBD30
Sattsize	equ	$17F66
SmallFontMap	equ	$47D3C
SortCords	equ	$17480
VSPRITES	equ	$18D32
VmMAP1	equ	$18D34
VmMAP2	equ	$18D38
Vpos	equ	$17CEA
Vscroll	equ	$17CF2
ZamSprites	equ	$47D34
clockram	equ	$17ED4
crowdvrcset	equ	$18D4A
digit	equ	$3E262
digits	equ	$3E274
disflags	equ	$18D64
faceoffvrcset	equ	$18D4C
fodropx	equ	$1746C
fodropy	equ	$1746E
fofdata2	equ	$17CF8
gameclock	equ	$180E6
move	equ	$2C9C8
print	equ	$38F80
printx	equ	$18D58
printz	equ	$38F6E
shootoutclock	equ	$193B6
smallfontchars	equ	$18D42
swap	equ	$2779A
L23028	equ	$23028
X_1C8D2	equ	$1C8D2
X_21000	equ	$21000
X_22C16	equ	$22C16
X_236B4	equ	$236B4
X_236BC	equ	$236BC

	org	$22BB0

DumpSprites						;Transfer (by dma) scroll stuff, sprite table, vram data in dmalist.
									;Called from VBlank when dfok was set. Falls into DumpSprites2
	bsr.w	X_22C16
	movea.l	#Satt,a0
	move.w	(Sattsize).l,d0
	move.w	(VSPRITES).l,d1
	bsr.w	X_1C8D2
	movea.l	$191CA.l,a6
	dc.w	$BDFC,$0001,$8D6A,$6700,$E428,$3226,$3026,$2066
	dc.w	$6100,$9CF0,$BDFC,$0001,$8D6A,$6E00,$FFEE,$4E75
	dc.w	$2C79,$0001,$91CA,$BDFC,$0001,$8D6A,$6700,$E402
	dc.w	$3226,$3026,$2066,$6100,$9B74,$BDFC,$0001,$8D6A
	dc.w	$6E00,$FFEE,$4E75,$3039,$0001,$8D30,$0640,$0002
	dc.w	$6100,$AB5E,$0839,$0004,$00FF,$800E,$66F6,$33FC
	dc.w	$0031,$00FF,$8026,$33F9,$0001,$7CF0,$00FF,$8028
	dc.w	$08F9,$0003,$00FF,$800F,$0839,$0003,$00FF,$800E
	dc.w	$67F6,$08F9,$0004,$00FF,$800F,$08B9,$0003,$00FF
	dc.w	$800F,$0839,$0003,$00FF,$800E,$66F6,$08B9,$0004
	dc.w	$00FF,$800F,$0839,$0004,$00FF,$800E,$66F6,$33FC
	dc.w	$0030,$00FF,$8026,$23FC,$4002,$0010,$00FF,$8028
	dc.w	$08F9,$0003,$00FF,$800F,$0839,$0003,$00FF,$800E
	dc.w	$67F6,$08F9,$0004,$00FF,$800F,$08B9,$0003,$00FF
	dc.w	$800F,$0839,$0003,$00FF,$800E,$66F6,$08B9,$0004
	dc.w	$00FF,$800F,$0839,$0004,$00FF,$800E,$66F6,$33FC
	dc.w	$0031,$00FF,$8026,$33F9,$0001,$7CF2,$00FF,$8028
	dc.w	$08F9,$0003,$00FF,$800F,$0839,$0003,$00FF,$800E
	dc.w	$67F6,$08F9,$0004,$00FF,$800F,$08B9,$0003,$00FF
	dc.w	$800F,$0839,$0003,$00FF,$800E,$66F6,$08B9,$0004
	dc.w	$00FF,$800F,$4E75,$48E7,$FFFE,$0839,$0000,$0001
	dc.w	$8D64,$6600,$FFF6,$2A7C,$0001,$8D6A,$6100,$0072
	dc.w	$2C7C,$000B,$BD30,$7C01,$6100,$019C,$6100,$063C
	dc.w	$6100,$07D2,$6100,$07F0,$6100,$0484,$6100,$0250
	dc.w	$4EB9,$0002,$9364,$6100,$032E,$6100,$011A,$4EB9
	dc.w	$0002,$2E70,$BDFC,$000B,$BD30,$6600,$0006,$429E
	dc.w	$429E,$422E,$FFFB,$200E,$0480,$000B,$BD30,$E248
	dc.w	$33C0,$0001,$7F66,$23CD,$0001,$91CA,$23CD,$0001
	dc.w	$AD96,$08F9,$0000,$0001,$8D64,$4CDF,$7FFF,$4E75
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
showzam						;zamboni. a5 = dma list, a6 = sprite table, d6 = link counter. Draws frame
									;1, frame 2-4 picked by x, then frame 5 (home score not ahead) or a .ftab
									;frame. Called from setvideo
	move.w	$17CE2.l,d0
	bmi.w	X_21000		;no zamboni
	movea.l	(ZamSprites).l,a0
	lsr.w	#$2,d0
	move.w	#$12A,d1		;y (92 128+200)
	moveq	#$1,d2		;frame
	move.w	(ExtraChars).l,d3
	bsr.w	L23028
	move.w	d0,d2
	lsr.w	#$1,d2
	ext.l	d2
	divu.w	#$3,d2
	swap	d2
	addi.w	#$2,d2		;frame 2 + (x/2 mod 3)
	bsr.w	L23028
	moveq	#$5,d2
	move.w	(HmGoals).l,d4		;home score
	cmp.w	(AwGoals).l,d4
	bls.w	L23028		;home not ahead: frame 5
	move.w	d0,d2
	subi.w	#$DA,d2
	bpl.w	.pos
	clr.w	d2		;x below $DA: first entry
.pos	lsr.w	#$2,d2		;(x-$DA)/4
	add.w	d2,d2		;word index
	cmpi.w	#$1A,d2
	blt.w	.l23000
	moveq	#$18,d2
.l23000	lea.l	$3E00E.l,a1
	move.w	(a1,d2.w),d2
	bra.w	L23028
	ori.b	#$6,d5
	ori.b	#$8,d7
	ori.b	#$8,d7
	ori.b	#$8,d7
	ori.b	#$8,d7
	ori.b	#$6,d7
	dc.w	$0005,$0C46
	ori.w	#$6C00,d0
	adda.l	(a2),sp
	movem.l	d0-d5/a0,-(sp)
	adda.l	$4(a0),a0
	add.w	d2,d2
	move.w	$2(a0,d2.w),d4
	sub.w	(a0,d2.w),d4
	lsr.w	#$3,d4
	subi.w	#$1,d4
	adda.w	(a0,d2.w),a0
.l2304C	move.w	$2(a0),(a6)
	add.w	d1,(a6)+
	move.b	$7(a0),(a6)+		;clamp to the last entry
	move.b	d6,(a6)+
	move.w	$6(a0),d2
	andi.w	#$F800,d2
	add.w	$4(a0),d2
	add.w	d3,d2
	move.w	d2,(a6)+
	move.w	(a0),(a6)
	add.w	d0,(a6)+
	addi.w	#$1,d6
	cmpi.w	#$40,d6
	beq.w	.l23080
	adda.w	#$8,a0
	dbra	d4,.l2304C
.l23080	movem.l	(sp)+,d0-d5/a0
	rts
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
	beq.w	.3
	btst	#$0,$17F78.l		;shootout
	bne.w	.x
	move.l	a1,-(sp)
	jsr	(printz).l
	String	CC_Font2Pri,$D,$5
	move.w	(gameclock).l,d0
	ext.l	d0
	divu.w	#$258,d0		;tens of minutes (600 seconds)
	move.l	d0,-(sp)
	tst.w	d0
	bne.w	.1
	addi.w	#$1,(printx).l
	bra.w	.2
.1	jsr	(digit).l
.2	move.l	(sp)+,d0
	swap	d0
	ext.l	d0
	divu.w	#$3C,d0		;minutes
	move.l	d0,-(sp)
	jsr	(digit).l
	move.l	(sp)+,d0
	swap	d0
	ext.l	d0
	addi.w	#$2,(printx).l
	divu.w	#$A,d0		;tens of seconds
	move.l	d0,-(sp)
	jsr	(digit).l
	move.l	(sp)+,d0
	swap	d0
	ext.l	d0
	jsr	(digit).l
	movea.l	(sp)+,a1
	jsr	(printz).l
	String	CC_Font3Pri,$D,$5
.x	rts
	movea.l	#digits,a1
	asl.w	#$2,d0
	adda.w	d0,a1
	jsr	(print).l
	rts
	dc.w	$0004,$3000
	dc.w	$0004,$3100
	dc.w	$0004,$3200
	dc.w	$0004,$3300
	dc.w	$0004,$3400
	dc.w	$0004,$3500
	dc.w	$0004,$3600
	dc.w	$0004,$3700
	dc.w	$0004,$3800
	dc.w	$0004,$3900
.3	bclr	#$3,(disflags).l		;dfclock
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
checksso						;do graphics for sso structure: arrows for the players when they are off
									;screen. Called from setvideo. a5 = dma list, a6 = sprite table, d6 = link
									;counter. Returns on the horizontal rink. Includes the pads 3 and 4
									;(Joy3Struct / Joy4Struct when cont3team / cont4team). Falls into .ca for
									;the last one
	dc.w	$0839,$0007,$0001,$7F6A		;x spot, y spot, frame add, attribute per direction
	dc.w	$6600,$DC7C		;.xspot = 116, .yspot = 100
	dc.w	$207C,$0001,$7D20
	dc.w	$267C,$0001,$7DD8
	dc.w	$363C,$0180
	dc.w	$6100,$0046
	dc.w	$D0FC,$001C
	dc.w	$D6FC,$0014
	dc.w	$363C,$0183
	dc.w	$6100,$0036
	dc.w	$4A79,$0001,$7FAA
	dc.w	$6700,$DC4E
	dc.w	$207C,$0001,$7D74
	dc.w	$D6FC,$0014
	dc.w	$363C,$0346
	dc.w	$6100,$001A
	dc.w	$4A79,$0001,$7FAC
	dc.w	$6700,$DC32
	dc.w	$207C,$0001,$7D90
	dc.w	$D6FC,$0014
	dc.w	$363C,$0349
.l233DE	dc.w	$4A68,$0018
	dc.w	$6B00,$DC1C
	dc.w	$50EB,$0006
	dc.w	$3028,$0000
	dc.w	$0839,$0000,$0001,$7F78
	dc.w	$6600,$001A
	dc.w	$0839,$0003,$0001,$7F6C
	dc.w	$6600,$000E
	dc.w	$0839,$0002,$0001,$7F70
	dc.w	$6700,$001A
.l23412	dc.w	$3F00
	dc.w	$4A40
	dc.w	$6A00,$0004
	dc.w	$4440
.l2341C	dc.w	$0C40,$00A6
	dc.w	$6D00,$0006
	dc.w	$301F
	dc.w	$4E75
.l23428	dc.w	$301F
.l2342A	dc.w	$3228,$0014
	dc.w	$0839,$0007,$0001,$7F6A
	dc.w	$6700,$000E
	dc.w	$C141
	dc.w	$4440
	dc.w	$0441,$00C5
	dc.w	$6000,$000E
.l23446	dc.w	$9079,$0001,$7CEE
	dc.w	$9279,$0001,$7CEA
.l23452	dc.w	$4242
	dc.w	$0C40,$0074
	dc.w	$6D00,$0006
	dc.w	$08C2,$0003
.l23460	dc.w	$0C40,$FF8C
	dc.w	$6E00,$0006
	dc.w	$08C2,$0002
.l2346C	dc.w	$0C41,$0064
	dc.w	$6D00,$0006
	dc.w	$08C2,$0000
.l23478	dc.w	$0C41,$FF9C
	dc.w	$6E00,$0006
	dc.w	$08C2,$0001
.l23484	dc.w	$4A42
	dc.w	$6700,$DB78
	dc.w	$227C,$0003,$7588
	dc.w	$1431,$2000
	dc.w	$E742
	dc.w	$227C,$0003,$E4D4
	dc.w	$3831,$2000
	dc.w	$6700,$0004
	dc.w	$3004
.l234A6	dc.w	$0640,$0100
	dc.w	$3740,$0000
	dc.w	$3831,$2002
	dc.w	$6700,$0004
	dc.w	$3204
.l234B8	dc.w	$4441
	dc.w	$0641,$00F0
	dc.w	$3741,$0002
	dc.w	$D671,$2004
	dc.w	$3743,$0006
	dc.w	$3771,$2006,$0004
	dc.w	$6000,$0214
	dc.w	$0000,$0064
	dc.w	$0000,$0000
	dc.w	$0074,$0064,$0001
	dc.w	$0000,$0074
	dc.w	$0000,$0002
	dc.w	$0000,$0074
	dc.w	$FF9C
	dc.w	$0001,$1000
	dc.l	$FF9C
	dc.l	$1000
	dc.w	$FF8C
	dc.w	$FF9C
	dc.w	$0001,$1800
	dc.w	$FF8C
	dc.w	$0000,$0002
	dc.w	$0800
	dc.w	$FF8C
	dc.w	$0064,$0001
	dc.w	$0800
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
	bsr.w	uppads
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
uppads						;update the gloves object and the 6 pad objects, and queue new pad labels
									;(QueuePadLabel). The pad players
									;come from the PadControlBits / PadControlBits34 nibbles ($E = no change,
									;$F = none)
	movea.l	#$17DAC,a0		;pads+(4*ffosize): gloves
	st.b	$18(a0)		;set Zpos
	move.b	$17E32.l,d0
	beq.w	.0		;branch if 0
	move.b	$17E33.l,d1
	ext.w	d0
	asl.w	#$2,d0
	move.w	d0,$0(a0)		;move d0 into Xpos
	ext.w	d1
	asl.w	#$2,d1
	move.w	d1,$14(a0)		;move d1 into Ypos
	clr.w	$18(a0)		;clear Zpos
.0	move.w	#$5,d4
	movea.l	#$17D04,a0
	movea.l	#$17DCA,a1		;last label code per pad
	movea.l	#SortCords,a2
	move.w	(PadControlBits).l,d3
.top	cmpi.w	#$1,d4
	bne.w	.nibble
	move.w	(PadControlBits34).l,d3
	lsr.w	#$4,d3
	bra.w	.nibble		;to the next instruction
.nibble	move.w	d3,d0		;per pad: d3 holds the remaining nibbles
	andi.w	#$F,d0		;this pad's nibble: player number, $E or $F
	move.w	#$F,d1		;label code for $E
	cmpi.w	#$E,d0
	beq.w	.chg		;$E: leave the pad position alone
	st.b	$18(a0)		;hidden
	cmpi.w	#$F,d0
	beq.w	.next		;$F: pad hidden, label unchanged
	asl.w	#$7,d0
	move.w	(a2,d0.w),$0(a0)
	move.w	$14(a2,d0.w),$14(a0)
	clr.w	$18(a0)		;shown
	move.b	$35(a2,d0.w),d1		;label code = position << 8 | rostnum
	asl.w	#$8,d1
	move.b	$6F(a2,d0.w),d1
.chg	cmp.w	(a1),d1		;new label code vs the last one for this pad
	beq.w	.next		;same label as last time
	move.w	d1,(a1)
	bsr.w	QueuePadLabel
.next	lsr.w	#$4,d3
	adda.w	#$1C,a0
	adda.w	#$2,a1
	dbra	d4,.top
	rts
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
	bsr.w	uppads_pd
	move.w	d1,d2
	andi.w	#$F,d2
	cmpi.w	#$F,d2
	bne.w	.lo
	move.w	#$FFF0,d2		;$F: blank
.lo	addi.w	#$30,d2		;'0' (ones digit of the label, or blank)
	moveq	#$1,d0		;char slot 1
	bsr.w	uppads_pd
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
uppads_pd						;Dma one small font tile (SmallFontMap) to the object's chars. d2 = ascii
									;char, d0 = char slot, a0 = object (VRchar), a5 = dma list
	movea.l	(SmallFontMap).l,a3
	adda.l	$4(a3),a3
	add.w	d2,d2
	move.w	$4(a3,d2.w),d2
	andi.w	#$7FF,d2
	asl.w	#$5,d2		;32 bytes per tile
	movea.l	(SmallFontMap).l,a3
	lea.l	$A(a3,d2.w),a3		;tile data
	move.l	a3,(a5)+
	move.w	#$10,(a5)+		;words to transfer
	add.w	$12(a0),d0
	asl.w	#$5,d0
	move.w	d0,(a5)+		;vram destination
	rts
	dc.w	$2044,$444C,$4352,$5800,$48E7,$E000,$302B,$0000
	dc.w	$322B,$0014,$342B,$0018,$6B00,$0012,$6100,$01A0
	dc.w	$0C41,$4E20,$6700,$0006,$6100,$0008,$4CDF,$0007
	dc.w	$4E75,$3F2B,$0004,$48E7,$FCE0,$382B,$0006,$6B00
	dc.w	$0174,$6700,$0170,$0244,$F800,$B96B,$0004,$382B
	dc.w	$0006,$0244,$07FF,$2479,$0004,$7D24,$D5EA,$0004
	dc.w	$D844,$B86A,$0002,$6C00,$014C,$3A32,$4002,$9A72
	dc.w	$4000,$E64D,$0445,$0001,$D4F2,$4000,$4243,$4244
	dc.w	$3F00,$302B,$0006,$0240,$07FF,$B06B,$0008,$6700
	dc.w	$0086,$4A45,$6600,$0006,$3740,$0008,$48A7,$F800
	dc.w	$342A,$0004,$4244,$182A,$0007,$207C,$0004,$1A5C
	dc.w	$1830,$4000,$B86F,$0008,$6E00,$0026,$B46F,$0004
	dc.w	$6D00,$001E,$302F,$0004,$D06F,$0008,$9042,$9044
	dc.w	$6B00,$000E,$4C9F,$0003,$DEFC,$0006,$6000,$0034
	dc.w	$D66F,$0008,$4C9F,$0003,$DEFC,$0006,$48A7,$F800
	dc.w	$D66B,$0012,$48C2,$EB82,$D4B9,$0004,$7D24,$0682
	dc.w	$0000,$000A,$E944,$EB43,$2AC2,$3AC4,$3AC3,$4C9F
	dc.w	$001F,$1783,$500A,$301F,$48A7,$E000,$342A,$0002
	dc.w	$082B,$0004,$0004,$6700,$0016,$142A,$0007,$0242
	dc.w	$0003,$0642,$0001,$E742,$4442,$946A,$0002,$D242
	dc.w	$3C81,$3412,$082B,$0003,$0004,$6700,$0014,$142A
	dc.w	$0007,$0242,$000C,$0642,$0004,$E342,$4442,$9452
	dc.w	$D042,$3D40,$0006,$1D6A,$0007,$0002,$1D46,$0003
	dc.w	$342A,$0006,$302B,$0004,$B142,$0242,$F800,$082B
	dc.w	$0000,$0005,$6700,$000E,$0802,$000E,$6700,$0006
	dc.w	$08C2,$000D,$8433,$500A,$D46B,$0012,$3D42,$0004
	dc.w	$4C9F,$0007,$0646,$0001,$DCFC,$0008,$D4FC,$0008
	dc.w	$51CD,$FECE,$4CDF,$073F,$375F,$0004,$4E75
find3d						;input: d0 = xfield, d1 = yfield, d2 = height off field. Output: d0 =
									;xscreen, d1 = yscreen, or d1 = $4E20 when off screen
	btst	#$7,$17F6A.l
	beq.w	.nhor
	exg.l	d0,d1
	neg.w	d0
	subi.w	#$C5,d1
	bra.w	.crange
.nhor	sub.w	(Hpos).l,d0
	sub.w	(Vpos).l,d1
.crange	cmpi.w	#$90,d0
	bgt.w	.offscr
	cmpi.w	#$FF70,d0
	blt.w	.offscr
	addi.w	#$100,d0		;128+128
	add.w	d2,d1
	asr.w	#$1,d2
	add.w	d2,d1		;y + 1.5 * height
	cmpi.w	#$90,d1		;112+32
	bgt.w	.offscr
	cmpi.w	#$FF70,d1
	blt.w	.offscr
	neg.w	d1
	addi.w	#$F0,d1		;112+128
	rts
.offscr	move.w	#$4E20,d1
	rts
