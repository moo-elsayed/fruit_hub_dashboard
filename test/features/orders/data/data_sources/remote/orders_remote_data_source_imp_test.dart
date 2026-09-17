import 'dart:async';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/helpers/backend_endpoints.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/orders/data/data_sources/remote/orders_remote_data_source_imp.dart';
import 'package:fruit_hub_dashboard/features/orders/data/models/order_model.dart';

void main() {
  group('OrdersRemoteDataSourceImp', () {
    late FakeFirebaseFirestore fakeFirestore;
    late OrdersRemoteDataSourceImp sut;

    Map<String, dynamic> createOrderMap({
      String uId = 'user_1',
      int orderId = 101,
      double totalPrice = 250.0,
      String status = 'pending',
      String paymentMethod = 'cash_on_delivery',
      String date = '2026-09-17T10:00:00Z',
    }) => {
      'uId': uId,
      'orderId': orderId,
      'totalPrice': totalPrice,
      'status': status,
      'paymentMethod': paymentMethod,
      'date': date,
      'shippingAddress': {
        'name': 'Ahmed Ali',
        'email': 'ahmed@example.com',
        'phone': '01012345678',
        'city': 'Cairo',
        'street': 'Tahrir St',
        'building_number': '10',
        'floor_number': '2',
        'apartment_number': '5',
      },
      'orderItems': [
        {
          'name': 'Apple',
          'code': 'APP123',
          'price': 50.0,
          'quantity': 2,
          'imageUrl': 'https://example.com/apple.png',
        },
      ],
    };

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      sut = OrdersRemoteDataSourceImp(firestore: fakeFirestore);
    });

    group('getOrders', () {
      test('should emit NetworkSuccess with an empty list when collection has no documents', () async {
        // Act
        final stream = sut.getOrders();

        // Assert
        await expectLater(
          stream,
          emits(
            predicate<NetworkResponse<List<OrderModel>>>((response) {
              if (response is! NetworkSuccess<List<OrderModel>>) return false;
              return response.data != null && response.data!.isEmpty;
            }),
          ),
        );
      });

      test('should emit NetworkSuccess with properly mapped OrderModel when documents exist', () async {
        // Arrange
        final orderData = createOrderMap(orderId: 101, uId: 'user_test');
        final docRef = await fakeFirestore
            .collection(BackendEndpoints.ordersCollection)
            .add(orderData);

        // Act
        final stream = sut.getOrders();

        // Assert
        await expectLater(
          stream,
          emits(
            predicate<NetworkResponse<List<OrderModel>>>((response) {
              if (response is! NetworkSuccess<List<OrderModel>>) return false;
              final orders = response.data;
              if (orders == null || orders.length != 1) return false;

              final order = orders.first;
              return order.docId == docRef.id &&
                  order.uId == 'user_test' &&
                  order.orderId == 101 &&
                  order.totalPrice == 250.0 &&
                  order.status == 'pending' &&
                  order.paymentMethod == 'cash_on_delivery' &&
                  order.date == '2026-09-17T10:00:00Z' &&
                  order.shippingAddress.name == 'Ahmed Ali' &&
                  order.shippingAddress.city == 'Cairo' &&
                  order.shippingAddress.streetName == 'Tahrir St' &&
                  order.orderItems.length == 1 &&
                  order.orderItems.first.name == 'Apple' &&
                  order.orderItems.first.price == 50.0 &&
                  order.orderItems.first.quantity == 2;
            }),
          ),
        );
      });

      test('should sort orders descending by date when all orders have non-empty dates', () async {
        // Arrange
        await fakeFirestore
            .collection(BackendEndpoints.ordersCollection)
            .add(createOrderMap(orderId: 1, date: '2026-09-10T00:00:00Z'));
        await fakeFirestore
            .collection(BackendEndpoints.ordersCollection)
            .add(createOrderMap(orderId: 2, date: '2026-09-17T00:00:00Z'));
        await fakeFirestore
            .collection(BackendEndpoints.ordersCollection)
            .add(createOrderMap(orderId: 3, date: '2026-09-13T00:00:00Z'));

        // Act
        final stream = sut.getOrders();

        // Assert
        await expectLater(
          stream,
          emits(
            predicate<NetworkResponse<List<OrderModel>>>((response) {
              if (response is! NetworkSuccess<List<OrderModel>>) return false;
              final orders = response.data!;
              return orders.length == 3 &&
                  orders[0].orderId == 2 &&
                  orders[1].orderId == 3 &&
                  orders[2].orderId == 1;
            }),
          ),
        );
      });

      test(
        'should fallback to sorting descending by orderId when dates are empty',
        () async {
          // Arrange
          await fakeFirestore
              .collection(BackendEndpoints.ordersCollection)
              .add(createOrderMap(orderId: 100, date: ''));
          await fakeFirestore
              .collection(BackendEndpoints.ordersCollection)
              .add(createOrderMap(orderId: 300, date: ''));
          await fakeFirestore
              .collection(BackendEndpoints.ordersCollection)
              .add(createOrderMap(orderId: 200, date: ''));

          // Act
          final stream = sut.getOrders();

          // Assert
          await expectLater(
            stream,
            emits(
              predicate<NetworkResponse<List<OrderModel>>>((response) {
                if (response is! NetworkSuccess<List<OrderModel>>) return false;
                final orders = response.data!;
                return orders.length == 3 &&
                    orders[0].orderId == 300 &&
                    orders[1].orderId == 200 &&
                    orders[2].orderId == 100;
              }),
            ),
          );
        },
      );

      test('should fallback to sorting descending by orderId when one order date is empty', () async {
        // Arrange
        await fakeFirestore
            .collection(BackendEndpoints.ordersCollection)
            .add(createOrderMap(orderId: 100, date: '2026-09-15T00:00:00Z'));
        await fakeFirestore
            .collection(BackendEndpoints.ordersCollection)
            .add(createOrderMap(orderId: 500, date: ''));

        // Act
        final stream = sut.getOrders();

        // Assert
        await expectLater(
          stream,
          emits(
            predicate<NetworkResponse<List<OrderModel>>>((response) {
              if (response is! NetworkSuccess<List<OrderModel>>) return false;
              final orders = response.data!;
              return orders.length == 2 &&
                  orders[0].orderId == 500 &&
                  orders[1].orderId == 100;
            }),
          ),
        );
      });

      test('should emit updated list when new order is added to Firestore in real-time', () async {
        // Arrange
        await fakeFirestore
            .collection(BackendEndpoints.ordersCollection)
            .add(createOrderMap(orderId: 101, date: '2026-09-10T00:00:00Z'));

        final completer = Completer<void>();
        final emissions = <NetworkResponse<List<OrderModel>>>[];

        final sub = sut.getOrders().listen((event) {
          emissions.add(event);
          if (emissions.length == 1) {
            fakeFirestore
                .collection(BackendEndpoints.ordersCollection)
                .add(
                  createOrderMap(orderId: 102, date: '2026-09-12T00:00:00Z'),
                );
          } else if (emissions.length == 2) {
            completer.complete();
          }
        });

        await completer.future;
        await sub.cancel();

        // Assert
        expect(emissions.length, 2);

        final firstBatch = emissions[0];
        expect(firstBatch, isA<NetworkSuccess<List<OrderModel>>>());
        expect(
          (firstBatch as NetworkSuccess<List<OrderModel>>).data!.length,
          1,
        );
        expect(firstBatch.data!.first.orderId, 101);

        final secondBatch = emissions[1];
        expect(secondBatch, isA<NetworkSuccess<List<OrderModel>>>());
        final secondList =
            (secondBatch as NetworkSuccess<List<OrderModel>>).data!;
        expect(secondList.length, 2);
        expect(secondList[0].orderId, 102);
        expect(secondList[1].orderId, 101);
      });

      test('should emit updated list when an existing order is updated in Firestore in real-time', () async {
        // Arrange
        final docRef = await fakeFirestore
            .collection(BackendEndpoints.ordersCollection)
            .add(createOrderMap(orderId: 101, status: 'pending'));

        final completer = Completer<void>();
        final emissions = <NetworkResponse<List<OrderModel>>>[];

        final sub = sut.getOrders().listen((event) {
          emissions.add(event);
          if (emissions.length == 1) {
            fakeFirestore
                .collection(BackendEndpoints.ordersCollection)
                .doc(docRef.id)
                .update({'status': 'delivered'});
          } else if (emissions.length == 2) {
            completer.complete();
          }
        });

        await completer.future;
        await sub.cancel();

        // Assert
        expect(emissions.length, 2);

        final firstOrders =
            (emissions[0] as NetworkSuccess<List<OrderModel>>).data!;
        expect(firstOrders.first.status, 'pending');

        final secondOrders =
            (emissions[1] as NetworkSuccess<List<OrderModel>>).data!;
        expect(secondOrders.first.status, 'delivered');
      });

      test('should handle orders with missing optional fields without throwing exception', () async {
        // Arrange - empty doc data
        final docRef = await fakeFirestore
            .collection(BackendEndpoints.ordersCollection)
            .add(<String, dynamic>{});

        // Act
        final stream = sut.getOrders();

        // Assert
        await expectLater(
          stream,
          emits(
            predicate<NetworkResponse<List<OrderModel>>>((res) {
              if (res is! NetworkSuccess<List<OrderModel>>) return false;
              final orders = res.data!;
              expect(orders.length, 1);
              expect(orders.first.docId, docRef.id);
              expect(orders.first.uId, '');
              expect(orders.first.orderId, 0);
              expect(orders.first.totalPrice, 0.0);
              expect(orders.first.status, '');
              expect(orders.first.paymentMethod, '');
              expect(orders.first.orderItems, isEmpty);
              expect(orders.first.date, '');
              return true;
            }),
          ),
        );
      });
    });

    group('updateOrderStatus', () {
      test('should successfully update order status in Firestore and return NetworkSuccess(null)', () async {
        // Arrange
        final docRef = await fakeFirestore
            .collection(BackendEndpoints.ordersCollection)
            .add(createOrderMap(status: 'pending'));

        // Act
        final result = await sut.updateOrderStatus(
          docRef.id,
          OrderStatus.delivered,
        );

        // Assert
        expect(result, isA<NetworkSuccess<void>>());

        final updatedDoc = await fakeFirestore
            .collection(BackendEndpoints.ordersCollection)
            .doc(docRef.id)
            .get();
        expect(updatedDoc.data()?['status'], 'delivered');
      });

      for (final status in OrderStatus.values) {
        test(
          'should update Firestore document status to "${status.databaseValue}" for OrderStatus.${status.name}',
          () async {
            // Arrange
            final docRef = await fakeFirestore
                .collection(BackendEndpoints.ordersCollection)
                .add(createOrderMap(status: 'initial'));

            // Act
            final result = await sut.updateOrderStatus(docRef.id, status);

            // Assert
            expect(result, isA<NetworkSuccess<void>>());

            final updatedDoc = await fakeFirestore
                .collection(BackendEndpoints.ordersCollection)
                .doc(docRef.id)
                .get();
            expect(updatedDoc.data()?['status'], status.databaseValue);
          },
        );
      }
    });
  });
}
