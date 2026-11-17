; HOCKEY.BIN sfx, file $1C10C. Loaded at $1B000 this is $3710C.
; The cartridge sfx (middle94.asm): play sound effect number, one word passed on stack.
; A negative id returns. Otherwise the id is stored in lastsfx and $FF8022, and command
; $26 is posted on the bit-6 handshake instead of calling play_sfx_or_music_track.
; See docs/segacd_song.md.




sfx									;play sound effect number. One word passed on stack
	move.l	d0,-(sp)				;disc saves d0 only (cartridge saves d0-d7/a0-a6)
	move.w	8(sp),d0				;the number word
	bmi.w	.none					;negative = no sound
	move.w	d0,(lastsfx).l			;remember the last effect
	move.w	d0,$FF8022.l			;effect number for the main CPU
.w1	btst.b	#7,$FF800E.l
	bne.b	.w1
	move.w	#$26,$FF8020.l			;command $26: play effect
	bset.b	#6,$FF800F.l
.w2	btst.b	#6,$FF800E.l
	beq.b	.w2
	bset.b	#7,$FF800F.l
	bclr.b	#6,$FF800F.l
.w3	btst.b	#6,$FF800E.l
	bne.b	.w3
	bclr.b	#7,$FF800F.l
.none								;pop the d0 saved above
	movem.l	(sp)+,d0
	move.l	(sp),2(sp)				;return address over the number word
	addq.w	#2,sp					;(callee pops its own argument)
	rts

