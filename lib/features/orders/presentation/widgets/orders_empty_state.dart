import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:gap/gap.dart';

class OrdersEmptyState extends StatelessWidget {
  const OrdersEmptyState({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              size: 64.sp,
              color: context.colors.primary,
            ),
          ),
          Gap(20.h),
          Text(
            AppStrings.noOrdersYet,
            style: AppTextStyles.font18Bold.copyWith(
              color: context.colors.mainText,
            ),
          ),
          Gap(8.h),
          Text(
            AppStrings.noOrdersYetSubtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.font13Regular.copyWith(
              color: context.colors.subText,
            ),
          ),
        ],
      ),
    ),
  );
}
