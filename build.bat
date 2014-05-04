@if "%~1" equ "" (
	echo This file cannot be run without arguments. Please run 'Build.Release.bat' instead.
	pause
	exit /b %ERRORLEVEL%
)
set CONFIG=%~1
set PLATFORM=%2
set PROJECT=%3
@if "%4" neq "" (set ACTION=%4) else (set ACTION=Build)
if %PLATFORM% == x64 (set MACHINE=x64) else (set MACHINE=x86)
call "%VS120COMNTOOLS%..\..\VC\vcvarsall.bat" %MACHINE%
echo on
devenv /nologo amcap.sln /Project %PROJECT% /%ACTION% "%CONFIG%|%PLATFORM%"
@if %ERRORLEVEL% neq 0 (
	call :color c "%3 %~1 %PLATFORM% %ACTION% failed"
	pause
	exit /b %ERRORLEVEL%
)
exit /b
REM Functions
:color
@echo off
setlocal
pushd %temp%
for /F "tokens=1 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
	<nul set/p"=%%a" >"%~2"
)
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
popd
@echo on
exit /b