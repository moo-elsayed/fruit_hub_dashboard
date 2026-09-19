import 'package:bloc_test/bloc_test.dart';
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
import 'package:fruit_hub_dashboard/features/analytics/domain/use_cases/get_analytics_use_case.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/managers/analytics_cubit/analytics_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAnalyticsUseCase extends Mock implements GetAnalyticsUseCase {}

void main() {
  group('AnalyticsCubit', () {
    late MockGetAnalyticsUseCase mockGetAnalyticsUseCase;
    late AnalyticsCubit sut;

    final tFrom = DateTime(2026, 9, 1);
    final tTo = DateTime(2026, 9, 7);
    const tErrorMessage = 'Failed to load analytics data';
    const tFailure = ServerFailure(error: tErrorMessage);

    final tAnalyticsData = AnalyticsDataEntity(
      kpi: const AnalyticsKpiEntity(
        totalRevenue: 15000.0,
        totalOrders: 60,
        deliveredOrders: 45,
        cancelledOrders: 5,
        pendingOrders: 5,
        processingOrders: 3,
        shippedOrders: 2,
        totalUsers: 150,
        verifiedUsers: 120,
        activeCartsCount: 35,
      ),
      revenueOverTime: [
        RevenueDataPointEntity(
          date: DateTime(2026, 9, 1),
          revenue: 2500.0,
          ordersCount: 10,
        ),
      ],
      topProducts: const [
        TopProductEntity(
          code: 'PROD_1',
          name: 'Watermelon',
          imagePath: 'watermelon.png',
          totalQuantitySold: 40,
          totalRevenue: 2000.0,
        ),
      ],
      orderStatusStats: const [
        OrderStatusStatEntity(status: OrderStatus.delivered, count: 45),
      ],
      paymentMethodStats: const [
        PaymentMethodStatEntity(type: PaymentMethodType.cash, count: 35),
      ],
    );

    final tUpdatedAnalyticsData = AnalyticsDataEntity(
      kpi: const AnalyticsKpiEntity(
        totalRevenue: 20000.0,
        totalOrders: 80,
      ),
      revenueOverTime: [
        RevenueDataPointEntity(
          date: DateTime(2026, 9, 2),
          revenue: 5000.0,
          ordersCount: 20,
        ),
      ],
    );

    setUp(() {
      mockGetAnalyticsUseCase = MockGetAnalyticsUseCase();
      sut = AnalyticsCubit(mockGetAnalyticsUseCase);
    });

    tearDown(() {
      sut.close();
    });

    test('initial state should be AnalyticsInitial and cachedData should be null', () {
      expect(sut.state, equals(AnalyticsInitial()));
      expect(sut.cachedData, isNull);
    });

    group('loadAnalytics', () {
      blocTest<AnalyticsCubit, AnalyticsState>(
        'emits [AnalyticsLoading, AnalyticsSuccess] and sets cachedData on success',
        build: () {
          when(
            () => mockGetAnalyticsUseCase(from: tFrom, to: tTo),
          ).thenAnswer((_) async => NetworkSuccess(tAnalyticsData));
          return sut;
        },
        act: (cubit) => cubit.loadAnalytics(from: tFrom, to: tTo),
        expect: () => [
          AnalyticsLoading(),
          AnalyticsSuccess(data: tAnalyticsData),
        ],
        verify: (_) {
          verify(() => mockGetAnalyticsUseCase(from: tFrom, to: tTo)).called(1);
          expect(sut.cachedData, equals(tAnalyticsData));
        },
      );

      blocTest<AnalyticsCubit, AnalyticsState>(
        'emits [AnalyticsLoading, AnalyticsSuccess with default entity] when response data is null',
        build: () {
          when(
            () => mockGetAnalyticsUseCase(from: tFrom, to: tTo),
          ).thenAnswer((_) async => const NetworkSuccess(null));
          return sut;
        },
        act: (cubit) => cubit.loadAnalytics(from: tFrom, to: tTo),
        expect: () => [
          AnalyticsLoading(),
          const AnalyticsSuccess(data: AnalyticsDataEntity()),
        ],
        verify: (_) {
          verify(() => mockGetAnalyticsUseCase(from: tFrom, to: tTo)).called(1);
          expect(sut.cachedData, isNull);
        },
      );

      blocTest<AnalyticsCubit, AnalyticsState>(
        'emits [AnalyticsLoading, AnalyticsFailure] when response is NetworkFailure',
        build: () {
          when(
            () => mockGetAnalyticsUseCase(from: tFrom, to: tTo),
          ).thenAnswer((_) async => const NetworkFailure(tFailure));
          return sut;
        },
        act: (cubit) => cubit.loadAnalytics(from: tFrom, to: tTo),
        expect: () => [
          AnalyticsLoading(),
          const AnalyticsFailure(message: tErrorMessage),
        ],
        verify: (_) {
          verify(() => mockGetAnalyticsUseCase(from: tFrom, to: tTo)).called(1);
          expect(sut.cachedData, isNull);
        },
      );

      test('does not emit state if cubit is closed before response returns', () async {
        when(
          () => mockGetAnalyticsUseCase(from: tFrom, to: tTo),
        ).thenAnswer((_) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return NetworkSuccess(tAnalyticsData);
        });

        final states = <AnalyticsState>[];
        sut.stream.listen(states.add);

        final future = sut.loadAnalytics(from: tFrom, to: tTo);
        await sut.close();
        await future;

        expect(states, [AnalyticsLoading()]);
      });
    });

    group('refresh', () {
      blocTest<AnalyticsCubit, AnalyticsState>(
        'calls loadAnalytics with the previously loaded from and to dates and emits updated success',
        build: () {
          when(
            () => mockGetAnalyticsUseCase(from: tFrom, to: tTo),
          ).thenAnswer((_) async => NetworkSuccess(tAnalyticsData));
          return sut;
        },
        act: (cubit) async {
          await cubit.loadAnalytics(from: tFrom, to: tTo);
          when(
            () => mockGetAnalyticsUseCase(from: tFrom, to: tTo),
          ).thenAnswer((_) async => NetworkSuccess(tUpdatedAnalyticsData));
          await cubit.refresh();
        },
        expect: () => [
          AnalyticsLoading(),
          AnalyticsSuccess(data: tAnalyticsData),
          AnalyticsLoading(),
          AnalyticsSuccess(data: tUpdatedAnalyticsData),
        ],
        verify: (_) {
          verify(() => mockGetAnalyticsUseCase(from: tFrom, to: tTo)).called(2);
          expect(sut.cachedData, equals(tUpdatedAnalyticsData));
        },
      );

      blocTest<AnalyticsCubit, AnalyticsState>(
        'emits failure on refresh when reload fails',
        build: () {
          when(
            () => mockGetAnalyticsUseCase(from: tFrom, to: tTo),
          ).thenAnswer((_) async => NetworkSuccess(tAnalyticsData));
          return sut;
        },
        act: (cubit) async {
          await cubit.loadAnalytics(from: tFrom, to: tTo);
          when(
            () => mockGetAnalyticsUseCase(from: tFrom, to: tTo),
          ).thenAnswer((_) async => const NetworkFailure(tFailure));
          await cubit.refresh();
        },
        expect: () => [
          AnalyticsLoading(),
          AnalyticsSuccess(data: tAnalyticsData),
          AnalyticsLoading(),
          const AnalyticsFailure(message: tErrorMessage),
        ],
        verify: (_) {
          verify(() => mockGetAnalyticsUseCase(from: tFrom, to: tTo)).called(2);
        },
      );

      test('does nothing when refresh is called on a closed cubit', () async {
        when(
          () => mockGetAnalyticsUseCase(from: tFrom, to: tTo),
        ).thenAnswer((_) async => NetworkSuccess(tAnalyticsData));

        await sut.loadAnalytics(from: tFrom, to: tTo);
        await sut.close();

        // Calling refresh on closed cubit
        await sut.refresh();

        // Verify it was only called once during initial loadAnalytics
        verify(() => mockGetAnalyticsUseCase(from: tFrom, to: tTo)).called(1);
      });

      blocTest<AnalyticsCubit, AnalyticsState>(
        'refresh uses the latest date range when multiple loadAnalytics calls were made',
        build: () {
          final range1From = DateTime(2026, 8, 1);
          final range1To = DateTime(2026, 8, 15);
          final range2From = DateTime(2026, 9, 1);
          final range2To = DateTime(2026, 9, 15);

          when(
            () => mockGetAnalyticsUseCase(from: range1From, to: range1To),
          ).thenAnswer((_) async => NetworkSuccess(tAnalyticsData));
          when(
            () => mockGetAnalyticsUseCase(from: range2From, to: range2To),
          ).thenAnswer((_) async => NetworkSuccess(tUpdatedAnalyticsData));

          return sut;
        },
        act: (cubit) async {
          final range1From = DateTime(2026, 8, 1);
          final range1To = DateTime(2026, 8, 15);
          final range2From = DateTime(2026, 9, 1);
          final range2To = DateTime(2026, 9, 15);

          await cubit.loadAnalytics(from: range1From, to: range1To);
          await cubit.loadAnalytics(from: range2From, to: range2To);
          await cubit.refresh();
        },
        expect: () => [
          AnalyticsLoading(),
          AnalyticsSuccess(data: tAnalyticsData),
          AnalyticsLoading(),
          AnalyticsSuccess(data: tUpdatedAnalyticsData),
          AnalyticsLoading(),
          AnalyticsSuccess(data: tUpdatedAnalyticsData),
        ],
        verify: (_) {
          final range2From = DateTime(2026, 9, 1);
          final range2To = DateTime(2026, 9, 15);
          verify(() => mockGetAnalyticsUseCase(from: range2From, to: range2To)).called(2);
        },
      );
    });
  });
}
