;	NHL 94 (retail) segment $162FE-$169F9
;	92 Video.asm second half, as 93 video93_2.asm: showclock, checksso, setsortcords, setffo, uppads, FormatControllerDisplay,
;	RenderSmallFontChar, ButtonLabelCharTable, addframe, addframe2, find3d, updatesound and KillCrowd. setupice
;	(hockey94_06) follows at $169FA.
;	Transcribed from lst/nhl94.bin.lst lines 52287-53021. Global names are the IDA names, or the 93 name where IDA has an
;	auto name (IDA name in an ;IDA: comment). The IDA routines 93 writes as locals are locals: showclock .char (sub_16468),
;	checksso .ca (sub_164D6) and .tab (unk_165BC); the 94 horizontal clock code's .digit (sub_16384) and .digits (unk_16396)
;	sit inside showclock too, so the 93 body (loc_163BE) stays the local .163BE. Local labels are the IDA local names
;	(_x -> .x) or the IDA address (loc_1640C -> .1640C).
;	IDA shows the two clock strings after printz as ori.b / btst; they are written with the String macro. The tables IDA
;	left as dc.b (.digits, .tab, ButtonLabelCharTable) are String / dc.w / dc.b.
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp / cmpi;
;	fixopcodes.js patches the cmp encoding after assembly.
;	Object offsets, as 92 / 93: Xpos 0, attribute 4, frame 6, oldframe 8, VRoffs $A, VRchar $12, Ypos $14, Zpos $18.
;	92 ffosize = $1C, ssosize = $14. DMA list entries (a5): long source, word length in words, word vram.

showclock	;put the game clock on screen. Called from setvideo and PauseMode. 94: on the horizontal rink the clock is printed (printz / print
	;with .digits; not in a shootout, word_FFC2FA bit 0). On the vertical rink (.163BE, the 93 showclock body) it goes in the dma list, only when
	;dfclock is set; with word_FFC2FA bit 1 (penalty shot / shootout) word_FFD454 is shown instead of gameclock. a5 = dma list
	btst	#7,(sflags).w	;sfhor
	beq.w	.163BE
	btst	#0,(word_FFC2FA).w	;94 only: shootout
	bne.w	.16382
	move.l	a1,-(sp)
	jsr	(printz).l
	String	$BE,$D,5		;IDA: ori.b / btst d2,d0
	move.w	(gameclock).w,d0
	ext.l	d0
	divu.w	#$258,d0	;tens of minutes (600 seconds)
	move.l	d0,-(sp)
	tst.w	d0
	bne.w	.1633A
	addq.w	#1,(printx).w
	bra.w	.16340
.1633A
	jsr	(.digit).l
.16340
	move.l	(sp)+,d0
	swap	d0
	ext.l	d0
	divu.w	#$3C,d0	;minutes
	move.l	d0,-(sp)
	jsr	(.digit).l
	move.l	(sp)+,d0
	swap	d0
	ext.l	d0
	addq.w	#2,(printx).w
	divu.w	#$A,d0	;tens of seconds
	move.l	d0,-(sp)
	jsr	(.digit).l
	move.l	(sp)+,d0
	swap	d0
	ext.l	d0
	jsr	(.digit).l
	movea.l	(sp)+,a1
	jsr	(printz).l
	String	$BD,$D,5		;IDA: ori.b / btst d2,d0
.16382
	rts
.digit	;IDA: sub_16384. Print digit d0 from .digits
	movea.l	#.digits,a1
	asl.w	#2,d0
	adda.w	d0,a1
	jsr	(print).l
	rts
.digits	;IDA: unk_16396. Strings '0' .. '9' for .digit (4 bytes each)
	String	'0'
	String	'1'
	String	'2'
	String	'3'
	String	'4'
	String	'5'
	String	'6'
	String	'7'
	String	'8'
	String	'9'
