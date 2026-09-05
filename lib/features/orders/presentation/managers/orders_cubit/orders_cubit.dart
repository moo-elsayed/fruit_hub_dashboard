import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/use_cases/get_orders_use_case.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/use_cases/update_order_status_use_case.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(this._getOrdersUseCase, this._updateOrderStatusUseCase)
    : super(OrdersInitial());
  final GetOrdersUseCase _getOrdersUseCase;
  final UpdateOrderStatusUseCase _updateOrderStatusUseCase;

  StreamSubscription? _ordersSubscription;
  List<OrderEntity> _orders = [];

  List<OrderEntity> get currentOrders => _orders;

  void streamOrders() {
    _ordersSubscription?.cancel();

    emit(OrdersLoading(OrderState.getOrders));
    _ordersSubscription = _getOrdersUseCase().listen(
      (response) {
        if (isClosed) return;
        switch (response) {
          case NetworkSuccess<List<OrderEntity>>():
            _orders = response.data ?? [];
            emit(
              OrdersSuccess(orders: _orders, orderState: OrderState.getOrders),
            );
          case NetworkFailure<List<OrderEntity>>():
            emit(
              OrdersFailure(
                message: response.error,
                orderState: OrderState.getOrders,
              ),
            );
        }
      },
      onError: (error) {
        if (isClosed) return;
        emit(
          OrdersFailure(
            message: error.toString(),
            orderState: OrderState.getOrders,
          ),
        );
      },
    );
  }

  Future<void> updateOrderStatus(String docId, OrderStatus status) async {
    emit(OrdersLoading(OrderState.updateOrderStatus));
    final response = await _updateOrderStatusUseCase(docId, status);
    if (isClosed) return;
    switch (response) {
      case NetworkSuccess<void>():
        emit(
          OrdersSuccess(
            orders: _orders,
            orderState: OrderState.updateOrderStatus,
          ),
        );
      case NetworkFailure<void>():
        emit(
          OrdersFailure(
            message: response.error,
            orderState: OrderState.updateOrderStatus,
          ),
        );
    }
  }

  @override
  Future<void> close() {
    _ordersSubscription?.cancel();
    return super.close();
  }
}
