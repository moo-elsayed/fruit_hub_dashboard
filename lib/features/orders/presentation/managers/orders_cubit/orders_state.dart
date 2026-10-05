part of 'orders_cubit.dart';

enum OrderState { getOrders, updateOrderStatus }

@immutable
sealed class OrdersState {
  const OrdersState();
}

final class OrdersInitial extends OrdersState {
  const OrdersInitial();
}

final class OrdersLoading extends OrdersState {
  const OrdersLoading(this.orderState);

  final OrderState orderState;
}

final class OrdersSuccess extends OrdersState {
  const OrdersSuccess({
    required this.orders,
    this.orderState = OrderState.getOrders,
    this.activeFilter,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.stats = const OrdersStatsEntity(),
  });

  final List<OrderEntity> orders;
  final OrderState orderState;
  final OrderStatus? activeFilter;
  final bool hasMore;
  final bool isLoadingMore;
  final OrdersStatsEntity stats;

  OrdersSuccess copyWith({
    List<OrderEntity>? orders,
    OrderState? orderState,
    OrderStatus? Function()? activeFilter,
    bool? hasMore,
    bool? isLoadingMore,
    OrdersStatsEntity? stats,
  }) => OrdersSuccess(
    orders: orders ?? this.orders,
    orderState: orderState ?? this.orderState,
    activeFilter: activeFilter != null ? activeFilter() : this.activeFilter,
    hasMore: hasMore ?? this.hasMore,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    stats: stats ?? this.stats,
  );
}

final class OrdersFailure extends OrdersState {
  const OrdersFailure({required this.message, required this.orderState});

  final String message;
  final OrderState orderState;
}
