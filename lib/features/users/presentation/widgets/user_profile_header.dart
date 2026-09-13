import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    padding: EdgeInsets.all(14.r),
    decoration: BoxDecoration(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: context.colors.border),
    ),
    child: Row(
      spacing: 12.w,
      children: [
        UserAvatarWidget(imagePath: user.image, name: user.name, size: 56),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2.h,
            children: [
              Row(
                spacing: 6.w,
                children: [
                  Flexible(
                    child: Text(
                      user.name,
                      style: AppTextStyles.font15Bold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (user.isVerified)
                    Icon(
                      Icons.verified_rounded,
                      size: 15.sp,
                      color: AppPalette.accentGreen,
                    ),
                ],
              ),
              if (user.email.isNotEmpty)
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
                  style: AppTextStyles.font12Regular.copyWith(
                    color: context.colors.subText,
                  ),
                ),
            ],
          ),
        ),
        Material(
          color: context.colors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
          child: InkWell(
            onTap: onSendNotification,
            borderRadius: BorderRadius.circular(12.r),
            child: Padding(
              padding: EdgeInsets.all(10.r),
              child: Icon(
                Icons.notifications_active_outlined,
                size: 20.sp,
                color: context.colors.primary,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
