import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/helpers/extentions.dart';
import 'package:fruit_hub_dashboard/core/helpers/functions.dart';
import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/core/services/database/database_service.dart';
import 'package:fruit_hub_dashboard/features/orders/data/data_sources/remote/orders_remote_data_source.dart';
import 'package:fruit_hub_dashboard/features/orders/data/models/order_model.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import '../../../../../core/helpers/backend_endpoints.dart';

class OrdersRemoteDataSourceImp implements OrdersRemoteDataSources {
  OrdersRemoteDataSourceImp(this._databaseService);

  final DatabaseService _databaseService;

  @override
  Stream<NetworkResponse<List<OrderEntity>>> getOrders() async* {
    try {
      final stream = _databaseService.streamAllData(
        path: BackendEndpoints.streamOrders,
        includeDocId: true,
      );

      await for (final orders in stream) {
        final orderEntities = orders
            .map((e) => OrderModel.fromJson(e).toEntity())
            .toList();
        yield NetworkSuccess<List<OrderEntity>>(orderEntities);
      }
    } catch (e) {
      yield handleError<List<OrderEntity>>(e, 'getOrders');
    }
  }

  @override
  Future<NetworkResponse<void>> updateOrderStatus(
    String docId,
    OrderStatus status,
  ) async {
    try {
      await _databaseService.updateData(
        path: BackendEndpoints.updateOrderStatus,
        documentId: docId,
        data: {'status': status.getName},
      );
      return const NetworkSuccess<void>();
    } catch (e) {
      return handleError<void>(e, 'updateOrderStatus');
    }
  }
}
