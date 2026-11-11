;	HOCKEY.BIN $278A0-$28A7D (runtime $428A0-$43A7D): graphics94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	Part 1 of graphics94: the player picture palette and the four no-picture cards cards94 draws,
;	read from the disc file. The rest of the file (from $28A7E: arena sprites, the graphics pointer
;	table at $2CD00, code at $2CDAE) is not done yet.

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

	org	$428A0

PicturePalette						;the player picture palette, and the picture of a player with none
									;(DrawMatchupPicture, PlayerCardScreen)
	incbin	..\cdbin\HOCKEY.BIN,$278A0,1078	;PicturePalette.bin (from the disc file)
	even
NoPicSkater1						;read by DrawPlayerPicture (high ROM)
	incbin	..\cdbin\HOCKEY.BIN,$27CD6,874	;NoPicSkater1.map.jim (from the disc file)
	even
NoPicSkater2						;read by DrawPlayerPicture (high ROM)
	incbin	..\cdbin\HOCKEY.BIN,$28040,874	;NoPicSkater2.map.jim (from the disc file)
	even
NoPicGoalie1						;read by DrawPlayerPicture (high ROM)
	incbin	..\cdbin\HOCKEY.BIN,$283AA,874	;NoPicGoalie1.map.jim (from the disc file)
	even
NoPicGoalie2						;the generic goalie card: DrawPlayerPicture uses it for a goalie with no
									;card whose hand rating (h) bit 0 is clear (NoPicGoalie1 when set). Also
									;listed for ANH 0 and FLA 0
	incbin	..\cdbin\HOCKEY.BIN,$28714,874	;NoPicGoalie2.map.jim (from the disc file)
