	include	segacd\hockey.inc
	include	macros\genesis.mac

ArenaAnims	equ	$2A26C
CopyString	equ	$25818
DecompressGraphicsPlain	equ	$38958
FaceoffAnims	equ	$2AC8E
GetLogName	equ	$26E0E
HmTeam	equ	$1A56C
LOAD	equ	$1B000
M68K_RAM	equ	$C45C
PlayedByTxt	equ	$2AE40
PushNumberWidth	equ	$3919A
RandomSongs	equ	$2A584
ReadCrowdRecord	equ	$2258E
ReadSRAM	equ	$22452
Satt	equ	$BBD30
Sattsize	equ	$17F66
SetSframe	equ	$3E028
SongIndex	equ	$1A56E
SongNum	equ	$1A56A
StanleyCupSprite	equ	$47D94
TeamSongs	equ	$2A4DC
TempBuffer	equ	$17E70
TempWord1	equ	$17E62
ThreeStars	equ	$BC000
appendz	equ	$39200
appstring	equ	$39208
arenaanim	equ	$1A556
arenaanimchars	equ	$1A54E
arenaframe	equ	$1A550
arenaframeidx	equ	$1A552
arenaframelist	equ	$1A558
arenaframetime	equ	$1A554
arenaspritelist	equ	$1A55C
awtmstruct	equ	$186B2
energybarchars	equ	$18D46
faceoffanim	equ	$1A560
lastsfx	equ	$17F64
lognametext	equ	$1AD5C
move	equ	$2C9C8
namelength	equ	$1A38A
namelogsel	equ	$1A38C
passdir	equ	$17E2C
passdirlist	equ	$2A674
picturebits	equ	$1AD42
picturebuf	equ	$1A8C0
playoffspritex	equ	$17CE4
playoffspritey	equ	$17CE6
print	equ	$38F80
printx	equ	$18D58
printy	equ	$18D5A
printz	equ	$38F6E
randomd0	equ	$37050
recbpr	equ	$17470
sopath	equ	$1A8B4
sopathdir	equ	$1A8BC
sopathx	equ	$1A8B8
tmshots	equ	$0
tmstruct	equ	$1834C
LF5BE	equ	$F5BE
X_F466	equ	$F466
X_F5CE	equ	$F5CE
X_F5F2	equ	$F5F2
X_F736	equ	$F736
X_FE50	equ	$FE50
X_14F5E	equ	$14F5E
X_14F64	equ	$14F64

	org	$F1AA

RunArenaAnim
	tst.w	(arenaanim).l
	bmi.w	.lF21C
	movem.l	d0-d7/a0-a6,-(sp)
	tst.l	(arenaspritelist).l
	bne.w	.lF202
	move.w	(arenaanim).l,d0
	asl.w	#$3,d0
	movea.l	#ArenaAnims,a0
	move.l	(a0,d0.w),(arenaframelist).l
	move.l	$4(a0,d0.w),(arenaspritelist).l
	movea.l	$4(a0,d0.w),a2
	adda.w	#$8,a2
	move.w	(arenaanimchars).l,d4
	jsr	(DecompressGraphicsPlain).l
	clr.w	(arenaframeidx).l
	bsr.w	NextArenaFrame
	bra.w	.lF218
.lF202	sub.w	d7,(arenaframetime).l
	bpl.w	.lF218
	addi.w	#$1,(arenaframeidx).l
	bsr.w	NextArenaFrame
.lF218	movem.l	(sp)+,d0-d7/a0-a6
.lF21C	rts
NextArenaFrame
	movea.l	(arenaframelist).l,a0
	move.w	(arenaframeidx).l,d0
	add.w	d0,d0
	move.b	(a0,d0.w),d1
	ext.w	d1
	move.w	d1,(arenaframe).l
	move.b	$1(a0,d0.w),d1
	ext.w	d1
	move.w	d1,(arenaframetime).l
	cmpi.w	#$FFFF,(arenaframe).l
	bne.w	.lF25A
	clr.w	(arenaframeidx).l
	bra.w	NextArenaFrame
