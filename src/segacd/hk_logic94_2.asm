	include	segacd\hockey.inc
	include	macros\genesis.mac

BA_Goalie_SCnum	equ	$1936A
LOAD	equ	$1B000
PBnum	equ	$18068
PadControlBits	equ	$17DC8
ReadGoaliePulled	equ	$2AEDC
SortCords	equ	$17480
lastplayer	equ	$17E2A
makepde	equ	$3C274
move	equ	$2C9C8
passdir	equ	$17E2C
passspeed	equ	$17E2E
puckc	equ	$17BE0
puckvx	equ	$17BA8
puckvy	equ	$17BAA
puckvz	equ	$17BAC
puckvzadj	equ	$226A8
puckx	equ	$17B80
pucky	equ	$17B94
sfx	equ	$3710C
swap	equ	$2779A
X_167B8	equ	$167B8
X_167DC	equ	$167DC
X_16AB6	equ	$16AB6
X_1B2C4	equ	$1B2C4
X_1C044	equ	$1C044
X_1C050	equ	$1C050
X_1C08E	equ	$1C08E

	org	$16528

doshot						;stick is at puck so launch puck toward goal
	movem.l	d0-d7/a0-a3,-(sp)
	bclr	#$4,$17F78.l
	btst	#$1,$64(a3)		;check if player on breakaway
	beq.w	.cont
	bset	#$4,$17F78.l		;set if breakaway
.cont	bsr.w	X_167DC
	move.w	#$5,-(sp)		;#SFXshotwiff - sound effect
	move.w	$52(a3),$17E28.l
	bclr	#$3,$17F6A.l		;#sfssdir - shot direction mode
	bset	#$5,$62(a3)		;#pfalock
	btst	#$3,$64(a3)		;check if shooting one timer
	bne.w	.shottype		;jump if yes
	move.w	(puckc).l,d0		;puck carrier SCnum into d0
	cmp.w	$52(a3),d0		;is player puck carrier?
	bne.w	.ex		;wiffed shot
.shottype	move.w	#$18,(sp)		;#SFXshotfh
	bset	#$4,$17F6C.l		;#sf2shot - shot was taken
	cmpi.w	#$92E,$58(a3)
	bne.w	.nbh		;no backhand
	move.w	#$14,(sp)		;#SFXshotbh
	move.w	(passspeed).l,d0
	lsr.w	#$2,d0		;sub 25% for backhand shots
	sub.w	d0,(passspeed).l
.nbh	btst	#$3,$64(a3)		;check if shooting one timer
	beq.w	.cont2		;jump if not
	movem.l	d0-d1,-(sp)		;push d0-d1 on stack
	move.w	#$1F,d0		;1F into d0 - one timer min speed
	move.w	d0,(passspeed).l		;make passspeed start with a higher value
	movem.l	(sp)+,d0-d1		;Pop off stack d0-d1
.cont2	clr.w	d0
	move.b	$6C(a3),d0		;6C = shotspd (ShP)
	lsr.b	#$1,d0		;divide by 2
	movea.l	a3,a0		;move a3 address into a0
	jsr	(makepde).l		;scale d0 based on energy level
	addi.w	#$14,d0		;add 14 to d0
	mulu.w	(passspeed).l,d0		;shot speed ranged by energy level
	mulu.w	#$5249,d0		;($4000*45)/35
	swap	d0		;swaps the upper and lower words of d0
	move.w	d0,(passspeed).l		;move d0 into passspeed
	btst	#$0,$6C(a3)		;checks if ShP value is even or odd
	beq.w	.even
	asr.w	#$4,d0		;divide by 16
	add.w	(passspeed).l,d0		;add passspeed to d0
.even	lsr.w	#$4,d0		;divide by 16 (d0 is passspeed)
	neg.w	d0		;negative
	addi.w	#$3,d0		;add 3 to d0
	bpl.w	.nbh2
	clr.w	d0		;clear if negative
.nbh2	add.w	d0,(sp)		;add to stack current value (Shot SFX)
	st.b	(puckc).l		;clear puck carrier
	move.b	#$10,$5E(a3)		;5E = nopuck - no puck collision till 0
	move.w	$52(a3),(lastplayer).l		;SCNum
	move.w	#$108,d1		;$108 = top goal line Y position
	btst	#$7,$62(a3)		;pfgoal, pflags
	bne.w	.0		;branch if shooting up
	neg.w	d1		;flip d1 if shooting down
