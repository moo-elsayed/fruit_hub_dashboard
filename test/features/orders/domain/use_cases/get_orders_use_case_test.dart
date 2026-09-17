import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/repo/orders_repo.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/use_cases/get_orders_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockOrdersRepo extends Mock implements OrdersRepo {}

void main() {
  late MockOrdersRepo mockOrdersRepo;
  late GetOrdersUseCase sut;

  const tOrders = [
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
  ];

  const tFailure = ServerFailure(error: 'Failed to fetch orders');

  setUp(() {
    mockOrdersRepo = MockOrdersRepo();
    sut = GetOrdersUseCase(mockOrdersRepo);
  });

  group('GetOrdersUseCase', () {
    test('should emit NetworkSuccess with orders list when repo emits NetworkSuccess', () async {
      // Arrange
      when(() => mockOrdersRepo.getOrders())
          .thenAnswer((_) => Stream.value(const NetworkSuccess(tOrders)));

      // Act
      final stream = sut();

      // Assert
      await expectLater(
        stream,
        emits(
          predicate<NetworkResponse<List<OrderEntity>>>(
            (response) =>
                response is NetworkSuccess<List<OrderEntity>> &&
                response.data == tOrders,
          ),
        ),
      );
      verify(() => mockOrdersRepo.getOrders()).called(1);
      verifyNoMoreInteractions(mockOrdersRepo);
    });

    test('should emit NetworkFailure when repo emits NetworkFailure', () async {
      // Arrange
      when(() => mockOrdersRepo.getOrders())
          .thenAnswer((_) => Stream.value(const NetworkFailure(tFailure)));

      // Act
      final stream = sut();

      // Assert
      await expectLater(
        stream,
        emits(
          predicate<NetworkResponse<List<OrderEntity>>>(
            (response) =>
                response is NetworkFailure<List<OrderEntity>> &&
                response.failure == tFailure,
          ),
        ),
      );
      verify(() => mockOrdersRepo.getOrders()).called(1);
      verifyNoMoreInteractions(mockOrdersRepo);
    });

    test(
      'should emit stream events in sequential order as received from repo',
      () async {
        // Arrange
        when(() => mockOrdersRepo.getOrders()).thenAnswer(
          (_) => Stream.fromIterable([
            const NetworkSuccess(<OrderEntity>[]),
            const NetworkSuccess(tOrders),
            const NetworkFailure<List<OrderEntity>>(tFailure),
          ]),
        );

        // Act
        final stream = sut();

        // Assert
        await expectLater(
          stream,
          emitsInOrder([
            predicate<NetworkResponse<List<OrderEntity>>>(
              (res) =>
                  res is NetworkSuccess<List<OrderEntity>> &&
                  res.data != null &&
                  res.data!.isEmpty,
            ),
            predicate<NetworkResponse<List<OrderEntity>>>(
              (res) =>
                  res is NetworkSuccess<List<OrderEntity>> &&
                  res.data == tOrders,
            ),
            predicate<NetworkResponse<List<OrderEntity>>>(
              (res) =>
                  res is NetworkFailure<List<OrderEntity>> &&
                  res.failure == tFailure,
            ),
          ]),
        );
        verify(() => mockOrdersRepo.getOrders()).called(1);
        verifyNoMoreInteractions(mockOrdersRepo);
      },
    );
  });
}
