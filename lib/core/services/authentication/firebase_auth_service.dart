import 'package:firebase_auth/firebase_auth.dart';
import 'package:fruit_hub_dashboard/features/auth/data/models/user_model.dart';
import 'package:fruit_hub_dashboard/features/auth/domain/entities/user_entity.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../helpers/firebase_keys.dart';
import '../../helpers/functions.dart';
import 'auth_service.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthService(this._auth, this._googleSignIn);

  @override
  Future<UserEntity> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return UserModel.fromFirebaseUser(credential.user!);
  }

  @override
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return UserModel.fromFirebaseUser(credential.user!);
  }

  @override
  Future<UserEntity> googleSignIn() async {
    await _googleSignIn.signOut();

    await _googleSignIn.initialize(
      clientId: FirebaseKeys.clientId,
      serverClientId: FirebaseKeys.serverClientId,
    );
    final GoogleSignInAccount? googleUser = await _googleSignIn
        .attemptLightweightAuthentication();

    if (googleUser == null) {
      errorLogger(
        functionName: 'AuthFirebase.googleSignIn',
        error: 'User canceled sign in',
      );
      throw Exception("The sign-in process was canceled.");
    }

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    if (googleAuth.idToken == null) {
      errorLogger(
        functionName: 'AuthFirebase.googleSignIn',
        error: 'No idToken received from Google',
      );
      throw Exception(
        "Could not retrieve authentication details from Google. Please try again.",
      );
    }

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    var userCredential = await _auth.signInWithCredential(credential);
    return UserModel.fromFirebaseUser(userCredential.user!);
  }

  @override
  Future<void> deleteCurrentUser() async => await _auth.currentUser?.delete();

  @override
  Future<void> forgetPassword(String email) async =>
      await _auth.sendPasswordResetEmail(email: email);

  @override
  Future<void> sendEmailVerification() async =>
      await _auth.currentUser!.sendEmailVerification();

  @override
  Future<void> signOut() async => await _auth.signOut();
}
