import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fruit_hub_dashboard/core/enums/order_search_by.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/orders_page_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/orders_stats_entity.dart';

abstract class OrdersRepo {
  Future<NetworkResponse<OrdersPageEntity>> getOrders({
    int limit = 15,
    DocumentSnapshot? lastDocument,
    OrderStatus? status,
  });

  Future<NetworkResponse<OrdersStatsEntity>> getOrdersStats();

  Future<NetworkResponse<List<OrderEntity>>> searchOrders({
    required String query,
    required OrderSearchBy searchBy,
    int limit = 30,
  });

  Future<NetworkResponse<void>> updateOrderStatus(
    String docId,
    OrderStatus status,
  );
}
