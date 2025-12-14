import '../../../../../core/helpers/network_response.dart';
import '../../../domain/entities/order_entity.dart';

abstract class OrdersRemoteDataSources {
  Stream<NetworkResponse<List<OrderEntity>>> getOrders();
}