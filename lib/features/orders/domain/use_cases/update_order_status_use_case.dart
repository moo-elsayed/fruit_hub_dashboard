import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';

import '../repo/orders_repo.dart';

class UpdateOrderStatusUseCase {
  UpdateOrderStatusUseCase(this._ordersRepo);

  final OrdersRepo _ordersRepo;

  Future<NetworkResponse<void>> call(String docId, OrderStatus status) async =>
      await _ordersRepo.updateOrderStatus(docId, status);
}
