	include	segacd\hockey.inc
	include	macros\genesis.mac

move	equ	$2C9C8
swap	equ	$2779A
X_1B2F8	equ	$1B2F8
X_1B3C0	equ	$1B3C0
X_1B82A	equ	$1B82A
X_1BAE0	equ	$1BAE0
X_21000	equ	$21000

	org	$1B7B8

noturn0
	moveq	#$2,d4
	btst	#$4,$62(a3)
	beq.w	.l1B7CC
	addi.w	#$4,d4
	eori.w	#$8,d0
.l1B7CC	tst.w	d0
	beq.w	X_1B82A
	move.w	$28(a3),d0
	move.w	$2A(a3),d1
	bsr.w	X_1B2F8
	btst	#$3,d0
	bne.w	.l1B7F8
	sub.w	$54(a3),d0
	add.w	d4,d0
	andi.w	#$7,d0
	cmpi.w	#$4,d0
	blt.w	X_1BAE0
.l1B7F8	addi.w	#$1,$54(a3)
	btst	#$3,$4(a3)
	beq.w	.l1B80E
	subi.w	#$2,$54(a3)
.l1B80E	andi.w	#$7,$54(a3)
	move.w	#$50C,d1
	btst	#$4,$62(a3)
	beq.w	X_1B3C0
	move.w	#$A60,d1
	bra.w	X_1B3C0
	dc.w	$323C,$0A92,$082B,$0004,$0062,$6600,$0026,$323C
	dc.w	$05D0,$082B,$0006,$0063,$6700,$0006,$323C,$11E6
	dc.w	$3839,$0001,$7BE0,$B86B,$0052,$6600,$0006,$323C
	dc.w	$053E,$082B,$0001,$0063,$6600,$0006,$6100,$FB58
	dc.w	$082B,$0004,$0062,$6700,$0006,$0A42,$0004,$E542
	dc.w	$41FA,$0312,$3230,$2002,$3030,$2000,$342B,$0050
	dc.w	$6700,$000A,$B142,$6A00,$0004,$4240,$342B,$004E
	dc.w	$6700,$000A,$B342,$6B00,$0004,$4241,$4242,$142B
	dc.w	$0067,$E44A,$4442,$0642,$0040,$D42B,$0068,$0839
	dc.w	$0001,$0001,$7F7C,$6600,$000E,$0839,$0006,$0001
	dc.w	$7F7A,$6700,$000A,$0602,$0002,$0602,$0002,$4A6B
	dc.w	$0034,$6600,$000A,$D42B,$0068,$0642,$0010,$E242
	dc.w	$C1C2,$C3C2,$EA80,$EA81,$C1C7,$C3C7,$4A6B,$0034
	dc.w	$6600,$001E,$082B,$0003,$0062,$6700,$0014,$3439
	dc.w	$0001,$7BE0,$B46B,$0052,$6600,$0006,$E240,$E241
	dc.w	$D06B,$0028,$D26B,$002A,$3400,$3601,$C5C2,$C7C3
	dc.w	$D682,$48A7,$C000,$6100,$596E,$0839,$0004,$0001
	dc.w	$7F7A,$6700,$0006,$303C,$1000,$4242,$142B,$0069
	dc.w	$0839,$0001,$0001,$7F7C,$6600,$000E,$0839,$0006
	dc.w	$0001,$7F7A,$6700,$0012,$0602,$0002,$0C02,$001E
	dc.w	$6F00,$0006,$143C,$001E,$33C2,$0001,$7E66,$E24A
	dc.w	$C4C0,$E982,$4842,$E542,$0242,$003F,$45FA,$0118
	dc.w	$33C2,$0001,$7E6C,$2432,$2000,$23C2,$0001,$7E68
	dc.w	$0C79,$003C,$0001,$7E6C,$6C00,$002A,$0839,$0000
	dc.w	$0001,$7E67,$6700,$001E,$3439,$0001,$7E6C,$0642
	dc.w	$0004,$2432,$2000,$94B9,$0001,$7E68,$E282,$D4B9
	dc.w	$0001,$7E68,$082B,$0006,$0063,$6700,$0004,$E68A
	dc.w	$4A6B,$0034,$6600,$0012,$3039,$0001,$7BE0,$B06B
	dc.w	$0052,$6600,$0004,$E282,$4C9F,$0003,$B682,$6200
	dc.w	$000A,$3740,$0028,$3741,$002A,$4A79,$0001,$8C0A
	dc.w	$6600,$55F4,$0839,$0007,$00FF,$800E,$66F6,$33FC
	dc.w	$001B,$00FF,$8020,$08F9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$67F6,$3039,$00FF,$8010,$08F9
	dc.w	$0007,$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F
	dc.w	$0240,$007F,$6600,$55A0,$6100,$583C,$0440,$0021
	dc.w	$0C40,$0C00,$6D00,$5852,$142B,$0072,$4882,$E24A
	dc.w	$D042,$6100,$5844,$082B,$0000,$0072,$6700,$0016
	dc.w	$0839,$0000,$0001,$7475,$6700,$000A,$0640,$0001
	dc.w	$6000,$5826,$4E75,$01CD,$9410,$01FC,$E3E1,$022E
	dc.w	$8284,$0262,$6FF9,$0298,$AC40,$02D1,$3759,$030C
	dc.w	$1144,$0349,$3A01,$0388,$B190,$03CA,$77F1,$040E
	dc.w	$8D24,$0454,$F129,$049D,$A400,$04E8,$A5A9,$0535
	dc.w	$F624,$0585,$9571,$0C6B,$1000,$0028,$6E00,$0032
	dc.w	$0C6B,$F000,$0028,$6D00,$0028,$0C6B,$1000,$002A
	dc.w	$6E00,$001E,$0C6B,$F000,$002A,$6D00,$0014,$4A6B
	dc.w	$0034,$6600,$0036,$4EF9,$0002,$2F74,$6000,$002C
	dc.w	$323C,$050C,$082B,$0004,$0062,$6600,$000C,$08EB
	dc.w	$0001,$0063,$323C,$06C6,$6100,$F88C,$4A6B,$0034
	dc.w	$6600,$0008,$4EF9,$0002,$2F74
