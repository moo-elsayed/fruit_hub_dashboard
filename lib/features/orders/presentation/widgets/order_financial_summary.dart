import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:gap/gap.dart';

class OrderFinancialSummary extends StatelessWidget {
  const OrderFinancialSummary({
    super.key,
    required this.subtotal,
    required this.shippingCost,
    required this.totalPrice,
  });

  final double subtotal;
  final double shippingCost;
  final double totalPrice;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(12.r),
    decoration: BoxDecoration(
      color: context.colors.background,
      borderRadius: BorderRadius.circular(10.r),
      border: Border.all(color: context.colors.border, width: 0.8),
    ),
    child: Column(
      children: [
        _RowItem(
          title: AppStrings.subtotal,
          amount: '\$${subtotal.toStringAsFixed(2)}',
        ),
        Gap(6.h),
        _RowItem(
          title: AppStrings.delivery,
          amount: shippingCost > 0
              ? '\$${shippingCost.toStringAsFixed(2)}'
              : AppStrings.freeShipping,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Divider(color: context.colors.border, height: 1),
        ),
        _RowItem(
          title: AppStrings.grandTotal,
          amount: '\$${totalPrice.toStringAsFixed(2)}',
          isTotal: true,
        ),
      ],
    ),
  );
}

class _RowItem extends StatelessWidget {
  const _RowItem({
    required this.title,
    required this.amount,
    this.isTotal = false,
  });

  final String title;
  final String amount;
  final bool isTotal;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: isTotal
            ? AppTextStyles.font13Bold.copyWith(color: context.colors.mainText)
            : AppTextStyles.font12Medium.copyWith(
                color: context.colors.subText,
              ),
      ),
      Text(
        amount,
        style: isTotal
            ? AppTextStyles.font15Bold.copyWith(color: context.colors.primary)
            : AppTextStyles.font12Medium.copyWith(
                color: context.colors.mainText,
              ),
      ),
    ],
  );
}
