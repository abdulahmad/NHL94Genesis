;	BOOT.BIN $200-$783 (runtime $FF0000-$FF0583): the start of the initial program. Written by hand.
;
;	The BIOS copies the initial program to main CPU RAM $FF0000 and runs it. Its first $584 bytes are Sega's
;	security block for the US region (it shows the licence screen: "PRODUCED BY OR UNDER LICENSE FROM SEGA
;	ENTERPRISES, LTD."), the same on every US disc.
;
;	It is Sega's code, so it is read from the disc file here (cdbin/BOOT.BIN, from your own disc image), as
;	the cartridge build reads its assets from Extracted/. The game's own initial program follows in ip.asm.

	org	$FF0000

SecurityBlock
	incbin	..\cdbin\BOOT.BIN,$200,$584
