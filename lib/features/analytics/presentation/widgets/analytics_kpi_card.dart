import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';

class AnalyticsKpiCard extends StatelessWidget {
  const AnalyticsKpiCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
    this.titleSpan,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;
  final InlineSpan? titleSpan;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(14.r),
    decoration: BoxDecoration(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: context.colors.border),
      boxShadow: [
        BoxShadow(
          color: context.colors.mainText.withValues(alpha: 0.03),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 20.r, color: accentColor),
        ),
        SizedBox(height: 10.h),
        Text(
          value,
          style: AppTextStyles.font18Bold.copyWith(
            color: context.colors.mainText,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        titleSpan != null
            ? Text.rich(
                titleSpan!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : Text(
                title,
                style: AppTextStyles.font12Regular.copyWith(
                  color: context.colors.subText,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
      ],
    ),
  );
}
