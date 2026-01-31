import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/repo/orders_repo.dart';
import '../data_sources/remote/orders_remote_data_source.dart';

class OrdersRepoImp implements OrdersRepo {
  OrdersRepoImp(this._ordersRemoteDataSources);

  final OrdersRemoteDataSources _ordersRemoteDataSources;

  @override
  Stream<NetworkResponse<List<OrderEntity>>> getOrders() async* {
    yield* _ordersRemoteDataSources.getOrders();
  }

  @override
  Future<NetworkResponse<void>> updateOrderStatus(
    String docId,
    OrderStatus status,
  ) async => _ordersRemoteDataSources.updateOrderStatus(docId, status);
}