stopna
	tst.w	$28(a3)
	bpl.w	.l1BB5A
	addi.w	#$96,$28(a3)
	bmi.w	.l1BB68
	clr.w	$28(a3)
.l1BB5A	subi.w	#$96,$28(a3)
	bpl.w	.l1BB68
	clr.w	$28(a3)
.l1BB68	tst.w	$2A(a3)
	bpl.w	.l1BB7E
	addi.w	#$96,$2A(a3)
	bmi.w	X_21000
	clr.w	$2A(a3)
.l1BB7E	subi.w	#$96,$2A(a3)
	bpl.w	X_21000
	clr.w	$2A(a3)
	rts
	dc.w	$0000,$00C8,$008D,$008D,$00C8,$0000,$008D,$FF73
	dc.w	$0000,$FF38,$FF73,$FF73,$FF38,$0000,$FF73,$008D
	dc.w	$0000,$0000
UnpackNibbles						;a0 = packed data, d0 = count: unpack 4-bit values into words at
									;nibblebuffer
	movem.l	d0-d2/a0-a1,-(sp)
	movea.l	#$18BE8,a1		;a1 = output words
	clr.w	d2		;d2 bit 0 = which nibble is next
	bra.w	.l1BBD8
.loop	move.b	(a0)+,d1		;next nibble (one count per pass)
	bchg	#$0,d2		;toggle high/low nibble
	bne.w	.lo		;low nibble?
	suba.w	#$1,a0		;high nibble: read the same byte again next time
	lsr.w	#$4,d1		;high nibble down
.lo	andi.w	#$F,d1
	move.w	d1,(a1)+
.l1BBD8	dbra	d0,.loop
	movem.l	(sp)+,d0-d2/a0-a1
	rts
WeightedRandomSelect						;d0 = number of word weights at nibblebuffer:
									;return a weighted random index
	movem.l	d1/a1,-(sp)
	movea.l	#$18BE8,a1		;weights
	clr.w	d1		;d1 = running total of the weights
	bra.w	.l1BBF4
.sumloop	add.w	(a1)+,d1
.l1BBF4	dbra	d0,.sumloop
	move.w	d1,d0
	bsr.w	randomd0		;random 0 to total-1
