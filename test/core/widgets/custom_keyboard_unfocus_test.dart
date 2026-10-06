import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_keyboard_unfocus.dart';

import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('CustomKeyboardUnfocus Widget Tests', () {
    testWidgets('should unfocus active focus node when tapping outside', (
      WidgetTester tester,
    ) async {
      // Arrange
      final focusNode = FocusNode();
      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomKeyboardUnfocus(
            child: Column(
              children: [
                TextField(focusNode: focusNode),
                const ColoredBox(
                  key: Key('outside_area'),
                  color: Colors.transparent,
                  child: SizedBox(height: 100, width: 100),
                ),
              ],
            ),
          ),
        ),
      );

      // Act 1: Focus the text field
      focusNode.requestFocus();
      await tester.pump();
      expect(focusNode.hasFocus, isTrue);

      // Act 2: Tap outside on the CustomKeyboardUnfocus wrapper
      await tester.tap(find.byKey(const Key('outside_area')));
      await tester.pump();

      // Assert
      expect(focusNode.hasFocus, isFalse);
    });
  });
}
