	include	segacd\hockey.inc
	include	macros\genesis.mac

LOAD	equ	$1B000
SortCords	equ	$17480
Sroot	equ	$3708E
lastplayer	equ	$17E2A
makepde	equ	$3C274
move	equ	$2C9C8
onetimershot	equ	$22D28
puckglue	equ	$3BDE8
puckvx	equ	$17BA8
puckvy	equ	$17BAA
randomd0	equ	$37050
sflags6	equ	$17F76
sfx	equ	$3710C
wcradiusx	equ	$17CF4
wcradiusy	equ	$17CF6
X_1AD28	equ	$1AD28
X_1AEF8	equ	$1AEF8
X_2001C	equ	$2001C
X_206A2	equ	$206A2
X_208E8	equ	$208E8
X_21000	equ	$21000
X_21246	equ	$21246

	org	$1FF40

checkwallcoll						;d2/d3 = x/y to test, a3 = object, wcradiusx/wcradiusy = radius. Check the
									;corner circles, the goals (checkgoal with a2 = SortCords+(13*SCstruct)
									;top, SortCords+(12*SCstruct) bottom) and then the side and end boards.
									;Calls wallcollb on a hit, with d0/d1 = cos/sin of the wall. Called from
									;checkcoll
	bclr	#$4,$64(a3)
	move.w	#$88,d4
	sub.w	(wcradiusx).l,d4
	move.w	#$12A,d5		;298: end boards
	sub.w	(wcradiusy).l,d5
	movem.w	d2-d5,-(sp)
	neg.w	d4
	neg.w	d5
	addi.w	#$40,d4		;corner circle radius 64
	addi.w	#$40,d5
	cmp.w	d5,d3
	bgt.w	.0
	cmp.w	d4,d2
	blt.w	.1
	neg.w	d4
	cmp.w	d4,d2
	bgt.w	.1
	movea.l	#$17B00,a2
	bsr.w	X_2001C
	bra.w	.2
.0	neg.w	d5
	cmp.w	d5,d3
	blt.w	.2
	cmp.w	d4,d2
	blt.w	.1
	neg.w	d4
	cmp.w	d4,d2
	bgt.w	.1
	movea.l	#$17A80,a2
	bsr.w	X_2001C
	bra.w	.2
.1	sub.w	d4,d2		;corner circle: d2/d3 = offset from the circle centre
	sub.w	d5,d3
	move.w	d3,d0
	move.w	d2,d1
	neg.w	d1
	muls.w	d3,d3
	muls.w	d2,d2
	add.l	d2,d3		;dist from dot
	cmpi.l	#$1000,d3		;inside the corner circle (64*64)
	bls.w	.2
	exg.l	d0,d3
	bsr.w	Sroot-LOAD		;distance from the circle center
	exg.l	d0,d3
	ext.l	d0
	asl.l	#$8,d0
	divs.w	d3,d0
	ext.l	d1
	asl.l	#$8,d1
	divs.w	d3,d1
	bsr.w	X_206A2
