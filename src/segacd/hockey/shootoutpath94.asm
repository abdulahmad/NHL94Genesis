;	HOCKEY.BIN $F58C-$F901 (runtime $2A58C-$2A901): shootoutpath94.asm as the disc has it.
;	The cartridge source with long addresses and no short or quick forms. Lines under ;CD: have
;	no cartridge twin. Names are the cartridge's; segacd\hockey\hockey.inc has the disc RAM map.
;
;	Saved lines and the shootout skate paths are the cartridge code. The saved lines sit at $E20
;	in the backup RAM image (LineDataBase; the cartridge save RAM has them at $1EF6).

	include	macros\genesis.mac
	include	segacd\hockey\hockey.inc

ReadSRAM	equ	$22452
WriteSRAM	equ	$2246C
randomd0	equ	$37050

	org	$2A58C

;	Saved line data, win records, and the shootout skate paths. New in 94.
;	ROM-contiguous from ReadLineData through ShootoutShootCheck. The shootout
;	UI (mode box, count, won-by) is shootout94.asm earlier in the ROM.

ReadLineData						;Read the $100 bytes at save RAM LineDataBase to databuffer; sflags bit 4
									;cleared, lastsfx = -1, recbpr = $FFFF0000. Called from Begin and
									;GameSetUp
	movem.l	d0-d1/a0,-(sp)
	move.l	#$100,d1				;all $100 bytes of line data
	move.l	#LineDataBase,d0
	movea.l	#databuffer,a0
	jsr	(ReadSRAM).l
	bclr.b	#sfwrap,(sflags).l		;the SRAM routines leave these set: reset them
	move.w	#$FFFF,(lastsfx).l
	move.l	#$C45C,(recbpr).l		;CD: the cartridge has #M68K_RAM
	movem.l	(sp)+,d0-d1/a0
	rts
WriteLineData						;Write databuffer back to save RAM at LineDataBase (WriteSRAM,
									;MakeSRAMChecksum); as ReadLineData after. Called from EncodePW and
									;EncodeTeamLines
	movem.l	d0-d1/a0,-(sp)
	move.l	#$100,d1
	move.l	#LineDataBase,d0
	movea.l	#databuffer,a0
	jsr	(WriteSRAM).l
	bclr.b	#sfwrap,(sflags).l
	move.w	#$FFFF,(lastsfx).l
	move.l	#$C45C,(recbpr).l		;CD: the cartridge has #M68K_RAM
	movem.l	(sp)+,d0-d1/a0
	rts
ClearWinRecords						;Clear bytes 8-$B of the 8 ThreeStars records and write the $80 bytes at
									;TeamRecBase (WriteSRAM, MakeSRAMChecksum). Called from
									;RecordHoldersScreen
									;(Record Holders)
	movem.l	d0-d7/a0-a6,-(sp)
	movea.l	#recordbuf,a0
	move.w	#7,d7					;8 user record blocks
.loop								;clear the wins and games of each
	clr.b	urwins(a0)
	clr.b	urwins+1(a0)
	clr.b	urgames(a0)
	clr.b	urgames+1(a0)
	adda.w	#$10,a0					;16 bytes per block
	dbf	d7,.loop
	move.l	#TeamRecBase,d0			;write all $80 bytes back
	move.l	#$80,d1
	movea.l	#recordbuf,a0
	jsr	(WriteSRAM).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
PSandSOpassdir						;Penalty shot / shootout: passdir = sopathdir (the end of the skate path,
									;NextPathPoint), turned by passdirlist for the bottom net. Called from
									;shotdiradj
	movem.l	d0-d7/a0-a6,-(sp)
	move.w	(sopathdir).l,d0
	btst.b	#pfgoal,pflags(a3)		;check what net shooting at
	bne.w	.0						;top net: the direction is already right
	movea.l	#passdirlist,a0			;bottom net: use the mirrored direction
	add.w	d0,d0
	move.w	(a0,d0.w),d0			;mirrored
.0									;direction ready
	move.w	d0,(passdir).l			;move d0 into passdir
	movem.l	(sp)+,d0-d7/a0-a6
	rts
passdirlist	dc.w	0				;PSandSOpassdir: passdir for the other net
	dc.w	7
	dc.w	6
	dc.w	5
	dc.w	4
	dc.w	3
	dc.w	2
	dc.w	1
	dc.w	8
