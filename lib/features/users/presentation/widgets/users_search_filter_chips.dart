import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/enums/user_search_by.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';

class UsersSearchFilterChips extends StatelessWidget {
  const UsersSearchFilterChips({
    super.key,
    required this.selectedSearchBy,
    required this.onSelected,
  });

  final UserSearchBy selectedSearchBy;
  final ValueChanged<UserSearchBy> onSelected;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Row(
      spacing: 8.w,
      children: UserSearchBy.values.map((searchBy) {
        final isSelected = selectedSearchBy == searchBy;
        return _SearchFilterChip(
          label: searchBy.label,
          icon: switch (searchBy) {
            UserSearchBy.name => Icons.person_outline_rounded,
            UserSearchBy.email => Icons.mail_outline_rounded,
            UserSearchBy.phone => Icons.phone_outlined,
          },
          isSelected: isSelected,
          onTap: () => onSelected(searchBy),
        );
      }).toList(),
    ),
  );
}

class _SearchFilterChip extends StatelessWidget {
  const _SearchFilterChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isSelected ? context.colors.primary : context.colors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isSelected ? context.colors.primary : context.colors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6.w,
        children: [
          Icon(
            icon,
            size: 15.sp,
            color: isSelected ? AppPalette.white : context.colors.subText,
          ),
          Text(
            label,
            style: AppTextStyles.font12Regular.copyWith(
              color: isSelected ? AppPalette.white : context.colors.mainText,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    ),
  );
}
