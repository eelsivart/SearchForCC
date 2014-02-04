@ECHO OFF

REM Author: Travis Lee
REM Last Updated: 1-31-2014
REM
REM Description: Script to automate a memory dump with MDD or ProcDump and then do
REM              a search with grep for credit card track 1 and 2 data, track 1 only,
REM              and track 2 only data.
REM
REM Usage: MemDump-SearchForCC.bat <mdd or procdump> <output file> [process.exe or PID (for procdump)]
REM
REM Example using MDD: 		MemDump-SearchForCC.bat mdd results.txt
REM Examples using ProcDump:	MemDump-SearchForCC.bat procdump results.txt pos.exe
REM				MemDump-SearchForCC.bat procdump results.txt 1234

IF NOT EXIST procdump.exe GOTO error
IF NOT EXIST mdd_1.3.exe GOTO error
IF NOT EXIST grep.exe GOTO error

REM Filename for memory dump file and results file
SET memdmp=memory_temp.dmp

SET prog=%1
SET resultfile=%2

IF "%prog%"=="mdd" GOTO mdd
IF "%prog%"=="procdump" GOTO procdump
GOTO error

:mdd
ECHO.
ECHO [+] Starting full system memory dump with MDD. Please wait...
ECHO.
mdd_1.3.exe -o %memdmp%
GOTO search

:procdump
SET process=%3
IF "%process%"=="" GOTO error
ECHO.
ECHO [+] Starting memory dump with ProcDump on process: %process%. Please wait...
ECHO.
procdump.exe -accepteula -ma %process% %memdmp%
GOTO search

REM Search with grep
:search
IF NOT EXIST %memdmp% GOTO error

ECHO.
ECHO [+] Searching for Track 1 and 2 strings. Please wait...
echo Track 1 and 2 strings: > "%resultfile%"
grep.exe -aoE "(((%%?[Bb`]?)[0-9]{13,19}\^[A-Za-z\s]{0,26}\/[A-Za-z\s]{0,26}\^(1[2-9]|2[0-9])(0[1-9]|1[0-2])[0-9\s]{3,50}\?)[;\s]{1,3}([0-9]{13,19}=(1[2-9]|2[0-9])(0[1-9]|1[0-2])[0-9]{3,50}\?))" %memdmp% >> "%resultfile%"

ECHO.
ECHO [+] Searching for Track 1 strings only. Please wait...
echo. >> "%resultfile%"
echo Track 1 strings: >> "%resultfile%"
grep.exe -aoE "((%%?[Bb`]?)[0-9]{13,19}\^[A-Za-z\s]{0,26}\/[A-Za-z\s]{0,26}\^(1[2-9]|2[0-9])(0[1-9]|1[0-2])[0-9\s]{3,50}\?)" %memdmp% >> "%resultfile%"

ECHO.
ECHO [+] Searching for Track 2 strings only. Please wait...
echo. >> "%resultfile%"
echo Track 2 strings: >> "%resultfile%"
grep.exe -aoE "([0-9]{13,19}=(1[2-9]|2[0-9])(0[1-9]|1[0-2])[0-9]{3,50}\?)" %memdmp% >> "%resultfile%"

:done
ECHO.
ECHO [+] Search completed! Results have been stored in: "%resultfile%"
ECHO.
ECHO [+] Cleaning up... Deleting memory dump file: %memdmp%
ECHO.
del %memdmp%
GOTO end

:error
ECHO.
ECHO [-] An error has occured! Ensure all files exist.
ECHO [-] Usage: MemDump-SearchForCC.bat ^<mdd or procdump^> ^<output file^> [process.exe or PID (for procdump only)]
ECHO.

:end