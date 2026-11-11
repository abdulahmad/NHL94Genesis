; HOCKEY.BIN scouting file load, $24C12-$24D65.
; SDK $6044 with d7=$D, then d7=1 d0=0, then d7=3.
; Adds the returned pointer to the directory longs. $47CFC is the
; script base. $47D54 is the Ron Barr picture. cdstart.asm follows.
; See docs/segacd_announce.md.

ScoutingReportTextPtr	equ	$47CFC
GameSetUpMapPtr	equ	$47D00
GameSetUpMap2Ptr	equ	$47D04
EASportsBGMapPtr	equ	$47D0C
FramerMapPtr	equ	$47D10
RinktilelistPtr	equ	$47D18
BigFontMapPtr	equ	$47D38
SmallFontMapPtr	equ	$47D3C
TeamblocksmapPtr	equ	$47D44
TeamBitmapsPtr	equ	$47D48
ArrowsmapPtr	equ	$47D50
RonBarrMapPtr	equ	$47D54
PrintFont2MapPtr	equ	$47D70
SetupMenuMapPtr	equ	$47D74
SetupFramerMapPtr	equ	$47D78
LogoBoxMapPtr	equ	$47D7C
FeaturedPicturesPtr	equ	$47D88
TeamLogoBitmapsPtr	equ	$47D8C
StanleyCupSpritePtr	equ	$47D94
HotMapPtr	equ	$47D98
ColdMapPtr	equ	$47D9C
ScoutingSpeechClipsPtr	equ	$47DA4

	org	$24C12

	tst.w	$3FC0A.l
	beq.b	L24C20
	jsr	$376F2.l
L24C20	move.w	#$D,d7
	jsr	$6044.w
	movem.l	d0-d2/d7/a0-a1,-(sp)
	move.w	#$1,d7
	move.w	#$0,d0
	jsr	$6044.w
	move.l	a0,$47D60.l
	movem.l	(sp)+,d0-d2/d7/a0-a1
	move.w	#$3,d7
	jsr	$6044.w
	movea.l	$47D60.l,a0
	move.l	a0,d0
	move.l	(a0)+,(ScoutingReportTextPtr).l
	add.l	d0,(ScoutingReportTextPtr).l
	move.l	(a0)+,(TeamLogoBitmapsPtr).l
	add.l	d0,(TeamLogoBitmapsPtr).l
	move.l	(a0)+,(FeaturedPicturesPtr).l
	add.l	d0,(FeaturedPicturesPtr).l
	move.l	(a0)+,(ScoutingSpeechClipsPtr).l
	add.l	d0,(ScoutingSpeechClipsPtr).l
	move.l	(a0)+,(SmallFontMapPtr).l
	add.l	d0,(SmallFontMapPtr).l
	move.l	(a0)+,(HotMapPtr).l
	add.l	d0,(HotMapPtr).l
	move.l	(a0)+,(ColdMapPtr).l
	add.l	d0,(ColdMapPtr).l
	move.l	(a0)+,(ArrowsmapPtr).l
	add.l	d0,(ArrowsmapPtr).l
	move.l	(a0)+,(BigFontMapPtr).l
	add.l	d0,(BigFontMapPtr).l
	move.l	(a0)+,(FramerMapPtr).l
	add.l	d0,(FramerMapPtr).l
	move.l	(a0)+,(RonBarrMapPtr).l
	add.l	d0,(RonBarrMapPtr).l
	move.l	(a0)+,(PrintFont2MapPtr).l
	add.l	d0,(PrintFont2MapPtr).l
	move.l	(a0)+,(EASportsBGMapPtr).l
	add.l	d0,(EASportsBGMapPtr).l
	move.l	(a0)+,$47D08.l
	add.l	d0,$47D08.l
	move.l	(a0)+,(SetupFramerMapPtr).l
	add.l	d0,(SetupFramerMapPtr).l
	move.l	(a0)+,(TeamblocksmapPtr).l
	add.l	d0,(TeamblocksmapPtr).l
	move.l	(a0)+,(LogoBoxMapPtr).l
	add.l	d0,(LogoBoxMapPtr).l
	move.l	(a0)+,(TeamBitmapsPtr).l
	add.l	d0,(TeamBitmapsPtr).l
	move.l	(a0)+,(StanleyCupSpritePtr).l
	add.l	d0,(StanleyCupSpritePtr).l
	move.l	(a0)+,(RinktilelistPtr).l
	add.l	d0,(RinktilelistPtr).l
	move.l	(a0)+,(GameSetUpMapPtr).l
	add.l	d0,(GameSetUpMapPtr).l
	move.l	(a0)+,(SetupMenuMapPtr).l
	add.l	d0,(SetupMenuMapPtr).l
	move.l	(a0)+,(GameSetUpMap2Ptr).l
	add.l	d0,(GameSetUpMap2Ptr).l
