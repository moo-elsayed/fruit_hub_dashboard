import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fruit_hub_dashboard/core/enums/order_search_by.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/orders_page_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/orders_stats_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/repo/orders_repo.dart';

import '../data_sources/remote/orders_remote_data_source.dart';

class OrdersRepoImp implements OrdersRepo {
  OrdersRepoImp(this._ordersRemoteDataSources);

  final OrdersRemoteDataSources _ordersRemoteDataSources;

  @override
  Future<NetworkResponse<OrdersPageEntity>> getOrders({
    int limit = 15,
    DocumentSnapshot? lastDocument,
    OrderStatus? status,
  }) async {
    final response = await _ordersRemoteDataSources.getOrders(
      limit: limit,
      lastDocument: lastDocument,
      status: status,
    );
    return switch (response) {
      NetworkSuccess(data: final pageModel) => NetworkSuccess(
        pageModel?.toEntity() ??
            const OrdersPageEntity(orders: [], hasMore: false),
      ),
      NetworkFailure(failure: final failure) => NetworkFailure(failure),
    };
  }

  @override
  Future<NetworkResponse<OrdersStatsEntity>> getOrdersStats() async {
    final response = await _ordersRemoteDataSources.getOrdersStats();
    return switch (response) {
      NetworkSuccess(data: final statsModel) => NetworkSuccess(
        statsModel?.toEntity() ?? const OrdersStatsEntity(),
      ),
      NetworkFailure(failure: final failure) => NetworkFailure(failure),
    };
  }

  @override
  Future<NetworkResponse<List<OrderEntity>>> searchOrders({
    required String query,
    required OrderSearchBy searchBy,
    int limit = 30,
  }) async {
    final response = await _ordersRemoteDataSources.searchOrders(
      query: query,
      searchBy: searchBy,
      limit: limit,
    );
    return switch (response) {
      NetworkSuccess(data: final orderModels) => NetworkSuccess(
        orderModels?.map((m) => m.toEntity()).toList() ?? [],
      ),
      NetworkFailure(failure: final failure) => NetworkFailure(failure),
    };
  }

  @override
  Future<NetworkResponse<void>> updateOrderStatus(
    String docId,
    OrderStatus status,
  ) async => await _ordersRemoteDataSources.updateOrderStatus(docId, status);
}
