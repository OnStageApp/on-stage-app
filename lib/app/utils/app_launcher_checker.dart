import 'package:shared_preferences/shared_preferences.dart';

class AppLaunchChecker {
  static const String _firstLaunchKey = 'isFirstLaunch';

  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();

    final isFirstLaunch = prefs.getBool(_firstLaunchKey) ?? true;

    if (isFirstLaunch) {
      await prefs.setBool(_firstLaunchKey, false);
    }

    return isFirstLaunch;
  }
}
