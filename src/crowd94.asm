;	The crowd and hot players. This file runs the crowd meter, with the arena record and the
;	crowd noise, checks the corners of the wall, and keeps the tables of which players are hot or
;	cold that the player ratings and the matchups screen use.

LoadCrowdRec						;CrowdRecord = the arena record of HomeTeam from save RAM (ReadCrowdRecord
									;into the buffer at ThreeStars), $50 when none. Called from StartGame
	movem.l	d0-d7/a0-a6,-(sp)		;save
	move.w	(HomeTeam).w,d1			;home team
	ext.l	d1						;long
	movea.l	#recordbuf,a0			;record buffer
	jsr	(ReadCrowdRecord).l			;its crowd records
	move.b	crpeak(a0),d0			;the arena's loudest crowd so far
	beq.w	.none					;no record yet: use $50
	andi.w	#$FF,d0					;byte
	bra.w	.ex						;store
.none								;no record: $50 dB
	move.w	#$50,d0					;$50 dB
.ex									;CrowdRecord = record or $50
	move.w	d0,(CrowdRecord).w		;store it
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
Crowd_Noise							;The crowd meter each frame: crowd noise on / off (sflags5 bit 7) from
									;CwdExciteLvl against
									;CrowdRecord / CrowdAvg, and every $14 ticks CurCrowdMeter (sqrt(level *
									;4) + 65 dB) and CrowdPeak. Called from setvideo
	btst	#sfhor,(sflags).w		;screen is in horizontal mode
	bne.w	.ex1					;no crowd noise in horizontal mode
	btst	#0,(gmode2).w			;gmode2 bit 0: no crowd noise
	bne.w	.ex1
	btst	#sf3llcs,(sflags3).w	;check if game paused
	bne.w	.ex2
	btst	#7,(sflags5).w			;noise on?
	bne.w	.chkoff					;noise on: check whether to stop it
	tst.w	(crowdnoisedelay).w		;noise off: wait out the delay first
	beq.w	.chkon					;delay over: maybe start the noise
	subq.w	#1,(crowdnoisedelay).w	;count down
	bpl.w	.ex1					;still waiting
	clr.w	(crowdnoisedelay).w		;0
.ex2								;paused: leave the meter alone
	rts								;return
.chkon								;start the noise once the excitement passes ((record - $49)^2 / 4 + 6)
	move.w	(CrowdRecord).w,d0		;arena record
	move.w	d0,(CrowdAvg).w			;CrowdAvg = record - $B: the level where the noise stops
	subi.w	#$B,(CrowdAvg).w		;lower the average by $B
	subi.w	#$49,d0					;minus $49
	muls.w	d0,d0					;squared
	asr.l	#2,d0					;/ 4
	addq.w	#6,d0					;plus 6
	cmp.w	(CwdExciteLvl).w,d0		;excitement past it?
	bgt.w	.ex1					;not loud enough yet
	bset	#7,(sflags5).w			;noise on
	rts								;return
.chkoff								;noise on: stop it when the excitement drops below (CrowdAvg - $41)^2 / 4
	move.w	(CrowdAvg).w,d0			;average
	subi.w	#$41,d0					;minus $41
	muls.w	d0,d0					;squared
	asr.l	#2,d0					;/ 4
	cmp.w	(CwdExciteLvl).w,d0		;excitement below it?
	blt.w	.meter					;still loud: keep it on
	bclr	#7,(sflags5).w			;noise off
.meter								;noise decided: update the meter every $14 ticks
	sub.w	d7,(CwdChkCntr).w		;d7 = ticks this frame
	bpl.w	.ex1					;not yet
	move.w	#$14,(CwdChkCntr).w		;restart the countdown
	addq.w	#1,(CwdChkCnt).w		;count the check
	move.w	(CwdExciteLvl).w,d0		;meter = sqrt(level * 4) + $41 (65 dB)
	ext.l	d0						;long
	asl.w	#2,d0					;times 4
	jsr	(Sroot).l					;square root
	addi.w	#$41,d0					;plus $41
	move.w	d0,(CurCrowdMeter).w	;meter value
	cmp.w	(CrowdPeak).w,d0		;above the peak?
	ble.w	.chkrec					;not louder than the game peak
	move.w	d0,(CrowdPeak).w		;new peak
