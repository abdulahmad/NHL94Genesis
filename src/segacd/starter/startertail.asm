;	STARTER.BIN $1AF0E-$1D5B7 (runtime $25F0E-$285B7).
;
;	After startergfx.asm to the end of the file: the credits text (read from the disc file: it names real
;	people), then code and data, decoded as found. SubMain (a name given here) is where the boot's jmp $262A8
;	lands: stack at $C41C, the gate array command words cleared, then the start-up.
;
;	The code ends with jmp $B00E, back to the boot, which loads HOCKEY.BIN at $1B000 over this part of the
;	file.


StarterDriverEntry	equ	$C4B6
X_281CF	equ	$281CF

	org	$25F0E

	dc.w	$0014,$4465
	incbin	..\cdbin\STARTER.BIN,$1AF12,16	;text, read from the disc file
	dc.w	$0010,$4D69
	incbin	..\cdbin\STARTER.BIN,$1AF26,11	;text, read from the disc file
	dc.b	$00
	dc.w	$0004,$FF00
	ori.b	#$4,d2
	dc.w	$FF00
	dc.w	$0018,$4F72
	incbin	..\cdbin\STARTER.BIN,$1AF40,19	;text, read from the disc file
	dc.b	$00
	dc.w	$000E
	incbin	..\cdbin\STARTER.BIN,$1AF56,11	;text, read from the disc file
	dc.b	$00
	dc.w	$0004,$FF00
	dc.w	$0016,$5345
	incbin	..\cdbin\STARTER.BIN,$1AF6A,18	;text, read from the disc file
	dc.w	$0010,$5061
	incbin	..\cdbin\STARTER.BIN,$1AF80,11	;text, read from the disc file
	dc.b	$00
	dc.w	$000C
	incbin	..\cdbin\STARTER.BIN,$1AF8E,9	;text, read from the disc file
	dc.b	$00
	dc.w	$000C
	incbin	..\cdbin\STARTER.BIN,$1AF9A,10	;text, read from the disc file
	dc.w	$0004,$FF00
	dc.w	$000E
	incbin	..\cdbin\STARTER.BIN,$1AFAA,12	;text, read from the disc file
	dc.w	$000E
	incbin	..\cdbin\STARTER.BIN,$1AFB8,12	;text, read from the disc file
	dc.w	$000C
	incbin	..\cdbin\STARTER.BIN,$1AFC6,9	;text, read from the disc file
	dc.b	$00
	dc.w	$0004,$FF00
	dc.w	$0016,$4D75
	incbin	..\cdbin\STARTER.BIN,$1AFD8,17	;text, read from the disc file
	dc.b	$00
	dc.w	$000E
	incbin	..\cdbin\STARTER.BIN,$1AFEC,11	;text, read from the disc file
	dc.b	$00
	dc.w	$000E
	incbin	..\cdbin\STARTER.BIN,$1AFFA,12	;text, read from the disc file
	dc.w	$0004,$FF00
	dc.w	$0012,$4F72
	incbin	..\cdbin\STARTER.BIN,$1B00E,13	;text, read from the disc file
	dc.b	$00
	dc.w	$0010,$4469
	incbin	..\cdbin\STARTER.BIN,$1B020,11	;text, read from the disc file
	dc.b	$00
	dc.w	$0004,$FF00
	dc.w	$000C
	incbin	..\cdbin\STARTER.BIN,$1B032,10	;text, read from the disc file
	dc.w	$000A
	incbin	..\cdbin\STARTER.BIN,$1B03E,8	;text, read from the disc file
	dc.w	$0004,$FF00
	dc.w	$0016,$4578
	incbin	..\cdbin\STARTER.BIN,$1B04E,17	;text, read from the disc file
	dc.b	$00
	dc.w	$000C
	incbin	..\cdbin\STARTER.BIN,$1B062,9	;text, read from the disc file
	dc.b	$00
	dc.w	$0004,$FF00
	dc.w	$000E
	incbin	..\cdbin\STARTER.BIN,$1B072,12	;text, read from the disc file
	dc.w	$0010,$4D69
	incbin	..\cdbin\STARTER.BIN,$1B082,11	;text, read from the disc file
	dc.b	$00
	dc.w	$0004,$FF00
	dc.w	$0016,$4173
	incbin	..\cdbin\STARTER.BIN,$1B096,17	;text, read from the disc file
	dc.b	$00
	dc.w	$000E
	incbin	..\cdbin\STARTER.BIN,$1B0AA,12	;text, read from the disc file
	dc.w	$0004,$FF00
	dc.w	$0016,$5465
	incbin	..\cdbin\STARTER.BIN,$1B0BE,18	;text, read from the disc file
	dc.w	$000E
	incbin	..\cdbin\STARTER.BIN,$1B0D2,12	;text, read from the disc file
	dc.w	$000C
	incbin	..\cdbin\STARTER.BIN,$1B0E0,10	;text, read from the disc file
	dc.w	$0004,$FF00
	dc.w	$0016,$4465
	incbin	..\cdbin\STARTER.BIN,$1B0F2,18	;text, read from the disc file
	dc.w	$0010,$4E61
	incbin	..\cdbin\STARTER.BIN,$1B108,11	;text, read from the disc file
	dc.b	$00
	dc.w	$0004,$FF00
	dc.w	$000A
	incbin	..\cdbin\STARTER.BIN,$1B11A,8	;text, read from the disc file
	dc.w	$000C
	incbin	..\cdbin\STARTER.BIN,$1B124,10	;text, read from the disc file
	dc.w	$000E
	incbin	..\cdbin\STARTER.BIN,$1B130,11	;text, read from the disc file
	dc.b	$00
	dc.w	$000E
	incbin	..\cdbin\STARTER.BIN,$1B13E,11	;text, read from the disc file
	dc.b	$00
	dc.w	$0004,$FF00
	dc.w	$001C,$506F
	incbin	..\cdbin\STARTER.BIN,$1B152,23	;text, read from the disc file
	dc.b	$00
	dc.w	$000E
	incbin	..\cdbin\STARTER.BIN,$1B16C,12	;text, read from the disc file
	dc.w	$0004,$FF00
	dc.w	$001E,$4E48
	incbin	..\cdbin\STARTER.BIN,$1B180,25	;text, read from the disc file
	dc.b	$00
	dc.w	$000C
	incbin	..\cdbin\STARTER.BIN,$1B19C,9	;text, read from the disc file
	dc.b	$00
	dc.w	$0010,$4A61
	incbin	..\cdbin\STARTER.BIN,$1B1AA,11	;text, read from the disc file
	dc.b	$00
	dc.w	$000C
	incbin	..\cdbin\STARTER.BIN,$1B1B8,10	;text, read from the disc file
	dc.w	$0004,$FF00
	dc.w	$0012,$506C
	incbin	..\cdbin\STARTER.BIN,$1B1CA,13	;text, read from the disc file
	dc.b	$00
	dc.w	$0010,$4967
	incbin	..\cdbin\STARTER.BIN,$1B1DC,11	;text, read from the disc file
	dc.b	$00
	dc.w	$0004,$FF00
	dc.w	$0016,$506C
	incbin	..\cdbin\STARTER.BIN,$1B1F0,17	;text, read from the disc file
	dc.b	$00
	dc.w	$0010,$5374
	incbin	..\cdbin\STARTER.BIN,$1B206,12	;text, read from the disc file
	dc.w	$0004,$FF00
	dc.w	$0012,$5370
	incbin	..\cdbin\STARTER.BIN,$1B21A,13	;text, read from the disc file
	dc.b	$00
	dc.w	$000E
	incbin	..\cdbin\STARTER.BIN,$1B22A,12	;text, read from the disc file
	dc.w	$000C
	incbin	..\cdbin\STARTER.BIN,$1B238,10	;text, read from the disc file
	dc.w	$000E
	incbin	..\cdbin\STARTER.BIN,$1B244,12	;text, read from the disc file
	dc.w	$0004,$FF00
	dc.w	$0012,$5370
	incbin	..\cdbin\STARTER.BIN,$1B258,13	;text, read from the disc file
	dc.b	$00
	dc.w	$000C
	incbin	..\cdbin\STARTER.BIN,$1B268,10	;text, read from the disc file
	dc.w	$000A
	incbin	..\cdbin\STARTER.BIN,$1B274,8	;text, read from the disc file
	dc.w	$0012,$5269
	incbin	..\cdbin\STARTER.BIN,$1B280,14	;text, read from the disc file
	dc.w	$000A
	incbin	..\cdbin\STARTER.BIN,$1B290,8	;text, read from the disc file
	dc.w	$0004,$FF00
	ori.b	#$2,d2
	dc.w	$0004,$FF00
	dc.w	$0004,$FF00