.findloop	sub.w	-(a1),d0		;minus the weight
	bpl.w	.findloop
	suba.l	#$18BE8,a1
	move.w	a1,d0
	lsr.w	#$1,d0		;word offset -> index
	movem.l	(sp)+,d1/a1
	rts
	dc.w	$2F0E,$2C79,$0001,$9360,$0839,$0005,$00FF,$800F
	dc.w	$6706,$3D3C,$0001,$6004,$3D3C,$0000,$08B9,$0005
	dc.w	$00FF,$800F,$23CE,$0001,$9360,$2C5F,$3F39,$0001
	dc.w	$8D64,$08F9,$0002,$0001,$8D64,$48E7,$F8E0,$C141
	dc.w	$2448,$6100,$1AC6,$0441,$0001,$7003,$341A,$4243
	dc.w	$3802,$0244,$000F,$E24C,$1831,$4000,$0802,$0000
	dc.w	$6600,$0004,$E84C,$0244,$000F,$8604,$E85B,$E85A
	dc.w	$51C8,$FFDE,$0839,$0007,$00FF,$800E,$66F6,$33C3
	dc.w	$00FF,$8022,$33FC,$000D,$00FF,$8020,$08F9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$67F6,$08F9
	dc.w	$0007,$00FF,$800F,$08B9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$66F6,$08B9,$0007,$00FF,$800F
	dc.w	$51C9,$FF88,$4CDF,$071F,$33DF,$0001,$8D64,$2F0E
	dc.w	$2C79,$0001,$9360,$4A5E,$670A,$08F9,$0005,$00FF
	dc.w	$800F,$6008,$08B9,$0005,$00FF,$800F,$23CE,$0001
	dc.w	$9360,$2C5F,$4E75,$48E7,$8080,$207C,$000B,$BCB0
	dc.w	$701F,$2F10,$4298,$51C8,$FFFA,$33FC,$0018,$0001
	dc.w	$8D62,$6100,$003E,$701F,$211F,$51C8,$FFFC,$4CDF
	dc.w	$0101,$4E75,$48E7,$8080,$207C,$000B,$BCB0,$701F
	dc.w	$2F10,$4298,$51C8,$FFFA,$33FC,$0064,$0001,$8D62
	dc.w	$6100,$0010,$701F,$211F,$51C8,$FFFC,$4CDF,$0101
	dc.w	$4E75,$2F39,$0001,$8D66,$3F39,$0001,$8D64,$08B9
	dc.w	$0002,$0001,$8D64,$23FC,$0003,$DB90,$0001,$8D66
	dc.w	$2F0E,$2C79,$0001,$9360,$0839,$0005,$00FF,$800F
	dc.w	$6706,$3D3C,$0001,$6004,$3D3C,$0000,$08B9,$0005
	dc.w	$00FF,$800F,$23CE,$0001,$9360,$2C5F,$08F9,$0005
	dc.w	$00FF,$800F,$4A79,$0001,$8D62,$6A00,$FFF8,$2F0E
	dc.w	$2C79,$0001,$9360,$4A5E,$670A,$08F9,$0005,$00FF
	dc.w	$800F,$6008,$08B9,$0005,$00FF,$800F,$23CE,$0001
	dc.w	$9360,$2C5F,$33DF,$0001,$8D64,$23DF,$0001,$8D66
	dc.w	$4E75,$4A79,$0001,$8D62,$6B00,$5202,$0C79,$0064
	dc.w	$0001,$8D62,$6700,$0096,$5379,$0001,$8D62,$6B00
	dc.w	$51EC,$4280,$3039,$0001,$8D62,$0C40,$0018,$6E00
	dc.w	$51DC,$80FC,$0003,$4840,$E540,$7602,$E163,$7A0E
	dc.w	$E165,$3805,$4644,$23C3,$000B,$BC88,$23C4,$000B
	dc.w	$BC8C,$23C5,$000B,$BC90,$4EB9,$0002,$22C2,$0839
	dc.w	$0004,$00FF,$800E,$66F6,$33FC,$001D,$00FF,$8026
	dc.w	$08F9,$0003,$00FF,$800F,$0839,$0003,$00FF,$800E
	dc.w	$67F6,$08F9,$0004,$00FF,$800F,$08B9,$0003,$00FF
	dc.w	$800F,$0839,$0003,$00FF,$800E,$66F6,$08B9,$0004
	dc.w	$00FF,$800F,$4EB9,$0002,$2268,$4E75,$48E7,$80C0
	dc.w	$3F39,$0001,$8D64,$08F9,$0002,$0001,$8D64,$227C
	dc.w	$000B,$BCB0,$207C,$00C0,$0000,$0839,$0004,$00FF
	dc.w	$800E,$66F6,$33FC,$0030,$00FF,$8026,$23FC,$C000
	dc.w	$0000,$00FF,$8028,$08F9,$0003,$00FF,$800F,$0839
	dc.w	$0003,$00FF,$800E,$67F6,$08F9,$0004,$00FF,$800F
	dc.w	$08B9,$0003,$00FF,$800F,$0839,$0003,$00FF,$800E
	dc.w	$66F6,$08B9,$0004,$00FF,$800F,$701F,$0839,$0004
	dc.w	$00FF,$800E,$66F6,$33FC,$0033,$00FF,$8026,$23D9
	dc.w	$00FF,$8028,$08F9,$0003,$00FF,$800F,$0839,$0003
	dc.w	$00FF,$800E,$67F6,$08F9,$0004,$00FF,$800F,$08B9
	dc.w	$0003,$00FF,$800F,$0839,$0003,$00FF,$800E,$66F6
	dc.w	$08B9,$0004,$00FF,$800F,$51C8,$FFB2,$50F9,$0001
	dc.w	$8D62,$33DF,$0001,$8D64,$4CDF,$0301,$4E75,$48E7
	dc.w	$80C0,$3F39,$0001,$8D64,$08F9,$0002,$0001,$8D64
	dc.w	$227C,$000B,$BCB0,$207C,$00C0,$0000,$0839,$0007
	dc.w	$00FF,$800E,$66F6,$23FC,$C000,$0000,$00FF,$8022
	dc.w	$33FC,$000B,$00FF,$8020,$08F9,$0006,$00FF,$800F
	dc.w	$0839,$0006,$00FF,$800E,$67F6,$08F9,$0007,$00FF
	dc.w	$800F,$08B9,$0006,$00FF,$800F,$0839,$0006,$00FF
	dc.w	$800E,$66F6,$08B9,$0007,$00FF,$800F,$701F,$0839
	dc.w	$0007,$00FF,$800E,$66F6,$23D9,$00FF,$8022,$33FC
	dc.w	$000E,$00FF,$8020,$08F9,$0006,$00FF,$800F,$0839
	dc.w	$0006,$00FF,$800E,$67F6,$08F9,$0007,$00FF,$800F
	dc.w	$08B9,$0006,$00FF,$800F,$0839,$0006,$00FF,$800E
	dc.w	$66F6,$08B9,$0007,$00FF,$800F,$51C8,$FFB2,$50F9
	dc.w	$0001,$8D62,$33DF,$0001,$8D64,$4CDF,$0301,$4E75
	dc.w	$3F00,$E340,$6100,$0006,$905F,$4E75
