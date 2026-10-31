;	RAM map (93G form): M68K_RAM and the RAM below varstart as equates, then the variables from varstart
;	allocated with rs in address order, each sized to the next one. Equates only: no ROM bytes.

Z80_RAM equ $A00000
Z80_YM2612 equ $A04000
Stack	=	$FFFFFFFE				;game stack (Begin, StartPer, Opening2)
M68K_RAM equ $FFFF0000
sramcleared equ $FFFF1FFE
varstart equ $FFFFB000				;start of variable space (end of replay; 93G)
replayend equ $FFFFAF54				;end of the replay frames (replaysize bytes each); suba4, adda43
									;and the record step wrap here
	RSSET	varstart				;variables from here on are allocated upwards with rs (93G)
VSCRLPM	rs.w	1
VSPRITES	rs.w	1
VmMAP1	rs.w	1
Map1col	rs.w	1
VmMAP2	rs.w	1
Map2col	rs.w	1
VmMAP3	rs.w	1
Map3col	rs.w	1
BigFontchars	rs.w	1
smallfontchars	rs.w	1
smallfont2chars	rs.w	1
energybarchars	rs.w	1
rinkvrcset	rs.w	1
crowdvrcset	rs.w	1				;94 keeps the crowd tiles 1st vram char here
faceoffvrcset	rs.w	1
framercset	rs.w	1
EASNcset	rs.w	1
basetileoffset	rs.w	1
spritechars	rs.w	1
ExtraChars	rs.w	1
printx	rs.w	1
printy	rs.w	1
printa	rs.w	1
printm	rs.w	1
printfontset	rs.w	1
fodropx	rs.w	1
fodropy	rs.w	1
recbpr	rs.l	1
VBint	rs.l	1
Vcount	rs.w	1
OldVcount	rs.w	1
repeatdelayframes	rs.w	1
asv	rs.w	1
lldisp	rs.w	1
periodendtime	rs.w	1
SortCords	rs.b	Sortobjs*SCstruct	;sort objects, SCstruct bytes each (93G); the puck is object puckscnum
puckx	equ	SortCords+(puckscnum*SCstruct)+Xpos	;puck x position in its sort object (93G)
puckvx	equ	SortCords+(puckscnum*SCstruct)+Xvel	;puck x velocity
pucky	equ	SortCords+(puckscnum*SCstruct)+Ypos	;puck y position
puckvy	equ	SortCords+(puckscnum*SCstruct)+Yvel	;puck y velocity
puckz	equ	SortCords+(puckscnum*SCstruct)+Zpos	;puck height above the ice
puckvz	equ	SortCords+(puckscnum*SCstruct)+Zvel	;puck z velocity
puckx_nopuck	equ	SortCords+(puckscnum*SCstruct)+nopuck	;puck object nopuck word
puckc	equ	SortCords+(puckscnum*SCstruct)+newpos	;puck carrier (93G: the newpos slot of the puck object)
puck_pflags2	equ	SortCords+(puckscnum*SCstruct)+pflags2	;puck object pflags2
Ylist	rs.w	16
OOlistpos	rs.w	16
OOlist	rs.w	8
Crowdframe	rs.w	1
Crowdlevel	rs.w	1
Crowdstep	rs.w	1
Crowdcnt	rs.w	1
CwdExciteLvl	rs.w	1
MaxCwdExciteLvl	rs.w	1
NumCwdExciteLvl	rs.w	1
SumCwdExciteLvl	rs.l	1
Zamx	rs.w	1
playoffspritex	rs.w	1
playoffspritey	rs.w	1
clampcounter	rs.w	1
DMAList	rs.w	560
DMAlistend	rs.l	1
Vpos	rs.w	1
Oldrow	rs.w	1
Hpos	rs.w	1
Hscroll	rs.w	1
Vscroll	rs.w	1
wcradiusx	rs.w	1
wcradiusy	rs.w	1
palcount	rs.w	1
palfadenew	rs.w	64
fofdata2	rs.w	4
fofdata	rs.l	1
ffonum	equ	7						;objects tied to the rink scroll (93 had 5)
pads	rs.w	14
Joy1Struct	rs.w	28
CameraPosStruct	rs.w	11
replayactive	rs.w	3
Joy3Struct	rs.w	14
Joy4Struct	rs.w	14
glovestruct	rs.w	14
PadControlBits	rs.w	1
padcont	rs.w	6
PadControlBits34	rs.w	1		;as PadControlBits, for pads 3 and 4 (4 way play)
ssonum	equ	4						;screen objects not tied to the rink scroll (2 arrows + 2 scoreboard
									;logos)