StartShootoutPath					;Shootout: pick one of the 7 skate paths (ShootoutPaths) at random
									;(sopath) and start it (NextPathPoint). Called from NextShooter and
									;puckshootout
	movem.l	d0-d7/a0-a6,-(sp)
.loop								;random 0-6
	move.w	#7,d0					;random 0-7
	jsr	(randomd0).l
	cmpi.w	#6,d0
	bgt.w	.loop					;7 is out of range: pick again
	move.w	d0,(sopath).l
	bclr.b	#3,(sflags7).l			;not at the path end yet
	move.w	#$FFFF,(sopathpoint).l	;the first NextPathPoint call takes point 0
	clr.w	(sopathx).l
	bsr.w	NextPathPoint
	movem.l	(sp)+,d0-d7/a0-a6
	rts
ShootoutPaths						;The 7 shootout skate paths (NextPathPoint)
	dc.l	ShootoutPath1
	dc.l	ShootoutPath2
	dc.l	ShootoutPath3
	dc.l	ShootoutPath4
	dc.l	ShootoutPath5
	dc.l	ShootoutPath6
	dc.l	ShootoutPath7
ShootoutPath1						;ShootoutPaths path: x, y points; $80 in the high byte ends it (low byte:
									;sopathend, then sopathdir)
	dc.w	$10,$E2,$10,$D0,$8020,5
ShootoutPath2						;ShootoutPaths path: x, y points; $80 in the high byte ends it (low byte:
									;sopathend, then sopathdir)
	dc.w	$FFC9,$A0,$FFFF,$C8,$FFE0,$D0,$8020,5
ShootoutPath3						;ShootoutPaths path: x, y points; $80 in the high byte ends it (low byte:
									;sopathend, then sopathdir)
	dc.w	$FFB0,$40,$1A,$BC,$8020,5
ShootoutPath4						;ShootoutPaths path: x, y points; $80 in the high byte ends it (low byte:
									;sopathend, then sopathdir)
	dc.w	$FFCE,$58,$14,$D0,$802C,5
ShootoutPath5						;ShootoutPaths path: x, y points; $80 in the high byte ends it (low byte:
									;sopathend, then sopathdir)
	dc.w	$FFCE,8,$20,$D0,$8028,6
ShootoutPath6						;ShootoutPaths path: x, y points; $80 in the high byte ends it (low byte:
									;sopathend, then sopathdir)
	dc.w	$1C,$F4,8,$E0,$8020,6
ShootoutPath7						;ShootoutPaths path: x, y points; $80 in the high byte ends it (low byte:
									;sopathend, then sopathdir)
	dc.w	$FFE6,$F8,0,$E0,$8020,2
NextPathPoint						;Next point of shootout path sopath: sopathx / sopathy = x (turned by bit
									;0 of handed(a3)) / y; at the end ($80) sflags7 bit 3, sopathend and
									;sopathdir
	movem.l	d0-d7/a0-a6,-(sp)
	cmpi.b	#$80,(sopathx).l		;path already ended: keep the last point
	beq.w	.x
	addi.w	#1,(sopathpoint).l
	move.w	(sopathpoint).l,d0
	asl.w	#2,d0					;4 bytes per point
	movea.l	#ShootoutPaths,a0
	move.w	(sopath).l,d1
	asl.w	#2,d1					;4 bytes per path address
	movea.l	(a0,d1.w),a0			;its points
	move.w	(a0,d0.w),(sopathx).l	;point X
	btst.b	#0,handed(a3)			;left handed: mirror the path
	beq.w	.0
	neg.w	(sopathx).l
.0									;point X ready
	move.w	$2(a0,d0.w),(sopathy).l	;point Y
	cmpi.b	#$80,$4(a0,d0.w)		;next entry not the end marker: done
	bne.w	.x
	bset.b	#3,(sflags7).l			;end reached: flag it and keep the end values
	clr.w	(sopathend).l
	move.b	$5(a0,d0.w),(sopathend+1).l	;end distance
	move.w	$6(a0,d0.w),(sopathdir).l	;end pass direction
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a6
	rts
