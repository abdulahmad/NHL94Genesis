	include	segacd\hockey.inc
	include	macros\genesis.mac

Arrowsmap	equ	$47D50
CC_Font3Pal3	equ	$CD
DecompressGraphicsPlain	equ	$38958
DoDMA_nd2	equ	$379D6
ExtraChars	equ	$18D56
HomeTeam	equ	$17FAE
LOAD	equ	$1B000
OldVcount	equ	$17476
OptLine	equ	$18C0A
PlayerScrollCtr	equ	$1A452
ScoutSubStatus	equ	$17474
SortCords	equ	$17480
Teamblocksmap	equ	$47D44
VisTeam	equ	$17FB0
awayhotcoldsave	equ	$1A714
awtmstruct	equ	$186B2
basetileoffset	equ	$18D52
dobitmap	equ	$387E2
gamelevel	equ	$18A9E
homehotcoldsave	equ	$1A574
mesarea	equ	$17EF2
move	equ	$2C9C8
null	equ	$1B008
page	equ	$27DB0
palcount	equ	$18D62
playoffspritex	equ	$17CE4
potreeteam	equ	$18AA0
print	equ	$38F80
printa	equ	$18D5C
printsmall	equ	$38D9E
printx	equ	$18D58
printz	equ	$38F6E
scoutcolumn	equ	$1A44E
swap	equ	$2779A
tmstruct	equ	$1834C
X_21000	equ	$21000
X_21EC6	equ	$21EC6
X_241F6	equ	$241F6
X_245C6	equ	$245C6
X_24832	equ	$24832

	org	$2391C

	dc.w	$48E7,$FFFE,$08F9,$0001,$0001,$8D64,$33FC,$C000
	dc.w	$0001,$8D38,$33FC,$0006,$0001,$8D3A,$33FC,$DC00
	dc.w	$0001,$8D32,$33FC,$E000,$0001,$8D34,$33FC,$0006
	dc.w	$0001,$8D36,$33FC,$F000,$0001,$8D3C,$33FC,$0005
	dc.w	$0001,$8D3E,$33FC,$FC00,$0001,$8D30,$7000,$6100
	dc.w	$91EE,$08B9,$0000,$0001,$7F6A,$3F39,$0001,$8D64
	dc.w	$08F9,$0002,$0001,$8D64,$4279,$0001,$7CEE,$4279
	dc.w	$0001,$7CEA,$33FC,$07D0,$0001,$7CEC,$50F9,$0001
	dc.w	$7CE2,$303C,$0800,$3239,$0001,$8D34,$343C,$07FF
	dc.w	$6100,$90F4,$4244,$33C4,$0001,$8D48,$2479,$0004
	dc.w	$7D18,$508A,$0839,$0004,$0001,$7F72,$6700,$000A
	dc.w	$2479,$0004,$7D64,$508A,$6100,$9F82,$4EB9,$0002
	dc.w	$A9D0,$33C4,$0001,$8D50,$6100,$0292,$33C4,$0001
	dc.w	$8D46,$2479,$0004,$7D40,$508A,$6100,$9F60,$33C4
	dc.w	$0001,$8D4A,$2479,$0004,$7D2C,$508A,$6100,$9F4E
	dc.w	$33C4,$0001,$A54E,$0644,$0032,$33C4,$0001,$8D54
	dc.w	$6100,$037C,$33C4,$0001,$8C1C,$6100,$0238,$6100
	dc.w	$A9CE,$33C4,$0001,$8D42,$2479,$0004,$7D3C,$508A
	dc.w	$6100,$9F08,$4343,$4567,$89AB,$CDEF,$33C4,$0001
	dc.w	$8D40,$2479,$0004,$7D38,$508A,$6100,$9EEE,$7123
	dc.w	$4567,$89AB,$CDEF,$6100,$029C,$33C4,$0001,$8D56
	dc.w	$0839,$0001,$0001,$7F68,$6700,$0018,$267C,$0001
	dc.w	$7480,$700B,$086B,$0007,$0062,$D6FC,$0080,$51C8
	dc.w	$FFF4,$6100,$07BC,$33FC,$FFFF,$0001,$7DC8,$33FC
	dc.w	$FFFF,$0001,$7DD6,$42B9,$0001,$7DCA,$42B9,$0001
	dc.w	$7DCE,$42B9,$0001,$7DD2,$50F9,$0001,$7F9E,$50F9
	dc.w	$0001,$7FA0,$2A7C,$0001,$8D6A,$2C7C,$000B,$BD30
	dc.w	$7C01,$267C,$0001,$7D04,$4240,$4241,$6100,$FC0C
	dc.w	$D6FC,$001C,$6100,$FC04,$D6FC,$001C,$6100,$FBFC
	dc.w	$D6FC,$001C,$6100,$FBF4,$D6FC,$001C,$6100,$FBEC
	dc.w	$D6FC,$001C,$6100,$FBE4,$23CD,$0001,$91CA,$6100
	dc.w	$F0E4,$33DF,$0001,$8D64,$23FC,$0003,$DAB8,$0001
	dc.w	$8D66,$08B9,$0000,$0001,$8D64,$08B9,$0002,$0001
	dc.w	$8D64,$08F9,$0005,$00FF,$800F,$4CDF,$7FFF,$4E75
	dc.w	$48E7,$FFFE,$4EB9,$0003,$6D0A,$08B9,$0000,$0001
	dc.w	$7F6A,$3F39,$0001,$8D64,$08F9,$0002,$0001,$8D64
	dc.w	$4279,$0001,$7CEE,$4279,$0001,$7CEA,$33FC,$07D0
	dc.w	$0001,$7CEC,$50F9,$0001,$7CE2,$3839,$0001,$8D54
	dc.w	$6100,$021C,$6100,$00DE,$0839,$0001,$0001,$7F68
	dc.w	$6700,$0018,$267C,$0001,$7480,$700B,$086B,$0007
	dc.w	$0062,$D6FC,$0080,$51C8,$FFF4,$6100,$06A4,$33FC
	dc.w	$FFFF,$0001,$7DC8,$33FC,$FFFF,$0001,$7DD6,$42B9
	dc.w	$0001,$7DCA,$42B9,$0001,$7DCE,$42B9,$0001,$7DD2
	dc.w	$50F9,$0001,$7F9E,$50F9,$0001,$7FA0,$6100,$009E
	dc.w	$2A7C,$0001,$8D6A,$2C7C,$000B,$BD30,$7C01,$267C
	dc.w	$0001,$7D04,$4240,$4241,$6100,$FAF0,$D6FC,$001C
	dc.w	$6100,$FAE8,$D6FC,$001C,$6100,$FAE0,$D6FC,$001C
	dc.w	$6100,$FAD8,$D6FC,$001C,$6100,$FAD0,$D6FC,$001C
	dc.w	$6100,$FAC8,$23CD,$0001,$91CA,$6100,$EFC8,$33FC
	dc.w	$001C,$0001,$8D62,$33DF,$0001,$8D64,$23FC,$0003
	dc.w	$DAB8,$0001,$8D66,$08B9,$0000,$0001,$8D64,$08B9
	dc.w	$0002,$0001,$8D64,$08F9,$0005,$00FF,$800F,$4CDF
	dc.w	$7FFF,$4E75,$2079,$0004,$7D18,$D1D0,$700F,$227C
	dc.w	$000B,$BCB0,$22D8,$51C8,$FFFC,$4E75,$3839,$0001
	dc.w	$8D50,$2479,$0004,$7D4C,$508A,$6100,$9CBE,$7123
	dc.w	$4567,$89AB,$CDEF,$4E75,$3839,$0001,$8D46,$2479
	dc.w	$0004,$7D40,$508A,$6000,$9CB4,$3839,$0001,$8D4A
	dc.w	$2479,$0004,$7D2C,$508A,$6000,$9CA2,$3839,$0001
	dc.w	$8D56,$2479,$0004,$7D20,$508A,$6000,$9C90,$3839
	dc.w	$0001,$8D56,$2479,$0004,$7D1C,$508A,$6000,$9C7E
	dc.w	$3839,$0001,$8D4C,$2479,$0004,$7D30,$508A,$6000
	dc.w	$9C6C,$3839,$0001,$8D56,$2479,$0004,$7D14,$508A
	dc.w	$6000,$9C5A
