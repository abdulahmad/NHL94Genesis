;	Sound driver, 68000 side. It starts and stops sounds and songs, plays the music tracks event
;	by event, sets each channel's volume and pitch, and sets up the Z80. The pad readers run from
;	its vertical blank routine. The Z80 program and the sound data follow it.


;	Sound numbers and the data the driver works on, named as in 92's sound.asm (the same as sound93.asm
;	except where 94 differs: 8 byte channel structs with a volume byte, a voice volume word, sounds $0-$7A).

;	Sound numbers
SoundLast			=	$7A			;last sound number: effects below $30, songs from $30
FirstSong			=	$30			;the first song; a new song stops the one playing

;	Track slots (fm_track_slots in ram94.asm, 8 of SlotSize bytes; slot n plays track 7-n): an event
;	pointer and a delay
NumSlots			=	8
SlotSize			=	6
sl_delay			=	4			;word: frames until the next event (sl_delaybyte is its low byte)
sl_delaybyte		=	5

;	Channel structs (6, the 6th is the PCM channel)
NumChans			=	6
NumFMChans			=	5
ChanSize			=	8			;bytes per channel struct
ch_key				=	0			;midi channel * 8 + track
ch_note				=	1
ch_vol				=	2			;the event's volume
ch_patch			=	3			;PCMPatch and up play on the PCM channel
ch_out				=	4			;output channel (0, 1, 2, 4, 5, 6)
ch_age				=	5			;frames since key on, held at $FF
ch_flags			=	6
ch_on				=	0			;ch_flags bit: the key is on

;	Voice table: 8 bytes per key (key = midi channel * 8 + track)
NumMidiChans		=	8			;midi channels per track
KeyShift			=	3			;key = midi channel << 3 | track
VoiceShift			=	3			;voice table offset = key << 3
VoiceSize			=	1<<VoiceShift
vc_bend				=	0			;word: pitch bend (stored as the stream word - BendCentre)
vc_spare			=	2			;cleared with the key, never read
vc_patch			=	3
vc_vol				=	4			;word: voice volume, 0-$7F (controller 7 sets the low byte)
BendCentre			=	$2000		;stream pitch bend word for no bend

;	Events: 4 bytes. Status bits 6-4 are the command, bits 3-0 the midi channel
EventSize			=	4
ev_delay			=	0
ev_status			=	1
ev_data				=	2			;note, patch, controller or bend word; the byte after it is the volume
EvCmdMask			=	$70
EvChanMask			=	$F

;	FM patches: 32 bytes each; patch numbers from PCMPatch are PCM samples (pcm_sample_table)
PCMPatch			=	$60
PatchShift			=	5			;32 bytes per patch
patch_bendscale		=	$1E			;patch byte: pitch bend scale

;	Command buffer sent to the Z80 (Z80_command_buffer, 5 bytes in ram94.asm), then
;	per_channel_attenuation_table, per_channel_frequency_table and per_channel_patch_table
cb_keyoff			=	0			;bit per output channel
cb_keyon			=	1
cb_volume			=	2
cb_freq				=	3
cb_patch			=	4
CmdBufSize			=	33			;bytes copied to the Z80

;	Z80 memory map (offsets from Z80_RAM)
z80_cmdbuf			=	$02			;where the command buffer is copied to
z80_dac_start_addr		=	$23			;3 bytes: PCM sample start (high byte first)
z80_dac_next_addr	=	$26			;3 bytes: where the Z80 carries on after a 0 sample byte (high byte first)
z80_dac_vol_page			=	$83			;volume table page ($03-$1F, $1F loudest)
z80_dac_step		=	$8E			;sample step per DAC write; 0 holds the current byte (no advance)
z80_cmd				=	$96			;low byte of the sample loop's jump target: Z80Idle when the Z80 can take
									;a command
z80_cmd_high		=	$97			;high byte of that jump target; the Z80 always leaves 0 here
z80_tables			=	$2000		;end of the 29 tables of 256 bytes below it
Z80Idle				=	$7D			;the sample loop (MainLoop in z80_snd_drv93.asm): no command pending
Z80Cmd_Upload		=	$D1			;UpdateFmChannels: take the command buffer
Z80Cmd_PCM			=	$29			;Z80_Init: restart with the PCM sample set up at z80_dac_start_addr
Z80ProgramLen		=	$295		;bytes of the Z80 program copied to Z80 RAM
Z80Tables			=	29			;tables of 256 bytes built by p_initialZ80

p_turnoff							;(audio stop). Silence everything: free all slots, key off and mute every
									;output channel, send the buffer
									;and stop the PCM channel. Called from Begin and the game screens
	movem.l	d0-d7/a0-a2,-(sp)
	bsr.w	ClearAllTrackAndSFXSlots
	move.b	#$77,(Z80_command_buffer).w	;key off channels 0-2, 4-6
	move.b	#$77,(Z80_command_buffer+cb_volume).w	;volume change on 0-2, 4-6
	moveq	#6,d0					;7 volume bytes
	movea.w	#(per_channel_attenuation_table-M68K_RAM),a0
.loop								;silence each channel
	move.b	#$7F,(a0)+				;$7F = silent
	dbf	d0,.loop
	bsr.w	UploadCommandBufferToZ80
	bsr.w	StopPCMChannel			;stop the PCM channel
	movem.l	(sp)+,d0-d7/a0-a2
rtsfx								;The shared rts; play_sfx_or_music_track and
									;ProcessOneMusicTrack branch to it
	rts
play_sfx_or_music_track				;Start sound d0 (0-$7A) in the track slot with the lowest pointer. $30 and
									;up are songs: the song already playing is stopped first
									;(stop_current_song). Takes the event stream from the long pointer table
									;SoundStreamTable and also sets each voice volume (vc_vol) to $7F. Called
									;from sfx and song
	cmp.w	#SoundLast,d0			;valid sound?
	bhi.s	rtsfx					;out of range
	movem.l	d0-d3/a0-a2,-(sp)
	cmp.w	#FirstSong,d0			;a song?
	blt.w	.0
	bsr.w	stop_current_song		;song: stop the current song
.0									;sound effects keep the song playing
	lea	(fm_track_slots).w,a1		;8 x 6 bytes
	moveq	#NumSlots-1,d3
.loop								;loop
	move.l	(a1),d1
	move.w	d3,d2
	movea.w	a1,a2
.loop2								;(the slot search loop: find the lowest pointer)
	cmp.l	(a1),d1
	bgt.s	.loop
	addq.w	#SlotSize,a1
	dbf	d3,.loop2					;loop
	tst.w	(a2)
	bpl.w	.x						;no free slot (lowest pointer is in use): do nothing
	asl.w	#2,d0
	lea	(SoundStreamTable).l,a0
	movea.l	0(a0,d0.w),a0			;this sound's stream
	move.l	a0,(a2)
	clr.w	sl_delay(a2)
	move.b	(a0),sl_delaybyte(a2)
	lea	(fm_voice_usage_table).w,a0
	asl.w	#VoiceShift,d2
	adda.w	d2,a0
	moveq	#NumMidiChans-1,d0		;the 8 midi channels of this track
.loop3								;clear each midi channel's voice
	clr.w	(a0)					;no pitch bend
	clr.b	vc_spare(a0)			;clear the spare byte
	clr.b	vc_patch(a0)
	move.w	#$7F,vc_vol(a0)
	adda.w	#NumSlots*VoiceSize,a0	;next channel (8 keys of 8 bytes)
	dbf	d0,.loop3					;next midi channel
.x									;exit: restore the registers
	movem.l	(sp)+,d0-d3/a0-a2
	rts
stop_current_song					;Stop the song in progress: free the first slot whose pointer is at or
									;past the first song ($30, SongPointerTable)
									;and key off its channels. Called from play_sfx_or_music_track,
									;DoGameFrame and others
	movem.l	d0-d3/a0-a3,-(sp)
	move	sr,-(sp)				;save the status register
	move	#$2700,sr				;no interrupts while the slots change
	lea	(fm_track_slots).w,a1
	moveq	#NumSlots-1,d3
	movea.l	(SongPointerTable).l,a0	;first song stream
.find								;find the slot of the song
	cmpa.l	(a1),a0					;look for a slot whose pointer is at or past the first song data
	addq.w	#SlotSize,a1
	dble	d3,.find				;until a slot pointer >= the song data
	bgt.w	.0						;none: no song playing
	clr.l	(Z80_command_buffer).w	;clear the change bits
	clr.b	(Z80_command_buffer+cb_patch).w	;and the patch bits
	move.l	#-1,-SlotSize(a1)
	moveq	#NumChans-1,d1
	lea	(fm_channel_structs).w,a2	;6 x 8 bytes
.kill								;each channel struct
	move.b	ch_key(a2),d2			;each channel struct: release the ones that belong to this track
	andi.w	#NumSlots-1,d2			;track of the key
	cmp.w	d2,d3					;this track?
	bne.w	.next					;another track
	bsr.w	ReleaseChannelAndNote
	move.b	ch_out(a2),d0
	lea	(per_channel_attenuation_table).w,a1
	move.b	#$7F,0(a1,d0.w)			;silent
	bset	d0,(Z80_command_buffer+cb_volume).w
.next								;next channel
	addq.w	#ChanSize,a2
	dbf	d1,.kill
	bsr.w	UploadCommandBufferToZ80
.0									;no song slot found
	move	(sp)+,sr				;restore the status register
	movem.l	(sp)+,d0-d3/a0-a3
	rts
