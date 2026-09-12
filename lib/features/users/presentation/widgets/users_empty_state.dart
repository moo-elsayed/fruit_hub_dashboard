import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';

class UsersEmptyState extends StatelessWidget {
  const UsersEmptyState({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 48.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12.h,
        children: [
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.people_outline_rounded,
              size: 48.sp,
              color: context.colors.primary,
            ),
          ),
          Text(
            AppStrings.noUsersFound,
            style: AppTextStyles.font16SemiBold.copyWith(
              color: context.colors.mainText,
            ),
          ),
          Text(
            AppStrings.noUsersSubtitle,
            style: AppTextStyles.font12Regular.copyWith(
              color: context.colors.subText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
