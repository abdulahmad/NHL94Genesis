ResetCardTimer						;Reset the player card timer cardtimer to $AA ($53 if C was pressed).
									;Called from ReadSetupPads, PrintOptions and PlayerCardTimer
	move.w	#$AA,$1939E.l		;normal wait
	btst	#$5,$19390.l		;C held (bit 5): use the shorter wait
	beq.w	.ex
	move.w	#$53,$1939E.l		;shorter wait
.ex	rts
PlayerCardTimer						;Player cards, called each frame from ReadSetupPads in the first minute of
									;its wait. When carddelay runs out set setupcardflags bit 0; then count
									;cardtimer down (C skips $50); at $52 switch sides (bit 1), forget the
									;logos and draw the next card (PlayerCardScreen); below 0 restart the
									;timer (ResetCardTimer)
	subi.w	#$1,$193A2.l		;count down the start delay
	bpl.w	.ex
	move.w	#$FFFF,$193A2.l		;keep it run out
	bset	#$0,$19390.l		;first run out: the cards may start
	btst	#$0,$19390.l		;cards allowed?
	beq.w	.ex
	btst	#$5,$19390.l		;C held?
	beq.w	.next
	cmpi.w	#$52,$1939E.l		;timer below $52?
	bge.w	.next
	subi.w	#$50,$1939E.l		;skip $50 of the wait
.next	subi.w	#$1,$1939E.l
	bmi.w	.next2		;timer ran out: start the next cycle
	cmpi.w	#$52,$1939E.l
	bne.w	.ex		;only at $52 is a new card drawn
	bclr	#$2,$19390.l		;clear setupcardflags bits 2 and 3
	bclr	#$3,$19390.l
	bchg	#$1,$19390.l		;the next card goes on the other side
	st.b	$1938C.l
	st.b	$1938E.l
	bclr	#$6,$19390.l
	bclr	#$7,$19390.l
	jsr	(PlayerCardScreen).l
.ex	rts
.next2	jmp	(ResetCardTimer).l

PlayerCardScreen						;Draw a player card on one side. setupcardflags bit 1 set: visitors, logo
									;box and picture on the left (column 3), text frame at $B; clear: home,
									;logo box and picture on the right ($1C), text frame at 3. Shows featured
									;player featuredplayer (0-5, from the FeaturedPictures list of the team;
									;next one after each visitors card), his number and name, and with SRAM
									;his user records (PrintRecordValue, PrintRecordHolder, PrintRecordVs).
									;Called from PlayerCardTimer
	movem.l	d0-d7/a0-a6,-(sp)
	jsr	(printz).l
	String	CC_Font1,$0,$0		;x3
	move.w	#$1C,(printx).l		;visitors: erase the other logo box at $1C
	btst	#$1,$19390.l		;which side?
	bne.w	.0
	move.w	#$3,(printx).l		;home: erase the one at 3
.0	move.w	#$5,(printy).l
	move.w	#$8,d0		;clear the 8 x 8 logo area
	move.w	#$8,d1
	move.w	#$7FF,d2		;blank char
	jsr	(eraser).l
	jsr	(printz).l
	String	CC_Font1,$0,$0		;x3
	move.w	#$3,(printx).l
	btst	#$1,$19390.l
	bne.w	.1
	move.w	#$B,(printx).l
.1	move.w	#$5,(printy).l
	move.w	#$19,d0		;clear the 25 x 8 card area
	move.w	#$8,d1
	move.w	#$7FF,d2		;blank char
	jsr	(eraser).l
	btst	#$1,$19390.l		;which side?
	bne.w	.2
	bsr.w	TeamLogoBitmapsEnd		;home logo box
	bra.w	.3
.2	bsr.w	DrawLogoBoxHomeLeft
	addi.w	#$1,$193A0.l		;each visitors card moves to the next featured player
.3	jsr	(printz).l
	String	CC_Font1,$0,$0		;x3 / add.b
	cmpi.w	#$6,$193A0.l
	blt.w	.4
	clr.w	$193A0.l		;back to the first picture
.4	move.w	(HomeTeam).l,d0
	move.w	#$1D,(printx).l
	btst	#$1,$19390.l		;which side?
	beq.w	.5
	move.w	(VisTeam).l,d0
	move.w	#$4,(printx).l
.5	move.w	#$6,(printy).l
	move.w	(homepicchars).l,d4
	move.w	$193A0.l,d3
	mulu.w	#$6,d3		;6 bytes per entry: picture.l + roster index.w
	asl.w	#$2,d0		;team number * 4 to index the list of team lists
	movea.l	$47D88.l,a0		;pictures of each team: picture.l, roster index.w entries
	movea.l	(a0,d0.w),a0		;this team's list
	move.w	$4(a0,d3.w),$19396.l
	movea.l	(a0,d3.w),a0		;the picture
	movea.l	a0,a1		;a1 = picture header
	movea.l	a0,a2
	adda.l	(a2)+,a0		;a0 = the picture's tile data
	movea.l	#PicturePalette,a0
	adda.l	(a0),a0
	tst.l	(a2)		;no map: the PicturePalette one
	bne.w	.6
	movea.l	#PicturePalette,a1
	adda.l	$4(a1),a1
	tst.l	(a2)+		;skip the map offset
	bra.w	.7
.6	adda.l	(a2)+,a1
.7	bsr.w	UnpackPicture
	movea.l	#picturebuf,a2
	move.w	(ScoutSubStatus).l,d3		;current frame
.loop	cmp.w	(ScoutSubStatus).l,d3
	beq.w	.loop
	move.w	#$6,d3
	move.w	#$6,d2
	clr.w	d0
	clr.w	d1
	move.l	$BBCD2.l,-(sp)		;keep palette colors $22-$29: dobitmap overwrites them
	move.l	$BBCD6.l,-(sp)
	move.w	#$2,d5
	jsr	(dobitmap).l
	move.l	(sp)+,$BBCD6.l
	move.l	(sp)+,$BBCD2.l
	jsr	(printz).l
	String	CC_Font1Pri,$0,$0		;(the routine here)
	move.w	#$6000,(printa).l
	move.w	#$3,(printx).l
	move.w	#$19,d0
	btst	#$1,$19390.l		;which side?
	beq.w	.8
	move.w	#$B,(printx).l
	move.w	#$19,d0
.8	move.w	#$5,(printy).l
	move.w	#$8,d1
	move.w	(printx).l,$193A4.l		;text inside the frame starts one in and one down
	addi.w	#$1,$193A4.l
	move.w	(printy).l,$193A6.l
	addi.w	#$1,$193A6.l
	jsr	(Framer).l
	move.w	$193A4.l,(printx).l		;text inside the frame
	move.w	$193A6.l,(printy).l
	move.w	#$0,(printa).l
	move.w	#$0,$18D5E.l
	move.w	(HomeTeam).l,d0
	btst	#$1,$19390.l		;which side?
	beq.w	.9
	move.w	(VisTeam).l,d0
.9	move.w	d0,$193A8.l
	movea.l	#TeamList,a2
	asl.w	#$2,d0
	movea.l	(a2,d0.w),a2
	adda.w	$0(a2),a2		;a2 = first player record of the team
	move.w	$19396.l,d0		;skip cardroster players to reach the featured one
	bra.w	.next
.loop2	adda.w	(a2),a2
	adda.w	#$8,a2
.next	dbra	d0,.loop2
	movea.l	#mesarea,a3
	lea.l	$2(a3),a1		;text after the header
	move.w	#$6,(a3)		;string header: 6 = print mode
	move.l	a2,-(sp)		;keep the player record
	adda.w	(a2),a2
	move.b	(a2),d0
	ext.w	d0
	jsr	(ConvertByteToDigits).l
	move.w	#$2000,$4(a3)
	movea.l	(sp)+,a1
	jsr	(appstring).l
	movea.l	a3,a1
	bset	#$3,(sflags6).l
	jsr	(printsmall).l
	bclr	#$3,(sflags6).l		;normal font
	movea.l	#mesarea,a1
	move.w	$193A8.l,d0
	move.w	$19396.l,d1
	tst.w	$193BA.l
	bmi.w	.fade
	jsr	(UpdateRecordsCopyName).l
	cmpi.w	#$2,(a1)		;PrintRecordValue left an empty string: no records to show
	beq.w	.fade
	move.w	$193A4.l,(printx).l		;left edge of the text
	addi.w	#$2,(printy).l		;two rows down
	bset	#$3,(sflags6).l		;card font
	jsr	(printsmall).l
	bclr	#$3,(sflags6).l		;normal font
	movea.l	#mesarea,a1
	move.w	$193A8.l,d0
	move.w	$19396.l,d1
	movea.l	#$C45C,a0
	jsr	(PrintRecordHolder).l
	move.w	$193A4.l,(printx).l
	cmpi.w	#$2,(a1)		;no record holder: skip the line
	beq.w	.11
	addi.w	#$1,(printy).l
	bset	#$3,(sflags6).l		;card font
	jsr	(printsmall).l
	bclr	#$3,(sflags6).l		;normal font
