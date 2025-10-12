import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Failure {
  Failure(this.errorMessage);

  final String errorMessage;
}

class ServerFailure extends Failure {
  ServerFailure(super.errorMessage);

  factory ServerFailure.fromFirebaseException(FirebaseException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return ServerFailure('invalid_email');
      case 'wrong-password':
        return ServerFailure("wrong_password_provided_for_that_user");
      case 'user-not-found':
        return ServerFailure("no_user_found_for_that_email");
      case 'user-disabled':
        return ServerFailure('user_disabled');
      case 'too-many-requests':
        return ServerFailure('too_many_requests');
      case 'operation-not-allowed':
        return ServerFailure('operation_not_allowed');
      case 'invalid-credential':
        return ServerFailure("invalid_email_or_password");
      case 'network-request-failed':
        return ServerFailure("network_error_message");
      case 'weak-password':
        return ServerFailure("the_password_provided_is_too_weak");
      case 'email-already-in-use':
        return ServerFailure("the_account_already_exists_for_that_email");
      case 'internal-error':
        return ServerFailure("internal_error");
      case 'app-not-authorized':
        return ServerFailure("app_not_authorized");
      case 'user-token-expired':
        return ServerFailure("user_token_expired");
      case 'requires-recent-login':
        return ServerFailure("requires_recent_login");
      case 'user-mismatch':
        return ServerFailure("user_mismatch");
      case 'quota-exceeded':
        return ServerFailure("quota_exceeded");
      case 'permission-denied':
        return ServerFailure("permission-denied");
      default:
        return ServerFailure("error_occurred_please_try_again");
    }
  }
}
