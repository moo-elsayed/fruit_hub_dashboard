import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/enums/payment_methods.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/address_entity.dart';
import 'package:gap/gap.dart';

class OrderCustomerSummary extends StatelessWidget {
  const OrderCustomerSummary({
    super.key,
    required this.address,
    required this.totalPrice,
    required this.paymentType,
  });

  final AddressEntity address;
  final double totalPrice;
  final PaymentMethodType paymentType;

  @override
  Widget build(BuildContext context) {
    final customerName = address.name.isNotEmpty
        ? address.name
        : AppStrings.unknownUser;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38.r,
          height: 38.r,
          decoration: BoxDecoration(
            color: context.colors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person_rounded,
            size: 20.sp,
            color: context.colors.primary,
          ),
        ),
        Gap(10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                customerName,
                style: AppTextStyles.font14Bold.copyWith(
                  color: context.colors.mainText,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (address.phone.isNotEmpty) ...[
                Gap(2.h),
                Row(
                  children: [
                    Icon(
                      Icons.phone_outlined,
                      size: 12.sp,
                      color: context.colors.subText,
                    ),
                    Gap(4.w),
                    Text(
                      address.phone,
                      style: AppTextStyles.font12Regular.copyWith(
                        color: context.colors.subText,
                      ),
                    ),
                  ],
                ),
              ],
              if (address.city.isNotEmpty) ...[
                Gap(2.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 12.sp,
                      color: context.colors.subText,
                    ),
                    Gap(4.w),
                    Expanded(
                      child: Text(
                        '${address.city}, ${address.streetName}',
                        style: AppTextStyles.font12Regular.copyWith(
                          color: context.colors.subText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        Gap(12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${totalPrice.toStringAsFixed(2)}',
              style: AppTextStyles.font18Bold.copyWith(
                color: context.colors.primary,
              ),
            ),
            Gap(4.h),
            _PaymentTypeChip(paymentType: paymentType),
          ],
        ),
      ],
    );
  }
}

class _PaymentTypeChip extends StatelessWidget {
  const _PaymentTypeChip({required this.paymentType});

  final PaymentMethodType paymentType;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (paymentType) {
      PaymentMethodType.paypal => (Icons.paypal, AppPalette.info),
      PaymentMethodType.card => (Icons.credit_card, AppPalette.secondaryOrange),
      PaymentMethodType.cash => (Icons.attach_money, AppPalette.accentGreen),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: color),
          Gap(4.w),
          Text(
            paymentType.title,
            style: AppTextStyles.font11SemiBold.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
