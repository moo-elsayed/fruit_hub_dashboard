import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/helpers/backend_endpoints.dart';
import 'package:fruit_hub_dashboard/core/helpers/extentions.dart';
import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/core/services/database/database_service.dart';
import 'package:fruit_hub_dashboard/features/orders/data/data_sources/remote/orders_remote_data_source_imp.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockDatabaseService extends Mock implements DatabaseService {}

void main() {
  late OrdersRemoteDataSourceImp sut;
  late MockDatabaseService mockDatabaseService;

  setUp(() {
    mockDatabaseService = .new();
    sut = .new(mockDatabaseService);
  });

  group('OrdersRemoteDataSourceImp', () {
    group('getOrders', () {
      final tRawData = [
        {
          'uId': 'user_1',
          'docId': 'doc_1',
          'orderId': 101,
          'totalPrice': 150.0,
          'status': 'Pending',
          'paymentMethod': 'cash_on_delivery',
          'shippingAddress': {
            'street': '123 Main St',
            'city': 'Cairo',
            'state': 'Cairo Governorate',
            'zipCode': '12345',
            'country': 'Egypt',
          },
          'orderItems': [
            {
              'productId': 'prod_1',
              'name': 'Apple',
              'price': 30.0,
              'quantity': 2,
              'imageUrl': 'https://example.com/apple.jpg',
            },
            {
              'productId': 'prod_2',
              'name': 'Banana',
              'price': 20.0,
              'quantity': 3,
              'imageUrl': 'https://example.com/banana.jpg',
            },
          ],
          'date': '2024-04-01T10:00:00Z',
        },
        {
          'uId': 'user_2',
          'docId': 'doc_2',
          'orderId': 102,
          'totalPrice': 200.0,
          'status': 'Delivered',
          'paymentMethod': 'credit_card',
          'shippingAddress': {
            'street': '456 Nile Ave',
            'city': 'Giza',
            'state': 'Giza Governorate',
            'zipCode': '54321',
            'country': 'Egypt',
          },
          'orderItems': [
            {
              'productId': 'prod_3',
              'name': 'Orange',
              'price': 50.0,
              'quantity': 2,
              'imageUrl': 'https://example.com/orange.jpg',
            },
            {
              'productId': 'prod_4',
              'name': 'Grapes',
              'price': 25.0,
              'quantity': 4,
              'imageUrl': 'https://example.com/grapes.jpg',
            },
          ],
          'date': '2024-04-02T14:30:00Z',
        },
        {
          'uId': 'user_3',
          'docId': 'doc_3',
          'orderId': 103,
          'totalPrice': 120.0,
          'status': 'Cancelled',
          'paymentMethod': 'paypal',
          'shippingAddress': {
            'street': '789 Pyramids Rd',
            'city': 'Alexandria',
            'state': 'Alexandria Governorate',
            'zipCode': '67890',
            'country': 'Egypt',
          },
          'orderItems': [
            {
              'productId': 'prod_5',
              'name': 'Mango',
              'price': 60.0,
              'quantity': 2,
              'imageUrl': 'https://example.com/mango.jpg',
            },
          ],
          'date': '2024-04-03T09:15:00Z',
        },
      ];
      test(
        'should emit [NetworkSuccess] with List<OrderEntity> when stream emits data',
        () {
          // Arrange
          when(
            () => mockDatabaseService.streamAllData(
              path: BackendEndpoints.streamOrders,
              includeDocId: true,
            ),
          ).thenAnswer((_) => Stream.value(tRawData));
          // Act
          final stream = sut.getOrders();
          // Assert
          expect(
            stream,
            emitsInOrder([
              isA<NetworkSuccess<List<OrderEntity>>>()
                  .having((state) => state.data!.first.docId, 'docId', 'doc_1')
                  .having((state) => state.data!.length, 'length', 3),
            ]),
          );
        },
      );
      test('should emit [NetworkFailure] when stream throws an exception', () {
        // Arrange
        when(
          () => mockDatabaseService.streamAllData(
            path: BackendEndpoints.streamOrders,
            includeDocId: true,
          ),
        ).thenAnswer((_) => Stream.error(Exception('Database Error')));
        // Act
        final stream = sut.getOrders();
        // Assert
        expect(
          stream,
          emitsInOrder([
            isA<NetworkFailure<List<OrderEntity>>>().having(
              (state) => state.exception.toString(),
              'message',
              contains('Database Error'),
            ),
          ]),
        );
      });
    });
    group('updateOrderStatus', () {
      const tDocId = 'doc_123';
      const tStatus = OrderStatus.shipped;
      test(
        'should emit [NetworkSuccess] when updateOrderStatus is successful',
        () async {
          // Arrange
          when(
            () => mockDatabaseService.updateData(
              path: BackendEndpoints.updateOrderStatus,
              documentId: tDocId,
              data: any(named: 'data'),
            ),
          ).thenAnswer((_) async {});
          // Act
          final result = await sut.updateOrderStatus(tDocId, tStatus);
          // Assert
          expect(result, isA<NetworkSuccess<void>>());
          verify(
            () => mockDatabaseService.updateData(
              path: BackendEndpoints.updateOrderStatus,
              documentId: tDocId,
              data: {'status': tStatus.getName},
            ),
          ).called(1);
        },
      );
      test(
        'should emit [NetworkFailure] when updateOrderStatus throws an exception',
        () async {
          // Arrange
          when(
            () => mockDatabaseService.updateData(
              path: BackendEndpoints.updateOrderStatus,
              documentId: tDocId,
              data: any(named: 'data'),
            ),
          ).thenThrow(Exception('Database Error'));
          // Act
          final result = await sut.updateOrderStatus(tDocId, tStatus);
          // Assert
          expect(result, isA<NetworkFailure<void>>());
        },
      );
    });
  });
}
