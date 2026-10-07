;
;	Top level of the full NHL 94 ROM build (build94.bat, npm run build:retail).
;	The includes are in address order: each file assembles at the address after the one before it.
;	The address after each include is the retail lst/nhl94.bin address (inclusive). See SEGMENT_AGENT.md "ROM map".
;	Ram94.Asm has no active lines; the ports, VDP status bits and RAM names are in stubinc, as in each *_stub.asm.
;
	include	stubinc\ports.inc	;IO_* / VDP_* ports. Equates only
	include	stubinc\equals.inc	;VDP status bits. Equates only
	include	stubinc\ram_addrs.inc	;RAM names. Equates only

	include	Main94.Asm		;$000000-$000309  vectors, header, SegaInit, Start
	include	TeamData94.Asm		;$00030A-$005B1B  TeamList, team blocks, playoffseats, Credits
	include	Frames94.Asm		;$005B1C-$0076B1  SPAlist: graphics data table for Sprites.anim
	include	Ram94.Asm		;no ROM bytes (equates only)

	include	hockey94_01.asm		;$0076B2-$007E35  VBjsr, Begin ... Pausemode, SetupPauseScreen, seta2
	include	menu94.asm		;$007E36-$0080D3  InitMenuState ... vcountwait (menu engine)
	include	stats94.asm		;$0080D4-$009FCF  ShowScores ... WaitVSyncAndReadInput (stats screens)
	include	hockey94_02.asm		;$009FD0-$00B0E7  ReplayMode ... checkwindow
	include	logic94_1.asm		;$00B0E8-$00C70F  doinput ... check4bench
	include	logic94_2.asm		;$00C710-$00D09B  assbench ... asswingd
	include	logic94_3.asm		;$00D09C-$00E62D  asswingo ... EvadePC
	include	logic94_4.asm		;$00E62E-$00FFE9  checkob ... pucknorm
	include	logic94_5.asm		;$00FFEA-$010EDF  ChkOffsides ... WeightedRandomSelect
	include	middle94_1.asm		;$010EE0-$011699  remap ... Vmaddr
	include	middle94_2.asm		;$01169A-$011F2B  dobitmap ... AddTeamBlock
	include	penalty94_1.asm		;$011F2C-$012C03  AddPenalty ... SetHor
	include	penalty94_2.asm		;$012C04-$0138AB  PrintScores1 ... StartHL2
	include	hockey94_03.asm		;$0138AC-$014549  checkcoll ... setInjuryType
	include	hockey94_04.asm		;$01454A-$0150E3  checkfight ... checkpuckcoll
	include	hockey94_05.asm		;$0150E4-$015D99  puckstick ... ClampNibble
	include	video94_1.asm		;$015D9A-$0162FD  VBlank ... showcrowd
	include	video94_2.asm		;$0162FE-$0169F9  showclock ... KillCrowd
	include	hockey94_06.asm		;$0169FA-$017A17  setupice ... PeriodOver, Opening, PlayoffScreen, text player
	include	attract94.asm		;$017A18-$017C71  EASportsScreen ... VBlank_SetOptions
	include	hockey94_09.asm		;$017C72-$01837F  DefaultMenus, NewPO, MakeTree, FigureJoy, password code
	include	hockey94_10.asm		;$018380-$018CFB  ResolveGames ... exception handlers, crash
	include	hockey94_11.asm		;$018CFC-$01A04F  data: cd0, asstab, PenaltyList ... menu and pause text
	include	sram94.asm		;$01A050-$01A263  InitSaveRAM ... ReadSRAM (battery save RAM)
	include	sound94.asm		;$01A264-$04B5BF  p_turnoff ... ClearAllTrackAndSFXSlots (68k sound driver), then Z80 program and sound data (incbin)
	include	graphics94.asm		;$04B5C0-$0F66ED  MATCHUPS script, graphics (incbin)
	include	high94_1.asm		;$0F66EE-$0F739D  puckvzadj ... one-timer, 4 way play test, crowd meter, hot / cold
	include	hockey94_08.asm		;$0F739E-$0F8B59  GameSetUp ... setoptions (game setup screen)
	include	high94_2.asm		;$0F8B5A-$0FCB99  wallcollduringcheck ... save RAM records, Player Cards, shootout
	include	hockey94_07.asm		;$0FCB9A-$0FD617  ScoutingReport (MATCHUPS screen)
	include	high94_3.asm		;$0FD618-$0FFABF  arena animations, Game Statistics, ChooseSong, title, credits
	include	checksum94.asm		;$0FFAC0-$0FFB0F  ValidationRoutine
	dcb.b	$100000-*,$FF		;$0FFB10-$0FFFFF  $FF fill to the 1 MB ROM end
