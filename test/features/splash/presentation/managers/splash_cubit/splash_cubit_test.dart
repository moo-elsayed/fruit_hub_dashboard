import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/services/local_storage/app_preferences_service.dart';
import 'package:fruit_hub_dashboard/features/splash/presentation/managers/splash_cubit/splash_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockAppPreferencesService extends Mock implements AppPreferencesService {}

void main() {
  group('SplashCubit', () {
    late MockAppPreferencesService mockAppPreferencesService;
    late SplashCubit sut;

    setUp(() {
      mockAppPreferencesService = MockAppPreferencesService();
      sut = SplashCubit(mockAppPreferencesService);
    });

    tearDown(() => sut.close());

    test('initial state should be SplashInitial', () {
      expect(sut.state, isA<SplashInitial>());
    });

    group('checkAppStatus', () {
      blocTest<SplashCubit, SplashState>(
        'should emit [SplashNavigationState with SplashNavigation.home] after 2 seconds delay when isLoggedIn returns true',
        build: () => sut,
        setUp: () {
          when(() => mockAppPreferencesService.isLoggedIn()).thenReturn(true);
        },
        act: (cubit) => cubit.checkAppStatus(),
        wait: const Duration(seconds: 2),
        expect: () => [
          isA<SplashNavigationState>().having(
            (s) => s.navigation,
            'navigation',
            SplashNavigation.home,
          ),
        ],
        verify: (_) {
          verify(() => mockAppPreferencesService.isLoggedIn()).called(1);
          verifyNoMoreInteractions(mockAppPreferencesService);
        },
      );

      blocTest<SplashCubit, SplashState>(
        'should emit [SplashNavigationState with SplashNavigation.login] after 2 seconds delay when isLoggedIn returns false',
        build: () => sut,
        setUp: () {
          when(() => mockAppPreferencesService.isLoggedIn()).thenReturn(false);
        },
        act: (cubit) => cubit.checkAppStatus(),
        wait: const Duration(seconds: 2),
        expect: () => [
          isA<SplashNavigationState>().having(
            (s) => s.navigation,
            'navigation',
            SplashNavigation.login,
          ),
        ],
        verify: (_) {
          verify(() => mockAppPreferencesService.isLoggedIn()).called(1);
          verifyNoMoreInteractions(mockAppPreferencesService);
        },
      );
    });
  });
}
