;
;	Top level of the full NHL 94 ROM build (build94.bat, npm run build:retail).
;	nhl94.asm is the include list, in ROM order: each file assembles at the address after the one before it.
;	The address on each include line there is the retail lst/nhl94.bin start address. See SEGMENT_AGENT.md "ROM map".
;	Ram94.Asm has no active lines; the ports, VDP status bits and RAM names are in stubinc, as in each *_stub.asm.
;
	include	stubinc\ports.inc	;IO_* / VDP_* ports. Equates only
	include	stubinc\equals.inc	;VDP status bits. Equates only
	include	stubinc\ram_addrs.inc	;RAM names. Equates only

	include	nhl94.asm		;the ROM include list, in ROM order, then the $FF fill
