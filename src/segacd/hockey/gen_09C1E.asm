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
.2	bsr.w	Sub_24AFA
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
	bra.w	.l9E7A
.loop2	adda.w	(a2),a2
	adda.w	#$8,a2
.l9E7A	dbra	d0,.loop2
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
	beq.w	.l9FFE
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
.l9FFE	rts
	bclr	#$5,(sflags6).l
	tst.w	$17BE0.l
	bmi.w	.lA05E
	movem.l	d0/a0,-(sp)
	movea.l	#$17480,a0
	move.w	$17BE0.l,d0
	asl.w	#$7,d0
	adda.w	d0,a0
	move.w	$14(a0),d0
	btst	#$7,$62(a0)
	bne.w	.lA036
	neg.w	d0
.lA036	cmpi.w	#$58,d0
	blt.w	.lA05A
	cmpi.w	#$47,$0(a0)
	bgt.w	.lA05A
	cmpi.w	#$FFB9,$0(a0)
	blt.w	.lA05A
	bset	#$5,(sflags6).l
.lA05A	movem.l	(sp)+,d0/a0
.lA05E	rts
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_0A060.bin
	movem.l	d0-d7/a1-a6,-(sp)
	move.l	a1,-(sp)
	movea.l	a1,a3
	movea.l	#$257EE,a1
	movem.l	d0-d1,-(sp)
	bsr.w	CopyString
	movem.l	(sp)+,d0-d1
	bsr.w	GetRecordValue
	tst.w	d0
	bne.w	.lA78E
	movea.l	(sp)+,a1
	move.w	#$2,(a1)
	bra.w	.lA7E8
.lA78E	movea.l	#TempBuffer,a1
	move.w	d0,$17E64.l
	bsr.w	AppendNumber
	movea.l	(sp),a3
	movea.l	#TempBuffer,a1
	jsr	(appstring).l
	move.w	$17E64.l,d0
	movea.l	#$25808,a1
	cmpi.w	#$1,d0
	bne.w	.lA7C6
	movea.l	#$25810,a1
.lA7C6	tst.w	d1
	bne.w	.lA7E0
	movea.l	#$257F8,a1
	cmpi.w	#$1,d0
	bne.w	.lA7E0
	movea.l	#$25800,a1
.lA7E0	movea.l	(sp)+,a3
	jsr	(appstring).l
.lA7E8	movem.l	(sp)+,d0-d7/a1-a6
	rts
	dc.w	$000A,$5265,$636F,$7264,$2000,$0008,$2067,$6F61
	dc.w	$6C73,$0008,$2067,$6F61,$6C00,$0008,$2073,$6176
	dc.w	$6573,$0008,$2073,$6176,$6500
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
	bra.w	.lA8C2
.loop	adda.w	(a2),a2
	adda.w	#$8,a2
.lA8C2	dbra	d0,.loop
	move.w	d1,d0
	move.w	(sp)+,d1
	move.w	d0,d5
	move.w	d1,d4
	ext.l	d0
	movea.l	#$C45C,a0
	bsr.w	Sub_22534		;his save record into M68K_RAM
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
	dc.w	$0006,$6279,$2000
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
	dc.w	$0006,$7673,$2E20
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
	bsr.w	Sub_22534
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
	bsr.w	Sub_22534
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
