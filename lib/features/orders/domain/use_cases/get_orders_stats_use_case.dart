import 'package:fruit_hub_dashboard/core/network/network_response.dart';

import '../entities/orders_stats_entity.dart';
import '../repo/orders_repo.dart';

class GetOrdersStatsUseCase {
  const GetOrdersStatsUseCase(this._ordersRepo);

  final OrdersRepo _ordersRepo;

  Future<NetworkResponse<OrdersStatsEntity>> call() async =>
      await _ordersRepo.getOrdersStats();
}
