import 'package:shared_preferences/shared_preferences.dart';

enum AppEnvironment { development, production }

const String envKey = 'app_environment';

class EnvironmentManager {
  static AppEnvironment _currentEnv = AppEnvironment.production;

  /// Initialize the environment by reading from shared preferences
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final storedEnv = prefs.getString(envKey) ?? AppEnvironment.production.name;
    _currentEnv = AppEnvironment.values.firstWhere(
      (e) => e.name == storedEnv,
      orElse: () => AppEnvironment.production,
    );
  }

  /// Get the current environment
  static AppEnvironment get currentEnvironment => _currentEnv;

  /// Set the environment and persist it
  static Future<void> setEnvironment({
    required AppEnvironment env,
    required Future<void> Function() onChange,
  }) async {
    if (_currentEnv != env) {
      _currentEnv = env;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(envKey, env.name);
      await onChange(); // Callback for additional actions
    }
  }

  /// Check if the current environment is production
  static bool get isProduction => _currentEnv == AppEnvironment.production;
}
