import 'package:fruit_hub_dashboard/core/enums/order_search_by.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';

import '../entities/order_entity.dart';
import '../repo/orders_repo.dart';

class SearchOrdersUseCase {
  const SearchOrdersUseCase(this._ordersRepo);

  final OrdersRepo _ordersRepo;

  Future<NetworkResponse<List<OrderEntity>>> call({
    required String query,
    required OrderSearchBy searchBy,
    int limit = 30,
  }) async => await _ordersRepo.searchOrders(
    query: query,
    searchBy: searchBy,
    limit: limit,
  );
}
