import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/user_search_by.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/users/domain/entities/dashboard_user_entity.dart';
import 'package:fruit_hub_dashboard/features/users/domain/repo/users_repo.dart';
import 'package:fruit_hub_dashboard/features/users/domain/use_cases/search_users_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockUsersRepo extends Mock implements UsersRepo {}

void main() {
  late MockUsersRepo mockUsersRepo;
  late SearchUsersUseCase sut;

  const tUsers = <DashboardUserEntity>[
    DashboardUserEntity(
      uid: 'u_1',
      name: 'Youssef Ali',
      email: 'youssef@test.com',
      phone: '01012345678',
      image: 'https://example.com/avatar.png',
      isVerified: true,
      languageCode: 'ar',
      fcmToken: 'fcm_token_1',
      cartItems: [],
      favoriteIds: [],
    ),
  ];

  const tFailure = ServerFailure(error: 'Failed to search users');

  setUpAll(() {
    registerFallbackValue(UserSearchBy.name);
  });

  setUp(() {
    mockUsersRepo = MockUsersRepo();
    sut = SearchUsersUseCase(mockUsersRepo);
  });

  group('SearchUsersUseCase', () {
    test('should call repo with given parameters and return NetworkSuccess with users list', () async {
      // Arrange
      when(
        () => mockUsersRepo.searchUsers(
          query: any(named: 'query'),
          searchBy: any(named: 'searchBy'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => const NetworkSuccess<List<DashboardUserEntity>>(tUsers));

      // Act
      final result = await sut(query: 'Youssef', searchBy: UserSearchBy.name);

      // Assert
      expect(result, isA<NetworkSuccess<List<DashboardUserEntity>>>());
      final list = (result as NetworkSuccess<List<DashboardUserEntity>>).data!;
      expect(list, tUsers);
      expect(list.length, 1);
      expect(list.first.name, 'Youssef Ali');

      verify(
        () => mockUsersRepo.searchUsers(
          query: 'Youssef',
          searchBy: UserSearchBy.name,
          limit: 30,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockUsersRepo);
    });

    test('should forward custom limit parameter to repo correctly', () async {
      // Arrange
      when(
        () => mockUsersRepo.searchUsers(
          query: any(named: 'query'),
          searchBy: any(named: 'searchBy'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => const NetworkSuccess<List<DashboardUserEntity>>(tUsers));

      // Act
      final result = await sut(
        query: '010',
        searchBy: UserSearchBy.phone,
        limit: 10,
      );

      // Assert
      expect(result, isA<NetworkSuccess<List<DashboardUserEntity>>>());

      verify(
        () => mockUsersRepo.searchUsers(
          query: '010',
          searchBy: UserSearchBy.phone,
          limit: 10,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockUsersRepo);
    });

    test(
      'should return NetworkFailure when repo call returns failure',
      () async {
        // Arrange
        when(
          () => mockUsersRepo.searchUsers(
            query: any(named: 'query'),
            searchBy: any(named: 'searchBy'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => const NetworkFailure(tFailure));

        // Act
        final result = await sut(
          query: 'test@email.com',
          searchBy: UserSearchBy.email,
        );

        // Assert
        expect(result, isA<NetworkFailure<List<DashboardUserEntity>>>());
        final failure =
            (result as NetworkFailure<List<DashboardUserEntity>>).failure;
        expect(failure.error, tFailure.error);

        verify(
          () => mockUsersRepo.searchUsers(
            query: 'test@email.com',
            searchBy: UserSearchBy.email,
            limit: 30,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockUsersRepo);
      },
    );
  });
}
