import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/use_cases/get_orders_use_case.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/use_cases/update_order_status_use_case.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/managers/orders_cubit/orders_cubit.dart';
import 'package:mocktail/mocktail.dart';

// 1. Mocks
class MockGetOrdersUseCase extends Mock implements GetOrdersUseCase {}

class MockUpdateOrderStatusUseCase extends Mock
    implements UpdateOrderStatusUseCase {}

void main() {
  late OrdersCubit sut;
  late MockGetOrdersUseCase mockGetOrdersUseCase;
  late MockUpdateOrderStatusUseCase mockUpdateOrderStatusUseCase;

  setUpAll(() {
    registerFallbackValue(OrderStatus.pending);
  });

  setUp(() {
    mockGetOrdersUseCase = MockGetOrdersUseCase();
    mockUpdateOrderStatusUseCase = MockUpdateOrderStatusUseCase();
    sut = OrdersCubit(mockGetOrdersUseCase, mockUpdateOrderStatusUseCase);
  });

  tearDown(() {
    sut.close();
  });

  group('OrdersCubit', () {
    test('initial state is OrdersInitial', () {
      expect(sut.state, isA<OrdersInitial>());
    });

    // Dummy Data
    final tOrders = [OrderEntity(orderId: 1, docId: 'doc_1')];

    // ==========================================
    // 1. Tests for streamOrders
    // ==========================================
    group('streamOrders', () {
      blocTest<OrdersCubit, OrdersState>(
        'emits [OrdersLoading, OrdersSuccess] when data is received successfully',
        build: () => sut,
        setUp: () => when(
          () => mockGetOrdersUseCase(),
        ).thenAnswer((_) => Stream.value(NetworkSuccess(tOrders))),
        act: (cubit) => cubit.streamOrders(),
        expect: () => [
          isA<OrdersLoading>().having(
            (s) => s.orderState,
            'state',
            OrderState.getOrders,
          ),
          isA<OrdersSuccess>()
              .having((s) => s.orders, 'orders', tOrders)
              .having((s) => s.orderState, 'state', OrderState.getOrders),
        ],
      );

      blocTest<OrdersCubit, OrdersState>(
        'emits [OrdersLoading, OrdersFailure] when NetworkFailure is received',
        build: () => sut,
        setUp: () => when(() => mockGetOrdersUseCase()).thenAnswer(
          (_) => Stream.value(NetworkFailure(Exception('Server Error'))),
        ),
        act: (cubit) => cubit.streamOrders(),
        expect: () => [
          isA<OrdersLoading>(),
          isA<OrdersFailure>().having(
            (s) => s.message,
            'message',
            contains('Server Error'),
          ),
        ],
      );

      blocTest<OrdersCubit, OrdersState>(
        'emits [OrdersLoading, OrdersFailure] when stream emits error',
        build: () => sut,
        setUp: () => when(
          () => mockGetOrdersUseCase(),
        ).thenAnswer((_) => Stream.error(Exception('Stream Error'))),
        act: (cubit) => cubit.streamOrders(),
        expect: () => [
          isA<OrdersLoading>(),
          isA<OrdersFailure>().having(
            (s) => s.message,
            'message',
            contains('Stream Error'),
          ),
        ],
      );
    });

    // ==========================================
    // 2. Tests for updateOrderStatus
    // ==========================================
    group('updateOrderStatus', () {
      const tDocId = 'doc_123';
      const tStatus = OrderStatus.shipped;

      blocTest<OrdersCubit, OrdersState>(
        'emits [OrdersLoading] ONLY when update is successful',
        build: () => sut,
        setUp: () => when(
          () => mockUpdateOrderStatusUseCase(any(), any()),
        ).thenAnswer((_) async => const NetworkSuccess()),
        act: (cubit) => cubit.updateOrderStatus(tDocId, tStatus),
        expect: () => [
          isA<OrdersLoading>().having(
            (s) => s.orderState,
            'state',
            OrderState.updateOrderStatus,
          ),
        ],
        verify: (_) {
          verify(() => mockUpdateOrderStatusUseCase(tDocId, tStatus)).called(1);
        },
      );

      blocTest<OrdersCubit, OrdersState>(
        'emits [OrdersLoading, OrdersFailure] when update fails',
        build: () => sut,
        setUp: () => when(
          () => mockUpdateOrderStatusUseCase(any(), any()),
        ).thenAnswer((_) async => NetworkFailure(Exception('Update Failed'))),
        act: (cubit) => cubit.updateOrderStatus(tDocId, tStatus),
        expect: () => [
          isA<OrdersLoading>(),
          isA<OrdersFailure>()
              .having((s) => s.message, 'message', contains('Update Failed'))
              .having(
                (s) => s.orderState,
                'state',
                OrderState.updateOrderStatus,
              ),
        ],
      );
    });
  });
}
