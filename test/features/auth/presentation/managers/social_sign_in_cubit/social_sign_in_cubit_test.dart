import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/helpers/di.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/auth/domain/entities/user_entity.dart';
import 'package:fruit_hub_dashboard/features/auth/domain/use_cases/google_sign_in_use_case.dart';
import 'package:fruit_hub_dashboard/features/auth/presentation/managers/social_sign_in_cubit/social_sign_in_cubit.dart';
import 'package:fruit_hub_dashboard/features/auth/presentation/managers/user_info_cubit/user_info_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGoogleSignInUseCase extends Mock implements GoogleSignInUseCase {}

class MockUserInfoCubit extends Mock implements UserInfoCubit {}

class FakeUserEntity extends Fake implements UserEntity {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeUserEntity());
  });

  late MockGoogleSignInUseCase mockUseCase;
  late MockUserInfoCubit mockUserInfoCubit;
  late SocialSignInCubit sut;

  const tUserEntity = UserEntity(
    uid: 'google_uid_123',
    name: 'Google User',
    email: 'google@example.com',
    phone: '01012345678',
    image: 'https://example.com/avatar.png',
    isVerified: true,
  );

  const tErrorMessage = 'Google sign in cancelled';
  const tServerFailure = ServerFailure(error: tErrorMessage);

  setUp(() {
    mockUseCase = MockGoogleSignInUseCase();
    mockUserInfoCubit = MockUserInfoCubit();

    if (getIt.isRegistered<UserInfoCubit>()) {
      getIt.unregister<UserInfoCubit>();
    }
    getIt.registerSingleton<UserInfoCubit>(mockUserInfoCubit);

    when(
      () => mockUserInfoCubit.saveUserLocally(any()),
    ).thenAnswer((_) async {});

    sut = SocialSignInCubit(mockUseCase);
  });

  tearDown(() {
    sut.close();
    if (getIt.isRegistered<UserInfoCubit>()) {
      getIt.unregister<UserInfoCubit>();
    }
  });

  test('initial state should be SocialSignInInitial', () {
    // Assert
    expect(sut.state, isA<SocialSignInInitial>());
  });

  group('googleSignIn', () {
    blocTest<SocialSignInCubit, SocialSignInState>(
      'should emit [GoogleLoading, GoogleSuccess] and save user locally when googleSignIn succeeds with user data',
      build: () => sut,
      setUp: () {
        // Arrange
        when(
          () => mockUseCase.call(),
        ).thenAnswer((_) async => const NetworkSuccess(tUserEntity));
      },
      act: (cubit) async {
        // Act
        await cubit.googleSignIn();
      },
      expect: () => [
        isA<GoogleLoading>(),
        isA<GoogleSuccess>(),
      ],
      verify: (_) {
        // Assert
        verify(() => mockUseCase.call()).called(1);
        verify(
          () => mockUserInfoCubit.saveUserLocally(tUserEntity),
        ).called(1);
        verifyNoMoreInteractions(mockUseCase);
      },
    );

    blocTest<SocialSignInCubit, SocialSignInState>(
      'should emit [GoogleLoading, GoogleSuccess] and NOT save user locally when googleSignIn returns NetworkSuccess with null data',
      build: () => sut,
      setUp: () {
        // Arrange
        when(
          () => mockUseCase.call(),
        ).thenAnswer((_) async => const NetworkSuccess<UserEntity>(null));
      },
      act: (cubit) async {
        // Act
        await cubit.googleSignIn();
      },
      expect: () => [
        isA<GoogleLoading>(),
        isA<GoogleSuccess>(),
      ],
      verify: (_) {
        // Assert
        verify(() => mockUseCase.call()).called(1);
        verifyNever(() => mockUserInfoCubit.saveUserLocally(any()));
        verifyNoMoreInteractions(mockUseCase);
      },
    );

    blocTest<SocialSignInCubit, SocialSignInState>(
      'should emit [GoogleLoading, GoogleFailure] with correct error message and NOT save user locally when googleSignIn returns NetworkFailure',
      build: () => sut,
      setUp: () {
        // Arrange
        when(
          () => mockUseCase.call(),
        ).thenAnswer((_) async => const NetworkFailure(tServerFailure));
      },
      act: (cubit) async {
        // Act
        await cubit.googleSignIn();
      },
      expect: () => [
        isA<GoogleLoading>(),
        isA<GoogleFailure>().having(
          (state) => state.message,
          'message',
          tErrorMessage,
        ),
      ],
      verify: (_) {
        // Assert
        verify(() => mockUseCase.call()).called(1);
        verifyNever(() => mockUserInfoCubit.saveUserLocally(any()));
        verifyNoMoreInteractions(mockUseCase);
      },
    );
  });
}
