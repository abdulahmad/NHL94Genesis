;	HOCKEY.BIN $7534-$76A7 (runtime $22534-$226A7): cards94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	Part 2 of cards94: the save RAM readers (ReadPlayerRecord ... NameLogIO, PlayerRecordOffsets).
;	On the disc they sit here, next to sram94, not in cards94 (part 1 at $9B5E). The cartridge code.

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

ReadSRAM	equ	$22452
WriteSRAM	equ	$2246C

	org	$22534

ReadPlayerRecord					;Read the 4 byte player record d1 (PlayerRecordOffsets) of team d0 from
									;save RAM to a0
	bclr.b	#6,(sflags6).l			;bit 6 clear = read
PlayerRecordIO						;Read (sflags6 bit 6 clear) or write a save RAM record block (ReadSRAM /
									;WriteSRAM). Entered from WritePlayerRecord
	movem.l	d0-d1/a0-a1,-(sp)
	asl.l	#2,d0					;team d0 * 4 bytes ... (record base 0)
	addi.l	#0,d0					;plus the record base
	movea.l	#PlayerRecordOffsets,a1	;record slot of each player
	add.w	d1,d1					;PlayerRecordOffsets is word sized
	move.w	(a1,d1.w),d1			;his slot
	asl.w	#2,d1					;slot * 4 bytes per record
	ext.l	d1
	add.l	d1,d0
	move.l	#4,d1					;4 bytes per record
	btst.b	#6,(sflags6).l			;write?
	beq.w	.read
	jsr	(WriteSRAM).l
	bra.w	.x
.read								;read: SRAM to a0
	jsr	(ReadSRAM).l
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d1/a0-a1
	rts
WritePlayerRecord					;Write the 4 byte player record
	bset.b	#6,(sflags6).l			;bit 6 set = write
	bra.w	PlayerRecordIO
ReadCrowdRecord						;Read the 16 byte crowd record block of team d1 from save RAM
									;(CrowdRecBase + team * 16) to a0. Called from
									;LoadCrowdRec and PrintCrowdMeter
	bclr.b	#6,(sflags6).l			;bit 6 clear = read
CrowdRecordIO						;The crowd record block: read or write (sflags6 bit 6). Entered from
									;ReadCrowdRecord and WriteCrowdRecord
	movem.l	d0-d1/a0-a1,-(sp)
	move.l	d1,d0
	asl.w	#4,d0					;16 bytes per team
	addi.l	#CrowdRecBase,d0		;plus the crowd record base
	move.l	#$10,d1
	btst.b	#6,(sflags6).l			;write?
	beq.w	.read
	jsr	(WriteSRAM).l
	bra.w	.x
.read								;read: SRAM to a0
	jsr	(ReadSRAM).l
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d1/a0-a1
	rts
WriteCrowdRecord					;Write the 16 byte crowd record block of team d1 (CrowdRecordIO)
	bset.b	#6,(sflags6).l			;bit 6 set = write
	bra.w	CrowdRecordIO
ReadTeamRecord						;Read the 16 byte team record block of team d1 (TeamRecBase + team * 16)
									;to a0 (TeamRecordIO)
	bclr.b	#6,(sflags6).l			;bit 6 clear = read
TeamRecordIO						;A save RAM record block: read or write (sflags6 bit 6)
	movem.l	d0-d1/a0-a1,-(sp)
	move.l	d1,d0
	asl.w	#4,d0					;16 bytes per team
	addi.l	#TeamRecBase,d0			;plus the team record base
	move.l	#$10,d1
	btst.b	#6,(sflags6).l			;write?
	beq.w	.read
	jsr	(WriteSRAM).l
	bra.w	.x
.read								;read: SRAM to a0
	jsr	(ReadSRAM).l
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d1/a0-a1
	rts
WriteTeamRecord						;Write the team record block (TeamRecordIO)
	bset.b	#6,(sflags6).l			;bit 6 set = write
	bra.w	TeamRecordIO
WriteNameLog						;Write the user name log ($80 bytes at namelog) to save RAM at NameLogBase
									;(NameLogIO)
	bset.b	#6,(sflags6).l			;bit 6 set = write
	bra.w	NameLogIO
ReadNameLog							;Read the user name log from save RAM at NameLogBase to namelog. Called
									;from GameSetUp
	bclr.b	#6,(sflags6).l			;bit 6 clear = read
NameLogIO							;A user record block: read or write (sflags6 bit 6)
	movem.l	d0-d7/a0-a6,-(sp)
	move.l	#NameLogBytes,d1
	move.l	#NameLogBase,d0
	movea.l	#namelog,a0
	btst.b	#6,(sflags6).l			;write?
	beq.w	.read
	jsr	(WriteSRAM).l				;namelog to SRAM
	bra.w	.x
.read								;read: SRAM to namelog
	jsr	(ReadSRAM).l
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a6
	rts
PlayerRecordOffsets	dc.b	0		;Record offsets for ReadPlayerRecord
	dc.b	0,0,$1A,0
	dc.b	$34						;4
	dc.b	0
	dc.b	$4E						;N
	dc.b	0
	dc.b	$68						;h
	dc.b	0,$82,0,$9C,0,$B6,0,$D0,0,$EA,1,4,1,$1E,1
	dc.b	$38						;8
	dc.b	1
	dc.b	$52						;R
	dc.b	1
	dc.b	$6C						;l
	dc.b	1,$86,1,$A0,1,$BA,1,$D4,1,$EE,2,8,2
	dc.b	$22						;"
	dc.b	2
	dc.b	$3C						;<
	dc.b	2
	dc.b	$56						;V
	dc.b	2
	dc.b	$70						;p
	dc.b	2,$8A,2,$A4,2,$BE,2,$D8
