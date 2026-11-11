;	HOCKEY.BIN $6FC8-$7533 (runtime $21FC8-$22533): sram94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	CD start-up and save data. The file opens with new code (the BIOS vector at $6038, a handshake with
;	the main CPU), then Begin, the game start that the jmp at file $0 enters (stack at $C458, clears
;	$1745C-$1AD99), then ValidateSRAM / ClearSRAM reworked for the backup RAM through the BIOS ($6044).

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

HiScoreScreen	equ	$2A58C
orjoy	equ	$37460
Opening	equ	$3F2D6
DefaultMenus	equ	$40102
ReadPads	equ	$47DB2

	org	$21FC8

;CD: no cartridge twin
	move.l	#$22018,$6038.w
.L21FD0
	btst.b	#$7,$FF800E.l
	bne.s	.L21FD0
	move.w	#$2D,$FF8020.l
	bset.b	#$6,$FF800F.l
.L21FEA
	btst.b	#$6,$FF800E.l
	beq.s	.L21FEA
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L22004
	btst.b	#$6,$FF800E.l
	bne.s	.L22004
	bclr.b	#$7,$FF800F.l
	rts
	btst.b	#$5,$FF800E.l
	beq.w	.L22094
	bset.b	#$2,$FF800F.l
	move.l	#$2203A,-(sp)
	move.l	$18D66.l,-(sp)
	rts
	jsr	(ReadPads).l
.L22040
	btst.b	#$4,$FF800E.l
	bne.s	.L22040
	move.w	#$2F,$FF8026.l
	bset.b	#$3,$FF800F.l
.L2205A
	btst.b	#$3,$FF800E.l
	beq.s	.L2205A
	bset.b	#$4,$FF800F.l
	bclr.b	#$3,$FF800F.l
.L22074
	btst.b	#$3,$FF800E.l
	bne.s	.L22074
	bclr.b	#$4,$FF800F.l
	bclr.b	#$2,$FF800F.l
	addq.w	#$1,$17460.l
.L22094
	rts
Begin								;CD: its first lines have no twin; the rest of it starts here
	movea.l	#(Stack-M68K_RAM),sp	;stack pointer to Stack
	movea.l	#(VSCRLPM-M68K_RAM),a0	;clear out ram
.0	clr.l	(a0)+					;clear the RAM from VSCRLPM through PALflag
	cmpa.l	#(PALflag+2-M68K_RAM),a0
	blt.w	.0
;CD: no cartridge twin
	move.w	#$C,d7
	jsr	$6044.w
	move.w	d0,$193BA.l
	tst.w	$193BA.l
	bne.s	.L220FE
	jsr	(ClearSRAM).l
	move.w	#$0,d0
	lea	$7E000.l,a0
	lea	$17EF2.l,a1
	jsr	$5F16.w
	bcs.s	.L220F6
	move.w	#$3,d0
	lea	$2240C.l,a0
	lea	$193BC.l,a1
	jsr	$5F16.w
	bra.s	.L220FE
.L220F6
	move.w	#$FFFF,$193BA.l
.L220FE
	move.l	#$19360,$19360.l
	clr.w	$1AD94.l
.L2210E
	btst.b	#$7,$FF800E.l
	bne.s	.L2210E
	movem.l	a0,-(sp)
	lea	$C00004.l,a0
	move.l	a0,$FF8022.l
	move.w	#$18,$FF8020.l
	bset.b	#$6,$FF800F.l
.L22138
	btst.b	#$6,$FF800E.l
	beq.s	.L22138
	move.w	$FF8010.l,d0
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L22158
	btst.b	#$6,$FF800E.l
	bne.s	.L22158
	bclr.b	#$7,$FF800F.l
	movem.l	(sp)+,a0
	andi.w	#$1,d0
	move.w	d0,$18C20.l
	beq.w	.L22184
	bset.b	#$0,$1AD94.l
.L22184
	btst.b	#$7,$FF800E.l
	bne.s	.L22184
	move.w	#$2B,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2219E
	btst.b	#$6,$FF800E.l
	beq.s	.L2219E
	move.w	$FF8010.l,$18BF8.l
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L221C2
	btst.b	#$6,$FF800E.l
	bne.s	.L221C2
	bclr.b	#$7,$FF800F.l
	move.w	#$FFFF,$17DD6.l
	jsr	$21FC8.l
	move.w	#$3,d7
	jsr	$6044.w						;CD: the cartridge has (InitSaveRAM).l
	jsr	$3FDE8.l					;CD: the cartridge has (ReadLineData).l
	jsr	(HiScoreScreen).l
	jsr	(DefaultMenus).l
	move.w	(OptLine).l,(TmpOptLine2).l
	move.w	(OptPlayMode).l,(TempOptPlayMode).l
	jsr	(orjoy).l					;clear any previous button presses
	jmp	(Opening).l					;goto title screen and options etc.
;CD: no cartridge twin
.L2221C
	btst.b	#$7,$FF800E.l
	bne.s	.L2221C
.L22226
	btst.b	#$6,$FF800E.l
	beq.s	.L22226
	bset.b	#$6,$FF800F.l
	bset.b	#$7,$FF800F.l
.L22240
	btst.b	#$6,$FF800E.l
	bne.s	.L22240
	bclr.b	#$6,$FF800F.l
	bclr.b	#$7,$FF800F.l
	rts
.L2225C
	bclr.b	#$2,$FF8003.l
	bne.s	.L2225C
	rts
.L22268
	btst.b	#$1,$FF8003.l
	beq.s	.L22268
	rts
