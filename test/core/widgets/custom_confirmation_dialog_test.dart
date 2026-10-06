import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_confirmation_dialog.dart';

import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('CustomConfirmationDialog Widget Tests', () {
    testWidgets(
      'should render title, subtitle, confirm button and cancel button with callbacks',
      (WidgetTester tester) async {
        // Arrange
        var confirmCalled = false;
        var cancelCalled = false;

        await tester.pumpWidget(
          createWidgetForTesting(
            child: CustomConfirmationDialog(
              title: 'Delete Order',
              subtitle: 'Are you sure you want to delete this order?',
              textConfirmButton: 'Delete',
              textCancelButton: 'Keep',
              onConfirm: () => confirmCalled = true,
              onCancel: () => cancelCalled = true,
            ),
          ),
        );

        // Assert content
        expect(find.text('Delete Order'), findsOneWidget);
        expect(
          find.text('Are you sure you want to delete this order?'),
          findsOneWidget,
        );
        expect(find.text('Delete'), findsOneWidget);
        expect(find.text('Keep'), findsOneWidget);

        // Act: Tap cancel
        await tester.tap(find.text('Keep'));
        await tester.pump();
        expect(cancelCalled, isTrue);

        // Act: Tap confirm
        await tester.tap(find.text('Delete'));
        await tester.pump();
        expect(confirmCalled, isTrue);
      },
    );

    testWidgets('should hide cancel button when showCancelButton is false', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomConfirmationDialog(
            title: 'Notice',
            textConfirmButton: 'Understand',
            showCancelButton: false,
            onConfirm: () {},
          ),
        ),
      );

      // Assert
      expect(find.text('Understand'), findsOneWidget);
      expect(find.text(AppStrings.cancel), findsNothing);
    });

    testWidgets(
      'should display dialog via CustomConfirmationDialog.show static method',
      (WidgetTester tester) async {
        // Arrange
        var confirmed = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    CustomConfirmationDialog.show(
                      context: context,
                      title: 'Confirm Action',
                      textConfirmButton: 'Yes',
                      onConfirm: () {
                        confirmed = true;
                        Navigator.of(context).pop();
                      },
                    );
                  },
                  child: const Text('Open Dialog'),
                ),
              ),
            ),
          ),
        );

        // Act: Open dialog
        await tester.tap(find.text('Open Dialog'));
        await tester.pumpAndSettle();

        // Assert dialog rendered
        expect(find.text('Confirm Action'), findsOneWidget);

        // Act: Confirm
        await tester.tap(find.text('Yes'));
        await tester.pumpAndSettle();

        // Assert callback fired and dialog dismissed
        expect(confirmed, isTrue);
        expect(find.text('Confirm Action'), findsNothing);
      },
    );
  });
}
