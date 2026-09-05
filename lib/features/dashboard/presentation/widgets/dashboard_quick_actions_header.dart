import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';

import '../../../../core/helpers/app_strings.dart';
import '../../../../core/theming/app_text_styles.dart';

class DashboardQuickActionsHeader extends StatelessWidget {
  const DashboardQuickActionsHeader({super.key, required this.itemCount});

  final int itemCount;

  @override
  Widget build(BuildContext context) => Row(
    spacing: 8.w,
    children: [
      Text(
        AppStrings.quickActions,
        style: AppTextStyles.font16Bold.copyWith(
          color: context.colors.mainText,
        ),
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: context.colors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Text(
          '$itemCount',
          style: AppTextStyles.font12Bold.copyWith(
            color: context.colors.primary,
          ),
        ),
      ),
    ],
  );
}
