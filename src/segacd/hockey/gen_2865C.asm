NoPicGoalie2						;the generic goalie card: DrawPlayerPicture uses it for a goalie with no
									;card whose hand rating (h) bit 0 is clear (NoPicGoalie1 when set). Also
									;listed for ANH 0 and FLA 0
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_28714.bin
	even
Card001								;Player card 1 (FeaturedPictures BOS 0)
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_28A7E.bin
NHLPALogoMapDisc					;disc only: graphics after Card001 (through the end of $2B65C). From its start on, it is the
									;cartridge's NHLPALogoMap data from byte $780 to $49B4, then more map data
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_28DE8.bin
