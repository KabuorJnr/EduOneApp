class AppConfig {
  static const String appName = 'DigiSchool Desktop';
  static const String appTagline = 'Windows desktop shell for the school portal';
  static const String portalUrl = String.fromEnvironment(
    'DIGISCHOOL_PORTAL_URL',
    defaultValue: 'http://localhost:5173',
  );
}