.2	movem.w	(sp)+,d2-d5
	move.w	$4E(a3),d0		;wallcos: already hit
	or.w	$50(a3),d0
	bne.w	X_21000
	move.w	#$100,d0		;now check side walls
	clr.w	d1
	cmp.w	d5,d3
	bge.w	X_206A2
	neg.w	d5
	neg.w	d0
	cmp.w	d5,d3
	ble.w	X_206A2
	exg.l	d0,d1
	cmp.w	d4,d2
	bge.w	X_206A2
	neg.w	d4
	neg.w	d1
	cmp.w	d4,d2
	ble.w	X_206A2
	rts
	dc.w	$0C6B,$000D,$0018,$6E00,$0FDC,$0C6B,$000E,$0052
	dc.w	$6600,$050A,$946A,$0000,$7810,$D879,$0001,$7CF4
	dc.w	$B444,$6E00,$0FC0,$4444,$B444,$6D00,$0FB8,$966A
	dc.w	$0014,$3A3C,$0002,$DA79,$0001,$7CF6,$B645,$6E00
	dc.w	$0FA4,$4445,$B645,$6D00,$0F9C,$50F9,$0001,$7EEE
	dc.w	$0C6B,$000D,$0024,$6D00,$000C,$376B,$0024,$0018
	dc.w	$6000,$0114,$08AB,$0007,$0062,$3039,$0001,$7BE0
	dc.w	$6B00,$0034,$50F9,$0001,$7BE0,$EF40,$207C,$0001
	dc.w	$7480,$11BC,$0008,$005E,$3239,$0001,$7B94,$0830
	dc.w	$0007,$0062,$6600,$0004,$4441,$4A41,$6A00,$0008
	dc.w	$08EB,$0007,$0062,$303C,$FF00,$222B,$0014,$92AB
	dc.w	$0020,$E081,$6700,$00CE,$6B00,$0006,$4440,$4445
	dc.w	$DA43,$262B,$0000,$96AB,$001C,$E083,$CBC3,$8BC1
	dc.w	$6900,$00B2,$9445,$B444,$6D00,$00AA,$4444,$B444
	dc.w	$6E00,$00A2,$4241,$362B,$0014,$B143,$6B00,$0652
	dc.w	$4440,$082B,$0007,$0062,$6600,$0646,$0C6B,$000D
	dc.w	$0018,$6700,$0014,$0444,$0001,$B444,$6E00,$000A
	dc.w	$4444,$B444,$6C00,$0086,$6100,$16E8,$3F3C,$0025
	dc.w	$0839,$0000,$0001,$7F68,$6600,$0016,$3EBC,$0008
	dc.w	$0679,$012C,$0001,$7CD2,$0679,$0028,$0001,$7CD8
	dc.w	$6100,$BFAE,$303C,$1000,$6100,$BEEA,$4A6B,$0014
	dc.w	$6B00,$0004,$4440,$3740,$002A,$303C,$1000,$6100
	dc.w	$BEC8,$3740,$0028,$303C,$1000,$6100,$BEBC,$3740
	dc.w	$002C,$6000,$AD68,$446B,$002C,$6A00,$0E68,$446B
	dc.w	$002C,$4E75,$4240,$323C,$0100,$342B,$0000,$946B
	dc.w	$001C,$6B00,$05AC,$4441,$6000,$05A6,$0839,$0002
	dc.w	$0001,$7F70,$6700,$008E,$0839,$0000,$0001,$7F78
	dc.w	$6600,$0028,$48E7,$8080,$3039,$0001,$9368,$EF40
	dc.w	$207C,$0001,$7480,$D0C0,$0828,$0007,$0062,$4CDF
	dc.w	$0101,$6600,$0010,$6000,$001A,$4A79,$0001,$A436
	dc.w	$6600,$0010,$4A79,$0001,$7B94,$6B00,$0DF8,$6000
	dc.w	$000C,$4A79,$0001,$7B94,$6A00,$0DEA,$08F9,$0005
	dc.w	$0001,$7F72,$4A79,$0001,$A436,$6700,$000E,$0679
	dc.w	$0001,$0001,$A418,$6000,$000A,$0679,$0001,$0001
	dc.w	$A416,$08F9,$0000,$0001,$7F7C,$4EB9,$0003,$4C46
	dc.w	$6000,$000E,$0839,$0000,$0001,$7F68,$6600,$0DA6
	dc.w	$08F9,$0000,$0001,$7F72,$08B9,$0003,$0001,$7F7C
	dc.w	$6100,$15B0,$4EB9,$0004,$7DB0,$3F00,$3039,$0001
	dc.w	$7474,$B079,$0001,$7474,$6700,$FFF8,$301F,$3F3C
	dc.w	$0000,$6100,$BE7C,$4EB9,$0003,$0094,$0679,$01F4
	dc.w	$0001,$7CD2,$247C,$0001,$834C,$43EA,$0366,$4A6B
	dc.w	$0014,$6A00,$0004,$C34A,$0839,$0001,$0001,$7F68
	dc.w	$6700,$0004,$C34A,$066A,$0001,$000C,$0839,$0005
	dc.w	$0001,$7F72,$6700,$0014,$0839,$0000,$0001,$7F78
	dc.w	$6600,$0008,$066A,$0001,$0364,$08B9,$0004,$0001
	dc.w	$7F78,$6700,$0008,$066A,$0001,$035C,$0839,$0005
	dc.w	$0001,$7F6C,$6700,$002C,$0839,$0006,$0001,$7F6C
	dc.w	$6600,$0016,$B5FC,$0001,$86B2,$6600,$0016,$066A
	dc.w	$0001,$0358,$6000,$000C,$B5FC,$0001,$834C,$6700
	dc.w	$FFEE,$48E7,$8020,$3039,$0001,$80E4,$D040,$D4C0
	dc.w	$066A,$0001,$0344,$4CDF,$0401,$08B9,$0007,$0001
	dc.w	$7F7C,$6700,$0008,$066A,$0001,$0360,$B5FC,$0001
	dc.w	$834C,$6600,$0024,$33F9,$0001,$7FAE,$0001,$A56C
	dc.w	$33FC,$0003,$0001,$A56E,$4EB9,$0002,$A478,$3F39
	dc.w	$0001,$A56A,$6100,$BE50,$0C79,$0168,$0001,$80F0
	dc.w	$6600,$000A,$0479,$0006,$0001,$80F0,$207C,$0001
	dc.w	$80F2,$D0F9,$0001,$80F0,$0679,$0006,$0001,$80F0
	dc.w	$6100,$0170,$30C0,$7002,$D06A,$0026,$9069,$0026
	dc.w	$10C0,$0679,$001E,$0001,$7CD8,$B5FC,$0001,$834C
	dc.w	$6700,$0010,$0479,$0014,$0001,$7CD8,$08E8,$0007
	dc.w	$FFFF,$302A,$0018,$10C0,$30BC,$FFFF,$0640,$00B6
	dc.w	$0632,$0001,$0000,$302A,$001A,$6B00,$0032,$B06A
	dc.w	$0018,$6700,$002A,$10C0,$0640,$00D0,$0632,$0001
	dc.w	$0000,$302A,$001C,$6B00,$0016,$B06A,$0018,$6700
	dc.w	$000E,$1080,$0640,$00D0,$0632,$0001,$0000,$3029
	dc.w	$0028,$6B00,$000C,$0640,$00B6,$0631,$0001,$0000
	dc.w	$6100,$13E0,$6100,$EA3C,$08B9,$0003,$0001,$7F70
	dc.w	$6100,$103E,$33FC,$2710,$0001,$7F82,$0839,$0000
	dc.w	$0001,$7F78,$6700,$0006,$6000,$0008,$7007,$6100
	dc.w	$0072,$4279,$0001,$7EEE,$426B,$0028,$426B,$002A
	dc.w	$7006,$4A6B,$0000,$6A00,$0004,$4440,$3740,$0000
	dc.w	$303C,$0110,$4A6B,$0014,$6A00,$0004,$4440,$3740
	dc.w	$0014,$377C,$0600,$002C,$426B,$0018,$50F9,$0001
	dc.w	$7E38,$50F9,$0001,$7E3C,$08EB,$0002,$0062,$303C
	dc.w	$001A,$6100,$AE24,$2F0B,$D6FC,$0080,$323C,$102E
	dc.w	$6100,$AEF2,$2669,$0022,$700E,$6100,$DF7E,$265F
	dc.w	$4E75,$2F0B,$266A,$0022,$7605,$4A6B,$0034,$6F00
	dc.w	$0026,$082B,$0000,$0063,$6600,$001C,$08AB,$0002
	dc.w	$0062,$08AB,$0003,$0064,$6700,$0008,$4EB9,$0002
	dc.w	$AF00,$6100,$ADC8,$D6FC,$0080,$51CB,$FFCE,$265F
	dc.w	$4E75,$3039,$0001,$80E4,$4840,$4240,$E488,$8079
	dc.w	$0001,$80EA,$9079,$0001,$80E6,$4E75,$082B,$0005
	dc.w	$0063,$6600,$0AC0,$0C6B,$000A,$0018,$6E00,$0AB6
	dc.w	$0C6B,$000B,$0052,$6E00,$0AAC,$48A7,$3000,$966A
	dc.w	$0014,$3003,$946A,$0000,$3202,$4440,$E942,$C5C2
	dc.w	$84FC,$0400,$0C42,$0100,$6200,$0054,$E943,$C7C3
	dc.w	$86FC,$0079,$D642,$0C43,$0100,$6200,$0042,$4C9F
	dc.w	$000C,$6100,$0040,$48A7,$3000,$48A7,$C000,$C1C0
	dc.w	$C3C1,$D081,$6100,$BAEC,$3400,$4C9F,$0003,$0642
	dc.w	$0001,$E180,$81C2,$E181,$83C2,$08F9,$0004,$0001
	dc.w	$7F76,$6100,$019C,$08B9,$0004,$0001,$7F76,$4C9F
	dc.w	$000C,$4E75,$48E7,$C000,$0839,$0007,$00FF,$800E
	dc.w	$66F6,$33FC,$001B,$00FF,$8020,$08F9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$67F6,$3039,$00FF
	dc.w	$8010,$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007
	dc.w	$00FF,$800F,$0240,$001F,$6600,$0044,$3039,$0001
	dc.w	$7B94,$906A,$0014,$0C40,$0028,$6E00,$0032,$0C40
	dc.w	$FFD8,$6D00,$002A,$302B,$0028,$322B,$002A,$0C40
	dc.w	$2000,$6E00,$0020,$0C40,$E000,$6D00,$0018,$0C41
	dc.w	$2000,$6E00,$0010,$0C41,$E000,$6D00,$0008,$4CDF
	dc.w	$0003,$4E75,$DEFC,$000C,$E440,$E441,$3540,$0028
	dc.w	$3541,$002A,$426B,$0028,$426B,$002A,$08F9,$0006
	dc.w	$0001,$7F6A,$0839,$0000,$0001,$7F68,$6600,$0966
	dc.w	$7008,$6000,$DDB6,$0C6B,$000E,$0052,$6600,$00B2
	dc.w	$0C6B,$001D,$0018,$6E00,$0060,$0C6B,$0012,$0018
	dc.w	$6300,$009E,$0C6B,$0118,$0014,$6D00,$004C,$0C6B
	dc.w	$000D,$0000,$6D00,$008A,$0C6B,$000F,$0000,$6E00
	dc.w	$0080,$0C6B,$0FA0,$002A,$6D00,$0076,$2F0B,$E0EB
	dc.w	$002A,$D6FC,$0080,$323C,$1078,$6100,$ACC8,$265F
	dc.w	$3F3C,$000E,$6100,$BA0A,$0679,$0258,$0001,$7CD2
	dc.w	$0679,$000F,$0001,$7CD8,$08F9,$0006,$0001,$7F6A
	dc.w	$08EB,$0002,$0062,$4A6B,$0014,$6A00,$0008,$006B
	dc.w	$8000,$0004,$426B,$0086,$0839,$0000,$0001,$7F68
	dc.w	$6600,$08C2,$2F0B,$3039,$0001,$7EC8,$EF40,$267C
	dc.w	$0001,$7480,$D6C0,$7006,$6100,$DD00,$265F,$4E75
