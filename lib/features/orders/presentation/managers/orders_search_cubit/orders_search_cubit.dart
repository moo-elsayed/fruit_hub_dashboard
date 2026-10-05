import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/core/enums/order_search_by.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/use_cases/search_orders_use_case.dart';

part 'orders_search_state.dart';

class OrdersSearchCubit extends Cubit<OrdersSearchState> {
  OrdersSearchCubit(this._searchOrdersUseCase)
    : super(const OrdersSearchInitial());

  final SearchOrdersUseCase _searchOrdersUseCase;

  String _currentQuery = '';
  OrderSearchBy _currentSearchBy = OrderSearchBy.orderId;

  OrderSearchBy get currentSearchBy => _currentSearchBy;
  String get currentQuery => _currentQuery;

  Future<void> searchOrders(String query, {OrderSearchBy? searchBy}) async {
    _currentQuery = query.trim();
    if (searchBy != null) _currentSearchBy = searchBy;

    if (_currentQuery.isEmpty) {
      emit(OrdersSearchInitial(searchBy: _currentSearchBy));
      return;
    }

    emit(OrdersSearchLoading(searchBy: _currentSearchBy));

    final response = await _searchOrdersUseCase(
      query: _currentQuery,
      searchBy: _currentSearchBy,
    );

    switch (response) {
      case NetworkSuccess(data: final orders):
        emit(
          OrdersSearchSuccess(
            orders: orders ?? [],
            query: _currentQuery,
            searchBy: _currentSearchBy,
          ),
        );
      case NetworkFailure(failure: final failure):
        emit(OrdersSearchFailure(failure.error, searchBy: _currentSearchBy));
    }
  }

  void setSearchBy(OrderSearchBy searchBy) {
    if (_currentSearchBy == searchBy) return;
    _currentSearchBy = searchBy;
    _currentQuery = '';
    emit(OrdersSearchInitial(searchBy: searchBy));
  }

  void clearSearch() {
    _currentQuery = '';
    emit(OrdersSearchInitial(searchBy: _currentSearchBy));
  }
}
