import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/local_storage/local_storage_service.dart';

class SharedPreferencesManager implements LocalStorageService {
  late SharedPreferences _prefs;
  final String _isLoggedInKey = 'isLoggedIn';

  @override
  Future<void> init() async => _prefs = await SharedPreferences.getInstance();

  @override
  Future<void> setLoggedIn(bool isLoggedIn) async =>
      await _prefs.setBool(_isLoggedInKey, isLoggedIn);

  @override
  bool getLoggedIn() => _prefs.getBool(_isLoggedInKey) ?? false;
}
