PlayerCardScreen
	movem.l	d0-d7/a0-a6,-(sp)
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1,$0,$0
	move.w	#$1C,(printx).l
	btst	#$1,$19390.l
	bne.w	L9C4A
	move.w	#$3,(printx).l
L9C4A	move.w	#$5,(printy).l
	move.w	#$8,d0
	move.w	#$8,d1
	move.w	#$7FF,d2
	dc.w	$4EB9,$0003,$8C06
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1,$0,$0
	move.w	#$3,(printx).l
	btst	#$1,$19390.l
	bne.w	L9C8C
	move.w	#$B,(printx).l
L9C8C	move.w	#$5,(printy).l
	move.w	#$19,d0
	move.w	#$8,d1
	move.w	#$7FF,d2
	dc.w	$4EB9,$0003,$8C06
	btst	#$1,$19390.l
	bne.w	L9CBA
	bsr.w	TeamLogoBitmapsEnd
	bra.w	L9CC6
L9CBA	bsr.w	Sub_24AFA
	addi.w	#$1,$193A0.l
L9CC6	jsr	(printz).l
	String	CC_Font1,$0,$0
	cmpi.w	#$6,$193A0.l
	blt.w	L9CE4
	clr.w	$193A0.l
L9CE4	move.w	(HomeTeam).l,d0
	move.w	#$1D,(printx).l
	btst	#$1,$19390.l
	beq.w	L9D0C
	move.w	(VisTeam).l,d0
	move.w	#$4,(printx).l
L9D0C	move.w	#$6,(printy).l
	move.w	(homepicchars).l,d4
	move.w	$193A0.l,d3
	mulu.w	#$6,d3
	asl.w	#$2,d0
	movea.l	$47D88.l,a0
	movea.l	(a0,d0.w),a0
	move.w	$4(a0,d3.w),$19396.l
	movea.l	(a0,d3.w),a0
	movea.l	a0,a1
	movea.l	a0,a2
	adda.l	(a2)+,a0
	movea.l	#PicturePalette,a0
	adda.l	(a0),a0
	tst.l	(a2)
	bne.w	L9D60
	movea.l	#PicturePalette,a1
	adda.l	$4(a1),a1
	tst.l	(a2)+
	bra.w	L9D62
L9D60	adda.l	(a2)+,a1
L9D62	bsr.w	UnpackPicture
	movea.l	#picturebuf,a2
	move.w	(ScoutSubStatus).l,d3
L9D72	cmp.w	(ScoutSubStatus).l,d3
	beq.w	L9D72
	move.w	#$6,d3
	move.w	#$6,d2
	clr.w	d0
	clr.w	d1
	move.l	$BBCD2.l,-(sp)
	move.l	$BBCD6.l,-(sp)
	move.w	#$2,d5
	dc.w	$4EB9,$0003,$87E2
	move.l	(sp)+,$BBCD6.l
	move.l	(sp)+,$BBCD2.l
	dc.w	$4EB9,$0003,$8F6E
	String	CC_Font1Pri,$0,$0
	move.w	#$6000,(printa).l
	move.w	#$3,(printx).l
	move.w	#$19,d0
	btst	#$1,$19390.l
	beq.w	L9DE2
	move.w	#$B,(printx).l
	move.w	#$19,d0
L9DE2	move.w	#$5,(printy).l
	move.w	#$8,d1
	move.w	(printx).l,$193A4.l
	addi.w	#$1,$193A4.l
	move.w	(printy).l,$193A6.l
	addi.w	#$1,$193A6.l
	dc.w	$4EB9,$0003,$8CA0
	move.w	$193A4.l,(printx).l
	move.w	$193A6.l,(printy).l
	move.w	#$0,(printa).l
	dc.w	$33FC,$0000,$0001,$8D5E
	move.w	(HomeTeam).l,d0
	btst	#$1,$19390.l
	beq.w	L9E54
	move.w	(VisTeam).l,d0
