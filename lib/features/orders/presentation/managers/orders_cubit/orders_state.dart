part of 'orders_cubit.dart';

@immutable
sealed class OrdersState {}

final class OrdersInitial extends OrdersState {}

final class OrdersLoading extends OrdersState {}

final class OrdersSuccess extends OrdersState {
  OrdersSuccess(this.orders);

  final List<OrderEntity> orders;
}

final class OrdersFailure extends OrdersState {
  final String message;

  OrdersFailure(this.message);
}
