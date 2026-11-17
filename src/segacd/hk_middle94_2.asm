	include	segacd\hockey.inc
	include	macros\genesis.mac

FourWayPlay	equ	$18BF8
HandleMenuInput	equ	$2C368
LOAD	equ	$1B000
ReadJoy1	equ	$374F0
ReadJoy2	equ	$3750E
RunArenaAnim	equ	$2A1AA
ScoutSubStatus	equ	$17474
move	equ	$2C9C8
pausepad	equ	$17F94
updatecrowdf	equ	$2BD28
X_1C52C	equ	$1C52C
X_1C54A	equ	$1C54A
X_21000	equ	$21000
X_22D16	equ	$22D16

	org	$1C2D0

	dc.w	$4279,$0001,$AD76,$4440,$33C0,$0001,$7474,$6100
	dc.w	$0210,$8779,$0001,$AD76,$4A41,$6600,$4D14,$6100
	dc.w	$021E,$8779,$0001,$AD76,$4A41,$6600,$4D04,$4A79
	dc.w	$0001,$8BF8,$6700,$0022,$6100,$0222,$8779,$0001
	dc.w	$AD76,$4A41,$6600,$4CEA,$6100,$0230,$8779,$0001
	dc.w	$AD76,$4A41,$6600,$4CDA,$3039,$0001,$7474,$B079
	dc.w	$0001,$7474,$6700,$FFF8,$4A40,$6B00,$FFA2,$4E75
waitxsr						;Wait d0 vblanks while the zamboni crosses
	movem.l	d4-d7/a0-a3,-(sp)
	neg.w	d0		;Vcount counts up from -d0 to 0
	move.w	d0,(ScoutSubStatus).l		;frame counter
.wait	cmpi.w	#$708,$17CE2.l		;zamboni across?
	bhi.w	.nz		;zamboni past $708: stop moving it
	addi.w	#$1,$17CE2.l
.nz	moveq	#$1,d7		;1 frame
	jsr	(updatecrowdf).l		;4EB8: target below $8000
	jsr	(RunArenaAnim).l
	clr.w	(pausepad).l
	bclr	#$1,$17F6A.l
	bsr.w	ReadJoy1-LOAD
	bsr.w	ProcessInputWithRepeat
	tst.w	d1		;any press?
	bne.w	.key
	clr.w	(pausepad).l
	bset	#$1,$17F6A.l
	bsr.w	ReadJoy2-LOAD
	bsr.w	ProcessInputWithRepeat
	tst.w	d1		;any press?
	bne.w	.key
	tst.w	(FourWayPlay).l		;four way?
	beq.w	.vid
	bclr	#$1,$17F6A.l
	move.w	#$3,(pausepad).l
	bsr.w	X_1C52C
	bsr.w	ProcessInputWithRepeat
	tst.w	d1		;any press?
	bne.w	.key
	tst.w	(FourWayPlay).l		;four way?
	beq.w	.vid
	bset	#$1,$17F6A.l
	move.w	#$4,(pausepad).l
	bsr.w	X_1C54A
	bsr.w	ProcessInputWithRepeat
	tst.w	d1		;any press?
	beq.w	.vid
.key	move.w	(ScoutSubStatus).l,d0		;frame counter
	cmpi.w	#$FF88,d0		;more than $78 frames left?
	blt.w	.menu
	moveq	#-120,d0
.menu	movem.w	d0,-(sp)
	jsr	(HandleMenuInput).l		;4EB8: target below $8000
	bne.w	.resume		;menu did not end the screen: carry on waiting
	adda.w	#$2,sp		;drop it
	bset	#$7,d1		;tell the caller the menu ended it
	bra.w	.ex
.resume	move.w	(sp)+,(ScoutSubStatus).l
.vid	bsr.w	X_22D16
	move.w	(ScoutSubStatus).l,d0		;frame counter
.0	cmp.w	(ScoutSubStatus).l,d0		;wait for the next vblank
	beq.w	.0		;wait for a new frame
	tst.w	d0		;time left?
	bmi.w	.wait
.ex	movem.l	(sp)+,d4-d7/a0-a3
	rts
	dc.w	$3039,$0001,$7474,$B079,$0001,$7474,$6700,$FFF8
	dc.w	$6100,$0008,$6700,$FFEA,$4E75
