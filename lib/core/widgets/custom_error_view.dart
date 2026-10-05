import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_material_button.dart';

class CustomErrorView extends StatelessWidget {
  const CustomErrorView({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
  });

  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8.h,
        children: [
          Container(
            padding: EdgeInsets.all(18.r),
            decoration: BoxDecoration(
              color: context.colors.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon ?? Icons.error_outline_rounded,
              size: 40.sp,
              color: context.colors.error,
            ),
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.font14Medium.copyWith(
              color: context.colors.mainText,
            ),
          ),
          if (onRetry != null)
            CustomMaterialButton(
              onPressed: onRetry!,
              text: AppStrings.retry,
              maxWidth: false,
            ),
        ],
      ),
    ),
  );
}
