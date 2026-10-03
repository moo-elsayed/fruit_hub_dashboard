import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:gap/gap.dart';

class SettingsPreferenceTile extends StatelessWidget {
  const SettingsPreferenceTile({
    super.key,
    required this.icon,
    required this.title,
    required this.trailingText,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String trailingText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12.r),
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 20.sp, color: context.colors.primary),
          ),
          Gap(14.w),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.font14SemiBold.copyWith(
                color: context.colors.mainText,
              ),
            ),
          ),
          Text(
            trailingText,
            style: AppTextStyles.font13Regular.copyWith(
              color: context.colors.subText,
            ),
          ),
          Gap(8.w),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14.sp,
            color: context.colors.subText,
          ),
        ],
      ),
    ),
  );
}
