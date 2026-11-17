	include	segacd\hockey.inc
	include	macros\genesis.mac

AppendUserName	equ	$25DE8
CopyString	equ	$25818
LOAD	equ	$1B000
M68K_RAM	equ	$C45C
PlayerCardScreen	equ	$24C1E
RecByTxt	equ	$2595C
RecVsTxt	equ	$25994
ResetCardTimer	equ	$24B5E
TempBuffer	equ	$17E70
appstring	equ	$39208
move	equ	$2C9C8
setuphome	equ	$1938C
setupvis	equ	$1938E
sflags6	equ	$17F76
swap	equ	$2779A
X_7534	equ	$7534
X_A9E2	equ	$A9E2

	org	$9B7C

PlayerCardTimer						;Player cards, called each frame from ReadSetupPads in the first minute of
									;its wait. When carddelay runs out set setupcardflags bit 0; then count
									;cardtimer down (C skips $50); at $52 switch sides (bit 1), forget the
									;logos and draw the next card (PlayerCardScreen); below 0 restart the
									;timer (ResetCardTimer)
	subi.w	#$1,$193A2.l		;count down the start delay
	bpl.w	.x
	move.w	#$FFFF,$193A2.l		;keep it run out
	bset	#$0,$19390.l		;first run out: the cards may start
	btst	#$0,$19390.l		;cards allowed?
	beq.w	.x
	btst	#$5,$19390.l		;C held?
	beq.w	.0
	cmpi.w	#$52,$1939E.l		;timer below $52?
	bge.w	.0
	subi.w	#$50,$1939E.l		;skip $50 of the wait
.0	subi.w	#$1,$1939E.l
	bmi.w	.1		;timer ran out: start the next cycle
	cmpi.w	#$52,$1939E.l
	bne.w	.x		;only at $52 is a new card drawn
	bclr	#$2,$19390.l		;clear setupcardflags bits 2 and 3
	bclr	#$3,$19390.l
	bchg	#$1,$19390.l		;the next card goes on the other side
	st.b	(setuphome).l		;force the logo boxes to be redrawn later
	st.b	(setupvis).l
	bclr	#$6,$19390.l		;clear setupcardflags bits 6 and 7
	bclr	#$7,$19390.l
	jsr	(PlayerCardScreen).l
