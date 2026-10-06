import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/orders_status_view.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('OrdersStatusView Widget Tests', () {
    testWidgets('should render icon and message correctly', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const OrdersStatusView(
            message: 'No orders available',
            icon: Icons.inbox_outlined,
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
      expect(find.text('No orders available'), findsOneWidget);
    });

    testWidgets('should apply custom color when provided', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      const customColor = Colors.purple;
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const OrdersStatusView(
            message: 'Custom error',
            icon: Icons.error_outline,
            color: customColor,
          ),
        ),
      );

      // Assert
      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.error_outline));
      expect(iconWidget.color, customColor);

      final textWidget = tester.widget<Text>(find.text('Custom error'));
      expect(textWidget.style?.color, customColor);
    });
  });
}
