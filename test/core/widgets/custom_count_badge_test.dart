import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_count_badge.dart';

import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('CustomCountBadge Widget Tests', () {
    testWidgets('should render numeric count text', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(child: const CustomCountBadge(count: 5)),
      );

      // Assert
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('should render string text when provided', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(child: const CustomCountBadge(text: 'New')),
      );

      // Assert
      expect(find.text('New'), findsOneWidget);
    });

    testWidgets('should render quantity prefix with quantity constructor', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const CustomCountBadge.quantity(quantity: 3),
        ),
      );

      // Assert
      expect(find.text('x3'), findsOneWidget);
    });

    testWidgets('should render circle shape when isCircle is true', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const CustomCountBadge(count: 2, isCircle: true),
        ),
      );

      // Assert
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.shape, equals(BoxShape.circle));
      expect(decoration?.borderRadius, isNull);
    });

    testWidgets('should apply custom colors and padding', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const CustomCountBadge(
            text: 'VIP',
            textColor: Colors.white,
            backgroundColor: Colors.purple,
            padding: EdgeInsets.all(12),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.color, equals(Colors.purple));
      expect(container.padding, equals(const EdgeInsets.all(12)));

      final text = tester.widget<Text>(find.text('VIP'));
      expect(text.style?.color, equals(Colors.white));
    });
  });
}
