abstract class LocalStorageService {
  Future<void> init();

  Future<void> setLoggedIn(bool isLoggedIn);

  bool getLoggedIn();
}
