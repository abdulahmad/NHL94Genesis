;	NHL 94 (retail) segment $17A18-$17C71
;	94 only: the EA Sports screen (EASportsScreen, called from Begin) and the 94 helpers after it, then the
;	93 setoptions vblank handler (93 hockey93_08 VBlank_SetOptions, IDA loc_17C42). 94 put this code just
;	before that handler, so the handler ends this segment and LoadDefMenuOptions ($17C72, 93 DefaultMenus,
;	hockey94_09) follows. HiScoreScreen ($FED70) is not next to this code and is not in this segment.
;	Transcribed from lst/nhl94.bin.lst lines 54528-54846. IDA left $17B98-$17C41 as dc.b; it is code with
;	no xref and is written as instructions (sub_17B98, sub_17BBA, sub_17BCA, sub_17BE4).
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real
;	cmp / cmpi; fixopcodes.js patches the cmp encoding after assembly.
;	Inline print strings after printz use the String macro (length word includes itself).

EASportsScreen	;94 only. Called from Begin. Show the EA Sports screen until a button, or $50 x 4 frames (about 5 s)
	move.l	#loc_15E4C,(vbint).w	;vblank handler
	bclr	#1,(disflags).w
	move.w	#5,(Map3col1).w
	move.w	#$A000,(VmMap2).w
	move.w	#7,(Map2col1).w
	move.w	#$C000,(VmMap1).w
	move.w	#7,(Map1col1).w
	move.w	#$F000,(VmMap3).w
	move.w	#$F800,(VSPRITES).w
	move.w	#$FC00,(VSCRLPM).w
	movea.w	#(palfadenew-M68K_RAM),a0
	moveq	#$1F,d1			;32 longs: all 64 colours black
.clr	clr.l	(a0)+			;IDA: loc_17A5C
	dbf	d1,.clr
	bsr.w	sub_11044
	bsr.w	loc_115AA
	bsr.w	printz
	String	$FE,0,0,0
	movea.l	#unk_B425A,a2		;screen map. IDA hid this in the string (ori.b #$7C,d0 / ori.b #$5A,a3)
	movea.l	a2,a0
	movea.l	a2,a1
	adda.l	(a2)+,a0
	adda.l	(a2)+,a1
	clr.w	d0
	clr.w	d1
	move.w	(a1),d2
	move.w	2(a1),d3
	clr.w	d4
	moveq	#$F,d5
	bsr.w	dobitmap
	move.w	#$EEE,(palfadenew).w
	move.w	#0,(word_FFBD36).w
	move.w	#$18,(palcount).w	;fade in
	move	#$2500,sr		;vblank on
	move.w	#$50,(RNGseed).w	;frame count down in the random seed word
.wait	moveq	#4,d0			;IDA: loc_17AB0
	bsr.w	waitx			;4 frames; d1 = buttons
	tst.w	d1
	bne.w	.ex			;IDA: loc_17AC2. Button pressed
	subq.w	#1,(RNGseed).w
	bpl.s	.wait
.ex	move	#$2700,sr
	rts

sub_17AC8	;94 only. Set pojoy from the number of players for play modes 2 and 3. Called from $F844A
	cmpi.w	#2,(OptPlayMode).w
	blt.w	rtss2
	cmpi.w	#4,(OptPlayMode).w
	beq.w	rtss2
	moveq	#7,d0
	tst.w	(FourWayPlay).w
	beq.w	.set			;IDA: loc_17AEA
	move.w	#$B,d0			;4 way play
.set	sub.w	(OptNOP).w,d0
	move.w	d0,(pojoy).w
	rts

sub_17AF4	;94 only. Called from sub_F7B20. Draw the VisTeam and HomeTeam bitmaps (sub_17B78)
	movem.l	d0-d7/a0-a2,-(sp)
	cmpi.w	#4,(OptPlayMode).w
	beq.w	.opt			;IDA: loc_17B0A
	tst.w	(OptPlayMode).w
	bne.w	.draw			;IDA: loc_17B16
.opt	move.w	(Opt1Team).w,(HomeTeam).w
	move.w	(Opt2Team).w,(VisTeam).w