.lF25A	cmpi.w	#$FFFE,(arenaframe).l
	bne.w	.lF26A
	bsr.w	X_F466
.lF26A	rts
	dc.w	$0002,$A3E4,$0004,$3A7E,$0002,$A398,$0004,$42A2
	dc.w	$0002,$A3BE,$0004,$42A2,$0002,$A386,$0004,$4FA8
	dc.w	$0002,$A330,$0004,$5A16,$0002,$A300,$0004,$5A16
	dc.w	$0002,$A2EA,$0004,$6942,$0002,$A2AC,$0004,$6942
	dc.w	$010A,$020A,$030A,$040A,$050A,$060A,$070A,$080A
	dc.w	$090A,$0A0A,$010A,$020A,$030A,$040A,$050A,$060A
	dc.w	$070A,$080A,$090A,$0A0A,$010A,$020A,$030A,$040A
	dc.w	$050A,$060A,$070A,$080A,$090A,$0A0A,$FE00,$010A
	dc.w	$020A,$030A,$040A,$050A,$060A,$070A,$080A,$090A
	dc.w	$0A0A,$FF00,$010A,$020A,$030A,$040A,$050A,$060A
	dc.w	$070A,$080A,$090A,$0A0A,$0B0A,$0C0A,$0D0A,$0E0A
	dc.w	$0F0A,$100A,$110A,$120A,$130A,$140A,$150A,$160A
	dc.w	$170A,$FE00,$0108,$0208,$033C,$043C,$033C,$043C
	dc.w	$033C,$043C,$033C,$043C,$033C,$043C,$033C,$043C
	dc.w	$033C,$043C,$033C,$043C,$033C,$043C,$033C,$043C
	dc.w	$033C,$043C,$033C,$043C,$033C,$043C,$033C,$043C
	dc.w	$033C,$043C,$033C,$043C,$033C,$043C,$033C,$043C
	dc.w	$033C,$043C,$0208,$0108,$FF00,$0108,$0208,$0308
	dc.w	$0408,$0508,$0608,$0708,$0808,$FF00,$0108,$0208
	dc.w	$0308,$041E,$0508,$0608,$0708,$081E,$0508,$0608
	dc.w	$0708,$081E,$0908,$0A08,$0B08,$0C08,$0D08,$0E08
	dc.w	$FE00,$0F08,$1008,$1108,$121E,$1308,$1408,$1508
	dc.w	$161E,$1308,$1408,$1508,$161E,$1708,$1808,$1908
	dc.w	$1A08,$1B08,$1C08,$FE00,$010A,$020A,$030A,$040A
	dc.w	$050A,$060A,$070A,$080A,$090A,$0A0A,$0B0A,$0C0A
	dc.w	$0D0A,$0E0A,$0F7F,$FE00,$08F9,$0006,$0001,$7F6A
	dc.w	$33FC,$0000,$0001,$7EDC,$33FC,$0160,$0001,$7EDE
	dc.w	$4E75
StartArenaAnim
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	d0,(arenaanim).l
	move.l	#tmshots,(arenaframelist).l
	move.l	#tmshots,(arenaspritelist).l
	move.w	#$1,(arenaframe).l
	clr.w	(arenaframeidx).l
	st.b	(faceoffanim).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
SetFaceoffAnim
	bset	#$0,$17F7A.l
	move.w	d0,(faceoffanim).l
	rts
	move.w	#$FFFF,(arenaanim).l
	bclr	#$0,$17F7A.l
	rts
ChooseSong
	movem.l	d0-d1/a0-a1,-(sp)
	btst	#$4,$17F68.l
	beq.w	.lF490
	move.w	#$FFFF,d1
	bra.w	.lF4D0
.lF490	bclr	#$6,$17F7C.l
	movea.l	#TeamSongs,a0
	movea.l	#RandomSongs,a1
	move.w	(HmTeam).l,d0
	mulu.w	#$6,d0
	add.w	(SongIndex).l,d0
	clr.w	d1
	move.b	(a0,d0.w),d1
	bne.w	.lF4D0
	move.w	#$8,d0
	jsr	(randomd0).l
	andi.w	#$7,d0
	move.b	(a1,d0.w),d1
