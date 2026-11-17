	include	segacd\hockey.inc
	include	macros\genesis.mac

ArenaAnims	equ	$2A26C
CopyString	equ	$25818
DecompressGraphicsPlain	equ	$38958
FaceoffAnims	equ	$2AC8E
HmTeam	equ	$1A56C
LOAD	equ	$1B000
PlayedByTxt	equ	$2AE40
PushNumberWidth	equ	$3919A
RandomSongs	equ	$2A584
ReadCrowdRecord	equ	$2258E
Satt	equ	$BBD30
Sattsize	equ	$17F66
SetSframe	equ	$3E028
SongIndex	equ	$1A56E
SongNum	equ	$1A56A
StanleyCupSprite	equ	$47D94
TeamSongs	equ	$2A4DC
TempBuffer	equ	$17E70
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
printz	equ	$38F6E
randomd0	equ	$37050
sopath	equ	$1A8B4
sopathdir	equ	$1A8BC
sopathx	equ	$1A8B8
tmshots	equ	$0
tmstruct	equ	$1834C
X_BE0E	equ	$BE0E
X_F466	equ	$F466
X_F736	equ	$F736
X_FE50	equ	$FE50

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
	dc.w	$08F9,$0000,$0001,$7F7A,$33C0,$0001,$A560,$4E75
	dc.w	$33FC,$FFFF,$0001,$A556,$08B9,$0000,$0001,$7F7A
	dc.w	$4E75
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
	dc.w	$7600,$5A00,$3132,$3000,$5A31,$3433,$3334,$5A00
	dc.w	$3537,$3537,$3636,$383A,$3938,$5A65,$4A4B,$4B00
	dc.w	$5A00,$3B3C,$3D00,$5A3C,$3E3F,$3F00,$5A00,$7775
	dc.w	$7600,$5A00,$4042,$4142,$5A40,$4343,$4544,$5A46
	dc.w	$4F4E,$4F4D,$5A4C,$5051,$5000,$5A52,$4748,$4749
	dc.w	$5A49,$5455,$5300,$5A00,$7775,$7600,$5A00,$5657
	dc.w	$5658,$0058,$595B,$595C,$5A5C,$5D5E,$5D00,$5A5E
	dc.w	$5F60,$6163,$6465,$6768,$6867,$5A69,$6A6B,$6B00
	dc.w	$5A00,$6C6C,$6D00,$5A00,$6E6F,$7000,$5A00,$7173
	dc.w	$7100,$5A74,$7775,$7600,$5A00,$5455,$5300,$5A00
	dc.w	$5455,$5300,$5A00,$3440,$4249,$585C,$6566,$48E7
	dc.w	$C080,$223C,$0000,$0100,$203C,$0000,$0E20,$207C
	dc.w	$0001,$8C26,$4EB9,$0002,$2452,$08B9,$0004,$0001
	dc.w	$7F6A,$33FC,$FFFF,$0001,$7F64,$23FC,$0000,$C45C
	dc.w	$0001,$7470,$4CDF,$0103,$4E75,$48E7,$C080,$223C
	dc.w	$0000,$0100,$203C,$0000,$0E20,$207C,$0001,$8C26
	dc.w	$4EB9,$0002,$246C,$08B9,$0004,$0001,$7F6A,$33FC
	dc.w	$FFFF,$0001,$7F64,$23FC,$0000,$C45C,$0001,$7470
	dc.w	$4CDF,$0103,$4E75,$48E7,$FFFE,$207C,$000B,$C000
	dc.w	$3E3C,$0007,$4228,$0008,$4228,$0009,$4228,$000A
	dc.w	$4228,$000B,$D0FC,$0010,$51CF,$FFEA,$203C,$0000
	dc.w	$0D20,$223C,$0000,$0080,$207C,$000B,$C000,$4EB9
	dc.w	$0002,$246C,$4CDF,$7FFF,$4E75
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
	dc.w	$4EB9,$0003,$8958,$301F,$4E75,$0000,$0023,$0000
	dc.w	$003C,$0000,$0024,$0000,$0025,$0000,$0026,$0000
	dc.w	$0027,$0000,$0028,$0000,$0029,$0000,$002A,$0000
	dc.w	$002B,$0000,$002C,$0000,$002D,$0000,$002E,$0000
	dc.w	$002F,$0000,$0030,$0000,$0031,$0000,$0032,$0000
	dc.w	$0033,$0000,$0034,$0000,$0035,$0000,$0036,$0000
	dc.w	$0037,$0000,$0038,$0000,$0039,$0000,$003A,$0000
	dc.w	$003B,$0000,$003D,$0000,$003E,$48E7,$8020,$4EB9
	dc.w	$0003,$8F6E,$0004,$2028,$D4FC,$00D0,$6000,$0014
	dc.w	$48E7,$8020,$4EB9,$0003,$8F6E,$0004,$2028,$D4FC
	dc.w	$00B6
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
	dc.w	$0679,$0001,$0001,$8D5A,$33FC,$000E,$0001,$8D58
	dc.w	$4CDF,$0401,$4E75,$0C6B,$193E,$0058,$6700,$00FC
	dc.w	$0C6B,$1A00,$0058,$6700,$00B2,$0C6B,$18CC,$0058
	dc.w	$6700,$00C8,$0C6B,$17E8,$0058,$6700,$007E,$0C6B
	dc.w	$1776,$0058,$6700,$0010,$0C6B,$185A,$0058,$6700
	dc.w	$0038,$6000,$00E2,$303C,$0124,$0C79,$0056,$0001
	dc.w	$937E,$6E00,$000E,$0C79,$FFAA,$0001,$937E,$6E00
	dc.w	$0006,$303C,$0116,$906B,$0014,$6B00,$00BA,$E240
	dc.w	$D16B,$0014,$6000,$00B0,$303C,$FEDC,$0C79,$0056
	dc.w	$0001,$937E,$6E00,$000E,$0C79,$FFAA,$0001,$937E
	dc.w	$6E00,$0006,$303C,$FEEA,$906B,$0014,$6A00,$0088
	dc.w	$E240,$D16B,$0014,$6000,$007E,$303C,$0082,$082B
	dc.w	$0003,$0004,$6700,$0006,$303C,$FF7E,$906B,$0000
	dc.w	$E240,$D16B,$0000,$6000,$005E,$303C,$0088,$082B
	dc.w	$0003,$0004,$6700,$0006,$303C,$FF78,$906B,$0000
	dc.w	$E240,$D16B,$0000,$6000,$003E,$303C,$FF7E,$082B
	dc.w	$0003,$0004,$6700,$0006,$303C,$0082,$906B,$0000
	dc.w	$E240,$D16B,$0000,$6000,$001E,$303C,$FF78,$082B
	dc.w	$0003,$0004,$6700,$0006,$303C,$0088,$906B,$0000
	dc.w	$E240,$D16B,$0000,$4E75
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
	dc.w	$4240,$102A,$0074,$E448,$4E75,$082A,$0001,$0074
	dc.w	$4E75
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
	dc.w	$247C,$0001,$834C,$B46A,$002A,$6700,$0008,$247C
	dc.w	$0001,$86B2,$4E75,$48E7,$4080,$0839,$0000,$0001
	dc.w	$7F68,$6600,$0038,$3239,$0001,$7E62,$207C,$0001
	dc.w	$AD46,$4A44,$6700,$0008,$207C,$0001,$AD4E,$0690
	dc.w	$0000,$0001,$0C41,$0008,$6700,$0012,$B26B,$0054
	dc.w	$6700,$000A,$06A8,$0000,$0001,$0004,$4CDF,$0102
	dc.w	$4E75