.chkrec								;peak kept or set: compare with the arena record
	move.w	(CurCrowdMeter).w,d0	;meter
	cmp.w	(CrowdRecord).w,d0		;below the record?
	blt.w	.stack					;yes
	bra.w	.stack					;(the record test has no effect: both paths go to .stack)
.stack								;empty save and restore, left from the original
	movem.l	d0-d7/a0-a6,-(sp)
	movem.l	(sp)+,d0-d7/a0-a6
.ex1								;nothing to do this frame
	rts								;return
stopna2								;Slow Xvel and Yvel of a3 toward 0 by $7D0. Called from goalieacc
	tst.w	Xvel(a3)				;moving left?
	bpl.w	.xp						;moving right (or still): slow toward 0 from above
	addi.w	#$7D0,Xvel(a3)			;slow it
	bmi.w	.y						;still moving left: next the Y speed
	clr.w	Xvel(a3)				;stop
.xp									;moving right: slow toward 0 (the left path also falls in here after its
									;clear)
	subi.w	#$7D0,Xvel(a3)			;slow it
	bpl.w	.y						;still moving right: next the Y speed
	clr.w	Xvel(a3)				;stop
.y									;now the same for Yvel
	tst.w	Yvel(a3)				;moving up?
	bpl.w	.yp						;moving down (or still)
	addi.w	#$7D0,Yvel(a3)			;slow it
	bmi.w	.ex						;still moving up: done
	clr.w	Yvel(a3)				;stop
.yp									;moving down: slow toward 0 (the up path also falls in here after its
									;clear)
	subi.w	#$7D0,Yvel(a3)			;slow it
	bpl.w	.ex						;still moving down: done
	clr.w	Yvel(a3)				;stop
.ex									;exit (also the end of the code above)
	rts								;return
checkcornercoll						;210 = blue line to the end of the rink, corner radius 64. Corner circles
									;and side walls for object a3 at d2 / d3 (wcradiusx / wcradiusy); a hit
									;goes to wallcollb. Called from wallcollduringcheck.
	bclr	#pf3wall,pflags3(a3)	;clear the wall collision bit
	move.w	#Sideline,d4			;sideline
	sub.w	(wcradiusx).w,d4		;wcradiusx
	move.w	#$12A,d5				;ywall
	sub.w	(wcradiusy).w,d5		;wcradiusy
	movem.w	d2-d5,-(sp)				;save the walls
	neg.w	d4						;d4/d5 = the negative edges, moved in by the corner radius
	neg.w	d5						;negated
	addi.w	#$40,d4					;'@'   ; radius
	addi.w	#$40,d5					;plus the radius
	cmp.w	d5,d3					;past the top corner start: maybe the top corners
	bgt.w	.ctc					;top corners
	cmp.w	d4,d2					;left of the corner circle centre: a corner
	blt.w	.circle					;bottom left corner
	neg.w	d4						;right side
	cmp.w	d4,d2					;right of it?
	bgt.w	.circle					;right of the right corner circle: a corner
	bra.w	.exit					;between the corners: no corner hit
.ctc								;beyond the positive corner start
	neg.w	d5						;top edge
	cmp.w	d5,d3					;below it?
	blt.w	.exit					;not in a corner zone
	cmp.w	d4,d2					;left of the corner?
	blt.w	.circle					;yes
	neg.w	d4						;right side
	cmp.w	d4,d2					;right of it?
	bgt.w	.circle					;yes
	bra.w	.exit					;no corner hit