SubMain
	movea.l	#$C41C,sp
	move.w	#$0,$FF8020.l
	move.w	#$0,$FF8022.l
	move.w	#$0,$FF8024.l
	move.w	#$0,$FF8026.l
	move.w	#$0,$FF8028.l
	move.w	#$0,$FF802A.l
	move.w	#$0,$FF802C.l
	move.w	#$0,$FF802E.l
	move.b	#$0,$FF800F.l
	jsr	(.L2802E).l
	jsr	(.L280F2).l
	bclr.b	#$5,$FF800F.l
.L2630A
	btst.b	#$7,$FF800E.l
	bne.s	.L2630A
	move.w	#$8164,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2632C
	btst.b	#$6,$FF800E.l
	beq.s	.L2632C
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L26346
	btst.b	#$6,$FF800E.l
	bne.s	.L26346
	bclr.b	#$7,$FF800F.l
.L26358
	btst.b	#$7,$FF800E.l
	bne.s	.L26358
	move.w	#$8C00,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2637A
	btst.b	#$6,$FF800E.l
	beq.s	.L2637A
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L26394
	btst.b	#$6,$FF800E.l
	bne.s	.L26394
	bclr.b	#$7,$FF800F.l
.L263A6
	btst.b	#$7,$FF800E.l
	bne.s	.L263A6
	move.w	#$8700,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L263C8
	btst.b	#$6,$FF800E.l
	beq.s	.L263C8
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L263E2
	btst.b	#$6,$FF800E.l
	bne.s	.L263E2
	bclr.b	#$7,$FF800F.l
.L263F4
	btst.b	#$7,$FF800E.l
	bne.s	.L263F4
	move.w	#$9001,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L26416
	btst.b	#$6,$FF800E.l
	beq.s	.L26416
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L26430
	btst.b	#$6,$FF800E.l
	bne.s	.L26430
	bclr.b	#$7,$FF800F.l
.L26442
	btst.b	#$7,$FF800E.l
	bne.s	.L26442
	move.w	#$8238,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L26464
	btst.b	#$6,$FF800E.l
	beq.s	.L26464
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2647E
	btst.b	#$6,$FF800E.l
	bne.s	.L2647E
	bclr.b	#$7,$FF800F.l
.L26490
	btst.b	#$7,$FF800E.l
	bne.s	.L26490
	move.w	#$8407,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L264B2
	btst.b	#$6,$FF800E.l
	beq.s	.L264B2
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L264CC
	btst.b	#$6,$FF800E.l
	bne.s	.L264CC
	bclr.b	#$7,$FF800F.l
.L264DE
	btst.b	#$7,$FF800E.l
	bne.s	.L264DE
	move.w	#$8578,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L26500
	btst.b	#$6,$FF800E.l
	beq.s	.L26500
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2651A
	btst.b	#$6,$FF800E.l
	bne.s	.L2651A
	bclr.b	#$7,$FF800F.l
.L2652C
	btst.b	#$7,$FF800E.l
	bne.s	.L2652C
	move.w	#$8D3D,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2654E
	btst.b	#$6,$FF800E.l
	beq.s	.L2654E
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L26568
	btst.b	#$6,$FF800E.l
	bne.s	.L26568
	bclr.b	#$7,$FF800F.l
.L2657A
	btst.b	#$7,$FF800E.l
	bne.s	.L2657A
	move.w	#$831C,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2659C
	btst.b	#$6,$FF800E.l
	beq.s	.L2659C
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L265B6
	btst.b	#$6,$FF800E.l
	bne.s	.L265B6
	bclr.b	#$7,$FF800F.l
.L265C8
	btst.b	#$7,$FF800E.l
	bne.s	.L265C8
	move.w	#$9100,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L265EA
	btst.b	#$6,$FF800E.l
	beq.s	.L265EA
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L26604
	btst.b	#$6,$FF800E.l
	bne.s	.L26604
	bclr.b	#$7,$FF800F.l
.L26616
	btst.b	#$7,$FF800E.l
	bne.s	.L26616
	move.w	#$9200,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L26638
	btst.b	#$6,$FF800E.l
	beq.s	.L26638
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L26652
	btst.b	#$6,$FF800E.l
	bne.s	.L26652
	bclr.b	#$7,$FF800F.l
.L26664
	btst.b	#$7,$FF800E.l
	bne.s	.L26664
	move.w	#$8F02,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L26686
	btst.b	#$6,$FF800E.l
	beq.s	.L26686
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L266A0
	btst.b	#$6,$FF800E.l
	bne.s	.L266A0
	bclr.b	#$7,$FF800F.l
.L266B2
	btst.b	#$7,$FF800E.l
	bne.s	.L266B2
	move.w	#$8B00,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L266D4
	btst.b	#$6,$FF800E.l
	beq.s	.L266D4
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L266EE
	btst.b	#$6,$FF800E.l
	bne.s	.L266EE
	bclr.b	#$7,$FF800F.l
.L26700
	btst.b	#$7,$FF800E.l
	bne.s	.L26700
	move.l	#$74000003,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L26724
	btst.b	#$6,$FF800E.l
	beq.s	.L26724
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2673E
	btst.b	#$6,$FF800E.l
	bne.s	.L2673E
	bclr.b	#$7,$FF800F.l
.L26750
	btst.b	#$7,$FF800E.l
	bne.s	.L26750
	move.w	#$0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L26772
	btst.b	#$6,$FF800E.l
	beq.s	.L26772
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2678C
	btst.b	#$6,$FF800E.l
	bne.s	.L2678C
	bclr.b	#$7,$FF800F.l
.L2679E
	btst.b	#$7,$FF800E.l
	bne.s	.L2679E
	move.w	#$0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L267C0
	btst.b	#$6,$FF800E.l
	beq.s	.L267C0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L267DA
	btst.b	#$6,$FF800E.l
	bne.s	.L267DA
	bclr.b	#$7,$FF800F.l
.L267EC
	btst.b	#$7,$FF800E.l
	bne.s	.L267EC
	move.l	#$40000010,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L26810
	btst.b	#$6,$FF800E.l
	beq.s	.L26810
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2682A
	btst.b	#$6,$FF800E.l
	bne.s	.L2682A
	bclr.b	#$7,$FF800F.l
