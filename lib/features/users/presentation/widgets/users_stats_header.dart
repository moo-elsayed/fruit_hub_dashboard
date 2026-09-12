import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';

import '../managers/users_cubit/users_cubit.dart';

class UsersStatsHeader extends StatelessWidget {
  const UsersStatsHeader({
    super.key,
    required this.totalCount,
    required this.verifiedCount,
    required this.activeCartCount,
    required this.activeFilter,
    required this.onSelectFilter,
  });

  final int totalCount;
  final int verifiedCount;
  final int activeCartCount;
  final UserFilterType activeFilter;
  final ValueChanged<UserFilterType> onSelectFilter;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Row(
      spacing: 8.w,
      children: [
        _StatFilterTab(
          title: AppStrings.all,
          count: totalCount,
          icon: Icons.people_alt_rounded,
          color: AppPalette.info,
          isSelected: activeFilter == UserFilterType.all,
          onTap: () => onSelectFilter(UserFilterType.all),
        ),
        _StatFilterTab(
          title: AppStrings.verifiedUsers,
          count: verifiedCount,
          icon: Icons.verified_rounded,
          color: AppPalette.accentGreen,
          isSelected: activeFilter == UserFilterType.verified,
          onTap: () => onSelectFilter(UserFilterType.verified),
        ),
        _StatFilterTab(
          title: AppStrings.activeCarts,
          count: activeCartCount,
          icon: Icons.shopping_cart_rounded,
          color: AppPalette.secondaryOrange,
          isSelected: activeFilter == UserFilterType.withCart,
          onTap: () => onSelectFilter(UserFilterType.withCart),
        ),
      ],
    ),
  );
}

class _StatFilterTab extends StatelessWidget {
  const _StatFilterTab({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: isSelected ? color.withValues(alpha: 0.12) : context.colors.surface,
    borderRadius: BorderRadius.circular(12.r),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? color : context.colors.border,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8.w,
          children: [
            Icon(
              icon,
              size: 17.sp,
              color: isSelected ? color : context.colors.subText,
            ),
            Text(
              title,
              style: AppTextStyles.font13Medium.copyWith(
                color: isSelected ? color : context.colors.mainText,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withValues(alpha: 0.2)
                    : context.colors.border.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                count.toString(),
                style: AppTextStyles.font12Bold.copyWith(
                  color: isSelected ? color : context.colors.subText,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
