;	Top level of the ROM build. Includes every module in ROM order; ram94.asm (after frames94)
;	holds the ports, structure offsets and RAM map. Each file assembles at the address after
;	the one before it.
;
;	teamdata94.asm is included as a copy in output/obj/ with the real player names and
;	team nicknames put back by tools/build.js. The file in src/ has placeholders and needs
;	the original ROM.
;
;	The two New York full names in optsetup94.asm are included from
;	Extracted/NHL94/Text (asm the extractor generates).

	include	main94.asm				; $000000 header, startup, vectors
	include	..\output\obj\teamdata94.asm	; $00030A teams, palettes, credits text
	include	frames94.asm			; $005B1C sprite animation tables
	include	ram94.asm				;ports, structure offsets and RAM map (rs), after frames94 like
									;93 so Stack is the reset vector value until ram94 redefines
									;it. Equates only
	include	hockey94.asm			; $0076B2 game loop, pause
	include	menu94.asm				; $007E36 menu core
	include	stats94.asm				;$0080D4 scores, line editor, roster, scoring and penalty summaries,
									;player stats, crowd meter, goalie select
	include	replay94.asm			; $009FD0 replay
	include	logic94.asm				; $00A9D6 player update, input, assignments
	include	middle94.asm			; $010E88 shared helpers, decompress, print
	include	penalty94.asm			; $011F2C penalties, scoreboard, highlights
	include	collide94.asm			; $0138AC puck, players, walls, fights, goals
	include	video94.asm				; $015D9A vblank, clock, crowd, rink scroll
	include	setup94.asm				; $0169FA ice setup, attract, menus, playoff data
	include	tables94.asm			; $018CFC crowd frames, asstab, penalties, playoff tree, menus
	include	sram94.asm				; $01A050 save data
	include	sound\sound94.asm		; $01A264 sound driver, then the sound data
	include	graphics94.asm			; $04B5C0 graphics only
	include	onetimer94.asm			; $0F66EE  NEW in 94: one-timer
	include	fourway94.asm			; $0F6D5E  NEW in 94: four-player adaptor
	include	crowd94.asm				; $0F6E8A  NEW in 94: crowd meter and hot / cold players
	include	optsetup94.asm			; $0F739E expanded: game setup and options
	include	cards94.asm				; $0F87D2  NEW in 94: player cards and matchup palettes
	include	records94.asm			; $0FB018  NEW in 94: name entry and record holders
	include	shootout94.asm			; $0FC320  NEW in 94: shootout
	include	scout94.asm				; $0FCB9A  NEW in 94: matchups and scouting report
	include	period94.asm			; $0FD618  NEW in 94: period stats and game statistics
	include	goalie94.asm			; $0FE1D8  NEW in 94: manual goalie
	include	title94.asm				; $0FE556  NEW in 94: song select, title, credits
	include	checksum94.asm			; $0FFAC0 checksum
	dcb.b	$100000-*,$FF			;fill the retail 1MB image. Includes for a larger ROM go after this line;
									;tools/fixrom.js pads the image and sets the header ROM end
									;(docs/EXPANDING_THE_ROM.md)
	include	shortcalls.inc			; checks only: the routines the retail code calls with .w stay below $8000