.L2683C
	btst.b	#$7,$FF800E.l
	bne.s	.L2683C
	move.w	#$0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2685E
	btst.b	#$6,$FF800E.l
	beq.s	.L2685E
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L26878
	btst.b	#$6,$FF800E.l
	bne.s	.L26878
	bclr.b	#$7,$FF800F.l
.L2688A
	btst.b	#$7,$FF800E.l
	bne.s	.L2688A
	move.w	#$0,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L268AC
	btst.b	#$6,$FF800E.l
	beq.s	.L268AC
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L268C6
	btst.b	#$6,$FF800E.l
	bne.s	.L268C6
	bclr.b	#$7,$FF800F.l
.L268D8
	btst.b	#$7,$FF800E.l
	bne.s	.L268D8
	move.l	#$70000003,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L268FC
	btst.b	#$6,$FF800E.l
	beq.s	.L268FC
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L26916
	btst.b	#$6,$FF800E.l
	bne.s	.L26916
	bclr.b	#$7,$FF800F.l
.L26928
	btst.b	#$7,$FF800E.l
	bne.s	.L26928
	move.l	#$0,$FF8022.l
	move.w	#$E,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2694C
	btst.b	#$6,$FF800E.l
	beq.s	.L2694C
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L26966
	btst.b	#$6,$FF800E.l
	bne.s	.L26966
	bclr.b	#$7,$FF800F.l
.L26978
	btst.b	#$7,$FF800E.l
	bne.s	.L26978
	move.w	#$20,$FF8020.l
	bset.b	#$6,$FF800F.l
.L26992
	btst.b	#$6,$FF800E.l
	beq.s	.L26992
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L269AC
	btst.b	#$6,$FF800E.l
	bne.s	.L269AC
	bclr.b	#$7,$FF800F.l
	move.l	#$2,d7
	movea.l	#$29000,a0
	jsr	$6044.w
	bclr.b	#$5,$FF800F.l
	move.l	#$2746A,$C432.l
	jsr	(.L27A12).l
	bset.b	#$5,$FF800F.l
	movea.l	#$BBCB0,a0
	moveq	#$1F,d0
.L269F6
	clr.l	(a0)+
	dbf	d0,.L269F6
	move.w	#$18,$C43E.l
.L26A04
	tst.w	$C43E.l
	bpl.w	.L26A04
.L26A0E
	btst.b	#$7,$FF800E.l
	bne.s	.L26A0E
	move.w	#$8C81,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L26A30
	btst.b	#$6,$FF800E.l
	beq.s	.L26A30
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L26A4A
	btst.b	#$6,$FF800E.l
	bne.s	.L26A4A
	bclr.b	#$7,$FF800F.l
.L26A5C
	btst.b	#$7,$FF800E.l
	bne.s	.L26A5C
	move.w	#$8230,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L26A7E
	btst.b	#$6,$FF800E.l
	beq.s	.L26A7E
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L26A98
	btst.b	#$6,$FF800E.l
	bne.s	.L26A98
	bclr.b	#$7,$FF800F.l
.L26AAA
	btst.b	#$7,$FF800E.l
	bne.s	.L26AAA
	move.w	#$8407,$FF8022.l
	move.w	#$A,$FF8020.l
	bset.b	#$6,$FF800F.l
.L26ACC
	btst.b	#$6,$FF800E.l
	beq.s	.L26ACC
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L26AE6
	btst.b	#$6,$FF800E.l
	bne.s	.L26AE6
	bclr.b	#$7,$FF800F.l
.L26AF8
	btst.b	#$7,$FF800E.l
	bne.s	.L26AF8
	move.w	#$20,$FF8020.l
	bset.b	#$6,$FF800F.l
.L26B12
	btst.b	#$6,$FF800E.l
	beq.s	.L26B12
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L26B2C
	btst.b	#$6,$FF800E.l
	bne.s	.L26B2C
	bclr.b	#$7,$FF800F.l
	jsr	(.L26DC6).l
	tst.w	$C450.l
	beq.w	.L26BB4
	movea.l	#$BBCB0,a0
	moveq	#$1F,d0
.L26B56
	clr.l	(a0)+
	dbf	d0,.L26B56
	move.w	#$18,$C43E.l
.L26B64
	tst.w	$C43E.l
	bpl.w	.L26B64
.L26B6E
	btst.b	#$7,$FF800E.l
	bne.s	.L26B6E
	move.w	#$20,$FF8020.l
	bset.b	#$6,$FF800F.l
.L26B88
	btst.b	#$6,$FF800E.l
	beq.s	.L26B88
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L26BA2
	btst.b	#$6,$FF800E.l
	bne.s	.L26BA2
	bclr.b	#$7,$FF800F.l
.L26BB4
	bclr.b	#$5,$FF800F.l
	jsr	(.L27A6A).l
	move.l	#$2,d7
	movea.l	#$1B000,a0
	jsr	$6044.w
	move.l	#$400,d1
	move.w	#$85,d0
	jsr	$5F22.w
	move.w	#$8400,d1
	move.w	#$85,d0
	jsr	$5F22.w
.L26BEC
	btst.b	#$7,$FF800E.l
	bne.s	.L26BEC
	move.w	#$3E,$FF8020.l
	bset.b	#$6,$FF800F.l
.L26C06
	btst.b	#$6,$FF800E.l
	beq.s	.L26C06
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L26C20
	btst.b	#$6,$FF800E.l
	bne.s	.L26C20
	bclr.b	#$7,$FF800F.l
	move.w	#$2500,sr
	bset.b	#$2,$FF8033.l
	move.w	#$4,d0
	move.l	#$ADA,d1
	move.l	#$6038,d2
	move.l	#$29000,d3
	move.l	#$80000,d4
	sub.l	d3,d4
	bset.b	#$5,$FF800F.l
	jsr	(StarterDriverEntry).l
	movea.l	#$C41C,sp
	jsr	(.L2802E).l
.L26C76
	bclr.b	#$2,$FF8003.l
	bne.s	.L26C76
	jsr	(.L2800E).l
	move.w	#$2000,sr
	bset.b	#$2,$FF8033.l
	movea.l	#$80000,a0
	move.w	#$2,d7
	jsr	$6044.w
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$5,d0
	jsr	$6044.w
	movea.l	a0,a0
	movem.l	(sp)+,d0-d2/d7/a0-a1
	move.l	$B090.l,$6038.w
.L26CBE
	btst.b	#$7,$FF800E.l
	bne.s	.L26CBE
	move.w	#$2E,$FF8020.l
	bset.b	#$6,$FF800F.l
.L26CD8
	btst.b	#$6,$FF800E.l
	beq.s	.L26CD8
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L26CF2
	btst.b	#$6,$FF800E.l
	bne.s	.L26CF2
	bclr.b	#$7,$FF800F.l
	bset.b	#$5,$FF800F.l
	bset.b	#$2,$FF8033.l
	bsr.w	.L2801A
.L26D18
	btst.b	#$7,$FF800E.l
	bne.s	.L26D18
	move.w	#$3F,$FF8020.l
	bset.b	#$6,$FF800F.l
.L26D32
	btst.b	#$6,$FF800E.l
	beq.s	.L26D32
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L26D4C
	btst.b	#$6,$FF800E.l
	bne.s	.L26D4C
	bclr.b	#$7,$FF800F.l
	bsr.w	.L2800E
	move.l	$B090.l,$6038.w
.L26D6A
	btst.b	#$7,$FF800E.l
	bne.s	.L26D6A
	move.w	#$2E,$FF8020.l
	bset.b	#$6,$FF800F.l