.11	movea.l	#mesarea,a1
	move.w	$193A8.l,d0
	move.w	$19396.l,d1
	movea.l	#$C45C,a0
	jsr	(PrintRecordVs).l
	move.w	$193A4.l,(printx).l		;left edge of the text
	addi.w	#$1,(printy).l
	bset	#$3,(sflags6).l		;card font
	jsr	(printsmall).l
	bclr	#$3,(sflags6).l		;normal font
.fade	move.w	#$64,(palcount).l		;fade the palette in over $64 frames
	movem.l	(sp)+,d0-d7/a0-a6
	rts
; Player card screen: draws the portrait when the slot is in use.
PlayerCardDrawPortrait
	tst.w	$34(a2)
	beq.w	.ex
	movem.l	d0-d7,-(sp)
	move.w	$0(a2),d2
	move.w	$14(a2),d3
	move.w	$4A(a2),$17CF4.l
	addi.w	#$17,$17CF4.l
	move.w	$4C(a2),$17CF6.l
	addi.w	#$17,$17CF6.l
	movem.l	a0-a6,-(sp)
	exg.l	a2,a3
	jsr	(checkcornercoll).l
	exg.l	a2,a3
	movem.l	(sp)+,a0-a6
	movem.l	(sp)+,d0-d7
.ex	rts
; Player card screen: draws the stat block of the selected player.
PlayerCardDrawStats
	bclr	#$5,(sflags6).l
	tst.w	$17BE0.l
	bmi.w	.ex2
	movem.l	d0/a0,-(sp)
	movea.l	#$17480,a0
	move.w	$17BE0.l,d0
	asl.w	#$7,d0
	adda.w	d0,a0
	move.w	$14(a0),d0
	btst	#$7,$62(a0)
	bne.w	.next2
	neg.w	d0
.next2	cmpi.w	#$58,d0
	blt.w	.next3
	cmpi.w	#$47,$0(a0)
	bgt.w	.next3
	cmpi.w	#$FFB9,$0(a0)
	blt.w	.next3
	bset	#$5,(sflags6).l
.next3	movem.l	(sp)+,d0/a0
.ex2	rts
TeamPalettes						;Matchup and player card palettes: 56 of 16 colors, two per team (28
									;teams, TeamList order). A is the matchup logo palette (the
									;TeamLogoPalettes
									;entry, except BOS, FLA, HFD, SJ), B the other side (A with colors 1-2 and
									;3-4 swapped). Used by TeamIcons and the player cards
		dc.w	$0EEA,$0000,$0042,$0EEA		;ANH matchup logo palette
; Palette data after TeamPalettes: 12 colour words ($0EEA,$0EEE,$0000,$0888 ...).
	dc.w	$0EEA,$0EEE,$0000,$0888
	dc.w	$0AAA,$0068,$008A,$00CE
	dc.w	$0260,$0040,$0664,$0E8E
		dc.w	$0EEA,$0EEA,$0EEA,$0000		;ANH other side
; Palette data after TeamPalettes: 12 colour words ($0042,$0EEE,$0000,$0888 ...).
	dc.w	$0042,$0EEE,$0000,$0888
	dc.w	$0AAA,$0068,$008A,$00CE
	dc.w	$0260,$0040,$0664,$0E8E
		dc.w	$0EE8,$0000,$008C,$0EE8		;BOS matchup logo palette
; Palette data after TeamPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0C8C ...).
	dc.w	$0EE8,$0EEE,$0000,$0C8C
	dc.w	$008C,$0888,$0068,$0846
	dc.w	$0044,$0422,$08CE,$02AE
		dc.w	$0EE8,$0EE8,$0EE8,$0000		;BOS other side
; Palette data after TeamPalettes: 12 colour words ($008C,$0EEE,$0000,$0C8C ...).
	dc.w	$008C,$0EEE,$0000,$0C8C
	dc.w	$008C,$0888,$0068,$0846
	dc.w	$0044,$0422,$08CE,$02AE
		dc.w	$0EE8,$0822,$008C,$0EE8		;BUF matchup logo palette
; Palette data after TeamPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0EC8 ...).
	dc.w	$0EE8,$0EEE,$0000,$0EC8
	dc.w	$048C,$0C88,$006C,$0866
	dc.w	$0268,$0224,$0620,$00CE
		dc.w	$0EE8,$0EE8,$0EE8,$0822		;BUF other side
; Palette data after TeamPalettes: 12 colour words ($008C,$0EEE,$0000,$0EC8 ...).
	dc.w	$008C,$0EEE,$0000,$0EC8
	dc.w	$048C,$0C88,$006C,$0866
	dc.w	$0268,$0224,$0620,$00CE
		dc.w	$0EE8,$0006,$008C,$0EE8		;CGY matchup logo palette
; Palette data after TeamPalettes: 12 colour words ($0EE8,$0EEE,$0000,$08EE ...).
	dc.w	$0EE8,$0EEE,$0000,$08EE
	dc.w	$02CE,$02AE,$026E,$000C
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0EE8,$0EE8,$0006		;CGY other side
; Palette data after TeamPalettes: 12 colour words ($008C,$0EEE,$0000,$08EE ...).
	dc.w	$008C,$0EEE,$0000,$08EE
	dc.w	$02CE,$02AE,$026E,$000C
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0000,$0006,$0EE8		;CHI matchup logo palette
; Palette data after TeamPalettes: 12 colour words ($0EE8,$0EEE,$0000,$08EE ...).
	dc.w	$0EE8,$0EEE,$0000,$08EE
	dc.w	$0A8E,$04AC,$0A88,$046C
	dc.w	$0226,$0644,$022E,$0262
		dc.w	$0EE8,$0EE8,$0EE8,$0000		;CHI other side
; Palette data after TeamPalettes: 12 colour words ($0006,$0EEE,$0000,$08EE ...).
	dc.w	$0006,$0EEE,$0000,$08EE
	dc.w	$0A8E,$04AC,$0A88,$046C
	dc.w	$0226,$0644,$022E,$0262
		dc.w	$0EE8,$0000,$0042,$0EE8		;DAL matchup logo palette
; Palette data after TeamPalettes: 12 colour words ($0EE8,$0EEE,$0000,$08AA ...).
	dc.w	$0EE8,$0EEE,$0000,$08AA
	dc.w	$0688,$0488,$0466,$0244
	dc.w	$0260,$0020,$0ACC,$0000
		dc.w	$0EE8,$0EE8,$0EE8,$0000		;DAL other side
; Palette data after TeamPalettes: 12 colour words ($0042,$0EEE,$0000,$08AA ...).
	dc.w	$0042,$0EEE,$0000,$08AA
	dc.w	$0688,$0488,$0466,$0244
	dc.w	$0260,$0020,$0ACC,$0000
		dc.w	$0EE8,$0006,$0006,$0EE8		;DET matchup logo palette
; Palette data after TeamPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0C8E ...).
	dc.w	$0EE8,$0EEE,$0000,$0C8E
	dc.w	$086E,$044E,$082E,$020E
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0EE8,$0EE8,$0006		;DET other side
; Palette data after TeamPalettes: 12 colour words ($0006,$0EEE,$0000,$0C8E ...).
	dc.w	$0006,$0EEE,$0000,$0C8E
	dc.w	$086E,$044E,$082E,$020E
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0600,$004A,$0EE8		;EDM matchup logo palette
; Palette data after TeamPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0CEA ...).
	dc.w	$0EE8,$0EEE,$0000,$0CEA
	dc.w	$0A8E,$08A8,$044E,$0488
	dc.w	$002E,$0440,$0400,$0EE8
		dc.w	$0EE8,$0EE8,$0EE8,$0600		;EDM other side
; Palette data after TeamPalettes: 12 colour words ($004A,$0EEE,$0000,$0CEA ...).
	dc.w	$004A,$0EEE,$0000,$0CEA
	dc.w	$0A8E,$08A8,$044E,$0488
	dc.w	$002E,$0440,$0400,$0EE8
		dc.w	$0EEA,$004A,$0600,$0EEA		;FLA matchup logo palette
; Palette data after TeamPalettes: 12 colour words ($0EEA,$0EEE,$0000,$000A ...).
	dc.w	$0EEA,$0EEE,$0000,$000A
	dc.w	$0004,$0046,$008E,$0CEE
	dc.w	$0466,$0442,$0EC6,$0200
		dc.w	$0EEA,$0EEA,$0EEA,$004A		;FLA other side
; Palette data after TeamPalettes: 12 colour words ($0600,$0EEE,$0000,$000A ...).
	dc.w	$0600,$0EEE,$0000,$000A
	dc.w	$0004,$0046,$008E,$0CEE
	dc.w	$0466,$0442,$0EC6,$0200
		dc.w	$0EE8,$0042,$0822,$0EE8		;HFD matchup logo palette
