import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/use_cases/update_order_status_use_case.dart';
import '../../../../../core/helpers/functions.dart';
import '../../../../../core/helpers/network_response.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../domain/use_cases/get_orders_use_case.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(this._getOrdersUseCase, this._updateOrderStatusUseCase)
    : super(OrdersInitial());
  final GetOrdersUseCase _getOrdersUseCase;
  final UpdateOrderStatusUseCase _updateOrderStatusUseCase;

  StreamSubscription? _ordersSubscription;

  void streamOrders() {
    _ordersSubscription?.cancel();

    emit(OrdersLoading(.getOrders));
    _ordersSubscription = _getOrdersUseCase().listen(
      (response) {
        switch (response) {
          case NetworkSuccess<List<OrderEntity>>():
            emit(OrdersSuccess(orders: response.data!, orderState: .getOrders));
          case NetworkFailure<List<OrderEntity>>():
            emit(
              OrdersFailure(
                message: getErrorMessage(response),
                orderState: .getOrders,
              ),
            );
        }
      },
      onError: (error) {
        emit(OrdersFailure(message: error.toString(), orderState: .getOrders));
      },
    );
  }

  Future<void> updateOrderStatus(String docId, OrderStatus status) async {
    emit(OrdersLoading(.updateOrderStatus));
    final response = await _updateOrderStatusUseCase(docId, status);
    switch (response) {
      case NetworkSuccess<void>():
        return;
      case NetworkFailure<void>():
        emit(
          OrdersFailure(
            message: getErrorMessage(response),
            orderState: .updateOrderStatus,
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