.L26D84
	btst.b	#$6,$FF800E.l
	beq.s	.L26D84
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L26D9E
	btst.b	#$6,$FF800E.l
	bne.s	.L26D9E
	bclr.b	#$7,$FF800F.l
	bset.b	#$5,$FF800F.l
	bset.b	#$2,$FF8033.l
	jmp	$B00E.l
.L26DC6
	move.w	#$0,d0
	move.w	#$B,d7
	jsr	$6044.w
	jsr	(.L26EAA).l
	move.w	#$0,d0
	lea	$7D000.l,a0
	lea	$7C000.l,a1
	jsr	$5F16.w
	bcc.w	.L26E0A
	jsr	(.L26EBE).l
	cmpi.w	#$FFFF,$C442.l
	beq.w	.L26E6A
	move.w	#$6,d0
	jsr	$5F16.w
.L26E0A
	move.w	#$3,d0
	lea	(.L26E78).l,a0
	lea	$7F000.l,a1
	jsr	$5F16.w
	bcs.w	.L26E38
	jsr	(.L26E96).l
	cmp.l	$7FF20.l,d0
	beq.w	.L26E76
	jsr	(.L26EAA).l
.L26E38
	move.w	#$5,d0
	lea	(.L26E78).l,a0
	jsr	$5F16.w
	move.w	#$1,d0
	lea	$C452.l,a1
	jsr	$5F16.w
	cmpi.w	#$3D,d0
	bge.w	.L26E76
	move.w	#$1,$C44C.l
	jsr	(.L26EBE).l
.L26E6A
	move.w	#$FFFF,d0
	move.w	#$B,d7
	jsr	$6044.w
.L26E76
	rts
.L26E78
	incbin	..\cdbin\STARTER.BIN,$1BE78,11	;text, read from the disc file
	dc.b	$00
	ori.b	#$0,d0
	incbin	..\cdbin\STARTER.BIN,$1BE88,11	;text, read from the disc file
	dc.b	$00
	dc.w	$003D
.L26E96
	lea	$7F000.l,a0
	moveq	#$0,d0
	move.w	#$F1F,d1
.L26EA2
	add.b	(a0)+,d0
	dbf	d1,.L26EA2
	rts
.L26EAA
	lea	$7F000.l,a0
	move.w	#$F1F,d0
	clr.l	d1
.L26EB6
	move.b	d1,(a0)+
	dbf	d0,.L26EB6
	rts
.L26EBE
	movem.l	d0-d7/a0-a2,-(sp)
	move.w	#$1,$C450.l
	tst.w	$C44E.l
	bne.w	.L272A2
	bset.b	#$5,$FF800F.l
	movea.l	#$BBCB0,a1
	moveq	#$1F,d0
.L26EE4
	clr.l	(a1)+
	dbf	d0,.L26EE4
	move.w	#$64,$C43E.l
.L26EF2
	tst.w	$C43E.l
	bpl.w	.L26EF2
	move.l	#$2,d7
	movea.l	#$80000,a0
	jsr	$6044.w
	move.w	#$20,$C448.l
	lea	(.L282B4).l,a1
	move.w	$2(a1),d0
	lsl.w	#$4,d0
	move.w	d0,d2
	move.w	$C448.l,d1
	lea	$4(a1),a0
	jsr	(.L2790E).l
	add.w	d2,d2
	add.w	d2,$C448.l
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$61,d0
	jsr	$6044.w
	move.l	a0,$C436.l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	$C436.l,a1
	move.w	$2(a1),d0
	lsl.w	#$4,d0
	move.w	d0,d2
	move.w	$C448.l,d1
	move.w	d1,d5
	lsr.w	#$5,d5
	lea	$4(a1),a0
	jsr	(.L2790E).l
	add.w	d2,d2
	add.w	d2,$C448.l
	lea	$4(a1,d2.w),a0
	movea.l	#$BBCB0,a1
	moveq	#$1F,d0
.L26F8A
	move.l	(a0)+,(a1)+
	dbf	d0,.L26F8A
	move.l	#$EEE,$BBCD2.l
	move.l	#$4440666,$BBCF2.l
	move.w	#$E000,d0
	bsr.w	.L273AA
	move.w	(a0)+,d1
	move.w	(a0)+,d2
	incbin	..\cdbin\STARTER.BIN,$1BFB0,7	;text, read from the disc file
	dc.b	$01
	move.w	#$80,d7
	moveq	#$0,d4
	move.w	#$E000,d4
.L26FC2
	move.l	d4,d0
	movea.l	#$C00000,a0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	ori.w	#$4000,d0
	swap	d0
	andi.w	#$3,d0
.L26FD8
	btst.b	#$7,$FF800E.l
	bne.s	.L26FD8
	move.l	d0,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L26FF8
	btst.b	#$6,$FF800E.l
	beq.s	.L26FF8
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L27012
	btst.b	#$6,$FF800E.l
	bne.s	.L27012
	bclr.b	#$7,$FF800F.l
.L27024
	move.w	(a2)+,d6
	add.w	d5,d6
.L27028
	btst.b	#$7,$FF800E.l
	bne.s	.L27028
	move.w	d6,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L27048
	btst.b	#$6,$FF800E.l
	beq.s	.L27048
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L27062
	btst.b	#$6,$FF800E.l
	bne.s	.L27062
	bclr.b	#$7,$FF800F.l
	dbf	d1,.L27024
	move.w	d3,d1
	add.w	d7,d4
	dbf	d2,.L26FC2
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$40,d0
	jsr	$6044.w
	move.l	a0,$C43A.l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	movea.l	$C43A.l,a1
	move.w	$2(a1),d0
	lsl.w	#$3,d0
	move.l	#$11111111,d1
	lea	$4(a1),a1
.L270B0
	add.l	d1,(a1)+
	dbf	d0,.L270B0
	movea.l	$C43A.l,a1
	move.w	$2(a1),d0
	lsl.w	#$4,d0
	move.w	d0,d2
	move.w	$C448.l,d1
	move.w	d1,$C44A.l
	lea	$4(a1),a0
	jsr	(.L2790E).l
	move.w	#$C000,d0
	bsr.w	.L273AA
	tst.w	$C44C.l
	bne.w	.L27280
	moveq	#$0,d4
	move.w	#$C31A,d4
	move.w	#$20,d5
	lsr.w	#$5,d5
	bset	#$E,d5
	moveq	#$4,d1
	move.w	d1,d3
	moveq	#$2,d2
	move.w	#$80,d7
.L27106
	move.l	d4,d0
	movea.l	#$C00000,a0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	ori.w	#$4000,d0
	swap	d0
	andi.w	#$3,d0
.L2711C
	btst.b	#$7,$FF800E.l
	bne.s	.L2711C
	move.l	d0,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2713C
	btst.b	#$6,$FF800E.l
	beq.s	.L2713C
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L27156
	btst.b	#$6,$FF800E.l
	bne.s	.L27156
	bclr.b	#$7,$FF800F.l
.L27168
	btst.b	#$7,$FF800E.l
	bne.s	.L27168
	move.w	d5,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L27188
	btst.b	#$6,$FF800E.l
	beq.s	.L27188
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L271A2
	btst.b	#$6,$FF800E.l
	bne.s	.L271A2
	bclr.b	#$7,$FF800F.l
	addi.w	#$1,d5
	dbf	d1,.L27168
	move.w	d3,d1
	add.w	d7,d4
	dbf	d2,.L27106
.L271C4
	btst.b	#$7,$FF800E.l
	bne.s	.L271C4
	move.l	#$74000003,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L271E8
	btst.b	#$6,$FF800E.l
	beq.s	.L271E8
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L27202
	btst.b	#$6,$FF800E.l
	bne.s	.L27202
	bclr.b	#$7,$FF800F.l
