import 'package:fruit_hub_dashboard/features/orders/domain/repo/orders_repo.dart';
import '../../../../core/helpers/network_response.dart';
import '../entities/order_entity.dart';

class GetOrdersUseCase {
  GetOrdersUseCase(this._ordersRepo);

  final OrdersRepo _ordersRepo;

  Stream<NetworkResponse<List<OrderEntity>>> call() async* {
    yield* _ordersRepo.getOrders();
  }
}
