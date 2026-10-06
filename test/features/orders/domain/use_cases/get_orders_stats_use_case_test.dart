import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/orders_stats_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/repo/orders_repo.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/use_cases/get_orders_stats_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockOrdersRepo extends Mock implements OrdersRepo {}

void main() {
  late MockOrdersRepo mockOrdersRepo;
  late GetOrdersStatsUseCase sut;

  const tStats = OrdersStatsEntity(
    totalCount: 50,
    pendingCount: 10,
    processingCount: 8,
    shippedCount: 12,
    deliveredCount: 18,
    cancelledCount: 2,
  );

  const tFailure = ServerFailure(error: 'Failed to fetch orders statistics');

  setUp(() {
    mockOrdersRepo = MockOrdersRepo();
    sut = GetOrdersStatsUseCase(mockOrdersRepo);
  });

  group('GetOrdersStatsUseCase', () {
    test('should return NetworkSuccess with OrdersStatsEntity when repo call is successful', () async {
      // Arrange
      when(() => mockOrdersRepo.getOrdersStats())
          .thenAnswer((_) async => const NetworkSuccess(tStats));

      // Act
      final result = await sut();

      // Assert
      expect(result, isA<NetworkSuccess<OrdersStatsEntity>>());
      final entity = (result as NetworkSuccess<OrdersStatsEntity>).data!;
      expect(entity, tStats);
      expect(entity.totalCount, 50);
      expect(entity.pendingCount, 10);
      expect(entity.processingCount, 8);
      expect(entity.shippedCount, 12);
      expect(entity.deliveredCount, 18);
      expect(entity.cancelledCount, 2);

      verify(() => mockOrdersRepo.getOrdersStats()).called(1);
      verifyNoMoreInteractions(mockOrdersRepo);
    });

    test(
      'should return NetworkFailure when repo call returns failure',
      () async {
        // Arrange
        when(() => mockOrdersRepo.getOrdersStats())
            .thenAnswer((_) async => const NetworkFailure(tFailure));

        // Act
        final result = await sut();

        // Assert
        expect(result, isA<NetworkFailure<OrdersStatsEntity>>());
        final failure = (result as NetworkFailure<OrdersStatsEntity>).failure;
        expect(failure.error, tFailure.error);

        verify(() => mockOrdersRepo.getOrdersStats()).called(1);
        verifyNoMoreInteractions(mockOrdersRepo);
      },
    );
  });
}
