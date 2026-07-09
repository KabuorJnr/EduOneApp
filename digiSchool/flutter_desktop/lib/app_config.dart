class AppConfig {
  static const String appName = 'DigiSchool Desktop';
  static const String appTagline =
      'Windows desktop shell for the school portal';
  static const String appVersion = '0.1.0';

  // Portal URL - can be overridden via --dart-define
  static const String portalUrl = String.fromEnvironment(
    'DIGISCHOOL_PORTAL_URL',
    defaultValue: 'http://localhost:5173',
  );

  // Supabase configuration - passed from environment
  static const String supabaseUrl = String.fromEnvironment(
    'VITE_SUPABASE_URL',
    defaultValue: '',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'VITE_SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  // Enable developer tools for debugging
  static const bool enableDevTools =
      String.fromEnvironment('ENABLE_DEV_TOOLS', defaultValue: 'true') ==
      'true';
}
