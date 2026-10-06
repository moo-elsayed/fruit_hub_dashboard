import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'custom_order_item.dart';

class OrdersSkeletonList extends StatelessWidget {
  const OrdersSkeletonList({super.key, this.itemCount = 4, this.padding});

  final int itemCount;
  final EdgeInsetsGeometry? padding;

  static const _dummyOrder = OrderEntity(
    orderId: 1001,
    totalPrice: 150.0,
    status: OrderStatus.pending,
    date: '2026-10-05T12:00:00Z',
  );

  @override
  Widget build(BuildContext context) => Skeletonizer(
    enabled: true,
    child: ListView.separated(
      padding: padding ?? EdgeInsets.only(right: 16.w, left: 16.w, bottom: 8.h),
      itemCount: itemCount,
      separatorBuilder: (context, index) => Gap(8.h),
      itemBuilder: (context, index) =>
          const CustomOrderItem(orderEntity: _dummyOrder),
    ),
  );
}