.x	rts
.1	jmp	(ResetCardTimer).l
	dc.w	$48E7,$FFFE,$4EB9,$0003,$8F6E,$0006,$FF00,$0000
	dc.w	$33FC,$001C,$0001,$8D58,$0839,$0001,$0001,$9390
	dc.w	$6600,$000A,$33FC,$0003,$0001,$8D58,$33FC,$0005
	dc.w	$0001,$8D5A,$303C,$0008,$323C,$0008,$343C,$07FF
	dc.w	$4EB9,$0003,$8C06,$4EB9,$0003,$8F6E,$0006,$FF00
	dc.w	$0000,$33FC,$0003,$0001,$8D58,$0839,$0001,$0001
	dc.w	$9390,$6600,$000A,$33FC,$000B,$0001,$8D58,$33FC
	dc.w	$0005,$0001,$8D5A,$303C,$0019,$323C,$0008,$343C
	dc.w	$07FF,$4EB9,$0003,$8C06,$0839,$0001,$0001,$9390
	dc.w	$6600,$000A,$6100,$FE22,$6000,$000E,$6100,$FE3E
	dc.w	$0679,$0001,$0001,$93A0,$4EB9,$0003,$8F6E,$0006
	dc.w	$FF00,$0000,$0C79,$0006,$0001,$93A0,$6D00,$0008
	dc.w	$4279,$0001,$93A0,$3039,$0001,$7FAE,$33FC,$001D
	dc.w	$0001,$8D58,$0839,$0001,$0001,$9390,$6700,$0010
	dc.w	$3039,$0001,$7FB0,$33FC,$0004,$0001,$8D58,$33FC
	dc.w	$0006,$0001,$8D5A,$3839,$0001,$9392,$3639,$0001
	dc.w	$93A0,$C6FC,$0006,$E540,$2079,$0004,$7D88,$2070
	dc.w	$0000,$33F0,$3004,$0001,$9396,$2070,$3000,$2248
	dc.w	$2448,$D1DA,$207C,$0004,$28A0,$D1D0,$4A92,$6600
	dc.w	$0012,$227C,$0004,$28A0,$D3E9,$0004,$4A9A,$6000
	dc.w	$0004,$D3DA,$6100,$5B9E,$247C,$0001,$A8C0,$3639
	dc.w	$0001,$7474,$B679,$0001,$7474,$6700,$FFF8,$363C
	dc.w	$0006,$343C,$0006,$4240,$4241,$2F39,$000B,$BCD2
	dc.w	$2F39,$000B,$BCD6,$3A3C,$0002,$4EB9,$0003,$87E2
	dc.w	$23DF,$000B,$BCD6,$23DF,$000B,$BCD2,$4EB9,$0003
	dc.w	$8F6E,$0006,$BF00,$0000,$33FC,$6000,$0001,$8D5C
	dc.w	$33FC,$0003,$0001,$8D58,$303C,$0019,$0839,$0001
	dc.w	$0001,$9390,$6700,$000E,$33FC,$000B,$0001,$8D58
	dc.w	$303C,$0019,$33FC,$0005,$0001,$8D5A,$323C,$0008
	dc.w	$33F9,$0001,$8D58,$0001,$93A4,$0679,$0001,$0001
	dc.w	$93A4,$33F9,$0001,$8D5A,$0001,$93A6,$0679,$0001
	dc.w	$0001,$93A6,$4EB9,$0003,$8CA0,$33F9,$0001,$93A4
	dc.w	$0001,$8D58,$33F9,$0001,$93A6,$0001,$8D5A,$33FC
	dc.w	$0000,$0001,$8D5C,$33FC,$0000,$0001,$8D5E,$3039
	dc.w	$0001,$7FAE,$0839,$0001,$0001,$9390,$6700,$0008
	dc.w	$3039,$0001,$7FB0,$33C0,$0001,$93A8,$247C,$0001
	dc.w	$B00C,$E540,$2472,$0000,$D4EA,$0000,$3039,$0001
	dc.w	$9396,$6000,$0008,$D4D2,$D4FC,$0008,$51C8,$FFF8
	dc.w	$267C,$0001,$7EF2,$43EB,$0002,$36BC,$0006,$2F0A
	dc.w	$D4D2,$1012,$4880,$4EB9,$0004,$12A8,$377C,$2000
	dc.w	$0004,$225F,$4EB9,$0003,$9208,$224B,$08F9,$0003
	dc.w	$0001,$7F76,$4EB9,$0003,$8D9E,$08B9,$0003,$0001
	dc.w	$7F76,$227C,$0001,$7EF2,$3039,$0001,$93A8,$3239
	dc.w	$0001,$9396,$4A79,$0001,$93BA,$6B00,$00CC,$4EB9
	dc.w	$0002,$5760,$0C51,$0002,$6700,$00BE,$33F9,$0001
	dc.w	$93A4,$0001,$8D58,$0679,$0002,$0001,$8D5A,$08F9
	dc.w	$0003,$0001,$7F76,$4EB9,$0003,$8D9E,$08B9,$0003
	dc.w	$0001,$7F76,$227C,$0001,$7EF2,$3039,$0001,$93A8
	dc.w	$3239,$0001,$9396,$207C,$0000,$C45C,$4EB9,$0002
	dc.w	$591A,$33F9,$0001,$93A4,$0001,$8D58,$0C51,$0002
	dc.w	$6700,$0020,$0679,$0001,$0001,$8D5A,$08F9,$0003
	dc.w	$0001,$7F76,$4EB9,$0003,$8D9E,$08B9,$0003,$0001
	dc.w	$7F76,$227C,$0001,$7EF2,$3039,$0001,$93A8,$3239
	dc.w	$0001,$9396,$207C,$0000,$C45C,$4EB9,$0002,$5962
	dc.w	$33F9,$0001,$93A4,$0001,$8D58,$0679,$0001,$0001
	dc.w	$8D5A,$08F9,$0003,$0001,$7F76,$4EB9,$0003,$8D9E
	dc.w	$08B9,$0003,$0001,$7F76,$33FC,$0064,$0001,$8D62
	dc.w	$4CDF,$7FFF,$4E75,$4A6A,$0034,$6700,$0044,$48E7
	dc.w	$FF00,$342A,$0000,$362A,$0014,$33EA,$004A,$0001
	dc.w	$7CF4,$0679,$0017,$0001,$7CF4,$33EA,$004C,$0001
	dc.w	$7CF6,$0679,$0017,$0001,$7CF6,$48E7,$00FE,$C54B
	dc.w	$4EB9,$0002,$2FBE,$C54B,$4CDF,$7F00,$4CDF,$00FF
	dc.w	$4E75,$08B9,$0005,$0001,$7F76,$4A79,$0001,$7BE0
	dc.w	$6B00,$004E,$48E7,$8080,$207C,$0001,$7480,$3039
	dc.w	$0001,$7BE0,$EF40,$D0C0,$3028,$0014,$0828,$0007
	dc.w	$0062,$6600,$0004,$4440,$0C40,$0058,$6D00,$001E
	dc.w	$0C68,$0047,$0000,$6E00,$0014,$0C68,$FFB9,$0000
	dc.w	$6D00,$000A,$08F9,$0005,$0001,$7F76,$4CDF,$0101
	dc.w	$4E75,$0EEA,$0000,$0042,$0EEA,$0EEA,$0EEE,$0000
	dc.w	$0888,$0AAA,$0068,$008A,$00CE,$0260,$0040,$0664
	dc.w	$0E8E,$0EEA,$0EEA,$0EEA,$0000,$0042,$0EEE,$0000
	dc.w	$0888,$0AAA,$0068,$008A,$00CE,$0260,$0040,$0664
	dc.w	$0E8E,$0EE8,$0000,$008C,$0EE8,$0EE8,$0EEE,$0000
	dc.w	$0C8C,$008C,$0888,$0068,$0846,$0044,$0422,$08CE
	dc.w	$02AE,$0EE8,$0EE8,$0EE8,$0000,$008C,$0EEE,$0000
	dc.w	$0C8C,$008C,$0888,$0068,$0846,$0044,$0422,$08CE
	dc.w	$02AE,$0EE8,$0822,$008C,$0EE8,$0EE8,$0EEE,$0000
	dc.w	$0EC8,$048C,$0C88,$006C,$0866,$0268,$0224,$0620
	dc.w	$00CE,$0EE8,$0EE8,$0EE8,$0822,$008C,$0EEE,$0000
	dc.w	$0EC8,$048C,$0C88,$006C,$0866,$0268,$0224,$0620
	dc.w	$00CE,$0EE8,$0006,$008C,$0EE8,$0EE8,$0EEE,$0000
	dc.w	$08EE,$02CE,$02AE,$026E,$000C,$0EE8,$0EE8,$0EE8
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8,$0006,$008C,$0EEE,$0000
	dc.w	$08EE,$02CE,$02AE,$026E,$000C,$0EE8,$0EE8,$0EE8
	dc.w	$0EE8,$0EE8,$0000,$0006,$0EE8,$0EE8,$0EEE,$0000
	dc.w	$08EE,$0A8E,$04AC,$0A88,$046C,$0226,$0644,$022E
	dc.w	$0262,$0EE8,$0EE8,$0EE8,$0000,$0006,$0EEE,$0000
	dc.w	$08EE,$0A8E,$04AC,$0A88,$046C,$0226,$0644,$022E
	dc.w	$0262,$0EE8,$0000,$0042,$0EE8,$0EE8,$0EEE,$0000
	dc.w	$08AA,$0688,$0488,$0466,$0244,$0260,$0020,$0ACC
	dc.w	$0000,$0EE8,$0EE8,$0EE8,$0000,$0042,$0EEE,$0000
	dc.w	$08AA,$0688,$0488,$0466,$0244,$0260,$0020,$0ACC
	dc.w	$0000,$0EE8,$0006,$0006,$0EE8,$0EE8,$0EEE,$0000
	dc.w	$0C8E,$086E,$044E,$082E,$020E,$0EE8,$0EE8,$0EE8
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8,$0006,$0006,$0EEE,$0000
	dc.w	$0C8E,$086E,$044E,$082E,$020E,$0EE8,$0EE8,$0EE8
	dc.w	$0EE8,$0EE8,$0600,$004A,$0EE8,$0EE8,$0EEE,$0000
	dc.w	$0CEA,$0A8E,$08A8,$044E,$0488,$002E,$0440,$0400
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8,$0600,$004A,$0EEE,$0000
	dc.w	$0CEA,$0A8E,$08A8,$044E,$0488,$002E,$0440,$0400
	dc.w	$0EE8,$0EEA,$004A,$0600,$0EEA,$0EEA,$0EEE,$0000
	dc.w	$000A,$0004,$0046,$008E,$0CEE,$0466,$0442,$0EC6
	dc.w	$0200,$0EEA,$0EEA,$0EEA,$004A,$0600,$0EEE,$0000
	dc.w	$000A,$0004,$0046,$008E,$0CEE,$0466,$0442,$0EC6
	dc.w	$0200,$0EE8,$0042,$0822,$0EE8,$0EE8,$0EEE,$0000
	dc.w	$00E8,$04C4,$0A8A,$00A2,$0466,$0600,$0224,$0EE8
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8,$0042,$0822,$0EEE,$0000
	dc.w	$00E8,$04C4,$0A8A,$00A2,$0466,$0600,$0224,$0EE8
	dc.w	$0EE8,$0EE8,$0000,$0000,$0EE8,$0EE8,$0EEE,$0000
	dc.w	$0AAA,$0888,$0666,$0444,$0222,$0CCC,$0EE8,$0EE8
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8,$0000,$0000,$0EEE,$0000
	dc.w	$0AAA,$0888,$0666,$0444,$0222,$0CCC,$0EE8,$0EE8
	dc.w	$0EE8,$0EE8,$0600,$0006,$0EE8,$0EE8,$0EEE,$0000
	dc.w	$088E,$026E,$0C68,$002E,$0A24,$0EAA,$0EE8,$0EE8
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8,$0600,$0006,$0EEE,$0000
	dc.w	$088E,$026E,$0C68,$002E,$0A24,$0EAA,$0EE8,$0EE8
	dc.w	$0EE8,$0EE8,$0020,$0006,$0EE8,$0EE8,$0EEE,$0000
	dc.w	$0AAA,$000A,$0888,$000C,$0022,$0006,$0CCC,$0EE8
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8,$0020,$0006,$0EEE,$0000
	dc.w	$0AAA,$000A,$0888,$000C,$0022,$0006,$0CCC,$0EE8
	dc.w	$0EE8,$0EE8,$0822,$004A,$0EE8,$0EE8,$0EEE,$0000
	dc.w	$0AA8,$066E,$0864,$022C,$062A,$0008,$0622,$0222
	dc.w	$0A8E,$0EE8,$0EE8,$0EE8,$0822,$004A,$0EEE,$0000
	dc.w	$0AA8,$066E,$0864,$022C,$062A,$0008,$0622,$0222
	dc.w	$0A8E,$0EE8,$0600,$0006,$0EE8,$0EE8,$0EEE,$0000
	dc.w	$0AAA,$0C86,$002E,$0C60,$0844,$0444,$0840,$0008
	dc.w	$0EC8,$0EE8,$0EE8,$0EE8,$0600,$0006,$0EEE,$0000
	dc.w	$0AAA,$0C86,$002E,$0C60,$0844,$0444,$0840,$0008
	dc.w	$0EC8,$0EE8,$0006,$006A,$0EE8,$0EE8,$0EEE,$0000
	dc.w	$068A,$0688,$0466,$0244,$022C,$0228,$0008,$0AAA
	dc.w	$0004,$0EE8,$0EE8,$0EE8,$0006,$006A,$0EEE,$0000
	dc.w	$068A,$0688,$0466,$0244,$022C,$0228,$0008,$0AAA
	dc.w	$0004,$0EE8,$0000,$004A,$0EE8,$0EE8,$0EEE,$0000
	dc.w	$0CCC,$088E,$0AAA,$046E,$006E,$0888,$0666,$002E
	dc.w	$0444,$0EE8,$0EE8,$0EE8,$0000,$004A,$0EEE,$0000
	dc.w	$0CCC,$088E,$0AAA,$046E,$006E,$0888,$0666,$002E
	dc.w	$0444,$0EE8,$0000,$008C,$0EE8,$0EE8,$0EEE,$0000
	dc.w	$0AAA,$088A,$066A,$04EE,$0464,$0440,$02CE,$0244
	dc.w	$0AEE,$0EE8,$0EE8,$0EE8,$0000,$008C,$0EEE,$0000
	dc.w	$0AAA,$088A,$066A,$04EE,$0464,$0440,$02CE,$0244
	dc.w	$0AEE,$0EE8,$0600,$0006,$0EE8,$0EE8,$0EEE,$0000
	dc.w	$0C00,$000E,$0E44,$0ECE,$0E80,$088E,$0EE8,$0EE8
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8,$0600,$0006,$0EEE,$0000
	dc.w	$0C00,$000E,$0E44,$0ECE,$0E80,$088E,$0EE8,$0EE8
	dc.w	$0EE8,$0EE8,$0000,$0860,$0EE8,$0EE8,$0EEE,$0000
	dc.w	$0860,$0642,$0888,$0CA8,$0ACC,$02AE,$006E,$0048
	dc.w	$046A,$0EE8,$0EE8,$0EE8,$0000,$0860,$0EEE,$0000
	dc.w	$0860,$0642,$0888,$0CA8,$0ACC,$02AE,$006E,$0048
	dc.w	$046A,$0EE8,$0822,$006A,$0EE8,$0EE8,$0EEE,$0000
	dc.w	$0602,$024C,$0002,$0026,$0068,$0428,$086E,$0EE8
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8,$0822,$006A,$0EEE,$0000
	dc.w	$0602,$024C,$0002,$0026,$0068,$0428,$086E,$0EE8
	dc.w	$0EE8,$0EE8,$0000,$0600,$0EE8,$0EE8,$0EEE,$0000
	dc.w	$0C86,$0E84,$0A84,$0C44,$0822,$0E20,$0600,$0A00
	dc.w	$0EA8,$0EE8,$0EE8,$0EE8,$0000,$0600,$0EEE,$0000
	dc.w	$0C86,$0E84,$0A84,$0C44,$0822,$0E20,$0600,$0A00
	dc.w	$0EA8,$0EE8,$0600,$0600,$0EE8,$0EE8,$0EEE,$0000
	dc.w	$0ECA,$0AAA,$0C66,$0822,$0CCC,$0EE8,$0EE8,$0EE8
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8,$0600,$0600,$0EEE,$0000
	dc.w	$0ECA,$0AAA,$0C66,$0822,$0CCC,$0EE8,$0EE8,$0EE8
	dc.w	$0EE8,$0EE8,$0000,$008C,$0EE8,$0EE8,$0EEE,$0000
	dc.w	$00CE,$006A,$004E,$0028,$0022,$0020,$008E,$0888
	dc.w	$06CE,$0EE8,$0EE8,$0EE8,$0000,$008C,$0EEE,$0000
	dc.w	$00CE,$006A,$004E,$0028,$0022,$0020,$008E,$0888
	dc.w	$06CE,$0EE8,$0006,$0600,$0EE8,$0EE8,$0EEE,$0000
	dc.w	$022C,$0C86,$0EA8,$088E,$0842,$0EE8,$0EE8,$0EE8
	dc.w	$0EE8,$0EE8,$0EE8,$0EE8,$0006,$0600,$0EEE,$0000
	dc.w	$022C,$0C86,$0EA8,$088E,$0842,$0EE8,$0EE8,$0EE8
	dc.w	$0EE8,$0EE8,$0600,$0006,$0EE8,$0EE8,$0EEE,$0000
	dc.w	$022C,$0422,$0AAC,$0666,$0CAA,$0444,$066E,$08CE
	dc.w	$0226,$0EE8,$0EE8,$0EE8,$0600,$0006,$0EEE,$0000
	dc.w	$022C,$0422,$0AAC,$0666,$0CAA,$0444,$066E,$08CE
	dc.w	$0226,$0EE8,$0000,$004A,$0EE8,$0EE8,$0EEE,$0000
	dc.w	$0688,$0464,$0244,$0222,$004E,$000A,$0022,$0AAA
	dc.w	$0000,$0EE8,$0EE8,$0EE8,$0000,$004A,$0EEE,$0000
	dc.w	$0688,$0464,$0244,$0222,$004E,$000A,$0022,$0AAA
	dc.w	$0000,$0EE8,$0000,$004A,$0EE8,$0EE8,$0EEE,$0000
	dc.w	$0688,$0464,$0244,$0222,$004E,$000A,$0022,$0AAA
	dc.w	$0000,$0EE8,$0EE8,$0EE8,$0000,$004A,$0EEE,$0000
	dc.w	$0688,$0464,$0244,$0222,$004E,$000A,$0022,$0AAA
	dc.w	$0000,$48E7,$FF7E,$2F09,$2649,$227C,$0002,$57EE
	dc.w	$48E7,$C000,$6100,$00A4,$4CDF,$0003,$6100,$0124
	dc.w	$4A40,$6600,$000C,$225F,$32BC,$0002,$6000,$005C
	dc.w	$227C,$0001,$7E70,$33C0,$0001,$7E64,$6100,$0092
	dc.w	$2657,$227C,$0001,$7E70,$4EB9,$0003,$9208,$3039
	dc.w	$0001,$7E64,$227C,$0002,$5808,$0C40,$0001,$6600
	dc.w	$0008,$227C,$0002,$5810,$4A41,$6600,$0016,$227C
	dc.w	$0002,$57F8,$0C40,$0001,$6600,$0008,$227C,$0002
	dc.w	$5800,$265F,$4EB9,$0003,$9208,$4CDF,$7EFF,$4E75
	dc.w	$000A,$5265,$636F,$7264,$2000,$0008,$2067,$6F61
	dc.w	$6C73,$0008,$2067,$6F61,$6C00,$0008,$2073,$6176
	dc.w	$6573,$0008,$2073,$6176,$6500,$48E7,$8000,$3011
	dc.w	$0440,$0001,$16D9,$51C8,$FFFC,$4CDF,$0001,$4E75