ssosize	equ	$14						;bytes per sso object
sso	rs.w	40
shotplayer	rs.w	1
lastplayer	rs.w	1
passdir	rs.w	1
passspeed	rs.w	1
passReceiverPlayerNum	rs.w	1			;SCnum of the intended receiver of the last pass, -1 = none (94 had passplayer)
glovecords	rs.w	1
threat	rs.w	1
puckcross	rs.b	2*pcsize		;xcord / frames, top entry then bottom (93G rs.w 4)
puckcross2	equ	puckcross+pcframes	;top entry frames
puckcross4	equ	puckcross+pcsize	;bottom entry x
puckcross6	equ	puckcross+pcsize+pcframes	;bottom entry frames
lj1	rs.w	1
lj2	rs.w	1
lj3	rs.w	1
lj4	rs.w	1
pad4way1	rs.b	1
pad4way2	rs.b	1
pad4way3	rs.b	1
pad4way4	rs.b	1
pad4wayword	rs.l	1				;the pad word the unused ReadJoySwapPad1-4 swap a pad's saved word into
									;around ReadJoy1
pad4waysave1	rs.w	1			;ReadJoySwapPad1 saved pad word
pad4waysave2	rs.w	1			;ReadJoySwapPad2 saved pad word
pad4waysave3	rs.w	1			;ReadJoySwapPad3 saved pad word
pad4waysave4	rs.w	1			;ReadJoySwapPad4 saved pad word
bholdtimer	rs.w	1				;B button hold timers of pads 1 / 2 (one byte each); bholdtimer34 for pads
									;3 / 4
bholdtimer34	rs.w	1
padword3	rs.w	1
padword4	rs.w	1
padword1	rs.w	1				;a pad 1 word swapped with padword3 for 4 way play (updateplayers)
padword2	rs.w	1				;a pad 2 word swapped with padword4 for 4 way play (updateplayers)
TempWord1	rs.w	1				;a scratch word (hot / cold totals, record page, button direction ...)
TempWord2	rs.w	1				;a scratch word (hot / cold totals, attribute number, credits step ...)
TempRawSpd	rs.w	1
TempMaxSpd	rs.l	1
TempEnergySpd	rs.w	1
TempLegSpd	rs.w	1
TempBuffer	rs.w	20				;40 byte scratch buffer: String buffer (AppendNumber, names, "(played by
									;NAME)"), hot / cold player, sum byte pairs
scorergoalies	rs.w	1
recties	rs.w	1
reclosses	rs.w	1
recwins	rs.w	1
awayhotter	rs.w	1
setupfontchars	rs.w	1
awayhotidx	rs.w	1
homehotidx	rs.w	1
awaycoldidx	rs.w	1
homecoldidx	rs.w	1
awayhotplayer	rs.w	1			;the away team's hottest starter (BuildHotColdLists)
homehotplayer	rs.w	1			;the home team's hottest starter
awaycoldplayer	rs.w	1			;the away team's coldest starter
homecoldplayer	rs.w	1			;the home team's coldest starter
ChkBodyG	rs.w	1
ChkBodySqG	rs.l	1
NegChkBodyG	rs.w	1
onetimerplayer	rs.w	1
onetimerclock	rs.w	4
onetimerflags	rs.w	1
disflags	rs.w	1
ltplayer	rs.w	1
ltx	rs.w	1
lty	rs.w	1
iflags	rs.b	1
icingPlayer	rs.b	5
clockram	rs.w	4
xc1	rs.w	1
yc1	rs.w	1
yleader	rs.w	1
fox	rs.w	1
foy	rs.w	1
fodir1	rs.w	1
fodir2	rs.w	1
deltax	rs.w	1
deltay	rs.w	1
collflag	rs.w	1
evalue	rs.w	1
mesarea	rs.w	1
TextBuffer	rs.w	49
PushWidthBuf	rs.w	4
PushNumberBuf	rs.w	1
redrawicons	rs.w	1
ltack	rs.w	1
lastsfx	rs.w	1
Satt	rs.w	360
Sattsize	rs.w	1
gmode	rs.w	1
sflags	rs.w	1
sflags2	rs.w	1
sflags3	rs.w	1
BA_PS_flags	rs.w	1
sflags4	rs.w	1					;94 flag word: reverse angle replay (bits 4, 6, 7), slot, penalty shot
									;goal ...
