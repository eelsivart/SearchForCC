Author: Travis Lee
Last Updated: 1-31-2014

Description:
A collection of open source/common tools/scripts to perform a system memory dump
and/or process memory dump on Windows-based PoS systems and search for unencrypted
credit card track data.


==================
MemDump-SearchForCC.bat

Description: 
Script to automate a memory dump with MDD or ProcDump and then do
a search with grep for credit card track 1 and 2 data, track 1 only,
and track 2 only data.

Usage:
MemDump-SearchForCC.bat <mdd or procdump> <output file> [process.exe or PID (for procdump)]

Example using MDD:
MemDump-SearchForCC.bat mdd results.txt

Examples using ProcDump:
MemDump-SearchForCC.bat procdump results.txt pos.exe
MemDump-SearchForCC.bat procdump results.txt 1234



==================
SearchForCC.bat

Description: 
Script to search an existing memory dump with grep for 
credit card track 1 and 2 data, track 1 only, and track 2 only data.

Usage:
SearchForCC.bat <memory dump file> <output file>

Example:
SearchForCC.bat memory.dmp results.txt