.L22274
	btst.b	#$7,$FF800E.l
	bne.s	.L22274
	move.w	#$7,$FF8020.l
	bset.b	#$6,$FF800F.l
.L2228E
	btst.b	#$6,$FF800E.l
	beq.s	.L2228E
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.L222A8
	btst.b	#$6,$FF800E.l
	bne.s	.L222A8
	bclr.b	#$7,$FF800F.l
	jsr	$22268.l
	rts
	bset.b	#$0,$FF8003.l
.L222CA
	btst.b	#$1,$FF8003.l
	bne.s	.L222CA
	rts
	movem.l	d0-d1/a0-a1,-(sp)
.L222DA
	move.w	#$80,d0
	jsr	$5F22.w
	bcs.s	.L222DA
	movem.l	(sp)+,d0-d1/a0-a1
	rts
GamePcmSounds						;CD-only data (a name given here, not a cartridge name)
	dc.w	$000D,$006C,$000E,$0060,$000E,$0061,$000E,$0062
	dc.w	$000E,$0063,$000E,$0064,$000E,$0065,$000E,$0066
	dc.w	$000E,$0067,$000E,$006D,$000E,$006E,$000E,$006F
	dc.w	$000E,$006B,$000E,$0600,$0A60,$00FF,$FF02,$0202
	dc.w	$00FF,$00FF,$0600,$0754,$00FF,$FF02,$0202,$00FF
	dc.w	$00FF,$0600,$0254,$00FF,$FF02,$0202,$00FF,$00FF
	dc.w	$0600,$0154,$00FF,$FF02,$0202,$00FF,$00FF,$0600
	dc.w	$0654,$00FF,$FF02,$0202,$00FF,$00FF,$0600,$045A
	dc.w	$00FF,$FF02,$0202,$00FF,$00FF,$0600,$005A,$00FF
	dc.w	$FF02,$0202,$00FF,$00FF,$0600,$035A,$00FF,$FF02
	dc.w	$0202,$00FF,$00FF,$0600,$0554,$00FF,$FF02,$0202
	dc.w	$0096,$00FF,$0600,$085A,$00FF,$FF02,$0202,$00FF
	dc.w	$00FF,$0600,$095A,$00FF,$FF02,$0202,$00FF,$00FF
	dc.w	$0608,$0B54,$00FF,$FF02,$0202,$00FF,$00FF,$0600
	dc.w	$0C5A,$00FF,$FF02,$0202,$00FF,$00FF
GamePcmSampleList					;CD-only data (a name given here, not a cartridge name)
	dc.w	$0002,$0000,$0002,$0001,$0002,$0002,$0002,$0003
	dc.w	$0002,$0004,$0002,$0005,$0002,$0006,$0002,$0007
	dc.w	$0002,$0008,$0002,$0009,$0002,$000A,$0002,$000B
	dc.w	$0002,$000C,$FFFF
	dc.b	'NHLHOCKEY94'
	dc.b	$00
	ori.b	#$0,d0
	dc.b	'NHLHOCKEY94'
	dc.b	$00
	dc.w	$003D
	lea	$193BC.l,a0
	moveq	#$0,d0
	move.w	#$F1F,d1
.L22436
	add.b	(a0)+,d0
	dbf	d1,.L22436
.x									;exit (also the end of the code above)
ValidateSRAM						;CD: its first lines have no twin; the rest of it starts here
	rts
ClearSRAM							;Clears first $2000 of RAM and SaveRAM: zero M68K_RAM $0-$1FFF with byte
									;$1FFE = $FF (the checksum of zeros), write it to
									;the save RAM, set byte 1 to 1, then MakeSRAMChecksum. Called from
									;InitSaveRAM
	lea	$193BC.l,a0					;CD: the cartridge has (M68K_RAM).l
	move.w	#$F1F,d0				;CD: the cartridge has #$1FFF
	clr.l	d1
.loop								;clear each byte
	move.b	d1,(a0)+
	dbf	d0,.loop
;CD: no cartridge twin
	rts
	movem.l	d0-d1/a0-a1,-(sp)
	movea.l	d0,a1
	adda.l	#$193BC,a1
	subq.l	#$1,d1
.L22460
	move.b	(a1)+,(a0)+
	dbf	d1,.L22460
	movem.l	(sp)+,d0-d1/a0-a1
	rts
	movem.l	d0-d1/a0-a1,-(sp)
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst.b	#$5,$FF800F.l
	beq.s	.L22488
	move.w	#$1,-(a6)
	bra.s	.L2248C
.L22488
	move.w	#$0,-(a6)
.L2248C
	bclr.b	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	movea.l	d0,a1
	adda.l	#$193BC,a1
	subq.l	#$1,d1
.L224A6
	move.b	(a0)+,(a1)+
	dbf	d1,.L224A6
	tst.w	$193BA.l
	bmi.w	.L22508
	jsr	$2242A.l
	move.l	d0,$1A2DC.l
	move.w	#$0,d0
	lea	$BC000.l,a0
	lea	$17EF2.l,a1
	jsr	$5F16.w
	bcs.w	.L22500
	move.w	#$5,d0
	lea	$2240C.l,a0
	jsr	$5F16.w
	move.w	#$4,d0
	lea	$2241C.l,a0
	lea	$193BC.l,a1
	jsr	$5F16.w
	bcc.w	.L22508
.L22500
	move.w	#$FFFF,$193BA.l
.L22508
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.s	.L2251E
	bset.b	#$5,$FF800F.l
	bra.s	.L22526
.L2251E
	bclr.b	#$5,$FF800F.l
.L22526
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	movem.l	(sp)+,d0-d1/a0-a1
	rts