.163BE	;IDA: loc_163BE. The 93 showclock body: returns unless dfclock is set
	bclr	#3,(disflags).w	;dfclock
	beq.w	rtss2
	btst	#3,(sflags2).w	;94 only
	bne.w	rtss2
	cmpi.w	#4,(gsp).w	;no clock update when gsp = 4
	beq.w	rtss2
	movea.w	#(unk_FFBF8C-M68K_RAM),a0	;end of the 5 word clock buffer (92 clockram+(5*2)); written backward
	movea.l	#unk_AAC52,a1	;93 smallfontmap
	adda.l	4(a1),a1
	move.w	$78(a1),d0	;4+(':'*2)
	add.w	(word_FFB012).w,d0	;93 smallfontchars
	ori.w	#$8000,d0
	move.w	d0,(word_FFBF86).w	;colon (93 clockram)
	move.w	(gameclock).w,d0
	btst	#1,(word_FFC2FA).w	;94 only: penalty shot / shootout clock
	beq.w	.1640C
	move.w	(word_FFD454).w,d0
.1640C
	ext.l	d0
	divu.w	#$A,d0
	bsr.w	.char	;seconds ones
	divu.w	#6,d0
	bsr.w	.char	;seconds tens
	subq.w	#2,a0	;skip the colon
	divu.w	#$A,d0
	bsr.w	.char	;minutes ones
	swap	d0
	tst.l	d0
	bne.w	.16434
	moveq	#-$10,d0	;' '-'0': blank leading zero (IDA #$FFFFFFF0)
	swap	d0
.16434
	bsr.w	.char	;minutes tens
	move.l	a0,(a5)+
	move.w	#5,(a5)+	;words to transfer
	movea.w	#(VmMap1-M68K_RAM),a1
	moveq	#$18,d0	;.clocky = 24
	moveq	#3,d2	;.clockx = 3
	btst	#7,(sflags).w	;sfhor (always clear here in 94: the horizontal rink prints the clock above)
	beq.w	.16458
	movea.w	#(VmMap2-M68K_RAM),a1
	moveq	#5,d0	;.clocky2 (93 4)
	moveq	#$D,d2	;.clockx2 = 13
.16458
	move.w	2(a1),d1
	asl.w	d1,d0
	add.w	d2,d0
	asl.w	#1,d0
	add.w	(a1),d0
	move.w	d0,(a5)+	;vram destination
	rts
.char	;IDA: sub_16468 (93 .char, IDA showclock_char). d0 high word = digit, write its tile to -(a0)
	swap	d0
	asl.w	#1,d0
	move.w	$64(a1,d0.w),d0	;4+('0'*2)
	add.w	(word_FFB012).w,d0
	ori.w	#$8000,d0
	move.w	d0,-(a0)
	swap	d0
	ext.l	d0
	rts
checksso	;do graphics for sso structure: arrows for the players when they are off screen. Called from setvideo. a5 = dma list, a6 = sprite
	;table, d6 = link counter. Returns on the horizontal rink. 94 adds the pads 3 and 4 (Joy3Struct / Joy4Struct when cont3team / cont4team).
	;Falls into .ca for the last one
	btst	#7,(sflags).w
	bne.w	rtss2
	movea.w	#(Joy1Struct-M68K_RAM),a0
	movea.w	#(sso-M68K_RAM),a3
	move.w	#$180,d3	;SPFarrow
	bsr.w	.ca
	adda.w	#$1C,a0	;ffosize
	adda.w	#$14,a3	;ssosize
	move.w	#$183,d3	;SPFarrow+3
	bsr.w	.ca
	tst.w	(cont3team).w
	beq.w	rtss2	;on screen: no arrow
	movea.w	#(Joy3Struct-M68K_RAM),a0
	adda.w	#$14,a3
	move.w	#$346,d3
	bsr.w	.ca
	tst.w	(cont4team).w
	beq.w	rtss2
	movea.w	#(Joy4Struct-M68K_RAM),a0
	adda.w	#$14,a3
	move.w	#$349,d3
