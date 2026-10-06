import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/order_header_badge.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('OrderHeaderBadge Widget Tests', () {
    testWidgets('should render label and color correctly', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const OrderHeaderBadge(label: 'Pending', color: Colors.orange),
        ),
      );

      // Assert
      expect(find.text('Pending'), findsOneWidget);
    });

    testWidgets('should render dot indicator when showDot is true', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const OrderHeaderBadge(
            label: 'Delivered',
            color: Colors.green,
            showDot: true,
          ),
        ),
      );

      // Assert
      expect(find.text('Delivered'), findsOneWidget);
      // Dot is a Container with BoxShape.circle
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Container &&
              w.decoration is BoxDecoration &&
              (w.decoration as BoxDecoration).shape == BoxShape.circle,
        ),
        findsOneWidget,
      );
    });

    testWidgets('should render leading icon and trailing icon when provided', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const OrderHeaderBadge(
            label: 'Action',
            color: Colors.blue,
            icon: Icons.info_outline,
            trailingIcon: Icons.arrow_forward_ios,
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
      expect(find.text('Action'), findsOneWidget);
    });

    testWidgets('should trigger onTap callback when clicked', (
      WidgetTester tester,
    ) async {
      // Arrange
      bool tapped = false;
      await tester.pumpWidget(
        createWidgetForTesting(
          child: OrderHeaderBadge(
            label: 'Clickable',
            color: Colors.red,
            onTap: () => tapped = true,
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(OrderHeaderBadge));
      await tester.pump();

      // Assert
      expect(tapped, isTrue);
    });
  });
}
