
@echo off
start /B taskkill /F /IM love.exe


timeout /t 1 /nobreak >nul

start "" love .
