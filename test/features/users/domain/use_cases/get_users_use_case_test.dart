import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/user_filter_type.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/users/domain/entities/dashboard_user_entity.dart';
import 'package:fruit_hub_dashboard/features/users/domain/entities/users_page_entity.dart';
import 'package:fruit_hub_dashboard/features/users/domain/repo/users_repo.dart';
import 'package:fruit_hub_dashboard/features/users/domain/use_cases/get_users_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockUsersRepo extends Mock implements UsersRepo {}

void main() {
  late MockUsersRepo mockUsersRepo;
  late GetUsersUseCase sut;

  const tUsersPage = UsersPageEntity(
    users: [
      DashboardUserEntity(
        uid: 'user_1',
        name: 'Mahmoud Ahmed',
        email: 'mahmoud@example.com',
        phone: '01011112222',
        image: 'https://example.com/avatar.png',
        isVerified: true,
        languageCode: 'ar',
        fcmToken: 'token_123',
        cartItems: [],
        favoriteIds: [],
      ),
    ],
    hasMore: true,
    lastDocument: null,
  );

  const tFailure = ServerFailure(error: 'Failed to fetch users page');

  setUpAll(() {
    registerFallbackValue(UserFilterType.all);
  });

  setUp(() {
    mockUsersRepo = MockUsersRepo();
    sut = GetUsersUseCase(mockUsersRepo);
  });

  group('GetUsersUseCase', () {
    test('should call repo with default parameters and return NetworkSuccess with UsersPageEntity', () async {
      // Arrange
      when(
        () => mockUsersRepo.getUsers(
          limit: any(named: 'limit'),
          lastDocument: any(named: 'lastDocument'),
          filter: any(named: 'filter'),
        ),
      ).thenAnswer((_) async => const NetworkSuccess(tUsersPage));

      // Act
      final result = await sut();

      // Assert
      expect(result, isA<NetworkSuccess<UsersPageEntity>>());
      final page = (result as NetworkSuccess<UsersPageEntity>).data!;
      expect(page.users.length, 1);
      expect(page.users.first.uid, 'user_1');
      expect(page.hasMore, isTrue);

      verify(
        () => mockUsersRepo.getUsers(
          limit: 15,
          lastDocument: null,
          filter: UserFilterType.all,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockUsersRepo);
    });

    test(
      'should forward custom limit, lastDocument, and filter to repo correctly',
      () async {
        // Arrange
        when(
          () => mockUsersRepo.getUsers(
            limit: any(named: 'limit'),
            lastDocument: any(named: 'lastDocument'),
            filter: any(named: 'filter'),
          ),
        ).thenAnswer((_) async => const NetworkSuccess(tUsersPage));

        // Act
        final result = await sut(limit: 25, filter: UserFilterType.withCart);

        // Assert
        expect(result, isA<NetworkSuccess<UsersPageEntity>>());

        verify(
          () => mockUsersRepo.getUsers(
            limit: 25,
            lastDocument: null,
            filter: UserFilterType.withCart,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockUsersRepo);
      },
    );

    test(
      'should return NetworkFailure when repo call returns failure',
      () async {
        // Arrange
        when(
          () => mockUsersRepo.getUsers(
            limit: any(named: 'limit'),
            lastDocument: any(named: 'lastDocument'),
            filter: any(named: 'filter'),
          ),
        ).thenAnswer((_) async => const NetworkFailure(tFailure));

        // Act
        final result = await sut();

        // Assert
        expect(result, isA<NetworkFailure<UsersPageEntity>>());
        final failure = (result as NetworkFailure<UsersPageEntity>).failure;
        expect(failure.error, tFailure.error);

        verify(
          () => mockUsersRepo.getUsers(
            limit: 15,
            lastDocument: null,
            filter: UserFilterType.all,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockUsersRepo);
      },
    );
  });
}
