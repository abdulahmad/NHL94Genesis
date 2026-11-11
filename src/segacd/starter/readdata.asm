;	STARTER.BIN $5068-$508B (runtime $10068-$1008B).
;
;	ReadData (between GetData in subheap.asm and the audio stream in audiostream.asm).


	org	$10068

ReadData
	link	a6,#$0
	move.l	$10(a6),d0
	add.l	$C(a6),d0
	movea.l	$8(a6),a0
	move.l	d0,$C(a0)
	unlk	a6
	rts
	dc.b	$88,'ReadData',0,0,0