.lF4D0	move.w	d1,(SongNum).l
	movem.l	(sp)+,d0-d1/a0-a1
	rts
	dc.w	$7775
ReadLineData
	moveq	#$0,d3
	addq.b	#$5,d0
	move.w	(a2,d3.w),-(a0)
	dc.w	$5A31,$3433
	dc.w	$3334,$5A00
	dc.w	$3537,$3537,$3636,$383A,$3938,$5A65
	dc.w	$4A4B
	dc.w	$4B00
	addq.b	#$5,d0
	move.w	#$3D00,-(a5)
	dc.w	$5A3C
	dc.w	$3E3F
	move.w	d0,-(sp)
	addq.b	#$5,d0
	dc.w	$7775
	moveq	#$0,d3
	addq.b	#$5,d0
	negx.w	d2
	dc.w	$4142
	addq.w	#$5,d0
	dc.w	$4343
	dc.w	$4544
	addq.w	#$5,d6
	dc.w	$4F4E
	dc.w	$4F4D
	addq.w	#$5,a4
	addq.w	#$8,(a1)
	addq.b	#$8,d0
	addq.w	#$5,(a2)
	dc.w	$4748
	dc.w	$4749
	addq.w	#$5,a1
	addq.w	#$2,(a5)
	subq.b	#$1,d0
	addq.b	#$5,d0
	dc.w	$7775
	moveq	#$0,d3
	addq.b	#$5,d0
	addq.w	#$3,(sp)
	addq.w	#$3,(a0)+
	ori.w	#$595B,(a0)+
	subq.w	#$4,(a4)+
	addq.w	#$5,(a4)+
	subq.w	#$6,(a6)+
	subq.b	#$6,d0
	addq.w	#$5,(a6)+
	subq.w	#$7,-(a0)
	dc.w	$6163
	dc.w	$6465
	beq.b	LF5BE
	dc.w	$6867
	addq.w	#$5,$6A6B(a1)
	bmi.w	X_14F5E
	bge.b	X_F5CE
	blt.w	X_14F64
	dc.w	$6E6F
	moveq	#$0,d0
	addq.b	#$5,d0
	dc.w	$7173
	dc.w	$7100
	dc.w	$5A74,$7775,$7600,$5A00
	addq.w	#$2,(a5)
	subq.b	#$1,d0
	addq.b	#$5,d0
	addq.w	#$2,(a5)
	subq.b	#$1,d0
	addq.b	#$5,d0
	movea.w	d0,a2
	dc.w	$4249
	addq.w	#$4,(a4)+
	bcs.b	X_F5F2
	movem.l	d0-d1/a0,-(sp)
	move.l	#$100,d1
	move.l	#$E20,d0
	movea.l	#$18C26,a0
	jsr	(ReadSRAM).l
	bclr	#$4,$17F6A.l
	move.w	#$FFFF,(lastsfx).l
	move.l	#M68K_RAM,(recbpr).l
	movem.l	(sp)+,d0-d1/a0
	dc.w	$4E75,$48E7,$C080,$223C,$0000,$0100,$203C,$0000
	dc.w	$0E20,$207C,$0001,$8C26,$4EB9,$0002,$246C,$08B9
	dc.w	$0004,$0001,$7F6A,$33FC,$FFFF,$0001,$7F64,$23FC
	dc.w	$0000,$C45C,$0001,$7470,$4CDF,$0103,$4E75,$48E7
	dc.w	$FFFE,$207C,$000B,$C000,$3E3C,$0007,$4228,$0008
	dc.w	$4228,$0009,$4228,$000A,$4228,$000B,$D0FC,$0010
	dc.w	$51CF,$FFEA,$203C,$0000,$0D20,$223C,$0000,$0080
	dc.w	$207C,$000B,$C000,$4EB9,$0002,$246C,$4CDF,$7FFF
	dc.w	$4E75