L9E54	move.w	d0,$193A8.l
	movea.l	#TeamList,a2
	asl.w	#$2,d0
	movea.l	(a2,d0.w),a2
	adda.w	$0(a2),a2
	move.w	$19396.l,d0
	bra.w	L9E7A
L9E74	adda.w	(a2),a2
	adda.w	#$8,a2
L9E7A	dbra	d0,L9E74
	movea.l	#mesarea,a3
	lea.l	$2(a3),a1
	move.w	#$6,(a3)
	move.l	a2,-(sp)
	adda.w	(a2),a2
	move.b	(a2),d0
	ext.w	d0
	dc.w	$4EB9,$0004,$12A8
	move.w	#$2000,$4(a3)
	movea.l	(sp)+,a1
	dc.w	$4EB9,$0003,$9208
	movea.l	a3,a1
	bset	#$3,(sflags6).l
	dc.w	$4EB9,$0003,$8D9E
	bclr	#$3,(sflags6).l
	movea.l	#mesarea,a1
	move.w	$193A8.l,d0
	move.w	$19396.l,d1
	dc.w	$4A79,$0001,$93BA
	bmi.w	L9FA6
	jsr	$25760.l
	cmpi.w	#$2,(a1)
	beq.w	L9FA6
	move.w	$193A4.l,(printx).l
	addi.w	#$2,(printy).l
	bset	#$3,(sflags6).l
	dc.w	$4EB9,$0003,$8D9E
	bclr	#$3,(sflags6).l
	movea.l	#mesarea,a1
	move.w	$193A8.l,d0
	move.w	$19396.l,d1
	dc.w	$207C,$0000,$C45C
	dc.w	$4EB9,$0002,$591A
	move.w	$193A4.l,(printx).l
	cmpi.w	#$2,(a1)
	beq.w	L9F60
	addi.w	#$1,(printy).l
	bset	#$3,(sflags6).l
	dc.w	$4EB9,$0003,$8D9E
	bclr	#$3,(sflags6).l
L9F60	movea.l	#mesarea,a1
	move.w	$193A8.l,d0
	move.w	$19396.l,d1
	dc.w	$207C,$0000,$C45C
	dc.w	$4EB9,$0002,$5962
	move.w	$193A4.l,(printx).l
	addi.w	#$1,(printy).l
	bset	#$3,(sflags6).l
	dc.w	$4EB9,$0003,$8D9E
	bclr	#$3,(sflags6).l
L9FA6	move.w	#$64,(palcount).l
	movem.l	(sp)+,d0-d7/a0-a6
	rts
	tst.w	$34(a2)
	beq.w	L9FFE
	movem.l	d0-d7,-(sp)
	move.w	$0(a2),d2
	move.w	$14(a2),d3
	dc.w	$33EA,$004A,$0001,$7CF4
	dc.w	$0679,$0017,$0001,$7CF4
	dc.w	$33EA,$004C,$0001,$7CF6
	dc.w	$0679,$0017,$0001,$7CF6
	movem.l	a0-a6,-(sp)
	exg.l	a2,a3
	jsr	(checkcornercoll).l
	exg.l	a2,a3
	movem.l	(sp)+,a0-a6
	movem.l	(sp)+,d0-d7
L9FFE	rts
	bclr	#$5,(sflags6).l
	tst.w	$17BE0.l
	bmi.w	LA05E
	movem.l	d0/a0,-(sp)
	dc.w	$207C,$0001,$7480
	move.w	$17BE0.l,d0
	asl.w	#$7,d0
	adda.w	d0,a0
	move.w	$14(a0),d0
	btst	#$7,$62(a0)
	bne.w	LA036
	neg.w	d0
LA036	cmpi.w	#$58,d0
	blt.w	LA05A
	cmpi.w	#$47,$0(a0)
	bgt.w	LA05A
	cmpi.w	#$FFB9,$0(a0)
	blt.w	LA05A
	bset	#$5,(sflags6).l
