	include	segacd\hockey.inc
	include	macros\genesis.mac

AddPenalty	equ	$3941A
AdjustFacingDirection	equ	$33058
LOAD	equ	$1B000
SortCords	equ	$17480
move	equ	$2C9C8
puckvx	equ	$17BA8
puckvy	equ	$17BAA
puckx	equ	$17B80
pucky	equ	$17B94
swap	equ	$2779A
tmstruct	equ	$1834C
X_162AA	equ	$162AA
X_1AF74	equ	$1AF74
X_1B0D8	equ	$1B0D8
X_1B362	equ	$1B362
X_1B3C0	equ	$1B3C0
X_1B3D6	equ	$1B3D6
X_1B878	equ	$1B878
X_1BAE0	equ	$1BAE0
X_21000	equ	$21000

	org	$1AC8C

ClearOffsidesIfAllPlayers						;a2 = team struct: clear the team offsides flag once no skater is past the
									;line
	btst	#$4,$32(a2)
	beq.w	X_21000
	movea.l	$22(a2),a0
	moveq	#$5,d1
	tst.w	$34(a0)		;position: off ice keeps the last d0
	bmi.w	.next
	move.w	$14(a0),d0		;d0 = y toward the goal this player shoots at
	btst	#$7,$62(a0)
	bne.w	.next
	neg.w	d0
.next	adda.w	#$80,a0
	cmpi.w	#$58,d0
	dbgt	d1,$1AC9C
	bgt.w	X_21000
	bclr	#$4,$32(a2)
	rts
a2offsides						;player a2 touched the puck: offsides penalty if his team is flagged and
									;the puck is past the blue line
	btst	#$5,$17F68.l
	beq.w	X_21000
	move.w	(pucky).l,d0		;puck y toward the goal a2 shoots at
	btst	#$7,$62(a2)
	bne.w	.0
	neg.w	d0
.0	cmpi.w	#$68,d0
	blt.w	X_21000
	movea.l	#tmstruct,a0		;a0 = a2's team struct
	btst	#$6,$62(a2)
	beq.w	.1
	adda.w	#$366,a0
.1	btst	#$4,$32(a0)
	beq.w	X_21000
	btst	#$4,$17F68.l
	bne.w	X_21000
	exg.l	a2,a3
	moveq	#$10,d0
	bsr.w	AddPenalty-LOAD
	exg.l	a2,a3
	rts
	move.w	$0(a2),$17ECA.l
	move.w	$14(a2),$17ECC.l
	move.w	$52(a2),$17EC8.l
	movea.l	#tmstruct,a0
	btst	#$6,$62(a2)
	beq.w	.l1AD54
	lea.l	$366(a0),a0
.l1AD54	clr.w	d0
	move.b	$66(a2),d0
	btst	#$3,$64(a2)
	beq.w	.l1AD6C
	bset	#$7,$17F7C.l
.l1AD6C	cmp.w	$18(a0),d0
	beq.w	.l1AD9A
	bclr	#$3,$32(a0)
	bne.w	.l1AD8A
	move.w	$1A(a0),$1C(a0)
	move.w	$18(a0),$1A(a0)
.l1AD8A	move.w	d0,$18(a0)
	cmp.w	$1C(a0),d0
	bne.w	.l1AD9A
	st.b	$1C(a0)
.l1AD9A	bclr	#$4,$17F6C.l
	bsr.w	a2offsides
	btst	#$2,$17ECE.l
	beq.w	.l1AE06
	btst	#$0,$17ECE.l
	beq.w	.l1AE06
	tst.w	$34(a2)
	beq.w	.l1AE06
	btst	#$1,$17ECE.l
	bne.w	.l1ADFC
	btst	#$7,$62(a2)
	beq.w	.l1AE06
.l1ADDC	clr.w	d0
	move.b	$17ECF.l,d0
	asl.w	#$7,d0
	move.l	a3,-(sp)
	movea.l	#SortCords,a3
	adda.w	d0,a3
	move.w	#$C,d0
	bsr.w	AddPenalty-LOAD
	movea.l	(sp)+,a3
	rts
.l1ADFC	btst	#$7,$62(a2)
	beq.w	.l1ADDC
.l1AE06	clr.b	$17ECE.l
	move.b	$53(a2),$17ECF.l
	move.w	(pucky).l,d0
	btst	#$7,$62(a2)
	beq.w	.l1AE2E
	bset	#$1,$17ECE.l
	neg.w	d0
.l1AE2E	bmi.w	X_21000
	move.w	$18372.l,d0
	sub.w	$186D8.l,d0
	dc.w	$082A,$0006,$0062,$6700,$0004,$4440,$6B00,$61B4
	dc.w	$08F9,$0002,$0001,$7ECE,$4E75