.0	move.w	(passdir).l,d2		;passdir into d2
	asl.w	#$2,d2		;mult by 4
	lea.l	X_167B8(pc),a0		;table of shot directions
	move.w	(a0,d2.w),d0		;xoffset
	move.w	$2(a0,d2.w),d2		;z offset
	sub.w	(puckx).l,d0
	sub.w	(pucky).l,d1
	movem.w	d0-d2,-(sp)		;push d0-d2(dx,dy,z offset) on stack
	muls.w	d0,d0
	muls.w	d1,d1
	add.l	d1,d0
	bsr.w	X_1C08E
	tst.w	d0		;distance in pix to goal
	bne.w	.1
	addi.w	#$1,d0
.1	move.w	d0,d3		;straight line distance from puck to spot aiming for with passdir
	btst	#$4,$17F68.l		;check if highlight (always perfect)
	bne.w	.perf
	cmpi.w	#$C8,d3		;C8 = 200 decimal
	bhi.w	.notperf		;too far away from perfect shot
	jsr	(ReadGoaliePulled).l		;checks if shooting team's G pulled
	bmi.w	.perf		;perfect shot with pulled goalie
	btst	#$0,$17F78.l		;check if shootout
	bne.w	.perf		;perfect shot in shootout
	moveq	#$10,d0		;start value for ShA calc
	add.b	$6D(a3),d0		;shotacc(a3)
	bsr.w	X_1C050
	cmpi.w	#$E,d0		;chance of perfect shot
	bgt.w	.perf		;branch if higher - perfect shot
.notperf	clr.w	d0
	move.b	$6D(a3),d0		;shotacc(a3)
	lsr.w	#$1,d0		;divide by 2
	move.b	d0,-(sp)		;push on stack
	move.w	(passspeed).l,d0		;move passspeed into d0
	lsr.w	#$4,d0		;divide by 16
	sub.b	(sp)+,d0		;shotacc(a3) / 2
	addi.b	#$10,d0		;add $10 to d0
	mulu.w	d3,d0		;mult straight line distance with d0
	lsr.w	#$6,d0		;shot accuracy adjust - divide by 64
	cmpi.w	#$FA,d3		;250 pixels straight line distance
	bhi.w	.chkvalue		;branch if higher
	lsr.w	#$1,d0		;extra shot accuracy adjust
.chkvalue	cmpi.w	#$88,d0		;compare to $88 (max adj value in X)
	blt.w	.cont3
	move.w	#$88,d0
.cont3	move.w	d0,-(sp)		;push adjusting value: 2(sp) / 4(sp) = x / y diff pushed before
	bsr.w	X_1C044		;RNG adj value
	add.w	d0,$2(sp)		;add result to x diff
	move.w	(sp),d0		;move adjusting value into d0
	cmpi.w	#$3C,d0		;compare to $3C (max adjustment in Y)
	bls.w	.lessx		;branch if less
	moveq	#$3C,d0
	move.w	d0,(sp)
.lessx	tst.w	$4(sp)
	bpl.w	.ycalc
	lsr.w	#$1,d0
.ycalc	bsr.w	X_1C044		;RNG adjustment
	add.w	d0,$4(sp)		;add to y diff
	move.w	(sp)+,d0		;pop adj value
	lsr.w	#$1,d0		;divide by 2
	bsr.w	X_1C050		;RNG result
	add.w	d0,$4(sp)		;add to Z diff
.perf	move.w	(passspeed).l,d2		;shot speed
	muls.w	#$44,d2		;1024/15
	muls.w	(sp)+,d2		;mult by x dist
	divs.w	d3,d2		;divide d2 by straight line distance
	move.w	d2,(puckvx).l		;move into puckvx
	move.w	(passspeed).l,d2
	muls.w	#$44,d2		;1024/15
	muls.w	(sp)+,d2		;mult by y dist
	divs.w	d3,d2		;divide d2 by straight line distance
	move.w	d2,(puckvy).l		;move into puckvy
	move.w	#$8000,d1		;this is the highest negative puckvy possible
	btst	#$7,$62(a3)		;check direction of shooting net
	beq.w	.2		;branch if bottom goal
	clr.w	d1