wallcoll						;d0 = cosine, d1 = sine of angle of incidence with wall, a3 = object.
									;Bounce a3 off the wall: the puck loses speed, flips and plays
									;sfx $28-$2B; a player sets the wall collision bit (unless sflags6 bit 4)
									;and plays SFXplayerwall on a hard hit. Called from checkgoal, checkgoalp
									;and wallcollb
	move.w	d0,$4E(a3)
	move.w	d1,$50(a3)
	movem.l	d2-d3,-(sp)
	movem.w	d0-d1,-(sp)
	muls.w	$2A(a3),d0
	muls.w	$28(a3),d1
	sub.l	d1,d0
	asr.l	#$8,d0
	move.w	d0,d2
	movem.w	(sp),d0-d1
	muls.w	$28(a3),d0
	muls.w	$2A(a3),d1
	add.l	d1,d0
	asr.l	#$8,d0
	move.w	d0,d3
	neg.w	d2
	cmpi.w	#$E,$52(a3)
	bne.w	.player
	bclr	#$4,$17F6C.l
	tst.w	d2
	bpl.w	.nocoll
	asr.w	#$2,d2		;reduce normal speed on puck
	cmpi.w	#$FC00,d2
	bgt.w	.pok
	move.w	#$800,d0
	bsr.w	randomd0-LOAD
	neg.w	d0
	move.w	d0,$2C(a3)
	bsr.w	X_1AEF8
	move.w	d2,d0		;sfx $28 + ((v1n >> 10) + 4) & 3
	asr.w	#$8,d0
	asr.w	#$2,d0
	addi.w	#$4,d0
	bpl.w	.sf0
	clr.w	d0