LA05A	movem.l	(sp)+,d0/a0
LA05E	rts
	incbin	..\Extracted\SegaCD\HOCKEY\hockey_0A060.bin
	movem.l	d0-d7/a1-a6,-(sp)
	move.l	a1,-(sp)
	movea.l	a1,a3
	movea.l	#$257EE,a1
	movem.l	d0-d1,-(sp)
	bsr.w	CopyString
	movem.l	(sp)+,d0-d1
	bsr.w	GetRecordValue
	tst.w	d0
	bne.w	LA78E
	movea.l	(sp)+,a1
	move.w	#$2,(a1)
	bra.w	LA7E8
LA78E	movea.l	#TempBuffer,a1
	dc.w	$33C0,$0001,$7E64
	bsr.w	AppendNumber
	movea.l	(sp),a3
	movea.l	#TempBuffer,a1
	dc.w	$4EB9,$0003,$9208
	dc.w	$3039,$0001,$7E64
	movea.l	#$25808,a1
	cmpi.w	#$1,d0
	bne.w	LA7C6
	movea.l	#$25810,a1
LA7C6	tst.w	d1
	bne.w	LA7E0
	movea.l	#$257F8,a1
	cmpi.w	#$1,d0
	bne.w	LA7E0
	movea.l	#$25800,a1
LA7E0	movea.l	(sp)+,a3
	dc.w	$4EB9,$0003,$9208
LA7E8	movem.l	(sp)+,d0-d7/a1-a6
	rts
	dc.w	$000A,$5265,$636F,$7264,$2000,$0008,$2067,$6F61
	dc.w	$6C73,$0008,$2067,$6F61,$6C00,$0008,$2073,$6176
	dc.w	$6573,$0008,$2073,$6176,$6500
CopyString
	movem.l	d0,-(sp)
	move.w	(a1),d0
	subi.w	#$1,d0
LA822	move.b	(a1)+,(a3)+
	dbra	d0,LA822
	movem.l	(sp)+,d0
	rts
AppendNumber
	movem.w	d0-d6/a0,-(sp)
	move.l	a1,-(sp)
	move.w	d0,d6
	adda.l	#$2,a1
	clr.w	d1
	ext.l	d0
	divu.w	#$64,d0
	tst.w	d0
	beq.w	LA854
	addi.w	#$30,d0
	move.b	d0,(a1)+
	addi.w	#$1,d1
LA854	swap	d0
	ext.l	d0
	divu.w	#$A,d0
	addi.w	#$30,d0
	cmpi.b	#$30,d0
	bne.w	LA870
	cmpi.w	#$A,d6
	blt.w	LA876
LA870	move.b	d0,(a1)+
	addi.w	#$1,d1
LA876	swap	d0
	addi.w	#$30,d0
	move.b	d0,(a1)+
	addi.w	#$1,d1
	btst	#$0,d1
	beq.w	LA892
	move.b	#$0,(a1)+
	addi.w	#$1,d1
LA892	movea.l	(sp)+,a0
	addi.w	#$2,d1
	move.w	d1,(a0)
	movem.w	(sp)+,d0-d6/a0
	rts
GetRecordValue
	movem.l	d2-d7/a0-a6,-(sp)
	move.w	d0,-(sp)
	movea.l	#TeamList,a2
	asl.w	#$2,d0
	movea.l	(a2,d0.w),a2
	adda.w	$0(a2),a2
	move.w	d1,d0
	bra.w	LA8C2
LA8BC	adda.w	(a2),a2
	adda.w	#$8,a2
