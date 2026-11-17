Sub_338E8
	bsr.w	Sub_338B6
	bne.w	Sub_33986
	tst.w	$17E34.l
	beq.w	Sub_33986
.l188FA	btst	#$7,$FF800E.l
	bne.b	.l188FA
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.l18914	btst	#$6,$FF800E.l
	beq.b	.l18914
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l18934	btst	#$6,$FF800E.l
	bne.b	.l18934
	bclr	#$7,$FF800F.l
	andi.w	#$3,d0
	bne.w	Sub_33986
	move.w	#$58,d0
	btst	#$7,$62(a3)
	beq.w	.l1896C
	move.w	#$FFA8,d0
	cmp.w	$14(a3),d0
	blt.w	CompShoot
	bra.w	.l18974
.l1896C	cmp.w	$14(a3),d0
	bgt.w	CompShoot
.l18974	bset	#$3,$17F74.l
	jmp	(dopass).l
	dc.w	$6000,$0144
Sub_33986
	btst	#$1,$64(a3)
	beq.w	.l189D2
	move.w	#$1E,d0
	dc.w	$4EB9,$0003,$7050
	addi.w	#$82,d0
	dc.w	$B079,$0001,$7B94
	blt.w	.l189B8
	neg.w	d0
	dc.w	$B079,$0001,$7B94
	bgt.w	.l189B8
	bra.w	.l189D2
.l189B8	move.w	#$2,d0
	dc.w	$4EB9,$0003,$7044
	add.w	$54(a3),d0
	andi.w	#$7,d0
	move.w	d0,$54(a3)
	bra.w	CompShoot
.l189D2	moveq	#$20,d4
	clr.w	d1
	move.b	$70(a3),d1
	lsr.w	#$1,d1
	sub.b	d1,d4
	asl.w	#$4,d4
	move.w	#$108,d1
	btst	#$7,$62(a3)
	bne.w	.l189F0
	neg.w	d1
.l189F0	dc.w	$9279,$0001,$7B94
	dc.w	$3039,$0001,$7B80
	neg.w	d0
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d0,d1
	cmpi.l	#$2710,d1
	movem.w	(sp)+,d0-d1
	bhi.w	.l18A76
	lsr.w	#$4,d4
	bsr.w	vtoa
	move.w	d0,d5
	moveq	#$5,d3
	dc.w	$227C,$0001,$7480
	cmpi.w	#$6,$52(a3)
	bge.w	.l18A34
	adda.w	#$300,a1
.l18A34	tst.w	$34(a1)
	beq.w	.l18A60
	move.w	$0(a1),d0
	dc.w	$9079,$0001,$7B80
	move.w	$14(a1),d1
	dc.w	$9279,$0001,$7B94
	bsr.w	vtoa
	cmp.w	d5,d0
	bne.w	.l18A6E
	asl.w	#$1,d4
	bra.w	.l18A6E
.l18A60	btst	#$1,$63(a1)
	beq.w	.l18A6E
	clr.w	d3
	moveq	#$1,d4
.l18A6E	adda.w	#$80,a1
	dbra	d3,.l18A34
.l18A76	move.w	d4,d0
	bsr.w	randomd0
	btst	#$0,$70(a3)
	beq.w	.l18A92
	cmpi.w	#$7,d0
	bgt.w	Sub_31AB6
	bra.w	.l18A9A
.l18A92	cmpi.w	#$8,d0
	bgt.w	Sub_31AB6
.l18A9A	dc.w	$3039,$0001,$7B94
	btst	#$7,$62(a3)
	bne.w	.l18AAC
	neg.w	d0
.l18AAC	tst.w	d0
	bmi.w	Sub_31AB6
	move.w	#$108,d1
	sub.w	d0,d1
	bmi.w	Sub_31AB6
	btst	#$7,$17F6C.l
	bne.w	Sub_31AB6
CompShoot						;computer shot: drop the return address and aim from the puck's distance
									;to the goal line
	adda.w	#$4,sp
	dc.w	$3039,$0001,$7B94
	btst	#$7,$62(a3)
	bne.w	.ds0
	neg.w	d0
.ds0	move.w	#$108,d1		;d0 is now puck y toward the goal I shoot at
	sub.w	d0,d1		;d1 = distance to $108 along the shooting direction
	lsr.w	#$3,d1
	cmpi.w	#$14,d1
	blt.w	.0
	moveq	#$14,d1
.0	move.w	d1,$42(a3)
	moveq	#$12,d0
	bra.w	Sub_362E4