.sf0	andi.w	#$3,d0
	addi.w	#$28,d0
	move.w	d0,-(sp)
	bsr.w	sfx-LOAD
.pok	move.w	d3,d0		;reduce tangent speed on puck
	asr.w	#$6,d0
	sub.w	d0,d3
	asr.w	#$1,d0
	sub.w	d0,d3
	bra.w	.noadd
.player	cmpi.w	#$3E8,d2
	bgt.w	.nocoll
	bclr	#$4,(sflags6).l		;set by checkgoalp
	bne.w	.0
	bset	#$4,$64(a3)		;set wall collision bit
.0	cmpi.w	#$F000,d2
	bgt.w	.nosfx
	cmpi.w	#$A,$32(a3)
	blt.w	.nosfx
	move.w	#$20,-(sp)
	bsr.w	sfx-LOAD
.nosfx	asr.w	#$2,d2		;reduce normal speed on player to 1/4
	cmpi.w	#$FC7C,d2
	blt.w	.noadd
	move.w	#$FC18,d2
.noadd	movem.w	(sp),d0-d1		;rotate normal/tangent speeds (d2/d3) back into Xvel/Yvel
	movem.w	d2-d3,-(sp)
	muls.w	d0,d3
	muls.w	d1,d2
	sub.l	d2,d3
	asr.l	#$8,d3
	move.w	d3,$28(a3)
	movem.w	(sp)+,d2-d3
	movem.w	(sp),d0-d1
	muls.w	d1,d3
	muls.w	d0,d2
	add.l	d2,d3
	asr.l	#$8,d3
	move.w	d3,$2A(a3)
	tst.w	$2C(a3)
	bmi.w	.nocoll
	clr.w	$2C(a3)