PuckIChk						;check for icing of puck penalty. Called from pucknorm
	btst	#$2,$17ECE.l		;#ifok
	beq.w	X_21000
	btst	#$0,$17ECE.l		;#ifcgl - if crossed goal line
	bne.w	X_21000
	tst.w	$17BE0.l
	bpl.w	X_21000
	move.w	#$108,d0		;goalline
	btst	#$1,$17ECE.l		;#ifdir - 1 = must cross top line
	bne.w	.0
	neg.w	d0		;other direction: d0 = -(goal line y)
	cmp.w	(pucky).l,d0		;check other goalline
	bgt.w	.chkx		;puck y reached the goal line
	rts
.0	cmp.w	(pucky).l,d0
	bgt.w	X_21000
.chkx	cmpi.w	#$2C,(puckx).l		;2C - edge of crease
	bgt.w	.set
	cmpi.w	#$FFD4,(puckx).l		;FFD4 - edge of crease
	blt.w	.set
	bclr	#$2,$17ECE.l		;#ifok cleared
	rts
.set	bset	#$0,$17ECE.l		;#ifcgl
	rts
puckunflip						;stop spinning puck. a3 = puck. Entered from
									;pucknothing, called from pucknorm
	cmpi.w	#$8,$5A(a3)		;2*4 SPAnum
	blt.w	.k
	cmpi.w	#$18,$5A(a3)		;6*4
	bge.w	.k
	eori.w	#$2,$54(a3)		;facedir
.k	ori.w	#$4,$54(a3)		;facedir bit 2 set
	clr.w	$5A(a3)		;SPAnum
	st.b	$5C(a3)		;SPAcnt
	rts
puckflip						;start puck spinning. a3 = puck, d0 bit 0 = flip. Called from checkgoal,
									;wallcoll and others
	andi.w	#$1,d0
	eor.w	d0,$54(a3)		;facedir
	andi.w	#$3,$54(a3)		;keep 0-3
	st.b	$5C(a3)		;SPAcnt
	move.w	#$46A,d1
	bra.w	X_1B3C0		;start the puck flip animation
	cmpi.w	#$18A,$6(a3)
	bne.w	.l1AF44
	move.w	-$80(a3),$0(a3)
	move.w	-$6C(a3),$14(a3)
	clr.w	$18(a3)
	moveq	#$14,d0
	btst	#$7,$17F6A.l
	beq.w	.l1AF3C
	moveq	#$0,d0
.l1AF3C	addi.w	#$1,(a3,d0.w)
	rts
.l1AF44	tst.w	$6(a3)
	beq.w	X_21000
	clr.w	$0(a3)
	move.w	#$12C,$14(a3)
	move.w	#$E,$18(a3)
	tst.w	-$6C(a3)
	bpl.w	X_1AF74
	move.w	#$8000,$4(a3)
	neg.w	$14(a3)
	subi.w	#$1,$18(a3)
	dc.w	$4E75
findpc						;find puck crossing lines: calculate when puck will cross goalline (if at
									;all). Called from pucknorm fills puckcross (2 entries of x word, time
									;word): top goal line first, then bottom
	movem.l	d0-d4/a1-a2,-(sp)
	movea.l	#$17E36,a1
	move.w	#$88,d1		;sideline - distance from center to side boards
	move.w	#$108,d4		;goaline
	bsr.w	.calc		;top goal line (y = d4)
	neg.w	d4		;make d4 negative to check bottom goal line
	bsr.w	.calc		;bottom goal line (y = -d4)
	movem.l	(sp)+,d0-d4/a1-a2
	rts
.calc	move.w	d4,d0		;move goaline into d0
	sub.w	(pucky).l,d0		;sub pucky from d0
	tst.w	(puckvy).l		;check puckvy
	beq.w	.nocross		;branch if 0
	move.w	d0,d2		;move d0 into d2
	swap	d2		;swap upper and lower word of d2
	clr.w	d2		;clear bottom word of d2
	asr.l	#$4,d2		;shift 4 bits right (divide by 16)
	divs.w	(puckvy).l,d2		;divide puckvy into d2
	bmi.w	.nocross		;branch if negative
	move.w	d2,$2(a1)		;time until crossing in frames (puckcross y)
	muls.w	(puckvx).l,d0		;mult puckvx with d0
	divs.w	(puckvy).l,d0		;divide puckvy into d0
	bvs.w	.nocross		;branch if overflow set
	add.w	(puckx).l,d0		;add puckx to d0
	cmp.w	d1,d0		;compare d1 (sideline) to d0
	blt.w	.o1		;branch if less than (in play)
	neg.w	d0		;negate d0
	add.w	d1,d0		;add d1 3 times to d0
	add.w	d1,d0
	add.w	d1,d0
.o1	neg.w	d1		;negate d1
	cmp.w	d1,d0		;compare d1 (other sideline) to d0
	bgt.w	.o2		;branch if greater than (in play)
	neg.w	d0		;negate d0
	add.w	d1,d0		;add d1 to d0 3 times
	add.w	d1,d0
	add.w	d1,d0
