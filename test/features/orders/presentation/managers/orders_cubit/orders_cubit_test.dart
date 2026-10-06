import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/orders_page_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/orders_stats_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/use_cases/get_orders_stats_use_case.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/use_cases/get_orders_use_case.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/use_cases/update_order_status_use_case.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/managers/orders_cubit/orders_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetOrdersUseCase extends Mock implements GetOrdersUseCase {}

class MockGetOrdersStatsUseCase extends Mock implements GetOrdersStatsUseCase {}

class MockUpdateOrderStatusUseCase extends Mock
    implements UpdateOrderStatusUseCase {}

void main() {
  late MockGetOrdersUseCase mockGetOrdersUseCase;
  late MockGetOrdersStatsUseCase mockGetOrdersStatsUseCase;
  late MockUpdateOrderStatusUseCase mockUpdateOrderStatusUseCase;
  late OrdersCubit sut;
  late DocumentSnapshot fakeDoc;
  late OrdersPageEntity tPage1;

  const tErrorMessage = 'Failed to load orders';
  const tFailure = ServerFailure(error: tErrorMessage);

  const tStats = OrdersStatsEntity(
    totalCount: 50,
    pendingCount: 15,
    processingCount: 10,
    shippedCount: 5,
    deliveredCount: 15,
    cancelledCount: 5,
  );

  const tOrder1 = OrderEntity(
    docId: 'doc_1',
    orderId: 101,
    totalPrice: 200.0,
    status: OrderStatus.pending,
    date: '2026-10-06T10:00:00Z',
  );

  const tOrder2 = OrderEntity(
    docId: 'doc_2',
    orderId: 102,
    totalPrice: 350.0,
    status: OrderStatus.processing,
    date: '2026-10-06T09:00:00Z',
  );

  const tOrder3 = OrderEntity(
    docId: 'doc_3',
    orderId: 103,
    totalPrice: 150.0,
    status: OrderStatus.delivered,
    date: '2026-10-06T08:00:00Z',
  );

  setUpAll(() {
    registerFallbackValue(OrderStatus.pending);
  });

  setUp(() async {
    mockGetOrdersUseCase = MockGetOrdersUseCase();
    mockGetOrdersStatsUseCase = MockGetOrdersStatsUseCase();
    mockUpdateOrderStatusUseCase = MockUpdateOrderStatusUseCase();

    sut = OrdersCubit(
      mockGetOrdersUseCase,
      mockGetOrdersStatsUseCase,
      mockUpdateOrderStatusUseCase,
    );

    final fakeFirestore = FakeFirebaseFirestore();
    fakeDoc = await fakeFirestore.collection('orders').doc('doc_2').get();

    tPage1 = OrdersPageEntity(
      orders: const [tOrder1, tOrder2],
      hasMore: true,
      lastDocument: fakeDoc,
    );
  });

  tearDown(() => sut.close());

  group('OrdersCubit', () {
    test('initial state and getters should have default values', () {
      // Assert
      expect(sut.state, isA<OrdersInitial>());
      expect(sut.currentOrders, isEmpty);
      expect(sut.activeFilter, isNull);
      expect(sut.stats.totalCount, 0);
      expect(sut.hasMore, isFalse);
      expect(sut.isLoadingMore, isFalse);
    });

    group('initOrders', () {
      blocTest<OrdersCubit, OrdersState>(
        'should fetch stats and orders in parallel and emit [OrdersLoading, OrdersSuccess] with stats',
        setUp: () {
          when(() => mockGetOrdersStatsUseCase.call())
              .thenAnswer((_) async => const NetworkSuccess(tStats));
          when(
            () => mockGetOrdersUseCase.call(
              limit: any(named: 'limit'),
              lastDocument: any(named: 'lastDocument'),
              status: any(named: 'status'),
            ),
          ).thenAnswer((_) async => NetworkSuccess(tPage1));
        },
        build: () => sut,
        act: (cubit) => cubit.initOrders(),
        expect: () => [
          isA<OrdersLoading>().having(
            (s) => s.orderState,
            'orderState',
            OrderState.getOrders,
          ),
          isA<OrdersSuccess>()
              .having((s) => s.orders, 'orders', [tOrder1, tOrder2])
              .having((s) => s.hasMore, 'hasMore', isTrue)
              .having((s) => s.stats.totalCount, 'totalCount', 50)
              .having((s) => s.orderState, 'orderState', OrderState.getOrders),
        ],
        verify: (_) {
          expect(sut.stats.totalCount, 50);
          expect(sut.currentOrders.length, 2);
          expect(sut.hasMore, isTrue);
          verify(() => mockGetOrdersStatsUseCase.call()).called(1);
          verify(() => mockGetOrdersUseCase.call(limit: 15, status: null))
              .called(1);
        },
      );
    });

    group('getOrdersStats', () {
      test(
        'should update internal stats when state is not OrdersSuccess',
        () async {
          // Arrange
          when(() => mockGetOrdersStatsUseCase.call())
              .thenAnswer((_) async => const NetworkSuccess(tStats));

          // Act
          await sut.getOrdersStats();

          // Assert
          expect(sut.stats.totalCount, 50);
          expect(sut.stats.pendingCount, 15);
          expect(sut.state, isA<OrdersInitial>());
        },
      );

      blocTest<OrdersCubit, OrdersState>(
        'should emit updated OrdersSuccess with orderState reset to getOrders when state is already OrdersSuccess',
        setUp: () {
          when(
            () => mockGetOrdersUseCase.call(
              limit: any(named: 'limit'),
              lastDocument: any(named: 'lastDocument'),
              status: any(named: 'status'),
            ),
          ).thenAnswer((_) async => NetworkSuccess(tPage1));

          when(() => mockGetOrdersStatsUseCase.call())
              .thenAnswer((_) async => const NetworkSuccess(tStats));
        },
        build: () => sut,
        act: (cubit) async {
          await cubit.getOrders();
          await cubit.getOrdersStats();
        },
        expect: () => [
          isA<OrdersLoading>(),
          isA<OrdersSuccess>().having((s) => s.stats.totalCount, 'stats', 0),
          isA<OrdersSuccess>()
              .having((s) => s.stats.totalCount, 'stats', 50)
              .having((s) => s.orderState, 'orderState', OrderState.getOrders),
        ],
      );

      test(
        'should retain current stats when getOrdersStats returns failure',
        () async {
          // Arrange
          when(() => mockGetOrdersStatsUseCase.call())
              .thenAnswer((_) async => const NetworkFailure(tFailure));

          // Act
          await sut.getOrdersStats();

          // Assert
          expect(sut.stats.totalCount, 0);
        },
      );
    });

    group('getOrders', () {
      blocTest<OrdersCubit, OrdersState>(
        'should reset pagination, emit [OrdersLoading, OrdersSuccess] on success',
        setUp: () {
          when(
            () => mockGetOrdersUseCase.call(
              limit: any(named: 'limit'),
              lastDocument: any(named: 'lastDocument'),
              status: any(named: 'status'),
            ),
          ).thenAnswer((_) async => NetworkSuccess(tPage1));
        },
        build: () => sut,
        act: (cubit) => cubit.getOrders(),
        expect: () => [
          isA<OrdersLoading>().having(
            (s) => s.orderState,
            'orderState',
            OrderState.getOrders,
          ),
          isA<OrdersSuccess>()
              .having((s) => s.orders, 'orders', [tOrder1, tOrder2])
              .having((s) => s.hasMore, 'hasMore', isTrue)
              .having((s) => s.activeFilter, 'activeFilter', isNull),
        ],
        verify: (_) {
          expect(sut.currentOrders.length, 2);
          expect(sut.hasMore, isTrue);
          expect(sut.isLoadingMore, isFalse);
        },
      );

      blocTest<OrdersCubit, OrdersState>(
        'should update activeFilter and pass it to use case when filter closure is provided',
        setUp: () {
          when(
            () => mockGetOrdersUseCase.call(
              limit: any(named: 'limit'),
              lastDocument: any(named: 'lastDocument'),
              status: any(named: 'status'),
            ),
          ).thenAnswer(
            (_) async => const NetworkSuccess(
              OrdersPageEntity(orders: [tOrder1], hasMore: false),
            ),
          );
        },
        build: () => sut,
        act: (cubit) => cubit.getOrders(filter: () => OrderStatus.pending),
        expect: () => [
          isA<OrdersLoading>(),
          isA<OrdersSuccess>()
              .having((s) => s.orders, 'orders', [tOrder1])
              .having(
                (s) => s.activeFilter,
                'activeFilter',
                OrderStatus.pending,
              )
              .having((s) => s.hasMore, 'hasMore', isFalse),
        ],
        verify: (_) {
          expect(sut.activeFilter, OrderStatus.pending);
          verify(
            () => mockGetOrdersUseCase.call(
              limit: 15,
              status: OrderStatus.pending,
            ),
          ).called(1);
        },
      );

      blocTest<OrdersCubit, OrdersState>(
        'should emit empty orders and hasMore false when response data is null',
        setUp: () {
          when(
            () => mockGetOrdersUseCase.call(
              limit: any(named: 'limit'),
              lastDocument: any(named: 'lastDocument'),
              status: any(named: 'status'),
            ),
          ).thenAnswer((_) async => const NetworkSuccess(null));
        },
        build: () => sut,
        act: (cubit) => cubit.getOrders(),
        expect: () => [
          isA<OrdersLoading>(),
          isA<OrdersSuccess>()
              .having((s) => s.orders, 'orders', isEmpty)
              .having((s) => s.hasMore, 'hasMore', isFalse),
        ],
        verify: (_) {
          expect(sut.currentOrders, isEmpty);
          expect(sut.hasMore, isFalse);
        },
      );

      blocTest<OrdersCubit, OrdersState>(
        'should emit [OrdersLoading, OrdersFailure] when getOrders fails',
        setUp: () {
          when(
            () => mockGetOrdersUseCase.call(
              limit: any(named: 'limit'),
              lastDocument: any(named: 'lastDocument'),
              status: any(named: 'status'),
            ),
          ).thenAnswer((_) async => const NetworkFailure(tFailure));
        },
        build: () => sut,
        act: (cubit) => cubit.getOrders(),
        expect: () => [
          isA<OrdersLoading>(),
          isA<OrdersFailure>()
              .having((s) => s.message, 'message', tErrorMessage)
              .having((s) => s.orderState, 'orderState', OrderState.getOrders),
        ],
      );
    });

    group('loadMoreOrders', () {
      blocTest<OrdersCubit, OrdersState>(
        'should return early without action if state is not OrdersSuccess',
        build: () => sut,
        act: (cubit) => cubit.loadMoreOrders(),
        expect: () => [],
        verify: (_) {
          verifyZeroInteractions(mockGetOrdersUseCase);
        },
      );

      blocTest<OrdersCubit, OrdersState>(
        'should return early without action if hasMore is false',
        setUp: () {
          when(
            () => mockGetOrdersUseCase.call(
              limit: any(named: 'limit'),
              lastDocument: any(named: 'lastDocument'),
              status: any(named: 'status'),
            ),
          ).thenAnswer(
            (_) async => const NetworkSuccess(
              OrdersPageEntity(orders: [tOrder1], hasMore: false),
            ),
          );
        },
        build: () => sut,
        act: (cubit) async {
          await cubit.getOrders();
          await cubit.loadMoreOrders();
        },
        skip: 2, // Skip initial loading and success
        expect: () => [],
      );

      blocTest<OrdersCubit, OrdersState>(
        'should append new orders, update pagination flags, and emit OrdersSuccess with isLoadingMore false',
        setUp: () {
          when(
            () => mockGetOrdersUseCase.call(
              limit: any(named: 'limit'),
              lastDocument: null,
              status: any(named: 'status'),
            ),
          ).thenAnswer((_) async => NetworkSuccess(tPage1));

          when(
            () => mockGetOrdersUseCase.call(
              limit: any(named: 'limit'),
              lastDocument: fakeDoc,
              status: any(named: 'status'),
            ),
          ).thenAnswer(
            (_) async => const NetworkSuccess(
              OrdersPageEntity(orders: [tOrder3], hasMore: false),
            ),
          );
        },
        build: () => sut,
        act: (cubit) async {
          await cubit.getOrders();
          await cubit.loadMoreOrders();
        },
        skip: 2, // Skip getOrders emissions
        expect: () => [
          isA<OrdersSuccess>().having(
            (s) => s.isLoadingMore,
            'isLoadingMore',
            isTrue,
          ),
          isA<OrdersSuccess>()
              .having((s) => s.orders, 'orders', [tOrder1, tOrder2, tOrder3])
              .having((s) => s.hasMore, 'hasMore', isFalse)
              .having((s) => s.isLoadingMore, 'isLoadingMore', isFalse),
        ],
        verify: (_) {
          expect(sut.currentOrders.length, 3);
          expect(sut.hasMore, isFalse);
          expect(sut.isLoadingMore, isFalse);
          verify(
            () => mockGetOrdersUseCase.call(
              limit: 15,
              lastDocument: fakeDoc,
              status: null,
            ),
          ).called(1);
        },
      );

      blocTest<OrdersCubit, OrdersState>(
        'should set hasMore to false when loaded page is empty',
        setUp: () {
          when(
            () => mockGetOrdersUseCase.call(
              limit: any(named: 'limit'),
              lastDocument: null,
              status: any(named: 'status'),
            ),
          ).thenAnswer((_) async => NetworkSuccess(tPage1));

          when(
            () => mockGetOrdersUseCase.call(
              limit: any(named: 'limit'),
              lastDocument: fakeDoc,
              status: any(named: 'status'),
            ),
          ).thenAnswer(
            (_) async => const NetworkSuccess(
              OrdersPageEntity(orders: [], hasMore: false),
            ),
          );
        },
        build: () => sut,
        act: (cubit) async {
          await cubit.getOrders();
          await cubit.loadMoreOrders();
        },
        skip: 2,
        expect: () => [
          isA<OrdersSuccess>().having(
            (s) => s.isLoadingMore,
            'isLoadingMore',
            isTrue,
          ),
          isA<OrdersSuccess>()
              .having((s) => s.hasMore, 'hasMore', isFalse)
              .having((s) => s.isLoadingMore, 'isLoadingMore', isFalse),
        ],
        verify: (_) {
          expect(sut.hasMore, isFalse);
          expect(sut.isLoadingMore, isFalse);
        },
      );

      blocTest<OrdersCubit, OrdersState>(
        'should reset isLoadingMore to false when loadMoreOrders fails',
        setUp: () {
          when(
            () => mockGetOrdersUseCase.call(
              limit: any(named: 'limit'),
              lastDocument: null,
              status: any(named: 'status'),
            ),
          ).thenAnswer((_) async => NetworkSuccess(tPage1));

          when(
            () => mockGetOrdersUseCase.call(
              limit: any(named: 'limit'),
              lastDocument: fakeDoc,
              status: any(named: 'status'),
            ),
          ).thenAnswer((_) async => const NetworkFailure(tFailure));
        },
        build: () => sut,
        act: (cubit) async {
          await cubit.getOrders();
          await cubit.loadMoreOrders();
        },
        skip: 2,
        expect: () => [
          isA<OrdersSuccess>().having(
            (s) => s.isLoadingMore,
            'isLoadingMore',
            isTrue,
          ),
          isA<OrdersSuccess>().having(
            (s) => s.isLoadingMore,
            'isLoadingMore',
            isFalse,
          ),
        ],
        verify: (_) {
          expect(sut.isLoadingMore, isFalse);
        },
      );
    });

    group('setFilter', () {
      blocTest<OrdersCubit, OrdersState>(
        'should return early without re-fetching if activeFilter is identical and state is OrdersSuccess',
        setUp: () {
          when(
            () => mockGetOrdersUseCase.call(
              limit: any(named: 'limit'),
              lastDocument: any(named: 'lastDocument'),
              status: any(named: 'status'),
            ),
          ).thenAnswer(
            (_) async => const NetworkSuccess(
              OrdersPageEntity(orders: [tOrder1], hasMore: false),
            ),
          );
        },
        build: () => sut,
        act: (cubit) async {
          await cubit.setFilter(OrderStatus.pending);
          // Try setting identical filter
          await cubit.setFilter(OrderStatus.pending);
        },
        verify: (_) {
          // Called only once from the first setFilter
          verify(
            () => mockGetOrdersUseCase.call(
              limit: 15,
              status: OrderStatus.pending,
            ),
          ).called(1);
        },
      );

      blocTest<OrdersCubit, OrdersState>(
        'should update filter and re-fetch orders when filter changes',
        setUp: () {
          when(
            () => mockGetOrdersUseCase.call(
              limit: any(named: 'limit'),
              lastDocument: any(named: 'lastDocument'),
              status: any(named: 'status'),
            ),
          ).thenAnswer(
            (_) async => const NetworkSuccess(
              OrdersPageEntity(orders: [tOrder1], hasMore: false),
            ),
          );
        },
        build: () => sut,
        act: (cubit) => cubit.setFilter(OrderStatus.delivered),
        expect: () => [
          isA<OrdersLoading>(),
          isA<OrdersSuccess>().having(
            (s) => s.activeFilter,
            'activeFilter',
            OrderStatus.delivered,
          ),
        ],
        verify: (_) {
          expect(sut.activeFilter, OrderStatus.delivered);
          verify(
            () => mockGetOrdersUseCase.call(
              limit: 15,
              status: OrderStatus.delivered,
            ),
          ).called(1);
        },
      );
    });

    group('updateOrderStatus', () {
      blocTest<OrdersCubit, OrdersState>(
        'should return early without action when order is not found',
        build: () => sut,
        act: (cubit) =>
            cubit.updateOrderStatus('non_existing_doc', OrderStatus.delivered),
        expect: () => [],
        verify: (_) {
          verifyZeroInteractions(mockUpdateOrderStatusUseCase);
        },
      );

      blocTest<OrdersCubit, OrdersState>(
        'should return early without action when new status is identical to current status',
        setUp: () {
          when(
            () => mockGetOrdersUseCase.call(
              limit: any(named: 'limit'),
              lastDocument: any(named: 'lastDocument'),
              status: any(named: 'status'),
            ),
          ).thenAnswer((_) async => NetworkSuccess(tPage1));
        },
        build: () => sut,
        act: (cubit) async {
          await cubit.getOrders();
          // tOrder1 current status is already pending
          await cubit.updateOrderStatus('doc_1', OrderStatus.pending);
        },
        skip: 2,
        expect: () => [],
        verify: (_) {
          verifyZeroInteractions(mockUpdateOrderStatusUseCase);
        },
      );

      blocTest<OrdersCubit, OrdersState>(
        'should update status optimistically, emit OrdersSuccess with updateOrderStatus on backend success, and refresh stats with orderState reset to getOrders',
        setUp: () {
          when(
            () => mockGetOrdersUseCase.call(
              limit: any(named: 'limit'),
              lastDocument: any(named: 'lastDocument'),
              status: any(named: 'status'),
            ),
          ).thenAnswer((_) async => NetworkSuccess(tPage1));

          when(
            () => mockUpdateOrderStatusUseCase.call(
              'doc_1',
              OrderStatus.delivered,
            ),
          ).thenAnswer((_) async => const NetworkSuccess(null));

          when(() => mockGetOrdersStatsUseCase.call())
              .thenAnswer((_) async => const NetworkSuccess(tStats));
        },
        build: () => sut,
        act: (cubit) async {
          await cubit.getOrders();
          await cubit.updateOrderStatus('doc_1', OrderStatus.delivered);
        },
        skip: 2, // Skip getOrders emissions
        expect: () => [
          // 1. Optimistic update
          isA<OrdersSuccess>()
              .having(
                (s) => s.orders.first.status,
                'status',
                OrderStatus.delivered,
              )
              .having((s) => s.orderState, 'orderState', OrderState.getOrders),
          // 2. Backend success confirmation (triggers toast once)
          isA<OrdersSuccess>()
              .having(
                (s) => s.orders.first.status,
                'status',
                OrderStatus.delivered,
              )
              .having(
                (s) => s.orderState,
                'orderState',
                OrderState.updateOrderStatus,
              ),
          // 3. Stats refreshed with orderState reset to getOrders (prevents toast duplication!)
          isA<OrdersSuccess>()
              .having((s) => s.stats.totalCount, 'totalCount', 50)
              .having((s) => s.orderState, 'orderState', OrderState.getOrders),
        ],
        verify: (_) {
          expect(sut.currentOrders.first.status, OrderStatus.delivered);
          verify(
            () => mockUpdateOrderStatusUseCase.call(
              'doc_1',
              OrderStatus.delivered,
            ),
          ).called(1);
          verify(() => mockGetOrdersStatsUseCase.call()).called(1);
        },
      );

      blocTest<OrdersCubit, OrdersState>(
        'should rollback status to previous on backend failure, emit OrdersFailure, then emit OrdersSuccess',
        setUp: () {
          when(
            () => mockGetOrdersUseCase.call(
              limit: any(named: 'limit'),
              lastDocument: any(named: 'lastDocument'),
              status: any(named: 'status'),
            ),
          ).thenAnswer((_) async => NetworkSuccess(tPage1));

          when(
            () => mockUpdateOrderStatusUseCase.call(
              'doc_1',
              OrderStatus.cancelled,
            ),
          ).thenAnswer((_) async => const NetworkFailure(tFailure));
        },
        build: () => sut,
        act: (cubit) async {
          await cubit.getOrders();
          await cubit.updateOrderStatus('doc_1', OrderStatus.cancelled);
        },
        skip: 2, // Skip getOrders
        expect: () => [
          // 1. Optimistic update
          isA<OrdersSuccess>().having(
            (s) => s.orders.first.status,
            'status',
            OrderStatus.cancelled,
          ),
          // 2. Failure emission with message and updateOrderStatus state
          isA<OrdersFailure>()
              .having((s) => s.message, 'message', tErrorMessage)
              .having(
                (s) => s.orderState,
                'orderState',
                OrderState.updateOrderStatus,
              ),
          // 3. Rollback back to pending
          isA<OrdersSuccess>().having(
            (s) => s.orders.first.status,
            'status',
            OrderStatus.pending,
          ),
        ],
        verify: (_) {
          expect(sut.currentOrders.first.status, OrderStatus.pending);
        },
      );
    });
  });
}
