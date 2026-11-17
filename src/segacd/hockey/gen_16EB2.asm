donothing
	btst	#$5,$62(a3)
	bne.w	Sub_31AB6
	btst	#$3,$62(a3)
	bne.w	Sub_31AB6
	moveq	#$8,d0
	bra.w	doplayeracc
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_16ECC.bin
assgoaliectrl						;joypad controlled goalie control: a3 = goalie; a goalie not on the
									;joystick leaves through assexit
	btst	#$3,$62(a3)		;is player joystick controlled?
	bne.w	.goaliectrl		;branch is so
	bra.w	assexit
.goaliectrl	btst	#$1,$62(a3)		;check if new assignment
	bne.w	.na		;branch if new assignment
	movem.w	d0-d1,-(sp)		;push to stack
	move.w	$0(a3),d0		;Xpos
	move.w	$14(a3),d1		;Ypos
	cmpi.w	#$AA,d1		;compare $AA to Ypos
	bgt.w	.l1780C
	cmpi.w	#$FF56,d1		;check -$AA to Ypos
	blt.w	.l1780C		;branch if less than
	btst	#$0,$17F68.l		;check if clock stopped
	bne.w	.l1780C		;branch if so
	move.w	d0,-(sp)		;push to stack
	move.w	#$8,d0		;clock stoppage due to goalie out of range
	jsr	(AddPenalty2).l
	move.w	(sp)+,d0
.l1780C	dc.w	$9079,$0001,$7CEE
	dc.w	$9279,$0001,$7CEA
	bclr	#$2,$64(a3)		;clear goalie control bit?
	cmpi.w	#$74,d0		;compare $74 to Xpos diff
	blt.w	.0		;branch if less than
	bset	#$2,$64(a3)		;set goalie control bit?
	bra.w	.cont2
.0	cmpi.w	#$FF8C,d0		;compare -$74 to Xpos diff
	bgt.w	.1		;branch if greater than
	bset	#$2,$64(a3)		;set goalie control bit?
	bra.w	.cont2
.1	cmpi.w	#$64,d1		;compare $64 to Ypos diff
	blt.w	.2		;branch if less than
	bset	#$2,$64(a3)		;set goalie control bit?
	bra.w	.cont2
.2	cmpi.w	#$FF9C,d1		;compare -$64 to Ypos diff
	bgt.w	.cont2		;branch if greater than
	bset	#$2,$64(a3)		;set goalie control bit?
.cont2	movem.w	(sp)+,d0-d1		;pop from stack
	btst	#$2,$64(a3)		;check goalie ctrl bit
	bne.w	Sub_32930		;branch if set
.na	btst	#$5,$62(a3)		;check if anim lock
	bne.w	Sub_31AB6		;exit if so
	bsr.w	check4bench
	bclr	#$1,$62(a3)		;clear new assignment bit
	beq.w	.nna		;branch if already cleared
	clr.w	$40(a3)		;clear temp1
	move.w	#$8,$42(a3)		;move 8 into temp2
	st.b	$46(a3)		;FFFF to temp4
.nna	btst	#$1,$63(a3)		;check if anim in progress
	bne.w	.ex		;exit if so
	btst	#$0,$17F68.l		;check if clock stopped
	bne.w	Sub_31AB6		;exit if so
	tst.w	$48(a3)		;test temp5
	bmi.w	.nofo		;branch if less than 0
	move.w	$52(a3),d0		;move SCnum into d0
	cmp.w	$17BE0.l,d0		;check if puckc is goalie
	beq.w	.mbfo		;branch if equal
	st.b	$48(a3)		;set temp5 to -1
	bra.w	.nofo
.mbfo	sub.w	d7,$48(a3)		;subtract d7(frames elapsed) from temp5
	bpl.w	.nofo		;branch if more than 0
	btst	#$2,$17F70.l		;check bit 2
	beq.w	.l178EA		;branch if not set
	bset	#$4,$17F70.l
	bra.w	.nofo
.l178EA	moveq	#$8,d0
	bsr.w	AddPenalty2
.nofo	sub.b	d7,$40(a3)		;sub d7(frames elapsed) from temp1
	bpl.w	.ex		;branch if positive
	move.b	$6B(a3),d0		;DfA into d0
	beq.w	.3		;branch if value was 0
	btst	#$6,$17F7A.l		;check if crowd meter broken
	beq.w	.3		;jump if not
	subi.b	#$1,d0		;sub 1 from d0
.3	lsr.b	#$2,d0		;divide by 4
	move.b	d0,$40(a3)		;move d0 into temp1
	move.w	$52(a3),d0		;move SCnum into d0
	cmp.w	$17BE0.l,d0		;compare puckc to d0
	beq.w	.ex		;jump to assgoaliecpu if the same
.ex	rts
checkanim
	btst	#$3,$62(a3)
	bne.w	assgoaliectrl
