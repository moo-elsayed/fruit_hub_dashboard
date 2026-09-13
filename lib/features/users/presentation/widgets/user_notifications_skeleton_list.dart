import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/enums/notification_type.dart';
import '../../domain/entities/notification_entity.dart';
import 'user_notification_item.dart';

class UserNotificationsSkeletonList extends StatelessWidget {
  const UserNotificationsSkeletonList({
    super.key,
    this.itemCount = 5,
    this.physics,
  });

  final int itemCount;
  final ScrollPhysics? physics;

  static const _dummyNotification = NotificationEntity(
    id: '',
    titleAr: 'تحديث حالة الطلب الخاص بك',
    titleEn: 'Your order status has been updated',
    bodyAr: 'تم شحن طلبك بنجاح وهو في طريقه إليك الآن خلال الساعات القادمة',
    bodyEn: 'Your order has been shipped successfully and is on its way',
    type: NotificationType.order,
    isRead: false,
  );

  @override
  Widget build(BuildContext context) => Skeletonizer(
    enabled: true,
    child: ListView.separated(
      physics: physics,
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      itemCount: itemCount,
      separatorBuilder: (_, _) => SizedBox(height: 8.h),
      itemBuilder: (_, _) =>
          const UserNotificationItem(notification: _dummyNotification),
    ),
  );
}
