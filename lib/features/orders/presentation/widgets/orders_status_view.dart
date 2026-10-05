import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';

class OrdersStatusView extends StatelessWidget {
  const OrdersStatusView({
    super.key,
    required this.message,
    required this.icon,
    this.color,
  });

  final String message;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? context.colors.primary;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12.h,
          children: [
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: effectiveColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40.sp, color: effectiveColor),
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.font14Regular.copyWith(
                color: color ?? context.colors.subText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
