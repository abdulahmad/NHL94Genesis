;	BOOT.BIN $0-$1FF: the disc header, sector 0 of the data track. Written by hand.
;
;	BOOT.BIN is the boot area, the first 16 sectors of the data track (not a file on the disc):
;	tools/segacd_bootarea.py copies it from your own disc image into cdbin/BOOT.BIN.
;
;	This header is read by the Sega CD BIOS: the volume and system names, where the initial program
;	(security.asm, ip.asm) and the system program (sp.asm) are, then the system header in the cartridge's
;	form.

	org	0

DiscHeader
	dc.b	'SEGADISCSYSTEM  '		;disc type
	dc.b	'NHLHOCKEY94',0			;volume name
	dc.w	$0100					;volume version
	dc.w	$0001					;volume type
	dc.b	'CDSYS.BIN  ',0			;system name
	dc.w	$0001					;system version
	dc.w	$0000					;system type
	dc.l	$800,$800,0,0			;initial program: offset, size, entry, work RAM
	dc.l	$1000,$7000,0,0			;system program: offset, size, entry, work RAM
	dc.b	'12181993'				;date
	dcb.b	$100-*,' '

SystemHeader
	dc.b	'SEGA GENESIS    '		;hardware
	dc.b	'(C)T-50 1993.NOV'		;copyright: publisher code T-50, date
	dc.b	'NHL HOCKEY 94'			;domestic name
	dcb.b	$150-*,' '
	dc.b	'NHL HOCKEY 94'			;overseas name
	dcb.b	$180-*,' '
	dc.b	'GM T-50015 -00  '		;serial number and version
	dc.b	'J'						;input devices: joypad
	dcb.b	$1F0-*,' '
	dc.b	'U'						;region: USA
	dcb.b	$200-*,' '
