;	NHL 94 (retail) segment $15D9A-$162FD
;	92 Video.asm first half, as 93 video93_1.asm: VBlank, vb2, IRQ7, DumpSprites, DumpSprites2, DoDMAlist, SetScroll2,
;	setvideo and the sprite builders it calls (updatescroll, showref, checkfo, showzam, SetSframe, showcrowd). showclock
;	(video94_2) follows at $162FE.
;	Transcribed from lst/nhl94.bin.lst lines 51765-52286. Global names are the IDA names, or the 93 name where IDA has an
;	auto name (IDA name in an ;IDA: comment); VBlank and vb2 have no IDA label. The IDA routines 93 writes as locals are
;	locals: showzam .ftab (unk_1615E), showcrowd .pb (sub_16226) and .sc (sub_16246). Local labels are the IDA local names
;	(_x -> .x) or the IDA address (loc_15DB6 -> .15DB6).
;	EA's compiler emits cmp #imm,Dn as CMP (Bxxx), SNASM emits CMPI (0Cxx). The source has the real cmp / cmpi;
;	fixopcodes.js patches the cmp encoding after assembly.
;	Bits: disflags 0 dfok, 2 dfng, 3 dfclock, 4 face off; sflags 0 sfpz, 7 sfhor; sflags2 1 sf2refref.

VBlank	;IDA: loc_15D9A (93 name; 93 IDA VBlank_org). Main vblank code for game play (vbint target, set by setupice and sub_16BAC). DumpSprites when
	;dfok is set, cramfade, then the game clock. 94: word_FFC2FA bit 2 keeps the clock running after the whistle, and with word_FFC2FA bit 1
	;(penalty shot / shootout) word_FFD454 counts down instead (word_FFD456 jiffies, not while word_FFC2FA bit 7 is set)
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#2,(disflags).w	;dfng: don't touch the vdp
	bne.w	.15DBA
	bclr	#0,(disflags).w	;dfok
	beq.w	.15DB6
	bsr.w	DumpSprites
.15DB6
	bsr.w	cramfade
.15DBA
	btst	#0,(sflags).w	;sfpz
	bne.w	.15E1A
	btst	#2,(word_FFC2FA).w	;94 only
	bne.w	.15DD8
	btst	#0,(gmode).w	;gmclock: game clock stopped
	bne.w	.15E1A
.15DD8
	btst	#1,(word_FFC2FA).w	;94 only: penalty shot / shootout clock
	bne.w	.15E2A
	tst.w	(gameclock).w
	beq.w	.15E1A
	subi.w	#$AAA,(word_FFC46A).w	;jiffy ($10000/24). word_FFC46A = gameclock+2
	bcc.w	.15E1A
	bset	#3,(disflags).w	;dfclock
	subq.w	#1,(gameclock).w
	cmpi.w	#$3D,(gameclock).w	;61
	bgt.w	.15E1A
	cmpi.w	#$3C,(gameclock).w	;60
	blt.w	.15E1A
	move.w	#2,-(sp)	;SFXbeep2, played when gameclock reaches 60
	bsr.w	sfx
.15E1A
	addq.w	#1,(vcount).w	;92 Vcount
	jsr	(MusicVB).l	;93 p_music_vblank
	movem.l	(sp)+,d0-d7/a0-a6
	rte
.15E2A
	tst.w	(word_FFD454).w
	beq.s	.15E1A
	subi.w	#$AAA,(word_FFD456).w
	bcc.s	.15E1A
	bset	#3,(disflags).w
	btst	#7,(word_FFC2FA).w
	bne.s	.15E1A
	subq.w	#1,(word_FFD454).w
	bra.s	.15E1A
vb2	;IDA: loc_15E4C (93 name). Vblank used for palfades only, no dmas (vbint target). No rte here: falls into IRQ7
	movem.l	d0-d7/a0-a6,-(sp)
	btst	#2,(disflags).w
	bne.w	.15E5E
	bsr.w	cramfade