sflags5	rs.w	1					;94 flag word: crowd noise on (bit 7), menu handler keeps its screen (bit
									;1), setup scroll (bit 2) ...
sflags6	rs.w	1					;94 flag word: one-timer (bits 1, 2), slot (bit 5), save RAM write (bit
									;6), record value (bit 7) ...
gmode2	rs.w	1					;94 game mode word, beside gmode: shootout (bit 0), shootout skater has
									;the puck (bit 1), breakaway (bit 4) ...
sflags7	rs.w	1					;94 flag byte: arena faceoff animation (bit 0), injury (bit 5), crowd
									;meter broken (bit 6) ...
sflags8	rs.w	1					;94 flag byte: penalty shot / shootout and one-timer bits
DelayedPen	rs.l	1
crowdnoisedelay	rs.w	1
CwdChkCntr	rs.w	1
CwdChkCnt	rs.w	3
CurCrowdMeter	rs.w	1
CrowdRecord	rs.w	1
CrowdAvg	rs.w	1
CrowdPeak	rs.w	1
pausepad	rs.w	1
joypuckcarrier	rs.w	1
msgtimer	rs.w	1
passmodetimer	rs.w	1
savednewpnum	rs.w	1
c1playernum	rs.w	1
c2playernum	rs.w	1
c3playernum	rs.w	1
c4playernum	rs.w	1
cont1team	rs.w	1
cont2team	rs.w	1
cont3team	rs.w	1
cont4team	rs.w	1
HomeTeam	rs.w	1
VisTeam	rs.w	1
TeamBlockMap	rs.w	56			;Map word buffer for CopyTeamBlockMapData and PutTeamBlock
PenBuf	rs.w	33
; Penalty numbers (word offsets into Penaltylist) for AddPenalty
PenEOP	equ	$2
PenEOG	equ	$4
PenOOP	equ	$6
PenGhold	equ	$8
PenWhistle	equ	$A
PenIcing	equ	$C
PenGoal	equ	$E
PenOffsides	equ	$10
PenRoughing2	equ	$12
PenNoText	equ	$14
PenCharging	equ	$16
PenSlashing	equ	$18
PenRoughing	equ	$1A
PenCrossChk	equ	$1C
PenHooking	equ	$1E
PenTripping	equ	$20
PenInterference	equ	$22
PenHolding	equ	$24
PenFighting	equ	$26
PenFighting2	equ	$28
PenInst	equ	$2A
PenDelay	equ	$2C
PenHookingPS	equ	$2E
PenTrippingPS	equ	$30
PenGhold2	equ	$32
PenInterferencePS	equ	$34
PenRoughingPS	equ	$36
PenChargingPS	equ	$38
PenCrossChkPS	equ	$3A
PenSlashingPS	equ	$3C
; Sprite object constants (92 names; the sso/ffo counts and size sit with sso and pads)
collrad	equ	8						;collision radius of an object (objects collide within collrad*2)
horoff	equ	197						;subtracted from the screen y in the horizontal rink view
PenCntDwn	rs.w	1
Penaltytimer	rs.w	1
PBnum	rs.w	1
InjCntDown	rs.w	1
penmsgtimer	rs.w	1
RefCnt	rs.w	1
RefStep	rs.w	1
RefPen	rs.w	1
RefRamMap	rs.w	56
gsp	rs.w	1
gameclock	rs.l	1
PerTimeTotal	rs.w	1
ChkCnt	rs.w	1
TempPlOffset	rs.w	1
ScoreSumbytes	rs.w	1
ScoreSum	rs.w	180
PenSumLength	rs.w	1
PenSum	rs.w	120
tmstruct	rs.b	tmsize			;home team struct (93G)
HmGoals	equ	tmstruct+tmscore		;home score
HomeTeamRosterPtr	equ	tmstruct+tmdata	;home team data address
awtmstruct	rs.b	tmsize				;away team struct (first field tmshots)
AwGoals	equ	awtmstruct+tmscore			;away score
AwayTeamRosterPtr	equ	awtmstruct+tmdata	;away team data address
statsbuffer	rs.w	104
gstruct	rs.b	gssize*8		;8 game structures
gamenum	rs.w	1
postarts	rs.w	1
bosgames	rs.w	1
gamelevel	rs.w	1
potreeteam	rs.w	1
pojoy	rs.w	1
WinBits	rs.w	1
potree	rs.w	16
PlList	rs.w	6
menuitem	rs.l	1				;menu state: selected item, then (+2) first item shown
menulist	rs.l	1
menudraw	rs.l	1
TickerNum	rs.w	1
PPBonus	rs.b	1
PKBonus	rs.b	1
ThirdPBonus	rs.b	1
HmAwBonus	rs.b	1
remapTablePtr	rs.l	1
ThreeStars	rs.w	100
recordbuf equ ThreeStars			;the save RAM record staging buffer (shares ThreeStars)
decompbuffer equ ThreeStars			;DecompressBytecode 256 byte ring buffer (shares ThreeStars)
teamrecbuf	rs.w	28				;SRAM team record buffer: the 16 byte record of a team (ReadCrowdRecord),
									;byte 8 crowd record, byte 9 its name number
