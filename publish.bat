@echo off
cd /d "%~dp0"
bash publish.sh %*
echo.
pause