.nocoll	adda.w	#$4,sp		;drop saved cos/sin
	movem.l	(sp)+,d2-d3
	rts
checkpuckcoll_sfx						;Entered from checkpuckcoll. Puck in the air: sfx 5 once when sflags4 bit
									;2 is set
	bclr	#$2,$17F72.l
	beq.w	X_21000
	move.w	#$5,-(sp)
	bra.w	sfx-LOAD
	cmpi.w	#$190,$14(a3)
	bgt.w	.l20896
	cmpi.w	#$FE70,$14(a3)
	bgt.w	.l2089A
.l20896	clr.w	$2A(a3)
.l2089A	cmpi.w	#$10,$18(a3)
	bgt.w	checkpuckcoll_sfx
	move.w	$52(a3),d0
	asl.w	#$1,d0
	movea.l	#$17CA0,a0
	movea.l	#$17CC0,a1
	movea.l	#$17C80,a2
	move.w	(a0,d0.w),d1
	cmpi.w	#$F,d1
	beq.w	X_208E8
	dc.w	$4244,$1831,$1001,$3A32,$4000,$9A6B,$0014,$0C45
	dc.w	$0016,$6E00,$000C,$6100,$0032,$5241,$6000,$FFDA
	dc.w	$3230,$0000,$6700,$0022,$4244,$1831,$10FF,$3A2B
	dc.w	$0014,$9A72,$4000,$0C45,$0016,$6E00,$000C,$6100
	dc.w	$000A,$5341,$6600,$FFE2,$4E75,$48E7,$FFF0,$E24C
	dc.w	$B879,$0001,$7BE0,$6700,$0116,$0C44,$000B,$6E00
	dc.w	$010E,$EF44,$247C,$0001,$7480,$D4C4,$0839,$0002
	dc.w	$0001,$7F70,$6700,$0018,$EE44,$B879,$0001,$9368
	dc.w	$6700,$000C,$B879,$0001,$936A,$6600,$00E2,$082A
	dc.w	$0002,$0062,$6600,$00D8,$4A2A,$005E,$6600,$00D0
	dc.w	$082A,$0002,$0063,$6600,$0070,$0C6B,$0005,$0018
	dc.w	$6E00,$0066,$0C6B,$0200,$002C,$6E00,$005C,$2F0A
	dc.w	$6100,$A9D8,$D06A,$0000,$906B,$0000,$0C40,$000E
	dc.w	$6E00,$0046,$0C40,$FFF2,$6D00,$003E,$D26A,$0014
	dc.w	$926B,$0014,$0C41,$000E,$6E00,$002E,$0C41,$FFF2
	dc.w	$6D00,$0026,$C1C0,$C3C1,$D081,$223C,$0000,$00C4
	dc.w	$4A2B,$005E,$6F00,$0004,$E449,$B081,$6200,$000A
	dc.w	$6100,$0256,$6000,$0058,$4A6A,$0034,$6700,$00A6
	dc.w	$082A,$0003,$0064,$6600,$0046,$302A,$0000,$906B
	dc.w	$0000,$0C40,$0008,$6E00,$0036,$0C40,$FFF8,$6D00
	dc.w	$002E,$322A,$0014,$926B,$0014,$0C41,$0008,$6E00
	dc.w	$001E,$0C41,$FFF8,$6D00,$0016,$C1C0,$C3C1,$D081
	dc.w	$0C80,$0000,$0040,$6200,$0006,$6100,$052E,$4CDF
	dc.w	$0FFF,$4E75,$000C,$000C,$000D,$000D,$000D,$000D
	dc.w	$000D,$000D,$000D,$000D,$000E,$000E,$000E,$000E
	dc.w	$000F,$000F,$000F,$000F,$000F,$000F,$0090,$0090
	dc.w	$00A9,$00A9,$00A9,$00A9,$00A9,$00A9,$00A9,$00A9
	dc.w	$00C4,$00C4,$00C4,$00C4,$00E1,$00E1,$00E1,$00E1
	dc.w	$00E1,$00E1,$2F08,$207C,$0003,$BA3C,$4240,$102A
	dc.w	$0068,$0839,$0001,$0001,$7F7C,$6600,$000E,$0839
	dc.w	$0006,$0001,$7F7A,$6700,$0006,$0600,$0002,$E248
	dc.w	$082A,$0003,$0062,$6700,$0006,$303C,$000F,$D040
	dc.w	$0839,$0000,$0001,$7F78,$6700,$000C,$4A40,$6700
	dc.w	$0006,$0440,$0002,$0C40,$001E,$6D00,$0006,$303C
	dc.w	$001E,$33F0,$0000,$0001,$7EB4,$207C,$0003,$BA64
	dc.w	$42B9,$0001,$7EB6,$33F0,$0000,$0001,$7EB8,$33F9
	dc.w	$0001,$7EB4,$0001,$7EBA,$4479,$0001,$7EBA,$0839
	dc.w	$0001,$0001,$7F76,$6700,$001C,$33FC,$000C,$0001
	dc.w	$7EB4,$23FC,$0000,$0090,$0001,$7EB6,$33FC,$FFF4
	dc.w	$0001,$7EBA,$0C6A,$0250,$0058,$6700,$000C,$0C6A
	dc.w	$02A2,$0058,$6600,$001C,$33FC,$0012,$0001,$7EB4
	dc.w	$23FC,$0000,$0144,$0001,$7EB6,$33FC,$FFEE,$0001
	dc.w	$7EBA,$205F,$0C79,$000F,$0001,$7B98,$6E00,$0094
	dc.w	$302A,$0000,$0C6A,$0250,$0058,$6700,$0014,$0C6A
	dc.w	$02A2,$0058,$6600,$0028,$323C,$0006,$6000,$0006
	dc.w	$323C,$FFFA,$082A,$0007,$0062,$6600,$0004,$4441
	dc.w	$082A,$0000,$0076,$6700,$0004,$4441,$D041,$906B
	dc.w	$0000,$B079,$0001,$7EB4,$6E00,$0048,$B079,$0001
	dc.w	$7EBA,$6D00,$003E,$322A,$0014,$926B,$0014,$B279
	dc.w	$0001,$7EB4,$6E00,$002C,$B279,$0001,$7EBA,$6D00
	dc.w	$0022,$48A7,$C000,$C1C0,$C3C1,$D081,$B0B9,$0001
	dc.w	$7EB6,$4C9F,$0003,$6200,$000A,$6100,$03FE,$6000
	dc.w	$FE2E,$08B9,$0002,$0001,$7F72,$6700,$FE22,$3039
	dc.w	$0001,$7BE0,$B06A,$0052,$6700,$FE14,$3F3C,$0005
	dc.w	$6100,$B4E2,$6000,$FE08
