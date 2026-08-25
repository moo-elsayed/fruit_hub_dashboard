import 'package:equatable/equatable.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';

abstract class Failure extends Equatable {
  const Failure({required this.error});

  final String error;

  @override
  List<Object?> get props => [error];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.error});

  factory ServerFailure.fromException(Object exception) {
    final String errorStr = exception.toString().toLowerCase();

    if (errorStr.contains('invalid-credential') ||
        errorStr.contains('invalid_credential') ||
        errorStr.contains('invalid-login-credentials') ||
        errorStr.contains('wrong-password') ||
        errorStr.contains('user-not-found')) {
      return const ServerFailure(error: AppStrings.invalidCredential);
    } else if (errorStr.contains('email-already-in-use')) {
      return const ServerFailure(error: AppStrings.emailAlreadyInUse);
    } else if (errorStr.contains('account-exists-with-different-credential') ||
        errorStr.contains('account_exists_with_different_credential')) {
      return const ServerFailure(
        error: AppStrings.accountExistsWithDifferentCredential,
      );
    } else if (errorStr.contains('invalid-email')) {
      return const ServerFailure(error: AppStrings.invalidEmail);
    } else if (errorStr.contains('too-many-requests')) {
      return const ServerFailure(error: AppStrings.tooManyRequests);
    } else if (errorStr.contains('permission-denied')) {
      return const ServerFailure(error: AppStrings.permissionDenied);
    } else if (errorStr.contains('user-disabled')) {
      return const ServerFailure(error: AppStrings.userDisabled);
    } else if (errorStr.contains('operation-not-allowed')) {
      return const ServerFailure(error: AppStrings.operationNotAllowed);
    } else if (errorStr.contains('network-request-failed') ||
        errorStr.contains('socketexception')) {
      return const ServerFailure(error: AppStrings.noInternetConnection);
    } else if (errorStr.contains('web-context-canceled') ||
        errorStr.contains('web_context_canceled') ||
        errorStr.contains('popup-closed-by-user') ||
        errorStr.contains('sign_in_canceled') ||
        errorStr.contains('canceled') ||
        errorStr.contains('cancelled')) {
      return const ServerFailure(error: AppStrings.googleSignInCancelled);
    }

    return const ServerFailure(error: AppStrings.unexpectedError);
  }

  factory ServerFailure.fromFirebaseException(Object exception) =>
      ServerFailure.fromException(exception);
}

class AuthFailure extends Failure {
  const AuthFailure({required super.error});
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({required super.error});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.error});
}
