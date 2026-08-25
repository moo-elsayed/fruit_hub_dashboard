import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import '../entities/order_entity.dart';
import '../repo/orders_repo.dart';

class GetOrdersUseCase {
  GetOrdersUseCase(this._ordersRepo);

  final OrdersRepo _ordersRepo;

  Stream<NetworkResponse<List<OrderEntity>>> call() => _ordersRepo.getOrders();
}