setupTeamBlocksMap						;Load the TeamBlocks map tiles (Teamblocksmap) at d4+$2C and copy the home
									;and visitor team blocks to vram at basetileoffset and basetileoffset+$16.
									;d4 = 1st vram char; return d4 = basetileoffset+$2C. Called from setupice
	move.w	d4,(basetileoffset).l
	addi.w	#$2C,d4
	movea.l	#$17FB2,a1		;map word buffer for CopyTeamBlockMapData
	movea.l	(Teamblocksmap).l,a0
	lea.l	$8(a0),a2
	bsr.w	DecompressGraphicsPlain-LOAD		;all team block tiles to vram at d4
	adda.l	$4(a0),a0
	move.l	a0,-(sp)
	move.w	(HomeTeam).l,d0
	move.w	(basetileoffset).l,d1
	asl.w	#$5,d1		;vram address of char
	bsr.w	CopyTeamBlockMapData		;home blocks at basetileoffset
	movea.l	(sp)+,a0
	move.w	(VisTeam).l,d0
	move.w	(basetileoffset).l,d1
	addi.w	#$16,d1		;22 chars ($16) after the home blocks
	asl.w	#$5,d1		;vram address of char
	bsr.w	CopyTeamBlockMapData
	move.w	(basetileoffset).l,d4		;d4 = first char after both teams' blocks
	addi.w	#$2C,d4
	rts
