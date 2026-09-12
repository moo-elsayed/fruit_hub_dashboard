import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/core/widgets/user_avatar_widget.dart';

import '../../domain/entities/dashboard_user_entity.dart';

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({
    super.key,
    required this.user,
    required this.onSendNotification,
  });

  final DashboardUserEntity user;
  final VoidCallback onSendNotification;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(16.r),
    decoration: BoxDecoration(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(20.r),
      border: Border.all(color: context.colors.border),
    ),
    child: Column(
      spacing: 16.h,
      children: [
        Row(
          spacing: 16.w,
          children: [
            UserAvatarWidget(imagePath: user.image, name: user.name, size: 64),
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
                          style: AppTextStyles.font16Bold.copyWith(
                            color: context.colors.mainText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color:
                              (user.isVerified
                                      ? AppPalette.accentGreen
                                      : context.colors.subText)
                                  .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 3.w,
                          children: [
                            Icon(
                              user.isVerified
                                  ? Icons.verified_rounded
                                  : Icons.info_outline_rounded,
                              size: 11.sp,
                              color: user.isVerified
                                  ? AppPalette.accentGreen
                                  : context.colors.subText,
                            ),
                            Text(
                              user.isVerified
                                  ? AppStrings.verified
                                  : AppStrings.notVerified,
                              style: AppTextStyles.font11Regular.copyWith(
                                color: user.isVerified
                                    ? AppPalette.accentGreen
                                    : context.colors.subText,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (user.email.isNotEmpty)
                    Text(
                      user.email,
                      style: AppTextStyles.font12Regular.copyWith(
                        color: context.colors.subText,
                      ),
                    ),
                  if (user.phone.isNotEmpty)
                    Text(
                      user.phone,
                      style: AppTextStyles.font12Regular.copyWith(
                        color: context.colors.subText,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        Row(
          spacing: 8.w,
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.notifications_active_outlined,
                label: AppStrings.sendNotification,
                color: context.colors.primary,
                onTap: onSendNotification,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: color.withValues(alpha: 0.08),
    borderRadius: BorderRadius.circular(10.r),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 6.w,
          children: [
            Icon(icon, size: 16.sp, color: color),
            Text(
              label,
              style: AppTextStyles.font13Medium.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
