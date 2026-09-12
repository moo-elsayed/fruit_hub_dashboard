import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';

import '../managers/user_notifications_cubit/user_notifications_cubit.dart';

class UserNotificationsList extends StatelessWidget {
  const UserNotificationsList({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<UserNotificationsCubit, UserNotificationsState>(
        builder: (context, state) {
          if (state is UserNotificationsLoading) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32.h),
                child: const CircularProgressIndicator.adaptive(),
              ),
            );
          }

          if (state is UserNotificationsFailure) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Text(
                  state.message,
                  style: AppTextStyles.font13Regular.copyWith(
                    color: context.colors.error,
                  ),
                ),
              ),
            );
          }

          if (state is UserNotificationsSuccess) {
            final notifications = state.notifications;
            if (notifications.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 36.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8.h,
                    children: [
                      Icon(
                        Icons.notifications_none_rounded,
                        size: 40.sp,
                        color: context.colors.subText,
                      ),
                      Text(
                        AppStrings.emptyNotifications,
                        style: AppTextStyles.font14Medium.copyWith(
                          color: context.colors.subText,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => SizedBox(height: 8.h),
              itemBuilder: (context, index) {
                final notification = notifications[index];
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
                                    style: AppTextStyles.font13SemiBold
                                        .copyWith(
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
              },
            );
          }

          return const SizedBox.shrink();
        },
      );
}