randomd0						;d0 = range. Return random number in d0 (0 <= d0 < range)
	movem.l	d0-d2,-(sp)		;2(sp) = range (the saved d0 low word)
	move.w	$18C1A.l,d0		;seed+2 (92)
	move.w	d0,d1		;seed low
	move.w	$18C18.l,d2
	mulu.w	#$E62D,d0
	mulu.w	#$BB40,d1
	mulu.w	#$E62D,d2
	add.w	d2,d1		;add the cross term
	swap	d0		;to the high word
	add.w	d1,d0
	swap	d0
	addq.l	#$1,d0
	move.l	d0,$18C18.l
	asr.l	#$8,d0
	mulu.w	$2(sp),d0		;times the range
	swap	d0		;d0 = result 0 <= d0 < range
	addq.w	#$4,sp		;skip the saved d0 so the result survives
	movem.l	(sp)+,d1-d2
	rts
Sroot						;Square Root, this returns (d0.L)^.5 in d0. Large values use a binary
									;search
	tst.l	d0		;zero?
	beq.w	X_21000
	cmpi.l	#$640,d0
	bhi.w	.m2		;large value: Newton iteration / binary search below
	move.l	d1,-(sp)		;find square root of d0
	moveq	#-1,d1
.0	addq.w	#$2,d1		;next odd number
	sub.w	d1,d0		;minus the odd number
	bcc.w	.0
	lsr.w	#$1,d1		;d1 = 2*root+1 -> root
	move.w	d1,d0
	move.l	(sp)+,d1
	rts
.m2	movem.l	d1-d4,-(sp)
	moveq	#$9,d3		;max number of reps
	move.w	#$8000,d1		;binary search start
	cmpi.l	#$F00000,d0		;over $F00000?
	bhi.w	.big		;too big for divu: binary search
	move.l	d0,d1
	lsr.l	#$8,d1		;first guess = d0/256 + 2
	addi.w	#$2,d1
.top	move.w	d1,d2		;Newton step: d1 = (d0/guess + guess)/2
	move.l	d0,d1
	divu.w	d2,d1
	add.w	d2,d1
	lsr.w	#$1,d1
	cmp.w	d1,d2		;stop when the guess stops changing, or after 10 steps
	dbeq	d3,.top		;loop
.done	move.w	d1,d0		;d0 = root (shared exit of both methods)
	movem.l	(sp)+,d1-d4
	rts
.big	moveq	#$0,d1
	moveq	#-1,d2
.bs	move.w	d1,d3		;d3 = (low+high)/2, carry shifted back in
	add.w	d2,d3
	roxr.w	#$1,d3
	cmp.w	d3,d1		;same as low?
	beq.w	.done		;no step left: d1 is the root
	move.w	d3,d4
	mulu.w	d3,d3
	cmp.l	d3,d0
	bcc.w	.lo		;d0 >= mid^2: raise low
	move.w	d4,d2
	bra.w	.bs
.lo	move.w	d4,d1
	bra.w	.bs