ReadJoyData							;read the pads every vblank. With FourWayPlay, pads 1-4 through the 4 way
									;adaptor (ReadPad4Way1 ...
									;ReadPad4Way4) to pad4way1-pad4way4, else pads 1 and 2 (ReadPad1,
									;ReadPad2)
	movem.l	d1/a0,-(sp)
	tst.w	(FourWayPlay).w			;4-way play?
	beq.w	.0
	bsr.s	ReadPad4Way1
	move.b	d0,(pad4way1).w
	bsr.s	ReadPad4Way2
	move.b	d0,(pad4way2).w
	bsr.w	ReadPad4Way3
	move.b	d0,(pad4way3).w
	bsr.w	ReadPad4Way4
	move.b	d0,(pad4way4).w
	bra.w	.x
.0									;FourWayPlay = 0
	bsr.w	ReadPad1
	move.b	d0,(pad4way1).w
	bsr.w	ReadPad2
	move.b	d0,(pad4way2).w
.x									;exit: restore the registers
	movem.l	(sp)+,d1/a0
	rts
ReadPad4Way1						;4 way play pad 1: take the Z80 bus (ResetZ80Bus if it is not granted),
									;select pad 1 on port 2 and read it on port 1 (ReadPad4WayPort1)
	move.w	#$100,(IO_Z80BUS).l		;request the Z80 bus
	move.w	#$64,d0					;$64 tries
.loop								;wait for the bus
	btst	#0,(IO_Z80BUS).l		;granted?
	beq.s	.0
	dbf	d0,.loop					;keep waiting
	bsr.w	ResetZ80Bus				;not granted: reset the Z80
.0									;bus granted (or reset)
	move.b	#$C,(IO_CT2_DATA+1).l	;select pad 1 on port 2
	bra.w	ReadPad4WayPort1
ReadPad4Way2						;4 way play pad 2: take the Z80 bus (ResetZ80Bus if it is not granted),
									;select pad 2 on port 2 and read it on port 1 (ReadPad4WayPort1)
	move.w	#$100,(IO_Z80BUS).l		;request the Z80 bus
	move.w	#$64,d0					;$64 tries
.loop								;wait for the bus
	btst	#0,(IO_Z80BUS).l		;granted?
	beq.s	.0
	dbf	d0,.loop					;keep waiting
	bsr.w	ResetZ80Bus				;not granted: reset the Z80
.0									;bus granted (or reset)
	move.b	#$1C,(IO_CT2_DATA+1).l	;select pad 2 on port 2
	bra.w	ReadPad4WayPort1
ReadPad4Way3						;4 way play pad 3: take the Z80 bus (ResetZ80Bus if it is not granted),
									;select pad 3 on port 2 and read it on port 1 (ReadPad4WayPort1)
	move.w	#$100,(IO_Z80BUS).l		;request the Z80 bus
	move.w	#$64,d0					;$64 tries
.loop								;wait for the bus
	btst	#0,(IO_Z80BUS).l		;granted?
	beq.s	.0
	dbf	d0,.loop					;keep waiting
	bsr.w	ResetZ80Bus				;not granted: reset the Z80
.0									;bus granted (or reset)
	move.b	#$2C,(IO_CT2_DATA+1).l	;select pad 3 on port 2
	bra.w	ReadPad4WayPort1
ReadPad4Way4						;4 way play pad 4: take the Z80 bus (ResetZ80Bus if it is not granted),
									;select pad 4 on port 2 and read it on port 1 (ReadPad4WayPort1)
	move.w	#$100,(IO_Z80BUS).l		;request the Z80 bus
	move.w	#$64,d0					;$64 tries
.loop								;wait for the bus
	btst	#0,(IO_Z80BUS).l		;granted?
	beq.s	.0
	dbf	d0,.loop					;keep waiting
	bsr.w	ResetZ80Bus				;not granted: reset the Z80
.0									;bus granted (or reset)
	move.b	#$3C,(IO_CT2_DATA+1).l	;select pad 4 on port 2
ReadPad4WayPort1					;Read the pad on port 1; branched to from ReadPad4Way1 ... ReadPad4Way4
	movem.l	d1/a0,-(sp)
	lea	(IO_CT1_DATA+1).l,a0
	bra.w	ReadPad3Button
ReadPad2							;Read pad 2 (port 2). Falls into ReadPadA0
	movem.l	d1/a0,-(sp)
	lea	(IO_CT2_DATA+1).l,a0
	bra.s	ReadPadA0
ReadPad1							;Read pad 1 (port 1)
	movem.l	d1/a0,-(sp)
	lea	(IO_CT1_DATA+1).l,a0
ReadPadA0							;Take the Z80 bus (ResetZ80Bus if it is not granted), then ReadPad3Button
	move.w	#$100,(IO_Z80BUS).l		;request the Z80 bus
	move.w	#$64,d0					;$64 tries
.loop								;wait for the bus
	btst	#0,(IO_Z80BUS).l		;granted?
	beq.s	ReadPad3Button			;yes: read the pad
	dbf	d0,.loop					;keep waiting
	bsr.w	ResetZ80Bus				;not granted: reset the Z80
ReadPad3Button						;Read a 3 button pad at a0 (TH low, then high), release the bus and return
									;d0 = the buttons, the directions through PadDirTable
	moveq	#0,d0
	move.b	#0,(a0)
	nop								;let the lines settle
	nop
	move.b	(a0),d0					;d0 = start, A
	move.b	#$40,(a0)
	nop								;let the lines settle
	nop
	move.b	(a0),d1					;d1 = C, B, directions
	move.w	#0,(IO_Z80BUS).l		;release the Z80 bus
	asl.b	#2,d0					;start and A to bits 7-6
	andi.b	#$C0,d0					;keep them
	andi.b	#$3F,d1					;C, B and directions
	or.b	d1,d0
	not.b	d0
	not.b	d1
	andi.w	#$F,d1					;direction nibble
	lea	PadDirTable(pc),a0
	andi.b	#$F0,d0					;keep the buttons
	or.b	0(a0,d1.w),d0			;remapped directions
	not.b	d0						;pressed = 0 again
	movem.l	(sp)+,d1/a0
	rts
PadDirTable							;Direction nibble table for ReadPad3Button: remaps the nibble when
									;opposite directions are pressed together
	dc.b	0,1,2,1,4,5,6,6,8,9,$A,$A,8,9,$A,0
ResetZ80Bus							;Reset the Z80 and wait for its bus
	move.w	#$100,(IO_Z80RES).l		;reset the Z80
	move.w	#$100,(IO_Z80BUS).l		;request the Z80 bus
.loop								;loop
	btst	#0,(IO_Z80BUS).l		;granted?
	bne.s	.loop
	rts
p_music_vblank						;(vblank handler). Read the pads (ReadJoyData), clear the change bits, run
									;the 8 track slots (d7 = track 7-0), send the buffer if anything changed
									;and age the channels. 50 Hz block: with PALflag bit 0 set the slots run
									;again every 6th frame. Called from the vblank handlers
	bsr.w	ReadJoyData				;read the pads
	clr.b	(music_needs_z80_update).w	;nothing to send yet
	clr.l	(Z80_command_buffer).w	;key off/on, volume, frequency bits
	clr.b	(Z80_command_buffer+cb_patch).w
.loop								;loop
	lea	(fm_track_slots).w,a5
	moveq	#NumSlots-1,d7
.loop2								;each music track
	bsr.w	ProcessOneMusicTrack	;run its events
	addq.w	#SlotSize,a5
	dbf	d7,.loop2					;loop
	btst	#0,(PALflag).w			;50 Hz?
	beq.w	.0
	subq.w	#1,(music_tick_divider).w	;count down the divider
	bpl.w	.0
	addq.w	#6,(music_tick_divider).w	;reload it
	bra.s	.loop					;run the slots again
.0									;bit 0 of PALflag clear or music_tick_divider >= 0
	tst.b	(music_needs_z80_update).w
	beq.w	.1						;nothing changed
	bsr.w	UploadCommandBufferToZ80
.1									;Z80 updated, or nothing to send
	movea.w	#(fm_channel_structs-M68K_RAM),a0
	moveq	#NumChans-1,d0
.loop3								;age every channel
	addq.b	#1,ch_age(a0)
	bne.w	.next
	subq.b	#1,ch_age(a0)			;hold at $FF
.next								;next channel
	addq.w	#ChanSize,a0
	dbf	d0,.loop3					;loop
	rts
z80_bus_release_delay				;Z80 busy: give the bus back, wait, then falls into
									;UploadCommandBufferToZ80 to retry
	clr.w	(IO_Z80BUS).l			;release the Z80 bus
	moveq	#$64,d0
.delay								;short wait
	dbf	d0,.delay
UploadCommandBufferToZ80			;Copy the 33 byte command buffer (Z80_command_buffer) to z80_cmdbuf once
									;the Z80 is idle (z80_cmd_high 0, z80_cmd Z80Idle)
	move.w	#$100,(IO_Z80BUS).l		;request the Z80 bus
.loop								;loop
	btst	#0,(IO_Z80BUS).l		;granted?
	bne.s	.loop
	movea.l	#Z80_RAM,a0
	cmpi.b	#0,z80_cmd_high(a0)
	bne.s	z80_bus_release_delay
	cmpi.b	#Z80Idle,z80_cmd(a0)
	bne.s	z80_bus_release_delay
	move.b	#Z80Cmd_Upload,z80_cmd(a0)	;the sample loop jumps to UpdateFmChannels next
	move.b	#0,z80_cmd_high(a0)
	adda.w	#z80_cmdbuf,a0			;command buffer area
	movea.w	#(Z80_command_buffer-M68K_RAM),a1
	moveq	#CmdBufSize-1,d0