chk4pass						;player a3 looks for good pass (computer controlled)
	tst.w	$17E34.l
	bne.w	.dp0		;an opponent is close: always consider a pass
	moveq	#$10,d0
	add.b	$70(a3),d0
	bsr.w	randomd0		;0 <= d0 < $10 + odds
	cmpi.w	#$C,d0
	bgt.w	Sub_31AB6
.dp0	moveq	#$6,d0		;Set up pass assignment
	bsr.w	randomd0		;d0 = random teammate index 0-5
	cmpi.w	#$6,$52(a3)
	blt.w	.0
	addi.w	#$6,d0
.0	tst.w	$34(a3)
	beq.w	.1
	dc.w	$0C79,$0028,$0001,$7B80
	bgt.w	.1
	dc.w	$0C79,$FFD8,$0001,$7B80
	blt.w	.1
	dc.w	$0C79,$00CC,$0001,$7B94
	bgt.w	Sub_31AB6
	dc.w	$0C79,$FF34,$0001,$7B94
	blt.w	Sub_31AB6
.1	cmp.w	$52(a3),d0
	beq.w	Sub_31AB6
	asl.w	#$7,d0		;d0 * SCstruct ($80)
	dc.w	$207C,$0001,$7480
	adda.w	d0,a0		;a0 = receiver sort object
	tst.w	$34(a0)
	ble.w	Sub_31AB6
	btst	#$2,$63(a0)
	bne.w	Sub_31AB6
	btst	#$5,$62(a0)
	bne.w	Sub_31AB6
	move.w	$14(a0),d0		;check for pass across blue line
	move.w	$14(a3),d1		;d0 = receiver y, d1 = my y (toward the goal I shoot at)
	btst	#$7,$62(a3)
	bne.w	.f0
	neg.w	d0
	neg.w	d1
.f0	btst	#$5,$17F68.l		;offsides on?
	beq.w	.oko
	movem.w	d0-d1,-(sp)
	subi.w	#$58,d0		;y relative to the blue line
	subi.w	#$58,d1
	eor.w	d0,d1		;sign differs if the pass crosses the blue line
	movem.w	(sp)+,d0-d1
	bmi.w	Sub_31AB6
.oko	cmpi.w	#$58,d0
	bgt.w	.ok
	sub.w	d1,d0
	cmpi.w	#$FFF1,d0
	blt.w	Sub_31AB6
.ok	move.w	$0(a0),d0		;receiver accepted: get the pass direction
	dc.w	$9079,$0001,$7B80
	move.w	$14(a0),d1
	dc.w	$9279,$0001,$7B94
	movem.w	d0-d1,-(sp)
	bsr.w	vtoa
	dc.w	$33C0,$0001,$7E2C
	movem.w	(sp)+,d1-d2
	muls.w	d1,d1
	muls.w	d2,d2
	add.l	d1,d2		;d2 = squared distance to the receiver
	moveq	#$5,d3
	dc.w	$227C,$0001,$7480
	cmpi.w	#$6,$52(a3)
	bge.w	.co0
	adda.w	#$300,a1		;loop over the 6 opponents
.co0	move.w	$0(a1),d0		;next opponent: is he in the pass lane?
	dc.w	$9079,$0001,$7B80
	move.w	$14(a1),d1
	dc.w	$9279,$0001,$7B94
	movem.w	d0-d1,-(sp)
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d0,d1		;d1 = squared distance to this opponent
	cmp.l	d2,d1
	movem.w	(sp)+,d0-d1
	bhi.w	.l18C52		;farther than the receiver: ignore
	bsr.w	vtoa
	dc.w	$B079,$0001,$7E2C
	beq.w	Sub_31AB6
.l18C52	adda.w	#$80,a1
	dbra	d3,.co0
	bsr.w	dopass		;lane is clear: pass in passdir
	tst.w	$34(a3)
	beq.w	Sub_31AB6
	adda.w	#$4,sp
	bra.w	Sub_362C4
	dc.w	$4A79,$0001,$7BE0,$6B00,$DE40,$142B,$0028,$9439
	dc.w	$0001,$7BA8,$4882,$D46B,$0000,$9479,$0001,$7B80
	dc.w	$0C42,$0028,$6E00,$DE22,$0C42,$FFD8,$6D00,$DE1A
	dc.w	$122B,$002A,$9239,$0001,$7BAA,$4881,$D26B,$0014
	dc.w	$9279,$0001,$7B94,$0C41,$0028,$6E00,$DDFC,$0C41
	dc.w	$FFD8,$6D00,$DDF4,$302B,$0000,$9079,$0001,$7B80
	dc.w	$322B,$0014,$9279,$0001,$7B94,$6100,$261E,$0839
	dc.w	$0005,$0001,$7F68,$6700,$0038,$322B,$0014,$082B
	dc.w	$0007,$0062,$6600,$0004,$4441,$0441,$0058,$0C41
	dc.w	$000A,$6E00,$001C,$0C41,$FFCE,$6D00,$0014,$7002
	dc.w	$322B,$0000,$B279,$0001,$7B80,$6E00,$0004,$7006
	dc.w	$4E75
