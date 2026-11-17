	include	segacd\hockey.inc
	include	macros\genesis.mac

CC_Font1Pri	equ	$BF
CC_Font2	equ	$FE
CopyString	equ	$25818
Framer	equ	$38CA0
HomeTeam	equ	$17FAE
LOAD	equ	$1B000
LetterGrid	equ	$26DD0
M68K_RAM	equ	$C45C
NameEntryFramer	equ	$26DF0
NameEntryHelp	equ	$26A4A
NoNameTxt	equ	$25E54
ReadJoy1	equ	$374F0
ReadJoy2	equ	$3750E
ReadNameLog	equ	$2262E
RecSpaceTxt	equ	$25A4A
ScoutSubStatus	equ	$17474
TeamList	equ	$1B00C
TeamLogoBitmaps	equ	$47D8C
TeamLogoPalettes	equ	$2AF56
VisTeam	equ	$17FB0
appstring	equ	$39208
cont1team	equ	$17FA6
cursoron	equ	$1A566
dobitmap	equ	$387E2
eraser	equ	$38C06
homepicchars	equ	$19392
mesarea	equ	$17EF2
move	equ	$2C9C8
nameentryvis	equ	$1A390
namelog	equ	$1A2FC
namelogarrows	equ	$1A38E
namelogsel	equ	$1A38C
print	equ	$38F80
printx	equ	$18D58
printy	equ	$18D5A
printz	equ	$38F6E
sflags6	equ	$17F76
X_7534	equ	$7534
X_B62C	equ	$B62C
X_B778	equ	$B778
X_B7DA	equ	$B7DA
X_B808	equ	$B808
X_B8A6	equ	$B8A6
X_B8B0	equ	$B8B0
X_BA00	equ	$BA00
X_BB1A	equ	$BB1A
X_BB4E	equ	$BB4E
X_BB80	equ	$BB80
X_BBAC	equ	$BBAC
X_BBD6	equ	$BBD6
X_BC04	equ	$BC04
X_BC60	equ	$BC60
X_BCC8	equ	$BCC8
X_BD86	equ	$BD86
X_BE0E	equ	$BE0E
X_BE5E	equ	$BE5E
X_C0A0	equ	$C0A0

	org	$A9E2

AppendRecordVs						;Append the user name (byte 3 of record a0), a space and the opponent team
									;name (byte 2, AppendTeamName) to a1
	movem.l	d0-d7/a0-a6,-(sp)
	cmpa.l	#$0,a0
	bne.w	.0		;a record was passed in a0: use it
	movem.l	d0-d7/a1-a6,-(sp)
	move.w	d0,-(sp)		;swap d0 and d1
	move.w	d1,d0		;swap d0/d1 into ReadPlayerRecord's order: d0 player, d1 team
	move.w	(sp)+,d1
	ext.l	d1
	ext.l	d0
	movea.l	#M68K_RAM,a0
	bsr.w	X_7534
	movea.l	#M68K_RAM,a0		;a0 = the record
	movem.l	(sp)+,d0-d7/a1-a6
