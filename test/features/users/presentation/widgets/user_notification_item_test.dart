import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/notification_type.dart';
import 'package:fruit_hub_dashboard/features/users/domain/entities/notification_entity.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/user_notification_item.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('UserNotificationItem Widget Tests', () {
    const tNotificationRead = NotificationEntity(
      id: 'notif_1',
      titleAr: 'تنبيه عربي',
      titleEn: 'English Alert',
      bodyAr: 'محتوى عربي',
      bodyEn: 'English Body',
      type: NotificationType.order,
      isRead: true,
    );

    const tNotificationUnread = NotificationEntity(
      id: 'notif_2',
      titleAr: 'تنبيه جديد',
      titleEn: 'New Alert',
      bodyAr: 'محتوى جديد',
      bodyEn: 'New Body',
      type: NotificationType.general,
      isRead: false,
    );

    testWidgets(
      'should render title, body, and read icon when notification isRead is true',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const UserNotificationItem(notification: tNotificationRead),
          ),
        );

        // Assert (test environment default locale is Arabic in test wrapper or LTR English)
        final titleFinder = find.byWidgetPredicate(
          (w) =>
              w is Text &&
              (w.data == tNotificationRead.titleAr ||
                  w.data == tNotificationRead.titleEn),
        );
        final bodyFinder = find.byWidgetPredicate(
          (w) =>
              w is Text &&
              (w.data == tNotificationRead.bodyAr ||
                  w.data == tNotificationRead.bodyEn),
        );

        expect(titleFinder, findsOneWidget);
        expect(bodyFinder, findsOneWidget);
        expect(find.byIcon(Icons.done_all_rounded), findsOneWidget);
      },
    );

    testWidgets(
      'should not render read icon when notification isRead is false',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const UserNotificationItem(
              notification: tNotificationUnread,
            ),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.done_all_rounded), findsNothing);
      },
    );
  });
}
