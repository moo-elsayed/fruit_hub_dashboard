import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';

abstract class OrdersRepo {
  Stream<NetworkResponse<List<OrderEntity>>> getOrders();

  Future<NetworkResponse<void>> updateOrderStatus(
    String docId,
    OrderStatus status,
  );
}
