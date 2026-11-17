	include	equates94.asm				;ports, button bits, structure offsets and other constants: shared with the Sega CD HOCKEY build
; the cartridge-only part of the old ram94.asm top: work RAM start, replay buffer, team count checks
replaystart equ $FFFF0000			;start of ram area for replay frames, also the start of RAM
M68K_RAM equ replaystart			; start of the 68000 work RAM, the same as replaystart
RAMStart equ $FF0000				;start of work RAM, as a 24-bit address
varstart equ $FFFFB000				;start of variable space (end of replay; 93G)
replaysize equ 98					;bytes per replay frame (92G/93G name; 92G 84)
replaynum equ ((varstart-replaystart)/replaysize)-1	;number of frames for replay
replayend equ replaystart+(replaynum*replaysize)	;end of the replay frames (replaysize bytes each);
									;suba4, adda43 and the record step wrap here
	IF NumTeams<>ASW+1
		inform	3,"TeamList needs one entry per team"
	ENDIF
	IF TeamRecBase<CrowdRecEnd
		inform	3,"The crowd records run into the records block (see docs/EXPANDING_THE_ROM.md)"
	ENDIF
	IF 32<NumPlayoffTeams
		inform	3,"The playoff draw only keeps 32 team bits"
	ENDIF


	RSSET	varstart				;variables from here on are allocated upwards with rs (93G)
VSCRLPM	rs.w	1					; location in vram of scroll parameters
VSPRITES	rs.w	1				; location in vram of sprite attributes
VmMAP1	rs.w	1					; location in vram of playfield 1
Map1col	rs.w	1					; 2 to this power = width in char of playfield 1
VmMAP2	rs.w	1					; location in vram of playfield 2
Map2col	rs.w	1					; 2 to this power = width in char of playfield 2
VmMAP3	rs.w	1					; location in vram of playfield 3
Map3col	rs.w	1					; 2 to this power = width in char of playfield 3
BigFontchars	rs.w	1			; vram tiles for BigFont.map
smallfontchars	rs.w	1			; vram tiles for SmallFont.map
smallfont2chars	rs.w	1			; vram tiles for the 2nd small font set.
energybarchars	rs.w	1			; vram tiles for the energy bar
logochars equ energybarchars		;reused: logo / cup sprite tiles on the title and playoff screens
rinkvrcset	rs.w	1				; vram tiles for IceRink.map
crowdvrcset	rs.w	1				;94 keeps the crowd tiles 1st vram char here
faceoffvrcset	rs.w	1			; vram tiles for FaceOff graphics
framercset	rs.w	1				; vram tiles for framer.map
EASNcset	rs.w	1				; vram tiles for EASN.map
basetileoffset	rs.w	1			; vram char of the home team block tiles; the visitor block is at +$18
spritechars	rs.w	1				; vram tiles for the sprites.
ExtraChars	rs.w	1				; vram tiles for extra graphics
printx	rs.w	1					; x cordinate for printing
printy	rs.w	1					; y cordinate for printing
printa	rs.w	1					; attribute for print characters
printm	rs.w	1					; map to use (0 = map 1, 4 = map 2, 8 = map 3)
printfontset	rs.w	1			; printsmall char set (index*2 into smallfontchars).
;printsmall / printz2 (ControlCodeJumpTable, -byte): the code, then its argument bytes
;print / printz / printbig / printbigz / appendz control byte (NOT printsmall: there $FF..
;are the CC_Set* codes above).
;One byte with bit 7 set, read as -$ab: bits 0-1 font (= map 1-3), bit 2 h flip, bit 3 v
;flip, bits 4-5 palette, bit 6 priority; then x, y (printa = the bits << 9, printm = map).
;Names match 93G ram93.asm / 93S / 94S
;Whole-String markers that list / page readers test (a String of just $FF / -1 is the word
;$FF00 at strtext, negative)
fodropx	rs.w	1					; face off drop spot x/y
fodropy	rs.w	1					; face off drop spot y (see fodropx)
recbpr	rs.l	1					; replay record buffer pointer: the frame being recorded
VBint	rs.l	1					; address of vblank interupt code
Vcount	rs.w	1					; counter for vblank
OldVcount	rs.w	1				; Vcount at the last game frame: the frame loop waits d7 frames from it
repeatdelayframes	rs.w	1		; frames until the menu cursor repeats (first delay $F, then 4)
asv	rs.w	1						; analog sound volume (crowd noise)
lldisp	rs.w	1					; line level disp update counter
periodendtime	rs.w	1			; CheckLateGameSong trigger time.
;the sort object structure (SCstruct bytes each)
;player struct fields after handed's neighbours, not named in 93 (names from the 92/93/94 comments)
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
GoalieStruct equ SortCords-SCstruct	;the sort object before SortCords: GoalieStruct+SCstruct is player 0
									;(shotdiradj scan)
