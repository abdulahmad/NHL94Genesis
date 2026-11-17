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
	include	segacd\main\mainsubcomm.asm
	include	segacd\main\hwread.asm
	include	segacd\main\mainsubcmd.asm
	include	segacd\main\mainctrl.asm
	include	segacd\main\maindrawb.asm
	include	segacd\main\maincmd.asm
	include	segacd\main\z80driver.asm
	include	segacd\main\mainsound.asm
	include	segacd\main\z80load.asm
	include	segacd\main\mainsound2.asm
