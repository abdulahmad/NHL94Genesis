;	NHL 94 (retail) segment $9FD0-$B0E7
;	92 hockey.asm part 1, second half, as 93 hockey93_02.asm: ReplayMode, getpzjoy, suba4 / adda4,
;	UpdateCameraPos, RestoreReplayFrame, updatereplay, rtss8, updateplayers, updateanim, freezewindow, checkwindow.
;	94 adds the reverse angle replay (word_FFC2F4 bits 4, 6, 7), the replay icon timer (sub_A448 ... sub_A4D8),
;	4 way play pads and the fall-down position fixes in updateplayers. doinput (logic94_1) follows at $B0E8.
;	Transcribed from lst/nhl94.bin.lst lines 34505-35879. Global names are the 93 names where 93 has the
;	routine (IDA name in an ;IDA: comment); 94-only routines keep the IDA name. Local labels are the IDA
;	local names (_x -> .x) or the IDA address (loc_A058 -> .A058).
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp /
;	cmpi; fixopcodes.js patches the cmp encoding after assembly.
;	Inline print strings after printz use the String macro (length word includes itself, odd data is padded).
;	Replay frames are $62 bytes from $FFFF0000 (replaystart) to $FFFFAF54 (replayend); recbpr is the record
;	pointer. SortCords objects are $80 bytes (SCstruct).

ReplayMode	;no IDA label ($9FD0). Instant replay play-back control and display code. Called from the pause menu.
	;As 93: a d-pad press picks the nearest object in that direction and the camera follows it
	bclr	#0,(word_FFC2F6).w
	bsr.w	forceblack
	move.w	(disflags).w,-(sp)
	bset	#3,(sflags2).w
	bclr	#4,(word_FFC2F4).w
	jsr	(ClrHor).l
	move.w	#$400,d0
	move.w	(VmMap3).w,d1
	move.w	#$7FF,d2
	bsr.w	DoFill
	move.w	(ExtraChars).w,d4
	movea.l	#unk_BB4F6,a2
	jsr	(sub_11738).l
	jsr	(sub_A448).l
	bclr	#5,(sflags).w
	bclr	#5,(sflags3).w
	st	(byte_FFBE1E).w
	movea.l	(recbpr).w,a4
.A02A
	bsr.w	suba4
	tst.w	d7
	bne.s	.A02A
	jsr	(SprSort).l
	jsr	(setvideo).l
	bclr	#1,(sflags3).w
	clr.l	(padcont).w
	clr.l	(dword_FFBE7E).w
	clr.l	(dword_FFBE82).w
	move.w	#$18,(palcount).w
	moveq	#1,d7
.A058
	move.w	(vcount).w,d0
	sub.w	(oldvcount).w,d0
	cmp.w	d0,d7
	bhi.s	.A058
	move.w	(vcount).w,(oldvcount).w
	tst.w	(word_FFDEB4).w
	bmi.w	.A084
	sub.w	d7,(word_FFDEB4).w
	bpl.w	.A084
	clr.w	(word_FFDEB4).w
	jsr	(sub_A48A).l
.A084
	movem.l	d0/a3,-(sp)
	movea.l	#$FFFFB64A,a3
	move.w	#1,8(a3)
	movea.l	#$FFFFB6CA,a3
	move.w	#1,8(a3)
	movem.l	(sp)+,d0/a3
	moveq	#1,d7
	bsr.w	getpzjoy
	btst	#0,(word_FFC2F6).w
	beq.w	.A0C4
	andi.w	#$FFF0,d0
	ori.w	#8,d0
	andi.w	#$FFF0,d1
	andi.w	#$FFF0,d3
.A0C4
	movea.w	#(ReplayStarStruct-M68K_RAM),a5
	btst	#5,(sflags3).w
	beq.w	.A0DC
	move.w	d1,d5
	andi.w	#$F,d5
	beq.w	.A25E
.A0DC
	btst	#3,d0
	bne.w	.A25E
	cmpi.w	#$FF60,(a5)
	bgt.w	.A0F4
	move.w	#0,(a5)
	bra.w	*+4
.A0F4
	cmpi.w	#$FED0,$14(a5)
	bgt.w	.A104
	move.w	#0,$14(a5)
.A104
	bset	#5,(sflags).w
	bne.w	.A118
	move.w	(Hpos).w,(a5)
	move.w	(Vpos).w,$14(a5)
.A118
	move.w	d0,d5
	andi.w	#7,d5
	eori.w	#4,d5
	movea.w	#(SortCords-M68K_RAM),a1
	st	d3
	bclr	#5,(sflags3).w
	beq.w	.A136
	move.w	$16(a5),d3
.A136
	move.w	(a5),d0
	move.w	$14(a5),d1
	moveq	#$B,d2
	move.l	#$100,d4
	movem.w	d0-d1,-(sp)
.A148
	cmp.w	$52(a1),d3
	beq.w	.A1A6
	movem.w	(sp),d0-d1
	sub.w	(a1),d0
	sub.w	$14(a1),d1
	jsr	(vtoa).l
	btst	#3,d0
	bne.w	.A1A6
	sub.w	d5,d0
	addq.w	#1,d0
	andi.w	#7,d0
	cmp.w	#2,d0
	bhi.w	.A1A6
	movem.w	(sp),d0-d1
	sub.w	(a1),d0
	sub.w	$14(a1),d1
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	cmp.l	#4,d0
	bls.w	.A1A6
	cmp.l	d4,d0
	bhi.w	.A1A6
	move.l	d0,d4
	move.w	$52(a1),$16(a5)
	bset	#5,(sflags3).w
.A1A6
	adda.w	#$80,a1
	dbf	d2,.A148
	addq.w	#4,sp
	btst	#5,(sflags3).w
	beq.w	.A1DA
	move.w	$16(a5),d0
	asl.w	#7,d0
	movea.w	#(SortCords-M68K_RAM),a3
	adda.w	d0,a3
	moveq	#4,d4
	bsr.w	sub_C656
	bsr.w	UpdateCameraPos
	jsr	(setvideo).l
	bra.w	.A058
.A1DA
	bset	#5,(sflags).w
	eori.w	#4,d5
	asl.w	#2,d5
	lea	.dirtab(pc),a0
	move.w	0(a0,d5.w),d0
	add.w	(a5),d0
	cmp.w	#$88,d0
	bgt.w	.A202
	cmp.w	#$FF78,d0
	blt.w	.A202
	move.w	d0,(a5)
