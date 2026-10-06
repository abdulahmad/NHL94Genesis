	include	macros\genesis.mac	;String (main94.asm includes it in the full build)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;
;	hockey94_06 segment stub. Retail $0169FA-$017A17.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; .region code
	org	$169FA

; includes for stubs to replace removed code
	include	stubinc\ports.inc	;IO_* / VDP_* ports
	include	stubinc\equals.inc	;VDP status bits
	include	stubinc\ram_addrs.inc	;RAM names

; External addresses outside $0169FA-$017A17, read from lst/nhl94.bin: jsr / jmp (x).l, movea.l / move.l #x and
; lea (x).l carry the address; bsr.w / bra.w / Bcc.w is the displacement word address + displacement. IDA names.
AddFramer = $11F12		;bsr.w / Bcc.w at $16ACA. middle94_2 (IDA sub_11F12)
AddPOStats = $182A2		;bsr.w / Bcc.w at $172B2
AddSmallFont = $11F04		;bsr.w / Bcc.w at $173BA. middle94_2 (IDA sub_11F04)
AddTeamBlock = $11F20		;bsr.w / Bcc.w at $173B6. middle94_2 (IDA sub_11F20)
Adda1Offset = $13510		;bsr.w / Bcc.w at $174D4
AllSndOff = $1A264		;jsr / jmp (x).l at $17288
DecompressGraphicsWithCallback = $1172C	;bsr.w / Bcc.w at $16AD8. middle94_2 (IDA sub_1172C)
DoDMA = $113E4			;bsr.w / Bcc.w at $176B4
DoDMA_clearCallbackPointer = $11738	;bsr.w / Bcc.w at $16A88. middle94_2 (IDA sub_11738)
DoDMA_nd2 = $114B8		;bsr.w / Bcc.w at $16D94. middle94_1 (IDA sub_114B8)
DoDMAlist = $15E82		;bsr.w / Bcc.w at $16B86
DoFill = $11544			;bsr.w / Bcc.w at $16A68
GameSetUp = $F739E		;jsr / jmp (x).l at $17312
Intermission = $130E6		;bsr.w / Bcc.w at $172B6
KillCrowd = $169D0		;bsr.w / Bcc.w at $172F0
MusicVB = $1A50A			;jsr / jmp (x).l at $176D2
ReadJoy1 = $11340		;bsr.w / Bcc.w at $17542
ReadJoy2 = $11358		;bsr.w / Bcc.w at $17548
ResetClock = $7814		;jsr (x).w at $17278. hockey94_01
RevRinkTiles = $B5188		;#x at $16A82
Rinktilelist = $5605A		;#x at $16C96
Rinktiles = $56062		;#x at $16A72
SetSPA = $1073A			;bsr.w / Bcc.w at $170E6
StartGame = $7742		;jmp (x).w at $17332. hockey94_01
StartPer = $7866			;jmp (x).w at $172C4. hockey94_01
UpdateScores = $1323E		;bsr.w / Bcc.w at $172A4
VBlank = $15D9A			;#x at $16B8E. video94_1 (IDA loc_15D9A)
Vmaddr = $11680			;bsr.w / Bcc.w at $176BC
addframe2 = $167AA		;bsr.w / Bcc.w at $16B56
cramfade = $10FB6		;bsr.w / Bcc.w at $176CA
dobitmap = $1169A		;bsr.w / Bcc.w at $173F0
eraser = $1197E			;bsr.w / Bcc.w at $1739C
forceblack = $10F32		;bsr.w / Bcc.w at $16BB0
newTitleScreen = $FF042		;jsr / jmp (x).l at $172F4
print = $11BA4			;bsr.w / Bcc.w at $17622
print2 = $11A48			;bsr.w / Bcc.w at $174E0
printz = $11B92			;bsr.w / Bcc.w at $17386
printz2 = $11A36			;bsr.w / Bcc.w at $174C0
rtss2 = $15464			;bsr.w / Bcc.w at $1733A. hockey94_05 (an rts)
setvram = $11594			;bsr.w / Bcc.w at $16A36
song = $11156			;bsr.w / Bcc.w at $172A0
sub_180FC = $180FC		;bsr.w / Bcc.w at $172C8
sub_9428 = $9428			;jsr / jmp (x).l at $172DA
sub_F7144 = $F7144		;jsr / jmp (x).l at $1792E
sub_F7172 = $F7172		;jsr / jmp (x).l at $17938
sub_F727C = $F727C		;jsr / jmp (x).l at $17942
sub_F72AA = $F72AA		;jsr / jmp (x).l at $1794C
sub_FBB88 = $FBB88		;jsr / jmp (x).l at $17318
sub_FCB9A = $FCB9A		;jsr / jmp (x).l at $178C0
sub_FCC76 = $FCC76		;jsr / jmp (x).l at $1732C
sub_FD5AE = $FD5AE		;jsr / jmp (x).l at $178E6
sub_FD5F4 = $FD5F4		;jsr / jmp (x).l at $1790E
sub_FEA52 = $FEA52		;jsr / jmp (x).l at $16A8C
sub_FED2A = $FED2A		;jsr / jmp (x).l at $17536
sub_FEEC8 = $FEEC8		;jsr / jmp (x).l at $178CA
sub_FEF5A = $FEF5A		;jsr / jmp (x).l at $178D4
unk_1928E = $1928E		;#x at $1743A
unk_4B5C0 = $4B5C0		;#x at $1774A
unk_54E24 = $54E24		;#x at $173D6
unk_55BFE = $55BFE		;#x at $16D0E
unk_5C410 = $5C410		;#x at $16CF2
unk_5CF6C = $5CF6C		;#x at $16CE4
unk_A4B5C = $A4B5C		;#x at $16AAC
unk_A78B6 = $A78B6		;#x at $16D00
unk_A9A18 = $A9A18		;#x at $16AE8
unk_AAC5A = $AAC5A		;#x at $16AD2
unk_AB928 = $AB928		;#x at $16A9E
unk_ABA14 = $ABA14		;#x at $16D24
unk_B3538 = $B3538		;#x at $16CB0
unk_B3640 = $B3640		;#x at $1762A
unk_B3648 = $B3648		;#x at $173BE
unk_F3098 = $F3098		;#x at $173F4

; Main segment code
	include	hockey94_06.asm
