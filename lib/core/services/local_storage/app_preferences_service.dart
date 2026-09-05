import 'dart:convert';

import 'package:fruit_hub_dashboard/features/auth/data/models/user_model.dart';
import 'package:fruit_hub_dashboard/features/auth/domain/entities/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppPreferencesService {
  Future<void> saveUser(UserEntity user);

  UserEntity? getUser();

  Future<void> clearUser();

  bool isLoggedIn();

  Future<void> saveThemeMode(String theme);

  String getThemeMode();
}

class AppPreferencesServiceImpl implements AppPreferencesService {
  AppPreferencesServiceImpl(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;
  static const String _keyUser = 'cached_user';
  static const String _keyThemeMode = 'theme_mode';

  @override
  Future<void> saveUser(UserEntity user) async {
    final userMap = UserModel.fromUserEntity(user).toJson();
    final jsonString = jsonEncode(userMap);
    await _sharedPreferences.setString(_keyUser, jsonString);
  }

  @override
  UserEntity? getUser() {
    final jsonString = _sharedPreferences.getString(_keyUser);
    if (jsonString == null || jsonString.isEmpty) return null;
    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserModel.fromJson(map).toUserEntity();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearUser() async {
    await _sharedPreferences.remove(_keyUser);
  }

  @override
  bool isLoggedIn() => getUser() != null;

  @override
  Future<void> saveThemeMode(String theme) async =>
      await _sharedPreferences.setString(_keyThemeMode, theme);

  @override
  String getThemeMode() =>
      _sharedPreferences.getString(_keyThemeMode) ?? 'system';
}