; Palette data after TeamPalettes: 12 colour words ($0EE8,$0EEE,$0000,$00E8 ...).
	dc.w	$0EE8,$0EEE,$0000,$00E8
	dc.w	$04C4,$0A8A,$00A2,$0466
	dc.w	$0600,$0224,$0EE8,$0EE8
		dc.w	$0EE8,$0EE8,$0EE8,$0042		;HFD other side
; Palette data after TeamPalettes: 12 colour words ($0822,$0EEE,$0000,$00E8 ...).
	dc.w	$0822,$0EEE,$0000,$00E8
	dc.w	$04C4,$0A8A,$00A2,$0466
	dc.w	$0600,$0224,$0EE8,$0EE8
		dc.w	$0EE8,$0000,$0000,$0EE8		;LA matchup logo palette
; Palette data after TeamPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0AAA ...).
	dc.w	$0EE8,$0EEE,$0000,$0AAA
	dc.w	$0888,$0666,$0444,$0222
	dc.w	$0CCC,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0EE8,$0EE8,$0000		;LA other side
; Palette data after TeamPalettes: 12 colour words ($0000,$0EEE,$0000,$0AAA ...).
	dc.w	$0000,$0EEE,$0000,$0AAA
	dc.w	$0888,$0666,$0444,$0222
	dc.w	$0CCC,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0600,$0006,$0EE8		;MTL matchup logo palette
; Palette data after TeamPalettes: 12 colour words ($0EE8,$0EEE,$0000,$088E ...).
	dc.w	$0EE8,$0EEE,$0000,$088E
	dc.w	$026E,$0C68,$002E,$0A24
	dc.w	$0EAA,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0EE8,$0EE8,$0600		;MTL other side
; Palette data after TeamPalettes: 12 colour words ($0006,$0EEE,$0000,$088E ...).
	dc.w	$0006,$0EEE,$0000,$088E
	dc.w	$026E,$0C68,$002E,$0A24
	dc.w	$0EAA,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0020,$0006,$0EE8		;NJ matchup logo palette
; Palette data after TeamPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0AAA ...).
	dc.w	$0EE8,$0EEE,$0000,$0AAA
	dc.w	$000A,$0888,$000C,$0022
	dc.w	$0006,$0CCC,$0EE8,$0EE8
		dc.w	$0EE8,$0EE8,$0EE8,$0020		;NJ other side
; Palette data after TeamPalettes: 12 colour words ($0006,$0EEE,$0000,$0AAA ...).
	dc.w	$0006,$0EEE,$0000,$0AAA
	dc.w	$000A,$0888,$000C,$0022
	dc.w	$0006,$0CCC,$0EE8,$0EE8
		dc.w	$0EE8,$0822,$004A,$0EE8		;NYI matchup logo palette
; Palette data after TeamPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0AA8 ...).
	dc.w	$0EE8,$0EEE,$0000,$0AA8
	dc.w	$066E,$0864,$022C,$062A
	dc.w	$0008,$0622,$0222,$0A8E
		dc.w	$0EE8,$0EE8,$0EE8,$0822		;NYI other side
; Palette data after TeamPalettes: 12 colour words ($004A,$0EEE,$0000,$0AA8 ...).
	dc.w	$004A,$0EEE,$0000,$0AA8
	dc.w	$066E,$0864,$022C,$062A
	dc.w	$0008,$0622,$0222,$0A8E
		dc.w	$0EE8,$0600,$0006,$0EE8		;NYR matchup logo palette
; Palette data after TeamPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0AAA ...).
	dc.w	$0EE8,$0EEE,$0000,$0AAA
	dc.w	$0C86,$002E,$0C60,$0844
	dc.w	$0444,$0840,$0008,$0EC8
		dc.w	$0EE8,$0EE8,$0EE8,$0600		;NYR other side
; Palette data after TeamPalettes: 12 colour words ($0006,$0EEE,$0000,$0AAA ...).
	dc.w	$0006,$0EEE,$0000,$0AAA
	dc.w	$0C86,$002E,$0C60,$0844
	dc.w	$0444,$0840,$0008,$0EC8
		dc.w	$0EE8,$0006,$006A,$0EE8		;OTW matchup logo palette
; Palette data after TeamPalettes: 12 colour words ($0EE8,$0EEE,$0000,$068A ...).
	dc.w	$0EE8,$0EEE,$0000,$068A
	dc.w	$0688,$0466,$0244,$022C
	dc.w	$0228,$0008,$0AAA,$0004
		dc.w	$0EE8,$0EE8,$0EE8,$0006		;OTW other side
; Palette data after TeamPalettes: 12 colour words ($006A,$0EEE,$0000,$068A ...).
	dc.w	$006A,$0EEE,$0000,$068A
	dc.w	$0688,$0466,$0244,$022C
	dc.w	$0228,$0008,$0AAA,$0004
		dc.w	$0EE8,$0000,$004A,$0EE8		;PHI matchup logo palette
; Palette data after TeamPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0CCC ...).
	dc.w	$0EE8,$0EEE,$0000,$0CCC
	dc.w	$088E,$0AAA,$046E,$006E
	dc.w	$0888,$0666,$002E,$0444
		dc.w	$0EE8,$0EE8,$0EE8,$0000		;PHI other side
; Palette data after TeamPalettes: 12 colour words ($004A,$0EEE,$0000,$0CCC ...).
	dc.w	$004A,$0EEE,$0000,$0CCC
	dc.w	$088E,$0AAA,$046E,$006E
	dc.w	$0888,$0666,$002E,$0444
		dc.w	$0EE8,$0000,$008C,$0EE8		;PIT matchup logo palette
; Palette data after TeamPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0AAA ...).
	dc.w	$0EE8,$0EEE,$0000,$0AAA
	dc.w	$088A,$066A,$04EE,$0464
	dc.w	$0440,$02CE,$0244,$0AEE
		dc.w	$0EE8,$0EE8,$0EE8,$0000		;PIT other side
; Palette data after TeamPalettes: 12 colour words ($008C,$0EEE,$0000,$0AAA ...).
	dc.w	$008C,$0EEE,$0000,$0AAA
	dc.w	$088A,$066A,$04EE,$0464
	dc.w	$0440,$02CE,$0244,$0AEE
		dc.w	$0EE8,$0600,$0006,$0EE8		;QUE matchup logo palette
; Palette data after TeamPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0C00 ...).
	dc.w	$0EE8,$0EEE,$0000,$0C00
	dc.w	$000E,$0E44,$0ECE,$0E80
	dc.w	$088E,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0EE8,$0EE8,$0600		;QUE other side
; Palette data after TeamPalettes: 12 colour words ($0006,$0EEE,$0000,$0C00 ...).
	dc.w	$0006,$0EEE,$0000,$0C00
	dc.w	$000E,$0E44,$0ECE,$0E80
	dc.w	$088E,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0000,$0860,$0EE8		;SJ matchup logo palette
; Palette data after TeamPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0860 ...).
	dc.w	$0EE8,$0EEE,$0000,$0860
	dc.w	$0642,$0888,$0CA8,$0ACC
	dc.w	$02AE,$006E,$0048,$046A
		dc.w	$0EE8,$0EE8,$0EE8,$0000		;SJ other side
; Palette data after TeamPalettes: 12 colour words ($0860,$0EEE,$0000,$0860 ...).
	dc.w	$0860,$0EEE,$0000,$0860
	dc.w	$0642,$0888,$0CA8,$0ACC
	dc.w	$02AE,$006E,$0048,$046A
		dc.w	$0EE8,$0822,$006A,$0EE8		;STL matchup logo palette
; Palette data after TeamPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0602 ...).
	dc.w	$0EE8,$0EEE,$0000,$0602
	dc.w	$024C,$0002,$0026,$0068
	dc.w	$0428,$086E,$0EE8,$0EE8
		dc.w	$0EE8,$0EE8,$0EE8,$0822		;STL other side
; Palette data after TeamPalettes: 12 colour words ($006A,$0EEE,$0000,$0602 ...).
	dc.w	$006A,$0EEE,$0000,$0602
	dc.w	$024C,$0002,$0026,$0068
	dc.w	$0428,$086E,$0EE8,$0EE8
		dc.w	$0EE8,$0000,$0600,$0EE8		;TB matchup logo palette
; Palette data after TeamPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0C86 ...).
	dc.w	$0EE8,$0EEE,$0000,$0C86
	dc.w	$0E84,$0A84,$0C44,$0822
	dc.w	$0E20,$0600,$0A00,$0EA8
		dc.w	$0EE8,$0EE8,$0EE8,$0000		;TB other side