.A202
	move.w	2(a0,d5.w),d1
	add.w	$14(a5),d1
	cmp.w	#$126,d1
	bgt.w	.A21E
	cmp.w	#$FEDA,d1
	blt.w	.A21E
	move.w	d1,$14(a5)
.A21E
	movea.w	a5,a3
	clr.w	$18(a5)
	andi.w	#$FFF,(word_FFBE78).w
	ori.w	#$E000,(word_FFBE78).w
	bsr.w	UpdateCameraPos
	jsr	(setvideo).l
	bra.w	.A058
.dirtab	;scroll step per d-pad direction 0-7: x, y
	dc.w	0,2, 2,2
	dc.w	2,0, 2,-2
	dc.w	0,-2, -2,-2
	dc.w	-2,0, -2,2
.A25E
	st	$18(a5)
	btst	#5,d1
	beq.w	.A27A
	btst	#0,(word_FFC2F6).w
	bne.w	.A27A
	bchg	#1,(sflags3).w
.A27A
	btst	#6,d3
	beq.w	.A2B0
	btst	#0,(word_FFC2F6).w
	bne.w	.A2B0
	bsr.w	suba4
	bsr.w	suba4
	bsr.w	suba4
	bsr.w	suba4
	jsr	(SprSort).l
	jsr	(setvideo).l
	moveq	#1,d7
	bclr	#1,(sflags3).w
.A2B0
	btst	#0,(word_FFC2F6).w
	bne.w	.A306
	btst	#4,d3
	beq.w	.A306
	btst	#6,d3
	beq.w	.A2EE
	bclr	#5,(sflags3).w
	bclr	#5,(sflags).w
	move.w	d0,-(sp)
	move.w	(word_FFBE78).w,d0
	andi.w	#$FFF,d0
	ori.w	#$E000,d0
	move.w	d0,(word_FFBE78).w
	move.w	(sp)+,d0
	bra.w	.A058
.A2EE
	bsr.w	adda4
	jsr	(SprSort).l
	jsr	(setvideo).l
	asl.w	#1,d7
	bclr	#1,(sflags3).w
.A306
	btst	#1,(sflags3).w
	beq.w	.A326
	st	(lastsfx).w
	bsr.w	adda4
	move.w	(lastsfx).w,-(sp)
	bsr.w	sfx
	jsr	(SprSort).l
.A326
	jsr	(setvideo).l
	btst	#0,(word_FFC2F6).w
	bne.w	.A358
	btst	#7,d1
	beq.w	.A058
	jsr	(sub_A4A8).l
	bclr	#1,(sflags3).w
	bset	#0,(word_FFC2F6).w
	bne.w	.A358
	bra.w	.A058
.A358
	btst	#7,d1
	bne.w	.A39E
	btst	#6,d1
	bne.w	.A398
	btst	#4,d1
	bne.w	.A3A8
	btst	#5,d1
	beq.w	.A058
	bset	#6,(word_FFC2F4).w
	bclr	#0,(word_FFC2F6).w
	jsr	(sub_A4D8).l
	bsr.w	adda4
	jsr	(SprSort).l
	bra.w	.A058
.A398
	jmp	.A058
.A39E
	clr.w	(dword_FFCF20).w
	bset	#1,(word_FFC2F6).w
.A3A8
	bsr.w	forceblack
	ori.w	#$F000,(word_FFBE78).w
	bclr	#5,(sflags).w
	movea.l	(recbpr).w,a4
	bclr	#4,(word_FFC2F4).w
	bsr.w	RestoreReplayFrame
	jsr	(SprSort).l
	bclr	#3,(sflags2).w
	move.w	(sp)+,(disflags).w
	jsr	(sub_9CDC).l
	jsr	(sub_16CAC).l
	jsr	(sub_16CC4).l
	jsr	(sub_16CD2).l
	jsr	(sub_16CEE).l
	btst	#4,(disflags).w
	beq.w	.A40A
	jsr	(sub_16D0A).l
	jsr	(sub_16CFC).l
.A40A
	jsr	(SetHor).l
	jsr	(setvideo).l
	move.w	#$18,(palcount).w
	rts
getpzjoy	;read the joystick of the pad that paused. 94: pads 3 and 4 when FourWayPlay (word_FFC316 = 3 or 4)
	tst.w	(FourWayPlay).w
	bne.w	.A434
.A426
	btst	#1,(sflags).w
	bne.w	ReadJoy2
	bra.w	ReadJoy1
.A434
	tst.w	(word_FFC316).w
	beq.s	.A426
	cmpi.w	#3,(word_FFC316).w
	beq.w	ReadJoy3
	bra.w	ReadJoy4
sub_A448	;94 only. Show the replay icon (93 ReplayMode does this inline) and start the $F0 frame word_FFDEB4 timer
	move.w	#$F0,(word_FFDEB4).w
	bsr.w	printz
	String	$BD,2,2			;IDA hid this and moveq #$20,d0 in ori.b / andi.b
	moveq	#$20,d0
	moveq	#$55,d1
	moveq	#8,d2
	moveq	#4,d3
	move.w	(rinkvrcset).w,d4
	move.w	#0,d5
	movea.l	#Rinktilelist,a1
	btst	#4,(word_FFC2F4).w	;check if reverse angle replay
	beq.w	.A47E	;branch if not
	movea.l	#RevRinkTilelist,a1
.A47E
	adda.l	4(a1),a1
	movea.w	#$30A,a2
	bra.w	dobitmap
sub_A48A	;94 only. Erase the 8 x 4 replay icon (word_FFDEB4 timer ran out)
	jsr	(printz).l
	String	$BD,2,2			;IDA hid this and the three moves in ori.b / andi.b
	move.w	#8,d0			;8 wide
	move.w	#4,d1			;4 high
	move.w	#$7FF,d2
	jmp	eraser
sub_A4A8	;94 only. Show unk_BB4EE at 0,0 (16 x 11) and stop the word_FFDEB4 timer
	st	(word_FFDEB4).w
	bsr.w	printz
	String	$BD,2,0			;IDA hid this and moveq #0,d0 in ori.b
	moveq	#0,d0
	moveq	#0,d1
	moveq	#$10,d2
	moveq	#$B,d3
	move.w	(ExtraChars).w,d4
	move.w	#0,d5
	movea.l	#unk_BB4EE,a1
	adda.l	4(a1),a1
	movea.w	#$30A,a2
	bra.w	dobitmap