orjoy						;return d1 = new button presses from either joystick
	tst.w	(FourWayPlay).l		;check for 4-way play?
	bne.w	.4way
	bsr.w	ReadJoy1-LOAD
	move.w	d1,-(sp)
	bsr.w	ReadJoy2-LOAD
	or.w	(sp)+,d1
	rts
.4way	bsr.w	ReadJoy1-LOAD
	move.w	d1,-(sp)
	bsr.w	ReadJoy2-LOAD
	move.w	d1,-(sp)
	bsr.w	X_1C52C
	move.w	d1,-(sp)
	bsr.w	X_1C54A
	or.w	(sp)+,d1
	or.w	(sp)+,d1
	or.w	(sp)+,d1
	rts
nodiag						;eliminate diagonal direction presses: if held directions (d3 bits 0-3)
									;are not one direction, clear the d1 direction bits
	movem.l	d0/d4-d5,-(sp)
	moveq	#$3,d4		;d4 = direction bit 3..0
	move.w	d3,d0
	andi.w	#$F,d0		;held directions
	beq.w	.ok		;none held
.0	clr.w	d5		;test each single-bit direction against the held set
	bset	d4,d5		;single direction bit
	cmp.w	d5,d0		;matches?
	dbeq	d4,.0		;loop
	beq.w	.ok		;exactly one direction held
	andi.w	#$FFF0,d1		;diagonal: drop the direction presses
.ok	movem.l	(sp)+,d0/d4-d5
	rts
ProcessInputWithRepeat						;nodiag, then key repeat on d1-d3
	bsr.w	nodiag
	tst.w	d3		;anything held?
	beq.w	X_21000
	tst.w	d2		;changed?
	bne.w	.chg		;buttons changed: restart the delay
	subi.w	#$1,$17478.l
	bpl.w	X_21000
	move.w	#$4,$17478.l		;repeat rate
	move.w	d3,d1		;repeat the held buttons
	rts
