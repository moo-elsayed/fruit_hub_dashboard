part of 'splash_cubit.dart';

enum SplashNavigation { home, login }

@immutable
sealed class SplashState {}

final class SplashInitial extends SplashState {}

final class SplashNavigationState extends SplashState {
  SplashNavigationState(this.navigation);

  final SplashNavigation navigation;
}
