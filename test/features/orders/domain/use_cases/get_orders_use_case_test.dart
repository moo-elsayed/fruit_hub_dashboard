import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/repo/orders_repo.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/use_cases/get_orders_use_case.dart';
import 'package:mocktail/mocktail.dart';

// 1. Mock Repository
class MockOrdersRepo extends Mock implements OrdersRepo {}

void main() {
  late MockOrdersRepo mockOrdersRepo;
  late GetOrdersUseCase getOrdersUseCase;

  setUpAll(() {
    registerFallbackValue(OrderStatus.pending);
  });

  setUp(() {
    mockOrdersRepo = MockOrdersRepo();
    getOrdersUseCase = GetOrdersUseCase(mockOrdersRepo);
  });

  // ==========================================
  // Test GetOrdersUseCase
  // ==========================================
  group('GetOrdersUseCase', () {
    test('should return stream of orders from repository', () async {
      // Arrange
      final tOrders = [
        OrderEntity(orderId: 1, docId: 'doc_1'),
        OrderEntity(orderId: 2, docId: 'doc_2'),
      ];
      final tResponse = NetworkSuccess<List<OrderEntity>>(tOrders);

      when(
        () => mockOrdersRepo.getOrders(),
      ).thenAnswer((_) => Stream.value(tResponse));

      // Act
      final result = getOrdersUseCase.call();

      // Assert
      await expectLater(result, emits(tResponse));

      verify(() => mockOrdersRepo.getOrders()).called(1);
    });
  });
}
