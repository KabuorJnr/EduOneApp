# DigiSchool Desktop - Deployment & Distribution Guide

This guide covers how to build, package, and distribute the DigiSchool desktop application to end users.

## Overview

There are three main distribution approaches:

1. **Direct Distribution** - Simple ZIP file with executable (fastest)
2. **Windows Installer (MSIX)** - Professional installer for Windows Store or enterprise
3. **Custom Installer** - Full control with NSIS or Inno Setup

## Prerequisites

- Flutter SDK 3.5.0+ with Windows desktop support enabled
- Visual Studio Build Tools (C++ workload)
- Your production portal URL (e.g., `https://digischool.example.com`)
- Portal must be publicly accessible or VPN-accessible to users

## Build Steps

### 1. Prepare the Build

```powershell
# Navigate to project root
cd \path\to\DigiSchool

# Clean previous builds
npm run flutter:clean

# Update Flutter (optional but recommended)
flutter upgrade
```

### 2. Build Release Binary

```powershell
# Build for production with your domain
npm run desktop:build -PortalUrl 'https://your-digischool-domain.com'

# Or manually:
cd flutter_desktop
flutter build windows --release `
  --dart-define=DIGISCHOOL_PORTAL_URL=https://your-digischool-domain.com `
  --dart-define=ENABLE_DEV_TOOLS=false
```

Build time: 5-15 minutes (first time may take longer)

Output location: `flutter_desktop/build/windows/x64/runner/Release/`

### 3. Verify the Build

```powershell
# Test the built executable
.\flutter_desktop\build\windows\x64\runner\Release\digischool_desktop.exe

# Make sure:
# - Window opens correctly
# - Portal loads
# - Can navigate
# - No errors in console
```

## Distribution Method 1: Direct Distribution (Simplest)

Best for: Internal distribution, small teams, quick deployments

### Steps

```powershell
# Copy all files to output folder
$output = "DigiSchool-Desktop-v0.1.0"
mkdir $output
Copy-Item -Path "flutter_desktop/build/windows/x64/runner/Release/*" `
          -Destination "$output" -Recurse -Force

# Create ZIP archive
Compress-Archive -Path $output -DestinationPath "DigiSchool-Desktop-v0.1.0.zip"

# Share the ZIP file
```

### For Users

```powershell
# 1. Download and extract DigiSchool-Desktop-v0.1.0.zip
# 2. Navigate to extracted folder
# 3. Double-click digischool_desktop.exe

# To create shortcuts:
# Right-click digischool_desktop.exe → Send to → Desktop (create shortcut)
# Rename to "DigiSchool"
```

**File Size**: ~200-300 MB
**Setup Time**: < 1 minute
**Uninstall**: Delete folder

## Distribution Method 2: Windows MSIX Installer

Best for: Professional distribution, Windows Store, enterprise deployments, auto-updates

### Build MSIX

```powershell
# Install MSIX build tools (one time)
flutter pub global activate msix

# Build MSIX package
cd flutter_desktop

flutter pub global run msix:create `
  --display-name="DigiSchool" `
  --publisher-display-name="Your Organization" `
  --identity-name="YourOrg.DigiSchool" `
  --version=0.1.0.0 `
  --certificate-path="" `  # Leave blank for local testing
  --install-certificate=false

# Output: build\windows\msix\digischool_desktop.msix
```

### For Users (Direct)

Users can install via:

```powershell
# Method 1: Double-click the .msix file
# (Requires developer mode or code signing)

# Method 2: PowerShell
Add-AppxPackage -Path "DigiSchool-Desktop-v0.1.0.msix"

# Method 3: Windows Package Manager
winget install YourOrg.DigiSchool
```

### For Enterprise Deployment

```powershell
# Distribute via:
# 1. Windows Store (requires code signing and approval)
# 2. Microsoft Intune/MDM
# 3. Company app portal/web portal
# 4. Group Policy distribution
```

### Advantages

- ✅ Automatic updates possible
- ✅ Clean install/uninstall via Windows
- ✅ Windows Store compatible
- ✅ Enterprise-friendly
- ✅ File association support
- ✅ Version management

### Code Signing (For Production)

For production MSIX deployment, you need code signing:

```powershell
# 1. Obtain a code signing certificate from a CA
#    (or use self-signed for internal distribution)

# 2. Create certificate for self-signed (internal use)
$cert = New-SelfSignedCertificate `
  -Subject "CN=YourOrg DigiSchool" `
  -Type CodeSigningCert `
  -CertStoreLocation "cert:\CurrentUser\My"

# 3. Export and use
flutter pub global run msix:create `
  --certificate-path="path/to/cert.pfx" `
  --certificate-password="password" `
  --install-certificate=true
```

## Distribution Method 3: Custom Installer (NSIS)

Best for: Full control, custom branding, advanced features

### Install NSIS

Download from: https://nsis.sourceforge.io/

### Create Installer Script

Create `installer.nsi`:

