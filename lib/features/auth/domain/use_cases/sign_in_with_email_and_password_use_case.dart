import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/auth/domain/entities/user_entity.dart';
import 'package:fruit_hub_dashboard/features/auth/domain/repo/auth_repo.dart';

class SignInWithEmailAndPasswordUseCase {
  SignInWithEmailAndPasswordUseCase(this._authRepo);

  final AuthRepo _authRepo;

  Future<NetworkResponse<UserEntity>> call({
    required String email,
    required String password,
  }) async => await _authRepo.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
}