; Palette data after TeamPalettes: 12 colour words ($0600,$0EEE,$0000,$0C86 ...).
	dc.w	$0600,$0EEE,$0000,$0C86
	dc.w	$0E84,$0A84,$0C44,$0822
	dc.w	$0E20,$0600,$0A00,$0EA8
		dc.w	$0EE8,$0600,$0600,$0EE8		;TOR matchup logo palette
; Palette data after TeamPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0ECA ...).
	dc.w	$0EE8,$0EEE,$0000,$0ECA
	dc.w	$0AAA,$0C66,$0822,$0CCC
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0EE8,$0EE8,$0600		;TOR other side
; Palette data after TeamPalettes: 12 colour words ($0600,$0EEE,$0000,$0ECA ...).
	dc.w	$0600,$0EEE,$0000,$0ECA
	dc.w	$0AAA,$0C66,$0822,$0CCC
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0000,$008C,$0EE8		;VAN matchup logo palette
; Palette data after TeamPalettes: 12 colour words ($0EE8,$0EEE,$0000,$00CE ...).
	dc.w	$0EE8,$0EEE,$0000,$00CE
	dc.w	$006A,$004E,$0028,$0022
	dc.w	$0020,$008E,$0888,$06CE
		dc.w	$0EE8,$0EE8,$0EE8,$0000		;VAN other side
; Palette data after TeamPalettes: 12 colour words ($008C,$0EEE,$0000,$00CE ...).
	dc.w	$008C,$0EEE,$0000,$00CE
	dc.w	$006A,$004E,$0028,$0022
	dc.w	$0020,$008E,$0888,$06CE
		dc.w	$0EE8,$0006,$0600,$0EE8		;WSH matchup logo palette
; Palette data after TeamPalettes: 12 colour words ($0EE8,$0EEE,$0000,$022C ...).
	dc.w	$0EE8,$0EEE,$0000,$022C
	dc.w	$0C86,$0EA8,$088E,$0842
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0EE8,$0EE8,$0006		;WSH other side
; Palette data after TeamPalettes: 12 colour words ($0600,$0EEE,$0000,$022C ...).
	dc.w	$0600,$0EEE,$0000,$022C
	dc.w	$0C86,$0EA8,$088E,$0842
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0600,$0006,$0EE8		;WPG matchup logo palette
; Palette data after TeamPalettes: 12 colour words ($0EE8,$0EEE,$0000,$022C ...).
	dc.w	$0EE8,$0EEE,$0000,$022C
	dc.w	$0422,$0AAC,$0666,$0CAA
	dc.w	$0444,$066E,$08CE,$0226
		dc.w	$0EE8,$0EE8,$0EE8,$0600		;WPG other side
; Palette data after TeamPalettes: 12 colour words ($0006,$0EEE,$0000,$022C ...).
	dc.w	$0006,$0EEE,$0000,$022C
	dc.w	$0422,$0AAC,$0666,$0CAA
	dc.w	$0444,$066E,$08CE,$0226
		dc.w	$0EE8,$0000,$004A,$0EE8		;ASE matchup logo palette
; Palette data after TeamPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0688 ...).
	dc.w	$0EE8,$0EEE,$0000,$0688
	dc.w	$0464,$0244,$0222,$004E
	dc.w	$000A,$0022,$0AAA,$0000
		dc.w	$0EE8,$0EE8,$0EE8,$0000		;ASE other side
; Palette data after TeamPalettes: 12 colour words ($004A,$0EEE,$0000,$0688 ...).
	dc.w	$004A,$0EEE,$0000,$0688
	dc.w	$0464,$0244,$0222,$004E
	dc.w	$000A,$0022,$0AAA,$0000
		dc.w	$0EE8,$0000,$004A,$0EE8		;ASW matchup logo palette
; Palette data after TeamPalettes: 12 colour words ($0EE8,$0EEE,$0000,$0688 ...).
	dc.w	$0EE8,$0EEE,$0000,$0688
	dc.w	$0464,$0244,$0222,$004E
	dc.w	$000A,$0022,$0AAA,$0000
		dc.w	$0EE8,$0EE8,$0EE8,$0000		;ASW other side
; Palette data after TeamPalettes: 12 colour words ($004A,$0EEE,$0000,$0688 ...).
	dc.w	$004A,$0EEE,$0000,$0688
	dc.w	$0464,$0244,$0222,$004E
	dc.w	$000A,$0022,$0AAA,$0000
; Copies a record holder name and fetches the record value.
UpdateRecordsCopyName
	movem.l	d0-d7/a1-a6,-(sp)
	move.l	a1,-(sp)
	movea.l	a1,a3
	movea.l	#$257EE,a1
	movem.l	d0-d1,-(sp)
	bsr.w	CopyString
	movem.l	(sp)+,d0-d1
	bsr.w	GetRecordValue
	tst.w	d0
	bne.w	.next
	movea.l	(sp)+,a1
	move.w	#$2,(a1)
	bra.w	.next4
.next	movea.l	#TempBuffer,a1
	move.w	d0,$17E64.l
	bsr.w	AppendNumber
	movea.l	(sp),a3
	movea.l	#TempBuffer,a1
	jsr	(appstring).l
	move.w	$17E64.l,d0
	movea.l	#$25808,a1
	cmpi.w	#$1,d0
	bne.w	.next2
	movea.l	#$25810,a1
.next2	tst.w	d1
	bne.w	.next3
	movea.l	#$257F8,a1
	cmpi.w	#$1,d0
	bne.w	.next3
	movea.l	#$25800,a1
.next3	movea.l	(sp)+,a3
	jsr	(appstring).l
.next4	movem.l	(sp)+,d0-d7/a1-a6
	rts
; Data that follows PlayerCardScreen (strings, small tables)
PlayerCardScreenData	dc.b	$00,$0A,'Record ',$00,$00,$08,' goa'
	dc.b	'ls',$00,$08,' goal',$00,$00,$08,' sav'
	dc.b	'es',$00,$08,' save',$00
CopyString						;Copy String a1 (length word first) to a3
	movem.l	d0,-(sp)
	move.w	(a1),d0		;the length word counts the header too
	subi.w	#$1,d0
.loop	move.b	(a1)+,(a3)+		;copy the whole String including its length word
	dbra	d0,.loop
	movem.l	(sp)+,d0
	rts
AppendNumber						;Write d0 (0 ... 999, no leading zeros) as a String at a1, padded to an
									;even length
	movem.w	d0-d6/a0,-(sp)
	move.l	a1,-(sp)		;keep the String start
	move.w	d0,d6
	adda.l	#$2,a1		;leave room for the length word
	clr.w	d1
	ext.l	d0
	divu.w	#$64,d0		;hundreds digit
	tst.w	d0		;any hundreds?
	beq.w	.0		;no hundreds: no leading zero
	addi.w	#$30,d0
	move.b	d0,(a1)+
	addi.w	#$1,d1
.0	swap	d0
	ext.l	d0		;clear the high word
	divu.w	#$A,d0		;tens digit
	addi.w	#$30,d0
	cmpi.b	#$30,d0		;tens 0 is skipped only for values below 10
	bne.w	.1
	cmpi.w	#$A,d6		;below 10?
	blt.w	.2		;yes: no tens digit
.1	move.b	d0,(a1)+
	addi.w	#$1,d1
.2	swap	d0		;ones digit from the remainder
	addi.w	#$30,d0
	move.b	d0,(a1)+
	addi.w	#$1,d1
	btst	#$0,d1		;odd length: pad with a 0 byte so the String stays word aligned
	beq.w	.3		;even already
	move.b	#$0,(a1)+		;pad byte
	addi.w	#$1,d1
.3	movea.l	(sp)+,a0
	addi.w	#$2,d1		;length counts the 2-byte header
	move.w	d1,(a0)
	movem.w	(sp)+,d0-d6/a0
	rts
GetRecordValue						;d0 = record d0 of player d1 of team d0 from save RAM (ReadPlayerRecord
									;into M68K_RAM); d1 = 1 when the player is a goalie
	movem.l	d2-d7/a0-a6,-(sp)
	move.w	d0,-(sp)
	movea.l	#TeamList,a2
	asl.w	#$2,d0
	movea.l	(a2,d0.w),a2
	adda.w	$0(a2),a2		;a2 = the team's first player record
	move.w	d1,d0		;skip d1 records to reach the player
	bra.w	.next
.loop	adda.w	(a2),a2
	adda.w	#$8,a2
.next	dbra	d0,.loop
	move.w	d1,d0
	move.w	(sp)+,d1
	move.w	d0,d5
	move.w	d1,d4
	ext.l	d0
	movea.l	#$C45C,a0
	bsr.w	SPAlistClearFlag6		;his save record into M68K_RAM
	move.b	(a0),d0		;byte 0 = the record value
	ext.w	d0
	movea.l	#TeamList,a5
	asl.w	#$2,d4
	movea.l	(a5,d4.w),a5
	adda.w	$A(a5),a5		;the goalie nibbles in GoalieOdds give the goalie count
	move.w	(a5),d1
	movem.w	d0,-(sp)
	clr.w	d0