.15E5E
	addq.w	#1,(vcount).w
	jsr	(MusicVB).l	;93 p_music_vblank
	movem.l	(sp)+,d0-d7/a0-a6
IRQ7	;rte only. vb2 falls in; the vector table ($60, $64, ...) points here
	rte
DumpSprites	;IDA: sub_15E6E (93 name). Transfer (by dma) scroll stuff, sprite table, vram data in dmalist. Called from VBlank when dfok was set. Falls into DumpSprites2
	bsr.w	SetScroll2
DumpSprites2	;IDA: sub_15E72 (93 name). Transfer sprite table, then the dma list. Falls into DoDMAlist. Also called from VBlank_SetOptions (attract94)
	movea.w	#(Satt-M68K_RAM),a0
	move.w	(word_FFC2E8).w,d0	;93 Sattsize: words
	move.w	(VSPRITES).w,d1
	bsr.w	DoDMA
DoDMAlist	;IDA name (93 DoDMAList; symbols are case-insensitive). Transfer data from dmalist. Also called from setupice
	movea.l	(DMAlistend).w,a6
	cmpa.l	#DMAList,a6
	beq.w	rtss2	;list empty
.15E90
	move.w	-(a6),d1	;vram address
	move.w	-(a6),d0	;words
	movea.l	-(a6),a0	;source
	bsr.w	DoDMA
	cmpa.l	#DMAList,a6
	bne.s	.15E90
	rts
SetScroll2	;IDA: sub_15EA4 (93 name; 93 IDA DoScroller). Write Hscroll / Vscroll to the vdp. Called from DumpSprites
	move.w	(VSCRLPM).w,d0
	addq.w	#2,d0
	bsr.w	Vmaddr
	move.w	(Hscroll).w,(a0)
	move.l	#$40020010,4(a0)	;vsram write, address 2
	move.w	(Vscroll).w,(a0)
	rts
setvideo	;this is not vblank code but sets up ram for vblank transfers. Called once per game frame (DoGameFrame, PauseMode, ...). 94 adds sub_FD78A and Crowd_Noise
	movem.l	d0-d7/a0-a6,-(sp)
.15EC4
	btst	#0,(disflags).w	;dfok: wait for vblank to take the last frame
	bne.s	.15EC4
	movea.w	#(DMAList-M68K_RAM),a5	;dma transfer list
	bsr.w	updatescroll
	movea.w	#(Satt-M68K_RAM),a6	;sprite attribute table area
	moveq	#1,d6	;link counter
	bsr.w	checkfo
	bsr.w	checksso
	bsr.w	setsortcords
	bsr.w	setffo
	bsr.w	showclock
	bsr.w	showzam
	jsr	(sub_FD78A).l	;94 only
	bsr.w	showcrowd
	bsr.w	showref
	jsr	(Crowd_Noise).l	;94 only (IDA Crowd_Noise?)
	cmpa.w	#(Satt-M68K_RAM),a6	;no sprites: one blank sprite
	bne.w	.15F12
	clr.l	(a6)+
	clr.l	(a6)+
.15F12
	clr.b	-5(a6)	;end sprite list
	move.l	a6,d0
	subi.l	#Satt,d0
	lsr.w	#1,d0	;words
	move.w	d0,(word_FFC2E8).w	;93 Sattsize
	move.l	a5,(DMAlistend).w
	bset	#0,(disflags).w	;dfok
	movem.l	(sp)+,d0-d7/a0-a6
	rts