SkatePath							;Shootout skate path: d0 / d1 = the point (mirrored for the bottom net);
									;within $A of it ($12 while Xvel / Yvel(a3) are 0) take the next one
									;(NextPathPoint). Called from asspuckc
	movem.l	d2-d7/a0-a6,-(sp)
	cmpi.b	#$80,(sopathx).l		;path ended?
	beq.w	.x						;path ended: keep heading to the last point
	move.w	(sopathx).l,d0
	move.w	(sopathy).l,d1
	btst.b	#pfgoal,pflags(a3)		;top net?
	bne.w	.0						;top net: path as stored
	neg.w	d0
	neg.w	d1
.0									;point for this end of the ice
	sub.w	0(a3),d0				;minus the player X
	bpl.w	.1
	neg.w	d0
.1									;|dx| ready
	tst.w	Xvel(a3)				;moving?
	bne.w	.2						;moving: the closer limit
	tst.w	Yvel(a3)				;moving?
	bne.w	.2
	cmpi.w	#$12,d0					;standing: within $12 is close enough
	ble.w	.3						;close enough
.2									;moving: within $A
	cmpi.w	#$A,d0					;within $A?
	bgt.w	.7
.3									;close in X: check Y
	sub.w	Ypos(a3),d1				;minus the player Y
	bpl.w	.4
	neg.w	d1
.4									;|dy| ready
	tst.w	Xvel(a3)				;moving?
	bne.w	.5						;moving: the closer limit
	tst.w	Yvel(a3)				;moving?
	bne.w	.5
	cmpi.w	#$12,d1					;standing: within $12
	ble.w	.nextpt					;close enough
.5									;moving: within $A
	cmpi.w	#$A,d1					;within $A?
	bgt.w	.7
.nextpt								;close to the point: take the next one
	bsr.w	NextPathPoint
.7									;d0 / d1 = the point to skate to
	move.w	(sopathx).l,d0
	move.w	(sopathy).l,d1
.x									;exit: restore the registers
	movem.l	(sp)+,d2-d7/a0-a6
	rts
ShootoutShootCheck					;Shootout, skater a3 has the puck (gmode2 bit 1): Z set (d0 is restored) =
									;shoot now: after 3 (shootoutclock) at the path
									;end, within sopathend of its last point, or with the puck stopped before
									;$F. Called from asspuckc
	movem.l	d0-d7/a0-a6,-(sp)
	btst.b	#1,(gmode2).l			;shootout?
	beq.w	.yes					;not a shootout: shoot whenever
	move.w	SCnum(a3),d0
	cmp.w	(puckc).l,d0			;puck carrier?
	bne.w	.yes					;not the puck carrier: d0 = 1
	cmpi.w	#3,(shootoutclock).l	;past tick 3?
	ble.w	.no						;first 3 ticks: keep skating
	cmpi.b	#$80,(sopathx).l		;path ended?
	beq.w	.no						;path over: skate to the net, no shot yet
	btst.b	#3,(sflags7).l			;at the path end?
	bne.w	.0						;at the path end: check the distance
	tst.w	(puckvx).l				;puck moving?
	bne.w	.yes					;puck moving: shoot
	tst.w	(puckvy).l				;puck moving?
	bne.w	.yes
	cmpi.w	#$F,(shootoutclock).l	;puck stopped: shoot from tick $F
	blt.w	.no						;before tick $F
	bra.w	.yes
.0									;path end reached: compare the distance to the last point with sopathend
	move.w	(sopathx).l,d0
	move.w	(sopathy).l,d1
	btst.b	#pfgoal,pflags(a3)		;top net?
	bne.w	.1						;top net: point as stored
	neg.w	d0
	neg.w	d1
.1									;point for this end of the ice
	sub.w	0(a3),d0				;minus the player X
	bpl.w	.2
	neg.w	d0
.2									;|dx| ready
	sub.w	Ypos(a3),d1				;minus the player Y
	bpl.w	.3
	neg.w	d1
.3									;|dy| ready
	cmp.w	(sopathend).l,d0		;close enough in X?
	bgt.w	.yes					;farther than sopathend from the last point: d0 = 1
	cmp.w	(sopathend).l,d1		;close enough in Y?
	bgt.w	.yes
.no									;no shot: d0 = 0 (Z set)
	clr.w	d0
	bra.w	.x
.yes								;shoot: d0 = 1
	move.w	#1,d0					;shoot
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d7/a0-a6
	rts