sub_A4D8	;94 only. Erase the 16 x 11 area sub_A4A8 drew
	jsr	(printz).l
	String	$BD,2,2			;IDA hid this and the three moves in ori.b / andi.b
	move.w	#$10,d0			;16 wide
	move.w	#$B,d1			;11 high
	move.w	#$7FF,d2
	jmp	eraser
suba4	;IDA: sub_A4F6. a4 = current replay frame. Back up 1 frame and set video parameters for display.
	;d7 = delay between frames, or zero at the end of the replay
	cmpa.l	#$FFFF0000,a4
	bne.w	.A510
	btst	#4,(sflags).w
	beq.w	.A520
	movea.l	#$FFFFAF54,a4
.A510
	suba.w	#$62,a4
	cmpa.l	(recbpr).w,a4
	bne.w	RestoreReplayFrame
	adda.w	#$62,a4
.A520
	bsr.w	RestoreReplayFrame
	clr.w	d7
	rts
adda4	;IDA: sub_A528. Step forward 1 frame (93 adda4). 94 first handles a reverse angle switch (word_FFC2F4 bit 6)
	bclr	#6,(word_FFC2F4).w
	beq.w	.A5D4
	movem.l	d0-d7/a0-a6,-(sp)
	bchg	#4,(word_FFC2F4).w
	move.w	(Hpos).w,-(sp)
	move.w	(Vpos).w,-(sp)
	bsr.w	forceblack2
	jsr	(vcountwait).l
	jsr	(vcountwait).l
	jsr	(sub_9CDC).l
	clr.w	(Hpos).w
	clr.w	(Vpos).w
	move.w	#$7D0,(Oldrow).w
	move.w	#1,d0
.A56C
	jsr	(setvideo).l
	jsr	(vcountwait).l
	dbf	d0,.A56C
	move.w	(sp)+,(Vpos).w
	move.w	(sp)+,(Hpos).w
	move.w	#1,d0
	jsr	(setvideo).l
.A58E
	jsr	(vcountwait).l
	dbf	d0,.A58E
	movem.l	a0,-(sp)
	movea.l	#$FFFFB64A,a0
	move.w	#1,8(a0)
	adda.w	#$80,a0
	move.w	#1,8(a0)
	movem.l	(sp)+,a0
	bsr.w	RevReplayAdj
	btst	#5,(sflags).w
	beq.w	*+4
.A5C4
	jsr	(sub_A448).l
	move.w	#$64,(palcount).w
	movem.l	(sp)+,d0-d7/a0-a6
.A5D4
	clr.w	d7
	btst	#2,(sflags2).w
	beq.w	adda42
	movem.l	a4,-(sp)
	bsr.w	adda43
	cmpa.l	(recbpr).w,a4
	movem.l	(sp)+,a4
	beq.w	rtss8
adda42	;IDA: loc_A5F4. adda4 without the sf2drec look-ahead: stop at the record point, else show the frame and
	;fall into adda43
	cmpa.l	(recbpr).w,a4
	beq.w	rtss8
	bsr.w	RestoreReplayFrame
adda43	;IDA: sub_A600. a4 += replay frame size ($62), wrapping from $FFFFAF54 (replayend) to $FFFF0000 (replaystart)
	adda.w	#$62,a4
	cmpa.l	#$FFFFAF54,a4
	bne.w	rtss8
	movea.l	#$FFFF0000,a4
	rts
UpdateCameraPos	;IDA: sub_A616. Camera struct a5 = object a3 x/y (negated for the reverse angle), Hpos/Vpos clamped
	movem.l	d0-d2,-(sp)
	move.w	(a3),d0
	btst	#7,(word_FFC2F4).w
	beq.w	.A628
	neg.w	d0
.A628
	move.w	d0,(a5)
	move.w	$14(a3),d1
	btst	#7,(word_FFC2F4).w
	beq.w	.A63A
	neg.w	d1
.A63A
	move.w	d1,$14(a5)
	cmp.w	#$3C,d0
	blt.w	.A64A
	move.w	#$3C,d0
.A64A
	cmp.w	#$FFC4,d0
	bgt.w	.A656
	move.w	#$FFC4,d0
.A656
	move.w	d0,(Hpos).w
	cmp.w	#$100,d1
	blt.w	.A666
	move.w	#$100,d1
.A666
	cmp.w	#$FF38,d1
	bgt.w	.A672
	move.w	#$FF38,d1
.A672
	move.w	d1,(Vpos).w
	movem.l	(sp)+,d0-d2
	rts
; set flag for reverse replay setup if needed
RevReplayAdj	;94 only. Set word_FFC2F4 bit 7 for a reverse angle replay, then fall into RestoreReplayFrame
	btst	#4,(word_FFC2F4).w	;check if reverse angle replay
	beq.w	RestoreReplayFrame	;branch if not
	bset	#7,(word_FFC2F4).w	;set bit 7
; a4 = current replay frame address to convert into normal coordinates
RestoreReplayFrame	;IDA: SetRCords (92 name). a4 = current replay frame address to convert into normal cordinates (92
	;SetRCords), then the other replay variables (92 nonshift). 94 flips x/y and frames for the reverse angle
	movem.l	d0-d2/a0/a6,-(sp)
	movea.l	#revframetbl,a6
	movea.l	a4,a0
	moveq	#$F,d1	;16 objects to convert (12 players/2 nets/puck/puck shadow)
	movea.w	#(SortCords-M68K_RAM),a3
.top
	move.w	2(a0),d2
	andi.w	#$3FF,d2
	btst	#9,d2
	beq.w	.chkrevx
	ori.w	#$FC00,d2
.chkrevx
	btst	#4,(word_FFC2F4).w	;check if reverse angle
	beq.w	.p	;branch if not
	neg.w	d2
.p
	move.w	d2,(a3)	;update Xpos
	move.l	(a0),d2
	asr.l	#4,d2
	asr.w	#6,d2
	btst	#9,d2
	beq.w	.chkrevy
	ori.w	#$FC00,d2
