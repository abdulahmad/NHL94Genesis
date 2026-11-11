;	MAIN.BIN $4F6A-$5269 (runtime $FF5F6A): a second copy of $2D2A-$3029, byte for byte the same as
;	src/segacd/mainfont.asm. Its branches are pc-relative and any absolute address in it still points into the
;	first copy, so the same source, included unchanged, gives these bytes.

	include	segacd\mainfont.asm