.0	move.b	$3(a0),d2
	ext.w	d2
	movem.l	d0/a1,-(sp)
	bset	#$7,(sflags6).l		;record name list
	bsr.w	AppendUserName
	movea.l	a1,a3
	movea.l	#RecSpaceTxt,a1
	jsr	(appstring).l
	movem.l	(sp)+,d0/a1
	move.b	$2(a0),d0		;byte 2 = the opponent team
	jsr	(AppendTeamName+LOAD).l		;append the team name
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.w	$0004,$2000,$4A79,$0001,$93BA,$6B00,$0120,$4A79
	dc.w	$0001,$8C06,$6600,$0116,$48E7,$FFFE,$6100,$0324
	dc.w	$6100,$034E,$3239,$0001,$7FAE,$48C1,$207C,$000B
	dc.w	$C000,$247C,$0001,$834C,$3A39,$0001,$93AA,$3C39
	dc.w	$0001,$7FB0,$6100,$027E,$3239,$0001,$7FB0,$48C1
	dc.w	$247C,$0001,$86B2,$3A39,$0001,$93AC,$3C39,$0001
	dc.w	$7FAE,$6100,$0260,$4247,$227C,$0001,$834C,$3839
	dc.w	$0001,$8BF4,$3A39,$0001,$8BF6,$3239,$0001,$7FAE
	dc.w	$3439,$0001,$7FB0,$3C39,$0001,$93AA,$48C1,$207C
	dc.w	$000B,$C000,$6100,$0174,$227C,$0001,$86B2,$3839
	dc.w	$0001,$8BF6,$3A39,$0001,$8BF4,$3239,$0001,$7FB0
	dc.w	$3439,$0001,$7FAE,$3C39,$0001,$93AC,$48C1,$207C
	dc.w	$000B,$C000,$6100,$0144,$207C,$000B,$C000,$3239
	dc.w	$0001,$8BF4,$48C1,$3439,$0001,$8BF6,$3639,$0001
	dc.w	$7FAE,$3839,$0001,$7FB0,$227C,$0001,$834C,$247C
	dc.w	$0001,$86B2,$6100,$0038,$207C,$000B,$C000,$3239
	dc.w	$0001,$8BF6,$48C1,$3439,$0001,$8BF4,$3639,$0001
	dc.w	$7FB0,$3839,$0001,$7FAE,$227C,$0001,$86B2,$247C
	dc.w	$0001,$834C,$6100,$0008,$4CDF,$7FFF,$4E75,$48E7
	dc.w	$FFFE,$6100,$CA5A,$50C7,$48A7,$8000,$4240,$1028
	dc.w	$000A,$E148,$1028,$000B,$0C40,$2328,$6C00,$0058
	dc.w	$0640,$0001,$1140,$000B,$E048,$1140,$000A,$3029
	dc.w	$000C,$B06A,$000C,$6E00,$0024,$6D00,$003A,$4240
	dc.w	$1028,$000C,$E148,$1028,$000D,$0640,$0001,$1140
	dc.w	$000D,$E048,$1140,$000C,$6000,$001C,$4240,$1028
	dc.w	$0008,$E148,$1028,$0009,$0640,$0001,$1140,$0009
	dc.w	$E048,$1140,$0008,$4C9F,$0001,$48A7,$8000,$3029
	dc.w	$000C,$B06A,$000C,$4C9F,$0001,$6F00,$0044,$3A29
	dc.w	$000C,$BA28,$0000,$6F00,$0014,$50C7,$1145,$0000
	dc.w	$1143,$0001,$1144,$0002,$1142,$0003,$3A2A,$000C
	dc.w	$3C2A,$0000,$9C45,$BC28,$0004,$6F00,$0014,$50C7
	dc.w	$1146,$0004,$1143,$0005,$1144,$0006,$1142,$0007
	dc.w	$6100,$C9CA,$4CDF,$7FFF,$4E75,$48E7,$FFFE,$6100
	dc.w	$C934,$3629,$000C,$B628,$0000,$6F00,$0014,$1143
	dc.w	$0000,$1144,$0001,$1145,$0003,$1142,$0002,$50C7
	dc.w	$0446,$0001,$4243,$3006,$0640,$00EA,$13F1,$0000
	dc.w	$0001,$7E62,$0640,$FFCC,$1031,$0000,$9139,$0001
	dc.w	$7E62,$B639,$0001,$7E62,$6C00,$0008,$1639,$0001
	dc.w	$7E62,$51CE,$FFD2,$B628,$0004,$6F00,$0014,$50C7
	dc.w	$1143,$0004,$1144,$0005,$1145,$0007,$1142,$0006
	dc.w	$B279,$0001,$7FAE,$6600,$002C,$1628,$0008,$0243
	dc.w	$00FF,$B679,$0001,$7F92,$6C00,$001A,$3639,$0001
	dc.w	$7F92,$50C7,$1143,$0008,$1144,$0009,$1145,$000B
	dc.w	$1142,$000A,$4A47,$6700,$0006,$6100,$C8C6,$4CDF
	dc.w	$7FFF,$4E75,$4280,$343C,$0019,$6100,$C81E,$B045
	dc.w	$6D00,$0012,$3F00,$0640,$00B6,$1832,$0000,$301F
	dc.w	$6000,$0016,$3F00,$0640,$00EA,$1832,$0000,$0640
	dc.w	$FFCC,$9832,$0000,$301F,$1628,$0000,$B803,$6F00
	dc.w	$0038,$1144,$0000,$1179,$0001,$8BF5,$0001,$1179
	dc.w	$0001,$8BF7,$0003,$B5FC,$0001,$834C,$6700,$0012
	dc.w	$1179,$0001,$8BF7,$0001,$1179,$0001,$8BF5,$0003
	dc.w	$1146,$0002,$6100,$C802,$0640,$0001,$51CA,$FF8C
	dc.w	$4E75,$48E7,$FFFE,$247C,$0001,$834C,$4EB9,$0002
	dc.w	$ED60,$33C0,$0001,$93AA,$247C,$0001,$86B2,$4EB9
	dc.w	$0002,$ED60,$33C0,$0001,$93AC,$4CDF,$7FFF,$4E75
	dc.w	$48E7,$FFFE,$247C,$0001,$834C,$4EB9,$0002,$EDBC
	dc.w	$33C0,$0001,$93AE,$247C,$0001,$86B2,$4EB9,$0002
	dc.w	$EDBC,$33C0,$0001,$93B0,$4CDF,$7FFF,$4E75
