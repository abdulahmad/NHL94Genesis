; HOCKEY.BIN scouting report text player, $2486C-$24C09 (was scouttext.asm + scouttok.asm).
; InitScoutingDisplay, UpdateScoutingDisplay and ScrollDisplayUp of the cartridge
; (setup94.asm), the same code. Disc changes: the script is a loaded file
; (ScoutingReportText is a pointer, the cartridge uses the address of the script) and the
; paragraph offset comes from scoutparaoff instead of the cartridge's line-skip loop.
; The local labels are the cartridge's (.9-.30). See docs/segacd_announce.md.

	include	segacd\hockey.inc

	org	$2486C

InitScoutingDisplay					;start the text player: VertLineScrolling = -1, PlayerScrollCtr = -1, clear
									;SelectedPlayerIdx / ScoutingReportTimer; return a0 = TestList.
									;Called from ScoutingReport
	move.w	#$FFFF,(VertLineScrolling).l
	move.w	#$FF00,(PlayerScrollCtr).l
	clr.w	(SelectedPlayerIdx).l
	clr.w	(ScoutingReportTimer).l
	movea.l	#TestList,a0
	rts
UpdateScoutingDisplay				;text player for ScoutingReport: prints the script word by word with a
									;typing delay (ScoutingReportTimer, longer after , and .). $D ends a line;
									;special characters insert team data. Called from ScoutingReport
	cmpi.w	#$1000,(ScoutingReportTimer).l
	bgt.w	rtss2
	tst.w	(asv).l
	bmi.w	.0
	subi.w	#$1,(ScoutingReportTimer).l
	bpl.w	rtss2
.0									;time for the next letter
	movea.l	(ScoutingReportText).l,a1
	moveq	#$0,d0
	move.w	(PlayerScrollCtr).l,d0
	cmpi.w	#$FF00,d0
	bne.w	.3
	clr.w	(scoutcolumn).l
	move.w	(SelectedPlayerIdx).l,d0
	addi.w	#$2,(SelectedPlayerIdx).l
	movea.l	#TestList,a0
	move.w	(a0,d0.w),d0
	bpl.w	.1
	move.w	#$7FFF,(ScoutingReportTimer).l
	move.w	#$1E0,(screentimer).l
	rts
.1									;d0 >= 0
	bsr.w	ScrollDisplayUp
	move.l	(scoutparaoff).l,d0
.3									;line start found
	lea.l	(a1,d0.l),a2
	move.w	#$A,(ScoutingReportTimer).l
	move.w	(scoutcolumn).l,d0
	cmpi.b	#$5F,(a2)
	beq.w	.29
	cmpi.b	#$2B,(a2)
	beq.w	.27
	cmpi.b	#$24,(a2)
	beq.w	.20
	cmpi.b	#$7B,(a2)
	beq.w	.29
	cmpi.b	#$7D,(a2)
	beq.w	.28
	cmpi.b	#$5B,(a2)
	beq.w	.23
	cmpi.b	#$5D,(a2)
	beq.w	.22
	cmpi.b	#$3C,(a2)
	beq.w	.16
	cmpi.b	#$3E,(a2)
	beq.w	.17
	cmpi.b	#$7C,(a2)
	beq.w	.18
	cmpi.b	#$5C,(a2)
	beq.w	.19
	cmpi.b	#$40,(a2)
	beq.w	.9
	cmpi.b	#$23,(a2)
	beq.w	.10
	cmpi.b	#$25,(a2)
	beq.w	.11
	cmpi.b	#$3D,(a2)
	beq.w	.12
	cmpi.b	#$2A,(a2)
	beq.w	.13
	cmpi.b	#$5E,(a2)
	beq.w	.14
	cmpi.b	#$3B,(a2)
	beq.w	.15
	move.w	#$FF00,(PlayerScrollCtr).l
	movea.l	#TextBuffer,a0
	clr.w	d1
.2	cmpi.b	#$21,(a2)
	bne.w	.2b
	addq.l	#$3,a2
.2b	cmpi.b	#$D,(a2)
	beq.w	.print
	addi.w	#$1,d0
.loop3	move.b	(a2),(a0)+
	addi.w	#$1,d1
	cmpi.b	#$2C,(a2)
	beq.w	.4
	cmpi.b	#$2E,(a2)
	bne.w	.5
.4	addi.w	#$28,(ScoutingReportTimer).l
.5	cmpi.b	#$20,(a2)+
	bne.w	.2
	cmpi.b	#$20,(a2)
	beq.w	.6
	bra.w	.6a
.6	addi.w	#$14,(ScoutingReportTimer).l
	addq.l	#$1,a2
	bra.w	.loop3
.6a	subi.w	#$1,d0
	cmpa.l	a2,a1
	ble.w	.6b
	move.w	#$FF00,(PlayerScrollCtr).l
	bra.b	.print
.6b	suba.l	a1,a2
	move.w	a2,(PlayerScrollCtr).l
