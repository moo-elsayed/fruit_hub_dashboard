import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';

import '../managers/user_notifications_cubit/user_notifications_cubit.dart';
import 'user_notification_item.dart';
import 'user_notifications_skeleton_list.dart';

class UserNotificationsList extends StatelessWidget {
  const UserNotificationsList({super.key, this.physics});

  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<UserNotificationsCubit, UserNotificationsState>(
        buildWhen: (previous, current) =>
            current is UserNotificationsLoading ||
            current is UserNotificationsSuccess ||
            current is UserNotificationsFailure,
        builder: (context, state) {
          if (state is UserNotificationsLoading) {
            return UserNotificationsSkeletonList(physics: physics);
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
              physics: physics,
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => SizedBox(height: 8.h),
              itemBuilder: (context, index) =>
                  UserNotificationItem(notification: notifications[index]),
            );
          }

          return const SizedBox.shrink();
        },
      );
}