.o2	neg.w	d1		;negate d1
	move.w	d0,(a1)		;move d0 into puckcross
	bra.w	.next
.nocross	move.w	#$FFFF,$2(a1)		;move -1 into puckcross y
.next	adda.w	#$4,a1		;next puckcross entry (the other goal line)
	rts
skateto						;a0 = extra routine for collision avoidance, d0/d1 = x/y cord to skate to,
									;d7 = elapse frames
	sub.b	d7,$42(a3)		;sub d7 from temp2
	bpl.w	.ex		;exit if not 0 or less
	addi.b	#$C,$42(a3)		;add 12 - only execute every 12 frames
	bsr.w	.l1B0D8		;avoid the goal nets
	movem.w	d0-d1,-(sp)		;no deltax/deltay test
	move.w	$28(a3),d0		;Xvel
	asr.w	#$8,d0		;divide by 256
	neg.w	d0		;make negative
	add.w	(sp)+,d0		;add new x coord from stack
	sub.w	$0(a3),d0		;sub Xpos
	move.w	$2A(a3),d1		;Yvel
	asr.w	#$8,d1		;divide by 256
	neg.w	d1		;make negative
	add.w	(sp)+,d1		;add new y coord from stack
	sub.w	$14(a3),d1		;sub Ypos
	cmpi.w	#$C,d0		;compare 12 to d0
	bgt.w	.vt
	cmpi.w	#$FFF4,d0		;cmp -12
	blt.w	.vt
	cmpi.w	#$C,d1		;compare 12 to d1
	bgt.w	.vt
	cmpi.w	#$FFF4,d1		;cmp -12
	blt.w	.vt
	moveq	#$9,d0		;close enough: no direction
	bra.w	.nvt
.vt	bsr.w	vtoa
.nvt	jsr	(a0)		;extra collision routine
	move.b	d0,$43(a3)		;move d0 into temp2+1
	cmpi.w	#$7,d0		;compare to 7
	ble.w	.ex		;a real direction: go accelerate
	move.w	$28(a3),d0		;Xvel
	or.w	$2A(a3),d0		;Yvel
	bne.w	.ex		;still moving
	move.w	(puckx).l,d0		;move puckx into d0
	move.w	(pucky).l,d1		;move pucky into d1
	btst	#$0,$17BE3.l		;#pf2fight, puckx+pflags2
	beq.w	.nf
	move.w	$17EDC.l,d0		;scroll lock x coord
	move.w	$17EDE.l,d1		;scroll lock y coord
.nf	sub.w	$0(a3),d0		;Xpos
	sub.w	$14(a3),d1		;Ypos - face towards puck
	bsr.w	vtoa
	sub.w	$54(a3),d0		;facedir
	beq.w	.ex		;already facing it
	neg.w	d0
	andi.w	#$4,d0
	lsr.w	#$1,d0		;divide by 2
	subi.w	#$1,d0		;+1/-1: one step in the shorter turn direction
	add.w	$54(a3),d0		;facedir
	andi.w	#$7,d0
	move.w	d0,$54(a3)		;facedir
.ex	clr.w	d0		;d0 = stored direction
	move.b	$43(a3),d0		;temp2+1
	bra.w	X_1B3D6		;accelerate that way
.l1B0D8	clr.w	$17EEA.l
	clr.w	$17EEC.l
	tst.w	$34(a3)
	beq.w	X_21000
	move.w	$0(a3),d2
	eor.w	d0,d2
	bpl.w	.l1B17A
	move.w	d1,d2
	sub.w	$14(a3),d2
	move.w	$0(a3),d3
	muls.w	d3,d2
	sub.w	d0,d3
	divs.w	d3,d2
	add.w	$14(a3),d2
	cmpi.w	#$121,d2
	bgt.w	.l1B17A
	cmpi.w	#$DB,d2
	blt.w	.l1B144
	move.w	#$144,d3
	cmpi.w	#$FE,d2
	bgt.w	.l1B138
	blt.w	.l1B134
	cmpi.w	#$FE,$14(a3)
	bgt.w	.l1B138
.l1B134	move.w	#$B8,d3
.l1B138	sub.w	d2,d3
	move.w	d3,$17EEC.l
	bra.w	.l1B17A
.l1B144	cmpi.w	#$FF25,d2
	bgt.w	.l1B17A
	cmpi.w	#$FEDF,d2
	blt.w	.l1B17A
	move.w	#$FF48,d3
	cmpi.w	#$FF02,d2
	bgt.w	.l1B172
	blt.w	.l1B16E
	cmpi.w	#$FF02,$14(a3)
	bgt.w	.l1B172
.l1B16E	move.w	#$FEBC,d3
.l1B172	sub.w	d2,d3
	move.w	d3,$17EEC.l
