import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/enums/payment_methods.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/analytics/data/data_sources/remote/analytics_remote_data_source.dart';
import 'package:fruit_hub_dashboard/features/analytics/data/models/analytics_data_model.dart';
import 'package:fruit_hub_dashboard/features/analytics/data/models/analytics_kpi_model.dart';
import 'package:fruit_hub_dashboard/features/analytics/data/models/order_status_stat_model.dart';
import 'package:fruit_hub_dashboard/features/analytics/data/models/payment_method_stat_model.dart';
import 'package:fruit_hub_dashboard/features/analytics/data/models/revenue_data_point_model.dart';
import 'package:fruit_hub_dashboard/features/analytics/data/models/top_product_model.dart';
import 'package:fruit_hub_dashboard/features/analytics/data/repo_imp/analytics_repo_imp.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/analytics_data_entity.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/analytics_kpi_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockAnalyticsRemoteDataSource extends Mock
    implements AnalyticsRemoteDataSource {}

void main() {
  group('AnalyticsRepoImp', () {
    late MockAnalyticsRemoteDataSource mockRemoteDataSource;
    late AnalyticsRepoImp sut;

    final tFrom = DateTime(2026, 9, 1);
    final tTo = DateTime(2026, 9, 3);
    const tFailure = ServerFailure(error: 'Firestore query failed');

    final tDataModel = AnalyticsDataModel(
      kpi: const AnalyticsKpiModel(
        totalRevenue: 5000.0,
        totalOrders: 20,
        deliveredOrders: 15,
        cancelledOrders: 2,
        pendingOrders: 1,
        processingOrders: 1,
        shippedOrders: 1,
        totalUsers: 50,
        verifiedUsers: 40,
        activeCartsCount: 10,
      ),
      revenueOverTime: [
        RevenueDataPointModel(
          date: DateTime(2026, 9, 1),
          revenue: 1500.0,
          ordersCount: 6,
        ),
        RevenueDataPointModel(
          date: DateTime(2026, 9, 2),
          revenue: 2000.0,
          ordersCount: 8,
        ),
        RevenueDataPointModel(
          date: DateTime(2026, 9, 3),
          revenue: 1500.0,
          ordersCount: 6,
        ),
      ],
      topProducts: const [
        TopProductModel(
          code: 'APL',
          name: 'Apple',
          imagePath: 'apple.png',
          totalQuantitySold: 25,
          totalRevenue: 1250.0,
        ),
        TopProductModel(
          code: 'BAN',
          name: 'Banana',
          imagePath: 'banana.png',
          totalQuantitySold: 15,
          totalRevenue: 450.0,
        ),
      ],
      orderStatusStats: const [
        OrderStatusStatModel(status: OrderStatus.delivered, count: 15),
        OrderStatusStatModel(status: OrderStatus.cancelled, count: 2),
        OrderStatusStatModel(status: OrderStatus.pending, count: 1),
        OrderStatusStatModel(status: OrderStatus.processing, count: 1),
        OrderStatusStatModel(status: OrderStatus.shipped, count: 1),
      ],
      paymentMethodStats: const [
        PaymentMethodStatModel(type: PaymentMethodType.cash, count: 10),
        PaymentMethodStatModel(type: PaymentMethodType.card, count: 7),
        PaymentMethodStatModel(type: PaymentMethodType.paypal, count: 3),
      ],
    );

    setUp(() {
      mockRemoteDataSource = MockAnalyticsRemoteDataSource();
      sut = AnalyticsRepoImp(mockRemoteDataSource);
    });

    group('getAnalytics', () {
      test(
        'should return NetworkSuccess with mapped AnalyticsDataEntity when remote data source returns NetworkSuccess with model',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getAnalytics(from: tFrom, to: tTo),
          ).thenAnswer((_) async => NetworkSuccess(tDataModel));

          // Act
          final result = await sut.getAnalytics(from: tFrom, to: tTo);

          // Assert
          expect(result, isA<NetworkSuccess<AnalyticsDataEntity>>());
          final entity = (result as NetworkSuccess<AnalyticsDataEntity>).data;
          expect(entity, equals(tDataModel.toEntity()));

          verify(
            () => mockRemoteDataSource.getAnalytics(from: tFrom, to: tTo),
          ).called(1);
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );

      test(
        'should return NetworkSuccess with default AnalyticsDataEntity when remote data source returns NetworkSuccess with null data',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getAnalytics(from: tFrom, to: tTo),
          ).thenAnswer((_) async => const NetworkSuccess(null));

          // Act
          final result = await sut.getAnalytics(from: tFrom, to: tTo);

          // Assert
          expect(result, isA<NetworkSuccess<AnalyticsDataEntity>>());
          final entity = (result as NetworkSuccess<AnalyticsDataEntity>).data;
          expect(entity, equals(const AnalyticsDataEntity()));
          expect(entity?.kpi, equals(const AnalyticsKpiEntity()));
          expect(entity?.revenueOverTime, isEmpty);
          expect(entity?.topProducts, isEmpty);
          expect(entity?.orderStatusStats, isEmpty);
          expect(entity?.paymentMethodStats, isEmpty);

          verify(
            () => mockRemoteDataSource.getAnalytics(from: tFrom, to: tTo),
          ).called(1);
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );

      test(
        'should return NetworkFailure with same failure when remote data source returns NetworkFailure',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.getAnalytics(from: tFrom, to: tTo),
          ).thenAnswer((_) async => const NetworkFailure(tFailure));

          // Act
          final result = await sut.getAnalytics(from: tFrom, to: tTo);

          // Assert
          expect(result, isA<NetworkFailure<AnalyticsDataEntity>>());
          final failure = (result as NetworkFailure<AnalyticsDataEntity>).failure;
          expect(failure, equals(tFailure));

          verify(
            () => mockRemoteDataSource.getAnalytics(from: tFrom, to: tTo),
          ).called(1);
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );

      test(
        'should pass exact from and to DateTime parameters to the remote data source',
        () async {
          // Arrange
          final specificFrom = DateTime(2026, 1, 15, 8, 30);
          final specificTo = DateTime(2026, 1, 20, 18, 45);

          when(
            () => mockRemoteDataSource.getAnalytics(
              from: specificFrom,
              to: specificTo,
            ),
          ).thenAnswer((_) async => NetworkSuccess(tDataModel));

          // Act
          await sut.getAnalytics(from: specificFrom, to: specificTo);

          // Assert
          verify(
            () => mockRemoteDataSource.getAnalytics(
              from: specificFrom,
              to: specificTo,
            ),
          ).called(1);
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );
    });
  });
}