.L27214
	btst.b	#$7,$FF800E.l
	bne.s	.L27214
	move.w	#$3B,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L27236
	btst.b	#$6,$FF800E.l
	beq.s	.L27236
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L27250
	btst.b	#$6,$FF800E.l
	bne.s	.L27250
	bclr.b	#$7,$FF800F.l
	move.w	#$3B,$C444.l
	lea	.L280FE(pc),a0
	move.w	#$5B,d0
	moveq	#$9,d1
.L27274
	bsr.w	.L277F8
	addi.w	#$28,d0
	dbf	d1,.L27274
.L27280
	bset.b	#$5,$FF800F.l
	move.w	#$18,$C43E.l
.L27290
	tst.w	$C43E.l
	bpl.w	.L27290
	move.w	#$1,$C44E.l
.L272A2
	tst.w	$C44C.l
	bne.w	.L27368
.L272AC
	clr.w	$C446.l
.L272B2
	tst.w	$C446.l
	beq.w	.L272B2
	bsr.w	.L27F5A
	cmpi.b	#$4,d1
	beq.w	.L272DC
	cmpi.b	#$8,d1
	beq.w	.L272F8
	cmpi.b	#$20,d1
	beq.w	.L27320
	bra.w	.L272AC
.L272DC
	tst.w	$C442.l
	bpl.w	.L272AC
	clr.w	$C442.l
	move.w	#$FFFE,$C440.l
	bra.w	.L27312
.L272F8
	tst.w	$C442.l
	bmi.w	.L272AC
	move.w	#$FFFF,$C442.l
	move.w	#$2,$C440.l
.L27312
	tst.w	$C440.l
	bne.w	.L27312
	bra.w	.L272AC
.L27320
	cmpi.w	#$FFFF,$C442.l
	beq.w	.L27364
	lea	.L281BC(pc),a0
	move.w	#$213,d0
	bsr.w	.L277F8
	moveq	#$3,d1
	moveq	#$F,d2
	move.w	d2,d3
	addi.w	#$A,d0
.L27342
	clr.w	$C446.l
.L27348
	tst.w	$C446.l
	beq.w	.L27348
	dbf	d2,.L27342
	move.w	d3,d2
	bsr.w	.L277F8
	addi.w	#$1,d0
	dbf	d1,.L27342
.L27364
	bra.w	.L273A4
.L27368
	move.w	#$C000,d0
	bsr.w	.L273AA
	move.w	#$B,d1
	move.w	#$5B,d0
	lea	X_281CF(pc),a0
.L2737C
	bsr.w	.L277F8
	addi.w	#$28,d0
	dbf	d1,.L2737C
.L27388
	clr.w	$C446.l
.L2738E
	tst.w	$C446.l
	beq.w	.L2738E
	bsr.w	.L27F5A
	cmpi.b	#$20,d1
	bne.w	.L27388
.L273A4
	movem.l	(sp)+,d0-d7/a0-a2
	rts
.L273AA
	movem.l	d0-d2,-(sp)
	move.w	#$0,d1
	lsr.w	#$5,d1
	moveq	#$0,d2
	move.w	d0,d2
	lsl.l	#$2,d2
	lsr.w	#$2,d2
	swap	d2
	addi.l	#$40000000,d2
.L273C4
	btst.b	#$7,$FF800E.l
	bne.s	.L273C4
	move.l	d2,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L273E4
	btst.b	#$6,$FF800E.l
	beq.s	.L273E4
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L273FE
	btst.b	#$6,$FF800E.l
	bne.s	.L273FE
	bclr.b	#$7,$FF800F.l
	move.w	#$7FF,d2
.L27414
	btst.b	#$7,$FF800E.l
	bne.s	.L27414
	move.w	d1,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L27434
	btst.b	#$6,$FF800E.l
	beq.s	.L27434
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2744E
	btst.b	#$6,$FF800E.l
	bne.s	.L2744E
	bclr.b	#$7,$FF800F.l
	dbf	d2,.L27414
	movem.l	(sp)+,d0-d2
	rts
	movem.l	d0-d7/a0,-(sp)
	tst.w	$C440.l
	beq.w	.L2769A
.L27478
	btst.b	#$4,$FF800E.l
	bne.s	.L27478
	move.w	#$30,$FF8026.l
	move.l	#$74000003,$FF8028.l
	bset.b	#$3,$FF800F.l
.L2749C
	btst.b	#$3,$FF800E.l
	beq.s	.L2749C
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L274B6
	btst.b	#$3,$FF800E.l
	bne.s	.L274B6
	bclr.b	#$4,$FF800F.l
.L274C8
	btst.b	#$4,$FF800E.l
	bne.s	.L274C8
	move.w	#$31,$FF8026.l
	move.w	$C444.l,$FF8028.l
	bset.b	#$3,$FF800F.l
.L274EC
	btst.b	#$3,$FF800E.l
	beq.s	.L274EC
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L27506
	btst.b	#$3,$FF800E.l
	bne.s	.L27506
	bclr.b	#$4,$FF800F.l
	move.w	$C440.l,d0
	add.w	d0,$C444.l
	tst.w	$C440.l
	bpl.w	.L275E2
	cmpi.w	#$0,$C444.l
	bgt.w	.L2769A
	clr.w	$C444.l
.L27540
	btst.b	#$4,$FF800E.l
	bne.s	.L27540
	move.w	#$30,$FF8026.l
	move.l	#$74000003,$FF8028.l
	bset.b	#$3,$FF800F.l
.L27564
	btst.b	#$3,$FF800E.l
	beq.s	.L27564
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L2757E
	btst.b	#$3,$FF800E.l
	bne.s	.L2757E
	bclr.b	#$4,$FF800F.l
.L27590
	btst.b	#$4,$FF800E.l
	bne.s	.L27590
	move.w	#$31,$FF8026.l
	move.w	#$0,$FF8028.l
	bset.b	#$3,$FF800F.l
.L275B2
	btst.b	#$3,$FF800E.l
	beq.s	.L275B2
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L275CC
	btst.b	#$3,$FF800E.l
	bne.s	.L275CC
	bclr.b	#$4,$FF800F.l
	bra.w	.L27694
.L275E2
	cmpi.w	#$3B,$C444.l
	blt.w	.L2769A
.L275EE
	btst.b	#$4,$FF800E.l
	bne.s	.L275EE
	move.w	#$30,$FF8026.l
	move.l	#$74000003,$FF8028.l
	bset.b	#$3,$FF800F.l
.L27612
	btst.b	#$3,$FF800E.l
	beq.s	.L27612
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L2762C
	btst.b	#$3,$FF800E.l
	bne.s	.L2762C
	bclr.b	#$4,$FF800F.l
.L2763E
	btst.b	#$4,$FF800E.l
	bne.s	.L2763E
	move.w	#$31,$FF8026.l
	move.w	#$3B,$FF8028.l
	bset.b	#$3,$FF800F.l
.L27660
	btst.b	#$3,$FF800E.l
	beq.s	.L27660
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L2767A
	btst.b	#$3,$FF800E.l
	bne.s	.L2767A
	bclr.b	#$4,$FF800F.l
	move.w	#$3B,$C444.l
.L27694
	clr.w	$C440.l