.ca	;IDA: sub_164D6 (93 .ca, IDA checksso_ca). a0 = object, a3 = sso, d3 = first arrow frame. 94: in a shootout, with sflags2 bit 3 or in a penalty shot, no arrow for a player beyond x $A6
	tst.w	$18(a0)
	bmi.w	rtss2	;not on the ice
	st	6(a3)
	move.w	(a0),d0
	btst	#0,(word_FFC2FA).w
	bne.w	.16502
	btst	#3,(sflags2).w
	bne.w	.16502
	btst	#2,(BA_PS_flags).w
	beq.w	.1651A
.16502
	move.w	d0,-(sp)
	tst.w	d0
	bpl.w	.1650C
	neg.w	d0
.1650C
	cmp.w	#$A6,d0
	blt.w	.16518
	move.w	(sp)+,d0
	rts
.16518
	move.w	(sp)+,d0
.1651A
	move.w	$14(a0),d1
	btst	#7,(sflags).w
	beq.w	.16534
	exg	d0,d1
	neg.w	d0
	subi.w	#$C5,d1	;horoff
	bra.w	.1653C
.16534
	sub.w	(Hpos).w,d0
	sub.w	(Vpos).w,d1
.1653C
	clr.w	d2
	cmp.w	#$74,d0	;.xoff = 116
	blt.w	.1654A
	bset	#3,d2
.1654A
	cmp.w	#$FF8C,d0	;-.xoff
	bgt.w	.16556
	bset	#2,d2
.16556
	cmp.w	#$64,d1	;.yoff = 100
	blt.w	.16562
	bset	#0,d2
.16562
	cmp.w	#$FF9C,d1	;-.yoff
	bgt.w	.1656E
	bset	#1,d2
.1656E
	tst.w	d2
	beq.w	rtss2
	movea.l	#jdtab,a1
	move.b	0(a1,d2.w),d2
	asl.w	#3,d2
	movea.l	#.tab,a1
	move.w	0(a1,d2.w),d4
	beq.w	.16590
	move.w	d4,d0
.16590
	addi.w	#$100,d0	;128+128
	move.w	d0,(a3)
	move.w	2(a1,d2.w),d4
	beq.w	.165A0
	move.w	d4,d1
.165A0
	neg.w	d1
	addi.w	#$F0,d1	;112+128
	move.w	d1,2(a3)
	add.w	4(a1,d2.w),d3
	move.w	d3,6(a3)
	move.w	6(a1,d2.w),4(a3)
	bra.w	addframe2
.tab	;IDA: unk_165BC (93 .tab). x spot, y spot, frame add, attribute per direction
	dc.w	0,$64,0,$0000
	dc.w	$74,$64,1,$0000
	dc.w	$74,0,2,$0000
	dc.w	$74,-$64,1,$1000
	dc.w	0,-$64,0,$1000
	dc.w	-$74,-$64,1,$1800
	dc.w	-$74,0,2,$0800
	dc.w	-$74,$64,1,$0800
setsortcords	;setup sort cord graphics: addframe for the 16 objects in OOlist order. a5 = dmalist, a6 = sprite attribute table, d6 = link counter
	movea.w	#(OOlist-M68K_RAM),a4	;move OOlist into a4
	move.w	#$F,d0	;sortobj-1 (15 dec)
.top
	clr.w	d1
	move.b	(a4)+,d1	;move next sortcord into d1
	asl.w	#6,d1	;mult by 64
	movea.w	#(SortCords-M68K_RAM),a3	;Sort Cord struct start into a3 (FFB04A)
	adda.w	d1,a3	;add offset to next struct
	bsr.w	addframe
	dbf	d0,.top	;loop until done
	rts
setffo	;draw the 7 objects tied to icerink scrolling (gloves and pads), moving each by its x offset. Called from setvideo
	bsr.w	uppads
	move.w	#6,d0	;ffo obj -1
	movea.w	#(pads-M68K_RAM),a3	;move start of struct into a3
