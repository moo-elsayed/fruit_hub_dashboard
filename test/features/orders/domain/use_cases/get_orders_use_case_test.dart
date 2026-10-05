import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/orders_page_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/repo/orders_repo.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/use_cases/get_orders_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockOrdersRepo extends Mock implements OrdersRepo {}

void main() {
  late MockOrdersRepo mockOrdersRepo;
  late GetOrdersUseCase sut;

  const tOrdersPage = OrdersPageEntity(
    orders: [
      OrderEntity(
        docId: 'doc_1',
        orderId: 101,
        totalPrice: 150.0,
        date: '2026-09-17T10:00:00Z',
      ),
      OrderEntity(
        docId: 'doc_2',
        orderId: 102,
        totalPrice: 300.0,
        date: '2026-09-17T11:00:00Z',
      ),
    ],
    hasMore: true,
  );

  const tFailure = ServerFailure(error: 'Failed to fetch orders');

  setUpAll(() {
    registerFallbackValue(OrderStatus.pending);
  });

  setUp(() {
    mockOrdersRepo = MockOrdersRepo();
    sut = GetOrdersUseCase(mockOrdersRepo);
  });

  group('GetOrdersUseCase', () {
    test('should return NetworkSuccess with OrdersPageEntity when repo returns NetworkSuccess', () async {
      // Arrange
      when(
        () => mockOrdersRepo.getOrders(
          limit: any(named: 'limit'),
          lastDocument: any(named: 'lastDocument'),
          status: any(named: 'status'),
        ),
      ).thenAnswer((_) async => const NetworkSuccess(tOrdersPage));

      // Act
      final result = await sut();

      // Assert
      expect(result, isA<NetworkSuccess<OrdersPageEntity>>());
      expect((result as NetworkSuccess<OrdersPageEntity>).data, tOrdersPage);
      verify(
        () => mockOrdersRepo.getOrders(
          limit: 15,
          lastDocument: null,
          status: null,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockOrdersRepo);
    });

    test('should return NetworkFailure when repo returns NetworkFailure', () async {
      // Arrange
      when(
        () => mockOrdersRepo.getOrders(
          limit: any(named: 'limit'),
          lastDocument: any(named: 'lastDocument'),
          status: any(named: 'status'),
        ),
      ).thenAnswer((_) async => const NetworkFailure(tFailure));

      // Act
      final result = await sut(limit: 20, status: OrderStatus.pending);

      // Assert
      expect(result, isA<NetworkFailure<OrdersPageEntity>>());
      expect((result as NetworkFailure<OrdersPageEntity>).failure, tFailure);
      verify(
        () => mockOrdersRepo.getOrders(
          limit: 20,
          lastDocument: null,
          status: OrderStatus.pending,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockOrdersRepo);
    });
  });
}
