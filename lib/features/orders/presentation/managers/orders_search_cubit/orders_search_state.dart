part of 'orders_search_cubit.dart';

sealed class OrdersSearchState {
  const OrdersSearchState({this.searchBy = OrderSearchBy.orderId});

  final OrderSearchBy searchBy;
}

final class OrdersSearchInitial extends OrdersSearchState {
  const OrdersSearchInitial({super.searchBy});
}

final class OrdersSearchLoading extends OrdersSearchState {
  const OrdersSearchLoading({super.searchBy});
}

final class OrdersSearchSuccess extends OrdersSearchState {
  const OrdersSearchSuccess({
    required this.orders,
    required this.query,
    super.searchBy,
  });

  final List<OrderEntity> orders;
  final String query;
}

final class OrdersSearchFailure extends OrdersSearchState {
  const OrdersSearchFailure(this.message, {super.searchBy});

  final String message;
}