.l1B17A	move.w	d1,d3
	subi.w	#$FE,d3
	move.w	$14(a3),d2
	subi.w	#$FE,d2
	bsr.w	.l1B1AC
	move.w	d1,d3
	addi.w	#$FE,d3
	move.w	$14(a3),d2
	addi.w	#$FE,d2
	bsr.w	.l1B1AC
	add.w	$17EEA.l,d0
	add.w	$17EEC.l,d1
	rts
.l1B1AC	move.w	d3,d4
	eor.w	d2,d4
	bpl.w	X_21000
	move.w	d0,d4
	sub.w	$0(a3),d4
	muls.w	d2,d4
	sub.w	d3,d2
	divs.w	d2,d4
	add.w	$0(a3),d4
	cmpi.w	#$50,d4
	bgt.w	X_21000
	cmpi.w	#$FFB0,d4
	blt.w	X_21000
	moveq	#$50,d3
	tst.w	d4
	bne.w	.l1B1E0
	tst.w	$0(a3)
.l1B1E0	bpl.w	.l1B1E6
	neg.w	d3
.l1B1E6	sub.w	d4,d3
	move.w	d3,$17EEA.l
	rts
skatetopuckinit						;d0/d1 = puck x/y plus half the high byte of its
									;velocity. Called from skatetopuck and assnearest
	move.b	(puckvx).l,d0		;high byte of the puck x velocity (signed)
	asr.b	#$1,d0		;halved
	ext.w	d0
	add.w	(puckx).l,d0		;d0 = puck x + vx/2
	move.b	(puckvy).l,d1
	asr.b	#$1,d1
	ext.w	d1
	add.w	(pucky).l,d1		;d1 = puck y + vy/2
	rts
skatetopuck						;player a3 should skate to puck. d7 = elapse frames
	bsr.w	skatetopuckinit		;d0/d1 = predicted puck spot
	sub.b	d7,$42(a3)		;temp2
	bpl.w	.ex		;not due: reuse the last direction
	addi.b	#$A,$42(a3)		;temp2
	bsr.w	X_1B0D8		;go around the nets
	movem.w	d0-d1,-(sp)		;save the target
	move.l	a3,-(sp)		;GetHot argument: this player
	bsr.w	X_1B362		;d0/d1 = hot spot x/y of this player
	neg.b	d0
	neg.b	d1
	sub.b	$28(a3),d0		;Xvel
	ext.w	d0
	add.w	(sp)+,d0		;+ target x
	sub.w	$0(a3),d0		;Xpos
	sub.b	$2A(a3),d1		;Yvel
	ext.w	d1
	add.w	(sp)+,d1
	sub.w	$14(a3),d1		;Ypos
	bsr.w	vtoa		;direction to the puck
	move.b	d0,$43(a3)		;temp2 lower byte
	tst.w	$34(a3)		;goalie skips the sweep check
	beq.w	.ex
	move.w	(puckvx).l,d0
	move.w	(puckvy).l,d1
	bsr.w	vtoa		;direction the puck is moving
	eori.w	#$4,d0		;opposite of that
	cmp.w	$54(a3),d0		;facedir
	beq.w	.ex		;puck is coming towards players
	move.w	(puckx).l,d0
	sub.w	$0(a3),d0		;Xpos
	move.w	(pucky).l,d1
	sub.w	$14(a3),d1		;Ypos
	movem.w	d0-d1,-(sp)
	bsr.w	vtoa		;direction from me to the puck
	cmp.w	$54(a3),d0
	movem.w	(sp)+,d0-d1
	bne.w	.ex		;not facing the puck
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0		;squared distance to the puck
	cmpi.l	#$384,d0		;#30^2
	bls.w	.ex
	cmpi.l	#$5A4,d0		;#38^2
	bls.w	X_162AA
.ex	move.b	$43(a3),d0
	bra.w	X_1B3D6
	addi.w	#$1,$36(a3)
	andi.w	#$7,$36(a3)
	bset	#$1,$62(a3)
	rts
	subi.w	#$1,$36(a3)
	andi.w	#$7,$36(a3)
	move.l	d1,-(sp)
	move.w	$36(a3),d1
	move.b	d0,$38(a3,d1.w)
	bset	#$1,$62(a3)
	move.l	(sp)+,d1
	rts
vtoa						;d0/d1 are x/y distances which are converted into direction 0-7 and
									;returned in d0 (8 = no direction)
	movem.l	d2/a0,-(sp)
	move.w	d0,d2
	or.w	d1,d2
	beq.w	.nodir		;both zero: no direction
	clr.w	d2		;d2 = 4 bit index built from the signs and slope tests
	tst.w	d0
	bpl.w	.0
	neg.w	d0		;|dx|
	bset	#$0,d2		;bit 0: dx negative
