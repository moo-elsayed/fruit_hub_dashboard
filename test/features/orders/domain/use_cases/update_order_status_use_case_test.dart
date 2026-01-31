import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/repo/orders_repo.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/use_cases/update_order_status_use_case.dart';
import 'package:mocktail/mocktail.dart';

// 1. Mock Repository
class MockOrdersRepo extends Mock implements OrdersRepo {}

void main() {
  late MockOrdersRepo mockOrdersRepo;
  late UpdateOrderStatusUseCase updateOrderStatusUseCase;

  setUpAll(() {
    registerFallbackValue(OrderStatus.pending);
  });

  setUp(() {
    mockOrdersRepo = MockOrdersRepo();
    updateOrderStatusUseCase = UpdateOrderStatusUseCase(mockOrdersRepo);
  });

  // ==========================================
  // Test UpdateOrderStatusUseCase
  // ==========================================
  group('UpdateOrderStatusUseCase', () {
    test('should call repository with correct parameters', () async {
      // Arrange
      const tDocId = 'doc_123';
      const tStatus = OrderStatus.shipped;
      const tResponse = NetworkSuccess<void>();

      when(
        () => mockOrdersRepo.updateOrderStatus(any(), any()),
      ).thenAnswer((_) async => tResponse);

      // Act
      final result = await updateOrderStatusUseCase.call(tDocId, tStatus);

      // Assert
      expect(result, tResponse);

      verify(() => mockOrdersRepo.updateOrderStatus(tDocId, tStatus)).called(1);
    });
  });
}
