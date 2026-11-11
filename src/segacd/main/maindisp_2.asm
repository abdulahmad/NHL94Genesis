;	MAIN.BIN $40D0-$4F69 (runtime $FF50D0): a second copy of $1E90-$2D29, byte for byte the same as
;	src/segacd/maindisp.asm. Its branches are pc-relative and any absolute address in it still points into the
;	first copy, so the same source, included unchanged, gives these bytes.

	include	segacd\maindisp.asm