puckstick						;puck collides with stick. a2 = player who collided, a3 = puck, d0 =
									;distance^2 (from checkpuckcoll .ccx). A stick check on the puck carrier
									;can steal the puck (Stk rolls, smaller ranges when the carrier is in the
									;slot, sflags6 bit 5), else a slow enough puck is caught (puckglue); a
									;one-timer shoots it (onetimershot). Uses the slot ranges and the
									;skater, or no highlight: the stick takes the puck (steal check if someone
									;has it)
	tst.w	$34(a2)		;a2 = player who collided
	bne.w	.0		;branch if not goalie
	btst	#$4,$17F68.l
	bne.w	X_21000		;exit if so (goalie always lets the shot in)
.0	bclr	#$0,$62(a2)
	move.w	$17BE0.l,d1		;move puckc into d1
	bmi.w	.nosteal		;branch if no puck carrier
	asl.w	#$7,d1
	movea.l	#SortCords,a0
	adda.w	d1,a0		;a0 = Struct of puck carrier
	move.b	$62(a0),d1
	move.b	$62(a2),d2
	eor.w	d1,d2		;compare pflags of each player
	btst	#$6,d2		;check if on same team
	beq.w	X_21000		;no stealing from teammate
	btst	#$5,(sflags6).l		;check if puckc is in slot
	beq.w	.noslot
	cmpi.l	#$40,d0		;steal range met: goalies always steal, nobody steals from a goalie
	bhi.w	X_21000
	bra.w	.1
