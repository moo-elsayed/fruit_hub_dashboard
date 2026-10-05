import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/enums/order_search_by.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/di.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_app_bar.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_keyboard_unfocus.dart';
import 'package:fruit_hub_dashboard/core/widgets/search_text_field.dart';

import '../managers/orders_search_cubit/orders_search_cubit.dart';
import '../widgets/orders_search_filter_chips.dart';
import '../widgets/orders_search_results_list.dart';
import '../widgets/orders_skeleton_list.dart';
import '../widgets/orders_status_view.dart';

class OrdersSearchView extends StatefulWidget {
  const OrdersSearchView({super.key});

  @override
  State<OrdersSearchView> createState() => _OrdersSearchViewState();
}

class _OrdersSearchViewState extends State<OrdersSearchView> {
  late final TextEditingController _searchController;
  late final FocusNode _focusNode;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _focusNode = FocusNode();
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  void _onSearchChanged(String? query, OrdersSearchCubit cubit) {
    _debounceTimer?.cancel();
    final cleanQuery = query?.trim() ?? '';
    if (cleanQuery.isEmpty) {
      cubit.clearSearch();
      return;
    }
    _debounceTimer = Timer(const Duration(milliseconds: 350), () {
      cubit.searchOrders(cleanQuery);
    });
  }

  void _onClearSearch(OrdersSearchCubit cubit) {
    _debounceTimer?.cancel();
    cubit.clearSearch();
  }

  void _onFilterSelected(OrderSearchBy by, OrdersSearchCubit cubit) {
    if (cubit.currentSearchBy == by) return;
    _debounceTimer?.cancel();
    _searchController.clear();
    cubit.setSearchBy(by);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt.get<OrdersSearchCubit>(),
    child: Builder(
      builder: (context) {
        final cubit = context.read<OrdersSearchCubit>();
        return Scaffold(
          appBar: CustomAppBar(
            title: AppStrings.search,
            showArrowBack: true,
            onTap: () => context.pop(),
          ),
          body: CustomKeyboardUnfocus(
            child: Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Column(
                spacing: 12.h,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Hero(
                      tag: 'orders_search_bar_hero_tag',
                      child: Material(
                        color: Colors.transparent,
                        child: SearchTextField(
                          focusNode: _focusNode,
                          controller: _searchController,
                          hint: AppStrings.searchOrders,
                          onChanged: (query) => _onSearchChanged(query, cubit),
                          onClear: () => _onClearSearch(cubit),
                        ),
                      ),
                    ),
                  ),
                  BlocBuilder<OrdersSearchCubit, OrdersSearchState>(
                    buildWhen: (previous, current) =>
                        previous.searchBy != current.searchBy,
                    builder: (context, state) => OrdersSearchFilterChips(
                      selectedSearchBy: state.searchBy,
                      onSelected: (by) => _onFilterSelected(by, cubit),
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<OrdersSearchCubit, OrdersSearchState>(
                      builder: (context, state) => switch (state) {
                        OrdersSearchInitial() => OrdersStatusView(
                          icon: Icons.search_rounded,
                          message: AppStrings.typeToSearchOrders,
                        ),
                        OrdersSearchLoading() => const OrdersSkeletonList(),
                        OrdersSearchFailure(:final message) => OrdersStatusView(
                          icon: Icons.error_outline_rounded,
                          message: message,
                          color: context.colors.error,
                        ),
                        OrdersSearchSuccess(:final orders) =>
                          orders.isEmpty
                              ? OrdersStatusView(
                                  icon: Icons.receipt_long_outlined,
                                  message: AppStrings.noSearchResultsFound,
                                )
                              : OrdersSearchResultsList(orders: orders),
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
