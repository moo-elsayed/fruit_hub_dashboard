import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/use_cases/get_orders_use_case.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/use_cases/update_order_status_use_case.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/managers/orders_cubit/orders_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGetOrdersUseCase extends Mock implements GetOrdersUseCase {}

class MockUpdateOrderStatusUseCase extends Mock
    implements UpdateOrderStatusUseCase {}

void main() {
  setUpAll(() {
    registerFallbackValue(OrderStatus.pending);
  });

  late MockGetOrdersUseCase mockGetOrdersUseCase;
  late MockUpdateOrderStatusUseCase mockUpdateOrderStatusUseCase;
  late OrdersCubit sut;

  const tDocId = 'order_doc_123';
  const tErrorMessage = 'Something went wrong';
  const tFailure = ServerFailure(error: tErrorMessage);

  const tOrders = [
    OrderEntity(
      docId: 'doc_1',
      orderId: 101,
      totalPrice: 150.0,
      status: OrderStatus.pending,
      date: '2026-09-17T10:00:00Z',
    ),
    OrderEntity(
      docId: 'doc_2',
      orderId: 102,
      totalPrice: 280.0,
      status: OrderStatus.shipped,
      date: '2026-09-17T11:00:00Z',
    ),
  ];

  setUp(() {
    mockGetOrdersUseCase = MockGetOrdersUseCase();
    mockUpdateOrderStatusUseCase = MockUpdateOrderStatusUseCase();
    sut = OrdersCubit(mockGetOrdersUseCase, mockUpdateOrderStatusUseCase);
  });

  tearDown(() => sut.close());

  group('OrdersCubit', () {
    test('initial state should be OrdersInitial and currentOrders empty', () {
      expect(sut.state, isA<OrdersInitial>());
      expect(sut.currentOrders, isEmpty);
    });

    group('streamOrders', () {
      blocTest<OrdersCubit, OrdersState>(
        'should emit [OrdersLoading, OrdersSuccess] and update currentOrders when use case emits NetworkSuccess with orders',
        build: () => sut,
        setUp: () {
          when(() => mockGetOrdersUseCase.call())
              .thenAnswer((_) => Stream.value(const NetworkSuccess(tOrders)));
        },
        act: (cubit) => cubit.streamOrders(),
        expect: () => [
          isA<OrdersLoading>().having(
            (s) => s.orderState,
            'orderState',
            OrderState.getOrders,
          ),
          isA<OrdersSuccess>()
              .having((s) => s.orders, 'orders', tOrders)
              .having((s) => s.orderState, 'orderState', OrderState.getOrders),
        ],
        verify: (cubit) {
          expect(cubit.currentOrders, tOrders);
          verify(() => mockGetOrdersUseCase.call()).called(1);
        },
      );

      blocTest<OrdersCubit, OrdersState>(
        'should emit [OrdersLoading, OrdersSuccess] with empty list when NetworkSuccess has null data',
        build: () => sut,
        setUp: () {
          when(() => mockGetOrdersUseCase.call())
              .thenAnswer((_) => Stream.value(const NetworkSuccess(null)));
        },
        act: (cubit) => cubit.streamOrders(),
        expect: () => [
          isA<OrdersLoading>().having(
            (s) => s.orderState,
            'orderState',
            OrderState.getOrders,
          ),
          isA<OrdersSuccess>()
              .having((s) => s.orders, 'orders', isEmpty)
              .having((s) => s.orderState, 'orderState', OrderState.getOrders),
        ],
        verify: (cubit) {
          expect(cubit.currentOrders, isEmpty);
          verify(() => mockGetOrdersUseCase.call()).called(1);
        },
      );

      blocTest<OrdersCubit, OrdersState>(
        'should emit [OrdersLoading, OrdersFailure] when use case emits NetworkFailure',
        build: () => sut,
        setUp: () {
          when(() => mockGetOrdersUseCase.call()).thenAnswer(
            (_) =>
                Stream.value(const NetworkFailure<List<OrderEntity>>(tFailure)),
          );
        },
        act: (cubit) => cubit.streamOrders(),
        expect: () => [
          isA<OrdersLoading>().having(
            (s) => s.orderState,
            'orderState',
            OrderState.getOrders,
          ),
          isA<OrdersFailure>()
              .having((s) => s.message, 'message', tErrorMessage)
              .having((s) => s.orderState, 'orderState', OrderState.getOrders),
        ],
        verify: (_) => verify(() => mockGetOrdersUseCase.call()).called(1),
      );

      blocTest<OrdersCubit, OrdersState>(
        'should emit [OrdersLoading, OrdersFailure] when stream throws error via onError',
        build: () => sut,
        setUp: () {
          when(() => mockGetOrdersUseCase.call())
              .thenAnswer((_) => Stream.error(Exception('Connection lost')));
        },
        act: (cubit) => cubit.streamOrders(),
        expect: () => [
          isA<OrdersLoading>().having(
            (s) => s.orderState,
            'orderState',
            OrderState.getOrders,
          ),
          isA<OrdersFailure>()
              .having((s) => s.message, 'message', contains('Connection lost'))
              .having((s) => s.orderState, 'orderState', OrderState.getOrders),
        ],
        verify: (_) => verify(() => mockGetOrdersUseCase.call()).called(1),
      );

      blocTest<OrdersCubit, OrdersState>(
        'should handle sequential stream emissions and update currentOrders accordingly',
        build: () => sut,
        setUp: () {
          when(() => mockGetOrdersUseCase.call()).thenAnswer(
            (_) => Stream.fromIterable([
              const NetworkSuccess(<OrderEntity>[]),
              const NetworkSuccess(tOrders),
            ]),
          );
        },
        act: (cubit) => cubit.streamOrders(),
        expect: () => [
          isA<OrdersLoading>().having(
            (s) => s.orderState,
            'orderState',
            OrderState.getOrders,
          ),
          isA<OrdersSuccess>()
              .having((s) => s.orders, 'orders', isEmpty)
              .having((s) => s.orderState, 'orderState', OrderState.getOrders),
          isA<OrdersSuccess>()
              .having((s) => s.orders, 'orders', tOrders)
              .having((s) => s.orderState, 'orderState', OrderState.getOrders),
        ],
        verify: (cubit) {
          expect(cubit.currentOrders, tOrders);
          verify(() => mockGetOrdersUseCase.call()).called(1);
        },
      );

      test(
        'should cancel previous subscription when streamOrders is called again',
        () async {
          // Arrange
          final controller1 =
              StreamController<NetworkResponse<List<OrderEntity>>>();
          final controller2 =
              StreamController<NetworkResponse<List<OrderEntity>>>();

          when(() => mockGetOrdersUseCase.call())
              .thenAnswer((_) => controller1.stream);

          // Act 1
          sut.streamOrders();
          expect(controller1.hasListener, isTrue);

          // Arrange 2
          when(() => mockGetOrdersUseCase.call())
              .thenAnswer((_) => controller2.stream);

          // Act 2
          sut.streamOrders();

          // Assert: previous controller should have its subscription cancelled
          await pumpEventQueue();
          expect(controller1.hasListener, isFalse);
          expect(controller2.hasListener, isTrue);

          await controller1.close();
          await controller2.close();
        },
      );

      test(
        'should not emit state if cubit is closed when response arrives',
        () async {
          // Arrange
          final controller =
              StreamController<NetworkResponse<List<OrderEntity>>>();
          when(() => mockGetOrdersUseCase.call())
              .thenAnswer((_) => controller.stream);

          sut.streamOrders();
          await sut.close();

          // Act - add to stream after close
          controller.add(const NetworkSuccess(tOrders));
          await pumpEventQueue();

          // Assert - closed cubit does not emit
          expect(sut.isClosed, isTrue);
          await controller.close();
        },
      );

      test(
        'should not emit state if cubit is closed when stream emits error',
        () async {
          // Arrange
          final controller =
              StreamController<NetworkResponse<List<OrderEntity>>>();
          when(() => mockGetOrdersUseCase.call())
              .thenAnswer((_) => controller.stream);

          sut.streamOrders();
          await sut.close();

          // Act - emit error after close
          controller.addError(Exception('Late error'));
          await pumpEventQueue();

          // Assert - closed cubit does not emit
          expect(sut.isClosed, isTrue);
          await controller.close();
        },
      );
    });

    group('updateOrderStatus', () {
      blocTest<OrdersCubit, OrdersState>(
        'should emit [OrdersLoading, OrdersSuccess] with current orders when updateOrderStatus succeeds',
        build: () => sut,
        setUp: () {
          when(
            () => mockUpdateOrderStatusUseCase.call(
              tDocId,
              OrderStatus.delivered,
            ),
          ).thenAnswer((_) async => const NetworkSuccess(null));
        },
        act: (cubit) => cubit.updateOrderStatus(tDocId, OrderStatus.delivered),
        expect: () => [
          isA<OrdersLoading>().having(
            (s) => s.orderState,
            'orderState',
            OrderState.updateOrderStatus,
          ),
          isA<OrdersSuccess>()
              .having((s) => s.orders, 'orders', isEmpty)
              .having(
                (s) => s.orderState,
                'orderState',
                OrderState.updateOrderStatus,
              ),
        ],
        verify: (_) {
          verify(
            () => mockUpdateOrderStatusUseCase.call(
              tDocId,
              OrderStatus.delivered,
            ),
          ).called(1);
          verifyNoMoreInteractions(mockUpdateOrderStatusUseCase);
        },
      );

      blocTest<OrdersCubit, OrdersState>(
        'should emit [OrdersLoading, OrdersFailure] with error message when updateOrderStatus fails',
        build: () => sut,
        setUp: () {
          when(
            () => mockUpdateOrderStatusUseCase.call(
              tDocId,
              OrderStatus.cancelled,
            ),
          ).thenAnswer((_) async => const NetworkFailure<void>(tFailure));
        },
        act: (cubit) => cubit.updateOrderStatus(tDocId, OrderStatus.cancelled),
        expect: () => [
          isA<OrdersLoading>().having(
            (s) => s.orderState,
            'orderState',
            OrderState.updateOrderStatus,
          ),
          isA<OrdersFailure>()
              .having((s) => s.message, 'message', tErrorMessage)
              .having(
                (s) => s.orderState,
                'orderState',
                OrderState.updateOrderStatus,
              ),
        ],
        verify: (_) {
          verify(
            () => mockUpdateOrderStatusUseCase.call(
              tDocId,
              OrderStatus.cancelled,
            ),
          ).called(1);
          verifyNoMoreInteractions(mockUpdateOrderStatusUseCase);
        },
      );

      test('should preserve currentOrders in OrdersSuccess when updateOrderStatus succeeds', () async {
        // Arrange
        when(() => mockGetOrdersUseCase.call())
            .thenAnswer((_) => Stream.value(const NetworkSuccess(tOrders)));
        when(
          () =>
              mockUpdateOrderStatusUseCase.call(tDocId, OrderStatus.delivered),
        ).thenAnswer((_) async => const NetworkSuccess(null));

        // Act 1: stream orders first to populate _orders
        sut.streamOrders();
        await pumpEventQueue();
        expect(sut.currentOrders, tOrders);

        // Act 2: update order status
        await sut.updateOrderStatus(tDocId, OrderStatus.delivered);

        // Assert: state should contain the preserved orders
        expect(sut.state, isA<OrdersSuccess>());
        final successState = sut.state as OrdersSuccess;
        expect(successState.orders, tOrders);
        expect(successState.orderState, OrderState.updateOrderStatus);
      });

      test('should not emit state if cubit is closed before updateOrderStatus completes', () async {
        // Arrange
        final completer = Completer<NetworkResponse<void>>();
        when(() => mockUpdateOrderStatusUseCase.call(any(), any()))
            .thenAnswer((_) => completer.future);

        // Act: start update then immediately close cubit
        final future = sut.updateOrderStatus(tDocId, OrderStatus.shipped);
        await sut.close();

        completer.complete(const NetworkSuccess(null));
        await future;

        // Assert: cubit is closed and didn't crash
        expect(sut.isClosed, isTrue);
      });
    });

    group('close', () {
      test('cancels active ordersSubscription on close', () async {
        // Arrange
        final controller =
            StreamController<NetworkResponse<List<OrderEntity>>>();
        when(() => mockGetOrdersUseCase.call())
            .thenAnswer((_) => controller.stream);

        sut.streamOrders();
        expect(controller.hasListener, isTrue);

        // Act
        await sut.close();

        // Assert
        expect(controller.hasListener, isFalse);
        await controller.close();
      });
    });
  });
}
