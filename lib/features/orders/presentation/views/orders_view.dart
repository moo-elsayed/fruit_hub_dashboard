import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/di.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/use_cases/get_orders_use_case.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/custom_order_item.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/helpers/extentions.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../managers/orders_cubit/orders_cubit.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OrdersCubit(getIt.get<GetOrdersUseCase>())..streamOrders(),
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Orders",
          showArrowBack: true,
          onTap: () => context.pop(),
        ),
        body: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            if (state is OrdersFailure) {
              return Center(child: Text(state.message, textAlign: .center));
            }
            if (state is OrdersSuccess) {
              return ListView.separated(
                itemCount: state.orders.length,
                padding: .symmetric(horizontal: 16.w),
                separatorBuilder: (context, index) => Gap(12.h),
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return CustomOrderItem(orderEntity: order)
                      .animate(delay: const Duration(milliseconds: 50))
                      .slideY(begin: 0.15, duration: 300.ms)
                      .fadeIn(duration: 300.ms);
                },
              );
            }
            return ListView.separated(
              itemCount: 3,
              padding: .symmetric(horizontal: 16.w),
              separatorBuilder: (context, index) => Gap(12.h),
              itemBuilder: (context, index) => Skeletonizer(
                enabled: true,
                child: CustomOrderItem(orderEntity: OrderEntity()),
              ),
            );
          },
        ),
      ),
    );
  }
}