Ylist	rs.w	16					; list of y cords for each sortobj
OOlistpos	rs.w	16				; objects pos in OOlist
OOlist	rs.w	8					; object order list for sort objs
Crowdframe	rs.w	1				; current crowd frame number
Crowdlevel	rs.w	1				; level of crowd excitement
Crowdstep	rs.w	1				; animation step for crowd
Crowdcnt	rs.w	1				; count down to next step.
CwdExciteLvl	rs.w	1			; crowd excitement level (starts at gamelevel*16, +$1E on an injury, +$28
MaxCwdExciteLvl	rs.w	1			; peak crowd level.
NumCwdExciteLvl	rs.w	1			; crowd level sample count.
SumCwdExciteLvl	rs.l	1			; crowd level running total.
Zamx	rs.w	1					; zamboni x cord
playoffspritex	rs.w	1			; logo sprite x (title / playoff screens).
playoffspritey	rs.w	1			; logo sprite y.
clampcounter	rs.w	1			; credits page wait counter (how long the first page stays)
logoslide equ clampcounter			;reused: title / playoff screen page time (credits wait)
DMAList	rs.w	560					; dma transfer list
DMAlistend	rs.l	1				; end of the DMA list: where the next entry is written
Vpos	rs.w	1					; ice rink vertical position
Oldrow	rs.w	1					; last row (used in vertical scrolling of the map data)
Hpos	rs.w	1					; ice rink horizontal position
Hscroll	rs.w	1					; horizontal scroll value
Vscroll	rs.w	1					; vertical scroll value
wcradiusx	rs.w	1				; variables used in wall collisions
wcradiusy	rs.w	1				; wall collision radius y (see wcradiusx)
palcount	rs.w	1				; counter for fading in color palettes
palfadenew	rs.w	64				; palettes to fade into (+$20 the title palette, +$40 palettes 2-3)
fofdata2	rs.w	4				; faceoff sprite data, second set
fofdata	rs.l	1					; data for frame/att of big face off sprites
pads	rs.w	14					;face-off ice pad object (93 pads object 0). Not joypads
Joy1Struct	rs.w	28				;controller 1 and 2 arrow objects (93 pads+ffosize, two ffo)
Joy2Struct	equ	Joy1Struct+ffosize	;controller 2 arrow object (second half of Joy1Struct)
CameraPosStruct	rs.w	11			; scroll camera: tracked object, target and the lead on the scroll
;replay camera struct (CameraPosStruct, 93 name): stands in for a sort object, Xpos / Ypos
;are its position (UpdateCameraPos). It is really 14 words: camtrack and camidle lie past the 11
;words 93 reserved for it and overlap replayactive (camtrack is the replayactive word)
replayactive	rs.w	3			; set by ReplayMode.
Joy3Struct	rs.w	14				;controller 3 arrow object (4 Way Play; 93 had glovestruct here)
Joy4Struct	rs.w	14				;controller 4 arrow object (4 Way Play)
glovestruct	rs.w	14				; gloves object, pads+(4*ffosize).
PadControlBits	rs.w	1			; pad assignment bits ($FFFF = no assignments, set at game setup)
padcont	rs.w	6					; pad assignment data (4 words), cleared together with PadControlBits
PadControlBits34	rs.w	1		;as PadControlBits, for pads 3 and 4 (4 way play)
sso	rs.w	40						; screen objects not tied to the rink scroll: 2 arrows for off screen
shotplayer	rs.w	1				; player who shot last
lastplayer	rs.w	1				; last player who touched puck
passdir	rs.w	1					; direction for pass/shot
passspeed	rs.w	1				; speed of pass/shot
passReceiverPlayerNum	rs.w	1	;SCnum of the intended receiver of the last pass, -1 = none (94 had
									;passplayer)
glovecords	rs.w	1				; cordinates of glove/sticks (fighting)
threat	rs.w	1					; direction of threat on puck handler
puckcross	rs.b	2*pcsize		;xcord / frames, top entry then bottom (93G rs.w 4)
puckcross2	equ	puckcross+pcframes	;top entry frames
puckcross4	equ	puckcross+pcsize	;bottom entry x
puckcross6	equ	puckcross+pcsize+pcframes	;bottom entry frames
lj1	rs.w	1						; used in joystick debounce
lj2	rs.w	1						; joystick debounce for pad 2 (see lj1)
lj3	rs.w	1						; controller 3 joystick state
lj4	rs.w	1						; controller 4 joystick state
PadRaw1	rs.b	1					; Rev B: controller 1 as read by ReadPads in the vblank (active low)
PadRaw2	rs.b	1					; Rev B: controller 2 (ReadJoy1/ReadJoy2 only translate these)
PadRaw3	rs.b	1					; controller 3 raw pad byte
PadRaw4	rs.b	1					; controller 4 raw pad byte
pad4wayword	rs.l	1				;the pad word the unused ReadJoySwapPad1-4 swap a pad's saved word into
									;around ReadJoy1
pad4waysave1	rs.w	1			;ReadJoySwapPad1 saved pad word
pad4waysave2	rs.w	1			;ReadJoySwapPad2 saved pad word
pad4waysave3	rs.w	1			;ReadJoySwapPad3 saved pad word
pad4waysave4	rs.w	1			;ReadJoySwapPad4 saved pad word
bholdtimer	rs.w	1				;B button hold timers of pads 1 / 2 (one byte each); bholdtimer34 for pads
									;3 / 4
bholdtimer34	rs.w	1			; B button hold timers, controllers 3 and 4
padword3	rs.w	1				; controller 3 pad word
padword4	rs.w	1				; controller 4 pad word
padword1	rs.w	1				;a pad 1 word swapped with padword3 for 4 way play (updateplayers)
padword2	rs.w	1				;a pad 2 word swapped with padword4 for 4 way play (updateplayers)
TempWord1	rs.w	1				;a scratch word (hot / cold totals, record page, button direction ...)
TempWord2	rs.w	1				;a scratch word (hot / cold totals, attribute number, credits step ...)
TempRawSpd	rs.w	1				; temporary: raw speed
TempMaxSpd	rs.l	1				; temporary: maximum speed
TempEnergySpd	rs.w	1			; temporary: speed after energy
TempLegSpd	rs.w	1				; temporary: leg speed
TempBuffer	rs.w	20				;40 byte scratch buffer: String buffer (AppendNumber, names, "(played by
									;NAME)"), hot / cold player, sum byte pairs
scorergoalies	rs.w	1			; first goalie slot of the scoring team (scorer check in setup)
recties	rs.w	1					; team record: ties
reclosses	rs.w	1				; team record: losses
recwins	rs.w	1					; team record: wins
awayhotter	rs.w	1				; away team hot player
setupfontchars	rs.w	1			; first font character of the setup screens
awayhotidx	rs.w	1				; away team hot player index
homehotidx	rs.w	1				; home team hot player index
awaycoldidx	rs.w	1				; away team cold player index
homecoldidx	rs.w	1				; home team cold player index
awayhotplayer	rs.w	1			;the away team's hottest starter (BuildHotColdLists)
homehotplayer	rs.w	1			;the home team's hottest starter
awaycoldplayer	rs.w	1			;the away team's coldest starter
homecoldplayer	rs.w	1			;the home team's coldest starter
ChkBodyG	rs.w	1				; body check strength of the goalie
ChkBodySqG	rs.l	1				; body check strength squared, goalie
NegChkBodyG	rs.w	1				; negated body check strength of the goalie
onetimerplayer	rs.w	1			; player taking a one timer
onetimerclock	rs.w	4			; one timer timing clocks
onetimerflags	rs.w	1			; one timer flags
disflags	rs.w	1				; display flags
ltplayer	rs.w	1				; last touch player
ltx	rs.w	1						; last touch x cord
lty	rs.w	1						; last touch y cord
iflags	rs.b	1					; icing
icingPlayer	rs.b	5				; icing: the SCnum+1 of the last player to touch the puck (iflags+1), then
clockram	rs.w	4				; ram for dma transfer of clock digits
xc1	rs.w	1						; scroll lock x cord
yc1	rs.w	1						; scroll lock y cord
yleader	rs.w	1					; lead distance on scrolling
fox	rs.w	1						; faceoff spot x/y
foy	rs.w	1						; face off spot y (see fox)
fodir1	rs.w	1					; pull directions for each player on face off
fodir2	rs.w	1					; pull direction for the visiting player on the face off (see fodir1)
deltax	rs.w	1					; used lots of places for x/y stuff
deltay	rs.w	1					; y difference, used in many places (see deltax)
collflag	rs.w	1				; collision has occured
evalue	rs.w	1					; elasticity value (parameter of collisions)
mesarea	rs.w	1					; temp area for mes chars
TextBuffer	rs.w	49				; to mesarea+100
PushWidthBuf	rs.w	4			; PushNumberWidth string: length word, then digits.
PushNumberBuf	rs.w	1			; PushNumber builds its string down from here.
redrawicons	rs.w	1				; DrawLineIcons: last icon group drawn ($FF = redraw).
ltack	rs.w	1					; last tackle sound.
lastsfx	rs.w	1					; last sound played
Satt	rs.w	360					; sprite attribute table (for dma transfer
Sattsize	rs.w	1				; size of transfer
gmode	rs.w	1					; game mode flag
sflags	rs.w	1					; game state flags
sflags2	rs.w	1					; game state flags, second word
sflags3	rs.w	1					; game state flags, third word
BA_PS_flags	rs.w	1				;breakaway / penalty shot / shootout flags (94)
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
DelayedPen	rs.l	1				;delayed penalty (94): bit 0 PP goal, bit 1 home, bit 2 away
crowdnoisedelay	rs.w	1			; frames until the next crowd noise
CwdChkCntr	rs.w	1				; Crowd meter frame counter
CwdChkCnt	rs.w	3				; Crowd meter update count
CurCrowdMeter	rs.w	1			; current crowd meter level
CrowdRecord	rs.w	1				; The crowd record threshold
CrowdAvg	rs.w	1				; Crowd noise off level
CrowdPeak	rs.w	1				; The crowd peak of the game
pausepad	rs.w	1				; pad that paused the game
joypuckcarrier	rs.w	1			; player with the puck controlled by the joypad
msgtimer	rs.w	1				; on screen message timer
passmodetimer	rs.w	1			; pass mode timer
savednewpnum	rs.w	1			; saved new player number
c1playernum	rs.w	1				; player in control or neg for none
c2playernum	rs.w	1				; player controlled by pad 2, negative = none (see c1playernum)
c3playernum	rs.w	1				; controller 3 player number
c4playernum	rs.w	1				; controller 4 player number
cont1team	rs.w	1				; cont1 team 0=none 1=team1 2=team2
cont2team	rs.w	1				; team of controller 2: 0 = none (see cont1team)
cont3team	rs.w	1				; team of controller 3
cont4team	rs.w	1				; team of controller 4
HomeTeam	rs.w	1				; number 0-24
VisTeam	rs.w	1					; visiting team number (0-24, see HomeTeam)
TeamBlockMap	rs.w	56			;Map word buffer for CopyTeamBlockMapData and PutTeamBlock
PenBuf	rs.w	MaxPen+1			; upto x penalties saved
PenCntDwn	rs.w	1				; frames until the penalty or stoppage message ends (fights 60, an injury
Penaltytimer	rs.w	1			; counts down the second for the penalty clocks (jps frames)
PBnum	rs.w	1					; $HV00 h=home players in pb
InjCntDown	rs.w	1				; frames until the injury box is shown after an injury
penmsgtimer	rs.w	1				; penalty message timer
RefCnt	rs.w	1					; ref graphics control
RefStep	rs.w	1					; ref animation step: word offset into the ref frames, -1 = ref idle
RefPen	rs.w	1					; penalty number the ref is calling (4 = game over)
RefRamMap	rs.w	refwidth*refheight	; ref cam map words (refwidth x refheight)
gsp	rs.w	1						; game period
gameclock	rs.l	1				; game clock
PerTimeTotal	rs.w	1			; total time of the period
ChkCnt	rs.w	1					; check counter for the player check stat
TempPlOffset	rs.w	1			; roster offset of the player to print (bit 15 =
ScoreSumbytes	rs.w	1			; bytes used in ScoreSum (6 per goal)
ScoreSum	rs.w	180				; scoring summary: 6 bytes per goal (scorer, assists, time)
PenSumLength	rs.w	1			; bytes used in PenSum (4 per penalty).
PenSum	rs.w	120					; penalty summary log, 4 bytes per penalty.
;team variables (tmstruct / awtmstruct = the home / away team struct)
tmstruct	rs.b	tmsize			;home team struct (93G)
HmGoals	equ	tmstruct+tmscore		;home score
HomeTeamRosterPtr	equ	tmstruct+tmdata	;home team data address
awtmstruct	rs.b	tmsize			;away team struct (first field tmshots)
AwGoals	equ	awtmstruct+tmscore		;away score
AwayTeamRosterPtr	equ	awtmstruct+tmdata	;away team data address
statsbuffer	rs.w	104				; playoff team stat totals, summed from the stat bytes
;game structure variables (one per playoff matchup)
gstruct	rs.b	gssize*8			;8 game structures
gamenum	rs.w	1					; index for current game in game struct
postarts	rs.w	1				; 0-31 for which playoff tree to use as frame
bosgames	rs.w	1				; 0-6 game of series or 7 if not in best of seven
gamelevel	rs.w	1				; 0-3 for the depth into the play off tree
potreeteam	rs.w	1				; which team you are on the intial playoff tree
pojoy	rs.w	1					; playoff joystick indicator
WinBits	rs.w	1					; bits which indicat the continuing teams on the playoff tree
potree	rs.w	16					; team in the tree
PlList	rs.w	6					; list of players used differently
menuitem	rs.l	1				;menu state: selected item, then (+2) first item shown
menulist	rs.l	1				; menu item list.
menudraw	rs.l	1				; menu screen draw routine.
TickerNum	rs.w	1				; intermission ticker: index of the game being shown, negative = no more
PPBonus	rs.b	1					; check bonuses, cleared together by clr.l.
PKBonus	rs.b	1					; penalty kill bonus
ThirdPBonus	rs.b	1				; third period bonus
HmAwBonus	rs.b	1				; home / visitor bonus
remapTablePtr	rs.l	1			; remap table for DecompressGraphicsWithRemap; 0 = plain DMA
ThreeStars	rs.w	100				; three stars of the game data
starscores equ ThreeStars			;the 52 star score longs (CalcStarScores)
recordbuf equ ThreeStars			;the save RAM record staging buffer (shares ThreeStars)
decompbuffer equ ThreeStars			;DecompressBytecode 256 byte ring buffer (shares ThreeStars)
teamrecbuf	rs.w	28				;SRAM team record buffer: the 16 byte record of a team (ReadCrowdRecord),
									;byte 8 crowd record, byte 9 its name number
nibblebuffer	rs.w	6			; UnpackNibbles words, WeightedRandomSelect weights.
varend equ nibblebuffer+8			;end of the variables cleared by Opening2
homeuser	rs.w	1				; home team user controller
awayuser	rs.w	1				; away team user controller
FourWayPlay	rs.w	1				;EA 4 Way Play adaptor present (Detect4WayPlay). With the Opt* setup
									;flags, not the pad I/O (PadRaw / ReadPad4Way)
OptPlayMode	rs.w	1				; play mode
OptNOP	rs.w	1					; number of players
Opt1team	rs.w	1				; team 1
Opt2team	rs.w	1				; team 2
Optperlen	rs.w	1				; period length index.
OptGoalie	rs.w	1				; option: goalie
OptUserRec	rs.w	1				; option: user records
OptPen	rs.w	1					; penalties 1 for off
OptLine	rs.w	1					; line changes option
goaliemode1	rs.w	1				; goalie mode, home
goaliemode2	rs.w	1				; goalie mode, away
TmpOptUserRec	rs.w	1			; temporary option: user records
TmpOptPen	rs.w	1				; temporary option: penalties
TmpOptLine	rs.w	1				; temporary option: line changes
demoflag	rs.w	1				; demo flag
seed	rs.l	1					; seed for the random number generator
dmaram	rs.l	1					; dma ram area.
PalMode	rs.w	1					; Rev A only: VDP PAL bit (Begin). Set = 50 Hz: faster skating
music_tick_divider	rs.w	1		; Rev A only: p_music_vblank runs the track slots again every 6th frame
TmpOptLine2	rs.w	1				; temporary option: line changes, second
TempOptPlayMode	rs.w	1			; temporary option: play mode
databuffer	rs.w	9				; scratch data buffer
passbits	rs.w	5				;playoff password bits (94 had pwddatabuffer)
outputbuffer	rs.w	113			; work buffer, also the shot data kept between games
marker	rs.w	1					;last word of the $100 byte saved block (databuffer .. marker), as 93
tpassbits	rs.w	5				; temporary storage of passbits.
music_needs_z80_update	rs.w	1	; nonzero when the Z80 must be sent the channel changes
Z80_command_buffer	rs.b	5		; key off/on, volume, frequency and patch bits for the Z80 (5 bytes)
per_channel_attenuation_table	rs.b	7	; FM channel attenuation (7 bytes, 6 FM + the DAC)
per_channel_frequency_table	rs.w	7	; FM channel frequency values (7 words)
per_channel_patch_table	rs.w	4	; FM channel patch numbers (4 words)
fm_voice_usage_table	rs.w	256	; which track slot uses each FM voice (256 words)
fm_channel_structs	rs.w	20		; FM channel state (15 words)
pcm_channel_struct	rs.w	4		;PCM (DAC) channel struct, after the 5 FM structs (94 had
									;fm_channel_struct6)
fm_track_slots	rs.w	24			; track slots that play the sounds and songs (25 words)
BA_Team	rs.w	1					;breakaway / penalty shot / shootout: which team (with BA_PS_flags)
BA_Sktr_SCnum	rs.w	1			;SCnum of the breakaway / penalty-shot / shootout skater
BA_Goalie_SCnum	rs.w	1			;SCnum of that play's goalie
BA_Skater_Offset	rs.w	1		;that skater's team position offset
BA_Goalie_Offset	rs.w	1		;that goalie's team position offset
BA_Checker_Offset	rs.w	1		;the checker's team position offset (penalty shot)
pspenalty	rs.w	1				; penalty summary: penalty number
holdreset	rs.w	1				; hold reset countdown
onetimertargetx	rs.w	1			; one timer target x
onetimertargety	rs.w	1			; one timer target y
onetimerheight	rs.w	1			; one timer puck height
FallYPos	rs.w	1				; falling player y position
FallXPos	rs.w	1				; falling player x position
aholdtimer	rs.w	1				;A button hold timers of pads 1 / 2 (one byte each); aholdtimer34 for pads
									;3 / 4
aholdtimer34	rs.w	1			; A button hold timers, controllers 3 and 4
setupfirstline	rs.w	1			; setup screen: first line shown
setupprevline	rs.w	1			; setup screen: previous line
setupmenuchars	rs.w	1			; setup screen: menu character base
logoteam	rs.w	1				; team whose logo is shown
setuphome	rs.w	1				; setup screen: home team
setupvis	rs.w	1				; setup screen: visiting team
setupcardflags	rs.w	1			; setup screen: player card flags
homepicchars	rs.w	1			; home team picture characters
vispicchars	rs.w	1				; visiting team picture characters
cardroster	rs.w	1				; player card: roster
logobox1chars	rs.w	1			; logo box 1 characters
logobox2chars	rs.w	1			; logo box 2 characters
teambitmapchars	rs.w	1			; team bitmap characters
cardtimer	rs.w	1				; player card timer
featuredplayer	rs.w	1			; featured player
carddelay	rs.w	1				; player card delay
cardprintx	rs.w	1				; player card print x
cardprinty	rs.w	1				; player card print y
cardteamnum	rs.w	1				; player card team number
homegoalies	rs.w	1				; home team goalies
awaygoalies	rs.w	1				; away team goalies
homeplayers	rs.w	1				; Players of the home team (CountPlayers)
awayplayers	rs.w	1				; Players of the away team (CountPlayers)
cardlogochars1	rs.w	1			; card logo characters 1
cardlogochars2	rs.w	1			; card logo characters 2
shootoutclock	rs.w	1			; The shootout clock
shootoutjiffy	rs.w	1			; shootout frame counter
ValidSRAM	rs.w	1				; nonzero when the save RAM is valid
namelog	rs.w	64					;the user name log: $80 bytes from save RAM NameLogBase (NameLogIO),
									;12 bytes per name, namelogsel the entry
nameentrybuf	rs.w	7			; name entry buffer
namelength	rs.w	1				; length of the name being entered
namelogsel	rs.w	1				; selected name log entry
namelogarrows	rs.w	1			; Name entry: the name log row with the arrows
nameentryvis	rs.w	1			; name entry cursor visible
homecardidx	rs.w	1				; home player card index
awaycardidx	rs.w	1				; away player card index
cardindex	rs.w	1				; player card index
cardvis	rs.w	1					; player card visible
cardcount	rs.w	1				; player card count
homecardlist	rs.w	13			;the home player card order (BuildCardPlayerLists), read by GetCardPlayer
awaycardlist	rs.w	13			;the away player card order
cardplayer	rs.w	1				; player card player
nameframechars	rs.w	1			; Name entry frame chars (NameEntryFramer)
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
homeshootgoals	rs.w	1			; Shootout goals, home
awayshootgoals	rs.w	1			; Shootout goals, away
shootoutround	rs.w	1			; Shootout round
homeshooters	rs.w	6			;the home shootout shooter list (6 words, homeshootnum the index)
homeshootnum	rs.w	1			; The shooter index of the shootout
awayshooters	rs.w	6			;the away shootout shooter list (6 words)
shootoutteam	rs.l	1			; Shootout: 0 home shoots, 1 away
matchup	rs.w	1					; matchup screen: selection
scoutunused	rs.w	1				;cleared by ScoutingReport, never read
matchuphome	rs.w	1				; matchup screen: home team
matchupvis	rs.w	1				;the visitors player of the matchup; also the scroll limit of StatsReport
homerating	rs.w	1				; home team rating
visrating	rs.w	1				; visiting team rating
advframe	rs.w	1				; advantage meter frame
advcount	rs.w	1				; advantage meter count
matchuptimer	rs.w	1			; matchup screen timer
matchupslot	rs.w	1				; matchup screen slot
;DispAttribCtr to TestList are not in 93G order: 94 moved them, and the addresses here are 94's
DispAttribCtr	rs.w	1			; stats screens: attribute page / sort column
playoffscroll equ DispAttribCtr		;reused: playoff screen scroll position
scoutcolumn equ DispAttribCtr		;reused: scouting report column
titlescrollspeed equ DispAttribCtr	;reused: title screen attribute display counter
VertLineScrolling	rs.w	1		; scouting report: text line being drawn, -1 = none
PlayerScrollCtr	rs.w	1			; scouting report: scroll step per frame (RAM
SelectedPlayerIdx	rs.w	1		; scouting report: index into TestList (RAM shared with the stats screens)
ScoutingReportTimer	rs.w	1		;scouting report: frames elapsed, the text typing delay (94 had typedelay)
screentimer	rs.w	1				; frames left on a screen (ScoutingReport); last cursor row.
TestList	rs.w	122				; scouting report: list of the lines to show (also the line editor cursor
arenaanimchars	rs.w	1			; arena animation characters
arenaframe	rs.w	1				; arena animation frame
arenaframeidx	rs.w	1			; arena animation frame index
arenaframetime	rs.w	1			; arena animation frame time
arenaanim	rs.w	1				; arena animation
arenaframelist	rs.l	1			; arena animation frame list pointer
arenaspritelist	rs.l	1			; arena sprite list pointer
faceoffanim	rs.w	3				; faceoff animation state
cursoron	rs.w	1				; cursor visible
facelcwait	rs.w	1				; wait value, set to $FFFF by the logic
SongNum	rs.w	1					; current song number
HmTeam	rs.w	1					; home team
SongIndex	rs.w	1				; song index
OvrDivisor	rs.w	1				; overall rating divisor
OvrDividend	rs.w	1				; overall rating dividend
homehotcoldsave	rs.w	208			;clearTeamStats keeps the home hot / cold table (tmstruct+tmHotCold)
									;here
awayhotcoldsave	rs.w	208			;the same for the awtmstruct table
sopath	rs.w	1					; shootout path
sopathpoint	rs.w	1				; shootout path point
sopathx	rs.w	1					; shootout path x
sopathy	rs.w	1					; shootout path y
sopathdir	rs.w	1				; passdir at the end of the shootout path
sopathend	rs.w	1				; shootout path end
picturebuf	rs.w	577				;UnpackPicture output: tile count word, then the 4 bit tiles
									;(DrawMatchupBitmap, dobitmap read it)
picturebits	rs.l	1				;UnpackPicture: the 3 packed bytes of the row being unpacked
homepresses	rs.l	1				; home team button presses
homedirpresses	rs.l	1			; home team direction presses
awaypresses	rs.l	1				; away team button presses
awaydirpresses	rs.l	1			; away team direction presses
replayicontimer	rs.w	1			; replay icon timer
TmpPuckX	rs.l	1				; temporary puck x
lognametext	rs.w	9				;the unused TerminateLogName's GetLogName String text (length word at -2)
songdelay	rs.w	1				; frames until the delayed song starts
delayedsong	rs.w	1				; song waiting to start
shootoutdelay	rs.w	1			; Frames before the shootout ends
PuckZCntr	rs.w	1				; Frames the puck has hung at one height
waitxpad	rs.w	1				; pad used by the wait routine
TmpPuckZ	rs.w	1				; puckz last frame
inputjoy	rs.w	1				; joypad input
TmpJoyPuckCarrier	rs.w	1		; temporary joypad puck carrier
PlayerChked	rs.l	1				; player being checked
PlayerChking	rs.l	1			; player checking
hoticonchars	rs.w	1			; First vram char of the hot icon (ScoutingReport, HotIconMap)
coldiconchars	rs.w	1			; First vram char of the cold icon (ColdIconMap)
iconplayer	rs.w	1				; icon player
iconx	rs.w	1					; icon x position
scoutwait	rs.l	1				; scouting report wait
replaydelay	rs.w	1				; replay delay
PALflag	rs.w	4230				; nonzero on a PAL console
	rs.w	1						;the word at Stack
; ----------------------------------



