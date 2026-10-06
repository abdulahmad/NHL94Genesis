	include	macros\genesis.mac	;String (main94.asm includes it in the full build)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	hockey94_11 segment stub. Retail $018CFC-$01A04F.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; .region code
	org	$18CFC

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $018CFC-$01A04F, read from lst/nhl94.bin: jsr / jmp (x).l, movea.l / move.l #x and
; lea (x).l carry the address; bsr.w / bra.w / Bcc.w is the displacement word address + displacement. IDA names.
InitTeamSructure = $171BE	;hockey94_06 label. The line editor menus have dc.l InitTeamSructure+$10 (retail $171CE)
ReplayMode = $9FD0		;dc.l in the menu lists, retail value. hockey94_02
assbench = $C710			;dc.l in asstab, retail value. logic94_2
assbreakaway = $E6CE		;dc.l in asstab, retail value. logic94_4
asscenterd = $D1E8		;dc.l in asstab, retail value. logic94_3
asscentero = $D294		;dc.l in asstab, retail value. logic94_3
assdefd = $CDE0			;dc.l in asstab, retail value. logic94_2
assdefo = $CD00			;dc.l in asstab, retail value. logic94_2
assdopen = $CA2A			;dc.l in asstab, retail value. logic94_2
asseben = $C882			;dc.l in asstab, retail value. logic94_2
assepen = $CA50			;dc.l in asstab, retail value. logic94_2
assfaceoff = $CB3A		;dc.l in asstab, retail value. logic94_2
assfaceoffp1 = $CB50		;dc.l in asstab, retail value. logic94_2
assfight = $CBE0			;dc.l in asstab, retail value. logic94_2
assfwatch = $CBE2		;dc.l in asstab, retail value. logic94_2
assgoaliebreakwait = $CAE0	;dc.l in asstab, retail value. logic94_2
assgoaliecpu = $D51C		;dc.l in asstab, retail value. logic94_3
assgoaliectrl = $D3C6		;dc.l in asstab, retail value. logic94_3
assgoalietopuck = $DD2E		;dc.l in asstab, retail value. logic94_3
assnearest = $E6F4		;dc.l in asstab, retail value. logic94_4
assonetimer = $F693E		;dc.l in asstab, retail value
asspassrec = $EB84		;dc.l in asstab, retail value. logic94_4
asspenalty = $C8F0		;dc.l in asstab, retail value. logic94_2
asspuckc = $DF18			;dc.l in asstab, retail value. logic94_3
assscore = $CC4E			;dc.l in asstab, retail value. logic94_2
assshoot = $EC82			;dc.l in asstab, retail value. logic94_4
assstanley = $CBFA		;dc.l in asstab, retail value. logic94_2
asswingd = $CF9A			;dc.l in asstab, retail value. logic94_2
asswingo = $D09C			;dc.l in asstab, retail value. logic94_3
chkpuckc = $DEEE			;dc.l in asstab, retail value. logic94_3
puckfaceoff = $F3E4		;dc.l in asstab, retail value. logic94_4
puckfaceoff2 = $F88E		;dc.l in asstab, retail value. logic94_4
pucknorm = $FF0C			;dc.l in asstab, retail value. logic94_4
puckpenshot = $EF92		;dc.l in asstab, retail value. logic94_4
puckshadow = $102EC		;dc.l in asstab, retail value. logic94_5
puckshootout = $ECB6		;dc.l in asstab, retail value. logic94_4
puckunflip = $102A8		;dc.l in asstab, retail value. logic94_5
rtss2 = $15464			;dc.l in asstab, retail value. hockey94_05
sub_80D4 = $80D4			;dc.l in the menu lists, retail value. no IDA label
sub_82DA = $82DA			;dc.l in the menu lists, retail value. no IDA label
sub_88C8 = $88C8			;dc.l in the menu lists, retail value. no IDA label
sub_8928 = $8928			;dc.l in the menu lists, retail value. no IDA label
sub_89AC = $89AC			;dc.l in the menu lists, retail value. no IDA label
sub_8EB0 = $8EB0			;dc.l in the menu lists, retail value. no IDA label
sub_9142 = $9142			;dc.l in the menu lists, retail value. no IDA label
sub_9428 = $9428			;dc.l in the menu lists, retail value. no IDA label
sub_945A = $945A			;dc.l in the menu lists, retail value. no IDA label
sub_9A2A = $9A2A			;dc.l in the menu lists, retail value. no IDA label
sub_9D7A = $9D7A			;dc.l in the menu lists, retail value. no IDA label
sub_9DE6 = $9DE6			;dc.l in the menu lists, retail value. no IDA label
sub_FA07E = $FA07E		;dc.l in the menu lists, retail value. no IDA label
sub_FBC14 = $FBC14		;dc.l in the menu lists, retail value. no IDA label
sub_FC620 = $FC620		;dc.l in the menu lists, retail value. no IDA label
sub_FD90C = $FD90C		;dc.l in the menu lists, retail value. no IDA label
sub_FDC5A = $FDC5A		;dc.l in the menu lists, retail value. no IDA label
sub_FE1D8 = $FE1D8		;dc.l in the menu lists, retail value. no IDA label

; Main segment code
	include	hockey94_11.asm