CopyTeamBlockMapData						;Copy one team's 22 block chars from the loaded tile set to vram at d1 by
									;vram dma (DoDMA_nd2), and store their map words at (a1)+. a0 = map data,
									;d0 = team, d1 = vram address
	mulu.w	#$2C,d0
	lea.l	$4(a0,d0.w),a0
	move.w	#$15,d3
.row	moveq	#$20,d0		;32 bytes per char
	move.w	d1,-(sp)
	move.b	(a0),(a1)		;keep the map word flag bits
	andi.w	#$F800,(a1)
	lsr.w	#$5,d1		;vram address back to char number
	ori.w	#$8000,d1		;priority
	or.w	d1,(a1)+
	move.w	(sp)+,d1
	move.w	(a0)+,d2
	andi.w	#$7FF,d2		;source char in the loaded tile set
	add.w	(basetileoffset).l,d2
	addi.w	#$2C,d2
	asl.w	#$5,d2		;source vram address
	bsr.w	DoDMA_nd2-LOAD		;vram to vram copy
	addi.w	#$20,d1
	dbra	d3,.row
	rts
	dc.w	$247C,$0003,$EE08,$267C,$0001,$7DD8,$7003,$377C
	dc.w	$FFFF,$0008,$375A,$0000,$375A,$0002,$375A,$0006
	dc.w	$375A,$0004,$3744,$0012,$D85A,$D6FC,$0014,$51C8
	dc.w	$FFDE,$247C,$0003,$EE30,$267C,$0001,$7D04,$203C
	dc.w	$0000,$0006,$50EB,$0008,$375A,$0000,$375A,$0014
	dc.w	$375A,$0018,$375A,$0006,$375A,$0004,$3744,$0012
	dc.w	$D85A,$D6FC,$001C,$51C8,$FFDC,$6000,$007E,$0000
	dc.w	$0000,$0000,$0000,$0009,$0000,$0000,$0000,$0000
	dc.w	$0009,$0000,$0000,$0000,$0000,$0009,$0000,$0000
	dc.w	$0000,$0000,$0009,$0000,$0000,$FFFF,$0188,$0000
	dc.w	$0007,$0000,$0000,$FFFF,$0186,$0000,$0007,$0000
	dc.w	$0000,$FFFF,$0187,$0000,$0007,$0000,$0000,$FFFF
	dc.w	$0189,$8000,$0007,$0000,$0000,$FFFF,$034C,$0000
	dc.w	$0007,$0000,$0000,$FFFF,$034D,$0000,$0007,$0000
	dc.w	$0000,$FFFF,$0161,$0000,$0005,$4246,$227C,$0001
	dc.w	$7CC0,$45FA,$0070,$267C,$0001,$7480,$287C,$0001
	dc.w	$7CA0,$701F,$204B,$4298,$51C8,$FFFC,$3746,$0052
	dc.w	$50EB,$0008,$50EB,$0066,$375A,$0000,$375A,$0014
	dc.w	$375A,$0018,$375A,$0006,$375A,$0004,$3744,$0012
	dc.w	$D85A,$375A,$004A,$375A,$004C,$D4FC,$0001,$175A
	dc.w	$0038,$D4FC,$0001,$175A,$0062,$D6FC,$0080,$E346
	dc.w	$12C6,$E24E,$38C6,$5246,$0C46,$0010,$6600,$FFA4
	dc.w	$6000,$0142,$0180,$00C0,$0000,$0001,$0000,$0014
	dc.w	$0008,$0004,$0000,$0080,$FF38,$FF9C,$0000,$0001
	dc.w	$0000,$0014,$0008,$0004,$0000,$0080,$FF38,$FFB0
	dc.w	$0000,$0001,$0000,$0014,$0008,$0004,$0000,$0080
	dc.w	$FF38,$FFC4,$0000,$0001,$0000,$0014,$0008,$0004
	dc.w	$0000,$0080,$FF38,$FFD8,$0000,$0001,$0000,$0014
	dc.w	$0008,$0004,$0000,$0080,$FF38,$FFEC,$0000,$0001
	dc.w	$0000,$0014,$0008,$0004,$0000,$0080,$00C0,$00C0
	dc.w	$0000,$0001,$0001,$0014,$0008,$0004,$0000,$0040
	dc.w	$FF38,$0028,$0000,$0001,$0001,$0014,$0008,$0004
	dc.w	$0000,$0040,$FF38,$003C,$0000,$0001,$0001,$0014
	dc.w	$0008,$0004,$0000,$0040,$FF38,$0050,$0000,$0001
	dc.w	$0001,$0014,$0008,$0004,$0000,$0040,$FF38,$0064
	dc.w	$0000,$0001,$0001,$0014,$0008,$0004,$0000,$0040
	dc.w	$FF38,$0078,$0000,$0001,$0001,$0014,$0008,$0004
	dc.w	$0000,$0040,$0000,$010C,$0000,$0195,$0000,$000B
	dc.w	$0014,$0006,$0000,$0000,$0000,$FEF4,$0000,$0196
	dc.w	$0000,$0011,$0014,$0006,$0000,$0000,$0000,$0000
	dc.w	$0000,$018B,$0000,$0001,$0005,$0005,$0018,$0001
	dc.w	$0000,$0000,$0000,$018A,$0000,$0011,$0003,$0003
	dc.w	$0019,$0004,$48E7,$F8E0,$247C,$0001,$7CA0,$227C
	dc.w	$0001,$7C80,$207C,$0001,$7480,$363C,$000F,$3828
	dc.w	$0014,$0839,$0007,$0001,$7F6A,$6700,$0006,$3828
	dc.w	$0000,$32C4,$D0FC,$0080,$51CB,$FFE4,$227C,$0001
	dc.w	$7C80,$4244,$207C,$0001,$7CC0,$363C,$000E,$4240
	dc.w	$4241,$1018,$1210,$3431,$0000,$B471,$1000,$6F00
	dc.w	$001C,$1080,$1141,$FFFF,$2408,$0482,$0001,$7CC0
	dc.w	$3582,$0000,$5342,$3582,$1000,$50C4,$51CB,$FFD4
	dc.w	$4A44,$6600,$FFBE,$4CDF,$071F,$4E75,$48E7,$E0F0
	dc.w	$247C,$0001,$834C,$6100,$0012,$247C,$0001,$86B2
	dc.w	$6100,$0008,$4CDF,$0F07,$4E75,$08AA,$0004,$0032
	dc.w	$7405,$266A,$0022,$422B,$0063,$4A6B,$0034,$6B00
	dc.w	$001A,$323C,$050C,$4EB9,$0003,$63C0,$426B,$0032
	dc.w	$422B,$005E,$022B,$00C2,$0062,$D6FC,$0080,$51CA
	dc.w	$FFD6,$4E75