updatescroll	;IDA name (92 name; 93 show_rink). Using hpos and vpos set scroll cords; queue rink map rows on the dma list (a5) when vertical
	;scrolling needs new rows. Called from setvideo. 94 takes the rows from Rinktilelist, or RevRinkTilelist in a reverse angle replay
	;(word_FFC2F4 bit 4)
	btst	#7,(sflags).w	;sfhor
	bne.w	rtss2
	moveq	#-$40,d0	;-192+128 (IDA #$FFFFFFC0)
	sub.w	(Hpos).w,d0
	move.w	(Vpos).w,d1
	move.w	d0,(Hscroll).w
	move.w	d1,(Vscroll).w
	neg.w	(Vscroll).w
	move.w	(Oldrow).w,d4
	asr.w	#3,d1
	move.w	d1,(Oldrow).w
	moveq	#$1F,d3	;max lines to update
	cmp.w	d4,d1
	beq.w	rtss2	;same row as last frame
	movea.l	#Rinktilelist,a0
	btst	#4,(word_FFC2F4).w	;94 only: reverse angle replay
	beq.w	.15F7C
	movea.l	#RevRinkTilelist,a0
.15F7C
	adda.l	4(a0),a0	;a0 = map header: (a0) = chars per row, data at 4(a0) (the move / adda leave the cmp flags)
	blt.w	.su0	;row went up
.sd
	move.w	d1,d0
	neg.w	d0
	addi.w	#$1E,d0
	andi.w	#$1F,d0
	asl.w	#7,d0
	add.w	(VmMap2).w,d0
	move.w	d0,6(a5)
	move.w	#$1E,d0
	sub.w	d1,d0
	move.w	(a0),4(a5)
	mulu.w	(a0),d0
	add.w	d0,d0
	lea	4(a0,d0.w),a1
	move.l	a1,(a5)
	addq.w	#8,a5
	subq.w	#1,d1
	cmp.w	d4,d1
	dbeq	d3,.sd
	rts
.su0
	move.w	d1,d0
	neg.w	d0
	addi.w	#$1D,d0
	andi.w	#$1F,d0
	asl.w	#7,d0
	add.w	(VmMap2).w,d0
	move.w	d0,6(a5)
	move.w	#$3D,d0
	sub.w	d1,d0
	move.w	(a0),4(a5)
	mulu.w	(a0),d0
	add.w	d0,d0
	lea	4(a0,d0.w),a1
	move.l	a1,(a5)
	addq.w	#8,a5
	addq.w	#1,d1
	cmp.w	d4,d1
	dbeq	d3,.su0
	rts
showref	;draw ref graphics. a5 = dma list, a6 = sprite table, d6 = link counter. Called from setvideo
	bclr	#1,(sflags2).w	;sf2refref
	beq.w	rtss2
	movea.w	#(RefRamMap-M68K_RAM),a0
	movea.w	#(VmMap1-M68K_RAM),a1
	move.w	2(a1),d2
	moveq	#2,d0	;refy: Xpos on ice screen
	btst	#7,(sflags).w
	beq.w	.16014
	moveq	#$F,d0	;Ypos on scoreboard screen
.16014
	asl.w	d2,d0
	moveq	#2,d1
	asl.w	d2,d1
	addq.w	#2,d0
	btst	#7,(sflags).w
	beq.w	.1602A
	addi.w	#$B,d0
.1602A
	asl.w	#1,d0
	add.w	(a1),d0
	moveq	#7,d2
.16030
	move.l	a0,(a5)+
	move.w	#7,(a5)+
	move.w	d0,(a5)+
	adda.w	#$E,a0
	add.w	d1,d0
	dbf	d2,.16030
	rts
checkfo	;check for face off sprites (93 checkfo and checkfo2; 94 has no checkfo2 label). 3 entries of dword_FFBDA8 (93 fofdata2): word frame, word flags. Called from setvideo
	btst	#0,(sflags).w	;sfpz
	bne.w	rtss2
	btst	#4,(disflags).w	;face off flag
	beq.w	rtss2
	movea.w	#(dword_FFBDA8-M68K_RAM),a3
	moveq	#2,d0
.1605E
	move.w	(a3),d4
	bmi.w	.160EE
	beq.w	.160EE
	movea.l	#unk_A78AE,a2	;93 FaceOffSprites
	adda.l	4(a2),a2
	add.w	d4,d4
	move.w	2(a2,d4.w),d5
	sub.w	0(a2,d4.w),d5
	lsr.w	#3,d5
	subq.w	#1,d5
	adda.w	0(a2,d4.w),a2
