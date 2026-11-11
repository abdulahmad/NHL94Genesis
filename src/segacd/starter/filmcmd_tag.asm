;	STARTER.BIN $4DCA-$4DDD (runtime $FDCA-$FDDD).
;
;	The SendCommandToMain name tag after filmcmd.asm.


	org	$FDCA

	dc.b	$91,'SendCommandToMain',0,0