.0	tst.w	d1		;y sign
	bpl.w	.1
	neg.w	d1		;|dy|
	bset	#$1,d2		;bit 1: dy negative
.1	asl.w	#$1,d1		;slope test: |dx| against 2|dy|
	cmp.w	d1,d0
	bhi.w	.2		;|dx| > 2|dy|
	bset	#$2,d2		;bit 2: |dx| <= 2|dy|
.2	lsr.w	#$1,d1		;slope test: |dy| against 2|dx|
	asl.w	#$1,d0
	cmp.w	d0,d1
	bhi.w	.3		;|dy| > 2|dx|
	bset	#$3,d2		;bit 3: |dy| <= 2|dx|
.3	movea.l	#GetHot+LOAD,a0		;#.dt
	clr.w	d0
	move.b	(a0,d2.w),d0
	movem.l	(sp)+,d2/a0
	rts
.nodir	moveq	#$8,d0		;8 = no direction
	movem.l	(sp)+,d2/a0
	rts
GetHot						;push long address of structure to get hot spot from. Hot spot x/y
									;returned in d0/d1. Reads a byte pair per frame from HotList
	dc.w	$0107
	dc.w	$0305
	dc.l	$404
	dc.w	$0206,$0206
	dc.w	$0107
	dc.w	$0305
	dc.w	$48E7,$00C0
	dc.w	$206F,$000C
	dc.w	$4240
	dc.w	$4241
	dc.w	$4A68,$0006
	dc.w	$6F00,$0044
	dc.w	$2279,$0004,$7D28
	dc.w	$5589
	dc.w	$3028,$0006
	dc.w	$D040
	dc.w	$1231,$0001
	dc.w	$4881
	dc.w	$1031,$0000
	dc.w	$4880
	dc.w	$0828,$0003,$0004
	dc.w	$6700,$0004
	dc.w	$4440
.l1B39C	dc.w	$0828,$0004,$0004
	dc.w	$6600,$0004
	dc.w	$4441
.l1B3A8	dc.w	$0839,$0007,$0001,$7F6A
	dc.w	$6700,$0006
	dc.w	$C141
	dc.w	$4441
.l1B3B8	dc.w	$4CDF,$0300
	dc.w	$2E9F
	dc.w	$4E75
.l1B3C0	dc.w	$B26B,$0058
	dc.w	$6700,$5C3A
	dc.w	$426B,$005A
	dc.w	$3741,$0058
	dc.w	$50EB,$005C
	dc.w	$4E75
	dc.w	$4A6B,$0034
	dc.w	$6700,$01C8
	dc.w	$323C,$050C
	dc.w	$082B,$0004,$0062
	dc.w	$6700,$0006
	dc.w	$323C,$0A60
.l1B3F0	dc.w	$0240,$000F
	dc.w	$0C40,$0007
	dc.w	$6F00,$0022
	dc.w	$0C40,$0009
	dc.w	$6600,$000E
	dc.w	$302B,$0028
	dc.w	$806B,$002A
	dc.w	$6600,$06D2
.l1B410	dc.w	$082B,$0001,$0063
	dc.w	$6700,$FFA8
	dc.w	$4E75
.l1B41C	dc.w	$48A7,$C000
	dc.w	$3400
	dc.w	$302B,$0052
	dc.w	$B079,$0001,$7BE0
	dc.w	$6700,$00C6
	dc.w	$3039,$0001,$7B80
	dc.w	$906B,$0000
	dc.w	$362B,$0014
	dc.w	$1239,$0001,$7BAA
	dc.w	$4881
	dc.w	$D279,$0001,$7B94
	dc.w	$9243
	dc.w	$082B,$0007,$0062
	dc.w	$6600,$000C
	dc.w	$4440
	dc.w	$4441
	dc.w	$4443
	dc.w	$0A42,$0004
.l1B462	dc.w	$082B,$0004,$0062
	dc.w	$6600,$0028
	dc.w	$4A43
	dc.w	$6A00,$0084
	dc.w	$0C42,$0004
	dc.w	$6600,$007C
	dc.w	$6100,$FE7C
	dc.w	$0640,$0001
	dc.w	$0240,$0007
	dc.w	$0C40,$0002
	dc.w	$6200,$0068
	dc.w	$6000,$0026
.l1B492	dc.w	$0442,$0003
	dc.w	$0242,$0007
	dc.w	$0C42,$0002
	dc.w	$6200,$0054
	dc.w	$6100,$FE54
	dc.w	$0640,$0002
	dc.w	$0240,$0007
	dc.w	$0C40,$0004
	dc.w	$6200,$0040
