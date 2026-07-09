# DigiSchool Flutter Desktop

This folder contains a Flutter desktop shell for the existing DigiSchool portal. It embeds the React web app in a native Windows desktop window while maintaining full connectivity to the Supabase backend.

## Architecture

The desktop app consists of:
- **Flutter Shell** (`lib/main.dart`, `lib/app_shell.dart`): Window management, navigation UI, and webview hosting
- **Embedded WebView**: Loads the existing React web app and all its features
- **Backend Connection**: Transparent pass-through to Supabase (authentication, database, storage, etc.)
- **All Features**: 100% of web app functionality is available through the embedded view

## Prerequisites

- Flutter SDK (3.5.0+) with Windows desktop support enabled
- The existing DigiSchool web app running locally or deployed
- Supabase backend configured and accessible

## Quick Start

### 1. Enable Windows Desktop Support (first time only)

```bash
flutter config --enable-windows-desktop
```

### 2. Get Dependencies

```bash
cd flutter_desktop
flutter pub get
```

### 3. Run with Local Dev Server

Start the web app in one terminal:
```bash
npm run dev
```

Run the desktop app in another terminal:
```bash
flutter run -d windows --dart-define=DIGISCHOOL_PORTAL_URL=http://localhost:5173
```

### 4. Run Against Production

```bash
flutter run -d windows --dart-define=DIGISCHOOL_PORTAL_URL=https://your-digischool-domain.com
```

## Features

✅ **Full Web App Integration**
- All React components work identically
- Authentication flows (Supabase) working out of the box
- Real-time database updates
- File uploads and downloads
- All third-party integrations (email, PDF export, etc.)

✅ **Native Desktop Features**
- Window controls (minimize, maximize, close, resize)
- Navigation toolbar (back, forward, reload)
- Developer tools (F12) for debugging
- Auto-fill for forms (username, password)
- Responsive layout (sidebar + main content)

✅ **Seamless Backend Connection**
- Supabase authentication flows
- Real-time listening via WebSocket
- File storage operations
- Email and notification services

## Building for Distribution

### Development Build (Debug)
```bash
flutter build windows --dart-define=DIGISCHOOL_PORTAL_URL=https://your-domain.com -v
```

### Release Build (Optimized)
```bash
flutter build windows --release --dart-define=DIGISCHOOL_PORTAL_URL=https://your-domain.com
```

The resulting executable will be in:
```
build/windows/x64/runner/Release/digischool_desktop.exe
```

## Configuration

### Via --dart-define

Pass configuration at runtime:
```bash
flutter run -d windows \
  --dart-define=DIGISCHOOL_PORTAL_URL=http://localhost:5173 \
  --dart-define=ENABLE_DEV_TOOLS=true
```

### Environment Variables

Available `--dart-define` flags:
- `DIGISCHOOL_PORTAL_URL`: Portal URL (default: `http://localhost:5173`)
- `VITE_SUPABASE_URL`: Supabase project URL (read from web app)
- `VITE_SUPABASE_ANON_KEY`: Supabase public key (read from web app)
- `ENABLE_DEV_TOOLS`: Enable F12 devtools (default: `true`)

## Troubleshooting

### "Could not open the portal" Error

1. Check that the web app is running at the specified URL
2. Verify network connectivity
3. Check browser devtools (F12) inside the app for JavaScript errors
4. Review backend logs (Supabase Dashboard)

### WebView Not Loading

- Ensure `DIGISCHOOL_PORTAL_URL` environment variable is correct
- Check Windows Defender/antivirus isn't blocking the app
- Try reloading the portal (button in sidebar)

### Authentication Not Working

- Verify Supabase credentials are correct in the web app
- Check CORS settings in Supabase console
- Ensure redirects include `http://localhost:5173` (for dev)

### Performance Issues

- Close unnecessary browser tabs on the local machine
- Ensure backend API responses are optimized
- Monitor network in browser devtools (F12 > Network tab)

## Development

### File Structure
```
flutter_desktop/
├── lib/
│   ├── main.dart          # App entry point and window setup
│   ├── app_shell.dart     # Shell UI, webview, navigation
│   └── app_config.dart    # Configuration and constants
├── pubspec.yaml           # Dependencies
├── windows/               # Windows-specific native code
└── README.md              # This file
```

### Key Dependencies
- `webview_windows`: Embedded Chromium webview
- `window_manager`: Window control API
- `url_launcher`: Open links in external browser
- `shared_preferences`: Local storage (future)
- `path_provider`: File system access (future)

### Hot Reload

During development, you can hot-reload the Flutter shell:
```bash
flutter run -d windows --dart-define=DIGISCHOOL_PORTAL_URL=http://localhost:5173
# Type 'r' in console to hot-reload
# Type 'R' to hot-restart
```

The embedded web app will auto-refresh due to Vite's HMR.

### Adding Native Features

To add native desktop features (file picker, system tray, etc.), add packages from pub.dev:
```bash
flutter pub add package_name
flutter run -d windows
```

## Distribution

### MSIX Installer

To create a Windows installer:
```bash
flutter pub global activate msix
flutter pub global run msix:create
```

This generates an `.msix` file suitable for:
- Windows Store distribution
- Enterprise deployment
- Standalone installer

### Standalone EXE

The release build in `build/windows/x64/runner/Release/digischool_desktop.exe` can be:
- Zipped and distributed
- Run on any Windows 10/11 machine
- Included in your own installer

## License

Same as the main DigiSchool project.

## Support

For issues, feature requests, or questions:
1. Check the troubleshooting section above
2. Review browser devtools (F12) for errors
3. Check Supabase dashboard for backend issues
4. Open an issue in the main repository