.copy								;copy each byte
	move.b	(a1)+,(a0)+				;copy the buffer to Z80 RAM
	dbf	d0,.copy
	clr.w	(IO_Z80BUS).l			;release the Z80 bus
rtscmd10							;The shared rts; handle_command_10 branches to it
	rts
ProcessOneMusicTrack				;Count down track slot a5 (track d7) and run every event that is due
									;through command_jump_table. A 0 status ends the stream; a non-negative
									;long at ev_data is a loop pointer. Called from p_music_vblank
	subq.w	#1,sl_delay(a5)
	bpl.w	rtsfx					;not due yet
.event								;loop
	tst.w	(a5)					;slot free?
	bmi.w	rtsfx
	movea.l	(a5),a0
	addq.l	#EventSize,(a5)
	clr.w	sl_delay(a5)
	move.b	EventSize+ev_delay(a0),sl_delaybyte(a5)	;delay before the next event
	move.b	ev_status(a0),d0
	bne.w	.cmd
	st	(a5)						;status 0: end of stream
	tst.w	ev_data(a0)				;loop pointer?
	bmi.w	rtsfx					;no: the stream ends
	move.l	ev_data(a0),(a5)
	bra.s	.event
.cmd								;d0 <> 0
	move.b	ev_status(a0),d0		;dispatch on the command number in status bits 6-4
	andi.w	#EvCmdMask,d0			;status bits 6-4
	lsr.w	#3,d0
	lea	command_jump_table(pc),a2
	adda.w	0(a2,d0.w),a2			;this command's handler
	jsr	(a2)
	bra.s	ProcessOneMusicTrack	;the next event may be due now (delay 0)
command_jump_table					;Event handlers by status bits 6-4, as offsets from the table, including
									;handle_command_30
	dc.w	handle_command_00-command_jump_table
	dc.w	handle_command_10-command_jump_table
	dc.w	handle_command_skip-command_jump_table
	dc.w	handle_command_30-command_jump_table
	dc.w	handle_command_40-command_jump_table
	dc.w	handle_command_skip-command_jump_table
	dc.w	handle_command_60-command_jump_table
	dc.w	handle_command_skip-command_jump_table
handle_command_00					;Event $0x: key off note ev_data on midi channel (ev_status bits 3-0) of
									;track d7. Also entered from handle_command_10 (volume 0). Falls into
									;ReleaseChannelAndNote
	move.b	ev_status(a0),d0
	andi.w	#EvChanMask,d0			;midi channel
	asl.w	#KeyShift,d0
	or.w	d7,d0
	asl.w	#8,d0					;key to the high byte
	move.b	ev_data(a0),d0			;key and note, as in ch_key / ch_note
	movea.w	#(fm_track_slots-M68K_RAM),a2	;end of the channel structs
	moveq	#NumChans-1,d1
.find								;find the channel playing this note
	subq.w	#ChanSize,a2			;search the channel structs (last to first) for this key and note
	cmp.w	(a2),d0					;this key and note?
	dbeq	d1,.find				;until found
	bne.w	rtsfx
	btst	#ch_on,ch_flags(a2)		;on?
	dbne	d1,.find				;matched but already off: keep looking
	beq.w	rtsfx					;none on: nothing to do
ReleaseChannelAndNote				;Key off channel struct a2 if it is on. The PCM patches ($60 up) stop the
									;PCM channel (StopPCMChannel)
	bclr	#ch_on,ch_flags(a2)		;key off
	beq.w	rtsfx					;was already off
	cmpi.b	#PCMPatch,ch_patch(a2)	;PCM patch?
	bge.w	StopPCMChannel
	move.b	ch_out(a2),d0
	bset	d0,(Z80_command_buffer).w	;key off
	st	(music_needs_z80_update).w
	rts
StopPCMChannel						;Clear z80_dac_step (the PCM rate byte written by
									;UpdateChannelFrequencyAndVolume): stops the PCM channel
	move.w	#$100,(IO_Z80BUS).l		;request the Z80 bus
.loop								;loop
	btst	#0,(IO_Z80BUS).l		;granted?
	bne.s	.loop
	clr.b	(Z80_RAM+z80_dac_step).l
	clr.w	(IO_Z80BUS).l			;release the Z80 bus
	rts
handle_command_10					;Event $1x: key on note ev_data at volume ev_data+1, midi channel bits
									;3-0, track d7 (volume 0 = key off). An FM patch takes a free channel or
									;the oldest one; a PCM patch ($60 up) sets the sample start and next address
									;(pcm_sample_table) in z80_dac_start_addr / z80_dac_next_addr. Then the volume
									;(SetChannelVolume) and the frequency (UpdateChannelFrequencyAndVolume)
	tst.b	ev_data+1(a0)			;volume
	beq.s	handle_command_00		;volume 0: key off
	movea.w	#(fm_channel_struct6-M68K_RAM),a2	;the PCM channel struct
	lea	(fm_voice_usage_table).w,a3
	move.b	ev_status(a0),d0
	andi.w	#EvChanMask,d0			;midi channel
	asl.w	#KeyShift,d0
	or.w	d7,d0
	move.w	d0,d6
	asl.w	#VoiceShift,d0
	move.b	vc_patch(a3,d0.w),d0	;patch of this key
	cmp.b	#PCMPatch,d0			;PCM?
	bge.w	.pcm
	subq.w	#ChanSize,a2
	moveq	#NumFMChans-1,d1
	bra.w	.setold
.old								;find the oldest FM channel
	cmp.b	ch_age(a2),d2			;older than a4?
	bhi.w	.nextold
.setold								;the oldest so far
	movea.w	a2,a4					;a4 = oldest so far
	move.b	ch_age(a4),d2
.nextold							;next channel
	subq.w	#ChanSize,a2
	dbf	d1,.old						;loop
	moveq	#NumFMChans-1,d1
	movea.w	#(fm_channel_struct6-M68K_RAM),a2	;after the last FM channel
.free								;look for a free channel with this patch
	subq.w	#ChanSize,a2			;look for a channel struct that is off
	btst	#ch_on,ch_flags(a2)		;on?
	dbeq	d1,.free				;skip channels that are on
	bne.w	.0						;none off: use the oldest (a4)
	movea.w	a2,a4					;a4 = this off channel
	cmp.b	ch_patch(a4),d0			;same patch?
	dbeq	d1,.free				;look for an off channel that has the patch already
	beq.w	.keyon					;found: no patch change
	bra.w	.patch
.0									;a free channel: same patch?
	cmp.b	ch_patch(a4),d0			;same patch?
	beq.w	.keyon					;yes: no patch change
.patch								;the patch has to be loaded
	movea.w	a4,a2
.1									;(not branched to)
	move.b	d0,ch_patch(a2)
	clr.w	d1						;clear the high byte
	move.b	ch_out(a2),d1
	bset	d1,(Z80_command_buffer+cb_patch).w
	movea.w	#(per_channel_patch_table-M68K_RAM),a4
	move.b	d0,0(a4,d1.w)			;store the patch
	st	(music_needs_z80_update).w
.keyon								;key the note on
	clr.b	ch_age(a2)
	bset	#ch_on,ch_flags(a2)
	move.b	d6,ch_key(a2)
	move.b	ev_data(a0),ch_note(a2)	;note
	move.b	ev_data+1(a0),ch_vol(a2)	;volume
	clr.w	d1						;clear the high byte
	move.b	ch_out(a2),d1
	bset	d1,(Z80_command_buffer).w	;key off first
	bset	d1,(Z80_command_buffer+cb_keyon).w
	bsr.w	SetChannelVolume
	bra.w	UpdateChannelFrequencyAndVolume
.pcm								;d0 >= #PCMPatch
	bset	#ch_on,ch_flags(a2)		;a2 = the PCM channel
	beq.w	.pcmon					;it was off
	cmp.b	ch_patch(a2),d0			;playing a higher patch?
	ble.w	rtscmd10
.pcmon								;PCM channel taken (higher patch wins)
	move.b	d0,ch_patch(a2)
	clr.b	ch_age(a2)
	move.b	d6,ch_key(a2)
	move.b	ev_data(a0),ch_note(a2)	;note
	move.b	ev_data+1(a0),ch_vol(a2)	;volume
	ext.w	d0
	subi.w	#PCMPatch,d0
	asl.w	#3,d0					;8 bytes per sample
	lea	pcm_sample_table(pc),a1		;PCM sample start, end longs by patch - $60
	move.l	4(a1,d0.w),d1
	move.l	0(a1,d0.w),d0
	move.w	#$100,(IO_Z80BUS).l		;request the Z80 bus
.loop								;loop
	btst	#0,(IO_Z80BUS).l		;granted?
	bne.s	.loop
	movea.l	#Z80_RAM,a1
	move.b	d0,z80_dac_start_addr+2(a1)	;sample start, high byte first
	lsr.w	#8,d0					;middle byte
	move.b	d0,z80_dac_start_addr+1(a1)
	swap	d0
	move.b	d0,z80_dac_start_addr(a1)
	move.b	d1,z80_dac_next_addr+2(a1)	;where to carry on after a 0 byte
	lsr.w	#8,d1					;middle byte
	move.b	d1,z80_dac_next_addr+1(a1)
	swap	d1
	move.b	d1,z80_dac_next_addr(a1)
	move.b	#Z80Cmd_PCM,z80_cmd(a1)	;play the sample: the Z80 restarts at Z80_Init
	move.b	#0,z80_cmd_high(a1)
	clr.w	(IO_Z80BUS).l			;release the Z80 bus
	bsr.w	SetChannelVolume