PSandSOpassdir
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(sopathdir).l,d0
	btst	#$7,$62(a3)
	bne.w	.lF668
	movea.l	#passdirlist,a0
	add.w	d0,d0
	move.w	(a0,d0.w),d0
.lF668	move.w	d0,(passdir).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.w	$0000,$0007,$0006,$0005,$0004,$0003,$0002,$0001
	dc.w	$0008
StartShootoutPath
	movem.l	d0-d7/a0-a6,-(sp)
.lF68A	move.w	#$7,d0
	jsr	(randomd0).l
	cmpi.w	#$6,d0
	bgt.w	.lF68A
	move.w	d0,(sopath).l
	bclr	#$3,$17F7A.l
	move.w	#$FFFF,$1A8B6.l
	clr.w	(sopathx).l
	bsr.w	X_F736
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.w	$0002,$A6DE,$0002,$A6EA,$0002,$A6FA,$0002,$A706
	dc.w	$0002,$A712,$0002,$A71E,$0002,$A72A,$0010,$00E2
	dc.w	$0010,$00D0,$8020,$0005,$FFC9,$00A0,$FFFF,$00C8
	dc.w	$FFE0,$00D0,$8020,$0005,$FFB0,$0040,$001A,$00BC
	dc.w	$8020,$0005,$FFCE,$0058,$0014,$00D0,$802C,$0005
	dc.w	$FFCE,$0008,$0020,$00D0,$8028,$0006,$001C,$00F4
	dc.w	$0008,$00E0,$8020,$0006,$FFE6,$00F8,$0000,$00E0
	dc.w	$8020,$0002,$48E7,$FFFE,$0C39,$0080,$0001,$A8B8
	dc.w	$6700,$006C,$0679,$0001,$0001,$A8B6,$3039,$0001
	dc.w	$A8B6,$E540,$207C,$0002,$A6C2,$3239,$0001,$A8B4
	dc.w	$E541,$2070,$1000,$33F0,$0000,$0001,$A8B8,$082B
	dc.w	$0000,$0076,$6700,$0008,$4479,$0001,$A8B8,$33F0
	dc.w	$0002,$0001,$A8BA,$0C30,$0080,$0004,$6600,$0020
	dc.w	$08F9,$0003,$0001,$7F7A,$4279,$0001,$A8BE,$13F0
	dc.w	$0005,$0001,$A8BF,$33F0,$0006,$0001,$A8BC,$4CDF
	dc.w	$7FFF,$4E75,$48E7,$3FFE,$0C39,$0080,$0001,$A8B8
	dc.w	$6700,$0080,$3039,$0001,$A8B8,$3239,$0001,$A8BA
	dc.w	$082B,$0007,$0062,$6600,$0006,$4440,$4441,$906B
	dc.w	$0000,$6A00,$0004,$4440,$4A6B,$0028,$6600,$0012
	dc.w	$4A6B,$002A,$6600,$000A,$0C40,$0012,$6F00,$000A
	dc.w	$0C40,$000A,$6E00,$0030,$926B,$0014,$6A00,$0004
	dc.w	$4441,$4A6B,$0028,$6600,$0012,$4A6B,$002A,$6600
	dc.w	$000A,$0C41,$0012,$6F00,$000A,$0C41,$000A,$6E00
	dc.w	$0006,$6100,$FF00,$3039,$0001,$A8B8,$3239,$0001
	dc.w	$A8BA,$4CDF,$7FFC,$4E75,$48E7,$FFFE,$0839,$0001
	dc.w	$0001,$7F78,$6700,$00A0,$302B,$0052,$B079,$0001
	dc.w	$7BE0,$6600,$0092,$0C79,$0003,$0001,$93B6,$6F00
	dc.w	$0080,$0C39,$0080,$0001,$A8B8,$6700,$0074,$0839
	dc.w	$0003,$0001,$7F7A,$6600,$0026,$4A79,$0001,$7BA8
	dc.w	$6600,$0064,$4A79,$0001,$7BAA,$6600,$005A,$0C79
	dc.w	$000F,$0001,$93B6,$6D00,$0048,$6000,$004A,$3039
	dc.w	$0001,$A8B8,$3239,$0001,$A8BA,$082B,$0007,$0062
	dc.w	$6600,$0006,$4440,$4441,$906B,$0000,$6A00,$0004
	dc.w	$4440,$926B,$0014,$6A00,$0004,$4441,$B079,$0001
	dc.w	$A8BE,$6E00,$0012,$B279,$0001,$A8BE,$6E00,$0008
	dc.w	$4240,$6000,$0006,$303C,$0001,$4CDF,$7FFF,$4E75
