;	HOCKEY.BIN $D1D4-$D2B5 (runtime $281D4-$282B5): scout94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	Part 1 of scout94 (part 2 is scout94_2.asm; $D2B6-$D397 between them is src/segacd/scoutopen.asm).
;	The matchup screen is the cartridge code.

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

TeamList	equ	$1B00C
ReadCrowdRecord	equ	$2258E
CopyString	equ	$25818
AppendNumber	equ	$2582E
AppendUserName	equ	$25DE8
appstring	equ	$39208

	org	$281D4

;	Scouting report. This file shows the pregame matchups screen with its pages of team text,
;	ratings, pictures and positions, and marks which team has the advantage.

ScoutCrowdRecord					;The text player's '@' (UpdateScoutingDisplay): return a1 = the home
									;team's crowd record in dB as a String at TempBuffer (SRAM team record
									;crpeak, 80 if 0). ReadCrowdRecord reads the 16 byte SRAM record of team
									;d1 (CrowdRecBase + d1 * 16) to a0
	movem.l	d0-d7/a0/a2-a6,-(sp)
	move.w	(HomeTeam).l,d1
	ext.l	d1
	movea.l	#teamrecbuf,a0			;SRAM team record buffer
	move.l	a0,-(sp)
	jsr	(ReadCrowdRecord).l			;read the HomeTeam record
	movea.l	(sp)+,a0
	movea.l	#TempBuffer,a1
	clr.w	d0
	move.b	crpeak(a0),d0			;crowd record
	bne.w	.0
	move.b	#$50,d0					;none saved: 80 dB
.0									;crowd record ready
	move.l	a1,-(sp)
	jsr	(AppendNumber).l			;d0 as a decimal String at a1
	movea.l	(sp)+,a1
	movem.l	(sp)+,d0-d7/a0/a2-a6
	rts
ScoutCrowdRecordBy					;unused: return a1 = 'by <name> ' for the home team's crowd record (SRAM
									;record crpeakuser = name number, AppendUserName reads that 12 char name
									;from namelog), or an empty String if crpeakuser is 0
	movem.l	d0-d7/a0/a2-a6,-(sp)
	move.w	(HomeTeam).l,d1
	ext.l	d1
	movea.l	#teamrecbuf,a0			;SRAM team record buffer
	move.l	a0,-(sp)
	jsr	(ReadCrowdRecord).l			;read the HomeTeam record
	movea.l	(sp)+,a0
	tst.b	crpeakuser(a0)
	beq.w	.0
	movea.l	#ThreeStars,a3
	movea.l	#ScoutByTxt,a1
	move.l	a3,-(sp)
	jsr	(CopyString).l				;copy the String at a1 to a3: 'by '
	movea.l	(sp)+,a3
	clr.w	d2
	move.b	crpeakuser(a0),d2
	movea.l	#TempBuffer,a1
	bset.b	#7,(sflags6).l
	bsr.w	AppendUserName
	jsr	(appstring).l				;append the name
	movea.l	#ScoutSpaceTxt,a1
	jsr	(appstring).l
	movea.l	a3,a1					;a1 = 'by <name> '
	bra.w	.x
.0									;no name: empty text
	movea.l	#ScoutEmptyTxt,a1
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0/a2-a6
	rts
ScoutEmptyTxt	String	''			;empty String: no name number in the crowd record
ScoutByTxt	String	'by '			;start of the "by <name> " String
ScoutSpaceTxt	String	' '			;space after the name
GetTeamCity							;unused: return a1 = the city String of team byte tmATOP(a0) (TeamList,
									;Teamname offset)
	movem.l	d0-d7/a0/a2-a6,-(sp)
	clr.w	d2
	move.b	$A(a0),d2
	asl.w	#2,d2
	movea.l	#TeamList,a1
	movea.l	(a1,d2.w),a1
	adda.w	Teamname(a1),a1
	movem.l	(sp)+,d0-d7/a0/a2-a6
	rts
