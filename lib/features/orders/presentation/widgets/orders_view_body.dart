import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/routing/routes.dart';
import 'package:fruit_hub_dashboard/core/widgets/app_toasts.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_error_view.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_keyboard_unfocus.dart';
import 'package:fruit_hub_dashboard/core/widgets/search_text_field.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toastification/toastification.dart';

import '../managers/orders_cubit/orders_cubit.dart';
import 'custom_order_item.dart';
import 'orders_empty_state.dart';
import 'orders_skeleton_list.dart';
import 'orders_stats_header.dart';
import 'orders_stats_header_skeleton.dart';

class OrdersViewBody extends StatefulWidget {
  const OrdersViewBody({super.key});

  @override
  State<OrdersViewBody> createState() => _OrdersViewBodyState();
}

class _OrdersViewBodyState extends State<OrdersViewBody> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<OrdersCubit>().loadMoreOrders();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<OrdersCubit, OrdersState>(
    listener: (context, state) {
      if (state is OrdersFailure) {
        AppToast.show(
          context: context,
          title: state.message,
          type: ToastificationType.error,
        );
      }
      if (state is OrdersSuccess &&
          state.orderState == OrderState.updateOrderStatus) {
        AppToast.show(
          context: context,
          title: AppStrings.orderStatusUpdatedSuccessfully,
          type: ToastificationType.success,
        );
      }
    },
    builder: (context, state) {
      final cubit = context.read<OrdersCubit>();
      final orders = state is OrdersSuccess
          ? state.orders
          : cubit.currentOrders;
      final isInitialLoading =
          state is OrdersLoading &&
          state.orderState == OrderState.getOrders &&
          cubit.stats.totalCount == 0;
      final isListLoading =
          state is OrdersLoading && state.orderState == OrderState.getOrders;

      if (state is OrdersFailure && orders.isEmpty) {
        return CustomErrorView(
          message: state.message,
          onRetry: () => cubit.initOrders(),
        );
      }

      return CustomKeyboardUnfocus(
        child: Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: Column(
            spacing: 12.h,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Skeletonizer(
                  enabled: isInitialLoading,
                  child: Hero(
                    tag: 'orders_search_bar_hero_tag',
                    child: Material(
                      color: Colors.transparent,
                      child: SearchTextField(
                        readOnly: true,
                        enabled: !isInitialLoading,
                        hint: AppStrings.searchOrders,
                        onTap: isInitialLoading
                            ? null
                            : () => context.pushNamed(Routes.ordersSearchView),
                      ),
                    ),
                  ),
                ),
              ),
              if (isInitialLoading)
                const OrdersStatsHeaderSkeleton()
              else
                OrdersStatsHeader(
                  stats: state is OrdersSuccess ? state.stats : cubit.stats,
                  activeFilter: cubit.activeFilter,
                  onSelectFilter: (filter) => cubit.setFilter(filter),
                ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => cubit.initOrders(),
                  child: Builder(
                    builder: (context) {
                      if (isListLoading) {
                        return const OrdersSkeletonList();
                      }

                      if (orders.isEmpty) {
                        return const OrdersEmptyState();
                      }

                      final hasLoadingFooter =
                          state is OrdersSuccess && state.isLoadingMore;

                      return ListView.separated(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          right: 16.w,
                          left: 16.w,
                          bottom: 8.h,
                        ),
                        itemCount: orders.length + (hasLoadingFooter ? 1 : 0),
                        separatorBuilder: (context, index) => Gap(8.h),
                        itemBuilder: (context, index) {
                          if (index >= orders.length) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                child: const CupertinoActivityIndicator(),
                              ),
                            );
                          }

                          final order = orders[index];
                          return CustomOrderItem(orderEntity: order)
                              .animate(delay: const Duration(milliseconds: 30))
                              .slideY(begin: 0.1, duration: 250.ms)
                              .fadeIn(duration: 250.ms);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
