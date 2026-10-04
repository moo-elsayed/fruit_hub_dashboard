import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/features/settings/presentation/widgets/shipping_notification_toggle_tile.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ValueNotifier<bool> notifyNotifier;
  late TextEditingController costController;
  late TextEditingController thresholdController;

  setUp(() {
    notifyNotifier = ValueNotifier<bool>(false);
    costController = TextEditingController(text: '40');
    thresholdController = TextEditingController(text: '300');
  });

  tearDown(() {
    notifyNotifier.dispose();
    costController.dispose();
    thresholdController.dispose();
  });

  Widget buildWidget() => createWidgetForTesting(
    child: ShippingNotificationToggleTile(
      notifyNotifier: notifyNotifier,
      costController: costController,
      thresholdController: thresholdController,
    ),
  );

  group('ShippingNotificationToggleTile Widget Tests', () {
    testWidgets(
      'should render notification toggle row with switch off and hide preview initially',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget());

        // Assert
        expect(
          find.byIcon(Icons.notifications_active_outlined),
          findsOneWidget,
        );
        expect(
          find.text(AppStrings.notifyUsersAboutShippingUpdate),
          findsOneWidget,
        );
        expect(
          find.text(AppStrings.notifyUsersAboutShippingUpdateSubtitle),
          findsOneWidget,
        );
        expect(find.byType(Switch), findsOneWidget);
        final switchWidget = tester.widget<Switch>(find.byType(Switch));
        expect(switchWidget.value, isFalse);
        expect(find.text(AppStrings.notificationPreview), findsNothing);
      },
    );

    testWidgets(
      'should display notification preview when switch is toggled on',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildWidget());

        // Act
        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();

        // Assert
        expect(notifyNotifier.value, isTrue);
        expect(find.text(AppStrings.notificationPreview), findsOneWidget);
        expect(find.text(AppStrings.shippingUpdateTitleAr), findsOneWidget);
        expect(find.text(AppStrings.shippingUpdateTitleEn), findsOneWidget);
        expect(
          find.text(
            AppStrings.shippingUpdateBodyAr(cost: 40.0, threshold: 300.0),
          ),
          findsOneWidget,
        );
        expect(
          find.text(
            AppStrings.shippingUpdateBodyEn(cost: 40.0, threshold: 300.0),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should dynamically update notification preview when controllers change',
      (WidgetTester tester) async {
        // Arrange
        notifyNotifier.value = true;
        await tester.pumpWidget(buildWidget());
        await tester.pumpAndSettle();

        // Act
        costController.text = '55';
        thresholdController.text = '450';
        await tester.pump();

        // Assert
        expect(
          find.text(
            AppStrings.shippingUpdateBodyAr(cost: 55.0, threshold: 450.0),
          ),
          findsOneWidget,
        );
        expect(
          find.text(
            AppStrings.shippingUpdateBodyEn(cost: 55.0, threshold: 450.0),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets('should hide notification preview when switch is toggled off', (
      WidgetTester tester,
    ) async {
      // Arrange: switch is initially on
      notifyNotifier.value = true;
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.notificationPreview), findsOneWidget);

      // Act: toggle switch off
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // Assert
      expect(notifyNotifier.value, isFalse);
      expect(find.text(AppStrings.notificationPreview), findsNothing);
    });
  });
}
