;	New in 94: battery save RAM. At power on the save RAM is copied into work RAM and checked,
;	and this file holds the routines that check, clear, read and write it.

InitSaveRAM							;Called from Begin. Copy the $2000 byte save RAM (the odd bytes) to
									;M68K_RAM and check its checksum
									;(ValidateSRAM; ValidSRAM 0 = good, -1 = bad). A bad save RAM is cleared
									;(ClearSRAM) and read again. Two power-on tests that never return:
									;Start+A+C held writes and reads back every bit of every byte, writes
									;$12,$34,$56,$78 to bytes 0-3 and flashes the screen green, or red at the
									;first bad byte; Start+B+C held flashes green if bytes 0-3 are $12345678,
									;else red
	move.l	#VBcount,(VBint).l
	move	#$2500,sr
	clr.w	(ValidSRAM).w			;good until checked
	jsr	(ReadJoy1).l				;get joypad buttons held
	move.w	d3,d0					;d0 = buttons held
	movea.l	#SaveRAM,a0				;move SRAM address into a0
	move.w	#$E,d3					;red ($00E), fading by 2 a frame
	move.w	#2,d4					;move 2 into d4
	cmp.b	#$E0,d0					;Start+A+C button held down
	beq.w	.setiterator			;branch if held down
	cmp.b	#$B0,d0					;Start+B+C buttons held down
	beq.w	.setiterator2			;branch if held down
	moveq	#0,d0					;move 0 into d0
	move.l	#$2000,d1				;$2000 into d1
	movea.l	#M68K_RAM,a0			;start of RAM into a0
	bsr.w	ReadSRAM				;Writes SRAM to RAM
	bsr.w	ValidateSRAM
	tst.w	(ValidSRAM).w
	bpl.w	.ex
	bsr.w	ClearSRAM
	moveq	#0,d0
	move.l	#$2000,d1
	movea.l	#M68K_RAM,a0
	bsr.w	ReadSRAM				;Writes SRAM to RAM
	bsr.w	ValidateSRAM
.ex									;exit (also the end of the code above)
	rts
.setiterator						;d0 = $E0
	move.w	#$1FFF,d2				;$2000 bytes
.SRAMloop							;each SRAM byte
	move.w	#1,d1					;bit 0, then up to bit 7
	move.w	#7,d0
.setto80							;each bit test
	move.w	d1,(a0)
	cmp.b	1(a0),d1
	bne.w	.loadcolor
	lsl.w	#1,d1
	dbf	d0,.setto80
	adda.w	#2,a0
	dbf	d2,.SRAMloop
	movea.l	#SaveRAM,a0
	move.l	#$120034,(a0)+			;bytes 0-3 = $12,$34,$56,$78 (word writes: the low byte goes to the odd
									;SRAM byte)
	move.l	#$560078,(a0)+
	move.w	#$E0,d3					;green ($0E0), fading by $20 a frame
	move.w	#$20,d4
.loadcolor							;flash color reset
	move.w	d3,d0					;move d3 (color of flashing screen) to d0
.flashscreen						;loop
	move.l	#CRAM_W,(Vctrl).l		;cram write 0: the background colour
	move.w	d0,d1
	and.w	d3,d1
	move.w	d1,(Vdata).l
	bsr.w	SRAMWaitVblank			;wait a vblank
	sub.w	d4,d0
	bra.s	.flashscreen
.setiterator2						;d0 = $B0
	move.w	#3,d1
.SRAMloop2							;each test byte
	adda.w	#1,a0					;odd byte
	lsl.l	#8,d0
	move.b	(a0)+,d0
	dbf	d1,.SRAMloop2
	cmp.l	#$12345678,d0
	bne.s	.loadcolor				;branch if not equal (screen flashes red)
	move.w	#$E0,d3					;green
	move.w	#$20,d4
	bra.s	.loadcolor				;branch (screen flashes green)
SRAMWaitVblank						;Wait for the next vblank. Called from InitSaveRAM
	jsr	(vcountwait).l
	rts
VBcount								;VBint handler while InitSaveRAM runs: Vcount + 1 only
	addq.w	#1,(Vcount).w			;vblank with counter only
	rte
ValidateSRAM						;Check the save RAM copy in M68K_RAM: byte $1FFF must be the sum of bytes
									;0-$1FFD, byte $1FFE its complement. ValidSRAM = 0 if they match, -1 if
									;not. Called from InitSaveRAM
	move.w	#$1FFD,d1				;set iterator to  $1FFD
	clr.w	d0						;clear d0
	lea	(M68K_RAM).l,a0				;set a0 to start of RAM
.loop								;sum each byte
	add.b	(a0)+,d0				;add value at a0 to d0 and increment a0
	dbf	d1,.loop					;loop through RAM d1 times
	clr.w	d1						;clear d1
	cmp.b	1(a0),d0				;compare data at 1+a0 ($1FFF RAM address) to d0
	beq.w	.0						;branch if equal
	addq.w	#1,d1					;add 1 to d1
.0									;checksum checked
	not.w	d0						;toggle bits in d0 from 1->0 and vice-versa
	cmp.b	(a0),d0					;compare byte at a0 ($1FFE) with d0
	beq.w	.1						;branch if equal
	addq.w	#1,d1					;add 1 to d1 if not
