@echo off
title ConnectSpace
cd /d "%~dp0"
echo.
echo ========================================
echo          CONNECTSPACE STARTUP
echo ========================================
echo.

where py >nul 2>nul
if %errorlevel%==0 (
  set "PYTHON=py"
) else (
  set "PYTHON=python"
)

%PYTHON% --version >nul 2>nul
if errorlevel 1 (
  echo Python was not found.
  echo Install Python 3.12 or newer from https://www.python.org/downloads/
  echo During installation, tick "Add Python to PATH".
  pause
  exit /b 1
)

if not exist ".venv\Scripts\python.exe" (
  echo Creating a local Python environment...
  %PYTHON% -m venv .venv
  if errorlevel 1 goto error
)

echo Installing required packages (first run may take a few minutes)...
".venv\Scripts\python.exe" -m pip install --upgrade pip
".venv\Scripts\python.exe" -m pip install -r requirements.txt
if errorlevel 1 goto error

if not exist "data" mkdir data
if not exist "recordings" mkdir recordings

echo Starting ConnectSpace...
start "ConnectSpace browser" cmd /c "timeout /t 3 /nobreak >nul & start http://127.0.0.1:8000"
".venv\Scripts\python.exe" -m uvicorn app.main:app --host 127.0.0.1 --port 8000
goto end

:error
echo.
echo Startup failed. Check the error above and see README.md troubleshooting.
pause
exit /b 1

:end
pause