clearTeamStats						;clear both team structs (2 x tmsize) but keep each hot / cold table
									;(tmHotCold, saved to
									;homehotcoldsave / awayhotcoldsave and back) and tmstruct+tmgoalie /
									;awtmstruct+tmgoalie. Falls into setteams
	move.w	$18374.l,-(sp)		;keep the home goalie
	move.w	$186DA.l,-(sp)		;keep the away goalie
	movem.l	a1-a3,-(sp)
	move.w	#$19F,d0		;hot / cold table bytes - 1
	movea.l	#$18856,a1		;Hot/Cold table Away Team
	movea.l	#$184F0,a0		;Hot/Cold table Home Team
	movea.l	#homehotcoldsave,a2
	movea.l	#awayhotcoldsave,a3
.loop	move.b	(a0)+,(a2)+
	move.b	(a1)+,(a3)+
	dbra	d0,.loop
	movem.l	(sp)+,a1-a3
	move.l	#$365,d0
	movea.l	#tmstruct,a0
.loop2	clr.b	(a0)+
	dbra	d0,.loop2
	movea.l	#awtmstruct,a0
	move.w	#$365,d0
.loop3	clr.b	(a0)+
	dbra	d0,.loop3
	movem.l	a1-a3,-(sp)
	move.w	#$19F,d0		;hot / cold table bytes - 1
	movea.l	#$18856,a1
	movea.l	#$184F0,a0
	movea.l	#homehotcoldsave,a2
	movea.l	#awayhotcoldsave,a3
