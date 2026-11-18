	include	segacd\ram94cd.asm
	include	macros\genesis.mac

	org	$1B000

	include	..\output\obj\hockey_teamdata.asm
	include	frames94.asm					;sprite animation tables, the same file the cartridge includes
	include	segacd\hockey\cdhockey94cd.asm
	include	segacd\hockey\onetimer94cd.asm
	include	segacd\hockey\fourway94cd.asm
	include	segacd\hockey\crowd94cd.asm
	include	segacd\hockey\optsetup94cd.asm
	include	segacd\hockey\cards94cd.asm
	include	segacd\hockey\records94cd.asm
	include	segacd\hockey\shootout94cd.asm
	include	segacd\hockey\scout94cd.asm
	include	segacd\hockey\period94cd.asm
	include	segacd\hockey\arena94cd.asm
	include	segacd\hockey\shootoutpath94cd.asm
	include	segacd\hockey\ui94cd.asm
	include	segacd\hockey\helpers94cd.asm
	include	segacd\hockey\logos94cd.asm
	include	segacd\hockey\hockey94cd.asm
	include	segacd\hockey\menu94cd.asm
	include	segacd\hockey\stats94cd.asm
	include	segacd\hockey\replay94cd.asm
	include	segacd\hockey\logic94cd.asm			; nests periodover94cd.asm between EndfaceoffData and ClearOffsidesIfAllPlayers
	include	segacd\hockey\middle94cd.asm
	include	segacd\hockey\decompress94cd.asm
	include	segacd\hockey\print94cd.asm
	include	segacd\hockey\penalty94cd.asm
	include	segacd\hockey\collide94cd.asm			; nests scoreboard94cd.asm between setpde and setpersonel
	include	segacd\hockey\video94cd.asm
	include	segacd\hockey\setup94cd.asm
	include	segacd\hockey\tables94cd.asm
	include	segacd\hockey\graphics94cd.asm