UpdateChannelFrequencyAndVolume		;Set the frequency of channel struct a2 from its note and the pitch bend
									;of its key (a3 = voice table, vc_bend). Called from handle_command_60 and
									;handle_command_10
	clr.l	d3
	move.b	ch_note(a2),d3			;note
	divu.w	#$C,d3					;d3 = octave, high word = note in the octave
	move.w	d3,-(sp)
	swap	d3						;note in the octave
	add.w	d3,d3
	lea	.fnum(pc),a4				;frequency numbers
	move.w	0(a4,d3.w),d2			;d2 = frequency number
	clr.w	d1						;clear the high byte
	move.b	ch_key(a2),d1
	asl.w	#VoiceShift,d1
	move.w	0(a3,d1.w),d3			;d3 = pitch bend
	beq.w	.nobend
	moveq	#$C,d1					;PCM bend scale
	cmpi.b	#PCMPatch,ch_patch(a2)	;PCM?
	bge.w	.0
	move.b	ch_patch(a2),d1
	asl.w	#PatchShift,d1			;32 bytes per patch
	lea	(fm_instrument_patches).l,a4	;32 bytes per patch
	move.b	patch_bendscale(a4,d1.w),d1
	ext.w	d1
.0									;scale the bend
	muls.w	d1,d3					;bend * scale
	asr.l	#2,d3					;scale down
	asr.w	#7,d3
	addi.w	#$C0,d3					;centre of .bendtab
	add.w	d3,d3
	lea	.bendtab(pc),a4
	mulu.w	0(a4,d3.w),d2			;frequency * factor
	asl.l	#1,d2					;scale
	swap	d2						;d2 = bent frequency
.nobend								;frequency ready (with or without bend)
	move.w	(sp)+,d3
	cmpi.b	#PCMPatch,ch_patch(a2)	;PCM?
	bge.w	.1
	asl.w	#3,d3					;octave
	asl.w	#8,d3					;octave in bits 13-11
	or.w	d3,d2					;octave and frequency number
	clr.w	d3						;clear the high byte
	move.b	ch_out(a2),d3
	bset	d3,(Z80_command_buffer+cb_freq).w
	add.w	d3,d3
	movea.w	#(per_channel_frequency_table-M68K_RAM),a4
	move.w	d2,0(a4,d3.w)			;store the frequency
	st	(music_needs_z80_update).w
	rts
.1									;PCM channel
	btst	#ch_on,ch_flags(a2)		;on?
	beq.w	.x
	move.w	#$100,(IO_Z80BUS).l		;request the Z80 bus
.loop								;loop
	btst	#0,(IO_Z80BUS).l		;granted?
	bne.s	.loop
	neg.w	d3
	addq.w	#8,d3
	lsr.w	d3,d2					;frequency number >> (8 - octave)
	move.b	d2,(Z80_RAM+z80_dac_step).l
	clr.w	(IO_Z80BUS).l			;release the Z80 bus
.x									;exit (also the end of the code above)
	rts
.fnum								;frequency number of each note in the octave
	dc.w	$0146,$0159,$016E,$0184,$019B,$01B3,$01CD,$01E8,$0205,$0224,$0245,$0268
.bendtab							;385 factors, entry $C0 = $8000 (no bend)
	dc.w	$4000,$403B,$4076,$40B2,$40EE,$412A,$4166,$41A3,$41E0,$421D
	dc.w	$425A,$4297,$42D5,$4313,$4351,$438F,$43CE,$440D,$444C,$448B
	dc.w	$44CA,$450A,$454A,$458A,$45CA,$460B,$464C,$468D,$46CE,$4710
	dc.w	$4752,$4794,$47D6,$4818,$485B,$489E,$48E1,$4925,$4969,$49AD
	dc.w	$49F1,$4A35,$4A7A,$4ABF,$4B04,$4B4A,$4B8F,$4BD5,$4C1B,$4C62
	dc.w	$4CA9,$4CF0,$4D37,$4D7E,$4DC6,$4E0E,$4E56,$4E9F,$4EE8,$4F31
	dc.w	$4F7A,$4FC4,$500E,$5058,$50A2,$50ED,$5138,$5183,$51CE,$521A
	dc.w	$5266,$52B2,$52FF,$534C,$5399,$53E6,$5434,$5482,$54D0,$551F
	dc.w	$556E,$55BD,$560C,$565C,$56AC,$56FC,$574C,$579D,$57EE,$5840
	dc.w	$5891,$58E3,$5936,$5988,$59DB,$5A2E,$5A82,$5AD6,$5B2A,$5B7E
	dc.w	$5BD3,$5C28,$5C7D,$5CD3,$5D29,$5D7F,$5DD6,$5E2D,$5E84,$5EDB
	dc.w	$5F33,$5F8B,$5FE4,$603D,$6096,$60EF,$6149,$61A3,$61FD,$6258
	dc.w	$62B3,$630E,$636A,$63C6,$6423,$647F,$64DC,$653A,$6597,$65F6
	dc.w	$6654,$66B3,$6712,$6771,$67D1,$6831,$6892,$68F2,$6954,$69B5
	dc.w	$6A17,$6A79,$6ADC,$6B3F,$6BA2,$6C06,$6C6A,$6CCE,$6D33,$6D98
	dc.w	$6DFD,$6E63,$6EC9,$6F30,$6F97,$6FFE,$7066,$70CE,$7136,$719F
	dc.w	$7208,$7272,$72DC,$7346,$73B1,$741C,$7488,$74F4,$7560,$75CD
	dc.w	$763A,$76A7,$7715,$7783,$77F2,$7861,$78D0,$7940,$79B0,$7A21
	dc.w	$7A92,$7B04,$7B76,$7BE8,$7C5B,$7CCE,$7D41,$7DB5,$7E2A,$7E9F
	dc.w	$7F14,$7F89,$8000,$8076,$80ED,$8164,$81DC,$8254,$82CD,$8346
	dc.w	$83C0,$843A,$84B4,$852F,$85AA,$8626,$86A2,$871F,$879C,$881A
	dc.w	$8898,$8916,$8995,$8A14,$8A94,$8B14,$8B95,$8C16,$8C98,$8D1A
	dc.w	$8D9D,$8E20,$8EA4,$8F28,$8FAC,$9031,$90B7,$913D,$91C3,$924A
	dc.w	$92D2,$935A,$93E2,$946B,$94F4,$957E,$9609,$9694,$971F,$97AB
	dc.w	$9837,$98C4,$9952,$99E0,$9A6E,$9AFD,$9B8D,$9C1D,$9CAD,$9D3E
	dc.w	$9DD0,$9E62,$9EF5,$9F88,$A01C,$A0B0,$A145,$A1DA,$A270,$A306
	dc.w	$A39D,$A435,$A4CD,$A565,$A5FE,$A698,$A732,$A7CD,$A868,$A904
	dc.w	$A9A1,$AA3E,$AADC,$AB7A,$AC18,$ACB8,$AD58,$ADF8,$AE99,$AF3B
	dc.w	$AFDD,$B080,$B123,$B1C7,$B26C,$B311,$B3B7,$B45D,$B504,$B5AC
	dc.w	$B654,$B6FD,$B7A7,$B851,$B8FB,$B9A6,$BA52,$BAFF,$BBAC,$BC5A
	dc.w	$BD08,$BDB7,$BE67,$BF17,$BFC8,$C07A,$C12C,$C1DF,$C292,$C346
	dc.w	$C3FB,$C4B1,$C567,$C61D,$C6D5,$C78D,$C846,$C8FF,$C9B9,$CA74
	dc.w	$CB2F,$CBEC,$CCA8,$CD66,$CE24,$CEE3,$CFA2,$D063,$D124,$D1E5
	dc.w	$D2A8,$D36B,$D42E,$D4F3,$D5B8,$D67E,$D744,$D80C,$D8D4,$D99D
	dc.w	$DA66,$DB30,$DBFB,$DCC7,$DD93,$DE60,$DF2E,$DFFD,$E0CC,$E19D
	dc.w	$E26D,$E33F,$E411,$E4E5,$E5B9,$E68D,$E763,$E839,$E910,$E9E8
	dc.w	$EAC0,$EB9A,$EC74,$ED4F,$EE2A,$EF07,$EFE4,$F0C2,$F1A1,$F281
	dc.w	$F361,$F443,$F525,$F608,$F6EC,$F7D0,$F8B6,$F99C,$FA83,$FB6B
	dc.w	$FC54,$FD3E,$FE28,$FF13,$FF13
SetChannelVolume					;Set the volume of channel struct a2: note volume (ch_vol) * the voice
									;volume (vc_vol) / 128. FM: attenuation from .veltab (volume / 8); PCM:
									;z80_dac_vol_page (at least 3). Called from handle_command_10 and
									;handle_command_30
	movem.l	d0,-(sp)
	clr.w	d0
	move.b	ch_vol(a2),d0			;note volume
	clr.w	d1
	move.b	ch_key(a2),d1
	asl.w	#VoiceShift,d1
	mulu.w	vc_vol(a3,d1.w),d0		;times the voice volume
	lsr.w	#7,d0
	cmpi.b	#PCMPatch,ch_patch(a2)	;PCM?
	bge.w	.0
	lea	.veltab(pc),a4
	lsr.w	#3,d0
	move.b	0(a4,d0.w),d0			;d0 = attenuation
	clr.w	d3						;clear the high byte
	move.b	ch_out(a2),d3
	movea.w	#(per_channel_attenuation_table-M68K_RAM),a4
	move.b	d0,0(a4,d3.w)
	bset	d3,(Z80_command_buffer+cb_volume).w
	st	(music_needs_z80_update).w
	movem.l	(sp)+,d0
	rts
