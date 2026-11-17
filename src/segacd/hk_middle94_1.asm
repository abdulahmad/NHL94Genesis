	include	segacd\hockey.inc
	include	macros\genesis.mac

move	equ	$2C9C8
swap	equ	$2779A
X_21000	equ	$21000

	org	$1BBE2

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
