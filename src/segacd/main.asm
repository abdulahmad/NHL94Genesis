	include	macros\genesis.mac
	include	segacd\main\equates94cd.asm

	org	$FF0000

	include	segacd\main\maincd94cd.asm
	include	segacd\main\maindma94cd.asm
	include	segacd\main\maincont94cd.asm
	include	segacd\main\mainblit94cd.asm
	include	segacd\main\mainvdp94cd.asm
	include	segacd\main\mainpad94cd.asm
	include	segacd\main\maindisp94cd.asm
	include	segacd\main\mainfont94cd.asm
	include	segacd\main\maintext94cd.asm
	include	segacd\main\mainsubcomm94cd.asm
	include	segacd\main\hwread94cd.asm
	include	segacd\main\mainsubcmd94cd.asm
	include	segacd\main\mainctrl94cd.asm
	include	segacd\main\maindrawb94cd.asm
	include	segacd\main\maincmd94cd.asm
	include	segacd\main\z80driver94cd.asm
	include	segacd\main\mainsound94cd.asm
	include	segacd\main\z80load94cd.asm
	include	segacd\main\mainsound294cd.asm