UnpackPicture						;Unpack a picture a2: count.w, then 3 bytes per row of 8 pixels to 4 bit
									;pixels + 5 at picturebuf (count first). Called from DrawPictureBox,
									;DrawMatchupPicture and PlayerCardScreen
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#picturebuf,a0
	movea.l	#picturebits,a1
	move.w	(a2)+,d0		;row count: first word of the picture
	move.w	d0,(a0)+
	asl.w	#$3,d0		;8 rows per tile
	subi.w	#$1,d0
.loop	clr.l	(a0)
	clr.l	(a1)
	move.b	(a2)+,(a1)
	move.b	(a2)+,$1(a1)
	move.b	(a2)+,$2(a1)
	move.l	#tmshots,-(sp)		;build the 8 pixels of 4 bits each, + 5 for the card palette
	move.l	(a1),d2
	andi.l	#$E0000000,d2		;pixel 0 (bits 31-29)
	lsr.l	#$1,d2
	addi.l	#$50000000,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$1C000000,d2		;pixel 1
	lsr.l	#$2,d2
	addi.l	#$5000000,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$3800000,d2		;pixel 2
	lsr.l	#$3,d2
	addi.l	#$500000,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$700000,d2		;pixel 3
	lsr.l	#$4,d2
	addi.l	#$50000,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$E0000,d2		;pixel 4
	lsr.l	#$5,d2
	addi.l	#$5000,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$1C000,d2		;pixel 5
	lsr.l	#$6,d2
	addi.l	#$500,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$3800,d2		;pixel 6
	lsr.l	#$7,d2
	addi.l	#$50,d2
	or.l	d2,(sp)
	move.l	(a1),d2
	andi.l	#$700,d2		;pixel 7
	move.w	#$8,d5
	lsr.l	d5,d2
	addi.l	#$5,d2
	or.l	d2,(sp)
	move.l	(sp)+,(a0)+
	dbra	d0,.loop
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.w	$3F00,$0444,$0018,$4A79,$0001,$7468,$6708,$2479
	dc.w	$0004,$7DA8,$6006,$2479,$0004,$7D90,$D4FC,$0008
	dc.w	$4EB9,$0003,$8958,$301F,$4E75
TeamGfxListEnd						;end of TeamGfxList (size check below)
	ori.b	#$23,d0
	ori.b	#$3C,d0
	ori.b	#$24,d0
	ori.b	#$25,d0
	ori.b	#$26,d0
	ori.b	#$27,d0
	ori.b	#$28,d0
	ori.b	#$29,d0
	ori.b	#$2A,d0
	ori.b	#$2B,d0
	ori.b	#$2C,d0
	ori.b	#$2D,d0
	ori.b	#$2E,d0
	ori.b	#$2F,d0
	ori.b	#$30,d0
	ori.b	#$31,d0
	ori.b	#$32,d0
	ori.b	#$33,d0
	ori.b	#$34,d0
	ori.b	#$35,d0
	ori.b	#$36,d0
	ori.b	#$37,d0
	ori.b	#$38,d0
	ori.b	#$39,d0
	ori.b	#$3A,d0
	ori.b	#$3B,d0
	dc.w	$0000,$003D,$0000,$003E,$48E7,$8020,$4EB9,$0003
	dc.w	$8F6E,$0004,$2028,$D4FC,$00D0,$6000,$0014,$48E7
	dc.w	$8020,$4EB9,$0003,$8F6E,$0004,$2028,$D4FC,$00B6
