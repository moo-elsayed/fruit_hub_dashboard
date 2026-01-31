part of 'orders_cubit.dart';

enum OrderState { getOrders, updateOrderStatus }

@immutable
sealed class OrdersState {}

final class OrdersInitial extends OrdersState {}

final class OrdersLoading extends OrdersState {
  OrdersLoading(this.orderState);

  final OrderState orderState;
}

final class OrdersSuccess extends OrdersState {
  OrdersSuccess({required this.orders, required this.orderState});

  final List<OrderEntity> orders;
  final OrderState orderState;
}

final class OrdersFailure extends OrdersState {
  OrdersFailure({required this.message, required this.orderState});

  final String message;
  final OrderState orderState;
}
