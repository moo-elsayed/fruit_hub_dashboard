import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/helpers/functions.dart';
import '../../../../../core/helpers/network_response.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../domain/use_cases/get_orders_use_case.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(this._getOrdersUseCase) : super(OrdersInitial());
  final GetOrdersUseCase _getOrdersUseCase;

  StreamSubscription? _ordersSubscription;

  void streamOrders() {
    _ordersSubscription?.cancel();

    emit(OrdersLoading());
    _ordersSubscription = _getOrdersUseCase().listen(
      (response) {
        switch (response) {
          case NetworkSuccess<List<OrderEntity>>():
            emit(OrdersSuccess(response.data!));
          case NetworkFailure<List<OrderEntity>>():
            emit(OrdersFailure(getErrorMessage(response)));
        }
      },
      onError: (error) {
        emit(OrdersFailure(error.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _ordersSubscription?.cancel();
    return super.close();
  }
}