.noslot	cmpi.l	#$24,d0
	bhi.w	X_21000
.1	tst.w	$34(a2)		;check if colliding player is goalie
	beq.w	.steal
	tst.w	$34(a0)
	beq.w	X_21000		;no stealing from goalie
	move.b	$71(a0),d0
	lsr.b	#$1,d0
	bsr.w	makepde-LOAD		;adjust for energy level
	move.w	d0,-(sp)
	exg.l	a0,a2		;swap a2 and a0 (a0 now collider)
	move.b	$71(a0),d0		;Stk for collider
	lsr.b	#$1,d0		;divie by 2
	bsr.w	makepde-LOAD		;adjust for energy
	exg.l	a0,a2		;swap back (a0 now puckc)
	neg.w	d0
	add.w	(sp)+,d0		;add puckc modified Stk
	addi.w	#$24,d0		;add 24 hex (36 decimal)
	bsr.w	randomd0-LOAD
	btst	#$5,(sflags6).l		;check if puckc is in slot
	beq.w	.2
	cmpi.w	#$4,d0		;steal: the carrier cannot touch the puck for a while (stick handling,
	bhi.w	X_21000		;exit if higher (not losing puck)
	bra.w	.steal
.2	cmpi.w	#$2,d0		;compare 2 to d0
	bhi.w	X_21000		;exit if higher (not losing puck)