.loop2	addi.w	#$1,d0
	asl.w	#$4,d1		;next nibble
	bne.w	.loop2
	cmp.w	d5,d0		;roster index past the goalies: a skater
	movem.w	(sp)+,d0
	bgt.w	.1		;index below the goalie count: a goalie
	clr.w	d1		;d1 = 0: a skater
	bra.w	.x
.1	move.w	#$1,d1		;d1 = 1: a goalie
.x	movem.l	(sp)+,d2-d7/a0-a6
	rts
PrintRecordHolder						;Record holder line: RecByTxt ("by") then the holder's user name
									;(AppendRecordHolder). An empty String when there is none
	movem.l	d0-d7/a1-a6,-(sp)
	move.l	a1,-(sp)		;keep the output start
	movea.l	a1,a3
	movea.l	#$2595C,a1
	movem.l	d0-d1,-(sp)		;save team and player
	bsr.w	CopyString
	movem.l	(sp)+,d0-d1
	movea.l	#TempBuffer,a1		;holder name buffer
	bsr.w	AppendRecordHolder
	movea.l	(sp)+,a3
	cmpi.w	#$2,(a1)		;no holder name: give back an empty String
	bne.w	.0
	move.w	#$2,(a3)		;length 2 = empty String
	bra.w	.x
.0	jsr	(appstring).l		;append the name
.x	movem.l	(sp)+,d0-d7/a1-a6
	rts
; Data that follows PrintRecordHolder (strings, small tables)
PrintRecordHolderData	dc.w	$0006,$6279,$2000
PrintRecordVs						;Record line: RecVsTxt ("vs.") then the user name and the opponent team
									;(AppendRecordVs)
	movem.l	d0-d7/a1-a6,-(sp)
	move.l	a1,-(sp)		;keep the output start
	movea.l	a1,a3
	movea.l	#$25994,a1
	movem.l	d0-d1,-(sp)		;save team and player
	bsr.w	CopyString
	movem.l	(sp)+,d0-d1
	movea.l	#TempBuffer,a1
	bsr.w	AppendRecordVs		;user name and opponent
	movea.l	(sp)+,a3
	jsr	(appstring).l
	movem.l	(sp)+,d0-d7/a1-a6
	rts
; Data that follows PrintRecordVs (strings, small tables)
PrintRecordVsData	dc.b	$00,$06,'vs. '
AppendRecordHolder						;Append the user name of the record holder (byte 1 of record a0, or read
									;record d0 / d1 when a0 is 0) to a1 (AppendUserName)
	movem.l	d0-d7/a1-a2,-(sp)
	cmpa.l	#$0,a0
	bne.w	.0		;a record was passed in a0: use it
	movem.l	d0-d7/a1-a6,-(sp)
	move.w	d0,-(sp)		;swap d0 and d1
	move.w	d1,d0		;swap d0/d1 into ReadPlayerRecord's order: d0 player, d1 team
	move.w	(sp)+,d1
	ext.l	d1
	ext.l	d0
	movea.l	#$C45C,a0
	bsr.w	SPAlistClearFlag6
	movea.l	#$C45C,a0
	movem.l	(sp)+,d0-d7/a1-a6
.0	move.b	$1(a0),d2
	ext.w	d2
	bset	#$7,(sflags6).l		;bit 7 of sflags6: AppendUserName uses the record name list
	bsr.w	AppendUserName
	movem.l	(sp)+,d0-d7/a1-a2
	rts
AppendRecordVs						;Append the user name (byte 3 of record a0), a space and the opponent team
									;name (byte 2, AppendTeamName) to a1
	movem.l	d0-d7/a0-a6,-(sp)
	cmpa.l	#$0,a0
	bne.w	.0		;a record was passed in a0: use it
	movem.l	d0-d7/a1-a6,-(sp)
	move.w	d0,-(sp)		;swap d0 and d1
	move.w	d1,d0		;swap d0/d1 into ReadPlayerRecord's order: d0 player, d1 team
	move.w	(sp)+,d1
	ext.l	d1
	ext.l	d0
	movea.l	#$C45C,a0
	bsr.w	SPAlistClearFlag6
	movea.l	#$C45C,a0
	movem.l	(sp)+,d0-d7/a1-a6
.0	move.b	$3(a0),d2
	ext.w	d2
	movem.l	d0/a1,-(sp)
	bset	#$7,(sflags6).l		;record name list
	bsr.w	AppendUserName
	movea.l	a1,a3
	movea.l	#$25A4A,a1
	jsr	(appstring).l
	movem.l	(sp)+,d0/a1
	move.b	$2(a0),d0
	jsr	(AppendTeamName).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts

UpdateRecords						;With save RAM (ValidSRAM) and user records on (OptUserRec 0), update the
	
	
	
; Data that follows UpdateRecords (strings, small tables)
UpdateRecordsData	dc.w	$0004,$2000
; Starts the record update: skipped when records are off or a game is in progress.
UpdateRecordsStart
	tst.w	$193BA.l
	bmi.w	.ex
	tst.w	$18C06.l
	bne.w	.ex
	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	.next17
	bsr.w	.next18
	move.w	(HomeTeam).l,d1
	ext.l	d1
	movea.l	#ThreeStars,a0
	movea.l	#tmstruct,a2
	move.w	$193AA.l,d5
	move.w	(VisTeam).l,d6
	bsr.w	.next12
	move.w	(VisTeam).l,d1
	ext.l	d1
	movea.l	#awtmstruct,a2
	move.w	$193AC.l,d5
	move.w	(HomeTeam).l,d6
	bsr.w	.next12
	clr.w	d7
	movea.l	#tmstruct,a1
	move.w	$18BF4.l,d4
	move.w	$18BF6.l,d5
	move.w	(HomeTeam).l,d1
	move.w	(VisTeam).l,d2
	move.w	$193AA.l,d6
	ext.l	d1
	movea.l	#ThreeStars,a0
	bsr.w	.next6
	movea.l	#awtmstruct,a1
	move.w	$18BF6.l,d4
	move.w	$18BF4.l,d5
	move.w	(VisTeam).l,d1
	move.w	(HomeTeam).l,d2
	move.w	$193AC.l,d6
	ext.l	d1
	movea.l	#ThreeStars,a0
	bsr.w	.next6
	movea.l	#ThreeStars,a0
	move.w	$18BF4.l,d1
	ext.l	d1
	move.w	$18BF6.l,d2
	move.w	(HomeTeam).l,d3
	move.w	(VisTeam).l,d4
	movea.l	#tmstruct,a1
	movea.l	#awtmstruct,a2
	bsr.w	.next
	movea.l	#ThreeStars,a0
	move.w	$18BF6.l,d1
	ext.l	d1
	move.w	$18BF4.l,d2
	move.w	(VisTeam).l,d3
	move.w	(HomeTeam).l,d4
	movea.l	#awtmstruct,a1
	movea.l	#tmstruct,a2
	bsr.w	.next
	movem.l	(sp)+,d0-d7/a0-a6
.ex	rts
.next	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	ReadCrowdRecordBClearFlag6
	st.b	d7
	movem.w	d0,-(sp)
	clr.w	d0
	move.b	$A(a0),d0
	lsl.w	#$8,d0
	move.b	$B(a0),d0
	cmpi.w	#$2328,d0
	bge.w	.next3
	addi.w	#$1,d0
	move.b	d0,$B(a0)
	lsr.w	#$8,d0
	move.b	d0,$A(a0)
	move.w	$C(a1),d0
	cmp.w	$C(a2),d0
	bgt.w	.next2
	blt.w	.next3
	clr.w	d0
	move.b	$C(a0),d0
	lsl.w	#$8,d0
	move.b	$D(a0),d0
	addi.w	#$1,d0
	move.b	d0,$D(a0)
	lsr.w	#$8,d0
	move.b	d0,$C(a0)
	bra.w	.next3
.next2	clr.w	d0
	move.b	$8(a0),d0
	lsl.w	#$8,d0
	move.b	$9(a0),d0
	addi.w	#$1,d0
	move.b	d0,$9(a0)
	lsr.w	#$8,d0
	move.b	d0,$8(a0)
.next3	movem.w	(sp)+,d0
	movem.w	d0,-(sp)
	move.w	$C(a1),d0
	cmp.w	$C(a2),d0
	movem.w	(sp)+,d0
	ble.w	.next5
	move.w	$C(a1),d5
	cmp.b	$0(a0),d5
	ble.w	.next4
	st.b	d7
	move.b	d5,$0(a0)
	move.b	d3,$1(a0)
	move.b	d4,$2(a0)
	move.b	d2,$3(a0)
.next4	move.w	$C(a2),d5
	move.w	$0(a2),d6
	sub.w	d5,d6
	cmp.b	$4(a0),d6
	ble.w	.next5
	st.b	d7
	move.b	d6,$4(a0)
	move.b	d3,$5(a0)
	move.b	d4,$6(a0)
	move.b	d2,$7(a0)
