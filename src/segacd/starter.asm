	include	macros\genesis.mac

	org	$21300

; Sega CD sub CPU BIOS: backup RAM call (d0 = function: 0 BRMINIT, 1 BRMSTAT, 2 BRMSERCH, 3 BRMREAD, 4 BRMWRITE, 5 BRMDEL, 6 BRMFORMAT).
BiosBuram	equ	$5F16

	include	segacd\starter\subboot94cd.asm
	include	segacd\starter\startersubpcm94cd.asm
	include	segacd\starter\starterbios94cd.asm
	include	segacd\starter\starterscreen94cd.asm
	include	segacd\starter\startersprite94cd.asm
	include	segacd\starter\starteranim94cd.asm
	include	segacd\starter\startercmd94cd.asm
	include	segacd\starter\pcmclear94cd.asm
	include	segacd\starter\cdcwait94cd.asm
	include	segacd\starter\startervars94cd.asm
	include	segacd\starter\filmrun94cd.asm
	include	segacd\starter\filmsm94cd.asm
	include	segacd\starter\pcmchip94cd.asm
	include	segacd\starter\startercdbios94cd.asm
	include	segacd\starter\filmopen94cd.asm
	include	segacd\starter\starterfilmstr94cd.asm
	include	segacd\starter\filmtask94cd.asm
	include	segacd\starter\starterfilmname94cd.asm
	include	segacd\starter\filmclose94cd.asm
	include	segacd\starter\starterheap94cd.asm
	include	segacd\starter\filmcmd94cd.asm
	include	segacd\starter\startercopy94cd.asm
	include	segacd\starter\filmbuf94cd.asm
	include	segacd\starter\startersect94cd.asm
	include	segacd\starter\subheap94cd.asm
	include	segacd\starter\starterblock94cd.asm
	include	segacd\starter\audiostream94cd.asm
	include	segacd\starter\starterarith94cd.asm
	include	segacd\starter\cdfade94cd.asm
	include	segacd\starter\starterdata94cd.asm
	include	segacd\starter\startergate94cd.asm
	include	segacd\starter\starterstr94cd.asm

	objend