.veltab								;attenuation by volume / 8
	dc.b	$1A,$18,$16,$14,$12,$10,$0E,$0C,$0A,$08,$06,$04,$03,$02,$01,$00
.0									;PCM volume
	move.w	#$100,(IO_Z80BUS).l		;request the Z80 bus
.loop								;loop
	btst	#0,(IO_Z80BUS).l		;granted?
	bne.s	.loop
	lsr.b	#2,d0
	cmp.w	#3,d0					;below 3?
	bgt.w	.1
	moveq	#3,d0					;at least 3
.1									;at least 3
	move.b	d0,(Z80_RAM+z80_dac_vol_page).l	;the Z80's volume table page
	clr.w	(IO_Z80BUS).l			;release the Z80 bus
	movem.l	(sp)+,d0
	rts
handle_command_40					;Event $4x: set the patch (vc_patch) of midi channel bits 3-0, track d7,
									;to ev_data
	lea	(fm_voice_usage_table).w,a3
	move.b	ev_status(a0),d0
	andi.w	#EvChanMask,d0			;midi channel
	asl.w	#KeyShift,d0
	or.w	d7,d0
	asl.w	#VoiceShift,d0
	move.b	ev_data(a0),vc_patch(a3,d0.w)
	rts
handle_command_60					;Event $6x: set the pitch bend (vc_bend) of midi channel bits 3-0, track
									;d7, to ev_data - BendCentre, and update the frequency of every channel
									;with that key
	lea	(fm_voice_usage_table).w,a3
	move.b	ev_status(a0),d0
	andi.w	#EvChanMask,d0			;midi channel
	asl.w	#KeyShift,d0
	or.w	d7,d0
	move.w	d0,d4
	asl.w	#VoiceShift,d0
	move.w	ev_data(a0),vc_bend(a3,d0.w)
	subi.w	#BendCentre,vc_bend(a3,d0.w)	;signed, 0 = no bend
	movea.w	#(fm_channel_structs-M68K_RAM),a2
	moveq	#NumChans-1,d0
.loop								;each channel struct
	cmp.b	ch_key(a2),d4			;find the channel structs playing this key
	bne.w	.next					;another key
	bsr.w	UpdateChannelFrequencyAndVolume
.next								;next channel
	addq.w	#ChanSize,a2
	dbf	d0,.loop					;loop
	rts
handle_command_30					;event $3x, controller ev_data = ev_data+1 on midi channel bits 3-0, track
									;d7. Only controller 7 (volume) is used: set the voice volume (the low
									;byte of vc_vol) and update the volume of every channel with that key
									;(SetChannelVolume)
	cmpi.b	#7,ev_data(a0)			;volume controller?
	beq.w	.0
	rts								;others ignored
.0									;volume controller
	lea	(fm_voice_usage_table).w,a3
	move.b	ev_status(a0),d0
	andi.w	#EvChanMask,d0			;midi channel
	asl.w	#KeyShift,d0
	or.w	d7,d0
	move.w	d0,d4
	asl.w	#VoiceShift,d0
	move.b	ev_data+1(a0),vc_vol+1(a3,d0.w)	;low byte of the voice volume
	movea.w	#(fm_channel_structs-M68K_RAM),a2
	moveq	#NumChans-1,d0
.loop								;each channel struct
	cmp.b	ch_key(a2),d4			;this key?
	bne.w	.next
	bsr.w	SetChannelVolume
.next								;next channel
	addq.w	#ChanSize,a2
	dbf	d0,.loop					;loop
	rts
handle_command_skip					;Events $2x, $5x and $7x: ignored
	rts
p_initialZ80						;(initialization). Free all slots, load the Z80 program (Z80_Program_Code,
									;$295 bytes) into Z80 RAM, build 29 tables of 256 bytes below z80_tables (
									;(x - $80) * 8 / n + $80 for n = 8-$24), then reset and start the Z80.
									;Called from Begin
	movem.l	d0-d2/a0-a2,-(sp)
	bsr.w	ClearAllTrackAndSFXSlots
	move.w	#$100,(IO_Z80RES).l		;Z80 reset off
	move.w	#$100,(IO_Z80BUS).l		;request the Z80 bus
.loop								;loop
	btst	#0,(IO_Z80BUS).l		;granted?
	bne.s	.loop
	movea.l	#Z80_Program_Code,a1
	movea.l	#Z80_RAM,a2
	move.w	#Z80ProgramLen-1,d0
.loop2								;copy the Z80 program
	move.b	(a1)+,(a2)+
	dbf	d0,.loop2					;loop
	movea.l	#Z80_RAM+z80_tables,a2	;end of the tables
	moveq	#8,d2					;first divisor
	move.l	#Z80Tables-1,d3
.loop3								;each table
	move.w	#$FF,d0
.loop4								;each table byte
	move.w	d0,d1					;one table byte: ((i-$80)*8)/divisor + $80
	subi.w	#$80,d1
	asl.w	#3,d1
	ext.l	d1
	divs.w	d2,d1
	addi.w	#$80,d1
	move.b	d1,-(a2)
	dbf	d0,.loop4					;loop
	clr.b	(a2)					;entry 0 = 0
	addq.w	#1,d2					;next divisor
	dbf	d3,.loop3					;next table
	move.w	#0,(IO_Z80RES).l		;Z80 reset
	move.w	#0,(IO_Z80BUS).l		;release the bus
	move.w	#$1F4,d0
.loop5								;wait for the reset
	dbf	d0,.loop5					;wait
	move.w	#$100,(IO_Z80RES).l		;Z80 runs
	clr.b	(music_needs_z80_update).w
	movem.l	(sp)+,d0-d2/a0-a2
	rts
ClearAllTrackAndSFXSlots			;Free the 8 track slots and reset the 6 channel structs (output channels
									;0, 1, 2, 4, 5, 6). Called from p_turnoff and p_initialZ80
	lea	(fm_track_slots).w,a0
	moveq	#NumSlots-1,d0
	moveq	#-1,d1
.trk								;free each track slot
	move.l	d1,(a0)
	addq.w	#SlotSize,a0
	dbf	d0,.trk						;loop
	moveq	#NumChans-1,d0
	movea.w	#(fm_track_slots-M68K_RAM),a0	;end of the channel structs
.chan								;set up each channel struct
	subq.w	#ChanSize,a0			;set up channel struct d0 (last to first)
	move.b	d0,ch_out(a0)
	cmp.w	#3,d0					;channel 3 or more?
	blt.w	.set
	addq.b	#1,ch_out(a0)			;3-5 become 4-6
.set								;output channel set
	st	ch_patch(a0)
	st	ch_key(a0)
	clr.b	ch_note(a0)				;no note
	clr.b	ch_flags(a0)
	dbf	d0,.chan					;loop
	rts