AppendUserName						;Append user name d2 (12 bytes of the name log at namelog, spaces for 0)
									;to a1, or NoNameTxt when d2 is 0; trailing spaces trimmed (TrimSpaces)
	movem.l	d0-d3/a0-a3,-(sp)
	movea.l	a1,a2		;keep the String start
	tst.w	d2		;no user?
	beq.w	.2
	move.w	#$B,d0
	clr.w	d3
	movea.l	#namelog,a0
	mulu.w	#$C,d2		;12 bytes per name
	adda.l	d2,a0		;this user's name
.loop	move.b	(a0,d3.w),d1		;0 bytes print as spaces
	bne.w	.0
	move.b	#$20,d1
.0	move.b	d1,$2(a1)		;after the length word
	tst.b	(a1)+
	addi.w	#$1,d3		;next name byte
	dbra	d0,.loop
	move.w	#$E,(a2)		;length = 12 + header
	btst	#$7,(sflags6).l
	beq.w	.1		;trim only when asked (bit 7)
	bsr.w	TrimSpaces		;trim the trailing spaces
.1	bra.w	.x
.2	movea.l	a1,a3
	move.l	a3,-(sp)
	movea.l	#NoNameTxt,a1
	jsr	(CopyString).l
	movea.l	(sp)+,a2
	bsr.w	TrimSpaces		;trim the trailing spaces
.x	movem.l	(sp)+,d0-d3/a0-a3
	rts
	dc.w	$0002,$48E7,$FFFE,$3E3C,$0009,$4EB8,$6044,$207C
	dc.w	$000A,$FF60,$0839,$0007,$00FF,$800E,$66F6,$23FC
	dc.w	$0000,$0000,$00FF,$8022,$33FC,$000B,$00FF,$8020
	dc.w	$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF,$800E
	dc.w	$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007
	dc.w	$00FF,$800F,$203C,$0000,$3FFF,$0839,$0007,$00FF
	dc.w	$800E,$66F6,$33FC,$0016,$00FF,$8020,$08F9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$67F6,$20F9
	dc.w	$00FF,$8010,$08F9,$0007,$00FF,$800F,$08B9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9
	dc.w	$0007,$00FF,$800F,$51C8,$FFB2,$203C,$0000,$0027
	dc.w	$0839,$0007,$00FF,$800E,$66F6,$23FC,$0000,$0010
	dc.w	$00FF,$8022,$33FC,$000B,$00FF,$8020,$08F9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$67F6,$08F9
	dc.w	$0007,$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F
	dc.w	$0839,$0007,$00FF,$800E,$66F6,$33FC,$0015,$00FF
	dc.w	$8020,$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$67F6,$30F9,$00FF,$8010,$08F9,$0007,$00FF
	dc.w	$800F,$08B9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$66F6,$08B9,$0007,$00FF,$800F,$51C8,$FFB2
	dc.w	$4EB9,$0003,$6D0A,$2F0E,$2C79,$0001,$9360,$0839
	dc.w	$0005,$00FF,$800F,$6706,$3D3C,$0001,$6004,$3D3C
	dc.w	$0000,$08B9,$0005,$00FF,$800F,$23CE,$0001,$9360
	dc.w	$2C5F,$3039,$0001,$8BFE,$3239,$0001,$8C00,$3439
	dc.w	$0001,$8BF8,$3E3C,$0005,$4EB8,$6044,$4EB9,$0002
	dc.w	$B614,$4EB9,$0002,$1FC8,$303C,$0002,$4EB8,$5F22
	dc.w	$303C,$0080,$4EB8,$5F22,$6500,$FFF6,$303C,$0081
	dc.w	$4EB8,$5F22,$3410,$0242,$FF00,$0C42,$0000,$66EC
	dc.w	$33FC,$0005,$0001,$9364,$303C,$0013,$41F9,$0001
	dc.w	$9364,$4EB8,$5F22,$4EB9,$0003,$6D0A,$303C,$8000
	dc.w	$323C,$0000,$207C,$000A,$FF60,$4EB9,$0003,$7762
	dc.w	$4EB9,$0003,$816C,$0839,$0007,$00FF,$800E,$66F6
	dc.w	$33FC,$0027,$00FF,$8020,$08F9,$0006,$00FF,$800F
	dc.w	$0839,$0006,$00FF,$800E,$67F6,$08F9,$0007,$00FF
	dc.w	$800F,$08B9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$66F6,$08B9,$0007,$00FF,$800F,$4CDF,$7FFF
	dc.w	$2F0E,$2C79,$0001,$9360,$4A5E,$670A,$08F9,$0005
	dc.w	$00FF,$800F,$6008,$08B9,$0005,$00FF,$800F,$23CE
	dc.w	$0001,$9360,$2C5F,$4EF9,$0002,$E980
