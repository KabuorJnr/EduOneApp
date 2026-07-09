# DigiSchool Flutter Desktop

This folder contains a Flutter desktop shell for the existing DigiSchool portal.
It does not reimplement the whole school system in Dart; instead, it opens the current web app inside a native Windows desktop window so the product can be shipped as a desktop app with minimal behavioral drift.

## What it does

- Uses Flutter for the desktop shell and window chrome.
- Loads the existing portal URL in an embedded WebView.
- Lets you point the shell at any environment with `--dart-define`.

## Prerequisites

- Flutter SDK with Windows desktop support enabled.
- The existing DigiSchool web app running locally or deployed somewhere reachable.

## Run

```bash
flutter config --enable-windows-desktop
flutter pub get
flutter run -d windows --dart-define=DIGISCHOOL_PORTAL_URL=http://localhost:5173
```

If you want to target a deployed portal instead of the local Vite server, change the URL:

```bash
flutter run -d windows --dart-define=DIGISCHOOL_PORTAL_URL=https://your-portal.example.com
```

## Build

```bash
flutter build windows --dart-define=DIGISCHOOL_PORTAL_URL=https://your-portal.example.com
```

## Notes

- The shell defaults to `http://localhost:5173`, which matches the Vite development server used by the current React app.
- If you want a fully native Flutter rewrite of the portal screens, this shell can be used as the starting point for that migration.
