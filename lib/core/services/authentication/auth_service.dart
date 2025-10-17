import 'package:fruit_hub_dashboard/features/auth/domain/entities/user_entity.dart';

abstract class AuthService {
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserEntity> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserEntity> googleSignIn();

  Future<void> deleteCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> forgetPassword(String email);

  Future<void> signOut();
}
