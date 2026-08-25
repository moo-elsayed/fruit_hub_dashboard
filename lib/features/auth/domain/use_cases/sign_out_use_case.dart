import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/auth/domain/repo/auth_repo.dart';

class SignOutUseCase {
  SignOutUseCase(this._authRepo);

  final AuthRepo _authRepo;

  Future<NetworkResponse<void>> call() async => await _authRepo.signOut();
}