.chkrevy
	btst	#4,(word_FFC2F4).w	;check if reverse angle
	beq.w	.p1	;branch if not
	neg.w	d2
	cmp.w	#0,d1	;check if last object (puck shadow)
	bne.w	.p1	;branch if not
	addq.w	#2,d2	;update puck shadow Xpos
.p1
	move.w	d2,$14(a3)	;update Ypos
	move.w	(a0),d2
	asr.w	#4,d2
	andi.w	#$3FF,d2
	btst	#4,(word_FFC2F4).w	;check if reverse angle
	beq.w	.A738	;branch if not
	asl.w	#1,d2
	move.w	0(a6,d2.w),d2	;look up table to adjust d2
	cmpi.w	#$F,$52(a3)	;check if puck shadow
	bne.w	.A71C	;branch if not
	cmp.w	#$18A,d2
	beq.w	.A71C
	move.w	#$FC00,$14(a3)	;update Ypos of puck shadow
.A71C
	cmp.w	#1,d2	;check if frame is before frame 1 (out of range)
	blt.w	.A730	;branch if so
	cmp.w	#$34E,d2	;check if frame is >= 846 (last frame +1)
	bge.w	.A730	;branch if so
	bra.w	.A738	;branch if valid object frame
.A730
	move.w	(a0),d2
	asr.w	#4,d2
	andi.w	#$3FF,d2
.A738
	move.w	d2,6(a3)
	cmp.w	#$28D,d2	;check if frame is before glass shatter frames
	blt.w	.A75C	;branch if so
	cmp.w	#$292,d2	;check if frame is after glass shatter frames
	bge.w	.A75C	;branch if so
	btst	#4,(word_FFC2F4).w
	beq.w	.A75C
	move.w	#$190,$14(a3)
.A75C
	move.w	(a0),d2
	asr.w	#3,d2
	andi.w	#$1800,d2
	andi.w	#$E7FF,4(a3)
	or.w	d2,4(a3)
	btst	#4,(word_FFC2F4).w	;check if reverse angle replay
	beq.w	.A792	;branch if not
	move.w	6(a3),d2	;move frame into d2
	cmp.w	#$162,d2	;check if frame is before old fight frames
	blt.w	.A792	;branch if so
	cmp.w	#$179,d2	;check if frame is after old fight frames
	bge.w	.A792	;branch if so
	bchg	#3,4(a3)	;change X flip attribute for object
.A792
	addq.w	#4,a0
	adda.w	#$80,a3
	dbf	d1,.top	;loop to next object
	moveq	#5,d2
	movea.w	#(SortCords-M68K_RAM),a3
.A7A2
	move.b	(a0)+,$6F(a3)
	move.b	(a0),d0
	andi.w	#$F,d0
	cmp.w	#$F,d0
	bne.w	.A7B6
	moveq	#-1,d0
.A7B6
	move.w	d0,$34(a3)
	adda.w	#$80,a3
	move.b	(a0)+,d0
	lsr.b	#4,d0
	move.b	d0,$6F(a3)
	move.b	(a0),d0
	asl.b	#4,d0
	or.b	d0,$6F(a3)
	move.b	(a0)+,d0
	lsr.b	#4,d0
	andi.w	#$F,d0
	cmp.w	#$F,d0
	bne.w	.A7E0
	moveq	#-1,d0
.A7E0
	move.w	d0,$34(a3)
	adda.w	#$80,a3
	dbf	d2,.A7A2
	move.b	(a0)+,d0
	ext.w	d0
	move.w	d0,(puckz).w
	move.b	(a0)+,d0
	ext.w	d0
	move.w	d0,(unk_FFB7E2).w
	move.b	(a0)+,d0
	ext.w	d0
	move.w	d0,(lastsfx).w
	clr.w	d7
	move.b	(a0)+,d7
	move.w	(a0)+,d0
	andi.w	#$FFF,d0
	andi.w	#$F000,(word_FFBE78).w
	or.w	d0,(word_FFBE78).w
	move.w	(a0)+,(crowdframe).w
	move.w	(a0)+,(glovecords).w
	move.b	(a0)+,(PBnum).w
	clr.w	d0
	move.b	(a0)+,d0
	lsl.w	#4,d0
	ori.w	#$F00F,d0
	move.w	d0,(word_FFBE86).w
	btst	#5,(sflags).w
	beq.w	.A860
	movea.w	a5,a3
	btst	#5,(sflags3).w
	beq.w	.A858
	clr.w	$18(a5)
	move.w	$16(a5),d0
	asl.w	#7,d0
	movea.w	#(SortCords-M68K_RAM),a3
	adda.w	d0,a3
.A858
	bsr.w	UpdateCameraPos
	bra.w	.A880
.A860
	move.w	(a0)+,(Hpos).w
	move.w	(a0)+,(Vpos).w
	btst	#4,(word_FFC2F4).w
	beq.w	.A880
	neg.w	(Hpos).w
	neg.w	(Vpos).w
	jsr	(sub_A88C).l
.A880
	bclr	#7,(word_FFC2F4).w
	movem.l	(sp)+,d0-d2/a0/a6
	rts
sub_A88C	;94 only. Clamp Hpos to -$3C..$3C and Vpos to -$C8..$100
	move.w	d0,-(sp)
	move.w	#$3C,d0
	cmp.w	(Hpos).w,d0
	blt.w	.A8A6
	move.w	#$FFC4,d0
	cmp.w	(Hpos).w,d0
	ble.w	.A8AA
.A8A6
	move.w	d0,(Hpos).w
.A8AA
	move.w	#$100,d0
	cmp.w	(Vpos).w,d0
	blt.w	.A8C2
	move.w	#$FF38,d0
	cmp.w	(Vpos).w,d0
	ble.w	.A8C6
.A8C2
	move.w	d0,(Vpos).w
.A8C6
	move.w	(sp)+,d0
	rts
; called every frame to save replay events
; d7 = elapsed frames
updatereplay	;called every frame to save replay events, d7 = elapsed frames
	btst	#4,(gmode).w	;check if highlight
	bne.w	rtss8	;exit if so
	btst	#2,(sflags2).w	;check if replay record disabled
	beq.w	.A8F6	;branch if not
	tst.w	(word_FFDEF0).w
	beq.w	.A918
	subq.w	#1,(word_FFDEF0).w
	bpl.w	.A8F6
	clr.w	(word_FFDEF0).w
	bra.w	.A918
