import '../../../../core/helpers/functions.dart';
import '../../../../core/helpers/network_response.dart';
import '../entities/user_entity.dart';
import '../repo_contract/repo/auth_repo.dart';

class SignInWithEmailAndPasswordUseCase {
  SignInWithEmailAndPasswordUseCase(this._authRepo);

  final AuthRepo _authRepo;

  Future<NetworkResponse<UserEntity>> call({
    required String email,
    required String password,
  }) async {
    var networkResponse = await _authRepo.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    switch (networkResponse) {
      case NetworkSuccess<UserEntity>():
        await saveUserDataToSharedPreferences(networkResponse.data!);
        return NetworkSuccess(networkResponse.data);
      case NetworkFailure<UserEntity>():
        return NetworkFailure(networkResponse.exception);
    }
  }
}
