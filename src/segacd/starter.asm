	include	macros\genesis.mac

	org	$21300

; Sega CD sub CPU BIOS: backup RAM call (d0 = function: 0 BRMINIT, 1 BRMSTAT, 2 BRMSERCH, 3 BRMREAD, 4 BRMWRITE, 5 BRMDEL, 6 BRMFORMAT).
BiosBuram	equ	$5F16

	include	segacd\starter\subboot.asm
	include	segacd\starter\startersubpcm.asm
	include	segacd\starter\starterbios.asm
	include	segacd\starter\starterscreen.asm
	include	segacd\starter\startersprite.asm
	include	segacd\starter\starteranim.asm
	include	segacd\starter\startercmd.asm
	include	segacd\starter\pcmclear.asm
	include	segacd\starter\cdcwait.asm
	include	segacd\starter\startervars.asm
	include	segacd\starter\filmrun.asm
	include	segacd\starter\filmsm.asm
	include	segacd\starter\pcmchip.asm
	include	segacd\starter\startercdbios.asm
	include	segacd\starter\filmopen.asm
	include	segacd\starter\starterfilmstr.asm
	include	segacd\starter\filmtask.asm
	include	segacd\starter\starterfilmname.asm
	include	segacd\starter\filmclose.asm
	include	segacd\starter\starterheap.asm
	include	segacd\starter\filmcmd.asm
	include	segacd\starter\startercopy.asm
	include	segacd\starter\filmbuf.asm
	include	segacd\starter\startersect.asm
	include	segacd\starter\subheap.asm
	include	segacd\starter\starterblock.asm
	include	segacd\starter\audiostream.asm
	include	segacd\starter\starterarith.asm
	include	segacd\starter\cdfade.asm
	include	segacd\starter\starterdisptbl.asm
	include	segacd\starter\startergate.asm
	include	segacd\starter\starterstr.asm

	objend
