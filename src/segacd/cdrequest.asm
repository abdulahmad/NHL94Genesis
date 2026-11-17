; HOCKEY.BIN song, file $1C1D2-$1C205.
; The game is entered at $1B000, so this is the jsr $371D2 target.
; The cartridge song (middle94.asm) took one word on the stack and called the FM driver.
; Here a word in $30-$77 sets $1745C and stores argument-$29 in $1745E.
; $79 and $7A (SngScouting) are outside that window and do not change the track.
; See docs/segacd_song.md.

	include	segacd\hockey.inc

;calls begin
;calls end

	org	$1C1D2

song								;play song number. One word passed on stack
	move.l	d0,-(sp)				;disc saves d0 only (cartridge saves d0-d7/a0-a6)
	move.w	8(sp),d0				;the number word
	cmpi.w	#$30,d0
	blt.w	.none					;not a CD song
	cmpi.w	#$78,d0
	bge.w	.none
	move.w	#1,$1745C.l				;track changed
	subi.w	#$29,d0
	move.w	d0,$1745E.l				;CD track to play (cdtrack.asm)
.none								;pop the d0 saved above
	movem.l	(sp)+,d0
	move.l	(sp),2(sp)				;return address over the number word
	addq.w	#2,sp					;drop the number word
	rts
