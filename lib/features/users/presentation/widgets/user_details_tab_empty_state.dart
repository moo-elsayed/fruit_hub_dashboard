import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';

class UserDetailsTabEmptyState extends StatelessWidget {
  const UserDetailsTabEmptyState({
    super.key,
    required this.icon,
    required this.message,
  });

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 36.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8.h,
        children: [
          Icon(icon, size: 40.sp, color: context.colors.subText),
          Text(
            message,
            style: AppTextStyles.font14Medium.copyWith(
              color: context.colors.subText,
            ),
          ),
        ],
      ),
    ),
  );
}