PrintParenNumber						;PrintPlayerAssists / PrintPlayerGoals: the number (1 to 3 digits,
									;PushNumberWidth) and ")"
	move.b	(a2,d0.w),d0
	ext.w	d0
	move.w	#$1,d1		;width 1 digit
	cmpi.w	#$9,d0		;over 9?
	ble.w	.0		;up to 9: 1 digit
	move.w	#$2,d1		;2 wide
	cmpi.w	#$63,d0		;up to 99: 2 digits
	ble.w	.0		;up to 99: 2 digits
	move.w	#$3,d1		;3 wide
.0	jsr	(PushNumberWidth).l
	jsr	(print).l
	jsr	(printz).l		;print ")"
	String	')'
	addi.w	#$1,(printy).l		;the next line of the goal box
	move.w	#$E,(printx).l
	movem.l	(sp)+,d0/a2
	rts
PlaceBoardFall						;A player falling into the boards (SPAboardfront ... SPAbenchcheckl). For
									;frames SPAboardfront / SPAboardback (y to $124 / $FEDC, or $116 / $FEEA
									;by FallXPos) and SPAboardright / SPAbenchcheckr / SPAboardleft /
									;SPAbenchcheckl (x to +-$82 / $88 by attribute bit 3) of SPA(a3): move
									;player a3 half way there. Called from updateplayers
	cmpi.w	#$193E,$58(a3)		;left bench check?
	beq.w	.12
	cmpi.w	#$1A00,$58(a3)		;right bench check?
	beq.w	.8
	cmpi.w	#$18CC,$58(a3)		;left boards?
	beq.w	.10
	cmpi.w	#$17E8,$58(a3)		;right boards?
	beq.w	.6
	cmpi.w	#$1776,$58(a3)		;front boards?
	beq.w	.0
	cmpi.w	#$185A,$58(a3)		;back boards?
	beq.w	.3
	bra.w	.x		;any other frame: nothing to move
.0	move.w	#$124,d0
	cmpi.w	#$56,$1937E.l		;right corner: closer wall
	bgt.w	.1
	cmpi.w	#$FFAA,$1937E.l		;middle: the full wall
	bgt.w	.2
.1	move.w	#$116,d0
.2	sub.w	$14(a3),d0
	bmi.w	.x		;already past it
	asr.w	#$1,d0
	add.w	d0,$14(a3)
	bra.w	.x
.3	move.w	#$FEDC,d0
	cmpi.w	#$56,$1937E.l		;right corner: closer wall
	bgt.w	.4
	cmpi.w	#$FFAA,$1937E.l		;middle: the full wall
	bgt.w	.5
.4	move.w	#$FEEA,d0
.5	sub.w	$14(a3),d0
	bpl.w	.x		;already past it
	asr.w	#$1,d0
	add.w	d0,$14(a3)
	bra.w	.x
.6	move.w	#$82,d0
	btst	#$3,$4(a3)		;attribute bit 3: the other wall
	beq.w	.7
	move.w	#$FF7E,d0
.7	sub.w	$0(a3),d0
	asr.w	#$1,d0
	add.w	d0,$0(a3)
	bra.w	.x
.8	move.w	#$88,d0		;bench wall X
	btst	#$3,$4(a3)		;attribute bit 3: the other side
	beq.w	.9
	move.w	#$FF78,d0		;other side
.9	sub.w	$0(a3),d0
	asr.w	#$1,d0
	add.w	d0,$0(a3)
	bra.w	.x
.10	move.w	#$FF7E,d0		;wall X
	btst	#$3,$4(a3)		;attribute bit 3: the other side
	beq.w	.11
	move.w	#$82,d0		;other side
.11	sub.w	$0(a3),d0
	asr.w	#$1,d0
	add.w	d0,$0(a3)
	bra.w	.x
.12	move.w	#$FF78,d0		;bench wall X
	btst	#$3,$4(a3)		;attribute bit 3: the other side
	beq.w	.13
	move.w	#$88,d0		;other side
