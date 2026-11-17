; Jumps to the handler for the command number in d0.
Z80CommandSwitch	tst.w	d0
	bne.b	.next
	bra.w	SndSlotsInit
.next	opt	oaq-
	opt	osq-
	subi.w	#$1,d0
	opt	oaq+
	opt	osq+
	bne.b	.next2
	bra.w	SndSlotsTickAll
.next2	opt	oaq-
	opt	osq-
	subi.w	#$1,d0
	opt	oaq+
	opt	osq+
	bne.b	.next3
	bra.w	SndSlotsSave
.next3	opt	oaq-
	opt	osq-
	subi.w	#$1,d0
	opt	oaq+
	opt	osq+
	bne.b	.next4
	bra.w	SndFindId
.next4	opt	oaq-
	opt	osq-
	subi.w	#$1,d0
	opt	oaq+
	opt	osq+
	bne.b	.next5
	bra.w	Z80UploadBlock
.next5	opt	oaq-
	opt	osq-
	subi.w	#$1,d0
	opt	oaq+
	opt	osq+
	bne.b	.next6
	bra.w	Z80ReadStatus
.next6	opt	oaq-
	opt	osq-
	subi.w	#$1,d0
	opt	oaq+
	opt	osq+
	bne.b	.next7
	bra.w	SndSetSource
.next7	opt	oaq-
	opt	osq-
	subi.w	#$1,d0
	opt	oaq+
	opt	osq+
	bne.b	.next8
	bra.w	SndScanToEnd
.next8	opt	oaq-
	opt	osq-
	subi.w	#$1,d0
	opt	oaq+
	opt	osq+
	bne.b	.next9
	bra.w	Z80LoadBank
.next9	opt	oaq-
	opt	osq-
	subi.w	#$1,d0
	opt	oaq+
	opt	osq+
	bne.b	.next10
	bra.w	Z80LoadSmall
.next10	move.w	#$1,d0
	ori.b	#$1,ccr
	rts