AppendNumber						;Write d0 (0 ... 999, no leading zeros) as a String at a1, padded to an
									;even length
	movem.w	d0-d6/a0,-(sp)
	move.l	a1,-(sp)		;keep the String start
	move.w	d0,d6
	adda.l	#$2,a1		;leave room for the length word
	clr.w	d1
	ext.l	d0
	divu.w	#$64,d0		;hundreds digit
	tst.w	d0		;any hundreds?
	beq.w	.0		;no hundreds: no leading zero
	addi.w	#$30,d0
	move.b	d0,(a1)+
	addi.w	#$1,d1
.0	swap	d0
	ext.l	d0		;clear the high word
	divu.w	#$A,d0		;tens digit
	addi.w	#$30,d0
	cmpi.b	#$30,d0		;tens 0 is skipped only for values below 10
	bne.w	.1
	cmpi.w	#$A,d6		;below 10?
	blt.w	.2		;yes: no tens digit
.1	move.b	d0,(a1)+
	addi.w	#$1,d1
.2	swap	d0		;ones digit from the remainder
	addi.w	#$30,d0
	move.b	d0,(a1)+
	addi.w	#$1,d1
	btst	#$0,d1		;odd length: pad with a 0 byte so the String stays word aligned
	beq.w	.3		;even already
	move.b	#$0,(a1)+		;pad byte
	addi.w	#$1,d1
