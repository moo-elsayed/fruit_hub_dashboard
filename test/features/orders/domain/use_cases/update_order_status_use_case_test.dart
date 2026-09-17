import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/repo/orders_repo.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/use_cases/update_order_status_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockOrdersRepo extends Mock implements OrdersRepo {}

void main() {
  late MockOrdersRepo mockOrdersRepo;
  late UpdateOrderStatusUseCase sut;

  const tDocId = 'order_doc_123';
  const tFailure = ServerFailure(error: 'Failed to update order status');

  setUp(() {
    mockOrdersRepo = MockOrdersRepo();
    sut = UpdateOrderStatusUseCase(mockOrdersRepo);
  });

  group('UpdateOrderStatusUseCase', () {
    for (final status in OrderStatus.values) {
      test(
        'should pass OrderStatus.${status.name} correctly to OrdersRepo',
        () async {
          // Arrange
          when(() => mockOrdersRepo.updateOrderStatus(tDocId, status))
              .thenAnswer((_) async => const NetworkSuccess(null));

          // Act
          final result = await sut(tDocId, status);

          // Assert
          expect(result, isA<NetworkSuccess<void>>());
          verify(() => mockOrdersRepo.updateOrderStatus(tDocId, status))
              .called(1);
          verifyNoMoreInteractions(mockOrdersRepo);
        },
      );
    }

    test(
      'should return NetworkFailure when OrdersRepo returns NetworkFailure',
      () async {
        // Arrange
        when(
          () => mockOrdersRepo.updateOrderStatus(tDocId, OrderStatus.cancelled),
        ).thenAnswer((_) async => const NetworkFailure(tFailure));

        // Act
        final result = await sut(tDocId, OrderStatus.cancelled);

        // Assert
        expect(result, isA<NetworkFailure<void>>());
        final failure = (result as NetworkFailure<void>).failure;
        expect(failure, tFailure);
        verify(
          () => mockOrdersRepo.updateOrderStatus(tDocId, OrderStatus.cancelled),
        ).called(1);
        verifyNoMoreInteractions(mockOrdersRepo);
      },
    );
  });
}
