import '../../../../../core/helpers/network_response.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repo_contract/data_sources/remote/auth_remote_data_source.dart';
import '../../../domain/repo_contract/repo/auth_repo.dart';

class AuthRepoImp implements AuthRepo {
  AuthRepoImp(this._authRemoteDataSource);

  final AuthRemoteDataSource _authRemoteDataSource;

  @override
  Future<NetworkResponse<UserEntity>> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) async => await _authRemoteDataSource.createUserWithEmailAndPassword(
    email: email,
    password: password,
    username: username,
  );

  @override
  Future<NetworkResponse<UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async => await _authRemoteDataSource.signInWithEmailAndPassword(
    email: email,
    password: password,
  );

  @override
  Future<void> signOut() async => await _authRemoteDataSource.signOut();

  @override
  Future<NetworkResponse<UserEntity>> googleSignIn() async =>
      await _authRemoteDataSource.googleSignIn();

  @override
  Future<NetworkResponse> forgetPassword(String email) async =>
      await _authRemoteDataSource.forgetPassword(email);
}