.loop4	move.b	(a2)+,(a0)+
	move.b	(a3)+,(a1)+
	dbra	d0,.loop4
	movem.l	(sp)+,a1-a3
	move.w	(sp)+,$186DA.l
	move.w	(sp)+,$18374.l
	st.b	$183E8.l
	st.b	$1874E.l
setteams						;Use hometeam/visteam to set team structures (InitTeamStructure for each).
									;Falls in from clearTeamStats, also called from TeamIcons
	movem.l	d0/a0-a2,-(sp)
	movea.l	#tmstruct,a2
	move.w	(HomeTeam).l,d0
	move.l	#SortCords,$22(a2)		;home players: the first 6 sort objects
	bsr.w	X_241F6
	movea.l	#awtmstruct,a2
	move.w	(VisTeam).l,d0
	move.l	#$17780,$22(a2)		;away players: the next 6 sort objects
	bsr.w	X_241F6
	movem.l	(sp)+,d0/a0-a2
	rts
	dc.w	$3540,$002A,$207C,$0001,$B00C,$E540,$2570,$0000
	dc.w	$001E
CopyTeamLines						;'Set Original lines' (line editor exit menu): copy the team data line
									;sets to tmlines
	tst.w	(OptLine).l		;line changes On (0)?
	beq.w	.0
	movea.l	$1E(a2),a0
	adda.w	$6(a0),a0
	lea.l	$16C(a2),a1
	move.l	(a0)+,(a1)+		;line 1: the no-line-change line
	move.l	(a0)+,(a1)+
	adda.w	#$8,a0		;skip line 2 (Sc1)
	move.w	#$B,d0		;lines 3-8
.loop	move.l	(a0)+,(a1)+
	dbra	d0,.loop
	rts
.0	moveq	#$D,d0		;14 longs
	movea.l	$1E(a2),a0
	adda.w	$6(a0),a0
	adda.w	#$8,a0		;skip line 1 (the no-line-change line)
	lea.l	$16C(a2),a1
