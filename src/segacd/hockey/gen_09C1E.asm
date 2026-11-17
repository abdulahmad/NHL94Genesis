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
	jsr	$25760.l
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
	dc.w	$0EEA,$0EEE,$0000,$0888
	dc.w	$0AAA,$0068,$008A,$00CE
	dc.w	$0260,$0040,$0664,$0E8E
		dc.w	$0EEA,$0EEA,$0EEA,$0000		;ANH other side
	dc.w	$0042,$0EEE,$0000,$0888
	dc.w	$0AAA,$0068,$008A,$00CE
	dc.w	$0260,$0040,$0664,$0E8E
		dc.w	$0EE8,$0000,$008C,$0EE8		;BOS matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0C8C
	dc.w	$008C,$0888,$0068,$0846
	dc.w	$0044,$0422,$08CE,$02AE
		dc.w	$0EE8,$0EE8,$0EE8,$0000		;BOS other side
	dc.w	$008C,$0EEE,$0000,$0C8C
	dc.w	$008C,$0888,$0068,$0846
	dc.w	$0044,$0422,$08CE,$02AE
		dc.w	$0EE8,$0822,$008C,$0EE8		;BUF matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0EC8
	dc.w	$048C,$0C88,$006C,$0866
	dc.w	$0268,$0224,$0620,$00CE
		dc.w	$0EE8,$0EE8,$0EE8,$0822		;BUF other side
	dc.w	$008C,$0EEE,$0000,$0EC8
	dc.w	$048C,$0C88,$006C,$0866
	dc.w	$0268,$0224,$0620,$00CE
		dc.w	$0EE8,$0006,$008C,$0EE8		;CGY matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$08EE
	dc.w	$02CE,$02AE,$026E,$000C
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0EE8,$0EE8,$0006		;CGY other side
	dc.w	$008C,$0EEE,$0000,$08EE
	dc.w	$02CE,$02AE,$026E,$000C
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0000,$0006,$0EE8		;CHI matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$08EE
	dc.w	$0A8E,$04AC,$0A88,$046C
	dc.w	$0226,$0644,$022E,$0262
		dc.w	$0EE8,$0EE8,$0EE8,$0000		;CHI other side
	dc.w	$0006,$0EEE,$0000,$08EE
	dc.w	$0A8E,$04AC,$0A88,$046C
	dc.w	$0226,$0644,$022E,$0262
		dc.w	$0EE8,$0000,$0042,$0EE8		;DAL matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$08AA
	dc.w	$0688,$0488,$0466,$0244
	dc.w	$0260,$0020,$0ACC,$0000
		dc.w	$0EE8,$0EE8,$0EE8,$0000		;DAL other side
	dc.w	$0042,$0EEE,$0000,$08AA
	dc.w	$0688,$0488,$0466,$0244
	dc.w	$0260,$0020,$0ACC,$0000
		dc.w	$0EE8,$0006,$0006,$0EE8		;DET matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0C8E
	dc.w	$086E,$044E,$082E,$020E
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0EE8,$0EE8,$0006		;DET other side
	dc.w	$0006,$0EEE,$0000,$0C8E
	dc.w	$086E,$044E,$082E,$020E
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0600,$004A,$0EE8		;EDM matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0CEA
	dc.w	$0A8E,$08A8,$044E,$0488
	dc.w	$002E,$0440,$0400,$0EE8
		dc.w	$0EE8,$0EE8,$0EE8,$0600		;EDM other side
	dc.w	$004A,$0EEE,$0000,$0CEA
	dc.w	$0A8E,$08A8,$044E,$0488
	dc.w	$002E,$0440,$0400,$0EE8
		dc.w	$0EEA,$004A,$0600,$0EEA		;FLA matchup logo palette
	dc.w	$0EEA,$0EEE,$0000,$000A
	dc.w	$0004,$0046,$008E,$0CEE
	dc.w	$0466,$0442,$0EC6,$0200
		dc.w	$0EEA,$0EEA,$0EEA,$004A		;FLA other side
	dc.w	$0600,$0EEE,$0000,$000A
	dc.w	$0004,$0046,$008E,$0CEE
	dc.w	$0466,$0442,$0EC6,$0200
		dc.w	$0EE8,$0042,$0822,$0EE8		;HFD matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$00E8
	dc.w	$04C4,$0A8A,$00A2,$0466
	dc.w	$0600,$0224,$0EE8,$0EE8
		dc.w	$0EE8,$0EE8,$0EE8,$0042		;HFD other side
	dc.w	$0822,$0EEE,$0000,$00E8
	dc.w	$04C4,$0A8A,$00A2,$0466
	dc.w	$0600,$0224,$0EE8,$0EE8
		dc.w	$0EE8,$0000,$0000,$0EE8		;LA matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0AAA
	dc.w	$0888,$0666,$0444,$0222
	dc.w	$0CCC,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0EE8,$0EE8,$0000		;LA other side
	dc.w	$0000,$0EEE,$0000,$0AAA
	dc.w	$0888,$0666,$0444,$0222
	dc.w	$0CCC,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0600,$0006,$0EE8		;MTL matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$088E
	dc.w	$026E,$0C68,$002E,$0A24
	dc.w	$0EAA,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0EE8,$0EE8,$0600		;MTL other side
	dc.w	$0006,$0EEE,$0000,$088E
	dc.w	$026E,$0C68,$002E,$0A24
	dc.w	$0EAA,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0020,$0006,$0EE8		;NJ matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0AAA
	dc.w	$000A,$0888,$000C,$0022
	dc.w	$0006,$0CCC,$0EE8,$0EE8
		dc.w	$0EE8,$0EE8,$0EE8,$0020		;NJ other side
	dc.w	$0006,$0EEE,$0000,$0AAA
	dc.w	$000A,$0888,$000C,$0022
	dc.w	$0006,$0CCC,$0EE8,$0EE8
		dc.w	$0EE8,$0822,$004A,$0EE8		;NYI matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0AA8
	dc.w	$066E,$0864,$022C,$062A
	dc.w	$0008,$0622,$0222,$0A8E
		dc.w	$0EE8,$0EE8,$0EE8,$0822		;NYI other side
	dc.w	$004A,$0EEE,$0000,$0AA8
	dc.w	$066E,$0864,$022C,$062A
	dc.w	$0008,$0622,$0222,$0A8E
		dc.w	$0EE8,$0600,$0006,$0EE8		;NYR matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0AAA
	dc.w	$0C86,$002E,$0C60,$0844
	dc.w	$0444,$0840,$0008,$0EC8
		dc.w	$0EE8,$0EE8,$0EE8,$0600		;NYR other side
	dc.w	$0006,$0EEE,$0000,$0AAA
	dc.w	$0C86,$002E,$0C60,$0844
	dc.w	$0444,$0840,$0008,$0EC8
		dc.w	$0EE8,$0006,$006A,$0EE8		;OTW matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$068A
	dc.w	$0688,$0466,$0244,$022C
	dc.w	$0228,$0008,$0AAA,$0004
		dc.w	$0EE8,$0EE8,$0EE8,$0006		;OTW other side
	dc.w	$006A,$0EEE,$0000,$068A
	dc.w	$0688,$0466,$0244,$022C
	dc.w	$0228,$0008,$0AAA,$0004
		dc.w	$0EE8,$0000,$004A,$0EE8		;PHI matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0CCC
	dc.w	$088E,$0AAA,$046E,$006E
	dc.w	$0888,$0666,$002E,$0444
		dc.w	$0EE8,$0EE8,$0EE8,$0000		;PHI other side
	dc.w	$004A,$0EEE,$0000,$0CCC
	dc.w	$088E,$0AAA,$046E,$006E
	dc.w	$0888,$0666,$002E,$0444
		dc.w	$0EE8,$0000,$008C,$0EE8		;PIT matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0AAA
	dc.w	$088A,$066A,$04EE,$0464
	dc.w	$0440,$02CE,$0244,$0AEE
		dc.w	$0EE8,$0EE8,$0EE8,$0000		;PIT other side
	dc.w	$008C,$0EEE,$0000,$0AAA
	dc.w	$088A,$066A,$04EE,$0464
	dc.w	$0440,$02CE,$0244,$0AEE
		dc.w	$0EE8,$0600,$0006,$0EE8		;QUE matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0C00
	dc.w	$000E,$0E44,$0ECE,$0E80
	dc.w	$088E,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0EE8,$0EE8,$0600		;QUE other side
	dc.w	$0006,$0EEE,$0000,$0C00
	dc.w	$000E,$0E44,$0ECE,$0E80
	dc.w	$088E,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0000,$0860,$0EE8		;SJ matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0860
	dc.w	$0642,$0888,$0CA8,$0ACC
	dc.w	$02AE,$006E,$0048,$046A
		dc.w	$0EE8,$0EE8,$0EE8,$0000		;SJ other side
	dc.w	$0860,$0EEE,$0000,$0860
	dc.w	$0642,$0888,$0CA8,$0ACC
	dc.w	$02AE,$006E,$0048,$046A
		dc.w	$0EE8,$0822,$006A,$0EE8		;STL matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0602
	dc.w	$024C,$0002,$0026,$0068
	dc.w	$0428,$086E,$0EE8,$0EE8
		dc.w	$0EE8,$0EE8,$0EE8,$0822		;STL other side
	dc.w	$006A,$0EEE,$0000,$0602
	dc.w	$024C,$0002,$0026,$0068
	dc.w	$0428,$086E,$0EE8,$0EE8
		dc.w	$0EE8,$0000,$0600,$0EE8		;TB matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0C86
	dc.w	$0E84,$0A84,$0C44,$0822
	dc.w	$0E20,$0600,$0A00,$0EA8
		dc.w	$0EE8,$0EE8,$0EE8,$0000		;TB other side
	dc.w	$0600,$0EEE,$0000,$0C86
	dc.w	$0E84,$0A84,$0C44,$0822
	dc.w	$0E20,$0600,$0A00,$0EA8
		dc.w	$0EE8,$0600,$0600,$0EE8		;TOR matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0ECA
	dc.w	$0AAA,$0C66,$0822,$0CCC
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0EE8,$0EE8,$0600		;TOR other side
	dc.w	$0600,$0EEE,$0000,$0ECA
	dc.w	$0AAA,$0C66,$0822,$0CCC
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0000,$008C,$0EE8		;VAN matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$00CE
	dc.w	$006A,$004E,$0028,$0022
	dc.w	$0020,$008E,$0888,$06CE
		dc.w	$0EE8,$0EE8,$0EE8,$0000		;VAN other side
	dc.w	$008C,$0EEE,$0000,$00CE
	dc.w	$006A,$004E,$0028,$0022
	dc.w	$0020,$008E,$0888,$06CE
		dc.w	$0EE8,$0006,$0600,$0EE8		;WSH matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$022C
	dc.w	$0C86,$0EA8,$088E,$0842
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0EE8,$0EE8,$0006		;WSH other side
	dc.w	$0600,$0EEE,$0000,$022C
	dc.w	$0C86,$0EA8,$088E,$0842
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8
		dc.w	$0EE8,$0600,$0006,$0EE8		;WPG matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$022C
	dc.w	$0422,$0AAC,$0666,$0CAA
	dc.w	$0444,$066E,$08CE,$0226
		dc.w	$0EE8,$0EE8,$0EE8,$0600		;WPG other side
	dc.w	$0006,$0EEE,$0000,$022C
	dc.w	$0422,$0AAC,$0666,$0CAA
	dc.w	$0444,$066E,$08CE,$0226
		dc.w	$0EE8,$0000,$004A,$0EE8		;ASE matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0688
	dc.w	$0464,$0244,$0222,$004E
	dc.w	$000A,$0022,$0AAA,$0000
		dc.w	$0EE8,$0EE8,$0EE8,$0000		;ASE other side
	dc.w	$004A,$0EEE,$0000,$0688
	dc.w	$0464,$0244,$0222,$004E
	dc.w	$000A,$0022,$0AAA,$0000
		dc.w	$0EE8,$0000,$004A,$0EE8		;ASW matchup logo palette
	dc.w	$0EE8,$0EEE,$0000,$0688
	dc.w	$0464,$0244,$0222,$004E
	dc.w	$000A,$0022,$0AAA,$0000
		dc.w	$0EE8,$0EE8,$0EE8,$0000		;ASW other side
	dc.w	$004A,$0EEE,$0000,$0688
	dc.w	$0464,$0244,$0222,$004E
	dc.w	$000A,$0022,$0AAA,$0000
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
PlayerCardScreenTbl1	dc.b	$00,$0A,'Record ',$00,$00,$08,' goa'
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
PrintRecordHolderTbl1	dc.w	$0006,$6279,$2000
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
PrintRecordVsTbl1	dc.b	$00,$06,'vs. '
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
