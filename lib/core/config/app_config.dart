/// Typed values for the About screen, loaded from `assets/config/app_config.json`.
/// Changing About content is a config edit, not a code change.
class AppConfig {
  final String appName;
  final String description;
  final String version;
  final String build;
  final Map<String, String> details;

  const AppConfig({
    required this.appName,
    required this.description,
    required this.version,
    required this.build,
    this.details = const {},
  });

  /// Safe built-in value used when the config file is missing or malformed,
  /// so the app never crashes on a bad config.
  static const AppConfig fallback = AppConfig(
    appName: 'Sreeraj P QR Reader',
    description:
        'A comprehensive QR and Barcode scanner application with 6-layer URL safety analysis.',
    version: '1.4.3',
    build: '1',
    details: {
      'Author': 'Sreeraj P',
      'Email': 'sreerajp80@gmail.com',
      'License': 'All libraries used are open source.',
      'AI used': 'Claude 4.6, Gemini 3.6, ChatGPT 5.4',
      'IDE used': 'VS Code / Gemini Antigravity IDE',
    },
  );

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    String str(String key, String fallbackValue) {
      final value = json[key];
      return value is String ? value : fallbackValue;
    }

    Map<String, String> parseStringMap(String key) {
      final raw = json[key];
      if (raw is! Map) return const {};
      final out = <String, String>{};
      raw.forEach((k, v) {
        if (k is String && v is String) out[k] = v;
      });
      return out;
    }

    return AppConfig(
      appName: str('appName', fallback.appName),
      description: str('description', fallback.description),
      version: str('version', fallback.version),
      build: str('build', fallback.build),
      details: parseStringMap('details'),
    );
  }
}
