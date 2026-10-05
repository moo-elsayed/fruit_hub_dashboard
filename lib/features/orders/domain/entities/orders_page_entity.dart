import 'package:cloud_firestore/cloud_firestore.dart';

import 'order_entity.dart';

class OrdersPageEntity {
  const OrdersPageEntity({
    required this.orders,
    required this.hasMore,
    this.lastDocument,
  });

  final List<OrderEntity> orders;
  final bool hasMore;
  final DocumentSnapshot? lastDocument;
}
