part of 'sign_in_cubit.dart';

@immutable
sealed class SignInState {}

final class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {
  SignInSuccess(this.user);

  final UserEntity user;
}

class SignInFailure extends SignInState {
  SignInFailure(this.message);

  final String message;
}