.16084
	move.w	2(a2),d2
	addi.w	#$80,d2
	add.w	(fodropy).w,d2
	move.w	d2,(a6)
	move.w	(a2),d2
	btst	#3,2(a3)	;x flip
	beq.w	.160AE
	move.b	7(a2),d2
	andi.w	#$C,d2
	addq.w	#4,d2
	asl.w	#1,d2
	neg.w	d2
	sub.w	(a2),d2
.160AE
	addi.w	#$80,d2
	add.w	(fodropx).w,d2
	move.w	d2,6(a6)
	move.b	7(a2),2(a6)
	move.b	d6,3(a6)
	move.w	6(a2),d2
	andi.w	#$F800,d2
	or.w	4(a2),d2
	move.w	2(a3),d1
	andi.w	#$F800,d1
	eor.w	d1,d2
	add.w	(word_FFB01C).w,d2	;93 faceoffvrcset
	move.w	d2,4(a6)
	addq.w	#1,d6
	addq.w	#8,a6
	addq.w	#8,a2
	dbf	d5,.16084
	addq.w	#4,a3
.160EE
	dbf	d0,.1605E
	rts
showzam	;zamboni. a5 = dma list, a6 = sprite table, d6 = link counter. Draws frame 1, frame 2-4 picked by x, then frame 5 (home score not ahead) or a .ftab frame. Called from setvideo
	move.w	(zamx).w,d0
	bmi.w	rtss2	;no zamboni
	movea.l	#ZamFrameList,a0	;93 ZamSprites
	lsr.w	#2,d0
	move.w	#$12A,d1	;y (92 128+200)
	moveq	#1,d2
	move.w	(ExtraChars).w,d3
	bsr.w	SetSframe
	move.w	d0,d2
	lsr.w	#1,d2
	ext.l	d2
	divu.w	#3,d2
	swap	d2
	addq.w	#2,d2	;frame 2 + (x/2 mod 3)
	bsr.w	SetSframe
	moveq	#5,d2
	move.w	(HmGoals).w,d4	;home score
	cmp.w	(AwGoals).w,d4
	bls.w	SetSframe	;home not ahead: frame 5
	move.w	d0,d2
	subi.w	#$DA,d2
	bpl.w	.1613E
	clr.w	d2
.1613E
	lsr.w	#2,d2
	add.w	d2,d2
	cmp.w	#$1A,d2
	blt.w	.16150
	move.l	#$18,d2
.16150
	movea.l	#.ftab,a1
	move.w	0(a1,d2.w),d2
	bra.w	SetSframe
.ftab	dc.w	5,6,7,8,7,8,7,8,7,8,7,6,5	;IDA: unk_1615E (93 .ftab). Frame by (x-$DA)/4
SetSframe	;draw one sprite frame. a0 = framelist, d0/d1 = x/y cords, d2 = frame to setup (from 0), d3 = start char in vram, a6 = sprite table,
	;d6 = link counter. Called from showzam and from code outside this segment
	cmp.w	#$40,d6	;MaxSprites
	bge.w	rtss2
	movem.l	d0-d5/a0,-(sp)
	adda.l	4(a0),a0
	add.w	d2,d2
	move.w	2(a0,d2.w),d4
	sub.w	0(a0,d2.w),d4
	lsr.w	#3,d4
	subq.w	#1,d4	;number of sprites in frame
	adda.w	0(a0,d2.w),a0
.1619A
	move.w	2(a0),(a6)
	add.w	d1,(a6)+
	move.b	7(a0),(a6)+
	move.b	d6,(a6)+
	move.w	6(a0),d2
	andi.w	#$F800,d2
	add.w	4(a0),d2
	add.w	d3,d2
	move.w	d2,(a6)+
	move.w	(a0),(a6)
	add.w	d0,(a6)+
	addq.w	#1,d6
	cmp.w	#$40,d6	;MaxSprites
	beq.w	.161CA
	addq.w	#8,a0
	dbf	d4,.1619A
