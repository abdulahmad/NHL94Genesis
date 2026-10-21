;	The Manual Goalie menu item, followed by the arena and faceoff animations.

ManualGoalieMenu					;"x Manual Goalie" menu item (menu lists; PrintMenuItem prints Manual /
									;Auto Goalie from the same words): with OptNOP set, toggle the goalie mode
									;of the pause pad (goaliemode2 for pad 2, sflags bit 1, else goaliemode1;
									;both when the pads are on one team). In a penalty shot or shootout
									;(gmode2 bit 0, BA_PS_flags bit 2) the pad then takes player 0 / 6 or 5 /
									;$B by its mode, when BA_Sktr_SCnum is on its side (setc1player /
									;setc2player)
	movem.l	d0-d7/a0-a6,-(sp)
	tst.w	(OptNOP).w				;goalie option set?
	beq.w	.chkso					;no goalie option: switch only
	move.w	(cont1team).w,d0		;pad 1's team
	cmp.w	(cont2team).w,d0		;same team?
	bne.w	.0						;pads on different teams
	eori.w	#1,(goaliemode2).w		;toggle pad 2's goalie mode
	bra.w	.g1						;same team: pad 1 too
.0									;d0 <> cont2team
	btst	#sfpj,(sflags).w		;which pad paused?
	beq.w	.g1						;pad 1 paused
	eori.w	#1,(goaliemode2).w		;toggle pad 2's goalie mode
	bra.w	.chkso
.g1									;pad 1's goalie mode
	eori.w	#1,(goaliemode1).w		;toggle pad 1's goalie mode
.chkso								;shootout or penalty shot?
	btst	#0,(gmode2).w			;shootout?
	bne.w	.so
	btst	#2,(BA_PS_flags).w		;penalty shot?
	beq.w	.x						;neither: done
.so									;shootout or penalty shot: switch the pad's player
	btst	#sfpj,(sflags).w		;which pad paused?
	bne.w	.p2						;pad 2 paused
	cmpi.w	#2,(OptNOP).w			;two player teams?
	bne.w	.4
	cmpi.w	#5,(BA_Sktr_SCnum).w	;visiting shooter?
	bgt.w	.x						;skater on the other side
	bra.w	.5
.4									;OptNOP <> 2
	cmpi.w	#5,(BA_Sktr_SCnum).w	;home shooter?
	ble.w	.x						;skater on the other side
.5									;pad 1: goalie or skater
	move.w	#0,d0					;goalie slot 0
	cmpi.w	#2,(OptNOP).w
	bne.w	.6						;not two player
	move.w	#6,d0					;two player slot 6
.6									;goalie slot chosen
	tst.w	(goaliemode1).w			;goalie mode of pad 1
	bne.w	.set1					;manual: the goalie
	move.w	#5,d0					;skater slot 5
	cmpi.w	#2,(OptNOP).w
	bne.w	.set1
	move.w	#$B,d0					;two player skater slot
.set1								;set pad 1's player
	jsr	(setc1player).l
	bra.w	.x
.p2									;sfpj set
	cmpi.w	#2,(OptNOP).w			;two player teams?
	bne.w	.9
	cmpi.w	#5,(BA_Sktr_SCnum).w	;home shooter?
	ble.w	.x						;skater on the other side
	bra.w	.10
.9									;OptNOP <> 2
	cmpi.w	#5,(BA_Sktr_SCnum).w	;visiting shooter?
	bgt.w	.x						;skater on the other side
.10									;pad 2: goalie or skater
	move.w	#6,d0					;goalie slot 6
	tst.w	(goaliemode2).w			;goalie mode of pad 2
	bne.w	.set2					;manual: the goalie
	move.w	#$B,d0					;skater slot
.set2								;set pad 2's player
	jsr	(setc2player).l
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a6
	rts
RunArenaAnim						;Run the arena animation arenaanim (negative: none): the first time, its
									;frame list and graphics from ArenaAnims
									;(arenaframelist / arenaspritelist, tiles to VRAM d4 = arenaanimchars:
									;DecompressGraphicsPlain); then count down the frame time arenaframetime
									;by d7 and step (NextArenaFrame). Called from periodicevents and waitxsr
	tst.w	(arenaanim).w			;any arena animation?
	bmi.w	.x2						;none running
	movem.l	d0-d7/a0-a6,-(sp)
	tst.l	(arenaspritelist).w		;first time?
	bne.w	.run					;already loaded: run it
	move.w	(arenaanim).w,d0
	asl.w	#3,d0					;8 bytes per animation
	movea.l	#ArenaAnims,a0			;ArenaAnims table
	move.l	0(a0,d0.w),(arenaframelist).w	;frame list
	move.l	4(a0,d0.w),(arenaspritelist).w	;sprite list
	movea.l	4(a0,d0.w),a2
	addq.w	#8,a2					;tiles at 8(x)
	move.w	(arenaanimchars).w,d4	;vram tile base
	jsr	(DecompressGraphicsPlain).l	;unpack the tiles
	clr.w	(arenaframeidx).w		;start of the list
	bsr.w	NextArenaFrame			;first frame
	bra.w	.x
.run								;arenaspritelist <> 0
	sub.w	d7,(arenaframetime).w	;count down the frame time
	bpl.w	.x						;frame time not out yet
	addq.w	#1,(arenaframeidx).w	;next entry
	bsr.w	NextArenaFrame			;read the next frame
.x									;pop the d0-d7/a0-a6 saved above
	movem.l	(sp)+,d0-d7/a0-a6
.x2									;exit (also the end of the code above)
	rts
