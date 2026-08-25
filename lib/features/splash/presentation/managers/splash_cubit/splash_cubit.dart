import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/core/services/local_storage/app_preferences_service.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._appPreferencesService) : super(SplashInitial());

  final AppPreferencesService _appPreferencesService;

  Future<void> checkAppStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    if (_appPreferencesService.isLoggedIn()) {
      emit(SplashNavigationState(SplashNavigation.home));
    } else {
      emit(SplashNavigationState(SplashNavigation.login));
    }
  }
}
