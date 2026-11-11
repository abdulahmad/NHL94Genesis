;	MAIN.BIN $526A-$56F7 (runtime $FF626A): a second copy of $302A-$34B7, byte for byte the same as
;	src/segacd/maintext.asm. Its branches are pc-relative and any absolute address in it still points into the
;	first copy, so the same source, included unchanged, gives these bytes.

	include	segacd\maintext.asm
