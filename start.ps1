# EuropeGAS Development Server Launcher
Write-Host "===== EuropeGAS Development Server Launcher =====" -ForegroundColor Cyan
Write-Host "Fixing localhost issues and starting development server..." -ForegroundColor Cyan

# Set execution policy for this process
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# Kill any running Node.js processes to free up ports
Write-Host "Stopping any existing Node.js processes..." -ForegroundColor Yellow
Get-Process -Name "node" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

# Clear npm cache
Write-Host "Clearing npm cache..." -ForegroundColor Yellow
npm cache clean --force | Out-Null

# Delete node_modules/.cache to force clean rebuild
Write-Host "Clearing React cache..." -ForegroundColor Yellow
if (Test-Path -Path "node_modules\.cache") {
    Remove-Item -Path "node_modules\.cache" -Recurse -Force | Out-Null
}

# Set environment variables for localhost fix
Write-Host "Setting environment variables..." -ForegroundColor Yellow
$env:HOST = "127.0.0.1"
$env:PORT = "3000"
$env:BROWSER = "none"

# Start the development server
Write-Host "Starting development server..." -ForegroundColor Green
Write-Host ""
Write-Host "If the application doesn't open automatically, visit:" -ForegroundColor White
Write-Host "http://127.0.0.1:3000" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor White
Write-Host ""

# Start the development server
npm start 