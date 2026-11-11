;	STARTER.BIN $4EC0-$4ECD (runtime $FEC0-$FECD).
;
;	The InitEngine name tag after filmbuf.asm.


	org	$FEC0

	dc.b	$8A,'InitEngine',0,0,0
