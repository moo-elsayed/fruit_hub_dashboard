import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_count_badge.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_item_entity.dart';

import 'order_product_card.dart';

class OrderProductsList extends StatefulWidget {
  const OrderProductsList({
    super.key,
    required this.products,
    this.initiallyExpanded = true,
  });

  final List<OrderItemEntity> products;
  final bool initiallyExpanded;

  @override
  State<OrderProductsList> createState() => _OrderProductsListState();
}

class _OrderProductsListState extends State<OrderProductsList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _expandAnimation;
  late final Animation<double> _arrowAnimation;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: _isExpanded ? 1.0 : 0.0,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _arrowAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(_expandAnimation);
  }

  @override
  void dispose() {
    _expandAnimation.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    if (_isExpanded) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    _isExpanded = !_isExpanded;
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _toggleExpand,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 6.w,
              children: [
                Text(
                  AppStrings.orderedItems,
                  style: AppTextStyles.font14Bold.copyWith(
                    color: context.colors.mainText,
                  ),
                ),
                CustomCountBadge(count: widget.products.length),
              ],
            ),
            RotationTransition(
              turns: _arrowAnimation,
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 22.sp,
                color: context.colors.subText,
              ),
            ),
          ],
        ),
      ),
      SizeTransition(
        sizeFactor: _expandAnimation,
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: Column(
            spacing: 8.h,
            children: widget.products
                .map((product) => OrderProductCard(product: product))
                .toList(),
          ),
        ),
      ),
    ],
  );
}
