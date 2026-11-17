	opt	oaq+
	opt	osq+
; HOCKEY.BIN updatesound, $238CE-$2391B.
; The cartridge updatesound (video94.asm): move the crowd noise volume (asv) toward
; Crowdlevel. The PSG writes are gone: this builds the old attenuation byte and
; returns it in d0.




updatesound							;move the crowd noise volume (asv) toward Crowdlevel
	move.w	(Crowdlevel).l,d0
	asl.w	#3,d0
	addi.w	#$400,d0
	cmpi.w	#$EFF,d0
	bls.w	.ip
	move.w	#$EFF,d0
.ip									;level clamped
	moveq	#$28,d2					;max step 40 (d0 = target level, asv = current)
	sub.w	(asv).l,d0
	cmp.w	d2,d0
	bgt.w	.iasv
	neg.w	d2
	cmp.w	d2,d0
	bge.w	.non					;within 40: no change
.iasv								;step toward the target
	add.w	d2,(asv).l				;step asv toward the target
	bpl.w	.non
	clr.w	(asv).l
.non								;crowd level set; the three PSG writes of the cartridge are gone
	move.b	(asv).l,d0
	eori.b	#$F,d0
	ori.b	#$F0,d0					;noise channel attenuation, returned instead of written
	rts

	opt	oaq-
	opt	osq-