.1									;complement checked
	swap	d0						;swap d0 word size
	move.b	(a0),d0					;move data at a0 into d0
	not.b	d0						;toggle bits
	cmp.b	1(a0),d0				;compare data a0+1 with d0
	beq.w	.2						;branch if equal
	addq.w	#1,d1					;add 1 to d1 if not
.2									;check done
	swap	d0						;swap d0 word size
	tst.w	d1						;test d1
	bne.w	.bad					;branch if d1 not 0
	clr.w	(ValidSRAM).w			;clear
	bra.w	.x						;branch to exit
.bad								;d1 <> 0
	st	(ValidSRAM).w				;set
.x									;exit (also the end of the code above)
	rts
ClearSRAM							;Clears first $2000 of RAM and SaveRAM: zero M68K_RAM $0-$1FFF with byte
									;$1FFE = $FF (the checksum of zeros), write it to
									;the save RAM, set byte 1 to 1, then MakeSRAMChecksum. Called from
									;InitSaveRAM
	lea	(M68K_RAM).l,a0				;a0 = RAM copy buffer
	move.w	#$1FFF,d0				;$2000 bytes, as a dbf count
	clr.l	d1						;fill value 0
.loop								;clear each byte
	move.b	d1,(a0)+				;zero one byte
	dbf	d0,.loop
	move.b	#$FF,(sramcleared).l	;$FF, the checksum of all zeros
	moveq	#0,d0					;first save RAM byte 0
	move.l	#$2000,d1				;$2000 bytes
	movea.l	#M68K_RAM,a0			;from the RAM copy
	bsr.w	WriteSRAM				;write all of it to save RAM
	moveq	#1,d0					;save RAM byte 1
	moveq	#1,d1					;one byte
	move.b	#1,(M68K_RAM).l			;byte 0 of the RAM copy is written to save RAM byte 1
	movea.l	#M68K_RAM,a0			;from the RAM copy (byte 0 = 1)
	bsr.w	WriteSRAM				;write it
	bsr.w	MakeSRAMChecksum		;put the checksum bytes in place
	rts								;done
WriteSRAM							;Write data from a0 into SaveRAM: d1 = number of bytes, d0 = first save
									;RAM byte (each byte is the odd byte of a word at
									;Called from ClearSRAM, MakeSRAMChecksum and the save code
									;(ReadCrowdRecord ...)
	movem.l	d0-d2/a0-a1,-(sp)		;save registers
	movea.l	#SaveRAM,a1				;a1 = save RAM
	add.l	d0,d0					;word offset = byte number * 2 (one byte per word)
	subq.l	#1,d1					;dbf count
	clr.w	d2						;d2 high byte stays 0
.loop								;write each byte
	move.b	(a0)+,d2				;next byte to write
	move.w	d2,0(a1,d0.w)			;store it as a word
	addq.w	#2,d0					;next word
	dbf	d1,.loop
	movem.l	(sp)+,d0-d2/a0-a1		;restore registers
	rts								;done
MakeSRAMChecksum					;Read the whole save RAM to M68K_RAM, put the sum of bytes 0-$1FFD in byte
									;$1FFF and its complement in byte $1FFE
									;and write those two bytes back. Called from ClearSRAM and the save code
									;(UpdateRecords ...)
	lea	(M68K_RAM).l,a0				;a0 = RAM copy buffer
	move.l	#$2000,d1				;$2000 bytes
	clr.l	d0						;from save RAM byte 0
	bsr.w	ReadSRAM				;read the whole save RAM
	lea	(M68K_RAM).l,a0				;start of the copy again
	clr.w	d0						;d0 = sum
	move.w	#$1FFD,d1				;dbf count for bytes 0 to $1FFD
.loop								;sum each byte
	add.b	(a0)+,d0				;add each byte to the sum
	dbf	d1,.loop
	move.b	d0,1(a0)				;sum goes to save RAM byte $1FFF (a0 is at byte $1FFE here)
	not.w	d0						;complement of the sum
	move.b	d0,(a0)					;complement goes to byte $1FFE
	movea.l	#sramcleared,a0			;the two checksum bytes
	moveq	#2,d1					;two bytes
	move.l	#$1FFE,d0				;save RAM byte $1FFE
	bsr.s	WriteSRAM				;write them back
	rts								;done
ReadSRAM							;Copy d1 save RAM bytes from byte d0 (the odd bytes + d0 * 2) to (a0)+.
									;Called from InitSaveRAM, MakeSRAMChecksum and the save code
	movem.l	d0-d2/a0-a1,-(sp)		;save registers
	movea.l	#SaveRAM,a1				;a1 = save RAM
	add.l	d0,d0					;word offset = byte number * 2
	subq.l	#1,d1					;dbf count
.loop								;copy each byte
	move.b	1(a1,d0.w),d2			;odd byte of the word
	move.b	d2,(a0)+				;store it in the buffer
	addq.w	#2,d0					;next word
	dbf	d1,.loop
	movem.l	(sp)+,d0-d2/a0-a1		;restore registers
	rts								;done
