import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/orders_stats_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/use_cases/get_orders_stats_use_case.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/use_cases/get_orders_use_case.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/use_cases/update_order_status_use_case.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(
    this._getOrdersUseCase,
    this._getOrdersStatsUseCase,
    this._updateOrderStatusUseCase,
  ) : super(const OrdersInitial());

  final GetOrdersUseCase _getOrdersUseCase;
  final GetOrdersStatsUseCase _getOrdersStatsUseCase;
  final UpdateOrderStatusUseCase _updateOrderStatusUseCase;

  static const int _pageSize = 15;
  List<OrderEntity> _orders = [];
  OrderStatus? _activeFilter;

  DocumentSnapshot? _lastDocument;
  bool _hasMore = false;
  bool _isLoadingMore = false;
  OrdersStatsEntity _stats = const OrdersStatsEntity();

  List<OrderEntity> get currentOrders => _orders;
  OrderStatus? get activeFilter => _activeFilter;
  OrdersStatsEntity get stats => _stats;
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  Future<void> initOrders() async {
    await Future.wait([getOrdersStats(), getOrders()]);
  }

  Future<void> getOrdersStats() async {
    final response = await _getOrdersStatsUseCase();
    if (response is NetworkSuccess<OrdersStatsEntity>) {
      _stats = response.data ?? const OrdersStatsEntity();
      if (state is OrdersSuccess) {
        emit(
          (state as OrdersSuccess).copyWith(
            stats: _stats,
            orderState: OrderState.getOrders,
          ),
        );
      }
    }
  }

  Future<void> getOrders({OrderStatus? Function()? filter}) async {
    if (filter != null) {
      _activeFilter = filter();
    }
    _lastDocument = null;
    _hasMore = false;
    _isLoadingMore = false;
    emit(const OrdersLoading(OrderState.getOrders));

    final response = await _getOrdersUseCase(
      limit: _pageSize,
      status: _activeFilter,
    );

    switch (response) {
      case NetworkSuccess(data: final page):
        if (page != null) {
          _orders = List.of(page.orders);
          _hasMore = page.hasMore;
          _lastDocument = page.lastDocument;
        } else {
          _orders = [];
          _hasMore = false;
        }
        _emitSuccess();
      case NetworkFailure(failure: final failure):
        emit(
          OrdersFailure(
            message: failure.error,
            orderState: OrderState.getOrders,
          ),
        );
    }
  }

  Future<void> loadMoreOrders() async {
    if (_isLoadingMore || !_hasMore || state is! OrdersSuccess) return;

    _isLoadingMore = true;
    final currentState = state as OrdersSuccess;
    emit(currentState.copyWith(isLoadingMore: true));

    final response = await _getOrdersUseCase(
      limit: _pageSize,
      lastDocument: _lastDocument,
      status: _activeFilter,
    );

    switch (response) {
      case NetworkSuccess(data: final page):
        _isLoadingMore = false;
        if (page != null && page.orders.isNotEmpty) {
          _orders.addAll(page.orders);
          _hasMore = page.hasMore;
          _lastDocument = page.lastDocument;
        } else {
          _hasMore = false;
        }
        _emitSuccess();
      case NetworkFailure():
        _isLoadingMore = false;
        emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  Future<void> setFilter(OrderStatus? filter) async {
    if (_activeFilter == filter && state is OrdersSuccess) return;
    _activeFilter = filter;
    await getOrders();
  }

  Future<void> updateOrderStatus(String docId, OrderStatus status) async {
    final index = _orders.indexWhere((o) => o.docId == docId);
    if (index == -1) return;

    final previousStatus = _orders[index].status;
    if (previousStatus == status) return;

    // 1. Optimistic update (Local First)
    _orders[index] = _orders[index].copyWith(status: status);
    _emitSuccess();

    // 2. Call backend
    final response = await _updateOrderStatusUseCase(docId, status);
    if (isClosed) return;

    switch (response) {
      case NetworkSuccess<void>():
        _emitSuccess(orderState: OrderState.updateOrderStatus);
        unawaited(getOrdersStats());

      case NetworkFailure<void>():
        // 3. Rollback on failure
        final currentIndex = _orders.indexWhere((o) => o.docId == docId);
        if (currentIndex != -1) {
          _orders[currentIndex] = _orders[currentIndex].copyWith(
            status: previousStatus,
          );
        }
        emit(
          OrdersFailure(
            message: response.error,
            orderState: OrderState.updateOrderStatus,
          ),
        );
        _emitSuccess();
    }
  }

  void _emitSuccess({OrderState orderState = OrderState.getOrders}) => emit(
    OrdersSuccess(
      orders: List.unmodifiable(_orders),
      orderState: orderState,
      activeFilter: _activeFilter,
      hasMore: _hasMore,
      isLoadingMore: _isLoadingMore,
      stats: _stats,
    ),
  );
}
