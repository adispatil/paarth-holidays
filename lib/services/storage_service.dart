import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String tokenKey = 'auth_token';
  static const String firstTimeKey = 'is_first_time';
  static const String isProfileCompletedKey = 'is_profile_completed';
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

  Future<void> saveIsProfileCompleted(bool value) async {
    await _prefs.setBool(isProfileCompletedKey, value);
  }

  bool getIsProfileCompleted() {
    return _prefs.getBool(isProfileCompletedKey) ?? false;
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
} 