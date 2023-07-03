import 'package:shared_preferences/shared_preferences.dart';

class AppPrefrence {

  static Future<bool> getBoolean(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key,) ?? false;
  }

  static Future<bool> putBoolean(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(key, value);
  }

  static Future<String> getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }

  static Future<bool> putString(String key, String? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, value!);
  }

  static Future<bool> putInt(String key, int? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setInt(key, value!);
  }

  static Future<int> getInt(String key, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getInt(key) ?? 0;
  }

  static Future<int> getPreviousDate(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getInt(key) ?? 0;
  }

  static void clearPrefrence() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