.l1B4B6	dc.w	$082B,$0004,$0062
	dc.w	$6600,$003C
	dc.w	$302B,$0028
	dc.w	$806B,$002A
	dc.w	$6700,$0020
	dc.w	$302B,$0028,$322B,$002A,$6100,$FE22,$9057,$0640
	dc.w	$0001,$0240,$0007,$0C40,$0002,$6200,$0012,$08EB
	dc.w	$0004,$0062,$6000,$0008,$08AB,$0004,$0062,$4C9F
	dc.w	$0003,$342B,$0054,$9042,$0240,$0007,$207C,$0003
	dc.w	$6594,$E340,$4A70,$0000,$6700,$02A2,$382B,$0028
	dc.w	$C9C4,$362B,$002A,$C7C3,$D684,$4843,$383C,$0300
	dc.w	$9843,$0C44,$0180,$6C00,$0006,$383C,$0180,$C9F0
	dc.w	$0000,$082B,$0004,$0062,$6700,$0004,$4484,$D9AB
	dc.w	$0054,$026B,$0007,$0054,$342B,$0054,$0C43,$0014
	dc.w	$6300,$0028,$4241,$4A70,$0000,$6A00,$0006,$0A41
	dc.w	$FFCE,$082B,$0003,$0004,$6700,$0006,$0A41,$FFCE
	dc.w	$0641,$0694,$08EB,$0001,$0063,$6100,$FE38,$0C43
	dc.w	$0002,$6200,$02DA,$4E75
goalieacc						;goalie gets acc. in direction d0. Turns facedir one step toward d0
	ori.b	#$10,d0
	ori.b	#$10,(a0)
	dc.l	$FFF0
	dc.w	$FFF0
	dc.w	$FFF0
	btst	#$3,$62(a3)
	beq.w	.normalgoalie
	movem.w	d0,-(sp)
	move.w	$17BE0.l,d0
	cmp.w	$52(a3),d0
	movem.w	(sp)+,d0
	beq.w	.normalgoalie
	cmpi.w	#$30,$0(a3)
	bgt.w	.normalgoalie
	cmpi.w	#$FFD0,$0(a3)
	blt.w	.normalgoalie
	cmpi.w	#$FF40,$14(a3)
	bgt.w	.checkbottom
	cmpi.w	#$FEFA,$14(a3)
	blt.w	.normalgoalie
	bra.w	.facepuck
.checkbottom	cmpi.w	#$C0,$14(a3)
	blt.w	.normalgoalie
	cmpi.w	#$106,$14(a3)
	bgt.w	.normalgoalie
.facepuck	movem.w	d0-d1,-(sp)
	move.w	(puckx).l,d0
	sub.w	$0(a3),d0
	move.w	(pucky).l,d1
	sub.w	$14(a3),d1
	cmpi.w	#$10,d0
	bgt.w	.usevtoa
	cmpi.w	#$FFF0,d0
	blt.w	.usevtoa
	cmpi.w	#$10,d1
	bgt.w	.usevtoa
	cmpi.w	#$FFF0,d1
	blt.w	.usevtoa
	move.w	$54(a3),d0
	bra.w	.checkadjust
.usevtoa	bsr.w	vtoa
.checkadjust	btst	#$0,$17F72.l
	bne.w	.adjustkeepdir
	bsr.w	AdjustFacingDirection-LOAD
	movem.w	(sp)+,d0-d1
	bra.w	.setready
.adjustkeepdir	movem.w	(sp)+,d0-d1
	cmpi.w	#$8,d0
	beq.w	.setready
	movem.w	d0-d1,-(sp)
	bsr.w	AdjustFacingDirection-LOAD
	movem.w	(sp)+,d0-d1
.setready	move.w	#$2,d1
	btst	#$1,$63(a3)
	bne.w	.exit
	bsr.w	X_1B3C0
	cmpi.w	#$8,d0
	bne.w	.playermove
	tst.w	$34(a3)
	bne.w	.playermove
	btst	#$3,$62(a3)
	beq.w	.playermove
	move.w	d0,-(sp)
	move.w	$14(a3),d0
	btst	#$7,$62(a3)
	beq.w	.topstay
	neg.w	d0
.topstay	cmpi.w	#$D8,d0
	blt.w	.stopandrestore
	move.w	$0(a3),d0
	cmpi.w	#$20,d0
	bgt.w	.stopandrestore
	cmpi.w	#$FFE0,d0
	blt.w	.stopandrestore
	move.w	(sp)+,d0
	jsr	$22F74.l
	bra.w	.playermove
.stopandrestore	jsr	$22F74.l
	move.w	(sp)+,d0
.playermove	move.w	d0,d2
	bra.w	X_1B878
.normalgoalie	move.w	#$2,d1
	btst	#$3,$62(a3)
	beq.w	.goalieacc2
	btst	#$2,$62(a3)
	bne.w	.cgl
	cmpi.w	#$8,d0
	bne.w	.turnskater
	tst.w	$34(a3)
	bne.w	.cgl
	move.w	d0,-(sp)
	move.w	$14(a3),d0
	btst	#$7,$62(a3)
	beq.w	.topstop
	neg.w	d0