.A8F6
	addi.l	#$62,(recbpr).w
	cmpi.l	#$FFFFAF54,(recbpr).w
	bne.w	.A918
	bset	#4,(sflags).w
	move.l	#$FFFF0000,(recbpr).w
.A918
	movea.l	(recbpr).w,a0
	moveq	#$F,d2
	movea.w	#(SortCords-M68K_RAM),a3
.A922
	clr.l	(a0)
	move.w	(a3),d1
	andi.w	#$3FF,d1
	move.w	d1,2(a0)
	clr.l	d1
	move.w	$14(a3),d1
	asl.w	#6,d1
	asl.l	#4,d1
	or.l	d1,(a0)
	move.w	6(a3),d1
	asl.w	#4,d1
	or.w	d1,(a0)
	move.w	4(a3),d1
	andi.w	#$1800,d1
	asl.w	#3,d1
	or.w	d1,(a0)
	addq.w	#4,a0
	adda.w	#$80,a3
	dbf	d2,.A922
	moveq	#5,d2
	movea.w	#(SortCords-M68K_RAM),a3
.A95E
	move.b	$6F(a3),(a0)+
	move.w	$34(a3),d0
	bpl.w	.A96C
	moveq	#$F,d0
.A96C
	andi.w	#$F,d0
	move.b	d0,(a0)
	adda.w	#$80,a3
	move.b	$6F(a3),d0
	asl.w	#4,d0
	or.b	d0,(a0)+
	move.b	$6F(a3),d0
	lsr.b	#4,d0
	move.b	d0,(a0)
	move.w	$34(a3),d0
	bpl.w	.A990
	moveq	#$F,d0
.A990
	asl.w	#4,d0
	or.b	d0,(a0)+
	adda.w	#$80,a3
	dbf	d2,.A95E
	move.b	(puckz+1).w,(a0)+
	move.b	(byte_FFB7E3).w,(a0)+
	move.b	(lastsfx+1).w,(a0)+
	bset	#7,(lastsfx+1).w
	move.b	d7,(a0)+
	move.w	(word_FFBE78).w,(a0)+
	move.w	(crowdframe).w,(a0)+
	move.w	(glovecords).w,(a0)+
	move.b	(PBnum).w,(a0)+
	move.w	d0,-(sp)
	move.w	(word_FFBE86).w,d0
	lsr.w	#4,d0
	move.b	d0,(a0)+
	move.w	(sp)+,d0
	move.w	(Hpos).w,(a0)+
	move.w	(Vpos).w,(a0)+
rtss8	;IDA name (93 rtss2; 94 rtss2 is the rts at $15464)
	rts
; this routine calls all collision/animation/assignment code for all players
; d7 = elapse frames since last call
updateplayers	;this routine calls all collision/animation/assignment code for all players. d7 = elapsed frames
	btst	#7,(sflags).w	;check if screen is in horiz mode
	bne.w	.checkcrowd	;jump if horiz mode
	ori.w	#$F,(word_FFBE78).w
	cmpi.w	#5,(puckz).w	;check puckz with 5
	bgt.w	.gt	;branch if greater
.clrcnt
	clr.w	(PuckZCntr).w	;clear counter
	bra.w	.checkcrowd
.gt
	move.w	(TmpPuckZ).w,d0
	cmp.w	(puckz).w,d0
	beq.w	.pzeq	;branch if puckz equal to TmpPuckZ
	move.w	(puckz).w,(TmpPuckZ).w
	bra.s	.clrcnt
.pzeq
	addq.w	#1,(PuckZCntr).w	;add 1 to counter
	cmpi.w	#$10,(PuckZCntr).w	;compare counter to 10 (16 decmial)
	blt.w	.checkcrowd	;branch if less than
	clr.w	(PuckZCntr).w	;clear counter
	subq.w	#1,(puckz).w	;subtract 1 from puckz
.checkcrowd
	bclr	#6,(byte_FFC2FC).w	;Bit 6 = Crowd Meter bit
	move.w	(CurCrowdMeter).w,d0	;Move cur crowd meter to d0
	cmp.w	(CrowdRecord).w,d0	;compare with crowd record
	blt.w	.nobreak	;branch if less than
	bset	#6,(byte_FFC2FC).w	;set Crowd Meter bit
.nobreak
	jsr	(set_bit1_C2FE).l	;jump to turn on bit 1 of C2FE
	tst.w	(puckc).w
	bmi.w	.scload	;branch if no puck carrier
	bclr	#7,(byte_FFC2FE).w
	bclr	#1,(word_FFC2F8).w
	move.w	(puckc).w,d0	;move puckc SCnum into d0
	asl.w	#7,d0
	movea.l	#$FFFFB04A,a3	;start of player SCstructs (SortCords)
	adda.w	d0,a3	;add offset to a3
	btst	#1,$64(a3)	;checks if there is a breakaway
	beq.w	.scload	;branch if no breakaway
	bclr	#4,(word_FFC2FA).w	;clear if breakaway
.scload
	movea.w	#(SortCords-M68K_RAM),a3
.top
	move.l	(a3),$1C(a3)	;Xpos, oldXpos
	move.l	$14(a3),$20(a3)	;Ypos, oldYpos
	move.l	$18(a3),$24(a3)	;Zpos, oldZpos
	btst	#5,$64(a3)	;falling down?
	beq.w	.top2	;branch if not
	clr.w	$28(a3)	;clear Xvel
	clr.w	$2A(a3)	;clear Yvel
	tst.w	$5A(a3)	;check animation index
	bne.w	.AAAA	;branch if index not 0
	jsr	(sub_FEB54).l
	bra.w	.top2
.AAAA
	cmpi.w	#$193E,$58(a3)	;SPA_193E (frames94). check animation
	beq.w	.AB74
	cmpi.w	#$1A00,$58(a3)	;SPA_1A00 (frames94)
	beq.w	.AB48
	cmpi.w	#$18CC,$58(a3)	;SPA_18CC (frames94)
	beq.w	.AB5E
	cmpi.w	#$17E8,$58(a3)	;SPA_17E8 (frames94)
	beq.w	.AB32
	cmpi.w	#$1776,$58(a3)	;SPA_1776 (frames94)
	beq.w	.AAEA
	cmpi.w	#$185A,$58(a3)	;SPA_185A (frames94)
	beq.w	.AB0E
	bra.w	.top2