checkob						;bring up little warning ref if a player on your team is over blue line
	btst	#$5,$17F68.l
	beq.w	Sub_31AB6
	btst	#$2,$17F70.l
	bne.w	.l18D94
	movem.l	d0-d1/a0,-(sp)
	moveq	#$5,d0		;6 players of a3's team
	dc.w	$207C,$0001,$7480
	cmpi.w	#$6,$52(a3)
	blt.w	.0
	adda.w	#$300,a0		;a0 = first sort object of a3's team
.0	moveq	#$5C,d1
	btst	#$7,$62(a3)
	bne.w	.l18DB6		;shooting at the top goal: mirrored tests below
	neg.w	d1		;d1 = -$5C
	dc.w	$B279,$0001,$7B94
	bgt.w	.nob		;puck already across the line: nobody can be offside
.bottom	tst.w	$34(a0)		;loop over the team, skipping negative positions
	bmi.w	.bn
	cmp.w	$14(a0),d1
	bgt.w	.ob		;this player is over the line
.bn	adda.w	#$80,a0
	dbra	d0,.bottom
.nob	moveq	#$40,d0		;no one offside: d0 = $40 = clear the ref window (PushRef)
	bclr	#$7,$17F6C.l		;clear the offsides ref flag
	bne.w	.l18DA4		;it was on: update the ref
.ex	movem.l	(sp)+,d0-d1/a0
.l18D94	rts
.ob	moveq	#$6,d0
	bset	#$7,$17F6C.l		;someone is offsides: show the little ref
	bne.w	.ex		;already shown
.l18DA4	dc.w	$4A79,$0001,$806E
	bpl.w	.ex
	bsr.w	PushRef
	bra.w	.ex
.l18DB6	dc.w	$B279,$0001,$7B94
	blt.w	.nob
.top1	tst.w	$34(a0)		;loop over the team's players (top goal)
	bmi.w	.tn
	cmp.w	$14(a0),d1
	blt.w	.ob
.tn	adda.w	#$80,a0		;next player
	dbra	d0,.top1
	bra.w	.nob
assbreakaway						;assignment for a breakaway: the puck carrier skates in, anyone else goes
									;back to assnearest
	move.w	$52(a3),d0		;Move SCnum into d0
	cmp.w	$17BE0.l,d0		;compare puck carrier SCnum with d0
	beq.w	assnearest		;branch if puck carrier
L18DEA	bclr	#$1,$64(a3)		;clear breakaway bit
	move.w	#$11,d0		;11 - assnearest
	bsr.w	Sub_362E4
	bra.w	L18E06
assnearest						;this is a special assignment used for the player who is nearest the puck
									;but doesn't have it. Assignment anearest ($11)
									;a2 = a3's team struct, d7 = elapsed frames. temp1 = re-evaluation timer,
									;temp3 = hold timer
	jsr	(breakaway).l
	bmi.w	L18DEA
L18E06	bclr	#$2,$17F74.l
	bne.w	.chkpuck
	bclr	#$1,$64(a3)		;clear breakaway bit
.chkpuck	move.w	$52(a3),d0		;move SCnum into d0
	cmp.w	$17BE0.l,d0		;compare with puck carrier SCnum
	bne.w	.chkbreak		;jump if not puck carrier
	btst	#$1,$64(a3)		;check breakaway bit
	bne.w	.chkbreak		;jump if set
	btst	#$2,$17F70.l		;check if bit 2 set (cleared on Faceoffs)
	bne.w	.chkbreak		;jump if set
	jsr	(BreakawayOffsidesFlagSet).l
	beq.w	.chkbreak
	move.w	#$22,d0		;22 - assbreakaway if flag set
	bsr.w	Sub_362E4		;assreplace with assbreakaway
	bra.w	.chkbreak
.chkbreak	bclr	#$1,$62(a3)		;pfna - clear new assignment
	beq.w	.nna
	btst	#$1,$64(a3)		;check if breakaway
	beq.w	.chkbreak2		;jump if not
	move.w	#$2,-(sp)		;ding SFX
	dc.w	$4EB9,$0003,$710C
.chkbreak2	btst	#$1,$64(a3)		;check if breakaway
	beq.w	.nobreak		;jump if not
	movem.l	a2,-(sp)		;push a2 to stack
	movea.l	#tmstruct,a2		;put Home Team Struct into a2
	btst	#$6,$62(a3)		;pfteam - check home or away
	beq.w	.addcrowd		;jump if home
	movea.l	#awtmstruct,a2		;put Away Team Struct into a2
