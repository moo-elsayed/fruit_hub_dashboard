import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/enums/payment_methods.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/analytics_data_entity.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/analytics_kpi_entity.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/order_status_stat_entity.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/payment_method_stat_entity.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/revenue_data_point_entity.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/top_product_entity.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/repo/analytics_repo.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/use_cases/get_analytics_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAnalyticsRepo extends Mock implements AnalyticsRepo {}

void main() {
  group('GetAnalyticsUseCase', () {
    late MockAnalyticsRepo mockAnalyticsRepo;
    late GetAnalyticsUseCase sut;

    final tFrom = DateTime(2026, 9, 1);
    final tTo = DateTime(2026, 9, 5);
    const tFailure = ServerFailure(error: 'Failed to fetch analytics');

    final tAnalyticsData = AnalyticsDataEntity(
      kpi: const AnalyticsKpiEntity(
        totalRevenue: 10000.0,
        totalOrders: 50,
        deliveredOrders: 40,
        cancelledOrders: 5,
        pendingOrders: 2,
        processingOrders: 2,
        shippedOrders: 1,
        totalUsers: 100,
        verifiedUsers: 80,
        activeCartsCount: 20,
      ),
      revenueOverTime: [
        RevenueDataPointEntity(
          date: DateTime(2026, 9, 1),
          revenue: 2000.0,
          ordersCount: 10,
        ),
      ],
      topProducts: const [
        TopProductEntity(
          code: 'APL',
          name: 'Apple',
          imagePath: 'apple.png',
          totalQuantitySold: 30,
          totalRevenue: 1500.0,
        ),
      ],
      orderStatusStats: const [
        OrderStatusStatEntity(status: OrderStatus.delivered, count: 40),
        OrderStatusStatEntity(status: OrderStatus.cancelled, count: 5),
      ],
      paymentMethodStats: const [
        PaymentMethodStatEntity(type: PaymentMethodType.cash, count: 30),
        PaymentMethodStatEntity(type: PaymentMethodType.card, count: 20),
      ],
    );

    setUp(() {
      mockAnalyticsRepo = MockAnalyticsRepo();
      sut = GetAnalyticsUseCase(mockAnalyticsRepo);
    });

    test(
      'should forward from and to to AnalyticsRepo and return NetworkSuccess with AnalyticsDataEntity on success',
      () async {
        // Arrange
        when(
          () => mockAnalyticsRepo.getAnalytics(from: tFrom, to: tTo),
        ).thenAnswer((_) async => NetworkSuccess(tAnalyticsData));

        // Act
        final result = await sut(from: tFrom, to: tTo);

        // Assert
        expect(result, isA<NetworkSuccess<AnalyticsDataEntity>>());
        final data = (result as NetworkSuccess<AnalyticsDataEntity>).data;
        expect(data, equals(tAnalyticsData));

        verify(
          () => mockAnalyticsRepo.getAnalytics(from: tFrom, to: tTo),
        ).called(1);
        verifyNoMoreInteractions(mockAnalyticsRepo);
      },
    );

    test(
      'should return NetworkFailure when AnalyticsRepo returns NetworkFailure',
      () async {
        // Arrange
        when(
          () => mockAnalyticsRepo.getAnalytics(from: tFrom, to: tTo),
        ).thenAnswer((_) async => const NetworkFailure(tFailure));

        // Act
        final result = await sut(from: tFrom, to: tTo);

        // Assert
        expect(result, isA<NetworkFailure<AnalyticsDataEntity>>());
        final failure = (result as NetworkFailure<AnalyticsDataEntity>).failure;
        expect(failure, equals(tFailure));

        verify(
          () => mockAnalyticsRepo.getAnalytics(from: tFrom, to: tTo),
        ).called(1);
        verifyNoMoreInteractions(mockAnalyticsRepo);
      },
    );

    test(
      'should pass exact custom DateTime instances to repo without modification',
      () async {
        // Arrange
        final customFrom = DateTime(2026, 12, 1, 10, 0);
        final customTo = DateTime(2026, 12, 31, 23, 59);

        when(
          () => mockAnalyticsRepo.getAnalytics(from: customFrom, to: customTo),
        ).thenAnswer((_) async => NetworkSuccess(tAnalyticsData));

        // Act
        await sut(from: customFrom, to: customTo);

        // Assert
        verify(
          () => mockAnalyticsRepo.getAnalytics(from: customFrom, to: customTo),
        ).called(1);
        verifyNoMoreInteractions(mockAnalyticsRepo);
      },
    );
  });
}
