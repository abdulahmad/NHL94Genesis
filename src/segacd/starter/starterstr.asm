; Warning screen text.
StrWarningA	dc.b	'    WARNING!!   '	;     WARNING!!   
	dc.b	$20,$20,$00,'Backup ram is'	;   .Backup ram is
	dc.b	' NOT ',$00,'formatted.'	;  NOT .formatted.
	dc.b	' Do you ',$00,'want to'	;  Do you .want to
	dc.b	' format it?',$00,'    '	;  format it?.    
	dc.b	'              ',$00,$20	;               . 
	dc.b	'  YES     NO    '	;   YES     NO    
	dc.b	$20,$00,'              '	;  .              
	dc.b	'    ',$00,'Push C-butt'	;     .Push C-butt
	dc.b	'on to  ',$00,'confirm.'	; on to  .confirm.
	dc.b	'          ',$00,'     '	;           .     
	dc.b	'             ',$00	;              .
; 'FORMATTING...' text.
StrFormatting	dc.b	'FORMATTING',$00,$2E,$00,$2E,$00,$2E	; FORMATTING......
	dc.b	$00,$2E,$00	; ...
; Warning screen text.
StrWarningB	dc.b	'    WARNING!!   '	;     WARNING!!   
	dc.b	$20,$20,$00,'Not enough ro'	;   .Not enough ro
	dc.b	'om to',$00,'save game '	; om to.save game 
	dc.b	'status. ',$00,'To save'	; status. .To save
	dc.b	' status,   ',$00,'you '	;  status,   .you 
	dc.b	'must delete   ',$00,$6F	; must delete   .o
	dc.b	'ther game files '	; ther game files 
	dc.b	$20,$00,'in the control'	;  .in the control
	dc.b	'    ',$00,'panel scree'	;     .panel scree
	dc.b	'n.     ',$00,'        '	; n.     .        
	dc.b	'          ',$00,'Press'	;           .Press
	dc.b	' the C-button',$00,$69,$66	;  the C-button.if
	dc.b	' you want to    '	;  you want to    
	dc.b	$00,'continue.      '	; .continue.      
	dc.b	$20,$20,$20,$00,$00,$08,$08,$00,$18	;    ......
	dcb.b	$D,0
	dc.b	$03,$11,$11,$00,$02,$31,$11,$00,$02,$23,$00,$00,$02,$22,$00,$00	; .....1...#..."..
	dc.b	$02,$22	; ."
	dcb.b	$D,0
	dc.b	$11,$11,$11,$11,$11,$11,$11,$11	; ........
	dcb.b	$18,0
	dc.b	$11,$11,$11,$11,$11,$11,$11,$11	; ........
	dcb.b	$18,0
	dc.b	$11,$11,$11,$11,$11,$11,$11,$11	; ........
	dcb.b	$18,0
	dc.b	$11,$11,$30,$00,$11,$13,$20,$00,$00,$32,$20,$00,$00,$22,$20,$00	; ..0... ..2 .." .
	dc.b	$00,$22,$20,$00,$00,$02,$22,$00,$00,$02,$22,$00,$00,$02,$22,$00	; ." ..."..."...".
	dc.b	$00,$02,$22,$00,$00,$02,$22,$00,$00,$02,$22,$00,$00,$02,$22,$00	; .."..."..."...".
	dc.b	$00,$02,$22	; .."
	dcb.b	$62,0
	dc.b	$22,$20,$00,$00,$22,$20,$00,$00,$22,$20,$00,$00,$22,$20,$00,$00	; " .." .." .." ..
	dc.b	$22,$20,$00,$00,$22,$20,$00,$00,$22,$20,$00,$00,$22,$20,$00,$00	; " .." .." .." ..
	dc.b	$02,$22,$00,$00,$02,$22,$00,$00,$02,$33,$11,$00,$03,$11,$11	; ."..."...3.....
	dcb.b	$18,0
	dc.b	$11,$11,$11,$11,$11,$11,$11,$11	; ........
	dcb.b	$18,0
	dc.b	$11,$11,$11,$11,$11,$11,$11,$11	; ........
	dcb.b	$18,0
	dc.b	$11,$11,$11,$11,$11,$11,$11,$11	; ........
	dcb.b	$11,0
	dc.b	$22,$20,$00,$00,$32,$20,$00,$11,$13,$20,$00,$11,$11,$30	; " ..2 ... ...0
	dcb.b	$131,0
