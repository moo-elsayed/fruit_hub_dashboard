import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_item_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/order_product_card.dart';
import 'package:gap/gap.dart';

class OrderProductsList extends StatelessWidget {
  const OrderProductsList({super.key, required this.products});

  final List<OrderItemEntity> products;

  @override
  Widget build(BuildContext context) => ListView.separated(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: products.length,
    separatorBuilder: (context, index) => Gap(8.h),
    itemBuilder: (context, index) => OrderProductCard(product: products[index]),
  );
}
