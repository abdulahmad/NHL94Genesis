	include	macros\genesis.mac	;String (main94.asm includes it in the full build)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	video94_1 segment stub. Retail $015D9A-$0162FD.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; .region code
	org	$15D9A

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $015D9A-$0162FD, read from lst/nhl94.bin: jsr / jmp (x).l, movea.l / move.l #x and
; lea (x).l carry the address; bsr.w / bra.w / Bcc.w is the displacement word address + displacement. IDA names.
CrowdFrameList = $A4B54		;#x at $161DA. 93 CrowdSprites
Crowd_Noise = $F6EBE		;jsr / jmp (x).l at $15F00
DoDMA = $113E4			;bsr.w / Bcc.w at $15E7E. middle94_1
MusicVB = $1A50A			;jsr / jmp (x).l at $15E1E. 93 p_music_vblank
RevRinkTilelist = $B5180		;#x at $15F76
Rinktilelist = $5605A		;#x at $15F66. 93 IceRinkMap
Vmaddr = $11680			;bsr.w / Bcc.w at $15EAA. middle94_1
ZamFrameList = $A8922		;#x at $160FC. 93 ZamSprites (penalty94_2 unk_A892A is ZamFrameList+8)
checksso = $16480		;bsr.w / Bcc.w at $15EDE. video94_2
cramfade = $10FB6		;bsr.w / Bcc.w at $15DB6. middle94_1
rtss2 = $15464			;bsr.w / Bcc.w at $15E8C. hockey94_05 (an rts)
setffo = $1661A			;bsr.w / Bcc.w at $15EE6. video94_2
setsortcords = $165FC		;bsr.w / Bcc.w at $15EE2. video94_2
sfx = $11132			;bsr.w / Bcc.w at $15E16. middle94_1
showclock = $162FE		;bsr.w / Bcc.w at $15EEA. video94_2
sub_FD78A = $FD78A		;jsr / jmp (x).l at $15EF2
unk_A78AE = $A78AE		;#x at $16068. 93 FaceOffSprites

; Main segment code
	include	video94_1.asm