.16626
	movea.w	a6,a0
	bsr.w	addframe
	cmpa.w	a6,a0
	beq.w	.1663E
	move.w	2(a3),d1
	add.w	d1,6(a0)
	add.w	d1,$E(a0)
.1663E
	adda.w	#$1C,a3	;move to next struct
	dbf	d0,.16626
	rts
uppads	;update the gloves object and the 6 pad objects, and queue new pad labels (FormatControllerDisplay). The pad players
	;come from the word_FFBE78 / word_FFBE86 nibbles ($E = no change, $F = none)
	movea.w	#(glovestruct-M68K_RAM),a0
	st	$18(a0)	;set Zpos
	move.b	(glovecords).w,d0
	beq.w	.1666E	;branch if 0
	move.b	(glovecords+1).w,d1
	ext.w	d0
	asl.w	#2,d0
	move.w	d0,(a0)	;move d0 into Xpos
	ext.w	d1
	asl.w	#2,d1
	move.w	d1,$14(a0)	;move d1 into Ypos
	clr.w	$18(a0)	;clear Zpos
.1666E
	move.w	#5,d4
	movea.w	#(pads-M68K_RAM),a0
	movea.w	#(padcont-M68K_RAM),a1
	movea.w	#(SortCords-M68K_RAM),a2
	move.w	(word_FFBE78).w,d3
.top
	cmp.w	#1,d4
	bne.w	.16694
	move.w	(word_FFBE86).w,d3
	lsr.w	#4,d3
	bra.w	*+4	;to the next instruction
.16694
	move.w	d3,d0
	andi.w	#$F,d0
	move.w	#$F,d1
	cmp.w	#$E,d0
	beq.w	.166CC
	st	$18(a0)
	cmp.w	#$F,d0
	beq.w	.166D8
	asl.w	#7,d0
	move.w	0(a2,d0.w),(a0)
	move.w	$14(a2,d0.w),$14(a0)
	clr.w	$18(a0)
	move.b	$35(a2,d0.w),d1
	asl.w	#8,d1
	move.b	$6F(a2,d0.w),d1
.166CC
	cmp.w	(a1),d1
	beq.w	.166D8
	move.w	d1,(a1)
	bsr.w	FormatControllerDisplay
.166D8
	lsr.w	#4,d3
	adda.w	#$1C,a0
	addq.w	#2,a1
	dbf	d4,.top
	rts
FormatControllerDisplay	;IDA: sub_166E6 (93 name). Queue the 3 character label of a pad object. d1 = label code: bits 7-4 and 3-0 are digits ($F =
	;blank), bits 10-8 index ButtonLabelCharTable (94: none while byte_FFC2FC bit 7 is set). a0 = pad object, a5 = dma list. Falls into
	;RenderSmallFontChar for the last char
	lea	ButtonLabelCharTable(pc),a4
	clr.w	2(a0)	;x offset (setffo adds it to the sprites)
	move.w	d1,d2
	lsr.w	#4,d2
	andi.w	#$F,d2
	bne.w	.16702
	move.w	#$FFF0,d2	;' '-'0': blank leading zero
	subq.w	#4,2(a0)
.16702
	addi.w	#$30,d2
	clr.w	d0
	bsr.w	RenderSmallFontChar
	move.w	d1,d2
	andi.w	#$F,d2
	cmp.w	#$F,d2
	bne.w	.1671E
	move.w	#$FFF0,d2	;$F: blank
.1671E
	addi.w	#$30,d2
	moveq	#1,d0
	bsr.w	RenderSmallFontChar
	move.w	d1,d2
	btst	#7,(byte_FFC2FC).w	;94 only
	beq.w	.16736
	clr.w	d2
.16736
	lsr.w	#8,d2
	andi.w	#7,d2
	bne.w	.16744
	addq.w	#4,2(a0)
