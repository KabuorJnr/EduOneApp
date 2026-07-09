# DigiSchool Desktop - Quick Reference Card

## 🚀 Start Here

**First Time Setup:**
```powershell
# Enable Windows desktop support (one-time)
flutter config --enable-windows-desktop

# Install Flutter deps
npm run flutter:deps

# Start development
npm run desktop:dev
```

**Subsequent Runs:**
```powershell
# Development
npm run desktop:dev

# Production build
npm run desktop:build -PortalUrl 'https://your-domain.com'
```

## 📁 Important Paths

| Path | Purpose |
|------|---------|
| `flutter_desktop/lib/app_shell.dart` | Main UI and webview hosting |
| `flutter_desktop/lib/app_config.dart` | Configuration constants |
| `flutter_desktop/pubspec.yaml` | Flutter dependencies |
| `scripts/desktop-dev.ps1` | Development launcher |
| `scripts/desktop-build.ps1` | Production builder |
| `package.json` | npm scripts for desktop commands |

## 📚 Documentation Map

| Read This | When You... |
|-----------|------------|
| `DESKTOP_SETUP.md` | Want to get started developing |
| `DESKTOP_DEPLOYMENT.md` | Need to build and distribute |
| `DESKTOP_TROUBLESHOOTING.md` | Something isn't working |
| `DESKTOP_SUMMARY.md` | Want project overview |
| `flutter_desktop/README.md` | Need technical details |

## 🎯 Common Commands

```powershell
# Development with auto-refresh
npm run desktop:dev

# Get Flutter dependencies
npm run flutter:deps

# Clean build cache
npm run flutter:clean

# Build for production
npm run desktop:build

# Build for production with custom URL
powershell -File ./scripts/desktop-build.ps1 -PortalUrl 'https://your-domain.com'

# Manual Flutter run (dev)
cd flutter_desktop
flutter run -d windows --dart-define=DIGISCHOOL_PORTAL_URL=http://localhost:5173

# Manual Flutter build (prod)
cd flutter_desktop
flutter build windows --release --dart-define=DIGISCHOOL_PORTAL_URL=https://your-domain.com
```

## ⚙️ Configuration

### Development (localhost)
```powershell
flutter run -d windows --dart-define=DIGISCHOOL_PORTAL_URL=http://localhost:5173
```

### Staging
```powershell
flutter run -d windows --dart-define=DIGISCHOOL_PORTAL_URL=https://staging.digischool.com
```

### Production
```powershell
flutter build windows --release --dart-define=DIGISCHOOL_PORTAL_URL=https://digischool.com
```

## 🐛 Quick Troubleshooting

| Issue | Solution |
|-------|----------|
| "flutter not found" | Add Flutter to PATH, restart PowerShell |
| "Could not open portal" | Start web app: `npm run dev` |
| Blank page in app | Press F12, check Console for errors |
| App crashes on startup | Install WebView2 Runtime |
| Build fails | Run `npm run flutter:clean`, try again |

## 📦 Distribution

**Simple (ZIP):**
```powershell
npm run desktop:build
# Zip the build/output/ folder
# Users extract and run digischool_desktop.exe
```

**Professional (MSIX):**
```powershell
flutter pub global activate msix
flutter pub global run msix:create
```

**Custom (NSIS):**
- See DESKTOP_DEPLOYMENT.md for full NSIS example

## 🔍 DevTools

**Open in running app:** Press `F12`

**Tabs:**
- **Console**: JavaScript errors and logs
- **Network**: HTTP requests, latency
- **Application**: Storage, cookies, cache
- **Elements**: HTML/CSS inspection

## 📊 Build Times

| Build Type | Time | Size |
|-----------|------|------|
| Debug | 3-5 min | 500 MB |
| Release | 5-15 min | 200-300 MB |
| MSIX | 10-20 min | 250-350 MB |

## ✨ Features

✅ 100% web compatibility  
✅ Full Supabase integration  
✅ DevTools debugging  
✅ Navigation controls  
✅ Error recovery  
✅ Multiple environments  
✅ Production ready  

## 🆘 Get Help

1. **Common issues?** → Check DESKTOP_TROUBLESHOOTING.md
2. **Setup problem?** → Read DESKTOP_SETUP.md
3. **Build question?** → See DESKTOP_DEPLOYMENT.md
4. **Code issue?** → Check flutter_desktop/README.md
5. **Still stuck?** → Open GitHub issue with F12 Console errors

## 📞 Key Contacts

- **Flutter Docs**: https://flutter.dev
- **WebView Windows**: https://pub.dev/packages/webview_windows
- **Supabase Docs**: https://supabase.com/docs
- **Windows Build Tools**: https://visualstudio.microsoft.com

## 🎓 Learning Path

1. Run `npm run desktop:dev` (see it work)
2. Read `DESKTOP_SETUP.md` (understand setup)
3. Open `flutter_desktop/lib/app_shell.dart` (study code)
4. Try `npm run desktop:build` (build release)
5. Follow `DESKTOP_DEPLOYMENT.md` (distribute)

## 💡 Pro Tips

- 💡 Hot reload works: Type `r` during `flutter run`
- 💡 Vite HMR auto-refreshes embedded web app
- 💡 F12 devtools are your best friend
- 💡 Use `--dart-define` to pass environment variables
- 💡 Clean build caches often during development
- 💡 Test on multiple machines before distribution
- 💡 Version number in `pubspec.yaml` (update for releases)

---

**Last Updated:** 2026-07-10  
**Version:** 0.1.0  
**Status:** ✅ Production Ready