.copy	move.l	(a0)+,(a1)+
	dbra	d0,.copy
	rts
	dc.w	$4241,$0C79,$0013,$0001,$7FB0,$6700,$0012,$0C79
	dc.w	$0013,$0001,$7FAE,$6700,$0006,$6000,$000A,$33FC
	dc.w	$0860,$000B,$BCDC,$207C,$0001,$834C,$6100,$0008
	dc.w	$7220,$D0FC,$0366,$2468,$001E,$D4EA,$0002,$D4C1
	dc.w	$227C,$000B,$BCF0,$D2C1,$7007,$22DA,$51C8,$FFFC
	dc.w	$4E75,$6100,$13BC,$4A79,$0001,$8BFA,$6700,$0010
	dc.w	$08B9,$0001,$0001,$7F6A,$4EB9,$0002,$DE18,$6100
	dc.w	$0080,$4A79,$0001,$91CE,$660C,$33FC,$0001,$0003
	dc.w	$FC0A,$6100,$093C,$6000,$0008,$4EB9,$0004,$8208
	dc.w	$4EB9,$0004,$8208,$08B9,$0005,$00FF,$800F,$2E7C
	dc.w	$0000,$C458,$207C,$0001,$745C,$4298,$B1FC,$0001
	dc.w	$8BF0,$6D00,$FFF6,$23FC,$0003,$DB90,$0001,$8D66
	dc.w	$08F9,$0005,$00FF,$800F,$4EB9,$0002,$33CC,$4EB9
	dc.w	$0002,$702C,$6100,$001A,$0839,$0000,$0001,$7F78
	dc.w	$6600,$0008,$4EB9,$0002,$82B6,$4EF9,$0002,$B7F8
	dc.w	$4A79,$0001,$91CE,$660C,$33FC,$0000,$0003,$FC0A
	dc.w	$6100,$08BE,$08B9,$0005,$00FF,$800F,$4A79,$0001
	dc.w	$8BFA,$6700,$CCA0,$23FC,$0003,$F78E,$0001,$8D66
	dc.w	$08F9,$0005,$00FF,$800F,$08B9,$0001,$0001,$8D64
	dc.w	$33FC,$0000,$0001,$8D30,$33FC,$BC00,$0001,$8D32
	dc.w	$33FC,$B000,$0001,$8D3C,$33FC,$0006,$0001,$8D3E
	dc.w	$33FC,$C000,$0001,$8D38,$33FC,$0007,$0001,$8D3A
	dc.w	$33FC,$E000,$0001,$8D34,$33FC,$0007,$0001,$8D36
	dc.w	$303C,$0000,$6100,$8798,$6100,$9BA8,$0006,$FF00
	dc.w	$0000,$203C,$0000,$0080,$721C,$343C,$07FF,$6100
	dc.w	$982A,$6100,$9B8E,$0006,$FD00,$0000,$7028,$7202
	dc.w	$343C,$07FF,$6100,$9814,$6100,$A016,$6100,$9FEE
	dc.w	$2479,$0004,$7D50,$508A,$33C4,$0001,$8D56,$6100
	dc.w	$954C,$6100,$9B5E,$0006,$CE00,$0000,$2079,$0004
	dc.w	$7D0C,$2248,$2448,$D1DA,$D3DA,$4240,$4241,$3411
	dc.w	$3629,$0002,$7A03,$6100,$93AE,$2279,$0004,$7D94
	dc.w	$45E9,$0008,$D3D1,$7007,$207C,$000B,$BCF0,$2168
	dc.w	$FFC0,$0020,$2159,$FFC0,$20E8,$FFE0,$51C8,$FFF0
	dc.w	$33FC,$0860,$000B,$BCDC,$33FC,$0860,$000B,$BCFC
	dc.w	$33C4,$0001,$8D46,$6100,$94E4,$33FC,$0104,$0001
	dc.w	$7CE8,$33FC,$00A0,$0001,$7CE6,$207C,$00C0,$0004
	dc.w	$0839,$0007,$00FF,$800E,$66F6,$33FC,$9202,$00FF
	dc.w	$8022,$33FC,$000A,$00FF,$8020,$08F9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$67F6,$08F9,$0007
	dc.w	$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839,$0006
	dc.w	$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F,$227C
	dc.w	$0001,$8AA6,$207C,$0004,$1ADE,$3039,$0001,$8A9E
	dc.w	$E340,$D0F0,$0000,$4244,$1818,$6100,$9A76,$0006
	dc.w	$FF00,$0000,$13D8,$0001,$8D59,$13D8,$0001,$8D5B
	dc.w	$4241,$1219,$D241,$6100,$0232,$51CC,$FFDE,$4244
	dc.w	$1818,$6100,$9A4E,$0006,$FF00,$0200,$13D8,$0001
	dc.w	$8D59,$4240,$1018,$6100,$01E2,$51CC,$FFE6,$6100
	dc.w	$9A32,$0006,$EF00,$0000,$0C79,$0007,$0001,$8A9C
	dc.w	$6700,$0028,$4244,$1818,$6B00,$0020,$247C,$0001
	dc.w	$8A18,$13D8,$0001,$8D59,$13D8,$0001,$8D5B,$6100
	dc.w	$017C,$D4FC,$0010,$51CC,$FFEA,$6100,$9814,$0008
	dc.w	$F801,$0141,$1A00
	lea.l	X_24832(pc),a1
	move.w	(gamelevel).l,d0
	bsr.w	X_21EC6
	move.w	(a1),d0
	lsr.w	#$1,d0
	sub.w	d0,(printx).l
	bsr.w	printsmall-LOAD
	tst.w	(gamelevel).l
	beq.w	X_245C6
	bsr.w	printz-LOAD
	String	CC_Font3Pal3,$A,$1,'Press [ or ] to page'
	dc.w	$33FC,$0018,$0001,$8D62,$3F3C,$0079,$4EB9,$0003
	dc.w	$71D2,$4240,$4244,$33FC,$FFFF,$0001,$A452,$33FC
	dc.w	$0001,$0001,$A44E,$6100,$0052,$6100,$00C4,$207C
	dc.w	$0003,$C000,$4EB9,$0002,$ACD2,$6100,$0006,$6000
	dc.w	$FFEA,$4EB9,$0003,$74F0,$3F03,$4EB9,$0003,$750E
	dc.w	$865F,$0803,$0007,$6600,$0092,$0803,$0003,$6700
	dc.w	$000A,$33FC,$FFFE,$0001,$A452,$0803,$0002,$6700
	dc.w	$000A,$33FC,$0002,$0001,$A452