.next5	bsr.w	ReadCrowdRecordBSetFlag6
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.next6	movem.l	d0-d7/a0-a6,-(sp)
	bsr.w	ReadCrowdRecord
	move.w	$C(a1),d3
	cmp.b	$0(a0),d3
	ble.w	.next7
	move.b	d3,$0(a0)
	move.b	d4,$1(a0)
	move.b	d5,$3(a0)
	move.b	d2,$2(a0)
	st.b	d7
.next7	subi.w	#$1,d6
	clr.w	d3
.loop	move.w	d6,d0
	addi.w	#$EA,d0
	move.b	(a1,d0.w),$17E62.l
	addi.w	#$FFCC,d0
	move.b	(a1,d0.w),d0
	sub.b	d0,$17E62.l
	cmp.b	$17E62.l,d3
	bge.w	.next8
	move.b	$17E62.l,d3
.next8	dbra	d6,.loop
	cmp.b	$4(a0),d3
	ble.w	.next9
	st.b	d7
	move.b	d3,$4(a0)
	move.b	d4,$5(a0)
	move.b	d5,$7(a0)
	move.b	d2,$6(a0)
.next9	cmp.w	(HomeTeam).l,d1
	bne.w	.next10
	move.b	$8(a0),d3
	andi.w	#$FF,d3
	cmp.w	$17F92.l,d3
	bge.w	.next10
	move.w	$17F92.l,d3
	st.b	d7
	move.b	d3,$8(a0)
	move.b	d4,$9(a0)
	move.b	d5,$B(a0)
	move.b	d2,$A(a0)
.next10	tst.w	d7
	beq.w	.next11
	bsr.w	ReadCrowdRecordASetFlag6
.next11	movem.l	(sp)+,d0-d7/a0-a6
	rts
.next12	clr.l	d0
	move.w	#$19,d2
.loop2	bsr.w	SPAlistClearFlag6
	cmp.w	d5,d0
	blt.w	.next13
	move.w	d0,-(sp)
	addi.w	#$B6,d0
	move.b	(a2,d0.w),d4
	move.w	(sp)+,d0
	bra.w	.next14
.next13	move.w	d0,-(sp)
	addi.w	#$EA,d0
	move.b	(a2,d0.w),d4
	addi.w	#$FFCC,d0
	sub.b	(a2,d0.w),d4
	move.w	(sp)+,d0
.next14	move.b	$0(a0),d3
	cmp.b	d3,d4
	ble.w	.next16
	move.b	d4,$0(a0)
	move.b	$18BF5.l,$1(a0)
	move.b	$18BF7.l,$3(a0)
	cmpa.l	#$1834C,a2
	beq.w	.next15
	move.b	$18BF7.l,$1(a0)
	move.b	$18BF5.l,$3(a0)
.next15	move.b	d6,$2(a0)
	bsr.w	SPAlistSetFlag6
.next16	addi.w	#$1,d0
	dbra	d2,.loop2
	rts
.next17	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a2
	jsr	(GetGoalieCount).l
	move.w	d0,$193AA.l
	movea.l	#awtmstruct,a2
	jsr	(GetGoalieCount).l
	move.w	d0,$193AC.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
.next18	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#tmstruct,a2
	jsr	(GetPlayerCount).l
	move.w	d0,$193AE.l
	movea.l	#awtmstruct,a2
	jsr	(GetPlayerCount).l
	move.w	d0,$193B0.l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
AppendUserName						;Append user name d2 (12 bytes of the name log at namelog, spaces for 0)
	
	movem.l	d0-d3/a0-a3,-(sp)
	movea.l	a1,a2
	tst.w	d2
	beq.w	.2
	move.w	#$B,d0
	clr.w	d3
	movea.l	#$1A2FC,a0
	mulu.w	#$C,d2
	adda.l	d2,a0
.loop	move.b	(a0,d3.w),d1
	bne.w	.0
	move.b	#$20,d1
.0	move.b	d1,$2(a1)
	tst.b	(a1)+
	addi.w	#$1,d3
	dbra	d0,.loop
	move.w	#$E,(a2)
	btst	#$7,(sflags6).l
	beq.w	.1
	bsr.w	TrimSpaces
.1	bra.w	.x
.2	movea.l	a1,a3
	move.l	a3,-(sp)
	movea.l	#$25E54,a1
	jsr	(CopyString).l
	movea.l	(sp)+,a2
	bsr.w	TrimSpaces
.x	movem.l	(sp)+,d0-d3/a0-a3
	rts
; Table of 2 bytes after AppendUserName, 2 bytes: $00,$02 ...
	dc.b	$00,$02	; ..
; Loads the records from the disc (loader command 9) and copies them to RAM
LoadRecordsFromDisc	movem.l	d0-d7/a0-a6,-(sp)
	move.w	#$9,d7
	jsr	$6044.w
	movea.l	#$AFF60,a0
.loop	btst.b	#$7,$FF800E.l
	bne.s	.loop
	move.l	#$0,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop2	btst.b	#$6,$FF800E.l
	beq.s	.loop2
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop3	btst.b	#$6,$FF800E.l
	bne.s	.loop3
	bclr.b	#$7,$FF800F.l
	move.l	#$3FFF,d0
.loop4	btst.b	#$7,$FF800E.l
	bne.s	.loop4
	move.w	#$16,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop5	btst.b	#$6,$FF800E.l
	beq.s	.loop5
	move.l	$FF8010.l,(a0)+
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop6	btst.b	#$6,$FF800E.l
	bne.s	.loop6
	bclr.b	#$7,$FF800F.l
	dbra	d0,.loop4
	move.l	#$27,d0
.loop7	btst.b	#$7,$FF800E.l
	bne.s	.loop7
	move.l	#$10,$FF8022.l
	move.w	#$B,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop8	btst.b	#$6,$FF800E.l
	beq.s	.loop8
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop9	btst.b	#$6,$FF800E.l
	bne.s	.loop9
	bclr.b	#$7,$FF800F.l
.loop10	btst.b	#$7,$FF800E.l
	bne.s	.loop10
	move.w	#$15,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop11	btst.b	#$6,$FF800E.l
	beq.s	.loop11
	move.w	$FF8010.l,(a0)+
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop12	btst.b	#$6,$FF800E.l
	bne.s	.loop12
	bclr.b	#$7,$FF800F.l
	dbra	d0,.loop10
	jsr	(forceblack).l
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	btst.b	#$5,$FF800F.l
	beq.b	.next
	move.w	#$1,-(a6)
	bra.b	.next2
.next	move.w	#$0,-(a6)
.next2	bclr.b	#$5,$FF800F.l
	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	move.w	$18BFE.l,d0
	move.w	$18C00.l,d1
	move.w	$18BF8.l,d2
	move.w	#$5,d7
	jsr	$6044.w
	jsr	(HotColdIconExitSetC2Load).l
	jsr	(SubCmd2DSend).l
	move.w	#$2,d0
	jsr	$5F22.w
.loop13	move.w	#$80,d0
	jsr	$5F22.w
	bcs.w	.loop13
.loop14	move.w	#$81,d0
	jsr	$5F22.w
	move.w	(a0),d2
	andi.w	#$FF00,d2
	cmpi.w	#$0,d2
	bne.s	.loop14
	move.w	#$5,$19364.l
	move.w	#$13,d0
	lea.l	$19364.l,a0
	jsr	$5F22.w
	jsr	(forceblack).l
	move.w	#$8000,d0
	move.w	#$0,d1
	movea.l	#$AFF60,a0
	jsr	(DoDMApro).l
	jsr	(SetVramQueueFlag).l
.loop15	btst.b	#$7,$FF800E.l
	bne.s	.loop15
	move.w	#$27,$FF8020.l
	bset.b	#$6,$FF800F.l
.loop16	btst.b	#$6,$FF800E.l
	beq.s	.loop16
	bset.b	#$7,$FF800F.l
	bclr.b	#$6,$FF800F.l
.loop17	btst.b	#$6,$FF800E.l
	bne.s	.loop17
	bclr.b	#$7,$FF800F.l
	movem.l	(sp)+,d0-d7/a0-a6
	move.l	a6,-(sp)
	movea.l	$19360.l,a6
	tst.w	(a6)+
	beq.b	.next3
	bset.b	#$5,$FF800F.l
	bra.b	.next4
.next3	bclr.b	#$5,$FF800F.l
.next4	move.l	a6,$19360.l
	movea.l	(sp)+,a6
	jmp	(StatsScreenFadeIn).l
AppendTeamName						;Append the city name of team d0 (TeamList block Strings) to a1
	
	movem.l	d0/a0-a3,-(sp)
	ext.w	d0
	asl.w	#$2,d0
	movea.l	#TeamList,a0
	movea.l	(a0,d0.w),a0
	move.w	$4(a0),d0
	ext.l	d0
	adda.l	d0,a0
	adda.w	(a0),a0
	movea.l	a1,a3
	movea.l	a0,a1
	jsr	(appstring).l
	movem.l	(sp)+,d0/a0-a3
	rts
