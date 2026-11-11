;	PLAYER.BIN $40C6-$AE6F: the picture data, then the zero-filled variable area. Written by hand.
;
;	From $40C6 the file holds the images playerpic.asm copies to $BC000 for the main CPU (the player photos
;	and the generic frame); they are read from the disc file here, as the cartridge build reads its graphics
;	from Extracted/.
;
;	From $A594 to the end the file is zeros: the area the start-up points a6 and the stack into (lea
;	0(pc,a6.l) in playerinit.asm).

	org	$40C6

PlayerPictures
	incbin	..\cdbin\PLAYER.BIN,$40C6,25806
PlayerVars
	dcb.b	2268,0