.3	movea.l	(sp)+,a0
	addi.w	#$2,d1		;length counts the 2-byte header
	move.w	d1,(a0)
	movem.w	(sp)+,d0-d6/a0
	rts
	dc.w	$48E7,$3FFE,$3F00,$247C,$0001,$B00C,$E540,$2472
	dc.w	$0000,$D4EA,$0000,$3001,$6000,$0008,$D4D2,$D4FC
	dc.w	$0008,$51C8,$FFF8,$3001,$321F,$3A00,$3801,$48C0
	dc.w	$207C,$0000,$C45C,$6100,$CC5C,$1010,$4880,$2A7C
	dc.w	$0001,$B00C,$E544,$2A75,$4000,$DAED,$000A,$3215
	dc.w	$48A7,$8000,$4240,$0640,$0001,$E941,$6600,$FFF8
	dc.w	$B045,$4C9F,$0001,$6E00,$0008,$4241,$6000,$0006
	dc.w	$323C,$0001,$4CDF,$7FFC,$4E75
PrintRecordHolder						;Record holder line: RecByTxt ("by") then the holder's user name
									;(AppendRecordHolder). An empty String when there is none
	movem.l	d0-d7/a1-a6,-(sp)
	move.l	a1,-(sp)		;keep the output start
	movea.l	a1,a3
	movea.l	#RecByTxt,a1
	movem.l	d0-d1,-(sp)		;save team and player
	bsr.w	CopyString-LOAD
	movem.l	(sp)+,d0-d1
	movea.l	#TempBuffer,a1		;holder name buffer
	bsr.w	AppendRecordHolder
	movea.l	(sp)+,a3
	cmpi.w	#$2,(a1)		;no holder name: give back an empty String
	bne.w	.0
	move.w	#$2,(a3)		;length 2 = empty String
	bra.w	.x
