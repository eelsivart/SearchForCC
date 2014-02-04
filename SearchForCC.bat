@ECHO OFF

REM Author: Travis Lee
REM Last Updated: 1-31-2014
REM
REM Description: Script to search an existing memory dump with grep for 
REM		 credit card track 1 and 2 data, track 1 only, and track 2 only data.
REM
REM Usage: SearchForCC.bat <memory dump file> <output file>
REM
REM Example: SearchForCC.bat memory.dmp results.txt

SET memdmp=%1
SET resultfile=%2

IF "%memdmp%"=="" GOTO error
IF "%resultfile%"=="" GOTO error
IF NOT EXIST grep.exe GOTO error

REM Search with grep
:search
IF NOT EXIST %memdmp% GOTO error

ECHO.
ECHO Input file: %memdmp%
ECHO Output file: %resultfile%

ECHO.
ECHO [+] Searching for Track 1 and 2 strings. Please wait...
echo Track 1 and 2 strings: > %resultfile%
grep.exe -aoE "(((%%?[Bb`]?)[0-9]{13,19}\^[A-Za-z\s]{0,26}\/[A-Za-z\s]{0,26}\^(1[2-9]|2[0-9])(0[1-9]|1[0-2])[0-9\s]{3,50}\?)[;\s]{1,3}([0-9]{13,19}=(1[2-9]|2[0-9])(0[1-9]|1[0-2])[0-9]{3,50}\?))" %memdmp% >> %resultfile%

ECHO.
ECHO [+] Searching for Track 1 strings only. Please wait...
echo. >> %resultfile%
echo Track 1 strings: >> %resultfile%
grep.exe -aoE "((%%?[Bb`]?)[0-9]{13,19}\^[A-Za-z\s]{0,26}\/[A-Za-z\s]{0,26}\^(1[2-9]|2[0-9])(0[1-9]|1[0-2])[0-9\s]{3,50}\?)" %memdmp% >> %resultfile%

ECHO.
ECHO [+] Searching for Track 2 strings only. Please wait...
echo. >> %resultfile%
echo Track 2 strings: >> %resultfile%
grep.exe -aoE "([0-9]{13,19}=(1[2-9]|2[0-9])(0[1-9]|1[0-2])[0-9]{3,50}\?)" %memdmp% >> %resultfile%

:done
ECHO.
ECHO [+] Search completed! Results have been stored in: %resultfile%
GOTO end

:error
ECHO.
ECHO [-] An error has occured! Ensure all files exist.
ECHO [-] Usage: SearchForCC.bat ^<memory dump file^> ^<output file^>
ECHO.

:end