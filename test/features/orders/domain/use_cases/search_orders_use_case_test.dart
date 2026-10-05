import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/order_search_by.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/repo/orders_repo.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/use_cases/search_orders_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockOrdersRepo extends Mock implements OrdersRepo {}

void main() {
  late MockOrdersRepo mockOrdersRepo;
  late SearchOrdersUseCase sut;

  const tOrders = <OrderEntity>[
    OrderEntity(
      docId: 'doc_1',
      orderId: 101,
      totalPrice: 150.0,
      date: '2026-09-17T10:00:00Z',
    ),
  ];

  const tFailure = ServerFailure(error: 'Failed to search orders');

  setUpAll(() {
    registerFallbackValue(OrderSearchBy.orderId);
  });

  setUp(() {
    mockOrdersRepo = MockOrdersRepo();
    sut = SearchOrdersUseCase(mockOrdersRepo);
  });

  group('SearchOrdersUseCase', () {
    test(
      'should call repo with given parameters and return NetworkSuccess with orders list',
      () async {
        // Arrange
        when(
          () => mockOrdersRepo.searchOrders(
            query: any(named: 'query'),
            searchBy: any(named: 'searchBy'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer(
          (_) async => const NetworkSuccess<List<OrderEntity>>(tOrders),
        );

        // Act
        final result = await sut(query: '101', searchBy: OrderSearchBy.orderId);

        // Assert
        expect(result, isA<NetworkSuccess<List<OrderEntity>>>());
        final list = (result as NetworkSuccess<List<OrderEntity>>).data!;
        expect(list, tOrders);
        expect(list.length, 1);
        expect(list.first.orderId, 101);

        verify(
          () => mockOrdersRepo.searchOrders(
            query: '101',
            searchBy: OrderSearchBy.orderId,
            limit: 30,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockOrdersRepo);
      },
    );

    test('should forward custom limit parameter to repo correctly', () async {
      // Arrange
      when(
        () => mockOrdersRepo.searchOrders(
          query: any(named: 'query'),
          searchBy: any(named: 'searchBy'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer(
        (_) async => const NetworkSuccess<List<OrderEntity>>(tOrders),
      );

      // Act
      final result = await sut(
        query: 'Ahmed',
        searchBy: OrderSearchBy.customerName,
        limit: 15,
      );

      // Assert
      expect(result, isA<NetworkSuccess<List<OrderEntity>>>());

      verify(
        () => mockOrdersRepo.searchOrders(
          query: 'Ahmed',
          searchBy: OrderSearchBy.customerName,
          limit: 15,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockOrdersRepo);
    });

    test(
      'should return NetworkFailure when repo call returns failure',
      () async {
        // Arrange
        when(
          () => mockOrdersRepo.searchOrders(
            query: any(named: 'query'),
            searchBy: any(named: 'searchBy'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => const NetworkFailure(tFailure));

        // Act
        final result = await sut(
          query: '01012345678',
          searchBy: OrderSearchBy.phone,
        );

        // Assert
        expect(result, isA<NetworkFailure<List<OrderEntity>>>());
        final failure = (result as NetworkFailure<List<OrderEntity>>).failure;
        expect(failure.error, tFailure.error);

        verify(
          () => mockOrdersRepo.searchOrders(
            query: '01012345678',
            searchBy: OrderSearchBy.phone,
            limit: 30,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockOrdersRepo);
      },
    );
  });
}