.topstop	cmpi.w	#$D8,d0
	blt.w	.restoreidle
	move.w	$0(a3),d0
	cmpi.w	#$20,d0
	bgt.w	.restoreidle
	cmpi.w	#$FFE0,d0
	blt.w	.restoreidle
	move.w	(sp)+,d0
	bsr.w	stopna
	bra.w	.cgl
.restoreidle	move.w	(sp)+,d0
	bra.w	.cgl
.turnskater	bra.w	.d1
.goalieacc2	andi.w	#$F,d0
	cmpi.w	#$7,d0
	ble.w	.d1
	cmpi.w	#$9,d0
	bne.w	.cgl
	move.w	$28(a3),d0
	or.w	$2A(a3),d0
	beq.w	.cgl
	jmp	$22F74.l
.cgl	btst	#$1,$63(a3)
	beq.w	X_1B3C0
.exit	rts
.d1	sub.w	$54(a3),d0
	beq.w	.d11
	neg.w	d0
	andi.w	#$4,d0
	lsr.w	#$1,d0
	subi.w	#$1,d0
	add.w	$54(a3),d0
	andi.w	#$7,d0
	move.w	d0,$54(a3)
.d11	move.w	#$3D8,d1
	bsr.w	X_1B3C0
	move.w	$54(a3),d2
	bra.w	X_1B878
noturn0						;doplayeracc when the wanted direction needs no turn (.ftab entry 0). d0 =
									;direction minus facedir, times 2
	moveq	#$2,d4		;d4 = 2 forwards, 6 when skating backwards
	btst	#$4,$62(a3)
	beq.w	.0
	addi.w	#$4,d4
	eori.w	#$8,d0		;backwards: swap "straight" and "opposite"
.0	tst.w	d0		;straight ahead?
	beq.w	noturn		;the wanted direction is already the way I skate
	move.w	$28(a3),d0		;opposite: look at the current motion
	move.w	$2A(a3),d1
	bsr.w	vtoa
	btst	#$3,d0		;not moving
	bne.w	.nostop
	sub.w	$54(a3),d0
	add.w	d4,d0
	andi.w	#$7,d0
	cmpi.w	#$4,d0
	blt.w	X_1BAE0		;moving along the facing: brake first
.nostop	addi.w	#$1,$54(a3)		;turn one step (the way depends on attribute bit 3)
	btst	#$3,$4(a3)
	beq.w	.nos0
	subi.w	#$2,$54(a3)
.nos0	andi.w	#$7,$54(a3)		;wrap facing to 0-7
	move.w	#$50C,d1
	btst	#$4,$62(a3)
	beq.w	X_1B3C0
	move.w	#$A60,d1
	bra.w	X_1B3C0
noturn						;reverse the acc. direction when skating backwards, then falls into
									;playeracc
	move.w	#$A92,d1
	btst	#$4,$62(a3)
	bne.w	.l1B85C
	move.w	#$5D0,d1
	btst	#$6,$63(a3)
	beq.w	.l1B84A
	move.w	#$11E6,d1
.l1B84A	move.w	$17BE0.l,d4
	cmp.w	$52(a3),d4
	bne.w	.l1B85C
	move.w	#$53E,d1
.l1B85C	btst	#$1,$63(a3)
	bne.w	.l1B86A
	bsr.w	X_1B3C0
