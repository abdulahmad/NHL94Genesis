;	New in 95: the season schedule, one record for each day of the season with the games played
;	on it.

;	Layout: a day count, then one record per day: the number of games, then two team
;	numbers per game (TeamList order). Each day is written with the Day macro: list the
;	matchups as team abbreviations in pairs; a day with no games is just "Day".
;	The schedule stores no dates. DayToDate walks SeasonDay+4 through MonthDays, so SeasonDay
;	0 is October 5 and the last day is April 14 (the 1993-94 NHL season). FindDayGames reads
;	record (SeasonStartDay + SeasonDay) mod the day count; with the random schedule option
;	off SeasonStartDay is 0, so "day n" below is SeasonDay n-1.

;	Team numbers ANH ... WPG: stubinc/equals.inc

SeasonSchedule	;The season schedule (read by PickSeasonStartDay, BuildSeasonTeamList, WriteDayGames, ...)
	dc.b	192	;days
	Day	NYR,BOS,  PHI,PIT,  DAL,DET,  CGY,NYI                                                                                  ;day 1
	Day	OTW,QUE,  MTL,HFD,  NJ, TB,   CHI,FLA,  WPG,WSH,  EDM,SJ,   LA, VAN                                                    ;day 2
	Day	BOS,BUF,  PIT,MTL,  NYR,TB,   TOR,DAL,  STL,FLA,  CGY,SJ                                                               ;day 3
	Day	WSH,NJ,   EDM,NYI,  ANH,DET                                                                                            ;day 4
	Day	BOS,QUE,  HFD,PHI,  PIT,NYR,  MTL,BUF,  NJ, WSH,  TB, FLA,  TOR,CHI,  STL,OTW,  DAL,WPG,  VAN,CGY,  LA, DET            ;day 5
	Day	BUF,HFD,  QUE,PIT,  PHI,TOR,  CHI,WPG,  LA, SJ,   ANH,NYI                                                              ;day 6
	Day	BOS,MTL,  NYR,WSH,  VAN,EDM                                                                                            ;day 7
	Day	NJ, WPG,  PHI,BUF,  FLA,PIT,  DAL,CHI,  LA, NYI                                                                        ;day 8
	Day	HFD,MTL,  NYR,QUE,  TOR,WSH,  DET,STL,  ANH,EDM                                                                        ;day 9
	Day	TB, PIT,  FLA,OTW,  CHI,HFD,  SJ, CGY,  LA, EDM                                                                        ;day 10
	Day	BUF,NYR,  WSH,PHI,  TOR,DET,  WPG,CHI,  ANH,BOS                                                                        ;day 11
	Day	PIT,HFD,  MTL,QUE,  NYI,NJ,   PHI,NYR,  WSH,BUF,  TB, OTW,  DET,TOR,  DAL,STL,  EDM,VAN,  SJ, BOS,  LA, CGY            ;day 12
	Day	FLA,TB,   ANH,CGY                                                                                                      ;day 13
	Day	BUF,DET,  QUE,MTL,  CHI,DAL,  WPG,EDM                                                                                  ;day 14
	Day	NYI,PIT,  NYR,ANH,  FLA,LA,   TOR,HFD,  VAN,BOS,  SJ, STL                                                              ;day 15
	Day	HFD,QUE,  MTL,DAL,  NJ, ANH,  TB, LA,   EDM,CGY                                                                        ;day 16
	Day	OTW,DAL,  PHI,NYI,  FLA,TOR,  DET,WPG,  CHI,QUE,  STL,SJ,   CGY,VAN                                                    ;day 17
	Day	BUF,PIT,  WSH,LA,   TB, NYR,  EDM,BOS                                                                                  ;day 18
	Day	HFD,BUF,  PIT,STL,  MTL,ANH,  QUE,DAL,  NYI,OTW,  NJ, FLA,  PHI,WPG,  TB, TOR,  CHI,DET,  CGY,BOS,  SJ, VAN            ;day 19
	Day	NYR,LA,   EDM,WSH,  VAN,SJ                                                                                             ;day 20
	Day	OTW,ANH,  DET,DAL,  CGY,WSH                                                                                            ;day 21
	Day	QUE,PHI,  NYI,LA,   NJ, MTL,  FLA,WPG,  CHI,STL,  SJ, EDM                                                              ;day 22
	Day	OTW,PHI,  TB, WPG,  DET,LA,   DAL,HFD,  CGY,BUF,  VAN,WSH                                                              ;day 23
	Day	BOS,OTW,  PIT,QUE,  NYR,MTL,  FLA,NYI,  CHI,TOR,  STL,HFD,  SJ, ANH                                                    ;day 24
	Day	TB, NYI,  WPG,LA,   EDM,BUF,  ANH,WSH                                                                                  ;day 25
	Day	BOS,STL,  HFD,NYR,  PIT,CHI,  MTL,TOR,  QUE,DET,  NJ, PHI,  FLA,TB,   DAL,OTW,  CGY,EDM,  VAN,BUF,  SJ, WSH            ;day 26
	Day	NYR,NJ,   CHI,PHI,  WPG,CGY,  ANH,SJ                                                                                   ;day 27
	Day	HFD,STL,  DAL,TOR                                                                                                      ;day 28
	Day	QUE,TB,   NYI,VAN,  FLA,PHI,  DET,BOS,  SJ, PIT                                                                        ;day 29
	Day	HFD,CGY,  BUF,PIT,  MTL,TB,   NYR,VAN,  TOR,FLA,  WPG,STL,  EDM,OTW,  LA, NJ,   ANH,DAL                                ;day 30
	Day	BOS,CGY,  PHI,QUE,  DET,TOR,  CHI,NYI                                                                                  ;day 31
	Day	WSH,VAN,  WPG,OTW,  SJ, DAL,  ANH,NJ                                                                                   ;day 32
	Day	BOS,TB,   MTL,CGY,  QUE,NYR,  NYI,HFD,  TOR,PHI,  STL,EDM,  LA, PIT                                                    ;day 33
	Day	BUF,BOS,  QUE,FLA,  PHI,VAN,  CHI,EDM,  DAL,WPG,  SJ, NJ,   ANH,PIT                                                    ;day 34
	Day	NYR,TB                                                                                                                 ;day 35
	Day	NYI,WPG,  WSH,QUE,  DET,EDM,  STL,PIT,  CGY,LA,   SJ, TOR,  ANH,DAL                                                    ;day 36
	Day	HFD,OTW,  BUF,PHI,  MTL,FLA,  NYR,WPG,  NJ, NYI,  VAN,LA                                                               ;day 37
	Day	BOS,EDM,  OTW,FLA,  PHI,NJ,   TB, WSH,  CHI,PIT,  STL,TOR,  DAL,SJ,   CGY,ANH                                          ;day 38
	Day	                                                                                                                       ;day 39
	Day	HFD,EDM,  PIT,DET,  MTL,OTW,  NYI,BOS,  NJ, SJ,   PHI,BUF,  WSH,NYR,  TB, QUE,  TOR,CHI,  WPG,DAL,  CGY,VAN,  LA, STL  ;day 40
	Day	NYR,SJ,   FLA,QUE,  CHI,DAL,  VAN,ANH                                                                                  ;day 41
	Day	OTW,MTL,  TOR,EDM,  CGY,WPG                                                                                            ;day 42
	Day	PIT,PHI,  WSH,SJ,   FLA,NYR,  VAN,STL                                                                                  ;day 43
	Day	HFD,BOS,  OTW,NYI,  MTL,EDM,  NJ, BUF,  DAL,TB,   WPG,DET,  ANH,TOR                                                    ;day 44
	Day	BOS,SJ,   PIT,WSH,  OTW,NJ,   MTL,NYI,  PHI,HFD,  FLA,CHI,  STL,CGY,  LA, TOR                                          ;day 45
	Day	BUF,WPG,  TB, NYR,  VAN,ANH                                                                                            ;day 46
	Day	BOS,PHI,  HFD,SJ,   MTL,PIT,  QUE,WPG,  NJ, DET,  TB, CHI,  FLA,WSH,  STL,LA,   DAL,CGY,  EDM,TOR                      ;day 47
	Day	BUF,SJ,   PHI,NYI,  STL,DET,  DAL,LA,   EDM,ANH                                                                        ;day 48
	Day	OTW,BUF,  CGY,ANH,  VAN,TOR                                                                                            ;day 49
	Day	QUE,NJ,   NYR,MTL,  FLA,HFD,  SJ, DET                                                                                  ;day 50
	Day	PIT,BOS,  BUF,NJ,   OTW,NYR,  PHI,MTL,  WSH,STL,  TB, HFD,  DAL,NYI,  WPG,ANH,  CGY,TOR,  EDM,CHI,  VAN,DET            ;day 51
	Day	QUE,LA                                                                                                                 ;day 52
	Day	BOS,FLA,  BUF,OTW,  PHI,TB,   WSH,PIT,  STL,NJ,   WPG,VAN,  CGY,CHI,  ANH,SJ                                           ;day 53
	Day	HFD,FLA,  PIT,OTW,  MTL,LA,   QUE,BUF,  NYI,NYR,  TB, PHI,  TOR,BOS,  DET,DAL,  EDM,VAN,  SJ, ANH                      ;day 54
	Day	NYI,DET,  NYR,WSH,  STL,WPG                                                                                            ;day 55
	Day	OTW,HFD,  TOR,BUF,  EDM,DAL,  VAN,CHI                                                                                  ;day 56
	Day	QUE,BOS,  NYI,WSH,  NJ, NYR,  CGY,DAL,  LA, WPG                                                                        ;day 57
	Day	HFD,DET,  MTL,OTW,  TB, BUF,  TOR,STL,  EDM,PHI,  ANH,WPG                                                              ;day 58
	Day	BOS,NYI,  PIT,NJ,   FLA,BUF,  STL,TOR,  VAN,PHI,  LA, ANH                                                              ;day 59
	Day	NYI,QUE,  WSH,MTL,  DET,OTW,  SJ, WPG                                                                                  ;day 60
	Day	BOS,MTL,  HFD,PIT,  OTW,WSH,  QUE,VAN,  NJ, CHI,  TOR,NYR,  STL,DAL,  CGY,PHI,  LA, TB                                 ;day 61
	Day	BUF,BOS,  NYR,NJ,   DAL,EDM,  WPG,DET,  SJ, FLA,  ANH,TB                                                               ;day 62
	Day	OTW,CGY,  MTL,VAN,  DET,WPG                                                                                            ;day 63
	Day	QUE,CGY,  NYI,EDM,  WSH,HFD,  STL,CHI,  SJ, TB,   ANH,FLA                                                              ;day 64
	Day	HFD,VAN,  OTW,BUF,  MTL,NJ,   NYR,EDM,  TOR,WPG,  DAL,PIT,  LA, FLA                                                    ;day 65
	Day	BOS,VAN,  NJ, QUE,  PHI,WSH,  DET,STL,  DAL,OTW                                                                        ;day 66
	Day	BUF,CGY,  WPG,FLA                                                                                                      ;day 67
	Day	BOS,CHI,  HFD,BUF,  MTL,WSH,  QUE,OTW,  NYI,PHI,  NJ, EDM,  TB, PIT,  TOR,CGY,  DET,SJ,   LA, STL                      ;day 68
	Day	BOS,HFD,  PHI,EDM,  CHI,SJ,   DAL,FLA,  WPG,TOR,  ANH,STL                                                              ;day 69
	Day	OTW,LA,   QUE,WSH,  NYR,BUF                                                                                            ;day 70
	Day	PIT,LA,   NYI,NJ,   TB, MTL,  DET,ANH,  CGY,VAN                                                                        ;day 71
	Day	NYR,HFD,  NJ, BOS,  TB, OTW,  FLA,MTL,  TOR,ANH,  DAL,CHI,  EDM,VAN,  SJ, STL                                          ;day 72
	Day	PIT,BUF,  PHI,QUE                                                                                                      ;day 73
	Day	BUF,LA,   NYI,TOR,  WSH,OTW,  DET,NYR,  DAL,ANH,  CGY,STL,  EDM,SJ,   VAN,WPG                                          ;day 74
	Day	HFD,WSH,  MTL,DET,  QUE,NJ,   PHI,CHI,  TB, BOS,  TOR,LA,   CGY,WPG                                                    ;day 75
	Day	PIT,NYI,  BUF,TB,   QUE,SJ,   NYR,OTW,  NJ, PHI,  FLA,BOS,  CHI,ANH,  EDM,STL,  VAN,DAL                                ;day 76
	Day	WPG,ANH,  CGY,LA                                                                                                       ;day 77
	Day	PIT,TB,   OTW,QUE,  PHI,WSH,  DET,CHI,  VAN,EDM                                                                        ;day 78
	Day	HFD,NJ,   MTL,NYI,  FLA,NYR,  TOR,SJ,   EDM,CGY,  ANH,DAL                                                              ;day 79
	Day	BOS,PIT,  BUF,MTL,  OTW,HFD,  NJ, TOR,  PHI,DET,  WSH,NYR,  CHI,SJ,   STL,TB,   WPG,QUE,  VAN,CGY,  LA, DAL            ;day 80
	Day	                                                                                                                       ;day 81
	Day	                                                                                                                       ;day 82
	Day	HFD,OTW,  NYI,BUF,  NYR,NJ,   WSH,PIT,  TB, FLA,  STL,CHI,  ANH,LA                                                     ;day 83
	Day	BUF,PHI,  OTW,BOS,  CHI,TOR,  DAL,DET,  EDM,WPG                                                                        ;day 84
	Day	PIT,PHI,  QUE,TB,   NYI,ANH,  NJ, HFD,  WSH,FLA,  SJ, CGY,  LA, VAN                                                    ;day 85
	Day	HFD,FLA,  STL,NYR,  DAL,TOR,  WPG,CHI,  EDM,MTL                                                                        ;day 86
	Day	OTW,TB,   QUE,NYI,  WSH,ANH,  CGY,EDM                                                                                  ;day 87
	Day	BOS,PHI,  PIT,QUE,  BUF,NYR,  DET,LA,   CHI,DAL,  WPG,STL,  CGY,MTL,  VAN,SJ                                           ;day 88
	Day	OTW,NJ,   NYI,HFD,  WSH,TB,   FLA,ANH,  TOR,LA                                                                         ;day 89
	Day	BOS,WSH,  HFD,PIT,  BUF,TOR,  TB, ANH,  CHI,WPG,  STL,CGY,  DAL,QUE,  EDM,SJ,   VAN,MTL                                ;day 90
	Day	OTW,PIT,  NYR,FLA                                                                                                      ;day 91
	Day	NJ, NYI,  TOR,TB,   STL,DET,  DAL,CHI,  SJ, MTL,  LA, QUE                                                              ;day 92
	Day	HFD,WPG,  OTW,VAN,  QUE,MTL,  NYR,CGY                                                                                  ;day 93
	Day	BOS,WPG,  HFD,STL,  TOR,OTW,  CHI,ANH,  DAL,PHI,  SJ, DET                                                              ;day 94
	Day	BUF,PIT,  NYI,CGY,  NJ, FLA,  EDM,QUE                                                                                  ;day 95
	Day	BOS,FLA,  HFD,NYI,  PIT,CGY,  OTW,WPG,  MTL,NYR,  WSH,CHI,  TB, PHI,  TOR,VAN,  STL,ANH,  LA, DET                      ;day 96
	Day	BUF,VAN,  NJ, WSH,  CHI,EDM,  DAL,STL                                                                                  ;day 97
	Day	BOS,TOR,  OTW,NYI,  MTL,WPG,  NYR,TB,   ANH,DET                                                                        ;day 98
	Day	PIT,BOS,  PHI,OTW,  WSH,TOR,  CHI,BUF,  DAL,EDM,  CGY,QUE,  SJ, LA                                                     ;day 99
	Day	MTL,NJ,   DET,TB,   WPG,BUF,  VAN,QUE,  LA, HFD,  ANH,SJ                                                               ;day 100
	Day	PIT,FLA,  PHI,BOS,  TOR,DAL,  CHI,TB,   STL,EDM                                                                        ;day 101
	Day	NYI,MTL,  NYR,PHI,  WSH,NJ,   DET,DAL,  VAN,OTW,  ANH,HFD                                                              ;day 102
	Day	BOS,DET,  PIT,EDM,  MTL,FLA,  QUE,WSH,  NYI,CHI,  NJ, LA,   STL,BUF,  WPG,TOR,  CGY,OTW,  SJ, HFD                      ;day 103
	Day	PHI,LA,   CHI,NYR,  DAL,BUF,  WPG,TB,   ANH,VAN                                                                        ;day 104
	Day	BOS,HFD,  MTL,WSH,  NYI,FLA,  TB, DET,  SJ, CGY                                                                        ;day 105
	Day	OTW,EDM,  QUE,PIT,  NYR,STL,  TOR,ANH,  DAL,LA                                                                         ;day 106
	Day	HFD,TOR,  BUF,EDM,  MTL,BOS,  PHI,STL,  TB, NYI,  FLA,WSH,  DET,ANH,  WPG,NJ,   VAN,CGY                                ;day 107
	Day	                                                                                                                       ;day 108
	Day	                                                                                                                       ;day 109
	Day	                                                                                                                       ;day 110
	Day	                                                                                                                       ;day 111
	Day	HFD,BOS,  TB, BUF,  FLA,MTL,  DAL,NJ,   CGY,LA,   EDM,VAN,  ANH,STL                                                    ;day 112
	Day	PIT,OTW,  QUE,PHI,  WSH,BOS,  DET,CHI,  VAN,STL,  SJ, NYR,  LA, WPG                                                    ;day 113
	Day	HFD,MTL,  TB, FLA,  TOR,NYI,  CGY,DAL,  EDM,NJ,   ANH,WPG                                                              ;day 114
	Day	PIT,QUE,  BUF,WSH,  OTW,HFD,  CHI,DET,  VAN,DAL,  LA, NYR                                                              ;day 115
	Day	NYI,BOS,  FLA,SJ,   CGY,NJ,   EDM,STL,  ANH,NYR                                                                        ;day 116
	Day	BOS,NYI,  HFD,QUE,  MTL,BUF,  PHI,WSH,  TB, SJ,   TOR,PIT,  DET,WPG,  CHI,OTW,  CGY,STL,  EDM,DAL,  VAN,NJ,   LA, ANH  ;day 117
	Day	BUF,FLA,  MTL,PHI,  WSH,DET                                                                                            ;day 118
	Day	BOS,QUE,  OTW,CHI,  NYR,PIT,  VAN,LA                                                                                   ;day 119
	Day	PIT,FLA,  QUE,HFD,  NYI,SJ,   STL,TOR                                                                                  ;day 120
	Day	OTW,FLA,  MTL,HFD,  NYR,NYI,  NJ, BUF,  PHI,WSH,  TB, DET,  WPG,DAL,  EDM,LA,   VAN,CHI,  ANH,CGY                      ;day 121
	Day	BOS,NYR,  PHI,SJ,   STL,QUE                                                                                            ;day 122
	Day	NJ, OTW,  WSH,MTL,  FLA,BUF,  DET,PIT,  WPG,HFD,  EDM,CHI,  ANH,VAN                                                    ;day 123
	Day	BOS,PHI,  OTW,MTL,  QUE,NYI,  NJ, PIT,  WSH,TB,   TOR,DET,  STL,SJ,   LA, CGY                                          ;day 124
	Day	BUF,NYI,  FLA,BOS,  DAL,SJ,   EDM,WPG,  VAN,HFD,  ANH,CHI                                                              ;day 125
	Day	PIT,MTL,  NYR,WSH,  TOR,TB,   CGY,EDM                                                                                  ;day 126
	Day	OTW,PHI,  QUE,BOS,  NYI,BUF,  DET,VAN,  STL,WPG,  SJ, CHI                                                              ;day 127
	Day	MTL,NYR,  DAL,WPG,  EDM,CGY,  LA, CHI                                                                                  ;day 128
	Day	BOS,BUF,  PIT,NYI,  OTW,TB,   NJ, VAN,  PHI,FLA,  STL,WSH                                                              ;day 129
	Day	BUF,MTL,  NYR,QUE,  DET,PHI,  WPG,TOR,  CGY,HFD,  SJ, CHI,  ANH,LA                                                     ;day 130
	Day	BOS,NJ,   PIT,DAL,  OTW,NYR,  MTL,QUE,  NYI,FLA,  TB, VAN,  STL,DET,  CGY,TOR,  EDM,HFD,  LA, WSH                      ;day 131
	Day	BUF,DAL,  PHI,PIT,  TB, NJ,   FLA,VAN,  EDM,ANH,  SJ, CHI                                                              ;day 132
	Day	QUE,NYR,  CGY,CHI,  LA, BOS                                                                                            ;day 133
	Day	PIT,WPG,  NYI,TB,   WSH,EDM,  TOR,DET,  STL,VAN,  SJ, PHI                                                              ;day 134
	Day	HFD,BUF,  DET,FLA,  DAL,BOS,  ANH,PHI                                                                                  ;day 135
	Day	PIT,HFD,  TB, MTL,  TOR,NJ,   CHI,VAN,  SJ, QUE                                                                        ;day 136
	Day	BUF,FLA,  NYR,OTW,  WSH,NYI,  DET,EDM,  STL,BOS,  DAL,CGY,  WPG,CHI,  LA, PHI,  ANH,QUE                                ;day 137
	Day	HFD,NYR,  MTL,PIT,  NYI,OTW,  NJ, TB,   TOR,EDM,  SJ, LA                                                               ;day 138
	Day	WSH,BUF,  TB, BOS,  FLA,DET,  CHI,NJ,   STL,ANH,  WPG,CGY                                                              ;day 139
	Day	BUF,QUE,  NYI,WSH,  NYR,PIT,  PHI,MTL,  SJ, DAL,  LA, TOR                                                              ;day 140
	Day	WPG,FLA,  VAN,CGY                                                                                                      ;day 141
	Day	BUF,ANH,  MTL,SJ,   NYR,BOS,  DET,NJ,   EDM,TOR,  LA, DAL                                                              ;day 142
	Day	PIT,ANH,  OTW,SJ,   QUE,STL,  NJ, NYR,  PHI,NYI,  FLA,WSH,  DET,HFD,  CHI,WPG,  CGY,TB                                 ;day 143
	Day	BUF,CHI,  NYI,PHI,  WPG,BOS,  EDM,LA                                                                                   ;day 144
	Day	HFD,NJ,   PIT,BUF,  OTW,STL,  QUE,ANH,  WSH,FLA,  TOR,MTL,  DET,SJ,   DAL,NYR,  CGY,LA,   VAN,TB                       ;day 145
	Day	HFD,WSH,  NYI,QUE,  CHI,BOS,  EDM,TB                                                                                   ;day 146
	Day	OTW,TOR,  NJ, STL,  FLA,PIT,  WPG,SJ,   LA, MTL                                                                        ;day 147
	Day	QUE,BUF,  NYI,STL,  WSH,TB,   DET,CGY,  VAN,EDM                                                                        ;day 148
	Day	HFD,LA,   OTW,BUF,  NYR,PHI,  FLA,NJ,   WPG,DAL,  ANH,MTL                                                              ;day 149
	Day	BOS,LA,   TB, NJ,   CHI,CGY,  STL,VAN,  SJ, EDM                                                                        ;day 150
	Day	BUF,PIT,  OTW,WPG,  NYR,NYI,  WSH,PHI,  FLA,HFD,  DET,TOR,  DAL,VAN,  ANH,EDM                                          ;day 151
	Day	BOS,OTW,  QUE,TOR,  NYI,NYR,  NJ, CGY,  TB, HFD,  STL,MTL                                                              ;day 152
	Day	WSH,CGY,  TB, PHI,  DET,BUF,  CHI,LA,   DAL,MTL,  WPG,PIT,  SJ, ANH                                                    ;day 153
	Day	BOS,WSH,  NYR,DET,  NJ, QUE,  TOR,STL,  WPG,NYI,  VAN,FLA                                                              ;day 154
	Day	PIT,BOS,  QUE,OTW,  PHI,DAL,  CHI,ANH,  SJ, BUF                                                                        ;day 155
	Day	HFD,TB,   MTL,STL,  WSH,NYR,  TOR,DAL,  CGY,DET,  EDM,FLA,  VAN,NYI,  LA, CHI,  ANH,BUF                                ;day 156
	Day	BOS,NYR,  PIT,TOR,  QUE,MTL,  NJ, HFD,  PHI,OTW,  SJ, NYI                                                              ;day 157
	Day	WPG,VAN,  CGY,FLA,  EDM,DET,  ANH,CHI                                                                                  ;day 158
	Day	HFD,DAL,  PIT,NYR,  MTL,PHI,  NJ, BOS,  WSH,QUE,  TOR,WPG,  STL,NYI,  CGY,SJ,   LA, BUF                                ;day 159
	Day	HFD,PIT,  NJ, DAL,  PHI,TB,   CHI,VAN,  ANH,OTW                                                                        ;day 160
	Day	MTL,BOS,  QUE,CHI,  FLA,NYR                                                                                            ;day 161
	Day	PIT,WSH,  NYI,NJ,   TB, CGY,  DET,VAN,  LA, OTW                                                                        ;day 162
	Day	MTL,CHI,  NYR,HFD,  TB, EDM,  FLA,CGY,  TOR,VAN,  WPG,STL,  ANH,LA                                                     ;day 163
	Day	BOS,PIT,  BUF,NJ,   QUE,HFD,  DET,NYI,  SJ, OTW                                                                        ;day 164
	Day	NYI,BUF,  NYR,CHI,  FLA,EDM,  TOR,STL,  DAL,WSH                                                                        ;day 165
	Day	BOS,NJ,   PIT,VAN,  MTL,QUE,  PHI,HFD,  WPG,DET,  LA, SJ                                                               ;day 166
	Day	BUF,OTW,  QUE,EDM,  NYI,PIT,  TB, WSH,  FLA,PHI,  TOR,CGY,  CHI,STL,  DAL,VAN,  SJ, LA                                 ;day 167
	Day	FLA,NJ                                                                                                                 ;day 168
	Day	PIT,SJ,   QUE,BOS,  NYI,TB,   WSH,HFD,  DET,CHI,  STL,PHI,  DAL,ANH,  CGY,NYR                                          ;day 169
	Day	BUF,STL,  OTW,DET,  FLA,TOR,  WPG,MTL,  EDM,NYR,  LA, VAN                                                              ;day 170
	Day	BOS,ANH,  PIT,OTW,  NJ, TB,   PHI,FLA,  TOR,SJ,   CHI,MTL                                                              ;day 171
	Day	BUF,HFD,  DET,WSH,  STL,DAL,  WPG,SJ,   EDM,LA,   VAN,NYR                                                              ;day 172
	Day	BOS,MTL,  HFD,ANH,  NYI,FLA,  NJ, PHI,  TOR,QUE,  CGY,PIT                                                              ;day 173
	Day	BUF,NYI,  NJ, QUE,  PHI,ANH,  WSH,BOS,  TB, DAL,  CHI,DET,  STL,SJ,   WPG,NYR,  EDM,PIT,  VAN,LA                       ;day 174
	Day	MTL,OTW,  FLA,DAL,  VAN,TOR                                                                                            ;day 175
	Day	NJ, MTL,  PHI,NYR,  WSH,NYI,  DET,HFD,  SJ, WPG                                                                        ;day 176
	Day	HFD,CHI,  BUF,TB,   OTW,QUE,  FLA,STL,  VAN,PIT,  LA, ANH                                                              ;day 177
	Day	BOS,DAL,  PHI,CGY,  DET,QUE,  CHI,WSH,  SJ, TOR,  ANH,EDM                                                              ;day 178
	Day	BUF,BOS,  NYI,MTL,  NYR,DAL,  WSH,NJ,   TB, STL,  VAN,WPG                                                              ;day 179
	Day	HFD,PHI,  MTL,NYI,  QUE,BUF,  NJ, NYR,  FLA,OTW,  DET,CGY,  SJ, VAN,  LA, EDM,  ANH,TOR                                ;day 180
	Day	PIT,BOS,  WSH,DAL,  DET,STL,  CHI,CGY,  LA, EDM                                                                        ;day 181
	Day	PIT,TB,   NYR,FLA,  WPG,PHI                                                                                            ;day 182
	Day	QUE,FLA,  WSH,NYI,  STL,CHI,  DAL,TOR,  VAN,DET,  LA, SJ                                                               ;day 183
	Day	HFD,NYI,  PIT,NJ,   OTW,WSH,  MTL,TB,   WPG,EDM,  CGY,ANH                                                              ;day 184
	Day	BOS,OTW,  QUE,HFD,  PHI,FLA,  STL,LA,   VAN,SJ                                                                         ;day 185
	Day	BUF,MTL,  NYI,DAL,  NYR,TOR,  NJ, PIT,  CHI,STL,  CGY,SJ,   EDM,ANH                                                    ;day 186
	Day	BOS,TB,   MTL,PIT,  WSH,OTW,  WPG,LA,   CGY,DET,  VAN,ANH                                                              ;day 187
	Day	HFD,TB,   BUF,QUE,  NYI,NYR,  PHI,BOS,  FLA,NJ,   TOR,WPG,  CHI,LA,   STL,DAL,  EDM,DET,  SJ, VAN                      ;day 188
	Day	HFD,MTL,  OTW,PIT,  ANH,CGY                                                                                            ;day 189
	Day	NYR,BUF,  PHI,NJ,   WSH,WPG,  FLA,QUE,  TOR,CHI,  DAL,STL                                                              ;day 190
	Day	OTW,BOS,  TB, NYI,  DET,MTL,  SJ, EDM,  LA, CGY,  ANH,VAN                                                              ;day 191
	Day	BOS,HFD,  BUF,WSH,  NYR,PHI,  NJ, OTW,  TB, QUE,  FLA,NYI,  CHI,TOR,  STL,WPG,  DAL,DET,  LA, EDM                      ;day 192
SeasonScheduleEnd	;CountTeamGames stops its scan here (cmpa.l #x,a0)
	dc.b	$FF	;pad so the next address is even