.16744
	move.b	0(a4,d2.w),d2
	moveq	#2,d0
RenderSmallFontChar	;IDA: sub_1674A (93 name). Dma one small font tile (unk_AAC52, 93 smallfontmap) to the object's chars. d2 = ascii char, d0 = char slot, a0 = object (VRchar), a5 = dma list
	movea.l	#unk_AAC52,a3
	adda.l	4(a3),a3
	add.w	d2,d2
	move.w	4(a3,d2.w),d2
	andi.w	#$7FF,d2
	asl.w	#5,d2	;32 bytes per tile
	movea.l	#unk_AAC52,a3
	lea	$A(a3,d2.w),a3
	move.l	a3,(a5)+
	move.w	#$10,(a5)+	;words to transfer
	add.w	$12(a0),d0
	asl.w	#5,d0
	move.w	d0,(a5)+
	rts
ButtonLabelCharTable	;IDA: unk_1677A (93 name). Third label character by bits 10-8 of the label code
	dc.b	' DDLCRX',$FF	;94 pad byte $FF (93 retail $10)
addframe	;a3 = sort cord object. Project it with find3d, then addframe2. a5 = dma trans, a6 = sprite attribute table. Called from setsortcords and setffo
	movem.l	d0-d2,-(sp)
	move.w	(a3),d0	;Xpos into d0
	move.w	$14(a3),d1	;Ypos into d1
	move.w	$18(a3),d2	;Zpos into d2
	bmi.w	.exit	;exit if Zpos minus
	bsr.w	find3d	;get position on screen
	cmp.w	#$4E20,d1	;#osflag into d1
	beq.w	.exit	;exit if Sort Cord is off screen
	bsr.w	addframe2
.exit
	movem.l	(sp)+,d0-d2
	rts
addframe2	;d0/d1 = x/y coord on screen, a3 = object, a5 = dma trans, a6 = sprite attribute table, d6 = link counter. Queue the sprite tiles of
	;the frame (once per frame change, sharing tiles already sent) and write its sprites
	move.w	4(a3),-(sp)	;push attribute to stack
	movem.l	d0-d5/a0-a2,-(sp)	;push to stack
	move.w	6(a3),d4	;move frame into d4
	bmi.w	.exit	;exit if minus
	beq.w	.exit	;exit if 0
	andi.w	#$F800,d4	;pass highest 5 bits
	eor.w	d4,4(a3)	;EOR d4 with attribute
	move.w	6(a3),d4	;move frame back into d4
	andi.w	#$7FF,d4	;pass first 11 bits
	movea.l	#off_5DE7A,a2	;sprite frame list
	adda.l	4(a2),a2	;add long word at offset 4 to a2 address ($408AA). a2 now $9E724
	add.w	d4,d4	;add d4 to itself
	cmp.w	2(a2),d4	;compare offset 2 of a2 to d4. Offset 2 = $69E
	bge.w	.exit	;branch if greater than or equal
	move.w	2(a2,d4.w),d5	;move data at 2+a2+d4 into d5
	sub.w	0(a2,d4.w),d5	;sub data at a2+d4 from d5
	lsr.w	#3,d5	;divide d5 by 8
	subq.w	#1,d5	;sub 1 from d5. d5 now total sprites in frame -1(SprStrnum)
	adda.w	0(a2,d4.w),a2	;add data at a2+d4 to a2, a2 now at SprStrdat - sprite data
	clr.w	d3	;clear d3
	clr.w	d4	;clear d4
.sloop
	move.w	d0,-(sp)	;push d0 on stack
	move.w	6(a3),d0	;move frame into d0
	andi.w	#$7FF,d0	;pass first 11 bits
	cmp.w	8(a3),d0	;compare old frame to d0 (current frame)
	beq.w	.noref	;branch if equal (no change)
	tst.w	d5	;check if d5 is 0
	bne.w	.nn	;branch if not
	move.w	d0,8(a3)	;move frame into old frame
