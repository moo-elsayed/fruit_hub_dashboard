import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/core/utils/stat_filter_tab_item.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_count_badge.dart';

class StatFilterTab extends StatelessWidget {
  const StatFilterTab({super.key, required this.item});

  final StatFilterTabItem item;

  @override
  Widget build(BuildContext context) => Material(
    color: item.isSelected
        ? item.color.withValues(alpha: 0.12)
        : context.colors.surface,
    borderRadius: BorderRadius.circular(12.r),
    child: InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: item.isSelected ? item.color : context.colors.border,
            width: item.isSelected ? 1.5 : 1,
          ),
          boxShadow: item.isSelected
              ? [
                  BoxShadow(
                    color: item.color.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 7.w,
          children: [
            Icon(
              item.icon,
              size: 16.sp,
              color: item.isSelected ? item.color : context.colors.subText,
            ),
            Text(
              item.title,
              style: AppTextStyles.font13Medium.copyWith(
                color: item.isSelected ? item.color : context.colors.mainText,
                fontWeight: item.isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            CustomCountBadge(
              count: item.count,
              textColor: item.isSelected ? item.color : context.colors.subText,
              backgroundColor: item.isSelected
                  ? item.color.withValues(alpha: 0.2)
                  : context.colors.border.withValues(alpha: 0.4),
              textStyle: AppTextStyles.font11Bold,
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            ),
          ],
        ),
      ),
    ),
  );
}
