	include	segacd\hockey.inc
	include	macros\genesis.mac

Hpos	equ	$17CEE
SmallFontMap	equ	$47D3C
Vpos	equ	$17CEA
move	equ	$2C9C8

	org	$23684

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
