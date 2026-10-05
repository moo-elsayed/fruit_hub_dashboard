import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';

import '../entities/orders_page_entity.dart';
import '../repo/orders_repo.dart';

class GetOrdersUseCase {
  const GetOrdersUseCase(this._ordersRepo);

  final OrdersRepo _ordersRepo;

  Future<NetworkResponse<OrdersPageEntity>> call({
    int limit = 15,
    DocumentSnapshot? lastDocument,
    OrderStatus? status,
  }) async => await _ordersRepo.getOrders(
    limit: limit,
    lastDocument: lastDocument,
    status: status,
  );
}
