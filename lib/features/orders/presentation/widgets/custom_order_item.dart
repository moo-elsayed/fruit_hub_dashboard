import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/core/utils/custom_bottom_sheet_selection_item.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_bottom_sheet.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/managers/orders_cubit/orders_cubit.dart';
import 'package:gap/gap.dart';

import 'order_card_header.dart';
import 'order_customer_details.dart';
import 'order_financial_summary.dart';
import 'order_products_list.dart';
import 'order_summary_bar.dart';

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

  void _showUpdateStatusSheet(BuildContext context, OrderEntity orderEntity) {
    final cubit = context.read<OrdersCubit>();
    final items = OrderStatus.values
        .map(
          (status) => CustomBottomSheetSelectionItem(
            title: status.getName,
            value: status,
            isSelected: orderEntity.status == status,
            onTap: () => cubit.updateOrderStatus(orderEntity.docId, status),
          ),
        )
        .toList();

    CustomBottomSheet.show(
      context: context,
      title: AppStrings.updateOrderStatus,
      items: items,
    );
  }

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
            onStatusTap: () => _showUpdateStatusSheet(context, order),
          ),
          Divider(color: context.colors.border, height: 24.h, thickness: 1.h),
          ValueListenableBuilder<bool>(
            valueListenable: _isExpandedNotifier,
            builder: (context, isExpanded, _) => OrderSummaryBar(
              totalPrice: order.totalPrice,
              paymentType: order.paymentOption.type,
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
                spacing: 12.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(0),
                  OrderCustomerDetails(address: order.address),
                  OrderProductsList(products: order.products),
                  OrderFinancialSummary(
                    subtotal: subtotal,
                    shippingCost: order.paymentOption.shippingCost,
                    totalPrice: order.totalPrice,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
