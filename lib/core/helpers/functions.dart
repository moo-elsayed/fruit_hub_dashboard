import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'app_logger.dart';
import 'failures.dart';
import 'network_response.dart';

void errorLogger({required String functionName, required String error}) =>
    log('exception in function $functionName $error');

String getErrorMessage(result) =>
    ((result.exception as dynamic).message ?? result.exception.toString())
        .replaceAll('Exception: ', '');

num getPrice(double price) => price.toInt() == price ? price.toInt() : price;

NetworkFailure<T> handleError<T>(Object e, String functionName) {
  AppLogger.error('error occurred in $functionName', error: e);
  if (e is FirebaseException) {
    return NetworkFailure(
      Exception(ServerFailure.fromFirebaseException(e).errorMessage),
    );
  }
  return NetworkFailure(Exception(e.toString()));
}
