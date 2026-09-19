import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/users/domain/entities/users_stats_entity.dart';
import 'package:fruit_hub_dashboard/features/users/domain/repo/users_repo.dart';
import 'package:fruit_hub_dashboard/features/users/domain/use_cases/get_users_stats_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockUsersRepo extends Mock implements UsersRepo {}

void main() {
  late MockUsersRepo mockUsersRepo;
  late GetUsersStatsUseCase sut;

  const tStats = UsersStatsEntity(
    totalCount: 50,
    verifiedCount: 35,
    activeCartCount: 15,
  );

  const tFailure = ServerFailure(error: 'Failed to fetch users statistics');

  setUp(() {
    mockUsersRepo = MockUsersRepo();
    sut = GetUsersStatsUseCase(mockUsersRepo);
  });

  group('GetUsersStatsUseCase', () {
    test('should return NetworkSuccess with UsersStatsEntity when repo call is successful', () async {
      // Arrange
      when(() => mockUsersRepo.getUsersStats())
          .thenAnswer((_) async => const NetworkSuccess(tStats));

      // Act
      final result = await sut();

      // Assert
      expect(result, isA<NetworkSuccess<UsersStatsEntity>>());
      final entity = (result as NetworkSuccess<UsersStatsEntity>).data!;
      expect(entity, tStats);
      expect(entity.totalCount, 50);
      expect(entity.verifiedCount, 35);
      expect(entity.activeCartCount, 15);

      verify(() => mockUsersRepo.getUsersStats()).called(1);
      verifyNoMoreInteractions(mockUsersRepo);
    });

    test(
      'should return NetworkFailure when repo call returns failure',
      () async {
        // Arrange
        when(() => mockUsersRepo.getUsersStats())
            .thenAnswer((_) async => const NetworkFailure(tFailure));

        // Act
        final result = await sut();

        // Assert
        expect(result, isA<NetworkFailure<UsersStatsEntity>>());
        final failure = (result as NetworkFailure<UsersStatsEntity>).failure;
        expect(failure.error, tFailure.error);

        verify(() => mockUsersRepo.getUsersStats()).called(1);
        verifyNoMoreInteractions(mockUsersRepo);
      },
    );
  });
}
