import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/core/widgets/app_toasts.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toastification/toastification.dart';

import '../managers/orders_cubit/orders_cubit.dart';
import 'custom_order_item.dart';
import 'orders_empty_state.dart';

class OrdersViewBody extends StatelessWidget {
  const OrdersViewBody({super.key});

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
      if (state is OrdersFailure &&
          context.read<OrdersCubit>().currentOrders.isEmpty) {
        return Center(
          child: Text(
            state.message,
            textAlign: TextAlign.center,
            style: AppTextStyles.font14Medium.copyWith(
              color: context.colors.error,
            ),
          ),
        );
      }

      final orders = state is OrdersSuccess
          ? state.orders
          : context.read<OrdersCubit>().currentOrders;

      if (state is OrdersSuccess && orders.isEmpty) {
        return const OrdersEmptyState();
      }

      if (orders.isNotEmpty) {
        return ListView.separated(
          itemCount: orders.length,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          separatorBuilder: (context, index) => Gap(12.h),
          itemBuilder: (context, index) {
            final order = orders[index];
            return CustomOrderItem(orderEntity: order)
                .animate(delay: const Duration(milliseconds: 50))
                .slideY(begin: 0.15, duration: 300.ms)
                .fadeIn(duration: 300.ms);
          },
        );
      }

      return ListView.separated(
        itemCount: 3,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        separatorBuilder: (context, index) => Gap(12.h),
        itemBuilder: (context, index) => const Skeletonizer(
          enabled: true,
          child: CustomOrderItem(orderEntity: OrderEntity()),
        ),
      );
    },
  );
}