NextArenaFrame						;Read frame arenaframeidx of the list: arenaframe = frame, arenaframetime
									;= time; frame $FF loops to the start, $FE ends the animation
									;(EndArenaAnim)
	movea.l	(arenaframelist).w,a0	;frame list
	move.w	(arenaframeidx).w,d0	;entry index
	add.w	d0,d0					;2 bytes per entry
	move.b	0(a0,d0.w),d1			;frame byte
	ext.w	d1
	move.w	d1,(arenaframe).w		;frame number
	move.b	1(a0,d0.w),d1
	ext.w	d1
	move.w	d1,(arenaframetime).w	;frame time
	cmpi.w	#$FFFF,(arenaframe).w	;$FF = loop
	bne.w	.0
	clr.w	(arenaframeidx).w		;restart the list
	bra.s	NextArenaFrame			;$FF: back to the first frame
.0									;end of the frame list?
	cmpi.w	#$FFFE,(arenaframe).w
	bne.w	.x
	bsr.w	EndArenaAnim			;$FE: end the animation
.x									;exit (also the end of the code above)
	rts
ArenaAnims							;The 8 arena animations (StartArenaAnim d0): frame list, then the graphics
									;in ArenaGfxBank (sprite list at 4(x), tiles at 8(x))
	dc.l	ArenaFrames8,ArenaGfxBank+$416
	dc.l	ArenaFrames6,ArenaGfxBank+$C3A
	dc.l	ArenaFrames7,ArenaGfxBank+$C3A
	dc.l	ArenaFrames5,ArenaGfxBank+$1940
	dc.l	ArenaFrames4,ArenaGfxBank+$23AE
	dc.l	ArenaFrames3,ArenaGfxBank+$23AE
	dc.l	ArenaFrames2,ArenaGfxBank+$32DA
	dc.l	ArenaFrames1,ArenaGfxBank+$32DA
ArenaFrames1						;ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,$A,2,$A,3,$A,4,$A,5,$A,6,$A,7,$A,8,$A
	dc.b	9,$A,$A,$A,1,$A,2,$A,3,$A,4,$A,5,$A,6,$A
	dc.b	7,$A,8,$A,9,$A,$A,$A,1,$A,2,$A,3,$A,4,$A
	dc.b	5,$A,6,$A,7,$A,8,$A,9,$A,$A,$A,$FE,0
ArenaFrames2						;ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,$A,2,$A,3,$A,4,$A,5,$A,6,$A,7,$A,8,$A
	dc.b	9,$A,$A,$A,$FF,0
ArenaFrames3						;ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,$A,2,$A,3,$A,4,$A,5,$A,6,$A,7,$A,8,$A
	dc.b	9,$A,$A,$A,$B,$A,$C,$A,$D,$A,$E,$A,$F,$A,$10,$A
	dc.b	$11,$A,$12,$A,$13,$A,$14,$A,$15,$A,$16,$A,$17,$A,$FE,0
ArenaFrames4						;ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,8,2,8,3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C
	dc.b	3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C
	dc.b	3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C
	dc.b	3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C
	dc.b	3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C,3,$3C,4,$3C
	dc.b	2,8,1,8,$FF,0
ArenaFrames5						;ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,8,2,8,3,8,4,8,5,8,6,8,7,8,8,8
	dc.b	$FF,0
ArenaFrames6						;ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,8,2,8,3,8,4,$1E,5,8,6,8,7,8,8,$1E
	dc.b	5,8,6,8,7,8,8,$1E,9,8,$A,8,$B,8,$C,8
	dc.b	$D,8,$E,8,$FE,0
ArenaFrames7						;ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	$F,8,$10,8,$11,8,$12,$1E,$13,8,$14,8,$15,8,$16,$1E
	dc.b	$13,8,$14,8,$15,8,$16,$1E,$17,8,$18,8,$19,8,$1A,8
	dc.b	$1B,8,$1C,8,$FE,0
ArenaFrames8						;ArenaAnims frame list: (frame, time) byte pairs, $FF loops, $FE ends
	dc.b	1,$A,2,$A,3,$A,4,$A,5,$A,6,$A,7,$A,8,$A
	dc.b	9,$A,$A,$A,$B,$A,$C,$A,$D,$A,$E,$A,$F,$7F,$FE,0
SetCameraTop						;Unreferenced. Sflags bit 6, xc1 = 0, yc1 = $160
	bset	#sfslock,(sflags).w
	move.w	#0,(xc1).w
	move.w	#$160,(yc1).w
	rts
StartArenaAnim						;Start arena animation d0 (ArenaAnims): arenaanim = d0, RunArenaAnim loads
									;it. Called from FallDown (7)
									;ShowGoalBox (0 on a home hat trick) and puckfaceoff2 (the one
									;SetFaceoffAnim set)
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	d0,(arenaanim).w		;animation number
	move.l	#0,(arenaframelist).w	;RunArenaAnim loads the lists
	move.l	#0,(arenaspritelist).w
	move.w	#1,(arenaframe).w		;first frame
	clr.w	(arenaframeidx).w
	st	(faceoffanim).w				;no faceoff animation queued
	movem.l	(sp)+,d0-d7/a0-a6
	rts
SetFaceoffAnim						;Set the faceoff animation: sflags7 bit 0, faceoffanim = d0. Called from
									;puckfaceoff
	bset	#0,(sflags7).w			;faceoff animation pending
	move.w	d0,(faceoffanim).w		;which animation
	rts
EndArenaAnim						;End the arena animation: arenaanim = -1, sflags7 bit 0 cleared. Called
									;from NextArenaFrame and puckfaceoff2
	move.w	#$FFFF,(arenaanim).w	;no animation
	bclr	#0,(sflags7).w			;no faceoff animation
	rts