AppendTeamName						;Append the city name of team d0 (TeamList block Strings) to a1
									;(appstring)
	movem.l	d0/a0-a3,-(sp)
	ext.w	d0
	asl.w	#$2,d0
	movea.l	#TeamList,a0
	movea.l	(a0,d0.w),a0
	move.w	$4(a0),d0		;offset of the team's Strings block
	ext.l	d0
	adda.l	d0,a0		;a0 = Strings block
	adda.w	(a0),a0		;first String: the city
	movea.l	a1,a3
	movea.l	a0,a1		;city name
	jsr	(appstring).l
	movem.l	(sp)+,d0/a0-a3
	rts
	dc.w	$2F0E,$4279,$0001,$A570,$4279,$0001,$A572,$2C7C
	dc.w	$0002,$6266,$B8B9,$0004,$1C70,$6600,$0008,$2C7C
	dc.w	$0002,$6246,$B8B9,$0004,$1DD2,$6600,$0008,$2C7C
	dc.w	$0002,$6256,$206A,$001E,$49EA,$01A4,$4281,$3200
	dc.w	$E941,$D9C1,$D9FC,$0000,$0010,$D0E8,$0000,$D0D0
	dc.w	$D0FC,$0008,$51C8,$FFF8,$4240,$4241,$740F,$4844
	dc.w	$0504,$6700,$009A,$3602,$E24B,$4443,$1630,$30FF
	dc.w	$0802,$0000,$6700,$0004,$E84B,$0243,$000F,$0C42
	dc.w	$000D,$6600,$0006,$6000,$0070,$0C42,$0006,$6700
	dc.w	$0068,$48E7,$0700,$1A36,$2000,$4885,$0C45,$0002
	dc.w	$6700,$0012,$3F03,$0445,$0002,$D657,$51CD,$FFFC
	dc.w	$E243,$4A5F,$4CDF,$00E0,$BDFC,$0002,$6266,$6700
	dc.w	$0022,$4442,$3F07,$1E34,$20FF,$4887,$DF79,$0001
	dc.w	$A570,$0679,$0001,$0001,$A572,$3E1F,$4442,$6000
	dc.w	$0018,$3F03,$E943,$D657,$D65F,$4442,$D634,$20FF
	dc.w	$6A00,$0004,$4203,$4442,$D043,$0641,$0064,$51CA
	dc.w	$FF60,$BDFC,$0002,$6266,$6700,$0020,$323C,$0064
	dc.w	$48E7,$0300,$3C39,$0001,$A570,$48C6,$3E39,$0001
	dc.w	$A572,$8DC7,$D046,$4CDF,$00C0,$B041,$6D00,$0008
	dc.w	$3200,$0440,$0001,$2C5F,$4E75,$0202,$0202,$0406
	dc.w	$0204,$0204,$0606,$0402,$0202,$0202,$0202,$0202
	dc.w	$0202,$0909,$0202,$0902,$0202,$0202,$0202,$0202
	dc.w	$0202,$0202,$0202,$0202,$0202,$48E7,$FF7E,$2079
	dc.w	$0004,$7D88,$3401,$E542,$2070,$2000,$343C,$FFFF
	dc.w	$6000,$0016,$B068,$0004,$6600,$0008,$2050,$6000
	dc.w	$007A,$D1FC,$0000,$0006,$0642,$0001,$4A90,$6600
	dc.w	$FFE4,$207C,$0001,$B00C,$E541,$2070,$1000,$2C48
	dc.w	$3C00,$DCEE,$0000,$6000,$0008,$DCD6,$DCFC,$0008
	dc.w	$51CE,$FFF8,$DCD6,$D0E8,$000A,$3210,$4243,$0643
	dc.w	$0001,$E941,$6600,$FFF8,$207C,$0004,$33AA,$082E
	dc.w	$0000,$0004,$6600,$0008,$207C,$0004,$3714,$B043
	dc.w	$6D00,$0018,$207C,$0004,$3040,$082E,$0000,$0004
	dc.w	$6600,$0008,$207C,$0004,$2CD6,$4CDF,$7EFF,$4E75
