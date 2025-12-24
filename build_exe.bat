@echo off
REM Simple batch wrapper to run the PowerShell build script
SET SCRIPT_DIR=%~dp0
powershell -ExecutionPolicy Bypass -NoProfile -File "%SCRIPT_DIR%build_exe.ps1"
pause
