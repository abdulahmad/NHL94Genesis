; ---------- ram names -------------
M68K_RAM equ $FFFF0000
sramcleared equ $FFFF1FFE	;IDA: byte_FF1FFE
;$FFFF55BF: IDA word_FF55BF, not used
replayend equ $FFFFAF54	;no IDA label. 93 name: end of the replay frames ($62 bytes each from M68K_RAM); suba4, adda43 and the record step wrap here
;$FFFFAFCA is SortCords-SCstruct (IDA unk_FFAFCA)
VSCRLPM equ $FFFFB000
VSPRITES equ $FFFFB002
VmMap1 equ $FFFFB004
Map1col1 equ $FFFFB006
VmMap2 equ $FFFFB008
Map2col1 equ $FFFFB00A
VmMap3 equ $FFFFB00C
Map3col1 equ $FFFFB00E
BigFontChars equ $FFFFB010	;IDA: word_FFB010
smallfontchars equ $FFFFB012	;IDA: word_FFB012
smallfont2chars equ $FFFFB014	;IDA: word_FFB014
energybarchars equ $FFFFB016	;IDA: word_FFB016
rinkvrcset equ $FFFFB018
gamesetuptilesetindex equ $FFFFB01A	;IDA: word_FFB01A. 93 name; 94 keeps the crowd tiles 1st vram char here
faceoffvrcset equ $FFFFB01C	;IDA: word_FFB01C
framercset equ $FFFFB01E
EASNcset equ $FFFFB020	;IDA: word_FFB020
basetileoffset equ $FFFFB022	;IDA: word_FFB022
spritechars equ $FFFFB024	;IDA: word_FFB024
ExtraChars equ $FFFFB026
printx equ $FFFFB028
printy equ $FFFFB02A
printa equ $FFFFB02C
printm equ $FFFFB02E
printfontset equ $FFFFB030	;IDA: word_FFB030
fodropx equ $FFFFB032
fodropy equ $FFFFB034
recbpr equ $FFFFB036
vbint equ $FFFFB03A
vcount equ $FFFFB03E
oldvcount equ $FFFFB040
repeatdelayframes equ $FFFFB042	;IDA: word_FFB042
asv equ $FFFFB044
lldisp equ $FFFFB046
periodendtime equ $FFFFB048	;IDA: word_FFB048
SortCords equ $FFFFB04A
;$FFFFB066 is SortCords+OldXpos (IDA word_FFB066)
;$FFFFB366 is SortCords+(6*SCstruct)+OldXpos (IDA word_FFB366)
;$FFFFB5CA is SortCords+(11*SCstruct) (no IDA label), the away goalie SCstruct
;$FFFFB64A is SortCords+(12*SCstruct) (IDA unk_FFB64A)
;$FFFFB6CA is SortCords+(13*SCstruct) (IDA unk_FFB6CA)
puckx equ $FFFFB74A
;$FFFFB74E is SortCords+(puckscnum*SCstruct)+attribute (IDA word_FFB74E)
pucky equ $FFFFB75E
puckz equ $FFFFB762
puckvx equ $FFFFB772
puckvy equ $FFFFB774
puckvz equ $FFFFB776
;$FFFFB78A is SortCords+(puckscnum*SCstruct)+temp1 (IDA word_FFB78A)
puckx_nopuck equ $FFFFB7A8
puckc equ $FFFFB7AA
;$FFFFB7AC is SortCords+(puckscnum*SCstruct)+pflags (IDA byte_FFB7AC)
puck_pflags2 equ $FFFFB7AD
;$FFFFB7CA is SortCords+((puckscnum+1)*SCstruct) (IDA unk_FFB7CA)
;$FFFFB7E2 is SortCords+((puckscnum+1)*SCstruct)+Zpos (IDA unk_FFB7E2)
;$FFFFB7E3 is SortCords+((puckscnum+1)*SCstruct)+Zpos+1 (IDA byte_FFB7E3)
Ylist equ $FFFFB84A
OOlistpos equ $FFFFB86A
OOlist equ $FFFFB88A
crowdframe equ $FFFFB89A
crowdlevel equ $FFFFB89C
crowdstep equ $FFFFB89E
crowdcnt equ $FFFFB8A0
CwdExciteLvl equ $FFFFB8A2
MaxCwdExciteLvl equ $FFFFB8A4
NumCwdExciteLvl equ $FFFFB8A6
SumCwdExciteLvl equ $FFFFB8A8
zamx equ $FFFFB8AC
playoffspritex equ $FFFFB8AE	;IDA: word_FFB8AE
playoffspritey equ $FFFFB8B0	;IDA: word_FFB8B0
clampcounter equ $FFFFB8B2	;IDA: word_FFB8B2
DMAList equ $FFFFB8B4
DMAlistend equ $FFFFBD14
Vpos equ $FFFFBD18
Oldrow equ $FFFFBD1A
Hpos equ $FFFFBD1C
Hscroll equ $FFFFBD1E
Vscroll equ $FFFFBD20
wcradiusx equ $FFFFBD22
wcradiusy equ $FFFFBD24
palcount equ $FFFFBD26
palfadenew equ $FFFFBD28
;$FFFFBD36 is palfadenew+$E (IDA word_FFBD36)
;$FFFFBD4A is palfadenew+$22 (IDA dword_FFBD4A)
;$FFFFBD4E is palfadenew+$26 (IDA dword_FFBD4E)
;$FFFFBD52 is palfadenew+$2A (IDA word_FFBD52)
;$FFFFBD68 is palfadenew+$40 (IDA CardPalette). IDA: unk_FFBD68
;$FFFFBD6A is palfadenew+$42 (IDA word_FFBD6A)
;$FFFFBD82 is palfadenew+$5A (IDA word_FFBD82)
;$FFFFBD88 is palfadenew+$60 (no IDA label)
;$FFFFBDA2 is palfadenew+$7A (IDA word_FFBDA2)
fofdata2 equ $FFFFBDA8	;IDA: dword_FFBDA8
;$FFFFBDAC is fofdata2+4 (IDA word_FFBDAC)
fofdata equ $FFFFBDB0	;IDA: word_FFBDB0
pads equ $FFFFBDB4
Joy1Struct equ $FFFFBDD0
ReplayStarStruct equ $FFFFBE08
replayactive equ $FFFFBE1E	;IDA: byte_FFBE1E
Joy3Struct equ $FFFFBE24
Joy4Struct equ $FFFFBE40
glovestruct equ $FFFFBE5C
PadControlBits equ $FFFFBE78	;IDA: word_FFBE78
padcont equ $FFFFBE7A
;$FFFFBE7E is padcont+4 (IDA dword_FFBE7E)
;$FFFFBE82 is padcont+8 (IDA dword_FFBE82)
PadControlBits34 equ $FFFFBE86	;IDA: word_FFBE86. as PadControlBits, for pads 3 and 4 (4 way play)
sso equ $FFFFBE88
shotplayer equ $FFFFBED8
lastplayer equ $FFFFBEDA
passdir equ $FFFFBEDC
passspeed equ $FFFFBEDE
passplayer equ $FFFFBEE0
glovecords equ $FFFFBEE2
threat equ $FFFFBEE4
puckcross equ $FFFFBEE6
puckcross2 equ $FFFFBEE8
puckcross4 equ $FFFFBEEA
puckcross6 equ $FFFFBEEC
lj1 equ $FFFFBEEE
lj2 equ $FFFFBEF0
lj3 equ $FFFFBEF2
lj4 equ $FFFFBEF4
pad4way1 equ $FFFFBEF6	;IDA: byte_FFBEF6
pad4way2 equ $FFFFBEF7	;IDA: byte_FFBEF7
pad4way3 equ $FFFFBEF8	;IDA: byte_FFBEF8
pad4way4 equ $FFFFBEF9	;IDA: byte_FFBEF9
pad4wayword equ $FFFFBEFA	;no IDA label. the pad word the unused Read4WayPad1-4 (high94_1) swap a pad's saved word into around ReadJoy1
pad4waysave1 equ $FFFFBEFE	;no IDA label. Read4WayPad1 saved pad word
pad4waysave2 equ $FFFFBF00	;no IDA label. Read4WayPad2 saved pad word
pad4waysave3 equ $FFFFBF02	;no IDA label. Read4WayPad3 saved pad word
pad4waysave4 equ $FFFFBF04	;no IDA label. Read4WayPad4 saved pad word
bholdtimer equ $FFFFBF06	;IDA: word_FFBF06. B button hold timers of pads 1 / 2 (one byte each); bholdtimer34 for pads 3 / 4
bholdtimer34 equ $FFFFBF08	;IDA: word_FFBF08
padword3 equ $FFFFBF0A	;IDA: word_FFBF0A
padword4 equ $FFFFBF0C	;IDA: word_FFBF0C
padword1 equ $FFFFBF0E	;IDA: word_FFBF0E. a pad 1 word swapped with padword3 for 4 way play (updateplayers)
padword2 equ $FFFFBF10	;IDA: word_FFBF10. a pad 2 word swapped with padword4 for 4 way play (updateplayers)
TempWord1 equ $FFFFBF12	;IDA: word_FFBF12. a scratch word (hot / cold totals, record page, button direction ...)
TempWord2 equ $FFFFBF14	;IDA: word_FFBF14. a scratch word (hot / cold totals, attribute number, credits step ...)
TempRawSpd equ $FFFFBF16
TempMaxSpd equ $FFFFBF18
TempEnergySpd equ $FFFFBF1C
TempLegSpd equ $FFFFBF1E
TempBuffer equ $FFFFBF20	;no IDA label. 40 byte scratch buffer: String buffer (AppendNumber, names, "(played by NAME)"), hot / cold player, sum byte pairs
;$FFFFBF2A is TempBuffer+10 (no IDA label), the 6th (coldest) SortHotColdStarters pair
scorergoalies equ $FFFFBF48	;IDA: word_FFBF48
recties equ $FFFFBF4A	;IDA: word_FFBF4A
reclosses equ $FFFFBF4C	;IDA: word_FFBF4C
recwins equ $FFFFBF4E	;IDA: word_FFBF4E
awayhotter equ $FFFFBF50	;IDA: word_FFBF50
setupfontchars equ $FFFFBF52	;IDA: word_FFBF52
awayhotidx equ $FFFFBF54	;IDA: word_FFBF54
homehotidx equ $FFFFBF56	;IDA: word_FFBF56
awaycoldidx equ $FFFFBF58	;IDA: word_FFBF58
homecoldidx equ $FFFFBF5A	;IDA: word_FFBF5A
awayhotplayer equ $FFFFBF5C	;no IDA label. the away team's hottest starter (BuildHotColdLists)
homehotplayer equ $FFFFBF5E	;no IDA label. the home team's hottest starter
awaycoldplayer equ $FFFFBF60	;no IDA label. the away team's coldest starter
homecoldplayer equ $FFFFBF62	;no IDA label. the home team's coldest starter
ChkBodyG equ $FFFFBF64
ChkBodySqG equ $FFFFBF66
NegChkBodyG equ $FFFFBF6A
onetimerplayer equ $FFFFBF6C
onetimerclock equ $FFFFBF6E	;IDA: word_FFBF6E
onetimerflags equ $FFFFBF76	;IDA: word_FFBF76
disflags equ $FFFFBF78
ltplayer equ $FFFFBF7A
ltx equ $FFFFBF7C
lty equ $FFFFBF7E
iflags equ $FFFFBF80
icingPlayer equ $FFFFBF81
clockram equ $FFFFBF86	;IDA: word_FFBF86
;$FFFFBF8C is clockram+6 (IDA clockramend). IDA: unk_FFBF8C
xc1 equ $FFFFBF8E
yc1 equ $FFFFBF90
yleader equ $FFFFBF92
fox equ $FFFFBF94
foy equ $FFFFBF96
fodir1 equ $FFFFBF98
fodir2 equ $FFFFBF9A
deltax equ $FFFFBF9C
deltay equ $FFFFBF9E
collflag equ $FFFFBFA0
evalue equ $FFFFBFA2
mesarea equ $FFFFBFA4
TextBuffer equ $FFFFBFA6	;IDA: word_FFBFA6
;$FFFFBFC2 is mesarea+30 (IDA unk_FFBFC2)
PushWidthBuf equ $FFFFC008	;IDA: unk_FFC008
;$FFFFC00A is PushWidthBuf+2 (IDA unk_FFC00A)
PushNumberBuf equ $FFFFC010	;IDA: unk_FFC010
redrawicons equ $FFFFC012	;IDA: byte_FFC012
ltack equ $FFFFC014
lastsfx equ $FFFFC016
Satt equ $FFFFC018
Sattsize equ $FFFFC2E8	;IDA: word_FFC2E8
gmode equ $FFFFC2EA
sflags equ $FFFFC2EC
sflags2 equ $FFFFC2EE
sflags3 equ $FFFFC2F0
BA_PS_flags equ $FFFFC2F2
sflags4 equ $FFFFC2F4	;IDA: word_FFC2F4. 94 flag word: reverse angle replay (bits 4, 6, 7), slot, penalty shot goal ...
sflags5 equ $FFFFC2F6	;IDA: word_FFC2F6. 94 flag word: crowd noise on (bit 7), menu handler keeps its screen (bit 1), setup scroll (bit 2) ...
sflags6 equ $FFFFC2F8	;IDA: word_FFC2F8. 94 flag word: one-timer (bits 1, 2), slot (bit 5), save RAM write (bit 6), record value (bit 7) ...
gmode2 equ $FFFFC2FA	;IDA: word_FFC2FA. 94 game mode word, beside gmode: shootout (bit 0), shootout skater has the puck (bit 1), breakaway (bit 4) ...
sflags7 equ $FFFFC2FC	;IDA: byte_FFC2FC. 94 flag byte: arena faceoff animation (bit 0), injury (bit 5), crowd meter broken (bit 6) ...
sflags8 equ $FFFFC2FE	;IDA: byte_FFC2FE. 94 flag byte: penalty shot / shootout and one-timer bits
DelayedPen equ $FFFFC300
crowdnoisedelay equ $FFFFC304	;IDA: word_FFC304
CwdChkCntr equ $FFFFC306
CwdChkCnt equ $FFFFC308
CurCrowdMeter equ $FFFFC30E
CrowdRecord equ $FFFFC310
CrowdAvg equ $FFFFC312
CrowdPeak equ $FFFFC314
pausepad equ $FFFFC316	;IDA: word_FFC316
joypuckcarrier equ $FFFFC318
msgtimer equ $FFFFC31A	;IDA: word_FFC31A
passmodetimer equ $FFFFC31C	;IDA: word_FFC31C
savednewpnum equ $FFFFC31E	;IDA: byte_FFC31E
c1playernum equ $FFFFC320
c2playernum equ $FFFFC322
c3playernum equ $FFFFC324
c4playernum equ $FFFFC326
cont1team equ $FFFFC328
cont2team equ $FFFFC32A
cont3team equ $FFFFC32C
cont4team equ $FFFFC32E
HomeTeam equ $FFFFC330
VisTeam equ $FFFFC332
TeamBlockMap equ $FFFFC334	;IDA: unk_FFC334. Map word buffer for CopyTeamBlockMapData and PrintTeamData (93 unk_FFC210)
PenBuf equ $FFFFC3A4
Pencntdwn equ $FFFFC3E6
Penaltytimer equ $FFFFC3E8
PBnum equ $FFFFC3EA
InjCntDown equ $FFFFC3EC
penmsgtimer equ $FFFFC3EE	;IDA: word_FFC3EE
RefCnt equ $FFFFC3F0
RefStep equ $FFFFC3F2
RefPen equ $FFFFC3F4
RefRamMap equ $FFFFC3F6
gsp equ $FFFFC466
gameclock equ $FFFFC468
;$FFFFC46A is gameclock+2 (IDA word_FFC46A)
PerTimeTotal equ $FFFFC46C
ChkCnt equ $FFFFC46E
TempPlOffset equ $FFFFC470
ScoreSumbytes equ $FFFFC472
ScoreSum equ $FFFFC474
PenSumLength equ $FFFFC5DC
PenSum equ $FFFFC5DE
HmShots equ $FFFFC6CE
HmGoals equ $FFFFC6DA
;$FFFFC6E4 is HmShots+tmline (IDA word_FFC6E4)
HomeTeamRosterPtr equ $FFFFC6EC	;IDA: dword_FFC6EC
;$FFFFC6F4 is HmShots+tmgoalie (IDA word_FFC6F4)
;$FFFFC6FE is HmShots+tmflags (IDA byte_FFC6FE)
;$FFFFC768 is HmShots+tmpdst+$34 (IDA byte_FFC768)
AwShots equ $FFFFCA32
AwGoals equ $FFFFCA3E
;$FFFFCA48 is AwShots+tmline (IDA word_FFCA48)
AwayTeamRosterPtr equ $FFFFCA50	;IDA: dword_FFCA50
;$FFFFCA58 is AwShots+tmgoalie (IDA word_FFCA58)
;$FFFFCA62 is AwShots+tmflags (IDA byte_FFCA62)
;$FFFFCACC is AwShots+tmpdst+$34 (IDA byte_FFCACC)
statsbuffer equ $FFFFCD96	;IDA: unk_FFCD96
gsstruct equ $FFFFCE66
;$FFFFCED6 is gsstruct+(7*$10) (IDA unk_FFCED6)
gamenum equ $FFFFCEE6
postarts equ $FFFFCEE8
bosgames equ $FFFFCEEA
gamelevel equ $FFFFCEEC
potreeteam equ $FFFFCEEE
pojoy equ $FFFFCEF0
WinBits equ $FFFFCEF2	;IDA: word_FFCEF2
potree equ $FFFFCEF4	;IDA: unk_FFCEF4
PlList equ $FFFFCF14
menuitem equ $FFFFCF20	;IDA: dword_FFCF20. menu state: selected item, then (+2) first item shown (93 dword_FFC9B4)
menulist equ $FFFFCF24	;IDA: dword_FFCF24
menudraw equ $FFFFCF28	;IDA: dword_FFCF28
TickerNum equ $FFFFCF2C
PPBonus equ $FFFFCF2E
PKBonus equ $FFFFCF2F
ThirdPBonus equ $FFFFCF30
HmAwBonus equ $FFFFCF31
callbackPtr equ $FFFFCF32	;IDA: dword_FFCF32
ThreeStars equ $FFFFCF36
;$FFFFCF38 is ThreeStars+2 (no IDA label), the text after a String length word at ThreeStars
teamrecbuf equ $FFFFCFFE	;no IDA label. SRAM team record buffer: the 16 byte record of a team (clrCrowdRAM), byte 8 crowd record, byte 9 its name number
nibblebuffer equ $FFFFD036	;IDA: dword_FFD036
;$FFFFD03A is nibblebuffer+4 (IDA dword_FFD03A)
homeuser equ $FFFFD042	;IDA: word_FFD042
awayuser equ $FFFFD044	;IDA: word_FFD044
FourWayPlay equ $FFFFD046
OptPlayMode equ $FFFFD048
OptNOP equ $FFFFD04A
Opt1Team equ $FFFFD04C
Opt2Team equ $FFFFD04E
OptPerlen equ $FFFFD050
OptGoalie equ $FFFFD052
OptUserRec equ $FFFFD054
OptPen equ $FFFFD056
OptLine equ $FFFFD058
goaliemode1 equ $FFFFD05A	;IDA: word_FFD05A
goaliemode2 equ $FFFFD05C	;IDA: word_FFD05C
TmpOptUserRec equ $FFFFD05E
TmpOptPen equ $FFFFD060
TmpOptLine equ $FFFFD062
demoflag equ $FFFFD064
RNGseed equ $FFFFD066
dmaram equ $FFFFD06A
music_global_tick_counter equ $FFFFD06E	;IDA: word_FFD06E
music_tick_divider equ $FFFFD070	;IDA: word_FFD070
TmpOptLine2 equ $FFFFD072
TempOptPlayMode equ $FFFFD074
databuffer equ $FFFFD076	;IDA: unk_FFD076
pwddatabuffer equ $FFFFD088	;IDA: unk_FFD088
outputbuffer equ $FFFFD092	;IDA: unk_FFD092
tpassbits equ $FFFFD176	;IDA: unk_FFD176
music_needs_z80_update equ $FFFFD180	;IDA: byte_FFD180
Z80_command_buffer equ $FFFFD182	;IDA: dword_FFD182
;$FFFFD186 is Z80_command_buffer+4 (IDA byte_FFD186)
per_channel_attenuation_table equ $FFFFD187	;IDA: unk_FFD187
per_channel_frequency_table equ $FFFFD18E	;IDA: unk_FFD18E
per_channel_patch_table equ $FFFFD19C	;IDA: unk_FFD19C
fm_voice_usage_table equ $FFFFD1A4	;IDA: unk_FFD1A4
fm_channel_structs equ $FFFFD3A4	;IDA: unk_FFD3A4
fm_channel_struct6 equ $FFFFD3CC	;IDA: unk_FFD3CC
fm_track_slots equ $FFFFD3D4	;IDA: unk_FFD3D4
BA_Team equ $FFFFD404
BA_Sktr_SCnum equ $FFFFD406
BA_Goalie_SCnum equ $FFFFD408
BA_Skater_Offset equ $FFFFD40A
BA_Goalie_Offset equ $FFFFD40C
BA_Checker_Offset equ $FFFFD40E
pspenalty equ $FFFFD410	;IDA: word_FFD410
holdreset equ $FFFFD412	;IDA: word_FFD412
onetimertargetx equ $FFFFD414	;IDA: word_FFD414
onetimertargety equ $FFFFD416	;IDA: word_FFD416
onetimerheight equ $FFFFD418	;IDA: word_FFD418
FallYPos equ $FFFFD41A
FallXPos equ $FFFFD41C
aholdtimer equ $FFFFD41E	;IDA: word_FFD41E. A button hold timers of pads 1 / 2 (one byte each); aholdtimer34 for pads 3 / 4
aholdtimer34 equ $FFFFD420	;IDA: word_FFD420
setupfirstline equ $FFFFD422	;IDA: word_FFD422
setupprevline equ $FFFFD424	;IDA: word_FFD424
setupmenuchars equ $FFFFD426	;IDA: word_FFD426
logoteam equ $FFFFD428	;IDA: word_FFD428
setuphome equ $FFFFD42A	;IDA: word_FFD42A
setupvis equ $FFFFD42C	;IDA: word_FFD42C
setupcardflags equ $FFFFD42E	;IDA: word_FFD42E
homepicchars equ $FFFFD430	;IDA: word_FFD430
vispicchars equ $FFFFD432	;IDA: word_FFD432
cardroster equ $FFFFD434	;IDA: word_FFD434
logobox1chars equ $FFFFD436	;IDA: word_FFD436
logobox2chars equ $FFFFD438	;IDA: word_FFD438
teambitmapchars equ $FFFFD43A	;IDA: word_FFD43A
cardtimer equ $FFFFD43C	;IDA: word_FFD43C
featuredplayer equ $FFFFD43E	;IDA: word_FFD43E
carddelay equ $FFFFD440	;IDA: word_FFD440
cardprintx equ $FFFFD442	;IDA: word_FFD442
cardprinty equ $FFFFD444	;IDA: word_FFD444
cardteamnum equ $FFFFD446	;IDA: word_FFD446
homegoalies equ $FFFFD448	;IDA: word_FFD448
awaygoalies equ $FFFFD44A	;IDA: word_FFD44A
homeplayers equ $FFFFD44C	;IDA: word_FFD44C
awayplayers equ $FFFFD44E	;IDA: word_FFD44E
cardlogochars1 equ $FFFFD450	;IDA: word_FFD450
cardlogochars2 equ $FFFFD452	;IDA: word_FFD452
shootoutclock equ $FFFFD454	;IDA: word_FFD454
shootoutjiffy equ $FFFFD456	;IDA: word_FFD456
ValidSRAM equ $FFFFD458
namelog equ $FFFFD45A	;no IDA label. the user name log: $80 bytes from save RAM $DA0 (NameLogIO), 12 bytes per name, namelogsel the entry
nameentrybuf equ $FFFFD4DA	;IDA: word_FFD4DA
;$FFFFD4DC is nameentrybuf+2 (no IDA label), the text after its length word
namelength equ $FFFFD4E8	;IDA: word_FFD4E8
namelogsel equ $FFFFD4EA	;IDA: word_FFD4EA
namelogarrows equ $FFFFD4EC	;IDA: word_FFD4EC
nameentryvis equ $FFFFD4EE	;IDA: word_FFD4EE
homecardidx equ $FFFFD4F0	;IDA: word_FFD4F0
awaycardidx equ $FFFFD4F2	;IDA: word_FFD4F2
cardindex equ $FFFFD4F4	;IDA: word_FFD4F4
cardvis equ $FFFFD4F6	;IDA: word_FFD4F6
cardcount equ $FFFFD4F8	;IDA: word_FFD4F8
homecardlist equ $FFFFD4FA	;no IDA label. the home player card order (BuildCardPlayerLists), read by GetCardPlayer
awaycardlist equ $FFFFD514	;no IDA label. the away player card order
cardplayer equ $FFFFD52E	;IDA: word_FFD52E
nameframechars equ $FFFFD530	;IDA: word_FFD530
recsort1 equ $FFFFD532	;no IDA label. Record Holders row order sorted on record byte 0 (ReadTeamRecords), read by PrintPlayerRecords
recsort2 equ $FFFFD53A	;no IDA label. Record Holders row order sorted on record byte 4 (ReadTeamRecords, sflags6 bit 6)
winsort equ $FFFFD542	;no IDA label. Record Holders win row order (CalcWinPercents), read by PrintWinRecords
winpcts equ $FFFFD54A	;no IDA label. the win % byte of each of the 8 records (CalcWinPercents)
winties equ $FFFFD552	;no IDA label. the ties word of each record (record bytes $C-$D)
wingames equ $FFFFD562	;no IDA label. the games word of each record (record bytes $A-$B)
shootoutstate equ $FFFFD572	;no IDA label. first of the 19 words ClearGameStats clears ($FFD572-$FFD597: shootout goals, playoffround, shooter lists ...)
homeshootgoals equ $FFFFD574	;IDA: word_FFD574
awayshootgoals equ $FFFFD576	;IDA: word_FFD576
playoffround equ $FFFFD578	;IDA: word_FFD578
homeshooters equ $FFFFD57A	;no IDA label. the home shootout shooter list (6 words, homeshootnum the index)
;$FFFFD585 is homeshootnum-1 (IDA byte_FFD585)
homeshootnum equ $FFFFD586	;IDA: word_FFD586
awayshooters equ $FFFFD588	;no IDA label. the away shootout shooter list (6 words)
;$FFFFD593 is shootoutteam-1 (IDA byte_FFD593)
shootoutteam equ $FFFFD594	;IDA: word_FFD594
matchup equ $FFFFD598	;IDA: word_FFD598
scoutunused equ $FFFFD59A	;IDA: word_FFD59A. cleared by ScoutingReport, never read
matchuphome equ $FFFFD59C	;IDA: word_FFD59C
matchupvis equ $FFFFD59E	;IDA: word_FFD59E. the visitors player of the matchup; also the scroll limit of GameStatisticsScreen
homerating equ $FFFFD5A0	;IDA: word_FFD5A0
visrating equ $FFFFD5A2	;IDA: word_FFD5A2
advframe equ $FFFFD5A4	;IDA: word_FFD5A4
advcount equ $FFFFD5A6	;IDA: word_FFD5A6
matchuptimer equ $FFFFD5A8	;IDA: word_FFD5A8
matchupslot equ $FFFFD5AA	;IDA: word_FFD5AA
DispAttribCtr equ $FFFFD5AC
VertLineScrolling equ $FFFFD5AE
PlayerScrollCtr equ $FFFFD5B0
SelectedPlayerIdx equ $FFFFD5B2	;IDA: word_FFD5B2
typedelay equ $FFFFD5B4	;IDA: word_FFD5B4
screentimer equ $FFFFD5B6	;IDA: word_FFD5B6
TestList equ $FFFFD5B8	;IDA: word_FFD5B8
arenaanimchars equ $FFFFD6AC	;IDA: word_FFD6AC
arenaframe equ $FFFFD6AE	;IDA: word_FFD6AE
arenaframeidx equ $FFFFD6B0	;IDA: word_FFD6B0
arenaframetime equ $FFFFD6B2	;IDA: word_FFD6B2
arenaanim equ $FFFFD6B4	;IDA: word_FFD6B4
arenaframelist equ $FFFFD6B6	;IDA: dword_FFD6B6
arenaspritelist equ $FFFFD6BA	;IDA: dword_FFD6BA
faceoffanim equ $FFFFD6BE	;IDA: word_FFD6BE
cursoron equ $FFFFD6C4	;IDA: word_FFD6C4
facelcwait equ $FFFFD6C6	;IDA: word_FFD6C6
SongNum equ $FFFFD6C8
HmTeam equ $FFFFD6CA
SongIndex equ $FFFFD6CC
OvrDivisor equ $FFFFD6CE
OvrDividend equ $FFFFD6D0
homehotcoldsave equ $FFFFD6D2	;no IDA label. clearTeamStats keeps the first $1A0 bytes of the home hot / cold table (HmShots+$1A2) here
awayhotcoldsave equ $FFFFD872	;no IDA label. the same for AwShots+$1A2
sopath equ $FFFFDA12	;IDA: word_FFDA12
sopathpoint equ $FFFFDA14	;IDA: word_FFDA14
sopathx equ $FFFFDA16	;IDA: word_FFDA16
sopathy equ $FFFFDA18	;IDA: word_FFDA18
sopathdir equ $FFFFDA1A	;IDA: word_FFDA1A
sopathend equ $FFFFDA1C	;IDA: word_FFDA1C
picturebuf equ $FFFFDA1E	;no IDA label. UnpackPicture output: tile count word, then the 4 bit tiles (DrawMatchupBitmap, dobitmap read it)
picturebits equ $FFFFDEA0	;no IDA label. UnpackPicture: the 3 packed bytes of the row being unpacked
homepresses equ $FFFFDEA4	;IDA: dword_FFDEA4
homedirpresses equ $FFFFDEA8	;IDA: dword_FFDEA8
awaypresses equ $FFFFDEAC	;IDA: dword_FFDEAC
awaydirpresses equ $FFFFDEB0	;IDA: dword_FFDEB0
replayicontimer equ $FFFFDEB4	;IDA: word_FFDEB4
TmpPuckX equ $FFFFDEB6
lognametext equ $FFFFDEBA	;no IDA label. the unused TerminateLogName's GetLogName String text (length word at -2)
songdelay equ $FFFFDECC	;IDA: word_FFDECC
delayedsong equ $FFFFDECE	;IDA: word_FFDECE
shootoutdelay equ $FFFFDED0	;IDA: word_FFDED0
PuckZCntr equ $FFFFDED2
waitxpad equ $FFFFDED4	;IDA: word_FFDED4
TmpPuckZ equ $FFFFDED6
inputjoy equ $FFFFDED8
TmpJoyPuckCarrier equ $FFFFDEDA
PlayerChked equ $FFFFDEDC
PlayerChking equ $FFFFDEE0
hoticonchars equ $FFFFDEE4	;IDA: word_FFDEE4
coldiconchars equ $FFFFDEE6	;IDA: word_FFDEE6
iconplayer equ $FFFFDEE8	;IDA: word_FFDEE8
iconx equ $FFFFDEEA	;IDA: word_FFDEEA
scoutwait equ $FFFFDEEC	;IDA: dword_FFDEEC
replaydelay equ $FFFFDEF0	;IDA: word_FFDEF0
PALflag equ $FFFFDEF2	;IDA: word_FFDEF2
;$FFFFFFF6: IDA unk_FFFFF6, not used
Stack equ $FFFFFFFE
;$FFFFFFFF: IDA unk_FFFFFF, not used
Z80_RAM equ $A00000
;$A00083 is Z80_RAM+$83 (IDA byte_A00083)
;$A0008E is Z80_RAM+$8E (IDA byte_A0008E)
;$A02000 is Z80_RAM+$2000 (IDA unk_A02000)
Z80_YM2612 equ $A04000
; ----------------------------------



