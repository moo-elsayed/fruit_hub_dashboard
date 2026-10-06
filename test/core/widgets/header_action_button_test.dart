import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/widgets/header_action_button.dart';

import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('HeaderActionButton Widget Tests', () {
    testWidgets('should render label and icon, and trigger onTap when tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      var tapped = false;
      await tester.pumpWidget(
        createWidgetForTesting(
          child: HeaderActionButton(
            label: 'Add Fruit',
            icon: Icons.add_rounded,
            onTap: () => tapped = true,
          ),
        ),
      );

      // Assert
      expect(find.text('Add Fruit'), findsOneWidget);
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);

      // Act
      await tester.tap(find.byType(HeaderActionButton));
      await tester.pump();

      // Assert callback
      expect(tapped, isTrue);
    });
  });
}
