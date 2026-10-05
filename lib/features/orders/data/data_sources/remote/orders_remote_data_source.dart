import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fruit_hub_dashboard/core/enums/order_search_by.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';

import '../../models/order_model.dart';
import '../../models/orders_page_model.dart';
import '../../models/orders_stats_model.dart';

abstract class OrdersRemoteDataSources {
  Future<NetworkResponse<OrdersPageModel>> getOrders({
    int limit = 15,
    DocumentSnapshot? lastDocument,
    OrderStatus? status,
  });

  Future<NetworkResponse<OrdersStatsModel>> getOrdersStats();

  Future<NetworkResponse<List<OrderModel>>> searchOrders({
    required String query,
    required OrderSearchBy searchBy,
    int limit = 30,
  });

  Future<NetworkResponse<void>> updateOrderStatus(
    String docId,
    OrderStatus status,
  );
}
