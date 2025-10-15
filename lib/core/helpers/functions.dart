import 'dart:developer';
import 'package:fruit_hub_dashboard/core/helpers/shared_preferences_manager.dart';
import '../../features/auth/domain/entities/user_entity.dart';

void errorLogger({required String functionName, required String error}) =>
    log('exception in function $functionName $error');

String getErrorMessage(result) =>
    (result.exception as dynamic).message ?? result.exception.toString();

Future<void> saveUserDataToSharedPreferences(UserEntity entity) async =>
    await Future.wait([
      SharedPreferencesManager.setUsername(entity.name!),
      SharedPreferencesManager.setLoggedIn(true),
    ]);
