import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';

import '../../domain/entities/notification_entity.dart';

class UserNotificationItem extends StatelessWidget {
  const UserNotificationItem({super.key, required this.notification});

  final NotificationEntity notification;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isRTL;
    final title = notification.localizedTitle(isArabic);
    final body = notification.localizedBody(isArabic);

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              notification.type.icon,
              size: 18.sp,
              color: context.colors.primary,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.h,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.font13SemiBold.copyWith(
                          color: context.colors.mainText,
                        ),
                      ),
                    ),
                    if (notification.isRead)
                      Icon(
                        Icons.done_all_rounded,
                        size: 14.sp,
                        color: context.colors.primary,
                      ),
                  ],
                ),
                Text(
                  body,
                  style: AppTextStyles.font12Regular.copyWith(
                    color: context.colors.subText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
