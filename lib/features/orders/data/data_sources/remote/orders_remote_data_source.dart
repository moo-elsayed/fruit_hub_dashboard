import '../../../../../core/enums/order_status.dart';
import '../../../../../core/helpers/network_response.dart';
import '../../../domain/entities/order_entity.dart';

abstract class OrdersRemoteDataSources {
  Stream<NetworkResponse<List<OrderEntity>>> getOrders();

  Future<NetworkResponse<void>> updateOrderStatus(
    String docId,
    OrderStatus status,
  );
}