```nsis
; DigiSchool Desktop Installer
; Edit variables as needed

!define PRODUCT_NAME "DigiSchool Desktop"
!define PRODUCT_VERSION "0.1.0"
!define PRODUCT_PUBLISHER "Your Organization"
!define PRODUCT_WEB_SITE "https://digischool.example.com"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\digischool_desktop.exe"

; Include Modern UI
!include "MUI2.nsh"

; General
Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "DigiSchool-Desktop-v0.1.0-Setup.exe"
InstallDir "$PROGRAMFILES\${PRODUCT_NAME}"

; UI Configuration
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"

; Installer Sections
Section "Install"
  SetOutPath "$INSTDIR"
  
  ; Copy files
  File /r "flutter_desktop\build\windows\x64\runner\Release\*.*"
  
  ; Create Start Menu shortcut
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\digischool_desktop.exe"
  
  ; Create Desktop shortcut
  CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\digischool_desktop.exe"
  
  ; Registry entries
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\digischool_desktop.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayName" "${PRODUCT_NAME}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "UninstallString" "$INSTDIR\Uninstall.exe"
SectionEnd

; Uninstaller
Section "Uninstall"
  RMDir /r "$INSTDIR"
  RMDir /r "$SMPROGRAMS\${PRODUCT_NAME}"
  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
SectionEnd
```

### Build Installer

```powershell
# Use NSIS to compile
& "C:\Program Files (x86)\NSIS\makensis.exe" installer.nsi

# Output: DigiSchool-Desktop-v0.1.0-Setup.exe
```

## Configuration for Different Environments

### Development Environment
```powershell
flutter build windows --dart-define=DIGISCHOOL_PORTAL_URL=http://localhost:5173
```

### Staging Environment
```powershell
flutter build windows --dart-define=DIGISCHOOL_PORTAL_URL=https://staging.digischool.example.com
```

### Production Environment
```powershell
flutter build windows --release --dart-define=DIGISCHOOL_PORTAL_URL=https://digischool.example.com
```

## Update Strategy

### Manual Updates
Users download new version and install over existing version.

### Automatic Updates (with MSIX)

```powershell
# MSIX supports auto-updates via Microsoft Store or App Installer
# Configure via app manifest for automatic checks
```

### Update Guide for Users

Create `UPDATE_GUIDE.txt`:
```
DigiSchool Desktop Update

1. Download the latest version from [your download link]
2. Run the installer (or extract ZIP)
3. If upgrading from previous version:
   - Uninstall old version: Settings > Apps > Apps & features > DigiSchool Desktop
   - Or simply run new installer (will replace existing)
4. Desktop shortcuts will update automatically
5. All settings and cache are preserved

If you encounter issues, clear the app cache:
1. Press Windows+R
2. Type: %LOCALAPPDATA%\digischool_desktop
3. Delete the 'cache' folder
4. Restart the app
```

## Distribution Channels

### 1. Direct Download
- Host on your website
- Email users direct link
- Host on OneDrive, Google Drive, etc.
- Simple and fast

### 2. Windows Store
- Professional appearance
- Auto-update capability
- Requires code signing and MSIX
- Microsoft approval process
- Reach Windows users searching Store

### 3. Enterprise Distribution
- Use Intune/MDM for managed devices
- Group Policy deployment
- Custom App Stores
- Version control and compliance

### 4. GitHub Releases
```powershell
# Publish release on GitHub for developers/technical users
gh release create v0.1.0 `
  "DigiSchool-Desktop-v0.1.0.zip" `
  "DigiSchool-Desktop-v0.1.0-Setup.exe"
```

## File Size & Bandwidth

- **Portable ZIP**: ~200-300 MB (includes all dependencies)
- **MSIX**: ~250-350 MB (includes overhead)
- **Total**: ~30-50 MB after compression

Plan for: ~300 MB per user on first download

## Security Considerations

- ✅ Build from official source (your Git repository)
- ✅ Sign code with valid certificate (for production)
- ✅ Use HTTPS for download links
- ✅ Consider checksums/signatures for integrity
- ✅ Disable DevTools in production builds
- ✅ Test thoroughly before distribution
- ✅ Communicate security updates clearly

## Verification Checklist

Before distributing:

- [ ] Build completes without errors
- [ ] Portal URL is correct
- [ ] All features work (auth, data, files, etc.)
- [ ] DevTools disabled (if production)
- [ ] Window size/appearance correct
- [ ] Keyboard shortcuts work
- [ ] No console errors (F12)
- [ ] Network connectivity confirmed
- [ ] Supabase accessible from user networks
- [ ] File size reasonable
- [ ] Version number updated

## Support Resources

Create for users:

1. **Quick Start Guide** - 1-page PDF with download link
2. **Troubleshooting Guide** - FAQ for common issues
3. **Support Email** - address for issues
4. **Release Notes** - what's new in each version

## Example Deployment Script

Save as `deploy.ps1`:

```powershell
param(
    [string]$PortalUrl = "https://digischool.example.com",
    [string]$OutputDir = ".\releases"
)

# Build
flutter build windows --release --dart-define="DIGISCHOOL_PORTAL_URL=$PortalUrl"

# Copy to output
New-Item -ItemType Directory -Force -Path $OutputDir
Copy-Item "flutter_desktop\build\windows\x64\runner\Release\*" -Destination "$OutputDir\portable" -Recurse

# Create ZIP
$version = "0.1.0"
Compress-Archive -Path "$OutputDir\portable" -DestinationPath "$OutputDir\DigiSchool-Desktop-v$version.zip" -Force

# Create MSIX
flutter pub global run msix:create --install-certificate=false

# Verify
Write-Host "Build complete!"
Write-Host "ZIP: $OutputDir\DigiSchool-Desktop-v$version.zip"
Write-Host "MSIX: flutter_desktop\build\windows\msix\digischool_desktop.msix"
```

---

**Ready to deploy?** Test thoroughly on target devices before full rollout!
