; STARTER.BIN file $556E-$BC63 (runtime $2686E-$2CF63), 26358 bytes. The boot screen pictures live here,
;   not unused data: the copy loop in starterbios94cd.asm (`.next`, before LoadBootImages) copies five
;   ranges of the sub CPU image (file address + $B000) to word RAM at $80000 and stores a pointer to each
;   ($10984, $1094C, $109D8, $109DC, $109E0). The pictures are in .map.jim form (palette offset, map
;   offset, tile count with bit 15 = packed, tiles, 4 CRAM lines, map).
;     file $5BD8-$A246  TitleCredits          40 by 28 tiles: NHL HOCKEY '94 title with credits
;     file $A246-$A942  BootFont              32 by 4 tiles: the font the boot screens draw their text with
;     file $A942-$BC62  HighScoreProductions  40 by 28 tiles: the High Score Productions logo and PRESENTS
;   The next two ranges ($BC62-$C402 and $C402-$C56C, sprite sheets with a frame table: the EA logo
;   animation that ScreenSetupA plays) start inside the bytes labelled PcmBankDirectoryA below. File
;   $556E-$5BD8 (1,642 bytes) is not a picture. Studio (lib/games.js, cdImages) lists the pictures.
;   startergate.asm only writes bytes in the area as work variables ($2800A, $2800B) and reads a few words
;   at $282B4. Earlier disassembly runs turned the area into instructions (DispTableA-F ...), which is why
;   it used to be listed as code. Splitting it into one asset per picture and renaming the label needs the
;   Windows build to check the bytes, so only the comment is corrected here.
StarterUnusedData
	incbin	..\Extracted\SegaCD\STARTER\StarterUnusedData.bin

; PCM sound bank at the end of STARTER.BIN: two directory records (a 4-byte length word, then the table), then the
; unsigned 8-bit samples. Loaded into the PCM chip by SubCmdLoadWave.
; Directory record 1: length word $05D4, then $5D4 bytes of wave / instrument parameters.
PcmBankDirectoryA
	incbin	..\Extracted\SegaCD\STARTER\PcmBankDirectoryA.bin
; Directory record 2: length word $066E, then $66E bytes of wave parameters.
PcmBankDirectoryB
	incbin	..\Extracted\SegaCD\STARTER\PcmBankDirectoryB.bin
; Sample data: unsigned 8-bit PCM waves (smooth byte sequences), played by the PCM chip.
PcmSampleData
	incbin	..\Extracted\SegaCD\STARTER\PcmSampleData.bin
; From here to the end of the file is an overlay: the file keeps it at $3CFA0, the program runs it at $26CA0 (file
; address minus $16300) on top of the bytes that the stale low copies below hold. `obj` assembles it for its run address,
; so calls and pointers into it use the labels.
	obj	$26CA0
; Hand-off sequence: BIOS call 5, status handshakes $2E / $3F around the word RAM hand-over, then jumps to $B00E.
StarterBootHandshake	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$5,d0
	jsr	$6044.w
	movea.l	a0,a0
	movem.l	(sp)+,d0-d2/d7/a0-a1
	move.l	$B090.l,$6038.w
.loop	btst.b	#$7,$FF800E.l
	bne.b	.loop
	move.w	#$2E,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop2	btst.b	#$6,$FF800E.l
	beq.b	.loop2
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop3	btst.b	#$6,$FF800E.l
	bne.b	.loop3
	bclr.b	#$7,$FF800F.l
	bset.b	#$5,$FF800F.l
	bset.b	#$2,$FF8033.l
	bsr.w	GiveWordRam
.loop4	btst.b	#$7,$FF800E.l
	bne.b	.loop4
	move.w	#$3F,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop5	btst.b	#$6,$FF800E.l
	beq.b	.loop5
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop6	btst.b	#$6,$FF800E.l
	bne.b	.loop6
	bclr.b	#$7,$FF800F.l
	bsr.w	WaitDmnaSet
	move.l	$B090.l,$6038.w
.loop7	btst.b	#$7,$FF800E.l
	bne.b	.loop7
	move.w	#$2E,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop8	btst.b	#$6,$FF800E.l
	beq.b	.loop8
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop9	btst.b	#$6,$FF800E.l
	bne.b	.loop9
	bclr.b	#$7,$FF800F.l
	bset.b	#$5,$FF800F.l
	bset.b	#$2,$FF8033.l
	jmp	$B00E.l
; Mounts the backup RAM (BRMINIT), reads the save file into the buffer at $7F000 and checks its checksum; clears the
; buffer and formats the RAM when the file is missing or damaged.
BackupRamMountVerify	move.w	#$0,d0
	move.w	#$B,d7
	jsr	$6044.w
	jsr	(BackupBufferClearImage).l
	move.w	#$0,d0
	lea.l	$7D000.l,a0
	lea.l	$7C000.l,a1
	jsr	BiosBuram.w		;BRMINIT
	bcc.w	.next2
	jsr	(GateArrayIrqA).l
	cmpi.w	#$FFFF,$C442.l
	beq.w	.next4
	move.w	#$6,d0
	jsr	BiosBuram.w		;BRMFORMAT
.next2	move.w	#$3,d0
	lea.l	BackupFileName.l,a0
	lea.l	$7F000.l,a1
	jsr	BiosBuram.w		;BRMREAD
	bcs.w	.next3
	jsr	(BackupBufferChecksumImage).l
	cmp.l	$7FF20.l,d0
	beq.w	.ex
	jsr	(BackupBufferClearImage).l
.next3	move.w	#$5,d0
	lea.l	BackupFileName.l,a0
	jsr	BiosBuram.w		;BRMDEL
	move.w	#$1,d0
	lea.l	$C452.l,a1
	jsr	BiosBuram.w		;BRMSTAT
	cmpi.w	#$3D,d0
	bge.w	.ex
	move.w	#$1,$C44C.l
	jsr	(GateArrayIrqA).l
.next4	move.w	#$FFFF,d0
	move.w	#$B,d7
	jsr	$6044.w
.ex	rts
; Two 16-byte file name records (the second has a trailing $3D): the backup RAM file name.
BackupFileName
	dc.b	'NHLHOCKEY94',$00,$00,$00,$00,$00
	dc.b	'NHLHOCKEY94',$00,$00,$3D
; Image of the routine that runs in the slot at $26E96: adds up the $F20 bytes of the buffer at $7F000 into d0.
BackupBufferChecksumImage
	lea.l	$7F000.l,a0
	moveq	#$0,d0
	move.w	#$F1F,d1
.loop	add.b	(a0)+,d0
	dbra	d1,.loop
	rts
; Image of the routine that runs in the slot at $26EAA: clears the $F20 bytes of the buffer at $7F000.
BackupBufferClearImage
	lea.l	$7F000.l,a0
	move.w	#$F1F,d0
	clr.l	d1
.loop	move.b	d1,(a0)+
	dbra	d0,.loop
	rts