.circle								;in a corner zone: distance from the circle centre
	sub.w	d4,d2					;dx
	sub.w	d5,d3					;dy
	move.w	d3,d0					;cos0 = dy/r
	move.w	d2,d1					;sin0 = -dx/r
	neg.w	d1						;negated
	muls.w	d3,d3					;dy squared
	muls.w	d2,d2					;dx squared
	add.l	d2,d3					;dist from dot
	cmp.l	#$1000,d3				;.radius^2 = $1000
	bls.w	.exit					;inside the radius: no corner hit
	exg	d0,d3						;r = sqrt(dx^2 + dy^2)
	jsr	(Sroot).l					;square root
	exg	d0,d3						;d3 = r
	ext.l	d0						;cos and sin as 8.8 fractions
	asl.l	#8,d0					;cos * 256
	divs.w	d3,d0					;/ r
	ext.l	d1						;long
	asl.l	#8,d1					;sin * 256
	divs.w	d3,d1					;/ r
	bsr.w	cornercollb				;bounce off the corner
.exit								;no corner (or corner done): pop the walls
	movem.w	(sp)+,d2-d5				;restore the walls
	move.w	Wallcos(a3),d0			;wallcos(a3)
	or.w	Wallsin(a3),d0			;wallsin(a3)
	bne.w	.rtss3					;a corner was hit already: done
	move.w	#$100,d0				;now check side walls
	clr.w	d1						;sin 0
	cmp.w	d5,d3					;past the end wall (top)
	bge.w	cornercollb				;top wall
	neg.w	d5						;past the bottom end wall
	neg.w	d0						;bottom normal
	cmp.w	d5,d3					;past the bottom?
	ble.w	cornercollb				;yes
	exg	d0,d1						;side walls: normal along X
	cmp.w	d4,d2					;past the right?
	bge.w	cornercollb				;past the right side wall
	neg.w	d4						;left side
	neg.w	d1						;left normal
	cmp.w	d4,d2					;past the left side wall
	ble.w	cornercollb				;yes
.rtss3								;no wall hit
	rts								;return
cornercollb							;Thunk: jmp wallcollb
	jmp	wallcollb					;wall bounce
Create_HotCold_Table				;Fill the hot / cold table (tmHotCold) of team struct a0: 16 bytes for
									;each of the 26 roster players, random -9 ... 8 (randomd0s). Called from
									;StartGame and ScoutingReport, once for each team struct
	movem.l	d0-d7,-(sp)				;save
	move.w	#tmPerGoals-tmHotCold-1,d1	;loop count: the table size (26 x 16 bytes)
HotColdLoop							;The Create_HotCold_Table loop
	move.w	#9,d0					;sets RNG limit (-9 - +8)
	jsr	(randomd0s).l
	move.l	a0,-(sp)				;save
	adda.l	#tmHotCold,a0			;offset to Hot/Cold table
	move.b	d0,0(a0,d1.w)			;random value into this slot
	movea.l	(sp)+,a0				;restore
	dbf	d1,HotColdLoop				;loop
	movem.l	(sp)+,d0-d7				;restore
	rts								;return
Clamp0to100							;unused: clamp d3 to 0 ... 100
	tst.w	d3						;below 0?
	bpl.w	.chkmax					;not negative: check the top
	clr.w	d3						;0
	rts								;return
.chkmax								;d3 not negative: check the maximum
	cmp.w	#$64,d3					;over 100?
	ble.w	.x						;no
	move.w	#$64,d3					;100
.x									;d3 in range
	rts								;return
AttributeCalc						;Attribute d3 of player a3 * 5 plus his hot / cold value / 3, limited to 0
									;... $1E. Called from setplayer
	movem.l	d0-d2/a1,-(sp)			;save
	move.w	(TempWord2).w,d1		;TempWord2 goes to d1
	movea.l	#tmstruct,a1			;Start of Home Team struct
	btst	#pfteam,pflags(a3)		;Check if home or away
	beq.w	.attribmath				;home team: struct at tmstruct
.away								;away team: the next struct
	adda.l	#tmsize,a1				;shift to start of Away Team struct