.13	sub.w	$0(a3),d0
	asr.w	#$1,d0
	add.w	d0,$0(a3)
.x	rts
GetLeagueCrowdRecord						;d0 = the team (of NumTeams) with the highest crowd record (crpeak)
									;(ReadCrowdRecord; 0 counts as $50). Called from PrintCrowdMeter
	movem.l	d1-d7/a0-a6,-(sp)
	move.w	#$1B,d1
	ext.l	d1
	clr.w	d7		;d7 = highest so far
	movea.l	#ThreeStars,a0
.loop	jsr	(ReadCrowdRecord).l		;read team d1's records
	clr.w	d2
	move.b	$8(a0),d2
	bne.w	.0		;a record: use it
	move.w	#$50,d2		;none: $50 dB
.0	cmp.w	d7,d2		;higher?
	ble.w	.lFC32
	move.w	d2,d7
	move.w	d1,d0
.lFC32	dbra	d1,.loop
	movem.l	(sp)+,d1-d7/a0-a6
	rts
getFgtbyte						;d0 = fighting byte of a2 / 4. Called from setInjuryType
	clr.w	d0
	move.b	$74(a2),d0		;move H/F bit into d0 (this is always even)
	lsr.w	#$2,d0		;shift 2 right (divide by 4)
	rts
	btst	#$1,$74(a2)
	rts
RandomFaceoffAnim						;d0 = a random faceoff animation from FaceoffAnims, 6 when fox <= -$40 and
									;foy <= $C0. Called from puckfaceoff
	movem.l	a0,-(sp)
	movea.l	#FaceoffAnims,a0
	move.w	#$64,d0		;random 0-99
	jsr	(randomd0).l
	andi.w	#$7,d0
	add.w	d0,d0
	move.w	(a0,d0.w),d0		;the animation number
	cmpi.w	#$FFC0,$17EE2.l		;dropped left of center?
	bgt.w	.x		;puck dropped off center: keep the random one
	cmpi.w	#$C0,$17EE4.l		;dropped below?
	bgt.w	.x
	move.w	#$6,d0		;center ice: animation 6
.x	movem.l	(sp)+,a0
	rts
	dc.w	$0003,$0005,$0003,$0001,$0005,$0002,$0003,$0003
	dc.w	$FFFF
CheckScoreLeader						;Compare tmap (players on ice) of tmstruct / awtmstruct and test tmteam of
									;the team with more for $13 (SJ); the result is not used (bne.w *+4).
									;Called from puckfaceoff
	movem.l	d0-d2/a0-a2,-(sp)
	movea.l	#tmstruct,a0
	movea.l	#awtmstruct,a1
	move.w	$26(a0),d0		;home players on ice
	sub.w	$26(a1),d0
	beq.w	.x		;same number on the ice: done
	bpl.w	.0		;home has more: test home
	exg.l	a0,a1		;away has more: test the away team
.0	cmpi.w	#$13,$2A(a0)
	bne.w	.x		;(the branch goes to the next line either way)
.x	movem.l	(sp)+,d0-d2/a0-a2
	rts
DrawPlayoffSprite						;The StanleyCupSprite sprite at playoffspritex / playoffspritey in Satt,
									;then
									;end the sprite list (Sattsize = its size). Called from PlayoffScreen
	movea.l	#Satt,a6
	moveq	#$1,d6
	movea.l	(StanleyCupSprite).l,a0
	move.w	(energybarchars).l,d3
	ori.w	#$8000,d3		;high priority
	move.w	(playoffspritex).l,d0
	move.w	(playoffspritey).l,d1
	move.w	#$1,d2		;frame 1
	jsr	(SetSframe).l
	cmpa.l	#$BBD30,a6		;any drawn?
	bne.w	.0		;sprites drawn: end the list
	clr.l	(a6)+		;no sprite drawn: add an empty one
	clr.l	(a6)+
.0	clr.b	-$5(a6)
	move.l	a6,d0		;end of the list
	subi.l	#$BBD30,d0
	lsr.w	#$1,d0
	move.w	d0,(Sattsize).l
	rts
