import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';

import '../../models/order_model.dart';

abstract class OrdersRemoteDataSources {
  Stream<NetworkResponse<List<OrderModel>>> getOrders();

  Future<NetworkResponse<void>> updateOrderStatus(
    String docId,
    OrderStatus status,
  );
}
