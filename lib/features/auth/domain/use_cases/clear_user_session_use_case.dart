import '../../../../core/helpers/app_logger.dart';
import '../../../../core/services/local_storage/local_storage_service.dart';

class ClearUserSessionUseCase {
  ClearUserSessionUseCase(this._localStorageService);

  final LocalStorageService _localStorageService;

  Future<void> call() async {
    try {
      await _localStorageService.setLoggedIn(false);
    } catch (e) {
      AppLogger.error("error in clear user session", error: e.toString());
      throw Exception('Failed to clear user session');
    }
  }
}
