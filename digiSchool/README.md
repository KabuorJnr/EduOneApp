# DigiShule (EduOne)

DigiShule (also known as EduOne) is a comprehensive, offline-first school management system. It provides role-based portals for students, parents, teachers, and administrators to track attendance, grades, finances, discipline, and parent-teacher meetings.

## Features

- **Role-Based Portals**: Tailored interfaces for Principal, Registrar, Finance, Teachers, Students, and Parents.
- **Offline Support**: PWA with IndexedDB offline caching and background sync when connection is restored.
- **Database Backend**: Powered by Supabase (PostgreSQL) with strict Row Level Security (RLS) policies.
- **Communications**: Automated messaging and SMS broadcast system for notices.
- **Grade Tracking**: CBC-aligned and numerical grade computation with PDF report card generation.

## Getting Started

### Prerequisites

- Node.js (v18 or newer)
- npm or yarn
- Supabase account (for database and auth)

### Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/KabuorJnr/DigiShule.git
   cd DigiShule
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Environment Variables**:
   Copy the example environment file and fill in your credentials.
   ```bash
   cp .env.example .env
   ```
   *Note: Never commit your real `.env` file containing secrets!*

4. **Run the development server**:
   ```bash
   npm run dev
   ```

## Scripts & Tools

All utility scripts for database seeding, testing, and RPC checks are located in the `scripts/` directory.

### Web App Scripts
- `npm run dev`: Start Vite dev server (localhost:5173)
- `npm run build`: Build the frontend for production
- `npm run lint`: Run ESLint across the codebase
- `npm run test`: Run the Vitest test suite
- `npm run preview`: Preview production build locally

### Desktop App Scripts
- `npm run desktop:dev`: Run desktop app connected to local dev server
- `npm run desktop:build`: Build for production (requires portal URL)
- `npm run desktop:build:local`: Build for local dev server
- `npm run flutter:deps`: Install Flutter dependencies
- `npm run flutter:clean`: Clean Flutter build cache

For detailed desktop app setup, see [DESKTOP_SETUP.md](./DESKTOP_SETUP.md).

## Project Structure

- `/src/components`: Reusable UI widgets and layout components.
- `/src/views`: The main portal views (e.g., `StudentPortal`, `AdminDashboard`).
- `/src/data`: Static lookup data and configuration constants.
- `/src/lib`: Supabase client and offline sync logic.
- `/src/tests`: Vitest unit and integration tests.
- `/api`: Serverless functions (e.g., Vercel API routes for email sending).
- `/scripts`: Debugging and database seeding tools.
- `/supabase`: SQL migrations and database schema setup.

## Desktop App (Flutter)

A **Flutter desktop shell** wraps the entire DigiSchool portal in a native Windows application. All features work identically to the web version, with the added benefit of native desktop integration.

### Quick Start

```powershell
# Install Flutter (see DESKTOP_SETUP.md for details)
flutter config --enable-windows-desktop

# Run with local dev server
npm run desktop:dev

# Or manually:
cd flutter_desktop
flutter pub get
flutter run -d windows --dart-define=DIGISCHOOL_PORTAL_URL=http://localhost:5173
```

### Features

✅ **100% Web App Compatibility** - All features work exactly as the web version  
✅ **Native Desktop UI** - Window controls, navigation toolbar, responsive layout  
✅ **Full Backend Access** - Direct Supabase connection (auth, data, storage, realtime)  
✅ **Developer Tools** - F12 devtools for debugging  
✅ **Production Ready** - Build for distribution with your production domain  

### Build for Distribution

```powershell
# Build release executable for production
npm run desktop:build -PortalUrl 'https://your-domain.com'

# Output: build/output/digischool_desktop.exe
# Distribute as ZIP or create Windows installer (MSIX)
```

### Architecture

The desktop app consists of:
- **Flutter Shell** (`flutter_desktop/lib/`) - Window management and UI chrome
- **Embedded WebView** - Renders the React web app
- **Supabase Backend** - All data and auth flows pass through seamlessly

See [flutter_desktop/README.md](./flutter_desktop/README.md) for detailed documentation.  
See [DESKTOP_SETUP.md](./DESKTOP_SETUP.md) for complete setup guide.
