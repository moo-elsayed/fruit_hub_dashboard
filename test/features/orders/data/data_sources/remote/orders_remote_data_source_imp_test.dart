import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/order_search_by.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/enums/payment_methods.dart';
import 'package:fruit_hub_dashboard/core/helpers/backend_endpoints.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/orders/data/data_sources/remote/orders_remote_data_source_imp.dart';
import 'package:fruit_hub_dashboard/features/orders/data/models/address_model.dart';
import 'package:fruit_hub_dashboard/features/orders/data/models/order_item_model.dart';
import 'package:fruit_hub_dashboard/features/orders/data/models/order_model.dart';
import 'package:fruit_hub_dashboard/features/orders/data/models/orders_page_model.dart';
import 'package:fruit_hub_dashboard/features/orders/data/models/orders_stats_model.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';

void main() {
  group('OrdersRemoteDataSourceImp', () {
    late FakeFirebaseFirestore fakeFirestore;
    late OrdersRemoteDataSourceImp sut;

    const ordersCollection = BackendEndpoints.ordersCollection;

    Map<String, dynamic> createOrderMap({
      String uId = 'user_1',
      int orderId = 101,
      double totalPrice = 250.0,
      String status = 'pending',
      String paymentMethod = 'cash_on_delivery',
      String date = '2026-09-17T10:00:00Z',
      String customerName = 'Ahmed Ali',
      String phone = '01012345678',
    }) => {
      'uId': uId,
      'orderId': orderId,
      'totalPrice': totalPrice,
      'status': status,
      'paymentMethod': paymentMethod,
      'date': date,
      'shippingAddress': {
        'name': customerName,
        'email': 'ahmed@example.com',
        'phone': phone,
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
      test(
        'should return NetworkSuccess with an empty page when collection has no documents',
        () async {
          // Act
          final result = await sut.getOrders();

          // Assert
          expect(result, isA<NetworkSuccess<OrdersPageModel>>());
          final page = (result as NetworkSuccess<OrdersPageModel>).data;
          expect(page?.orders, isEmpty);
          expect(page?.hasMore, isFalse);
          expect(page?.lastDocument, isNull);
        },
      );

      test(
        'should return paginated orders with hasMore true when documents are greater than limit',
        () async {
          // Arrange
          for (int i = 1; i <= 3; i++) {
            await fakeFirestore
                .collection(ordersCollection)
                .doc('doc_$i')
                .set(createOrderMap(orderId: 100 + i));
          }

          // Act
          final result = await sut.getOrders(limit: 2);

          // Assert
          expect(result, isA<NetworkSuccess<OrdersPageModel>>());
          final page = (result as NetworkSuccess<OrdersPageModel>).data;
          expect(page?.orders.length, 2);
          expect(page?.hasMore, isTrue);
          expect(page?.lastDocument, isNotNull);
        },
      );

      test(
        'should return next page of orders when lastDocument is provided',
        () async {
          // Arrange
          for (int i = 1; i <= 3; i++) {
            await fakeFirestore
                .collection(ordersCollection)
                .doc('doc_$i')
                .set(createOrderMap(orderId: 100 + i));
          }

          // Act - fetch first page
          final firstResult = await sut.getOrders(limit: 2);
          final firstPage = (firstResult as NetworkSuccess<OrdersPageModel>).data;
          final lastDoc = firstPage?.lastDocument;

          // Act - fetch second page
          final secondResult = await sut.getOrders(limit: 2, lastDocument: lastDoc);

          // Assert
          expect(secondResult, isA<NetworkSuccess<OrdersPageModel>>());
          final secondPage = (secondResult as NetworkSuccess<OrdersPageModel>).data;
          expect(secondPage?.orders.length, 1);
          expect(secondPage?.orders.first.orderId, 103);
          expect(secondPage?.hasMore, isFalse);
        },
      );

      test('should filter orders by status in Firestore', () async {
        // Arrange
        await fakeFirestore
            .collection(ordersCollection)
            .doc('doc_1')
            .set(createOrderMap(orderId: 101, status: 'pending'));
        await fakeFirestore
            .collection(ordersCollection)
            .doc('doc_2')
            .set(createOrderMap(orderId: 102, status: 'delivered'));

        // Act
        final result = await sut.getOrders(status: OrderStatus.delivered);

        // Assert
        expect(result, isA<NetworkSuccess<OrdersPageModel>>());
        final page = (result as NetworkSuccess<OrdersPageModel>).data;
        expect(page?.orders.length, 1);
        expect(page?.orders.first.orderId, 102);
      });

      test('should assign doc.id to docId on OrderModel', () async {
        // Arrange
        await fakeFirestore
            .collection(ordersCollection)
            .doc('order_special_doc_id')
            .set(createOrderMap(orderId: 555));

        // Act
        final result = await sut.getOrders();

        // Assert
        expect(result, isA<NetworkSuccess<OrdersPageModel>>());
        final page = (result as NetworkSuccess<OrdersPageModel>).data;
        expect(page?.orders.first.docId, 'order_special_doc_id');
      });
    });

    group('getOrdersStats', () {
      test('should return zeros for all counts when collection is empty', () async {
        // Act
        final result = await sut.getOrdersStats();

        // Assert
        expect(result, isA<NetworkSuccess<OrdersStatsModel>>());
        final stats = (result as NetworkSuccess<OrdersStatsModel>).data;
        expect(stats?.totalCount, 0);
        expect(stats?.pendingCount, 0);
        expect(stats?.processingCount, 0);
        expect(stats?.shippedCount, 0);
        expect(stats?.deliveredCount, 0);
        expect(stats?.cancelledCount, 0);
      });

      test('should return correct counts aggregated by status', () async {
        // Arrange
        await fakeFirestore
            .collection(ordersCollection)
            .doc('doc_1')
            .set(createOrderMap(status: 'pending'));
        await fakeFirestore
            .collection(ordersCollection)
            .doc('doc_2')
            .set(createOrderMap(status: 'pending'));
        await fakeFirestore
            .collection(ordersCollection)
            .doc('doc_3')
            .set(createOrderMap(status: 'processing'));
        await fakeFirestore
            .collection(ordersCollection)
            .doc('doc_4')
            .set(createOrderMap(status: 'shipped'));
        await fakeFirestore
            .collection(ordersCollection)
            .doc('doc_5')
            .set(createOrderMap(status: 'delivered'));
        await fakeFirestore
            .collection(ordersCollection)
            .doc('doc_6')
            .set(createOrderMap(status: 'cancelled'));

        // Act
        final result = await sut.getOrdersStats();

        // Assert
        expect(result, isA<NetworkSuccess<OrdersStatsModel>>());
        final stats = (result as NetworkSuccess<OrdersStatsModel>).data;
        expect(stats?.totalCount, 6);
        expect(stats?.pendingCount, 2);
        expect(stats?.processingCount, 1);
        expect(stats?.shippedCount, 1);
        expect(stats?.deliveredCount, 1);
        expect(stats?.cancelledCount, 1);
      });
    });

    group('searchOrders', () {
      test('should return empty list when query is empty string', () async {
        // Act
        final result = await sut.searchOrders(
          query: '',
          searchBy: OrderSearchBy.orderId,
        );

        // Assert
        expect(result, isA<NetworkSuccess<List<OrderModel>>>());
        expect((result as NetworkSuccess<List<OrderModel>>).data, isEmpty);
      });

      test('should return empty list when query is whitespace only', () async {
        // Act
        final result = await sut.searchOrders(
          query: '   ',
          searchBy: OrderSearchBy.orderId,
        );

        // Assert
        expect(result, isA<NetworkSuccess<List<OrderModel>>>());
        expect((result as NetworkSuccess<List<OrderModel>>).data, isEmpty);
      });

      test('should return orders matching orderId with integer query', () async {
        // Arrange
        await fakeFirestore
            .collection(ordersCollection)
            .doc('doc_1')
            .set(createOrderMap(orderId: 9001));
        await fakeFirestore
            .collection(ordersCollection)
            .doc('doc_2')
            .set(createOrderMap(orderId: 9002));

        // Act
        final result = await sut.searchOrders(
          query: '9001',
          searchBy: OrderSearchBy.orderId,
        );

        // Assert
        expect(result, isA<NetworkSuccess<List<OrderModel>>>());
        final orders = (result as NetworkSuccess<List<OrderModel>>).data;
        expect(orders?.length, 1);
        expect(orders?.first.orderId, 9001);
      });

      test('should return orders matching orderId when query includes # prefix', () async {
        // Arrange
        await fakeFirestore
            .collection(ordersCollection)
            .doc('doc_1')
            .set(createOrderMap(orderId: 9001));

        // Act
        final result = await sut.searchOrders(
          query: '#9001',
          searchBy: OrderSearchBy.orderId,
        );

        // Assert
        expect(result, isA<NetworkSuccess<List<OrderModel>>>());
        final orders = (result as NetworkSuccess<List<OrderModel>>).data;
        expect(orders?.length, 1);
        expect(orders?.first.orderId, 9001);
      });

      test('should return empty list when orderId query is not a valid number', () async {
        // Act
        final result = await sut.searchOrders(
          query: 'not_a_number',
          searchBy: OrderSearchBy.orderId,
        );

        // Assert
        expect(result, isA<NetworkSuccess<List<OrderModel>>>());
        expect((result as NetworkSuccess<List<OrderModel>>).data, isEmpty);
      });

      test('should return orders matching customerName prefix', () async {
        // Arrange
        await fakeFirestore
            .collection(ordersCollection)
            .doc('doc_1')
            .set(createOrderMap(orderId: 9001, customerName: 'Ahmed Ali'));
        await fakeFirestore
            .collection(ordersCollection)
            .doc('doc_2')
            .set(createOrderMap(orderId: 9002, customerName: 'Mohamed Sayed'));

        // Act
        final result = await sut.searchOrders(
          query: 'Ahmed',
          searchBy: OrderSearchBy.customerName,
        );

        // Assert
        expect(result, isA<NetworkSuccess<List<OrderModel>>>());
        final orders = (result as NetworkSuccess<List<OrderModel>>).data;
        expect(orders, isNotNull);
        expect(orders!.length, 1);
        expect(orders.first.shippingAddress.name, 'Ahmed Ali');
      });

      test('should return orders matching phone prefix', () async {
        // Arrange
        await fakeFirestore
            .collection(ordersCollection)
            .doc('doc_1')
            .set(createOrderMap(orderId: 9001, phone: '01012345678'));
        await fakeFirestore
            .collection(ordersCollection)
            .doc('doc_2')
            .set(createOrderMap(orderId: 9002, phone: '01298765432'));

        // Act
        final result = await sut.searchOrders(
          query: '010',
          searchBy: OrderSearchBy.phone,
        );

        // Assert
        expect(result, isA<NetworkSuccess<List<OrderModel>>>());
        final orders = (result as NetworkSuccess<List<OrderModel>>).data;
        expect(orders, isNotNull);
        expect(orders!.length, 1);
        expect(orders.first.shippingAddress.phone, '01012345678');
      });
    });

    group('updateOrderStatus', () {
      test('should successfully update status and preserve existing fields', () async {
        // Arrange
        await fakeFirestore
            .collection(ordersCollection)
            .doc('doc_1')
            .set(createOrderMap(status: 'pending', customerName: 'Ahmed Ali'));

        // Act
        final result = await sut.updateOrderStatus('doc_1', OrderStatus.delivered);

        // Assert
        expect(result, isA<NetworkSuccess<void>>());
        final doc = await fakeFirestore.collection(ordersCollection).doc('doc_1').get();
        expect(doc.data()?['status'], 'delivered');
        expect(doc.data()?['uId'], 'user_1');
        final address = doc.data()?['shippingAddress'] as Map<String, dynamic>?;
        expect(address?['name'], 'Ahmed Ali');
      });
    });

    group('Model and Entity Mappings', () {
      test('OrderModel.toEntity should accurately map all properties and calculate subtotal', () {
        // Arrange
        final addressModel = AddressModel(
          name: 'Ahmed Ali',
          email: 'ahmed@test.com',
          phone: '01012345678',
          city: 'Cairo',
          buildingNumber: '10',
          streetName: 'Tahrir St',
          floorNumber: '2',
          apartmentNumber: '5',
        );

        final item1 = OrderItemModel(
          code: 'APP',
          name: 'Apple',
          imagePath: 'https://img.com/apple.png',
          price: 40.0,
          quantity: 2,
        );

        final item2 = OrderItemModel(
          code: 'BAN',
          name: 'Banana',
          imagePath: 'https://img.com/banana.png',
          price: 20.0,
          quantity: 1,
        );

        final orderModel = OrderModel(
          uId: 'uid_1',
          docId: 'doc_1',
          orderId: 777,
          totalPrice: 130.0, // Subtotal = (40*2) + (20*1) = 100. Shipping = 30.
          status: 'shipped',
          paymentMethod: 'cash_on_delivery',
          shippingAddress: addressModel,
          orderItems: [item1, item2],
          date: '2026-09-17T10:00:00Z',
        );

        // Act
        final entity = orderModel.toEntity();

        // Assert
        expect(entity.uid, 'uid_1');
        expect(entity.docId, 'doc_1');
        expect(entity.orderId, 777);
        expect(entity.totalPrice, 130.0);
        expect(entity.status, OrderStatus.shipped);
        expect(entity.date, '2026-09-17T10:00:00Z');
        expect(entity.address.name, 'Ahmed Ali');
        expect(entity.address.city, 'Cairo');
        expect(entity.products.length, 2);
        expect(entity.paymentOption.type, PaymentMethodType.cash);
        expect(entity.paymentOption.shippingCost, 30.0);
      });

      test('OrderModel.toEntity should map credit_card and paypal payment methods correctly', () {
        // Arrange
        final emptyAddress = AddressModel(
          name: '',
          email: '',
          phone: '',
          city: '',
          buildingNumber: '',
          streetName: '',
          floorNumber: '',
          apartmentNumber: '',
        );

        final cardOrder = OrderModel(
          uId: 'u1',
          docId: 'd1',
          orderId: 1,
          totalPrice: 50.0,
          status: 'pending',
          paymentMethod: 'credit_card',
          shippingAddress: emptyAddress,
          orderItems: [],
          date: '',
        );

        final paypalOrder = OrderModel(
          uId: 'u2',
          docId: 'd2',
          orderId: 2,
          totalPrice: 50.0,
          status: 'processing',
          paymentMethod: 'paypal',
          shippingAddress: emptyAddress,
          orderItems: [],
          date: '',
        );

        // Act & Assert
        expect(cardOrder.toEntity().paymentOption.type, PaymentMethodType.card);
        expect(paypalOrder.toEntity().paymentOption.type, PaymentMethodType.paypal);
      });

      test('OrderModel.fromJson should handle numeric coercion and default fallbacks for missing fields', () {
        // Arrange - int totalPrice and num orderId, missing address/items
        final json = <String, dynamic>{
          'uId': 'u_fallback',
          'docId': 'd_fallback',
          'orderId': 999,
          'totalPrice': 100, // int instead of double
          'status': 'cancelled',
          'paymentMethod': 'cash_on_delivery',
          'date': '2026-10-01',
        };

        // Act
        final model = OrderModel.fromJson(json);

        // Assert
        expect(model.uId, 'u_fallback');
        expect(model.docId, 'd_fallback');
        expect(model.orderId, 999);
        expect(model.totalPrice, 100.0);
        expect(model.status, 'cancelled');
        expect(model.shippingAddress.name, isEmpty);
        expect(model.orderItems, isEmpty);
      });

      test('OrderModel.fromFirestore should attach docId correctly', () {
        // Arrange
        final map = <String, dynamic>{
          'uId': 'u1',
          'orderId': 123,
          'totalPrice': 50.0,
          'status': 'pending',
          'paymentMethod': 'cash',
          'date': '2026-09-17',
        };

        // Act
        final model = OrderModel.fromFirestore(map, 'firestore_doc_id_456');

        // Assert
        expect(model.docId, 'firestore_doc_id_456');
        expect(model.orderId, 123);
      });

      test('OrderEntity.copyWith should accurately copy modified properties and retain others', () {
        // Arrange
        const original = OrderEntity(
          uid: 'u_orig',
          docId: 'd_orig',
          orderId: 100,
          totalPrice: 150.0,
          date: '2026-09-17',
          status: OrderStatus.pending,
        );

        // Act
        final copied = original.copyWith(
          status: OrderStatus.delivered,
          totalPrice: 200.0,
        );

        // Assert
        expect(copied.uid, 'u_orig');
        expect(copied.docId, 'd_orig');
        expect(copied.orderId, 100);
        expect(copied.totalPrice, 200.0);
        expect(copied.status, OrderStatus.delivered);
        expect(copied.date, '2026-09-17');
      });

      test('OrdersPageModel.toEntity should map all properties correctly', () {
        // Arrange
        const model = OrdersPageModel(
          orders: [],
          hasMore: true,
          lastDocument: null,
        );

        // Act
        final entity = model.toEntity();

        // Assert
        expect(entity.orders, isEmpty);
        expect(entity.hasMore, isTrue);
        expect(entity.lastDocument, isNull);
      });

      test('OrdersStatsModel.toEntity should map all counts accurately', () {
        // Arrange
        const model = OrdersStatsModel(
          totalCount: 100,
          pendingCount: 20,
          processingCount: 15,
          shippedCount: 25,
          deliveredCount: 35,
          cancelledCount: 5,
        );

        // Act
        final entity = model.toEntity();

        // Assert
        expect(entity.totalCount, 100);
        expect(entity.pendingCount, 20);
        expect(entity.processingCount, 15);
        expect(entity.shippedCount, 25);
        expect(entity.deliveredCount, 35);
        expect(entity.cancelledCount, 5);
      });

      test('AddressModel.toEntity and toJson should map all properties and serialize keys accurately', () {
        // Arrange
        final model = AddressModel(
          name: 'Kareem Tarek',
          email: 'kareem@test.com',
          phone: '01123456789',
          city: 'Giza',
          buildingNumber: '15',
          streetName: 'Pyramids St',
          floorNumber: '4',
          apartmentNumber: '8',
        );

        // Act - toEntity
        final entity = model.toEntity();

        // Assert - toEntity
        expect(entity.name, 'Kareem Tarek');
        expect(entity.email, 'kareem@test.com');
        expect(entity.phone, '01123456789');
        expect(entity.city, 'Giza');
        expect(entity.buildingNumber, '15');
        expect(entity.streetName, 'Pyramids St');
        expect(entity.floorNumber, '4');
        expect(entity.apartmentNumber, '8');

        // Act - fromEntity
        final fromEntityModel = AddressModel.fromEntity(entity);
        expect(fromEntityModel.name, model.name);
        expect(fromEntityModel.city, model.city);

        // Act - toJson
        final json = model.toJson();

        // Assert - exact Firestore keys
        expect(json['name'], 'Kareem Tarek');
        expect(json['email'], 'kareem@test.com');
        expect(json['phone'], '01123456789');
        expect(json['city'], 'Giza');
        expect(json['street'], 'Pyramids St');
        expect(json['building_number'], '15');
        expect(json['floor_number'], '4');
        expect(json['apartment_number'], '8');
      });

      test('OrderItemModel.toEntity and fromJson should handle imageUrl and imagePath correctly', () {
        // Arrange - using imageUrl in json
        final jsonWithImageUrl = {
          'code': 'ITEM_1',
          'name': 'Orange',
          'imageUrl': 'https://img.com/orange.png',
          'price': 25, // int to double
          'quantity': 3,
        };

        // Act
        final model1 = OrderItemModel.fromJson(jsonWithImageUrl);
        final entity1 = model1.toEntity();

        // Assert
        expect(entity1.code, 'ITEM_1');
        expect(entity1.name, 'Orange');
        expect(entity1.imagePath, 'https://img.com/orange.png');
        expect(entity1.price, 25.0);
        expect(entity1.quantity, 3);

        // Arrange - using imagePath fallback in json
        final jsonWithImagePath = {
          'code': 'ITEM_2',
          'name': 'Mango',
          'imagePath': 'https://img.com/mango.png',
          'price': 60.5,
          'quantity': 1,
        };

        // Act
        final model2 = OrderItemModel.fromJson(jsonWithImagePath);

        // Assert
        expect(model2.imagePath, 'https://img.com/mango.png');
      });
    });
  });
}
