import 'package:shared_preferences/shared_preferences.dart';

class LoginPrefsService {
  static const _tokenKey = 'token';
  static const _keepLoggedInKey = 'keepLoggedIn';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> setKeepLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keepLoggedInKey, value);
  }

  static Future<bool> getKeepLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keepLoggedInKey) ?? false;
  }

  static Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_keepLoggedInKey);
  }
}