.AAEA
	move.w	#$124,d0
	cmpi.w	#$56,(FallXPos).w
	bgt.w	.AB02
	cmpi.w	#$FFAA,(FallXPos).w
	bgt.w	.AB06
.AB02
	move.w	#$116,d0
.AB06
	move.w	d0,$14(a3)
	bra.w	.top2
.AB0E
	move.w	#$FEDC,d0
	cmpi.w	#$56,(FallXPos).w
	bgt.w	.AB26
	cmpi.w	#$FFAA,(FallXPos).w
	bgt.w	.AB2A
.AB26
	move.w	#$FEEA,d0
.AB2A
	move.w	d0,$14(a3)
	bra.w	.top2
.AB32
	move.w	#$82,(a3)
	btst	#3,4(a3)
	beq.w	.top2
	move.w	#$FF7E,(a3)
	bra.w	.top2
.AB48
	move.w	#$88,(a3)
	btst	#3,4(a3)
	beq.w	.top2
	move.w	#$FF78,(a3)
	bra.w	.top2
.AB5E
	move.w	#$FF7E,(a3)
	btst	#3,4(a3)
	beq.w	.top2
	move.w	#$82,(a3)
	bra.w	.top2
.AB74
	move.w	#$FF78,(a3)
	btst	#3,4(a3)
	beq.w	.top2
	move.w	#$88,(a3)
.top2
	tst.w	$34(a3)	;check if on ice
	bmi.w	.nf1	;branch if not on ice
	move.w	$52(a3),d0
	cmp.w	(puckc).w,d0	;check if player has puck
	beq.w	.top3	;branch if puck carrier
	bclr	#1,$64(a3)	;clear breakaway bit
	bclr	#0,$64(a3)	;clear offsides bit
.top3
	bsr.w	updateanim
	sub.b	d7,$5E(a3)	;no puck control
	bpl.w	.np
	clr.b	$5E(a3)	;clear upper byte of nopuck
.np
	sub.b	d7,$5F(a3)	;subtract # of frames from nopuck+1
	bpl.w	.ABC2
	clr.b	$5F(a3)	;clear lower byte of nopuck
.ABC2
	btst	#6,(sflags3).w	;check if penalty timer is up
	beq.w	.ABE6
	clr.w	d0
	move.b	$66(a3),d0	;player offset on roster
	bmi.w	.ABE6
	add.w	d0,d0
	addi.w	#$136,d0
	jsr	(loadTeamStruct).l
	addq.w	#1,0(a2,d0.w)	;add 1 to TOI for player
.ABE6
	cmpi.w	#$145C,$58(a3)	;SPA_145C (frames94). check animation
	beq.w	.done
	cmpi.w	#$1AF4,$58(a3)	;SPAinjury1 (frames94). check animation
	beq.w	.done
	moveq	#$11,d4
	tst.w	(word_FFD06E).w
	beq.w	.notoside
	moveq	#$16,d4
.notoside
	mulu.w	d7,d4	;update velocity
	tst.w	$18(a3)	;Zpos
	bne.w	.y2	;no deceleration
	moveq	#6,d2
	btst	#0,$62(a3)	;pfdoff - player deceleration
	beq.w	.off
	moveq	#9,d2	;this value used when player receiving pass. Also the puck will use this when "normal"
.off
	move.w	$28(a3),d0	;Xvel
	beq.w	.x2
	asr.w	d2,d0	;shift d0 right d2 times
	bne.w	.x1	;branch if d0 not zero
	moveq	#1,d0	;make d0 1 if it was 0
.x1
	sub.w	d0,$28(a3)	;Xvel
.x2
	move.w	$2A(a3),d0	;Yvel
	beq.w	.y2	;branch if d0 is 0
	asr.w	d2,d0	;shift d0 to the right d2 times
	bne.w	.y1	;branch if d0 not 0
	moveq	#1,d0	;make d0 1 if it was 0
.y1
	sub.w	d0,$2A(a3)	;sub d0 from Yvel
.y2
	move.w	$28(a3),d0	;Xvel
	beq.w	.x3	;branch if d0 is 0
	muls.w	d4,d0	;mult d0 by d4
	add.l	d0,(a3)	;add to Xpos
.x3
	move.w	$2A(a3),d0	;Yvel
	beq.w	.y3	;branch if d0 is 0
	muls.w	d4,d0	;mult d0 by d4
	add.l	d0,$14(a3)	;add to Ypos
.y3
	tst.w	$18(a3)	;check Zpos
	bmi.w	.done	;branch if negative
	bne.w	.z1	;branch if not 0
	tst.w	$2C(a3)	;check Zvel
	beq.w	.done	;branch if 0
.z1
	asl.w	#1,d4	;mult d4 by 2
	sub.w	d4,$2C(a3)	;sub d4 from Zvel
	asl.w	#1,d4	;mult d4 by 2
	sub.w	d4,$2C(a3)	;sub d4 from Zvel
	lsr.w	#2,d4	;divide d4 by 4
	move.w	$2C(a3),d0	;move Zvel into d0
	muls.w	d4,d0	;mult d0 by d4
	add.l	d0,$18(a3)	;add d0 to Zpos
	bpl.w	.done	;branch if d0+Zpos is positive
	clr.l	$18(a3)	;clear Zpos
	neg.w	$2C(a3)	;negate Zvel
	asr.w	$2C(a3)	;divide Zvel by 2
	moveq	#5,d0	;move 5 into d0
	sub.b	$2C(a3),d0	;sub Zvel from d0
	bpl.w	.chkpuck	;branch if result is positive
	clr.w	d0	;clear d0
.chkpuck
	cmp.w	#3,d0	;compare d0 to 3
	bhi.w	.done	;branch if higher than 3
	addi.w	#$2C,d0	;','   ; #SFXpuckice
	move.w	d0,-(sp)
	bsr.w	sfx
.done
	move.w	$52(a3),d6	;SCnum
	cmp.w	(puckc).w,d6	;check if puck carrier
	bne.w	.tp	;not puck carrier
	btst	#0,$63(a3)	;pf2fight - check if fighting
	bne.w	.tp
	btst	#7,(sflags).w	;#sfhor - check if in horiz mode
	bne.w	.tp
	moveq	#-2,d4	;-2 - pad index for puck carrier
	bsr.w	sub_C656
