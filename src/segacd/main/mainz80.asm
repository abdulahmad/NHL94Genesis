;	MAIN.BIN $5E0C-$765B (runtime $FF6E0C-$FF865B). Written by hand.
;
;	The Z80 sound image: the $1850 bytes InitSoundCommand and InitSoundDriverCommand (game shell commands
;	$29 and $40) pass to z80load.asm, which copies them to Z80 RAM $0000. The vectors, the program from Z80
;	$0600 and the RAM it shares with the 68000 (zero here). It is not the cartridge Z80 driver. The source
;
;	is mainz80.z80 (asm80, written by tools/segacd_z80dis.py); tools/build.js --segacd assembles it into
;	output/obj/z80/mainz80.bin before the fragments, and this includes it.

	org	$FF6E0C

Z80SoundImage
	incbin	..\output\obj\z80\mainz80.bin
