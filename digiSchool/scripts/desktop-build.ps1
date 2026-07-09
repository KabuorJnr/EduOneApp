# DigiSchool Desktop - Build Script (Windows PowerShell)
# Builds the Flutter desktop app for distribution

param(
    [string]$PortalUrl = "https://your-domain.com",
    [string]$OutputDir = ".\build\output",
    [switch]$Release = $true
)

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "DigiSchool Desktop - Build Script" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Build Configuration:" -ForegroundColor Yellow
Write-Host "  Portal URL: $PortalUrl"
Write-Host "  Release Mode: $Release"
Write-Host "  Output Directory: $OutputDir"
Write-Host ""

# Check if Flutter is installed
Write-Host "Checking Flutter installation..." -ForegroundColor Yellow
flutter --version
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Flutter not found. Install Flutter from https://flutter.dev" -ForegroundColor Red
    exit 1
}

# Navigate to flutter_desktop directory
Push-Location "$PSScriptRoot\..\flutter_desktop"

# Install dependencies
Write-Host ""
Write-Host "Installing Flutter dependencies..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to get Flutter dependencies" -ForegroundColor Red
    Pop-Location
    exit 1
}

# Build
Write-Host ""
Write-Host "Building Flutter desktop app..." -ForegroundColor Cyan
$buildMode = if ($Release) { "--release" } else { "" }
flutter build windows $buildMode `
    --dart-define="DIGISCHOOL_PORTAL_URL=$PortalUrl" `
    --dart-define="ENABLE_DEV_TOOLS=false" `
    -v

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Build failed" -ForegroundColor Red
    Pop-Location
    exit 1
}

Write-Host ""
Write-Host "✅ Build completed successfully!" -ForegroundColor Green
Write-Host ""

# Create output directory
New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

# Copy executable
$exePath = "build\windows\x64\runner\Release\digischool_desktop.exe"
if (Test-Path $exePath) {
    Write-Host "Copying executable to output directory..." -ForegroundColor Cyan
    Copy-Item -Path $exePath -Destination "$OutputDir\digischool_desktop.exe" -Force
    Write-Host "✅ Executable copied: $OutputDir\digischool_desktop.exe" -ForegroundColor Green
}

# Copy runtime files
Write-Host "Copying runtime dependencies..." -ForegroundColor Cyan
Copy-Item -Path "build\windows\x64\runner\Release\*" -Destination $OutputDir -Recurse -Force -Exclude "*.exe"

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Build completed!" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Output location: $(Get-Item $OutputDir | Select-Object -ExpandProperty FullName)" -ForegroundColor Yellow
Write-Host ""
Write-Host "To distribute:" -ForegroundColor Yellow
Write-Host "1. Zip the output directory"
Write-Host "2. Share the ZIP file"
Write-Host "3. Users extract and run digischool_desktop.exe"
Write-Host ""

Pop-Location