.L2769A
	tst.w	$C43E.l
	bmi.w	.L2773E
	cmpi.w	#$64,$C43E.l
	beq.w	.L27744
	subq.w	#$1,$C43E.l
	bmi.w	.L2773E
	clr.l	d0
	move.w	$C43E.l,d0
	cmpi.w	#$18,d0
	bgt.w	.L2773E
	divu.w	#$3,d0
	swap	d0
	asl.w	#$2,d0
	moveq	#$2,d3
	asl.w	d0,d3
	moveq	#$E,d5
	asl.w	d0,d5
	move.w	d5,d4
	not.w	d4
	move.l	d3,$BBC88.l
	move.l	d4,$BBC8C.l
	move.l	d5,$BBC90.l
	bsr.w	.L2801A
.L276F4
	btst.b	#$4,$FF800E.l
	bne.s	.L276F4
	move.w	#$1D,$FF8026.l
	bset.b	#$3,$FF800F.l
.L2770E
	btst.b	#$3,$FF800E.l
	beq.s	.L2770E
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L27728
	btst.b	#$3,$FF800E.l
	bne.s	.L27728
	bclr.b	#$4,$FF800F.l
	bsr.w	.L2800E
.L2773E
	movem.l	(sp)+,d0-d7/a0
	rts
.L27744
	movea.l	#$BBCB0,a1
.L2774A
	btst.b	#$4,$FF800E.l
	bne.s	.L2774A
	move.w	#$30,$FF8026.l
	move.l	#$C0000000,$FF8028.l
	bset.b	#$3,$FF800F.l
.L2776E
	btst.b	#$3,$FF800E.l
	beq.s	.L2776E
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L27788
	btst.b	#$3,$FF800E.l
	bne.s	.L27788
	bclr.b	#$4,$FF800F.l
	moveq	#$1F,d0
.L2779C
	btst.b	#$4,$FF800E.l
	bne.s	.L2779C
	move.w	#$33,$FF8026.l
	move.l	(a1)+,$FF8028.l
	bset.b	#$3,$FF800F.l
.L277BC
	btst.b	#$3,$FF800E.l
	beq.s	.L277BC
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L277D6
	btst.b	#$3,$FF800E.l
	bne.s	.L277D6
	bclr.b	#$4,$FF800F.l
	dbf	d0,.L2779C
	st.b	$C43E.l
	movem.l	(sp)+,d0-d7/a0
	rts
.L277F8
	movem.l	d0-d2/a1/a5,-(sp)
	andi.l	#$FFFF,d0
	divu.w	#$28,d0
	move.w	d0,d2
	lsl.w	#$6,d2
	swap	d0
	add.w	d2,d0
	add.w	d0,d0
	moveq	#$0,d2
	move.w	#$E000,d2
	add.w	d0,d2
	lsl.l	#$2,d2
	lsr.w	#$2,d2
	swap	d2
	addi.l	#$40000000,d2
.L27824
	btst.b	#$7,$FF800E.l
	bne.s	.L27824
	move.l	d2,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L27844
	btst.b	#$6,$FF800E.l
	beq.s	.L27844
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L2785E
	btst.b	#$6,$FF800E.l
	bne.s	.L2785E
	bclr.b	#$7,$FF800F.l
	bsr.w	.L2787A
	movem.l	(sp)+,d0-d2/a1/a5
	rts
.L2787A
	move.w	$C44A.l,d0
	lsr.w	#$5,d0
	bset	#$D,d0
.L27886
	moveq	#$0,d2
	move.b	(a0)+,d2
	beq.w	.L2790C
	cmpi.b	#$22,d2
	beq.w	.L278AA
	cmpi.b	#$5F,d2
	beq.w	.L278AA
	cmpi.b	#$24,d2
	beq.w	.L278B2
	bra.w	.L278B6
.L278AA
	move.b	#$20,d2
	bra.w	.L278B6
.L278B2
	move.b	#$22,d2
.L278B6
	subi.b	#$20,d2
	add.w	d0,d2
.L278BC
	btst.b	#$7,$FF800E.l
	bne.s	.L278BC
	move.w	d2,$FF8022.l
	move.w	#$D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L278DC
	btst.b	#$6,$FF800E.l
	beq.s	.L278DC
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L278F6
	btst.b	#$6,$FF800E.l
	bne.s	.L278F6
	bclr.b	#$7,$FF800F.l
	bra.w	.L27886
.L2790C
	rts
.L2790E
	movem.l	d2-d3/a1-a2,-(sp)
	cmpa.l	#$80000,a0
	bge.w	.L27932
	move.l	d0,d3
	lsr.w	#$1,d3
	lea	$BC000.l,a2
.L27926
	move.l	(a0)+,(a2)+
	dbf	d3,.L27926
	lea	$BC000.l,a0
.L27932
	lea	$C00004.l,a1
	move.l	(a0),$BBC96.l
	move.l	d1,$BBC9A.l
	adda.l	#$180002,a0
	move.w	#$8154,$BBC88.l
	move.w	#$8F02,$BBC8A.l
	move.w	#$9300,d2
	move.b	d0,d2
	move.w	d2,$BBC8C.l
	move.w	#$9400,d2
	lsr.w	#$8,d0
	move.b	d0,d2
	move.w	d2,$BBC8E.l
	move.l	a0,d0
	lsr.l	#$1,d0
	move.w	#$9500,d2
	move.b	d0,d2
	move.w	d2,$BBC90.l
	lsr.l	#$8,d0
	move.w	#$9600,d2
	move.b	d0,d2
	move.w	d2,$BBC92.l
	lsr.l	#$8,d0
	andi.b	#$7F,d0
	move.w	#$9700,d2
	move.b	d0,d2
	move.w	d2,$BBC94.l
	clr.l	d0
	move.w	d1,d0
	asl.l	#$2,d0
	lsr.w	#$2,d0
	move.l	d0,d3
	ori.l	#$804000,d0
	move.l	d0,$BBC9E.l
	jsr	(.L2801A).l
.L279C0
	btst.b	#$7,$FF800E.l
	bne.s	.L279C0
	move.w	#$8,$FF8020.l
	bset.b	#$6,$FF800F.l
.L279DA
	btst.b	#$6,$FF800E.l
	beq.s	.L279DA
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L279F4
	btst.b	#$6,$FF800E.l
	bne.s	.L279F4
	bclr.b	#$7,$FF800F.l
	jsr	(.L2800E).l
	movem.l	(sp)+,d2-d3/a1-a2
	rts
.L27A12
	move.l	$6038.w,$C42E.l
	move.l	#$27A74,$6038.w
.L27A22
	btst.b	#$7,$FF800E.l
	bne.s	.L27A22
	move.w	#$2D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L27A3C
	btst.b	#$6,$FF800E.l
	beq.s	.L27A3C
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L27A56
	btst.b	#$6,$FF800E.l
	bne.s	.L27A56
	bclr.b	#$7,$FF800F.l
	rts
.L27A6A
	move.l	$C42E.l,$6038.w
	rts
	btst.b	#$5,$FF800E.l
	beq.w	.L27AF2
	move.w	#$1,$C446.l
	bset.b	#$2,$FF800F.l
	move.l	#$27A9E,-(sp)
	move.l	$C432.l,-(sp)
	rts
	jsr	(.L27B38).l
.L27AA4
	btst.b	#$4,$FF800E.l
	bne.s	.L27AA4
	move.w	#$2F,$FF8026.l
	bset.b	#$3,$FF800F.l
.L27ABE
	btst.b	#$3,$FF800E.l
	beq.s	.L27ABE
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L27AD8
	btst.b	#$3,$FF800E.l
	bne.s	.L27AD8
	bclr.b	#$4,$FF800F.l
	bclr.b	#$2,$FF800F.l
