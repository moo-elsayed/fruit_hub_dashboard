import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/widgets/app_toasts.dart';
import 'package:toastification/toastification.dart';

import '../../helpers/test_widget_wrapper.dart';

void main() {
  setUp(() {
    AppToast.isEnabled = true;
  });

  tearDown(() {
    AppToast.isEnabled = true;
    toastification.dismissAll();
  });

  group('AppToast Widget Tests', () {
    testWidgets(
      'should display toast title and description when show is called',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createWidgetForTesting(
            withToastification: true,
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  AppToast.show(
                    context: context,
                    title: 'Order Updated',
                    description: 'Status changed to Delivered',
                    type: ToastificationType.success,
                  );
                },
                child: const Text('Show Toast'),
              ),
            ),
          ),
        );

        // Act: Show toast
        await tester.tap(find.text('Show Toast'));
        await tester.pump();
        for (int i = 0; i < 10; i++) {
          await tester.pump(const Duration(milliseconds: 50));
        }

        // Assert toast is displayed
        expect(find.text('Order Updated'), findsOneWidget);
        expect(find.text('Status changed to Delivered'), findsOneWidget);

        // Dismiss and settle
        toastification.dismissAll();
        await tester.pump(const Duration(seconds: 3));
      },
    );

    testWidgets('should not display toast when AppToast.isEnabled is false', (
      WidgetTester tester,
    ) async {
      // Arrange
      AppToast.isEnabled = false;

      await tester.pumpWidget(
        createWidgetForTesting(
          withToastification: true,
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                AppToast.show(
                  context: context,
                  title: 'Disabled Toast',
                  type: ToastificationType.info,
                );
              },
              child: const Text('Trigger Toast'),
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Trigger Toast'));
      await tester.pump();
      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      // Assert toast is NOT displayed
      expect(find.text('Disabled Toast'), findsNothing);
    });

    testWidgets('should dismiss toast when close button is tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        createWidgetForTesting(
          withToastification: true,
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                AppToast.show(
                  context: context,
                  title: 'Dismissible Toast',
                  type: ToastificationType.error,
                );
              },
              child: const Text('Show Error'),
            ),
          ),
        ),
      );

      // Act 1: Show toast
      await tester.tap(find.text('Show Error'));
      await tester.pump();
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(find.text('Dismissible Toast'), findsOneWidget);

      // Act 2: Tap close button
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      // Assert dismissed
      expect(find.text('Dismissible Toast'), findsNothing);

      // Settle
      toastification.dismissAll();
      await tester.pump(const Duration(seconds: 3));
    });
  });
}