.2	eor.w	d2,d1		;EOR - checking to see if exceeding maximum puckvy
	bpl.w	.3		;branch if positive
	move.w	#$3810,(puckvy).l		;move into puckvy
	btst	#$7,$62(a3)		;check net shooting on
	bne.w	.3		;branch if top
	move.w	#$C7F0,(puckvy).l		;move into puckvy (shooting on bottom net)
.3	move.w	(sp)+,d1		;pix height in goal
	beq.w	.ex		;exit if zero
	mulu.w	(passspeed).l,d1
	mulu.w	#$44,d1		;1024/15
	divu.w	d3,d1		;by d3 = distance in pix to goal
	mulu.w	#$B33,d3		;(1024*42)/15
	divu.w	(passspeed).l,d3		;divide by passspeed
	add.w	d1,d3
	cmpi.w	#$1800,d3
	bls.w	.noup		;branch if less than
	move.w	#$1800,d3		;set max puckvz
.noup	move.w	d3,(puckvz).l		;move into puckvz
	bclr	#$4,$17F74.l		;check in-close top shelf bit
	beq.w	.ex		;if bit was cleared, exit
	btst	#$3,$64(a3)		;check if one timer
	bne.w	.ex		;branch if so
	jsr	(puckvzadj).l		;adjust puckvz for top shelf shot
.ex	bsr.w	sfx-LOAD		;play the shot sound
	movem.l	(sp)+,d0-d7/a0-a3
	rts
	dc.w	$0000,$000C,$0010,$000C,$0010,$0006,$0010,$0000
	dc.w	$0000,$0000,$FFF0,$0000,$FFF0,$0006,$FFF0,$000C
	dc.w	$0000,$0006,$082B,$0003,$0064,$6600,$000C,$082B
	dc.w	$0003,$0062,$6600,$00D8,$7008,$7205,$207C,$0001
	dc.w	$7400,$082B,$0006,$0062,$6600,$0006,$D0FC,$0300
	dc.w	$D0FC,$0080,$4A68,$0034,$57C9,$FFF6,$6600,$008C
	dc.w	$1028,$0028,$4880,$E240,$D068,$0000,$9079,$0001
	dc.w	$7B80,$1228,$002A,$4881,$E241,$D268,$0014,$9279
	dc.w	$0001,$7B94,$48A7,$C000,$C1C0,$C3C1,$D081,$5280
	dc.w	$6100,$5844,$3400,$4C9F,$0003,$7612,$383C,$0108
	dc.w	$082B,$0007,$0062,$6600,$0004,$4444,$48A7,$1800
	dc.w	$6100,$005E,$3A04,$4C9F,$0018,$4443,$6100,$0052
	dc.w	$D845,$4240,$0C44,$002C,$6E00,$0020,$0C44,$FFD4
	dc.w	$6D00,$0018,$082B,$0007,$0062,$6700,$0004,$4444
	dc.w	$7002,$4A44,$6A00,$0004,$7006,$33C0,$0001,$7E2C
	dc.w	$0839,$0002,$0001,$7F70,$6600,$000E,$0839,$0000
	dc.w	$0001,$7F78,$6700,$0008,$4EB9,$0002,$A648,$4E75
	dc.w	$9679,$0001,$7B80,$9879,$0001,$7B94,$C9C0,$C7C1
	dc.w	$9883,$89C2,$4E75
