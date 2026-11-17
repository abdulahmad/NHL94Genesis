	include	macros\genesis.mac
	include	segacd\main\equates.asm

	org	$FF0000

	include	segacd\main\maincd.asm
	include	segacd\main\maindma.asm
	include	segacd\main\maincont.asm
	include	segacd\main\mainblit.asm
	include	segacd\main\mainvdp.asm
	include	segacd\main\mainpad.asm
	include	segacd\main\maindisp.asm
	include	segacd\main\mainfont.asm
	include	segacd\main\maintext.asm
	include	segacd\main\main_034B8.asm
	include	segacd\main\hwread.asm
	include	segacd\main\main_03C3E.asm
	include	segacd\main\z80load.asm
	include	segacd\main\main_077B8.asm