.nn
	movem.w	d0-d4,-(sp)	;push to stack
	move.w	4(a2),d2	;move 4 + a2 data into d2 (tile pointer bytes)
	clr.w	d4	;clear d4
	move.b	7(a2),d4	;move 7 + a2 data into d4 (sizetab byte)
	movea.l	#sizetab,a0	;move address into a0
	move.b	0(a0,d4.w),d4	;move data at a0+d4 into d4 - tiles used in sprite
	cmp.w	8(sp),d4	;compare current d4 to previous d4
	bgt.w	.nodup	;branch if d4 greater - more data in prev sprite so no dup
	;d0 = frame
	;d2 = 11 bit pointer to sprite tiles
	;d4 = # of tiles in sprite
	;d5 = # of sprites in frame-1
	cmp.w	4(sp),d2	;compare current d2 to previous d2
	blt.w	.nodup	;branch if less than
	move.w	4(sp),d0	;move previous d2 into d0
	add.w	8(sp),d0	;add previous d4 to d0 - end of last data
	sub.w	d2,d0	;sub d2 from d0
	sub.w	d4,d0	;sub d4 from d0
	bmi.w	.nodup	;branch if d0 negative
	movem.w	(sp)+,d0-d1	;pop d0 and d1 from stack
	addq.w	#6,sp	;add 6 to stack pointer
	bra.w	.dup	;branch
.nodup
	add.w	8(sp),d3	;add old d4 to d3 - both of these are 0 if first sprite in frame
	movem.w	(sp)+,d0-d1	;pop d0 and d1 from stack (d0=Xpos, d1=Ypos)
	addq.w	#6,sp	;add 6 to stack pointer (moves past old d4 spot on stack)
	movem.w	d0-d4,-(sp)	;push d0-d4 to stack (all new values are on stack)
	add.w	$12(a3),d3	;add VRChar of player struct to d3
	ext.l	d2	;extend d2 (clears out upper word)
	asl.l	#5,d2	;mult d2 by 32
	addi.l	#Spritetiles,d2	;IDA: Spritetiles ($5DE84)
	asl.w	#4,d4	;mult by 16 (# of sprite tiles by 16)
	asl.w	#5,d3	;mult by 32 (# of prev sprite tiles+VrChar by 32)
	move.l	d2,(a5)+
	move.w	d4,(a5)+	;words to transfer
	move.w	d3,(a5)+	;vram destination
	movem.w	(sp)+,d0-d4	;pop from stack
.dup
	move.b	d3,$A(a3,d5.w)	;move d3 into VRoffs of sprite
	;This and VRChar are for VRAM access
.noref
	move.w	(sp)+,d0	;pop from stack
	movem.w	d0-d2,-(sp)	;push to stack
	move.w	2(a2),d2	;move data at 2+a2 into d2 - Y global
	btst	#4,4(a3)	;check for Y flip
	beq.w	.noyflip	;branch if no y flip
	move.b	7(a2),d2	;move byte 7 (sizetab byte) into d2
	andi.w	#3,d2	;pass bit 1 and 2
	addq.w	#1,d2	;add 1
	asl.w	#3,d2	;mult by 8
	neg.w	d2	;negate d2
	sub.w	2(a2),d2	;sub Y global from d2
.noyflip
	add.w	d2,d1	;add d2 to d1 (d1=Ypos of Sort Cord)
	move.w	d1,(a6)	;move sprite's Ypos into a6 data (Satt)
	move.w	(a2),d2	;move data at a2 to d2 (X global into d2)
	btst	#3,4(a3)	;check for x flip
	beq.w	.noxflip	;branch if no x flip
	move.b	7(a2),d2	;move data at 7+a2 into d2
	andi.w	#$C,d2	;pass bit 3 and 4
	addq.w	#4,d2	;add 4
	asl.w	#1,d2	;mult by 2
	neg.w	d2	;negate d2
	sub.w	(a2),d2	;sub data at a2 from d2