.print								;print the word
	move.w	d1,(mesarea).l
	addi.w	#$2,(mesarea).l
	btst	#$0,d1
	beq.w	.7
	clr.b	(a0)
	addi.w	#$1,(mesarea).l
.7	movea.l	#mesarea,a1
.loop4								;each line
	cmpi.w	#$1D,d0
	ble.w	.8
	bsr.w	ScrollDisplayUp
.8	bsr.w	printz
	; printz string: length word, then CC_Font1 ($FF), x=9, y=4
	dc.w	$0006
	dc.b	$FF,$09,$04,$00
	move.w	(scoutcolumn).l,d0
	add.w	d0,(printx).l
	move.w	(VertLineScrolling).l,d0
	add.w	d0,(printy).l
	bsr.w	print
	add.w	d1,(scoutcolumn).l
	rts
.9									;a2 = $40, crowd record
	jsr	(ScoutCrowdRecord).l
	bra.w	.append
.10									;a2 = $23
	jsr	(PlayedByHome).l
	bra.w	.append
.11									;a2 = $25
	jsr	(PlayedByAway).l
	bra.w	.append
.12									;a2 = $3D, home nickname
	move.l	a2,-(sp)
	movea.l	#tmstruct,a2
	jsr	(GetTeamNickname).l
	movea.l	(sp)+,a2
	bra.w	.append
.13									;a2 = $2A, away nickname
	move.l	a2,-(sp)
	movea.l	#awtmstruct,a2
	jsr	(GetTeamNickname).l
	movea.l	(sp)+,a2
	bra.w	.append
.14									;a2 = $5E, home arena
	move.l	a2,-(sp)
	movea.l	#tmstruct,a2
	jsr	(GetTeamArena).l
	movea.l	(sp)+,a2
	bra.w	.append
.15									;a2 = $3B, away arena
	move.l	a2,-(sp)
	movea.l	#awtmstruct,a2
	jsr	(GetTeamArena).l
	movea.l	(sp)+,a2
	bra.w	.append
.16									;a2 = $3C
	jsr	(NextHomeHotPlayer).l
	bra.w	.roster
.17									;a2 = $3E
	jsr	(NextAwayHotPlayer).l
	bra.w	.roster
.18									;a2 = $7C
	jsr	(NextHomeColdPlayer).l
	bra.w	.roster
.19									;a2 = $5C
	jsr	(NextAwayColdPlayer).l
	bra.w	.roster
.20									;a2 = $24
	movea.l	#tmstruct,a1
	tst.w	(awayhotter).l
	beq.w	.21
	movea.l	#awtmstruct,a1
.21	movea.l	tmdata(a1),a1
	adda.w	Teamname(a1),a1
	bra.w	.append
.22									;a2 = $5D
	movea.l	#awtmstruct,a1
	bra.w	.24
.23									;a2 = $5B
	movea.l	#tmstruct,a1
.24	move.w	tmgoalie(a1),d1
.roster	movea.l	tmdata(a1),a1
	adda.w	$0(a1),a1
	bra.w	.26
.loop5	adda.w	(a1),a1
	adda.w	#pldsize,a1
.26	dbra	d1,.loop5
	bra.w	.append
.27									;a2 = $2B
	movea.l	(AwayTeamRosterPtr).l,a1
	adda.w	Teamname(a1),a1
	bra.w	.append
.28									;a2 = $7D
	movea.l	(AwayTeamRosterPtr).l,a1
	bra.w	.30
.29									;a2 = $5F or a2 = $7B
	movea.l	(HomeTeamRosterPtr).l,a1
.30	adda.w	Teamname(a1),a1
.append									;append the text
	addi.w	#$1,(PlayerScrollCtr).l
	add.w	(a1),d0
	subi.w	#$1,d0
	move.w	(a1),d1
	subi.w	#$2,d1
	tst.b	$1(a1,d1.w)
	bne.w	.loop4
	subi.w	#$1,d1
	bra.w	.loop4
ScrollDisplayUp						;next text line: VertLineScrolling + 1; at 7 lines, scroll the 8 rows up
									;by vram dma (DoDMA_nd2)
	clr.w	(scoutcolumn).l
	addi.w	#$1,(VertLineScrolling).l
	cmpi.w	#$7,(VertLineScrolling).l
	blt.w	rtss2
	subi.w	#$1,(VertLineScrolling).l
	movem.l	d0-d3,-(sp)
	moveq	#$7,d3
	move.w	(VmMAP1).l,d1
	addi.w	#$212,d1
.loop	moveq	#$3A,d0
	move.w	d1,d2
	addi.w	#$80,d2
	move.w	sr,-(sp)
	move.w	#$2700,sr
	jsr	(DoDMA_nd2).l
	move.w	(sp)+,sr
	move.w	d2,d1
	dbra	d3,.loop
	movem.l	(sp)+,d0-d3
	rts