setpads						;Put SCnum of a3 in the d4 nibble of PadControlBits ; d4 = -2 puck
									;carrier, 0 / 2 pads, 4 replay target. Falls into rtss3
	movem.l	d0-d1,-(sp)
	moveq	#$2,d0
	add.w	d4,d0
	add.w	d0,d0
	move.w	#$FFF0,d1
	rol.w	d0,d1
	and.w	d1,(PadControlBits).l
	move.w	$52(a3),d1
	asl.w	d0,d1
	or.w	d1,(PadControlBits).l
	movem.l	(sp)+,d0-d1
	dc.w	$4E75,$0839,$0002,$0001,$7F70,$6600,$FFF4,$082B
	dc.w	$0003,$0062,$6600,$FFEA,$082B,$0004,$0063,$6600
	dc.w	$FFE0,$4A2B,$0060,$6A00,$000A,$4A2B,$0061,$6B00
	dc.w	$FFD0,$102B,$0061,$B02B,$0066,$6700,$0032,$302B
	dc.w	$0036,$0C33,$000B,$0038,$6700,$FFB6,$302B,$0052
	dc.w	$B079,$0001,$7BE0,$6700,$FFA8,$DEFC,$0004,$08EB
	dc.w	$0002,$0063,$426B,$0040,$700B,$6000,$4974,$DEFC
	dc.w	$0004,$08AB,$0002,$0063,$08AB,$0002,$0062,$50EB
	dc.w	$0061,$50EB,$0060,$302B,$0034,$4A2B,$0060,$6A00
	dc.w	$0008,$4EF9,$0003,$D754,$102B,$0060,$4880,$3740
	dc.w	$0034,$4EF9,$0003,$D754,$082B,$0005,$0062,$6600
	dc.w	$FF50,$0C6B,$0064,$0040,$6700,$00FA,$6100,$FF44
	dc.w	$082B,$0004,$0063,$6600,$48F8,$08AB,$0001,$0062
	dc.w	$6700,$002E,$377C,$0008,$0042,$7050,$082B,$0006
	dc.w	$0062,$6600,$0004,$4440,$3740,$0046,$377C,$0088
	dc.w	$0044,$446B,$0044,$046B,$0008,$0044,$426B,$0040
	dc.w	$102B,$0061,$B02B,$0066,$6700,$00FA,$9F6B,$0040
	dc.w	$6A00,$00D6,$066B,$0008,$0040,$302B,$0014,$906B
	dc.w	$0046,$0C40,$0028,$6E00,$00C0,$0C40,$FFD8,$6D00
	dc.w	$00B8,$302B,$0000,$906B,$0044,$0C40,$0020,$6E00
	dc.w	$00A8,$323C,$050C,$4A6B,$0034,$6600,$0006,$323C
	dc.w	$0002,$6100,$4968,$08EB,$0002,$0062,$0C6B,$0004
	dc.w	$0054,$6700,$000E,$066B,$0001,$0054,$026B,$0007
	dc.w	$0054,$426B,$002A,$377C,$F800,$0028,$0C40,$0010
	dc.w	$6E00,$0030,$426B,$0028,$0C6B,$0004,$0054,$6600
	dc.w	$0022,$377C,$F800,$0028,$377C,$0002,$0054,$323C
	dc.w	$0FAC,$6100,$4918,$08EB,$0005,$0062,$377C,$0064
	dc.w	$0040,$4E75,$426B,$0006,$4240,$102B,$0066,$D040
	dc.w	$207C,$0001,$834C,$082B,$0006,$0062,$6700,$0006
	dc.w	$D0FC,$0366,$31BC,$FFFE,$0068,$162B,$0061,$6100
	dc.w	$002A,$4EF9,$0003,$D770,$082B,$0002,$0062,$6600
	dc.w	$FFC2,$302B,$0044,$322B,$0046,$207C,$0003,$3C6E
	dc.w	$6000,$4502,$08AB,$0002,$0063,$102B,$0060,$4880
	dc.w	$3740,$0034,$4EB9,$0003,$D754,$50EB,$0061,$50EB
	dc.w	$0060,$4E75,$082B,$0005,$0062,$6600,$FF86,$08AB
	dc.w	$0001,$0062,$6700,$0040,$426B,$0028,$426B,$002A
	dc.w	$302B,$0052,$0440,$0006,$6B00,$0006,$0640,$0001
	dc.w	$C1FC,$000E,$3740,$0014,$377C,$0088,$0000,$446B
	dc.w	$0000,$377C,$0002,$0054,$08EB,$0005,$0062,$323C
	dc.w	$0F6E,$6000,$4848,$377C,$0004,$0054,$08AB,$0002
	dc.w	$0062,$08AB,$0005,$0063,$08AB,$0002,$0063,$426B
	dc.w	$0058,$377C,$1000,$0028,$6000,$4726,$082B,$0005
	dc.w	$0062,$6600,$FF0E,$08AB,$0001,$0062,$6700,$005C
	dc.w	$08EB,$0002,$0063,$6100,$0106,$78FE,$6100,$FD1C
	dc.w	$377C,$0008,$0042,$700B,$1239,$0001,$8068,$082B
	dc.w	$0006,$0062,$6600,$0006,$E849,$4440,$0241,$000F
	dc.w	$0C41,$0002,$6300,$0004,$7202,$5641,$C3C0,$3741
	dc.w	$0046,$377C,$0088,$0044,$426B,$0040,$08EB,$0005
	dc.w	$0063,$426B,$004E,$426B,$0050,$302B,$0014,$906B
	dc.w	$0046,$0C40,$000C,$6E00,$0094,$0C40,$FFF4,$6D00
	dc.w	$008C,$302B,$0000,$906B,$0044,$0C40,$FFE8,$6D00
	dc.w	$007C,$9F6B,$0040,$6A00,$FE7A,$066B,$0008,$0040
	dc.w	$08EB,$0002,$0062,$323C,$050C,$6100,$4770,$7406
	dc.w	$4A2B,$0076,$6700,$0004,$7402,$B46B,$0054,$6700
	dc.w	$000E,$066B,$0001,$0054,$026B,$0007,$0054,$426B
	dc.w	$002A,$377C,$1000,$0028,$0C40,$FFF8,$6D00,$FE34
	dc.w	$426B,$0028,$B46B,$0054,$6600,$FE28,$08EB,$0005
	dc.w	$0062,$377C,$0002,$0054,$323C,$0F6E,$6100,$471E
	dc.w	$08AB,$0004,$0063,$700D,$6000,$4636,$302B,$0044
	dc.w	$322B,$0046,$207C,$0003,$1AB6,$6000,$4348,$082B
	dc.w	$0003,$0062,$6700,$FDEC,$4244,$302B,$0052,$B079
	dc.w	$0001,$7F9E,$6700,$F5CA,$7802,$6000,$F5C4
