import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/orders/data/models/order_model.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/repo/orders_repo.dart';
import '../data_sources/remote/orders_remote_data_source.dart';

class OrdersRepoImp implements OrdersRepo {
  OrdersRepoImp(this._ordersRemoteDataSources);

  final OrdersRemoteDataSources _ordersRemoteDataSources;

  @override
  Stream<NetworkResponse<List<OrderEntity>>> getOrders() async* {
    await for (final response in _ordersRemoteDataSources.getOrders()) {
      switch (response) {
        case NetworkSuccess<List<OrderModel>>():
          yield NetworkSuccess(
            response.data?.map((model) => model.toEntity()).toList(),
          );
        case NetworkFailure<List<OrderModel>>():
          yield NetworkFailure(response.failure);
      }
    }
  }

  @override
  Future<NetworkResponse<void>> updateOrderStatus(
    String docId,
    OrderStatus status,
  ) async => await _ordersRemoteDataSources.updateOrderStatus(docId, status);
}
