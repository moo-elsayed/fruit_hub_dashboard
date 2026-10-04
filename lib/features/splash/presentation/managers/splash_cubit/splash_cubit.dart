import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/core/services/local_storage/app_preferences_service.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._appPreferencesService, {FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      super(SplashInitial());

  final AppPreferencesService _appPreferencesService;
  final FirebaseAuth _firebaseAuth;

  Future<void> checkAppStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    final isFirebaseLoggedIn = _firebaseAuth.currentUser != null;
    final isLocalLoggedIn = _appPreferencesService.isLoggedIn();

    if (isFirebaseLoggedIn && isLocalLoggedIn) {
      emit(SplashNavigationState(SplashNavigation.home));
    } else {
      if (!isFirebaseLoggedIn && isLocalLoggedIn) {
        await _appPreferencesService.clearUser();
      }
      emit(SplashNavigationState(SplashNavigation.login));
    }
  }
}