nibblebuffer	rs.w	6
homeuser	rs.w	1
awayuser	rs.w	1
FourWayPlay	rs.w	1
OptPlayMode	rs.w	1
OptNOP	rs.w	1
Opt1team	rs.w	1
Opt2team	rs.w	1
Optperlen	rs.w	1
OptGoalie	rs.w	1
OptUserRec	rs.w	1
OptPen	rs.w	1
OptLine	rs.w	1
goaliemode1	rs.w	1
goaliemode2	rs.w	1
TmpOptUserRec	rs.w	1
TmpOptPen	rs.w	1
TmpOptLine	rs.w	1
demoflag	rs.w	1
seed	rs.l	1
dmaram	rs.l	1
PalMode	rs.w	1
music_tick_divider	rs.w	1
TmpOptLine2	rs.w	1
TempOptPlayMode	rs.w	1
databuffer	rs.w	9
passbits	rs.w	5				;playoff password bits (94 had pwddatabuffer)
outputbuffer	rs.w	114
tpassbits	rs.w	5
music_needs_z80_update	rs.w	1
Z80_command_buffer	rs.b	5
per_channel_attenuation_table	rs.b	7
per_channel_frequency_table	rs.w	7
per_channel_patch_table	rs.w	4
fm_voice_usage_table	rs.w	256
fm_channel_structs	rs.w	20
pcm_channel_struct	rs.w	4			;PCM (DAC) channel struct, after the 5 FM structs (94 had fm_channel_struct6)
fm_track_slots	rs.w	24
BA_Team	rs.w	1
BA_Sktr_SCnum	rs.w	1
BA_Goalie_SCnum	rs.w	1
BA_Skater_Offset	rs.w	1
BA_Goalie_Offset	rs.w	1
BA_Checker_Offset	rs.w	1
pspenalty	rs.w	1
holdreset	rs.w	1
onetimertargetx	rs.w	1
onetimertargety	rs.w	1
onetimerheight	rs.w	1
FallYPos	rs.w	1
FallXPos	rs.w	1
aholdtimer	rs.w	1				;A button hold timers of pads 1 / 2 (one byte each); aholdtimer34 for pads
									;3 / 4
aholdtimer34	rs.w	1
setupfirstline	rs.w	1
setupprevline	rs.w	1
setupmenuchars	rs.w	1
logoteam	rs.w	1
setuphome	rs.w	1
setupvis	rs.w	1
setupcardflags	rs.w	1
homepicchars	rs.w	1
vispicchars	rs.w	1
cardroster	rs.w	1
logobox1chars	rs.w	1
logobox2chars	rs.w	1
teambitmapchars	rs.w	1
cardtimer	rs.w	1
featuredplayer	rs.w	1
carddelay	rs.w	1
cardprintx	rs.w	1
cardprinty	rs.w	1
cardteamnum	rs.w	1
homegoalies	rs.w	1
awaygoalies	rs.w	1
homeplayers	rs.w	1
awayplayers	rs.w	1
cardlogochars1	rs.w	1
cardlogochars2	rs.w	1
shootoutclock	rs.w	1
shootoutjiffy	rs.w	1
ValidSRAM	rs.w	1
namelog	rs.w	64					;the user name log: $80 bytes from save RAM NameLogBase (NameLogIO),
									;12 bytes per name, namelogsel the entry