TrimSpaces						;Trim the trailing spaces of String a2 and pad it to an even length
	movem.l	a3,-(sp)
	movea.l	a2,a3
	adda.w	(a2),a3		;a3 = end of the String
.loop	move.b	-(a3),d0
	cmpi.b	#$20,d0		;space?
	bne.w	.0		;last character not a space: done
	move.b	#$0,(a3)
	subi.w	#$1,(a2)		;one shorter
	bra.w	.loop
.0	addi.w	#$1,(a2)
	andi.w	#$FE,(a2)
	movem.l	(sp)+,a3
	rts
	dc.w	$48E7,$FFFE,$08B9,$0005,$00FF,$800F,$383C,$0002
	dc.w	$23FC,$0004,$00D0,$0001,$8D66,$08B9,$0000,$0001
	dc.w	$8D64,$08F9,$0002,$0001,$8D64,$08B9,$0001,$0001
	dc.w	$8D64,$33FC,$0000,$0001,$8D30,$33FC,$B400,$0001
	dc.w	$8D32,$33FC,$B800,$0001,$8D3C,$33FC,$0005,$0001
	dc.w	$8D3E,$33FC,$C000,$0001,$8D38,$33FC,$0006,$0001
	dc.w	$8D3A,$33FC,$E000,$0001,$8D34,$33FC,$0006,$0001
	dc.w	$8D36,$303C,$0000,$4EB9,$0003,$7B5A,$08F9,$0005
	dc.w	$00FF,$800F,$4EB9,$0003,$7460,$33C4,$0001,$8D4E
	dc.w	$2479,$0004,$7D10,$508A,$4EB9,$0003,$8946,$9123
	dc.w	$4567,$89AB,$CDEF,$33C4,$0001,$A3D2,$2479,$0004
	dc.w	$7D10,$508A,$4EB9,$0003,$8946,$9123,$4560,$89AB
	dc.w	$CDEF,$33C4,$0001,$8D42,$4EB9,$0003,$93E8,$4EB9
	dc.w	$0003,$8F6E,$0006,$FF00,$0000,$7028,$721C,$343C
	dc.w	$07FF,$4EB9,$0003,$8C06,$4EB9,$0003,$EC60,$4EB9
	dc.w	$0003,$8F6E,$0006,$FE00,$0000,$2079,$0004,$7D0C
	dc.w	$2248,$2448,$D1DA,$D3DA,$4240,$4241,$7428,$761C
	dc.w	$7A0D,$4EB9,$0003,$87E2,$4EB9,$0003,$6F72,$33C4
	dc.w	$0001,$9392,$0644,$0024,$33C4,$0001,$9398,$2479
	dc.w	$0004,$7D7C,$508A,$4EB9,$0003,$8958,$33C4,$0001
	dc.w	$8D40,$2479,$0004,$7D38,$508A,$4EB9,$0003,$8946
	dc.w	$7123,$4567,$89AB,$CDEF,$4EB9,$0003,$8F6E,$0006
	dc.w	$BF1F,$0600,$3039,$0001,$7FAE,$4A79,$0001,$A390
	dc.w	$6700,$0008,$3039,$0001,$7FB0,$227C,$0001,$B00C
	dc.w	$E540,$2271,$0000,$D2E9,$0004,$3011,$0440,$0002
	dc.w	$E248,$9179,$0001,$8D58,$4EB9,$0003,$8F80,$4EB9
	dc.w	$0003,$8F6E,$0006,$BF1B,$0700,$303C,$0008,$323C
	dc.w	$0008,$4EB9,$0003,$8CA0,$4EB9,$0003,$8F6E,$0006
	dc.w	$8F1C,$0800
	move.w	(HomeTeam).l,d3
	tst.w	(nameentryvis).l
	beq.w	.lB522
	move.w	(VisTeam).l,d3
