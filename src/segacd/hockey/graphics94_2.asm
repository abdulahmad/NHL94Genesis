;	HOCKEY.BIN $28A7E-$2CCFB (runtime $43A7E-$47CFB): graphics94.asm part 2, graphics data.
;	Written by hand (not by tools/segacd_port.py): the bytes are read from the disc file, as the cartridge
;	build reads its graphics from Extracted/.
;
;	It opens with the arena animation graphics. ArenaAnims (arena94.asm) points at them as
;	NHLPALogoMap+offset; NHLPALogoMap itself is not a disc address (its offsets land here, the cartridge's
;	NHLPALogoMap layout does not). Each piece has the sprite list at 4(x) and the tiles at 8(x).
;
;	The rest, up to the graphics pointer table (cdgfxptrs.asm), is not yet identified.

	org	$43A7E

ArenaGfx8							;NHLPALogoMap+$416: arena animation 8
	incbin	..\cdbin\HOCKEY.BIN,$28A7E,2084
ArenaGfx67							;NHLPALogoMap+$C3A: arena animations 6 and 7
	incbin	..\cdbin\HOCKEY.BIN,$292A2,3334
ArenaGfx5							;NHLPALogoMap+$1940: arena animation 5
	incbin	..\cdbin\HOCKEY.BIN,$29FA8,2670
ArenaGfx34							;NHLPALogoMap+$23AE: arena animations 3 and 4
	incbin	..\cdbin\HOCKEY.BIN,$2AA16,3884
ArenaGfx12							;NHLPALogoMap+$32DA: arena animations 1 and 2, then more graphics
	incbin	..\cdbin\HOCKEY.BIN,$2B942,5050