.l1B86A	btst	#$4,$62(a3)
	beq.w	X_1B878
	dc.w	$0A42,$0004,$E542,$41FA,$0312,$3230,$2002,$3030
	dc.w	$2000,$342B,$0050,$6700,$000A,$B142,$6A00,$0004
	dc.w	$4240,$342B,$004E,$6700,$000A,$B342,$6B00,$0004
	dc.w	$4241,$4242,$142B,$0067,$E44A,$4442,$0642,$0040
	dc.w	$D42B,$0068,$0839,$0001,$0001,$7F7C,$6600,$000E
	dc.w	$0839,$0006,$0001,$7F7A,$6700,$000A,$0602,$0002
	dc.w	$0602,$0002,$4A6B,$0034,$6600,$000A,$D42B,$0068
	dc.w	$0642,$0010,$E242,$C1C2,$C3C2,$EA80,$EA81,$C1C7
	dc.w	$C3C7,$4A6B,$0034,$6600,$001E,$082B,$0003,$0062
	dc.w	$6700,$0014,$3439,$0001,$7BE0,$B46B,$0052,$6600
	dc.w	$0006,$E240,$E241,$D06B,$0028,$D26B,$002A,$3400
	dc.w	$3601,$C5C2,$C7C3,$D682,$48A7,$C000,$6100,$596E
	dc.w	$0839,$0004,$0001,$7F7A,$6700,$0006,$303C,$1000
	dc.w	$4242,$142B,$0069,$0839,$0001,$0001,$7F7C,$6600
	dc.w	$000E,$0839,$0006,$0001,$7F7A,$6700,$0012,$0602
	dc.w	$0002,$0C02,$001E,$6F00,$0006,$143C,$001E,$33C2
	dc.w	$0001,$7E66,$E24A,$C4C0,$E982,$4842,$E542,$0242
	dc.w	$003F,$45FA,$0118,$33C2,$0001,$7E6C,$2432,$2000
	dc.w	$23C2,$0001,$7E68,$0C79,$003C,$0001,$7E6C,$6C00
	dc.w	$002A,$0839,$0000,$0001,$7E67,$6700,$001E,$3439
	dc.w	$0001,$7E6C,$0642,$0004,$2432,$2000,$94B9,$0001
	dc.w	$7E68,$E282,$D4B9,$0001,$7E68,$082B,$0006,$0063
	dc.w	$6700,$0004,$E68A,$4A6B,$0034,$6600,$0012,$3039
	dc.w	$0001,$7BE0,$B06B,$0052,$6600,$0004,$E282,$4C9F
	dc.w	$0003,$B682,$6200,$000A,$3740,$0028,$3741,$002A
	dc.w	$4A79,$0001,$8C0A,$6600,$55F4,$0839,$0007,$00FF
	dc.w	$800E,$66F6,$33FC,$001B,$00FF,$8020,$08F9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$67F6,$3039
	dc.w	$00FF,$8010,$08F9,$0007,$00FF,$800F,$08B9,$0006
	dc.w	$00FF,$800F,$0839,$0006,$00FF,$800E,$66F6,$08B9
	dc.w	$0007,$00FF,$800F,$0240,$007F,$6600,$55A0,$6100
	dc.w	$583C,$0440,$0021,$0C40,$0C00,$6D00,$5852,$142B
	dc.w	$0072,$4882,$E24A,$D042,$6100,$5844,$082B,$0000
	dc.w	$0072,$6700,$0016,$0839,$0000,$0001,$7475,$6700
	dc.w	$000A,$0640,$0001,$6000,$5826,$4E75,$01CD,$9410
	dc.w	$01FC,$E3E1,$022E,$8284,$0262,$6FF9,$0298,$AC40
	dc.w	$02D1,$3759,$030C,$1144,$0349,$3A01,$0388,$B190
	dc.w	$03CA,$77F1,$040E,$8D24,$0454,$F129,$049D,$A400
	dc.w	$04E8,$A5A9,$0535,$F624,$0585,$9571,$0C6B,$1000
	dc.w	$0028,$6E00,$0032,$0C6B,$F000,$0028,$6D00,$0028
	dc.w	$0C6B,$1000,$002A,$6E00,$001E,$0C6B,$F000,$002A
	dc.w	$6D00,$0014,$4A6B,$0034,$6600,$0036,$4EF9,$0002
	dc.w	$2F74,$6000,$002C,$323C,$050C,$082B,$0004,$0062
	dc.w	$6600,$000C,$08EB,$0001,$0063,$323C,$06C6,$6100
	dc.w	$F88C,$4A6B,$0034,$6600,$0008,$4EF9,$0002,$2F74
stopna						;slow player a3 by 150 on each axis, no animation change. Falls in from
									;dostop, also entered from goalieacc and others
	tst.w	$28(a3)		;Xvel
	bpl.w	.xp
	addi.w	#$96,$28(a3)		;150
	bmi.w	.y		;still negative: done
	clr.w	$28(a3)		;crossed zero: clear (the code below then also ends at 0)
.xp	subi.w	#$96,$28(a3)		;positive x: subtract 150
	bpl.w	.y
	clr.w	$28(a3)
.y	tst.w	$2A(a3)		;Yvel
	bpl.w	.yp
	addi.w	#$96,$2A(a3)
	bmi.w	X_21000
	clr.w	$2A(a3)
.yp	subi.w	#$96,$2A(a3)
	bpl.w	X_21000
	clr.w	$2A(a3)
	rts
	dc.w	$0000,$00C8,$008D,$008D,$00C8,$0000,$008D,$FF73
	dc.w	$0000,$FF38,$FF73,$FF73,$FF38,$0000,$FF73,$008D
	dc.w	$0000,$0000
UnpackNibbles
	movem.l	d0-d2/a0-a1,-(sp)
	movea.l	#$18BE8,a1
	clr.w	d2
	bra.w	.l1BBD8
.l1BBC2	move.b	(a0)+,d1
	bchg	#$0,d2
	bne.w	.l1BBD2
	suba.w	#$1,a0
	lsr.w	#$4,d1
.l1BBD2	andi.w	#$F,d1
	move.w	d1,(a1)+
.l1BBD8	dbra	d0,.l1BBC2
	movem.l	(sp)+,d0-d2/a0-a1
	rts