.lB522	asl.w	#$2,d3
	movea.l	(TeamLogoBitmaps).l,a0
	movea.l	(a0,d3.w),a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	asl.w	#$3,d3
	movea.l	#TeamLogoPalettes,a0
	subi.w	#$40,d3
	adda.w	d3,a0
	adda.l	(a2)+,a1
	move.w	#$6,d3
	move.w	#$6,d2
	clr.w	d0
	clr.w	d1
	move.w	#$4,d5
	move.w	(homepicchars).l,d4
	jsr	(dobitmap).l
	jsr	(printz).l
	String	CC_Font1Pri,$2,$0
	dc.w	$303C,$0024,$323C,$0006,$4EB9,$0003,$8CA0,$4EB9
	dc.w	$0003,$9258,$0010,$BF0A,$024E,$414D,$4520,$2045
	dc.w	$4E54,$5259
	bsr.w	ReadNameLog-LOAD
	clr.w	(namelogarrows).l
	move.w	#$1,(namelogsel).l
	clr.w	d0
	bsr.w	X_C0A0
	movea.l	#$1A37C,a1
	bsr.w	X_BE0E
	bsr.w	X_BC60
	jsr	(printz).l
	String	CC_Font1Pri,$7,$6,'Name Log'
	dc.w	$33FC,$0018,$0001,$8D62,$08B9,$0002,$0001,$8D64
	dc.w	$4244,$6100,$0570,$6100,$05CA,$6100,$061E,$3F39
	dc.w	$0001,$8D58,$3F39,$0001,$8D5A,$4EB9,$0002,$6DF0
	dc.w	$33DF,$0001,$8D5A,$0679,$0001,$0001,$8D5A,$33DF
	dc.w	$0001,$8D58,$0679,$0001,$0001,$8D58,$6100,$05BE
	dc.w	$33FC,$0001,$0001,$A566,$6100,$028C,$4240,$6000
	dc.w	$01B0,$6100,$0724,$4EB9,$0003,$8F6E,$0006,$BF05
	dc.w	$1200
	tst.w	(cursoron).l
	beq.w	.lB654
	movea.l	#$1A37C,a1
	bsr.w	X_BD86
	bsr.w	X_BB1A
.lB654	bsr.w	X_BCC8
.lB658	move.w	(ScoutSubStatus).l,d0
.lB65E	cmp.w	(ScoutSubStatus).l,d0
	beq.w	.lB65E
	movem.w	d1,-(sp)
	move.w	(cont1team).l,d1
	subi.w	#$1,d1
	cmp.w	(nameentryvis).l,d1
	movem.w	(sp)+,d1
	beq.w	.lB694
	jsr	(ReadJoy2).l
	tst.w	d1
	beq.w	.lB658
	bra.w	.lB6A0
.lB694	jsr	(ReadJoy1).l
	tst.w	d1
	beq.w	.lB658
.lB6A0	btst	#$7,d1
	bne.w	X_B8A6
	tst.w	(cursoron).l
	bne.w	.lB6DC
	move.w	#$1,d0
	btst	#$1,d1
	bne.w	.lB726
	move.w	#$FFFF,d0
	btst	#$0,d1
	bne.w	.lB726
	btst	#$4,d1
	beq.w	X_B62C
	bsr.w	X_B8B0
	clr.w	d0
	bra.w	.lB726
.lB6DC	moveq	#-1,d0
	btst	#$6,d1
	bne.w	X_B7DA
	neg.w	d0
	btst	#$5,d1
	bne.w	X_B7DA
	btst	#$3,d1
	bne.w	X_B808
	neg.w	d0
	btst	#$2,d1
	bne.w	X_B808
	moveq	#$6,d0
	btst	#$1,d1
	bne.w	X_B808
	neg.w	d0
	btst	#$0,d1
	bne.w	X_B808
	btst	#$4,d1
	beq.w	X_B62C
	bsr.w	X_B8B0
	bra.w	X_B62C
