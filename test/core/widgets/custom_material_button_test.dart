import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_material_button.dart';

import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('CustomMaterialButton Widget Tests', () {
    testWidgets('should render text and trigger onPressed when tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      var pressed = false;
      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomMaterialButton(
            text: 'Submit',
            onPressed: () => pressed = true,
          ),
        ),
      );

      // Assert initial
      expect(find.text('Submit'), findsOneWidget);
      expect(find.byType(CupertinoActivityIndicator), findsNothing);

      // Act
      await tester.tap(find.byType(CustomMaterialButton));
      await tester.pump();

      // Assert callback
      expect(pressed, isTrue);
    });

    testWidgets(
      'should show CupertinoActivityIndicator and not call onPressed when isLoading is true',
      (WidgetTester tester) async {
        // Arrange
        var pressed = false;
        await tester.pumpWidget(
          createWidgetForTesting(
            child: CustomMaterialButton(
              text: 'Save',
              isLoading: true,
              onPressed: () => pressed = true,
            ),
          ),
        );

        // Assert indicator is displayed
        expect(find.byType(CupertinoActivityIndicator), findsOneWidget);

        // Act
        await tester.tap(find.byType(CustomMaterialButton));
        await tester.pump();

        // Assert onPressed was not triggered
        expect(pressed, isFalse);
      },
    );

    testWidgets('should render icon with leading and trailing positioning', (
      WidgetTester tester,
    ) async {
      // Leading icon
      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomMaterialButton(
            text: 'Add',
            icon: const Icon(Icons.add),
            isTrailingIcon: false,
            onPressed: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);

      // Trailing icon
      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomMaterialButton(
            text: 'Next',
            icon: const Icon(Icons.arrow_forward),
            isTrailingIcon: true,
            onPressed: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
    });

    testWidgets('should apply custom styling and maxWidth', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomMaterialButton(
            text: 'Custom',
            maxWidth: true,
            backgroundColor: Colors.teal,
            textColor: Colors.amber,
            onPressed: () {},
          ),
        ),
      );

      final materialButton = tester.widget<MaterialButton>(
        find.byType(MaterialButton),
      );
      expect(materialButton.minWidth, equals(double.infinity));
      expect(materialButton.color, equals(Colors.teal));
    });
  });
}
