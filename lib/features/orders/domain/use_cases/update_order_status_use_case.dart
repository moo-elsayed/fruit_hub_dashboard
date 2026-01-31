import 'package:fruit_hub_dashboard/features/orders/domain/repo/orders_repo.dart';
import '../../../../core/enums/order_status.dart';
import '../../../../core/helpers/network_response.dart';

class UpdateOrderStatusUseCase {
  UpdateOrderStatusUseCase(this._ordersRepo);

  final OrdersRepo _ordersRepo;

  Future<NetworkResponse<void>> call(String docId, OrderStatus status) async =>
      _ordersRepo.updateOrderStatus(docId, status);
}