.draw	bsr.w	printz
	String	$BF,7,1,0
	move.w	(VisTeam).w,d1
	move.w	d1,d0
	asl.w	#6,d0			;64 bytes per team
	movea.l	#unk_F8BF4,a0
	move.l	$26(a0,d0.w),(dword_FFBD4E).w
	move.w	(word_FFD43A).w,d4
	bsr.w	sub_17B78
	bsr.w	printz
	String	$BF,$16,1,0
	move.w	(HomeTeam).w,d1
	move.w	d1,d0
	asl.w	#6,d0			;64 bytes per team
	movea.l	#unk_F8BF4,a0
	move.l	2(a0,d0.w),(dword_FFBD4A).w
	move.w	#$EEE,(word_FFBD52).w
	move.w	#2,d4
	bsr.w	sub_17B78
	bsr.w	sub_17190
	move.w	#$64,(palcount).w
	movem.l	(sp)+,d0-d7/a0-a2
	rts

sub_17B78	;94 only. dobitmap entry d1 of unk_AFE12 (d4 from the caller)
	clr.w	d0
	asl.w	#1,d1
	movea.l	#unk_AFE12,a0
	movea.l	a0,a1
	adda.l	(a0),a0
	adda.l	4(a1),a1
	movea.w	#$30A,a2
	move.w	(a1),d2
	moveq	#2,d3
	moveq	#0,d5
	bra.w	dobitmap

sub_17B98	;94 only, no xref (IDA dc.b). Like sub_17B78 with unk_ABA14, d4 = 2, d5 = 2
	clr.w	d0
	asl.w	#1,d1
	movea.l	#unk_ABA14,a0
	movea.l	a0,a1
	adda.l	(a0),a0
	adda.l	4(a1),a1
	movea.w	#$30A,a2
	move.w	(a1),d2
	moveq	#2,d3
	moveq	#2,d4
	moveq	#2,d5
	bra.w	dobitmap

sub_17BBA	;94 only, no xref (IDA dc.b). Set the print position, then erase 12 x 2 at it
	bsr.w	sub_17BCA
	moveq	#$C,d0			;12
	moveq	#2,d1			;2
	move.w	#$7FF,d2
	bra.w	eraser

sub_17BCA	;94 only (IDA dc.b). printz position string, then printx = $1A when a2 is the home team
	bsr.w	printz
	String	$BF,2,$A,0
	cmpa.w	#(HmShots-M68K_RAM),a2	;home team struct?
	bne.w	rtss2
	move.w	#$1A,(printx).w
	rts

sub_17BE4	;94 only, no xref (IDA dc.b). $26(a2) = 0 if a pad has team a2, else (gamelevel <= 2, line changes on)
	;a value from the team's .sodds
	movem.l	d0/a0,-(sp)
	clr.w	$26(a2)
	bsr.w	sub_17E42
	cmpa.w	#(HmShots-M68K_RAM),a2
	seq	d0
	ext.w	d0
	addq.w	#2,d0			;1 for the home team, 2 for the away team
	cmp.w	(cont1team).w,d0
	beq.w	.x
	cmp.w	(cont2team).w,d0
	beq.w	.x			;a pad has this team: leave $26(a2) = 0
	moveq	#0,d0
	cmpi.w	#2,(gamelevel).w
	bgt.w	.set
	tst.w	(OptLine).w
	bne.w	.set
	movea.w	#$30E,a0		;TeamList (teamdata94)
	move.w	(a2),d0
	asl.w	#2,d0
	movea.l	0(a0,d0.w),a0		;team block
	adda.w	$A(a0),a0		;ScoreOdds offset: a0 = .sodds
	moveq	#4,d0
	bsr.w	sub_10E88
	bsr.w	sub_10EB4
.set	move.w	d0,$26(a2)
.x	movem.l	(sp)+,d0/a0
	rts

VBlank_SetOptions	;IDA: loc_17C42. 93 hockey93_08 name: vbint handler stored by setoptions (also ROM $FB024).
	;92 vb2 (cramfade unless dfng), plus sub_15E72 (93 DumpSprites2) when dfok is set
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#2,(disflags).w		;dfng
	bne.w	.nograph		;IDA: loc_17C62
	bclr	#0,(disflags).w		;dfok
	beq.w	.fade			;IDA: loc_17C5E
	bsr.w	sub_15E72		;93 DumpSprites2
.fade	bsr.w	cramfade
.nograph	addq.w	#1,(vcount).w
	jsr	(MusicVB).l		;93 p_music_vblank
	movem.l	(sp)+,d0-d7/a0-a6
	rte
