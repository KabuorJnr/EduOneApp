# DigiSchool Desktop - Development Script (Windows PowerShell)
# This script starts both the web app dev server and the Flutter desktop shell

param(
    [string]$PortalUrl = "http://localhost:5173",
    [string]$EnableDevTools = "true"
)

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "DigiSchool Desktop - Development Mode" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Configuration:" -ForegroundColor Yellow
Write-Host "  Portal URL: $PortalUrl"
Write-Host "  DevTools: $EnableDevTools"
Write-Host ""

# Check if Flutter is installed
Write-Host "Checking Flutter installation..." -ForegroundColor Yellow
flutter --version
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Flutter not found. Install Flutter from https://flutter.dev" -ForegroundColor Red
    exit 1
}

# Check if web app is already running
Write-Host "Checking if web app is running on localhost:5173..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:5173" -TimeoutSec 2 -ErrorAction SilentlyContinue
    Write-Host "✅ Web app is already running" -ForegroundColor Green
}
catch {
    Write-Host "⚠️  Web app not detected. You should run 'npm run dev' in another terminal" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Starting web app in background..." -ForegroundColor Cyan
    Start-Process -NoNewWindow -FilePath "npm" -ArgumentList "run", "dev" -WorkingDirectory (Get-Item -Path "$PSScriptRoot\.." | Select-Object -ExpandProperty FullName)
    Start-Sleep -Seconds 5
}

# Install Flutter dependencies
Write-Host ""
Write-Host "Installing Flutter dependencies..." -ForegroundColor Yellow
Push-Location "$PSScriptRoot\..\flutter_desktop"
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to get Flutter dependencies" -ForegroundColor Red
    Pop-Location
    exit 1
}
Pop-Location

# Run desktop app
Write-Host ""
Write-Host "Launching Flutter desktop app..." -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop" -ForegroundColor Gray
Write-Host ""

flutter run -d windows `
    --dart-define="DIGISCHOOL_PORTAL_URL=$PortalUrl" `
    --dart-define="ENABLE_DEV_TOOLS=$EnableDevTools"

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "❌ Desktop app exited with error" -ForegroundColor Red
}
else {
    Write-Host ""
    Write-Host "✅ Desktop app closed successfully" -ForegroundColor Green
}
