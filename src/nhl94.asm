;
;	NHL 94 ROM include list, in ROM order. hockey94.asm (the full build, build94.bat, npm run build:retail) includes it.
;	Each file assembles at the address after the one before it. The org for a segment build is in its _stub.asm (main94.asm keeps its org 0 / org $100).
;	The address on each line is the retail lst/nhl94.bin start address. See SEGMENT_AGENT.md "ROM map".
;
	include	main94.asm		; $000000  Adapted from main93.asm: header, startup, vectors
	include	teamdata94.asm		; $00030A  Adapted from teamdata93.asm: teams, palettes, credits text
	include	frames94.asm		; $005B1C  Adapted from frames93.asm: sprite animation tables
	include	ram94.asm		;          Adapted from ram93.asm: equates only
	include	game94.asm		; $0076B2  Adapted from hockey93.asm: game loop, pause
	include	menu94.asm		; $007E36  Adapted from menu93.asm: menu core
	include	stats94.asm		; $0080D4  Adapted from stats93.asm: scores, line editor, roster, scoring and penalty summaries, player stats, crowd meter, goalie select
	include	replay94.asm		; $009FD0  Adapted from hockey93.asm: replay
	include	input94.asm		; $00B0E8  Adapted from logic93.asm: controller input and line changes
	include	assign94.asm		; $00C710  Adapted from logic93.asm: player assignments
	include	checks94.asm		; $00D09C  Adapted from logic93.asm: checks before the display code
	include	video94.asm		; $010EE0  Adapted from video93.asm: display helpers
	include	penalty94.asm		; $011F2C  Adapted from penalty93.asm: penalties, scoreboard, highlights
	include	collide94.asm		; $0138AC  Adapted from hockey93.asm: puck, players, walls, fights, goals
	include	display94.asm		; $015D9A  Adapted from video93.asm: vblank, clock, crowd, rink scroll
	include	setup94.asm		; $0169FA  Adapted from hockey93.asm: ice setup, intermission, playoff screen
	include	attract94.asm		; $017A18  NEW in 94: EA Sports attract screen
	include	data94.asm		; $017C72  Adapted from hockey93.asm: menus, season results, string tables
	include	sram94.asm		; $01A050  Adapted from sram93.asm: save data
	include	sound94.asm		; $01A264  Adapted from sound93.asm: sound driver, then the sound data
	include	graphics94.asm		; $04B5C0  Adapted from graphics93.asm: graphics only
	include	onetimer94.asm		; $0F66EE  NEW in 94: one-timer
	include	fourway94.asm		; $0F6D5E  NEW in 94: four-player adaptor
	include	crowd94.asm		; $0F6E8A  NEW in 94: crowd meter and hot / cold players
	include	optsetup94.asm		; $0F739E  Adapted from hockey93.asm, expanded: game setup and options
	include	cards94.asm		; $0F8B5A  NEW in 94: player cards and matchup palettes
	include	records94.asm		; $0FBB88  NEW in 94: name entry and record holders
	include	shootout94.asm		; $0FC47C  NEW in 94: shootout
	include	scout94.asm		; $0FCB9A  NEW in 94: matchups and scouting report
	include	period94.asm		; $0FD618  NEW in 94: period stats and game statistics
	include	goalie94.asm		; $0FE1D8  NEW in 94: manual goalie
	include	title94.asm		; $0FE556  NEW in 94: song select, title, credits
	include	checksum94.asm		; $0FFAC0  Adapted from checksum93.asm: checksum
	dcb.b	$100000-*,$FF		;$0FFB10-$0FFFFF  $FF fill to the 1 MB ROM end
