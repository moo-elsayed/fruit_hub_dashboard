import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/orders/data/data_sources/remote/orders_remote_data_source.dart';
import 'package:fruit_hub_dashboard/features/orders/data/models/address_model.dart';
import 'package:fruit_hub_dashboard/features/orders/data/models/order_item_model.dart';
import 'package:fruit_hub_dashboard/features/orders/data/models/order_model.dart';
import 'package:fruit_hub_dashboard/features/orders/data/repo_imp/orders_repo_imp.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockOrdersRemoteDataSources extends Mock
    implements OrdersRemoteDataSources {}

void main() {
  late MockOrdersRemoteDataSources mockRemoteDataSource;
  late OrdersRepoImp sut;

  const tDocId = 'order_doc_123';
  const tFailure = ServerFailure(error: 'Network connection error');

  final tAddressModel = AddressModel(
    name: 'Ahmed Ali',
    email: 'ahmed@example.com',
    phone: '01012345678',
    city: 'Cairo',
    buildingNumber: '10',
    streetName: 'Tahrir St',
    floorNumber: '2',
    apartmentNumber: '5',
  );

  final tOrderItemModel = OrderItemModel(
    name: 'Apple',
    code: 'APP123',
    price: 50.0,
    quantity: 2,
    imagePath: 'https://example.com/apple.png',
  );

  final tOrderModel1 = OrderModel(
    uId: 'user_1',
    docId: 'doc_1',
    orderId: 101,
    totalPrice: 100.0,
    status: 'pending',
    paymentMethod: 'cash_on_delivery',
    shippingAddress: tAddressModel,
    orderItems: [tOrderItemModel],
    date: '2026-09-17T10:00:00Z',
  );

  final tOrderModel2 = OrderModel(
    uId: 'user_2',
    docId: 'doc_2',
    orderId: 102,
    totalPrice: 200.0,
    status: 'shipped',
    paymentMethod: 'credit_card',
    shippingAddress: tAddressModel,
    orderItems: [tOrderItemModel],
    date: '2026-09-17T11:00:00Z',
  );

  setUp(() {
    mockRemoteDataSource = MockOrdersRemoteDataSources();
    sut = OrdersRepoImp(mockRemoteDataSource);
  });

  group('OrdersRepoImp', () {
    group('getOrders', () {
      test('should emit NetworkSuccess with empty list when remote data source emits empty list', () async {
        // Arrange
        when(() => mockRemoteDataSource.getOrders())
            .thenAnswer((_) => Stream.value(const NetworkSuccess([])));

        // Act
        final stream = sut.getOrders();

        // Assert
        await expectLater(
          stream,
          emits(
            predicate<NetworkResponse<List<OrderEntity>>>((response) {
              if (response is! NetworkSuccess<List<OrderEntity>>) return false;
              return response.data != null && response.data!.isEmpty;
            }),
          ),
        );
        verify(() => mockRemoteDataSource.getOrders()).called(1);
      });

      test('should map OrderModels to OrderEntities and emit NetworkSuccess when remote data source emits models', () async {
        // Arrange
        final models = [tOrderModel1, tOrderModel2];
        final expectedEntities = models.map((m) => m.toEntity()).toList();

        when(() => mockRemoteDataSource.getOrders())
            .thenAnswer((_) => Stream.value(NetworkSuccess(models)));

        // Act
        final stream = sut.getOrders();

        // Assert
        await expectLater(
          stream,
          emits(
            predicate<NetworkResponse<List<OrderEntity>>>((response) {
              if (response is! NetworkSuccess<List<OrderEntity>>) return false;
              final data = response.data;
              if (data == null || data.length != 2) return false;
              return data[0] == expectedEntities[0] &&
                  data[1] == expectedEntities[1];
            }),
          ),
        );
        verify(() => mockRemoteDataSource.getOrders()).called(1);
      });

      test('should emit NetworkSuccess with null data when remote data source emits NetworkSuccess with null data', () async {
        // Arrange
        when(() => mockRemoteDataSource.getOrders())
            .thenAnswer((_) => Stream.value(const NetworkSuccess(null)));

        // Act
        final stream = sut.getOrders();

        // Assert
        await expectLater(
          stream,
          emits(
            predicate<NetworkResponse<List<OrderEntity>>>((response) {
              if (response is! NetworkSuccess<List<OrderEntity>>) return false;
              return response.data == null;
            }),
          ),
        );
        verify(() => mockRemoteDataSource.getOrders()).called(1);
      });

      test('should emit NetworkFailure when remote data source emits NetworkFailure', () async {
        // Arrange
        when(() => mockRemoteDataSource.getOrders())
            .thenAnswer((_) => Stream.value(const NetworkFailure(tFailure)));

        // Act
        final stream = sut.getOrders();

        // Assert
        await expectLater(
          stream,
          emits(
            predicate<NetworkResponse<List<OrderEntity>>>((response) {
              if (response is! NetworkFailure<List<OrderEntity>>) return false;
              return response.failure == tFailure;
            }),
          ),
        );
        verify(() => mockRemoteDataSource.getOrders()).called(1);
      });

      test('should emit multiple sequential responses as they arrive from remote data source stream', () async {
        // Arrange
        final batch1 = [tOrderModel1];
        final batch2 = [tOrderModel1, tOrderModel2];

        when(() => mockRemoteDataSource.getOrders()).thenAnswer(
          (_) => Stream.fromIterable([
            NetworkSuccess(batch1),
            NetworkSuccess(batch2),
            const NetworkFailure<List<OrderModel>>(tFailure),
          ]),
        );

        // Act
        final stream = sut.getOrders();

        // Assert
        await expectLater(
          stream,
          emitsInOrder([
            predicate<NetworkResponse<List<OrderEntity>>>(
              (res) =>
                  res is NetworkSuccess<List<OrderEntity>> &&
                  res.data?.length == 1 &&
                  res.data?.first == tOrderModel1.toEntity(),
            ),
            predicate<NetworkResponse<List<OrderEntity>>>(
              (res) =>
                  res is NetworkSuccess<List<OrderEntity>> &&
                  res.data?.length == 2,
            ),
            predicate<NetworkResponse<List<OrderEntity>>>(
              (res) =>
                  res is NetworkFailure<List<OrderEntity>> &&
                  res.failure == tFailure,
            ),
          ]),
        );
        verify(() => mockRemoteDataSource.getOrders()).called(1);
      });
    });

    group('updateOrderStatus', () {
      test('should forward call to remote data source and return NetworkSuccess(null) on success', () async {
        // Arrange
        when(
          () => mockRemoteDataSource.updateOrderStatus(
            tDocId,
            OrderStatus.delivered,
          ),
        ).thenAnswer((_) async => const NetworkSuccess(null));

        // Act
        final result = await sut.updateOrderStatus(
          tDocId,
          OrderStatus.delivered,
        );

        // Assert
        expect(result, isA<NetworkSuccess<void>>());
        verify(
          () => mockRemoteDataSource.updateOrderStatus(
            tDocId,
            OrderStatus.delivered,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      });

      for (final status in OrderStatus.values) {
        test(
          'should pass OrderStatus.${status.name} to remote data source correctly',
          () async {
            // Arrange
            when(() => mockRemoteDataSource.updateOrderStatus(tDocId, status))
                .thenAnswer((_) async => const NetworkSuccess(null));

            // Act
            final result = await sut.updateOrderStatus(tDocId, status);

            // Assert
            expect(result, isA<NetworkSuccess<void>>());
            verify(() => mockRemoteDataSource.updateOrderStatus(tDocId, status))
                .called(1);
          },
        );
      }

      test('should return NetworkFailure when remote data source returns NetworkFailure', () async {
        // Arrange
        when(
          () => mockRemoteDataSource.updateOrderStatus(
            tDocId,
            OrderStatus.cancelled,
          ),
        ).thenAnswer((_) async => const NetworkFailure(tFailure));

        // Act
        final result = await sut.updateOrderStatus(
          tDocId,
          OrderStatus.cancelled,
        );

        // Assert
        expect(result, isA<NetworkFailure<void>>());
        final failure = (result as NetworkFailure<void>).failure;
        expect(failure, tFailure);
        verify(
          () => mockRemoteDataSource.updateOrderStatus(
            tDocId,
            OrderStatus.cancelled,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      });
    });
  });
}
