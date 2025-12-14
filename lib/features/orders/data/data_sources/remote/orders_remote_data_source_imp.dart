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
      yield* _databaseService.streamAllData(BackendEndpoints.streamOrders).map((
        orders,
      ) {
        final orderEntities = orders
            .map((e) => OrderModel.fromJson(e).toEntity())
            .toList();
        return NetworkSuccess<List<OrderEntity>>(orderEntities);
      });
    } catch (e) {
      yield handleError<List<OrderEntity>>(e, 'getOrders');
    }
  }
}