.steal	move.b	$71(a0),d0		;Stk of puckc
	lsr.b	#$1,d0
	bsr.w	makepde-LOAD		;adj for energy
	addi.w	#$14,d0		;add 14 hex (20 dec)
	move.b	d0,$5E(a0)		;move result into nopuck (cant get puck timer)
	exg.l	a0,a2		;swap a0 and a2 (a0 now collider)
	move.b	$71(a0),d0		;Stk of collider
	lsr.b	#$1,d0
	bsr.w	makepde-LOAD		;adj for energy
	addi.w	#$14,d0		;add 14 hex (20 dec)
	move.b	d0,$5E(a0)		;move result into nopuck
	exg.l	a0,a2
	move.w	$52(a0),(lastplayer).l		;SCNum of puckc into lastplayer
	bclr	#$2,$17F6A.l		;clear pass dir mode
	bclr	#$3,$17F6A.l		;clear shot dir mode
.stdef	move.w	#$6,-(sp)
	bsr.w	sfx-LOAD
	bsr.w	X_1AD28		;deflect
	bra.w	X_21246		;no carrier (goalie in the smaller range): one-timer check
.nosteal	tst.w	$34(a2)
	bne.w	.onetimerchk
	cmpi.l	#$40,d0
	bhi.w	X_21000		;smaller range for stealing puck
.onetimerchk	btst	#$3,$64(a2)
	beq.w	.nosteal2
	cmpi.l	#$64,d0		;not a one-timer, or past its frame: catch or deflect by puck speed
	bhi.w	.3
	cmpi.w	#$18,$5A(a2)
	bge.w	.nosteal2
	move.w	#$18,$5A(a2)
	bset	#$7,$17F7C.l
.nosteal2	move.w	(puckvx).l,d0		;d0 = puck speed^2, d1 = catch limit
	move.w	(puckvy).l,d1
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	clr.w	d1
	btst	#$4,$17F6C.l		;check if shot was taken
	bne.w	.nohand
	btst	#$3,$64(a2)		;check if one timer
	bne.w	.onetimer
	move.b	$71(a2),d1
	mulu.w	#$15E,d1
.nohand	addi.w	#$32C8,d1
	mulu.w	d1,d1
	cmp.l	d1,d0
	bls.w	puckglue-LOAD
	move.b	#$8,$5E(a2)
	bra.w	.stdef
.onetimer	exg.l	a2,a3
	jsr	(onetimershot).l
	exg.l	a2,a3
	rts
.3	cmpi.l	#$144,d0
	bhi.w	.ex2
	cmpi.w	#$18,$5A(a2)
	bge.w	.ex2
	move.w	#$18,$5A(a2)
.ex2	rts
