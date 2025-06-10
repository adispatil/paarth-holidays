import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String tokenKey = 'auth_token';
  static const String firstTimeKey = 'is_first_time';
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  Future<void> saveToken(String token) async {
    await _prefs.setString(tokenKey, token);
  }

  String? getToken() {
    return _prefs.getString(tokenKey);
  }

  Future<void> removeToken() async {
    await _prefs.remove(tokenKey);
  }

  bool? getIsFirstTime() {
    return _prefs.getBool(firstTimeKey);
  }

  Future<void> setIsFirstTime(bool value) async {
    await _prefs.setBool(firstTimeKey, value);
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
} 