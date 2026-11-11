;	MAIN.BIN $56F8-$57E7 (runtime $FF66F8): a second copy of $34B8-$35A7, byte for byte the same as
;	src/segacd/main/maincrt.asm (the Sierra C run-time helpers). Its branches are pc-relative, so the same
;	source, included unchanged, gives these bytes.

	include	segacd\main\maincrt.asm
