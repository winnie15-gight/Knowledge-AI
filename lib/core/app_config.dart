class AppConfig {
  static const String defaultBaseUrl = 'https://lovewise-flow.onrender.com';

  static String get baseUrl {
    const fromEnv = String.fromEnvironment('BACKEND_BASE_URL');
    return fromEnv.isNotEmpty ? fromEnv : defaultBaseUrl;
  }
}
