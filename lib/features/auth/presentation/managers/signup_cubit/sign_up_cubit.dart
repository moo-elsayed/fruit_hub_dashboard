import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/helpers/functions.dart';
import '../../../../../core/helpers/network_response.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/use_cases/create_user_with_email_and_password_use_case.dart';

part 'sign_up_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit(this._createUserWithEmailAndPasswordUseCase)
    : super(SignUpInitial());

  final CreateUserWithEmailAndPasswordUseCase
  _createUserWithEmailAndPasswordUseCase;

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    emit(SignUpLoading());
    final result = await _createUserWithEmailAndPasswordUseCase.call(
      email: email,
      password: password,
      username: username,
    );
    switch (result) {
      case NetworkSuccess<UserEntity>():
        emit(SignUpSuccess(result.data!));
      case NetworkFailure<UserEntity>():
        emit(SignUpFailure(getErrorMessage(result)));
    }
  }


}