assdopen						;add player a3 to penalty box
	btst	#$5,$62(a3)
	bne.w	X_16AB6
	moveq	#$10,d0
	btst	#$6,$62(a3)
	beq.w	.1
	moveq	#$1,d0
.1	add.b	d0,(PBnum).l		;Players in penalty box
	st.b	$34(a3)
	clr.w	$6(a3)
	rts
	dc.w	$082B,$0005,$0062,$6600,$FDA4,$08AB,$0001,$0062
	dc.w	$6700,$0052,$08EB,$0002,$0062,$08EB,$0002,$0063
	dc.w	$7010,$72C4,$082B,$0006,$0062,$6700,$0006,$7001
	dc.w	$4441,$9139,$0001,$8068,$3741,$0014,$426B,$0028
	dc.w	$426B,$002A,$377C,$0086,$0000,$377C,$0002,$0054
	dc.w	$08EB,$0005,$0062,$323C,$0FAC,$6100,$465A,$4EF9
	dc.w	$0003,$F03E,$377C,$0004,$0054,$50EB,$0061,$50EB
	dc.w	$0060,$08AB,$0003,$0062,$08AB,$0002,$0062,$08AB
	dc.w	$0005,$0063,$08AB,$0002,$0063,$377C,$F000,$0028
	dc.w	$6000,$4528
assgoaliebreakwait						;asstab entry. In a shootout or penalty shot park the idle goalie off the
									;ice, else exit
	btst	#$5,$62(a3)		;check if animation locked
	bne.w	.exit		;exit if so
	btst	#$2,$17F70.l		;check if pen shot
	bne.w	.park		;branch if so
	btst	#$0,$17F78.l		;check for shootout
	bne.w	.park		;branch if so
	nop
	bra.w	X_1B2C4
.park	clr.w	$28(a3)		;clear Xvel
	clr.w	$2A(a3)		;clear Yvel
	movem.l	d0/a0,-(sp)		;push d0 and a0 on stack
	movea.l	#SortCords,a0		;Home SC Sctruct start
	move.w	(BA_Goalie_SCnum).l,d0		;move Goalie SCNum into d0
	asl.w	#$7,d0		;shift d0 7 bits left
	adda.w	d0,a0		;add d0 to address a0
	move.w	#$191,$14(a3)		;move 401 decimal into Ypos
	btst	#$7,$62(a0)		;check if shooting up or down (a0 is goalie being shot on)
	bne.w	.popstack		;branch if shooting up
	move.w	#$FE6F,$14(a3)		;move -191 decimal into Ypos (goalie not being shot on)
.popstack	movem.l	(sp)+,d0/a0
.exit	rts
	dc.w	$082B,$0005,$0062,$6600,$000E,$0839,$0000,$0001
	dc.w	$7F6C,$6700,$44B2,$4E75