.addcrowd	addi.w	#$1,$35A(a2)		;add to breakaway attempt
	dc.w	$0679,$0014,$0001,$7CD8
	addi.w	#$C8,(Crowdlevel).l		;add to crowd level
	movem.l	(sp)+,a2		;pop off stack into a2
.nobreak	clr.w	$44(a3)		;clear temp3
	move.w	#$8,$42(a3)		;move 8 into temp2
	clr.w	$40(a3)		;clear temp1
.nna	move.w	$52(a3),d1		;checks if puck carrier
	cmp.w	$17BE0.l,d1
	bne.w	.nopc		;jumps if not
	tst.w	$34(a3)		;check if goalie
	beq.w	Sub_32926		;branch if goalie
	moveq	#$10,d0
	btst	#$3,$62(a3)		;pfjoycon - check if controlled
	beq.w	Sub_362D8		;jump if not
	rts		;human controlled: leave as is
.nopc	sub.b	d7,$40(a3)		;subtract d7 (elapsed frames) from temp1
	bpl.w	.nodec		;jump if positive
	move.b	$6A(a3),$40(a3)		;move aioff into temp1
	jsr	(ReadGoaliePulled).l		;check if goalie is pulled
	bmi.w	.bonus
	btst	#$6,$17F7A.l		;check if crowd meter currently broken
	beq.w	.nopc2		;jump if not broken
	tst.b	$40(a3)		;check if temp1 is 0
	beq.w	.nopc2		;jump if so
.bonus	subi.b	#$1,$40(a3)		;subtract 1 from temp1
.nopc2	btst	#$5,(sflags6).l		;check if slot bit is set (puckc in slot)
	beq.w	.nopc3		;branch if not set
	move.w	$17BE0.l,d1		;move puck carrier SCnum
	cmpi.w	#$5,d1		;check if its home (5 or less) or away (6-11)
	bgt.w	.pcaway		;jump if away
	btst	#$6,$62(a3)		;pfteam
	beq.w	.nopc3		;jump if home
.tmnopc	move.b	$40(a3),d1		;temp1 into d1
	ext.w	d1		;extend d1
	asr.w	#$1,d1		;divide by 2
	move.b	d1,$40(a3)		;move d1 into temp1 - cutting the timer in half
	bne.w	.nopc3		;jump if not zero
	move.b	#$1,$40(a3)		;move 1 into temp1
	bra.w	.nopc3
.pcaway	btst	#$6,$62(a3)		;pfteam - 0 home, 1 away
	beq.w	.tmnopc		;jump if home
.nopc3	clr.l	$2C(a2)		;no nearest skater yet
	move.w	$17BE0.l,d1		;move puck carrier SCnum into d1
	bmi.w	.np		;branch if no puck carrier
	asl.w	#$7,d1		;scsize
	dc.w	$227C,$0001,$7480
	adda.w	d1,a1		;use d1 as offset
	move.b	$62(a1),d0		;pflags of puck carrier
	move.b	$62(a3),d1		;pflags of current player
	eor.b	d0,d1		;XOR pflags
	btst	#$6,d1		;check pfteam
	beq.w	.switch		;branch if on same team
.np	moveq	#-1,d2		;-1
	moveq	#$5,d4		;5 = # of players on team
	movea.l	$22(a2),a0		;SortCord start value for team
