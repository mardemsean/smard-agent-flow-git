@echo off
setlocal
title SMard Agent Flow - Install
if not exist "%~dp0files\plugin\install.ps1" goto notextracted
set "PS=powershell"
where pwsh >nul 2>nul
if not errorlevel 1 set "PS=pwsh"
%PS% -NoProfile -ExecutionPolicy Bypass -File "%~dp0files\plugin\install.ps1" %*
if errorlevel 1 goto failed
echo.
echo Done. Open a NEW Claude Code session and type:  /smard-agent-flow
goto end
:notextracted
echo The files are not here. Extract the whole ZIP first: right-click the ZIP, choose "Extract All",
echo then run Install.cmd from the new folder.
goto end
:failed
echo.
echo The installation did not finish. Read the message above.
:end
echo.
pause
