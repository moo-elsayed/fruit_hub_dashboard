import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/services/local_storage/app_preferences_service.dart';
import 'package:fruit_hub_dashboard/features/splash/presentation/managers/splash_cubit/splash_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockAppPreferencesService extends Mock implements AppPreferencesService {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

void main() {
  group('SplashCubit', () {
    late MockAppPreferencesService mockAppPreferencesService;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockFirebaseUser;
    late SplashCubit sut;

    setUp(() {
      mockAppPreferencesService = MockAppPreferencesService();
      mockFirebaseAuth = MockFirebaseAuth();
      mockFirebaseUser = MockUser();
      sut = SplashCubit(
        mockAppPreferencesService,
        firebaseAuth: mockFirebaseAuth,
      );
    });

    tearDown(() => sut.close());

    test('initial state should be SplashInitial', () {
      expect(sut.state, isA<SplashInitial>());
    });

    group('checkAppStatus', () {
      blocTest<SplashCubit, SplashState>(
        'should emit [SplashNavigationState with SplashNavigation.home] after 2 seconds delay when both currentUser and isLoggedIn are valid',
        build: () => sut,
        setUp: () {
          when(() => mockFirebaseAuth.currentUser).thenReturn(mockFirebaseUser);
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
          verify(() => mockFirebaseAuth.currentUser).called(1);
          verify(() => mockAppPreferencesService.isLoggedIn()).called(1);
          verifyNoMoreInteractions(mockAppPreferencesService);
        },
      );

      blocTest<SplashCubit, SplashState>(
        'should emit [SplashNavigationState with SplashNavigation.login] after 2 seconds delay when neither is logged in',
        build: () => sut,
        setUp: () {
          when(() => mockFirebaseAuth.currentUser).thenReturn(null);
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
          verify(() => mockFirebaseAuth.currentUser).called(1);
          verify(() => mockAppPreferencesService.isLoggedIn()).called(1);
          verifyNever(() => mockAppPreferencesService.clearUser());
          verifyNoMoreInteractions(mockAppPreferencesService);
        },
      );

      blocTest<SplashCubit, SplashState>(
        'should emit [SplashNavigationState with SplashNavigation.login] and clear local user when currentUser is null but local cache exists',
        build: () => sut,
        setUp: () {
          when(() => mockFirebaseAuth.currentUser).thenReturn(null);
          when(() => mockAppPreferencesService.isLoggedIn()).thenReturn(true);
          when(() => mockAppPreferencesService.clearUser())
              .thenAnswer((_) async {});
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
          verify(() => mockFirebaseAuth.currentUser).called(1);
          verify(() => mockAppPreferencesService.isLoggedIn()).called(1);
          verify(() => mockAppPreferencesService.clearUser()).called(1);
          verifyNoMoreInteractions(mockAppPreferencesService);
        },
      );

      blocTest<SplashCubit, SplashState>(
        'should emit [SplashNavigationState with SplashNavigation.login] when currentUser is not null but local cache does not exist',
        build: () => sut,
        setUp: () {
          when(() => mockFirebaseAuth.currentUser).thenReturn(mockFirebaseUser);
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
          verify(() => mockFirebaseAuth.currentUser).called(1);
          verify(() => mockAppPreferencesService.isLoggedIn()).called(1);
          verifyNever(() => mockAppPreferencesService.clearUser());
          verifyNoMoreInteractions(mockAppPreferencesService);
        },
      );
    });
  });
}