PlayoffScreen_scrup						;Move the tree one step (PlayerScrollCtr) and stop on a page boundary
									;($70). The position is
									;DispAttribCtr; playoffspritex is the sprite x offset while it is on
									;screen
	move.w	(PlayerScrollCtr).l,d0
	beq.w	X_21000
	add.w	(scoutcolumn).l,d0		;new position
	move.w	(gamelevel).l,d1		;page limit = gamelevel
	cmpi.w	#$3,d1		;more than 3?
	bls.w	.lim
	moveq	#$3,d1		;at most 3 pages each way
.lim	mulu.w	#$70,d1		;$70 pixels a page
	cmp.w	d1,d0		;past the right limit?
	bgt.w	X_21000
	neg.w	d1
	cmp.w	d1,d0		;past it?
	blt.w	X_21000
	move.w	d0,(scoutcolumn).l		;store the new position
	clr.w	(playoffspritex).l		;sprite x off screen
	move.w	d0,d1		;sprite x = position + $100
	addi.w	#$100,d1
	cmpi.w	#$40,d1
	blt.w	.nox		;playoffspritex = position+$100 only inside $40-$200, else 0
	cmpi.w	#$200,d1		;past $200?
	bgt.w	.nox
	move.w	d1,(playoffspritex).l
.nox	ext.l	d0		;is the new position on a page boundary?
	divs.w	#$70,d0
	swap	d0
	tst.w	d0
	bne.w	X_21000		;not on a boundary: keep scrolling
	clr.w	(PlayerScrollCtr).l
	rts
	dc.w	$DEFC,$0004,$4E75
waitxc1						;Each time palcount runs out, eor the color
									;word at palfadenew+$42 with $EE and restart palcount at $18; then wait
									;for the next vblank
	tst.w	(palcount).l
	bpl.w	.wait		;palcount still counting
	eori.w	#$EE,$BBCF2.l		;blink the color
	move.w	#$18,(palcount).l		;restart the count