CalcAttrib						;The overall rating of player d0: his attributes weighted by
	
	
	
	move.l	a6,-(sp)
	clr.w	$1A570.l
	clr.w	$1A572.l
	movea.l	#$26266,a6
	cmp.l	(PAttribOverallMask).l,d4
	bne.w	.1
	movea.l	#$26246,a6
.1	cmp.l	(GAttribOverallMask).l,d4
	bne.w	.11
	movea.l	#$26256,a6
.11	movea.l	$1E(a2),a0
	lea.l	$1A4(a2),a4
	clr.l	d1
	move.w	d0,d1
	asl.w	#$4,d1
	adda.l	d1,a4
	adda.l	#$10,a4
	adda.w	$0(a0),a0
.skip	adda.w	(a0),a0
	adda.w	#$8,a0
	dbra	d0,.skip
	clr.w	d0
	clr.w	d1
	moveq	#$F,d2
	swap	d4
.bit	btst	d2,d4
	beq.w	.next
	move.w	d2,d3
	lsr.w	#$1,d3
	neg.w	d3
	move.b	-$1(a0,d3.w),d3
	btst	#$0,d2
	beq.w	.0
	lsr.w	#$4,d3
.0	andi.w	#$F,d3
	cmpi.w	#$D,d2
	bne.w	.cont
	bra.w	.00
.cont	cmpi.w	#$6,d2
	beq.w	.00
	movem.l	d5-d7,-(sp)
	move.b	(a6,d2.w),d5
	ext.w	d5
	cmpi.w	#$2,d5
	beq.w	.000
	move.w	d3,-(sp)
	subi.w	#$2,d5
.attribadd	add.w	(sp),d3
	dbra	d5,.attribadd
	asr.w	#$1,d3
	tst.w	(sp)+
.000	movem.l	(sp)+,d5-d7
	cmpa.l	#$26266,a6
	beq.w	.2
	neg.w	d2
	move.w	d7,-(sp)
	move.b	-$1(a4,d2.w),d7
	ext.w	d7
	add.w	d7,$1A570.l
	addi.w	#$1,$1A572.l
	move.w	(sp)+,d7
	neg.w	d2
	bra.w	.00
.2	move.w	d3,-(sp)
	asl.w	#$4,d3
	add.w	(sp),d3
	add.w	(sp)+,d3
	neg.w	d2
	add.b	-$1(a4,d2.w),d3
	bpl.w	.pos
	clr.b	d3
.pos	neg.w	d2
.00	add.w	d3,d0
	addi.w	#$64,d1
.next	dbra	d2,.bit
	cmpa.l	#$26266,a6
	beq.w	.3
	move.w	#$64,d1
	movem.l	d6-d7,-(sp)
	move.w	$1A570.l,d6
	ext.l	d6
	move.w	$1A572.l,d7
	divs.w	d7,d6
	add.w	d6,d0
	movem.l	(sp)+,d6-d7
.3	cmp.w	d1,d0
	blt.w	.4
	move.w	d0,d1
	subi.w	#$1,d0
.4	movea.l	(sp)+,a6
	rts
; Rating weight table
CalcAttribFirstTable	dc.w	$0202,$0202,$0406,$0204,$0204,$0606,$0402,$0202
; Rating weight table
CalcAttribSecondTable	dc.w	$0202,$0202,$0202,$0202,$0909,$0202,$0902,$0202
; Rating weight table
CalcAttribThirdTable	dc.w	$0202,$0202,$0202,$0202,$0202,$0202,$0202,$0202
DrawPlayerPicture						;Draw the player picture (NoPicSkater1 ... NoPicGoalie2, Card<player>)
	movem.l	d0-d7/a1-a6,-(sp)
	movea.l	$47D88.l,a0
	move.w	d1,d2
	asl.w	#$2,d2
	movea.l	(a0,d2.w),a0
	move.w	#$FFFF,d2
	bra.w	.1
.loop	cmp.w	$4(a0),d0
	bne.w	.0
	movea.l	(a0),a0
	bra.w	.x
.0	adda.l	#$6,a0
.1	addi.w	#$1,d2
	tst.l	(a0)
	bne.w	.loop
	movea.l	#TeamList,a0
	asl.w	#$2,d1
	movea.l	(a0,d1.w),a0
	movea.l	a0,a6
	move.w	d0,d6
	adda.w	$0(a6),a6
	bra.w	.next
.loop2	adda.w	(a6),a6
	adda.w	#$8,a6
.next	dbra	d6,.loop2
	adda.w	(a6),a6
	adda.w	$A(a0),a0
	move.w	(a0),d1
	clr.w	d3
.loop3	addi.w	#$1,d3
	asl.w	#$4,d1
	bne.w	.loop3
	movea.l	#NoPicGoalie1,a0
	btst	#$0,$4(a6)
	bne.w	.3
	movea.l	#NoPicGoalie2,a0
.3	cmp.w	d3,d0
	blt.w	.x
	movea.l	#NoPicSkater2,a0
	btst	#$0,$4(a6)
	bne.w	.x
	movea.l	#NoPicSkater1,a0
.x	movem.l	(sp)+,d0-d7/a1-a6
	rts
TrimSpaces						;Trim the trailing spaces of String a2 and pad it to an even length
	movem.l	a3,-(sp)
	movea.l	a2,a3
	adda.w	(a2),a3
.loop	move.b	-(a3),d0
	cmpi.b	#$20,d0
	bne.w	.0
	move.b	#$0,(a3)
	subi.w	#$1,(a2)
	bra.w	.loop
.0	addi.w	#$1,(a2)
	andi.w	#$FE,(a2)
	movem.l	(sp)+,a3
	rts
; Sets up the menu vblank handler and display flags for the name screens.
TrimSpacesMenuSetup
	movem.l	d0-d7/a0-a6,-(sp)
	bclr	#$5,$FF800F.l
	move.w	#$2,d4
	move.l	#MenuVBlankHandler,(VBint).l
	bclr	#$0,(disflags).l
	bset	#$2,(disflags).l
	bclr	#$1,(disflags).l
	move.w	#$0,$18D30.l
	move.w	#$B400,$18D32.l
	move.w	#$B800,$18D3C.l
	move.w	#$5,$18D3E.l
	move.w	#$C000,$18D38.l
	move.w	#$6,(Map2col).l
	move.w	#$E000,(VmMAP1).l
	move.w	#$6,(Map1col).l
	move.w	#$0,d0
	jsr	(setVram).l
	bset	#$5,$FF800F.l
	jsr	(orjoy).l
	move.w	d4,(framercset).l
	movea.l	(FramerMap).l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
; Inline data read by DecompressGraphicsWithRemap from the return address (1 row).
	dc.l	$91234567,$89ABCDEF
	move.w	d4,$1A3D2.l
	movea.l	$47D10.l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
; Inline data read by $38946 from the return address (1 row).
	dc.b	$91,$23,$45,$60,$89,$AB,$CD,$EF	; .#E`....
	move.w	d4,$18D42.l
	jsr	(AddSmallFont).l
	jsr	(printz).l
; Inline data read by $38F6E from the return address (1 row).
	dc.b	$00,$06,$FF,$00,$00,$00	; ......
	moveq	#$28,d0
	moveq	#$1C,d1
	move.w	#$7FF,d2
	jsr	(eraser).l
	jsr	(setupIceRinkPal).l
	jsr	(printz).l
; Inline data read by $38F6E from the return address (1 row).
	dc.b	$00,$06,$FE,$00,$00,$00	; ......
	movea.l	$47D0C.l,a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	moveq	#$28,d2
	moveq	#$1C,d3
	moveq	#$D,d5
	jsr	(dobitmap).l
	jsr	(ForceBlackStepCram).l
	move.w	d4,$19392.l
	addi.w	#$24,d4
	move.w	d4,$19398.l
	movea.l	$47D7C.l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsPlain).l
	move.w	d4,$18D40.l
	movea.l	$47D38.l,a2
	addq.l	#$8,a2
	jsr	(DecompressGraphicsWithRemap).l
; Inline data read by $38946 from the return address (1 row).
	dc.b	$71,$23,$45,$67,$89,$AB,$CD,$EF	; q#Eg....
	jsr	(printz).l
; Inline data read by $38F6E from the return address (1 row).
	dc.b	$00,$06,$BF,$1F,$06,$00	; ......
	move.w	$17FAE.l,d0
	tst.w	$1A390.l
	beq.w	.next
	move.w	$17FB0.l,d0