.attribmath							;team struct chosen: find the player's hot / cold slot
	clr.w	d1						;clear
	move.b	pnum(a3),d1				;move roster offset into d1
	asl.w	#4,d1					;shifts d1 4 bits left, moving the values over 1 nibble
	adda.l	#tmHotCold,a1			;a1 points to Hot/Cold Table Start
	move.b	0(a1,d1.w),d1			;move data at add. (a1 + d1) into d1
	ext.w	d1						;sign-extend word. Ex: F5 (-5) -> FFF5
	ext.l	d1						;sign-extend long word. Ex: FFF5 -> FFFFFFF5
	divs.w	#3,d1					;Signed-Div D1 by 3 (FFFFFFF5 / 3, or -5 / 3 = -1r2, or FFFEFFFF Remainder
									;is 4 MS Nibbles, result is 4 LS Nibbles)
	move.w	d3,-(sp)				;push d3 onto stack
	asl.w	#2,d3					;shift left 2 bits (mult. by 4)
	add.w	(sp)+,d3				;Pop off d3 value and add to d3 (attrib X 5)
	add.w	d1,d3					;add d1 (H/C value) to d3
	bmi.w	.LowerLimit				;below 0: clamp to 0
.UpperLimitCheck					;not below 0: check the top
	cmp.w	#$1E,d3					;check if above upper limit (1E or 30 decimal)
	blt.w	.MaskAttribMathResult
.UpperLimit							;above $1D: clamp to $1E
	move.w	#$1E,d3					;if above, set to 1E
	bra.w	.MaskAttribMathResult
.LowerLimit							;below 0
	clr.w	d3						;if below lower limit (0), set to 0
.MaskAttribMathResult				;value in range
	andi.w	#$FF,d3					;pass only lower byte
	movem.l	(sp)+,d0-d2/a1			;restore
	rts								;return
NextHomeHotPlayer					;d1 = the next home hot player (homehotidx index into the list at
									;homehotplayer), a1 = tmstruct. Called from ScoutTextPlayer (the MATCHUPS
									;text)
	movem.l	d0/a0,-(sp)				;save
	movea.l	#homehotplayer,a0		;home hot list
	move.w	(homehotidx).w,d0		;index
	add.w	d0,d0					;word index
	move.w	0(a0,d0.w),d1			;the next entry of the list
	cmpi.w	#0,(homehotidx).w		;index stays 0 when already 0 or more
	bge.w	.x						;yes: stay
	addq.w	#1,(homehotidx).w		;next
.x									;(the index never moves past entry 0)
	movem.l	(sp)+,d0/a0				;restore
	movea.l	#tmstruct,a1			;home team struct
	rts								;return
NextAwayHotPlayer					;The same for the away team (awayhotplayer, awayhotidx), a1 = AwShots.
									;Called from ScoutTextPlayer
	movem.l	d0/a0,-(sp)				;save
	movea.l	#awayhotplayer,a0		;away hot list
	move.w	(awayhotidx).w,d0		;index
	add.w	d0,d0					;word index
	move.w	0(a0,d0.w),d1			;d1 = the player
	cmpi.w	#0,(awayhotidx).w		;0 or more?
	bge.w	.x						;yes: stay
	addq.w	#1,(awayhotidx).w		;next
.x									;pop the d0/a0 saved above
	movem.l	(sp)+,d0/a0				;restore
	movea.l	#AwShots,a1				;away team struct
	rts								;return
	rts								;unreferenced
