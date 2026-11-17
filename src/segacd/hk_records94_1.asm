	include	segacd\hockey.inc
	include	macros\genesis.mac


	org	$BA4A

NameEntryHelp						;Name entry help text ("D-Pad up/down to move arrows.", "Press START to
									;select name.", "Press B to edit.")
	dc.w	$48E7,$FFFE
	dc.w	$4EB9,$0003,$8F6E
	dc.w	$001A,$BF02,$1544,$2D50,$6164,$2075,$702F,$646F,$776E,$2074,$6F20,$2020,$2000
	dc.w	$4EB9,$0003,$8F6E
	dc.w	$001A,$BF02,$166D,$6F76,$6520,$6172,$726F,$7773,$2E20,$2020,$2020,$2020,$2000
	dc.w	$33FC,$0002,$0001,$8D58
	dc.w	$3F39,$0001,$8D58
	dc.w	$0679,$0001,$0001,$8D5A
	dc.w	$4EB9,$0003,$8F6E
	dc.w	$0016,$5072,$6573,$7320,$5354,$4152,$5420,$746F,$2020,$2020,$2020
	dc.w	$0679,$0001,$0001,$8D5A
	dc.w	$33D7,$0001,$8D58
	dc.w	$4EB9,$0003,$8F6E
	dc.w	$0016,$7365,$6C65,$6374,$206E,$616D,$652E,$2020,$2020,$2020,$2020
	dc.w	$0679,$0001,$0001,$8D5A
	dc.w	$33DF,$0001,$8D58
	dc.w	$4EB9,$0003,$8F6E
	dc.w	$0016,$5072,$6573,$7320,$4220,$746F,$2065,$6469,$742E,$2020,$2020
	dc.w	$4CDF,$7FFF
	dc.w	$4E75
PrintNamePrompt						;Name entry: "Enter new name:" for an empty name log slot namelogsel, else
									;"Select or replace:"
	dc.w	$48E7,$FFFE
	dc.w	$3039,$0001,$A38C
	dc.w	$C0FC,$000C
	dc.w	$207C,$0001,$A2FC
	dc.w	$227C,$0002,$6C30
	dc.w	$4A30,$0000
	dc.w	$6700,$0008
	dc.w	$227C,$0002,$6C48
.lBB42	dc.w	$4EB9,$0003,$8F80
	dc.w	$4CDF,$7FFF
	dc.w	$4E75
SyncLetterCursor						;Name entry: the letter grid cursor d5 = the grid index of the current
									;letter (FindLetter), 0 when it is not in the grid
	dc.w	$48E7,$F8FE
	dc.w	$1039,$0001,$A37C
	dc.w	$6100,$0026
	dc.w	$0C40,$001E
	dc.w	$6D00,$0008
	dc.w	$4245
	dc.w	$6000,$0012
.lBB6A	dc.w	$3A00
	dc.w	$207C,$0002,$6DD0
	dc.w	$13F0,$5000,$0001,$A37C
.lBB7A	dc.w	$4CDF,$7F1F
	dc.w	$4E75
FindLetter						;d0 = index of letter d0 in LetterGrid, $1E when not found
	dc.w	$48E7,$70FE
	dc.w	$207C,$0002,$6DD0
	dc.w	$1200
	dc.w	$4240
	dc.w	$363C,$001E
.lBB92	dc.w	$B230,$0000
	dc.w	$6700,$000E
	dc.w	$0640,$0001
	dc.w	$51CB,$FFF2
	dc.w	$303C,$001E
.lBBA6	dc.w	$4CDF,$7F0E
	dc.w	$4E75
PrintNameCursor						;Name entry: the " < " cursor
	dc.w	$4EB9,$0003,$8F6E
	dc.w	$0006,$BF04,$1300
	dc.w	$D979,$0001,$8D58
	dc.w	$4A79,$0001,$A566
	dc.w	$6700,$000E
	dc.w	$4EB9,$0003,$8F6E
	dc.w	$0006,$203C,$2000
	dc.w	$4E75
PrintCurLetter						;Name entry: print grid letter d5 (with the cursor on, cursoron)
	dc.w	$4A79,$0001,$A566
	dc.w	$6700,$FFF6
	dc.w	$227C,$000B,$C000
	dc.w	$32BC,$0004
	dc.w	$137C,$0000,$0003
	dc.w	$207C,$0002,$6DD0
	dc.w	$1030,$5000
	dc.w	$1340,$0002
	dc.w	$4EF9,$0003,$8F80
LetterGridPos						;Name entry: printx / printy of grid letter d5 (6 letters a row, 2 cells
									;apart); d0 / d1 = 3 x 3 box
	dc.w	$4EB9,$0003,$8F6E
	dc.w	$0006,$BF18,$1000
	dc.w	$3005
	dc.w	$48C0
	dc.w	$80FC,$0006
	dc.w	$E340
	dc.w	$D179,$0001,$8D5A
	dc.w	$4840
	dc.w	$E340
	dc.w	$D179,$0001,$8D58
	dc.w	$7003
	dc.w	$7203
	dc.w	$4E75
PrintNameLog						;Name entry: the "Name Log" list (PrintNameField, GetLogName)
	dc.w	$0018,$BF02
	dc.w	$1020
	dc.w	$2045
	dc.w	$6E74
	dc.w	$6572
	dc.w	$206E,$6577
	dc.w	$206E,$616D
	dc.w	$653A
	dc.w	$2000
	dc.w	$0018,$BF02
	dc.w	$1053
	dc.w	$656C
	dc.w	$6563
	dc.w	$7420
	dc.w	$6F72
	dc.w	$2072,$6570,$6C61,$6365
	dc.w	$3A00
	dc.w	$48E7,$FFFE
	dc.w	$3F39,$0001,$A38A
	dc.w	$3F39,$0001,$A38C
	dc.w	$4EB9,$0003,$8F6E
	dc.w	$0006,$BF05,$0800
	dc.w	$3E3C,$0006
.lBC80	dc.w	$33FC,$0001,$0001,$A38C
	dc.w	$227C,$0001,$7E70
.lBC8E	dc.w	$6100,$017E
	dc.w	$3F39,$0001,$8D58
	dc.w	$6100,$00EC
	dc.w	$33DF,$0001,$8D58
	dc.w	$0679,$0001,$0001,$8D5A
	dc.w	$0679,$0001,$0001,$A38C
	dc.w	$51CF,$FFDA
	dc.w	$33DF,$0001,$A38C
.lBCBC	dc.w	$33DF,$0001,$A38A
	dc.w	$4CDF,$7FFF
	dc.w	$4E75
MoveLogArrows						;Name entry: when the name log selection namelogsel changed, erase the old
									;] [ arrows and print them at the new row (PrintLogArrows)
	dc.w	$48E7,$FFFE
	dc.w	$3039,$0001,$A38C
	dc.w	$B079,$0001,$A38E
	dc.w	$6700,$0016
	dc.w	$227C,$0002,$6D4A
	dc.w	$6100,$0012
	dc.w	$227C,$0002,$6D42
	dc.w	$6100,$0008
.lBCF0	dc.w	$4CDF,$7FFF
	dc.w	$4E75
	dc.w	$4A79,$0001,$A38E,$6700,$0038,$4EB9,$0003,$8F6E
	dc.w	$0006,$BF03,$0800,$3039,$0001,$A38E,$0440,$0001
	dc.w	$D179,$0001,$8D5A,$2F09,$4EB9,$0003,$8F80,$225F
	dc.w	$D2D1,$33FC,$0012,$0001,$8D58,$4EB9,$0003,$8F80
	dc.w	$33F9,$0001,$A38C,$0001,$A38E,$4E75,$0004,$5D00
	dc.w	$0004,$5B00,$0004,$2000,$0004,$2000
GetNameLength						;namelength = length of the name being entered
									;(up to '-' or 0, at most 12)
	dc.w	$48E7,$FFFE
	dc.w	$363C,$000B
	dc.w	$207C,$0001,$A37C
	dc.w	$4279,$0001,$A38A
.lBD66	dc.w	$0C10,$002D
	dc.w	$6700,$0014
	dc.w	$4A18
	dc.w	$6700,$000E
	dc.w	$0679,$0001,$0001,$A38A
	dc.w	$51CB,$FFE8
.lBD80	dc.w	$4CDF,$7FFF
	dc.w	$4E75
PrintNameField						;Name entry: print the 12 character name field from a1, '-' past the
									;length namelength
	dc.w	$48E7,$FFFE
	dc.w	$207C,$000B,$C000
	dc.w	$3039,$0001,$A38A
	dc.w	$363C,$0000
	dc.w	$30FC,$000E
.lBD9E	dc.w	$1231,$3000
	dc.w	$B679,$0001,$A38A
	dc.w	$6D00,$0006
	dc.w	$123C,$002D
.lBDB0	dc.w	$10C1
	dc.w	$0643,$0001
	dc.w	$0C43,$000C
	dc.w	$6D00,$FFE2
	dc.w	$227C,$000B,$C000
	dc.w	$4EB9,$0003,$8F80
	dc.w	$4CDF,$7FFF
	dc.w	$4E75
	dc.w	$4142
	dc.w	$4344
	dc.w	$4546
	dc.w	$4748
	dc.w	$494A
	dc.w	$4B4C
	dc.w	$4D4E
	dc.w	$4F50
NameEntryFramer						;Framer with the name entry frame tiles (nameframechars as framercset)
	dc.w	$5152
	dc.w	$5354
	dc.w	$5556
	dc.w	$5758
	dc.w	$595A
	dc.w	$2E31,$3220
	dc.w	$2D00
	dc.w	$3F39,$0001,$8D4E
	dc.w	$33F9,$0001,$A3D2,$0001,$8D4E
	dc.w	$4EB9,$0003,$8CA0
	dc.w	$33DF,$0001,$8D4E
	dc.w	$4E75
GetLogName						;Copy name log entry namelogsel to a1 ('-' for
									;empty), namelength = its length
	dc.w	$48E7,$FFFE
	dc.w	$207C,$0001,$A2FC
	dc.w	$3439,$0001,$A38C
	dc.w	$C4FC,$000C
	dc.w	$33FC,$0000,$0001,$A38A
	dc.w	$363C,$000B
.lBE2E	dc.w	$1030,$2000
	dc.w	$6700,$0006
	dc.w	$6000,$000E
.lBE3A	dc.w	$103C,$002D
	dc.w	$0479,$0001,$0001,$A38A
.lBE46	dc.w	$12C0
	dc.w	$0679,$0001,$0001,$A38A
	dc.w	$0642,$0001
	dc.w	$51CB,$FFD8
	dc.w	$4CDF,$7FFF
	dc.w	$4E75
StoreUserName						;Name entry: store the name in save RAM
									;(WriteNameRecord, MakeSRAMChecksum)
	dc.w	$48E7,$FFFE
	dc.w	$207C,$0001,$A2FC
	dc.w	$3039,$0001,$A38C
	dc.w	$C0FC,$000C
	dc.w	$D0C0
	dc.w	$227C,$0001,$A37C
	dc.w	$383C,$000B
.lBE7E	dc.w	$0C11,$002D
	dc.w	$6600,$0006
	dc.w	$12BC,$0000
.lBE8A	dc.w	$1219
	dc.w	$B218
	dc.w	$6600,$000A
	dc.w	$51CC,$FFEA
	dc.w	$6000,$003C
.lBE9A	dc.w	$207C,$0001,$A2FC
	dc.w	$3039,$0001,$A38C
	dc.w	$C0FC,$000C
	dc.w	$D0C0
	dc.w	$227C,$0001,$A37C
	dc.w	$383C,$000B
.lBEB6	dc.w	$1219
	dc.w	$0C01,$002D
	dc.w	$6600,$0006
	dc.w	$123C,$0000
.lBEC4	dc.w	$10C1
	dc.w	$51CC,$FFEE
	dc.w	$6100,$B756
	dc.w	$4EB9,$0002,$6F06
.lBED4	dc.w	$2A7C,$0001,$8BF4
	dc.w	$4A79,$0001,$A390
	dc.w	$6700,$0008
	dc.w	$2A7C,$0001,$8BF6
.lBEEA	dc.w	$4A39,$0001,$A37C
	dc.w	$6600,$0008
	dc.w	$4279,$0001,$A38C
.lBEFA	dc.w	$3AB9,$0001,$A38C
	dc.w	$4CDF,$7FFF
	dc.w	$4E75
	dc.w	$48E7,$FFFE
	dc.w	$3E3C,$02D7
	dc.w	$203C,$0000,$0000
	dc.w	$223C,$0000,$0004
	dc.w	$207C,$000B,$C000
	dc.w	$3C39,$0001,$A38C
.lBF26	dc.w	$4245
	dc.w	$4EB9,$0002,$2452
	dc.w	$BC28,$0001
	dc.w	$6600,$0008
	dc.w	$4228,$0001
	dc.w	$50C5
.lBF3C	dc.w	$BC28,$0003
	dc.w	$6600,$0008
	dc.w	$4228,$0003
	dc.w	$50C5
.lBF4A	dc.w	$4A45
	dc.w	$6700,$0008
	dc.w	$4EB9,$0002,$246C
.lBF56	dc.w	$0680,$0000,$0004
	dc.w	$51CF,$FFC8
	dc.w	$3E3C,$001B
	dc.w	$203C,$0000,$0B60
	dc.w	$223C,$0000,$0010
	dc.w	$207C,$000B,$C000
	dc.w	$3C39,$0001,$A38C
.lBF7C	dc.w	$4245
	dc.w	$4EB9,$0002,$2452
	dc.w	$BC28,$0001
	dc.w	$6600,$0008
	dc.w	$4228,$0001
	dc.w	$50C5
.lBF92	dc.w	$BC28,$0003
	dc.w	$6600,$0008
	dc.w	$4228,$0003
	dc.w	$50C5
.lBFA0	dc.w	$BC28,$0005
	dc.w	$6600,$0008
	dc.w	$4228,$0005
	dc.w	$50C5
.lBFAE	dc.w	$BC28,$0007
	dc.w	$6600,$0008
	dc.w	$4228,$0007
	dc.w	$50C5
.lBFBC	dc.w	$BC28,$0009
	dc.w	$6600,$0008
	dc.w	$4228,$0009
	dc.w	$50C5
.lBFCA	dc.w	$BC28,$000B
	dc.w	$6600,$0008
	dc.w	$4228,$000B
	dc.w	$50C5
.lBFD8	dc.w	$4A45
	dc.w	$6700,$0008
	dc.w	$4EB9,$0002,$246C
.lBFE4	dc.w	$0680,$0000,$0010
	dc.w	$51CF,$FF90
	dc.w	$203C,$0000,$0D20
	dc.w	$3639,$0001,$A38C
	dc.w	$E943
	dc.w	$48C3
	dc.w	$D083
	dc.w	$223C,$0000,$0010
	dc.w	$207C,$000B,$C000
	dc.w	$4EB9,$0002,$2452
	dc.w	$2F08
	dc.w	$363C,$000F
.lC018	dc.w	$4218
	dc.w	$51CB,$FFFC
	dc.w	$205F
	dc.w	$4EB9,$0002,$246C
	dc.w	$4CDF,$7FFF
	dc.w	$4E75
UserNameEntry						;With user records on (OptUserRec 0): the name entry (NameEntryScreen) for
									;the pads in use. Called from Opening2
	dc.w	$4A79,$0001,$8C06
	dc.w	$6600,$006A
	dc.w	$4279,$0001,$8BF4
	dc.w	$4279,$0001,$8BF6
	dc.w	$4A79,$0001,$7FA6
	dc.w	$6700,$001A
	dc.w	$33F9,$0001,$7FA6,$0001,$A390
	dc.w	$0479,$0001,$0001,$A390
	dc.w	$4EB9,$0002,$6348
.lC064	dc.w	$4A79,$0001,$7FA8
	dc.w	$6700,$0032
	dc.w	$48A7,$8000
	dc.w	$3039,$0001,$7FA6
	dc.w	$B079,$0001,$7FA8
	dc.w	$4C9F,$0001
	dc.w	$6700,$001A
	dc.w	$33F9,$0001,$7FA8,$0001,$A390
	dc.w	$0479,$0001,$0001,$A390
	dc.w	$4EB9,$0002,$6348
.lC09E	dc.w	$4E75
SkipOtherUserName						;Name entry: step the selection namelogsel past the name the other pad
									;picked (homeuser / awayuser), in the direction on the stack
	dc.w	$48A7,$8000
	dc.w	$3039,$0001,$8BF6
	dc.w	$4A79,$0001,$A390
	dc.w	$6700,$0008
	dc.w	$3039,$0001,$8BF4
.lC0BA	dc.w	$B079,$0001,$A38C
	dc.w	$6600,$0018
	dc.w	$303C,$0001
	dc.w	$4A57
	dc.w	$6A00,$0006
	dc.w	$303C,$FFFF
.lC0D2	dc.w	$D179,$0001,$A38C
	dc.w	$4240
.lC0DA	dc.w	$4C9F,$0001
	dc.w	$4E75
RecordHoldersScreen						;"Record Holders" menu item (menu lists): the save RAM record holders
									;(PrintRecordTitles ... ReadTeamRecords)
	dc.w	$303C,$0000
	dc.w	$323C,$001A
	dc.w	$4EB9,$0002,$E728
	dc.w	$4EB9,$0003,$8F6E
	dc.w	$0006,$BE01,$0100
	dc.w	$2079,$0004,$7D80
	dc.w	$2248
	dc.w	$2448
	dc.w	$D1DA
	dc.w	$D3DA
	dc.w	$4241
	dc.w	$4240
	dc.w	$7406
	dc.w	$363C,$0006
	dc.w	$7A08
	dc.w	$4EB9,$0003,$87E2
	dc.w	$4EB9,$0003,$8F6E
	dc.w	$0006,$BE21,$0100
	dc.w	$2079,$0004,$7D84
	dc.w	$2248
	dc.w	$2448
	dc.w	$D1DA
	dc.w	$D3DA
	dc.w	$4241
	dc.w	$4240
	dc.w	$7406
	dc.w	$363C,$0006
	dc.w	$7A00
	dc.w	$4EB9,$0003,$87E2
	dc.w	$4EB9,$0003,$8F6E
	dc.w	$0006,$BD0B,$0100
	dc.w	$303C,$0012
	dc.w	$323C,$0007
	dc.w	$4EB9,$0003,$8CA0
	dc.w	$4EB9,$0003,$9258
	dc.w	$0018
	dc.b	$BD,$0E,$02,$52,$65,$63,$6F,$72,$64,$BD,$0D,$05,$48,$6F,$6C,$64,$65,$72,$73,$BD,$01,$09
	dc.w	$4EB9,$0003,$8D8C,$0010,$F806,$0305,$08F9,$014E
	dc.w	$616D,$65F9,$0000,$6100,$B498,$4279,$0001,$7E62
	dc.w	$08B9,$0006,$0001,$7F76,$6100,$0612,$08F9,$0006
	dc.w	$0001,$7F76,$6100,$0606,$6100,$0500,$6100,$00B6
	dc.w	$6100,$01D8,$4EB9,$0002,$C63A,$4EB9,$0002,$F2F0
	dc.w	$4EB9,$0003,$74BE,$0803,$0007,$6700,$0008,$4EF9
	dc.w	$0002,$E980,$4A79,$0001,$7E62,$6600,$0022,$0803
	dc.w	$0006,$6700,$001A,$0803,$0005,$6700,$0012,$6100
	dc.w	$3406,$6100,$04B6,$6100,$0192,$6000,$FFB8,$0801
	dc.w	$0003,$6700,$0026,$0C79,$0002,$0001,$7E62,$6700
	dc.w	$FFA4,$6100,$028E,$0679,$0001,$0001,$7E62,$6100
	dc.w	$0044,$6100,$0032,$6000,$FF8C,$0801,$0002,$6700
	dc.w	$FF84,$4A79,$0001,$7E62,$6700,$FF7A,$6100,$0264
	dc.w	$0479,$0001,$0001,$7E62,$6100,$001A,$6100,$0008
	dc.w	$6000,$FF62,$4E75,$4A79,$0001,$7E62,$6700,$012C
	dc.w	$6000,$028A
PrintRecordTitles						;Record Holders: the record titles (WinRecTitles, GoalRecTitles,
									;SaveRecTitles)
	dc.w	$227C,$0002,$72A2
	dc.w	$4A79,$0001,$7E62
	dc.w	$6700,$001A
	dc.w	$227C,$0002,$7346
	dc.w	$0C79,$0002,$0001,$7E62
	dc.w	$6700,$0008
	dc.w	$227C,$0002,$72F4
.lC29A	dc.w	$4EB9,$0003,$8D9E
	dc.w	$4E75
	dc.w	$0052,$F806,$0310,$08F9,$0120,$2020,$5769,$6E20
	dc.w	$2520,$2020,$5769,$6E2D,$4C6F,$7373,$2D54,$6965
	dc.w	$FD04,$FC19,$5573,$6520,$412B,$4320,$746F,$2063
	dc.w	$6C65,$6172,$2041,$4C4C,$2077,$696E,$2072,$6563
	dc.w	$6F72,$6473,$FD10,$FC1A,$2020,$4D6F,$7265,$205D
	dc.w	$F900,$0052,$F806,$0312,$08F9,$0147,$6F61,$6C73
	dc.w	$2020,$2020,$2020,$2020,$2054,$6561,$6D73,$2020
	dc.w	$2020,$FD04,$FC19,$2020,$2020,$5445,$414D,$204D
	dc.w	$5553,$5420,$5749,$4E20,$544F,$2051,$5541,$4C49
	dc.w	$4659,$2020,$2020,$FD10,$FC1A,$5B20,$4D6F,$7265
	dc.w	$205D,$F900,$0052,$F806,$0312,$08F9,$0153,$6176
	dc.w	$6573,$2020,$2020,$2020,$2020,$2054,$6561,$6D73
	dc.w	$2020,$2020,$FD04,$FC19,$2020,$2020,$5445,$414D
	dc.w	$204D,$5553,$5420,$5749,$4E20,$544F,$2051,$5541
	dc.w	$4C49,$4659,$2020,$2020,$FD10,$FC1A,$5B20,$4D6F
	dc.w	$7265,$2020,$F900,$48E7,$FFFE,$4EB9,$0003,$8D8C
	dc.w	$000A,$F804,$0202,$0AF9,$0000,$3E3C,$0006,$207C
	dc.w	$0001,$A3E4,$247C,$0001,$A3EC,$2A7C,$000B,$C000
	dc.w	$33FC,$0002,$0001,$8D58,$1018,$4880,$1A32,$0000
	dc.w	$E940,$1835,$000A,$E14C,$1835,$000B,$3F04,$1835
	dc.w	$000C,$E14C,$1835,$000D,$33C4,$0001,$7E9A,$1835
	dc.w	$0008,$E14C,$1835,$0009,$33C4,$0001,$7E9E,$D879
	dc.w	$0001,$7E9A,$9857,$4444,$33C4,$0001,$7E9C,$381F
	dc.w	$4A44,$6700,$007C,$6100,$024C,$33FC,$0013,$0001
	dc.w	$8D58,$3F00,$3005,$323C,$0003,$4EB9,$0003,$919A
	dc.w	$4EB9,$0003,$8D9E,$33FC,$001A,$0001,$8D58,$3039
	dc.w	$0001,$7E9E,$323C,$0004,$4EB9,$0003,$919A,$4EB9
	dc.w	$0003,$8D9E,$33FC,$001F,$0001,$8D58,$3039,$0001
	dc.w	$7E9C,$323C,$0004,$4EB9,$0003,$919A,$4EB9,$0003
	dc.w	$8D9E,$33FC,$0024,$0001,$8D58,$3039,$0001,$7E9A
	dc.w	$323C,$0003,$4EB9,$0003,$919A,$301F,$6000,$0008
	dc.w	$227C,$0002,$7630,$4EB9,$0003,$8D9E,$0679,$0002
	dc.w	$0001,$8D5A,$51CF,$FF1A,$4CDF,$7FFF,$4E75
ClearRecordArea						;Record Holders: erase the record rows ($28 x $12), keeping printx /
									;printy / printm
	dc.w	$48E7,$FFFE
	dc.w	$3F39,$0001,$8D58
	dc.w	$3F39,$0001,$8D5A
	dc.w	$3F39,$0001,$8D5E
	dc.w	$4EB9,$0003,$8D8C
	dc.w	$0008,$F804,$0200,$0A00
	dc.w	$303C,$0028
	dc.w	$323C,$0012
	dc.w	$4EB9,$0003,$8C06
	dc.w	$33DF,$0001,$8D5E
	dc.w	$33DF,$0001,$8D5A
	dc.w	$33DF,$0001,$8D58
	dc.w	$4CDF,$7FFF
	dc.w	$4E75
	dc.w	$48E7,$FFFE
	dc.w	$4EB9,$0003,$8D8C
	dc.w	$000A,$F804,$0202,$0AF9,$0000
	dc.w	$3E3C,$0006
	dc.w	$207C,$0001,$A3D4
	dc.w	$0C79,$0001,$0001,$7E62
	dc.w	$6700,$0008
	dc.w	$207C,$0001,$A3DC
.lC52A	dc.w	$247C,$000B,$C000
	dc.w	$33FC,$0002,$0001,$8D58
	dc.w	$1018
	dc.w	$4880
	dc.w	$E940
	dc.w	$1A32,$0000
	dc.w	$0C79,$0001,$0001,$7E62
	dc.w	$6700,$0006
	dc.w	$1A32,$0004
.lC552	dc.w	$4A05
	dc.w	$6700,$00BC
	dc.w	$6100,$010C
	dc.w	$33FC,$0012,$0001,$8D58
	dc.w	$3F00
	dc.w	$0C79,$0001,$0001,$7E62
	dc.w	$6600,$000A
	dc.w	$1032,$0000
	dc.w	$6000,$0006
.lC57A	dc.w	$1032,$0004
.lC57E	dc.w	$0240,$00FF
	dc.w	$323C,$0003
	dc.w	$4EB9,$0003,$919A
	dc.w	$4EB9,$0003,$8D9E
	dc.w	$301F
	dc.w	$33FC,$0019,$0001,$8D58
	dc.w	$227C,$0002,$7658
	dc.w	$267C,$0001,$7EF2
	dc.w	$6100,$E26E
	dc.w	$3F00
	dc.w	$0C79,$0001,$0001,$7E62
	dc.w	$6600,$000A
	dc.w	$1032,$0001,$6000,$0006,$1032,$0005,$0240,$00FF
	dc.w	$227C,$0001,$7EF2,$6100,$EB0E,$227C,$0002,$765E
	dc.w	$267C,$0001,$7EF2,$4EB9,$0003,$9208,$227C,$0001
	dc.w	$7EF2,$301F,$0C79,$0001,$0001,$7E62,$6600,$000A
	dc.w	$1032,$0002,$6000,$0006,$1032,$0006,$0240,$00FF
	dc.w	$6100,$EAD4,$6000,$0008,$227C,$0002,$7630,$4EB9
	dc.w	$0003,$8D9E,$0679,$0002,$0001,$8D5A,$51CF,$FF08
	dc.w	$4CDF,$7FFF,$4E75,$0028,$2020,$2020,$2020,$2020
	dc.w	$2020,$2020,$2020,$2020,$2020,$2020,$2020,$2020
	dc.w	$2020,$2020,$2020,$2020,$2020,$2020,$2020,$0006
	dc.w	$6279,$2000,$0008,$2076,$732E,$2000,$3F07,$4447
	dc.w	$0647,$0007,$0647,$0030,$227C,$0001,$7EF2,$32BC
	dc.w	$0006,$1347,$0002,$137C,$002E,$0003,$137C,$0020
	dc.w	$0004,$137C,$0000,$0005,$4EB9,$0003,$8D9E,$3E1F
	dc.w	$1428,$FFFF,$4882,$227C,$0001,$7EF2,$08B9,$0007
	dc.w	$0001,$7F76,$6100,$E738,$4EF9,$0003,$8D9E
CalcWinPercents						;Record Holders: for the 8 user record blocks at recordbuf, the win %
									;(winpcts), games (wingames) and ties (winties), then sort the rows
									;(winsort)
	dc.w	$48E7,$FFFE
	dc.w	$207C,$000B,$C000
	dc.w	$227C,$0001,$A3EC
	dc.w	$2C7C,$0001,$A3F4
	dc.w	$2A7C,$0001,$A404
	dc.w	$3E3C,$0007
.lC6D8	dc.w	$1028,$0008
	dc.w	$E148
	dc.w	$1028,$0009
	dc.w	$1228,$000A
	dc.w	$E149
	dc.w	$1228,$000B
	dc.w	$3AC1
	dc.w	$4A41
	dc.w	$6600,$0008
	dc.w	$4240
	dc.w	$6000,$0008
.lC6FA	dc.w	$C0FC,$0064
	dc.w	$80C1
.lC700	dc.w	$12C0
	dc.w	$1CE8,$000C
	dc.w	$1CE8,$000D
	dc.w	$D0FC,$0010
	dc.w	$51CF,$FFC8
	dc.w	$227C,$0001,$A3E4
	dc.w	$2F09
	dc.w	$303C,$0001
	dc.w	$3E3C,$0006
.lC722	dc.w	$12C0
	dc.w	$0640,$0001
	dc.w	$51CF,$FFF8
	dc.w	$2257
	dc.w	$207C,$0001,$A3EC
	dc.w	$2C7C,$0001,$A3F4
	dc.w	$2A7C,$0001,$A404
.lC740	dc.w	$2257
	dc.w	$3E3C,$0005
	dc.w	$4246
.lC748	dc.w	$1219
	dc.w	$4881
	dc.w	$1411
	dc.w	$4882
	dc.w	$1030,$1000
	dc.w	$1630,$2000
	dc.w	$B003
	dc.w	$6E00,$004C
	dc.w	$6D00,$003A
	dc.w	$48E7,$7000
	dc.w	$D241
	dc.w	$D442
	dc.w	$3036,$1000
	dc.w	$3636,$2000
	dc.w	$B043
	dc.w	$4CDF,$000E
	dc.w	$6E00,$002E
	dc.w	$6D00,$001C
	dc.w	$48E7,$7000
	dc.w	$D241
	dc.w	$D442
	dc.w	$3035,$1000
	dc.w	$3635,$2000
	dc.w	$B043
	dc.w	$4CDF,$000E
	dc.w	$6C00,$0010
.lC79A	dc.w	$1011
	dc.w	$1229,$FFFF
	dc.w	$1340,$FFFF
	dc.w	$1281
	dc.w	$50C6
.lC7A8	dc.w	$51CF,$FF9E
	dc.w	$4A46
	dc.w	$6600,$FF90
	dc.w	$225F
	dc.w	$4CDF,$7FFF
	dc.w	$4E75
ReadTeamRecords						;Record Holders: read the records (ReadSRAM)
	dc.w	$48E7,$FFFE
	dc.w	$203C,$0000,$0D20
	dc.w	$223C,$0000,$0080
	dc.w	$207C,$000B,$C000
	dc.w	$4EB9,$0002,$2452
	dc.w	$227C,$0001,$A3D4
	dc.w	$0839,$0006,$0001,$7F76
	dc.w	$6700,$0008
	dc.w	$227C,$0001,$A3DC
.lC7EE	dc.w	$2F09
	dc.w	$303C,$0001
	dc.w	$3E3C,$0006
.lC7F8	dc.w	$12C0
	dc.w	$0640,$0001
	dc.w	$51CF,$FFF8
	dc.w	$2257
	dc.w	$207C,$000B,$C000
.lC80A	dc.w	$2257
	dc.w	$3E3C,$0005
	dc.w	$4246
.lC812	dc.w	$1219
	dc.w	$4881
	dc.w	$1411
	dc.w	$4882
	dc.w	$E941
	dc.w	$E942
	dc.w	$1030,$1000
	dc.w	$1630,$2000
	dc.w	$0839,$0006,$0001,$7F76
	dc.w	$6700,$000A
	dc.w	$1030,$1004
	dc.w	$1630,$2004
.lC83A	dc.w	$B003
	dc.w	$6C00,$0010
	dc.w	$1011
	dc.w	$1229,$FFFF
	dc.w	$1340,$FFFF
	dc.w	$1281
	dc.w	$50C6
.lC84E	dc.w	$51CF,$FFC2
	dc.w	$4A46
	dc.w	$6600,$FFB4
	dc.w	$225F
	dc.w	$4CDF,$7FFF
	dc.w	$4E75
ShootoutModeBox
	dc.w	$48E7,$FFFE
	dc.w	$303C,$FFFF
	dc.w	$4EB9,$0003,$9D96
	dc.w	$4EB9,$0003,$8F6E
	dc.w	$0006,$BF03,$0200
	dc.w	$701B
	dc.w	$720C
	dc.w	$4EB9,$0003,$8CA0
	dc.w	$43FA,$013E
	dc.w	$4EB9,$0003,$926A
	dc.w	$3039,$0001,$936C
	dc.w	$247C,$0001,$834C
	dc.w	$4A79,$0001,$9366
	dc.w	$6700,$0008
	dc.w	$247C,$0001,$86B2
.lC8AA	dc.w	$4EB9,$0004,$1192
	dc.w	$3F39,$0001,$8D58
	dc.w	$4EB9,$0003,$8F80
	dc.w	$33DF,$0001,$8D58
	dc.w	$0679,$0001,$0001,$8D5A
	dc.w	$0679,$0006,$0001,$8D58
	dc.w	$4EB9,$0003,$8F6E
	dc.w	$000A,$2076,$732E,$BF04,$0700
	dc.w	$3039,$0001,$936A,$EF40,$247C,$0001,$7480,$D4C0
	dc.w	$4240,$102A,$0066,$247C,$0001,$86B2,$4A79,$0001
	dc.w	$9366,$6700,$0008,$247C,$0001,$834C,$4EB9,$0004
	dc.w	$1192,$4EB9,$0003,$8F80,$4EB9,$0003,$8F6E,$0006
	dc.w	$BF04,$0900,$227C,$0001,$834C,$2269,$001E,$D2E9
	dc.w	$0004,$4EB9,$0003,$8F80,$33FC,$0015,$0001,$8D58
	dc.w	$3039,$0001,$A416,$323C,$0003,$4EB9,$0003,$919A
	dc.w	$4EB9,$0003,$8F80,$4EB9,$0003,$8F6E,$0006,$BF04
	dc.w	$0A00,$227C,$0001,$86B2,$2269,$001E,$D2E9,$0004
	dc.w	$4EB9,$0003,$8F80,$33FC,$0015,$0001,$8D58,$3039
	dc.w	$0001,$A418,$323C,$0003,$4EB9,$0003,$919A,$4EB9
	dc.w	$0003,$8F80,$4EB9,$0003,$8F6E,$000A,$BF04,$0C52
	dc.w	$6F75,$6E64,$2000,$3039,$0001,$A41A,$323C,$0002
	dc.w	$4EB9,$0003,$919A,$4EB9,$0003,$8F80,$4CDF,$7FFF
	dc.w	$4E75,$0016,$BF04,$0353,$484F,$4F54,$4F55,$5420
	dc.w	$4D4F,$4445,$BF04,$0500
ClearShootout
	dc.w	$207C,$0001,$7480
	dc.w	$303C,$03FF
.lC9E4	dc.w	$4258
	dc.w	$51C8,$FFFC
	dc.w	$4279,$0001,$AD72
	dc.w	$33FC,$0001,$0001,$A41A
	dc.w	$08B9,$0003,$0001,$7F78
	dc.w	$4279,$0001,$A416
	dc.w	$4279,$0001,$A418
	dc.w	$4279,$0001,$A428
	dc.w	$4279,$0001,$A436
	dc.w	$6100,$00F0
	dc.w	$33FC,$0001,$0001,$A436
	dc.w	$6100,$00E4
	dc.w	$4279,$0001,$A436
	dc.w	$4E75
