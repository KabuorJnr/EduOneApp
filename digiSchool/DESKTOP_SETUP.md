# DigiSchool Desktop - Getting Started Guide

Welcome! This guide walks you through setting up and running the DigiSchool desktop application.

## What is the DigiSchool Desktop App?

The DigiSchool Desktop App is a native Windows application that embeds the DigiSchool web portal. It provides:

✅ **All web app features** - Everything works exactly as the web version
✅ **Native desktop integration** - Window controls, navigation toolbar, keyboard shortcuts
✅ **Full backend access** - Direct connection to Supabase for authentication, data, files, etc.
✅ **Offline-ready** - PWA support means some features work offline (with proper setup)

## Prerequisites

Before you start, ensure you have:

1. **Node.js** (v16+) - [Download](https://nodejs.org)
2. **Flutter SDK** (3.5.0+) - [Download](https://flutter.dev)
3. **Visual Studio Build Tools** - Required for Windows desktop development
4. **Git** - [Download](https://git-scm.com)

## Step 1: Install Flutter & Windows Desktop Support

### Windows Build Tools

You need Visual Studio build tools for C++ development. Install via:

```powershell
# Option A: Install Visual Studio (includes build tools)
# Download from https://visualstudio.microsoft.com/downloads/
# Select "Desktop development with C++"

# Option B: Install build tools only (smaller download)
# Download from https://visualstudio.microsoft.com/downloads/
# Search for "Build Tools for Visual Studio"
```

### Flutter Setup

```powershell
# Download Flutter from https://flutter.dev/docs/get-started/install/windows
# Add Flutter to PATH (usually C:\flutter\bin)

# Verify installation
flutter --version

# Enable Windows desktop support
flutter config --enable-windows-desktop

# Check for any issues
flutter doctor
```

## Step 2: Set Up the Project

```powershell
# Clone and navigate to project
git clone <your-repo-url>
cd digiSchool

# Install Node dependencies for web app
npm install

# Install Flutter dependencies for desktop app
npm run flutter:deps
```

## Step 3: Run in Development

### Option A: Using the Development Script (Recommended)

```powershell
# This automatically starts the web server and desktop app
npm run desktop:dev
```

The script will:
1. Check if Flutter is installed ✓
2. Start the web app dev server (`npm run dev`) if needed
3. Install Flutter dependencies
4. Launch the desktop app connected to `http://localhost:5173`

### Option B: Manual Setup (For troubleshooting)

**Terminal 1 - Web App:**
```powershell
npm run dev
# App runs at http://localhost:5173
```

**Terminal 2 - Desktop App:**
```powershell
cd flutter_desktop
flutter pub get
flutter run -d windows --dart-define=DIGISCHOOL_PORTAL_URL=http://localhost:5173
```

## Step 4: Use the App

Once running, you'll see:

- **Sidebar (left)**: App info, status, portal target, reload button
- **Main area (right)**: Embedded web portal
- **Toolbar (top)**: Back, forward, reload navigation controls

### Features Available

All features from the web app work:
- ✅ User authentication (Supabase)
- ✅ Dashboard & analytics
- ✅ Student/teacher/admin management
- ✅ Classes, schedules, attendance
- ✅ File uploads & downloads
- ✅ Real-time data sync
- ✅ Email notifications
- ✅ PDF exports
- ✅ All custom features

### Keyboard Shortcuts

- `F12` - Open developer tools (if enabled)
- `Ctrl+R` - Reload page
- `Ctrl+Shift+I` - Inspect element (via devtools)
- `Backspace` - Go back

## Step 5: Build for Distribution

Once you're ready to distribute the desktop app:

### Build for Production

```powershell
# Build with your production domain
npm run desktop:build

# Or customize the URL
powershell -ExecutionPolicy Bypass -File ./scripts/desktop-build.ps1 -PortalUrl 'https://your-digischool.com'
```

### Output

The built app is in: `build/output/`
- Main executable: `digischool_desktop.exe`
- All runtime dependencies included

### Distribution Options

**Option 1: Direct Distribution**
- Zip the `build/output/` folder
- Users extract and run `digischool_desktop.exe`
- No installation needed

**Option 2: Windows Installer (MSIX)**
```powershell
cd flutter_desktop
flutter pub global activate msix
flutter pub global run msix:create
```

This creates an `.msix` installer file for:
- Windows Store distribution
- Enterprise deployment
- Auto-update support

**Option 3: Custom Installer**
- Use a tool like NSIS or Inno Setup
- Bundle the `digischool_desktop.exe` and dependencies
- Add shortcuts, uninstaller, registry entries

## Configuration

### Changing the Portal URL

At runtime (development):
```powershell
flutter run -d windows --dart-define=DIGISCHOOL_PORTAL_URL=https://your-domain.com
```

At build time:
```powershell
flutter build windows --dart-define=DIGISCHOOL_PORTAL_URL=https://your-domain.com
```

### Disabling Developer Tools for Production

```powershell
flutter build windows \
  --dart-define=DIGISCHOOL_PORTAL_URL=https://your-domain.com \
  --dart-define=ENABLE_DEV_TOOLS=false
```

## Troubleshooting

### "Flutter not found"

**Solution**: Add Flutter to your system PATH
1. Download Flutter SDK
2. Extract to a folder (e.g., `C:\flutter`)
3. Add `C:\flutter\bin` to Windows PATH
4. Restart PowerShell
5. Verify: `flutter --version`

### "Web app not running" Error

**Solution**: Start the web app first
```powershell
# Terminal 1
npm run dev

# Terminal 2 (wait 5 seconds for server to start)
npm run desktop:dev
```

### "Could not open the portal" in Desktop App

**Causes & Solutions**:
- Web app not running → Start with `npm run dev`
- Wrong URL configured → Update `--dart-define=DIGISCHOOL_PORTAL_URL`
- Network blocked → Check Windows Firewall
- Backend unavailable → Check Supabase status

**Debug steps**:
1. Press `F12` to open browser devtools
2. Check Console tab for JavaScript errors
3. Check Network tab for failed requests
4. Verify Supabase credentials in `.env`

### "Build failed with cryptic error"

**Solution**: Clean and rebuild
```powershell
npm run flutter:clean
npm run desktop:dev
```

### App runs but shows blank page

**Causes**:
- Web app not accessible
- CORS issues
- Supabase not configured
- JavaScript errors in portal

**Debug**:
1. Open F12 devtools
2. Check Console for red errors
3. Check Network for failed requests
4. Verify `.env` has `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY`

## Architecture Overview

```
┌─────────────────────────────────┐
│  DigiSchool Desktop (Flutter)   │
│  ┌───────────────────────────┐  │
│  │  Window Shell + Toolbar   │  │
│  │  (Flutter, Windows)       │  │
│  ├───────────────────────────┤  │
│  │  WebView                  │  │
│  │  ┌─────────────────────┐  │  │
│  │  │ DigiSchool Web App  │  │  │
│  │  │ (React, Vite)       │  │  │
│  │  └─────────────────────┘  │  │
│  └───────────────────────────┘  │
│            │                     │
└────────────┼─────────────────────┘
             │
             ▼
      ┌────────────────┐
      │ Supabase       │
      │ - Database     │
      │ - Auth         │
      │ - Storage      │
      │ - Realtime     │
      └────────────────┘
```

## Next Steps

1. **Development**: Run `npm run desktop:dev` daily for development
2. **Testing**: Test all features in the desktop app
3. **Deployment**: Build and distribute when ready
4. **Feedback**: Gather user feedback and iterate

## Support & Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [WebView Windows Plugin](https://pub.dev/packages/webview_windows)
- [Window Manager Plugin](https://pub.dev/packages/window_manager)
- [Supabase Documentation](https://supabase.com/docs)

## Tips

- 💡 Hot reload works for the Flutter shell (type `r` during dev)
- 💡 Vite HMR auto-refreshes the embedded web app
- 💡 F12 devtools are your friend for debugging
- 💡 Build times are ~5-10 minutes for first build
- 💡 Start with local dev before testing against production

Happy building! 🚀
