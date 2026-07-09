# DigiSchool Desktop - Troubleshooting Guide

Common issues and solutions for the DigiSchool desktop application.

## Installation & Setup Issues

### "Flutter command not found"

**Error**: PowerShell says `flutter` is not recognized

**Solution**:
1. Download Flutter SDK from https://flutter.dev/docs/get-started/install/windows
2. Extract to a folder (e.g., `C:\flutter`)
3. Add to Windows PATH:
   - Right-click This PC → Properties
   - Click "Advanced system settings"
   - Click "Environment Variables"
   - Edit `Path` variable
   - Add: `C:\flutter\bin`
   - Restart PowerShell
4. Verify: `flutter --version`

---

### "Visual Studio Build Tools not found"

**Error**: Build fails with C++ compiler errors

**Solution**:
1. Download Visual Studio Build Tools: https://visualstudio.microsoft.com/downloads/
2. Run installer
3. Select "Desktop development with C++"
4. Complete installation (~5-10 GB)
5. Restart computer
6. Try build again

---

### "WebView2 runtime not found"

**Error**: App crashes on startup with WebView error

**Solution**:
1. Download WebView2 Runtime: https://go.microsoft.com/fwlink/p/?LinkId=2124703
2. Install it
3. Restart app

---

## Development & Running

### "Could not open the portal" error

**Symptoms**: Desktop app shows error message, can't load web portal

**Causes & Solutions**:

**Cause 1: Web app not running**
```powershell
# Terminal 1: Start web app
npm run dev
# Wait for: "Local: http://localhost:5173"

# Terminal 2: Start desktop app
npm run desktop:dev
```

**Cause 2: Wrong portal URL**
```powershell
# Check the URL you're passing
flutter run -d windows --dart-define=DIGISCHOOL_PORTAL_URL=http://localhost:5173
#                                                                    ^^^^^^^^^^^
#                                     Must match where web app is running
```

**Cause 3: Network connectivity**
- Check: Can you access `http://localhost:5173` in browser?
- If no → Web app isn't running
- If yes but desktop app still fails → Firewall issue

**Cause 4: Backend not accessible**
- Press F12 in desktop app
- Check Console tab for red errors
- Look for 401/403 errors (auth issues)
- Check Network tab for failed requests to Supabase

---

### App shows blank/white page

**Symptoms**: App loads but portal is completely blank

**Debug steps**:
1. Press F12 to open devtools
2. Go to Console tab
3. Look for red error messages
4. Report what you see

**Common causes**:

**Blank page + Console errors**:
- Supabase not configured → Check `.env` file has `VITE_SUPABASE_URL` and key
- JavaScript error → Fix error shown in console
- Missing API → Check backend is running

**Blank page + No errors**:
- Portal URL wrong → Verify with `--dart-define` flag
- Network connectivity → Try reloading (button in sidebar)
- Backend down → Check Supabase dashboard

---

### Hot reload not working

**Issue**: Changes to Flutter code don't appear without rebuild

**Solution**:
```powershell
# During `flutter run`:
# Type 'r' to hot-reload (keeps state)
# Type 'R' to hot-restart (clears state)

# If neither works, stop (Ctrl+C) and restart:
flutter run -d windows --dart-define=DIGISCHOOL_PORTAL_URL=http://localhost:5173
```

---

### "No devices found"

**Error**: `No devices found / flutter run` won't start

**Solution**:
```powershell
# Check connected devices
flutter devices

# If no 'windows' listed, enable it
flutter config --enable-windows-desktop

# Check status
flutter doctor

# Try explicit device
flutter run -d windows --dart-define=DIGISCHOOL_PORTAL_URL=http://localhost:5173
```

---

## Authentication Issues

### Can't log in / "Invalid credentials"

**Cause 1: Supabase not configured**
```powershell
# Check .env file has:
# VITE_SUPABASE_URL=https://xxx.supabase.co
# VITE_SUPABASE_ANON_KEY=eyJ...

# If missing, copy from .env.example and fill in
```

**Cause 2: CORS blocking requests**
1. Open F12 devtools (press F12)
2. Go to Network tab
3. Try to log in
4. Look for red requests to `supabase.co`
5. If blocked with CORS error → Backend issue

**Solution**:
- Check Supabase console: Settings → API → CORS
- Ensure your portal URL is listed under allowed origins

**Cause 3: User doesn't exist**
- Create user in Supabase dashboard
- Or ensure user email exists in auth table

---

### "Refresh token expired" / "Session expired"

**Cause**: Been logged in too long without activity

**Solution**:
- Log out and log in again
- Or reload the app

---

## Performance Issues

### App is slow / takes long to load

**Cause 1: Low internet speed**
- Normal for connections < 5 Mbps
- Nothing to fix (unless network issue)

**Cause 2: Backend is slow**
1. Open F12 devtools
2. Go to Network tab
3. Reload the portal
4. Look for slow requests (> 3 seconds)
5. If requests to Supabase are slow → Backend optimization needed

**Cause 3: Computer resources low**
```powershell
# Check Task Manager
# Watch Resources tab
# If Memory > 90% or CPU > 80% constantly → Upgrade computer or close other apps
```

---

### High CPU usage / Battery drain

**Cause 1: Background processes**
- Close other browser tabs/apps
- Disable auto-refresh features (if any)

**Cause 2: WebView actively rendering**
- Nothing to do (inherent with embedded browser)
- Close app if not using

---

## UI & Display Issues

### Sidebar missing / UI broken

**Cause**: Window too small