;	The Z80 driver, the PCM samples and the FM patches are unchanged from 93; the pointer tables are written
;	with the labels; each sound and song event stream is its own file (loop pointers written as dc.l).
Z80_Program_Code					;The Z80 sound driver (93's, $28B bytes), built by asm80 from
									;src/sound/z80_snd_drv93.asm (output/obj/z80_snd_drv93.bin). p_initialZ80 copies
									;Z80ProgramLen ($295) bytes from here: the 10 bytes after the driver (the pad
									;byte and the start of pcm_sample_table) land below the Z80 stack top and are
									;never read as data.
	incbin	..\output\obj\z80_snd_drv93.bin,0,$278	;Z80 $0000-$0277
	;Z80 $0278 (z80_fm_patches_window): ld bc operand, the bank window address of the FM patches
	dc.b	fm_instrument_patches&$FF,((fm_instrument_patches>>8)&$7F)|$80
	;Z80 $027A: add hl,bc / ld a,n; $027C (z80_fm_patches_bank): the 32K bank of the FM patches
	dc.b	$09,$3E,fm_instrument_patches>>15
	incbin	..\output\obj\z80_snd_drv93.bin,$27D,$E	;Z80 $027D-$028A: jp SetBank, SelectPart
	dc.b	$FF						;pad: retail leftover byte
pcm_sample_table					;(sample address, 0) for PCM patches $60-$6E (lea in handle_command_10)
	dc.l	sfx_puckget_pcm,0		;patch $60
	dc.l	sfx_pass_pcm,0			;patch $61
	dc.l	sfx_shotbh_pcm,0		;patch $62
	dc.l	sfx_shotfh_pcm,0		;patch $63
	dc.l	sfx_check2_pcm,0		;patch $64
	dc.l	sfx_check_pcm,0			;patch $65
	dc.l	sfx_playerwall_pcm,0	;patch $66
	dc.l	sfx_hithigh_pcm,0		;patch $67
	dc.l	0,0						;patch $68
	dc.l	0,0						;patch $69
	dc.l	sfx_hithigh_pcm,0		;patch $6A
	dc.l	sfx_crowdboo_pcm,0		;patch $6B
	dc.l	sfx_oooh_pcm,0			;patch $6C
	dc.l	sfx_crowdcheer_pcm,0	;patch $6D
	dc.l	sfx_bglass_pcm,0		;patch $6E
sfx_shotbh_pcm						;raw PCM sample, played through the Z80 (pcm_sample_table)
	incbin	..\Extracted\NHL94\Sound\sfx_shotbh_pcm.bin	;sample 2: shotbh
	even
sfx_pass_pcm						;raw PCM sample, played through the Z80 (pcm_sample_table)
	incbin	..\Extracted\NHL94\Sound\sfx_pass_pcm.bin	;sample 1: pass
	dc.b	$FF						;pad: retail leftover byte
sfx_oooh_pcm						;raw PCM sample, played through the Z80 (pcm_sample_table)
	incbin	..\Extracted\NHL94\Sound\sfx_oooh_pcm.bin	;sample 12: oooh, sfx_oooh2, sfx_bglass
	even
sfx_crowdboo_pcm					;raw PCM sample, played through the Z80 (pcm_sample_table)
	incbin	..\Extracted\NHL94\Sound\sfx_crowdboo_pcm.bin	;sample 11: crowdboo
	dc.b	$FF						;pad: retail leftover byte
sfx_check_pcm						;raw PCM sample, played through the Z80 (pcm_sample_table)
	incbin	..\Extracted\NHL94\Sound\sfx_check_pcm.bin	;sample 5: check1, check3
	even
sfx_crowdcheer_pcm					;raw PCM sample, played through the Z80 (pcm_sample_table)
	incbin	..\Extracted\NHL94\Sound\sfx_crowdcheer_pcm.bin	;sample 13: crowdcheer, homewin
	even
sfx_bglass_pcm						;raw PCM sample, played through the Z80 (pcm_sample_table)
	incbin	..\Extracted\NHL94\Sound\sfx_bglass_pcm.bin	;sample 14: sfx_bglass
	dc.b	$FF						;pad: retail leftover byte
sfx_playerwall_pcm					;raw PCM sample, played through the Z80 (pcm_sample_table)
	incbin	..\Extracted\NHL94\Sound\sfx_playerwall_pcm.bin	;sample 6: playerwall, sfx_playerwall2-23
	even
sfx_check2_pcm						;raw PCM sample, played through the Z80 (pcm_sample_table)
	incbin	..\Extracted\NHL94\Sound\sfx_check2_pcm.bin	;sample 4: check2, check4
	dc.b	$FF						;pad: retail leftover byte
sfx_hithigh_pcm						;PCM samples 7 and 10: hithigh, hitlow, check1-4, songs $32 and $35-$37
	incbin	..\Extracted\NHL94\Sound\sfx_hithigh_pcm.bin	;samples 7 and 10: hithigh, hitlow, check1-4,
															;songs $32 and $35-$37
	even
sfx_shotfh_pcm						;raw PCM sample, played through the Z80 (pcm_sample_table)
	incbin	..\Extracted\NHL94\Sound\sfx_shotfh_pcm.bin	;sample 3: shotfh
	even
sfx_puckget_pcm						;raw PCM sample, played through the Z80 (pcm_sample_table)
	incbin	..\Extracted\NHL94\Sound\sfx_puckget_pcm.bin	;sample 0: puckget
	even
fm_instrument_patches				;32 FM patches x 32 bytes, patch_bendscale = pitch bend scale
									;(UpdateChannelFrequencyAndVolume)
	incbin	..\Extracted\NHL94\Sound\fm_instrument_patches.bin	;32 FM patches x 32 bytes (byte $1E = pitch
																;bend scale)
	even
SoundStreamTable					;event stream of sounds 0-$7A as long pointers (play_sfx_or_music_track)
	dc.l	sfx_siren_cmdstream		;sound $0
	dc.l	sfx_beep1_cmdstream		;sound $1
	dc.l	sfx_beep2_cmdstream		;sound $2
	dc.l	sfx_whistle_cmdstream	;sound $3
	dc.l	sfx_horn_cmdstream		;sound $4
	dc.l	sfx_shotwiff_cmdstream	;sound $5
	dc.l	sfx_stdef_cmdstream		;sound $6
	dc.l	sfx_puckget_cmdstream	;sound $7
	dc.l	sfx_oooh_cmdstream		;sound $8
	dc.l	sfx_hithigh_cmdstream	;sound $9
	dc.l	sfx_hitlow_cmdstream	;sound $A
	dc.l	sfx_crowdcheer_cmdstream	;sound $B
	dc.l	sfx_crowdboo_cmdstream	;sound $C
	dc.l	sfx_oooh2_cmdstream		;sound $D
	dc.l	sfx_bglass_cmdstream	;sound $E
	dc.l	sfx_homewin_cmdstream	;sound $F
	dc.l	sfx_pass1_cmdstream		;sound $10
	dc.l	sfx_pass2_cmdstream		;sound $11
	dc.l	sfx_pass3_cmdstream		;sound $12
	dc.l	sfx_pass4_cmdstream		;sound $13
	dc.l	sfx_shotbh1_cmdstream	;sound $14
	dc.l	sfx_shotbh2_cmdstream	;sound $15
	dc.l	sfx_shotbh3_cmdstream	;sound $16
	dc.l	sfx_shotbh4_cmdstream	;sound $17
	dc.l	sfx_shotfh1_cmdstream	;sound $18
	dc.l	sfx_shotfh2_cmdstream	;sound $19
	dc.l	sfx_shotfh3_cmdstream	;sound $1A
	dc.l	sfx_shotfh4_cmdstream	;sound $1B
	dc.l	sfx_check1_cmdstream	;sound $1C
	dc.l	sfx_check2_cmdstream	;sound $1D
	dc.l	sfx_check3_cmdstream	;sound $1E
	dc.l	sfx_check4_cmdstream	;sound $1F
	dc.l	sfx_playerwall_cmdstream	;sound $20
	dc.l	sfx_playerwall2_cmdstream	;sound $21
	dc.l	sfx_playerwall3_cmdstream	;sound $22
	dc.l	sfx_playerwall4_cmdstream	;sound $23
	dc.l	sfx_puckbody_cmdstream	;sound $24
	dc.l	sfx_puckpost_cmdstream	;sound $25
	dc.l	sfx_empty_cmdstream		;sound $26
	dc.l	sfx_empty_cmdstream		;sound $27
	dc.l	sfx_puckwall1_cmdstream	;sound $28
	dc.l	sfx_puckwall2_cmdstream	;sound $29
	dc.l	sfx_puckwall3_cmdstream	;sound $2A
	dc.l	sfx_puckwall4_cmdstream	;sound $2B
	dc.l	sfx_puckice1_cmdstream	;sound $2C
	dc.l	sfx_puckice2_cmdstream	;sound $2D
	dc.l	sfx_puckice3_cmdstream	;sound $2E
	dc.l	sfx_puckice4_cmdstream	;sound $2F
SongPointerTable					;the songs $30-$7A of SoundStreamTable (stop_current_song reads the first)
	dc.l	fmtune_id_30_cmdstream	;song $30
	dc.l	fmtune_id_31_cmdstream	;song $31
	dc.l	fmtune_id_32_cmdstream	;song $32
	dc.l	fmtune_id_33_cmdstream	;song $33
	dc.l	fmtune_id_34_cmdstream	;song $34
	dc.l	fmtune_id_35_cmdstream	;song $35
	dc.l	fmtune_id_36_cmdstream	;song $36
	dc.l	fmtune_id_37_cmdstream	;song $37
	dc.l	fmtune_id_38_cmdstream	;song $38
	dc.l	fmtune_id_39_cmdstream	;song $39
	dc.l	fmtune_id_3A_cmdstream	;song $3A
	dc.l	fmtune_id_3B_cmdstream	;song $3B
	dc.l	fmtune_id_3C_cmdstream	;song $3C
	dc.l	fmtune_id_3D_cmdstream	;song $3D
	dc.l	fmtune_id_3E_cmdstream	;song $3E
	dc.l	fmtune_id_3F_cmdstream	;song $3F
	dc.l	fmtune_id_40_cmdstream	;song $40
	dc.l	fmtune_id_41_cmdstream	;song $41
	dc.l	fmtune_id_42_cmdstream	;song $42
	dc.l	fmtune_id_43_cmdstream	;song $43
	dc.l	fmtune_id_44_cmdstream	;song $44
	dc.l	fmtune_id_45_cmdstream	;song $45
	dc.l	fmtune_id_46_cmdstream	;song $46
	dc.l	fmtune_id_47_cmdstream	;song $47
	dc.l	fmtune_id_48_cmdstream	;song $48
	dc.l	fmtune_id_49_cmdstream	;song $49
	dc.l	fmtune_id_4A_cmdstream	;song $4A
	dc.l	fmtune_id_4B_cmdstream	;song $4B
	dc.l	fmtune_id_4C_cmdstream	;song $4C
	dc.l	fmtune_id_4D_cmdstream	;song $4D
	dc.l	fmtune_id_4E_cmdstream	;song $4E
	dc.l	fmtune_id_4F_cmdstream	;song $4F
	dc.l	fmtune_id_50_cmdstream	;song $50
	dc.l	fmtune_id_51_cmdstream	;song $51
	dc.l	fmtune_id_52_cmdstream	;song $52
	dc.l	fmtune_id_53_cmdstream	;song $53
	dc.l	fmtune_id_54_cmdstream	;song $54
	dc.l	fmtune_id_55_cmdstream	;song $55
	dc.l	fmtune_id_56_cmdstream	;song $56
	dc.l	fmtune_id_57_cmdstream	;song $57
	dc.l	fmtune_id_58_cmdstream	;song $58
	dc.l	fmtune_id_59_cmdstream	;song $59
	dc.l	fmtune_id_5A_cmdstream	;song $5A
	dc.l	fmtune_id_5B_cmdstream	;song $5B
	dc.l	fmtune_id_5C_cmdstream	;song $5C
	dc.l	fmtune_id_5D_cmdstream	;song $5D
	dc.l	fmtune_id_5E_cmdstream	;song $5E
	dc.l	fmtune_id_5F_cmdstream	;song $5F
	dc.l	fmtune_id_60_cmdstream	;song $60
	dc.l	fmtune_id_61_cmdstream	;song $61
	dc.l	fmtune_id_62_cmdstream	;song $62
	dc.l	fmtune_id_63_cmdstream	;song $63
	dc.l	fmtune_id_64_cmdstream	;song $64
	dc.l	fmtune_id_65_cmdstream	;song $65
	dc.l	fmtune_id_66_cmdstream	;song $66
	dc.l	fmtune_id_67_cmdstream	;song $67
	dc.l	fmtune_id_68_cmdstream	;song $68
	dc.l	fmtune_id_69_cmdstream	;song $69
	dc.l	fmtune_id_6A_cmdstream	;song $6A
	dc.l	fmtune_id_6B_cmdstream	;song $6B
	dc.l	fmtune_id_6C_cmdstream	;song $6C
	dc.l	fmtune_id_6D_cmdstream	;song $6D
	dc.l	fmtune_id_6E_cmdstream	;song $6E
	dc.l	fmtune_id_6F_cmdstream	;song $6F
	dc.l	fmtune_id_70_cmdstream	;song $70
	dc.l	fmtune_id_71_cmdstream	;song $71
	dc.l	fmtune_id_72_cmdstream	;song $72
	dc.l	fmtune_id_73_cmdstream	;song $73
	dc.l	fmtune_id_74_cmdstream	;song $74
	dc.l	fmtune_id_75_cmdstream	;song $75
	dc.l	fmtune_id_76_cmdstream	;song $76
	dc.l	fmtune_id_77_cmdstream	;song $77
	dc.l	fmtune_title_cmdstream	;song $78
	dc.l	fmtune_eop_cmdstream	;song $79
	dc.l	fmtune_scouting_cmdstream	;song $7A
sfx_beep1_cmdstream					;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_beep1_cmdstream.bin	;sound $1 (SFXbeep1)
	even
sfx_empty_cmdstream					;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_empty_cmdstream.bin	;sound $26, sound $27
	even
sfx_beep2_cmdstream					;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_beep2_cmdstream.bin	;sound $2 (SFXbeep2)
	even
sfx_horn_cmdstream					;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_horn_cmdstream.bin	;sound $4
	even
sfx_stdef_cmdstream					;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_stdef_cmdstream.bin	;sound $6
	even
sfx_puckget_cmdstream				;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_puckget_cmdstream.bin	;sound $7
	even
sfx_puckice1_cmdstream				;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_puckice1_cmdstream.bin	;sound $2C
	even
sfx_puckice2_cmdstream				;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_puckice2_cmdstream.bin	;sound $2D
	even
sfx_puckice3_cmdstream				;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_puckice3_cmdstream.bin	;sound $2E
	even
sfx_puckice4_cmdstream				;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_puckice4_cmdstream.bin	;sound $2F
	even
sfx_puckbody_cmdstream				;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_puckbody_cmdstream.bin	;sound $24
	even
sfx_oooh_cmdstream					;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_oooh_cmdstream.bin	;sound $8
	even
sfx_puckpost_cmdstream				;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_puckpost_cmdstream.bin	;sound $25
	even
sfx_playerwall_cmdstream			;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_playerwall_cmdstream.bin	;sound $20
	even
sfx_playerwall2_cmdstream			;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_playerwall2_cmdstream.bin	;sound $21
	even
sfx_playerwall3_cmdstream			;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_playerwall3_cmdstream.bin	;sound $22
	even
sfx_playerwall4_cmdstream			;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_playerwall4_cmdstream.bin	;sound $23
	even
sfx_puckwall1_cmdstream				;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_puckwall1_cmdstream.bin	;sound $28
	even
sfx_puckwall2_cmdstream				;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_puckwall2_cmdstream.bin	;sound $29
	even
sfx_puckwall3_cmdstream				;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_puckwall3_cmdstream.bin	;sound $2A
	even
sfx_puckwall4_cmdstream				;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_puckwall4_cmdstream.bin	;sound $2B
	even
sfx_whistle_cmdstream				;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_whistle_cmdstream.bin	;sound $3
	even
	dc.b	$FF,$FF					;pad: retail leftover bytes
sfx_shotwiff_cmdstream				;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_shotwiff_cmdstream.bin	;sound $5
	even
sfx_check1_cmdstream				;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_check1_cmdstream.bin	;sound $1C
	even
sfx_check2_cmdstream				;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_check2_cmdstream.bin	;sound $1D
	even
sfx_check3_cmdstream				;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_check3_cmdstream.bin	;sound $1E
	even
sfx_check4_cmdstream				;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_check4_cmdstream.bin	;sound $1F
	even
sfx_pass1_cmdstream					;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_pass1_cmdstream.bin	;sound $10
	even
sfx_pass2_cmdstream					;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_pass2_cmdstream.bin	;sound $11
	even
sfx_pass3_cmdstream					;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_pass3_cmdstream.bin	;sound $12
	even
sfx_pass4_cmdstream					;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_pass4_cmdstream.bin	;sound $13
	even
sfx_shotbh1_cmdstream				;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_shotbh1_cmdstream.bin	;sound $14
	even
sfx_shotbh2_cmdstream				;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_shotbh2_cmdstream.bin	;sound $15
	even
sfx_shotbh3_cmdstream				;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_shotbh3_cmdstream.bin	;sound $16
	even
sfx_shotbh4_cmdstream				;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_shotbh4_cmdstream.bin	;sound $17
	even
sfx_shotfh1_cmdstream				;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_shotfh1_cmdstream.bin	;sound $18
	even
sfx_shotfh2_cmdstream				;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_shotfh2_cmdstream.bin	;sound $19
	even
sfx_shotfh3_cmdstream				;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_shotfh3_cmdstream.bin	;sound $1A
	even
sfx_shotfh4_cmdstream				;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_shotfh4_cmdstream.bin	;sound $1B
	even
sfx_hithigh_cmdstream				;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_hithigh_cmdstream.bin	;sound $9 (SFXhithigh)
	even
sfx_hitlow_cmdstream				;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_hitlow_cmdstream.bin	;sound $A (SFXhitlow)
	even
sfx_homewin_cmdstream				;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_homewin_cmdstream.bin	;sound $F
	even
sfx_crowdcheer_cmdstream			;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_crowdcheer_cmdstream.bin	;sound $B (SFXcrowdcheer)
	even
sfx_crowdboo_cmdstream				;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_crowdboo_cmdstream.bin	;sound $C (SFXcrowdboo)
	even
sfx_bglass_cmdstream				;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_bglass_cmdstream.bin	;sound $E
	even
sfx_oooh2_cmdstream					;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_oooh2_cmdstream.bin	;sound $D
	even
sfx_siren_cmdstream					;sound effect event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\sfx_siren_cmdstream.bin	;sound $0
	even
fmtune_id_30_cmdstream				;song $30 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_30_cmdstream.bin	;song $30: ChooseSong, TeamSongs BOS
	even
fmtune_id_31_cmdstream				;song $31 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_31_cmdstream.bin	;song $31: ChooseSong, TeamSongs BOS
	even
fmtune_id_32_cmdstream				;song $32 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_32_cmdstream.bin	;song $32: ChooseSong, TeamSongs BOS
	even
fmtune_id_33_cmdstream				;song $33 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_33_cmdstream.bin	;song $33: ChooseSong, TeamSongs BUF
	even
fmtune_id_34_cmdstream				;song $34 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_34_cmdstream.bin	;song $34: ChooseSong, TeamSongs BUF,
																;RandomSongs
	even
fmtune_id_35_cmdstream				;song $35 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_35_cmdstream.bin	;song $35: ChooseSong, TeamSongs CGY
	even
fmtune_id_36_cmdstream				;song $36 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_36_cmdstream.bin	;song $36: ChooseSong, TeamSongs CGY
	even
fmtune_id_37_cmdstream				;song $37 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_37_cmdstream.bin	;song $37: ChooseSong, TeamSongs CGY
	even
fmtune_id_38_cmdstream				;song $38 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_38_cmdstream.bin	;song $38: ChooseSong, TeamSongs CHI
	even
fmtune_id_39_cmdstream				;song $39 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_39_cmdstream.bin	;song $39: ChooseSong, TeamSongs CHI
	even
fmtune_id_3A_cmdstream				;song $3A event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_3A_cmdstream.bin	;song $3A: ChooseSong, TeamSongs CHI
	even
fmtune_id_3B_cmdstream				;song $3B event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_3B_cmdstream.bin	;song $3B: ChooseSong, TeamSongs DET
	even
fmtune_id_3C_cmdstream				;song $3C event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_3C_cmdstream.bin	;song $3C: ChooseSong, TeamSongs DET
	even
fmtune_id_3D_cmdstream				;song $3D event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_3D_cmdstream.bin	;song $3D: ChooseSong, TeamSongs DET
	even
fmtune_id_3E_cmdstream				;song $3E event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_3E_cmdstream.bin	;song $3E: ChooseSong, TeamSongs EDM
	even
fmtune_id_3F_cmdstream				;song $3F event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_3F_cmdstream.bin	;song $3F: ChooseSong, TeamSongs EDM
	even
fmtune_id_40_cmdstream				;song $40 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_40_cmdstream.bin	;song $40: ChooseSong, TeamSongs HFD,
																;RandomSongs
	even
fmtune_id_41_cmdstream				;song $41 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_41_cmdstream.bin	;song $41: ChooseSong, TeamSongs HFD
	even
fmtune_id_42_cmdstream				;song $42 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_42_cmdstream.bin	;song $42: ChooseSong, TeamSongs HFD,
																;RandomSongs
	even
fmtune_id_43_cmdstream				;song $43 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_43_cmdstream.bin	;song $43: ChooseSong, TeamSongs LA
	even
fmtune_id_44_cmdstream				;song $44 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_44_cmdstream.bin	;song $44: ChooseSong, TeamSongs LA
	even
fmtune_id_45_cmdstream				;song $45 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_45_cmdstream.bin	;song $45: ChooseSong, TeamSongs LA
	even
fmtune_id_46_cmdstream				;song $46 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_46_cmdstream.bin	;song $46: ChooseSong, TeamSongs LA
	even
fmtune_id_47_cmdstream				;song $47 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_47_cmdstream.bin	;song $47: ChooseSong, TeamSongs NYI
	even
fmtune_id_48_cmdstream				;song $48 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_48_cmdstream.bin	;song $48: ChooseSong, TeamSongs NYI
	even
fmtune_id_49_cmdstream				;song $49 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_49_cmdstream.bin	;song $49: ChooseSong, TeamSongs NYI,
																;RandomSongs
	even
fmtune_id_4A_cmdstream				;song $4A event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_4A_cmdstream.bin	;song $4A: ChooseSong, TeamSongs DAL
	even
fmtune_id_4B_cmdstream				;song $4B event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_4B_cmdstream.bin	;song $4B: ChooseSong, TeamSongs DAL
	even
fmtune_id_4C_cmdstream				;song $4C event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_4C_cmdstream.bin	;song $4C: ChooseSong, TeamSongs MTL
	even
fmtune_id_4D_cmdstream				;song $4D event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_4D_cmdstream.bin	;song $4D: ChooseSong, TeamSongs MTL
	even
fmtune_id_4E_cmdstream				;song $4E event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_4E_cmdstream.bin	;song $4E: ChooseSong, TeamSongs MTL
	even
fmtune_id_4F_cmdstream				;song $4F event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_4F_cmdstream.bin	;song $4F: ChooseSong, TeamSongs MTL
	even
fmtune_id_50_cmdstream				;song $50 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_50_cmdstream.bin	;song $50: ChooseSong, TeamSongs NJ
	even
fmtune_id_51_cmdstream				;song $51 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_51_cmdstream.bin	;song $51: ChooseSong, TeamSongs NJ
	even
fmtune_id_52_cmdstream				;song $52 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_52_cmdstream.bin	;song $52: ChooseSong, TeamSongs NJ
	even
fmtune_id_53_cmdstream				;song $53 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_53_cmdstream.bin	;song $53: ChooseSong, TeamSongs NYR / ASE /
																;ASW
	even
fmtune_id_54_cmdstream				;song $54 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_54_cmdstream.bin	;song $54: ChooseSong, TeamSongs NYR / ASE /
																;ASW
	even
fmtune_id_55_cmdstream				;song $55 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_55_cmdstream.bin	;song $55: ChooseSong, TeamSongs NYR / ASE /
																;ASW
	even
fmtune_id_56_cmdstream				;song $56 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_56_cmdstream.bin	;song $56: ChooseSong, TeamSongs PHI
	even
fmtune_id_57_cmdstream				;song $57 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_57_cmdstream.bin	;song $57: ChooseSong, TeamSongs PHI
	even
fmtune_id_58_cmdstream				;song $58 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_58_cmdstream.bin	;song $58: ChooseSong, TeamSongs PHI,
																;RandomSongs
	even
fmtune_id_59_cmdstream				;song $59 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_59_cmdstream.bin	;song $59: ChooseSong, TeamSongs PIT
	even
fmtune_id_5A_cmdstream				;song $5A event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_5A_cmdstream.bin	;song $5A: ChooseSong, TeamSongs (25 teams:
																;all but CGY, PHI and SJ)
	even
fmtune_id_5B_cmdstream				;song $5B event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_5B_cmdstream.bin	;song $5B: ChooseSong, TeamSongs PIT
	even
fmtune_id_5C_cmdstream				;song $5C event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_5C_cmdstream.bin	;song $5C: ChooseSong, TeamSongs PIT,
																;RandomSongs
	even
fmtune_id_5D_cmdstream				;song $5D event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_5D_cmdstream.bin	;song $5D: ChooseSong, TeamSongs QUE
	even
fmtune_id_5E_cmdstream				;song $5E event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_5E_cmdstream.bin	;song $5E: ChooseSong, TeamSongs QUE
	even
fmtune_id_5F_cmdstream				;song $5F event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_5F_cmdstream.bin	;song $5F: ChooseSong, TeamSongs SJ
	even
fmtune_id_60_cmdstream				;song $60 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_60_cmdstream.bin	;song $60: ChooseSong, TeamSongs SJ
	even
fmtune_id_61_cmdstream				;song $61 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_61_cmdstream.bin	;song $61: ChooseSong, TeamSongs SJ
	even
fmtune_id_62_cmdstream				;song $62 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_62_cmdstream.bin	;song $62: ChooseSong, not in TeamSongs or
																;RandomSongs
	even
fmtune_id_63_cmdstream				;song $63 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_63_cmdstream.bin	;song $63: ChooseSong, TeamSongs SJ
	even
fmtune_id_64_cmdstream				;song $64 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_64_cmdstream.bin	;song $64: ChooseSong, TeamSongs SJ
	even
fmtune_id_65_cmdstream				;song $65 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_65_cmdstream.bin	;song $65: ChooseSong, TeamSongs CHI / SJ,
																;RandomSongs
	even
fmtune_id_66_cmdstream				;song $66 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_66_cmdstream.bin	;song $66: ChooseSong, RandomSongs
	even
fmtune_id_67_cmdstream				;song $67 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_67_cmdstream.bin	;song $67: ChooseSong, TeamSongs STL
	even
fmtune_id_68_cmdstream				;song $68 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_68_cmdstream.bin	;song $68: ChooseSong, TeamSongs STL
	even
fmtune_id_69_cmdstream				;song $69 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_69_cmdstream.bin	;song $69: ChooseSong, TeamSongs STL
	even
fmtune_id_6A_cmdstream				;song $6A event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_6A_cmdstream.bin	;song $6A: ChooseSong, TeamSongs TB
	even
fmtune_id_6B_cmdstream				;song $6B event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_6B_cmdstream.bin	;song $6B: ChooseSong, TeamSongs TB
	even
fmtune_id_6C_cmdstream				;song $6C event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_6C_cmdstream.bin	;song $6C: ChooseSong, TeamSongs TOR
	even
fmtune_id_6D_cmdstream				;song $6D event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_6D_cmdstream.bin	;song $6D: ChooseSong, TeamSongs TOR
	even
fmtune_id_6E_cmdstream				;song $6E event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_6E_cmdstream.bin	;song $6E: ChooseSong, TeamSongs VAN
	even
fmtune_id_6F_cmdstream				;song $6F event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_6F_cmdstream.bin	;song $6F: ChooseSong, TeamSongs VAN
	even
fmtune_id_70_cmdstream				;song $70 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_70_cmdstream.bin	;song $70: ChooseSong, TeamSongs VAN
	even
fmtune_id_71_cmdstream				;song $71 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_71_cmdstream.bin	;song $71: ChooseSong, TeamSongs WSH
	even
fmtune_id_72_cmdstream				;song $72 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_72_cmdstream.bin	;song $72: ChooseSong, not in TeamSongs or
																;RandomSongs
	even
fmtune_id_73_cmdstream				;song $73 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_73_cmdstream.bin	;song $73: ChooseSong, TeamSongs WSH
	even
fmtune_id_74_cmdstream				;song $74 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_74_cmdstream.bin	;song $74: ChooseSong, TeamSongs WSH
	even
fmtune_id_75_cmdstream				;song $75 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_75_cmdstream.bin	;song $75: ChooseSong, TeamSongs ANH / FLA /
																;OTW / WPG
	even
fmtune_id_76_cmdstream				;song $76 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_76_cmdstream.bin	;song $76: ChooseSong, TeamSongs ANH / FLA /
																;OTW / WPG
	even
fmtune_id_77_cmdstream				;song $77 event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_id_77_cmdstream.bin	;song $77: ChooseSong, TeamSongs ANH / FLA /
																;OTW / WPG
	even
fmtune_title_cmdstream				;song event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_title_cmdstream94.bin	;song $78: ExitToOpening, newTitleScreen.
									;One stream that loops to its start
	even
	dc.l	fmtune_title_cmdstream	;loop pointer
fmtune_eop_cmdstream				;song event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_eop_cmdstream94.bin	;song $79: PeriodOver_sp, StartHL2
	even
	dc.l	fmtune_eop_cmdstream+4	;loop pointer (past the first event)
fmtune_scouting_cmdstream			;song event stream (SoundStreamTable)
	incbin	..\Extracted\NHL94\Sound\fmtune_scouting_cmdstream94.bin	;song $7A: ScoutingReport
	even
	dc.l	fmtune_scouting_cmdstream+4	;loop pointer (past the first event)
