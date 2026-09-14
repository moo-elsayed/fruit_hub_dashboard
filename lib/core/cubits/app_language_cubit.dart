import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/local_storage/app_preferences_service.dart';

class AppLanguageCubit extends Cubit<Locale> {
  AppLanguageCubit(this._preferencesService)
    : super(Locale(_preferencesService.getLanguage()));

  final AppPreferencesService _preferencesService;

  Future<void> changeLanguage(String languageCode) async {
    final locale = Locale(languageCode);
    emit(locale);
    await _preferencesService.saveLanguage(languageCode);
  }
}