.tp
	btst	#0,(sflags2).w	;sf2faceoff- check for faceoff
	bne.w	.tp2	;branch if faceoff
	tst.w	(word_FFD412).w
	beq.w	.tp2
	subq.w	#1,(word_FFD412).w
	beq.w	.ACFE
	bpl.w	.tp2
.ACFE
	clr.w	(word_FFD412).w
	move.w	#$1111,(word_FFBF06).w
	move.w	#$1111,(word_FFBF08).w
.tp2
	cmp.w	(c1playernum).w,d6	;check if cont 1 is puck carrier
	bne.w	.t0
	bsr.w	ReadJoy1
	clr.w	d4	;pad index for cont 1 player
	move.w	#$FFFF,(joypuckcarrier).w
	bsr.w	doinput	;B button
	bra.w	.t1
.t0
	cmp.w	(c2playernum).w,d6	;check if cont 2 is puck carrier
	bne.w	.t1
	bsr.w	ReadJoy2
	moveq	#2,d4	;pad index for cont 2 player
	move.w	#$FFFF,(joypuckcarrier).w
	bsr.w	doinput	;B button
.t1
	cmp.w	#$B,d6	;check if SCnum 0-11 were puck carrier (players)
	bgt.w	.t1cont	;jump if not
	tst.w	(cont3team).w	;check if there is 3 controllers?
	beq.w	.ADE2
	cmp.w	(c3playernum).w,d6
	bne.w	.ADE2
	jsr	(ReadJoy3).l
	clr.l	d4
	clr.w	(joypuckcarrier).w
	move.w	(cont1team).w,-(sp)
	move.w	(cont3team).w,(cont1team).w
	move.w	(c1playernum).w,-(sp)
	move.w	(c3playernum).w,(c1playernum).w
	move.w	(word_FFBF06).w,-(sp)
	move.w	(word_FFBF08).w,(word_FFBF06).w
	move.w	(word_FFBF0E).w,-(sp)
	move.w	(word_FFBF0A).w,(word_FFBF0E).w
	move.w	(word_FFD41E).w,-(sp)
	move.w	(word_FFD420).w,(word_FFD41E).w
	move.w	(word_FFBE78).w,-(sp)
	move.w	(word_FFBE86).w,(word_FFBE78).w
	bsr.w	doinput	;B button
	move.w	(word_FFBE78).w,(word_FFBE86).w
	move.w	(sp)+,(word_FFBE78).w
	move.w	(word_FFD41E).w,(word_FFD420).w
	move.w	(sp)+,(word_FFD41E).w
	move.w	(word_FFBF0E).w,(word_FFBF0A).w
	move.w	(sp)+,(word_FFBF0E).w
	move.w	(word_FFBF06).w,(word_FFBF08).w
	move.w	(sp)+,(word_FFBF06).w
	move.w	(c1playernum).w,(c3playernum).w
	move.w	(sp)+,(c1playernum).w
	move.w	(cont1team).w,(cont3team).w
	move.w	(sp)+,(cont1team).w
.ADE2
	tst.w	(cont4team).w	;check if there is 4 controllers?
	beq.w	.t1cont
	cmp.w	(c4playernum).w,d6
	bne.w	.t1cont
	jsr	(ReadJoy4).l
	moveq	#2,d4
	move.w	#1,(joypuckcarrier).w
	move.w	(cont2team).w,-(sp)
	move.w	(cont4team).w,(cont2team).w
	move.w	(c2playernum).w,-(sp)
	move.w	(c4playernum).w,(c2playernum).w
	move.w	(word_FFBF06).w,-(sp)
	move.w	(word_FFBF08).w,(word_FFBF06).w
	move.w	(word_FFBF10).w,-(sp)
	move.w	(word_FFBF0C).w,(word_FFBF10).w
	move.w	(word_FFD41E).w,-(sp)
	move.w	(word_FFD420).w,(word_FFD41E).w
	move.w	(word_FFBE78).w,-(sp)
	move.w	(word_FFBE86).w,(word_FFBE78).w
	bsr.w	doinput	;B button
	move.w	(word_FFBE78).w,(word_FFBE86).w
	move.w	(sp)+,(word_FFBE78).w
	move.w	(word_FFD41E).w,(word_FFD420).w
	move.w	(sp)+,(word_FFD41E).w
	move.w	(word_FFBF10).w,(word_FFBF0C).w
	move.w	(sp)+,(word_FFBF10).w
	move.w	(word_FFBF06).w,(word_FFBF08).w
	move.w	(sp)+,(word_FFBF06).w
	move.w	(c2playernum).w,(c4playernum).w
	move.w	(sp)+,(c2playernum).w
	move.w	(cont2team).w,(cont4team).w
	move.w	(sp)+,(cont2team).w
.t1cont
	move.w	$36(a3),d0	;assnum
	clr.w	d1
	move.b	$38(a3,d0.w),d1	;asslist of SCstruct
	asl.w	#2,d1	;mult by 4
	movea.l	#asstab,a0
	movea.l	0(a0,d1.w),a0	;get address of assignment to use for jmp
	jsr	(loadTeamStruct).l
	jsr	(a0)	;call assignment for this player
	clr.w	$4E(a3)	;clear wallcos
	clr.w	$50(a3)	;clear wallsin
	move.w	(a3),d2	;Xpos
	move.w	$14(a3),d3	;Ypos
	cmp.w	$1C(a3),d2	;compare to oldXpos
	bne.w	.cc	;branch if not equal
	cmp.w	$20(a3),d3	;compare to oldYpos
	beq.w	.nf	;branch if equal
.cc
	jsr	(checkcoll).l	;check for collisions
.nf
	move.w	d7,d0	;move d7 into d0 (elapsed frames)
	asl.w	#1,d0	;mult by 2
	sub.w	d0,$32(a3)	;reduce impact at a constant rate
	bpl.w	.nf1	;branch if positive
	clr.w	$32(a3)	;clear impact if negative or zero
.nf1
	move.w	$32(a3),$30(a3)	;move impact into limpact
	adda.w	#$80,a3	;SCstruct size
	cmpi.w	#$F,-$2E(a3)	;compare Sortobjs-1 to SCnum-SCstruct
	blt.w	.top	;loop for all Sort objects
	rts
