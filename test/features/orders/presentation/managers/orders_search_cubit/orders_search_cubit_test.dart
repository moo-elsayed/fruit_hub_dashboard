import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/order_search_by.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/use_cases/search_orders_use_case.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/managers/orders_search_cubit/orders_search_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchOrdersUseCase extends Mock implements SearchOrdersUseCase {}

void main() {
  late MockSearchOrdersUseCase mockSearchOrdersUseCase;
  late OrdersSearchCubit sut;

  const tErrorMessage = 'Failed to search orders';
  const tFailure = ServerFailure(error: tErrorMessage);

  const tOrder1 = OrderEntity(
    docId: 'doc_1',
    orderId: 1001,
    totalPrice: 250.0,
    status: OrderStatus.pending,
    date: '2026-10-06T10:00:00Z',
  );

  const tOrder2 = OrderEntity(
    docId: 'doc_2',
    orderId: 1002,
    totalPrice: 400.0,
    status: OrderStatus.delivered,
    date: '2026-10-05T10:00:00Z',
  );

  setUpAll(() {
    registerFallbackValue(OrderSearchBy.orderId);
  });

  setUp(() {
    mockSearchOrdersUseCase = MockSearchOrdersUseCase();
    sut = OrdersSearchCubit(mockSearchOrdersUseCase);
  });

  tearDown(() => sut.close());

  group('OrdersSearchCubit', () {
    test('initial state and getters should have default values', () {
      // Assert
      expect(sut.state, isA<OrdersSearchInitial>());
      expect(sut.state.searchBy, OrderSearchBy.orderId);
      expect(sut.currentSearchBy, OrderSearchBy.orderId);
      expect(sut.currentQuery, isEmpty);
    });

    group('searchOrders', () {
      blocTest<OrdersSearchCubit, OrdersSearchState>(
        'should emit OrdersSearchInitial and not call use case when query is empty',
        build: () => sut,
        act: (cubit) => cubit.searchOrders(''),
        expect: () => [
          isA<OrdersSearchInitial>().having(
            (s) => s.searchBy,
            'searchBy',
            OrderSearchBy.orderId,
          ),
        ],
        verify: (_) {
          expect(sut.currentQuery, '');
          verifyZeroInteractions(mockSearchOrdersUseCase);
        },
      );

      blocTest<OrdersSearchCubit, OrdersSearchState>(
        'should emit OrdersSearchInitial and not call use case when query is whitespace only',
        build: () => sut,
        act: (cubit) => cubit.searchOrders('   '),
        expect: () => [
          isA<OrdersSearchInitial>().having(
            (s) => s.searchBy,
            'searchBy',
            OrderSearchBy.orderId,
          ),
        ],
        verify: (_) {
          expect(sut.currentQuery, '');
          verifyZeroInteractions(mockSearchOrdersUseCase);
        },
      );

      blocTest<OrdersSearchCubit, OrdersSearchState>(
        'should emit [OrdersSearchLoading, OrdersSearchSuccess] when search by orderId succeeds',
        setUp: () {
          when(
            () => mockSearchOrdersUseCase.call(
              query: any(named: 'query'),
              searchBy: any(named: 'searchBy'),
              limit: any(named: 'limit'),
            ),
          ).thenAnswer((_) async => const NetworkSuccess([tOrder1]));
        },
        build: () => sut,
        act: (cubit) => cubit.searchOrders('1001'),
        expect: () => [
          isA<OrdersSearchLoading>().having(
            (s) => s.searchBy,
            'searchBy',
            OrderSearchBy.orderId,
          ),
          isA<OrdersSearchSuccess>()
              .having((s) => s.orders, 'orders', [tOrder1])
              .having((s) => s.query, 'query', '1001')
              .having((s) => s.searchBy, 'searchBy', OrderSearchBy.orderId),
        ],
        verify: (_) {
          expect(sut.currentQuery, '1001');
          verify(
            () => mockSearchOrdersUseCase.call(
              query: '1001',
              searchBy: OrderSearchBy.orderId,
            ),
          ).called(1);
        },
      );

      blocTest<OrdersSearchCubit, OrdersSearchState>(
        'should update currentSearchBy and search by customerName when searchBy argument is provided',
        setUp: () {
          when(
            () => mockSearchOrdersUseCase.call(
              query: any(named: 'query'),
              searchBy: any(named: 'searchBy'),
              limit: any(named: 'limit'),
            ),
          ).thenAnswer((_) async => const NetworkSuccess([tOrder1, tOrder2]));
        },
        build: () => sut,
        act: (cubit) =>
            cubit.searchOrders(' Ahmed ', searchBy: OrderSearchBy.customerName),
        expect: () => [
          isA<OrdersSearchLoading>().having(
            (s) => s.searchBy,
            'searchBy',
            OrderSearchBy.customerName,
          ),
          isA<OrdersSearchSuccess>()
              .having((s) => s.orders, 'orders', [tOrder1, tOrder2])
              .having((s) => s.query, 'query', 'Ahmed')
              .having(
                (s) => s.searchBy,
                'searchBy',
                OrderSearchBy.customerName,
              ),
        ],
        verify: (_) {
          expect(sut.currentSearchBy, OrderSearchBy.customerName);
          expect(sut.currentQuery, 'Ahmed');
          verify(
            () => mockSearchOrdersUseCase.call(
              query: 'Ahmed',
              searchBy: OrderSearchBy.customerName,
            ),
          ).called(1);
        },
      );

      blocTest<OrdersSearchCubit, OrdersSearchState>(
        'should search by phone number correctly',
        setUp: () {
          when(
            () => mockSearchOrdersUseCase.call(
              query: any(named: 'query'),
              searchBy: any(named: 'searchBy'),
              limit: any(named: 'limit'),
            ),
          ).thenAnswer((_) async => const NetworkSuccess([tOrder1]));
        },
        build: () => sut,
        act: (cubit) =>
            cubit.searchOrders('01012345678', searchBy: OrderSearchBy.phone),
        expect: () => [
          isA<OrdersSearchLoading>().having(
            (s) => s.searchBy,
            'searchBy',
            OrderSearchBy.phone,
          ),
          isA<OrdersSearchSuccess>()
              .having((s) => s.orders, 'orders', [tOrder1])
              .having((s) => s.query, 'query', '01012345678')
              .having((s) => s.searchBy, 'searchBy', OrderSearchBy.phone),
        ],
        verify: (_) {
          expect(sut.currentSearchBy, OrderSearchBy.phone);
          expect(sut.currentQuery, '01012345678');
          verify(
            () => mockSearchOrdersUseCase.call(
              query: '01012345678',
              searchBy: OrderSearchBy.phone,
            ),
          ).called(1);
        },
      );

      blocTest<OrdersSearchCubit, OrdersSearchState>(
        'should emit empty list in OrdersSearchSuccess when response data is null',
        setUp: () {
          when(
            () => mockSearchOrdersUseCase.call(
              query: any(named: 'query'),
              searchBy: any(named: 'searchBy'),
              limit: any(named: 'limit'),
            ),
          ).thenAnswer((_) async => const NetworkSuccess(null));
        },
        build: () => sut,
        act: (cubit) => cubit.searchOrders('9999'),
        expect: () => [
          isA<OrdersSearchLoading>(),
          isA<OrdersSearchSuccess>()
              .having((s) => s.orders, 'orders', isEmpty)
              .having((s) => s.query, 'query', '9999'),
        ],
      );

      blocTest<OrdersSearchCubit, OrdersSearchState>(
        'should emit [OrdersSearchLoading, OrdersSearchFailure] when search fails',
        setUp: () {
          when(
            () => mockSearchOrdersUseCase.call(
              query: any(named: 'query'),
              searchBy: any(named: 'searchBy'),
              limit: any(named: 'limit'),
            ),
          ).thenAnswer((_) async => const NetworkFailure(tFailure));
        },
        build: () => sut,
        act: (cubit) => cubit.searchOrders('invalid_query'),
        expect: () => [
          isA<OrdersSearchLoading>().having(
            (s) => s.searchBy,
            'searchBy',
            OrderSearchBy.orderId,
          ),
          isA<OrdersSearchFailure>()
              .having((s) => s.message, 'message', tErrorMessage)
              .having((s) => s.searchBy, 'searchBy', OrderSearchBy.orderId),
        ],
      );
    });

    group('setSearchBy', () {
      blocTest<OrdersSearchCubit, OrdersSearchState>(
        'should not emit state when setting the exact same searchBy',
        build: () => sut,
        act: (cubit) => cubit.setSearchBy(OrderSearchBy.orderId),
        expect: () => [],
      );

      blocTest<OrdersSearchCubit, OrdersSearchState>(
        'should update currentSearchBy, clear query, and emit OrdersSearchInitial when searchBy changes',
        build: () => sut,
        act: (cubit) {
          cubit.setSearchBy(OrderSearchBy.customerName);
        },
        expect: () => [
          isA<OrdersSearchInitial>().having(
            (s) => s.searchBy,
            'searchBy',
            OrderSearchBy.customerName,
          ),
        ],
        verify: (_) {
          expect(sut.currentSearchBy, OrderSearchBy.customerName);
          expect(sut.currentQuery, isEmpty);
        },
      );
    });

    group('clearSearch', () {
      blocTest<OrdersSearchCubit, OrdersSearchState>(
        'should reset currentQuery to empty and emit OrdersSearchInitial retaining currentSearchBy',
        setUp: () {
          when(
            () => mockSearchOrdersUseCase.call(
              query: any(named: 'query'),
              searchBy: any(named: 'searchBy'),
              limit: any(named: 'limit'),
            ),
          ).thenAnswer((_) async => const NetworkSuccess([tOrder1]));
        },
        build: () => sut,
        act: (cubit) async {
          await cubit.searchOrders('010123', searchBy: OrderSearchBy.phone);
          cubit.clearSearch();
        },
        skip: 2, // Skip Loading and Success from the search call
        expect: () => [
          isA<OrdersSearchInitial>().having(
            (s) => s.searchBy,
            'searchBy',
            OrderSearchBy.phone,
          ),
        ],
        verify: (_) {
          expect(sut.currentQuery, isEmpty);
          expect(sut.currentSearchBy, OrderSearchBy.phone);
        },
      );
    });
  });
}