.0	jsr	(appstring).l		;append the name
.x	movem.l	(sp)+,d0-d7/a1-a6
	rts
	dc.w	$0006,$6279,$2000
PrintRecordVs						;Record line: RecVsTxt ("vs.") then the user name and the opponent team
									;(AppendRecordVs)
	movem.l	d0-d7/a1-a6,-(sp)
	move.l	a1,-(sp)		;keep the output start
	movea.l	a1,a3
	movea.l	#RecVsTxt,a1
	movem.l	d0-d1,-(sp)		;save team and player
	bsr.w	CopyString-LOAD
	movem.l	(sp)+,d0-d1
	movea.l	#TempBuffer,a1
	bsr.w	X_A9E2		;user name and opponent
	movea.l	(sp)+,a3
	jsr	(appstring).l
	movem.l	(sp)+,d0-d7/a1-a6
	rts
	dc.w	$0006,$7673,$2E20
AppendRecordHolder						;Append the user name of the record holder (byte 1 of record a0, or read
									;record d0 / d1 when a0 is 0) to a1 (AppendUserName)
	movem.l	d0-d7/a1-a2,-(sp)
	cmpa.l	#$0,a0
	bne.w	.0		;a record was passed in a0: use it
	movem.l	d0-d7/a1-a6,-(sp)
	move.w	d0,-(sp)		;swap d0 and d1
	move.w	d1,d0		;swap d0/d1 into ReadPlayerRecord's order: d0 player, d1 team
	move.w	(sp)+,d1
	ext.l	d1
	ext.l	d0
	movea.l	#M68K_RAM,a0
	bsr.w	X_7534
	movea.l	#M68K_RAM,a0		;a0 = the record
	movem.l	(sp)+,d0-d7/a1-a6
.0	move.b	$1(a0),d2
	ext.w	d2
	bset	#$7,(sflags6).l		;bit 7 of sflags6: AppendUserName uses the record name list
	bsr.w	AppendUserName-LOAD
	movem.l	(sp)+,d0-d7/a1-a2
	rts
