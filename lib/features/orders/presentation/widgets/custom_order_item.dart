import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:gap/gap.dart';

import 'order_card_header.dart';
import 'order_customer_details.dart';
import 'order_customer_summary.dart';
import 'order_financial_summary.dart';
import 'order_footer_actions.dart';
import 'order_items_preview_bar.dart';
import 'order_products_list.dart';

class CustomOrderItem extends StatefulWidget {
  const CustomOrderItem({super.key, required this.orderEntity});

  final OrderEntity orderEntity;

  @override
  State<CustomOrderItem> createState() => _CustomOrderItemState();
}

class _CustomOrderItemState extends State<CustomOrderItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _expandController;
  late final Animation<double> _expandAnimation;
  final ValueNotifier<bool> _isExpandedNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    _isExpandedNotifier.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    if (_isExpandedNotifier.value) {
      _expandController.reverse();
      _isExpandedNotifier.value = false;
    } else {
      _expandController.forward();
      _isExpandedNotifier.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.orderEntity;
    final subtotal = order.products.fold<double>(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.colors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppPalette.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrderCardHeader(
            orderId: order.orderId,
            date: order.date,
            status: order.status,
          ),
          Gap(12.h),
          OrderCustomerSummary(
            address: order.address,
            totalPrice: order.totalPrice,
            paymentType: order.paymentOption.type,
          ),
          Gap(8.h),
          Divider(color: context.colors.border, height: 1),
          ValueListenableBuilder<bool>(
            valueListenable: _isExpandedNotifier,
            builder: (context, isExpanded, _) => OrderItemsPreviewBar(
              products: order.products,
              isExpanded: isExpanded,
              onToggle: _toggleExpand,
            ),
          ),
          SizeTransition(
            sizeFactor: _expandAnimation,
            alignment: Alignment.topCenter,
            child: FadeTransition(
              opacity: _expandAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(6.h),
                  Divider(color: context.colors.border, height: 1),
                  Gap(12.h),
                  OrderCustomerDetails(address: order.address),
                  Gap(12.h),
                  OrderProductsList(products: order.products),
                  Gap(12.h),
                  OrderFinancialSummary(
                    subtotal: subtotal,
                    shippingCost: order.paymentOption.shippingCost,
                    totalPrice: order.totalPrice,
                  ),
                  Gap(12.h),
                  OrderFooterActions(orderEntity: order),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
