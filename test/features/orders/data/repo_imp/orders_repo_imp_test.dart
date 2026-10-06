import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/order_search_by.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/orders/data/data_sources/remote/orders_remote_data_source.dart';
import 'package:fruit_hub_dashboard/features/orders/data/models/address_model.dart';
import 'package:fruit_hub_dashboard/features/orders/data/models/order_item_model.dart';
import 'package:fruit_hub_dashboard/features/orders/data/models/order_model.dart';
import 'package:fruit_hub_dashboard/features/orders/data/models/orders_page_model.dart';
import 'package:fruit_hub_dashboard/features/orders/data/models/orders_stats_model.dart';
import 'package:fruit_hub_dashboard/features/orders/data/repo_imp/orders_repo_imp.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/orders_page_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/orders_stats_entity.dart';
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

  final tOrdersPageModel = OrdersPageModel(
    orders: [tOrderModel1],
    hasMore: true,
    lastDocument: null,
  );

  const tOrdersStatsModel = OrdersStatsModel(
    totalCount: 50,
    pendingCount: 10,
    processingCount: 8,
    shippedCount: 12,
    deliveredCount: 18,
    cancelledCount: 2,
  );

  setUpAll(() {
    registerFallbackValue(OrderStatus.pending);
    registerFallbackValue(OrderSearchBy.orderId);
  });

  setUp(() {
    mockRemoteDataSource = MockOrdersRemoteDataSources();
    sut = OrdersRepoImp(mockRemoteDataSource);
  });

  group('OrdersRepoImp - getOrders', () {
    test('should return NetworkSuccess with OrdersPageEntity when remote data source returns NetworkSuccess', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.getOrders(
          limit: any(named: 'limit'),
          lastDocument: any(named: 'lastDocument'),
          status: any(named: 'status'),
        ),
      ).thenAnswer((_) async => NetworkSuccess(tOrdersPageModel));

      // Act
      final result = await sut.getOrders(limit: 15);

      // Assert
      expect(result, isA<NetworkSuccess<OrdersPageEntity>>());
      final page = (result as NetworkSuccess<OrdersPageEntity>).data;
      expect(page?.orders.length, 1);
      expect(page?.orders.first.orderId, 101);
      expect(page?.hasMore, true);
      verify(() => mockRemoteDataSource.getOrders(limit: 15)).called(1);
    });

    test('should return NetworkFailure when remote data source returns NetworkFailure', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.getOrders(
          limit: any(named: 'limit'),
          lastDocument: any(named: 'lastDocument'),
          status: any(named: 'status'),
        ),
      ).thenAnswer((_) async => const NetworkFailure(tFailure));

      // Act
      final result = await sut.getOrders();

      // Assert
      expect(result, isA<NetworkFailure<OrdersPageEntity>>());
      expect((result as NetworkFailure<OrdersPageEntity>).failure, tFailure);
    });
  });

  group('OrdersRepoImp - getOrdersStats', () {
    test('should return NetworkSuccess with OrdersStatsEntity when remote data source returns NetworkSuccess', () async {
      // Arrange
      when(() => mockRemoteDataSource.getOrdersStats())
          .thenAnswer((_) async => const NetworkSuccess(tOrdersStatsModel));

      // Act
      final result = await sut.getOrdersStats();

      // Assert
      expect(result, isA<NetworkSuccess<OrdersStatsEntity>>());
      final stats = (result as NetworkSuccess<OrdersStatsEntity>).data;
      expect(stats?.totalCount, 50);
      expect(stats?.pendingCount, 10);
      verify(() => mockRemoteDataSource.getOrdersStats()).called(1);
    });

    test('should return NetworkFailure when remote data source returns NetworkFailure', () async {
      // Arrange
      when(() => mockRemoteDataSource.getOrdersStats())
          .thenAnswer((_) async => const NetworkFailure(tFailure));

      // Act
      final result = await sut.getOrdersStats();

      // Assert
      expect(result, isA<NetworkFailure<OrdersStatsEntity>>());
      expect((result as NetworkFailure<OrdersStatsEntity>).failure, tFailure);
    });
  });

  group('OrdersRepoImp - searchOrders', () {
    test('should return NetworkSuccess with List<OrderEntity> when search succeeds', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.searchOrders(
          query: any(named: 'query'),
          searchBy: any(named: 'searchBy'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => NetworkSuccess([tOrderModel1]));

      // Act
      final result = await sut.searchOrders(
        query: '101',
        searchBy: OrderSearchBy.orderId,
      );

      // Assert
      expect(result, isA<NetworkSuccess<List<OrderEntity>>>());
      final orders = (result as NetworkSuccess<List<OrderEntity>>).data;
      expect(orders?.length, 1);
      expect(orders?.first.orderId, 101);
    });

    test('should return NetworkFailure when search fails', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.searchOrders(
          query: any(named: 'query'),
          searchBy: any(named: 'searchBy'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => const NetworkFailure(tFailure));

      // Act
      final result = await sut.searchOrders(
        query: '101',
        searchBy: OrderSearchBy.orderId,
      );

      // Assert
      expect(result, isA<NetworkFailure<List<OrderEntity>>>());
      expect((result as NetworkFailure<List<OrderEntity>>).failure, tFailure);
    });
  });

  group('OrdersRepoImp - updateOrderStatus', () {
    test(
      'should call remote data source and return NetworkSuccess(null)',
      () async {
        // Arrange
        when(
          () => mockRemoteDataSource.updateOrderStatus(
            tDocId,
            OrderStatus.shipped,
          ),
        ).thenAnswer((_) async => const NetworkSuccess(null));

        // Act
        final result = await sut.updateOrderStatus(tDocId, OrderStatus.shipped);

        // Assert
        expect(result, isA<NetworkSuccess<void>>());
        verify(
          () => mockRemoteDataSource.updateOrderStatus(
            tDocId,
            OrderStatus.shipped,
          ),
        ).called(1);
      },
    );

    test('should return NetworkFailure when remote data source returns NetworkFailure', () async {
      // Arrange
      when(
        () =>
            mockRemoteDataSource.updateOrderStatus(tDocId, OrderStatus.shipped),
      ).thenAnswer((_) async => const NetworkFailure(tFailure));

      // Act
      final result = await sut.updateOrderStatus(tDocId, OrderStatus.shipped);

      // Assert
      expect(result, isA<NetworkFailure<void>>());
      expect((result as NetworkFailure<void>).failure, tFailure);
      verify(
        () =>
            mockRemoteDataSource.updateOrderStatus(tDocId, OrderStatus.shipped),
      ).called(1);
    });
  });
}