.noxflip
	add.w	d2,d0	;add d2 to d0 (d0 = Xpos of Sort Cord)
	move.w	d0,6(a6)	;move sprite's Xpos into 6+a6 position (Satt)
	move.b	7(a2),2(a6)	;move sizetab byte into 2+a6
	move.b	d6,3(a6)	;move d6 (link counter) into 3+a6
	move.w	6(a2),d2	;move 6+a2 into d2 (to be used to check palette and set HVFlip)
	move.w	4(a3),d0	;move attribute into d0
	eor.w	d0,d2	;EOR d0 with d2
	andi.w	#$F800,d2	;pass top 5 bits
	btst	#0,5(a3)	;check if bit 0 of attribute+1 is 0
	beq.w	.nospec	;branch if zero
	btst	#$E,d2	;check if bit 14 is 0
	beq.w	.nospec	;branch if zero
	bset	#$D,d2	;set bit 13 to 0 - team 2 color
.nospec
	or.b	$A(a3,d5.w),d2	;OR Vroffs of a3+d5 to d2
	add.w	$12(a3),d2	;add VRchar to d2
	move.w	d2,4(a6)	;move d2 into 4+a6 (Satt)
	movem.w	(sp)+,d0-d2	;pop from stack
	addq.w	#1,d6	;add 1 to d6
	addq.w	#8,a6	;add 8 to a6
	addq.w	#8,a2	;add 8 to a2
	dbf	d5,.sloop	;loop if still sprites in frame
.exit
	movem.l	(sp)+,d0-d5/a0-a2
	move.w	(sp)+,4(a3)
	rts
find3d	;input: d0 = xfield, d1 = yfield, d2 = height off field. Output: d0 = xscreen, d1 = yscreen, or d1 = $4E20 (92 osflag) when off screen
	btst	#7,(sflags).w
	beq.w	.16936
	exg	d0,d1
	neg.w	d0
	subi.w	#$C5,d1
	bra.w	.1693E
.16936
	sub.w	(Hpos).w,d0
	sub.w	(Vpos).w,d1
.1693E
	cmp.w	#$90,d0
	bgt.w	.16970
	cmp.w	#$FF70,d0
	blt.w	.16970
	addi.w	#$100,d0
	add.w	d2,d1
	asr.w	#1,d2
	add.w	d2,d1
	cmp.w	#$90,d1
	bgt.w	.16970
	cmp.w	#$FF70,d1
	blt.w	.16970
	neg.w	d1
	addi.w	#$F0,d1
	rts
.16970
	move.w	#$4E20,d1
	rts
updatesound	;move the crowd noise volume (psg noise channel, asv) toward crowdlevel. Called from periodicevents
	move.w	(crowdlevel).w,d0
	asl.w	#3,d0
	addi.w	#$400,d0
	cmp.w	#$EFF,d0
	bls.w	.ip
	move.w	#$EFF,d0
.ip
	moveq	#$28,d2
	sub.w	(asv).w,d0
	cmp.w	d2,d0
	bgt.w	.169A0
	neg.w	d2
	cmp.w	d2,d0
	bge.w	.non
.169A0
	add.w	d2,(asv).w
	bpl.w	.non
	clr.w	(asv).w
.non
	move.b	#$C8,(VDP_PSG).l
	move.b	#1,(VDP_PSG).l
	move.b	(asv).w,d0
	eori.b	#$F,d0
	ori.b	#$F0,d0
	move.b	d0,(VDP_PSG).l
	rts
KillCrowd	;silence the crowd noise (psg). Called from Begin, SetupPauseScreen, StartHL2, ...
	move.b	#$E7,(VDP_PSG).l
	move.b	#$DF,(VDP_PSG).l
	move.b	#$C8,(VDP_PSG).l
	move.b	#1,(VDP_PSG).l
	move.b	#$FF,(VDP_PSG).l
	rts
