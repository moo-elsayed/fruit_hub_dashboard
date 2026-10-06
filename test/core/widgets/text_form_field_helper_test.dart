import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/widgets/text_form_field_helper.dart';

import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('TextFormFieldHelper Widget Tests', () {
    testWidgets('should render hint, label, and update text on input', (
      WidgetTester tester,
    ) async {
      // Arrange
      final controller = TextEditingController();
      String? changedValue;

      await tester.pumpWidget(
        createWidgetForTesting(
          child: TextFormFieldHelper(
            controller: controller,
            hint: 'Enter fruit name',
            labelText: 'Fruit Name',
            onChanged: (val) => changedValue = val,
          ),
        ),
      );

      // Assert initial
      expect(find.text('Enter fruit name'), findsOneWidget);
      expect(find.text('Fruit Name'), findsOneWidget);

      // Act
      await tester.enterText(find.byType(TextFormField), 'Banana');
      await tester.pump();

      // Assert
      expect(controller.text, equals('Banana'));
      expect(changedValue, equals('Banana'));
    });

    testWidgets(
      'should toggle obscureText when password visibility icon is tapped',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const TextFormFieldHelper(
              isPassword: true,
              hint: 'Password',
            ),
          ),
        );

        // Initial state: obscured -> visibility_outlined icon is shown
        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.obscureText, isTrue);

        // Act: Tap visibility toggle
        await tester.tap(find.byIcon(Icons.visibility_outlined));
        await tester.pumpAndSettle();

        // Assert: revealed -> visibility_off_outlined icon is shown
        expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
        final updatedTextField = tester.widget<TextField>(
          find.byType(TextField),
        );
        expect(updatedTextField.obscureText, isFalse);
      },
    );

    testWidgets(
      'should show validation error when onValidate returns error string',
      (WidgetTester tester) async {
        // Arrange
        final formKey = GlobalKey<FormState>();
        await tester.pumpWidget(
          createWidgetForTesting(
            child: Form(
              key: formKey,
              child: TextFormFieldHelper(
                onValidate: (val) =>
                    val == null || val.isEmpty ? 'Value is required' : null,
              ),
            ),
          ),
        );

        // Act: Trigger validation
        formKey.currentState!.validate();
        await tester.pumpAndSettle();

        // Assert error displayed
        expect(find.text('Value is required'), findsOneWidget);
      },
    );

    testWidgets(
      'should adjust text direction to RTL when Arabic text is entered',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const TextFormFieldHelper(hint: 'Type here'),
          ),
        );

        // Act: Enter Arabic text
        await tester.enterText(find.byType(TextFormField), 'تفاح');
        await tester.pump();

        // Assert
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.textDirection, equals(TextDirection.rtl));
      },
    );
  });
}