BuildHotColdLists					;Build the hot / cold player lists of both teams (SortHotColdStarters,
									;CopyHottestPlayer, CopyColdestPlayer). Called from ScoutingReport
	clr.w	(awayhotidx).w			;away index 0
	clr.w	(homehotidx).w			;home index 0
	movem.l	d0-d7/a0-a6,-(sp)		;save
	movea.l	#tmstruct,a0			;home team struct
	bsr.w	SortHotColdStarters		;sort its starters
	movea.l	#homehotplayer,a0		;home hot list
	bsr.w	CopyHottestPlayer		;copy the hottest
	movea.l	#homecoldplayer,a0		;home cold list
	bsr.w	CopyColdestPlayer		;copy the coldest
	movea.l	#AwShots,a0				;away team struct
	bsr.w	SortHotColdStarters		;sort its starters
	movea.l	#awayhotplayer,a0		;away hot list
	bsr.w	CopyHottestPlayer		;copy the hottest
	movea.l	#awaycoldplayer,a0		;away cold list
	bsr.w	CopyColdestPlayer		;copy the coldest
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
SortHotColdStarters					;Sum the hot / cold values of the 6 starters of team a0 into TempBuffer
									;(byte pairs: player, sum), then sort them by sum
	movem.l	d0-d7/a0-a6,-(sp)		;save
	movea.l	a0,a2					;team struct
	adda.l	#tmHotCold,a2			;its hot / cold table
	movea.l	tmdata(a0),a0			;team data
	adda.w	LineSets(a0),a0			;its lines
	movea.l	#TempBuffer,a1			;pair buffer
	move.w	#5,d0					;6 starters
.player								;each starter
	move.b	(a0)+,d1
	subq.b	#1,d1					;roster slots are 1-based
	move.b	d1,(a1)+
	ext.w	d1
	asl.w	#4,d1					;16 hot / cold bytes per player
	clr.b	(a1)
	addq.w	#3,d1					;start at byte 3
	move.w	#3,d7					;from byte 3
.attrib								;sum the bytes of this player
	clr.w	d2						;clear
	move.b	0(a2,d1.w),d2			;hot / cold byte
	cmp.b	#9,d7					;byte 9?
	beq.w	.nextattr				;skip bytes 9 and $D
	cmp.b	#$D,d7					;byte $D?
	beq.w	.nextattr				;yes: skip
	add.b	d2,(a1)					;add it
.nextattr							;byte added (or skipped)
	addq.w	#1,d1					;next byte
	addq.w	#1,d7					;next
	cmp.b	#$10,d7					;past byte $F?
	bne.s	.attrib					;up to byte $F
	tst.b	(a1)+					;next pair
	dbf	d0,.player					;loop
.sort								;bubble sort the 6 pairs by sum, hottest first
	movea.l	#TempBuffer,a1			;pair buffer
	clr.w	d1						;no swap yet
	move.w	#4,d0					;5 compares
.cmp								;compare a pair with the next
	move.b	3(a1),d6				;next sum
	cmp.b	1(a1),d6				;above this one?
	ble.w	.next					;in order: no swap
	st	d1							;swapped: d1 set, sort again
	move.w	2(a1),d2				;swap the pairs
	move.w	(a1),2(a1)
	move.w	d2,(a1)
.next								;next pair
	tst.w	(a1)+					;next pair
	dbf	d0,.cmp						;loop
	tst.w	d1
	bne.s	.sort					;repeat until no swap
	movem.l	(sp)+,d0-d7/a0-a6		;restore
	rts								;return
NextHomeColdPlayer					;d1 = the next home cold player (homecoldidx, homecoldplayer), a1 =
									;tmstruct. Called from ScoutTextPlayer
	movem.l	d0/a0,-(sp)				;save
	movea.l	#homecoldplayer,a0		;home cold list
	move.w	(homecoldidx).w,d0		;index
	add.w	d0,d0					;word index
	move.w	0(a0,d0.w),d1			;d1 = the player
	cmpi.w	#0,(homecoldidx).w		;index stays 0 when already 0 or more
	bge.w	.x						;yes: stay
	addq.w	#1,(homecoldidx).w		;next
.x									;(the index never moves past entry 0)
	movem.l	(sp)+,d0/a0				;restore
	movea.l	#tmstruct,a1			;home team struct
	rts								;return