; frame switch control on struct a3
updateanim	;frame switch control on struct a3
	tst.w	$58(a3)	;test SPA
	bne.w	.ia	;branch if not 0
	bclr	#5,$62(a3)	;clear anim lock
	bclr	#1,$63(a3)	;clear anim in progress
	rts
.ia
	movea.l	#SPAlist,a0	;animation data tables (frames94)
	adda.w	$58(a3),a0	;add SPA to a0 address
	move.w	$10(a0),d1	;16 dec - attributes for anim
	move.w	$54(a3),d0	;facedir into d0
	btst	#7,(sflags).w	;check if horizontal mode
	beq.w	.nhor	;branch if not
	cmpi.w	#$C,$52(a3)	;compare to 12 (check if a player, not the puck or nets)
	bge.w	.nhor	;branch if greater than (puck or nets)
	subq.w	#2,d0	;direction adjust for horizontal rink
	andi.w	#7,d0
.nhor
	btst	#3,4(a3)	;x flip flag
	beq.w	.nox	;branch if no flip
	neg.w	d0	;negate d0
	addq.w	#8,d0	;add 8 to d0 for flipping
	andi.w	#7,d0	;pass first 3 bits
.nox
	asl.w	#1,d0	;mult by 2
	adda.w	0(a0,d0.w),a0	;add a0 + d0 offset to a0 - This moves the SPF value into a0
	move.w	$5A(a3),d0	;SPANum into d0 (index into animation)
	move.w	0(a0,d0.w),d2	;a0 + d0 offset into d2 - this is the new SPF frame of this animation
	tst.w	$5C(a3)	;check if SPAcnt is 0 (time for a new frame)
	bmi.w	.1	;branch if so (SPAcnt is negative)
	sub.w	d7,$5C(a3)	;sub frames elasped from SPAcnt
	bpl.w	.cframe	;branch if SPAcnt is positive
	addq.w	#4,$5A(a3)	;add 4 to SPAnum (set for next index)
	addq.w	#4,d0	;add 4 to d0 (currently holds current index)
	tst.w	-2(a0,d0.w)	;test -2 offset from a0 + d0 (this is the frame time for the previous frame)
	bpl.w	.1	;branch if positive (not the end of the animation)
	clr.w	d0	;clear d0
	clr.w	$5A(a3)	;clear SPANum
	bclr	#5,$62(a3)	;clear animation lock
	bclr	#1,$63(a3)	;clear animation in progress
	bclr	#5,$64(a3)	;clear fall down flag
	btst	#0,d1	;check if anim attribute loops
	bne.w	.1	;loop
	clr.w	$58(a3)	;clear SPA
.1
	move.w	2(a0,d0.w),d0	;move frame time for animation frame into d0
	bpl.w	.0	;branch if positive
	neg.w	d0	;make d0 negative (this is the case if final frame)
.0
	move.w	d0,$5C(a3)	;move d0 into SPAcnt
.cframe
	sub.b	d7,$65(a3)	;sub frames elapsed from glitch - limit minimum time between frame switches
	bpl.w	.rtss	;branch if glitch is positive still
	clr.b	$65(a3)	;clear glitch
	cmp.w	6(a3),d2	;compare frame to d2
	beq.w	.rtss	;branch if equal
	move.w	d2,6(a3)	;move d2 into frame
	move.b	#4,$65(a3)	;move 4 into glitch - /60 sec min frame switch time
.rtss
	rts
freezewindow	;lock scrolling to the current position
	move.w	(Vpos).w,(yc1).w
	move.w	(Hpos).w,(xc1).w
	bset	#6,(sflags).w
	rts
checkwindow	;set Hpos and Vpos according to how the screen should follow the puck
	move.w	(yc1).w,d2
	move.w	(xc1).w,d3
	btst	#6,(sflags).w
	bne.w	.B042
	movea.w	#(puckx-M68K_RAM),a3
	move.w	(puckc).w,d0
	bmi.w	.B02A
	asl.w	#7,d0
	movea.w	#(SortCords-M68K_RAM),a3
	adda.w	d0,a3
	move.w	d7,d0
	add.w	d0,d0
	btst	#7,$62(a3)
	beq.w	.B016
	add.w	d0,(yleader).w
	cmpi.w	#$32,(yleader).w
	blt.w	.B02A
	move.w	#$32,(yleader).w
	bra.w	.B02A
.B016
	sub.w	d0,(yleader).w
	cmpi.w	#$FFCE,(yleader).w
	bgt.w	.B02A
	move.w	#$FFCE,(yleader).w
.B02A
	move.w	$2A(a3),d2
	asr.w	#7,d2
	add.w	$14(a3),d2
	add.w	(yleader).w,d2
	move.w	(a3),d3
	move.w	d2,(yc1).w
	move.w	d3,(xc1).w
.B042
	move.w	d2,d0
	sub.w	(Vpos).w,d0
	cmp.w	#$FFF6,d0
	bge.w	.B066
	move.w	d2,d1
	subi.w	#$FFF6,d1
	cmp.w	#$FF38,d1
	bgt.w	.B080
	move.w	#$FF38,d1
	bra.w	.B080
.B066
	cmp.w	#$A,d0
	ble.w	.B094
	move.w	d2,d1
	subi.w	#$A,d1
	cmp.w	#$100,d1
	blt.w	.B080
	move.w	#$100,d1
.B080
	sub.w	(Vpos).w,d1
	beq.w	.B094
	asr.w	#4,d1
	bne.w	.B090
	addq.w	#1,d1
.B090
	add.w	d1,(Vpos).w
.B094
	move.w	d3,d0
	sub.w	(Hpos).w,d0
	cmp.w	#$FFD8,d0
	bge.w	.B0B8
	move.w	d3,d1
	subi.w	#$FFD8,d1
	cmp.w	#$FFC4,d1
	bge.w	.B0D2
	move.w	#$FFC4,d1
	bra.w	.B0D2
.B0B8
	cmp.w	#$28,d0
	ble.w	.B0E6
	move.w	d3,d1
	subi.w	#$28,d1
	cmp.w	#$3C,d1
	ble.w	.B0D2
	move.w	#$3C,d1
.B0D2
	sub.w	(Hpos).w,d1
	beq.w	.B0E6
	asr.w	#4,d1
	bne.w	.B0E2
	addq.w	#1,d1
.B0E2
	add.w	d1,(Hpos).w
.B0E6
	rts
