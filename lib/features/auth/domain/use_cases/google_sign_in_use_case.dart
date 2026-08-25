import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/auth/domain/entities/user_entity.dart';
import 'package:fruit_hub_dashboard/features/auth/domain/repo/auth_repo.dart';

class GoogleSignInUseCase {
  GoogleSignInUseCase(this._authRepo);

  final AuthRepo _authRepo;

  Future<NetworkResponse<UserEntity>> call() async =>
      await _authRepo.googleSignIn();
}
