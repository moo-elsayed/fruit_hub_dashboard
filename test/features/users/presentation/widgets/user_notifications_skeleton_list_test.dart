import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/user_notification_item.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/user_notifications_skeleton_list.dart';
import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('UserNotificationsSkeletonList Widget Tests', () {
    testWidgets(
      'should render Skeletonizer and default itemCount of UserNotificationItem',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const UserNotificationsSkeletonList(),
          ),
        );

        expect(
          find.byWidgetPredicate(
            (w) => w.runtimeType.toString() == '_Skeletonizer',
          ),
          findsOneWidget,
        );
        expect(find.byType(UserNotificationItem), findsAtLeast(3));
      },
    );

    testWidgets(
      'should render custom itemCount of UserNotificationItem when provided',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const UserNotificationsSkeletonList(itemCount: 3),
          ),
        );

        // Assert
        expect(find.byType(UserNotificationItem), findsNWidgets(3));
      },
    );
  });
}