.wait	move.w	(ScoutSubStatus).l,d0		;wait until the vblank handler bumps Vcount
	cmp.w	(OldVcount).l,d0
	beq.w	.wait
	move.w	d0,(OldVcount).l
	rts
PlayoffScreen_doscores						;Print best of 7 wins "t-b" for game struct a2 at printx/printy
	movea.l	#mesarea,a1
	move.w	#$6,(a1)+
	move.w	$4(a2),d0
	addi.w	#$30,d0
	move.b	d0,(a1)+
	move.b	#$2D,(a1)+
	move.w	$6(a2),d0
	addi.w	#$30,d0
	move.b	d0,(a1)+
	clr.b	(a1)+
	movea.l	#mesarea,a1
	bra.w	print-LOAD
PlayoffScreen_doarrow						;Draw tree arrow d0 from the arrows map (Arrowsmap) at printx/printy
	movem.l	d0-d7/a0-a3,-(sp)
	movea.l	(Arrowsmap).l,a0		;a0 = arrows map
	movea.l	a0,a1		;a1 = map header
	adda.l	(a0),a0		;a0 = arrow frames
	adda.l	$4(a1),a1		;a1 = map data
	movea.l	#null,a2
	clr.w	d1
	moveq	#$2,d2
	moveq	#$17,d3
	move.w	(ExtraChars).l,d4
	moveq	#$0,d5
	bsr.w	dobitmap-LOAD
	movem.l	(sp)+,d0-d7/a0-a3
	rts
PlayoffScreen_doteam						;Draw team block d1 (team*2) from the TeamBlocks map (Teamblocksmap) at
									;printx/printy; the user's team (potreeteam entry of potree) is
									;highlighted (printa $6000)
	movem.l	d0-d7/a0-a3,-(sp)
	movea.l	#$18AA6,a0		;teams in the tree
	move.w	(potreeteam).l,d0		;the user's team entry
	move.b	(a0,d0.w),d0
	add.b	d0,d0
	cmp.b	d0,d1		;this block?
	bne.w	.nohi
	move.w	#$6000,(printa).l
.nohi	movea.l	(Teamblocksmap).l,a1		;a1 = map header of the team blocks
	adda.l	$4(a1),a1
	movea.l	#null,a2
	clr.w	d0
	move.w	(a1),d2
	moveq	#$2,d3
	moveq	#$2,d4
	moveq	#$0,d5
	bsr.w	dobitmap-LOAD
	movem.l	(sp)+,d0-d7/a0-a3
	rts
	dc.w	$48E7,$FFFE,$0839,$0002,$0001,$8D64,$6600,$008A
	dc.w	$207C,$000B,$BD30,$3039,$0001,$7F66,$6700,$0074
	dc.w	$4279,$0001,$7F66,$3239,$0001,$8D32,$4EB9,$0003
	dc.w	$78D2,$3039,$0001,$8D30,$6100,$8FB8,$303C,$FEA0
	dc.w	$D079,$0001,$A44E,$0839,$0004,$00FF,$800E,$66F6
	dc.w	$33FC,$0031,$00FF,$8026,$33C0,$00FF,$8028,$08F9
	dc.w	$0003,$00FF,$800F,$0839,$0003,$00FF,$800E,$67F6
	dc.w	$08F9,$0004,$00FF,$800F,$08B9,$0003,$00FF,$800F
	dc.w	$0839,$0003,$00FF,$800E,$66F6,$08B9,$0004,$00FF
	dc.w	$800F,$4EB9,$0003,$6DF6,$5279,$0001,$7474,$4CDF
	dc.w	$7FFF,$4E75,$000A,$506C,$6179,$6F66,$6673,$0010
	dc.w	$5175,$6172,$7465,$7266,$696E,$616C,$7300,$000C
	dc.w	$5365,$6D69,$6669,$6E61,$6C73,$0008,$4669,$6E61
	dc.w	$6C73,$000C,$4368,$616D,$7069,$6F6E,$7300
