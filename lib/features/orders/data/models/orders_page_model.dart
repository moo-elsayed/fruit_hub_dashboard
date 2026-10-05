import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/orders_page_entity.dart';
import 'order_model.dart';

class OrdersPageModel {
  const OrdersPageModel({
    required this.orders,
    required this.hasMore,
    this.lastDocument,
  });

  final List<OrderModel> orders;
  final bool hasMore;
  final DocumentSnapshot? lastDocument;

  OrdersPageEntity toEntity() => OrdersPageEntity(
    orders: orders.map((o) => o.toEntity()).toList(),
    hasMore: hasMore,
    lastDocument: lastDocument,
  );
}