**Solution**:
- Drag window edge to expand
- Or close and reopen app
- Default minimum size: 1180x760

---

### Text is blurry / zoomed wrong

**Cause**: DPI scaling

**Solution**:
```powershell
# Desktop app respects system DPI
# Adjust in Settings → Display → Scale and layout
# Default: 100%
```

---

### Navigation buttons don't work

**Cause 1: Already at first/last page**
- Back button disabled on first page
- Forward button disabled on last page

**Cause 2: WebView issue**
```powershell
# Reload portal (sidebar button)
# Or restart app
```

---

## Network Issues

### "Network error" / Can't reach backend

**Check network connectivity**:
```powershell
# Test connection to portal
ping google.com

# Test connection to Supabase
ping your-project.supabase.co

# Check firewall
# Windows Defender Firewall > Allow an app through firewall
# Make sure digischool_desktop.exe is allowed
```

**If behind corporate proxy**:
- Portal URL must be accessible through proxy
- Contact IT department for configuration

---

### Can't upload files

**Cause 1: Supabase Storage not configured**
- Check `.env` has Supabase credentials
- Check Storage bucket exists in Supabase dashboard

**Cause 2: File too large**
- Max upload: Usually 50 MB (configurable)
- Try smaller file

**Cause 3: No internet**
- Check network connection
- See "Network error" section above

---

## Build Issues

### "Build failed with error X"

**Step 1: Clean and try again**
```powershell
npm run flutter:clean
npm run desktop:dev
```

**Step 2: Update Flutter**
```powershell
flutter upgrade
flutter pub get
```

**Step 3: Check dependencies**
```powershell
flutter doctor
# Fix any issues shown
```

**Step 4: Check logs**
```powershell
flutter run -d windows --dart-define=DIGISCHOOL_PORTAL_URL=http://localhost:5173 -v
# Look for detailed error message
# Search error message on GitHub issues
```

---

### "Out of memory" during build

**Cause**: Not enough RAM or disk space

**Solution**:
- Close other applications
- Free up disk space (at least 5 GB free)
- Restart computer
- Try build again

---

### Built app won't start

**Cause 1: Portal URL misconfigured at build time**
```powershell
# Rebuild with correct URL
flutter build windows --dart-define=DIGISCHOOL_PORTAL_URL=https://your-domain.com
```

**Cause 2: WebView2 runtime missing on user machine**
- See "WebView2 runtime not found" above

**Cause 3: Missing dependencies**
- Ensure Visual C++ runtime is installed on target machine
- Download: https://support.microsoft.com/en-us/topic/kb2977609

---

## Data & Persistence Issues

### Data not syncing between web and desktop

**Expected**: Desktop app shows same data as web portal

**Check**:
1. Same Supabase project in both? → Check `.env`
2. Same login account? → Verify email/user
3. Other browser tabs show data? → If no, backend issue (not app)
4. Try reload → Press reload button in sidebar

---

### Session lost after restart

**Expected behavior**: Users must log in again after app restart

**If unexpected**: This is by design

**To persist login**:
- Implement remember-me (future feature)
- Or manual: Save auth token in browser storage

---

## Debugging with DevTools

**Open DevTools**: Press F12

### Console Tab
Shows JavaScript errors and debug logs
- Red text = Error (needs fixing)
- Yellow text = Warning (usually okay)
- Blue text = Info (helpful for debugging)

### Network Tab
Shows all HTTP requests
- Look for red errors (failed requests)
- Check timing (slow requests)
- Verify requests go to correct domain

### Application Tab
Shows storage, cookies, cache
- Check local storage has auth token
- Clear cache if having issues

### Elements Tab
Inspect HTML/CSS
- Right-click UI element → Inspect
- See what DOM structure looks like
- Check applied CSS

---

## Getting Help

If you've tried troubleshooting and still stuck:

1. **Check this guide again** - Most issues are covered
2. **Check browser devtools (F12)** - Almost always shows the actual error
3. **Check Supabase dashboard** - Backend status, logs
4. **Check Flutter doctor** - `flutter doctor` shows environment issues
5. **Search GitHub issues** - Your error might be reported
6. **Ask for help** - Include:
   - Error message (exact text)
   - Screenshots
   - What you were doing
   - Devtools Console errors
   - Flutter version
   - Windows version

---

## Common Error Messages

### "Connection refused / ERR_CONNECTION_REFUSED"
- Portal URL is wrong
- Web app not running
- Firewall blocking
→ Check portal URL and web app status

### "ERR_SSL_PROTOCOL_ERROR"
- HTTPS certificate issue
- Only for production URLs
→ Ensure certificate is valid

### "ERR_NAME_NOT_RESOLVED"
- Can't reach domain
- DNS not resolving
→ Check domain name and internet connection

### "No providers of 'AuthService' were found"
- Angular-related error (shouldn't happen)
- Framework mismatch
→ Ensure using React portal URL

### "Maximum call stack size exceeded"
- Infinite loop in JavaScript
- UI framework issue
→ Clear cache, restart app, check portal for errors

### "Out of memory"
- RAM exhausted
- Memory leak in portal
→ Restart app, close other programs

---

## Still Stuck?

Create an issue on GitHub with:
```
**Error**: [exact error message]
**Steps to reproduce**:
1. [step 1]
2. [step 2]
**Expected**: [what should happen]
**Actual**: [what happened]
**DevTools Console**:
[paste errors from F12 > Console]
**System Info**:
- Windows version: [e.g., Windows 11]
- Flutter version: `flutter --version`
- Portal URL: [the URL you used]
```

This will help maintainers reproduce and fix the issue.
