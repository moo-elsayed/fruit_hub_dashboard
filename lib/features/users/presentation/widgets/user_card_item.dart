import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/core/widgets/user_avatar_widget.dart';

import '../../domain/entities/dashboard_user_entity.dart';

class UserCardItem extends StatelessWidget {
  const UserCardItem({super.key, required this.user, required this.onTap});

  final DashboardUserEntity user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: context.colors.surface,
    borderRadius: BorderRadius.circular(16.r),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          spacing: 12.w,
          children: [
            UserAvatarWidget(imagePath: user.image, name: user.name, size: 52),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4.h,
                children: [
                  Row(
                    spacing: 6.w,
                    children: [
                      Flexible(
                        child: Text(
                          user.name.isNotEmpty ? user.name : user.email,
                          style: AppTextStyles.font14SemiBold.copyWith(
                            color: context.colors.mainText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (user.isVerified)
                        Icon(
                          Icons.verified_rounded,
                          size: 14.sp,
                          color: AppPalette.accentGreen,
                        ),
                    ],
                  ),
                  if (user.email.isNotEmpty && user.name.isNotEmpty)
                    Text(
                      user.email,
                      style: AppTextStyles.font12Regular.copyWith(
                        color: context.colors.subText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (user.phone.isNotEmpty)
                    Text(
                      user.phone,
                      style: AppTextStyles.font11Regular.copyWith(
                        color: context.colors.subText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  Row(
                    spacing: 8.w,
                    children: [
                      if (user.hasActiveCart)
                        _CountBadge(
                          icon: Icons.shopping_cart_outlined,
                          label: '${user.cartCount} ${AppStrings.itemsCount}',
                          color: AppPalette.secondaryOrange,
                        ),
                      if (user.favoritesCount > 0)
                        _CountBadge(
                          icon: Icons.favorite_border_rounded,
                          label: '${user.favoritesCount}',
                          color: AppPalette.accentPink,
                        ),
                      _CountBadge(
                        icon: Icons.language_rounded,
                        label: user.languageCode.toUpperCase(),
                        color: context.colors.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20.sp,
              color: context.colors.subText,
            ),
          ],
        ),
      ),
    ),
  );
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(6.r),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 3.w,
      children: [
        Icon(icon, size: 11.sp, color: color),
        Text(
          label,
          style: AppTextStyles.font11Regular.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