.L27AF2
	rts
	move.l	a5,-(sp)
	move.w	sr,-(sp)
	move.w	#$2700,sr
	movem.l	d0-d7/a0-a4/a6,-(sp)
	btst.b	#$0,$FF800F.l
	beq.w	.L27B1E
	btst.b	#$1,$FF800E.l
	beq.s	.L27B1E
	move.w	#$A,d7
	jsr	$6044.w
.L27B1E
	movem.l	(sp)+,d0-d7/a0-a4/a6
	movea.l	#$FF8000,a5
	move.w	(sp)+,sr
	incbin	..\cdbin\STARTER.BIN,$1CB2A,14	;text, read from the disc file
.L27B38
	movem.l	d1/a0,-(sp)
	bsr.w	.L27CAA
	move.b	d0,$2800A.l
	bsr.w	.L27CA2
	move.b	d0,$2800B.l
	movem.l	(sp)+,d1/a0
	rts
.L27B56
	btst.b	#$4,$FF800E.l
	bne.s	.L27B56
	move.b	#$C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.L27B78
	btst.b	#$4,$FF800E.l
	beq.s	.L27B78
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L27B92
	btst.b	#$3,$FF800E.l
	bne.s	.L27B92
	bclr.b	#$4,$FF800F.l
	bra.w	.L27C9A
.L27BA8
	btst.b	#$4,$FF800E.l
	bne.s	.L27BA8
	move.b	#$1C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.L27BCA
	btst.b	#$4,$FF800E.l
	beq.s	.L27BCA
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L27BE4
	btst.b	#$3,$FF800E.l
	bne.s	.L27BE4
	bclr.b	#$4,$FF800F.l
	bra.w	.L27C9A
.L27BFA
	btst.b	#$4,$FF800E.l
	bne.s	.L27BFA
	move.b	#$2C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.L27C1C
	btst.b	#$4,$FF800E.l
	beq.s	.L27C1C
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L27C36
	btst.b	#$3,$FF800E.l
	bne.s	.L27C36
	bclr.b	#$4,$FF800F.l
	bra.w	.L27C9A
.L27C4C
	btst.b	#$4,$FF800E.l
	bne.s	.L27C4C
	move.b	#$3C,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.L27C6E
	btst.b	#$4,$FF800E.l
	beq.s	.L27C6E
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L27C88
	btst.b	#$3,$FF800E.l
	bne.s	.L27C88
	bclr.b	#$4,$FF800F.l
.L27C9A
	movem.l	d1/a0,-(sp)
	bra.w	.L27CAE
.L27CA2
	movem.l	d1/a0,-(sp)
	bra.w	.L27DE8
.L27CAA
	movem.l	d1/a0,-(sp)
.L27CAE
	moveq	#$0,d0
.L27CB0
	btst.b	#$4,$FF800E.l
	bne.s	.L27CB0
	move.b	#$0,$FF8028.l
	move.w	#$36,$FF8026.l
	bset.b	#$3,$FF800F.l
.L27CD2
	btst.b	#$3,$FF800E.l
	beq.s	.L27CD2
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L27CEC
	btst.b	#$3,$FF800E.l
	bne.s	.L27CEC
	bclr.b	#$4,$FF800F.l
.L27CFE
	btst.b	#$4,$FF800E.l
	bne.s	.L27CFE
	move.w	#$37,$FF8026.l
	bset.b	#$3,$FF800F.l
.L27D18
	btst.b	#$3,$FF800E.l
	beq.s	.L27D18
	move.b	$FF8018.l,d0
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L27D38
	btst.b	#$3,$FF800E.l
	bne.s	.L27D38
	bclr.b	#$4,$FF800F.l
.L27D4A
	btst.b	#$4,$FF800E.l
	bne.s	.L27D4A
	move.b	#$40,$FF8028.l
	move.w	#$36,$FF8026.l
	bset.b	#$3,$FF800F.l
.L27D6C
	btst.b	#$3,$FF800E.l
	beq.s	.L27D6C
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L27D86
	btst.b	#$3,$FF800E.l
	bne.s	.L27D86
	bclr.b	#$4,$FF800F.l
.L27D98
	btst.b	#$4,$FF800E.l
	bne.s	.L27D98
	move.w	#$37,$FF8026.l
	bset.b	#$3,$FF800F.l
.L27DB2
	btst.b	#$3,$FF800E.l
	beq.s	.L27DB2
	move.b	$FF8018.l,d1
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L27DD2
	btst.b	#$3,$FF800E.l
	bne.s	.L27DD2
	bclr.b	#$4,$FF800F.l
	bra.w	.L27F22
.L27DE8
	moveq	#$0,d0
.L27DEA
	btst.b	#$4,$FF800E.l
	bne.s	.L27DEA
	move.b	#$0,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.L27E0C
	btst.b	#$4,$FF800E.l
	beq.s	.L27E0C
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L27E26
	btst.b	#$3,$FF800E.l
	bne.s	.L27E26
	bclr.b	#$4,$FF800F.l
.L27E38
	btst.b	#$4,$FF800E.l
	bne.s	.L27E38
	move.w	#$38,$FF8026.l
	bset.b	#$3,$FF800F.l
.L27E52
	btst.b	#$3,$FF800E.l
	beq.s	.L27E52
	move.b	$FF8018.l,d0
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L27E72
	btst.b	#$3,$FF800E.l
	bne.s	.L27E72
	bclr.b	#$4,$FF800F.l
.L27E84
	btst.b	#$4,$FF800E.l
	bne.s	.L27E84
	move.b	#$40,$FF8028.l
	move.w	#$35,$FF8026.l
	bset.b	#$3,$FF800F.l
.L27EA6
	btst.b	#$4,$FF800E.l
	beq.s	.L27EA6
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L27EC0
	btst.b	#$3,$FF800E.l
	bne.s	.L27EC0
	bclr.b	#$4,$FF800F.l
.L27ED2
	btst.b	#$4,$FF800E.l
	bne.s	.L27ED2
	move.w	#$38,$FF8026.l
	bset.b	#$3,$FF800F.l
.L27EEC
	btst.b	#$3,$FF800E.l
	beq.s	.L27EEC
	move.b	$FF8018.l,d1
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L27F0C
	btst.b	#$3,$FF800E.l
	bne.s	.L27F0C
	bclr.b	#$4,$FF800F.l
	bra.w	.L27F22
.L27F22
	asl.b	#$2,d0
	andi.b	#$C0,d0
	andi.b	#$3F,d1
	or.b	d1,d0
	not.b	d0
	not.b	d1
	andi.w	#$F,d1
	lea	.L27F4A(pc),a0
	andi.b	#$F0,d0
	or.b	(a0,d1.w),d0
	not.b	d0
	movem.l	(sp)+,d1/a0
	rts
.L27F4A
	dc.w	$0001,$0201
	dc.w	$0405,$0606
	dc.w	$0809
	dc.w	$0A0A
	dc.w	$0809
	dc.w	$0A00
.L27F5A
	move.b	$2800A.l,d0
	bsr.w	.L27FD2
	move.w	$28002.l,d2
	move.w	d1,$28002.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
	move.b	$2800B.l,d0
	bsr.w	.L27FD2
	move.w	$28004.l,d2
	move.w	d1,$28004.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
	move.b	$2800C.l,d0
	bsr.w	.L27FD2
	move.w	$28006.l,d2
	move.w	d1,$28006.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
	move.b	$2800D.l,d0
	bsr.w	.L27FD2
	move.w	$28008.l,d2
	move.w	d1,$28008.l
	move.w	d1,d3
	eor.w	d1,d2
	and.w	d2,d1
	rts
