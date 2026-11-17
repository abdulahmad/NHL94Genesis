	include	equates94.asm
	include	segacd\hockey.inc
	include	macros\genesis.mac

	org	$1B000

	include	..\output\obj\hockey_teamdata.asm
	include	frames94.asm					;sprite animation tables, the same file the cartridge includes
	include	segacd\hockey\cdhockey.asm
	include	segacd\hockey\onetimer94.asm
	include	segacd\hockey\fourway94.asm
	include	segacd\hockey\crowd94.asm
	include	segacd\hockey\optsetup94.asm
	include	segacd\hockey\cards94.asm
	include	segacd\hockey\records94.asm
	include	segacd\hockey\shootout94.asm
	include	segacd\hockey\scout94.asm
	include	segacd\hockey\period94.asm
	include	segacd\hockey\arena94.asm
	include	segacd\hockey\shootoutpath94.asm
	include	segacd\hockey\ui94.asm
	include	segacd\hockey\helpers94.asm
	include	segacd\hockey\logos94.asm
	include	segacd\hockey\hockey94.asm
	include	segacd\hockey\menu94.asm
	include	segacd\hockey\stats94.asm
	include	segacd\hockey\replay94.asm
	include	segacd\hockey\logic94.asm			; nests periodover94.asm between EndfaceoffData and ClearOffsidesIfAllPlayers
	include	segacd\hockey\middle94.asm
	include	segacd\hockey\decompress94.asm
	include	segacd\hockey\print94.asm
	include	segacd\hockey\penalty94.asm
	include	segacd\hockey\collide94.asm			; nests scoreboard94.asm between setpde and setpersonel
	include	segacd\hockey\video94.asm
	include	segacd\hockey\setup94.asm
	include	segacd\hockey\tables94.asm
	include	segacd\hockey\graphics94.asm