TerminateLogName						;Unreferenced. The GetLogName String at lognametext, ended with 0 at
									;namelength and its length word made even
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#lognametext,a1
	bsr.w	X_BE0E
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
	bsr.w	X_BE0E
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
	dc.w	$227C,$0001,$7E70,$4CDF,$7DFF,$4E75,$000E,$2870
	dc.w	$6C61,$7965,$6420,$6279,$2000,$0002,$227C,$0002
	dc.w	$AE4E,$6000,$FFE2,$48E7,$FFBE,$3039,$0001,$8BF6
	dc.w	$6000,$FF56,$6000,$000E,$08B9,$0001,$0001,$7F7C
	dc.w	$6000,$000A,$08F9,$0001,$0001,$7F7C,$4E75,$0C40
	dc.w	$0032,$6C00,$0008,$E240,$0640,$0019,$4E75,$48A7
	dc.w	$C000,$3039,$0001,$7B80,$906B,$0000,$0C40,$001E
	dc.w	$6E00,$0030,$3239,$0001,$7BA8,$B340,$0240,$8000
	dc.w	$6700,$0020,$3039,$0001,$7B94,$906B,$0014,$0C40
	dc.w	$001E,$6E00,$000E,$3239,$0001,$7BAA,$B340,$0240
	dc.w	$8000,$4C9F,$0003,$4E75
ReadGoaliePulled
	movem.l	a1,-(sp)
	movea.l	#tmstruct,a1
	btst	#$6,$62(a3)
	beq.w	.lFEF6
	movea.l	#awtmstruct,a1
.lFEF6	tst.w	$28(a1)
	movem.l	(sp)+,a1
	rts