.L27FD2
	not.b	d0
	clr.w	d1
	move.b	d0,d1
	move.w	d1,-(sp)
	andi.w	#$F0,d0
	andi.w	#$F,d1
	lea	(.L27FF2).l,a0
	move.b	(a0,d1.w),d1
	or.w	d1,d0
	move.w	(sp)+,d1
	rts
.L27FF2
	dc.w	$0800
	dc.w	$0408
	dc.w	$0607,$0508
	dc.w	$0201,$0308
	dc.w	$0808
	dc.w	$0808
	ori.b	#$0,d0
	ori.b	#$0,d0
	ori.b	#$0,d0
.L2800E
	btst.b	#$1,$FF8003.l
	beq.s	.L2800E
	rts
.L2801A
	bset.b	#$0,$FF8003.l
.L28022
	btst.b	#$1,$FF8003.l
	bne.s	.L28022
	rts
.L2802E
	btst.b	#$7,$FF800E.l
	bne.s	.L2802E
.L28038
	btst.b	#$6,$FF800E.l
	beq.s	.L28038
	bset.b	#$6,$FF800F.l
	bset.b	#$7,$FF800F.l
.L28052
	btst.b	#$6,$FF800E.l
	bne.s	.L28052
	bclr.b	#$6,$FF800F.l
	bclr.b	#$7,$FF800F.l
	rts
	move.w	#$7,d2
.L28072
	move.b	d2,d3
	addi.w	#$40,d3
	move.b	d3,$FF000F.l
	move.b	#$0,$FF000D.l
	move.b	#$0,$FF000B.l
	move.b	#$0,$FF0009.l
	dbf	d2,.L28072
	move.b	#$40,$FF000F.l
	move.b	#$80,$FF000F.l
	move.w	#$F,d2
.L280AE
	move.w	#$FFF,d0
	move.l	#$0,d1
	movea.l	#$FF2001,a0
	move.b	d2,$FF000D.l
.L280C4
	move.b	d1,$0(a0)
	adda.w	#$2,a0
	dbf	d0,.L280C4
	dbf	d2,.L280AE
	move.b	#$FF,$FF0011.l
	rts
	movem.l	d0-d1/a0-a1,-(sp)
.L280E2
	move.w	#$80,d0
	jsr	$5F22.w
	bcs.s	.L280E2
	movem.l	(sp)+,d0-d1/a0-a1
	rts
.L280F2
	bclr.b	#$2,$FF8003.l
	bne.s	.L280F2
	rts
.L280FE
	incbin	..\cdbin\STARTER.BIN,$1D0FE,18	;text, read from the disc file
	ori.w	#$6163,d2
	incbin	..\cdbin\STARTER.BIN,$1D114,15	;text, read from the disc file
	dc.b	$00
	incbin	..\cdbin\STARTER.BIN,$1D124,18	;text, read from the disc file
	dc.w	$0077,$616E,$7420
	incbin	..\cdbin\STARTER.BIN,$1D13C,13	;text, read from the disc file
	dc.b	$00
	incbin	..\cdbin\STARTER.BIN,$1D14A,18	;text, read from the disc file
	dc.w	$0020,$2020
	incbin	..\cdbin\STARTER.BIN,$1D160,15	;text, read from the disc file
	dc.b	$00
	incbin	..\cdbin\STARTER.BIN,$1D170,18	;text, read from the disc file
	ori.w	#$7573,(a0)
	incbin	..\cdbin\STARTER.BIN,$1D186,15	;text, read from the disc file
	dc.b	$00
	incbin	..\cdbin\STARTER.BIN,$1D196,18	;text, read from the disc file
	dc.w	$0020,$2020
	incbin	..\cdbin\STARTER.BIN,$1D1AC,15	;text, read from the disc file
	dc.b	$00
.L281BC
	incbin	..\cdbin\STARTER.BIN,$1D1BC,10	;text, read from the disc file
	ori.b	#$2E,$2E(a6)
	ori.b	#$20,$2020(a6)
	incbin	..\cdbin\STARTER.BIN,$1D1D2,15	;text, read from the disc file
	dc.b	$00
	incbin	..\cdbin\STARTER.BIN,$1D1E2,18	;text, read from the disc file
	dc.w	$0073
	incbin	..\cdbin\STARTER.BIN,$1D1F6,17	;text, read from the disc file
	dc.b	$00
	incbin	..\cdbin\STARTER.BIN,$1D208,18	;text, read from the disc file
	ori.w	#$6F75,$206D7573.l
	incbin	..\cdbin\STARTER.BIN,$1D222,11	;text, read from the disc file
	dc.b	$00
	incbin	..\cdbin\STARTER.BIN,$1D22E,18	;text, read from the disc file
	ori.w	#$6E20,$7468(a1)
	incbin	..\cdbin\STARTER.BIN,$1D246,13	;text, read from the disc file
	dc.b	$00
	incbin	..\cdbin\STARTER.BIN,$1D254,18	;text, read from the disc file
	dc.w	$0020,$2020
	incbin	..\cdbin\STARTER.BIN,$1D26A,15	;text, read from the disc file
	dc.b	$00
	incbin	..\cdbin\STARTER.BIN,$1D27A,18	;text, read from the disc file
	ori.w	#$6620,$796F(a1)
	incbin	..\cdbin\STARTER.BIN,$1D292,13	;text, read from the disc file
	dc.b	$00
	incbin	..\cdbin\STARTER.BIN,$1D2A0,18	;text, read from the disc file
	dc.w	$0000
.L282B4
	dc.w	$0808
	ori.b	#$0,(a0)+
	ori.b	#$0,d0
	ori.b	#$0,d0
	ori.b	#$3,d0
	move.b	(a1),-(a0)
	dc.w	$0002,$3111
	dc.w	$0002,$2300
	dc.w	$0002,$2200
	dc.w	$0002,$2200
	ori.b	#$0,d0
	ori.b	#$0,d0
	ori.b	#$0,d0
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	dcb.b	24,0
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	dcb.b	24,0
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	dcb.b	24,0
	move.b	(a1),-(a0)
	move.w	d0,d0
	move.b	(a3),-(a0)
	move.l	d0,d0
	dc.w	$0032,$2000,$0022
	move.l	d0,d0
	dc.w	$0022,$2000
	dc.w	$0002,$2200
	dc.w	$0002,$2200
	dc.w	$0002,$2200
	dc.w	$0002,$2200
	dc.w	$0002,$2200
	dc.w	$0002,$2200
	dc.w	$0002,$2200
	dc.w	$0002,$2200
	dcb.b	97,0
	dc.b	$22
	move.l	d0,d0
	dc.w	$0022,$2000
	dc.w	$0022,$2000
	dc.w	$0022,$2000
	dc.w	$0022,$2000
	dc.w	$0022,$2000
	dc.w	$0022,$2000
	dc.w	$0022,$2000
	dc.w	$0002,$2200
	dc.w	$0002,$2200
	dc.w	$0002,$3311
	dc.w	$0003,$1111
	dcb.b	24,0
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	dcb.b	24,0
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	dcb.b	24,0
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	move.b	(a1),-(a0)
	dcb.b	17,0
	dc.b	$22
	move.l	d0,d0
	dc.w	$0032
	move.l	d0,d0
	move.b	(a3),-(a0)
	move.l	d0,d0
	move.b	(a1),-(a0)
	move.w	d0,d0
	dcb.b	304,0
