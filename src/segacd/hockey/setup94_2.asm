;	HOCKEY.BIN $24C0A-$24C11 (runtime $3FC0A-$3FC11): setup94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	Part 2 of setup94: the 8 bytes between scouttok.asm and scoutload.asm (a zero word, then the
;	jsr $37598 that opens the scouting file load).

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

	org	$3FC0A

;CD: no cartridge twin
	dc.w	$0000,$4EB9
	dc.w	$0003,$7598