.lB726	add.w	d0,(namelogsel).l
.lB72C	cmpi.w	#$7,(namelogsel).l
	ble.w	.lB740
	move.w	#$1,(namelogsel).l
.lB740	tst.w	(namelogsel).l
	bne.w	.lB752
	move.w	#$7,(namelogsel).l
.lB752	bsr.w	X_C0A0
	beq.w	.lB72C
	movea.l	#$1A37C,a1
	bsr.w	X_BE0E
	tst.w	(cursoron).l
	bne.w	X_B778
	jsr	(NameEntryHelp).l
	bra.w	X_B62C
	dc.w	$4EB9,$0003,$8F6E,$0006,$BF04,$1300,$D979,$0001
	dc.w	$8D58,$4EB9,$0003,$8F6E,$0006,$2020,$2000
	bsr.w	X_BC04
	moveq	#$1,d2
	move.w	(printx).l,-(sp)
	move.w	(printy).l,-(sp)
	jsr	(eraser).l
	move.w	(sp)+,(printy).l
	addi.w	#$1,(printy).l
	move.w	(sp)+,(printx).l
	addi.w	#$1,(printx).l
	bsr.w	X_BBD6
	bsr.w	X_BB4E
	move.w	d4,d0
	neg.w	d0
	bra.w	.lB7DA
.lB7DA	add.w	d4,d0
	cmpi.w	#$B,d0
	bhi.w	X_B62C
	move.w	d0,d4
	bsr.w	X_BBAC
	movea.l	#$1A37C,a0
	clr.w	d0
	cmpi.b	#$2D,(a0,d4.w)
	beq.w	.lB808
	move.b	(a0,d4.w),d0
	ext.w	d0
	bsr.w	X_BB80
	sub.w	d5,d0
.lB808	add.w	d5,d0
	cmpi.w	#$1D,d0
	bhi.w	X_B62C
	move.w	d0,-(sp)
	bsr.w	X_BC04
	moveq	#$1,d2
	move.w	(printx).l,-(sp)
	move.w	(printy).l,-(sp)
	jsr	(eraser).l
	move.w	(sp)+,(printy).l
	addi.w	#$1,(printy).l
	move.w	(sp)+,(printx).l
	addi.w	#$1,(printx).l
	bsr.w	X_BBD6
	move.w	(sp)+,d5
	bsr.w	X_BC04
	move.w	(printx).l,-(sp)
	move.w	(printy).l,-(sp)
	tst.w	(cursoron).l
	beq.w	.lB86E
	jsr	(NameEntryFramer).l
.lB86E	move.w	(sp)+,(printy).l
	addi.w	#$1,(printy).l
	move.w	(sp)+,(printx).l
	addi.w	#$1,(printx).l
	bsr.w	X_BBD6
	movea.l	#$1A37C,a0
	movea.l	#LetterGrid,a1
	move.b	(a1,d5.w),d0
	move.b	d0,(a0,d4.w)
	bra.w	X_B62C
	bsr.w	X_BE5E
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	dc.w	$48E7,$FFFE,$4EB9,$0003,$8F6E,$0006,$BF01,$1400
	move.w	#$16,d0
	move.w	#$7,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	bchg	#$0,$1A567.l
	bne.w	X_BA00
	jsr	(printz).l
	String	CC_Font1Pri,$19,$11
	movea.l	#LetterGrid,a0
	moveq	#$4,d0
.lB8F2	moveq	#$5,d1
	movea.l	#mesarea,a1
	move.w	#$E,(a1)+
.lB8FE	move.b	(a0)+,(a1)+
	move.b	#$20,(a1)+
	dbra	d1,.lB8FE
	movea.l	#mesarea,a1
	jsr	(print).l
	addi.w	#$2,(printy).l
	subi.w	#$C,(printx).l
	dbra	d0,.lB8F2
	jsr	(printz).l
	String	CC_Font2,$1,$14
	moveq	#$16,d0
	moveq	#$7,d1
	jsr	(Framer).l
	jsr	(printz).l
	String	CC_Font1Pri,$2,$15,'D-Pad to a letter.'
	move.w	#$2,(printx).l
	addi.w	#$1,(printy).l
	move.w	(printx).l,-(sp)
	jsr	(printz).l
	String	'C to select letter.'
