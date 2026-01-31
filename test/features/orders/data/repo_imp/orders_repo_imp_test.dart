import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/features/orders/data/data_sources/remote/orders_remote_data_source.dart';
import 'package:fruit_hub_dashboard/features/orders/data/repo_imp/orders_repo_imp.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockOrdersRemoteDataSource extends Mock implements OrdersRemoteDataSources {}

void main() {
  late OrdersRepoImp repo;
  late MockOrdersRemoteDataSource mockDataSource;

  setUpAll(() {
    registerFallbackValue(OrderStatus.pending);
  });

  setUp(() {
    mockDataSource = MockOrdersRemoteDataSource();
    repo = OrdersRepoImp(mockDataSource);
  });

  group('OrdersRepoImp', () {

    test('getOrders should return stream from remote data source', () async {
      // Arrange
      final tOrdersResponse = NetworkSuccess<List<OrderEntity>>([
        OrderEntity(orderId: 1, docId: 'doc1'),
      ]);

      when(() => mockDataSource.getOrders())
          .thenAnswer((_) => Stream.value(tOrdersResponse));

      // Act
      final result = repo.getOrders();

      // Assert
      await expectLater(result, emits(tOrdersResponse));

      verify(() => mockDataSource.getOrders()).called(1);
    });

    test('updateOrderStatus should call remote data source with correct params', () async {
      // Arrange
      const tDocId = 'doc_123';
      const tStatus = OrderStatus.delivered;
      const tResponse = NetworkSuccess<void>();

      when(() => mockDataSource.updateOrderStatus(any(), any()))
          .thenAnswer((_) async => tResponse);

      // Act
      final result = await repo.updateOrderStatus(tDocId, tStatus);

      // Assert
      expect(result, tResponse);

      verify(() => mockDataSource.updateOrderStatus(tDocId, tStatus)).called(1);
    });
  });
}