.next	movea.l	#$1B00C,a1
	asl.w	#$2,d0
	movea.l	(a1,d0.w),a1
	adda.w	$4(a1),a1
	move.w	(a1),d0
	subi.w	#$2,d0
	lsr.w	#$1,d0
	sub.w	d0,$18D58.l
	jsr	(print).l
	jsr	(printz).l
; Inline data read by $38F6E from the return address (1 row).
	dc.b	$00,$06,$BF,$1B,$07,$00	; ......
	move.w	#$8,d0
	move.w	#$8,d1
	jsr	(Framer).l
	jsr	(printz).l
; Inline data read by $38F6E from the return address (1 row).
	dc.b	$00,$06,$8F,$1C,$08,$00	; ......
	move.w	$17FAE.l,d3
	tst.w	$1A390.l
	beq.w	.next2
	move.w	$17FB0.l,d3
.next2	asl.w	#$2,d3
	movea.l	$47D8C.l,a0
	movea.l	(a0,d3.w),a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	asl.w	#$3,d3
	movea.l	#TeamLogoPalettes,a0
	subi.w	#$40,d3
	adda.w	d3,a0
	adda.l	(a2)+,a1
	move.w	#$6,d3
	move.w	#$6,d2
	clr.w	d0
	clr.w	d1
	move.w	#$4,d5
	move.w	$19392.l,d4
	jsr	(dobitmap).l
	jsr	(printz).l
; Inline data read by $38F6E from the return address (1 row).
	dc.b	$00,$06,$BF,$02,$00,$00	; ......
	move.w	#$24,d0
	move.w	#$6,d1
	jsr	(Framer).l
	jsr	(printbigz).l
; Inline data read by $39258 from the return address (1 row).
	dc.b	$00,$10,$BF,$0A,$02,$4E,$41,$4D,$45,$20,$20,$45,$4E,$54,$52,$59	; .....NAME  ENTRY
	bsr.w	ReadNameLog
	clr.w	$1A38E.l
	move.w	#$1,$1A38C.l
	clr.w	d0
	bsr.w	SkipOtherUserName
	movea.l	#$1A37C,a1
	bsr.w	GetLogName
; Inline data read by GetLogName from the return address (1 row).
	dc.w	$6100,$06AC
	jsr	(printz).l
; Inline data read by $38F6E from the return address (1 row).
	dc.b	$00,$0E,$BF,$07,$06,$4E,$61,$6D,$65,$20,$4C,$6F,$67,$00	; .....Name Log.
	move.w	#$18,$18D62.l
	bclr.b	#$2,$18D64.l
	clr.w	d4
	bsr.w	SyncLetterCursor
	bsr.w	PrintNameCursor
	bsr.w	LetterGridPos
	move.w	$18D58.l,-(sp)
	move.w	$18D5A.l,-(sp)
	jsr	(NameEntryFramerRun).l
	move.w	(sp)+,$18D5A.l
	addi.w	#$1,$18D5A.l
	move.w	(sp)+,$18D58.l
	addi.w	#$1,$18D58.l
	bsr.w	PrintCurLetter
	move.w	#$1,$1A566.l
	bsr.w	NameLetterGrid
	clr.w	d0
	bra.w	NameEntryMoveCursor
; Name entry: prints the prompt and the length of the name so far
NameEntryPrompt	bsr.w	GetNameLength
	jsr	(printz).l
; Inline data read by $38F6E from the return address (1 row).
	dc.b	$00,$06,$BF,$05,$12,$00	; ......
	tst.w	$1A566.l
	beq.w	.next
	movea.l	#$1A37C,a1
	bsr.w	PrintNameField
	bsr.w	PrintNamePrompt
.next	bsr.w	MoveLogArrows
.loop	move.w	$17474.l,d0
.loop2	cmp.w	$17474.l,d0
	beq.w	.loop2
	movem.w	d1,-(sp)
	move.w	$17FA6.l,d1
	subi.w	#$1,d1
	cmp.w	$1A390.l,d1
	movem.w	(sp)+,d1
	beq.w	.next2
	jsr	(ReadJoy2).l
	tst.w	d1
	beq.w	.loop
	bra.w	.next3
.next2	jsr	(ReadJoy1).l
	tst.w	d1
	beq.w	.loop
.next3	btst	#$7,d1
	bne.w	NameEntryDone
	tst.w	$1A566.l
	bne.w	.next4
	move.w	#$1,d0
	btst	#$1,d1
	bne.w	.next5
	move.w	#$FFFF,d0
	btst	#$0,d1
	bne.w	.next5
	btst	#$4,d1
	beq.w	NameEntryPrompt
	bsr.w	NameLetterGrid
	clr.w	d0
	bra.w	.next5
.next4	moveq	#-1,d0
	btst	#$6,d1
	bne.w	NameEntryMoveCursor
	neg.w	d0
	btst	#$5,d1
	bne.w	NameEntryMoveCursor
	btst	#$3,d1
	bne.w	NameEntryMoveRow
	neg.w	d0
	btst	#$2,d1
	bne.w	NameEntryMoveRow
	moveq	#$6,d0
	btst	#$1,d1
	bne.w	NameEntryMoveRow
	neg.w	d0
	btst	#$0,d1
	bne.w	NameEntryMoveRow
	btst	#$4,d1
	beq.w	NameEntryPrompt
	bsr.w	NameLetterGrid
	bra.w	NameEntryPrompt
.next5	add.w	d0,$1A38C.l
.loop3	cmpi.w	#$7,$1A38C.l
	ble.w	.next6
	move.w	#$1,$1A38C.l
.next6	tst.w	$1A38C.l
	bne.w	.next7
	move.w	#$7,$1A38C.l
.next7	bsr.w	SkipOtherUserName
	beq.w	.loop3
	movea.l	#$1A37C,a1
	bsr.w	GetLogName
	tst.w	$1A566.l
	bne.w	.next8
	jsr	(NameEntryHelp).l
	bra.w	NameEntryPrompt
.next8	jsr	(printz).l
; Inline data read by $38F6E from the return address (1 row).
	dc.b	$00,$06,$BF,$04,$13,$00	; ......
; Name entry: blanks the letter under the cursor
NameEntryClearLetter	add.w	d4,$18D58.l
	jsr	(printz).l
; Inline data read by $38F6E from the return address (1 row).
	dc.b	$00,$06,$20,$20,$20,$00	; ..   .
	bsr.w	LetterGridPos
	moveq	#$1,d2
	move.w	$18D58.l,-(sp)
	move.w	$18D5A.l,-(sp)
	jsr	(eraser).l
	move.w	(sp)+,$18D5A.l
	addi.w	#$1,$18D5A.l
	move.w	(sp)+,$18D58.l
	addi.w	#$1,$18D58.l
	bsr.w	PrintCurLetter
	bsr.w	SyncLetterCursor
	move.w	d4,d0
	neg.w	d0
	bra.w	NameEntryMoveColumn
; Name entry: moves the cursor along the name
NameEntryMoveCursor
; Name entry: adds the column step to the letter grid position
NameEntryMoveColumn	add.w	d4,d0
	cmpi.w	#$B,d0
	bhi.w	NameEntryPrompt
	move.w	d0,d4
	bsr.w	PrintNameCursor
	movea.l	#$1A37C,a0
	clr.w	d0
	cmpi.b	#$2D,(a0,d4.w)
	beq.w	NameEntryApplyRow
	move.b	(a0,d4.w),d0
	ext.w	d0
	bsr.w	FindLetter
	sub.w	d5,d0
; Name entry: moves the letter grid row
NameEntryMoveRow
; Name entry: applies the row step to the letter grid position
NameEntryApplyRow	add.w	d5,d0
	cmpi.w	#$1D,d0
	bhi.w	NameEntryPrompt
	move.w	d0,-(sp)
	bsr.w	LetterGridPos
	moveq	#$1,d2
	move.w	$18D58.l,-(sp)
	move.w	$18D5A.l,-(sp)
	jsr	(eraser).l
	move.w	(sp)+,$18D5A.l
	addi.w	#$1,$18D5A.l
	move.w	(sp)+,$18D58.l
	addi.w	#$1,$18D58.l
	bsr.w	PrintCurLetter
	move.w	(sp)+,d5
	bsr.w	LetterGridPos
	move.w	$18D58.l,-(sp)
	move.w	$18D5A.l,-(sp)
	tst.w	$1A566.l
	beq.w	.next
	jsr	(NameEntryFramerRun).l
.next	move.w	(sp)+,$18D5A.l
	addi.w	#$1,$18D5A.l
	move.w	(sp)+,$18D58.l
	addi.w	#$1,$18D58.l
	bsr.w	PrintCurLetter
	movea.l	#$1A37C,a0
	movea.l	#$26DD0,a1
	move.b	(a1,d5.w),d0
	move.b	d0,(a0,d4.w)
	bra.w	NameEntryPrompt
; Name entry: stores the name and returns
NameEntryDone	bsr.w	StoreUserName
	movem.l	(sp)+,d0-d7/a0-a6
	rts