import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/helpers/app_logger.dart';
import '../../../../core/helpers/firebase_keys.dart';
import '../../../../core/services/authentication/auth_service.dart';
import '../../../features/auth/data/models/user_model.dart';
import '../../../features/auth/domain/entities/user_entity.dart';

class FirebaseAuthService implements AuthService, SignOutService {
  FirebaseAuthService(this._auth, this._googleSignIn);

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  @override
  Future<UserEntity> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _returnUserEntity(credential);
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
    return _returnUserEntity(credential);
  }

  @override
  Future<UserEntity> googleSignIn() async {
    final User user = await _googleSignInInternal();
    return UserModel.fromFirebaseUser(user).toUserEntity();
  }

  @override
  Future<void> deleteCurrentUser() async => await _auth.currentUser?.delete();

  @override
  Future<void> forgetPassword(String email) async =>
      await _auth.sendPasswordResetEmail(email: email);

  @override
  Future<void> sendEmailVerification() async =>
      await _auth.currentUser?.sendEmailVerification();

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    try {
      await _googleSignIn.disconnect();
    } catch (e) {
      // ignore: avoid_print
    }
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      // ignore: avoid_print
    }
  }

  Future<User> _googleSignInInternal() async {
    await _googleSignIn.initialize(
      clientId: FirebaseKeys.clientId,
      serverClientId: FirebaseKeys.serverClientId,
    );
    final GoogleSignInAccount? googleUser = await _googleSignIn
        .attemptLightweightAuthentication();

    if (googleUser == null) {
      AppLogger.error('error in google sign in', error: 'No user found');
      throw Exception('The sign-in process was canceled.');
    }

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    if (googleAuth.idToken == null) {
      AppLogger.error(
        'error in google sign in',
        error: 'No idToken received from Google',
      );
      throw Exception(
        'Could not retrieve authentication details from Google. Please try again.',
      );
    }

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    return _returnUser(userCredential);
  }

  User _returnUser(UserCredential userCredential) {
    final user = userCredential.user;
    if (user == null) {
      throw Exception('Firebase user object is null after sign in.');
    }
    return user;
  }

  UserEntity _returnUserEntity(UserCredential credential) {
    final user = credential.user;
    if (user == null) {
      throw Exception('Firebase user object is null after sign in.');
    }
    return UserModel.fromFirebaseUser(user).toUserEntity();
  }
}