.161CA
	movem.l	(sp)+,d0-d5/a0
	rts
showcrowd	;draw crowd sprites: up to 3 frames per PBnum nibble, then the two crowdframe frames. a5 = dma list, a6 = sprite table, d6 = link
	;counter. 94: no crowd in a reverse angle replay. Called from setvideo
	btst	#4,(word_FFC2F4).w	;check if reverse angle replay
	bne.w	.162FC	;branch if so
	movea.l	#CrowdFrameList,a1	;93 CrowdSprites
	adda.l	4(a1),a1
	move.w	(Hpos).w,d4
	move.w	(Vpos).w,d5
	btst	#7,(sflags).w
	beq.w	.161FE
	moveq	#-$40,d4	;(IDA #$FFFFFFC0)
	move.l	#$100,d5
.161FE
	clr.w	d0
	move.b	(PBnum).w,d2
	moveq	#$1A,d3	;frames 26+ (low nibble)
	bsr.w	.pb
	move.b	(PBnum).w,d2
	lsr.w	#4,d2
	moveq	#$1D,d3	;frames 29+ (high nibble)
	bsr.w	.pb
	move.b	(crowdframe).w,d0
	bsr.w	.sc
	move.b	(crowdframe+1).w,d0
	bra.w	.sc
.pb	;IDA: sub_16226 (93 .pb, IDA showcrowd_pb). d2 = count, d3 = first frame
	andi.w	#$F,d2
	cmp.w	#3,d2
	bls.w	.16234
	moveq	#3,d2	;max 3
.16234
	bra.w	.16240
.16238
	move.w	d3,d0
	add.w	d2,d0
	bsr.w	.sc
.16240
	dbf	d2,.16238
	rts
.sc	;IDA: sub_16246 (93 .sc, IDA showcrowd_sc). d0 = frame, 0 = none
	ext.w	d0
	beq.w	rtss2
	btst	#7,(sflags).w
	beq.w	.1625A
	addi.w	#$1F,d0	;horizontal frames are 31 later
.1625A
	cmp.w	#$40,d6	;MaxSprites
	bge.w	rtss2
	movem.l	d0-d5,-(sp)
	add.w	d0,d0
	movea.l	a1,a0
	move.w	2(a0,d0.w),d1
	sub.w	0(a0,d0.w),d1
	lsr.w	#3,d1
	subq.w	#1,d1
	move.w	d1,-(sp)	;number of sprites in frame
	adda.w	0(a0,d0.w),a0
	move.w	d4,d0
	addi.w	#$C0,d0
	move.w	d0,d1
	subi.w	#$90,d0
	addi.w	#$80,d1
	move.w	#$170,d2
	sub.w	d5,d2
	move.w	d2,d3
	subi.w	#$80,d2
	addi.w	#$70,d3
	move.w	(sp)+,d4
.1629E
	cmp.w	2(a0),d2
	bgt.w	.162F2
	cmp.w	2(a0),d3
	blt.w	.162F2
	cmp.w	(a0),d0
	bgt.w	.162F2
	cmp.w	(a0),d1
	blt.w	.162F2
	move.w	2(a0),d5
	addi.w	#$70,d5
	sub.w	d2,d5
	move.w	d5,(a6)+
	move.b	7(a0),(a6)+
	move.b	d6,(a6)+
	move.w	6(a0),d5
	andi.w	#$F800,d5
	add.w	4(a0),d5
	add.w	(word_FFB01A).w,d5	;crowd start char
	move.w	d5,(a6)+
	move.w	(a0),d5
	addi.w	#$70,d5
	sub.w	d0,d5
	move.w	d5,(a6)+
	addq.w	#1,d6
	cmp.w	#$40,d6
	beq.w	.162F8
.162F2
	addq.w	#8,a0
	dbf	d4,.1629E
.162F8
	movem.l	(sp)+,d0-d5
.162FC	;IDA: locret_162FC
	rts
