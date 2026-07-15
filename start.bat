@echo off
setlocal

REM Terminal Trials launcher for PortableGit / Git Bash on Windows.
REM The first existing Bash executable in this list is used.
set "ROOT=%~dp0"
set "BASH_EXE="

for %%B in (
  "%ROOT%PortableGit\bin\bash.exe"
  "%ROOT%PortableGit\usr\bin\bash.exe"
  "%ROOT%..\PortableGit\bin\bash.exe"
  "%ROOT%..\PortableGit\usr\bin\bash.exe"
  "%ROOT%..\bin\bash.exe"
  "%ROOT%..\usr\bin\bash.exe"
  "%ProgramFiles%\Git\bin\bash.exe"
  "%ProgramFiles%\Git\usr\bin\bash.exe"
  "%LocalAppData%\Programs\Git\bin\bash.exe"
) do (
  if not defined BASH_EXE if exist "%%~fB" set "BASH_EXE=%%~fB"
)

if not defined BASH_EXE (
  echo.
  echo Git Bash was not found.
  echo Place this folder inside a PortableGit installation, or edit start.bat
  echo to point BASH_EXE at your PortableGit bash.exe.
  pause
  exit /b 1
)

"%BASH_EXE%" --noprofile --norc -i "%ROOT%start.sh"
endlocal
