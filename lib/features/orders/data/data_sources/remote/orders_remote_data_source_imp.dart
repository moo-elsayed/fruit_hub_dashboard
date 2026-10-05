import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fruit_hub_dashboard/core/enums/order_search_by.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/helpers/backend_endpoints.dart';
import 'package:fruit_hub_dashboard/core/network/api_helper.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/orders/data/data_sources/remote/orders_remote_data_source.dart';
import 'package:fruit_hub_dashboard/features/orders/data/models/order_model.dart';
import 'package:fruit_hub_dashboard/features/orders/data/models/orders_page_model.dart';
import 'package:fruit_hub_dashboard/features/orders/data/models/orders_stats_model.dart';

class OrdersRemoteDataSourceImp implements OrdersRemoteDataSources {
  OrdersRemoteDataSourceImp({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  static const String _ordersCollection = BackendEndpoints.ordersCollection;

  @override
  Future<NetworkResponse<OrdersPageModel>> getOrders({
    int limit = 15,
    DocumentSnapshot? lastDocument,
    OrderStatus? status,
  }) async => ApiHelper.executeSafely(() async {
    Query query = _firestore.collection(_ordersCollection);

    if (status != null) {
      query = query.where('status', isEqualTo: status.databaseValue);
    }

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    query = query.limit(limit);

    final snapshot = await query.get();
    final orders = snapshot.docs
        .map(
          (doc) => OrderModel.fromFirestore(
            doc.data() as Map<String, dynamic>,
            doc.id,
          ),
        )
        .toList();

    final hasMore = snapshot.docs.length == limit;
    final newLastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

    return OrdersPageModel(
      orders: orders,
      hasMore: hasMore,
      lastDocument: newLastDoc,
    );
  }, functionName: 'getOrders');

  @override
  Future<NetworkResponse<OrdersStatsModel>> getOrdersStats() async =>
      ApiHelper.executeSafely(() async {
        final results = await Future.wait([
          _firestore.collection(_ordersCollection).count().get(),
          _firestore
              .collection(_ordersCollection)
              .where('status', isEqualTo: OrderStatus.pending.databaseValue)
              .count()
              .get(),
          _firestore
              .collection(_ordersCollection)
              .where('status', isEqualTo: OrderStatus.processing.databaseValue)
              .count()
              .get(),
          _firestore
              .collection(_ordersCollection)
              .where('status', isEqualTo: OrderStatus.shipped.databaseValue)
              .count()
              .get(),
          _firestore
              .collection(_ordersCollection)
              .where('status', isEqualTo: OrderStatus.delivered.databaseValue)
              .count()
              .get(),
          _firestore
              .collection(_ordersCollection)
              .where('status', isEqualTo: OrderStatus.cancelled.databaseValue)
              .count()
              .get(),
        ]);

        return OrdersStatsModel(
          totalCount: results[0].count ?? 0,
          pendingCount: results[1].count ?? 0,
          processingCount: results[2].count ?? 0,
          shippedCount: results[3].count ?? 0,
          deliveredCount: results[4].count ?? 0,
          cancelledCount: results[5].count ?? 0,
        );
      }, functionName: 'getOrdersStats');

  @override
  Future<NetworkResponse<List<OrderModel>>> searchOrders({
    required String query,
    required OrderSearchBy searchBy,
    int limit = 30,
  }) async => ApiHelper.executeSafely(() async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return <OrderModel>[];

    Query queryRef = _firestore.collection(_ordersCollection);

    switch (searchBy) {
      case OrderSearchBy.orderId:
        final orderIdNum = int.tryParse(cleanQuery.replaceAll('#', '').trim());
        if (orderIdNum == null) return <OrderModel>[];
        queryRef = queryRef.where('orderId', isEqualTo: orderIdNum);
      case OrderSearchBy.customerName:
        queryRef = queryRef
            .where('shippingAddress.name', isGreaterThanOrEqualTo: cleanQuery)
            .where(
              'shippingAddress.name',
              isLessThanOrEqualTo: '$cleanQuery\uf8ff',
            );
      case OrderSearchBy.phone:
        queryRef = queryRef
            .where('shippingAddress.phone', isGreaterThanOrEqualTo: cleanQuery)
            .where(
              'shippingAddress.phone',
              isLessThanOrEqualTo: '$cleanQuery\uf8ff',
            );
    }

    queryRef = queryRef.limit(limit);
    final snapshot = await queryRef.get();

    return snapshot.docs
        .map(
          (doc) => OrderModel.fromFirestore(
            doc.data() as Map<String, dynamic>,
            doc.id,
          ),
        )
        .toList();
  }, functionName: 'searchOrders');

  @override
  Future<NetworkResponse<void>> updateOrderStatus(
    String docId,
    OrderStatus status,
  ) async => ApiHelper.executeSafely(() async {
    await _firestore
        .collection(_ordersCollection)
        .doc(docId)
        .update({'status': status.databaseValue});
  }, functionName: 'updateOrderStatus');
}
