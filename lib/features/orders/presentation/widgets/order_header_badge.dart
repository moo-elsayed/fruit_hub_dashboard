import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:gap/gap.dart';

class OrderHeaderBadge extends StatelessWidget {
  const OrderHeaderBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.showDot = false,
  });

  final String label;
  final Color color;
  final IconData? icon;
  final bool showDot;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(20.r),
      border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showDot) ...[
          Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          Gap(6.w),
        ] else if (icon != null) ...[
          Icon(icon, size: 12.sp, color: color),
          Gap(5.w),
        ],
        Text(label, style: AppTextStyles.font11Bold.copyWith(color: color)),
      ],
    ),
  );
}
