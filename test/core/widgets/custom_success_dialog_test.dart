import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_success_dialog.dart';

import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('CustomSuccessDialog Widget Tests', () {
    testWidgets(
      'should render checkmark icon, message text, and trigger callback',
      (WidgetTester tester) async {
        // Arrange
        var pressed = false;
        await tester.pumpWidget(
          createWidgetForTesting(
            child: CustomSuccessDialog(
              text: 'Fruit added successfully!',
              onPressed: () => pressed = true,
            ),
          ),
        );

        // Assert content
        expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
        expect(find.text('Fruit added successfully!'), findsOneWidget);
        expect(find.text(AppStrings.ok), findsOneWidget);

        // Act
        await tester.tap(find.text(AppStrings.ok));
        await tester.pump();

        // Assert callback
        expect(pressed, isTrue);
      },
    );

    testWidgets(
      'should render custom button text and display dialog via show static method',
      (WidgetTester tester) async {
        // Arrange
        var pressed = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    CustomSuccessDialog.show(
                      context: context,
                      text: 'Changes saved',
                      buttonText: 'Done',
                      onPressed: () {
                        pressed = true;
                        Navigator.of(context).pop();
                      },
                    );
                  },
                  child: const Text('Show Success'),
                ),
              ),
            ),
          ),
        );

        // Act: Open dialog
        await tester.tap(find.text('Show Success'));
        await tester.pumpAndSettle();

        // Assert dialog is visible
        expect(find.text('Changes saved'), findsOneWidget);
        expect(find.text('Done'), findsOneWidget);

        // Act: Tap button
        await tester.tap(find.text('Done'));
        await tester.pumpAndSettle();

        // Assert
        expect(pressed, isTrue);
        expect(find.text('Changes saved'), findsNothing);
      },
    );
  });
}