.chg	move.w	#$F,$17478.l
	rts
	dc.w	$1039,$0001,$7E46,$6100,$0070,$3439,$0001,$7E3E
	dc.w	$33C1,$0001,$7E3E,$3601,$B342,$C242,$4E75,$1039
	dc.w	$0001,$7E47,$6100,$0052,$3439,$0001,$7E40,$33C1
	dc.w	$0001,$7E40,$3601,$B342,$C242,$4E75,$1039,$0001
	dc.w	$7E48,$6100,$0034,$3439,$0001,$7E42,$33C1,$0001
	dc.w	$7E42,$3601,$B342,$C242,$4E75,$1039,$0001,$7E49
	dc.w	$6100,$0016,$3439,$0001,$7E44,$33C1,$0001,$7E44
	dc.w	$3601,$B342,$C242,$4E75,$4600,$4241,$1200,$3F01
	dc.w	$0240,$00F0,$0241,$000F,$41F9,$0003,$7588,$1230
	dc.w	$1000,$8041,$321F,$4E75,$0800,$0408,$0607,$0508
	dc.w	$0201,$0308,$0808,$0808,$48E7,$0180,$3E3C,$0002
	dc.w	$207C,$0004,$820A,$4EB8,$6044,$4CDF,$0180,$4EB9
	dc.w	$0003,$75B6,$4E75,$48E7,$8080,$41F9,$0004,$7CFC
	dc.w	$203C,$0000,$002B,$4298,$51C8,$FFFC,$4CDF,$0101
	dc.w	$4E75,$563A,$7E00,$3E39,$0003,$75D2,$E24F,$6400
	dc.w	$0006,$0A47,$B400,$33C7,$0003,$75D2,$8FFC,$FFFF
	dc.w	$4847,$4E75,$48E7,$C080,$2079,$0004,$7D88,$2208
	dc.w	$701B,$D398,$51C8,$FFFC,$D398,$5488,$4A90,$6600
	dc.w	$FFF8,$5888,$4A90,$6600,$FFF0,$4CDF,$0103,$4E75
	dc.w	$48E7,$C080,$207C,$0008,$0000,$2208,$92B9,$0004
	dc.w	$7D88,$701B,$D398,$51C8,$FFFC,$D398,$5488,$4A90
	dc.w	$6600,$FFF8,$5888,$4A90,$6600,$FFF0,$4CDF,$0103
	dc.w	$4E75,$48E7,$F0F8,$2079,$0004,$7D88,$227C,$0008
	dc.w	$0000,$303C,$88B8,$22D8,$51C8,$FFFC,$2079,$0004
	dc.w	$7D88,$4EB9,$0003,$7620,$2248,$D3FC,$0000,$07D0
	dc.w	$247C,$0008,$0000,$3039,$0001,$7FB0,$611C,$3039
	dc.w	$0001,$7FAE,$6114,$D1FC,$0000,$EA60,$3E3C,$0002
	dc.w	$4EB8,$6044,$4CDF,$1F0F,$4E75,$3400,$E542,$2230
	dc.w	$2000,$9288,$363C,$012C,$2672,$1000,$2849,$22DB
	dc.w	$51CB,$FFFC,$218C,$1000,$5C41,$4AB0,$1000,$6600
	dc.w	$FFE4,$4E75,$48E7,$C080,$2079,$0004,$7D8C,$2208
	dc.w	$203C,$0000,$001B,$D398,$51C8,$FFFC,$4CDF,$0103
	dc.w	$4E75,$48E7,$FFE0,$08B9,$0005,$00FF,$800F,$0839
	dc.w	$0007,$00FF,$800E,$66F6,$33FC,$003D,$00FF,$8020
	dc.w	$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF,$800E
	dc.w	$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007
	dc.w	$00FF,$800F,$08F9,$0005,$00FF,$800F,$4CDF,$07FF
	dc.w	$4E75,$48E7,$FFE0,$7000,$6100,$0400,$4CDF,$07FF
	dc.w	$4E75,$3F39,$0001,$8D64,$08F9,$0002,$0001,$8D64
	dc.w	$6100,$000A,$33DF,$0001,$8D64,$4E75,$2F0E,$2C79
	dc.w	$0001,$9360,$0839,$0005,$00FF,$800F,$6706,$3D3C
	dc.w	$0001,$6004,$3D3C,$0000,$08B9,$0005,$00FF,$800F
	dc.w	$23CE,$0001,$9360,$2C5F,$48E7,$3060,$B1FC,$0008
	dc.w	$0000,$6C00,$0018,$2600,$E24B,$45F9,$000B,$C000
	dc.w	$24D8,$51CB,$FFFC,$41F9,$000B,$C000,$43F9,$00C0
	dc.w	$0004,$23D0,$000B,$BC96,$23C1,$000B,$BC9A,$D1FC
	dc.w	$0018,$0002,$33FC,$8154,$000B,$BC88,$33FC,$8F02
	dc.w	$000B,$BC8A,$343C,$9300,$1400,$33C2,$000B,$BC8C
	dc.w	$343C,$9400,$E048,$1400,$33C2,$000B,$BC8E,$2008
	dc.w	$E288,$343C,$9500,$1400,$33C2,$000B,$BC90,$E088
	dc.w	$343C,$9600,$1400,$33C2,$000B,$BC92,$E088,$0200
	dc.w	$007F,$343C,$9700,$1400,$33C2,$000B,$BC94,$4280
	dc.w	$3001,$E580,$E448,$2600,$0080,$0080,$4000,$23C0
	dc.w	$000B,$BC9E,$4EB9,$0002,$22C2,$0839,$0007,$00FF
	dc.w	$800E,$66F6,$33FC,$0008,$00FF,$8020,$08F9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$67F6,$08F9
	dc.w	$0007,$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F
	dc.w	$4EB9,$0002,$2268,$2F0E,$2C79,$0001,$9360,$4A5E
	dc.w	$670A,$08F9,$0005,$00FF,$800F,$6008,$08B9,$0005
	dc.w	$00FF,$800F,$23CE,$0001,$9360,$2C5F,$4CDF,$060C
	dc.w	$4E75,$48E7,$3060,$B1FC,$0008,$0000,$6C00,$0018
	dc.w	$2600,$E24B,$45F9,$000B,$C000,$24D8,$51CB,$FFFC
	dc.w	$41F9,$000B,$C000,$43F9,$00C0,$0004,$23D0,$000B
	dc.w	$BC96,$23C1,$000B,$BC9A,$D1FC,$0018,$0002,$33FC
	dc.w	$8154,$000B,$BC88,$33FC,$8F02,$000B,$BC8A,$343C
	dc.w	$9300,$1400,$33C2,$000B,$BC8C,$343C,$9400,$E048
	dc.w	$1400,$33C2,$000B,$BC8E,$2008,$E288,$343C,$9500
	dc.w	$1400,$33C2,$000B,$BC90,$E088,$343C,$9600,$1400
	dc.w	$33C2,$000B,$BC92,$E088,$0200,$007F,$343C,$9700
	dc.w	$1400,$33C2,$000B,$BC94,$4280,$3001,$E580,$E448
	dc.w	$2600,$0080,$0080,$4000,$23C0,$000B,$BC9E,$4EB9
	dc.w	$0002,$22C2,$0839,$0004,$00FF,$800E,$66F6,$33FC
	dc.w	$0032,$00FF,$8026,$08F9,$0003,$00FF,$800F,$0839
	dc.w	$0003,$00FF,$800E,$67F6,$08F9,$0004,$00FF,$800F
	dc.w	$08B9,$0003,$00FF,$800F,$0839,$0003,$00FF,$800E
	dc.w	$66F6,$08B9,$0004,$00FF,$800F,$4EB9,$0002,$2268
	dc.w	$4CDF,$060C,$4E75,$2F0E,$2C79,$0001,$9360,$0839
	dc.w	$0005,$00FF,$800F,$6706,$3D3C,$0001,$6004,$3D3C
	dc.w	$0000,$08B9,$0005,$00FF,$800F,$23CE,$0001,$9360
	dc.w	$2C5F,$3F39,$0001,$8D64,$08F9,$0002,$0001,$8D64
	dc.w	$23C0,$000B,$BC88,$23C1,$000B,$BC8C,$23C2,$000B
	dc.w	$BC90,$4EB9,$0002,$22C2,$0839,$0007,$00FF,$800E
	dc.w	$66F6,$33FC,$001E,$00FF,$8020,$08F9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$67F6,$08F9,$0007
	dc.w	$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839,$0006
	dc.w	$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F,$4EB9
	dc.w	$0002,$2268,$33DF,$0001,$8D64,$2F0E,$2C79,$0001
	dc.w	$9360,$4A5E,$670A,$08F9,$0005,$00FF,$800F,$6008
	dc.w	$08B9,$0005,$00FF,$800F,$23CE,$0001,$9360,$2C5F
	dc.w	$4E75,$2F0E,$2C79,$0001,$9360,$0839,$0005,$00FF
	dc.w	$800F,$6706,$3D3C,$0001,$6004,$3D3C,$0000,$08B9
	dc.w	$0005,$00FF,$800F,$23CE,$0001,$9360,$2C5F,$23C0
	dc.w	$000B,$BC88,$23C1,$000B,$BC8C,$23C2,$000B,$BC90
	dc.w	$4EB9,$0002,$22C2,$0839,$0007,$00FF,$800E,$66F6
	dc.w	$33FC,$001F,$00FF,$8020,$08F9,$0006,$00FF,$800F
	dc.w	$0839,$0006,$00FF,$800E,$67F6,$08F9,$0007,$00FF
	dc.w	$800F,$08B9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$66F6,$08B9,$0007,$00FF,$800F,$4EB9,$0002
	dc.w	$2268,$2F0E,$2C79,$0001,$9360,$4A5E,$670A,$08F9
	dc.w	$0005,$00FF,$800F,$6008,$08B9,$0005,$00FF,$800F
	dc.w	$23CE,$0001,$9360,$2C5F,$4E75,$207C,$000B,$BCB0
	dc.w	$723F,$30C0,$51C9,$FFFC,$33FC,$0018,$0001,$8D62
	dc.w	$6100,$F1F4,$2F0E,$2C79,$0001,$9360,$0839,$0005
	dc.w	$00FF,$800F,$6706,$3D3C,$0001,$6004,$3D3C,$0000
	dc.w	$08B9,$0005,$00FF,$800F,$23CE,$0001,$9360,$2C5F
	dc.w	$3F39,$0001,$8D64,$08F9,$0002,$0001,$8D64,$0839
	dc.w	$0007,$00FF,$800E,$66F6,$33FC,$8F02,$00FF,$8022
	dc.w	$33FC,$000A,$00FF,$8020,$08F9,$0006,$00FF,$800F
	dc.w	$0839,$0006,$00FF,$800E,$67F6,$08F9,$0007,$00FF
	dc.w	$800F,$08B9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$66F6,$08B9,$0007,$00FF,$800F,$4240,$6100
	dc.w	$0B1E,$4281,$0839,$0007,$00FF,$800E,$66F6,$33FC
	dc.w	$0020,$00FF,$8020,$08F9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$67F6,$08F9,$0007,$00FF,$800F
	dc.w	$08B9,$0006,$00FF,$800F,$0839,$0006,$00FF,$800E
	dc.w	$66F6,$08B9,$0007,$00FF,$800F,$303C,$8C00,$0839
	dc.w	$0001,$0001,$8D64,$6600,$0006,$0040,$0081,$0839
	dc.w	$0007,$00FF,$800E,$66F6,$33C0,$00FF,$8022,$33FC
	dc.w	$000A,$00FF,$8020,$08F9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$67F6,$08F9,$0007,$00FF,$800F
	dc.w	$08B9,$0006,$00FF,$800F,$0839,$0006,$00FF,$800E
	dc.w	$66F6,$08B9,$0007,$00FF,$800F,$0839,$0007,$00FF
	dc.w	$800E,$66F6,$33FC,$8014,$00FF,$8022,$33FC,$000A
	dc.w	$00FF,$8020,$08F9,$0006,$00FF,$800F,$0839,$0006
	dc.w	$00FF,$800E,$67F6,$08F9,$0007,$00FF,$800F,$08B9
	dc.w	$0006,$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6
	dc.w	$08B9,$0007,$00FF,$800F,$0839,$0007,$00FF,$800E
	dc.w	$66F6,$33FC,$8164,$00FF,$8022,$33FC,$000A,$00FF
	dc.w	$8020,$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9
	dc.w	$0007,$00FF,$800F,$303C,$9001,$0C79,$0006,$0001
	dc.w	$8D36,$6700,$0006,$303C,$9003,$0839,$0007,$00FF
	dc.w	$800E,$66F6,$33C0,$00FF,$8022,$33FC,$000A,$00FF
	dc.w	$8020,$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9
	dc.w	$0007,$00FF,$800F,$303C,$8200,$1039,$0001,$8D34
	dc.w	$E408,$0200,$0038,$0839,$0007,$00FF,$800E,$66F6
	dc.w	$33C0,$00FF,$8022,$33FC,$000A,$00FF,$8020,$08F9
	dc.w	$0006,$00FF,$800F,$0839,$0006,$00FF,$800E,$67F6
	dc.w	$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF,$800F
	dc.w	$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007,$00FF
	dc.w	$800F,$303C,$8400,$1039,$0001,$8D38,$EA08,$0839
	dc.w	$0007,$00FF,$800E,$66F6,$33C0,$00FF,$8022,$33FC
	dc.w	$000A,$00FF,$8020,$08F9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$67F6,$08F9,$0007,$00FF,$800F
	dc.w	$08B9,$0006,$00FF,$800F,$0839,$0006,$00FF,$800E
	dc.w	$66F6,$08B9,$0007,$00FF,$800F,$303C,$8300,$1039
	dc.w	$0001,$8D3C,$E408,$0200,$003E,$0839,$0007,$00FF
	dc.w	$800E,$66F6,$33C0,$00FF,$8022,$33FC,$000A,$00FF
	dc.w	$8020,$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9
	dc.w	$0007,$00FF,$800F,$303C,$8500,$1039,$0001,$8D32
	dc.w	$E208,$0839,$0007,$00FF,$800E,$66F6,$33C0,$00FF
	dc.w	$8022,$33FC,$000A,$00FF,$8020,$08F9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$67F6,$08F9,$0007
	dc.w	$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839,$0006
	dc.w	$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F,$303C
	dc.w	$8D00,$1039,$0001,$8D30,$E408,$0839,$0007,$00FF
	dc.w	$800E,$66F6,$33C0,$00FF,$8022,$33FC,$000A,$00FF
	dc.w	$8020,$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9
	dc.w	$0007,$00FF,$800F,$0839,$0007,$00FF,$800E,$66F6
	dc.w	$33FC,$9100,$00FF,$8022,$33FC,$000A,$00FF,$8020
	dc.w	$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF,$800E
	dc.w	$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007
	dc.w	$00FF,$800F,$0839,$0007,$00FF,$800E,$66F6,$33FC
	dc.w	$9200,$00FF,$8022,$33FC,$000A,$00FF,$8020,$08F9
	dc.w	$0006,$00FF,$800F,$0839,$0006,$00FF,$800E,$67F6
	dc.w	$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF,$800F
	dc.w	$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007,$00FF
	dc.w	$800F,$0839,$0007,$00FF,$800E,$66F6,$33FC,$8700
	dc.w	$00FF,$8022,$33FC,$000A,$00FF,$8020,$08F9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$67F6,$08F9
	dc.w	$0007,$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F
	dc.w	$0839,$0007,$00FF,$800E,$66F6,$33FC,$8B00,$00FF
	dc.w	$8022,$33FC,$000A,$00FF,$8020,$08F9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$67F6,$08F9,$0007
	dc.w	$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839,$0006
	dc.w	$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F,$0839
	dc.w	$0007,$00FF,$800E,$66F6,$23FC,$4000,$0010,$00FF
	dc.w	$8022,$33FC,$000B,$00FF,$8020,$08F9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$67F6,$08F9,$0007
	dc.w	$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839,$0006
	dc.w	$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F,$0839
	dc.w	$0007,$00FF,$800E,$66F6,$23FC,$0000,$0000,$00FF
	dc.w	$8022,$33FC,$000E,$00FF,$8020,$08F9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$67F6,$08F9,$0007
	dc.w	$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839,$0006
	dc.w	$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F,$33DF
	dc.w	$0001,$8D64,$2F0E,$2C79,$0001,$9360,$4A5E,$670A
	dc.w	$08F9,$0005,$00FF,$800F,$6008,$08B9,$0005,$00FF
	dc.w	$800F,$23CE,$0001,$9360,$2C5F,$4E75,$2F0E,$2C79
	dc.w	$0001,$9360,$0839,$0005,$00FF,$800F,$6706,$3D3C
	dc.w	$0001,$6004,$3D3C,$0000,$08B9,$0005,$00FF,$800F
	dc.w	$23CE,$0001,$9360,$2C5F,$3F39,$0001,$8D64,$08F9
	dc.w	$0002,$0001,$8D64,$0839,$0007,$00FF,$800E,$66F6
	dc.w	$33FC,$8F02,$00FF,$8022,$33FC,$000A,$00FF,$8020
	dc.w	$08F9,$0006,$00FF,$800F,$0839,$0006,$00FF,$800E
	dc.w	$67F6,$08F9,$0007,$00FF,$800F,$08B9,$0006,$00FF
	dc.w	$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9,$0007
	dc.w	$00FF,$800F,$4240,$6100,$0526,$4281,$303C,$8C00
	dc.w	$0839,$0001,$0001,$8D64,$6600,$0006,$0040,$0081
	dc.w	$0839,$0007,$00FF,$800E,$66F6,$33C0,$00FF,$8022
	dc.w	$33FC,$000A,$00FF,$8020,$08F9,$0006,$00FF,$800F
	dc.w	$0839,$0006,$00FF,$800E,$67F6,$08F9,$0007,$00FF
	dc.w	$800F,$08B9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$66F6,$08B9,$0007,$00FF,$800F,$0839,$0007
	dc.w	$00FF,$800E,$66F6,$33FC,$8014,$00FF,$8022,$33FC
	dc.w	$000A,$00FF,$8020,$08F9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$67F6,$08F9,$0007,$00FF,$800F
	dc.w	$08B9,$0006,$00FF,$800F,$0839,$0006,$00FF,$800E
	dc.w	$66F6,$08B9,$0007,$00FF,$800F,$0839,$0007,$00FF
	dc.w	$800E,$66F6,$33FC,$8164,$00FF,$8022,$33FC,$000A
	dc.w	$00FF,$8020,$08F9,$0006,$00FF,$800F,$0839,$0006
