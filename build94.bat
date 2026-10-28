@echo off
setlocal

REM Get the directory of this batch file
set "workspaceFolder=%~dp0"

REM Set default values for rev and checksum if not provided
if not defined rev set rev=0
if not defined checksum set checksum=1

REM Pre-step: tools\prebuild.js checks the ROM and Extracted/ and extracts the assets if they are missing
REM or incomplete; it stops the build with the ROM path, SHA-1 and size if the ROM is missing. The npm
REM scripts run it first and set NHL_PREBUILD_DONE; tools/verify_all.sh does the same under wine.
set "prebuildTarget=retail"
if not defined NHL_PREBUILD_DONE (
    node "%workspaceFolder%tools\prebuild.js" %prebuildTarget% || exit /b 1
)

@REM echo Using rev=%rev% and checksum=%checksum%

REM Create the output directory
REM Intermediates (raw image, listing, log) go in output\obj; npm run fixopcodes moves the finished ROM to output\
if not exist "%workspaceFolder%output\obj" mkdir "%workspaceFolder%output\obj"

REM Change to the workspace src directory
cd /d "%workspaceFolder%src"

REM Determine revision flag
if "%REV%"=="1" (
    set revFlag="/e REV=1"
    ECHO "its reva"
) else (
    set revFlag="/e REV=0"
    ECHO "its retail"
)

REM Determine checksum flag
if "%checksum%"=="0" (
    set checksumFlag="/e CHECKSUM=0"
) else (
    set checksumFlag="/e CHECKSUM=1"
)

REM MSU=1 builds the MegaSD / MSU-MD ROM (src\msu94.asm). Default is the retail ROM
if not defined MSU set MSU=0
set msuFlag="/e MSU=%MSU%"

REM Run the assembler with all flags
"%workspaceFolder%assembler\Assembler.exe" ^
  /p /m /g ^
  /o d- /o s- /o r+ /o l+ /o l. /o ow+ /o op- /o os+ /o oz+ /o omq- /o oaq+ /o osq+ ^
  %revFlag% %checksumFlag% %msuFlag% ^
  "%workspaceFolder%src\nhl94.asm,%workspaceFolder%output\obj\nhl94.bin,%workspaceFolder%output\obj\nhl94,%workspaceFolder%output\obj\nhl94" ^
  > "%workspaceFolder%output\obj\Build94.log"

endlocal