GetTeamStruct						;a2 = tmstruct, or awtmstruct when team d2 is not tmteam of tmstruct.
									;Called from PrintStartingLine
	movea.l	#tmstruct,a2
	cmp.w	$2A(a2),d2		;team d2 is the home team
	beq.w	.x
	movea.l	#awtmstruct,a2
.x	rts
	movem.l	d1/a0,-(sp)
	btst	#$0,$17F68.l
	bne.w	.lFD80
	move.w	(TempWord1).l,d1
	movea.l	#$1AD46,a0
	tst.w	d4
	beq.w	.lFD62
	movea.l	#$1AD4E,a0
.lFD62	addi.l	#$1,(a0)
	cmpi.w	#$8,d1
	beq.w	.lFD80
	cmp.w	$54(a3),d1
	beq.w	.lFD80
	addi.l	#$1,$4(a0)
.lFD80	movem.l	(sp)+,d1/a0
	rts
TerminateLogName						;Unreferenced. The GetLogName String at lognametext, ended with 0 at
									;namelength and its length word made even
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#lognametext,a1
	bsr.w	GetLogName-LOAD
	move.w	(namelength).l,d0
	move.b	#$0,(a1,d0.w)		;end the name with 0
	addi.w	#$1,d0
	andi.w	#$FFFE,d0		;length rounded to even
	move.w	d0,-$2(a1)
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.w	$48E7,$FFBE,$3039,$0001,$8BF4
PlayedByText						;PlayedByHome / PlayedByAway body
	tst.w	d0		;a user?
	beq.w	X_FE50		;no user: the empty String
	movea.l	#$1A37E,a1		;the name after a length word
	move.w	d0,(namelogsel).l
	bsr.w	GetLogName-LOAD
	adda.w	(namelength).l,a1		;end the name with 0
	move.b	#$0,(a1)
	addi.w	#$1,(namelength).l
	andi.w	#$FFFE,(namelength).l		;rounded to even
	addi.w	#$2,(namelength).l		;rounded to even + the header
	move.w	(namelength).l,$1A37C.l
	movea.l	#$1A37C,a1
	move.l	a1,-(sp)
	movea.l	#TempBuffer,a3
	movea.l	#PlayedByTxt,a1		;"(played by " then the name and ")"
	bsr.w	CopyString-LOAD		;copy "(played by "
	movea.l	(sp)+,a1
	movea.l	#TempBuffer,a3
	jsr	(appstring).l		;append the name
	movea.l	#TempBuffer,a3
	jsr	(appendz).l
	String	')'
	movea.l	#TempBuffer,a1		;a1 = the String
	dc.w	$4CDF,$7DFF,$4E75,$000E,$2870,$6C61,$7965,$6420
	dc.w	$6279,$2000,$0002,$227C,$0002,$AE4E,$6000,$FFE2
	dc.w	$48E7,$FFBE,$3039,$0001,$8BF6,$6000,$FF56,$6000
	dc.w	$000E,$08B9,$0001,$0001,$7F7C,$6000,$000A,$08F9
	dc.w	$0001,$0001,$7F7C,$4E75,$0C40,$0032,$6C00,$0008
	dc.w	$E240,$0640,$0019,$4E75,$48A7,$C000,$3039,$0001
	dc.w	$7B80,$906B,$0000,$0C40,$001E,$6E00,$0030,$3239
	dc.w	$0001,$7BA8,$B340,$0240,$8000,$6700,$0020,$3039
	dc.w	$0001,$7B94,$906B,$0014,$0C40,$001E,$6E00,$000E
	dc.w	$3239,$0001,$7BAA,$B340,$0240,$8000,$4C9F,$0003
	dc.w	$4E75
ReadGoaliePulled
	movem.l	a1,-(sp)
	movea.l	#tmstruct,a1
	btst	#$6,$62(a3)
	beq.w	.lFEF6
	movea.l	#awtmstruct,a1
.lFEF6	tst.w	$28(a1)
	movem.l	(sp)+,a1
	rts