nameentrybuf	rs.w	7
namelength	rs.w	1
namelogsel	rs.w	1
namelogarrows	rs.w	1
nameentryvis	rs.w	1
homecardidx	rs.w	1
awaycardidx	rs.w	1
cardindex	rs.w	1
cardvis	rs.w	1
cardcount	rs.w	1
homecardlist	rs.w	13			;the home player card order (BuildCardPlayerLists), read by GetCardPlayer
awaycardlist	rs.w	13			;the away player card order
cardplayer	rs.w	1
nameframechars	rs.w	1
recsort1	rs.w	4				;Record Holders row order sorted on record byte 0 (ReadTeamRecords), read
									;by PrintPlayerRecords
recsort2	rs.w	4				;Record Holders row order sorted on record byte 4 (ReadTeamRecords,
									;sflags6 bit 6)
winsort	rs.w	4					;Record Holders win row order (CalcWinPercents), read by PrintWinRecords
winpcts	rs.w	4					;the win % byte of each of the 8 records (CalcWinPercents)
winties	rs.w	8					;the ties word of each record (record bytes $C-$D)
wingames	rs.w	8				;the games word of each record (record bytes $A-$B)
shootoutstate	rs.w	1			;first of the 19 words ClearGameStats clears (shootout
									;goals, shootoutround, shooter lists ...)
homeshootgoals	rs.w	1
awayshootgoals	rs.w	1
shootoutround	rs.w	1
homeshooters	rs.w	6			;the home shootout shooter list (6 words, homeshootnum the index)
homeshootnum	rs.w	1
awayshooters	rs.w	6			;the away shootout shooter list (6 words)
shootoutteam	rs.l	1
matchup	rs.w	1
scoutunused	rs.w	1				;cleared by ScoutingReport, never read
matchuphome	rs.w	1
matchupvis	rs.w	1				;the visitors player of the matchup; also the scroll limit of StatsReport
homerating	rs.w	1
visrating	rs.w	1
advframe	rs.w	1
advcount	rs.w	1
matchuptimer	rs.w	1
matchupslot	rs.w	1
;DispAttribCtr to TestList are not in 93G order: 94 moved them, and the addresses here are 94's
DispAttribCtr	rs.w	1
VertLineScrolling	rs.w	1
PlayerScrollCtr	rs.w	1
SelectedPlayerIdx	rs.w	1
ScoutingReportTimer	rs.w	1			;scouting report: frames elapsed, the text typing delay (94 had typedelay)
screentimer	rs.w	1
TestList	rs.w	122
arenaanimchars	rs.w	1
arenaframe	rs.w	1
arenaframeidx	rs.w	1
arenaframetime	rs.w	1
arenaanim	rs.w	1
arenaframelist	rs.l	1
arenaspritelist	rs.l	1
faceoffanim	rs.w	3
cursoron	rs.w	1
facelcwait	rs.w	1
SongNum	rs.w	1
HmTeam	rs.w	1
SongIndex	rs.w	1
OvrDivisor	rs.w	1
OvrDividend	rs.w	1
homehotcoldsave	rs.w	208			;clearTeamStats keeps the home hot / cold table (tmstruct+tmHotCold)
									;here
awayhotcoldsave	rs.w	208			;the same for the awtmstruct table
sopath	rs.w	1
sopathpoint	rs.w	1
sopathx	rs.w	1
sopathy	rs.w	1
sopathdir	rs.w	1
sopathend	rs.w	1
picturebuf	rs.w	577				;UnpackPicture output: tile count word, then the 4 bit tiles
									;(DrawMatchupBitmap, dobitmap read it)
picturebits	rs.l	1				;UnpackPicture: the 3 packed bytes of the row being unpacked
homepresses	rs.l	1
homedirpresses	rs.l	1
awaypresses	rs.l	1
awaydirpresses	rs.l	1
replayicontimer	rs.w	1
TmpPuckX	rs.l	1
lognametext	rs.w	9				;the unused TerminateLogName's GetLogName String text (length word at -2)
songdelay	rs.w	1
delayedsong	rs.w	1
shootoutdelay	rs.w	1
PuckZCntr	rs.w	1
waitxpad	rs.w	1
TmpPuckZ	rs.w	1
inputjoy	rs.w	1
TmpJoyPuckCarrier	rs.w	1
PlayerChked	rs.l	1
PlayerChking	rs.l	1
hoticonchars	rs.w	1
coldiconchars	rs.w	1
iconplayer	rs.w	1
iconx	rs.w	1
scoutwait	rs.l	1
replaydelay	rs.w	1
PALflag	rs.w	4230
	rs.w	1						;the word at Stack
; ----------------------------------



