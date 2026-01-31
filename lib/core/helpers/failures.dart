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
        return ServerFailure('Invalid email');
      case 'wrong-password':
        return ServerFailure('Wrong password provided for that user');
      case 'user-not-found':
        return ServerFailure('No user found for that email');
      case 'user-disabled':
        return ServerFailure('User disabled');
      case 'too-many-requests':
        return ServerFailure('Too many requests');
      case 'operation-not-allowed':
        return ServerFailure('Operation not allowed');
      case 'invalid-credential':
        return ServerFailure('Invalid email or password');
      case 'network-request-failed':
        return ServerFailure('Network error message');
      case 'weak-password':
        return ServerFailure('The password provided is too weak');
      case 'email-already-in-use':
        return ServerFailure('The account already exists for that email');
      case 'internal-error':
        return ServerFailure('Internal error');
      case 'app-not-authorized':
        return ServerFailure('App not authorized');
      case 'user-token-expired':
        return ServerFailure('User token expired');
      case 'requires-recent-login':
        return ServerFailure('Requires recent login');
      case 'user-mismatch':
        return ServerFailure('User mismatch');
      case 'quota-exceeded':
        return ServerFailure('Quota exceeded');
      case 'permission-denied':
        return ServerFailure('Permission denied');
      default:
        return ServerFailure('An error occurred, please try again');
    }
  }
}
