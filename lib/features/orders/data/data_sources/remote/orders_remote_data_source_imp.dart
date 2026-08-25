import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/errors/exceptions.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_logger.dart';
import 'package:fruit_hub_dashboard/core/helpers/backend_endpoints.dart';
import 'package:fruit_hub_dashboard/core/network/api_helper.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/orders/data/data_sources/remote/orders_remote_data_source.dart';
import 'package:fruit_hub_dashboard/features/orders/data/models/order_model.dart';

class OrdersRemoteDataSourceImp implements OrdersRemoteDataSources {
  OrdersRemoteDataSourceImp({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Stream<NetworkResponse<List<OrderModel>>> getOrders() async* {
    try {
      final snapshots = _firestore
          .collection(BackendEndpoints.ordersCollection)
          .snapshots();

      await for (final snapshot in snapshots) {
        final orderModels = snapshot.docs.map((doc) {
          final data = Map<String, dynamic>.from(doc.data());
          data['docId'] = doc.id;
          return OrderModel.fromJson(data);
        }).toList();
        yield NetworkSuccess<List<OrderModel>>(orderModels);
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error in getOrders', error: e, stackTrace: stackTrace);
      if (e is BusinessException) {
        yield NetworkFailure(ServerFailure(error: e.message));
      } else {
        yield NetworkFailure(ServerFailure.fromException(e));
      }
    }
  }

  @override
  Future<NetworkResponse<void>> updateOrderStatus(
    String docId,
    OrderStatus status,
  ) async => ApiHelper.executeSafely(() async {
    await _firestore
        .collection(BackendEndpoints.ordersCollection)
        .doc(docId)
        .update({'status': status.getName});
  }, functionName: 'updateOrderStatus');
}
