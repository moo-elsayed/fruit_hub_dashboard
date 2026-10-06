import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:gap/gap.dart';

import 'custom_order_item.dart';

class OrdersSearchResultsList extends StatelessWidget {
  const OrdersSearchResultsList({super.key, required this.orders});

  final List<OrderEntity> orders;

  @override
  Widget build(BuildContext context) => ListView.separated(
    padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 12.h),
    itemCount: orders.length,
    separatorBuilder: (context, index) => Gap(8.h),
    itemBuilder: (context, index) => CustomOrderItem(
      key: ValueKey(orders[index].docId),
      orderEntity: orders[index],
    ),
  );
}
