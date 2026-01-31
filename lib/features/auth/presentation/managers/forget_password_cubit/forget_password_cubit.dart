import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/helpers/functions.dart';
import '../../../../../core/helpers/network_response.dart';
import '../../../domain/use_cases/forget_password_use_case.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit(this._forgetPasswordUseCase)
    : super(ForgetPasswordInitial());

  final ForgetPasswordUseCase _forgetPasswordUseCase;

  Future<void> forgetPassword(String email) async {
    emit(ForgetPasswordLoading());
    final response = await _forgetPasswordUseCase.forgetPassword(email);
    switch (response) {
      case NetworkSuccess():
        emit(ForgetPasswordSuccess());
      case NetworkFailure():
        emit(ForgetPasswordFailure(getErrorMessage(response)));
    }
  }
}
