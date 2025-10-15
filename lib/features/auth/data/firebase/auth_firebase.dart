import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/helpers/failures.dart';
import '../../../../core/helpers/firebase_keys.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/helpers/network_response.dart';

class AuthFirebase {
  AuthFirebase._();

  static AuthFirebase? _instance;

  static AuthFirebase get instance => _instance ??= AuthFirebase._();

  final _auth = FirebaseAuth.instance;

  Future<NetworkResponse<User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return NetworkSuccess(credential.user);
    } on FirebaseAuthException catch (e) {
      errorLogger(
        functionName: 'AuthFirebase.signInWithEmailAndPassword',
        error: e.toString(),
      );
      return NetworkFailure(
        Exception(ServerFailure.fromFirebaseException(e).errorMessage),
      );
    } catch (e) {
      errorLogger(
        functionName: 'AuthFirebase.signInWithEmailAndPassword',
        error: e.toString(),
      );
      return NetworkFailure(Exception("error_occurred_please_try_again"));
    }
  }

  Future<NetworkResponse<User>> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return NetworkSuccess(credential.user);
    } on FirebaseAuthException catch (e) {
      errorLogger(
        functionName: 'AuthFirebase.createUserWithEmailAndPassword',
        error: e.toString(),
      );
      return NetworkFailure(
        Exception(ServerFailure.fromFirebaseException(e).errorMessage),
      );
    } catch (e) {
      errorLogger(
        functionName: 'AuthFirebase.createUserWithEmailAndPassword',
        error: e.toString(),
      );
      return NetworkFailure(
        Exception("An unexpected error occurred. Please try again."),
      );
    }
  }

  Future<void> sendEmailVerification() async =>
      await _auth.currentUser!.sendEmailVerification();

  Future<void> signOut() async => await _auth.signOut();

  Future<NetworkResponse<UserCredential>> googleSignIn() async {
    try {
      final GoogleSignIn signIn = GoogleSignIn.instance;

      await signIn.signOut();

      await signIn.initialize(
        clientId: FirebaseKeys.clientId,
        serverClientId: FirebaseKeys.serverClientId,
      );
      final GoogleSignInAccount? googleUser = await signIn
          .attemptLightweightAuthentication();

      if (googleUser == null) {
        errorLogger(
          functionName: 'AuthFirebase.googleSignIn',
          error: 'User canceled sign in',
        );
        return NetworkFailure(Exception("The sign-in process was canceled."));
      }

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      if (googleAuth.idToken == null) {
        errorLogger(
          functionName: 'AuthFirebase.googleSignIn',
          error: 'No idToken received from Google',
        );
        return NetworkFailure(
          Exception(
            "Could not retrieve authentication details from Google. Please try again.",
          ),
        );
      }

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      var userCredential = await _auth.signInWithCredential(credential);
      return NetworkSuccess(userCredential);
    } on FirebaseAuthException catch (e) {
      errorLogger(
        functionName: 'AuthFirebase.googleSignIn',
        error: e.toString(),
      );
      return NetworkFailure(
        Exception(ServerFailure.fromFirebaseException(e).errorMessage),
      );
    } on PlatformException catch (e) {
      errorLogger(
        functionName: 'AuthFirebase.googleSignIn',
        error: e.toString(),
      );
      return NetworkFailure(
        Exception(
          "A platform error occurred during Google sign-in. Please check your connection and try again.",
        ),
      );
    } catch (e) {
      errorLogger(
        functionName: 'AuthFirebase.googleSignIn',
        error: e.toString(),
      );
      return NetworkFailure(
        Exception(
          "An unexpected error occurred during Google sign-in. Please try again.",
        ),
      );
    }
  }

  Future<void> forgetPassword(String email) async =>
      await _auth.sendPasswordResetEmail(email: email);
}
