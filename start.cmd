@echo off
echo ===== EuropeGAS Development Server Launcher =====
echo Fixing localhost issues and starting development server...

:: Kill any running Node.js processes to free up ports
echo Stopping any existing Node.js processes...
taskkill /F /IM node.exe >nul 2>nul

:: Clear npm cache
echo Clearing npm cache...
call npm cache clean --force >nul 2>nul

:: Delete node_modules/.cache to force clean rebuild
echo Clearing React cache...
if exist node_modules\.cache (
  rmdir /S /Q node_modules\.cache >nul 2>nul
)

:: Set environment variables for localhost fix
echo Setting environment variables...
set HOST=127.0.0.1
set PORT=3000

:: Start the development server
echo Starting development server...
echo.
echo If the application doesn't open automatically, visit:
echo http://127.0.0.1:3000
echo.
echo Press Ctrl+C to stop the server
echo.

npm start 