LA8C2	dbra	d0,LA8BC
	move.w	d1,d0
	move.w	(sp)+,d1
	move.w	d0,d5
	move.w	d1,d4
	ext.l	d0
	dc.w	$207C,$0000,$C45C
	bsr.w	Sub_22534
	move.b	(a0),d0
	ext.w	d0
	movea.l	#TeamList,a5
	asl.w	#$2,d4
	movea.l	(a5,d4.w),a5
	adda.w	$A(a5),a5
	move.w	(a5),d1
	movem.w	d0,-(sp)
	clr.w	d0
LA8F6	addi.w	#$1,d0
	asl.w	#$4,d1
	bne.w	LA8F6
	cmp.w	d5,d0
	movem.w	(sp)+,d0
	bgt.w	LA910
	clr.w	d1
	bra.w	LA914
LA910	move.w	#$1,d1
LA914	movem.l	(sp)+,d2-d7/a0-a6
	rts
PrintRecordHolder
	movem.l	d0-d7/a1-a6,-(sp)
	move.l	a1,-(sp)
	movea.l	a1,a3
	movea.l	#$2595C,a1
	movem.l	d0-d1,-(sp)
	bsr.w	CopyString
	movem.l	(sp)+,d0-d1
	movea.l	#TempBuffer,a1
	bsr.w	AppendRecordHolder
	movea.l	(sp)+,a3
	cmpi.w	#$2,(a1)
	bne.w	LA950
	move.w	#$2,(a3)
	bra.w	LA956
LA950	jsr	(appstring).l
LA956	movem.l	(sp)+,d0-d7/a1-a6
	rts
	dc.w	$0006,$6279,$2000
PrintRecordVs
	movem.l	d0-d7/a1-a6,-(sp)
	move.l	a1,-(sp)
	movea.l	a1,a3
	movea.l	#$25994,a1
	movem.l	d0-d1,-(sp)
	bsr.w	CopyString
	movem.l	(sp)+,d0-d1
	movea.l	#TempBuffer,a1
	bsr.w	AppendRecordVs
	movea.l	(sp)+,a3
	dc.w	$4EB9,$0003,$9208
	movem.l	(sp)+,d0-d7/a1-a6
	rts
	dc.w	$0006,$7673,$2E20
AppendRecordHolder
	movem.l	d0-d7/a1-a2,-(sp)
	cmpa.l	#$0,a0
	bne.w	LA9CA
	movem.l	d0-d7/a1-a6,-(sp)
	move.w	d0,-(sp)
	move.w	d1,d0
	move.w	(sp)+,d1
	ext.l	d1
	ext.l	d0
	dc.w	$207C,$0000,$C45C
	bsr.w	Sub_22534
	dc.w	$207C,$0000,$C45C
	movem.l	(sp)+,d0-d7/a1-a6
LA9CA	move.b	$1(a0),d2
	ext.w	d2
	bset	#$7,(sflags6).l
	bsr.w	AppendUserName
	movem.l	(sp)+,d0-d7/a1-a2
	rts
AppendRecordVs
	movem.l	d0-d7/a0-a6,-(sp)
	cmpa.l	#$0,a0
	bne.w	LAA12
	movem.l	d0-d7/a1-a6,-(sp)
	move.w	d0,-(sp)
	move.w	d1,d0
	move.w	(sp)+,d1
	ext.l	d1
	ext.l	d0
	dc.w	$207C,$0000,$C45C
	bsr.w	Sub_22534
	dc.w	$207C,$0000,$C45C
	movem.l	(sp)+,d0-d7/a1-a6
LAA12	move.b	$3(a0),d2
	ext.w	d2
	movem.l	d0/a1,-(sp)
	bset	#$7,(sflags6).l
	bsr.w	AppendUserName
	movea.l	a1,a3
	dc.w	$227C,$0002,$5A4A
	dc.w	$4EB9,$0003,$9208
	movem.l	(sp)+,d0/a1
	move.b	$2(a0),d0
	dc.w	$4EB9,$0002,$60E0
	movem.l	(sp)+,d0-d7/a0-a6
	rts