NextAwayColdPlayer					;The same for the away team (awaycoldidx, awaycoldplayer), a1 = AwShots.
									;Called from ScoutTextPlayer
	movem.l	d0/a0,-(sp)				;save
	movea.l	#awaycoldplayer,a0		;away cold list
	move.w	(awaycoldidx).w,d0		;index
	add.w	d0,d0					;word index
	move.w	0(a0,d0.w),d1			;d1 = the player
	cmpi.w	#0,(awaycoldidx).w		;index stays 0 when already 0 or more
	bge.w	.x						;yes: stay
	addq.w	#1,(awaycoldidx).w		;next
.x									;(the index never moves past entry 0)
	movem.l	(sp)+,d0/a0				;restore
	movea.l	#AwShots,a1				;away team struct
	rts								;return
	rts								;unreferenced
CopyHottestPlayer					;Copy the hottest player of TempBuffer to the list at a0
	movem.l	d0-d1/a0-a1,-(sp)		;save
	movea.l	#TempBuffer,a1			;pair buffer
	move.w	#0,d0					;copy 1 entry
.copy								;byte 0 = 0, byte 1 = player
	clr.b	(a0)+					;0
	move.b	(a1),d1					;player
	move.b	d1,(a0)+				;store it
	tst.w	(a1)+					;next pair
	dbf	d0,.copy					;loop
	movem.l	(sp)+,d0-d1/a0-a1		;restore
	rts								;return
CopyColdestPlayer					;Copy the coldest player (TempBuffer+10) to the list at a0
	movem.l	d0/a0-a1,-(sp)			;save
	movea.l	#TempBuffer+10,a1		;the last pair is the coldest
	move.w	#0,d0
.copy								;byte 0 = 0, byte 1 = player
	clr.b	(a0)+					;0
	move.b	(a1),(a0)+				;player
	tst.w	-(a1)					;back a pair
	dbf	d0,.copy					;loop
	movem.l	(sp)+,d0/a0-a1			;restore
	rts								;return
CompareHotColdTotals				;Compare the teams' hot / cold totals (GetHotColdTotal into TempWord1 /
									;TempWord2): awayhotter = 1 when the away total is
									;higher; d0 = -1, $22 or $23 by the difference (ScoutingReport text
									;"Lately ... has been playing (extremely) well")
	movem.l	d1-d7/a0-a6,-(sp)		;save
	movea.l	#tmstruct,a0			;home team struct
	bsr.w	GetHotColdTotal			;its total
	move.w	d1,(TempWord1).w		;save it
	movea.l	#AwShots,a0				;away team struct
	bsr.w	GetHotColdTotal			;its total
	move.w	d1,(TempWord2).w		;save it
	move.w	(TempWord1).w,d1		;home total
	move.w	(TempWord2).w,d2		;away total
	sub.w	d1,d2					;d2 = away total - home total
	move.w	#0,(awayhotter).w		;home hotter
	tst.w	d2
	bmi.w	.abs					;home hotter: awayhotter stays 0
	move.w	#1,(awayhotter).w		;away hotter
.abs								;d2 = the difference, made positive
	tst.w	d2						;negative?
	bpl.w	.level					;no
	neg.w	d2						;make it positive
.level								;pick the text by how big the gap is
	move.w	#$FFFF,d0				;no text
	cmp.w	#$5E,d2					;small gap?
	blt.w	.x						;small gap: no text
	move.w	#$22,d0					;"Lately" text
	cmp.w	#$BD,d2					;big gap?
	blt.w	.x						;big gap: "extremely" well
	move.w	#$23,d0					;"extremely" text
.x									;exit: restore the registers
	movem.l	(sp)+,d1-d7/a0-a6		;restore
	rts								;return
GetHotColdTotal						;d1 = the hot / cold total of the starters of
									;team a0 (SortHotColdStarters)
	bsr.w	SortHotColdStarters
	move.w	#6,d0					;7 sums (starters + the extra slot)
	movea.l	#TempBuffer,a0			;pair buffer
	clr.w	d1						;clear
.sum								;add the sum byte of each pair
	move.b	1(a0),d2				;sum byte
	ext.w	d2						;word
	add.w	d2,d1					;add it
	tst.w	(a0)+					;next pair
	dbf	d0,.sum						;loop
	rts								;return