.de0	tst.w	$34(a0)		;check if goalie
	ble.w	.next		;branch if goalie
	tst.b	$5E(a0)		;check if nopuck (cant touch puck)
	bne.w	.next		;branch if nopuck timer not 0
	btst	#$2,$63(a0)		;pf2unav - unavailable
	bne.w	.next		;branch if unavailable
	move.w	$36(a0),d0		;assnum - current assignment
	cmpi.b	#$13,$38(a0,d0.w)		;check if current assignment is asspassrec
	beq.w	.next		;branch if a0 is going to receive puck
	move.l	a0,-(sp)		;push onto stack
	bsr.w	Sub_36362		;get hot spot
	add.w	$0(a0),d0		;Xpos to d0
	dc.w	$9079,$0001,$7B80
	add.w	$14(a0),d1
	dc.w	$9279,$0001,$7B94
	dc.w	$3639,$0001,$7BA8
	asr.w	#$6,d3
	sub.w	d3,d0
	dc.w	$3639,$0001,$7BAA
	asr.w	#$6,d3		;divide by 64
	sub.w	d3,d1		;sub d3 from d1 (Y distance between player and puck)
	muls.w	d0,d0		;square d0
	muls.w	d1,d1		;square d1
	add.l	d1,d0		;add d1 to d0
	cmp.l	d2,d0		;compare d2 to d0
	bhi.w	.next		;branch if d0 higher than d2 (0 or a positive # first run)
	move.l	d0,d2		;move d0 into d2
	movea.l	a0,a1		;move a0 address into a1
.next	adda.w	#$80,a0		;SCstruct size
	dbra	d4,.de0
	tst.l	d2		;check if 0
	bmi.w	.de1		;branch if less (no one near puck)
	move.l	d2,$2C(a2)		;nearest skater's distance^2 to the puck
.switch	cmpa.l	a1,a3		;a1 = closest to the puck, or puckc (if on same team)
	beq.w	.de1		;branch if same
	btst	#$0,$17F68.l		;gmclock - 1 if stopped
	bne.w	.de1		;jump if stopped
	btst	#$2,$63(a1)		;pf2unav
	bne.w	.de1		;jump if unavailable
	btst	#$3,$64(a1)		;shooting one timer
	bne.w	.de1		;jump if shooting
	exg.l	a1,a3		;swap addresses
	bclr	#$0,$62(a3)		;clear pfdoff
	moveq	#$11,d0
	bsr.w	Sub_362D8		;... and give him the assnearest assignment
	exg.l	a1,a3
	bra.w	Sub_362C4		;I (old a3) drop this assignment
.de1	btst	#$5,$62(a3)		;pfalock - check if locked in animation
	bne.w	Sub_31AB6		;exit if locked
	moveq	#$2,d1		;move 2 into d1
	cmpi.w	#$190,d2		;compare $190 (20^2) to d2. d2 = distance to puck^2
	bhi.w	.nfar		;branch if d2 higher
	subi.w	#$2,d1		;close: d1 = 0
	cmpi.w	#$2,$34(a3)		;compare if position is F or D (1 and 2 are D)
	bls.w	.nodec		;jump if D
.nfar	btst	#$5,$17F6C.l		;sf2pwrplay - check if PP
	beq.w	.l1907C		;branch if no PP
	subi.w	#$2,d1		;sub 2 from d1
	bsr.w	chkpk2
	bne.w	.l1907C		;branch if on PK
	addi.w	#$4,d1		;add 4 to d1
.l1907C	moveq	#$28,d0
	sub.b	$75(a3),d0		;sub checking from d0
	asl.w	d1,d0		;shift d0 by value of d1
	bsr.w	randomd0		;RNG
	cmpi.w	#$2,d0		;compare 2 to d0
	bhi.w	.nodec		;branch if d0 more than 2
	move.w	#$F0,$44(a3)		;move 240 dec into temp3
.nodec	btst	#$5,$62(a3)		;pfalock - check if anim lock
	bne.w	Sub_31AB6		;exit if locked
	btst	#$2,$17F70.l		;check bit 2
	beq.w	.gmclock		;jump if not set
	btst	#$5,$17F70.l		;check bit 5
	beq.w	.nodec2		;jump if not set
.gmclock	btst	#$0,$17F68.l		;check if clock running
	bne.w	Sub_31EB2		;branch if not
.nodec2	btst	#$3,$62(a3)		;pfjoycon - check if controlled
	bne.w	Sub_31AB6		;jump if controlled
	btst	#$2,$32(a2)		;tmfmid of tmflags(a2)
	bne.w	.nodec22
	tst.w	$17BE0.l		;check if theres a puck carrier
	bmi.w	check4check		;jump if no puck carrier
	sub.w	d7,$44(a3)		;subtract frames from temp3
	bpl.w	check4check		;jump if positive
	clr.w	$44(a3)		;clear temp3
.nodec22	bsr.w	skatetopuckinit		;d0/d1 = halfway between
	movem.w	d0-d1,-(sp)		;d0 = future puckx, d1 = future pucky push on stack
	neg.w	d0		;or (0,-$F4) if pfgoal
	neg.w	d1
	addi.w	#$F4,d1		;add goalline - 20 decimal
	btst	#$7,$62(a3)		;pfgoal - check what net shooting on
	beq.w	.nd0		;branch if bottom
	subi.w	#$1E8,d1		;sub bottom goalline - 20 decimal
.nd0	asr.w	#$1,d0		;divide by 2
	asr.w	#$1,d1		;divide by 2
	add.w	(sp)+,d0		;add original future puckx
	add.w	(sp)+,d1		;add original future pucky
	btst	#$2,$32(a2)		;?? - doesn't seem to be set anywhere
	beq.w	.spdboost
	btst	#$7,$62(a3)		;pfgoal
	beq.w	.botshoot		;branch if bottom
	cmpi.w	#$53,d1		;check if y pos of puck near blue line
	blt.w	.spdboost		;branch if in neutral zone or D zone
	move.w	#$44,d1		;move 44 hex into d1
	bra.w	.spdboost
.botshoot	cmpi.w	#$FFAD,d1		;check if pucky near bottom blue line
	bgt.w	.spdboost		;branch if in neutral zone or D zone
	move.w	#$FFBC,d1		;move FFBC into d1
.spdboost	btst	#$5,(sflags6).l		;check if puckc is in the slot
	beq.w	.noslot		;branch if not
	move.b	$69(a3),$17E6E.l		;legspd into TempLegSpd
	addi.b	#$6,$69(a3)		;add 6 to legspd
	btst	#$1,$17F7C.l		;check if crowd meter broken (always is)
	bne.w	.spdboostex		;jump if set
	btst	#$6,$17F7A.l		;check if crowd meter currently broken
	beq.w	.spdlimit		;jump if not set
.spdboostex	addi.b	#$2,$69(a3)
.spdlimit	cmpi.b	#$1E,$69(a3)		;check speed limit
	ble.w	.cont
	move.b	#$1E,$69(a3)		;limit legspd to $1E (30 decimal)
.cont	lea.l	$341EE.l,a0
	bsr.w	skateto
	move.b	$17E6E.l,$69(a3)		;move original legpsd back into player
	bra.w	.chkslot
.noslot	lea.l	$341EE.l,a0
	bsr.w	skateto
.chkslot	btst	#$5,(sflags6).l
	beq.w	.chkcont
	dc.w	$3039,$0001,$7B94
	move.w	$14(a3),d2		;Ypos into d2
	tst.w	d0		;check if d0 is 0
	bpl.w	.pospuck		;branch if positive
	neg.w	d0		;make d0 negative
	neg.w	d2		;make d2 negative
.pospuck	sub.w	d0,d2		;sub d0 from d2 (equals how far puck is from player Ypos)
	cmpi.w	#$A,d2		;check difference with A (10 decimal)
	blt.w	.exit
	move.w	$0(a3),d0		;Xpos of player (gets here if player is between net and puck carrier)
	dc.w	$9079,$0001,$7B80
	bpl.w	.chkx		;branch if positive difference
	neg.w	d0		;make d0 negative
.chkx	cmpi.w	#$F,d0		;compare F (15 dec) with Xpos difference
	blt.w	.chkcont		;branch if less than (within 15 pix in X direction)
.exit	rts
.chkcont	btst	#$5,(sflags6).l		;check if puckc is in the slot
	beq.w	L1922A		;branch if not in slot
	move.b	$75(a3),d0		;move Chk into d0
	ext.w	d0		;clear top byte of d0
	movem.l	d0/a3,-(sp)		;push to stack
	add.b	d0,d0		;add d0 to itself
	cmpi.b	#$1E,d0		;compare max Chk to d0
	blt.w	.chkcont2		;branch if less
	move.b	#$1E,d0		;move 1E into d0
.chkcont2	move.b	d0,$75(a3)		;move d0 into Chk
	bsr.w	L1922A
	movem.l	(sp)+,d0/a3		;pop off stack
	move.b	d0,$75(a3)		;move original Chk into player
	rts
check4check						;look for good opportunity for checking opponent. Falls in from
									;assnearest; also entered from assfwatch and asswingd roll against
									;the checking rating first, then look for an opponent within 30 units
									;whom a3 is facing
	bsr.w	skatetopuck
L1922A	tst.w	$34(a3)		;check if goalie
	bne.w	.player		;branch if not
	rts
.player	move.w	#$28,d0		;start with 28 hex (40 decimal)
	sub.b	$75(a3),d0		;subtract Chk from d0 (Chk max is 1E or 30 decimal)
	dc.w	$4A79,$0001,$8C08
	beq.w	.nopen		;branch if not on
	asl.w	#$1,d0		;mult by 2
.nopen	bsr.w	randomd0		;RNG d0
	cmpi.w	#$6,d0		;compare 6 to d0
	bhi.w	Sub_31AB6		;exit if d0 higher than 6
	moveq	#$5,d2		;move 5 into d2
	dc.w	$207C,$0001,$7480
	cmpi.w	#$6,$52(a3)		;check if player on home team
	bge.w	.0		;branch if away
	adda.w	#$300,a0		;add if home (checks opposite team in loop)
.0	tst.w	$34(a0)		;check if goalie
	beq.w	.next		;branch if goalie
	btst	#$5,$62(a0)		;check if locked in anim
	bne.w	.next		;branch if locked
	btst	#$0,$63(a0)		;check if fighting
	bne.w	.next		;branch if fighting
	move.w	$0(a0),d0		;move Xpos into d0
	sub.w	$0(a3),d0		;sub a3 from a0
	cmpi.w	#$1E,d0		;compare to 30 decimal
	bgt.w	.next		;branch if more than 30 decimal
	cmpi.w	#$FFE2,d0		;compare to -30 decimal
	blt.w	.next		;branch if less than -30
	move.w	$14(a0),d1		;Ypos
	sub.w	$14(a3),d1		;subtract checker Ypos from d1
	cmpi.w	#$1E,d1		;compare to 30 decimal
	bgt.w	.next		;branch if more
	cmpi.w	#$FFE2,d1		;check with -30 decimal
	blt.w	.next		;branch if less
	bsr.w	vtoa		;determine direction
	cmp.w	$54(a3),d0		;compare facedir with vtoa result
	bne.w	.next		;branch if not facing in that direction
	btst	#$5,(sflags6).l		;check if puckc in slot
	bne.w	Acheck		;branch if in slot
.l192CE	btst	#$7,$FF800E.l
	bne.b	.l192CE
	move.w	#$1B,$FF8020.l
	bset	#$6,$FF800F.l
.l192E8	btst	#$6,$FF800E.l
	beq.b	.l192E8
	move.w	$FF8010.l,d0
	bset	#$7,$FF800F.l
	bclr	#$6,$FF800F.l
.l19308	btst	#$6,$FF800E.l
	bne.b	.l19308
	bclr	#$7,$FF800F.l
	andi.w	#$3,d0		;pass first 2 bits
	bne.w	burst		;throw check
	bra.w	Acheck		;1 in 4: hold or hook on a0
.next	adda.w	#$80,a0		;move to next SCstruct
	dbra	d2,.0
	rts
asspassrec						;assignment for catching a pass (apassrec)
	btst	#$5,$62(a3)		;pfalock - animation lock
	bne.w	Sub_31AB6		;exit if locked
	btst	#$0,$17F68.l		;gmclock - check if clock running
	bne.w	Sub_31EB2		;exit if clock stopped
	btst	#$3,$62(a3)		;pfjoycon - joystick controlled?
	bne.w	Sub_362C4		;exit if controlled
	bclr	#$1,$62(a3)		;#pfna - clear new assignment
	beq.w	.nna
	bset	#$0,$62(a3)		;#pfdoff - set decceleration off
	move.b	#$8,$43(a3)		;move into temp2+1
	clr.b	$42(a3)		;clear temp2 byte
	move.w	#$FFFE,$46(a3)		;move into temp4
.nna	tst.w	$17BE0.l		;check if there is a puck carrier
	bpl.w	.exit		;exit if puck still in possession
	addi.w	#$1,$46(a3)		;add to temp4
	beq.w	.l19388		;branch if temp4 is zero
	bpl.w	.ex2		;branch if temp4 is positive
.l19388	dc.w	$4A79,$0001,$7EBC
	bpl.w	.ex2
	tst.w	$34(a3)		;test if goalie
	beq.w	.ex2		;exit if goalie
	move.w	d0,-(sp)		;push d0 on stack
	clr.w	$46(a3)		;clear temp4
	move.w	#$1,d0
	btst	#$6,$62(a3)		;check if home or away
	beq.w	.l193B2
	move.w	#$2,d0		;away team
.l193B2	dc.w	$B079,$0001,$7FA6
	beq.w	.pop
	dc.w	$B079,$0001,$7FA8
	beq.w	.pop		;branch if so
	jsr	(PuckOnAttackHalf).l
	beq.w	.pop
	move.w	$14(a3),d0		;Ypos
	btst	#$7,$62(a3)		;pfgoal
	bne.w	.chkpos		;branch if shooting at top
	neg.w	d0
.chkpos	cmpi.w	#$58,d0		;blueline
	blt.w	.nozone
	cmpi.w	#$108,d0		;goalline
	bgt.w	.nozone
	bra.w	.atkzone
.nozone	move.w	#$8,d0		;outside of attack zone
	dc.w	$4EB9,$0003,$7050
	tst.w	d0		;check if d0 is zero
	bne.w	.pop
.atkzone	move.w	(sp)+,d0
	dc.w	$33FC,$FFFF,$0001,$AD7A
	move.w	#$23,d0
	dc.w	$4EF9,$0003,$62E4
.pop	move.w	(sp)+,d0
.ex2	sub.b	d7,$40(a3)
	bpl.w	Sub_31AB6
.exit	bclr	#$0,$62(a3)
	bra.w	Sub_362C4
	dc.w	$302B,$0044,$322B,$0046,$41FA,$7BCA,$6000,$1BCE
assshoot						;assignment for computer shooting. Assignment ashoot ($12)
	btst	#$5,$62(a3)		;pfalock - animation locked
	bne.w	Sub_31AB6
	bclr	#$1,$62(a3)		;clear pfna
	beq.w	.nna
	bra.w	Sub_313CA		;first frame: start the shot (temp2 = swing time set by CompShoot)
.nna	btst	#$3,$17F6A.l		;#sfssdir
	beq.w	Sub_362C4		;no: the shot is done
	clr.w	d2
	sub.w	d7,$42(a3)		;count the swing time down
	bpl.w	ShotMode		;still swinging: feed ShotMode no buttons
	bset	#$5,d2		;#cbut
	bra.w	ShotMode		;swing time over: press the shot button (cbut)
puckshootout						;puck logic for the shootout: on a new assignment clear the pads and
									;select the skater, then run the attempt
	bclr	#$1,$62(a3)
	beq.w	.selectskater
	bset	#$7,$17F7A.l
	clr.l	$17DCA.l
	clr.l	$17DCE.l
	clr.l	$17DD2.l
	bclr	#$7,$17F78.l
	btst	#$0,$17F78.l
	beq.w	.startattempt
	jsr	(NextShooter).l
	bra.w	.initflags
.startattempt	jsr	(StartShootoutPath).l
	move.l	a2,-(sp)
	movea.l	#tmstruct,a2
	dc.w	$4A79,$0001,$9366
	beq.w	.countattempt
	movea.l	#awtmstruct,a2
.countattempt	addi.w	#$1,$362(a2)
	movea.l	(sp)+,a2
.initflags	bclr	#$2,$17F70.l
	bclr	#$4,$17F70.l
	bclr	#$5,$17F70.l
	bclr	#$6,$17F70.l
	bset	#$1,(sflags6).l
	btst	#$3,$17F68.l
	bne.w	Stop4Pen
	bclr	#$1,$62(a3)
	btst	#$0,$17F78.l
	beq.w	.l19556
	dc.w	$4A79,$0001,$A436
	bne.w	.setstopped
	dc.w	$4A79,$0001,$A428
	bne.w	.setstopped
	dc.w	$33F9,$0001,$7FAE,$0001,$A56C
	dc.w	$33FC,$0002,$0001,$A56E
	jsr	(ChooseSong).l
	dc.w	$3F39,$0001,$A56A
	bra.w	.playsong
.l19556	dc.w	$33F9,$0001,$7FAE,$0001,$A56C
	dc.w	$33FC,$0002,$0001,$A56E
	jsr	(ChooseSong).l
	dc.w	$3F39,$0001,$A56A
.playsong	bsr.w	song
.setstopped	bset	#$0,$17F68.l
	bset	#$1,$17F78.l
	dc.w	$4279,$0001,$7BA8
	dc.w	$4279,$0001,$7BAA
	dc.w	$33FC,$0019,$0001,$93B6
	bsr.w	ReturnGoalies
	st.b	$40(a3)
	st.b	$42(a3)
.selectskater	bset	#$2,$17F70.l
	movem.w	d1-d2,-(sp)
	dc.w	$4EB9,$0003,$4666
	bmi.w	.noeligible
	movem.w	(sp)+,d1-d2
	bra.w	.checkgoalie
.noeligible	movem.w	(sp)+,d1-d2
	bclr	#$2,$17F70.l
	move.w	#$1B,d0		;puckfaceoff
	bsr.w	Sub_362E4
	rts
.checkgoalie	movem.w	d1-d2,-(sp)
	dc.w	$3039,$0001,$936A
	dc.w	$247C,$0001,$7480
	asl.w	#$7,d0
	adda.w	d0,a2
	tst.w	$34(a2)
	bne.w	.l19602
	btst	#$2,$63(a2)
	beq.w	.startpenshot
.l19602	dc.w	$3039,$0001,$936A
	move.w	#$6,d2
.goalieloop	subi.w	#$1,d2
	bmi.w	.noeligible
	subi.w	#$1,d0
	bpl.w	.wraphome
	move.w	#$5,d0
	bra.w	.l19630
.wraphome	cmpi.w	#$5,d0
	bne.w	.l19630
	move.w	#$B,d0
.l19630	dc.w	$247C,$0001,$7480
	move.w	d0,d1
	asl.w	#$7,d1
	adda.w	d1,a2
	tst.w	$34(a2)
	bne.w	.goalieloop
	btst	#$2,$63(a2)
	bne.w	.goalieloop
	dc.w	$33C0,$0001,$936A
.startpenshot	movem.w	(sp)+,d1-d2
	movea.l	#tmstruct,a2
	move.w	#$1F,d0		;puckpenshot
	bra.w	Sub_362E4
